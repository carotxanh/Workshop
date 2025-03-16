/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.ticketplane.controller.admin;

import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Booking.BookingStatus;
import com.mycompany.ticketplane.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "BookingManagement", urlPatterns = {"/admin/booking-management"})
public class BookingManagement extends HttpServlet {

    private BookingService bookingService;
    
    public BookingManagement() {
        this.bookingService = new BookingService();
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }
            
            switch (action) {
                case "view":
                    viewBookingDetail(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateBooking(request, response);
                    break;
                case "updateStatus":
                    updateBookingStatus(request, response);
                    break;
                default:
                    listBookings(request, response);
                    break;
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingManagement.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/error.jsp").forward(request, response);
        }
    }

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
        processRequest(request, response);
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
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Booking Management Servlet";
    }// </editor-fold>

    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Booking> bookings = bookingService.getAllBookings();
        request.setAttribute("bookings", bookings);
        
        // Get statistics for dashboard
        int totalBookings = bookingService.getTotalBookings();
        int confirmedBookings = bookingService.getBookingCountByStatus(BookingStatus.CONFIRMED);
        int pendingBookings = bookingService.getBookingCountByStatus(BookingStatus.PENDING);
        int cancelledBookings = bookingService.getBookingCountByStatus(BookingStatus.CANCELLED);
        double totalRevenue = bookingService.getTotalRevenue().doubleValue();
        
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("confirmedBookings", confirmedBookings);
        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("cancelledBookings", cancelledBookings);
        request.setAttribute("totalRevenue", totalRevenue);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/booking-list.jsp").forward(request, response);
    }
    
    private void viewBookingDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        Booking booking = bookingService.getBookingWithFlightDetails(bookingId);
        
        if (booking == null) {
            request.setAttribute("errorMessage", "Booking not found");
            request.getRequestDispatcher("/WEB-INF/views/admin/error.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/WEB-INF/views/admin/booking-detail.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        Booking booking = bookingService.getBookingWithFlightDetails(bookingId);
        
        if (booking == null) {
            request.setAttribute("errorMessage", "Booking not found");
            request.getRequestDispatcher("/WEB-INF/views/admin/error.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("booking", booking);
        request.setAttribute("statuses", BookingStatus.values());
        request.getRequestDispatcher("/WEB-INF/views/admin/booking-edit.jsp").forward(request, response);
    }
    
    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String status = request.getParameter("status");
        
        Booking booking = bookingService.findById(bookingId);
        if (booking == null) {
            request.setAttribute("errorMessage", "Booking not found");
            request.getRequestDispatcher("/WEB-INF/views/admin/error.jsp").forward(request, response);
            return;
        }
        
        booking.setStatus(BookingStatus.valueOf(status));
        booking.setPassengerName(request.getParameter("passengerName"));
        booking.setPassengerEmail(request.getParameter("passengerEmail"));
        booking.setPassengerPhone(request.getParameter("passengerPhone"));
        booking.setPaymentStatus(request.getParameter("paymentStatus"));
        
        boolean updated = bookingService.updateBooking(booking);
        
        if (updated) {
            request.setAttribute("message", "Booking updated successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to update booking");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/booking-management?action=view&id=" + bookingId);
    }
    
    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String status = request.getParameter("status");
        
        boolean updated = bookingService.updateBookingStatus(bookingId, BookingStatus.valueOf(status));
        
        if (updated) {
            request.setAttribute("message", "Booking status updated successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to update booking status");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/booking-management");
    }
}
