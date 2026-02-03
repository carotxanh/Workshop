package com.mycompany.ticketplane.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    protected Connection connection;
    protected ResultSet resultSet;
    protected PreparedStatement statement;

    public DBConnection() {
        // Không tạo kết nối trong constructor
    }

    /**
     * Lấy kết nối mới đến cơ sở dữ liệu
     *
     * @return Kết nối đến cơ sở dữ liệu
     */
    public Connection getConnection() {
        try {
            String username = "root"; // Thay đổi theo cấu hình của bạn
            String password = "123456789"; // Thay đổi theo cấu hình của bạn
            String url = "jdbc:mysql://localhost:3306/ticketplane_2"; // Thay đổi theo cấu hình của bạn
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    /**
     * Đóng tất cả các tài nguyên cơ sở dữ liệu
     */
    public void closeResources() {
        try {
            if (resultSet != null && !resultSet.isClosed()) {
                resultSet.close();
            }
            if (statement != null && !statement.isClosed()) {
                statement.close();
            }
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static void main(String[] args) {
        System.out.println(new DBConnection().connection);
    }
}
