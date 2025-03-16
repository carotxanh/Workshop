package com.mycompany.ticketplane.controller;

import com.mycompany.ticketplane.dao.FlightDAO;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Location;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private FlightService flightService;
    
    @Override
    public void init() {
        flightService = new FlightService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy danh sách các chuyến bay sắp tới
            List<Flight> upcomingFlights = flightService.getUpcomingFlights();
            request.setAttribute("upcomingFlights", upcomingFlights);
            
            // Lấy danh sách các điểm khởi hành và điểm đến
            List<Location> origins = flightService.getAllOrigins();
            List<Location> destinations = flightService.getAllDestinations();
            
            request.setAttribute("origins", origins);
            request.setAttribute("destinations", destinations);
            
            // Lấy thông tin người dùng từ session (nếu đã đăng nhập)
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                request.setAttribute("userName", user.getName());
            }
            
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(HomeServlet.class.getName()).log(Level.SEVERE, null, ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Xử lý form tìm kiếm chuyến bay nếu có
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departureDate = request.getParameter("departureDate");
        
        if (origin != null && destination != null && departureDate != null) {
            // Chuyển hướng đến trang tìm kiếm chuyến bay với các tham số
            response.sendRedirect(request.getContextPath() + "/flights/search?origin=" + 
                    origin + "&destination=" + destination + "&departureDate=" + departureDate);
        } else {
            doGet(request, response);
        }
    }
} 