package com.mycompany.ticketplane.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.mycompany.ticketplane.model.Booking;
import com.mycompany.ticketplane.model.Flight;
import com.mycompany.ticketplane.model.User;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PDFGenerator {
    
    private static final Font TITLE_FONT = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
    private static final Font HEADER_FONT = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
    private static final Font NORMAL_FONT = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);
    
    /**
     * Tạo vé điện tử dạng PDF
     * @param booking Thông tin đặt vé
     * @param user Thông tin người dùng
     * @param flight Thông tin chuyến bay
     * @return Mảng byte của file PDF
     * @throws DocumentException Lỗi khi tạo PDF
     */
    public static byte[] generateTicket(Booking booking, User user, Flight flight) throws DocumentException {
        Document document = new Document(PageSize.A4);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        
        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            document.open();
            
            // Tiêu đề
            Paragraph title = new Paragraph("VÉ MÁY BAY ĐIỆN TỬ", TITLE_FONT);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(Chunk.NEWLINE);
            
            // Thông tin chuyến bay
            PdfPTable flightTable = new PdfPTable(2);
            flightTable.setWidthPercentage(100);
            
            addTableHeader(flightTable, "THÔNG TIN CHUYẾN BAY");
            addTableRow(flightTable, "Hãng hàng không:", flight.getAirline());
            addTableRow(flightTable, "Số hiệu chuyến bay:", flight.getFlightNumber());
            addTableRow(flightTable, "Điểm khởi hành:", flight.getOrigin());
            addTableRow(flightTable, "Điểm đến:", flight.getDestination());
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            addTableRow(flightTable, "Thời gian khởi hành:", dateFormat.format(flight.getDepartureTime()));
            addTableRow(flightTable, "Thời gian đến:", dateFormat.format(flight.getArrivalTime()));
            
            document.add(flightTable);
            document.add(Chunk.NEWLINE);
            
            // Thông tin hành khách
            PdfPTable passengerTable = new PdfPTable(2);
            passengerTable.setWidthPercentage(100);
            
            addTableHeader(passengerTable, "THÔNG TIN HÀNH KHÁCH");
            addTableRow(passengerTable, "Họ tên:", user.getName());
            addTableRow(passengerTable, "Email:", user.getEmail());
            addTableRow(passengerTable, "Số điện thoại:", user.getPhone());
            
            document.add(passengerTable);
            document.add(Chunk.NEWLINE);
            
            // Thông tin đặt vé
            PdfPTable bookingTable = new PdfPTable(2);
            bookingTable.setWidthPercentage(100);
            
            addTableHeader(bookingTable, "THÔNG TIN ĐẶT VÉ");
            addTableRow(bookingTable, "Mã đặt vé:", String.valueOf(booking.getBookingId()));
            addTableRow(bookingTable, "Ngày đặt vé:", dateFormat.format(booking.getBookingDate()));
            addTableRow(bookingTable, "Số ghế:", booking.getSeatNumber());
            addTableRow(bookingTable, "Trạng thái:", booking.getStatus().toString());
            addTableRow(bookingTable, "Tổng tiền:", booking.getTotalPrice() + " VND");
            
            document.add(bookingTable);
            document.add(Chunk.NEWLINE);
            
            // Thông tin quan trọng
            Paragraph note = new Paragraph("LƯU Ý QUAN TRỌNG:", HEADER_FONT);
            document.add(note);
            
            Paragraph notes = new Paragraph(
                    "1. Vui lòng có mặt tại sân bay ít nhất 2 giờ trước giờ khởi hành.\n" +
                    "2. Mang theo giấy tờ tùy thân (CMND/CCCD/Hộ chiếu) khi làm thủ tục.\n" +
                    "3. Hành lý xách tay không quá 7kg.\n" +
                    "4. Vé điện tử này là bằng chứng hợp đồng vận chuyển.",
                    NORMAL_FONT
            );
            document.add(notes);
            
            // Mã QR
            document.add(Chunk.NEWLINE);
            BarcodeQRCode qrCode = new BarcodeQRCode(
                    "BookingID:" + booking.getBookingId() + 
                    ",Flight:" + flight.getFlightNumber() + 
                    ",Passenger:" + user.getName(),
                    100, 100, null);
            Image qrCodeImage = qrCode.getImage();
            qrCodeImage.setAlignment(Element.ALIGN_CENTER);
            document.add(qrCodeImage);
            
            // Chân trang
            Paragraph footer = new Paragraph("Vé điện tử được tạo ngày " + dateFormat.format(new Date()), NORMAL_FONT);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);
            
            document.close();
            return baos.toByteArray();
        } catch (DocumentException e) {
            throw e;
        } finally {
            try {
                baos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    
    private static void addTableHeader(PdfPTable table, String headerText) {
        PdfPCell cell = new PdfPCell(new Phrase(headerText, HEADER_FONT));
        cell.setColspan(2);
        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(5);
        table.addCell(cell);
    }
    
    private static void addTableRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, NORMAL_FONT));
        labelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        labelCell.setPadding(5);
        table.addCell(labelCell);
        
        PdfPCell valueCell = new PdfPCell(new Phrase(value, NORMAL_FONT));
        valueCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        valueCell.setPadding(5);
        table.addCell(valueCell);
    }
} 