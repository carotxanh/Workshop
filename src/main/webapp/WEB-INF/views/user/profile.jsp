<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Hồ sơ người dùng" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Hồ sơ người dùng</h2>
</div>

<!-- Toast container -->
<div class="position-fixed top-0 end-0 p-3" style="z-index: 1050">
    <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-check-circle me-2"></i>
                <span id="successToastMessage"></span>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    
    <div id="errorToast" class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-exclamation-circle me-2"></i>
                <span id="errorToastMessage"></span>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-4">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Thông tin cá nhân</h6>
            </div>
            <div class="card-body">
                <div class="text-center mb-4">
                    <img class="img-profile rounded-circle" src="${pageContext.request.contextPath}/resources/images/undraw_profile.svg" style="width: 150px; height: 150px;">
                    <h5 class="mt-3">${user.name}</h5>
                    <p class="text-muted">
                        <c:choose>
                            <c:when test="${user.role eq 'ADMIN'}">
                                <span class="badge bg-danger">Quản trị viên</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-primary">Người dùng</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#uploadAvatarModal">
                        <i class="fas fa-upload me-2"></i>Thay đổi ảnh đại diện
                    </button>
                </div>
                
                <div class="mb-3">
                    <label class="form-label text-muted">Email</label>
                    <p class="form-control-static">${user.email}</p>
                </div>
                <div class="mb-3">
                    <label class="form-label text-muted">Số điện thoại</label>
                    <p class="form-control-static">${user.phone}</p>
                </div>
                <div class="mb-3">
                    <label class="form-label text-muted">Ngày tham gia</label>
                    <p class="form-control-static"><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" /></p>
                </div>
                <div class="mb-3">
                    <label class="form-label text-muted">Cập nhật lần cuối</label>
                    <p class="form-control-static"><fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></p>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-lg-8">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Cập nhật thông tin</h6>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/profileController" method="post" id="profileForm" novalidate>
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="name" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" value="${user.name}"  
                                   pattern=".{3,50}" title="Họ và tên phải có từ 3 đến 50 ký tự">
                            <div class="invalid-feedback">Vui lòng nhập họ và tên (3-50 ký tự)</div>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" 
                                   pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Vui lòng nhập email hợp lệ">
                            <div class="invalid-feedback">Vui lòng nhập email hợp lệ</div>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}"
                                   pattern="(0|\+84)[0-9]{9,10}" title="Số điện thoại phải bắt đầu bằng 0 hoặc +84 và có 10-11 số">
                            <div class="invalid-feedback">Số điện thoại không hợp lệ</div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Cập nhật thông tin
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Đổi mật khẩu</h6>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/profileController" method="post" id="passwordForm" novalidate>
                    <input type="hidden" name="action" value="changePassword">
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                        <div class="invalid-feedback">Vui lòng nhập mật khẩu hiện tại</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">Mật khẩu mới <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required
                               pattern=".{8,}" title="Mật khẩu phải có ít nhất 8 ký tự">
                        <div class="form-text">Mật khẩu phải có ít nhất 8 ký tự.</div>
                        <div class="invalid-feedback">Mật khẩu phải có ít nhất 8 ký tự</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        <div class="invalid-feedback">Mật khẩu xác nhận không khớp</div>
                    </div>
                    
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-key me-2"></i>Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Upload Avatar -->
<div class="modal fade" id="uploadAvatarModal" tabindex="-1" aria-labelledby="uploadAvatarModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="uploadAvatarModalLabel">Thay đổi ảnh đại diện</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/profileController" method="post" enctype="multipart/form-data" id="avatarForm" novalidate>
                <input type="hidden" name="action" value="uploadAvatar">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="avatarFile" class="form-label">Chọn ảnh</label>
                        <input class="form-control" type="file" id="avatarFile" name="avatarFile" accept="image/*" required>
                        <div class="form-text">Chỉ chấp nhận file ảnh (JPG, PNG, GIF). Kích thước tối đa 2MB.</div>
                        <div class="invalid-feedback">Vui lòng chọn file ảnh</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Tải lên</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Hiển thị toast nếu có thông báo
    <c:if test="${not empty successMessage}">
        $('#successToastMessage').text("${successMessage}");
        var successToast = new bootstrap.Toast(document.getElementById('successToast'));
        successToast.show();
    </c:if>
    
    <c:if test="${not empty errorMessage}">
        $('#errorToastMessage').text("${errorMessage}");
        var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
        errorToast.show();
    </c:if>
    
    // Validate form cập nhật thông tin
    $('#profileForm').submit(function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
            $(this).addClass('was-validated');
            $('#errorToastMessage').text("Vui lòng kiểm tra lại thông tin đã nhập");
            var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
            errorToast.show();
            return false;
        }
        $(this).addClass('was-validated');
        return true;
    });
    
    // Validate form đổi mật khẩu
    $('#passwordForm').submit(function(e) {
        const currentPassword = $('#currentPassword').val();
        const newPassword = $('#newPassword').val();
        const confirmPassword = $('#confirmPassword').val();
        
        if (!currentPassword || !newPassword || !confirmPassword) {
            e.preventDefault();
            $(this).addClass('was-validated');
            $('#errorToastMessage').text("Vui lòng nhập đầy đủ thông tin");
            var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
            errorToast.show();
            return false;
        }
        
        if (newPassword.length < 8) {
            e.preventDefault();
            $('#newPassword').addClass('is-invalid');
            $('#errorToastMessage').text("Mật khẩu phải có ít nhất 8 ký tự");
            var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
            errorToast.show();
            return false;
        }
        
        if (newPassword !== confirmPassword) {
            e.preventDefault();
            $('#confirmPassword').addClass('is-invalid');
            $('#errorToastMessage').text("Mật khẩu và xác nhận mật khẩu không khớp");
            var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
            errorToast.show();
            return false;
        }
        
        $(this).addClass('was-validated');
        return true;
    });
    
    // Validate form upload avatar
    $('#avatarForm').submit(function(e) {
        const avatarFile = $('#avatarFile').val();
        
        if (!avatarFile) {
            e.preventDefault();
            $(this).addClass('was-validated');
            $('#errorToastMessage').text("Vui lòng chọn file ảnh");
            var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
            errorToast.show();
            return false;
        }
        
        const fileExtension = avatarFile.substring(avatarFile.lastIndexOf('.')).toLowerCase();
        if (fileExtension !== '.jpg' && fileExtension !== '.jpeg' && fileExtension !== '.png' && fileExtension !== '.gif') {
            e.preventDefault();
            $('#avatarFile').addClass('is-invalid');
            $('#errorToastMessage').text("Chỉ chấp nhận file ảnh (JPG, PNG, GIF)");
            var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
            errorToast.show();
            return false;
        }
        
        $(this).addClass('was-validated');
        return true;
    });
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 