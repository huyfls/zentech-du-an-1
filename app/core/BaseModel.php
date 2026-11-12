<?php
/**
 * ZenTech — BaseModel
 * Cung cấp các thao tác CRUD tổng quát thông qua PDO.
 * Mọi Model cụ thể đều kế thừa class này.
 */
class BaseModel {

    /** @var PDO Kết nối PDO được inject qua constructor */
    protected PDO $pdo;

    // -------------------------------------------------------------------------
    // Constructor: nhận PDO instance (thường lấy từ Database::getInstance())
    // -------------------------------------------------------------------------
    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    // =========================================================================
    // TRUY VẤN CƠ BẢN
    // =========================================================================

    /**
     * Lấy tất cả bản ghi trong bảng, hỗ trợ điều kiện WHERE, sắp xếp, giới hạn.
     *
     * @param string   $table      Tên bảng
     * @param array    $conditions Mảng điều kiện [column => value] (AND)
     * @param string   $orderBy    Chuỗi ORDER BY, ví dụ 'created_at DESC'
     * @param int|null $limit      Số bản ghi tối đa
     * @param int|null $offset     Vị trí bắt đầu
     * @return array
     */
    public function findAll(
        string $table,
        array  $conditions = [],
        string $orderBy    = 'id DESC',
        ?int   $limit      = null,
        ?int   $offset     = null
    ): array {
        $sql    = "SELECT * FROM `{$table}`";
        $params = [];

        // Xây dựng mệnh đề WHERE từ mảng điều kiện
        if (!empty($conditions)) {
            $clauses = [];
            foreach ($conditions as $col => $val) {
                $clauses[] = "`{$col}` = :{$col}";
                $params[":{$col}"] = $val;
            }
            $sql .= ' WHERE ' . implode(' AND ', $clauses);
        }

        $sql .= " ORDER BY {$orderBy}";

        if ($limit !== null) {
            $sql .= " LIMIT {$limit}";
        }
        if ($offset !== null) {
            $sql .= " OFFSET {$offset}";
        }

        return $this->rawQuery($sql, $params);
    }

    /**
     * Tìm bản ghi theo ID chính.
     *
     * @param string $table Tên bảng
     * @param int    $id    Giá trị ID
     * @return array|null   Null nếu không tìm thấy
     */
    public function findById(string $table, int $id): ?array {
        $sql  = "SELECT * FROM `{$table}` WHERE `id` = :id LIMIT 1";
        $rows = $this->rawQuery($sql, [':id' => $id]);
        return $rows[0] ?? null;
    }

    /**
     * Tìm nhiều bản ghi theo điều kiện WHERE (AND).
     *
     * @param string $table Tên bảng
     * @param array  $where [column => value]
     * @return array
     */
    public function findWhere(string $table, array $where): array {
        if (empty($where)) {
            return $this->findAll($table);
        }

        $clauses = [];
        $params  = [];
        foreach ($where as $col => $val) {
            $clauses[]       = "`{$col}` = :{$col}";
            $params[":{$col}"] = $val;
        }

        $sql = "SELECT * FROM `{$table}` WHERE " . implode(' AND ', $clauses);
        return $this->rawQuery($sql, $params);
    }

    // =========================================================================
    // THÊM / SỬA / XOÁ
    // =========================================================================

    /**
     * Chèn bản ghi mới vào bảng.
     *
     * @param string $table Tên bảng
     * @param array  $data  [column => value]
     * @return int          lastInsertId
     */
    public function insert(string $table, array $data): int {
        $cols     = array_keys($data);
        $colList  = implode('`, `', $cols);
        $binds    = ':' . implode(', :', $cols);

        $sql  = "INSERT INTO `{$table}` (`{$colList}`) VALUES ({$binds})";
        $stmt = $this->pdo->prepare($sql);

        // Bind từng giá trị
        foreach ($data as $col => $val) {
            $stmt->bindValue(":{$col}", $val);
        }

        $stmt->execute();
        return (int) $this->pdo->lastInsertId();
    }

