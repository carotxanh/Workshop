package com.mycompany.ticketplane.controller.admin;

import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Flight.FlightStatus;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.service.SeatService;

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
    
    @Override
    public void init() throws ServletException {
        flightService = new FlightService();
        seatService = new SeatService();
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
        
        String pathInfo = request.getPathInfo();
        String action = pathInfo == null ? "list" : pathInfo.substring(1);
        
        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteFlight(request, response);
                break;
            case "detail":
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
        
        String pathInfo = request.getPathInfo();
        String action = pathInfo == null ? "list" : pathInfo.substring(1);
        
        switch (action) {
            case "create":
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
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/list.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/list.jsp").forward(request, response);
        }
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
    }
    
    private void createFlight(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form
            String flightNumber = request.getParameter("flightNumber");
            String airline = request.getParameter("airline");
            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            String departureDateStr = request.getParameter("departureDate");
            String departureTimeStr = request.getParameter("departureTime");
            String arrivalDateStr = request.getParameter("arrivalDate");
            String arrivalTimeStr = request.getParameter("arrivalTime");
            String priceStr = request.getParameter("price");
            String seatsStr = request.getParameter("availableSeats");
            String economySeatsStr = request.getParameter("economySeats");
            String businessSeatsStr = request.getParameter("businessSeats");
            String firstClassSeatsStr = request.getParameter("firstClassSeats");
            String statusStr = request.getParameter("status");
            
            // Validate input
            if (flightNumber == null || airline == null || origin == null || destination == null ||
                departureDateStr == null || departureTimeStr == null || arrivalDateStr == null || 
                arrivalTimeStr == null || priceStr == null || seatsStr == null || 
                economySeatsStr == null || businessSeatsStr == null || firstClassSeatsStr == null || 
                statusStr == null) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
                return;
            }
            
            // Parse date and time
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            
            Date departureDate = dateFormat.parse(departureDateStr);
            Date departureTime = timeFormat.parse(departureTimeStr);
            Date arrivalDate = dateFormat.parse(arrivalDateStr);
            Date arrivalTime = timeFormat.parse(arrivalTimeStr);
            
            // Combine date and time
            String departureDateTimeStr = departureDateStr + " " + departureTimeStr;
            String arrivalDateTimeStr = arrivalDateStr + " " + arrivalTimeStr;
            
            Date departureDateTime = dateTimeFormat.parse(departureDateTimeStr);
            Date arrivalDateTime = dateTimeFormat.parse(arrivalDateTimeStr);
            
            // Calculate duration
            long durationMillis = arrivalDateTime.getTime() - departureDateTime.getTime();
            Time duration = new Time(durationMillis);
            
            // Parse other values
            BigDecimal price = new BigDecimal(priceStr);
            int availableSeats = Integer.parseInt(seatsStr);
            int economySeats = Integer.parseInt(economySeatsStr);
            int businessSeats = Integer.parseInt(businessSeatsStr);
            int firstClassSeats = Integer.parseInt(firstClassSeatsStr);
            FlightStatus status = FlightStatus.valueOf(statusStr);
            
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
            flight.setAvailableSeats(availableSeats);
            flight.setStatus(status);
            
            // Save to database
            boolean success = flightService.createFlight(flight);
            
            if (success) {
                // Initialize seats for the flight
                seatService.initializeSeatsForFlight(
                    flight.getFlightId(), 
                    economySeats, 
                    businessSeats, 
                    firstClassSeats
                );
                
                request.getSession().setAttribute("success", "Thêm chuyến bay thành công");
                response.sendRedirect(request.getContextPath() + "/admin/flights");
            } else {
                request.setAttribute("error", "Không thể thêm chuyến bay");
                request.setAttribute("flight", flight);
                request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
            }
            
        } catch (ParseException e) {
            request.setAttribute("error", "Dữ liệu ngày tháng không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            // Bao gồm cả NumberFormatException vì nó là con của IllegalArgumentException
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(request.getParameter("id"));
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                request.getSession().setAttribute("error", "Không tìm thấy chuyến bay");
                response.sendRedirect(request.getContextPath() + "/admin/flights");
                return;
            }
            
            request.setAttribute("flight", flight);
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID chuyến bay không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/flights");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
        }
    }
    
    private void updateFlight(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy ID chuyến bay
            int flightId = Integer.parseInt(request.getParameter("flightId"));
            
            // Lấy thông tin chuyến bay hiện tại
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                request.getSession().setAttribute("error", "Không tìm thấy chuyến bay");
                response.sendRedirect(request.getContextPath() + "/admin/flights");
                return;
            }
            
            // Lấy dữ liệu từ form
            String flightNumber = request.getParameter("flightNumber");
            String airline = request.getParameter("airline");
            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            String departureDateStr = request.getParameter("departureDate");
            String departureTimeStr = request.getParameter("departureTime");
            String arrivalDateStr = request.getParameter("arrivalDate");
            String arrivalTimeStr = request.getParameter("arrivalTime");
            String priceStr = request.getParameter("price");
            String seatsStr = request.getParameter("availableSeats");
            String statusStr = request.getParameter("status");
            
            // Validate input
            if (flightNumber == null || airline == null || origin == null || destination == null ||
                departureDateStr == null || departureTimeStr == null || arrivalDateStr == null || 
                arrivalTimeStr == null || priceStr == null || seatsStr == null || statusStr == null) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                request.setAttribute("flight", flight);
                request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
                return;
            }
            
            // Parse date and time
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            
            Date departureDate = dateFormat.parse(departureDateStr);
            Date departureTime = timeFormat.parse(departureTimeStr);
            Date arrivalDate = dateFormat.parse(arrivalDateStr);
            Date arrivalTime = timeFormat.parse(arrivalTimeStr);
            
            // Combine date and time
            String departureDateTimeStr = departureDateStr + " " + departureTimeStr;
            String arrivalDateTimeStr = arrivalDateStr + " " + arrivalTimeStr;
            
            Date departureDateTime = dateTimeFormat.parse(departureDateTimeStr);
            Date arrivalDateTime = dateTimeFormat.parse(arrivalDateTimeStr);
            
            // Calculate duration
            long durationMillis = arrivalDateTime.getTime() - departureDateTime.getTime();
            Time duration = new Time(durationMillis);
            
            // Parse other values
            BigDecimal price = new BigDecimal(priceStr);
            int availableSeats = Integer.parseInt(seatsStr);
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
            flight.setAvailableSeats(availableSeats);
            flight.setStatus(status);
            
            // Save to database
            boolean success = flightService.updateFlight(flight);
            
            if (success) {
                request.getSession().setAttribute("success", "Cập nhật chuyến bay thành công");
                response.sendRedirect(request.getContextPath() + "/admin/flights");
            } else {
                request.setAttribute("error", "Không thể cập nhật chuyến bay");
                request.setAttribute("flight", flight);
                request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
            }
            
        } catch (ParseException e) {
            request.setAttribute("error", "Dữ liệu ngày tháng không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            // Bao gồm cả NumberFormatException vì nó là con của IllegalArgumentException
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/form.jsp").forward(request, response);
        }
    }
    
    private void deleteFlight(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(request.getParameter("id"));
            
            boolean success = flightService.deleteFlight(flightId);
            
            if (success) {
                request.getSession().setAttribute("success", "Xóa chuyến bay thành công");
            } else {
                request.getSession().setAttribute("error", "Không thể xóa chuyến bay. Chuyến bay có thể đã được đặt vé.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/flights");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID chuyến bay không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/flights");
        } catch (SQLException e) {
            request.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/flights");
        }
    }
    
    private void showFlightDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(request.getParameter("id"));
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                request.getSession().setAttribute("error", "Không tìm thấy chuyến bay");
                response.sendRedirect(request.getContextPath() + "/admin/flights");
                return;
            }
            
            request.setAttribute("flight", flight);
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID chuyến bay không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/flights");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/flights/list.jsp").forward(request, response);
        }
    }
} 