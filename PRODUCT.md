# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

PHP 8 thuần (MVC tự viết), MySQL qua PDO, Tailwind CSS bản tải sẵn trong `public/assets/vendor` (cấu hình ở `public/assets/js/tailwind-theme.js`), Vanilla JS. Chạy bằng `php -S` trên localhost, không có bước build.

## Product

ZenTech là website thương mại điện tử bán gaming gear (chuột, bàn phím cơ, tai nghe, lót chuột) cho thị trường Việt Nam. Giao diện tiếng Việt. Gồm cửa hàng cho khách (danh sách, bộ lọc, chi tiết sản phẩm theo biến thể màu/phiên bản, giỏ hàng, thanh toán, lịch sử đơn) và khu quản trị (sản phẩm, đơn hàng, tồn kho). Có trợ lý AI ZenBot tư vấn chọn gear.

## Users

Game thủ 16-28 tuổi mua cho bản thân: học sinh, sinh viên, người đi làm trẻ. Tự tìm hiểu thông số, ngân sách khoảng 0,5-4 triệu đồng. Dùng cả điện thoại và máy tính. Quản trị viên là một người nội bộ dùng khu admin để xử lý đơn và kho.

## Positioning

Khác shop gaming gear thông thường ở hai điểm: (1) chọn theo thông số, so sánh biến thể rõ ràng: mỗi sản phẩm ghi cảm biến, switch, trọng lượng, pin; chọn màu/phiên bản thì giá và tồn kho cập nhật ngay; (2) trợ lý AI ZenBot tư vấn theo ngân sách và nhu cầu.

## Context

Đồ án môn học "Dự án 1 - Lập trình website", chạy local để demo cho giảng viên, chưa bán hàng thật. Cần gây ấn tượng về thiết kế và chức năng, nhưng nội dung phải trung thực.

## Facts to preserve

- Chính sách có thật trong hệ thống: miễn phí vận chuyển từ 500.000₫ (dưới mức đó 30.000₫), đổi trả 7 ngày, bảo hành 12 tháng. Thanh toán: COD, chuyển khoản, MoMo.
- Không có hệ thống mã giảm giá; không được quảng cáo voucher.
- Dữ liệu sản phẩm lấy từ DB (330 sản phẩm, 34 thương hiệu), nguồn là các trang công khai của CellphoneS, dùng làm dữ liệu mẫu.
- Ảnh sản phẩm được lưu trong `public/uploads/products`; vẫn cần ảnh dự phòng cho sản phẩm không có ảnh.
- Không bịa số liệu khách hàng, đánh giá hay chứng thực.

## Constraints

- Phải chạy không cần bước build; CSS/JS tĩnh trong `public/assets`.
- Phải hoạt động tốt ở điện thoại 375px và máy tính.
- Tiếng Việt đầy đủ dấu: phông chữ phải có subset vietnamese.

## Decisions

- Phong cách thị giác: nền sáng tối giản (tham chiếu Apple Store, Nothing), một màu nhấn xanh dương, phông Be Vietnam Pro. Người dùng chọn hướng "chuẩn ngành" trên trang quyết định. Chi tiết trong `docs/ZenTech_UIUX_Specification.md`.
