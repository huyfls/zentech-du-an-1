<?php
/**
 * ZenTech - Kết nối cơ sở dữ liệu PDO
 * Sử dụng Singleton pattern để tránh tạo nhiều connection
 */
class Database {
    private static ?PDO $instance = null;
    
    // Mặc định là cấu hình XAMPP trên máy. Trên máy chủ thật đặt biến môi trường DB_HOST, DB_NAME, DB_USER, DB_PASS
    // và dùng tài khoản MySQL riêng chỉ có quyền trên database này, không dùng root.
    private static array $config = [];

    private static function config(): array
    {
        return self::$config ?: self::$config = [
            'host'    => getenv('DB_HOST') ?: 'localhost',
            'dbname'  => getenv('DB_NAME') ?: 'zentech_db',
            'user'    => getenv('DB_USER') ?: 'root',
            'pass'    => getenv('DB_PASS') !== false ? getenv('DB_PASS') : '',
            'charset' => 'utf8mb4',
        ];
    }
    
    public static function getInstance(): PDO {
        if (self::$instance === null) {
            try {
                $dsn = sprintf(
                    'mysql:host=%s;dbname=%s;charset=%s',
                    self::config()['host'],
                    self::config()['dbname'],
                    self::config()['charset']
                );
                self::$instance = new PDO($dsn, self::config()['user'], self::config()['pass'], [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => true,
                ]);
            } catch (PDOException $e) {
                // Ghi log lỗi, không hiển thị thông tin nhạy cảm ra ngoài
                error_log('[ZenTech][DB] Connection failed: ' . $e->getMessage());
                http_response_code(503);
                die(json_encode(['error' => 'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.']));
            }
        }
        return self::$instance;
    }
    
    // Ngăn clone và unserialize
    private function __clone() {}
    public function __wakeup() { throw new \Exception("Cannot unserialize singleton"); }
}
