package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Seat;
import com.mycompany.ticketplane.model.Seat.SeatClass;
import com.mycompany.ticketplane.model.Seat.SeatStatus;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SeatDAO {
    
    public Seat findById(int seatId) throws SQLException {
        String sql = "SELECT * FROM Seat WHERE seat_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, seatId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSeat(rs);
                }
            }
        }
        
        return null;
    }
    
    public List<Seat> findByFlightId(int flightId) throws SQLException {
        String sql = "SELECT * FROM Seat WHERE flight_id = ?";
        List<Seat> seats = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, flightId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    seats.add(mapResultSetToSeat(rs));
                }
            }
        }
        return seats;
    }
    
    public List<Seat> findAvailableSeatsByFlightId(int flightId) throws SQLException {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT * FROM Seat WHERE flight_id = ? AND status = 'AVAILABLE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, flightId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    seats.add(mapResultSetToSeat(rs));
                }
            }
        }
        
        return seats;
    }
    
    public boolean updateSeatStatus(int flightId, String seatNumber, SeatStatus status) throws SQLException {
        String sql = "UPDATE Seat SET status = ? WHERE flight_id = ? AND seat_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, flightId);
            stmt.setString(3, seatNumber);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean insertSeatsForFlight(int flightId, int economySeats, int businessSeats, int firstClassSeats) throws SQLException {
        String sql = "INSERT INTO Seat (flight_id, seat_number, class, status) VALUES (?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            stmt = conn.prepareStatement(sql);
            
            // Thêm ghế hạng Economy
            for (int i = 1; i <= economySeats; i++) {
                String seatNumber = "E" + String.format("%02d", i);
                stmt.setInt(1, flightId);
                stmt.setString(2, seatNumber);
                stmt.setString(3, SeatClass.ECONOMY.toString());
                stmt.setString(4, SeatStatus.AVAILABLE.toString());
                stmt.addBatch();
            }
            
            // Thêm ghế hạng Business
            for (int i = 1; i <= businessSeats; i++) {
                String seatNumber = "B" + String.format("%02d", i);
                stmt.setInt(1, flightId);
                stmt.setString(2, seatNumber);
                stmt.setString(3, SeatClass.BUSINESS.toString());
                stmt.setString(4, SeatStatus.AVAILABLE.toString());
                stmt.addBatch();
            }
            
            // Thêm ghế hạng First Class
            for (int i = 1; i <= firstClassSeats; i++) {
                String seatNumber = "F" + String.format("%02d", i);
                stmt.setInt(1, flightId);
                stmt.setString(2, seatNumber);
                stmt.setString(3, SeatClass.FIRST_CLASS.toString());
                stmt.setString(4, SeatStatus.AVAILABLE.toString());
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            
            // Kiểm tra kết quả
            boolean success = true;
            for (int result : results) {
                if (result <= 0) {
                    success = false;
                    break;
                }
            }
            
            if (success) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
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
    
    public List<Seat> findByFlightIdAndStatus(int flightId, SeatStatus status) throws SQLException {
        String sql = "SELECT * FROM Seat WHERE flight_id = ? AND status = ?";
        List<Seat> seats = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, flightId);
            stmt.setString(2, status.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    seats.add(mapResultSetToSeat(rs));
                }
            }
        }
        return seats;
    }

    public Seat findBySeatNumber(int flightId, String seatNumber) throws SQLException {
        String sql = "SELECT * FROM Seat WHERE flight_id = ? AND seat_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, flightId);
            stmt.setString(2, seatNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSeat(rs);
                }
            }
        }
        return null;
    }

    public boolean insert(Seat seat) throws SQLException {
        String sql = "INSERT INTO Seat (flight_id, seat_number, class, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, seat.getFlightId());
            stmt.setString(2, seat.getSeatNumber());
            stmt.setString(3, seat.getSeatClass().name());
            stmt.setString(4, seat.getStatus().name());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    seat.setSeatId(generatedKeys.getInt(1));
                    return true;
                }
            }
        }
        return false;
    }

    public boolean delete(int seatId) throws SQLException {
        String sql = "DELETE FROM Seat WHERE seat_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, seatId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private Seat mapResultSetToSeat(ResultSet rs) throws SQLException {
        Seat seat = new Seat();
        seat.setSeatId(rs.getInt("seat_id"));
        seat.setFlightId(rs.getInt("flight_id"));
        seat.setSeatNumber(rs.getString("seat_number"));
        seat.setSeatClass(SeatClass.valueOf(rs.getString("class")));
        seat.setStatus(SeatStatus.valueOf(rs.getString("status")));
        seat.setCreatedAt(rs.getTimestamp("created_at"));
        seat.setUpdatedAt(rs.getTimestamp("updated_at"));
        return seat;
    }
} 