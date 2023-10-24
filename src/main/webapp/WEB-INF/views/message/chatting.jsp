<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>Chatting</title>
    <link rel="shortcut icon" href="img/pandora_logo.png" />
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
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
    <script type="text/javascript" src="/js/login/chatting.js"></script>
</head>
<style>
    body{ overflow-x:scroll; }
    .socketBtn{
        width:100px;
        height:40px;
        color:white;
        border:none;
        border-radius: 5px;
    }
    .BOX{
        border: 10px solid #E8C48F;
        padding: 20px;
        width:1100px;
        height:600px;

    }
    .messageBody{
        border:1px solid black;
        border-radius: 5px;
        min-width:10px;
        margin-top:5px;
        display: inline-block;
        padding:0px 5px 0px 5px;
        height:30px;
        line-height: 30px;
        color:black;
    }
    #messageBox{
        overflow-y:auto;
        text-align:right;
        width:1050px;
        height:500px;
        box-sizing: border-box;
        padding:0px 15px 0px 0px;
    }
    #messageList{
        overflow-y:auto;
        width:100%;
        min-height:400px;
        box-sizing: border-box;
        padding-left:22px;
    }
    .messageName{
        font-weight: bold;
        margin-top:5px;
    }
    .messageText{
        width:1080px;
        height:60px;
        margin-left:10px;
        font-size:20px;
        border:none;
        background-color: #f6f6f6;
    }
    .none{
        border-top:2px solid black;
        margin-left:-20px;
    }
    .time{ display: inline-block; margin:0px 5px;}
</style>
<script>
    const name = "${sessionScope.name}";
    $(function(){
        $("#msg").on('keypress', function(e){
            if(e.keyCode == 13){
                let msg = document.getElementById("msg").value;
                if(msg.replace(/ /gi,"") == ""){
                    alert("글을 입력하세요");
                    return false;
                }else{
                    let date = new Date();
                    var json = {
                        "type":"message",
                        "userName":name,
                        "msg":msg,
                        "time":date.getHours()+":"+date.getMinutes()
                    }
                    wsmsg.send(JSON.stringify(json));
                    // wsmsg.send(name+":"+msg);
                    document.getElementById("msg").value = "";
                }
            }
        });
    });
    function disconnect(){
        var json = {
            "type":"message",
            "userName":name,
            "msg" : " "
        }
        wsmsg.send(JSON.stringify(json));
        wsmsg.close();
        wslist.send(name+"님이 나가셨습니다.");
        wslist.close();

    }
</script>
<style></style>
<body id="page-top" onbeforeunload="return disconnect()"><!-- 페이지이동 이벤트 감지 -->
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
            <div class="container-fluid" style="width:1300px; min-height:600px; margin-top:100px;">
                <h1 style="font-weight: bold; text-align: center; width:1200px; margin-top:-40px;">Chatting Room</h1>
                <div class="d-sm-flex align-items-center justify-content-between mb-4" style=" margin-top:50px; text-align: center;">
                    <!--수정할 부분 시작-->

                    <!-- 채팅 box -->
                    <div class="BOX">
                        <div id="messageBox"></div>
                        <input type="text" class="messageText none" placeholder="Press Enter for send message.( 100 characters )" id="msg" maxlength="100">
                    </div>
                    <!-- 참여인원 box -->
                    <div style="width:200px; height:600px; border: 10px solid #E8C48F; border-left:none; overflow-y:auto;">
                        <div style="font-size: 17px; font-weight: bold;padding:5px 0px; border-bottom: 10px solid #E8C48F;">현재 참여인원</div>
                        <div id="messageList"></div>
                    </div>

                    <!--수정할 부분 끝-->
                </div>
            </div><!--End of container -->
        </div><!-- End of Main Content -->
        <!-- footer -->
        <%@include file="../footer.jsp" %>
    </div><!-- End of Content Wrapper -->
</div> <!-- End of Page Wrapper -->

<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="js/sb-admin-2.min.js"></script>

</body>
</html>
