package com.pandora.lms.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pandora.lms.dao.AdminDAO;
import com.pandora.lms.dto.ApplCrclmWrapperDTO;
import com.pandora.lms.dto.ApplInfoDTO;
import com.pandora.lms.dto.AttendanceDTO;
import com.pandora.lms.dto.CrclmInfoDTO;
import com.pandora.lms.dto.InstrInfoDTO;
import com.pandora.lms.dto.OnLectNmDTO;

@Service
public class AdminService {
	
	@Autowired
	AdminDAO adminDAO;

	public List<ApplCrclmWrapperDTO> applList(ApplCrclmWrapperDTO applCrc) {
		return adminDAO.applList(applCrc);
	}

	public List<Map<String, Object>> onlectList(Map<String, String> formData) {
		return adminDAO.onlectList(formData);
	}

	public List<OnLectNmDTO> insertYoutube(OnLectNmDTO onLect) {
		return adminDAO.insertYoutube(onLect);
	}

	public List<ApplInfoDTO> studentsModal(ApplInfoDTO appl) {
		return adminDAO.studentsModal(appl);
	}

	public List<CrclmInfoDTO> departmentModal(CrclmInfoDTO crclm) {
		return adminDAO.departmentModal(crclm);
	}

	public List<InstrInfoDTO> instructorModal(InstrInfoDTO instr) {
		return adminDAO.instructorModal(instr);
	}

	public int crcList(ApplCrclmWrapperDTO applCrc) {
		return adminDAO.crcList(applCrc);
	}

	public List<AttendanceDTO> attendanceList(AttendanceDTO atnd) {
		return adminDAO.attendanceList(atnd);
	}

	public int attendaceCnt(AttendanceDTO atnd) {
		return adminDAO.attendaceCnt(atnd);
	}

}
