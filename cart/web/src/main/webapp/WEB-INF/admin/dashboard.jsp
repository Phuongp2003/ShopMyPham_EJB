<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <h2 class="mb-4">Quản lý cửa hàng</h2>
    
    <div class="row">
        <!-- Order Stats -->
        <div class="col-md-4 mb-4">
            <div class="card bg-primary text-white h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-0">Đơn hàng chờ xử lý</h6>
                            <h2 class="my-2">${fn:length(pendingOrders)}</h2>
                        </div>
                        <i class="fas fa-clock fa-2x opacity-50"></i>
                    </div>
                    <a href="#pendingOrders" class="text-white text-decoration-none">
                        Xem chi tiết <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card bg-info text-white h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-0">Đơn hàng đang giao</h6>
                            <h2 class="my-2">${fn:length(deliveringOrders)}</h2>
                        </div>
                        <i class="fas fa-truck fa-2x opacity-50"></i>
                    </div>
                    <a href="#deliveringOrders" class="text-white text-decoration-none">
                        Xem chi tiết <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card bg-success text-white h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title mb-0">Thao tác nhanh</h6>
                        </div>
                        <i class="fas fa-tasks fa-2x opacity-50"></i>
                    </div>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/admin/products" 
                           class="btn btn-outline-light btn-sm w-100 mb-2">
                            <i class="fas fa-box"></i> Quản lý sản phẩm
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders" 
                           class="btn btn-outline-light btn-sm w-100">
                            <i class="fas fa-list"></i> Quản lý đơn hàng
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Pending Orders -->
    <div id="pendingOrders" class="card mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="card-title mb-0">Đơn hàng chờ xử lý</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty pendingOrders}">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pendingOrders}" var="order">
                                    <tr>
                                        <td>#${order.id}</td>
                                        <td>${order.user.fullName}</td>
                                        <td>
                                            <fmt:formatDate value="${order.orderDate}" 
                                                          pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${order.totalAmount}" 
                                                            type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/order/view/${order.id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <form action="${pageContext.request.contextPath}/order" 
                                                  method="post" class="d-inline">
                                                <input type="hidden" name="action" value="simulate-delivery">
                                                <input type="hidden" name="orderId" value="${order.id}">
                                                <button type="submit" class="btn btn-info btn-sm">
                                                    <i class="fas fa-truck"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-center mb-0">Không có đơn hàng nào đang chờ xử lý</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Delivering Orders -->
    <div id="deliveringOrders" class="card">
        <div class="card-header bg-info text-white">
            <h5 class="card-title mb-0">Đơn hàng đang giao</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty deliveringOrders}">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${deliveringOrders}" var="order">
                                    <tr>
                                        <td>#${order.id}</td>
                                        <td>${order.user.fullName}</td>
                                        <td>
                                            <fmt:formatDate value="${order.orderDate}" 
                                                          pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${order.totalAmount}" 
                                                            type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/order/view/${order.id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-center mb-0">Không có đơn hàng nào đang giao</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
