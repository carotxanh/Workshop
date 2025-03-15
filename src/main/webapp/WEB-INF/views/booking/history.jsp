<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Lịch sử đặt vé" />
</jsp:include>

<h2 class="mb-4">Lịch sử đặt vé</h2>

<c:choose>
    <c:when test="${empty bookings}">
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i>Bạn chưa có đặt vé nào. <a href="${pageContext.request.contextPath}/flights/search" class="alert-link">Tìm chuyến bay ngay</a>.
        </div>
    </c:when>
    <c:otherwise>
        <div class="card shadow">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Mã đặt vé</th>
                                <th>Chuyến bay</th>
                                <th>Hành trình</th>
                                <th>Ngày bay</th>
                                <th>Trạng thái</th>
                                <th>Tổng tiền</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                                <tr>
                                    <td>${booking.bookingCode}</td>
                                    <td>${booking.flightNumber}</td>
                                    <td>${booking.origin} - ${booking.destination}</td>
                                    <td><fmt:formatDate value="${booking.departureTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.status eq 'CONFIRMED'}">
                                                <span class="badge bg-success">Đã xác nhận</span>
                                            </c:when>
                                            <c:when test="${booking.status eq 'PENDING'}">
                                                <span class="badge bg-warning text-dark">Chờ thanh toán</span>
                                            </c:when>
                                            <c:when test="${booking.status eq 'CANCELLED'}">
                                                <span class="badge bg-danger">Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${booking.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/bookings/detail?id=${booking.bookingId}" class="btn btn-outline-primary">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <c:if test="${booking.status eq 'PENDING'}">
                                                <a href="${pageContext.request.contextPath}/payment?bookingId=${booking.bookingId}" class="btn btn-outline-success">
                                                    <i class="fas fa-credit-card"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${booking.status eq 'CONFIRMED' && booking.canCancel}">
                                                <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#cancelModal${booking.bookingId}">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                        
                                        <!-- Modal hủy vé -->
                                        <c:if test="${booking.status eq 'CONFIRMED' && booking.canCancel}">
                                            <div class="modal fade" id="cancelModal${booking.bookingId}" tabindex="-1" aria-labelledby="cancelModalLabel${booking.bookingId}" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="cancelModalLabel${booking.bookingId}">Xác nhận hủy vé</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p>Bạn có chắc chắn muốn hủy vé cho chuyến bay ${booking.flightNumber} từ ${booking.origin} đến ${booking.destination} vào ngày <fmt:formatDate value="${booking.departureTime}" pattern="dd/MM/yyyy" />?</p>
                                                            <p class="text-danger">Lưu ý: Việc hủy vé có thể phát sinh phí hủy vé tùy theo chính sách của hãng hàng không.</p>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                            <a href="${pageContext.request.contextPath}/bookings/cancel?id=${booking.bookingId}" class="btn btn-danger">Xác nhận hủy</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 