package com.pandora.lms.controller;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.pandora.lms.dto.ZoomDTO;
import com.pandora.lms.service.ZoomService;
import com.pandora.lms.util.socket.AlarmHandler;
import lombok.AllArgsConstructor;
import okhttp3.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@AllArgsConstructor
@Controller
public class ZoomController {

    private final ZoomService zoomService;
    private final AlarmHandler alarmHandler;

    @PostMapping("/zoom_open")
    @ResponseBody
    public String Zoom_open(HttpSession session, @RequestParam Integer sbjct_no) throws IOException{
        ZoomDTO zoomDTO = new ZoomDTO();
        int user_no = (int) session.getAttribute("user_no");
        zoomDTO.setUser_no(user_no);
        ZoomDTO result = zoomService.authority(zoomDTO);


        if(result.getZOOM_AUTH() == 1){
            String message = "회의가 개설되었습니다.";
            alarmHandler.sendMessage(message);  // 쪽지 알람
            return sbjct_no.toString();
        }else{
            return "";
        }
    }

    @GetMapping("/zoom/token")
    public ModelAndView get_token(@RequestParam("code") String code, Model model, HttpServletRequest request, HttpSession session, @RequestParam Integer sbjct_no) throws IOException {
        OkHttpClient client = new OkHttpClient(); /*통신을 위한 OkHttp*/
        ObjectMapper mapper = new ObjectMapper();/*Json 처리를 위하여 생성*/
        ZoomDTO zoomDTO = new ZoomDTO();
        ModelAndView mv = new ModelAndView("/zoom");
        String zoomUrl = "https://zoom.us/oauth/token"; //Access token 을 받는 zoom api 호출 url

        FormBody formBody = new FormBody.Builder()/*http 요청 바디를 만듬*/
                .add("code", code) // 1단계에서 받은 code 값
                .add("grant_type", "authorization_code") // 문서에 명시 된 grant_type
                .add("redirect_uri", "http://localhost/zoom/token?sbjct_no=" + sbjct_no) //등록 된 uri
                /*.add("code_verifier", DecEncUtil.encode(code))*/ // 나중에 시간이 된다면 code를 SHA-256 방식으로 암호화하여 전달할 예정
                .build();

        Request zoomRequest = new Request.Builder()/*http 요청 헤더를 만듬*/
                .url(zoomUrl) // 호출 url
                .addHeader("Content-Type", "application/x-www-form-urlencoded") // 공식 문서에 명시 된 type
                .addHeader("Authorization", "Basic S3B2dThxakRTWkNFbkV0elo1OEtuQTpaUXVYQlRhYTlXTUFWVk82VFJMTG1kVG9vVlVsNkk5NQ==") // Client_ID:Client_Secret 을  Base64-encoded 한 값
                .post(formBody)
                .build();


        Response zoomResponse = client.newCall(zoomRequest).execute();/*client를 사용하여 zoomRequest를 서버로 보내고 응답 받은 내용을  zoomResponse에 저장*/
        String zoomText = zoomResponse.body().string();/*zoomResponse 응답 받은 내용을 문자열로 바꿔줌*/

        mapper.configure(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY, true);/*위에서 생성한  ObjectMapper에 벨류값을 배열 타입으로 만들어줌*/
        List<Object> list = mapper.readValue(zoomText, new TypeReference<List<Object>>() {
        });

        model.addAttribute("response", list.get(0));
        model.addAttribute("code", code);


        Object responseObj = model.getAttribute("response");
        Map<String, Object> responseMap = (Map<String, Object>) responseObj;
        String accessToken = (String) responseMap.get("access_token");
        session.setAttribute("sbjct_no",sbjct_no);

        System.err.println("요청한 내용 : " + model.getAttribute("response"));
        System.err.println("사용자 코드 : " + model.getAttribute("code"));
        System.err.println("엑세스 토큰 : " + accessToken);


        String join_url = zoomService.meeting(accessToken);/*화의 개설*/

        zoomDTO.setJoin_url(join_url);
        zoomDTO.setSbjct_no(sbjct_no);
        zoomService.join_url(zoomDTO);/*DB에 join_url 삽입*/
        /*========================*//*해당 강사의 강의를 수강하고 있는 학생에게 쪽지 발송*/
        int instr_no = (int) session.getAttribute("instr_no");
        zoomDTO.setLogin_id((String) session.getAttribute("id"));
        zoomDTO.setInstr_no(instr_no);
        zoomService.meeting_msg(zoomDTO);
        /*========================*/
        String message = "회의가 개설되었습니다.";
        alarmHandler.sendMessage(message);  // 쪽지 알람
        /*========================*/
        mv.addObject("Join_URL",join_url);
        /*========================*//*해당 강사의 강의를 수강하고 있는 학생들 명단 출력*/
        List<Map<String, Object>> student_list = zoomService.student_list(zoomDTO);
        mv.addObject("student_list",student_list);

        return mv;
    }



    @PostMapping("/zoom_exit")
    @ResponseBody
    public int zoom_exit(HttpSession session){
        ZoomDTO zoomDTO = new ZoomDTO();

        zoomDTO.setSbjct_no((Integer) session.getAttribute("sbjct_no"));
        System.err.println("과목 번호 : "+ zoomDTO.getSbjct_no());

        int result = zoomService.zoom_exit(zoomDTO);
        System.err.println(result);

        return result;
    }

    @PostMapping("/zoom_join")
    @ResponseBody
    public String zoom_join(@RequestParam Integer sbjct_no){
        ZoomDTO zoomDTO = new ZoomDTO();
        ModelAndView mv = new ModelAndView("zoom_student");
        zoomDTO.setSbjct_no(sbjct_no);


        ZoomDTO zoom_url = zoomService.zoom_join(zoomDTO);
        String join_url = zoom_url.getJoin_url();

        if (join_url.contains("https://us05web.zoom.us/j")) {
            return join_url;
        }else {
            return "";
        }
    }

    @GetMapping("/zoom_student")
    public ModelAndView zoom_student(@RequestParam String join_url){
        ModelAndView mv = new ModelAndView("zoom_student");
        mv.addObject("Join_URL", join_url);



        return mv;
    }

    @PostMapping("/attendance")
    @ResponseBody
    public String attendance(HttpServletRequest request,HttpSession session){
        ZoomDTO zoomDTO = new ZoomDTO();
        String[] attendance = request.getParameterValues("attendance_check[]");
        String[] absence = request.getParameterValues("absence_check[]");


        zoomDTO.setSbjct_no((Integer) session.getAttribute("sbjct_no"));
        zoomDTO.setAttendance(attendance);
        zoomDTO.setAbsence(absence);

        zoomService.attendances_check(zoomDTO);

        return "잘옴";
    }


}

