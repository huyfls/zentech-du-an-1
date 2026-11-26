# Báo cáo tổng kết ZenTech, đọc trước buổi kiểm tra

> **Ngày lập:** 24/11/2026 · **Buổi kiểm tra dự kiến:** khoảng 08/12/2026 (2 tuần nữa)
> **Nhóm 1 Dự án 1**, trưởng nhóm Lê Thành Huy (PA00423)
> **Mã nguồn:** github.com/huyfls/zentech-du-an-1 (công khai)

---

## 1. Tóm tắt một trang

ZenTech là website bán gaming gear (chuột, bàn phím, tai nghe, lót chuột), viết bằng PHP thuần theo mô hình MVC, cơ sở dữ liệu MySQL, giao diện Tailwind CSS và JavaScript thuần. Website chạy đầy đủ luồng mua hàng từ xem sản phẩm đến đặt hàng, có trang quản trị và trợ lý tư vấn ZenBot.

| Chỉ số | Giá trị |
|---|---|
| Sản phẩm đang bán | 330 sản phẩm, 571 biến thể (màu, phiên bản), 1.848 ảnh |
| Thương hiệu, danh mục | 34 thương hiệu, 13 danh mục (2 cấp) |
| Cơ sở dữ liệu | 26 bảng, 29 khóa ngoại, chuẩn 3NF, thông số kỹ thuật theo mô hình EAV |
| Đường dẫn (route) | 72, gồm cả đường dẫn tiếng Việt và tiếng Anh |
| Mã nguồn PHP trong `app/` | khoảng 8.300 dòng |
| Kiểm thử tự động | **159 trên 159 ca đạt** (59 ca kiểm tra trang và bảo mật, 100 ca luồng nghiệp vụ) |
| Khảo sát | 139 phản hồi, 9 biểu đồ phân tích |

**Trạng thái:** đủ 4 yêu cầu Giai đoạn 1 (đề tài, khảo sát, UI/UX, cơ sở dữ liệu) và đã vượt sang phần xây dựng website chạy thật. Còn một số việc chỉ bạn làm được (mục 8).

---

## 2. Website đã có những gì

### 2.1 Phía khách hàng

| Trang hoặc chức năng | Mô tả ngắn |
|---|---|
| Trang chủ | Tiêu đề lớn căn giữa, sản phẩm nổi bật tự chuyển giữa 5 sản phẩm (có chấm chọn, nút tạm dừng), ô loại sản phẩm, sản phẩm nổi bật, mới về |
| Danh sách sản phẩm | Bộ lọc dạng cửa sổ: chọn nhiều loại, nhiều hãng, khoảng giá; sắp xếp; phân trang 48 sản phẩm một trang |
| Thẻ sản phẩm | Ảnh sản phẩm trơn, giá "Từ ...", nhãn giảm giá; nút tim (yêu thích), nút So sánh, nút "+" thêm nhanh vào giỏ |
| Chi tiết sản phẩm | Thanh con cố định (Tổng quan, Thông số, Đánh giá, Sản phẩm liên quan, Mua); chọn màu và phiên bản cập nhật giá, tồn kho ngay; bảng thông số; đánh giá |
| Tìm kiếm nhanh | Phím tắt Ctrl K, gợi ý ngay khi gõ |
| Yêu thích | Trang `/yeu-thich`, số lượng trên biểu tượng tim ở đầu trang |
| So sánh | Chọn tối đa 3 sản phẩm, bảng so sánh cạnh nhau, tô nền các dòng khác nhau, lọc "chỉ hiện điểm khác biệt" |
| Giỏ hàng | Sửa số lượng, xóa; tự đồng bộ giá và tồn kho mới nhất từ cơ sở dữ liệu |
| Thanh toán | Chọn nhanh địa chỉ đã lưu, mã giảm giá có nút "Áp dụng" để xem trước số tiền giảm, 2 cách thanh toán (COD, chuyển khoản) |
| Đơn hàng | Lịch sử, chi tiết, hủy đơn khi còn chờ xác nhận (hoàn kho và hoàn lượt mã giảm giá) |
| Tài khoản | Sửa họ tên, số điện thoại, đổi mật khẩu, sổ địa chỉ |
| Đăng ký, đăng nhập, quên mật khẩu | Báo lỗi cụ thể, giữ lại dữ liệu đã nhập; liên kết đặt lại mật khẩu dùng một lần, hiệu lực 30 phút |
| Đánh giá | Chỉ khách đã nhận hàng mới viết được, mỗi sản phẩm một lần |
| ZenBot | Trợ lý gợi ý gear theo ngân sách và nhu cầu |
| Giới thiệu, thương hiệu, 404 | Trang tĩnh và trang lỗi riêng |

