<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.modal_search{
height: 195px;
}
.modal_search > div {
width: 138px;
line-height: 26px;
position: relative;
top: 6px;
}
.modal_search > input {
width: 270px;
min-width: 170px;
position: relative;
top: -1px;
margin: 5px;
}
.red{
color: red;
height: 30px;
font-size: 14px;
}
.float{
float: none;
}
.center{
text-align: center;
position: relative;
top: 10px;
}
.wide{
width: 110px;
}
.top{
position: relative;
top: 10px;
}
.topTo{
position: relative;
top: 5px;
}
</style>
<div id="modal_password" class="modal_password">
	<div class="modal_top_bar">사용자암호변경</div>
	<div class="modal_main">
		<div class="red">
		※ 현재비밀번호를 입력한 후 새로 사용할 비밀번호를 입력하세요.
		</div>
			<form id="studentsModal_form">
				<div class="main_container_search modal_search">
					<div>사용자ID</div>
					<input value="${id}" disabled>
					<div>사용자명</div>
					<input value="${name}" disabled>
					<div>현재 비밀번호</div>
					<input>
					<div>새 비밀번호 입력</div>
					<input>
					<div>새 비밀번호 확인</div>
					<input>
				</div>
			</form>
		<div class="modal_main_btn center">
			<input type="submit" value="비밀번호 변경" id="" class="search_btn noMargin float wide" onclick="">
			<input type="submit" value="닫기" id="close_btn_modal" class="search_btn noMargin float" onclick="close_modal(modal_password)">
		</div>
		<div class="red top">
		※ 비밀번호는 8~15자 이상 영문, 숫자, 특수문자를 사용하세요.<br>
		</div>
		<div class="red topTo">
		※ 특수문자는 .(마침표) ,(쉼표) &(앤드) ?(물음표) -(하이픈)은 사용불가. 
		</div>
	</div>
</div>