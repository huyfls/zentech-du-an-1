<?php
/** VIEW: Admin - Mã giảm giá. Biến: $coupons */
$in = 'w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-3 py-2 text-xs text-white outline-none';
?>
<div class="space-y-6">
    <div>
        <h1 class="text-2xl font-black text-white tracking-tight">Mã Giảm Giá</h1>
        <p class="text-xs text-zinc-400 mt-1">Tạo mã, xem số lượt đã dùng và bật/tắt mã</p>
    </div>

    <form action="/admin/coupons/create" method="POST" class="bg-zinc-900 border border-zinc-800 rounded-2xl p-5 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <?= Csrf::field() ?>
        <div><label class="block text-[11px] font-semibold text-zinc-300 mb-1">Mã *</label><input name="code" required maxlength="50" placeholder="VD: SALE20" class="<?= $in ?> uppercase"></div>
        <div><label class="block text-[11px] font-semibold text-zinc-300 mb-1">Loại *</label>
            <select name="discount_type" class="<?= $in ?>"><option value="percent">Phần trăm (%)</option><option value="fixed">Số tiền cố định (₫)</option></select></div>
        <div><label class="block text-[11px] font-semibold text-zinc-300 mb-1">Giá trị giảm *</label><input name="discount_value" type="number" step="1" min="1" required class="<?= $in ?>"></div>
        <div><label class="block text-[11px] font-semibold text-zinc-300 mb-1">Đơn tối thiểu (₫)</label><input name="min_order_value" type="number" min="0" value="0" class="<?= $in ?>"></div>
        <div><label class="block text-[11px] font-semibold text-zinc-300 mb-1">Số lượt tối đa (để trống = không giới hạn)</label><input name="max_uses" type="number" min="1" class="<?= $in ?>"></div>
        <div><label class="block text-[11px] font-semibold text-zinc-300 mb-1">Bắt đầu</label><input name="starts_at" type="datetime-local" class="<?= $in ?>"></div>
        <div><label class="block text-[11px] font-semibold text-zinc-300 mb-1">Hết hạn</label><input name="expires_at" type="datetime-local" class="<?= $in ?>"></div>
        <div><label class="block text-[11px] font-semibold text-zinc-300 mb-1">Mô tả</label><input name="description" maxlength="255" class="<?= $in ?>"></div>
        <div class="sm:col-span-2 lg:col-span-4"><button class="px-5 py-2.5 rounded-xl bg-accent-500 text-white text-xs font-bold">+ Tạo mã</button></div>
    </form>

    <div class="bg-zinc-900 border border-zinc-800 rounded-2xl overflow-x-auto">
        <table class="w-full text-xs">
            <thead><tr class="text-left text-[10px] uppercase text-zinc-500">
                <th class="px-5 py-3">Mã</th><th class="px-3">Giảm</th><th class="px-3">Đơn tối thiểu</th><th class="px-3">Đã dùng</th><th class="px-3">Hiệu lực</th><th class="px-3">Trạng thái</th><th class="px-5"></th>
            </tr></thead>
            <tbody>
            <?php foreach ($coupons as $c): ?>
                <tr class="border-t border-zinc-800">
                    <td class="px-5 py-3"><div class="font-bold text-white"><?= e($c['code']) ?></div><div class="text-zinc-500"><?= e($c['description']) ?></div></td>
                    <td class="px-3"><?= $c['discount_type'] === 'percent' ? (float) $c['discount_value'] . '%' : number_format($c['discount_value'], 0, ',', '.') . '₫' ?></td>
                    <td class="px-3"><?= number_format($c['min_order_value'], 0, ',', '.') ?>₫</td>
                    <td class="px-3"><?= (int) $c['used_count'] ?><?= $c['max_uses'] !== null ? ' / ' . (int) $c['max_uses'] : '' ?></td>
                    <td class="px-3 text-zinc-400"><?= $c['starts_at'] ? date('d/m/Y', strtotime($c['starts_at'])) : '—' ?> → <?= $c['expires_at'] ? date('d/m/Y', strtotime($c['expires_at'])) : '—' ?></td>
                    <td class="px-3"><?= $c['is_active'] ? '<span class="text-green-500 font-semibold">Đang bật</span>' : '<span class="text-zinc-500">Đã tắt</span>' ?></td>
                    <td class="px-5 text-right"><form action="/admin/coupons/toggle/<?= (int) $c['id'] ?>" method="POST"><?= Csrf::field() ?><button class="text-accent-400 font-semibold hover:underline"><?= $c['is_active'] ? 'Tắt' : 'Bật' ?></button></form></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>
