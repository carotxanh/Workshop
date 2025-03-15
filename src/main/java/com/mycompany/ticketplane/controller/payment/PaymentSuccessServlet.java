package com.mycompany.ticketplane.controller.payment;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.BookingService;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.util.PDFGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import com.itextpdf.text.DocumentException;

@WebServlet("/payment/success")
public class PaymentSuccessServlet extends HttpServlet {
    
    private BookingService bookingService;
    private FlightService flightService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        flightService = new FlightService();
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
        
        String bookingIdStr = request.getParameter("bookingId");
        String download = request.getParameter("download");
        
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/bookings");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // Lấy thông tin đặt vé
            Booking booking = bookingService.findById(bookingId);
            
            if (booking == null || booking.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/bookings");
                return;
            }
            
            // Lấy thông tin chuyến bay
            Flight flight = flightService.findById(booking.getFlightId());
            
            if ("true".equals(download)) {
                try {
                    // Tạo và tải xuống vé điện tử
                    var pdfBytes = PDFGenerator.generateTicket(booking, user, flight);
                    
                    // Thiết lập response
                    response.setContentType("application/pdf");
                    response.setHeader("Content-Disposition", "attachment; filename=ticket_" + booking.getBookingId() + ".pdf");
                    response.setContentLength(pdfBytes.length);
                    
                    // Ghi dữ liệu PDF vào response
                    OutputStream os = response.getOutputStream();
                    os.write(pdfBytes);
                    os.flush();
                    os.close();
                    return;
                } catch (IOException | DocumentException e) {
                    // Handle specific exceptions
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                      "Lỗi tạo vé điện tử: " + e.getMessage());
                }
            }
            
            // Lưu thông tin vào request
            request.setAttribute("booking", booking);
            request.setAttribute("flight", flight);
            
            // Chuyển hướng đến trang xác nhận thanh toán
            request.getRequestDispatcher("/WEB-INF/views/payment/success.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bookings");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/booking/history.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tạo vé điện tử: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/payment/success.jsp").forward(request, response);
        }
    }
} 