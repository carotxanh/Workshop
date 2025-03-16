<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Trang chủ - Đặt vé máy bay" />
</jsp:include>

<!-- Hero Section -->
<div class="hero-section py-5 bg-primary text-white">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h1 class="display-4 fw-bold mb-4">Đặt vé máy bay online</h1>
                <p class="lead mb-4">Tìm kiếm và đặt vé máy bay với giá tốt nhất. Dễ dàng, nhanh chóng và an toàn.</p>
                <a href="${pageContext.request.contextPath}/booking" class="btn btn-light btn-lg">Đặt vé ngay</a>
            </div>
            <div class="col-md-6">
                <div class="card shadow-lg">
                    <div class="card-body p-4">
                        <h3 class="card-title text-dark mb-4">Tìm kiếm chuyến bay</h3>
                        <form action="${pageContext.request.contextPath}/booking" method="get">
                            <input type="hidden" name="action" value="search">
                            <div class="mb-3">
                                <label for="origin" class="form-label text-dark">Điểm khởi hành</label>
                                <select class="form-select" id="origin" name="origin" required>
                                    <option value="">Chọn điểm đi</option>
                                    <c:forEach items="${origins}" var="origin">
                                        <option value="${origin.locationId}">${origin.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="destination" class="form-label text-dark">Điểm đến</label>
                                <select class="form-select" id="destination" name="destination" required>
                                    <option value="">Chọn điểm đến</option>
                                    <c:forEach items="${destinations}" var="destination">
                                        <option value="${destination.locationId}">${destination.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="departureDate" class="form-label text-dark">Ngày khởi hành</label>
                                <input type="date" class="form-control" id="departureDate" name="departureDate" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Features Section -->
<div class="container my-5">
    <div class="row text-center">
        <div class="col-12">
            <h2 class="mb-5">Tại sao chọn chúng tôi?</h2>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body p-4">
                    <i class="fas fa-money-bill-wave fa-3x text-primary mb-3"></i>
                    <h4 class="card-title">Giá cả cạnh tranh</h4>
                    <p class="card-text">Chúng tôi cung cấp giá vé máy bay tốt nhất với nhiều ưu đãi hấp dẫn.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body p-4">
                    <i class="fas fa-shield-alt fa-3x text-primary mb-3"></i>
                    <h4 class="card-title">Đảm bảo an toàn</h4>
                    <p class="card-text">Thanh toán an toàn và bảo mật thông tin cá nhân của khách hàng.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body p-4">
                    <i class="fas fa-headset fa-3x text-primary mb-3"></i>
                    <h4 class="card-title">Hỗ trợ 24/7</h4>
                    <p class="card-text">Đội ngũ hỗ trợ khách hàng luôn sẵn sàng giúp đỡ bạn mọi lúc.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Popular Destinations -->
<div class="container my-5">
    <div class="row">
        <div class="col-12 text-center mb-4">
            <h2>Điểm đến phổ biến</h2>
            <p class="lead">Khám phá những điểm đến hàng đầu với giá vé hấp dẫn</p>
        </div>
    </div>
    <div class="row">
        <c:forEach items="${destinations}" var="destination" begin="0" end="5">
            <div class="col-md-4 mb-4">
                <div class="card destination-card shadow-sm">
                    <div class="card-body p-4">
                        <h4 class="card-title">${destination.name}</h4>
                        <p class="card-text">${destination.city}, ${destination.country}</p>
                        <a href="${pageContext.request.contextPath}/booking?action=search&destination=${destination.locationId}" class="btn btn-outline-primary">Xem chuyến bay</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Thiết lập giá trị mặc định cho ngày khởi hành là ngày hiện tại
        const today = new Date();
        const formattedDate = today.toISOString().split('T')[0];
        document.getElementById('departureDate').value = formattedDate;
        
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

<jsp:include page="/WEB-INF/views/common/footer.jsp" />