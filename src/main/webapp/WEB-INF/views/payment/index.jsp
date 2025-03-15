<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Thanh toán" />
</jsp:include>

<div class="row">
    <div class="col-lg-8">
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Phương thức thanh toán</h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/payment" method="post">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}">
                    
                    <div class="mb-4">
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="creditCard" value="CREDIT_CARD" checked>
                            <label class="form-check-label" for="creditCard">
                                <i class="fas fa-credit-card me-2"></i>Thẻ tín dụng/Thẻ ghi nợ
                            </label>
                        </div>
                        
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="bankTransfer" value="BANK_TRANSFER">
                            <label class="form-check-label" for="bankTransfer">
                                <i class="fas fa-university me-2"></i>Chuyển khoản ngân hàng
                            </label>
                        </div>
                        
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="momo" value="MOMO">
                            <label class="form-check-label" for="momo">
                                <i class="fas fa-wallet me-2"></i>Ví MoMo
                            </label>
                        </div>
                    </div>
                    
                    <div id="creditCardForm">
                        <div class="mb-3">
                            <label for="cardNumber" class="form-label">Số thẻ</label>
                            <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" required>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="expiryDate" class="form-label">Ngày hết hạn</label>
                                <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY" required>
                            </div>
                            <div class="col-md-6">
                                <label for="cvv" class="form-label">CVV</label>
                                <input type="text" class="form-control" id="cvv" name="cvv" placeholder="XXX" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="cardName" class="form-label">Tên chủ thẻ</label>
                            <input type="text" class="form-control" id="cardName" name="cardName" required>
                        </div>
                    </div>
                    
                    <div id="bankTransferForm" style="display: none;">
                        <div class="alert alert-info">
                            <p class="mb-1"><strong>Thông tin chuyển khoản:</strong></p>
                            <p class="mb-1">Ngân hàng: Vietcombank</p>
                            <p class="mb-1">Số tài khoản: 1234567890</p>
                            <p class="mb-1">Chủ tài khoản: CÔNG TY TNHH AIRTICKET</p>
                            <p class="mb-0">Nội dung: ${booking.bookingCode} - ${user.name}</p>
                        </div>
                        <div class="mb-3">
                            <label for="transferProof" class="form-label">Minh chứng chuyển khoản</label>
                            <input type="file" class="form-control" id="transferProof" name="transferProof">
                        </div>
                    </div>
                    
                    <div id="momoForm" style="display: none;">
                        <div class="text-center mb-3">
                            <img src="${pageContext.request.contextPath}/resources/images/momo-qr.png" alt="MoMo QR Code" class="img-fluid" style="max-width: 200px;">
                        </div>
                        <div class="alert alert-info">
                            <p class="mb-1">Quét mã QR bằng ứng dụng MoMo để thanh toán</p>
                            <p class="mb-0">Số tiền: <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></p>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="termsCheck" required>
                            <label class="form-check-label" for="termsCheck">
                                Tôi đồng ý với <a href="#" class="text-decoration-none">điều khoản và điều kiện</a>
                            </label>
                        </div>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-credit-card me-2"></i>Thanh toán
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Thông tin đặt vé</h3>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-between mb-2">
                    <span>Mã đặt vé:</span>
                    <span class="fw-bold">${booking.bookingCode}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Chuyến bay:</span>
                    <span>${flight.flightNumber}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Hành trình:</span>
                    <span>${flight.origin} - ${flight.destination}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Ngày bay:</span>
                    <span><fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy" /></span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Giờ bay:</span>
                    <span><fmt:formatDate value="${flight.departureTime}" pattern="HH:mm" /></span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Hành khách:</span>
                    <span>${booking.passengerName}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Ghế:</span>
                    <span>${booking.seatNumber}</span>
                </div>
                
                <hr>
                
                <div class="d-flex justify-content-between fw-bold">
                    <span>Tổng tiền:</span>
                    <span class="text-primary">
                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                    </span>
                </div>
            </div>
        </div>
        
        <div class="card shadow">
            <div class="card-body">
                <h5 class="card-title">Lưu ý</h5>
                <ul class="mb-0">
                    <li>Vui lòng kiểm tra kỹ thông tin trước khi thanh toán</li>
                    <li>Đơn đặt vé sẽ được xác nhận sau khi thanh toán thành công</li>
                    <li>Vé điện tử sẽ được gửi qua email sau khi thanh toán</li>
                    <li>Vé đã thanh toán không được hoàn tiền</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Xử lý chuyển đổi giữa các phương thức thanh toán
    const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
    const creditCardForm = document.getElementById('creditCardForm');
    const bankTransferForm = document.getElementById('bankTransferForm');
    const momoForm = document.getElementById('momoForm');
    
    paymentMethods.forEach(method => {
        method.addEventListener('change', function() {
            // Ẩn tất cả các form
            creditCardForm.style.display = 'none';
            bankTransferForm.style.display = 'none';
            momoForm.style.display = 'none';
            
            // Hiển thị form tương ứng
            if (this.value === 'CREDIT_CARD') {
                creditCardForm.style.display = 'block';
            } else if (this.value === 'BANK_TRANSFER') {
                bankTransferForm.style.display = 'block';
            } else if (this.value === 'MOMO') {
                momoForm.style.display = 'block';
            }
        });
    });
    
    // Định dạng số thẻ
    const cardNumberInput = document.getElementById('cardNumber');
    cardNumberInput.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 16) {
            value = value.slice(0, 16);
        }
        
        // Thêm khoảng trắng sau mỗi 4 số
        const formattedValue = value.replace(/(\d{4})(?=\d)/g, '$1 ');
        e.target.value = formattedValue;
    });
    
    // Định dạng ngày hết hạn
    const expiryDateInput = document.getElementById('expiryDate');
    expiryDateInput.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 4) {
            value = value.slice(0, 4);
        }
        
        if (value.length > 2) {
            value = value.slice(0, 2) + '/' + value.slice(2);
        }
        
        e.target.value = value;
    });
    
    // Giới hạn CVV chỉ 3-4 số
    const cvvInput = document.getElementById('cvv');
    cvvInput.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 4) {
            value = value.slice(0, 4);
        }
        e.target.value = value;
    });
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 