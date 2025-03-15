CREATE DATABASE IF NOT EXISTS ticket_plane;
USE ticket_plane;

-- Bảng User
CREATE TABLE IF NOT EXISTS User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('ADMIN', 'CUSTOMER') NOT NULL DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng Flight
CREATE TABLE IF NOT EXISTS Flight (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    airline VARCHAR(100) NOT NULL,
    flight_number VARCHAR(20) NOT NULL,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    duration TIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    available_seats INT NOT NULL,
    status ENUM('ON_TIME', 'DELAYED', 'CANCELLED') NOT NULL DEFAULT 'ON_TIME',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng Seat
CREATE TABLE IF NOT EXISTS Seat (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    class ENUM('ECONOMY', 'BUSINESS', 'FIRST_CLASS') NOT NULL DEFAULT 'ECONOMY',
    status ENUM('AVAILABLE', 'BOOKED') NOT NULL DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id) ON DELETE CASCADE,
    UNIQUE KEY (flight_id, seat_number)
);

-- Bảng Booking
CREATE TABLE IF NOT EXISTS Booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    flight_id INT NOT NULL,
    booking_date DATETIME NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id)
);

-- Bảng Payment
CREATE TABLE IF NOT EXISTS Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    card_number VARCHAR(50),
    card_name VARCHAR(100),
    transaction_id VARCHAR(100) UNIQUE,
    refund_for INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (refund_for) REFERENCES Payment(payment_id)
);

-- Dữ liệu mẫu cho bảng User
INSERT INTO User (name, email, password, phone, role) VALUES
('Admin', 'admin@example.com', 'YWRtaW4xMjM=:YWRtaW4xMjM=', '0123456789', 'ADMIN'),
('Nguyễn Văn A', 'nguyenvana@example.com', 'dXNlcjEyMw==:dXNlcjEyMw==', '0987654321', 'CUSTOMER'),
('Trần Thị B', 'tranthib@example.com', 'dXNlcjEyMw==:dXNlcjEyMw==', '0912345678', 'CUSTOMER');

-- Dữ liệu mẫu cho bảng Flight
INSERT INTO Flight (airline, flight_number, origin, destination, departure_time, arrival_time, duration, price, available_seats, status) VALUES
('Vietnam Airlines', 'VN123', 'Hà Nội', 'Hồ Chí Minh', '2023-12-01 08:00:00', '2023-12-01 10:00:00', '02:00:00', 1500000, 150, 'ON_TIME'),
('Vietjet Air', 'VJ456', 'Hồ Chí Minh', 'Đà Nẵng', '2023-12-02 09:30:00', '2023-12-02 11:00:00', '01:30:00', 1200000, 180, 'ON_TIME'),
('Bamboo Airways', 'QH789', 'Đà Nẵng', 'Hà Nội', '2023-12-03 14:00:00', '2023-12-03 16:00:00', '02:00:00', 1400000, 120, 'ON_TIME');

-- Dữ liệu mẫu cho bảng Seat (chỉ một số ghế cho mỗi chuyến bay)
-- Chuyến bay 1
INSERT INTO Seat (flight_id, seat_number, class, status) VALUES
(1, 'A1', 'ECONOMY', 'AVAILABLE'),
(1, 'A2', 'ECONOMY', 'AVAILABLE'),
(1, 'B1', 'BUSINESS', 'AVAILABLE'),
(1, 'F1', 'FIRST_CLASS', 'AVAILABLE');

-- Chuyến bay 2
INSERT INTO Seat (flight_id, seat_number, class, status) VALUES
(2, 'A1', 'ECONOMY', 'AVAILABLE'),
(2, 'A2', 'ECONOMY', 'AVAILABLE'),
(2, 'B1', 'BUSINESS', 'AVAILABLE'),
(2, 'F1', 'FIRST_CLASS', 'AVAILABLE');

-- Chuyến bay 3
INSERT INTO Seat (flight_id, seat_number, class, status) VALUES
(3, 'A1', 'ECONOMY', 'AVAILABLE'),
(3, 'A2', 'ECONOMY', 'AVAILABLE'),
(3, 'B1', 'BUSINESS', 'AVAILABLE'),
(3, 'F1', 'FIRST_CLASS', 'AVAILABLE');

-- - Bảng Notification
CREATE TABLE Notification (
notification_id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT NOT NULL,
message TEXT NOT NULL,
sent_date DATETIME DEFAULT CURRENT_TIMESTAMP,
status ENUM('SENT', 'PENDING') NOT NULL DEFAULT 'PENDING',
notification_type ENUM('EMAIL', 'SMS') NOT NULL DEFAULT 'EMAIL',
FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- - Bảng Airport
CREATE TABLE Airport (
airport_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
code VARCHAR(10) UNIQUE NOT NULL,
city VARCHAR(255) NOT NULL,
country VARCHAR(255) NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- - Bảng Flight_Airport để liên kết sân bay với chuyến bay
CREATE TABLE Flight_Airport (
flight_id INT NOT NULL,
airport_id INT NOT NULL,
type ENUM('DEPARTURE', 'ARRIVAL') NOT NULL,
PRIMARY KEY (flight_id, airport_id, type),
FOREIGN KEY (flight_id) REFERENCES Flight(flight_id) ON DELETE CASCADE,
FOREIGN KEY (airport_id) REFERENCES Airport(airport_id) ON DELETE CASCADE
);
-