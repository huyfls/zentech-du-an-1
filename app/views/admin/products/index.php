<?php
/**
 * VIEW: Admin Product List
 */
?>

<div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
            <h1 class="text-2xl font-black text-white tracking-tight">Quản Lý Sản Phẩm</h1>
            <p class="text-xs text-zinc-400 mt-1">Danh sách sản phẩm và các biến thể Gaming Gear trong hệ thống</p>
        </div>

        <a href="/admin/products/create" 
           class="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl font-bold text-xs bg-accent-500 hover:bg-accent-600 text-on  transition">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
            </svg>
            <span>Thêm sản phẩm mới</span>
        </a>
    </div>

    <!-- Search Bar -->
    <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-4">
        <form method="GET" action="/admin/products" class="flex items-center gap-3">
            <input type="text" name="q" value="<?= htmlspecialchars($search ?? '') ?>" 
                   placeholder="Tìm theo tên sản phẩm, mã SKU, thương hiệu..." 
                   class="flex-1 bg-zinc-950 border border-zinc-700 rounded-xl px-4 py-2.5 text-xs text-white outline-none focus:border-accent-400">
            <button type="submit" class="px-5 py-2.5 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition">
                Tìm kiếm
            </button>
            <?php if (!empty($search)): ?>
                <a href="/admin/products" class="text-xs text-zinc-400 hover:text-white">Đặt lại</a>
            <?php endif; ?>
        </form>
    </div>

    <!-- Products Table -->
    <div class="bg-zinc-900/60 border border-zinc-800 rounded-3xl overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs">
                <thead class="bg-zinc-950/60 text-zinc-400 border-b border-zinc-800">
                    <tr>
                        <th class="py-3.5 px-4 font-semibold">ẢNH</th>
                        <th class="py-3.5 px-4 font-semibold">TÊN SẢN PHẨM</th>
                        <th class="py-3.5 px-4 font-semibold">DANH MỤC</th>
                        <th class="py-3.5 px-4 font-semibold">HÃNG</th>
                        <th class="py-3.5 px-4 font-semibold">SỐ BIẾN THỂ</th>
                        <th class="py-3.5 px-4 font-semibold">KHOẢNG GIÁ</th>
                        <th class="py-3.5 px-4 font-semibold">TỔN KHO</th>
                        <th class="py-3.5 px-4 font-semibold">TRẠNG THÁI</th>
                        <th class="py-3.5 px-4 font-semibold text-right">THAO TÁC</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-zinc-800/60">
                    <?php if (empty($products)): ?>
                        <tr>
                            <td colspan="9" class="py-12 text-center text-zinc-500">
                                Không tìm thấy sản phẩm nào.
                            </td>
                        </tr>
                    <?php else: ?>
                        <?php foreach ($products as $p): ?>
                            <tr class="hover:bg-zinc-800/30 transition">
                                <td class="py-3 px-4">
                                    <div class="w-12 h-12 rounded-lg bg-zinc-950 border border-zinc-800 p-1 flex items-center justify-center">
                                        <img src="<?= htmlspecialchars($p['thumbnail_url'] ?? 'https://placehold.co/100x100/18181b/22d3ee') ?>" 
                                             alt="" class="max-w-full max-h-full object-contain">
                                    </div>
                                </td>
                                <td class="py-3 px-4 max-w-xs">
                                    <div class="font-bold text-zinc-100 hover:text-accent-400 transition truncate">
                                        <a href="/san-pham/<?= htmlspecialchars($p['slug']) ?>" target="_blank">
                                            <?= htmlspecialchars($p['name']) ?>
                                        </a>
                                    </div>
                                    <div class="text-[11px] text-zinc-500 font-mono"><?= htmlspecialchars($p['sku']) ?></div>
                                </td>
                                <td class="py-3 px-4 text-zinc-300"><?= htmlspecialchars($p['category_name']) ?></td>
                                <td class="py-3 px-4">
                                    <span class="px-2 py-0.5 rounded-full bg-accent-500/10 text-accent-400 text-[10px] font-bold border border-accent-500/20">
                                        <?= htmlspecialchars($p['brand_name']) ?>
                                    </span>
                                </td>
                                <td class="py-3 px-4 font-mono font-semibold text-ember-400">
                                    <?= (int)$p['variant_count'] ?> SKU
                                </td>
                                <td class="py-3 px-4 font-bold text-accent-400">
                                    <?= number_format($p['min_price'] ?? 0, 0, ',', '.') ?>₫
                                </td>
                                <td class="py-3 px-4">
                                    <span class="font-bold <?= ($p['total_stock'] ?? 0) <= 5 ? 'text-red-400' : 'text-zinc-200' ?>">
                                        <?= (int)($p['total_stock'] ?? 0) ?>
                                    </span>
                                </td>
                                <td class="py-3 px-4">
                                    <?php if ($p['is_active']): ?>
                                        <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-green-500/10 text-green-400 border border-green-500/20">Đang bán</span>
                                    <?php else: ?>
                                        <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-zinc-800 text-zinc-500 border border-zinc-700">Ngừng bán</span>
                                    <?php endif; ?>
                                </td>
                                <td class="py-3 px-4 text-right space-x-2 whitespace-nowrap">
                                    <a href="/admin/products/edit/<?= $p['id'] ?>" class="text-xs text-accent-400 hover:underline font-semibold">
                                        Sửa
                                    </a>
                                    <form action="/admin/products/delete/<?= $p['id'] ?>" method="POST" class="inline" onsubmit="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?')">
<?= Csrf::field() ?>
                                        <button type="submit" class="text-xs text-red-400 hover:underline font-semibold">
                                            Xóa
                                        </button>
                                    </form>
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
                        <a href="/admin/products?page=<?= $i ?>&q=<?= urlencode($search ?? '') ?>" 
                           class="w-7 h-7 rounded-lg flex items-center justify-center font-bold <?= $i === $page ? 'bg-accent-500 text-black' : 'bg-zinc-800 hover:bg-zinc-700 text-on' ?>">
                            <?= $i ?>
                        </a>
                    <?php endfor; ?>
                </div>
            </div>
        <?php endif; ?>
    </div>
</div>
