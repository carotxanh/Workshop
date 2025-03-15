<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Quản lý đặt vé" />
</jsp:include>

<div class="container my-5">
    <div class="row">
        <div class="col-lg-10 mx-auto">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Quản lý đặt vé</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                        <i class="fas fa-search me-2"></i>Tìm chuyến bay mới
                    </a>
                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">Danh sách đặt vé của bạn</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty bookings}">
                            <div class="text-center py-5">
                                <i class="fas fa-ticket-alt text-muted mb-3" style="font-size: 3rem;"></i>
                                <h5>Bạn chưa có đặt vé nào</h5>
                                <p class="text-muted">Hãy tìm kiếm và đặt chuyến bay đầu tiên của bạn.</p>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-primary mt-2">
                                    <i class="fas fa-search me-2"></i>Tìm chuyến bay
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Mã đặt vé</th>
                                            <th>Ngày đặt</th>
                                            <th>Chuyến bay</th>
                                            <th>Ngày khởi hành</th>
                                            <th>Trạng thái</th>
                                            <th>Tổng tiền</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${bookings}" var="booking">
                                            <tr>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}" class="text-primary fw-bold">
                                                        ${booking.bookingNumber}
                                                    </a>
                                                </td>
                                                <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy" /></td>
                                                <td>
                                                    <div>${booking.flight.origin} → ${booking.flight.destination}</div>
                                                    <c:if test="${not empty booking.returnFlight}">
                                                        <div class="text-muted small">${booking.returnFlight.origin} → ${booking.returnFlight.destination}</div>
                                                    </c:if>
                                                </td>
                                                <td><fmt:formatDate value="${booking.flight.departureTime}" pattern="dd/MM/yyyy" /></td>
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
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="dropdownMenuButton${booking.bookingId}" data-bs-toggle="dropdown" aria-expanded="false">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton${booking.bookingId}">
                                                            <li>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}">
                                                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}/print" target="_blank">
                                                                    <i class="fas fa-print me-2"></i>In vé điện tử
                                                                </a>
                                                            </li>
                                                            <c:if test="${booking.status ne 'CANCELLED' && booking.flight.status ne 'COMPLETED'}">
                                                                <li><hr class="dropdown-divider"></li>
                                                                <li>
                                                                    <a class="dropdown-item text-danger" href="#" data-bs-toggle="modal" data-bs-target="#cancelModal${booking.bookingId}">
                                                                        <i class="fas fa-times-circle me-2"></i>Hủy đặt vé
                                                                    </a>
                                                                </li>
                                                            </c:if>
                                                        </ul>
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
                                                                    <p class="text-danger">Lưu ý: Việc hoàn tiền sẽ tuân theo chính sách của hãng hàng không và có thể mất phí hủy vé.</p>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                                    <a href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}/cancel" class="btn btn-danger">Xác nhận hủy</a>
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
                                            <a class="page-link" href="${pageContext.request.contextPath}/bookings?page=${currentPage - 1}" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/bookings?page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/bookings?page=${currentPage + 1}" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 