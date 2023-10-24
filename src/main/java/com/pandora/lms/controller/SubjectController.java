package com.pandora.lms.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pandora.lms.service.SubjectService;

@Controller
public class SubjectController {

	@Autowired
	SubjectService subjectService;
	
	@GetMapping("/admin/subject")
	public String subject() {
		
		return "admin/subject";
	}
	
	//학생의 수강신청된 교육과정을 가져오는 부분 ****
//	@GetMapping("/subject")
//	public ModelAndView subject(HttpSession session) {
//		ModelAndView mv = new ModelAndView("subject");
//		String student = (String) session.getAttribute("id");
//		
//		//List<Map<String, Object>> list = subjectService.subject(student);
//		//mv.addObject("student", list);
//		
//		return mv;
//	}
	
	//필터링을 하고 값을 반환****
	@PostMapping("/subjectFilter")
	@ResponseBody
	public String subjectFilter(@RequestBody Map<String, String> formData) throws JsonProcessingException {
	    String year = formData.get("year");
	    String semester = formData.get("semester");
	    String subjectName = formData.get("subjectName");
	    String departmentName = formData.get("departmentName");
	    
	    
	    String Search01 = year+semester;
	    //System.out.println(Search01);
	    //System.out.println(subjectName);
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("Search01", Search01);
	    paramMap.put("subjectName", subjectName);
	    paramMap.put("departmentName", departmentName);
	    
	    System.out.println(Search01);
	    
	    // 필터링 로직 수행
	    List<Map<String, Object>> filteredData = subjectService.AjaxSubject(paramMap);
	    
	    
	    // 결과를 JSON 문자열로 변환하여 반환
	    ObjectMapper mapper = new ObjectMapper();
	    Map<String, Object> result = new HashMap<>();
	    result.put("status", "success");
	    result.put("data", filteredData);
	    for (Map<String, Object> map : filteredData) {
	    	for( String key : map.keySet() ) {
	    		System.out.println(key + " : " + map.get(key));
	    	}
		}
	    return mapper.writeValueAsString(result);
	}
	
	
	//필터를 위해 필요한 데이터를 확인하기위함. 나중에 지울것
//	@PostMapping("/subjectFilter")
//	@ResponseBody
//	public void subjectFilter(@RequestBody Map<String, String> formData) {
//	    String year = formData.get("year");
//	    String semester = formData.get("semester");
//	    String subjectName = formData.get("subjectName");
//	    
//	    System.out.println("년도 : " + year + ", 학기 : " + semester + ", 과목명 : " + subjectName);
//	    // 필터링 로직 수행
//	    
//	}
	
	@PostMapping("/detailSubject")
	@ResponseBody
	public Map<String, Object> detailSubject(@RequestBody Map<String, String> data) {
		String year = data.get("year");
		String semester = data.get("semester");
		String subjectName = data.get("subjectName");
		String departmentName = data.get("departmentName");
		
		String num = "";
		if(semester.length() > 4) {
			if(semester.charAt(0) == '하') {
				num = "03";
			}else {
				num = "04";
			}
		}else {
			num = "0"+String.valueOf(semester.charAt(0));
		}
		
		String Search01 = year+num;
		System.out.println(Search01);
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("Search01", Search01);
		paramMap.put("subjectName", subjectName);
		paramMap.put("departmentName", departmentName);
		    
		// 필터링 로직 수행
		List<Map<String, Object>> detailData = subjectService.AjaxSubject(paramMap);
		
		// 결과 데이터 생성
		Map<String, Object> result = new HashMap<>();
		result.put("status", "success");
		result.put("data", detailData);
		
		// 생성된 결과 데이터 반환
		return result;
	    }
	
	
}
