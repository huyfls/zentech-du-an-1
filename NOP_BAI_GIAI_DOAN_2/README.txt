ZENTECH - NỘP BÀI GIAI ĐOẠN 2 (Dự án 1 - Lập trình website, Nhóm 1)
Trưởng nhóm: Lê Thành Huy - PA00423
GitHub: https://github.com/huyfls/zentech-du-an-1

01_Bao_Cao_Giai_Doan_2_ZenTech.docx   Báo cáo tổng kết (chức năng, CSDL, bảo mật, kiểm thử)
02_Huong_Dan_Cai_Dat_Va_Chay.docx     Hướng dẫn cài đặt, chạy, tài khoản demo
03_Bao_Cao_Kiem_Thu_ZenTech.docx      Báo cáo kiểm thử (159/159 test pass)
04_Slide_Thuyet_Trinh.pptx            Slide thuyết trình
ZenTech_SourceCode.zip                Toàn bộ source code (app, config, public, database, test)
2_Database/zentech_full_dump.sql      CSDL đầy đủ dữ liệu mẫu (import vào zentech_db)
2_Database/zentech_schema.sql         Chỉ cấu trúc bảng

Chạy nhanh:
  1. Bật MySQL (XAMPP), tạo CSDL zentech_db, import 2_Database/zentech_full_dump.sql
  2. Giải nén ZenTech_SourceCode.zip, vào thư mục ZenTech
  3. php -S localhost:8001 -t public/
  4. Mở http://localhost:8001  (admin: /admin)
