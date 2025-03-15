<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Quản lý người dùng" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản lý người dùng</h2>
    <div>
        <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Thêm người dùng
        </a>
    </div>
</div>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Danh sách người dùng</h6>
    </div>
    <div class="card-body">
        <div class="mb-3">
            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-3">
                <div class="col-md-4">
                    <label for="username" class="form-label">Tên đăng nhập</label>
                    <input type="text" class="form-control" id="username" name="username" value="${param.username}">
                </div>
                <div class="col-md-4">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="${param.email}">
                </div>
                <div class="col-md-4">
                    <label for="role" class="form-label">Vai trò</label>
                    <select class="form-select" id="role" name="role">
                        <option value="">Tất cả</option>
                        <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên</option>
                        <option value="USER" ${param.role == 'USER' ? 'selected' : ''}>Người dùng</option>
                    </select>
                </div>
                <div class="col-12 mt-3">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search me-2"></i>Tìm kiếm
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary ms-2">
                        <i class="fas fa-redo me-2"></i>Đặt lại
                    </a>
                </div>
            </form>
        </div>
        
        <div class="table-responsive">
            <table class="table table-bordered" id="usersTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.userId}</td>
                            <td>${user.username}</td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.role eq 'ADMIN'}">
                                        <span class="badge bg-danger">Quản trị viên</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-primary">Người dùng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.active}">
                                        <span class="badge bg-success">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Bị khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" /></td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}" class="btn btn-primary">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <c:if test="${user.active}">
                                        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#lockModal${user.userId}">
                                            <i class="fas fa-lock"></i>
                                        </button>
                                    </c:if>
                                    <c:if test="${!user.active}">
                                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#unlockModal${user.userId}">
                                            <i class="fas fa-unlock"></i>
                                        </button>
                                    </c:if>
                                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal${user.userId}">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                
                                <!-- Modal khóa người dùng -->
                                <c:if test="${user.active}">
                                    <div class="modal fade" id="lockModal${user.userId}" tabindex="-1" aria-labelledby="lockModalLabel${user.userId}" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="lockModalLabel${user.userId}">Xác nhận khóa người dùng</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <p>Bạn có chắc chắn muốn khóa người dùng ${user.username}?</p>
                                                    <p>Người dùng sẽ không thể đăng nhập vào hệ thống sau khi bị khóa.</p>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                    <a href="${pageContext.request.contextPath}/admin/users/lock?id=${user.userId}" class="btn btn-warning">Xác nhận khóa</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Modal mở khóa người dùng -->
                                <c:if test="${!user.active}">
                                    <div class="modal fade" id="unlockModal${user.userId}" tabindex="-1" aria-labelledby="unlockModalLabel${user.userId}" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="unlockModalLabel${user.userId}">Xác nhận mở khóa người dùng</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <p>Bạn có chắc chắn muốn mở khóa người dùng ${user.username}?</p>
                                                    <p>Người dùng sẽ có thể đăng nhập vào hệ thống sau khi được mở khóa.</p>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                    <a href="${pageContext.request.contextPath}/admin/users/unlock?id=${user.userId}" class="btn btn-success">Xác nhận mở khóa</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Modal xóa người dùng -->
                                <div class="modal fade" id="deleteModal${user.userId}" tabindex="-1" aria-labelledby="deleteModalLabel${user.userId}" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="deleteModalLabel${user.userId}">Xác nhận xóa người dùng</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>Bạn có chắc chắn muốn xóa người dùng ${user.username}?</p>
                                                <p class="text-danger">Lưu ý: Việc xóa người dùng sẽ xóa tất cả dữ liệu liên quan đến người dùng này và không thể khôi phục.</p>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                <a href="${pageContext.request.contextPath}/admin/users/delete?id=${user.userId}" class="btn btn-danger">Xác nhận xóa</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <c:if test="${empty users}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>Không tìm thấy người dùng nào phù hợp với điều kiện tìm kiếm.
            </div>
        </c:if>
        
        <!-- Phân trang -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&username=${param.username}&email=${param.email}&role=${param.role}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}&username=${param.username}&email=${param.email}&role=${param.role}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&username=${param.username}&email=${param.email}&role=${param.role}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#usersTable').DataTable({
        "paging": false,
        "searching": false,
        "language": {
            "emptyTable": "Không có dữ liệu",
            "info": "Hiển thị _START_ đến _END_ của _TOTAL_ người dùng",
            "infoEmpty": "Hiển thị 0 đến 0 của 0 người dùng",
            "zeroRecords": "Không tìm thấy người dùng nào phù hợp"
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 