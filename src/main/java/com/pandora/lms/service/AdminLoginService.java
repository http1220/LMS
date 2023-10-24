package com.pandora.lms.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.pandora.lms.dao.LoginDAO;
import com.pandora.lms.dto.AdminInfoDto;
import com.pandora.lms.dto.LoginDTO;
import com.pandora.lms.dto.UserInfoDto;
import com.pandora.lms.dto.securityAdmininfo;
import com.pandora.lms.dto.securityinfo;

@Service
public class AdminLoginService implements UserDetailsService{
	
	@Autowired
    private LoginDAO loginDAO;

    
    public LoginDTO login(LoginDTO loginInfo) {
        return loginDAO.login(loginInfo);
    }

    public String instrNo(int userNo) { return loginDAO.instrNo(userNo); }

    public String applNo(int userNo) { return loginDAO.applNo(userNo); }
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    	System.out.println("메소드명 : loadUserByUsername");
        AdminInfoDto user = loginDAO.findByAdminname(username);
        	
        securityAdmininfo newone = new securityAdmininfo(user);
        
             
        return newone;
    }

	public int getAPPL(int user_NO) {
		return loginDAO.getAPPL(user_NO);
		
	}

	public int getINSTR(int user_NO) {
		
		return loginDAO.getINSTR(user_NO);
	}

	public int save(UserInfoDto userInfoDto) {
		return loginDAO.save(userInfoDto);
		
	}
}
