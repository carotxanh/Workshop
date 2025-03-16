<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Quản lý chuyến bay" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản lý chuyến bay</h2>
    <a href="${pageContext.request.contextPath}/admin/flights/create" class="btn btn-primary">
        <i class="fas fa-plus-circle me-2"></i>Thêm chuyến bay mới
    </a>
</div>

<c:if test="${not empty sessionScope.success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.success}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("success"); %>
</c:if>

<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("error"); %>
</c:if>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Danh sách chuyến bay</h6>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered" id="flightsTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Số hiệu</th>
                        <th>Hãng bay</th>
                        <th>Từ - Đến</th>
                        <th>Khởi hành</th>
                        <th>Đến nơi</th>
                        <th>Giá vé</th>
                        <th>Ghế trống</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${flights}" var="flight">
                        <tr>
                            <td>${flight.flightId}</td>
                            <td>${flight.flightNumber}</td>
                            <td>${flight.airline}</td>
                            <td>${flight.origin} - ${flight.destination}</td>
                            <td>
                                <fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy HH:mm" />
                            </td>
                            <td>
                                <fmt:formatDate value="${flight.arrivalTime}" pattern="dd/MM/yyyy HH:mm" />
                            </td>
                            <td>
                                <fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                            </td>
                            <td>${flight.availableSeats}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${flight.status eq 'SCHEDULED'}">
                                        <span class="badge bg-primary">Đã lên lịch</span>
                                    </c:when>
                                    <c:when test="${flight.status eq 'DELAYED'}">
                                        <span class="badge bg-warning text-dark">Trì hoãn</span>
                                    </c:when>
                                    <c:when test="${flight.status eq 'CANCELLED'}">
                                        <span class="badge bg-danger">Đã hủy</span>
                                    </c:when>
                                    <c:when test="${flight.status eq 'COMPLETED'}">
                                        <span class="badge bg-success">Đã hoàn thành</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${flight.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex">
                                    <a href="${pageContext.request.contextPath}/admin/flights/detail?id=${flight.flightId}" 
                                       class="btn btn-info btn-sm me-1" title="Chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/flights/edit?id=${flight.flightId}" 
                                       class="btn btn-primary btn-sm me-1" title="Sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="javascript:void(0);" 
                                       onclick="confirmDelete(${flight.flightId}, '${flight.flightNumber}')"
                                       class="btn btn-danger btn-sm" title="Xóa">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal xác nhận xóa -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn xóa chuyến bay <span id="flightToDelete"></span>?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('#flightsTable').DataTable({
            "language": {
                "emptyTable": "Không có dữ liệu",
                "info": "Hiển thị _START_ đến _END_ của _TOTAL_ chuyến bay",
                "infoEmpty": "Hiển thị 0 đến 0 của 0 chuyến bay",
                "zeroRecords": "Không tìm thấy chuyến bay nào phù hợp",
                "paginate": {
                    "first": "Đầu",
                    "last": "Cuối",
                    "next": "Tiếp",
                    "previous": "Trước"
                }
            }
        });
    });

    function confirmDelete(flightId, flightNumber) {
        document.getElementById('flightToDelete').textContent = flightNumber;
        document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/admin/flights/delete?id=' + flightId;
        var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 