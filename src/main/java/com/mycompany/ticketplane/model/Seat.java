package com.mycompany.ticketplane.model;

import java.math.BigDecimal;

public class Seat {
    private Integer seatId;
    private Integer flightId;
    private String seatNumber;
    private SeatClass seatClass;
    private BigDecimal price;
    private SeatStatus status;
    
    public enum SeatClass {
        ECONOMY, BUSINESS, FIRST
    }
    
    public enum SeatStatus {
        AVAILABLE, BOOKED, RESERVED
    }
    
    // Constructors
    public Seat() {}
    
    public Seat(Integer seatId, Integer flightId, String seatNumber, SeatClass seatClass, BigDecimal price, SeatStatus status) {
        this.seatId = seatId;
        this.flightId = flightId;
        this.seatNumber = seatNumber;
        this.seatClass = seatClass;
        this.price = price;
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
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public SeatStatus getStatus() {
        return status;
    }
    
    public void setStatus(SeatStatus status) {
        this.status = status;
    }
    
    @Override
    public String toString() {
        return "Seat{" +
                "seatId=" + seatId +
                ", flightId=" + flightId +
                ", seatNumber='" + seatNumber + '\'' +
                ", seatClass=" + seatClass +
                ", price=" + price +
                ", status=" + status +
                '}';
    }
} 