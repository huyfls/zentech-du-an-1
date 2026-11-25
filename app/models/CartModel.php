<?php
/**
 * ZenTech CartModel
 * Lưu giỏ hàng của khách đã đăng nhập vào DB (carts / cart_items) để giỏ giữ nguyên
 * giữa các lần đăng nhập và giữa hai trình duyệt / thiết bị khác nhau.
 * Khách chưa đăng nhập vẫn dùng giỏ trong session.
 */
class CartModel extends BaseModel
{
    public const MAX_QTY = 10; // tối đa mỗi sản phẩm (biến thể) trong một giỏ

    /** Giỏ của user, cùng dạng với $_SESSION['cart']. Giá giữ theo lúc bỏ vào giỏ để refreshCart báo khi giá đổi. */
    public function load(int $userId): array
    {
        $rows = $this->rawQuery(
            "SELECT ci.variant_id, ci.quantity, ci.price, p.name AS product_name, pv.color, pv.version_spec,
                    COALESCE(pv.image_url, p.thumbnail_url) AS image, pv.stock_qty
             FROM carts c
             JOIN cart_items ci ON ci.cart_id = c.id
             JOIN product_variants pv ON pv.id = ci.variant_id
             JOIN products p ON p.id = pv.product_id
             WHERE c.user_id = ? ORDER BY ci.id",
            [$userId]
        );
        $cart = [];
        foreach ($rows as $r) {
            $cart[(int) $r['variant_id']] = [
                'variant_id'   => (int) $r['variant_id'],
                'product_name' => $r['product_name'],
                'variant_info' => implode(' / ', array_filter([$r['color'] ?? '', $r['version_spec'] ?? ''])),
                'price'        => (float) $r['price'],
                'image'        => $r['image'] ?? '',
                'quantity'     => (int) $r['quantity'],
                'stock_qty'    => (int) $r['stock_qty'],
            ];
        }
        return $cart;
    }

    /** Ghi đè giỏ của user bằng $cart. shortcut: hai trình duyệt sửa cùng lúc thì bản lưu sau thắng, đủ cho quy mô shop nhỏ. */
    public function save(int $userId, array $cart): void
    {
        $this->pdo->beginTransaction();
        try {
            $this->pdo->prepare('INSERT INTO carts (user_id) VALUES (?) ON DUPLICATE KEY UPDATE updated_at = NOW()')->execute([$userId]);
            $st = $this->pdo->prepare('SELECT id FROM carts WHERE user_id = ?');
            $st->execute([$userId]);
            $cartId = (int) $st->fetchColumn();
            $this->pdo->prepare('DELETE FROM cart_items WHERE cart_id = ?')->execute([$cartId]);
            $ins = $this->pdo->prepare('INSERT INTO cart_items (cart_id, variant_id, quantity, price) VALUES (?, ?, ?, ?)');
            foreach ($cart as $vid => $item) {
                $ins->execute([$cartId, (int) $vid, min(self::MAX_QTY, max(1, (int) $item['quantity'])), (float) $item['price']]);
            }
            $this->pdo->commit();
        } catch (Throwable $e) {
            if ($this->pdo->inTransaction()) $this->pdo->rollBack();
            error_log('[ZenTech][Cart save] ' . $e->getMessage());
        }
    }

    /** Gộp giỏ lúc chưa đăng nhập vào giỏ đã lưu (cộng số lượng, chặn ở MAX_QTY và tồn kho). */
    public static function merge(array $saved, array $guest): array
    {
        foreach ($guest as $vid => $item) {
            if (isset($saved[$vid])) {
                $saved[$vid]['quantity'] = min(self::MAX_QTY, (int) $item['stock_qty'], $saved[$vid]['quantity'] + (int) $item['quantity']);
            } else {
                $saved[$vid] = $item;
            }
        }
        return $saved;
    }
}
