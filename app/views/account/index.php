<?php
/** VIEW: Tài khoản của tôi. Biến: $user, $addresses */
$in = 'w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-3.5 py-2.5 text-sm text-white outline-none';
$lb = 'block text-xs font-semibold text-zinc-300 mb-1.5';
$card = 'bg-zinc-900/60 border border-zinc-800 rounded-2xl p-6 space-y-4';
?>
<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
    <h1 class="text-3xl font-black text-white">Tài khoản của tôi</h1>
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <form action="/tai-khoan/thong-tin" method="POST" class="<?= $card ?>"><?= Csrf::field() ?>
            <h2 class="text-sm font-bold text-white uppercase tracking-wider">Thông tin cá nhân</h2>
            <div><label class="<?= $lb ?>">Email (không đổi được)</label><input value="<?= e($user['email'] ?? '') ?>" disabled class="<?= $in ?> opacity-60"></div>
            <div><label class="<?= $lb ?>" for="full_name">Họ và tên</label><input id="full_name" name="full_name" required minlength="2" value="<?= e($user['full_name'] ?? '') ?>" class="<?= $in ?>"></div>
            <div><label class="<?= $lb ?>" for="phone">Số điện thoại</label><input id="phone" name="phone" value="<?= e($user['phone'] ?? '') ?>" placeholder="0912345678" class="<?= $in ?>"></div>
            <button class="px-5 py-2.5 rounded-xl bg-accent-500 text-on text-sm font-semibold">Lưu thông tin</button>
        </form>

        <form action="/tai-khoan/mat-khau" method="POST" class="<?= $card ?>"><?= Csrf::field() ?>
            <h2 class="text-sm font-bold text-white uppercase tracking-wider">Đổi mật khẩu</h2>
            <div><label class="<?= $lb ?>" for="cp">Mật khẩu hiện tại</label><input id="cp" type="password" name="current_password" required autocomplete="current-password" class="<?= $in ?>"></div>
            <div><label class="<?= $lb ?>" for="np">Mật khẩu mới (từ 8 ký tự)</label><input id="np" type="password" name="new_password" required minlength="8" autocomplete="new-password" class="<?= $in ?>"></div>
            <div><label class="<?= $lb ?>" for="cf">Nhập lại mật khẩu mới</label><input id="cf" type="password" name="confirm_password" required autocomplete="new-password" class="<?= $in ?>"></div>
            <button class="px-5 py-2.5 rounded-xl bg-accent-500 text-on text-sm font-semibold">Đổi mật khẩu</button>
        </form>
    </div>

    <div class="<?= $card ?>">
        <h2 class="text-sm font-bold text-white uppercase tracking-wider">Sổ địa chỉ</h2>
        <?php if (!$addresses): ?><p class="text-sm text-zinc-500">Bạn chưa lưu địa chỉ nào. Địa chỉ lưu ở đây sẽ được chọn nhanh khi thanh toán.</p><?php endif; ?>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
        <?php foreach ($addresses as $a): ?>
            <div class="border border-zinc-800 rounded-xl p-4 text-sm flex justify-between gap-3">
                <div class="space-y-1">
                    <div class="font-semibold text-white"><?= e($a['receiver_name']) ?> · <?= e($a['phone']) ?> <?= $a['is_default'] ? '<span class="ml-1 text-[11px] text-accent-400">Mặc định</span>' : '' ?></div>
                    <div class="text-zinc-400"><?= e($a['street']) ?>, <?= e($a['ward']) ?>, <?= e($a['district']) ?>, <?= e($a['province']) ?></div>
                </div>
                <form action="/tai-khoan/dia-chi/xoa/<?= (int) $a['id'] ?>" method="POST"><?= Csrf::field() ?><button class="text-xs text-red-500 hover:underline">Xóa</button></form>
            </div>
        <?php endforeach; ?>
        </div>
        <form action="/tai-khoan/dia-chi" method="POST" class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2"><?= Csrf::field() ?>
            <input name="receiver_name" required placeholder="Họ tên người nhận" class="<?= $in ?>">
            <input name="phone" required placeholder="Số điện thoại" class="<?= $in ?>">
            <input name="province" required placeholder="Tỉnh / Thành phố" class="<?= $in ?>">
            <input name="district" required placeholder="Quận / Huyện" class="<?= $in ?>">
            <input name="ward" required placeholder="Phường / Xã" class="<?= $in ?>">
            <input name="street" required placeholder="Số nhà, tên đường" class="<?= $in ?>">
            <label class="flex items-center gap-2 text-sm text-zinc-300"><input type="checkbox" name="is_default" value="1"> Đặt làm mặc định</label>
            <div><button class="px-5 py-2.5 rounded-xl border border-zinc-700 text-sm font-semibold text-white hover:border-accent-400">+ Thêm địa chỉ</button></div>
        </form>
    </div>
</div>
