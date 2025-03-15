<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Thanh toán" />
</jsp:include>

<div class="container my-5">
    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">Phương thức thanh toán</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/flights/payment" method="post" id="paymentForm">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                        
                        <div class="alert alert-info mb-4">
                            <i class="fas fa-info-circle me-2"></i>Vui lòng chọn phương thức thanh toán và hoàn tất giao dịch để xác nhận đặt vé.
                        </div>
                        
                        <div class="mb-4">
                            <div class="form-check mb-3">
                                <input class="form-check-input payment-method" type="radio" name="paymentMethod" id="creditCard" value="CREDIT_CARD" checked>
                                <label class="form-check-label" for="creditCard">
                                    <i class="far fa-credit-card me-2"></i>Thẻ tín dụng/ghi nợ
                                </label>
                            </div>
                            
                            <div id="creditCardForm" class="payment-form ms-4 p-3 border rounded">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="cardNumber" class="form-label">Số thẻ <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardName" class="form-label">Tên chủ thẻ <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="cardName" name="cardName" placeholder="Tên in trên thẻ" required>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="expiryDate" class="form-label">Ngày hết hạn <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cvv" class="form-label">Mã bảo mật (CVV) <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="cvv" name="cvv" placeholder="XXX" required>
                                    </div>
                                </div>
                                
                                <div class="d-flex align-items-center mt-2">
                                    <span class="me-3">Chúng tôi chấp nhận:</span>
                                    <img src="${pageContext.request.contextPath}/resources/images/payment/visa.png" alt="Visa" class="me-2" height="30">
                                    <img src="${pageContext.request.contextPath}/resources/images/payment/mastercard.png" alt="MasterCard" class="me-2" height="30">
                                    <img src="${pageContext.request.contextPath}/resources/images/payment/jcb.png" alt="JCB" class="me-2" height="30">
                                    <img src="${pageContext.request.contextPath}/resources/images/payment/amex.png" alt="American Express" height="30">
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <div class="form-check mb-3">
                                <input class="form-check-input payment-method" type="radio" name="paymentMethod" id="bankTransfer" value="BANK_TRANSFER">
                                <label class="form-check-label" for="bankTransfer">
                                    <i class="fas fa-university me-2"></i>Chuyển khoản ngân hàng
                                </label>
                            </div>
                            
                            <div id="bankTransferForm" class="payment-form ms-4 p-3 border rounded d-none">
                                <div class="alert alert-warning">
                                    <p class="mb-1">Vui lòng chuyển khoản đến tài khoản sau:</p>
                                    <p class="mb-1"><strong>Ngân hàng:</strong> Vietcombank</p>
                                    <p class="mb-1"><strong>Số tài khoản:</strong> 1234567890</p>
                                    <p class="mb-1"><strong>Chủ tài khoản:</strong> CÔNG TY TNHH DU LỊCH VÀ DỊCH VỤ ABC</p>
                                    <p class="mb-1"><strong>Nội dung chuyển khoản:</strong> ${booking.bookingNumber}</p>
                                    <p class="mb-0"><strong>Số tiền:</strong> <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></p>
                                </div>
                                <p class="text-danger">Lưu ý: Vé sẽ được xác nhận sau khi chúng tôi nhận được thanh toán của bạn.</p>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <div class="form-check mb-3">
                                <input class="form-check-input payment-method" type="radio" name="paymentMethod" id="momo" value="MOMO">
                                <label class="form-check-label" for="momo">
                                    <i class="fas fa-mobile-alt me-2"></i>Ví điện tử MoMo
                                </label>
                            </div>
                            
                            <div id="momoForm" class="payment-form ms-4 p-3 border rounded d-none">
                                <div class="text-center mb-3">
                                    <img src="${pageContext.request.contextPath}/resources/images/payment/momo-qr.png" alt="MoMo QR Code" class="img-fluid" style="max-width: 200px;">
                                </div>
                                <p class="text-center">Quét mã QR bằng ứng dụng MoMo để thanh toán</p>
                                <div class="alert alert-warning">
                                    <p class="mb-1"><strong>Số tiền:</strong> <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></p>
                                    <p class="mb-0"><strong>Nội dung thanh toán:</strong> ${booking.bookingNumber}</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="termsCheck" required>
                            <label class="form-check-label" for="termsCheck">
                                Tôi đồng ý với <a href="#" data-bs-toggle="modal" data-bs-target="#paymentTermsModal">điều khoản thanh toán</a> và xác nhận rằng thông tin tôi cung cấp là chính xác
                            </label>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-lock me-2"></i>Thanh toán an toàn
                        </button>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">Thông tin đặt vé</h5>
                </div>
                <div class="card-body">
                    <p class="mb-1"><strong>Mã đặt vé:</strong> ${booking.bookingNumber}</p>
                    <p class="mb-3"><strong>Ngày đặt:</strong> <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                    
                    <h6 class="border-bottom pb-2 mb-3">Thông tin chuyến bay</h6>
                    
                    <!-- Chuyến bay đi -->
                    <div class="mb-3">
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
                        
                        <div class="d-flex mt-2">
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
                    </div>
                    
                    <!-- Chuyến bay về (nếu có) -->
                    <c:if test="${not empty booking.returnFlight}">
                        <div class="mb-3">
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
                            
                            <div class="d-flex mt-2">
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
                        </div>
                    </c:if>
                    
                    <h6 class="border-bottom pb-2 mb-3">Hành khách</h6>
                    <c:forEach items="${booking.passengers}" var="passenger" varStatus="status">
                        <p class="mb-1">
                            ${status.count}. ${passenger.title} ${passenger.firstName} ${passenger.lastName}
                            <span class="badge bg-secondary">
                                <c:choose>
                                    <c:when test="${passenger.passengerType eq 'ADULT'}">Người lớn</c:when>
                                    <c:when test="${passenger.passengerType eq 'CHILD'}">Trẻ em</c:when>
                                    <c:when test="${passenger.passengerType eq 'INFANT'}">Em bé</c:when>
                                </c:choose>
                            </span>
                        </p>
                    </c:forEach>
                    
                    <h6 class="border-bottom pb-2 mb-3 mt-4">Chi tiết giá</h6>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Giá vé cơ bản</span>
                        <span><fmt:formatNumber value="${booking.basePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Thuế và phí</span>
                        <span><fmt:formatNumber value="${booking.taxAndFees}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </div>
                    <c:if test="${booking.discount > 0}">
                        <div class="d-flex justify-content-between mb-2 text-success">
                            <span>Giảm giá</span>
                            <span>-<fmt:formatNumber value="${booking.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                        </div>
                    </c:if>
                    <div class="d-flex justify-content-between fw-bold mt-2 pt-2 border-top">
                        <span>Tổng cộng</span>
                        <span><fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Điều khoản thanh toán -->
