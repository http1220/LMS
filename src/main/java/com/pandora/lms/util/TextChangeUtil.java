package com.pandora.lms.util;

import org.springframework.stereotype.Component;

@Component
public class TextChangeUtil {

	public String changeText(String txt) {
		if (txt != null) {
			txt = txt.replaceAll("<", "&lt;");
			txt = txt.replaceAll(">", "&gt;");
		}
		return txt;
	}

	public String changeEnter(String txt) {
		if (txt != null) {
			txt = txt.replaceAll("\n", "<br>");
		}
		return txt;
	}
}