### 2.2 Phía quản trị (`/admin`)

| Trang | Mô tả |
|---|---|
| Tổng quan | Doanh thu đã giao, số đơn, đơn chờ xử lý, cảnh báo biến thể sắp hết hàng |
| Quản lý sản phẩm | Tìm kiếm, sắp xếp và lọc theo tồn kho, huy hiệu "Sắp hết", "Hết hàng", thêm, sửa, ẩn sản phẩm |
| Quản lý đơn hàng | Lọc theo trạng thái, cập nhật trạng thái theo đúng thứ tự (chờ xác nhận, đã xác nhận, đang xử lý, đang giao, đã giao, hoặc hủy) |
| Mã giảm giá | Tạo mã, bật tắt, xem số lượt đã dùng |

### 2.3 Giao diện

- Phong cách sáng, tối giản, theo nhịp trình bày của các trang sản phẩm cao cấp: thanh điều hướng mỏng mờ kính, tiêu đề rất lớn có dấu chấm cuối câu, dải nền trắng và xám xen kẽ, nút dạng viên thuốc. Mã, chữ, hình và phông đều của ZenTech, không sao chép trang khác.
- Logo mới hình phím cơ.
- Chuyển động nhẹ: thanh tiến độ cuộn, nội dung hiện dần, thẻ nghiêng theo chuột, ảnh bay vào giỏ, chuyển trang mượt. Nền trắng sạch, không có hình trang trí bay. Tự tắt khi người dùng bật "giảm chuyển động" trong hệ điều hành.
- Đáp ứng điện thoại: thanh "Thêm vào giỏ / Mua ngay" dính ở đáy trang chi tiết.

---

## 3. Cách chạy và kịch bản demo

### 3.1 Chạy trên máy

1. Mở XAMPP, bật **MySQL** (và Apache nếu muốn dùng phpMyAdmin).
2. Nếu máy mới: tạo database `zentech_db` rồi nạp file `database/zentech_full_dump.sql`.
3. Mở Terminal tại thư mục dự án và chạy: `/Applications/XAMPP/xamppfiles/bin/php -S localhost:8001 -t public/`
4. Mở trình duyệt: `http://localhost:8001`. Xem database tại `http://localhost/phpmyadmin`.

### 3.2 Tài khoản thử

| Vai trò | Email | Mật khẩu |
|---|---|---|
| Quản trị | thanhhuyfls@gmail.com | huy103 |
| Khách hàng | nguyenvanan@gmail.com | Password@123 |

Mã giảm giá có sẵn: `ZENTECH10` (giảm 10% đơn từ 500.000₫), `GAMING200K`, `NEWUSER50K`.

### 3.3 Kịch bản demo khoảng 10 phút

1. Trang chủ: chỉ sản phẩm nổi bật tự chuyển, cuộn xuống ô loại sản phẩm.
2. Danh sách: mở Bộ lọc, chọn 2 hãng và khoảng giá dưới 1 triệu.
3. Bấm "So sánh" trên 2 sản phẩm, mở bảng so sánh, bật "Chỉ hiện điểm khác biệt".
4. Mở một sản phẩm: đổi màu xem giá và tồn kho đổi; bấm "Thông số" trên thanh con.
5. Thêm vào giỏ (ảnh bay vào giỏ), mở giỏ, sửa số lượng vượt kho để thấy thông báo.
6. Đăng nhập khách, thanh toán, nhập `ZENTECH10`, bấm "Áp dụng", đặt hàng.
7. Đăng nhập admin: xem đơn mới ở Tổng quan, chuyển trạng thái đơn, xem cảnh báo tồn kho ở Quản lý sản phẩm.
8. Thử đăng nhập sai mật khẩu để thấy thông báo chung, không lộ email có tồn tại hay không.

