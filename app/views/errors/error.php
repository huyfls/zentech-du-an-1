<?php
// Trang lỗi chung. Biến: $errorCode (int), $errorMessage (string)
$errorCode    = $errorCode    ?? 404;
$errorMessage = $errorMessage ?? 'Không tìm thấy trang.';
$titles = [403 => 'Không có quyền truy cập', 404 => 'Không tìm thấy trang', 419 => 'Phiên làm việc hết hạn', 500 => 'Có lỗi xảy ra'];
$title  = $titles[$errorCode] ?? 'Có lỗi xảy ra';
?><!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= (int) $errorCode ?> — <?= htmlspecialchars($title) ?> | ZenTech</title>
    <link rel="stylesheet" href="/assets/css/fonts.css">
    <script src="/assets/vendor/tailwind-3.4.0.js"></script>
    <script src="/assets/js/tailwind-theme.js"></script>
    <link rel="stylesheet" href="/assets/css/custom.css">
</head>
<body class="min-h-screen bg-zinc-950 text-white flex items-center justify-center px-4 font-sans antialiased">
    <main class="text-center max-w-md">
        <a href="/" class="inline-flex items-center gap-2 mb-10" aria-label="ZenTech - về trang chủ">
            <svg class="w-6 h-6 text-accent-500" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M13 2L4.5 13.5H11L10 22l9-12h-6.5L13 2Z"/></svg>
            <span class="text-xl font-bold">ZenTech</span>
        </a>
        <p class="text-7xl font-extrabold text-accent-400"><?= (int) $errorCode ?></p>
        <h1 class="mt-4 text-xl font-bold"><?= htmlspecialchars($title) ?></h1>
        <p class="mt-2 text-sm text-zinc-400"><?= htmlspecialchars($errorMessage) ?></p>
        <div class="mt-8 flex items-center justify-center gap-3">
            <a href="/" class="px-5 py-2.5 rounded-xl bg-accent-500 hover:bg-accent-400 text-zinc-950 text-sm font-bold transition">Về trang chủ</a>
            <a href="/san-pham" class="px-5 py-2.5 rounded-xl border border-zinc-700 hover:border-accent-400 text-sm text-zinc-300 transition">Xem sản phẩm</a>
            <a href="javascript:history.back()" class="px-5 py-2.5 rounded-xl border border-zinc-700 hover:border-accent-400 text-sm text-zinc-300 transition">Quay lại</a>
        </div>
    </main>
</body>
</html>