    /**
     * Cập nhật bản ghi theo ID.
     *
     * @param string $table Tên bảng
     * @param int    $id    ID bản ghi
     * @param array  $data  [column => value] — dữ liệu cần cập nhật
     * @return bool
     */
    public function update(string $table, int $id, array $data): bool {
        if (empty($data)) {
            return false;
        }

        $setClauses = [];
        foreach ($data as $col => $val) {
            $setClauses[] = "`{$col}` = :{$col}";
        }
        $data[':id'] = $id;

        $sql  = "UPDATE `{$table}` SET " . implode(', ', $setClauses) . " WHERE `id` = :id";
        $stmt = $this->pdo->prepare($sql);

        foreach ($data as $col => $val) {
            $key = str_starts_with($col, ':') ? $col : ":{$col}";
            $stmt->bindValue($key, $val);
        }

        return $stmt->execute();
    }

    /**
     * Xoá bản ghi theo ID.
     *
     * @param string $table Tên bảng
     * @param int    $id    ID bản ghi
     * @return bool
     */
    public function delete(string $table, int $id): bool {
        $sql  = "DELETE FROM `{$table}` WHERE `id` = :id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->bindValue(':id', $id, PDO::PARAM_INT);
        return $stmt->execute();
    }

    // =========================================================================
    // PHÂN TRANG
    // =========================================================================

    /**
     * Thực thi câu truy vấn có phân trang.
     * Tự động tính tổng bản ghi bằng cách bọc query trong COUNT(*).
     *
     * @param string $sql     Câu SQL gốc (SELECT ... FROM ... WHERE ...)
     * @param array  $params  Tham số bind
     * @param int    $page    Trang hiện tại (bắt đầu từ 1)
     * @param int    $perPage Số bản ghi mỗi trang
     * @return array {
     *     items: array,
     *     total: int,
     *     pages: int,
     *     current_page: int,
     *     per_page: int
     * }
     */
    public function paginate(string $sql, array $params = [], int $page = 1, int $perPage = 12): array {
        $page    = max(1, $page);
        $perPage = max(1, $perPage);

        // Đếm tổng bản ghi
        $countSql  = "SELECT COUNT(*) as total FROM ({$sql}) as _count_query";
        $countRows = $this->rawQuery($countSql, $params);
        $total     = (int) ($countRows[0]['total'] ?? 0);

        // Tính số trang
        $totalPages = $total > 0 ? (int) ceil($total / $perPage) : 1;
        $page       = min($page, $totalPages);
        $offset     = ($page - 1) * $perPage;

        // Lấy dữ liệu trang hiện tại
        $pagedSql = $sql . " LIMIT {$perPage} OFFSET {$offset}";
        $items    = $this->rawQuery($pagedSql, $params);

        return [
            'items'        => $items,
            'total'        => $total,
            'pages'        => $totalPages,
            'total_pages'  => $totalPages,
            'current_page' => $page,
            'per_page'     => $perPage,
        ];
    }

    // =========================================================================
    // TRUY VẤN THÔ
    // =========================================================================

    /**
     * Thực thi câu SQL tuỳ ý và trả về mảng kết quả.
     *
     * @param string $sql    Câu SQL
     * @param array  $params Tham số bind [:key => value hoặc mảng số nguyên 0-indexed]
     * @return array
     */
    public function rawQuery(string $sql, array $params = []): array {
        $stmt = $this->pdo->prepare($sql);

        foreach ($params as $key => $value) {
            $paramKey = is_int($key) ? $key + 1 : $key;
            // Tự động chọn kiểu dữ liệu phù hợp
            $type = match (true) {
                is_int($value)  => PDO::PARAM_INT,
                is_bool($value) => PDO::PARAM_BOOL,
                is_null($value) => PDO::PARAM_NULL,
                default         => PDO::PARAM_STR,
            };
            $stmt->bindValue($paramKey, $value, $type);
        }

        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Thực thi câu SQL tuỳ ý và trả về một bản ghi duy nhất.
     *
     * @param string $sql    Câu SQL
     * @param array  $params Tham số bind
     * @return array|null
     */
    public function rawQueryOne(string $sql, array $params = []): ?array {
        $rows = $this->rawQuery($sql, $params);
        return $rows[0] ?? null;
    }
}
