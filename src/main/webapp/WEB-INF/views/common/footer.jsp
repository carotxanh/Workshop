<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="bg-dark text-white mt-5 py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>AirTicket</h5>
                    <p>Hệ thống đặt vé máy bay trực tuyến hàng đầu Việt Nam</p>
                </div>
                <div class="col-md-4">
                    <h5>Liên kết nhanh</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/" class="text-white">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/flights/search" class="text-white">Tìm chuyến bay</a></li>
                        <li><a href="#" class="text-white">Về chúng tôi</a></li>
                        <li><a href="#" class="text-white">Liên hệ</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Liên hệ</h5>
                    <address>
                        <i class="fas fa-map-marker-alt me-2"></i>123 Đường ABC, Quận XYZ, TP. Hồ Chí Minh<br>
                        <i class="fas fa-phone me-2"></i>(+84) 123 456 789<br>
                        <i class="fas fa-envelope me-2"></i>info@airticket.com
                    </address>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p class="mb-0">&copy; 2023 AirTicket. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html> 