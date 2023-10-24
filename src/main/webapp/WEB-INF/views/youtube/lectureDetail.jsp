<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Pandora University - LMS</title>
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
    const appl = "${sessionScope.appl_no}";
    const instr = "${sessionScope.instr_no}";

    if(appl != "") {

        /* 교시 코드 */
        let BGNG_CLS_CD = "${lectureInfo.BGNG_CLS_CD}";
        let END_CLS_CD = "${lectureInfo.END_CLS_CD}";

        /* 오늘 날짜를 대신합니다. */
//         let today = "${week }";
        let today = "4";

        /* createElement를 사용해서 html이 로드되면 <script><script> 태그를 생성 */
        var tag = document.createElement('script');

        /* 만들어진 태그 유튜브 API가 정상적으로 동작할 시 <div id='player'> 안에 iframe을 삽입 준비 */
        tag.src = "https://www.youtube.com/iframe_api";

        /* 위에 선언된 var tag를 가장 첫번째 <script>로 인식 시키기 위한 코드 */
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        /* 유튜브 동영상 iframe 생성 객체, 그 안에 실행될 동영상 정보를 가져오고 상태 변화에 따른 이벤트를 발생 시킴 */
        var player;
        /* 인터벌 사용하기 위한 변수 선언 */
        let timer = null;
        /* 실제 동영상 재생 시간 위치 */
        let curr_time = 0;
        /* 동영상 주소 */
        let video_id = "${lectureInfo.ON_LECT_URL }";
        /* 학생이 실제 시청 시간 위치 */
        let play_time = "${lectureInfo.LAST_PLAY_TM }";
        /* 동영상 총 재생시간 */
        let lect_max_tm = "${lectureInfo.LECT_MAX_TM}";
        /* 해당 강의 번호 */
        let on_lect_sn = "${lectureInfo.ON_LECT_SN}";
        /* 해당 과목 번호 */
        let sbjct_no = "${lectureInfo.SBJCT_NO}";

        /* 유튜브 Iframe 준비 상태 */
        function onYouTubeIframeAPIReady() {
            player = new YT.Player('youtubePlayer', {
                videoId: video_id,
                playerVars: {
                    rel: 0,
                    controls: 1,
                    start: play_time
                },
                events: {
                    'onReady': onPlayerReady,
                    'onStateChange': onPlayerStateChange
                }
            });
        }

        /* iframe 준비 완료 상태 */
        function onPlayerReady(event) {
        }

        /* 플레이어 상태 변화 */
        function onPlayerStateChange(event) {

            /* 동영상 버퍼링 상태 */
            if (event.data === YT.PlayerState.BUFFERING) {
            }

            if (event.data === YT.PlayerState.CUED) {
            }

            /* 동영상 재생 상태 */
            if (event.data === YT.PlayerState.PLAYING) {
                $(function () {
                    $.ajax({
                        type: "POST",
                        url: "/getPlayTime",
                        data: {"on_lect_sn": on_lect_sn },
                        dataType: "text",
                        success: function (playTime) {
                            play_time = playTime;
                            curr_time = Math.floor(player.getCurrentTime());

                            /* 현재 재생시간이 동영상 전체 재생시간 -10초와 같을 경우 수강 완료로 인식합니다.  */
                            if(curr_time >= (lect_max_tm - 10)) {
                                player.stopVideo();
                                if( (BGNG_CLS_CD >= today) && (END_CLS_CD <= today) ) {
                                    alert("강의를 수강하셨습니다.");
                                } else {
                                    alert("강의를 수강하셨습니다.\n*지난 강의는 출석에 반영되지 않습니다.");
                                }
                                return false;
                            }

                            /* 실시간 재생 시간과 저장된 재생 시간의 차이가 3보다 클 경우 저장된 위치로 옮깁니다. */
                            if( (BGNG_CLS_CD >= today) && (END_CLS_CD <= today) ) {
                                if ((curr_time - play_time) > 3) {
                                    player.seekTo(play_time);
                                }
                            }

                            /* 초마다 재생 시간을 검사합니다 */
                            if (timer == null) {
                                timer = setInterval(checkVideoTime, 1000);
                            }
                        },
                        error: function () {
                            alert("저장된 재생 시간을 불러오지 못했습니다.");
                        }
                    });
                });
            }

            /* 동영상 일시정지 상태 */
            if (event.data === YT.PlayerState.PAUSED) {
                $(function () {
                    $.ajax({
                        type: "POST",
                        url: "/getPlayTime",
                        data: {"on_lect_sn": on_lect_sn },
                        dataType: "text",
                        success: function (playTime) {
                            play_time = playTime;
                            curr_time = Math.floor(player.getCurrentTime());

                            /*
                                재생 시간이 저장된 재생 시간보다 클 경우 실행합니다.
                            */
                            if (curr_time > play_time) {
                                /* 실시간 재생 위치와 데이터베이스에 등록된 값의 차이가 5초 이하일 경우는 정상 */
                                if ((curr_time - play_time) <= 5) {
                                    playTimeSave();
                                }
                                /* 실시간 재생 위치와 데이터베이스에 등록된 값의 차이가 5초 초과일 경우 비정상 */
                                else {
                                    if( (BGNG_CLS_CD >= today) && (END_CLS_CD <= today) ) {
                                        player.seekTo(play_time);
                                    }
                                }
                            }

                            /* 반복되는 인터벌을 클리어 합니다. */
                            clearInterval(timer);
                            timer = null;
                        },
                        error: function () {
                            alert("저장된 재생 시간을 불러오지 못했습니다.");
                        }
                    });
                });
            }

            /* 동영상 종료 상태 */
            if (event.data === YT.PlayerState.ENDED) {
                timer = null;
            }
        }

        /* 초 단위로 재생 위치를 알아옵니다. */
        var count = 0;

        function checkVideoTime() {
            count += 1;
            curr_time = Math.floor(player.getCurrentTime());

            console.log("재생 시간 [현재] : " + curr_time);

            /* 현재 재생시간이 동영상 전체 재생시간 -10초와 같을 경우 수강 완료로 인식합니다. *재생중일 경우 완강 시 타이머 종료 후 저장합니다.  */
            if(curr_time >= (lect_max_tm - 10)) {
                player.stopVideo();
                clearInterval(timer);
                timer = null;
                playTimeSave();

                if ((BGNG_CLS_CD >= today) && (today <= END_CLS_CD)) {
                    /* 수강 완료 출석 관련 데이터 삽입 */
                    $.post({
                        url: "/applATNDInsert",
                        data: {"sbjct_no": sbjct_no, "on_lect_sn": on_lect_sn},
                        dataType: "text",
                        success: function (result) {
                            alert("강의를 수강하셨습니다.");
                        },
                        error: function () {
                            alert("에러 발생\n잠시 후 다시 시도해주세요.");
                        }
                    });
                    return false;
                } else {
                    alert("강의를 수강하셨습니다.\n*지난 강의는 출석에 반영되지 않습니다.");
                }
            }

            /* 재생 위치를 5초마다 저장합니다. */
            if ((count % 5) == 0) {
                /* 실시간 재생 위치가 저장된 재생 위치 값보다 클 경우 실행합니다. */
                if (curr_time > play_time) {
                    playTimeSave();
                }
            }

        }

        /* 재생 시간을 저장합니다. */
        function playTimeSave() {
            $(function () {
                $.ajax({
                    type: "POST",
                    url: "/playTimeSave",
                    data: {"on_lect_sn": on_lect_sn, "curr_time" : curr_time, "today" : today},
                    dataType: "text",
                    success: function (result) {
                        if(result == "success") {
                            console.log("[playTimeSave] " + curr_time + "초 저장");
                        } else if(result == "fail") {
                            if( (BGNG_CLS_CD >= today) && (END_CLS_CD <= today) ) {
                                player.seekTo(play_time);
                            }
                        }
                    },
                    error: function () {
                        alert("재생 시간을 저장하지 못했습니다.");
                    }
                });
            });
        }
    } else {
        var tag = document.createElement('script');

        tag.src = "https://www.youtube.com/iframe_api";

        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        let video_id = "${lectureInfo.ON_LECT_URL }";
        let on_lect_sn = "${lectureInfo.ON_LECT_SN}";

        function onYouTubeIframeAPIReady() {
            player = new YT.Player('youtubePlayer', {
                videoId: video_id,
                playerVars: {
                    rel: 0,
                    controls: 1
                },
                events: {
                    'onReady': onPlayerReady,
                    'onStateChange': onPlayerStateChange
                }
            });
        }
    }
