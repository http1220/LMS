<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
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

<script>

    function zoom_exit(){
        $(function() {
            $.ajax({
                url: '/zoom_exit',
                type: 'post',
                success : function(result) {
                    if(result = 1){
                        window.close();
                    }else{
                        alert("요청 실패 관리자 문의 바람.");
                        return false;
                    }
                },
                error : function(xhr) {
                    alert(xhr);
                    alert("요청 실패 재시도 바람.");
                }
            });
        });
    };

    function student_check(){
        $(function() {
            var attendance_list = [];/*출석 리스트*/
            var absence_list = [];/*결석 리스트*/

            $('input[name="attendance_check"]:checked').each(function() {
                attendance_list.push($(this).val());
            });

            $('input[name="absence_check"]:checked').each(function() {
                absence_list.push($(this).val());
            });
            $.ajax({
                type: 'post',
                url: '/attendance',
                data: {
                    "attendance_check" : attendance_list,
                    "absence_check" : absence_list
                },
                success: function(result) {

                },
                error: function(xhr, status, error) {
                    console.log(error);
                }
            });
        });
    };

    function zoom_join(){

        window.open('${Join_URL}',"zoom","width=1350, height=790");

    };


    function checkAttendance(checkbox) {
        var appl_no = checkbox.value;
        var attendanceCheck = document.getElementsByName('attendance_check');
        var absenceCheck = document.getElementsByName('absence_check');

        for (var i = 0; i < attendanceCheck.length+absenceCheck.length; i++) {
            if (attendanceCheck[i].value === appl_no && absenceCheck[i].checked) {
                absenceCheck[i].checked = false;
            }
        }

    }
    function checkAbsence(checkbox) {
        var appl_no = checkbox.value;
        var attendanceCheck = document.getElementsByName('attendance_check');
        var absenceCheck = document.getElementsByName('absence_check');

        for (var i = 0; i < attendanceCheck.length+absenceCheck.length; i++) {
            if (absenceCheck[i].value === appl_no && attendanceCheck[i].checked) {
                attendanceCheck[i].checked = false;
            }
        }
    }



</script>
    <style>
        .all_place{
            width: 800px;
            height: 700px;
            float: left;
        }

        .check_place{
            width:580px;
            height:700px;
            float: left;
        }

        .btn_place{
            margin-left: 10px;
            margin-right: 10px;
            width: 200px;
            height: 700px;
            float: left;
            text-align: center;
        }

        .check_btn{
            display: inline-block;
            margin-top: 10px;
            width: 150px;
            height: 40px;
            border-radius: 5px;
            border: none;
            color: white;
        }
    </style>
</head>
<body>
<div class="all_place">

    <div class="btn_place">
        <div class="schedule_card mb-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">수업 관리</h6>
                </div>
                <div class="card-body">
                    <div style="height: 600px;" class="chart-area">
                        <div>
                            <button onclick="zoom_join()" class="check_btn" style="background-color: #007bff">수업 시작</button>
                            <button onclick="zoom_exit()" class="check_btn" style="background-color: #dc3545">수업 종료</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="check_place">
        <div class="schedule_card mb-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">출석 체크</h6>
                </div>
                <!-- A 본문 부분 -->
                <div class="card-body">
                    <div style="height: 600px; overflow: auto;" class="chart-area">
                        <div>

                            <table class="table">
                                <thead>
                                <tr>
                                    <th scope="col">이름</th>
                                    <th scope="col">연락처</th>
                                    <th scope="col">이메일</th>
                                    <th scope="col">출석</th>
                                    <th scope="col">결석</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${student_list}" var="list">
                                <tr>
                                    <td>${list.KORN_FLNM}</td>
                                    <td>${list.TELNO}</td>
                                    <td>${list.EML_ADDR}</td>
                                    <th><input name="attendance_check" value="${list.APPL_NO}" type="checkbox" onclick="checkAttendance(this)"></th>
                                    <th><input name="absence_check" value="${list.APPL_NO}" type="checkbox" onclick="checkAbsence(this)"></th>
                                </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                            <button onclick="student_check()" class="check_btn" style="background-color: #6610f2">출석 체크</button>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</div>

<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="js/sb-admin-2.min.js"></script>

</body>
</html>