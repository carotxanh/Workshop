<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Booking Management - Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
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
                font-size: 0.75rem;
                font-weight: 800;
                text-transform: uppercase;
                color: rgba(255, 255, 255, 0.4);
                padding: 0 1rem;
                margin-top: 1.5rem;
                margin-bottom: 0.5rem;
            }
            
            main {
                padding-top: 24px;
            }
            
            /* Card styles */
            .card {
                border: none;
                border-radius: 0.35rem;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
                margin-bottom: 1.5rem;
            }
            
            .card-header {
                background-color: #f8f9fc;
                border-bottom: 1px solid #e3e6f0;
                padding: 0.75rem 1.25rem;
                font-weight: 700;
                color: var(--dark-color);
            }
            
            /* Dashboard card styles */
            .stat-card {
                border-left: 0.25rem solid;
                border-radius: 0.35rem;
                transition: transform 0.2s;
            }
            
            .stat-card:hover {
                transform: translateY(-3px);
            }
            
            .stat-card.primary {
                border-left-color: var(--primary-color);
            }
            
            .stat-card.success {
                border-left-color: var(--success-color);
            }
            
            .stat-card.warning {
                border-left-color: var(--warning-color);
            }
            
            .stat-card.info {
                border-left-color: var(--info-color);
            }
            
            .stat-card .card-body {
                padding: 1.25rem;
            }
            
            .stat-card .stat-title {
                text-transform: uppercase;
                font-size: 0.7rem;
                font-weight: 700;
                color: var(--secondary-color);
                margin-bottom: 0.25rem;
            }
            
            .stat-card .stat-value {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--dark-color);
                margin-bottom: 0;
            }
            
            .stat-card .stat-icon {
                font-size: 2rem;
                opacity: 0.3;
            }
            
            /* Table styles */
            .table-container {
                background-color: #fff;
                border-radius: 0.35rem;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
                margin-bottom: 1.5rem;
            }
            
            .table-header {
                background-color: #f8f9fc;
                border-bottom: 1px solid #e3e6f0;
                padding: 1rem 1.25rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .table-title {
                font-weight: 700;
                color: var(--dark-color);
                margin-bottom: 0;
            }
            
            .table-body {
                padding: 1.25rem;
            }
            
            .table {
                margin-bottom: 0;
            }
            
            .table thead th {
                background-color: #f8f9fc;
                border-bottom: 2px solid #e3e6f0;
                font-weight: 700;
                color: var(--dark-color);
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.05em;
            }
            
            .table tbody tr:hover {
                background-color: #f8f9fc;
            }
            
            /* Badge styles */
            .badge {
                font-weight: 600;
                padding: 0.35em 0.65em;
                border-radius: 0.35rem;
            }
            
            /* Button styles */
            .btn-group .btn {
                border-radius: 0.35rem;
                margin-right: 0.25rem;
            }
            
            .btn-sm {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
            }
            
            /* Responsive adjustments */
            @media (max-width: 768px) {
                .sidebar {
                    width: 100%;
                    position: relative;
                    padding-top: 0;
                }
                
                main {
                    margin-left: 0 !important;
                    padding-top: 1rem;
                }
                
                .stat-card {
                    margin-bottom: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="../common/header.jsp">
            <jsp:param name="title" value="Booking Management" />
        </jsp:include>
        
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                    <div class="position-sticky pt-3 sidebar-sticky">
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-speedometer2"></i>
                                    Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/booking-management">
                                    <i class="bi bi-calendar-check"></i>
                                    Bookings
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/flight-management">
                                    <i class="bi bi-airplane"></i>
                                    Flights
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/user-management">
                                    <i class="bi bi-people"></i>
                                    Users
                                </a>
                            </li>
                        </ul>
                        
                        <div class="sidebar-heading">
                            System
                        </div>
                        <ul class="nav flex-column mb-2">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right"></i>
                                    Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>
                
                <!-- Main Content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                        <h1 class="h2 text-gray-800">Booking Management</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-file-earmark-excel"></i> Export
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-printer"></i> Print
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Dashboard Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card primary h-100">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="stat-title">Total Bookings</div>
                                            <div class="stat-value">${totalBookings}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-calendar-check stat-icon text-primary"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card success h-100">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="stat-title">Confirmed Bookings</div>
                                            <div class="stat-value">${confirmedBookings}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-check-circle stat-icon text-success"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card warning h-100">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="stat-title">Pending Bookings</div>
                                            <div class="stat-value">${pendingBookings}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-hourglass-split stat-icon text-warning"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card info h-100">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="stat-title">Total Revenue</div>
                                            <div class="stat-value">$<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-currency-dollar stat-icon text-info"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Booking List Table -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                            <h6 class="m-0 font-weight-bold text-primary">
                                <i class="bi bi-table me-1"></i> Booking List
                            </h6>
                            <div class="dropdown no-arrow">
                                <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-three-dots-vertical text-gray-400"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="dropdownMenuLink">
                                    <li><a class="dropdown-item" href="#">Filter by Status</a></li>
                                    <li><a class="dropdown-item" href="#">Sort by Date</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="#">Export Data</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered" id="bookingsTable" width="100%" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Passenger</th>
                                            <th>Flight</th>
                                            <th>Booking Date</th>
                                            <th>Seat</th>
                                            <th>Price</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="booking" items="${bookings}">
                                            <tr>
                                                <td>${booking.bookingId}</td>
                                                <td>${booking.passengerName}</td>
                                                <td>
                                                    <c:if test="${not empty booking.flight}">
                                                        <strong>${booking.flight.flightNumber}</strong><br>
                                                        <small class="text-muted">${booking.flight.origin} → ${booking.flight.destination}</small>
                                                    </c:if>
                                                </td>
                                                <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                <td><span class="badge bg-light text-dark">${booking.seatNumber}</span></td>
                                                <td><strong>$<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></strong></td>
                                                <td>
                                                    <span class="badge 
                                                        <c:choose>
                                                            <c:when test="${booking.status == 'CONFIRMED'}">bg-success</c:when>
                                                            <c:when test="${booking.status == 'PENDING'}">bg-warning text-dark</c:when>
                                                            <c:when test="${booking.status == 'CANCELLED'}">bg-danger</c:when>
                                                            <c:when test="${booking.status == 'COMPLETED'}">bg-primary</c:when>
                                                        </c:choose>">
                                                        ${booking.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="booking-management?action=view&id=${booking.bookingId}" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Details">
                                                            <i class="bi bi-eye-fill"></i>
                                                        </a>
                                                        <a href="booking-management?action=edit&id=${booking.bookingId}" class="btn btn-sm btn-primary" data-bs-toggle="tooltip" title="Edit Booking">
                                                            <i class="bi bi-pencil-fill"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-success" 
                                                                onclick="updateStatus('${booking.bookingId}', 'CONFIRMED')"
                                                                <c:if test="${booking.status == 'CONFIRMED' || booking.status == 'COMPLETED' || booking.status == 'CANCELLED'}">disabled</c:if>
                                                                data-bs-toggle="tooltip" title="Confirm Booking">
                                                            <i class="bi bi-check-circle-fill"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-danger" 
                                                                onclick="updateStatus('${booking.bookingId}', 'CANCELLED')"
                                                                <c:if test="${booking.status == 'CANCELLED' || booking.status == 'COMPLETED'}">disabled</c:if>
                                                                data-bs-toggle="tooltip" title="Cancel Booking">
                                                            <i class="bi bi-x-circle-fill"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
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
        
        <!-- Status Update Form (Hidden) -->
        <form id="statusForm" action="booking-management" method="post" style="display: none;">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" id="bookingId" name="bookingId" value="">
            <input type="hidden" id="status" name="status" value="">
        </form>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- DataTables -->
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
        
        <script>
            // Initialize DataTables
            $(document).ready(function() {
                $('#bookingsTable').DataTable({
                    "pageLength": 10,
                    "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    "order": [[ 0, "desc" ]],
                    "language": {
                        "search": "Search bookings:",
                        "lengthMenu": "Show _MENU_ bookings per page",
                        "info": "Showing _START_ to _END_ of _TOTAL_ bookings",
                        "infoEmpty": "Showing 0 to 0 of 0 bookings",
                        "infoFiltered": "(filtered from _MAX_ total bookings)"
                    }
                });
                
                // Initialize tooltips
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl)
                });
            });
            
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
