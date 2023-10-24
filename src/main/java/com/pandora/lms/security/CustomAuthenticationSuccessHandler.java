
package com.pandora.lms.security;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import com.pandora.lms.dto.securityinfo;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
    
	 @Override
	    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
	            Authentication authentication) throws IOException, ServletException {
		 	
		 	System.err.println(authentication);
		 	securityinfo userDetails = (securityinfo) authentication.getPrincipal();
		 	System.out.println(authentication.getPrincipal());
	        HttpSession session = request.getSession();
	        session.setAttribute("username", userDetails.getUsername());
	        session.setAttribute("user_no", userDetails.getUserno());
	        session.setAttribute("id", userDetails.getUser_id());
	        session.setAttribute("division", userDetails.getDivision());
	        session.setAttribute("name", userDetails.getUser_name());
		 	if(userDetails.getDivision().equals("20")) {session.setAttribute("instr_no", userDetails.getINSTR_NO());}
		 	if(userDetails.getDivision().equals("10")) {session.setAttribute("appl_no", userDetails.getAPPL_NO());  }
	        Enumeration<String> attributeNames = session.getAttributeNames();
	        
	        // Iterate through all attributes and print their values to the console
	        while (attributeNames.hasMoreElements()) {
		         String attributeName = attributeNames.nextElement();
		         Object attributeValue = session.getAttribute(attributeName);
		         System.out.println(attributeName + ": " + attributeValue);
	        }
	        // redirect to the home page or the page the user was trying to access before being redirected to the login page
	        SavedRequest savedRequest = (SavedRequest) session.getAttribute("SPRING_SECURITY_SAVED_REQUEST");
	        if (savedRequest != null) {
	            // Clear the saved request from the session
	            session.removeAttribute("SPRING_SECURITY_SAVED_REQUEST");
	            // Use the saved request URL to redirect the user
	            response.sendRedirect(savedRequest.getRedirectUrl());
	        } else {
	            // No saved request found, redirect to the home page
	            response.sendRedirect("/");
	        }       
	    }
    
}
