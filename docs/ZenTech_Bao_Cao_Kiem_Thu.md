# Báo Cáo Kiểm Thử Hệ Thống ZenTech

> **Ngày kiểm thử:** 11/11/2026  
> **Môi trường:** PHP 8.2 (máy chủ tích hợp), MariaDB (XAMPP), Chrome; chạy tại `localhost:8001`  
> **Kết quả tự động:** 86 trên 86 ca đạt

---

## 1. Tổng quan

| Chỉ số | Kết quả |
|---|---|
| Ca kiểm thử tự động: kiểm tra trang, bảo mật, đơn hàng, quản trị | 57 / 57 đạt |
| Ca kiểm thử tự động: luồng nghiệp vụ (đăng ký, đặt hàng, lọc, admin) | 29 / 29 đạt |
| Kiểm thử logic JavaScript: bộ chọn biến thể (Node, `scratch/variant_picker_test.js`) | Đạt |
| Kiểm thử thủ công trên trình duyệt | Máy tính (khoảng 800px) và điện thoại giả lập (375px); không có thanh cuộn ngang |
| Rà soát theo checklist thiết kế | 8 checklist: giỏ hàng, thanh toán, đăng nhập, đăng ký, tìm kiếm, 404, báo lỗi nhập liệu, gửi biểu mẫu |
| Kiểm tra schema | File SQL nạp sạch vào database trống: 24 bảng, 26 khóa ngoại, khớp database đang chạy |

### Dữ liệu trong hệ thống khi kiểm thử

| Bảng | Số dòng |
|---|---|
| Sản phẩm | 330 |
| Biến thể (màu, phiên bản, giá, tồn kho) | 571 |
| Hình ảnh sản phẩm | 1827 |
| Thông số kỹ thuật (EAV) | 1834 |
| Thương hiệu | 34 |
| Người dùng | 4 |
| Đơn hàng | 8 |

Dữ liệu sản phẩm lấy từ các trang công khai của CellphoneS làm dữ liệu mẫu. Tồn kho, lượt bán và lượt xem là số giả lập.

---

## 2. Kết quả kiểm thử tự động

### 2.1 Trang, bảo mật, đơn hàng, quản trị (57 ca)

| Mã | Nội dung kiểm tra | Kết quả |
|---|---|---|
| E01 | Đăng nhập thiếu CSRF token bị từ chối (419) | Đạt |
| E02 | Trang đăng nhập có CSRF token | Đạt |
| E03 | Đăng ký tài khoản thành công (302) | Đạt |
| E04 | Đổi mã phiên sau khi đăng ký (chống cố định phiên) | Đạt |
| E05 | Tên lưu nguyên bản, không bị mã hóa HTML | Đạt |
| E06 | Đăng xuất bằng GET không còn hiệu lực (404) | Đạt |
| E07 | Đăng xuất thiếu CSRF token bị từ chối (419) | Đạt |
| E08 | Đăng xuất có CSRF token thành công (302) | Đạt |
| E09 | Đăng nhập với mật khẩu chứa ký tự đặc biệt | Đạt |
| E10 | Trang chủ hiển thị khi đã đăng nhập | Đạt |
| E11 | Truy cập / trả về 200 | Đạt |
| E12 | không có cảnh báo PHP tại / | Đạt |
| E13 | Truy cập /san-pham trả về 200 | Đạt |
| E14 | không có cảnh báo PHP tại /san-pham | Đạt |
| E15 | Truy cập /thuong-hieu trả về 200 | Đạt |
| E16 | không có cảnh báo PHP tại /thuong-hieu | Đạt |
| E17 | Truy cập /gio-hang trả về 200 | Đạt |
| E18 | không có cảnh báo PHP tại /gio-hang | Đạt |
| E19 | Truy cập /orders trả về 200 | Đạt |
| E20 | không có cảnh báo PHP tại /orders | Đạt |
| E21 | Truy cập /ve-chung-toi trả về 200 | Đạt |
| E22 | không có cảnh báo PHP tại /ve-chung-toi | Đạt |
| E23 | Truy cập /san-pham/logitech-g-pro-x-superlight-2 trả về 200 | Đạt |
| E24 | không có cảnh báo PHP tại /san-pham/logitech-g-pro-x-superlight-2 | Đạt |
| E25 | Truy cập /403 trả về 403/404 | Đạt |
| E26 | không có cảnh báo PHP tại /403 | Đạt |
| E27 | Truy cập /404 trả về 403/404 | Đạt |
| E28 | không có cảnh báo PHP tại /404 | Đạt |
| E29 | Mã đơn không hợp lệ trả 404 chứ không phải lỗi 500 | Đạt |
| E30 | API tìm kiếm trả JSON | Đạt |
| E31 | API số lượng giỏ hàng trả JSON | Đạt |
| E32 | Thêm giỏ hàng thiếu CSRF token bị từ chối (419) | Đạt |
| E33 | Thêm giỏ hàng có token trong header thành công | Đạt |
| E34 | Đặt hàng thành công | Đạt |
| E35 | Tồn kho giảm đúng 2 | Đạt |
| E36 | Hủy đơn thành công (302) | Đạt |
| E37 | Trạng thái đơn chuyển sang đã hủy | Đạt |
| E38 | Hủy đơn hoàn lại tồn kho | Đạt |
| E39 | Hủy lần hai không cộng kho thêm | Đạt |
| E40 | Quản trị viên đăng nhập | Đạt |
| E41 | Truy cập /admin trả về 200 | Đạt |
| E42 | không có cảnh báo PHP tại /admin | Đạt |
| E43 | Truy cập /admin/products trả về 200 | Đạt |
| E44 | không có cảnh báo PHP tại /admin/products | Đạt |
| E45 | Truy cập /admin/orders trả về 200 | Đạt |
| E46 | không có cảnh báo PHP tại /admin/orders | Đạt |
| E47 | Truy cập /admin/orders/detail/62 trả về 200 | Đạt |
| E48 | không có cảnh báo PHP tại /admin/orders/detail/62 | Đạt |
| E49 | Truy cập /admin/products/create trả về 200 | Đạt |
| E50 | không có cảnh báo PHP tại /admin/products/create | Đạt |
| E51 | Trang đơn hàng admin không có cảnh báo PHP | Đạt |
| E52 | Admin cập nhật đơn thiếu CSRF token bị từ chối (419) | Đạt |
| E53 | Không cho nhảy trạng thái từ chờ xử lý sang đã giao | Đạt |
| E54 | Sau cập nhật chuyển về trang chi tiết đơn | Đạt |
| E55 | Chuỗi trạng thái hợp lệ đến đang giao | Đạt |
| E56 | Trả hàng hoàn kho +1 | Đạt |
| E57 | Khách hàng không vào được khu quản trị | Đạt |

