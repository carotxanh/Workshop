package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.BookingDAO;
import com.mycompany.ticketplane.dao.FlightDAO;
import com.mycompany.ticketplane.dao.SeatDAO;
import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Booking.BookingStatus;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Seat.SeatStatus;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class BookingService {
    
    private BookingDAO bookingDAO;
    private FlightDAO flightDAO;
    private SeatDAO seatDAO;
    
    public BookingService() {
        this.bookingDAO = new BookingDAO();
        this.flightDAO = new FlightDAO();
        this.seatDAO = new SeatDAO();
    }
    
    public Booking findById(int bookingId) throws SQLException {
        return bookingDAO.findById(bookingId);
    }
    
    public List<Booking> findByUserId(int userId) throws SQLException {
        return bookingDAO.findByUserId(userId);
    }
    
    public List<Booking> findAll() throws SQLException {
        return bookingDAO.findAll();
    }
    
    public Booking bookFlight(int userId, int flightId, String seatNumber, BigDecimal totalPrice) throws SQLException {
        // Kiểm tra chuyến bay có tồn tại không
        Flight flight = flightDAO.findById(flightId);
        if (flight == null || flight.getAvailableSeats() <= 0) {
            return null;
        }
        
        // Tạo đối tượng booking
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setFlightId(flightId);
        booking.setBookingDate(new Date());
        booking.setSeatNumber(seatNumber);
        booking.setStatus(BookingStatus.PENDING);
        booking.setTotalPrice(totalPrice);
        
        // Lưu booking vào database
        boolean bookingCreated = bookingDAO.insert(booking);
        
        if (bookingCreated) {
            // Cập nhật trạng thái ghế
            seatDAO.updateSeatStatus(flightId, seatNumber, SeatStatus.BOOKED);
            return booking;
        }
        
        return null;
    }
    
    public boolean confirmBooking(int bookingId) throws SQLException {
        return bookingDAO.updateStatus(bookingId, BookingStatus.CONFIRMED);
    }
    
    public boolean cancelBooking(int bookingId) throws SQLException {
        Booking booking = bookingDAO.findById(bookingId);
        if (booking != null && booking.getStatus() != BookingStatus.COMPLETED) {
            // Cập nhật trạng thái booking
            boolean updated = bookingDAO.updateStatus(bookingId, BookingStatus.CANCELLED);
            if (updated) {
                // Cập nhật trạng thái ghế
                seatDAO.updateSeatStatus(booking.getFlightId(), booking.getSeatNumber(), SeatStatus.AVAILABLE);
                // Cập nhật số ghế trống của chuyến bay
                flightDAO.updateAvailableSeats(booking.getFlightId(), 1);
                return true;
            }
        }
        return false;
    }
    
    public int getTotalBookings() throws SQLException {
        return bookingDAO.getTotalBookings();
    }
    
    public BigDecimal getTotalRevenue() throws SQLException {
        return bookingDAO.getTotalRevenue();
    }
    
    public List<Booking> getBookingsByUserId(int userId) throws SQLException {
        return bookingDAO.findByUserId(userId);
    }
    
    /**
     * Lấy doanh thu theo tháng và năm
     * @param month Tháng (1-12)
     * @param year Năm
     * @return Doanh thu trong tháng/năm chỉ định
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByMonth(int month, int year) throws SQLException {
        return bookingDAO.getRevenueByMonth(month, year).doubleValue();
    }
    
    /**
     * Lấy doanh thu theo năm
     * @param year Năm
     * @return Doanh thu trong năm chỉ định
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByYear(int year) throws SQLException {
        return bookingDAO.getRevenueByYear(year).doubleValue();
    }
    
    /**
     * Lấy số lượng đặt vé theo tháng và năm
     * @param month Tháng (1-12)
     * @param year Năm
     * @return Số lượng đặt vé trong tháng/năm chỉ định
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByMonth(int month, int year) throws SQLException {
        return bookingDAO.getBookingCountByMonth(month, year);
    }
    
    /**
     * Lấy số lượng đặt vé theo loại ghế
     * @param seatClass Loại ghế (ECONOMY, BUSINESS, FIRST)
     * @return Số lượng đặt vé theo loại ghế
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByClass(String seatClass) throws SQLException {
        return bookingDAO.getBookingCountByClass(seatClass);
    }
    
    /**
     * Lấy doanh thu theo khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Doanh thu trong khoảng thời gian
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByDateRange(Date startDate, Date endDate) throws SQLException {
        return bookingDAO.getRevenueByDateRange(startDate, endDate).doubleValue();
    }
    
    /**
     * Lấy số lượng đặt vé theo khoảng thời gian
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng đặt vé trong khoảng thời gian
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByDateRange(Date startDate, Date endDate) throws SQLException {
        return bookingDAO.getBookingCountByDateRange(startDate, endDate);
    }
    
    /**
     * Lấy doanh thu theo từng tháng trong năm
     * @param year Năm
     * @return Map chứa doanh thu của từng tháng
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Map<Integer, Double> getMonthlyRevenueInYear(int year) throws SQLException {
        Map<Integer, Double> monthlyRevenue = new HashMap<>();
        for (int month = 1; month <= 12; month++) {
            double revenue = getRevenueByMonth(month, year);
            monthlyRevenue.put(month, revenue);
        }
        return monthlyRevenue;
    }
    
    /**
     * Lấy số lượng đặt vé theo trạng thái
     * @param status Trạng thái đặt vé
     * @return Số lượng đặt vé theo trạng thái
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByStatus(BookingStatus status) throws SQLException {
        return bookingDAO.getBookingCountByStatus(status);
    }
    
    /**
     * Lấy doanh thu theo điểm đến
     * @param destinationId ID của điểm đến
     * @return Doanh thu theo điểm đến
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByDestination(int destinationId) throws SQLException {
        return bookingDAO.getRevenueByDestination(destinationId).doubleValue();
    }
    
    /**
     * Lấy số lượng đặt vé theo điểm đến
     * @param destinationId ID của điểm đến
     * @return Số lượng đặt vé theo điểm đến
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByDestination(int destinationId) throws SQLException {
        return bookingDAO.getBookingCountByDestination(destinationId);
    }
    
    /**
     * Lấy doanh thu theo trạng thái đặt vé
     * @param status Trạng thái đặt vé
     * @return Doanh thu theo trạng thái
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByStatus(BookingStatus status) throws SQLException {
        return bookingDAO.getRevenueByStatus(status).doubleValue();
    }
    
    /**
     * Lấy doanh thu theo quý
     * @param quarter Quý (1-4)
     * @param year Năm
     * @return Doanh thu trong quý
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByQuarter(int quarter, int year) throws SQLException {
        return bookingDAO.getRevenueByQuarter(quarter, year).doubleValue();
    }
    
    /**
     * Lấy số lượng đặt vé theo quý
     * @param quarter Quý (1-4)
     * @param year Năm
     * @return Số lượng đặt vé trong quý
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByQuarter(int quarter, int year) throws SQLException {
        return bookingDAO.getBookingCountByQuarter(quarter, year);
    }
    
    /**
     * Lấy danh sách các đặt vé gần đây
     * @param limit Số lượng đặt vé cần lấy
     * @return Danh sách các đặt vé gần đây
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Booking> getRecentBookings(int limit) throws SQLException {
        return bookingDAO.getRecentBookings(limit);
    }
    
    /**
     * Lấy doanh thu theo loại ghế
     * @param seatClass Loại ghế (ECONOMY, BUSINESS, FIRST)
     * @return Doanh thu theo loại ghế
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByClass(String seatClass) throws SQLException {
        return bookingDAO.getRevenueByClass(seatClass).doubleValue();
    }
    
    /**
     * Lấy doanh thu theo loại ghế và khoảng thời gian
     * @param seatClass Loại ghế (ECONOMY, BUSINESS, FIRST)
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Doanh thu theo loại ghế trong khoảng thời gian
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByClassAndDateRange(String seatClass, Date startDate, Date endDate) throws SQLException {
        return bookingDAO.getRevenueByClassAndDateRange(seatClass, startDate, endDate).doubleValue();
    }
    
    /**
     * Lấy số lượng đặt vé theo loại ghế và khoảng thời gian
     * @param seatClass Loại ghế (ECONOMY, BUSINESS, FIRST)
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return Số lượng đặt vé theo loại ghế trong khoảng thời gian
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByClassAndDateRange(String seatClass, Date startDate, Date endDate) throws SQLException {
        return bookingDAO.getBookingCountByClassAndDateRange(seatClass, startDate, endDate);
    }
    
    /**
     * Lấy doanh thu theo tuần
     * @param weekNumber Số thứ tự tuần trong năm
     * @param year Năm
     * @return Doanh thu trong tuần
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByWeek(int weekNumber, int year) throws SQLException {
        return bookingDAO.getRevenueByWeek(weekNumber, year).doubleValue();
    }
    
    /**
     * Lấy số lượng đặt vé theo tuần
     * @param weekNumber Số thứ tự tuần trong năm
     * @param year Năm
     * @return Số lượng đặt vé trong tuần
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByWeek(int weekNumber, int year) throws SQLException {
        return bookingDAO.getBookingCountByWeek(weekNumber, year);
    }
    
    /**
     * Lấy doanh thu theo ngày
     * @param date Ngày cần lấy doanh thu
     * @return Doanh thu trong ngày
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public double getRevenueByDate(Date date) throws SQLException {
        return bookingDAO.getRevenueByDate(date).doubleValue();
    }
    
    /**
     * Lấy số lượng đặt vé theo ngày
     * @param date Ngày cần lấy số lượng đặt vé
     * @return Số lượng đặt vé trong ngày
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getBookingCountByDate(Date date) throws SQLException {
        return bookingDAO.getBookingCountByDate(date);
    }
    
    /**
     * Lấy tất cả các đặt vé trong hệ thống
     * @return Danh sách tất cả các đặt vé
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Booking> getAllBookings() throws SQLException {
        return bookingDAO.findAll();
    }
    
    /**
     * Cập nhật trạng thái đặt vé
     * @param bookingId ID đặt vé
     * @param status Trạng thái mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean updateBookingStatus(int bookingId, BookingStatus status) throws SQLException {
        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null) {
            return false;
        }
        
        booking.setStatus(status);
        return bookingDAO.update(booking);
    }
    
    /**
     * Tạo booking mới
     * @param booking Đối tượng booking cần tạo
     * @return true nếu tạo thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean createBooking(Booking booking) throws SQLException {
        return bookingDAO.insert(booking);
    }
    
    /**
     * Cập nhật booking
     * @param booking Đối tượng booking cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean updateBooking(Booking booking) throws SQLException {
        return bookingDAO.update(booking);
    }
} 