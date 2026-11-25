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

        $return = $this->pdo->prepare('SELECT * FROM order_returns WHERE order_id = ?');
        $return->execute([$id]);
        $return = $return->fetch() ?: null;

        $this->render('admin/orders/detail', compact('order', 'orderLogs', 'return'), 'admin');
    }

    /**
     * POST - Cập nhật trạng thái đơn hàng (chỉ các bước trong OrderModel::TRANSITIONS)
     */
    public function updateStatus(int $id): void
    {
        $status = (string) $this->getPost('status', '');
        $label  = OrderModel::LABELS;

        if ($this->orderModel->updateStatus($id, $status, (int) $_SESSION['user_id'])) {
            $this->setFlash('success', 'Đã cập nhật trạng thái đơn hàng: ' . $label[$status] . '.');
        } else {
            $q = $this->pdo->prepare('SELECT status, delivered_at FROM orders WHERE id = ?');
            $q->execute([$id]);
            $cur = $q->fetch();
            if (!$cur) {
                $this->setFlash('error', 'Không tìm thấy đơn hàng.');
            } elseif (!isset($label[$status])) {
                $this->setFlash('error', 'Trạng thái bạn chọn không tồn tại.');
            } elseif ($status === 'completed' && $cur['status'] === 'delivered') {
                $this->setFlash('error', 'Khách vẫn còn trong hạn ' . OrderModel::RETURN_DAYS . ' ngày trả hàng, chưa thể đánh dấu hoàn thành.');
            } else {
                $next = array_map(fn($k) => $label[$k], OrderModel::TRANSITIONS[$cur['status']] ?? []);
                $this->setFlash('error', 'Không thể chuyển từ "' . $label[$cur['status']] . '" sang "' . $label[$status] . '". '
                    . ($next ? 'Bước tiếp theo hợp lệ: ' . implode(', ', $next) . '.' : 'Admin không có thao tác nào ở bước này.'));
            }
        }

        $this->redirect('/admin/orders/detail/' . $id);
    }

    /** POST - Ghi nhận một lần giao thất bại (đơn vị vận chuyển hoặc shipper). */
    public function deliveryFailed(int $id): void
    {
        $n = $this->orderModel->deliveryFailed($id, (int) $_SESSION['user_id'], (string) $this->getPost('note', ''));
        if ($n === null) $this->setFlash('error', 'Chỉ ghi nhận giao thất bại khi đơn đang ở đơn vị vận chuyển hoặc shipper đang giao.');
        elseif ($n >= OrderModel::MAX_FAILS) $this->setFlash('success', "Giao thất bại lần $n: đơn đã bị hủy, hàng được cộng lại vào kho.");
        else $this->setFlash('success', "Đã ghi nhận giao thất bại lần $n/" . OrderModel::MAX_FAILS . '.');
        $this->redirect('/admin/orders/detail/' . $id);
    }

    /** Tab Hoàn hàng: yêu cầu trả hàng đang chờ duyệt và đã xử lý. */
    public function returns(): void
    {
        $tab = $this->getGet('tab', 'pending') === 'done' ? 'done' : 'pending';
        $st = $this->pdo->prepare("
            SELECT r.*, o.order_code, o.total_amount, o.payment_method, u.full_name, u.email
            FROM order_returns r JOIN orders o ON o.id = r.order_id JOIN users u ON u.id = r.user_id
            WHERE r.status " . ($tab === 'pending' ? "= 'pending'" : "<> 'pending'") . "
            ORDER BY r.created_at DESC LIMIT 100");
        $st->execute();
        $returns = $st->fetchAll();
        $pendingCount = (int) $this->pdo->query("SELECT COUNT(*) FROM order_returns WHERE status = 'pending'")->fetchColumn();
        $this->render('admin/orders/returns', compact('returns', 'tab', 'pendingCount'), 'admin');
    }

    /** POST - Duyệt hoặc từ chối yêu cầu trả hàng của đơn $id. */
    public function resolveReturn(int $id): void
    {
        $approve = $this->getPost('decision', '') === 'approve';
        $ok = $this->orderModel->resolveReturn($id, $approve, (int) $_SESSION['user_id'], (string) $this->getPost('admin_note', ''));
        $this->setFlash($ok ? 'success' : 'error', $ok
            ? ($approve ? 'Đã duyệt trả hàng: hàng về kho và đã hoàn tiền.' : 'Đã từ chối trả hàng, đơn chuyển sang Hoàn thành.')
            : 'Yêu cầu này đã được xử lý hoặc không tồn tại.');
        $this->redirect('/admin/returns');
    }
}
