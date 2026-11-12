<?php
/**
 * ZenTech — Csrf
 * Sinh và kiểm tra CSRF token (đồng bộ theo session).
 */
class Csrf
{
    public static function token(): string
    {
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }

    /** Thẻ <input hidden> dùng trong form. */
    public static function field(): string
    {
        return '<input type="hidden" name="csrf_token" value="' . self::token() . '">';
    }

    /** Thẻ <meta> để JS đọc và gửi qua header X-CSRF-Token. */
    public static function meta(): string
    {
        return '<meta name="csrf-token" content="' . self::token() . '">';
    }

    public static function verify(): bool
    {
        $sent = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
        $real = $_SESSION['csrf_token'] ?? '';
        return is_string($sent) && $real !== '' && hash_equals($real, $sent);
    }
}

/** Escape đầu ra HTML (dùng trong view). */
function e(mixed $s): string
{
    return htmlspecialchars((string) $s, ENT_QUOTES, 'UTF-8');
}
