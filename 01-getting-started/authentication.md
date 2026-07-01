> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 인증

> Claude Code에 로그인하고 개인, 팀, 조직을 위한 인증을 구성합니다.

Claude Code는 설정에 따라 여러 인증 방법을 지원합니다. 개별 사용자는 Claude.ai 계정으로 로그인할 수 있으며, 팀은 Claude for Teams 또는 Enterprise, Claude Console, 또는 Amazon Bedrock, Google Vertex AI, Microsoft Foundry와 같은 클라우드 제공자를 사용할 수 있습니다.

<h2 id="log-in-to-claude-code">
  Claude Code에 로그인
</h2>

[Claude Code를 설치](/ko/setup#install-claude-code)한 후 터미널에서 `claude`를 실행합니다. 처음 실행할 때 Claude Code는 로그인할 수 있도록 브라우저 창을 엽니다.

브라우저가 자동으로 열리지 않으면 `c`를 눌러 로그인 URL을 클립보드에 복사한 후 브라우저에 붙여넣습니다.

브라우저에서 로그인 후 리디렉션 대신 로그인 코드를 표시하면 터미널의 `Paste code here if prompted` 프롬프트에 붙여넣습니다. 이는 브라우저가 Claude Code의 로컬 콜백 서버에 도달할 수 없을 때 발생하며, WSL2, SSH 세션 및 컨테이너에서 일반적입니다.

다음 계정 유형 중 하나로 인증할 수 있습니다:

* **Claude Pro 또는 Max 구독**: Claude.ai 계정으로 로그인합니다. [claude.com/pricing](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_pro_max)에서 구독합니다.
* **Claude for Teams 또는 Enterprise**: 팀 관리자가 초대한 Claude.ai 계정으로 로그인합니다.
* **Claude Console**: Console 자격증명으로 로그인합니다. 관리자가 먼저 [초대](#claude-console-authentication)해야 합니다.
* **클라우드 제공자**: 조직에서 [Amazon Bedrock](/ko/amazon-bedrock), [Google Vertex AI](/ko/google-vertex-ai), 또는 [Microsoft Foundry](/ko/microsoft-foundry)를 사용하는 경우 `claude`를 실행하기 전에 필요한 환경 변수를 설정합니다. 브라우저 로그인이 필요하지 않습니다.
* **클라우드 게이트웨이**: 조직에서 자체 호스팅 [Claude 앱 게이트웨이](/ko/claude-apps-gateway)를 실행하는 경우 `/login`을 통해 회사 SSO로 로그인합니다. 게이트웨이에서 발급한 토큰이 세션의 유일한 자격증명입니다.

Claude Code 프롬프트에서 `/logout`을 입력하여 로그아웃하고 다시 인증합니다.

로그인에 문제가 있으면 [인증 문제 해결](/ko/troubleshoot-install#login-and-authentication)을 참조합니다.

<h2 id="set-up-team-authentication">
  팀 인증 설정
</h2>

팀과 조직의 경우 다음 방법 중 하나로 Claude Code 액세스를 구성할 수 있습니다:

* [Claude for Teams 또는 Enterprise](#claude-for-teams-or-enterprise), 대부분의 팀에 권장됨
* [Claude Console](#claude-console-authentication)
* [Claude apps gateway](/ko/claude-apps-gateway), 개발자가 IdP로 로그인하고 구성한 클라우드 제공자로 추론을 라우팅하는 자체 호스팅 게이트웨이
* [Amazon Bedrock](/ko/amazon-bedrock)
* [Google Vertex AI](/ko/google-vertex-ai)
* [Microsoft Foundry](/ko/microsoft-foundry)

<h3 id="claude-for-teams-or-enterprise">
  Claude for Teams 또는 Enterprise
</h3>

[Claude for Teams](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_teams#team-&-enterprise)와 [Claude for Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_enterprise)는 Claude Code를 사용하는 조직에 최고의 경험을 제공합니다. 팀 멤버는 중앙 집중식 청구 및 팀 관리를 통해 Claude Code와 웹의 Claude에 모두 액세스할 수 있습니다.

* **Claude for Teams**: 협업 기능, 관리 도구, 청구 관리가 포함된 셀프 서비스 플랜입니다. 소규모 팀에 최적입니다.
* **Claude for Enterprise**: SSO, 도메인 캡처, 역할 기반 권한, 규정 준수 API, 조직 전체 Claude Code 구성을 위한 관리형 정책 설정을 추가합니다. 보안 및 규정 준수 요구 사항이 있는 대규모 조직에 최적입니다.

<Steps>
  <Step title="구독">
    [Claude for Teams](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_teams_step#team-&-enterprise)를 구독하거나 [Claude for Enterprise](https://anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_enterprise_step)에 대해 영업팀에 문의합니다.
  </Step>

  <Step title="팀 멤버 초대">
    관리자 대시보드에서 팀 멤버를 초대합니다.
  </Step>

  <Step title="설치 및 로그인">
    팀 멤버는 Claude Code를 설치하고 Claude.ai 계정으로 로그인합니다.
  </Step>
</Steps>

<h3 id="claude-console-authentication">
  Claude Console 인증
</h3>

API 기반 청구를 선호하는 조직의 경우 Claude Console을 통해 액세스를 설정할 수 있습니다.

<Steps>
  <Step title="Console 계정 생성 또는 사용">
    기존 Claude Console 계정을 사용하거나 새로 만듭니다.
  </Step>

  <Step title="사용자 추가">
    다음 방법 중 하나로 사용자를 추가할 수 있습니다:

    * Console 내에서 사용자를 일괄 초대: Settings -> Members -> Invite
    * [SSO 설정](https://support.claude.com/en/articles/13132885-setting-up-single-sign-on-sso)
  </Step>

  <Step title="역할 할당">
    사용자를 초대할 때 다음 중 하나를 할당합니다:

    * **Claude Code** 역할: 사용자는 Claude Code API 키만 생성할 수 있습니다
    * **Developer** 역할: 사용자는 모든 종류의 API 키를 생성할 수 있습니다
  </Step>

  <Step title="사용자가 설정 완료">
    초대된 각 사용자는 다음을 수행해야 합니다:

    * Console 초대 수락
    * [시스템 요구 사항 확인](/ko/setup#system-requirements)
    * [Claude Code 설치](/ko/setup#install-claude-code)
    * Console 계정 자격증명으로 로그인
  </Step>
</Steps>

<h3 id="cloud-provider-authentication">
  클라우드 제공자 인증
</h3>

Amazon Bedrock, Google Vertex AI 또는 Microsoft Foundry를 사용하는 팀의 경우:

<Steps>
  <Step title="제공자 설정 따르기">
    [Bedrock 문서](/ko/amazon-bedrock), [Vertex 문서](/ko/google-vertex-ai), 또는 [Microsoft Foundry 문서](/ko/microsoft-foundry)를 따릅니다.
  </Step>

  <Step title="구성 배포">
    환경 변수와 클라우드 자격증명 생성 지침을 사용자에게 배포합니다. [여기에서 구성을 관리하는 방법](/ko/settings)에 대해 자세히 알아봅니다.
  </Step>

  <Step title="Claude Code 설치">
    사용자는 [Claude Code를 설치](/ko/setup#install-claude-code)할 수 있습니다.
  </Step>
</Steps>

<h2 id="credential-management">
  자격증명 관리
</h2>

Claude Code는 인증 자격증명을 안전하게 관리합니다:

* **저장 위치**:
  * macOS에서 자격증명은 암호화된 macOS Keychain에 저장됩니다.
  * Linux에서 자격증명은 `~/.claude/.credentials.json`에 파일 모드 `0600`으로 저장됩니다.
  * Windows에서 자격증명은 `%USERPROFILE%\.claude\.credentials.json`에 저장되며 사용자 프로필 디렉터리의 액세스 제어를 상속하므로 기본적으로 파일이 사용자 계정으로 제한됩니다.
  * Linux 또는 Windows에서 `CLAUDE_CONFIG_DIR` 환경 변수를 설정한 경우 `.credentials.json` 파일은 해당 디렉터리 아래에 있습니다.
  * Claude Code는 `/login` 및 `/logout`을 통해 `.credentials.json`을 관리합니다. 요청을 사용자 정의 API 엔드포인트를 통해 라우팅하려면 대신 [`ANTHROPIC_BASE_URL`](/ko/env-vars) 환경 변수를 설정합니다.
* **지원되는 인증 유형**: Claude.ai 자격증명, Claude API 자격증명, Azure Auth, Bedrock Auth, Vertex Auth, 및 [Claude apps gateway](/ko/claude-apps-gateway) 세션 토큰.
* **사용자 정의 자격증명 스크립트**: [`apiKeyHelper`](/ko/settings#available-settings) 설정을 구성하여 API 키를 반환하는 셸 스크립트를 실행할 수 있습니다.
* **새로고침 간격**: 기본적으로 `apiKeyHelper`는 5분 후 또는 HTTP 401 응답 시 호출됩니다. 사용자 정의 새로고침 간격을 위해 `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` 환경 변수를 설정합니다.
* **느린 도우미 알림**: `apiKeyHelper`가 키를 반환하는 데 10초 이상 걸리면 Claude Code는 경과 시간을 표시하는 프롬프트 표시줄에 경고 알림을 표시합니다. 이 알림이 정기적으로 표시되면 자격증명 스크립트를 최적화할 수 있는지 확인합니다.

`apiKeyHelper`, `ANTHROPIC_API_KEY`, `ANTHROPIC_AUTH_TOKEN`은 CLI 및 VS Code 확장 프로그램, Agent SDK, GitHub Actions를 포함하여 이를 래핑하는 표면에 적용됩니다. Claude Desktop 및 클라우드 세션은 `apiKeyHelper`를 호출하거나 이러한 환경 변수를 읽지 않습니다. 이들은 OAuth를 사용하며, [조직에서 배포한 타사 추론 구성](/ko/llm-gateway-connect#desktop-app)을 실행하는 데스크톱 세션은 해당 구성의 자격증명으로 인증합니다.

<h3 id="authentication-precedence">
  인증 우선순위
</h3>

여러 자격증명이 있을 때 Claude Code는 다음 순서로 선택합니다:

1. `CLAUDE_CODE_USE_BEDROCK`, `CLAUDE_CODE_USE_VERTEX`, 또는 `CLAUDE_CODE_USE_FOUNDRY`가 설정된 경우 클라우드 제공자 자격증명. 설정은 [타사 통합](/ko/third-party-integrations)을 참조합니다.
2. `ANTHROPIC_AUTH_TOKEN` 환경 변수. `Authorization: Bearer` 헤더로 전송됩니다. Anthropic API 키 대신 베어러 토큰으로 인증하는 [LLM 게이트웨이 또는 프록시](/ko/llm-gateway)를 통해 라우팅할 때 사용합니다.
3. `ANTHROPIC_API_KEY` 환경 변수. `X-Api-Key` 헤더로 전송됩니다. [Claude Console](https://platform.claude.com)의 키를 사용하여 Anthropic API에 직접 액세스할 때 사용합니다. 대화형 모드에서는 키를 승인하거나 거부하도록 한 번 프롬프트되며 선택이 기억됩니다. 나중에 변경하려면 `/config`의 "사용자 정의 API 키 사용" 토글을 사용합니다. 비대화형 모드(`-p`)에서는 키가 있을 때 항상 사용됩니다.
4. [`apiKeyHelper`](/ko/settings#available-settings) 스크립트 출력. 자격증명 모음에서 가져온 단기 토큰과 같은 동적 또는 회전 자격증명에 사용합니다.
5. `CLAUDE_CODE_OAUTH_TOKEN` 환경 변수. [`claude setup-token`](#generate-a-long-lived-token)으로 생성된 장기 OAuth 토큰입니다. 브라우저 로그인을 사용할 수 없는 CI 파이프라인 및 스크립트에 사용합니다.
6. `/login`의 구독 OAuth 자격증명. Claude Pro, Max, Team, Enterprise 사용자의 기본값입니다.

활성 Claude 구독이 있지만 환경에 `ANTHROPIC_API_KEY`도 설정되어 있으면 승인된 후 API 키가 우선합니다. 키가 비활성화되거나 만료된 조직에 속하면 인증 실패가 발생할 수 있습니다. `unset ANTHROPIC_API_KEY`를 실행하여 구독으로 돌아가고 `/status`를 확인하여 활성 방법을 확인합니다.

[Claude Code on the Web](/ko/claude-code-on-the-web)은 항상 구독 자격증명을 사용합니다. 샌드박스 환경의 `ANTHROPIC_API_KEY` 및 `ANTHROPIC_AUTH_TOKEN`은 이를 재정의하지 않습니다.

<h3 id="generate-a-long-lived-token">
  장기 토큰 생성
</h3>

CI 파이프라인, 스크립트 또는 대화형 브라우저 로그인을 사용할 수 없는 기타 환경의 경우 `claude setup-token`으로 1년 OAuth 토큰을 생성합니다:

```bash theme={null}
claude setup-token
```

명령은 OAuth 인증을 안내하고 터미널에 토큰을 인쇄합니다. 토큰을 어디에도 저장하지 않으므로 복사하여 인증하려는 곳에 `CLAUDE_CODE_OAUTH_TOKEN` 환경 변수로 설정합니다:

```bash theme={null}
export CLAUDE_CODE_OAUTH_TOKEN=your-token
```

이 토큰은 Claude 구독으로 인증하며 Pro, Max, Team 또는 Enterprise 플랜이 필요합니다. 추론만으로 범위가 지정되며 [Remote Control](/ko/remote-control) 세션을 설정할 수 없습니다.

[Bare mode](/ko/headless#start-faster-with-bare-mode)는 `CLAUDE_CODE_OAUTH_TOKEN`을 읽지 않습니다. 스크립트가 `--bare`를 전달하면 `ANTHROPIC_API_KEY` 또는 `apiKeyHelper`로 인증합니다.
