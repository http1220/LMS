package com.pandora.lms.dto;

import java.math.BigDecimal;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class OnLectNmDTO {
	
	private String LECT_YMD, SBJCT_NO, CRCLM_CD, CRCLM_CYCL, ON_LECT_NM, ON_LECT_CN, ON_LECT_URL;
	
	private BigDecimal ON_LECT_SN, ON_LECT_TM, THUMB_FILE_SN, LECT_FILE_SN;
	
}
