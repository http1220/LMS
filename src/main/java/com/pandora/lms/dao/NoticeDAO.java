package com.pandora.lms.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Mapper
@Repository
public interface NoticeDAO {

    int noticeCount(Map<String, Object> pages);

    List<Map<String, Object>> noticeList(Map<String, Object> pages);

    void noticeRead(String noticeNo);

    Map<String, Object> noticeDetail(String noticeNo);

    void noticeWrite(Map<String, Object> map);

    void noticeUpdate(Map<String, Object> map);

    int noticeDelete(String noticeNo);

    int noticeNo(String rowNum);

    int mainNoticCnt();

    List<Map<String, Object>> mainNoticeList();
}
