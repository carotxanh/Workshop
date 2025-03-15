package com.mycompany.ticketplane.controller.booking;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.BookingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/bookings")
public class BookingHistoryServlet extends HttpServlet {
    
    private BookingService bookingService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        try {
            // Lấy lịch sử đặt vé
            List<Booking> bookings = bookingService.findByUserId(user.getUserId());
            
            // Lưu thông tin vào request
            request.setAttribute("bookings", bookings);
            
            // Chuyển hướng đến trang lịch sử đặt vé
            request.getRequestDispatcher("/WEB-INF/views/booking/history.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/booking/history.jsp").forward(request, response);
        }
    }
} 