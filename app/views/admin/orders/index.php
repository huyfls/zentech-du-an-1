<?php
/**
 * VIEW: Admin Orders Management
 *
 * Variables:
 *   $orders: array
 *   $page, $pages, $total
 *   $status, $search
 *   $counts: array
 */
$statusTabs = [
    ''           => ['Tất cả', $counts['all'] ?? 0],
    'pending'    => ['Chờ xác nhận', $counts['pending'] ?? 0],
    'confirmed'  => ['Đã xác nhận', $counts['confirmed'] ?? 0],
    'shipping'   => ['Đang giao', $counts['shipping'] ?? 0],
    'delivered'  => ['Đã giao', $counts['delivered'] ?? 0],
    'cancelled'  => ['Đã hủy', $counts['cancelled'] ?? 0],
];
?>

<div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
            <h1 class="text-2xl font-black text-white tracking-tight">Quản Lý Đơn Hàng</h1>
            <p class="text-xs text-zinc-400 mt-1">Theo dõi, duyệt và xử lý trạng thái giao hàng cho toàn bộ khách hàng</p>
        </div>
    </div>

    <!-- Status Tabs Strip -->
    <div class="flex items-center gap-2 overflow-x-auto pb-1">
        <?php foreach ($statusTabs as $stKey => [$stLabel, $stCount]): ?>
            <a href="/admin/orders?status=<?= $stKey ?>&q=<?= urlencode($search ?? '') ?>" 
               class="px-4 py-2 rounded-xl text-xs font-semibold whitespace-nowrap transition flex items-center gap-2 <?= $status === $stKey ? 'bg-accent-500/20 text-accent-400 border border-accent-500/30' : 'bg-zinc-900 border border-zinc-800 text-zinc-400 hover:text-white' ?>">
                <span><?= $stLabel ?></span>
                <span class="px-1.5 py-0.2 rounded-full text-[10px] <?= $status === $stKey ? 'bg-accent-400 text-black font-bold' : 'bg-zinc-800 text-zinc-400' ?>">
                    <?= $stCount ?>
                </span>
            </a>
        <?php endforeach; ?>
    </div>

    <!-- Search Bar -->
    <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-4">
        <form method="GET" action="/admin/orders" class="flex items-center gap-3">
            <input type="hidden" name="status" value="<?= htmlspecialchars($status ?? '') ?>">
            <input type="text" name="q" value="<?= htmlspecialchars($search ?? '') ?>" 
                   placeholder="Tìm theo mã đơn hàng, tên khách, số điện thoại..." 
                   class="flex-1 bg-zinc-950 border border-zinc-700 rounded-xl px-4 py-2.5 text-xs text-white outline-none focus:border-accent-400">
            <button type="submit" class="px-5 py-2.5 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition">
                Tìm kiếm
            </button>
            <?php if (!empty($search)): ?>
                <a href="/admin/orders?status=<?= htmlspecialchars($status) ?>" class="text-xs text-zinc-400 hover:text-white">Đặt lại</a>
            <?php endif; ?>
        </form>
    </div>

    <!-- Orders Table -->
    <div class="bg-zinc-900/60 border border-zinc-800 rounded-3xl overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs">
                <thead class="bg-zinc-950/60 text-zinc-400 border-b border-zinc-800">
                    <tr>
                        <th class="py-3.5 px-4 font-semibold">MÃ ĐƠN HÀNG</th>
                        <th class="py-3.5 px-4 font-semibold">KHÁCH HÀNG</th>
                        <th class="py-3.5 px-4 font-semibold">SĐT</th>
                        <th class="py-3.5 px-4 font-semibold">TỔNG TIỀN</th>
                        <th class="py-3.5 px-4 font-semibold">THANH TOÁN</th>
                        <th class="py-3.5 px-4 font-semibold">TRẠNG THÁI</th>
                        <th class="py-3.5 px-4 font-semibold">THỜI GIAN</th>
                        <th class="py-3.5 px-4 font-semibold text-right">THAO TÁC</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-zinc-800/60">
                    <?php if (empty($orders)): ?>
                        <tr>
                            <td colspan="8" class="py-12 text-center text-zinc-500">
                                Không có đơn hàng nào phù hợp.
                            </td>
                        </tr>
                    <?php else: ?>
                        <?php foreach ($orders as $o): 
                            $statusMap = [
                                'pending'    => ['Chờ xác nhận', 'bg-amber-500/10 text-amber-400 border-amber-500/20'],
                                'confirmed'  => ['Đã xác nhận',  'bg-accent-500/10 text-accent-400 border-accent-500/20'],
                                'processing' => ['Đang xử lý',   'bg-ember-500/10 text-ember-400 border-ember-500/20'],
                                'shipping'   => ['Đang giao',     'bg-accent-500/10 text-accent-400 border-accent-500/20'],
                                'delivered'  => ['Đã giao',       'bg-green-500/10 text-green-400 border-green-500/20'],
                                'cancelled'  => ['Đã hủy',        'bg-red-500/10 text-red-400 border-red-500/20'],
                            ];
                            [$stText, $stClass] = $statusMap[$o['status']] ?? [$o['status'], 'bg-zinc-800 text-zinc-300 border-zinc-700'];
                        ?>
                            <tr class="hover:bg-zinc-800/30 transition">
                                <td class="py-3 px-4 font-mono font-bold text-white">
                                    <a href="/admin/orders/detail/<?= $o['id'] ?>" class="hover:text-accent-400 transition">
                                        <?= htmlspecialchars($o['order_code']) ?>
                                    </a>
                                </td>
                                <td class="py-3 px-4 text-zinc-200 font-semibold"><?= htmlspecialchars($o['receiver_name']) ?></td>
                                <td class="py-3 px-4 text-zinc-400 font-mono"><?= htmlspecialchars($o['receiver_phone']) ?></td>
                                <td class="py-3 px-4 font-bold text-accent-400">
                                    <?= number_format($o['total_amount'], 0, ',', '.') ?>₫
                                </td>
                                <td class="py-3 px-4">
                                    <span class="text-[10px] uppercase font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">
                                        <?= strtoupper($o['payment_method']) ?>
                                    </span>
                                </td>
                                <td class="py-3 px-4">
                                    <span class="text-[10px] font-semibold px-2.5 py-0.5 rounded-full border <?= $stClass ?>">
                                        <?= $stText ?>
                                    </span>
                                </td>
                                <td class="py-3 px-4 text-zinc-500 text-[11px]">
                                    <?= date('d/m/Y H:i', strtotime($o['created_at'])) ?>
                                </td>
                                <td class="py-3 px-4 text-right">
                                    <a href="/admin/orders/detail/<?= $o['id'] ?>" class="text-xs text-accent-400 hover:underline font-semibold">
                                        Xem chi tiết &rarr;
                                    </a>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <?php if ($pages > 1): ?>
            <div class="p-4 border-t border-zinc-800 flex items-center justify-between text-xs text-zinc-400">
                <div>Trang <?= $page ?> trên <?= $pages ?></div>
                <div class="flex gap-1.5">
                    <?php for ($i = 1; $i <= $pages; $i++): ?>
                        <a href="/admin/orders?page=<?= $i ?>&status=<?= urlencode($status ?? '') ?>&q=<?= urlencode($search ?? '') ?>" 
                           class="w-7 h-7 rounded-lg flex items-center justify-center font-bold <?= $i === $page ? 'bg-accent-500 text-black' : 'bg-zinc-800 hover:bg-zinc-700 text-on' ?>">
                            <?= $i ?>
                        </a>
                    <?php endfor; ?>
                </div>
            </div>
        <?php endif; ?>
    </div>
</div>
