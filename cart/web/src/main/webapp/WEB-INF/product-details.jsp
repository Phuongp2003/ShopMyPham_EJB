<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <div class="row">
        <!-- Product Image -->
        <div class="col-md-5">
            <img src="${pageContext.request.contextPath}/images/${product.image}" 
                 class="img-fluid" alt="${product.name}">
        </div>
        
        <!-- Product Details -->
        <div class="col-md-7">
            <h1 class="mb-3">${product.name}</h1>
            
            <!-- Rating -->
            <div class="mb-3">
                <div class="star-rating h4">
                    <c:forEach begin="1" end="5" var="i">
                        <i class="fas fa-star${i <= product.averageRating ? '' : '-o'}"></i>
                    </c:forEach>
                    <span class="ms-2">${product.averageRating}/5 (${product.totalReviews} đánh giá)</span>
                </div>
            </div>
            
            <!-- Price -->
            <div class="h3 text-danger mb-4">
                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
            </div>
            
            <!-- Stock Status -->
            <p class="mb-4">
                Tình trạng: 
                <span class="badge ${product.stock > 0 ? 'bg-success' : 'bg-danger'}">
                    ${product.stock > 0 ? 'Còn hàng' : 'Hết hàng'}
                </span>
                <c:if test="${product.stock > 0}">
                    <span class="ms-2">(${product.stock} sản phẩm)</span>
                </c:if>
            </p>
            
            <!-- Description -->
            <div class="mb-4">
                <h5>Mô tả sản phẩm:</h5>
                <p class="text-justify">${product.description}</p>
            </div>
            
            <!-- Add to Cart Form -->
            <form class="mb-4" onsubmit="event.preventDefault(); addToCart('${product.id}');">
                <div class="row align-items-center">
                    <div class="col-auto">
                        <label class="form-label">Số lượng:</label>
                        <input type="number" class="form-control" id="quantity-${product.id}" 
                               value="1" min="1" max="${product.stock}" style="width: 100px;">
                    </div>
                    <div class="col">
                        <button type="submit" class="btn btn-primary btn-lg"
                                ${product.stock > 0 ? '' : 'disabled'}>
                            <i class="fas fa-cart-plus"></i> 
                            ${product.stock > 0 ? 'Thêm vào giỏ' : 'Hết hàng'}
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Reviews Section -->
    <div class="row mt-5">
        <div class="col-12">
            <h3 class="mb-4">Đánh giá sản phẩm</h3>
            
            <!-- Add Review Form (if user can review) -->
            <c:if test="${sessionScope.user != null && canReview}">
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Viết đánh giá của bạn</h5>
                        <form action="${pageContext.request.contextPath}/review/add" method="post">
                            <input type="hidden" name="productId" value="${product.id}">
                            <input type="hidden" name="orderId" value="${orderId}">
                            
                            <!-- Rating Stars -->
                            <div class="mb-3">
                                <label class="form-label">Đánh giá:</label>
                                <div class="star-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <input type="radio" id="star${i}" name="rating" value="${i}" required>
                                        <label for="star${i}"><i class="far fa-star"></i></label>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <!-- Comment -->
                            <div class="mb-3">
                                <label for="comment" class="form-label">Nhận xét:</label>
                                <textarea class="form-control" id="comment" name="comment" rows="3"></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                        </form>
                    </div>
                </div>
            </c:if>
            
            <!-- Review List -->
            <c:choose>
                <c:when test="${not empty reviews}">
                    <div class="row row-cols-1 row-cols-md-2 g-4">
                        <c:forEach items="${reviews}" var="review">
                            <div class="col">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <h6 class="card-subtitle text-muted">${review.user.fullName}</h6>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${review.reviewDate}" 
                                                              pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </div>
                                        <div class="star-rating mb-2">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star${i <= review.rating ? '' : '-o'}"></i>
                                            </c:forEach>
                                        </div>
                                        <p class="card-text">${review.comment}</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<style>
.star-rating {
    display: inline-flex;
    flex-direction: row-reverse;
}

.star-rating input {
    display: none;
}

.star-rating label {
    cursor: pointer;
    font-size: 1.5rem;
    padding: 0 0.1em;
    color: #ddd;
}

.star-rating input:checked ~ label,
.star-rating label:hover,
.star-rating label:hover ~ label {
    color: #ffc107;
}
</style>

<script>
document.querySelectorAll('.star-rating label').forEach(label => {
    label.addEventListener('mouseover', function() {
        this.innerHTML = '<i class="fas fa-star"></i>';
    });
    
    label.addEventListener('mouseout', function() {
        if (!this.control.checked) {
            this.innerHTML = '<i class="far fa-star"></i>';
        }
    });
    
    label.addEventListener('click', function() {
        this.innerHTML = '<i class="fas fa-star"></i>';
    });
});
</script>

<%@ include file="/WEB-INF/common/footer.jsp" %>
