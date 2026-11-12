<?php
/**
 * ZenTech AdminOrderController
 * Quản lý đơn hàng, duyệt trạng thái và xuất chi tiết đơn
 */
class AdminOrderController extends BaseController
{
    private OrderModel $orderModel;

    public function __construct()
    {
        parent::__construct();
        $this->requireAdmin();
        $this->orderModel = new OrderModel($this->pdo);
    }

    /**
     * Danh sách đơn hàng
     */
    public function index(): void
    {
        $page    = max(1, (int) $this->getGet('page', 1));
        $status  = trim($this->getGet('status', ''));
        $search  = trim($this->getGet('q', ''));
        $perPage = 10;

        $filters = [
            'status' => $status,
            'search' => $search,
        ];

        $result = $this->orderModel->getAllAdmin($filters, $page, $perPage);
        $orders = $result['items'];
        $total  = $result['total'];
        $pages  = $result['total_pages'];
        $counts = $this->orderModel->getStatusCounts();

        $this->render('admin/orders/index', compact('orders', 'page', 'pages', 'total', 'status', 'search', 'counts'), 'admin');
    }

    /**
     * Chi tiết đơn hàng
     */
    public function detail(int $id): void
    {
        $order = $this->orderModel->getById($id);
        if (!$order) {
            $this->redirect('/admin/orders');
            return;
        }

        // Lấy lịch sử thay đổi trạng thái
        $logs = $this->pdo->prepare("
            SELECT osl.*, u.full_name AS changer_name 
            FROM order_status_logs osl
            LEFT JOIN users u ON u.id = osl.changed_by
            WHERE osl.order_id = ? 
            ORDER BY osl.created_at ASC
        ");
        $logs->execute([$id]);
        $orderLogs = $logs->fetchAll();

        $this->render('admin/orders/detail', compact('order', 'orderLogs'), 'admin');
    }

    /**
     * POST - Cập nhật trạng thái đơn hàng
     */
    public function updateStatus(int $id): void
    {
        $status = $this->getPost('status', '');
        $adminId = (int) $_SESSION['user_id'];

        if ($this->orderModel->updateStatus($id, $status, $adminId)) {
            $this->setFlash('success', 'Đã cập nhật trạng thái đơn hàng sang: ' . strtoupper($status));
        } else {
            $this->setFlash('error', 'Cập nhật thất bại: trạng thái mới không hợp lệ với trạng thái hiện tại của đơn.');
        }

        $this->redirect('/admin/orders/detail/' . $id);
    }
}
