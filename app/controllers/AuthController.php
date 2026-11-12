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

        $user = $this->userModel->findByEmail($email);

        if (!$user || !$this->userModel->verifyPassword($password, $user['password_hash'])) {
            $this->setFlash('error', 'Email hoặc mật khẩu không chính xác.');
            $this->redirect('/auth/login' . ($redirect ? '?redirect=' . urlencode($redirect) : ''));
            return;
        }

        if (!$user['is_active']) {
            $this->setFlash('error', 'Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.');
            $this->redirect('/auth/login');
            return;
        }

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
}
