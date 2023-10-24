package com.pandora.lms.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.pandora.lms.dto.ApplCrclmWrapperDTO;
import com.pandora.lms.dto.ApplInfoDTO;
import com.pandora.lms.dto.AttendanceDTO;
import com.pandora.lms.dto.CrclmInfoDTO;
import com.pandora.lms.dto.InstrInfoDTO;
import com.pandora.lms.dto.OnLectNmDTO;

@Repository
@Mapper
public interface AdminDAO {
	
	public List<ApplCrclmWrapperDTO> applList(ApplCrclmWrapperDTO applCrc);

	public int crcList(ApplCrclmWrapperDTO applCrc);
	
	public List<Map<String, Object>> onlectList(Map<String, String> formData);

	public List<OnLectNmDTO> insertYoutube(OnLectNmDTO onLect);

	public List<ApplInfoDTO> studentsModal(ApplInfoDTO appl);

	public List<CrclmInfoDTO> departmentModal(CrclmInfoDTO crclm);

	public List<InstrInfoDTO> instructorModal(InstrInfoDTO instr);

	public List<AttendanceDTO> attendanceList(AttendanceDTO atnd);

	public int attendaceCnt(AttendanceDTO atnd);


}
