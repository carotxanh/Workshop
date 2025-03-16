/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.ticketplane.controller.admin;

import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.model.User.UserRole;
import com.mycompany.ticketplane.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "UserManagement", urlPatterns = {"/admin/user-management"})
public class UserManagement extends HttpServlet {

    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getRole() != UserRole.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/error/403");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "view":
                viewUserDetail(request, response);
                break;
            case "list":
            default:
                listUsers(request, response);
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getRole() != UserRole.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/error/403");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "create":
                createUser(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Error retrieving users: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
        }
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("roles", UserRole.values());
        request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
    }
    
    private void createUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get form data
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String roleStr = request.getParameter("role");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                roleStr == null || roleStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                request.setAttribute("roles", UserRole.values());
                request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
                return;
            }
            
            // Create user object
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password); // In a real app, you should hash the password
            user.setPhone(phone);
            user.setRole(UserRole.valueOf(roleStr));
            
            // Save to database
            boolean success = userService.createUser(user);
            
            if (success) {
                request.getSession().setAttribute("success", "User created successfully");
                response.sendRedirect(request.getContextPath() + "/admin/user-management");
            } else {
                request.setAttribute("error", "Could not create user");
                request.setAttribute("roles", UserRole.values());
                request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid data: " + e.getMessage());
            request.setAttribute("roles", UserRole.values());
            request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.setAttribute("roles", UserRole.values());
            request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = userService.getUserById(userId);
            
            if (user == null) {
                request.getSession().setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/user-management");
                return;
            }
            
            request.setAttribute("user", user);
            request.setAttribute("roles", UserRole.values());
            request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/admin/user-management");
        } catch (SQLException e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            User user = userService.getUserById(userId);
            
            if (user == null) {
                request.getSession().setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/user-management");
                return;
            }
            
            // Get form data
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String roleStr = request.getParameter("role");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                roleStr == null || roleStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                request.setAttribute("user", user);
                request.setAttribute("roles", UserRole.values());
                request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
                return;
            }
            
            // Update user object
            user.setName(name);
            user.setEmail(email);
            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(password); // In a real app, you should hash the password
            }
            user.setPhone(phone);
            user.setRole(UserRole.valueOf(roleStr));
            
            // Save to database
            boolean success = userService.updateUser(user);
            
            if (success) {
                request.getSession().setAttribute("success", "User updated successfully");
                response.sendRedirect(request.getContextPath() + "/admin/user-management");
            } else {
                request.setAttribute("error", "Could not update user");
                request.setAttribute("user", user);
                request.setAttribute("roles", UserRole.values());
                request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid data: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            
            // Check if user exists
            User user = userService.getUserById(userId);
            if (user == null) {
                request.getSession().setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/user-management");
                return;
            }
            
            // Check if user is the current logged-in admin
            User currentUser = (User) request.getSession().getAttribute("user");
            if (currentUser.getUserId().equals(userId)) {
                request.getSession().setAttribute("error", "You cannot delete your own account");
                response.sendRedirect(request.getContextPath() + "/admin/user-management");
                return;
            }
            
            boolean success = userService.deleteUser(userId);
            
            if (success) {
                request.getSession().setAttribute("success", "User deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Could not delete user");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/user-management");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/admin/user-management");
        } catch (SQLException e) {
            request.getSession().setAttribute("error", "System error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/user-management");
        }
    }
    
    private void viewUserDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = userService.getUserById(userId);
            
            if (user == null) {
                request.getSession().setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/user-management");
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/admin/user-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/admin/user-management");
        } catch (SQLException e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
        }
    }
}
