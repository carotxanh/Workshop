<%-- 
    Document   : user-list
    Created on : Mar 16, 2025, 5:14:40 PM
    Author     : FPTSHOP
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Management - Admin Dashboard</title>
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
            
            .table {
                color: #5a5c69;
            }
            
            .table th {
                font-weight: 700;
                color: #4e73df;
            }
            
            .badge-role {
                font-size: 0.75rem;
                padding: 0.25rem 0.5rem;
            }
            
            .badge-admin {
                background-color: #4e73df;
                color: white;
            }
            
            .badge-customer {
                background-color: #1cc88a;
                color: white;
            }
            
            .badge-user {
                background-color: #f6c23e;
                color: white;
            }
            
            .action-buttons .btn {
                padding: 0.25rem 0.5rem;
                font-size: 0.75rem;
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="../common/header.jsp">
            <jsp:param name="title" value="User Management" />
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
                        <h1 class="h2">User Management</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <a href="user-management?action=create" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-person-plus"></i> Add New User
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Success and Error Messages -->
                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="success" scope="session" />
                    </c:if>
                    
                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="error" scope="session" />
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- User List Card -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="bi bi-people-fill me-1"></i>
                            User List
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Role</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.userId}</td>
                                                <td>${user.name}</td>
                                                <td>${user.email}</td>
                                                <td>${user.phone}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.role == 'ADMIN'}">
                                                            <span class="badge badge-role badge-admin">ADMIN</span>
                                                        </c:when>
                                                        <c:when test="${user.role == 'CUSTOMER'}">
                                                            <span class="badge badge-role badge-customer">CUSTOMER</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-role badge-user">USER</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                <td class="action-buttons">
                                                    <a href="user-management?action=view&id=${user.userId}" class="btn btn-info btn-sm">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="user-management?action=edit&id=${user.userId}" class="btn btn-primary btn-sm">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-danger btn-sm" 
                                                            data-bs-toggle="modal" data-bs-target="#deleteModal${user.userId}">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                    
                                                    <!-- Delete Confirmation Modal -->
                                                    <div class="modal fade" id="deleteModal${user.userId}" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    Are you sure you want to delete user <strong>${user.name}</strong>?
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    <a href="user-management?action=delete&id=${user.userId}" class="btn btn-danger">Delete</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty users}">
                                            <tr>
                                                <td colspan="7" class="text-center">No users found</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
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
