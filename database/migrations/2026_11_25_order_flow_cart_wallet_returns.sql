-- Quy trình đơn 1 chiều, giao thất bại, trả hàng, ví ZenTech, giỏ hàng lưu DB, mã giảm giá theo danh mục/sản phẩm
ALTER TABLE orders
  MODIFY status ENUM('pending','confirmed','processing','handed_over','shipping','delivered','completed','return_requested','returned','cancelled') NOT NULL DEFAULT 'pending',
  MODIFY payment_method ENUM('cod','online','wallet','vnpay','momo','bank_transfer') NOT NULL DEFAULT 'cod',
  ADD COLUMN fail_count TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER status,
  ADD COLUMN delivered_at DATETIME NULL AFTER fail_count;

ALTER TABLE users ADD COLUMN wallet_balance DECIMAL(14,0) NOT NULL DEFAULT 0 AFTER is_active;

CREATE TABLE wallet_transactions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  order_id INT UNSIGNED NULL,
  amount DECIMAL(14,0) NOT NULL,
  note VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_returns (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL UNIQUE,
  user_id INT UNSIGNED NOT NULL,
  reason VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  evidence_url VARCHAR(500) NULL,
  refund_method ENUM('wallet','bank') NOT NULL DEFAULT 'wallet',
  bank_info VARCHAR(255) NULL,
  status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  admin_note VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at DATETIME NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Giỏ hàng lưu DB: mỗi user 1 giỏ, mỗi biến thể 1 dòng, giữ giá lúc bỏ vào giỏ để báo khi giá đổi
DELETE FROM cart_items; DELETE FROM carts;
ALTER TABLE carts ADD UNIQUE KEY uq_cart_user (user_id);
ALTER TABLE cart_items ADD COLUMN price DECIMAL(14,0) NOT NULL DEFAULT 0, ADD UNIQUE KEY uq_cart_variant (cart_id, variant_id);

ALTER TABLE coupons
  ADD COLUMN category_id INT UNSIGNED NULL AFTER min_order_value,
  ADD COLUMN product_id INT UNSIGNED NULL AFTER category_id,
  ADD FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
  ADD FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- Xóa tài khoản thì xóa luôn giỏ đã lưu (trước đây SET NULL để lại giỏ mồ côi)
DELETE FROM carts WHERE user_id IS NULL;
ALTER TABLE carts DROP FOREIGN KEY fk_cart_user;
ALTER TABLE carts ADD CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
