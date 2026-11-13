#!/usr/bin/env python3
"""Kiểm thử luồng nghiệp vụ (đăng ký, đặt hàng, hủy đơn, lọc nhiều giá trị, admin...). Cần server ở localhost:8001."""
import urllib.request, urllib.parse, http.cookiejar, re, subprocess, time, sys, json
B = "http://localhost:8001"
MY = ["/Applications/XAMPP/xamppfiles/bin/mysql", "-uroot", "-N", "zentech_db", "-e"]
PHP = "/Applications/XAMPP/xamppfiles/bin/php"
results = []

def sql(q): return subprocess.run(MY + [q], capture_output=True, text=True).stdout.strip()
class NoR(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, *a, **k): return None
def cli(): return urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()), NoR)
def req(c, m, p, d=None, h=None):
    r = urllib.request.Request(B + p, data=urllib.parse.urlencode(d).encode() if d is not None else None, method=m, headers=h or {})
    try: x = c.open(r); return x.status, x.read().decode(), dict(x.headers)
    except urllib.error.HTTPError as e: return e.code, e.read().decode(), dict(e.headers)
def follow(c, m, p, d=None, h=None):
    s, b, hd = req(c, m, p, d, h)
    while s in (301, 302, 303): s, b, hd = req(c, "GET", hd["Location"].replace(B, ""))
    return s, b
def tok(c, p="/auth/login"):
    s, b, _ = req(c, "GET", p)
    m = re.search(r'name="csrf-token" content="(\w+)"', b) or re.search(r'name="csrf_token" value="(\w+)"', b)
    return m.group(1)
def check(area, name, cond): results.append((area, name, bool(cond))); print(("PASS " if cond else "FAIL ") + f"[{area}] {name}")
def cards(path): return len(re.findall(r"<article", req(cli(), "GET", path)[1]))

