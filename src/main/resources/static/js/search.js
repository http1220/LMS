function search(){	//검색 체크
	let searchType = document.getElementById("searchType");
	let searchValue = document.getElementById("searchValue");
	if(searchType.value=="none") {
		alert("검색 항목을 선택해주세요");
		return false;
	}
	// if(searchValue.value=="") {
	// 	alert("검색어를 입력해주세요");
	// 	return false;
	// }
}