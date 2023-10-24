
function moveBefore(pageNo){	//페이징 시작
	let searchType = document.getElementById("searchType");
	let searchValue = document.getElementById("searchValue");
	let url =  document.location.href.split("?",1);
	if(pageNo < 1) { return false; }
	else if (pageNo != 1){
		if((searchType.value != null && searchType.value != "none") && searchValue.value != null){
			location.href=url+"?searchType="+ searchType.value+"&searchValue="+searchValue.value+"&pageNo="+(pageNo-1);
		}else{
			location.href="/notice?pageNo="+(pageNo-1);
		}
	}else{
		if((searchType.value != null && searchType.value != "none") && searchValue.value != null){
			location.href=url+"?searchType="+ searchType.value+"&searchValue="+searchValue.value+"&pageNo="+1;
		}else{
			location.href="/notice?pageNo="+1;
		}
	}
}
function move(pageNo){
	let searchType = document.getElementById("searchType");
	let searchValue = document.getElementById("searchValue");
	let url =  document.location.href.split("?");
	if((searchType.value != null && searchType.value != "none") && searchValue.value != null){
		location.href=url[0]+"?searchType="+ searchType.value+"&searchValue="+searchValue.value+"&pageNo="+pageNo;
	}else{
		location.href="/notice?pageNo="+pageNo;
	}
	
}//페이징 끝