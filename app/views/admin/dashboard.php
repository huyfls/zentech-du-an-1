<?php
/**
 * VIEW: Admin Dashboard Index
 */
?>

<div class="space-y-8">
    <!-- Page Header -->
    <div>
        <h1 class="text-2xl font-black text-white tracking-tight">Tổng Quan Hệ Thống</h1>
        <p class="text-xs text-zinc-400 mt-1">Số liệu từ <?= date('d/m/Y', strtotime($filter['from'])) ?> đến <?= date('d/m/Y', strtotime($filter['to'])) ?> (theo ngày đặt đơn)</p>
    </div>

    <!-- Bộ lọc -->
    <form method="GET" action="/admin" class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-4 flex flex-wrap items-end gap-3 text-xs">
        <label><span class="block mb-1 text-zinc-400 font-semibold">Khoảng thời gian</span>
            <select name="range" class="bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-white" onchange="document.getElementById('dash-custom').classList.toggle('hidden', this.value !== 'custom'); document.getElementById('dash-custom').classList.toggle('flex', this.value === 'custom'); if (this.value !== 'custom') this.form.submit()">
                <?php foreach (AdminDashboardController::RANGES as $k => $l): ?><option value="<?= $k ?>" <?= $filter['range'] === $k ? 'selected' : '' ?>><?= $l ?></option><?php endforeach; ?>
            </select></label>
        <div id="dash-custom" class="items-end gap-3 <?= $filter['range'] === 'custom' ? 'flex' : 'hidden' ?>">
            <label><span class="block mb-1 text-zinc-400 font-semibold">Từ ngày</span><input type="date" name="from" value="<?= e($filter['from']) ?>" class="bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-white"></label>
            <label><span class="block mb-1 text-zinc-400 font-semibold">Đến ngày</span><input type="date" name="to" value="<?= e($filter['to']) ?>" class="bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-white"></label>
        </div>
        <label><span class="block mb-1 text-zinc-400 font-semibold">Trạng thái đơn (danh sách bên dưới)</span>
            <select name="status" class="bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-white" onchange="this.form.submit()">
                <option value="">Tất cả trạng thái</option>
                <?php foreach (OrderModel::LABELS as $k => $l): ?><option value="<?= $k ?>" <?= $filter['status'] === $k ? 'selected' : '' ?>><?= e($l) ?></option><?php endforeach; ?>
            </select></label>
        <button class="px-4 py-2 rounded-xl bg-accent-500 text-white font-bold">Lọc</button>
        <?php if ($filter['range'] !== '30d' || $filter['status']): ?><a href="/admin" class="py-2 text-zinc-400 hover:text-white">Đặt lại</a><?php endif; ?>
    </form>

    <!-- Metric Stat Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <!-- Doanh thu -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 hover:border-accent-500/30 transition">
            <div class="flex items-center justify-between mb-3">
                <span class="text-xs font-semibold text-zinc-400 uppercase tracking-wider">Doanh thu</span>
                <span class="w-8 h-8 rounded-xl bg-accent-500/10 text-accent-400 flex items-center justify-center text-sm"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 7h20v10H2zM12 14a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/></svg></span>
            </div>
            <div class="text-2xl font-black text-white">
                <?= number_format($stats['total_revenue'] ?? 0, 0, ',', '.') ?>₫
            </div>
            <div class="text-[11px] text-green-400 mt-1">Đơn khách đã nhận / hoàn thành</div>
        </div>

        <!-- Tổng đơn hàng -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 hover:border-ember-500/30 transition">
            <div class="flex items-center justify-between mb-3">
                <span class="text-xs font-semibold text-zinc-400 uppercase tracking-wider">Tổng Đơn Hàng</span>
                <span class="w-8 h-8 rounded-xl bg-ember-500/10 text-ember-400 flex items-center justify-center text-sm"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M21 8l-9-5-9 5m18 0l-9 5m9-5v8l-9 5m0-8L3 8m9 5v8M3 8v8l9 5"/></svg></span>
            </div>
            <div class="text-2xl font-black text-white">
                <?= number_format($stats['total_orders'] ?? 0) ?>
            </div>
            <div class="text-[11px] text-zinc-400 mt-1">Đã hủy: <?= $stats['cancelled'] ?> · Trả hàng: <?= $stats['returns'] ?></div>
        </div>

        <!-- Đơn chờ duyệt -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 hover:border-amber-500/30 transition">
            <div class="flex items-center justify-between mb-3">
                <span class="text-xs font-semibold text-zinc-400 uppercase tracking-wider">Đơn Chờ Xử Lý</span>
                <span class="w-8 h-8 rounded-xl bg-amber-500/10 text-amber-400 flex items-center justify-center text-sm"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></span>
            </div>
            <div class="text-2xl font-black text-amber-400">
                <?= number_format($stats['pending_orders'] ?? 0) ?>
            </div>
            <div class="text-[11px] text-amber-400/80 mt-1">Cần xác nhận ngay</div>
        </div>

        <!-- Sản phẩm đang bán -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 hover:border-accent-500/30 transition">
            <div class="flex items-center justify-between mb-3">
                <span class="text-xs font-semibold text-zinc-400 uppercase tracking-wider">Sản Phẩm Đang Bán</span>
                <span class="w-8 h-8 rounded-xl bg-accent-500/10 text-accent-400 flex items-center justify-center text-sm"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 12h4m-2-2v4m7-1h.01M18 11h.01M5 7h14a3 3 0 0 1 3 3v4a3 3 0 0 1-5 2l-1-1H8l-1 1a3 3 0 0 1-5-2v-4a3 3 0 0 1 3-3z"/></svg></span>
            </div>
            <div class="text-2xl font-black text-white">
                <?= number_format($stats['total_products'] ?? 0) ?>
            </div>
            <div class="text-[11px] text-accent-400 mt-1">Khách mới trong kỳ: <?= $stats['new_customers'] ?></div>
        </div>
    </div>

    <!-- 2 Column Section: Đơn hàng mới + Cảnh báo tồn kho -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        
        <!-- Đơn hàng gần đây (8 cols) -->
        <div class="lg:col-span-8 bg-zinc-900/60 border border-zinc-800 rounded-3xl p-6 space-y-4">
            <div class="flex items-center justify-between">
                <h2 class="text-base font-bold text-white flex items-center gap-2">
                    <span class="w-2 h-2 rounded-full bg-accent-400"></span>
                    Đơn hàng trong kỳ<?= $filter['status'] ? ' — ' . e(OrderModel::LABELS[$filter['status']]) : '' ?>
                </h2>
                <a href="/admin/orders" class="text-xs text-accent-400 hover:underline">Xem tất cả &rarr;</a>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left text-xs">
                    <thead>
                        <tr class="text-zinc-500 border-b border-zinc-800 pb-2">
                            <th class="py-2.5 font-semibold">Mã đơn</th>
                            <th class="py-2.5 font-semibold">Khách hàng</th>
                            <th class="py-2.5 font-semibold">Tổng tiền</th>
                            <th class="py-2.5 font-semibold">Trạng thái</th>
                            <th class="py-2.5 font-semibold text-right">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-zinc-800/60">
                        <?php foreach ($recentOrders as $ro): 
                            [$stText, $stClass] = OrderModel::badge($ro['status']);
                        ?>
                            <tr class="hover:bg-zinc-800/30 transition">
                                <td class="py-3 font-mono font-bold text-white"><?= htmlspecialchars($ro['order_code']) ?></td>
                                <td class="py-3 text-zinc-300"><?= htmlspecialchars($ro['receiver_name']) ?></td>
                                <td class="py-3 font-bold text-accent-400"><?= number_format($ro['total_amount'], 0, ',', '.') ?>₫</td>
                                <td class="py-3">
                                    <span class="text-[11px] font-semibold px-2 py-0.5 rounded-full border <?= $stClass ?>">
                                        <?= $stText ?>
                                    </span>
                                </td>
                                <td class="py-3 text-right">
                                    <a href="/admin/orders/detail/<?= $ro['id'] ?>" class="text-xs text-zinc-400 hover:text-accent-400 font-semibold">
                                        Xem
                                    </a>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                        <?php if (!$recentOrders): ?><tr><td colspan="5" class="py-8 text-center text-zinc-500">Không có đơn hàng nào trong kỳ này.</td></tr><?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Cảnh báo tồn kho (4 cols) -->
        <div class="lg:col-span-4 bg-zinc-900/60 border border-zinc-800 rounded-3xl p-6 space-y-4">
            <h2 class="text-base font-bold text-white flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-red-400"></span>
                Cảnh Báo Tồn Kho Sắp Hết
            </h2>

            <div class="space-y-3">
                <?php if (empty($lowStockProducts)): ?>
                    <p class="text-xs text-zinc-500 py-4">Tất cả sản phẩm đều đủ số lượng tồn kho.</p>
                <?php else: ?>
                    <?php foreach ($lowStockProducts as $lsp): ?>
                        <div class="p-3 rounded-xl bg-zinc-950/60 border border-zinc-800/80 flex items-center justify-between">
                            <div class="min-w-0 pr-2">
                                <div class="text-xs font-semibold text-zinc-200 truncate"><?= htmlspecialchars($lsp['product_name']) ?></div>
                                <div class="text-[11px] text-zinc-500 font-mono"><?= htmlspecialchars($lsp['sku']) ?></div>
                            </div>
                            <span class="px-2 py-1 rounded-lg text-xs font-bold <?= $lsp['stock_qty'] == 0 ? 'bg-red-500/20 text-red-400 border border-red-500/30' : 'bg-amber-500/20 text-amber-400 border border-amber-500/30' ?>">
                                Còn <?= $lsp['stock_qty'] ?>
                            </span>
                        </div>
                    <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </div>

    </div>
</div>
