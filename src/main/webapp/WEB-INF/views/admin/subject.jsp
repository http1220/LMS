<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
function search() {
  const year = document.getElementById("year").value;
  const semester = document.getElementById("semester").value;
  const subjectName = document.getElementById("subject_name").value;
  const departmentName = document.getElementById("department_name").value;
  
  const data = {
    "year": year,
    "semester": semester,
    "subjectName": subjectName,
    "departmentName" : departmentName
  };

  const xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      if (xhr.status === 200) {
        const result = document.getElementById("result").getElementsByTagName("tbody")[0];
        const response = JSON.parse(xhr.responseText);
		console.log(response.data[0]);
        // 기존 테이블 내용 삭제
        result.innerHTML = "";
		
        // 조회된 데이터 건수
        $('#cnt_subject').append(response.data.length);
        
        // 데이터 출력
        for (let i = 0; i < response.data.length; i++) {
          const row = result.insertRow(-1);
          const categoryCell1 = row.insertCell(0);
          const categoryCell2 = row.insertCell(1);
          const subjectNameCell = row.insertCell(2);
          const departmentNameCell = row.insertCell(3);
          
          let newText = document.createTextNode(response.data[i].CRCLM_CYCL.toString().substr(0,4) + "년도");
      
          categoryCell1.appendChild(newText);

          if(response.data[i].CRCLM_CYCL.toString().substr(5) !== '1' && response.data[i].CRCLM_CYCL.toString().substr(5) !== '2'){
        	  if(response.data[i].CRCLM_CYCL.toString().substr(5) == '3'){
        		categoryCell2.innerHTML = "하계 계절학기";
        	  }else{
        		categoryCell2.innerHTML = "동계 계절학기";
        	  }
          }else{
          		categoryCell2.innerHTML = response.data[i].CRCLM_CYCL.toString().substr(5)+"학기";        	  
          }
          subjectNameCell.innerHTML = response.data[i].SBJCT_NM;
          departmentNameCell.innerHTML = response.data[i].CRCLM_NM;
       
          // 이벤트 리스너 추가
          row.addEventListener('click', function() {
            const rowData = {
              year: categoryCell1.innerHTML.substr(0,4),
              semester: categoryCell2.innerHTML,
              subjectName: subjectNameCell.innerHTML,
              departmentName: departmentNameCell.innerHTML
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

  xhr.open('POST', '/subjectFilter');
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.send(JSON.stringify(data));
}

</script>
<style>

.modity {
	display:flex;
	flex-flow: row wrap;
	justify-content: flex-start;

}
.top{
position: relative;
top: 58px;
float: none;
}
.modify > div{
/* width: 100px; */
margin: 5px;
}
.modify > input{
/* width: 150px;
min-width: 150px; */
margin: 5px;
}
</style>

<div id="main_container_load">
	<div class="main_container_title">
		<img class="title_img" alt="title" src="/img/icon/title.png">교육과정관리
	</div>
	<div style="overflow-y: hidden; overflow-x: hidden; height: 580px;">
	<form id="search-form">
		<div class="main_container_interspace">
			<input type="button" value="조회" class="search_btn" onclick="search()">
		</div>
		<div class="main_container_search">
		<div>학년도</div>
		<span class="div_input">
		<input class="div_input_left" id="year" name="year" value="2023">
		<select id="semester"  class="div_select_right">
			<option value="0">전체</option>
			<option value="01">1학기</option>
			<option value="02">2학기</option>
			<option value="03">하계 계절학기</option>
			<option value="04">동계 계절학기</option>
		</select>
		</span>
		<div>교과목명</div>
		<input type="text" class="top_text" id="subject_name" name="subject_name">
		<div>편성학과</div>
		<input type="text" class="top_text" id="department_name" name="department_name">
		</div>
	</form>
	
	<div class="main_container_subtitle">
		<div class="blue_bar"></div>
		교육과정정보
	</div>
		<div style="font-size: 14px; color: gray; position: relative; float: left; top: 20px;">
		<span id="cnt_subject"></span>건이 조회되었습니다.
	</div>
		<div class="main_content short">
		<table id="result" class="main_table">
		  	<thead>
		    	<tr>
					<th onclick="sortTable(0, result)">교육년도</th>
					<th onclick="sortTable(1, result)">학기</th>
					<th onclick="sortTable(2, result)">교과목명</th>
					<th onclick="sortTable(3, result)">편성학과</th>
		    	</tr>
		  	</thead>
		  	<tbody></tbody>	
		</table>
		</div>
		<div class="main_container_subtitle top">
			<div class="blue_bar"></div>
			과목정보
		</div>
		<div class="main_container_search modify">
			<div>학년도</div>
			<input id="years" name="years">
			<div>학과코드</div>
			<input type="text" id="departmentCd" name="departmentCd">
			<div>편성학과</div>
			<input type="text" id="departmentName" name="departmentName">
			<div>편성학기</div>
			<input type="text" id="semesterName" name="semesterName">
			<div>교과구분</div>
			<input type="text" id="major" name="major">
			<div>과목코드</div>
			<input type="text" id="subjectCd" name="subjectCd">
			<div>과목명</div>
			<input type="text" id="subjectName" name="subjectName">
			<div>비고</div>
			<input type="text" id="note" name="note">
		</div>
	</div>
</div>
<script>
function sendAjax(rowData) {
	  const xhr = new XMLHttpRequest();
	  
	  xhr.onreadystatechange = function() {
	    if (xhr.readyState === XMLHttpRequest.DONE) {
	      if (xhr.status === 200) {
	        //console.log(xhr.responseText);
	    	  const response = JSON.parse(xhr.responseText);
	          console.log(response);
	          
	          // 응답 데이터를 input 요소에 추가
	          const data = response.data[0];
	          
	          //날짜
	          const yearsInput = document.getElementById("years");
	          yearsInput.value = data.CRCLM_CYCL.toString().substr(0,4);
	          
	          //학기 가공
	          if(data.CRCLM_CYCL.toString().substr(5) != '1' && data.CRCLM_CYCL.toString().substr(5) != '2'){
	        	  if(data.CRCLM_CYCL.toString().substr(5) == '3'){
	          		const semesterNameInput = document.getElementById("semesterName");
	          		semesterNameInput.value = "하계 계절학기";
	          	  }else{
	          		const semesterNameInput = document.getElementById("semesterName");
	          		semesterNameInput.value = "동계 계절학기";
	          	  }
	          }else{
	        	  	const semesterNameInput = document.getElementById("semesterName");
	          		semesterNameInput.value = data.CRCLM_CYCL.toString().substr(5)+"학기";
	          }
	          //학과명
	          const subjectNameInput = document.getElementById("subjectName");
	          subjectNameInput.value = data.SBJCT_NM;
	          //학과코드
	          const departmentCdInput = document.getElementById("departmentCd");
	          departmentCdInput.value = data.CRCLM_CD;
	          //편성학과
	          const departmentNameInput = document.getElementById("departmentName");
	          departmentNameInput.value = data.CRCLM_NM;
	          //과목코드
	          const subjectCdInput = document.getElementById("subjectCd");
	          subjectCdInput.value = data.SBJCT_NO;
	          //전공구분
	          if(data.SBJCT_NO.toString().substr(1) == 'a'){
	        	  const majorInput = document.getElementById("major");
	        	  majorInput.value = "교양";
	          }else{
	        	  const majorInput = document.getElementById("major");
	        	  majorInput.value = "전공";
	          }
	          
	          
	      } else {
	        console.error('Error:', xhr.statusText);
	      }
	    }
	  };
	  
	  xhr.open('POST', '/detailSubject');
	  xhr.setRequestHeader('Content-Type', 'application/json');
	  xhr.send(JSON.stringify(rowData));
	}
</script>