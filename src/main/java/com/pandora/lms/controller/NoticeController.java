package com.pandora.lms.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.pandora.lms.service.NoticeService;
import com.pandora.lms.util.TextChangeUtil;
import com.pandora.lms.util.socket.AlarmHandler;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class NoticeController {

    private final NoticeService noticeService;
    private final TextChangeUtil textChangeUtil;
    private final AlarmHandler alarmHandler;

    @GetMapping("/noticeIframe")
    public String noticeIframe() { 
    	return "/notice/noticeIframe"; 
    	}

    @GetMapping("/notice")
    public ModelAndView noticeList(@RequestParam(value = "pageNo", defaultValue = "1") int pageNo, HttpServletRequest request, HttpSession session) {

            ModelAndView mv = new ModelAndView("/notice/notice");
            Map<String, Object> pages = new HashMap<String, Object>();
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");
            pages.put("searchType", searchType);
            pages.put("searchValue", searchValue);
            int startPage = (pageNo * 10) - 10;
            int totalCount = noticeService.noticeCount(pages);
            int lastPage = (int) Math.ceil((double) totalCount / 10);
            if(searchType == null){
                if((startPage+10)>totalCount) {
                    startPage = totalCount - 10;
                    pageNo = lastPage;
                }
            }
            pages.put("startPage", startPage);
            pages.put("lastPage", lastPage);
            List<Map<String, Object>> list = noticeService.noticeList(pages);
            for (Map<String, Object> m : list) { m.put("notice_title", textChangeUtil.changeText((String) m.get("notice_title"))); }
            mv.addObject("pages", pages);
            mv.addObject("list", list);
            mv.addObject("pageNo", pageNo);
            mv.addObject("totalCount", totalCount);
            return mv;
        }

    

    @GetMapping("/noticeDetail")
    public ModelAndView noticeDetail(HttpServletRequest request, HttpSession session) {

            ModelAndView mv = new ModelAndView("/notice/noticeDetail");
            String rowNum = request.getParameter("rowNum");
            String totalCnt = request.getParameter("totalCnt");

            if (Integer.parseInt(rowNum) >= Integer.parseInt(totalCnt)) rowNum = totalCnt;
            else if (Integer.parseInt(rowNum) < 1) rowNum = "1";

            String notice_no = Integer.toString(noticeService.noticeNo(rowNum));
            noticeService.noticeRead(notice_no);
            Map<String, Object> noticeDetail = noticeService.noticeDetail(notice_no);
            textChangeUtil.changeText((String) noticeDetail.get("notice_title"));
            noticeDetail.put("notice_title", textChangeUtil.changeEnter((String) noticeDetail.get("notice_title")));
            noticeDetail.put("notice_content", textChangeUtil.changeEnter((String) noticeDetail.get("notice_content")));
            mv.addObject("noticeDetail", noticeDetail);
            mv.addObject("rowNum", rowNum);
            mv.addObject("totalCnt", totalCnt);
            return mv;
        }
    

    @GetMapping("/noticeWrite")
    public String noticeWrite(HttpSession session) {
        System.out.println(session.getAttribute("id"));
        if (session.getAttribute("user_no") == null) return "redirect:/login";
        else if (!session.getAttribute("id").equals("dudu")) return "redirect:/notice";
        else return "/notice/noticeWrite";
    }

    @PostMapping("/noticeWrite")
    public String noticeWrite(HttpServletRequest request, HttpSession session) throws IOException {
        if (session.getAttribute("user_no") == null) return "redirect:/login";
        else {
            String notice_title = request.getParameter("writeTitle");
            notice_title = textChangeUtil.changeText(notice_title);
            String notice_content = request.getParameter("writeContent");
            String rowNum = request.getParameter("rowNum");
            String totalCnt = request.getParameter("totalCnt");
            System.out.println("rowNum : " + rowNum);
            System.out.println("totalCnt : " + totalCnt);
            if (rowNum == null) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("notice_title", notice_title);
                map.put("notice_content", notice_content);
                noticeService.noticeWrite(map);
                String notification = "공지사항이 업데이트 되었습니다.";
                alarmHandler.sendNotification(notification);
                return "redirect:/notice";
            } else {
                String notice_no = Integer.toString(noticeService.noticeNo(rowNum));
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("notice_title", notice_title);
                map.put("notice_content", notice_content);
                map.put("notice_no", notice_no);
                noticeService.noticeUpdate(map);
                return "redirect:/noticeDetail?rowNum=" + rowNum + "&totalCnt=" + totalCnt;
            }
        }
    }

    @GetMapping("/noticeUpdate")
    public ModelAndView noticeUpdate(String rowNum, HttpServletRequest request, HttpSession session) {
        if (session.getAttribute("user_no") == null) {
            ModelAndView login = new ModelAndView("redirect:/login");
            return login;
        } else if (!session.getAttribute("id").equals("dudu")) {
            ModelAndView notice = new ModelAndView("redirect:/notice");
            return notice;
        } else {
            ModelAndView mv = new ModelAndView("/notice/noticeWrite");
            String totalCnt = request.getParameter("totalCnt");
            System.out.println("totalCnt : " + totalCnt);
            String notice_no = Integer.toString(noticeService.noticeNo(rowNum));
            Map<String, Object> noticeDetail = noticeService.noticeDetail(notice_no);
            mv.addObject("noticeDetail", noticeDetail);
            mv.addObject("totalCnt", totalCnt);
            return mv;
        }
    }

    @GetMapping("/noticeDelete")
    public String noticeDelete(String rowNum, HttpSession session) {
        if (session.getAttribute("user_no") == null) return "redirect:/login";
        else if (!session.getAttribute("id").equals("dudu")) return "redirect:/notice";
        else {
            String notice_no = Integer.toString(noticeService.noticeNo(rowNum));
            int result = noticeService.noticeDelete(notice_no);
            System.out.println(result + " 개의 공지글이 비활성화 되었습니다.");
            return "redirect:/notice";
        }
    }
}
