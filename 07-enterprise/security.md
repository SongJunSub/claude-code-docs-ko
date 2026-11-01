> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 보안

> Claude Code의 보안 보호 기능과 안전한 사용을 위한 모범 사례에 대해 알아봅니다.

## 보안에 대한 우리의 접근 방식

### 보안 기초

코드의 보안은 매우 중요합니다. Claude Code는 보안을 핵심으로 구축되었으며, Anthropic의 포괄적인 보안 프로그램에 따라 개발되었습니다. [Anthropic Trust Center](https://trust.anthropic.com)에서 자세히 알아보고 리소스(SOC 2 Type 2 보고서, ISO 27001 인증서 등)에 접근할 수 있습니다.

### 권한 기반 아키텍처

세션의 권한 모드는 Claude가 사용자에게 먼저 묻지 않고 수행할 수 있는 작업을 결정합니다. 자동 모드는 대화형 터미널 및 VS Code 세션의 기본 제공 시작 권한 모드입니다. [세션이 시작되는 모드](https://code.claude.com/docs/ko/permission-modes.md#which-mode-a-session-starts-in)에서는 이전 버전, 다른 사용 환경, 그리고 시작 권한 모드를 변경하는 설정을 다룹니다.

* **자동 모드**: 별도의 분류기 모델이 사용자 대신 작업을 검토하고 안전하지 않다고 판단하는 작업을 차단합니다. [분류기가 작업을 평가하는 방식](https://code.claude.com/docs/ko/permission-modes.md#how-the-classifier-evaluates-actions)에서는 Claude Code가 직접 승인하는 작업, 분류기로 보내는 작업, 그리고 여전히 사용자에게 묻는 작업을 나열합니다. 명시적 요청 및 거부 규칙은 여전히 적용되며, 조직은 [자동 모드를 끌 수 있습니다](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)
* **Manual 모드**: Claude Code는 읽기 전용 권한으로 시작합니다. 파일을 편집하거나, 테스트를 실행하거나, 명령을 실행해야 할 때 먼저 사용자에게 묻고, 사용자는 작업을 한 번만 승인할지 또는 그 이후로 계속 허용할지 선택합니다. `ls`, `cat`, `git status`와 같은 기본 제공 [읽기 전용 명령](https://code.claude.com/docs/ko/permissions.md#read-only-commands) 집합은 묻지 않고 실행합니다

사용자와 조직은 이러한 권한을 직접 구성합니다. 자세한 권한 구성은 [Permissions](https://code.claude.com/docs/ko/permissions.md)를 참조하십시오.

### 기본 제공 보호

에이전트 시스템의 위험을 완화하기 위해:

* **샌드박스 bash 도구**: [Sandbox](https://code.claude.com/docs/ko/sandboxing.md) bash 명령을 파일 시스템 및 네트워크 격리로 실행하여 권한 프롬프트를 줄이면서 보안을 유지합니다. `/sandbox`를 사용하여 Claude Code가 자율적으로 작업할 수 있는 경계를 정의하도록 구성합니다.
* **작업 디렉터리 경계**: Manual 모드에서 Claude Code는 파일 도구가 시작된 폴더와 그 하위 폴더 외부를 읽거나 쓰기 전에 사용자에게 묻습니다. 이 경계는 권한 프롬프트이므로, 사용자가 승인한 Bash 명령은 여전히 사용자 계정이 쓸 수 있는 모든 위치에 쓸 수 있습니다
  * 프롬프트 없이 폴더를 읽으려면 [추가 디렉터리](https://code.claude.com/docs/ko/permissions.md#working-directories)로 추가합니다
  * 운영 체제 수준에서 Bash 명령을 제한하려면 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md#filesystem-isolation)을 켭니다
* **프롬프트 피로 완화**: 사용자별, 코드베이스별 또는 조직별로 자주 사용되는 안전한 명령을 허용 목록에 추가하는 지원
* **Accept Edits 모드**: 파일 편집을 자동으로 승인하고 작업 디렉토리의 경로에 대해 `mkdir`, `touch`, `rm`, `mv`, `cp`, `sed`와 같은 고정된 파일 시스템 Bash 명령 집합을 자동으로 승인합니다. 다른 Bash 명령과 범위를 벗어난 경로는 여전히 프롬프트를 표시합니다.

### 사용자 책임

사용자는 승인 전에 제안된 코드와 명령의 안전성을 검토할 책임이 있습니다.

## 프롬프트 주입으로부터 보호

프롬프트 주입은 공격자가 악의적인 텍스트를 삽입하여 AI 어시스턴트의 지시사항을 무시하거나 조작하려는 기법입니다. Claude Code는 이러한 공격에 대한 여러 보호 기능을 포함합니다:

### 핵심 보호

* **권한 시스템**: Manual 모드에서는 민감한 작업에 명시적 승인이 필요합니다.
* **네트워크 명령 승인**: `curl` 및 `wget`과 같이 웹에서 콘텐츠를 가져오는 명령은 기본적으로 자동 승인되지 않습니다. Manual 모드에서는 다른 읽기 전용이 아닌 Bash 명령처럼 프롬프트가 표시되므로 한 번 승인하거나 `Bash(curl *)`와 같은 명시적 허용 규칙을 추가할 수 있습니다. Claude가 이를 실행하지 못하도록 하려면 [`permissions.deny`](https://code.claude.com/docs/ko/permissions#tool-specific-permission-rules)에 추가하십시오. deny 규칙은 [작성된 대로](https://code.claude.com/docs/ko/permissions.md#bash-rule-limits) 명령과 일치합니다. 명령 텍스트에 의존하지 않는 네트워크 적용의 경우 [샌드박스 네트워크 격리](https://code.claude.com/docs/ko/sandboxing.md#network-isolation)를 참조하십시오.

### 개인정보 보호 장치

데이터를 보호하기 위해 다음을 포함한 여러 보호 기능을 구현했습니다:

* 민감한 정보에 대한 제한된 보관 기간([Privacy Center](https://privacy.anthropic.com/en/articles/10023548-how-long-do-you-store-my-data)에서 자세히 알아보기)
* 사용자 세션 데이터에 대한 제한된 액세스
* 데이터 학습 기본 설정에 대한 사용자 제어. 소비자 사용자는 언제든지 [개인정보 보호 설정](https://claude.ai/settings/privacy)을 변경할 수 있습니다.

전체 세부 사항은 [Commercial Terms of Service](https://www.anthropic.com/legal/commercial-terms)(Team, Enterprise 및 API 사용자용) 또는 [Consumer Terms](https://www.anthropic.com/legal/consumer-terms)(Free, Pro, Max 및 Ultra 사용자용) 및 [Privacy Policy](https://www.anthropic.com/legal/privacy)를 검토하십시오.

### 추가 보호 기능

* **네트워크 요청 승인**: Manual 모드에서는 네트워크 요청을 하는 대부분의 도구가 기본적으로 사용자 승인이 필요합니다.
* **웹 페이지 요약**: 대부분의 가져오기에서 WebFetch는 페이지에 대해 별도의 모델 호출을 실행하며, Claude는 원시 페이지 대신 해당 호출의 응답을 받습니다. [WebFetch 도구 동작](https://code.claude.com/docs/ko/tools-reference.md#webfetch-tool-behavior)을 참조하십시오.
* **신뢰 확인**: 대화형 세션에서 Claude Code는 신뢰하지 않은 폴더에서 시작할 때 워크스페이스 신뢰 대화 상자를 표시합니다. 프로젝트의 `.mcp.json`에 있는 서버에는 별도의 승인 프롬프트가 있으며, [프로젝트 범위](https://code.claude.com/docs/ko/mcp.md#project-scope)에 이를 건너뛰는 세션이 나와 있습니다.
  * 참고: `-p` 세션에서는 두 프롬프트 모두 표시되지 않습니다. [폴더를 신뢰하기 전에 실행되는 항목](https://code.claude.com/docs/ko/permissions.md#what-runs-before-you-trust-a-folder)에 해당 환경에서 저장소의 파일이 실행할 수 있는 항목이 나와 있습니다.
  * 참고: Claude Code를 홈 디렉터리에서 직접 시작할 때 신뢰 수락은 현재 세션에만 유지되며 디스크에 기록되지 않으므로 각 시작 시 프롬프트가 다시 나타납니다. 이를 유지하는 설정은 없습니다. 신뢰 수락이 디렉터리별로 저장되는 프로젝트 하위 디렉터리에서 Claude Code를 시작하십시오.
* **명령 인젝션 감지**: Manual 모드에서 Claude Code는 완전히 분석할 수 없는 Bash 명령을 실행하기 전에 확인을 요청합니다. `Bash(git *)`와 같이 명령의 일부에 대한 허용 규칙으로는 이 프롬프트를 건너뛸 수 없습니다. [샌드박스된 명령](https://code.claude.com/docs/ko/permissions.md#how-permissions-interact-with-sandboxing)은 이 프롬프트 없이 실행될 수 있습니다.
* **폐쇄형 매칭 실패**: Manual 모드에서는 일치하지 않는 명령은 기본적으로 수동 승인이 필요합니다.
* **안전한 자격 증명 저장**: API 키와 토큰은 사용 가능한 경우 macOS Keychain에 저장됩니다. Linux에서는 모드 `0600`의 파일에 저장되며, Windows에서는 사용자 프로필 디렉터리의 액세스 제어를 상속하는 파일에 저장됩니다. [자격 증명 관리](https://code.claude.com/docs/ko/authentication.md#credential-management)를 참조하십시오.

> [!WARNING]
>
> **Windows WebDAV 보안 위험**: Windows에서 Claude Code를 실행할 때 WebDAV를 활성화하거나 Claude Code가 WebDAV 하위 디렉토리를 포함할 수 있는 `\\*`와 같은 경로에 액세스하도록 허용하지 않는 것이 좋습니다. [WebDAV는 Microsoft에서 보안 위험으로 인해 더 이상 사용되지 않습니다](https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features#:~:text=The%20Webclient%20\(WebDAV\)%20service%20is%20deprecated). WebDAV를 활성화하면 Claude Code가 원격 호스트에 대한 네트워크 요청을 트리거하여 권한 시스템을 우회할 수 있습니다.

**신뢰할 수 없는 콘텐츠로 작업하기 위한 모범 사례**:

1. 승인 전에 제안된 명령 검토
2. 신뢰할 수 없는 콘텐츠를 Claude에 직접 파이프하지 않기
3. 중요한 파일에 대한 제안된 변경 사항 확인
4. 가상 머신(VM)을 사용하여 스크립트를 실행하고 도구 호출을 수행합니다. 특히 외부 웹 서비스와 상호 작용할 때
5. `/feedback`을 사용하여 의심스러운 동작 보고

> [!WARNING]
>
> 이러한 보호 기능이 위험을 크게 줄이지만, 모든 공격에 완전히 면역인 시스템은 없습니다. 모든 AI 도구로 작업할 때 항상 좋은 보안 관행을 유지하십시오.

## MCP 보안

Claude Code를 Model Context Protocol(MCP) 서버에 연결할 수 있습니다. 프로젝트 범위 서버는 `.mcp.json`에 정의되며, 이 파일은 소스 제어에 체크인할 수 있습니다. [다른 범위](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes)의 서버와 [claude.ai 커넥터](https://code.claude.com/docs/ko/mcp.md#how-connectors-reach-claude-code)는 저장소 외부에서 구성되고, 플러그인도 서버를 추가할 수 있으므로 `.mcp.json`을 검토하는 것만으로는 세션이 로드할 수 있는 모든 서버를 확인할 수 없습니다. 조직에서 실행되는 서버를 제한하려면 [관리형 MCP 구성](https://code.claude.com/docs/ko/managed-mcp.md)을 참조하세요.

자신의 MCP 서버를 작성하거나 신뢰하는 제공자의 MCP 서버를 사용할 것을 권장합니다. Claude Code 권한을 MCP 서버에 대해 구성할 수 있습니다. Anthropic은 커넥터를 [나열 기준](https://claude.com/docs/connectors/building/review-criteria)에 따라 검토한 후 [Anthropic 디렉토리](https://claude.ai/directory)에 추가하지만, MCP 서버에 대한 보안 감사를 수행하거나 관리하지 않습니다.

## IDE 보안

IDE에서 Claude Code를 실행하는 방법에 대한 자세한 내용은 [기본 제공 IDE MCP 서버](https://code.claude.com/docs/ko/vs-code.md#the-built-in-ide-mcp-server)를 참조하십시오.

## 클라우드 실행 보안

[웹에서 Claude Code](https://code.claude.com/docs/ko/claude-code-on-the-web.md)를 사용할 때 추가 보안 제어가 적용됩니다. 조직이 [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)으로 라우팅하는 세션은 사용자의 자체 인프라에서 실행되며, 격리, 네트워크 송신 및 git 자격증명은 배포의 책임입니다. Anthropic 호스팅 환경에서는:

* **격리된 가상 머신**: 각 클라우드 세션은 격리된 Anthropic 관리 VM에서 실행됩니다
* **네트워크 액세스 제어**: 네트워크 액세스는 기본적으로 제한되며 비활성화되거나 특정 도메인만 허용하도록 구성할 수 있습니다
* **자격증명 보호**: GitHub 자격증명은 Anthropic의 서버에 암호화되어 저장되며 세션 VM에 절대 입력되지 않습니다. VM은 해당 세션으로 범위가 지정된 단기 자격증명을 보유하며, GitHub 트래픽은 서버 측에서 GitHub 자격증명을 첨부하는 [Anthropic 프록시](https://code.claude.com/docs/ko/cloud-environments.md#github-proxy)를 통해 이동합니다. 액세스를 부여하는 방법은 [GitHub 인증 옵션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#github-authentication-options)을 참조하십시오
* **푸시 제한**: [GitHub 프록시](https://code.claude.com/docs/ko/cloud-environments.md#github-proxy)는 브랜치 삭제 및 태그와 같이 브랜치가 아닌 항목의 푸시를 거부합니다. GitHub는 연결된 GitHub 액세스에 저장소의 브랜치 보호 규칙과 규칙 세트를 적용하여 세션이 업데이트할 수 있는 브랜치를 결정합니다. 해당 액세스가 우회할 수 있는 규칙은 세션의 푸시를 차단하지 않습니다
* **감사 로깅**: 클라우드 세션의 모든 작업은 규정 준수 및 감사 목적으로 기록됩니다
* **자동 정리**: 세션 VM은 일정 기간의 비활성 후 회수됩니다
* **삭제**: [언제든지 세션을 삭제](https://code.claude.com/docs/ko/claude-code-on-the-web.md#delete-sessions)할 수 있습니다. 클라우드 세션에 대해 Anthropic이 저장하는 내용은 [클라우드 실행 데이터 흐름](https://code.claude.com/docs/ko/data-usage.md#cloud-execution-data-flow-and-dependencies)을 참조하십시오

클라우드 실행에 대한 자세한 내용은 [클라우드에서 Claude Code 사용](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 참조하십시오. 클라우드 세션의 네트워크 액세스를 구성하려면 [클라우드 환경 구성](https://code.claude.com/docs/ko/cloud-environments.md#network-access)을 참조하십시오.

[Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션은 다르게 작동합니다: 웹 인터페이스는 로컬 머신에서 실행 중인 Claude Code 프로세스에 연결됩니다. 모든 코드 실행 및 파일 액세스는 로컬에 유지되며, 세션 트래픽은 TLS를 통해 Anthropic API를 통해 이동합니다. 연결되어 있는 동안 세션 트랜스크립트는 [연결 및 보안](https://code.claude.com/docs/ko/remote-control.md#connection-and-security)에 설명된 대로 디바이스 간 대화를 동기화하기 위해 Anthropic 서버에 저장됩니다. 클라우드 VM 또는 샌드박싱이 관련되지 않습니다. 연결은 각각 특정 목적으로 제한되고 독립적으로 만료되는 여러 단기 범위 자격증명을 사용하여 손상된 단일 자격증명의 영향 범위를 제한합니다.

## 보안 모범 사례

### 민감한 코드로 작업

* 승인 전에 제안된 모든 변경 사항 검토
* 민감한 저장소에 프로젝트별 권한 설정 사용
* 추가 격리를 위해 Claude Code(로컬 모드) 프로세스 전체를 [샌드박스 런타임](https://code.claude.com/docs/ko/sandbox-environments.md#sandbox-runtime) 또는 [dev container](https://code.claude.com/docs/ko/devcontainer.md) 내에서 실행
* `/permissions`를 사용하여 권한 설정을 정기적으로 감사합니다

### 팀 보안

* [managed settings](https://code.claude.com/docs/ko/settings.md#where-settings-live)를 사용하여 조직 표준 적용
* 버전 제어를 통해 승인된 권한 구성 공유
* 팀 구성원에게 보안 모범 사례 교육
* [OpenTelemetry metrics](https://code.claude.com/docs/ko/monitoring-usage.md)를 통해 Claude Code 사용 모니터링
* [`ConfigChange` hooks](https://code.claude.com/docs/ko/hooks#configchange)를 사용하여 세션 중 설정 변경 감사 또는 차단

### 보안 문제 보고

Claude Code에서 보안 취약점을 발견한 경우:

1. 공개적으로 공개하지 마십시오
2. [HackerOne 프로그램](https://hackerone.com/4f1f16ba-10d3-4d09-9ecc-c721aad90f24/embedded_submissions/new)을 통해 보고합니다
3. 자세한 재현 단계 포함
4. 공개 공개 전에 문제를 해결할 시간을 허용합니다

## 관련 리소스

* [Security guidance plugin](https://code.claude.com/docs/ko/security-guidance.md): Claude가 세션 중에 자신의 코드 변경 사항에서 취약점을 검토하고 수정하도록 합니다
* [`/security-review`](https://code.claude.com/docs/ko/commands#all-commands): 현재 브랜치의 변경 사항에 대해 온디맨드 보안 검사를 실행합니다
* [Sandbox 환경](https://code.claude.com/docs/ko/sandbox-environments.md): 격리 접근 방식을 비교하고 위협 모델에 맞는 방식을 선택합니다
* [Sandboxing](https://code.claude.com/docs/ko/sandboxing.md): Bash 명령에 대한 파일 시스템 및 네트워크 격리
* [Permissions](https://code.claude.com/docs/ko/permissions.md): 권한 및 액세스 제어를 구성합니다
* [Monitoring usage](https://code.claude.com/docs/ko/monitoring-usage.md): Claude Code 활동을 추적하고 감사합니다
* [Development containers](https://code.claude.com/docs/ko/devcontainer.md): 보안, 격리된 환경
* [Anthropic Trust Center](https://trust.anthropic.com): 보안 인증 및 규정 준수
* [CISO's guide to agentic AI](https://claude.com/blog/ciso-guide-to-agentic-ai): 에이전트 AI 배포를 평가하기 위한 보안 리더의 프레임워크