Muốn thầy xem từ máy khác: bật tunnel (`~/bin/cloudflared tunnel --url http://localhost:8001`), gửi link `trycloudflare.com` hiện ra, xem xong tắt bằng `pkill cloudflared`.

---

## 4. Kiến trúc và cơ sở dữ liệu

- **MVC tự viết:** `public/index.php` là điểm vào duy nhất; `app/core/Router.php` ánh xạ đường dẫn sang Controller; Model dùng PDO với câu lệnh có tham số; View là PHP thuần với Tailwind.
- **26 bảng** chia 7 nhóm: tài khoản (roles, users, addresses, password_resets), danh mục và thương hiệu, sản phẩm và biến thể và thông số (EAV), giỏ hàng và đơn hàng (orders, order_items, order_status_logs, order_coupons), mã giảm giá, đánh giá, trợ lý AI.
- **Đặt hàng an toàn:** chạy trong một giao dịch: khóa dòng tồn kho (`SELECT ... FOR UPDATE`), kiểm tra kho và mã giảm giá, tạo đơn, trừ kho, ghi lịch sử trạng thái, rồi mới xác nhận. Lỗi ở bất kỳ bước nào thì hoàn tác toàn bộ, nên hai người đặt cùng lúc không thể mua quá số hàng còn.
- **Giá luôn lấy từ cơ sở dữ liệu** lúc đặt hàng, không tin giá lưu trong giỏ.
- Sơ đồ: `docs/erd_lien_ket_bang.png` (liên kết giữa các bảng) và ERD đầy đủ trong báo cáo Word.

---

## 5. Kiểm thử và bảo mật

**159 trên 159 ca kiểm thử tự động đạt** (`scratch/e2e_test.py`, `scratch/flow_tests.py`). Danh sách đầy đủ ở `09_Bao_Cao_Kiem_Thu_He_Thong_ZenTech.docx`.

### 5.1 Đăng nhập và tài khoản: đã kiểm tra từng tình huống

| Tình huống | Website phản ứng |
|---|---|
| Sai email hoặc sai mật khẩu | Cùng một thông báo "Email hoặc mật khẩu không chính xác" (không lộ email nào có tài khoản) |
| Bỏ trống | "Vui lòng nhập đầy đủ Email và Mật khẩu" |
| Sai mật khẩu 5 lần | Khóa đăng nhập 15 phút cho cặp máy và email đó |
| Tài khoản bị khóa | Chỉ báo "đã bị khóa" khi nhập đúng mật khẩu |
| Admin khóa tài khoản khi khách đang dùng | Khách bị đăng xuất ở lần tải trang kế tiếp |
| Không thao tác lâu | Khách tự đăng xuất sau 2 giờ, admin sau 30 phút |
| Thử chèn mã SQL, chèn mã `<script>` | Không có tác dụng |
| Gửi form giả từ trang khác (CSRF) | Bị từ chối |
| Đăng xuất | Đổi mã phiên, **xóa giỏ hàng** để người sau trên cùng máy không thấy |

### 5.2 Giỏ hàng: đã kiểm tra

- Số lượng 0, âm, mã sản phẩm sai: báo lỗi, không thêm.
- Thêm vượt tồn kho: tự giảm về số còn và báo "Kho chỉ còn N sản phẩm".
- Admin đổi giá sau khi khách bỏ vào giỏ: giỏ hiện giá mới và báo "Giá ... đã đổi từ ... thành ...".
- Sản phẩm hết hàng hoặc ngừng bán khi đang nằm trong giỏ: tự bỏ khỏi giỏ, có lý do.
- Hàng hết đúng lúc bấm đặt: báo không đủ hàng, không tạo đơn.

