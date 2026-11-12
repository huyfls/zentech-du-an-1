-- =============================================================
--  ZenTech - Website bán phụ kiện máy tính & Gaming Gear
--  Database Schema - MySQL 8.0+
--  Engine: InnoDB | Charset: utf8mb4 | Collation: utf8mb4_unicode_ci
--  Tác giả  : ZenTech Dev Team
--  Phiên bản: 1.0.0
--  Ngày tạo : 2026-11-04
-- =============================================================

CREATE DATABASE IF NOT EXISTS zentech_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE zentech_db;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- =============================================================
-- SECTION 1: PHÂN QUYỀN & TÀI KHOẢN
-- =============================================================

-- -------------------------------------------------------
-- 1.1 roles — Vai trò người dùng (Admin, Customer, Staff...)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS roles (
    id          TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50)       NOT NULL COMMENT 'admin | customer | staff',
    description VARCHAR(255)               DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_roles_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Danh sách vai trò trong hệ thống';

-- -------------------------------------------------------
-- 1.2 users — Tài khoản người dùng
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id            INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    role_id       TINYINT UNSIGNED  NOT NULL DEFAULT 2  COMMENT 'FK → roles.id',
    full_name     VARCHAR(100)      NOT NULL,
    email         VARCHAR(150)      NOT NULL,
    phone         VARCHAR(20)                DEFAULT NULL,
    password_hash VARCHAR(255)      NOT NULL,
    avatar_url    VARCHAR(500)               DEFAULT NULL,
    gender        ENUM('male','female','other') DEFAULT NULL,
    birthday      DATE                       DEFAULT NULL,
    is_active     TINYINT(1)        NOT NULL DEFAULT 1,
    email_verified_at DATETIME               DEFAULT NULL,
    created_at    DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_email (email),
    KEY idx_users_role (role_id),
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tài khoản người dùng (admin & khách hàng)';

