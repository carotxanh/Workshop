package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.SeatDAO;
import com.mycompany.ticketplane.model.Seat;
import com.mycompany.ticketplane.model.Seat.SeatClass;
import com.mycompany.ticketplane.model.Seat.SeatStatus;

import java.sql.SQLException;
import java.util.List;

public class SeatService {
    
    private SeatDAO seatDAO;
    
    public SeatService() {
        this.seatDAO = new SeatDAO();
    }
    
    public Seat findById(int seatId) throws SQLException {
        return seatDAO.findById(seatId);
    }
    
    public List<Seat> findByFlightId(int flightId) throws SQLException {
        return seatDAO.findByFlightId(flightId);
    }
    
    public List<Seat> findAvailableSeatsByFlightId(int flightId) throws SQLException {
        return seatDAO.findByFlightIdAndStatus(flightId, SeatStatus.AVAILABLE);
    }
    
    public Seat findBySeatNumber(int flightId, String seatNumber) throws SQLException {
        return seatDAO.findBySeatNumber(flightId, seatNumber);
    }
    
    public boolean updateSeatStatus(int flightId, String seatNumber, SeatStatus status) throws SQLException {
        return seatDAO.updateSeatStatus(flightId, seatNumber, status);
    }
    
    public boolean addSeat(int flightId, String seatNumber, SeatClass seatClass) throws SQLException {
        Seat seat = new Seat();
        seat.setFlightId(flightId);
        seat.setSeatNumber(seatNumber);
        seat.setSeatClass(seatClass);
        seat.setStatus(SeatStatus.AVAILABLE);
        
        return seatDAO.insert(seat);
    }
    
    public boolean deleteSeat(int seatId) throws SQLException {
        return seatDAO.delete(seatId);
    }
} 