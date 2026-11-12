# 📋 Từ điển Dữ liệu (Data Dictionary)
## ZenTech — Website Gaming Gear & Phụ kiện máy tính

> **Phiên bản:** 1.0.0 · **Cập nhật:** 04/11/2026  
> **Hệ quản trị:** MySQL 8.0+ · `ENGINE=InnoDB` · `CHARSET=utf8mb4_unicode_ci`

---

## Quy ước ký hiệu

| Ký hiệu | Ý nghĩa |
|---------|---------|
| 🔑 PK | Primary Key — Khóa chính |
| 🔗 FK | Foreign Key — Khóa ngoại |
| NN | NOT NULL — Bắt buộc nhập |
| UQ | UNIQUE — Giá trị duy nhất |
| AI | AUTO_INCREMENT |
| D | DEFAULT — Giá trị mặc định |

---

## SECTION 1 — Phân quyền & Tài khoản

---

### Bảng `roles` — Vai trò hệ thống

> Lưu danh sách vai trò phân quyền. Mỗi `user` thuộc về một `role`.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `TINYINT UNSIGNED` | 🔑 PK · AI · NN | Định danh vai trò |
| `name` | `VARCHAR(50)` | NN · UQ | Tên vai trò: `admin`, `customer`, `staff` |
| `description` | `VARCHAR(255)` | — | Mô tả chi tiết vai trò |

---

### Bảng `users` — Tài khoản người dùng

> Lưu toàn bộ tài khoản hệ thống (admin, nhân viên và khách hàng). Phân biệt bằng `role_id`.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh người dùng |
| `role_id` | `TINYINT UNSIGNED` | 🔗 FK → `roles.id` · NN · D=2 | Vai trò (mặc định: customer) |
| `full_name` | `VARCHAR(100)` | NN | Họ và tên đầy đủ |
| `email` | `VARCHAR(150)` | NN · UQ | Địa chỉ email (dùng để đăng nhập) |
| `phone` | `VARCHAR(20)` | — | Số điện thoại liên hệ |
| `password_hash` | `VARCHAR(255)` | NN | Mật khẩu đã mã hóa (bcrypt) |
| `avatar_url` | `VARCHAR(500)` | — | URL ảnh đại diện |
| `gender` | `ENUM('male','female','other')` | — | Giới tính |
| `birthday` | `DATE` | — | Ngày sinh |
| `is_active` | `TINYINT(1)` | NN · D=1 | Trạng thái tài khoản (1=hoạt động) |
| `email_verified_at` | `DATETIME` | — | Thời điểm xác thực email (NULL=chưa xác thực) |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày tạo tài khoản |
| `updated_at` | `DATETIME` | NN | Ngày cập nhật gần nhất |

---

### Bảng `addresses` — Địa chỉ giao hàng

> Một khách hàng có thể lưu nhiều địa chỉ giao hàng. Địa chỉ mặc định dùng khi checkout nhanh.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh địa chỉ |
| `user_id` | `INT UNSIGNED` | 🔗 FK → `users.id` · NN | Chủ sở hữu địa chỉ |
| `receiver_name` | `VARCHAR(100)` | NN | Tên người nhận hàng |
| `phone` | `VARCHAR(20)` | NN | Số điện thoại người nhận |
| `province` | `VARCHAR(100)` | NN | Tỉnh / Thành phố |
| `district` | `VARCHAR(100)` | NN | Quận / Huyện |
| `ward` | `VARCHAR(100)` | NN | Phường / Xã |
| `street` | `VARCHAR(255)` | NN | Số nhà, tên đường (chi tiết) |
| `is_default` | `TINYINT(1)` | NN · D=0 | 1 = địa chỉ mặc định |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày tạo địa chỉ |

---

## SECTION 2 — Danh mục & Thương hiệu

---

### Bảng `categories` — Danh mục sản phẩm đa cấp

