> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 구성 디버깅하기

> CLAUDE.md, 설정, 훅, MCP 서버 또는 스킬이 적용되지 않는 이유를 진단합니다. /context, /doctor, /hooks, /mcp를 사용하여 실제로 로드된 항목을 확인합니다.

Claude가 명령을 무시하거나 구성한 기능이 나타나지 않을 때, 원인은 보통 파일이 로드되지 않았거나, 예상과 다른 위치에서 로드되었거나, 다른 파일이 이를 재정의했기 때문입니다. 이 가이드는 Claude Code가 실제로 로드한 항목을 검사하여 어느 경우에 해당하는지 좁혀나가는 방법을 보여줍니다.

설치, 인증 및 연결 문제의 경우 대신 [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md)을 참조하십시오.

## 컨텍스트에 로드된 항목 확인

`/context` 명령은 현재 세션의 컨텍스트 윈도우를 차지하는 모든 항목을 시스템 프롬프트, 시스템 도구, MCP 도구, 사용자 정의 서브에이전트(로드된 소스 포함), 메모리 파일, 스킬 및 대화 메시지로 분류하여 표시합니다. 먼저 이를 실행하여 `CLAUDE.md`, 규칙 또는 스킬 설명이 실제로 존재하는지 확인합니다. `/context`의 스킬 섹션에는 `/skills`에서 나열하지 않는 [번들 스킬](https://code.claude.com/docs/ko/skills.md#bundled-skills)도 포함됩니다.

특정 카테고리에 대한 세부 정보는 전용 명령으로 팔로우업합니다:

| 명령 | 표시 내용 |
| :- | :- |
| `/memory` | 사용자 및 프로젝트 범위의 메모리 파일 위치(편집기에서 각각을 열 수 있는 옵션 포함), 자동 메모리 폴더 및 자동 메모리 토글에 대한 액세스 |
| `/skills` | 프로젝트, 사용자 및 플러그인 소스의 사용 가능한 스킬 |
| `/hooks` | 활성 훅 구성 |
| `/mcp` | 연결된 MCP 서버 및 해당 상태 |
| `/permissions` | 현재 적용 중인 허용 및 거부 규칙 |
| `/doctor` | 설정 점검: 설치 상태, 잘못된 설정 파일, 사용하지 않는 확장 프로그램, 동일한 디렉토리의 중복 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md) 이름 및 Claude가 코드베이스에서 파생할 수 있는 체크인된 `CLAUDE.md` 콘텐츠(제안된 수정 사항 포함) |
| `/debug [issue]` | 세션에 대해 디버그 로깅을 활성화하고 Claude가 로그 출력 및 설정 경로를 사용하여 진단하도록 프롬프트합니다 |
| `/status` | 활성 설정 소스, 관리 설정이 적용 중인지 여부 포함 |

메모리 파일이 `/context` 분류에서 누락된 경우, [CLAUDE.md 파일이 로드되는 방식](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load)에 대해 해당 위치를 확인합니다. 하위 디렉토리 `CLAUDE.md` 파일은 세션 시작 시가 아니라 필요할 때 로드되므로 해당 분류에 나타나지 않습니다.

`/context`가 파일이 로드되었음을 확인했지만 Claude가 여전히 특정 명령을 따르지 않는 경우, 문제는 파일이 로드되었는지 여부가 아니라 명령이 작성된 방식일 가능성이 높습니다. CLAUDE.md는 새로운 팀원에게 제공할 지침(예: 프로젝트 규칙, 빌드 명령 및 파일 위치)에 적합합니다.

