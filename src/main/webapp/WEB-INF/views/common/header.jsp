<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${param.title} - AirTicket</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                    <i class="fas fa-plane-departure me-2"></i>AirTicket
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/">Trang chủ</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/booking">Đặt vé máy bay</a>
                        </li>
                        <c:if test="${not empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/booking?action=list">Lịch sử đặt vé</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/profileController">Trang cá nhân</a>
                            </li>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/booking-management">Quản trị</a>
                                </li>
                            </c:if>
                        </c:if>
                    </ul>
                    <ul class="navbar-nav">
                        <c:choose>
                            <c:when test="${empty sessionScope.user}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="profileController" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-user me-1"></i>${sessionScope.user.name}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                                        <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">Quản trị</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            </c:if>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profileController">Thông tin cá nhân</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/booking?action=list">Lịch sử đặt vé</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                    </ul>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                                </li>

                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="container mt-4">
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
        </div>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 