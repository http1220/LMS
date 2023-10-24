
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
function ch(){
if (location.protocol === "https:") {
	  console.log("현재 페이지는 HTTPS 프로토콜을 사용합니다.");
	} else {
	  console.log("현재 페이지는 HTTPS 프로토콜을 사용하지 않습니다.");
	}
}
ch();


function submit_info(element) {
  var username = element.parentNode.parentNode.querySelector('input[name="username"]').value;
  var password = element.parentNode.parentNode.querySelector('input[name="password"]').value;
 		if (/^\d{8}$/.test(username)) {	   	
 		} else {
 		   alert("숫자 8자리를 입력해주세요.");
 		   return;
 		}
  var form = document.createElement('form');
  form.action = '/login';
  form.method = 'post';

  var input1 = document.createElement('input');
  input1.type = 'hidden';
  input1.name = 'username';
  input1.value = username;

  var input2 = document.createElement('input');
  input2.type = 'hidden';
  input2.name = 'password';
  input2.value = password;

  form.appendChild(input1);
  form.appendChild(input2);

  document.body.appendChild(form);

  form.submit();
	  }

</script>
<style>
body{
  margin:0;
  color:#6a6f8c;
  background:#c8c8c8;
  font:600 16px/18px 'Open Sans',sans-serif;
}
*,:after,:before{box-sizing:border-box}
.clearfix:after,.clearfix:before{content:'';display:table}
.clearfix:after{clear:both;display:block}
a{color:inherit;text-decoration:none}

.login-wrap{
  width:100%;
  margin:auto;
  max-width:525px;
  min-height:670px;
  position:relative;
  background:url(https://raw.githubusercontent.com/khadkamhn/day-01-login-form/master/img/bg.jpg) no-repeat center;
  box-shadow:0 12px 15px 0 rgba(0,0,0,.24),0 17px 50px 0 rgba(0,0,0,.19);
}
.login-html{
  width:100%;
  height:100%;
  position:absolute;
  padding:90px 70px 50px 70px;
  background:rgba(40,57,101,.9);
}
.login-html .student,
.login-html .professor{
  top:0;
  left:0;
  right:0;
  bottom:0;
  position:absolute;
  transform:rotateY(180deg);
  backface-visibility:hidden;
  transition:all .4s linear;
}
.login-html .sign-in,
.login-html .sign-up,
.login-form .group .check{
  display:none;
}
.login-html .tab,
.login-form .group .label,
.login-form .group .button{
  text-transform:uppercase;
}
.login-html .tab{
  font-size:22px;
  margin-right:15px;
  padding-bottom:5px;
  margin:0 15px 10px 0;
  display:inline-block;
  border-bottom:2px solid transparent;
}
.login-html .sign-in:checked + .tab,
.login-html .sign-up:checked + .tab{
  color:#fff;
  border-color:#1161ee;
}
.login-form{
  min-height:345px;
  position:relative;
  perspective:1000px;
  transform-style:preserve-3d;
}
.login-form .group{
  margin-bottom:15px;
}
.login-form .group .label,
.login-form .group .input,
.login-form .group .button{
  width:100%;
  color:#fff;
  display:block;
}
.login-form .group .input,
.login-form .group .button{
  border:none;
  padding:15px 20px;
  border-radius:25px;
  background:rgba(255,255,255,.1);
}
.login-form .group input[data-type="password"]{
  text-security:circle;
  -webkit-text-security:circle;
}
.login-form .group .label{
  color:#aaa;
  font-size:12px;
}
.login-form .group .button{
  background:#1161ee;
}
.login-form .group label .icon{
  width:15px;
  height:15px;
  border-radius:2px;
  position:relative;
  display:inline-block;
  background:rgba(255,255,255,.1);
}
.login-form .group label .icon:before,
.login-form .group label .icon:after{
  content:'';
  width:10px;
  height:2px;
  background:#fff;
  position:absolute;
  transition:all .2s ease-in-out 0s;
}
.login-form .group label .icon:before{
  left:3px;
  width:5px;
  bottom:6px;
  transform:scale(0) rotate(0);
}
.login-form .group label .icon:after{
  top:6px;
  right:0;
  transform:scale(0) rotate(0);
}
.login-form .group .check:checked + label{
  color:#fff;
}
.login-form .group .check:checked + label .icon{
  background:#1161ee;
}
.login-form .group .check:checked + label .icon:before{
  transform:scale(1) rotate(45deg);
}
.login-form .group .check:checked + label .icon:after{
  transform:scale(1) rotate(-45deg);
}
.login-html .sign-in:checked + .tab + .sign-up + .tab + .login-form .student{
  transform:rotate(0);
}
.login-html .sign-up:checked + .tab + .login-form .professor{
  transform:rotate(0);
}

.hr{
  height:2px;
  margin:60px 0 50px 0;
  background:rgba(255,255,255,.2);
}
.foot-lnk{
  text-align:center;
}
</style>
</head>
<body>
<c:if test="${not empty sc}">
${sc}
</c:if>
<div class="login-wrap">
  <div class="login-html">
    <input id="tab-1" type="radio" name="tab" class="sign-in" checked><label for="tab-1" class="tab">학생</label>
    <input id="tab-2" type="radio" name="tab" class="sign-up"><label for="tab-2" class="tab">교수</label>
    <div class="login-form">
      <div class="student">
        <div class="group">
          <label for="user" class="label">학번</label>
          <input name="username" type="text" class="input" maxlength="8"/>
        </div>
        <div class="group">
          <label for="pass" class="label">비밀번호</label>
          <input name="password" type="password" class="input" data-type="password" onkeydown="if (event.keyCode === 13) submit_info(this)"/>
          
        </div>
        <div class="group">
          <input id="check" type="checkbox" class="check" checked>
          <label for="check"><span class="icon"></span> Keep me Signed in</label>
        </div>
        <div class="group">
          <input type="button" class="button" value="들어가기" onclick="submit_info(this)"/>
        </div>
        <div class="hr"></div>
        <div class="foot-lnk">
          <a href="#forgot">비밀번호를 잊으셨나요?</a>
        </div>
      </div>
      <div class="professor">
        <div class="group">
          <label for="user" class="label">교수코드</label>
          <input name="username" type="text" class="input"/>
        </div>
        <div class="group">
          <label for="pass" class="label">비밀번호</label>
          <input name="password" type="password" class="input" data-type="password" onkeydown="if (event.keyCode === 13) submit_info(this)"/>
        </div>
        
        <div class="group">
          <input type="button" class="button" value="들어가기" onclick="submit_info(this)"/>
        </div>
        <div class="hr"></div>
        <div class="foot-lnk">
          <label for="tab-1">비밀번호를 잊으셨나요?</a>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>