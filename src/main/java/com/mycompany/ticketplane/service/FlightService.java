package com.mycompany.ticketplane.service;

import com.mycompany.ticketplane.dao.FlightDAO;
import com.mycompany.ticketplane.dao.SeatDAO;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.Flight.FlightStatus;
import com.mycompany.ticketplane.model.Location;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Time;
import java.util.Date;
import java.util.List;

public class FlightService {
    
    private FlightDAO flightDAO;
    private SeatDAO seatDAO;
    
    public FlightService() {
        this.flightDAO = new FlightDAO();
        this.seatDAO = new SeatDAO();
    }
    
    public Flight findById(int flightId) throws SQLException {
        return flightDAO.findById(flightId);
    }
    
    public List<Flight> findAll() throws SQLException {
        return flightDAO.findAll();
    }
    
    public List<Flight> searchFlights(String origin, String destination, Date departureDate) throws SQLException {
        // Convert java.util.Date to java.sql.Date
        java.sql.Date sqlDate = new java.sql.Date(departureDate.getTime());
        return flightDAO.searchFlights(origin, destination, sqlDate);
    }
    
    public boolean addFlight(String airline, String flightNumber, String origin, String destination,
                            Date departureTime, Date arrivalTime, Time duration, BigDecimal price,
                            int totalSeats, int economySeats, int businessSeats, int firstClassSeats) throws SQLException {
        
        Flight flight = new Flight();
        flight.setAirline(airline);
        flight.setFlightNumber(flightNumber);
        flight.setOrigin(origin);
        flight.setDestination(destination);
        flight.setDepartureTime(departureTime);
        flight.setArrivalTime(arrivalTime);
        flight.setDuration(duration);
        flight.setPrice(price);
        flight.setAvailableSeats(totalSeats);
        flight.setStatus(FlightStatus.ON_TIME);
        
        boolean flightAdded = flightDAO.insert(flight);
        
        if (flightAdded) {
            // Thêm ghế cho chuyến bay
            return seatDAO.insertSeatsForFlight(flight.getFlightId(), economySeats, businessSeats, firstClassSeats);
        }
        
        return false;
    }
    
    public boolean updateFlight(int flightId, String airline, String flightNumber, String origin, String destination,
                               Date departureTime, Date arrivalTime, Time duration, BigDecimal price,
                               int availableSeats, FlightStatus status) throws SQLException {
        
        Flight flight = flightDAO.findById(flightId);
        
        if (flight == null) {
            return false;
        }
        
        flight.setAirline(airline);
        flight.setFlightNumber(flightNumber);
        flight.setOrigin(origin);
        flight.setDestination(destination);
        flight.setDepartureTime(departureTime);
        flight.setArrivalTime(arrivalTime);
        flight.setDuration(duration);
        flight.setPrice(price);
        flight.setAvailableSeats(availableSeats);
        flight.setStatus(status);
        
        return flightDAO.update(flight);
    }
    
    public boolean updateFlightStatus(int flightId, FlightStatus status) throws SQLException {
        Flight flight = flightDAO.findById(flightId);
        
        if (flight == null) {
            return false;
        }
        
        flight.setStatus(status);
        
        return flightDAO.update(flight);
    }
    
    public boolean deleteFlight(int flightId) throws SQLException {
        return flightDAO.delete(flightId);
    }
    
    /**
     * Lấy danh sách các chuyến bay sắp tới
     * @return Danh sách các chuyến bay sắp tới
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Flight> getUpcomingFlights() throws SQLException {
        // Mặc định lấy 5 chuyến bay sắp tới
        return flightDAO.getUpcomingFlights(5);
    }

    /**
     * Lấy danh sách các chuyến bay sắp tới với số lượng giới hạn
     * @param limit Số lượng chuyến bay tối đa cần lấy
     * @return Danh sách các chuyến bay sắp tới
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Flight> getUpcomingFlights(int limit) throws SQLException {
        return flightDAO.getUpcomingFlights(limit);
    }
    
    public boolean updateAvailableSeats(int flightId, int change) throws SQLException {
        return flightDAO.updateAvailableSeats(flightId, change);
    }
    
    /**
     * Lấy số lượng chuyến bay theo trạng thái
     * @param status Trạng thái chuyến bay
     * @return Số lượng chuyến bay theo trạng thái
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public int getFlightCountByStatus(String status) throws SQLException {
        return flightDAO.getFlightCountByStatus(status);
    }

    /**
     * Lấy danh sách các chuyến bay có sẵn
     * @return Danh sách các chuyến bay có sẵn
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Flight> findAvailableFlights() throws SQLException {
        return flightDAO.findAvailableFlights();
    }

    /**
     * Lấy danh sách tất cả các điểm khởi hành
     * @return Danh sách các điểm khởi hành
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Location> getAllOrigins() throws SQLException {
        return flightDAO.getAllOrigins();
    }

    /**
     * Lấy danh sách tất cả các điểm đến
     * @return Danh sách các điểm đến
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Location> getAllDestinations() throws SQLException {
        return flightDAO.getAllDestinations();
    }

    /**
     * Lấy tất cả các chuyến bay
     * @return Danh sách tất cả các chuyến bay
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Flight> getAllFlights() throws SQLException {
        return flightDAO.findAll();
    }

    /**
     * Tạo chuyến bay mới
     * @param flight Đối tượng Flight cần tạo
     * @return true nếu tạo thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean createFlight(Flight flight) throws SQLException {
        return flightDAO.insert(flight);
    }

    /**
     * Cập nhật thông tin chuyến bay
     * @param flight Đối tượng Flight cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean updateFlight(Flight flight) throws SQLException {
        return flightDAO.update(flight);
    }

    /**
     * Lấy thông tin chi tiết của chuyến bay
     * @param flightId ID của chuyến bay cần lấy thông tin
     * @return Đối tượng Flight chứa thông tin chi tiết
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Flight getFlightDetail(int flightId) throws SQLException {
        return flightDAO.findById(flightId);
    }

    /**
     * Tìm kiếm chuyến bay theo điều kiện
     * @param origin Điểm khởi hành
     * @param destination Điểm đến
     * @param departureDate Ngày khởi hành
     * @return Danh sách các chuyến bay thỏa mãn điều kiện
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public List<Flight> searchFlights(String origin, String destination, java.sql.Date departureDate) throws SQLException {
        return flightDAO.searchFlights(origin, destination, departureDate);
    }

    /**
     * Tìm chuyến bay theo số hiệu
     * @param flightNumber Số hiệu chuyến bay
     * @return Đối tượng Flight nếu tìm thấy, null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public Flight findByFlightNumber(String flightNumber) throws SQLException {
        return flightDAO.findByFlightNumber(flightNumber);
    }
} 