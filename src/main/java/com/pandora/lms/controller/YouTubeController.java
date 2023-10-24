package com.pandora.lms.controller;


import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.pandora.lms.ytbUtil.UploadVideo;
import org.apache.commons.io.FilenameUtils;
import org.apache.ibatis.session.SqlSession;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.api.client.auth.oauth2.Credential;
import com.pandora.lms.ytbUtil.OAuth;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class YouTubeController {

    private final OAuth oAuth;
    private final SqlSession sqlSession;
    private final ServletContext context;

    @GetMapping("/lecture")
    public ModelAndView lecture(@RequestParam Map<String, Object> userInfo, HttpSession session) {
        ModelAndView view = new ModelAndView("/youtube/lecture");

        if(session.getAttribute("appl_no") == null && session.getAttribute("instr_no") == null) {
            view.setViewName("redirect:/login");
            return view;
        }

        List<Map<String, Object>> lecture = null;

        if(session.getAttribute("appl_no") != null) {
            userInfo.put("appl_no", session.getAttribute("appl_no"));
            lecture = sqlSession.selectList("youtube.lecture", userInfo);

            for(Map<String, Object> data : lecture) {
                Float TOTAL_LECT_CNT = Float.parseFloat(String.valueOf(data.get("TOTAL_LECT_CNT")));
                Float APPL_ATND_CNT = Float.parseFloat(String.valueOf(data.get("APPL_ATND_CNT")));

                data.replace("TOTAL_LECT_CNT", TOTAL_LECT_CNT);
                data.replace("APPL_ATND_CNT", APPL_ATND_CNT);

                if(APPL_ATND_CNT != 0) {
                    Integer LECT_MAG = (int) ((APPL_ATND_CNT / TOTAL_LECT_CNT) * 100);
                    data.put("LECT_MAG", LECT_MAG);
                } else {
                    data.put("LECT_MAG", 0);
                }
            }
        } else if(session.getAttribute("instr_no") != null) {
            userInfo.put("instr_no", session.getAttribute("instr_no"));
            lecture = sqlSession.selectList("youtube.lecture", userInfo);
        }
        
        view.addObject("lecture", lecture);
        
        return view;
    }

    @GetMapping("/lectureATND")
    public ModelAndView getATND(@RequestParam int sbjct_no) {
        ModelAndView view = new ModelAndView("youtube/lectureATND");
        List<String> applList = sqlSession.selectList("youtube.getApplList", sbjct_no);
        Integer clsCdCount = sqlSession.selectOne("youtube.getClsCdCount", sbjct_no);
        Integer applClsCount = sqlSession.selectOne("youtube.getApplClsCount", sbjct_no);
        List<Map<String, Object>> atndInfo = sqlSession.selectList("youtube.getATND", sbjct_no);

        System.out.println(applList);

        view.addObject("applList", applList);
        view.addObject("clsCdCount", clsCdCount);
        view.addObject("applClsCount", applClsCount);
        view.addObject("atndInfo", atndInfo);

        return view;
    }
    
    //Calendar함수
    public static int getWeek() {  //list, detail용
    	Calendar cal = Calendar.getInstance();  
    	
    	//개강일자 입력
    	cal.set(Calendar.YEAR, 2023);
    	//1월 : JANUARY, 2월 : FEBRUARY, 3월 : MARCH, 4월 : APRIL, 5월 : MAY, 6월 : JUNE
		//7월 : JULY, 8월 : AUGUST, 9월 : SEPTEMBER, 10월 : OCTOBER, 11월 : NOVEMBER, 12월 : DECEMBER
    	cal.set(Calendar.MONTH, Calendar.APRIL);
    	cal.set(Calendar.DATE, 24);
    	
    	cal.setMinimalDaysInFirstWeek(7); //한주를 최소 7일로 설정
    	cal.setFirstDayOfWeek(Calendar.MONDAY);//한주의 첫 번째요일을 월요일로 설정
    	
    	int week = cal.get(Calendar.WEEK_OF_MONTH);
    	System.out.println(week + "주차입니다.");
    	
    	return week;
    }
    
    
    @GetMapping("/lectureList")
    public ModelAndView youtubeList(@RequestParam Map<String, Object> lectureInfo, HttpSession session) {
        ModelAndView view = new ModelAndView("youtube/lectureList");

       	int week = getWeek();
       	
        if(session.getAttribute("appl_no") == null && session.getAttribute("instr_no") == null) {
            view.setViewName("redirect:/login");
            return view;
        }

        lectureInfo.put("appl_no", session.getAttribute("appl_no"));
        List<Map<String, Object>> lectList = sqlSession.selectList("youtube.lectList", lectureInfo);
        
        List<Map<String, Object>> notice = sqlSession.selectList("youtube.notice", lectureInfo);

        for(Map<String, Object> lectInfo : lectList) {
            if( lectInfo.get("FILE_SN") != null ) {
                int FILE_LENGTH = String.valueOf(lectInfo.get("FILE_SN_SEQ")).split(",").length;
                String[] PHYS_FILE_NM, ORGNL_FILE_NM, FILE_SN_SEQ, FILE_EXTN_NM, FILE_SZ;

                FILE_SN_SEQ = String.valueOf(lectInfo.get("FILE_SN_SEQ")).split(",");
                PHYS_FILE_NM = String.valueOf(lectInfo.get("PHYS_FILE_NM")).split(",");
                ORGNL_FILE_NM = String.valueOf(lectInfo.get("ORGNL_FILE_NM")).split(",");
                FILE_EXTN_NM = String.valueOf(lectInfo.get("FILE_EXTN_NM")).split(",");
                FILE_SZ = String.valueOf(lectInfo.get("FILE_SZ")).split(",");

                List<String> PHYS_FILE_NM_LS = new ArrayList<>();
                List<String> ORGNL_FILE_NM_LS = new ArrayList<>();
                List<String> FILE_SN_SEQ_LS = new ArrayList<>();
                List<String> FILE_EXTN_NM_LS = new ArrayList<>();
                List<String> FILE_SZ_LS  = new ArrayList<>();

                lectInfo.put("FILE_LENGTH", FILE_LENGTH);
                for(int i = 0; i < FILE_LENGTH; i++) {
                    PHYS_FILE_NM_LS.add(PHYS_FILE_NM[i]);
                    ORGNL_FILE_NM_LS.add(ORGNL_FILE_NM[i]);
                    FILE_SN_SEQ_LS.add(FILE_SN_SEQ[i]);
                    FILE_EXTN_NM_LS.add(FILE_EXTN_NM[i]);
                    FILE_SZ_LS.add(FILE_SZ[i]);
                }
                lectInfo.put("PHYS_FILE_NM_LS", PHYS_FILE_NM_LS);
                lectInfo.put("ORGNL_FILE_NM_LS", ORGNL_FILE_NM_LS);
                lectInfo.put("FILE_SN_SEQ_LS", FILE_SN_SEQ_LS);
                lectInfo.put("FILE_EXTN_NM_LS", FILE_EXTN_NM_LS);
                lectInfo.put("FILE_SZ_LS", FILE_SZ_LS);

                lectInfo.remove("PHYS_FILE_NM");
                lectInfo.remove("ORGNL_FILE_NM");
                lectInfo.remove("FILE_SN_SEQ");
                lectInfo.remove("FILE_EXTN_NM");
                lectInfo.remove("FILE_SZ");
            }
        }

        view.addObject("sbjct_no", lectureInfo.get("sbjct_no"));
        view.addObject("notice", notice);
        view.addObject("lectList", lectList);
        view.addObject("week", week);
        System.out.println(lectList);
        
        return view;
    }

    @GetMapping("/lectureNoticeDetail")
    @ResponseBody
    public String lectureNoticeDetail(@RequestParam Integer notice_no) {
        JSONObject jsonObject = new JSONObject();

        Map<String, Object> detail = sqlSession.selectOne("youtube.lectureNoticeDetail", notice_no);

        jsonObject.put("notice_no", detail.get("notice_no"));
        jsonObject.put("admin_id", detail.get("admin_id"));
        jsonObject.put("notice_title", detail.get("notice_title"));
        jsonObject.put("notice_content", detail.get("notice_content"));
        jsonObject.put("notice_read", detail.get("notice_read"));
        jsonObject.put("notice_date", detail.get("notice_date"));
        jsonObject.put("notice_like", detail.get("notice_like"));

        return jsonObject.toString();
    }

    @PostMapping("/lectureNoticeWrite")
    @ResponseBody
    public String lectureNoticeWrite(@RequestParam Map<String, Object> notice) {
        System.out.println(notice);

        String msg = "";
        int reuslt = sqlSession.insert("youtube.noticeWrite", notice);

        if(reuslt != 1) {
            msg = "error";
        } else {
            msg = "success";
        }

        return msg;
    }

    @GetMapping("/lectureDetail")
    public ModelAndView lectureDetail(@RequestParam Map<String, Object> userInfo, HttpSession session) {
        ModelAndView view = new ModelAndView("youtube/lectureDetail");
        
        int week = getWeek();
       	
        if(session.getAttribute("appl_no") == null && session.getAttribute("instr_no") == null) {
            view.setViewName("redirect:/login");
            return view;
        }

        userInfo.put("appl_no", session.getAttribute("appl_no"));

        Map<String, Object> lectureInfo = sqlSession.selectOne("youtube.lectDetail", userInfo);

        if(session.getAttribute("appl_no") != null) {
            int seconds = (Integer) lectureInfo.get("LAST_PLAY_TM");
            int minutes = seconds / 60;
            int remainingSeconds = seconds % 60;
            String LAST_PLAY_TM2 = minutes + "분 " + remainingSeconds + "초";

            lectureInfo.replace("LECT_PRGRS_RT", Math.ceil((Float) lectureInfo.get("LECT_PRGRS_RT")) );
            lectureInfo.put("LAST_PLAY_TM2", LAST_PLAY_TM2);
        }

        view.addObject("lectureInfo", lectureInfo);
        view.addObject("week", week);
        
        return view;
    }

    @PostMapping("/getPlayTime")
    @ResponseBody
    public Integer getPlayTime(@RequestParam Map<String, Object> userInfo, HttpSession session) {
        userInfo.put("appl_no", session.getAttribute("appl_no"));
        return sqlSession.selectOne("youtube.getPlayTime", userInfo);
    }

    @PostMapping("/playTimeSave")
    @ResponseBody
    public String playTimeSave(@RequestParam Map<String, Object> userInfo, HttpSession session) {
        userInfo.put("appl_no", session.getAttribute("appl_no"));

        // 종료 교시 코드 가져오기
        Map<String, Integer> clsCd = sqlSession.selectOne("youtube.getClsCd", userInfo);

        Integer today = Integer.parseInt(String.valueOf(userInfo.get("today")));
        Integer BGNG_CLS_CD = clsCd.get("BGNG_CLS_CD");
        Integer END_CLS_CD = clsCd.get("END_CLS_CD");

        String msg;

        if( (BGNG_CLS_CD >= today) && (END_CLS_CD <= today) ) {
            int playTime = sqlSession.selectOne("youtube.getPlayTime", userInfo);
            int saveTime = Integer.parseInt(String.valueOf(userInfo.get("curr_time")));

            if ( (saveTime - playTime) > 5 ) {
                System.out.println("비정상적인 저장 접근입니다.");
                msg = "fail";
            } else {
                int result = sqlSession.update("youtube.playTimeSave", userInfo);
                msg = (result == 1) ? "success" : "fail";
            }
        } else {
            System.out.println("교시가 지났습니다.");
            msg = "fail";
        }

        return msg;
    }

    @PostMapping("/applATNDInsert")
    @ResponseBody
    public String applATNDInsert(@RequestParam Map<String, Object> userInfo, HttpSession session) {
        if(session.getAttribute("appl_no") == null && session.getAttribute("instr_no") == null) {
            return "fail";
        }
        userInfo.put("appl_no", session.getAttribute("appl_no"));

        Map<String, Object> lectInfo = sqlSession.selectOne("youtube.getLectInfo", userInfo);
        int result = sqlSession.insert("youtube.applATNDInsert", lectInfo);

        return "success";
    }

    @PostMapping("/modalUpload")
    @ResponseBody
    public String modalUpload(@RequestParam Map<String, Object> modalInfo, @RequestPart(name = "file", required = false) MultipartFile file) throws IOException {
        String uploadSelect = (String) modalInfo.get("upload-select");
        String result = null;

        if(uploadSelect.equals("assign")) {
            System.out.println("과제 등록");
            result = "success";
        } else if(uploadSelect.equals("file")) {
            if(file.getSize() == 0) {
                result = "empty_file";
            } else {
                Map<String, Object> fileInfo = new HashMap<>();

                String realPath = context.getRealPath("/");
                String uploadPath = "/resources/" + "upload/";

                File uploadDir = new File(realPath + uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                File uploadFile = new File(uploadDir, file.getOriginalFilename());
                FileCopyUtils.copy(file.getBytes(), uploadFile);

                fileInfo.put("FILE_SN", modalInfo.get("on_lect_sn"));
                Integer FILE_SN_SEQ = (Integer) sqlSession.selectOne("youtube.getFileSnSeq", modalInfo);

                if(FILE_SN_SEQ != null) fileInfo.put("FILE_SN_SEQ",  FILE_SN_SEQ + 1);
                else fileInfo.put("FILE_SN_SEQ",  1);

                fileInfo.put("PHYS_FILE_NM", modalInfo.get("title"));
                fileInfo.put("ORGNL_FILE_NM", FilenameUtils.getBaseName(file.getOriginalFilename()));
                fileInfo.put("FILE_PATH_NM", uploadPath);
                fileInfo.put("FILE_EXTN_NM", FilenameUtils.getExtension(file.getOriginalFilename()));
                fileInfo.put("FILE_SZ", file.getSize());

                System.out.println(uploadPath);
                System.out.println(fileInfo);

                int file_result = sqlSession.insert("youtube.insertFileInfo", fileInfo);

                if(file_result == 1) result = "success";
                else result = "error";
            }
        }

        return result;
    }

    @GetMapping("/fileDownload/{file}")
    public void fileDownload(@PathVariable String file, HttpServletResponse response) throws IOException {
        Map<String, Object> fileInfo = new HashMap<>();
        fileInfo.put("file_sn", file.split(",")[0]);
        fileInfo.put("file_sn_seq", file.split(",")[1]);

        Map<String, String> downloadFile = sqlSession.selectOne("youtube.getFileInfo", fileInfo);

        String serverPath = context.getRealPath("/") + downloadFile.get("FILE_PATH_NM");
        File serverFile = new File(serverPath, downloadFile.get("ORGNL_FILE_NM") + "." + downloadFile.get("FILE_EXTN_NM"));

        // file 다운로드 설정
        response.setContentType("application/download");
        response.setContentLength( (int) serverFile.length() );
        String fileName = downloadFile.get("PHYS_FILE_NM");
        String fileExtn = downloadFile.get("FILE_EXTN_NM");
        String encodedFilename = URLEncoder.encode(fileName + "." + fileExtn, "UTF-8");
        encodedFilename = encodedFilename.replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename=" + encodedFilename);

        // response 객체를 통해서 서버로부터 파일 다운로드
        OutputStream os = response.getOutputStream();

        // 파일 입력 객체 생성
        FileInputStream fis = new FileInputStream(serverFile);
        FileCopyUtils.copy(fis, os);

        fis.close();
        os.flush();

        response.flushBuffer();
        os.close();
    }

    @PostMapping("/youtubeAccess")
    @ResponseBody
    public String youtubeAccess() throws Exception {
        List<String> scopes = new ArrayList<>();
        scopes.add("https://www.googleapis.com/auth/youtube");

        Credential credential = oAuth.authorize(scopes, false);
        if (credential != null) {
            return "인증이 완료 됐습니다.";
        } else {
            return null;
        }
    }

    @GetMapping("/uploadVideo")
    public ModelAndView uploadVideo() throws Exception {
        ModelAndView view = new ModelAndView("youtube/uploadVideo");

        List<String> scopes = new ArrayList<>();
        scopes.add("https://www.googleapis.com/auth/youtube");

        Credential credential = oAuth.authorize(scopes, true);

        if (credential != null) {
            view.addObject("auth", true);
        } else {
            view.addObject("auth", false);
        }
        
        return view;
    }

    @PostMapping("/uploadVideo")
    public String uploadVideo(@RequestParam Map<String, Object> videoInfo, @RequestPart(name = "video_file") MultipartFile videoFile) throws Exception {
        System.out.println("동영상 정보 : " + videoInfo);
        System.out.println("동영상 파일 : " + videoFile);
        
        List<String> scopes = new ArrayList<>();
        scopes.add("https://www.googleapis.com/auth/youtube");

        Credential credential = oAuth.authorize(scopes, true);
        UploadVideo uploadVideo = new UploadVideo();
        Map<String, Object> result = uploadVideo.uploadVideo(credential, videoFile, videoInfo);

        //DB에 저장하는 로직
        sqlSession.insert("youtube.insertNewYOUtubeLecture", result);
        
        return "redirect:/uploadVideo";
    }
    
//    @GetMapping("/youtubetesting")
//    public void youtubetesting() {
//    	Map<String, Object> result = new HashMap<String, Object>();
//    	result.put("CRCLM_CD", "150902");
//        result.put("SBJCT_NO", "2234");
//        result.put("ON_LECT_NM", "거시경제학");
//        result.put("ON_LECT_CN", "국가 단위의 글로벌 규모의 경제를 학습");
//        result.put("ON_LECT_URL", "kakao");
//    	sqlSession.insert("youtube.insertNewYOUtubeLecture", result);
//    }

}