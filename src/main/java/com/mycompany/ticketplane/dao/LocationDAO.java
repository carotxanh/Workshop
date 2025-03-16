package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Location;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LocationDAO extends DBConnection {
    
    private static final Logger LOGGER = Logger.getLogger(LocationDAO.class.getName());
    
    /**
     * Lấy tất cả các địa điểm
     * 
     * @return Danh sách các địa điểm
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Location> findAll() throws SQLException {
        String sql = "SELECT * FROM location ORDER BY name";
        List<Location> locations = new ArrayList<>();
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                locations.add(getFromResultSet(resultSet));
            }
            
            return locations;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all locations", e);
            throw e;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Tìm địa điểm theo ID
     * 
     * @param id ID của địa điểm cần tìm
     * @return Địa điểm nếu tìm thấy, null nếu không
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Location findById(String id) throws SQLException {
        String sql = "SELECT * FROM location WHERE location_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, id);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
            
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding location by ID: " + id, e);
            throw e;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Tìm địa điểm theo tên
     * 
     * @param name Tên của địa điểm
     * @return Địa điểm tìm thấy hoặc null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Location findByName(String name) throws SQLException {
        Location location = null;
        String sql = "SELECT * FROM location WHERE name = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                location = getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding location by name: " + name, e);
            throw e;
        } finally {
            closeResources();
        }
        
        return location;
    }
    
    /**
     * Thêm địa điểm mới
     * 
     * @param location Địa điểm cần thêm
     * @return ID của địa điểm mới thêm, -1 nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int insert(Location location) throws SQLException {
        String sql = "INSERT INTO location (location_id, name, city, country, airport_code, description) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, location.getLocationId());
            statement.setString(2, location.getName());
            statement.setString(3, location.getCity());
            statement.setString(4, location.getCountry());
            statement.setString(5, location.getAirportCode());
            statement.setString(6, location.getDescription());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating location failed, no rows affected.");
            }
            
            return 1; // Vì location_id là tự đặt, không phải auto-increment
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting location: " + location.getName(), e);
            throw e;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Cập nhật thông tin địa điểm
     * 
     * @param location Địa điểm cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean update(Location location) throws SQLException {
        String sql = "UPDATE location SET name = ?, city = ?, country = ?, airport_code = ?, description = ? WHERE location_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, location.getName());
            statement.setString(2, location.getCity());
            statement.setString(3, location.getCountry());
            statement.setString(4, location.getAirportCode());
            statement.setString(5, location.getDescription());
            statement.setString(6, location.getLocationId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating location: " + location.getLocationId(), e);
            throw e;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Xóa địa điểm
     * 
     * @param id ID của địa điểm cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean delete(String id) throws SQLException {
        String sql = "DELETE FROM location WHERE location_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, id);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting location: " + id, e);
            throw e;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Chuyển đổi ResultSet thành đối tượng Location
     * 
     * @param rs ResultSet chứa dữ liệu
     * @return Đối tượng Location
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Location getFromResultSet(ResultSet rs) throws SQLException {
        return Location.builder()
            .locationId(rs.getString("location_id"))
            .name(rs.getString("name"))
            .city(rs.getString("city"))
            .country(rs.getString("country"))
            .airportCode(rs.getString("airport_code"))
            .description(rs.getString("description"))
            .build();
    }
} 