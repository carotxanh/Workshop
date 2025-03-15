package com.mycompany.ticketplane.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    
    private static final int SALT_LENGTH = 16;
    
    /**
     * Mã hóa mật khẩu với salt ngẫu nhiên
     * @param password Mật khẩu cần mã hóa
     * @return Chuỗi mã hóa dạng: salt:hash
     */
    public static String hashPassword(String password) {
        try {
            // Tạo salt ngẫu nhiên
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Mã hóa mật khẩu với salt
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Chuyển salt và hash thành chuỗi Base64
            String saltStr = Base64.getEncoder().encodeToString(salt);
            String hashStr = Base64.getEncoder().encodeToString(hashedPassword);
            
            // Trả về dạng salt:hash
            return saltStr + ":" + hashStr;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi khi mã hóa mật khẩu", e);
        }
    }
    
    /**
     * Kiểm tra mật khẩu có khớp với chuỗi đã mã hóa không
     * @param password Mật khẩu cần kiểm tra
     * @param storedPassword Chuỗi mã hóa đã lưu (dạng salt:hash)
     * @return true nếu mật khẩu khớp, false nếu không khớp
     */
    public static boolean verifyPassword(String password, String storedPassword) {
        try {
            // Tách salt và hash từ chuỗi đã lưu
            String[] parts = storedPassword.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            String saltStr = parts[0];
            String hashStr = parts[1];
            
            // Chuyển salt và hash từ chuỗi Base64 thành byte[]
            byte[] salt = Base64.getDecoder().decode(saltStr);
            byte[] hash = Base64.getDecoder().decode(hashStr);
            
            // Mã hóa mật khẩu cần kiểm tra với salt đã lưu
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // So sánh hash
            if (hash.length != hashedPassword.length) {
                return false;
            }
            
            for (int i = 0; i < hash.length; i++) {
                if (hash[i] != hashedPassword[i]) {
                    return false;
                }
            }
            
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Tạo mật khẩu ngẫu nhiên
     * @param length Độ dài mật khẩu
     * @return Mật khẩu ngẫu nhiên
     */
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            int randomIndex = random.nextInt(chars.length());
            sb.append(chars.charAt(randomIndex));
        }
        
        return sb.toString();
    }
} 