<%-- 
    Document   : flight-add
    Created on : Mar 16, 2025, 3:29:50 PM
    Author     : FPTSHOP
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add New Flight - Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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
            
            .form-label {
                font-weight: 600;
                color: var(--dark-color);
            }
            
            .input-group-text {
                background-color: var(--light-color);
                border-color: #d1d3e2;
            }
            
            .form-control, .form-select {
                border-color: #d1d3e2;
                color: var(--dark-color);
            }
            
            .form-control:focus, .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(78, 115, 223, 0.25);
            }
            
            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }
            
            .btn-primary:hover {
                background-color: #4262c5;
                border-color: #3d5cb8;
            }
            
            .btn-secondary {
                background-color: var(--secondary-color);
                border-color: var(--secondary-color);
            }
            
            .btn-secondary:hover {
                background-color: #717484;
                border-color: #6b6e7c;
            }
            
            .section-title {
                font-size: 1.2rem;
                font-weight: 700;
                color: var(--primary-color);
                margin-bottom: 1.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 1px solid #e3e6f0;
            }
            
            .content-wrapper {
                margin-left: 14rem;
                padding: 1.5rem;
            }
            
            @media (max-width: 768px) {
                .content-wrapper {
                    margin-left: 0;
                }
                .sidebar {
                    width: 100%;
                    position: relative;
                    padding-top: 0;
                }
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav class="col-md-2 col-lg-2 d-md-block sidebar">
                    <div class="sidebar-sticky">
                        <div class="d-flex align-items-center justify-content-center my-4">
                            <span class="fs-4 text-white fw-bold">Admin Dashboard</span>
                        </div>
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-speedometer2"></i>
                                    Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/flight-management">
                                    <i class="bi bi-airplane-fill"></i>
                                    Flight Management
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/booking-management">
                                    <i class="bi bi-calendar-check-fill"></i>
                                    Booking Management
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/user-management">
                                    <i class="bi bi-people-fill"></i>
                                    User Management
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                                    <i class="bi bi-bar-chart-fill"></i>
                                    Reports
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings">
                                    <i class="bi bi-gear-fill"></i>
                                    Settings
                                </a>
                            </li>
                        </ul>
                        
                        <div class="mt-auto mb-3">
                            <hr class="sidebar-divider">
                            <div class="nav flex-column">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right"></i>
                                    Logout
                                </a>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Main Content -->
                <main class="col-md-10 ms-sm-auto col-lg-10 px-md-4 content-wrapper">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Add New Flight</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <a href="${pageContext.request.contextPath}/admin/flight-management" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Back to Flight List
                            </a>
                        </div>
                    </div>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <div class="card">
                        <div class="card-header">
                            <i class="bi bi-plus-circle-fill"></i> Flight Information
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/flight-management" method="post">
                                <input type="hidden" name="action" value="create">
                                
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="section-title">Basic Information</div>
                                        
                                        <div class="mb-3">
                                            <label for="flightNumber" class="form-label">Flight Number <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-hash"></i></span>
                                                <input type="text" class="form-control" id="flightNumber" name="flightNumber" 
                                                       placeholder="e.g. VN123" required value="${flight.flightNumber}">
                                            </div>
                                            <div class="form-text">Enter a unique flight number (airline code + numbers)</div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="airline" class="form-label">Airline <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-airplane"></i></span>
                                                <input type="text" class="form-control" id="airline" name="airline" 
                                                       placeholder="e.g. Vietnam Airlines" required value="${flight.airline}">
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="SCHEDULED" ${flight.status == 'SCHEDULED' ? 'selected' : ''}>SCHEDULED</option>
                                                <option value="DELAYED" ${flight.status == 'DELAYED' ? 'selected' : ''}>DELAYED</option>
                                                <option value="CANCELLED" ${flight.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                                <option value="BOARDING" ${flight.status == 'BOARDING' ? 'selected' : ''}>BOARDING</option>
                                                <option value="IN_FLIGHT" ${flight.status == 'IN_FLIGHT' ? 'selected' : ''}>IN FLIGHT</option>
                                                <option value="ARRIVED" ${flight.status == 'ARRIVED' ? 'selected' : ''}>ARRIVED</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <div class="section-title">Route Information</div>
                                        
                                        <div class="mb-3">
                                            <label for="origin" class="form-label">Origin <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-geo-alt-fill"></i></span>
                                                <input type="text" class="form-control" id="origin" name="origin" 
                                                       placeholder="e.g. Hanoi" required value="${flight.origin}">
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="destination" class="form-label">Destination <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-geo-alt-fill"></i></span>
                                                <input type="text" class="form-control" id="destination" name="destination" 
                                                       placeholder="e.g. Ho Chi Minh City" required value="${flight.destination}">
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="totalSeats" class="form-label">Total Seats <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                                                <input type="number" class="form-control" id="totalSeats" name="totalSeats" 
                                                       min="1" max="500" required value="${flight.totalSeats > 0 ? flight.totalSeats : 180}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="section-title">Schedule Information</div>
                                        
                                        <div class="mb-3">
                                            <label for="departureTime" class="form-label">Departure Time <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-calendar-event-fill"></i></span>
                                                <input type="text" class="form-control flatpickr-datetime" id="departureTime" name="departureTime" 
                                                       placeholder="Select date and time" required 
                                                       value="<fmt:formatDate value="${flight.departureTime}" pattern="yyyy-MM-dd HH:mm" />">
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="arrivalTime" class="form-label">Arrival Time <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-calendar-event-fill"></i></span>
                                                <input type="text" class="form-control flatpickr-datetime" id="arrivalTime" name="arrivalTime" 
                                                       placeholder="Select date and time" required 
                                                       value="<fmt:formatDate value="${flight.arrivalTime}" pattern="yyyy-MM-dd HH:mm" />">
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <div class="section-title">Pricing Information</div>
                                        
                                        <div class="mb-3">
                                            <label for="price" class="form-label">Base Price <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="number" class="form-control" id="price" name="price" 
                                                       min="0" step="0.01" required value="${flight.price}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="${pageContext.request.contextPath}/admin/flight-management" class="btn btn-secondary me-md-2">
                                        <i class="bi bi-x-circle me-1"></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-1"></i> Create Flight
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

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize datetime pickers
                flatpickr(".flatpickr-datetime", {
                    enableTime: true,
                    dateFormat: "Y-m-d H:i",
                    time_24hr: true
                });
                
                // Validate that arrival time is after departure time
                document.querySelector('form').addEventListener('submit', function(event) {
                    const departureTime = new Date(document.getElementById('departureTime').value);
                    const arrivalTime = new Date(document.getElementById('arrivalTime').value);
                    
                    if (arrivalTime <= departureTime) {
                        event.preventDefault();
                        alert('Arrival time must be after departure time');
                    }
                });
                
                // Validate that origin and destination are different
                document.querySelector('form').addEventListener('submit', function(event) {
                    const origin = document.getElementById('origin').value.trim();
                    const destination = document.getElementById('destination').value.trim();
                    
                    if (origin.toLowerCase() === destination.toLowerCase()) {
                        event.preventDefault();
                        alert('Origin and destination cannot be the same');
                    }
                });
            });
        </script>
    </body>
</html>
