package com.mycompany.ticketplane.controller.booking;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.BookingService;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

@WebServlet("/bookings")
public class BookingServlet extends HttpServlet {
    
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
        
        String flightIdStr = request.getParameter("flightId");
        String seatNumber = request.getParameter("seatNumber");
        
        if (flightIdStr == null || flightIdStr.trim().isEmpty() || seatNumber == null || seatNumber.trim().isEmpty()) {
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
            
            // Lưu thông tin vào request
            request.setAttribute("flight", flight);
            request.setAttribute("seatNumber", seatNumber);
            
            // Tính giá vé dựa trên loại ghế
            BigDecimal price = flight.getPrice();
            if (seatNumber.startsWith("B")) {
                // Ghế hạng thương gia
                price = price.multiply(new BigDecimal("1.5"));
            } else if (seatNumber.startsWith("F")) {
                // Ghế hạng nhất
                price = price.multiply(new BigDecimal("2.0"));
            }
            
            request.setAttribute("price", price);
            
            // Chuyển hướng đến trang xác nhận đặt vé
            request.getRequestDispatcher("/WEB-INF/views/booking/confirm.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/flights/search");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/flight/search.jsp").forward(request, response);
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
        
        String flightIdStr = request.getParameter("flightId");
        String seatNumber = request.getParameter("seatNumber");
        String priceStr = request.getParameter("price");
        
        if (flightIdStr == null || flightIdStr.trim().isEmpty() || 
            seatNumber == null || seatNumber.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/flights/search");
            return;
        }
        
        try {
            int flightId = Integer.parseInt(flightIdStr);
            BigDecimal price = new BigDecimal(priceStr);
            
            // Đặt vé
            Booking booking = bookingService.bookFlight(user.getUserId(), flightId, seatNumber, price);
            
            if (booking != null) {
                // Đặt vé thành công
                
                // Lấy thông tin chuyến bay
                Flight flight = flightService.findById(flightId);
                
                // Gửi email xác nhận
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                EmailUtil.sendBookingConfirmationEmail(
                        user.getEmail(),
                        user.getName(),
                        String.valueOf(booking.getBookingId()),
                        flight.getFlightNumber(),
                        flight.getOrigin(),
                        flight.getDestination(),
                        dateFormat.format(flight.getDepartureTime()),
                        seatNumber,
                        price.toString()
                );
                
                // Chuyển hướng đến trang thanh toán
                response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + booking.getBookingId());
            } else {
                // Đặt vé thất bại
                request.setAttribute("error", "Không thể đặt vé. Vui lòng thử lại sau.");
                request.getRequestDispatcher("/WEB-INF/views/flight/search.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/flights/search");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/flight/search.jsp").forward(request, response);
        }
    }
} 