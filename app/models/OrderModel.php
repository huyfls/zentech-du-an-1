<?php
/**
 * ZenTech OrderModel
 * Quản lý đơn hàng, chi tiết đơn và transaction trừ tồn kho an toàn tuyệt đối
 */
class OrderModel extends BaseModel
{
    public const FREE_SHIPPING_FROM = 500000;
    public const SHIPPING_FEE       = 30000;

    /** Phí giao hàng theo tạm tính: miễn phí từ 500.000₫. */
    public static function shippingFee(float $subtotal): int
    {
        return $subtotal >= self::FREE_SHIPPING_FROM ? 0 : self::SHIPPING_FEE;
    }

    /**
     * Tính tiền giảm của mã giảm giá. Trả về [số tiền giảm, lỗi|null].
     * $c là dòng bảng coupons (hoặc null nếu không có mã).
     */
    public static function couponDiscount(?array $c, float $subtotal, ?int $now = null): array
    {
        $now = $now ?? time();
        if (!$c || !(int) $c['is_active']) return [0, 'Mã giảm giá không tồn tại hoặc đã ngừng.'];
        if ($c['starts_at'] && strtotime($c['starts_at']) > $now) return [0, 'Mã giảm giá chưa đến ngày áp dụng.'];
        if ($c['expires_at'] && strtotime($c['expires_at']) < $now) return [0, 'Mã giảm giá đã hết hạn.'];
        if ($c['max_uses'] !== null && (int) $c['used_count'] >= (int) $c['max_uses']) return [0, 'Mã giảm giá đã hết lượt dùng.'];
        if ($subtotal < (float) $c['min_order_value']) {
            return [0, 'Đơn hàng cần từ ' . number_format((float) $c['min_order_value'], 0, ',', '.') . '₫ để dùng mã này.'];
        }
        $d = $c['discount_type'] === 'percent' ? (int) floor($subtotal * (float) $c['discount_value'] / 100) : (int) $c['discount_value'];
        return [min($d, (int) $subtotal), null];
    }

