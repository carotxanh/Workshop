<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Chi tiết chuyến bay" />
</jsp:include>

<div class="row">
    <div class="col-lg-8">
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Chi tiết chuyến bay</h3>
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
                
                <div class="row mt-4">
                    <div class="col-md-6">
                        <h4>Thông tin chuyến bay</h4>
                        <table class="table">
                            <tr>
                                <th>Hãng hàng không:</th>
                                <td>${flight.airline}</td>
                            </tr>
                            <tr>
                                <th>Số hiệu:</th>
                                <td>${flight.flightNumber}</td>
                            </tr>
                            <tr>
                                <th>Loại máy bay:</th>
                                <td>${flight.aircraft}</td>
                            </tr>
                            <tr>
                                <th>Thời gian bay:</th>
                                <td><fmt:formatDate value="${flight.duration}" pattern="HH:mm" /> giờ</td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h4>Dịch vụ trên chuyến bay</h4>
                        <ul class="list-group">
                            <li class="list-group-item">
                                <i class="fas fa-utensils me-2 text-primary"></i> Bữa ăn miễn phí
                            </li>
                            <li class="list-group-item">
                                <i class="fas fa-suitcase me-2 text-primary"></i> Hành lý xách tay 7kg
                            </li>
                            <li class="list-group-item">
                                <i class="fas fa-suitcase-rolling me-2 text-primary"></i> Hành lý ký gửi 23kg
                            </li>
                            <li class="list-group-item">
                                <i class="fas fa-wifi me-2 text-primary"></i> Wi-Fi trên máy bay (có phí)
                            </li>
                            <li class="list-group-item">
                                <i class="fas fa-tv me-2 text-primary"></i> Giải trí trên máy bay
                            </li>
                        </ul>
                    </div>
                </div>
                
                <div class="mt-4">
                    <h4>Sơ đồ ghế ngồi</h4>
                    <div class="seat-map-container mt-3">
                        <div class="airplane-nose"></div>
                        <div class="seat-grid">
                            <c:forEach var="row" begin="1" end="10">
                                <div class="seat-row">
                                    <div class="seat-row-number">${row}</div>
                                    <c:forEach var="col" items="A,B,C,D,E,F">
                                        <c:set var="seatNumber" value="${row}${col}" />
                                        <c:set var="seatFound" value="false" />
                                        <c:set var="seatClass" value="" />
                                        <c:set var="seatStatus" value="" />
                                        
                                        <c:forEach var="seat" items="${seats}">
                                            <c:if test="${seat.seatNumber eq seatNumber}">
                                                <c:set var="seatFound" value="true" />
                                                <c:set var="seatClass" value="${seat.seatClass}" />
                                                <c:set var="seatStatus" value="${seat.status}" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <c:choose>
                                            <c:when test="${seatFound eq 'true'}">
                                                <c:choose>
                                                    <c:when test="${seatStatus eq 'AVAILABLE'}">
                                                        <div class="seat available ${seatClass}" data-seat="${seatNumber}" data-class="${seatClass}">
                                                            ${seatNumber}
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="seat occupied">
                                                            ${seatNumber}
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="seat-placeholder"></div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <c:if test="${col eq 'C'}">
                                            <div class="aisle"></div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div class="seat-legend mt-3">
                        <div class="d-flex justify-content-center">
                            <div class="me-4">
                                <div class="seat-sample available ECONOMY"></div>
                                <span>Phổ thông</span>
                            </div>
                            <div class="me-4">
                                <div class="seat-sample available BUSINESS"></div>
                                <span>Thương gia</span>
                            </div>
                            <div class="me-4">
                                <div class="seat-sample available FIRST_CLASS"></div>
                                <span>Hạng nhất</span>
                            </div>
                            <div>
                                <div class="seat-sample occupied"></div>
                                <span>Đã đặt</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Đặt vé</h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/booking" method="post" id="bookingForm">
                    <input type="hidden" name="flightId" value="${flight.flightId}">
                    
                    <div class="mb-3">
                        <label class="form-label">Chọn ghế</label>
                        <input type="text" class="form-control" id="selectedSeat" name="seatNumber" readonly required>
                        <div class="form-text">Vui lòng chọn ghế trên sơ đồ</div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Hạng ghế</label>
                        <input type="text" class="form-control" id="seatClass" readonly>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Giá vé</label>
                        <div class="form-control bg-light fw-bold text-primary" id="priceDisplay">
                            <fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                        </div>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg" id="bookButton" disabled>
                            <i class="fas fa-ticket-alt me-2"></i>Đặt vé
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<style>
.seat-map-container {
    margin: 0 auto;
    max-width: 600px;
}

