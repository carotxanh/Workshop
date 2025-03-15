<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Cài đặt hệ thống" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Cài đặt hệ thống</h2>
</div>

<div class="row">
    <div class="col-lg-6">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Cài đặt chung</h6>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/settings/general" method="post">
                    <div class="mb-3">
                        <label for="siteName" class="form-label">Tên trang web</label>
                        <input type="text" class="form-control" id="siteName" name="siteName" value="${settings.siteName}">
                    </div>
                    <div class="mb-3">
                        <label for="siteDescription" class="form-label">Mô tả trang web</label>
                        <textarea class="form-control" id="siteDescription" name="siteDescription" rows="3">${settings.siteDescription}</textarea>
                    </div>
                    <div class="mb-3">
                        <label for="contactEmail" class="form-label">Email liên hệ</label>
                        <input type="email" class="form-control" id="contactEmail" name="contactEmail" value="${settings.contactEmail}">
                    </div>
                    <div class="mb-3">
                        <label for="contactPhone" class="form-label">Số điện thoại liên hệ</label>
                        <input type="text" class="form-control" id="contactPhone" name="contactPhone" value="${settings.contactPhone}">
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Địa chỉ</label>
                        <textarea class="form-control" id="address" name="address" rows="2">${settings.address}</textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu cài đặt
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-lg-6">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Cài đặt email</h6>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/settings/email" method="post">
                    <div class="mb-3">
                        <label for="smtpHost" class="form-label">SMTP Host</label>
                        <input type="text" class="form-control" id="smtpHost" name="smtpHost" value="${emailSettings.smtpHost}">
                    </div>
                    <div class="mb-3">
                        <label for="smtpPort" class="form-label">SMTP Port</label>
                        <input type="number" class="form-control" id="smtpPort" name="smtpPort" value="${emailSettings.smtpPort}">
                    </div>
                    <div class="mb-3">
                        <label for="smtpUsername" class="form-label">SMTP Username</label>
                        <input type="text" class="form-control" id="smtpUsername" name="smtpUsername" value="${emailSettings.smtpUsername}">
                    </div>
                    <div class="mb-3">
                        <label for="smtpPassword" class="form-label">SMTP Password</label>
                        <input type="password" class="form-control" id="smtpPassword" name="smtpPassword" value="${emailSettings.smtpPassword}">
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="smtpAuth" name="smtpAuth" ${emailSettings.smtpAuth ? 'checked' : ''}>
                        <label class="form-check-label" for="smtpAuth">Yêu cầu xác thực</label>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="smtpStartTls" name="smtpStartTls" ${emailSettings.smtpStartTls ? 'checked' : ''}>
                        <label class="form-check-label" for="smtpStartTls">Sử dụng STARTTLS</label>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu cài đặt
                    </button>
                    <button type="button" class="btn btn-outline-primary ms-2" id="testEmailBtn">
                        <i class="fas fa-paper-plane me-2"></i>Gửi email thử nghiệm
                    </button>
                </form>
            </div>
        </div>
        
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Cài đặt thanh toán</h6>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/settings/payment" method="post">
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="enablePaypal" name="enablePaypal" ${paymentSettings.enablePaypal ? 'checked' : ''}>
                        <label class="form-check-label" for="enablePaypal">Bật thanh toán PayPal</label>
                    </div>
                    <div class="mb-3">
                        <label for="paypalClientId" class="form-label">PayPal Client ID</label>
                        <input type="text" class="form-control" id="paypalClientId" name="paypalClientId" value="${paymentSettings.paypalClientId}">
                    </div>
                    <div class="mb-3">
                        <label for="paypalSecret" class="form-label">PayPal Secret</label>
                        <input type="password" class="form-control" id="paypalSecret" name="paypalSecret" value="${paymentSettings.paypalSecret}">
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="enableVnpay" name="enableVnpay" ${paymentSettings.enableVnpay ? 'checked' : ''}>
                        <label class="form-check-label" for="enableVnpay">Bật thanh toán VNPay</label>
                    </div>
                    <div class="mb-3">
                        <label for="vnpayMerchantId" class="form-label">VNPay Merchant ID</label>
                        <input type="text" class="form-control" id="vnpayMerchantId" name="vnpayMerchantId" value="${paymentSettings.vnpayMerchantId}">
                    </div>
                    <div class="mb-3">
                        <label for="vnpaySecretKey" class="form-label">VNPay Secret Key</label>
                        <input type="password" class="form-control" id="vnpaySecretKey" name="vnpaySecretKey" value="${paymentSettings.vnpaySecretKey}">
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu cài đặt
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal gửi email thử nghiệm -->
<div class="modal fade" id="testEmailModal" tabindex="-1" aria-labelledby="testEmailModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="testEmailModalLabel">Gửi email thử nghiệm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/settings/test-email" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="testEmailTo" class="form-label">Gửi đến</label>
                        <input type="email" class="form-control" id="testEmailTo" name="testEmailTo" required>
                    </div>
                    <div class="mb-3">
                        <label for="testEmailSubject" class="form-label">Tiêu đề</label>
                        <input type="text" class="form-control" id="testEmailSubject" name="testEmailSubject" value="Email thử nghiệm từ hệ thống đặt vé máy bay" required>
                    </div>
                    <div class="mb-3">
                        <label for="testEmailContent" class="form-label">Nội dung</label>
                        <textarea class="form-control" id="testEmailContent" name="testEmailContent" rows="5" required>Đây là email thử nghiệm từ hệ thống đặt vé máy bay. Nếu bạn nhận được email này, cấu hình email của hệ thống đã hoạt động bình thường.</textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Gửi email</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#testEmailBtn').click(function() {
        $('#testEmailModal').modal('show');
    });
});
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 