<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
function search_instrInfo() {
  const instrName = document.getElementById("korn_FLNM_readonly_input_instrInfo").value;
  const departmentName = document.getElementById("department_name_instr").value;

  console.log(instrName);
  console.log(departmentName);
  
  
//   if(instrName == ""){
// 	  alert("강사이름을 입력해주세요");
// 	  return;
//   }
  
  const data = {
		instrName: instrName,
    	departmentName : departmentName
  };

  
  //시작
  const xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      if (xhr.status === 200) {
        const main_table_instrInfo = document.getElementById("main_table_instrInfo").getElementsByTagName("tbody")[0];
        const response = JSON.parse(xhr.responseText);
        // 기존 테이블 내용 삭제
        main_table_instrInfo.innerHTML = "";
        alert(response.data);
        console.log(response.data);

        // 데이터 출력
        for (let i = 0; i < response.data.length; i++) {
          const row = main_table_instrInfo.insertRow(-1);
          const INSTR_NO = row.insertCell(0);//강사번호
          const KORN_FLNM = row.insertCell(1);//강사이름
          const SBJCT_NMCell = row.insertCell(2);//과목이름
          const ESNTL_YNCell = row.insertCell(3);//교과구분
          const EML_ADDR = row.insertCell(4);//이메일
          const TELNO = row.insertCell(5);//비상연락망
          const GENDER_CD = row.insertCell(6);//성별
          const ZOOM_AUTH = row.insertCell(7);//줌권한
          const UPDATE = row.insertCell(8);//업데이트 버튼
          
          //성별 코드를 string으로 변환
          if(response.data[i].GENDER_CD == 20){
	          GENDER_CD.innerHTML = "남";
          }else{
        	  GENDER_CD.innerHTML = "여";
          }
          
          //줌권한 코드를 string 으로 변환
          if(response.data[i].ZOOM_AUTH == 1){
        	  ZOOM_AUTH.innerHTML = "O";
          }else{
        	  ZOOM_AUTH.innerHTML = "X";
          }
          
          if (response.data[i].ZOOM_AUTH == 1) {
        	  UPDATE.innerHTML = "<button onclick='sendInstrNo(" + response.data[i].INSTR_NO + ")'>줌권한회수</button>";
        	} else {
        	  UPDATE.innerHTML = "<button onclick='sendInstrNo(" + response.data[i].INSTR_NO + ")'>줌권한부여</button>";
        	}
          
          INSTR_NO.innerHTML = response.data[i].INSTR_NO;
          KORN_FLNM.innerHTML = response.data[i].KORN_FLNM;
          SBJCT_NMCell.innerHTML = response.data[i].SBJCT_NM;
          ESNTL_YNCell.innerHTML = response.data[i].ESNTL_YN;
          EML_ADDR.innerHTML = response.data[i].EML_ADDR;
          TELNO.innerHTML = response.data[i].TELNO;
          
          

          
        }
      } else {
        console.error('Error:', xhr.statusText);
      }
    }
  };
  xhr.open('POST', '/InstrSearch');
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.send(JSON.stringify(data));
}

function sendInstrNo(instrNo) {
	console.log("Send INSTR_NO:", instrNo);
	const data = {
		instrNo: instrNo
	};
	
	const xhr = new XMLHttpRequest();
	xhr.open('POST', '/ChangeInstr');
	xhr.setRequestHeader('Content-Type', 'application/json');
	xhr.send(JSON.stringify(data));
	
	search_instrInfo();
}

</script>
<div id="main_container_load">
	<div class="main_container_title">
		<img class="title_img" alt="title" src="/img/icon/title.png">강사명부조회
	</div>

		<div class="main_container_interspace">
			<input type="button" value="조회" id="search_btn" class="search_btn" onclick="search_instrInfo()">
		</div>
		<div class="main_container_search">
			<div>강사번호/성명</div>
			<span class="div_input">
				<input id="instr_NO_disabled_input_instrInfo" name="instr_num" disabled="disabled" class="div_input_left">
				<input id="korn_FLNM_readonly_input_instrInfo" name="instr_name" name="instrName" class="div_input_right">
				<img alt="magnifyingBtn" src="/img/icon/magnifyingBtn.png" class="magnifyingBtn" onclick="modalSearch('instructorModal', 'korn_FLNM_readonly_input_instrInfo', 'instrInfo')">
			</span>
			<div>소속학과</div>
			<input id="department_name_instr" name="department_name_instr">
		</div>

	<div class="main_container_subtitle">
		<div class="blue_bar"></div>
		강사 정보
	</div>
	<div style="font-size: 14px; color: gray; position: relative; float: left; top: 20px;">
		<span id="cnt_list"></span>건이 조회되었습니다.
	</div>
	<div class="main_content">
		<table id="main_table_instrInfo" class="main_table">
			<thead>
				<tr>
					<th onclick="sortTable(0, main_table_instrInfo)">강사번호</th>
					<th onclick="sortTable(1, main_table_instrInfo)">강사이름</th>
					<th onclick="sortTable(2, main_table_instrInfo)">과목이름</th>
					<th onclick="sortTable(3, main_table_instrInfo)">교과구분</th>
					<th onclick="sortTable(4, main_table_instrInfo)">이메일</th>
					<th onclick="sortTable(5, main_table_instrInfo)">비상연락망</th>
					<th onclick="sortTable(6, main_table_instrInfo)">성별</th>
					<th onclick="sortTable(7, main_table_instrInfo)">줌권한</th>
					<th onclick="sortTable(8, main_table_instrInfo)">줌권한변경</th>
				</tr>
			</thead>
			<tbody id="tableBody_instrInfo">
			
			</tbody>
		</table>
	</div>
</div>