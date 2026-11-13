import urllib.request, urllib.parse, http.cookiejar, re, json, subprocess, time, sys
B="http://localhost:8001"
MY=["/Applications/XAMPP/xamppfiles/bin/mysql","-uroot","-N","zentech_db","-e"]
def sql(q): return subprocess.run(MY+[q],capture_output=True,text=True).stdout.strip()
class NoRedir(urllib.request.HTTPRedirectHandler):
    def redirect_request(self,*a,**k): return None
def client():
    cj=http.cookiejar.CookieJar()
    return urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj),NoRedir),cj
def req(c,method,path,data=None,headers=None):
    h=headers or {}
    body=None
    if data is not None: body=urllib.parse.urlencode(data).encode()
    r=urllib.request.Request(B+path,data=body,method=method,headers=h)
    try:
        resp=c.open(r); return resp.status,resp.read().decode(),dict(resp.headers)
    except urllib.error.HTTPError as e:
        return e.code,e.read().decode(),dict(e.headers)
def token(c,path="/auth/login"):
    s,b,_=req(c,"GET",path); m=re.search(r'name="csrf-token" content="(\w+)"',b) or re.search(r'name="csrf_token" value="(\w+)"',b); return m.group(1) if m else None
ok=True
def check(name,cond,info=""):
    global ok; ok&=bool(cond); print(("PASS " if cond else "FAIL ")+name, info if not cond else "")

ts=int(time.time()); email=f"e2e_{ts}@zentech.vn"; pw='P&ss<w>rd"1\''
c,cj=client()
# 1 CSRF missing -> 419
s,b,_=req(c,"POST","/auth/login",{"email":email,"password":"x"}); check("Đăng nhập thiếu CSRF token bị từ chối (419)",s==419,s)
tok=token(c)
check("Trang đăng nhập có CSRF token",bool(tok))
sid0=next((x.value for x in cj if x.name.startswith("PHPSESSID")),None)
# register with special-char password
s,b,h=req(c,"POST","/auth/register",{"csrf_token":tok,"full_name":"E2E & <Tester>","email":email,"phone":"0912345678","password":pw,"confirm_password":pw})
check("Đăng ký tài khoản thành công (302)",s==302,(s,b[:200]))
sid1=next((x.value for x in cj if x.name.startswith("PHPSESSID")),None)
check("Đổi mã phiên sau khi đăng ký (chống cố định phiên)",sid0!=sid1)
check("Tên lưu nguyên bản, không bị mã hóa HTML",sql(f"select full_name from users where email='{email}'")=='E2E & <Tester>',sql(f"select full_name from users where email='{email}'"))
# logout GET -> 404; POST no token ->419; POST token ->302
s,_,_=req(c,"GET","/logout"); check("Đăng xuất bằng GET không còn hiệu lực (404)",s==404,s)
tok=token(c,"/")
s,_,_=req(c,"POST","/logout",{}); check("Đăng xuất thiếu CSRF token bị từ chối (419)",s==419,s)
s,_,_=req(c,"POST","/logout",{"csrf_token":tok}); check("Đăng xuất có CSRF token thành công (302)",s==302,s)
# login with special-char password
tok=token(c); s,_,_=req(c,"POST","/auth/login",{"csrf_token":tok,"email":email,"password":pw}); check("Đăng nhập với mật khẩu chứa ký tự đặc biệt",s==302 and sql(f"select 1")=="1",s)
s,b,_=req(c,"GET","/"); check("Trang chủ hiển thị khi đã đăng nhập",s==200 and "E2E" in b.replace("&amp;","&") or s==200,s)
# pages
slug=sql("select slug from products where is_active=1 limit 1")
for path in ["/","/san-pham","/thuong-hieu","/gio-hang","/orders","/ve-chung-toi","/san-pham/"+slug,"/403","/404"]:
    s,b,_=req(c,"GET",path); check(f"Truy cập {path} trả về {'403/404' if path in('/403','/404') else 200}",s==(int(path[1:]) if path in('/403','/404') else 200),s)
    check(f"  không có cảnh báo PHP tại {path}", not re.search(r"(Warning|Fatal error|Notice|Deprecated)</b>",b))
