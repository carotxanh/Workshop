package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.LocationDAO;
import com.mycompany.ticketplane.model.Location;

import java.sql.SQLException;
import java.util.List;

public class LocationService {
    
    private LocationDAO locationDAO;
    
    public LocationService() {
        this.locationDAO = new LocationDAO();
    }
    
    /**
     * Lấy tất cả các địa điểm
     * 
     * @return Danh sách các địa điểm
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Location> getAllLocations() throws SQLException {
        return locationDAO.findAll();
    }
    
    /**
     * Tìm địa điểm theo ID
     * 
     * @param id ID của địa điểm
     * @return Địa điểm tìm thấy hoặc null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Location findById(String id) throws SQLException {
        return locationDAO.findById(id);
    }
    
    /**
     * Tìm địa điểm theo tên
     * 
     * @param name Tên của địa điểm
     * @return Địa điểm tìm thấy hoặc null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Location findByName(String name) throws SQLException {
        return locationDAO.findByName(name);
    }
    
    /**
     * Thêm địa điểm mới
     * 
     * @param location Địa điểm cần thêm
     * @return true nếu thêm thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean addLocation(Location location) throws SQLException {
        return locationDAO.insert(location) > 0;
    }
    
    /**
     * Cập nhật thông tin địa điểm
     * 
     * @param location Địa điểm cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean updateLocation(Location location) throws SQLException {
        return locationDAO.update(location);
    }
    
    /**
     * Xóa địa điểm
     * 
     * @param id ID của địa điểm cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean deleteLocation(String id) throws SQLException {
        return locationDAO.delete(id);
    }
} 