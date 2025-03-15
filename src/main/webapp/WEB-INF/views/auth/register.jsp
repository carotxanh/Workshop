<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Đăng ký" />
</jsp:include>

<div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
        <div class="card shadow">
            <div class="card-body p-5">
                <h2 class="text-center mb-4">Đăng ký tài khoản</h2>
                
                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div class="mb-3">
                        <label for="name" class="form-label">Họ và tên</label>
                        <input type="text" class="form-control" id="name" name="name" value="${name}" required>
                        <c:if test="${not empty nameError}">
                            <div class="text-danger">${nameError}</div>
                        </c:if>
                    </div>
                    
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${email}" required>
                        <c:if test="${not empty emailError}">
                            <div class="text-danger">${emailError}</div>
                        </c:if>
                    </div>
                    
                    <div class="mb-3">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" required>
                        <c:if test="${not empty phoneError}">
                            <div class="text-danger">${phoneError}</div>
                        </c:if>
                    </div>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                        <div class="form-text">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</div>
                        <c:if test="${not empty passwordError}">
                            <div class="text-danger">${passwordError}</div>
                        </c:if>
                    </div>
                    
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        <c:if test="${not empty confirmPasswordError}">
                            <div class="text-danger">${confirmPasswordError}</div>
                        </c:if>
                    </div>
                    
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="terms" name="terms" required>
                        <label class="form-check-label" for="terms">Tôi đồng ý với <a href="#" class="text-decoration-none">điều khoản sử dụng</a> và <a href="#" class="text-decoration-none">chính sách bảo mật</a></label>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Đăng ký</button>
                    </div>
                </form>
                
                <hr class="my-4">
                
                <div class="text-center">
                    <p class="mb-0">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">Đăng nhập</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 