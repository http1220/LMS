<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% Integer sbjct_no = Integer.parseInt(request.getParameter("sbjct_no")); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Pandora University - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <%-- ISO 8601 변환 시 사용하기 위한 라이브러리 --%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">
    <link href="css/logo.css" rel="stylesheet">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
</head>
<script>
	/* 오늘 날짜를 대신합니다. */
// 	let today = ${week };
	let today = 4;
	
    $(function() {
        $(".btn-atnd").click(function (){
            let sbjct_no = "<%=sbjct_no%>";
            window.open('/lectureATND?sbjct_no=' + sbjct_no, '출결관리', 'width=820, height=720');
        });

        $(".week-select").click(function() {
            let appl_no = "${sessionScope.appl_no}";
            let end_cls_cd = $(this).children(".fas").attr("value");

            if(appl_no != "") {
                if(today < end_cls_cd) {
                    alert("진행할 수 없는 주차입니다.");
                    return false;
                }
            }

            $(this).children(".fas").toggleClass("fa-chevron-down fa-chevron-up");
        });

        $(".week-title").click(function() {
                let lectureInfo = $(this).find(".mthd").val();
                let snOrUrl = lectureInfo.split(",")[0];
                let mthd = lectureInfo.split(",")[1];

                if(mthd == 1) {
                    if(snOrUrl != "") {
                        location.href = "/lectureDetail?on_lect_sn=" + snOrUrl;
                    } else {
                        alert("유효하지 않은 주소입니다.\n잠시 후 다시 시도해주세요.");
                    }
                } else {
                    let sbjct_no = "${sbjct_no}";
                    let appl = "${sessionScope.appl_no}";
                    let instr = "${sessionScope.instr_no}";

                    if(appl != "") {
                        if(snOrUrl != "") {
                            window.open(snOrUrl, "줌", "menubar=no, toolbar=no, fullscreen=yes");
                        } else {
                            alert("회의가 개설되지 않았습니다.");
                        }
                    } else if (instr != "") {
                        // 강사의 줌 회의 개설
                            $(function() {
                                $.ajax({
                                    url: '/zoom_open',
                                    type: 'post',
                                    data: { "sbjct_no" : sbjct_no },
                                    dataType: 'text',
                                    success : function(result) {
                                        if(result != ""){
                                            alert("인증에 성공했습니다.");
                                            window.open("https://zoom.us/oauth/authorize?client_id=Kpvu8qjDSZCEnEtzZ58KnA&response_type=code&redirect_uri=http://localhost/zoom/token?sbjct_no=" + result, "Zoom", "width=820, height=720, menubar=no");
                                        }else{
                                            alert("인증실패 관리자 문의 바람.");
                                            return false;
                                        }
                                    },
                                    error : function(xhr) {
                                        alert(xhr);
                                        alert("요청 실패 재시도 바람.");
                                    }
                                });
                            });
                    }
                }
        });

        $(".week-file").click(function() {
            let file = $(this).find(".file").val();
            let downloadTab = window.open("/fileDownload/" + file, "_blank");
            setTimeout(function() {
                downloadTab.close();
            }, 1000);
        });

        $(".week-assign").click(function() {
            alert("과제를 제출했습니다.");
        });

        $(".week-upload").click(function() {
            let sbjct_mthd = $(this).find("#sbjct_mthd").val();
            $("#sbjct_mthd_cd").val(sbjct_mthd);
            let lect_ymd_org = $(this).find("#lect_ymd_org").val();
            $("#lect_ymd").val(lect_ymd_org);

            let on_lect_sn = $(this).find(".upload").val();
            $("#on_lect_sn").val(on_lect_sn);
            $(".modal-title").html(on_lect_sn + "주차 추가");
            $(".upload-modal").modal("show");
        });

        $("#upload-select").change(function() {
            let upload_select = $("#upload-select").val();

            if(upload_select == "assign") {
                $(".upload-title").html("과제명");
                $(".upload-title-td").html("<input class='form-control' name='title' type='text'>");
                $(".upload-content").html("과제");
                $(".upload-content-td").html("<input class='form-control' name='content' type='text'>");
            } else if(upload_select == "file") {
                $(".upload-title").html("파일명");
                $(".upload-title-td").html("<input class='form-control' name='title' type='text'>");
                $(".upload-content").html("파일");
                $(".upload-content-td").html("<input class='form-control' name='file' type='file'>");
            }
        });

        $(".modal-submit").click(function() {
            let frm_modal = $("#frm-modal")[0];
            let frmData = new FormData(frm_modal);

            $.ajax({
                type: "post",
                url: "/modalUpload",
                data: frmData,
                contentType : false,
                processData : false,
                success: function(result) {
                    if(result == "empty_file") {
                        alert("선택된 파일이 없습니다.");
                    } else if(result == "success") {
                        alert("등록 완료.");
                        location.reload();
                    } else if(result == "error") {
                        alert("파일 등록중 문제가 발생했습니다.\n잠시후 다시 시도해주세요.");
                    }
                },
                error: function () {
                    alert("파일 등록중 문제가 발생했습니다.\n잠시후 다시 시도해주세요.");
                }
            });
        });

        $(".notice-tr").click(function() {
            let notice_no = $(this).attr("value");

            //id notice_title
            //class notice-table
            $.ajax({
                url: "/lectureNoticeDetail",
                data: { "notice_no" : notice_no },
                dataType: "json",
                success: function(notice) {
                    console.log(notice);
                    $("#notice_title").html(notice.notice_title);
                    $(".notice-tr1").html("");
                    $(".notice-tr1").append("<td class='notice-admin'>");
                    $(".notice-tr1").append("<td class='notice-date'>");
                    $(".notice-admin").html(notice.admin_id);
                    $(".notice-date").html(notice.notice_date);
                    $(".notice-content").html(notice.notice_content);
                    $(".notice-modify").html("수정");
                    $(".notice-save").html("확인");
                    $(".notice-modal").modal("show");
                },
                error: function() {
                    alert("공지사항을 불러오지 못했습니다.");
                }
            });
        });

        $(".btn-notice").click(function() {
            $("#notice_title").html("공지사항 작성");
            $(".notice-tr1").html("<td colspan='2'><input class='form-control' type='text' id='n_title' name='n_title' style='width: 100%; height: 100%;' placeholder='제목을 입력하세요.'></td>");
            $(".notice-content").html("<input class='form-control' type='text' id='n_content' name='n_content' style='width: 100%; height: 100%;' placeholder='내용을 입력하세요.'>");
            $(".notice-modify").html("취소");
            $(".notice-btn").html("저장");
            $(".notice-modal").modal("show");
        });

        $(".notice-save").click(function() {
            let n_title = $("#n_title").val();
            let n_content = $("#n_content").val();
            let category = "<%=sbjct_no + 1%>";

            if(n_title != undefined) {
                $.ajax({
                    type: "POST",
                    url: "/lectureNoticeWrite",
                    data: { "instr_no": "${sessionScope.instr_no}", "notice_title" : n_title, "notice_content" : n_content, "category" : category },
                    success: function (result) {
                        if(result == "success") {
                            alert("공지사항을 등록했습니다.");
                            location.reload();
                        } else {
                            alert("공지사항을 등록하지 못했습니다.");
                        }
                    },
                    error: function () {
                        alert("저장하지 못했습니다.");
                    }
                });
            }

            $(".notice-modal").modal("hide");
        });


    });
