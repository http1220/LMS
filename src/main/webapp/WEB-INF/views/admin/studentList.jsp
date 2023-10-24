<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
$(document).ready( function() {
	$("#search_btn").click(
		function(e) {
			e.preventDefault();
			$.ajax({
				url : "/search/studentList",
				type : "POST",
				dataType : "json",
				data : $("#studentList_form").serialize(),
				success : function(data) {
					$('#tableBody').empty();
					$('#cnt_list').empty();
					var result = data;
					var str = "";
					$.each(result, function(i, info) {
						str += '<tr><td>' + info.appl_NO
								+ '</td><td>' + info.korn_FLNM
								+ '</td><td>' + info.crclm_NM
								+ '</td><td>' + info.user_BRDT
								+ '</td><td>' + info.age
								+ '</td><td>' + info.gender
								+ '</td><td>' + info.eml_ADDR
								+ '</td><td>' + info.telno
								+ '</td><td>' + info.addr
								+ '</td></tr>';
					});
					$('#tableBody').append(str);
					$('#cnt_list').append(result.length);
				}
			});
		});
	});
</script>
<div id="main_container_load">
	<div class="main_container_title">
		<img class="title_img" alt="title" src="/img/icon/title.png">학생명부조회
	</div>

	<form id="studentList_form">
		<div class="main_container_interspace">
			<input type="button" value="조회" id="search_btn" class="search_btn">
		</div>
		<div class="main_container_search">
			<div>학번(이름)</div>
			<input name="name">
			<div>학적상태</div>
			<select name="academic_status">
				<option value="">(전체)</option>
				<option value="재학" selected>재학</option>
				<option value="휴학">휴학</option>
			</select>
			<div>소속학과</div>
			<span class="div_input">
			<input type="hidden" name="crclm_CD_able" value="1">
			<input class="div_input_left" value="" name="crclm_CD" id="crclm_CD_disabled_input_studentList" disabled>
			<input class="div_input_right" name="department" id="crclm_NM_readonly_input_studentList">
			<img alt="magnifyingBtn" src="/img/icon/magnifyingBtn.png" class="magnifyingBtn" onclick="modalSearch('departmentModal', 'crclm_NM_readonly_input_studentList', 'studentList')">
			</span>
		</div>
	</form>

	<div class="main_container_subtitle">
		<div class="blue_bar"></div>
		학생 정보
	</div>
	<div style="font-size: 14px; color: gray; position: relative; float: left; top: 20px;">
		<span id="cnt_list"></span>건이 조회되었습니다.
	</div>
	<div class="main_content">
		<table id="main_table" class="main_table">
			<thead>
				<tr>
					<th onclick="sortTable(0, main_table)">학번</th>
					<th onclick="sortTable(1, main_table)">이름</th>
					<th onclick="sortTable(2, main_table)">소속학과</th>
					<th onclick="sortTable(3, main_table)">생년월일</th>
					<th onclick="sortTable(4, main_table)">나이</th>
					<th onclick="sortTable(5, main_table)">성별</th>
					<th onclick="sortTable(6, main_table)">이메일</th>
					<th onclick="sortTable(7, main_table)">연락처</th>
					<th onclick="sortTable(8, main_table)">주소</th>
				</tr>
			</thead>
			<tbody id="tableBody">
			
			</tbody>
		</table>
	</div>
</div>