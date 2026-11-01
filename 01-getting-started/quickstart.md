> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 빠른 시작

> 터미널에 Claude Code를 설치하고 로그인한 후, CLI를 사용하여 코드베이스를 탐색하고 첫 번째 코드 변경을 수행합니다.

이 빠른 시작 가이드에서는 터미널에서 Claude Code를 사용하는 방법을 다룹니다. CLI 설치, 첫 세션에서의 로그인, 그리고 자체 프로젝트에서 일반적인 개발 작업에 활용하는 방법을 설명합니다.

## 시작하기 전에

다음을 확인하십시오:

* 열려 있는 터미널 또는 명령 프롬프트
* 작업할 코드 프로젝트
* [Claude 구독](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=quickstart_prereq) (Pro, Max, Ultra, Team 또는 Enterprise), [Claude Console](https://platform.claude.com/) 계정 또는 [지원되는 클라우드 제공자](https://code.claude.com/docs/ko/third-party-integrations.md)를 통한 액세스

> [!NOTE]
>
> 다음 경우는 다른 페이지에서 다룹니다:
>
> * **터미널을 처음 사용하는 경우**: [터미널 가이드](https://code.claude.com/docs/ko/terminal-guide)부터 시작하십시오
> * **터미널이 아닌 다른 곳에서 Claude Code를 사용하려는 경우**: Claude Code는 [웹](https://claude.ai/code), [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md), [VS Code](https://code.claude.com/docs/ko/vs-code.md) 및 [JetBrains IDE](https://code.claude.com/docs/ko/jetbrains.md), [Slack](https://code.claude.com/docs/ko/slack.md), [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md) 및 [GitLab](https://code.claude.com/docs/ko/gitlab-ci-cd.md)의 CI/CD에서도 사용할 수 있습니다. [모든 인터페이스](https://code.claude.com/docs/ko/overview.md#use-claude-code-everywhere)를 참조하십시오.

## 단계 1: Claude Code 설치

Claude Code를 설치하려면 터미널을 열고 시스템에 맞는 명령을 실행하십시오. 이전에 터미널을 사용해본 적이 없다면 [터미널 가이드](https://code.claude.com/docs/ko/terminal-guide)에서 터미널을 열고 명령을 붙여넣는 방법을 확인할 수 있습니다.

> [tab] 기본 설치 (권장)
>
> **macOS, Linux, WSL:**
>
> ```bash theme={null}
> curl -fsSL https://claude.ai/install.sh | bash
> ```
>
> Windows에서 PowerShell에 있을 때는 프롬프트에 `PS C:\`가 표시되고, CMD에 있을 때는 `PS` 없이 `C:\`만 표시됩니다.
>
> **Windows PowerShell:**
>
> ```powershell theme={null}
> irm https://claude.ai/install.ps1 | iex
> ```
>
> **Windows CMD:**
>
> ```batch theme={null}
> curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
> ```
>
> 설치 명령은 Claude Code를 다운로드하는 동안 진행 상황을 표시하지 않습니다. 설치 프로그램이 완료되면 새 터미널 창을 열고 `claude --version`을 실행하십시오. 설치가 제대로 되었으면 버전 번호가 출력됩니다. 셸에서 `claude`를 찾을 수 없거나 인식되지 않는다고 표시되면 설치 디렉토리가 아직 PATH에 없는 것입니다. [PATH 수정](https://code.claude.com/docs/ko/troubleshoot-install.md#command-not-found-claude-after-installation)을 참조하십시오.
>
> `The token '&&' is not a valid statement separator` 오류가 표시되면 CMD가 아닌 PowerShell에 있는 것입니다. `'irm' is not recognized as an internal or external command` 오류가 표시되면 PowerShell이 아닌 CMD에 있는 것입니다.
>
> 설치 명령이 `syntax error near unexpected token '<'`, `403` 또는 다른 오류로 실패하면 [설치 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#find-your-error)을 참조하여 오류를 수정 방법과 일치시키고 대체 설치 방법을 확인하십시오.
>
> [Git for Windows](https://git-scm.com/downloads/win)는 Claude Code가 Bash 도구를 사용할 수 있도록 기본 Windows에서 권장됩니다. Git for Windows가 설치되지 않은 경우 Claude Code는 대신 PowerShell을 셸 도구로 사용합니다. WSL 설정에는 Git for Windows가 필요하지 않습니다.
>
> > [!NOTE]
> >
> > 기본 설치는 최신 버전으로 유지하기 위해 백그라운드에서 자동으로 업데이트됩니다.

> [tab] Homebrew
>
> ```bash theme={null}
> brew install --cask claude-code
> ```
>
> Homebrew는 두 가지 cask를 제공합니다. `claude-code`는 안정적인 릴리스 채널을 추적하며, 일반적으로 약 1주일 뒤에 있고 주요 회귀가 있는 릴리스를 건너뜁니다. `claude-code@latest`는 최신 채널을 추적하고 새 버전이 출시되는 즉시 받습니다.
>
> > [!NOTE]
> >
> > Homebrew 설치는 자동으로 업데이트되지 않습니다. 설치한 cask에 따라 `brew upgrade claude-code` 또는 `brew upgrade claude-code@latest`를 실행하여 최신 기능 및 보안 수정 사항을 받으십시오.

> [tab] WinGet
>
> ```powershell theme={null}
> winget install Anthropic.ClaudeCode
> ```
>
> > [!NOTE]
> >
> > WinGet 설치는 자동으로 업데이트되지 않습니다. 최신 기능 및 보안 수정 사항을 받으려면 주기적으로 `winget upgrade Anthropic.ClaudeCode`를 실행하십시오.

또한 Debian, Fedora, RHEL 및 Alpine에서 [apt, dnf 또는 apk](https://code.claude.com/docs/ko/setup.md#install-with-linux-package-managers)로 설치할 수 있습니다.

설치가 제대로 작동했는지 확인하려면 다음을 실행하세요:

```bash theme={null}
claude --version
```

이 명령어는 버전 번호 다음에 `(Claude Code)`를 출력합니다.

## 2단계: 첫 번째 세션 시작하기

아무 프로젝트 디렉터리에서 터미널을 열고 Claude Code를 시작합니다:

```bash theme={null}
cd /path/to/your/project
claude
```

`/path/to/your/project`를 작업하려는 프로젝트의 경로로 바꿉니다.

Claude Code는 처음 사용할 때 로그인을 요청합니다. Claude 구독 또는 Console 계정의 경우 안내에 따라 브라우저에서 인증을 완료합니다. `ANTHROPIC_API_KEY` 환경 변수를 설정했고 Claude Code가 해당 키를 사용할지 물을 때 승인하면 Claude Code는 로그인 프롬프트를 건너뜁니다.

다음 계정 유형 중 하나로 로그인할 수 있습니다:

* [Claude Pro, Max, Ultra, Team 또는 Enterprise](https://claude.com/pricing?utm_source=claude_code\&utm_medium=docs\&utm_content=quickstart_login)(권장)
* [Claude Console](https://platform.claude.com/)(선불 크레딧을 사용하는 API 액세스). 처음 로그인하면 중앙 집중식 비용 추적을 위해 Console에 "Claude Code" 워크스페이스가 자동으로 생성됩니다.
* [Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry](https://code.claude.com/docs/ko/third-party-integrations.md)(엔터프라이즈 클라우드 제공업체)
* 조직에서 운영하는 경우 자체 호스팅 [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway): 관리자가 게이트웨이 URL을 미리 구성하며, `/login`을 실행하면 바로 **Cloud gateway** 화면이 열려 회사 SSO로 로그인할 수 있습니다

로그인하면 자격 증명이 저장되므로 다시 로그인할 필요가 없습니다. 자세한 내용은 [자격 증명 관리](https://code.claude.com/docs/ko/authentication.md#credential-management)를 참조하세요.

Claude Code 프롬프트가 나타나며, 그 위에 버전, 현재 모델, 작업 디렉터리가 표시됩니다. 사용 가능한 명령을 보려면 `/help`를, 이전 대화를 이어가려면 `/resume`을 입력합니다. 나중에 계정을 전환하거나 다시 인증하려면 실행 중인 세션 안에서 `/login`을 입력합니다.

## 3단계: 첫 번째 질문하기

다음 명령 중 하나를 시도해 보세요:

```text wrap theme={null}
what does this project do?
```

Claude가 파일을 분석하고 요약을 제공합니다. 더 구체적인 질문을 할 수도 있습니다:

```text wrap theme={null}
what technologies does this project use?
```

```text wrap theme={null}
where is the main entry point?
```

```text wrap theme={null}
explain the folder structure
```

Claude에게 Claude 자체의 기능에 대해 물어볼 수도 있습니다:

```text wrap theme={null}
what can Claude Code do?
```

```text wrap theme={null}
how do I create custom skills in Claude Code?
```

```text wrap theme={null}
can Claude Code work with Docker?
```

> [!NOTE]
>
> Claude Code는 필요에 따라 프로젝트 파일을 읽습니다. 컨텍스트를 수동으로 추가할 필요가 없습니다.

## 4단계: 첫 번째 코드 변경하기

간단한 작업을 시도해 보세요:

```text wrap theme={null}
add a hello world function to the main file
```

Claude Code가 적절한 파일을 찾아 변경 사항을 보여 줍니다. 변경하기 전에 확인을 요청하면 **Yes**를 선택하여 승인합니다.

세션의 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)는 Claude가 먼저 묻지 않고 수행할 수 있는 작업을 결정합니다. 언제든지 `Shift+Tab`을 눌러 현재 세션의 권한 모드를 전환할 수 있습니다.

## 5단계: Claude Code로 Git 사용하기

Claude Code를 사용하면 대화하듯이 Git 작업을 수행할 수 있습니다:

```text wrap theme={null}
what files have I changed?
```

```text wrap theme={null}
commit my changes with a descriptive message
```

더 복잡한 Git 작업을 요청할 수도 있습니다:

```text wrap theme={null}
create a new branch called feature/quickstart
```

```text wrap theme={null}
show me the last 5 commits
```

```text wrap theme={null}
help me resolve merge conflicts
```

## 6단계: 버그 수정 또는 기능 추가

원하는 작업을 자연어로 설명합니다:

```text wrap theme={null}
add input validation to the user registration form
```

또는 기존 문제를 수정합니다:

```text wrap theme={null}
there's a bug where users can submit empty forms - fix it
```

## 7단계: 다른 일반적인 워크플로 테스트하기

몇 가지 프롬프트를 더 시도해 보세요. Claude에게 코드 리팩터링, 테스트 작성, 문서 업데이트, 변경 사항 리뷰를 요청할 수 있습니다.

```text wrap theme={null}
refactor the authentication module to use async/await instead of callbacks
```

```text wrap theme={null}
write unit tests for the calculator functions
```

```text wrap theme={null}
update the README with installation instructions
```

```text wrap theme={null}
review my changes and suggest improvements
```

> [!TIP]
>
> 유능한 동료에게 말하듯이 Claude에게 말해 보세요. 달성하고 싶은 목표를 설명하면 Claude가 그 목표에 도달할 수 있도록 도와줍니다.

## 필수 명령

일상적인 사용을 위한 가장 중요한 명령을 실행 위치별로 분류하면 다음과 같습니다.

### 셸 명령

Claude Code를 시작하거나 재개하려면 터미널에서 다음 명령을 실행합니다.

| 명령 | 기능 | 예시 |
| - | - | - |
| `claude` | 대화형 모드 시작 | `claude` |
| `claude "task"` | 초기 프롬프트를 사용하여 대화형 모드 시작 | `claude "fix the build error"` |
| `claude -p "query"` | 일회성 쿼리 실행 후 종료 | `claude -p "explain this function"` |
| `claude -c` | 현재 디렉토리에서 가장 최근 대화 계속 | `claude -c` |
| `claude -r` | 이전 대화 재개 | `claude -r` |

전체 셸 명령 목록은 [CLI 참조](https://code.claude.com/docs/ko/cli-reference.md)를 참조하십시오.

### 세션 명령

Claude Code가 시작된 후 내부에서 다음 명령을 실행합니다.

| 명령 | 기능 | 예시 |
| - | - | - |
| `/clear` | 대화 기록 지우기 | `/clear` |
| `/help` | 사용 가능한 명령 표시 | `/help` |
| `/exit` 또는 Ctrl+D 두 번 | Claude Code 종료 | `/exit` |

전체 세션 명령 목록은 [명령 참조](https://code.claude.com/docs/ko/commands.md)를 참조하십시오.

## 초보자를 위한 팁

자세한 내용은 [모범 사례](https://code.claude.com/docs/ko/best-practices.md) 및 [일반적인 워크플로우](https://code.claude.com/docs/ko/common-workflows.md)를 참조하십시오.

> [accordion] 요청을 구체적으로 하기
>
> 대신: "버그 수정"
>
> 시도: "사용자가 잘못된 자격 증명을 입력한 후 빈 화면을 보는 로그인 버그 수정"

> [accordion] 단계별 지침 사용
>
> 복잡한 작업을 단계로 나누기:
>
> ```text wrap theme={null}
> 1. 사용자 프로필을 위한 새 데이터베이스 테이블 생성
> 2. 사용자 프로필을 가져오고 업데이트하는 API 엔드포인트 생성
> 3. 사용자가 자신의 정보를 보고 편집할 수 있는 웹페이지 구축
> ```

> [accordion] Claude가 먼저 탐색하도록 하기
>
> 변경하기 전에 Claude가 코드를 이해하도록 하기:
>
> ```text wrap theme={null}
> 데이터베이스 스키마 분석
> ```
>
> ```text wrap theme={null}
> 영국 고객이 가장 자주 반품하는 제품을 보여주는 대시보드 구축
> ```

> [accordion] 바로가기로 시간 절약
>
> * `/`를 입력하여 모든 명령 및 skills 보기
> * Tab을 사용하여 명령 완성
> * ↑를 눌러 명령 기록 보기
> * `Shift+Tab`을 눌러 권한 모드 순환

## 다음 단계

이제 기본 사항을 배웠으므로 더 고급 기능을 살펴보십시오:

* [Claude Code 작동 방식](https://code.claude.com/docs/ko/how-claude-code-works.md): 에이전틱 루프, 기본 제공 도구 및 Claude Code가 프로젝트와 상호 작용하는 방식 이해
* [모범 사례](https://code.claude.com/docs/ko/best-practices.md): 효과적인 프롬프팅 및 프로젝트 설정으로 더 나은 결과 얻기
* [일반적인 워크플로](https://code.claude.com/docs/ko/common-workflows.md): 일반적인 작업에 대한 단계별 가이드
* [Claude Code 확장](https://code.claude.com/docs/ko/features-overview.md): CLAUDE.md, 스킬, 훅, MCP 등으로 사용자 정의

설치 옵션, 수동 업데이트 또는 제거 방법은 [고급 설정](https://code.claude.com/docs/ko/setup.md)을 참조하십시오.

## 도움 받기

* **Claude Code에서**: `/help`를 입력하거나 "어떻게..."를 물어보기
* **문서**: 이 사이트의 다른 가이드 찾아보기
* **강좌**: [Claude Code 101](https://academy.claude.com/courses/claude-code-101)을 수강하고 [Claude Academy](https://academy.claude.com/)에서 다른 무료 자습형 강좌를 수강하기
* **커뮤니티**: 팁과 지원을 위해 [Discord 서버](https://www.anthropic.com/discord)에 참여하기
