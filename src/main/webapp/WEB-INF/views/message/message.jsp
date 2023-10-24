<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>쪽지 보내기</title>
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>
<style>
</style>
<script>
    $(function(){

        $("#id_check").click(function() {
            $.ajax({
                url : "/messageIdCheck", //데이터를 전송할 url
                type : "POST",
                data : { 'member_name' : $("#member_name").val() }, //서버에 전송할 데이터, key/value형태의 객체
                dataType : "json",
                success : function(data) {
                    if(data==1){
                        alert("확인되었습니다.");
                        $("#id_check").attr("disabled","disabled");
                        $("#member_name").attr("readonly","readonly");
                        $("#member_name").css("background-color", "#e2e2e2");
                    }else alert("닉네임을 확인해주세요");
                },
                error : function(xhr, status, error) { alert("error"); }
            });
        });
    });

    function null_ck(){
        let member_name = document.getElementById("member_name");
        let msg_title = document.getElementById("msg_title");
        let msg_content = document.getElementById("msg_content");

        if(member_name.value == "") alert("닉네임을 확인해주세요"); return false;
        if(msg_title.value == "") alert("제목을 입력해주세요"); return false;
        if(msg_content.value == "") alert("내용을 입력해주세요"); return false;
        if(member_name.getAttribute("readonly") != "readonly") alert("ID를 확인해주세요"); return false;
    }
</script>
<body>
<div class="banner" style="text-align: center;">
    <img src="/img/banner.png">
</div>
<form action="/message" method="post" onsubmit="return null_ck()">
    <div style="width: 700px; margin: 0 auto;">
        <div style="width: 680px; line-height: 40px; margin: 0 auto;">
            <h1>쪽지 보내기</h1>
            <div class="mt-4">
                <label for="member_name" style="float: left;">받는 사람</label>
                <input class="form-control" style="float: left; width: 490px; height: 40px; margin: 0px 0px 10px 10px;" type="text" id="member_name" name="member_name" onchange="ck()"placeholder="받는 사람 입력" value="${receiver }">
                <button class="btn btn-primary" style="float: left; width: 100px; height: 40px; margin-left: 10px;" id="id_check" type="button">ID 확인</button>
            </div>
            <div class="mt-3">
                <input class="form-control" style=" height: 40px; margin-bottom: 10px;" type="text" id="msg_title" name="msg_title" placeholder="제목">
                <textarea class="form-control" id="msg_content" name="msg_content" placeholder="쪽지 내용을 입력하세요." rows="10"></textarea>
            </div>
            <div class="mt-3">
                <button class="btn btn-primary" style="width: 100px; height: 40px; float: right;" type="submit">전송</button>
            </div>
        </div>
    </div>
</form>
</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
</html>