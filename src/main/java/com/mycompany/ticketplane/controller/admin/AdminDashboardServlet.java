package com.mycompany.ticketplane.controller.admin;

import com.mycompany.ticketplane.service.BookingService;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    private BookingService bookingService;
    private FlightService flightService;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        flightService = new FlightService();
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy thống kê cho dashboard
            request.setAttribute("totalBookings", bookingService.getTotalBookings());
            request.setAttribute("totalRevenue", bookingService.getTotalRevenue());
            request.setAttribute("totalUsers", userService.getTotalUsers());
            request.setAttribute("upcomingFlights", flightService.getUpcomingFlights());
            
            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                  .forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading dashboard data", e);
        }
    }
} 