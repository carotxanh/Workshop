<%-- 
    Document   : flight-list
    Created on : Mar 16, 2025, 3:29:00 PM
    Author     : FPTSHOP
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Flight Management - Admin Dashboard</title>
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
                font-size: .75rem;
                text-transform: uppercase;
                color: rgba(255, 255, 255, 0.5);
                font-weight: 800;
                letter-spacing: 0.05rem;
                padding: 0.75rem 1rem;
            }
            
            main {
                margin-top: 20px;
            }
            
            .card {
                border: none;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
                border-radius: 0.5rem;
            }
            
            .card-header {
                background-color: #f8f9fc;
                border-bottom: 1px solid #e3e6f0;
                padding: 1rem 1.35rem;
                font-weight: 700;
                color: var(--dark-color);
                display: flex;
                align-items: center;
            }
            
            .card-header i {
                margin-right: 0.5rem;
                color: var(--primary-color);
            }
            
            .table-responsive {
                padding: 1rem;
            }
            
            .status-badge {
                padding: 0.5rem 0.75rem;
                font-weight: 700;
                border-radius: 0.35rem;
                font-size: 0.75rem;
            }
            
            .action-buttons .btn {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
                margin-right: 0.25rem;
            }
            
            .stats-card {
                transition: all 0.3s;
                border-left: 0.25rem solid;
            }
            
            .stats-card:hover {
                transform: translateY(-3px);
            }
            
            .stats-card-primary {
                border-left-color: var(--primary-color);
            }
            
            .stats-card-success {
                border-left-color: var(--success-color);
            }
            
            .stats-card-info {
                border-left-color: var(--info-color);
            }
            
            .stats-card-warning {
                border-left-color: var(--warning-color);
            }
            
            .stats-icon {
                font-size: 2rem;
                opacity: 0.3;
            }
            
            .stats-card-primary .stats-icon {
                color: var(--primary-color);
            }
            
            .stats-card-success .stats-icon {
                color: var(--success-color);
            }
            
            .stats-card-info .stats-icon {
                color: var(--info-color);
            }
            
            .stats-card-warning .stats-icon {
                color: var(--warning-color);
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                    <div class="sidebar-sticky">
                        <div class="d-flex align-items-center justify-content-center my-4">
                            <span class="fs-4 fw-bold text-white">Admin Dashboard</span>
                        </div>
                        
                        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1">
                            <span>Management</span>
                        </h6>
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-speedometer2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/user-management">
                                    <i class="bi bi-people"></i>Users
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/flight-management">
                                    <i class="bi bi-airplane-fill"></i>Flights
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/booking-management">
                                    <i class="bi bi-calendar-check"></i>Bookings
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
                        <h1 class="h2">Flight Management</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <a href="flight-management?action=create" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-plus-circle"></i> Add New Flight
                                </a>
                            </div>
                        </div>
                    </div>

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

                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card stats-card-primary h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                Total Flights
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${flights.size()}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-airplane stats-icon"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card stats-card-success h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                                Active Flights
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                <c:set var="activeCount" value="0" />
                                                <c:forEach items="${flights}" var="flight">
                                                    <c:if test="${flight.status == 'SCHEDULED' || flight.status == 'BOARDING'}">
                                                        <c:set var="activeCount" value="${activeCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${activeCount}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-check-circle-fill stats-icon"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card stats-card-info h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                                Completed Flights
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                <c:set var="completedCount" value="0" />
                                                <c:forEach items="${flights}" var="flight">
                                                    <c:if test="${flight.status == 'COMPLETED'}">
                                                        <c:set var="completedCount" value="${completedCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${completedCount}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-flag-fill stats-icon"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stats-card stats-card-warning h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                                Cancelled Flights
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                <c:set var="cancelledCount" value="0" />
                                                <c:forEach items="${flights}" var="flight">
                                                    <c:if test="${flight.status == 'CANCELLED'}">
                                                        <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${cancelledCount}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-x-circle-fill stats-icon"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Flights Table -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="bi bi-table me-1"></i>
                            Flight List
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table id="flightsTable" class="table table-striped table-hover" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Flight Number</th>
                                            <th>Airline</th>
                                            <th>Route</th>
                                            <th>Departure</th>
                                            <th>Arrival</th>
                                            <th>Price</th>
                                            <th>Available Seats</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="flight" items="${flights}">
                                            <tr>
                                                <td>${flight.flightId}</td>
                                                <td>${flight.flightNumber}</td>
                                                <td>${flight.airline}</td>
                                                <td>${flight.origin} → ${flight.destination}</td>
                                                <td><fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                <td><fmt:formatDate value="${flight.arrivalTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                <td>$<fmt:formatNumber value="${flight.price}" pattern="#,##0.00"/></td>
                                                <td>${flight.availableSeats}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${flight.status == 'SCHEDULED'}">
                                                            <span class="badge bg-primary status-badge">SCHEDULED</span>
                                                        </c:when>
                                                        <c:when test="${flight.status == 'BOARDING'}">
                                                            <span class="badge bg-warning status-badge">BOARDING</span>
                                                        </c:when>
                                                        <c:when test="${flight.status == 'DEPARTED'}">
                                                            <span class="badge bg-info status-badge">DEPARTED</span>
                                                        </c:when>
                                                        <c:when test="${flight.status == 'COMPLETED'}">
                                                            <span class="badge bg-success status-badge">COMPLETED</span>
                                                        </c:when>
                                                        <c:when test="${flight.status == 'CANCELLED'}">
                                                            <span class="badge bg-danger status-badge">CANCELLED</span>
                                                        </c:when>
                                                        <c:when test="${flight.status == 'DELAYED'}">
                                                            <span class="badge bg-warning text-dark status-badge">DELAYED</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary status-badge">${flight.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="action-buttons">
                                                    <a href="flight-management?action=edit&id=${flight.flightId}" 
                                                       class="btn btn-primary btn-sm"
                                                       data-bs-toggle="tooltip" 
                                                       data-bs-placement="top" 
                                                       title="Edit Flight">
                                                        <i class="bi bi-pencil-fill"></i>
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-danger btn-sm" 
                                                            onclick="confirmDelete(${flight.flightId}, '${flight.flightNumber}')"
                                                            data-bs-toggle="tooltip" 
                                                            data-bs-placement="top" 
                                                            title="Delete Flight">
                                                        <i class="bi bi-trash-fill"></i>
                                                    </button>
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

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete flight <span id="flightNumber"></span>?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="deleteLink" class="btn btn-danger">Delete</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include Footer -->
        <jsp:include page="../common/footer.jsp" />

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
        
        <script>
            // Initialize DataTables
            $(document).ready(function() {
                $('#flightsTable').DataTable({
                    "pageLength": 10,
                    "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    "order": [[ 4, "asc" ]],  // Sort by departure time
                    "language": {
                        "search": "Search flights:",
                        "lengthMenu": "Show _MENU_ flights per page",
                        "info": "Showing _START_ to _END_ of _TOTAL_ flights",
                        "infoEmpty": "Showing 0 to 0 of 0 flights",
                        "infoFiltered": "(filtered from _MAX_ total flights)"
                    }
                });
                
                // Initialize tooltips
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl)
                });
            });
            
            function confirmDelete(flightId, flightNumber) {
                document.getElementById('flightNumber').textContent = flightNumber;
                document.getElementById('deleteLink').href = 'flight-management?action=delete&id=' + flightId;
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                deleteModal.show();
            }
        </script>
    </body>
</html>
