package com.mycompany.ticketplane.controller.admin;

import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Flight.FlightStatus;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.model.Location;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.service.SeatService;
import com.mycompany.ticketplane.service.BookingService;
import com.mycompany.ticketplane.service.LocationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/flight-management")
public class FlightManagementServlet extends HttpServlet {
    
    private FlightService flightService;
    private SeatService seatService;
    private BookingService bookingService;
    private LocationService locationService;
    
    @Override
    public void init() throws ServletException {
        flightService = new FlightService();
        seatService = new SeatService();
        bookingService = new BookingService();
        locationService = new LocationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user.getRole() != User.UserRole.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/error/403");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "create":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteFlight(request, response);
                break;
            case "view":
                showFlightDetail(request, response);
                break;
            case "list":
            default:
                listFlights(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user.getRole() != User.UserRole.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/error/403");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "add":
                createFlight(request, response);
                break;
            case "edit":
                updateFlight(request, response);
                break;
            default:
                listFlights(request, response);
                break;
        }
    }
    
    private void listFlights(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Flight> flights = flightService.getAllFlights();
            request.setAttribute("flights", flights);
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-list.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-list.jsp").forward(request, response);
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Fetch all locations from the database
            List<Location> locations = locationService.getAllLocations();
            request.setAttribute("locations", locations);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Error loading locations: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
        }
    }
    
    private void createFlight(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get form data
            String flightNumber = request.getParameter("flightNumber");
            String airline = request.getParameter("airline");
            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            String departureTimeStr = request.getParameter("departureTime");
            String arrivalTimeStr = request.getParameter("arrivalTime");
            String priceStr = request.getParameter("price");
            String totalSeatsStr = request.getParameter("totalSeats");
            
            // Validate required fields
            if (flightNumber == null || flightNumber.trim().isEmpty() ||
                airline == null || airline.trim().isEmpty() ||
                origin == null || origin.trim().isEmpty() ||
                destination == null || destination.trim().isEmpty() ||
                departureTimeStr == null || departureTimeStr.trim().isEmpty() ||
                arrivalTimeStr == null || arrivalTimeStr.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                totalSeatsStr == null || totalSeatsStr.trim().isEmpty()) {
                
                // Fetch all locations again to repopulate the form
                List<Location> locations = locationService.getAllLocations();
                request.setAttribute("locations", locations);
                
                request.setAttribute("error", "Please fill in all required fields");
                request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
                return;
            }
            
            // Validate that origin and destination are different
            if (origin.equals(destination)) {
                // Fetch all locations again to repopulate the form
                List<Location> locations = locationService.getAllLocations();
                request.setAttribute("locations", locations);
                
                request.setAttribute("error", "Origin and destination cannot be the same");
                request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
                return;
            }
            
            // Parse date and time - handle the datetime-local format (yyyy-MM-ddTHH:mm)
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            
            Date departureDateTime = dateTimeFormat.parse(departureTimeStr);
            Date arrivalDateTime = dateTimeFormat.parse(arrivalTimeStr);
            
            // Validate departure and arrival times
            if (arrivalDateTime.before(departureDateTime)) {
                // Fetch all locations again to repopulate the form
                List<Location> locations = locationService.getAllLocations();
                request.setAttribute("locations", locations);
                
                request.setAttribute("error", "Arrival time must be after departure time");
                request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
                return;
            }
            
            // Calculate duration
            long durationMillis = arrivalDateTime.getTime() - departureDateTime.getTime();
            Time duration = new Time(durationMillis);
            
            // Parse other values
            BigDecimal price = new BigDecimal(priceStr);
            int totalSeats = Integer.parseInt(totalSeatsStr);
            
            // Create flight object
            Flight flight = new Flight();
            flight.setFlightNumber(flightNumber);
            flight.setAirline(airline);
            flight.setOrigin(origin);
            flight.setDestination(destination);
            flight.setDepartureTime(new java.sql.Timestamp(departureDateTime.getTime()));
            flight.setArrivalTime(new java.sql.Timestamp(arrivalDateTime.getTime()));
            flight.setDuration(duration);
            flight.setPrice(price);
            flight.setAvailableSeats(totalSeats);
            flight.setStatus(FlightStatus.SCHEDULED);
            
            // Save to database
            boolean success = flightService.createFlight(flight);
            
            if (success) {
                // Lấy ID của chuyến bay vừa tạo
                Flight createdFlight = flightService.findByFlightNumber(flightNumber);
                if (createdFlight != null) {
                    // Tạo ghế cho chuyến bay
                    seatService.createSeatsForFlight(createdFlight.getFlightId(), totalSeats);
                    
                    request.getSession().setAttribute("success", "Flight created successfully");
                    response.sendRedirect(request.getContextPath() + "/admin/flight-management");
                } else {
                    request.setAttribute("error", "Flight created but could not create seats");
                    request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Could not create flight");
                request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
            }
            
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date format: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            // Includes NumberFormatException
            request.setAttribute("error", "Invalid data: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-add.jsp").forward(request, response);
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(request.getParameter("id"));
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                request.getSession().setAttribute("error", "Flight not found");
                response.sendRedirect(request.getContextPath() + "/admin/flight-management");
                return;
            }
            
            request.setAttribute("flight", flight);
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid flight ID");
            response.sendRedirect(request.getContextPath() + "/admin/flight-management");
        } catch (SQLException e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-list.jsp").forward(request, response);
        }
    }
    
    private void updateFlight(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(request.getParameter("flightId"));
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                request.getSession().setAttribute("error", "Flight not found");
                response.sendRedirect(request.getContextPath() + "/admin/flight-management");
                return;
            }
            
            // Get form data
            String flightNumber = request.getParameter("flightNumber");
            String airline = request.getParameter("airline");
            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            String departureTimeStr = request.getParameter("departureTime");
            String arrivalTimeStr = request.getParameter("arrivalTime");
            String priceStr = request.getParameter("price");
            String statusStr = request.getParameter("status");
            
            // Validate required fields
            if (flightNumber == null || flightNumber.trim().isEmpty() ||
                airline == null || airline.trim().isEmpty() ||
                origin == null || origin.trim().isEmpty() ||
                destination == null || destination.trim().isEmpty() ||
                departureTimeStr == null || departureTimeStr.trim().isEmpty() ||
                arrivalTimeStr == null || arrivalTimeStr.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                statusStr == null || statusStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                request.setAttribute("flight", flight);
                request.getRequestDispatcher("/WEB-INF/views/admin/flight-edit.jsp").forward(request, response);
                return;
            }
            
            // Parse date and time
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            
            Date departureDateTime = dateTimeFormat.parse(departureTimeStr);
            Date arrivalDateTime = dateTimeFormat.parse(arrivalTimeStr);
            
            // Validate departure and arrival times
            if (arrivalDateTime.before(departureDateTime)) {
                request.setAttribute("error", "Arrival time must be after departure time");
                request.setAttribute("flight", flight);
                request.getRequestDispatcher("/WEB-INF/views/admin/flight-edit.jsp").forward(request, response);
                return;
            }
            
            // Calculate duration
            long durationMillis = arrivalDateTime.getTime() - departureDateTime.getTime();
            Time duration = new Time(durationMillis);
            
            // Parse other values
            BigDecimal price = new BigDecimal(priceStr);
            FlightStatus status = FlightStatus.valueOf(statusStr);
            
            // Update flight object
            flight.setFlightNumber(flightNumber);
            flight.setAirline(airline);
            flight.setOrigin(origin);
            flight.setDestination(destination);
            flight.setDepartureTime(new java.sql.Timestamp(departureDateTime.getTime()));
            flight.setArrivalTime(new java.sql.Timestamp(arrivalDateTime.getTime()));
            flight.setDuration(duration);
            flight.setPrice(price);
            flight.setStatus(status);
            
            // Save to database
            boolean success = flightService.updateFlight(flight);
            
            if (success) {
                request.getSession().setAttribute("success", "Flight updated successfully");
                response.sendRedirect(request.getContextPath() + "/admin/flight-management");
            } else {
                request.setAttribute("error", "Could not update flight");
                request.setAttribute("flight", flight);
                request.getRequestDispatcher("/WEB-INF/views/admin/flight-edit.jsp").forward(request, response);
            }
            
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date format: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-edit.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            // Includes NumberFormatException
            request.setAttribute("error", "Invalid data: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-edit.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-edit.jsp").forward(request, response);
        }
    }
    
    private void deleteFlight(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(request.getParameter("id"));
            
            // Check if flight has bookings
            boolean hasBookings = bookingService.hasBookingsForFlight(flightId);
            
            if (hasBookings) {
                request.getSession().setAttribute("error", "Cannot delete flight. There are bookings associated with this flight.");
                response.sendRedirect(request.getContextPath() + "/admin/flight-management");
                return;
            }
            
            boolean success = flightService.deleteFlight(flightId);
            
            if (success) {
                request.getSession().setAttribute("success", "Flight deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Could not delete flight");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/flight-management");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid flight ID");
            response.sendRedirect(request.getContextPath() + "/admin/flight-management");
        } catch (SQLException e) {
            request.getSession().setAttribute("error", "System error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/flight-management");
        }
    }
    
    private void showFlightDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(request.getParameter("id"));
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                request.getSession().setAttribute("error", "Flight not found");
                response.sendRedirect(request.getContextPath() + "/admin/flight-management");
                return;
            }
            
            // Get bookings for this flight
            flight.setBookings(bookingService.getBookingsByFlightId(flightId));
            
            request.setAttribute("flight", flight);
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid flight ID");
            response.sendRedirect(request.getContextPath() + "/admin/flight-management");
        } catch (SQLException e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flight-list.jsp").forward(request, response);
        }
    }
} 