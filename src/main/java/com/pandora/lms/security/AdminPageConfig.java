package com.pandora.lms.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.pandora.lms.service.AdminLoginService;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class AdminPageConfig {
	
	@Autowired
	private AdminLoginService adminLoginService;
	
//	@Autowired
//	protected void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
//		auth.userDetailsService(adminLoginService);
//	}
	
	
	@Autowired
	private AuthenticationSuccessHandler authenticationSuccessHandler;

   @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    	http.csrf().disable();
        http.antMatcher("/admin/**").authorizeRequests()
        	.antMatchers("/css/**","/scss/**","/vendor/**","/js/**","/img/**","/join","/resources/**").permitAll()
            .anyRequest().hasAuthority("30").and().userDetailsService(adminLoginService);

        http.formLogin()
            .loginPage("/admin/login")
            .usernameParameter("id")
            .passwordParameter("pw")
            .loginProcessingUrl("/admin/loginaction")
            // .successHandler(authenticationSuccessHandler)
            .permitAll();
            
        http
        .sessionManagement()
        .maximumSessions(1)
        .maxSessionsPreventsLogin(true)
        .sessionRegistry(adminsessionRegistry());
            
        http
            .logout()
            .logoutUrl("/admin/logout")
//            .invalidateHttpSession(true)
//            .clearAuthentication(true)
            .logoutSuccessUrl("/admin/login")
            .permitAll();
			return http.build();
            
    }
    


    @Bean
	public SessionRegistry adminsessionRegistry() {
		return new SessionRegistryImpl();
	}

}
