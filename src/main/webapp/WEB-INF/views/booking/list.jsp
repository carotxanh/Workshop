<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Danh sách đặt vé - Đặt vé máy bay" />
</jsp:include>

<!-- Main Content -->
<div class="container my-5">
    <div class="row">
        <div class="col-12">
            <h2 class="mb-4 text-center fw-bold">Danh sách đặt vé của bạn</h2>
            
            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("success"); %>
            </c:if>
            
            <div class="card shadow-sm">
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty bookings}">
                            <div class="text-center py-5">
                                <i class="fas fa-ticket-alt fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">Bạn chưa có đặt vé nào</h4>
                                <p class="mb-4">Hãy đặt vé ngay để trải nghiệm dịch vụ của chúng tôi</p>
                                <a href="${pageContext.request.contextPath}/booking?action=flights" class="btn btn-primary">
                                    <i class="fas fa-search me-2"></i>Tìm chuyến bay
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr class="fw-medium">
                                            <th>Mã đặt vé</th>
                                            <th>Mã chuyến bay</th>
                                            <th>Ghế</th>
                                            <th>Ngày bay</th>
                                            <th>Giờ bay</th>
                                            <th>Hành khách</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${bookings}" var="booking">
                                            <tr>
                                                <td class="fw-medium">${booking.bookingId}</td>
                                                <td>${booking.flight.flightNumber}</td>
                                                <td>${booking.seatNumber}</td>
                                                <td><fmt:formatDate value="${booking.flight.departureTime}" pattern="dd/MM/yyyy" /></td>
                                                <td><fmt:formatDate value="${booking.flight.departureTime}" pattern="HH:mm" /></td>
                                                <td>${booking.passengerName}</td>
                                                <td class="fw-medium text-primary"><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0" /> VND</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${booking.status eq 'PENDING'}">
                                                            <span class="badge bg-warning">Chờ xác nhận</span>
                                                        </c:when>
                                                        <c:when test="${booking.status eq 'CONFIRMED'}">
                                                            <span class="badge bg-success">Đã xác nhận</span>
                                                        </c:when>
                                                        <c:when test="${booking.status eq 'CANCELLED'}">
                                                            <span class="badge bg-danger">Đã hủy</span>
                                                        </c:when>
                                                        <c:when test="${booking.status eq 'COMPLETED'}">
                                                            <span class="badge bg-info">Hoàn thành</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-2">
                                                        <a href="${pageContext.request.contextPath}/booking?action=detail&id=${booking.bookingId}" 
                                                           class="btn btn-sm btn-outline-primary" title="Chi tiết">
                                                            <i class="fas fa-info-circle"></i>
                                                        </a>
                                                        
                                                        <c:if test="${booking.status eq 'PENDING' || booking.status eq 'CONFIRMED'}">
                                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                    data-bs-toggle="modal" data-bs-target="#cancelModal${booking.bookingId}" 
                                                                    title="Hủy đặt vé">
                                                                <i class="fas fa-times-circle"></i>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                    
                                                    <!-- Cancel Modal -->
                                                    <div class="modal fade" id="cancelModal${booking.bookingId}" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="cancelModalLabel">Xác nhận hủy đặt vé</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <p>Bạn có chắc chắn muốn hủy đặt vé này không?</p>
                                                                    <p class="text-danger">Lưu ý: Hành động này không thể hoàn tác.</p>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                                    <a href="${pageContext.request.contextPath}/booking?action=cancel&id=${booking.bookingId}" class="btn btn-danger">Xác nhận hủy</a>
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
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" /> 