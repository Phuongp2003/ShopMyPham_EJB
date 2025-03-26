# Kiến trúc EJB (Enterprise JavaBeans)

## Tổng quan

EJB là một phần của chuẩn Java EE, cung cấp framework để xây dựng các ứng dụng phân tán, có khả năng mở rộng và bảo mật.

## Các loại EJB sử dụng trong dự án

### 1. Entity Beans (JPA Entities)

-   Đại diện cho dữ liệu trong database
-   Được đánh dấu với @Entity
-   Vị trí: ejb/src/main/java/.../entity/
-   Ví dụ:
    -   UserEntity: Thông tin người dùng
    -   ProductEntity: Thông tin sản phẩm
    -   OrderEntity: Thông tin đơn hàng
    -   CartItemEntity: Mục trong giỏ hàng
    -   ReviewEntity: Đánh giá sản phẩm

### 2. Session Beans

#### Stateless Session Beans

-   Xử lý business logic
-   Không lưu trữ trạng thái
-   Đánh dấu với @Stateless
-   Vị trí: ejb/src/main/java/.../session/
-   Ví dụ:
    -   ProductService: Quản lý sản phẩm
    -   OrderService: Xử lý đơn hàng
    -   UserService: Quản lý người dùng
    -   CartService: Xử lý giỏ hàng

#### Stateful Session Beans

-   Lưu trữ trạng thái cho client session
-   Đánh dấu với @Stateful
-   Vị trí: ejb/src/main/java/.../session/
-   Ví dụ:
    -   ShoppingCartBean: Giỏ hàng của người dùng
    -   UserSessionBean: Phiên đăng nhập

### 3. Message-Driven Beans (nếu có)

-   Xử lý tin nhắn bất đồng bộ
-   Đánh dấu với @MessageDriven
-   Có thể được sử dụng cho:
    -   Xử lý email thông báo
    -   Thông báo đơn hàng
    -   Xử lý hàng đợi đơn hàng

## Dependency Injection

```java
@EJB
private ProductService productService;

@PersistenceContext
private EntityManager em;

@Resource
private UserTransaction userTransaction;
```

## Transaction Management

-   Sử dụng @TransactionManagement
-   Container-managed transactions (CMT)
-   Các annotation:
    -   @TransactionAttribute(TransactionAttributeType.REQUIRED)
    -   @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    -   @TransactionAttribute(TransactionAttributeType.SUPPORTS)

## Security

-   Sử dụng annotation bảo mật:
    -   @RolesAllowed({"admin"})
    -   @PermitAll
    -   @DenyAll
-   Tích hợp với JAAS (Java Authentication and Authorization Service)

## Lifecycle Callbacks

```java
@PostConstruct
public void init() {
    // Khởi tạo resources
}

@PreDestroy
public void cleanup() {
    // Giải phóng resources
}
```

## Interceptors

-   Xử lý cross-cutting concerns
-   Logging
-   Auditing
-   Performance monitoring

## Exception Handling

```java
@ApplicationException(rollback=true)
public class OrderException extends Exception {
    // Custom exception
}
```

## Best Practices

1. Sử dụng interface cho Session Beans
2. Tránh business logic trong Entity Beans
3. Sử dụng proper transaction attributes
4. Implement proper exception handling
5. Tối ưu hóa performance với:
    - Pool sizing
    - Caching
    - Lazy loading
6. Logging đầy đủ cho debugging
