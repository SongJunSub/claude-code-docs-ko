> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 플랫폼 및 통합

> Claude Code를 실행할 위치를 선택하고 연결할 항목을 결정합니다. CLI, Desktop, VS Code, JetBrains, 웹, 모바일 및 Chrome, Slack, CI/CD와 같은 통합을 비교합니다.

Claude Code는 모든 곳에서 동일한 기본 엔진을 실행하지만, 각 플랫폼은 다양한 작업 방식에 맞게 조정됩니다. 이 페이지는 워크플로우에 적합한 플랫폼을 선택하고 이미 사용 중인 도구를 연결하는 데 도움을 줍니다.

## Claude Code를 실행할 위치

작업 방식과 프로젝트가 있는 위치에 따라 플랫폼을 선택합니다.

| 플랫폼 | 최적 용도 | 제공 기능 |
| :- | :- | :- |
| [CLI](https://code.claude.com/docs/ko/quickstart.md) | 터미널 워크플로, 스크립팅, 원격 서버 | 전체 기능 세트, [Agent SDK](https://code.claude.com/docs/ko/headless.md), macOS의 [컴퓨터 사용](https://code.claude.com/docs/ko/computer-use.md) (Pro, Max 및 Ultra), 타사 제공자 |
| [Desktop](https://code.claude.com/docs/ko/desktop.md) | 시각적 검토, 병렬 세션, 관리형 설정 | diff 뷰어, 앱 미리보기, Pro, Max 및 Ultra의 [컴퓨터 사용](https://code.claude.com/docs/ko/desktop.md#let-claude-use-your-computer) 및 [Dispatch](https://code.claude.com/docs/ko/desktop.md#sessions-from-dispatch) |
| [VS Code](https://code.claude.com/docs/ko/vs-code.md) | VS Code 내에서 터미널로 전환하지 않고 작업 | 인라인 Diff, 통합 터미널, 파일 컨텍스트 |
| [JetBrains](https://code.claude.com/docs/ko/jetbrains.md) | IntelliJ, PyCharm, WebStorm 또는 기타 JetBrains IDE 내에서 작업 | Diff 뷰어, 선택 공유, 터미널 세션 |
| [Web](https://code.claude.com/docs/ko/claude-code-on-the-web.md) | 많은 조작이 필요하지 않은 장기 실행 작업 또는 오프라인 상태에서도 계속되어야 하는 작업 | 클라우드, Anthropic 관리형(기본값); 연결 해제 후에도 계속 실행 |
| [Mobile](https://code.claude.com/docs/ko/mobile.md) | 컴퓨터에서 멀리 떨어져 있을 때 작업 시작 및 모니터링 | iOS 및 Android용 Claude 앱의 클라우드 세션, 로컬 세션용 [Remote Control](https://code.claude.com/docs/ko/remote-control.md), Pro, Max 및 Ultra의 Desktop으로 [Dispatch](https://code.claude.com/docs/ko/desktop.md#sessions-from-dispatch) |

CLI는 터미널 기반 작업을 위한 가장 완전한 플랫폼입니다. 스크립팅 및 Agent SDK는 CLI 전용입니다. 타사 제공자는 [VS Code](https://code.claude.com/docs/ko/vs-code.md#use-third-party-providers)에서도 작동하며 [JetBrains](https://code.claude.com/docs/ko/feature-availability.md#features-available-on-every-provider)에서도 작동합니다. JetBrains는 IDE의 터미널에서 CLI를 실행합니다. Enterprise [Desktop](https://code.claude.com/docs/ko/desktop.md) 배포는 Google Cloud의 Agent Platform을 지원하며, Desktop은 [게이트웨이 제공자](https://code.claude.com/docs/ko/llm-gateway-connect.md#desktop-app)를 지원합니다. Amazon Bedrock 또는 Microsoft Foundry의 경우 CLI 또는 IDE 확장 프로그램을 사용하거나, 해당 제공자에서 Code 탭을 실행하는 [Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview)를 사용합니다. Desktop과 IDE 확장 프로그램은 일부 CLI 전용 기능을 포기하는 대신 시각적 검토와 더 긴밀한 편집기 통합을 제공합니다. 웹은 클라우드에서 실행되므로 연결을 해제한 후에도 작업이 계속됩니다. Mobile은 동일한 클라우드 세션으로의 씬 클라이언트이거나 Remote Control을 통한 로컬 세션으로의 씬 클라이언트이며, Dispatch를 통해 Desktop으로 작업을 보낼 수 있습니다.

동일한 프로젝트에서 여러 플랫폼을 혼합하여 사용할 수 있습니다. 구성, 프로젝트 메모리 및 MCP 서버는 로컬 플랫폼 간에 공유됩니다.

## 도구 연결

통합을 통해 Claude는 코드베이스 외부의 서비스와 작업할 수 있습니다.

| 통합 | 기능 | 사용 용도 |
| :- | :- | :- |
| [Chrome](https://code.claude.com/docs/ko/chrome.md) | 로그인된 세션으로 브라우저를 제어합니다 | 웹 앱 테스트, 양식 작성, API 없이 사이트 자동화 |
| [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md) | CI 파이프라인에서 Claude를 실행합니다 | 자동화된 PR 검토, 이슈 분류, 예약된 유지보수 |
| [GitLab CI/CD](https://code.claude.com/docs/ko/gitlab-ci-cd.md) | GitHub Actions와 동일하지만 GitLab용입니다 | GitLab의 CI 기반 자동화 |
| [Code Review](https://code.claude.com/docs/ko/code-review.md) | 모든 PR을 자동으로 검토합니다 | 인간 검토 전에 버그 포착 |
| [Slack](https://code.claude.com/docs/ko/slack.md) | 사용자 본인의 계정으로 채널의 `@Claude` 멘션에 응답합니다 | Pro, Max 및 Ultra 플랜에서 팀 채팅의 버그 보고를 풀 리퀘스트로 변환 |
| [Claude Tag](https://claude.com/docs/claude-tag) | 관리자가 구성한 액세스 권한으로 조직의 공유 ID로 `@Claude`를 실행합니다 | Team 및 Enterprise 플랜에서 사용자별 Slack 세션 대신 공유 팀 액세스 |

여기에 나열되지 않은 통합의 경우, [MCP 서버](https://code.claude.com/docs/ko/mcp.md) 및 [커넥터](https://code.claude.com/docs/ko/desktop.md#connect-external-tools)를 사용하면 거의 모든 것을 연결할 수 있습니다. Linear, Notion, Google Drive 또는 자체 내부 API입니다.

## 터미널에서 멀리 떨어져 있을 때 작업

Claude Code는 터미널에 있지 않을 때 작업할 수 있는 여러 방법을 제공합니다. 이들은 작업을 트리거하는 것, Claude가 실행되는 위치, 그리고 설정해야 할 양이 다릅니다.

| | 트리거 | Claude 실행 위치 | 설정 | 최적 용도 |
| :- | :- | :- | :- | :- |
| [Dispatch](https://code.claude.com/docs/ko/desktop.md#sessions-from-dispatch) | Claude 모바일 앱에서 작업 메시지 전송 | 사용자 머신 (Desktop) | [모바일 앱을 Desktop과 페어링](https://support.claude.com/en/articles/13947068) | 외출 중 작업 위임, 최소 설정 |
| [Remote Control](https://code.claude.com/docs/ko/remote-control.md) | [claude.ai/code](https://claude.ai/code) 또는 Claude 모바일 앱에서 실행 중인 세션 제어 | 사용자 머신 (CLI, Desktop, 또는 VS Code) | [`claude remote-control` 또는 `/remote-control` 실행](https://code.claude.com/docs/ko/remote-control#start-a-remote-control-session) | 다른 기기에서 진행 중인 작업 조종 |
| [Channels](https://code.claude.com/docs/ko/channels.md) | Telegram 또는 Discord와 같은 채팅 앱이나 자체 서버에서 이벤트 푸시 | 사용자 머신 (CLI) | [채널 플러그인 설치](https://code.claude.com/docs/ko/channels.md#quickstart) 또는 [직접 구축](https://code.claude.com/docs/ko/channels-reference.md) | CI 실패 또는 채팅 메시지와 같은 외부 이벤트에 반응 |
| [Slack](https://code.claude.com/docs/ko/slack.md) | 팀 채널에서 `@Claude` 언급 | Anthropic 클라우드 | Pro, Max 및 Ultra 플랜에서 [Claude Code on the web](https://code.claude.com/docs/ko/claude-code-on-the-web.md)이 활성화된 상태로 [Slack 앱 설치](https://code.claude.com/docs/ko/slack.md#setting-up-claude-code-in-slack) | 팀 채팅에서 PR 및 리뷰 |
| [Self-hosted environments](https://code.claude.com/docs/ko/self-hosted-environments) | [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 시작하고 조직의 환경 선택 | 조직의 인프라 | [러너 배포](https://code.claude.com/docs/ko/self-hosted-environments-quickstart.md), Team 및 Enterprise 플랜 | 네트워크 내에서 실행해야 하는 클라우드 세션 |
| [Scheduled tasks](https://code.claude.com/docs/ko/scheduled-tasks.md) | 일정 설정 | [CLI](https://code.claude.com/docs/ko/scheduled-tasks.md), [Desktop](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md), 또는 [클라우드](https://code.claude.com/docs/ko/routines.md) | 빈도 선택 | 일일 검토와 같은 반복 자동화 |

시작할 위치가 확실하지 않으면 [CLI를 설치](https://code.claude.com/docs/ko/quickstart.md)하고 프로젝트 디렉토리에서 실행합니다. 터미널을 사용하지 않으려면 [Desktop](https://code.claude.com/docs/ko/desktop-quickstart.md)이 그래픽 인터페이스와 함께 동일한 엔진을 제공합니다.

## 관련 리소스

### 플랫폼

* [CLI 빠른 시작](https://code.claude.com/docs/ko/quickstart.md): 터미널에서 첫 번째 명령을 설치하고 실행합니다
* [Desktop](https://code.claude.com/docs/ko/desktop.md): 시각적 Diff 검토, 병렬 세션, 컴퓨터 사용 및 Dispatch
* [VS Code](https://code.claude.com/docs/ko/vs-code.md): 편집기 내 Claude Code 확장 프로그램
* [JetBrains](https://code.claude.com/docs/ko/jetbrains.md): IntelliJ, PyCharm 및 기타 JetBrains IDE용 확장 프로그램
* [웹](https://code.claude.com/docs/ko/claude-code-on-the-web.md): 연결 해제 후에도 계속 실행되는 claude.ai/code의 클라우드 세션
* [Projects](https://code.claude.com/docs/ko/claude-projects.md): Claude가 많은 클라우드 세션을 조정하고 작업 본문에 대해 보고하는 하나의 대화
* [Mobile](https://code.claude.com/docs/ko/mobile.md): [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) 및 [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude)용 Claude 앱으로 컴퓨터에서 멀리 떨어져 있을 때 작업 시작 및 모니터링

### 통합

* [Chrome](https://code.claude.com/docs/ko/chrome.md): 로그인된 세션으로 브라우저 작업 자동화
* [컴퓨터 사용](https://code.claude.com/docs/ko/computer-use.md): Claude가 macOS에서 앱을 열고 화면을 제어하도록 허용
* [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md): CI 파이프라인에서 Claude 실행
* [GitLab CI/CD](https://code.claude.com/docs/ko/gitlab-ci-cd.md): GitLab용 동일한 기능
* [Code Review](https://code.claude.com/docs/ko/code-review.md): 모든 풀 요청에 대한 자동 검토
* [Slack](https://code.claude.com/docs/ko/slack.md): Pro, Max 및 Ultra 플랜에서 팀 채팅으로 작업을 보내고 PR을 받습니다
* [Claude Tag](https://claude.com/docs/claude-tag): Team 및 Enterprise 플랜에서 조직의 공유 ID로 `@Claude`를 실행합니다

### 원격 액세스

* [Dispatch](https://code.claude.com/docs/ko/desktop.md#sessions-from-dispatch): 휴대폰에서 작업을 메시지로 보내면 Desktop 세션을 생성할 수 있습니다
* [Remote Control](https://code.claude.com/docs/ko/remote-control.md): 휴대폰 또는 브라우저에서 실행 중인 세션을 제어합니다
* [Channels](https://code.claude.com/docs/ko/channels.md): 채팅 앱 또는 자체 서버의 이벤트를 세션으로 푸시합니다
* [예약 옵션](https://code.claude.com/docs/ko/scheduled-tasks.md#compare-scheduling-options): 반복 일정에 따라 프롬프트를 실행합니다
