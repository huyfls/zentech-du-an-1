# Chuẩn bị báo cáo Giai đoạn 1 (hạn 13/11)

Tài liệu này giúp bạn chuẩn bị và trình bày Giai đoạn 1 của đồ án ZenTech: đủ file nộp chưa, nói gì, demo gì, và trả lời thế nào khi bị hỏi.

---

## 1. Yêu cầu Giai đoạn 1 và hiện trạng

| Yêu cầu | Trạng thái | File chính | Việc còn lại |
|---|---|---|---|
| **Quyết định đề tài** | Xong | `01_Quyet_Dinh_De_Tai_ZenTech.docx` | Điền tên và MSSV thành viên |
| **Google Form: ít nhất 100 phản hồi** | Xong (139 phản hồi) | `zentech_survey_139.xlsx`, `.csv`, `zentech_survey_139_labeled.csv` | Thêm link hoặc ảnh chụp Google Form thật; đối chiếu bảng mã hóa (mục 3) |
| **Phân tích câu trả lời** | Xong, có 9 biểu đồ | `08_Phan_Tich_Khao_Sat_ZenTech.docx`, thư mục `bieu_do_khao_sat` | Như dòng trên |
| **Thiết kế UI/UX** | Xong, kèm 24 ảnh giao diện thật | `02_Dac_Ta_Thiet_Ke_UIUX_ZenTech.docx`, `03_Ban_Mau_Giao_Dien_Tuong_Tac_UIUX.html`, thư mục `hinh_anh_giao_dien` | Không |
| **Thiết kế database** | Xong: 24 bảng, 26 khóa ngoại | `04_...Co_So_Du_Lieu.docx`, `05_...Data_Dictionary.docx`, `06_...ERD.docx`, `06_ERD_day_du.png`, `07_zentech_schema.sql`, `07_zentech_full_dump.sql` | Không |

Ngoài yêu cầu, nhóm đã làm sẵn sản phẩm chạy được (website đầy đủ) và báo cáo kiểm thử (`09_...`). Vì vậy khi báo cáo Giai đoạn 1 có thể demo luôn thiết kế đã thành sản phẩm.

---

## 2. Danh sách file trong thư mục này

| File | Nội dung | Dùng khi |
|---|---|---|
| `00_BAO_CAO_TONG_HOP_GIAI_DOAN_1_ZENTECH.docx` | Gộp tất cả: đề tài, khảo sát, UI/UX, database, kiểm thử | Nộp bản tổng hợp |
| `01_Quyet_Dinh_De_Tai_ZenTech.docx` | Lý do chọn đề tài, mục tiêu, kế hoạch 2 giai đoạn | Phần mở đầu |
| `02_Dac_Ta_Thiet_Ke_UIUX_ZenTech.docx` | Bảng màu, chữ, thành phần, luồng người dùng, 17 ảnh giao diện | Phần UI/UX |
| `03_Ban_Mau_Giao_Dien_Tuong_Tac_UIUX.html` | Bản mẫu bấm được: màu, chữ, nút, thẻ, chọn biến thể, bộ lọc, thông báo | Mở trên trình duyệt khi trình bày UI/UX |
| `04_Thiet_Ke_Kien_Truc_Co_So_Du_Lieu.docx` | Kiến trúc 24 bảng, nhóm bảng | Phần database |
| `05_Tu_Dien_Du_Lieu_Data_Dictionary.docx` | Từng bảng, từng cột, kiểu dữ liệu, ràng buộc | Khi bị hỏi chi tiết cột |
| `06_So_Do_Quan_He_Thuc_The_ERD.docx` | ERD tổng quan và đầy đủ | Phần database |
| `06_ERD_day_du.png` | ERD đầy đủ từng cột, ảnh lớn (7.854 x 3.644 px) để phóng to | Chiếu khi trình bày |
| `07_zentech_schema.sql` | Cấu trúc 24 bảng, 10 sản phẩm mẫu, 4 tài khoản demo | Nộp file SQL |
| `07_zentech_full_dump.sql` | Dữ liệu đầy đủ: 330 sản phẩm, 34 hãng, 571 biến thể | Nạp để demo |
| `08_Phan_Tich_Khao_Sat_ZenTech.docx` | Phân tích 139 phản hồi, 9 biểu đồ, kết luận tác động tới thiết kế | Phần khảo sát |
| `09_Bao_Cao_Kiem_Thu_He_Thong_ZenTech.docx` | 86 ca kiểm thử đạt, 23 lỗi đã phát hiện và sửa | Khi được hỏi về chất lượng |
| `10_SQL_PHP_PDO_ZenTech.docx` | Mẫu truy vấn SQL và PDO | Tham khảo |
| `TOM_TAT_DU_AN_1_ZENTECH_TEAM.pdf` (và `.html`) | Tóm tắt 6 trang cho cả nhóm | Đọc nhanh trước buổi báo cáo |
| `BAI_TEST_DOC_HIEU_ZENTECH.html` | Bài test 11 câu để cả nhóm ôn nội dung | Cả nhóm tự kiểm tra |
| `zentech_survey_codebook.json` | Bảng giải nghĩa mã của khảo sát | Khi cần sửa nhãn |
| `hinh_anh_giao_dien/` | 24 ảnh chụp giao diện (máy tính, điện thoại, admin) | Làm slide |
| `bieu_do_khao_sat/` | 9 biểu đồ khảo sát | Làm slide |

