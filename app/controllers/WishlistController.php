<?php
/**
 * WishlistController — danh sách yêu thích lưu trong session (chưa có bảng DB).
 */
class WishlistController extends BaseController
{
    public function toggle(): void
    {
        $input = json_decode(file_get_contents('php://input'), true);
        $productId = (int) ($input['product_id'] ?? $_POST['product_id'] ?? 0);

        if ($productId <= 0) {
            $this->renderJson(['success' => false, 'message' => 'Dữ liệu không hợp lệ.'], 422);
        }

        $list = $_SESSION['wishlist'] ?? [];
        if (in_array($productId, $list, true)) {
            $list = array_values(array_diff($list, [$productId]));
            $wished = false;
        } else {
            $list[] = $productId;
            $wished = true;
        }
        $_SESSION['wishlist'] = $list;

        $this->renderJson(['success' => true, 'wished' => $wished, 'count' => count($list)]);
    }
}
