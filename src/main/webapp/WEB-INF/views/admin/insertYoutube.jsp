<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style type="text/css">
.min > div{
width: 100px;
min-width: 100px;
}
</style>
<script type="text/javascript">
	//조회
	$(document).ready(function() {
  // 검색 버튼 클릭 이벤트 등록
  $("#search_btn_inYou").click(function(e) {
    e.preventDefault(); // 기본 이벤트 제거 (페이지 새로고침 방지)

    // AJAX 요청
    $.ajax({
      url: "/search/onlect", // 요청할 URL
      type: "POST", // 요청 방식
      dataType: "json", // 응답 데이터 타입
      data: $("#search_form_inYou").serialize(), // 요청 데이터 (폼 데이터)
      success: function(data) { // 요청 성공 시 콜백 함수 실행
        $('#tableBody_inYou').empty(); // 테이블 바디 초기화
        $('#cnt_inYou').empty(); // 검색 결과 수 초기화
        console.log(data);
        var result = data; // 응답 데이터 저장
        var str = ""; // 테이블 로우 HTML 문자열 초기화
        $.each(result, function(i, info) { // 응답 데이터를 순회하며 테이블 로우 HTML 문자열 생성
          str += '<tr><td class="CRCLM_CYCL">' 
          + info.CRCLM_CYCL
          + '</td><td class="CRCLM_NM">' 
          + info.CRCLM_NM
          + '</td><td class="SBJCT_NM">' 
          + info.SBJCT_NM
          + '</td><td class="ON_LECT_NM">' 
          + info.ON_LECT_NM
          + '</td><td class="KORN_FLNM">' 
          + info.KORN_FLNM
          + '</td><td class="LECT_YMD">'
          + info.LECT_YMD
          + '</td><td class="ON_LECT_TM">'
          + info.ON_LECT_TM
          + '</td><td style="display:none;"><input type="hidden" class="on_LECT_URL" value="' 
          + info.ON_LECT_URL + '"></td></tr>';
        });
        $('#tableBody_inYou').append(str); // 테이블 바디에 테이블 로우 추가
        $('#cnt_inYou').append(result.length); // 검색 결과 수 표시
      }
    });
  });
});

	//저장
	// 문서가 로드될 때 실행되는 함수
$(document).ready(function() {
  // insert_btn_inYou 버튼 클릭 이벤트 등록
  $("#insert_btn_inYou").click(function(e) {
    // AJAX 요청
    $.ajax({
      url: "/insertYoutube/save", // 요청 URL
      type: "POST", // 요청 방식
      dataType: "json", // 받을 데이터 타입
      data: $("#insert_form_inYou").serialize(), // 전송할 데이터
      success: function(data) { // 요청 성공 시 실행될 함수
        // tableBody_inYou와 cnt_inYou 엘리먼트 비우기
        $('#tableBody_inYou').empty();
        $('#cnt_inYou').empty();
        
        // 받은 데이터를 이용하여 테이블 업데이트
        var result = data;
        var str = "";
        $.each(result, function(i, info) {
          str += '<tr><td>' 
          + info.sbjct_NO 
          + '</td><td>' 
          + info.crclm_CYCL 
          + '</td><td>' 
          + info.lect_YMD 
          + '</td><td>' 
          + info.on_LECT_SN 
          + '</td><td>' 
          + info.on_LECT_NM 
          + '</td><td>' 
          + info.on_LECT_CN 
          + '</td><td>' 
          + info.on_LECT_TM 
          + '</td><td style="display:none;"><input type="hidden" class="on_LECT_URL" value="' 
          + info.on_LECT_URL + '"></td></tr>';
        });
        $('#tableBody_inYou').append(str);
        $('#cnt_inYou').append(result.length);
      }
    });
  });

  $("#inYou_table").on("click", "tbody tr", function() {
		  // 클릭한 행에서 on_LECT_URL 가져오기
		  var on_LECT_URL = $(this).find(".on_LECT_URL").val();


    
    var CRCLM_NM = $(this).find(".CRCLM_NM").text();
    var CRCLM_CYCL = $(this).find(".CRCLM_CYCL").text();
    var SBJCT_NM = $(this).find(".SBJCT_NM").text();
    //var major = $(this).find(".필수").val()	;
    var ON_LECT_NM = $(this).find(".ON_LECT_NM").text();
    var KORN_FLNM = $(this).find(".KORN_FLNM").text();
    var LECT_YMD = $(this).find(".LECT_YMD").text();
    var ON_LECT_TM = $(this).find(".ON_LECT_TM").text();

    // 가져온 값을 #on_LECT_URL input 엘리먼트에 설정하기
    $("#on_LECT_URL").val(on_LECT_URL);
    
    $('#years').val(CRCLM_CYCL);
    $('#semesterName').val(CRCLM_NM);
    $('#departmentName').val(CRCLM_NM);
    $('#major').val("필수");
    $('#subjectCd').val(SBJCT_NM);
    $('#lecName').val(ON_LECT_NM);
    $('#instrName').val(KORN_FLNM);
    $('#lecDay').val(LECT_YMD);
    $('#lectime').val(ON_LECT_TM);
    $('#on_LECT_URL').val(on_LECT_URL);
  });

});
</script>
<div id="main_container_load">
	<div class="main_container_title">
		<img class="title_img" alt="title" src="/img/icon/title.png">일반교과목관리
	</div>