> Cấu trúc cây (Adjacency List). `parent_id = NULL` là danh mục gốc (cấp 1). Hệ thống hỗ trợ tối đa 3 cấp:  
> **Cấp 1** → Chuột Gaming | **Cấp 2** → Chuột Không Dây | **Cấp 3** → Chuột KD Trên 1Tr

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh danh mục |
| `parent_id` | `INT UNSIGNED` | 🔗 FK → `categories.id` · D=NULL | NULL = danh mục gốc; có giá trị = danh mục con |
| `name` | `VARCHAR(150)` | NN | Tên danh mục hiển thị |
| `slug` | `VARCHAR(200)` | NN · UQ | Đường dẫn URL thân thiện (SEO) |
| `image_url` | `VARCHAR(500)` | — | Ảnh đại diện danh mục |
| `description` | `TEXT` | — | Mô tả danh mục |
| `sort_order` | `SMALLINT` | NN · D=0 | Thứ tự hiển thị trên menu |
| `is_active` | `TINYINT(1)` | NN · D=1 | 1=hiển thị; 0=ẩn |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày tạo |

---

### Bảng `brands` — Thương hiệu

> Lưu thông tin thương hiệu. Mỗi sản phẩm thuộc về đúng một thương hiệu.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh thương hiệu |
| `name` | `VARCHAR(100)` | NN | Tên thương hiệu (Logitech, Razer...) |
| `slug` | `VARCHAR(120)` | NN · UQ | Đường dẫn URL (logitech, razer...) |
| `logo_url` | `VARCHAR(500)` | — | URL logo thương hiệu |
| `country` | `VARCHAR(100)` | — | Quốc gia xuất xứ |
| `description` | `TEXT` | — | Mô tả thương hiệu |
| `is_active` | `TINYINT(1)` | NN · D=1 | 1=hiển thị; 0=ẩn |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày tạo |

---

## SECTION 3 — Sản phẩm & Biến thể

---

### Bảng `products` — Sản phẩm chính

> Thông tin tổng quan của sản phẩm. Giá bán chi tiết nằm ở `product_variants`.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh sản phẩm |
| `category_id` | `INT UNSIGNED` | 🔗 FK → `categories.id` · NN | Danh mục lá (cấp sâu nhất) của sản phẩm |
| `brand_id` | `INT UNSIGNED` | 🔗 FK → `brands.id` · NN | Thương hiệu sản phẩm |
| `name` | `VARCHAR(255)` | NN | Tên sản phẩm đầy đủ |
| `slug` | `VARCHAR(300)` | NN · UQ | Đường dẫn URL thân thiện |
| `sku` | `VARCHAR(100)` | — | Mã sản phẩm tổng (product master SKU) |
| `short_desc` | `TEXT` | — | Mô tả ngắn (hiển thị trong card sản phẩm) |
| `full_desc` | `LONGTEXT` | — | Mô tả chi tiết (HTML hỗ trợ) |
| `thumbnail_url` | `VARCHAR(500)` | — | Ảnh đại diện chính |
| `base_price` | `DECIMAL(12,0)` | NN · D=0 | Giá tham chiếu (dùng hiển thị khi chưa chọn biến thể) |
| `is_featured` | `TINYINT(1)` | NN · D=0 | 1 = sản phẩm nổi bật (hiển thị trang chủ) |
| `is_active` | `TINYINT(1)` | NN · D=1 | 1=đang bán; 0=ngừng kinh doanh |
| `view_count` | `INT UNSIGNED` | NN · D=0 | Tổng lượt xem trang chi tiết SP |
| `sold_count` | `INT UNSIGNED` | NN · D=0 | Tổng số lượng đã bán |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày đăng sản phẩm |
| `updated_at` | `DATETIME` | NN | Ngày cập nhật gần nhất |

---

### Bảng `product_images` — Ảnh gallery sản phẩm

> Lưu nhiều ảnh cho một sản phẩm. Ảnh sắp xếp theo `sort_order`.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh ảnh |
| `product_id` | `INT UNSIGNED` | 🔗 FK → `products.id` · NN | Sản phẩm sở hữu ảnh |
| `image_url` | `VARCHAR(500)` | NN | URL ảnh (CDN hoặc local) |
| `alt_text` | `VARCHAR(255)` | — | Văn bản thay thế ảnh (hỗ trợ SEO) |
| `sort_order` | `TINYINT` | NN · D=0 | Thứ tự hiển thị trong gallery |

---

### Bảng `attribute_groups` — Nhóm thuộc tính kỹ thuật

> Gom các thuộc tính liên quan vào một nhóm để hiển thị theo block trong trang SP.  
> Ví dụ: *"Thông số cảm biến"* gồm DPI, Loại cảm biến, Tốc độ theo dõi.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh nhóm |
| `name` | `VARCHAR(100)` | NN | Tên nhóm thuộc tính |
| `sort_order` | `TINYINT` | NN · D=0 | Thứ tự hiển thị nhóm |

