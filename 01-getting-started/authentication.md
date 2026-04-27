> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 인증

> Claude Code에 로그인하고 개인, 팀, 조직을 위한 인증을 구성합니다.

Claude Code는 설정에 따라 여러 인증 방법을 지원합니다. 개별 사용자는 Claude.ai 계정으로 로그인할 수 있으며, 팀은 Claude for Teams 또는 Enterprise, Claude Console, 또는 Amazon Bedrock, Google Vertex AI, Microsoft Foundry와 같은 클라우드 제공자를 사용할 수 있습니다.

## Claude Code에 로그인

[Claude Code를 설치](/ko/setup#install-claude-code)한 후 터미널에서 `claude`를 실행합니다. 처음 실행할 때 Claude Code는 로그인할 수 있도록 브라우저 창을 엽니다.

브라우저가 자동으로 열리지 않으면 `c`를 눌러 로그인 URL을 클립보드에 복사한 후 브라우저에 붙여넣습니다.

다음 계정 유형 중 하나로 인증할 수 있습니다:

* **Claude Pro 또는 Max 구독**: Claude.ai 계정으로 로그인합니다. [claude.com/pricing](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=authentication_pro_max)에서 구독합니다.
* **Claude for Teams 또는 Enterprise**: 팀 관리자가 초대한 Claude.ai 계정으로 로그인합니다.
* **Claude Console**: Console 자격증명으로 로그인합니다. 관리자가 먼저 [초대](#claude-console-authentication)해야 합니다.
* **클라우드 제공자**: 조직에서 [Amazon Bedrock](/ko/amazon-bedrock), [Google Vertex AI](/ko/google-vertex-ai), 또는 [Microsoft Foundry](/ko/microsoft-foundry)를 사용하는 경우 `claude`를 실행하기 전에 필요한 환경 변수를 설정합니다. 브라우저 로그인이 필요하지 않습니다.

로그아웃하고 다시 인증하려면 Claude Code 프롬프트에서 `/logout`을 입력합니다.

로그인에 문제가 있으면 [인증 문제 해결](/ko/troubleshooting#authentication-issues)을 참조합니다.

## 팀 인증 설정

팀과 조직의 경우 다음 방법 중 하나로 Claude Code 액세스를 구성할 수 있습니다:

* [Claude for Teams 또는 Enterprise](#claude-for-teams-or-enterprise), 대부분의 팀에 권장됨
* [Claude Console](#claude-console-authentication)
* [Amazon Bedrock](/ko/amazon-bedrock)
* [Google Vertex AI](/ko/google-vertex-ai)
* [Microsoft Foundry](/ko/microsoft-foundry)

### Claude for Teams 또는 Enterprise

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

### Claude Console 인증

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

### 클라우드 제공자 인증

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

## 자격증명 관리

Claude Code는 인증 자격증명을 안전하게 관리합니다:

* **저장 위치**: macOS에서 자격증명은 암호화된 macOS Keychain에 저장됩니다.
* **지원되는 인증 유형**: Claude.ai 자격증명, Claude API 자격증명, Azure Auth, Bedrock Auth, Vertex Auth.
* **사용자 정의 자격증명 스크립트**: [`apiKeyHelper`](/ko/settings#available-settings) 설정을 구성하여 API 키를 반환하는 셸 스크립트를 실행할 수 있습니다.
* **새로고침 간격**: 기본적으로 `apiKeyHelper`는 5분 후 또는 HTTP 401 응답 시 호출됩니다. 사용자 정의 새로고침 간격을 위해 `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` 환경 변수를 설정합니다.