### 5.3 Bảo mật khác

Mật khẩu băm bcrypt; token đặt lại mật khẩu chỉ lưu dạng băm; header bảo mật (chống nhúng khung, chống đoán kiểu tệp); khách không vào được trang quản trị; giới hạn số lượt gọi ZenBot.

---

## 6. Thay đổi từ sau hạn nộp Giai đoạn 1 (13/11)

1. Rà soát giao diện: nhãn giảm giá không che logo ảnh, không hiện 5 sao khi chưa có đánh giá, tiêu đề thống nhất.
2. Ảnh đại diện sạch cho 302 sản phẩm, nút thêm nhanh vào giỏ, thanh mua hàng trên điện thoại.
3. Trang Yêu thích và So sánh sản phẩm; sửa khả năng tiếp cận (nhãn ô nhập, tiêu đề trang, cỡ chữ, vùng chạm).
4. Áp nhịp trình bày cao cấp cho toàn bộ trang khách; bỏ hình nền bay và hiệu ứng khi bấm.
5. Sản phẩm nổi bật trang chủ tự chuyển giữa 5 sản phẩm.
6. Sửa 4 lỗi: trang 404 hiện ký tự mã hóa; tài khoản bị khóa vẫn dùng được phiên cũ; giỏ hiện giá cũ; sửa số lượng vượt kho không báo.
7. Đăng xuất xóa giỏ hàng.

---

## 7. Hạn chế đã biết (nên nói thật nếu thầy hỏi)

| Hạn chế | Giải thích |
|---|---|
| Quên mật khẩu chưa gửi email thật | Chưa có máy chủ gửi thư; ở máy thử, liên kết hiện thẳng trên trang |
| Thanh toán chưa qua cổng thật | COD và chuyển khoản là mô phỏng, chưa nối VNPay, MoMo |
| ZenBot chưa gọi AI thật | Chưa cấu hình khóa Gemini nên ZenBot trả lời theo quy tắc có sẵn; có khóa thì gọi AI thật |
| Giỏ hàng, yêu thích lưu theo phiên | Đổi trình duyệt hoặc hết phiên thì mất; danh sách so sánh lưu trong trình duyệt |
| Dữ liệu sản phẩm lấy từ CellphoneS | Tên, giá, ảnh là dữ liệu mẫu; tồn kho, lượt bán là số giả lập |
| Admin chưa theo phong cách mới | Trang quản trị giữ bố cục cũ |
| Chưa thử trên điện thoại thật, Safari, Firefox | Mới kiểm tra trên Chrome (cả khổ máy tính và khổ điện thoại giả lập) |
| Độ tương phản màu chưa đo bằng công cụ | Chỉnh theo mục tiêu chuẩn AA nhưng chưa có số đo |
| File Figma chưa cập nhật logo mới | Hết lượt gọi công cụ Figma của gói miễn phí |

---

## 8. Việc bạn cần làm trước buổi kiểm tra

- [ ] **Gắn link Google Form thật và ảnh trang kết quả** vào báo cáo; ghi rõ nguồn 139 phản hồi (thầy cho phép dùng AI tạo câu trả lời).
- [ ] Đối chiếu bộ mã câu hỏi `zentech_survey_codebook.json` với form thật.
- [ ] Mở các file Word trong `NOP_BAI_GIAI_DOAN_1/` xem định dạng; ảnh chụp giao diện trong báo cáo đang là bản cũ, nên chụp lại nếu cần.
- [ ] Chạy thử kịch bản demo ở mục 3.3 trên chính máy sẽ trình bày.
- [ ] Đổi mật khẩu admin nếu repo vẫn công khai (mật khẩu `huy103` đang nằm trong file SQL công khai).
- [ ] Mỗi thành viên đọc mục 4, 5 và 9 để trả lời được câu hỏi.
- [ ] Sao lưu database trước buổi demo (thư mục `backup/`).

---

## 9. Câu hỏi thầy có thể hỏi

