# Tầng Persistence (JPA)

## Tổng quan

Dự án sử dụng JPA (Java Persistence API) để quản lý persistence layer, cho phép mapping giữa các Java objects và database tables.

## Cấu hình Persistence

File: ejb/src/main/resources/META-INF/persistence.xml

```xml
<persistence-unit name="CosmeticsPU" transaction-type="JTA">
    <jta-data-source>jdbc/cosmetics</jta-data-source>
    <properties>
        <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
        <property name="hibernate.show_sql" value="true"/>
        <property name="hibernate.format_sql" value="true"/>
    </properties>
</persistence-unit>
```

## Entity Classes

### 1. User Entity

```java
@Entity
@Table(name = "users")
public class User implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @OneToMany(mappedBy = "user")
    private List<Order> orders;

    // Các trường khác và getter/setter
}
```

### 2. Product Entity

```java
@Entity
@Table(name = "products")
public class Product implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @OneToMany(mappedBy = "product")
    private List<Review> reviews;

    // Các trường khác và getter/setter
}
```

## Relationships

### One-to-Many

```java
// Trong Order Entity
@OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
private List<OrderItem> orderItems;

// Trong OrderItem Entity
@ManyToOne
@JoinColumn(name = "order_id")
private Order order;
```

### Many-to-Many

```java
// Nếu cần thiết cho tính năng Wishlist
@ManyToMany
@JoinTable(
    name = "user_wishlist",
    joinColumns = @JoinColumn(name = "user_id"),
    inverseJoinColumns = @JoinColumn(name = "product_id")
)
private List<Product> wishlist;
```

## Entity Manager

```java
@PersistenceContext
private EntityManager em;

// Create
public void save(Product product) {
    em.persist(product);
}

// Read
public Product find(Long id) {
    return em.find(Product.class, id);
}

// Update
public void update(Product product) {
    em.merge(product);
}

// Delete
public void delete(Long id) {
    Product product = em.find(Product.class, id);
    if (product != null) {
        em.remove(product);
    }
}
```

## JPQL Queries

```java
// Named Query
@NamedQuery(
    name = "Product.findByCategory",
    query = "SELECT p FROM Product p WHERE p.category = :category"
)

// Sử dụng Named Query
public List<Product> findByCategory(String category) {
    return em.createNamedQuery("Product.findByCategory", Product.class)
             .setParameter("category", category)
             .getResultList();
}

// Dynamic Query
public List<Product> searchProducts(String keyword) {
    return em.createQuery(
        "SELECT p FROM Product p WHERE p.name LIKE :keyword",
        Product.class)
        .setParameter("keyword", "%" + keyword + "%")
        .getResultList();
}
```

## Criteria API

```java
public List<Product> findProductsByFilters(Map<String, Object> filters) {
    CriteriaBuilder cb = em.getCriteriaBuilder();
    CriteriaQuery<Product> cq = cb.createQuery(Product.class);
    Root<Product> product = cq.from(Product.class);

    List<Predicate> predicates = new ArrayList<>();

    if (filters.containsKey("minPrice")) {
        predicates.add(cb.ge(product.get("price"),
            (Double) filters.get("minPrice")));
    }

    if (filters.containsKey("maxPrice")) {
        predicates.add(cb.le(product.get("price"),
            (Double) filters.get("maxPrice")));
    }

    cq.where(predicates.toArray(new Predicate[0]));
    return em.createQuery(cq).getResultList();
}
```

## Lazy Loading & Fetch Types

```java
// Lazy Loading (mặc định cho @OneToMany và @ManyToMany)
@OneToMany(mappedBy = "product", fetch = FetchType.LAZY)
private List<Review> reviews;

// Eager Loading
@ManyToOne(fetch = FetchType.EAGER)
private Product product;
```

## Cache

```java
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Entity
public class Product {
    // Entity implementation
}
```

## Optimistic Locking

```java
@Entity
public class Product {
    @Version
    private Long version;

    // Các trường khác
}
```

## Best Practices

1. Sử dụng các annotations JPA thay vì XML configuration
2. Implement equals() và hashCode() cho entities
3. Sử dụng proper fetch types để tối ưu performance
4. Implement proper cascade types
5. Sử dụng batch operations cho large datasets
6. Proper exception handling trong persistence layer
7. Sử dụng connection pooling
8. Implement proper indexing trong database
