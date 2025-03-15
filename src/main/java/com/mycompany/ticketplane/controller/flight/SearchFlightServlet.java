package com.mycompany.ticketplane.controller.flight;

import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.service.FlightService;
import com.mycompany.ticketplane.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/flights/search")
public class SearchFlightServlet extends HttpServlet {
    
    private FlightService flightService;
    
    @Override
    public void init() throws ServletException {
        flightService = new FlightService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/flight/search.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departureDateStr = request.getParameter("departureDate");
        
        // Kiểm tra dữ liệu đầu vào
        boolean hasError = false;
        
        if (!ValidationUtil.isNotEmpty(origin)) {
            request.setAttribute("originError", "Vui lòng chọn điểm khởi hành");
            hasError = true;
        }
        
        if (!ValidationUtil.isNotEmpty(destination)) {
            request.setAttribute("destinationError", "Vui lòng chọn điểm đến");
            hasError = true;
        }
        
        if (!ValidationUtil.isNotEmpty(departureDateStr)) {
            request.setAttribute("departureDateError", "Vui lòng chọn ngày khởi hành");
            hasError = true;
        }
        
        if (origin.equals(destination)) {
            request.setAttribute("destinationError", "Điểm đến không được trùng với điểm khởi hành");
            hasError = true;
        }
        
        if (hasError) {
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("origin", origin);
            request.setAttribute("destination", destination);
            request.setAttribute("departureDate", departureDateStr);
            
            request.getRequestDispatcher("/WEB-INF/views/flight/search.jsp").forward(request, response);
            return;
        }
        
        try {
            // Chuyển đổi chuỗi ngày thành đối tượng Date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date departureDate = dateFormat.parse(departureDateStr);
            
            // Tìm kiếm chuyến bay
            List<Flight> flights = flightService.searchFlights(origin, destination, departureDate);
            
            // Lưu kết quả tìm kiếm vào request
            request.setAttribute("flights", flights);
            request.setAttribute("origin", origin);
            request.setAttribute("destination", destination);
            request.setAttribute("departureDate", departureDateStr);
            
            // Chuyển hướng đến trang kết quả tìm kiếm
            request.getRequestDispatcher("/WEB-INF/views/flight/search-results.jsp").forward(request, response);
        } catch (ParseException e) {
            request.setAttribute("departureDateError", "Định dạng ngày không hợp lệ");
            
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("origin", origin);
            request.setAttribute("destination", destination);
            
            request.getRequestDispatcher("/WEB-INF/views/flight/search.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("origin", origin);
            request.setAttribute("destination", destination);
            request.setAttribute("departureDate", departureDateStr);
            
            request.getRequestDispatcher("/WEB-INF/views/flight/search.jsp").forward(request, response);
        }
    }
} 