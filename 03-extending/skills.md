> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude를 skills로 확장하기

> Claude Code에서 skills를 생성, 관리 및 공유하여 Claude의 기능을 확장합니다. 사용자 정의 명령어 및 번들 skills를 포함합니다.

Skills는 Claude가 할 수 있는 작업을 확장합니다. `SKILL.md` 파일을 지침과 함께 생성하면 Claude가 이를 자신의 도구 모음에 추가합니다. Claude는 관련성이 있을 때 skills를 사용하거나, `/skill-name`으로 직접 호출할 수 있습니다.

동일한 지침, 체크리스트 또는 다단계 절차를 반복해서 채팅에 붙여넣거나, CLAUDE.md의 섹션이 사실이 아닌 절차로 성장했을 때 skill을 생성합니다. CLAUDE.md 콘텐츠와 달리, skill의 본문은 사용할 때만 로드되므로 긴 참고 자료는 필요할 때까지 거의 비용이 들지 않습니다.

> [!NOTE]
>
> `/help` 및 `/compact`와 같은 기본 제공 명령어와 `/debug` 및 `/code-review`와 같은 번들 skills의 경우 [명령어 참조](https://code.claude.com/docs/ko/commands.md)를 참조하세요.
>
> **사용자 정의 명령어가 skills로 병합되었습니다.** `.claude/commands/deploy.md`의 파일과 `.claude/skills/deploy/SKILL.md`의 skill은 모두 `/deploy`를 생성하고 동일한 방식으로 작동합니다. 기존 `.claude/commands/` 파일은 계속 작동합니다. Skills는 선택적 기능을 추가합니다: 지원 파일을 위한 디렉토리, [사용자 또는 Claude가 호출하는지 제어](#control-who-invokes-a-skill)하기 위한 frontmatter, 그리고 Claude가 관련성이 있을 때 자동으로 로드할 수 있는 기능입니다.

Claude Code skills는 여러 AI 도구에서 작동하는 [Agent Skills](https://agentskills.io) 개방형 표준을 따릅니다. Claude Code는 [호출 제어](#control-who-invokes-a-skill), [subagent 실행](#run-skills-in-a-subagent), [동적 컨텍스트 주입](#inject-dynamic-context)과 같은 추가 기능으로 표준을 확장합니다. [Claude Code 외부에서 skill frontmatter 사용](#using-skill-frontmatter-outside-claude-code)에서 어떤 frontmatter 필드가 표준의 일부이고 어떤 필드가 Claude Code 확장인지 확인하세요.

## 번들 스킬

Claude Code에는 `/doctor`, `/code-review`, `/batch`, `/debug`, `/loop`, `/claude-api` 등의 번들 스킬 세트가 포함되어 있습니다. 번들 스킬은 프롬프트 기반입니다. 즉, Claude에 상세한 지침을 제공하고 도구를 사용하여 작업을 조율하도록 합니다. 대부분의 기본 제공 명령은 대신 고정된 로직을 직접 실행합니다.

번들 스킬은 다른 스킬과 동일한 방식으로 호출합니다. `/` 다음에 스킬 이름을 입력하면 됩니다. Claude는 관련성이 있을 때 일부 번들 스킬을 자동으로 호출합니다. `/verify`를 포함한 다른 스킬은 사용자가 호출할 때만 실행되므로, 이러한 더 오래 실행되는 검사가 시간과 토큰을 소비하는 시점을 제어할 수 있습니다.

대부분의 번들 스킬은 모든 세션에서 사용 가능합니다. 일부는 특정 기능에 따라 달라집니다. 예를 들어 `/workflow-authoring`은 [동적 워크플로](https://code.claude.com/docs/ko/workflows.md)가 활성화된 경우에만 사용 가능합니다.

번들 스킬을 끄려면 [`disableBundledSkills`](https://code.claude.com/docs/ko/settings-reference#disablebundledskills) 설정을 사용하면 됩니다.

> [!NOTE]
>
> [`/doctor`](https://code.claude.com/docs/ko/commands#all-commands) 설정 점검은 `disableBundledSkills`가 켜져 있을 때도 입력 가능합니다. 이를 숨기려면 `DISABLE_DOCTOR_COMMAND` 환경 변수를 설정하거나 [`skillOverrides`](#override-skill-visibility-from-settings) 항목을 `"doctor": "off"`로 설정하면 됩니다.

번들 스킬은 [명령 참조](https://code.claude.com/docs/ko/commands.md)에서 기본 제공 명령과 함께 나열되며, 목적 열에 **Skill**로 표시됩니다.

### `/doctor`로 설정 점검

Claude Code 프롬프트에서 `/doctor`를 실행하면 문제를 진단하고 수정할 수 있는 설정 점검을 수행합니다. Claude는 먼저 발견 사항을 보고하고, 무엇이든 변경하기 전에 확인을 요청합니다. 점검 대상은 다음과 같습니다.

* **설치 상태**: 중복되거나 남아 있는 설치, `PATH` 문제, 파싱할 수 없는 설정 파일, 그리고 [릴리스 채널](https://code.claude.com/docs/ko/setup.md#configure-release-channel)에 더 새로운 버전이 있는지 여부
* **확장 기능**: 컨텍스트 비용 대비 사용되지 않는 스킬, MCP 서버, 플러그인, 그리고 느린 [훅](https://code.claude.com/docs/ko/hooks.md)
* **`CLAUDE.md` 파일**: 체크인된 파일과 중복되는 로컬 `CLAUDE.md` 파일, 체크인된 [`CLAUDE.md` 내용 중 Claude가 코드베이스에서 도출할 수 있는 내용](https://code.claude.com/docs/ko/memory#my-claude-md-is-too-large), 그리고 항상 로드되는 나머지 지침. Claude는 이 지침을 필요할 때 로드되는 스킬과 중첩된 `CLAUDE.md` 파일로 옮기도록 제안합니다
* **권한**: [자동 모드](https://code.claude.com/docs/ko/permissions.md#permission-modes)를 기본 권한 모드로 설정하고, 자주 거부하는 읽기 전용 명령을 [사전 승인](https://code.claude.com/docs/ko/permissions.md)하도록 제안
* **사용량**: Pro, Max, Ultra, Team 또는 Enterprise 플랜에서 최근 7일간 측정한 플랜 사용량을 줄이기 위해 [`/usage`가 권장하는 변경 사항](https://code.claude.com/docs/ko/costs#plan-usage-breakdown). Claude는 직접 적용할 수 있는 변경 사항은 제안하고, 나머지는 사용자가 실행할 명령과 같은 조언으로 보고합니다. 사용량 점검은 Claude Code v2.1.305 이상이 필요하며, [Remote Control](https://code.claude.com/docs/ko/remote-control.md)이 연결되어 있는 동안에는 `/doctor`에서 제외됩니다.

세션을 시작하지 않고 읽기 전용 설치 진단을 수행하려면 대신 터미널에서 `claude doctor`를 실행합니다.

설정이 아닌 지침을 감사하려면 Claude Code 프롬프트에서 `/doctor prompt-audit`를 실행합니다. Claude는 점검을 실행하는 대신 [`CLAUDE.md` 파일, 스킬 및 기타 구성을 검사](https://code.claude.com/docs/ko/memory#audit-your-instruction-files)하여 오래되었거나 충돌하는 지침을 찾습니다. `prompt-audit` 하위 명령은 Claude Code v2.1.283 이상이 필요합니다.

### 앱 실행 및 확인

세 가지 번들 스킬이 함께 작동하여 앱을 시작하고 테스트만이 아닌 실행 중인 앱에 대해 변경 사항을 확인합니다.

| 스킬 | 목적 |
| :- | :- |
| `/run` | 앱을 시작하고 실행하여 변경 사항이 작동하는지 확인 |
| `/verify` | 앱을 빌드하고 실행하여 코드 변경이 의도한 대로 작동하는지 확인하며, 테스트나 타입 검사로 폴백하지 않음 |
| `/run-skill-generator` | `/run`과 `/verify`에 프로젝트를 빌드하고 시작하는 방법을 학습시킴 |

`/run`과 `/verify`는 설정 없이 작동합니다. 프로젝트 유형(CLI, 서버, TUI, 브라우저 기반)과 README, `package.json` 또는 `Makefile`의 내용으로부터 시작을 추론합니다. 이 추론은 표준 시작 이상의 것이 필요한 프로젝트(데이터베이스, env 파일, 그래픽 세션, 다단계 빌드)에서는 신뢰할 수 없게 됩니다.

`/run-skill-generator`는 대신 레시피를 기록합니다. 깨끗한 환경에서 앱을 실행하고, 작동한 것(설치 명령, env 변수, 시작 스크립트)을 캡처하고, 프로젝트별 스킬로 `.claude/skills/run-<name>/`에 커밋합니다. 그 후 `/run`, `/verify` 및 리포지토리의 다른 에이전트는 레시피를 다시 발견하는 대신 기록된 레시피를 따릅니다. 프로젝트당 한 번 `/run-skill-generator`를 실행하고, 빌드 또는 시작 프로세스가 변경되면 다시 실행합니다.

`/verify`는 자체 레시피를 기록할 수도 있습니다. 기록된 레시피 없이 앱을 빌드하고 실행해야 할 때, 작동한 것을 리포지토리 루트의 `.claude/skills/verify/SKILL.md`에 또는 모노레포의 터치된 패키지 디렉토리에 작성하므로 나중의 실행과 다른 에이전트가 동일한 단계를 따릅니다. 리포지토리 루트에서 기록된 스킬은 번들 `/verify`를 대체합니다.

Claude는 실패한 명령이나 누락된 단계와 같이 실행을 잘못 조종한 경우에만 기록된 파일을 편집하므로 세션별 diff 없이 파일을 커밋할 수 있습니다.

### 각 커밋 전에 검사 실행

`verify` 또는 `simplify`라는 이름의 스킬이 있는 상태로 세션이 시작되면, Claude Code의 커밋 지침은 문서나 테스트 변경을 제외하고 각 커밋 직전에 해당 스킬을 실행하도록 Claude에 지시합니다. 이는 Claude Code v2.1.286 이상이 필요합니다. 세션 시작 시 다음 조건이 충족되면 Claude가 이 지침을 받습니다.

* **위치**: 스킬이 엔터프라이즈, 개인, 프로젝트 또는 추가 디렉토리 [위치](#where-skills-live)에서 로드되거나, 해당 이름의 `.claude/commands/` 파일에서 로드됩니다. `/verify`가 리포지토리 루트에 기록하는 레시피는 프로젝트 스킬이므로 해당됩니다. 번들 `/verify`와 `/simplify`, 플러그인 스킬, claude.ai 계정의 스킬은 해당되지 않습니다.
* **호출**: Claude가 스킬을 호출할 수 있어야 합니다. 예를 들어 `disable-model-invocation: true`로 [Claude가 스킬을 호출하지 못하도록 한](#control-who-invokes-a-skill) 경우 Claude는 이 지침을 받지 않습니다.
* **Git 지침**: [`includeGitInstructions`](https://code.claude.com/docs/ko/settings-reference#includegitinstructions)를 끄지 않아야 합니다. 이를 끄면 나머지 기본 제공 커밋 및 PR 지침과 함께 이 지침도 제거됩니다.

### Claude API 프로젝트 작업

번들 `/claude-api` 스킬은 프로젝트 언어에 맞는 [Claude API](https://platform.claude.com/docs/en/api/overview) 및 [Managed Agents](https://platform.claude.com/docs/en/managed-agents/overview) 참조 자료를 로드합니다. 코드에서 `anthropic` 또는 `@anthropic-ai/sdk`를 가져오는 경우 Claude가 이 스킬을 자동으로 활성화하기도 합니다.

스킬의 워크플로 중 하나를 시작하려면 Claude Code 프롬프트에서 스킬 이름 뒤에 하위 명령을 입력합니다(예: `/claude-api migrate`). 아래 표에는 각 하위 명령의 기능과 해당 하위 명령이 포함된 가장 이른 Claude Code 버전이 나와 있습니다. `migrate`와 `managed-agents-onboard`는 표에서 추적하는 가장 오래된 버전인 v2.1.221 이전부터 제공되었습니다.

| 하위 명령 | 기능 | 최소 버전 |
| :- | :- | :- |
| `migrate` | 기존 Claude API 코드를 최신 모델에 맞게 업데이트 | v2.1.221 이전 |
| `upgrade` | 프로젝트의 Anthropic SDK를 새 메이저 버전으로 업그레이드하고 호환성이 깨지는 변경 사항에 맞게 코드를 업데이트 | v2.1.236 이상 |
| `api-version` | Claude API 코드를 최신 [API 버전](https://platform.claude.com/docs/en/api/versioning)에 맞게 업데이트한 다음 요청을 해당 버전으로 전환 | v2.1.307 이상 |
| `managed-agents-onboard` | 새 Managed Agent 생성 과정을 단계별로 안내 | v2.1.221 이전 |
| `managed-agents-onboard <url>` | [Managed Agents 문서](https://platform.claude.com/docs/en/managed-agents/overview)의 페이지 등 해당 URL의 페이지에 설명된 Managed Agent를 구축 | v2.1.290 이상 |
| `managed-agents-onboard <quickstart-name>` | `deep-researcher` 등 Console의 빠른 시작 템플릿 중 하나를 구축. 템플릿 이름이 아닌 단어 하나를 입력하면 Claude가 유효한 이름 목록을 표시 | v2.1.290 이상 |
| `managed-agents-secure [<agent-id>]` | Managed Agent 하나의 설정을 읽고 [Managed Agents 배포 보안](https://platform.claude.com/docs/en/managed-agents/secure-deployment) 가이드와 일치하는 부분과 다른 부분을 보고. [`ant` CLI](https://platform.claude.com/docs/en/cli-sdks-libraries/cli/quickstart)가 필요 | v2.1.304 이상 |
| `prompt-audit` | 프롬프트, 스킬, 도구 설명에서 이전 모델용으로 작성된 지침에 플래그를 지정하고 수정 사항을 diff로 제안 | v2.1.221 이상 |
| `cost-optimize` | 프로젝트의 Claude API 지출이 어디에 쓰이는지 프로파일링하고, 프롬프트 캐싱, 불필요한 입력 및 출력 토큰 줄이기, 배치 처리, effort, 모델 선택 등의 옵션을 통한 절감 방안을 한 번에 하나씩 제안 | v2.1.247 이상 |
| `build-eval` | Claude 기반 앱을 위한 평가 세트 구축 | v2.1.259 이상 |
| `hillclimb` | 기존 평가를 기준으로 앱을 반복적으로 개선 | v2.1.259 이상 |
| `preserved-thinking-migration` | 통합이 이전 턴, 시스템 프롬프트 또는 도구 목록에 가하는 편집 중 [preserved thinking](https://platform.claude.com/docs/en/build-with-claude/preserved-thinking) 블록을 무효화하는 편집을 찾아 각 편집으로 손실되는 추론의 양을 측정하고, 수정 사항을 한 번에 하나씩 제안하며 변경할 때마다 다시 측정 | v2.1.282 이상 |

## 시작하기

### 첫 번째 skill 만들기

이 예제는 git 저장소의 커밋되지 않은 변경 사항을 요약하고 위험한 부분을 표시하는 skill을 만듭니다. 실시간 diff를 Claude가 읽기 전에 프롬프트로 가져오므로, 응답이 Claude가 열린 파일에서 추측할 수 있는 것이 아니라 실제 작업 트리에 기반합니다. Claude는 변경 사항에 대해 물어볼 때 자동으로 skill을 로드하거나, `/summarize-changes`로 직접 호출할 수 있습니다.

**1. skill 디렉토리 만들기**

개인 skills 폴더에 skill용 디렉토리를 만듭니다. 개인 skills는 모든 프로젝트에서 사용할 수 있습니다.

```bash theme={null}
mkdir -p ~/.claude/skills/summarize-changes
```

**2. SKILL.md 작성**

모든 스킬에는 `SKILL.md` 파일이 필요합니다. 이 파일은 두 부분으로 구성됩니다: Claude에게 스킬을 언제 사용할지 알려주는 `---` 마커 사이의 YAML frontmatter와 스킬이 실행될 때 Claude가 따르는 지침이 포함된 markdown 콘텐츠입니다. 디렉토리 이름(또는 frontmatter `name`을 설정한 경우 해당 값)이 입력하는 명령이 되고, `description`은 Claude가 스킬을 자동으로 로드할지 결정하는 데 도움이 됩니다.

이를 `~/.claude/skills/summarize-changes/SKILL.md`에 저장합니다:

```yaml theme={null}
---
description: Summarizes uncommitted changes and flags anything risky. Use when the user asks what changed, wants a commit message, or asks to review their diff.
---

## Current changes

!`git diff HEAD`

## Instructions

Summarize the changes above in two or three bullet points, then list any risks you notice such as missing error handling, hardcoded values, or tests that need updating. If the diff is empty, say there are no uncommitted changes.
```

`` !`git diff HEAD` `` 줄은 [동적 컨텍스트 주입](#inject-dynamic-context)을 사용합니다: Claude Code는 명령어를 실행하고 Claude가 skill 콘텐츠를 보기 전에 줄을 출력으로 바꾸므로, 지침이 현재 diff가 이미 인라인된 상태로 도착합니다.

**3. skill 테스트**

git 프로젝트를 열고, 파일을 약간 편집한 후 `claude`를 실행하여 Claude Code를 시작합니다. skill을 두 가지 방법으로 테스트할 수 있습니다.

**설명과 일치하는 내용을 물어봐서 Claude가 자동으로 호출하도록 하기:**

```text theme={null}
What did I change?
```

**또는 skill 이름으로 직접 호출:**

```text theme={null}
/summarize-changes
```

어느 쪽이든 Claude는 편집 내용의 짧은 요약과 위험 목록으로 응답해야 합니다.

## 스킬이 로드되는 위치 선택

스킬을 저장하는 위치에 따라 어떤 세션에서 로드될지가 결정됩니다. 홈 디렉터리에 저장하면 모든 프로젝트에서 로드되고, 저장소에 커밋하면 그곳에서 작업하는 모든 사람이 사용할 수 있으며, 플러그인이나 관리형 설정을 통해 배포하면 전체 팀이 접근할 수 있습니다.

| 위치 | 경로 | 로드되는 위치 |
| :- | :- | :- |
| Enterprise | [관리형 설정 디렉터리](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms)의 `.claude/skills/<skill-name>/SKILL.md` | 조직이 배포한 머신의 모든 사용자 |
| Personal | `~/.claude/skills/<skill-name>/SKILL.md` | 이 머신의 모든 프로젝트, 단 [Cowork 또는 클라우드 세션](#skills-in-cowork-and-cloud-sessions)은 제외 |
| Project | `.claude/skills/<skill-name>/SKILL.md` | 이 저장소의 세션, 단 [프로젝트의 클라우드 스레드](https://code.claude.com/docs/ko/claude-projects.md#what-threads-pick-up-from-your-repositories)는 제외. 커밋하면 팀도 사용할 수 있습니다 |
| Nested | `<subdir>/.claude/skills/<skill-name>/SKILL.md` | `<subdir>`에서 시작되거나 그 아래에서 시작된 세션, 단 프로젝트의 클라우드 스레드는 제외. 해당 스레드 외부에서는 `<subdir>` 위에서 시작된 세션이 Claude가 그곳의 파일에서 작업할 때 스킬을 로드합니다. [모노레포 및 하위 디렉터리](#discovery-from-parent-and-nested-directories) 참조 |
| Additional directory | `--add-dir`로 전달한 디렉터리의 `.claude/skills/<skill-name>/SKILL.md` | 해당 세션. [프로젝트 외부의 디렉터리](#skills-from-additional-directories) 참조 |
| Plugin | `<plugin>/skills/<skill-name>/SKILL.md` | [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)이 활성화된 모든 위치에서 `/plugin-name:skill-name`으로 |
| claude.ai account | claude.ai 계정에 대해 활성화된 스킬 | Cowork 세션, 클라우드 세션, 그리고 해당 계정으로 로그인한 터미널 세션. [claude.ai에서 동기화된 스킬](#how-synced-skills-behave) 참조 |

스킬 폴더는 또한 다음 규칙을 따릅니다:

* **심볼릭 링크된 폴더**: enterprise, personal 또는 project 위치의 `<skill-name>` 항목은 디스크의 다른 위치에 있는 디렉터리로의 심볼릭 링크일 수 있습니다. Claude Code는 대상에서 `SKILL.md`를 읽고 여러 위치가 같은 대상을 가리키더라도 스킬을 한 번만 로드합니다. 플러그인 스킬은 [심볼릭 링크를 다르게 처리합니다](https://code.claude.com/docs/ko/plugins/host-marketplace.md#share-files-within-a-marketplace-with-symlinks).
* **예약된 이름 `synced`**: 스킬 폴더 이름을 대소문자와 관계없이 `synced`로 지정하지 마세요. Claude Code는 `~/.claude/skills/synced/`를 [claude.ai에서 다운로드한 스킬](#where-synced-skills-load)에 사용하며 enterprise, personal 및 project 위치에서 해당 이름으로 작성한 스킬을 건너뜁니다.
* **예약된 이름 `anthropic-skills`**: 플러그인 외부에서 이름이 `anthropic-skills`이거나 `anthropic-skills:`로 시작하는 스킬 폴더 또는 명령 파일은 로드되지 않습니다. [동기화된 스킬용으로 예약된 이름](#names-reserved-for-synced-skills)을 참조하세요.
* **이름에 포함된 문자**: 플러그인 외부에서 스킬 폴더 이름에 폭이 없는 공백(zero-width space)이나 `<` 같은 문자가 있으면 해당 스킬 폴더는 로드되지 않습니다. [스킬 이름에 사용할 수 없는 문자](#characters-a-skill-name-cant-hold)를 참조하세요.
* **명령 파일**: `.claude/commands/`의 Markdown 파일은 이전 형식이며 여전히 작동합니다. `name` 및 `paths`를 제외한 동일한 [frontmatter](#frontmatter-reference)를 지원합니다. 호출하기 위해 입력하는 이름을 찾으려면 [스킬이 명령 이름을 얻는 방법](#how-a-skill-gets-its-command-name)을 참조하세요. 스킬은 [지원 파일](#add-supporting-files)도 지원하므로 새 작업에는 스킬을 선호합니다.
* **플러그인으로서의 스킬 폴더**: personal 또는 project 스킬 폴더에 `.claude-plugin/plugin.json`을 추가하면 Claude Code가 이를 자체 에이전트, 훅 및 MCP 서버를 갖춘 `<name>@skills-dir`이라는 이름의 [플러그인](https://code.claude.com/docs/ko/plugins/loading.md#plugins-shared-through-a-repository)으로 로드할 수 있습니다. 프로젝트의 `.claude/skills/`에서는 먼저 워크스페이스 신뢰 대화 상자를 수락해야 하며, 두 위치 모두에서 관리자가 [스킬 디렉터리 플러그인을 차단하지](https://code.claude.com/docs/ko/plugins/loading.md#skills-directory-plugins-blocked-by-managed-settings) 않았어야 합니다.

### 모노레포 및 하위 디렉터리에서 스킬 로드

Claude Code는 세션을 시작한 디렉터리와 저장소 루트까지의 모든 상위 디렉터리의 `.claude/skills/`에서 프로젝트 스킬을 로드하므로 `packages/frontend/`에서 시작해도 루트에 정의된 스킬을 선택합니다. v2.1.246 이상에서 [`/cd`로 세션을 이동](https://code.claude.com/docs/ko/permissions#move-the-session-to-another-directory)하면 Claude Code는 새 디렉터리의 프로젝트 스킬을 추가합니다.

`--worktree` 또는 `git worktree add`로 만든 연결된 [git worktree](https://code.claude.com/docs/ko/worktrees.md)에서 실행되는 세션에서 Claude Code는 worktree 루트까지만 상위 디렉터리를 검색합니다. Claude Code v2.1.277 이상에서는 worktree 체크아웃의 루트에 `.claude/skills` 디렉터리가 없으면 Claude Code가 대신 메인 체크아웃의 프로젝트 스킬을 로드합니다. [워크트리가 메인 체크아웃과 공유하는 항목](https://code.claude.com/docs/ko/worktrees.md#what-worktrees-share-with-the-main-checkout)을 참조하세요.

시작한 위치 아래의 `.claude/skills/` 디렉터리의 스킬은 시작 시 로드되지 않습니다. Claude가 해당 하위 디렉터리의 파일을 처음 읽거나 편집할 때 로드되며 세션의 나머지 기간 동안 사용 가능합니다. 그때까지는 `/` 메뉴에 나타나지 않으며 이름으로 호출할 수 없습니다. 더 빨리 로드하려면 하위 디렉터리의 경로와 함께 `/add-dir`을 실행하세요. 이는 Claude Code v2.1.257 이상이 필요합니다. 데스크톱 앱에서 시작하는 워크트리 세션의 경우 [워크트리가 메인 체크아웃과 공유하는 항목](https://code.claude.com/docs/ko/worktrees.md#what-worktrees-share-with-the-main-checkout)을 참조하세요.

중첩된 스킬의 디렉터리 이름이 다른 스킬의 이름과 일치할 때 둘 다 사용 가능합니다. 저장소 루트에 `deploy` 스킬이 있고 `apps/web/.claude/skills/`에 다른 스킬이 있는 경우:

* `/deploy`는 루트 스킬을 실행합니다. Claude Code는 또한 Claude를 위해 디렉터리 한정 변형을 나열하며, 작업 중인 파일이 있는 디렉터리의 스킬을 호출하도록 지시하므로 중첩된 스킬은 여전히 `apps/web/`의 작업에 적용됩니다.
* `/apps/web:deploy`는 중첩된 스킬을 독립적으로 실행합니다. 설명에 적용되는 디렉터리의 이름이 지정됩니다.

### 프로젝트 외부의 디렉터리에서 스킬 로드

`--add-dir` 또는 `/add-dir`으로 디렉터리를 추가하면 Claude Code는 해당 디렉터리의 `.claude/skills/`의 스킬과 `.claude/commands/` 및 `.claude/agents/`를 로드합니다. Agent SDK가 TypeScript의 [`additionalDirectories`](https://code.claude.com/docs/ko/agent-sdk/typescript#options) 또는 Python의 [`add_dirs`](https://code.claude.com/docs/ko/agent-sdk/python#claudeagentoptions)를 통해 추가하는 디렉터리는 SDK가 `--add-dir`으로 전달하기 때문에 동일한 방식으로 로드됩니다. `settings.json`의 `permissions.additionalDirectories` 설정은 파일 액세스만 부여하며 이 중 어느 것도 로드하지 않습니다.

Claude Code는 시작 시 `--add-dir`으로 전달한 디렉터리의 `.claude/skills/`를 [세션 중 스킬 편집](#live-change-detection)에서 설명하는 대로 감시합니다. 추가된 디렉터리의 `.claude/commands/` 또는 `.claude/agents/`는 감시하지 않으므로 파일을 변경한 후 세션을 다시 시작하세요.

이러한 로드는 기본적으로 켜져 있는 `project` [설정 소스](https://code.claude.com/docs/ko/agent-sdk/claude-code-features.md#control-filesystem-settings-with-settingsources)에 따라 달라집니다. [`strictPluginOnlyCustomization`](https://code.claude.com/docs/ko/settings-reference#strictpluginonlycustomization) 정책, [bare 모드](https://code.claude.com/docs/ko/headless.md#start-faster-with-bare-mode) 및 [`--safe-mode`](https://code.claude.com/docs/ko/cli-reference#cli-flags)는 각각 이를 더 제한하며, 이러한 페이지에서 설명합니다. 추가된 디렉터리가 로드하는 것의 전체 표(`CLAUDE.md` 및 플러그인 설정 포함)는 [추가 디렉터리는 파일 액세스를 부여하며 구성은 아님](https://code.claude.com/docs/ko/permissions.md#additional-directories-grant-file-access-not-configuration)을 참조하세요.

#### 추가된 디렉터리에서 같은 이름의 스킬 실행

추가된 디렉터리의 스킬은 폴더 이름이 enterprise, personal 또는 project 스킬, 또는 먼저 추가된 디렉터리의 스킬과 충돌할 때 접두사가 붙습니다. 실행하려면 Claude Code 프롬프트에서 `/<prefix>:<skill-name>`을 입력하세요. `/` 메뉴는 해당 스킬을 접두사가 붙은 이름으로 나열하며, [스킬이 명령 이름을 얻는 방법](#how-a-skill-gets-its-command-name)에서 접두사가 어디에서 오는지 설명합니다. 이 이름에는 Claude Code v2.1.309 이상이 필요합니다.

예를 들어 `--add-dir ../cli`를 사용하고 프로젝트와 `../cli` 모두에 `verify` 스킬이 있는 경우:

* `/verify`는 프로젝트의 스킬을 실행합니다
* `/cli:verify`는 `../cli`의 스킬을 실행합니다

### 이름이 같은 스킬 해결

두 스킬이 같은 디렉터리 이름이나 파일 이름을 공유할 때 각각이 어디에서 왔는지에 따라 `/name`이 실행하는 스킬이 결정됩니다. frontmatter `name` 필드로 설정된 이름의 경우 [스킬이 명령 이름을 얻는 방법](#how-a-skill-gets-its-command-name)을 참조하세요.

| 같은 이름 위치 | 실행되는 스킬 |
| :- | :- |
| Enterprise, personal 및 project 중 두 개 | Enterprise가 personal보다 우선하고 personal이 project보다 우선합니다. `~/.claude/skills/`와 프로젝트의 `.claude/skills/` 모두에 `deploy`가 있으면 `/deploy`는 personal 스킬을 실행합니다 |
| 해당 위치 중 하나와 [번들 스킬](#bundled-skills) | 사용자 스킬이 번들 명령을 대체하지만 별칭은 대체하지 않습니다. 프로젝트 `code-review` 스킬은 `/code-review`를 대체하고 번들 별칭 `/review`는 사용자 스킬을 실행하지 않습니다 |
| 해당 위치 중 하나와 [기본 제공 명령](https://code.claude.com/docs/ko/commands.md) | 로컬 터미널 세션에서는 사용자 스킬이 기본 제공 명령을 대체하지만 별칭은 대체하지 않습니다. 프로젝트 `usage` 스킬은 `/usage`를 대체하고 기본 제공 별칭 `/cost`는 여전히 기본 제공 명령을 실행합니다 |
| 스킬과 `.claude/commands/`의 파일 | 스킬 |
| 프로젝트 루트 스킬과 중첩된 스킬 | 둘 다 로드됩니다. [모노레포 및 하위 디렉터리](#discovery-from-parent-and-nested-directories) 참조 |
| Enterprise, personal 또는 project 스킬과 [프로젝트 외부의 추가된 디렉터리](#skills-from-additional-directories)의 스킬 | Enterprise, personal 또는 project 스킬이 실행되며, 추가된 디렉터리의 스킬은 접두사가 붙은 이름으로 실행됩니다. [추가된 디렉터리에서 같은 이름의 스킬 실행](#run-a-same-named-skill-from-an-added-directory) 참조 |
| 프로젝트 외부의 [추가된 디렉터리](#skills-from-additional-directories) 두 개 | `--add-dir` 또는 `/add-dir` 순서상 먼저 추가된 디렉터리의 스킬. 다른 스킬은 [접두사가 붙은 이름](#run-a-same-named-skill-from-an-added-directory)으로 실행됩니다 |
| 플러그인 스킬과 위의 위치 중 하나의 스킬 | 플러그인 스킬이 `/plugin-name:skill-name`으로 네임스페이스되기 때문에 둘 다 로드됩니다 |
| 위의 모든 것과 [claude.ai 계정에서 동기화된](#how-synced-skills-behave) 스킬의 짧은 이름 | 다른 스킬 또는 명령. 이 경우 동기화된 스킬은 전체 이름으로만 나열되고 실행됩니다. [동기화된 스킬 이름이 다른 명령과 일치할 때](#when-a-synced-skill-name-matches-another-command) 참조 |

### Cowork 및 클라우드 세션에서 스킬 사용

[Cowork](https://claude.com/product/cowork) 세션 및 [클라우드 세션](https://code.claude.com/docs/ko/cloud-environments.md#what-carries-over-from-your-setup)([클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md) 포함)은 머신의 `~/.claude/skills/`를 읽지 않습니다. 대화형 및 예약된 Cowork 세션 모두 claude.ai 계정에 대해 활성화된 스킬을 로드하며, 세션 시작 시 동기화됩니다. Desktop 앱 사이드바의 **Customize**에서 또는 claude.ai의 스킬 설정에서 관리합니다.

스킬이 머신의 `~/.claude/skills/`에만 존재하면 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)이 호출할 때 Claude Code는 스킬을 찾을 수 없다고 보고합니다. 각 실행이 새로운 클라우드 세션으로 시작되기 때문입니다. 이러한 세션에서 개인 스킬을 사용 가능하게 하려면:

* Cowork 세션, 클라우드 세션 및 [프로젝트](https://code.claude.com/docs/ko/claude-projects.md#what-threads-pick-up-from-your-repositories)의 클라우드 스레드의 경우 claude.ai 계정에 대해 스킬을 활성화합니다. 프로젝트의 클라우드 스레드에서는 저장소의 `.claude/skills/`에 커밋된 스킬을 사용할 수 없습니다. [자체 호스팅 환경의 일부 세션](https://code.claude.com/docs/ko/self-hosted-environments-configuration.md#how-each-session’s-config-is-assembled)은 계정의 스킬을 로드하지 않습니다.
* 프로젝트 스레드 외의 클라우드 세션의 경우 대신 저장소의 `.claude/skills/`에 스킬을 커밋할 수 있습니다. 저장소의 `.claude/settings.json`에 선언된 플러그인과 사용자 설정에서만 활성화된 플러그인은 [클라우드 세션에서 로드되지 않습니다](https://code.claude.com/docs/ko/cloud-environments.md#what-carries-over-from-your-setup).

[Desktop 예약 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md)은 머신에서 로컬로 실행되므로 `~/.claude/skills/`를 로드합니다.

### claude.ai에서 동기화된 스킬

이 섹션은 Cowork 또는 클라우드 세션을 사용하거나 claude.ai 계정으로 터미널에서 Claude Code에 로그인하는 경우에 적용됩니다. 이러한 세션에서 Claude Code는 [동기화된 스킬이 로드되는 위치](#where-synced-skills-load)에서 설명하는 대로 설정 없이 claude.ai 계정에 대해 활성화된 스킬을 로드합니다. 이러한 스킬에는 claude.ai 설정에서 만들거나 켠 스킬, 조직이 제공하는 스킬, 그리고 `pdf` 및 `xlsx`와 같은 Anthropic의 기본 제공 스킬이 포함됩니다.

Claude Code는 세션이 실행되는 머신에서 작성한 파일을 읽는 대신 계정에서 동기화된 스킬을 다운로드하므로 [스킬 위치](#where-skills-live)에 저장한 스킬에 적용되지 않는 규칙을 동기화된 스킬에 적용합니다.

#### 동기화된 스킬이 로드되는 위치

Cowork 또는 클라우드 세션에서 Claude Code는 claude.ai 계정에 대해 활성화된 스킬을 로드하며 [Cowork 및 클라우드 세션에서 스킬](#skills-in-cowork-and-cloud-sessions)은 해당 세션이 어떤 스킬을 얻는지 선택하는 방법을 설명합니다.

터미널에서 Claude Code는 claude.ai 계정으로 로그인한 세션에서 해당 스킬을 동기화합니다. 세션이 시작되면 Claude Code는 계정의 스킬을 백그라운드에서 `~/.claude/skills/synced/`로 다운로드한 다음 세션이 실행되는 동안 claude.ai에서 변경 사항을 확인합니다. 확인 결과 스킬이 claude.ai에서 추가, 편집 또는 비활성화되었음을 발견하면 Claude Code는 재시작 없이 실행 중인 세션에서 이를 추가, 업데이트 또는 제거합니다. 터미널 세션에서의 동기화에는 Claude Code v2.1.273 이상이 필요합니다.

세션이 유휴 상태인 동안에는 확인 빈도가 줄어듭니다:

* **사용자나 Claude가 세션에서 작업하는 동안**: 약 10분마다 확인합니다.
* **세션이 유휴 상태인 동안**: 약 40분마다 확인합니다. 세션에 다시 입력하면 마지막 확인이 10분 이상 전인 경우 Claude Code가 몇 분 이내에 확인합니다.

동기화는 스킬을 호출할 때만 스킬의 다운로드를 기다리기 때문에 시작을 지연시키지 않습니다. 짧은 [비대화형](https://code.claude.com/docs/ko/headless.md) 실행은 새로 추가된 스킬이 다운로드되기 전에 완료될 수 있으며, 이 경우 나중 세션이 이를 다운로드합니다. 비대화형 실행이 스킬을 다운로드하고 프롬프트에 답하기 전에 목록을 기다리도록 하려면 [`CLAUDE_CODE_SYNC_SKILLS`](https://code.claude.com/docs/ko/env-vars#variables)를 `1`로 설정하세요. v2.1.273 이전에는 터미널 세션이 이 변수를 설정한 `-p` 실행에서만 스킬을 다운로드했습니다.

Claude Code는 claude.ai 계정으로 로그인하고 [Anthropic에서 기능 플래그를 가져오는](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) 세션에서만 동기화합니다. 이러한 세션에서는 동기화하지 않습니다:

* `/login`으로 저장된 로그인을 사용하지 않는 세션(예: API 키로 인증하는 세션, 또는 `ANTHROPIC_AUTH_TOKEN`, `CLAUDE_CODE_OAUTH_TOKEN` 또는 `apiKeyHelper` 스크립트가 자격 증명을 제공하는 세션)
* 기능 플래그를 가져오지 않는 세션(예: Amazon Bedrock의 세션 또는 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`을 설정한 세션)
* [bare 모드](https://code.claude.com/docs/ko/headless.md#start-faster-with-bare-mode)의 세션 또는 `--safe-mode`로 시작한 세션
* 조직의 관리형 설정이 [스킬을 플러그인 소스로 잠그는](https://code.claude.com/docs/ko/settings-reference.md#strictpluginonlycustomization-skills) 세션, 또는 `user`를 제외하는 [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 목록으로 시작한 세션

세션 중에 `/login`으로 로그인하면 Claude Code를 다시 시작하여 동기화를 시작하세요.

이전 세션이 동기화한 스킬은 디스크에 남아 있습니다. Claude Code는 같은 계정으로 로그인한 나중 세션에서 claude.ai에 도달할 수 없을 때도 이를 로드합니다.

Claude Code는 동기화된 스킬을 다운로드만 하며 업로드하지 않습니다. 사용자나 Claude가 `~/.claude/skills/synced/` 아래의 파일을 편집하면 변경 사항은 claude.ai 계정에 저장되지 않으며, 이후 동기화에서 덮어쓰거나 제거될 수 있습니다. 동기화된 스킬을 변경하려면 claude.ai에서 업데이트하세요. 다음 동기화에서 새 버전을 다운로드합니다.

동기화된 스킬을 보려면 `/skills`를 실행하세요. 메뉴는 `claude.ai sync` 아래에 나열합니다.

`pdf` 및 `xlsx`와 같은 Anthropic의 일부 스킬은 항상 동기화됩니다. 나머지의 경우 claude.ai의 스킬 설정에서 스킬을 켜거나 꺼서 동기화 여부를 변경하세요.

머신에서 동기화를 중지하려면 사용자 설정에서 [`syncClaudeAiSkills`](https://code.claude.com/docs/ko/settings-reference#syncclaudeaiskills)를 `false`로 설정하세요. Claude Code는 다운로드를 중지하고 다음 번 시작 시 이미 동기화한 스킬을 `~/.claude/skills/.trash/`로 이동하고 더 이상 로드하지 않습니다. 조직은 claude.ai에서 스킬을 끔으로써 모든 사람에 대해 동기화를 끌 수 있습니다. 스킬을 켠 상태로 동기화를 중지하려면 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 동일한 키를 설정할 수 있습니다.

조직이 claude.ai에서 스킬을 끄면 Claude Code는 다운로드한 스킬을 제거하고 로드를 중지합니다. 제거된 스킬은 [보존 기간 정리](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)가 삭제할 때까지 복구할 수 있는 `~/.claude/skills/.trash/`로 이동합니다. 조직이 스킬을 다시 켜면 Claude Code는 다음 동기화 시 활성화한 스킬을 다운로드합니다.

#### 동기화된 스킬 이름이 다른 명령과 일치할 때

동기화된 스킬은 짧은 이름 `/<name>` 또는 전체 이름 `/anthropic-skills:<name>`으로 호출할 수 있습니다. 다른 명령이 해당 짧은 이름을 사용할 때 `/<name>`은 다른 명령을 실행하고 동기화된 스킬은 `/anthropic-skills:<name>`으로만 실행됩니다. 로컬 `deploy` 스킬과 동기화된 `deploy`가 있으면 `/deploy`는 로컬 스킬을 실행하고 `/anthropic-skills:deploy`는 동기화된 스킬을 실행합니다. v2.1.269 이전에는 동기화된 스킬이 짧은 이름만 가졌습니다.

`/` 메뉴, `/skills` 및 `/context`에서 동기화된 스킬은 짧은 이름으로 표시되며, 다른 명령이 짧은 이름을 사용하는 동안에는 전체 이름으로 표시됩니다. 세션에서 `/skills`를 실행하세요. 목록 아래의 안내에서 짧은 이름을 잃은 각 동기화된 스킬을 설명합니다. `~/.claude/`에 있는 personal 스킬이나 명령 파일 중 하나가 해당 이름을 사용하는 경우, 안내에는 이름을 되찾기 위해 무엇의 이름을 바꾸거나 삭제해야 하는지도 표시됩니다.

v2.1.269부터 v2.1.280까지는 이러한 목록에 모든 동기화된 스킬이 전체 이름으로 표시되었고 `/skills`에는 이러한 안내가 없었습니다. 두 가지 모두 v2.1.281에서 변경되었습니다.

짧은 이름을 사용하는 명령은 다음 중 하나일 수 있습니다:

* 기본 제공 명령 또는 [번들 스킬](#bundled-skills)(예: 번들 스킬을 끈 후처럼 세션에서 사용할 수 없는 경우 포함)
* 모든 [로컬 수준](#where-skills-live)의 스킬 또는 `.claude/commands/`의 파일
* 플러그인 스킬
* [MCP 프롬프트](https://code.claude.com/docs/ko/mcp.md#use-mcp-prompts-as-commands)

Claude Code는 동기화된 스킬에 레이블을 지정하므로 어디에서 왔는지 알 수 있습니다. `/skills` 메뉴와 `/context`는 동기화된 스킬을 `claude.ai sync` 아래에 그룹화하고 `/` 명령 메뉴는 claude.ai에서 온 것으로 표시합니다.

이름을 비교할 때 Claude Code는 대소문자, 공백 및 보이지 않는 문자를 무시하고 전자 문자 및 대시 변형과 같은 호환성 형식을 일반 등가물로 취급합니다. 예를 들어 `Commit`이라는 동기화된 스킬과 `commit`이라는 로컬 스킬은 같은 이름으로 간주되므로 `/commit`은 로컬 스킬을 계속 실행합니다.

다른 알파벳의 모양이 비슷한 문자로만 다른 이름은 다른 이름으로 간주되며 `claude.ai sync` 레이블은 두 개를 구분하는 방법입니다. 이러한 검사 및 레이블에는 Claude Code v2.1.228 이상이 필요합니다.

#### 동기화된 스킬용으로 예약된 이름

Claude Code는 `anthropic-skills`라는 이름과 `anthropic-skills:pdf`처럼 해당 네임스페이스 안의 모든 이름을 claude.ai에서 동기화된 스킬용으로 예약하므로, 동기화된 스킬의 전체 이름이 다른 것을 실행하는 일은 없습니다. 이 이름은 claude.ai 계정으로 로그인하는지 여부와 관계없이 모든 세션에서 예약됩니다.

* **스킬 폴더, frontmatter `name`, `.claude/commands/`의 파일 또는 하위 폴더, 또는 [저장된 워크플로](https://code.claude.com/docs/ko/workflows.md#save-the-workflow-for-reuse)**: 로드되지 않습니다. [시작 알림](https://code.claude.com/docs/ko/errors.md#a-skill-command-or-workflow-wasnt-loaded-because-its-name-is-reserved)에 이름을 바꾸거나 편집해야 할 첫 번째 항목이 표시됩니다.
* **`anthropic-skills`라는 이름의 플러그인**: 로드됩니다. 해당 플러그인의 스킬 중 하나와 동기화된 스킬의 이름이 모두 `<name>`인 경우 `/anthropic-skills:<name>`은 동기화된 스킬을 실행합니다.
* **`anthropic-skills`라는 이름의 MCP 서버**: 연결되고 도구도 작동하지만 [프롬프트가 명령으로 표시되지 않습니다](https://code.claude.com/docs/ko/mcp.md#use-mcp-prompts-as-commands). 프롬프트를 나열하려면 MCP 구성에서 서버 이름을 변경하세요.

#### Claude Code가 동기화된 스킬의 frontmatter를 처리하는 방법

Claude Code는 동기화된 스킬의 frontmatter에 두 가지 규칙을 적용합니다:

* frontmatter는 모든 종류의 세션에서 적용되므로 `allowed-tools` 부여는 일반 [권한 흐름](https://code.claude.com/docs/ko/permissions.md)을 거칩니다. 조직이 `allowManagedPermissionRulesOnly`를 설정한 경우 해당 부여는 [적용되지 않습니다](#when-only-managed-permission-rules-apply).
* Claude Code는 스킬이 제공하는 표시 텍스트(예: 설명)를 정제합니다. 제어 문자를 제거하고 Claude에 도달하는 텍스트(예: 설명)에서 꺾쇠 괄호를 이스케이프하여 텍스트가 Claude Code의 내부 형식을 모방할 수 없도록 합니다. 이 정제에는 Claude Code v2.1.228 이상이 필요합니다.

#### Claude Code가 동기화된 스킬의 본문을 처리하는 방법

Claude Code가 동기화된 스킬의 본문으로 수행하는 작업은 세션이 실행되는 위치에 따라 달라집니다:

* 클라우드 세션에서 본문은 로컬 스킬이 가지는 동작을 유지합니다. 세션이 격리된 컨테이너에서 실행되기 때문입니다.
* 데스크톱의 Cowork 세션에서 본문은 로컬 스킬이 가지는 동작을 유지합니다. 단, Claude Code는 그곳에서 제공하는 모든 스킬에 대해 하는 것처럼 모든 `!` 명령줄을 [`disableSkillShellExecution` 플레이스홀더](#inject-dynamic-context)로 바꿉니다.
* 머신의 다른 세션에서 Claude Code는 [`!` 명령](#inject-dynamic-context)을 실행하지 않으며, 로컬 스킬에서처럼 `@` 참조가 가리키는 파일을 첨부하지 않고, `${CLAUDE_PROJECT_DIR}` 및 `${CLAUDE_SESSION_ID}` 플레이스홀더를 대체하지 않으므로 `@` 참조와 두 플레이스홀더는 Claude에 리터럴 텍스트로 도달합니다. `!` 명령줄도 리터럴 텍스트로 도달하거나 `disableSkillShellExecution`이 켜져 있을 때 해당 플레이스홀더로 도달합니다. 이 처리에는 Claude Code v2.1.228 이상이 필요합니다.

### 세션 중 스킬 편집

Claude Code는 [bare 모드](https://code.claude.com/docs/ko/headless.md#start-faster-with-bare-mode)를 제외하고 스킬 디렉터리의 파일 변경을 감시합니다. `~/.claude/skills/`, 프로젝트 `.claude/skills/` 또는 `--add-dir` 디렉터리 내의 `.claude/skills/` 아래에서 스킬을 추가, 편집 또는 제거하면 Claude Code는 재시작 없이 현재 세션 내에서 변경 사항을 반영합니다.

세션이 시작될 때 존재하지 않았던 최상위 스킬 디렉터리를 만든 경우 [`/reload-skills`](https://code.claude.com/docs/ko/commands#all-commands)를 실행하여 그곳에 넣은 스킬을 가져오세요. Claude Code는 아직 해당 디렉터리를 감시하지 않으므로 이후 그곳에서 변경할 때마다 `/reload-skills`를 다시 실행하세요.

라이브 변경 감지는 `SKILL.md` 텍스트만 다룹니다. 스킬 폴더가 [플러그인](https://code.claude.com/docs/ko/plugins/loading.md#plugins-shared-through-a-repository)이기도 한 경우 `hooks/`, `.mcp.json`, `agents/` 및 `output-styles/`의 변경 사항을 적용하려면 `/reload-plugins`가 필요합니다.

### 스킬 제거

스킬을 제거하는 방법은 어디에서 왔는지에 따라 달라집니다:

* **Personal 또는 project 스킬**: 스킬의 디렉터리 `~/.claude/skills/<skill-name>/` 또는 `.claude/skills/<skill-name>/`을 삭제합니다. Claude Code는 [현재 세션의 `/skills`에서 삭제합니다](#live-change-detection). Claude Code가 이미 로드한 콘텐츠는 [스킬 콘텐츠 수명 주기](#skill-content-lifecycle)를 따릅니다.
* **Enterprise 스킬**: 관리자가 [관리형 설정 디렉터리](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms) 내의 `.claude/skills/`에서 스킬의 디렉터리를 삭제합니다. 예를 들어 Linux의 `/etc/claude-code/.claude/skills/<skill-name>/`.
* **Plugin 스킬**: `/plugin` 메뉴에서 또는 `/plugin uninstall <plugin-name>@<marketplace-name>`으로 스킬을 제공하는 플러그인을 비활성화하거나 제거합니다. Claude Code는 [변경이 적용될 때](https://code.claude.com/docs/ko/plugins/cli-reference.md#reload-plugins) 또는 재시작할 때 플러그인의 스킬을 언로드합니다.
* **claude.ai에서 동기화된 스킬**: [활성화한](#skills-in-cowork-and-cloud-sessions) 것과 같은 위치에서 claude.ai 계정에 대해 스킬을 끕니다. Claude Code는 다음 번에 [스킬을 동기화할 때](#where-synced-skills-load) `~/.claude/skills/synced/`에서 제거합니다. 대신 디렉터리를 직접 삭제하면 다음 동기화가 스킬이 claude.ai에서 활성화된 상태로 유지되는 동안 다시 다운로드합니다.
* **번들 스킬**: [`disableBundledSkills`](#bundled-skills)를 `true`로 설정하여 번들 스킬을 끄거나 [`skillOverrides`](#override-skill-visibility-from-settings)에서 하나의 스킬을 `"off"`로 설정하여 숨깁니다.

Personal 또는 project 스킬을 유지하지만 Claude가 자동으로 호출하지 않도록 하려면 frontmatter에서 [`disable-model-invocation: true`](#control-who-invokes-a-skill)를 설정하거나 파일을 편집하지 않으려면 [`skillOverrides`](#override-skill-visibility-from-settings)에서 `"user-invocable-only"`를 설정합니다.

## 스킬 구성

스킬은 `SKILL.md` 상단의 YAML frontmatter와 그 뒤에 오는 마크다운 콘텐츠를 통해 구성됩니다.

### 스킬 콘텐츠의 유형

스킬 파일은 모든 지침을 포함할 수 있지만, 스킬을 어떻게 호출하고 싶은지 생각하면 포함할 내용을 결정하는 데 도움이 됩니다.

**참고 콘텐츠**는 Claude가 현재 작업에 적용하는 지식을 추가합니다. 규칙, 패턴, 스타일 가이드, 도메인 지식입니다. 이 콘텐츠는 인라인으로 실행되므로 Claude가 대화 컨텍스트와 함께 사용할 수 있습니다.

```yaml theme={null}
---
name: api-conventions
description: API design patterns for this codebase
---

When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats
- Include request validation
```

**작업 콘텐츠**는 Claude에게 배포, 커밋 또는 코드 생성과 같은 특정 작업에 대한 단계별 지침을 제공합니다. 이러한 작업은 Claude가 실행 시기를 결정하도록 하기보다는 `/skill-name`으로 직접 호출하려는 작업인 경우가 많습니다. Claude가 자동으로 트리거하는 것을 방지하려면 `disable-model-invocation: true`를 추가합니다. 아래 예제는 `context: fork`를 추가하며, 이는 스킬을 자체 서브에이전트 컨텍스트에서 실행합니다. [서브에이전트에서 스킬 실행](#run-skills-in-a-subagent)을 참조하세요.

```yaml theme={null}
---
name: deploy
description: Deploy the application to production
context: fork
disable-model-invocation: true
---

Deploy the application:
1. Run the test suite
2. Build the application
3. Push to the deployment target
```

본문 자체는 간결하게 유지합니다. 스킬이 로드되면 해당 콘텐츠는 [여러 턴에 걸쳐 컨텍스트에 유지](#skill-content-lifecycle)되므로 모든 줄이 반복되는 토큰 비용입니다. 어떻게 또는 왜인지 설명하기보다는 무엇을 해야 하는지 명시하고, [CLAUDE.md 콘텐츠](https://code.claude.com/docs/ko/best-practices.md#keep-claude-md-short)에 적용할 동일한 간결성 테스트를 적용합니다.

### frontmatter 참고

`SKILL.md` 상단의 `---` 마커 사이에 있는 YAML [frontmatter](https://code.claude.com/docs/ko/glossary.md#frontmatter)로 스킬을 구성하고, 닫는 `---` 뒤에 스킬의 지침을 Markdown으로 작성합니다. 필드 이름은 `when_to_use`를 제외하고 하이픈으로 구분된 소문자 단어를 사용합니다. `.claude/commands/`의 [명령 파일](#where-skills-live)은 `name` 및 `paths`를 제외한 동일한 필드를 허용합니다. 이 예제는 네 개의 필드를 설정합니다.

```yaml theme={null}
---
name: my-skill
description: What this skill does
disable-model-invocation: true
allowed-tools: Read Grep
---

Your skill instructions here...
```

모든 필드는 선택 사항입니다. Claude가 스킬을 언제 사용할지 알 수 있도록 `description`만 권장됩니다. 필드 이름은 하이픈을 포함하여 표와 정확히 일치해야 합니다. Claude Code는 인식하지 못하는 필드를 오류를 보고하지 않고 무시합니다. 부울 필드는 `true` 및 `false` 외에도 모든 문자 케이스에서 `yes`, `no`, `on`, `off`, `1`, `0`을 허용합니다.

Claude Code는 파일의 첫 번째 줄이 `---`일 때만 frontmatter를 읽습니다. 그렇지 않으면 `---` 마커를 포함한 전체 파일을 스킬 콘텐츠로 취급합니다. 마커 사이의 YAML을 파싱할 수 없는 경우에도 스킬은 필드가 설정되지 않은 상태로 로드됩니다. 오류를 찾아 수정하려면 [스킬이 트리거되지 않음](#skill-not-triggering)을 참조하세요.

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `name` | 아니요 | `/` 메뉴에 표시되는 명령 이름입니다. 기본값은 디렉터리 이름입니다. [스킬이 명령 이름을 얻는 방법](#how-a-skill-gets-its-command-name)을 참조하여 필드가 스킬을 호출하기 위해 입력하는 이름과 어떻게 상호 작용하는지 확인하세요. |
| `description` | 권장 | 스킬이 무엇을 하는지, 언제 사용할지입니다. Claude는 이를 사용하여 스킬을 적용할 시기를 결정합니다. 생략하면 마크다운 콘텐츠의 첫 번째 비어 있지 않은 줄을 사용합니다. 주요 사용 사례를 먼저 입력하세요. 결합된 `description` 및 `when_to_use` 텍스트는 컨텍스트 사용을 줄이기 위해 스킬 목록에서 1,536자로 잘립니다. 텍스트의 꺾쇠괄호는 [`&lt;` 및 `&gt;`로 표시됩니다](#angle-brackets-in-a-skill-description). |
| `when_to_use` | 아니요 | Claude가 스킬을 호출해야 할 때에 대한 추가 컨텍스트입니다. 예를 들어 트리거 구문이나 예제 요청입니다. 스킬 목록의 `description`에 추가되며 1,536자 제한에 포함됩니다. |
| `argument-hint` | 아니요 | 자동 완성 중에 표시되는 힌트로 예상 인수를 나타냅니다. 예: `[issue-number]` 또는 `[filename] [format]`. |
| `arguments` | 아니요 | 스킬 콘텐츠에서 [`$name` 치환](#available-string-substitutions)을 위한 명명된 위치 인수입니다. 공백으로 구분된 문자열 또는 YAML 목록을 허용합니다. 이름은 순서대로 인수 위치에 매핑됩니다. |
| `disable-model-invocation` | 아니요 | Claude가 이 스킬을 자동으로 로드하는 것을 방지하려면 `true`로 설정합니다. `/name`으로 수동으로 트리거하려는 워크플로에 사용합니다. 또한 스킬이 [서브에이전트에 사전 로드되는 것](https://code.claude.com/docs/ko/sub-agents.md#preload-skills-into-subagents)과 스킬을 프롬프트로 하는 [세션 범위 예약 작업](https://code.claude.com/docs/ko/scheduled-tasks.md)이 실행될 때 스킬이 실행되는 것을 방지합니다. 기본값: `false`. |
| `user-invocable` | 아니요 | Claude만 스킬을 호출해야 할 때 `false`로 설정합니다. Claude Code는 `/` 메뉴에서 숨기고 `/name`을 입력할 때 실행하지 않습니다. 사용자가 직접 호출하지 않아야 하는 배경 지식에 사용합니다. 기본값: `true`. |
| `allowed-tools` | 아니요 | 이 스킬을 호출하는 턴 중에 Claude가 권한을 요청하지 않고 사용할 수 있는 도구입니다. 다음 메시지를 보낼 때 권한이 해제됩니다. 공백 또는 쉼표로 구분된 문자열 또는 YAML 목록을 허용합니다. [스킬에 대한 도구 사전 승인](#pre-approve-tools-for-a-skill)을 참조하세요. |
| `disallowed-tools` | 아니요 | 이 스킬이 활성화되는 동안 Claude의 사용 가능한 도구 풀에서 제거되는 도구입니다. 백그라운드 루프에서의 `AskUserQuestion`처럼 특정 도구를 호출하지 않아야 하는 자율 스킬에 사용합니다. 공백 또는 쉼표로 구분된 문자열 또는 YAML 목록을 허용합니다. 다음 메시지를 보낼 때 제한이 해제됩니다. 거부 규칙과 마찬가지로 다른 도구가 남아 있는 동안 이 필드는 [`EndConversation`](https://code.claude.com/docs/ko/tools-reference#endconversation-tool-behavior)을 제거할 수 없습니다. |
| `model` | 아니요 | 이 스킬이 활성화될 때 사용할 모델입니다. 재정의는 현재 턴의 나머지 부분에 적용되며 설정에 저장되지 않습니다. 다음 프롬프트를 보낼 때 세션 모델이 재개됩니다. [`/model`](https://code.claude.com/docs/ko/model-config)과 동일한 값을 허용하거나 활성 모델을 유지하려면 `inherit`을 허용합니다. 조직의 [`availableModels`](https://code.claude.com/docs/ko/model-config#restrict-model-selection) 허용 목록에서 제외된 값은 사용되지 않으며 세션은 현재 모델을 유지합니다. [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서, 그리고 [분류기가 명령을 검토하는 동안 플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에서 자동 모드가 지원하지 않는 모델도 사용되지 않으며 세션은 현재 모델을 유지합니다. `context: fork`를 사용하면 값이 [포크된 서브에이전트의 모델](#run-skills-in-a-subagent)을 설정하고 제외된 값은 [서브에이전트 모델 재정의와 동일한 규칙을 따릅니다](https://code.claude.com/docs/ko/model-config.md#restrict-model-selection). |
| `effort` | 아니요 | 현재 턴의 나머지 부분에 적용되는 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)입니다. 세션 effort 수준을 재정의하지만 [`CLAUDE_CODE_EFFORT_LEVEL`](https://code.claude.com/docs/ko/env-vars#variables) 환경 변수는 재정의하지 않습니다. `context: fork`를 사용하면 값이 대신 포크된 서브에이전트의 effort 수준을 설정합니다. 생략하면 [effort 결정 순서](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)에 따라 수준이 정해집니다. 옵션: `low`, `medium`, `high`, `xhigh`, `max`. 사용 가능한 수준은 모델에 따라 다릅니다. |
| `context` | 아니요 | 포크된 서브에이전트 컨텍스트에서 실행하려면 `fork`로 설정합니다. [서브에이전트에서 스킬 실행](#run-skills-in-a-subagent)을 참조하세요. |
| `agent` | 아니요 | `context: fork`가 설정되었을 때 사용할 서브에이전트 유형입니다. |
| `background` | 아니요 | `context: fork`에만 적용됩니다. [백그라운드에서 실행](#run-skills-in-a-subagent)하는 대신 스킬을 호출한 턴에서 포크된 서브에이전트의 결과를 기다리려면 `false`로 설정합니다. 기본값: `true`. |
| `hooks` | 아니요 | Claude Code가 스킬을 호출할 때 등록하고 세션의 나머지 부분 동안 계속 실행되는 훅입니다. 구성 형식, `once` 옵션 및 [스킬 훅의 제한 사항](https://code.claude.com/docs/ko/hooks.md#limits-on-skill-hooks)은 [스킬 및 에이전트의 훅](https://code.claude.com/docs/ko/hooks.md#hooks-in-skills-and-agents)을 참조하세요. |
| `paths` | 아니요 | 이 스킬이 활성화되는 시기를 제한하는 Glob 패턴입니다. 쉼표로 구분된 문자열 또는 YAML 목록을 허용합니다. 설정되면 Claude는 패턴과 일치하는 파일로 작업할 때만 스킬을 자동으로 로드합니다. 패턴은 Claude의 현재 작업 디렉터리를 기준으로 하며, 해당 디렉터리 외부의 파일은 일치하지 않습니다. [경로별 규칙](https://code.claude.com/docs/ko/memory.md#path-specific-rules)과 동일한 glob 형식을 사용합니다. |
| `shell` | 아니요 | 이 스킬에서 `` !`command` `` 및 ` ```! ` 블록에 사용할 셸입니다. `bash`(기본값) 또는 `powershell`을 허용합니다. `powershell`을 설정하면 [PowerShell 도구](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool)가 활성화되었을 때 PowerShell을 통해 인라인 셸 명령을 실행합니다. Git Bash가 없는 Windows에서는 기본적으로 켜져 있고, Git Bash가 있는 claude.ai 및 Console 계정에서는 기본적으로 켜져 있으며, Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 세션 및 macOS, Linux, WSL에서는 `CLAUDE_CODE_USE_POWERSHELL_TOOL=1`이 필요합니다. 도구를 끄려면 `0`으로 설정합니다. |
| `metadata` | 아니요 | 자격 또는 카탈로그 필드와 같은 자신의 키-값 데이터를 위한 자유 형식 YAML 맵으로, `SKILL.md`에서 자신의 도구로 읽습니다. Claude Code는 해당 콘텐츠에 대해 작동하지 않으며 맵이 아닌 값을 삭제합니다. `paths`와 같은 frontmatter 필드 이름을 키로 재사용하지 마세요. |
| `license` | 아니요 | 스킬을 다루는 라이선스입니다. [Agent Skills](https://agentskills.io) 사양의 일부입니다. [Claude Code 외부에서 스킬 frontmatter 사용](#using-skill-frontmatter-outside-claude-code)을 참조하세요. Claude Code는 필드를 허용하지만 작동하지 않습니다. |
| `compatibility` | 아니요 | [Agent Skills](https://agentskills.io) 사양에서 정의한 대로 의도된 제품 또는 시스템 사전 요구 사항과 같은 스킬의 환경 요구 사항입니다. [Claude Code 외부에서 스킬 frontmatter 사용](#using-skill-frontmatter-outside-claude-code)을 참조하세요. 최대 500자의 문자열을 허용합니다. Claude Code는 필드를 허용하지만 작동하지 않습니다. |

#### Claude Code 외부에서 스킬 frontmatter 사용

Claude Code는 위 표의 모든 필드를 허용합니다. Claude Code 외부에서는 [Agent Skills](https://agentskills.io) 사양의 필드만 사용할 수 있습니다.

| 배포 경로 | 사용할 수 있는 frontmatter 필드 |
| :- | :- |
| [모든 수준](#where-skills-live)의 Claude Code 스킬([플러그인](https://code.claude.com/docs/ko/plugins/overview.md) 스킬 포함) | 위 표의 모든 필드 |
| claude.ai 스킬 업로드, Skills API, [anthropics/skills](https://github.com/anthropics/skills)의 `package_skill.py`로 패키징 | `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools` |

예를 들어 [Cowork 및 클라우드 세션](#skills-in-cowork-and-cloud-sessions)과 예약 작업에서 사용하기 위해 claude.ai 계정에 개인 스킬을 활성화하면 스킬을 claude.ai에 업로드하게 됩니다. 해당 업로드에도 동일한 규칙이 적용됩니다.

사양이 허용하지 않는 필드를 포함하면 필드를 무시하는 대신 하드 오류로 패키징 또는 업로드가 실패합니다.

```
Unexpected key(s) in SKILL.md frontmatter: argument-hint. Allowed properties are: allowed-tools, compatibility, description, license, metadata, name
```

frontmatter를 사양의 6개 필드로 제한하면 위의 예상치 못한 키 오류를 피할 수 있습니다. [Agent Skills 사양](https://agentskills.io) 및 [Skills API 요구 사항](https://docs.claude.com/en/api/skills-guide)은 이러한 경로가 검증하는 다른 모든 것을 정의합니다. Claude Code 전용 본문 기능(예: [동적 컨텍스트 주입](#inject-dynamic-context))은 claude.ai 채팅 또는 API를 통해 작동하지 않습니다. Claude Code는 6개 필드를 모두 허용하므로 사양을 따르는 frontmatter는 변경 없이 Claude Code에 로드됩니다.

#### 스킬이 명령 이름을 얻는 방법

스킬을 호출하기 위해 입력하는 명령은 스킬 파일이 있는 위치에서 나오며, 스킬 디렉터리와 플러그인 스킬의 경우 frontmatter `name` 필드에서도 나옵니다. 개인 또는 프로젝트 스킬 디렉터리에서 `name`은 다른 명령이 이미 해당 이름을 사용하지 않는 한 `/` 메뉴에 표시되고 입력하는 명령을 설정합니다. 디렉터리 이름으로도 스킬을 호출할 수 있습니다. 플러그인 스킬에서 `name`은 명령의 마지막 세그먼트를 설정하고 플러그인 접두사는 제자리에 유지됩니다.

아래 표는 각 레이아웃에 대해 명령 이름이 어디에서 나오는지 보여줍니다.

| 스킬 위치 | 명령 이름 소스 | 예제 |
| :- | :- | :- |
| `~/.claude/skills/` 또는 `.claude/skills/` 아래의 스킬 디렉터리 | frontmatter `name` 또는 디렉터리 이름 | `.claude/skills/deploy-staging/SKILL.md` → `/deploy-staging`, 또는 `name: deploy`를 사용하면 `/deploy` |
| [중첩된](#where-skills-live) `.claude/skills/` 디렉터리(디렉터리 이름이 다른 스킬과 충돌할 때) | 작업 디렉터리를 기준으로 한 서브디렉터리 경로, 그 다음 스킬 디렉터리 이름 | `apps/web/.claude/skills/deploy/SKILL.md` → `/apps/web:deploy` |
| [프로젝트 외부에 추가된 디렉터리](#skills-from-additional-directories)의 `.claude/skills/`(스킬 디렉터리 이름이 엔터프라이즈, 개인 또는 프로젝트 스킬이나 먼저 추가된 디렉터리의 스킬과 충돌할 때) | 추가된 디렉터리의 폴더 이름, 그 다음 스킬 디렉터리 이름. 두 추가된 디렉터리의 폴더 이름이 같으면 접두사는 상위 폴더의 이름으로 시작합니다. v2.1.309 이상이 필요합니다 | `--add-dir ../cli`를 사용하면 `../cli/.claude/skills/verify/SKILL.md` → `/cli:verify`. `--add-dir ../a/cli --add-dir ../b/cli`를 사용하고 각 디렉터리에 `verify` 스킬이 있으며 다른 곳에는 없으면 `../a/cli`의 스킬 → `/verify`, 다른 스킬 → `/b/cli:verify` |
| `.claude/commands/` 아래의 파일 | 확장자 없는 파일 이름 | `.claude/commands/deploy.md` → `/deploy` |
| `.claude/commands/`의 서브디렉터리 아래의 파일 | `commands/`를 기준으로 한 서브디렉터리 경로(각 `/`를 `:`로 대체), 그 다음 확장자 없는 파일 이름 | `.claude/commands/frontend/component.md` → `/frontend:component` |
| 플러그인 `skills/` 서브디렉터리 | frontmatter `name` 또는 디렉터리 이름(플러그인으로 네임스페이스됨) | `my-plugin/skills/review/SKILL.md` → `/my-plugin:review`, 또는 `name: fancy`를 사용하면 `/my-plugin:fancy` |
| 플러그인 루트 `SKILL.md` | frontmatter `name`(플러그인 디렉터리 이름이 폴백) | `my-plugin/SKILL.md`에서 `name: review` → `/my-plugin:review`. [플러그인 루트의 단일 스킬](https://code.claude.com/docs/ko/plugins/components.md#skills)을 참조하세요. |
| [claude.ai에서 동기화된](#how-synced-skills-behave) 스킬 | claude.ai 계정의 스킬 이름(접두사 `anthropic-skills:`) | 계정 스킬 `deploy` → `/anthropic-skills:deploy`, 또는 다른 명령이 해당 이름을 사용하지 않으면 `/deploy` |

플러그인 스킬에서 frontmatter `name`은 명령의 마지막 세그먼트에서 디렉터리 이름을 대체하므로 `my-plugin/skills/review/SKILL.md`에서 `name: fancy`는 `/my-plugin:fancy`가 됩니다. 다른 명령이 이미 해당 이름을 사용하지 않으면 `/fancy`도 스킬을 호출합니다. 작성한 `name`이 이미 플러그인 자체의 접두사로 시작하면 v2.1.246 이상에서 Claude Code는 접두사를 다시 추가하지 않습니다. 예를 들어 `name: my-plugin:fancy`는 여전히 `/my-plugin:fancy`가 됩니다. v2.1.216부터 v2.1.245까지 Claude Code는 `name`이 이미 접두사를 가지고 있을 때 접두사를 두 번 붙였습니다.

[비대화형 세션](https://code.claude.com/docs/ko/headless.md)에서 `help` 및 `feedback` 이름은 터미널 전용 기본 제공 명령에 대해 예약되지 않으므로 이러한 이름을 가진 플러그인 스킬은 해당 세션에서 접두사 없는 명령을 유지합니다. `/login`과 같은 다른 모든 터미널 전용 기본 제공 명령의 이름은 해당 명령이 이러한 세션에서 실행될 수 없더라도 예약된 상태로 유지됩니다.

플러그인 루트 `SKILL.md`의 경우 이름을 가져올 스킬 디렉터리가 없으므로 `name`이 전체 마지막 세그먼트를 제공합니다. `name` 필드가 없으면 Claude Code는 플러그인의 디렉터리 이름으로 폴백합니다.

#### 스킬 이름에 사용할 수 없는 문자

스킬 또는 사용자 지정 명령이 `/` 메뉴에 없거나 메뉴에 스킬의 frontmatter `name`이 표시되지 않으면 이름을 확인하세요. Claude Code는 다음과 같은 문자가 포함된 명령 이름 또는 frontmatter `name`을 거부합니다.

* 폭 없는 공백(zero-width space) 또는 제어 문자
* 아이콘 폰트의 글리프와 같은 사용자 정의 영역(private-use) 문자 또는 할당되지 않은 문자
* 주변 텍스트의 방향을 바꾸는 문자
* 단어 사이의 일반 공백 하나 이외의 공백(예: 줄 바꿈 없는 공백, 연속된 두 개의 공백, 시작 또는 끝의 공백)
* `<` 또는 `>`

Claude Code가 디렉터리 또는 파일 이름을 거부하면 사용자 지정 명령 또는 스킬이 로드되지 않습니다. 해당 폴더 또는 파일의 이름을 변경하여 이러한 문자를 제거하세요. 이러한 문자가 플러그인 스킬 폴더의 이름이나 frontmatter `name`에만 있는 경우에는 스킬이 계속 로드됩니다.

* **플러그인의 `skills/` 디렉터리 또는 매니페스트의 [`skills` 경로](https://code.claude.com/docs/ko/plugins/components#skills)에 있는 폴더**: 폴더 이름을 변경할 필요가 없습니다. 이러한 문자는 스킬의 명령 이름에서 하이픈이 되므로 하이픈을 넣어 명령을 입력합니다.
* **frontmatter `name`**: `/` 메뉴에 `name` 값이 표시되지 않으며 이를 입력해도 스킬이 호출되지 않습니다. `name:` 줄을 편집하여 이러한 문자를 제거합니다.

Claude Code가 어떤 이름을 거부했는지 확인하려면 셸에서 [`claude --debug`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 시작하고 [디버그 로그](https://code.claude.com/docs/ko/debug-your-config.md)에서 `[names]`를 검색합니다. 대화형 세션에서는 [시작 알림](https://code.claude.com/docs/ko/errors.md#skill-or-command-name-refused)도 이름이 거부되었음을 알려줍니다. 이름을 변경하거나 `name:` 줄을 편집한 후에는 세션을 다시 시작합니다. 단, 파일이 Claude Code가 [변경 사항을 감시하는](#live-change-detection) 디렉터리에 있는 경우는 예외입니다.

#### 사용 가능한 문자열 치환

스킬은 스킬 콘텐츠의 동적 값에 대한 문자열 치환을 지원합니다.

| 변수 | 설명 |
| :- | :- |
| `$ARGUMENTS` | 스킬을 호출할 때 전달된 모든 인수입니다. 플레이스홀더가 인수를 받지 않으면 Claude Code는 인수를 `ARGUMENTS: <value>`로 추가합니다. [스킬에 인수 전달](#pass-arguments-to-skills)을 참조하세요. |
| `$ARGUMENTS[N]` | `$ARGUMENTS[0]`(첫 번째 인수)과 같이 0 기반 인덱스로 특정 인수에 액세스합니다. |
| `$N` | `$0`(첫 번째 인수) 또는 `$1`(두 번째 인수)과 같이 `$ARGUMENTS[N]`의 약자입니다. |
| `$name` | [`arguments`](#frontmatter-reference) frontmatter 목록에 선언된 명명된 인수입니다. 이름은 순서대로 위치에 매핑되므로 `arguments: [issue, branch]`를 사용하면 플레이스홀더 `$issue`는 첫 번째 인수로 확장되고 `$branch`는 두 번째 인수로 확장됩니다. |
| `${CLAUDE_SESSION_ID}` | 현재 세션 ID입니다. 로깅, 세션별 파일 생성 또는 스킬 출력을 세션과 연관시키는 데 유용합니다. |
| `${CLAUDE_EFFORT}` | 현재 effort 수준: `low`, `medium`, `high`, `xhigh`, 또는 `max`. 이를 사용하여 활성 effort 설정에 스킬 지침을 조정합니다. |
| `${CLAUDE_SKILL_DIR}` | 스킬의 `SKILL.md` 파일을 포함하는 디렉터리입니다. 플러그인 스킬의 경우 플러그인 루트가 아닌 플러그인 내 스킬의 서브디렉터리입니다. 현재 작업 디렉터리와 관계없이 스킬과 함께 번들된 스크립트 또는 파일을 참조하려면 bash 주입 명령에서 사용합니다. |
| `${CLAUDE_PROJECT_DIR}` | 프로젝트 루트 디렉터리입니다. 이는 [훅](https://code.claude.com/docs/ko/hooks.md#reference-scripts-by-path) 및 MCP 서버가 `CLAUDE_PROJECT_DIR`로 받는 동일한 경로입니다. 스킬이 설치된 위치와 관계없이 프로젝트 로컬 스크립트 또는 파일(예: `${CLAUDE_PROJECT_DIR}/.claude/hooks/helper.sh`)을 참조하려면 사용합니다. |
| `${CLAUDE_PLUGIN_ROOT}` | 플러그인의 설치 디렉터리입니다. 플러그인 스킬에서만 치환됩니다. 플러그인의 스킬 간에 공유되는 리소스를 포함하여 플러그인의 어디에나 번들된 스크립트 또는 파일을 참조하려면 사용합니다. [플러그인 환경 변수](https://code.claude.com/docs/ko/plugins/manifest-reference.md#environment-variables)를 참조하세요. |
| `${CLAUDE_PLUGIN_DATA}` | 플러그인의 [지속적인 데이터 디렉터리](https://code.claude.com/docs/ko/plugins/components.md#path-variables-and-persistent-data)로, 플러그인 업데이트 후에도 유지됩니다. 플러그인 스킬에서만 치환됩니다. 설치된 의존성, 생성된 파일 또는 업데이트 이후에도 유지되어야 하는 캐시를 참조하려면 사용합니다. |

Claude Code는 `${CLAUDE_SKILL_DIR}` 및 `${CLAUDE_PROJECT_DIR}`을 두 위치에서 치환합니다. 스킬의 마크다운 콘텐츠 및 [`allowed-tools`](#frontmatter-reference) frontmatter의 Bash 규칙입니다. 플러그인 스킬에서 Claude Code는 `${CLAUDE_PLUGIN_ROOT}` 및 `${CLAUDE_PLUGIN_DATA}`를 동일한 두 위치에서 치환합니다. 두 위치에서 동일한 변수를 사용하면 스킬이 권한 프롬프트 없이 번들된 스크립트를 실행할 수 있습니다. 다음 스킬은 패턴을 보여줍니다.

```yaml theme={null}
---
name: render-chart
description: Render a chart from a CSV file
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/render.sh *)
---

Run `${CLAUDE_SKILL_DIR}/scripts/render.sh <csv-file>` to render the chart.
```

이 스킬이 `~/.claude/skills/render-chart/`에 설치되면 `${CLAUDE_SKILL_DIR}`의 두 발생 모두 해당 디렉터리로 확장됩니다. `allowed-tools` 규칙은 스킬 본문이 Claude에게 실행하도록 지시하는 정확한 명령과 일치하므로 스크립트는 확인 요청 없이 실행됩니다.

인덱싱된 인수는 셸 스타일 인용을 사용하므로 다중 단어 값을 따옴표로 감싸서 단일 인수로 전달합니다. 예를 들어 `/my-skill "hello world" second`는 `$0`을 `hello world`로 확장하고 `$1`을 `second`로 확장합니다. `$ARGUMENTS` 플레이스홀더는 항상 입력한 대로 전체 인수 문자열로 확장됩니다.

해당 인수가 없는 인덱싱된 플레이스홀더(예: 하나의 인수만 전달되었을 때 `$2`)는 콘텐츠에서 변경되지 않은 상태로 유지됩니다. [`arguments`](#frontmatter-reference) frontmatter의 일치하는 인수가 없는 명명된 플레이스홀더는 빈 문자열로 확장됩니다.

`$1` 또는 `$ARGUMENTS`와 같은 텍스트를 포함하는 인수 값을 전달하면 Claude Code는 이를 리터럴 텍스트로 삽입하고 확장하지 않습니다. 예를 들어 스킬의 본문에 `Summarize $0`이 포함되어 있고 `/summarize "$ARGUMENTS from yesterday"`를 실행하면 Claude는 `Summarize $ARGUMENTS from yesterday`를 받습니다. Claude Code는 여전히 인수를 삽입한 후 `${CLAUDE_SKILL_DIR}`과 같은 `${CLAUDE_*}` 변수를 대체합니다.

산문에서 `$1.00`과 같이 숫자, `ARGUMENTS` 또는 선언된 인수 이름 앞에 리터럴 `$`를 포함하려면 백슬래시로 이스케이프합니다. `\$1.00`. 다른 `$` 앞의 백슬래시는 변경되지 않은 상태로 유지됩니다. 토큰 바로 앞의 단일 백슬래시만 이스케이프합니다. `\\$1`과 같은 이중 백슬래시는 두 백슬래시를 제자리에 두고 `$1`은 여전히 인수 값으로 확장됩니다. 백슬래시 이스케이프는 이러한 인수 플레이스홀더만 다룹니다. 백슬래시는 변수가 적용되는 `${CLAUDE_*}` 변수의 치환을 방지하지 않습니다.

**치환을 사용한 예제:**

```yaml theme={null}
---
name: session-logger
description: Log activity for this session
---

Log the following to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS
```

### 지원 파일 추가

스킬은 디렉터리에 여러 파일을 포함할 수 있습니다. 이렇게 하면 `SKILL.md`가 필수 사항에 집중하면서 Claude가 필요할 때만 상세 참고 자료에 액세스할 수 있습니다. 큰 참고 문서, API 사양 또는 예제 컬렉션은 스킬이 실행될 때마다 컨텍스트에 로드될 필요가 없습니다.

```text theme={null}
my-skill/
├── SKILL.md (required - overview and navigation)
├── reference.md (detailed API docs - loaded when needed)
├── examples.md (usage examples - loaded when needed)
└── scripts/
    └── helper.py (utility script - executed, not loaded)
```

`SKILL.md`에서 지원 파일을 참조하여 Claude가 각 파일의 내용과 로드 시기를 알 수 있도록 합니다.

```markdown theme={null}
## Additional resources

- For complete API details, see [reference.md](reference.md)
- For usage examples, see [examples.md](examples.md)
```

> [!TIP]
>
> `SKILL.md`를 500줄 이하로 유지합니다. 상세 참고 자료를 별도 파일로 이동합니다.

### 스킬을 호출할 수 있는 사람 제어

기본적으로 사용자와 Claude 모두 모든 스킬을 호출할 수 있습니다. `/skill-name`을 입력하여 직접 호출할 수 있고 Claude는 대화와 관련이 있을 때 자동으로 로드할 수 있습니다. 두 개의 frontmatter 필드를 사용하여 이를 제한할 수 있습니다.

* **`disable-model-invocation: true`**: Claude가 자체적으로 스킬을 호출할 수 없습니다. `/commit`, `/deploy` 또는 `/send-slack-message`와 같이 부작용이 있거나 타이밍을 제어하려는 워크플로에 사용합니다. 코드가 준비된 것처럼 보인다는 이유로 Claude가 배포를 결정해서는 안 됩니다.

* **`user-invocable: false`**: Claude만 스킬을 호출할 수 있습니다. 명령으로 실행할 수 없는 배경 지식에 사용합니다. `legacy-system-context` 스킬은 이전 시스템이 어떻게 작동하는지 설명합니다. Claude는 관련이 있을 때 이를 알아야 하지만 `/legacy-system-context`는 사용자가 취할 의미 있는 작업이 아닙니다.

이 예제는 배포 스킬을 만듭니다. `disable-model-invocation: true`를 설정하면 Claude는 스킬을 자동으로 실행할 수 없습니다.

```yaml theme={null}
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
---

Deploy $ARGUMENTS to production:

1. Run the test suite
2. Build the application
3. Push to the deployment target
4. Verify the deployment succeeded
```

Claude가 그래도 시도하면 Claude Code는 호출을 차단하고 배포 단계를 다른 방식으로 재현하지 않도록 지시하므로, Claude는 사용자가 `/deploy`를 직접 실행하도록 제안할 것입니다.

두 필드가 호출 및 컨텍스트 로딩에 어떻게 영향을 미치는지는 다음과 같습니다.

| frontmatter | 사용자가 호출할 수 있음 | Claude가 호출할 수 있음 | 컨텍스트에 로드되는 시기 |
| :- | :- | :- | :- |
| (기본값) | 예 | 예 | 설명은 항상 컨텍스트에 있고, 호출될 때 전체 스킬이 로드됨 |
| `disable-model-invocation: true` | 예 | 자체적으로는 불가 | 설명은 컨텍스트에 없고, 호출될 때 전체 스킬이 로드됨 |
| `user-invocable: false` | 아니요 | 예 | 설명은 항상 컨텍스트에 있고, 호출될 때 전체 스킬이 로드됨 |

> [!NOTE]
>
> 일반 세션에서 스킬 설명은 Claude가 사용 가능한 것을 알 수 있도록 컨텍스트에 로드되지만 전체 스킬 콘텐츠는 호출될 때만 로드됩니다. [사전 로드된 스킬이 있는 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#preload-skills-into-subagents)는 다르게 작동합니다. 전체 스킬 콘텐츠는 시작 시 주입됩니다.

#### 스킬 이름을 작성하는 위치

스킬을 직접 실행하려면 메시지 시작 부분에 스킬 이름을 입력합니다. 일반 텍스트 뒤에 오는 이름은 Claude에게 스킬을 실행할 권한을 부여하지만 스킬을 실행하지는 않습니다.

| 위치 | 예제 | 동작 |
| :- | :- | :- |
| 메시지 시작 부분 | `/deploy staging` | Claude Code가 스킬을 직접 실행함 |
| 일반 텍스트 뒤, 구두점이 붙지 않은 별도의 단어 | `go ahead and /deploy to staging` | 직접 실행되는 것은 없습니다. 이름은 해당 메시지에 대한 사용자의 권한으로 간주됩니다. Claude는 응답하는 동안 스킬을 실행할 수 있으며, 사용자의 표현을 보고 실행을 요청했는지 판단합니다 |

실행을 허용하지 않고 스킬에 대해 언급하려면 슬래시를 생략합니다.

### 스킬 콘텐츠 수명 주기

사용자 또는 Claude가 스킬을 호출하면 렌더링된 `SKILL.md` 콘텐츠가 대화에 단일 메시지로 들어가고 이후 턴에 걸쳐 유지됩니다. 이 지속성은 스킬의 지침에 적용되며 권한에는 적용되지 않습니다. [`allowed-tools`](#pre-approve-tools-for-a-skill) 권한은 다음 메시지를 보낼 때 해제됩니다. Claude Code는 이후 턴에서 스킬 파일을 다시 읽지 않으므로 작업 전체에 적용되어야 하는 지침을 일회성 단계가 아닌 상시 지침으로 작성합니다.

Claude가 렌더링된 콘텐츠가 이미 컨텍스트에 있는 복사본과 동일한 스킬을 다시 호출할 때 Claude Code는 콘텐츠의 두 번째 복사본 대신 스킬이 이미 로드되었다는 짧은 메모를 추가합니다. 인수가 변경되었거나 [동적 컨텍스트](#inject-dynamic-context) 명령이 새 출력을 생성했기 때문에 렌더링된 콘텐츠가 다를 때 Claude Code는 전체 콘텐츠를 다시 추가합니다.

[자동 압축](https://code.claude.com/docs/ko/how-claude-code-works.md#when-context-fills-up)은 토큰 예산 내에서 호출된 스킬을 전달합니다. 대화가 컨텍스트를 확보하기 위해 요약될 때 Claude Code는 각 스킬의 처음 5,000토큰을 유지하면서 가장 최근의 각 스킬 호출을 요약 뒤에 다시 첨부합니다. 다시 첨부된 스킬은 25,000토큰의 결합 예산을 공유합니다. Claude Code는 가장 최근에 호출된 스킬부터 시작하여 이 예산을 채우므로 한 세션에서 많은 스킬을 호출한 경우 압축 후 이전 스킬이 완전히 삭제될 수 있습니다.

세션 도중에 Claude가 스킬을 따르지 않게 되면 [Claude가 스킬을 따르지 않음](#claude-stops-following-a-skill)을 참조하세요.

### 스킬에 대한 도구 사전 승인

`allowed-tools` 필드는 스킬을 호출하는 턴 중에 나열된 도구에 대한 권한을 부여하므로 Claude는 승인을 요청하지 않고 사용할 수 있습니다. 다음 메시지를 보낼 때 권한이 해제되지만 스킬 콘텐츠는 [컨텍스트에 유지됩니다](#skill-content-lifecycle). 스킬을 다시 호출하면 해당 턴에 대해 다시 적용됩니다. 이는 사용 가능한 도구를 제한하지 않습니다. 모든 도구는 호출 가능하며 [권한 설정](https://code.claude.com/docs/ko/permissions.md)은 나열되지 않은 도구를 계속 관리합니다. 단일 턴이 아닌 전체 세션에 대해 도구를 사전 승인하려면 대신 해당 권한 설정에 허용 규칙을 추가합니다.

워크스페이스 신뢰는 이 필드를 제어하지 않습니다. Claude Code는 신뢰한 적이 없는 폴더에서의 `-p` 실행에서도 프로젝트 스킬의 `allowed-tools`를 적용합니다. 스킬은 자신에게 광범위한 도구 액세스를 부여할 수 있으므로 저장소에서 Claude Code를 실행하기 전에 해당 저장소에 체크인된 스킬의 `allowed-tools`를 검토합니다. 조직 전체에서 저장소 스킬의 이 필드를 적용하지 않으려면 [관리형 권한 규칙만 적용되는 경우](#when-only-managed-permission-rules-apply)를 참조하세요.

이 스킬을 호출할 때마다 Claude가 사용할 때마다 승인을 요청하지 않고 git 명령을 실행할 수 있습니다.

```yaml theme={null}
---
name: commit
description: Stage and commit the current changes
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git status *)
---
```

스킬이 활성화되는 동안 Claude의 사용 가능한 도구 풀에서 도구를 제거하려면 스킬의 frontmatter에서 `disallowed-tools`에 나열합니다. 다음 메시지를 보낼 때 제한이 해제됩니다. 거부 규칙과 마찬가지로 다른 도구가 남아 있는 동안 이 필드는 [`EndConversation`](https://code.claude.com/docs/ko/tools-reference#endconversation-tool-behavior)을 제거할 수 없습니다. 모든 스킬 및 프롬프트에서 도구를 차단하려면 [권한 설정](https://code.claude.com/docs/ko/permissions.md)에 거부 규칙을 추가합니다.

#### 관리형 설정이 훅을 플러그인으로 제한하는 경우

조직의 관리형 설정이 `strictPluginOnlyCustomization`에 `hooks`를 나열하면, frontmatter에 `hooks`를 선언한 개인 또는 프로젝트 스킬은 [사전 승인을 유지하는 스킬](https://code.claude.com/docs/ko/settings-reference.md#strictpluginonlycustomization-hooks)을 제외하고 `allowed-tools` 사전 승인을 잃습니다.

* **확인**: Claude Code 세션에서 `/status`를 입력합니다. `/status`에 [`Enterprise managed settings`](https://code.claude.com/docs/ko/settings#check-what-your-organization-enforces)가 표시되면 관리자에게 `strictPluginOnlyCustomization`에 `hooks`가 나열되어 있는지 문의합니다.
* **해결**: 해당 설정에서는 스킬의 훅이 실행되지 않으므로 스킬의 frontmatter에서 `hooks`를 제거합니다. 훅을 유지하려면 마켓플레이스에서 설치하는 [플러그인으로 스킬을 이동](https://code.claude.com/docs/ko/hooks.md#limits-on-skill-hooks)합니다.

#### 관리형 권한 규칙만 적용되는 경우

조직이 관리형 설정에서 `allowManagedPermissionRulesOnly`를 설정하면 Claude Code는 프로젝트 및 개인 스킬과 [해당 설정 항목에 나열된 기타 소스](https://code.claude.com/docs/ko/settings-reference.md#allowmanagedpermissionrulesonly)의 `allowed-tools`를 무시합니다. 이를 위해서는 Claude Code v2.1.282 이상이 필요합니다.

영향을 받는 스킬이 나열한 도구는 대신 조직의 관리형 규칙과 일반 권한 프롬프트를 거칩니다. `/status`를 실행하면 세션에서 지금까지 Claude Code가 `allowed-tools`를 무시한 각 스킬이 나열됩니다. 스킬에서 관리형 규칙이 허용하지 않는 주입된 명령은 [주입된 명령에 대한 권한 검사](#permission-checks-on-injected-commands)를 따릅니다.

### 스킬에 인수 전달

사용자와 Claude 모두 스킬을 호출할 때 인수를 전달할 수 있습니다. 인수는 `$ARGUMENTS` 플레이스홀더를 통해 사용 가능합니다.

이 스킬은 번호로 GitHub 이슈를 수정합니다. `$ARGUMENTS` 플레이스홀더는 스킬 이름 뒤에 오는 모든 것으로 대체됩니다.

```yaml theme={null}
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.

1. Read the issue description
2. Understand the requirements
3. Implement the fix
4. Write tests
5. Create a commit
```

`/fix-issue 123`을 실행하면 Claude는 "Fix GitHub issue 123 following our coding standards..."를 받습니다.

인수와 함께 스킬을 호출했지만 스킬의 콘텐츠에서 인수를 받는 플레이스홀더가 없으면 Claude Code는 `ARGUMENTS: <your input>`을 스킬 콘텐츠 끝에 추가하므로 Claude는 여전히 입력한 내용을 봅니다. 플레이스홀더는 `$ARGUMENTS`, `$1`과 같은 인덱싱된 형식 또는 명명된 인수입니다. 위치에 인수가 없는 인덱싱된 플레이스홀더는 리터럴 텍스트로 유지되며 인수를 받은 것으로 계산되지 않습니다. 명명된 플레이스홀더는 위치에 인수가 없어도 계산됩니다. 빈 문자열로 확장되기 때문입니다.

위치별로 개별 인수에 액세스하려면 `$ARGUMENTS[N]` 또는 더 짧은 `$N`을 사용합니다.

```yaml theme={null}
---
name: migrate-component
description: Migrate a component from one language to another
---

Migrate the $ARGUMENTS[0] component from $ARGUMENTS[1] to $ARGUMENTS[2].
Preserve all existing behavior and tests.
```

`/migrate-component SearchBar JavaScript TypeScript`를 실행하면 `$ARGUMENTS[0]`을 `SearchBar`로, `$ARGUMENTS[1]`을 `JavaScript`로, `$ARGUMENTS[2]`를 `TypeScript`로 대체합니다. `$N` 약자를 사용하는 동일한 스킬:

```yaml theme={null}
---
name: migrate-component
description: Migrate a component from one language to another
---

Migrate the $0 component from $1 to $2.
Preserve all existing behavior and tests.
```

#### 한 메시지에 여러 스킬 스택

터미널의 Claude Code 프롬프트에 입력할 때는 한 메시지의 시작 부분에 여러 스킬을 스택할 수 있습니다. Agent SDK 또는 `claude -p`를 통해서는 Claude Code가 첫 번째 스킬만 로드하고 줄의 나머지 부분을 해당 스킬의 인수로 사용합니다. 터미널 프롬프트에서 `/write-tests /fix-issue 123`을 입력하면 두 스킬이 모두 로드되고 후행 텍스트 `123`이 각각에 `$ARGUMENTS`로 전달됩니다.

Claude Code는 첫 번째 스킬과 그 뒤에 스택된 최대 5개를 확장합니다. 확장은 인라인 사용자 호출 가능 스킬이 아닌 첫 번째 토큰에서 중지됩니다. [`/code-review`](https://code.claude.com/docs/ko/code-review-local)처럼 [포크된 서브에이전트](#run-skills-in-a-subagent)로 실행되는 스킬이나 `/loop`처럼 인수가 다른 명령으로 시작할 수 있는 스킬을 스택하면 확장은 거기서 끝납니다. 해당 토큰 및 그 뒤의 모든 것이 확장된 모든 스킬의 인수 텍스트가 됩니다.

## 고급 패턴

### 동적 컨텍스트 주입

`` !`<command>` `` 구문은 스킬 콘텐츠가 Claude에 전송되기 전에 셸 명령을 실행합니다. 명령 출력이 플레이스홀더를 대체하므로 Claude는 명령 자체가 아닌 실제 데이터를 받습니다. Claude Code는 스킬이 [claude.ai 계정에서 동기화될 때](#how-claude-code-handles-the-body-of-a-synced-skill) 이러한 명령을 머신에서 실행하지 않습니다. 이 제한은 Claude Code v2.1.228 이상이 필요합니다.

이 스킬은 GitHub CLI를 사용하여 라이브 PR 데이터를 가져와 풀 리퀘스트를 요약합니다. `` !`gh pr diff` `` 및 기타 명령이 먼저 실행되고 해당 출력이 프롬프트에 삽입됩니다:

```yaml theme={null}
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request...
```

치환은 원본 파일에 대해 한 번만 실행됩니다. 명령 출력은 일반 텍스트로 삽입되며 추가 `` !`<command>` `` 플레이스홀더에 대해 다시 스캔되지 않으므로 명령은 나중의 패스를 위해 플레이스홀더를 내보낼 수 없습니다.

인라인 형식은 `!`이 줄의 시작 또는 공백 직후에 나타날 때만 인식됩니다. `!`이 `` KEY=!`cmd` ``처럼 다른 문자 뒤에 오면 플레이스홀더는 리터럴 텍스트로 남고 명령은 실행되지 않습니다.

여러 줄 명령의 경우 인라인 형식 대신 ` ```! `로 열린 펜스 코드 블록을 사용합니다:

````markdown theme={null}
## Environment
```!
node --version
git status --short
```
````

사용자, 프로젝트, 플러그인 또는 [추가 디렉터리](#skills-from-additional-directories) 소스의 스킬 및 사용자 정의 명령에 대해 이 동작을 비활성화하려면 [설정](https://code.claude.com/docs/ko/settings.md)에서 `"disableSkillShellExecution": true`를 설정합니다. 각 명령은 실행되는 대신 `[shell command execution disabled by policy]`로 대체됩니다. 번들 스킬과 관리형 스킬은 영향을 받지 않습니다. 이 설정은 사용자가 재정의할 수 없는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 가장 유용합니다.

Claude Code는 이 설정과 관계없이 [claude.ai 계정에서 동기화된](#how-synced-skills-behave) 스킬에 나타나는 이러한 명령을 머신에서 절대 실행하지 않습니다. 이 제한은 Claude Code v2.1.228 이상이 필요합니다. [Claude Code가 동기화된 스킬의 본문을 처리하는 방법](#how-claude-code-handles-the-body-of-a-synced-skill)은 각 종류의 세션에서 Claude가 명령 대신 받는 것을 설명합니다.

> [!TIP]
>
> 스킬이 실행될 때 더 깊은 추론을 요청하려면 스킬 콘텐츠의 어디든지 `ultrathink`를 포함합니다. [일회성 깊은 추론을 위해 ultrathink 사용](https://code.claude.com/docs/ko/model-config.md#use-ultrathink-for-one-off-deep-reasoning)을 참조합니다.

#### 주입된 명령이 실행되는 방식

Claude Code는 스킬의 frontmatter에 있는 `shell` 키와 사용자 환경에서 스킬의 주입된 명령을 실행할 도구를 선택합니다. 모든 조합은 Bash 도구 또는 PowerShell 도구를 통해 명령을 실행하며, 호출을 완전히 실패하게 하는 하나의 조합을 제외합니다:

* `shell: powershell`, [PowerShell 도구](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool)가 활성화된 경우: 명령은 PowerShell 도구를 통해 실행됩니다.
* `shell: bash` (bash를 사용할 수 없는 경우): 명령이 실행되기 전에 호출이 실패합니다. 이는 Git Bash가 없는 Windows에서 발생합니다. Claude Code는 ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found``를 표시합니다.
* 기타 모든 조합: bash를 사용할 수 있을 때 명령은 Bash 도구를 통해 실행됩니다. 사용할 수 없을 때는 PowerShell 도구를 통해 실행됩니다.

두 도구 모두 Claude의 자체 셸 명령을 실행하는 것과 동일한 방식으로 명령을 실행합니다. 이들은 작업 디렉터리, 타임아웃 및 출력 처리를 공유합니다:

* **작업 디렉터리**: Claude Code는 각 명령을 세션 셸의 현재 작업 디렉터리에서 실행합니다. Claude가 `cd`를 실행할 때 해당 디렉터리가 이동합니다. 매번 동일하게 확인되어야 하는 경로에서 [`${CLAUDE_SKILL_DIR}` 또는 `${CLAUDE_PROJECT_DIR}`](#available-string-substitutions)을 사용합니다.
* **stderr**: 기본 `bash` 셸을 사용하면 Claude Code는 stderr를 stdout으로 병합합니다. 명령이 stderr에 쓰는 모든 것이 주입된 텍스트에 나타납니다.
* **타임아웃**: 각 명령은 Bash 도구의 기본 2분 [타임아웃](https://code.claude.com/docs/ko/tools-reference.md#timeout-and-output-limits) 아래에서 실행됩니다. Bash 도구가 [시간 초과된 명령을 백그라운드로 이동](https://code.claude.com/docs/ko/tools-reference.md#foreground-commands-that-move-to-the-background)할 때 스킬은 여전히 렌더링됩니다. 주입된 텍스트는 이동을 보고하고 백그라운드 작업과 명령의 출력을 수집하는 파일의 이름을 지정합니다. 명령이 Bash 도구가 절대 자동으로 백그라운드하지 않는 명령인 경우 Claude Code는 타임아웃에서 이를 종료합니다. 이 실패는 [호출을 중단합니다](#when-an-injected-command-fails).
* **출력 크기**: Bash 도구의 인라인 상한을 초과하는 출력은 잘린 텍스트가 아닌 파일 경로와 짧은 미리보기로 도착합니다. [출력 제한](https://code.claude.com/docs/ko/tools-reference.md#output-limits)은 상한과 각 경계를 조정하는 방법을 다룹니다.

PowerShell 도구는 실행하는 명령에 동일한 타임아웃, 백그라운드 처리 및 출력 상한 동작을 적용합니다. 해당 세부 사항은 [PowerShell 도구](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool) 섹션을 참조합니다.

#### 주입된 명령이 실패할 때

실패한 명령은 자신의 플레이스홀더뿐만 아니라 전체 스킬 호출을 중단합니다. Claude는 해당 호출에 대한 스킬 콘텐츠를 절대 보지 않습니다. 중단은 `Shell command failed for pattern "..."`를 표시합니다. 오류 메시지에는 명령의 출력이 포함됩니다.

기본 `bash` 셸을 사용하면 0이 아닌 종료 코드는 실패로 계산됩니다. 하나의 예외가 적용됩니다: Claude Code는 [검색 및 비교 명령](https://code.claude.com/docs/ko/tools-reference.md#output-limits)에서 종료 코드 1을 정상 결과로 취급하고 해당 출력을 주입합니다. 종료 코드 2 이상은 이러한 명령에 대해서도 실패합니다.

어떤 명령이 예외를 받는지는 셸에 따라 다릅니다:

* 기본 `bash` 셸: [출력 제한](https://code.claude.com/docs/ko/tools-reference.md#output-limits) 아래에 나열된 명령
* `shell: powershell`, PowerShell 도구가 활성화된 경우: `grep` 및 `git diff`를 포함하지만 `find` 또는 `diff`는 포함하지 않는 [다른 집합](https://code.claude.com/docs/ko/tools-reference.md#exit-code-1-from-searches-and-git-diff-in-powershell)

기본 `bash` 셸을 사용하면 0이 아닌 종료를 예상하는 다른 명령에 `|| true`를 추가합니다. 문제를 찾을 때 1을 종료하는 검사 스크립트가 한 예입니다.

#### 셸 명령이 실행되지 않은 경우

`No shell command in <name> was run`은 해당 스킬의 셸 명령 중 하나에 도구가 허용하지 않는 문자가 포함되어 있음을 의미합니다. 해당 문자를 찾아 제거하려면 [오류 참조](https://code.claude.com/docs/ko/errors.md#no-shell-command-was-run)를 참조합니다.

#### 주입된 명령의 권한 확인

주입된 명령은 스킬이 렌더링되는 동안 절대 권한을 요청하지 않습니다. Claude Code는 각 명령을 [권한 규칙](https://code.claude.com/docs/ko/permissions.md)에 대해 먼저 확인합니다. 거부 규칙이 일치하는 명령은 호출을 중단하고 `Shell command permission check failed for pattern "..."`를 표시합니다.

[자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) 외부에서 명령의 권한 확인이 허용 이외의 것을 반환하면 Claude Code는 동일한 오류와 함께 호출을 중단합니다. 여기에는 일반적으로 확인을 요청할 규칙이 포함됩니다. 일치하지 않는 명령이 여기서 중단되지 않도록 하려면 [`allowed-tools`](#pre-approve-tools-for-a-skill)로 미리 승인합니다. 조직이 권한 규칙을 관리형 설정으로 제한하는 경우 [관리형 권한 규칙만 적용되는 경우](#when-only-managed-permission-rules-apply)를 참조합니다. 거부 및 확인 규칙은 여전히 `allowed-tools`를 재정의합니다. [권한 관리](https://code.claude.com/docs/ko/permissions.md#manage-permissions)를 참조합니다.

자동 모드에서 그렇지 않으면 승인이 필요한 명령은 호출을 중단하지 않습니다. 스킬은 Claude에게 먼저 명령을 실행하도록 지시하는 지침과 함께 로드되고 Claude의 자체 호출은 [자동 모드의 일반적인 확인](https://code.claude.com/docs/ko/permission-modes.md#how-the-classifier-evaluates-actions)을 통과합니다. 호출은 여전히 `agent`를 설정하는 [포크된 스킬](#run-skills-in-a-subagent)에서 중단되고, Claude가 [주입된 명령을 실행하는 셸 도구](#how-injected-commands-run)를 갖지 않은 세션에서 중단됩니다.

### 서브에이전트에서 스킬 실행

스킬을 격리된 상태에서 실행하려면 frontmatter에 `context: fork`를 추가합니다. Claude Code는 `agent` 필드에 설정된 유형의 새로운 서브에이전트를 시작하고 스킬 콘텐츠를 프롬프트로 제공합니다. 서브에이전트는 대화 기록을 보지 않으므로 스킬의 지침이 독립적으로 작동해야 합니다.

> [!NOTE]
>
> 이름에도 불구하고 `context: fork`가 있는 스킬은 [현재 대화의 포크](https://code.claude.com/docs/ko/sub-agents.md#fork-the-current-conversation)에서 실행되지 않으며, 이는 지금까지 논의한 모든 것을 서브에이전트에 전달할 것입니다. 작업이 해당 기록에 따라 다를 때 `context: fork` 대신 대화를 포크합니다.

포크된 서브에이전트는 [백그라운드](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)에서 실행됩니다: 실행되는 동안 계속 작업하고 완료되면 결과가 대화에 도착합니다. frontmatter에서 `background: false`를 설정하여 대신 스킬을 호출한 턴에서 결과를 기다립니다.

Claude Code는 다음과 같은 경우에도 스킬이 `background: false`를 설정하지 않더라도 결과를 기다립니다:

* `-p` 플래그 또는 Agent SDK를 사용한 비대화형 모드
* [`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`](https://code.claude.com/docs/ko/env-vars)를 `1`로 설정할 때 (다른 백그라운드 작업 기능도 끕니다)
* 동일한 스킬의 이전 호출이 여전히 실행 중인 동안 포크된 스킬을 호출할 때
* [세션 범위 예약 작업](https://code.claude.com/docs/ko/scheduled-tasks.md)이 스킬을 프롬프트로 하여 실행될 때

[동적 워크플로](https://code.claude.com/docs/ko/workflows.md)의 에이전트가 포크된 스킬을 호출하면, 스킬이 `background: false`를 설정하지 않더라도 해당 에이전트가 결과를 기다렸다가 받습니다. v2.1.295 이전에는 스킬이 백그라운드에서 실행되면 해당 에이전트가 스킬을 기다리지 않았습니다. 그러면 스킬의 결과는 에이전트에 전달되지 않고 주 대화에 도착했습니다.

백그라운드에서 실행되는 포크는 [백그라운드 서브에이전트에 적용되는 더 좁은 도구 집합](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)으로도 실행됩니다: 스킬의 서브에이전트는 일반 에이전트 유형이므로 대화를 포크하는 서브에이전트에 대한 예외는 적용되지 않습니다. 스킬의 단계가 해당 집합 외부의 도구에 따라 다르면 `background: false`를 설정하여 전체 도구 집합을 유지합니다.

백그라운드에서 실행되는 포크된 스킬은 세션의 [체크포인트](https://code.claude.com/docs/ko/checkpointing.md#subagent-edits-not-restored) 외부에서 편집을 적용합니다. 이후 `/rewind`는 Claude가 대화에서 이미 편집한 파일만 복원합니다. 다른 파일에 대한 스킬의 편집은 그대로 남으므로 git을 사용하여 되돌립니다.

> [!WARNING]
>
> `context: fork`는 명시적 지침이 있는 스킬에만 의미가 있습니다. 스킬에 작업 없이 "이러한 API 규칙을 사용합니다"와 같은 지침이 포함되어 있으면 서브에이전트는 지침을 받지만 실행 가능한 프롬프트가 없으므로 의미 있는 출력 없이 반환됩니다.

스킬과 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)는 두 방향으로 함께 작동합니다:

| 접근 방식 | 시스템 프롬프트 | 작업 | 또한 로드 |
| :- | :- | :- | :- |
| `context: fork`가 있는 스킬 | 에이전트 유형에서 | SKILL.md 콘텐츠 | CLAUDE.md, 에이전트의 [시작 컨텍스트](https://code.claude.com/docs/ko/sub-agents.md#what-loads-at-startup)에 따라 |
| `skills` 필드가 있는 서브에이전트 | 서브에이전트의 마크다운 본문 | Claude의 위임 메시지 | 사전 로드된 스킬 + CLAUDE.md, 서브에이전트의 [시작 컨텍스트](https://code.claude.com/docs/ko/sub-agents.md#what-loads-at-startup)에 따라 |

`context: fork`를 사용하면 스킬에 작업을 작성하고 이를 실행할 에이전트 유형을 선택합니다. 기본 제공 Explore 및 Plan 에이전트는 컨텍스트를 작게 유지하기 위해 [CLAUDE.md 및 git 상태 없이 시작합니다](https://code.claude.com/docs/ko/sub-agents.md#what-loads-at-startup). 작업에 필요한 모든 내용을 SKILL.md에 넣습니다. `agent: Explore`를 사용하는 포크된 스킬은 해당 콘텐츠와 에이전트의 자체 시스템 프롬프트로 시작하며, CLAUDE.md 파일은 전혀 포함하지 않습니다.

역으로 스킬을 참조 자료로 사용하는 사용자 정의 서브에이전트를 정의하려면 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#preload-skills-into-subagents)를 참조합니다.

#### 예: Explore 에이전트를 사용하는 연구 스킬

이 스킬은 포크된 Explore 에이전트에서 연구를 실행합니다. 스킬 콘텐츠는 작업이 되고 에이전트는 코드베이스 탐색에 최적화된 읽기 전용 도구를 제공합니다:

```yaml theme={null}
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:

1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

이 스킬이 실행될 때:

1. 새로운 격리된 컨텍스트가 생성됩니다
2. 서브에이전트는 스킬 콘텐츠를 프롬프트로 받습니다 ("Research \$ARGUMENTS thoroughly" 지침)
3. `agent` 필드는 실행 환경 (모델, 도구 및 권한)을 결정합니다
4. 서브에이전트는 결과를 요약하고 완료되면 주 대화에 반환합니다

`agent` 필드는 사용할 서브에이전트 구성을 지정합니다. 옵션에는 기본 제공 에이전트 (`Explore`, `Plan`, `general-purpose`) 또는 `.claude/agents/`의 모든 사용자 정의 서브에이전트가 포함됩니다. 생략하면 `general-purpose`를 사용합니다.

### Claude의 스킬 액세스 제한

기본적으로 Claude는 `disable-model-invocation: true`가 설정되지 않은 모든 스킬을 호출할 수 있습니다. [`allowed-tools`](#pre-approve-tools-for-a-skill)를 정의하는 스킬은 스킬을 호출하는 턴 동안 Claude에게 사용할 때마다 승인하지 않고도 해당 도구에 액세스할 수 있는 권한을 부여합니다. 이 부여는 다음 메시지를 보낼 때 해제됩니다. [권한 설정](https://code.claude.com/docs/ko/permissions.md)은 여전히 다른 모든 도구에 대한 기본 승인 동작을 관리합니다. `/init` 및 `/security-review`를 포함한 몇 가지 기본 제공 명령도 Skill 도구를 통해 사용할 수 있습니다. `/compact`와 같은 다른 기본 제공 명령은 그렇지 않습니다.

Claude가 호출할 수 있는 스킬을 제어하는 세 가지 방법:

**`/permissions`에서 Skill 도구를 거부하여 모든 스킬 비활성화**:

```text theme={null}
# Add to deny rules:
Skill
```

**[권한 규칙](https://code.claude.com/docs/ko/permissions.md)을 사용하여 특정 스킬 허용 또는 거부**:

```text theme={null}
# Allow only specific skills
Skill(commit)
Skill(review-pr *)

# Deny specific skills
Skill(deploy *)
```

권한 구문: 정확한 일치의 경우 `Skill(name)`, 모든 인수를 사용한 접두사 일치의 경우 `Skill(name *)`.

아래 표는 규칙에 사용된 이름의 종류별로 `deny` 규칙이 작성한 이름 외에 추가로 차단하는 대상을 보여 줍니다.

| `deny` 규칙에 지정한 이름 | 규칙 예시 | Claude Code가 추가로 차단하는 대상 |
| :- | :- | :- |
| 별칭 | `Skill(review)` | `/review` 별칭을 통한 번들 `/code-review` |
| 정규화되지 않은 이름 | `Skill(deploy)` | `apps/web:deploy`로 나열된 [중첩된 스킬](#where-skills-live) |
| [claude.ai에서 동기화된 스킬](#how-synced-skills-behave) | `Skill(anthropic-skills:deploy)` | Claude Desktop이 해당 스킬을 플러그인으로 세션에 전달할 때의 그 스킬 |
| 동기화된 스킬의 플러그인 형식 | `Skill(deploy:deploy)` | 동기화된 스킬 |
| [매개변수 형식](https://code.claude.com/docs/ko/permissions.md#match-by-input-parameter)의 스킬 | `Skill(skill:deploy)` | Claude가 별칭과 표시 이름을 포함하여 어떤 이름으로 호출하든 해당 스킬 |

v2.1.260 이전에는 Claude Code가 deny 규칙이 정규화되지 않은 이름만 지정할 때 정규화된 이름 아래에 나열된 중첩된 스킬을 차단하지 않았습니다.

Claude Code는 `allow` 규칙을 스킬의 자체 이름과 Claude의 호출에서의 이름에 대해서만 일치시킵니다. [동기화된 스킬](#how-synced-skills-behave)을 확인 요청 없이 승인하려면 [예약된 네임스페이스](#names-reserved-for-synced-skills) 안에서 이름을 지정합니다:

* `Skill(anthropic-skills:pdf)`는 동기화된 `pdf` 스킬을 승인합니다
* `Skill(anthropic-skills *)`는 모든 동기화된 스킬을 승인합니다
* `Skill(anthropic *)`는 `anthropic-skills:pdf`를 포함하지 않습니다. 네임스페이스 외부의 접두사는 그 안의 이름과 일치하지 않기 때문입니다

**frontmatter에 `disable-model-invocation: true`를 추가하여 개별 스킬 숨기기**. 이는 Claude의 컨텍스트에서 스킬을 완전히 제거합니다.

> [!NOTE]
>
> `user-invocable: false`를 사용하면 스킬을 호출할 수 없지만 Claude는 여전히 할 수 있습니다. Claude가 Skill 도구를 통해 호출하지 못하도록 하려면 `disable-model-invocation: true`를 설정합니다.

### 설정에서 스킬 가시성 재정의

`skillOverrides` 설정은 스킬의 자체 frontmatter 대신 [설정](https://code.claude.com/docs/ko/settings.md)에서 스킬 가시성을 제어합니다. SKILL.md를 편집하고 싶지 않은 스킬 (예: 공유 프로젝트 리포지토리에 체크인된 스킬)에 사용합니다. `/skills` 메뉴가 이 설정을 대신 작성합니다: 스킬을 강조하고 `Space`를 눌러 상태를 순환한 다음 `Esc`를 눌러 `.claude/settings.local.json`에 저장합니다.

각 키는 스킬 이름이고 각 값은 다음 네 가지 상태 중 하나입니다:

| 값 | Claude에 나열됨 | `/` 메뉴에서 |
| :- | :- | :- |
| `"on"` | 이름 및 설명 | 예 |
| `"name-only"` | 이름만 | 예 |
| `"user-invocable-only"` | 숨김 | 예 |
| `"off"` | 숨김 | 숨김 |

`/skills` 메뉴는 `"user-invocable-only"` 상태를 `user-only`로 레이블합니다.

`"off"`는 터미널 `/` 메뉴 외에도 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 클라이언트 및 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/skills.md#discover-available-commands) 호출자에게 광고되는 명령 목록에서도 스킬을 숨깁니다. 전체 이름으로 숨겨진 스킬을 호출하면 실행하는 대신 `skillOverrides` 오류를 반환합니다.

`skillOverrides`에 없는 스킬은 `"on"`으로 취급됩니다. 아래 예제는 한 스킬을 이름으로 축소하고 다른 스킬을 완전히 끕니다:

```json theme={null}
{
  "skillOverrides": {
    "legacy-context": "name-only",
    "deploy": "off"
  }
}
```

일부 번들 스킬에는 `/doctor`에 대한 `checkup`과 같은 별칭이 있습니다. [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 또는 `--settings` 플래그로 전달하는 파일에서 별칭 아래에 `skillOverrides` 항목을 설정하면 Claude Code는 이를 별칭 뒤의 스킬에 적용합니다. 별칭을 통해 스킬을 더 제한할 수만 있으며 더 가시적으로 만들 수는 없으며, 관리형 설정에서 스킬의 자체 이름 아래에도 항목을 설정하면 해당 항목이 우선합니다. v2.1.260 이전에는 Claude Code가 모든 설정 소스의 스킬에 별칭 아래의 항목을 적용하지 않았습니다.

사용자, 프로젝트 및 로컬 설정에서 Claude Code는 스킬 이름에 대해서만 항목을 일치시킵니다. 거기서 `review`에 대한 항목을 설정하면 `/review` 별칭을 통한 번들 `/code-review`가 아닌 `review`라는 스킬에 적용됩니다.

플러그인 스킬은 `skillOverrides`의 영향을 받지 않습니다. `/plugin`을 통해 이를 관리합니다.

### 사용하지 않는 스킬 찾기

[스킬 목록](#skill-descriptions-are-cut-short)의 모든 스킬은 Claude가 절대 사용하지 않더라도 모든 턴에서 컨텍스트에 추가됩니다. `/skill-doctor`를 실행하여 각 스킬의 비용과 사용 빈도를 확인하고 어떤 스킬을 끌지 결정합니다. 대화형 세션에서 보고서는 `/plugin` 관리자의 **Stats** 탭에서 열립니다. `-p`를 사용한 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 Claude Code는 이를 텍스트로 인쇄합니다.

보고서는 번들 스킬 및 엔터프라이즈 스킬을 제외한 세션의 스킬을 다룹니다. 목록에서 절대 호출되지 않은 스킬에 플래그를 지정하고 끌 위치를 알려줍니다. 끌 위치를 알려주는 스킬 중에서 가장 높은 컨텍스트 비용을 가진 스킬부터 시작합니다. 보고서는 또한 최근에 사용하지 않은 플러그인을 나열합니다.

`/skill-doctor`는 Claude Code v2.1.252 이상이 필요하며 [기능 플래그 가져오기](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching)를 건너뛰는 세션에서는 사용할 수 없습니다. 휴대폰 또는 브라우저에서 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 통해 `/skill-doctor`를 실행하면 Claude Code는 대신 [`Skill usage reports are not available on this connection.`](https://code.claude.com/docs/ko/errors#skill-usage-reports-are-not-available-on-this-connection)이라고 회신합니다. 세션이 실행 중인 머신의 터미널에서 `/skill-doctor`를 실행합니다.

## 스킬 평가 및 반복

스킬이 트리거되는 것을 보는 것은 Claude가 스킬을 찾았다는 의미이지, 의도한 대로 작동했다는 의미는 아닙니다. 스킬이 제대로 작동하는지 알기 위해서는 두 가지를 별도로 측정해야 합니다. Claude가 해야 할 프롬프트에서 스킬을 호출하는지 여부와 호출할 때 출력이 예상과 일치하는지 여부입니다.

두 가지 모두에 대한 확인은 기준선 비교입니다. 현실적인 프롬프트 몇 개를 수집하고, 스킬을 사용할 수 있는 새로운 세션에서 각각을 실행한 후 스킬을 끈 상태에서 다시 실행하고 결과를 비교합니다. 새로운 세션이 중요한 이유는 스킬 작성 시 남겨진 컨텍스트가 작성된 지침의 간격을 숨길 수 있기 때문입니다.

두 번째 실행을 위해 스킬을 끄는 방법은 스킬의 출처에 따라 다릅니다:

* **개인 또는 프로젝트 스킬**: [`skillOverrides`](#override-skill-visibility-from-settings)에서 `"off"`로 설정합니다.
* **플러그인이 제공하는 스킬**: `skillOverrides`는 플러그인 스킬에 적용되지 않습니다. 대신 플러그인을 로드하지 않은 상태로 각 실행을 반복하는 [`claude plugin eval`](https://code.claude.com/docs/ko/plugin-evals#the-no-plugin-baseline)을 사용합니다.

두 가지 도구가 기준선 비교를 자동화합니다. [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)에 포함되어 배포되는 스킬의 경우, [`claude plugin eval`](https://code.claude.com/docs/ko/plugin-evals)은 플러그인을 사용하는 경우와 사용하지 않는 경우 각 프롬프트를 격리된 세션에서 실행하고, 정의한 또는 자동으로 작성된 채점자로 점수를 매기며, 임계값 이하에서 0이 아닌 값으로 종료하여 CI에서 이를 제어할 수 있습니다. Claude Code 대화 내에서 단일 스킬을 반복하는 경우, 아래의 스킬 생성자 플러그인은 자체 `evals/evals.json` 형식으로 유사한 루프를 실행합니다. 두 형식은 상호 교환할 수 없습니다.

### skill-creator로 평가 실행

[`skill-creator` 플러그인](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator)은 Claude Code 내에서 비교 루프를 자동화합니다. VS Code 확장 프로그램 또는 데스크톱 앱에서는 [플러그인 설치](https://code.claude.com/docs/ko/plugins/install.md#install-a-plugin)에 따라 공식 마켓플레이스에서 설치합니다. 터미널에서는 `claude`를 실행하여 Claude Code를 시작한 다음 프롬프트에 다음을 입력합니다:

```text theme={null}
/plugin install skill-creator@claude-plugins-official
```

설치가 실패하면 Claude Code가 보고한 메시지와 일치시킵니다:

* `Marketplace "claude-plugins-official" not found`: `/plugin marketplace add anthropics/claude-plugins-official`로 마켓플레이스를 추가한 후 설치를 다시 시도합니다.
* `Plugin "<name>" not found in marketplace "claude-plugins-official"`: 로컬에 있는 마켓플레이스 카탈로그 사본이 오래되었을 수 있습니다. `/plugin marketplace update claude-plugins-official`로 카탈로그를 새로 고친 후 설치를 다시 시도합니다. 재시도 시에도 동일한 메시지가 출력되면 [Plugin not found in marketplace](https://code.claude.com/docs/ko/plugins/troubleshooting.md#plugin-not-found-in-marketplace)를 참조합니다.

설치 요약에서 `Run /reload-plugins to apply.`를 보고하면 Claude Code가 해당 재로드를 실행합니다. 재로드 시 다음 메시지가 대화를 다시 읽을 것이라는 경고가 표시되면 `/reload-plugins --force`를 실행하여 현재 세션에서 플러그인의 스킬을 사용할 수 있게 합니다. 그런 다음 Claude에게 기존 스킬을 평가하도록 요청합니다. 예를 들어 `evaluate my summarize-changes skill with skill-creator`입니다. 플러그인은 테스트 케이스 작성을 안내하고 루프를 실행합니다:

* **테스트 케이스**: 프롬프트, 입력 파일 및 예상 동작을 스킬 디렉토리 내 `evals/evals.json`에 저장합니다
* **격리된 실행**: 각 테스트 케이스마다 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)를 생성하여 각 실행이 깨끗한 컨텍스트로 시작되도록 하고, 토큰 수와 지속 시간을 기록합니다
* **채점**: 각 어설션을 출력과 비교하고 `grading.json`에 증거와 함께 통과 또는 실패를 작성합니다
* **벤치마크**: 스킬 사용 여부에 따른 통과율, 시간 및 토큰을 `benchmark.json`에 집계하여 토큰 및 시간 오버헤드에 대한 통과율 개선을 비교할 수 있습니다
* **버전 비교**: 스킬의 두 버전 간에 블라인드 A/B를 실행하여 편집이 커밋하기 전에 개선 사항인지 확인할 수 있습니다
* **설명 튜닝**: 트리거해야 하는 프롬프트와 트리거하지 않아야 하는 프롬프트를 생성하고, 히트율을 측정하고, 스킬이 잘못된 요청에서 활성화될 때 설명 편집을 제안합니다
* **검토 뷰어**: 각 출력을 검사하고 다음 반복이 읽을 정성적 피드백을 기록할 수 있는 HTML 보고서를 엽니다

평가 파일 형식 및 전체 반복 워크플로우는 agentskills.io의 [스킬 출력 품질 평가](https://agentskills.io/skill-creation/evaluating-skills)를 참조합니다. 벤치마크 및 비교 모드의 배경은 [skill-creator 공지](https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills)를 참조합니다.

## 스킬 공유

스킬은 대상에 따라 다양한 범위에서 배포할 수 있습니다:

* **프로젝트 스킬**: `.claude/skills/`를 버전 관리에 커밋합니다
* **플러그인**: [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)에서 `skills/` 디렉토리를 생성합니다
* **관리형**: [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 통해 조직 전체에 배포합니다

### 시각적 출력 생성

스킬은 모든 언어의 스크립트를 번들로 제공하고 실행할 수 있으므로 Claude에 단일 프롬프트로는 불가능한 기능을 제공합니다. 한 가지 패턴은 시각적 출력을 생성하는 것입니다: 브라우저에서 열리는 대화형 HTML 파일로 데이터 탐색, 디버깅 또는 보고서 작성에 사용할 수 있습니다.

이 예제는 코드베이스 탐색기를 생성합니다: 디렉토리를 확장 및 축소할 수 있는 대화형 트리 뷰로, 파일 크기를 한눈에 볼 수 있고 색상으로 파일 유형을 식별할 수 있습니다.

스킬 디렉토리를 생성합니다:

```bash theme={null}
mkdir -p ~/.claude/skills/codebase-visualizer/scripts
```

이를 `~/.claude/skills/codebase-visualizer/SKILL.md`에 저장합니다. 설명은 Claude에게 이 스킬을 언제 활성화할지 알려주고, 지침은 Claude에게 번들된 스크립트를 실행하도록 지시합니다. 스크립트 경로는 [`${CLAUDE_SKILL_DIR}`](#available-string-substitutions)를 사용하므로 스킬이 개인, 프로젝트 또는 플러그인 수준에서 설치되었는지 여부에 관계없이 올바르게 해석됩니다:

````yaml theme={null}
---
name: codebase-visualizer
description: Generate an interactive collapsible tree visualization of your codebase. Use when exploring a new repo, understanding project structure, or identifying large files.
allowed-tools: Bash(python3 *)
---

# Codebase Visualizer

Generate an interactive HTML tree view that shows your project's file structure with collapsible directories.

## Usage

Run the visualization script from your project root:

```bash
python3 ${CLAUDE_SKILL_DIR}/scripts/visualize.py .
```

This creates `codebase-map.html` in the current directory and opens it in your default browser.

## What the visualization shows

- **Collapsible directories**: Click folders to expand/collapse
- **File sizes**: Displayed next to each file
- **Colors**: Different colors for different file types
- **Directory totals**: Shows aggregate size of each folder
````

이를 `~/.claude/skills/codebase-visualizer/scripts/visualize.py`에 저장합니다. 이 스크립트는 디렉토리 트리를 스캔하고 다음을 포함하는 자체 포함된 HTML 파일을 생성합니다:

* 파일 개수, 디렉토리 개수, 총 크기 및 파일 유형 수를 표시하는 **요약 사이드바**
* 파일 유형별로 코드베이스를 분석하는 **막대 차트** (크기 기준 상위 8개)
* 디렉토리를 확장 및 축소할 수 있는 **축소 가능한 트리**로, 색상으로 구분된 파일 유형 표시기가 있습니다

스크립트는 Python 3이 필요하지만 기본 제공 라이브러리만 사용하므로 설치할 패키지가 없습니다:

```python expandable theme={null}
#!/usr/bin/env python3
"""Generate an interactive collapsible tree visualization of a codebase."""

import json
import sys
import webbrowser
from html import escape
from pathlib import Path
from collections import Counter

IGNORE = {'.git', 'node_modules', '__pycache__', '.venv', 'venv', 'dist', 'build'}

def scan(path: Path, stats: dict) -> dict:
    result = {"name": path.name, "children": [], "size": 0}
    try:
        for item in sorted(path.iterdir()):
            if item.name in IGNORE or item.name.startswith('.'):
                continue
            if item.is_file():
                size = item.stat().st_size
                ext = item.suffix.lower() or '(no ext)'
                result["children"].append({"name": item.name, "size": size, "ext": ext})
                result["size"] += size
                stats["files"] += 1
                stats["extensions"][ext] += 1
                stats["ext_sizes"][ext] += size
            elif item.is_dir():
                stats["dirs"] += 1
                child = scan(item, stats)
                if child["children"]:
                    result["children"].append(child)
                    result["size"] += child["size"]
    except PermissionError:
        pass
    return result

def generate_html(data: dict, stats: dict, output: Path) -> None:
    ext_sizes = stats["ext_sizes"]
    total_size = sum(ext_sizes.values()) or 1
    sorted_exts = sorted(ext_sizes.items(), key=lambda x: -x[1])[:8]
    colors = {
        '.js': '#f7df1e', '.ts': '#3178c6', '.py': '#3776ab', '.go': '#00add8',
        '.rs': '#dea584', '.rb': '#cc342d', '.css': '#264de4', '.html': '#e34c26',
        '.json': '#6b7280', '.md': '#083fa1', '.yaml': '#cb171e', '.yml': '#cb171e',
        '.mdx': '#083fa1', '.tsx': '#3178c6', '.jsx': '#61dafb', '.sh': '#4eaa25',
    }
    lang_bars = "".join(
        f'<div class="bar-row"><span class="bar-label">{ext}</span>'
        f'<div class="bar" style="width:{(size/total_size)*100}%;background:{colors.get(ext,"#6b7280")}"></div>'
        f'<span class="bar-pct">{(size/total_size)*100:.1f}%</span></div>'
        for ext, size in sorted_exts
    )
    def fmt(b):
        if b < 1024: return f"{b} B"
        if b < 1048576: return f"{b/1024:.1f} KB"
        return f"{b/1048576:.1f} MB"

    html = f'''<!DOCTYPE html>
<html><head>
  <meta charset="utf-8"><title>Codebase Explorer</title>
  <style>
    body {{ font: 14px/1.5 system-ui, sans-serif; margin: 0; background: #1a1a2e; color: #eee; }}
    .container {{ display: flex; height: 100vh; }}
    .sidebar {{ width: 280px; background: #252542; padding: 20px; border-right: 1px solid #3d3d5c; overflow-y: auto; flex-shrink: 0; }}
    .main {{ flex: 1; padding: 20px; overflow-y: auto; }}
    h1 {{ margin: 0 0 10px 0; font-size: 18px; }}
    h2 {{ margin: 20px 0 10px 0; font-size: 14px; color: #888; text-transform: uppercase; }}
    .stat {{ display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #3d3d5c; }}
    .stat-value {{ font-weight: bold; }}
    .bar-row {{ display: flex; align-items: center; margin: 6px 0; }}
    .bar-label {{ width: 55px; font-size: 12px; color: #aaa; }}
    .bar {{ height: 18px; border-radius: 3px; }}
    .bar-pct {{ margin-left: 8px; font-size: 12px; color: #666; }}
    .tree {{ list-style: none; padding-left: 20px; }}
    details {{ cursor: pointer; }}
    summary {{ padding: 4px 8px; border-radius: 4px; }}
    summary:hover {{ background: #2d2d44; }}
    .folder {{ color: #ffd700; }}
    .file {{ display: flex; align-items: center; padding: 4px 8px; border-radius: 4px; }}
    .file:hover {{ background: #2d2d44; }}
    .size {{ color: #888; margin-left: auto; font-size: 12px; }}
    .dot {{ width: 8px; height: 8px; border-radius: 50%; margin-right: 8px; }}
  </style>
</head><body>
  <div class="container">
    <div class="sidebar">
      <h1>📊 Summary</h1>
      <div class="stat"><span>Files</span><span class="stat-value">{stats["files"]:,}</span></div>
      <div class="stat"><span>Directories</span><span class="stat-value">{stats["dirs"]:,}</span></div>
      <div class="stat"><span>Total size</span><span class="stat-value">{fmt(data["size"])}</span></div>
      <div class="stat"><span>File types</span><span class="stat-value">{len(stats["extensions"])}</span></div>
      <h2>By file type</h2>
      {lang_bars}
    </div>
    <div class="main">
      <h1>📁 {escape(data["name"])}</h1>
      <ul class="tree" id="root"></ul>
    </div>
  </div>
  <script>
    const data = {json.dumps(data)};
    const colors = {json.dumps(colors)};
    function fmt(b) {{ if (b < 1024) return b + ' B'; if (b < 1048576) return (b/1024).toFixed(1) + ' KB'; return (b/1048576).toFixed(1) + ' MB'; }}
    function esc(s) {{ return s.replace(/[&<>"']/g, c => ({{"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}}[c])); }}
    function render(node, parent) {{
      if (node.children) {{
        const det = document.createElement('details');
        det.open = parent === document.getElementById('root');
        det.innerHTML = `<summary><span class="folder">📁 ${{esc(node.name)}}</span><span class="size">${{fmt(node.size)}}</span></summary>`;
        const ul = document.createElement('ul'); ul.className = 'tree';
        node.children.sort((a,b) => (b.children?1:0)-(a.children?1:0) || a.name.localeCompare(b.name));
        node.children.forEach(c => render(c, ul));
        det.appendChild(ul);
        const li = document.createElement('li'); li.appendChild(det); parent.appendChild(li);
      }} else {{
        const li = document.createElement('li'); li.className = 'file';
        li.innerHTML = `<span class="dot" style="background:${{colors[node.ext]||'#6b7280'}}"></span>${{esc(node.name)}}<span class="size">${{fmt(node.size)}}</span>`;
        parent.appendChild(li);
      }}
    }}
    data.children.forEach(c => render(c, document.getElementById('root')));
  </script>
</body></html>'''
    output.write_text(html)

if __name__ == '__main__':
    target = Path(sys.argv[1] if len(sys.argv) > 1 else '.').resolve()
    stats = {"files": 0, "dirs": 0, "extensions": Counter(), "ext_sizes": Counter()}
    data = scan(target, stats)
    out = Path('codebase-map.html')
    generate_html(data, stats, out)
    print(f'Generated {out.absolute()}')
    webbrowser.open(f'file://{out.absolute()}')
```

테스트하려면 Claude Code를 모든 프로젝트에서 열고 "Visualize this codebase."라고 요청합니다. Claude가 스크립트를 실행하면 생성된 파일의 경로(예: `Generated /path/to/codebase-map.html`)를 출력하고 브라우저에서 엽니다. 브라우저가 열리지 않는 헤드리스 환경에서 작업하는 경우 출력된 경로는 스크립트가 성공했음을 확인합니다.

이 패턴은 모든 시각적 출력에 적용됩니다: 종속성 그래프, 테스트 커버리지 보고서, API 문서 또는 데이터베이스 스키마 시각화입니다. 번들된 스크립트가 작업을 수행하는 동안 Claude는 오케스트레이션을 처리합니다.

## 문제 해결

### 스킬이 트리거되지 않음

Claude가 예상대로 스킬을 사용하지 않는 경우:

1. 설명에 사용자가 자연스럽게 말할 만한 키워드가 포함되어 있는지 확인하세요
2. 스킬이 `What skills are available?`에 나타나는지 확인하세요
3. 설명과 더 가깝게 일치하도록 요청을 다시 표현해 보세요
4. 스킬이 사용자 호출 가능한 경우 `/skill-name`으로 직접 호출하세요
5. `/skill-name`도 인식되지 않으면 Claude Code가 [스킬 이름을 거부했는지](#characters-a-skill-name-cant-hold) 확인하세요
6. 스킬이 `paths`를 설정하는 경우 Claude가 읽거나 편집하거나 쓰는 파일이 Claude의 현재 작업 디렉터리 안에 있는지 확인하세요. 스킬은 그 외부에 있는 파일에 대해서는 활성화되지 않습니다. 예를 들어 형제 git worktree에 있는 파일은 `/add-dir`로 추가했더라도 활성화되지 않습니다. 해당 파일에 대해 스킬이 활성화되도록 하려면 해당 worktree에서 Claude Code를 시작하거나 [`/cd`로 세션을 그곳으로 옮기세요](https://code.claude.com/docs/ko/permissions#move-the-session-to-another-directory).

frontmatter YAML이 잘못된 형식이면 Claude Code는 스킬 본문을 빈 메타데이터로 로드하므로 `/skill-name`은 여전히 작동하지만 Claude는 일치시킬 `description`이 없습니다. `--debug`로 실행하여 파싱 오류를 확인하세요.

스킬이 플러그인에 포함되어 있으면 한 번에 하나씩 확인하는 대신 현실적인 프롬프트에서 얼마나 자주 트리거되는지 측정할 수 있습니다. [`tool_used: Skill` grader](https://code.claude.com/docs/ko/plugin-evals#create-your-first-eval-suite)를 사용하여 eval 케이스를 작성하고 각 설명 변경 후 `claude plugin eval`로 실행하세요.

frontmatter가 파싱되지 않는 `SKILL.md` 파일을 찾으려면 스킬 디렉토리에서 [`claude plugin validate`](https://code.claude.com/docs/ko/plugins/cli-reference#validate-a-directory)를 실행하세요. 예를 들어 프로젝트 스킬의 경우 `claude plugin validate .claude/skills` 또는 개인 스킬의 경우 `claude plugin validate ~/.claude/skills`입니다. Claude Code v2.1.233 이상이 필요합니다.

### 스킬이 너무 자주 트리거됨

Claude가 원하지 않을 때 스킬을 사용하는 경우:

1. 설명을 더 구체적으로 만드세요
2. 수동 호출만 원하는 경우 `disable-model-invocation: true`를 추가하세요

### Claude가 스킬을 따르지 않게 됨

Claude가 첫 번째 응답에서는 스킬을 따르다가 이후에 따르지 않게 되면, 다음 중 해당하는 경우부터 확인하세요:

* **Claude가 매번 지켜져야 하는 규칙을 건너뛴 경우**: 규칙을 [훅](https://code.claude.com/docs/ko/hooks-guide.md)으로 옮기세요. Claude Code는 각 파일 편집 전과 같이 해당 이벤트가 발생할 때마다 Claude가 스킬을 따르고 있는지와 관계없이 훅을 실행합니다. 규칙을 스킬과 함께 유지하려면 스킬의 [`hooks` frontmatter](https://code.claude.com/docs/ko/hooks#hooks-in-skills-and-agents)에 훅을 정의하세요. 해당 훅은 스킬이 호출된 시점부터 세션이 끝날 때까지 적용됩니다.
* **Claude가 판단에 따라 적용해야 하는 지침을 건너뛴 경우**: 지침이 전체 작업에 적용되도록 표현하세요. 예를 들어 "테스트를 실행하세요" 대신 "편집할 때마다 테스트를 실행하세요"와 같이 작성합니다. Claude Code는 스킬이 호출될 때 스킬의 내용을 대화에 추가하며 이후 턴에서 [파일을 다시 읽지 않습니다](#skill-content-lifecycle).
* **대화가 압축된 경우**: 스킬을 다시 호출하여 전체 내용을 복원하세요. [압축](https://code.claude.com/docs/ko/how-claude-code-works.md#when-context-fills-up) 후 Claude Code는 [호출된 스킬의 시작 부분만 유지할 수 있으므로](#skill-content-lifecycle) 가장 중요한 지침을 `SKILL.md` 상단 가까이에 배치하세요.

### 스킬 설명이 잘려 있음

Claude Code는 스킬 이름과 설명 목록을 컨텍스트에 로드하여 Claude가 사용 가능한 항목을 알 수 있도록 합니다. 목록에는 항상 모든 스킬 이름이 포함되지만 스킬이 많으면 Claude Code는 목록의 문자 예산에 맞추기 위해 일부 설명을 삭제하며, 이로 인해 Claude가 요청과 일치시키는 데 필요한 키워드가 제거됩니다. 예산은 모델의 컨텍스트 윈도우의 1%로 조정됩니다. 목록이 초과되면 Claude Code는 가장 적게 호출하는 스킬부터 설명을 삭제하므로 가장 자주 사용하는 스킬이 전체 텍스트를 유지합니다.

목록의 컨텍스트 비용 추정치와 가장 큰 기여자를 보려면 `/doctor`를 실행하세요. 사용하지 않는 스킬을 찾으려면 [`/skill-doctor`](#find-unused-skills)를 실행하세요. 목록이 예산을 초과하면 Claude Code는 [`--debug`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 볼 수 있는 디버그 로그에 경고를 작성합니다.

`/context`의 Skills 행은 예산이 적용된 후 목록의 크기를 보고하므로 모델이 수신하는 것과 일치합니다. v2.1.196 이전에는 행이 모든 설명의 전체 텍스트를 계산했으며 구성된 예산보다 몇 배 더 큰 값을 표시할 수 있었습니다.

예산을 높이려면 [`skillListingBudgetFraction`](https://code.claude.com/docs/ko/settings-reference#skilllistingbudgetfraction) 설정(예: `0.02` = 2%) 또는 `SLASH_COMMAND_TOOL_CHAR_BUDGET` 환경 변수를 고정 문자 수로 설정하세요. 다른 스킬을 위해 예산을 확보하려면 [`skillOverrides`](#override-skill-visibility-from-settings)에서 낮은 우선순위 항목을 `"name-only"`로 설정하여 설명 없이 나열되도록 하세요. 또한 소스에서 `description` 및 `when_to_use` 텍스트를 자르세요. 각 항목의 결합된 텍스트는 예산에 관계없이 1,536자로 제한되므로 주요 사용 사례를 먼저 배치하세요. 상한은 [`skillListingMaxDescChars`](https://code.claude.com/docs/ko/settings-reference#skilllistingmaxdescchars)로 구성할 수 있습니다.

### 스킬 설명의 꺾쇠괄호가 `&lt;` 및 `&gt;`로 표시됨

Claude Code는 `description` 및 `when_to_use` 필드의 `<`와 `>`를 `&lt;`와 `&gt;`로 표시합니다. `<branch>`와 같은 자리 표시자를 표시하려면 대괄호 또는 [`argument-hint`](#frontmatter-reference)를 사용하세요:

* **대괄호**: `<branch>`를 `[branch]`로 바꾸세요. 입력한 그대로 표시됩니다
* **`argument-hint`**: 자리 표시자를 새 `argument-hint: <branch>` 줄로 옮기세요. 명령 이름 뒤에 표시됩니다. 스킬을 claude.ai 또는 Skills API에도 업로드하는 경우 먼저 [해당 위치에서 `argument-hint`가 허용되는지 확인하세요](#using-skill-frontmatter-outside-claude-code).

### 개인 스킬이 사라짐

`~/.claude/skills/`에 만든 스킬 폴더가 사라졌다면 `~/.claude/skills/.trash/`를 확인하세요. Claude Code가 [claude.ai에서 스킬을 동기화](#how-synced-skills-behave)할 때는 별도의 `synced` 하위 폴더로 다운로드하며, 사용자가 만든 폴더는 이동하거나 삭제하지 않습니다.

v2.1.280 이전에는 `~/.claude/skills/`에 `manifest.json`이라는 파일이 있으면 Claude Code가 해당 파일에 나열된 스킬 폴더를 `~/.claude/skills/.trash/` 아래의 타임스탬프 폴더로 이동했으며, 해당 스킬은 더 이상 로드되지 않았습니다.

스킬을 복원하려면 타임스탬프 폴더에서 해당 스킬 폴더를 `~/.claude/skills/`로 다시 옮기세요. [보존 정리](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)가 휴지통 항목을 삭제하기 전에 이 작업을 수행하세요. 기본적으로 휴지통 항목은 휴지통으로 이동된 후 30일이 지나면 삭제됩니다.

## 관련 리소스

* **[구성 디버깅](https://code.claude.com/docs/ko/debug-your-config.md)**: skill이 나타나지 않거나 트리거되지 않는 이유 진단
* **[Skill 출력 품질 평가](https://agentskills.io/skill-creation/evaluating-skills)**: agentskills.io의 eval 파일 형식 및 반복 워크플로우
* **[Skill 작성 모범 사례](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)**: Claude 제품 전체에 적용되는 작성 지침
* **[Subagents](https://code.claude.com/docs/ko/sub-agents.md)**: 특화된 에이전트에 작업 위임
* **[플러그인](https://code.claude.com/docs/ko/plugins/overview.md)**: 다른 확장과 함께 스킬 패키징 및 배포
* **[Hooks](https://code.claude.com/docs/ko/hooks.md)**: 도구 이벤트 주변 워크플로우 자동화
* **[메모리](https://code.claude.com/docs/ko/memory.md)**: 지속적인 컨텍스트를 위한 CLAUDE.md 파일 관리
* **[명령어](https://code.claude.com/docs/ko/commands.md)**: 기본 제공 명령어 및 번들 skills 참조
* **[권한](https://code.claude.com/docs/ko/permissions.md)**: 도구 및 skill 액세스 제어
* **[Claude Tag skills](https://claude.com/docs/claude-tag/admins/skills-repo)**: 리포지토리에 커밋된 프로젝트 skills는 해당 리포지토리가 Claude Tag 채널에서 사용될 때도 로드됩니다
