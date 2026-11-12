<?php
/**
 * ZenTech AdminCouponController
 * Quản lý mã giảm giá: xem danh sách, tạo mới, bật/tắt.
 */
class AdminCouponController extends BaseController
{
    public function __construct()
    {
        parent::__construct();
        $this->requireAdmin();
    }

    public function index(): void
    {
        $coupons = $this->pdo->query('SELECT * FROM coupons ORDER BY id DESC')->fetchAll();
        $this->render('admin/coupons/index', compact('coupons'), 'admin');
    }

    public function store(): void
    {
        $code  = strtoupper(trim((string) $this->getPost('code', '')));
        $type  = $this->getPost('discount_type', 'percent');
        $value = (float) $this->getPost('discount_value', 0);
        $min   = max(0, (int) $this->getPost('min_order_value', 0));
        $max   = trim((string) $this->getPost('max_uses', ''));
        $desc  = trim((string) $this->getPost('description', ''));
        $from  = trim((string) $this->getPost('starts_at', ''));
        $to    = trim((string) $this->getPost('expires_at', ''));

        $err = null;
        if (!preg_match('/^[A-Z0-9]{3,50}$/', $code)) $err = 'Mã chỉ gồm chữ không dấu và số, dài 3–50 ký tự.';
        elseif (!in_array($type, ['percent', 'fixed'], true)) $err = 'Loại giảm giá không hợp lệ.';
        elseif ($value <= 0 || ($type === 'percent' && $value > 100)) $err = 'Giá trị giảm không hợp lệ (phần trăm từ 1 đến 100).';
        elseif ($max !== '' && (!ctype_digit($max) || (int) $max < 1)) $err = 'Số lượt dùng tối đa phải là số nguyên dương.';
        elseif ($from && $to && strtotime($to) < strtotime($from)) $err = 'Ngày hết hạn phải sau ngày bắt đầu.';

        if (!$err) {
            $dup = $this->pdo->prepare('SELECT 1 FROM coupons WHERE code = ?');
            $dup->execute([$code]);
            if ($dup->fetchColumn()) $err = 'Mã này đã tồn tại.';
        }
        if ($err) {
            $this->setFlash('error', $err);
            $this->redirect('/admin/coupons');
            return;
        }

        $this->pdo->prepare(
            'INSERT INTO coupons (code, description, discount_type, discount_value, min_order_value, max_uses, starts_at, expires_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
        )->execute([$code, $desc ?: null, $type, $value, $min, $max === '' ? null : (int) $max, $from ?: null, $to ?: null]);
        $this->setFlash('success', 'Đã tạo mã ' . $code . '.');
        $this->redirect('/admin/coupons');
    }

    public function toggle(int $id): void
    {
        $this->pdo->prepare('UPDATE coupons SET is_active = 1 - is_active WHERE id = ?')->execute([$id]);
        $this->setFlash('success', 'Đã đổi trạng thái mã giảm giá.');
        $this->redirect('/admin/coupons');
    }
}
