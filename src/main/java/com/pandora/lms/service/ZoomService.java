package com.pandora.lms.service;

import com.pandora.lms.dto.ZoomDTO;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Service
public interface ZoomService {


    String meeting(String accessToken) throws IOException;

    ZoomDTO authority(ZoomDTO zoomDTO);


    void join_url(ZoomDTO zoomDTO);

    void meeting_msg(ZoomDTO zoomDTO);

    int zoom_exit(ZoomDTO zoomDTO);

    ZoomDTO zoom_join(ZoomDTO zoomDTO);


    List<Map<String, Object>> student_list(ZoomDTO zoomDTO);


    void attendances_check(ZoomDTO zoomDTO);
}