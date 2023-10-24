<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="joinProc" method="post">
  <label for="user-id">User ID:</label>
  <input type="text" id="user-id" name="USER_ID" required><br>

  <label for="password">Password:</label>
  <input type="password" id="password" name="PSWD" required><br>

  <label for="korn-flnm">KORN FLNM:</label>
  <input type="text" id="korn-flnm" name="KORN_FLNM" required><br>

  <label for="user-brdt">User BRDT:</label>
  <input type="date" id="user-brdt" name="USER_BRDT" required><br>

  <label for="email">Email:</label>
  <input type="email" id="email" name="EML_ADDR" required><br>

  <label for="telno">Tel No:</label>
  <input type="tel" id="telno" name="TELNO" required><br>

  <label for="user-group-cd">User Group CD:</label>
  <input type="text" id="user-group-cd" name="USER_GROUP_CD" required><br>

  <input type="submit" value="Submit">
</form>

</body>
</html>