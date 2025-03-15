<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Thanh toán thành công" />
</jsp:include>

<div class="text-center mb-5">
    <div class="display-1 text-success mb-3">
        <i class="fas fa-check-circle"></i>
    </div>
    <h1 class="display-4 mb-3">Thanh toán thành công!</h1>
    <p class="lead">Cảm ơn bạn đã đặt vé. Vé điện tử đã được gửi đến email của bạn.</p>
</div>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Thông tin đặt vé</h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Mã đặt vé:</strong> ${booking.bookingCode}</p>
                        <p><strong>Trạng thái:</strong> <span class="badge bg-success">Đã thanh toán</span></p>
                        <p><strong>Hành khách:</strong> ${booking.passengerName}</p>
                        <p><strong>Email:</strong> ${booking.passengerEmail}</p>
                        <p><strong>Số điện thoại:</strong> ${booking.passengerPhone}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Chuyến bay:</strong> ${flight.flightNumber}</p>
                        <p><strong>Hành trình:</strong> ${flight.origin} - ${flight.destination}</p>
                        <p><strong>Ngày bay:</strong> <fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy" /></p>
                        <p><strong>Giờ bay:</strong> <fmt:formatDate value="${flight.departureTime}" pattern="HH:mm" /></p>
                        <p><strong>Ghế:</strong> ${booking.seatNumber}</p>
                    </div>
                </div>
                
                <hr>
                
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
        
        <div class="d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}/payment/success?bookingId=${booking.bookingId}&download=true" class="btn btn-primary">
                <i class="fas fa-download me-2"></i>Tải vé điện tử
            </a>
            <a href="${pageContext.request.contextPath}/bookings" class="btn btn-outline-primary">
                <i class="fas fa-history me-2"></i>Xem lịch sử đặt vé
            </a>
        </div>
    </div>
</div>

<div class="row justify-content-center mt-5">
    <div class="col-lg-8">
        <div class="card shadow">
            <div class="card-body">
                <h4 class="card-title">Thông tin quan trọng</h4>
                <ul>
                    <li>Vui lòng có mặt tại sân bay trước giờ khởi hành ít nhất 2 tiếng đối với chuyến bay nội địa và 3 tiếng đối với chuyến bay quốc tế.</li>
                    <li>Mang theo giấy tờ tùy thân (CMND/CCCD/Hộ chiếu) khi làm thủ tục.</li>
                    <li>Kiểm tra kỹ hành lý trước khi lên máy bay, không mang theo các vật phẩm cấm.</li>
                    <li>Nếu có thay đổi lịch bay, chúng tôi sẽ thông báo qua email và số điện thoại của bạn.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 