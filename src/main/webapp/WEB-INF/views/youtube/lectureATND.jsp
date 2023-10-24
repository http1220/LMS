<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Pandora University - LMS</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <link href="css/sb-admin-2.min.css" rel="stylesheet">
    <link href="css/logo.css" rel="stylesheet">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
</head>
<body id="page-top">
<h1>
    ${atndInfo[0].SBJCT_NM}
</h1>
<table class="table table-bordered">
    <thead>
        <tr>
            <th>이름</th>
            <c:forEach var="week" begin="1" end="${clsCdCount}">
            <th>${week} 주차</th>
            </c:forEach>
        </tr>
    </thead>
    <tbody>
    <c:forEach items="${applList}" var="appl" varStatus="applStatus">
        <tr>
            <td>${appl}</td>
            <c:forEach begin="0" end="${clsCdCount - 1}" varStatus="atndStatus">
                <td>
                    <c:choose>
                        <c:when test="${atndInfo[applStatus.index * clsCdCount + atndStatus.index].ATND eq '출석'}">
                            <b style="color: blue;">${atndInfo[applStatus.index * clsCdCount + atndStatus.index].ATND}</b>
                        </c:when>
                        <c:otherwise>
                            <b style="color: red;">${atndInfo[applStatus.index * clsCdCount + atndStatus.index].ATND}</b>
                        </c:otherwise>
                    </c:choose>
                </td>
            </c:forEach>
        </tr>
    </c:forEach>
    </tbody>
</table>

<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="js/sb-admin-2.min.js"></script>
</body>
</html>