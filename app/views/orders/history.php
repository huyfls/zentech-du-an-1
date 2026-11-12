<?php
/**
 * VIEW: Lịch sử đơn hàng của người dùng
 *
 * Variables:
 *   $orders: array
 */
?>

<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <nav class="flex items-center gap-2 text-xs text-zinc-400 mb-6">
        <a href="/" class="hover:text-accent-400">Trang chủ</a>
        <span>/</span>
        <span class="text-zinc-200">Đơn hàng của tôi</span>
    </nav>

    <h1 class="text-2xl sm:text-3xl font-black text-white tracking-tight mb-8">
        Lịch Sử Mua Hàng
    </h1>

    <?php if (empty($orders)): ?>
        <div class="text-center py-16 bg-zinc-900/40 rounded-3xl border border-zinc-800 p-8">
            <div class="text-5xl mb-4"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M21 8l-9-5-9 5m18 0l-9 5m9-5v8l-9 5m0-8L3 8m9 5v8M3 8v8l9 5"/></svg></div>
            <h2 class="text-lg font-bold text-white mb-2">Bạn chưa có đơn hàng nào</h2>
            <p class="text-xs text-zinc-400 mb-6">Hãy dạo quanh ZenTech để chọn những món gear ưng ý nhé.</p>
            <a href="/products" class="inline-flex px-6 py-2.5 rounded-xl bg-accent-500/20 text-accent-400 border border-accent-500/30 text-xs font-bold hover:bg-accent-500/30 transition">
                Khám phá sản phẩm
            </a>
        </div>
    <?php else: ?>
        <div class="space-y-4">
            <?php foreach ($orders as $order): 
                $statusMap = [
                    'pending'    => ['Chờ xác nhận', 'bg-amber-500/10 text-amber-400 border-amber-500/20'],
                    'confirmed'  => ['Đã xác nhận',  'bg-accent-500/10 text-accent-400 border-accent-500/20'],
                    'processing' => ['Đang xử lý',   'bg-ember-500/10 text-ember-400 border-ember-500/20'],
                    'shipping'   => ['Đang giao',     'bg-accent-500/10 text-accent-400 border-accent-500/20'],
                    'delivered'  => ['Đã giao',       'bg-green-500/10 text-green-400 border-green-500/20'],
                    'cancelled'  => ['Đã hủy',        'bg-red-500/10 text-red-400 border-red-500/20'],
                    'returned'   => ['Đã trả hàng',   'bg-zinc-800 text-zinc-300 border-zinc-700'],
                ];
                [$statusText, $statusClass] = $statusMap[$order['status']] ?? [$order['status'], 'bg-zinc-800 text-zinc-300 border-zinc-700'];
            ?>
                <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 hover:border-zinc-700 transition">
                    <div>
                        <div class="flex items-center gap-3 mb-1.5">
                            <span class="font-mono font-bold text-white text-sm"><?= htmlspecialchars($order['order_code']) ?></span>
                            <span class="text-[11px] font-semibold px-2.5 py-0.5 rounded-full border <?= $statusClass ?>">
                                <?= $statusText ?>
                            </span>
                        </div>
                        <div class="text-xs text-zinc-400">
                            Ngày đặt: <?= date('d/m/Y H:i', strtotime($order['created_at'])) ?> • <?= (int)($order['item_count'] ?? 1) ?> sản phẩm
                        </div>
                    </div>

                    <div class="flex items-center gap-4 w-full sm:w-auto justify-between sm:justify-end pt-3 sm:pt-0 border-t sm:border-t-0 border-zinc-800">
                        <div class="text-right">
                            <div class="text-[11px] text-zinc-500">Tổng tiền</div>
                            <div class="text-base font-bold text-accent-400">
                                <?= number_format($order['total_amount'], 0, ',', '.') ?>₫
                            </div>
                        </div>

                        <a href="/orders/<?= $order['id'] ?>" 
                           class="px-4 py-2 text-xs font-semibold rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-200 hover:text-white border border-zinc-700 transition">
                            Chi tiết &rarr;
                        </a>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>
