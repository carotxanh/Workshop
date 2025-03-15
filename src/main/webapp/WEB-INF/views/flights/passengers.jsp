<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Thông tin hành khách" />
</jsp:include>

<div class="container my-5">
    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">Thông tin hành khách</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/flights/passengers" method="post" id="passengerForm">
                        <input type="hidden" name="flightId" value="${flight.flightId}">
                        <input type="hidden" name="returnFlightId" value="${returnFlight.flightId}">
                        <input type="hidden" name="cabinClass" value="${param.cabinClass}">
                        <input type="hidden" name="passengers" value="${param.passengers}">
                        
                        <div class="alert alert-info mb-4">
                            <i class="fas fa-info-circle me-2"></i>Vui lòng nhập thông tin chính xác của tất cả hành khách. Thông tin này sẽ được sử dụng để xuất vé và kiểm tra khi lên máy bay.
                        </div>
                        
                        <c:forEach begin="1" end="${param.passengers}" var="i">
                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0">Hành khách ${i}</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="title${i}" class="form-label">Danh xưng <span class="text-danger">*</span></label>
                                            <select class="form-select" id="title${i}" name="passengers[${i-1}].title" required>
                                                <option value="">-- Chọn danh xưng --</option>
                                                <option value="Ông">Ông</option>
                                                <option value="Bà">Bà</option>
                                                <option value="Cô">Cô</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="passengerType${i}" class="form-label">Loại hành khách <span class="text-danger">*</span></label>
                                            <select class="form-select" id="passengerType${i}" name="passengers[${i-1}].passengerType" required>
                                                <option value="ADULT">Người lớn (>12 tuổi)</option>
                                                <option value="CHILD">Trẻ em (2-12 tuổi)</option>
                                                <option value="INFANT">Em bé (<2 tuổi)</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="firstName${i}" class="form-label">Họ <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="firstName${i}" name="passengers[${i-1}].firstName" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="lastName${i}" class="form-label">Tên <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="lastName${i}" name="passengers[${i-1}].lastName" required>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="dateOfBirth${i}" class="form-label">Ngày sinh <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" id="dateOfBirth${i}" name="passengers[${i-1}].dateOfBirth" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="nationality${i}" class="form-label">Quốc tịch <span class="text-danger">*</span></label>
                                            <select class="form-select" id="nationality${i}" name="passengers[${i-1}].nationality" required>
                                                <option value="">-- Chọn quốc tịch --</option>
                                                <option value="VN">Việt Nam</option>
                                                <option value="US">Hoa Kỳ</option>
                                                <option value="GB">Anh</option>
                                                <option value="FR">Pháp</option>
                                                <option value="DE">Đức</option>
                                                <option value="JP">Nhật Bản</option>
                                                <option value="KR">Hàn Quốc</option>
                                                <option value="CN">Trung Quốc</option>
                                                <option value="SG">Singapore</option>
                                                <option value="TH">Thái Lan</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="passportNumber${i}" class="form-label">Số hộ chiếu <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="passportNumber${i}" name="passengers[${i-1}].passportNumber" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="passportExpiry${i}" class="form-label">Ngày hết hạn hộ chiếu <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" id="passportExpiry${i}" name="passengers[${i-1}].passportExpiry" required>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <div class="card mb-4">
                            <div class="card-header bg-light">
                                <h6 class="mb-0">Thông tin liên hệ</h6>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="contactName" class="form-label">Họ tên người liên hệ <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="contactName" name="contactName" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="contactEmail" class="form-label">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="contactEmail" name="contactEmail" required>
                                        <div class="form-text">Vé điện tử sẽ được gửi đến địa chỉ email này</div>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="contactPhone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                        <input type="tel" class="form-control" id="contactPhone" name="contactPhone" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="contactAddress" class="form-label">Địa chỉ</label>
                                        <input type="text" class="form-control" id="contactAddress" name="contactAddress">
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="termsCheck" required>
                            <label class="form-check-label" for="termsCheck">
                                Tôi đã đọc và đồng ý với <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">điều khoản và điều kiện</a> của hãng hàng không
                            </label>
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <a href="javascript:history.back()" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary">
                                Tiếp tục đến thanh toán <i class="fas fa-arrow-right ms-2"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">Thông tin chuyến bay</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <img src="${pageContext.request.contextPath}/resources/images/airlines/${flight.airlineCode}.png" alt="${flight.airline}" class="me-2" style="height: 30px;">
                        <h6 class="mb-0">${flight.airline}</h6>
                    </div>
                    
                    <div class="mb-4">
                        <div class="d-flex justify-content-between mb-2">
                            <div>
                                <div class="fw-bold">${flight.departureTime}</div>
                                <div class="text-muted">${flight.departureDate}</div>
                                <div>${flight.origin} (${flight.originCode})</div>
                            </div>
                            <div class="text-center">
                                <div class="text-muted">${flight.duration}</div>
                                <div class="flight-line">
                                    <i class="fas fa-plane"></i>
                                </div>
                                <div class="text-muted">Bay thẳng</div>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold">${flight.arrivalTime}</div>
                                <div class="text-muted">${flight.arrivalDate}</div>
                                <div>${flight.destination} (${flight.destinationCode})</div>
                            </div>
                        </div>
                        <div class="small text-muted">
                            <i class="fas fa-info-circle me-1"></i>Mã chuyến bay: ${flight.flightNumber}
                        </div>
                    </div>
                    
                    <c:if test="${not empty returnFlight}">
                        <hr>
                        <div class="d-flex align-items-center mb-3">
                            <img src="${pageContext.request.contextPath}/resources/images/airlines/${returnFlight.airlineCode}.png" alt="${returnFlight.airline}" class="me-2" style="height: 30px;">
                            <h6 class="mb-0">${returnFlight.airline}</h6>
                        </div>
                        
                        <div class="mb-4">
                            <div class="d-flex justify-content-between mb-2">
                                <div>
                                    <div class="fw-bold">${returnFlight.departureTime}</div>
                                    <div class="text-muted">${returnFlight.departureDate}</div>
                                    <div>${returnFlight.origin} (${returnFlight.originCode})</div>
                                </div>
                                <div class="text-center">
                                    <div class="text-muted">${returnFlight.duration}</div>
                                    <div class="flight-line">
                                        <i class="fas fa-plane"></i>
                                    </div>
                                    <div class="text-muted">Bay thẳng</div>
                                </div>
                                <div class="text-end">
                                    <div class="fw-bold">${returnFlight.arrivalTime}</div>
                                    <div class="text-muted">${returnFlight.arrivalDate}</div>
                                    <div>${returnFlight.destination} (${returnFlight.destinationCode})</div>
                                </div>
                            </div>
                            <div class="small text-muted">
                                <i class="fas fa-info-circle me-1"></i>Mã chuyến bay: ${returnFlight.flightNumber}
                            </div>
                        </div>
                    </c:if>
                    
                    <hr>
                    
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Hạng ghế:</span>
                            <span class="fw-bold">
                                <c:choose>
                                    <c:when test="${param.cabinClass eq 'ECONOMY'}">Phổ thông</c:when>
                                    <c:when test="${param.cabinClass eq 'BUSINESS'}">Thương gia</c:when>
                                    <c:when test="${param.cabinClass eq 'FIRST'}">Hạng nhất</c:when>
                                </c:choose>
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Số hành khách:</span>
                            <span class="fw-bold">${param.passengers}</span>
                        </div>
                    </div>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span>Giá vé:</span>
                        <span class="fw-bold">
                            <fmt:formatNumber value="${flight.price * param.passengers}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </span>
                    </div>
                    
                    <c:if test="${not empty returnFlight}">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Giá vé khứ hồi:</span>
                            <span class="fw-bold">
                                <fmt:formatNumber value="${returnFlight.price * param.passengers}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </span>
                        </div>
                    </c:if>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span>Thuế & phí:</span>
                        <span class="fw-bold">
                            <fmt:formatNumber value="${(flight.price * 0.1) * param.passengers}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            <c:if test="${not empty returnFlight}">
                                + <fmt:formatNumber value="${(returnFlight.price * 0.1) * param.passengers}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </c:if>
                        </span>
                    </div>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span class="fw-bold">Tổng cộng:</span>
                        <span class="fw-bold fs-5 text-primary">
                            <c:set var="totalPrice" value="${(flight.price * 1.1) * param.passengers}" />
                            <c:if test="${not empty returnFlight}">
                                <c:set var="totalPrice" value="${totalPrice + (returnFlight.price * 1.1) * param.passengers}" />
                            </c:if>
                            <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Điều khoản -->
