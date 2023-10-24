package com.pandora.lms.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ZoomDTO {

    int ZOOM_AUTH, user_no, sbjct_no, instr_no, appl_no;
    String join_url,user_id, korn_flnm,login_id;

    String[] attendance,absence;

}