</script>
<style>
    .card-body {
        height: 900px;
    }

    .lecture-content {
        justify-content: center;
        width: 100%;
        height: 85%;
    }

    .youtube-player {
        width: 100%;
        height: 100%;
    }

    .lecture-info {
        display: block;
        width: 100%;
        height: 16%;
    }

    .lecture-progress {
        display: block;
        width: 100%;
        height: 50%;
    }

    .lecture-progress > span {
        display: block;
        width: 100%;
        height: 100%;
        text-align: center;
        padding-top: 10px;
        box-sizing: border-box;
    }

    .lecture-page-btn {
        display: block;
        width: 100%;
        height: 50%;
    }

    .lecture-page-btn > span {
        display: block;
        width: 100%;
        height: 100%;
        text-align: right;
        padding-top: 10px;
        box-sizing: border-box;
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
            <!-- 본문 컨텐츠 부분 시작 -->
            <div class="container-fluid">

                <!-- 메인 페이지의 탑 -->
                <div class="d-sm-flex align-items-center justify-content-between mt-4 mb-4">
                    <h1 class="h3 mb-0 text-gray-800"></h1>
                    <%--                        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i class="fas fa-download fa-sm text-white-50"></i> 이건무슨 버튼으로 쓸까</a>--%>
                </div>

                <div class="row">
                    <!-- A카드 게시판 -->
                    <div class="col-xl-12 col-lg-7">
                        <div class="card shadow mb-4">
                            <!-- A 카드 설정 버튼 부분 -->
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary pointer_default">내 강의실</h6>
                            </div>
                            <!-- A 본문 부분 -->
                            <div class="card-body">
                                <div class="lecture-content">
                                    <!-- 실제 구성은 이곳에서 진행합니다. -->
                                    <div class="youtube-player" id="youtubePlayer"></div>
                                    <div class="lecture-info">
                                        <div class="lecture-page-btn">
                                            <span>
                                                <button class="btn btn-primary" onclick="location.href='/lectureList?sbjct_no=${lectureInfo.SBJCT_NO}'">목록</button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <!-- 디테일 화면 종료 -->
        </div>
        <!-- 메인 콘텐츠 종료 -->

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

<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="js/sb-admin-2.min.js"></script>

</body>
</html>