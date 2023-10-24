<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>Message Box</title>
    <link rel="shortcut icon" href="img/pandora_logo.png" />
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN"
            crossorigin="anonymous"></script>
    <script type="text/javascript" src="/js/NoticePaging.js"></script>
<!-- <%--    <script type="text/javascript" src="/js/search.js"></script>--%> -->
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

</head>
<style>
    .container0 { display: flex; font-size: 12px; }
    /*.table{ min-height:500px; }*/
    .msgBox_detail {
        display: inline-block;
        width: 400px;
        height: 600px;
        box-sizing: border-box;
    }
    .msg_detail {
        display: inline-block;
        width: 100%;
        height: 47px;
        line-height: 47px;
        font-size: 15px;
        font-weight: bold;
        border: 1px solid #d3d3d3;
        box-sizing: border-box;
    }
    .msg_content {
        font-size: 20px;
        width: 100%;
        height: 550px;
        box-sizing: border-box;
        font-weight: bold;
        border: 1px solid #d3d3d3;
        background-color: #fafafa;
    }
    .pagingBox { width: 100%; }
    .write_btn {
        width: 30px;
        background-color: #ff3d3d;
        height: 30px;
    }
    .title{ text-align: left; }
</style>
<script>
    $(function () {

        $("#msgBox_detail").hide();
        let prev = -1;

        $(".message").click(function () {
            let msgNo = $(this).attr("value");
            console.log($(".msg_content" + msgNo).val());
            $("#msg_content").val($(".msg_content" + msgNo).val());
            if (msgNo == prev) $("#msgBox_detail").toggle();
            else $("#msgBox_detail").show();
            prev = msgNo;

            $.ajax({
                type: "POST",
                url: "/msgRead",
                data: {'msgNo': msgNo },
                dataType: "json",
                success: function (data) {
                    if (data == 1) $(".msgread" + msgNo).load(location.href + " .msgread" + msgNo);
                },
                error: function (xhr, status, error) { alert("실패"); }
            });
        });
        $(".del").click(function () {
            if (confirm("삭제하시겠습니까?")) {
                let del = $(this).val();
                $.post({
                    url: "msgDel",
                    data: {'msgNo': del }
                }).done(function (data) { document.location.reload();
                }).fail(function (xhr, status, error) { alert("실패"); });
            }
        });
    });
    function moveNext(pageNo) {	//페이지 뒤쪽 버튼
        let searchType = document.getElementById("searchType");
        let searchValue = document.getElementById("searchValue");
        let url = document.location.href.split("?", 1);

        if (pageNo > ${pages.lastPage }) return false;
        else if (pageNo != ${pages.lastPage }) {
            if ((searchType.value != null && searchType.value != "none") && searchValue.value != null) {
                location.href = url + "?searchType=" + searchType.value + "&searchValue=" + searchValue.value + "&pageNo=" + (pageNo + 1);
            } else location.href = "/notice?pageNo=" + (pageNo + 1);

        } else if (pageNo == ${pages.lastPage }) {
            if ((searchType.value != null && searchType.value != "none") && searchValue.value != null) {
                location.href = url + "?searchType=" + searchType.value + "&searchValue=" + searchValue.value + "&pageNo=" + pageNo;
            } else location.href = "/notice?pageNo=" + pageNo;
        }
    }
</script>
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
            <div style="background-color: #2a96a5; width:100%; height:200px;">
                <div style="width:1200px;height:200px; margin:0 auto; text-align: center;">
                    <h1 class="mb-0" style="width:1200px;height:200px;font-weight:bold; color:white; line-height: 200px;">쪽지함</h1>
                </div>
            </div>
            <div class="container-fluid" style="width:1200px; min-height:800px; margin-top:50px;">
                <div class="d-sm-flex align-items-center justify-content-between mb-4" style=" margin-top:50px; text-align: center;">
                    <!--수정할 부분 시작-->
                    <div class="content">
                        <div class="container0">
                            <div class="msgBox_board">

                                <table class="table" style="color:black; font-size: 15px; width:800px;">
                                    <tr class="table-header">
                                        <th class="col-1">번호</th>
                                        <th class="col-2">보낸사람</th>
                                        <th class="col-3">제목</th>
                                        <th class="col-2">날짜</th>
                                        <th class="col-1">읽음</th>
                                        <th class="col-1">삭제</th>
                                    </tr>
                                    <c:forEach var="msg" items="${list }">
                                        <tr style="cursor: pointer;" class="message" value="${msg.message_no }">
                                            <td>${msg.rowNum }</td>
                                            <td>${msg.post_user_id }</td>
                                            <td class="title">${msg.message_title }</td>
                                            <td>${msg.message_time }</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${msg.read_or_not eq  'false' }"><b class="msgread${msg.message_no }" style="color:red;">x</b></c:when>
                                                    <c:otherwise><b class="msgread${msg.message_no }" style="color:blue; text-align: center;">o</b></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button class="write_btn del" value="${msg.message_no }"><i class="xi-trash-o xi-x"></i></button>
                                            </td>
                                            <input type="hidden" class="msg_content${msg.message_no }" value="${msg.message_content }">
                                        </tr>
                                    </c:forEach>
                                </table>
                                <br><br>
                                <!-- 페이징 -->
                                <div class="pagingBox">
                                    <ul class="pagingList">
                                        <li class="pageNo page_btn" onclick="moveBefore(1)"><i class="xi-backward xi-x"></i></li>
                                        <li class="pageNo page_btn" onclick="moveBefore(${pageNo})"><i class="xi-step-backward xi-x"></i></li>
                                        <c:forEach var="i" begin="${Math.floor((pageNo-1)/10)*10+1 }" end="${Math.floor((pageNo-1)/10)*10 +10 gt pages.lastPage ? pages.lastPage : Math.floor((pageNo-1)/10)*10 +10}">
                                            <li class="pageNo" onclick="move(${i })" <c:if test="${pageNo eq i }">style="color:red; font-weight: bold;"</c:if>>${i }</li>
                                        </c:forEach>
                                        <li class="pageNo page_btn" onclick="moveNext(${pageNo})"><i class="xi-step-forward xi-x"></i></li>
                                        <li class="pageNo page_btn" onclick="moveNext(${pages.lastPage })"><i class="xi-forward xi-x"></i></li>
                                    </ul>
                                </div>
                                <!-- 페이징 끝 -->
                                <br>
                                <div class="searchForm">
                                    <form action="" method="get" id="searchForm">
                                        <select name="searchType" id="searchType" style="height:30px;">
                                            <option value="title">제목</option>
                                            <option value="writer" <c:if test='${pages.searchType eq "writer"}'>selected</c:if>>보낸사람</option>
                                        </select>
                                        <input type="text" name="searchValue" id="searchValue" style=" font-size:15px; width:350px; height:30px;" value="${pages.searchValue }">
                                        <button class="search_btn">검색</button>
                                    </form>
                                </div>
                            </div>
                            <!-- message content -->
                            <div class="msgBox_detail" id="msgBox_detail">
                                <span class="msg_detail">내용</span>
                                <textarea style="border-radius: 0px 0px 20px 20px;" readonly="readonly" class="msg_content" id="msg_content"></textarea>
                            </div>
                        </div>
                    </div>
                    <!--수정할 부분 끝-->
                </div>
            </div><!-- End of container -->
        </div><!-- End of Main Content -->
        <!-- footer -->
        <%@include file="../footer.jsp" %>
    </div><!-- End of Content Wrapper -->
</div> <!-- End of Page Wrapper -->

<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="js/sb-admin-2.min.js"></script>

</body>
</html>
