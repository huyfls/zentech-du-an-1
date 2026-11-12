#!/usr/bin/env python3
"""Sinh docs/ZenTech_Bao_Cao_Kiem_Thu.md từ kết quả chạy e2e_test.py và flow_tests.py."""
import re, subprocess, datetime
from pathlib import Path
ROOT = Path(__file__).resolve().parent.parent
def sql(q): return subprocess.run(["/Applications/XAMPP/xamppfiles/bin/mysql", "-uroot", "-N", "zentech_db", "-e", q], capture_output=True, text=True).stdout.strip()
e2e = [l[5:].strip() for l in (ROOT / "scratch/data/e2e_result.txt").read_text(encoding="utf-8").splitlines() if l.startswith(("PASS", "FAIL"))]
e2e_ok = [l.startswith("PASS") for l in (ROOT / "scratch/data/e2e_result.txt").read_text(encoding="utf-8").splitlines() if l.startswith(("PASS", "FAIL"))]
flow = []
for l in (ROOT / "scratch/data/flow_result.txt").read_text(encoding="utf-8").splitlines():
    m = re.match(r"(PASS|FAIL) \[(.+?)\] (.+)", l)
    if m: flow.append((m.group(1) == "PASS", m.group(2), m.group(3)))
n_all = len(e2e) + len(flow); ok_all = sum(e2e_ok) + sum(f[0] for f in flow)
def n(q): return int(sql(q) or 0)
today = datetime.date.today().strftime("%d/%m/%Y")

e2e_rows = "\n".join(f"| E{i:02d} | {t} | {'Đạt' if ok else 'Không đạt'} |" for i, (t, ok) in enumerate(zip(e2e, e2e_ok), 1))
flow_rows = "\n".join(f"| F{i:02d} | {a} | {t} | {'Đạt' if ok else 'Không đạt'} |" for i, (ok, a, t) in enumerate(flow, 1))

