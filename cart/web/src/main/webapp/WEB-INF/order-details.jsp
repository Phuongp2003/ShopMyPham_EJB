<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <div class="row">
        <div class="col-md-8">
            <!-- Order Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Chi tiết đơn hàng #${order.id}</h2>
                <c:choose>
                    <c:when test="${order.status == 'PENDING'}">
                        <span class="badge bg-warning">Chờ xử lý</span>
                    </c:when>
                    <c:when test="${order.status == 'DELIVERING'}">
                        <span class="badge bg-info">Đang giao</span>
                    </c:when>
                    <c:when test="${order.status == 'DELIVERED'}">
                        <span class="badge bg-success">Đã giao</span>
                    </c:when>
                </c:choose>
            </div>

            <!-- Order Items -->
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title mb-4">Sản phẩm</h5>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Số lượng</th>
                                    <th>Tổng</th>
                                    <th>Đánh giá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${order.items}" var="item">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="${pageContext.request.contextPath}/images/${item.product.image}" 
                                                     alt="${item.product.name}" 
                                                     style="width: 50px; height: 50px; object-fit: cover;">
                                                <div class="ms-3">
                                                    <h6 class="mb-0">
                                                        <a href="${pageContext.request.contextPath}/product/${item.product.id}" 
                                                           class="text-dark text-decoration-none">
                                                            ${item.product.name}
                                                        </a>
                                                    </h6>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${item.price}" 
                                                            type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td>${item.quantity}</td>
                                        <td>
                                            <fmt:formatNumber value="${item.subtotal}" 
                                                            type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'DELIVERED' && !order.reviewed}">
                                                    <button type="button" class="btn btn-outline-primary btn-sm"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#reviewModal-${item.product.id}">
                                                        <i class="fas fa-star"></i> Đánh giá
                                                    </button>
                                                    
                                                    <!-- Review Modal -->
                                                    <div class="modal fade" id="reviewModal-${item.product.id}" tabindex="-1">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title">Đánh giá sản phẩm</h5>
                                                                    <button type="button" class="btn-close" 
                                                                            data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <form action="${pageContext.request.contextPath}/review/add" 
                                                                          method="post">
                                                                        <input type="hidden" name="productId" 
                                                                               value="${item.product.id}">
                                                                        <input type="hidden" name="orderId" 
                                                                               value="${order.id}">
                                                                        
                                                                        <!-- Rating Stars -->
                                                                        <div class="mb-3">
                                                                            <label class="form-label">Đánh giá:</label>
                                                                            <div class="star-rating">
                                                                                <c:forEach begin="1" end="5" var="i">
                                                                                    <input type="radio" id="star${i}-${item.product.id}" 
                                                                                           name="rating" value="${i}" required>
                                                                                    <label for="star${i}-${item.product.id}">
                                                                                        <i class="far fa-star"></i>
                                                                                    </label>
                                                                                </c:forEach>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <!-- Comment -->
                                                                        <div class="mb-3">
                                                                            <label for="comment-${item.product.id}" 
                                                                                   class="form-label">Nhận xét:</label>
                                                                            <textarea class="form-control" 
                                                                                    id="comment-${item.product.id}" 
                                                                                    name="comment" rows="3"></textarea>
                                                                        </div>
                                                                        
                                                                        <button type="submit" class="btn btn-primary">
                                                                            Gửi đánh giá
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:when test="${order.reviewed}">
                                                    <span class="text-success">
                                                        <i class="fas fa-check"></i> Đã đánh giá
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <!-- Order Summary -->
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title mb-4">Thông tin đơn hàng</h5>
                    
                    <dl class="row mb-0">
                        <dt class="col-sm-5">Ngày đặt:</dt>
                        <dd class="col-sm-7">
                            <fmt:formatDate value="${order.orderDate}" 
                                          pattern="dd/MM/yyyy HH:mm"/>
                        </dd>

                        <dt class="col-sm-5">Tổng tiền:</dt>
                        <dd class="col-sm-7">
                            <fmt:formatNumber value="${order.totalAmount}" 
                                            type="currency" currencySymbol="₫"/>
                        </dd>

                        <dt class="col-sm-5">Người nhận:</dt>
                        <dd class="col-sm-7">${order.user.fullName}</dd>

                        <dt class="col-sm-5">Địa chỉ:</dt>
                        <dd class="col-sm-7">${order.user.address}</dd>

                        <dt class="col-sm-5">Điện thoại:</dt>
                        <dd class="col-sm-7">${order.user.phone}</dd>
                    </dl>
                </div>
            </div>

            <!-- Actions -->
            <div class="card">
                <div class="card-body">
                    <c:if test="${sessionScope.user.admin && order.status == 'PENDING'}">
                        <form action="${pageContext.request.contextPath}/order" method="post" 
                              class="d-grid gap-2">
                            <input type="hidden" name="action" value="simulate-delivery">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <button type="submit" class="btn btn-info">
                                <i class="fas fa-truck"></i> Giao hàng
                            </button>
                        </form>
                    </c:if>
                    
                    <c:if test="${!sessionScope.user.admin && order.status == 'DELIVERING'}">
                        <form action="${pageContext.request.contextPath}/order" method="post" 
                              class="d-grid gap-2">
                            <input type="hidden" name="action" value="confirm-delivery">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check"></i> Xác nhận đã nhận
                            </button>
                        </form>
                    </c:if>
                    
                    <a href="${pageContext.request.contextPath}/order" 
                       class="btn btn-outline-primary d-block mt-2">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
