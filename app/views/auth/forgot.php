<?php
/**
 * VIEW: Đăng nhập ZenTech (Standalone Glassmorphism Card)
 */
$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);
?>
<!DOCTYPE html>
<html lang="vi" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — ZenTech</title>
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
            <p class="text-xs text-zinc-400 mt-2">Quên mật khẩu</p>
        </div>

        <!-- Glassmorphism Card -->
        <div class="bg-zinc-900/70 backdrop-blur-xl border border-zinc-800 rounded-3xl p-8 ">
            
            <?php if (!empty($flash['error'])): ?>
                <div class="mb-5 p-3.5 rounded-xl bg-red-500/10 border border-red-500/30 text-xs text-red-400">
                    <?= htmlspecialchars($flash['error']) ?>
                </div>
            <?php endif; ?>

            <?php if (!empty($flash['success'])): ?>
                <div class="mb-5 p-3.5 rounded-xl bg-green-500/10 border border-green-500/30 text-xs text-green-400">
                    <?= htmlspecialchars($flash['success']) ?>
                </div>
            <?php endif; ?>

            <form action="/quen-mat-khau" method="POST" class="space-y-4">
<?= Csrf::field() ?>
                <p class="text-xs text-zinc-400">Nhập email đã đăng ký, chúng tôi sẽ tạo liên kết đặt lại mật khẩu (hiệu lực 30 phút).</p>
                <div><label class="block text-xs font-semibold text-zinc-300 mb-1.5" for="email">Địa chỉ Email</label>
                <input type="email" id="email" name="email" required autocomplete="email" class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-4 py-3 text-xs text-white outline-none"></div>
                <button class="w-full py-3 rounded-xl bg-accent-500 text-on text-sm font-bold">Gửi liên kết</button>
                <p class="text-center text-xs text-zinc-400"><a href="/dang-nhap" class="font-bold text-accent-400 hover:underline">Quay lại đăng nhập</a></p>
            </form>
        </div>
    </div>
</body>
</html>
