package com.pandora.lms.util;

import java.util.List;


import javax.servlet.http.HttpSession;

public class Completion {
	
	//수강생 강의진행율 확인해서 수료조건 확인
	public void attendance(HttpSession session, List<Object> list) {
		//해당 수강생 세션을 이용해서 정보 출력
		String id = (String) session.getAttribute("id");
		
		
		
	}
	
	
	
	
}
