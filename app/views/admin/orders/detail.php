<?php
/**
 * VIEW: Admin Order Detail & Status Management
 *
 * Variables:
 *   $order     : array
 *   $orderLogs : array
 */
$statuses = OrderModel::LABELS;
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

        <!-- Thao tác theo bước (một chiều) -->
        <div class="flex flex-col items-end gap-2">
<?php $next = OrderModel::TRANSITIONS[$order['status']] ?? []; ?>
<?php if ($order['status'] === 'delivered' && OrderModel::canReturn($order)) $next = []; ?>
            <div class="text-xs text-zinc-400">Trạng thái hiện tại: <strong class="text-white"><?= e($statuses[$order['status']] ?? $order['status']) ?></strong></div>
<?php if ($next): ?>
            <div class="flex flex-wrap justify-end gap-2">
                <?php foreach ($next as $k): ?>
                <form action="/admin/orders/update/<?= $order['id'] ?>" method="POST" <?= $k === 'cancelled' ? 'onsubmit="return confirm(\'Hủy đơn này? Hàng sẽ được cộng lại vào kho.\')"' : '' ?>>
                    <?= Csrf::field() ?><input type="hidden" name="status" value="<?= $k ?>">
                    <button type="submit" class="px-4 py-2 rounded-xl text-xs font-bold transition <?= $k === 'cancelled' ? 'bg-red-500/10 text-red-400 border border-red-500/30 hover:bg-red-500/20' : 'bg-accent-500 hover:bg-accent-400 text-black' ?>">
                        <?= $k === 'cancelled' ? 'Hủy đơn' : 'Chuyển sang: ' . e($statuses[$k]) ?>
                    </button>
                </form>
                <?php endforeach; ?>
            </div>
<?php endif; ?>
<?php if (in_array($order['status'], ['handed_over', 'shipping'], true)): ?>
            <form action="/admin/orders/failed/<?= $order['id'] ?>" method="POST" class="flex gap-2" onsubmit="return confirm('Ghi nhận giao thất bại lần <?= (int) $order['fail_count'] + 1 ?>/<?= OrderModel::MAX_FAILS ?>?<?= (int) $order['fail_count'] + 1 >= OrderModel::MAX_FAILS ? ' Đơn sẽ bị hủy và hàng về kho.' : '' ?>')">
                <?= Csrf::field() ?>
                <input name="note" maxlength="200" placeholder="Lý do (không liên lạc được, sai địa chỉ...)" class="bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-xs text-white w-64">
                <button type="submit" class="px-4 py-2 rounded-xl text-xs font-bold bg-amber-500/10 text-amber-400 border border-amber-500/30 hover:bg-amber-500/20">
                    Giao thất bại (<?= (int) $order['fail_count'] ?>/<?= OrderModel::MAX_FAILS ?>)
                </button>
            </form>
            <?php if ($order['status'] === 'shipping'): ?><p class="text-[11px] text-zinc-500">Đơn chuyển sang "Đã nhận hàng" khi khách bấm xác nhận trên website.</p><?php endif; ?>
<?php elseif ($order['status'] === 'delivered'): ?>
            <p class="text-[11px] text-zinc-500">Khách nhận hàng lúc <?= date('d/m/Y H:i', strtotime($order['delivered_at'])) ?>.
                <?= OrderModel::canReturn($order) ? 'Còn trong hạn ' . OrderModel::RETURN_DAYS . ' ngày trả hàng, chưa thể hoàn thành.' : 'Đã hết hạn trả hàng.' ?></p>
<?php elseif ($order['status'] === 'return_requested'): ?>
            <a href="/admin/returns" class="px-4 py-2 rounded-xl text-xs font-bold bg-amber-500/10 text-amber-400 border border-amber-500/30">Xử lý ở tab Hoàn hàng &rarr;</a>
<?php elseif (!$next): ?>
            <span class="text-xs text-zinc-500">Đơn đã kết thúc, không thể đổi trạng thái.</span>
<?php endif; ?>
        </div>
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
            <div class="text-zinc-300">Phương thức: <span class="font-bold text-white"><?= e(OrderModel::PAYMENT_LABELS[$order['payment_method']] ?? $order['payment_method']) ?></span></div>
            <div class="text-zinc-300">Thanh toán: <span class="font-bold text-amber-400"><?= e(OrderModel::PAYMENT_STATUS_LABELS[$order['payment_status']] ?? $order['payment_status']) ?></span></div>
            <?php if (!empty($order['cancelled_reason'])): ?><div class="text-red-400">Lý do hủy: <?= e($order['cancelled_reason']) ?></div><?php endif; ?>
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
                                Phân loại: <?= htmlspecialchars($item['variant_info'] ?? 'Mặc định') ?> • SKU: <span class="font-mono text-accent-400"><?= htmlspecialchars($item['sku'] ?? '—') ?></span>
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

    <?php if (!empty($return)): ?>
    <div class="bg-zinc-900/60 border border-amber-500/30 rounded-3xl p-6 text-xs space-y-2">
        <h3 class="font-bold uppercase tracking-wider text-amber-400 text-[11px]">Yêu cầu trả hàng (<?= ['pending' => 'Chờ duyệt', 'approved' => 'Đã duyệt', 'rejected' => 'Đã từ chối'][$return['status']] ?>)</h3>
        <div class="text-zinc-200"><strong>Lý do:</strong> <?= e($return['reason']) ?></div>
        <div class="text-zinc-400"><?= nl2br(e($return['description'])) ?></div>
        <?php if ($return['evidence_url']): ?><a href="<?= e($return['evidence_url']) ?>" target="_blank" rel="noopener"><img src="<?= e($return['evidence_url']) ?>" alt="Ảnh minh chứng trả hàng" class="h-32 rounded-xl border border-zinc-800"></a><?php endif; ?>
        <div class="text-zinc-300">Hoàn tiền: <?= $return['refund_method'] === 'wallet' ? 'Ví ZenTech' : 'Chuyển khoản — ' . e($return['bank_info']) ?></div>
    </div>
    <?php endif; ?>

    <!-- History Logs -->
    <?php if (!empty($orderLogs)): ?>
        <div class="bg-zinc-900/40 border border-zinc-800 rounded-3xl p-6">
            <h3 class="text-xs font-bold uppercase tracking-wider text-zinc-400 mb-3">Lịch Sử Trạng Thái</h3>
            <div class="space-y-2 text-xs">
                <?php foreach ($orderLogs as $log): ?>
                    <div class="flex items-center gap-3 text-zinc-400">
                        <span class="font-mono text-[11px] text-zinc-500"><?= date('d/m/Y H:i', strtotime($log['created_at'])) ?></span>
                        <span class="px-2 py-0.5 rounded bg-zinc-800 text-zinc-200 font-semibold"><?= e(OrderModel::LABELS[$log['new_status']] ?? $log['new_status']) ?></span>
                        <span><?= htmlspecialchars($log['note'] ?? '') ?></span>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php endif; ?>
</div>
