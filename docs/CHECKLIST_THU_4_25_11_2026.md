# Checklist công việc đã hoàn thành – Thứ 4, 25/11/2026

**Dự án:** ZenTech – Dự án 1 Lập trình website, Nhóm 1
**Trưởng nhóm:** Lê Thành Huy (PA00423)
**Nguồn:** lịch sử commit trên GitHub (`huyfls/zentech-du-an-1`) và kết quả kiểm thử trong ngày

---

## 1. Nộp bài giai đoạn 2 (commit `dc6bd12`)

- [x] Tạo thư mục `NOP_BAI_GIAI_DOAN_2/`
- [x] Đóng gói source code `ZenTech_SourceCode.zip` (không kèm `.git`, `backup/`, dữ liệu thật)
- [x] Báo cáo giai đoạn 2 (`01_Bao_Cao_Giai_Doan_2_ZenTech.docx`)
- [x] Hướng dẫn cài đặt và chạy (`02_Huong_Dan_Cai_Dat_Va_Chay.docx`)
- [x] Báo cáo kiểm thử (`03_Bao_Cao_Kiem_Thu_ZenTech.docx`)
- [x] Slide thuyết trình (`04_Slide_Thuyet_Trinh.pptx`)
- [x] File SQL đầy đủ dữ liệu và file cấu trúc bảng (`2_Database/`)
- [x] `README.txt` giải thích từng file

## 2. Sửa lỗi trang quản trị (commit `abb95c5`)

- [x] Ô "URL ảnh đại diện" khi sửa sản phẩm nhận được cả đường dẫn `/uploads/...` (trước đây báo "Vui lòng nhập URL")

## 3. Vận hành và dữ liệu

- [x] Bật tunnel Cloudflare để người khác vào test từ xa
- [x] Khôi phục database về bản sao lưu gần nhất (16/11), có sao lưu trạng thái trước khi khôi phục
- [x] Chạy lại toàn bộ test sau khi khôi phục: đạt hết

## 4. Phía khách hàng (commit `b947f53`)

- [x] Giỏ hàng lưu vào database, đăng nhập ở 2 trình duyệt thấy cùng một giỏ
- [x] Gộp giỏ lúc chưa đăng nhập vào giỏ đã lưu khi đăng nhập
- [x] Mỗi sản phẩm tối đa 10 cái trong giỏ, vượt thì tự chỉnh và báo lý do
- [x] Chống spam thêm giỏ: tối đa 20 lần mỗi phút
- [x] Trang đăng ký kiểm tra email ngay khi gõ (sai định dạng / đã có tài khoản)
- [x] Trang thanh toán có 3 lựa chọn: COD, thanh toán online (giả lập), ví ZenTech
- [x] Thông tin giao hàng tự điền từ địa chỉ mặc định
- [x] Trang chi tiết đơn có thanh tiến trình các bước
- [x] Nút "Đã nhận hàng" khi shipper đang giao, sau đó hiện nút đánh giá sản phẩm
- [x] Yêu cầu trả hàng trong 7 ngày: chọn lý do, mô tả, ảnh minh chứng, hoàn tiền về ví hoặc tài khoản ngân hàng
- [x] Khách chỉ hủy được đơn trước khi giao cho đơn vị vận chuyển

## 5. Phía quản trị (commit `b947f53`)

