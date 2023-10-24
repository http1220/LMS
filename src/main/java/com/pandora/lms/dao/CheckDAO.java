package com.pandora.lms.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface CheckDAO {

	List<Map<String, Object>> AjaxStudent(Map<String, Object> paramMap);

	List<Map<String, Object>> AjaxInstrSearch(Map<String, Object> paramMap);

	void ChangeInstr(int instrNo);

	

	

	

}