.airplane-nose {
    width: 100px;
    height: 50px;
    background-color: #ddd;
    border-radius: 50% 50% 0 0;
    margin: 0 auto 20px;
}

.seat-grid {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.seat-row {
    display: flex;
    margin-bottom: 10px;
    align-items: center;
}

.seat-row-number {
    width: 30px;
    text-align: center;
    font-weight: bold;
}

.seat {
    width: 40px;
    height: 40px;
    margin: 0 5px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 5px;
    cursor: pointer;
    font-size: 12px;
    font-weight: bold;
}

.seat.available {
    background-color: #e9ecef;
    border: 1px solid #ced4da;
}

.seat.available:hover {
    background-color: #dee2e6;
}

.seat.available.selected {
    background-color: #0d6efd;
    color: white;
    border-color: #0d6efd;
}

.seat.occupied {
    background-color: #dc3545;
    color: white;
    cursor: not-allowed;
    border: 1px solid #dc3545;
}

.seat.available.ECONOMY {
    background-color: #e9ecef;
}

.seat.available.BUSINESS {
    background-color: #cfe2ff;
    border-color: #9ec5fe;
}

.seat.available.FIRST_CLASS {
    background-color: #d1e7dd;
    border-color: #a3cfbb;
}

.seat-placeholder {
    width: 40px;
    height: 40px;
    margin: 0 5px;
}

.aisle {
    width: 20px;
}

.flight-path {
    position: relative;
    width: 100%;
    height: 2px;
    background-color: #dee2e6;
    margin: 10px 0;
}

.flight-path i {
    position: absolute;
    top: -10px;
    left: 50%;
    transform: translateX(-50%);
    color: #0d6efd;
}

.seat-legend {
    margin-top: 20px;
}

.seat-sample {
    display: inline-block;
    width: 20px;
    height: 20px;
    margin-right: 5px;
    border-radius: 3px;
    vertical-align: middle;
}

.seat-sample.available.ECONOMY {
    background-color: #e9ecef;
    border: 1px solid #ced4da;
}

.seat-sample.available.BUSINESS {
    background-color: #cfe2ff;
    border: 1px solid #9ec5fe;
}

.seat-sample.available.FIRST_CLASS {
    background-color: #d1e7dd;
    border: 1px solid #a3cfbb;
}

.seat-sample.occupied {
    background-color: #dc3545;
    border: 1px solid #dc3545;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const seats = document.querySelectorAll('.seat.available');
    const selectedSeatInput = document.getElementById('selectedSeat');
    const seatClassInput = document.getElementById('seatClass');
    const bookButton = document.getElementById('bookButton');
    const priceDisplay = document.getElementById('priceDisplay');
    const basePrice = ${flight.price};
    
    seats.forEach(seat => {
        seat.addEventListener('click', function() {
            // Bỏ chọn ghế đã chọn trước đó
            document.querySelectorAll('.seat.selected').forEach(selectedSeat => {
                selectedSeat.classList.remove('selected');
            });
            
            // Chọn ghế mới
            this.classList.add('selected');
            
            // Cập nhật thông tin ghế
            const seatNumber = this.getAttribute('data-seat');
            const seatClass = this.getAttribute('data-class');
            selectedSeatInput.value = seatNumber;
            
            // Hiển thị hạng ghế
            let seatClassName = 'Phổ thông';
            let priceMultiplier = 1;
            
            if (seatClass === 'BUSINESS') {
                seatClassName = 'Thương gia';
                priceMultiplier = 2;
            } else if (seatClass === 'FIRST_CLASS') {
                seatClassName = 'Hạng nhất';
                priceMultiplier = 3;
            }
            
            seatClassInput.value = seatClassName;
            
            // Cập nhật giá vé
            const finalPrice = basePrice * priceMultiplier;
            priceDisplay.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(finalPrice);
            
            // Kích hoạt nút đặt vé
            bookButton.disabled = false;
        });
    });
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 