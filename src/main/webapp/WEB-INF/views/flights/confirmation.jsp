<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Xác nhận đặt vé" />
</jsp:include>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm mb-4">
                <div class="card-body text-center py-5">
                    <div class="mb-4">
                        <i class="fas fa-check-circle text-success" style="font-size: 5rem;"></i>
                    </div>
                    <h2 class="mb-3">Đặt vé thành công!</h2>
                    <p class="lead mb-4">Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi. Vé điện tử đã được gửi đến email của bạn.</p>
                    <div class="d-flex justify-content-center mb-4">
                        <div class="bg-light p-3 rounded">
                            <p class="mb-1">Mã đặt vé của bạn</p>
                            <h3 class="mb-0 text-primary">${booking.bookingNumber}</h3>
                        </div>
                    </div>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}" class="btn btn-primary">
                            <i class="fas fa-ticket-alt me-2"></i>Xem chi tiết đặt vé
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                            <i class="fas fa-home me-2"></i>Về trang chủ
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">Thông tin chuyến bay</h5>
                </div>
                <div class="card-body">
                    <!-- Chuyến bay đi -->
                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="mb-0">Chuyến bay đi</h6>
                            <span class="badge bg-success">${booking.status}</span>
                        </div>
                        
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
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Chuyến bay về (nếu có) -->
                    <c:if test="${not empty booking.returnFlight}">
                        <div class="mb-4">
                            <h6 class="mb-3">Chuyến bay về</h6>
                            
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
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Thông tin hành khách -->
                    <div class="mb-4">
                        <h6 class="mb-3">Thông tin hành khách</h6>
                        
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>Họ tên</th>
                                        <th>Loại hành khách</th>
                                        <th>Số hộ chiếu</th>
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
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <!-- Thông tin liên hệ -->
                    <div class="mb-4">
                        <h6 class="mb-3">Thông tin liên hệ</h6>
                        
                        <div class="card">
                            <div class="card-body">
                                <p class="mb-1"><strong>Họ tên:</strong> ${booking.contactName}</p>
                                <p class="mb-1"><strong>Email:</strong> ${booking.contactEmail}</p>
                                <p class="mb-1"><strong>Điện thoại:</strong> ${booking.contactPhone}</p>
                                <p class="mb-0"><strong>Địa chỉ:</strong> ${booking.contactAddress}</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thông tin thanh toán -->
                    <div>
                        <h6 class="mb-3">Thông tin thanh toán</h6>
                        
                        <div class="card">
                            <div class="card-body">
                                <p class="mb-1"><strong>Phương thức thanh toán:</strong> 
                                    <c:choose>
                                        <c:when test="${booking.paymentMethod eq 'CREDIT_CARD'}">Thẻ tín dụng/ghi nợ</c:when>
                                        <c:when test="${booking.paymentMethod eq 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                                        <c:when test="${booking.paymentMethod eq 'MOMO'}">Ví điện tử MoMo</c:when>
                                    </c:choose>
                                </p>
                                <p class="mb-1"><strong>Trạng thái thanh toán:</strong> 
                                    <span class="badge bg-success">Đã thanh toán</span>
                                </p>
                                <p class="mb-1"><strong>Ngày thanh toán:</strong> <fmt:formatDate value="${booking.paymentDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                                
                                <div class="d-flex justify-content-between fw-bold mt-3 pt-3 border-top">
                                    <span>Tổng cộng</span>
                                    <span><fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}/print" class="btn btn-outline-primary" target="_blank">
                    <i class="fas fa-print me-2"></i>In vé điện tử
                </a>
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