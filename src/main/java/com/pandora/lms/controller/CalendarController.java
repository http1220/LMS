package com.pandora.lms.controller;

import com.pandora.lms.dto.CalendarDTO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class CalendarController {

    @ResponseBody
    @PostMapping("/save_event")
    public String save_event(HttpServletRequest request, HttpSession session){
        CalendarDTO calendarDTO = new CalendarDTO();
        System.out.println(request.getParameter("start"));
        System.out.println(request.getParameter("end"));
        calendarDTO.setTitle(request.getParameter("title"));
        calendarDTO.setStart_date(request.getParameter("start"));
        calendarDTO.setEnd_date(request.getParameter("end"));
        calendarDTO.setUser_no((int)session.getAttribute("user_no"));


        System.err.println("일정 제목 : "+calendarDTO.getTitle());
        System.err.println("일정 시작일 : "+calendarDTO.getStart_date());
        System.err.println("일정 종료일 : "+calendarDTO.getEnd_date());
        System.err.println("유저 넘버 : "+calendarDTO.getUser_no());
        return "";
    }


}
