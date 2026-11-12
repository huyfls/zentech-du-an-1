<?php
/**
 * ZenTech ReviewController
 * Khách chỉ đánh giá sản phẩm đã mua và đã nhận hàng, mỗi sản phẩm một lần.
 */
class ReviewController extends BaseController
{
    public function add(): void
    {
        $this->requireLogin();
        $pid     = (int) $this->getPost('product_id', 0);
        $rating  = (int) $this->getPost('rating', 0);
        $title   = mb_substr(trim((string) $this->getPost('title', '')), 0, 200);
        $content = mb_substr(trim((string) $this->getPost('content', '')), 0, 1000);

        $products = new ProductModel($this->pdo);
        $slug = $this->pdo->prepare('SELECT slug FROM products WHERE id = ?');
        $slug->execute([$pid]);
        $slug = $slug->fetchColumn();
        if (!$slug) { $this->redirect('/san-pham'); return; }
        $back = '/san-pham/' . $slug . '#reviews';

        [$state, $orderId] = $products->reviewEligibility((int) $_SESSION['user_id'], $pid);
        if ($state !== 'ok') {
            $this->setFlash('error', $state === 'done' ? 'Bạn đã đánh giá sản phẩm này rồi.' : 'Chỉ khách đã nhận hàng sản phẩm này mới đánh giá được.');
        } elseif ($rating < 1 || $rating > 5 || mb_strlen($content) < 5) {
            $this->setFlash('error', 'Vui lòng chọn số sao và viết nhận xét ít nhất 5 ký tự.');
        } else {
            $this->pdo->prepare('INSERT INTO reviews (product_id, user_id, order_id, rating, title, content, is_approved) VALUES (?, ?, ?, ?, ?, ?, 1)')
                ->execute([$pid, (int) $_SESSION['user_id'], $orderId, $rating, $title ?: null, $content]);
            $this->setFlash('success', 'Cảm ơn bạn đã đánh giá sản phẩm!');
        }
        $this->redirect($back);
    }
}
