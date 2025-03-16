package com.mycompany.ticketplane.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Date;

public class Booking {
    private Integer bookingId;
    private Integer userId;
    private Integer flightId;
    private Date bookingDate;
    private String seatNumber;
    private BookingStatus status;
    private BigDecimal totalPrice;
    private String passengerName;
    private String passengerEmail;
    private String passengerPhone;
    private String paymentMethod;
    private String paymentStatus;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Thêm các đối tượng liên quan để tiện sử dụng
    private User user;
    private Flight flight;
    
    public enum BookingStatus {
        CONFIRMED, CANCELLED, PENDING, COMPLETED
    }
    
    // Constructors
    public Booking() {}
    
    public Booking(Integer bookingId, Integer userId, Integer flightId, Date bookingDate, 
                  String seatNumber, BookingStatus status, BigDecimal totalPrice) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.flightId = flightId;
        this.bookingDate = bookingDate;
        this.seatNumber = seatNumber;
        this.status = status;
        this.totalPrice = totalPrice;
    }
    
    // Getters and Setters
    public Integer getBookingId() {
        return bookingId;
    }
    
    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public Integer getFlightId() {
        return flightId;
    }
    
    public void setFlightId(Integer flightId) {
        this.flightId = flightId;
    }
    
    public Date getBookingDate() {
        return bookingDate;
    }
    
    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }
    
    public String getSeatNumber() {
        return seatNumber;
    }
    
    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }
    
    public BookingStatus getStatus() {
        return status;
    }
    
    public void setStatus(BookingStatus status) {
        this.status = status;
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public Flight getFlight() {
        return flight;
    }
    
    public void setFlight(Flight flight) {
        this.flight = flight;
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
    
    public String getPassengerName() {
        return passengerName;
    }
    
    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }
    
    public String getPassengerEmail() {
        return passengerEmail;
    }
    
    public void setPassengerEmail(String passengerEmail) {
        this.passengerEmail = passengerEmail;
    }
    
    public String getPassengerPhone() {
        return passengerPhone;
    }
    
    public void setPassengerPhone(String passengerPhone) {
        this.passengerPhone = passengerPhone;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    @Override
    public String toString() {
        return "Booking{" +
                "bookingId=" + bookingId +
                ", userId=" + userId +
                ", flightId=" + flightId +
                ", bookingDate=" + bookingDate +
                ", seatNumber='" + seatNumber + '\'' +
                ", status=" + status +
                ", totalPrice=" + totalPrice +
                '}';
    }
} 