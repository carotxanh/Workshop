package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Booking.BookingStatus;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingDAO extends DBConnection {
    
    private UserDAO userDAO;
    private FlightDAO flightDAO;
    
    public BookingDAO() {
        super();
        this.userDAO = new UserDAO();
        this.flightDAO = new FlightDAO();
    }
    
    public Booking findById(int bookingId) {
        Booking booking = null;
        String sql = "SELECT * FROM Booking WHERE booking_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                booking = mapResultSetToBooking(rs);
                
                // Lấy thông tin user và flight
                booking.setUser(userDAO.findById(booking.getUserId()));
                booking.setFlight(flightDAO.findById(booking.getFlightId()));
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return booking;
    }
    
    public List<Booking> findByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return bookings;
    }
    
    /**
     * Lấy tất cả các đặt vé trong hệ thống
     * @return Danh sách tất cả các đặt vé
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Booking> findAll() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY booking_date DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                
                // Lấy thông tin người dùng và chuyến bay
                User user = userDAO.findById(booking.getUserId());
                Flight flight = flightDAO.findById(booking.getFlightId());
                
                booking.setUser(user);
                booking.setFlight(flight);
                
                bookings.add(booking);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return bookings;
    }
    
    public boolean insert(Booking booking) {
        String sql = "INSERT INTO booking (user_id, flight_id, booking_date, total_price, status, passenger_name, passenger_email, passenger_phone, seat_number, payment_method, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getFlightId());
            stmt.setTimestamp(3, new Timestamp(booking.getBookingDate().getTime()));
            stmt.setBigDecimal(4, booking.getTotalPrice());
            stmt.setString(5, booking.getStatus().toString());
            stmt.setString(6, booking.getPassengerName());
            stmt.setString(7, booking.getPassengerEmail());
            stmt.setString(8, booking.getPassengerPhone());
            stmt.setString(9, booking.getSeatNumber());
            stmt.setString(10, booking.getPaymentMethod());
            stmt.setString(11, booking.getPaymentStatus());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Lấy ID được tạo tự động
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    booking.setBookingId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }
    
    public boolean update(Booking booking) {
        String sql = "UPDATE Booking SET user_id = ?, flight_id = ?, booking_date = ?, " +
                     "seat_number = ?, status = ?, total_price = ? WHERE booking_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getFlightId());
            stmt.setTimestamp(3, new Timestamp(booking.getBookingDate().getTime()));
            stmt.setString(4, booking.getSeatNumber());
            stmt.setString(5, booking.getStatus().toString());
            stmt.setBigDecimal(6, booking.getTotalPrice());
            stmt.setInt(7, booking.getBookingId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(null, stmt, conn);
        }
        return false;
    }
    
    public boolean updateStatus(int bookingId, BookingStatus status) {
        String sql = "UPDATE Booking SET status = ? WHERE booking_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status.toString());
            stmt.setInt(2, bookingId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(null, stmt, conn);
        }
        return false;
    }
    
    public boolean delete(int bookingId) {
        String sql = "DELETE FROM Booking WHERE booking_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(null, stmt, conn);
        }
        return false;
    }
    
    public int getTotalBookings() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }
    
    public BigDecimal getTotalRevenue() {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return revenue;
    }
    
    public BigDecimal getMonthlyRevenue(int month, int year) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE MONTH(booking_date) = ? AND YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return revenue;
    }
    
    public BigDecimal getYearlyRevenue(int year) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, year);
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return revenue;
    }
    
    public int getMonthlyBookingCount(int month, int year) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking WHERE MONTH(booking_date) = ? AND YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }
    
    public BigDecimal getRevenueByDateRange(Date startDate, Date endDate) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE booking_date BETWEEN ? AND ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, new Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new Timestamp(endDate.getTime()));
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return revenue;
    }
    
    public int getBookingCountByDateRange(Date startDate, Date endDate) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking WHERE booking_date BETWEEN ? AND ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, new Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new Timestamp(endDate.getTime()));
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }
    
    public BigDecimal getRevenueByClass(String seatClass) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(b.total_price) FROM Booking b " +
                     "JOIN Seat s ON b.flight_id = s.flight_id AND b.seat_number = s.seat_number " +
                     "WHERE s.class = ? AND b.status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, seatClass);
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return revenue;
    }
    
    public int getBookingCountByClass(String seatClass) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking b " +
                     "JOIN Seat s ON b.flight_id = s.flight_id AND b.seat_number = s.seat_number " +
                     "WHERE s.class = ? AND b.status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, seatClass);
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }
    
    public BigDecimal getRevenueByWeek(int weekNumber, int year) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE WEEK(booking_date, 1) = ? AND YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, weekNumber);
            stmt.setInt(2, year);
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return revenue;
    }
    
    public int getBookingCountByWeek(int weekNumber, int year) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking WHERE WEEK(booking_date, 1) = ? AND YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, weekNumber);
            stmt.setInt(2, year);
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }
    
    public BigDecimal getRevenueByDate(Date date) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE DATE(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, new java.sql.Date(date.getTime()));
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return revenue;
    }
    
    public int getBookingCountByDate(Date date) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking WHERE DATE(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, new java.sql.Date(date.getTime()));
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }
    
    public int getBookingCountByQuarter(int quarter, int year) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking WHERE QUARTER(booking_date) = ? AND YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, quarter);
            stmt.setInt(2, year);
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }
    
    public BigDecimal getRevenueByClassAndDateRange(String seatClass, Date startDate, Date endDate) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(b.total_price) FROM Booking b " +
                     "JOIN Seat s ON b.flight_id = s.flight_id AND b.seat_number = s.seat_number " +
                     "WHERE s.class = ? AND b.booking_date BETWEEN ? AND ? AND b.status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, seatClass);
            stmt.setTimestamp(2, new Timestamp(startDate.getTime()));
            stmt.setTimestamp(3, new Timestamp(endDate.getTime()));
            rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return revenue;
    }
    
    public int getBookingCountByClassAndDateRange(String seatClass, Date startDate, Date endDate) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking b " +
                     "JOIN Seat s ON b.flight_id = s.flight_id AND b.seat_number = s.seat_number " +
                     "WHERE s.class = ? AND b.booking_date BETWEEN ? AND ? AND b.status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, seatClass);
            stmt.setTimestamp(2, new Timestamp(startDate.getTime()));
            stmt.setTimestamp(3, new Timestamp(endDate.getTime()));
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        return count;
    }
    
    public BigDecimal getRevenueByMonth(int month, int year) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE MONTH(booking_date) = ? AND YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return revenue;
    }
    
    public BigDecimal getRevenueByYear(int year) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, year);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return revenue;
    }
    
    public int getBookingCountByMonth(int month, int year) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking WHERE MONTH(booking_date) = ? AND YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return count;
    }
    
    public BigDecimal getRevenueByQuarter(int quarter, int year) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE QUARTER(booking_date) = ? AND YEAR(booking_date) = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, quarter);
            stmt.setInt(2, year);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return revenue;
    }
    
    public List<Booking> getRecentBookings(int limit) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY booking_date DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                booking.setUser(userDAO.findById(booking.getUserId()));
                booking.setFlight(flightDAO.findById(booking.getFlightId()));
                bookings.add(booking);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return bookings;
    }
    
    public int getBookingCountByStatus(BookingStatus status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking WHERE status = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status.toString());
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return count;
    }
    
    public BigDecimal getRevenueByStatus(BookingStatus status) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM Booking WHERE status = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status.toString());
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return revenue;
    }
    
    public BigDecimal getRevenueByDestination(int destinationId) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(b.total_price) FROM Booking b " +
                     "JOIN Flight f ON b.flight_id = f.flight_id " +
                     "WHERE f.destination_id = ? AND b.status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, destinationId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                if (sum != null) {
                    revenue = sum;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return revenue;
    }
    
    public int getBookingCountByDestination(int destinationId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Booking b " +
                     "JOIN Flight f ON b.flight_id = f.flight_id " +
                     "WHERE f.destination_id = ? AND b.status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, destinationId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return count;
    }
    
    /**
     * Lấy danh sách booking theo trạng thái
     * @param status Trạng thái booking cần lấy
     * @return Danh sách booking theo trạng thái
     */
    public List<Booking> findByStatus(BookingStatus status) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE status = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status.toString());
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                booking.setUser(userDAO.findById(booking.getUserId()));
                booking.setFlight(flightDAO.findById(booking.getFlightId()));
                bookings.add(booking);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return bookings;
    }
    
    /**
     * Lấy danh sách booking theo khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Danh sách booking trong khoảng thời gian
     */
    public List<Booking> findByDateRange(Date startDate, Date endDate) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE booking_date BETWEEN ? AND ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, new Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new Timestamp(endDate.getTime()));
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                booking.setUser(userDAO.findById(booking.getUserId()));
                booking.setFlight(flightDAO.findById(booking.getFlightId()));
                bookings.add(booking);
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources(rs, stmt, conn);
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
        booking.setPassengerName(rs.getString("passenger_name"));
        booking.setPassengerEmail(rs.getString("passenger_email"));
        booking.setPassengerPhone(rs.getString("passenger_phone"));
        booking.setPaymentMethod(rs.getString("payment_method"));
        booking.setPaymentStatus(rs.getString("payment_status"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        booking.setUpdatedAt(rs.getTimestamp("updated_at"));
        return booking;
    }
    
    private void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
} 