ts = int(time.time()); em = f"flow_{ts}@zentech.vn"; ae = f"fa_{ts}@zentech.vn"
c = cli()
# --- Đăng ký / đăng nhập
t = tok(c); s, b = follow(c, "POST", "/auth/register", {"csrf_token": t, "full_name": "Flow Keep", "email": "abc", "password": "123", "confirm_password": "9", "phone": "0911111111"})
check("Đăng ký", "Báo lỗi dữ liệu sai (email, mật khẩu ngắn, xác nhận lệch)", "Email không hợp lệ" in b and "8 ký tự" in b)
check("Đăng ký", "Giữ lại tên và số điện thoại đã nhập sau khi báo lỗi", 'value="Flow Keep"' in b and 'value="0911111111"' in b)
t = tok(c); s, b = follow(c, "POST", "/auth/login", {"csrf_token": t, "email": "nope@x.vn", "password": "wrongpass"})
check("Đăng nhập", "Sai thông tin: báo lỗi chung, không lộ email có tồn tại hay không", "Email hoặc mật khẩu không chính xác" in b)
t = tok(c); s, b = follow(c, "POST", "/auth/register", {"csrf_token": t, "full_name": "Flow Test", "email": em, "password": "FlowTest#1", "confirm_password": "FlowTest#1", "phone": "0912345678"})
check("Đăng ký", "Đăng ký thành công và có thông báo", "thành công" in b)
# --- Giỏ hàng, thanh toán
vid = sql("select id from product_variants where is_active=1 and stock_qty>=5 and id>41 limit 1")
stock0 = int(sql(f"select stock_qty from product_variants where id={vid}"))
H = {"X-CSRF-Token": tok(c, "/"), "X-Requested-With": "XMLHttpRequest"}
s, b, _ = req(c, "POST", "/cart/add", {"variant_id": vid, "quantity": 2}, H)
check("Giỏ hàng", "Thêm vào giỏ (AJAX) trả về số lượng", s == 200 and '"count": 2' in b)
t = tok(c, "/checkout"); s, b = follow(c, "POST", "/order/place", {"csrf_token": t, "receiver_name": "", "receiver_phone": "12", "shipping_address": "1 Keep Street", "payment_method": "cod"})
check("Thanh toán", "Báo lỗi tên, số điện thoại không hợp lệ", "Vui lòng nhập tên người nhận" in b and "Số điện thoại không hợp lệ" in b)
check("Thanh toán", "Giữ lại địa chỉ đã nhập sau khi báo lỗi", 'value="1 Keep Street"' in b)
t = tok(c, "/checkout"); s, b = follow(c, "POST", "/order/place", {"csrf_token": t, "receiver_name": "Flow", "receiver_phone": "0912345678", "shipping_address": "1 Test", "payment_method": "cod"})
oid = sql(f"select max(id) from orders where user_id=(select id from users where email='{em}')")
check("Thanh toán", "Đặt hàng thành công, hiện thông báo", "Đặt hàng thành công" in b and oid not in ("", "NULL"))
check("Thanh toán", "Trừ tồn kho đúng số lượng đặt", int(sql(f"select stock_qty from product_variants where id={vid}")) == stock0 - 2)
t = tok(c, f"/orders/{oid}"); s, b = follow(c, "POST", f"/orders/cancel/{oid}", {"csrf_token": t})
check("Đơn hàng", "Hủy đơn đang chờ: đổi trạng thái và có thông báo", sql(f"select status from orders where id={oid}") == "cancelled" and "hủy thành công" in b)
# --- Mã giảm giá
cp = '["is_active"=>1,"starts_at"=>null,"expires_at"=>null,"max_uses"=>null,"used_count"=>0,"min_order_value"=>500000]'
php = ('class BaseModel{} require "app/models/OrderModel.php";'
       f'$p=array_merge({cp},["discount_type"=>"percent","discount_value"=>10]);$f=array_merge({cp},["discount_type"=>"fixed","discount_value"=>200000]);'
       'echo json_encode([OrderModel::couponDiscount($p,1000000),OrderModel::couponDiscount($f,1000000),OrderModel::couponDiscount($p,400000)[1]!==null,'
       'OrderModel::couponDiscount(array_merge($f,["discount_value"=>900000,"min_order_value"=>0]),500000)[0],'
       'OrderModel::couponDiscount(array_merge($p,["expires_at"=>"2000-01-01 00:00:00"]),1000000)[1]!==null,'
       'OrderModel::couponDiscount(array_merge($p,["max_uses"=>5,"used_count"=>5]),1000000)[1]!==null,OrderModel::couponDiscount(null,1000000)[1]!==null]);')
