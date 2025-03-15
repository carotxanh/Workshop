<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Trang chủ" />
</jsp:include>

<!-- Hero Section -->
<div class="container-fluid bg-primary text-white py-5">
    <div class="container py-5">
        <div class="row">
            <div class="col-md-6">
                <h1 class="display-4 fw-bold mb-4">Đặt vé máy bay dễ dàng, nhanh chóng</h1>
                <p class="lead mb-4">Tìm kiếm và đặt vé máy bay với giá tốt nhất cho chuyến đi của bạn</p>

                <c:if test="${empty sessionScope.user}">
                    <div class="d-flex gap-3">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-light btn-lg">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg">Đăng ký</a>
                    </div>
                </c:if>
            </div>
            <div class="col-md-6">
                <!-- Form tìm kiếm chuyến bay -->
                <div class="card shadow">
                    <div class="card-body p-4">
                        <h4 class="card-title text-dark mb-4">Tìm chuyến bay</h4>
                        <form action="${pageContext.request.contextPath}/flights/search" method="get">
                            <div class="mb-3">
                                <label for="origin" class="form-label text-dark">Điểm đi</label>
                                <select class="form-select" id="origin" name="origin" required>
                                    <option value="">Chọn điểm đi</option>
                                    <option value="Hà Nội">Hà Nội</option>
                                    <option value="Hồ Chí Minh">Hồ Chí Minh</option>
                                    <option value="Đà Nẵng">Đà Nẵng</option>
                                    <option value="Nha Trang">Nha Trang</option>
                                    <option value="Phú Quốc">Phú Quốc</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="destination" class="form-label text-dark">Điểm đến</label>
                                <select class="form-select" id="destination" name="destination" required>
                                    <option value="">Chọn điểm đến</option>
                                    <option value="Hà Nội">Hà Nội</option>
                                    <option value="Hồ Chí Minh">Hồ Chí Minh</option>
                                    <option value="Đà Nẵng">Đà Nẵng</option>
                                    <option value="Nha Trang">Nha Trang</option>
                                    <option value="Phú Quốc">Phú Quốc</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="departureDate" class="form-label text-dark">Ngày đi</label>
                                <input type="date" class="form-control" id="departureDate" name="departureDate" required>
                            </div>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Tìm chuyến bay</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Upcoming Flights Section -->
<div class="container py-5">
    <h2 class="text-center mb-4">Các chuyến bay sắp tới</h2>

    <div class="row">
        <c:choose>
            <c:when test="${not empty upcomingFlights}">
                <c:forEach var="flight" items="${upcomingFlights}">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="card-title mb-0">${flight.airline}</h5>
                                    <span class="badge bg-primary">${flight.flightNumber}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <div>
                                        <p class="mb-0 fw-bold">${flight.origin}</p>
                                        <p class="text-muted small">
                                            <fmt:formatDate value="${flight.departureTime}" pattern="HH:mm, dd/MM/yyyy" />
                                        </p>
                                    </div>
                                    <div class="text-center">
                                        <i class="fas fa-plane"></i>
                                    </div>
                                    <div class="text-end">
                                        <p class="mb-0 fw-bold">${flight.destination}</p>
                                        <p class="text-muted small">
                                            <fmt:formatDate value="${flight.arrivalTime}" pattern="HH:mm, dd/MM/yyyy" />
                                        </p>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <p class="mb-0 text-success fw-bold">
                                        <fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/flights/detail?id=${flight.flightId}" class="btn btn-outline-primary btn-sm">Chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center">
                    <p>Không có chuyến bay nào sắp tới.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Features Section -->
<div class="container-fluid bg-light py-5">
    <div class="container">
        <h2 class="text-center mb-5">Tại sao chọn chúng tôi?</h2>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="card border-0 bg-transparent h-100">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <i class="fas fa-money-bill-wave fa-3x text-primary"></i>
                        </div>
                        <h4>Giá cả cạnh tranh</h4>
                        <p>Chúng tôi cung cấp giá vé máy bay tốt nhất từ các hãng hàng không hàng đầu.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-transparent h-100">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <i class="fas fa-headset fa-3x text-primary"></i>
                        </div>
                        <h4>Hỗ trợ 24/7</h4>
                        <p>Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng giúp đỡ bạn mọi lúc, mọi nơi.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 bg-transparent h-100">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <i class="fas fa-shield-alt fa-3x text-primary"></i>
                        </div>
                        <h4>Đảm bảo an toàn</h4>
                        <p>Thanh toán an toàn và bảo mật thông tin cá nhân của bạn là ưu tiên hàng đầu của chúng tôi.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Popular Destinations -->
<div class="container py-5">
    <h2 class="text-center mb-5">Điểm đến phổ biến</h2>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card bg-dark text-white h-100">
                <img src="${pageContext.request.contextPath}/resources/images/hanoi.jpg" class="card-img" alt="Hà Nội" onerror="this.src='https://via.placeholder.com/400x300?text=Hà+Nội'">
                <div class="card-img-overlay d-flex flex-column justify-content-end" style="background: linear-gradient(to top, rgba(0,0,0,0.7), rgba(0,0,0,0));">
                    <h5 class="card-title">Hà Nội</h5>
                    <p class="card-text">Khám phá thủ đô nghìn năm văn hiến với nhiều di tích lịch sử và văn hóa.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card bg-dark text-white h-100">
                <img src="${pageContext.request.contextPath}/resources/images/hochiminh.jpg" class="card-img" alt="Hồ Chí Minh" onerror="this.src='https://via.placeholder.com/400x300?text=Hồ+Chí+Minh'">
                <div class="card-img-overlay d-flex flex-column justify-content-end" style="background: linear-gradient(to top, rgba(0,0,0,0.7), rgba(0,0,0,0));">
                    <h5 class="card-title">Hồ Chí Minh</h5>
                    <p class="card-text">Thành phố năng động với nhịp sống hiện đại và nhiều điểm tham quan hấp dẫn.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card bg-dark text-white h-100">
                <img src="${pageContext.request.contextPath}/resources/images/danang.jpg" class="card-img" alt="Đà Nẵng" onerror="this.src='https://via.placeholder.com/400x300?text=Đà+Nẵng'">
                <div class="card-img-overlay d-flex flex-column justify-content-end" style="background: linear-gradient(to top, rgba(0,0,0,0.7), rgba(0,0,0,0));">
                    <h5 class="card-title">Đà Nẵng</h5>
                    <p class="card-text">Thành phố biển xinh đẹp với bãi biển trải dài và cảnh quan thiên nhiên tuyệt vời.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />