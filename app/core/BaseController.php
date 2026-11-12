<?php
/**
 * ZenTech BaseController — Lớp controller cơ sở
 * Tất cả Controller đều kế thừa class này
 */
abstract class BaseController
{
    protected PDO $pdo;

    public function __construct()
    {
        $this->pdo = Database::getInstance();
    }

    // ─── Render view với layout ───────────────────────────────────
    /**
     * @param string $view   Đường dẫn view tương đối (vd: 'home/index')
     * @param array  $data   Dữ liệu truyền vào view (extract thành biến)
     * @param string $layout Layout file ('main' | 'admin' | 'blank')
     */
    protected function render(string $view, array $data = [], string $layout = 'main'): void
    {
        // Extract data thành các biến cục bộ
        extract($data, EXTR_SKIP);

        // Buffer nội dung view
        ob_start();
        $viewFile = VIEW_PATH . '/' . str_replace('.', '/', $view) . '.php';

        if (!file_exists($viewFile)) {
            ob_end_clean();
            http_response_code(500);
            error_log("[ZenTech] View not found: {$viewFile}");
            die("View [{$view}] không tồn tại.");
        }

        require $viewFile;
        $content = ob_get_clean(); // $content được dùng trong layout

        // Load layout wrapper
        $layoutFile = VIEW_PATH . '/layouts/' . $layout . '.php';
        if (!file_exists($layoutFile)) {
            // Không có layout → render thẳng
            echo $content;
            return;
        }

        require $layoutFile;
    }

    // ─── Trả về JSON response ─────────────────────────────────────
    protected function renderJson(mixed $data, int $status = 200): void
    {
        http_response_code($status);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        exit;
    }

    // ─── Redirect ─────────────────────────────────────────────────
    protected function redirect(string $url): void
    {
        // Nếu không có http, prepend APP_URL
        if (!str_starts_with($url, 'http')) {
            $url = APP_URL . '/' . ltrim($url, '/');
        }
        header('Location: ' . $url);
        exit;
    }

    // ─── Redirect với flash message ───────────────────────────────
    protected function redirectWithFlash(string $url, string $message, string $type = 'success'): void
    {
        $_SESSION['flash'] = ['message' => $message, 'type' => $type];
        $this->redirect($url);
    }

    // ─── Lấy flash message và xóa khỏi session ───────────────────
    protected function getFlash(): ?array
    {
        if (isset($_SESSION['flash'])) {
            $flash = $_SESSION['flash'];
            unset($_SESSION['flash']);
            return $flash;
        }
        return null;
    }

    // ─── Kiểm tra đăng nhập ───────────────────────────────────────
    protected function isLoggedIn(): bool
    {
        return isset($_SESSION['user_id']);
    }

    // ─── Kiểm tra quyền admin ─────────────────────────────────────
    protected function isAdmin(): bool
    {
        return isset($_SESSION['user_role']) && $_SESSION['user_role'] === 'admin';
    }

    // ─── Bắt buộc đăng nhập ───────────────────────────────────────
    protected function requireAuth(): void
    {
        if (!$this->isLoggedIn()) {
            $this->redirect('/auth/login?redirect=' . urlencode($_SERVER['REQUEST_URI']));
        }
    }

    protected function requireLogin(): void
    {
        $this->requireAuth();
    }

    protected function requirePost(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->renderJson(['success' => false, 'message' => 'Method not allowed'], 405);
        }
    }

    protected function setFlash(string $key, mixed $message): void
    {
        $_SESSION['flash'][$key] = $message;
    }

    // ─── Bắt buộc quyền admin ─────────────────────────────────────
    protected function requireAdmin(): void
    {
        $this->requireAuth();
        if (!$this->isAdmin()) {
            $this->redirect('/');
        }
    }

    // ─── Lấy dữ liệu POST đã sanitize ────────────────────────────
    protected function getPost(string $key, mixed $default = null): mixed
    {
        // Chỉ trim; việc escape thực hiện ở đầu ra (view) bằng e()
        $value = $_POST[$key] ?? $default;
        // ?x[]=1 cho ra mảng: các hàm gọi đều cần giá trị đơn, nên bỏ qua và dùng mặc định
        return is_string($value) ? trim($value) : (is_array($value) ? $default : $value);
    }

    // ─── Lấy dữ liệu GET đã sanitize ─────────────────────────────
    protected function getGet(string $key, mixed $default = null): mixed
    {
        $value = $_GET[$key] ?? $default;
        return is_string($value) ? trim($value) : (is_array($value) ? $default : $value);
    }

    // ─── Lấy current user từ session ─────────────────────────────
    protected function currentUser(): array
    {
        return [
            'id'    => $_SESSION['user_id']    ?? null,
            'name'  => $_SESSION['user_name']  ?? 'Khách',
            'role'  => $_SESSION['user_role']  ?? 'guest',
            'email' => $_SESSION['user_email'] ?? '',
        ];
    }

    // ─── Format tiền VNĐ ─────────────────────────────────────────
    protected function formatPrice(int|float $amount): string
    {
        return number_format($amount, 0, ',', '.') . '₫';
    }

    // ─── Lấy số lượng giỏ hàng từ session ────────────────────────
    protected function getCartCount(): int
    {
        return array_sum(array_column($_SESSION['cart'] ?? [], 'quantity'));
    }
}
