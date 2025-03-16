package com.mycompany.ticketplane.controller.auth;

import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra nếu người dùng đã đăng nhập
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userService.login(email, password);

            if (user != null) {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                // Đăng nhập thất bại
                request.setAttribute("error", "Email hoặc mật khẩu không đúng");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
