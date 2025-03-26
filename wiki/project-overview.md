# Tổng quan về Shop Mỹ Phẩm - EJB Cosmetics Store

## Cấu trúc dự án

```
cart/
├── ejb/                    # Module chứa các thành phần EJB
│   ├── src/main/java/     # Chứa Entity & EJB classes
│   └── pom.xml            # Cấu hình Maven cho module EJB
├── web/                    # Module web application
│   ├── src/main/java/     # Chứa Servlets & Filters
│   ├── src/main/webapp/   # Chứa JSP & resources
│   └── pom.xml            # Cấu hình Maven cho module Web
├── pom.xml                # File cấu hình Maven cha
├── setup.sql              # Script tạo CSDL
└── README.md              # Hướng dẫn cài đặt và sử dụng
```

## Môi trường phát triển

-   JDK 8
-   GlassFish 5 (Application Server)
-   MySQL 8.0 (Database)
-   Maven 3.8+ (Build tool)

## Kiến trúc ứng dụng

-   Mô hình phân lớp sử dụng EJB (Enterprise JavaBeans)
-   Giao diện web sử dụng JSP (JavaServer Pages)
-   Sử dụng MySQL làm CSDL với kết nối JDBC
-   Maven quản lý dependencies và build

## Tính năng chính

-   Quản lý sản phẩm mỹ phẩm
-   Giỏ hàng và đặt hàng
-   Đăng ký/đăng nhập người dùng
-   Xem lịch sử đơn hàng
-   Đánh giá sản phẩm
-   Giao diện quản trị cho admin

## Tài khoản mặc định

-   Admin account:
    -   Username: admin
    -   Password: admin123

## Một số lưu ý

-   Character encoding: UTF-8 cho toàn bộ dự án
-   Database được cấu hình với collation utf8mb4_unicode_ci
-   JNDI resource name: jdbc/cosmetics
-   Connection pool: CosmeticsPool
