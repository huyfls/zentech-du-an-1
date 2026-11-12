<?php
/**
 * ZenTech AuthController
 * Xử lý đăng nhập, đăng ký, đăng xuất và phân quyền người dùng
 */
class AuthController extends BaseController
{
    private UserModel $userModel;

    public function __construct()
    {
        parent::__construct();
        $this->userModel = new UserModel($this->pdo);
    }

    /**
     * GET - Trang đăng nhập
     */
    public function loginPage(): void
    {
        if ($this->isLoggedIn()) {
            $this->redirect($_SESSION['user_role'] === 'admin' ? '/admin' : '/');
            return;
        }

        $redirect = $this->getGet('redirect', '');
        $this->render('auth/login', ['redirect' => $redirect], 'blank');
    }

    /**
     * POST - Xử lý đăng nhập
     */
    public function login(): void
    {
        $email    = trim($this->getPost('email', ''));
        $password = $this->getPost('password', '');
        $redirect = $this->getPost('redirect', '');

        if (empty($email) || empty($password)) {
            $this->setFlash('error', 'Vui lòng nhập đầy đủ Email và Mật khẩu.');
            $this->redirect('/auth/login' . ($redirect ? '?redirect=' . urlencode($redirect) : ''));
            return;
        }

        // Giới hạn thử sai: 5 lần / 15 phút cho mỗi cặp (IP, email). shortcut: lưu file tạm, đủ cho 1 máy chủ; nhiều máy chủ cần Redis/DB.
        $throttle = sys_get_temp_dir() . '/zentech_login_' . sha1(($_SERVER['REMOTE_ADDR'] ?? '') . '|' . mb_strtolower($email));
        $state = is_file($throttle) ? (json_decode((string) file_get_contents($throttle), true) ?: []) : [];
        if (($state['until'] ?? 0) > time()) {
            $this->setFlash('error', 'Bạn đã nhập sai quá nhiều lần. Vui lòng thử lại sau ' . (int) ceil((($state['until']) - time()) / 60) . ' phút.');
            $this->redirect('/auth/login' . ($redirect ? '?redirect=' . urlencode($redirect) : ''));
            return;
        }

        $user = $this->userModel->findByEmail($email);

        if (!$user || !$this->userModel->verifyPassword($password, $user['password_hash'])) {
            $fails = (($state['until'] ?? 0) > 0 || time() - ($state['first'] ?? 0) > 900) ? 1 : ($state['fails'] ?? 0) + 1;
            file_put_contents($throttle, json_encode([
                'fails' => $fails,
                'first' => $fails === 1 ? time() : ($state['first'] ?? time()),
                'until' => $fails >= 5 ? time() + 900 : 0,
            ]), LOCK_EX);
            $this->setFlash('error', 'Email hoặc mật khẩu không chính xác.');
            $this->redirect('/auth/login' . ($redirect ? '?redirect=' . urlencode($redirect) : ''));
            return;
        }

        if (!$user['is_active']) {
            $this->setFlash('error', 'Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.');
            $this->redirect('/auth/login');
            return;
        }

        @unlink($throttle);
        // Đăng nhập thành công -> chống session fixation, rồi lưu session
        session_regenerate_id(true);
        $_SESSION['user_id']    = (int) $user['id'];
        $_SESSION['user_name']  = $user['full_name'];
        $_SESSION['user_email'] = $user['email'];
        $_SESSION['user_role']  = ($user['role_id'] == 1 || ($user['role_name'] ?? '') === 'admin') ? 'admin' : 'customer';

        $this->setFlash('success', 'Chào mừng ' . $user['full_name'] . ' đã trở lại!');

        if (!empty($redirect) && str_starts_with($redirect, '/')) {
            $this->redirect($redirect);
            return;
        }

        $this->redirect($_SESSION['user_role'] === 'admin' ? '/admin' : '/');
    }

    /**
     * GET - Trang đăng ký
     */
    public function registerPage(): void
    {
        if ($this->isLoggedIn()) {
            $this->redirect('/');
            return;
        }

        $this->render('auth/register', [], 'blank');
    }

    /**
     * POST - Xử lý đăng ký
     */
    public function register(): void
    {
        $fullName = trim($this->getPost('full_name', ''));
        $email    = trim($this->getPost('email', ''));
        $phone    = trim($this->getPost('phone', ''));
        $password = $this->getPost('password', '');
        $confirm  = $this->getPost('confirm_password', '');

        $errors = [];

        if (empty($fullName)) {
            $errors[] = 'Họ và tên không được để trống.';
        }
        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $errors[] = 'Email không hợp lệ.';
        }
        if (mb_strlen($password) < 8) {
            $errors[] = 'Mật khẩu phải từ 8 ký tự trở lên.';
        }
        if ($password !== $confirm) {
            $errors[] = 'Xác nhận mật khẩu không trùng khớp.';
        }

        // Kiểm tra email trùng
        if (empty($errors)) {
            $existing = $this->userModel->findByEmail($email);
            if ($existing) {
                $errors[] = 'Email này đã được sử dụng. Vui lòng chọn email khác.';
            }
        }

