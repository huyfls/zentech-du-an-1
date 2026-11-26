# Hướng dẫn tải và chạy ZenTech trên Windows

Dành cho các thành viên Nhóm 1. Làm theo đúng thứ tự, lần đầu mất khoảng 15–20 phút (phần lớn là thời gian tải).

## Cần chuẩn bị

| Thứ cần có | Ghi chú |
|---|---|
| Windows 10 hoặc 11 | |
| XAMPP bản **PHP 8.2** | Tải tại https://www.apachefriends.org, cài vào thư mục mặc định `C:\xampp` |
| Khoảng 3 GB trống | Code + ảnh sản phẩm Apple (1,6 GB) |

Không cần cài Git, không cần bật Apache. Chỉ cần **MySQL** của XAMPP.

## Bước 1 – Tải source code

1. Mở https://github.com/huyfls/zentech-du-an-1
2. Bấm nút xanh **Code** → **Download ZIP**.
3. Giải nén ra một thư mục **không có dấu tiếng Việt và khoảng trắng**, ví dụ `D:\zentech`.
   Sau khi giải nén phải thấy các thư mục `app`, `public`, `database`, `windows` nằm ngay trong `D:\zentech`
   (nếu bị lồng thêm một lớp `zentech-du-an-1-main`, chọn thư mục bên trong đó).

> Repo chỉ cho xem và tải về, thành viên không sửa được code trên GitHub.

## Bước 2 – Bật MySQL

1. Mở **XAMPP Control Panel** (`C:\xampp\xampp-control.exe`).
2. Bấm **Start** ở dòng **MySQL**, chờ chữ MySQL chuyển nền xanh.

## Bước 3 – Cài đặt lần đầu

Mở thư mục `windows` trong code, bấm đúp **`1_cai_dat.bat`**. File này sẽ:

1. Kiểm tra PHP và các extension cần thiết (`pdo_mysql`, `mbstring`, `fileinfo`).
2. Kiểm tra MySQL đang chạy.
3. Tạo database `zentech_db` và nạp toàn bộ dữ liệu (403 sản phẩm, tài khoản demo, đơn mẫu).
4. Tải ảnh sản phẩm Apple (1,6 GB) từ mục Releases của GitHub và giải nén vào `public\uploads\products\apple`.

Nếu Windows hiện cảnh báo "Windows protected your PC", bấm **More info** → **Run anyway**.

> Chạy lại `1_cai_dat.bat` sẽ **ghi đè** database bằng dữ liệu gốc (mất đơn hàng, tài khoản bạn tạo thêm khi test). Ảnh đã tải thì không tải lại.

## Bước 4 – Chạy website

Bấm đúp **`windows\2_chay_web.bat`**. Trình duyệt tự mở http://localhost:8001.
Giữ cửa sổ đen đó mở trong lúc dùng web; đóng cửa sổ là tắt web.

Những lần sau chỉ cần: bật MySQL trong XAMPP → bấm đúp `2_chay_web.bat`.

## Tài khoản demo

| Vai trò | Email | Mật khẩu |
|---|---|---|
| Quản trị viên | thanhhuyfls@gmail.com | huy103 |
| Khách hàng | nguyenvanan@gmail.com | Password@123 |
| Khách hàng | tranthibinh@gmail.com | Password@123 |

Trang quản trị: http://localhost:8001/admin

## Gặp lỗi thì làm gì

| Hiện tượng | Cách xử lý |
|---|---|
| `Khong tim thay XAMPP tai C:\xampp` | XAMPP cài chỗ khác: mở 2 file `.bat` bằng Notepad, sửa dòng `set "XAMPP=C:\xampp"` thành đúng thư mục |
| `MySQL chua chay` | Mở XAMPP Control Panel → Start MySQL |
| MySQL không Start được (báo cổng 3306 bị chiếm) | Tắt MySQL/MariaDB khác đang chạy trên máy, hoặc khởi động lại máy |
| `Thieu extension ...` | Mở `C:\xampp\php\php.ini` bằng Notepad, tìm dòng `;extension=...` tương ứng, xóa dấu `;` ở đầu, lưu lại |
| Trang báo lỗi cổng 8001 đang dùng | Mở `2_chay_web.bat` bằng Notepad, đổi `set "PORT=8001"` thành `8002` |
| Sản phẩm Apple không có ảnh | Tải tay file `apple_images.zip` ở https://github.com/huyfls/zentech-du-an-1/releases, giải nén vào `public\uploads\products\` (sau khi giải nén phải có thư mục `public\uploads\products\apple`) |
| Chữ tiếng Việt bị lỗi trong web | Database nạp sai bảng mã: chạy lại `1_cai_dat.bat` |

## Cách chạy thủ công (không dùng file .bat)

Mở **Command Prompt** tại thư mục code rồi chạy lần lượt:

```bat
C:\xampp\mysql\bin\mysql.exe -uroot -e "CREATE DATABASE IF NOT EXISTS zentech_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
C:\xampp\mysql\bin\mysql.exe -uroot --default-character-set=utf8mb4 zentech_db < database\zentech_full_dump.sql
C:\xampp\php\php.exe -S localhost:8001 -t public
```

Hoặc dùng phpMyAdmin (cần Start thêm Apache): http://localhost/phpmyadmin → tạo database `zentech_db` (utf8mb4_unicode_ci) → tab **Import** → chọn `database\zentech_full_dump.sql`.
