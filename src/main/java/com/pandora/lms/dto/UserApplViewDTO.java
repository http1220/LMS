package com.pandora.lms.dto;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class UserApplViewDTO {
	private int USER_NO, APPL_NO, ATNDDY_CNT, ABSTDY_CNT, LATE_CNT, SBJCT_NO, CRCLM_CD, CRCLM_CYCL;
	private String USER_FLNM, CRCLM_NM, SBJCT_NM, ESNTL_YN, KORN_FLNM, ACADEMIC_STATUS;
}
