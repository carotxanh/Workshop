package com.mycompany.ticketplane.dao;

import com.mycompany.ticketplane.model.Payment;
import com.mycompany.ticketplane.model.Payment.PaymentStatus;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PaymentDAO extends DBConnection {
    
    public Payment findById(int paymentId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE payment_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, paymentId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return mapResultSetToPayment(resultSet);
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return null;
    }
    
    public List<Payment> findByBookingId(int bookingId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE booking_id = ? ORDER BY payment_date DESC";
        List<Payment> payments = new ArrayList<>();
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, bookingId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                payments.add(mapResultSetToPayment(resultSet));
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return payments;
    }
    
    public boolean insert(Payment payment) throws SQLException {
        String sql = "INSERT INTO Payment (booking_id, amount, payment_date, payment_method, status, " +
                "card_number, card_name, transaction_id, refund_for, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            statement.setInt(1, payment.getBookingId());
            statement.setBigDecimal(2, payment.getAmount());
            statement.setTimestamp(3, new Timestamp(payment.getPaymentDate().getTime()));
            statement.setString(4, payment.getPaymentMethod());
            statement.setString(5, payment.getStatus().toString());
            statement.setString(6, payment.getCardNumber());
            statement.setString(7, payment.getCardName());
            statement.setString(8, payment.getTransactionId());
            
            if (payment.getRefundFor() != null) {
                statement.setInt(9, payment.getRefundFor());
            } else {
                statement.setNull(9, Types.INTEGER);
            }
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    payment.setPaymentId(resultSet.getInt(1));
                    return true;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
        }
        
        return false;
    }
    
    public boolean update(Payment payment) throws SQLException {
        String sql = "UPDATE Payment SET booking_id = ?, amount = ?, payment_date = ?, " +
                "payment_method = ?, status = ?, card_number = ?, card_name = ?, " +
                "transaction_id = ?, refund_for = ?, updated_at = NOW() " +
                "WHERE payment_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, payment.getBookingId());
            statement.setBigDecimal(2, payment.getAmount());
            statement.setTimestamp(3, new Timestamp(payment.getPaymentDate().getTime()));
            statement.setString(4, payment.getPaymentMethod());
            statement.setString(5, payment.getStatus().toString());
            statement.setString(6, payment.getCardNumber());
            statement.setString(7, payment.getCardName());
            statement.setString(8, payment.getTransactionId());
            
            if (payment.getRefundFor() != null) {
                statement.setInt(9, payment.getRefundFor());
            } else {
                statement.setNull(9, Types.INTEGER);
            }
            
            statement.setInt(10, payment.getPaymentId());
            
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        } finally {
            closeResources();
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