package com.mycompany.ticketplane.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class EmailUtil {
    
    private static final String CONFIG_FILE = "/mail.properties";
    private static Properties mailProperties = new Properties();
    
    static {
        try (InputStream inputStream = EmailUtil.class.getResourceAsStream(CONFIG_FILE)) {
            mailProperties.load(inputStream);
        } catch (IOException e) {
            System.err.println("Không thể tải cấu hình email: " + e.getMessage());
        }
    }
    
    /**
     * Gửi email
     * @param to Địa chỉ email người nhận
     * @param subject Tiêu đề email
     * @param content Nội dung email (HTML)
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public static boolean sendEmail(String to, String subject, String content) {
        try {
            // Cấu hình session
            Session session = Session.getInstance(mailProperties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(
                            mailProperties.getProperty("mail.smtp.user"),
                            mailProperties.getProperty("mail.smtp.password")
                    );
                }
            });
            
            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(mailProperties.getProperty("mail.smtp.user")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=utf-8");
            
            // Gửi email
            Transport.send(message);
            
            return true;
        } catch (MessagingException e) {
            System.err.println("Lỗi khi gửi email: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Đọc template email từ file
     * @param templateName Tên file template
     * @return Nội dung template
     */
    public static String readEmailTemplate(String templateName) {
        try (InputStream inputStream = EmailUtil.class.getResourceAsStream("/mail-templates/" + templateName)) {
            if (inputStream == null) {
                throw new IOException("Không tìm thấy template: " + templateName);
            }
            
            byte[] bytes = inputStream.readAllBytes();
            return new String(bytes, StandardCharsets.UTF_8);
        } catch (IOException e) {
            System.err.println("Lỗi khi đọc template email: " + e.getMessage());
            return "";
        }
    }
    
    /**
     * Thay thế các placeholder trong template
     * @param template Template cần thay thế
     * @param placeholders Mảng các placeholder và giá trị thay thế (placeholder1, value1, placeholder2, value2, ...)
     * @return Template sau khi thay thế
     */
    public static String replacePlaceholders(String template, String... placeholders) {
        if (placeholders.length % 2 != 0) {
            throw new IllegalArgumentException("Số lượng placeholder và giá trị thay thế không khớp");
        }
        
        String result = template;
        for (int i = 0; i < placeholders.length; i += 2) {
            result = result.replace("{{" + placeholders[i] + "}}", placeholders[i + 1]);
        }
        
        return result;
    }
    
    /**
     * Gửi email xác nhận đặt vé
     * @param to Email người nhận
     * @param name Tên người nhận
     * @param bookingId Mã đặt vé
     * @param flightNumber Số hiệu chuyến bay
     * @param origin Điểm khởi hành
     * @param destination Điểm đến
     * @param departureTime Thời gian khởi hành
     * @param seatNumber Số ghế
     * @param totalPrice Tổng tiền
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public static boolean sendBookingConfirmationEmail(String to, String name, String bookingId, 
                                                     String flightNumber, String origin, String destination, 
                                                     String departureTime, String seatNumber, String totalPrice) {
        String template = readEmailTemplate("booking-confirmation.html");
        String content = replacePlaceholders(template,
                "name", name,
                "bookingId", bookingId,
                "flightNumber", flightNumber,
                "origin", origin,
                "destination", destination,
                "departureTime", departureTime,
                "seatNumber", seatNumber,
                "totalPrice", totalPrice
        );
        
        return sendEmail(to, "Xác nhận đặt vé máy bay", content);
    }
    
    /**
     * Gửi email xác nhận thanh toán
     * @param to Email người nhận
     * @param name Tên người nhận
     * @param bookingId Mã đặt vé
     * @param paymentId Mã thanh toán
     * @param amount Số tiền
     * @param paymentMethod Phương thức thanh toán
     * @param paymentDate Ngày thanh toán
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public static boolean sendPaymentConfirmationEmail(String to, String name, String bookingId, 
                                                     String paymentId, String amount, 
                                                     String paymentMethod, String paymentDate) {
        String template = readEmailTemplate("payment-confirmation.html");
        String content = replacePlaceholders(template,
                "name", name,
                "bookingId", bookingId,
                "paymentId", paymentId,
                "amount", amount,
                "paymentMethod", paymentMethod,
                "paymentDate", paymentDate
        );
        
        return sendEmail(to, "Xác nhận thanh toán vé máy bay", content);
    }
    
    /**
     * Gửi email nhắc nhở trước giờ bay
     * @param to Email người nhận
     * @param name Tên người nhận
     * @param flightNumber Số hiệu chuyến bay
     * @param origin Điểm khởi hành
     * @param destination Điểm đến
     * @param departureTime Thời gian khởi hành
     * @param checkInTime Thời gian check-in
     * @param gate Cổng
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public static boolean sendFlightReminderEmail(String to, String name, String flightNumber, 
                                                String origin, String destination, 
                                                String departureTime, String checkInTime, String gate) {
        String template = readEmailTemplate("flight-reminder.html");
        String content = replacePlaceholders(template,
                "name", name,
                "flightNumber", flightNumber,
                "origin", origin,
                "destination", destination,
                "departureTime", departureTime,
                "checkInTime", checkInTime,
                "gate", gate
        );
        
        return sendEmail(to, "Nhắc nhở chuyến bay sắp khởi hành", content);
    }
} 