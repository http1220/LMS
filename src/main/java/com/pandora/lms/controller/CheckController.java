package com.pandora.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pandora.lms.service.CheckService;


@Controller
public class CheckController {
	@Autowired	
	CheckService checkService;
	
	@GetMapping("/admin/check")
	public String check() {	
		return "admin/check";
	}
	
	@PostMapping("/studentCheck")
	@ResponseBody
	public String subjectFilter(@RequestBody Map<String, String> formData) throws JsonProcessingException {
	    String year = formData.get("year_ck");
	    String semester = formData.get("semester_ck");
	    String studentNum = formData.get("studentNum_ck");
	    String departmentName = formData.get("departmentName_ck");
	    
	    System.out.println(year);
	    
	    String Search01 = year+semester;
	    System.out.println(Search01);
	    System.out.println(studentNum);
	    
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("Search01", Search01);
	    paramMap.put("studentNum", studentNum);
	    paramMap.put("departmentName", departmentName);
	    
	   
	    
	    // 필터링 로직 수행
	    List<Map<String, Object>> filteredData = checkService.AjaxStudent(paramMap);
	    
	    System.out.println(filteredData);
	    
	    // 결과를 JSON 문자열로 변환하여 반환
	    ObjectMapper mapper = new ObjectMapper();
	    Map<String, Object> result = new HashMap<>();
	    result.put("status", "success");
	    result.put("data", filteredData);
	    return mapper.writeValueAsString(result);
	}
	
	
	
}
