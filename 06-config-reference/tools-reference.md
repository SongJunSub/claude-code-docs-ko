> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 도구 참조

> Claude Code가 사용할 수 있는 도구의 완전한 참조 자료이며, 권한 요구사항 및 도구별 동작을 포함합니다.

Claude Code는 코드베이스를 이해하고 수정하는 데 도움이 되는 도구 세트에 접근할 수 있습니다. 도구 이름은 [권한 규칙](/ko/permissions#tool-specific-permission-rules), [subagent 도구 목록](/ko/sub-agents), 및 [hook 매처](/ko/hooks)에서 사용하는 정확한 문자열입니다. 도구를 완전히 비활성화하려면 [권한 설정](/ko/permissions#tool-specific-permission-rules)의 `deny` 배열에 해당 이름을 추가합니다.

사용자 정의 도구를 추가하려면 [MCP 서버](/ko/mcp)를 연결합니다. Claude를 재사용 가능한 프롬프트 기반 워크플로우로 확장하려면 [skill](/ko/skills)을 작성합니다. 이는 새로운 도구 항목을 추가하는 대신 기존 `Skill` 도구를 통해 실행됩니다.

| 도구                     | 설명                                                                                                                                                                                                                                                                                                                                                                                                                                   | 필요한 권한 |
| :--------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----- |
| `Agent`                | 작업을 처리하기 위해 자체 context window를 가진 [subagent](/ko/sub-agents)를 생성합니다. [Agent 도구 동작](#agent-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                          | 아니오    |
| `AskUserQuestion`      | 요구사항을 수집하거나 모호함을 명확히 하기 위해 객관식 질문을 합니다                                                                                                                                                                                                                                                                                                                                                                                               | 아니오    |
| `Bash`                 | 환경에서 shell 명령을 실행합니다. [Bash 도구 동작](#bash-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                                           | 예      |
| `CronCreate`           | 현재 세션 내에서 반복 또는 일회성 프롬프트를 예약합니다. 작업은 세션 범위이며 `--resume` 또는 `--continue`에서 만료되지 않으면 복원됩니다. [예약된 작업](/ko/scheduled-tasks) 참조                                                                                                                                                                                                                                                                                                           | 아니오    |
| `CronDelete`           | ID로 예약된 작업을 취소합니다                                                                                                                                                                                                                                                                                                                                                                                                                    | 아니오    |
| `CronList`             | 세션의 모든 예약된 작업을 나열합니다                                                                                                                                                                                                                                                                                                                                                                                                                 | 아니오    |
| `Edit`                 | 특정 파일에 대한 대상 편집을 수행합니다. [Edit 도구 동작](#edit-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                                         | 예      |
| `EnterPlanMode`        | Plan Mode로 전환하여 코딩 전에 접근 방식을 설계합니다                                                                                                                                                                                                                                                                                                                                                                                                   | 아니오    |
| `EnterWorktree`        | 격리된 [git worktree](/ko/worktrees)를 생성하고 전환합니다. 새로운 worktree를 생성하는 대신 현재 저장소의 기존 worktree로 전환하려면 `path`를 전달합니다. worktree 세션 내에서 또는 [`isolation: worktree`](/ko/sub-agents#supported-frontmatter-fields)와 같이 고정된 작업 디렉토리를 가진 subagent에서는 `path` 형식만 사용 가능하며 대상은 `.claude/worktrees/` 아래에 있어야 합니다                                                                                                                                       | 아니오    |
| `ExitPlanMode`         | 승인을 위한 계획을 제시하고 Plan Mode를 종료합니다                                                                                                                                                                                                                                                                                                                                                                                                     | 예      |
| `ExitWorktree`         | worktree 세션을 종료하고 원래 디렉토리로 돌아갑니다. [`isolation: worktree`](/ko/sub-agents#supported-frontmatter-fields)와 같이 자체 작업 디렉토리에서 이미 실행되는 subagent에서는 사용할 수 없습니다                                                                                                                                                                                                                                                                               | 아니오    |
| `Glob`                 | 패턴 매칭을 기반으로 파일을 찾습니다. [Glob 도구 동작](#glob-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                                           | 아니오    |
| `Grep`                 | 파일 내용에서 패턴을 검색합니다. [Grep 도구 동작](#grep-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                                              | 아니오    |
| `ListMcpResourcesTool` | 연결된 [MCP 서버](/ko/mcp)에서 노출된 리소스를 나열합니다                                                                                                                                                                                                                                                                                                                                                                                               | 아니오    |
| `LSP`                  | 언어 서버를 통한 코드 인텔리전스: 정의로 이동, 참조 찾기, 타입 오류 및 경고 보고. [LSP 도구 동작](#lsp-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                 | 아니오    |
| `Monitor`              | 백그라운드에서 명령을 실행하고 각 출력 라인을 Claude에 다시 전달하므로, Claude는 로그 항목, 파일 변경 또는 대화 중 폴링된 상태에 반응할 수 있습니다. [Monitor 도구](#monitor-tool) 참조                                                                                                                                                                                                                                                                                                          | 예      |
| `NotebookEdit`         | Jupyter 노트북 셀을 수정합니다. [NotebookEdit 도구 동작](#notebookedit-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                           | 예      |
| `PowerShell`           | PowerShell 명령을 기본적으로 실행합니다. [PowerShell 도구](#powershell-tool) 참조                                                                                                                                                                                                                                                                                                                                                                     | 예      |
| `PushNotification`     | 데스크톱 알림을 보내고, [Remote Control](/ko/remote-control)이 연결되었을 때 휴대폰 푸시를 보내므로, 장기 실행 작업 또는 [예약된 작업](/ko/scheduled-tasks)이 사용자가 자리를 떠났을 때 연락할 수 있습니다. {/* plan-availability: feature=push-notifications providers=anthropic */}푸시 전달은 Amazon Bedrock, Google Vertex AI 또는 Microsoft Foundry에서 접근할 수 없는 Anthropic 호스팅 인프라를 통해 실행됩니다                                                                                                         | 아니오    |
| `Read`                 | 파일의 내용을 읽습니다. [Read 도구 동작](#read-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                                                   | 아니오    |
| `ReadMcpResourceTool`  | URI로 특정 MCP 리소스를 읽습니다                                                                                                                                                                                                                                                                                                                                                                                                                | 아니오    |
| `RemoteTrigger`        | claude.ai에서 [Routines](/ko/routines)를 생성, 업데이트, 실행 및 나열합니다. `/schedule` 명령을 지원합니다. {/* plan-availability: feature=routines plans=pro,max,team,enterprise providers=anthropic */}Routines는 claude.ai에 있으며 Pro, Max, Team 또는 Enterprise 플랜이 필요하므로, 이 도구는 Amazon Bedrock, Google Vertex AI 또는 Microsoft Foundry에서 접근할 수 없습니다                                                                                                            | 아니오    |
| `ScheduleWakeup`       | [자체 속도 `/loop`](/ko/scheduled-tasks#let-claude-choose-the-interval)의 다음 반복을 다시 예약합니다. Claude는 각 반복이 끝날 때 이를 호출하여 다음 반복이 실행될 시간을 선택합니다(1분에서 1시간 사이). 사용자가 직접 호출하지는 않습니다. 대기 중인 wakeup은 [Stop hook input](/ko/hooks#stop-input)의 `session_crons`에 나타납니다. {/* plan-availability: feature=loop-dynamic providers=anthropic */}Amazon Bedrock, Google Vertex AI 또는 Microsoft Foundry에서는 사용할 수 없으며, 여기서 간격이 없는 `/loop` 프롬프트는 고정 일정으로 실행됩니다 | 아니오    |
| `SendMessage`          | [agent team](/ko/agent-teams) 팀원에게 메시지를 보내거나, agent ID로 [subagent를 재개합니다](/ko/sub-agents#resume-subagents). 중지된 subagent는 백그라운드에서 자동으로 재개됩니다. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`이 설정되었을 때만 사용 가능합니다                                                                                                                                                                                                                            | 아니오    |
| `ShareOnboardingGuide` | {/* plan-availability: feature=onboarding-guide-share plans=pro,max,team,enterprise providers=anthropic */}}`ONBOARDING.md`를 업로드하고 팀원이 Claude Code에서 열 수 있는 공유 링크를 반환합니다. 가이드가 작성된 후 `/team-onboarding`에서 호출됩니다. Pro, Max, Team 및 Enterprise 플랜의 claude.ai 구독자가 사용 가능합니다                                                                                                                                                             | 예      |
| `Skill`                | 주 대화 내에서 [skill](/ko/skills#control-who-invokes-a-skill)을 실행합니다                                                                                                                                                                                                                                                                                                                                                                      | 예      |
| `TaskCreate`           | 작업 목록에 새 작업을 생성합니다                                                                                                                                                                                                                                                                                                                                                                                                                   | 아니오    |
| `TaskGet`              | 특정 작업의 전체 세부 정보를 검색합니다                                                                                                                                                                                                                                                                                                                                                                                                               | 아니오    |
| `TaskList`             | 현재 상태와 함께 모든 작업을 나열합니다                                                                                                                                                                                                                                                                                                                                                                                                               | 아니오    |
| `TaskOutput`           | (더 이상 사용되지 않음) 백그라운드 작업에서 출력을 검색합니다. 작업의 출력 파일 경로에서 `Read`를 사용하는 것을 권장합니다                                                                                                                                                                                                                                                                                                                                                            | 아니오    |
| `TaskStop`             | ID로 실행 중인 백그라운드 작업을 종료합니다                                                                                                                                                                                                                                                                                                                                                                                                            | 아니오    |
| `TaskUpdate`           | 작업 상태, 종속성, 세부 정보를 업데이트하거나 작업을 삭제합니다                                                                                                                                                                                                                                                                                                                                                                                                 | 아니오    |
| `TeamCreate`           | 여러 팀원이 있는 [agent team](/ko/agent-teams)을 생성합니다. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`이 설정되었을 때만 사용 가능합니다                                                                                                                                                                                                                                                                                                                          | 아니오    |
| `TeamDelete`           | agent team을 해산하고 팀원 프로세스를 정리합니다. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`이 설정되었을 때만 사용 가능합니다                                                                                                                                                                                                                                                                                                                                         | 아니오    |
| `TodoWrite`            | {/* min-version: 2.1.142 */}세션 작업 체크리스트를 관리합니다. v2.1.142부터 기본적으로 비활성화되어 있으며 `TaskCreate`, `TaskGet`, `TaskList`, `TaskUpdate`를 선호합니다. `CLAUDE_CODE_ENABLE_TASKS=0`을 설정하여 다시 활성화합니다                                                                                                                                                                                                                                                   | 아니오    |
| `ToolSearch`           | [tool search](/ko/mcp#scale-with-mcp-tool-search)가 활성화되었을 때 지연된 도구를 검색하고 로드합니다                                                                                                                                                                                                                                                                                                                                                       | 아니오    |
| `WaitForMcpServers`    | {/* min-version: 2.1.142 */}백그라운드에서 여전히 연결 중인 하나 이상의 [MCP 서버](/ko/mcp)를 기다리므로, 요청이 세션을 다시 시작하지 않고도 해당 도구를 사용할 수 있습니다. Claude는 필요한 서버가 아직 연결되지 않았을 때 이를 호출합니다. [tool search](/ko/mcp#scale-with-mcp-tool-search)가 비활성화되었을 때만 나타나며, `ToolSearch`가 활성화되었을 때는 대기를 처리합니다                                                                                                                                                                  | 아니오    |
| `WebFetch`             | 지정된 URL에서 콘텐츠를 가져옵니다. [WebFetch 도구 동작](#webfetch-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                                   | 예      |
| `WebSearch`            | 웹 검색을 수행합니다. [WebSearch 도구 동작](#websearch-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                                          | 예      |
| `Workflow`             | [동적 워크플로우](/ko/workflows)를 실행합니다: 백그라운드에서 많은 subagent를 조율하고 하나의 통합된 결과를 반환하는 스크립트입니다                                                                                                                                                                                                                                                                                                                                                 | 예      |
| `Write`                | 파일을 생성하거나 덮어씁니다. [Write 도구 동작](#write-tool-behavior) 참조                                                                                                                                                                                                                                                                                                                                                                              | 예      |

## 권한 규칙 및 hook으로 도구 구성

대부분의 경우 Claude가 이러한 도구를 사용할 시기를 결정하며 Claude와 상호작용할 때 도구 이름을 직접 지정할 필요가 없습니다. 권한 및 기타 구성을 정의할 때 도구 이름을 직접 참조합니다:

* 설정의 [`permissions.allow` 및 `permissions.deny`](/ko/settings#available-settings) 및 `/permissions` 인터페이스에서
* Agent SDK의 [`allowedTools` 및 `disallowedTools`](/ko/agent-sdk/permissions#allow-and-deny-rules) 옵션에서
* [subagent의 `tools` 또는 `disallowedTools`](/ko/sub-agents#supported-frontmatter-fields) frontmatter에서
* [skill의 `allowed-tools`](/ko/skills#frontmatter-reference) frontmatter에서
* hook의 [`if` 조건](/ko/hooks-guide#filter-by-tool-name-and-arguments-with-the-if-field)에서

이들 모두 동일한 규칙 형식인 `ToolName(specifier)`를 허용합니다. specifier는 도구에 따라 다르며, 여러 도구가 형식을 공유합니다:

| 규칙 형식                          | 적용 대상                     | 세부 정보                                                    |
| :----------------------------- | :------------------------ | :------------------------------------------------------- |
| `Bash(npm run *)`              | Bash, Monitor             | [명령 패턴 매칭](/ko/permissions#bash)                         |
| `PowerShell(Get-ChildItem *)`  | PowerShell                | [명령 패턴 매칭](/ko/permissions#powershell)                   |
| `Read(~/secrets/**)`           | Read, Grep, Glob, LSP     | [경로 패턴 매칭](/ko/permissions#read-and-edit)                |
| `Edit(/src/**)`                | Edit, Write, NotebookEdit | [경로 패턴 매칭](/ko/permissions#read-and-edit)                |
| `Skill(deploy *)`              | Skill                     | [Skill 이름 매칭](/ko/skills#restrict-claude's-skill-access) |
| `Agent(Explore)`               | Agent                     | [Subagent 타입 매칭](/ko/permissions#agent-subagents)        |
| `WebFetch(domain:example.com)` | WebFetch                  | [도메인 매칭](/ko/permissions#webfetch)                       |
| `WebSearch`                    | WebSearch                 | specifier 없음; 도구 전체를 허용하거나 거부합니다                         |

`ExitPlanMode` 또는 `ShareOnboardingGuide`와 같이 여기에 나열되지 않은 도구는 specifier 없이 도구 이름만 허용합니다.

`Edit(...)` allow 규칙은 동일한 경로에 대한 읽기 접근도 부여하므로, 일치하는 `Read(...)` 규칙이 필요하지 않습니다.

Hook `matcher` 필드는 괄호로 묶인 규칙 형식이 아닌 도구 이름만 사용합니다. 매칭 규칙은 [matcher 패턴](/ko/hooks#matcher-patterns)을 참조합니다. 각 도구가 hook의 `tool_input`에 전달하는 필드 이름은 [PreToolUse 입력 참조](/ko/hooks#pretooluse-input)를 참조합니다.

## Agent 도구 동작

Agent 도구는 별도의 context window에서 subagent를 생성합니다. Subagent는 자신의 작업을 자율적으로 처리한 다음 단일 텍스트 결과를 부모 대화에 반환합니다. 부모는 subagent의 중간 도구 호출이나 출력을 보지 못하고, 최종 결과만 봅니다. Subagent가 실행하는 턴의 수를 제한하려면 [subagent 정의](/ko/sub-agents#supported-frontmatter-fields)에서 `maxTurns`를 설정합니다.

동일한 Agent 도구는 fork 모드가 활성화되었을 때 [forked subagent](/ko/sub-agents#fork-the-current-conversation)도 시작합니다. fork는 새로 시작하는 대신 전체 부모 대화를 상속하고, 항상 백그라운드에서 실행되며, 여전히 터미널에서 권한 프롬프트를 표시합니다. 이 섹션의 나머지 부분은 명명된 subagent를 설명합니다.

명명된 subagent가 사용할 수 있는 도구는 [subagent 정의](/ko/sub-agents)의 `tools` 및 `disallowedTools` 필드에 따라 다릅니다:

* **필드가 설정되지 않음**: subagent는 부모가 사용 가능한 모든 도구를 상속합니다.
* **`tools`만**: subagent는 나열된 도구만 가져옵니다.
* **`disallowedTools`만**: subagent는 나열된 도구를 제외한 모든 부모 도구를 가져옵니다.
* **둘 다 설정됨**: `disallowedTools`가 우선합니다. 둘 다에 나열된 도구는 제거됩니다.

Subagent를 시작하는 것 자체는 권한을 요청하지 않습니다. Subagent의 자체 도구 호출은 실행될 때 권한 규칙에 대해 확인됩니다:

* **포그라운드 subagent**는 각 도구 호출이 발생하는 순간 주 대화에서 보게 될 동일한 권한 프롬프트를 표시합니다.
* **백그라운드 subagent**는 프롬프트를 표시하지 않습니다. 이들은 세션에서 이미 부여된 권한으로 실행되고 그렇지 않으면 프롬프트를 표시할 도구 호출을 자동으로 거부합니다. 거부 후 subagent는 해당 도구 없이 계속 진행합니다.

Subagent가 먼저 도달할 수 있는 것을 제한하려면 `tools` 필드를 좁히고, Bash를 목록에서 제외하거나, [Subagent 기능 제어](/ko/sub-agents#control-subagent-capabilities)에서 설명한 대로 설정에서 거부 규칙을 설정합니다. 포그라운드와 백그라운드 중 선택에 대한 자세한 내용은 [Subagent를 포그라운드 또는 백그라운드에서 실행](/ko/sub-agents#run-subagents-in-foreground-or-background)을 참조합니다.

## Bash 도구 동작

Bash 도구는 다음의 지속성 동작으로 각 명령을 별도의 프로세스에서 실행합니다:

* Claude가 주 세션에서 `cd`를 실행할 때, 새로운 작업 디렉토리는 프로젝트 디렉토리 내에 머물러 있거나 `--add-dir`, `/add-dir`, 또는 설정의 `additionalDirectories`로 추가한 [추가 작업 디렉토리](/ko/permissions#working-directories) 내에 머물러 있는 한 이후 Bash 명령으로 이월됩니다. Subagent 세션은 절대 작업 디렉토리 변경을 이월하지 않습니다.
  * `cd`가 해당 디렉토리 외부로 이동하면, Claude Code는 프로젝트 디렉토리로 재설정하고 도구 결과에 `Shell cwd was reset to <dir>`을 추가합니다.
  * 모든 Bash 명령이 프로젝트 디렉토리에서 시작하도록 이 이월을 비활성화하려면 `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1`을 설정합니다.
* 환경 변수는 지속되지 않습니다. 한 명령의 `export`는 다음 명령에서 사용할 수 없습니다.
* 셸 시작 파일에 정의된 별칭 및 셸 함수를 사용할 수 있습니다. 세션 시작 시, Claude Code는 셸에 따라 `~/.zshrc`, `~/.bashrc`, 또는 `~/.profile`을 소싱하고, 결과 별칭, 함수 및 셸 옵션을 캡처하여 모든 Bash 명령에 적용합니다.

Claude Code를 시작하기 전에 virtualenv 또는 conda 환경을 활성화합니다. Bash 명령 전체에서 환경 변수를 지속하려면 Claude Code를 시작하기 전에 [`CLAUDE_ENV_FILE`](/ko/env-vars)을 셸 스크립트로 설정하거나, [SessionStart hook](/ko/hooks#persist-environment-variables)을 사용하여 동적으로 채웁니다.

두 가지 제한이 각 명령을 제한합니다:

* **Timeout**: 기본값은 2분입니다. Claude는 `timeout` 매개변수로 명령당 최대 10분을 요청할 수 있습니다. [`BASH_DEFAULT_TIMEOUT_MS` 및 `BASH_MAX_TIMEOUT_MS`](/ko/env-vars)로 기본값 및 상한을 재정의합니다.
* **출력 길이**: 기본값은 30,000자입니다. 명령이 그 이상을 생성하면, Claude Code는 전체 출력을 세션 디렉토리의 파일에 저장하고 Claude에 파일 경로와 시작 부분의 짧은 미리보기를 제공합니다. Claude는 나머지가 필요할 때 해당 파일을 읽거나 검색합니다. [`BASH_MAX_OUTPUT_LENGTH`](/ko/env-vars)로 제한을 높입니다. 최대 150,000자까지 가능합니다.

dev 서버 또는 watch 빌드와 같은 장기 실행 프로세스의 경우, Claude는 `run_in_background: true`를 설정하여 명령을 백그라운드 작업으로 시작하고 실행되는 동안 계속 작업할 수 있습니다. `/tasks`로 백그라운드 작업을 나열하고 중지합니다.

## Edit 도구 동작

Edit 도구는 정확한 문자열 교체를 수행합니다. `old_string`과 `new_string`을 가져와 첫 번째를 두 번째로 교체합니다. 정규식이나 fuzzy 매칭을 사용하지 않습니다.

편집이 적용되려면 세 가지 확인이 통과해야 합니다:

* **편집 전 읽기**: Claude는 현재 대화에서 파일을 읽었어야 하며, 해당 읽기 이후 파일이 디스크에서 변경되지 않았어야 합니다. 이 확인은 먼저 실행되며, 문자열 매칭 전에 실행됩니다.
* **매칭**: `old_string`은 파일에 정확히 작성된 대로 나타나야 합니다. 공백이나 들여쓰기의 단일 문자 차이도 미스하기에 충분합니다.
* **고유성**: `old_string`은 정확히 한 번 나타나야 합니다. 한 번 이상 나타나면, Claude는 한 발생을 고정하기에 충분한 주변 컨텍스트가 있는 더 긴 문자열을 제공하거나, `replace_all: true`를 설정하여 모두 교체합니다.

Bash로 파일을 보는 것도 명령이 단일 파일에 대한 `cat`, `head`, `tail`, 또는 `sed -n 'X,Yp'`일 때 파이프, 리다이렉트, 또는 기타 플래그가 없으면 편집 전 읽기 요구사항을 만족합니다. 파이프된 출력과 다른 Bash 명령은 계산되지 않으며, Claude는 이 경우 편집 전에 Read를 사용해야 합니다.

이는 편집 적격성에만 영향을 미치며, 권한에는 영향을 미치지 않습니다. [Read 및 Edit 거부 규칙](/ko/permissions#tool-specific-permission-rules)은 Claude Code가 `cat`, `head`, `tail` 및 `sed`와 같이 Bash에서 인식하는 파일 명령에도 적용되지만, 파일을 간접적으로 읽거나 쓰는 Python 또는 Node 스크립트와 같은 임의의 하위 프로세스에는 적용되지 않습니다. OS 수준 적용을 위해 모든 프로세스를 포함하려면 [sandbox를 활성화](/ko/sandboxing)합니다.

## Glob 도구 동작

Glob 도구는 이름 패턴으로 파일을 찾습니다. 재귀 디렉토리 매칭을 위한 `**`를 포함한 표준 glob 구문을 지원합니다:

* `**/*.js`는 모든 깊이의 모든 `.js` 파일과 일치합니다
* `src/**/*.ts`는 `src/` 아래의 모든 `.ts` 파일과 일치합니다
* `*.{json,yaml}`은 현재 디렉토리의 `.json` 및 `.yaml` 파일과 일치합니다

결과는 수정 시간으로 정렬되고 100개 파일로 제한됩니다. 상한에 도달하면, Claude는 결과에서 잘림 플래그를 보고 패턴을 좁힐 수 있습니다.

Glob은 기본적으로 `.gitignore`를 존중하지 않으므로, gitignored 파일을 추적된 파일과 함께 찾습니다. 이는 gitignored 파일을 건너뛰는 [Grep](#grep-tool-behavior)과 다릅니다. Glob이 `.gitignore`를 존중하도록 하려면 Claude Code를 시작하기 전에 `CLAUDE_CODE_GLOB_NO_IGNORE=false`를 설정합니다.

## Grep 도구 동작

Grep 도구는 파일 내용에서 패턴을 검색합니다. [Glob](#glob-tool-behavior)이 이름으로 파일을 찾는 경우, Grep은 파일 내부의 라인을 찾습니다.

Grep은 [ripgrep](https://github.com/BurntSushi/ripgrep)을 기반으로 하며 POSIX grep이 아닌 ripgrep의 정규식 구문을 사용합니다. 정규식 메타문자를 포함하는 패턴은 이스케이프가 필요합니다. 예를 들어, Go 코드에서 `interface{}`를 찾으려면 `interface\{\}` 패턴이 필요합니다.

세 가지 출력 모드는 반환되는 내용을 제어합니다:

* `files_with_matches`: 파일 경로만, 라인 내용 없음. 이것이 기본값입니다.
* `content`: 파일 및 라인 번호가 있는 일치하는 라인.
* `count`: 파일당 일치 수.

Claude는 `**/*.tsx`와 같은 `glob` 매개변수로 파일별로 결과를 범위 지정하거나, `py` 또는 `rust`와 같은 `type` 매개변수로 언어별로 범위 지정할 수 있습니다. 기본적으로 패턴은 단일 라인 내에서 일치합니다. Claude는 `multiline: true`를 설정하여 라인 경계를 넘어 일치시킬 수 있습니다.

Grep은 `.gitignore`를 존중하므로 gitignored 파일은 건너뜁니다. gitignored 파일을 검색하려면 Claude는 경로를 직접 전달합니다.

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

## NotebookEdit 도구 동작

NotebookEdit은 `cell_id`로 대상 셀을 지정하여 Jupyter 노트북을 한 번에 한 셀씩 수정합니다. 일반 파일에서 [Edit](#edit-tool-behavior)처럼 노트북 전체에서 문자열 교체를 수행하지 않습니다.

세 가지 편집 모드는 대상 셀에 발생하는 일을 제어합니다:

* `replace`: 셀의 소스를 덮어씁니다. 이것이 기본값입니다.
* `insert`: 대상 후에 새 셀을 추가합니다. `cell_id`가 없으면, 새 셀은 노트북의 시작 부분으로 이동합니다. `cell_type`을 `code` 또는 `markdown`으로 설정해야 합니다.
* `delete`: 대상 셀을 제거합니다.

권한 규칙은 `Edit(...)` 경로 형식을 사용합니다. `Edit(notebooks/**)`와 같은 규칙은 해당 디렉토리의 파일에 대한 NotebookEdit 호출을 포함합니다.

## PowerShell 도구

PowerShell 도구를 사용하면 Claude는 PowerShell 명령을 기본적으로 실행할 수 있습니다. Windows에서는 이것이 Git Bash를 통해 라우팅하는 대신 PowerShell에서 명령을 실행한다는 의미입니다. Git Bash가 없는 Windows에서는 도구가 자동으로 활성화됩니다. Git Bash가 설치된 Windows에서는 도구가 점진적으로 출시되고 있습니다. Linux, macOS 및 WSL에서는 도구가 옵트인입니다.

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

Windows에서 Claude Code는 PowerShell 7+의 경우 `pwsh.exe`를 자동 감지하며 PowerShell 5.1의 경우 `powershell.exe`로 폴백합니다. 도구가 활성화되면 Claude는 PowerShell을 기본 셸로 취급합니다. Bash 도구는 Git Bash가 설치되어 있을 때 POSIX 스크립트에 사용할 수 있습니다.

Claude Code는 프로세스 범위에서만 `-ExecutionPolicy Bypass`를 사용하여 PowerShell을 생성하므로 `.ps1` 스크립트 및 모듈 가져오기는 머신의 정책을 변경하지 않고도 기본 Windows 설치에서 작동합니다. 프로세스 범위 바이패스는 그룹 정책 `MachinePolicy` 또는 `UserPolicy`를 재정의하지 않으므로 엔터프라이즈 잠금이 여전히 적용됩니다. 머신의 유효한 실행 정책을 대신 존중하려면 `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY=1`을 설정합니다.

### 설정, hook 및 skill의 shell 선택

세 가지 추가 설정이 PowerShell이 사용되는 위치를 제어합니다:

* [`settings.json`](/ko/settings#available-settings)의 `"defaultShell": "powershell"`: 대화형 `!` 명령을 PowerShell을 통해 라우팅합니다. PowerShell 도구가 활성화되어야 합니다.
* 개별 [command hook](/ko/hooks#command-hook-fields)의 `"shell": "powershell"`: 해당 hook을 PowerShell에서 실행합니다. Hook은 PowerShell을 직접 생성하므로 `CLAUDE_CODE_USE_POWERSHELL_TOOL`에 관계없이 작동합니다.
* [skill frontmatter](/ko/skills#frontmatter-reference)의 `shell: powershell`: `` !`command` `` 블록을 PowerShell에서 실행합니다. PowerShell 도구가 활성화되어야 합니다.

Bash 도구 섹션에서 설명한 동일한 주 세션 작업 디렉토리 재설정 동작이 PowerShell 명령에 적용되며, `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` 환경 변수도 포함됩니다.

### 미리보기 제한사항

PowerShell 도구는 미리보기 중에 다음과 같은 알려진 제한사항이 있습니다:

* PowerShell 프로필이 로드되지 않습니다
* Windows에서는 sandboxing이 지원되지 않습니다

## Read 도구 동작

Read 도구는 파일 경로를 가져와 라인 번호가 있는 내용을 반환합니다. Claude는 항상 절대 경로를 전달하도록 지시됩니다.

기본적으로 Read는 시작 부분에서 파일을 반환합니다. 전체 파일 읽기가 토큰 제한을 초과하면, Read는 첫 번째 페이지를 `PARTIAL view` 공지와 함께 반환하며, 이는 Claude가 받은 파일의 양과 `offset` 및 `limit`으로 더 많이 읽는 방법을 알려줍니다. 명시적 `offset` 또는 `limit`을 전달하고 여전히 토큰 제한을 초과하는 읽기는 오류를 반환합니다.

Read는 일반 텍스트 이상의 여러 파일 타입을 처리합니다:

* **이미지**: PNG, JPG 및 기타 이미지 형식은 원본 바이트가 아닌 Claude가 볼 수 있는 시각적 콘텐츠로 반환됩니다. Claude Code는 모델의 이미지 크기 제한에 맞도록 큰 이미지를 크기 조정하고 재압축하므로, Claude는 큰 스크린샷의 축소된 버전을 볼 수 있습니다. Claude가 큰 이미지에서 세밀한 픽셀 수준의 세부 정보를 놓치면, 예를 들어 ImageMagick을 통해 Bash로 관심 영역을 먼저 자르도록 요청합니다.
* **PDF**: Claude는 짧은 `.pdf` 파일을 전체적으로 읽습니다. 10페이지보다 긴 PDF의 경우, `"1-5"`와 같은 `pages` 매개변수로 범위에서 읽으며, 한 번에 최대 20페이지까지 읽습니다.
* **Jupyter 노트북**: `.ipynb` 파일은 코드, markdown 및 시각화를 포함한 모든 셀과 해당 출력을 반환합니다.

Read는 파일만 읽으며, 디렉토리는 읽지 않습니다. Claude는 Bash 도구를 통해 `ls`를 사용하여 디렉토리 내용을 나열합니다.

## WebFetch 도구 동작

WebFetch는 URL과 추출할 내용을 설명하는 프롬프트를 가져옵니다. 페이지를 가져오고, 서버가 HTML을 반환할 때 응답을 Markdown으로 변환하며, 작고 빠른 모델을 사용하여 콘텐츠에 대해 프롬프트를 실행합니다. 대부분의 가져오기의 경우, Claude는 원본 페이지가 아닌 해당 모델의 답변을 받습니다. 변환 단계는 구성할 수 없습니다.

이는 WebFetch를 설계상 손실이 있게 만듭니다. 추출 프롬프트는 Claude에 도달하는 내용을 결정하므로, 페이지가 무언가를 언급하지 않는다는 결과는 프롬프트가 그것을 묻지 않았다는 의미일 수 있습니다. Claude에 더 구체적인 프롬프트로 다시 가져오도록 요청하거나, 처리되지 않은 페이지의 경우 Bash를 통해 `curl`을 사용합니다.

몇 가지 동작이 Claude가 받는 응답을 형성합니다:

* HTTP URL은 자동으로 HTTPS로 업그레이드됩니다.
* 큰 페이지는 처리 전에 고정 문자 제한으로 잘립니다.
* 응답은 15분 동안 캐시되므로, 동일한 URL의 반복 가져오기는 빠르게 반환됩니다.
* URL이 다른 호스트로 리다이렉트되면, WebFetch는 원본 URL과 리다이렉트 대상의 이름을 지정하는 텍스트 결과를 반환하고 따라가지 않습니다. Claude는 두 번째 WebFetch 호출로 새 URL을 가져옵니다.

기본 및 `acceptEdits` 권한 모드에서 WebFetch는 새 도메인에 처음 도달할 때 프롬프트합니다. 프롬프트 없이 미리 도메인을 허용하려면 `WebFetch(domain:example.com)`과 같은 권한 규칙을 추가합니다. `auto` 및 `bypassPermissions` [권한 모드](/ko/permissions#permission-modes)는 프롬프트를 완전히 건너뜁니다.

WebFetch는 `Claude-User`로 시작하는 `User-Agent` 헤더와 콘텐츠 협상을 지원하는 서버가 Markdown을 직접 반환할 수 있도록 HTML보다 Markdown을 선호하는 `Accept` 헤더를 설정합니다. [Sandbox](/ko/sandboxing) 네트워크 규칙은 별도로 구성되므로, sandboxed 프로세스가 도달하기를 원하는 도메인은 여전히 명시적 sandbox 권한 규칙이 필요합니다.

## WebSearch 도구 동작

WebSearch는 Anthropic의 [web search](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-search-tool) 백엔드에 대해 쿼리를 실행하고 결과 제목과 URL을 반환합니다. 결과 페이지를 가져오지 않습니다. Claude가 검색 결과에서 찾은 페이지를 읽으려면 [WebFetch](#webfetch-tool-behavior)로 후속 조치합니다.

이 도구는 호출당 최대 8개의 백엔드 검색을 발행하여 반환 전에 검색을 내부적으로 개선할 수 있습니다. Claude는 `allowed_domains`로 특정 호스트만 포함하거나 `blocked_domains`로 제외하여 결과를 범위 지정할 수 있습니다. 두 목록은 단일 호출에서 결합할 수 없습니다.

검색 백엔드는 구성할 수 없습니다. 다른 제공자로 검색하려면 검색 도구를 노출하는 [MCP 서버](/ko/mcp)를 추가합니다.

WebSearch 권한 규칙은 specifier를 사용하지 않습니다. `allow` 또는 `deny`의 단순 `WebSearch` 항목이 유일한 형식입니다.

<Note>
  WebSearch는 Claude API 및 Microsoft Foundry에서 사용 가능합니다. Google Cloud Vertex AI에서는 Opus, Sonnet 및 Haiku를 포함한 Claude 4 모델과 함께 작동합니다. Amazon Bedrock은 서버 측 web search 도구를 노출하지 않습니다.
</Note>

## Write 도구 동작

Write 도구는 제공된 전체 콘텐츠로 새 파일을 생성하거나 기존 파일을 덮어씁니다. 추가하거나 병합하지 않습니다.

대상 경로가 이미 존재하면, Claude는 현재 대화에서 해당 파일을 최소한 한 번 읽었어야 합니다. 읽지 않은 기존 파일에 대한 Write는 오류로 실패합니다. 이 제약은 새 파일에는 적용되지 않습니다.

Bash로 파일을 보는 것도 [Edit 도구 동작](#edit-tool-behavior)에서 설명한 대로 이 요구사항을 만족합니다.

기존 파일에 대한 부분 변경의 경우, Claude는 Write 대신 Edit을 사용합니다.

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
