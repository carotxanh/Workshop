<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Chi tiết đặt vé - Đặt vé máy bay" />
</jsp:include>

<!-- Main Content -->
<div class="container my-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">Chi tiết đặt vé</h2>
                <a href="${pageContext.request.contextPath}/booking?action=list" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </a>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Thông tin đặt vé #${booking.bookingId}</h5>
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
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="fw-bold">Thông tin hành khách</h6>
                            <table class="table table-borderless">
                                <tr>
                                    <td class="text-muted" style="width: 40%">Họ tên:</td>
                                    <td class="fw-medium">${booking.passengerName}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Email:</td>
                                    <td>${booking.passengerEmail}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Số điện thoại:</td>
                                    <td>${booking.passengerPhone}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Ngày đặt vé:</td>
                                    <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold">Thông tin thanh toán</h6>
                            <table class="table table-borderless">
                                <tr>
                                    <td class="text-muted" style="width: 40%">Phương thức:</td>
                                    <td>${booking.paymentMethod}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Trạng thái:</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.paymentStatus eq 'PAID'}">
                                                <span class="badge bg-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning">Chưa thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Tổng tiền:</td>
                                    <td class="fw-bold text-primary"><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0" /> VND</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Thông tin chuyến bay</h5>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="fw-bold">${booking.flight.origin} → ${booking.flight.destination}</h5>
                                    <p class="text-muted mb-0">${booking.flight.airline} | Chuyến bay: ${booking.flight.flightNumber}</p>
                                </div>
                                <div class="text-end">
                                    <h5 class="fw-bold"><fmt:formatDate value="${booking.flight.departureTime}" pattern="HH:mm" /></h5>
                                    <p class="text-muted mb-0"><fmt:formatDate value="${booking.flight.departureTime}" pattern="dd/MM/yyyy" /></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <table class="table table-borderless">
                                <tr>
                                    <td class="text-muted" style="width: 40%">Thời gian khởi hành:</td>
                                    <td><fmt:formatDate value="${booking.flight.departureTime}" pattern="HH:mm, dd/MM/yyyy" /></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Thời gian đến:</td>
                                    <td><fmt:formatDate value="${booking.flight.arrivalTime}" pattern="HH:mm, dd/MM/yyyy" /></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Thời gian bay:</td>
                                    <td>${booking.flight.duration}</td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="table table-borderless">
                                <tr>
                                    <td class="text-muted" style="width: 40%">Số ghế:</td>
                                    <td class="fw-medium">${booking.seatNumber}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Trạng thái:</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.flight.status eq 'SCHEDULED'}">
                                                <span class="badge bg-primary">Đã lên lịch</span>
                                            </c:when>
                                            <c:when test="${booking.flight.status eq 'ON_TIME'}">
                                                <span class="badge bg-success">Đúng giờ</span>
                                            </c:when>
                                            <c:when test="${booking.flight.status eq 'DELAYED'}">
                                                <span class="badge bg-warning">Trễ chuyến</span>
                                            </c:when>
                                            <c:when test="${booking.flight.status eq 'CANCELLED'}">
                                                <span class="badge bg-danger">Đã hủy</span>
                                            </c:when>
                                            <c:when test="${booking.flight.status eq 'COMPLETED'}">
                                                <span class="badge bg-info">Hoàn thành</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="mt-4">
                <c:if test="${booking.status eq 'PENDING' || booking.status eq 'CONFIRMED'}">
                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelModal">
                        <i class="fas fa-times-circle me-2"></i>Hủy đặt vé
                    </button>
                </c:if>
            </div>
            
            <!-- Cancel Modal -->
            <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
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
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" /> 