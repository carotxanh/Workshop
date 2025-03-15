<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Hồ sơ người dùng" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Hồ sơ người dùng</h2>
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
                    <h5 class="mt-3">${user.fullName}</h5>
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
                    <label class="form-label text-muted">Tên đăng nhập</label>
                    <p class="form-control-static">${user.username}</p>
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
                    <label class="form-label text-muted">Lần đăng nhập cuối</label>
                    <p class="form-control-static"><fmt:formatDate value="${user.lastLogin}" pattern="dd/MM/yyyy HH:mm" /></p>
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
                <form action="${pageContext.request.contextPath}/admin/profile/update" method="post" id="profileForm">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
                        </div>
                        <div class="col-md-6">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <input type="text" class="form-control" id="address" name="address" value="${user.address}">
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
                <form action="${pageContext.request.contextPath}/admin/profile/change-password" method="post" id="passwordForm">
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">Mật khẩu mới <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        <div class="form-text">Mật khẩu phải có ít nhất 8 ký tự.</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
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
            <form action="${pageContext.request.contextPath}/admin/profile/upload-avatar" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="avatarFile" class="form-label">Chọn ảnh</label>
                        <input class="form-control" type="file" id="avatarFile" name="avatarFile" accept="image/*" required>
                        <div class="form-text">Chỉ chấp nhận file ảnh (JPG, PNG, GIF). Kích thước tối đa 2MB.</div>
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
    $('#passwordForm').submit(function(e) {
        const newPassword = $('#newPassword').val();
        const confirmPassword = $('#confirmPassword').val();
        
        if (newPassword.length < 8) {
            e.preventDefault();
            alert('Mật khẩu phải có ít nhất 8 ký tự.');
            return false;
        }
        
        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert('Mật khẩu và xác nhận mật khẩu không khớp.');
            return false;
        }
        
        return true;
    });
});
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 