</div>
	<div class="main_container_interspace">
		<input type="submit" value="조회" id="search_btn_inYou"
			class="search_btn"> <input type="submit" value="저장"
			id="insert_btn_inYou" class="search_btn">
	</div>
		<form id="search_form_inYou">
	<div class="main_container_search">
		<div>학년도</div>
		<span class="div_input">
		<input class="div_input_left" id="year" name="year" value="2023"> 
		<select id="semester" class="div_select_right">
				<option value="0">전체</option>
				<option value="01">1학기</option>
				<option value="02">2학기</option>
				<option value="03">하계 계절학기</option>
				<option value="04">동계 계절학기</option>
		</select>
		</span>
		<div>편성학과</div>
		<input type="text" class="top_text" id="department_name"
			name="department_name">
		<div>과목명</div>
		<input name="ON_SBJECT_NM">
		<div>강의명</div>
		<input name="ON_LECT_NM">
		<div>교수명</div>
		<input name="ON_INSTR_NM">
	</div>
		</form>
<br>
<div class="main_container_subtitle">
	<div class="blue_bar"></div>
	강의정보
</div>
<div
	style="font-size: 14px; color: gray; position: relative; float: left; top: 20px;">
	<span id="cnt_inYou"></span>건이 조회되었습니다.
</div>
<div class="main_content short">
	<table id="inYou_table" class="main_table">
		<thead>
			<tr>
				<th onclick="sortTable(0, inYou_table)">학년도</th>
				<th onclick="sortTable(1, inYou_table)">학과</th>
				<th onclick="sortTable(2, inYou_table)">과목명</th>
				<th onclick="sortTable(3, inYou_table)">온라인강의명</th>
				<th onclick="sortTable(4, inYou_table)">교수자명</th>
				<th onclick="sortTable(5, inYou_table)">강의일자</th>
				<th onclick="sortTable(6, inYou_table)">강의시간</th>
			</tr>
		</thead>
		<tbody id="tableBody_inYou">
		</tbody>
	</table>
</div>
<br>
<div class="main_container_search min" id="insert_btn_inYou">
	<input type="hidden" id="">
	
	<div>학년도</div>
	<input type="text" id="years" name="years" />
	<div>편성학기</div>
	<input type="text" id="semesterName" name="semesterName" />
	<div>학과</div>
	<input type="text" id="departmentName" name="departmentName" />
	<div>교과구분</div>
	<input type="text" id="major" name="major" />
	<div>과목명</div>
	<input type="text" id="subjectCd" name="subjectName" />
	<div>강의명</div>
	<input type="text" id="lecName" name="lecName">
	<div>교수자명</div>
	<input type="text" id="instrName" name="instrName" />
	<div>강의일자</div>
	<input type="text" id="lecDay" name="lecDay" />
	<div>강의시간</div>
	<input type="text" id="lectime" name="lectime" />
	<div>강의URL</div>
	<input id="on_LECT_URL" name="ON_LECT_URL" />
	<div>파일 첨부</div>
	<input type="file" id="file_upload" accept="video/*"
		style="height: 24px; position: relative; top: 7px;" />
	<div>강의요약내용</div>
	<input type="text" id="lecsmry" name="lecsmry"/>
</div>
</div>