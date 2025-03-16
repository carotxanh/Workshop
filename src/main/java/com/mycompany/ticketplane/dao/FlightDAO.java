package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Flight.FlightStatus;
import com.mycompany.ticketplane.model.Location;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FlightDAO extends DBConnection {
    
    private static final Logger LOGGER = Logger.getLogger(FlightDAO.class.getName());
    
    public Flight findById(int flightId) throws SQLException {
        Flight flight = null;
        String sql = "SELECT * FROM Flight WHERE flight_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, flightId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                flight = mapResultSetToFlight(resultSet);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return flight;
    }
    
    public List<Flight> findAll() throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flight";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                flights.add(mapResultSetToFlight(resultSet));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return flights;
    }
    
//    public List<Flight> searchFlights(String origin, String destination, Date departureDate) {
//        List<Flight> flights = new ArrayList<>();
//        String sql = "SELECT * FROM Flight WHERE origin = ? AND destination = ? " +
//                    "AND DATE(departure_time) = ? AND status = 'SCHEDULED' " +
//                    "AND available_seats > 0 ORDER BY departure_time";
//        try {
//            statement = connection.prepareStatement(sql);
//            statement.setString(1, origin);
//            statement.setString(2, destination);
//            statement.setDate(3, new java.sql.Date(departureDate.getTime()));
//            resultSet = statement.executeQuery();
//            while (resultSet.next()) {
//                flights.add(mapResultSetToFlight(resultSet));
//            }
//        } catch (SQLException ex) {
//            Logger.getLogger(FlightDAO.class.getName()).log(Level.SEVERE, null, ex);
//        } finally {
//            closeResources();
//        }
//        return flights;
//    }
    
    public boolean insert(Flight flight) {
        String sql = "INSERT INTO Flight (airline, flight_number, origin, destination, departure_time, arrival_time, " +
                    "duration, price, available_seats, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, flight.getAirline());
            statement.setString(2, flight.getFlightNumber());
            statement.setString(3, flight.getOrigin());
            statement.setString(4, flight.getDestination());
            statement.setTimestamp(5, new Timestamp(flight.getDepartureTime().getTime()));
            statement.setTimestamp(6, new Timestamp(flight.getArrivalTime().getTime()));
            statement.setTime(7, flight.getDuration());
            statement.setBigDecimal(8, flight.getPrice());
            statement.setInt(9, flight.getAvailableSeats());
            statement.setString(10, flight.getStatus().toString());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                flight.setFlightId(resultSet.getInt(1));
                return true;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
        } finally {
            closeResources();
        }
        return false;
    }
    
    public boolean update(Flight flight) {
        String sql = "UPDATE Flight SET airline = ?, flight_number = ?, origin = ?, destination = ?, " +
                    "departure_time = ?, arrival_time = ?, duration = ?, price = ?, available_seats = ?, " +
                    "status = ? WHERE flight_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, flight.getAirline());
            statement.setString(2, flight.getFlightNumber());
            statement.setString(3, flight.getOrigin());
            statement.setString(4, flight.getDestination());
            statement.setTimestamp(5, new Timestamp(flight.getDepartureTime().getTime()));
            statement.setTimestamp(6, new Timestamp(flight.getArrivalTime().getTime()));
            statement.setTime(7, flight.getDuration());
            statement.setBigDecimal(8, flight.getPrice());
            statement.setInt(9, flight.getAvailableSeats());
            statement.setString(10, flight.getStatus().toString());
            statement.setInt(11, flight.getFlightId());
            
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
        } finally {
            closeResources();
        }
        return false;
    }
    
    public boolean delete(int flightId) {
        String sql = "DELETE FROM Flight WHERE flight_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, flightId);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
        } finally {
            closeResources();
        }
        return false;
    }
    
    /**
     * Cập nhật số ghế có sẵn của chuyến bay
     * 
     * @param flightId ID của chuyến bay
     * @param change Số lượng ghế thay đổi (dương: tăng, âm: giảm)
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateAvailableSeats(int flightId, int change) {
        String sql = "UPDATE Flight SET available_seats = available_seats + ? WHERE flight_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, change);
            stmt.setInt(2, flightId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return false;
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, e.getMessage(), e);
            }
        }
    }
    
    /**
     * Lấy danh sách các chuyến bay sắp tới
     * @param limit Số lượng chuyến bay tối đa cần lấy
     * @return Danh sách các chuyến bay sắp tới
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Flight> getUpcomingFlights(int limit) throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flight WHERE departure_time > NOW() " +
                    "AND (status = 'SCHEDULED' OR status = 'ON_TIME') " +
                    "ORDER BY departure_time LIMIT ?";
        
        try {
            // Đảm bảo kết nối được mở mới
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, limit);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                flights.add(mapResultSetToFlight(resultSet));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return flights;
    }
    
    public boolean updateStatus(int flightId, FlightStatus status) {
        String sql = "UPDATE Flight SET status = ? WHERE flight_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status.name());
            statement.setInt(2, flightId);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
        } finally {
            closeResources();
        }
        return false;
    }
    
    public List<Flight> findByStatus(FlightStatus status) {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flight WHERE status = ? ORDER BY departure_time";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status.name());
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                flights.add(mapResultSetToFlight(resultSet));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
        } finally {
            closeResources();
        }
        return flights;
    }
    
    public int getFlightCountByStatus(String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Flight WHERE status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
        } finally {
            closeResources();
        }
        return count;
    }
    
    private Flight mapResultSetToFlight(ResultSet rs) throws SQLException {
        Flight flight = new Flight();
        flight.setFlightId(rs.getInt("flight_id"));
        flight.setAirline(rs.getString("airline"));
        flight.setFlightNumber(rs.getString("flight_number"));
        flight.setOrigin(rs.getString("origin"));
        flight.setDestination(rs.getString("destination"));
        flight.setDepartureTime(rs.getTimestamp("departure_time"));
        flight.setArrivalTime(rs.getTimestamp("arrival_time"));
        flight.setDuration(rs.getTime("duration"));
        flight.setPrice(rs.getBigDecimal("price"));
        flight.setAvailableSeats(rs.getInt("available_seats"));
        
        String statusStr = rs.getString("status");
        if (statusStr != null) {
            try {
                flight.setStatus(Flight.FlightStatus.valueOf(statusStr));
            } catch (IllegalArgumentException e) {
                flight.setStatus(Flight.FlightStatus.SCHEDULED);
            }
        }
        
        flight.setCreatedAt(rs.getTimestamp("created_at"));
        flight.setUpdatedAt(rs.getTimestamp("updated_at"));
        return flight;
    }

    /**
     * Lấy tất cả các điểm khởi hành
     * 
     * @return Danh sách các địa điểm khởi hành
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Location> getAllOrigins() throws SQLException {
        String sql = "SELECT DISTINCT o.* FROM flight f " +
                     "JOIN location o ON f.origin = o.location_id " +
                     "ORDER BY o.name";
        List<Location> origins = new ArrayList<>();
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                origins.add(getLocationFromResultSet(resultSet, ""));
            }
            
            return origins;
        } catch (SQLException e) {
            Logger.getLogger(FlightDAO.class.getName()).log(Level.SEVERE, 
                    "Error getting all origins: " + e.getMessage(), e);
            throw e;
        } finally {
            closeResources();
        }
    }

    /**
     * Lấy tất cả các điểm đến
     * 
     * @return Danh sách các địa điểm đến
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Location> getAllDestinations() throws SQLException {
        String sql = "SELECT DISTINCT d.* FROM flight f " +
                     "JOIN location d ON f.destination = d.location_id " +
                     "ORDER BY d.name";
        List<Location> destinations = new ArrayList<>();
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                destinations.add(getLocationFromResultSet(resultSet, ""));
            }
            
            return destinations;
        } catch (SQLException e) {
            Logger.getLogger(FlightDAO.class.getName()).log(Level.SEVERE, 
                    "Error getting all destinations: " + e.getMessage(), e);
            throw e;
        } finally {
            closeResources();
        }
    }

    /**
     * Chuyển đổi ResultSet thành đối tượng Location
     * 
     * @param rs ResultSet chứa dữ liệu
     * @param prefix Tiền tố cho tên cột (nếu có)
     * @return Đối tượng Location
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    private Location getLocationFromResultSet(ResultSet rs, String prefix) throws SQLException {
        String idColumn = prefix.isEmpty() ? "location_id" : prefix + "_id";
        String nameColumn = prefix.isEmpty() ? "name" : prefix + "_name";
        String cityColumn = prefix.isEmpty() ? "city" : prefix + "_city";
        String countryColumn = prefix.isEmpty() ? "country" : prefix + "_country";
        String airportCodeColumn = prefix.isEmpty() ? "airport_code" : prefix + "_airport_code";
        String descriptionColumn = prefix.isEmpty() ? "description" : prefix + "_description";
        
        return Location.builder()
                .locationId(rs.getString(idColumn))
                .name(rs.getString(nameColumn))
                .city(rs.getString(cityColumn))
                .country(rs.getString(countryColumn))
                .airportCode(rs.getString(airportCodeColumn))
                .description(rs.getString(descriptionColumn))
                .build();
    }

    /**
     * Lấy danh sách các chuyến bay có sẵn
     * @return Danh sách các chuyến bay có sẵn
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Flight> findAvailableFlights() throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flight WHERE (status = 'SCHEDULED' OR status = 'ON_TIME') " +
                    "AND available_seats > 0 AND departure_time > NOW() ORDER BY departure_time";
        
        try {
            // Đảm bảo kết nối được mở mới
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                flights.add(mapResultSetToFlight(resultSet));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return flights;
    }

    /**
     * Tìm kiếm chuyến bay theo điều kiện
     * @param origin Điểm khởi hành
     * @param destination Điểm đến
     * @param departureDate Ngày khởi hành
     * @return Danh sách các chuyến bay thỏa mãn điều kiện
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Flight> searchFlights(String origin, String destination, java.sql.Date departureDate) throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flight WHERE origin = ? AND destination = ? " +
                    "AND DATE(departure_time) = ? AND (status = 'SCHEDULED' OR status = 'ON_TIME') " +
                    "AND available_seats > 0 ORDER BY departure_time";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, origin);
            statement.setString(2, destination);
            statement.setDate(3, departureDate);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                flights.add(mapResultSetToFlight(resultSet));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return flights;
    }
} 