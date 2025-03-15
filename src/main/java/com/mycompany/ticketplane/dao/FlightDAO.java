package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Flight.FlightStatus;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FlightDAO {
    private Connection connection = null;
    private PreparedStatement statement = null;
    private ResultSet resultSet = null;
    
    public Flight findById(int flightId) throws SQLException {
        String sql = "SELECT * FROM Flight WHERE flight_id = ?";
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, flightId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFlight(rs);
                }
            }
        }
        
        return null;
    }
    
    public List<Flight> findAll() {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flight";
        try {
            Connection conn = new DBConnection().getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                flights.add(mapResultSetToFlight(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return flights;
    }
    
    public List<Flight> searchFlights(String origin, String destination, Date departureDate) {
        List<Flight> flights = new ArrayList<>();
        String sql = "SELECT * FROM Flight WHERE origin = ? AND destination = ? " +
                    "AND DATE(departure_time) = ? AND status = 'SCHEDULED' " +
                    "AND available_seats > 0 ORDER BY departure_time";
        try {
            Connection conn = new DBConnection().getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, origin);
            statement.setString(2, destination);
            statement.setDate(3, new java.sql.Date(departureDate.getTime()));
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                flights.add(mapResultSetToFlight(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return flights;
    }
    
    public boolean insert(Flight flight) throws SQLException {
        String sql = "INSERT INTO Flight (airline, flight_number, origin, destination, departure_time, arrival_time, " +
                    "duration, price, available_seats, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, flight.getAirline());
            stmt.setString(2, flight.getFlightNumber());
            stmt.setString(3, flight.getOrigin());
            stmt.setString(4, flight.getDestination());
            stmt.setTimestamp(5, new Timestamp(flight.getDepartureTime().getTime()));
            stmt.setTimestamp(6, new Timestamp(flight.getArrivalTime().getTime()));
            stmt.setTime(7, flight.getDuration());
            stmt.setBigDecimal(8, flight.getPrice());
            stmt.setInt(9, flight.getAvailableSeats());
            stmt.setString(10, flight.getStatus().toString());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    flight.setFlightId(generatedKeys.getInt(1));
                    return true;
                } else {
                    return false;
                }
            }
        }
    }
    
    public boolean update(Flight flight) throws SQLException {
        String sql = "UPDATE Flight SET airline = ?, flight_number = ?, origin = ?, destination = ?, " +
                    "departure_time = ?, arrival_time = ?, duration = ?, price = ?, available_seats = ?, " +
                    "status = ? WHERE flight_id = ?";
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, flight.getAirline());
            stmt.setString(2, flight.getFlightNumber());
            stmt.setString(3, flight.getOrigin());
            stmt.setString(4, flight.getDestination());
            stmt.setTimestamp(5, new Timestamp(flight.getDepartureTime().getTime()));
            stmt.setTimestamp(6, new Timestamp(flight.getArrivalTime().getTime()));
            stmt.setTime(7, flight.getDuration());
            stmt.setBigDecimal(8, flight.getPrice());
            stmt.setInt(9, flight.getAvailableSeats());
            stmt.setString(10, flight.getStatus().toString());
            stmt.setInt(11, flight.getFlightId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean updateAvailableSeats(int flightId, int seats) throws SQLException {
        String sql = "UPDATE Flight SET available_seats = available_seats + ? WHERE flight_id = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, seats);
            stmt.setInt(2, flightId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean delete(int flightId) throws SQLException {
        String sql = "DELETE FROM Flight WHERE flight_id = ?";
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, flightId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public List<Flight> getUpcomingFlights() throws SQLException {
        String sql = "SELECT * FROM Flight WHERE departure_time > NOW() " +
                    "AND status = 'SCHEDULED' ORDER BY departure_time LIMIT 5";
        List<Flight> flights = new ArrayList<>();
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                flights.add(mapResultSetToFlight(rs));
            }
        }
        return flights;
    }
    
    public boolean updateStatus(int flightId, FlightStatus status) throws SQLException {
        String sql = "UPDATE Flight SET status = ? WHERE flight_id = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, flightId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public List<Flight> findByStatus(FlightStatus status) throws SQLException {
        String sql = "SELECT * FROM Flight WHERE status = ? ORDER BY departure_time";
        List<Flight> flights = new ArrayList<>();
        
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    flights.add(mapResultSetToFlight(rs));
                }
            }
        }
        return flights;
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
        flight.setStatus(FlightStatus.valueOf(rs.getString("status")));
        flight.setCreatedAt(rs.getTimestamp("created_at"));
        flight.setUpdatedAt(rs.getTimestamp("updated_at"));
        return flight;
    }
    
    private void closeResources() {
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }
} 