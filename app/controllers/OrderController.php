<?php
/**
 * OrderController.php
 * Xử lý đặt hàng, lịch sử đơn hàng và hủy đơn
 * Đặt hàng dùng transaction-safe với FOR UPDATE lock
 */
class OrderController extends BaseController
{
    private OrderModel   $orderModel;
    private ProductModel $productModel;

    public function __construct()
    {
        parent::__construct();
        $this->orderModel   = new OrderModel($this->pdo);
        $this->productModel = new ProductModel($this->pdo);
    }

    /**
     * GET - Hiển thị form thanh toán (checkout)
     * Yêu cầu đăng nhập
     */
    public function checkout(): void
    {
        // Yêu cầu đăng nhập
        $this->requireLogin();

        // Giỏ hàng phải có sản phẩm
        if (empty($_SESSION['cart'])) {
            $this->redirect('/cart');
            return;
        }

        $cartItems = $_SESSION['cart'];

        // Tính subtotal
        $subtotal = 0.0;
        foreach ($cartItems as $item) {
            $subtotal += (float) $item['price'] * (int) $item['quantity'];
        }

        // Phí ship mặc định (có thể tính động theo địa chỉ)
        $shippingFee = OrderModel::shippingFee($subtotal);

        $this->render('orders/checkout', compact('cartItems', 'subtotal', 'shippingFee'));
    }

    /**
     * POST - Đặt hàng
     * Quy trình: validate cart → check stock (FOR UPDATE) → INSERT order
     *           → INSERT order_details → UPDATE stock → clear cart → COMMIT
     * ROLLBACK nếu có bất kỳ lỗi nào
     */
    public function place(): void
    {
        $this->requireLogin();

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/checkout');
            return;
        }

        // Kiểm tra giỏ hàng có sản phẩm không
        if (empty($_SESSION['cart'])) {
            $this->setFlash('error', 'Giỏ hàng của bạn đang trống.');
            $this->redirect('/cart');
            return;
        }

        // Lấy và validate thông tin giao hàng
        $receiverName    = trim($this->getPost('receiver_name', ''));
        $receiverPhone   = trim($this->getPost('receiver_phone', ''));
        $shippingAddress = trim($this->getPost('shipping_address', ''));
        $paymentMethod   = $this->getPost('payment_method', 'cod');
        $note            = trim($this->getPost('note', ''));

        // Validate dữ liệu đầu vào
        $errors = [];
        if (empty($receiverName)) {
            $errors[] = 'Vui lòng nhập tên người nhận.';
        }
        if (empty($receiverPhone) || !preg_match('/^0[0-9]{9}$/', $receiverPhone)) {
            $errors[] = 'Số điện thoại không hợp lệ (10 chữ số, bắt đầu bằng 0).';
        }
        if (empty($shippingAddress)) {
            $errors[] = 'Vui lòng nhập địa chỉ giao hàng.';
        }
        if (!in_array($paymentMethod, ['cod', 'bank_transfer', 'momo'])) {
            $errors[] = 'Phương thức thanh toán không hợp lệ.';
        }

        if (!empty($errors)) {
            $this->setFlash('errors', $errors);
            $this->setFlash('old', ['receiver_name' => $receiverName, 'receiver_phone' => $receiverPhone, 'shipping_address' => $shippingAddress, 'note' => $note, 'payment_method' => $paymentMethod]);
            $this->redirect('/checkout');
            return;
        }

        // Gọi OrderModel để đặt hàng trong transaction
        $addressInfo = [
            'receiver_name'    => $receiverName,
            'receiver_phone'   => $receiverPhone,
            'shipping_address' => $shippingAddress,
            'note'             => $note,
        ];

        $result = $this->orderModel->placeOrder(
            (int) $_SESSION['user_id'],
            $addressInfo,
            $_SESSION['cart'],
            $paymentMethod
        );

        if ($result['success']) {
            // Xóa giỏ hàng sau khi đặt thành công
            $_SESSION['cart'] = [];

            $this->setFlash('success', 'Đặt hàng thành công! Mã đơn: ' . $result['order_code']);
            $this->redirect('/orders/' . $result['order_id']);
        } else {
            $this->setFlash('error', $result['message'] ?? 'Đặt hàng thất bại, vui lòng thử lại.');
            $this->redirect('/checkout');
        }
    }

    /**
     * Lịch sử đơn hàng của user đang đăng nhập
     */
    public function history(): void
    {
        $this->requireLogin();

        $orders = $this->orderModel->getByUser((int) $_SESSION['user_id']);

        $this->render('orders/history', compact('orders'));
    }

    /**
     * Chi tiết một đơn hàng
     * Chỉ cho phép xem đơn của chính mình
     */
    public function detail(int $id): void
    {
        $this->requireLogin();

        $order = $this->orderModel->getById($id);

        if (!$order) {
            $this->redirect('/404');
            return;
        }

        // Bảo mật: chỉ được xem đơn hàng của chính mình (trừ admin)
        if ((int) $order['user_id'] !== (int) $_SESSION['user_id'] && ($_SESSION['user_role'] ?? '') !== 'admin') {
            $this->redirect('/403');
            return;
        }

        $this->render('orders/detail', compact('order'));
    }

    /**
     * POST - Hủy đơn hàng (chỉ hủy được nếu status = 'pending')
     */
    public function cancel(int $id): void
    {
        $this->requireLogin();

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/orders/' . $id);
            return;
        }

        $order = $this->orderModel->getById($id);

        if (!$order) {
            $this->setFlash('error', 'Đơn hàng không tồn tại.');
            $this->redirect('/orders');
            return;
        }

        // Chỉ được hủy đơn của chính mình
        if ((int) $order['user_id'] !== (int) $_SESSION['user_id']) {
            $this->redirect('/403');
            return;
        }

        // Chỉ được hủy khi đơn đang ở trạng thái 'pending'
        if ($order['status'] !== 'pending') {
            $this->setFlash('error', 'Chỉ có thể hủy đơn hàng đang chờ xử lý.');
            $this->redirect('/orders/' . $id);
            return;
        }

        // Hủy trong transaction: khóa đơn, hoàn tồn kho, ghi log
        $success = $this->orderModel->cancel($id, (int) $_SESSION['user_id']);

        if ($success) {
            $this->setFlash('success', 'Đơn hàng đã được hủy thành công.');
        } else {
            $this->setFlash('error', 'Không thể hủy đơn hàng. Vui lòng thử lại.');
        }

        $this->redirect('/orders/' . $id);
    }

}