</script>
<style>
    .week-select {
        width: 100%;
        height: 50px;
        line-height: 50px;
        padding-left: 10px;
        box-sizing: border-box;
        border-top: 1px solid #ccc;
        border-left: 1px solid #ccc;
        border-right: 1px solid #ccc;
    }

    .select-last {
        border-bottom: 1px solid #ccc;
    }

    .week-content {
        width: 100%;
        height: auto;
        border-top: 1px solid #ccc;
        border-left: 1px solid #ccc;
        border-right: 1px solid #ccc;
        padding: 10px;
        padding-top: 17px;
        box-sizing: border-box;
        transition: 0s;
    }

    .week-file {
        width: 100%;
        height: auto;
        border-top: 1px solid #ccc;
        border-left: 1px solid #ccc;
        border-right: 1px solid #ccc;
        padding: 10px;
        padding-top: 17px;
        box-sizing: border-box;
        transition: 0s;
    }

    .week-assign {
        width: 100%;
        height: auto;
        border-top: 1px solid #ccc;
        border-left: 1px solid #ccc;
        border-right: 1px solid #ccc;
        padding: 10px;
        padding-top: 17px;
        box-sizing: border-box;
        transition: 0s;
    }

    .week-upload {
        width: 100%;
        height: auto;
        border-top: 1px solid #ccc;
        border-left: 1px solid #ccc;
        border-right: 1px solid #ccc;
        padding: 10px;
        padding-top: 17px;
        box-sizing: border-box;
        transition: 0s;
    }

    .content-last {
        border-top: 0;
        border-bottom: 1px solid #ccc;
    }

    .week-object {
        width: 100%;
        height: 40px;
    }

    .btn {
        width: 75px;
        height: 30px;
        line-height: 17px;
        margin-right: 10px;
    }

    .assign-tr {
        line-height: 40px;
        text-align: center;
    }
    
	.pointer_default{
	cursor: default;
	}

	.pointer{
	cursor: pointer;
	}

