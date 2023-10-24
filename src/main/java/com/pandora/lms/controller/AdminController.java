package com.pandora.lms.controller;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.pandora.lms.dto.ApplCrclmWrapperDTO;
import com.pandora.lms.dto.ApplInfoDTO;
import com.pandora.lms.dto.AttendanceDTO;
import com.pandora.lms.dto.CrclmInfoDTO;
import com.pandora.lms.dto.InstrInfoDTO;
import com.pandora.lms.dto.OnLectNmDTO;
import com.pandora.lms.service.AdminService;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@GetMapping("/admin")
	public String admin(HttpSession session,
						Model model) {
		model.addAttribute("id", session.getAttribute("id"));
		model.addAttribute("name", session.getAttribute("name"));
		return "admin/admin";
	}
	
	@GetMapping("/admin/studentList")
	public String studentList() {
	    return "admin/studentList";
	}
	
	@ResponseBody
	@PostMapping("/search/studentList")
	public List<ApplCrclmWrapperDTO> studentList(@RequestParam("name") String name
							, @RequestParam("academic_status") String academic_status
							, @RequestParam("department") String CRCLM_NM
			) {
		
		ApplCrclmWrapperDTO applCrc = new ApplCrclmWrapperDTO();
		
		applCrc.setCRCLM_NM(CRCLM_NM);
		int crcCD;
		if (CRCLM_NM != "") {
			crcCD = adminService.crcList(applCrc);
			applCrc.setCRCLM_CD(crcCD);
		}
		applCrc.setKORN_FLNM(name);
		applCrc.setACADEMIC_STATUS(academic_status);
		applCrc.setCRCLM_NM(CRCLM_NM);
		
		
		List<ApplCrclmWrapperDTO> studentList = adminService.applList(applCrc);
		
		for (ApplCrclmWrapperDTO applCrcInfo : studentList) {
			int gender = applCrcInfo.getGENDER_CD();
			if (gender == 1) {
				applCrcInfo.setGENDER("남자");
			}else {
				applCrcInfo.setGENDER("여자");
			}
			LocalDate current_date = LocalDate.now();
			int current_Year = current_date.getYear();
			int birth = Integer.parseInt(applCrcInfo.getUSER_BRDT().toString().substring(0, 4));
			int age = current_Year - birth;
			applCrcInfo.setAGE(age);
			
		}
		
		return studentList;
	}

	@ResponseBody
	@PostMapping("/search/onlect")
	public List<Map<String, Object>> onlect(@RequestParam Map<String,String> formData){
		System.out.println(formData.toString());
		List<Map<String, Object>> rsl = adminService.onlectList(formData);
		for (Map<String, Object> map : rsl) {
			System.out.println(map.toString());
		}
		return rsl;
	}
	
	@GetMapping("/admin/insertYoutube")
	public String insertYoutube() {
		return "admin/insertYoutube";
	}
	
	@ResponseBody
	@PostMapping("/insertYoutube/save")
	public List<OnLectNmDTO> insertYoutube(@RequestParam("ON_LECT_URL") String ON_LECT_URL
											, @RequestParam("file_upload") MultipartFile fileUpload
											){
		
		OnLectNmDTO onLect = new OnLectNmDTO();
		onLect.setON_LECT_URL(ON_LECT_URL);
//		onLect.set
		
		List<OnLectNmDTO> insertYoutube = adminService.insertYoutube(onLect);
		
		return insertYoutube;
	}
	
	@GetMapping("/admin/attendance")
	public String attendance() {
		return "admin/attendance";
	}
	
	@ResponseBody
	@PostMapping("/search/attendance")
	public List<AttendanceDTO> attendance(@RequestParam("years") String years
										, @RequestParam("semester") String semester
										, @RequestParam("studentNumber") String studentNumber
										, @RequestParam("department") String CRCLM_NM){
		AttendanceDTO atnd = new AttendanceDTO();
		
		int attendace = adminService.attendaceCnt(atnd);
		System.out.println(attendace + "추울");
		atnd.setAttendace(attendace);
		
//		System.out.println(years + "1");
		System.out.println(semester);
//		System.out.println(studentNumber);
		System.out.println(CRCLM_NM + "2");
		if (semester == "01") {
			atnd.setCRCLM_CYCL(202301);
		}else if(semester == "02") {
			atnd.setCRCLM_CYCL(202302);
		}
//		int LECT_YMD = Integer.parseInt(years);
		int APPL_NO = Integer.parseInt(studentNumber);
//		atnd.setLECT_YMD(LECT_YMD);
		atnd.setAPPL_NO(APPL_NO);
		atnd.setCRCLM_NM(CRCLM_NM);
		
		
		List<AttendanceDTO> attendanceList = adminService.attendanceList(atnd);
		for (AttendanceDTO attendanceDTO : attendanceList) {
			System.out.println(attendanceDTO.getAttendace() + "출석");
			int semesters = attendanceDTO.getCRCLM_CYCL();
			System.out.println(semesters + "semesters");
			if (semesters == 202301) {
				attendanceDTO.setSemester("1학기");
			} else if(semesters == 202302) {
				attendanceDTO.setSemester("2학기");
			}
		}
		
		return attendanceList;
	}
	
	@GetMapping("/admin/modal/departmentModal")
	public String departmentModal() {
		return "admin/modal/departmentModal";
	}
	
	@ResponseBody
	@PostMapping("/search/departmentModal")
	public List<CrclmInfoDTO> departmentModal(@RequestParam("department") String department
			) {
		CrclmInfoDTO crclm = new CrclmInfoDTO();
		System.out.println("ddddd");
		crclm.setCRCLM_NM(department);
		
		List<CrclmInfoDTO> departmentModal = adminService.departmentModal(crclm);
		
		for (CrclmInfoDTO crclmInfo : departmentModal) {
		    int crclmCd = crclmInfo.getCRCLM_CD();
		    int thirdDigit = (crclmCd / 1000) % 10;
		    if (thirdDigit == 0) {
		        crclmInfo.setDepartment("학부");
		    } else {
		        crclmInfo.setDepartment("학과");
		    }
		}
		return departmentModal;
	}
	
	@GetMapping("/admin/modal/studentsModal")
	public String studentsModal() {
		return "admin/modal/studentsModal";
	}
	
	@ResponseBody
	@PostMapping("/search/studentsModal")
	public List<ApplInfoDTO> studentsModal(@RequestParam("name") String name
			) {
		ApplInfoDTO appl = new ApplInfoDTO();
		
		appl.setKORN_FLNM(name);
		
		List<ApplInfoDTO> studentsModal = adminService.studentsModal(appl);
		
		for (ApplInfoDTO applInfo : studentsModal) {
			int gender = applInfo.getGENDER_CD();
			if (gender == 1) {
				applInfo.setGENDER("남자");
			}else {
				applInfo.setGENDER("여자");
			}
		}
		return studentsModal;
	}
	
	@GetMapping("/admin/modal//instructorModal")
	public String instructorModal() {
		return "admin/modal/instructorModal";
	}
	
	@ResponseBody
	@PostMapping("/search/instructorModal")
	public List<InstrInfoDTO> instructorModal(@RequestParam("name") String name){
		
		InstrInfoDTO instr = new InstrInfoDTO();
		
		instr.setKORN_FLNM(name);
		
		List<InstrInfoDTO> instructorModal = adminService.instructorModal(instr);
		
		for (InstrInfoDTO instrInfo : instructorModal) {
			int gender = instrInfo.getGENDER_CD();
			if (gender == 10) {
				instrInfo.setGENDER("남자");
			}else {
				instrInfo.setGENDER("여자");
			}
		}
		System.out.println(instructorModal + "ㅇㅇ");
		return instructorModal;
	}
	
	@GetMapping("/admin/modal/userInfoModal")
	public String userInfoModal() {
		return "admin/modal/userInfoModal";
	}
}


