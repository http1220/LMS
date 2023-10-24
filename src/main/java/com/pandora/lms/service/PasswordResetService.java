package com.pandora.lms.service;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.pandora.lms.dao.LoginDAO;
import com.pandora.lms.dto.UserInfoDto;
import com.pandora.lms.mail.MailTO;

@Service
public class PasswordResetService {
	
	@Autowired
	private LoginDAO loginDao;
	
    @Autowired
    private EmailService emailService;
    
    //아이디(학번)를 DB에 전달하고 결과값을 받아옴 (이메일 주소를 받아옴)
	public String checkEamil(String id) {

		return loginDao.checkEamil(id);
	}
	//이메일 보내는 메소드
	public void tosendemail(UserInfoDto userInfoDto) {
		MailTO mailTO = new MailTO();

		 mailTO.setAddress("http1220@naver.com");
		 //mailTO.setAddress(userInfoDto.getEML_ADDR());
	     mailTO.setTitle("Pandora 임시 번호 이메일입니다.");
	     mailTO.setMessage("임시번호 : " + userInfoDto.getPSWD_ERR_NMTM());

		emailService.sendMail(mailTO);
		
	}
	//임시 번호를 생성함
	public int tempkey() {
		int min = 10000000; // Minimum 8-digit number
        int max = 99999999; // Maximum 8-digit number
        Random random = new Random();
        int randomNumber = random.nextInt(max - min + 1) + min;
        System.out.println("Random 8-digit number: " + randomNumber);
		return randomNumber;
	}
	
	//임시 번호를 DB에 저장함
	public UserInfoDto tempkeysave(UserInfoDto userInfoDto) {
		userInfoDto.setPSWD_ERR_NMTM(this.tempkey());
		loginDao.tempkeysave(userInfoDto);

		return userInfoDto;
	}
	
	//입력받은 임시번호를 DB와 확인
	public int compareNum(UserInfoDto userInfoDto) {
		return loginDao.compareNum(userInfoDto);
		
	}
	
	//입력 받은 새로운 비밀번호를 DB에 저장
	public int rewritepw(UserInfoDto userInfoDto) {
    	BCryptPasswordEncoder pwenc = new BCryptPasswordEncoder();
    	String enpw = pwenc.encode(userInfoDto.getPSWD());
    	userInfoDto.setPSWD(enpw);
		return loginDao.rewritepw(userInfoDto);
		
	}
	

	
}
