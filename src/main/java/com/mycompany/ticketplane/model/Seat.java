package com.mycompany.ticketplane.model;

import java.sql.Timestamp;

public class Seat {
    private Integer seatId;
    private Integer flightId;
    private String seatNumber;
    private SeatClass seatClass;
    private SeatStatus status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum SeatClass {
        ECONOMY, BUSINESS, FIRST_CLASS
    }
    
    public enum SeatStatus {
        AVAILABLE, BOOKED
    }
    
    // Constructors
    public Seat() {}
    
    public Seat(Integer seatId, Integer flightId, String seatNumber, SeatClass seatClass, SeatStatus status) {
        this.seatId = seatId;
        this.flightId = flightId;
        this.seatNumber = seatNumber;
        this.seatClass = seatClass;
        this.status = status;
    }
    
    // Getters and Setters
    public Integer getSeatId() {
        return seatId;
    }
    
    public void setSeatId(Integer seatId) {
        this.seatId = seatId;
    }
    
    public Integer getFlightId() {
        return flightId;
    }
    
    public void setFlightId(Integer flightId) {
        this.flightId = flightId;
    }
    
    public String getSeatNumber() {
        return seatNumber;
    }
    
    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }
    
    public SeatClass getSeatClass() {
        return seatClass;
    }
    
    public void setSeatClass(SeatClass seatClass) {
        this.seatClass = seatClass;
    }
    
    public SeatStatus getStatus() {
        return status;
    }
    
    public void setStatus(SeatStatus status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @Override
    public String toString() {
        return "Seat{" +
                "seatId=" + seatId +
                ", flightId=" + flightId +
                ", seatNumber='" + seatNumber + '\'' +
                ", seatClass=" + seatClass +
                ", status=" + status +
                '}';
    }
} 