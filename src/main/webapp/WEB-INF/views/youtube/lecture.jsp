<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Pandora University - LMS</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">
    <link href="css/logo.css" rel="stylesheet">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
</head>
<style>
.pointer_default{
	cursor: default;
}
.pointer{
	cursor: pointer;
}
</style>
<body id="page-top">
<!-- Page Wrapper -->
<div id="wrapper">

    <%-- 네비게이션 바 --%>
    <%@include file="../navbar.jsp" %>

    <!-- 콘텐츠 전체 감싸기 -->
    <div id="content-wrapper" class="d-flex flex-column">
        <!-- 메인 컨텐츠 -->
        <div id="content">
            <%-- 탑 바 --%>
            <%@include file="../top.jsp" %>

            <!-- 본문 컨텐츠 부분 시작 -->
            <div class="container-fluid">

                <!-- 메인 페이지의 탑 -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800"></h1>
                    <%--                        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i class="fas fa-download fa-sm text-white-50"></i> 이건무슨 버튼으로 쓸까</a>--%>
                </div>

                <div class="row">
                    <!-- A카드 게시판 -->
                    <div class="col-xl-12 col-lg-7">
                        <div class="card shadow mb-4 pointer_default">
                            <!-- A 카드 설정 버튼 부분 -->
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">내 강의실</h6>
                            </div>
                            <!-- A 본문 부분 -->
                            <div class="card-body">
                                <div>
                                    <!-- 실제 구성은 이곳에서 진행합니다. -->
                                    <table class="table table-sm" id="table_lecture">
                                        <thead>
                                        <tr>
                                            <th class="col-2 text-center"><c:choose><c:when test="${sessionScope.appl_no != null}">수강목록</c:when><c:otherwise>강의목록</c:otherwise></c:choose></th>
                                            <th class="col-2 text-center">학과</th>
                                            <th class="col-2 text-center">교수</th>
                                            <c:if test="${sessionScope.appl_no != null}"><th class="col-3 text-center">진도율</th></c:if>
                                        </tr>
                                        </thead>
                                        <tbody id="tb_lecture">
                                        <c:forEach items="${lecture }" var="i">
                                        <tr style='height:70px; line-height:70px;'>
                                            <td class='text-center pointer' onclick="location.href='lectureList?sbjct_no=${i.SBJCT_NO}'">${i.SBJCT_NM }</td>
                                            <td class='text-center'>${i.CRCLM_NM }</td>
                                            <td class='text-center'>${i.KORN_FLNM }</td>
                                            <c:if test="${sessionScope.appl_no != null}">
	                                            <td>
	                                                <div style='height:20px; line-height: 20px;'>&nbsp;
														<span class='float-right' style='height:20px; margin-right:45px;'>
														${i.LECT_MAG }%
														</span>
													</div>
	                                                <div class='progress mb-4' style='height:20px; margin:5px 30px 25px 45px;'>
	                                                    <div class='progress-bar bg-primary' role='progressbar' style='height:20px; 
	                                                    width: ${i.LECT_MAG }%;' aria-valuenow='20' aria-valuemin='0' aria-valuemax='100'></div>
		                                            </div>
	                                            </td>
                                            </c:if>
										</tr>
										</c:forEach>
                                	</tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- 디테일 화면 종료 -->
    </div>
    <!-- 메인 콘텐츠 종료 -->
    
    <!-- Footer -->
    <%@include file="../footer.jsp" %>
</div>
<!-- End of Content Wrapper -->

</div>
<!-- End of Page Wrapper -->

<!-- Scroll to Top Button -->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>

<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="js/sb-admin-2.min.js"></script>
</body>
</html>