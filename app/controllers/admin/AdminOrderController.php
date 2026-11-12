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
            $label = ['pending' => 'Chờ xác nhận', 'confirmed' => 'Đã xác nhận', 'processing' => 'Đang xử lý', 'shipping' => 'Đang giao', 'delivered' => 'Đã giao', 'cancelled' => 'Đã hủy', 'returned' => 'Đã trả hàng'];
            $q = $this->pdo->prepare('SELECT status FROM orders WHERE id = ?');
            $q->execute([$id]);
            $cur = $q->fetchColumn();
            if ($cur === false) {
                $this->setFlash('error', 'Không tìm thấy đơn hàng.');
            } elseif ($cur === $status) {
                $this->setFlash('error', 'Đơn hàng đã ở trạng thái "' . ($label[$cur] ?? $cur) . '" rồi, không cần cập nhật lại.');
            } elseif (!array_key_exists($status, $label)) {
                $this->setFlash('error', 'Trạng thái bạn chọn không tồn tại.');
            } else {
                $next = array_map(fn($k) => $label[$k], OrderModel::TRANSITIONS[$cur] ?? []);
                $this->setFlash('error', 'Không thể chuyển từ "' . ($label[$cur] ?? $cur) . '" sang "' . $label[$status] . '". '
                    . ($next ? 'Bước tiếp theo hợp lệ: ' . implode(', ', $next) . '.' : 'Đơn này đã kết thúc, không đổi trạng thái được nữa.'));
            }
        }

        $this->redirect('/admin/orders/detail/' . $id);
    }
}