</style>
<body id="page-top">
<!-- Page Wrapper -->
<div id="wrapper">

    <%-- 네비게이션 바 --%>
    <%@include file="../navbar.jsp" %>

    <!-- 콘텐츠 전체 감싸기 -->
    <div id="content-wrapper" class="d-flex flex-column">
        <!-- 메인 컨텐츠 -->
        <div id="content">
            <%-- 탑 바 --%>
            <%@include file="../top.jsp" %>

            <!-- 본문 컨텐츠 부분 시작 -->
            <div class="container-fluid">

                <!-- 메인 페이지의 탑 -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800"></h1>
                </div>

                <div class="row">
                    <!-- A카드 게시판 -->
                    <div class="col-xl-12 col-lg-7">
                        <div class="card shadow mb-4">
                            <!-- 강의 본문 부분 -->
                            <div class="card-body border-left-primary">
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <div style="width: 80%; height: 40px; float: left;" class="pointer_default">${lectList[0].SBJCT_NM} 공지사항</div>
                                    <div style="width: 20%; height: 40px; float: left; margin-bottom: 5px;">
                                        <c:if test="${sessionScope.instr_no != null}"><button class="btn btn-primary btn-notice" style="float: right;">글작성</button></c:if>
                                    </div>
                                </div>
                                <div class="text-md font-weight-bold text-primary text-uppercase mb-1">
                                    <table class="table">
                                        <thead>
                                        <tr class="pointer_default">
                                            <td class="col-1">번호</td>
                                            <td class="col-4">제목</td>
                                            <td class="col-2">작성자</td>
                                            <td class="col-2">조회수</td>
                                            <td class="col-2">등록일</td>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when test="${!empty notice}">
                                                <c:forEach items="${notice}" var="notice">
                                                <tr class="notice-tr pointer" value="${notice.notice_no}">
                                                    <td>${notice.notice_no }</td>
                                                    <td class="title text-truncate" style="max-width:1px; text-align: left;">${notice.notice_title }</td>
                                                    <td>${notice.admin_id }</td>
                                                    <td>${notice.notice_read }</td>
                                                    <td>${notice.notice_date }</td>
                                                </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="5" class="pointer_default">등록된 공지사항이 없습니다.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>

                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- A카드 게시판 -->
                    <div class="col-xl-12 col-lg-7">
                        <div class="card shadow mb-4">
                            <!-- A 카드 설정 버튼 부분 -->
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary pointer_default">강의</h6>
                                <c:if test="${sessionScope.instr_no ne null}"><button class="btn btn-primary btn-atnd" style="width: 100px;">출결확인</button></c:if>
                            </div>
                            <!-- 강의 본문 부분 -->
                            <div class="card-body">
                                <div>
                                    <!-- 강의 정보 추가 위치 -->
                                    <c:set var="i" value="1"/>
                                        <c:forEach items="${lectList}" var="lect" varStatus="status">
                                        <div class="week-select ${status.last ? 'select-last' : ''} pointer" data-toggle="collapse" data-target=".week-content${i}">
                                            <i class="fas fa-chevron-down" value="${lect.END_CLS_CD}"></i> ${i }주차
