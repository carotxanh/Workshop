package com.mycompany.ticketplane.controller.auth;

import com.mycompany.ticketplane.service.UserService;
import com.mycompany.ticketplane.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        
        // Kiểm tra dữ liệu đầu vào
        boolean hasError = false;
        
        if (!ValidationUtil.isValidName(name)) {
            request.setAttribute("nameError", "Tên không hợp lệ");
            hasError = true;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("emailError", "Email không hợp lệ");
            hasError = true;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("passwordError", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
            hasError = true;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Mật khẩu xác nhận không khớp");
            hasError = true;
        }
        
        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Số điện thoại không hợp lệ");
            hasError = true;
        }
        
        if (hasError) {
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        try {
            boolean registered = userService.register(name, email, password, phone);
            
            if (registered) {
                // Đăng ký thành công
                request.setAttribute("success", "Đăng ký thành công. Vui lòng đăng nhập.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            } else {
                // Đăng ký thất bại
                request.setAttribute("error", "Email đã tồn tại trong hệ thống");
                
                // Giữ lại dữ liệu đã nhập
                request.setAttribute("name", name);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
} 