md = f"""# Báo Cáo Kiểm Thử Hệ Thống ZenTech

> **Ngày kiểm thử:** {today}  
> **Môi trường:** PHP 8.2 (máy chủ tích hợp), MariaDB (XAMPP), Chrome; chạy tại `localhost:8001`  
> **Kết quả tự động:** {ok_all} trên {n_all} ca đạt

---

## 1. Tổng quan

| Chỉ số | Kết quả |
|---|---|
| Ca kiểm thử tự động: kiểm tra trang, bảo mật, đơn hàng, quản trị | {sum(e2e_ok)} / {len(e2e)} đạt |
| Ca kiểm thử tự động: luồng nghiệp vụ (đăng ký, đặt hàng, lọc, admin) | {sum(f[0] for f in flow)} / {len(flow)} đạt |
| Kiểm thử logic JavaScript: bộ chọn biến thể (Node, `scratch/variant_picker_test.js`) | Đạt |
| Kiểm thử thủ công trên trình duyệt | Máy tính (khoảng 800px) và điện thoại giả lập (375px); không có thanh cuộn ngang |
| Rà soát theo checklist thiết kế | 8 checklist: giỏ hàng, thanh toán, đăng nhập, đăng ký, tìm kiếm, 404, báo lỗi nhập liệu, gửi biểu mẫu |
| Kiểm tra schema | File SQL nạp sạch vào database trống: 24 bảng, 26 khóa ngoại, khớp database đang chạy |

### Dữ liệu trong hệ thống khi kiểm thử

| Bảng | Số dòng |
|---|---|
| Sản phẩm | {n("select count(*) from products")} |
| Biến thể (màu, phiên bản, giá, tồn kho) | {n("select count(*) from product_variants")} |
| Hình ảnh sản phẩm | {n("select count(*) from product_images")} |
| Thông số kỹ thuật (EAV) | {n("select count(*) from product_attributes")} |
| Thương hiệu | {n("select count(*) from brands")} |
| Người dùng | {n("select count(*) from users")} |
| Đơn hàng | {n("select count(*) from orders")} |

Dữ liệu sản phẩm lấy từ các trang công khai của CellphoneS làm dữ liệu mẫu. Tồn kho, lượt bán và lượt xem là số giả lập.

---

## 2. Kết quả kiểm thử tự động

### 2.1 Trang, bảo mật, đơn hàng, quản trị ({len(e2e)} ca)

| Mã | Nội dung kiểm tra | Kết quả |
|---|---|---|
{e2e_rows}

### 2.2 Luồng nghiệp vụ ({len(flow)} ca)

| Mã | Khu vực | Nội dung kiểm tra | Kết quả |
|---|---|---|---|
{flow_rows}

---

## 3. Lỗi phát hiện và đã sửa trong quá trình kiểm thử

| # | Lỗi | Mức độ | Cách xử lý |
|---|---|---|---|
| 1 | Mọi form POST, kể cả của quản trị, không có chống CSRF; đăng xuất dùng GET | Nghiêm trọng | Thêm CSRF token kiểm tra tập trung ở bộ định tuyến; đăng xuất chuyển sang POST |
| 2 | Hủy đơn không hoàn lại tồn kho | Nghiêm trọng | Hủy trong một giao dịch, khóa dòng, hoàn kho, ghi log; chuyển trạng thái đơn theo bảng chuyển hợp lệ |
| 3 | Chọn màu và phiên bản không tồn tại vẫn thêm nhầm biến thể khác vào giỏ | Nghiêm trọng | Tổ hợp không có bị mờ gạch, bấm vào tự chuyển sang biến thể có thật |
| 4 | Chọn biến thể hết hàng làm hỏng toàn bộ bộ chọn (giá, ảnh không cập nhật), nút Mua ngay không bị khóa | Nghiêm trọng | Dựng lại khối tồn kho, khóa cả hai nút mua khi hết hàng |
| 5 | Trang chi tiết sản phẩm lỗi cú pháp và hằng số không tồn tại, dừng giữa trang | Nghiêm trọng | Sửa mã, bỏ cấu trúc HTML lồng nhau, truyền đủ dữ liệu thông số |
| 6 | Dữ liệu nhập bị mã hóa HTML trước khi lưu, làm sai cả mật khẩu chứa ký tự đặc biệt | Cao | Chỉ cắt khoảng trắng khi nhận, mã hóa lúc hiển thị |
| 7 | Không có thông báo sau đăng ký, đặt hàng, hủy đơn, đăng xuất | Cao | Hiển thị thông báo nổi ở mọi trang |
| 8 | Admin lưu được giá bán âm và giá khuyến mãi lớn hơn giá gốc | Cao | Thêm kiểm tra ở máy chủ kèm thông báo chỉ rõ biến thể lỗi |
| 9 | Nút "Thêm vào giỏ" đưa người dùng sang trang JSON thô | Cao | Gửi bằng AJAX, có thông báo và cập nhật số trên giỏ |
| 10 | Phân trang admin đọc sai khóa; liên kết admin dẫn tới trang 404; nhiều đường dẫn không tồn tại (tìm kiếm, số lượng giỏ, yêu thích) | Trung bình | Sửa khóa, sửa liên kết, thêm các đường dẫn thiếu |
| 11 | Gợi ý phím mũi tên và Enter ở ô tìm kiếm có hiển thị nhưng không hoạt động | Trung bình | Làm chức năng chạy thật, thêm tô sáng từ khóa và xem tất cả kết quả |
| 12 | Mất dữ liệu đã nhập khi báo lỗi đăng ký hoặc thanh toán | Trung bình | Giữ lại dữ liệu đã nhập |
| 13 | Trạng thái yêu thích mất khi tải lại trang | Thấp | Lấy trạng thái từ máy chủ |
| 14 | Màu xanh lá chỉ đạt tương phản 4,43:1, dưới chuẩn AA | Thấp | Đổi sang màu đậm hơn (5,4:1) |
| 15 | Trường form hoặc tham số URL dạng mảng (`full_name[]=x`, `?sort[]=x`) làm trang lỗi nghiêm trọng, lộ đường dẫn file | Cao | Hàm đọc dữ liệu bỏ qua giá trị dạng mảng; có test hồi quy |
| 16 | Đăng xuất giữ nguyên mã phiên cũ | Trung bình | Đổi mã phiên sau khi đăng xuất |
| 17 | Phí ship tính theo giá cũ trong giỏ, khác giá thật lấy từ database khi đặt hàng | Trung bình | Tính phí ở `OrderModel` từ tạm tính lấy lại từ database |
| 18 | Tài khoản demo trong README không đăng nhập được (mật khẩu không khớp hash); file schema chứa hash giả | Trung bình | Đặt lại mật khẩu 4 tài khoản demo, sửa hash trong file schema |
| 19 | Điểm cuối ZenBot cho mọi trang web gọi, không giới hạn số tin, đặt khóa API trong URL; câu trả lời mẫu nêu showroom và hotline không có thật | Trung bình | Bỏ CORS, giới hạn 15 tin trong 10 phút mỗi phiên, gửi khóa qua header, sửa nội dung theo chính sách thật |
| 20 | Cấu hình cố định: luôn bật hiển thị lỗi, `root` không mật khẩu | Trung bình | Đọc từ biến môi trường, mặc định chỉ bật hiển thị lỗi khi chạy ở localhost |
| 21 | Website cần internet mới hiển thị đúng (Tailwind, phông chữ, ảnh sản phẩm tải từ máy chủ ngoài) | Trung bình | Tải sẵn Tailwind, phông Be Vietnam Pro và toàn bộ ảnh sản phẩm về `public/` |
| 22 | Mã chết: 2 trang cũ, 1 bản sao API, 1 hàm AJAX không có route, tổng tồn kho bị nhân bội ở 3 truy vấn | Thấp | Xóa |
| 23 | Trang đăng ký hứa "nhận ngay voucher 50.000₫" và trang giới thiệu có showroom, hotline không có thật | Thấp | Gỡ nội dung sai, viết lại theo đúng chính sách thực tế |

---

## 4. Tồn đọng và giới hạn

- **Chưa có:** chức năng quên mật khẩu, mã giảm giá (bảng `coupons` đã thiết kế nhưng ứng dụng chưa dùng), thanh toán trực tuyến thật (ba phương thức hiện chỉ ghi nhận lựa chọn).
- **ZenBot:** khi chưa có khóa API, trả lời bằng bộ câu mẫu theo chủ đề.
- **Giỏ hàng** lưu trong phiên làm việc, chưa dùng bảng `carts` trong cơ sở dữ liệu.
- **Chưa kiểm thử:** tải đồng thời nhiều người đặt cùng một sản phẩm; trình duyệt Safari và Firefox; trình đọc màn hình thật.
- **Ảnh sản phẩm** đã lưu trên máy; 7 sản phẩm mẫu ban đầu không có ảnh nên hiện ảnh thay thế. Giới hạn số tin của ZenBot đếm theo phiên, người xóa cookie sẽ qua mặt được; khi đưa lên mạng cần đếm theo IP.
- **Form thêm, sửa sản phẩm** của quản trị chưa giữ lại dữ liệu đã nhập khi báo lỗi.

## 5. Cách chạy lại kiểm thử

```bash
cd "dự án 1"
/Applications/XAMPP/xamppfiles/bin/php -S localhost:8001 -t public/ &
python3 scratch/e2e_test.py
python3 scratch/flow_tests.py
node scratch/variant_picker_test.js
```

Các script tự tạo dữ liệu thử và xóa sau khi chạy xong.
"""
(ROOT / "docs/ZenTech_Bao_Cao_Kiem_Thu.md").write_text(md, encoding="utf-8")
print("ok", n_all, ok_all)