Sơ đồ Mermaid (ERD, luồng người dùng) đã được vẽ thành ảnh nằm trong `docs/hinh_ve/` và đã chèn sẵn vào các file Word.

---

## 3. Việc phải làm trước ngày báo cáo

Làm theo thứ tự ưu tiên:

- [ ] **Mở thử các file Word.** Chúng được sinh tự động và chưa được mở bằng Word. Kiểm tra bảng, hình, tiếng Việt có dấu, rồi sửa lỗi định dạng nếu có.
- [ ] **Đối chiếu bảng mã hóa khảo sát với Google Form thật.** File dữ liệu gốc chỉ có số (1, 2, 3...), nhãn trong `zentech_survey_codebook.json` là bảng đề xuất. Cần chắc nhất ở 4 câu: nghề nghiệp, kiểu kết nối, khó khăn khi mua, mức hứng thú với AI. Nếu có nhãn sai: sửa trong file `zentech_survey_codebook.json`, rồi chạy `python3 scratch/analyze_survey.py` và `python3 scratch/build_survey_md.py`, sau đó `python3 docs/convert_to_docx.py`.
- [ ] **Chụp màn hình Google Form (câu hỏi) và trang phản hồi**, đưa link Form vào báo cáo `08_...`. Giảng viên thường hỏi bằng chứng của khảo sát.
- [x] **Điền tên thành viên và MSSV (đã điền)** vào `docs/ZenTech_Quyet_Dinh_De_Tai.md` (dòng "Sinh viên thực hiện", đang ghi "ZenTech Dev Team") và dòng tương ứng trong `docs/convert_to_docx.py`, rồi chạy lại `python3 docs/convert_to_docx.py`.
- [ ] **Thống nhất cách nói về nguồn dữ liệu khảo sát** (xem mục 6).
- [ ] **Chạy thử toàn bộ demo trên đúng máy sẽ dùng để báo cáo** (mục 5), kể cả khi tắt Wi-Fi. Website đã chạy được không cần mạng.
- [ ] **Sao lưu** toàn bộ thư mục `dự án 1 - bản chính` ra USB hoặc đám mây.
- [ ] Cả nhóm làm `BAI_TEST_DOC_HIEU_ZENTECH.html` để chắc ai cũng nắm nội dung.

---

## 4. Gợi ý kịch bản trình bày (khoảng 12 phút, chia lại theo thời gian được cấp)

