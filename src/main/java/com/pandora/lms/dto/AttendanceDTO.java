package com.pandora.lms.dto;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class AttendanceDTO {
	private int SBJCT_NO, CRCLM_CD, CRCLM_CYCL, APPL_NO, SBJCT_MTHD_CD, ATND_CD, attendace;
	private String CRCLM_NM, SBJCT_NM, SBJCT_EXPLN, KORN_FLNM, semester;
}