---

### Bảng `attributes` — Tên thuộc tính kỹ thuật (EAV Key)

> Định nghĩa tên & đơn vị của từng thuộc tính kỹ thuật.  
> Áp dụng mô hình **EAV (Entity–Attribute–Value)** để lưu thông số linh hoạt theo loại sản phẩm.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh thuộc tính |
| `group_id` | `INT UNSIGNED` | 🔗 FK → `attribute_groups.id` | Nhóm chứa thuộc tính này |
| `name` | `VARCHAR(150)` | NN | Tên thuộc tính (DPI tối đa, Trọng lượng...) |
| `unit` | `VARCHAR(30)` | — | Đơn vị đo (g, Hz, giờ, DPI) |
| `sort_order` | `TINYINT` | NN · D=0 | Thứ tự hiển thị trong nhóm |
| `is_filterable` | `TINYINT(1)` | NN · D=0 | 1 = hiển thị ở bộ lọc sidebar |

---

### Bảng `product_attributes` — Giá trị thuộc tính kỹ thuật (EAV Value)

> Lưu giá trị cụ thể của thuộc tính cho từng sản phẩm.  
> Ví dụ: Sản phẩm #1 (Logitech GPX SL2) có `attribute_id=1` (DPI) = `"25600"`.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh bản ghi |
| `product_id` | `INT UNSIGNED` | 🔗 FK → `products.id` · NN · UQ(product,attr) | Sản phẩm sở hữu thuộc tính |
| `attribute_id` | `INT UNSIGNED` | 🔗 FK → `attributes.id` · NN | Loại thuộc tính |
| `value` | `VARCHAR(500)` | NN | Giá trị (ví dụ: `25600`, `Optical`, `RGB`) |

---

### Bảng `variant_options` — Tên tùy chọn biến thể

> Định nghĩa các chiều tùy chọn tạo nên biến thể.  
> Ví dụ: `Màu sắc`, `Kết nối`, `Loại Switch`.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh tùy chọn |
| `name` | `VARCHAR(80)` | NN · UQ | Tên tùy chọn (Màu sắc, Kết nối, Switch) |

---

### Bảng `variant_option_values` — Giá trị tùy chọn biến thể

> Lưu từng giá trị cụ thể của một tùy chọn.  
> Ví dụ: Tùy chọn `Màu sắc` → Đen, Trắng, Hồng.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh giá trị |
| `option_id` | `INT UNSIGNED` | 🔗 FK → `variant_options.id` · NN | Tùy chọn cha |
| `value` | `VARCHAR(100)` | NN | Giá trị (Đen, Trắng, Wireless 2.4G...) |
| `color_hex` | `VARCHAR(10)` | — | Mã màu HEX (chỉ dùng khi option là Màu sắc) |

---

### Bảng `product_variants` — Biến thể sản phẩm

> Mỗi biến thể là một tổ hợp tùy chọn cụ thể (màu × kết nối × switch).  
> **Đây là đơn vị tồn kho, giá bán và giỏ hàng thực tế.**

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh biến thể |
| `product_id` | `INT UNSIGNED` | 🔗 FK → `products.id` · NN | Sản phẩm chính |
| `sku` | `VARCHAR(120)` | NN · UQ | Mã SKU riêng của biến thể (VD: LOG-GPXSL2-BLK) |
| `price` | `DECIMAL(12,0)` | NN | Giá bán niêm yết (VNĐ) |
| `sale_price` | `DECIMAL(12,0)` | — | Giá khuyến mãi; NULL = không khuyến mãi |
| `stock_qty` | `INT UNSIGNED` | NN · D=0 | Số lượng tồn kho hiện tại |
| `image_url` | `VARCHAR(500)` | — | Ảnh riêng của biến thể (thường là ảnh theo màu) |
| `is_active` | `TINYINT(1)` | NN · D=1 | 1=đang bán; 0=ngừng bán |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày tạo |
| `updated_at` | `DATETIME` | NN | Ngày cập nhật |

---

### Bảng `variant_attribute_values` — Ánh xạ biến thể ↔ tùy chọn

> Bảng trung gian nhiều-nhiều. Liên kết biến thể với các giá trị tùy chọn tương ứng.  
> Ví dụ: Biến thể `LOG-GPXSL2-BLK` → `Màu: Đen` + `Kết nối: Wireless 2.4G`.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `variant_id` | `INT UNSIGNED` | 🔑🔗 PK+FK → `product_variants.id` · NN | Biến thể sản phẩm |
| `option_value_id` | `INT UNSIGNED` | 🔑🔗 PK+FK → `variant_option_values.id` · NN | Giá trị tùy chọn |

