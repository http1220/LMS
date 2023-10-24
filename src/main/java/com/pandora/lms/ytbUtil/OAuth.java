package com.pandora.lms.ytbUtil;

import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.extensions.java6.auth.oauth2.FileCredentialStore;
import com.google.api.client.extensions.java6.auth.oauth2.VerificationCodeReceiver;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.Preconditions;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 사용자의 계정에 OAuth2를 사용하여 YouTube Data API (V3)를 통해 비디오를 업로드하는 데모입니다.
 * <p>
 * TODO : 주의, 비디오 파일을 이 애플리케이션으로 업로드하려면 프로젝트 폴더에 파일을 추가해야 합니다!
 *
 * @author Jeremy Walker
 */
@Component
public class OAuth {
    private static final Logger LOGGER = Logger.getLogger(OAuth.class.getName());

    /**
     * HTTP 전송의 전역 인스턴스입니다.
     */
    public static final HttpTransport HTTP_TRANSPORT = new NetHttpTransport();

    /**
     * JSON 파싱을 위한 전역 인스턴스입니다.
     */
    public static final JsonFactory JSON_FACTORY = new JacksonFactory();

    /**
     * 설치된 애플리케이션이 사용자의 보호된 데이터에 액세스할 수 있도록 인증합니다.
     *
     * @param scopes YouTube 업로드에 필요한 범위(scope) 목록입니다.
     */
    public Credential authorize(List<String> scopes, boolean authScope) throws Exception {
        GoogleAuthorizationCodeFlow flow = null;
        VerificationCodeReceiver localReceiver = null;

        // 클라이언트 시크릿을 로드합니다.
        GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(
                JSON_FACTORY, new InputStreamReader(OAuth.class.getResourceAsStream("/client_secrets.json")));


        // 기본값이 대체되었는지 확인합니다 (기본값 = "여기에 X 입력").
        if (clientSecrets.getDetails().getClientId().startsWith("Enter")
                || clientSecrets.getDetails().getClientSecret().startsWith("Enter ")) {
            System.out.println(
                    "Enter Client ID and Secret from https://console.developers.google.com/project/_/apiui/credential"
                            + "into youtube-cmdline-uploadvideo-sample/src/main/resources/client_secrets.json");
            System.exit(1);
        }

        // 파일 자격 증명 저장소를 설정합니다.
        FileCredentialStore credentialStore = new FileCredentialStore(
                new File(System.getProperty("user.home"), ".credentials/youtube-api-uploadvideo.json"), JSON_FACTORY);

        // 권한 코드 플로우를 설정합니다.
        flow = new GoogleAuthorizationCodeFlow.Builder(
                HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, scopes).setCredentialStore(credentialStore).build();

        // 로컬 서버를 빌드하고 9000 포트에 바인드합니다.
        localReceiver = new LocalServerReceiver.Builder().setPort(9000).build();

        // 인증합니다.
        return authorize(flow, localReceiver, authScope);
    }

    /* 구글 권한 인증 (세부 페이지) */
    /*
    * authScope
    * - true : 인증 여부 파악 (인증 완료 : Credential 객체 반환, 인증 미완료 : null 반환)
    * - false : 인증위한 url 출력
    * */
    private Credential authorize(GoogleAuthorizationCodeFlow flow, VerificationCodeReceiver localReceiver, boolean authScope) throws IOException {
        try {
            Credential credential = flow.loadCredential("user");
            if (credential != null
                    && (credential.getRefreshToken() != null
                    || credential.getExpiresInSeconds() == null
                    || credential.getExpiresInSeconds() > 60)) {
                return credential;
            }
            // open in browser
            String redirectUri = localReceiver.getRedirectUri();
            AuthorizationCodeRequestUrl authorizationUrl = flow.newAuthorizationUrl().setRedirectUri(redirectUri);

            String url = authorizationUrl.build();
            Preconditions.checkNotNull(url);
            if(authScope) {
                return null;
            }
            openBrowse(url);

            // receive authorization code and exchange it for an access token
            String code = localReceiver.waitForCode();
            TokenResponse response = flow.newTokenRequest(code).setRedirectUri(redirectUri).execute();

            // store credential and return it
            return flow.createAndStoreCredential(response, "user");
        } finally {
            localReceiver.stop();
        }
    }

    /* 자바로 기본 브라우저 새로운 탭 열기 */
    public void openBrowse(String url) {
        try {
            if (Desktop.isDesktopSupported()) {
                // java with desktop support
                Desktop desktop = Desktop.getDesktop();
                desktop.browse(new URI(url));
            } else {
                // no java desktop support
                // fall back into dark ages
                String osName = System.getProperty("os.name");

                if (osName.toLowerCase().contains("linux")) {
                    // probably linux/unix
                    Runtime runtime = Runtime.getRuntime();
                    runtime.exec("xdg-open " + url);
                } else if (osName.toLowerCase().contains("windows")) {
                    // older windows
                    Runtime.getRuntime().exec("cmd /c start \"\" \"" + url + "\"");
                } else if (osName.toLowerCase().contains("mac")) {
                    // probably mac os
                    Class.forName("com.apple.eio.FileManager").getDeclaredMethod("openURL", String.class).invoke(null, url);
                }
            }
        } catch (IOException | InternalError | ClassNotFoundException | NoSuchMethodException | IllegalAccessException |
                 InvocationTargetException | URISyntaxException e) {
            System.out.println(Level.WARNING + "\nUnable to open browser\n" + e);
        }
    }

}