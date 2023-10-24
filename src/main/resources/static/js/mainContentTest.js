$(document).ready( function() {
	$(".search_btn").click(
		function(e) {
			e.preventDefault();
			$.ajax({
				url : "/search",
				type : "POST",
				dataType : "json",
				data : $("#search-form").serialize(),
				success : function(data) {
					$('#tableBody').empty();
					$('#cnt').empty();
					var result = data;
					var str = "";
					$.each(result, function(i, info) {
						str += '<tr><td>' + info.procedure
								+ '</td><td>' + info.admission
								+ '</td><td>' + info.student_no
								+ '</td><td>' + info.name
								+ '</td><td>' + info.birth
								+ '</td><td>' + info.gender
								+ '</td><td>' + info.department
								+ '</td><td>' + info.day_and_night
								+ '</td><td>' + info.grade
								+ '</td><td>' + info.division
								+ '</td><td>' + info.academic_status
								+ '</td><td>' + info.date_of_admission
								+ '</td></tr>';
					});
					$('#tableBody').append(str);
					$('#cnt').append(result.length);
				}
			});
		});
	});
$(document).ready( function() {
	$(".search_btn2").click(
		function(e) {
			e.preventDefault();
			$.ajax({
				url : "/search2",
				type : "POST",
				dataType : "json",
				data : $("#search-form2").serialize(),
				success : function(data) {
					$('#tableBody2').empty();
					$('#cnt2').empty();
					var result2 = data;
					var str2 = "";
					$.each(result2, function(i, info) {
						str2 += '<tr><td>' + info.procedure
								+ '</td><td>' + info.admission
								+ '</td><td>' + info.student_no
								+ '</td><td>' + info.name
								+ '</td><td>' + info.birth
								+ '</td><td>' + info.gender
								+ '</td><td>' + info.department
								+ '</td><td>' + info.day_and_night
								+ '</td><td>' + info.grade
								+ '</td><td>' + info.division
								+ '</td><td>' + info.academic_status
								+ '</td><td>' + info.date_of_admission
								+ '</td></tr>';
					});
					$('#tableBody2').append(str2);
					$('#cnt2').append(result2.length);
				}
			});
		});
	});
