package com.pandora.lms.dto;

import java.sql.Date;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class ApplInfoDTO {
	private int APPL_NO, CRCLM_CD, CRCLM_CYCL, USER_NO, GENDER_CD, AGE, REL_CD, REG_CD;
	private String KORN_FLNM, EML_ADDR, TELNO, ADDR, GENDER, ACADEMIC_STATUS, department;
	private Date USER_BRDT;
}