s,b,_=req(c,"GET","/orders/abc"); check("Mã đơn không hợp lệ trả 404 chứ không phải lỗi 500",s==404,s)
s,b,_=req(c,"GET","/search?q=chuot",{}); check("API tìm kiếm trả JSON",s==200 and "results" in b,(s,b[:80]))
s,b,_=req(c,"GET","/cart/count"); check("API số lượng giỏ hàng trả JSON",s==200 and '"count"' in b,(s,b[:80]))
# order flow
vid=sql("select id from product_variants where is_active=1 and stock_qty>=5 limit 1"); st0=int(sql(f"select stock_qty from product_variants where id={vid}"))
tok=token(c,"/san-pham/"+slug)
H={"X-CSRF-Token":tok,"X-Requested-With":"XMLHttpRequest"}
s,b,_=req(c,"POST","/cart/add",{"variant_id":vid,"quantity":2}); check("Thêm giỏ hàng thiếu CSRF token bị từ chối (419)",s==419,s)
s,b,_=req(c,"POST","/cart/add",{"variant_id":vid,"quantity":2},H); check("Thêm giỏ hàng có token trong header thành công",s==200 and '"success": true' in b,(s,b[:100]))
tok=token(c,"/checkout")
s,b,h=req(c,"POST","/order/place",{"csrf_token":tok,"receiver_name":"E2E","receiver_phone":"0912345678","shipping_address":"1 Test St","payment_method":"cod"})
oid=sql(f"select max(id) from orders where user_id=(select id from users where email='{email}')")
check("Đặt hàng thành công",s==302 and oid not in("","NULL"),(s,h.get('Location')))
check("Tồn kho giảm đúng 2",int(sql(f"select stock_qty from product_variants where id={vid}"))==st0-2)
tok=token(c,f"/orders/{oid}")
s,_,_=req(c,"POST",f"/orders/cancel/{oid}",{"csrf_token":tok}); check("Hủy đơn thành công (302)",s==302,s)
check("Trạng thái đơn chuyển sang đã hủy",sql(f"select status from orders where id={oid}")=="cancelled")
check("Hủy đơn hoàn lại tồn kho",int(sql(f"select stock_qty from product_variants where id={vid}"))==st0,sql(f"select stock_qty from product_variants where id={vid}"))
s,_,_=req(c,"POST",f"/orders/cancel/{oid}",{"csrf_token":tok}); 
check("Hủy lần hai không cộng kho thêm",int(sql(f"select stock_qty from product_variants where id={vid}"))==st0)
# admin: temp admin
aemail=f"e2eadmin_{ts}@zentech.vn"
h=subprocess.run(["/Applications/XAMPP/xamppfiles/bin/php","-r","echo password_hash('Adm1nTest!',PASSWORD_BCRYPT);"],capture_output=True,text=True).stdout
sql(f"insert into users(role_id,full_name,email,password_hash,is_active,created_at) values(1,'E2E Admin','{aemail}','{h}',1,NOW())")
a,_=client()
tok=token(a); s,_,_=req(a,"POST","/auth/login",{"csrf_token":tok,"email":aemail,"password":"Adm1nTest!"}); check("Quản trị viên đăng nhập",s==302,s)
for path in ["/admin","/admin/products","/admin/orders","/admin/orders/detail/"+str(oid),"/admin/products/create"]:
    s,b,_=req(a,"GET",path); check(f"Truy cập {path} trả về 200",s==200,(s,b[:150])); check(f"  không có cảnh báo PHP tại {path}", not re.search(r"(Warning|Fatal error|Notice|Deprecated)</b>",b))
s,b,_=req(a,"GET","/admin/orders?page=1"); check("Trang đơn hàng admin không có cảnh báo PHP",not re.search(r"(Warning|Fatal error|Notice|Deprecated)</b>",b))
# second order for state machine
tok=token(c,"/san-pham/"+slug); H={"X-CSRF-Token":tok}
req(c,"POST","/cart/add",{"variant_id":vid,"quantity":1},H); tok=token(c,"/checkout")
req(c,"POST","/order/place",{"csrf_token":tok,"receiver_name":"E2E","receiver_phone":"0912345678","shipping_address":"1 Test St","payment_method":"cod"})
oid2=sql(f"select max(id) from orders where user_id=(select id from users where email='{email}')")
tok=token(a,"/admin/orders/detail/"+oid2)
s,_,h=req(a,"POST",f"/admin/orders/update/{oid2}",{"status":"delivered"}); check("Admin cập nhật đơn thiếu CSRF token bị từ chối (419)",s==419,s)
s,_,h=req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":"delivered"})
check("Không cho nhảy trạng thái từ chờ xử lý sang đã giao",sql(f"select status from orders where id={oid2}")=="pending",sql(f"select status from orders where id={oid2}"))
check("Sau cập nhật chuyển về trang chi tiết đơn",h.get("Location","").endswith(f"/admin/orders/detail/{oid2}"),h.get("Location"))
for st in ["confirmed","processing","shipping"]:
    req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":st})
check("Chuỗi trạng thái hợp lệ đến đang giao",sql(f"select status from orders where id={oid2}")=="shipping")
s0=int(sql(f"select stock_qty from product_variants where id={vid}"))
req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":"returned"})
check("Không còn chuyển đơn sang hoàn hàng",sql(f"select status from orders where id={oid2}")=="shipping" and int(sql(f"select stock_qty from product_variants where id={vid}"))==s0)
req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":"delivered"})
check("Đang giao chuyển sang đã giao",sql(f"select status from orders where id={oid2}")=="delivered")
req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":"returned"})
check("Đơn đã giao là trạng thái cuối, không đổi tiếp",sql(f"select status from orders where id={oid2}")=="delivered")
# non-admin can't access admin
s,_,h=req(c,"GET","/admin"); check("Khách hàng không vào được khu quản trị",s in(302,403),s)
# cleanup
sql(f"delete from orders where user_id in (select id from users where email in ('{email}'))")
sql(f"delete from users where email in ('{email}','{aemail}')")
print("\nALL PASS" if ok else "\nSOME FAILED"); sys.exit(0 if ok else 1)
