<?php
/**
 * ZenTech UserModel
 * Quản lý tài khoản, mật khẩu băm bcrypt và phân quyền
 */
class UserModel extends BaseModel
{
    /**
     * Tìm user theo email
     */
    public function findByEmail(string $email): ?array
    {
        $sql = "
            SELECT u.*, r.name AS role_name
            FROM users u
            LEFT JOIN roles r ON r.id = u.role_id
            WHERE u.email = ? LIMIT 1
        ";
        return $this->rawQueryOne($sql, [$email]);
    }

    /**
     * Tìm user theo ID
     */
    public function findUserById(int $id): ?array
    {
        $sql = "
            SELECT u.*, r.name AS role_name
            FROM users u
            LEFT JOIN roles r ON r.id = u.role_id
            WHERE u.id = ? LIMIT 1
        ";
        return $this->rawQueryOne($sql, [$id]);
    }

    /**
     * Đăng ký tài khoản người dùng mới (Role mặc định 2: customer)
     */
    public function register(string $fullName, string $email, string $password, ?string $phone = null): int
    {
        $hash = password_hash($password, PASSWORD_BCRYPT);
        $sql = "
            INSERT INTO users (role_id, full_name, email, phone, password_hash, is_active, created_at)
            VALUES (2, :name, :email, :phone, :hash, 1, NOW())
        ";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            ':name'  => $fullName,
            ':email' => $email,
            ':phone' => $phone,
            ':hash'  => $hash,
        ]);
        return (int) $this->pdo->lastInsertId();
    }

    /**
     * Xác thực mật khẩu
     */
    public function verifyPassword(string $password, string $hash): bool
    {
        return password_verify($password, $hash);
    }
}
