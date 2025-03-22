<%@ include file="/WEB-INF/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Quản lý sản phẩm</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
            <i class="fas fa-plus"></i> Thêm sản phẩm
        </button>
    </div>

    <!-- Products Table -->
    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Hình ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá</th>
                            <th>Tồn kho</th>
                            <th>Đánh giá</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${products}" var="product">
                            <tr>
                                <td>
                                    <img src="${pageContext.request.contextPath}/images/${product.image}" 
                                         alt="${product.name}" style="width: 50px; height: 50px; object-fit: cover;">
                                </td>
                                <td>${product.name}</td>
                                <td>
                                    <fmt:formatNumber value="${product.price}" 
                                                    type="currency" currencySymbol="₫"/>
                                </td>
                                <td>${product.stock}</td>
                                <td>
                                    <div class="star-rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star${i <= product.averageRating ? '' : '-o'}"></i>
                                        </c:forEach>
                                        <span class="ms-1">(${product.totalReviews})</span>
                                    </div>
                                </td>
                                <td>
                                    <button class="btn btn-outline-primary btn-sm" 
                                            onclick="editProduct('${product.id}')"
                                            data-bs-toggle="modal" data-bs-target="#editProductModal">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm" 
                                            onclick="deleteProduct('${product.id}')">
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

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm sản phẩm mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/admin/products" method="post" 
                      enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add-product">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Tên sản phẩm</label>
                        <input type="text" class="form-control" id="name" name="name" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="price" class="form-label">Giá</label>
                        <input type="number" class="form-control" id="price" name="price" 
                               min="0" step="1000" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="stock" class="form-label">Số lượng tồn kho</label>
                        <input type="number" class="form-control" id="stock" name="stock" 
                               min="0" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="image" class="form-label">Hình ảnh</label>
                        <input type="text" class="form-control" id="image" name="image" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Edit Product Modal -->
<div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chỉnh sửa sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/admin/products" method="post" 
                      enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update-product">
                    <input type="hidden" name="productId" id="editProductId">
                    
                    <div class="mb-3">
                        <label for="editName" class="form-label">Tên sản phẩm</label>
                        <input type="text" class="form-control" id="editName" name="name" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="editDescription" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="editDescription" name="description" rows="3"></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="editPrice" class="form-label">Giá</label>
                        <input type="number" class="form-control" id="editPrice" name="price" 
                               min="0" step="1000" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="editStock" class="form-label">Số lượng tồn kho</label>
                        <input type="number" class="form-control" id="editStock" name="stock" 
                               min="0" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="editImage" class="form-label">Hình ảnh</label>
                        <input type="text" class="form-control" id="editImage" name="image" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function editProduct(productId) {
    // Get product details via AJAX and populate the edit form
    fetch('${pageContext.request.contextPath}/admin/products?action=get-product&id=' + productId)
        .then(response => response.json())
        .then(product => {
            document.getElementById('editProductId').value = product.id;
            document.getElementById('editName').value = product.name;
            document.getElementById('editDescription').value = product.description;
            document.getElementById('editPrice').value = product.price;
            document.getElementById('editStock').value = product.stock;
            document.getElementById('editImage').value = product.image;
        });
}

function deleteProduct(productId) {
    if (confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/products';
        
        const fields = {
            'action': 'delete-product',
            'productId': productId
        };
        
        for (const key in fields) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = fields[key];
            form.appendChild(input);
        }
        
        document.body.appendChild(form);
        form.submit();
    }
}
</script>

<%@ include file="/WEB-INF/common/footer.jsp" %>
