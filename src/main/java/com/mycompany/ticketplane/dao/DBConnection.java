package com.mycompany.ticketplane.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static final String PROPERTIES_FILE = "/db.properties";
    private static Properties properties = new Properties();
    
    static {
        try (InputStream inputStream = DBConnection.class.getResourceAsStream(PROPERTIES_FILE)) {
            properties.load(inputStream);
            Class.forName(properties.getProperty("driver"));
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException("Failed to load database properties", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
            properties.getProperty("url"),
            properties.getProperty("username"),
            properties.getProperty("password")
        );
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
} 