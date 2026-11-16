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

        // Ảnh đại diện cho từng ô loại sản phẩm: sản phẩm nổi bật (hoặc mới nhất) của loại đó và các loại con
        $catImages = [];
        foreach ($this->pdo->query("
            SELECT c.id, (SELECT p.thumbnail_url FROM products p JOIN categories pc ON pc.id = p.category_id
                          WHERE p.is_active = 1 AND p.thumbnail_url IS NOT NULL AND p.name NOT LIKE '%iPad%' AND p.name NOT LIKE '%Powerplay%' AND (pc.id = c.id OR pc.parent_id = c.id)
                          ORDER BY p.is_featured DESC, p.id DESC LIMIT 1) AS img
            FROM categories c WHERE c.parent_id IS NULL")->fetchAll() as $r) {
            $catImages[(int) $r['id']] = $r['img'];
        }

        $this->render('home/index', compact('featuredProducts', 'newProducts', 'categories', 'catImages'));
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