<!-- value 조건만 바꾸면댐 -->
<%-- <c:set var="week" value="${week }"/> --%>
<c:set var="week" value="4"/>
                                            
                                            <!-- 완료 미완료 버튼 -->
                                            <div style="float:right; margin-right:20px">
                                                <c:choose>
                                                    <c:when test="${sessionScope.appl_no ne null}">
                                                    	<c:choose>
                                                    	<c:when test="${week >= lect.END_CLS_CD}">
	                                                        <c:choose>
	                                                            <c:when test="${90 lt lect.LECT_PRGRS_RT || lect.ATTENDANCE eq '1'}">
	                                                                <button style="width:108px;" class="btn btn-outline-primary">과제제출</button>
	                                                            </c:when>
	                                                            <c:otherwise>
	                                                                <button style="width:108px;" class="btn btn-outline-danger">과제미제출</button>
	                                                            </c:otherwise>
	                                                        </c:choose>
                                                    	</c:when>
                                                    	</c:choose>
                                                        
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            <div style="float:right; margin-right:10px">
                                                <c:if test="${sessionScope.appl_no ne null}">
                                                	<c:choose>
                                                    <c:when test="${week gt lect.END_CLS_CD}">
		                                            	<c:choose>
															<c:when test="${90 le lect.LECT_PRGRS_RT || lect.ATTENDANCE eq '1'}">
																<button style="width:90px;" class="btn btn-outline-success" disabled>수강완료</button>
															</c:when>
															<c:otherwise>
																<button style="width:90px;" class="btn btn-outline-danger">미수강</button>
															</c:otherwise>
														</c:choose>
													</c:when>
													
													<c:when test="${week eq lect.END_CLS_CD}">
		                                            	<c:choose>
															<c:when test="${90 le lect.LECT_PRGRS_RT || lect.ATTENDANCE eq '1'}">
																<button style="width:90px;" class="btn btn-outline-primary" disabled>수강완료</button>
															</c:when>
															<c:otherwise>
																<button style="width:90px;" class="btn btn-outline-success">수강중</button>
															</c:otherwise>
														</c:choose>
													</c:when>
													
													
													<c:otherwise>
													</c:otherwise>
													
													
													</c:choose>
                                                </c:if>
                                            </div>
                                        </div>
