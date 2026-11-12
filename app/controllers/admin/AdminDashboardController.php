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

    public function index(): void
    {
        // Thống kê doanh thu và đơn hàng
        $stats = [
            'total_revenue' => (float) ($this->pdo->query("SELECT SUM(total_amount) FROM orders WHERE status = 'delivered'")->fetchColumn() ?: 0),
            'total_orders'  => (int) ($this->pdo->query("SELECT COUNT(*) FROM orders")->fetchColumn() ?: 0),
            'pending_orders'=> (int) ($this->pdo->query("SELECT COUNT(*) FROM orders WHERE status = 'pending'")->fetchColumn() ?: 0),
            'total_products'=> (int) ($this->pdo->query("SELECT COUNT(*) FROM products WHERE is_active = 1")->fetchColumn() ?: 0),
            'total_users'   => (int) ($this->pdo->query("SELECT COUNT(*) FROM users WHERE role_id = 2")->fetchColumn() ?: 0),
        ];

        // 5 đơn hàng mới nhất
        $recentOrders = $this->pdo->query("
            SELECT o.*, u.full_name AS user_name 
            FROM orders o 
            LEFT JOIN users u ON u.id = o.user_id 
            ORDER BY o.created_at DESC 
            LIMIT 5
        ")->fetchAll();

        // Sản phẩm sắp hết hàng (< 5 cái)
        $lowStockProducts = $this->pdo->query("
            SELECT pv.*, p.name AS product_name 
            FROM product_variants pv
            JOIN products p ON p.id = pv.product_id
            WHERE pv.stock_qty <= 5 AND pv.is_active = 1
            ORDER BY pv.stock_qty ASC 
            LIMIT 5
        ")->fetchAll();

        $this->render('admin/dashboard', compact('stats', 'recentOrders', 'lowStockProducts'), 'admin');
    }
}
