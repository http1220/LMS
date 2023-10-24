package com.pandora.lms.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class ApplCrclmWrapperDTO {
	private int APPL_NO, CRCLM_CD, CRCLM_CYCL, USER_NO, GENDER_CD, AGE, REL_CD, REG_CD;
	private String KORN_FLNM, EML_ADDR, TELNO, ADDR, GENDER, ACADEMIC_STATUS;
	private Date USER_BRDT;
	private int CRCLM_SCHDL_CD, RPRS_INSTR_NO;
	private String CRCLM_NM, EDU_CN, EDU_FNSH_YN, department;
}
