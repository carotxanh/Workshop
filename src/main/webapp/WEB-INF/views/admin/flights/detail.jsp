<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Chi tiết chuyến bay" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Chi tiết chuyến bay</h2>
    <div>
        <a href="${pageContext.request.contextPath}/admin/flights/edit?id=${flight.flightId}" class="btn btn-primary me-2">
            <i class="fas fa-edit me-2"></i>Chỉnh sửa
        </a>
        <a href="${pageContext.request.contextPath}/admin/flights" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="row">
    <div class="col-lg-8">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold text-primary">Thông tin chuyến bay</h6>
                <span class="badge 
                    <c:choose>
                        <c:when test="${flight.status eq 'SCHEDULED'}">bg-primary</c:when>
                        <c:when test="${flight.status eq 'DELAYED'}">bg-warning text-dark</c:when>
                        <c:when test="${flight.status eq 'CANCELLED'}">bg-danger</c:when>
                        <c:when test="${flight.status eq 'COMPLETED'}">bg-success</c:when>
                        <c:otherwise>bg-secondary</c:otherwise>
                    </c:choose>">
                    <c:choose>
                        <c:when test="${flight.status eq 'SCHEDULED'}">Đã lên lịch</c:when>
                        <c:when test="${flight.status eq 'DELAYED'}">Trì hoãn</c:when>
                        <c:when test="${flight.status eq 'CANCELLED'}">Đã hủy</c:when>
                        <c:when test="${flight.status eq 'COMPLETED'}">Đã hoàn thành</c:when>
                        <c:otherwise>${flight.status}</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5 class="text-primary">${flight.airline}</h5>
                        <p class="text-muted mb-2">Số hiệu: ${flight.flightNumber}</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <h5 class="text-primary"><fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></h5>
                        <p class="text-muted mb-2">Còn ${flight.availableSeats} ghế trống</p>
                    </div>
                </div>
                
                <div class="flight-path-container mb-4">
                    <div class="row">
                        <div class="col-md-5">
                            <div class="text-center">
                                <h5>${flight.origin}</h5>
                                <p class="mb-0 fs-4 fw-bold"><fmt:formatDate value="${flight.departureTime}" pattern="HH:mm" /></p>
                                <p class="text-muted"><fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy" /></p>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="flight-line position-relative">
                                <hr>
                                <i class="fas fa-plane"></i>
                                <div class="text-center mt-2">
                                    <small class="text-muted"><fmt:formatDate value="${flight.duration}" pattern="HH:mm" /> giờ</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="text-center">
                                <h5>${flight.destination}</h5>
                                <p class="mb-0 fs-4 fw-bold"><fmt:formatDate value="${flight.arrivalTime}" pattern="HH:mm" /></p>
                                <p class="text-muted"><fmt:formatDate value="${flight.arrivalTime}" pattern="dd/MM/yyyy" /></p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-4">
                    <div class="col-12">
                        <h6 class="text-muted mb-3">Thông tin chi tiết</h6>
                        <table class="table table-striped">
                            <tbody>
                                <tr>
                                    <th scope="row" width="30%">ID chuyến bay</th>
                                    <td>${flight.flightId}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Hãng bay</th>
                                    <td>${flight.airline}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Số hiệu</th>
                                    <td>${flight.flightNumber}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Điểm khởi hành</th>
                                    <td>${flight.origin}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Điểm đến</th>
                                    <td>${flight.destination}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Thời gian khởi hành</th>
                                    <td><fmt:formatDate value="${flight.departureTime}" pattern="HH:mm dd/MM/yyyy" /></td>
                                </tr>
                                <tr>
                                    <th scope="row">Thời gian đến</th>
                                    <td><fmt:formatDate value="${flight.arrivalTime}" pattern="HH:mm dd/MM/yyyy" /></td>
                                </tr>
                                <tr>
                                    <th scope="row">Thời gian bay</th>
                                    <td><fmt:formatDate value="${flight.duration}" pattern="HH:mm" /> giờ</td>
                                </tr>
                                <tr>
                                    <th scope="row">Giá vé</th>
                                    <td><fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                </tr>
                                <tr>
                                    <th scope="row">Số ghế trống</th>
                                    <td>${flight.availableSeats}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Trạng thái</th>
                                    <td>
                                        <span class="badge 
                                            <c:choose>
                                                <c:when test="${flight.status eq 'SCHEDULED'}">bg-primary</c:when>
                                                <c:when test="${flight.status eq 'DELAYED'}">bg-warning text-dark</c:when>
                                                <c:when test="${flight.status eq 'CANCELLED'}">bg-danger</c:when>
                                                <c:when test="${flight.status eq 'COMPLETED'}">bg-success</c:when>
                                                <c:otherwise>bg-secondary</c:otherwise>
                                            </c:choose>">
                                            <c:choose>
                                                <c:when test="${flight.status eq 'SCHEDULED'}">Đã lên lịch</c:when>
                                                <c:when test="${flight.status eq 'DELAYED'}">Trì hoãn</c:when>
                                                <c:when test="${flight.status eq 'CANCELLED'}">Đã hủy</c:when>
                                                <c:when test="${flight.status eq 'COMPLETED'}">Đã hoàn thành</c:when>
                                                <c:otherwise>${flight.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 fw-bold text-primary">Thao tác</h6>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/admin/flights/edit?id=${flight.flightId}" class="btn btn-primary btn-block">
                        <i class="fas fa-edit me-2"></i>Chỉnh sửa chuyến bay
                    </a>
                    <a href="javascript:void(0);" onclick="confirmDelete(${flight.flightId}, '${flight.flightNumber}')" class="btn btn-danger btn-block">
                        <i class="fas fa-trash me-2"></i>Xóa chuyến bay
                    </a>
                    <hr>
                    <a href="${pageContext.request.contextPath}/admin/flights" class="btn btn-secondary btn-block">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                    </a>
                </div>
            </div>
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

<style>
.flight-line {
    margin: 25px 0;
}

.flight-line hr {
    margin: 0;
    height: 2px;
    background-color: #ddd;
    width: 100%;
}

.flight-line i {
    position: absolute;
    top: -10px;
    right: 0;
    color: #0d6efd;
    transform: rotate(90deg);
}
</style>

<script>
    function confirmDelete(flightId, flightNumber) {
        document.getElementById('flightToDelete').textContent = flightNumber;
        document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/admin/flights/delete?id=' + flightId;
        var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 