out = subprocess.run([PHP, "-r", php], capture_output=True, text=True, cwd=__file__.rsplit("/scratch", 1)[0]).stdout
check("Mã giảm giá", "Tính đúng: 10% của 1 triệu, giảm cố định, dưới mức tối thiểu bị từ chối", out == '[[100000,null],[200000,null],true,500000,true,true,true]')
vid2 = sql("select id from product_variants where is_active=1 and stock_qty>=5 and price>=300000 and sale_price is null limit 1")
H = {"X-CSRF-Token": tok(c, "/"), "X-Requested-With": "XMLHttpRequest"}
req(c, "POST", "/cart/add", {"variant_id": vid2, "quantity": 2}, H)
sub = int(sql(f"select price*2 from product_variants where id={vid2}"))
used0 = int(sql("select used_count from coupons where code='ZENTECH10'"))
n0 = sql(f"select count(*) from orders where user_id=(select id from users where email='{em}')")
t = tok(c, "/checkout"); s, b = follow(c, "POST", "/order/place", {"csrf_token": t, "receiver_name": "Flow", "receiver_phone": "0912345678", "shipping_address": "1 Test", "payment_method": "cod", "coupon_code": "SAIMA"})
check("Mã giảm giá", "Mã sai: báo lỗi, không tạo đơn, giữ giỏ hàng", "không tồn tại" in b and sql(f"select count(*) from orders where user_id=(select id from users where email='{em}')") == n0)
t = tok(c, "/checkout"); s, b = follow(c, "POST", "/order/place", {"csrf_token": t, "receiver_name": "Flow", "receiver_phone": "0912345678", "shipping_address": "1 Test", "payment_method": "cod", "coupon_code": "zentech10"})
oid2 = sql(f"select max(id) from orders where user_id=(select id from users where email='{em}')")
disc = sub // 10
check("Mã giảm giá", "Dùng ZENTECH10: lưu đúng số tiền giảm, tổng = tạm tính + ship - giảm", sql(f"select discount_amount from orders where id={oid2}") == str(disc) and sql(f"select total_amount from orders where id={oid2}") == str(sub - disc))
check("Mã giảm giá", "Tăng số lượt đã dùng của mã", int(sql("select used_count from coupons where code='ZENTECH10'")) == used0 + 1)
check("Mã giảm giá", "Trang chi tiết đơn hiện dòng mã giảm giá", "Mã giảm giá" in follow(c, "GET", f"/orders/{oid2}")[1])
t = tok(c, f"/orders/{oid2}"); follow(c, "POST", f"/orders/cancel/{oid2}", {"csrf_token": t})
check("Mã giảm giá", "Hủy đơn trả lại lượt dùng mã", int(sql("select used_count from coupons where code='ZENTECH10'")) == used0)
check("Đơn hàng", "Hủy đơn hoàn lại tồn kho", int(sql(f"select stock_qty from product_variants where id={vid}")) == stock0)
t = tok(c, f"/orders/{oid}"); follow(c, "POST", f"/orders/cancel/{oid}", {"csrf_token": t})
check("Đơn hàng", "Hủy lần hai không cộng kho thêm", int(sql(f"select stock_qty from product_variants where id={vid}")) == stock0)
t = tok(c, "/"); s, b = follow(c, "POST", "/dang-xuat", {"csrf_token": t})
check("Đăng nhập", "Đăng xuất có thông báo", "đăng xuất" in b.lower())
# --- Bộ lọc, tìm kiếm, thương hiệu
a = cards("/san-pham?brand[]=razer"); b2 = cards("/san-pham?brand[]=razer&brand[]=logitech")
check("Bộ lọc", "Chọn nhiều thương hiệu cho ra nhiều kết quả hơn một thương hiệu", b2 > a and a > 0)
check("Bộ lọc", "Chọn nhiều loại sản phẩm", cards("/san-pham?category[]=chuot-bluetooth&category[]=lot-chuot") > cards("/san-pham?category[]=chuot-bluetooth"))
check("Bộ lọc", "Liên kết cũ ?category=slug vẫn dùng được", cards("/san-pham?category=chuot-gaming") > 0)
check("Bộ lọc", "Không có kết quả: hiện trạng thái trống có nút đặt lại", "Đặt lại bộ lọc" in req(cli(), "GET", "/san-pham?brand[]=akko&price_min=90000000")[1])
check("Bộ lọc", "Tham số lạ không gây lỗi PHP", "Warning</b>" not in req(cli(), "GET", "/san-pham?brand[a][b]=1&category=")[1])
s, b, _ = req(cli(), "GET", "/search?q=razer"); check("Tìm kiếm", "API gợi ý trả về kết quả JSON", s == 200 and '"results"' in b and b.count('"slug"') > 1)
s, b, h = req(cli(), "GET", "/thuong-hieu/logitech"); check("Thương hiệu", "Trang riêng của hãng chuyển sang danh sách đã lọc", s == 302 and "brand[]=logitech" in h.get("Location", ""))
# --- Quản trị
hsh = subprocess.run([PHP, "-r", "echo password_hash('Adm1nTest!',PASSWORD_BCRYPT);"], capture_output=True, text=True).stdout
sql(f"insert into users(role_id,full_name,email,password_hash,is_active,created_at) values(1,'FA','{ae}','{hsh}',1,NOW())")
ad = cli(); t = tok(ad); follow(ad, "POST", "/auth/login", {"csrf_token": t, "email": ae, "password": "Adm1nTest!"})
t = tok(ad, "/admin/products/create")
s, b = follow(ad, "POST", "/admin/products/create", {"csrf_token": t, "name": "", "category_id": "1", "brand_id": "1"})
check("Admin", "Thêm sản phẩm thiếu tên: báo lỗi", "Vui lòng điền đầy đủ" in b)
follow(ad, "POST", "/admin/products/create", {"csrf_token": t, "name": "ZZ Flow Neg", "category_id": "6", "brand_id": "1", "variants[0][price]": "-5", "variants[0][stock_qty]": "5"})
check("Admin", "Từ chối giá bán âm", sql("select count(*) from products where name='ZZ Flow Neg'") == "0")
follow(ad, "POST", "/admin/products/create", {"csrf_token": t, "name": "ZZ Flow Sale", "category_id": "6", "brand_id": "1", "variants[0][price]": "100000", "variants[0][sale_price]": "200000", "variants[0][stock_qty]": "5"})
check("Admin", "Từ chối giá khuyến mãi lớn hơn giá gốc", sql("select count(*) from products where name='ZZ Flow Sale'") == "0")
s, b = follow(ad, "POST", "/admin/products/create", {"csrf_token": t, "name": "ZZ Flow OK", "category_id": "6", "brand_id": "1", "sku": "ZZ1", "variants[0][price]": "100000", "variants[0][sale_price]": "80000", "variants[0][stock_qty]": "5"})
pid = sql("select id from products where name='ZZ Flow OK' limit 1")
check("Admin", "Thêm sản phẩm hợp lệ thành công", "Thêm mới sản phẩm thành công" in b and pid != "")
t = tok(ad, "/admin/products"); follow(ad, "POST", f"/admin/products/delete/{pid}", {"csrf_token": t})
check("Admin", "Xóa mềm sản phẩm (is_active = 0)", sql(f"select is_active from products where id={pid}") == "0")

