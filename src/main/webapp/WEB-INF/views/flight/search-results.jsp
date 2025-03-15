<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Kết quả tìm kiếm" />
</jsp:include>

<div class="card shadow mb-4">
    <div class="card-body">
        <h3 class="card-title">Thông tin tìm kiếm</h3>
        <div class="row">
            <div class="col-md-3">
                <p class="mb-1"><strong>Điểm khởi hành:</strong></p>
                <p>${origin}</p>
            </div>
            <div class="col-md-3">
                <p class="mb-1"><strong>Điểm đến:</strong></p>
                <p>${destination}</p>
            </div>
            <div class="col-md-3">
                <p class="mb-1"><strong>Ngày khởi hành:</strong></p>
                <p>${departureDate}</p>
            </div>
            <div class="col-md-3 text-md-end">
                <a href="${pageContext.request.contextPath}/flights/search" class="btn btn-outline-primary">
                    <i class="fas fa-edit me-1"></i>Thay đổi tìm kiếm
                </a>
            </div>
        </div>
    </div>
</div>

<h2 class="mb-4">Kết quả tìm kiếm chuyến bay</h2>

<c:choose>
    <c:when test="${empty flights}">
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i>Không tìm thấy chuyến bay phù hợp. Vui lòng thử lại với các tiêu chí khác.
        </div>
    </c:when>
    <c:otherwise>
        <div class="row">
            <c:forEach items="${flights}" var="flight">
                <div class="col-12 mb-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-2 text-center">
                                    <c:choose>
                                        <c:when test="${flight.airline eq 'Vietnam Airlines'}">
                                            <img src="${pageContext.request.contextPath}/resources/images/vietnam-airlines.png" alt="Vietnam Airlines" class="img-fluid" style="max-height: 50px;">
                                        </c:when>
                                        <c:when test="${flight.airline eq 'Vietjet Air'}">
                                            <img src="${pageContext.request.contextPath}/resources/images/vietjet.png" alt="Vietjet Air" class="img-fluid" style="max-height: 50px;">
                                        </c:when>
                                        <c:when test="${flight.airline eq 'Bamboo Airways'}">
                                            <img src="${pageContext.request.contextPath}/resources/images/bamboo.png" alt="Bamboo Airways" class="img-fluid" style="max-height: 50px;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="fw-bold">${flight.airline}</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="small mt-2">${flight.flightNumber}</div>
                                </div>
                                <div class="col-md-3">
                                    <div class="fs-5 fw-bold">
                                        <fmt:formatDate value="${flight.departureTime}" pattern="HH:mm" />
                                    </div>
                                    <div>${flight.origin}</div>
                                    <div class="small text-muted">
                                        <fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy" />
                                    </div>
                                </div>
                                <div class="col-md-2 text-center">
                                    <div class="text-muted small">
                                        <fmt:formatDate value="${flight.duration}" pattern="HH:mm" /> giờ
                                    </div>
                                    <div class="flight-path">
                                        <i class="fas fa-plane"></i>
                                    </div>
                                    <div class="text-muted small">Bay thẳng</div>
                                </div>
                                <div class="col-md-3">
                                    <div class="fs-5 fw-bold">
                                        <fmt:formatDate value="${flight.arrivalTime}" pattern="HH:mm" />
                                    </div>
                                    <div>${flight.destination}</div>
                                    <div class="small text-muted">
                                        <fmt:formatDate value="${flight.arrivalTime}" pattern="dd/MM/yyyy" />
                                    </div>
                                </div>
                                <div class="col-md-2 text-end">
                                    <div class="fs-5 fw-bold text-primary">
                                        <fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                    </div>
                                    <a href="${pageContext.request.contextPath}/flights/detail?id=${flight.flightId}" class="btn btn-primary mt-2">
                                        Chọn
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 