<?php
/**
 * Cấu hình ứng dụng ZenTech
 */

// Môi trường: 'development' | 'production'
// Môi trường: biến APP_ENV nếu có; mặc định 'development' khi chạy trên máy (localhost), còn lại là 'production'
$isLocalHost = PHP_SAPI === 'cli' || in_array($_SERVER['SERVER_NAME'] ?? 'localhost', ['localhost', '127.0.0.1', '::1'], true);
define('APP_ENV',      getenv('APP_ENV') ?: ($isLocalHost ? 'development' : 'production'));
define('APP_NAME',     'ZenTech');
// Tự động phát hiện APP_URL theo môi trường chạy (PHP dev server hoặc Apache XAMPP)
$baseDir = isset($_SERVER['SCRIPT_NAME']) ? str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'])) : '';
$baseDir = ($baseDir === '/' || $baseDir === '.') ? '' : $baseDir;
// Sau tunnel/proxy (Cloudflare) trình duyệt dùng HTTPS nhưng PHP chỉ thấy HTTP nội bộ nên đọc thêm X-Forwarded-Proto
$scheme = ((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || ($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https') ? 'https://' : 'http://';
$httpHost = $_SERVER['HTTP_HOST'] ?? 'localhost:8000';
// Trên máy chủ thật nên đặt biến APP_URL để không phụ thuộc vào header Host do người dùng gửi
define('APP_URL', rtrim(getenv('APP_URL') ?: $scheme . $httpHost . $baseDir, '/'));
define('APP_VERSION',  '1.0.0');

// Đường dẫn thư mục gốc
define('BASE_PATH',    dirname(__DIR__));
define('APP_PATH',     BASE_PATH . '/app');
define('PUBLIC_PATH',  BASE_PATH . '/public');
define('VIEW_PATH',    APP_PATH  . '/views');
define('UPLOAD_PATH',  PUBLIC_PATH . '/uploads');

// Phân trang
define('PER_PAGE', 12);

// Session
define('SESSION_LIFETIME', 86400); // 24 giờ

// AI API (Gemini)
define('GEMINI_API_KEY',  getenv('GEMINI_API_KEY') ?: 'YOUR_GEMINI_API_KEY_HERE');
define('GEMINI_API_URL',  'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent');

// Hiển thị lỗi theo môi trường
if (APP_ENV === 'development') {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(0);
    ini_set('display_errors', 0);
}
