package com.pandora.lms.dto;

import org.springframework.stereotype.Repository;

import lombok.Data;

@Data
@Repository
public class AdminInfoDto {
	private int ADMIN_NO,USER_GROUP_CD;
	private String ADMIN_ID,PSWD,KORN_FLNM,USER_BRDT,EML_ADDR,TELNO;

}