- [x] Trạng thái đơn đi một chiều: Chờ xác nhận → Đã xác nhận → Đang đóng gói → Giao đơn vị vận chuyển → Shipper đang giao → Đã nhận hàng → Hoàn thành
- [x] Admin không được bấm "Đã giao hàng" (khách tự xác nhận)
- [x] Đơn đã giao cho đơn vị vận chuyển thì không hủy được
- [x] Nút "Giao thất bại" đếm 1/3, 2/3, 3/3; lần thứ 3 tự hủy đơn, hàng về kho, tiền đã trả hoàn về ví
- [x] Tab mới "Hoàn hàng": xem ảnh minh chứng, duyệt hoặc từ chối
- [x] Duyệt trả hàng: hàng về kho và hoàn tiền; từ chối: đơn chuyển sang Hoàn thành
- [x] Chỉ đánh dấu "Hoàn thành" được khi khách đã hết hạn 7 ngày trả hàng
- [x] Mã giảm giá áp dụng cho toàn bộ / một danh mục (gồm danh mục con) / một sản phẩm
- [x] Bộ lọc dashboard theo khoảng thời gian (hôm nay, 7 ngày, 30 ngày, tháng này, toàn thời gian, tùy chọn) và theo trạng thái đơn
- [x] Dashboard thêm số đơn hủy, trả hàng, khách mới trong kỳ
- [x] Đồng nhất tiếng Việt toàn bộ trang quản trị

## 6. Database (commit `b947f53`)

- [x] Migration `2026_11_25_order_flow_cart_wallet_returns.sql`: trạng thái đơn mới, đếm giao thất bại, ngày nhận hàng
- [x] Bảng mới `order_returns` (yêu cầu trả hàng) và `wallet_transactions` (lịch sử ví)
- [x] Cột `wallet_balance` cho người dùng
- [x] Giỏ hàng lưu giá lúc bỏ vào giỏ; xóa tài khoản thì xóa luôn giỏ
- [x] Mã giảm giá thêm `category_id`, `product_id`
- [x] Cập nhật `zentech_full_dump.sql` và `zentech_schema.sql`, đã thử import vào database trống

## 7. Dữ liệu sản phẩm Apple từ CellphoneS (commit `1158eaa`)

- [x] Lấy 73 dòng máy Apple, không gồm phụ kiện, tổng 684 biến thể phiên bản × màu

  | Nhóm | Dòng máy | Biến thể |
  |---|---|---|
  | iPhone | 17 | 136 |
  | iPad | 11 | 150 |
  | Mac | 30 | 207 |
  | Apple Watch | 7 | 175 |
  | AirPods | 8 | 16 |

- [x] Thêm 4 danh mục mới: Điện Thoại, Máy Tính Bảng, Laptop & Máy Mac, Đồng Hồ Thông Minh
- [x] Tải 1.367 ảnh gốc (khoảng 1,5 GB) về `public/uploads/products/apple/`
- [x] Đánh dấu 3 dòng được xem nhiều nhất mỗi nhóm là sản phẩm nổi bật
- [x] Script `crawl.py` và `build.py` để chạy lại trên máy khác, hướng dẫn trong README

## 8. Kiểm thử

- [x] Kiểm thử luồng (`flow_tests.py`): 100/100 đạt
- [x] Kiểm thử end-to-end (`e2e_test.py`): đạt hết, gồm 25 test mới cho quy trình đơn, trả hàng, ví, giỏ lưu database, giới hạn 10 sản phẩm, mã giảm giá theo danh mục, bộ lọc dashboard
- [x] Chụp màn hình kiểm tra giao diện: dashboard, chi tiết đơn admin, mã giảm giá, đăng ký, trang sản phẩm iPhone và Apple Watch

---

## Còn tồn đọng / cần làm tiếp

- [ ] Đóng gói lại `NOP_BAI_GIAI_DOAN_2` vì bản zip đang là bản trước các thay đổi chiều thứ 4
- [ ] Cập nhật báo cáo Word và báo cáo kiểm thử với các chức năng mới
- [ ] Đơn khách không bấm "Đã nhận hàng" sẽ nằm mãi ở bước "Shipper đang giao" (chưa có tự chuyển sau thời gian)
- [ ] Thanh toán online mới là giả lập, chưa kết nối cổng thanh toán thật
- [ ] Ảnh sản phẩm Apple không có trên GitHub; ai clone repo phải chạy script tải ảnh
- [ ] Tồn kho sản phẩm Apple đang là số mặc định (20), cần nhập số thật nếu dùng
