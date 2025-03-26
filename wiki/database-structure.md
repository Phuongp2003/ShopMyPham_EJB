# Cấu trúc Database Shop Mỹ Phẩm

## Thông tin chung

-   Tên database: cosmetics
-   Character set: utf8mb4
-   Collation: utf8mb4_unicode_ci

## Các bảng trong CSDL

### 1. users - Quản lý người dùng

-   Lưu thông tin tài khoản và thông tin cá nhân người dùng
-   Phân biệt admin và user thường qua trường is_admin

```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,       # Stored as SHA-256 hash
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE
)
```

### 2. products - Quản lý sản phẩm

-   Lưu thông tin chi tiết về sản phẩm mỹ phẩm
-   Có tích hợp hệ thống đánh giá (rating)

```sql
CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image VARCHAR(255) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    average_rating DOUBLE NOT NULL DEFAULT 0,
    total_reviews INT NOT NULL DEFAULT 0
)
```

### 3. cart_items - Giỏ hàng

-   Lưu các sản phẩm trong giỏ hàng của người dùng
-   Liên kết với users và products qua foreign key

```sql
CREATE TABLE cart_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
)
```

### 4. orders - Đơn hàng

-   Lưu thông tin về đơn hàng
-   Tracking trạng thái đơn hàng và đánh giá

```sql
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    is_reviewed BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id)
)
```

### 5. order_items - Chi tiết đơn hàng

-   Lưu thông tin chi tiết các sản phẩm trong đơn hàng
-   Lưu giá tại thời điểm đặt hàng

```sql
CREATE TABLE order_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
)
```

### 6. reviews - Đánh giá sản phẩm

-   Lưu đánh giá của người dùng về sản phẩm
-   Liên kết với đơn hàng để đảm bảo chỉ đánh giá sau khi mua

```sql
CREATE TABLE reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
)
```

## Mối quan hệ giữa các bảng

1. users -> cart_items: 1-n (một user có nhiều cart items)
2. users -> orders: 1-n (một user có nhiều orders)
3. users -> reviews: 1-n (một user có nhiều reviews)
4. products -> cart_items: 1-n (một product có trong nhiều cart items)
5. products -> order_items: 1-n (một product có trong nhiều order items)
6. products -> reviews: 1-n (một product có nhiều reviews)
7. orders -> order_items: 1-n (một order có nhiều order items)
8. orders -> reviews: 1-n (một order có thể có nhiều reviews - cho từng sản phẩm)
