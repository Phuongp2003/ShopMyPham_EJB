<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <h2 class="mb-4">Đơn hàng của tôi</h2>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orders}" var="order">
                                    <tr>
                                        <td>#${order.id}</td>
                                        <td>
                                            <fmt:formatDate value="${order.orderDate}" 
                                                          pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${order.totalAmount}" 
                                                            type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td>
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
                                        </td>
                                        <td>
                                            <!-- View Details -->
                                            <a href="${pageContext.request.contextPath}/order/view/${order.id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye"></i> Chi tiết
                                            </a>

                                            <!-- Admin Actions -->
                                            <c:if test="${sessionScope.user.admin}">
                                                <c:if test="${order.status == 'PENDING'}">
                                                    <form action="${pageContext.request.contextPath}/order" 
                                                          method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="simulate-delivery">
                                                        <input type="hidden" name="orderId" value="${order.id}">
                                                        <button type="submit" class="btn btn-info btn-sm">
                                                            <i class="fas fa-truck"></i> Giao hàng
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </c:if>

                                            <!-- User Actions -->
                                            <c:if test="${!sessionScope.user.admin}">
                                                <c:if test="${order.status == 'DELIVERING'}">
                                                    <form action="${pageContext.request.contextPath}/order" 
                                                          method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="confirm-delivery">
                                                        <input type="hidden" name="orderId" value="${order.id}">
                                                        <button type="submit" class="btn btn-success btn-sm">
                                                            <i class="fas fa-check"></i> Xác nhận đã nhận
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <i class="fas fa-box-open fa-4x mb-3 text-muted"></i>
                <h3>Chưa có đơn hàng nào</h3>
                <p>Bạn chưa có đơn hàng nào.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Mua sắm ngay
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
