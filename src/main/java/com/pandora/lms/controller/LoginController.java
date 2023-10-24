package com.pandora.lms.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class LoginController {

    //private final LoginService loginService;

    @GetMapping("/login")
    public String login(HttpSession session){
    	System.out.println("Controller - GET - login");

         return "/login/login";

    }
    
    @GetMapping("/admin/login")
    public String adminlogin(HttpSession session){
    	System.out.println("Controller - GET - login");

         return "/admin/login";

    }
    
    
    @GetMapping("/admin/page1")
    public String page1(HttpSession session){

         return "/admin/page1";

    }
    
    @GetMapping("/admin/page2")
    public String page2(HttpSession session){
    	

         return "/admin/page2";

    }
//
//    @PostMapping("/login")
//    public String login(HttpServletRequest request){
//    	System.out.println("Controller - POST - login");
//        LoginDTO loginInfo = new LoginDTO();
//        loginInfo.setUSER_ID(request.getParameter("id"));
//        loginInfo.setPSWD(request.getParameter("pw"));
//        loginInfo.setUSER_GROUP_CD(request.getParameter("division"));
//
//        //loginInfo = loginService.login(loginInfo);
//
//        if(loginInfo != null) {
//
//            HttpSession session = request.getSession();
//            session.setAttribute("user_no",loginInfo.getUSER_NO());
//            session.setAttribute("id",loginInfo.getUSER_ID());
//            session.setAttribute("division",loginInfo.getUSER_GROUP_CD());
//            session.setAttribute("name",loginInfo.getKORN_FLNM());
//            if(loginInfo.getUSER_GROUP_CD().equals("20") ){
//                int instr = Integer.parseInt(loginService.instrNo(loginInfo.getUSER_NO()));
//                System.out.println("INSTR_NO : "+instr);
//                session.setAttribute("instr_no",instr);
//            }else if(loginInfo.getUSER_GROUP_CD().equals("10")){
//                String appl = loginService.applNo(loginInfo.getUSER_NO());
//                System.out.println("APPL_NO : "+appl);
//                session.setAttribute("appl_no",appl);
//            }
//            return "redirect:/index";
//        }else{ return "redirect:/login"; }
//    }
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