    /**
     * Quy trình đặt hàng an toàn (Database Transaction với FOR UPDATE lock)
     *
     * @param int   $userId
     * @param array $addressInfo ['receiver_name', 'receiver_phone', 'shipping_address', 'note']
     * @param array $cartItems   [$variantId => ['variant_id', 'product_name', 'variant_info', 'price', 'quantity']]
     * @param string $paymentMethod 'cod' | 'bank_transfer' | 'momo'
     * @return array ['success' => bool, 'order_id' => int|null, 'order_code' => string, 'message' => string]
     */
    public function placeOrder(
        int    $userId,
        array  $addressInfo,
        array  $cartItems,
        string $paymentMethod = 'cod',
        string $couponCode = ''
    ): array {
        if (empty($cartItems)) {
            return ['success' => false, 'message' => 'Giỏ hàng đang trống.'];
        }

        // Bắt đầu Transaction
        $this->pdo->beginTransaction();

        try {
            // ── BƯỚC 1: Khóa và kiểm tra tồn kho từng biến thể (FOR UPDATE) ──
            $variantIds = array_keys($cartItems);
            $placeholders = implode(',', array_fill(0, count($variantIds), '?'));

            $lockSql = "
                SELECT 
                    pv.id,
                    pv.stock_qty,
                    pv.price,
                    pv.sale_price,
                    COALESCE(pv.sale_price, pv.price) AS current_price,
                    p.name AS product_name
                FROM product_variants pv
                INNER JOIN products p ON p.id = pv.product_id
                WHERE pv.id IN ({$placeholders}) AND pv.is_active = 1
                FOR UPDATE
            ";

            $stmt = $this->pdo->prepare($lockSql);
            $stmt->execute($variantIds);
            $dbVariants = $stmt->fetchAll();

            $variantMap = [];
            foreach ($dbVariants as $dv) {
                $variantMap[$dv['id']] = $dv;
            }

            $subtotal = 0;
            $outOfStockItems = [];

            foreach ($cartItems as $vid => $item) {
                if (!isset($variantMap[$vid])) {
                    throw new RuntimeException("Sản phẩm \"{$item['product_name']}\" không còn tồn tại hoặc đã ngừng kinh doanh.");
                }

                $dbVar = $variantMap[$vid];
                $reqQty = (int) $item['quantity'];

                if ($dbVar['stock_qty'] < $reqQty) {
                    $outOfStockItems[] = "{$dbVar['product_name']} (còn {$dbVar['stock_qty']} cái)";
                }

                $price = !empty($dbVar['current_price']) ? (float)$dbVar['current_price'] : (float)$item['price'];
                $subtotal += $price * $reqQty;
            }

            if (!empty($outOfStockItems)) {
                throw new RuntimeException("Một số sản phẩm không đủ số lượng trong kho: " . implode(', ', $outOfStockItems));
            }

            // Phí ship tính từ giá lấy lại trong database, không tin giá cũ lưu trong giỏ
            $shippingFee = self::shippingFee($subtotal);
            // Mã giảm giá: khóa dòng coupon để hai đơn cùng lúc không vượt max_uses
            $discount = 0;
            $couponId = null;
            if ($couponCode !== '') {
                $cs = $this->pdo->prepare('SELECT * FROM coupons WHERE code = ? FOR UPDATE');
                $cs->execute([strtoupper($couponCode)]);
                $coupon = $cs->fetch() ?: null;
                [$discount, $couponErr] = self::couponDiscount($coupon, $subtotal);
                if ($couponErr) throw new RuntimeException($couponErr);
                $couponId = (int) $coupon['id'];
            }
            $totalAmount = $subtotal + $shippingFee - $discount;

            // ── BƯỚC 2: Tạo đơn hàng mới ──
            $orderCode = 'ZT' . date('Ymd') . strtoupper(substr(uniqid(), -4));

            $orderSql = "
                INSERT INTO orders (
                    user_id, order_code, receiver_name, receiver_phone, 
                    shipping_address, payment_method, payment_status, 
                    subtotal, shipping_fee, discount_amount, total_amount, 
                    status, note, created_at
                ) VALUES (
                    :user_id, :order_code, :receiver_name, :receiver_phone,
                    :shipping_address, :payment_method, 'unpaid',
                    :subtotal, :shipping_fee, :discount, :total_amount,
                    'pending', :note, NOW()
                )
            ";

            $orderStmt = $this->pdo->prepare($orderSql);
            $orderStmt->execute([
                ':user_id'          => $userId,
                ':order_code'       => $orderCode,
                ':receiver_name'    => $addressInfo['receiver_name'],
                ':receiver_phone'   => $addressInfo['receiver_phone'],
                ':shipping_address' => $addressInfo['shipping_address'],
                ':payment_method'   => $paymentMethod,
                ':subtotal'         => $subtotal,
                ':shipping_fee'     => $shippingFee,
                ':discount'         => $discount,
                ':total_amount'     => $totalAmount,
                ':note'             => $addressInfo['note'] ?? '',
            ]);

            $orderId = (int) $this->pdo->lastInsertId();
            if ($couponId) {
                $this->pdo->prepare('UPDATE coupons SET used_count = used_count + 1 WHERE id = ?')->execute([$couponId]);
                $this->pdo->prepare('INSERT INTO order_coupons (order_id, coupon_id) VALUES (?, ?)')->execute([$orderId, $couponId]);
            }

            // ── BƯỚC 3: Lưu chi tiết đơn hàng (Snapshot tên & giá) ──
            $itemSql = "
                INSERT INTO order_items (
                    order_id, variant_id, product_name, variant_info, 
                    unit_price, quantity, total_price
                ) VALUES (
                    :order_id, :variant_id, :product_name, :variant_info,
                    :unit_price, :quantity, :total_price
                )
            ";
            $itemStmt = $this->pdo->prepare($itemSql);

            // ── BƯỚC 4: Trừ tồn kho từng biến thể ──
            $stockSql = "
                UPDATE product_variants 
                SET stock_qty = stock_qty - :qty_minus 
                WHERE id = :id AND stock_qty >= :qty_check
            ";
            $stockStmt = $this->pdo->prepare($stockSql);

            foreach ($cartItems as $vid => $item) {
                $qty = (int) $item['quantity'];
                $unitPrice = !empty($variantMap[$vid]['current_price']) ? (float)$variantMap[$vid]['current_price'] : (float)$item['price'];
                $lineTotal = $unitPrice * $qty;

                // Insert order_item
                $itemStmt->execute([
                    ':order_id'     => $orderId,
                    ':variant_id'   => $vid,
                    ':product_name' => $item['product_name'] ?? $variantMap[$vid]['product_name'],
                    ':variant_info' => $item['variant_info'] ?? '',
                    ':unit_price'   => $unitPrice,
                    ':quantity'     => $qty,
                    ':total_price'  => $lineTotal,
                ]);

                // Trừ kho
                $stockStmt->execute([
                    ':qty_minus' => $qty,
                    ':qty_check' => $qty,
                    ':id'        => $vid,
                ]);

                if ($stockStmt->rowCount() === 0) {
                    throw new RuntimeException("Lỗi trừ tồn kho sản phẩm ID {$vid}. Kho không đủ hàng.");
                }
            }

            // ── BƯỚC 5: Ghi log lịch sử trạng thái ──
            try {
                $logSql = "INSERT INTO order_status_logs (order_id, new_status, changed_by, note, created_at)
                           VALUES (?, 'pending', ?, 'Khách hàng tạo đơn hàng qua Website', NOW())";
                $this->pdo->prepare($logSql)->execute([$orderId, $userId]);
            } catch (Exception $ex) {
                // Ignore log error if table doesn't block transaction
            }

            // Hoàn tất Transaction
            $this->pdo->commit();

            return [
                'success'    => true,
                'order_id'   => $orderId,
                'order_code' => $orderCode,
                'message'    => 'Đặt hàng thành công!',
            ];

        } catch (Throwable $e) {
            // Có lỗi -> Rollback lập tức
            if ($this->pdo->inTransaction()) {
                $this->pdo->rollBack();
            }
            error_log('[ZenTech][Order Transaction Error] ' . $e->getMessage());

            return [
                'success' => false,
                'message' => $e->getMessage(),
            ];
        }
    }

