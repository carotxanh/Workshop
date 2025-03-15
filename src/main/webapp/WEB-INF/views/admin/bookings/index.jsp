<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Quản lý đặt vé" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản lý đặt vé</h2>
</div>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Danh sách đặt vé</h6>
    </div>
    <div class="card-body">
        <div class="mb-3">
            <form action="${pageContext.request.contextPath}/admin/bookings" method="get" class="row g-3">
                <div class="col-md-3">
                    <label for="bookingNumber" class="form-label">Mã đặt vé</label>
                    <input type="text" class="form-control" id="bookingNumber" name="bookingNumber" value="${param.bookingNumber}">
                </div>
                <div class="col-md-3">
                    <label for="contactName" class="form-label">Tên khách hàng</label>
                    <input type="text" class="form-control" id="contactName" name="contactName" value="${param.contactName}">
                </div>
                <div class="col-md-3">
                    <label for="status" class="form-label">Trạng thái</label>
                    <select class="form-select" id="status" name="status">
                        <option value="">-- Tất cả --</option>
                        <option value="CONFIRMED" ${param.status eq 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="PENDING" ${param.status eq 'PENDING' ? 'selected' : ''}>Đang chờ xử lý</option>
                        <option value="CANCELLED" ${param.status eq 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="bookingDate" class="form-label">Ngày đặt vé</label>
                    <input type="date" class="form-control" id="bookingDate" name="bookingDate" value="${param.bookingDate}">
                </div>
                <div class="col-12 mt-3">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search me-2"></i>Tìm kiếm
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-secondary">
                        <i class="fas fa-redo me-2"></i>Đặt lại
                    </a>
                </div>
            </form>
        </div>
        
        <div class="table-responsive">
            <table class="table table-bordered" id="bookingsTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Mã đặt vé</th>
                        <th>Ngày đặt</th>
                        <th>Khách hàng</th>
                        <th>Chuyến bay</th>
                        <th>Ngày khởi hành</th>
                        <th>Trạng thái</th>
                        <th>Tổng tiền</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${bookings}" var="booking">
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/bookings/${booking.bookingNumber}" class="text-primary fw-bold">
                                    ${booking.bookingNumber}
                                </a>
                            </td>
                            <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td>
                                <div>${booking.contactName}</div>
                                <div class="small text-muted">${booking.contactEmail}</div>
                            </td>
                            <td>
                                <div>${booking.flight.flightNumber} (${booking.flight.origin} → ${booking.flight.destination})</div>
                                <c:if test="${not empty booking.returnFlight}">
                                    <div class="small text-muted">${booking.returnFlight.flightNumber} (${booking.returnFlight.origin} → ${booking.returnFlight.destination})</div>
                                </c:if>
                            </td>
                            <td><fmt:formatDate value="${booking.flight.departureTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${booking.status eq 'CONFIRMED'}">
                                        <span class="badge bg-success">Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${booking.status eq 'PENDING'}">
                                        <span class="badge bg-warning text-dark">Đang chờ xử lý</span>
                                    </c:when>
                                    <c:when test="${booking.status eq 'CANCELLED'}">
                                        <span class="badge bg-danger">Đã hủy</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td><fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            <td>
                                <div class="d-flex">
                                    <a href="${pageContext.request.contextPath}/admin/bookings/${booking.bookingNumber}" class="btn btn-sm btn-primary me-1" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <c:if test="${booking.status eq 'PENDING'}">
                                        <a href="${pageContext.request.contextPath}/admin/bookings/${booking.bookingNumber}/confirm" class="btn btn-sm btn-success me-1" title="Xác nhận đặt vé">
                                            <i class="fas fa-check"></i>
                                        </a>
                                    </c:if>
                                    <c:if test="${booking.status ne 'CANCELLED'}">
                                        <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#cancelModal${booking.bookingId}" title="Hủy đặt vé">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </c:if>
                                </div>
                                
                                <!-- Modal xác nhận hủy -->
                                <div class="modal fade" id="cancelModal${booking.bookingId}" tabindex="-1" aria-labelledby="cancelModalLabel${booking.bookingId}" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="cancelModalLabel${booking.bookingId}">Xác nhận hủy đặt vé</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>Bạn có chắc chắn muốn hủy đặt vé <strong>${booking.bookingNumber}</strong> không?</p>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                <a href="${pageContext.request.contextPath}/admin/bookings/${booking.bookingNumber}/cancel" class="btn btn-danger">Xác nhận hủy</a>
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
            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/bookings?page=${currentPage - 1}&bookingNumber=${param.bookingNumber}&contactName=${param.contactName}&status=${param.status}&bookingDate=${param.bookingDate}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/bookings?page=${i}&bookingNumber=${param.bookingNumber}&contactName=${param.contactName}&status=${param.status}&bookingDate=${param.bookingDate}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/bookings?page=${currentPage + 1}&bookingNumber=${param.bookingNumber}&contactName=${param.contactName}&status=${param.status}&bookingDate=${param.bookingDate}" aria-label="Next">
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
    $('#bookingsTable').DataTable({
        "paging": false,
        "searching": false,
        "language": {
            "emptyTable": "Không có dữ liệu",
            "info": "Hiển thị _START_ đến _END_ của _TOTAL_ đặt vé",
            "infoEmpty": "Hiển thị 0 đến 0 của 0 đặt vé",
            "zeroRecords": "Không tìm thấy đặt vé nào phù hợp"
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 