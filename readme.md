# Hệ thống đặt vé máy bay

Hệ thống đặt vé máy bay là một ứng dụng web Java cho phép người dùng tìm kiếm, đặt và thanh toán vé máy bay trực tuyến.

## Tính năng

- Đăng ký, đăng nhập và quản lý tài khoản người dùng
- Tìm kiếm chuyến bay theo điểm khởi hành, điểm đến và ngày bay
- Xem chi tiết chuyến bay và chọn ghế
- Đặt vé và thanh toán trực tuyến
- Xem lịch sử đặt vé và hủy vé
- Tạo và tải xuống vé điện tử dạng PDF
- Gửi email xác nhận đặt vé và thanh toán

## Công nghệ sử dụng

- Java Servlet và JSP
- MySQL
- HTML, CSS, JavaScript
- Bootstrap
- iText (tạo PDF)
- JavaMail (gửi email)

## Cài đặt

1. Clone repository
2. Import project vào Eclipse hoặc IntelliJ IDEA
3. Cấu hình Tomcat server
4. Tạo cơ sở dữ liệu MySQL và import file sql.sql
5. Cấu hình kết nối cơ sở dữ liệu trong file DBConnection.java
6. Cấu hình email trong file mail.properties
7. Chạy ứng dụng

## Cấu trúc dự án

### Actor trong hệ thống

1. Khách hàng (Customer) – Người dùng mua vé máy bay trực tuyến.
2. Nhân viên (Staff/Admin) – Quản lý thông tin chuyến bay, đơn hàng, khách hàng.
3. Hệ thống thanh toán (Payment Gateway) – Xử lý thanh toán vé máy bay.
4. Hệ thống hãng hàng không (Airline System) – Cung cấp dữ liệu về chuyến bay, tình trạng ghế, hủy chuyến.
5. Hệ thống thông báo (Notification System) – Gửi email, SMS xác nhận đặt vé.

---

### 2. Danh sách Use Case chính

### 2.1. Use Case của Khách hàng

1. Đăng ký tài khoản – Tạo tài khoản khách hàng.
2. Đăng nhập/Quên mật khẩu – Xác thực khách hàng.
3. Tìm kiếm chuyến bay – Nhập thông tin điểm đi, điểm đến, ngày bay để tìm vé.
4. Chọn chuyến bay và ghế ngồi – Chọn chuyến bay phù hợp và ghế ngồi mong muốn.
5. Đặt vé máy bay – Nhập thông tin cá nhân, số hộ chiếu (nếu cần).
6. Thanh toán vé máy bay – Liên kết với cổng thanh toán để thanh toán vé.
7. Nhận vé điện tử – Hệ thống gửi vé qua email hoặc tin nhắn.
8. Quản lý đặt chỗ – Xem lại thông tin đặt vé, chỉnh sửa nếu cần.
9. Hủy vé/Đổi lịch bay – Hủy vé hoặc đổi lịch trình theo chính sách của hãng hàng không.
10. Nhận thông báo – Nhận thông báo về chuyến bay qua email hoặc SMS.

---

### 2.2. Use Case của Nhân viên (Admin/Staff)

1. Quản lý khách hàng – Xem, chỉnh sửa thông tin khách hàng.
2. Quản lý chuyến bay – Thêm, sửa, xóa lịch trình chuyến bay.
3. Quản lý đặt vé – Kiểm tra trạng thái đặt vé, hủy/đổi vé khi khách yêu cầu.
4. Quản lý thanh toán – Kiểm tra giao dịch, hoàn tiền khi cần thiết.
5. Quản lý thông báo – Gửi thông báo về chuyến bay thay đổi, khuyến mãi.
6. Thống kê và báo cáo – Xem báo cáo doanh thu, số vé bán, số vé hủy.

---

### 2.3. Use Case của Hệ thống thanh toán

1. Xử lý thanh toán – Liên kết với ngân hàng, ví điện tử để thực hiện giao dịch.
2. Hoàn tiền – Xử lý yêu cầu hoàn tiền khi khách hủy vé.

---

### 2.4. Use Case của Hệ thống hãng hàng không

1. Cập nhật dữ liệu chuyến bay – Nhận thông tin từ hãng hàng không về thay đổi lịch trình.
2. Xác nhận tình trạng ghế ngồi – Kiểm tra số lượng ghế còn trống.

---

### 2.5. Use Case của Hệ thống thông báo

1. Gửi xác nhận đặt vé – Gửi email/SMS khi đặt vé thành công.
2. Thông báo thay đổi chuyến bay – Gửi thông báo khi chuyến bay bị hoãn, đổi giờ.
3. Nhắc nhở trước giờ bay – Gửi nhắc nhở về thời gian check-in.

========================

