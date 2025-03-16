package com.mycompany.ticketplane.controller.booking;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Booking.BookingStatus;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Location;
import com.mycompany.ticketplane.model.Seat;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.BookingService;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.service.SeatService;
import com.mycompany.ticketplane.service.LocationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/booking/*")
public class BookingServlet extends HttpServlet {
    
    private BookingService bookingService;
    private FlightService flightService;
    private SeatService seatService;
    private LocationService locationService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        flightService = new FlightService();
        seatService = new SeatService();
        locationService = new LocationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "flights";  // Mặc định hiển thị trang flights
        }
        
        switch (action) {
            case "search":
            case "flights":
                showFlightsPage(request, response);
                break;
            case "confirm":
                showConfirmPage(request, response);
                break;
            case "list":
                showBookingListPage(request, response);
                break;
            case "cancel":
                cancelBooking(request, response);
                break;
            default:
                showFlightsPage(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "flights";
        }
        
        switch (action) {
            case "create":
                processBookingCreation(request, response);
                break;
            case "search":
                showFlightsPage(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/booking?action=flights");
                break;
        }
    }
    
    /**
     * Hiển thị trang danh sách chuyến bay
     */
    private void showFlightsPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách địa điểm để hiển thị trong form tìm kiếm
            List<Location> locations = locationService.getAllLocations();
            request.setAttribute("locations", locations);
            
            // Xử lý tìm kiếm nếu có tham số
            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            String departureDateStr = request.getParameter("departureDate");
            
            // Nếu không có tham số tìm kiếm, hiển thị tất cả các chuyến bay
            if ((origin == null || origin.isEmpty()) && 
                (destination == null || destination.isEmpty()) && 
                (departureDateStr == null || departureDateStr.isEmpty())) {
                
                try {
                    // Lấy tất cả các chuyến bay
                    List<Flight> flights = flightService.getAllFlights();
                    request.setAttribute("flights", flights);
                } catch (SQLException e) {
                    Logger.getLogger(BookingServlet.class.getName()).log(Level.SEVERE, 
                            "Lỗi khi lấy danh sách chuyến bay: " + e.getMessage(), e);
                    request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                }
            } 
            // Nếu có tham số tìm kiếm, thực hiện tìm kiếm
            else if (origin != null && destination != null && departureDateStr != null 
                    && !origin.isEmpty() && !destination.isEmpty() && !departureDateStr.isEmpty()) {
                
                try {
                    // Chuyển đổi chuỗi ngày thành đối tượng Date
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date departureDate = dateFormat.parse(departureDateStr);
                    
                    // Tìm kiếm chuyến bay
                    List<Flight> flights = flightService.searchFlights(origin, destination, departureDate);
                    request.setAttribute("flights", flights);
                } catch (ParseException e) {
                    request.setAttribute("error", "Định dạng ngày không hợp lệ: " + e.getMessage());
                } catch (SQLException e) {
                    Logger.getLogger(BookingServlet.class.getName()).log(Level.SEVERE, 
                            "Lỗi khi tìm kiếm chuyến bay: " + e.getMessage(), e);
                    request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                }
            }
            
            request.getRequestDispatcher("/WEB-INF/views/booking/flights.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/booking/flights.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị trang xác nhận đặt vé
     */
    private void showConfirmPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String flightIdStr = request.getParameter("flightId");
        
        try {
            int flightId = Integer.parseInt(flightIdStr);
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                response.sendRedirect(request.getContextPath() + "/booking?action=flights");
                return;
            }
            
            // Lấy danh sách ghế ngồi theo loại
            List<Seat> firstClassSeats = seatService.getSeatsByFlightAndClass(flightId, "FIRST");
            List<Seat> businessSeats = seatService.getSeatsByFlightAndClass(flightId, "BUSINESS");
            List<Seat> economySeats = seatService.getSeatsByFlightAndClass(flightId, "ECONOMY");
            
            request.setAttribute("flight", flight);
            request.setAttribute("firstClassSeats", firstClassSeats);
            request.setAttribute("businessSeats", businessSeats);
            request.setAttribute("economySeats", economySeats);
            
            request.getRequestDispatcher("/WEB-INF/views/booking/confirm.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/booking?action=flights");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/booking/flights.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị trang danh sách đặt vé của người dùng
     */
    private void showBookingListPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        try {
            // Lấy danh sách đặt vé của người dùng
            List<Booking> bookings = bookingService.findByUserId(user.getUserId());
            
            // Lấy thông tin chuyến bay cho mỗi đặt vé
            for (Booking booking : bookings) {
                Flight flight = flightService.findById(booking.getFlightId());
                booking.setFlight(flight);
            }
            
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/views/booking/list.jsp").forward(request, response);
            
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/booking/list.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý tạo đặt vé mới
     */
    private void processBookingCreation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Lấy thông tin từ form
        String flightIdStr = request.getParameter("flightId");
        String seatIdStr = request.getParameter("seatId");
        String seatNumber = request.getParameter("seatNumber");
        String seatPriceStr = request.getParameter("seatPrice");
        String passengerName = request.getParameter("passengerName");
        String passengerPhone = request.getParameter("passengerPhone");
        String passengerEmail = request.getParameter("passengerEmail");
        String specialRequests = request.getParameter("specialRequests");
        String paymentMethod = request.getParameter("paymentMethod");
        
        try {
            Integer flightId = Integer.parseInt(flightIdStr);
            Integer seatId = Integer.parseInt(seatIdStr);
            BigDecimal seatPrice = new BigDecimal(seatPriceStr);
            
            Flight flight = flightService.findById(flightId);
            
            if (flight == null) {
                request.setAttribute("error", "Không tìm thấy chuyến bay");
                request.getRequestDispatcher("/WEB-INF/views/booking/flights.jsp").forward(request, response);
                return;
            }
            
            // Tạo đối tượng booking
            Booking booking = new Booking();
            booking.setFlightId(flightId);
            booking.setUserId(user.getUserId());
            booking.setBookingDate(new Date());
            booking.setStatus(BookingStatus.PENDING);
            booking.setTotalPrice(seatPrice);
            booking.setSeatNumber(seatNumber);
            booking.setPassengerName(passengerName);
            booking.setPassengerEmail(passengerEmail);
            booking.setPassengerPhone(passengerPhone);
            booking.setPaymentMethod(paymentMethod);
            booking.setPaymentStatus("UNPAID");
            
            // Lưu booking vào database
            boolean created = bookingService.createBooking(booking);
            
            if (created) {
                try {
                    // Cập nhật trạng thái ghế
                    boolean seatUpdated = seatService.updateSeatStatus(seatId, "BOOKED");
                    
                    if (!seatUpdated) {
                        Logger.getLogger(BookingServlet.class.getName()).log(Level.WARNING, 
                                "Không thể cập nhật trạng thái ghế ID: " + seatId);
                    }
                    
                    // Cập nhật số ghế trống
                    boolean updated = flightService.updateAvailableSeats(flightId, -1);
                    
                    if (!updated) {
                        Logger.getLogger(BookingServlet.class.getName()).log(Level.WARNING, 
                                "Không thể cập nhật số ghế có sẵn cho chuyến bay ID: " + flightId);
                    }
                } catch (Exception e) {
                    Logger.getLogger(BookingServlet.class.getName()).log(Level.SEVERE, 
                            "Lỗi khi cập nhật số ghế có sẵn: " + e.getMessage(), e);
                }
                
                // Đặt thông báo thành công và chuyển hướng đến trang danh sách đặt vé
                session.setAttribute("success", "Đặt vé thành công! Mã đặt vé của bạn là: " + booking.getBookingId());
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
            } else {
                request.setAttribute("error", "Không thể tạo đặt vé. Vui lòng thử lại.");
                request.getRequestDispatcher("/WEB-INF/views/booking/confirm.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/booking?action=flights");
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/booking/confirm.jsp").forward(request, response);
        }
    }
    
    /**
     * Hủy đặt vé
     */
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String bookingIdStr = request.getParameter("id");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = bookingService.findById(bookingId);
            
            if (booking == null || booking.getUserId() != user.getUserId()) {
                session.setAttribute("error", "Không tìm thấy đặt vé hoặc bạn không có quyền hủy đặt vé này");
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
                return;
            }
            
            // Cập nhật trạng thái đặt vé thành CANCELLED
            booking.setStatus(BookingStatus.CANCELLED);
            boolean updated = bookingService.updateBooking(booking);
            
            if (updated) {
                // Cập nhật số ghế trống
                flightService.updateAvailableSeats(booking.getFlightId(), 1);
                
                // Cập nhật trạng thái ghế
                if (booking.getSeatNumber() != null && !booking.getSeatNumber().isEmpty()) {
                    seatService.updateSeatStatusByFlightAndSeatNumber(
                            booking.getFlightId(), booking.getSeatNumber(), "AVAILABLE");
                }
                
                session.setAttribute("success", "Hủy đặt vé thành công");
            } else {
                session.setAttribute("error", "Không thể hủy đặt vé. Vui lòng thử lại.");
            }
            
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        } catch (SQLException e) {
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        }
    }
} 