package com.mycompany.ticketplane.controller;

import com.mycompany.ticketplane.dao.FlightDAO;
import com.mycompany.ticketplane.model.Flight;
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

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private FlightDAO flightDAO;
    
    @Override
    public void init() {
        flightDAO = new FlightDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách các chuyến bay sắp tới để hiển thị trên trang chủ
            List<Flight> upcomingFlights = flightDAO.getUpcomingFlights();
            request.setAttribute("upcomingFlights", upcomingFlights);
            
            // Lấy thông tin người dùng từ session (nếu đã đăng nhập)
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user != null) {
                request.setAttribute("userName", user.getName());
            }
            
            // Forward đến trang home.jsp
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error");
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