<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="${empty user.userId ? 'Thêm người dùng mới' : 'Cập nhật người dùng'}" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>${empty user.userId ? 'Thêm người dùng mới' : 'Cập nhật người dùng'}</h2>
    <div>
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>
</div>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Thông tin người dùng</h6>
    </div>
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/users/${empty user.userId ? 'create' : 'update'}" method="post" id="userForm">
            <c:if test="${not empty user.userId}">
                <input type="hidden" name="userId" value="${user.userId}">
            </c:if>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="username" name="username" value="${user.username}" required ${not empty user.userId ? 'readonly' : ''}>
                    <div class="form-text">Tên đăng nhập không thể thay đổi sau khi tạo.</div>
                </div>
                <div class="col-md-6">
                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="fullName" class="form-label">Họ tên <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" required>
                </div>
                <div class="col-md-6">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="password" class="form-label">${empty user.userId ? 'Mật khẩu' : 'Mật khẩu mới'} ${empty user.userId ? '<span class="text-danger">*</span>' : ''}</label>
                    <input type="password" class="form-control" id="password" name="password" ${empty user.userId ? 'required' : ''}>
                    <div class="form-text">
                        ${empty user.userId ? 'Mật khẩu phải có ít nhất 8 ký tự.' : 'Để trống nếu không muốn thay đổi mật khẩu.'}
                    </div>
                </div>
                <div class="col-md-6">
                    <label for="confirmPassword" class="form-label">${empty user.userId ? 'Xác nhận mật khẩu' : 'Xác nhận mật khẩu mới'} ${empty user.userId ? '<span class="text-danger">*</span>' : ''}</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" ${empty user.userId ? 'required' : ''}>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="role" class="form-label">Vai trò <span class="text-danger">*</span></label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="USER" ${user.role eq 'USER' ? 'selected' : ''}>Người dùng</option>
                        <option value="ADMIN" ${user.role eq 'ADMIN' ? 'selected' : ''}>Quản trị viên</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label for="active" class="form-label">Trạng thái</label>
                    <div class="form-check form-switch mt-2">
                        <input class="form-check-input" type="checkbox" id="active" name="active" ${empty user.userId || user.active ? 'checked' : ''}>
                        <label class="form-check-label" for="active">Hoạt động</label>
                    </div>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-12">
                    <label for="address" class="form-label">Địa chỉ</label>
                    <textarea class="form-control" id="address" name="address" rows="3">${user.address}</textarea>
                </div>
            </div>
            
            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-secondary me-2" onclick="window.location.href='${pageContext.request.contextPath}/admin/users'">Hủy</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i>${empty user.userId ? 'Thêm mới' : 'Cập nhật'}
                </button>
            </div>
        </form>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#userForm').submit(function(e) {
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();
        
        // Kiểm tra mật khẩu nếu đang thêm mới hoặc đã nhập mật khẩu mới
        if (password || ${empty user.userId}) {
            if (password.length < 8) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 8 ký tự.');
                return false;
            }
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu và xác nhận mật khẩu không khớp.');
                return false;
            }
        }
        
        return true;
    });
});
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 