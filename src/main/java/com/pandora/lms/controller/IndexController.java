package com.pandora.lms.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.pandora.lms.dto.UserInfoDto;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.pandora.lms.service.NoticeService;
import com.pandora.lms.util.TextChangeUtil;
import com.pandora.lms.util.socket.IPGetter;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class IndexController {
	
    private final NoticeService noticeService;
    private final TextChangeUtil textChangeUtil;
    private final IPGetter ipGetter;
    private final SqlSession sqlSession;
   
  
    @GetMapping("/")
    public ModelAndView main(@RequestParam Map<String, Object> userInfo, HttpSession session){
            ModelAndView mv = new ModelAndView("/index");
            int totalCount = noticeService.mainNoticCnt();
            List<Map<String, Object>> list = noticeService.mainNoticeList();
            for (Map<String, Object> m : list) {
                m.put("notice_title", textChangeUtil.changeText((String) m.get("notice_title")));
            }
            System.err.println(ipGetter.getIP());
            mv.addObject("list", list);
            mv.addObject("totalCount", totalCount);
            mv.addObject("myIp",ipGetter.getIP());   
            
            if(session.getAttribute("appl_no") == null && session.getAttribute("instr_no") == null) {
                mv.setViewName("redirect:/login");
                return mv;
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
            
            mv.addObject("lecture", lecture);
            
            return mv;
   }

    @GetMapping("/index")
    public ModelAndView index(@RequestParam Map<String, Object> userInfo, HttpSession session) {
        
            ModelAndView mv = new ModelAndView("/index");
            int totalCount = noticeService.mainNoticCnt();
            List<Map<String, Object>> list = noticeService.mainNoticeList();
            for (Map<String, Object> m : list) {
                m.put("notice_title", textChangeUtil.changeText((String) m.get("notice_title")));
            }
            System.err.println(ipGetter.getIP());
            mv.addObject("list", list);
            mv.addObject("totalCount", totalCount);
            mv.addObject("myIp",ipGetter.getIP());
            
            if(session.getAttribute("appl_no") == null && session.getAttribute("instr_no") == null) {
                mv.setViewName("redirect:/login");
                return mv;
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
            
            mv.addObject("lecture", lecture);
            
            return mv;
    }
    
    @GetMapping("/giveall")
    public @ResponseBody String giveall() {
        
            
            return "apion";
    }

}
