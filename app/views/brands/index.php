<?php
/** Danh sách thương hiệu: tên, số sản phẩm, khoảng giá. $brands đã sắp theo số sản phẩm giảm dần. */
$fmt = fn($n) => number_format((float) $n, 0, ',', '.') . '₫';
?>
<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16">
    <h1 class="text-4xl sm:text-5xl font-bold text-zinc-100">Thương hiệu</h1>
    <p class="mt-3 text-lg text-zinc-400"><?= (int) $totalBrands ?> hãng, <?= (int) $totalProducts ?> sản phẩm.</p>

    <ul class="mt-10 grid grid-cols-1 md:grid-cols-2 md:gap-x-12">
        <?php foreach ($brands as $b): ?>
            <li class="border-t border-zinc-800">
                <a href="/san-pham?brand[]=<?= urlencode($b['slug']) ?>" class="group flex items-baseline justify-between gap-4 py-4">
                    <span class="text-lg font-semibold text-zinc-100 group-hover:text-accent-400 transition-colors"><?= e($b['name']) ?></span>
                    <span class="text-sm text-zinc-400 tabular-nums text-right">
                        <?= (int) $b['product_count'] ?> sản phẩm<?php if ($b['min_price']): ?>, từ <?= $fmt($b['min_price']) ?><?php endif; ?>
                    </span>
                </a>
            </li>
        <?php endforeach; ?>
    </ul>
</div>
