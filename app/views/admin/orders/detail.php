<?php
/**
 * VIEW: Admin Order Detail & Status Management
 *
 * Variables:
 *   $order     : array
 *   $orderLogs : array
 */
$statuses = [
    'pending'    => 'Chờ xác nhận',
    'confirmed'  => 'Đã xác nhận',
    'processing' => 'Đang xử lý chuẩn bị hàng',
    'shipping'   => 'Đang giao hàng',
    'delivered'  => 'Đã giao thành công',
    'cancelled'  => 'Đã hủy đơn',
];
?>

<div class="max-w-5xl mx-auto space-y-6">
    <div class="flex items-center justify-between pb-4 border-b border-zinc-800">
        <div>
            <a href="/admin/orders" class="text-xs text-zinc-400 hover:text-accent-400 flex items-center gap-1 mb-1">
                &larr; Quay lại danh sách đơn hàng
            </a>
            <h1 class="text-2xl font-black text-white tracking-tight flex items-center gap-3">
                <span>Chi Tiết Đơn Hàng:</span>
                <span class="font-mono text-accent-400"><?= htmlspecialchars($order['order_code']) ?></span>
            </h1>
        </div>

        <!-- Form Update Status -->
        <form action="/admin/orders/update/<?= $order['id'] ?>" method="POST" class="flex items-center gap-2">
<?= Csrf::field() ?>
<?php $next = OrderModel::TRANSITIONS[$order['status']] ?? []; ?>
<?php if ($next): ?>
            <select name="status" class="bg-zinc-900 border border-zinc-700 text-xs font-semibold text-white rounded-xl px-3 py-2 outline-none focus:border-accent-400">
                <?php foreach ($next as $k): ?>
                    <option value="<?= $k ?>"><?= $statuses[$k] ?? $k ?> (<?= strtoupper($k) ?>)</option>
                <?php endforeach; ?>
            </select>
            <button type="submit" class="px-4 py-2 rounded-xl text-xs font-bold bg-accent-500 hover:bg-accent-400 text-black transition">
                Cập nhật trạng thái
            </button>
        <?php else: ?><span class="text-xs text-zinc-500">Đơn đã kết thúc, không thể đổi trạng thái.</span><?php endif; ?>
        </form>
    </div>

    <!-- Info Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold uppercase tracking-wider text-zinc-400 text-[11px]">Khách Hàng & Giao Nhận</h3>
            <div class="font-bold text-white text-sm"><?= htmlspecialchars($order['receiver_name']) ?></div>
            <div class="text-zinc-300">Điện thoại: <span class="font-mono font-bold"><?= htmlspecialchars($order['receiver_phone']) ?></span></div>
            <div class="text-zinc-400">Địa chỉ: <?= htmlspecialchars($order['shipping_address']) ?></div>
        </div>

        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold uppercase tracking-wider text-zinc-400 text-[11px]">Thanh Toán & Ngày Đặt</h3>
            <div class="text-zinc-300">Phương thức: <span class="font-bold text-white"><?= strtoupper($order['payment_method']) ?></span></div>
            <div class="text-zinc-300">Trạng thái: <span class="font-bold text-amber-400"><?= strtoupper($order['payment_status']) ?></span></div>
            <div class="text-zinc-400">Ngày tạo: <?= date('d/m/Y H:i:s', strtotime($order['created_at'])) ?></div>
        </div>

        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold uppercase tracking-wider text-zinc-400 text-[11px]">Ghi Chú Đơn</h3>
            <p class="text-zinc-400 italic">
                <?= !empty($order['note']) ? htmlspecialchars($order['note']) : 'Không có ghi chú' ?>
            </p>
        </div>
    </div>

    <!-- Items Table -->
    <div class="bg-zinc-900/60 border border-zinc-800 rounded-3xl overflow-hidden p-6 space-y-4">
        <h2 class="text-sm font-bold text-white uppercase tracking-wider">
            Các Mặt Hàng Trong Đơn
        </h2>

        <div class="divide-y divide-zinc-800">
            <?php foreach ($order['items'] ?? [] as $item): ?>
                <div class="py-3.5 first:pt-0 last:pb-0 flex items-center justify-between gap-4">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-lg bg-zinc-950 border border-zinc-800 p-1 flex items-center justify-center shrink-0">
                            <img src="<?= htmlspecialchars($item['variant_image'] ?? ($item['product_thumbnail'] ?? 'https://placehold.co/100x100/18181b/22d3ee')) ?>" 
                                 alt="" class="max-w-full max-h-full object-contain">
                        </div>
                        <div>
                            <div class="text-xs font-bold text-white"><?= htmlspecialchars($item['product_name']) ?></div>
                            <div class="text-[11px] text-zinc-400">
                                Phân loại: <?= htmlspecialchars($item['variant_info'] ?? 'Mặc định') ?> • SKU: <span class="font-mono text-accent-400"><?= htmlspecialchars($item['sku'] ?? 'N/A') ?></span>
                            </div>
                        </div>
                    </div>

                    <div class="text-right text-xs">
                        <div class="text-zinc-400"><?= number_format($item['unit_price'], 0, ',', '.') ?>₫ × <strong class="text-white"><?= $item['quantity'] ?></strong></div>
                        <div class="font-bold text-accent-400 text-sm"><?= number_format($item['total_price'], 0, ',', '.') ?>₫</div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <div class="pt-4 border-t border-zinc-800 max-w-xs ml-auto space-y-1.5 text-xs text-right">
            <div class="flex justify-between text-zinc-400">
                <span>Tiền hàng:</span>
                <span class="font-bold text-zinc-200"><?= number_format($order['subtotal'], 0, ',', '.') ?>₫</span>
            </div>
            <div class="flex justify-between text-zinc-400">
                <span>Phí ship:</span>
                <span class="font-bold text-zinc-200"><?= number_format($order['shipping_fee'], 0, ',', '.') ?>₫</span>
            </div>
            <?php if (!empty($order['discount_amount'])): ?>
            <div class="flex justify-between text-zinc-400">
                <span>Mã giảm giá:</span>
                <span class="font-bold text-green-400">-<?= number_format($order['discount_amount'], 0, ',', '.') ?>₫</span>
            </div>
            <?php endif; ?>
            <div class="flex justify-between text-base font-bold text-white pt-2 border-t border-zinc-800">
                <span>Tổng cộng:</span>
                <span class="text-accent-400"><?= number_format($order['total_amount'], 0, ',', '.') ?>₫</span>
            </div>
        </div>
    </div>

    <!-- History Logs -->
    <?php if (!empty($orderLogs)): ?>
        <div class="bg-zinc-900/40 border border-zinc-800 rounded-3xl p-6">
            <h3 class="text-xs font-bold uppercase tracking-wider text-zinc-400 mb-3">Lịch Sử Trạng Thái</h3>
            <div class="space-y-2 text-xs">
                <?php foreach ($orderLogs as $log): ?>
                    <div class="flex items-center gap-3 text-zinc-400">
                        <span class="font-mono text-[11px] text-zinc-500"><?= date('d/m/Y H:i', strtotime($log['created_at'])) ?></span>
                        <span class="px-2 py-0.5 rounded bg-zinc-800 text-zinc-200 font-semibold"><?= strtoupper($log['new_status']) ?></span>
                        <span><?= htmlspecialchars($log['note'] ?? '') ?></span>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php endif; ?>
</div>
