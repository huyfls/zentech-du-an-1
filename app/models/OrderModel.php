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
    public static function couponDiscount(?array $c, float $subtotal, ?array $lines = null, ?int $now = null): array
    {
        $now = $now ?? time();
        if (!$c || !(int) $c['is_active']) return [0, 'Mã giảm giá không tồn tại hoặc đã ngừng.'];
        if ($c['starts_at'] && strtotime($c['starts_at']) > $now) return [0, 'Mã giảm giá chưa đến ngày áp dụng.'];
        if ($c['expires_at'] && strtotime($c['expires_at']) < $now) return [0, 'Mã giảm giá đã hết hạn.'];
        if ($c['max_uses'] !== null && (int) $c['used_count'] >= (int) $c['max_uses']) return [0, 'Mã giảm giá đã hết lượt dùng.'];
        if ($subtotal < (float) $c['min_order_value']) {
            return [0, 'Đơn hàng cần từ ' . number_format((float) $c['min_order_value'], 0, ',', '.') . '₫ để dùng mã này.'];
        }
        // Mã giới hạn theo danh mục/sản phẩm chỉ giảm trên phần tiền hàng thuộc phạm vi đó
        $base = $subtotal;
        if ($lines !== null && (!empty($c['product_id']) || !empty($c['category_id']))) {
            $base = 0;
            foreach ($lines as $l) {
                if (!empty($c['product_id']) && (int) $l['product_id'] !== (int) $c['product_id']) continue;
                if (!empty($c['category_id']) && !in_array((int) $c['category_id'], [(int) $l['category_id'], (int) ($l['parent_id'] ?? 0)], true)) continue;
                $base += (float) $l['amount'];
            }
            if ($base <= 0) return [0, 'Giỏ hàng không có sản phẩm thuộc phạm vi áp dụng của mã này.'];
        }
        $d = $c['discount_type'] === 'percent' ? (int) floor($base * (float) $c['discount_value'] / 100) : (int) $c['discount_value'];
        return [min($d, (int) $base), null];
    }

    /**
     * Quy trình đặt hàng an toàn (Database Transaction với FOR UPDATE lock)
     *
     * @param int   $userId
     * @param array $addressInfo ['receiver_name', 'receiver_phone', 'shipping_address', 'note']
     * @param array $cartItems   [$variantId => ['variant_id', 'product_name', 'variant_info', 'price', 'quantity']]
     * @param string $paymentMethod 'cod' | 'online' (cổng thanh toán giả lập) | 'wallet' (ví ZenTech)
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
                    p.name AS product_name, p.id AS product_id, p.category_id, c.parent_id
                FROM product_variants pv
                INNER JOIN products p ON p.id = pv.product_id
                LEFT JOIN categories c ON c.id = p.category_id
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
            $lines = [];

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
                $lines[] = $dbVar + ['amount' => $price * $reqQty];
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
                [$discount, $couponErr] = self::couponDiscount($coupon, $subtotal, $lines);
                if ($couponErr) throw new RuntimeException($couponErr);
                $couponId = (int) $coupon['id'];
            }
            $totalAmount = $subtotal + $shippingFee - $discount;

            // Ví ZenTech: khóa dòng user để hai đơn cùng lúc không tiêu quá số dư
            if ($paymentMethod === 'wallet') {
                $bal = $this->pdo->prepare('SELECT wallet_balance FROM users WHERE id = ? FOR UPDATE');
                $bal->execute([$userId]);
                if ((float) $bal->fetchColumn() < $totalAmount) {
                    throw new RuntimeException('Số dư ví ZenTech không đủ để thanh toán đơn này.');
                }
            }
            $paymentStatus = $paymentMethod === 'cod' ? 'unpaid' : 'paid';

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
                    :shipping_address, :payment_method, :payment_status,
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
                ':payment_status'   => $paymentStatus,
                ':subtotal'         => $subtotal,
                ':shipping_fee'     => $shippingFee,
                ':discount'         => $discount,
                ':total_amount'     => $totalAmount,
                ':note'             => $addressInfo['note'] ?? '',
            ]);

            $orderId = (int) $this->pdo->lastInsertId();
            if ($paymentMethod === 'wallet') {
                $this->walletEntry($userId, $orderId, -$totalAmount, 'Thanh toán đơn ' . $orderCode);
            }
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
            if (!$order || !in_array($order['status'], self::CUSTOMER_CANCELLABLE, true)) {
                $this->pdo->rollBack();
                return false;
            }

            $this->restockOrder($id);
            $this->refundIfPaid($order, 'Hoàn tiền đơn ' . $order['order_code'] . ' (khách hủy)');
            $this->pdo->prepare("UPDATE orders SET status = 'cancelled', cancelled_reason = 'Khách hàng tự hủy', updated_at = NOW() WHERE id = ?")->execute([$id]);
            $this->log($id, $order['status'], 'cancelled', $userId, 'Khách hàng tự hủy đơn');

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

    public const LABELS = [
        'pending'          => 'Chờ xác nhận',
        'confirmed'        => 'Đã xác nhận',
        'processing'       => 'Đang đóng gói',
        'handed_over'      => 'Đã giao cho đơn vị vận chuyển',
        'shipping'         => 'Shipper đang giao',
        'delivered'        => 'Đã nhận hàng',
        'completed'        => 'Hoàn thành',
        'return_requested' => 'Yêu cầu trả hàng',
        'returned'         => 'Đã trả hàng',
        'cancelled'        => 'Đã hủy',
    ];
    public const PAYMENT_LABELS = ['cod' => 'Thanh toán khi nhận hàng (COD)', 'online' => 'Thanh toán online', 'wallet' => 'Ví ZenTech', 'vnpay' => 'VNPay', 'momo' => 'MoMo', 'bank_transfer' => 'Chuyển khoản'];
    public const PAYMENT_STATUS_LABELS = ['unpaid' => 'Chưa thanh toán', 'paid' => 'Đã thanh toán', 'refunded' => 'Đã hoàn tiền'];
    public const RETURN_REASONS = ['Sản phẩm lỗi / không hoạt động', 'Giao sai sản phẩm / sai phân loại', 'Sản phẩm bị hư hỏng khi vận chuyển', 'Thiếu phụ kiện / quà tặng', 'Không đúng mô tả', 'Lý do khác'];
    public const RETURN_DAYS = 7;   // số ngày được trả hàng kể từ khi khách bấm "Đã nhận hàng"
    public const MAX_FAILS   = 3;   // giao thất bại đủ 3 lần ở một chặng thì hủy đơn, hàng về kho
    public const CUSTOMER_CANCELLABLE = ['pending', 'confirmed', 'processing']; // đã giao cho đơn vị vận chuyển thì không hủy được

    /**
     * Bước admin được bấm (chỉ đi một chiều). Admin KHÔNG được bấm "đã giao":
     * khách tự bấm "Đã nhận hàng"; giao thất bại ghi bằng deliveryFailed().
     */
    public const TRANSITIONS = [
        'pending'          => ['confirmed', 'cancelled'],
        'confirmed'        => ['processing', 'cancelled'],
        'processing'       => ['handed_over', 'cancelled'],
        'handed_over'      => ['shipping'],
        'shipping'         => [],
        'delivered'        => ['completed'], // chỉ khi đã hết hạn trả hàng
        'completed'        => [],
        'return_requested' => [],            // xử lý ở tab Hoàn hàng
        'returned'         => [],
        'cancelled'        => [],
    ];

    /** [nhãn, class màu] để hiện huy hiệu trạng thái ở mọi trang. */
    public static function badge(string $status): array
    {
        $c = [
            'pending' => 'amber', 'confirmed' => 'accent', 'processing' => 'ember', 'handed_over' => 'ember',
            'shipping' => 'accent', 'delivered' => 'green', 'completed' => 'green', 'return_requested' => 'amber',
            'cancelled' => 'red',
        ][$status] ?? null;
        return [self::LABELS[$status] ?? $status, $c ? "bg-$c-500/10 text-$c-400 border-$c-500/20" : 'bg-zinc-800 text-zinc-300 border-zinc-700'];
    }

    /** Hạn trả hàng còn hay không (đơn đã nhận). */
    public static function canReturn(array $o, ?int $now = null): bool
    {
        return $o['status'] === 'delivered' && $o['delivered_at']
            && strtotime($o['delivered_at']) + self::RETURN_DAYS * 86400 > ($now ?? time());
    }

    /** Admin cập nhật trạng thái theo TRANSITIONS, trong transaction có khóa đơn. */
    public function updateStatus(int $id, string $status, ?int $changedBy = null): bool
    {
        if (!array_key_exists($status, self::TRANSITIONS)) {
            return false;
        }
        return $this->tx($id, function (array $o) use ($id, $status, $changedBy) {
            if (!in_array($status, self::TRANSITIONS[$o['status']] ?? [], true)) return false;
            if ($status === 'completed' && self::canReturn($o)) return false; // còn trong hạn trả hàng
            if ($status === 'cancelled') {
                $this->restockOrder($id);
                $this->refundIfPaid($o, 'Hoàn tiền đơn ' . $o['order_code'] . ' (shop hủy)');
                $this->pdo->prepare("UPDATE orders SET cancelled_reason = 'Shop hủy đơn' WHERE id = ?")->execute([$id]);
            }
            // sang chặng shipper: đếm lại số lần giao thất bại
            $this->pdo->prepare('UPDATE orders SET status = ?, fail_count = IF(? = "shipping", 0, fail_count), updated_at = NOW() WHERE id = ?')
                      ->execute([$status, $status, $id]);
            $this->log($id, $o['status'], $status, $changedBy, 'Admin cập nhật: ' . self::LABELS[$status]);
            return true;
        });
    }

    /** Admin ghi nhận một lần giao thất bại; lần thứ MAX_FAILS thì hủy đơn và trả hàng về kho. */
    public function deliveryFailed(int $id, int $adminId, string $note = ''): ?int
    {
        $n = null;
        $ok = $this->tx($id, function (array $o) use ($id, $adminId, $note, &$n) {
            if (!in_array($o['status'], ['handed_over', 'shipping'], true)) return false;
            $n = (int) $o['fail_count'] + 1;
            $stage = $o['status'] === 'handed_over' ? 'Đơn vị vận chuyển' : 'Shipper';
            $msg = "$stage giao thất bại lần $n" . ($note !== '' ? ": $note" : '');
            if ($n >= self::MAX_FAILS) {
                $this->restockOrder($id);
                $this->refundIfPaid($o, 'Hoàn tiền đơn ' . $o['order_code'] . ' (giao thất bại)');
                $this->pdo->prepare("UPDATE orders SET status = 'cancelled', fail_count = ?, cancelled_reason = ?, updated_at = NOW() WHERE id = ?")
                          ->execute([$n, "Giao thất bại {$n} lần", $id]);
                $this->log($id, $o['status'], 'cancelled', $adminId, $msg . ' → hủy đơn, hàng về kho');
            } else {
                $this->pdo->prepare('UPDATE orders SET fail_count = ?, updated_at = NOW() WHERE id = ?')->execute([$n, $id]);
                $this->log($id, $o['status'], $o['status'], $adminId, $msg);
            }
            return true;
        });
        return $ok ? $n : null;
    }

    /** Khách bấm "Đã nhận hàng": COD coi như đã thu tiền. */
    public function confirmReceived(int $id, int $userId): bool
    {
        return $this->tx($id, function (array $o) use ($id, $userId) {
            if ((int) $o['user_id'] !== $userId || $o['status'] !== 'shipping') return false;
            $this->pdo->prepare("UPDATE orders SET status = 'delivered', delivered_at = NOW(), payment_status = 'paid', updated_at = NOW() WHERE id = ?")->execute([$id]);
            $this->log($id, 'shipping', 'delivered', $userId, 'Khách hàng xác nhận đã nhận hàng');
            return true;
        });
    }

    /** Khách gửi yêu cầu trả hàng (trong RETURN_DAYS ngày kể từ khi nhận). $r đã được controller kiểm tra. */
    public function requestReturn(int $id, int $userId, array $r): bool
    {
        return $this->tx($id, function (array $o) use ($id, $userId, $r) {
            if ((int) $o['user_id'] !== $userId || !self::canReturn($o)) return false;
            $this->pdo->prepare('INSERT INTO order_returns (order_id, user_id, reason, description, evidence_url, refund_method, bank_info) VALUES (?, ?, ?, ?, ?, ?, ?)')
                      ->execute([$id, $userId, $r['reason'], $r['description'], $r['evidence_url'], $r['refund_method'], $r['bank_info']]);
            $this->pdo->prepare("UPDATE orders SET status = 'return_requested', updated_at = NOW() WHERE id = ?")->execute([$id]);
            $this->log($id, 'delivered', 'return_requested', $userId, 'Khách yêu cầu trả hàng: ' . $r['reason']);
            return true;
        });
    }

    /** Admin duyệt / từ chối trả hàng. Duyệt: hàng về kho + hoàn tiền (ví hoặc chuyển khoản). Từ chối: đơn hoàn thành. */
    public function resolveReturn(int $id, bool $approve, int $adminId, string $note = ''): bool
    {
        return $this->tx($id, function (array $o) use ($id, $approve, $adminId, $note) {
            if ($o['status'] !== 'return_requested') return false;
            $ret = $this->rawQueryOne("SELECT * FROM order_returns WHERE order_id = ? AND status = 'pending'", [$id]);
            if (!$ret) return false;
            if ($approve) {
                $this->restockOrder($id, false);
                if ($ret['refund_method'] === 'wallet') {
                    $this->walletEntry((int) $o['user_id'], $id, (float) $o['total_amount'], 'Hoàn tiền trả hàng đơn ' . $o['order_code']);
                }
                // hoàn qua ngân hàng: kế toán chuyển khoản thủ công theo bank_info, ở đây chỉ ghi nhận đã hoàn
                $this->pdo->prepare("UPDATE orders SET payment_status = 'refunded' WHERE id = ?")->execute([$id]);
            }
            $new = $approve ? 'returned' : 'completed';
            $this->pdo->prepare("UPDATE order_returns SET status = ?, admin_note = ?, resolved_at = NOW() WHERE id = ?")
                      ->execute([$approve ? 'approved' : 'rejected', $note ?: null, $ret['id']]);
            $this->pdo->prepare('UPDATE orders SET status = ?, updated_at = NOW() WHERE id = ?')->execute([$new, $id]);
            $this->log($id, 'return_requested', $new, $adminId, ($approve ? 'Duyệt trả hàng' : 'Từ chối trả hàng') . ($note !== '' ? ": $note" : ''));
            return true;
        });
    }

    /** Chạy $fn trong transaction với dòng đơn đã khóa; $fn trả false thì rollback. */
    private function tx(int $id, callable $fn): bool
    {
        $this->pdo->beginTransaction();
        try {
            $o = $this->rawQueryOne('SELECT * FROM orders WHERE id = ? FOR UPDATE', [$id]);
            if (!$o || !$fn($o)) {
                $this->pdo->rollBack();
                return false;
            }
            $this->pdo->commit();
            return true;
        } catch (Throwable $e) {
            if ($this->pdo->inTransaction()) $this->pdo->rollBack();
            error_log('[ZenTech][Order] ' . $e->getMessage());
            return false;
        }
    }

    private function log(int $id, ?string $old, string $new, ?int $by, string $note): void
    {
        $this->pdo->prepare('INSERT INTO order_status_logs (order_id, old_status, new_status, changed_by, note, created_at) VALUES (?, ?, ?, ?, ?, NOW())')
                  ->execute([$id, $old, $new, $by, $note]);
    }

    /** Cộng/trừ ví ZenTech và ghi lịch sử (gọi trong transaction). */
    private function walletEntry(int $userId, ?int $orderId, float $amount, string $note): void
    {
        $this->pdo->prepare('UPDATE users SET wallet_balance = wallet_balance + ? WHERE id = ?')->execute([$amount, $userId]);
        $this->pdo->prepare('INSERT INTO wallet_transactions (user_id, order_id, amount, note) VALUES (?, ?, ?, ?)')->execute([$userId, $orderId, $amount, $note]);
    }

    /** Đơn đã trả tiền trước (online/ví) mà bị hủy: hoàn toàn bộ về ví ZenTech. */
    private function refundIfPaid(array $o, string $note): void
    {
        if ($o['payment_status'] !== 'paid') return;
        $this->walletEntry((int) $o['user_id'], (int) $o['id'], (float) $o['total_amount'], $note);
        $this->pdo->prepare("UPDATE orders SET payment_status = 'refunded' WHERE id = ?")->execute([$o['id']]);
    }

    /** Cộng lại tồn kho theo các dòng của đơn (gọi trong transaction). */
    private function restockOrder(int $orderId, bool $releaseCoupon = true): void
    {
        $this->pdo->prepare(
            "UPDATE product_variants pv
             JOIN order_items oi ON oi.variant_id = pv.id
             SET pv.stock_qty = pv.stock_qty + oi.quantity
             WHERE oi.order_id = ?"
        )->execute([$orderId]);
        // Hủy đơn thì trả lại lượt dùng mã giảm giá (trả hàng thì không: mã đã được dùng thật)
        if ($releaseCoupon) $this->pdo->prepare(
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
        $lines = [];
        if ($ids) {
            $in = implode(',', array_fill(0, count($ids), '?'));
            $st = $this->pdo->prepare("SELECT pv.id, COALESCE(pv.sale_price, pv.price) AS p, p.id AS product_id, p.category_id, c.parent_id
                                       FROM product_variants pv JOIN products p ON p.id = pv.product_id LEFT JOIN categories c ON c.id = p.category_id
                                       WHERE pv.id IN ($in) AND pv.is_active = 1");
            $st->execute($ids);
            foreach ($st->fetchAll() as $r) {
                $amt = (float) $r['p'] * (int) $cart[$r['id']]['quantity'];
                $subtotal += $amt;
                $lines[] = $r + ['amount' => $amt];
            }
        }
        $ship = self::shippingFee($subtotal);
        $c = $this->rawQueryOne('SELECT * FROM coupons WHERE code = ?', [strtoupper(trim($code))]);
        [$discount, $err] = self::couponDiscount($c, $subtotal, $lines);
        return ['subtotal' => (int) $subtotal, 'shipping' => $ship, 'discount' => $discount, 'total' => (int) $subtotal + $ship - $discount, 'error' => $err];
    }

    /**
     * Thống kê số lượng đơn theo từng trạng thái
     */
    public function getStatusCounts(): array
    {
        $sql = "SELECT status, COUNT(*) AS count FROM orders GROUP BY status";
        $rows = $this->rawQuery($sql);
        $counts = ['all' => 0] + array_fill_keys(array_keys(self::LABELS), 0);
        foreach ($rows as $r) {
            $counts[$r['status']] = (int)$r['count'];
            $counts['all'] += (int)$r['count'];
        }
        return $counts;
    }
}