> *Khóa chính tổ hợp: `(variant_id, option_value_id)`*

---

## SECTION 4 — Giỏ hàng & Đơn hàng

---

### Bảng `carts` — Giỏ hàng

> Mỗi phiên mua hàng tạo một giỏ. Hỗ trợ cả khách đăng nhập (qua `user_id`) và khách vãng lai (qua `session_id`).

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh giỏ hàng |
| `user_id` | `INT UNSIGNED` | 🔗 FK → `users.id` | NULL = khách vãng lai |
| `session_id` | `VARCHAR(128)` | — | Session ID cho khách vãng lai |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày tạo giỏ |
| `updated_at` | `DATETIME` | NN | Ngày cập nhật giỏ |

---

### Bảng `cart_items` — Chi tiết giỏ hàng

> Lưu từng sản phẩm (theo biến thể) được thêm vào giỏ hàng.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh dòng giỏ hàng |
| `cart_id` | `INT UNSIGNED` | 🔗 FK → `carts.id` · NN | Giỏ hàng chứa sản phẩm |
| `variant_id` | `INT UNSIGNED` | 🔗 FK → `product_variants.id` · NN | Biến thể sản phẩm được chọn |
| `quantity` | `SMALLINT UNSIGNED` | NN · D=1 | Số lượng |

> *Ràng buộc UNIQUE `(cart_id, variant_id)`: mỗi biến thể chỉ xuất hiện 1 lần/giỏ*

---

### Bảng `orders` — Đơn hàng

> Lưu thông tin đơn hàng. Địa chỉ nhận hàng & giá được **snapshot** (sao chép) tại thời điểm đặt hàng để tránh thay đổi sau.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh đơn hàng |
| `user_id` | `INT UNSIGNED` | 🔗 FK → `users.id` | Người đặt hàng (NULL nếu khách vãng lai) |
| `order_code` | `VARCHAR(30)` | NN · UQ | Mã đơn hàng hiển thị (ZT20261104001) |
| `receiver_name` | `VARCHAR(100)` | NN | Tên người nhận (snapshot) |
| `receiver_phone` | `VARCHAR(20)` | NN | SĐT người nhận (snapshot) |
| `shipping_address` | `TEXT` | NN | Địa chỉ giao hàng đầy đủ (snapshot) |
| `payment_method` | `ENUM` | NN · D='cod' | Phương thức: `cod`, `vnpay`, `momo`, `bank_transfer` |
| `payment_status` | `ENUM` | NN · D='unpaid' | Trạng thái thanh toán: `unpaid`, `paid`, `refunded` |
| `subtotal` | `DECIMAL(14,0)` | NN · D=0 | Tổng tiền hàng (chưa gồm phí ship, chưa giảm) |
| `shipping_fee` | `DECIMAL(10,0)` | NN · D=0 | Phí vận chuyển |
| `discount_amount` | `DECIMAL(10,0)` | NN · D=0 | Số tiền được giảm (voucher, khuyến mãi) |
| `total_amount` | `DECIMAL(14,0)` | NN · D=0 | Tổng thanh toán = subtotal + ship − discount |
| `status` | `ENUM` | NN · D='pending' | Trạng thái đơn: `pending`, `confirmed`, `processing`, `shipping`, `delivered`, `cancelled`, `returned` |
| `note` | `TEXT` | — | Ghi chú của khách hàng |
| `cancelled_reason` | `TEXT` | — | Lý do hủy đơn hàng |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày đặt hàng |
| `updated_at` | `DATETIME` | NN | Ngày cập nhật trạng thái |

---

### Bảng `order_items` — Chi tiết sản phẩm trong đơn hàng

