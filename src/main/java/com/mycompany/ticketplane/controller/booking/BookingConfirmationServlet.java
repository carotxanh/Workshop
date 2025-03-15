package com.mycompany.ticketplane.controller.booking;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/booking/confirmation")
public class BookingConfirmationServlet extends HttpServlet {
    
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
        
        // Lấy thông tin đặt vé từ tham số
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/bookings");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingService.findById(bookingId);
            
            if (booking == null || (booking.getUserId() != user.getUserId() && user.getRole() != User.UserRole.ADMIN)) {
                response.sendRedirect(request.getContextPath() + "/user/bookings");
                return;
            }
            
            // Lưu thông tin vào request
            request.setAttribute("booking", booking);
            
            // Chuyển hướng đến trang xác nhận đặt vé
            request.getRequestDispatcher("/WEB-INF/views/booking/confirmation.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/bookings");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
} 