### 2.2 Luồng nghiệp vụ (29 ca)

| Mã | Khu vực | Nội dung kiểm tra | Kết quả |
|---|---|---|---|
| F01 | Đăng ký | Báo lỗi dữ liệu sai (email, mật khẩu ngắn, xác nhận lệch) | Đạt |
| F02 | Đăng ký | Giữ lại tên và số điện thoại đã nhập sau khi báo lỗi | Đạt |
| F03 | Đăng nhập | Sai thông tin: báo lỗi chung, không lộ email có tồn tại hay không | Đạt |
| F04 | Đăng ký | Đăng ký thành công và có thông báo | Đạt |
| F05 | Giỏ hàng | Thêm vào giỏ (AJAX) trả về số lượng | Đạt |
| F06 | Thanh toán | Báo lỗi tên, số điện thoại không hợp lệ | Đạt |
| F07 | Thanh toán | Giữ lại địa chỉ đã nhập sau khi báo lỗi | Đạt |
| F08 | Thanh toán | Đặt hàng thành công, hiện thông báo | Đạt |
| F09 | Thanh toán | Trừ tồn kho đúng số lượng đặt | Đạt |
| F10 | Đơn hàng | Hủy đơn đang chờ: đổi trạng thái và có thông báo | Đạt |
| F11 | Đơn hàng | Hủy đơn hoàn lại tồn kho | Đạt |
| F12 | Đơn hàng | Hủy lần hai không cộng kho thêm | Đạt |
| F13 | Đăng nhập | Đăng xuất có thông báo | Đạt |
| F14 | Bộ lọc | Chọn nhiều thương hiệu cho ra nhiều kết quả hơn một thương hiệu | Đạt |
| F15 | Bộ lọc | Chọn nhiều loại sản phẩm | Đạt |
| F16 | Bộ lọc | Liên kết cũ ?category=slug vẫn dùng được | Đạt |
| F17 | Bộ lọc | Không có kết quả: hiện trạng thái trống có nút đặt lại | Đạt |
| F18 | Bộ lọc | Tham số lạ không gây lỗi PHP | Đạt |
| F19 | Tìm kiếm | API gợi ý trả về kết quả JSON | Đạt |
| F20 | Thương hiệu | Trang riêng của hãng chuyển sang danh sách đã lọc | Đạt |
| F21 | Admin | Thêm sản phẩm thiếu tên: báo lỗi | Đạt |
| F22 | Admin | Từ chối giá bán âm | Đạt |
| F23 | Admin | Từ chối giá khuyến mãi lớn hơn giá gốc | Đạt |
| F24 | Admin | Thêm sản phẩm hợp lệ thành công | Đạt |
| F25 | Admin | Xóa mềm sản phẩm (is_active = 0) | Đạt |
| F26 | Hồi quy | Trường form dạng mảng không làm trang lỗi nghiêm trọng | Đạt |
| F27 | Hồi quy | Tham số URL dạng mảng (?sort[]=x, ?q[]=a) không có cảnh báo PHP | Đạt |
| F28 | Hồi quy | Đăng xuất đổi mã phiên | Đạt |
| F29 | Hồi quy | Phí ship tính theo giá hiện tại trong database, không theo giá cũ trong giỏ | Đạt |

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