<!-- 강의 -->
<%-- <c:set var="week" value="${week }"/> --%>
<c:set var="week" value="4"/>
	                                    <!-- 지난주차들 -->
	                                    <c:if test="${i le week || sessionScope.instr_no ne null}">
	                                        <div class="week-content week-content${i} ${status.last ? 'content-last' : ''} 
	                                        <c:choose>
	                                        <c:when test="${lect.SBJCT_MTHD_CD eq 1}">border-left-danger
	                                        </c:when>
	                                        <c:otherwise>border-left-primary
	                                        </c:otherwise>
	                                        </c:choose> collapse">
	                                            <!-- 숨길 객체의 내용 -->
	                                            <div class="week-object">
	                                                <div class="week-title" style="height: 30px; padding-top: 2px; box-sizing: border-box; float: left;">
	                                                    <button class="mthd btn 
	                                                    <c:choose>
	                                                    <c:when test="${lect.SBJCT_MTHD_CD eq 1}">btn-danger</c:when>
	                                                    <c:otherwise>btn-primary</c:otherwise>
	                                                    </c:choose>" 
	                                                    value="
	                                                    <c:choose>
	                                                    <c:when test="${lect.SBJCT_MTHD_CD eq 1}">${lect.ON_LECT_SN }</c:when>
	                                                    <c:otherwise>${lect.LECT_URL}</c:otherwise></c:choose>,${lect.SBJCT_MTHD_CD}">
	                                                    <c:choose>
	                                                    <c:when test="${lect.SBJCT_MTHD_CD eq 1}">유튜브</c:when>
	                                                    <c:otherwise>
	                                                    <c:choose>
	                                                    <c:when test="${sessionScope.appl_no ne null}">줌수업</c:when>
	                                                    <c:otherwise>줌생성</c:otherwise>
	                                                    </c:choose>
	                                                    </c:otherwise>
	                                                    </c:choose>
	                                                    </button>
	                                                    <span style="cursor: pointer">${lect.ON_LECT_NM }</span>
	                                                </div>
	                                                <c:if test="${sessionScope.appl_no != null}">
	                                                <div style="padding-top: 5px; box-sizing: border-box; height: 30px; float: right; line-height: 30px; display: flex; justify-content: right;">
	                                                    <c:choose>
	                                                    <c:when test="${lect.SBJCT_MTHD_CD eq 1}">          
	                                                    <div class='progress mb-4' style='height:15px; width: 200px; margin:5px 10px 24px 0;'>
		                                                    <div class='progress-bar bg-primary' role='progressbar' style='height:20px; 
		                                                    width: 
			                                                    <c:choose>
				                                                    <c:when test="${90 le lect.LECT_PRGRS_RT}">100%;</c:when>
				                                                    <c:otherwise>${lect.LECT_PRGRS_RT}%;</c:otherwise>
			                                                    </c:choose>' 
			                                                    aria-valuenow='20' aria-valuemin='0' aria-valuemax='100'>
		                                                    </div>
	                                                    </div>
	                                                    <div style='height:20px; line-height: 20px;'>&nbsp;
															<span class='float-right pointer_default' style='height:20px; margin-right:45px; padding-top: 2px;'>
															<c:choose>
				                                                    <c:when test="${90 le lect.LECT_PRGRS_RT}">100%</c:when>
				                                                    <c:otherwise>
																	<fmt:parseNumber value="${lect.LECT_PRGRS_RT}" integerOnly="true"></fmt:parseNumber>%
				                                                    </c:otherwise>
			                                                    </c:choose>
															</span>
														</div>
	                                                    </c:when>
	                                                    <c:otherwise>
	                                                    <div style='height:15px; width: 200px; margin-top: -3px;'>
	                                                    <c:choose>
	                                                    	<c:when test="${lect.ATTENDANCE eq '1'}">
	                                                    		<button style="width:108px;" class="btn btn-outline-success">출석</button>
	                                                    	</c:when>
	                                                    	<c:when test="${lect.ATTENDANCE eq '0' || lect.ATTENDANCE eq '결석' }">
	                                                    		<button style="width:108px;" class="btn btn-outline-danger">결석</button>
	                                                    	</c:when>
	                                                    </c:choose>
														</div>
	                                                    </c:otherwise>
	                                                    </c:choose>
	                                                </div>
	                                                </c:if>
	                                            </div>
	                                        </div>
										</c:if>
                                        <c:if test="${lect.FILE_SN ne null}">
                                            <c:set var="file_cnt" value="0"/>
                                            <c:forEach begin="1" end="${lect.FILE_LENGTH}">
                                            <!-- 파일 -->
                                            <div class="week-file week-content${i} ${status.last ? 'content-last' : ''} border-left-secondary collapse">
                                                <!-- 숨길 객체의 내용 -->
                                                <div class="week-object">
                                                    <div class="week-title pointer" style="width: 50%; height: 30px; padding-top: 2px; box-sizing: border-box; float: left;">
                                                        <button class="file btn btn-secondary" value="${lect.FILE_SN},${lect.FILE_SN_SEQ_LS[file_cnt]}">자료</button>
                                                        <span>${lect.PHYS_FILE_NM_LS[file_cnt]}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <c:set var="file_cnt" value="${file_cnt + 1}"/>
                                            </c:forEach>
                                        </c:if>
										<c:if test="${sessionScope.instr_no eq null }">
