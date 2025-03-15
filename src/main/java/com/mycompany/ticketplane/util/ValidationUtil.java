package com.mycompany.ticketplane.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10,15}$");
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$");
    
    /**
     * Kiểm tra email hợp lệ
     * @param email Email cần kiểm tra
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
    
    /**
     * Kiểm tra số điện thoại hợp lệ
     * @param phone Số điện thoại cần kiểm tra
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone).matches();
    }
    
    /**
     * Kiểm tra mật khẩu hợp lệ
     * Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt
     * @param password Mật khẩu cần kiểm tra
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        return PASSWORD_PATTERN.matcher(password).matches();
    }
    
    /**
     * Kiểm tra tên hợp lệ
     * @param name Tên cần kiểm tra
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public static boolean isValidName(String name) {
        return name != null && !name.trim().isEmpty() && name.length() >= 2 && name.length() <= 100;
    }
    
    /**
     * Kiểm tra chuỗi không rỗng
     * @param str Chuỗi cần kiểm tra
     * @return true nếu không rỗng, false nếu rỗng
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
    
    /**
     * Kiểm tra số hợp lệ
     * @param str Chuỗi cần kiểm tra
     * @return true nếu là số hợp lệ, false nếu không phải số
     */
    public static boolean isValidNumber(String str) {
        if (str == null || str.trim().isEmpty()) {
            return false;
        }
        try {
            Double.parseDouble(str);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * Kiểm tra số nguyên dương
     * @param str Chuỗi cần kiểm tra
     * @return true nếu là số nguyên dương, false nếu không phải
     */
    public static boolean isPositiveInteger(String str) {
        if (str == null || str.trim().isEmpty()) {
            return false;
        }
        try {
            int value = Integer.parseInt(str);
            return value > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
} 