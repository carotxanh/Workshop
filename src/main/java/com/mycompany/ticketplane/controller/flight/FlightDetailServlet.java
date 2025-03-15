package com.mycompany.ticketplane.controller.flight;

import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Seat;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.service.SeatService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/flights/detail")
public class FlightDetailServlet extends HttpServlet {
    
    private FlightService flightService;
    private SeatService seatService;
    
    @Override
    public void init() throws ServletException {
        flightService = new FlightService();
        seatService = new SeatService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flightIdStr = request.getParameter("id");
        
        if (flightIdStr == null || flightIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/flights/search");
            return;
        }
        
        try {
            int flightId = Integer.parseInt(flightIdStr);
            
            // Lấy thông tin chuyến bay
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                response.sendRedirect(request.getContextPath() + "/flights/search");
                return;
            }
            
            // Lấy danh sách ghế
            List<Seat> seats = seatService.findByFlightId(flightId);
            
            // Lưu thông tin vào request
            request.setAttribute("flight", flight);
            request.setAttribute("seats", seats);
            
            // Chuyển hướng đến trang chi tiết chuyến bay
            request.getRequestDispatcher("/WEB-INF/views/flight/detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/flights/search");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/flight/search.jsp").forward(request, response);
        }
    }
} 