<%-- 
    Document   : booking-detail
    Created on : Mar 16, 2025, 3:29:11 PM
    Author     : FPTSHOP
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Booking Details - Admin Dashboard</title>
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
                padding: 1rem 1.25rem;
                font-weight: 700;
                color: var(--dark-color);
                border-top-left-radius: 0.5rem !important;
                border-top-right-radius: 0.5rem !important;
            }
            
            .card-header i {
                color: var(--primary-color);
            }
            
            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }
            
            .btn-primary:hover {
                background-color: #2e59d9;
                border-color: #2e59d9;
            }
            
            .btn-success {
                background-color: var(--success-color);
                border-color: var(--success-color);
            }
            
            .btn-success:hover {
                background-color: #17a673;
                border-color: #17a673;
            }
            
            .btn-danger {
                background-color: var(--danger-color);
                border-color: var(--danger-color);
            }
            
            .btn-danger:hover {
                background-color: #e02d1b;
                border-color: #e02d1b;
            }
            
            .table th {
                font-weight: 700;
                color: var(--dark-color);
                background-color: #f8f9fc;
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="../common/header.jsp">
            <jsp:param name="title" value="Booking Details" />
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
                                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/booking-management">
                                    <i class="bi bi-calendar-check"></i>Bookings
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/flight-management">
                                    <i class="bi bi-airplane"></i>Flights
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/user-management">
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
                        <h1 class="h2">Booking Details</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <a href="booking-management" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-arrow-left"></i> Back to List
                                </a>
                                <a href="booking-management?action=edit&id=${booking.bookingId}" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                <button class="btn btn-sm btn-outline-secondary" onclick="window.print()">
                                    <i class="bi bi-printer"></i> Print
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <!-- Status Badge -->
                    <div class="mb-4">
                        <span class="badge fs-6 
                            <c:choose>
                                <c:when test="${booking.status == 'CONFIRMED'}">bg-success</c:when>
                                <c:when test="${booking.status == 'PENDING'}">bg-warning text-dark</c:when>
                                <c:when test="${booking.status == 'CANCELLED'}">bg-danger</c:when>
                                <c:when test="${booking.status == 'COMPLETED'}">bg-primary</c:when>
                            </c:choose>">
                            <i class="bi 
                                <c:choose>
                                    <c:when test="${booking.status == 'CONFIRMED'}">bi-check-circle-fill</c:when>
                                    <c:when test="${booking.status == 'PENDING'}">bi-hourglass-split</c:when>
                                    <c:when test="${booking.status == 'CANCELLED'}">bi-x-circle-fill</c:when>
                                    <c:when test="${booking.status == 'COMPLETED'}">bi-check-square-fill</c:when>
                                </c:choose> me-1"></i>
                            ${booking.status}
                        </span>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="bi bi-person-fill me-1"></i>
                                    Passenger Information
                                </div>
                                <div class="card-body">
                                    <table class="table table-striped">
                                        <tr>
                                            <th style="width: 30%">Name:</th>
                                            <td>${booking.passengerName}</td>
                                        </tr>
                                        <tr>
                                            <th>Email:</th>
                                            <td>${booking.passengerEmail}</td>
                                        </tr>
                                        <tr>
                                            <th>Phone:</th>
                                            <td>${booking.passengerPhone}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="bi bi-credit-card-fill me-1"></i>
                                    Payment Information
                                </div>
                                <div class="card-body">
                                    <table class="table table-striped">
                                        <tr>
                                            <th style="width: 30%">Total Price:</th>
                                            <td>$<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                        </tr>
                                        <tr>
                                            <th>Payment Method:</th>
                                            <td>${booking.paymentMethod}</td>
                                        </tr>
                                        <tr>
                                            <th>Payment Status:</th>
                                            <td>
                                                <span class="badge 
                                                    <c:choose>
                                                        <c:when test="${booking.paymentStatus == 'PAID'}">bg-success</c:when>
                                                        <c:when test="${booking.paymentStatus == 'PENDING'}">bg-warning text-dark</c:when>
                                                        <c:when test="${booking.paymentStatus == 'FAILED'}">bg-danger</c:when>
                                                        <c:when test="${booking.paymentStatus == 'REFUNDED'}">bg-info</c:when>
                                                    </c:choose>">
                                                    ${booking.paymentStatus}
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="bi bi-airplane-fill me-1"></i>
                                    Flight Information
                                </div>
                                <div class="card-body">
                                    <c:if test="${not empty booking.flight}">
                                        <table class="table table-striped">
                                            <tr>
                                                <th style="width: 30%">Flight Number:</th>
                                                <td>${booking.flight.flightNumber}</td>
                                            </tr>
                                            <tr>
                                                <th>Route:</th>
                                                <td>${booking.flight.origin} → ${booking.flight.destination}</td>
                                            </tr>
                                            <tr>
                                                <th>Departure:</th>
                                                <td><fmt:formatDate value="${booking.flight.departureTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            </tr>
                                            <tr>
                                                <th>Arrival:</th>
                                                <td><fmt:formatDate value="${booking.flight.arrivalTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            </tr>
                                            <tr>
                                                <th>Seat:</th>
                                                <td>${booking.seatNumber}</td>
                                            </tr>
                                        </table>
                                    </c:if>
                                    <c:if test="${empty booking.flight}">
                                        <p class="text-muted">No flight information available</p>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="bi bi-info-circle-fill me-1"></i>
                                    Booking Information
                                </div>
                                <div class="card-body">
                                    <table class="table table-striped">
                                        <tr>
                                            <th style="width: 30%">Booking ID:</th>
                                            <td>${booking.bookingId}</td>
                                        </tr>
                                        <tr>
                                            <th>Booking Date:</th>
                                            <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        </tr>
                                        <tr>
                                            <th>Created At:</th>
                                            <td><fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        </tr>
                                        <tr>
                                            <th>Updated At:</th>
                                            <td><fmt:formatDate value="${booking.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="bi bi-gear-fill me-1"></i>
                            Actions
                        </div>
                        <div class="card-body">
                            <div class="d-flex gap-2">
                                <c:if test="${booking.status != 'CONFIRMED' && booking.status != 'COMPLETED'}">
                                    <button type="button" class="btn btn-success" onclick="updateStatus('${booking.bookingId}', 'CONFIRMED')">
                                        <i class="bi bi-check-circle-fill me-1"></i> Confirm Booking
                                    </button>
                                </c:if>
                                
                                <c:if test="${booking.status != 'COMPLETED' && booking.status != 'CANCELLED'}">
                                    <button type="button" class="btn btn-primary" onclick="updateStatus('${booking.bookingId}', 'COMPLETED')">
                                        <i class="bi bi-check-square-fill me-1"></i> Mark as Completed
                                    </button>
                                </c:if>
                                
                                <c:if test="${booking.status != 'CANCELLED'}">
                                    <button type="button" class="btn btn-danger" onclick="updateStatus('${booking.bookingId}', 'CANCELLED')">
                                        <i class="bi bi-x-circle-fill me-1"></i> Cancel Booking
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        
        <!-- Include Footer -->
        <jsp:include page="../common/footer.jsp" />
        
        <!-- Status Update Form (Hidden) -->
        <form id="statusForm" action="booking-management" method="post" style="display: none;">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" id="bookingId" name="bookingId" value="">
            <input type="hidden" id="status" name="status" value="">
        </form>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function updateStatus(bookingId, status) {
                if (confirm('Are you sure you want to change the status to ' + status + '?')) {
                    document.getElementById('bookingId').value = bookingId;
                    document.getElementById('status').value = status;
                    document.getElementById('statusForm').submit();
                }
            }
        </script>
    </body>
</html>
