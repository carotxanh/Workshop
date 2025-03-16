package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.model.User.UserRole;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO extends DBConnection {

    public User findById(int userId) {
        User user = null;
        String sql = "SELECT * FROM User WHERE user_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                user = mapResultSetToUser(resultSet);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return user;
    }

    /**
     * Tìm người dùng theo email
     * @param email Email cần tìm
     * @return Đối tượng User nếu tìm thấy, null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public User findByEmail(String email) throws SQLException {
        User user = null;
        String sql = "SELECT * FROM user WHERE email = ?";
        
        try {
            // Đảm bảo kết nối được mở mới
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                user = mapResultSetToUser(resultSet);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return user;
    }

    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM User";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return users;
    }

    /**
     * Inserts a new user into the database
     * 
     * @param user The user to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insert(User user) throws SQLException {
        String sql = "INSERT INTO user (name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getRole().toString());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows > 0) {
                // Get the generated ID if needed for future use
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    user.setUserId(resultSet.getInt(1));
                }
                return true;
            }
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean update(User user) {
        String sql = "UPDATE User SET name = ?, email = ?, password = ?, phone = ?, role = ? WHERE user_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getRole().name());
            statement.setInt(6, user.getUserId());

            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean delete(int userId) {
        String sql = "DELETE FROM User WHERE user_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return false;
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM User WHERE email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return false;
    }

    public int getTotalUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM User";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return count;
    }

    public int getNewUserCountByMonth(int month, int year) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM User WHERE MONTH(created_at) = ? AND YEAR(created_at) = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, month);
            statement.setInt(2, year);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return count;
    }

    public int getUserCountByRole(String role) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM User WHERE role = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, role);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return count;
    }

    public List<User> getRecentUsers(int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM User ORDER BY created_at DESC LIMIT ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, limit);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return users;
    }

    /**
     * Chuyển đổi ResultSet thành đối tượng User
     * @param rs ResultSet chứa dữ liệu người dùng
     * @return Đối tượng User
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setRole(User.UserRole.valueOf(rs.getString("role")));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }

    /**
     * Checks if a user with the given email already exists
     * 
     * @param email The email to check
     * @return true if the email exists, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user WHERE email = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
            
            return false;
        } finally {
            closeResources();
        }
    }
}