<div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="termsModalLabel">Điều khoản và điều kiện</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <h6>1. Quy định chung</h6>
                <p>Khi đặt vé máy bay qua hệ thống của chúng tôi, bạn đồng ý tuân thủ các điều khoản và điều kiện của hãng hàng không và của chúng tôi.</p>
                
                <h6>2. Giá vé và thanh toán</h6>
                <p>Giá vé đã bao gồm thuế và phí. Việc thanh toán phải được hoàn tất trong thời gian quy định để đảm bảo giá vé không thay đổi.</p>
                
                <h6>3. Thay đổi và hủy vé</h6>
                <p>Việc thay đổi hoặc hủy vé sẽ tuân theo quy định của từng hãng hàng không và có thể phát sinh phí.</p>
                
                <h6>4. Hành lý</h6>
                <p>Quy định về hành lý (kích thước, trọng lượng) sẽ theo quy định của từng hãng hàng không.</p>
                
                <h6>5. Trách nhiệm của hành khách</h6>
                <p>Hành khách có trách nhiệm cung cấp thông tin chính xác và đầy đủ. Mọi vấn đề phát sinh do thông tin không chính xác, hành khách sẽ chịu hoàn toàn trách nhiệm.</p>
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
    $('#passengerForm').submit(function(e) {
        // Kiểm tra ngày hết hạn hộ chiếu
        let valid = true;
        
        $('[id^=passportExpiry]').each(function() {
            const expiryDate = new Date($(this).val());
            const today = new Date();
            
            if (expiryDate <= today) {
                alert('Hộ chiếu phải còn hạn sử dụng.');
                $(this).focus();
                valid = false;
                return false;
            }
        });
        
        if (!valid) {
            e.preventDefault();
            return false;
        }
        
        // Kiểm tra ngày sinh phù hợp với loại hành khách
        $('[id^=passengerType]').each(function(index) {
            const type = $(this).val();
            const dobInput = $('#dateOfBirth' + (index + 1));
            const dob = new Date(dobInput.val());
            const today = new Date();
            const age = today.getFullYear() - dob.getFullYear();
            
            if (type === 'ADULT' && age < 12) {
                alert('Người lớn phải từ 12 tuổi trở lên.');
                dobInput.focus();
                valid = false;
                return false;
            } else if (type === 'CHILD' && (age < 2 || age >= 12)) {
                alert('Trẻ em phải từ 2 đến dưới 12 tuổi.');
                dobInput.focus();
                valid = false;
                return false;
            } else if (type === 'INFANT' && age >= 2) {
                alert('Em bé phải dưới 2 tuổi.');
                dobInput.focus();
                valid = false;
                return false;
            }
        });
        
        if (!valid) {
            e.preventDefault();
            return false;
        }
        
        return true;
    });
    
    // Cập nhật loại hành khách dựa trên ngày sinh
    $('[id^=dateOfBirth]').change(function() {
        const id = $(this).attr('id');
        const index = id.replace('dateOfBirth', '');
        const dob = new Date($(this).val());
        const today = new Date();
        const age = today.getFullYear() - dob.getFullYear();
        
        const typeSelect = $('#passengerType' + index);
        
        if (age >= 12) {
            typeSelect.val('ADULT');
        } else if (age >= 2) {
            typeSelect.val('CHILD');
        } else {
            typeSelect.val('INFANT');
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 