<?php
/**
 * VIEW: Đăng ký tài khoản ZenTech
 */
$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);
?>
<!DOCTYPE html>
<html lang="vi" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản — ZenTech</title>
    <link rel="stylesheet" href="/assets/css/fonts.css">
    <script src="/assets/vendor/tailwind-3.4.0.js"></script>
    <script src="/assets/js/tailwind-theme.js"></script>
    <link rel="stylesheet" href="/assets/css/custom.css">
    
</head>
<body class="min-h-full flex items-center justify-center p-4">

    <div class="w-full max-w-md">
        <!-- Logo -->
        <div class="text-center mb-8">
            <a href="/" class="inline-flex items-center gap-2 group">
                <img src="/assets/img/logo-mark.svg" alt="" class="w-8 h-8  transition" width="28" height="28">
                <span class="text-2xl font-black text-accent-400">
                    ZenTech
                </span>
            </a>
            <p class="text-xs text-zinc-400 mt-2">Tạo tài khoản để lưu giỏ hàng và theo dõi đơn hàng</p>
        </div>

        <div class="bg-zinc-900/70 backdrop-blur-xl border border-zinc-800 rounded-3xl p-8 ">
            
            <?php if (!empty($flash['errors'])): ?>
                <div class="mb-5 p-3.5 rounded-xl bg-red-500/10 border border-red-500/30 text-xs text-red-400 space-y-1">
                    <ul class="list-disc pl-5">
                        <?php foreach ($flash['errors'] as $err): ?>
                            <li><?= htmlspecialchars($err) ?></li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            <?php endif; ?>

            <form action="/auth/register" method="POST" class="space-y-3.5">
<?= Csrf::field() ?>
                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1">Họ và tên *</label>
                    <input type="text" name="full_name" required autocomplete="name" placeholder="Nguyễn Văn A" value="<?= e($flash['old']['full_name'] ?? '') ?>"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1">Email *</label>
                    <input type="email" name="email" required autocomplete="email" placeholder="you@domain.com" value="<?= e($flash['old']['email'] ?? '') ?>"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1">Số điện thoại</label>
                    <input type="tel" name="phone" autocomplete="tel" inputmode="numeric" pattern="0[0-9]{9}" title="10 chữ số, bắt đầu bằng 0" placeholder="0912345678" value="<?= e($flash['old']['phone'] ?? '') ?>"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1">Mật khẩu *</label>
                    <input type="password" name="password" required minlength="8" autocomplete="new-password" placeholder="Tối thiểu 8 ký tự"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1">Xác nhận mật khẩu *</label>
                    <input type="password" name="confirm_password" required minlength="8" autocomplete="new-password" placeholder="Nhập lại mật khẩu"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                </div>

                <div class="pt-2">
                    <button type="submit" 
                            class="w-full py-3.5 rounded-xl font-bold text-xs bg-accent-500 hover:bg-accent-600 text-on  transition-all duration-300 ">
                        Đăng ký tài khoản
                    </button>
                </div>
            </form>

            <div class="mt-6 pt-5 border-t border-zinc-800 text-center text-xs text-zinc-400">
                Đã có tài khoản? 
                <a href="/auth/login" class="font-bold text-accent-400 hover:underline">Đăng nhập ngay</a>
            </div>
        </div>
    </div>

<script src="/assets/js/form-loading.js"></script>
</body>
</html>
