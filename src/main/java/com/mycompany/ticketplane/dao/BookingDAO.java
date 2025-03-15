package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Booking.BookingStatus;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class BookingDAO {
    
    private UserDAO userDAO = new UserDAO();
    private FlightDAO flightDAO = new FlightDAO();
    private Connection connection = null;
    private PreparedStatement statement = null;
    private ResultSet resultSet = null;
    
    public Booking findById(int bookingId) throws SQLException {
        String sql = "SELECT * FROM Booking WHERE booking_id = ?";
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    
                    // Lấy thông tin user và flight
                    booking.setUser(userDAO.findById(booking.getUserId()));
                    booking.setFlight(flightDAO.findById(booking.getFlightId()));
                    
                    return booking;
                }
            }
        }
        
        return null;
    }
    
    public List<Booking> findByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE user_id = ?";
        try {
            Connection conn = new DBConnection().getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                bookings.add(mapResultSetToBooking(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return bookings;
    }
    
    public List<Booking> findAll() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY booking_date DESC";
        
        try (Connection conn = new DBConnection().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                booking.setUser(userDAO.findById(booking.getUserId()));
                booking.setFlight(flightDAO.findById(booking.getFlightId()));
                bookings.add(booking);
            }
        }
        
        return bookings;
    }
    
    public boolean insert(Booking booking) throws SQLException {
        String sql = "INSERT INTO Booking (user_id, flight_id, booking_date, seat_number, status, total_price) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            DBConnection dbConnection = new DBConnection();
            conn = dbConnection.getConnection();
            conn.setAutoCommit(false);
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getFlightId());
            stmt.setTimestamp(3, new Timestamp(booking.getBookingDate().getTime()));
            stmt.setString(4, booking.getSeatNumber());
            stmt.setString(5, booking.getStatus().toString());
            stmt.setBigDecimal(6, booking.getTotalPrice());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                conn.rollback();
                return false;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    booking.setBookingId(generatedKeys.getInt(1));
                    
                    // Cập nhật số ghế còn trống
                    Flight flight = flightDAO.findById(booking.getFlightId());
                    int newAvailableSeats = flight.getAvailableSeats() - 1;
                    flightDAO.updateAvailableSeats(booking.getFlightId(), newAvailableSeats);
                    
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
    
    public boolean updateStatus(int bookingId, BookingStatus status) throws SQLException {
        String sql = "UPDATE Booking SET status = ? WHERE booking_id = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, bookingId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean delete(int bookingId) throws SQLException {
        String sql = "DELETE FROM Booking WHERE booking_id = ?";
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public int getTotalBookings() {
        String sql = "SELECT COUNT(*) FROM Booking";
        try {
            Connection conn = new DBConnection().getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public BigDecimal getTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(total_price) FROM Booking WHERE status = 'COMPLETED'";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
            return BigDecimal.ZERO;
        }
    }
    
    public List<Booking> findByStatus(BookingStatus status) throws SQLException {
        String sql = "SELECT * FROM Booking WHERE status = ? ORDER BY booking_date DESC";
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        }
        return bookings;
    }

    public List<Booking> findByUserIdAndStatus(int userId, BookingStatus status) throws SQLException {
        String sql = "SELECT * FROM Booking WHERE user_id = ? AND status = ? ORDER BY booking_date DESC";
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, status.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        }
        return bookings;
    }
    
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setFlightId(rs.getInt("flight_id"));
        booking.setBookingDate(rs.getTimestamp("booking_date"));
        booking.setSeatNumber(rs.getString("seat_number"));
        booking.setStatus(BookingStatus.valueOf(rs.getString("status")));
        booking.setTotalPrice(rs.getBigDecimal("total_price"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        booking.setUpdatedAt(rs.getTimestamp("updated_at"));
        return booking;
    }

    private void closeResources() {
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }
} 