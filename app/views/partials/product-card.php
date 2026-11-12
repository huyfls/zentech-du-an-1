<?php
/**
 * PARTIAL: Product Card
 * Hiển thị card sản phẩm phong cách Cyber-Dark Mode
 *
 * Variables:
 *   $product: array (id, name, slug, thumbnail, brand_name, min_price, original_price, max_discount_pct, avg_rating)
 */
$minPrice = $product['min_price'] ?? ($product['base_price'] ?? 0);
$origPrice = $product['original_price'] ?? null;
$discountPct = $product['max_discount_pct'] ?? 0;
$rating = $product['avg_rating'] ?? 5.0;
$thumbnail = !empty($product['thumbnail']) ? $product['thumbnail'] : (!empty($product['thumbnail_url']) ? $product['thumbnail_url'] : '');
?>

<article class="group relative flex flex-col">
    <a href="/san-pham/<?= e($product['slug'] ?? '') ?>" class="stage relative block aspect-square" tabindex="-1" aria-hidden="true">
        <img src="<?= e($thumbnail) ?>" alt="" loading="lazy"
             class="w-full h-full object-contain p-6 transition-transform duration-700 ease-out group-hover:scale-[1.05]">
        <?php if (!empty($discountPct) && $discountPct > 0): ?>
            <span class="absolute top-3 left-3 text-xs font-semibold px-2.5 py-1 rounded-full bg-red-500 text-on">Giảm <?= (int) $discountPct ?>%</span>
        <?php endif; ?>
    </a>

    <div class="flex flex-1 flex-col pt-4 px-1">
        <p class="text-xs font-medium text-zinc-400"><?= e($product['brand_name'] ?? 'Gaming Gear') ?></p>
        <h3 class="mt-1 text-[15px] font-semibold text-zinc-100 leading-snug line-clamp-2">
            <a href="/san-pham/<?= e($product['slug'] ?? '') ?>" class="after:absolute after:inset-0"><?= e($product['name'] ?? '') ?></a>
        </h3>
        <div class="mt-auto pt-3 flex items-baseline gap-2 flex-wrap">
            <span class="text-[15px] font-semibold text-zinc-100 tabular-nums">Từ <?= number_format($minPrice, 0, ',', '.') ?>₫</span>
            <?php if (!empty($origPrice) && $origPrice > $minPrice): ?>
                <span class="text-sm text-zinc-500 line-through tabular-nums"><?= number_format($origPrice, 0, ',', '.') ?>₫</span>
            <?php endif; ?>
        </div>
        <?php if (!empty($product['review_count'])): ?>
        <p class="mt-1 text-xs text-zinc-400"><span class="text-ember-400">★</span> <?= number_format($rating, 1) ?> · <?= (int) $product['review_count'] ?> đánh giá</p>
        <?php endif; ?>
    </div>
</article>
