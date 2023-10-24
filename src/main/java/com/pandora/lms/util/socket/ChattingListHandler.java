package com.pandora.lms.util.socket;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ChattingListHandler extends TextWebSocketHandler {

    private final Set<WebSocketSession> sessions = ConcurrentHashMap.newKeySet();
    //session 객체를 set 컬렉션으로 관리함, 저장 모든 사용자에게 메시지 전달가능하게 함
    String list = "";
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
//        System.out.println(message.getPayload());
        if(message.getPayload().contains("님이 나가셨습니다.")){
            String msg = message.getPayload().replace("님이 나가셨습니다.","");
            list = list.replace(msg,"");
        } else { list += message.getPayload()+" "; }
        for (WebSocketSession s : sessions){
            s.sendMessage(new TextMessage(list));
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        System.out.println("Chatting List On");
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
        System.out.println("Chatting List Off");
    }

}
