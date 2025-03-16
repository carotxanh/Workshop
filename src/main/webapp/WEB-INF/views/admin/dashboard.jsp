<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/admin/common/header.jsp">
    <jsp:param name="title" value="Bảng điều khiển" />
</jsp:include>

<!-- Toast container -->
<div class="position-fixed top-0 end-0 p-3" style="z-index: 1050">
    <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-check-circle me-2"></i>
                <span id="successToastMessage"></span>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    
    <div id="errorToast" class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-exclamation-circle me-2"></i>
                <span id="errorToastMessage"></span>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<!-- Page Heading -->
<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Bảng điều khiển</h1>
    <div>
        <a href="${pageContext.request.contextPath}/admin/dashboard/filter" class="btn btn-sm btn-primary shadow-sm me-2">
            <i class="fas fa-filter fa-sm text-white-50 me-2"></i>Lọc dữ liệu
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-sm btn-primary shadow-sm me-2">
            <i class="fas fa-file-alt fa-sm text-white-50 me-2"></i>Tạo báo cáo
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports/download" class="btn btn-sm btn-primary shadow-sm">
            <i class="fas fa-download fa-sm text-white-50 me-2"></i>Tải báo cáo
        </a>
    </div>
</div>

<!-- Content Row -->
<div class="row">
    <!-- Tổng doanh thu -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                            Doanh thu (Tháng này)</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                            <fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-calendar fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tổng doanh thu năm -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                            Doanh thu (Năm nay)</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                            <fmt:formatNumber value="${yearlyRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Số lượng đặt vé -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Đặt vé (Tháng này)
                        </div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">${monthlyBookings}</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div class="progress-bar bg-info" role="progressbar"
                                        style="width: ${monthlyBookingsPercentage}%" aria-valuenow="${monthlyBookingsPercentage}" aria-valuemin="0"
                                        aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Số lượng người dùng -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                            Người dùng</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${totalUsers}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-users fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Content Row -->
<div class="row">
    <!-- Biểu đồ doanh thu -->
    <div class="col-xl-8 col-lg-7">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Doanh thu theo tháng</h6>
                <div class="dropdown no-arrow">
                    <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink"
                        data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in"
                        aria-labelledby="dropdownMenuLink">
                        <div class="dropdown-header">Tùy chọn:</div>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard?action=viewRevenue">Xem chi tiết</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports?type=revenue">Tạo báo cáo</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard/filter">Lọc dữ liệu</a>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="chart-area">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Biểu đồ phân bố đặt vé -->
    <div class="col-xl-4 col-lg-5">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Phân bố đặt vé theo hạng</h6>
                <div class="dropdown no-arrow">
                    <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink"
                        data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in"
                        aria-labelledby="dropdownMenuLink">
                        <div class="dropdown-header">Tùy chọn:</div>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard?action=viewBookings">Xem chi tiết</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports?type=bookings">Tạo báo cáo</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard/filter">Lọc dữ liệu</a>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="chart-pie pt-4 pb-2">
                    <canvas id="bookingDistributionChart"></canvas>
                </div>
                <div class="mt-4 text-center small">
                    <span class="me-2">
                        <i class="fas fa-circle text-primary"></i> Phổ thông
                    </span>
                    <span class="me-2">
                        <i class="fas fa-circle text-success"></i> Thương gia
                    </span>
                    <span class="me-2">
                        <i class="fas fa-circle text-info"></i> Hạng nhất
                    </span>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
$(document).ready(function() {
    // Hiển thị thông báo thành công/lỗi
    <c:if test="${not empty successMessage}">
        $('#successToastMessage').text("${successMessage}");
        var successToast = new bootstrap.Toast(document.getElementById('successToast'));
        successToast.show();
    </c:if>
    
    <c:if test="${not empty errorMessage}">
        $('#errorToastMessage').text("${errorMessage}");
        var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
        errorToast.show();
    </c:if>
});