> Lưu từng dòng sản phẩm trong đơn. Tên & giá sản phẩm được **snapshot** để bảo toàn lịch sử dù sản phẩm có thay đổi sau này.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh dòng đơn hàng |
| `order_id` | `INT UNSIGNED` | 🔗 FK → `orders.id` · NN | Đơn hàng chứa sản phẩm |
| `variant_id` | `INT UNSIGNED` | 🔗 FK → `product_variants.id` | Biến thể SP (NULL nếu SP đã xóa) |
| `product_name` | `VARCHAR(255)` | NN | Tên SP tại thời điểm đặt hàng (snapshot) |
| `variant_info` | `VARCHAR(255)` | — | Mô tả biến thể dạng text (VD: `Đen \| Wireless`) |
| `unit_price` | `DECIMAL(12,0)` | NN | Đơn giá tại thời điểm đặt (snapshot) |
| `quantity` | `SMALLINT UNSIGNED` | NN | Số lượng |
| `total_price` | `DECIMAL(14,0)` | NN | Thành tiền = unit_price × quantity |

---

### Bảng `order_status_logs` — Lịch sử trạng thái đơn hàng

> Ghi lại mỗi lần trạng thái đơn thay đổi, ai thay đổi và lý do. Phục vụ theo dõi & kiểm tra lịch sử.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh log |
| `order_id` | `INT UNSIGNED` | 🔗 FK → `orders.id` · NN | Đơn hàng liên quan |
| `old_status` | `VARCHAR(30)` | — | Trạng thái trước khi thay đổi |
| `new_status` | `VARCHAR(30)` | NN | Trạng thái sau khi thay đổi |
| `changed_by` | `INT UNSIGNED` | 🔗 FK → `users.id` | Người thực hiện thay đổi (admin/staff) |
| `note` | `TEXT` | — | Ghi chú kèm theo thay đổi |
| `created_at` | `DATETIME` | NN · D=NOW() | Thời điểm ghi log |

---

## SECTION 5 — Đánh giá & Bình luận

---

### Bảng `reviews` — Đánh giá sản phẩm

> Chỉ khách hàng đã mua hàng (có `order_id` hợp lệ) mới được đánh giá sản phẩm. Admin duyệt trước khi hiển thị.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh đánh giá |
| `product_id` | `INT UNSIGNED` | 🔗 FK → `products.id` · NN | Sản phẩm được đánh giá |
| `user_id` | `INT UNSIGNED` | 🔗 FK → `users.id` · NN | Người viết đánh giá |
| `order_id` | `INT UNSIGNED` | 🔗 FK → `orders.id` | Đơn hàng xác nhận đã mua |
| `rating` | `TINYINT UNSIGNED` | NN · CHECK(1–5) | Số sao đánh giá (1 đến 5) |
| `title` | `VARCHAR(255)` | — | Tiêu đề đánh giá |
| `content` | `TEXT` | — | Nội dung đánh giá chi tiết |
| `is_approved` | `TINYINT(1)` | NN · D=0 | 1 = admin đã duyệt; 0 = chờ duyệt |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày gửi đánh giá |

---

### Bảng `review_images` — Ảnh đính kèm đánh giá

> Khách hàng có thể đính kèm nhiều ảnh thực tế cùng đánh giá.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh ảnh |
| `review_id` | `INT UNSIGNED` | 🔗 FK → `reviews.id` · NN | Đánh giá chứa ảnh |
| `image_url` | `VARCHAR(500)` | NN | URL ảnh đính kèm |

---

## SECTION 6 — AI Assistant

---

### Bảng `ai_conversations` — Phiên hội thoại AI

> Mỗi lần người dùng bắt đầu tư vấn với AI Assistant tạo ra một phiên hội thoại mới.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh phiên hội thoại |
| `user_id` | `INT UNSIGNED` | 🔗 FK → `users.id` | NULL = khách vãng lai |
| `session_id` | `VARCHAR(128)` | NN | Session ID để nhận diện khách vãng lai |
| `title` | `VARCHAR(255)` | — | Tiêu đề tóm tắt cuộc hội thoại (AI tự sinh) |
| `created_at` | `DATETIME` | NN · D=NOW() | Thời điểm bắt đầu hội thoại |
| `updated_at` | `DATETIME` | NN | Thời điểm tin nhắn cuối |

---

### Bảng `ai_messages` — Nội dung tin nhắn AI

> Lưu từng lượt hỏi/đáp trong phiên hội thoại. Hỗ trợ phân tích hành vi người dùng & cải thiện AI.

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh tin nhắn |
| `conversation_id` | `INT UNSIGNED` | 🔗 FK → `ai_conversations.id` · NN | Phiên hội thoại chứa tin nhắn |
| `role` | `ENUM('user','assistant')` | NN | Người gửi: `user` = khách; `assistant` = AI |
| `content` | `TEXT` | NN | Nội dung tin nhắn |
| `tokens_used` | `SMALLINT UNSIGNED` | — | Số token API đã tiêu thụ (theo dõi chi phí) |
| `created_at` | `DATETIME` | NN · D=NOW() | Thời điểm gửi tin nhắn |

