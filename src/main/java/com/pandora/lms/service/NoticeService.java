package com.pandora.lms.service;

import com.pandora.lms.dao.NoticeDAO;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@AllArgsConstructor
@Service
public class NoticeService {

    private final NoticeDAO noticeDAO;

    public int noticeCount(Map<String, Object> pages) { return noticeDAO.noticeCount(pages); }

    public List<Map<String, Object>> noticeList(Map<String, Object> pages) { return noticeDAO.noticeList(pages); }

    public void noticeRead(String noticeNo) { noticeDAO.noticeRead(noticeNo); }

    public Map<String, Object> noticeDetail(String noticeNo) { return noticeDAO.noticeDetail(noticeNo); }

    public void noticeWrite(Map<String, Object> map) { noticeDAO.noticeWrite(map); }

    public void noticeUpdate(Map<String, Object> map) { noticeDAO.noticeUpdate(map); }

    public int noticeDelete(String noticeNo) { return noticeDAO.noticeDelete(noticeNo); }

    public int noticeNo(String rowNum) { return noticeDAO.noticeNo(rowNum); }

    public int mainNoticCnt() { return noticeDAO.mainNoticCnt(); }

    public List<Map<String, Object>> mainNoticeList() { return noticeDAO.mainNoticeList(); }
}
