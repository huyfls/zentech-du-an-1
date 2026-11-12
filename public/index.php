<?php
/**
 * ZenTech — Front Controller
 * Điểm vào duy nhất của ứng dụng (single entry point)
 */

// Khởi động session với cài đặt bảo mật
session_set_cookie_params([
    'lifetime' => 86400,
    'path'     => '/',
    'secure'   => false,     // Đổi true khi deploy HTTPS
    'httponly' => true,
    'samesite' => 'Lax',
]);
session_start();

// Load cấu hình ứng dụng
require_once dirname(__DIR__) . '/config/app.php';
require_once dirname(__DIR__) . '/config/database.php';

// ── Autoloader ────────────────────────────────────────────────────
// Tự động load file class khi cần — không cần require_once thủ công
spl_autoload_register(function (string $class): void {
    $searchPaths = [
        APP_PATH . '/core/',
        APP_PATH . '/controllers/',
        APP_PATH . '/controllers/admin/',
        APP_PATH . '/models/',
    ];

    foreach ($searchPaths as $path) {
        $file = $path . $class . '.php';
        if (file_exists($file)) {
            require_once $file;
            return;
        }
    }
    // Class không tìm thấy — log lỗi (không die để router xử lý 404)
    error_log("[ZenTech][Autoload] Class not found: {$class}");
});

require_once APP_PATH . '/core/Csrf.php';

// ── Khởi chạy Router ─────────────────────────────────────────────
$router = new Router();
$router->dispatch();
