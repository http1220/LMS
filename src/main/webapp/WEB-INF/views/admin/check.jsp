<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
function search_check() {
  const year_ck = document.getElementById("year_ck").value;
  const semester_ck = document.getElementById("semester_ck").value;
  const studentNum_ck = document.getElementById("appl_NO_disabled_input_check").value;
  const departmentName_ck = document.getElementById("department_name").value;
	console.log(year_ck + " " + semester_ck + " " + studentNum_ck + " " + departmentName_ck); 
  

  if(studentNum_ck == ""){
	  alert("학번을 입력해주세요");
	  return;
  }
  
  const data = {
    year_ck : year_ck,
    semester_ck : semester_ck,
    studentNum_ck : studentNum_ck,
    departmentName_ck : departmentName_ck
  };

  const xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      if (xhr.status === 200) {
        const result = document.getElementById("main_table_check").getElementsByTagName("tbody")[0];
        const response = JSON.parse(xhr.responseText);
        // 기존 테이블 내용 삭제
        result.innerHTML = "";
        
        console.log(response.data);

        // 데이터 출력
        for (let i = 0; i < response.data.length; i++) {
          const row = result.insertRow(-1);
          const CRCLM_NMCell = row.insertCell(0);//개설학과
          const SBJCT_NOCell = row.insertCell(1);//과목코드
          const SBJCT_NMCell = row.insertCell(2);//개설과목
          const CRCLM_CYCLCell1 = row.insertCell(3);//수강년도
          const CRCLM_CYCLCell2 = row.insertCell(4);//학기
          const ESNTL_YNCell = row.insertCell(5);//이수구분
          const KORN_FLNMCell = row.insertCell(6);//담당교수
          const ATNDDY_CNTCell = row.insertCell(7);//출석
          const ABSTDY_CNTCell = row.insertCell(8);//결석
          const LATE_CNTCell = row.insertCell(9);//지각
          
          const CRCLM_CYCL = response.data[i].CRCLM_CYCL.toString();
          
          CRCLM_CYCLCell1.innerHTML = CRCLM_CYCL.substr(0,4)+"년도";

          if(CRCLM_CYCL.substr(5) !== '1' && CRCLM_CYCL.substr(5) !== '2'){
        	  if(CRCLM_CYCL.substr(5) == '3'){
        		  CRCLM_CYCLCell2.innerHTML = "하계 계절학기";
        	  }else{
        		  CRCLM_CYCLCell2.innerHTML = "동계 계절학기";
        	  }
          }else{
        	  CRCLM_CYCLCell2.innerHTML = CRCLM_CYCL.substr(5)+"학기";        	  
          }
          CRCLM_NMCell.innerHTML = response.data[i].CRCLM_NM;
          SBJCT_NOCell.innerHTML = response.data[i].SBJCT_NO;
          SBJCT_NMCell.innerHTML = response.data[i].SBJCT_NM;
          ESNTL_YNCell.innerHTML = response.data[i].ESNTL_YN;
          KORN_FLNMCell.innerHTML = response.data[i].KORN_FLNM;
          ATNDDY_CNTCell.innerHTML = response.data[i].ATNDDY_CNT;
          ABSTDY_CNTCell.innerHTML = response.data[i].ABSTDY_CNT;
          LATE_CNTCell.innerHTML = response.data[i].LATE_CNT;
          
          // 이벤트 리스너 추가
          row.addEventListener('click', function() {
            const rowData = {
              year_ck: categoryCell1.innerHTML.substr(0,4),
              semester_ck: categoryCell2.innerHTML,
              subjectName: subjectNameCell.innerHTML,
              departmentName_ck: departmentName_ckCell.innerHTML
            };
            sendAjax(rowData);
          });
       //여기까지
          
        }
      } else {
        console.error('Error:', xhr.statusText);
      }
    }
  };

  xhr.open('POST', '/studentCheck');
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.send(JSON.stringify(data));
}


</script>
<div id="main_container_load">
	<div class="main_container_title">
		<img class="title_img" alt="title" src="/img/icon/title.png">출결조회
	</div>

		<div class="main_container_interspace">
			<input type="button" value="조회" id="search_btn" class="search_btn" onclick="search_check()">
		</div>
		<div class="main_container_search">
			<div>학년도</div>
			<span class="div_input">
				<input class="div_input_left" id="year_ck" name="year_ck" value="2023">
				<select class="div_select_right" name=""  id="semester_ck">
					<option value="0">전체</option>
				 	<option value="01" selected>1학기</option>
				 	<option value="02">2학기</option>
				 	<option value="03">하계 계절학기</option>
				 	<option value="04">동계 계절학기</option>
				</select>
			</span>
			<div>학번/성명</div>
			<span class="div_input">
				<input class="div_input_left" id="appl_NO_disabled_input_check" value="">
				<input class="div_input_right" name="studentName" id="korn_FLNM_readonly_input_check" value="">
				<img alt="magnifyingBtn" src="/img/icon/magnifyingBtn.png" class="magnifyingBtn" onclick="modalSearch('studentsModal', 'korn_FLNM_readonly_input_check', 'check')">
			</span>
			<div>소속학과</div>
			<input disabled="disabled" value="" id="department_name" name="department_name">
		</div>

	<div class="main_container_subtitle">
		<div class="blue_bar"></div>
		강사 정보
	</div>
	<div style="font-size: 14px; color: gray; position: relative; float: left; top: 20px;">
		<span id="cnt_list"></span>건이 조회되었습니다.
	</div>
	<div class="main_content">
		<table id="main_table_check" class="main_table">
			<thead>
				<tr>
					<th onclick="sortTable(0, main_table_check)">개설학과</th>
					<th onclick="sortTable(1, main_table_check)">과목코드</th>
					<th onclick="sortTable(2, main_table_check)">개설과목</th>
					<th onclick="sortTable(3, main_table_check)">수강년도</th>
					<th onclick="sortTable(4, main_table_check)">학기</th>
					<th onclick="sortTable(5, main_table_check)">이수구분</th>
					<th onclick="sortTable(6, main_table_check)">담당교수</th>
					<th onclick="sortTable(7, main_table_check)">출석</th>
					<th onclick="sortTable(8, main_table_check)">결석</th>
					<th onclick="sortTable(9, main_table_check)">지각</th>
				</tr>
			</thead>
			<tbody id="tableBody_check">
			</tbody>
		</table>
	</div>
</div>