<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Chi tiết đặt vé" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Chi tiết đặt vé</h2>
    <div>
        <a href="${pageContext.request.contextPath}/bookings" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
        <c:if test="${booking.status eq 'CONFIRMED'}">
            <a href="${pageContext.request.contextPath}/bookings/detail?id=${booking.bookingId}&download=true" class="btn btn-primary ms-2">
                <i class="fas fa-download me-2"></i>Tải vé điện tử
            </a>
        </c:if>
    </div>
</div>

<div class="row">
    <div class="col-lg-8">
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Thông tin chuyến bay</h3>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-3 text-center">
                        <c:choose>
                            <c:when test="${flight.airline eq 'Vietnam Airlines'}">
                                <img src="${pageContext.request.contextPath}/resources/images/vietnam-airlines.png" alt="Vietnam Airlines" class="img-fluid" style="max-height: 60px;">
                            </c:when>
                            <c:when test="${flight.airline eq 'Vietjet Air'}">
                                <img src="${pageContext.request.contextPath}/resources/images/vietjet.png" alt="Vietjet Air" class="img-fluid" style="max-height: 60px;">
                            </c:when>
                            <c:when test="${flight.airline eq 'Bamboo Airways'}">
                                <img src="${pageContext.request.contextPath}/resources/images/bamboo.png" alt="Bamboo Airways" class="img-fluid" style="max-height: 60px;">
                            </c:when>
                            <c:otherwise>
                                <div class="fw-bold fs-4">${flight.airline}</div>
                            </c:otherwise>
                        </c:choose>
                        <div class="mt-2">${flight.flightNumber}</div>
                    </div>
                    <div class="col-md-9">
                        <div class="row">
                            <div class="col-md-5">
                                <div class="fs-4 fw-bold">
                                    <fmt:formatDate value="${flight.departureTime}" pattern="HH:mm" />
                                </div>
                                <div class="fs-5">${flight.origin}</div>
                                <div class="text-muted">
                                    <fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy" />
                                </div>
                            </div>
                            <div class="col-md-2 text-center">
                                <div class="flight-duration">
                                    <div class="text-muted small">
                                        <fmt:formatDate value="${flight.duration}" pattern="HH:mm" /> giờ
                                    </div>
                                    <div class="flight-path">
                                        <i class="fas fa-plane"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <div class="fs-4 fw-bold">
                                    <fmt:formatDate value="${flight.arrivalTime}" pattern="HH:mm" />
                                </div>
                                <div class="fs-5">${flight.destination}</div>
                                <div class="text-muted">
                                    <fmt:formatDate value="${flight.arrivalTime}" pattern="dd/MM/yyyy" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <hr>
                
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Ghế:</strong> ${booking.seatNumber}</p>
                        <p><strong>Hạng ghế:</strong> ${booking.seatClass}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Trạng thái:</strong> 
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
                        </p>
                        <p><strong>Mã đặt vé:</strong> ${booking.bookingCode}</p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Thông tin hành khách</h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Họ và tên:</strong> ${booking.passengerName}</p>
                        <p><strong>Email:</strong> ${booking.passengerEmail}</p>
                        <p><strong>Số điện thoại:</strong> ${booking.passengerPhone}</p>
                    </div>
                    <div class="col-md-6">
                        <c:if test="${not empty booking.specialRequests}">
                            <p><strong>Yêu cầu đặc biệt:</strong></p>
                            <p>${booking.specialRequests}</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        
        <c:if test="${booking.status eq 'CONFIRMED'}">
            <div class="card shadow mb-4">
                <div class="card-header bg-primary text-white">
                    <h3 class="card-title mb-0">Thông tin thanh toán</h3>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Phương thức thanh toán:</strong> 
                                <c:choose>
                                    <c:when test="${payment.paymentMethod eq 'CREDIT_CARD'}">Thẻ tín dụng/Thẻ ghi nợ</c:when>
                                    <c:when test="${payment.paymentMethod eq 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                                    <c:when test="${payment.paymentMethod eq 'MOMO'}">Ví MoMo</c:when>
                                    <c:otherwise>${payment.paymentMethod}</c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>Mã giao dịch:</strong> ${payment.transactionId}</p>
                            <p><strong>Ngày thanh toán:</strong> <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                        </div>
                        <div class="col-md-6 text-end">
                            <p><strong>Tổng tiền:</strong> <span class="text-primary fw-bold fs-4">
                                <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                            </span></p>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <c:if test="${booking.status eq 'PENDING'}">
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle me-2"></i>Đơn đặt vé của bạn đang chờ thanh toán. Vui lòng thanh toán để hoàn tất đặt vé.
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/payment?bookingId=${booking.bookingId}" class="btn btn-primary">
                        <i class="fas fa-credit-card me-2"></i>Thanh toán ngay
                    </a>
                </div>
            </div>
        </c:if>
        
        <c:if test="${booking.status eq 'CONFIRMED' && booking.canCancel}">
            <div class="card shadow mb-4">
                <div class="card-header bg-danger text-white">
                    <h3 class="card-title mb-0">Hủy đặt vé</h3>
                </div>
                <div class="card-body">
                    <p>Nếu bạn muốn hủy đặt vé, vui lòng nhấn vào nút bên dưới.</p>
                    <p class="text-danger">Lưu ý: Việc hủy vé có thể phát sinh phí hủy vé tùy theo chính sách của hãng hàng không.</p>
                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelModal">
                        <i class="fas fa-times me-2"></i>Hủy đặt vé
                    </button>
                    
                    <!-- Modal hủy vé -->
                    <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="cancelModalLabel">Xác nhận hủy vé</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Bạn có chắc chắn muốn hủy vé cho chuyến bay ${flight.flightNumber} từ ${flight.origin} đến ${flight.destination} vào ngày <fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy" />?</p>
                                    <p class="text-danger">Lưu ý: Việc hủy vé có thể phát sinh phí hủy vé tùy theo chính sách của hãng hàng không.</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    <a href="${pageContext.request.contextPath}/bookings/cancel?id=${booking.bookingId}" class="btn btn-danger">Xác nhận hủy</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
    
    <div class="col-lg-4">
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Thông tin sân bay</h3>
            </div>
            <div class="card-body">
                <h5>Sân bay đi: ${flight.originAirport}</h5>
                <p><i class="fas fa-map-marker-alt me-2"></i>${flight.originAddress}</p>
                <p><i class="fas fa-phone me-2"></i>${flight.originPhone}</p>
                <hr>
                <h5>Sân bay đến: ${flight.destinationAirport}</h5>
                <p><i class="fas fa-map-marker-alt me-2"></i>${flight.destinationAddress}</p>
                <p><i class="fas fa-phone me-2"></i>${flight.destinationPhone}</p>
            </div>
        </div>
        
        <div class="card shadow">
            <div class="card-body">
                <h5 class="card-title">Lưu ý</h5>
                <ul class="mb-0">
                    <li>Vui lòng có mặt tại sân bay trước giờ khởi hành ít nhất 2 tiếng</li>
                    <li>Mang theo giấy tờ tùy thân (CMND/CCCD/Hộ chiếu) khi làm thủ tục</li>
                    <li>Kiểm tra kỹ hành lý trước khi lên máy bay</li>
                    <li>Nếu có thay đổi lịch bay, chúng tôi sẽ thông báo qua email và số điện thoại của bạn</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 