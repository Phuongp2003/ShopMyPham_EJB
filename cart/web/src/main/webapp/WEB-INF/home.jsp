<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Banner -->
<div class="banner" style="background-image: url('${pageContext.request.contextPath}/static/images/banner.jpg');">
    <div class="container h-100" style="background-color: rgba(0, 0, 0, 0.5);">
        <div class="row h-100 align-items-center">
            <div class="col-12 text-center">
                <h1 class="display-4 text-white fw-bold">Shop Mỹ Phẩm</h1>
                <p class="lead text-white">Chất lượng làm nên thương hiệu</p>
            </div>
        </div>
    </div>
</div>

<!-- Featured Products -->
<div class="container">
    <h2 class="mb-4">Sản Phẩm Nổi Bật</h2>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach items="${products}" var="product">
            <div class="col">
                <div class="card product-card h-100">
                    <img src="${product.image}" 
                         class="card-img-top product-image" alt="${product.name}">
                    <div class="card-body">
                        <h5 class="card-title">${product.name}</h5>
                        <p class="card-text text-truncate">${product.description}</p>
                        
                        <!-- Rating -->
                        <div class="mb-2">
                            <div class="star-rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star${i <= product.averageRating ? '' : '-o'}"></i>
                                </c:forEach>
                                <span class="ms-1">(${product.totalReviews})</span>
                            </div>
                        </div>
                        
                        <!-- Price -->
                        <p class="card-text">
                            <strong>Giá: </strong>
                            <span class="text-danger fw-bold">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                            </span>
                        </p>
                        
                        <!-- Add to Cart Form -->
                        <div class="d-flex align-items-center">
                            <input type="number" class="form-control me-2" 
                                   id="quantity-${product.id}" value="1" min="1" 
                                   style="width: 80px;">
                            <button onclick="addToCart('${product.id}')" 
                                    class="btn btn-primary flex-grow-1"
                                    ${product.stock > 0 ? '' : 'disabled'}>
                                <i class="fas fa-cart-plus"></i> 
                                ${product.stock > 0 ? 'Thêm vào giỏ' : 'Hết hàng'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    
    <!-- View All Products Link -->
    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
            Xem tất cả sản phẩm
        </a>
    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
