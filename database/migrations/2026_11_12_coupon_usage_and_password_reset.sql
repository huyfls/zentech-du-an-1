-- Mã giảm giá đã dùng cho từng đơn (để hoàn lượt dùng khi hủy) và token đặt lại mật khẩu.
CREATE TABLE IF NOT EXISTS order_coupons (
    order_id  INT UNSIGNED NOT NULL PRIMARY KEY,
    coupon_id INT UNSIGNED NOT NULL,
    CONSTRAINT fk_oc_order  FOREIGN KEY (order_id)  REFERENCES orders (id)  ON DELETE CASCADE,
    CONSTRAINT fk_oc_coupon FOREIGN KEY (coupon_id) REFERENCES coupons (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS password_resets (
    id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id    INT UNSIGNED NOT NULL,
    token_hash CHAR(64)     NOT NULL,
    expires_at DATETIME     NOT NULL,
    used_at    DATETIME     NULL,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_pr_token (token_hash),
    CONSTRAINT fk_pr_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