| Phần | Thời gian | Nói gì | Chiếu gì |
|---|---|---|---|
| 1. Mở đầu | 1 phút | Giới thiệu nhóm và đề tài: website bán gaming gear, mỗi sản phẩm có nhiều màu và phiên bản | Trang chủ (`01_trang_chu.png`) |
| 2. Quyết định đề tài | 2 phút | Bài toán: người mua dễ mua nhầm phiên bản, khó so sánh thông số. Giải pháp: chọn biến thể với giá và tồn kho đổi ngay, trợ lý ZenBot | `01_Quyet_Dinh_De_Tai` |
| 3. Khảo sát | 3 phút | 139 phản hồi. 4 phát hiện chính và quyết định thiết kế tương ứng (bảng ở mục 5) | Biểu đồ: tuổi, ngân sách, khó khăn khi mua, mức quan trọng |
| 4. Thiết kế UI/UX | 3 phút | Nền sáng tối giản, một màu nhấn xanh, ảnh sản phẩm làm trung tâm. Đi qua bộ lọc, bộ chọn biến thể. Nói thẳng việc đã đổi từ giao diện tối sang sáng và vì sao | `03_Ban_Mau...html`, ảnh `03_`, `05_`, `07_` |
| 5. Thiết kế database | 3 phút | 24 bảng, chuẩn 3NF. Hai ý chính: bảng biến thể tách riêng và thông số lưu dạng EAV | ERD tổng quan, `06_ERD_day_du.png` |
| 6. Demo | 3 phút (nếu được) | Mục 5 bên dưới | Website chạy thật |
| 7. Kết | 1 phút | Đã xong gì, còn gì, kế hoạch Giai đoạn 2 | Bảng ở mục 1 |

Nguyên tắc nói: mỗi quyết định thiết kế gắn với một số liệu khảo sát hoặc một vấn đề của người dùng. Ví dụ: "53,2% người trả lời khó chọn vì thông số và so sánh phiên bản, nên trang chi tiết có tab thông số và bộ chọn biến thể đổi giá ngay".

---

## 5. Số liệu cần thuộc

**Khảo sát (139 phản hồi, tính từ `zentech_survey_139.csv`)**

| Số liệu | Giá trị |
|---|---|
| Từ 18 đến 28 tuổi | 82,7% (nhóm 18 đến 22 tuổi: 60,4%) |
| Học sinh, sinh viên | 40,3% |
| Quan tâm bàn phím và chuột | 73,4% (bàn phím 43,2%, chuột 30,2%) |
| Ngân sách tối đa 1 triệu đồng | 59,7% |
| Thích kết nối không dây | 67,6% |
| Khó chọn vì thông số hoặc so sánh phiên bản | 53,2% (26,6% mỗi loại) |
| Lo hàng không chính hãng | 25,2% |
| Hào hứng với trợ lý AI | 67,6% |
| Yếu tố quan trọng nhất | Thông số kỹ thuật, 3,78 trên 5 (nhưng 5 yếu tố chỉ chênh từ 3,69 đến 3,78) |

**Hệ thống**

| Số liệu | Giá trị |
|---|---|
| Số bảng, khóa ngoại | 24 bảng, 26 khóa ngoại |
| Sản phẩm, thương hiệu, biến thể, ảnh | 330, 34, 571, hơn 2.600 |
| Kiểm thử | 86 ca tự động đạt, 23 lỗi đã phát hiện và sửa |

---

## 6. Điểm cần nói trung thực

Giảng viên đánh giá cao sự trung thực hơn là số liệu đẹp. Chuẩn bị sẵn cách nói cho các điểm sau:

1. **Nguồn dữ liệu khảo sát.** Đề bài cho phép dùng AI tạo câu trả lời. Hãy thống nhất cả nhóm nói đúng như thực tế đã làm, và ghi thống nhất vào báo cáo `08_...` (hiện đang viết trung tính là "139 phản hồi").
2. **Khảo sát không có câu hỏi về giao diện sáng hay tối.** Giao diện được chọn theo nguyên tắc thiết kế (ảnh sản phẩm nền trắng nổi rõ, dễ đọc), không viện dẫn khảo sát. Đừng nói "khảo sát cho thấy người dùng thích giao diện sáng".
3. **Dữ liệu sản phẩm** lấy từ các trang công khai của CellphoneS làm dữ liệu mẫu, chỉ dùng để học tập. Tồn kho, lượt bán, lượt xem là số giả lập.
4. **Chưa có:** thanh toán trực tuyến thật (3 phương thức chỉ ghi nhận lựa chọn), quên mật khẩu, mã giảm giá. ZenBot trả lời bằng bộ câu mẫu khi chưa có khóa API Gemini.
5. **Giỏ hàng lưu trong phiên (session)**, dù database có sẵn bảng `carts`, `cart_items` cho hướng mở rộng.

