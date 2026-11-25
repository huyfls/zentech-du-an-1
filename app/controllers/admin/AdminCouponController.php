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
        $coupons = $this->pdo->query('SELECT c.*, cat.name AS category_name, p.name AS product_name FROM coupons c
            LEFT JOIN categories cat ON cat.id = c.category_id LEFT JOIN products p ON p.id = c.product_id ORDER BY c.id DESC')->fetchAll();
        $categories = $this->pdo->query('SELECT id, name, parent_id FROM categories WHERE is_active = 1 ORDER BY COALESCE(parent_id, id), parent_id IS NOT NULL, name')->fetchAll();
        $products = $this->pdo->query('SELECT id, name FROM products WHERE is_active = 1 ORDER BY name')->fetchAll();
        $this->render('admin/coupons/index', compact('coupons', 'categories', 'products'), 'admin');
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
        $scope = (string) $this->getPost('scope', 'all');
        $catId = $scope === 'category' ? (int) $this->getPost('category_id', 0) : 0;
        $prodId = $scope === 'product' ? (int) $this->getPost('product_id', 0) : 0;

        $err = null;
        if (!preg_match('/^[A-Z0-9]{3,50}$/', $code)) $err = 'Mã chỉ gồm chữ không dấu và số, dài 3–50 ký tự.';
        elseif (!in_array($type, ['percent', 'fixed'], true)) $err = 'Loại giảm giá không hợp lệ.';
        elseif ($value <= 0 || ($type === 'percent' && $value > 100)) $err = 'Giá trị giảm không hợp lệ (phần trăm từ 1 đến 100).';
        elseif ($max !== '' && (!ctype_digit($max) || (int) $max < 1)) $err = 'Số lượt dùng tối đa phải là số nguyên dương.';
        elseif ($from && $to && strtotime($to) < strtotime($from)) $err = 'Ngày hết hạn phải sau ngày bắt đầu.';
        elseif ($scope === 'category' && !$this->exists('categories', $catId)) $err = 'Vui lòng chọn danh mục áp dụng.';
        elseif ($scope === 'product' && !$this->exists('products', $prodId)) $err = 'Vui lòng chọn sản phẩm áp dụng.';

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
            'INSERT INTO coupons (code, description, discount_type, discount_value, min_order_value, category_id, product_id, max_uses, starts_at, expires_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
        )->execute([$code, $desc ?: null, $type, $value, $min, $catId ?: null, $prodId ?: null, $max === '' ? null : (int) $max, $from ?: null, $to ?: null]);
        $this->setFlash('success', 'Đã tạo mã ' . $code . '.');
        $this->redirect('/admin/coupons');
    }

    public function toggle(int $id): void
    {
        $this->pdo->prepare('UPDATE coupons SET is_active = 1 - is_active WHERE id = ?')->execute([$id]);
        $this->setFlash('success', 'Đã đổi trạng thái mã giảm giá.');
        $this->redirect('/admin/coupons');
    }

    private function exists(string $table, int $id): bool
    {
        $st = $this->pdo->prepare("SELECT 1 FROM $table WHERE id = ?"); // $table chỉ là hằng trong code
        $st->execute([$id]);
        return (bool) $st->fetchColumn();
    }
}
