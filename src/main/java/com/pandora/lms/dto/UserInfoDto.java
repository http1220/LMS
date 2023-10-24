package com.pandora.lms.dto;

import org.springframework.stereotype.Repository;

import lombok.Data;

@Data
@Repository
public class UserInfoDto {
	private int USER_NO,PSWD_ERR_NMTM,USER_GROUP_CD;
	private String USER_ID,PSWD,KORN_FLNM,USER_BRDT,EML_ADDR,TELNO,PSWD_CHG_YN,PSWD_CHG_DT;

}
