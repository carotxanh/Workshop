package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.PaymentDAO;
import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Payment;
import com.mycompany.ticketplane.model.Payment.PaymentStatus;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public class PaymentService {
    
    private PaymentDAO paymentDAO;
    
    public PaymentService() {
        this.paymentDAO = new PaymentDAO();
    }
    
    public Payment findById(int paymentId) throws SQLException {
        return paymentDAO.findById(paymentId);
    }
    
    public List<Payment> findByBookingId(int bookingId) throws SQLException {
        return paymentDAO.findByBookingId(bookingId);
    }
    
    /**
     * Xử lý thanh toán cho đặt vé
     * @param booking Thông tin đặt vé
     * @param cardNumber Số thẻ
     * @param cardName Tên chủ thẻ
     * @param expiryDate Ngày hết hạn
     * @param cvv Mã CVV
     * @return ID thanh toán nếu thành công, null nếu thất bại
     * @throws SQLException Lỗi SQL
     */
    public String processPayment(Booking booking, String cardNumber, String cardName, String expiryDate, String cvv) throws SQLException {
        // Trong thực tế, ở đây sẽ gọi API của cổng thanh toán
        // Trong demo này, chúng ta giả lập việc thanh toán luôn thành công
        
        // Tạo đối tượng Payment
        Payment payment = new Payment();
        payment.setBookingId(booking.getBookingId());
        payment.setAmount(booking.getTotalPrice());
        payment.setPaymentDate(new Date());
        payment.setPaymentMethod("CREDIT_CARD");
        payment.setStatus(PaymentStatus.COMPLETED);
        
        // Mã hóa thông tin thẻ (trong thực tế không nên lưu thông tin thẻ)
        String maskedCardNumber = "XXXX-XXXX-XXXX-" + cardNumber.substring(cardNumber.length() - 4);
        payment.setCardNumber(maskedCardNumber);
        payment.setCardName(cardName);
        
        // Tạo mã giao dịch
        String transactionId = UUID.randomUUID().toString();
        payment.setTransactionId(transactionId);
        
        // Lưu thông tin thanh toán
        boolean paymentCreated = paymentDAO.insert(payment);
        
        if (paymentCreated) {
            return transactionId;
        }
        
        return null;
    }
    
    /**
     * Hoàn tiền cho đặt vé
     * @param bookingId ID đặt vé
     * @return true nếu thành công, false nếu thất bại
     * @throws SQLException Lỗi SQL
     */
    public boolean refundPayment(int bookingId) throws SQLException {
        // Lấy thông tin thanh toán
        List<Payment> payments = paymentDAO.findByBookingId(bookingId);
        
        if (payments.isEmpty()) {
            return false;
        }
        
        // Lấy thanh toán gần nhất
        Payment payment = payments.get(0);
        
        // Tạo đối tượng Payment cho hoàn tiền
        Payment refund = new Payment();
        refund.setBookingId(bookingId);
        refund.setAmount(payment.getAmount().negate()); // Số tiền âm
        refund.setPaymentDate(new Date());
        refund.setPaymentMethod(payment.getPaymentMethod());
        refund.setStatus(PaymentStatus.REFUNDED);
        refund.setCardNumber(payment.getCardNumber());
        refund.setCardName(payment.getCardName());
        refund.setTransactionId(UUID.randomUUID().toString());
        refund.setRefundFor(payment.getPaymentId());
        
        // Lưu thông tin hoàn tiền
        return paymentDAO.insert(refund);
    }
} 