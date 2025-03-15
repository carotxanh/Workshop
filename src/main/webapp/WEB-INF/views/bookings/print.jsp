<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vé điện tử - ${booking.bookingNumber}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .ticket-container {
            max-width: 800px;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .ticket-header {
            background-color: #0d6efd;
            color: white;
            padding: 15px;
            border-radius: 5px 5px 0 0;
        }
        .ticket-body {
            padding: 20px;
        }
        .flight-info {
            border: 1px solid #dee2e6;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .flight-header {
            background-color: #f8f9fa;
            padding: 10px 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .flight-details {
            padding: 15px;
        }
        .passenger-info {
            margin-bottom: 20px;
        }
        .barcode {
            text-align: center;
            margin: 20px 0;
        }
        .barcode img {
            max-width: 300px;
        }
        .flight-path {
            position: relative;
            padding: 0 30px;
        }
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
        .print-button {
            text-align: center;
            margin: 20px 0;
        }
        .logo {
            max-height: 40px;
        }
        @media print {
            .print-button {
                display: none;
            }
            .ticket-container {
                box-shadow: none;
            }
            body {
                background-color: #fff;
            }
        }
    </style>
</head>
<body>
    <div class="ticket-container">
        <div class="ticket-header d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0">Vé điện tử</h4>
                <p class="mb-0">Mã đặt vé: ${booking.bookingNumber}</p>
            </div>
            <div>
                <img src="${pageContext.request.contextPath}/resources/images/logo-white.png" alt="Logo" class="logo">
            </div>
        </div>
        
        <div class="ticket-body">
            <div class="alert alert-info mb-4">
                <i class="fas fa-info-circle me-2"></i>Vui lòng xuất trình vé điện tử này cùng với giấy tờ tùy thân khi làm thủ tục tại sân bay.
            </div>
            
            <!-- Thông tin chuyến bay đi -->
            <div class="flight-info">
                <div class="flight-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chuyến bay đi</h5>
                    <span class="badge bg-primary">
                        <fmt:formatDate value="${booking.flight.departureTime}" pattern="EEE, dd/MM/yyyy" />
                    </span>
                </div>
                <div class="flight-details">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p class="mb-1"><strong>Hãng hàng không:</strong> ${booking.flight.airline}</p>
                            <p class="mb-1"><strong>Số hiệu chuyến bay:</strong> ${booking.flight.flightNumber}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-1"><strong>Hạng vé:</strong> 
                                <c:choose>
                                    <c:when test="${booking.cabinClass eq 'ECONOMY'}">Phổ thông</c:when>
                                    <c:when test="${booking.cabinClass eq 'BUSINESS'}">Thương gia</c:when>
                                    <c:when test="${booking.cabinClass eq 'FIRST'}">Hạng nhất</c:when>
                                </c:choose>
                            </p>
                            <p class="mb-1"><strong>Trạng thái:</strong> 
                                <c:choose>
                                    <c:when test="${booking.flight.status eq 'SCHEDULED'}">Đã lên lịch</c:when>
                                    <c:when test="${booking.flight.status eq 'DELAYED'}">Bị trì hoãn</c:when>
                                    <c:when test="${booking.flight.status eq 'CANCELLED'}">Đã hủy</c:when>
                                    <c:when test="${booking.flight.status eq 'COMPLETED'}">Đã hoàn thành</c:when>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    
                    <div class="row align-items-center mb-3">
                        <div class="col-md-5 text-center">
                            <h5 class="mb-0">${booking.flight.origin}</h5>
                            <p class="mb-0"><fmt:formatDate value="${booking.flight.departureTime}" pattern="HH:mm" /></p>
                        </div>
                        <div class="col-md-2">
                            <div class="flight-path">
                                <div class="flight-line">
                                    <i class="fas fa-plane"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-5 text-center">
                            <h5 class="mb-0">${booking.flight.destination}</h5>
                            <p class="mb-0"><fmt:formatDate value="${booking.flight.arrivalTime}" pattern="HH:mm" /></p>
                        </div>
                    </div>
                    
                    <div class="text-center">
                        <p class="mb-0 text-muted">
                            <c:set var="durationMinutes" value="${(booking.flight.arrivalTime.time - booking.flight.departureTime.time) / 60000}" />
                            <fmt:formatNumber value="${durationMinutes / 60}" pattern="#" var="hours" />
                            <fmt:formatNumber value="${durationMinutes % 60}" pattern="#" var="minutes" />
                            Thời gian bay: ${hours}h ${minutes}m
                        </p>
                    </div>
                </div>
            </div>
            
            <!-- Thông tin chuyến bay về (nếu có) -->
            <c:if test="${not empty booking.returnFlight}">
                <div class="flight-info">
                    <div class="flight-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Chuyến bay về</h5>
                        <span class="badge bg-primary">
                            <fmt:formatDate value="${booking.returnFlight.departureTime}" pattern="EEE, dd/MM/yyyy" />
                        </span>
                    </div>
                    <div class="flight-details">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Hãng hàng không:</strong> ${booking.returnFlight.airline}</p>
                                <p class="mb-1"><strong>Số hiệu chuyến bay:</strong> ${booking.returnFlight.flightNumber}</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Hạng vé:</strong> 
                                    <c:choose>
                                        <c:when test="${booking.cabinClass eq 'ECONOMY'}">Phổ thông</c:when>
                                        <c:when test="${booking.cabinClass eq 'BUSINESS'}">Thương gia</c:when>
                                        <c:when test="${booking.cabinClass eq 'FIRST'}">Hạng nhất</c:when>
                                    </c:choose>
                                </p>
                                <p class="mb-1"><strong>Trạng thái:</strong> 
                                    <c:choose>
                                        <c:when test="${booking.returnFlight.status eq 'SCHEDULED'}">Đã lên lịch</c:when>
                                        <c:when test="${booking.returnFlight.status eq 'DELAYED'}">Bị trì hoãn</c:when>
                                        <c:when test="${booking.returnFlight.status eq 'CANCELLED'}">Đã hủy</c:when>
                                        <c:when test="${booking.returnFlight.status eq 'COMPLETED'}">Đã hoàn thành</c:when>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                        
                        <div class="row align-items-center mb-3">
                            <div class="col-md-5 text-center">
                                <h5 class="mb-0">${booking.returnFlight.origin}</h5>
                                <p class="mb-0"><fmt:formatDate value="${booking.returnFlight.departureTime}" pattern="HH:mm" /></p>
                            </div>
                            <div class="col-md-2">
                                <div class="flight-path">
                                    <div class="flight-line">
                                        <i class="fas fa-plane"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5 text-center">
                                <h5 class="mb-0">${booking.returnFlight.destination}</h5>
                                <p class="mb-0"><fmt:formatDate value="${booking.returnFlight.arrivalTime}" pattern="HH:mm" /></p>
                            </div>
                        </div>
                        
                        <div class="text-center">
                            <p class="mb-0 text-muted">
                                <c:set var="returnDurationMinutes" value="${(booking.returnFlight.arrivalTime.time - booking.returnFlight.departureTime.time) / 60000}" />
                                <fmt:formatNumber value="${returnDurationMinutes / 60}" pattern="#" var="returnHours" />
                                <fmt:formatNumber value="${returnDurationMinutes % 60}" pattern="#" var="returnMinutes" />
                                Thời gian bay: ${returnHours}h ${returnMinutes}m
                            </p>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Thông tin hành khách -->
            <div class="passenger-info">
                <h5 class="mb-3">Thông tin hành khách</h5>
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
            
            <!-- Mã vạch -->
            <div class="barcode">
                <img src="https://barcode.tec-it.com/barcode.ashx?data=${booking.bookingNumber}&code=Code128&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=Gif&rotation=0&color=%23000000&bgcolor=%23ffffff&codepage=&qunit=Mm&quiet=0" alt="Barcode">
                <p class="text-muted small mt-2">Mã đặt vé: ${booking.bookingNumber}</p>
            </div>
            
            <!-- Thông tin liên hệ -->
            <div class="mt-4">
                <h5 class="mb-3">Thông tin liên hệ</h5>
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
            
            <!-- Lưu ý -->
            <div class="alert alert-warning mt-4">
                <h6 class="mb-2">Lưu ý quan trọng:</h6>
                <ul class="mb-0">
                    <li>Vui lòng có mặt tại sân bay ít nhất 2 giờ trước giờ khởi hành đối với chuyến bay quốc nội và 3 giờ đối với chuyến bay quốc tế.</li>
                    <li>Mang theo giấy tờ tùy thân (CMND/CCCD/Hộ chiếu) khi làm thủ tục.</li>
                    <li>Kiểm tra quy định về hành lý của hãng hàng không trước khi đến sân bay.</li>
                    <li>Liên hệ với chúng tôi nếu có bất kỳ thay đổi nào về lịch trình chuyến bay.</li>
                </ul>
            </div>
        </div>
    </div>
    
    <div class="print-button">
        <button class="btn btn-primary" onclick="window.print()">
            <i class="fas fa-print me-2"></i>In vé
        </button>
        <a href="${pageContext.request.contextPath}/bookings/${booking.bookingNumber}" class="btn btn-outline-primary ms-2">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 