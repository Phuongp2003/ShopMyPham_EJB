<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <h2 class="mb-4">Quản lý đơn hàng</h2>
    
    <!-- Order Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Trạng thái</label>
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="" ${empty param.status ? 'selected' : ''}>Tất cả</option>
                        <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="DELIVERING" ${param.status == 'DELIVERING' ? 'selected' : ''}>Đang giao</option>
                        <option value="DELIVERED" ${param.status == 'DELIVERED' ? 'selected' : ''}>Đã giao</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Sắp xếp</label>
                    <select name="sort" class="form-select" onchange="this.form.submit()">
                        <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                        <option value="oldest" ${param.sort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                        <option value="amount_high" ${param.sort == 'amount_high' ? 'selected' : ''}>Giá trị cao</option>
                        <option value="amount_low" ${param.sort == 'amount_low' ? 'selected' : ''}>Giá trị thấp</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Tìm kiếm</label>
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" 
                               placeholder="Tìm theo mã đơn hoặc tên khách hàng..." 
                               value="${param.search}">
                        <button class="btn btn-outline-secondary" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Orders Table -->
    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
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
                                    <div>
                                        <strong>${order.user.fullName}</strong><br>
                                        <small class="text-muted">${order.user.email}</small>
                                    </div>
                                </td>
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
                                    <a href="${pageContext.request.contextPath}/order/view/${order.id}" 
                                       class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-eye"></i> Chi tiết
                                    </a>
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
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <!-- Empty State -->
            <c:if test="${empty orders}">
                <div class="text-center py-5">
                    <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                    <h4>Không tìm thấy đơn hàng nào</h4>
                    <p class="text-muted">
                        ${not empty param.search ? 'Không có kết quả phù hợp với tìm kiếm của bạn' : 
                          'Chưa có đơn hàng nào trong hệ thống'}
                    </p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${not empty orders}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}">Trước</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="page">
                    <li class="page-item ${currentPage == page ? 'active' : ''}">
                        <a class="page-link" href="?page=${page}">${page}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}">Sau</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
