<?php
/**
 * ZenTech AdminDashboardController
 * Thống kê tổng quan hệ thống: Doanh thu, Đơn hàng mới, Tồn kho, Biểu đồ
 */
class AdminDashboardController extends BaseController
{
    private OrderModel $orderModel;
    private ProductModel $productModel;

    public function __construct()
    {
        parent::__construct();
        $this->requireAdmin();
        $this->orderModel   = new OrderModel($this->pdo);
        $this->productModel = new ProductModel($this->pdo);
    }

    public const RANGES = ['today' => 'Hôm nay', '7d' => '7 ngày qua', '30d' => '30 ngày qua', 'month' => 'Tháng này', 'all' => 'Toàn thời gian', 'custom' => 'Tùy chọn'];

    public function index(): void
    {
        // Bộ lọc: khoảng thời gian (theo ngày đặt đơn) + trạng thái cho danh sách đơn
        $range  = $this->getGet('range', '30d');
        $range  = isset(self::RANGES[$range]) ? $range : '30d';
        $status = $this->getGet('status', '');
        $status = isset(OrderModel::LABELS[$status]) ? $status : '';
        $today  = date('Y-m-d');
        [$from, $to] = match ($range) {
            'today'  => [$today, $today],
            '7d'     => [date('Y-m-d', strtotime('-6 days')), $today],
            '30d'    => [date('Y-m-d', strtotime('-29 days')), $today],
            'month'  => [date('Y-m-01'), $today],
            'all'    => ['2000-01-01', $today],
            'custom' => [$this->validDate($this->getGet('from', '')) ?? date('Y-m-d', strtotime('-29 days')), $this->validDate($this->getGet('to', '')) ?? $today],
        };
        if ($from > $to) [$from, $to] = [$to, $from];
        $p = [$from . ' 00:00:00', $to . ' 23:59:59'];
        $one = function (string $sql, array $extra = []) use ($p) {
            $st = $this->pdo->prepare($sql);
            $st->execute(array_merge($p, $extra));
            return $st->fetchColumn() ?: 0;
        };
        $in = 'created_at BETWEEN ? AND ?';

        $stats = [
            // doanh thu tính đơn khách đã nhận (chưa/đã hết hạn trả hàng), không tính đơn trả hàng hay hủy
            'total_revenue'  => (float) $one("SELECT SUM(total_amount) FROM orders WHERE $in AND status IN ('delivered', 'completed')"),
            'total_orders'   => (int) $one("SELECT COUNT(*) FROM orders WHERE $in"),
            'pending_orders' => (int) $one("SELECT COUNT(*) FROM orders WHERE $in AND status = 'pending'"),
            'cancelled'      => (int) $one("SELECT COUNT(*) FROM orders WHERE $in AND status = 'cancelled'"),
            'returns'        => (int) $one("SELECT COUNT(*) FROM order_returns WHERE $in"),
            'new_customers'  => (int) $one("SELECT COUNT(*) FROM users WHERE $in AND role_id = 2"),
            'total_products' => (int) ($this->pdo->query("SELECT COUNT(*) FROM products WHERE is_active = 1")->fetchColumn() ?: 0),
        ];

        $st = $this->pdo->prepare("
            SELECT o.*, u.full_name AS user_name
            FROM orders o LEFT JOIN users u ON u.id = o.user_id
            WHERE o.created_at BETWEEN ? AND ?" . ($status ? ' AND o.status = ?' : '') . "
            ORDER BY o.created_at DESC LIMIT 10");
        $st->execute($status ? array_merge($p, [$status]) : $p);
        $recentOrders = $st->fetchAll();

        // Sản phẩm sắp hết hàng (< 5 cái)
        $lowStockProducts = $this->pdo->query("
            SELECT pv.*, p.name AS product_name 
            FROM product_variants pv
            JOIN products p ON p.id = pv.product_id
            WHERE pv.stock_qty <= 5 AND pv.is_active = 1
            ORDER BY pv.stock_qty ASC 
            LIMIT 5
        ")->fetchAll();

        $filter = compact('range', 'status', 'from', 'to');
        $this->render('admin/dashboard', compact('stats', 'recentOrders', 'lowStockProducts', 'filter'), 'admin');
    }

    private function validDate(string $d): ?string
    {
        $t = DateTime::createFromFormat('!Y-m-d', $d);
        return $t && $t->format('Y-m-d') === $d ? $d : null;
    }
}
