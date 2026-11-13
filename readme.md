# Airline Ticket Booking System

A Java web application for searching flights, booking seats, managing reservations, and processing payments online.

## Features

- User registration, login, and account management
- Flight search by origin, destination, and travel date
- Flight details and seat selection
- Ticket booking and payment processing
- Booking history and cancellation
- PDF e-ticket generation and download
- Booking and payment confirmation emails

## Technology Stack

- Java Servlets and JSP
- MySQL
- HTML, CSS, and JavaScript
- Bootstrap
- iText for PDF generation
- JavaMail for email delivery

## Setup

1. Clone this repository.
2. Import the project into Eclipse or IntelliJ IDEA as a Maven project.
3. Configure a Tomcat server.
4. Create a MySQL database and import `sql.sql`.
5. Configure the database connection in `src/main/resources/db.properties`.
6. Configure email settings in `src/main/resources/mail.properties`.
7. Build and run the application on Tomcat.

> Update the database and email settings for your environment before running the application. Do not commit credentials.

## Project Structure

The tree below reflects the files currently present in the repository. It is formatted as a fenced code block so GitHub preserves the indentation and tree characters.

```text
Workshop/
├── src/
│   └── main/
│       ├── java/com/mycompany/ticketplane/
│       │   ├── controller/
│       │   │   ├── admin/
│       │   │   │   ├── BookingManagement.java
│       │   │   │   ├── FlightManagementServlet.java
│       │   │   │   └── UserManagement.java
│       │   │   ├── auth/
│       │   │   │   ├── LoginServlet.java
│       │   │   │   └── RegisterServlet.java
│       │   │   ├── booking/
│       │   │   │   └── BookingServlet.java
│       │   │   ├── user/
│       │   │   │   ├── ProfileController.java
│       │   │   │   └── UserBookingsServlet.java
│       │   │   ├── HomeServlet.java
│       │   │   └── LogoutServlet.java
│       │   ├── dao/
│       │   │   ├── BookingDAO.java
│       │   │   ├── DBConnection.java
│       │   │   ├── FlightDAO.java
│       │   │   ├── LocationDAO.java
│       │   │   ├── PaymentDAO.java
│       │   │   ├── SeatDAO.java
│       │   │   └── UserDAO.java
│       │   ├── model/
│       │   │   ├── Booking.java
│       │   │   ├── Flight.java
│       │   │   ├── Location.java
│       │   │   ├── Payment.java
│       │   │   ├── Seat.java
│       │   │   └── User.java
│       │   ├── service/
│       │   │   ├── BookingService.java
│       │   │   ├── FlightService.java
│       │   │   ├── LocationService.java
│       │   │   ├── PaymentService.java
│       │   │   ├── SeatService.java
│       │   │   └── UserService.java
│       │   └── util/
│       │       ├── PasswordUtil.java
│       │       ├── PDFGenerator.java
│       │       └── ValidationUtil.java
│       ├── resources/
│       │   ├── META-INF/
│       │   │   └── persistence.xml
│       │   ├── db.properties
│       │   └── mail.properties
│       └── webapp/
│           ├── META-INF/
│           │   └── context.xml
│           ├── WEB-INF/
│           │   ├── views/
│           │   │   ├── admin/
│           │   │   │   ├── booking-detail.jsp
│           │   │   │   ├── booking-edit.jsp
│           │   │   │   ├── booking-list.jsp
│           │   │   │   ├── flight-add.jsp
│           │   │   │   ├── flight-detail.jsp
│           │   │   │   ├── flight-edit.jsp
│           │   │   │   ├── flight-list.jsp
│           │   │   │   ├── user-add.jsp
│           │   │   │   ├── user-detail.jsp
│           │   │   │   ├── user-edit.jsp
│           │   │   │   └── user-list.jsp
│           │   │   ├── auth/
│           │   │   │   ├── login.jsp
│           │   │   │   └── register.jsp
│           │   │   ├── booking/
│           │   │   │   ├── confirm.jsp
│           │   │   │   ├── detail.jsp
│           │   │   │   ├── flights.jsp
│           │   │   │   └── list.jsp
│           │   │   ├── common/
│           │   │   │   ├── footer.jsp
│           │   │   │   └── header.jsp
│           │   │   ├── error/
│           │   │   │   ├── 403.jsp
│           │   │   │   ├── 404.jsp
│           │   │   │   └── 500.jsp
│           │   │   ├── home.jsp
│           │   │   └── user/
│           │   │       └── profile.jsp
│           │   ├── beans.xml
│           │   └── web.xml
│           ├── resources/
│           │   ├── css/
│           │   │   ├── admin-styles.css
│           │   │   └── style.css
│           │   ├── images/
│           │   │   ├── danang.jpg
│           │   │   ├── hanoi.jpg
│           │   │   └── hochiminh.jpg
│           │   └── js/
│           │       ├── admin-scripts.js
│           │       └── script.js
│           ├── index.html
│           └── index.jsp
├── WEB-INF/
│   └── views/booking/flights.jsp
├── .gitignore
├── danh_sach_use_case.xlsx
├── diagram.mwb
├── nb-configuration.xml
├── nbactions.xml
├── pom.xml
├── readme.md
├── sql.sql
└── TicketPlaneDB.sql
```

## Main Use Cases

### Customer

- Create an account, sign in, or reset a password
- Search for flights by route and date
- Choose a flight and seat
- Enter passenger details and book a ticket
- Pay for a booking and receive an e-ticket by email or SMS
- View, manage, cancel, or change a booking (subject to airline policy)
- Receive flight updates and reminders

### Staff and Administrators

- View and manage customers
- Add, edit, or remove flight schedules
- Review, cancel, or change bookings
- Review payment transactions and process refunds when appropriate
- Send flight updates and promotional notifications
- View sales and cancellation reports

### External Systems

- **Payment gateway:** processes ticket payments and refunds.
- **Airline system:** provides flight schedules and seat availability.
- **Notification system:** sends booking confirmations, schedule-change notices, and reminders.
