<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="container py-5">
	<div class="row justify-content-center">
		<div class="col-md-8 text-center">
			<div class="card">
				<div class="card-body py-5">
					<i
						class="fas fa-exclamation-circle fa-4x text-danger mb-4"></i>

					<h2 class="mb-4">Đã xảy ra lỗi</h2>

					<c:choose>
						<c:when test="${not empty error}">
							<p class="lead text-danger mb-4">${error}</p>
						</c:when>
						<c:otherwise>
							<p class="lead text-danger mb-4">
								Đã xảy ra lỗi không mong muốn. Vui lòng thử lại
								sau.
							</p>
						</c:otherwise>
					</c:choose>

					<div
						class="d-grid gap-2 d-sm-flex justify-content-sm-center">
						<button
							class="btn btn-outline-secondary"
							onclick="history.back()">
							<i class="fas fa-arrow-left"></i> Quay lại
						</button>
						<a
							href="${pageContext.request.contextPath}/home"
							class="btn btn-primary">
							<i class="fas fa-home"></i> Về trang chủ
						</a>
					</div>
				</div>
			</div>

			<!-- Technical Details (for admin only) -->
			<c:if test="${sessionScope.user.admin && not empty stackTrace}">
				<div class="card mt-4">
					<div class="card-header">
						<h5 class="card-title mb-0">Chi tiết kỹ thuật</h5>
					</div>
					<div class="card-body">
						<pre
							class="mb-0 text-start"><code>${stackTrace}</code></pre>
					</div>
				</div>
			</c:if>
		</div>
	</div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
