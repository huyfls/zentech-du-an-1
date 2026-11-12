<?php
/**
 * VIEW: Chi tiết đơn hàng người dùng
 *
 * Variables:
 *   $order: array (kèm items)
 */
$statusMap = [
    'pending'    => ['Chờ xác nhận', 'bg-amber-500/10 text-amber-400 border-amber-500/20'],
    'confirmed'  => ['Đã xác nhận',  'bg-accent-500/10 text-accent-400 border-accent-500/20'],
    'processing' => ['Đang xử lý',   'bg-ember-500/10 text-ember-400 border-ember-500/20'],
    'shipping'   => ['Đang giao',     'bg-accent-500/10 text-accent-400 border-accent-500/20'],
    'delivered'  => ['Đã giao',       'bg-green-500/10 text-green-400 border-green-500/20'],
    'cancelled'  => ['Đã hủy',        'bg-red-500/10 text-red-400 border-red-500/20'],
];
[$statusText, $statusClass] = $statusMap[$order['status']] ?? [$order['status'], 'bg-zinc-800 text-zinc-300 border-zinc-700'];
?>

<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <nav class="flex items-center gap-2 text-xs text-zinc-400 mb-6">
        <a href="/" class="hover:text-accent-400">Trang chủ</a>
        <span>/</span>
        <a href="/orders" class="hover:text-accent-400">Đơn hàng</a>
        <span>/</span>
        <span class="text-zinc-200"><?= htmlspecialchars($order['order_code']) ?></span>
    </nav>

    <!-- Header Card -->
    <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
            <div class="flex items-center gap-3 mb-1">
                <h1 class="text-xl font-black text-white font-mono"><?= htmlspecialchars($order['order_code']) ?></h1>
                <span class="text-xs font-semibold px-3 py-0.5 rounded-full border <?= $statusClass ?>">
                    <?= $statusText ?>
                </span>
            </div>
            <p class="text-xs text-zinc-400">
                Đặt ngày <?= date('d/m/Y lúc H:i', strtotime($order['created_at'])) ?>
            </p>
        </div>

        <?php if ($order['status'] === 'pending'): ?>
            <form action="/orders/cancel/<?= $order['id'] ?>" method="POST" onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
<?= Csrf::field() ?>
                <button type="submit" class="px-4 py-2 rounded-xl text-xs font-bold bg-red-500/10 hover:bg-red-500/20 text-red-400 border border-red-500/30 transition">
                    Hủy đơn hàng
                </button>
            </form>
        <?php endif; ?>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <!-- Người nhận -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold text-white uppercase text-[11px] text-zinc-400">Người Nhận</h3>
            <div class="font-bold text-zinc-200 text-sm"><?= htmlspecialchars($order['receiver_name']) ?></div>
            <div class="text-zinc-400">SĐT: <?= htmlspecialchars($order['receiver_phone']) ?></div>
            <div class="text-zinc-400">Địa chỉ: <?= htmlspecialchars($order['shipping_address']) ?></div>
        </div>

        <!-- Thanh toán -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold text-white uppercase text-[11px] text-zinc-400">Thanh Toán</h3>
            <div class="font-semibold text-zinc-200">
                <?= strtoupper($order['payment_method']) ?> (<?= $order['payment_method'] === 'cod' ? 'Tiền mặt' : 'Chuyển khoản' ?>)
            </div>
            <div class="text-zinc-400">
                Trạng thái: <strong class="<?= $order['payment_status'] === 'paid' ? 'text-green-400' : 'text-amber-400' ?>"><?= strtoupper($order['payment_status']) ?></strong>
            </div>
        </div>

        <!-- Ghi chú -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold text-white uppercase text-[11px] text-zinc-400">Ghi Chú Đơn Hàng</h3>
            <p class="text-zinc-400 italic">
                <?= !empty($order['note']) ? htmlspecialchars($order['note']) : 'Không có ghi chú' ?>
            </p>
        </div>
    </div>

    <!-- Items List -->
    <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-6">
        <h2 class="text-sm font-bold text-white uppercase tracking-wider pb-4 border-b border-zinc-800 mb-4">
            Danh Sách Sản Phẩm
        </h2>

        <div class="divide-y divide-zinc-800">
            <?php foreach ($order['items'] ?? [] as $item): ?>
                <div class="py-4 first:pt-0 last:pb-0 flex items-center justify-between gap-4">
                    <div class="flex items-center gap-4">
                        <div class="w-14 h-14 rounded-xl bg-zinc-950 border border-zinc-800 p-1 flex items-center justify-center shrink-0">
                            <img src="<?= htmlspecialchars($item['variant_image'] ?? ($item['product_thumbnail'] ?? 'https://placehold.co/100x100/18181b/22d3ee')) ?>" 
                                 alt="" class="max-w-full max-h-full object-contain">
                        </div>
                        <div>
                            <div class="text-sm font-semibold text-zinc-200"><?= htmlspecialchars($item['product_name']) ?></div>
                            <div class="text-xs text-zinc-400">
                                <?= htmlspecialchars($item['variant_info'] ?? '') ?> • SL: <strong>x<?= $item['quantity'] ?></strong>
                            </div>
                        </div>
                    </div>

                    <div class="text-right">
                        <div class="text-xs text-zinc-500"><?= number_format($item['unit_price'], 0, ',', '.') ?>₫</div>
                        <div class="text-sm font-bold text-accent-400"><?= number_format($item['total_price'], 0, ',', '.') ?>₫</div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <!-- Breakdown Total -->
        <div class="pt-6 border-t border-zinc-800 mt-6 space-y-2 text-xs text-right max-w-xs ml-auto">
            <div class="flex justify-between text-zinc-400">
                <span>Tiền hàng:</span>
                <span class="text-zinc-200 font-bold"><?= number_format($order['subtotal'], 0, ',', '.') ?>₫</span>
            </div>
            <div class="flex justify-between text-zinc-400">
                <span>Phí vận chuyển:</span>
                <span class="text-zinc-200 font-bold"><?= number_format($order['shipping_fee'], 0, ',', '.') ?>₫</span>
            </div>
            <div class="flex justify-between text-base font-bold pt-2 border-t border-zinc-800 text-white">
                <span>Tổng cộng:</span>
                <span class="text-accent-400"><?= number_format($order['total_amount'], 0, ',', '.') ?>₫</span>
            </div>
        </div>
    </div>
</div>
