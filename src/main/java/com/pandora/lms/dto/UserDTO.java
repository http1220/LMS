package com.pandora.lms.dto;

import lombok.Data;

@Data
public class UserDTO {
	
	private int USER_NO;
    private String USER_ID;
    private String PSWD;
    private String KORN_FLNM;
    private String USER_BRDT;
    private String EML_ADDR;
    private String TELNO;
    private String USER_GROUP_CD;
    private String PSWD_CHG_YN;
    private String PSWD_CHG_DT;
    private String PSWD_ERR_NMTM;

}
