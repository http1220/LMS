package com.pandora.lms.ytbUtil;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.client.googleapis.media.MediaHttpUploader;
import com.google.api.client.googleapis.media.MediaHttpUploaderProgressListener;
import com.google.api.client.http.InputStreamContent;
import com.google.api.services.youtube.YouTube;
import com.google.api.services.youtube.model.Video;
import com.google.api.services.youtube.model.VideoSnippet;
import com.google.api.services.youtube.model.VideoStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class UploadVideo {
    /* API 요청을 위한 YouTube 객체의 전역 인스턴스입니다. */
    private static YouTube youtube;
    private Map<String, Object> result;
    public Map<String, Object> uploadVideo(Credential credential, MultipartFile videoFile, Map<String, Object> videoInfo) {
         result = new HashMap<>();

        System.out.println("엑세스 관련 : " + credential.getAccessToken());
        System.out.println("파일 이름 : " + videoFile.getOriginalFilename());
        System.out.println("파일 크기 : " + videoFile.getSize());
        String CRCLM_CD = String.valueOf(videoInfo.get("CRCLM_CD"));
        String LECT_YMD = String.valueOf(videoInfo.get("LECT_YMD"));
        String SBJCT_NO = String.valueOf(videoInfo.get("SBJCT_NO"));
        String ON_LECT_NM = String.valueOf(videoInfo.get("ON_LECT_NM"));
        String ON_LECT_CN = String.valueOf(videoInfo.get("ON_LECT_CN"));

        /* 업로드되는 동영상의 형식 */
        String VIDEO_FILE_FORMAT = "video/*";

        try {
            // API 요청을 위해 사용되는 YouTube 객체입니다.
            youtube = new YouTube.Builder(OAuth.HTTP_TRANSPORT, OAuth.JSON_FACTORY, credential).setApplicationName(
                    "youtube-cmdline-uploadvideo-sample").build();

            /* 업로드할 비디오 파일을 가져옵니다, 콘솔로 사용자가 올린 파일명을 출력합니다. */
            byte[] videoFileByte = videoFile.getBytes();
            System.out.println(videoFile.getOriginalFilename() + "을(를) 업로드 중입니다.");

            /* 비디오 추가 정보 */
            Video videoObjectDefiningMetadata = new Video();

            /* 공개 범위, public, unlisted, private */
            VideoStatus status = new VideoStatus();
            status.setPrivacyStatus("unlisted");

            videoObjectDefiningMetadata.setStatus(status);

            /* VideoSnippet 객체를 사용하여 대부분의 메타데이터(동영상 정보)를 설정합니다. */
            VideoSnippet snippet = new VideoSnippet();

            /* 동영상 정보를 입력합니다. */
            snippet.setTitle(ON_LECT_NM);
            snippet.setDescription(ON_LECT_CN);

            /* 키워드 설정 */
            List<String> tags = new ArrayList<String>();
            tags.add("test");
            tags.add("Pandora!");
            tags.add("java");
            tags.add("YouTube Data API V3");
            snippet.setTags(tags);

            // 영상 객체에 완성된 스니펫을 설정합니다.
            videoObjectDefiningMetadata.setSnippet(snippet);

            /* 허용된 비디오 타입만, 실제 바이트 형태 배열로 변환한 동영상, 동영상 용량 */
            InputStreamContent mediaContent = new InputStreamContent(VIDEO_FILE_FORMAT, new ByteArrayInputStream(videoFileByte));
            mediaContent.setLength(videoFileByte.length);

            /*
             * 업로드 명령어는 다음을 포함합니다:
             * 파일이 성공적으로 업로드 된 후 반환하려는 정보
             * 업로드 된 비디오와 관련된 메타데이터
             * 업로드 할 비디오 파일 자체.
             */
            YouTube.Videos.Insert videoInsert = youtube.videos()
                    .insert("snippet,statistics,status", videoObjectDefiningMetadata, mediaContent);

            // 업로드 유형을 설정하고 이벤트 리스너를 추가합니다.
            MediaHttpUploader uploader = videoInsert.getMediaHttpUploader();

            /*
             * 미디어 직접 업로드를 사용할 것인지 여부를 설정합니다.
             * true : 미디어 콘텐츠 전체가 하나의 요청으로 업로드됩니다.
             * false (기본값) = 데이터 청크(여러 조각)를 업로드하는 resumable media 업로드 프로토콜을 사용합니다.
             */
            uploader.setDirectUploadEnabled(false);

            /* 업로드 진행 시 진행 상황에 대단 값을 반환합니다. */
            MediaHttpUploaderProgressListener progressListener = new MediaHttpUploaderProgressListener() {
                public void progressChanged(MediaHttpUploader uploader) throws IOException {
                    switch (uploader.getUploadState()) {
                        case INITIATION_STARTED:
                            System.out.println("Initiation Started");
                            break;
                        case INITIATION_COMPLETE:
                            System.out.println("Initiation Completed");
                            break;
                        case MEDIA_IN_PROGRESS:
                            System.out.println("Upload in progress");
                            System.out.println("Upload percentage: " + (uploader.getProgress() * 100));
                            break;
                        case MEDIA_COMPLETE:
                            System.out.println("Upload Completed!");
                            break;
                        case NOT_STARTED:
                            System.out.println("Upload Not Started!");
                            break;
                    }
                }
            };
            uploader.setProgressListener(progressListener);

            // 업로드 실행
            Video returnedVideo = videoInsert.execute();

            // 실행 결과 출력
            System.out.println("\n================== Returned Video ==================\n");
            System.out.println("  - Id: " + returnedVideo.getId());
            System.out.println("  - Title: " + returnedVideo.getSnippet().getTitle());
            System.out.println("  - Tags: " + returnedVideo.getSnippet().getTags());
            System.out.println("  - Privacy Status: " + returnedVideo.getStatus().getPrivacyStatus());
            System.out.println("  - Video Count: " + returnedVideo.getStatistics().getViewCount());
            System.out.println("  - Duration: " + returnedVideo.getContentDetails());

            result.put("CRCLM_CD", CRCLM_CD);
            result.put("SBJCT_NO", SBJCT_NO);
            result.put("LECT_YMD", LECT_YMD);
            result.put("ON_LECT_NM", returnedVideo.getSnippet().getTitle());
            result.put("ON_LECT_CN", returnedVideo.getSnippet().getDescription());
            result.put("ON_LECT_URL", returnedVideo.getId());
            // result.put("ON_LECT_TM", returnedVideo.getContentDetails().getDuration());


        } catch (GoogleJsonResponseException e) {
            System.err.println("GoogleJsonResponseException code: " + e.getDetails().getCode() + " : "
                    + e.getDetails().getMessage());
            e.printStackTrace();
        } catch (IOException e) {
            System.err.println("IOException: " + e.getMessage());
            e.printStackTrace();
        } catch (Throwable t) {
            System.err.println("Throwable: " + t.getMessage());
            t.printStackTrace();
        }

        return result;
    }

}
