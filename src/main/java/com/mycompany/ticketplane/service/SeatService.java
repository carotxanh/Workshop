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
    
    public List<Seat> getAvailableSeats(int flightId) throws SQLException {
        return seatDAO.findAvailableSeatsByFlightId(flightId);
    }
    
    public boolean initializeSeatsForFlight(int flightId, int economySeats, int businessSeats, int firstClassSeats) throws SQLException {
        return seatDAO.insertSeatsForFlight(flightId, economySeats, businessSeats, firstClassSeats);
    }
    
    public List<Seat> getSeatsByFlightId(int flightId) throws SQLException {
        return seatDAO.findByFlightId(flightId);
    }
    
    /**
     * Lấy danh sách ghế ngồi theo chuyến bay và hạng ghế
     * 
     * @param flightId ID của chuyến bay
     * @param seatClass Hạng ghế (ECONOMY, BUSINESS, FIRST)
     * @return Danh sách ghế ngồi
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Seat> getSeatsByFlightAndClass(int flightId, String seatClass) throws SQLException {
        return seatDAO.findByFlightAndClass(flightId, seatClass);
    }
    
    /**
     * Cập nhật trạng thái ghế
     * 
     * @param seatId ID của ghế
     * @param status Trạng thái mới (AVAILABLE, BOOKED, RESERVED)
     * @return true nếu cập nhật thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean updateSeatStatus(int seatId, String status) throws SQLException {
        return seatDAO.updateStatus(seatId, status);
    }
    
    /**
     * Cập nhật trạng thái ghế dựa trên ID chuyến bay và số ghế
     * 
     * @param flightId ID của chuyến bay
     * @param seatNumber Số ghế
     * @param status Trạng thái mới của ghế
     * @return true nếu cập nhật thành công, false nếu không
     * @throws SQLException nếu có lỗi SQL
     */
    public boolean updateSeatStatusByFlightAndSeatNumber(Integer flightId, String seatNumber, String status) throws SQLException {
        return seatDAO.updateSeatStatusByFlightAndSeatNumber(flightId, seatNumber, status);
    }
} 