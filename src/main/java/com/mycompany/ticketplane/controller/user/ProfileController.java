/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.ticketplane.controller.user;

import com.mycompany.ticketplane.model.User;
import com.mycompany.ticketplane.service.UserService;
import com.mycompany.ticketplane.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "Profile", urlPatterns = {"/profileController"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 2, // 2 MB
        maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class ProfileController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "view":
                    viewProfile(request, response, sessionUser);
                    break;
                case "edit":
                    showEditForm(request, response, sessionUser);
                    break;
                case "changePassword":
                    showChangePasswordForm(request, response, sessionUser);
                    break;
                default:
                    viewProfile(request, response, sessionUser);
                    break;
            }
        } else {
            viewProfile(request, response, sessionUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "updateProfile":
                    updateProfile(request, response, sessionUser);
                    break;
                case "changePassword":
                    changePassword(request, response, sessionUser);
                    break;
                case "uploadAvatar":
                    uploadAvatar(request, response, sessionUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/profileController");
                    break;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/profileController");
        }
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        try {
            // Lấy thông tin người dùng từ cơ sở dữ liệu để đảm bảo dữ liệu mới nhất
            User user = userService.findById(sessionUser.getUserId());
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi khi tải thông tin người dùng: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        try {
            User user = userService.findById(sessionUser.getUserId());
            request.setAttribute("user", user);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi khi tải thông tin người dùng: " + e.getMessage());
            viewProfile(request, response, sessionUser);
        }
    }

    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        try {
            User user = userService.findById(sessionUser.getUserId());
            request.setAttribute("user", user);
            request.setAttribute("passwordMode", true);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi khi tải thông tin người dùng: " + e.getMessage());
            viewProfile(request, response, sessionUser);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // Kiểm tra dữ liệu đầu vào
        boolean hasError = false;
        
        if (!ValidationUtil.isNotEmpty(name) || name.length() < 3 || name.length() > 50) {
            request.setAttribute("errorMessage", "Họ và tên phải có từ 3 đến 50 ký tự");
            hasError = true;
        }
        
        if (!ValidationUtil.isNotEmpty(email) || !ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Email không hợp lệ");
            hasError = true;
        }
        
        if (ValidationUtil.isNotEmpty(phone) && !ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("errorMessage", "Số điện thoại không hợp lệ");
            hasError = true;
        }
        
        if (hasError) {
            showEditForm(request, response, sessionUser);
            return;
        }
        
        try {
            boolean updated = userService.updateProfile(sessionUser.getUserId(), name, email, phone);
            
            if (updated) {
                // Cập nhật thông tin người dùng trong session
                User updatedUser = userService.findById(sessionUser.getUserId());
                HttpSession session = request.getSession();
                session.setAttribute("user", updatedUser);
                
                request.setAttribute("successMessage", "Cập nhật thông tin thành công");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thông tin thất bại. Email có thể đã tồn tại.");
            }
            
            viewProfile(request, response, sessionUser);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi cập nhật thông tin: " + e.getMessage());
            showEditForm(request, response, sessionUser);
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Kiểm tra dữ liệu đầu vào
        if (!ValidationUtil.isNotEmpty(currentPassword)
                || !ValidationUtil.isNotEmpty(newPassword)
                || !ValidationUtil.isNotEmpty(confirmPassword)) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin");
            showChangePasswordForm(request, response, sessionUser);
            return;
        }
        
        if (newPassword.length() < 8) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 8 ký tự");
            showChangePasswordForm(request, response, sessionUser);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp");
            showChangePasswordForm(request, response, sessionUser);
            return;
        }
        
        try {
            boolean changed = userService.changePassword(sessionUser.getUserId(), currentPassword, newPassword);
            
            if (changed) {
                request.setAttribute("successMessage", "Đổi mật khẩu thành công");
            } else {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng");
            }
            
            viewProfile(request, response, sessionUser);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi đổi mật khẩu: " + e.getMessage());
            showChangePasswordForm(request, response, sessionUser);
        }
    }

    private void uploadAvatar(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        try {
            Part filePart = request.getPart("avatarFile");

            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("errorMessage", "Vui lòng chọn file ảnh");
                viewProfile(request, response, sessionUser);
                return;
            }

            String fileName = filePart.getSubmittedFileName();
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));

            // Kiểm tra định dạng file
            if (!fileExtension.equalsIgnoreCase(".jpg")
                    && !fileExtension.equalsIgnoreCase(".jpeg")
                    && !fileExtension.equalsIgnoreCase(".png")
                    && !fileExtension.equalsIgnoreCase(".gif")) {
                request.setAttribute("errorMessage", "Chỉ chấp nhận file ảnh (JPG, PNG, GIF)");
                viewProfile(request, response, sessionUser);
                return;
            }

            // Tạo tên file mới để tránh trùng lặp
            String newFileName = "avatar_" + sessionUser.getUserId() + "_" + UUID.randomUUID().toString() + fileExtension;

            // Lưu file vào thư mục uploads
            String uploadPath = getServletContext().getRealPath("/resources/uploads/avatars");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + newFileName;
            filePart.write(filePath);

            // Cập nhật đường dẫn ảnh đại diện trong cơ sở dữ liệu (nếu có)
            // Hiện tại model User chưa có trường avatarUrl, nên cần bổ sung
            request.setAttribute("successMessage", "Tải lên ảnh đại diện thành công");
            viewProfile(request, response, sessionUser);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi tải lên ảnh đại diện: " + e.getMessage());
            viewProfile(request, response, sessionUser);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Profile Controller";
    }
}
