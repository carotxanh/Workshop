<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Danh sách chuyến bay - Đặt vé máy bay" />
</jsp:include>

<!-- Main Content -->
<div class="container my-5">
    <div class="row">
        <div class="col-12">
            <h2 class="mb-4 text-center fw-bold">Danh sách chuyến bay</h2>
            
            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <!-- Search Form -->
            <div class="card mb-4 shadow-sm">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/booking" method="get" class="row g-3">
                        <input type="hidden" name="action" value="search">
                        <div class="col-md-4">
                            <label for="origin" class="form-label fw-medium">Điểm khởi hành</label>
                            <select class="form-select" id="origin" name="origin" required>
                                <option value="">Chọn điểm khởi hành</option>
                                <c:forEach items="${locations}" var="location">
                                    <option value="${location.locationId}" ${param.origin == location.locationId ? 'selected' : ''}>${location.name} (${location.city})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="destination" class="form-label fw-medium">Điểm đến</label>
                            <select class="form-select" id="destination" name="destination" required>
                                <option value="">Chọn điểm đến</option>
                                <c:forEach items="${locations}" var="location">
                                    <option value="${location.locationId}" ${param.destination == location.locationId ? 'selected' : ''}>${location.name} (${location.city})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="departureDate" class="form-label fw-medium">Ngày khởi hành</label>
                            <input type="date" class="form-control" id="departureDate" name="departureDate" value="${param.departureDate}" required>
                        </div>
                        <div class="col-12 text-center mt-4">
                            <button type="submit" class="btn btn-primary px-4 py-2">
                                <i class="fas fa-search me-2"></i> Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/booking?action=flights" class="btn btn-outline-secondary px-4 py-2 ms-2">
                                <i class="fas fa-sync-alt me-2"></i> Đặt lại
                            </a>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Flights List -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty flights}">
                            <div class="text-center py-5">
                                <i class="fas fa-plane-slash fa-4x mb-3 text-muted"></i>
                                <h5 class="fw-bold">Không tìm thấy chuyến bay nào</h5>
                                <p class="text-muted">Vui lòng thử lại với các tiêu chí tìm kiếm khác.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr class="fw-medium">
                                            <th>Mã chuyến bay</th>
                                            <th>Hãng bay</th>
                                            <th>Điểm khởi hành</th>
                                            <th>Điểm đến</th>
                                            <th>Ngày khởi hành</th>
                                            <th>Giờ khởi hành</th>
                                            <th>Giờ đến</th>
                                            <th>Ghế trống</th>
                                            <th>Giá vé</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${flights}" var="flight">
                                            <tr>
                                                <td class="fw-medium">${flight.flightNumber}</td>
                                                <td>${flight.airline}</td>
                                                <td>${flight.origin}</td>
                                                <td>${flight.destination}</td>
                                                <td><fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy" /></td>
                                                <td><fmt:formatDate value="${flight.departureTime}" pattern="HH:mm" /></td>
                                                <td><fmt:formatDate value="${flight.arrivalTime}" pattern="HH:mm" /></td>
                                                <td>${flight.availableSeats}</td>
                                                <td class="fw-medium text-primary"><fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VND</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${flight.availableSeats > 0}">
                                                            <a href="${pageContext.request.contextPath}/booking?action=confirm&flightId=${flight.flightId}" class="btn btn-sm btn-primary">
                                                                <i class="fas fa-ticket-alt me-1"></i> Đặt vé
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-sm btn-secondary" disabled>
                                                                <i class="fas fa-ban me-1"></i> Hết vé
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Thiết lập giá trị mặc định cho ngày khởi hành nếu chưa có
        const departureDateInput = document.getElementById('departureDate');
        if (!departureDateInput.value) {
            const today = new Date();
            const formattedDate = today.toISOString().split('T')[0];
            departureDateInput.value = formattedDate;
        }
        
        // Kiểm tra điểm đi và điểm đến không được trùng nhau
        const form = document.querySelector('form');
        form.addEventListener('submit', function(event) {
            const origin = document.getElementById('origin').value;
            const destination = document.getElementById('destination').value;
            
            if (origin === destination && origin !== '') {
                event.preventDefault();
                alert('Điểm khởi hành và điểm đến không được trùng nhau!');
            }
        });
    });
</script>

<jsp:include page="../common/footer.jsp" />