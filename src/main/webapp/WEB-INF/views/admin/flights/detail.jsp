<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Chi tiết chuyến bay" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Chi tiết chuyến bay</h2>
    <div>
        <a href="${pageContext.request.contextPath}/admin/flights" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
        <a href="${pageContext.request.contextPath}/admin/flights/edit/${flight.flightId}" class="btn btn-primary ms-2">
            <i class="fas fa-edit me-2"></i>Chỉnh sửa
        </a>
    </div>
</div>

<!-- Chi tiết chuyến bay -->
<div class="row">
    <div class="col-lg-8">
        <div class="card shadow mb-4">
            <!-- ... nội dung chi tiết chuyến bay ... -->
        </div>
    </div>
    
    <div class="col-lg-4">
        <!-- Thống kê đặt vé -->
        <div class="card shadow mb-4">
            <!-- ... thống kê đặt vé ... -->
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 