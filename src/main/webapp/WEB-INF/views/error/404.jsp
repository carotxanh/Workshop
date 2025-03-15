<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Không tìm thấy trang" />
</jsp:include>

<div class="text-center mt-5">
    <div class="error mx-auto" data-text="404">404</div>
    <p class="lead text-gray-800 mb-4">Không tìm thấy trang</p>
    <p class="text-gray-500 mb-0">Có vẻ như bạn đã tìm thấy một lỗi trong ma trận...</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary mt-3">
        <i class="fas fa-home me-2"></i>Quay về trang chủ
    </a>
</div>

<style>
.error {
    color: #5a5c69;
    font-size: 7rem;
    position: relative;
    line-height: 1;
    width: 12.5rem;
    margin: 0 auto;
}

.error:before {
    content: attr(data-text);
    position: absolute;
    left: -2px;
    text-shadow: 1px 0 #4e73df;
    top: 0;
    color: #5a5c69;
    background: #f8f9fc;
    overflow: hidden;
    clip: rect(0, 900px, 0, 0);
    animation: noise-anim-2 3s infinite linear alternate-reverse;
}

.error:after {
    content: attr(data-text);
    position: absolute;
    left: 2px;
    text-shadow: -1px 0 #e74a3b;
    top: 0;
    color: #5a5c69;
    background: #f8f9fc;
    overflow: hidden;
    clip: rect(0, 900px, 0, 0);
    animation: noise-anim 2s infinite linear alternate-reverse;
}

@keyframes noise-anim {
    0% {
        clip: rect(31px, 9999px, 44px, 0);
    }
    5% {
        clip: rect(70px, 9999px, 71px, 0);
    }
    10% {
        clip: rect(29px, 9999px, 84px, 0);
    }
    15% {
        clip: rect(75px, 9999px, 39px, 0);
    }
    20% {
        clip: rect(57px, 9999px, 98px, 0);
    }
    25% {
        clip: rect(18px, 9999px, 8px, 0);
    }
    30% {
        clip: rect(11px, 9999px, 35px, 0);
    }
    35% {
        clip: rect(84px, 9999px, 43px, 0);
    }
    40% {
        clip: rect(10px, 9999px, 4px, 0);
    }
    45% {
        clip: rect(63px, 9999px, 26px, 0);
    }
    50% {
        clip: rect(47px, 9999px, 26px, 0);
    }
    55% {
        clip: rect(10px, 9999px, 67px, 0);
    }
    60% {
        clip: rect(52px, 9999px, 55px, 0);
    }
    65% {
        clip: rect(48px, 9999px, 43px, 0);
    }
    70% {
        clip: rect(61px, 9999px, 67px, 0);
    }
    75% {
        clip: rect(28px, 9999px, 86px, 0);
    }
    80% {
        clip: rect(95px, 9999px, 59px, 0);
    }
    85% {
        clip: rect(54px, 9999px, 30px, 0);
    }
    90% {
        clip: rect(1px, 9999px, 23px, 0);
    }
    95% {
        clip: rect(58px, 9999px, 71px, 0);
    }
    100% {
        clip: rect(40px, 9999px, 70px, 0);
    }
}

@keyframes noise-anim-2 {
    0% {
        clip: rect(18px, 9999px, 13px, 0);
    }
    5% {
        clip: rect(74px, 9999px, 50px, 0);
    }
    10% {
        clip: rect(94px, 9999px, 99px, 0);
    }
    15% {
        clip: rect(91px, 9999px, 24px, 0);
    }
    20% {
        clip: rect(45px, 9999px, 73px, 0);
    }
    25% {
        clip: rect(99px, 9999px, 66px, 0);
    }
    30% {
        clip: rect(41px, 9999px, 22px, 0);
    }
    35% {
        clip: rect(40px, 9999px, 78px, 0);
    }
    40% {
        clip: rect(87px, 9999px, 38px, 0);
    }
    45% {
        clip: rect(91px, 9999px, 9px, 0);
    }
    50% {
        clip: rect(56px, 9999px, 98px, 0);
    }
    55% {
        clip: rect(22px, 9999px, 100px, 0);
    }
    60% {
        clip: rect(88px, 9999px, 7px, 0);
    }
    65% {
        clip: rect(75px, 9999px, 10px, 0);
    }
    70% {
        clip: rect(37px, 9999px, 76px, 0);
    }
    75% {
        clip: rect(95px, 9999px, 13px, 0);
    }
    80% {
        clip: rect(15px, 9999px, 76px, 0);
    }
    85% {
        clip: rect(54px, 9999px, 61px, 0);
    }
    90% {
        clip: rect(41px, 9999px, 59px, 0);
    }
    95% {
        clip: rect(23px, 9999px, 84px, 0);
    }
    100% {
        clip: rect(86px, 9999px, 12px, 0);
    }
}
</style>

<jsp:include page="/WEB-INF/views/common/footer.jsp" /> 