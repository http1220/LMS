package com.pandora.lms.dto;

import java.sql.Date;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class InstrInfoDTO {
	private int INSTR_NO, USER_NO, GENDER_CD;
	private String KORN_FLNM, EML_ADDR, TELNO, ZIP, ADDR, DADDR, ZOOM_AUTH, GENDER;
	private Date USER_BRDT;
}
