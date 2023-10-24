package com.pandora.lms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.pandora.lms.mail.MailTO;

@Service
@Component
public class EmailService {
	
	@Autowired
    private JavaMailSender mailSender; // Inject the JavaMailSender bean

    
    public void sendMail(MailTO mail) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(mail.getAddress());
//        message.setFrom(""); from 값을 설정하지 않으면 application.yml의 username값이 설정됩니다.
        message.setSubject(mail.getTitle());
        message.setText(mail.getMessage());
        System.out.println(message.getTo()[0]+message.getText()+message.getSubject());
        mailSender.send(message);
    }
}

