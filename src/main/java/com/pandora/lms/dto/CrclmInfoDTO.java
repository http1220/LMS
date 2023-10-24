package com.pandora.lms.dto;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class CrclmInfoDTO {
	private int CRCLM_CD, CRCLM_CYCL, CRCLM_SCHDL_CD, RPRS_INSTR_NO;
	private String CRCLM_NM, EDU_CN, EDU_FNSH_YN, department;
}
