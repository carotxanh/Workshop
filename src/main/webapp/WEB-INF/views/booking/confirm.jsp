<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Xác nhận đặt vé - Đặt vé máy bay" />
</jsp:include>

<!-- CSS cho phần chọn ghế -->
<style>
    .seat-container {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 15px;
    }
    
    .seat-item {
        width: 45px;
        height: 45px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
        transition: all 0.2s;
    }
    
    .seat-item.available {
        background-color: #e9f7ef;
        border: 1px solid #27ae60;
        color: #27ae60;
    }
    
    .seat-item.booked {
        background-color: #f8d7da;
        border: 1px solid #dc3545;
        color: #dc3545;
        cursor: not-allowed;
        opacity: 0.7;
    }
    
    .seat-item.selected {
        background-color: #27ae60;
        border: 1px solid #27ae60;
        color: white;
    }
    
    .seat-item.available:hover {
        background-color: #d5f5e3;
        transform: scale(1.05);
    }
    
    /* CSS cho phần phương thức thanh toán */
    .payment-method-container {
        margin-bottom: 20px;
    }
    
    .payment-method-option {
        display: flex;
        align-items: center;
        padding: 15px;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        margin-bottom: 10px;
        cursor: pointer;
        transition: all 0.2s;
    }
    
    .payment-method-option:hover {
        border-color: #adb5bd;
        background-color: #f8f9fa;
    }
    
    .payment-method-option.selected {
        border-color: #0d6efd;
        background-color: #f0f7ff;
    }
    
    .payment-method-radio {
        margin-right: 15px;
        width: 20px;
        height: 20px;
    }
    
    .payment-method-icon {
        margin-right: 15px;
        width: 30px;
        text-align: center;
        font-size: 1.2rem;
    }
    
    .payment-method-details {
        flex-grow: 1;
    }
    
    .payment-method-title {
        font-weight: 600;
        margin-bottom: 5px;
    }
    
    .payment-method-description {
        color: #6c757d;
        font-size: 0.9rem;
        margin-bottom: 0;
    }
</style>