명령이 여러 방식으로 해석될 수 있을 정도로 모호할 때, 두 파일이 상충하는 지시를 제공할 때, 또는 파일이 충분히 길어서 개별 규칙이 덜 주목받을 때 준수가 감소합니다. [효과적인 명령 작성](https://code.claude.com/docs/ko/memory.md#write-effective-instructions)은 준수를 높게 유지하는 특이성, 크기 및 구조 패턴을 다룹니다.

> [!NOTE]
>
> CLAUDE.md와 권한은 서로 다른 문제를 해결합니다. CLAUDE.md는 Claude에게 프로젝트가 어떻게 작동하는지 알려주어 좋은 결정을 내리도록 합니다. [권한](https://code.claude.com/docs/ko/permissions.md) 및 [훅](https://code.claude.com/docs/ko/hooks.md)은 Claude가 무엇을 결정하든 제한을 강제합니다. CLAUDE.md는 "우리는 여기서 이렇게 합니다"에 사용합니다. 권한 또는 훅은 보안 경계 및 절대 발생해서는 안 되는 모든 것에 사용하며, 지침 대신 보장이 필요합니다.

## 해결된 설정 확인

설정은 관리, 사용자, 프로젝트 및 로컬 범위에 걸쳐 병합됩니다. 관리 설정은 존재할 때 항상 우선합니다. 나머지 중에서는 더 가까운 범위가 로컬, 프로젝트, 사용자 순서로 더 넓은 범위를 재정의합니다. 일부 설정은 또한 명령줄 플래그 또는 [환경 변수](https://code.claude.com/docs/ko/env-vars.md)로 설정할 수 있으며, 이는 또 다른 재정의 계층으로 작동합니다. 설정이 적용되지 않는 것처럼 보일 때, 설정한 값은 보통 다른 범위 또는 환경 변수에 의해 재정의되고 있습니다.

잘못된 설정 파일을 찾으려면 터미널에서 `claude doctor`를 실행합니다. 이는 세션을 시작하지 않고 읽기 전용 설치 및 설정 진단을 출력합니다. 수정 사항을 제안하고 적용하기 전에 확인하는 전체 점검을 위해 세션 내에서 [`/doctor`](https://code.claude.com/docs/ko/commands#all-commands)를 실행합니다.

`/status`를 실행하여 관리 설정이 적용 중인지 여부를 포함하여 활성 설정 소스를 확인합니다. 주어진 키에 대해 Claude Code가 사용하는 범위를 이해하려면 [설정 우선순위](https://code.claude.com/docs/ko/settings.md#settings-precedence)를 참조합니다.

## MCP 서버 확인

`/mcp`를 실행하면 구성된 모든 서버와 각 서버의 연결 상태, 그리고 현재 프로젝트에 대해 해당 서버를 승인했는지 여부를 확인할 수 있습니다. 서버가 올바르게 정의되어 있더라도 몇 가지 일반적인 이유로 도구를 제공하지 않을 수 있습니다.

* `.mcp.json`의 프로젝트 범위 서버는 일회성 승인이 필요합니다. 프롬프트를 닫았다면 `/mcp`에서 승인할 때까지 서버는 비활성화된 상태로 유지됩니다.
* 시작에 실패한 서버는 `/mcp`에서 실패로 표시됩니다. `command` 또는 `args`의 상대 파일 경로가 흔한 원인인데, 이러한 경로는 `.mcp.json`의 위치가 아니라 Claude Code를 실행한 디렉터리를 기준으로 해석되기 때문입니다.
* 연결됨으로 표시되지만 도구가 0개로 나열되는 서버는 정상적으로 시작되었으나 도구 목록을 반환하지 않는 상태입니다. `/mcp`에서 **Reconnect**를 선택합니다. 도구 수가 계속 0개라면 `claude --debug=mcp`를 실행하고 `~/.claude/debug/<session-id>.txt`의 디버그 로그에서 서버의 stderr를 확인합니다.

구성 위치와 범위 규칙은 [MCP](https://code.claude.com/docs/ko/mcp.md)를 참조하세요.

## 훅 확인

`/hooks`를 실행하여 현재 세션에 등록된 모든 훅을 이벤트별로 그룹화하여 나열합니다. 정의한 훅이 나타나지 않으면 Claude Code가 해당 훅을 로드하지 않은 것입니다. 다음 원인을 확인하십시오:

* 훅이 독립 실행형 파일에 정의되어 있습니다. 훅은 [설정 파일](https://code.claude.com/docs/ko/settings.md#settings-files)의 `"hooks"` 키 아래에 있어야 합니다.
* `matcher` 값이 단일 문자열이 아닌 배열입니다. Claude Code는 대화형 세션을 시작할 때와 `claude doctor`에서 해당 항목을 잘못된 설정으로 나열합니다. 배열이 `PreToolUse` 또는 `PermissionRequest` 아래에 있으면 해당 파일의 다른 훅도 모두 로드되지 않습니다.
* 훅이 스킬의 frontmatter에 있으며, 이 세션에서 사용자나 Claude가 아직 해당 스킬을 호출하지 않았습니다. 스킬을 호출하거나 Claude에게 호출하도록 요청한 다음 `/hooks`를 다시 실행하십시오. 그래도 훅이 나타나지 않으면 [파싱되지 않은 frontmatter](https://code.claude.com/docs/ko/skills.md#skill-not-triggering)나 [스킬 훅의 제한 사항](https://code.claude.com/docs/ko/hooks.md#limits-on-skill-hooks) 중 하나와 같은 다른 원인을 확인하십시오.

훅이 나타나지만 실행되지 않으면, 매처가 보통 원인입니다. 다음 실수를 확인하십시오:

* `matcher` 필드는 여러 도구 이름을 일치시키기 위해 `|`를 사용하는 단일 문자열입니다(예: `"Edit|Write"`). `,` 구분 기호는 동등하므로 `"Edit,Write"`는 동일한 도구를 일치시킵니다. v2.1.191 이전에는 쉼표가 정규식 평가로 넘어가고 매처가 일치하지 않으므로, v2.1.191이 아직 아니면 `|`를 사용하십시오.
* 잘못된 도구 이름은 아무것도 일치하지 않는 매처를 생성하므로 훅이 자동으로 실패합니다.

`settings.json`을 편집하면 파일 안정성 지연 후 실행 중인 세션에서 변경 사항이 적용됩니다. 세션이 시작된 후 파일이나 프로젝트의 `.claude/` 폴더를 생성한 경우에도 다시 시작할 필요가 없습니다. v2.1.257 이전에는 Claude Code가 세션이 시작된 후 생성된 `.claude/` 폴더의 편집을 감지하지 못했습니다.

저장 후 몇 초가 지났는데도 `/hooks`가 여전히 이전 정의를 표시하면 `/hooks`를 다시 실행하여 보기를 새로 고칩니다.

`/hooks`가 훅을 표시하지만 여전히 실행되지 않으면, 다음 단계는 훅 평가를 실시간으로 감시하는 것입니다. `claude --debug`로 세션을 시작하고 도구 호출을 트리거합니다. 디버그 로그는 각 이벤트, 확인된 매처 및 훅의 종료 코드와 출력을 기록합니다. 로그 형식은 [훅 디버깅](https://code.claude.com/docs/ko/hooks.md#debug-hooks)을 참조하고 일반적인 실패 패턴은 [훅 문제 해결](https://code.claude.com/docs/ko/hooks-guide.md#limitations-and-troubleshooting)을 참조합니다.

## 깨끗한 구성에 대해 테스트

[`claude --safe-mode`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 시작합니다. 이는 다음을 포함한 사용자 정의가 비활성화된 세션을 시작합니다.

* `CLAUDE.md`
* 스킬, 플러그인 및 훅
* MCP 서버
* 사용자 정의 명령 및 에이전트
* 사용자 정의 출력 스타일
* 사용자 정의 키보드 단축키

인증, 모델 선택, 기본 제공 도구 및 권한은 정상적으로 작동합니다. 안전 모드에서 문제가 사라지면, 비활성화한 항목 중 하나로 원인이 좁혀진 것입니다. 어느 것인지 찾으려면 [컨텍스트에 로드된 항목 확인](#see-what-loaded-into-context), [MCP 서버 확인](#check-mcp-servers) 또는 [훅 확인](#check-hooks)과 같이 해당 항목에 대한 확인 방법을 사용합니다.

안전 모드는 여전히 조직의 관리형 훅 및 설정 정책을 적용합니다. 관리형 플러그인, 스킬, `CLAUDE.md` 및 MCP 서버는 꺼집니다.

안전 모드에서 문제가 지속되거나 설정 자체가 의심스러우면, 사용자 자신의 구성이 전혀 없는 세션을 시작하여 문제가 계속 나타나는지 확인합니다.

**1. 빈 디렉토리를 만들고 해당 디렉토리로 이동**

Claude Code 세션이 실행되지 않은 상태에서 셸에서 디렉토리를 만들고 해당 디렉토리로 이동합니다.

> [tab] Bash or Zsh
>
> ```bash theme={null}
> mkdir -p ~/claude-clean/empty && cd ~/claude-clean/empty
> ```

> [tab] PowerShell
>
> ```powershell theme={null}
> New-Item -ItemType Directory -Force "$HOME/claude-clean/empty" | Out-Null
> Set-Location "$HOME/claude-clean/empty"
> ```

**2. 깨끗한 구성 디렉토리로 Claude Code 시작**

같은 셸에서 [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars)을 `~/.claude` 대신 새 디렉토리로 설정하고, [`--setting-sources user`](https://code.claude.com/docs/ko/cli-reference#cli-flags)를 전달하여 `.claude/settings.json`, `CLAUDE.md`, `.mcp.json`과 같은 프로젝트 구성을 끕니다.

> [tab] Bash or Zsh
>
> 이 변수는 이번 한 번의 실행에만 적용됩니다.
>
> ```bash theme={null}
> CLAUDE_CONFIG_DIR=~/claude-clean/config claude --setting-sources user
> ```

> [tab] PowerShell
>
> 이 변수는 현재 PowerShell 세션이 끝날 때까지 설정된 상태로 유지되므로, 같은 창에서 이후에 실행하는 `claude`도 계속 깨끗한 디렉토리를 사용합니다. 평소 사용하는 디렉토리로 돌아가려면 다음 실행 전에 `Remove-Item Env:CLAUDE_CONFIG_DIR`을 실행합니다.
>
> ```powershell theme={null}
> $env:CLAUDE_CONFIG_DIR = "$HOME/claude-clean/config"
> claude --setting-sources user
> ```

첫 번째 실행 시 첫 실행 설정 화면을 다시 거치게 되며, 이는 깨끗한 구성 디렉토리가 적용 중이라는 표시입니다. 관리형 설정은 여전히 적용되며, claude.ai 계정으로 로그인하면 [커넥터](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai)도 계속 로드됩니다.

**3. 문제 재현**

깨끗한 세션에서 문제를 일으킨 작업을 반복합니다.

* **문제가 사라진 경우**: 원인은 사용자 또는 프로젝트 구성에 있습니다. `~/.claude.json`과 `~/.claude`의 파일을 한 번에 하나씩 `~/claude-clean/config`로 복사합니다. 어느 파일로도 문제가 다시 나타나지 않으면, 같은 셸에서 프로젝트 디렉토리로 이동하여 `--setting-sources user` 없이 Claude Code를 시작합니다. Bash 또는 Zsh에서는 `CLAUDE_CONFIG_DIR=~/claude-clean/config claude`를 실행합니다. PowerShell에서는 변수가 아직 설정되어 있으므로 `claude`를 실행합니다.
* **문제가 지속되는 경우**: 원인은 사용자 및 프로젝트 구성 외부에 있습니다. 세션에서 `/status`를 실행하여 관리형 설정을 확인하고, 셸에서 [환경 변수](https://code.claude.com/docs/ko/env-vars.md)를 확인한 다음, [문제 해결](https://code.claude.com/docs/ko/troubleshooting.md)을 참조합니다.

## 일반적인 원인 확인

대부분의 구성 문제는 작은 위치 및 구문 규칙 집합으로 추적됩니다. 버그라고 가정하기 전에 다음을 확인하세요:

| 증상 | 원인 | 해결 방법 |
| :- | :- | :- |
| Hook이 실행되지 않음 | `matcher`가 문자열 대신 JSON 배열입니다 | 여러 도구를 일치시키려면 `\|`를 사용하는 단일 문자열을 사용하세요. 예를 들어 `"Edit\|Write"`입니다. [matcher 패턴](https://code.claude.com/docs/ko/hooks.md#matcher-patterns)을 참조하세요. |
| Hook이 실행되지 않음 | `matcher`가 v2.1.191 이전 버전에서 `,`를 구분 기호로 사용합니다 | Claude Code v2.1.191 이상에서는 `,`를 `\|`처럼 목록 구분 기호로 처리합니다. 이전 버전에서는 쉼표를 리터럴 문자로 평가하므로 `"Edit,Write"`는 아무것도 일치하지 않습니다. 대신 `\|`를 사용하거나 Claude Code를 업그레이드하세요. |
| Hook이 실행되지 않음 | `matcher` 값이 소문자입니다. 예를 들어 `"bash"` | 일치는 대소문자를 구분합니다. 도구 이름은 대문자로 표기됩니다: `Bash`, `Edit`, `Write`, `Read`. |
| Hook이 실행되지 않음 | Hook이 `settings.json` 대신 독립 실행형 파일에 정의되어 있습니다 | 프로젝트 또는 사용자 구성에 대한 독립 실행형 hook 파일이 없습니다. `settings.json`의 `"hooks"` 키 아래에 hook을 정의하세요. [플러그인](https://code.claude.com/docs/ko/plugins/components.md#hooks)만 별도의 `hooks/hooks.json`을 로드합니다. [hook 구성](https://code.claude.com/docs/ko/hooks.md)을 참조하세요. |
| 전역으로 설정된 권한 또는 hook이 무시됩니다 | 구성이 `~/.claude.json`에 추가되었습니다 | `~/.claude.json`은 앱 상태 및 UI 토글을 보유합니다. `permissions`, `hooks`, `env`는 `~/.claude/settings.json`에 속합니다. 이 두 파일은 다릅니다. |
| `settings.json` 값이 무시되는 것처럼 보입니다 | 동일한 키가 `settings.local.json`에 설정되어 있습니다 | `settings.local.json`은 `settings.json`을 재정의하고, 둘 다 `~/.claude/settings.json`을 재정의합니다. [설정 우선순위](https://code.claude.com/docs/ko/settings.md#settings-precedence)를 참조하세요. |
| Skill이 `/skills`에 나타나지 않습니다 | Skill 파일이 폴더 대신 `.claude/skills/name.md`에 있습니다 | 폴더 내에 `SKILL.md`를 사용하세요: `.claude/skills/name/SKILL.md`. |
| Skill이 `/skills`에 나타나지만 Claude가 호출하지 않습니다 | Skill의 frontmatter에 `disable-model-invocation: true`가 있거나, 설명이 요청을 표현하는 방식과 일치하지 않습니다 | `/skills`의 배지를 확인하세요: "user-only" 레이블은 Claude가 자동으로 트리거하지 않음을 의미합니다. [skill 호출](https://code.claude.com/docs/ko/skills.md)을 참조하세요. |
| 하위 디렉토리 `CLAUDE.md` 지침이 무시되는 것처럼 보입니다 | 하위 디렉토리 파일은 세션 시작 시가 아니라 필요에 따라 로드됩니다 | 하위 디렉토리의 `CLAUDE.md`를 로드하려면 Claude에게 해당 하위 디렉토리의 다른 파일을 읽도록 요청하세요. [하위 디렉토리 파일이 로드되는 시점](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load)을 참조하세요. |
| 서브에이전트가 `CLAUDE.md` 지침을 무시합니다 | 기본 제공 Explore 및 Plan 에이전트는 시작 시 `CLAUDE.md`를 건너뜁니다. 사용자 정의 서브에이전트는 정의에 [`omitClaudeMd`](https://code.claude.com/docs/ko/sub-agents#supported-frontmatter-fields)가 설정되어 있지 않는 한 메인 대화와 동일한 방식으로 로드합니다 | Explore 또는 Plan의 경우 위임 프롬프트에서 지침을 다시 명시하세요. `omitClaudeMd`를 설정하는 서브에이전트의 경우 필드를 제거하세요. 다른 사용자 정의 서브에이전트의 경우 중요한 지침을 에이전트 파일 본문에 넣으세요. 이는 에이전트의 시스템 프롬프트가 됩니다. [시작 시 로드되는 항목](https://code.claude.com/docs/ko/sub-agents.md#what-loads-at-startup)을 참조하세요. |
| 세션 종료 시 정리 로직이 실행되지 않습니다 | `SessionEnd` hook이 구성되지 않았습니다 | `settings.json`에 `SessionEnd` hook을 추가하세요. [hook 이벤트 목록](https://code.claude.com/docs/ko/hooks.md#hook-events)을 참조하세요. |
| `.mcp.json`의 MCP 서버가 로드되지 않습니다 | 파일이 `.claude/` 아래에 있거나, 서버가 VS Code의 `mcp.json`처럼 최상위 `servers` 키 아래에 있으며, `mcpServers` 대신 | 프로젝트 MCP 구성은 `.claude/` 내부가 아닌 저장소 루트에 `.mcp.json`으로 이동하며, 서버는 `mcpServers` 키 아래에 있습니다. [MCP 구성](https://code.claude.com/docs/ko/mcp.md)을 참조하세요. |
| `settings.json`의 `mcpServers` 아래에 추가된 MCP 서버가 나타나지 않습니다 | `settings.json`이 `mcpServers` 키를 읽지 않습니다 | 저장소 루트의 `.mcp.json`에서 프로젝트 서버를 정의하거나 사용자 범위 서버의 경우 `claude mcp add --scope user`를 실행하세요. [MCP 구성](https://code.claude.com/docs/ko/mcp.md)을 참조하세요. |
| 프로젝트 MCP 서버가 추가되었지만 나타나지 않습니다 | 일회성 승인 프롬프트가 해제되었습니다 | 프로젝트 범위 서버에는 승인이 필요합니다. `/mcp`를 실행하여 상태를 확인하고 승인하세요. |
| MCP 서버가 일부 디렉토리에서 시작하지 못합니다 | `command` 또는 `args`가 상대 파일 경로를 사용합니다 | 로컬 스크립트에 절대 경로를 사용하세요. `PATH`의 `npx` 또는 `uvx`와 같은 실행 파일은 그대로 작동합니다. |
| MCP 서버가 예상 환경 변수 없이 시작됩니다 | 서버의 구성 항목이 설정하지 않으며, Claude Code가 stdio 서버에 전달하는 환경에 없습니다: 자체 환경에서 [하위 프로세스에서 제거하는 변수](https://code.claude.com/docs/ko/monitoring-usage.md#administrator-configuration)를 뺀 것 | 서버의 `.mcp.json` 항목 내에서 서버별 `env`를 설정하세요. 이는 시작 환경이나 작업 영역 신뢰에 따라 달라지지 않습니다. |
| `Bash(rm *)` 거부 규칙이 `/bin/rm` 또는 `find -delete`를 차단하지 않습니다 | Bash 규칙은 기본 실행 파일이 아닌 리터럴 명령 문자열과 일치합니다. [Bash 규칙이 일치하지 않는 항목](https://code.claude.com/docs/ko/permissions.md#bash-rule-limits)을 참조하세요 | 확실한 보장을 위해 [PreToolUse hook](https://code.claude.com/docs/ko/hooks-guide.md) 또는 [sandbox](https://code.claude.com/docs/ko/sandboxing.md)를 사용하세요. |

## 관련 리소스

각 구성 표면에 대한 전체 참조는 전용 페이지를 참조합니다:

* **[`.claude` 디렉토리 참조](https://code.claude.com/docs/ko/claude-directory)**: 모든 구성 파일 위치 및 읽는 항목
* **[설정](https://code.claude.com/docs/ko/settings.md)**: 사용할 파일 및 Claude Code가 사용하는 값; [설정 참조](https://code.claude.com/docs/ko/settings-reference.md)에 전체 키 목록이 있습니다
* **[훅 참조](https://code.claude.com/docs/ko/hooks.md)**: 이벤트 이름, 페이로드 및 `--debug` 출력 형식
* **[MCP](https://code.claude.com/docs/ko/mcp.md)**: 서버 구성, 승인 및 `/mcp` 출력
* **[설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md)**: `command not found`, PATH 및 인증 문제
* **[문제 해결](https://code.claude.com/docs/ko/troubleshooting.md)**: 성능, 응답 중단 및 검색 문제