        if (!empty($errors)) {
            $this->setFlash('errors', $errors);
            $this->setFlash('old', ['full_name' => $fullName, 'email' => $email, 'phone' => $phone]);
            $this->redirect('/auth/register');
            return;
        }

        // Tạo tài khoản
        try {
            $userId = $this->userModel->register($fullName, $email, $password, $phone);
        } catch (PDOException $e) {
            // Trùng email do race condition (UNIQUE uq_users_email)
            $userId = 0;
            error_log('[ZenTech][Register] ' . $e->getMessage());
        }

        if ($userId) {
            // Tự động đăng nhập (đổi session id chống fixation)
            session_regenerate_id(true);
            $_SESSION['user_id']    = $userId;
            $_SESSION['user_name']  = $fullName;
            $_SESSION['user_email'] = $email;
            $_SESSION['user_role']  = 'customer';

            $this->setFlash('success', 'Đăng ký tài khoản thành công!');
            $this->redirect('/');
        } else {
            $this->setFlash('error', 'Đăng ký thất bại. Vui lòng thử lại sau.');
            $this->redirect('/auth/register');
        }
    }

    /**
     * POST - Đăng xuất (CSRF được Router kiểm tra)
     */
    public function logout(): void
    {
        // Xóa thông tin user nhưng giữ lại giỏ hàng trong session
        $cart = $_SESSION['cart'] ?? [];
        session_unset();
        $_SESSION['cart'] = $cart;
        session_destroy();

        // Start session mới cho khách
        session_start();
        session_regenerate_id(true);   // session_destroy giữ nguyên mã cũ nếu không đổi
        $_SESSION['cart'] = $cart;

        $this->setFlash('success', 'Bạn đã đăng xuất.');
        $this->redirect('/auth/login');
    }

    /** GET - Form quên mật khẩu */
    public function forgotPage(): void
    {
        $this->render('auth/forgot', [], 'blank');
    }

    /**
     * POST - Tạo liên kết đặt lại mật khẩu (hiệu lực 30 phút).
     * shortcut: chưa có máy chủ gửi mail, liên kết hiện trên trang khi APP_ENV=development và ghi vào error_log; nối SMTP trước khi chạy thật.
     */
    public function forgot(): void
    {
        $email = trim((string) $this->getPost('email', ''));
        $user = $email !== '' ? $this->userModel->findByEmail($email) : null;
        if ($user) {
            $token = bin2hex(random_bytes(32));
            $this->pdo->prepare('INSERT INTO password_resets (user_id, token_hash, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 MINUTE))')
                ->execute([(int) $user['id'], hash('sha256', $token)]);
            $link = APP_URL . '/dat-lai-mat-khau/' . $token;
            error_log('[ZenTech][Reset password] ' . $email . ' -> ' . $link);
            if (defined('APP_ENV') && APP_ENV === 'development') {
                $this->setFlash('success', 'Môi trường thử nghiệm chưa gửi email. Mở liên kết này để đặt lại mật khẩu: ' . $link);
                $this->redirect('/quen-mat-khau');
                return;
            }
        }
        $this->setFlash('success', 'Nếu email tồn tại trong hệ thống, hướng dẫn đặt lại mật khẩu đã được gửi.');
        $this->redirect('/quen-mat-khau');
    }

    private function findReset(string $token): ?array
    {
        $st = $this->pdo->prepare('SELECT * FROM password_resets WHERE token_hash = ? AND used_at IS NULL AND expires_at > NOW()');
        $st->execute([hash('sha256', $token)]);
        return $st->fetch() ?: null;
    }

    /** GET - Form đặt mật khẩu mới */
    public function resetPage(string $token): void
    {
        $this->render('auth/reset', ['token' => $token, 'valid' => (bool) $this->findReset($token)], 'blank');
    }

    /** POST - Lưu mật khẩu mới */
    public function reset(string $token): void
    {
        $r = $this->findReset($token);
        $new = (string) $this->getPost('new_password', '');
        if (!$r) {
            $this->setFlash('error', 'Liên kết không hợp lệ hoặc đã hết hạn. Vui lòng yêu cầu lại.');
            $this->redirect('/quen-mat-khau');
            return;
        }
        if (strlen($new) < 8 || $new !== (string) $this->getPost('confirm_password', '')) {
            $this->setFlash('error', 'Mật khẩu mới phải từ 8 ký tự và hai lần nhập phải khớp.');
            $this->redirect('/dat-lai-mat-khau/' . $token);
            return;
        }
        $this->pdo->beginTransaction();
        $this->pdo->prepare('UPDATE users SET password_hash = ? WHERE id = ?')->execute([password_hash($new, PASSWORD_BCRYPT), (int) $r['user_id']]);
        $this->pdo->prepare('UPDATE password_resets SET used_at = NOW() WHERE user_id = ?')->execute([(int) $r['user_id']]);
        $this->pdo->commit();
        $this->setFlash('success', 'Đã đặt lại mật khẩu. Bạn có thể đăng nhập.');
        $this->redirect('/dang-nhap');
    }
}
