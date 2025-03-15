package com.mycompany.ticketplane.controller.payment;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.BookingService;
import com.mycompany.ticketplane.service.PaymentService;
import com.mycompany.ticketplane.util.EmailUtil;
import com.mycompany.ticketplane.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    
    private BookingService bookingService;
    private PaymentService paymentService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        paymentService = new PaymentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/bookings");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // Lấy thông tin đặt vé
            Booking booking = bookingService.findById(bookingId);
            
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/bookings");
                return;
            }
            
            // Lưu thông tin vào request
            request.setAttribute("booking", booking);
            
            // Chuyển hướng đến trang thanh toán
            request.getRequestDispatcher("/WEB-INF/views/payment/index.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bookings");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/booking/history.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        String bookingIdStr = request.getParameter("bookingId");
        String cardNumber = request.getParameter("cardNumber");
        String cardName = request.getParameter("cardName");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");
        
        // Kiểm tra dữ liệu đầu vào
        boolean hasError = false;
        
        if (!ValidationUtil.isNotEmpty(cardNumber) || cardNumber.length() < 16) {
            request.setAttribute("cardNumberError", "Số thẻ không hợp lệ");
            hasError = true;
        }
        
        if (!ValidationUtil.isValidName(cardName)) {
            request.setAttribute("cardNameError", "Tên chủ thẻ không hợp lệ");
            hasError = true;
        }
        
        if (!ValidationUtil.isNotEmpty(expiryDate)) {
            request.setAttribute("expiryDateError", "Ngày hết hạn không hợp lệ");
            hasError = true;
        }
        
        if (!ValidationUtil.isNotEmpty(cvv) || cvv.length() < 3) {
            request.setAttribute("cvvError", "Mã CVV không hợp lệ");
            hasError = true;
        }
        
        if (hasError) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                
                // Lấy thông tin đặt vé
                Booking booking = bookingService.findById(bookingId);
                
                // Lưu thông tin vào request
                request.setAttribute("booking", booking);
                request.setAttribute("cardNumber", cardNumber);
                request.setAttribute("cardName", cardName);
                request.setAttribute("expiryDate", expiryDate);
                
                // Chuyển hướng đến trang thanh toán
                request.getRequestDispatcher("/WEB-INF/views/payment/index.jsp").forward(request, response);
                return;
            } catch (NumberFormatException | SQLException e) {
                response.sendRedirect(request.getContextPath() + "/bookings");
                return;
            }
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // Lấy thông tin đặt vé
            Booking booking = bookingService.findById(bookingId);
            
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/bookings");
                return;
            }
            
            // Xử lý thanh toán
            String paymentId = paymentService.processPayment(booking, cardNumber, cardName, expiryDate, cvv);
            
            if (paymentId != null) {
                // Thanh toán thành công
                
                // Xác nhận đặt vé
                bookingService.confirmBooking(bookingId);
                
                // Gửi email xác nhận thanh toán
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                EmailUtil.sendPaymentConfirmationEmail(
                        user.getEmail(),
                        user.getName(),
                        String.valueOf(booking.getBookingId()),
                        paymentId,
                        booking.getTotalPrice().toString(),
                        "Thẻ tín dụng/ghi nợ",
                        dateFormat.format(new Date())
                );
                
                // Chuyển hướng đến trang xác nhận thanh toán
                response.sendRedirect(request.getContextPath() + "/payment/success?bookingId=" + bookingId);
            } else {
                // Thanh toán thất bại
                request.setAttribute("error", "Thanh toán thất bại. Vui lòng thử lại sau.");
                request.setAttribute("booking", booking);
                request.setAttribute("cardNumber", cardNumber);
                request.setAttribute("cardName", cardName);
                request.setAttribute("expiryDate", expiryDate);
                
                request.getRequestDispatcher("/WEB-INF/views/payment/index.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bookings");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/booking/history.jsp").forward(request, response);
        }
    }
} 