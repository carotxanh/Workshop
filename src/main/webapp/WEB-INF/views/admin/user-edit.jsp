<%-- 
    Document   : user-edit
    Created on : Mar 16, 2025, 5:15:02 PM
    Author     : FPTSHOP
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${empty user ? 'Add New User' : 'Edit User'} - Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #4e73df;
                --secondary-color: #858796;
                --success-color: #1cc88a;
                --info-color: #36b9cc;
                --warning-color: #f6c23e;
                --danger-color: #e74a3b;
                --light-color: #f8f9fc;
                --dark-color: #5a5c69;
            }
            
            body {
                background-color: #f8f9fc;
                font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            }
            
            /* Sidebar styles */
            .sidebar {
                position: fixed;
                top: 0;
                bottom: 0;
                left: 0;
                z-index: 100;
                padding: 48px 0 0;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
                background: linear-gradient(180deg, var(--primary-color) 10%, #224abe 100%);
                transition: all 0.3s;
            }
            
            .sidebar-sticky {
                position: relative;
                top: 0;
                height: calc(100vh - 48px);
                padding-top: .5rem;
                overflow-x: hidden;
                overflow-y: auto;
            }
            
            .sidebar .nav-link {
                font-weight: 700;
                color: rgba(255, 255, 255, 0.8);
                padding: 1rem;
                margin-bottom: 0.2rem;
                border-radius: 0.35rem;
                transition: all 0.3s;
            }
            
            .sidebar .nav-link i {
                margin-right: 0.5rem;
                color: rgba(255, 255, 255, 0.3);
                transition: all 0.3s;
            }
            
            .sidebar .nav-link.active {
                color: #fff;
                background-color: rgba(255, 255, 255, 0.1);
            }
            
            .sidebar .nav-link.active i {
                color: #fff;
            }
            
            .sidebar .nav-link:hover {
                color: #fff;
                background-color: rgba(255, 255, 255, 0.1);
            }
            
            .sidebar .nav-link:hover i {
                color: #fff;
            }
            
            .sidebar-heading {
                font-size: .75rem;
                text-transform: uppercase;
                color: rgba(255, 255, 255, 0.5);
                font-weight: 800;
                letter-spacing: 0.05rem;
                padding: 0.75rem 1rem;
            }
            
            main {
                padding-top: 24px;
            }
            
            .card {
                border: none;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
                border-radius: 0.5rem;
                margin-bottom: 1.5rem;
            }
            
            .card-header {
                background-color: #f8f9fc;
                border-bottom: 1px solid #e3e6f0;
                padding: 1rem 1.35rem;
                font-weight: 700;
                color: var(--dark-color);
            }
            
            .form-control:focus, .form-select:focus {
                border-color: #bac8f3;
                box-shadow: 0 0 0 0.25rem rgba(78, 115, 223, 0.25);
            }
            
            .form-label {
                font-weight: 600;
                color: var(--dark-color);
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="../common/header.jsp">
            <jsp:param name="title" value="${empty user ? 'Add New User' : 'Edit User'}" />
        </jsp:include>

        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                    <div class="position-sticky pt-3 sidebar-sticky">
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-speedometer2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/booking-management">
                                    <i class="bi bi-calendar-check"></i>Bookings
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/flight-management">
                                    <i class="bi bi-airplane"></i>Flights
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/user-management">
                                    <i class="bi bi-people"></i>Users
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                                    <i class="bi bi-graph-up"></i>Reports
                                </a>
                            </li>
                        </ul>
                        
                        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1">
                            <span>System</span>
                        </h6>
                        <ul class="nav flex-column mb-2">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings">
                                    <i class="bi bi-gear"></i>Settings
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right"></i>Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>

                <!-- Main Content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">${empty user ? 'Add New User' : 'Edit User'}</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <a href="user-management" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-arrow-left"></i> Back to List
                                </a>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="bi bi-person-fill me-1"></i>
                            ${empty user ? 'Create New User' : 'Edit User Details'}
                        </div>
                        <div class="card-body">
                            <form action="user-management" method="post">
                                <input type="hidden" name="action" value="${empty user ? 'create' : 'update'}">
                                <c:if test="${not empty user}">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                </c:if>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <div class="card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <i class="bi bi-person-fill me-1"></i> Personal Information
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label for="name" class="form-label">Full Name</label>
                                                    <input type="text" class="form-control" id="name" name="name" 
                                                           value="${user.name}" required>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="email" class="form-label">Email</label>
                                                    <input type="email" class="form-control" id="email" name="email" 
                                                           value="${user.email}" required>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="phone" class="form-label">Phone</label>
                                                    <input type="text" class="form-control" id="phone" name="phone" 
                                                           value="${user.phone}">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="card h-100">
                                            <div class="card-header bg-info text-white">
                                                <i class="bi bi-shield-lock-fill me-1"></i> Account Information
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label for="password" class="form-label">
                                                        Password ${empty user ? '' : '(Leave blank to keep current password)'}
                                                    </label>
                                                    <input type="password" class="form-control" id="password" name="password" 
                                                           ${empty user ? 'required' : ''}>
                                                    <c:if test="${not empty user}">
                                                        <div class="form-text">Leave blank to keep the current password.</div>
                                                    </c:if>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="role" class="form-label">Role</label>
                                                    <select class="form-select" id="role" name="role" required>
                                                        <c:forEach var="roleOption" items="${roles}">
                                                            <option value="${roleOption}" ${user.role == roleOption ? 'selected' : ''}>
                                                                ${roleOption}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <c:if test="${not empty user}">
                                                    <div class="mb-3">
                                                        <label class="form-label">Created At</label>
                                                        <p class="form-control-plaintext">
                                                            <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                        </p>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="user-management" class="btn btn-secondary me-md-2">
                                        <i class="bi bi-x-circle me-1"></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-1"></i> ${empty user ? 'Create User' : 'Save Changes'}
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Include Footer -->
        <jsp:include page="../common/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
