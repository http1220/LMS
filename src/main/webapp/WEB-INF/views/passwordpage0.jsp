<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>

<script>
window.onload = function(){
	${msg}
	alert("${msg}");

}
</script>
<style>

.a1 {
  width : 800px;
  background-color : #f0f0f0;
  flex-flow : column;
  margin : 0 auto;
  text-align : center;
}

</style>
<body>
  <div class="a1">
    <div class="a2">
    ��й�ȣ�� ã�����ϴ� ���̵� �Է����ּ���.
      </div>
    <br>
<form action = "/pwreset/request" method="post">
  <div>
  <label for = idbx> ���̵� : </label>
  <input type="text" name="id" id="idbx"/>
  </div>
  <div>
    <br>
	<button class="btn">����</button>
  </div>
</form>
  </div>
</body>
</body>
</html>