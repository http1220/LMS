package com.pandora.lms.dto;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class SearchDTO {
	private String name, academic_status, department;
}
