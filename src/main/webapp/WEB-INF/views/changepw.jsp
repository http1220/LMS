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
			���ο� ��й�ȣ�� �Է��ϼ��� <br> 
			<input type="hidden" name="userid" value="${attr }" /> 
			
			�� ��й�ȣ 
			<input type="password" name="pw" id="p1" />
			<br> 
			��й�ȣ Ȯ�� 
			<input type="password" id="p2" /> <br>
			<button id="btn" type="button">�� ��й�ȣ�� �����ϱ�</button>
		</form>
	</div>
</body>
<script>
document.getElementById("btn").addEventListener("click", function(event) {
	  var pw1 = document.getElementById("p1").value;
	  var pw2 = document.getElementById("p2").value;

	  if (pw1 === pw2) {
	    // ��й�ȣ�� ��ġ�ϴ� ��쿡 ������ �ڵ�
	    document.getElementById("myForm").submit(); // �� ���� ����
	  } else {
	    // ��й�ȣ�� ��ġ���� �ʴ� ��쿡 ������ �ڵ�
	    alert("��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
	    document.getElementById("p1").value = ""; // ù ��° ��й�ȣ �ʱ�ȭ
	    document.getElementById("p2").value = ""; // �� ��° ��й�ȣ �ʱ�ȭ
	    event.preventDefault(); // �� ���� ����
	  }
	});

</script>
</html>