---

## SECTION 7 — Khuyến mãi & Voucher

---

### Bảng `coupons` — Mã giảm giá

> Lưu thông tin mã voucher. Hỗ trợ hai loại: giảm theo phần trăm (`percent`) hoặc số tiền cố định (`fixed`).

| Tên trường | Kiểu dữ liệu | Ràng buộc | Mô tả nghiệp vụ |
|-----------|--------------|-----------|-----------------|
| `id` | `INT UNSIGNED` | 🔑 PK · AI · NN | Định danh voucher |
| `code` | `VARCHAR(50)` | NN · UQ | Mã voucher (ZENTECH10, GAMING200K...) |
| `description` | `VARCHAR(255)` | — | Mô tả nội dung khuyến mãi |
| `discount_type` | `ENUM('percent','fixed')` | NN · D='percent' | Loại giảm giá |
| `discount_value` | `DECIMAL(10,2)` | NN | Giá trị giảm (10 = 10% hoặc 200000 = 200.000 ₫) |
| `min_order_value` | `DECIMAL(12,0)` | NN · D=0 | Giá trị đơn hàng tối thiểu để áp dụng |
| `max_uses` | `INT UNSIGNED` | — | Số lần sử dụng tối đa; NULL = không giới hạn |
| `used_count` | `INT UNSIGNED` | NN · D=0 | Số lần đã được sử dụng |
| `starts_at` | `DATETIME` | — | Ngày bắt đầu hiệu lực |
| `expires_at` | `DATETIME` | — | Ngày hết hạn |
| `is_active` | `TINYINT(1)` | NN · D=1 | 1=đang hoạt động; 0=đã vô hiệu hóa |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày tạo voucher |

---

### Bảng `order_coupons` — Mã giảm giá đã dùng cho đơn hàng

> Mỗi đơn dùng tối đa một mã. Bảng này giúp hoàn lại lượt dùng của mã khi đơn bị hủy hoặc trả hàng.

| Cột | Kiểu | Ràng buộc | Mô tả |
|-----|------|-----------|-------|
| `order_id` | `INT UNSIGNED` | PK · FK → `orders.id` (ON DELETE CASCADE) | Đơn hàng đã dùng mã |
| `coupon_id` | `INT UNSIGNED` | NN · FK → `coupons.id` | Mã giảm giá đã áp dụng |

---

### Bảng `password_resets` — Đặt lại mật khẩu

> Mỗi yêu cầu "Quên mật khẩu" tạo một dòng. Chỉ lưu SHA-256 của token, token gốc chỉ có trong liên kết gửi cho người dùng. Hiệu lực 30 phút, dùng một lần.

| Cột | Kiểu | Ràng buộc | Mô tả |
|-----|------|-----------|-------|
| `id` | `INT UNSIGNED` | PK · AI | Khóa chính |
| `user_id` | `INT UNSIGNED` | NN · FK → `users.id` (ON DELETE CASCADE) | Tài khoản yêu cầu |
| `token_hash` | `CHAR(64)` | NN · INDEX | SHA-256 của token |
| `expires_at` | `DATETIME` | NN | Hết hạn |
| `used_at` | `DATETIME` | — | Thời điểm đã dùng; NULL = chưa dùng |
| `created_at` | `DATETIME` | NN · D=NOW() | Ngày tạo |

---

## Tổng kết thống kê

| Thống kê | Giá trị |
|---------|---------|
| Tổng số bảng | **26 bảng** |
| Bảng thực thể chính | 16 |
| Bảng trung gian (n-n) | 4 (`variant_attribute_values`, `cart_items`, `order_items`, `order_coupons`) |
| Bảng log/audit | 2 (`order_status_logs`, `ai_messages`) |
| Tổng quan hệ FK | **29 khóa ngoại** |
| Mock data sản phẩm | 10 sản phẩm · 19 biến thể |
| Danh mục | 13 (2 cấp) |
| Thương hiệu | 5 |

---

> [!NOTE]
> Tài liệu này được tạo theo chuẩn báo cáo môn học **Dự án 1 — Giai đoạn 1**. File SQL đầy đủ chạy được trên phpMyAdmin nằm tại `database/zentech_schema.sql`.
