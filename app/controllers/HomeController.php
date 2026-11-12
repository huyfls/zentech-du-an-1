<?php
/**
 * HomeController.php
 * Xử lý trang chủ và tìm kiếm sản phẩm
 */
class HomeController extends BaseController
{
    private ProductModel  $productModel;
    private CategoryModel $categoryModel;

    public function __construct()
    {
        parent::__construct();
        $this->productModel  = new ProductModel($this->pdo);
        $this->categoryModel = new CategoryModel($this->pdo);
    }

    /**
     * Trang chủ: hiển thị sản phẩm nổi bật, sản phẩm mới, danh mục
     */
    public function index(): void
    {
        // Lấy sản phẩm nổi bật (is_featured=1) kèm MIN(price) từ variants
        $featuredProducts = $this->productModel->getFeatured(8);

        // Lấy sản phẩm mới nhất
        $newProducts = $this->productModel->getNewArrivals(8);

        // Danh mục cho menu/banner
        $categories = $this->categoryModel->getAll();

        $this->render('home/index', compact('featuredProducts', 'newProducts', 'categories'));
    }

    /**
     * Tìm kiếm AJAX - trả về JSON cho live-search
     */
    public function search(): void
    {
        $keyword = $this->getGet('q', '');
        $results = !empty($keyword) ? $this->productModel->searchProducts($keyword) : [];
        $this->renderJson(['results' => $results]);
    }

    /**
     * Trang Về chúng tôi (/ve-chung-toi, /about)
     */
    public function about(): void
    {
        $this->render('home/about', [
            'pageTitle' => 'Về ZenTech'
        ]);
    }
}
