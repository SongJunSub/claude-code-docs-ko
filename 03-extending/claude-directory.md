> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# .claude 디렉토리 탐색

> Claude Code가 CLAUDE.md, settings.json, hooks, skills, commands, subagents, workflows, rules, auto memory를 읽는 위치입니다. 프로젝트의 .claude 디렉토리와 홈 디렉토리의 ~/.claude를 탐색합니다.

Claude Code는 프로젝트 디렉토리와 홈 디렉토리의 `~/.claude`에서 지침, 설정, skills, subagents, 메모리를 읽습니다. 프로젝트 파일을 git에 커밋하여 팀과 공유합니다. `~/.claude`의 파일은 모든 프로젝트에 적용되는 개인 설정입니다.

Windows에서 `~/.claude`는 `%USERPROFILE%\.claude`로 확인됩니다. [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars)을 설정하면, 이 페이지의 모든 `~/.claude` 경로가 대신 해당 디렉터리 아래에 있습니다. 이는 `.claude.json`에도 동일하게 적용되며, 그렇지 않은 경우 이 파일은 `~/.claude.json`에 있습니다.

대부분의 사용자는 `CLAUDE.md`와 `settings.json`만 편집합니다. 저장소에 이미 다른 코딩 에이전트용 `AGENTS.md`가 있는 경우, Claude Code는 `CLAUDE.md` 대신 [해당 파일을 읽을 수 있습니다](https://code.claude.com/docs/ko/memory.md#agents-md). 디렉터리의 나머지는 선택 사항입니다. 필요에 따라 스킬, 규칙, 서브에이전트를 추가합니다.

## 디렉토리 탐색

트리의 파일을 클릭하여 각 파일이 무엇을 하는지, 언제 로드되는지, 예제를 확인합니다.

## 표시되지 않는 항목

탐색기는 작성하고 편집하는 파일을 다룹니다. 관련된 몇 가지 파일은 다른 위치에 있습니다.

| 파일 | 위치 | 목적 |
| - | - | - |
| `managed-settings.json` | 시스템 수준, OS에 따라 다름 | [좁은 예외](https://code.claude.com/docs/ko/settings.md#exceptions-to-managed-settings-precedence)를 제외하고는 사용자 자신의 설정 파일과 `--settings` 값으로 재정의할 수 없는 엔터프라이즈 강제 설정입니다. [파일을 저장할 위치](https://code.claude.com/docs/ko/managed-settings.md#deploy-a-managed-settings-file) 및 [Claude Code가 사용하는 관리형 소스](https://code.claude.com/docs/ko/managed-settings.md#precedence-within-the-managed-tier)를 참조하세요. |
| `CLAUDE.local.md` | 프로젝트 루트 | 이 프로젝트에 대한 개인 기본 설정으로, CLAUDE.md와 함께 로드됩니다. 수동으로 생성하고 `.gitignore`에 추가합니다. |
| `AGENTS.md` | 프로젝트 루트, `.claude/`, 또는 모든 디렉터리 | AI 코딩 에이전트를 위해 작성하는 프로젝트 지침입니다. Claude Code는 `CLAUDE.md` 대신 [이를 로드](https://code.claude.com/docs/ko/memory.md#agents-md)할 수 있습니다. |
| 설치된 플러그인 | `~/.claude/plugins` | 복제된 마켓플레이스, 설치된 플러그인 버전, `installed_plugins.json` 설치 기록, 플러그인별 데이터로, `claude plugin` 명령으로 관리됩니다. [claude.ai 계정에서 동기화된](https://code.claude.com/docs/ko/plugins/loading.md#synced-plugins) 플러그인은 `~/.claude/plugins/synced/`로 다운로드됩니다. 마켓플레이스 [`command` 소스](https://code.claude.com/docs/ko/plugins/marketplace-reference#command-plugin-source)에서 링크 모드로 설치된 플러그인의 경우, Claude Code는 복사본 대신 여기에 링크를 저장하고, 플러그인의 파일은 명령이 출력하는 디렉터리에 남아 있습니다. `command` 소스는 Claude Code v2.1.229 이상이 필요합니다. 로컬 경로에서 추가한 마켓플레이스에 상대 경로로 나열된 플러그인도 캐시 복사본이 아닌 소스 디렉터리에서 [제자리에 로드](https://code.claude.com/docs/ko/plugins/loading.md#find-plugins-on-disk)됩니다. [플러그인 캐싱](https://code.claude.com/docs/ko/plugins/loading.md#find-plugins-on-disk)에서 고아 버전이 정리되는 방식을 참조하세요. |

`~/.claude`는 또한 작업할 때 Claude Code가 작성하는 데이터를 보유합니다. 트랜스크립트, 프롬프트 기록, 파일 스냅샷, 캐시, 로그입니다. 아래의 [애플리케이션 데이터](#application-data)를 참조하세요.

## 올바른 파일 선택

다양한 종류의 사용자 정의는 다양한 파일에 있습니다. 이 표를 사용하여 변경 사항이 어디에 속하는지 찾습니다.

| 원하는 작업 | 편집 | 범위 | 참조 |
| :- | :- | :- | :- |
| Claude에 프로젝트 컨텍스트 및 규칙 제공 | `CLAUDE.md` | 프로젝트 또는 전역 | [메모리](https://code.claude.com/docs/ko/memory.md) |
| 특정 도구 호출 허용 또는 차단 | `settings.json` `permissions` 또는 `hooks` | 프로젝트 또는 전역 | [권한](https://code.claude.com/docs/ko/permissions.md), [Hooks](https://code.claude.com/docs/ko/hooks.md) |
| 도구 호출 전후에 스크립트 실행 | `settings.json` `hooks` | 프로젝트 또는 전역 | [Hooks](https://code.claude.com/docs/ko/hooks.md) |
| 세션에 대한 환경 변수 설정 | `settings.json` `env` | 프로젝트 또는 전역 | [설정](https://code.claude.com/docs/ko/settings-reference.md#all-settings) |
| 개인 재정의를 git에서 제외 | `settings.local.json` | 프로젝트만 | [설정 범위](https://code.claude.com/docs/ko/settings.md#where-settings-live) |
| `/name`으로 호출하는 프롬프트 또는 기능 추가 | `skills/<name>/SKILL.md` | 프로젝트 또는 전역 | [Skills](https://code.claude.com/docs/ko/skills.md) |
| 자신의 도구가 있는 특화된 subagent 정의 | `agents/*.md` | 프로젝트 또는 전역 | [Subagents](https://code.claude.com/docs/ko/sub-agents.md) |
| 스크립트에서 많은 subagent 조율 | `workflows/*.js` | 프로젝트 또는 전역 | [동적 워크플로우](https://code.claude.com/docs/ko/workflows.md) |
| MCP를 통해 외부 도구 연결 | `.mcp.json` | 프로젝트만 | [MCP](https://code.claude.com/docs/ko/mcp.md) |
| Claude가 응답을 포맷하는 방식 변경 | `output-styles/*.md` | 프로젝트 또는 전역 | [출력 스타일](https://code.claude.com/docs/ko/output-styles.md) |

## 파일 참조

이 표는 탐색기가 다루는 모든 파일을 나열합니다. 프로젝트 범위 파일은 `.claude/` 아래의 리포지토리에 있습니다 (또는 `CLAUDE.md`, `.mcp.json`, `.worktreeinclude`의 경우 루트에 있음). 전역 범위 파일은 `~/.claude/`에 있으며 모든 프로젝트에 적용됩니다.

> [!NOTE]
>
> 이 파일에 입력한 내용을 재정의할 수 있는 여러 가지가 있습니다.
>
> * 조직에서 배포한 [관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)은 [설정 우선순위의 예외](https://code.claude.com/docs/ko/settings.md#exceptions-to-managed-settings-precedence)를 제외하고 모든 설정 파일과 `--settings` 값보다 우선합니다.
> * `--permission-mode` 또는 `--settings`와 같은 CLI 플래그는 해당 세션에 대해 `settings.json`을 재정의합니다.
> * 일부 환경 변수는 동등한 설정보다 우선하지만, 이는 다양합니다. 각각에 대해 [환경 변수 참조](https://code.claude.com/docs/ko/env-vars.md)를 확인하세요.
>
> 전체 순서는 [설정 우선순위](https://code.claude.com/docs/ko/settings.md#settings-precedence)를 참조하세요.

파일 이름을 클릭하여 위의 탐색기에서 해당 노드를 엽니다.

| 파일 | 범위 | 커밋 | 기능 | 참조 |
| - | - | - | - | - |
| [`CLAUDE.md`](#ce-claude-md) | 프로젝트 및 전역 | ✓ | 매 세션마다 로드되는 지침 | [메모리](https://code.claude.com/docs/ko/memory.md) |
| [`rules/*.md`](#ce-rules) | 프로젝트 및 전역 | ✓ | 주제 범위 지침, 선택적으로 경로 제한 | [규칙](https://code.claude.com/docs/ko/memory.md#organize-rules-with-claude/rules/) |
| [`settings.json`](#ce-settings-json) | 프로젝트 및 전역 | ✓ | 권한, hooks, 환경 변수, 모델 기본값 | [설정](https://code.claude.com/docs/ko/settings.md) |
| [`settings.local.json`](#ce-settings-local-json) | 프로젝트만 | | 개인 재정의, Claude Code가 설정을 저장할 때 gitignored | [설정 범위](https://code.claude.com/docs/ko/settings.md#where-settings-live) |
| [`.mcp.json`](#ce-mcp-json) | 프로젝트만 | ✓ | 팀 공유 MCP 서버 | [MCP 범위](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes) |
| [`.worktreeinclude`](#ce-worktreeinclude) | 프로젝트만 | ✓ | 새 worktrees로 복사할 Gitignored 파일 | [Worktrees](https://code.claude.com/docs/ko/worktrees.md#copy-gitignored-files-into-worktrees) |
| [`skills/<name>/SKILL.md`](#ce-skills) | 프로젝트 및 전역 | ✓ | `/name`으로 호출되거나 자동 호출되는 재사용 가능한 프롬프트 | [Skills](https://code.claude.com/docs/ko/skills.md) |
| [`commands/*.md`](#ce-commands) | 프로젝트 및 전역 | ✓ | 단일 파일 프롬프트; skills와 동일한 메커니즘 | [Skills](https://code.claude.com/docs/ko/skills.md) |
| [`output-styles/*.md`](#ce-output-styles) | 프로젝트 및 전역 | ✓ | Claude의 작동 방식을 조정하는 사용자 정의 지침 세트 | [출력 스타일](https://code.claude.com/docs/ko/output-styles.md) |
| [`agents/*.md`](#ce-agents) | 프로젝트 및 전역 | ✓ | 자신의 프롬프트와 도구가 있는 subagent 정의 | [Subagents](https://code.claude.com/docs/ko/sub-agents.md) |
| [`workflows/*.js`](#ce-workflows) | 프로젝트 및 전역 | ✓ | Claude가 작성하고 `/workflows`에서 저장한 동적 워크플로우 스크립트; 각 파일은 `/<name>` 명령어가 됩니다 | [동적 워크플로우](https://code.claude.com/docs/ko/workflows.md) |
| [`agent-memory/<name>/`](#ce-agent-memory) | 프로젝트 및 전역 | ✓ | Subagents의 지속적 메모리 | [지속적 메모리](https://code.claude.com/docs/ko/sub-agents.md#enable-persistent-memory) |
| [`~/.claude.json`](#ce-claude-json) | 전역만 | | 앱 상태, 계정 세부 정보, UI 토글, 개인 MCP 서버. 이 파일이 없으면 Claude Code는 세션을 시작하거나 `claude auth status`와 같은 하위 명령을 실행할 때 파일을 생성하지만, `--version` 또는 `--help`의 경우에는 생성하지 않습니다. | [전역 설정](https://code.claude.com/docs/ko/settings-reference.md#global-config-settings) |
| [`projects/<project>/memory/`](#ce-global-projects) | 전역만 | | 자동 메모리: Claude의 세션 간 자체 메모 | [자동 메모리](https://code.claude.com/docs/ko/memory.md#auto-memory) |
| [`keybindings.json`](#ce-keybindings) | 전역만 | | 사용자 정의 키보드 단축키 | [키바인딩](https://code.claude.com/docs/ko/keybindings.md) |
| [`themes/*.json`](#ce-themes) | 전역만 | | 사용자 정의 색상 테마 | [사용자 정의 테마](https://code.claude.com/docs/ko/terminal-config.md#create-a-custom-theme) |

## 파일별 프론트매터 필드

Skills, command 파일, subagents, output styles, 그리고 rules는 파일 상단의 YAML [프론트매터](https://code.claude.com/docs/ko/glossary.md#frontmatter)에서 구성을 읽으며, 각각은 자신의 필드 집합을 허용합니다. 이 표는 각 파일의 필드 이름을 나열하고 이들을 설명하는 참조로 연결합니다.

| 파일 | 프론트매터 필드 | 참조 |
| - | - | - |
| `skills/<name>/SKILL.md` | `name`, `description`, `when_to_use`, `argument-hint`, `arguments`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `disallowed-tools`, `model`, `effort`, `context`, `agent`, `background`, `hooks`, `paths`, `shell`, `metadata`, `license`, `compatibility` | [Skill 프론트매터](https://code.claude.com/docs/ko/skills.md#frontmatter-reference) |
| `commands/*.md` | `name`과 `paths`를 제외한 skill 필드 | [Skill 프론트매터](https://code.claude.com/docs/ko/skills.md#frontmatter-reference) |
| `agents/*.md` | `name`, `description`, `tools`, `disallowedTools`, `model`, `permissionMode`, `maxTurns`, `autoCompactWindow`, `skills`, `mcpServers`, `hooks`, `memory`, `background`, `effort`, `isolation`, `color`, `initialPrompt`, `omitClaudeMd`, `experimental` | [서브에이전트 frontmatter](https://code.claude.com/docs/ko/sub-agents.md#supported-frontmatter-fields) |
| `output-styles/*.md` | `name`, `description`, `keep-coding-instructions`, `force-for-plugin` | [Output style 프론트매터](https://code.claude.com/docs/ko/output-styles.md#frontmatter) |
| `rules/*.md` | `paths` | [Rule 프론트매터](https://code.claude.com/docs/ko/memory.md#rules-frontmatter-reference) |

[플러그인](https://code.claude.com/docs/ko/plugins/components.md#agents)에서 제공되는 Agents는 subagent 필드의 부분 집합을 준수합니다.

## 설정 문제 해결

설정, hook, 파일이 적용되지 않으면, [설정 디버그](https://code.claude.com/docs/ko/debug-your-config.md)에서 검사 명령과 증상 우선 조회 표를 참조하세요.

## 애플리케이션 데이터

작성한 설정 외에도 `~/.claude`에는 Claude Code가 세션 중에 작성하는 데이터가 저장됩니다. 이 파일들은 평문입니다. 도구를 통과하는 모든 것은 디스크의 트랜스크립트에 기록됩니다: 파일 내용, 명령 출력, 붙여넣은 텍스트.

트랜스크립트에는 Claude Code가 사용자의 메시지와 함께 모델에 보내는 내용도 포함될 수 있습니다:

* 시스템 프롬프트
* 도구 정의
* 요청 매개변수
* CLAUDE.md와 같이 로드한 지침 파일

### 자동으로 정리됨

Claude Code는 [`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays)보다 오래된 아래 경로의 파일들을 삭제합니다. 보존 기간을 안전하게 결정할 수 있는 한 말입니다. 기본값은 30일이고 최소값은 1입니다. `0`으로 설정하면 유효성 검사 오류가 발생합니다. 동일한 나이 기준이 [고아 worktrees의 자동 제거](https://code.claude.com/docs/ko/worktrees.md#clean-up-subagent-and-background-session-worktrees)에도 적용됩니다.

| `~/.claude/` 아래 경로 | 내용 |
| - | - |
| `projects/<project>/<session>.jsonl` | 대화 트랜스크립트: 메시지, 도구 호출 및 도구 결과, 그리고 Claude Code가 모델에 보낸 요청의 시스템 프롬프트, 도구 정의 및 매개변수 |
| `projects/<project>/<session>.orphaned-<timestamp>-<suffix>.jsonl`, `projects/<project>/<session>.jsonl.superseded-<timestamp>` | Claude Code가 덮어쓰거나 삭제하는 대신 따로 보관한 세션의 이전 트랜스크립트입니다. 세션 선택기에 나타나지 않습니다 |
| `projects/<project>/<session>/subagents/` | 세션 트랜스크립트와 동일한 형식의 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md) 트랜스크립트, 상위 세션 트랜스크립트가 오래되면 함께 제거됨 |
| `projects/<project>/<session>/tool-results/` | 별도 파일로 유출된 대형 도구 출력, 그리고 [MCP 도구가 반환하는 이미지](https://code.claude.com/docs/ko/mcp.md#images-in-tool-results)의 전체 크기 복사본 |
| `projects/<project>/<session>/mcp-tasks/` | 재개된 세션이 실행 중인 [MCP 작업](https://code.claude.com/docs/ko/mcp.md#mcp-tasks-that-run-on-the-server)을 다시 추적하는 데 필요한 정보, 그리고 Claude가 아직 읽지 않은 완료된 작업의 결과 |
| `file-history/<session>/` | Claude Code가 변경한 파일의 편집 전 스냅샷, [checkpoint 복원](https://code.claude.com/docs/ko/checkpointing.md)에 사용됨. 가장 최근의 100개 checkpoint에 대한 스냅샷을 보유합니다. 보존된 checkpoint가 참조하지 않는 스냅샷 파일은 각 파일의 첫 번째 스냅샷을 제외하고 삭제됩니다 |
| `plans/` | [plan mode](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode) 중에 작성된 Plan 파일 |
| `debug/` | 세션별 디버그 로그, 디버그 로깅이 켜져 있을 때 작성됨. 예를 들어 [`--debug`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 시작하거나 `/debug`를 실행할 때 |
| `paste-cache/` | 대형 붙여넣기의 내용 |
| `image-cache/<session>/` | Claude Code v2.1.274 이전 버전에서 저장한 첨부 이미지입니다. 이후 버전은 붙여넣은 이미지와 첨부 이미지를 `~/.claude` 외부에 저장하며, [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars)이 제어하는 임시 디렉토리 아래 각 세션에 대한 `images/` 디렉토리에 저장합니다. 스윕은 나이에 관계없이 여기에 있는 다른 세션의 남은 디렉토리를 제거합니다. |
| `uploads/<session>/` | 웹 또는 모바일 앱에서 첨부한 파일 및 모바일 앱에서 첨부한 사진. [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션에 메시지를 보낼 때입니다. [cloud session](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에 대한 첨부는 대신 해당 세션의 자체 클라우드 환경에 저장되며, 사용자의 머신에는 저장되지 않습니다. |
| `dev-mods/<session>/` | [Claude가 작성한 Mods](https://code.claude.com/docs/ko/plugins/mods/create.md#ask-claude-for-a-mod) (세션 중) |
| `session-env/` | 세션별 환경 메타데이터 |
| `tasks/` | 작업 도구로 작성된 작업 목록, 목록당 하나의 디렉토리 |
| `shell-snapshots/` | 시작 시 캡처된 별칭, 함수 및 셸 옵션. [Bash tool](https://code.claude.com/docs/ko/tools-reference.md#bash-tool-behavior)에 의해 각 명령에 적용됩니다. 정상 종료 시 제거됩니다. 스윕은 충돌 후 남은 것을 정리합니다. |
| `backups/` | `~/.claude.json`의 이전 버전, Claude Code가 파일을 다시 쓸 때 복사됨. Claude Code는 가장 최신 5개와 구문 분석할 수 없는 모든 버전의 복사본을 유지합니다. |
| `feedback-bundles/` | 타사 제공자에서 또는 Anthropic 자격증명이 구성되지 않았을 때 `/feedback`이 작성한 수정된 트랜스크립트 아카이브. Anthropic 계정 팀에 보내기 위한 것입니다 |
| `feedback/drafts/` | 대기 중인 [Claude 작성 피드백](https://code.claude.com/docs/ko/tools-reference.md#sendfeedback-tool-behavior). `/feedback`에서 검토 대기 중입니다. `cleanupPeriodDays` 또는 30일 후 스윕됨. 큐가 10개 초안 제한에 도달하면 Claude Code는 가장 오래된 초안을 삭제하여 공간을 확보합니다. |
| `usage-data/` | `report.html` 및 [`/insights`](https://code.claude.com/docs/ko/costs#analyze-your-usage-patterns)에 의해 작성된 타임스탬프 보고서 복사본, 그리고 이를 구축하는 데 사용되는 캐시된 세션별 분석 데이터 |
| `skills/.trash/`, `plugins/.trash/` | [Skills](https://code.claude.com/docs/ko/skills.md#how-synced-skills-behave) 및 [plugins](https://code.claude.com/docs/ko/plugins/loading.md#synced-plugins). claude.ai 동기화가 제거한 것. 예를 들어 claude.ai에서 하나를 끄거나 동기화를 중지한 후. 파일은 스윕이 삭제할 때까지 복구할 수 있도록 여기에 남아 있습니다 |
| `plugins/installed_plugins.set-aside.<date>.<hash>.json`, `plugins/installed_plugins.unreadable.<date>.<hash>.kept` | Claude Code가 [`installed_plugins.json`](https://code.claude.com/docs/ko/plugins/loading#find-plugins-on-disk)을 다시 쓰기 전에 만드는 날짜가 지정된 복사본: 삭제한 설치 기록 및 읽을 수 없는 파일의 내용. |
| `todos/`, `statsig/`, `logs/` | 이전 버전의 레거시 디렉토리입니다. 더 이상 작성되지 않습니다. 스윕은 내용을 제거한 다음 빈 디렉토리를 제거합니다. |

`sessions/`의 세션 파일, 자동 메모리, Claude Desktop 및 Cowork 트랜스크립트는 각각 자체 보존 규칙을 따릅니다:

* **`sessions/`**: 실행 중인 각 세션에 대해 하나의 작은 파일을 보유합니다. 동시 세션 및 충돌을 감지하는 데 사용됩니다. 나이 기반 스윕의 일부가 아닙니다: Claude Code는 세션이 종료될 때 각 파일을 제거하고 다음 시작 시 충돌 남은 것을 정리합니다.
* **자동 메모리**: 스윕은 프로젝트의 [자동 메모리](https://code.claude.com/docs/ko/memory.md#auto-memory) 디렉토리 `projects/<project>/memory/`의 메모리 파일을 삭제하지 않습니다. Claude Code는 전체 보존 기간 동안 비어 있었던 경우에만 해당 디렉토리를 제거합니다. v2.1.228 이전에는 스윕이 메모리 디렉토리 내의 폴더를 세션 데이터로 취급하고 그 아래의 오래된 파일을 삭제할 수 있었습니다.
* **Claude Desktop 및 Cowork 트랜스크립트**: Claude Code는 Claude Desktop 또는 Cowork에서 시작하거나 가장 최근에 계속한 세션의 트랜스크립트를 나이에 관계없이 유지합니다. 이 트랜스크립트에 나이 제한을 주려면 [`desktopSessionCleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#desktopsessioncleanupperioddays)를 설정하세요. Claude Code v2.1.248 이상 필요; 이전 버전은 `cleanupPeriodDays` 후에 삭제합니다.

  다음 중 하나에 해당하면 Claude Code는 대신 `cleanupPeriodDays` 후에 이 트랜스크립트를 삭제합니다:

  * [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)이 `cleanupPeriodDays`를 설정한 경우
  * [HIPAA 구성이 세션에 적용되는](https://code.claude.com/docs/ko/hipaa-setup.md#check-how-developers-sign-in-and-connect) 경우

Claude Code는 다음 경우에 나이 기반 스윕을 건너뜁니다:

* **Bare mode**: [`--bare`](https://code.claude.com/docs/ko/headless#start-faster-with-bare-mode)로 `claude -p`를 실행할 때, Claude Code는 해당 세션에서 스윕을 실행하지 않습니다.
* **일시 중지된 스윕**: Claude Code가 보존 기간을 안전하게 결정할 수 없으면 보존 정리 스윕을 일시 중지합니다. [`retention_sweep` 이벤트](https://code.claude.com/docs/ko/monitoring-usage#retention-sweep-event)는 이를 일시 중지하는 각 구성을 나열합니다. 원인이 읽거나 구문 분석할 수 없는 설정 파일이거나 `cleanupPeriodDays` 또는 `desktopSessionCleanupPeriodDays`가 명시적으로 설정된 설정 오류인 경우, Claude Code는 설정 오류를 수정할 때까지 `/status`에 경고를 표시합니다. [관리 설정](https://code.claude.com/docs/ko/server-managed-settings.md)이 `cleanupPeriodDays`를 제공하면 Claude Code는 어느 경우든 관리 값에서 스윕을 실행합니다.

조직의 머신이 설정한 보존 기간으로 스윕을 실행하는지 확인하려면 [보존 스윕 확인](https://code.claude.com/docs/ko/monitoring-usage.md#check-the-retention-sweep)을 참조하세요.

### 세션 스크래치패드 디렉토리

스크래치패드는 Claude Code가 Claude에게 제공하는 세션별 디렉토리입니다. 임시 파일용입니다: 중간 결과, 도우미 스크립트, 프로젝트에 속하지 않는 초안. Claude가 무언가를 "스크래치패드에 저장했다"고 말하면 파일이 거기에 있습니다. Claude는 `/tmp` 대신 이를 사용하며 권한 프롬프트 없이 파일을 생성, 편집 및 읽을 수 있습니다.

스크래치패드는 `~/.claude` 대신 Claude Code의 임시 디렉토리 아래에 있습니다. 플랫폼별로 현재 세션의 경로를 찾으세요:

* **macOS**: `/private/tmp/claude-<uid>/<project>/<session-id>/scratchpad/`
* **Linux**: `/tmp/claude-<uid>/<project>/<session-id>/scratchpad/`, 또는 시스템이 설정한 경우 `$TMPDIR` 아래의 동일한 형태
* **Windows**: `%TEMP%\claude\<project>\<session-id>\scratchpad\`

`<project>`는 문자와 숫자 이외의 모든 문자가 `-`로 바뀐 작업 디렉토리 경로입니다. 예를 들어 `-Users-you-my-project`. [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars)을 설정하면 트리가 대신 해당 디렉토리 아래로 이동합니다. Hook은 현재 세션의 경로를 [`scratchpad_dir`](https://code.claude.com/docs/ko/hooks#common-input-fields)로 받습니다.

스크래치패드 파일은 세션의 트랜스크립트만큼 오래 지속됩니다: [보존 스윕](#cleaned-up-automatically)은 트랜스크립트를 삭제할 때 디렉토리를 삭제하고, [`claude purge`](#clear-local-data)는 임시 디렉토리를 건드리지 않습니다. 디렉토리가 시스템 임시 위치 아래에 있으므로 운영 체제도 이를 정리할 수 있습니다. 예를 들어 재시작 시. Claude가 거기에 작성한 것을 유지하려면 Claude에게 프로젝트로 이동하도록 요청하세요.

세션은 다음 모두가 유지될 때만 스크래치패드를 갖습니다:

* API 키가 아닌 claude.ai 계정으로 로그인했습니다
* 세션은 Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry가 아닌 Anthropic API를 사용합니다
* [`enableArtifact`](https://code.claude.com/docs/ko/settings-reference#enableartifact)가 `false`로 설정되지 않았습니다

### 삭제할 때까지 유지됨

달리 명시된 행을 제외하고, 보존 정리 스윕은 아래 경로를 제거하지 않으며 Claude Code는 사용자가 삭제할 때까지 이를 유지합니다.

| `~/.claude/` 아래 경로 | 내용 |
| - | - |
| `history.jsonl` | 입력한 프롬프트, 타임스탬프 및 프로젝트 경로 포함. 위쪽 화살표 회상, `Ctrl+R` 히스토리 검색 및 `!` 셸 명령 완성에 사용됩니다. [HIPAA 구성이 세션에 적용되는](https://code.claude.com/docs/ko/hipaa-setup.md#check-how-developers-sign-in-and-connect) 경우 각 스윕이 `cleanupPeriodDays`보다 오래된 항목을 제거합니다. |
| `stats-cache.json` | `/usage`에 표시된 집계된 토큰 및 비용 수 |
| `remote-settings.json` | [서버 관리 설정](https://code.claude.com/docs/ko/server-managed-settings.md)의 캐시된 복사본. 조직의 경우 또는 조직이 구성하지 않은 경우 `{}`. 세션이 [이를 가져올](https://code.claude.com/docs/ko/server-managed-settings.md#platform-availability) 때만 존재합니다. Claude Code는 시작 시 및 세션 중 매시간 업데이트를 확인합니다. Claude Code는 로그아웃할 때 삭제합니다. |
| `cache/changelog.md` | Claude Code 변경 로그의 캐시된 복사본, `/release-notes`에 표시됨. 백그라운드에서 새로 고쳐집니다. |
| `policy-limits.json` | 조직의 캐시된 기능 정책 설정. 일부 계정 유형에만 존재합니다. 자동으로 새로 고쳐집니다. `policy-limits.json.stamp.json` 사이드카는 캐시가 속한 계정 또는 API 키를 기록합니다. Claude Code는 로그아웃할 때 두 파일을 모두 삭제합니다. |

#### 유지해야 할 상태 파일

사용하는 기능에 따라 `~/.claude/`에는 [애플리케이션 데이터](#application-data) 아래 표에 나열되지 않은 파일도 저장됩니다. 그중 캐시 및 잠금 파일은 안전하게 삭제할 수 있습니다. 다음 상태 파일은 유지하세요:

* `.credentials.json`: 사용자의 [로그인 자격증명](https://code.claude.com/docs/ko/authentication.md#credential-management)
* `agent-memory/`: [subagent 메모리](https://code.claude.com/docs/ko/sub-agents.md#enable-persistent-memory)
* `jobs/` 및 `daemon/`: [background session](https://code.claude.com/docs/ko/agent-view.md#where-state-is-stored) 상태

### 평문 저장소

트랜스크립트 및 히스토리는 저장 시 암호화되지 않습니다. OS 파일 권한만이 유일한 보호입니다. 도구가 `.env` 파일을 읽거나 명령이 자격증명을 인쇄하면 해당 값이 `projects/<project>/<session>.jsonl`에 기록됩니다. 노출을 줄이려면:

* `cleanupPeriodDays`를 낮춰 Claude Code가 트랜스크립트를 유지하는 기간을 단축하세요
* [`desktopSessionCleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#desktopsessioncleanupperioddays)를 설정하여 Claude Desktop 및 Cowork 트랜스크립트에도 나이 제한을 주세요
* [`CLAUDE_CODE_SKIP_PROMPT_HISTORY`](https://code.claude.com/docs/ko/env-vars) 환경 변수를 설정하여 모든 모드에서 트랜스크립트 및 프롬프트 히스토리 작성을 건너뛰세요. 비대화형 모드에서는 대신 `-p`와 함께 `--no-session-persistence`를 전달하거나 TypeScript Agent SDK에서 `persistSession: false`를 설정할 수 있습니다. Python SDK에는 동등한 옵션이 없습니다.
* [권한 규칙](https://code.claude.com/docs/ko/permissions.md)을 사용하여 자격증명 파일의 읽기를 거부하세요

### 로컬 데이터 지우기

`claude purge`를 실행하여 Claude Code가 한 프로젝트에 대해 보유한 상태를 삭제합니다. 다음을 삭제합니다:

* `projects/` 아래의 트랜스크립트 및 자동 메모리
* 세션별 `tasks/`, `debug/` 및 `file-history/` 항목
* `history.jsonl`의 일치하는 프롬프트 라인
* `~/.claude.json`의 프로젝트 항목

프로젝트의 세션에서 붙여넣거나 첨부한 이미지 및 각 세션의 [스크래치패드](#session-scratchpad-directory)는 `~/.claude` 대신 Claude Code의 임시 디렉토리 아래에 저장되므로 purge는 이를 제거하지 않습니다. [보존 스윕](#cleaned-up-automatically)은 `cleanupPeriodDays`보다 오래되면 이미지를 삭제합니다. purge된 세션의 스크래치패드는 삭제할 때까지 또는 운영 체제가 임시 디렉토리를 정리할 때까지 유지됩니다.

명령은 전체 삭제 계획을 인쇄하고 아무것도 제거하기 전에 확인을 요청합니다.

v2.1.288 이전에는 명령이 `claude project purge`였습니다.

아래 예제는 `~/work/my-repo`를 자리 표시자로 사용합니다. 프로젝트의 경로로 바꾸세요. 경로와 일치하는 상태가 없으면 명령은 오류를 인쇄하고 상태 1로 종료합니다.

아무것도 삭제하지 않고 계획 미리 보기:

```bash theme={null}
claude purge ~/work/my-repo --dry-run
```

계획은 각 일치하는 항목과 포함된 이유를 나열합니다:

```text theme={null}
Purge plan for /home/user/work/my-repo:

  dir:    /home/user/.claude/projects/-home-user-work-my-repo
           project transcripts (.jsonl) and memory/
  config: projects["/home/user/work/my-repo"]
           project entry in ~/.claude.json (trust, history, MCP servers)
  filter: /home/user/.claude/history.jsonl
           12 prompt(s) typed in this project

shell-snapshots/ are not project-scoped and will not be touched
backups/ may still contain this project entry in old .claude.json snapshots (/home/user/.claude/backups); at most 5 are kept and they rotate out automatically
Dry run: 3 item(s) would be deleted.
```

단일 확인 프롬프트로 삭제:

```bash theme={null}
claude purge ~/work/my-repo
```

명령은 동일한 계획을 인쇄한 다음 `Delete 3 item(s) for /home/user/work/my-repo? This cannot be undone. [y/N]`를 묻고 `y`로 답변한 경우에만 삭제합니다.

대화형 목록에서 프로젝트를 선택하려면 경로를 생략하세요.

스크립트에서 사용하기 위해 확인 프롬프트를 건너뛰세요:

```bash theme={null}
claude purge ~/work/my-repo --yes
```

기타 옵션:

* 경로 대신 `--all`을 전달하면 한 번에 모든 프로젝트의 상태를 purge합니다. 이 경우 `history.jsonl`을 필터링하는 대신 완전히 삭제합니다.
* `-i`를 전달하면 삭제 계획을 한 번에 한 항목씩 단계별로 진행합니다.

명령은 `shell-snapshots/` 및 `backups/`를 그대로 두는데, 이는 프로젝트 범위가 아니기 때문이며 계획 출력에서 이에 대해 경고합니다. 누군가 해당 머신에서 [`/heapdump`](https://code.claude.com/docs/ko/troubleshooting#high-cpu-or-memory-usage)를 실행했다면 그것이 작성한 `.heapsnapshot` 파일도 삭제하세요. 힙 스냅샷에는 전체 대화와 프로세스가 보유했던 모든 자격 증명이 포함되며, 보존 스윕과 purge 모두 이를 건드리지 않습니다.

[유지해야 할 상태 파일](#state-files-to-keep)을 제외하면 위의 애플리케이션 데이터 경로를 직접 삭제할 수도 있습니다.

| 삭제 | 손실되는 것 |
| - | - |
| `~/.claude/projects/` | 과거 세션의 재개, 계속 및 되감기, 그리고 모든 프로젝트의 자동 메모리 |
| `~/.claude/history.jsonl` | 위쪽 화살표 프롬프트 회상, `Ctrl+R` 히스토리 검색 및 `!` 셸 명령 완성 |
| `~/.claude/paste-cache/` | 회상된 프롬프트의 붙여넣은 텍스트. [대형 콘텐츠 붙여넣기](https://code.claude.com/docs/ko/terminal-config.md#paste-large-content) 참조 |
| `~/.claude/uploads/` | 과거 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션이 경로로 참조하는 첨부 |
| `~/.claude/file-history/` | 과거 세션의 checkpoint 복원 |
| `~/.claude/stats-cache.json` | `/usage`에 표시된 과거 합계 |
| `~/.claude/usage-data/` | 과거 [`/insights`](https://code.claude.com/docs/ko/costs#analyze-your-usage-patterns) 보고서 및 이를 구축하는 데 사용된 캐시된 분석 데이터 |
| `~/.claude/feedback-bundles/` | Anthropic 계정 팀에 아직 보내지 않은 피드백 및 버그 보고서 아카이브 |
| `~/.claude/feedback/drafts/` | 보내지 않은 [Claude 작성 피드백](https://code.claude.com/docs/ko/tools-reference.md#sendfeedback-tool-behavior) |
| `~/.claude/remote-settings.json` | 없음. 다음 시작 시 다시 가져옵니다. |
| `~/.claude/cache/changelog.md` | 없음. 백그라운드에서 새로 고쳐집니다. |
| `~/.claude/policy-limits.json` | 없음. 자동으로 새로 고쳐집니다. |
| `~/.claude/tasks/` | 아직 사용 중인 것을 포함한 [작업 목록](https://code.claude.com/docs/ko/interactive-mode.md#task-list) |
| `~/.claude/skills/.trash/`, `~/.claude/plugins/.trash/` | [동기화된 skills](https://code.claude.com/docs/ko/skills.md#how-synced-skills-behave) 및 [동기화된 plugins](https://code.claude.com/docs/ko/plugins/loading.md#synced-plugins)를 복구할 기회. Claude Code가 제거한 것 |
| `~/.claude/plugins/installed_plugins.set-aside.<date>.<hash>.json`, `~/.claude/plugins/installed_plugins.unreadable.<date>.<hash>.kept` | Claude Code가 삭제했거나 읽을 수 없는 plugin 설치 기록의 복사본. 아무것도 이를 다시 읽지 않습니다 |
| `~/.claude/debug/`, `~/.claude/plans/`, `~/.claude/session-env/`, `~/.claude/shell-snapshots/`, `~/.claude/backups/` | 사용자 대면 없음 |
| `~/.claude/todos/`, `~/.claude/statsig/`, `~/.claude/logs/`, `~/.claude/image-cache/` | 없음. 현재 버전에서 작성되지 않는 레거시 디렉토리. |

`~/.claude.json`, `~/.claude/settings.json` 또는 `~/.claude/plugins/`를 삭제하지 마세요. 이들은 계정 정보, 기본 설정 및 설치된 플러그인을 보유합니다.

## 관련 리소스

* [Claude의 메모리 관리](https://code.claude.com/docs/ko/memory.md): CLAUDE.md, rules, auto memory 작성 및 구성
* [설정 구성](https://code.claude.com/docs/ko/settings.md): 권한, hooks, 환경 변수, 모델 기본값 설정
* [Skills 생성](https://code.claude.com/docs/ko/skills.md): 재사용 가능한 프롬프트 및 워크플로우 구축
* [Subagents 구성](https://code.claude.com/docs/ko/sub-agents.md): 자신의 컨텍스트가 있는 특화된 에이전트 정의
