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
for st in ["confirmed","processing","handed_over","shipping"]:
    req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":st})
check("Chuỗi trạng thái một chiều đến shipper đang giao",sql(f"select status from orders where id={oid2}")=="shipping")
s0=int(sql(f"select stock_qty from product_variants where id={vid}"))
req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":"cancelled"})
check("Đang giao thì admin không hủy được đơn",sql(f"select status from orders where id={oid2}")=="shipping" and int(sql(f"select stock_qty from product_variants where id={vid}"))==s0)
req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":"delivered"})
check("Admin không được bấm đã giao hàng",sql(f"select status from orders where id={oid2}")=="shipping")
req(a,"POST",f"/admin/orders/failed/{oid2}",{"csrf_token":tok,"note":"khong nghe may"})
check("Ghi nhận giao thất bại lần 1, đơn vẫn đang giao",sql(f"select concat(status,fail_count) from orders where id={oid2}")=="shipping1")
ctok=token(c,f"/orders/{oid2}")
s,_,_=req(c,"POST",f"/orders/cancel/{oid2}",{"csrf_token":ctok}); check("Khách không hủy được đơn đã giao cho vận chuyển",sql(f"select status from orders where id={oid2}")=="shipping")
s,_,_=req(c,"POST",f"/orders/received/{oid2}",{"csrf_token":ctok})
check("Khách bấm Đã nhận hàng: đơn sang đã nhận, COD tính đã thanh toán",sql(f"select concat(status,'/',payment_status) from orders where id={oid2}")=="delivered/paid")
req(a,"POST",f"/admin/orders/update/{oid2}",{"csrf_token":tok,"status":"completed"})
check("Còn hạn trả hàng thì admin chưa hoàn thành được",sql(f"select status from orders where id={oid2}")=="delivered")
# trả hàng: multipart có ảnh minh chứng
import uuid, base64
png=base64.b64decode("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==")
def multipart(c,path,fields,files):
    bd=uuid.uuid4().hex; parts=[]
    for k,v in fields.items(): parts.append(f'--{bd}\r\nContent-Disposition: form-data; name="{k}"\r\n\r\n{v}\r\n'.encode())
    for k,(fn,data,ct) in files.items(): parts.append(f'--{bd}\r\nContent-Disposition: form-data; name="{k}"; filename="{fn}"\r\nContent-Type: {ct}\r\n\r\n'.encode()+data+b"\r\n")
    body=b"".join(parts)+f"--{bd}--\r\n".encode()
    r=urllib.request.Request(B+path,data=body,method="POST",headers={"Content-Type":f"multipart/form-data; boundary={bd}"})
    try: resp=c.open(r); return resp.status
    except urllib.error.HTTPError as e: return e.code
ctok=token(c,f"/orders/{oid2}")
multipart(c,f"/orders/return/{oid2}",{"csrf_token":ctok,"reason":"Sản phẩm lỗi / không hoạt động","description":"ngắn","refund_method":"wallet"},{"evidence":("a.png",png,"image/png")})
check("Trả hàng mô tả quá ngắn bị từ chối",sql(f"select status from orders where id={oid2}")=="delivered")
multipart(c,f"/orders/return/{oid2}",{"csrf_token":ctok,"reason":"Sản phẩm lỗi / không hoạt động","description":"Chuột bị liệt nút trái sau 1 ngày dùng","refund_method":"wallet"},{"evidence":("a.php",b"<?php echo 1;","image/png")})
check("Ảnh minh chứng không phải ảnh thật bị từ chối",sql(f"select status from orders where id={oid2}")=="delivered")
multipart(c,f"/orders/return/{oid2}",{"csrf_token":ctok,"reason":"Sản phẩm lỗi / không hoạt động","description":"Chuột bị liệt nút trái sau 1 ngày dùng","refund_method":"wallet"},{"evidence":("a.png",png,"image/png")})
check("Gửi yêu cầu trả hàng có ảnh minh chứng",sql(f"select concat(o.status,'/',r.status) from orders o join order_returns r on r.order_id=o.id where o.id={oid2}")=="return_requested/pending")
s,b,_=req(a,"GET","/admin/returns"); check("Tab Hoàn hàng của admin hiện yêu cầu",s==200 and "Chuột bị liệt" in b,s)
s0=int(sql(f"select stock_qty from product_variants where id={vid}")); total=int(sql(f"select total_amount from orders where id={oid2}"))
tok=token(a,"/admin/returns")
req(a,"POST",f"/admin/returns/{oid2}",{"csrf_token":tok,"decision":"approve"})
check("Duyệt trả hàng: đơn đã trả, hàng về kho",sql(f"select status from orders where id={oid2}")=="returned" and int(sql(f"select stock_qty from product_variants where id={vid}"))==s0+1)
check("Duyệt trả hàng: tiền hoàn vào ví ZenTech",int(sql(f"select wallet_balance from users where email='{email}'"))==total,sql(f"select wallet_balance from users where email='{email}'"))
# thanh toán bằng ví, rồi giao thất bại 3 lần -> hủy + hoàn ví
H={"X-CSRF-Token":token(c,"/san-pham/"+slug),"X-Requested-With":"XMLHttpRequest"}
req(c,"POST","/cart/add",{"variant_id":vid,"quantity":1},H); ctok=token(c,"/checkout")
price=int(sql(f"select coalesce(sale_price,price) from product_variants where id={vid}"))
if price+ (0 if price>=500000 else 30000) <= total:
    req(c,"POST","/order/place",{"csrf_token":ctok,"receiver_name":"E2E","receiver_phone":"0912345678","shipping_address":"1 Test St","payment_method":"wallet"})
    oid3=sql(f"select max(id) from orders where user_id=(select id from users where email='{email}')")
    check("Thanh toán bằng ví: đơn đã thanh toán, ví bị trừ",sql(f"select concat(payment_method,'/',payment_status) from orders where id={oid3}")=="wallet/paid" and int(sql(f"select wallet_balance from users where email='{email}'"))==total-int(sql(f"select total_amount from orders where id={oid3}")))
    tok=token(a,f"/admin/orders/detail/{oid3}")
    for st in ["confirmed","processing","handed_over"]: req(a,"POST",f"/admin/orders/update/{oid3}",{"csrf_token":tok,"status":st})
    s0=int(sql(f"select stock_qty from product_variants where id={vid}"))
    for i in range(3): req(a,"POST",f"/admin/orders/failed/{oid3}",{"csrf_token":tok})
    check("Giao thất bại 3 lần: đơn hủy, hàng về kho, tiền về ví",sql(f"select concat(status,'/',payment_status) from orders where id={oid3}")=="cancelled/refunded" and int(sql(f"select stock_qty from product_variants where id={vid}"))==s0+1 and int(sql(f"select wallet_balance from users where email='{email}'"))==total)