-- -------------------------------------------------------
-- 1.3 addresses — Địa chỉ giao hàng của khách
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS addresses (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id      INT UNSIGNED NOT NULL  COMMENT 'FK → users.id',
    receiver_name VARCHAR(100) NOT NULL,
    phone        VARCHAR(20)  NOT NULL,
    province     VARCHAR(100) NOT NULL,
    district     VARCHAR(100) NOT NULL,
    ward         VARCHAR(100) NOT NULL,
    street       VARCHAR(255) NOT NULL,
    is_default   TINYINT(1)   NOT NULL DEFAULT 0,
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_addr_user (user_id),
    CONSTRAINT fk_addr_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Địa chỉ giao hàng của khách hàng';

-- =============================================================
-- SECTION 2: DANH MỤC & THƯƠNG HIỆU
-- =============================================================

-- -------------------------------------------------------
-- 2.1 categories — Danh mục đa cấp (Adjacency List)
--     Ví dụ: Phụ kiện (lvl1) → Chuột (lvl2) → Chuột không dây (lvl3)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    parent_id   INT UNSIGNED          DEFAULT NULL COMMENT 'NULL = danh mục gốc',
    name        VARCHAR(150) NOT NULL,
    slug        VARCHAR(200) NOT NULL,
    image_url   VARCHAR(500)          DEFAULT NULL,
    description TEXT                  DEFAULT NULL,
    sort_order  SMALLINT     NOT NULL DEFAULT 0,
    is_active   TINYINT(1)   NOT NULL DEFAULT 1,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cat_slug (slug),
    KEY idx_cat_parent (parent_id),
    CONSTRAINT fk_cat_parent FOREIGN KEY (parent_id) REFERENCES categories (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Danh mục sản phẩm đa cấp (tối đa 3 cấp)';

-- -------------------------------------------------------
-- 2.2 brands — Thương hiệu
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS brands (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    slug        VARCHAR(120) NOT NULL,
    logo_url    VARCHAR(500)          DEFAULT NULL,
    country     VARCHAR(100)          DEFAULT NULL,
    description TEXT                  DEFAULT NULL,
    is_active   TINYINT(1)   NOT NULL DEFAULT 1,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_brand_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Thương hiệu sản phẩm (Logitech, Razer, Corsair...)';

-- =============================================================
-- SECTION 3: SẢN PHẨM
-- =============================================================

-- -------------------------------------------------------
-- 3.1 products — Sản phẩm chính (product master)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
    id              INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    category_id     INT UNSIGNED  NOT NULL  COMMENT 'FK → categories.id (cấp lá)',
    brand_id        INT UNSIGNED  NOT NULL  COMMENT 'FK → brands.id',
    name            VARCHAR(255)  NOT NULL,
    slug            VARCHAR(300)  NOT NULL,
    sku             VARCHAR(100)            DEFAULT NULL COMMENT 'Mã sản phẩm tổng',
    short_desc      TEXT                    DEFAULT NULL,
    full_desc       LONGTEXT                DEFAULT NULL,
    thumbnail_url   VARCHAR(500)            DEFAULT NULL,
    base_price      DECIMAL(12,0) NOT NULL  DEFAULT 0 COMMENT 'Giá tham chiếu (VNĐ)',
    is_featured     TINYINT(1)    NOT NULL  DEFAULT 0,
    is_active       TINYINT(1)    NOT NULL  DEFAULT 1,
    view_count      INT UNSIGNED  NOT NULL  DEFAULT 0,
    sold_count      INT UNSIGNED  NOT NULL  DEFAULT 0,
    created_at      DATETIME      NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME      NOT NULL  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_prod_slug (slug),
    KEY idx_prod_category (category_id),
    KEY idx_prod_brand (brand_id),
    KEY idx_prod_featured (is_featured),
    CONSTRAINT fk_prod_category FOREIGN KEY (category_id) REFERENCES categories (id),
    CONSTRAINT fk_prod_brand    FOREIGN KEY (brand_id)    REFERENCES brands (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Bảng sản phẩm chính';

-- -------------------------------------------------------
-- 3.2 product_images — Ảnh gallery của sản phẩm
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_images (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id  INT UNSIGNED NOT NULL  COMMENT 'FK → products.id',
    image_url   VARCHAR(500) NOT NULL,
    alt_text    VARCHAR(255)           DEFAULT NULL,
    sort_order  TINYINT      NOT NULL  DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_pimg_product (product_id),
    CONSTRAINT fk_pimg_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Ảnh gallery của sản phẩm';

-- -------------------------------------------------------
-- 3.3 attribute_groups — Nhóm thuộc tính kỹ thuật
--     VD: "Thông số kỹ thuật", "Kết nối", "Hiệu năng"
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS attribute_groups (
    id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name       VARCHAR(100) NOT NULL,
    sort_order TINYINT      NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Nhóm thuộc tính kỹ thuật (EAV)';

-- -------------------------------------------------------
-- 3.4 attributes — Tên thuộc tính kỹ thuật (EAV key)
--     VD: DPI, Số nút, Trọng lượng, Loại switch, Thời lượng pin...
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS attributes (
    id               INT UNSIGNED NOT NULL AUTO_INCREMENT,
    group_id         INT UNSIGNED          DEFAULT NULL  COMMENT 'FK → attribute_groups.id',
    name             VARCHAR(150) NOT NULL COMMENT 'VD: DPI tối đa',
    unit             VARCHAR(30)           DEFAULT NULL  COMMENT 'VD: g, Hz, giờ',
    sort_order       TINYINT      NOT NULL DEFAULT 0,
    is_filterable    TINYINT(1)   NOT NULL DEFAULT 0 COMMENT 'Hiển thị bộ lọc sidebar?',
    PRIMARY KEY (id),
    KEY idx_attr_group (group_id),
    CONSTRAINT fk_attr_group FOREIGN KEY (group_id) REFERENCES attribute_groups (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tên thuộc tính kỹ thuật';

-- -------------------------------------------------------
-- 3.5 product_attributes — Giá trị thuộc tính theo sản phẩm (EAV value)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_attributes (
    id           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    product_id   INT UNSIGNED  NOT NULL  COMMENT 'FK → products.id',
    attribute_id INT UNSIGNED  NOT NULL  COMMENT 'FK → attributes.id',
    value        VARCHAR(500)  NOT NULL  COMMENT 'VD: 25600, Optical, RGB Chroma',
    PRIMARY KEY (id),
    UNIQUE KEY uq_pa_prod_attr (product_id, attribute_id),
    KEY idx_pa_attribute (attribute_id),
    CONSTRAINT fk_pa_product   FOREIGN KEY (product_id)   REFERENCES products   (id) ON DELETE CASCADE,
    CONSTRAINT fk_pa_attribute FOREIGN KEY (attribute_id) REFERENCES attributes (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Giá trị thuộc tính kỹ thuật theo sản phẩm (EAV)';

-- -------------------------------------------------------
-- 3.6 variant_options — Tùy chọn biến thể (màu, kết nối, switch...)
--     VD: color=Đen, connection=USB/Wireless, switch=Red Linear
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS variant_options (
    id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name       VARCHAR(80)  NOT NULL COMMENT 'VD: Màu sắc, Kết nối, Switch',
    PRIMARY KEY (id),
    UNIQUE KEY uq_vo_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tên tùy chọn biến thể sản phẩm';

-- -------------------------------------------------------
-- 3.7 variant_option_values — Giá trị của từng tùy chọn
--     VD: Màu sắc → Đen, Trắng; Kết nối → USB, Wireless, Bluetooth
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS variant_option_values (
    id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    option_id INT UNSIGNED NOT NULL  COMMENT 'FK → variant_options.id',
    value     VARCHAR(100) NOT NULL,
    color_hex VARCHAR(10)            DEFAULT NULL COMMENT 'Mã màu HEX nếu là option màu sắc',
    PRIMARY KEY (id),
    KEY idx_vov_option (option_id),
    CONSTRAINT fk_vov_option FOREIGN KEY (option_id) REFERENCES variant_options (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Giá trị tùy chọn biến thể';

-- -------------------------------------------------------
-- 3.8 product_variants — Biến thể sản phẩm (SKU cụ thể)
--     Mỗi biến thể = tổ hợp màu + kết nối + switch + giá riêng
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_variants (
    id              INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    product_id      INT UNSIGNED  NOT NULL  COMMENT 'FK → products.id',
    sku             VARCHAR(120)  NOT NULL  COMMENT 'SKU riêng của biến thể',
    color           VARCHAR(50)             DEFAULT 'Tiêu chuẩn' COMMENT 'Màu sắc biến thể',
    version_spec    VARCHAR(100)            DEFAULT 'Mặc định'   COMMENT 'Phiên bản / Chuẩn kết nối',
    price           DECIMAL(12,0) NOT NULL  COMMENT 'Giá bán (VNĐ)',
    sale_price      DECIMAL(12,0)           DEFAULT NULL COMMENT 'Giá khuyến mãi (NULL = không KM)',
    stock_qty       INT UNSIGNED  NOT NULL  DEFAULT 0,
    image_url       VARCHAR(500)            DEFAULT NULL COMMENT 'Ảnh riêng của biến thể',
    is_active       TINYINT(1)    NOT NULL  DEFAULT 1,
    created_at      DATETIME      NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME      NOT NULL  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_variant_sku (sku),
    KEY idx_var_product (product_id),
    CONSTRAINT fk_var_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Biến thể sản phẩm (SKU, giá, tồn kho riêng)';

-- -------------------------------------------------------
-- 3.9 variant_attribute_values — Ánh xạ biến thể ↔ giá trị tùy chọn
--     VD: variant#5 → Màu: Đen, Kết nối: Wireless
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS variant_attribute_values (
    variant_id       INT UNSIGNED NOT NULL  COMMENT 'FK → product_variants.id',
    option_value_id  INT UNSIGNED NOT NULL  COMMENT 'FK → variant_option_values.id',
    PRIMARY KEY (variant_id, option_value_id),
    KEY idx_vav_optval (option_value_id),
    CONSTRAINT fk_vav_variant  FOREIGN KEY (variant_id)      REFERENCES product_variants     (id) ON DELETE CASCADE,
    CONSTRAINT fk_vav_optvalue FOREIGN KEY (option_value_id) REFERENCES variant_option_values(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Ánh xạ biến thể sản phẩm với tùy chọn (màu, kết nối...)';

-- =============================================================
-- SECTION 4: GIỎ HÀNG & ĐƠN HÀNG
-- =============================================================

-- -------------------------------------------------------
-- 4.1 carts — Giỏ hàng (1 user = 1 cart đang hoạt động)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS carts (
    id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id    INT UNSIGNED          DEFAULT NULL  COMMENT 'NULL = khách vãng lai (session)',
    session_id VARCHAR(128)          DEFAULT NULL,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_cart_user (user_id),
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Giỏ hàng';

-- -------------------------------------------------------
-- 4.2 cart_items — Chi tiết sản phẩm trong giỏ hàng
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS cart_items (
    id          INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    cart_id     INT UNSIGNED  NOT NULL  COMMENT 'FK → carts.id',
    variant_id  INT UNSIGNED  NOT NULL  COMMENT 'FK → product_variants.id',
    quantity    SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_ci_cart_var (cart_id, variant_id),
    KEY idx_ci_variant (variant_id),
    CONSTRAINT fk_ci_cart    FOREIGN KEY (cart_id)    REFERENCES carts            (id) ON DELETE CASCADE,
    CONSTRAINT fk_ci_variant FOREIGN KEY (variant_id) REFERENCES product_variants (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Chi tiết sản phẩm trong giỏ hàng';

-- -------------------------------------------------------
-- 4.3 orders — Đơn hàng
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    id              INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    user_id         INT UNSIGNED            DEFAULT NULL  COMMENT 'FK → users.id',
    order_code      VARCHAR(30)    NOT NULL  COMMENT 'Mã đơn hàng: ZT20261104001',
    -- Địa chỉ nhận hàng (snapshot lúc đặt)
    receiver_name   VARCHAR(100)   NOT NULL,
    receiver_phone  VARCHAR(20)    NOT NULL,
    shipping_address TEXT          NOT NULL,
    -- Thanh toán
    payment_method  ENUM('cod','vnpay','momo','bank_transfer') NOT NULL DEFAULT 'cod',
    payment_status  ENUM('unpaid','paid','refunded')           NOT NULL DEFAULT 'unpaid',
    -- Giá
    subtotal        DECIMAL(14,0)  NOT NULL DEFAULT 0 COMMENT 'Tổng tiền hàng',
    shipping_fee    DECIMAL(10,0)  NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10,0)  NOT NULL DEFAULT 0,
    total_amount    DECIMAL(14,0)  NOT NULL DEFAULT 0 COMMENT 'Tổng thanh toán',
    -- Trạng thái
    status          ENUM('pending','confirmed','processing','shipping','delivered','cancelled','returned')
                                   NOT NULL DEFAULT 'pending',
    note            TEXT                    DEFAULT NULL,
    cancelled_reason TEXT                   DEFAULT NULL,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_order_code (order_code),
    KEY idx_order_user   (user_id),
    KEY idx_order_status (status),
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Đơn hàng';

-- -------------------------------------------------------
-- 4.4 order_items — Chi tiết sản phẩm trong đơn hàng (snapshot giá)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_items (
    id              INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    order_id        INT UNSIGNED  NOT NULL  COMMENT 'FK → orders.id',
    variant_id      INT UNSIGNED            DEFAULT NULL COMMENT 'FK → product_variants.id (snapshot)',
    product_name    VARCHAR(255)  NOT NULL  COMMENT 'Tên SP tại thời điểm đặt hàng',
    variant_info    VARCHAR(255)            DEFAULT NULL COMMENT 'VD: Đen | Wireless',
    unit_price      DECIMAL(12,0) NOT NULL,
    quantity        SMALLINT UNSIGNED NOT NULL,
    total_price     DECIMAL(14,0) NOT NULL,
    PRIMARY KEY (id),
    KEY idx_oi_order   (order_id),
    KEY idx_oi_variant (variant_id),
    CONSTRAINT fk_oi_order   FOREIGN KEY (order_id)   REFERENCES orders           (id) ON DELETE CASCADE,
    CONSTRAINT fk_oi_variant FOREIGN KEY (variant_id) REFERENCES product_variants (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Chi tiết sản phẩm trong đơn hàng';

-- -------------------------------------------------------
-- 4.5 order_status_logs — Lịch sử thay đổi trạng thái đơn hàng
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_status_logs (
    id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id   INT UNSIGNED NOT NULL,
    old_status VARCHAR(30)           DEFAULT NULL,
    new_status VARCHAR(30)  NOT NULL,
    changed_by INT UNSIGNED          DEFAULT NULL COMMENT 'FK → users.id (admin/staff)',
    note       TEXT                  DEFAULT NULL,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_osl_order (order_id),
    CONSTRAINT fk_osl_order FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Lịch sử trạng thái đơn hàng';

-- =============================================================
-- SECTION 5: ĐÁNH GIÁ & BÌNH LUẬN
-- =============================================================

-- -------------------------------------------------------
-- 5.1 reviews — Đánh giá sản phẩm
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id  INT UNSIGNED NOT NULL  COMMENT 'FK → products.id',
    user_id     INT UNSIGNED NOT NULL  COMMENT 'FK → users.id',
    order_id    INT UNSIGNED           DEFAULT NULL COMMENT 'FK → orders.id (đã mua mới được đánh giá)',
    rating      TINYINT UNSIGNED NOT NULL COMMENT '1-5 sao',
    title       VARCHAR(255)           DEFAULT NULL,
    content     TEXT                   DEFAULT NULL,
    is_approved TINYINT(1)   NOT NULL  DEFAULT 0,
    created_at  DATETIME     NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_rv_product (product_id),
    KEY idx_rv_user    (user_id),
    CONSTRAINT fk_rv_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    CONSTRAINT fk_rv_user    FOREIGN KEY (user_id)    REFERENCES users    (id) ON DELETE CASCADE,
    CONSTRAINT fk_rv_order   FOREIGN KEY (order_id)   REFERENCES orders   (id) ON DELETE SET NULL,
    CONSTRAINT chk_rv_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Đánh giá & xếp hạng sản phẩm';

-- -------------------------------------------------------
-- 5.2 review_images — Ảnh đính kèm trong đánh giá
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS review_images (
    id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    review_id INT UNSIGNED NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    PRIMARY KEY (id),
    KEY idx_ri_review (review_id),
    CONSTRAINT fk_ri_review FOREIGN KEY (review_id) REFERENCES reviews (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Ảnh đính kèm trong đánh giá sản phẩm';

-- =============================================================
-- SECTION 6: AI ASSISTANT LOG
-- =============================================================

-- -------------------------------------------------------
-- 6.1 ai_conversations — Phiên hội thoại AI
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS ai_conversations (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id      INT UNSIGNED           DEFAULT NULL  COMMENT 'NULL = khách vãng lai',
    session_id   VARCHAR(128)  NOT NULL,
    title        VARCHAR(255)           DEFAULT NULL COMMENT 'Tiêu đề tóm tắt cuộc hội thoại',
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_aic_user    (user_id),
    KEY idx_aic_session (session_id),
    CONSTRAINT fk_aic_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Phiên hội thoại với AI Assistant';

-- -------------------------------------------------------
-- 6.2 ai_messages — Nội dung từng tin nhắn trong phiên AI
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS ai_messages (
    id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    conversation_id INT UNSIGNED NOT NULL  COMMENT 'FK → ai_conversations.id',
    role            ENUM('user','assistant') NOT NULL,
    content         TEXT         NOT NULL,
    tokens_used     SMALLINT UNSIGNED DEFAULT NULL,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_aim_conv (conversation_id),
    CONSTRAINT fk_aim_conv FOREIGN KEY (conversation_id) REFERENCES ai_conversations (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Nội dung tin nhắn trong phiên hội thoại AI';

-- =============================================================
-- SECTION 7: KHUYẾN MÃI & VOUCHER (bonus)
-- =============================================================

CREATE TABLE IF NOT EXISTS coupons (
    id              INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    code            VARCHAR(50)    NOT NULL,
    description     VARCHAR(255)            DEFAULT NULL,
    discount_type   ENUM('percent','fixed') NOT NULL DEFAULT 'percent',
    discount_value  DECIMAL(10,2)  NOT NULL,
    min_order_value DECIMAL(12,0)  NOT NULL DEFAULT 0,
    max_uses        INT UNSIGNED            DEFAULT NULL COMMENT 'NULL = không giới hạn',
    used_count      INT UNSIGNED   NOT NULL DEFAULT 0,
    starts_at       DATETIME                DEFAULT NULL,
    expires_at      DATETIME                DEFAULT NULL,
    is_active       TINYINT(1)     NOT NULL DEFAULT 1,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_coupon_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Mã giảm giá / voucher';

SET FOREIGN_KEY_CHECKS = 1;


-- =============================================================
-- =============================================================
--  MOCK DATA — Dữ liệu mẫu
-- =============================================================
-- =============================================================

-- -------------------------------------------------------
-- Roles
-- -------------------------------------------------------
INSERT INTO roles (id, name, description) VALUES
(1, 'admin',    'Quản trị viên hệ thống'),
(2, 'customer', 'Khách hàng'),
(3, 'staff',    'Nhân viên bán hàng');

-- -------------------------------------------------------
-- Users (mật khẩu hash bcrypt của "Password@123")
-- -------------------------------------------------------
INSERT INTO users (id, role_id, full_name, email, phone, password_hash, is_active) VALUES
(1, 1, 'Admin ZenTech',  'admin@zentech.vn',       '0909000001', '$2y$10$hTIH2RlmRqPVpUrIV5LLc.NGwLxLkZOa/4QT.CtyLN1WlWccHcReS', 1),
(2, 2, 'Nguyễn Văn An',  'nguyenvanan@gmail.com',  '0912345678', '$2y$10$hTIH2RlmRqPVpUrIV5LLc.NGwLxLkZOa/4QT.CtyLN1WlWccHcReS',  1),
(3, 2, 'Trần Thị Bình',  'tranthibinh@gmail.com',  '0923456789', '$2y$10$hTIH2RlmRqPVpUrIV5LLc.NGwLxLkZOa/4QT.CtyLN1WlWccHcReS',  1),
(4, 3, 'Lê Minh Cường',  'leminhcuong@zentech.vn', '0934567890', '$2y$10$hTIH2RlmRqPVpUrIV5LLc.NGwLxLkZOa/4QT.CtyLN1WlWccHcReS', 1);

-- -------------------------------------------------------
-- Categories (3 cấp)
-- -------------------------------------------------------
INSERT INTO categories (id, parent_id, name, slug, sort_order) VALUES
-- Cấp 1 — Danh mục gốc
(1,  NULL, 'Chuột',          'chuot-gaming',           1),
(2,  NULL, 'Bàn Phím',       'ban-phim-gaming',        2),
(3,  NULL, 'Tai Nghe',       'tai-nghe-gaming',        3),
(4,  NULL, 'Lót Chuột',             'lot-chuot',              4),
(5,  NULL, 'Ghế & Bàn Gaming',      'ghe-ban-gaming',         5),
-- Cấp 2 — Con của Chuột Gaming (id=1)
(6,  1,   'Chuột Có Dây',           'chuot-co-day',           1),
(7,  1,   'Chuột Không Dây',        'chuot-khong-day',        2),
(8,  1,   'Chuột Bluetooth',        'chuot-bluetooth',        3),
-- Cấp 2 — Con của Bàn Phím Gaming (id=2)
(9,  2,   'Bàn Phím Cơ',            'ban-phim-co',            1),
(10, 2,   'Bàn Phím Membrane',      'ban-phim-membrane',      2),
(11, 2,   'Bàn Phím Mini / TKL',    'ban-phim-mini-tkl',      3),
-- Cấp 2 — Con của Tai Nghe Gaming (id=3)
(12, 3,   'Tai Nghe Có Dây',        'tai-nghe-co-day',        1),
(13, 3,   'Tai Nghe Không Dây',     'tai-nghe-khong-day',     2);

-- -------------------------------------------------------
-- Brands
-- -------------------------------------------------------
INSERT INTO brands (id, name, slug, country, description) VALUES
(1, 'Logitech', 'logitech', 'Thụy Sĩ',  'Thương hiệu phụ kiện máy tính hàng đầu thế giới'),
(2, 'Razer',    'razer',    'Singapore','Chuyên thiết bị gaming cao cấp'),
(3, 'Corsair',  'corsair',  'Mỹ',       'Phụ kiện & linh kiện máy tính hiệu năng cao'),
(4, 'DareU',    'dareu',    'Trung Quốc','Gaming gear giá tốt, phổ biến tại Việt Nam'),
(5, 'SteelSeries','steelseries','Đan Mạch','Thiết bị gaming chuyên nghiệp');

-- -------------------------------------------------------
-- Variant Options & Values
-- -------------------------------------------------------
INSERT INTO variant_options (id, name) VALUES
(1, 'Màu sắc'),
(2, 'Kết nối'),
(3, 'Loại Switch');

INSERT INTO variant_option_values (id, option_id, value, color_hex) VALUES
-- Màu sắc
(1,  1, 'Đen',          '#1a1a1a'),
(2,  1, 'Trắng',        '#f5f5f5'),
(3,  1, 'Hồng',         '#ff69b4'),
(4,  1, 'Xám',          '#808080'),
-- Kết nối
(5,  2, 'USB có dây',   NULL),
(6,  2, 'Wireless 2.4G',NULL),
(7,  2, 'Bluetooth',    NULL),
(8,  2, 'USB + Wireless',NULL),
-- Loại Switch
(9,  3, 'Red Linear',   NULL),
(10, 3, 'Brown Tactile',NULL),
(11, 3, 'Blue Clicky',  NULL),
(12, 3, 'Yellow Linear',NULL);

-- -------------------------------------------------------
-- Attribute Groups & Attributes
-- -------------------------------------------------------
INSERT INTO attribute_groups (id, name, sort_order) VALUES
(1, 'Thông số cảm biến',  1),
(2, 'Kết nối & Pin',      2),
(3, 'Thiết kế & Vật liệu',3),
(4, 'Thông số bàn phím',  4);

INSERT INTO attributes (id, group_id, name, unit, sort_order, is_filterable) VALUES
-- Chuột
(1,  1, 'DPI tối đa',          'DPI',  1, 1),
(2,  1, 'Loại cảm biến',       NULL,   2, 1),
(3,  1, 'Số nút bấm',          'nút',  3, 0),
(4,  1, 'Tốc độ theo dõi',     'IPS',  4, 0),
(5,  2, 'Loại kết nối',        NULL,   1, 1),
(6,  2, 'Thời lượng pin',      'giờ',  2, 1),
(7,  2, 'Thời gian sạc',       'giờ',  3, 0),
(8,  3, 'Trọng lượng',         'g',    1, 0),
(9,  3, 'Đèn LED',             NULL,   2, 1),
(10, 3, 'Kích thước bàn chân', NULL,   3, 0),
-- Bàn phím
(11, 4, 'Layout',              NULL,   1, 1),
(12, 4, 'Loại switch',         NULL,   2, 1),
(13, 4, 'Có thể hot-swap',     NULL,   3, 1),
(14, 4, 'Polling rate',        'Hz',   4, 0);

-- -------------------------------------------------------
-- Products (10 sản phẩm mẫu)
-- -------------------------------------------------------
INSERT INTO products (id, category_id, brand_id, name, slug, sku, short_desc, base_price, is_featured) VALUES
-- Chuột không dây (cat 7 = Chuột không dây)
(1, 7,  1, 'Logitech G Pro X Superlight 2',
   'logitech-g-pro-x-superlight-2',         'LOG-GPXSL2',
   'Chuột gaming không dây siêu nhẹ 60g, cảm biến HERO 2 25600 DPI',
   1890000, 1),

(2, 7,  2, 'Razer DeathAdder V3 HyperSpeed',
   'razer-deathadder-v3-hyperspeed',         'RZR-DAV3HS',
   'Chuột gaming không dây, thiết kế ergonomic, pin 300 giờ',
   1590000, 1),

(3, 7,  4, 'DareU EM901X Wireless',
   'dareu-em901x-wireless',                  'DRU-EM901X',
   'Chuột gaming không dây 3 chế độ, cảm biến PAW3395, giá tốt',
    890000, 0),

-- Chuột có dây (cat 6 = Chuột có dây)
(4, 6,  2, 'Razer DeathAdder V3',
   'razer-deathadder-v3',                    'RZR-DAV3',
   'Chuột gaming có dây siêu nhẹ 59g, Focus Pro 30K sensor',
   1290000, 1),

(5, 6,  3, 'Corsair M75',
   'corsair-m75',                            'COR-M75',
   'Chuột gaming có dây, cảm biến Marksman 26K, 10 nút lập trình',
    990000, 0),

-- Bàn phím cơ (cat 9 = Bàn phím cơ)
(6, 9,  4, 'DareU EK87 Pro',
   'dareu-ek87-pro',                         'DRU-EK87P',
   'Bàn phím cơ TKL, switch DareU Sky V3, RGB, gasket mount',
    790000, 0),

(7, 9,  3, 'Corsair K70 Pro Mini Wireless',
   'corsair-k70-pro-mini-wireless',          'COR-K70PMW',
   'Bàn phím cơ 65%, không dây, Cherry MX Switch, RGB',
   2890000, 1),

-- Tai nghe gaming (cat 12 = Tai nghe có dây)
(8, 12, 2, 'Razer BlackShark V2 X',
   'razer-blackshark-v2-x',                  'RZR-BSV2X',
   'Tai nghe gaming có dây, driver 50mm, mic siêu định hướng',
    890000, 0),

(9, 13, 1, 'Logitech G733 Lightspeed',
   'logitech-g733-lightspeed',               'LOG-G733',
   'Tai nghe gaming không dây LIGHTSPEED, pin 29 giờ, RGB',
   2290000, 1),

-- Lót chuột (cat 4 = Lót chuột)
(10, 4, 5, 'SteelSeries QcK Heavy XXL',
    'steelseries-qck-heavy-xxl',              'SS-QCKHXXL',
    'Lót chuột cỡ XXL 900x300mm, bề mặt vải mịn, đế cao su chống trượt',
     650000, 0);

-- -------------------------------------------------------
-- Product Attributes (EAV values)
-- -------------------------------------------------------
INSERT INTO product_attributes (product_id, attribute_id, value) VALUES
-- Logitech G Pro X Superlight 2 (id=1)
(1,  1, '25600'),
(1,  2, 'HERO 2 (Optical)'),
(1,  3, '5'),
(1,  5, 'Wireless 2.4G (LIGHTSPEED)'),
(1,  6, '95'),
(1,  8, '60'),
(1,  9, 'Không có LED'),
-- Razer DeathAdder V3 HyperSpeed (id=2)
(2,  1, '18000'),
(2,  2, 'Focus X (Optical)'),
(2,  3, '6'),
(2,  5, 'Wireless 2.4G HyperSpeed'),
(2,  6, '300'),
(2,  8, '75'),
(2,  9, 'Không có LED'),
-- DareU EM901X (id=3)
(3,  1, '26000'),
(3,  2, 'PAW3395 (Optical)'),
(3,  5, 'USB / 2.4G / Bluetooth'),
(3,  6, '120'),
(3,  8, '78'),
(3,  9, 'RGB'),
-- Razer DeathAdder V3 (id=4)
(4,  1, '30000'),
(4,  2, 'Focus Pro 30K (Optical)'),
(4,  3, '8'),
(4,  5, 'USB Type-C có dây'),
(4,  8, '59'),
(4,  9, 'Không có LED'),
-- DareU EK87 Pro (id=6)
(6, 11, 'TKL (87%)'),
(6, 12, 'DareU Sky V3'),
(6, 13, 'Có (5-pin)'),
(6, 14, '1000'),
-- Corsair K70 Pro Mini Wireless (id=7)
(7, 11, '65% (68 phím)'),
(7, 12, 'Cherry MX Red'),
(7, 13, 'Không'),
(7, 14, '8000');

-- -------------------------------------------------------
-- Product Variants
-- -------------------------------------------------------
INSERT INTO product_variants (id, product_id, sku, color, version_spec, price, sale_price, stock_qty) VALUES
-- Logitech G Pro X Superlight 2
(1,  1, 'LOG-GPXSL2-BLK',   'Đen',   'Wireless 2.4G',   1890000, 1750000, 25),
(2,  1, 'LOG-GPXSL2-WHT',   'Trắng', 'Wireless 2.4G',   1890000, NULL,     18),
-- Razer DeathAdder V3 HyperSpeed
(3,  2, 'RZR-DAV3HS-BLK',   'Đen',   'Wireless 2.4G',   1590000, 1490000, 30),
(4,  2, 'RZR-DAV3HS-WHT',   'Trắng', 'Wireless 2.4G',   1590000, NULL,     12),
-- DareU EM901X Wireless
(5,  3, 'DRU-EM901X-BLK',   'Đen',   'USB + Wireless',   890000,  799000, 50),
(6,  3, 'DRU-EM901X-WHT',   'Trắng', 'USB + Wireless',   890000,  799000, 40),
(7,  3, 'DRU-EM901X-PNK',   'Hồng',  'USB + Wireless',   890000,  799000, 20),
-- Razer DeathAdder V3
(8,  4, 'RZR-DAV3-BLK',     'Đen',   'USB có dây',      1290000, 1190000, 35),
-- Corsair M75
(9,  5, 'COR-M75-BLK',      'Đen',   'USB có dây',       990000,  899000, 22),
(10, 5, 'COR-M75-WHT',      'Trắng', 'USB có dây',       990000,  NULL,   15),
-- DareU EK87 Pro
(11, 6, 'DRU-EK87P-BLK-RED', 'Đen',   'Red Switch',       790000, 699000, 45),
(12, 6, 'DRU-EK87P-BLK-BRN', 'Đen',   'Brown Switch',     790000, 699000, 30),
(13, 6, 'DRU-EK87P-WHT-RED', 'Trắng', 'Red Switch',       790000, 699000, 25),
-- Corsair K70 Pro Mini Wireless
(14, 7, 'COR-K70PMW-BLK',   'Đen',   'USB + Wireless',  2890000, 2690000, 10),
-- Razer BlackShark V2 X
(15, 8, 'RZR-BSV2X-BLK',    'Đen',   'USB có dây',       890000,  799000, 60),
-- Logitech G733
(16, 9, 'LOG-G733-BLK',     'Đen',   'Wireless 2.4G',   2290000, 2090000, 18),
(17, 9, 'LOG-G733-WHT',     'Trắng', 'Wireless 2.4G',   2290000, 2090000, 10),
(18, 9, 'LOG-G733-PNK',     'Hồng',  'Wireless 2.4G',   2290000, NULL,     8),
-- SteelSeries QcK Heavy XXL
(19,10, 'SS-QCKHXXL-BLK',   'Đen',   'Kích thước XXL',   650000,  NULL,   100);

-- -------------------------------------------------------
-- Variant Attribute Values (ánh xạ variant ↔ màu/kết nối)
-- -------------------------------------------------------
INSERT INTO variant_attribute_values (variant_id, option_value_id) VALUES
-- Logitech GPX SL2
(1,  1),(1,  6),   -- Đen | Wireless 2.4G
(2,  2),(2,  6),   -- Trắng | Wireless 2.4G
-- Razer DAV3 HyperSpeed
(3,  1),(3,  6),   -- Đen | Wireless 2.4G
(4,  2),(4,  6),   -- Trắng | Wireless 2.4G
-- DareU EM901X
(5,  1),(5,  8),   -- Đen | USB+Wireless
(6,  2),(6,  8),   -- Trắng | USB+Wireless
(7,  3),(7,  8),   -- Hồng | USB+Wireless
-- Razer DAV3
(8,  1),(8,  5),   -- Đen | USB có dây
-- Corsair M75
(9,  1),(9,  5),   -- Đen | USB có dây
(10, 2),(10, 5),   -- Trắng | USB có dây
-- DareU EK87 Pro
(11, 1),(11, 9),   -- Đen | Red Linear
(12, 1),(12,10),   -- Đen | Brown Tactile
(13, 2),(13, 9),   -- Trắng | Red Linear
-- Corsair K70 Pro Mini
(14, 1),(14, 8),   -- Đen | USB+Wireless
-- Razer BlackShark V2X
(15, 1),(15, 5),   -- Đen | USB có dây
-- Logitech G733
(16, 1),(16, 6),   -- Đen | Wireless 2.4G
(17, 2),(17, 6),   -- Trắng | Wireless 2.4G
(18, 3),(18, 6);   -- Hồng | Wireless 2.4G

-- -------------------------------------------------------
-- Sample Coupon
-- -------------------------------------------------------
INSERT INTO coupons (code, description, discount_type, discount_value, min_order_value, max_uses, starts_at, expires_at) VALUES
('ZENTECH10',   'Giảm 10% cho đơn hàng từ 500K',  'percent', 10.00,  500000, 100, '2026-11-01 00:00:00', '2026-12-31 23:59:59'),
('GAMING200K',  'Giảm 200K cho đơn hàng từ 1.5Tr', 'fixed',  200000, 1500000,  50, '2026-11-01 00:00:00', '2026-11-30 23:59:59'),
('NEWUSER50K',  'Tặng 50K cho thành viên mới',      'fixed',   50000,       0, 500, '2026-11-01 00:00:00', '2027-12-31 23:59:59');
