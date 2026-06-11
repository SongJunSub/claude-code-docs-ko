> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# GitHub Enterprise Server와 Claude Code

> 자체 호스팅되는 GitHub Enterprise Server 인스턴스에 Claude Code를 연결하여 웹 세션, 코드 리뷰 및 플러그인 마켓플레이스를 사용합니다.

<Note>
  GitHub Enterprise Server 지원은 Team 및 Enterprise 플랜에서 사용 가능합니다.
</Note>

GitHub Enterprise Server(GHES) 지원을 통해 조직은 github.com 대신 자체 관리되는 GitHub 인스턴스에 호스팅된 저장소와 함께 Claude Code를 사용할 수 있습니다. 관리자가 GHES 인스턴스를 연결하면 개발자는 저장소별 구성 없이 웹 세션을 실행하고, 자동화된 코드 리뷰를 받으며, 내부 마켓플레이스에서 플러그인을 설치할 수 있습니다.

github.com의 저장소의 경우 [웹에서 Claude Code](/ko/claude-code-on-the-web) 및 [코드 리뷰](/ko/code-review)를 참조하십시오. 자신의 CI 인프라에서 Claude를 실행하려면 [GitHub Actions](/ko/github-actions)를 참조하십시오.

<h2 id="what-works-with-github-enterprise-server">
  GitHub Enterprise Server에서 작동하는 기능
</h2>

아래 표는 Claude Code의 어떤 기능이 GHES를 지원하는지 및 github.com 동작과의 차이점을 보여줍니다.

