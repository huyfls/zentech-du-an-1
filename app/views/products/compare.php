<?php
/** VIEW: So sánh sản phẩm. Biến: $products (2-3 sp), $groups [nhóm][nhãn][chỉ số sp] = giá trị */
$n = count($products);
$vnd = fn($v) => number_format((float) $v, 0, ',', '.') . '₫';
$without = fn(int $id) => '/so-sanh?ids=' . implode(',', array_map(fn($p) => (int) $p['id'], array_filter($products, fn($p) => (int) $p['id'] !== $id)));
$rows = [];   // hàng chung: [nhãn, [giá trị từng sản phẩm]]
$rows[] = ['Giá', array_map(fn($p) => $vnd($p['min_price']) . (!empty($p['max_discount_pct']) ? '  (giảm ' . (int) $p['max_discount_pct'] . '%)' : ''), $products)];
$rows[] = ['Thương hiệu', array_column($products, 'brand_name')];
$rows[] = ['Loại', array_column($products, 'category_name')];
$rows[] = ['Đánh giá', array_map(fn($p) => $p['review_count'] > 0 ? number_format($p['avg_rating'], 1) . ' / 5 (' . (int) $p['review_count'] . ' đánh giá)' : 'Chưa có đánh giá', $products)];
$rows[] = ['Màu sắc', array_map(fn($p) => $p['colors'] ?: '–', $products)];
$rows[] = ['Tình trạng', array_map(fn($p) => (int) $p['total_stock'] > 0 ? 'Còn hàng (' . (int) $p['total_stock'] . ')' : 'Hết hàng', $products)];
$diff = fn(array $vals) => count(array_unique(array_map(fn($v) => mb_strtolower(trim((string) $v)), $vals))) > 1;
?>
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <h1 class="t-section text-zinc-100">So sánh sản phẩm.</h1>

    <?php if ($n < 2): ?>
        <div class="mt-10 rounded-3xl bg-zinc-900 px-6 py-16 text-center">
            <p class="text-lg font-semibold text-zinc-100"><?= $n === 0 ? 'Chưa có sản phẩm nào để so sánh' : 'Cần ít nhất 2 sản phẩm để so sánh' ?></p>
            <p class="mt-1 text-sm text-zinc-400">Bấm nút "So sánh" trên thẻ sản phẩm để chọn từ 2 đến 3 sản phẩm.</p>
            <a href="/san-pham" class="btn-primary mt-6 inline-block">Chọn sản phẩm</a>
        </div>
    <?php else: ?>
    <div class="mt-2 flex flex-wrap items-center justify-between gap-3">
        <p class="text-sm text-zinc-400"><?= $n ?> sản phẩm. Các dòng khác nhau được tô nền.</p>
        <label class="flex items-center gap-2 text-sm text-zinc-300 cursor-pointer"><input type="checkbox" id="only-diff"> Chỉ hiện điểm khác biệt</label>
    </div>

    <div class="mt-6 overflow-x-auto rounded-3xl border border-zinc-800">
        <table class="w-full min-w-[720px] text-sm border-collapse" id="cmp-table">
            <caption class="sr-only">Bảng so sánh <?= $n ?> sản phẩm</caption>
            <thead>
                <tr>
                    <th scope="col" class="sticky left-0 z-10 bg-zinc-950 w-24 sm:w-40 p-3 sm:p-4 text-left align-bottom text-zinc-400 font-medium">Sản phẩm</th>
                    <?php foreach ($products as $p): ?>
                    <th scope="col" class="p-4 align-top text-left font-normal" style="width:<?= floor(80 / $n) ?>%">
                        <a href="/san-pham/<?= e($p['slug']) ?>" class="block">
                            <img src="<?= e($p['thumbnail']) ?>" alt="" class="w-full max-w-[200px] aspect-square object-contain rounded-2xl bg-zinc-900 p-3">
                            <span class="mt-3 block font-semibold text-zinc-100 leading-snug"><?= e($p['name']) ?></span>
                        </a>
                        <div class="mt-3 flex flex-wrap gap-2">
                            <button type="button" data-quick-add="<?= (int) $p['id'] ?>" class="btn-primary !py-2 !px-4 text-sm">Thêm vào giỏ</button>
                            <a href="<?= e($without((int) $p['id'])) ?>" class="px-3 py-2 text-sm text-zinc-400 hover:text-zinc-100" aria-label="Bỏ <?= e($p['name']) ?> khỏi so sánh">Bỏ</a>
                        </div>
                    </th>
                    <?php endforeach; ?>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($rows as [$label, $vals]): $d = $diff($vals); ?>
                <tr class="border-t border-zinc-800 <?= $d ? 'cmp-diff bg-accent-500/5' : '' ?>" data-diff="<?= $d ? 1 : 0 ?>">
                    <th scope="row" class="sticky left-0 z-10 bg-zinc-950 p-4 text-left font-medium text-zinc-400"><?= e($label) ?></th>
                    <?php foreach ($vals as $v): ?><td class="p-4 text-zinc-100"><?= e($v) ?></td><?php endforeach; ?>
                </tr>
                <?php endforeach; ?>
                <?php foreach ($groups as $g => $labels): ?>
                <tr class="border-t border-zinc-800"><th scope="colgroup" colspan="<?= $n + 1 ?>" class="sticky left-0 bg-zinc-900 px-4 py-2.5 text-left text-xs font-semibold uppercase tracking-wide text-zinc-400"><?= e($g) ?></th></tr>
                    <?php foreach ($labels as $label => $byIdx):
                        $vals = []; for ($i = 0; $i < $n; $i++) $vals[] = $byIdx[$i] ?? '–';
                        $d = $diff($vals); ?>
                    <tr class="border-t border-zinc-800 <?= $d ? 'cmp-diff bg-accent-500/5' : '' ?>" data-diff="<?= $d ? 1 : 0 ?>">
                        <th scope="row" class="sticky left-0 z-10 bg-zinc-950 p-4 text-left font-medium text-zinc-400"><?= e($label) ?></th>
                        <?php foreach ($vals as $v): ?><td class="p-4 text-zinc-100"><?= e($v) ?></td><?php endforeach; ?>
                    </tr>
                    <?php endforeach; ?>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
    <?php if ($n < 3): ?><p class="mt-4 text-sm text-zinc-400">Có thể thêm 1 sản phẩm nữa. <a class="text-accent-400 hover:underline" href="/san-pham">Chọn thêm</a></p><?php endif; ?>
    <script>
    document.getElementById('only-diff').addEventListener('change', function () {
        document.querySelectorAll('#cmp-table tbody tr[data-diff="0"]').forEach(r => r.hidden = this.checked);
    });
    </script>
    <?php endif; ?>
</div>
