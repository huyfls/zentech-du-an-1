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

        // Giá và tồn kho có thể đã đổi từ lúc bỏ vào giỏ: đồng bộ trước khi hiện tổng tiền
        if ($notes = $this->productModel->refreshCart($_SESSION['cart'])) {
            $this->setFlash('error', implode(' ', $notes));
            $this->redirect('/gio-hang');
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

        $st = $this->pdo->prepare('SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC');
        $st->execute([(int) $_SESSION['user_id']]);
        $addresses = $st->fetchAll();

        $st = $this->pdo->prepare('SELECT phone, wallet_balance FROM users WHERE id = ?');
        $st->execute([(int) $_SESSION['user_id']]);
        $me = $st->fetch();

        $this->render('orders/checkout', compact('cartItems', 'subtotal', 'shippingFee', 'addresses', 'me'));
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
        $couponCode      = strtoupper(trim($this->getPost('coupon_code', '')));

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
        if (!in_array($paymentMethod, ['cod', 'online', 'wallet'], true)) {
            $errors[] = 'Phương thức thanh toán không hợp lệ.';
        }

        if (!empty($errors)) {
            $this->setFlash('errors', $errors);
            $this->setFlash('old', ['receiver_name' => $receiverName, 'receiver_phone' => $receiverPhone, 'shipping_address' => $shippingAddress, 'note' => $note, 'payment_method' => $paymentMethod, 'coupon_code' => $couponCode]);
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
            $paymentMethod,
            $couponCode
        );

        if ($result['success']) {
            // Xóa giỏ hàng sau khi đặt thành công
            $_SESSION['cart'] = [];

            $this->setFlash('success', 'Đặt hàng thành công! Mã đơn: ' . $result['order_code']);
            $this->redirect('/orders/' . $result['order_id']);
        } else {
            $this->setFlash('error', $result['message'] ?? 'Đặt hàng thất bại, vui lòng thử lại.');
            $this->setFlash('old', ['receiver_name' => $receiverName, 'receiver_phone' => $receiverPhone, 'shipping_address' => $shippingAddress, 'note' => $note, 'payment_method' => $paymentMethod, 'coupon_code' => $couponCode]);
            $this->redirect('/checkout');
        }
    }

    /** POST (AJAX) - Xem trước tiền giảm của mã giảm giá cho giỏ hàng hiện tại. */
    public function couponPreview(): void
    {
        $this->requireLogin();
        $code = trim((string) $this->getPost('coupon_code', ''));
        if ($code === '' || empty($_SESSION['cart'])) {
            $this->renderJson(['ok' => false, 'message' => 'Vui lòng nhập mã giảm giá.'], 422);
            return;
        }
        $r = $this->orderModel->previewCoupon($_SESSION['cart'], $code);
        $this->renderJson($r + ['ok' => $r['error'] === null, 'message' => $r['error'] ?? 'Đã áp dụng mã, giảm ' . number_format($r['discount'], 0, ',', '.') . '₫.'], $r['error'] === null ? 200 : 422);
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

        $st = $this->pdo->prepare('SELECT * FROM order_returns WHERE order_id = ?');
        $st->execute([$id]);
        $return = $st->fetch() ?: null;

        $this->render('orders/detail', compact('order', 'return'));
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

        // Đơn đã giao cho đơn vị vận chuyển thì không hủy được nữa
        if (!in_array($order['status'], OrderModel::CUSTOMER_CANCELLABLE, true)) {
            $this->setFlash('error', 'Đơn đã giao cho đơn vị vận chuyển nên không thể hủy.');
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

    /** POST - Khách bấm "Đã nhận hàng" (chỉ khi shipper đang giao). */
    public function received(int $id): void
    {
        $this->requireLogin();
        $ok = $this->orderModel->confirmReceived($id, (int) $_SESSION['user_id']);
        $this->setFlash($ok ? 'success' : 'error', $ok
            ? 'Cảm ơn bạn! Hãy đánh giá sản phẩm. Bạn có thể yêu cầu trả hàng trong ' . OrderModel::RETURN_DAYS . ' ngày.'
            : 'Chỉ xác nhận được khi đơn đang được shipper giao.');
        $this->redirect('/orders/' . $id);
    }

    /** POST - Khách gửi yêu cầu trả hàng: lý do (chọn sẵn) + mô tả + ảnh minh chứng + cách hoàn tiền. */
    public function requestReturn(int $id): void
    {
        $this->requireLogin();
        $reason = (string) $this->getPost('reason', '');
        $desc   = (string) $this->getPost('description', '');
        $method = (string) $this->getPost('refund_method', 'wallet');
        $bank   = (string) $this->getPost('bank_info', '');

        $err = null;
        if (!in_array($reason, OrderModel::RETURN_REASONS, true)) $err = 'Vui lòng chọn lý do trả hàng.';
        elseif (mb_strlen($desc) < 10) $err = 'Vui lòng mô tả rõ tình trạng sản phẩm (ít nhất 10 ký tự).';
        elseif (!in_array($method, ['wallet', 'bank'], true)) $err = 'Cách hoàn tiền không hợp lệ.';
        elseif ($method === 'bank' && mb_strlen($bank) < 8) $err = 'Vui lòng nhập ngân hàng, số tài khoản và tên chủ tài khoản.';

        $evidence = null;
        $f = $_FILES['evidence'] ?? null;
        if (!$err) {
            if (!$f || $f['error'] !== UPLOAD_ERR_OK) $err = 'Vui lòng tải lên ảnh minh chứng.';
            elseif ($f['size'] > 5 * 1024 * 1024) $err = 'Ảnh minh chứng tối đa 5MB.';
            else {
                $ext = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'][(new finfo(FILEINFO_MIME_TYPE))->file($f['tmp_name'])] ?? null;
                if (!$ext) $err = 'Ảnh minh chứng phải là JPG, PNG hoặc WEBP.';
                else {
                    $dir = dirname(__DIR__, 2) . '/public/uploads/returns';
                    if (!is_dir($dir)) mkdir($dir, 0755, true);
                    $name = bin2hex(random_bytes(12)) . '.' . $ext;
                    if (move_uploaded_file($f['tmp_name'], "$dir/$name")) $evidence = "/uploads/returns/$name";
                    else $err = 'Không lưu được ảnh, vui lòng thử lại.';
                }
            }
        }

        if (!$err && !$this->orderModel->requestReturn($id, (int) $_SESSION['user_id'], [
            'reason' => $reason, 'description' => $desc, 'evidence_url' => $evidence,
            'refund_method' => $method, 'bank_info' => $method === 'bank' ? $bank : null,
        ])) {
            $err = 'Đơn này không thể yêu cầu trả hàng (đã quá ' . OrderModel::RETURN_DAYS . ' ngày hoặc chưa nhận hàng).';
        }
        $this->setFlash($err ? 'error' : 'success', $err ?? 'Đã gửi yêu cầu trả hàng, shop sẽ xem xét trong 1–2 ngày.');
        $this->redirect('/orders/' . $id);
    }
}
