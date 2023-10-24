package com.pandora.lms.controller;

import com.pandora.lms.service.MessageService;
import com.pandora.lms.util.TextChangeUtil;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@AllArgsConstructor
@Controller
public class MessageController {

    private final MessageService messageService;
    private final TextChangeUtil textChangeUtil;

    @GetMapping("/messageBox")
    public ModelAndView msgBox(@RequestParam(defaultValue = "1")int pageNo, HttpSession session, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("message/messageBox");
        String user_id = (String)session.getAttribute("id");
        String searchType = request.getParameter("searchType");
        String searchValue = request.getParameter("searchValue");
        Map<String, Object> pages = new HashMap<String, Object>();

        if(user_id != null) {
            pages.put("user_id",user_id);
            if (searchType != null && searchValue != null) {
                pages.put("searchType", searchType);
                pages.put("searchValue", searchValue);
            }
            int startPage = (pageNo*10)-10;
            int totalCount = messageService.msgCount(pages);
            int lastPage = (int)Math.ceil((double)totalCount/10);
            pages.put("startPage", startPage);
            pages.put("lastPage", lastPage);
            List<Map<String, Object>> list = messageService.msgList(pages);

            for(Map<String,Object> m : list) {
                m.put("message_title", textChangeUtil.changeText((String)m.get("message_title")));
                m.put("message_content", textChangeUtil.changeText((String)m.get("message_content")));
            }
            mv.addObject("pages",pages);
            mv.addObject("list",list);
            mv.addObject("pageNo", pageNo);

            return mv;
        }else {
            ModelAndView login = new ModelAndView("/login/login");
            return login;
        }
    }
    @ResponseBody
    @PostMapping("/msgRead")
    public String msgRead(@RequestParam String msgNo){
        int result = messageService.msgRead(msgNo);
        return result+"";
    }
    @ResponseBody
    @PostMapping("/msgDel")
    public String msgDel(@RequestParam String msgNo,HttpSession session){
        if(session.getAttribute("user_no") == null) return "redirect:/login";
        else{
            int result = messageService.msgDel(msgNo);
            return result+"";
        }

    }
    @ResponseBody
    @PostMapping("/msgNew")
    public String msgNew(HttpServletRequest request){
        String user_id = request.getParameter("user_id");
        System.out.println(user_id);
        int msg = messageService.msgNew(user_id);
        System.out.println("count : "+msg);
        return msg+"";
    }
    @GetMapping("/chatting")
    public String chatting(HttpSession session){
        if(session.getAttribute("user_no") == null) return "redirect:/login";
        else { return "/message/chatting"; }
    }


}