---

## 7. Kịch bản demo (3 đến 4 phút)

**Chuẩn bị (làm trước giờ báo cáo):**

```bash
# 1. Bật MySQL trong XAMPP. Nếu database trống: phpMyAdmin > Import > 07_zentech_full_dump.sql
# 2. Chạy website
cd ~/Documents/"dự án 1 - bản chính"
/Applications/XAMPP/xamppfiles/bin/php -S localhost:8001 -t public/
# 3. Mở http://localhost:8001
```

Tài khoản: khách `nguyenvanan@gmail.com`, quản trị `admin@zentech.vn`, mật khẩu cả hai là `Password@123`.

**Các bước demo:**

1. **Trang chủ và danh sách:** mở "Sản phẩm", cho thấy 330 sản phẩm, giá, giảm giá.
2. **Bộ lọc:** bấm "Bộ lọc", chọn 2 hãng (Logitech, Razer) và nút giá "500K - 1 triệu", bấm "Xem kết quả". Chỉ vào các thẻ bộ lọc phía trên, bấm × để bỏ một thẻ.
3. **Chọn biến thể:** mở `DareU EK87 Pro`, chọn Trắng, rồi chọn Brown Switch. Giải thích: tổ hợp Trắng + Brown không tồn tại nên hệ thống tự chuyển, tránh khách mua nhầm.
4. **Đặt hàng:** đăng nhập khách, thêm vào giỏ (có thông báo), thanh toán. Nói về giao dịch trừ kho (`SELECT ... FOR UPDATE`).
5. **Quản trị:** đăng nhập admin, xem tổng quan, chuyển trạng thái đơn. Chỉ ra việc không cho nhảy trạng thái bất hợp lý, và hủy đơn thì hoàn lại tồn kho.
6. **Tìm nhanh (nếu còn thời gian):** nhấn `Ctrl + K`, gõ "razer".

**Nếu demo gặp sự cố:** mở ảnh trong `hinh_anh_giao_dien/` thay thế. Hãy mở sẵn các ảnh này ở một cửa sổ khác.

---

## 8. Câu hỏi giảng viên có thể hỏi