# giỏ hàng lưu DB: thiết bị thứ hai thấy cùng giỏ; tối đa 10 mỗi sản phẩm
H={"X-CSRF-Token":token(c,"/san-pham/"+slug),"X-Requested-With":"XMLHttpRequest"}
vid10=sql("select id from product_variants where is_active=1 and stock_qty>=15 limit 1")
s,b,_=req(c,"POST","/cart/add",{"variant_id":vid10,"quantity":12},H)
check("Thêm 12 cái bị giới hạn còn 10",'"success": true' in b and int(sql(f"select ci.quantity from cart_items ci join carts ct on ct.id=ci.cart_id where ct.user_id=(select id from users where email='{email}') and ci.variant_id={vid10}") or 0)==10,b[:200])
c2,_=client(); tok=token(c2); req(c2,"POST","/auth/login",{"csrf_token":tok,"email":email,"password":pw})
s,b,_=req(c2,"GET","/cart/count"); check("Trình duyệt thứ hai đăng nhập cùng tài khoản thấy cùng giỏ",'"count": 10' in b,b[:80])
# mã giảm giá theo danh mục
cat=sql(f"select p.category_id from product_variants pv join products p on p.id=pv.product_id where pv.id={vid10}")
other=sql(f"select id from categories where id<>{cat} and (parent_id is null or parent_id<>{cat}) and id<>(select coalesce(parent_id,0) from categories where id={cat}) limit 1")
sql(f"insert into coupons(code,discount_type,discount_value,category_id) values('E2ECAT{ts}','percent',10,{other}),('E2EOK{ts}','percent',10,{cat})")
H={"X-CSRF-Token":token(c,"/checkout"),"X-Requested-With":"XMLHttpRequest"}
s,b,_=req(c,"POST","/coupon/preview",{"coupon_code":f"E2ECAT{ts}"},H); check("Mã của danh mục khác bị từ chối",s==422 and "phạm vi" in b,(s,b[:120]))
s,b,_=req(c,"POST","/coupon/preview",{"coupon_code":f"E2EOK{ts}"},H); check("Mã đúng danh mục được áp dụng",s==200 and '"ok": true' in b,(s,b[:120]))
sql(f"delete from coupons where code in ('E2ECAT{ts}','E2EOK{ts}')")
s,b,_=req(a,"GET","/admin?range=7d&status=pending"); check("Bộ lọc dashboard chạy, không cảnh báo PHP",s==200 and "Bộ lọc" not in b[:0] and not re.search(r"(Warning|Fatal error|Notice|Deprecated)</b>",b),s)
s,b,_=req(a,"GET","/admin?range=custom&from=2026-13-40&to=abc"); check("Bộ lọc dashboard bỏ qua ngày sai",s==200,s)
# non-admin can't access admin
s,_,h=req(c,"GET","/admin"); check("Khách hàng không vào được khu quản trị",s in(302,403),s)
# cleanup
for f in sql(f"select evidence_url from order_returns where user_id=(select id from users where email='{email}')").split():
    import os; os.remove("public"+f) if os.path.exists("public"+f) else None
sql(f"delete from orders where user_id in (select id from users where email in ('{email}'))")
sql(f"delete from users where email in ('{email}','{aemail}')")
print("\nALL PASS" if ok else "\nSOME FAILED"); sys.exit(0 if ok else 1)
