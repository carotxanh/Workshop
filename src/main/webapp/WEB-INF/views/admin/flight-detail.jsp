<%-- 
    Document   : flight-detail
    Created on : Mar 16, 2025, 3:29:24 PM
    Author     : FPTSHOP
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Flight Details - Admin Dashboard</title>
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
                margin-top: 20px;
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
                display: flex;
                align-items: center;
            }
            
            .card-header i {
                margin-right: 0.5rem;
                color: var(--primary-color);
            }
            
            .info-group {
                margin-bottom: 1.5rem;
            }
            
            .info-label {
                font-weight: 600;
                color: var(--secondary-color);
                margin-bottom: 0.25rem;
            }
            
            .info-value {
                font-size: 1.1rem;
            }
            
            .flight-path {
                display: flex;
                align-items: center;
                margin: 1.5rem 0;
            }
            
            .flight-path-point {
                display: flex;
                flex-direction: column;
                align-items: center;
                flex: 1;
            }
            
            .flight-path-point .city {
                font-weight: 700;
                font-size: 1.2rem;
            }
            
            .flight-path-point .time {
                color: var(--secondary-color);
            }
            
            .flight-path-line {
                flex: 2;
                height: 2px;
                background-color: var(--primary-color);
                position: relative;
                margin: 0 1rem;
            }
            
            .flight-path-line::before {
                content: "";
                position: absolute;
                width: 10px;
                height: 10px;
                background-color: var(--primary-color);
                border-radius: 50%;
                left: 0;
                top: -4px;
            }
            
            .flight-path-line::after {
                content: "";
                position: absolute;
                width: 10px;
                height: 10px;
                background-color: var(--primary-color);
                border-radius: 50%;
                right: 0;
                top: -4px;
            }
            
            .flight-path-line i {
                position: absolute;
                top: -12px;
                left: 50%;
                transform: translateX(-50%);
                color: var(--primary-color);
            }
            
            .status-badge {
                font-size: 0.9rem;
                padding: 0.5rem 0.75rem;
                border-radius: 0.35rem;
            }
            
            .action-buttons .btn {
                margin-right: 0.5rem;
            }
            
            .action-buttons .btn:last-child {
                margin-right: 0;
            }
            
            .passenger-list {
                max-height: 300px;
                overflow-y: auto;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Include Sidebar -->
                <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                    <div class="sidebar-sticky">
                        <div class="d-flex justify-content-center align-items-center mb-4">
                            <h3 class="text-white mb-0">Admin Panel</h3>
                        </div>
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-speedometer2"></i>Dashboard
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
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/user-management">
                                    <i class="bi bi-people"></i>Users
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/report">
                                    <i class="bi bi-bar-chart"></i>Reports
                                </a>
                            </li>
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
                        <h1 class="h2">Flight Details</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <a href="flight-management" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-arrow-left"></i> Back to List
                                </a>
                                <a href="flight-management?action=edit&id=${flight.flightId}" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil"></i> Edit Flight
                                </a>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="confirmDelete(${flight.flightId}, '${flight.flightNumber}')">
                                    <i class="bi bi-trash"></i> Delete Flight
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

                    <div class="row">
                        <div class="col-md-8">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="bi bi-info-circle-fill"></i> Flight Information
                                </div>
                                <div class="card-body">
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <div class="info-group">
                                                <div class="info-label">Flight Number</div>
                                                <div class="info-value">${flight.flightNumber}</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="info-group">
                                                <div class="info-label">Airline</div>
                                                <div class="info-value">${flight.airline}</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="flight-path">
                                        <div class="flight-path-point">
                                            <div class="city">${flight.origin}</div>
                                            <div class="time"><fmt:formatDate value="${flight.departureTime}" pattern="dd/MM/yyyy HH:mm" /></div>
                                        </div>
                                        <div class="flight-path-line">
                                            <i class="bi bi-airplane-fill"></i>
                                        </div>
                                        <div class="flight-path-point">
                                            <div class="city">${flight.destination}</div>
                                            <div class="time"><fmt:formatDate value="${flight.arrivalTime}" pattern="dd/MM/yyyy HH:mm" /></div>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-4">
                                        <div class="col-md-4">
                                            <div class="info-group">
                                                <div class="info-label">Duration</div>
                                                <div class="info-value">
                                                    <fmt:formatDate value="${flight.duration}" pattern="HH:mm" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="info-group">
                                                <div class="info-label">Price</div>
                                                <div class="info-value">$<fmt:formatNumber value="${flight.price}" pattern="#,##0.00"/></div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="info-group">
                                                <div class="info-label">Available Seats</div>
                                                <div class="info-value">${flight.availableSeats}</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-group">
                                        <div class="info-label">Status</div>
                                        <div class="info-value">
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
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="bi bi-gear-fill"></i> Actions
                                </div>
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <a href="flight-management?action=edit&id=${flight.flightId}" class="btn btn-primary">
                                            <i class="bi bi-pencil-fill me-2"></i> Edit Flight
                                        </a>
                                        <button type="button" class="btn btn-danger" onclick="confirmDelete(${flight.flightId}, '${flight.flightNumber}')">
                                            <i class="bi bi-trash-fill me-2"></i> Delete Flight
                                        </button>
                                        <div class="dropdown mt-2">
                                            <button class="btn btn-secondary dropdown-toggle w-100" type="button" id="statusDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="bi bi-arrow-repeat me-2"></i> Change Status
                                            </button>
                                            <ul class="dropdown-menu w-100" aria-labelledby="statusDropdown">
                                                <li><a class="dropdown-item" href="flight-management?action=updateStatus&id=${flight.flightId}&status=SCHEDULED">SCHEDULED</a></li>
                                                <li><a class="dropdown-item" href="flight-management?action=updateStatus&id=${flight.flightId}&status=BOARDING">BOARDING</a></li>
                                                <li><a class="dropdown-item" href="flight-management?action=updateStatus&id=${flight.flightId}&status=DEPARTED">DEPARTED</a></li>
                                                <li><a class="dropdown-item" href="flight-management?action=updateStatus&id=${flight.flightId}&status=COMPLETED">COMPLETED</a></li>
                                                <li><a class="dropdown-item" href="flight-management?action=updateStatus&id=${flight.flightId}&status=DELAYED">DELAYED</a></li>
                                                <li><a class="dropdown-item" href="flight-management?action=updateStatus&id=${flight.flightId}&status=CANCELLED">CANCELLED</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card">
                                <div class="card-header">
                                    <i class="bi bi-people-fill"></i> Booking Statistics
                                </div>
                                <div class="card-body">
                                    <div class="info-group">
                                        <div class="info-label">Total Seats</div>
                                        <div class="info-value">${flight.totalSeats}</div>
                                    </div>
                                    <div class="info-group">
                                        <div class="info-label">Booked Seats</div>
                                        <div class="info-value">${flight.totalSeats - flight.availableSeats}</div>
                                    </div>
                                    <div class="info-group">
                                        <div class="info-label">Available Seats</div>
                                        <div class="info-value">${flight.availableSeats}</div>
                                    </div>
                                    <div class="info-group mb-0">
                                        <div class="info-label">Occupancy Rate</div>
                                        <div class="info-value">
                                            <fmt:formatNumber value="${(flight.totalSeats - flight.availableSeats) / flight.totalSeats * 100}" pattern="#,##0.0"/>%
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <i class="bi bi-people-fill"></i> Passenger List
                        </div>
                        <div class="card-body">
                            <c:if test="${empty flight.bookings}">
                                <div class="alert alert-info mb-0">
                                    <i class="bi bi-info-circle-fill me-2"></i>
                                    No passengers have booked this flight yet.
                                </div>
                            </c:if>
                            <c:if test="${not empty flight.bookings}">
                                <div class="table-responsive passenger-list">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Booking ID</th>
                                                <th>Passenger Name</th>
                                                <th>Seat Number</th>
                                                <th>Booking Date</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${flight.bookings}" var="booking">
                                                <tr>
                                                    <td>${booking.bookingId}</td>
                                                    <td>${booking.passengerName}</td>
                                                    <td>${booking.seatNumber}</td>
                                                    <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.status == 'CONFIRMED'}">
                                                                <span class="badge bg-success">CONFIRMED</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'PENDING'}">
                                                                <span class="badge bg-warning text-dark">PENDING</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'CANCELLED'}">
                                                                <span class="badge bg-danger">CANCELLED</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'COMPLETED'}">
                                                                <span class="badge bg-info">COMPLETED</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${booking.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/booking-management?action=view&id=${booking.bookingId}" class="btn btn-sm btn-info">
                                                            <i class="bi bi-eye-fill"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
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

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function confirmDelete(flightId, flightNumber) {
                document.getElementById('flightNumber').textContent = flightNumber;
                document.getElementById('deleteLink').href = 'flight-management?action=delete&id=' + flightId;
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                deleteModal.show();
            }
        </script>
    </body>
</html>