| Câu hỏi | Gợi ý trả lời |
|---|---|
| Vì sao chọn đề tài này? | Khảo sát 139 người: khó biết thông số có hợp nhu cầu và khó so sánh phiên bản là hai khó khăn lớn nhất (26,6% mỗi mục), nên web tập trung vào thông số, bộ chọn biến thể và so sánh |
| Hai người cùng mua món cuối cùng thì sao? | Đặt hàng chạy trong giao dịch có khóa dòng; người sau phải chờ và sẽ nhận thông báo hết hàng |
| Mật khẩu lưu thế nào? | Băm bằng bcrypt, không lưu mật khẩu gốc |
| Chống SQL injection thế nào? | Mọi truy vấn dùng PDO với tham số, không ghép chuỗi trực tiếp |
| CSRF là gì, đã chống chưa? | Mọi form và yêu cầu AJAX đều kèm mã bảo vệ; thiếu mã thì bị từ chối |
| Vì sao dùng mô hình EAV cho thông số? | Mỗi loại gear có thông số khác nhau; EAV cho thêm loại mới mà không phải sửa bảng |
| Giá trong giỏ khác giá lúc đặt thì sao? | Giỏ tự đồng bộ giá mới và báo khách; khi đặt luôn tính theo giá trong database |
| Admin khóa tài khoản đang đăng nhập? | Phiên đó bị đăng xuất ở lần tải trang kế tiếp |
| Đã kiểm thử thế nào? | 159 ca tự động chạy trên website thật, cộng kiểm tra giao diện bằng trình duyệt |
| Phần nào chưa làm? | Xem mục 7, nói thật từng mục |

---

## 10. Cập nhật ngày 25/11/2026

Các chức năng thêm sau khi hoàn thiện báo cáo này. Chi tiết từng mục: `docs/CHECKLIST_THU_4_25_11_2026.md`.

### 10.1 Phía khách hàng

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

### 10.2 Phía quản trị

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

### 10.3 Database

- [x] Migration `2026_11_25_order_flow_cart_wallet_returns.sql`: trạng thái đơn mới, đếm giao thất bại, ngày nhận hàng
- [x] Bảng mới `order_returns` (yêu cầu trả hàng) và `wallet_transactions` (lịch sử ví)
- [x] Cột `wallet_balance` cho người dùng
- [x] Giỏ hàng lưu giá lúc bỏ vào giỏ; xóa tài khoản thì xóa luôn giỏ
- [x] Mã giảm giá thêm `category_id`, `product_id`
- [x] Cập nhật `zentech_full_dump.sql` và `zentech_schema.sql`, đã thử import vào database trống

### 10.4 Dữ liệu sản phẩm Apple từ CellphoneS

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

### 10.5 Kiểm thử

- [x] Kiểm thử luồng (`flow_tests.py`): 100/100 đạt
- [x] Kiểm thử end-to-end (`e2e_test.py`): đạt hết, gồm 25 test mới cho quy trình đơn, trả hàng, ví, giỏ lưu database, giới hạn 10 sản phẩm, mã giảm giá theo danh mục, bộ lọc dashboard
- [x] Chụp màn hình kiểm tra giao diện: dashboard, chi tiết đơn admin, mã giảm giá, đăng ký, trang sản phẩm iPhone và Apple Watch

### 10.6 Hạn chế mới cần biết

- Đơn khách không bấm "Đã nhận hàng" sẽ nằm ở bước "Shipper đang giao"; chưa có tự chuyển trạng thái sau một thời gian.
- Thanh toán online là giả lập, chưa nối cổng thanh toán thật. Hoàn tiền qua ngân hàng chỉ ghi nhận, kế toán chuyển khoản tay.
- Tồn kho sản phẩm Apple là số mặc định (20) vì CellphoneS không công khai tồn kho. Ảnh và thông tin sản phẩm là của CellphoneS, chỉ dùng cho mục đích học tập.
- Chạy trên Windows: xem `docs/HUONG_DAN_CHAY_TREN_WINDOWS.md`.
