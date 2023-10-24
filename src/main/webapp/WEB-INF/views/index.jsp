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
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <link type="text/css" rel="stylesheet" href="css/Notice.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN"
            crossorigin="anonymous"></script>
    <title>Pandora University - LMS</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">
    <link href="css/logo.css" rel="stylesheet">

    <%-- ==================full캘린더================== --%>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.5/index.global.min.js"></script>
    <%-- ==================full캘린더================== --%>
    <script>

        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                selectable: true,
                select: function(info) {
                    var startDate = info.startStr;/*일정 시작일*/
                    var endDate = info.endStr;/*일정 종료일*/

                    var eventTitle = prompt('이벤트 제목을 입력하세요');

                    if (eventTitle) {
                        var event = {
                            title: eventTitle,
                            start: startDate,
                            end: endDate
                        };

                        calendar.addEvent(event);

                        // AJAX 요청 보내기
                        saveEventToServer(event);
                    }

                    calendar.unselect();


                },

                eventClick: function(info) {
                    // 모달 창 띄우기
                    var modal = document.getElementById("myModal");
                    var eventTitleElement = document.getElementById("eventTitle");
                    var deleteButton = document.getElementById("deleteButton");
                    var closeButton = document.getElementById("close_btn");
                    var eventTitle = document.getElementById("eventInput");


                    eventTitleElement.innerText = "이벤트명: " + info.event.title;
                    modal.style.display = "block";

                    // 이벤트 삭제 버튼 클릭 시
                    deleteButton.addEventListener("click", function() {

                        info.event.remove();

                        // AJAX 요청 보내기
                        deleteEventFromServer(info.event);

                        // 모달 창 닫기
                        modal.style.display = "none";
                    },{once:true});

                    // 모달 창 'x' 버튼 클릭 시
                    closeButton.addEventListener("click", function() {
                        modal.style.display = "none";
                    });

                    saveButton.style.display = "none";/*저장 버튼 숨기기*/
                    eventTitle.style.display = "none";/*입력 공간 숨기기*/
                }
            });

            calendar.render();

            function saveEventToServer(event) {
                // AJAX 요청 코드 작성
                $.ajax({
                    url: '/save_event',
                    method: 'POST',
                    data: event,
                    success: function(response) {
                        console.log('이벤트가 성공적으로 서버에 저장되었습니다.');
                    },
                    error: function(xhr, status, error) {
                        console.error('이벤트를 서버에 저장하는 중에 오류가 발생했습니다:', error);
                    }
                });
            }

            function deleteEventFromServer(event) {
                $.ajax({
                    url: '/delete_event',
                    method: 'POST',
                    data: { eventId: event.id },
                    success: function(response) {
                        console.log('이벤트가 성공적으로 서버에서 삭제되었습니다.');
                    },
                    error: function(xhr, status, error) {
                        console.error('이벤트를 서버에서 삭제하는 중에 오류가 발생했습니다:', error);
                    }
                });
            }
        });


        function Zoom_Join(){
        $(function() {
            $.ajax({
                url: '/zoom_join',
                type: 'post',
                data: { "sbjct_no" : 2 },
                dataType: 'text',
                success : function(result) {
                    if(result != ""){
                        window.open(result, "Zoom_join", "width=1350, height=790");
                    }else{
                        alert("수업 시작 안함");
                        return false;
                    }
                },
                error : function(xhr) {
                    alert(xhr);
                    alert("요청 실패 재시도 바람.");
                }
            });
        });

    }

    </script>
    <style>
        #calendar {
            width: 90%;
            height: 500px;
            margin: 0 auto;
        }

        .main_content {
            width: 1500px;
            float: left;
        }

        .main_left {
            width: 800px;
            float: left;
        }

        .notice_card {
            width: 785px;
            height: 150px;
        }

        .schedule_card {
            width: 785px;
        }

        .main_right {
            width: 630px;
        }
        .none{ font-size:14px; }
        .none:hover{ background-color: #cccccc; }

        /*===== 모달 창 스타일 ===== */
        /* .modal {
            display: none;
            position: fixed;
            z-index: 1;
            padding-top: 100px;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0,0,0);
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 30%;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        } */
        /* =================================== */
    </style>
</head>

<body id="page-top">
<!-- Page Wrapper -->
<div id="wrapper">

    <%-- 네비게이션 바 --%>
    <%@include file="navbar.jsp" %>

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

        <!-- 메인 컨텐츠 -->
        <div id="content">
            <%-- 탑 바 --%>
            <%@include file="top.jsp" %>

            <!-- 본문 컨텐츠 부분 시작 -->
            <div class="container-fluid">

                <c:if test="${ division == 20 }">
                <!-- 페이지 헤드 부분 -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">교수</h1>
                </div>
                </c:if>

                <c:if test="${ division == 10 }">
                    <!-- 페이지 헤드 부분 -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">학생</h1>
                    </div>
                </c:if>

                <!-- 컨텐츠 탑 부분 -->
                <div class="main_content"><%--main_left--%>
                    <div class="main_left">
                        <!-- 학사 공지 -->
                        <div class="notice_card mb-4">
                            <div class="card border-left-primary shadow h-100 py-2" style="min-height:370px;">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2" >
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">공지사항 최신글</div><br>
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                <table class="table">
                                                    <tr class="table_header">
                                                        <td class="col-1" style="text-align: center;">번호</td>
                                                        <td class="col-4" style="text-align: center;">제목</td>
                                                        <td class="col-2" style="text-align: center;">작성자</td>
                                                        <td class="col-2" style="text-align: center;">조회수</td>
                                                        <td class="col-2" style="text-align: center;">등록일</td>
                                                    </tr>
                                                    <c:forEach var="notice" items="${list }">
                                                        <tr class="none">
                                                            <td>${notice.rowNum }</td>
                                                            <td class="title text-truncate" style="max-width:1px; text-align: left;">
                                                                <a href="/noticeDetail?rowNum=${notice.rowNum }&totalCnt=${totalCount}">${notice.notice_title }</a>
                                                            </td>
                                                            <td>${notice.admin_id }</td>
                                                            <td>${notice.notice_read }</td>
                                                            <td>${notice.notice_date }</td>
                                                        </tr>
                                                    </c:forEach>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 학사일정 -->
                        <div class="schedule_card mb-4" style="margin-top:230px;">
                            <div class="card shadow mb-4">
                                <!-- A 카드 설정 버튼 부분 -->
                                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">학습지원 안내</h6>
                                </div>
                                <!-- A 본문 부분 -->
                                <div class="card-body">
                                    <div style="height: 140px;" class="chart-area">
                                        <div>
											<ul class="table" style="list-style: none; margin:0; padding:0; font-weight: bold;">
												<li style="text-align: left; font-size: 18px; height:35px; line-height: 35px;">
													<a href="/noticeDetail?rowNum=7&totalCnt=${totalCount}">[모집] TOEIC 정기시험 고사장 준비 및 진행 보조 아르바이트</a>
												</li>
                                                <li style="text-align: left; font-size: 18px; height:35px; line-height: 35px;">
													<a href="/noticeDetail?rowNum=8&totalCnt=${totalCount}">[1차 모집] 2023년 경기도 청년 복지포인트</a>
												</li>
                                                <li style="text-align: left; font-size: 18px; height:35px; line-height: 35px;">
													<a href="/noticeDetail?rowNum=8&totalCnt=${totalCount}">[나라키움 남양주복합청사] 행복주택 제2차 입주자 모집</a>
												</li>
                                                <li style="text-align: left; font-size: 18px; height:35px; line-height: 35px;">
													<a href="/noticeDetail?rowNum=10&totalCnt=${totalCount}">2023 KBO-NINE 프로그램」모집 안내</a>
												</li>
											</ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%--main_left--%>
                    <!-- 컨텐츠 탑 부분 끝 -->
                    <div class="row">
                        <!-- 캘린더 -->
                        <div class="main_right">
                            <div class="card shadow mb-4">
                                <!-- B 카드 설정 버튼 부분 -->
                                <div
                                        class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">캘린더</h6>
<!-- 수정 -->
<!--                                     <div class="dropdown no-arrow"> -->
<!--                                         <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" -->
<!--                                            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> -->
<!--                                             <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i> -->
<!--                                         </a> -->
<!--                                         <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in" -->
<!--                                              aria-labelledby="dropdownMenuLink"> -->
<!--                                             <div class="dropdown-header">필요한가 ?</div> -->
<!--                                             <a class="dropdown-item" href="#">필요하나요?</a> -->
<!--                                             <a class="dropdown-item" href="#">필요 합니까?</a> -->
<!--                                             <div class="dropdown-divider"></div> -->
<!--                                             <a class="dropdown-item" href="#">아아아ㅏ아아아아</a> -->
<!--                                         </div> -->
<!--                                     </div> -->
                                </div>

                                <div style="margin:5px; padding:0; height: 550px;" class="card-body">
                                    <div class="chart-pie pt-4 pb-2">
                                        <%--본문 내용 작성하는 부분--%>
                                            <div id="calendar"></div>

                                            <div id="myModal" class="modal">
                                                <div class="modal-content">
                                                    <span id="close_btn" class="close">&times;</span>
                                                    <p id="eventTitle"></p>
                                                    <input type="text" id="eventInput" placeholder="이벤트 제목을 입력하세요">
                                                    <button id="saveButton">저장</button>
                                                    <button id="deleteButton">이벤트 삭제</button>
                                                </div>
                                            </div>
                                            <%--본문 내용 작성하는 부분--%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 진도율 카드 -->
                    <div class="row">
<!--                         Content Column -->
                        <div class="col-lg-5 mb-4">
<!--                             진도율 -->
                            <div class="card shadow mb-4" >
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">진도율</h6>
                                </div>
                                <div class="card-body">
                                <c:forEach items="${lecture }" var="i">
                                
                                    <h4 class="small font-weight-bold">${i.SBJCT_NM }
                                        <span class="float-right">${i.LECT_MAG }%</span></h4>
                                    <div class="progress mb-4">
                                        <div class="progress-bar bg-danger" role="progressbar" style="width: ${i.LECT_MAG }%"
                                             aria-valuenow="20" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
								</c:forEach>
                                    
<!--                                     <h4 class="small font-weight-bold">파이썬 <span -->
<!--                                             class="float-right">40%</span></h4> -->
<!--                                     <div class="progress mb-4"> -->
<!--                                         <div class="progress-bar bg-warning" role="progressbar" style="width: 40%" -->
<!--                                              aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div> -->
<!--                                     </div> -->
                                    
                                    
<!--                                     <h4 class="small font-weight-bold">자바 스크립트<span -->
<!--                                             class="float-right">60%</span></h4> -->
<!--                                     <div class="progress mb-4"> -->
<!--                                         <div class="progress-bar" role="progressbar" style="width: 60%" -->
<!--                                              aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div> -->
<!--                                     </div> -->
                                    
                                    
<!--                                     <h4 class="small font-weight-bold">HTML<span -->
<!--                                             class="float-right">80%</span></h4> -->
<!--                                     <div class="progress mb-4"> -->
<!--                                         <div class="progress-bar bg-info" role="progressbar" style="width: 80%" -->
<!--                                              aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div> -->
<!--                                     </div> -->
                                    
                                    
<!--                                     <h4 class="small font-weight-bold">진행율<span -->
<!--                                             class="float-right">Complete!</span></h4> -->
<!--                                     <div class="progress"> -->
<!--                                         <div class="progress-bar bg-success" role="progressbar" style="width: 100%" -->
<!--                                              aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div> -->
<!--                                     </div> -->
                                    
                                    
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-6 mb-4">
                        <!-- 식단 -->
                            <div style="width: 785px;" class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">식단표</h6>
                                </div>
                                <div>
                                    <img style="height: 329px; width: 650px; margin: 10px 62.5px 10px 62.5px" src="/img/pandora_rise.png">
                                </div>
                            </div>
                        </div>
                    </div>

                </div><!-- 메인 컨텐츠 끝 -->

            </div><!-- End of Main Content -->



        </div><!-- End of Content Wrapper -->

        <!-- Footer -->
        <%@include file="footer.jsp" %>

    </div><!-- End of Page Wrapper -->

    <!-- Scroll to Top Button -->
    <a class="scroll-to-top rounded" href="#page-top">
        <i class="fas fa-angle-up"></i>
    </a>

    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="js/sb-admin-2.min.js"></script>

</body>
</html>