<!-- Main Content -->
<div class="container my-5">
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <h2 class="mb-4 text-center fw-bold">Xác nhận thông tin đặt vé</h2>
            
            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold">Thông tin chuyến bay</h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p class="mb-1 text-muted">Mã chuyến bay</p>
                            <p class="fw-bold">${flight.flightNumber}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-1 text-muted">Hãng hàng không</p>
                            <p class="fw-bold">${flight.airline}</p>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p class="mb-1 text-muted">Điểm khởi hành</p>
                            <p class="fw-bold">${flight.origin}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-1 text-muted">Điểm đến</p>
                            <p class="fw-bold">${flight.destination}</p>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p class="mb-1 text-muted">Ngày khởi hành</p>
                            <p class="fw-bold"><fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy" /></p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-1 text-muted">Giờ khởi hành</p>
                            <p class="fw-bold"><fmt:formatDate value="${flight.departureTime}" pattern="HH:mm" /></p>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <p class="mb-1 text-muted">Giá vé</p>
                            <p class="fw-bold text-primary"><fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VND</p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-1 text-muted">Số ghế trống</p>
                            <p class="fw-bold">${flight.availableSeats}</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold">Chọn ghế ngồi</h5>
                </div>
                <div class="card-body">
                    <div class="mb-4">
                        <h6 class="mb-3">Hạng nhất</h6>
                        <div class="seat-container">
                            <c:forEach items="${firstClassSeats}" var="seat">
                                <div class="seat-item ${seat.status == 'AVAILABLE' ? 'available' : 'booked'}" 
                                     data-seat-id="${seat.seatId}" 
                                     data-seat-number="${seat.seatNumber}" 
                                     data-seat-price="${seat.price}">
                                    ${seat.seatNumber}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <h6 class="mb-3">Hạng thương gia</h6>
                        <div class="seat-container">
                            <c:forEach items="${businessSeats}" var="seat">
                                <div class="seat-item ${seat.status == 'AVAILABLE' ? 'available' : 'booked'}" 
                                     data-seat-id="${seat.seatId}" 
                                     data-seat-number="${seat.seatNumber}" 
                                     data-seat-price="${seat.price}">
                                    ${seat.seatNumber}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <h6 class="mb-3">Hạng phổ thông</h6>
                        <div class="seat-container">
                            <c:forEach items="${economySeats}" var="seat">
                                <div class="seat-item ${seat.status == 'AVAILABLE' ? 'available' : 'booked'}" 
                                     data-seat-id="${seat.seatId}" 
                                     data-seat-number="${seat.seatNumber}" 
                                     data-seat-price="${seat.price}">
                                    ${seat.seatNumber}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div id="selectedSeatInfo" class="alert alert-info mt-3 d-none">
                        <p class="mb-1">Ghế đã chọn: <span id="selectedSeatNumber" class="fw-bold"></span></p>
                        <p class="mb-0">Giá: <span id="selectedSeatPrice" class="fw-bold"></span> VND</p>
                    </div>
                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold">Thông tin hành khách</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/booking" method="post">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="flightId" value="${flight.flightId}">
                        <input type="hidden" name="seatId" id="seatIdInput">
                        <input type="hidden" name="seatNumber" id="seatNumberInput">
                        <input type="hidden" name="seatPrice" id="seatPriceInput">
                        <input type="hidden" name="paymentMethod" id="paymentMethodInput">
                        
                        <div class="mb-3">
                            <label for="passengerName" class="form-label">Họ tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="passengerName" name="passengerName" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="passengerEmail" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="passengerEmail" name="passengerEmail" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="passengerPhone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="passengerPhone" name="passengerPhone" required>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">Phương thức thanh toán <span class="text-danger">*</span></label>
                            <div class="payment-method-container">
                                <!-- Phương thức thanh toán: Tiền mặt khi nhận vé -->
                                <div class="payment-method-option" data-payment-method="CASH_ON_DELIVERY">
                                    <div class="payment-method-radio">
                                        <input type="radio" name="payment_method_radio" id="cashOnDelivery" checked>
                                    </div>
                                    <div class="payment-method-icon">
                                        <i class="fas fa-money-bill-wave text-success"></i>
                                    </div>
                                    <div class="payment-method-details">
                                        <div class="payment-method-title">Tiền mặt khi nhận vé</div>
                                        <div class="payment-method-description">Thanh toán bằng tiền mặt khi nhận vé. Vui lòng chuẩn bị đúng số tiền.</div>
                                    </div>
                                </div>
                                
                                <!-- Phương thức thanh toán: Ví điện tử -->
                                <div class="payment-method-option" data-payment-method="DIGITAL_WALLET">
                                    <div class="payment-method-radio">
                                        <input type="radio" name="payment_method_radio" id="digitalWallet">
                                    </div>
                                    <div class="payment-method-icon">
                                        <i class="fas fa-wallet text-primary"></i>
                                    </div>
                                    <div class="payment-method-details">
                                        <div class="payment-method-title">Ví điện tử</div>
                                        <div class="payment-method-description">Thanh toán qua ví điện tử (MoMo, ZaloPay, VNPay...)</div>
                                    </div>
                                </div>
                                
                                <!-- Phương thức thanh toán: Chuyển khoản ngân hàng -->
                                <div class="payment-method-option" data-payment-method="BANK_TRANSFER">
                                    <div class="payment-method-radio">
                                        <input type="radio" name="payment_method_radio" id="bankTransfer">
                                    </div>
                                    <div class="payment-method-icon">
                                        <i class="fas fa-university text-info"></i>
                                    </div>
                                    <div class="payment-method-details">
                                        <div class="payment-method-title">Chuyển khoản ngân hàng</div>
                                        <div class="payment-method-description">Thanh toán bằng chuyển khoản ngân hàng</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="specialRequests" class="form-label">Yêu cầu đặc biệt</label>
                            <textarea class="form-control" id="specialRequests" name="specialRequests" rows="3"></textarea>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <a href="${pageContext.request.contextPath}/booking?action=search" class="btn btn-secondary me-md-2">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary" id="confirmButton" disabled>
                                <i class="fas fa-check me-2"></i>Xác nhận đặt vé
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript cho phần chọn ghế và phương thức thanh toán -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Xử lý chọn ghế
        const availableSeats = document.querySelectorAll('.seat-item.available');
        const seatIdInput = document.getElementById('seatIdInput');
        const seatNumberInput = document.getElementById('seatNumberInput');
        const seatPriceInput = document.getElementById('seatPriceInput');
        const selectedSeatInfo = document.getElementById('selectedSeatInfo');
        const selectedSeatNumber = document.getElementById('selectedSeatNumber');
        const selectedSeatPrice = document.getElementById('selectedSeatPrice');
        const confirmButton = document.getElementById('confirmButton');
        let selectedSeat = null;
        
        availableSeats.forEach(seat => {
            seat.addEventListener('click', function() {
                if (selectedSeat) {
                    selectedSeat.classList.remove('selected');
                }
                
                this.classList.add('selected');
                selectedSeat = this;
                
                const seatId = this.getAttribute('data-seat-id');
                const seatNumber = this.getAttribute('data-seat-number');
                const seatPrice = this.getAttribute('data-seat-price');
                
                seatIdInput.value = seatId;
                seatNumberInput.value = seatNumber;
                seatPriceInput.value = seatPrice;
                
                selectedSeatNumber.textContent = seatNumber;
                selectedSeatPrice.textContent = new Intl.NumberFormat('vi-VN').format(seatPrice);
                selectedSeatInfo.classList.remove('d-none');
                
                // Chỉ kích hoạt nút xác nhận nếu đã chọn cả ghế và phương thức thanh toán
                validateForm();
            });
        });
        
        // Xử lý chọn phương thức thanh toán
        const paymentMethodOptions = document.querySelectorAll('.payment-method-option');
        const paymentMethodInput = document.getElementById('paymentMethodInput');
        let selectedPaymentMethod = 'CASH_ON_DELIVERY'; // Mặc định là tiền mặt khi nhận vé
        
        // Thiết lập giá trị mặc định cho input ẩn
        paymentMethodInput.value = selectedPaymentMethod;
        
        paymentMethodOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Bỏ chọn tất cả các phương thức thanh toán
                paymentMethodOptions.forEach(opt => {
                    opt.classList.remove('selected');
                    opt.querySelector('input[type="radio"]').checked = false;
                });
                
                // Chọn phương thức thanh toán mới
                this.classList.add('selected');
                this.querySelector('input[type="radio"]').checked = true;
                
                // Cập nhật giá trị cho input ẩn
                selectedPaymentMethod = this.getAttribute('data-payment-method');
                paymentMethodInput.value = selectedPaymentMethod;
                
                // Kiểm tra xem có thể kích hoạt nút xác nhận không
                validateForm();
            });
        });
        
        // Thiết lập trạng thái mặc định cho phương thức thanh toán đầu tiên
        paymentMethodOptions[0].classList.add('selected');
        paymentMethodOptions[0].querySelector('input[type="radio"]').checked = true;
        
        // Hàm kiểm tra xem có thể kích hoạt nút xác nhận không
        function validateForm() {
            if (seatIdInput.value && paymentMethodInput.value) {
                confirmButton.disabled = false;
            } else {
                confirmButton.disabled = true;
            }
        }
    });
</script>

<jsp:include page="../common/footer.jsp" /> 