<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="${empty flight.flightId ? 'Thêm chuyến bay mới' : 'Cập nhật chuyến bay'}" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>${empty flight.flightId ? 'Thêm chuyến bay mới' : 'Cập nhật chuyến bay'}</h2>
    <div>
        <a href="${pageContext.request.contextPath}/admin/flights" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>
</div>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Thông tin chuyến bay</h6>
    </div>
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/flights/${empty flight.flightId ? 'create' : 'update'}" method="post" id="flightForm">
            <c:if test="${not empty flight.flightId}">
                <input type="hidden" name="flightId" value="${flight.flightId}">
            </c:if>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="flightNumber" class="form-label">Mã chuyến bay <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="flightNumber" name="flightNumber" value="${flight.flightNumber}" required>
                </div>
                <div class="col-md-6">
                    <label for="airline" class="form-label">Hãng hàng không <span class="text-danger">*</span></label>
                    <select class="form-select" id="airline" name="airline" required>
                        <option value="">-- Chọn hãng hàng không --</option>
                        <option value="Vietnam Airlines" ${flight.airline eq 'Vietnam Airlines' ? 'selected' : ''}>Vietnam Airlines</option>
                        <option value="Vietjet Air" ${flight.airline eq 'Vietjet Air' ? 'selected' : ''}>Vietjet Air</option>
                        <option value="Bamboo Airways" ${flight.airline eq 'Bamboo Airways' ? 'selected' : ''}>Bamboo Airways</option>
                        <option value="Pacific Airlines" ${flight.airline eq 'Pacific Airlines' ? 'selected' : ''}>Pacific Airlines</option>
                    </select>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="origin" class="form-label">Điểm khởi hành <span class="text-danger">*</span></label>
                    <select class="form-select" id="origin" name="origin" required>
                        <option value="">-- Chọn điểm khởi hành --</option>
                        <option value="Hà Nội (HAN)" ${flight.origin eq 'Hà Nội (HAN)' ? 'selected' : ''}>Hà Nội (HAN)</option>
                        <option value="Hồ Chí Minh (SGN)" ${flight.origin eq 'Hồ Chí Minh (SGN)' ? 'selected' : ''}>Hồ Chí Minh (SGN)</option>
                        <option value="Đà Nẵng (DAD)" ${flight.origin eq 'Đà Nẵng (DAD)' ? 'selected' : ''}>Đà Nẵng (DAD)</option>
                        <option value="Nha Trang (CXR)" ${flight.origin eq 'Nha Trang (CXR)' ? 'selected' : ''}>Nha Trang (CXR)</option>
                        <option value="Phú Quốc (PQC)" ${flight.origin eq 'Phú Quốc (PQC)' ? 'selected' : ''}>Phú Quốc (PQC)</option>
                        <option value="Huế (HUI)" ${flight.origin eq 'Huế (HUI)' ? 'selected' : ''}>Huế (HUI)</option>
                        <option value="Đà Lạt (DLI)" ${flight.origin eq 'Đà Lạt (DLI)' ? 'selected' : ''}>Đà Lạt (DLI)</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label for="destination" class="form-label">Điểm đến <span class="text-danger">*</span></label>
                    <select class="form-select" id="destination" name="destination" required>
                        <option value="">-- Chọn điểm đến --</option>
                        <option value="Hà Nội (HAN)" ${flight.destination eq 'Hà Nội (HAN)' ? 'selected' : ''}>Hà Nội (HAN)</option>
                        <option value="Hồ Chí Minh (SGN)" ${flight.destination eq 'Hồ Chí Minh (SGN)' ? 'selected' : ''}>Hồ Chí Minh (SGN)</option>
                        <option value="Đà Nẵng (DAD)" ${flight.destination eq 'Đà Nẵng (DAD)' ? 'selected' : ''}>Đà Nẵng (DAD)</option>
                        <option value="Nha Trang (CXR)" ${flight.destination eq 'Nha Trang (CXR)' ? 'selected' : ''}>Nha Trang (CXR)</option>
                        <option value="Phú Quốc (PQC)" ${flight.destination eq 'Phú Quốc (PQC)' ? 'selected' : ''}>Phú Quốc (PQC)</option>
                        <option value="Huế (HUI)" ${flight.destination eq 'Huế (HUI)' ? 'selected' : ''}>Huế (HUI)</option>
                        <option value="Đà Lạt (DLI)" ${flight.destination eq 'Đà Lạt (DLI)' ? 'selected' : ''}>Đà Lạt (DLI)</option>
                    </select>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="departureTime" class="form-label">Thời gian khởi hành <span class="text-danger">*</span></label>
                    <input type="datetime-local" class="form-control" id="departureTime" name="departureTime" 
                           value="<fmt:formatDate value='${flight.departureTime}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required>
                </div>
                <div class="col-md-6">
                    <label for="arrivalTime" class="form-label">Thời gian đến <span class="text-danger">*</span></label>
                    <input type="datetime-local" class="form-control" id="arrivalTime" name="arrivalTime" 
                           value="<fmt:formatDate value='${flight.arrivalTime}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-4">
                    <label for="economyPrice" class="form-label">Giá vé hạng Phổ thông <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <input type="number" class="form-control" id="economyPrice" name="economyPrice" value="${flight.economyPrice}" min="0" required>
                        <span class="input-group-text">VND</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="businessPrice" class="form-label">Giá vé hạng Thương gia <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <input type="number" class="form-control" id="businessPrice" name="businessPrice" value="${flight.businessPrice}" min="0" required>
                        <span class="input-group-text">VND</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="firstClassPrice" class="form-label">Giá vé hạng Nhất</label>
                    <div class="input-group">
                        <input type="number" class="form-control" id="firstClassPrice" name="firstClassPrice" value="${flight.firstClassPrice}" min="0">
                        <span class="input-group-text">VND</span>
                    </div>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-4">
                    <label for="economySeats" class="form-label">Số ghế hạng Phổ thông <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" id="economySeats" name="economySeats" value="${flight.economySeats}" min="0" required>
                </div>
                <div class="col-md-4">
                    <label for="businessSeats" class="form-label">Số ghế hạng Thương gia <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" id="businessSeats" name="businessSeats" value="${flight.businessSeats}" min="0" required>
                </div>
                <div class="col-md-4">
                    <label for="firstClassSeats" class="form-label">Số ghế hạng Nhất</label>
                    <input type="number" class="form-control" id="firstClassSeats" name="firstClassSeats" value="${flight.firstClassSeats}" min="0">
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="SCHEDULED" ${flight.status eq 'SCHEDULED' ? 'selected' : ''}>Đã lên lịch</option>
                        <option value="DELAYED" ${flight.status eq 'DELAYED' ? 'selected' : ''}>Bị trì hoãn</option>
                        <option value="CANCELLED" ${flight.status eq 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        <option value="COMPLETED" ${flight.status eq 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label for="aircraft" class="form-label">Loại máy bay <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="aircraft" name="aircraft" value="${flight.aircraft}" required>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-12">
                    <label for="notes" class="form-label">Ghi chú</label>
                    <textarea class="form-control" id="notes" name="notes" rows="3">${flight.notes}</textarea>
                </div>
            </div>
            
            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-secondary me-2" onclick="window.location.href='${pageContext.request.contextPath}/admin/flights'">Hủy</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i>${empty flight.flightId ? 'Thêm mới' : 'Cập nhật'}
                </button>
            </div>
        </form>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#flightForm').submit(function(e) {
        const origin = $('#origin').val();
        const destination = $('#destination').val();
        
        if (origin === destination) {
            e.preventDefault();
            alert('Điểm khởi hành và điểm đến không được trùng nhau.');
            return false;
        }
        
        const departureTime = new Date($('#departureTime').val());
        const arrivalTime = new Date($('#arrivalTime').val());
        
        if (arrivalTime <= departureTime) {
            e.preventDefault();
            alert('Thời gian đến phải sau thời gian khởi hành.');
            return false;
        }
        
        return true;
    });
});
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 