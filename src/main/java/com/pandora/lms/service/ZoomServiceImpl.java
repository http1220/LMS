package com.pandora.lms.service;

import com.pandora.lms.dao.ZoomDAO;
import com.pandora.lms.dto.ZoomDTO;
import okhttp3.*;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Service
public class ZoomServiceImpl implements ZoomService {

    @Autowired
    private ZoomDAO zoomDAO;


    public String meeting(String accessToken) throws IOException {
        OkHttpClient client = new OkHttpClient(); /*통신을 위한 OkHttp*/

        String meetingUrl = "https://api.zoom.us/v2/users/date810@naver.com/meetings"; // date810@naver.com :사용자 ID 필요함

        // Zoom API 요청에 필요한 회의 개설내용 정의
        JSONObject jsonBody = new JSONObject();
        jsonBody.put("topic", "자바 수업");  //회의 이름
        jsonBody.put("type", 2);// 회의 타입  >> 0: 기본 회0의, 1: 일회성 회의, 2: 반복 회의
        //jsonBody.put("start_time", "2023-04-12T22:00:00");    //회의 시작시간_기본 현재시간
        jsonBody.put("duration", 40);   //회의 시간 (40분)
        jsonBody.put("password", "1234");
        // settings 객체 생성
        JSONObject settings = new JSONObject();
        settings.put("join_before_host", true);   // 호스트가 입장하기 전에 참여 가능 여부
        settings.put("auto_approve", true);       // 참여 요청 승인 설정
        jsonBody.put("settings", settings);


        //Zoom API 요청에 필요한 HTTP 헤더를 정의
        String authHeader = "Bearer " + accessToken;
        MediaType mediaType = MediaType.parse("application/json");
        Headers headers = new Headers.Builder()
                .add("Authorization", authHeader)
                .add("Content-Type", "application/json")
                .build();

        //Zoom API 요청 생성
        RequestBody body = RequestBody.create(mediaType, jsonBody.toString());
        Request request = new Request.Builder()
                .url(meetingUrl)
                .headers(headers)
                .post(body)
                .build();

        //Zoom API 요청
        Response response = client.newCall(request).execute();

        //요청 성공시 회의 url 반환
        if (response.isSuccessful()) {
            JSONObject responseBody = new JSONObject(response.body().string());
            System.err.println(responseBody);
            String meeting_no = Long.toString(responseBody.getLong("id"));
            String meeting_ps = responseBody.getString("h323_password");
            System.err.println("미팅 참가 번호 : "+meeting_no);
            System.err.println("미팅 참가 비번 : "+meeting_ps);

            String joinUrl = responseBody.getString("join_url");

            System.err.println("Join URL: " + joinUrl);
            return joinUrl;
        } else { //요청 실패시 에러메시지 반환
            String errorMessage = response.body().string();
            System.err.println("Error: " + errorMessage);
            return errorMessage;
        }
    }

    @Override
    public ZoomDTO authority(ZoomDTO zoomDTO) {
        return zoomDAO.authority(zoomDTO);
    }

    @Override
    public void join_url(ZoomDTO zoomDTO) {
        zoomDAO.join_url(zoomDTO);
    }

    @Override
    public void meeting_msg(ZoomDTO zoomDTO) {
        zoomDAO.meeting_msg(zoomDTO);
    }

    @Override
    public int zoom_exit(ZoomDTO zoomDTO) {

        return zoomDAO.zoom_exit(zoomDTO);
    }

    @Override
    public ZoomDTO zoom_join(ZoomDTO zoomDTO) {

        return zoomDAO.zoom_join(zoomDTO);
    }

    @Override
    public List<Map<String, Object>> student_list(ZoomDTO zoomDTO) {

        return zoomDAO.student_list(zoomDTO);
    }

    @Override
    public void attendances_check(ZoomDTO zoomDTO) {
        zoomDAO.attendance_check(zoomDTO);
    }


}
