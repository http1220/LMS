<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>Notice Detail</title>
    <link rel="shortcut icon" href="img/pandora_logo.png" />
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
    <script type="text/javascript" src="/js/NoticePaging.js"></script>
    <script type="text/javascript" src="/js/search.js"></script>
    <link type="text/css" rel="stylesheet" href="css/Notice.css">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">
    <link href="css/logo.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<style></style>
<script>
    function noticeUpdate(rowNum) { location.href = "/noticeUpdate?rowNum=" + rowNum + "&totalCnt=${totalCnt}"; }
    function noticeDelete(rowNum) { if (confirm("정말로 삭제하시겠습니까?")) location.href = "/noticeDelete?rowNum=" + rowNum; }
</script>
<style>
</style>
<body id="page-top">
<!-- Page Wrapper -->
<div id="wrapper">
    <%-- 네비게이션 바 --%>
    <%@include file="../navbar.jsp" %>
    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">
        <!-- 메인 컨텐츠 -->
        <div id="content">
            <%-- 탑 바 --%>
            <%@include file="../top.jsp" %>
            <!-- 본문 컨텐츠 부분 시작 -->
                <!-- <div style="background-color: #2a96a5; width:100%; height:200px;" onclick="location.href='/notice'">
                    <div style="width:1200px;height:200px; margin:0 auto;">
                        <h1 class="mb-0" style="font-weight:bold; color:white; padding:50px 0px 0px 20px; cursor: pointer;">공지사항</h1><br>
                        <h5 style="color:white; margin-left:20px;">Pandora 대학에 다양한 소식을 알려드립니다.</h5>
                    </div>
                </div> -->
            <div class="container-fluid" style="width:1200px; height:750px;">
                <div class="d-sm-flex align-items-center justify-content-between mb-4" style="margin-top:50px; text-align: center; ">
                    <h1 class="text-truncate" style="font-weight:bold; width:1200px; color:black;"> ${noticeDetail.notice_title } </h1>
                </div>
                <!--수정할 부분 시작-->
                <div class="detailBox">
                    <div class="detailTop">
                        <div class="detailTop_item"><input type="hidden" id="detailWriter">작성자 : ${noticeDetail.admin_id }&nbsp;&nbsp;&nbsp;&nbsp;</div>
                        <div class="detailTop_item">등록일 : ${noticeDetail.notice_date }&nbsp;&nbsp;</div>
                    </div>
                    <div class="detailMid"><br>${noticeDetail.notice_content }<br><br></div><br><br>
                    <div style="display: inline-block;">
                        <a style="color:black; font-weight: bold;" href="/noticeDetail?rowNum=${rowNum - 1 }&totalCnt=${totalCnt}"><i class="xi-angle-left xi-x"></i>이전글</a>   
                    </div>
                    <div style="display: inline-block; float:right;">
                        <a style="color:black; font-weight: bold;" href="/noticeDetail?rowNum=${rowNum + 1 }&totalCnt=${totalCnt}">다음글<i class="xi-angle-right xi-x"></i></a>
                    </div>
                    <br><br><br>
                    <div>
                        <c:if test="${sessionScope.id eq 'dudu' }">
                        <button class="detailBtn" style="background-color: #ffc414;" onclick="noticeUpdate(${rowNum })">수정</button>
                        <button class="detailBtn" style="background-color: #ff3d3d;" onclick="noticeDelete(${rowNum })">삭제</button>
                        </c:if>
                        <button class="detailBtn boardList" onclick="location.href='/notice'">목록</button>
                    </div>
                </div><!--수정할 부분 끝-->
            </div><!-- End of Container -->
        </div><!-- End of Main Content -->
        <!-- footer -->
        <%@include file="../footer.jsp" %>
    </div><!-- End of Content Wrapper -->
</div><!-- End of Page Wrapper -->

<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="js/sb-admin-2.min.js"></script>

</body>
</html>
