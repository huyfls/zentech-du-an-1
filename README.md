# ZenTech: website bán Gaming Gear

Đồ án môn Dự án 1, Lập trình website. Chuột, bàn phím cơ và tai nghe, mỗi sản phẩm có màu, phiên bản, giá và tồn kho riêng.

**Công nghệ:** PHP 8 thuần theo mô hình MVC, MySQL qua PDO, Tailwind CSS, JavaScript thuần, trợ lý AI ZenBot (Gemini, có bộ câu mẫu khi chưa có khóa API).

## Chức năng

- Danh sách sản phẩm với bộ lọc dạng cửa sổ: nhiều loại, nhiều thương hiệu, khoảng giá, sắp xếp, phân trang.
- Trang chi tiết: bộ ảnh, chọn màu và phiên bản (giá, ảnh, tồn kho đổi ngay), thông số kỹ thuật, đánh giá.
- Tìm kiếm nhanh bằng `Ctrl + K`, giỏ hàng, thanh toán một trang, lịch sử và hủy đơn.
- Đặt hàng bằng giao dịch cơ sở dữ liệu (`SELECT ... FOR UPDATE`), hủy đơn hoàn lại tồn kho.
- Đăng ký, đăng nhập, chống CSRF và cố định phiên.
- Quản trị: tổng quan, sản phẩm nhiều biến thể, đơn hàng theo luồng trạng thái hợp lệ.

## Cấu trúc thư mục

```
app/            controllers, models, views, core (Router, BaseController, BaseModel, Csrf)
config/         app.php (cấu hình), database.php (kết nối PDO)
database/       zentech_schema.sql (26 bảng, 10 sản phẩm mẫu), zentech_full_dump.sql (dữ liệu đầy đủ)
public/         index.php (điểm vào), assets (css, js, vendor, fonts), uploads/products (ảnh sản phẩm), api/ai-assistant.php
docs/           tài liệu nguồn (.md), bản mẫu giao diện; thư mục "tuần 1 - dự án 1" chứa file nộp (Word, PDF, khảo sát)
scratch/        script kiểm thử, thu thập và nạp dữ liệu, phân tích khảo sát
PRODUCT.md      mô tả sản phẩm và người dùng mục tiêu
```

## Chạy trên máy

1. Bật MySQL trong XAMPP. Trong phpMyAdmin, nhập (Import) một trong hai file:
   - `database/zentech_full_dump.sql`: dữ liệu đầy đủ (330 sản phẩm, 34 thương hiệu, ảnh, biến thể). Khuyến nghị.
   - `database/zentech_schema.sql`: chỉ cấu trúc 26 bảng và 10 sản phẩm mẫu.
2. Chạy website:
   ```bash
   /Applications/XAMPP/xamppfiles/bin/php -S localhost:8001 -t public/
   ```
   Mở `http://localhost:8001`.

Website không cần internet: Tailwind, phông chữ và ảnh sản phẩm đều nằm trong `public/`.

## Tài khoản demo

| Vai trò | Email | Mật khẩu |
|---|---|---|
| Quản trị viên | `thanhhuyfls@gmail.com` | `huy103` |
| Khách hàng | `nguyenvanan@gmail.com` | `Password@123` |
| Khách hàng | `tranthibinh@gmail.com` | `Password@123` |

## Cấu hình

Mặc định dùng cấu hình XAMPP (MySQL `root`, không mật khẩu, `APP_ENV=development` khi chạy ở `localhost`). Trên máy chủ thật đặt biến môi trường: `APP_ENV`, `APP_URL`, `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS`, `GEMINI_API_KEY`, và dùng tài khoản MySQL riêng thay vì `root`.

## Kiểm thử

Khi website đang chạy ở `localhost:8001`:

```bash
python3 scratch/e2e_test.py          # trang, bảo mật, đơn hàng, quản trị
python3 scratch/flow_tests.py        # luồng nghiệp vụ và các lỗi đã sửa
node scratch/variant_picker_test.js  # logic chọn biến thể
```

Các script tự tạo dữ liệu thử và xóa sau khi chạy.

## Dữ liệu sản phẩm

Tên, giá và ảnh lấy từ các trang công khai của CellphoneS làm dữ liệu mẫu (`scratch/crawl_cellphones.py`, `scratch/import_cellphones.py`, `scratch/localize_images.py`). Tồn kho, lượt bán, lượt xem là số giả lập. Ảnh và giá chỉ để học tập, không dùng cho mục đích thương mại.

## Tài liệu

Tài liệu Giai đoạn 1 nằm trong `docs/tuần 1 - dự án 1/`; bắt đầu từ `README_CHUAN_BI_BAO_CAO_GIAI_DOAN_1.md` (danh sách file, kịch bản trình bày, câu hỏi dự kiến). Sửa file `.md` trong `docs/` rồi chạy `python3 docs/convert_to_docx.py` để sinh lại file Word. Phân tích khảo sát: `python3 scratch/analyze_survey.py`. Ảnh giao diện: `scratch/capture_screens.py`. Sơ đồ Mermaid: `scratch/render_mermaid.py`.

## Chạy trên Windows (thành viên nhóm)

Xem [docs/HUONG_DAN_CHAY_TREN_WINDOWS.md](docs/HUONG_DAN_CHAY_TREN_WINDOWS.md). Tóm tắt: cài XAMPP (PHP 8.2) → Download ZIP repo này → Start MySQL trong XAMPP → bấm đúp `windows\1_cai_dat.bat` (lần đầu) → bấm đúp `windows\2_chay_web.bat`.

## Dữ liệu sản phẩm Apple (lấy từ CellphoneS)

73 dòng máy Apple (iPhone, iPad, Mac, Apple Watch, AirPods; không gồm phụ kiện) với 684 biến thể phiên bản × màu, giá và ảnh gốc.
Dữ liệu đã có sẵn trong `database/zentech_full_dump.sql`. Ảnh gốc (~1,6GB) không nằm trong repo mà ở mục
[Releases](https://github.com/huyfls/zentech-du-an-1/releases/tag/anh-apple-v1): tải `apple_images.zip`, giải nén vào `public/uploads/products/`
(trên Windows `1_cai_dat.bat` tự làm bước này). Muốn lấy lại dữ liệu mới nhất từ CellphoneS:

```bash
python3 scratch/cellphones/crawl.py   # lấy danh sách + trang chi tiết -> scratch/cellphones/data.json
python3 scratch/cellphones/build.py   # tải ảnh gốc vào public/uploads/products/apple/ và sinh database/seeds/2026_11_25_apple_cellphones.sql
mysql -uroot zentech_db < database/seeds/2026_11_25_apple_cellphones.sql
```

File SQL chạy lại được nhiều lần (xóa sản phẩm SKU `CPS-*` cũ trước khi nhập). 3 dòng máy được xem nhiều nhất mỗi nhóm trên CellphoneS được đánh dấu nổi bật.
