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
                <svg class="w-8 h-8 text-accent-400 group-hover:text-ember-400 transition" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M13 2L4.5 13.5H11L10 22l9-12h-6.5L13 2Z"/>
                </svg>
                <span class="text-2xl font-black text-accent-400">
                    ZenTech
                </span>
            </a>
            <p class="text-xs text-zinc-400 mt-2">Đăng nhập tài khoản Gaming & Setup</p>
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

            <form action="/auth/login" method="POST" class="space-y-4">
<?= Csrf::field() ?>
                <input type="hidden" name="redirect" value="<?= htmlspecialchars($redirect ?? '') ?>">

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Địa chỉ Email</label>
                    <input type="email" autocomplete="email"
                           name="email" 
                           required 
                           placeholder="admin@zentech.vn hoặc user@..."
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-4 py-3 text-xs text-white outline-none">
                </div>

                <div>
                    <div class="flex justify-between items-center mb-1.5">
                        <label class="text-xs font-semibold text-zinc-300">Mật khẩu</label>
                    </div>
                    <div class="relative">
                        <input type="password" 
                               id="password-input"
                               name="password" 
                               required 
                               placeholder="••••••••"
                               class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-4 py-3 text-xs text-white outline-none pr-10">
                        <button type="button" 
                                onclick="togglePass()"
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-white text-xs">
                            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12zm10 3a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/></svg>
                        </button>
                    </div>
                </div>

                <div class="pt-2">
                    <button type="submit" 
                            class="w-full py-3.5 rounded-xl font-bold text-xs bg-accent-500 hover:bg-accent-600 text-on  transition-all duration-300 ">
                        Đăng nhập
                    </button>
                </div>
            </form>

            <div class="mt-6 pt-6 border-t border-zinc-800 text-center text-xs text-zinc-400">
                Chưa có tài khoản? 
                <a href="/auth/register" class="font-bold text-accent-400 hover:underline">Đăng ký ngay</a>
            </div>

            <!-- Demo account hint (chỉ hiện ở môi trường development) -->
            <?php if (defined('APP_ENV') && APP_ENV === 'development'): ?>
            <div class="mt-4 p-3 rounded-xl bg-zinc-950/60 border border-zinc-800/80 text-[11px] text-zinc-400 space-y-1">
                <div><strong>Khách hàng:</strong> nguyenvanan@gmail.com</div>
            </div>
            <?php endif; ?>
        </div>
    </div>

    <script>
    function togglePass() {
        const inp = document.getElementById('password-input');
        inp.type = inp.type === 'password' ? 'text' : 'password';
    }
    </script>
<script src="/assets/js/form-loading.js"></script>
</body>
</html>
