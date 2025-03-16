package com.mycompany.ticketplane.controller.admin;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Booking.BookingStatus;
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
import java.util.List;

@WebServlet("/admin/bookings")
public class AdminBookingServlet extends HttpServlet {
    
    private BookingService bookingService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
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
        
        try {
            // Lấy danh sách tất cả các đặt vé
            List<Booking> bookings = bookingService.getAllBookings();
            
            // Lưu thông tin vào request
            request.setAttribute("bookings", bookings);
            
            // Chuyển hướng đến trang quản lý đặt vé
            request.getRequestDispatcher("/WEB-INF/views/admin/bookings/index.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/bookings/index.jsp").forward(request, response);
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
        
        // Lấy thông tin từ form
        String bookingIdStr = request.getParameter("bookingId");
        String statusStr = request.getParameter("status");
        
        if (bookingIdStr != null && statusStr != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                BookingStatus status = BookingStatus.valueOf(statusStr);
                
                // Cập nhật trạng thái đặt vé
                boolean updated = bookingService.updateBookingStatus(bookingId, status);
                
                if (updated) {
                    request.setAttribute("success", "Cập nhật trạng thái đặt vé thành công");
                } else {
                    request.setAttribute("error", "Không thể cập nhật trạng thái đặt vé");
                }
                
                // Lấy lại danh sách đặt vé
                List<Booking> bookings = bookingService.getAllBookings();
                request.setAttribute("bookings", bookings);
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID đặt vé không hợp lệ");
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Trạng thái không hợp lệ");
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            }
        }
        
        // Chuyển hướng đến trang quản lý đặt vé
        request.getRequestDispatcher("/WEB-INF/views/admin/bookings/index.jsp").forward(request, response);
    }
} 