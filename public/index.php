<?php
/**
 * ZenTech — Front Controller
 * Điểm vào duy nhất của ứng dụng (single entry point)
 */

// Thời gian không thao tác tối đa trước khi tự đăng xuất (giây): khách 2 giờ, admin 30 phút.
const SESSION_IDLE_CUSTOMER = 7200;
const SESSION_IDLE_ADMIN    = 1800;

// Khởi động session với cài đặt bảo mật. gc_maxlifetime phải >= mức dài nhất để PHP không dọn phiên sớm.
ini_set('session.gc_maxlifetime', (string) SESSION_IDLE_CUSTOMER);
session_set_cookie_params([
    'lifetime' => 0,         // cookie hết khi đóng trình duyệt; hạn thật do kiểm tra không thao tác bên dưới
    'path'     => '/',
    'secure'   => false,     // Đổi true khi deploy HTTPS
    'httponly' => true,
    'samesite' => 'Lax',
]);
session_start();

// Hết hạn do không thao tác: hủy phiên cũ (kể cả giỏ hàng), báo lý do ở trang tiếp theo.
if (isset($_SESSION['user_id'])) {
    $idleLimit = ($_SESSION['user_role'] ?? '') === 'admin' ? SESSION_IDLE_ADMIN : SESSION_IDLE_CUSTOMER;
    if (time() - ($_SESSION['last_activity'] ?? time()) > $idleLimit) {
        session_destroy();
        session_start();
        session_regenerate_id(true);
        $_SESSION['flash'] = ['error' => 'Phiên đăng nhập đã hết hạn do bạn không thao tác quá lâu. Vui lòng đăng nhập lại.'];
    }
}
if (isset($_SESSION['user_id'])) {
    $_SESSION['last_activity'] = time();
}

// Header bảo mật. CSP cho phép inline script/style vì giao diện dùng Tailwind và script nhúng trong trang.
header_remove('X-Powered-By');
header('X-Frame-Options: SAMEORIGIN');
header('X-Content-Type-Options: nosniff');
header('Referrer-Policy: strict-origin-when-cross-origin');
header("Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self'; frame-ancestors 'self'; form-action 'self'; base-uri 'self'");

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