| Câu hỏi | Gợi ý trả lời |
|---|---|
| Vì sao tách bảng `product_variants`? | Một sản phẩm có nhiều màu và phiên bản, mỗi biến thể có giá, tồn kho, ảnh riêng. Tách bảng để trừ kho đúng từng biến thể và tránh lặp dữ liệu (chuẩn 3NF). |
| EAV là gì, vì sao dùng? | Entity, Attribute, Value: thông số lưu theo dạng (sản phẩm, thuộc tính, giá trị). Chuột có DPI, bàn phím có switch; dùng EAV thì thêm loại thông số mới không phải sửa cấu trúc bảng. Nhược điểm: truy vấn phức tạp hơn, nên chỉ dùng cho thông số hiển thị. |
| Đặt hàng đồng thời thì sao, có bán quá tồn kho không? | Dùng giao dịch: `BEGIN`, `SELECT ... FOR UPDATE` khóa dòng biến thể, kiểm tra tồn kho, trừ kho, tạo đơn, `COMMIT`; lỗi thì `ROLLBACK`. Đã kiểm thử hủy đơn hoàn kho. Chưa kiểm thử tải nhiều người cùng lúc. |
| Vì sao chọn giao diện sáng? | Ảnh sản phẩm có nền trắng nổi rõ trên nền sáng, dễ đọc ở các trang thông tin. Bản đầu tiên là giao diện tối neon, qua kiểm tra thấy ảnh nền trắng thành khối chói nên nhóm đổi. Đây là quyết định thiết kế, không dựa trên khảo sát. |
| Khảo sát có thật không? | Trả lời theo mục 6, điểm 1. Nói rõ cỡ mẫu, cách mã hóa, và hạn chế (mẫu thuận tiện, nghiêng về sinh viên). |
| Hệ thống bảo mật thế nào? | Mật khẩu băm bcrypt, truy vấn có tham số (chống SQL injection), chống CSRF cho mọi form POST, đổi mã phiên sau đăng nhập, đăng xuất bằng POST, kiểm tra quyền admin ở bộ định tuyến, giới hạn tin của ZenBot. |
| Giỏ hàng lưu ở đâu? | Trong session PHP. Database có bảng giỏ hàng để mở rộng khi cần lưu giỏ cho người dùng đã đăng nhập. |
| ZenBot hoạt động thế nào? | Gọi Gemini nếu có khóa API; không có thì dùng bộ câu mẫu theo chủ đề (chuột, bàn phím, tai nghe, bảo hành, giao hàng). |
| Dữ liệu sản phẩm lấy ở đâu? | Từ trang công khai của CellphoneS, tuân thủ robots.txt, tốc độ chậm; dùng làm dữ liệu mẫu cho học tập. |
| Điều gì chưa làm được? | Mục 6, điểm 4. Nói kèm kế hoạch Giai đoạn 2. |
| Đã kiểm thử thế nào? | 86 ca tự động (trang, bảo mật, đặt hàng, hủy đơn, bộ lọc, quản trị) cộng kiểm thử thủ công trên máy tính và điện thoại. Trong lúc kiểm thử đã tìm và sửa 23 lỗi, có cả báo cáo trong file `09_...`. |
| Vì sao PHP thuần, không dùng framework? | Mục tiêu môn học là hiểu kiến trúc MVC; nhóm tự viết Router, BaseController, BaseModel. |

---

## 9. Gợi ý cấu trúc slide (nếu làm slide)

1. Tên đề tài, nhóm, môn học
2. Bài toán: mua nhầm phiên bản, khó so sánh thông số (ảnh `07_chon_bien_the_to_hop_khong_co.png`)
3. Mục tiêu và phạm vi 2 giai đoạn
4. Khảo sát: cách làm (139 phản hồi, 13 câu)
5. Khảo sát: 4 biểu đồ chính (tuổi, ngân sách, khó khăn, mức quan trọng)
6. Từ khảo sát đến thiết kế (bảng ở `08_...` mục 6)
7. UI/UX: nguyên tắc, bảng màu, chữ
8. UI/UX: hai màn hình then chốt (bộ lọc, chi tiết sản phẩm)
9. Database: ERD tổng quan, 24 bảng
10. Database: ba quyết định (biến thể, EAV, giao dịch trừ kho)
11. Kết quả hiện tại: sản phẩm chạy được, số liệu kiểm thử
12. Còn lại và kế hoạch Giai đoạn 2

Mỗi slide nên có một hình, ít chữ. Hình lấy từ `hinh_anh_giao_dien/`, `bieu_do_khao_sat/`, `06_ERD_day_du.png`.

---

## 10. Lệnh hữu ích

```bash
# Chạy kiểm thử (website phải đang chạy ở localhost:8001)
python3 scratch/e2e_test.py
python3 scratch/flow_tests.py
node scratch/variant_picker_test.js

# Sinh lại số liệu và biểu đồ khảo sát sau khi sửa bảng mã hóa
python3 scratch/analyze_survey.py && python3 scratch/build_survey_md.py

# Sinh lại toàn bộ file Word từ các file .md trong docs/
python3 docs/convert_to_docx.py

# Xuất lại bản sao lưu database
/Applications/XAMPP/xamppfiles/bin/mysqldump -uroot --default-character-set=utf8mb4 --single-transaction zentech_db > database/zentech_full_dump.sql
```

Chụp lại ảnh giao diện (cần `pip install playwright`): `python3 scratch/capture_screens.py`. Vẽ lại sơ đồ: `python3 scratch/render_mermaid.py`.
- Đối chiếu yêu cầu → file: xem `00_BANG_DOI_CHIEU_YEU_CAU_VA_FILE.md`
