<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Trang chủ" />
</jsp:include>

<div class="hero-section py-5 bg-primary text-white">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h1 class="display-4 fw-bold">Đặt vé máy bay trực tuyến</h1>
                <p class="lead">Tìm kiếm, đặt vé và thanh toán trực tuyến một cách nhanh chóng và tiện lợi.</p>
                <a href="${pageContext.request.contextPath}/flights/search" class="btn btn-light btn-lg mt-3">
                    <i class="fas fa-search me-2"></i>Tìm chuyến bay ngay
                </a>
            </div>
            <div class="col-md-6 text-center">
                <img src="${pageContext.request.contextPath}/resources/images/airplane.png" alt="Airplane" class="img-fluid" style="max-height: 300px;">
            </div>
        </div>
    </div>
</div>

<div class="py-5">
    <div class="container">
        <h2 class="text-center mb-5">Tại sao chọn chúng tôi?</h2>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="fas fa-money-bill-wave fa-3x text-primary mb-3"></i>
                        <h4>Giá cả cạnh tranh</h4>
                        <p>Chúng tôi cung cấp giá vé máy bay tốt nhất từ các hãng hàng không hàng đầu.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="fas fa-shield-alt fa-3x text-primary mb-3"></i>
                        <h4>Thanh toán an toàn</h4>
                        <p>Hệ thống thanh toán an toàn và bảo mật với nhiều phương thức thanh toán.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center">
                        <i class="fas fa-headset fa-3x text-primary mb-3"></i>
                        <h4>Hỗ trợ 24/7</h4>
                        <p>Đội ngũ hỗ trợ khách hàng luôn sẵn sàng giúp đỡ bạn mọi lúc mọi nơi.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="py-5 bg-light">
    <div class="container">
        <h2 class="text-center mb-5">Điểm đến phổ biến</h2>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card h-100 border-0 shadow-sm">
                    <img src="https://source.unsplash.com/random/300x200/?hanoi" class="card-img-top" alt="Hà Nội">
                    <div class="card-body">
                        <h5 class="card-title">Hà Nội</h5>
                        <p class="card-text">Khám phá thủ đô nghìn năm văn hiến với nhiều di tích lịch sử và văn hóa.</p>
                        <a href="${pageContext.request.contextPath}/flights/search?destination=Hà Nội" class="btn btn-outline-primary">Tìm chuyến bay</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card h-100 border-0 shadow-sm">
                    <img src="https://source.unsplash.com/random/300x200/?hochiminh" class="card-img-top" alt="Hồ Chí Minh">
                    <div class="card-body">
                        <h5 class="card-title">Hồ Chí Minh</h5>
                        <p class="card-text">Thành phố năng động với nhịp sống hiện đại và nhiều điểm tham quan hấp dẫn.</p>
                        <a href="${pageContext.request.contextPath}/flights/search?destination=Hồ Chí Minh" class="btn btn-outline-primary">Tìm chuyến bay</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card h-100 border-0 shadow-sm">
                    <img src="https://source.unsplash.com/random/300x200/?danang" class="card-img-top" alt="Đà Nẵng">
                    <div class="card-body">
                        <h5 class="card-title">Đà Nẵng</h5>
                        <p class="card-text">Thành phố biển xinh đẹp với bãi biển trải dài và nhiều danh lam thắng cảnh.</p>
                        <a href="${pageContext.request.contextPath}/flights/search?destination=Đà Nẵng" class="btn btn-outline-primary">Tìm chuyến bay</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 