# --- Xem trước mã, tài khoản, đánh giá, quên mật khẩu, quản lý mã giảm giá
t = tok(c); follow(c, "POST", "/auth/login", {"csrf_token": t, "email": em, "password": "FlowTest#1"})
H = {"X-CSRF-Token": tok(c, "/"), "X-Requested-With": "XMLHttpRequest"}
req(c, "POST", "/cart/add", {"variant_id": vid2, "quantity": 2}, H)
s, b, _ = req(c, "POST", "/coupon/preview", {"coupon_code": "ZENTECH10"}, H)
check("Mã giảm giá", "Nút Áp dụng: xem trước tiền giảm và tổng", s == 200 and f'"discount":{sub // 10}' in b.replace(" ", ""))
s, b, _ = req(c, "POST", "/coupon/preview", {"coupon_code": "NOPE"}, H)
check("Mã giảm giá", "Nút Áp dụng: mã sai trả lỗi 422", s == 422 and "không tồn tại" in b)
s, b, _ = req(c, "GET", "/thanh-toan")
check("Mã giảm giá", "Trang thanh toán có nút Áp dụng", 'id="coupon-apply"' in b)
t = tok(c, "/tai-khoan"); follow(c, "POST", "/tai-khoan/thong-tin", {"csrf_token": t, "full_name": "Flow Moi", "phone": "0987654321"})
check("Tài khoản", "Cập nhật họ tên, số điện thoại", sql(f"select concat(full_name,'|',phone) from users where email='{em}'") == "Flow Moi|0987654321")
s, b = follow(c, "POST", "/tai-khoan/thong-tin", {"csrf_token": t, "full_name": "X", "phone": "abc"})
check("Tài khoản", "Từ chối thông tin sai định dạng", "Họ tên tối thiểu" in b)
s, b = follow(c, "POST", "/tai-khoan/mat-khau", {"csrf_token": t, "current_password": "saimk", "new_password": "NewPass#123", "confirm_password": "NewPass#123"})
check("Tài khoản", "Đổi mật khẩu: mật khẩu hiện tại sai bị từ chối", "không đúng" in b)
follow(c, "POST", "/tai-khoan/mat-khau", {"csrf_token": t, "current_password": "FlowTest#1", "new_password": "NewPass#123", "confirm_password": "NewPass#123"})
c2 = cli(); follow(c2, "POST", "/auth/login", {"csrf_token": tok(c2), "email": em, "password": "NewPass#123"})
check("Tài khoản", "Đổi mật khẩu thành công, đăng nhập được bằng mật khẩu mới", "Flow Moi" in req(c2, "GET", "/tai-khoan")[1])
follow(c2, "POST", "/tai-khoan/dia-chi", {"csrf_token": tok(c2, "/tai-khoan"), "receiver_name": "Flow Moi", "phone": "0987654321", "province": "Ha Noi", "district": "Cau Giay", "ward": "Dich Vong", "street": "99 Test", "is_default": "1"})
uid = sql(f"select id from users where email='{em}'")
check("Tài khoản", "Thêm địa chỉ vào sổ địa chỉ", sql(f"select count(*) from addresses where user_id={uid}") == "1")
req(c2, "POST", "/cart/add", {"variant_id": vid2, "quantity": 1}, {"X-CSRF-Token": tok(c2, "/"), "X-Requested-With": "XMLHttpRequest"})
check("Tài khoản", "Trang thanh toán cho chọn nhanh địa chỉ đã lưu", "99 Test" in req(c2, "GET", "/thanh-toan")[1])
aid = sql(f"select id from addresses where user_id={uid} limit 1")
follow(c2, "POST", f"/tai-khoan/dia-chi/xoa/{aid}", {"csrf_token": tok(c2, "/tai-khoan")})
check("Tài khoản", "Xóa địa chỉ", sql(f"select count(*) from addresses where user_id={uid}") == "0")
# Đánh giá: chỉ sau khi nhận hàng, mỗi sản phẩm một lần
ppid = sql(f"select product_id from product_variants where id={vid2}")
t = tok(c2, "/thanh-toan"); follow(c2, "POST", "/order/place", {"csrf_token": t, "receiver_name": "Flow", "receiver_phone": "0912345678", "shipping_address": "1 Test", "payment_method": "cod"})
oid3 = sql(f"select max(id) from orders where user_id={uid}")
slug3 = sql(f"select slug from products where id={ppid}")
s, b = follow(c2, "POST", "/danh-gia", {"csrf_token": tok(c2, f"/san-pham/{slug3}"), "product_id": ppid, "rating": "5", "content": "San pham rat tot"})
check("Đánh giá", "Chưa nhận hàng thì không được đánh giá", "đã nhận hàng" in b and sql(f"select count(*) from reviews where user_id={uid}") == "0")
sql(f"update orders set status='delivered' where id={oid3}")
check("Đánh giá", "Đã nhận hàng: trang sản phẩm hiện form đánh giá", 'action="/danh-gia"' in req(c2, "GET", f"/san-pham/{slug3}")[1])
s, b = follow(c2, "POST", "/danh-gia", {"csrf_token": tok(c2, f"/san-pham/{slug3}"), "product_id": ppid, "rating": "4", "content": "San pham rat tot"})
check("Đánh giá", "Gửi đánh giá thành công và hiện trên trang", "Cảm ơn bạn" in b and "San pham rat tot" in b)
s, b = follow(c2, "POST", "/danh-gia", {"csrf_token": tok(c2, f"/san-pham/{slug3}"), "product_id": ppid, "rating": "5", "content": "Danh gia lan hai"})
check("Đánh giá", "Mỗi sản phẩm chỉ đánh giá một lần", "đã đánh giá" in b and sql(f"select count(*) from reviews where user_id={uid}") == "1")
# Quên mật khẩu
c3 = cli(); s, b = follow(c3, "POST", "/quen-mat-khau", {"csrf_token": tok(c3, "/quen-mat-khau"), "email": em})
m = re.search(r"/dat-lai-mat-khau/([0-9a-f]{64})", b)
check("Quên mật khẩu", "Yêu cầu tạo liên kết đặt lại (môi trường thử nghiệm)", bool(m))
s, b = follow(c3, "POST", "/quen-mat-khau", {"csrf_token": tok(c3, "/quen-mat-khau"), "email": "khong-co@zentech.vn"})
check("Quên mật khẩu", "Email lạ: thông báo chung, không lộ tài khoản có tồn tại", "Nếu email tồn tại" in b and "/dat-lai-mat-khau/" not in b)
if m:
    tk = m.group(1)
    check("Quên mật khẩu", "Trang đặt lại hiện form khi token hợp lệ", "Lưu mật khẩu mới" in req(c3, "GET", f"/dat-lai-mat-khau/{tk}")[1])
    s, b = follow(c3, "POST", f"/dat-lai-mat-khau/{tk}", {"csrf_token": tok(c3, f"/dat-lai-mat-khau/{tk}"), "new_password": "Short1", "confirm_password": "Short1"})
    check("Quên mật khẩu", "Mật khẩu mới ngắn bị từ chối", "từ 8 ký tự" in b)
    follow(c3, "POST", f"/dat-lai-mat-khau/{tk}", {"csrf_token": tok(c3, f"/dat-lai-mat-khau/{tk}"), "new_password": "Reset#Pass9", "confirm_password": "Reset#Pass9"})
    c4 = cli(); follow(c4, "POST", "/auth/login", {"csrf_token": tok(c4), "email": em, "password": "Reset#Pass9"})
    check("Quên mật khẩu", "Đặt lại xong đăng nhập được bằng mật khẩu mới", "Flow Moi" in req(c4, "GET", "/tai-khoan")[1])
    check("Quên mật khẩu", "Token dùng một lần: dùng lại bị từ chối", "không hợp lệ" in req(cli(), "GET", f"/dat-lai-mat-khau/{tk}")[1])
# Hết phiên do không thao tác: khách 2 giờ, admin 30 phút
import glob, os
def age_session(cl, seconds):
    sid = [ck.value for ck in cl.handlers[[type(h).__name__ for h in cl.handlers].index("HTTPCookieProcessor")].cookiejar if ck.name == "PHPSESSID"][0]
    f = f"/Applications/XAMPP/xamppfiles/temp/sess_{sid}"
    d = open(f).read(); d = re.sub(r"last_activity\|i:\d+;", f"last_activity|i:{int(time.time()) - seconds};", d); open(f, "w").write(d)
ci = cli(); follow(ci, "POST", "/auth/login", {"csrf_token": tok(ci), "email": em, "password": "Reset#Pass9"})
age_session(ci, 7000)
check("Hết phiên", "Khách 117 phút không thao tác vẫn còn đăng nhập", "Flow Moi" in req(ci, "GET", "/tai-khoan")[1])
age_session(ci, 7300)
s, b = follow(ci, "GET", "/tai-khoan")
check("Hết phiên", "Khách quá 2 giờ không thao tác bị đăng xuất, có thông báo", "đã hết hạn" in b and "Flow Moi" not in b)
ca = cli(); follow(ca, "POST", "/auth/login", {"csrf_token": tok(ca), "email": ae, "password": "Adm1nTest!"})
age_session(ca, 1700)
check("Hết phiên", "Admin 28 phút không thao tác vẫn vào được", req(ca, "GET", "/admin")[0] == 200)
age_session(ca, 1900)
s, b = follow(ca, "GET", "/admin")
check("Hết phiên", "Admin quá 30 phút không thao tác bị đăng xuất, có thông báo", "đã hết hạn" in b and "Tổng Quan" not in b)
# Admin: tồn kho trên trang quản lý sản phẩm
agg = ("select p.name from products p join product_variants v on v.product_id=p.id where v.is_active=1 group by p.id having %s order by %s limit 1")
low_first = sql(agg % ("min(v.stock_qty)<=5", "min(v.stock_qty), p.id desc"))
s_, b_, _ = req(ad, "GET", "/admin/products")
check("Admin tồn kho", "Có banner cảnh báo sản phẩm sắp hết hàng", "có biến thể sắp hết hàng" in b_)
s_, b_, _ = req(ad, "GET", "/admin/products?stock=low&sort=stock_low")
check("Admin tồn kho", "Lọc 'Có biến thể sắp hết': hiện huy hiệu, sản phẩm ít hàng nhất đứng đầu", s_ == 200 and ("Sắp hết" in b_ or "Hết hàng" in b_) and b_.find(low_first.replace("&", "&amp;")[:25]) != -1 and b_.find(low_first.replace("&", "&amp;")[:25]) == min(i for i in [b_.find(n.replace("&", "&amp;")[:25]) for n in sql("select p.name from products p join product_variants v on v.product_id=p.id where v.is_active=1 group by p.id having min(v.stock_qty)<=5 order by min(v.stock_qty), p.id desc limit 10").split("\n")] if i != -1))
s_, b_, _ = req(ad, "GET", "/admin/products?stock=ok")
check("Admin tồn kho", "Lọc 'Còn đủ hàng': không có huy hiệu sắp hết/hết hàng", s_ == 200 and "Sắp hết " not in b_ and "Hết hàng " not in b_.replace("Có biến thể hết hàng", ""))
n_out = int(sql("select count(*) from (select p.id from products p join product_variants v on v.product_id=p.id where v.is_active=1 group by p.id having sum(v.stock_qty=0)>0) t"))
s_, b_, _ = req(ad, "GET", "/admin/products?stock=out")
check("Admin tồn kho", "Lọc 'Có biến thể hết hàng': số sản phẩm khớp database", s_ == 200 and len(re.findall(r"Hết hàng \d+/\d+ biến thể", b_)) == min(n_out, 10))
s_, b_, _ = req(ad, "GET", "/admin/products?sort=stock_desc&stock=x&page=999")
check("Admin tồn kho", "Tham số lạ không gây lỗi", s_ == 200)
# Admin: quản lý mã giảm giá
s, b, _ = req(ad, "GET", "/admin/coupons"); check("Admin mã giảm giá", "Xem danh sách mã", s == 200 and "ZENTECH10" in b)
t = tok(ad, "/admin/coupons")
follow(ad, "POST", "/admin/coupons/create", {"csrf_token": t, "code": "zztest1", "discount_type": "percent", "discount_value": "15", "min_order_value": "100000", "max_uses": "3"})
check("Admin mã giảm giá", "Tạo mã mới (tự viết hoa)", sql("select concat(discount_value,'|',max_uses) from coupons where code='ZZTEST1'") == "15.00|3")
s, b = follow(ad, "POST", "/admin/coupons/create", {"csrf_token": t, "code": "ZZTEST1", "discount_type": "percent", "discount_value": "15"})
check("Admin mã giảm giá", "Từ chối mã trùng", "đã tồn tại" in b)
s, b = follow(ad, "POST", "/admin/coupons/create", {"csrf_token": t, "code": "ZZTEST2", "discount_type": "percent", "discount_value": "150"})
check("Admin mã giảm giá", "Từ chối giảm trên 100%", "không hợp lệ" in b and sql("select count(*) from coupons where code='ZZTEST2'") == "0")
cid = sql("select id from coupons where code='ZZTEST1'")
follow(ad, "POST", f"/admin/coupons/toggle/{cid}", {"csrf_token": t})
check("Admin mã giảm giá", "Bật/tắt mã", sql(f"select is_active from coupons where id={cid}") == "0")
sql("delete from coupons where code='ZZTEST1'")

