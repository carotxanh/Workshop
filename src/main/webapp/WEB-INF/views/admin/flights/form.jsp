<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="${empty flight.flightId ? 'Thêm chuyến bay mới' : 'Cập nhật chuyến bay'}" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>${empty flight.flightId ? 'Thêm chuyến bay mới' : 'Cập nhật chuyến bay'}</h2>
    <a href="${pageContext.request.contextPath}/admin/flights" class="btn btn-secondary">
        <i class="fas fa-arrow-left me-2"></i>Quay lại
    </a>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 fw-bold text-primary">Thông tin chuyến bay</h6>
    </div>
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/flights/${empty flight.flightId ? 'create' : 'edit'}" 
              method="post" id="flightForm">
            
            <c:if test="${not empty flight.flightId}">
                <input type="hidden" name="flightId" value="${flight.flightId}">
            </c:if>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="flightNumber" class="form-label">Số hiệu chuyến bay <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="flightNumber" name="flightNumber" 
                           value="${flight.flightNumber}" required>
                </div>
                <div class="col-md-6">
                    <label for="airline" class="form-label">Hãng bay <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="airline" name="airline" 
                           value="${flight.airline}" required>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="origin" class="form-label">Điểm khởi hành <span class="text-danger">*</span></label>
                    <select class="form-select" id="origin" name="origin" required>
                        <option value="">Chọn điểm khởi hành</option>
                        <c:forEach items="${origins}" var="origin">
                            <option value="${origin.id}" ${flight.origin eq origin.id ? 'selected' : ''}>${origin.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label for="destination" class="form-label">Điểm đến <span class="text-danger">*</span></label>
                    <select class="form-select" id="destination" name="destination" required>
                        <option value="">Chọn điểm đến</option>
                        <c:forEach items="${destinations}" var="destination">
                            <option value="${destination.id}" ${flight.destination eq destination.id ? 'selected' : ''}>${destination.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-3">
                    <label for="departureDate" class="form-label">Ngày khởi hành <span class="text-danger">*</span></label>
                    <input type="date" class="form-control" id="departureDate" name="departureDate" 
                           value="<fmt:formatDate value="${flight.departureTime}" pattern="yyyy-MM-dd" />" required>
                </div>
                <div class="col-md-3">
                    <label for="departureTime" class="form-label">Giờ khởi hành <span class="text-danger">*</span></label>
                    <input type="time" class="form-control" id="departureTime" name="departureTime" 
                           value="<fmt:formatDate value="${flight.departureTime}" pattern="HH:mm" />" required>
                </div>
                <div class="col-md-3">
                    <label for="arrivalDate" class="form-label">Ngày đến <span class="text-danger">*</span></label>
                    <input type="date" class="form-control" id="arrivalDate" name="arrivalDate" 
                           value="<fmt:formatDate value="${flight.arrivalTime}" pattern="yyyy-MM-dd" />" required>
                </div>
                <div class="col-md-3">
                    <label for="arrivalTime" class="form-label">Giờ đến <span class="text-danger">*</span></label>
                    <input type="time" class="form-control" id="arrivalTime" name="arrivalTime" 
                           value="<fmt:formatDate value="${flight.arrivalTime}" pattern="HH:mm" />" required>
                </div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-4">
                    <label for="price" class="form-label">Giá vé (VNĐ) <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" id="price" name="price" 
                           value="${flight.price}" min="0" step="1000" required>
                </div>
                <div class="col-md-4">
                    <label for="availableSeats" class="form-label">Số ghế <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" id="availableSeats" name="availableSeats" 
                           value="${flight.availableSeats}" min="1" required>
                </div>
                <div class="col-md-4">
                    <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="SCHEDULED" ${flight.status eq 'SCHEDULED' ? 'selected' : ''}>Đã lên lịch</option>
                        <option value="DELAYED" ${flight.status eq 'DELAYED' ? 'selected' : ''}>Trì hoãn</option>
                        <option value="CANCELLED" ${flight.status eq 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        <option value="COMPLETED" ${flight.status eq 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành</option>
                    </select>
                </div>
            </div>
            
            <c:if test="${empty flight.flightId}">
                <h5 class="mt-4 mb-3">Cấu hình ghế</h5>
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="economySeats" class="form-label">Số ghế hạng phổ thông <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="economySeats" name="economySeats" 
                               value="100" min="0" required>
                    </div>
                    <div class="col-md-4">
                        <label for="businessSeats" class="form-label">Số ghế hạng thương gia <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="businessSeats" name="businessSeats" 
                               value="20" min="0" required>
                    </div>
                    <div class="col-md-4">
                        <label for="firstClassSeats" class="form-label">Số ghế hạng nhất <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="firstClassSeats" name="firstClassSeats" 
                               value="10" min="0" required>
                    </div>
                </div>
            </c:if>
            
            <div class="mt-4">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i>${empty flight.flightId ? 'Thêm chuyến bay' : 'Cập nhật'}
                </button>
                <a href="${pageContext.request.contextPath}/admin/flights" class="btn btn-secondary ms-2">
                    <i class="fas fa-times me-2"></i>Hủy
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    $(document).ready(function() {
        // Kiểm tra form trước khi submit
        $('#flightForm').submit(function(event) {
            const origin = $('#origin').val();
            const destination = $('#destination').val();
            
            if (origin === destination) {
                alert('Điểm khởi hành và điểm đến không được trùng nhau');
                event.preventDefault();
                return false;
            }
            
            const departureDate = $('#departureDate').val();
            const departureTime = $('#departureTime').val();
            const arrivalDate = $('#arrivalDate').val();
            const arrivalTime = $('#arrivalTime').val();
            
            const departureDateTime = new Date(departureDate + 'T' + departureTime);
            const arrivalDateTime = new Date(arrivalDate + 'T' + arrivalTime);
            
            if (arrivalDateTime <= departureDateTime) {
                alert('Thời gian đến phải sau thời gian khởi hành');
                event.preventDefault();
                return false;
            }
            
            return true;
        });
    });
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 