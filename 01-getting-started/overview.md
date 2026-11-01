> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 개요

> Claude Code는 코드베이스를 읽고, 파일을 편집하고, 명령을 실행하고, 개발 도구와 통합하는 에이전트 코딩 도구입니다. 터미널, IDE, 데스크톱 앱 및 브라우저에서 사용할 수 있습니다.

Claude Code는 기능을 구축하고, 버그를 수정하고, 개발 작업을 자동화하는 데 도움이 되는 AI 기반 코딩 어시스턴트입니다. 전체 코드베이스를 이해하고 여러 파일과 도구에 걸쳐 작업할 수 있습니다.

## 시작하기

Claude Code는 터미널, IDE 확장 프로그램, 데스크톱 앱 및 웹을 포함한 여러 환경에서 실행됩니다. 아래 탭에서 하나를 선택하여 시작하세요. 대부분의 환경에는 [Claude 구독](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=overview_pricing) 또는 [Anthropic Console](https://platform.claude.com/) 계정이 필요합니다. Terminal CLI, VS Code 및 JetBrains는 [타사 제공자](https://code.claude.com/docs/ko/third-party-integrations.md)도 지원합니다.

> [tab] Terminal
>
> 터미널에서 Claude Code로 직접 작업하기 위한 모든 기능을 갖춘 CLI입니다. 파일을 편집하고, 명령을 실행하고, 명령줄에서 전체 프로젝트를 관리할 수 있습니다.
>
> Claude Code를 설치하려면 터미널을 열고 시스템에 맞는 명령을 실행하십시오. 이전에 터미널을 사용해본 적이 없다면 [터미널 가이드](https://code.claude.com/docs/ko/terminal-guide)에서 터미널을 열고 명령을 붙여넣는 방법을 확인할 수 있습니다.
>
> > [tab] 기본 설치 (권장)
> >
> > **macOS, Linux, WSL:**
> >
> > ```bash theme={null}
> > curl -fsSL https://claude.ai/install.sh | bash
> > ```
> >
> > Windows에서 PowerShell에 있을 때는 프롬프트에 `PS C:\`가 표시되고, CMD에 있을 때는 `PS` 없이 `C:\`만 표시됩니다.
> >
> > **Windows PowerShell:**
> >
> > ```powershell theme={null}
> > irm https://claude.ai/install.ps1 | iex
> > ```
> >
> > **Windows CMD:**
> >
> > ```batch theme={null}
> > curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
> > ```
> >
> > 설치 명령은 Claude Code를 다운로드하는 동안 진행 상황을 표시하지 않습니다. 설치 프로그램이 완료되면 새 터미널 창을 열고 `claude --version`을 실행하십시오. 설치가 제대로 되었으면 버전 번호가 출력됩니다. 셸에서 `claude`를 찾을 수 없거나 인식되지 않는다고 표시되면 설치 디렉토리가 아직 PATH에 없는 것입니다. [PATH 수정](https://code.claude.com/docs/ko/troubleshoot-install.md#command-not-found-claude-after-installation)을 참조하십시오.
> >
> > `The token '&&' is not a valid statement separator` 오류가 표시되면 CMD가 아닌 PowerShell에 있는 것입니다. `'irm' is not recognized as an internal or external command` 오류가 표시되면 PowerShell이 아닌 CMD에 있는 것입니다.
> >
> > 설치 명령이 `syntax error near unexpected token '<'`, `403` 또는 다른 오류로 실패하면 [설치 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#find-your-error)을 참조하여 오류를 수정 방법과 일치시키고 대체 설치 방법을 확인하십시오.
> >
> > [Git for Windows](https://git-scm.com/downloads/win)는 Claude Code가 Bash 도구를 사용할 수 있도록 기본 Windows에서 권장됩니다. Git for Windows가 설치되지 않은 경우 Claude Code는 대신 PowerShell을 셸 도구로 사용합니다. WSL 설정에는 Git for Windows가 필요하지 않습니다.
> >
> > > [!NOTE]
> > >
> > > 기본 설치는 최신 버전으로 유지하기 위해 백그라운드에서 자동으로 업데이트됩니다.
>
> > [tab] Homebrew
> >
> > ```bash theme={null}
> > brew install --cask claude-code
> > ```
> >
> > Homebrew는 두 가지 cask를 제공합니다. `claude-code`는 안정적인 릴리스 채널을 추적하며, 일반적으로 약 1주일 뒤에 있고 주요 회귀가 있는 릴리스를 건너뜁니다. `claude-code@latest`는 최신 채널을 추적하고 새 버전이 출시되는 즉시 받습니다.
> >
> > > [!NOTE]
> > >
> > > Homebrew 설치는 자동으로 업데이트되지 않습니다. 설치한 cask에 따라 `brew upgrade claude-code` 또는 `brew upgrade claude-code@latest`를 실행하여 최신 기능 및 보안 수정 사항을 받으십시오.
>
> > [tab] WinGet
> >
> > ```powershell theme={null}
> > winget install Anthropic.ClaudeCode
> > ```
> >
> > > [!NOTE]
> > >
> > > WinGet 설치는 자동으로 업데이트되지 않습니다. 최신 기능 및 보안 수정 사항을 받으려면 주기적으로 `winget upgrade Anthropic.ClaudeCode`를 실행하십시오.
>
> 또한 Debian, Fedora, RHEL 및 Alpine에서 [apt, dnf 또는 apk](https://code.claude.com/docs/ko/setup.md#install-with-linux-package-managers)로 설치할 수 있습니다.
>
> 그런 다음 모든 프로젝트에서 Claude Code를 시작합니다. `your-project`를 머신의 프로젝트 디렉터리 경로로 바꾸세요:
>
> ```bash theme={null}
> cd your-project
> claude
> ```
>
> Claude Code는 처음 사용할 때 로그인을 요청합니다. `ANTHROPIC_API_KEY` 환경 변수를 설정했고 Claude Code가 키 사용 여부를 물을 때 키를 승인하면 Claude Code는 로그인 프롬프트를 건너뜁니다. [빠른 시작으로 계속하기 →](https://code.claude.com/docs/ko/quickstart.md)
>
> > [!TIP]
> >
> > [고급 설정](https://code.claude.com/docs/ko/setup.md)에서 설치 옵션, 수동 업데이트 또는 제거 지침을 참조하세요. 문제가 발생하면 [설치 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md)을 방문하세요.

> [tab] VS Code
>
> VS Code 확장 프로그램은 인라인 diff, @-mentions, 계획 검토 및 대화 기록을 편집기에서 직접 제공합니다.
>
> * [VS Code용 설치](vscode:extension/anthropic.claude-code)
> * [Cursor용 설치](cursor:extension/anthropic.claude-code)
>
> 또는 확장 프로그램 보기(`Mac에서 Cmd+Shift+X`, `Windows/Linux에서 Ctrl+Shift+X`)에서 "Claude Code"를 검색합니다. 설치 후 명령 팔레트(`Cmd+Shift+P` / `Ctrl+Shift+P`)를 열고 "Claude Code"를 입력한 다음 **새 탭에서 열기**를 선택합니다.
>
> [VS Code 시작하기 →](https://code.claude.com/docs/ko/vs-code.md#get-started)

> [tab] Desktop app
>
> IDE 또는 터미널 외부에서 Claude Code를 실행하기 위한 독립 실행형 앱입니다. diff를 시각적으로 검토하고, 여러 세션을 나란히 실행하고, 반복되는 작업을 예약하고, 클라우드 세션을 시작할 수 있습니다.
>
> 다운로드 및 설치:
>
> * [macOS](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code\&utm_medium=docs) (Intel 및 Apple Silicon)
> * [Windows](https://claude.ai/api/desktop/win32/x64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs) (x64)
> * [Windows ARM64](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)
> * Ubuntu 또는 Debian에서 앱이 베타 버전이므로 [Linux 설치 지침](https://code.claude.com/docs/ko/desktop-linux.md)을 따라 apt로 설치합니다.
>
> 설치 후 Claude를 실행하고, 로그인한 다음 **Code** 탭을 클릭하여 코딩을 시작합니다. 앱에는 Claude Code가 포함되어 있으므로 CLI를 별도로 설치할 필요가 없습니다. [유료 구독](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=overview_desktop_pricing)이 필요합니다.
>
> [데스크톱 앱에 대해 자세히 알아보기 →](https://code.claude.com/docs/ko/desktop-quickstart.md)

> [tab] Web
>
> 로컬 설정 없이 브라우저에서 Claude Code를 실행합니다. 오래 실행되는 작업을 시작하고 완료되면 다시 확인하거나, 로컬에 없는 리포지토리에서 작업하거나, 여러 작업을 병렬로 실행할 수 있습니다. 더 오래 진행되는 작업의 경우 [프로젝트](https://code.claude.com/docs/ko/claude-projects.md)를 생성하고 Claude가 병렬 세션을 조정하도록 하세요. 데스크톱 브라우저 및 [iOS 및 Android용 Claude 앱](https://code.claude.com/docs/ko/mobile.md)에서 사용할 수 있습니다.
>
> [claude.ai/code](https://claude.ai/code)에서 코딩을 시작합니다.
>
> [시작하기 →](https://code.claude.com/docs/ko/web-quickstart.md)

> [tab] JetBrains
>
> IntelliJ IDEA, PyCharm, WebStorm 및 기타 JetBrains IDE용 플러그인으로 대화형 diff 보기 및 선택 컨텍스트 공유 기능이 있습니다.
>
> JetBrains Marketplace에서 [Claude Code 플러그인](https://plugins.jetbrains.com/plugin/27310-claude-code-beta-)을 설치하고 IDE를 다시 시작합니다. 플러그인에는 별도로 설치되는 Claude Code CLI가 필요합니다. [JetBrains 설정 단계](https://code.claude.com/docs/ko/jetbrains.md#installation)를 참조하세요.
>
> [JetBrains 시작하기 →](https://code.claude.com/docs/ko/jetbrains.md)

## 할 수 있는 것

Claude Code를 사용할 수 있는 몇 가지 방법은 다음과 같습니다:

> [accordion] 계속 미루고 있는 작업 자동화
>
> Claude Code는 하루를 낭비하는 지루한 작업을 처리합니다: 테스트되지 않은 코드에 대한 테스트 작성, 프로젝트 전체의 lint 오류 수정, 병합 충돌 해결, 종속성 업데이트 및 릴리스 노트 작성.
>
> ```bash theme={null}
> claude "write tests for the auth module, run them, and fix any failures"
> ```

> [accordion] 기능 구축 및 버그 수정
>
> 원하는 것을 일반 언어로 설명합니다. Claude Code는 접근 방식을 계획하고, 여러 파일에 걸쳐 코드를 작성하고, 작동하는지 확인합니다.
>
> 버그의 경우 오류 메시지를 붙여넣거나 증상을 설명합니다. Claude Code는 코드베이스를 통해 문제를 추적하고, 근본 원인을 파악하고, 수정을 구현합니다. 더 많은 예제는 [일반적인 워크플로우](https://code.claude.com/docs/ko/common-workflows.md)를 참조하세요.

> [accordion] 커밋 및 풀 요청 생성
>
> Claude Code는 git과 직접 작동합니다. 변경 사항을 스테이징하고, 커밋 메시지를 작성하고, 브랜치를 생성하고, 풀 요청을 엽니다.
>
> ```bash theme={null}
> claude "commit my changes with a descriptive message"
> ```
>
> CI에서 [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md) 또는 [GitLab CI/CD](https://code.claude.com/docs/ko/gitlab-ci-cd.md)를 사용하여 코드 리뷰 및 이슈 분류를 자동화할 수 있습니다.

> [accordion] MCP로 도구 연결
>
> [Model Context Protocol (MCP)](https://code.claude.com/docs/ko/mcp.md)는 AI 도구를 외부 데이터 소스에 연결하기 위한 개방형 표준입니다. MCP를 사용하면 Claude Code는 Google Drive에서 설계 문서를 읽고, Jira에서 티켓을 업데이트하고, Slack에서 데이터를 가져오거나, 자신의 커스텀 도구를 사용할 수 있습니다. [MCP 빠른 시작](https://code.claude.com/docs/ko/mcp-quickstart.md)은 첫 번째 서버를 처음부터 끝까지 연결합니다.

> [accordion] 지침, 스킬 및 훅으로 사용자 정의
>
> [`CLAUDE.md`](https://code.claude.com/docs/ko/memory)는 프로젝트 루트에 추가하는 마크다운 파일로 Claude Code가 모든 세션의 시작 부분에서 읽습니다. 이를 사용하여 코딩 표준, 아키텍처 결정, 선호하는 라이브러리 및 검토 체크리스트를 설정합니다. 저장소에 이미 다른 코딩 에이전트용 `AGENTS.md`가 있는 경우 Claude Code는 `CLAUDE.md` 대신 [해당 파일을 읽을 수 있습니다](https://code.claude.com/docs/ko/memory.md#agents-md). Claude는 또한 작업할 때 [자동 메모리](https://code.claude.com/docs/ko/memory.md#auto-memory)를 구축하여 세션 전체에서 학습 내용을 저장하므로 아무것도 작성할 필요가 없습니다.
>
> [skills](https://code.claude.com/docs/ko/skills.md)를 생성하여 팀이 공유할 수 있는 반복 가능한 워크플로우를 패키징합니다(예: `/review-pr` 또는 `/deploy-staging`).
>
> [Hooks](https://code.claude.com/docs/ko/hooks.md)를 사용하면 Claude Code 작업 전후에 셸 명령을 실행할 수 있습니다(예: 모든 파일 편집 후 자동 포맷팅 또는 커밋 전 lint 실행).

> [accordion] 에이전트를 병렬로 실행하고 커스텀 에이전트 구축
>
> 작업의 다른 부분에서 동시에 작동하는 [여러 Claude Code 에이전트](https://code.claude.com/docs/ko/sub-agents.md)를 생성합니다. 리드 에이전트가 작업을 조정하고, 하위 작업을 할당하고, 결과를 병합합니다.
>
> 여러 전체 세션을 병렬로 실행하고 한 화면에서 감시하려면 [백그라운드 에이전트](https://code.claude.com/docs/ko/agent-view.md)를 사용합니다. 완전히 커스텀 워크플로우의 경우 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)를 사용하면 Claude Code의 도구 및 기능으로 구동되는 자신의 에이전트를 구축할 수 있으며, 오케스트레이션, 도구 액세스 및 권한에 대한 완전한 제어가 가능합니다.

> [accordion] CLI로 파이프, 스크립트 및 자동화
>
> Claude Code는 구성 가능하며 Unix 철학을 따릅니다. 로그를 파이프하고, CI에서 실행하거나, 다른 도구와 연결합니다:
>
> ```bash theme={null}
> # 최근 로그 출력 분석
> tail -200 app.log | claude -p "Slack me if you see any anomalies"
>
> # CI에서 번역 자동화
> claude -p "translate new strings into French and raise a PR for review"
>
> # 파일 전체에 걸친 대량 작업
> git diff main --name-only | claude -p "review these changed files for security issues"
> ```
>
> 전체 명령 및 플래그 세트는 [CLI 참조](https://code.claude.com/docs/ko/cli-reference.md)를 참조하세요.

> [accordion] 반복되는 작업 예약
>
> Claude를 일정에 따라 실행하여 반복되는 작업을 자동화합니다: 아침 PR 검토, 야간 CI 실패 분석, 주간 종속성 감사 또는 PR 병합 후 문서 동기화.
>
> * 이전에 루틴이라고 불렸던 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)은 클라우드에서 실행되므로 컴퓨터가 꺼져 있어도 계속 실행됩니다. API 호출 또는 GitHub 이벤트에서도 트리거될 수 있습니다. 웹, 데스크톱 앱에서 생성하거나 CLI에서 `/schedule`을 실행하여 생성합니다.
> * [데스크톱 예약 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md)은 머신에서 실행되며 로컬 파일 및 도구에 직접 액세스할 수 있습니다
> * [`/loop`](https://code.claude.com/docs/ko/scheduled-tasks)는 빠른 폴링을 위해 CLI 세션 내에서 프롬프트를 반복합니다

> [accordion] 어디서나 작업
>
> 세션은 단일 사용 환경에 연결되지 않습니다. 컨텍스트가 변경되면 사용 환경 간에 작업을 이동합니다:
>
> * 책상에서 떠나 [원격 제어](https://code.claude.com/docs/ko/remote-control.md)를 사용하여 휴대폰이나 모든 브라우저에서 계속 작업합니다
> * [Dispatch](https://code.claude.com/docs/ko/desktop.md#sessions-from-dispatch)에 휴대폰에서 작업을 메시지로 보내고 생성되는 데스크톱 세션을 엽니다
> * [웹](https://code.claude.com/docs/ko/claude-code-on-the-web.md) 또는 [Claude 모바일 앱](https://code.claude.com/docs/ko/mobile.md)에서 오래 실행되는 작업을 시작한 다음 `claude --teleport`를 사용하여 터미널로 가져옵니다. Teleport는 claude.ai 구독이 필요합니다.
> * `/desktop`을 사용하여 현재 터미널 세션을 [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md)에서 계속하여 시각적으로 diff를 검토할 수 있습니다. `/desktop` 핸드오프는 claude.ai 구독이 필요합니다. macOS 및 x64 Windows에서 사용 가능합니다.
> * 팀 채팅에서 작업을 라우팅합니다: [Slack](https://code.claude.com/docs/ko/slack.md)에서 `@Claude`를 언급하고 버그 보고서를 포함하면 풀 요청을 다시 받습니다

## 모든 곳에서 Claude Code 사용

각 [환경](https://code.claude.com/docs/ko/glossary.md#surface)은 동일한 기본 Claude Code 엔진에 연결되므로 CLAUDE.md 파일, 설정 및 MCP 서버가 모든 환경에서 작동합니다.

위의 [Terminal](https://code.claude.com/docs/ko/quickstart.md), [VS Code](https://code.claude.com/docs/ko/vs-code.md), [JetBrains](https://code.claude.com/docs/ko/jetbrains.md), [Desktop](https://code.claude.com/docs/ko/desktop.md) 및 [Web](https://code.claude.com/docs/ko/claude-code-on-the-web.md) 환경 외에도 Claude Code는 CI/CD, 채팅 및 브라우저 워크플로우와 통합됩니다:

| 원하는 것 | 최적의 옵션 |
| - | - |
| 휴대폰이나 다른 기기에서 로컬 세션 계속하기 | [원격 제어](https://code.claude.com/docs/ko/remote-control.md) |
| Telegram, Discord, iMessage 또는 자신의 웹훅에서 세션으로 이벤트 푸시 | [Channels](https://code.claude.com/docs/ko/channels.md) |
| 로컬에서 작업 시작, 모바일에서 계속 | [`claude --cloud`](https://code.claude.com/docs/ko/claude-code-on-the-web#from-terminal-to-cloud), 그 다음 [Claude 모바일 앱](https://code.claude.com/docs/ko/mobile.md) |
| Claude를 반복 일정에 따라 실행 | [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md) 또는 [Desktop 예약 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md) |
| PR 검토 및 이슈 분류 자동화 | [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md) 또는 [GitLab CI/CD](https://code.claude.com/docs/ko/gitlab-ci-cd.md) |
| 모든 PR에서 자동 코드 검토 받기 | [GitHub Code Review](https://code.claude.com/docs/ko/code-review.md) |
| Slack의 버그 보고서를 풀 요청으로 라우팅 | [Slack](https://code.claude.com/docs/ko/slack.md) |
| 라이브 웹 애플리케이션 디버깅 | [Chrome](https://code.claude.com/docs/ko/chrome.md) |
| 자신의 워크플로우를 위한 커스텀 에이전트 구축 | [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) |

## 다음 단계

Claude Code를 설치한 후 이 가이드를 통해 더 깊이 있게 알아볼 수 있습니다.

* [빠른 시작](https://code.claude.com/docs/ko/quickstart.md): 코드베이스 탐색에서 수정 커밋까지 첫 번째 실제 작업을 진행합니다
* [지침 및 메모리 저장](https://code.claude.com/docs/ko/memory.md): CLAUDE.md 파일 및 자동 메모리를 사용하여 Claude에 지속적인 지침을 제공합니다
* [일반적인 워크플로우](https://code.claude.com/docs/ko/common-workflows.md) 및 [모범 사례](https://code.claude.com/docs/ko/best-practices.md): Claude Code에서 최대한 활용하기 위한 패턴
* [Claude Academy](https://academy.claude.com/): 무료 자기 주도 학습 과정으로 [Claude Code 101](https://academy.claude.com/courses/claude-code-101) 및 [Claude Code in Action](https://academy.claude.com/courses/claude-code-in-action)을 포함합니다
* [모든 작업을 위한 하네스](https://claude.com/blog/a-harness-for-every-task-dynamic-workflows-in-claude-code): Claude Code 팀이 [동적 워크플로우](https://code.claude.com/docs/ko/workflows.md)를 사용하여 대규모로 서브에이전트를 조율하는 방법
* [설정](https://code.claude.com/docs/ko/settings.md): Claude Code를 워크플로우에 맞게 사용자 정의합니다
* [문제 해결](https://code.claude.com/docs/ko/troubleshooting.md): 일반적인 문제에 대한 솔루션
* [code.claude.com](https://code.claude.com/): 데모, 가격 책정 및 제품 세부 정보
