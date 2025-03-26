<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8" />
		<meta
			name="viewport"
			content="width=device-width, initial-scale=1.0" />
		<title>Shop Mỹ Phẩm</title>
		<link
			href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
			rel="stylesheet" />
		<link
			href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
			rel="stylesheet" />
		<style>
			nav {
				height: 56px;
			}
			/* Ensure minimum page height */
			body {
			    min-height: 100vh;
			    display: flex;
			    flex-direction: column;
			}
			.container {
			    flex: 1;
			    min-height: calc(100vh - 56px); /* Subtract navbar height */
			}

			.banner {
			    height: 600px;
			    background-size: cover;
			    background-position: center;
			    margin-bottom: 2rem;
			}
			.product-card {
			    height: 100%;
			}
			.product-image {
			    height: 200px;
			    object-fit: cover;
			}
			.star-rating {
			    color: #ffc107;
			}
			.cart-indicator {
			    position: relative;
			    display: inline-block;
			}
			.cart-dot {
			    position: absolute;
			    top: -5px;
			    right: -5px;
			    width: 10px;
			    height: 10px;
			    background-color: red;
			    border-radius: 50%;
			    display: ${not empty sessionScope.cartCount && sessionScope.cartCount > 0 ? 'block' : 'none'};
			}
		</style>
	</head>
	<body>
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
			<div
				class="container"
				style="height: 100%">
				<a
					class="navbar-brand"
					href="${pageContext.request.contextPath}/"
					>Shop Mỹ Phẩm</a
				>
				<button
					class="navbar-toggler"
					type="button"
					data-bs-toggle="collapse"
					data-bs-target="#navbarNav">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div
					class="collapse navbar-collapse"
					id="navbarNav">
					<ul class="navbar-nav me-auto">
						<li class="nav-item">
							<a
								class="nav-link"
								href="${pageContext.request.contextPath}/products"
								>Sản phẩm</a
							>
						</li>
					</ul>
					<ul class="navbar-nav">
						<c:choose>
							<c:when test="${empty sessionScope.user}">
								<li class="nav-item">
									<a
										class="nav-link"
										href="${pageContext.request.contextPath}/login"
										>Đăng nhập</a
									>
								</li>
								<li class="nav-item">
									<a
										class="nav-link"
										href="${pageContext.request.contextPath}/register"
										>Đăng ký</a
									>
								</li>
							</c:when>
							<c:otherwise>
								<li class="nav-item">
									<a
										class="nav-link"
										href="${pageContext.request.contextPath}/cart">
										<span class="cart-indicator">
											<i class="fas fa-shopping-cart"></i>
											<span class="cart-dot"></span>
										</span>
										Giỏ hàng
									</a>
								</li>
								<li class="nav-item">
									<a
										class="nav-link"
										href="${pageContext.request.contextPath}/profile">
										<i class="fas fa-user"></i>
										${sessionScope.user.username}
									</a>
								</li>
								<li class="nav-item">
									<a
										class="nav-link"
										href="${pageContext.request.contextPath}/logout"
										>Đăng xuất</a
									>
								</li>
							</c:otherwise>
						</c:choose>
					</ul>
				</div>
			</div>
		</nav>
		<div class="container-wrap">
			<c:if test="${not empty error}">
				<div
					class="alert alert-danger alert-dismissible fade show"
					role="alert">
					${error}
					<button
						type="button"
						class="btn-close"
						data-bs-dismiss="alert"></button>
				</div>
			</c:if>
			<c:if test="${not empty message}">
				<div
					class="alert alert-success alert-dismissible fade show"
					role="alert">
					${message}
					<button
						type="button"
						class="btn-close"
						data-bs-dismiss="alert"></button>
				</div>
			</c:if>
		</div>
	</body>
</html>
