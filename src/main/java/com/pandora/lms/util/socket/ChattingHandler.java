package com.pandora.lms.util.socket;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ChattingHandler extends TextWebSocketHandler {

    private final Set<WebSocketSession> sessions = ConcurrentHashMap.newKeySet();
    //session 객체를 set 컬렉션으로 관리함, 저장 모든 사용자에게 메시지 전달가능하게 함

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        System.out.println(message.getPayload());
        String msg = message.getPayload();
        System.err.println(msg);
        JSONObject obj = jsonToObjectParser(msg);
        //예외처리가 발생할 수 있을 경우 웹소켓이 닫힘
        // System.err.println(perser.toString());
        for (WebSocketSession s : sessions){
            try{
                s.sendMessage(new TextMessage(obj.toJSONString()));
            } catch(Exception e){
                e.printStackTrace();
            }
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        System.out.println("Chtting On");
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
        System.out.println("Chtting Off");
    }

    private static JSONObject jsonToObjectParser(String json) { 
		JSONParser parser = new JSONParser();
		JSONObject obj = null;
		try {
			obj = (JSONObject) parser.parse(json);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return obj;
	}


}
