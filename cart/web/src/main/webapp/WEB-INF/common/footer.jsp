</div><!-- Close container from header -->
    
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container-wrap">
            <div class="row">
                <div class="col-md-4">
                    <h5>Shop Mỹ Phẩm</h5>
                    <p>Địa chỉ: 123 ABC Street<br>
                    Điện thoại: (123) 456-7890<br>
                    Email: contact@shopmypham.com</p>
                </div>
                <div class="col-md-4">
                    <h5>Liên kết</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/home" class="text-light">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/products" class="text-light">Sản phẩm</a></li>
                        <li><a href="${pageContext.request.contextPath}/cart" class="text-light">Giỏ hàng</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Theo dõi chúng tôi</h5>
                    <div class="social-links">
                        <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-light me-3"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-light me-3"><i class="fab fa-twitter"></i></a>
                    </div>
                </div>
            </div>
            <hr class="my-4">
            <div class="row">
                <div class="col text-center">
                    <p class="mb-0">&copy; 2025 Shop Mỹ Phẩm. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Add to cart function with confirmation dialog
        function addToCart(productId) {
            const quantity = document.querySelector(`#quantity-\${productId}`).value;
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/cart';
            
            const fields = {
                'action': 'add',
                'productId': productId,
                'quantity': quantity
            };
            
            for (const key in fields) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = fields[key];
                form.appendChild(input);
            }
            
            document.body.appendChild(form);
            
            // Submit form and handle redirect after success
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                const formData = new FormData(form);
                fetch(form.action, {
                    method: 'POST',
                    body: formData
                }).then(() => {
                    if (confirm('Sản phẩm đã được thêm vào giỏ hàng. Bạn có muốn tiếp tục mua sắm?')) {
                        window.location.href = '${pageContext.request.contextPath}/products';
                    } else {
                        window.location.href = '${pageContext.request.contextPath}/cart';
                    }
                });
            });
            
            form.submit();
        }
        
        // Update cart function
        function updateCart(productId) {
            const quantity = document.querySelector(`#quantity-\${productId}`).value;
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/cart';
            
            const fields = {
                'action': 'update',
                'productId': productId,
                'quantity': quantity
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
        
        // Remove from cart function
        function removeFromCart(productId) {
            if (confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/cart';
                
                const fields = {
                    'action': 'remove',
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
</body>
</html>
