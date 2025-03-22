-- Create database with proper character encoding
CREATE DATABASE IF NOT EXISTS cosmetics
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE cosmetics;

-- Drop tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create products table
CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image VARCHAR(255) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    average_rating DOUBLE NOT NULL DEFAULT 0,
    total_reviews INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create cart_items table
CREATE TABLE cart_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create orders table
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    is_reviewed BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create order_items table
CREATE TABLE order_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create reviews table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert admin user (password: admin123)
INSERT INTO users (username, password, full_name, email, phone, address, is_admin) VALUES
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Administrator', 'admin@example.com', '0123456789', 'Admin Address', TRUE);

-- Insert sample products with Vietnamese characters
INSERT INTO products (name, description, price, image, stock) VALUES
('Son Dưỡng Môi', 'Son dưỡng môi giúp làm mềm và phục hồi môi khô', 150000, 'lipbalm.jpg', 50),
('Kem Chống Nắng', 'Kem chống nắng SPF 50+ bảo vệ da khỏi tia UV', 350000, 'sunscreen.jpg', 30),
('Sữa Rửa Mặt', 'Sữa rửa mặt dịu nhẹ làm sạch sâu', 200000, 'cleanser.jpg', 40),
('Nước Hoa', 'Nước hoa với hương thơm quyến rũ và bền lâu', 1200000, 'perfume.jpg', 20),
('Phấn Trang Điểm', 'Phấn trang điểm kiềm dầu lâu trôi', 450000, 'powder.jpg', 25),
('Mascara', 'Mascara chống nước, không lem', 280000, 'mascara.jpg', 35),
('Serum Vitamin C', 'Serum làm sáng da và chống lão hóa', 550000, 'serum.jpg', 30),
('Kem Dưỡng Da', 'Kem dưỡng ẩm chuyên sâu', 400000, 'moisturizer.jpg', 40),
('Nước Tẩy Trang', 'Nước tẩy trang làm sạch sâu, không gây kích ứng', 250000, 'makeup-remover.jpg', 45);