<div class="modal fade" id="paymentTermsModal" tabindex="-1" aria-labelledby="paymentTermsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="paymentTermsModalLabel">Điều khoản thanh toán</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <h6>1. Quy định thanh toán</h6>
                <p>Việc thanh toán phải được hoàn tất trong vòng 24 giờ kể từ khi đặt vé. Sau thời gian này, đặt vé sẽ tự động bị hủy.</p>
                
                <h6>2. Bảo mật thông tin</h6>
                <p>Chúng tôi cam kết bảo mật thông tin thanh toán của khách hàng. Thông tin thẻ tín dụng/ghi nợ sẽ được mã hóa và bảo vệ theo tiêu chuẩn bảo mật quốc tế.</p>
                
                <h6>3. Hoàn tiền và hủy vé</h6>
                <p>Việc hoàn tiền khi hủy vé sẽ tuân theo chính sách của hãng hàng không. Thời gian hoàn tiền có thể mất từ 7-45 ngày làm việc tùy thuộc vào phương thức thanh toán và ngân hàng của khách hàng.</p>
                
                <h6>4. Xác nhận thanh toán</h6>
                <p>Sau khi thanh toán thành công, khách hàng sẽ nhận được email xác nhận đặt vé và hóa đơn điện tử.</p>
                
                <h6>5. Trách nhiệm của khách hàng</h6>
                <p>Khách hàng có trách nhiệm cung cấp thông tin thanh toán chính xác và đảm bảo có đủ số dư trong tài khoản để thực hiện giao dịch.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Đã hiểu</button>
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
    margin: 10px 0;
}

.flight-line i {
    position: absolute;
    top: -10px;
    right: 0;
    color: #0d6efd;
    transform: rotate(90deg);
}
</style>

<script>
$(document).ready(function() {
    // Xử lý hiển thị form thanh toán tương ứng
    $('.payment-method').change(function() {
        $('.payment-form').addClass('d-none');
        
        const method = $(this).val();
        if (method === 'CREDIT_CARD') {
            $('#creditCardForm').removeClass('d-none');
        } else if (method === 'BANK_TRANSFER') {
            $('#bankTransferForm').removeClass('d-none');
        } else if (method === 'MOMO') {
            $('#momoForm').removeClass('d-none');
        }
    });
    
    // Định dạng số thẻ
    $('#cardNumber').on('input', function() {
        let value = $(this).val().replace(/\D/g, '');
        value = value.replace(/(.{4})/g, '$1 ').trim();
        $(this).val(value);
    });
    
    // Định dạng ngày hết hạn
    $('#expiryDate').on('input', function() {
        let value = $(this).val().replace(/\D/g, '');
        if (value.length > 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
        }
        $(this).val(value);
    });
    
    // Định dạng CVV
    $('#cvv').on('input', function() {
        let value = $(this).val().replace(/\D/g, '');
        $(this).val(value);
    });
    
    // Kiểm tra form trước khi submit
    $('#paymentForm').submit(function(e) {
        const method = $('input[name="paymentMethod"]:checked').val();
        
        if (method === 'CREDIT_CARD') {
            const cardNumber = $('#cardNumber').val().replace(/\s/g, '');
            const expiryDate = $('#expiryDate').val();
            const cvv = $('#cvv').val();
            
            if (cardNumber.length < 16) {
                alert('Vui lòng nhập số thẻ hợp lệ.');
                $('#cardNumber').focus();
                e.preventDefault();
                return false;
            }
            
            if (!expiryDate.match(/^\d{2}\/\d{2}$/)) {
                alert('Vui lòng nhập ngày hết hạn theo định dạng MM/YY.');
                $('#expiryDate').focus();
                e.preventDefault();
                return false;
            }
            
            if (cvv.length < 3) {
                alert('Vui lòng nhập mã CVV hợp lệ.');
                $('#cvv').focus();
                e.preventDefault();
                return false;
            }
        }
        
        return true;
    });
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 