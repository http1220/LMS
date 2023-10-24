<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
  let user_id = "${ sessionScope.id }";
  $.ajax({
    type: "POST",
    url: "/msgNew",
    data: {'user_id': user_id },
    dataType: "text",
    success: function (msg) {
      //alert(msg);
      if(msg != "0") $(".msgCnt").text(msg);
      else $(".msgCnt").hide();
    },
    error: function (xhr, status, error) { alert("에러"); }
  });
</script>
<style>
  .msgCnt{
    width:23px;
    height:23px;
    line-height: 15px;
  }
</style>
<!-- 탑 바 -->
<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

  <!-- Sidebar Toggle (Topbar) -->
  <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
    <i class="fa fa-bars"></i>
  </button>

  <!-- Topbar Navbar -->
  <ul class="navbar-nav ml-auto">

    <div class="topbar-divider d-none d-sm-block"></div>

    <!-- 유저 프로필 부분 -->
    <li class="nav-item dropdown no-arrow">
      <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
         data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <span class="mr-2 d-none d-lg-inline text-gray-600 small">
          <c:if test="${ sessionScope.id ne null }">${sessionScope.name}</c:if>
        </span>
        <img class="img-profile rounded-circle" src="img/undraw_profile.svg"><%--유저 프로필 이미지 부분--%>
      </a>

      <!-- 유저 프로필 드롭다운 부분 -->
      <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
           aria-labelledby="userDropdown">
        <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
          <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
          로그아웃
        </a>
      </div>
    </li>
  </ul>
</nav>
<!-- 탑바 마무리 -->

<!-- Logout Modal-->
<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">로그아웃</h5>
        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true"></span>
        </button>
      </div>
      <div class="modal-body">정말로 로그아웃 하시겠습니까?</div>
      <div class="modal-footer">
        <button class="btn btn-secondary" style="font-size: 14px;" type="button" data-dismiss="modal" style="font-size: 12px;">취소</button>
        <form action="/logout" method = "post"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"><button class="btn btn-primary" type="submit" style="font-size: 12px;">로그아웃</button></form>
      </div>
    </div>
  </div>
</div>