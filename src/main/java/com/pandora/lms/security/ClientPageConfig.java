package com.pandora.lms.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.session.HttpSessionEventPublisher;

import com.pandora.lms.service.LoginService;

import lombok.RequiredArgsConstructor;

@EnableWebSecurity
@RequiredArgsConstructor
@Order(Ordered.HIGHEST_PRECEDENCE)
public class ClientPageConfig {

	@Autowired
	private AuthenticationSuccessHandler authenticationSuccessHandler;

	@Autowired
	private LoginService LoginService;


	@Bean
    public SecurityFilterChain mainfilterChain(HttpSecurity http) throws Exception {
    	
    	http.csrf().disable();
    	http.httpBasic().disable();
        http.requestMatchers().antMatchers("/**").and().authorizeRequests()
        	.antMatchers("/css/**","/scss/**","/vendor/**","/js/**","/img/**","/join","/resources/**" , "/pwreset/**").permitAll()
            .anyRequest().authenticated().and().userDetailsService(LoginService);

        http.formLogin()
            .loginPage("/login")
            .usernameParameter("id")
            .passwordParameter("pw")
            .loginProcessingUrl("/login")
            .failureUrl("/loginfail")
            .successHandler(authenticationSuccessHandler)
            .permitAll();

        
            http
            .sessionManagement()
            .maximumSessions(1)
            .maxSessionsPreventsLogin(true)
            .sessionRegistry(sessionRegistry());
            
            
            http
            .logout()
            .logoutSuccessUrl("/login")
//            .invalidateHttpSession(true)
//            .clearAuthentication(true)
            .permitAll();
            
			return http.build();
            
    }
	
	@Bean
	public SessionRegistry sessionRegistry() {
		return new SessionRegistryImpl();
	}
	 @Bean
	    public PasswordEncoder passwordEncoder() {
	        return new BCryptPasswordEncoder();
	    }

		
		@Bean
		public static ServletListenerRegistrationBean httpSessionEventPulisher() {
			return new ServletListenerRegistrationBean(new HttpSessionEventPublisher());
		}
		

	
}