// Biểu đồ doanh thu
var ctx = document.getElementById("revenueChart");
var myLineChart = new Chart(ctx, {
    type: 'line',
    data: {
        labels: ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"],
        datasets: [{
            label: "Doanh thu",
            lineTension: 0.3,
            backgroundColor: "rgba(78, 115, 223, 0.05)",
            borderColor: "rgba(78, 115, 223, 1)",
            pointRadius: 3,
            pointBackgroundColor: "rgba(78, 115, 223, 1)",
            pointBorderColor: "rgba(78, 115, 223, 1)",
            pointHoverRadius: 3,
            pointHoverBackgroundColor: "rgba(78, 115, 223, 1)",
            pointHoverBorderColor: "rgba(78, 115, 223, 1)",
            pointHitRadius: 10,
            pointBorderWidth: 2,
            data: [
                <c:forEach var="i" begin="1" end="12">
                    <c:set var="monthKey" value="Tháng ${i}" />
                    <c:choose>
                        <c:when test="${revenueChartData[monthKey] != null}">
                            ${revenueChartData[monthKey]}<c:if test="${i < 12}">,</c:if>
                        </c:when>
                        <c:otherwise>
                            0<c:if test="${i < 12}">,</c:if>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            ],
        }],
    },
    options: {
        maintainAspectRatio: false,
        layout: {
            padding: {
                left: 10,
                right: 25,
                top: 25,
                bottom: 0
            }
        },
        scales: {
            xAxes: [{
                time: {
                    unit: 'date'
                },
                gridLines: {
                    display: false,
                    drawBorder: false
                },
                ticks: {
                    maxTicksLimit: 7
                }
            }],
            yAxes: [{
                ticks: {
                    maxTicksLimit: 5,
                    padding: 10,
                    callback: function(value, index, values) {
                        return number_format(value) + ' ₫';
                    }
                },
                gridLines: {
                    color: "rgb(234, 236, 244)",
                    zeroLineColor: "rgb(234, 236, 244)",
                    drawBorder: false,
                    borderDash: [2],
                    zeroLineBorderDash: [2]
                }
            }],
        },
        legend: {
            display: false
        },
        tooltips: {
            backgroundColor: "rgb(255,255,255)",
            bodyFontColor: "#858796",
            titleMarginBottom: 10,
            titleFontColor: '#6e707e',
            titleFontSize: 14,
            borderColor: '#dddfeb',
            borderWidth: 1,
            xPadding: 15,
            yPadding: 15,
            displayColors: false,
            intersect: false,
            mode: 'index',
            caretPadding: 10,
            callbacks: {
                label: function(tooltipItem, chart) {
                    var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label || '';
                    return datasetLabel + ': ' + number_format(tooltipItem.yLabel) + ' ₫';
                }
            }
        }
    }
});

// Biểu đồ phân bố đặt vé
var ctx2 = document.getElementById("bookingDistributionChart");
var bookingDistributionChart = new Chart(ctx2, {
    type: 'doughnut',
    data: {
        labels: ["Phổ thông", "Thương gia", "Hạng nhất"],
        datasets: [{
            data: [
                <c:forEach var="entry" items="${bookingsByClass}">
                    <c:choose>
                        <c:when test="${entry.key eq 'Phổ thông'}">${entry.value},</c:when>
                        <c:when test="${entry.key eq 'Thương gia'}">${entry.value},</c:when>
                        <c:when test="${entry.key eq 'Hạng nhất'}">${entry.value}</c:when>
                    </c:choose>
                </c:forEach>
            ],
            backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
            hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf'],
            hoverBorderColor: "rgba(234, 236, 244, 1)",
        }],
    },
    options: {
        maintainAspectRatio: false,
        tooltips: {
            backgroundColor: "rgb(255,255,255)",
            bodyFontColor: "#858796",
            borderColor: '#dddfeb',
            borderWidth: 1,
            xPadding: 15,
            yPadding: 15,
            displayColors: false,
            caretPadding: 10,
        },
        legend: {
            display: false
        },
        cutoutPercentage: 80,
    },
});

// Hàm định dạng số
function number_format(number, decimals, dec_point, thousands_sep) {
    // *     example: number_format(1234.56, 2, ',', ' ');
    // *     return: '1 234,56'
    number = (number + '').replace(',', '').replace(' ', '');
    var n = !isFinite(+number) ? 0 : +number,
        prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
        sep = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
        dec = (typeof dec_point === 'undefined') ? '.' : dec_point,
        s = '',
        toFixedFix = function(n, prec) {
            var k = Math.pow(10, prec);
            return '' + Math.round(n * k) / k;
        };
    // Fix for IE parseFloat(0.55).toFixed(0) = 0;
    s = (prec ? toFixedFix(n, prec) : '' + Math.round(n)).split('.');
    if (s[0].length > 3) {
        s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep);
    }
    if ((s[1] || '').length < prec) {
        s[1] = s[1] || '';
        s[1] += new Array(prec - s[1].length + 1).join('0');
    }
    return s.join(dec);
}
</script>

<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" /> 