<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    $(function(){
       $("#alarm").hide();
    });
    let ws = new WebSocket("ws://172.30.1.39/noticeAlarm");
    ws.onopen = function(event) { console.log("알림감지가 작동되고 있습니다."); };
    ws.onmessage = function(event) {
        console.log(event.data);
        // document.getElementById("alarm").text(event.data);
        $(function(){
            $("#alarm").text(event.data);
            $("#alarm").fadeIn(3000,'linear');
            $("#alarm").delay(1000).fadeOut(3000,'linear');
        });
    };
    ws.onclose = function(event) { console.log("알림감지가 꺼졌습니다."); };
</script>
<style>
    #alarm {
        background-color: #fafafa; /*#405dc6;*/
        border: none;
        border-radius: 5px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.8);
        color: #333;
        font-size: 17px;
        font-weight: bold;
        margin: 10px;
        position : fixed;
        bottom : 0px;
        width:300px;
        height:70px;
        text-align: center;
        line-height: 70px;
        z-index: 1;
    }
</style>
<!-- 사이드 메뉴바 -->
<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center justify-content-center logo_space" href="index">
        <div class="logo_img"><img src="/img/pandora_logo.png"></div>
        <div class="sidebar-brand-text mx-3">
            <div class="logo_big_text">PANDORA</div>
            <sup class="logo_small_text">university</sup>
        </div>
    </a>
    <!-- Divider -->
    <hr class="sidebar-divider my-0">
    <!-- 학생정보 -->
    <li class="nav-item active">
        <a class="nav-link" href="index">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span><c:if test="${ sessionScope.id ne null }">${sessionScope.name} 님 환영합니다.</c:if></span>
        </a>
    </li>
    <!-- Divider -->
    <hr class="sidebar-divider">
    <!-- A 카테고리 -->
    <div class="sidebar-heading">학사</div>
    <!-- 학사 카테고리 학교 드롭다운 -->
    <li class="nav-item">
        <a style="height: 40px;" class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseTwo"
           aria-expanded="true" aria-controls="collapseTwo">
            <i class="fas fa-fw fa-cog"></i>
            <span>학교</span>
        </a>
        <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded">
                <h6 class="collapse-header">학교</h6>
                <a class="collapse-item" href="/notice">공지사항</a>
            </div>
        </div>
    </li>
    <!-- 학사 카테고리 내 강의실 탭 -->
    <li class="nav-item">
        <a class="nav-link collapsed" href="/lecture">
            <i class="fas fa-fw fa-book"></i>
            <span>내 강의실</span>
        </a>
    </li>

    <!-- Divider -->
    <hr class="sidebar-divider line">

    <!-- B 카테고리 -->
    <div class="sidebar-heading">엔터테인먼트</div>
    <!-- 추가적인 기능(이름 수정 필요) -->
    <li class="nav-item">
        <a style="height: 40px;" class="nav-link" href="/messageBox">
            <i class="fas fa-fw fa-chart-area"></i>
            <span>쪽지함</span>
        </a>
    </li>
    <!-- C 부분2 -->
    <li class="nav-item">
        <a class="nav-link" href="/chatting">
            <i class="fas fa-fw fa-table"></i>
            <span>채팅</span>
        </a>
    </li>
    <!-- Divider -->
    <hr class="sidebar-divider d-none d-md-block">

    <!-- 사이드바 토클 버튼 (누르면 들어감) -->
    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>

    <!-- Alarm-->
    <div id="alarm"></div>
</ul>
<!-- End of Sidebar -->
