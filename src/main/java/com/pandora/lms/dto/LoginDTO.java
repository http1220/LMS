package com.pandora.lms.dto;

import lombok.Data;

@Data
public class LoginDTO {
    private int USER_NO;
    private String USER_ID, PSWD, KORN_FLNM,EML_ADDR,USER_GROUP_CD;
}
