<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <h2 class="mb-4">Giỏ hàng</h2>
    
    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="row">
                <!-- Cart Items -->
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-body">
                            <!-- Cart Items Table -->
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th>Giá</th>
                                            <th>Số lượng</th>
                                            <th>Tổng</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${cartItems}" var="item">
                                            <tr>
                                                <!-- Product -->
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="${item.product.image}" 
                                                             alt="${item.product.name}" style="width: 50px; height: 50px; object-fit: cover;">
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
                                                
                                                <!-- Price -->
                                                <td>
                                                    <fmt:formatNumber value="${item.product.price}" 
                                                                    type="currency" currencySymbol="₫"/>
                                                </td>
                                                
                                                <!-- Quantity -->
                                                <td>
                                                    <div class="input-group" style="width: 120px;">
                                                        <input type="number" class="form-control" 
                                                               id="quantity-${item.product.id}"
                                                               value="${item.quantity}" min="1" 
                                                               max="${item.product.stock}">
                                                        <button class="btn btn-outline-secondary" type="button"
                                                                onclick="updateCart('${item.product.id}')">
                                                            <i class="fas fa-sync-alt"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                                
                                                <!-- Subtotal -->
                                                <td>
                                                    <fmt:formatNumber 
                                                        value="${item.product.price * item.quantity}" 
                                                        type="currency" currencySymbol="₫"/>
                                                </td>
                                                
                                                <!-- Remove Button -->
                                                <td>
                                                    <button class="btn btn-outline-danger btn-sm"
                                                            onclick="removeFromCart('${item.product.id}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Cart Summary -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title mb-4">Tổng đơn hàng</h5>
                            
                            <!-- Calculate Total -->
                            <c:set var="total" value="0"/>
                            <c:forEach items="${cartItems}" var="item">
                                <c:set var="total" 
                                       value="${total + (item.product.price * item.quantity)}"/>
                            </c:forEach>
                            
                            <div class="d-flex justify-content-between mb-3">
                                <span>Tổng tiền:</span>
                                <strong>
                                    <fmt:formatNumber value="${total}" type="currency" currencySymbol="₫"/>
                                </strong>
                            </div>
                            
                            <!-- Checkout Button -->
                            <form action="${pageContext.request.contextPath}/order" method="post" 
                                  class="d-grid gap-2">
                                <input type="hidden" name="action" value="create">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    Thanh toán
                                </button>
                            </form>
                            
                            <!-- Continue Shopping -->
                            <div class="d-grid gap-2 mt-3">
                                <a href="${pageContext.request.contextPath}/products" 
                                   class="btn btn-outline-primary">
                                    Tiếp tục mua sắm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Empty Cart -->
            <div class="text-center py-5">
                <i class="fas fa-shopping-cart fa-4x mb-3 text-muted"></i>
                <h3>Giỏ hàng trống</h3>
                <p>Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Mua sắm ngay
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
