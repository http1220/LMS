package com.pandora.lms.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface MessageDAO {

    int msgCount(Map<String, Object> pages);

    List<Map<String, Object>> msgList(Map<String, Object> pages);
    int msgRead(String msgNo);

    int msgDel(String msgNo);

    int msgNew(String userId);
}
