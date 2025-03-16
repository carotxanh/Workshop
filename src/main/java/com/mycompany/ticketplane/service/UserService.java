package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.UserDAO;
import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.model.User.UserRole;
import com.mycompany.ticketplane.util.PasswordUtil;

import java.sql.SQLException;
import java.util.List;

public class UserService {

    private UserDAO userDAO;
    private PasswordUtil passwordUtil;

    public UserService() {
        this.userDAO = new UserDAO();
        this.passwordUtil = new PasswordUtil();
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
        if (userDAO.checkEmailExists(email)) {
            return false;
        }
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(passwordUtil.hashPassword(password));
        user.setPhone(phone);
        user.setRole(UserRole.USER);
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

    public int getTotalUsers() throws SQLException {
        return userDAO.getTotalUsers();
    }

    public User authenticate(String email, String password) throws SQLException {
        User user = userDAO.findByEmail(email);
        if (user != null && passwordUtil.checkPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public boolean updateProfile(User user, String currentPassword, String newPassword) throws SQLException {
        User existingUser = userDAO.findById(user.getUserId());
        if (existingUser != null && PasswordUtil.verifyPassword(currentPassword, existingUser.getPassword())) {
            if (newPassword != null && !newPassword.isEmpty()) {
                user.setPassword(PasswordUtil.hashPassword(newPassword));
            } else {
                user.setPassword(existingUser.getPassword());
            }
            return userDAO.update(user);
        }
        return false;
    }

    /**
     * Lấy số lượng người dùng mới theo tháng và năm
     *
     * @param month Tháng (1-12)
     * @param year Năm
     * @return Số lượng người dùng mới trong tháng
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getNewUserCountByMonth(int month, int year) throws SQLException {
        return userDAO.getNewUserCountByMonth(month, year);
    }

    /**
     * Lấy số lượng người dùng theo vai trò
     *
     * @param role Vai trò người dùng
     * @return Số lượng người dùng theo vai trò
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getUserCountByRole(String role) throws SQLException {
        return userDAO.getUserCountByRole(role);
    }

    /**
     * Lấy danh sách người dùng mới nhất
     *
     * @param limit Số lượng người dùng cần lấy
     * @return Danh sách người dùng mới nhất
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<User> getRecentUsers(int limit) throws SQLException {
        return userDAO.getRecentUsers(limit);
    }

    public List<User> getAllUsers() throws SQLException {
        return userDAO.findAll();
    }

    public User getUserById(int userId) throws SQLException {
        return userDAO.findById(userId);
    }

    public boolean createUser(User user) throws SQLException {
        // Hash the password before storing
        user.setPassword(passwordUtil.hashPassword(user.getPassword()));
        // Call the insert method that returns a boolean
        return userDAO.insert(user);
    }

    public boolean updateUser(User user) throws SQLException {
        // If the password is already hashed (from existing user), don't hash it again
        User existingUser = userDAO.findById(user.getUserId());
        if (existingUser != null) {
            // Only hash the password if it's different from the existing one
            if (!user.getPassword().equals(existingUser.getPassword())) {
                user.setPassword(passwordUtil.hashPassword(user.getPassword()));
            }
            return userDAO.update(user);
        }
        return false;
    }

    /**
     * Checks if a user with the given email already exists
     *
     * @param email The email to check
     * @return true if the email exists, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean isEmailExists(String email) throws SQLException {
        return userDAO.isEmailExists(email);
    }
}