| 기능              | GHES 지원   | 참고                                                                                                      |
| :-------------- | :-------- | :------------------------------------------------------------------------------------------------------ |
| 웹에서 Claude Code | ✅ 지원됨     | 관리자가 GHES 인스턴스를 한 번 연결하면 개발자는 평소처럼 `claude --remote` 또는 [claude.ai/code](https://claude.ai/code)를 사용합니다 |
| 코드 리뷰           | ✅ 지원됨     | github.com과 동일한 자동화된 PR 리뷰                                                                              |
| Claude Security | ✅ 지원됨     | Enterprise 플랜의 공개 베타에서 [claude.ai/security](https://claude.ai/security)에서 사용 가능                         |
| Teleport 세션     | ✅ 지원됨     | `--teleport`를 사용하여 웹과 터미널 간에 세션 이동                                                                      |
| 플러그인 마켓플레이스     | ✅ 지원됨     | `owner/repo` 단축형 대신 전체 git URL 사용                                                                       |
| 기여도 메트릭         | ✅ 지원됨     | [분석 대시보드](/ko/analytics)로 웹훅을 통해 전달됨                                                                    |
| GitHub Actions  | ✅ 지원됨     | 수동 워크플로우 설정 필요; `/install-github-app`은 github.com 전용                                                    |
| GitHub MCP 서버   | ❌ 지원되지 않음 | GitHub MCP 서버는 GHES 인스턴스와 작동하지 않습니다                                                                     |

<h2 id="admin-setup">
  관리자 설정
</h2>

관리자가 GHES 인스턴스를 Claude Code에 한 번 연결합니다. 그 후 조직의 개발자는 추가 구성 없이 GHES 저장소를 사용할 수 있습니다. Claude 조직에 대한 관리자 액세스 권한과 GHES 인스턴스에서 GitHub App을 만들 수 있는 권한이 필요합니다.

안내식 설정은 GitHub App 매니페스트를 생성하고 한 번의 클릭으로 앱을 만들기 위해 GHES 인스턴스로 리디렉션합니다. 환경이 리디렉션 흐름을 차단하는 경우 [대체 수동 설정](#manual-setup)을 사용할 수 있습니다.

<Steps>
  <Step title="Claude Code 관리자 설정 열기">
    [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code)로 이동하여 GitHub Enterprise Server 섹션을 찾습니다.
  </Step>

  <Step title="안내식 설정 시작">
    **연결**을 클릭합니다. 연결의 표시 이름과 GHES 호스트명(예: `github.example.com`)을 입력합니다. GHES 인스턴스가 자체 서명 또는 개인 인증 기관 인증서를 사용하는 경우 선택적 필드에 CA 인증서를 붙여넣습니다.
  </Step>

  <Step title="GitHub App 만들기">
    **GitHub Enterprise로 계속**을 클릭합니다. 브라우저가 미리 채워진 앱 매니페스트와 함께 GHES 인스턴스로 리디렉션됩니다. 구성을 검토하고 **GitHub App 만들기**를 클릭합니다. GHES가 앱 자격 증명이 자동으로 저장된 상태로 Claude로 리디렉션합니다.
  </Step>

  <Step title="저장소에 앱 설치">
    GHES 인스턴스의 GitHub App 페이지에서 Claude가 액세스하기를 원하는 저장소 또는 조직에 앱을 설치합니다. 부분 집합으로 시작하여 나중에 더 추가할 수 있습니다.
  </Step>

  <Step title="기능 활성화">
    [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code)로 돌아가서 github.com과 동일한 구성을 사용하여 GHES 저장소에 대해 [코드 리뷰](/ko/code-review#set-up-code-review), Claude Security 및 [기여도 메트릭](/ko/analytics#enable-contribution-metrics)을 활성화합니다.
  </Step>
</Steps>

<h3 id="github-app-permissions">
  GitHub App 권한
</h3>

매니페스트는 웹 세션, 코드 리뷰, Claude Security 및 기여도 메트릭 전반에 걸쳐 Claude가 필요로 하는 권한 및 웹훅 이벤트로 GitHub App을 구성합니다:

| 권한               | 액세스     | 사용 목적              |
| :--------------- | :------ | :----------------- |
| Contents         | 읽기 및 쓰기 | 저장소 복제 및 분기 푸시     |
| Pull requests    | 읽기 및 쓰기 | PR 생성 및 리뷰 의견 게시   |
| Issues           | 읽기 및 쓰기 | 문제 언급에 응답          |
| Checks           | 읽기 및 쓰기 | 코드 리뷰 확인 실행 게시     |
| Actions          | 읽기      | 자동 수정을 위한 CI 상태 읽기 |
| Repository hooks | 읽기 및 쓰기 | 기여도 메트릭을 위한 웹훅 수신  |
| Metadata         | 읽기      | 모든 앱에 GitHub에서 필요  |

앱은 `pull_request`, `issue_comment`, `pull_request_review_comment`, `pull_request_review` 및 `check_run` 이벤트를 구독합니다.

<h3 id="manual-setup">
  수동 설정
</h3>

안내식 리디렉션 흐름이 네트워크 구성에 의해 차단되는 경우 연결 대신 **수동으로 추가**를 클릭합니다. [위의 권한 및 이벤트](#github-app-permissions)를 사용하여 GHES 인스턴스에서 GitHub App을 만든 다음 앱 자격 증명을 양식에 입력합니다: 호스트명, OAuth 클라이언트 ID 및 비밀, GitHub App ID, 클라이언트 ID, 클라이언트 비밀, 웹훅 비밀 및 개인 키.

<h3 id="network-requirements">
  네트워크 요구 사항
</h3>

GHES 인스턴스는 Claude가 저장소를 복제하고 리뷰 의견을 게시할 수 있도록 Anthropic 인프라에서 도달 가능해야 합니다. GHES 인스턴스가 방화벽 뒤에 있는 경우 [Anthropic API IP 주소](https://platform.claude.com/docs/en/api/ip-addresses)를 허용 목록에 추가합니다.

<h2 id="developer-workflow">
  개발자 워크플로우
</h2>

관리자가 GHES 인스턴스를 연결하면 개발자 측 구성이 필요하지 않습니다. Claude Code는 작업 디렉토리의 git 원격에서 GHES 호스트명을 자동으로 감지합니다.

평소처럼 GHES 인스턴스에서 저장소를 복제합니다:

```bash theme={null}
git clone git@github.example.com:platform/api-service.git
cd api-service
```

그런 다음 웹 세션을 시작합니다. Claude는 git 원격에서 GHES 호스트를 감지하고 세션을 조직의 구성된 인스턴스를 통해 라우팅합니다:

```bash theme={null}
claude --remote "Add retry logic to the payment webhook handler"
```

세션은 Anthropic 인프라에서 실행되고, GHES에서 저장소를 복제하며, 변경 사항을 분기로 다시 푸시합니다. `/tasks`를 사용하거나 [claude.ai/code](https://claude.ai/code)에서 진행 상황을 모니터링합니다. diff 리뷰, 자동 수정 및 루틴을 포함한 전체 원격 세션 워크플로우는 [웹에서 Claude Code](/ko/claude-code-on-the-web)를 참조하십시오.

<h3 id="teleport-sessions-to-your-terminal">
  세션을 터미널로 Teleport
</h3>

`claude --teleport`를 사용하여 웹 세션을 로컬 터미널로 가져옵니다. Teleport는 분기를 가져오고 세션 기록을 로드하기 전에 동일한 GHES 저장소의 체크아웃에 있는지 확인합니다. 자세한 내용은 [teleport 요구 사항](/ko/claude-code-on-the-web#teleport-requirements)을 참조하십시오.

<h2 id="plugin-marketplaces-on-ghes">
  GHES의 플러그인 마켓플레이스
</h2>

조직 전체에 내부 도구를 배포하기 위해 GHES 인스턴스에서 플러그인 마켓플레이스를 호스팅합니다. 마켓플레이스 구조는 github.com 호스팅 마켓플레이스와 동일합니다. 유일한 차이점은 이를 참조하는 방식입니다.

<h3 id="add-a-ghes-marketplace">
  GHES 마켓플레이스 추가
</h3>

`owner/repo` 단축형은 항상 github.com으로 확인됩니다. GHES 호스팅 마켓플레이스의 경우 전체 git URL을 사용합니다:

```bash theme={null}
/plugin marketplace add git@github.example.com:platform/claude-plugins.git
```

HTTPS URL도 작동합니다:

```bash theme={null}
/plugin marketplace add https://github.example.com/platform/claude-plugins.git
```

마켓플레이스 구축에 대한 전체 가이드는 [플러그인 마켓플레이스 만들기 및 배포](/ko/plugin-marketplaces)를 참조하십시오.

<h3 id="allowlist-ghes-marketplaces-in-managed-settings">
  관리되는 설정에서 GHES 마켓플레이스 허용 목록
</h3>

조직이 [관리되는 설정](/ko/settings)을 사용하여 개발자가 추가할 수 있는 마켓플레이스를 제한하는 경우 `hostPattern` 소스 유형을 사용하여 각 저장소를 열거하지 않고 GHES 인스턴스의 모든 마켓플레이스를 허용합니다:

```json theme={null}
{
  "strictKnownMarketplaces": [
    {
      "source": "hostPattern",
      "hostPattern": "^github\\.example\\.com$"
    }
  ]
}
```

개발자를 위해 마켓플레이스를 미리 등록하여 수동 설정 없이 표시되도록 할 수도 있습니다. 이 예제는 내부 도구 마켓플레이스를 조직 전체에서 사용 가능하게 만듭니다:

```json theme={null}
{
  "extraKnownMarketplaces": {
    "internal-tools": {
      "source": {
        "source": "git",
        "url": "git@github.example.com:platform/claude-plugins.git"
      }
    }
  }
}
```

전체 스키마는 [strictKnownMarketplaces](/ko/settings#strictknownmarketplaces) 및 [extraKnownMarketplaces](/ko/settings#extraknownmarketplaces) 설정 참조를 참조하십시오.

<h2 id="limitations">
  제한 사항
</h2>

몇 가지 기능은 GHES에서 github.com과 다르게 동작합니다. [기능 표](#what-works-with-github-enterprise-server)는 지원을 요약합니다. 이 섹션에서는 해결 방법을 다룹니다.

* **`/install-github-app` 명령**: claude.ai에서 [관리자 설정](#admin-setup) 흐름을 따릅니다. GHES에서 GitHub Actions 워크플로우도 원하는 경우 [예제 워크플로우](https://github.com/anthropics/claude-code-action/blob/main/examples/claude.yml)를 수동으로 조정합니다.
* **GitHub MCP 서버**: 대신 GHES 호스트에 대해 구성된 `gh` CLI를 사용합니다. `gh auth login --hostname github.example.com`을 실행하여 인증한 다음 Claude는 세션에서 `gh` 명령을 사용할 수 있습니다.

<h2 id="troubleshooting">
  문제 해결
</h2>

<h3 id="web-session-fails-to-clone-repository">
  웹 세션이 저장소 복제에 실패함
</h3>

`claude --remote`가 복제 오류로 실패하면 관리자가 GHES 인스턴스에 대한 설정을 완료했는지 확인하고 GitHub App이 작업 중인 저장소에 설치되어 있는지 확인합니다. 관리자에게 Claude 설정에 등록된 인스턴스 호스트명이 git 원격의 호스트명과 일치하는지 확인하도록 요청합니다.

<h3 id="marketplace-add-fails-with-a-policy-error">
  마켓플레이스 추가가 정책 오류로 실패함
</h3>

GHES URL에 대해 `/plugin marketplace add`가 차단되면 조직이 마켓플레이스 소스를 제한했습니다. 관리자에게 [관리되는 설정](#allowlist-ghes-marketplaces-in-managed-settings)에서 GHES 호스트명에 대한 `hostPattern` 항목을 추가하도록 요청합니다.

<h3 id="ghes-instance-not-reachable">
  GHES 인스턴스에 도달할 수 없음
</h3>

리뷰 또는 웹 세션이 시간 초과되면 GHES 인스턴스가 Anthropic 인프라에서 도달 가능하지 않을 수 있습니다. 방화벽이 [Anthropic API IP 주소](https://platform.claude.com/docs/en/api/ip-addresses)에서 인바운드 연결을 허용하는지 확인합니다.

<h2 id="related-resources">
  관련 리소스
</h2>

이 페이지들은 이 가이드 전체에서 참조된 기능을 더 자세히 다룹니다:

* [웹에서 Claude Code](/ko/claude-code-on-the-web): 클라우드 인프라에서 Claude Code 세션 실행
* [코드 리뷰](/ko/code-review): 자동화된 PR 리뷰
* [플러그인 마켓플레이스](/ko/plugin-marketplaces): 플러그인 카탈로그 구축 및 배포
* [분석](/ko/analytics): 사용량 및 기여도 메트릭 추적
* [관리되는 설정](/ko/settings): 조직 전체 정책 구성
* [네트워크 구성](/ko/network-config): 방화벽 및 IP 허용 목록 요구 사항
