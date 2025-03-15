package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Payment;
import com.mycompany.ticketplane.model.Payment.PaymentStatus;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    
    public Payment findById(int paymentId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE payment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, paymentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        }
        
        return null;
    }
    
    public List<Payment> findByBookingId(int bookingId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE booking_id = ? ORDER BY payment_date DESC";
        List<Payment> payments = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        }
        
        return payments;
    }
    
    public boolean insert(Payment payment) throws SQLException {
        String sql = "INSERT INTO Payment (booking_id, amount, payment_date, payment_method, status, " +
                "card_number, card_name, transaction_id, refund_for, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, payment.getBookingId());
            stmt.setBigDecimal(2, payment.getAmount());
            stmt.setTimestamp(3, new Timestamp(payment.getPaymentDate().getTime()));
            stmt.setString(4, payment.getPaymentMethod());
            stmt.setString(5, payment.getStatus().toString());
            stmt.setString(6, payment.getCardNumber());
            stmt.setString(7, payment.getCardName());
            stmt.setString(8, payment.getTransactionId());
            
            if (payment.getRefundFor() != null) {
                stmt.setInt(9, payment.getRefundFor());
            } else {
                stmt.setNull(9, Types.INTEGER);
            }
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        payment.setPaymentId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
    
    public boolean update(Payment payment) throws SQLException {
        String sql = "UPDATE Payment SET booking_id = ?, amount = ?, payment_date = ?, " +
                "payment_method = ?, status = ?, card_number = ?, card_name = ?, " +
                "transaction_id = ?, refund_for = ?, updated_at = NOW() " +
                "WHERE payment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, payment.getBookingId());
            stmt.setBigDecimal(2, payment.getAmount());
            stmt.setTimestamp(3, new Timestamp(payment.getPaymentDate().getTime()));
            stmt.setString(4, payment.getPaymentMethod());
            stmt.setString(5, payment.getStatus().toString());
            stmt.setString(6, payment.getCardNumber());
            stmt.setString(7, payment.getCardName());
            stmt.setString(8, payment.getTransactionId());
            
            if (payment.getRefundFor() != null) {
                stmt.setInt(9, payment.getRefundFor());
            } else {
                stmt.setNull(9, Types.INTEGER);
            }
            
            stmt.setInt(10, payment.getPaymentId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setBookingId(rs.getInt("booking_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setStatus(PaymentStatus.valueOf(rs.getString("status")));
        payment.setCardNumber(rs.getString("card_number"));
        payment.setCardName(rs.getString("card_name"));
        payment.setTransactionId(rs.getString("transaction_id"));
        
        int refundFor = rs.getInt("refund_for");
        if (!rs.wasNull()) {
            payment.setRefundFor(refundFor);
        }
        
        payment.setCreatedAt(rs.getTimestamp("created_at"));
        payment.setUpdatedAt(rs.getTimestamp("updated_at"));
        return payment;
    }
} 