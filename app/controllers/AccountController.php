<?php
/**
 * ZenTech AccountController
 * Trang tài khoản: thông tin cá nhân, đổi mật khẩu, sổ địa chỉ.
 */
class AccountController extends BaseController
{
    private function uid(): int { return (int) $_SESSION['user_id']; }

    public function index(): void
    {
        $this->requireLogin();
        $user = (new UserModel($this->pdo))->findUserById($this->uid());
        $st = $this->pdo->prepare('SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC');
        $st->execute([$this->uid()]);
        $this->render('account/index', ['user' => $user, 'addresses' => $st->fetchAll(), 'pageTitle' => 'Tài khoản của tôi – ZenTech']);
    }

    public function updateProfile(): void
    {
        $this->requireLogin();
        $name  = trim((string) $this->getPost('full_name', ''));
        $phone = trim((string) $this->getPost('phone', ''));
        if (mb_strlen($name) < 2 || ($phone !== '' && !preg_match('/^0[0-9]{9}$/', $phone))) {
            $this->setFlash('error', 'Họ tên tối thiểu 2 ký tự; số điện thoại gồm 10 chữ số, bắt đầu bằng 0.');
        } else {
            $this->pdo->prepare('UPDATE users SET full_name = ?, phone = ? WHERE id = ?')->execute([$name, $phone ?: null, $this->uid()]);
            $_SESSION['user_name'] = $name;
            $this->setFlash('success', 'Đã cập nhật thông tin.');
        }
        $this->redirect('/tai-khoan');
    }

    public function changePassword(): void
    {
        $this->requireLogin();
        $cur = (string) $this->getPost('current_password', '');
        $new = (string) $this->getPost('new_password', '');
        $cf  = (string) $this->getPost('confirm_password', '');
        $users = new UserModel($this->pdo);
        $u = $users->findUserById($this->uid());
        $hash = $this->pdo->prepare('SELECT password_hash FROM users WHERE id = ?');
        $hash->execute([$this->uid()]);
        $hash = $hash->fetchColumn();
        if (!$u || !$users->verifyPassword($cur, (string) $hash)) {
            $this->setFlash('error', 'Mật khẩu hiện tại không đúng.');
        } elseif (strlen($new) < 8) {
            $this->setFlash('error', 'Mật khẩu mới phải từ 8 ký tự trở lên.');
        } elseif ($new !== $cf) {
            $this->setFlash('error', 'Xác nhận mật khẩu mới không khớp.');
        } else {
            $this->pdo->prepare('UPDATE users SET password_hash = ? WHERE id = ?')->execute([password_hash($new, PASSWORD_BCRYPT), $this->uid()]);
            session_regenerate_id(true);
            $this->setFlash('success', 'Đã đổi mật khẩu.');
        }
        $this->redirect('/tai-khoan');
    }

    public function addAddress(): void
    {
        $this->requireLogin();
        $f = [];
        foreach (['receiver_name', 'phone', 'province', 'district', 'ward', 'street'] as $k) $f[$k] = mb_substr(trim((string) $this->getPost($k, '')), 0, 255);
        if (in_array('', $f, true) || !preg_match('/^0[0-9]{9}$/', $f['phone'])) {
            $this->setFlash('error', 'Vui lòng nhập đủ các trường địa chỉ; số điện thoại gồm 10 chữ số, bắt đầu bằng 0.');
            $this->redirect('/tai-khoan');
            return;
        }
        $default = (int) (bool) $this->getPost('is_default', 0);
        if ($default) $this->pdo->prepare('UPDATE addresses SET is_default = 0 WHERE user_id = ?')->execute([$this->uid()]);
        $this->pdo->prepare('INSERT INTO addresses (user_id, receiver_name, phone, province, district, ward, street, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)')
            ->execute([$this->uid(), $f['receiver_name'], $f['phone'], $f['province'], $f['district'], $f['ward'], $f['street'], $default]);
        $this->setFlash('success', 'Đã thêm địa chỉ.');
        $this->redirect('/tai-khoan');
    }

    public function deleteAddress(int $id): void
    {
        $this->requireLogin();
        $this->pdo->prepare('DELETE FROM addresses WHERE id = ? AND user_id = ?')->execute([$id, $this->uid()]);
        $this->setFlash('success', 'Đã xóa địa chỉ.');
        $this->redirect('/tai-khoan');
    }
}
