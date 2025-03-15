package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.BookingDAO;
import com.mycompany.ticketplane.dao.FlightDAO;
import com.mycompany.ticketplane.dao.SeatDAO;
import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Booking.BookingStatus;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Seat.SeatStatus;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class BookingService {
    
    private BookingDAO bookingDAO;
    private FlightDAO flightDAO;
    private SeatDAO seatDAO;
    
    public BookingService() {
        this.bookingDAO = new BookingDAO();
        this.flightDAO = new FlightDAO();
        this.seatDAO = new SeatDAO();
    }
    
    public Booking findById(int bookingId) throws SQLException {
        return bookingDAO.findById(bookingId);
    }
    
    public List<Booking> findByUserId(int userId) throws SQLException {
        return bookingDAO.findByUserId(userId);
    }
    
    public List<Booking> findAll() throws SQLException {
        return bookingDAO.findAll();
    }
    
    public Booking bookFlight(int userId, int flightId, String seatNumber, BigDecimal totalPrice) throws SQLException {
        // Kiểm tra chuyến bay có tồn tại không
        Flight flight = flightDAO.findById(flightId);
        if (flight == null || flight.getAvailableSeats() <= 0) {
            return null;
        }
        
        // Tạo đối tượng booking
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setFlightId(flightId);
        booking.setBookingDate(new Date());
        booking.setSeatNumber(seatNumber);
        booking.setStatus(BookingStatus.PENDING);
        booking.setTotalPrice(totalPrice);
        
        // Lưu booking vào database
        boolean bookingCreated = bookingDAO.insert(booking);
        
        if (bookingCreated) {
            // Cập nhật trạng thái ghế
            seatDAO.updateSeatStatus(flightId, seatNumber, SeatStatus.BOOKED);
            return booking;
        }
        
        return null;
    }
    
    public boolean confirmBooking(int bookingId) throws SQLException {
        return bookingDAO.updateStatus(bookingId, BookingStatus.CONFIRMED);
    }
    
    public boolean cancelBooking(int bookingId) throws SQLException {
        Booking booking = bookingDAO.findById(bookingId);
        
        if (booking == null) {
            return false;
        }
        
        // Cập nhật trạng thái booking
        boolean statusUpdated = bookingDAO.updateStatus(bookingId, BookingStatus.CANCELLED);
        
        if (statusUpdated) {
            // Cập nhật trạng thái ghế
            seatDAO.updateSeatStatus(booking.getFlightId(), booking.getSeatNumber(), SeatStatus.AVAILABLE);
            return true;
        }
        
        return false;
    }
} 