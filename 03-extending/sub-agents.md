> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 사용자 정의 subagent 만들기

> Claude Code에서 작업별 워크플로우 및 향상된 컨텍스트 관리를 위한 특화된 AI subagent를 만들고 사용합니다.

Subagent는 특정 유형의 작업을 처리하는 특화된 AI 어시스턴트입니다. 부작업이 검색 결과, 로그 또는 다시 참조하지 않을 파일 콘텐츠로 주 대화를 넘칠 때 하나를 사용하세요: subagent는 자신의 컨텍스트에서 해당 작업을 수행하고 요약만 반환합니다. 동일한 지침으로 동일한 종류의 워커를 계속 생성할 때 사용자 정의 subagent를 정의합니다.

각 subagent는 자체 컨텍스트 윈도우에서 실행되며 사용자 정의 시스템 프롬프트, 특정 도구 액세스 및 독립적인 권한을 가집니다. 또한 자신의 요청을 전송하며, 이는 주 대화와 동일한 [사용 제한](https://code.claude.com/docs/ko/costs.md#plan-usage-breakdown)으로 계산됩니다. Claude가 subagent의 설명과 일치하는 작업을 만나면 해당 subagent에 위임하고, subagent는 독립적으로 작동하여 결과를 반환합니다. 실제로 컨텍스트 절감을 확인하려면 [컨텍스트 윈도우 시각화](https://code.claude.com/docs/ko/context-window.md)에서 subagent가 자신의 별도 윈도우에서 연구를 처리하는 세션을 안내합니다.

> [!NOTE]
>
> Subagent는 단일 세션 내에서 작동합니다. 많은 독립적인 세션을 병렬로 실행하고 한 곳에서 모니터링하려면 [background agents](https://code.claude.com/docs/ko/agent-view.md)를 참조하세요. 서로 메시지를 전달하는 별도의 세션의 경우 [cross-session messaging](https://code.claude.com/docs/ko/cross-session-messaging.md)을 참조하세요. Claude가 생성하고 감독하는 조정된 세션 팀의 경우 [agent teams](https://code.claude.com/docs/ko/agent-teams.md)를 참조하세요.

Subagent는 다음을 도와줍니다:

* **컨텍스트 보존** - 탐색 및 구현을 주 대화에서 분리하여 유지
* **제약 조건 적용** - subagent가 사용할 수 있는 도구 제한
* **구성 재사용** - 사용자 수준 subagent를 통해 프로젝트 간 구성 재사용
* **동작 특화** - 특정 도메인을 위한 집중된 시스템 프롬프트
* **비용 제어** - Haiku와 같은 더 빠르고 저렴한 모델로 작업 라우팅

Claude는 각 subagent의 설명을 사용하여 작업을 위임할 시기를 결정합니다. Subagent를 만들 때 Claude가 언제 사용할지 알 수 있도록 명확한 설명을 작성하세요.

이러한 설명들은 컨텍스트를 차지하므로 짧게 유지하세요. 내장된 subagent를 제외한 subagent의 결합된 설명이 15,000 토큰을 초과하면 Claude Code는 [총 토큰 수와 함께 시작 시 경고를 표시합니다](https://code.claude.com/docs/ko/errors.md#agent-descriptions-are-over-the-15000-token-limit). Subagent의 `description` 필드를 정리하고 세부 정보를 각 subagent의 시스템 프롬프트로 이동하세요. 시스템 프롬프트는 해당 subagent가 실행될 때만 로드됩니다.

## 내장 subagent

Claude Code에는 Claude가 적절할 때 자동으로 사용하는 내장 subagent가 포함되어 있습니다. 각각은 부모 대화의 권한 규칙을 상속합니다. 대부분은 제한된 도구 세트로 실행됩니다.

Explore와 Plan은 연구를 빠르고 저렴하게 유지하기 위해 CLAUDE.md 파일과 git 상태 스냅샷 없이 시작합니다. 다른 내장 서브에이전트와 [사용자 정의 서브에이전트](#configure-subagents)는 둘 다 로드합니다. 단, 사용자 정의 서브에이전트의 정의에서 [`omitClaudeMd`](#supported-frontmatter-fields)를 설정하면 사용자, 프로젝트 및 로컬 CLAUDE.md 파일 없이 시작할 수 있습니다. 서브에이전트에 전달되는 항목의 전체 분석은 [시작 시 로드되는 항목](#what-loads-at-startup)을 참조하십시오.

> [tab] Explore
>
> 코드베이스 검색 및 분석에 최적화된 빠른 읽기 전용 에이전트입니다.
>
> * **모델**: 주 대화의 모델입니다. 주 대화가 Fable에서 실행되는 경우 Explore의 모델은 연결 방식에 따라 달라집니다.
>   * Claude 구독, Anthropic Console 계정 또는 `ANTHROPIC_BASE_URL`을 통해 연결하는 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 사용하는 경우 Explore는 [`opus` 별칭](https://code.claude.com/docs/ko/model-config#model-aliases)이 가리키는 Opus 모델에서 실행됩니다.
>   * Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry, [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md) 또는 [Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)에서는 Explore가 주 대화의 모델을 그대로 사용합니다.
> * **도구**: 읽기 전용 도구; Write 및 Edit은 거부됩니다.
> * **목적**: 파일 검색, 코드 검색, 코드베이스 탐색
>
> `Explore`라는 이름의 [사용자 또는 프로젝트 서브에이전트](#choose-the-subagent-scope)는 내장 서브에이전트를 재정의하고 자체 `model` 필드를 유지하므로, 더 낮은 비용의 모델에서 탐색을 실행하려면 `model: haiku`로 정의하십시오. Explore를 포함한 모든 서브에이전트에 하나의 모델을 강제로 적용하려면 [모든 서브에이전트를 하나의 모델에서 실행](#run-every-subagent-on-one-model)을 참조하십시오.
>
> Claude는 변경 없이 코드베이스를 검색하거나 이해해야 할 때 Explore에 위임합니다. 이렇게 하면 탐색 결과가 주 대화 컨텍스트에서 벗어납니다.
>
> Explore를 호출할 때 Claude는 철저함 수준을 지정합니다: 대상 조회의 경우 **quick**, 균형 잡힌 탐색의 경우 **medium**, 포괄적인 분석의 경우 **very thorough**.

> [tab] Plan
>
> [plan mode](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode) 중에 계획을 제시하기 전에 컨텍스트를 수집하는 데 사용되는 연구 에이전트입니다.
>
> * **모델**: 주 대화에서 상속되며, `CLAUDE_CODE_SUBAGENT_MODEL`을 설정하고 [모든 subagent를 하나의 모델에서 실행](#run-every-subagent-on-one-model)하도록 강제하지 않는 한 그렇습니다.
> * **도구**: 읽기 전용 도구; Write 및 Edit은 거부됩니다.
> * **목적**: 계획을 위한 코드베이스 연구
>
> plan mode에 있고 Claude가 코드베이스를 이해해야 할 때 연구를 Plan subagent에 위임하므로 탐색 출력이 별도의 컨텍스트 윈도우에 유지되고 주 대화는 읽기 전용으로 유지됩니다.

> [tab] General-purpose
>
> 탐색과 작업 모두를 필요로 하는 복잡한 다단계 작업을 위한 유능한 에이전트입니다.
>
> * **모델**: [`CLAUDE_CODE_SUBAGENT_MODEL`](#choose-a-model) 모델(설정한 경우 및 다른 것이 모델을 다른 방식으로 할당하지 않는 경우), 그렇지 않으면 주 대화의 모델; [모델 선택](#choose-a-model)은 전체 순서를 나타내고, [모든 subagent를 하나의 모델에서 실행](#run-every-subagent-on-one-model)은 변수가 이러한 소스를 재정의하는 방법을 보여줍니다.
> * **도구**: subagent에 [사용 가능한](#available-tools) 모든 도구
> * **목적**: 복잡한 연구, 다단계 작업, 코드 수정
>
> Claude는 작업이 탐색과 수정 모두를 필요로 하거나, 결과를 해석하기 위한 복잡한 추론이 필요하거나, 여러 종속 단계가 필요할 때 general-purpose에 위임합니다.

> [tab] Other
>
> Claude Code에는 특정 작업을 위한 추가 도우미 에이전트가 포함되어 있습니다. 이들은 일반적으로 자동으로 호출되므로 직접 사용할 필요가 없습니다.
>
> | 에이전트 | 모델 | Claude가 사용하는 경우 |
> | :- | :- | :- |
> | claude | 자신의 모델이 없음; Claude가 subagent로 생성할 때 [모델 순서](#choose-a-model)를 따름 | 작업이 더 특화된 에이전트에 맞지 않을 때. subagent에 [사용 가능한](#available-tools) 모든 도구가 있는 catch-all입니다. 또한 dispatched [background session](https://code.claude.com/docs/ko/agent-view.md)의 기본 에이전트; [시작하는 권한 모드](https://code.claude.com/docs/ko/agent-view.md#permission-mode-model-and-effort)는 세션이 시작된 방식에 따라 다릅니다. |
> | statusline-setup | Sonnet | `/statusline`을 실행하여 상태 표시줄을 구성할 때 |
> | claude-code-guide | Haiku | Claude Code 기능에 대한 질문을 할 때 |

내장 subagent는 기본적으로 대화형 세션에 등록됩니다. 이를 제한하려면:

* 특정 내장 유형을 차단하려면 [특정 subagent 비활성화](#disable-specific-subagents)에 표시된 대로 `permissions.deny`에 추가하십시오.
* Claude가 어떤 subagent에도 위임하는 것을 방지하려면 [`permissions.deny`](https://code.claude.com/docs/ko/permissions#tool-specific-permission-rules)를 사용하여 `Agent` 도구 자체를 거부하십시오.
* 내장 `Explore` 및 `Plan` subagent만 제거하려면 [`CLAUDE_CODE_DISABLE_EXPLORE_PLAN_AGENTS=1`](https://code.claude.com/docs/ko/env-vars)을 설정하십시오. Claude는 이들에게 위임하는 대신 파일을 직접 읽고 탐색합니다. Claude Code v2.1.198 이상이 필요합니다.
* [비대화형 모드](https://code.claude.com/docs/ko/headless.md) 및 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)에서는 [`CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS=1`](https://code.claude.com/docs/ko/env-vars)을 설정하여 모든 내장 유형을 제거하고 자신의 것만 제공하십시오.

`subagent_type`을 생략한 Agent 도구 호출은 세션에 대체로 사용할 `general-purpose` 서브에이전트가 없으면 [`subagent_type is required`](https://code.claude.com/docs/ko/errors#subagent-type-is-required) 오류로 실패합니다.

이러한 내장 subagent 외에도 사용자 정의 프롬프트, 도구 제한, 권한 모드, hooks 및 skills를 사용하여 자신의 subagent를 만들 수 있습니다. 다음 섹션에서는 시작하는 방법과 subagent를 사용자 정의하는 방법을 보여줍니다.

## 빠른 시작: 첫 번째 서브에이전트 만들기

서브에이전트는 YAML frontmatter가 있는 Markdown 파일입니다. Claude에게 작성을 요청하거나 [수동으로 파일을 작성](#write-subagent-files)할 수 있습니다.

이 연습에서는 코드를 검토하고 개선 사항을 제안하는 사용자 수준 서브에이전트를 만듭니다.

**1. Claude에게 서브에이전트 생성 요청**

Claude Code에서 원하는 서브에이전트와 저장 위치를 설명합니다:

```text wrap theme={null}
Create a personal code-improver subagent in ~/.claude/agents/ that scans
files and suggests improvements for readability, performance, and best
practices. It should explain each issue, show the current code, and
provide an improved version. Make it read-only and have it use Sonnet.
```

Claude는 `name`, `description`, `tools` 목록, `model` 및 시스템 프롬프트가 포함된 파일을 작성합니다.

**2. 파일 검토**

`~/.claude/agents/code-improver.md`를 열고 frontmatter가 요청한 내용과 일치하는지 확인합니다. 결과는 다음과 같습니다:

```markdown theme={null}
---
name: code-improver
description: Scans files and suggests improvements for readability, performance, and best practices. Use after writing or modifying code.
tools: Read, Grep, Glob
model: sonnet
---

You are a code improvement specialist. For each issue you find, explain
the problem, show the current code, and provide an improved version.
```

파일이 `~/.claude/agents/`에 있으므로 서브에이전트는 머신의 모든 프로젝트에서 사용할 수 있습니다. 대신 하나의 프로젝트로 범위를 지정하려면 해당 프로젝트의 `.claude/agents/` 디렉토리로 이동합니다. [서브에이전트 범위 선택](#choose-the-subagent-scope)에서 두 가지를 비교합니다.

**3. 시도해 보기**

Claude에게 새 서브에이전트에 위임하도록 요청합니다:

```text wrap theme={null}
Use the code-improver agent to suggest improvements in this project
```

Claude가 새 서브에이전트에 위임하고, 서브에이전트가 코드베이스를 스캔하여 개선 제안을 반환합니다. 트랜스크립트에서 위임은 서브에이전트의 이름 뒤에 짧은 작업 설명(예: `code-improver(Suggest code improvements)`)이 표시된 도구 호출 행으로 나타납니다.

Claude가 새 서브에이전트를 찾을 수 없으면 Claude Code를 다시 시작하고 다시 시도합니다. 이는 세션이 시작되기 전에 `~/.claude/agents/`가 없었을 때만 발생합니다. 실행 중인 세션은 새로 생성된 `agents` 디렉토리를 감지하지 않기 때문입니다.

이제 머신의 모든 프로젝트에서 코드베이스를 분석하고 개선 사항을 제안하는 데 사용할 수 있는 서브에이전트가 있습니다.

서브에이전트 파일을 수동으로 작성하거나, CLI 플래그를 통해 정의하거나, 플러그인을 통해 배포할 수도 있습니다. 다음 섹션에서는 모든 구성 옵션을 다룹니다.

> [!NOTE]
>
> `/agents`를 실행하면 Claude에게 요청하거나 `.claude/agents/` 및 `~/.claude/agents/`를 직접 편집하라는 알림이 출력됩니다.
> Claude Code v2.1.197 이전 버전에서는 `/agents`가 라이브 서브에이전트를 나열하는 **Running** 탭과 생성, 편집 및 삭제를 위한 **Library** 탭이 있는 대화형 마법사를 엽니다.&#x20;

## 서브에이전트 구성

서브에이전트 파일의 위치는 누가 해당 서브에이전트를 사용할 수 있는지를 결정하고, frontmatter는 서브에이전트가 무엇을 할 수 있는지를 결정합니다. 이 섹션에서는 서브에이전트 파일이 저장되는 위치와 지원되는 모든 필드를 다룹니다.

### 서브에이전트 범위 선택

범위에 따라 서브에이전트 파일을 서로 다른 위치에 저장합니다. 여러 서브에이전트가 같은 이름을 공유하는 경우 Claude Code는 우선순위가 더 높은 위치의 서브에이전트를 사용합니다.

| 위치 | 범위 | 우선순위 | 생성 방법 |
| :- | :- | :- | :- |
| 관리형 설정 | 조직 전체 | 1 (최상위) | [관리형 설정](https://code.claude.com/docs/ko/settings.md)을 통해 배포 |
| `--agents` CLI 플래그 | 현재 세션 | 2 | Claude Code 실행 시 JSON 전달 |
| `.claude/agents/` | 현재 프로젝트 | 3 | Claude에게 요청하거나 파일을 직접 생성 |
| `~/.claude/agents/` | 모든 프로젝트 | 4 | Claude에게 요청하거나 파일을 직접 생성 |
| 플러그인의 `agents/` 디렉터리 | 플러그인이 활성화된 곳 | 5 (최하위) | [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)과 함께 설치 |

**프로젝트 서브에이전트**(`.claude/agents/`)는 특정 코드베이스에 특화된 서브에이전트에 적합합니다. 버전 관리에 체크인하면 팀이 함께 사용하고 개선할 수 있습니다.

프로젝트 서브에이전트는 현재 작업 디렉터리에서 위쪽으로 올라가며 탐색되므로, 그 지점과 저장소 루트 사이에 있는 모든 `.claude/agents/`가 검색됩니다. 이러한 중첩 디렉터리 중 둘 이상이 같은 `name`을 정의하는 경우 Claude Code는 작업 디렉터리에 가장 가까운 정의를 사용합니다.

`--add-dir` 또는 `/add-dir`로 디렉터리를 추가하면 Claude Code는 프로젝트 서브에이전트와 함께 해당 디렉터리의 `.claude/agents/` 폴더도 로드합니다. `--add-dir`에서 어떤 다른 구성 유형이 로드되는지는 [추가 디렉터리](https://code.claude.com/docs/ko/permissions.md#additional-directories-grant-file-access-not-configuration)를 참조하세요. `--add-dir` 없이 여러 프로젝트에서 서브에이전트를 공유하려면 `~/.claude/agents/` 또는 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)을 사용하세요.

**사용자 서브에이전트**(`~/.claude/agents/`)는 모든 프로젝트에서 사용할 수 있는 개인 서브에이전트입니다.

Claude Code는 `.claude/agents/`와 `~/.claude/agents/`를 재귀적으로 검색하므로 `agents/review/` 또는 `agents/research/`와 같은 하위 폴더로 정의를 정리할 수 있습니다. 서브에이전트의 식별은 오직 `name` frontmatter 필드로만 이루어지므로, 하위 디렉터리 경로는 서브에이전트가 식별되거나 호출되는 방식에 영향을 주지 않습니다.

`name` 값은 전체 트리에서 고유하게 유지하세요. 같은 `.claude/agents/` 디렉터리(하위 폴더 포함) 아래의 두 파일이 같은 이름을 선언하면 Claude Code는 그중 하나만 로드하며, 이는 문서화된 우선순위가 아니라 파일 시스템 읽기 순서에 따라 선택됩니다. 중첩된 프로젝트 디렉터리 간에는 위에서 설명한 것처럼 작업 디렉터리에 가장 가까운 정의가 우선합니다. [`/doctor`](https://code.claude.com/docs/ko/commands#all-commands) 설정 점검은 같은 디렉터리에서 이름을 공유하는 파일을 보고하고, 하나만 남기고 나머지의 이름을 바꾸거나 제거할 것을 제안합니다.

플러그인 `agents/` 디렉터리도 재귀적으로 검색됩니다. 프로젝트 및 사용자 범위와 달리, 플러그인의 `agents/` 디렉터리 안의 하위 폴더는 [범위 지정 식별자](#invoke-subagents-explicitly)의 일부가 됩니다. 플러그인 `my-plugin`의 `agents/review/security.md` 파일은 `my-plugin:review:security`로 등록됩니다.

**CLI 정의 서브에이전트**는 Claude Code 실행 시 JSON으로 전달됩니다. 해당 세션에만 존재하고 디스크에 저장되지 않으므로 빠른 테스트나 자동화 스크립트에 유용합니다. 단일 `--agents` 호출로 여러 서브에이전트를 정의할 수 있습니다.

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> claude --agents '{
>   "code-reviewer": {
>     "description": "Expert code reviewer. Use proactively after code changes.",
>     "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
>     "tools": ["Read", "Grep", "Glob", "Bash"],
>     "model": "sonnet"
>   },
>   "debugger": {
>     "description": "Debugging specialist for errors and test failures.",
>     "prompt": "You are an expert debugger. Analyze errors, identify root causes, and provide fixes."
>   }
> }'
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> claude --agents @'
> {
>   "code-reviewer": {
>     "description": "Expert code reviewer. Use proactively after code changes.",
>     "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
>     "tools": ["Read", "Grep", "Glob", "Bash"],
>     "model": "sonnet"
>   },
>   "debugger": {
>     "description": "Debugging specialist for errors and test failures.",
>     "prompt": "You are an expert debugger. Analyze errors, identify root causes, and provide fixes."
>   }
> }
> '@
> ```

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 명령줄로 전달하기에 너무 큰 정의를 위해 `--agents`가 동일한 객체를 담은 JSON 파일의 경로도 받습니다. 예를 들어 `claude -p --agents ./agents.json "Review my changes"`는 해당 파일에서 정의를 읽습니다. 대화형 세션에서는 Claude Code가 파일 경로를 거부합니다. 파일 형식을 사용하려면 Claude Code v2.1.281 이상이 필요합니다.

JSON의 각 최상위 키는 에이전트의 이름이고, 그 값은 해당 에이전트의 정의입니다. 이름을 `-`로 시작하지 마세요. 정의는 다음 필드를 받습니다.

* **`prompt`**: 에이전트의 시스템 프롬프트로, 파일 기반 서브에이전트의 markdown 본문에 해당합니다. `prompt`는 비어 있을 수 있습니다. `prompt`가 비어 있고 `memory` 필드가 없는 에이전트를 `--agent`로 세션의 에이전트로 선택하면 세션의 시스템 프롬프트는 변경되지 않습니다. 빈 `prompt`를 사용하려면 Claude Code v2.1.281 이상이 필요합니다.
* **[Frontmatter 필드](#supported-frontmatter-fields)**: `description`, `tools`, `disallowedTools`, `model`, `permissionMode`, `mcpServers`, `hooks`, `maxTurns`, `autoCompactWindow`, `skills`, `initialPrompt`, `memory`, `effort`, `background`, `omitClaudeMd`, `isolation`.
* **무시되는 필드**: `color`와 `experimental`은 여기서 허용되지 않으며, 거부되는 대신 무시됩니다.

Claude Code가 로드할 수 없는 값을 어떻게 처리하는지, 그리고 해당 검사를 건너뛰는 플래그와 환경 변수에 대해서는 [`Invalid --agents configuration`](https://code.claude.com/docs/ko/errors#invalid-agents-configuration)을 참조하세요.

**관리형 서브에이전트**는 조직 관리자가 배포합니다. [관리형 설정 디렉터리](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms) 안의 `.claude/agents/`에 markdown 파일을 배치하며, 프로젝트 및 사용자 서브에이전트와 동일한 frontmatter 형식을 사용합니다. 관리형 정의는 같은 이름의 프로젝트 및 사용자 서브에이전트보다 우선합니다.

**플러그인 서브에이전트**는 설치한 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)에서 제공됩니다. 사용자 정의 서브에이전트와 함께 자동으로 로드되며, @-멘션 자동 완성에 범위 지정 이름으로 표시됩니다. 플러그인 서브에이전트 생성에 대한 자세한 내용은 [플러그인 구성 요소 참조](https://code.claude.com/docs/ko/plugins/components.md#agents)를 참조하세요.

> [!NOTE]
>
> 보안상의 이유로 플러그인 서브에이전트는 `hooks`, `mcpServers`, `permissionMode` frontmatter 필드를 지원하지 않습니다. 플러그인에서 에이전트를 로드할 때 이러한 필드는 무시됩니다. 이 필드가 필요하다면 에이전트 파일을 `.claude/agents/` 또는 `~/.claude/agents/`에 복사하세요. `settings.json` 또는 `settings.local.json`의 [`permissions.allow`](https://code.claude.com/docs/ko/settings-reference#permissions-allow)에 규칙을 추가할 수도 있지만, 이러한 규칙은 플러그인 서브에이전트뿐만 아니라 세션 전체에 적용됩니다.
>
> 플러그인 작성자라면 대신 훅은 플러그인의 [`hooks/hooks.json`](https://code.claude.com/docs/ko/plugins/components#hooks)에, MCP 서버는 플러그인의 [`.mcp.json`](https://code.claude.com/docs/ko/plugins/components#mcp-servers)에 포함하여 배포하세요. 이들은 서브에이전트 내부에서만이 아니라 플러그인이 활성화되어 있을 때마다 적용됩니다.

서브에이전트 정의를 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 팀원으로 재사용할 수도 있습니다. Claude에게 팀원 생성을 요청할 때 서브에이전트 유형을 지정하면 Claude Code가 해당 정의의 일부를 팀원에게 적용합니다. 각 표시 모드에서 어떤 범위와 어떤 부분이 적용되는지는 [팀원에 서브에이전트 정의 사용](https://code.claude.com/docs/ko/agent-teams.md#use-subagent-definitions-for-teammates)에 설명되어 있습니다.

### 서브에이전트 파일 작성

서브에이전트 파일은 구성을 위한 YAML frontmatter와 그 뒤에 오는 Markdown 형식의 시스템 프롬프트로 이루어집니다.

> [!NOTE]
>
> Claude Code는 `~/.claude/agents/`와 `.claude/agents/`를 감시합니다. 디스크에서 서브에이전트 파일을 추가하거나 편집하거나 Claude에게 작성을 요청하면, Claude Code는 몇 초 안에 변경을 감지하고 다음 위임부터 업데이트된 정의를 사용하므로 재시작할 필요가 없습니다.
>
> 다만 다음 세 가지 경우에는 여전히 재시작이 필요합니다.
>
> * 감시기는 세션이 시작될 때 존재했던 디렉터리만 대상으로 하므로, 새 `agents` 디렉터리에 해당 범위의 첫 에이전트 파일을 만든 후에는 재시작해야 로드됩니다.
> * Claude Code는 `--add-dir` 또는 `/add-dir`로 추가된 디렉터리 내부의 `.claude/agents/`를 감시하지 않으므로, 그곳에서 서브에이전트를 추가하거나 편집한 후에는 재시작해야 변경 사항이 로드됩니다.
> * `--disable-slash-commands`로 시작한 세션은 이러한 디렉터리를 전혀 감시하지 않습니다.

```markdown .claude/agents/code-reviewer.md theme={null}
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---

You are a code reviewer. When invoked, analyze the code and provide
specific, actionable feedback on quality, security, and best practices.
```

frontmatter는 서브에이전트의 메타데이터와 구성을 정의합니다. 본문은 서브에이전트의 동작을 안내하는 시스템 프롬프트가 됩니다. 서브에이전트는 Claude Code 시스템 프롬프트가 아니라 이 시스템 프롬프트와 작업 디렉터리 같은 기본 환경 정보만 받습니다.

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 [`--append-subagent-system-prompt`](https://code.claude.com/docs/ko/cli-reference#cli-flags)를 전달하면 중첩된 서브에이전트를 포함한 모든 서브에이전트의 시스템 프롬프트 끝에 텍스트가 추가됩니다. 단, 대화 자체의 프롬프트를 재사용하는 [포크된 서브에이전트](#fork-the-current-conversation)는 제외됩니다. Claude Code v2.1.205 이상이 필요합니다. 텍스트가 너무 길어 명령줄로 전달할 수 없다면 파일로 저장한 뒤 대신 `--append-subagent-system-prompt-file`로 경로를 전달하세요. 파일 플래그를 사용하려면 Claude Code v2.1.261 이상이 필요합니다.

서브에이전트는 메인 대화의 현재 작업 디렉터리에서 시작합니다. 서브에이전트 내에서 `cd` 명령은 Bash 또는 PowerShell 도구 호출 간에 유지되지 않으며 메인 대화의 작업 디렉터리에 영향을 주지 않습니다. 대신 서브에이전트에 저장소의 격리된 복사본을 제공하려면 [`isolation: worktree`](#supported-frontmatter-fields)를 설정하세요.

`isolation: worktree`가 설정된 서브에이전트는 Bash 및 PowerShell 명령을 자신의 워크트리 안에서 실행합니다. 예를 들어 서브에이전트가 실행되는 동안 워크트리 디렉터리가 제거되어 작업 디렉터리가 메인 체크아웃으로 해석되는 명령은 오류와 함께 실패합니다.

이 작업 디렉터리 검사는 Claude Code를 실행한 디렉터리를 포함하는 저장소 전체를 대상으로 합니다. 세션이 자체적으로 연결된 [worktree](https://code.claude.com/docs/ko/worktrees.md)에서 실행되는 경우, 검사는 해당 워크트리가 연결된 메인 체크아웃도 대상으로 합니다.

Bash 명령의 경우 Claude Code는 명령 자체도 두 가지 방식으로 검사합니다.

* git을 메인 체크아웃으로 리디렉션하는 명령을 차단합니다.
* 예를 들어 명령 이름이 런타임에 계산되는 경우처럼, 명령이 실행하는 git이 워크트리 안에 머무는지를 명령 텍스트로 확인할 수 없으면 해당 명령을 거부합니다.

리디렉션 벡터와 형태 규칙은 [Claude Code가 격리를 적용하는 방식](https://code.claude.com/docs/ko/worktrees.md#how-claude-code-enforces-isolation)에 나와 있습니다. PowerShell 명령에는 작업 디렉터리 검사만 적용됩니다.

[Monitor](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 명령은 Bash 명령과 동일한 작업 디렉터리 및 명령 내용 검사를 거칩니다.

메인 대화 자체가 워크트리에서 격리되어 실행되는 경우, Claude Code는 `isolation: worktree`가 없는 서브에이전트를 포함하여 세션과 세션이 생성하는 모든 서브에이전트에 동일한 검사를 적용합니다. [Claude Code가 격리를 적용하는 방식](https://code.claude.com/docs/ko/worktrees.md#how-claude-code-enforces-isolation)을 참조하세요.

### Frontmatter 참조

파일 상단의 `---` 표시 사이에 YAML [frontmatter](https://code.claude.com/docs/ko/glossary.md#frontmatter)로 서브에이전트를 구성하고, 닫는 `---` 뒤에 Markdown으로 시스템 프롬프트를 작성합니다. `name`과 `description`만 필수입니다.

여러 단어로 된 필드 이름은 `maxTurns`, `disallowedTools`처럼 camelCase를 사용하며 표와 정확히 일치해야 합니다. Claude Code는 인식하지 못하는 필드를 오류 보고 없이 무시합니다.

* 로드된 서브에이전트에서 철자가 잘못된 필드를 찾으려면 셸에서 [`claude --debug`](https://code.claude.com/docs/ko/cli-reference#cli-flags)를 실행하고 `~/.claude/debug/<session-id>.txt`의 디버그 로그에서 `does not recognize or apply`를 검색하세요. 디버그 로그는 서브에이전트 파일에서 Claude Code가 인식하지 못하는 최상위 필드를 최대 5개까지 알려 주며, 지원되는 필드와 비슷한 경우 의도했을 가능성이 높은 이름도 함께 표시합니다. Claude Code v2.1.296 이상이 필요합니다.
* 서브에이전트 파일이 로드되지 않은 이유를 알아보려면 [Claude Code가 건너뛰는 서브에이전트 파일](#subagent-files-claude-code-skips)을 참조하세요.

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `name` | 예 | `code-reviewer` 또는 `reviewer-v2`처럼 최대 256자의 고유 식별자입니다. [훅](https://code.claude.com/docs/ko/hooks.md#subagentstart)은 이 값을 `agent_type`으로 받습니다. 파일 이름과 일치할 필요는 없습니다. 이름에는 `:`를 포함할 수 없으며, 이는 `my-plugin:reviewer`와 같은 [플러그인 범위 식별자](https://code.claude.com/docs/ko/plugins/overview.md)용으로 예약되어 있습니다 |
| `description` | 예 | Claude가 이 서브에이전트에 위임해야 하는 시점 |
| `tools` | 아니요 | 서브에이전트가 사용할 수 있는 [도구](#available-tools)로, `Read, Grep, Bash`와 같은 쉼표로 구분된 문자열 또는 YAML 목록입니다. 생략하면 서브에이전트에서 사용 가능한 모든 도구를 상속합니다. 목록의 어떤 항목도 도구로 해석되지 않으면 서브에이전트는 보통 해당 항목을 명시한 오류와 함께 [실행에 실패](https://code.claude.com/docs/ko/errors.md#agent-would-be-spawned-with-zero-tools)합니다. Skills를 컨텍스트에 미리 로드하려면 여기에 `Skill`을 나열하는 대신 `skills` 필드를 사용하세요 |
| `disallowedTools` | 아니요 | 거부할 도구로, 상속되거나 지정된 목록에서 제거됩니다. 형식은 `tools`와 같습니다. `Bash(git push *)`처럼 지정자가 있는 항목도 여전히 [도구 전체를 제거](#restrict-which-tools-a-subagent-can-use)합니다 |
| `model` | 아니요 | 사용할 [모델](#choose-a-model): `sonnet`, `opus`, `haiku`, `fable`, `claude-opus-5-5`와 같은 전체 모델 ID 또는 `inherit`. 생략하면 Claude Code가 [서브에이전트 모델 순서](#choose-a-model)에 따라 모델을 선택합니다 |
| `permissionMode` | 아니요 | [권한 모드](#permission-modes): `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan` 또는 `default`의 별칭인 `manual`. [플러그인 서브에이전트](#choose-the-subagent-scope)에서는 무시됩니다 |
| `maxTurns` | 아니요 | 서브에이전트가 중지되기 전까지의 최대 에이전트 턴 수입니다. 서브에이전트가 한도에 도달하면 Claude Code는 출력을 부분 결과로 표시하여 반환하며, Claude는 계속 진행하기 위해 [서브에이전트를 재개](#resume-subagents)할 수 있습니다. 부분 결과 표시는 Claude Code v2.1.246 이상이 필요합니다 |
| `autoCompactWindow` | 아니요 | 이 서브에이전트의 [자동 압축 윈도우](#subagent-auto-compact-window)를 `100000`에서 `1000000` 사이의 토큰 수로 낮춥니다. Claude Code v2.1.296 이상이 필요합니다 |
| `skills` | 아니요 | 시작 시 서브에이전트의 컨텍스트에 미리 로드할 [스킬](https://code.claude.com/docs/ko/skills.md)입니다. 설명만이 아니라 스킬의 전체 내용이 주입됩니다. 서브에이전트는 여전히 Skill 도구를 통해 나열되지 않은 프로젝트, 사용자, 플러그인 스킬을 호출할 수 있습니다 |
| `mcpServers` | 아니요 | 이 서브에이전트가 사용할 수 있는 [MCP 서버](https://code.claude.com/docs/ko/mcp.md)입니다. 각 항목은 이미 구성된 서버를 참조하는 서버 이름(예: `"slack"`)이거나, 서버 이름을 키로 하고 전체 [MCP 서버 구성](https://code.claude.com/docs/ko/mcp.md#installing-mcp-servers)을 값으로 하는 인라인 정의입니다. [플러그인 서브에이전트](#choose-the-subagent-scope)에서는 무시됩니다 |
| `hooks` | 아니요 | 이 서브에이전트로 범위가 지정된 [라이프사이클 훅](#define-hooks-for-subagents)입니다. [플러그인 서브에이전트](#choose-the-subagent-scope)에서는 무시됩니다 |
| `memory` | 아니요 | [영구 메모리 범위](#enable-persistent-memory): `user`, `project` 또는 `local`. 세션 간 학습을 가능하게 합니다 |
| `background` | 아니요 | Claude가 이 서브에이전트를 기다리도록 요청하더라도 백그라운드에 유지하려면 `true`로 설정합니다. 기본적으로 Claude가 메인 대화에서 생성하는 서브에이전트는 이미 [백그라운드에서 시작](#run-subagents-in-foreground-or-background)합니다 |
| `omitClaudeMd` | 아니요 | 이 서브에이전트를 [초기 컨텍스트](#what-loads-at-startup)에 사용자, 프로젝트, 로컬 CLAUDE.md 파일 없이 시작하려면 `true`로 설정합니다. [관리형 정책 파일](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load)은 [관리형 서브에이전트](#choose-the-subagent-scope)를 제외하고 여전히 로드됩니다. 위임 프롬프트에서 필요한 모든 것을 받는 서브에이전트에 사용하세요. 에이전트가 `--agent` 또는 `agent` 설정을 통해 메인 세션 에이전트로 실행될 때는 무시됩니다. Claude Code v2.1.271 이상이 필요합니다 |
| `effort` | 아니요 | 이 서브에이전트가 활성화되어 있을 때의 effort 수준입니다. 세션 effort 수준을 재정의하지만 [`CLAUDE_CODE_EFFORT_LEVEL`](https://code.claude.com/docs/ko/env-vars#variables) 환경 변수는 재정의하지 않습니다. 옵션: `low`, `medium`, `high`, `xhigh`, `max`. 사용 가능한 수준은 모델에 따라 다릅니다. [effort 수준 선택](#choose-an-effort-level)을 참조하세요 |
| `isolation` | 아니요 | 서브에이전트를 임시 [git worktree](https://code.claude.com/docs/ko/worktrees.md)에서 실행하려면 `worktree`로 설정합니다. 이렇게 하면 부모 세션의 `HEAD`가 아니라 기본적으로 [기본 브랜치](https://code.claude.com/docs/ko/worktrees.md#choose-the-base-branch)에서 분기된 저장소의 격리된 복사본이 제공됩니다. 서브에이전트가 변경 사항을 만들지 않으면 워크트리는 자동으로 정리됩니다 |
| `color` | 아니요 | 작업 목록과 트랜스크립트에서 서브에이전트의 표시 색상입니다. `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan`을 허용합니다 |
| `initialPrompt` | 아니요 | 이 에이전트가 메인 세션 에이전트로 실행될 때(`--agent` 또는 `agent` 설정을 통해) 첫 번째 사용자 턴으로 자동 제출됩니다. [명령](https://code.claude.com/docs/ko/commands.md)과 [스킬](https://code.claude.com/docs/ko/skills.md)이 처리됩니다. 사용자가 제공한 프롬프트 앞에 추가됩니다. [플러그인 서브에이전트](#choose-the-subagent-scope)에서는 무시됩니다 |
| `experimental` | 아니요 | 실험적 옵션의 맵입니다. `cacheTtl` 키를 `5m` 또는 `1h`로 설정하면 이 서브에이전트의 요청에 대한 [프롬프트 캐시 수명](https://code.claude.com/docs/ko/prompt-caching.md#choose-the-ttl-yourself)을 [캐시 수명 우선순위](https://code.claude.com/docs/ko/prompt-caching.md#choose-the-ttl-yourself)에서 frontmatter의 위치로 선택할 수 있습니다. Claude Code는 다른 값을 무시하고, Claude 구독이 사용량 크레딧을 사용 중인 동안에는 `1h`를 무시하며, 이 필드는 서브에이전트 파일에서만 읽습니다. Claude Code v2.1.248 이상이 필요합니다 |

`cacheTtl`은 frontmatter의 최상위가 아니라 `experimental` 맵 안에 작성하세요.

```yaml theme={null}
---
name: repo-auditor
description: Audits a large repository and reports what it finds
experimental:
  cacheTtl: 1h
---
```

#### Claude Code가 건너뛰는 서브에이전트 파일

프로젝트, 사용자 또는 관리형 `agents` 디렉터리에 있거나 `--add-dir`로 추가한 디렉터리 아래의 `agents` 디렉터리에 있는 파일의 frontmatter에 다음 문제 중 하나가 있으면, Claude Code는 세션에서 이를 보고하지 않고 해당 파일을 건너뜁니다.

* **`name` 없음**: Claude Code는 해당 파일을 에이전트 옆에 보관된 문서로 취급합니다.
* **여는 `---`가 파일의 첫 줄이 아님**: Claude Code는 해당 파일에 frontmatter가 없는 것으로 읽고 문서로 취급합니다.
* **`name`이 `-`로 시작하거나, `:`를 포함하거나, 256자를 초과함**: Claude Code는 파일을 건너뛰고 디버그 로그에 오류를 기록합니다.
* **`name`은 있지만 `description`이 없음**: Claude Code는 파일을 건너뛰고 디버그 로그에 이유를 기록합니다.
* **YAML을 파싱할 수 없음**: Claude Code는 파일에서 어떤 필드도 읽지 않고 건너뛰며 디버그 로그에 파싱 오류를 기록합니다.

디버그 로그를 보려면 `--debug`와 함께 Claude Code를 실행하세요.

frontmatter에 `name`이 없거나 파싱되지 않는 [플러그인 서브에이전트](https://code.claude.com/docs/ko/plugins/components.md#agents)는 파일 이름으로 여전히 로드됩니다.

##### 세션 전에 `agents` 디렉터리 확인

`agents` 디렉터리에서 frontmatter가 파싱되지 않는 파일을 찾으려면 `.claude/agents` 또는 `~/.claude/agents`와 같은 디렉터리를 대상으로 `claude plugin validate`를 실행하세요. Claude Code는 [지정한 디렉터리](https://code.claude.com/docs/ko/plugins/cli-reference.md#validate-a-directory)만 검사하며, frontmatter는 파싱되지만 `name`이 없는 파일은 표시하지 않습니다. Claude Code v2.1.233 이상이 필요합니다.

### 모델 선택

`model` 필드는 서브에이전트가 사용할 모델을 제어합니다.

* **모델 별칭**: 사용 가능한 별칭 중 하나를 사용합니다: `sonnet`, `opus`, `haiku` 또는 `fable`
* **전체 모델 ID**: `claude-opus-5-5` 또는 `claude-sonnet-5`와 같은 전체 모델 ID를 사용합니다. `--model` 플래그와 동일한 값을 허용합니다
* **inherit**: 메인 대화와 동일한 모델을 사용합니다

Claude가 서브에이전트를 호출할 때 해당 호출에 대해 `model` 매개변수를 전달할 수도 있습니다. Agent 도구 호출에서 이 매개변수는 모델 별칭 `sonnet`, `opus`, `haiku` 또는 `fable`을 받습니다. Claude는 해당 호출에서 전체 모델 ID나 `inherit`를 전달할 수 없습니다. Claude Code는 다음 순서로 서브에이전트의 모델을 결정합니다.

1. 호출별 `model` 매개변수
2. 서브에이전트 정의의 `model` frontmatter. 여기서 `inherit`는 메인 대화의 모델을 선택합니다
3. 모델 별칭이나 모델 ID로 설정한 경우 [`CLAUDE_CODE_SUBAGENT_MODEL`](https://code.claude.com/docs/ko/model-config#environment-variables) 환경 변수
4. 메인 대화의 모델

설치된 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)가 [`agent.spawn`](https://code.claude.com/docs/ko/plugins/mods/reference#subagents) 훅에서 모델을 설정하면 Claude Code는 호출별 매개변수 대신 해당 모델을 사용합니다.

다음 두 경우에는 호출별 매개변수나 frontmatter의 `opus`와 같은 계열 별칭이 [별칭이 가리키는 버전](https://code.claude.com/docs/ko/model-config.md#model-aliases) 대신 메인 대화의 모델로 해석됩니다.

* **메인 대화의 모델이 해당 계열에 속하는 경우**: 서브에이전트는 `[1m]` 접미사를 포함하여 메인 대화와 정확히 동일한 모델에서 실행되므로 메인 대화와 동일한 [확장 컨텍스트](https://code.claude.com/docs/ko/model-config.md#extended-context) 윈도우를 얻습니다.
* **[Anthropic API 이외의 제공자](https://code.claude.com/docs/ko/third-party-integrations.md)에서 Claude Code가 메인 대화의 모델 계열을 알 수 없는 경우**: Claude Code가 기반 모델로 해석하지 못한 Amazon Bedrock의 [애플리케이션 추론 프로필 ARN](https://code.claude.com/docs/ko/amazon-bedrock.md#iam-configuration)에서 이런 일이 발생할 수 있습니다. 이 경우는 `opus` 별칭에만 해당하며, [`ANTHROPIC_DEFAULT_OPUS_MODEL`](https://code.claude.com/docs/ko/model-config#environment-variables)을 설정한 경우에는 `opus`가 설정한 모델로 해석되므로 적용되지 않습니다.

`CLAUDE_CODE_SUBAGENT_MODEL`의 별칭은 메인 대화의 계열을 가리키더라도 항상 별칭이 가리키는 버전으로 해석됩니다. 이 변수를 `inherit`로 설정하는 것은 설정하지 않은 것과 같습니다.

`CLAUDE_CODE_SUBAGENT_MODEL`만 설정해서는 기본 제공 Explore 및 Plan 서브에이전트가 실행되는 모델이 바뀌지 않습니다. 이를 바꾸려면 [모든 서브에이전트를 하나의 모델에서 실행](#run-every-subagent-on-one-model)을 참조하세요.

v2.1.251 이전에는 `CLAUDE_CODE_SUBAGENT_MODEL`이 이 순서에서 가장 먼저 왔으며, `model: inherit`를 포함하여 호출별 매개변수와 frontmatter를 모두 재정의했습니다.

Claude Code는 호출별 매개변수, frontmatter, 환경 변수 값을 조직의 [`availableModels`](https://code.claude.com/docs/ko/model-config#restrict-model-selection) 허용 목록과 대조하여 확인합니다. 차단된 값에 대해서는 다른 모델로 대체합니다.

* 차단된 값이 `opus`와 같은 계열 별칭인 경우, Claude Code는 `/model`과 동일한 [대체 규칙 및 제공자 범위](https://code.claude.com/docs/ko/model-config.md#restrict-model-selection)에 따라 허용 목록이 허용하는 해당 계열의 최신 버전에서 서브에이전트를 실행합니다. v2.1.222 이전에는 차단된 계열 별칭에 대해서도 Claude Code가 상속된 모델에서 서브에이전트를 실행했습니다.
* 그 밖의 차단된 값이거나, 해당 대체가 작동하지 않는 제공자이거나, 허용 목록이 해당 계열의 어떤 버전도 허용하지 않는 경우, Claude Code는 대신 상속된 모델에서 서브에이전트를 실행합니다. `CLAUDE_CODE_SUBAGENT_MODEL`을 설정한 경우 Claude Code는 동일한 규칙에 따라 해당 모델을 먼저 시도합니다.

대화형 세션에서 Claude Code는 두 가지 대체 모두에 대해 요청된 모델과 서브에이전트가 실행되는 모델을 명시한 경고를 표시합니다.

서브에이전트가 어떤 모델에서 실행 중인지 확인하려면 [`/tasks`](https://code.claude.com/docs/ko/commands)를 실행하세요. Claude Code는 서브에이전트 행에 모델을 표시하고, 해당 서브에이전트에 설정된 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)이 있으면 함께 표시합니다. Claude Code v2.1.242 이상이 필요합니다.

호출별 `model` 매개변수는 서브에이전트가 [재개되거나 후속 메시지를 받을](#resume-subagents) 때도 적용되므로 서브에이전트는 해당 모델에 계속 머무릅니다.

v2.1.198부터 서브에이전트는 메인 대화의 [확장 사고](https://code.claude.com/docs/ko/model-config.md#extended-thinking) 구성도 상속합니다. 세션에서 사고가 켜져 있으면 서브에이전트에서도 켜져 있고, 꺼져 있으면 꺼진 상태로 유지됩니다. 서브에이전트별 사고 설정은 없습니다. v2.1.198 이전에는 메인 대화의 설정과 관계없이 서브에이전트가 확장 사고가 비활성화된 상태로 실행되었습니다.

#### 모든 서브에이전트를 하나의 모델에서 실행

`CLAUDE_CODE_SUBAGENT_MODEL`은 기본값이므로 서브에이전트의 정의나 Claude가 전달하는 모델이 여전히 이보다 우선합니다. 모든 서브에이전트, [팀원](https://code.claude.com/docs/ko/agent-teams.md#specify-teammates-and-models), [워크플로 에이전트](https://code.claude.com/docs/ko/workflows.md)에 하나의 모델을 적용하려면 `CLAUDE_CODE_SUBAGENT_MODEL_FORCE`도 `1`로 설정하세요. Claude Code v2.1.257 이상이 필요합니다.

* 두 변수를 모두 설정하면 서브에이전트는 `CLAUDE_CODE_SUBAGENT_MODEL`의 모델에서 실행됩니다.
* `CLAUDE_CODE_SUBAGENT_MODEL_FORCE`만 설정하면 서브에이전트는 메인 대화의 모델에서 실행됩니다. 단, 기본 제공 Explore 서브에이전트는 [기본 제공 서브에이전트에 나열된 모델](#built-in-subagents)에서 실행됩니다.

예를 들어 모든 서브에이전트를 Haiku에서 실행하려면 [설정 파일](https://code.claude.com/docs/ko/settings.md)의 `env` 블록에 두 변수를 모두 설정합니다.

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",
    "CLAUDE_CODE_SUBAGENT_MODEL_FORCE": "1"
  }
}
```

설정이 적용되었는지 확인하려면 서브에이전트가 실행되는 동안 [`/tasks`](https://code.claude.com/docs/ko/commands)를 실행하세요. 서브에이전트 행에 실행 중인 모델이 표시됩니다.

`CLAUDE_CODE_SUBAGENT_MODEL_FORCE`가 [켜져 있는](https://code.claude.com/docs/ko/env-vars.md) 동안 Claude Code는 서브에이전트 정의의 `model` 필드를 무시하며, Claude는 서브에이전트를 시작할 때 모델을 전달할 수 없습니다. 다음 서브에이전트는 여전히 메인 대화의 모델에서 실행됩니다.

* [포크](#fork-the-current-conversation)
* `model: inherit`가 설정된 [서브에이전트에서 실행되는 스킬](https://code.claude.com/docs/ko/skills.md#run-skills-in-a-subagent)

### effort 수준 선택

서브에이전트를 자체 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)으로 실행하려면 정의에서 [`effort`](#supported-frontmatter-fields) 필드를 설정하세요.

Claude에게 포크가 아닌 서브에이전트를 특정 effort 수준으로 실행하도록 요청하면, Claude는 해당 호출에 대해 `effort` 매개변수를 전달할 수도 있습니다. 이 매개변수는 `effort` 필드를 재정의하며 서브에이전트가 [재개](#resume-subagents)될 때도 유지됩니다. [`CLAUDE_CODE_EFFORT_LEVEL`](https://code.claude.com/docs/ko/env-vars#variables) 환경 변수는 둘 다보다 우선합니다. 호출별 매개변수는 Claude Code v2.1.292 이상이 필요합니다.

### 서브에이전트 기능 제어

도구 접근, 권한 모드, 조건부 규칙을 통해 서브에이전트가 할 수 있는 작업을 제어할 수 있습니다.

#### 사용 가능한 도구

서브에이전트는 메인 대화에서 사용 가능한 [기본 제공 도구](https://code.claude.com/docs/ko/tools-reference.md)와 MCP 도구를 상속하며, 두 가지 필터로 범위가 좁혀집니다. 첫 번째 필터는 모든 서브에이전트에서 짧은 목록의 도구를 제거하고, 두 번째 필터는 기본값인 [백그라운드](#run-subagents-in-foreground-or-background)에서 실행되는 서브에이전트의 기본 제공 도구 세트를 줄입니다. macOS, Linux, WSL에서는 [Glob 도구 동작](https://code.claude.com/docs/ko/tools-reference.md#glob-tool-behavior)에 설명된 대로 메인 대화에 Glob 및 Grep 도구가 없더라도 서브에이전트가 이를 받을 수 있습니다. [포크](#fork-the-current-conversation)는 두 필터를 모두 건너뛰고 메인 대화와 정확히 동일한 도구 풀을 받습니다. 첫 번째 필터는 `tools` 필드에 나열되어 있더라도 다음 도구를 제거합니다.

* 서브에이전트가 [깊이 제한](#let-subagents-spawn-their-own-subagents)에 도달한 경우의 `Agent`. [포크](#fork-the-current-conversation)에서는 도구가 목록에 남아 있지만 생성하는 대신 오류를 반환합니다
* `AskUserQuestion`
* 메인 대화만 종료할 수 있는 `EndConversation`. [EndConversation 도구 동작](https://code.claude.com/docs/ko/tools-reference.md#endconversation-tool-behavior)을 참조하세요
* `EnterPlanMode`
* 서브에이전트의 [`permissionMode`](#permission-modes)가 `plan`이 아닌 경우의 `ExitPlanMode`
* `ScheduleWakeup`
* `WaitForMcpServers`
* `Workflow`

두 번째 필터는 백그라운드에서 실행되는 서브에이전트에 적용됩니다. 서브에이전트가 어디서 실행되든 첫 번째 필터의 조건을 따르는 `Agent`와 `ExitPlanMode`를 제외하면, 백그라운드 서브에이전트는 모든 MCP 도구를 유지하지만 기본 제공 도구는 `Read`, `Grep`, `Glob`, `LSP`, `Bash`, `PowerShell`, `Edit`, `Write`, `NotebookEdit`, `WebFetch`, `WebSearch`, `TodoWrite`, `Skill`, `ToolSearch`, `EnterWorktree`, `ExitWorktree`, `Monitor`, `TaskStop`, `SendMessage`, `Artifact`만 유지하며, 이를 통해 보고하는 서브에이전트의 경우 [`SubagentHandback`](https://code.claude.com/docs/ko/tools-reference)도 유지합니다. Claude Code는 상속되었든 `tools` 필드에 나열되었든 그 밖의 모든 기본 제공 도구를 백그라운드 서브에이전트에서 제거하므로, 같은 정의라도 포그라운드와 백그라운드에서 서로 다른 도구로 해석될 수 있습니다. 이 제거로 인해 `tools` 목록이 [아무것도 해석되지 않는](https://code.claude.com/docs/ko/errors.md#agent-would-be-spawned-with-zero-tools) 상태가 되지 않는 한 오류는 보고되지 않습니다.

v2.1.280 이전에는 백그라운드 서브에이전트가 `LSP`를 사용할 수 없었습니다.

[`ListAgents`](https://code.claude.com/docs/ko/cross-session-messaging)는 다른 기본 제공 도구와 마찬가지로 이러한 필터를 따릅니다. 세션 간 메시징이 활성화된 세션에서 포그라운드 서브에이전트는 이를 상속하지만, 백그라운드 서브에이전트는 이를 유지하지 않습니다.

[에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md)의 팀원은 추가로 작업 도구와 cron 도구를 유지합니다: `TaskCreate`, `TaskGet`, `TaskList`, `TaskUpdate`, `CronCreate`, `CronDelete`, `CronList`. [Task 도구가 없는 세션](https://code.claude.com/docs/ko/tools-reference.md#task-tool-availability)에서는 서브에이전트가 다른 모델을 실행하더라도 Claude Code가 서브에이전트에도 작업 도구를 제공하지 않습니다. 인프로세스 팀원도 같은 방식으로 세션을 따릅니다. 분할 창 팀원에게 작업 도구가 있는지 확인하려면 [Task 도구 가용성](https://code.claude.com/docs/ko/tools-reference.md#task-tool-availability)을 참조하세요.

#### 서브에이전트가 사용할 수 있는 도구 제한

도구를 제한하려면 `tools` 필드를 허용 목록으로, 또는 `disallowedTools` 필드를 거부 목록으로 사용하세요. 둘 다 설정된 경우 `disallowedTools`가 먼저 적용된 다음, 남은 풀을 대상으로 `tools`가 해석됩니다. 두 곳 모두에 나열된 도구는 제거됩니다.

이 예시는 `tools`를 사용하여 Read, Grep, Glob, Bash만 허용합니다. 서브에이전트는 파일을 편집하거나 작성할 수 없고 MCP 도구도 사용할 수 없습니다.

```yaml theme={null}
---
name: safe-researcher
description: Research agent with restricted capabilities
tools: Read, Grep, Glob, Bash
---
```

이 예시는 `disallowedTools`를 사용하여 Write와 Edit를 제외한 서브에이전트의 도구 풀을 상속합니다. 서브에이전트는 Bash, MCP 도구 및 풀의 나머지 도구를 유지합니다.

```yaml theme={null}
---
name: no-writes
description: Inherits the available tools except file writes
disallowedTools: Write, Edit
---
```

예를 들어 모든 항목의 철자가 잘못되었거나 서브에이전트에서 사용할 수 없는 도구를 지정하여 `tools` 목록의 어떤 항목도 도구로 해석되지 않으면, Claude Code는 보통 서브에이전트 실행을 거부하고 Agent 도구는 해석되지 않은 항목을 명시한 오류를 반환합니다. 메시지와 각 항목을 수정하는 방법은 [Agent would be spawned with zero tools](https://code.claude.com/docs/ko/errors.md#agent-would-be-spawned-with-zero-tools)를 참조하세요.

`tools` 및 `disallowedTools` 필드는 MCP 서버 전체에 대한 항목도 받습니다.

| 목표 | 필드 | 예시 항목 |
| :- | :- | :- |
| 서브에이전트에 하나의 서버의 모든 도구 제공 | `tools` | `mcp__github__*` |
| 하나의 서버의 도구 제외 | `disallowedTools` | `mcp__github` 또는 `mcp__github__*` |
| 모든 서버의 모든 MCP 도구 제외 | `disallowedTools` | `mcp__*` |

이 예시는 서브에이전트의 풀에서 다른 서버의 도구와 기본 제공 도구는 유지하면서 `github` MCP 서버의 모든 도구를 제거합니다.

```yaml theme={null}
---
name: local-only
description: Inherits every tool except those from the github MCP server
disallowedTools: mcp__github
---
```

`Bash(git push *)`처럼 지정자가 있는 `disallowedTools` 항목도 일치하는 명령만이 아니라 서브에이전트에서 도구 전체를 제거합니다. Bash를 유지하면서 특정 명령을 차단하려면 설정의 `permissions.deny`에 `Bash(git push *)`와 같은 [Bash 거부 규칙](https://code.claude.com/docs/ko/permissions.md#bash)을 추가하세요. 이 규칙은 메인 대화와 서브에이전트 모두에 적용됩니다.

##### 이중 밑줄이 포함된 MCP 서버 이름

`reports__v2`처럼 이름에 `__`가 포함된 MCP 서버의 도구를 서브에이전트가 하나도 받지 못한다면 서브에이전트의 `mcp__` 항목을 확인하세요.

* **`tools`의 경우**: `mcp__reports__v2__*`처럼 `mcp__` 뒤에 [서버의 전체 이름](https://code.claude.com/docs/ko/permissions.md#mcp)과 `__*`를 작성합니다. 끝의 `__*`가 없으면 `mcp__reports__v2`는 해당 서버의 어떤 도구와도 일치하지 않습니다.
* **`disallowedTools`의 경우**: `reports`라는 이름의 서버를 제외하는 항목인 `mcp__reports` 또는 `mcp__reports__*`가 있는지 확인합니다. 두 항목 중 하나라도 있으면 `reports__v2` 도구 이름도 `mcp__reports__`로 시작하기 때문에 서브에이전트는 모든 `reports__v2` 도구도 잃게 됩니다. `reports` 서버의 도구만 제외하려면 대신 `mcp__reports__run_query`처럼 하나씩 나열하세요.

#### 생성할 수 있는 서브에이전트 제한

에이전트가 `claude --agent`로 메인 스레드로 실행되면 Agent 도구를 사용하여 서브에이전트를 생성할 수 있습니다. 생성할 수 있는 서브에이전트 유형을 제한하려면 `tools` 필드에 `Agent(agent_type)` 구문을 사용하세요.

> [!NOTE]
>
> 버전 2.1.63에서 Task 도구의 이름이 Agent로 변경되었습니다. 설정과 에이전트 정의의 기존 `Task(...)` 참조는 별칭으로 계속 작동합니다.

```yaml theme={null}
---
name: coordinator
description: Coordinates work across specialized agents
tools: Agent(worker, researcher), Read, Bash
---
```

이는 허용 목록이므로 `worker`와 `researcher` 서브에이전트만 생성할 수 있습니다. 에이전트가 다른 유형을 생성하려고 하면 요청이 실패하며, 에이전트는 프롬프트에서 허용된 유형만 보게 됩니다. 다른 모든 에이전트를 허용하면서 특정 에이전트만 차단하려면 대신 [`permissions.deny`](#disable-specific-subagents)를 사용하세요.

제한 없이 모든 서브에이전트 생성을 허용하려면 괄호 없이 `Agent`를 사용하세요.

```yaml theme={null}
tools: Agent, Read, Bash
```

`tools` 목록에서 `Agent`를 완전히 생략하면 에이전트는 Agent 도구로 어떤 서브에이전트도 생성할 수 없습니다.

`Agent(agent_type)` 허용 목록 구문은 `claude --agent`로 메인 스레드로 실행되는 에이전트에만 적용됩니다. 서브에이전트 정의에서 `tools`에 `Agent`를 나열하면 [깊이 제한](#let-subagents-spawn-their-own-subagents)이 허용하는 한 해당 서브에이전트가 자체 서브에이전트를 생성할 수 있지만, 괄호 안의 유형 목록은 무시됩니다.

#### 서브에이전트로 MCP 서버 범위 지정

`mcpServers` 필드를 사용하면 메인 대화에서 사용할 수 없는 [MCP](https://code.claude.com/docs/ko/mcp.md) 서버에 서브에이전트가 접근하도록 할 수 있습니다. 여기서 정의한 인라인 서버는 [에이전트 파일 폴더에 대한 신뢰 규칙](#inline-server-trust)에 따라 서브에이전트가 시작될 때 연결되고 완료될 때 연결이 해제됩니다. 문자열 참조는 부모 세션의 연결을 공유합니다.

> [!NOTE]
>
> `mcpServers` 필드는 에이전트 파일이 실행될 수 있는 두 가지 컨텍스트 모두에 적용됩니다.
>
> * Agent 도구나 @-멘션을 통해 생성되는 서브에이전트로서
> * [`--agent`](#invoke-subagents-explicitly) 또는 `agent` 설정으로 실행되는 메인 세션으로서
>
> 에이전트가 메인 세션인 경우, 인라인 서버 정의는 동일한 [에이전트 파일 폴더에 대한 신뢰 규칙](#inline-server-trust)에 따라 [`.mcp.json`](https://code.claude.com/docs/ko/mcp) 및 설정 파일의 서버와 함께 시작 시 연결됩니다. `/mcp`에서 이전에 사용한 원격(HTTP 또는 SSE) 서버는 대신 [`cached` 상태](https://code.claude.com/docs/ko/mcp#managing-your-servers)로 표시될 수 있으며, Claude Code는 Claude가 해당 서버의 도구 중 하나를 처음 호출할 때 연결합니다.

목록의 각 항목은 인라인 서버 정의이거나 세션에 이미 구성된 MCP 서버를 참조하는 문자열입니다.

```yaml theme={null}
---
name: browser-tester
description: Tests features in a real browser using Playwright
mcpServers:
  # Inline definition: scoped to this subagent only
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  # Reference by name: reuses an already-configured server
  - github
---

Use the Playwright tools to navigate, screenshot, and interact with pages.
```

인라인 정의는 서버 이름을 키로 하는 `.mcp.json` 서버 항목과 동일한 스키마를 사용하며, `stdio`, `http`, `sse`, `ws` 유형을 지원합니다.

MCP 서버를 메인 대화에서 완전히 배제하고 해당 도구 설명이 그곳의 컨텍스트를 소비하지 않도록 하려면 `.mcp.json`이 아니라 여기에서 인라인으로 정의하세요. 서브에이전트는 도구를 받지만 부모 대화는 받지 않습니다.

메인 세션에 적용되는 MCP 제한은 서브에이전트 frontmatter에 선언된 서버에도 적용됩니다.

* [`--strict-mcp-config`](https://code.claude.com/docs/ko/cli-reference) 및 [`--bare`](https://code.claude.com/docs/ko/cli-reference)
* [엔터프라이즈 관리형 MCP 구성](https://code.claude.com/docs/ko/managed-mcp.md)
* [`allowedMcpServers` 및 `deniedMcpServers` 정책](https://code.claude.com/docs/ko/managed-mcp#policy-based-control-with-allowlists-and-denylists)

이 중 하나가 서버를 차단하면 Claude Code는 해당 서버를 건너뛰고 차단된 서버를 명시한 경고를 표시합니다.

관리형 설정 제한은 정의 방식과 관계없이 모든 서브에이전트에 적용됩니다. `--strict-mcp-config`는 `--agents` 또는 SDK `agents` 옵션을 통해 인라인으로 전달한 서버는 명시적인 호출자 입력이므로 필터링하지 않습니다.

#### 인라인 MCP 서버에 필요한 신뢰

Claude Code는 프로젝트의 `.claude/agents/` 디렉터리 또는 `--add-dir` 디렉터리의 `.claude/agents/`에 있는 에이전트 파일의 [인라인 MCP 서버](#scope-mcp-servers-to-a-subagent)를 [에이전트 파일이 있는 폴더를 신뢰](https://code.claude.com/docs/ko/permissions.md#what-runs-before-you-trust-a-folder)한 후에만 로드합니다. v2.1.238 이전에는 Claude Code가 신뢰를 확인하지 않고 이러한 서버를 로드했습니다.

* **인정되지 않는 신뢰**: 부모 폴더의 신뢰, 그리고 `-p` 또는 SDK 세션이 [설정 파일의 훅](https://code.claude.com/docs/ko/permissions.md#what-runs-before-you-trust-a-folder)에 대해 받는 자동 신뢰
* **신뢰하기 전까지**: Claude Code는 해당 에이전트 파일의 모든 인라인 서버를 건너뛰고, `~/.claude.json`에 대한 정확한 `projects["<path>"].hasTrustDialogAccepted` 키를 디버그 로그에 기록합니다
* **`--add-dir` 디렉터리**: 신뢰된 워크스페이스의 저장소 외부에 있는 디렉터리는 해당 `.claude/agents/` 파일이 워크스페이스의 신뢰를 상속하지 않으므로 자체 신뢰 항목이 필요합니다

Claude Code는 다음 두 종류의 서버를 에이전트 파일이 있는 폴더에 대한 신뢰를 확인하지 않고 로드합니다.

* 이미 구성한 서버를 참조하는 이름
* `~/.claude/agents/`의 에이전트 파일, `--agents` 또는 SDK `agents` 옵션으로 전달한 에이전트 파일, 또는 관리형 설정이 제공하는 에이전트 파일에 있는 인라인 서버

#### 권한 모드

`permissionMode`를 설정하여 서브에이전트가 실행될 권한 모드를 선택합니다. 모드의 구성 값을 사용하므로 Manual 모드는 `default`입니다. 설정하지 않으면 서브에이전트는 메인 대화의 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)를 상속합니다.

사용자가 설정한 값을 Claude Code가 사용할지 여부는 메인 대화의 권한 모드에 따라 결정됩니다.

* 메인 대화가 `bypassPermissions`, `acceptEdits` 또는 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)인 경우, 서브에이전트는 동일한 모드로 실행되며 Claude Code는 사용자가 설정한 `permissionMode`를 무시합니다. 자동 모드에서는 분류기가 메인 대화의 차단 및 허용 규칙으로 서브에이전트의 도구 호출을 평가합니다. 서브에이전트가 완료되면 [자동 모드가 서브에이전트를 처리하는 방식](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에 설명된 대로 분류기는 보고서가 전달되기 전에 서브에이전트의 작업과 최종 보고서도 검토합니다.
* 메인 대화가 `plan` 모드인 경우, 서브에이전트가 [에이전트 팀 규칙](https://code.claude.com/docs/ko/agent-teams.md#have-teammates-plan-before-implementing)에 따라 [에이전트 팀 팀원](#subagent-names)으로 실행되지 않는 한, 사용자가 설정한 `permissionMode`와 관계없이 서브에이전트는 플랜 모드를 유지합니다. `dontAsk`를 설정하면 서브에이전트는 사용자에게 확인도 요청하지 않으며, 플랜 모드에서 승인을 요청하게 될 작업은 대신 거부됩니다.
* 메인 대화가 `default` 또는 `dontAsk` 모드인 경우, 서브에이전트는 사용자가 설정한 권한 모드로 실행됩니다. 다만 다음 경우에는 대신 메인 대화의 권한 모드를 유지합니다.
  * 사용자가 `bypassPermissions`를 설정한 경우. `bypassPermissions` 예외는 Claude Code v2.1.267 이상이 필요합니다.
  * 사용자가 `auto`를 설정했지만, 설정 파일이 [`disableAutoMode`](https://code.claude.com/docs/ko/settings-reference#disableautomode)를 설정했거나 서브에이전트의 모델이 자동 모드를 지원하지 않는 경우처럼 서브에이전트가 [자동 모드를 사용할 수 없는](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) 경우.

`permissionMode`는 다음 값과 `default`의 별칭인 `manual`을 허용합니다.

| 모드 | 동작 |
| :- | :- |
| `default` | Manual 모드: 권한을 요청합니다 |
| `acceptEdits` | 작업 디렉터리 또는 `additionalDirectories`의 경로에 대한 파일 편집과 일반적인 파일 시스템 명령을 자동으로 수락합니다 |
| `auto` | [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode): 백그라운드 분류기가 명령과 보호된 디렉터리 쓰기를 검토합니다 |
| `dontAsk` | 확인을 요청하게 될 호출을 자동으로 거부합니다. 단, 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)가 [그러한 호출 중 일부](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)를 여전히 승인할 수 있습니다. 명시적으로 허용된 도구는 계속 작동합니다. `AskUserQuestion`, [`requiresUserInteraction`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)으로 표시된 MCP 도구, [네트워크 경로에서의 읽기](https://code.claude.com/docs/ko/permissions.md#network-paths), 그리고 해당 설정이 Claude Code에 도달하는 세션에서 [조직이 `ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구는 허용했더라도 거부됩니다 |
| `bypassPermissions` | [권한 프롬프트를 건너뜁니다](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode). 서브에이전트는 메인 대화가 이 모드일 때만 이 모드로 실행됩니다 |
| `plan` | 플랜 모드(읽기 전용 탐색) |

#### 서브에이전트에 스킬 미리 로드

`skills` 필드를 사용하여 시작 시 서브에이전트의 컨텍스트에 스킬 내용을 주입합니다. 이렇게 하면 서브에이전트가 실행 중에 스킬을 찾아 로드할 필요 없이 도메인 지식을 얻을 수 있습니다.

```yaml theme={null}
---
name: api-developer
description: Implement API endpoints following team conventions
skills:
  - api-conventions
  - error-handling-patterns
---

Implement API endpoints. Follow the conventions and patterns from the preloaded skills.
```

나열된 각 스킬의 전체 내용은 목록에서 처음 32개의 고유한 이름까지 시작 시 서브에이전트의 컨텍스트에 주입됩니다. 이 필드는 서브에이전트가 접근할 수 있는 스킬이 아니라 미리 로드되는 스킬을 제어합니다. 이 필드가 없어도 서브에이전트는 실행 중에 Skill 도구를 통해 프로젝트, 사용자, 플러그인 스킬을 찾아 호출할 수 있습니다. 서브에이전트가 스킬을 아예 호출하지 못하게 하려면 [`tools`](#available-tools) 목록에서 `Skill`을 생략하거나 `disallowedTools`에 추가하세요.

미리 로드는 Claude가 호출할 수 있는 것과 동일한 스킬 집합에서 가져오므로 [`disable-model-invocation: true`](https://code.claude.com/docs/ko/skills#control-who-invokes-a-skill)를 설정한 스킬은 미리 로드할 수 없습니다. 여기에는 Claude가 스스로 실행할 수 없는 번들 `/verify` 스킬도 포함됩니다.

나열된 스킬이 누락되었거나 조직의 정책 등으로 비활성화된 경우, Claude Code는 해당 스킬을 건너뛰고 디버그 로그에 경고를 기록합니다.

> [!NOTE]
>
> 이는 [서브에이전트에서 스킬 실행](https://code.claude.com/docs/ko/skills.md#run-skills-in-a-subagent)의 반대입니다. 서브에이전트에서 `skills`를 사용하면 서브에이전트가 시스템 프롬프트를 제어하고 스킬 내용을 로드합니다. 스킬에서 `context: fork`를 사용하면 스킬 내용이 지정한 에이전트에 주입됩니다. 두 경우 모두 서브에이전트는 대화 기록 없이 시작합니다.

#### 영구 메모리 활성화

`memory` 필드는 서브에이전트에 대화가 끝나도 유지되는 영구 디렉터리를 제공합니다. 서브에이전트는 이 디렉터리를 사용하여 코드베이스 패턴, 디버깅 인사이트, 아키텍처 결정과 같은 지식을 시간이 지나면서 축적합니다.

```yaml theme={null}
---
name: code-reviewer
description: Reviews code for quality and best practices
memory: user
---

You are a code reviewer. As you review code, update your agent memory with
patterns, conventions, and recurring issues you discover.
```

메모리를 얼마나 넓게 적용할지에 따라 범위를 선택하세요.

| 범위 | 위치 | 사용 시점 |
| :- | :- | :- |
| `user` | `~/.claude/agent-memory/<name-of-agent>/` | 서브에이전트가 모든 프로젝트에 걸쳐 학습 내용을 기억해야 하는 경우 |
| `project` | `.claude/agent-memory/<name-of-agent>/` | 서브에이전트의 지식이 프로젝트에 특화되어 있고 버전 관리를 통해 공유할 수 있는 경우 |
| `local` | `.claude/agent-memory-local/<name-of-agent>/` | 서브에이전트의 지식이 프로젝트에 특화되어 있지만 버전 관리에 체크인하면 안 되는 경우 |

서브에이전트 메모리는 [자동 메모리](https://code.claude.com/docs/ko/memory.md#auto-memory)의 일부입니다. `autoMemoryEnabled` 설정이나 `CLAUDE_CODE_DISABLE_AUTO_MEMORY`로 자동 메모리를 끄면 `memory` 필드는 효과가 없으며, 서브에이전트는 아래에 설명된 메모리 지침이나 메모리 도구 접근 없이 실행됩니다.

메모리가 활성화되면:

* 서브에이전트의 시스템 프롬프트에 메모리 디렉터리를 읽고 쓰는 방법에 대한 지침이 포함됩니다.
* 서브에이전트의 시스템 프롬프트에는 메모리 디렉터리에 있는 `MEMORY.md`의 처음 200줄 또는 25KB 중 먼저 도달하는 분량도 포함되며, 이 한도를 초과하면 `MEMORY.md`를 정리하라는 지침이 함께 포함됩니다.
* 서브에이전트가 메모리 파일을 관리할 수 있도록 Read, Write, Edit 도구가 자동으로 활성화됩니다.

##### 영구 메모리 팁

* `project`가 권장되는 기본 범위입니다. 서브에이전트의 지식을 버전 관리를 통해 공유할 수 있게 합니다.
* 작업을 시작하기 전에 메모리를 참조하도록 서브에이전트에게 요청하세요: "이 PR을 검토하고, 이전에 본 패턴이 있는지 메모리를 확인해 줘."
* 작업을 완료한 후 메모리를 업데이트하도록 서브에이전트에게 요청하세요: "이제 끝났으니 배운 내용을 메모리에 저장해 줘." 시간이 지나면 서브에이전트를 더 효과적으로 만드는 지식 베이스가 구축됩니다.
* 서브에이전트가 자체 지식 베이스를 능동적으로 유지하도록 서브에이전트의 markdown 파일에 메모리 지침을 직접 포함하세요.

  ```markdown theme={null}
  Update your agent memory as you discover codepaths, patterns, library
  locations, and key architectural decisions. This builds up institutional
  knowledge across conversations. Write concise notes about what you found
  and where.
  ```

#### 훅을 사용한 조건부 규칙

도구 사용을 보다 동적으로 제어하려면 `PreToolUse` 훅을 사용하여 작업이 실행되기 전에 검증하세요. 이는 도구의 일부 작업은 허용하면서 다른 작업은 차단해야 할 때 유용합니다.

이 예시는 읽기 전용 데이터베이스 쿼리만 허용하는 서브에이전트를 만듭니다. `PreToolUse` 훅은 각 Bash 명령이 실행되기 전에 `command`에 지정된 스크립트를 실행합니다.

```yaml theme={null}
---
name: db-reader
description: Execute read-only database queries
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---
```

Claude Code는 stdin을 통해 훅 명령에 [훅 입력을 JSON으로 전달](https://code.claude.com/docs/ko/hooks.md#pretooluse-input)합니다. 검증 스크립트는 이 JSON을 읽고 Bash 명령을 추출한 다음, 쓰기 작업을 차단하기 위해 [종료 코드 2로 종료](https://code.claude.com/docs/ko/hooks.md#exit-code-2-behavior-per-event)합니다.

```bash theme={null}
#!/bin/bash
# ./scripts/validate-readonly-query.sh

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Block SQL write operations (case-insensitive)
if echo "$COMMAND" | grep -iE '\b(INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|TRUNCATE)\b' > /dev/null; then
  echo "Blocked: Only SELECT queries are allowed" >&2
  exit 2
fi

exit 0
```

macOS와 Linux에서는 스크립트를 실행 가능하게 만드세요. 그렇지 않으면 훅이 아무것도 차단하지 못하고 실패합니다.

```bash theme={null}
chmod +x ./scripts/validate-readonly-query.sh
```

규칙을 테스트하려면 서브에이전트에게 `UPDATE` 문을 실행하도록 요청하세요. 스크립트가 종료 코드 2로 종료되고, Claude Code가 명령을 차단하며, 서브에이전트에게 `Blocked: Only SELECT queries are allowed` 메시지가 표시됩니다.

전체 입력 스키마는 [훅 입력](https://code.claude.com/docs/ko/hooks.md#pretooluse-input)을, 종료 코드가 동작에 미치는 영향은 [종료 코드](https://code.claude.com/docs/ko/hooks.md#exit-code-output)를 참조하세요. Windows에서는 [PowerShell에서 훅 실행](https://code.claude.com/docs/ko/hooks.md#windows-powershell-tool)에 나온 대로 훅 스크립트를 PowerShell로 작성하고 훅 항목에 `shell: powershell`을 추가하세요.

#### 특정 서브에이전트 비활성화

[설정](https://code.claude.com/docs/ko/settings-reference.md#permission-settings)의 `deny` 배열에 특정 서브에이전트를 추가하여 Claude가 해당 서브에이전트를 사용하지 못하게 할 수 있습니다. `Agent(subagent-name)` 형식을 사용하며, 여기서 `subagent-name`은 서브에이전트의 name 필드와 일치합니다.

```json theme={null}
{
  "permissions": {
    "deny": ["Agent(Explore)", "Agent(my-custom-agent)"]
  }
}
```

이는 기본 제공 서브에이전트와 사용자 정의 서브에이전트 모두에 작동합니다. `--disallowedTools` CLI 플래그를 사용할 수도 있습니다.

```bash theme={null}
claude --disallowedTools "Agent(Explore)"
```

권한 규칙에 대한 자세한 내용은 [권한 문서](https://code.claude.com/docs/ko/permissions.md#tool-specific-permission-rules)를 참조하세요.

### 서브에이전트용 훅 정의

서브에이전트는 서브에이전트의 라이프사이클 동안 실행되는 [훅](https://code.claude.com/docs/ko/hooks.md)을 정의할 수 있습니다. 훅을 구성하는 방법은 두 가지입니다.

* **서브에이전트의 frontmatter에서**: 해당 서브에이전트가 활성화되어 있는 동안에만 실행되는 훅을 정의합니다
* **`settings.json`에서**: 서브에이전트 내부에서도 실행되는 세션 전체 훅을 정의합니다. `PreToolUse` 및 `PostToolUse`와 같은 도구 이벤트는 메인 대화에서와 같은 방식으로 서브에이전트의 도구 호출에 대해 실행되며, `SubagentStart` 및 `SubagentStop`은 서브에이전트가 시작하거나 완료될 때 실행됩니다

[설정 파일, 관리형 정책 설정, 플러그인](https://code.claude.com/docs/ko/hooks.md#hook-locations)의 훅은 모두 서브에이전트 내부에 적용되므로, `settings.json`의 `PreToolUse` 훅은 서브에이전트가 사용하는 모든 도구 이전에도 실행됩니다.

#### 서브에이전트 frontmatter의 훅

서브에이전트의 markdown 파일에서 직접 훅을 정의합니다. 이러한 훅은 해당 서브에이전트가 활성화되어 있는 동안에만 실행되며 완료되면 정리됩니다.

> [!NOTE]
>
> frontmatter 훅은 에이전트가 Agent 도구나 @-멘션을 통해 서브에이전트로 생성될 때, 그리고 에이전트가 [`--agent`](#invoke-subagents-explicitly) 또는 `agent` 설정을 통해 메인 세션으로 실행될 때 실행됩니다. 메인 세션의 경우 [`settings.json`](https://code.claude.com/docs/ko/hooks)에 정의된 훅과 함께 실행됩니다.

프로젝트 수준 서브에이전트의 frontmatter 훅을 실행하려면 에이전트 파일이 있는 폴더에 대해 [워크스페이스 신뢰 대화 상자](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)를 수락하세요. `~/.claude/agents/`의 사용자 수준 서브에이전트와 `--agents`로 전달한 정의의 훅은 이 단계 없이 실행됩니다. 신뢰된 워크스페이스의 저장소 외부에서 `--add-dir`로 폴더를 추가한 경우 해당 폴더를 별도로 신뢰하세요. 해당 폴더의 `.claude/agents/` 훅은 워크스페이스의 승인을 상속하지 않습니다.

폴더를 신뢰하기 전까지 서브에이전트는 계속 실행되지만, Claude Code는 frontmatter 훅을 건너뛰고 폴더를 신뢰하는 방법을 설명하는 오류를 디버그 로그에 기록합니다. 이는 설정 파일의 훅에 대한 규칙보다 엄격한 규칙입니다. 부모 폴더를 신뢰하는 것만으로는 충분하지 않으며, `-p` 세션은 신뢰된 것으로 간주되지 않습니다. [폴더를 신뢰하기 전에 실행되는 항목](https://code.claude.com/docs/ko/permissions.md#what-runs-before-you-trust-a-folder)에서 두 규칙을 비교합니다.

모든 [훅 이벤트](https://code.claude.com/docs/ko/hooks.md#hook-events)가 지원됩니다. 서브에이전트에서 가장 일반적인 이벤트는 다음과 같습니다.

| 이벤트 | Matcher 입력 | 실행 시점 |
| :- | :- | :- |
| `PreToolUse` | 도구 이름 | 서브에이전트가 도구를 사용하기 전 |
| `PostToolUse` | 도구 이름 | 서브에이전트가 도구를 사용한 후 |
| `Stop` | (없음) | 서브에이전트가 완료될 때(런타임에 `SubagentStop`으로 변환됨) |

이 예시는 `PreToolUse` 훅으로 Bash 명령을 검증하고 `PostToolUse`로 파일 편집 후 린터를 실행합니다.

```yaml theme={null}
---
name: code-reviewer
description: Review code changes with automatic linting
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
---
```

에이전트가 서브에이전트로 호출되면 frontmatter의 `Stop` 훅은 자동으로 `SubagentStop` 이벤트로 변환됩니다.

#### 서브에이전트 이벤트에 대한 프로젝트 수준 훅

메인 세션에서 서브에이전트 라이프사이클 이벤트에 응답하는 훅을 `settings.json`에 구성합니다.

| 이벤트 | Matcher 입력 | 실행 시점 |
| :- | :- | :- |
| `SubagentStart` | 에이전트 유형 이름 | 서브에이전트가 실행을 시작할 때 |
| `SubagentStop` | 에이전트 유형 이름 | 서브에이전트가 완료될 때 |

두 이벤트 모두 이름으로 특정 에이전트 유형을 대상으로 하는 matcher를 지원합니다. matcher 값은 프로젝트 수준 및 사용자 수준 서브에이전트의 경우 에이전트의 frontmatter `name`이고, [플러그인 서브에이전트](https://code.claude.com/docs/ko/plugins/components.md#agents)의 경우 `my-plugin:db-agent`와 같은 플러그인 범위 식별자입니다. 범위 지정 이름에는 콜론이 포함되므로 [고정되지 않은 정규식](https://code.claude.com/docs/ko/hooks.md#matcher-patterns)으로 평가됩니다. 해당 에이전트만 일치시키려면 `^my-plugin:db-agent$`처럼 `^`와 `$`로 고정하세요.

이 예시는 `db-agent` 서브에이전트가 시작될 때만 설정 스크립트를 실행하고, 어떤 서브에이전트든 중지될 때 정리 스크립트를 실행합니다.

```json theme={null}
{
  "hooks": {
    "SubagentStart": [
      {
        "matcher": "db-agent",
        "hooks": [
          { "type": "command", "command": "./scripts/setup-db-connection.sh" }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          { "type": "command", "command": "./scripts/cleanup-db-connection.sh" }
        ]
      }
    ]
  }
}
```

전체 훅 구성 형식은 [훅](https://code.claude.com/docs/ko/hooks.md)을 참조하세요.

## 서브에이전트 사용하기

### 자동 위임 이해하기

Claude는 요청의 작업 설명, 서브에이전트 구성의 `description` 필드, 현재 컨텍스트를 바탕으로 작업을 자동으로 위임합니다. 능동적인 위임을 유도하려면 서브에이전트의 description 필드에 "use proactively"와 같은 문구를 포함합니다.

설명은 간결하게 유지해야 합니다. 서브에이전트 설명의 합계가 [15,000 토큰 한도](https://code.claude.com/docs/ko/errors.md#agent-descriptions-are-over-the-15000-token-limit)를 넘으면 Claude Code는 시작 시 경고를 표시하지만, 모든 서브에이전트를 여전히 로드합니다.

서브에이전트가 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)에 포함되어 제공되는 경우, 하나씩 확인하는 대신 현실적인 프롬프트 전반에서 Claude가 얼마나 안정적으로 해당 서브에이전트에 위임하는지 측정할 수 있습니다. [`claude plugin eval`](https://code.claude.com/docs/ko/plugin-evals)은 각 프롬프트를 플러그인이 있을 때와 없을 때 실행하고 결과에 점수를 매깁니다.

### 서브에이전트 명시적으로 호출하기

자동 위임만으로 충분하지 않을 때는 서브에이전트를 직접 요청할 수 있습니다. 일회성 제안부터 세션 전체 기본값까지 단계적으로 강해지는 세 가지 패턴이 있습니다.

* **자연어**: 프롬프트에서 서브에이전트 이름을 언급하면 Claude가 위임 여부를 결정합니다
* **@-멘션**: 하나의 작업에 대해 해당 서브에이전트가 실행되도록 보장합니다
* **세션 전체**: `--agent` 플래그 또는 `agent` 설정을 통해 세션 전체가 해당 서브에이전트로 실행됩니다

자연어의 경우 특별한 구문이 없습니다. 서브에이전트 이름을 언급하면 Claude가 일반적으로 위임합니다.

```text wrap theme={null}
Use the test-runner subagent to fix failing tests
Have the code-reviewer subagent look at my recent changes
```

**서브에이전트를 @-멘션하기.** 파일을 @-멘션하는 것과 같은 방식으로 `@`를 입력하고 자동 완성 목록에서 서브에이전트를 선택합니다. 이렇게 하면 선택을 Claude에게 맡기지 않고 특정 서브에이전트가 실행되도록 보장할 수 있습니다.

```text wrap theme={null}
@"code-reviewer (agent)" look at the auth changes
```

전체 메시지는 여전히 Claude에게 전달되며, Claude는 요청한 내용을 바탕으로 서브에이전트의 작업 프롬프트를 작성합니다. @-멘션은 Claude가 어떤 서브에이전트를 호출할지를 제어할 뿐, 서브에이전트가 어떤 프롬프트를 받을지를 제어하지는 않습니다.

활성화된 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)이 제공하는 서브에이전트는 `my-plugin:code-reviewer`와 같은 범위가 지정된 이름으로 자동 완성 목록에 표시되며, 플러그인이 [에이전트를 하위 폴더로 구성](#choose-the-subagent-scope)한 경우에는 `my-plugin:review:security`와 같이 표시됩니다. 세션에서 현재 실행 중인 이름이 지정된 백그라운드 서브에이전트도 이름 옆에 상태와 함께 자동 완성 목록에 표시됩니다.

선택기를 사용하지 않고 멘션을 직접 입력할 수도 있습니다. 로컬 서브에이전트는 `@agent-<name>`, 플러그인 서브에이전트는 `@agent-` 뒤에 범위가 지정된 이름을 붙입니다(예: `@agent-my-plugin:code-reviewer`). 이 형식을 입력하는 동안 자동 완성 목록에는 에이전트가 아닌 파일 일치 항목이 표시됩니다. 그래도 제출하면 에이전트 멘션은 정상적으로 처리됩니다.

**세션 전체를 서브에이전트로 실행하기.** [`--agent <name>`](https://code.claude.com/docs/ko/cli-reference)을 전달하면 메인 스레드 자체가 해당 서브에이전트의 도구 제한과 모델을 사용하는 세션을 시작합니다.

```bash theme={null}
claude --agent code-reviewer
```

에이전트의 [프롬프트가 비어 있지](#choose-the-subagent-scope) 않는 한, 사용자 지정 서브에이전트의 시스템 프롬프트는 [`--system-prompt`](https://code.claude.com/docs/ko/cli-reference)와 같은 방식으로 기본 Claude Code 시스템 프롬프트를 완전히 대체합니다. 에이전트 정의에서 [`omitClaudeMd`](#supported-frontmatter-fields)를 설정한 경우에도 `CLAUDE.md` 파일과 프로젝트 메모리는 일반 메시지 흐름을 통해 여전히 로드됩니다. 자체 프롬프트가 있는 사용자 지정 에이전트로 `-p`를 사용해 세션을 실행하면 [git 상태 스냅샷](https://code.claude.com/docs/ko/settings-reference.md#includegitinstructions) 없이 시작됩니다.

에이전트 이름은 시작 헤더에 `@<name>`으로 표시되므로 활성화 여부를 확인할 수 있습니다.

이 기능은 기본 제공 서브에이전트와 사용자 지정 서브에이전트 모두에서 작동하며, 세션을 재개할 때도 선택이 유지됩니다. Claude Code는 대화와 함께 에이전트의 도구 제한과 모델을 복원합니다. 재개할 때 에이전트가 더 이상 존재하지 않으면 세션은 기본 도구로 계속되며 [해당 에이전트 이름을 명시한 경고](https://code.claude.com/docs/ko/errors.md#session-agent-no-longer-available)가 표시됩니다. 두 경우의 시스템 프롬프트에 대해서는 [재개된 대화의 시스템 프롬프트 플래그](https://code.claude.com/docs/ko/cli-reference.md#system-prompt-flags-in-resumed-conversations)를 참조하세요.

플러그인이 제공하는 서브에이전트의 경우 에이전트 이름만 전달해도 Claude Code가 찾아냅니다.

```bash theme={null}
claude --agent security-reviewer
```

여러 플러그인이 같은 이름의 에이전트를 제공하는 경우 범위가 지정된 이름을 전달해 구분합니다.

```bash theme={null}
claude --agent my-plugin:security-reviewer
```

플러그인이 에이전트를 `agents/` 디렉터리의 하위 폴더에 두는 경우 범위가 지정된 이름에 하위 폴더를 포함합니다(예: `claude --agent my-plugin:review:security`).

프로젝트의 모든 세션에서 기본값으로 사용하려면 `.claude/settings.json`에서 `agent`를 설정합니다.

```json theme={null}
{
  "agent": "code-reviewer"
}
```

둘 다 있는 경우 CLI 플래그가 설정을 재정의합니다.

### 서브에이전트를 포그라운드 또는 백그라운드에서 실행하기

서브에이전트는 포그라운드 또는 백그라운드에서 실행할 수 있습니다.

* **포그라운드 서브에이전트**는 완료될 때까지 메인 대화를 차단합니다. 권한 프롬프트는 발생하는 즉시 사용자에게 전달됩니다.
* **백그라운드 서브에이전트**는 사용자가 작업을 계속하는 동안 동시에 실행됩니다. 백그라운드 서브에이전트가 권한이 필요한 도구 호출에 도달하면 Claude Code는 메인 세션에 프롬프트를 표시하고 요청하는 서브에이전트의 이름을 알려 줍니다. 승인하면 서브에이전트가 계속 진행하고, Esc를 누르면 서브에이전트를 중지하지 않고 해당 도구 호출 하나만 거부합니다.

#### 백그라운드에서 실행되는 서브에이전트

아무것도 구성하지 않은 경우, Claude가 메인 대화에서 생성하는 서브에이전트는 백그라운드에서 시작됩니다.

* **`claude -p` 및 Agent SDK**: Claude는 자체 판단에 따라 또는 사용자가 요청할 때 대기할 수 있습니다.
* **로컬 머신의 대화형 터미널 세션, VS Code 및 데스크톱 앱 세션**: Claude가 서브에이전트를 기다리도록 하려면 [기본적으로 켜져 있는](#turn-fork-mode-on-or-off) [포크 모드를 끕니다](#let-claude-wait-for-a-subagent).

`context: fork`가 있는 스킬의 경우, Claude Code는 포크 모드 여부와 관계없이 [서브에이전트에서 스킬 실행하기](https://code.claude.com/docs/ko/skills.md#run-skills-in-a-subagent)의 규칙을 따릅니다.

#### Claude가 서브에이전트를 기다리게 하기

1. `CLAUDE_CODE_FORK_SUBAGENT`를 `0`으로 설정해 [포크 모드](#turn-fork-mode-on-or-off)를 끕니다. 예를 들어 [`settings.json`](https://code.claude.com/docs/ko/settings)에서 다음과 같이 설정합니다.

   ```json theme={null}
   {
     "env": {
       "CLAUDE_CODE_FORK_SUBAGENT": "0"
     }
   }
   ```

2. 셸에서 `claude`를 다시 실행하거나 새 VS Code 대화를 엽니다.

3. 결과가 먼저 필요할 때 Claude에게 기다리라고 요청합니다. 예: "run the reviewer subagent and wait for its report".

Claude가 기다리는 동안 작업을 계속하려면 터미널에서 **Ctrl+B**를 누르거나 VS Code에서 [**Run in background**](https://code.claude.com/docs/ko/vs-code.md#move-a-running-command-or-subagent-to-the-background)를 클릭합니다.

포크 모드를 끄는 대신 [`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`](https://code.claude.com/docs/ko/env-vars) 환경 변수를 `1`로 설정하면, Claude는 계속 진행하기 전에 서브에이전트가 완료될 때까지 기다립니다. 백그라운드 명령도 꺼지며, **Ctrl+B**를 눌러도 아무것도 백그라운드로 이동하지 않습니다.

#### 백그라운드 서브에이전트의 도구, 권한 및 결과

백그라운드 서브에이전트는 대화 포크와 [재개된](#resume-subagents) 포그라운드 서브에이전트를 제외하고, 포그라운드 서브에이전트보다 [더 작은 기본 제공 도구 세트](#available-tools)로 실행됩니다.

백그라운드 서브에이전트는 모든 권한 프롬프트를 메인 세션에 표시합니다. 세션의 나머지 기간 동안 유지되는 허용처럼 해당 도구 호출 하나를 넘어 지속되는 선택으로 이러한 프롬프트에 응답하면, Claude Code는 메인 대화를 포함한 세션 전체에 그 응답을 적용합니다.

백그라운드 서브에이전트는 백그라운드 [Bash 또는 PowerShell 명령](https://code.claude.com/docs/ko/tools-reference.md#background-commands)을 [자신의 턴이 끝난 뒤에도 실행 중인 상태로](https://code.claude.com/docs/ko/interactive-mode.md#how-backgrounding-works) 남겨 둘 수 있습니다. 해당 명령이 끝나면 Claude Code가 서브에이전트에게 알림을 보냅니다.

백그라운드 서브에이전트의 결과는 이후 턴에서 완료 알림으로 Claude에게 전달됩니다. Claude는 서브에이전트의 결과를 보고하기 전에 해당 알림을 기다리며, 그 전에 진행 상황을 물으면 서브에이전트가 아직 실행 중이라고 보고합니다.

#### 패널과 작업 목록의 완료된 서브에이전트

Claude Code는 서브에이전트가 종료된 방식에 따라 두 가지 방법 중 하나로 프롬프트 입력 아래 서브에이전트 패널에서 백그라운드 서브에이전트의 행을 지웁니다.

* 서브에이전트가 성공적으로 완료되면 Claude Code는 해당 행을 즉시 제거하고, [스크린 리더 모드](https://code.claude.com/docs/ko/accessibility.md)를 제외하면 푸터에 30초 동안 `/tasks to see subagents`를 표시합니다. 이 30초 동안 [`/tasks`](https://code.claude.com/docs/ko/commands)를 실행하고 서브에이전트에서 `Enter`를 누르면 트랜스크립트를 열 수 있습니다. v2.1.232 이전에는 Claude Code가 실패한 서브에이전트와 마찬가지로 완료 후 30초 동안 행을 유지했으며 푸터 힌트를 표시하지 않았습니다.
* 서브에이전트가 실패하거나 사용자가 중지하면 Claude Code는 해당 행을 30초 동안 유지합니다. 행을 더 빨리 지우려면 행을 선택하고 `x`를 누릅니다.

완료된 백그라운드 서브에이전트는 푸터 힌트와 같은 30초 동안 [`/tasks`](https://code.claude.com/docs/ko/commands)에 완료로 표시된 채 실행 중인 작업 아래에 정렬되어 남아 있습니다. 서브에이전트가 완료되어도 상세 보기는 열린 상태로 유지됩니다. 실패하거나 사용자가 중지한 서브에이전트는 목록에서 사라집니다. v2.1.208 이전에는 완료된 서브에이전트가 완료되는 즉시 목록에서 사라지고 상세 보기도 닫혔습니다.

### 서브에이전트 이름

[에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md#enable-agent-teams)을 활성화한 상태로 세션을 시작하면, Claude는 Agent 도구 호출에 `name` 매개변수를 전달해 서브에이전트에 이름을 지정할 수 있습니다. 사용자에게 먼저 묻지 않고 스스로 그렇게 할 수도 있습니다. 이름을 지정하면 서브에이전트를 지칭할 수 있게 되어, 서브에이전트가 완료된 후 Claude가 [이름으로 메시지를 보내거나 재개](#resume-subagents)할 수 있습니다.

[에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md)이 활성화된 대화형 세션에서 Claude가 메인 대화에서 `name`과 함께 생성하는 서브에이전트는 팀원으로 시작됩니다. 단, 해당 호출이 [포크](#fork-the-current-conversation)인 경우나 호출 자체에 `isolation`을 전달하는 경우는 예외이며, 이 두 경우에는 팀원으로 시작되지 않습니다. 서브에이전트의 frontmatter에 있는 `isolation` 값으로는 팀원으로 시작되는 것을 막을 수 없으며, 이때 팀원은 메인 세션의 작업 디렉터리에서 실행됩니다. [Claude가 에이전트 팀을 시작하는 방법](https://code.claude.com/docs/ko/agent-teams.md#how-claude-starts-agent-teams)을 참조하세요.

### 서브에이전트의 API 오류

[서브에이전트의 응답이 스트리밍 도중 중단되고](https://code.claude.com/docs/ko/errors.md#the-response-above-may-be-incomplete) 부분 응답에 텍스트는 있지만 도구 호출이 없는 경우, Claude Code는 실행을 종료하는 대신 서브에이전트에게 계속하도록 요청합니다. 이는 대화형 세션에서도 마찬가지입니다. 이러한 계속 요청을 모두 소진한 경우에만 실행이 오류로 종료됩니다.

사용 한도나 반복되는 서버 오류와 같은 API 오류로 실행이 종료된 서브에이전트는 그 실패를 Claude에게 보고합니다. Claude가 받는 내용은 서브에이전트가 실행된 위치에 따라 다릅니다.

* **포그라운드**: 속도 제한, 과부하 또는 서버 오류로 이미 텍스트 출력을 생성한 서브에이전트가 중단되면, Agent 도구는 서브에이전트가 중단되어 작업을 완료하지 못했다는 메모와 함께 해당 부분 출력을 반환합니다. 아무것도 생성하지 않았거나 출력이 도구 호출뿐인 서브에이전트는 [`Agent terminated early due to an API error`](https://code.claude.com/docs/ko/errors#agent-terminated-early-due-to-an-api-error)와 그 뒤의 오류 세부 정보와 함께 실패합니다.
* **백그라운드**: 서브에이전트는 실패로 표시되며, 종료 시 Claude가 받는 메시지에는 API 오류 이름과 서브에이전트의 마지막 출력이 포함되므로 부분 작업이 손실되지 않습니다.

서브에이전트의 보고서가 다음 줄로 시작하면, 해당 서브에이전트는 폴백 모델로 작업을 마친 것입니다.

```text theme={null}
⚠ This agent switched to <model> because its earlier model could not be used.
```

[폴백 모델 체인](https://code.claude.com/docs/ko/model-config.md#fallback-model-chains)을 구성했고 서브에이전트가 모델을 사용할 수 없는 경우와 같이 체인이 처리하는 실패를 만나면, Claude Code는 서브에이전트를 체인에서 요청을 수락하는 첫 번째 모델로 전환합니다. 서브에이전트는 오류로 종료되지 않고 작업을 계속합니다.

근본적인 API 오류가 해소되면 Claude에게 작업을 재시도하거나 [서브에이전트를 재개](#resume-subagents)하도록 요청합니다.

### 서브에이전트 출력 검사

Claude Code는 Claude가 읽기 전에 각 서브에이전트의 최종 보고서를 검사합니다. 서브에이전트는 사용자가 검토한 적 없는 파일, 웹 페이지 또는 명령 출력을 읽었을 수 있으며, 이러한 출처의 텍스트에는 메인 대화를 겨냥한 지시가 포함되어 있을 수 있습니다. 검사는 어떤 내용도 제거하거나 바꿔 쓰지 않으며, 보고서에서 확인할 수 있는 두 가지 종류의 변경만 수행합니다.

* **백슬래시 삽입**: `<system-reminder>` 태그나 `Human:` 또는 `Assistant:`로 시작하는 줄처럼 Claude Code 자체 출력을 모방하는 텍스트에 백슬래시를 삽입하여, 모방된 텍스트가 대화의 일부로 오인되지 않고 일반 텍스트로 읽히게 합니다.
* **마커 줄**: 보고서가 `<system-reminder>` 같은 태그를 모방하거나 `bypassPermissions` 또는 `--dangerously-skip-permissions`와 같은 권한 설정을 언급하면 `[harness: subagent output matched instruction-shaped pattern(s):`로 시작하는 줄을 앞에 추가합니다. 권한 설정 언급에는 마커 줄이 추가되지만 텍스트 자체는 작성된 그대로 유지됩니다.

검사는 콘텐츠가 악의적인지 판단하지 않으며, 보고서 속 지시가 할 수 있는 일을 바꾸지도 않습니다. 보고서로 인해 Claude가 수행하는 도구 호출은 여전히 세션의 [권한 검사](https://code.claude.com/docs/ko/permissions.md)와 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)을 거칩니다. 검사가 [서브에이전트가 접근할 수 있는 범위를 제한하는 것](#control-subagent-capabilities)을 대체하지는 않습니다.

서브에이전트의 결과로 Claude에게 반환되는 보고서에는 서브에이전트 출력임을 나타내는 헤더도 붙습니다. 이 헤더는 보고서 안의 지시나 승인 주장이 서브에이전트의 말이며 사용자로부터 받은 권한이 없음을 명시합니다.

[백그라운드 서브에이전트의 보고서](#run-subagents-in-foreground-or-background)는 완료 알림 안에 담겨 도착하며, 이 알림은 사용자의 메시지가 아닌 자동화된 이벤트로 표시됩니다.

### 일반적인 패턴

#### 대량 출력 작업 격리하기

서브에이전트의 가장 효과적인 용도 중 하나는 대량의 출력을 생성하는 작업을 격리하는 것입니다. 테스트 실행, 문서 가져오기, 로그 파일 처리는 상당한 컨텍스트를 소비할 수 있습니다. 이러한 작업을 서브에이전트에 위임하면 장황한 출력은 서브에이전트의 컨텍스트에 머물고 관련 요약만 메인 대화로 돌아옵니다.

```text wrap theme={null}
Use a subagent to run the test suite and report only the failing tests with their error messages
```

#### 병렬 조사 실행하기

독립적인 조사의 경우 여러 서브에이전트를 생성해 동시에 작업하도록 합니다.

```text wrap theme={null}
Research the authentication, database, and API modules in parallel using separate subagents
```

각 서브에이전트가 자기 영역을 독립적으로 탐색하면 Claude가 결과를 종합합니다. 이 방법은 조사 경로가 서로 의존하지 않을 때 가장 효과적입니다.

> [!WARNING]
>
> 서브에이전트가 완료되면 결과가 메인 대화로 돌아옵니다. 각각 상세한 결과를 반환하는 서브에이전트를 많이 실행하면 상당한 컨텍스트를 소비할 수 있으며, 각 서브에이전트는 실행되는 동안 자체적으로 토큰을 사용합니다.

계속 병렬로 실행되어야 하거나 하나의 컨텍스트 윈도우에 담기지 않는 작업은 [별도의 세션](https://code.claude.com/docs/ko/agents.md)에서 실행하고 Claude가 [세션 간에 결과를 전달](https://code.claude.com/docs/ko/cross-session-messaging.md)하도록 합니다.

#### 서브에이전트 연결하기

여러 단계로 이루어진 워크플로의 경우 Claude에게 서브에이전트를 순서대로 사용하도록 요청합니다. 각 서브에이전트는 작업을 완료하고 결과를 Claude에게 반환하며, Claude는 관련 컨텍스트를 다음 서브에이전트에 전달합니다.

```text wrap theme={null}
Use the code-reviewer subagent to find performance issues, then use the optimizer subagent to fix them
```

### 서브에이전트와 메인 대화 중 선택하기

다음과 같은 경우 **메인 대화**를 사용합니다.

* 작업에 잦은 주고받기나 반복적인 개선이 필요한 경우
* 계획, 구현, 테스트처럼 여러 단계가 상당한 컨텍스트를 공유하는 경우
* 빠르고 목표가 명확한 변경을 하는 경우
* 지연 시간이 중요한 경우. [포크](#fork-the-current-conversation)가 아닌 서브에이전트는 새로 시작하므로 컨텍스트를 수집하는 데 시간이 필요할 수 있습니다

다음과 같은 경우 **서브에이전트**를 사용합니다.

* 작업이 메인 컨텍스트에 필요하지 않은 장황한 출력을 생성하는 경우
* 특정 도구 제한이나 권한을 강제하려는 경우
* 작업이 독립적이며 요약을 반환할 수 있는 경우

격리된 서브에이전트 컨텍스트가 아닌 메인 대화 컨텍스트에서 실행되는 재사용 가능한 프롬프트나 워크플로가 필요하다면 대신 [스킬](https://code.claude.com/docs/ko/skills.md)을 고려하세요.

대화에 이미 있는 내용에 대한 질문이라면 서브에이전트 대신 [`/btw`](https://code.claude.com/docs/ko/interactive-mode#side-questions-with-%2Fbtw)를 사용합니다. 전체 컨텍스트를 볼 수 있지만 도구에는 접근할 수 없으며, 답변은 기록에 추가되지 않습니다.

### 서브에이전트가 자체 서브에이전트를 생성하게 하기

기본적으로 서브에이전트는 메인 대화 아래 세 계층까지 자체 서브에이전트를 생성할 수 있습니다. 깊이 한도에 도달하면 Claude Code는 [포크](#fork-the-current-conversation)를 제외한 모든 서브에이전트에서 `Agent` 도구를 제공하지 않으므로, 한도에 있는 서브에이전트는 위임받은 작업을 직접 수행하고 하나의 요약을 반환합니다. 한도에 있는 포크는 상속받은 도구 목록에 `Agent`를 유지하지만, 이 도구는 서브에이전트를 생성하는 대신 오류를 반환합니다.

중첩된 서브에이전트는 각 결과마다 검증자를 보내는 리뷰어 서브에이전트처럼, 위임받은 작업 자체가 병렬 하위 작업으로 나뉘는 경우에 적합합니다. 기본적으로 생성하는 서브에이전트는 각 중첩된 서브에이전트의 보고서를 기다립니다.

* **대화형 터미널 세션**: 백그라운드 서브에이전트를 시작한 서브에이전트는 완료되기 전에 그 결과를 기다리므로, 최상위 서브에이전트의 요약만 사용자에게 돌아옵니다.
* **`claude -p` 및 Agent SDK**: [포크 모드](#turn-fork-mode-on-or-off)가 켜져 있는 동안에는 생성하는 서브에이전트가 기다립니다. 포크 모드를 끄면 중첩된 서브에이전트는 대신 [백그라운드](#run-subagents-in-foreground-or-background)에서 시작됩니다. 생성하는 서브에이전트는 백그라운드 중첩 서브에이전트를 기다리지 않으며, 중첩 서브에이전트가 생성한 서브에이전트보다 오래 실행되면 메인 대화에 보고합니다.

한도를 변경하려면 [`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`](https://code.claude.com/docs/ko/env-vars)를 메인 대화 아래에 두려는 서브에이전트 계층 수로 설정합니다. 예를 들어 [`settings.json`](https://code.claude.com/docs/ko/settings)의 다음 항목은 중첩을 두 계층으로 제한합니다.

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH": "2"
  }
}
```

이 값을 사용하면 서브에이전트가 자체 두 번째 계층에 위임할 수 있으며, 두 번째 계층은 더 이상 위임할 수 없습니다. 중첩을 끄려면 `1`로 설정합니다.

중첩된 서브에이전트는 최상위 서브에이전트와 같은 방식으로 구성되며 같은 [범위](#choose-the-subagent-scope)에서 확인됩니다. 중첩이 켜져 있는 동안 읽기 전용으로 유지해야 하는 리뷰어처럼 특정 서브에이전트가 생성하지 못하게 하려면, 해당 서브에이전트의 [`tools`](#available-tools) 목록에서 `Agent`를 빼거나 `disallowedTools`에 추가합니다.

터미널에서 Claude Code는 프롬프트 입력 아래 서브에이전트 패널에 중첩된 서브에이전트를 트리로 표시하며, 패널에 아직 하위 항목이 있는 각 행에는 그 수를 나타내는 `(+N)`을 표시합니다. 행을 열면 해당 서브에이전트의 형제 항목과 직속 하위 항목이 `main`으로 돌아가는 경로와 함께 표시됩니다.

### 동시 서브에이전트 한도

두 가지 한도가 서브에이전트 사용을 제어하며, 각각 자체 변수를 가집니다. 이 한도는 너무 많은 서브에이전트가 실행 중일 때 Claude가 더 생성하지 못하게 하고, [깊이 한도](#let-subagents-spawn-their-own-subagents)는 서브에이전트가 중첩될 수 있는 깊이를 제한합니다. 세션 동안 Claude가 생성할 수 있는 서브에이전트의 총수에는 한도가 없습니다.

기본적으로 세션에서 20개의 서브에이전트가 실행 중이면 Agent 도구로 다른 서브에이전트를 생성하려는 시도는 `Concurrent subagent limit reached`와 함께 실패하며, 오류는 Claude에게 재시도하지 말라고 알립니다. 실행 중인 수가 한도 아래로 떨어지면 다시 생성할 수 있습니다. 한도를 변경하려면 [`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`](https://code.claude.com/docs/ko/env-vars)를 임의의 양의 정수로 설정합니다. [ultracode](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)가 활성화된 세션은 예외이며, 해당 세션에서는 한도가 적용되지 않습니다. Claude Code v2.1.217 이상이 필요합니다.

이 한도는 Claude가 Agent 도구로 생성하는 서브에이전트만 차단하지만, 다른 실행도 같은 슬롯을 차지합니다.

* [`/subtask`](#fork-the-current-conversation)로 시작하는 세션 내 포크는 실행되는 동안 슬롯을 차지하며, 한도에 의해 차단되지 않습니다.
* 이미 완료된 [서브에이전트를 재개](#resume-subagents)하면 한도를 확인하지 않고 새 슬롯을 차지하므로, 재개로 인해 실행 중인 수가 한도를 넘을 수 있습니다.

[워크플로](https://code.claude.com/docs/ko/workflows.md) 에이전트나 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 팀원처럼 다른 기능이 실행하는 에이전트는 대신 자체 한도를 따릅니다.

### 서브에이전트 컨텍스트 관리하기

#### 시작 시 로드되는 항목

각 서브에이전트는 새롭고 격리된 컨텍스트 윈도우로 시작합니다. 대화 기록, 이미 호출한 스킬, Claude가 이미 읽은 파일을 보지 못합니다. Claude가 작업을 요약하는 위임 메시지를 작성하면 서브에이전트는 그 메시지에서 작업을 시작합니다. 예외는 [포크](#fork-the-current-conversation)로, 새로 시작하는 대신 부모 대화를 상속합니다.

포크가 아닌 서브에이전트의 초기 컨텍스트에는 다음이 포함됩니다.

* **시스템 프롬프트**: Claude Code 시스템 프롬프트가 아닌, 에이전트 자체 프롬프트와 Claude Code가 덧붙이는 환경 세부 정보입니다. 사용자 지정 서브에이전트는 [markdown 본문](#write-subagent-files) 또는 `prompt` 필드에 정의합니다. 기본 제공 에이전트에는 미리 정의된 프롬프트가 있습니다.
* **작업 메시지**: Claude가 작업을 넘길 때 작성하는 위임 프롬프트입니다.
* **CLAUDE.md 파일**: `~/.claude/CLAUDE.md`, 프로젝트 규칙, `CLAUDE.local.md`, 관리형 정책 파일, 프로젝트 지침으로 로드되는 모든 [`AGENTS.md` 파일](https://code.claude.com/docs/ko/memory#agents-md)을 포함해, 메인 대화가 로드하는 [CLAUDE.md 계층](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load)의 모든 수준입니다. 기본 제공 Explore 및 Plan 에이전트는 이를 건너뜁니다. 정의에서 [`omitClaudeMd`](#supported-frontmatter-fields)를 설정한 서브에이전트는 관리형 정책 파일만 로드하며, 정의가 [관리형 설정](#choose-the-subagent-scope)에서 온 경우에는 아무것도 로드하지 않습니다.
* **Git 상태**: 서브에이전트가 시작될 때 Claude Code가 저장소에서 읽는 스냅샷입니다. 해당 저장소의 [자체 worktree](https://code.claude.com/docs/ko/worktrees.md#isolate-subagents-with-worktrees)에 있는 서브에이전트의 경우 스냅샷에는 워크트리의 브랜치, 상태, 최근 커밋이 표시됩니다. Git 저장소 밖에 있거나 스냅샷이 꺼져 있으면 포함되지 않습니다. [`includeGitInstructions`](https://code.claude.com/docs/ko/settings-reference#includegitinstructions)를 참조하세요. Explore와 Plan은 어떤 경우에도 이를 건너뜁니다.
* **미리 로드된 스킬**: 에이전트의 [`skills` 필드](#preload-skills-into-subagents)에 지정된 모든 스킬의 전체 내용입니다. 기본 제공 에이전트는 스킬을 미리 로드하지 않습니다.
* **형제 목록**: `main`과 세션의 다른 모든 이름이 지정된 에이전트를 나열하는 [시스템 리마인더](https://code.claude.com/docs/ko/glossary.md#system-reminder)로, 각각 [`SendMessage`](#resume-subagents)의 유효한 `to` 값입니다. 이 목록은 서브에이전트의 도구에 `SendMessage`가 포함되어 있고, Claude가 생성할 때 이름을 지정했든 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 팀원으로 실행되든 다른 에이전트 중 하나 이상에 이름이 있을 때만 표시됩니다. 서브에이전트가 시작될 때 찍은 스냅샷이므로 이후에 이름이 지정된 에이전트는 표시되지 않습니다.

사용자, 프로젝트, 로컬 CLAUDE.md 파일 없이 자체 서브에이전트를 시작하려면 해당 서브에이전트의 frontmatter 또는 `--agents` JSON에서 [`omitClaudeMd: true`](#supported-frontmatter-fields)를 설정합니다. Explore, Plan, `omitClaudeMd`가 설정된 서브에이전트의 경우, 서브에이전트가 하위 디렉터리의 파일로 작업할 때 해당 하위 디렉터리의 `CLAUDE.md`와 일치하는 [경로 범위 규칙](https://code.claude.com/docs/ko/memory.md#path-specific-rules)은 여전히 [로드](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load)됩니다.

메인 대화는 이러한 서브에이전트의 결과를 읽을 때 여전히 전체 CLAUDE.md를 가지고 있으므로, 대부분의 규칙은 서브에이전트 자체에 전달될 필요가 없습니다. "`vendor/` 디렉터리 무시"처럼 반드시 전달되어야 하는 규칙이 있다면, 위임할 때 Claude에게 주는 프롬프트에 다시 명시합니다.

어떤 서브에이전트가 git 상태를 받을지는 변경할 수 없습니다. Explore와 Plan만 이를 건너뜁니다.

일부 메인 대화 상태는 포크가 아닌 서브에이전트에 전달되지 않습니다.

* **출력 스타일**: 서브에이전트는 자체 시스템 프롬프트로 실행되므로, [포크](#fork-the-current-conversation)를 제외하면 [출력 스타일](https://code.claude.com/docs/ko/output-styles.md)이 서브에이전트의 응답에 영향을 주지 않습니다.
* **자동 메모리**: 메인 대화의 [자동 메모리](https://code.claude.com/docs/ko/memory.md#auto-memory)는 로드되지 않습니다. 서브에이전트에 자체 영구 메모리를 제공하려면 [`memory` 필드](#enable-persistent-memory)를 사용합니다.
* **컨텍스트 윈도우 크기**: 서브에이전트의 컨텍스트 윈도우 크기는 부모가 아닌 자체 모델에 따라 결정됩니다. 더 작은 윈도우를 가진 모델에 위임하면 해당 서브에이전트는 더 작은 윈도우를 갖게 됩니다.

#### 서브에이전트 재개하기

서브에이전트를 호출할 때마다 이전 인스턴스를 이어가는 대신 새 인스턴스가 생성됩니다. 처음부터 다시 시작하지 않고 기존 서브에이전트의 작업을 이어가려면 Claude에게 재개하도록 요청합니다.

재개된 서브에이전트는 이전의 모든 도구 호출, 결과, 추론을 포함한 전체 대화 기록을 유지합니다. 서브에이전트가 [자체 백그라운드 서브에이전트](#let-subagents-spawn-their-own-subagents)를 생성한 경우, 그 기록에는 실행 중에 해당 서브에이전트들이 전달한 결과가 포함됩니다. v2.1.304 이전에는 완료 직후 Claude가 메시지를 보내거나 재개한 서브에이전트가 가장 최근 작업을 잊어버릴 수 있었습니다.

* 서브에이전트가 완료되면 Claude는 해당 에이전트 ID를 받습니다.
* 기본 제공 Explore 및 Plan 에이전트는 일회성이며 에이전트 ID를 반환하지 않으므로 Claude가 재개할 수 없습니다. 작업을 이어가야 하는 경우 `general-purpose` 또는 사용자 지정 서브에이전트를 사용합니다.
* 서브에이전트가 [`maxTurns`](#supported-frontmatter-fields) 한도에서 중지되면 Claude Code는 반환된 출력을 부분 출력으로 표시하며, Claude는 서브에이전트를 재개해 작업을 이어갈 수 있습니다.

Claude는 에이전트의 ID나 이름을 `to` 필드로 사용해 `SendMessage` 도구로 에이전트를 재개합니다. `SendMessage`는 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md)이 활성화되어 있지 않아도 사용할 수 있으며, `shutdown_request` 및 `plan_approval_response`와 같은 구조화된 팀 프로토콜 메시지만 에이전트 팀을 필요로 합니다. 서브에이전트와 팀원 외에도, 세션 간 메시징이 활성화된 세션에서는 Claude가 같은 도구를 사용해 이 머신이나 [다른 머신](https://code.claude.com/docs/ko/cross-session-messaging.md#message-sessions-on-other-machines)에 있는 [다른 Claude Code 세션](https://code.claude.com/docs/ko/cross-session-messaging.md)에 메시지를 보낼 수 있습니다.

서브에이전트를 재개하려면 Claude에게 이전 작업을 이어가도록 요청합니다.

```text wrap theme={null}
Use the code-reviewer subagent to review the authentication module
[Agent completes]

Continue that code review and now analyze the authorization logic
[Claude resumes the subagent with full context from previous conversation]
```

Claude가 `SendMessage` 도구로 완료된 서브에이전트에 메시지를 보내면, 서브에이전트는 새 `Agent` 호출 없이 백그라운드에서 재개됩니다. Claude가 `TaskStop` 도구로 중지한 서브에이전트도 중지된 실행이 종료된 후에는 마찬가지입니다. 재개된 실행은 [서브에이전트가 처음 실행되었을 때의 도구 세트](#run-subagents-in-foreground-or-background)를 유지하며, [원래 실행이 준비해 둔 프롬프트 캐시](https://code.claude.com/docs/ko/prompt-caching.md#subagents-and-the-cache)를 계속 읽을 수 있습니다.

`SendMessage` 도구가 있는 서브에이전트도 이러한 메시지를 보낼 수 있습니다. 대화형 세션에서는 재개된 에이전트가 메인 대화가 아닌, 자신을 재개한 서브에이전트에게 결과를 보고합니다. 해당 서브에이전트는 자신의 작업을 마치기 전에 결과를 기다립니다. 서브에이전트가 자신을 시작한 에이전트처럼 자신이 보고하는 대상 에이전트에 메시지를 보내면, Claude Code는 결과를 다른 곳으로 돌리지 않고 해당 에이전트를 재개합니다.

`/tasks`에서 `x`를 누르거나 SDK `stop_task` 요청으로 사용자가 직접 중지한 서브에이전트는 자동으로 재개되지 않습니다. Claude가 메시지를 보내면 메시지가 거부되고 Claude에게 에이전트가 취소되었다고 알려집니다.

[해당 서브에이전트의 행이 서브에이전트 패널에 아직 남아 있는](#run-subagents-in-foreground-or-background) 동안에는 트랜스크립트에 입력해 직접 재개할 수 있습니다. 그 후에는 Claude의 메시지로 다시 자동 재개될 수 있습니다.

재개하면 같은 ID로 에이전트의 새 실행이 시작되므로, 이미 실패했거나 완료된 서브에이전트가 작업 목록과 Agent SDK의 작업 이벤트에서 다시 실행 중으로 표시됩니다.

`SendMessage`는 이름이 대화 앞부분에서 도달했던 에이전트를 여전히 가리키는지 확인합니다. 이름을 재사용한 재생성된 백그라운드 에이전트처럼 새로운 에이전트가 그 이름을 차지한 경우, Claude Code는 잘못된 에이전트에 전달하지 않고 전송을 거부하며, 오류에는 해당 이름이 현재 어느 에이전트에 도달하는지가 표시되어 Claude가 대상을 다시 지정할 수 있습니다. 이전 에이전트가 아직 실행 중일 때 그 에이전트에 도달하려면, Claude는 해당 에이전트를 생성할 때 받은 에이전트 ID로 지칭합니다. 이 확인은 현재 대화 범위에서만 적용되며 `/clear` 시 초기화됩니다.

서브에이전트는 작업 도중의 방향 수정을 포함해, 자신을 시작한 에이전트의 메시지를 일반적인 작업 지시로 취급하며 자체 권한 설정 내에서 이에 따라 행동합니다. 메시지를 누가 보냈든 두 가지 제한은 항상 유지됩니다. 어떤 에이전트의 메시지도 대기 중인 권한 프롬프트에 대한 사용자의 승인으로 간주되지 않으며, 어떤 에이전트 메시지도 서브에이전트의 권한 설정, `CLAUDE.md` 또는 구성을 변경할 수 없습니다. 승인은 권한 시스템이나 사용자 자신의 메시지로만 부여할 수 있습니다.

에이전트 ID를 명시적으로 참조하려면 Claude에게 ID를 물어보거나, `~/.claude/projects/{project}/{sessionId}/subagents/`의 트랜스크립트 파일에서 ID를 찾을 수도 있습니다. 각 트랜스크립트는 `agent-{agentId}.jsonl`로 저장됩니다.

서브에이전트 트랜스크립트는 메인 대화와 독립적으로 유지됩니다.

* **메인 대화 압축**: 메인 대화가 압축되어도 서브에이전트 트랜스크립트는 영향을 받지 않습니다. 별도의 파일에 저장되기 때문입니다.
* **세션 지속성**: 서브에이전트 트랜스크립트는 해당 세션 내에서 유지됩니다. Claude Code를 다시 시작한 후 같은 세션을 재개하면 [서브에이전트를 재개](#resume-subagents)할 수 있습니다.
* **자동 정리**: Claude Code는 [보존 정리 규칙](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)에 따라 `cleanupPeriodDays` 보존 기간(기본값 30일)이 지나면 서브에이전트 트랜스크립트를 삭제합니다.

##### 다시 시작한 후 이름으로 서브에이전트에 메시지 보내기

> [!NOTE]
>
> 팀원으로 시작된 서브에이전트의 경우 대신 [에이전트 팀 제한 사항](https://code.claude.com/docs/ko/agent-teams.md#limitations)을 참조하세요.

Claude Code를 다시 시작하고 세션을 재개한 후 Claude가 이름으로 서브에이전트에 메시지를 보낼 수 없다면, 대신 서브에이전트의 에이전트 ID를 Claude에게 알려 줍니다. 마지막 [압축](https://code.claude.com/docs/ko/context-window.md#what-survives-compaction) 이후 Claude가 메인 대화에서 지정한 이름은 다시 시작한 후에도 유지됩니다. 그 압축 이전의 이름은 유지되지 않습니다. 이름에 해당하는 ID를 찾으려면 `~/.claude/projects/{project}/{sessionId}/subagents/`의 `agent-{agentId}.meta.json` 파일에서 해당 이름을 찾습니다.

ID로 메시지를 한 번 보내면, 새로운 에이전트가 그 이름을 차지하지 않은 한 서브에이전트의 이름이 다시 작동합니다. v2.1.299 이전에는 다시 시작한 후 어떤 이름도 유지되지 않았으며, 에이전트 ID가 여전히 작동하는 경우에도 이름으로 보낸 메시지는 거부되었습니다.

#### 자동 압축

서브에이전트는 자동 압축을 지원합니다. 압축은 서브에이전트 자체의 컨텍스트 윈도우가 차면서 트리거되며, `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`는 서브에이전트에도 적용됩니다. 재정의가 적용되는 시점은 [환경 변수](https://code.claude.com/docs/ko/env-vars.md)를 참조하세요.

압축 이벤트는 서브에이전트 트랜스크립트 파일에 기록됩니다.

```json theme={null}
{
  "type": "system",
  "subtype": "compact_boundary",
  "compactMetadata": {
    "trigger": "auto",
    "preTokens": 167189
  }
}
```

`preTokens` 값은 압축이 발생하기 전에 사용된 토큰 수를 나타냅니다.

##### 하나의 서브에이전트에 대한 자동 압축 윈도우 설정하기

하나의 서브에이전트가 평소보다 일찍 압축되도록 하려면 해당 서브에이전트의 [frontmatter](#supported-frontmatter-fields)에서 `autoCompactWindow`를 `100000`부터 `1000000`까지의 토큰 수로 설정합니다. [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](https://code.claude.com/docs/ko/env-vars#variables)를 설정한 경우, Claude Code가 [해당 변수의 값을 무시](https://code.claude.com/docs/ko/model-config.md#claude_code_auto_compact_window-values)하지 않는 한 서브에이전트는 대신 그 변수의 윈도우를 사용하고 이 필드는 효과가 없습니다. Claude Code v2.1.296 이상이 필요합니다.

다음 frontmatter는 긴 로그 파일을 읽는 서브에이전트의 `autoCompactWindow`를 200,000 토큰으로 설정합니다.

```yaml theme={null}
---
name: log-reader
description: Reads long log files and reports the errors it finds
autoCompactWindow: 200000
---
```

값은 `200000`과 같은 일반 정수로 작성해야 합니다. frontmatter에서 Claude Code는 `200k`를 200으로 읽으며, 이는 허용 범위를 벗어납니다. 이 경우에도 서브에이전트는 필드가 없는 것처럼 로드되고 압축됩니다. Claude Code가 값을 무시했는지 확인하려면 셸에서 `claude --debug`를 실행하고 [디버그 로그](#supported-frontmatter-fields)에서 `invalid autoCompactWindow`를 검색합니다.

값이 범위 안에 있는데도 변화가 없다면 다음 원인을 확인합니다.

* **값이 서브에이전트가 원래 상속할 [자동 압축 윈도우](https://code.claude.com/docs/ko/model-config.md#context-window-and-auto-compaction)보다 작지 않은 경우**: 더 일찍 압축하려면 해당 윈도우보다 작은 값을 설정합니다.
* **`--agent` 또는 `agent` 설정으로 세션 전체를 이 서브에이전트로 실행하는 경우**: 이때는 필드가 효과가 없습니다. 세션의 윈도우를 설정하려면 [자동 압축 윈도우 설정하기](https://code.claude.com/docs/ko/model-config.md#set-the-auto-compact-window)를 참조하세요.

## 현재 대화 포크

> [!NOTE]
>
> [에이전트 보기가 꺼져 있을 때](https://code.claude.com/docs/ko/agent-view.md#turn-off-agent-view), `/subtask`는 사용할 수 없으며 `/fork`가 포크된 서브에이전트를 대신 시작합니다. 그렇지 않으면 `/fork`는 전체 세션을 새로운 [background 세션](https://code.claude.com/docs/ko/agent-view.md#from-inside-a-session)으로 복사합니다.

포크는 새로 시작하는 대신 지금까지의 전체 대화를 상속하는 subagent입니다. 이렇게 하면 subagent가 일반적으로 제공하는 입력 격리가 떨어집니다: 포크는 주 세션과 동일한 시스템 프롬프트, 도구, 모델 및 메시지 기록을 보므로 상황을 다시 설명할 필요 없이 부작업을 전달할 수 있습니다. 포크의 자체 도구 호출은 여전히 대화에서 벗어나고 최종 결과만 돌아오므로 주 컨텍스트 윈도우가 깨끗하게 유지됩니다. 다른 subagent가 유용하기에는 너무 많은 배경이 필요하거나 동일한 시작점에서 여러 접근 방식을 병렬로 시도하려는 경우 포크를 사용합니다.

포크 모드가 켜져 있는 동안에는 Claude가 스스로 포크를 시작할 수 있으며, 포크 모드는 기본적으로 켜져 있습니다. 포크를 중지하려면 [포크 모드 끄기](#turn-fork-mode-on-or-off)를 참조하세요.

`/subtask` 다음에 작업을 입력하여 포크 모드가 켜져 있는지 여부와 관계없이 직접 포크를 시작할 수 있습니다. Claude Code는 작업의 첫 단어에서 포크의 이름을 지정합니다. 다음 예제는 주 세션에서 구현을 계속하는 동안 포크가 테스트 케이스를 작성하도록 포크합니다:

```text wrap theme={null}
/subtask draft unit tests for the parser changes so far
```

포크는 프롬프트 입력 아래의 패널에 나타나고 계속 작업하는 동안 background에서 실행됩니다. 완료되면 결과가 주 대화의 메시지로 도착합니다. 다음 섹션에서는 포크가 실행되는 동안 포크를 관찰하고 조종하기 위한 패널 컨트롤을 다룹니다.

### 실행 중인 포크 관찰 및 조종

실행 중인 포크는 프롬프트 입력 아래의 패널에 나타나며, 주 세션에 대한 행과 각 포크에 대한 행이 있습니다.

포크가 성공적으로 완료되면 Claude Code는 해당 행을 제거합니다. Claude Code는 실패했거나 중지한 포크의 행을 30초 동안 유지합니다. [다른 background subagent와 동일합니다](#run-subagents-in-foreground-or-background). v2.1.232 이전에는 Claude Code가 완료된 포크의 행을 30초 동안 유지했습니다.

이 키를 사용하여 패널과 상호 작용합니다:

| 키 | 작업 |
| :- | :- |
| `↑` / `↓` | 행 간 이동 |
| `Enter` | 선택한 포크의 트랜스크립트를 열고 후속 메시지 전송 |
| `x` | 실행 중인 경우 선택한 포크를 중지하거나, 더 이상 실행 중이 아닌 경우 행을 닫습니다. 주 세션 행 또는 `Enter`로 트랜스크립트를 연 포크의 행에서는 `x`가 프롬프트에 입력됩니다 |
| `Esc` | 프롬프트 입력으로 포커스 반환 |

포크 또는 서브에이전트의 트랜스크립트가 열려 있으면 후속 메시지와 [스킬](https://code.claude.com/docs/ko/skills.md)은 해당 에이전트로 전달되고 기본 제공 명령은 주 대화로 전달되며, 다음과 같은 안전장치가 적용됩니다:

* `/compact`, `/clear`, `/rewind`는 주 대화에 작용하므로, 이 보기에서 이 중 하나를 실행하기 전에 Claude Code가 확인을 요청합니다.
* `/model`과 `/fast`는 보고 있는 에이전트가 아닌 주 대화의 모델과 빠른 모드를 설정하므로 이 보기에서는 실행되지 않습니다. 그 이유를 알려 주는 알림이 표시됩니다.

보고 있는 에이전트가 대기 중인 작업이 끝나기 전에 메시지를 읽도록 하려면 [`Ctrl+Enter` 또는 `Ctrl+X Ctrl+S`](https://code.claude.com/docs/ko/keybindings#chat-actions)로 메시지를 전송합니다. 에이전트가 대기 중인 셸 명령이나 서브에이전트 중 [background](https://code.claude.com/docs/ko/tools-reference.md#background-commands)로 이동할 수 있는 것은 그곳으로 이동하여 계속 실행됩니다. 에이전트가 응답을 작성하는 중이거나 background로 이동할 수 없는 작업을 기다리는 중이면 계속 진행하며, 해당 작업이 끝난 후 메시지를 읽습니다. Claude Code v2.1.286 이상이 필요합니다.

### 포크와 다른 subagent의 차이점

포크는 생성 시점의 주 세션의 모든 것을 상속합니다. 다른 subagent는 정의에서 새로 시작합니다.

| | 포크 | 비포크 subagent |
| :- | :- | :- |
| 컨텍스트 | 전체 대화 기록 | 전달하는 프롬프트를 사용한 새로운 컨텍스트 |
| 시스템 프롬프트 및 도구 | 주 세션과 동일 | Subagent의 [정의 파일](#write-subagent-files)에서, [background 실행을 위해 필터링됨](#available-tools) |
| 모델 | 주 세션과 동일 | Subagent의 `model` 필드에서 |
| 프롬프트 캐시 | 주 세션과 공유 | 별도 캐시 |

포크의 시스템 프롬프트 및 도구 정의가 부모와 동일하기 때문에 첫 번째 요청은 부모의 [프롬프트 캐시](https://code.claude.com/docs/ko/prompt-caching.md#subagents-and-the-cache)를 재사용합니다. 이렇게 하면 동일한 컨텍스트가 필요한 작업에 대해 새로운 서브에이전트를 생성하는 것보다 포크가 더 저렴합니다.

Claude가 Agent 도구를 통해 포크를 생성할 때 `isolation: "worktree"`를 전달하여 포크의 파일 편집이 체크아웃 대신 별도의 git worktree에 기록되도록 할 수 있습니다. 포크는 추가 포크를 생성할 수 없습니다.

### 포크 모드 끄기

포크 모드를 사용하면 Claude가 스스로 포크를 시작할 수 있습니다. Claude가 포크를 시작하지 못하도록 하려면 다음과 같이 합니다:

* **포크만 중지**: [설정](#disable-specific-subagents)의 `permissions.deny`에 `"Agent(fork)"`를 추가합니다.
* **포크 모드 끄기**: [Claude가 서브에이전트를 기다리도록 하기](#let-claude-wait-for-a-subagent)의 단계에 따라 `CLAUDE_CODE_FORK_SUBAGENT`를 `0`으로 설정합니다.

포크 모드가 켜져 있는 동안에는 로컬 머신의 대화형 터미널, VS Code 또는 데스크톱 세션에서 Claude가 [서브에이전트를 기다릴](#run-subagents-in-foreground-or-background) 수도 없습니다. 포크 모드는 Claude Code v2.1.302부터 기본적으로 켜져 있으며, 대화형 터미널 세션에서는 v2.1.232부터 기본적으로 켜져 있습니다.

## 예제 subagent

이러한 예제는 subagent를 구축하기 위한 효과적인 패턴을 보여줍니다. 시작점으로 사용하거나 Claude로 사용자 정의된 버전을 생성합니다.

> [!TIP]
>
> **모범 사례:**
>
> * **집중된 subagent 설계:** 각 subagent는 특정 작업에서 탁월해야 합니다
> * **각 subagent를 구분하는 설명 작성:** Claude는 설명을 사용하여 위임할 시기를 결정합니다. 각 설명이 올바른 subagent로 라우팅할 수 있을 정도로 구체적이어야 하며, 결합된 집합을 [15,000토큰 설명 예산](#understand-automatic-delegation) 내에 유지합니다
> * **도구 액세스 제한:** 보안 및 집중을 위해 필요한 권한만 부여합니다
> * **버전 제어에 체크인:** 프로젝트 subagent를 팀과 공유합니다

### 코드 검토자

수정하지 않고 코드를 검토하는 읽기 전용 subagent입니다. 이 예제는 제한된 도구 액세스(Edit 및 Write 제외)와 정확히 무엇을 찾을지 및 출력 형식을 지정하는 자세한 프롬프트를 사용하여 집중된 subagent를 설계하는 방법을 보여줍니다.

```markdown theme={null}
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.
```

### 디버거

문제를 분석하고 수정할 수 있는 subagent입니다. 코드 검토자와 달리 이 subagent는 버그 수정이 코드 수정을 필요로 하기 때문에 Edit을 포함합니다. 프롬프트는 진단에서 검증까지의 명확한 워크플로우를 제공합니다.

```markdown theme={null}
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

Debugging process:
- Analyze error messages and logs
- Check recent code changes
- Form and test hypotheses
- Add strategic debug logging
- Inspect variable states

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach
- Prevention recommendations

Focus on fixing the underlying issue, not the symptoms.
```

### 데이터 과학자

데이터 분석 작업을 위한 도메인별 subagent입니다. 이 예제는 일반적인 코딩 작업 외에 특화된 워크플로우를 위해 subagent를 만드는 방법을 보여줍니다. 더 유능한 분석을 위해 명시적으로 `model: sonnet`을 설정합니다.

```markdown theme={null}
---
name: data-scientist
description: Data analysis expert for SQL queries, BigQuery operations, and data insights. Use proactively for data analysis tasks and queries.
tools: Bash, Read, Write
model: sonnet
---

You are a data scientist specializing in SQL and BigQuery analysis.

When invoked:
1. Understand the data analysis requirement
2. Write efficient SQL queries
3. Use BigQuery command line tools (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

Key practices:
- Write optimized SQL queries with proper filters
- Use appropriate aggregations and joins
- Include comments explaining complex logic
- Format results for readability
- Provide data-driven recommendations

For each analysis:
- Explain the query approach
- Document any assumptions
- Highlight key findings
- Suggest next steps based on data

Always ensure queries are efficient and cost-effective.
```

### 데이터베이스 쿼리 검증자

Bash 액세스를 허용하지만 읽기 전용 SQL 쿼리만 허용하도록 명령을 검증하는 subagent입니다. 이 예제는 `tools` 필드보다 더 세밀한 제어가 필요할 때 `PreToolUse` hook을 사용하는 방법을 보여줍니다.

```markdown theme={null}
---
name: db-reader
description: Execute read-only database queries. Use when analyzing data or generating reports.
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---

You are a database analyst with read-only access. Execute SELECT queries to answer questions about the data.

When asked to analyze data:
1. Identify which tables contain the relevant data
2. Write efficient SELECT queries with appropriate filters
3. Present results clearly with context

You cannot modify data. If asked to INSERT, UPDATE, DELETE, or modify schema, explain that you only have read access.
```

Claude Code는 [hook 입력을 JSON으로](https://code.claude.com/docs/ko/hooks.md#pretooluse-input) stdin을 통해 hook 명령에 전달합니다. 검증 스크립트는 이 JSON을 읽고 실행 중인 명령을 추출하고 SQL 쓰기 작업 목록에 대해 확인합니다. 쓰기 작업이 감지되면 스크립트는 [종료 코드 2](https://code.claude.com/docs/ko/hooks.md#exit-code-2-behavior-per-event)로 종료하여 실행을 차단하고 stderr를 통해 Claude에 오류 메시지를 반환합니다.

프로젝트의 어디든지 검증 스크립트를 만듭니다. 경로는 hook 구성의 `command` 필드와 일치해야 합니다:

```bash theme={null}
#!/bin/bash
# Blocks SQL write operations, allows SELECT queries

# Read JSON input from stdin
INPUT=$(cat)

# Extract the command field from tool_input using jq
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Block write operations (case-insensitive)
if echo "$COMMAND" | grep -iE '\b(INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|TRUNCATE|REPLACE|MERGE)\b' > /dev/null; then
  echo "Blocked: Write operations not allowed. Use SELECT queries only." >&2
  exit 2
fi

exit 0
```

macOS 및 Linux에서 스크립트를 실행 가능하게 만듭니다:

```bash theme={null}
chmod +x ./scripts/validate-readonly-query.sh
```

Windows에서는 검증 스크립트를 PowerShell로 작성하고 hook 항목에 `shell: powershell`을 추가합니다. [PowerShell에서 hook 실행](https://code.claude.com/docs/ko/hooks.md#windows-powershell-tool)을 참조하세요.

Hook은 stdin을 통해 JSON을 받으며 Bash 명령은 `tool_input.command`에 있습니다. 종료 코드 2는 작업을 차단하고 오류 메시지를 Claude에 피드백합니다. 종료 코드 및 출력에 대한 자세한 내용은 [Hooks](https://code.claude.com/docs/ko/hooks.md#exit-code-output)를 참조하고 [Hook input](https://code.claude.com/docs/ko/hooks.md#pretooluse-input)에서 전체 입력 스키마를 확인하세요.

시스템 프롬프트는 subagent에 쓰기 요청을 거부하도록 지시하므로 hook은 백스톱입니다. subagent가 어쨌든 쓰기를 시도하면 Claude Code는 명령을 차단하고 subagent는 `Blocked: Write operations not allowed. Use SELECT queries only.` 메시지를 봅니다.

## 다음 단계

이제 subagent를 이해했으므로 다음 관련 기능을 탐색합니다:

* [플러그인으로 subagent 배포](https://code.claude.com/docs/ko/plugins/components.md#agents) - 팀 또는 프로젝트 간에 subagent 공유
* [Claude Code를 프로그래밍 방식으로 실행](https://code.claude.com/docs/ko/headless.md) - CI/CD 및 자동화를 위한 Agent SDK
* [MCP 서버 사용](https://code.claude.com/docs/ko/mcp.md) - Subagent에 외부 도구 및 데이터에 대한 액세스 제공
