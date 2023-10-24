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
		<div class="a2">등록된 이메일로 전송된 인증번호를 입력해주세요</div>
		<br>
		<form action="/pwreset/checkrequest" method="post">
			<input type="text" name="key" /> <input type="hidden" name="userid"
				value="${attr }" />
			<button>인증번호 확인</button>
		</form>
	</div>
</body>

</html>