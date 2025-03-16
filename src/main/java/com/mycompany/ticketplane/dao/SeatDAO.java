package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Seat;
import com.mycompany.ticketplane.model.Seat.SeatClass;
import com.mycompany.ticketplane.model.Seat.SeatStatus;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SeatDAO extends DBConnection {

    private static final Logger LOGGER = Logger.getLogger(SeatDAO.class.getName());

    public SeatDAO() {
        super();
    }

    /**
     * Tìm ghế theo ID
     * 
     * @param seatId ID của ghế
     * @return Đối tượng Seat nếu tìm thấy, null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Seat findById(int seatId) throws SQLException {
        String sql = "SELECT * FROM seat WHERE seat_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, seatId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToSeat(rs);
            }
            
            return null;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    /**
     * Tìm danh sách ghế theo chuyến bay và hạng ghế
     * 
     * @param flightId ID của chuyến bay
     * @param seatClass Hạng ghế (ECONOMY, BUSINESS, FIRST)
     * @return Danh sách ghế
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Seat> findByFlightAndClass(int flightId, String seatClass) throws SQLException {
        String sql = "SELECT * FROM seat WHERE flight_id = ? AND seat_class = ? ORDER BY seat_number";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Seat> seats = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, flightId);
            stmt.setString(2, seatClass);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                seats.add(mapResultSetToSeat(rs));
            }
            
            return seats;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    /**
     * Cập nhật trạng thái ghế
     * 
     * @param seatId ID của ghế
     * @param status Trạng thái mới (AVAILABLE, BOOKED, RESERVED)
     * @return true nếu cập nhật thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean updateStatus(int seatId, String status) throws SQLException {
        String sql = "UPDATE seat SET status = ? WHERE seat_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, seatId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public List<Seat> findByFlightId(int flightId) throws SQLException {
        String sql = "SELECT * FROM Seat WHERE flight_id = ?";
        List<Seat> seats = new ArrayList<>();

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, flightId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                seats.add(mapResultSetToSeat(resultSet));
            }
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
        return seats;
    }

    public List<Seat> findAvailableSeatsByFlightId(int flightId) throws SQLException {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT * FROM Seat WHERE flight_id = ? AND status = 'AVAILABLE'";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, flightId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                seats.add(mapResultSetToSeat(resultSet));
            }
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }

        return seats;
    }

    public boolean updateSeatStatus(int flightId, String seatNumber, SeatStatus status) throws SQLException {
        String sql = "UPDATE Seat SET status = ? WHERE flight_id = ? AND seat_number = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status.name());
            statement.setInt(2, flightId);
            statement.setString(3, seatNumber);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
    }

    public boolean insertSeatsForFlight(int flightId, int economySeats, int businessSeats, int firstClassSeats) throws SQLException {
        String sql = "INSERT INTO Seat (flight_id, seat_number, class, status) VALUES (?, ?, ?, ?)";

        try {
            connection = getConnection();
            connection.setAutoCommit(false);
            statement = connection.prepareStatement(sql);

            // Thêm ghế hạng Economy
            for (int i = 1; i <= economySeats; i++) {
                String seatNumber = "E" + String.format("%02d", i);
                statement.setInt(1, flightId);
                statement.setString(2, seatNumber);
                statement.setString(3, SeatClass.ECONOMY.toString());
                statement.setString(4, SeatStatus.AVAILABLE.toString());
                statement.addBatch();
            }

            // Thêm ghế hạng Business
            for (int i = 1; i <= businessSeats; i++) {
                String seatNumber = "B" + String.format("%02d", i);
                statement.setInt(1, flightId);
                statement.setString(2, seatNumber);
                statement.setString(3, SeatClass.BUSINESS.toString());
                statement.setString(4, SeatStatus.AVAILABLE.toString());
                statement.addBatch();
            }

            // Thêm ghế hạng First Class
            for (int i = 1; i <= firstClassSeats; i++) {
                String seatNumber = "F" + String.format("%02d", i);
                statement.setInt(1, flightId);
                statement.setString(2, seatNumber);
                statement.setString(3, SeatClass.FIRST.toString());
                statement.setString(4, SeatStatus.AVAILABLE.toString());
                statement.addBatch();
            }

            int[] results = statement.executeBatch();

            // Kiểm tra kết quả
            boolean success = true;
            for (int result : results) {
                if (result <= 0) {
                    success = false;
                    break;
                }
            }

            if (success) {
                connection.commit();
                return true;
            } else {
                connection.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            throw e;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                } finally {
                    closeResources();
                }
            }
        }
    }

    public List<Seat> findByFlightIdAndStatus(int flightId, SeatStatus status) throws SQLException {
        String sql = "SELECT * FROM Seat WHERE flight_id = ? AND status = ?";
        List<Seat> seats = new ArrayList<>();

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, flightId);
            statement.setString(2, status.name());
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                seats.add(mapResultSetToSeat(resultSet));
            }
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
        return seats;
    }

    public Seat findBySeatNumber(int flightId, String seatNumber) throws SQLException {
        String sql = "SELECT * FROM Seat WHERE flight_id = ? AND seat_number = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, flightId);
            statement.setString(2, seatNumber);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapResultSetToSeat(resultSet);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean insert(Seat seat) throws SQLException {
        String sql = "INSERT INTO Seat (flight_id, seat_number, class, status) VALUES (?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, seat.getFlightId());
            statement.setString(2, seat.getSeatNumber());
            statement.setString(3, seat.getSeatClass().name());
            statement.setString(4, seat.getStatus().name());

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    seat.setSeatId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean delete(int seatId) throws SQLException {
        String sql = "DELETE FROM Seat WHERE seat_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, seatId);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
    }

    private Seat mapResultSetToSeat(ResultSet rs) throws SQLException {
        Seat seat = new Seat();
        seat.setSeatId(rs.getInt("seat_id"));
        seat.setFlightId(rs.getInt("flight_id"));
        seat.setSeatNumber(rs.getString("seat_number"));
        seat.setSeatClass(SeatClass.valueOf(rs.getString("seat_class")));
        seat.setPrice(rs.getBigDecimal("price"));
        seat.setStatus(SeatStatus.valueOf(rs.getString("status")));
        return seat;
    }

    private void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
    }

    /**
     * Cập nhật trạng thái ghế dựa trên ID chuyến bay và số ghế
     * 
     * @param flightId ID của chuyến bay
     * @param seatNumber Số ghế
     * @param status Trạng thái mới của ghế
     * @return true nếu cập nhật thành công, false nếu không
     * @throws SQLException nếu có lỗi SQL
     */
    public boolean updateSeatStatusByFlightAndSeatNumber(Integer flightId, String seatNumber, String status) throws SQLException {
        String sql = "UPDATE seat SET status = ? WHERE flight_id = ? AND seat_number = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, flightId);
            statement.setString(3, seatNumber);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
    }

    /**
     * Tạo ghế cho chuyến bay với số lượng ghế được chỉ định
     * 
     * @param flightId ID của chuyến bay
     * @param totalSeats Tổng số ghế cần tạo
     * @return true nếu tạo thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean createSeatsForFlight(Integer flightId, int totalSeats) throws SQLException {
        // Phân bổ số ghế cho từng hạng
        int economySeats = (int) (totalSeats * 0.7); // 70% là ghế Economy
        int businessSeats = (int) (totalSeats * 0.2); // 20% là ghế Business
        int firstClassSeats = totalSeats - economySeats - businessSeats; // 10% còn lại là First Class
        
        return insertSeatsForFlight(flightId, economySeats, businessSeats, firstClassSeats);
    }
}