<!-- 날짜 변경 -->
<%-- <c:set var="week" value="${week }"/> --%>
<c:set var="week" value="4"/>
											<!-- 지난주차들 -->
	                                        <c:if test="${i le week}">
		                                        <!-- 과제 -->
		                                        <div class="week-assign week-content${i} ${status.last ? 'content-last' : ''} border-left-warning collapse">
		                                            <!-- 숨길 객체의 내용 -->
		                                            <div class="week-object">
		                                                <div class="week-title pointer" style="width: 50%; height: 30px; padding-top: 2px; box-sizing: border-box; float: left;">
		                                                    <button class="assign btn btn-warning">과제</button>
		                                                    <span>${lect.ON_LECT_NM }</span>
		                                                </div>
		                                                <c:if test="${sessionScope.appl_no != null}">
		                                                <div style="width: 50%; padding-top: 5px; box-sizing: border-box; height: 30px; float: left; line-height: 30px; display: flex; justify-content: right;">
		                                                    <div style='height:15px; width: 200px; margin-top: -3px;'>
		                                                    	<c:choose>
		                                                    		<c:when test="${lect.LECT_PRGRS_RT >= 90 || lect.ATTENDANCE eq '1'}">
		                                                    			<button style="width:108px;" class="btn btn-outline-primary">제출</button>
		                                                    		</c:when>
		                                                    		<c:otherwise>
			                                                            <button style="width:108px;" class="btn btn-outline-danger">미제출</button>
		                                                    		</c:otherwise>
		                                                    	</c:choose>
		                                                    </div>
		                                                </div>
		                                                </c:if>
		                                            </div>
		                                        </div>
	                                        </c:if>
                                        </c:if>
                                        <c:if test="${sessionScope.instr_no != null && lect.SBJCT_MTHD_CD ne 2}">
                                        <!-- 추가 -->
                                        <div class="week-upload week-content${i} ${status.last ? 'content-last' : ''} border-left-success collapse">
                                            <!-- 숨길 객체의 내용 -->
                                            <div class="week-object">
                                                <div class="week-title" style="width: 50%; height: 30px; padding-top: 2px; box-sizing: border-box; float: left;">
                                                    <input type="hidden" id="sbjct_mthd" value="${lect.SBJCT_MTHD_CD}">
                                                    <input type="hidden" id="lect_ymd_org" value="${lect.LECT_YMD}">
                                                    <button class="upload btn btn-success" value="${lect.ON_LECT_SN}">추가</button>
                                                    <span>추가</span><span style="font-size: 12px; margin-left: 10px;"><b style="color: red;">*</b>파일, 과제를 추가합니다.</span>
                                                </div>
                                            </div>
                                        </div>
                                        </c:if>
                                        <c:set var="i" value="${i + 1}"/>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 디테일 화면 종료 -->
        </div>
        <!-- 메인 콘텐츠 종료 -->

        <!-- 공지 작성 및 보기 Modal -->
        <div class="modal notice-modal fade" id="noticeModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="notice_title"></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table table-bordered notice-table">
                            <tr class="notice-tr1">
                                <td class="notice-admin">작성자</td>
                                <td class="notice-date">작성일</td>
                            </tr>
                            <tr>
                                <td colspan="2" class="notice-content" style="height: 300px;">콘텐츠</td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-footer">
                    <c:if test="${sessionScope.instr_no ne null}">
                    <button type="button" class="btn btn-secondary notice-modify" data-bs-dismiss="modal">수정</button>
                    </c:if>
                    <button type="button" class="btn btn-primary notice-save">확인</button>
                </div>
                </div>
            </div>
        </div>

        <!-- 추가용 Modal -->
        <form id="frm-modal">
            <div class="modal upload-modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">Modal title</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="on_lect_sn" name="on_lect_sn">
                            <input type="hidden" id="sbjct_mthd_cd" name="sbjct_mthd_cd">
                            <input type="hidden" id="lect_ymd" name="lect_ymd">
                            <table class="table table-bordered">
                                <tr class="assign-tr">
                                    <th>유형</th>
                                    <td>
                                        <select class="form-select" name="upload-select" id="upload-select">
                                            <option value="assign" selected>과제</option>
                                            <option value="file">파일</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr class="assign-tr">
                                    <th class="upload-title">과제명</th>
                                    <td class="upload-title-td">
                                        <input class="form-control" type="text">
                                    </td>
                                </tr>
                                <tr class="assign-tr">
                                    <th class="upload-content">과제</th>
                                    <td class="upload-content-td">
                                        <input class="form-control" type="text">
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                            <button type="button" class="btn btn-primary modal-submit">추가</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>

        <!-- Footer -->
        <%@include file="../footer.jsp" %>

    </div>
    <!-- End of Content Wrapper -->

</div>
<!-- End of Page Wrapper -->

<!-- Scroll to Top Button -->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="js/sb-admin-2.min.js"></script>

</body>
</html>