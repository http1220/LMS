package com.pandora.lms.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pandora.lms.dao.CheckDAO;
import com.pandora.lms.dao.SubjectDAO;

@Service
public class CheckService {

	@Autowired
	CheckDAO checkDAO;

	public List<Map<String, Object>> AjaxStudent(Map<String, Object> paramMap) {
		return checkDAO.AjaxStudent(paramMap);
	}

	public List<Map<String, Object>> AjaxInstrSearch(Map<String, Object> paramMap) {
		return checkDAO.AjaxInstrSearch(paramMap);
	}

	public void ChangeInstr(int instrNo) {
		checkDAO.ChangeInstr(instrNo);
		
	}

	


	
	
	
}
