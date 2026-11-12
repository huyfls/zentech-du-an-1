# Bản Thuyết Minh Quyết Định Đề Tài

## Môn học: Dự án 1, Lập trình website

| Hạng mục | Nội dung |
|---|---|
| **Tên đề tài** | Xây dựng website thương mại điện tử kinh doanh Gaming Gear và phụ kiện máy tính, ZenTech |
| **Nhóm thực hiện** | Nhóm 1 Dự án 1 (7 thành viên), trưởng nhóm Lê Thành Huy |
| **Công nghệ** | PHP thuần (kiến trúc MVC), MySQL 8.0+ (PDO), Tailwind CSS, Vanilla JavaScript, Google Gemini API |
| **Danh sách thành viên** | 1. Lê Thành Huy, PA00423 (trưởng nhóm); 2. Nguyễn Văn Phong, PA00535; 3. Vũ Thị Kim Oanh, PA00447; 4. Lê Thanh Sơn, PA00501; 5. Lê Đình Đức, PA00493; 6. Hoàng Bách Khoa, PA00504; 7. Trịnh Đức Duy, PA00451 |
| **Thời gian Giai đoạn 1** | Tuần 1, hạn nộp 13/11 |

---

## 1. Lý do chọn đề tài

Ngành thể thao điện tử (Esports) phát triển mạnh, nhu cầu sở hữu thiết bị ngoại vi chuyên dụng như chuột gaming siêu nhẹ, bàn phím cơ tùy biến và tai nghe định vị âm thanh không còn chỉ dành cho game thủ chuyên nghiệp. Nhóm người dùng đã lan sang lập trình viên, người sáng tạo nội dung và nhân viên văn phòng trẻ.

Các trang thương mại điện tử đa ngành hiện nay thường có hai hạn chế:

- **Khó phân loại biến thể kỹ thuật phức tạp.** Một chuột hoặc bàn phím có nhiều phiên bản đan xen (màu sắc, chuẩn kết nối có dây, 2.4GHz, Bluetooth, loại switch). Khách hàng dễ mua nhầm phiên bản.
- **Thiếu tư vấn kỹ thuật.** Người mới thường bối rối trước các thuật ngữ như cảm biến HERO 2, DPI, polling rate 8000Hz, gasket mount, hot-swap.

Nhóm quyết định xây dựng ZenTech, lấy cảm hứng từ cách phân loại sản phẩm nhiều cấu hình của CellphoneS, kết hợp trợ lý AI ZenBot để người mua chọn đúng sản phẩm.

---

## 2. Mục tiêu của dự án

### 2.1 Mục tiêu nghiệp vụ

- Xây dựng kênh bán gaming gear trực tuyến với giao diện sáng, gọn, tập trung vào ảnh và thông số sản phẩm.
- Cho khách chọn phiên bản sản phẩm, xem giá, giá giảm và tồn kho theo từng biến thể ngay trên trang mà không tải lại.
- Cho phép lọc sản phẩm theo nhiều loại, nhiều thương hiệu và khoảng giá cùng lúc, qua cửa sổ bộ lọc.
- Đặt hàng nhanh trong một trang thanh toán, trừ tồn kho an toàn, tránh bán quá số lượng khi nhiều người đặt cùng lúc.
- Tích hợp trợ lý ZenBot tư vấn gear theo ngân sách và nhu cầu.
- Hỗ trợ mã giảm giá (xem trước tiền giảm, hoàn lượt khi hủy đơn), đánh giá sản phẩm của khách đã nhận hàng, trang tài khoản kèm sổ địa chỉ, quên và đặt lại mật khẩu, quản lý mã giảm giá cho admin.

### 2.2 Mục tiêu kỹ thuật và học thuật

- Nắm kiến trúc Model, View, Controller (MVC) bằng PHP thuần.
- Thiết kế cơ sở dữ liệu quan hệ chuẩn 3NF, dùng mô hình EAV (Entity, Attribute, Value) để lưu thông số kỹ thuật linh hoạt (26 bảng).
- Làm chủ giao dịch cơ sở dữ liệu (BEGIN, COMMIT, ROLLBACK và khóa dòng `SELECT ... FOR UPDATE`).
- Bảo mật cơ bản: chống CSRF, chống cố định phiên, mã hóa mật khẩu, truy vấn có tham số.
- Thiết kế UI/UX có hệ thống: bảng màu, typography, thành phần giao diện, đáp ứng nhiều kích thước màn hình.

---

## 3. Khảo sát nhu cầu và đối tượng mục tiêu

Khảo sát bằng Google Form thu được **139 phản hồi** (yêu cầu tối thiểu 100). Phân tích chi tiết, có biểu đồ, nằm trong tài liệu "Phân tích kết quả khảo sát". Các kết quả chính:

- **Độ tuổi:** 82,7% từ 18 đến 28 tuổi; nhóm lớn nhất là học sinh, sinh viên (40,3%).
- **Loại gear:** bàn phím (43,2%) và chuột (30,2%) được quan tâm nhiều nhất.
- **Ngân sách:** 59,7% muốn chi tối đa 1 triệu đồng cho một món gear.
- **Khó khăn khi mua online:** không biết thông số có hợp nhu cầu (26,6%), khó so sánh phiên bản và màu sắc (26,6%), lo hàng không chính hãng (25,2%).
- **Trợ lý AI:** 67,6% hào hứng hoặc rất hào hứng.
- **Mức quan trọng (thang 1 đến 5):** thông số kỹ thuật cao nhất (3,78), nhưng năm yếu tố chênh nhau rất ít (3,69 đến 3,78).

Các kết quả này dẫn đến quyết định thiết kế: bộ lọc khoảng giá có nút chọn nhanh, trang chi tiết nhấn mạnh thông số và bộ chọn biến thể, và có trợ lý ZenBot.

---

## 4. Phạm vi và kế hoạch triển khai

| Giai đoạn | Nội dung công việc | Sản phẩm đầu ra |
|---|---|---|
| **Giai đoạn 1 (Tuần 1)** | Quyết định đề tài; khảo sát Google Form (hơn 100 phản hồi) và phân tích; thiết kế UI/UX (bảng màu, typography, bản mẫu); thiết kế cơ sở dữ liệu 24 bảng (ERD, từ điển dữ liệu, SQL) | Bản thuyết minh đề tài; hồ sơ phân tích khảo sát; đặc tả UI/UX và bản mẫu giao diện; tài liệu cơ sở dữ liệu và file SQL |
| **Giai đoạn 2 (Tuần 2)** | Backend MVC bằng PHP; các màn hình khách hàng (trang chủ, bộ lọc, chi tiết sản phẩm, giỏ hàng, thanh toán); quản trị (tổng quan, sản phẩm nhiều biến thể, đơn hàng); trợ lý ZenBot; kiểm thử và nghiệm thu | Mã nguồn website; báo cáo kiểm thử; slide thuyết trình |

---

## 5. Kết luận Giai đoạn 1

Đề tài ZenTech đáp ứng yêu cầu của môn học, giải quyết một bài toán thương mại điện tử cụ thể (chọn đúng phiên bản của sản phẩm có nhiều cấu hình), và đã sẵn sàng cho giai đoạn lập trình.
