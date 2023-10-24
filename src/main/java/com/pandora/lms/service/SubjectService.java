package com.pandora.lms.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pandora.lms.dao.SubjectDAO;

@Service
public class SubjectService {

	@Autowired
	SubjectDAO subjectDAO;

	public List<Map<String, Object>> AjaxSubject(Map<String, Object> paramMap) {
		return subjectDAO.AjaxSubject(paramMap);
	}

	public List<Map<String, Object>> AjaxDetail(Map<String, Object> paramMap) {
		return subjectDAO.AjaxDetail(paramMap);
	}


	
	
	
}
