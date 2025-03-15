package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.FlightDAO;
import com.mycompany.ticketplane.dao.SeatDAO;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Flight.FlightStatus;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Time;
import java.util.Date;
import java.util.List;

public class FlightService {
    
    private FlightDAO flightDAO;
    private SeatDAO seatDAO;
    
    public FlightService() {
        this.flightDAO = new FlightDAO();
        this.seatDAO = new SeatDAO();
    }
    
    public Flight findById(int flightId) throws SQLException {
        return flightDAO.findById(flightId);
    }
    
    public List<Flight> findAll() throws SQLException {
        return flightDAO.findAll();
    }
    
    public List<Flight> searchFlights(String origin, String destination, Date departureDate) throws SQLException {
        return flightDAO.searchFlights(origin, destination, departureDate);
    }
    
    public boolean addFlight(String airline, String flightNumber, String origin, String destination,
                            Date departureTime, Date arrivalTime, Time duration, BigDecimal price,
                            int totalSeats, int economySeats, int businessSeats, int firstClassSeats) throws SQLException {
        
        Flight flight = new Flight();
        flight.setAirline(airline);
        flight.setFlightNumber(flightNumber);
        flight.setOrigin(origin);
        flight.setDestination(destination);
        flight.setDepartureTime(departureTime);
        flight.setArrivalTime(arrivalTime);
        flight.setDuration(duration);
        flight.setPrice(price);
        flight.setAvailableSeats(totalSeats);
        flight.setStatus(FlightStatus.ON_TIME);
        
        boolean flightAdded = flightDAO.insert(flight);
        
        if (flightAdded) {
            // Thêm ghế cho chuyến bay
            return seatDAO.insertSeatsForFlight(flight.getFlightId(), economySeats, businessSeats, firstClassSeats);
        }
        
        return false;
    }
    
    public boolean updateFlight(int flightId, String airline, String flightNumber, String origin, String destination,
                               Date departureTime, Date arrivalTime, Time duration, BigDecimal price,
                               int availableSeats, FlightStatus status) throws SQLException {
        
        Flight flight = flightDAO.findById(flightId);
        
        if (flight == null) {
            return false;
        }
        
        flight.setAirline(airline);
        flight.setFlightNumber(flightNumber);
        flight.setOrigin(origin);
        flight.setDestination(destination);
        flight.setDepartureTime(departureTime);
        flight.setArrivalTime(arrivalTime);
        flight.setDuration(duration);
        flight.setPrice(price);
        flight.setAvailableSeats(availableSeats);
        flight.setStatus(status);
        
        return flightDAO.update(flight);
    }
    
    public boolean updateFlightStatus(int flightId, FlightStatus status) throws SQLException {
        Flight flight = flightDAO.findById(flightId);
        
        if (flight == null) {
            return false;
        }
        
        flight.setStatus(status);
        
        return flightDAO.update(flight);
    }
    
    public boolean deleteFlight(int flightId) throws SQLException {
        return flightDAO.delete(flightId);
    }
} 