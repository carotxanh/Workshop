<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Quản lý chuyến bay" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản lý chuyến bay</h2>
    <div>
        <a href="${pageContext.request.contextPath}/admin/flights/create" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Thêm chuyến bay
        </a>
    </div>
</div>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Danh sách chuyến bay</h6>
    </div>
    <div class="card-body">
        <div class="mb-3">
            <form action="${pageContext.request.contextPath}/admin/flights" method="get" class="row g-3">
                <div class="col-md-3">
                    <label for="flightNumber" class="form-label">Mã chuyến bay</label>
                    <input type="text" class="form-control" id="flightNumber" name="flightNumber" value="${param.flightNumber}">
                </div>
                <div class="col-md-3">
                    <label for="airline" class="form-label">Hãng hàng không</label>
                    <select class="form-select" id="airline" name="airline">
                        <option value="">-- Tất cả --</option>
                        <option value="Vietnam Airlines" ${param.airline eq 'Vietnam Airlines' ? 'selected' : ''}>Vietnam Airlines</option>
                        <option value="Vietjet Air" ${param.airline eq 'Vietjet Air' ? 'selected' : ''}>Vietjet Air</option>
                        <option value="Bamboo Airways" ${param.airline eq 'Bamboo Airways' ? 'selected' : ''}>Bamboo Airways</option>
                        <option value="Pacific Airlines" ${param.airline eq 'Pacific Airlines' ? 'selected' : ''}>Pacific Airlines</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="status" class="form-label">Trạng thái</label>
                    <select class="form-select" id="status" name="status">
                        <option value="">-- Tất cả --</option>
                        <option value="SCHEDULED" ${param.status eq 'SCHEDULED' ? 'selected' : ''}>Đã lên lịch</option>
                        <option value="DELAYED" ${param.status eq 'DELAYED' ? 'selected' : ''}>Bị trì hoãn</option>
                        <option value="CANCELLED" ${param.status eq 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        <option value="COMPLETED" ${param.status eq 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="departureDate" class="form-label">Ngày khởi hành</label>
                    <input type="date" class="form-control" id="departureDate" name="departureDate" value="${param.departureDate}">
                </div>
                <div class="col-12 mt-3">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search me-2"></i>Tìm kiếm
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/flights" class="btn btn-secondary">
                        <i class="fas fa-redo me-2"></i>Đặt lại
                    </a>
                </div>
            </form>
        </div>
        
        <div class="table-responsive">
            <table class="table table-bordered" id="flightsTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Mã chuyến bay</th>
                        <th>Hãng hàng không</th>
                        <th>Từ - Đến</th>
                        <th>Khởi hành</th>
                        <th>Đến</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${flights}" var="flight">
                        <tr>
                            <td>${flight.flightNumber}</td>
                            <td>${flight.airline}</td>
                            <td>${flight.origin} - ${flight.destination}</td>
                            <td><fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td><fmt:formatDate value="${flight.arrivalTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${flight.status eq 'SCHEDULED'}">
                                        <span class="badge bg-success">Đã lên lịch</span>
                                    </c:when>
                                    <c:when test="${flight.status eq 'DELAYED'}">
                                        <span class="badge bg-warning">Trì hoãn</span>
                                    </c:when>
                                    <c:when test="${flight.status eq 'CANCELLED'}">
                                        <span class="badge bg-danger">Đã hủy</span>
                                    </c:when>
                                    <c:when test="${flight.status eq 'COMPLETED'}">
                                        <span class="badge bg-info">Đã hoàn thành</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${flight.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex">
                                    <a href="${pageContext.request.contextPath}/admin/flights/edit?id=${flight.flightId}" class="btn btn-sm btn-primary me-2">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal${flight.flightId}">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                    
                                    <!-- Modal xác nhận xóa -->
                                    <div class="modal fade" id="deleteModal${flight.flightId}" tabindex="-1" aria-labelledby="deleteModalLabel${flight.flightId}" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="deleteModalLabel${flight.flightId}">Xác nhận xóa</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    Bạn có chắc chắn muốn xóa chuyến bay <strong>${flight.flightNumber}</strong> không?
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                    <a href="${pageContext.request.contextPath}/admin/flights/delete?id=${flight.flightId}" class="btn btn-danger">Xác nhận xóa</a>
                                                </div>
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
        
        <!-- Phân trang -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/flights?page=${currentPage - 1}&flightNumber=${param.flightNumber}&airline=${param.airline}&status=${param.status}&departureDate=${param.departureDate}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/flights?page=${i}&flightNumber=${param.flightNumber}&airline=${param.airline}&status=${param.status}&departureDate=${param.departureDate}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/flights?page=${currentPage + 1}&flightNumber=${param.flightNumber}&airline=${param.airline}&status=${param.status}&departureDate=${param.departureDate}" aria-label="Next">
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
    $('#flightsTable').DataTable({
        "paging": false,
        "searching": false,
        "language": {
            "emptyTable": "Không có dữ liệu",
            "info": "Hiển thị _START_ đến _END_ của _TOTAL_ chuyến bay",
            "infoEmpty": "Hiển thị 0 đến 0 của 0 chuyến bay",
            "zeroRecords": "Không tìm thấy chuyến bay nào phù hợp"
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 