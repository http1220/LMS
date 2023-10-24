<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<script type="text/javascript">
//studentList에서 입력한 value값 가져오기
$(document).ready( function() {
	$("#department").val(val);
});
$(document).ready( function() {
	$("#search_btn_modal").click(
		function(e) {
			e.preventDefault();
			$.ajax({
				url : "/search/departmentModal",
				type : "POST",
				dataType : "json",
				data : $("#department_form").serialize(),
				success : function(data) {
					$('#tableBody_departmentModal').empty();
					$('#cnt_departmentModal').empty();
					var result = data;
					var str = "";
					$.each(result, function(i, info) {
						str += '<tr><td name="crclm_CD">' + info.crclm_CD
								+ '</td><td name="crclm_NM">' + info.crclm_NM
								+ '</td"><td>' + info.department
								+ '</td></tr>';
					});
					$('#tableBody_departmentModal').append(str);
					$('#cnt_departmentModal').append(result.length);
				}
			});
		});
	  // Enter 키를 누를 때 양식 제출 방지
	  $("#department_form").on("keypress", function(e) {
	    if (e.which === 13) {
	      e.preventDefault();
	      // 검색을 수행하기 위해 검색 버튼에서 클릭 이벤트 트리거
	      $("#search_btn_modal").click();
	    }
	  });
});
	
//행을 클릭했을 때
$(document).ready(function() {
	$("#table_departmentModal").on("click", "tbody tr", function() {
		  // 클릭한 행에서 department 가져오기
		  var crclm_CD = $(this).find("td[name=crclm_CD]").text();
		  var crclm_NM = $(this).find("td[name=crclm_NM]").text();
		  // 추가 데이터를 해당 입력 요소로 설정
		  $("#crclm_CD").val(crclm_CD);
		  $("#crclm_NM").val(crclm_NM);
		  $("#select_btn_modal").removeAttr("disabled");
		});
});

//선택버튼을 눌렀을 때
function choose_department(relay_input){
	var crclm_CD = $("#crclm_CD").val();
	var crclm_NM = $("#crclm_NM").val();
	//studentList의 input에 해당 값 입력
	$("#crclm_CD_disabled_input_" + relay_input).val(crclm_CD);
	$("#crclm_NM_readonly_input_" + relay_input).val(crclm_NM);
	$("input[name=department]").attr("readonly", "readonly");
	close_modal(modal_department);
}
</script>
<div id="modal_department" class="modal_department">
	<div class="modal_top_bar">소속학과검색(CO0025P)</div>
	<div class="modal_main">
		<div class="modal_main_btn">
			<input type="submit" value="닫기" id="close_btn_modal" class="search_btn noMargin" onclick="close_modal(modal_department)">
			<input type="submit" value="선택" id="select_btn_modal" class="search_btn noMargin" onclick="choose_department(relay_input)" disabled="disabled">
			<input type="submit" value="조회" id="search_btn_modal" class="search_btn noMargin">
			<input type="hidden" id="crclm_CD" value="">
			<input type="hidden" id="crclm_NM" value="">
		</div>
		<form id="department_form">
			<div class="main_container_search modal_search">
				<div>소속학과</div>
				<input name="department" id="department" class="top">
			</div>
		</form>
		<div class="main_container_subtitle" style="width: 120px;">
		<div class="blue_bar"></div>
		소속학과 정보
		</div>
		<div style="font-size: 14px; color: gray; position: relative; float: left; top: 20px;">
		<span id="cnt_departmentModal"></span>건이 조회되었습니다.
		</div>
		<div class="main_content">
			<table id="table_departmentModal" class="main_table">
				<thead>
					<tr>
						<th onclick="sortTable(0, table_departmentModal)" title="코드">코드</th>
						<th onclick="sortTable(1, table_departmentModal)" title="소속학과">소속학과</th>
						<th onclick="sortTable(2, table_departmentModal)" title="부서구분">부서구분</th>
					</tr>
				</thead>
				<tbody id="tableBody_departmentModal" style="overflow: hidden;">
				</tbody>
			</table>
		</div>
	</div>
</div>