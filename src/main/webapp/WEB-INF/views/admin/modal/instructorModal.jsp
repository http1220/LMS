<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
//studentList에서 입력한 value값 가져오기
$(document).ready( function() {
	$("#name").val(val);
	alert(relay_input);
});
$(document).ready( function() {
	$("#search_btn_modal").click(
		function(e) {
			$.ajax({
				url : "/search/instructorModal",
				type : "POST",
				dataType : "json",
				data : $("#instructorModal_form").serialize(),
				success : function(data) {
					$('#tableBody_instructorModal').empty();
					$('#cnt_instructorModal').empty();
					var result = data;
					var str = "";
					$.each(result, function(i, info) {
						str += '<tr><td name="instr_NO">' + info.instr_NO
								+ '</td><td name="korn_FLNM">' + info.korn_FLNM
								+ '</td><td>' + info.gender
								+ '</td><td>' + info.user_BRDT
								+ '</td><td>' + info.telno
								+ '</td></tr>';
					});
					$('#tableBody_instructorModal').append(str);
					$('#cnt_instructorModal').append(result.length);
				}
			});
		});
	  // Enter 키를 누를 때 양식 제출 방지
	  $("#instructorModal_form").on("keypress", function(e) {
	    if (e.which === 13) {
	      e.preventDefault();
	      // 검색을 수행하기 위해 검색 버튼에서 클릭 이벤트 트리거
	      $("#search_btn_modal").click();
	    }
	  });
});

//행을 클릭했을 때
$(document).ready(function() {
	$("#main_table_instructorModal").on("click", "tbody tr", function() {
		  // 클릭한 행에서 department 가져오기
		  var instr_NO = $(this).find("td[name=instr_NO]").text();
		  var korn_FLNM = $(this).find("td[name=korn_FLNM]").text();
		  // 추가 데이터를 해당 입력 요소로 설정
		  $("#instr_NO").val(instr_NO);
		  $("#korn_FLNM").val(korn_FLNM);
		  $("#select_btn_modal").removeAttr("disabled");
		});
});

//선택버튼을 눌렀을 때
function choose_instructor(relay_input){
	var instr_NO = $("#instr_NO").val();
	var korn_FLNM = $("#korn_FLNM").val();
	//studentList의 input에 해당 값 입력
	$("#instr_NO_disabled_input_" + relay_input).val(instr_NO);
	$("#korn_FLNM_readonly_input_" + relay_input).val(korn_FLNM);
	$("input[name=instrName]").attr("readonly", "readonly");
	close_modal(modal_instructor);
}
</script>
<style>
.modal_search{
height: 38px;
}
.modal_search > div {
width: 90px;
line-height: 26px;
}
.modal_search > input {
width: 170px;
min-width: 170px;
}
.main_container_search > input{
top: -1px;
}
</style>
<div id="modal_instructor" class="modal_department">
	<div class="modal_top_bar">강사검색(SL9999P)</div>
	<div class="modal_main">
		<div class="modal_main_btn">
			<input type="submit" value="닫기" id="close_btn_modal" class="search_btn noMargin" onclick="close_modal(modal_instructor)">
			<input type="submit" value="선택" id="select_btn_modal" class="search_btn noMargin" onclick="choose_instructor(relay_input)" disabled="disabled">
			<input type="submit" value="조회" id="search_btn_modal" class="search_btn noMargin">
			<input type="hidden" id="instr_NO" value="">
			<input type="hidden" id="korn_FLNM" value="">
		</div>
			<form id="instructorModal_form">
				<div class="main_container_search modal_search">
					<div>강사(이름)</div>
					<input name="name" id="name">
				</div>
			</form>
		<div class="main_container_subtitle" style="width: 120px;">
		<div class="blue_bar"></div>
		소속학과 정보
		</div>
		<div style="font-size: 14px; color: gray; position: relative; float: left; top: 20px;">
		<span id="cnt_instructorModal"></span>건이 조회되었습니다.
		</div>
		<div class="main_content">
			<table id="main_table_instructorModal" class="main_table">
				<thead>
					<tr>
						<th onclick="sortTable(0, main_table_instructorModal)">학번</th>
						<th onclick="sortTable(1, main_table_instructorModal)">이름</th>
						<th onclick="sortTable(2, main_table_instructorModal)">성별</th>
						<th onclick="sortTable(3, main_table_instructorModal)">생년월일</th>
						<th onclick="sortTable(4, main_table_instructorModal)">연락처</th>
					</tr>
				</thead>
				<tbody id="tableBody_instructorModal">
				</tbody>
			</table>
		</div>
	</div>
</div>