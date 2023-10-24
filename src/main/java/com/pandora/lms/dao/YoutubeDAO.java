package com.pandora.lms.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class YoutubeDAO {

	private SqlSession sqlSession;
	
	//public List<Map<String, Object>> lectureInfo() {
	//	return selectOne("youtube.lectureInfo");
	//}
}
