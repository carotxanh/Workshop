package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.UserDAO;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.model.User.UserRole;
import com.mycompany.ticketplane.util.PasswordUtil;

import java.sql.SQLException;
import java.util.List;

public class UserService {
    
    private UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    public User findById(int userId) throws SQLException {
        return userDAO.findById(userId);
    }
    
    public List<User> findAll() throws SQLException {
        return userDAO.findAll();
    }
    
    public User login(String email, String password) throws SQLException {
        User user = userDAO.findByEmail(email);
        
        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        
        return null;
    }
    
    public boolean register(String name, String email, String password, String phone) throws SQLException {
        // Kiểm tra email đã tồn tại chưa
        if (userDAO.findByEmail(email) != null) {
            return false;
        }
        
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setPhone(phone);
        user.setRole(UserRole.CUSTOMER);
        
        return userDAO.insert(user);
    }
    
    public boolean updateProfile(int userId, String name, String email, String phone) throws SQLException {
        User user = userDAO.findById(userId);
        
        if (user == null) {
            return false;
        }
        
        // Kiểm tra email đã tồn tại chưa (nếu thay đổi email)
        if (!user.getEmail().equals(email)) {
            User existingUser = userDAO.findByEmail(email);
            if (existingUser != null) {
                return false;
            }
        }
        
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);
        
        return userDAO.update(user);
    }
    
    public boolean changePassword(int userId, String oldPassword, String newPassword) throws SQLException {
        User user = userDAO.findById(userId);
        
        if (user == null || !PasswordUtil.verifyPassword(oldPassword, user.getPassword())) {
            return false;
        }
        
        user.setPassword(PasswordUtil.hashPassword(newPassword));
        
        return userDAO.update(user);
    }
    
    public boolean resetPassword(String email, String newPassword) throws SQLException {
        User user = userDAO.findByEmail(email);
        
        if (user == null) {
            return false;
        }
        
        user.setPassword(PasswordUtil.hashPassword(newPassword));
        
        return userDAO.update(user);
    }
    
    public boolean deleteUser(int userId) throws SQLException {
        return userDAO.delete(userId);
    }
} 