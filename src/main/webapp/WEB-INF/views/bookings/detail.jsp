<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Chi tiết đặt vé" />
</jsp:include>

<div class="container my-5">
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Chi tiết đặt vé</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/bookings" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">Thông tin đặt vé #${booking.bookingNumber}</h5>
                        <span class="badge bg-light text-primary">${booking.status}</span>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <p class="mb-1"><strong>Ngày đặt vé:</strong> <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                            <p class="mb-0"><strong>Trạng thái:</strong> 
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
                            </p>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <p class="mb-1"><strong>Tổng tiền:</strong> <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></p>
                            <p class="mb-0"><strong>Phương thức thanh toán:</strong> 
                                <c:choose>
                                    <c:when test="${booking.paymentMethod eq 'CREDIT_CARD'}">Thẻ tín dụng/ghi nợ</c:when>
                                    <c:when test="${booking.paymentMethod eq 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                                    <c:when test="${booking.paymentMethod eq 'MOMO'}">Ví điện tử MoMo</c:when>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    
                    <!-- Chuyến bay đi -->
                    <div class="mb-4">
                        <h6 class="border-bottom pb-2 mb-3">Chuyến bay đi</h6>
                        
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <p class="mb-0 fw-bold">${booking.flight.airline}</p>
                                        <p class="mb-0 text-muted small">${booking.flight.flightNumber}</p>
                                    </div>
                                    <div class="text-end">
                                        <p class="mb-0 text-muted small">
                                            <fmt:formatDate value="${booking.flight.departureTime}" pattern="EEE, dd/MM/yyyy" />
                                        </p>
                                    </div>
                                </div>
                                
                                <div class="d-flex mt-3">
                                    <div class="me-3 text-center">
                                        <p class="mb-0 fw-bold"><fmt:formatDate value="${booking.flight.departureTime}" pattern="HH:mm" /></p>
                                        <p class="mb-0 text-muted small">${booking.flight.origin}</p>
                                    </div>
                                    <div class="flex-grow-1 px-2">
                                        <div class="flight-line">
                                            <i class="fas fa-plane"></i>
                                        </div>
                                        <p class="text-center text-muted small mb-0">
                                            <c:set var="durationMinutes" value="${(booking.flight.arrivalTime.time - booking.flight.departureTime.time) / 60000}" />
                                            <fmt:formatNumber value="${durationMinutes / 60}" pattern="#" var="hours" />
                                            <fmt:formatNumber value="${durationMinutes % 60}" pattern="#" var="minutes" />
                                            ${hours}h ${minutes}m
                                        </p>
                                    </div>
                                    <div class="ms-3 text-center">
                                        <p class="mb-0 fw-bold"><fmt:formatDate value="${booking.flight.arrivalTime}" pattern="HH:mm" /></p>
                                        <p class="mb-0 text-muted small">${booking.flight.destination}</p>
                                    </div>
                                </div>
                                
                                <div class="mt-3 pt-3 border-top">
                                    <p class="mb-1"><strong>Hạng vé:</strong> 
                                        <c:choose>
                                            <c:when test="${booking.cabinClass eq 'ECONOMY'}">Phổ thông</c:when>
                                            <c:when test="${booking.cabinClass eq 'BUSINESS'}">Thương gia</c:when>
                                            <c:when test="${booking.cabinClass eq 'FIRST'}">Hạng nhất</c:when>
                                        </c:choose>
                                    </p>
                                    <p class="mb-0"><strong>Trạng thái chuyến bay:</strong> 
                                        <c:choose>
                                            <c:when test="${booking.flight.status eq 'SCHEDULED'}">
                                                <span class="badge bg-primary">Đã lên lịch</span>
                                            </c:when>
                                            <c:when test="${booking.flight.status eq 'DELAYED'}">
                                                <span class="badge bg-warning text-dark">Bị trì hoãn</span>
                                            </c:when>
                                            <c:when test="${booking.flight.status eq 'CANCELLED'}">
                                                <span class="badge bg-danger">Đã hủy</span>
                                            </c:when>
                                            <c:when test="${booking.flight.status eq 'COMPLETED'}">
                                                <span class="badge bg-success">Đã hoàn thành</span>
                                            </c:when>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Chuyến bay về (nếu có) -->
                    <c:if test="${not empty booking.returnFlight}">
                        <div class="mb-4">
                            <h6 class="border-bottom pb-2 mb-3">Chuyến bay về</h6>
                            
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <p class="mb-0 fw-bold">${booking.returnFlight.airline}</p>
                                            <p class="mb-0 text-muted small">${booking.returnFlight.flightNumber}</p>
                                        </div>
                                        <div class="text-end">
                                            <p class="mb-0 text-muted small">
                                                <fmt:formatDate value="${booking.returnFlight.departureTime}" pattern="EEE, dd/MM/yyyy" />
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex mt-3">
                                        <div class="me-3 text-center">
                                            <p class="mb-0 fw-bold"><fmt:formatDate value="${booking.returnFlight.departureTime}" pattern="HH:mm" /></p>
                                            <p class="mb-0 text-muted small">${booking.returnFlight.origin}</p>
                                        </div>
                                        <div class="flex-grow-1 px-2">
                                            <div class="flight-line">
                                                <i class="fas fa-plane"></i>
                                            </div>
                                            <p class="text-center text-muted small mb-0">
                                                <c:set var="returnDurationMinutes" value="${(booking.returnFlight.arrivalTime.time - booking.returnFlight.departureTime.time) / 60000}" />
                                                <fmt:formatNumber value="${returnDurationMinutes / 60}" pattern="#" var="returnHours" />
                                                <fmt:formatNumber value="${returnDurationMinutes % 60}" pattern="#" var="returnMinutes" />
                                                ${returnHours}h ${returnMinutes}m
                                            </p>
                                        </div>
                                        <div class="ms-3 text-center">
                                            <p class="mb-0 fw-bold"><fmt:formatDate value="${booking.returnFlight.arrivalTime}" pattern="HH:mm" /></p>
                                            <p class="mb-0 text-muted small">${booking.returnFlight.destination}</p>
                                        </div>
                                    </div>
                                    
                                    <div class="mt-3 pt-3 border-top">
                                        <p class="mb-1"><strong>Hạng vé:</strong> 
                                            <c:choose>
                                                <c:when test="${booking.cabinClass eq 'ECONOMY'}">Phổ thông</c:when>
                                                <c:when test="${booking.cabinClass eq 'BUSINESS'}">Thương gia</c:when>
                                                <c:when test="${booking.cabinClass eq 'FIRST'}">Hạng nhất</c:when>
                                            </c:choose>
                                        </p>
                                        <p class="mb-0"><strong>Trạng thái chuyến bay:</strong> 
                                            <c:choose>
                                                <c:when test="${booking.returnFlight.status eq 'SCHEDULED'}">
                                                    <span class="badge bg-primary">Đã lên lịch</span>
                                                </c:when>
                                                <c:when test="${booking.returnFlight.status eq 'DELAYED'}">
                                                    <span class="badge bg-warning text-dark">Bị trì hoãn</span>
                                                </c:when>
                                                <c:when test="${booking.returnFlight.status eq 'CANCELLED'}">
                                                    <span class="badge bg-danger">Đã hủy</span>
                                                </c:when>
                                                <c:when test="${booking.returnFlight.status eq 'COMPLETED'}">
                                                    <span class="badge bg-success">Đã hoàn thành</span>
                                                </c:when>
                                            </c:choose>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Thông tin hành khách -->
                    <div class="mb-4">
                        <h6 class="border-bottom pb-2 mb-3">Thông tin hành khách</h6>
                        
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>Họ tên</th>
                                        <th>Loại hành khách</th>
                                        <th>Số hộ chiếu</th>
                                        <th>Quốc tịch</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${booking.passengers}" var="passenger">
                                        <tr>
                                            <td>${passenger.title} ${passenger.firstName} ${passenger.lastName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${passenger.passengerType eq 'ADULT'}">Người lớn</c:when>
                                                    <c:when test="${passenger.passengerType eq 'CHILD'}">Trẻ em</c:when>
                                                    <c:when test="${passenger.passengerType eq 'INFANT'}">Em bé</c:when>
                                                </c:choose>
                                            </td>
                                            <td>${passenger.passportNumber}</td>
                                            <td>${passenger.nationality}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <!-- Thông tin liên hệ -->
                    <div class="mb-4">
                        <h6 class="border-bottom pb-2 mb-3">Thông tin liên hệ</h6>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Họ tên:</strong> ${booking.contactName}</p>
                                <p class="mb-1"><strong>Email:</strong> ${booking.contactEmail}</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Điện thoại:</strong> ${booking.contactPhone}</p>
                                <p class="mb-1"><strong>Địa chỉ:</strong> ${booking.contactAddress}</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Chi tiết thanh toán -->
                    <div>
                        <h6 class="border-bottom pb-2 mb-3">Chi tiết thanh toán</h6>
                        
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <tbody>
                                    <tr>
                                        <td>Giá vé (${booking.passengers.size()} hành khách)</td>
                                        <td class="text-end"><fmt:formatNumber value="${booking.basePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    </tr>
                                    <tr>
                                        <td>Thuế và phí</td>
                                        <td class="text-end"><fmt:formatNumber value="${booking.taxAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    </tr>
                                    <c:if test="${not empty booking.discountAmount && booking.discountAmount > 0}">
                                        <tr>
                                            <td>Giảm giá</td>
                                            <td class="text-end text-danger">-<fmt:formatNumber value="${booking.discountAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        </tr>
                                    </c:if>
                                    <tr class="table-primary">
                                        <th>Tổng cộng</th>
                                        <th class="text-end"><fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></th>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <!-- Nút hành động -->
                    <div class="mt-4 d-flex justify-content-between">
                        <div>
                            <c:if test="${booking.status ne 'CANCELLED' && booking.flight.status ne 'COMPLETED'}">
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelBookingModal">
                                    <i class="fas fa-times-circle me-2"></i>Hủy đặt vé
                                </button>
                            </c:if>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}/print" class="btn btn-outline-primary" target="_blank">
                                <i class="fas fa-print me-2"></i>In vé điện tử
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal xác nhận hủy đặt vé -->
<div class="modal fade" id="cancelBookingModal" tabindex="-1" aria-labelledby="cancelBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="cancelBookingModalLabel">Xác nhận hủy đặt vé</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn hủy đặt vé này không?</p>
                <p class="text-danger">Lưu ý: Việc hoàn tiền sẽ tuân theo chính sách của hãng hàng không và có thể mất phí hủy vé.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <a href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}/cancel" class="btn btn-danger">Xác nhận hủy</a>
            </div>
        </div>
    </div>
</div>

<style>
.flight-line {
    position: relative;
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

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 