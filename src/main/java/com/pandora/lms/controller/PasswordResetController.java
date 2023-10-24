package com.pandora.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.pandora.lms.dto.UserInfoDto;
import com.pandora.lms.mail.MailTO;
import com.pandora.lms.service.EmailService;
import com.pandora.lms.service.PasswordResetService;

@Controller
public class PasswordResetController {

    @Autowired
    private PasswordResetService passwordResetService;
    
    //초기 페이지 - 아이디 입력
    @GetMapping("/pwreset")
    public String page0(){

    	return "passwordpage0";
    }
    
    //입력받은 아이디로 이메일 확인
    @PostMapping("/pwreset/request")	
    public ModelAndView page1(@RequestParam String id) {
    	ModelAndView mv = new ModelAndView();
    	String email = passwordResetService.checkEamil(id);
    	System.out.println("받은 아이디 : `" + id + "`");
    	//분기 발생
    	if(email == null) {//F. 이메일이 존재하지 않음
    		mv.addObject("msg", "해당 학번은 존재하지 않습니다. 다시 입력해주세요");
    		System.out.println("이메일 없음");
    		mv.setViewName("passwordpage0");
    	} else {//T. 이메일이 존재함
    		//임시 번호를 생성하고 임시 번호를 DB에 저장함  		
    		UserInfoDto userInfoDto = new UserInfoDto();
    		userInfoDto.setUSER_ID(id);
    		userInfoDto.setEML_ADDR(email);  				
    		userInfoDto = passwordResetService.tempkeysave(userInfoDto);
    		
    		//해당 아이디에 매핑되어 있는 이메일 주소에 인증 메일을 전송
    		passwordResetService.tosendemail(userInfoDto);
    		
    		mv.addObject("attr", userInfoDto.getUSER_ID());
    		mv.setViewName("/passwordCheck");
    	}
    
    	return mv;
    }
    
    //이메일 전송 후 임시키 확인 페이지
    @PostMapping("/pwreset/checkrequest")
    public ModelAndView page2(@RequestParam int key , String userid) {
    	ModelAndView mv = new ModelAndView();
    	System.out.println("임시번호는"+key);
    	System.out.println(userid);
    	UserInfoDto userInfoDto = new UserInfoDto();
    	userInfoDto.setPSWD_ERR_NMTM(key);
    	userInfoDto.setUSER_ID(userid);
    	//입력 받은 임시번호를 DB의 저장된 번호와 비교
    	int result = passwordResetService.compareNum(userInfoDto);
    	if(result == 1) { //번호 일치
    		mv.addObject("attr", key);
    		
    		mv.setViewName("/changepw");
    	} else { //번호 미 일치
    		mv.setViewName("/passwrodresetpage");
    	}
    	
    	return mv;
    }
    
    //새로운 비밀번호를 입력 받아서 DB에 저장
    @PostMapping("/pwreset/changepw")
    public String page3(@RequestParam String pw, int userid) {
    	UserInfoDto userInfoDto = new UserInfoDto();
    	userInfoDto.setPSWD_ERR_NMTM(userid);
    	userInfoDto.setPSWD(pw);
    	passwordResetService.rewritepw(userInfoDto);
		return "redirect:/login";
    	
    }
    
}
