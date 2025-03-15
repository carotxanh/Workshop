<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Đặt vé" />
</jsp:include>

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
                        <p><strong>Ghế đã chọn:</strong> ${seatNumber}</p>
                        <p><strong>Hạng ghế:</strong> ${seatClass}</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <p><strong>Giá vé:</strong> <span class="text-primary fw-bold">
                            <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                        </span></p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Thông tin hành khách</h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/booking" method="post">
                    <input type="hidden" name="flightId" value="${flight.flightId}">
                    <input type="hidden" name="seatNumber" value="${seatNumber}">
                    <input type="hidden" name="totalPrice" value="${totalPrice}">
                    
                    <div class="mb-3">
                        <label for="passengerName" class="form-label">Họ và tên</label>
                        <input type="text" class="form-control" id="passengerName" name="passengerName" value="${user.name}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="passengerEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="passengerEmail" name="passengerEmail" value="${user.email}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="passengerPhone" class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" id="passengerPhone" name="passengerPhone" value="${user.phone}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="specialRequests" class="form-label">Yêu cầu đặc biệt (nếu có)</label>
                        <textarea class="form-control" id="specialRequests" name="specialRequests" rows="3"></textarea>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-arrow-right me-2"></i>Tiếp tục đến thanh toán
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="card-title mb-0">Tóm tắt đặt vé</h3>
            </div>
            <div class="card-body">
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
                    <span>Ghế:</span>
                    <span>${seatNumber} (${seatClass})</span>
                </div>
                
                <hr>
                
                <div class="d-flex justify-content-between fw-bold">
                    <span>Tổng tiền:</span>
                    <span class="text-primary">
                        <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                    </span>
                </div>
            </div>
        </div>
        
        <div class="card shadow">
            <div class="card-body">
                <h5 class="card-title">Lưu ý</h5>
                <ul class="mb-0">
                    <li>Vui lòng kiểm tra kỹ thông tin trước khi thanh toán</li>
                    <li>Hành khách cần có mặt tại sân bay trước giờ khởi hành ít nhất 2 tiếng</li>
                    <li>Mang theo giấy tờ tùy thân (CMND/CCCD/Hộ chiếu) khi làm thủ tục</li>
                    <li>Vé đã thanh toán không được hoàn tiền</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 