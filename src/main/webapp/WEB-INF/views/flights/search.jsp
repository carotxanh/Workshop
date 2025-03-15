<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Tìm kiếm chuyến bay" />
</jsp:include>

<div class="container my-5">
    <div class="row">
        <div class="col-lg-3">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">Bộ lọc tìm kiếm</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/flights/search" method="get" id="filterForm">
                        <input type="hidden" name="origin" value="${param.origin}">
                        <input type="hidden" name="destination" value="${param.destination}">
                        <input type="hidden" name="departureDate" value="${param.departureDate}">
                        <input type="hidden" name="returnDate" value="${param.returnDate}">
                        <input type="hidden" name="passengers" value="${param.passengers}">
                        <input type="hidden" name="cabinClass" value="${param.cabinClass}">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Hãng hàng không</label>
                            <div class="form-check">
                                <input class="form-check-input filter-checkbox" type="checkbox" name="airline" value="Vietnam Airlines" id="vietnamAirlines" ${param.airline.contains('Vietnam Airlines') ? 'checked' : ''}>
                                <label class="form-check-label" for="vietnamAirlines">
                                    Vietnam Airlines
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input filter-checkbox" type="checkbox" name="airline" value="Vietjet Air" id="vietjetAir" ${param.airline.contains('Vietjet Air') ? 'checked' : ''}>
                                <label class="form-check-label" for="vietjetAir">
                                    Vietjet Air
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input filter-checkbox" type="checkbox" name="airline" value="Bamboo Airways" id="bambooAirways" ${param.airline.contains('Bamboo Airways') ? 'checked' : ''}>
                                <label class="form-check-label" for="bambooAirways">
                                    Bamboo Airways
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input filter-checkbox" type="checkbox" name="airline" value="Pacific Airlines" id="pacificAirlines" ${param.airline.contains('Pacific Airlines') ? 'checked' : ''}>
                                <label class="form-check-label" for="pacificAirlines">
                                    Pacific Airlines
                                </label>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Thời gian khởi hành</label>
                            <div class="form-check">
                                <input class="form-check-input filter-checkbox" type="checkbox" name="departureTime" value="morning" id="morningDeparture" ${param.departureTime.contains('morning') ? 'checked' : ''}>
                                <label class="form-check-label" for="morningDeparture">
                                    Sáng (00:00 - 11:59)
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input filter-checkbox" type="checkbox" name="departureTime" value="afternoon" id="afternoonDeparture" ${param.departureTime.contains('afternoon') ? 'checked' : ''}>
                                <label class="form-check-label" for="afternoonDeparture">
                                    Chiều (12:00 - 17:59)
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input filter-checkbox" type="checkbox" name="departureTime" value="evening" id="eveningDeparture" ${param.departureTime.contains('evening') ? 'checked' : ''}>
                                <label class="form-check-label" for="eveningDeparture">
                                    Tối (18:00 - 23:59)
                                </label>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="priceRange" class="form-label fw-bold">Giá vé (VNĐ)</label>
                            <div class="d-flex justify-content-between mb-2">
                                <span id="minPriceDisplay">0</span>
                                <span id="maxPriceDisplay">10,000,000</span>
                            </div>
                            <input type="range" class="form-range" id="priceRange" name="maxPrice" min="0" max="10000000" step="100000" value="${empty param.maxPrice ? '10000000' : param.maxPrice}">
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Lọc kết quả
                        </button>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-lg-9">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">
                            ${param.origin} → ${param.destination}
                            <small class="ms-2 d-block d-md-inline-block">
                                <fmt:parseDate value="${param.departureDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                            </small>
                        </h5>
                        <span class="badge bg-light text-dark">${flights.size()} chuyến bay</span>
                    </div>
                </div>
                <div class="card-body">
                    <c:if test="${empty flights}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>Không tìm thấy chuyến bay nào phù hợp với tiêu chí tìm kiếm của bạn.
                        </div>
                    </c:if>
                    
                    <c:forEach items="${flights}" var="flight">
                        <div class="card mb-3 flight-card">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-2 text-center">
                                        <img src="${pageContext.request.contextPath}/resources/images/airlines/${flight.airlineCode}.png" alt="${flight.airline}" class="img-fluid mb-2" style="max-height: 40px;">
                                        <div class="small">${flight.airline}</div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="d-flex flex-column">
                                            <div class="fw-bold fs-5">${flight.departureTime}</div>
                                            <div class="small text-muted">${flight.originCode}</div>
                                        </div>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <div class="small text-muted mb-1">${flight.duration}</div>
                                        <div class="flight-line">
                                            <i class="fas fa-plane"></i>
                                        </div>
                                        <div class="small text-muted mt-1">
                                            <c:choose>
                                                <c:when test="${flight.stops == 0}">Bay thẳng</c:when>
                                                <c:otherwise>${flight.stops} điểm dừng</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="d-flex flex-column">
                                            <div class="fw-bold fs-5">${flight.arrivalTime}</div>
                                            <div class="small text-muted">${flight.destinationCode}</div>
                                        </div>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <div class="fw-bold text-primary fs-5">
                                            <fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/flights/select?flightId=${flight.flightId}&passengers=${param.passengers}&cabinClass=${param.cabinClass}" class="btn btn-primary btn-sm mt-2">
                                            Chọn
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="flight-details mt-3" style="display: none;">
                                    <hr>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6 class="fw-bold">Chi tiết chuyến bay</h6>
                                            <div class="d-flex mb-2">
                                                <div class="me-3">
                                                    <div class="fw-bold">${flight.departureTime}</div>
                                                    <div class="small text-muted">
                                                        <fmt:parseDate value="${flight.departureDate}" pattern="yyyy-MM-dd" var="parsedDepartureDate" />
                                                        <fmt:formatDate value="${parsedDepartureDate}" pattern="dd/MM/yyyy" />
                                                    </div>
                                                </div>
                                                <div>
                                                    <div class="fw-bold">${flight.origin}</div>
                                                    <div class="small text-muted">${flight.originAirport}</div>
                                                </div>
                                            </div>
                                            
                                            <div class="flight-path-line my-3">
                                                <div class="flight-path-icon">
                                                    <i class="fas fa-plane"></i>
                                                </div>
                                                <div class="flight-path-details ms-3">
                                                    <div class="fw-bold">${flight.duration}</div>
                                                    <div class="small text-muted">${flight.flightNumber}</div>
                                                    <div class="small text-muted">Máy bay: ${flight.aircraft}</div>
                                                </div>
                                            </div>
                                            
                                            <div class="d-flex">
                                                <div class="me-3">
                                                    <div class="fw-bold">${flight.arrivalTime}</div>
                                                    <div class="small text-muted">
                                                        <fmt:parseDate value="${flight.arrivalDate}" pattern="yyyy-MM-dd" var="parsedArrivalDate" />
                                                        <fmt:formatDate value="${parsedArrivalDate}" pattern="dd/MM/yyyy" />
                                                    </div>
                                                </div>
                                                <div>
                                                    <div class="fw-bold">${flight.destination}</div>
                                                    <div class="small text-muted">${flight.destinationAirport}</div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <h6 class="fw-bold">Chi tiết giá vé</h6>
                                            <table class="table table-sm">
                                                <tbody>
                                                    <tr>
                                                        <td>Giá vé cơ bản</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${flight.basePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Thuế & Phí</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${flight.tax}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                        </td>
                                                    </tr>
                                                    <tr class="fw-bold">
                                                        <td>Tổng cộng</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            
                                            <div class="d-grid gap-2">
                                                <a href="${pageContext.request.contextPath}/flights/select?flightId=${flight.flightId}&passengers=${param.passengers}&cabinClass=${param.cabinClass}" class="btn btn-primary">
                                                    Chọn chuyến bay này
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="text-center mt-2">
                                    <button class="btn btn-link btn-sm toggle-details">
                                        Xem chi tiết <i class="fas fa-chevron-down"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Chuyến bay khứ hồi (nếu có) -->
            <c:if test="${not empty param.returnDate && not empty returnFlights}">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                ${param.destination} → ${param.origin}
                                <small class="ms-2 d-block d-md-inline-block">
                                    <fmt:parseDate value="${param.returnDate}" pattern="yyyy-MM-dd" var="parsedReturnDate" />
                                    <fmt:formatDate value="${parsedReturnDate}" pattern="dd/MM/yyyy" />
                                </small>
                            </h5>
                            <span class="badge bg-light text-dark">${returnFlights.size()} chuyến bay</span>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Hiển thị danh sách chuyến bay khứ hồi tương tự như chuyến bay chiều đi -->
                    </div>
                </div>
            </c:if>
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

.flight-path-line {
    position: relative;
    padding-left: 20px;
    border-left: 2px dashed #ddd;
}

.flight-path-icon {
    position: absolute;
    left: -10px;
    top: 50%;
    transform: translateY(-50%);
    background-color: #fff;
    color: #0d6efd;
}
</style>

<script>
$(document).ready(function() {
    // Xử lý hiển thị chi tiết chuyến bay
    $('.toggle-details').click(function() {
        const card = $(this).closest('.flight-card');
        const details = card.find('.flight-details');
        const icon = $(this).find('i');
        
        details.slideToggle();
        
        if (icon.hasClass('fa-chevron-down')) {
            icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
            $(this).html('Ẩn chi tiết <i class="fas fa-chevron-up"></i>');
        } else {
            icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
            $(this).html('Xem chi tiết <i class="fas fa-chevron-down"></i>');
        }
    });
    
    // Xử lý thanh trượt giá
    const priceRange = $('#priceRange');
    const minPriceDisplay = $('#minPriceDisplay');
    const maxPriceDisplay = $('#maxPriceDisplay');
    
    function formatCurrency(value) {
        return new Intl.NumberFormat('vi-VN').format(value);
    }
    
    priceRange.on('input', function() {
        maxPriceDisplay.text(formatCurrency($(this).val()));
    });
    
    // Khởi tạo giá trị ban đầu
    maxPriceDisplay.text(formatCurrency(priceRange.val()));
    
    // Tự động submit form khi thay đổi checkbox
    $('.filter-checkbox').change(function() {
        $('#filterForm').submit();
    });
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 