# Web Module

## Tổng quan

Module web chứa các thành phần giao diện người dùng và controllers của ứng dụng, được đóng gói thành file WAR.

## Cấu trúc thư mục

```
web/
├── src/
│   ├── main/
│   │   ├── java/        # Servlets, Filters, và các class Java khác
│   │   └── webapp/      # JSP pages, resources và WEB-INF
│   └── test/            # Unit tests
└── pom.xml             # Maven configuration
```

## Servlets & Controllers

### 1. Front Controller

```java
@WebServlet("/")
public class FrontController extends HttpServlet {
    @EJB
    private ProductService productService;

    protected void doGet(HttpServletRequest request,
                        HttpServletResponse response) {
        // Xử lý routing và điều hướng
    }
}
```

### 2. Authentication

```java
@WebServlet("/auth/*")
public class AuthController extends HttpServlet {
    @EJB
    private UserService userService;

    // Xử lý đăng nhập/đăng ký
}
```

## Filters

### 1. Authentication Filter

```java
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    public void doFilter(ServletRequest request,
                        ServletResponse response,
                        FilterChain chain) {
        // Kiểm tra authentication
    }
}
```

### 2. Character Encoding Filter

```java
@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {
    public void doFilter(ServletRequest request,
                        ServletResponse response,
                        FilterChain chain) {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        chain.doFilter(request, response);
    }
}
```

## JSP Pages

### 1. Cấu trúc thư mục JSP

```
webapp/
├── WEB-INF/
│   ├── web.xml
│   └── jsp/
│       ├── common/     # Header, footer, navigation
│       ├── product/    # Product listing, details
│       ├── cart/       # Shopping cart
│       ├── user/       # User profile, orders
│       └── admin/      # Admin dashboard
└── resources/
    ├── css/
    ├── js/
    └── images/
```

### 2. Common JSP Components

```jsp
<!-- Header -->
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>

<!-- Navigation -->
<jsp:include page="/WEB-INF/jsp/common/nav.jsp"/>

<!-- Footer -->
<jsp:include page="/WEB-INF/jsp/common/footer.jsp"/>
```

### 3. JSTL Usage

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:forEach items="${products}" var="product">
    <div class="product">
        <h3>${product.name}</h3>
        <fmt:formatNumber value="${product.price}"
                         type="currency"/>
    </div>
</c:forEach>
```

## Security Configuration

```xml
<!-- web.xml -->
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Admin Area</web-resource-name>
        <url-pattern>/admin/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
        <role-name>admin</role-name>
    </auth-constraint>
</security-constraint>
```

## Session Management

```java
// Trong Servlet
HttpSession session = request.getSession();
session.setAttribute("cart", cart);

// Trong JSP
${sessionScope.cart}
```

## Error Handling

```xml
<!-- web.xml -->
<error-page>
    <error-code>404</error-code>
    <location>/WEB-INF/jsp/error/404.jsp</location>
</error-page>
```

## Resources

### 1. Static Resources

```xml
<!-- web.xml -->
<servlet-mapping>
    <servlet-name>default</servlet-name>
    <url-pattern>/resources/*</url-pattern>
</servlet-mapping>
```

### 2. Resource References

```xml
<!-- web.xml -->
<resource-ref>
    <res-ref-name>jdbc/cosmetics</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
</resource-ref>
```

## Best Practices

1. Sử dụng MVC pattern

    - Servlets làm controllers
    - EJBs làm models
    - JSPs làm views

2. Security

    - Input validation
    - XSS prevention
    - CSRF protection
    - Secure session management

3. Performance

    - Caching static resources
    - Gzip compression
    - Minification của CSS/JS
    - Lazy loading cho images

4. Maintainability

    - Consistent naming conventions
    - Modular JSP components
    - Clean separation of concerns
    - Proper error handling

5. SEO & Accessibility
    - Semantic HTML
    - Proper meta tags
    - Clean URLs
    - ARIA labels