# --- Hồi quy cho các lỗi tìm thấy khi review
c2 = cli(); t = tok(c2)
s, b = follow(c2, "POST", "/auth/register", {"csrf_token": t, "full_name[]": "x", "email": "arr@zentech.vn", "password": "12345678", "confirm_password": "12345678"})
check("Hồi quy", "Trường form dạng mảng không làm trang lỗi nghiêm trọng", "Fatal error" not in b and "Họ và tên không được để trống" in b)
check("Hồi quy", "Tham số URL dạng mảng (?sort[]=x, ?q[]=a) không có cảnh báo PHP", all("Warning</b>" not in req(cli(), "GET", "/san-pham?" + q)[1] for q in ("sort[]=x", "q[]=a", "keyword[]=a")))
c3 = cli(); t = tok(c3); follow(c3, "POST", "/auth/register", {"csrf_token": t, "full_name": "Sid Test", "email": f"sid_{ts}@zentech.vn", "password": "FlowTest#1", "confirm_password": "FlowTest#1", "phone": ""})
sid = lambda: [x.value for x in c3.handlers[[type(h).__name__ for h in c3.handlers].index("HTTPCookieProcessor")].cookiejar if x.name.startswith("PHPSESSID")][0]
before = sid(); t = tok(c3, "/"); req(c3, "POST", "/dang-xuat", {"csrf_token": t}); req(c3, "GET", "/auth/login")
check("Hồi quy", "Đăng xuất đổi mã phiên", before != sid())
vrow = sql("select id, price, coalesce(sale_price,'NULL') from product_variants where id>41 and coalesce(sale_price,price) between 500000 and 900000 and stock_qty>=5 limit 1").split("\t")
c4 = cli(); t = tok(c4); follow(c4, "POST", "/auth/register", {"csrf_token": t, "full_name": "Ship Test", "email": f"ship_{ts}@zentech.vn", "password": "FlowTest#1", "confirm_password": "FlowTest#1", "phone": ""})
req(c4, "POST", "/cart/add", {"variant_id": vrow[0], "quantity": 1}, {"X-CSRF-Token": tok(c4, "/"), "X-Requested-With": "XMLHttpRequest"})   # giá trong giỏ >= 500.000
sql(f"update product_variants set sale_price=400000 where id={vrow[0]}")                                      # admin hạ giá sau đó
t = tok(c4, "/checkout"); follow(c4, "POST", "/order/place", {"csrf_token": t, "receiver_name": "S", "receiver_phone": "0912345678", "shipping_address": "1 St", "payment_method": "cod"})
row = sql(f"select shipping_fee, subtotal from orders where user_id=(select id from users where email='ship_{ts}@zentech.vn') order by id desc limit 1")
sql(f"update product_variants set sale_price={'NULL' if vrow[2]=='NULL' else vrow[2]} where id={vrow[0]}")
check("Hồi quy", "Phí ship tính theo giá hiện tại trong database, không theo giá cũ trong giỏ", row.split("\t")[0] == "30000" and row.split("\t")[1] == "400000")
sql(f"delete from orders where user_id in (select id from users where email in ('ship_{ts}@zentech.vn'))"); sql(f"delete from users where email in ('sid_{ts}@zentech.vn','ship_{ts}@zentech.vn','arr@zentech.vn')")
# dọn
sql(f"delete from product_variants where product_id in (select id from products where name like 'ZZ Flow%')"); sql("delete from products where name like 'ZZ Flow%'")
sql(f"delete from orders where user_id in (select id from users where email in ('{em}'))"); sql(f"delete from users where email in ('{em}','{ae}')")
ok = sum(1 for r in results if r[2]); print(f"\n{ok}/{len(results)} đạt")
json.dump(results, open(sys.argv[1] if len(sys.argv) > 1 else "/dev/null", "w"), ensure_ascii=False) if len(sys.argv) > 1 else None
sys.exit(0 if ok == len(results) else 1)
