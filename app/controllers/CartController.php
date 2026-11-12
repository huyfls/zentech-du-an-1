<?php
/**
 * CartController.php
 * Quản lý giỏ hàng qua PHP Session
 *
 * Cấu trúc $_SESSION['cart']:
 * [
 *   variant_id => [
 *     'variant_id'   => int,
 *     'product_name' => string,
 *     'variant_info' => string,   // VD: "Đen / 128GB"
 *     'price'        => float,    // sale_price ưu tiên, fallback price
 *     'image'        => string,
 *     'quantity'     => int,
 *     'stock_qty'    => int,
 *   ]
 * ]
 */
class CartController extends BaseController
{
    private ProductModel $productModel;

    public function __construct()
    {
        parent::__construct();
        $this->productModel = new ProductModel($this->pdo);

        // Khởi tạo session cart nếu chưa có
        if (!isset($_SESSION['cart'])) {
            $_SESSION['cart'] = [];
        }
    }

    // =========================================================
    // PUBLIC METHODS
    // =========================================================

    /**
     * Hiển thị trang giỏ hàng + tính subtotal
     */
    public function index(): void
    {
        $summary = $this->getCartSummary();

        $this->render('cart/index', [
            'cartItems' => $_SESSION['cart'],
            'subtotal'  => $summary['subtotal'],
            'itemCount' => $summary['count'],
        ]);
    }

    /**
     * POST - Thêm sản phẩm vào giỏ hàng
     * Kiểm tra tồn kho từ DB trước khi thêm
     */
    public function add(): void
    {
        $this->requirePost();

        $variantId = (int) $this->getPost('variant_id', 0);
        $qty       = (int) $this->getPost('quantity', 1);

        if ($variantId <= 0 || $qty <= 0) {
            $this->renderJson(['success' => false, 'message' => 'Dữ liệu không hợp lệ.']);
            return;
        }

        // Lấy thông tin variant từ DB (kiểm tra tồn kho thực tế)
        $variant = $this->productModel->getVariantById($variantId);

        if (!$variant) {
            $this->renderJson(['success' => false, 'message' => 'Sản phẩm không tồn tại.']);
            return;
        }

        if ($variant['stock_qty'] <= 0) {
            $this->renderJson(['success' => false, 'message' => 'Sản phẩm đã hết hàng.']);
            return;
        }

        // Tính số lượng hiện có trong giỏ
        $currentQty = $_SESSION['cart'][$variantId]['quantity'] ?? 0;
        $newQty     = $currentQty + $qty;

        // Giới hạn không vượt quá tồn kho
        if ($newQty > $variant['stock_qty']) {
            $newQty = $variant['stock_qty'];
        }

        // Giá ưu tiên sale_price, nếu không có thì dùng price gốc
        $price = !empty($variant['sale_price']) && $variant['sale_price'] > 0
            ? (float) $variant['sale_price']
            : (float) $variant['price'];

        // Ghép chuỗi thông tin variant: "Đen / 128GB"
        $variantParts = array_filter([
            $variant['color'] ?? '',
            $variant['version_spec'] ?? '',
        ]);
        $variantInfo = implode(' / ', $variantParts);

        // Cập nhật session cart
        $_SESSION['cart'][$variantId] = [
            'variant_id'   => $variantId,
            'product_name' => $variant['product_name'],
            'variant_info' => $variantInfo,
            'price'        => $price,
            'image'        => $variant['image_url'] ?? '',
            'quantity'     => $newQty,
            'stock_qty'    => (int) $variant['stock_qty'],
        ];

        $summary = $this->getCartSummary();

        $this->renderJson([
            'success'  => true,
            'message'  => 'Đã thêm vào giỏ hàng!',
            'count'    => $summary['count'],
            'subtotal' => $summary['subtotal'],
        ]);
    }

    /**
     * POST - Cập nhật số lượng sản phẩm trong giỏ
     * Giới hạn số lượng không vượt tồn kho
     */
    public function update(): void
    {
        $this->requirePost();

        $variantId = (int) $this->getPost('variant_id', 0);
        $qty       = (int) $this->getPost('quantity', 1);

        if ($variantId <= 0) {
            $this->renderJson(['success' => false, 'message' => 'Dữ liệu không hợp lệ.']);
            return;
        }

        if (!isset($_SESSION['cart'][$variantId])) {
            $this->renderJson(['success' => false, 'message' => 'Sản phẩm không có trong giỏ.']);
            return;
        }

        if ($qty <= 0) {
            // Nếu số lượng <= 0 thì xóa khỏi giỏ
            unset($_SESSION['cart'][$variantId]);
        } else {
            // Giới hạn theo tồn kho lưu trong session
            $stockLimit = $_SESSION['cart'][$variantId]['stock_qty'];

            // Xác minh lại với DB để tránh race condition
            $variant = $this->productModel->getVariantById($variantId);
            if ($variant) {
                $stockLimit = (int) $variant['stock_qty'];
                // Cập nhật lại stock_qty trong session
                $_SESSION['cart'][$variantId]['stock_qty'] = $stockLimit;
            }

            $_SESSION['cart'][$variantId]['quantity'] = min($qty, $stockLimit);
        }

        $summary = $this->getCartSummary();

        $this->renderJson([
            'success'  => true,
            'count'    => $summary['count'],
            'subtotal' => $summary['subtotal'],
            'quantity' => $_SESSION['cart'][$variantId]['quantity'] ?? 0,
        ]);
    }

    /**
     * POST - Xóa một sản phẩm khỏi giỏ hàng
     */
    public function remove(): void
    {
        $this->requirePost();

        $variantId = (int) $this->getPost('variant_id', 0);

        if (isset($_SESSION['cart'][$variantId])) {
            unset($_SESSION['cart'][$variantId]);
        }

        $summary = $this->getCartSummary();

        $this->renderJson([
            'success'  => true,
            'message'  => 'Đã xóa sản phẩm khỏi giỏ hàng.',
            'count'    => $summary['count'],
            'subtotal' => $summary['subtotal'],
        ]);
    }

    /**
     * Xóa toàn bộ giỏ hàng
     */
    public function clear(): void
    {
        $_SESSION['cart'] = [];

        // Nếu là AJAX request thì trả JSON, ngược lại redirect
        if ($this->isAjax()) {
            $this->renderJson(['success' => true, 'message' => 'Đã xóa toàn bộ giỏ hàng.']);
        } else {
            $this->redirect('/cart');
        }
    }

    /**
     * Trả về số lượng items trong giỏ hàng (cho badge trên header)
     */
    public function getCount(): void
    {
        $summary = $this->getCartSummary();
        $this->renderJson(['count' => $summary['count']]);
    }

    // =========================================================
    // PRIVATE HELPERS
    // =========================================================

    /**
     * Tính tổng số lượng và subtotal của giỏ hàng
     *
     * @return array ['count' => int, 'subtotal' => float]
     */
    private function getCartSummary(): array
    {
        $count    = 0;
        $subtotal = 0.0;

        foreach ($_SESSION['cart'] as $item) {
            $count    += (int) $item['quantity'];
            $subtotal += (float) $item['price'] * (int) $item['quantity'];
        }

        return [
            'count'    => $count,
            'subtotal' => $subtotal,
        ];
    }

    // =========================================================
    // HELPER METHODS (gọi từ BaseController hoặc tự implement)
    // =========================================================

    /**
     * Kiểm tra request có phải AJAX không
     */
    protected function isAjax(): bool
    {
        return !empty($_SERVER['HTTP_X_REQUESTED_WITH'])
            && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest';
    }
}
