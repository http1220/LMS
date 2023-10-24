<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.narrow{
width: 940px;
float: left;
margin-right: 10px;
}
.narrow2{
width: 225px;
float: left;
}
</style>
<script type="text/javascript">
$(document).ready( function() {
	$("#attendance_btn").click(
		function(e) {
			if($("#appl_NO_disabled_input_attendance").val() == ""){
				alert("학번을 입력해주세요.");
			}
			e.preventDefault();
			
			 // Enable disabled fields
	        var disabled = $('#attendance_form').find(':input:disabled').removeAttr('disabled');
	        var formData = $("#attendance_form").serialize();

	        // Re-disable the set of inputs that you previously enabled
	        disabled.attr('disabled','disabled');
	        
			$.ajax({
				url : "/search/attendance",
				type : "POST",
				dataType : "json",
				data : formData,
				success : function(data) {
					$('#tableBody_attendance').empty();
					$('#cnt_attendance').empty();
					var result = data;
					var str = "";
					$.each(result, function(i, info) {
						str += '<tr><td>' + info.crclm_CD
								+ '</td><td>' + info.crclm_NM
								+ '</td><td>' + info.sbjct_NM
								+ '</td><td>' + "2023"
								+ '</td><td>' + info.semester
								+ '</td><td>' + info.sbjct_EXPLN
								+ '</td><td>' + info.korn_FLNM
								+ '</td><td>' + info.attendace
								+ '</td></tr>';
					});
					$('#tableBody_attendance').append(str);
					$('#cnt_attendance').append(result.length);
				}
			});
		});
	});
</script>
<div id="main_container_load">
	<div class="main_container_title">
		<img class="title_img" alt="title" src="/img/icon/title.png">출석부조회(학생용)
	</div>

	<form id="attendance_form">
		<div class="main_container_interspace">
			<input type="button" value="조회" id="attendance_btn" class="search_btn">
		</div>
		<div class="main_container_search">
			<div>학년도</div>
			<span class="div_input">
			<input class="div_input_left" name="years" value="2023">
			<select class="div_select_right" name="semester">
				<option value="01" selected>1학기</option>
				<option value="02">2학기</option>
			</select>
			</span>
			<div>학번/성명</div>
			<span class="div_input">
			<input class="div_input_left" id="appl_NO_disabled_input_attendance" disabled name="studentNumber" value="">
			<input class="div_input_right" name="studentName" id="korn_FLNM_readonly_input_attendance" value="">
			<img alt="magnifyingBtn" src="/img/icon/magnifyingBtn.png" class="magnifyingBtn" onclick="modalSearch('studentsModal', 'korn_FLNM_readonly_input_attendance', 'attendance')">
			</span>
			<div>소속학과</div>
			<input disabled="disabled" name="department" value="">
		</div>
	</form>
	<div class="main_container_subtitle">
		<div class="blue_bar"></div>
		학생 정보
	</div>
	<div style="font-size: 14px; color: gray; position: relative; float: left; top: 20px; margin-right: 735px;">
		<span id="cnt_attendance"></span>건이 조회되었습니다.
	</div>
	<div class="main_container_subtitle">
		<div class="blue_bar"></div>
		출결 상태
	</div>
	<div style="font-size: 14px; color: gray; position: relative; float: left; top: 20px;">
		<span id="cnt_attendance"></span>건
	</div>
	<div class="main_content narrow">
		<table id="main_table_attendance" class="main_table">
			<thead>
				<tr>
					<th onclick="sortTable(0, main_table_attendance)">학과코드</th>
					<th onclick="sortTable(1, main_table_attendance)">개설학과</th>
					<th onclick="sortTable(2, main_table_attendance)">개설과목</th>
					<th onclick="sortTable(3, main_table_attendance)">수강년도</th>
					<th onclick="sortTable(4, main_table_attendance)">수강학기</th>
					<th onclick="sortTable(5, main_table_attendance)">이수구분</th>
					<th onclick="sortTable(6, main_table_attendance)">담당교수</th>
					<th onclick="sortTable(7, main_table_attendance)">출석일수</th>
				</tr>
			</thead>
			<tbody id="tableBody_attendance">
			</tbody>
		</table>
	</div>
	<div class="main_content narrow2">
		<table id="main_table_attendance2" class="main_table">
			<thead>
				<tr>
					<th onclick="sortTable(0, main_table_attendance2)">월</th>
					<th onclick="sortTable(1, main_table_attendance2)">일</th>
				</tr>
			</thead>
			<tbody id="tableBody_attendance2">
			</tbody>
		</table>
	</div>
</div>