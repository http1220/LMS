package com.pandora.lms.service;

import com.pandora.lms.dao.MessageDAO;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@AllArgsConstructor
@Service
public class MessageService {

    private final MessageDAO messageDAO;

    public int msgCount(Map<String, Object> pages) { return messageDAO.msgCount(pages); }

    public List<Map<String, Object>> msgList(Map<String, Object> pages) { return messageDAO.msgList(pages); }

    public int msgRead(String msgNo) { return messageDAO.msgRead(msgNo); }

    public int msgDel(String msgNo) { return messageDAO.msgDel(msgNo); }

    public int msgNew(String userId) { return messageDAO.msgNew(userId); }
}
