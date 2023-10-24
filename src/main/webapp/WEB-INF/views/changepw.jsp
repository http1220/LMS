<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<style>
.a1 {
	width: 800px;
	background-color: #f0f0f0;
	flex-flow: column;
	margin: 0 auto;
	text-align: center;
}
</style>
<body>
	<div class="a1">
		<form action="/pwreset/changepw" method="post" id="myForm">
			새로운 비밀번호를 입력하세요 <br> 
			<input type="hidden" name="userid" value="${attr }" /> 
			
			새 비밀번호 
			<input type="password" name="pw" id="p1" />
			<br> 
			비밀번호 확인 
			<input type="password" id="p2" /> <br>
			<button id="btn" type="button">새 비밀번호로 저장하기</button>
		</form>
	</div>
</body>
<script>
document.getElementById("btn").addEventListener("click", function(event) {
	  var pw1 = document.getElementById("p1").value;
	  var pw2 = document.getElementById("p2").value;

	  if (pw1 === pw2) {
	    // 비밀번호가 일치하는 경우에 실행할 코드
	    document.getElementById("myForm").submit(); // 폼 전송 실행
	  } else {
	    // 비밀번호가 일치하지 않는 경우에 실행할 코드
	    alert("비밀번호가 일치하지 않습니다.");
	    document.getElementById("p1").value = ""; // 첫 번째 비밀번호 초기화
	    document.getElementById("p2").value = ""; // 두 번째 비밀번호 초기화
	    event.preventDefault(); // 폼 전송 중지
	  }
	});

</script>
</html>