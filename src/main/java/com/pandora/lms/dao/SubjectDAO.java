package com.pandora.lms.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface SubjectDAO {

	List<Map<String, Object>> AjaxSubject(Map<String, Object> paramMap);

	List<Map<String, Object>> AjaxDetail(Map<String, Object> paramMap);

}
