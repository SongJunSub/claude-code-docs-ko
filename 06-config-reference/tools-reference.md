> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 도구 참조

> Claude Code가 사용할 수 있는 도구의 완전한 참조 자료이며, 권한 요구사항을 포함합니다.

Claude Code는 코드베이스를 이해하고 수정하는 데 도움이 되는 도구 세트에 접근할 수 있습니다. 도구 이름은 [권한 규칙](/ko/permissions#tool-specific-permission-rules), [subagent 도구 목록](/ko/sub-agents), 및 [hook 매처](/ko/hooks)에서 사용하는 정확한 문자열입니다. 도구를 완전히 비활성화하려면 [권한 설정](/ko/permissions#tool-specific-permission-rules)의 `deny` 배열에 해당 이름을 추가합니다.

사용자 정의 도구를 추가하려면 [MCP 서버](/ko/mcp)를 연결합니다. Claude를 재사용 가능한 프롬프트 기반 워크플로우로 확장하려면 [skill](/ko/skills)을 작성합니다. 이는 새로운 도구 항목을 추가하는 대신 기존 `Skill` 도구를 통해 실행됩니다.

| 도구                     | 설명                                                                                                                                                                                                        | 필요한 권한 |
| :--------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----- |
| `Agent`                | 작업을 처리하기 위해 자체 context window를 가진 [subagent](/ko/sub-agents)를 생성합니다                                                                                                                                       | 아니오    |
| `AskUserQuestion`      | 요구사항을 수집하거나 모호함을 명확히 하기 위해 객관식 질문을 합니다                                                                                                                                                                    | 아니오    |
| `Bash`                 | 환경에서 shell 명령을 실행합니다. [Bash 도구 동작](#bash-tool-behavior) 참조                                                                                                                                                | 예      |
| `CronCreate`           | 현재 세션 내에서 반복 또는 일회성 프롬프트를 예약합니다. 작업은 세션 범위이며 `--resume` 또는 `--continue`에서 만료되지 않으면 복원됩니다. [예약된 작업](/ko/scheduled-tasks) 참조                                                                                | 아니오    |
| `CronDelete`           | ID로 예약된 작업을 취소합니다                                                                                                                                                                                         | 아니오    |
| `CronList`             | 세션의 모든 예약된 작업을 나열합니다                                                                                                                                                                                      | 아니오    |
| `Edit`                 | 특정 파일에 대한 대상 편집을 수행합니다                                                                                                                                                                                    | 예      |
| `EnterPlanMode`        | Plan Mode로 전환하여 코딩 전에 접근 방식을 설계합니다                                                                                                                                                                        | 아니오    |
| `EnterWorktree`        | 격리된 [git worktree](/ko/common-workflows#run-parallel-claude-code-sessions-with-git-worktrees)를 생성하고 전환합니다. 새로운 worktree를 생성하는 대신 현재 저장소의 기존 worktree로 전환하려면 `path`를 전달합니다. Subagent에서는 사용할 수 없습니다         | 아니오    |
| `ExitPlanMode`         | 승인을 위한 계획을 제시하고 Plan Mode를 종료합니다                                                                                                                                                                          | 예      |
| `ExitWorktree`         | worktree 세션을 종료하고 원래 디렉토리로 돌아갑니다. Subagent에서는 사용할 수 없습니다                                                                                                                                                  | 아니오    |
| `Glob`                 | 패턴 매칭을 기반으로 파일을 찾습니다                                                                                                                                                                                      | 아니오    |
| `Grep`                 | 파일 내용에서 패턴을 검색합니다                                                                                                                                                                                         | 아니오    |
| `ListMcpResourcesTool` | 연결된 [MCP 서버](/ko/mcp)에서 노출된 리소스를 나열합니다                                                                                                                                                                    | 아니오    |
| `LSP`                  | 언어 서버를 통한 코드 인텔리전스: 정의로 이동, 참조 찾기, 타입 오류 및 경고 보고. [LSP 도구 동작](#lsp-tool-behavior) 참조                                                                                                                      | 아니오    |
| `Monitor`              | 백그라운드에서 명령을 실행하고 각 출력 라인을 Claude에 다시 전달하므로, Claude는 로그 항목, 파일 변경 또는 대화 중 폴링된 상태에 반응할 수 있습니다. [Monitor 도구](#monitor-tool) 참조                                                                               | 예      |
| `NotebookEdit`         | Jupyter 노트북 셀을 수정합니다                                                                                                                                                                                      | 예      |
| `PowerShell`           | PowerShell 명령을 기본적으로 실행합니다. [PowerShell 도구](#powershell-tool) 참조                                                                                                                                          | 예      |
| `Read`                 | 파일의 내용을 읽습니다                                                                                                                                                                                              | 아니오    |
| `ReadMcpResourceTool`  | URI로 특정 MCP 리소스를 읽습니다                                                                                                                                                                                     | 아니오    |
| `SendMessage`          | [agent team](/ko/agent-teams) 팀원에게 메시지를 보내거나, agent ID로 [subagent를 재개합니다](/ko/sub-agents#resume-subagents). 중지된 subagent는 백그라운드에서 자동으로 재개됩니다. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`이 설정되었을 때만 사용 가능합니다 | 아니오    |
| `Skill`                | 주 대화 내에서 [skill](/ko/skills#control-who-invokes-a-skill)을 실행합니다                                                                                                                                           | 예      |
| `TaskCreate`           | 작업 목록에 새 작업을 생성합니다                                                                                                                                                                                        | 아니오    |
| `TaskGet`              | 특정 작업의 전체 세부 정보를 검색합니다                                                                                                                                                                                    | 아니오    |
| `TaskList`             | 현재 상태와 함께 모든 작업을 나열합니다                                                                                                                                                                                    | 아니오    |
| `TaskOutput`           | (더 이상 사용되지 않음) 백그라운드 작업에서 출력을 검색합니다. 작업의 출력 파일 경로에서 `Read`를 사용하는 것을 권장합니다                                                                                                                                 | 아니오    |
| `TaskStop`             | ID로 실행 중인 백그라운드 작업을 종료합니다                                                                                                                                                                                 | 아니오    |
| `TaskUpdate`           | 작업 상태, 종속성, 세부 정보를 업데이트하거나 작업을 삭제합니다                                                                                                                                                                      | 아니오    |
| `TeamCreate`           | 여러 팀원이 있는 [agent team](/ko/agent-teams)을 생성합니다. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`이 설정되었을 때만 사용 가능합니다                                                                                               | 아니오    |
| `TeamDelete`           | agent team을 해산하고 팀원 프로세스를 정리합니다. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`이 설정되었을 때만 사용 가능합니다                                                                                                              | 아니오    |
| `TodoWrite`            | 세션 작업 체크리스트를 관리합니다. 비대화형 모드 및 [Agent SDK](/ko/headless)에서 사용 가능합니다. 대화형 세션은 대신 TaskCreate, TaskGet, TaskList, TaskUpdate를 사용합니다                                                                           | 아니오    |
| `ToolSearch`           | [tool search](/ko/mcp#scale-with-mcp-tool-search)가 활성화되었을 때 지연된 도구를 검색하고 로드합니다                                                                                                                            | 아니오    |
| `WebFetch`             | 지정된 URL에서 콘텐츠를 가져옵니다                                                                                                                                                                                      | 예      |
| `WebSearch`            | 웹 검색을 수행합니다                                                                                                                                                                                               | 예      |
| `Write`                | 파일을 생성하거나 덮어씁니다                                                                                                                                                                                           | 예      |

권한 규칙은 `/permissions`를 사용하거나 [권한 설정](/ko/settings#available-settings)에서 구성할 수 있습니다. [도구별 권한 규칙](/ko/permissions#tool-specific-permission-rules)도 참조하십시오.

## Bash 도구 동작

Bash 도구는 다음의 지속성 동작으로 각 명령을 별도의 프로세스에서 실행합니다:

* Claude가 주 세션에서 `cd`를 실행할 때, 새로운 작업 디렉토리는 프로젝트 디렉토리 내에 머물러 있거나 `--add-dir`, `/add-dir`, 또는 설정의 `additionalDirectories`로 추가한 [추가 작업 디렉토리](/ko/permissions#working-directories) 내에 머물러 있는 한 이후 Bash 명령으로 이월됩니다. Subagent 세션은 절대 작업 디렉토리 변경을 이월하지 않습니다.
  * `cd`가 해당 디렉토리 외부로 이동하면, Claude Code는 프로젝트 디렉토리로 재설정하고 도구 결과에 `Shell cwd was reset to <dir>`을 추가합니다.
  * 모든 Bash 명령이 프로젝트 디렉토리에서 시작하도록 이 이월을 비활성화하려면 `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1`을 설정합니다.
* 환경 변수는 지속되지 않습니다. 한 명령의 `export`는 다음 명령에서 사용할 수 없습니다.

Claude Code를 시작하기 전에 virtualenv 또는 conda 환경을 활성화합니다. Bash 명령 전체에서 환경 변수를 지속하려면 Claude Code를 시작하기 전에 [`CLAUDE_ENV_FILE`](/ko/env-vars)을 shell 스크립트로 설정하거나, [SessionStart hook](/ko/hooks#persist-environment-variables)을 사용하여 동적으로 채웁니다.

## LSP 도구 동작

LSP 도구는 실행 중인 언어 서버에서 Claude에 코드 인텔리전스를 제공합니다. 각 파일 편집 후 자동으로 타입 오류 및 경고를 보고하므로 Claude는 별도의 빌드 단계 없이 문제를 수정할 수 있습니다. Claude는 또한 코드를 탐색하기 위해 직접 호출할 수 있습니다:

* 기호의 정의로 이동
* 기호에 대한 모든 참조 찾기
* 위치의 타입 정보 가져오기
* 파일 또는 워크스페이스의 기호 나열
* 인터페이스의 구현 찾기
* 호출 계층 추적

이 도구는 언어에 대한 [코드 인텔리전스 플러그인](/ko/discover-plugins#code-intelligence)을 설치할 때까지 비활성 상태입니다. 플러그인은 언어 서버 구성을 번들로 제공하며, 서버 바이너리는 별도로 설치합니다.

## Monitor 도구

<Note>
  Monitor 도구는 Claude Code v2.1.98 이상이 필요합니다.
</Note>

Monitor 도구를 사용하면 Claude는 백그라운드에서 무언가를 감시하고 대화를 일시 중지하지 않고 변경될 때 반응할 수 있습니다. Claude에 다음을 요청합니다:

* 로그 파일을 추적하고 오류가 나타나면 플래그 지정
* PR 또는 CI 작업을 폴링하고 상태가 변경되면 보고
* 파일 변경을 위해 디렉토리 감시
* 지정한 장기 실행 스크립트의 출력 추적

Claude는 감시를 위한 작은 스크립트를 작성하고, 백그라운드에서 실행하며, 각 출력 라인이 도착할 때 수신합니다. 동일한 세션에서 계속 작업하고 Claude는 이벤트가 발생할 때 개입합니다. Claude에 취소하도록 요청하거나 세션을 종료하여 모니터를 중지합니다.

Monitor는 [Bash와 동일한 권한 규칙](/ko/permissions#tool-specific-permission-rules)을 사용하므로, Bash에 대해 설정한 `allow` 및 `deny` 패턴이 여기에도 적용됩니다. Amazon Bedrock, Google Vertex AI 또는 Microsoft Foundry에서는 사용할 수 없습니다. `DISABLE_TELEMETRY` 또는 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`이 설정되었을 때도 사용할 수 없습니다.

플러그인은 Claude에 시작하도록 요청하는 대신 플러그인이 활성화될 때 자동으로 시작되는 모니터를 선언할 수 있습니다. [플러그인 모니터](/ko/plugins-reference#monitors)를 참조합니다.

## PowerShell 도구

PowerShell 도구를 사용하면 Claude는 PowerShell 명령을 기본적으로 실행할 수 있습니다. Windows에서는 이것이 Git Bash를 통해 라우팅하는 대신 PowerShell에서 명령을 실행한다는 의미입니다. 이 도구는 Windows에서 점진적으로 출시되고 있으며 Linux, macOS 및 WSL에서는 옵트인입니다.

### PowerShell 도구 활성화

환경 또는 `settings.json`에서 `CLAUDE_CODE_USE_POWERSHELL_TOOL=1`을 설정합니다:

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_USE_POWERSHELL_TOOL": "1"
  }
}
```

Windows에서는 변수를 `0`으로 설정하여 출시를 거부할 수 있습니다. Linux, macOS 및 WSL에서는 도구에 PowerShell 7 이상이 필요합니다: `pwsh`를 설치하고 `PATH`에 있는지 확인합니다.

Windows에서 Claude Code는 PowerShell 7+의 경우 `pwsh.exe`를 자동 감지하며 PowerShell 5.1의 경우 `powershell.exe`로 폴백합니다. Bash 도구는 PowerShell 도구와 함께 등록되므로 Claude에 PowerShell을 사용하도록 요청해야 할 수 있습니다.

### 설정, hook 및 skill의 shell 선택

세 가지 추가 설정이 PowerShell이 사용되는 위치를 제어합니다:

* [`settings.json`](/ko/settings#available-settings)의 `"defaultShell": "powershell"`: 대화형 `!` 명령을 PowerShell을 통해 라우팅합니다. PowerShell 도구가 활성화되어야 합니다.
* 개별 [command hook](/ko/hooks#command-hook-fields)의 `"shell": "powershell"`: 해당 hook을 PowerShell에서 실행합니다. Hook은 PowerShell을 직접 생성하므로 `CLAUDE_CODE_USE_POWERSHELL_TOOL`에 관계없이 작동합니다.
* [skill frontmatter](/ko/skills#frontmatter-reference)의 `shell: powershell`: `` !`command` `` 블록을 PowerShell에서 실행합니다. PowerShell 도구가 활성화되어야 합니다.

### 미리보기 제한사항

PowerShell 도구는 미리보기 중에 다음과 같은 알려진 제한사항이 있습니다:

* PowerShell 프로필이 로드되지 않습니다
* Windows에서는 sandboxing이 지원되지 않습니다
* Windows에서 Claude Code를 시작하려면 Git Bash가 여전히 필요합니다

## 사용 가능한 도구 확인

정확한 도구 세트는 제공자, 플랫폼 및 설정에 따라 다릅니다. 실행 중인 세션에서 로드된 항목을 확인하려면 Claude에 직접 문의합니다:

```text theme={null}
What tools do you have access to?
```

Claude는 대화형 요약을 제공합니다. 정확한 MCP 도구 이름의 경우 `/mcp`를 실행합니다.

## 참고 항목

* [MCP 서버](/ko/mcp): 외부 서버를 연결하여 사용자 정의 도구 추가
* [권한](/ko/permissions): 권한 시스템, 규칙 구문, 도구별 패턴
* [Subagents](/ko/sub-agents): subagent에 대한 도구 접근 구성
* [Hooks](/ko/hooks-guide): 도구 실행 전후에 사용자 정의 명령 실행