    /**
     * Lấy danh sách đơn hàng của một người dùng
     */
    public function getByUser(int $userId): array
    {
        $sql = "
            SELECT 
                o.*,
                COUNT(oi.id) AS item_count
            FROM orders o
            LEFT JOIN order_items oi ON oi.order_id = o.id
            WHERE o.user_id = ?
            GROUP BY o.id
            ORDER BY o.created_at DESC
        ";
        return $this->rawQuery($sql, [$userId]);
    }

    /**
     * Lấy chi tiết đơn hàng kèm các mặt hàng (order_items)
     */
    public function getById(int $id): ?array
    {
        $order = $this->findById('orders', $id);
        if (!$order) {
            return null;
        }

        $itemsSql = "
            SELECT 
                oi.*,
                pv.sku,
                pv.image_url AS variant_image,
                p.thumbnail_url AS product_thumbnail,
                p.slug AS product_slug
            FROM order_items oi
            LEFT JOIN product_variants pv ON pv.id = oi.variant_id
            LEFT JOIN products p ON p.id = pv.product_id
            WHERE oi.order_id = ?
            ORDER BY oi.id ASC
        ";
        $order['items'] = $this->rawQuery($itemsSql, [$id]);

        return $order;
    }

    /**
     * Khách hàng hủy đơn khi ở trạng thái 'pending'
     */
    public function cancel(int $id, int $userId): bool
    {
        $this->pdo->beginTransaction();
        try {
            $order = $this->rawQueryOne("SELECT * FROM orders WHERE id = ? AND user_id = ? FOR UPDATE", [$id, $userId]);
            if (!$order || $order['status'] !== 'pending') {
                $this->pdo->rollBack();
                return false;
            }

            // Hoàn lại số lượng tồn kho
            $this->restockOrder($id);

            // Cập nhật trạng thái
            $this->pdo->prepare("UPDATE orders SET status = 'cancelled', updated_at = NOW() WHERE id = ?")->execute([$id]);

            // Ghi log (lỗi log sẽ rollback cả giao dịch để dữ liệu nhất quán)
            $this->pdo->prepare("INSERT INTO order_status_logs (order_id, old_status, new_status, changed_by, note, created_at) VALUES (?, 'pending', 'cancelled', ?, 'Khách hàng tự hủy đơn', NOW())")->execute([$id, $userId]);

            $this->pdo->commit();
            return true;
        } catch (Throwable $e) {
            if ($this->pdo->inTransaction()) {
                $this->pdo->rollBack();
            }
            error_log('[ZenTech][Order cancel] ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Admin: Lấy danh sách đơn hàng có phân trang & lọc trạng thái
     */
    public function getAllAdmin(array $filters = [], int $page = 1, int $perPage = 10): array
    {
        $where = ['1=1'];
        $params = [];

        if (!empty($filters['status'])) {
            $where[] = 'o.status = :status';
            $params[':status'] = $filters['status'];
        }

        if (!empty($filters['search'])) {
            $where[] = '(o.order_code LIKE :kw OR o.receiver_name LIKE :kw OR o.receiver_phone LIKE :kw)';
            $params[':kw'] = '%' . $filters['search'] . '%';
        }

        $whereClause = implode(' AND ', $where);

        $sql = "
            SELECT 
                o.*,
                u.full_name AS user_name,
                u.email AS user_email,
                COUNT(oi.id) AS item_count
            FROM orders o
            LEFT JOIN users u ON u.id = o.user_id
            LEFT JOIN order_items oi ON oi.order_id = o.id
            WHERE {$whereClause}
            GROUP BY o.id
            ORDER BY o.created_at DESC
        ";

        return $this->paginate($sql, $params, $page, $perPage);
    }

    /** Các chuyển trạng thái hợp lệ (state machine). */
    public const TRANSITIONS = [
        'pending'    => ['confirmed', 'cancelled'],
        'confirmed'  => ['processing', 'cancelled'],
        'processing' => ['shipping', 'cancelled'],
        'shipping'   => ['delivered', 'returned'],
        'delivered'  => ['returned'],
        'cancelled'  => [],
        'returned'   => [],
    ];

    /**
     * Admin: Cập nhật trạng thái đơn hàng.
     * - Khóa đơn (FOR UPDATE) để tránh race giữa hai lần cập nhật/hủy.
     * - Chỉ cho phép chuyển trạng thái hợp lệ.
     * - Hủy/hoàn trả đơn sẽ hoàn lại tồn kho trong cùng transaction.
     */
    public function updateStatus(int $id, string $status, ?int $changedBy = null): bool
    {
        if (!array_key_exists($status, self::TRANSITIONS)) {
            return false;
        }

        $this->pdo->beginTransaction();
        try {
            $order = $this->rawQueryOne("SELECT status FROM orders WHERE id = ? FOR UPDATE", [$id]);
            if (!$order || !in_array($status, self::TRANSITIONS[$order['status']] ?? [], true)) {
                $this->pdo->rollBack();
                return false;
            }

            if (in_array($status, ['cancelled', 'returned'], true)) {
                $this->restockOrder($id);
            }

            $this->pdo->prepare("UPDATE orders SET status = ?, updated_at = NOW() WHERE id = ?")
                      ->execute([$status, $id]);

            $this->pdo->prepare(
                "INSERT INTO order_status_logs (order_id, old_status, new_status, changed_by, note, created_at)
                 VALUES (?, ?, ?, ?, 'Admin cập nhật trạng thái', NOW())"
            )->execute([$id, $order['status'], $status, $changedBy]);

            $this->pdo->commit();
            return true;
        } catch (Throwable $e) {
            if ($this->pdo->inTransaction()) {
                $this->pdo->rollBack();
            }
            error_log('[ZenTech][Order updateStatus] ' . $e->getMessage());
            return false;
        }
    }

    /** Cộng lại tồn kho theo các dòng của đơn (gọi trong transaction). */
    private function restockOrder(int $orderId): void
    {
        $this->pdo->prepare(
            "UPDATE product_variants pv
             JOIN order_items oi ON oi.variant_id = pv.id
             SET pv.stock_qty = pv.stock_qty + oi.quantity
             WHERE oi.order_id = ?"
        )->execute([$orderId]);
        // Hủy/hoàn đơn thì trả lại lượt dùng mã giảm giá
        $this->pdo->prepare(
            "UPDATE coupons c JOIN order_coupons oc ON oc.coupon_id = c.id
             SET c.used_count = GREATEST(c.used_count - 1, 0)
             WHERE oc.order_id = ?"
        )->execute([$orderId]);
    }

    /** Xem trước tiền giảm cho giỏ hiện tại (giá lấy từ database, không khóa dòng). */
    public function previewCoupon(array $cart, string $code): array
    {
        $ids = array_map('intval', array_keys($cart));
        $subtotal = 0.0;
        if ($ids) {
            $in = implode(',', array_fill(0, count($ids), '?'));
            $st = $this->pdo->prepare("SELECT id, COALESCE(sale_price, price) AS p FROM product_variants WHERE id IN ($in) AND is_active = 1");
            $st->execute($ids);
            foreach ($st->fetchAll() as $r) $subtotal += (float) $r['p'] * (int) $cart[$r['id']]['quantity'];
        }
        $ship = self::shippingFee($subtotal);
        $c = $this->rawQueryOne('SELECT * FROM coupons WHERE code = ?', [strtoupper(trim($code))]);
        [$discount, $err] = self::couponDiscount($c, $subtotal);
        return ['subtotal' => (int) $subtotal, 'shipping' => $ship, 'discount' => $discount, 'total' => (int) $subtotal + $ship - $discount, 'error' => $err];
    }

    /**
     * Thống kê số lượng đơn theo từng trạng thái
     */
    public function getStatusCounts(): array
    {
        $sql = "SELECT status, COUNT(*) AS count FROM orders GROUP BY status";
        $rows = $this->rawQuery($sql);
        $counts = [
            'all'        => 0,
            'pending'    => 0,
            'confirmed'  => 0,
            'processing' => 0,
            'shipping'   => 0,
            'delivered'  => 0,
            'cancelled'  => 0,
        ];
        foreach ($rows as $r) {
            $counts[$r['status']] = (int)$r['count'];
            $counts['all'] += (int)$r['count'];
        }
        return $counts;
    }
}