CẤU TRÚC PROJECT
TicketPlane-1.0-SNAPSHOT/
│── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── com/
│   │   │   │   ├── mycompany/
│   │   │   │   │   ├── ticketplane/
│   │   │   │   │   │   ├── model/
│   │   │   │   │   │   │   ├── User.java
│   │   │   │   │   │   │   ├── Flight.java
│   │   │   │   │   │   │   ├── Booking.java
│   │   │   │   │   │   │   ├── Payment.java
│   │   │   │   │   │   │   ├── Notification.java
│   │   │   │   │   │   │   ├── Airport.java
│   │   │   │   │   │   │   ├── Seat.java
│   │   │   │   │   │   │   ├── FlightAirport.java
│   │   │   │   │   │   ├── dao/
│   │   │   │   │   │   │   ├── UserDAO.java
│   │   │   │   │   │   │   ├── FlightDAO.java
│   │   │   │   │   │   │   ├── BookingDAO.java
│   │   │   │   │   │   │   ├── PaymentDAO.java
│   │   │   │   │   │   │   ├── NotificationDAO.java
│   │   │   │   │   │   │   ├── AirportDAO.java
│   │   │   │   │   │   │   ├── SeatDAO.java
│   │   │   │   │   │   │   ├── DAOFactory.java
│   │   │   │   │   │   │   ├── DBConnection.java
│   │   │   │   │   │   ├── service/
│   │   │   │   │   │   │   ├── UserService.java
│   │   │   │   │   │   │   ├── FlightService.java
│   │   │   │   │   │   │   ├── BookingService.java
│   │   │   │   │   │   │   ├── PaymentService.java
│   │   │   │   │   │   │   ├── NotificationService.java
│   │   │   │   │   │   │   ├── AirportService.java
│   │   │   │   │   │   ├── controller/
│   │   │   │   │   │   │   ├── auth/
│   │   │   │   │   │   │   │   ├── LoginServlet.java
│   │   │   │   │   │   │   │   ├── RegisterServlet.java
│   │   │   │   │   │   │   │   ├── LogoutServlet.java
│   │   │   │   │   │   │   │   ├── ForgotPasswordServlet.java
│   │   │   │   │   │   │   ├── flight/
│   │   │   │   │   │   │   │   ├── SearchFlightServlet.java
│   │   │   │   │   │   │   │   ├── FlightDetailsServlet.java
│   │   │   │   │   │   │   ├── booking/
│   │   │   │   │   │   │   │   ├── BookTicketServlet.java
│   │   │   │   │   │   │   │   ├── SelectSeatServlet.java
│   │   │   │   │   │   │   │   ├── ViewBookingsServlet.java
│   │   │   │   │   │   │   │   ├── CancelBookingServlet.java
│   │   │   │   │   │   │   ├── payment/
│   │   │   │   │   │   │   │   ├── ProcessPaymentServlet.java
│   │   │   │   │   │   │   │   ├── PaymentConfirmationServlet.java
│   │   │   │   │   │   │   ├── admin/
│   │   │   │   │   │   │   │   ├── ManageUsersServlet.java
│   │   │   │   │   │   │   │   ├── ManageFlightsServlet.java
│   │   │   │   │   │   │   │   ├── ManageBookingsServlet.java
│   │   │   │   │   │   │   │   ├── StatisticsServlet.java
│   │   │   │   │   │   ├── util/
│   │   │   │   │   │   │   ├── EmailUtil.java
│   │   │   │   │   │   │   ├── PasswordUtil.java
│   │   │   │   │   │   │   ├── ValidationUtil.java
│   │   │   │   │   │   │   ├── PDFGenerator.java
│   │   │   │   │   │   ├── filter/
│   │   │   │   │   │   │   ├── AuthenticationFilter.java
│   │   │   │   │   │   │   ├── AdminFilter.java
│   │   │   │   │   │   ├── listener/
│   │   │   │   │   │   │   ├── AppContextListener.java
│   │   ├── resources/
│   │   │   ├── META-INF/
│   │   │   ├── db.properties
│   │   │   ├── log4j.properties
│   │   │   ├── mail-templates/
│   │   │   │   ├── booking-confirmation.html
│   │   │   │   ├── payment-confirmation.html
│   │   │   │   ├── flight-reminder.html
│   │   ├── webapp/
│   │   │   ├── META-INF/
│   │   │   │   ├── context.xml
│   │   │   ├── WEB-INF/
│   │   │   │   ├── beans.xml
│   │   │   │   ├── web.xml
│   │   │   │   ├── views/
│   │   │   │   │   ├── auth/
│   │   │   │   │   │   ├── login.jsp
│   │   │   │   │   │   ├── register.jsp
│   │   │   │   │   │   ├── forgot-password.jsp
│   │   │   │   │   ├── flight/
│   │   │   │   │   │   ├── search.jsp
│   │   │   │   │   │   ├── search-results.jsp
│   │   │   │   │   │   ├── details.jsp
│   │   │   │   │   ├── booking/
│   │   │   │   │   │   ├── passenger-info.jsp
│   │   │   │   │   │   ├── select-seat.jsp
│   │   │   │   │   │   ├── confirmation.jsp
│   │   │   │   │   │   ├── my-bookings.jsp
│   │   │   │   │   ├── payment/
│   │   │   │   │   │   ├── payment-form.jsp
│   │   │   │   │   │   ├── payment-confirmation.jsp
│   │   │   │   │   ├── admin/
│   │   │   │   │   │   ├── dashboard.jsp
│   │   │   │   │   │   ├── manage-users.jsp
│   │   │   │   │   │   ├── manage-flights.jsp
│   │   │   │   │   │   ├── manage-bookings.jsp
│   │   │   │   │   │   ├── statistics.jsp
│   │   │   │   │   ├── common/
│   │   │   │   │   │   ├── header.jsp
│   │   │   │   │   │   ├── footer.jsp
│   │   │   │   │   │   ├── navigation.jsp
│   │   │   │   │   │   ├── error.jsp
│   │   │   ├── assets/
│   │   │   │   ├── css/
│   │   │   │   │   ├── style.css
│   │   │   │   │   ├── admin.css
│   │   │   │   ├── js/
│   │   │   │   │   ├── main.js
│   │   │   │   │   ├── search.js
│   │   │   │   │   ├── booking.js
│   │   │   │   │   ├── payment.js
│   │   │   │   ├── images/
│   │   │   │   │   ├── logo.png
│   │   │   │   │   ├── banner.jpg
│   │   │   │   │   ├── seat-map.png
│   │   │   ├── index.html
│── nb-configuration.xml
│── pom.xml
│── README.md
│── sql.sql