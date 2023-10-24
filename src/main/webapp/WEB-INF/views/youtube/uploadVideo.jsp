<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">
    <link href="css/logo.css" rel="stylesheet">
    <%-- API Key값 --%>
    <script src="js/apikey.js"></script>
</head>
<script>
    $(function () {
        let auth = "${auth}";

        $("#btn-access").click(function () {
            if (auth != true) {
                $.post({
                    url: "/youtubeAccess",
                    dataType: "text",
                    success: function (response) {
                        if (response != "") {
                            auth = true;

                            $("#txt_code").text(response);
                            $("#btn-upload").attr("disabled", false);
                            $("#btn-upload").removeClass("btn-secondary").addClass("btn-primary");
                        } else {
                            $("#txt_code").text("인증 실패 했습니다.");
                        }
                    }
                });
            } else {
                alert("이미 인증이 완료 됐습니다.");
            }
        });

        $("#btn-upload").click(function () {

            let video_title = $("#video_title").val();
            let video_desc = $("#video_desc").val();
            let video_file = $("#video_file").val();

            if (video_title == "") {
                alert("제목이 비었습니다.");
                $("#video_title").focus();
                return false;
            }

            if (video_desc == "") {
                alert("내용이 비었습니다.");
                $("#video_desc").focus();
                return false;
            }

            if (video_file == "") {
                alert("파일이 없습니다.");
                $("#video_file").focus();
                return false;
            }

            $("#form-video").submit();
        });
    });
</script>
<style>
    .div-btn {
        float: right;
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
                        <div class="card shadow mb-4">
                            <!-- A 카드 설정 버튼 부분 -->
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">동영상 업로드</h6>
                            </div>
                            <!-- A 본문 부분 -->
                            <div class="card-body">
                                <div>
                                    <!-- 실제 구성은 이곳에서 진행합니다. -->
                                    <form id="form-video" method="post" action="/uploadVideo"
                                          enctype="multipart/form-data">
                                        <table class="table">
                                            <thead>
                                            <tr>
                                                <th class="col-md-4">항목</th>
                                                <th class="col-md-8">데이터</th>
                                            </tr>
                                            </thead>
                                            <tbody class="table-group-divider">
                                            <tr>
                                                <td>인증 여부</td>
                                                <td>
                                                    <span id="txt_code"><c:choose><c:when test='${auth eq true}'><b>인증이 완료 됐습니다.</b></c:when><c:otherwise>미인증 상태입니다.</c:otherwise></c:choose></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>학과</td>
                                                <td>
                                                    <select class="form-select" name="CRCLM_CD" id="CRCLM_CD">
                                                       <option value="150901">컴퓨터공학부</option>
                                                        <option value="150902">경영학부</option>
                                                        <option value="150903">경제학부</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>과목번호</td>
                                                <td>
                                                    <select class="form-select" name="SBJCT_NO" id="sbjct_no">
                                                        <option value="1">자바</option>
                                                        <option value="2">웹디자인</option>
                                                        <option value="3">리눅스</option>
                                                        <option value="4">자바스크립트</option>
                                                        <option value="5">스프링</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>진행 주차</td>
                                                <td>
                                                    <select class="form-select" name="LECT_YMD" id="lect_ymd">
                                                        <option>1</option>
                                                        <option>2</option>
                                                        <option>3</option>
                                                        <option>4</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>강의 제목</td>
                                                <td>
                                                    <input class="form-control" type="text" name="ON_LECT_NM" id="video_title" placeholder="강의 제목을 입력해주세요.">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>강의 설명</td>
                                                <td>
                                                    <input class="form-control" type="text" name="ON_LECT_CN" id="video_desc" placeholder="강의 설명을 입력해주세요.">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>파일 등록</td>
                                                <td>
                                                    <input class="form-control form-control-md" name="video_file" id="video_file" type="file">
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                        <div class="div-btn">
                                            <c:if test="${auth eq false}"><button class="btn btn-primary" type="button" id="btn-access">인증하기</button></c:if>
                                            <button class="btn <c:choose><c:when test='${auth eq true}'>btn-primary</c:when><c:otherwise>btn-secondary</c:otherwise></c:choose>" type="button" id="btn-upload" <c:if test="${auth eq false}">disabled</c:if>>동영상 등록</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <!-- A 본문 부분 -->
                            <div class="card-body">
                                <div>
                                    <!-- 실제 구성은 이곳에서 진행합니다. -->

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

<!-- Bootstrap core JavaScript-->
<script src="vendor/jquery/jquery.min.js"></script>
<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- Core plugin JavaScript-->
<script src="vendor/jquery-easing/jquery.easing.min.js"></script>
<!-- Custom scripts for all pages-->
<script src="js/sb-admin-2.min.js"></script>
<!-- Page level plugins -->
<script src="vendor/chart.js/Chart.min.js"></script>
<!-- Page level custom scripts -->
<script src="js/demo/chart-area-demo.js"></script>
<script src="js/demo/chart-pie-demo.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
        crossorigin="anonymous"></script>
</html>