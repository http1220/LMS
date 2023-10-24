package com.pandora.lms.util.socket;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket    // 웹소켓 생성
public class WebSocketConfig implements WebSocketConfigurer {
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler( new ChattingHandler(), "/user");   //Chatting

        registry.addHandler( new ChattingListHandler(), "/list");   //Chatting List

        registry.addHandler(AlarmHandler(), "/noticeAlarm");    //Alarm
        //.setAllowedOrigins("*")      //cors 설정   cors 허용시켜줌
        //.withSockJS();                      //sockJS도 사용가능하게 함
    }

    @Bean
    public AlarmHandler AlarmHandler() { return new AlarmHandler(); }

}
