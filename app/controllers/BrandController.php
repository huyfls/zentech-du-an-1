<?php
/**
 * ZenTech BrandController
 * Điều hướng trang danh sách Thương hiệu chính hãng và Chi tiết từng Thương hiệu
 */
class BrandController extends BaseController
{
    private BrandModel $brandModel;

    public function __construct()
    {
        parent::__construct();
        $this->brandModel = new BrandModel($this->pdo);
    }

    /**
     * GET - Trang danh sách thương hiệu (/thuong-hieu, /brands)
     */
    public function index(): void
    {
        $brands = $this->brandModel->getAllWithProductCount();
        $totalProducts = array_sum(array_column($brands, 'product_count'));

        $this->render('brands/index', [
            'brands'        => $brands,
            'totalBrands'   => count($brands),
            'totalProducts' => $totalProducts,
            'pageTitle'     => 'Thương hiệu — ZenTech',
        ]);
    }

    /**
     * GET - Trang chi tiết thương hiệu & sản phẩm của hãng (/thuong-hieu/{slug})
     */
    public function detail(string $slug): void
    {
        // Trang riêng từng hãng trước đây trùng với danh sách sản phẩm có lọc theo hãng
        $brand = $this->brandModel->getBySlug($slug);
        $this->redirect($brand ? '/san-pham?brand[]=' . urlencode($brand['slug']) : '/thuong-hieu');
    }
}
