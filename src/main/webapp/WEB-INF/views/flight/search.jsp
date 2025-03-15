<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Tìm chuyến bay" />
</jsp:include>

<div class="card shadow">
    <div class="card-body p-4">
        <h2 class="card-title text-center mb-4">Tìm kiếm chuyến bay</h2>
        
        <form action="${pageContext.request.contextPath}/flights/search" method="post">
            <div class="row g-3">
                <div class="col-md-6">
                    <label for="origin" class="form-label">Điểm khởi hành</label>
                    <select class="form-select" id="origin" name="origin" required>
                        <option value="" selected disabled>Chọn điểm khởi hành</option>
                        <option value="Hà Nội" ${origin == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                        <option value="Hồ Chí Minh" ${origin == 'Hồ Chí Minh' ? 'selected' : ''}>Hồ Chí Minh</option>
                        <option value="Đà Nẵng" ${origin == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                        <option value="Nha Trang" ${origin == 'Nha Trang' ? 'selected' : ''}>Nha Trang</option>
                        <option value="Phú Quốc" ${origin == 'Phú Quốc' ? 'selected' : ''}>Phú Quốc</option>
                    </select>
                    <c:if test="${not empty originError}">
                        <div class="text-danger">${originError}</div>
                    </c:if>
                </div>
                
                <div class="col-md-6">
                    <label for="destination" class="form-label">Điểm đến</label>
                    <select class="form-select" id="destination" name="destination" required>
                        <option value="" selected disabled>Chọn điểm đến</option>
                        <option value="Hà Nội" ${destination == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                        <option value="Hồ Chí Minh" ${destination == 'Hồ Chí Minh' ? 'selected' : ''}>Hồ Chí Minh</option>
                        <option value="Đà Nẵng" ${destination == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                        <option value="Nha Trang" ${destination == 'Nha Trang' ? 'selected' : ''}>Nha Trang</option>
                        <option value="Phú Quốc" ${destination == 'Phú Quốc' ? 'selected' : ''}>Phú Quốc</option>
                    </select>
                    <c:if test="${not empty destinationError}">
                        <div class="text-danger">${destinationError}</div>
                    </c:if>
                </div>
                
                <div class="col-md-6">
                    <label for="departureDate" class="form-label">Ngày khởi hành</label>
                    <input type="date" class="form-control" id="departureDate" name="departureDate" value="${departureDate}" required>
                    <c:if test="${not empty departureDateError}">
                        <div class="text-danger">${departureDateError}</div>
                    </c:if>
                </div>
                
                <div class="col-md-6">
                    <label for="passengers" class="form-label">Số hành khách</label>
                    <select class="form-select" id="passengers" name="passengers">
                        <option value="1" selected>1 người</option>
                        <option value="2">2 người</option>
                        <option value="3">3 người</option>
                        <option value="4">4 người</option>
                        <option value="5">5 người</option>
                    </select>
                </div>
                
                <div class="col-12 mt-4">
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-search me-2"></i>Tìm chuyến bay
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="mt-5">
    <h3 class="mb-4">Các điểm đến phổ biến</h3>
    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <img src="https://source.unsplash.com/random/300x200/?danang" class="card-img-top" alt="Đà Nẵng">
                <div class="card-body">
                    <h5 class="card-title">Đà Nẵng</h5>
                    <p class="card-text">Thành phố biển xinh đẹp với bãi biển trải dài và nhiều danh lam thắng cảnh.</p>
                    <a href="${pageContext.request.contextPath}/flights/search?destination=Đà Nẵng" class="btn btn-outline-primary">Tìm chuyến bay</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <img src="https://source.unsplash.com/random/300x200/?phuquoc" class="card-img-top" alt="Phú Quốc">
                <div class="card-body">
                    <h5 class="card-title">Phú Quốc</h5>
                    <p class="card-text">Hòn đảo thiên đường với bãi biển cát trắng, nước biển trong xanh và nhiều khu nghỉ dưỡng cao cấp.</p>
                    <a href="${pageContext.request.contextPath}/flights/search?destination=Phú Quốc" class="btn btn-outline-primary">Tìm chuyến bay</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <img src="https://source.unsplash.com/random/300x200/?nhatrang" class="card-img-top" alt="Nha Trang">
                <div class="card-body">
                    <h5 class="card-title">Nha Trang</h5>
                    <p class="card-text">Thành phố biển nổi tiếng với bãi biển đẹp, ẩm thực phong phú và nhiều hoạt động giải trí.</p>
                    <a href="${pageContext.request.contextPath}/flights/search?destination=Nha Trang" class="btn btn-outline-primary">Tìm chuyến bay</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 