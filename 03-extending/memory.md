> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude가 프로젝트를 기억하는 방법

> CLAUDE.md 또는 AGENTS.md 파일로 Claude에 지속적인 지침을 제공하고, 자동 메모리를 통해 Claude가 자동으로 학습을 축적하도록 합니다.

각 Claude Code 세션은 새로운 컨텍스트 윈도우로 시작됩니다. 두 가지 메커니즘이 세션 간에 지식을 전달합니다:

* **CLAUDE.md 파일**: Claude에 지속적인 컨텍스트를 제공하기 위해 작성하는 지침. Claude는 또한 CLAUDE.md 대신 저장소의 [`AGENTS.md` 파일](#agents-md)을 읽을 수 있습니다
* **자동 메모리**: 수정 및 선호도에 따라 Claude가 자신을 위해 작성하는 노트

이 페이지에서는 다음을 다룹니다:

* [CLAUDE.md 파일 작성 및 구성](#claude-md-files)
* [기존 AGENTS.md를 프로젝트 지침으로 사용](#agents-md)하기
* [`.claude/rules/`를 사용하여 특정 파일 유형에 규칙 범위 지정](#organize-rules-with-claude/rules/)
* [자동 메모리 구성](#auto-memory)하여 Claude가 자동으로 노트를 작성하도록 함
* [지침이 따라지지 않을 때 문제 해결](#troubleshoot-memory-issues)

## CLAUDE.md vs 자동 메모리

Claude Code에는 두 가지 상호 보완적인 메모리 시스템이 있습니다. 둘 다 모든 대화의 시작 시 로드됩니다. Claude는 이들을 강제된 구성이 아닌 컨텍스트로 취급합니다. 작업을 차단하려면 어떤 Claude의 결정과 관계없이 [PreToolUse 훅](https://code.claude.com/docs/ko/hooks-guide.md)을 사용합니다. 지침이 더 구체적이고 간결할수록 Claude가 더 일관되게 따릅니다.

| | CLAUDE.md 파일 | 자동 메모리 |
| :- | :- | :- |
| **작성자** | 사용자 | Claude |
| **포함 내용** | 지침 및 규칙 | 학습 및 패턴 |
| **범위** | 프로젝트, 사용자 또는 조직 | 저장소당, 작업 트리 전체에서 공유 |
| **로드 대상** | 모든 세션 | 모든 세션(처음 200줄 또는 25KB) |
| **사용 목적** | 코딩 표준, 워크플로우, 프로젝트 아키텍처 | 사용자의 선호도, Claude에게 제공한 수정 사항, Claude가 코드에서 파악할 수 없는 프로젝트 컨텍스트 |

Claude의 동작을 안내하려면 CLAUDE.md 파일을 사용합니다. 자동 메모리를 통해 Claude는 수동 작업 없이 수정 사항에서 학습할 수 있습니다.

Subagent도 자신의 자동 메모리를 유지할 수 있습니다. 자세한 내용은 [subagent 구성](https://code.claude.com/docs/ko/sub-agents.md#enable-persistent-memory)을 참조하세요.

## CLAUDE.md 파일

CLAUDE.md 파일은 Claude에게 프로젝트, 개인 워크플로 또는 전체 조직을 위한 지속적인 지침을 제공하는 마크다운 파일입니다. 이 파일들을 일반 텍스트로 작성하면 Claude가 매 세션의 시작 시 이를 읽습니다. 저장소에서 `AGENTS.md`를 대신 사용하는 경우 [AGENTS.md](#agents-md)를 참조하십시오.

### CLAUDE.md에 추가할 시기

CLAUDE.md를 다시 설명해야 할 내용을 기록하는 장소로 생각하십시오. 다음과 같은 경우에 추가하십시오:

* Claude가 같은 실수를 두 번째로 반복할 때
* 코드 리뷰에서 Claude가 이 코드베이스에 대해 알아야 할 사항을 지적할 때
* 지난 세션에 입력한 것과 같은 수정 사항이나 설명을 채팅에 다시 입력할 때
* 새로운 팀원이 생산성을 높이기 위해 같은 컨텍스트가 필요할 때

매 세션마다 Claude가 보유해야 할 사실들로 유지하십시오: 빌드 명령, 규칙, 프로젝트 레이아웃, "항상 X를 수행하라"는 규칙. 항목이 다단계 절차이거나 코드베이스의 한 부분에만 해당하는 경우 [스킬](https://code.claude.com/docs/ko/skills.md) 또는 [경로 범위 규칙](#organize-rules-with-claude/rules/)으로 이동하십시오. [확장 기능 개요](https://code.claude.com/docs/ko/features-overview.md#build-your-setup-over-time)에서 각 메커니즘을 사용할 시기를 다룹니다.

### CLAUDE.md 파일을 어디에 배치할지 선택하기

CLAUDE.md 파일은 여러 위치에 있을 수 있으며, 각각 다른 범위를 가집니다. 아래 표는 로드 순서대로 나열되어 있으며, 가장 광범위한 범위에서 가장 구체적인 범위까지이므로 프로젝트 지침이 사용자 지침 이후에 컨텍스트에 나타납니다.

| 범위 | 위치 | 목적 | 사용 사례 예시 | 공유 대상 |
| - | - | - | - | - |
| **관리형 정책** | • macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md` • Linux 및 WSL: `/etc/claude-code/CLAUDE.md` • Windows: `C:\Program Files\ClaudeCode\CLAUDE.md` | IT/DevOps에서 관리하는 조직 전체 지침 | 회사 코딩 표준, 보안 정책, 규정 준수 요구사항 | 조직의 모든 사용자 |
| **사용자 지침** | `~/.claude/CLAUDE.md` | 모든 프로젝트에 대한 개인 선호도 | 코드 스타일 선호도, 개인 도구 단축키 | 본인만 (모든 프로젝트) |
| **프로젝트 지침** | `./CLAUDE.md` 또는 `./.claude/CLAUDE.md`. `./AGENTS.md`가 이들 대신 또는 함께 로드되는 시기는 [AGENTS.md](#agents-md)를 참조하십시오 | 프로젝트를 위한 팀 공유 지침 | 프로젝트 아키텍처, 코딩 표준, 일반적인 워크플로 | 소스 제어를 통한 팀 멤버 |
| **로컬 지침** | `./CLAUDE.local.md` | 개인 프로젝트별 선호도; `.gitignore`에 추가 | 샌드박스 URL, 선호하는 테스트 데이터 | 본인만 (현재 프로젝트) |

작업 디렉터리 위의 디렉터리 계층 구조에 있는 CLAUDE.md 및 CLAUDE.local.md 파일은 시작 시 로드됩니다. 하위 디렉터리의 파일은 필요에 따라 로드됩니다. 로드 시점과 전체 해석 순서는 [CLAUDE.md 파일이 로드되는 방식](#how-claude-md-files-load)을 참조하십시오.

대규모 프로젝트의 경우 [프로젝트 규칙](#organize-rules-with-claude/rules/)을 사용하여 지침을 주제별 파일로 나눌 수 있습니다. 규칙을 사용하면 특정 파일 유형이나 하위 디렉터리로 지침의 범위를 지정할 수 있습니다.

### 프로젝트 CLAUDE.md 설정하기

프로젝트 CLAUDE.md는 `./CLAUDE.md` 또는 `./.claude/CLAUDE.md`에 저장할 수 있습니다. 이 파일을 만들고 프로젝트에서 작업하는 모든 사람에게 적용되는 지침을 추가하십시오: 빌드 및 테스트 명령, 코딩 표준, 아키텍처 결정, 명명 규칙 및 일반적인 워크플로. 이 지침은 버전 제어를 통해 팀과 공유되므로 개인 선호도보다는 프로젝트 수준의 표준에 집중하십시오. 파일이 로드되었는지 확인하려면 세션에서 `/context`를 실행하고 **Memory files** 아래의 목록을 확인하십시오.

> [!TIP]
>
> `/init`을 실행하여 시작 CLAUDE.md를 자동으로 생성하십시오. Claude가 코드베이스를 분석하고 발견한 빌드 명령, 테스트 지침 및 프로젝트 규칙이 포함된 파일을 만듭니다. CLAUDE.md가 이미 존재하는 경우 `/init`은 덮어쓰지 않고 개선 사항을 제안합니다. 거기서부터 Claude가 자체적으로 발견하지 못할 지침으로 개선하십시오.
>
> 대화형 다단계 흐름을 사용하려면 `/init`을 실행하기 전에 `CLAUDE_CODE_NEW_INIT` 환경 변수를 `1`로 설정하십시오. 셸에서 설정하거나 [환경 변수 설정](https://code.claude.com/docs/ko/env-vars.md#set-environment-variables)에 표시된 대로 설정 파일의 `env` 블록에서 설정하십시오. 설정하면 `/init`은 설정할 아티팩트를 묻습니다: CLAUDE.md 파일, 스킬 및 훅. 그런 다음 서브에이전트로 코드베이스를 탐색하고, 후속 질문을 통해 빈 부분을 채우고, 파일을 작성하기 전에 검토 가능한 제안을 제시합니다. 이 변수는 `/init`이 실행되는 방식만 변경하므로 설정된 상태로 둘 수 있습니다.

### 효과적인 지침 작성하기

Claude는 CLAUDE.md 파일을 강제된 구성이 아닌 컨텍스트로 취급하므로, 지침을 작성하는 방식이 Claude가 이를 따르는 신뢰성에 영향을 미칩니다. 검증할 수 있을 정도로 구체적인 지침을 작성하십시오:

* "코드를 적절히 포맷하십시오" 대신 "2칸 들여쓰기 사용"
* "변경 사항을 테스트하십시오" 대신 "커밋하기 전에 `npm test` 실행"
* "파일을 정리하십시오" 대신 "API 핸들러는 `src/api/handlers/`에 위치"

파일을 짧고, 정리되고, 일관되게 유지하십시오:

* **크기**: CLAUDE.md 파일당 200줄 이하를 목표로 하십시오. 더 긴 파일은 더 많은 컨텍스트를 소비하고 준수를 감소시킵니다. 코드베이스의 일부에만 해당하는 지침을 [경로 범위 규칙](#path-specific-rules)으로 이동하십시오. 이러한 규칙은 Claude가 일치하는 파일로 작업할 때만 로드됩니다. [가져오기](#import-additional-files)는 긴 파일을 정리하는 데 도움이 되지만 컨텍스트 비용을 줄이지는 않습니다. 가져온 파일은 이를 가져오는 CLAUDE.md와 함께 로드되기 때문입니다.
* **구조**: 관련 지침을 마크다운 헤더와 글머리 기호로 그룹화하십시오. 정리된 섹션은 조밀한 단락보다 Claude가 따르기 쉽습니다.
* **일관성**: 두 지침이 서로 모순되면 Claude가 임의로 하나를 선택할 수 있습니다. CLAUDE.md 파일, 하위 디렉터리의 중첩된 CLAUDE.md 파일 및 [`.claude/rules/`](#organize-rules-with-claude/rules/)을 주기적으로 검토하여 오래되었거나 충돌하는 지침을 제거하십시오. Claude가 이를 대신 찾도록 하려면 [프롬프트 감사를 실행](#audit-your-instruction-files)하십시오.

#### 지침 파일 감사하기

Claude가 지침 파일에서 오래되었거나 충돌하는 내용을 확인하도록 하려면 세션에서 `/doctor prompt-audit`을 실행하십시오. Claude는 이전 모델용으로 작성된 지침, 존재하지 않는 파일 또는 명령에 대한 참조, 서로 모순되는 파일 등의 문제를 찾습니다. 발견 사항과 제안된 편집이 담긴 보고서가 제공되며, Claude에게 적용하도록 요청할 때까지 파일의 아무것도 변경되지 않습니다.

기본적으로 감사는 CLAUDE.md, CLAUDE.local.md 및 AGENTS.md 파일과 `.claude/` 및 `~/.claude/` 아래의 규칙, 스킬, 명령, 서브에이전트 및 출력 스타일을 다룹니다. 대신 하나의 파일 또는 디렉터리를 감사하려면 경로를 전달하십시오(예: `/doctor prompt-audit .claude/skills/deploy`).

감사는 번들된 `/claude-api` 스킬을 통해 실행됩니다. [`skillOverrides`](https://code.claude.com/docs/ko/skills#override-skill-visibility-from-settings)에서 해당 스킬이 꺼져 있거나 [`disableBundledSkills`](https://code.claude.com/docs/ko/settings-reference#disablebundledskills)로 비활성화되어 있는 동안에는 사용할 수 없습니다. `/doctor prompt-audit`은 Claude Code v2.1.283 이상이 필요합니다.

### 추가 파일 가져오기

CLAUDE.md 파일은 `@path/to/import` 구문을 사용하여 추가 파일을 가져올 수 있습니다. 가져온 파일은 확장되어 이를 참조하는 CLAUDE.md와 함께 컨텍스트에 로드됩니다.

상대 경로와 절대 경로 모두 허용됩니다. 상대 경로는 작업 디렉터리가 아닌 가져오기를 포함하는 파일을 기준으로 해석됩니다. 가져온 파일은 최대 4홉의 깊이로 다른 파일을 재귀적으로 가져올 수 있습니다.

경로에 공백이 포함된 파일을 가져오려면 각 공백 앞에 백슬래시를 붙이십시오. 백슬래시가 없으면 경로가 첫 번째 공백에서 끝나며, 가져오기가 자신의 줄에 있더라도 마찬가지입니다. 따옴표로 감싼 경로는 백슬래시 유무에 관계없이 가져오지 않습니다. 이 가져오기는 `Design Docs`라는 폴더에서 파일을 로드합니다:

```text theme={null}
- API conventions @Design\ Docs/api-conventions.md
```

가져오기 구문 분석은 마크다운 코드 스팬과 펜스된 코드 블록을 건너뜁니다. CLAUDE.md에서 경로를 언급하되 가져오지 않으려면 백틱으로 감싸십시오: `` `@README` ``를 작성하면 텍스트가 리터럴로 유지되고, 백틱 외부의 `@README`는 파일을 가져옵니다.

README, package.json 및 워크플로 가이드를 가져오려면 CLAUDE.md의 어디든지 `@` 구문으로 참조하십시오:

```text theme={null}
See @README for project overview and @package.json for available npm commands for this project.

# Additional Instructions
- git workflow @docs/git-instructions.md
```

버전 제어에 체크인되지 않아야 하는 개인 프로젝트별 선호도의 경우 프로젝트 루트에 `CLAUDE.local.md`를 만드십시오. 이는 `CLAUDE.md`와 함께 로드되고 같은 방식으로 처리됩니다. `CLAUDE.local.md`를 `.gitignore`에 추가하여 커밋되지 않도록 하십시오. `CLAUDE_CODE_NEW_INIT=1`이 설정된 상태에서 `/init`을 실행하고 개인 옵션을 선택하면 이를 자동으로 수행합니다.

같은 저장소의 여러 git worktree에서 작업하는 경우, gitignored `CLAUDE.local.md`는 생성한 worktree에만 존재합니다. 여러 worktree에서 개인 지침을 공유하려면 대신 홈 디렉터리에서 파일을 가져오십시오:

```text theme={null}
# Individual Preferences
- @~/.claude/my-project-instructions.md
```

> [!WARNING]
>
> 프로젝트 수준 메모리 파일의 가져오기는 위의 홈 디렉터리 가져오기와 같이 경로가 작업 디렉터리 외부로 해석될 때 외부 가져오기입니다. Claude Code가 프로젝트에서 외부 가져오기를 처음 만날 때 파일을 나열하는 승인 대화 상자를 표시합니다. 거부하면 가져오기가 비활성화된 상태로 유지되고 대화 상자가 다시 나타나지 않습니다.
>
> Claude Code는 다른 사람이 공유 프로젝트에 커밋한 파일로부터 사용자를 보호하기 위해 대화 상자를 표시합니다. `~/.claude/CLAUDE.md` 및 `~/.claude/rules/`와 같은 사용자 범위 메모리 파일은 본인이 작성한 파일입니다. [Cowork](https://claude.com/product/cowork) 데스크톱 세션을 제외하고 Claude Code는 대화 상자 없이 이들의 가져오기를 로드하고 나머지 개인 구성처럼 신뢰합니다.
>
> 데스크톱의 Cowork 세션에서 Claude Code는 사용자 범위 파일에서 세션의 작업 디렉터리 외부의 경로로 해석되는 가져오기를 건너뛰고 파일의 나머지는 로드합니다. 이러한 세션에서는 그 자체가 심볼릭 링크 또는 하드 링크인 `~/.claude/CLAUDE.md`와 작업 디렉터리 외부를 가리키는 심볼릭 링크된 `~/.claude/rules/` 디렉터리 또는 규칙 파일도 건너뜁니다.

### CLAUDE.md 파일이 로드되는 방식

Claude Code는 현재 작업 디렉터리와 그 위의 모든 디렉터리에서 `CLAUDE.md` 및 `CLAUDE.local.md`를 로드합니다. `foo/bar/`에서 Claude Code를 실행하면 `foo/bar/CLAUDE.md`, `foo/CLAUDE.md` 및 이들 옆의 모든 `CLAUDE.local.md` 파일을 로드합니다.

발견된 모든 파일은 서로를 재정의하지 않고 컨텍스트에 연결됩니다. 디렉터리 트리 전체에서 콘텐츠는 파일 시스템 루트에서 작업 디렉터리까지 순서대로 정렬됩니다. `foo/bar/` 예시의 경우 `foo/CLAUDE.md`가 `foo/bar/CLAUDE.md` 이전에 컨텍스트에 나타나므로 Claude를 시작한 위치에 더 가까운 지침이 마지막에 읽힙니다. 각 디렉터리 내에서 `CLAUDE.local.md`는 `CLAUDE.md` 이후에 추가되므로 개인 노트가 해당 수준에서 Claude가 읽는 마지막 항목입니다.

Claude는 또한 현재 작업 디렉터리 아래의 하위 디렉터리에서 `CLAUDE.md` 및 `CLAUDE.local.md` 파일을 발견합니다. 시작 시 로드하지 않고, Claude가 해당 하위 디렉터리의 다른 파일을 읽거나, 쓰거나, 편집하면 Claude Code가 각 파일을 로드합니다. 읽기에는 단일 파일에 대한 `cat` 또는 `head`처럼 [읽기로 간주되는](https://code.claude.com/docs/ko/tools-reference.md#edit-tool-behavior) Bash 명령으로 파일을 보는 것도 포함됩니다. `.claude/worktrees/` 아래의 워크트리 내부 파일에 대해서는 [워크트리로 서브에이전트 격리하기](https://code.claude.com/docs/ko/worktrees.md#isolate-subagents-with-worktrees)를 참조하십시오.

대규모 모노레포에서 작업하고 다른 팀의 CLAUDE.md 파일이 선택되는 경우 [`claudeMdExcludes`](#exclude-specific-claude-md-files)를 사용하여 건너뛰십시오. 루트 및 디렉터리별 CLAUDE.md 파일과 규칙의 전체 레이아웃은 [모노레포 및 대규모 저장소](https://code.claude.com/docs/ko/large-codebases.md)를 참조하십시오.

CLAUDE.md 파일의 블록 수준 HTML 주석(`<!-- maintainer notes -->`)은 Claude의 컨텍스트에 주입되기 전에 제거됩니다. 컨텍스트 토큰을 소비하지 않고 인간 유지보수자를 위한 노트를 남기는 데 사용하십시오. 코드 블록 내의 주석은 보존됩니다. Read 도구로 CLAUDE.md 파일을 직접 열 때 주석이 표시됩니다.

#### 추가 디렉터리에서 로드하기

`--add-dir` 플래그는 Claude에게 주 작업 디렉터리 외부의 추가 디렉터리에 대한 액세스를 제공합니다. 기본적으로 이러한 디렉터리의 CLAUDE.md 파일은 로드되지 않습니다.

추가 디렉터리에서 메모리 파일도 로드하려면 `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` 환경 변수를 설정하십시오:

```bash theme={null}
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ../shared-config
```

인라인 형식은 Bash 또는 Zsh에서 해당 한 번의 시작을 위해 변수를 설정합니다. 모든 세션에서 계속 설정하려면 [환경 변수 설정](https://code.claude.com/docs/ko/env-vars.md#set-environment-variables)에 표시된 대로 `~/.claude/settings.json`의 `env` 블록에 추가하십시오.

이는 추가 디렉터리에서 `CLAUDE.md`, `.claude/CLAUDE.md`, `.claude/rules/*.md` 및 `CLAUDE.local.md`를 로드합니다. [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference)에서 `local`을 제외하면 `CLAUDE.local.md`가 건너뛰어집니다.

### `.claude/rules/`로 규칙 정리하기

더 큰 프로젝트의 경우 `.claude/rules/` 디렉터리를 사용하여 지침을 여러 파일로 정리할 수 있습니다. 이는 지침을 모듈식으로 유지하고 팀이 유지보수하기 쉽게 합니다. 규칙은 또한 [특정 파일 경로로 범위를 지정](#path-specific-rules)할 수 있으므로 Claude가 일치하는 파일로 작업할 때만 컨텍스트에 로드되어 노이즈를 줄이고 컨텍스트 공간을 절약합니다.

> [!NOTE]
>
> 규칙은 매 세션마다 또는 일치하는 파일이 열릴 때 컨텍스트에 로드됩니다. 항상 컨텍스트에 있을 필요가 없는 작업별 지침의 경우 대신 [스킬](https://code.claude.com/docs/ko/skills.md)을 사용하십시오. 스킬은 호출할 때 또는 Claude가 프롬프트와 관련이 있다고 판단할 때만 로드됩니다.

#### 규칙 설정하기

프로젝트의 `.claude/rules/` 디렉터리에 마크다운 파일을 배치하십시오. 각 파일은 `testing.md` 또는 `api-design.md`와 같은 설명적인 파일명으로 한 가지 주제를 다루어야 합니다. 모든 `.md` 파일은 재귀적으로 발견되므로 `frontend/` 또는 `backend/`와 같은 하위 디렉터리로 규칙을 정리할 수 있습니다:

```text theme={null}
your-project/
├── .claude/
│   ├── CLAUDE.md           # Main project instructions
│   └── rules/
│       ├── code-style.md   # Code style guidelines
│       ├── testing.md      # Testing conventions
│       └── security.md     # Security requirements
```

[`paths` frontmatter](#path-specific-rules)가 없는 규칙은 `.claude/CLAUDE.md`와 같은 우선순위로 시작 시 로드됩니다.

프로젝트 규칙은 [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference)에서 `project`를 제외하면 건너뛰어집니다. v2.1.211 이전에는 경로 범위 규칙 및 중첩된 `.claude/rules/` 디렉터리의 규칙을 포함하여 필요에 따라 로드되는 규칙이 `project`가 제외되었을 때도 로드되었습니다.

#### 경로별 규칙

규칙은 `paths` 필드가 있는 YAML frontmatter를 사용하여 특정 파일로 범위를 지정할 수 있습니다. 이러한 조건부 규칙은 Claude가 지정된 패턴과 일치하는 파일로 작업할 때만 적용됩니다.

```markdown theme={null}
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules

- All API endpoints must include input validation
- Use the standard error response format
- Include OpenAPI documentation comments
```

`paths` 필드가 없는 규칙은 무조건 로드되고 모든 파일에 적용됩니다. 경로 범위 규칙은 Claude가 일치하는 파일에 Read, Write 또는 Edit 도구를 사용할 때 로드됩니다. 또한 Claude가 단일 파일에 대한 `cat` 또는 `head`처럼 [읽기로 간주되는](https://code.claude.com/docs/ko/tools-reference.md#edit-tool-behavior) Bash 명령으로 일치하는 파일을 볼 때도 로드됩니다. 일치는 Claude가 프로젝트 디렉터리의 심볼릭 링크된 경로를 통해 파일에 도달할 때도 작동합니다(예: 심볼릭 링크된 체크아웃).

각 패턴은 규칙의 기준 디렉터리를 기준으로 합니다:

* **프로젝트 규칙**: 규칙의 `.claude` 폴더를 포함하는 디렉터리
* **[사용자 수준 규칙](#user-level-rules)**: 세션의 [주 작업 디렉터리](https://code.claude.com/docs/ko/permissions.md#working-directories)

형제 git worktree의 파일에 대해 경로 범위 규칙이 로드되도록 하려면 해당 worktree에서 Claude Code를 시작하거나 [`/cd`로 세션을 그곳으로 이동](https://code.claude.com/docs/ko/permissions#move-the-session-to-another-directory)하십시오.

`paths` 필드에서 glob 패턴을 사용하여 확장자, 디렉터리 또는 조합으로 파일을 일치시키십시오:

| 패턴 | 일치 |
| - | - |
| `**/*.ts` | 모든 디렉터리의 모든 TypeScript 파일 |
| `src/**/*` | `src/` 디렉터리 아래의 모든 파일 |
| `*.md` | 프로젝트 루트의 마크다운 파일 |
| `src/components/*.tsx` | 특정 디렉터리의 React 컴포넌트 |

여러 패턴을 지정하고 중괄호 확장을 사용하여 한 패턴에서 여러 확장자를 일치시킬 수 있습니다:

```markdown theme={null}
---
paths:
  - "src/**/*.{ts,tsx}"
  - "lib/**/*.ts"
  - "tests/**/*.test.ts"
---
```

각 중괄호 그룹은 확장된 패턴의 수를 곱합니다: `src/*.{ts,tsx}`는 두 패턴으로 확장되고, `{a,b}/{c,d}/*.{ts,tsx}`는 8개로 확장됩니다. 확장을 제한하기 위해 규칙의 전체 `paths` 목록은 1,000개 확장된 패턴과 4 MiB의 하나의 예산을 공유하며, 중괄호가 없는 패턴은 이에 대해 계산되지 않습니다.

Claude Code는 예산을 초과할 패턴을 확장되지 않은 상태로 사용하며, 리터럴 중괄호는 파일과 일치하지 않습니다.

Glob 구문은 `[`를 `[abc]`와 같은 괄호 표현식의 시작으로 취급합니다. `photos [2024/**`와 같이 괄호 표현식으로 읽을 수 없는 `[`가 있는 패턴은 유효하지 않습니다: 아무것도 일치하지 않으며 규칙의 다른 패턴은 계속 작동합니다. 파일 이름의 리터럴 `[`를 일치시키려면 `photos \[2024/**`로 이스케이프하십시오.

#### 규칙 frontmatter 참조

파일 상단의 `---` 마커 사이에 YAML [frontmatter](https://code.claude.com/docs/ko/glossary.md#frontmatter)를 사용하여 규칙을 구성하십시오. `paths`는 Claude Code가 규칙에서 읽는 유일한 필드입니다. 다른 필드는 오류 없이 무시됩니다. Claude Code는 규칙을 컨텍스트에 로드하기 전에 frontmatter를 제거합니다.

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `paths` | 아니오 | [규칙을 일치하는 파일로 범위를 지정](#path-specific-rules)하는 Glob 패턴. YAML 목록 또는 쉼표로 구분된 문자열을 허용합니다 |

마커 사이의 YAML이 구문 분석되지 않으면 Claude Code는 frontmatter를 무시하고 `paths`가 없는 것처럼 규칙을 로드합니다. `claude --debug`를 실행하여 구문 분석 오류를 확인하십시오.

#### 심볼릭 링크로 프로젝트 간 규칙 공유하기

`.claude/rules/` 디렉터리는 심볼릭 링크를 지원하므로 공유 규칙 세트를 유지하고 여러 프로젝트에 링크할 수 있습니다. 순환 심볼릭 링크는 감지되고 우아하게 처리됩니다.

Claude Code는 대상이 작업 디렉터리 외부인 심볼릭 링크를 [외부 가져오기](#import-additional-files)처럼 취급합니다. 링크된 규칙은 프로젝트에 대한 외부 가져오기를 승인할 때까지 로드되지 않으며, 그 후 [`paths` 필드](#path-specific-rules)가 없는 규칙만 로드됩니다.

Claude Code는 대화형 세션 시작 시 대화 상자를 통해 프로젝트당 한 번 해당 승인을 요청합니다. 대화 상자에는 외부 `@path` 가져오기와 함께 링크된 규칙 파일이 나열됩니다. 해당 승인 없이 공유 규칙을 로드하려면 [`~/.claude/rules/`](#user-level-rules)에 유지하십시오. 여기서 컴퓨터의 모든 프로젝트에 적용됩니다.

이 예시는 공유 디렉터리와 개별 파일을 모두 링크합니다:

```bash theme={null}
ln -s ~/shared-claude-rules .claude/rules/shared
ln -s ~/company-standards/security.md .claude/rules/security.md
```

네트워크 경로(예: UNC 공유 `\\server\share` 또는 `/net` 또는 `/Network` 아래의 경로)에 `.claude/rules/` 또는 `CLAUDE.md` 심볼릭 링크를 가리키면 링크된 지침이 로드되지 않습니다. Claude Code는 이러한 경로를 조회하면 해당 경로가 가리키는 호스트에 연결할 수 있으므로 링크를 따르지 않습니다. `\\wsl$` 경로는 네트워크 경로로 계산되지 않습니다.

#### 사용자 수준 규칙

`~/.claude/rules/`의 개인 규칙은 컴퓨터의 모든 프로젝트에 적용됩니다. 프로젝트별이 아닌 선호도에 사용하십시오:

```text theme={null}
~/.claude/rules/
├── preferences.md    # Your personal coding preferences
└── workflows.md      # Your preferred workflows
```

Claude Code는 사용자 수준 규칙을 프로젝트 규칙 이전에 로드하므로 프로젝트 규칙이 Claude의 컨텍스트에서 사용자 규칙보다 나중에 나타납니다. 어느 쪽도 다른 쪽을 재정의하지 않습니다: 사용자 규칙과 프로젝트 규칙이 충돌하면 Claude가 둘 중 하나를 따를 수 있으므로 둘을 일관되게 유지하십시오.

### 대규모 팀을 위한 CLAUDE.md 관리하기

Claude Code를 팀 전체에 배포하는 조직의 경우 지침을 중앙화하고 로드되는 CLAUDE.md 파일을 제어할 수 있습니다.

#### 조직 전체 CLAUDE.md 배포하기

조직은 머신의 모든 사용자에게 적용되는 중앙 관리 CLAUDE.md를 배포할 수 있습니다. 개발자는 `claudeMdExcludes` 설정으로 [다른 CLAUDE.md 파일을 제외](#exclude-specific-claude-md-files)할 수 있지만 이 파일은 제외할 수 없습니다. 개발자가 CLAUDE.md 로드를 완전히 끈 상태로 세션을 시작하면 해당 세션은 관리형 콘텐츠도 로드하지 않습니다. 이 파일은 지침용으로 사용하고, 규칙은 `permissions.deny`와 같은 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)으로 강제하십시오.

**1. 관리형 정책 위치에 파일 만들기**

* macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`
* Linux 및 WSL: `/etc/claude-code/CLAUDE.md`
* Windows: `C:\Program Files\ClaudeCode\CLAUDE.md`

**2. 구성 관리 시스템으로 배포하기**

MDM, Group Policy, Ansible 또는 유사한 도구를 사용하여 개발자 머신 전체에 파일을 배포하십시오. 다른 조직 전체 구성 옵션은 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 참조하십시오.

`claudeMd` 키를 사용하면 별도 파일을 배포하는 대신 관리형 CLAUDE.md 콘텐츠를 `managed-settings.json`에 직접 배치할 수 있습니다.

**범위**: 머신의 모든 사용자, 모든 저장소에서. 저장소별 지침의 경우 프로젝트 CLAUDE.md를 대신 커밋하십시오.

**우선순위**: 관리형 CLAUDE.md 파일과 동일합니다. 사용자 및 프로젝트 CLAUDE.md 이전에 로드됩니다.

**적용되는 위치**: 관리형 및 정책 설정만. 사용자, 프로젝트 또는 로컬 설정에서 `claudeMd`를 설정해도 효과가 없습니다.

아래 예시는 관리형 설정 파일에 직접 동작 지침을 추가합니다:

```json theme={null}
{
  "claudeMd": "Always run `make lint` before committing.\nNever push directly to main."
}
```

관리형 CLAUDE.md와 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)은 다른 목적을 제공합니다. 기술적 강제를 위해 설정을 사용하고 CLAUDE.md를 동작 지침에 사용하십시오:

| 관심사 | 구성 위치 |
| :- | :- |
| 특정 도구, 명령 또는 파일 경로 차단 | 관리형 설정: `permissions.deny` |
| 샌드박스 격리 강제 | 관리형 설정: `sandbox.enabled` |
| 환경 변수 및 API 제공자 라우팅 | 관리형 설정: `env` |
| 로그인 방법 및 조직 제한 | 관리형 설정: `forceLoginMethod`, `forceLoginOrgUUID` |
| 코드 스타일 및 품질 가이드라인 | 관리형 CLAUDE.md |
| 데이터 처리 및 규정 준수 알림 | 관리형 CLAUDE.md |
| Claude의 동작 지침 | 관리형 CLAUDE.md |

설정 규칙은 Claude가 무엇을 하기로 결정하든 클라이언트에 의해 강제됩니다. CLAUDE.md 지침은 Claude의 동작을 형성하지만 하드 강제 계층이 아닙니다.

#### 특정 CLAUDE.md 파일 제외하기

대규모 모노레포에서 상위 CLAUDE.md 파일에는 작업과 관련이 없는 지침이 포함될 수 있습니다. `claudeMdExcludes` 설정을 사용하면 경로 또는 glob 패턴으로 특정 파일을 건너뛸 수 있습니다. [관리형 CLAUDE.md 파일](#deploy-organization-wide-claude-md)은 `claudeMdExcludes`로 제외할 수 없습니다.

이 예시는 상위 폴더의 최상위 CLAUDE.md 및 규칙 디렉터리를 제외합니다. `.claude/settings.local.json`에 추가하여 제외가 머신에 로컬로 유지되도록 하십시오:

```json theme={null}
{
  "claudeMdExcludes": [
    "**/monorepo/CLAUDE.md",
    "/home/user/monorepo/other-team/.claude/rules/**"
  ]
}
```

패턴은 glob 구문을 사용하여 절대 파일 경로와 일치합니다. 사용자, 프로젝트, 로컬 또는 관리형 정책을 포함한 모든 [설정 계층](https://code.claude.com/docs/ko/settings.md#where-settings-live)에서 `claudeMdExcludes`를 구성할 수 있습니다. 배열은 계층 전체에서 병합됩니다.

[심볼릭 링크](#share-rules-across-projects-with-symlinks)를 통해 도달하는 규칙 파일을 제외하려면, 파일 또는 해당 디렉터리가 링크인지 여부에 관계없이 두 경로 중 하나에 대해 패턴을 작성하십시오: `.claude/rules/` 아래의 파일 경로 또는 링크 대상. 두 경로 중 하나와 일치하는 패턴은 파일을 제외합니다. v2.1.239 이전에는 링크 대상과 일치하는 패턴만 파일을 제외했습니다.

## AGENTS.md

Claude Code는 [`AGENTS.md`](https://code.claude.com/docs/ko/glossary#agents-md)를 프로젝트 지침으로 읽을 수 있으므로, 다른 코딩 에이전트를 위해 이미 설정된 저장소는 `CLAUDE.md`, 가져오기 또는 설정을 추가할 필요 없이 작동합니다. 이 표는 저장소의 지침 파일 조합에 따라 Claude가 기본적으로 읽는 내용을 보여줍니다:

| 저장소에 있는 파일 | Claude가 읽는 내용 |
| :- | :- |
| `AGENTS.md`가 있고, 작업 디렉토리 또는 그 위에 `CLAUDE.md` 또는 `CLAUDE.local.md`가 없음 | `AGENTS.md` |
| `AGENTS.md`와 작업 디렉토리 또는 그 위에 `CLAUDE.md` 또는 `CLAUDE.local.md`가 있음 | `CLAUDE.md` 파일만 |
| 이미 [`AGENTS.md`를 가져오는](#share-one-file-with-other-coding-tools) `CLAUDE.md`가 있음 | `CLAUDE.md`, 가져오기를 통해 포함된 `AGENTS.md` |

기본값을 변경하려면, 예를 들어 Claude가 항상 두 파일을 모두 읽도록 하거나, `CLAUDE.md`만 읽도록 하거나, 조직의 관리되는 지침만 읽도록 하려면 [**프로젝트 지침** 설정을 변경](#choose-which-instruction-files-load)하십시오.

> [!NOTE]
>
> `AGENTS.md`를 직접 읽으려면 Claude Code v2.1.277 이상이 필요합니다. 일부 세션에서는 Claude가 [`AGENTS.md`를 읽을 수 없으므로](#when-agents-md-support-is-unavailable), 대신 [`CLAUDE.md`에서 가져오십시오](#share-one-file-with-other-coding-tools).

### Claude Code가 AGENTS.md를 읽을 때

기본적으로 Claude는 작업 디렉토리 또는 그 위에 `CLAUDE.md`가 없을 때만 `AGENTS.md`를 읽습니다. 다음은 해당 확인에 포함되는 파일입니다:

* **포함되므로 Claude가 `AGENTS.md` 대신 읽음**: 작업 디렉토리 또는 그 위의 `CLAUDE.md`, `.claude/CLAUDE.md` 또는 `CLAUDE.local.md`
* **포함되지 않으며 `AGENTS.md`와 함께 계속 로드됨**: `~/.claude/CLAUDE.md`, 조직의 관리되는 `CLAUDE.md`, `.claude/rules/` 파일

포함되는 파일이 없을 때, Claude가 읽는 내용과 확인 방법은 다음과 같습니다:

* **세션 시작 시**: 작업 디렉토리와 그 위의 디렉토리에 있는 모든 `AGENTS.md`와 `.claude/AGENTS.md`. 대화형 세션에서는 `no CLAUDE.md found; AGENTS.md loaded: /home/you/repo/AGENTS.md`와 같은 줄이 표시됩니다
* **Claude가 하위 디렉토리에서 작업할 때**: 하위 디렉토리에 Read 도구로 파일을 열 때, 해당 하위 디렉토리에 세 가지 `CLAUDE.md` 파일이 없으면 그 하위 디렉토리의 `AGENTS.md`
* **각 `AGENTS.md` 내부**: [`@path` 가져오기](#import-additional-files)가 확장되고, [`claudeMdExcludes`](#exclude-specific-claude-md-files) 패턴이 적용되며, [프로젝트 지침 없이 시작하는](https://code.claude.com/docs/ko/sub-agents.md#what-loads-at-startup) 서브에이전트는 이 파일들도 없이 시작합니다
* **읽지 않음**: `AGENTS.local.md`, `AGENTS.override.md` 또는 `.agents/` 디렉토리 아래의 모든 것

> [!NOTE]
>
> `CLAUDE.local.md`가 포함되므로, `AGENTS.md`에 의존하는 프로젝트에 개인 메모용으로 추가하면 Claude가 더 이상 `AGENTS.md`를 읽지 않습니다. `CLAUDE.local.md`를 유지하면서 Claude가 `AGENTS.md`를 읽도록 하려면 **프로젝트 지침**을 [`claude-md-and-agents-md`](#choose-which-instruction-files-load)로 설정하십시오.

### 로드할 지침 파일 선택

Claude가 읽는 파일을 변경하려면, Claude Code 세션에서 `/config`를 입력하여 설정 패널을 열고, **프로젝트 지침**을 다음 값 중 하나로 설정합니다:

| 값 | Claude가 읽는 내용 |
| :- | :- |
| `claude-md-or-agents-md` | `CLAUDE.md` 파일, 또는 작업 디렉토리 또는 그 위에 `CLAUDE.md` 또는 `CLAUDE.local.md`가 없을 때 `AGENTS.md` 파일. 이것이 기본값입니다 |
| `claude-md-and-agents-md` | `CLAUDE.md`와 `AGENTS.md` 파일을 함께, 각 디렉토리의 `CLAUDE.md` 파일을 먼저 읽고 그 다음 `AGENTS.md`. Claude Code는 이미 로드한 `AGENTS.md`를 건너뜁니다. 따라서 `CLAUDE.md`가 가져오거나 심볼릭 링크하는 것은 두 번 읽지 않습니다 |
| `claude-md` | `CLAUDE.md` 파일만 |
| `managed-only` | 시작 시 조직의 관리형 `CLAUDE.md`와 [자동 메모리](#auto-memory)만. 프로젝트, 로컬 및 사용자 `CLAUDE.md` 파일, `.claude/rules/` 파일 및 모든 `AGENTS.md`는 제외됩니다. 하위 디렉터리의 `CLAUDE.md`와 `.claude/rules/` 파일, 그리고 [경로 범위 규칙](#path-specific-rules)은 여전히 필요할 때 로드됩니다 |

`/config` 대신 설정 파일에서 값을 설정할 수도 있습니다. `AGENTS.md`를 읽는 내장 플러그인의 ID인 `cc-plugin-agents-md@builtin` 아래의 [`pluginConfigs`](https://code.claude.com/docs/ko/settings-reference#pluginconfigs)에 추가합니다. Claude Code는 `~/.claude/settings.json`, `--settings` 파일 또는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 이 항목을 읽으며, 프로젝트 및 로컬 설정 파일에서는 무시합니다. 이 예제는 Claude가 두 파일을 모두 읽도록 합니다:

```json settings.json theme={null}
{
  "pluginConfigs": {
    "cc-plugin-agents-md@builtin": {
      "options": { "instructionFiles": "claude-md-and-agents-md" }
    }
  }
}
```

v2.1.285 이전에는 플러그인의 ID가 `agents-md@builtin`이었으며, Claude Code는 `cc-plugin-agents-md@builtin` 아래의 항목을 무시했습니다. 이전 버전에서도 설정 파일을 읽는 경우 해당 파일에서는 `agents-md@builtin`을 사용하십시오. Claude Code v2.1.285 이상은 두 ID 중 어느 쪽 아래의 항목이든 읽습니다.

변경 사항은 다음 메시지를 보낼 때와 모든 새 세션에서 적용됩니다.

### AGENTS.md 지원을 사용할 수 없을 때

이러한 세션에서 Claude는 `CLAUDE.md` 파일만 읽으며, `/config` 설정 패널에서 **프로젝트 지침**이 나타나지 않습니다:

* v2.1.277 이전의 Claude Code 버전을 사용 중입니다
* `/plugin`을 사용하여 `AGENTS.md`를 읽는 내장 플러그인을 비활성화했습니다
* 일부 경우, v2.1.276 이상에서 [업그레이드한 후 첫 번째 세션](https://code.claude.com/docs/ko/env-vars.md#first-session-after-an-install-or-upgrade)입니다. Claude는 다음 세션부터 `AGENTS.md`를 읽습니다

v2.1.281 이전에는 Amazon Bedrock의 세션이나 원격 측정이 비활성화된 세션과 같은 일부 세션에서 `CLAUDE.md` 파일만 읽었습니다. 이러한 버전에서는 Claude Code를 업데이트하십시오. 이러한 세션에서 Claude에 `AGENTS.md`를 제공하려면 [`CLAUDE.md`에서 가져오십시오](#share-one-file-with-other-coding-tools).

### AGENTS.md가 CLAUDE.md와 다른 점

Claude가 **프로젝트 지침** 설정을 통해 읽는 `AGENTS.md`는 다음과 같은 방식으로 `CLAUDE.md`와 다릅니다:

| | `CLAUDE.md` | 설정을 통해 읽은 `AGENTS.md` |
| :- | :- | :- |
| [`InstructionsLoaded` 훅](https://code.claude.com/docs/ko/hooks#instructionsloaded) | 실행됨 | 실행되지 않음. `CLAUDE.md`가 가져오거나 심볼릭 링크하는 `AGENTS.md`의 경우 평소대로 실행됨 |
| [`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD`](#load-from-additional-directories)가 설정되었을 때 `--add-dir`으로 추가한 디렉토리 | 해당 `CLAUDE.md` 로드 | 해당 `AGENTS.md` 로드 안 함 |
| 작업 디렉토리 외부 파일의 `@path` 가져오기 | Claude Code가 [외부 가져오기](#import-additional-files) 승인을 요청함 | 이 프로젝트에 대해 이미 외부 가져오기를 승인한 경우에만 로드, 프롬프트 없음 |

### 이전 AGENTS.md 해결 방법 제거

Claude Code가 자체적으로 `AGENTS.md`를 읽기 전에 설정한 경우, 각 일반적인 설정에서 수행할 작업은 다음과 같습니다:

* **`@AGENTS.md`를 포함하는 `CLAUDE.md`**: 그대로 둘 수 있습니다. 가져오기를 유지하면 Claude가 `AGENTS.md`를 두 번 읽지 않습니다. 어떤 **프로젝트 지침** 값을 사용하든 상관없습니다. 파일에 다른 내용이 없으면 `CLAUDE.md`를 제거하거나, 일부 세션이 [`AGENTS.md`를 직접 로드할 수 없으면](#when-agents-md-support-is-unavailable) 유지하십시오.
* **Claude에게 `AGENTS.md`를 읽으라고 말하는 `CLAUDE.md`**: Claude는 파일을 열기로 결정한 경우에만 `AGENTS.md`를 봅니다. `CLAUDE.md`를 삭제하여 Claude가 `AGENTS.md`를 직접 읽도록 하거나, 문장을 `@AGENTS.md` 가져오기로 바꾸십시오.
* **`AGENTS.md`로 심볼릭 링크된 `CLAUDE.md`**: 아무것도 없거나 심볼릭 링크를 삭제합니다. 어느 쪽이든 Claude는 내용을 한 번 읽습니다.
* **`AGENTS.md`를 인쇄하는 `SessionStart` 훅**: 제거합니다. Claude가 `AGENTS.md`를 직접 읽으면, 훅은 컨텍스트에 두 번째 복사본을 추가합니다.

### 다른 코딩 도구와 한 파일 공유

Claude가 `AGENTS.md`를 직접 읽지 않을 때, 옆에 있는 `CLAUDE.md`에 `@AGENTS.md` 가져오기를 넣어 모든 도구가 공유하는 한 파일로 유지할 수 있습니다. 프로젝트에 `CLAUDE.md`도 있을 때, **프로젝트 지침**을 `claude-md`로 설정했을 때 또는 [`AGENTS.md`를 로드할 수 없는](#when-agents-md-support-is-unavailable) 세션에서 이를 수행합니다. Claude 특정 지침을 가져오기 아래에 추가하면, Claude는 가져온 파일을 먼저 읽은 다음 나머지를 읽습니다:

```markdown CLAUDE.md theme={null}
@AGENTS.md

## Claude Code

Use plan mode for changes under `src/billing/`.
```

Claude 특정 내용이 필요하지 않으면 심볼릭 링크도 작동합니다:

```bash theme={null}
ln -s AGENTS.md CLAUDE.md
```

명령은 성공 시 출력을 인쇄하지 않습니다. 심볼릭 링크를 가져오기 대신 선택하기 전에 다음 제약 사항을 확인하십시오:

* **편집**: Claude는 링크를 통해 `CLAUDE.md`를 읽지만, Edit 및 Write 도구는 [심볼릭 링크를 통해 쓰기를 거부](https://code.claude.com/docs/ko/errors.md#refusing-after-a-symlink-changed)하며, 거부는 Claude에게 링크의 대상인 `AGENTS.md`를 대신 편집하도록 지시합니다
* **Windows**: 저장소를 복제하는 사람이 Windows에서 작업하면 `@AGENTS.md` 가져오기를 대신 사용하십시오. 거기서 심볼릭 링크를 만들려면 관리자 권한 또는 개발자 모드가 필요하며, Git은 `core.symlinks`가 활성화되지 않으면 커밋된 심볼릭 링크를 일반 텍스트 파일로 체크아웃합니다. 이는 해당 복제본에 지침 대신 한 줄의 `CLAUDE.md`를 남깁니다

두 방법 모두 다음 세션에서 `/context`를 실행하고 `CLAUDE.md`가 **메모리 파일** 아래에 나타나는지 확인합니다.

### 다른 도구에서 지침 마이그레이션

[`/init`](https://code.claude.com/docs/ko/commands)을 실행하면 다른 도구의 지침 파일을 읽고 관련 부분을 생성된 `CLAUDE.md`에 통합합니다:

* `.cursor/rules/` 또는 `.cursorrules`의 Cursor 규칙
* `.github/copilot-instructions.md`의 Copilot 규칙
* `CLAUDE_CODE_NEW_INIT=1` 설정: `AGENTS.md`, `.devin/rules/`, `.windsurf/rules/` 또는 `.windsurfrules`, `.clinerules`

[`/import`](https://code.claude.com/docs/ko/commands)를 실행하여 지원되는 코딩 에이전트의 구성을 Claude Code로 가져올 수도 있습니다. 이는 `AGENTS.md`와 같은 지침 파일의 일회성 복사본을 일치하는 `CLAUDE.md`에 추가하고 MCP 서버, 명령, 서브에이전트 및 스킬을 가져옵니다.

## 자동 메모리

자동 메모리를 사용하면 사용자가 아무것도 직접 작성하지 않아도 Claude가 세션 전반에 걸쳐 지식을 축적할 수 있습니다. Claude는 작업하면서 스스로를 위해 네 가지 종류의 노트를 저장합니다. Claude는 그 종류를 메모리 파일 frontmatter의 `type` 필드에 기록합니다.

* `user`: 사용자의 역할, 전문 분야, 작업 선호 사항
* `feedback`: 사용자가 Claude에게 제공한 수정 사항과 사용자가 확인한 접근 방식
* `project`: Claude가 코드나 git 기록에서 도출할 수 없는 진행 중인 작업, 마감일, 결정 사항
* `reference`: 이슈 트래커나 대시보드처럼 프로젝트 외부에서 정보를 찾을 수 있는 위치

Claude는 아키텍처, 파일 경로, 디버깅 수정 사항처럼 코드베이스에서 도출할 수 있는 내용은 건너뜁니다. 또한 CLAUDE.md 파일에 이미 나와 있는 내용도 건너뜁니다.

Claude가 매 세션마다 무언가를 저장하는 것은 아닙니다. 해당 정보가 향후 대화에 유용할지 여부를 기준으로 기억할 가치가 있는 내용을 판단합니다.

### 자동 메모리 활성화 또는 비활성화

자동 메모리는 로컬 세션에서 기본적으로 켜져 있습니다. [Claude Tag](https://claude.com/docs/claude-tag/overview) 세션을 제외하면, [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments-configuration.md#how-each-session’s-config-is-assembled)의 세션은 기본적으로 자동 메모리가 꺼진 상태로 실행됩니다.

전환하려면 세션에서 `/memory`를 열고 자동 메모리 토글을 사용합니다. 이 토글은 `~/.claude/settings.json`의 사용자 설정에 `autoMemoryEnabled`를 저장합니다.

다음 세션에서는 토글로 자동 메모리를 끌 수는 있지만 다시 켤 수는 없습니다.

* [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)
* Claude가 Bash 도구를 통해 `claude`를 실행하는 경우처럼 다른 Claude Code 세션이 시작한 세션

이러한 세션에서 자동 메모리가 꺼져 있는 동안 토글에는 `off · can't be turned on here; use a session started outside Claude Code`가 표시됩니다. 자동 메모리를 다시 켜려면 터미널에서 직접 `claude`를 실행하고 해당 세션에서 `/memory` 토글을 사용합니다.

단일 프로젝트에서만 끄려면 해당 프로젝트의 설정에서 `autoMemoryEnabled`를 설정합니다.

```json theme={null}
{
  "autoMemoryEnabled": false
}
```

환경 변수로 자동 메모리를 비활성화하려면 `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`을 설정합니다.

### 저장 위치

각 프로젝트는 `~/.claude/projects/<project>/memory/`에 자체 메모리 디렉터리를 갖습니다. `<project>` 경로는 git 저장소에서 도출되므로, 같은 저장소 내의 모든 워크트리와 하위 디렉터리는 하나의 자동 메모리 디렉터리를 공유합니다. git 저장소 외부에서는 프로젝트 루트가 대신 사용됩니다.

`CLAUDE_CONFIG_DIR`과 함께 [`CLAUDE_CODE_PROJECT_DIR_NAME`](https://code.claude.com/docs/ko/sessions#name-the-project-directory-yourself)을 설정하면, Claude Code는 어느 저장소에서 실행하든 `<config dir>/projects/` 아래의 `<project>` 디렉터리로 해당 이름을 대신 사용하므로, 해당 구성 디렉터리로 실행한 프로젝트들은 하나의 자동 메모리 디렉터리를 공유합니다. Claude Code v2.1.234 이상이 필요합니다.

자동 메모리를 다른 위치에 저장하려면 `settings.json`에서 `autoMemoryDirectory`를 설정합니다. 이 값은 모든 [설정 범위](https://code.claude.com/docs/ko/settings.md#settings-precedence)(사용자, 프로젝트, 로컬, 정책 또는 `--settings`)에서 읽힙니다.

```json theme={null}
{
  "autoMemoryDirectory": "~/my-custom-memory-dir"
}
```

값은 절대 경로이거나 `~/`로 시작해야 합니다.

프로젝트의 `.claude/settings.json` 또는 `.claude/settings.local.json`에서 설정하는 경우, Claude Code는 [설정 파일의 훅과 동일한 워크스페이스 신뢰 규칙](https://code.claude.com/docs/ko/permissions.md#what-runs-before-you-trust-a-folder)에 따라 이를 적용합니다. [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)가 켜져 있는 동안에는 [저장소에서 제공한 설정 파일](https://code.claude.com/docs/ko/permissions.md#when-your-local-settings-file-needs-trust)이 지정한 디렉터리가 어디에 있든, Claude Code는 해당 디렉터리에서 자동 메모리를 로드하지 않으며 저장하지도 않습니다.

디렉터리에는 `MEMORY.md` 인덱스와 메모리당 하나의 주제 파일이 포함됩니다.

```text theme={null}
~/.claude/projects/<project>/memory/
├── MEMORY.md           # Index, one line per memory, loaded into every session
├── user_role.md        # One memory
├── feedback_testing.md # One memory
└── ...                 # Any other topic files Claude creates
```

`MEMORY.md`는 메모리 디렉터리의 인덱스 역할을 합니다. Claude는 세션 내내 이 디렉터리의 파일을 읽고 쓰며, `MEMORY.md`를 사용해 어떤 내용이 어디에 저장되어 있는지 추적합니다.

자동 메모리는 머신 로컬입니다. 같은 git 저장소 내의 모든 워크트리와 하위 디렉터리는 하나의 자동 메모리 디렉터리를 공유합니다. 파일은 머신이나 클라우드 환경 간에 공유되지 않습니다.

Claude Code는 [`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays) 보존 기간이 지나면 오래된 세션 트랜스크립트를 삭제하지만, 메모리 디렉터리의 메모리 파일은 해당 [보존 정리](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)에서 제외합니다. `MEMORY.md`와 주제 파일은 사용자나 Claude가 편집하거나 삭제할 때까지 유지됩니다.

### 작동 방식

`MEMORY.md`의 처음 200줄 또는 처음 25KB 중 먼저 도달하는 분량이 모든 대화 시작 시 로드됩니다. 이 임계값을 넘는 내용은 세션 시작 시 로드되지 않습니다. Claude는 자세한 노트를 별도의 주제 파일로 옮겨 `MEMORY.md`를 간결하게 유지합니다.

Claude가 `MEMORY.md`에 쓴 후, Claude Code는 200줄 및 25KB 읽기 제한을 기준으로 파일을 측정합니다. 파일이 제한에 가까우면 Claude Code는 Claude에게 파일을 줄이도록 알립니다. 즉, 항목당 한 줄을 유지하고, 세부 내용은 주제 파일로 옮기고, 오래된 항목은 병합하거나 삭제하도록 합니다. 파일이 제한을 초과하면 쓰기는 성공하지만, 제한을 넘는 내용은 다음 로드 시 모두 누락되므로 Claude Code는 [Claude에게 인덱스를 다시 작성하라는 오류](https://code.claude.com/docs/ko/errors.md#memory-index-is-over-its-read-limit)를 반환합니다.

> [!NOTE]
>
> 이 제한은 `MEMORY.md`에만 적용됩니다. 시작 시 로드되는 각 CLAUDE.md 파일은 크기가 4 MiB 이하인 한 Claude가 전체 내용을 받습니다. Claude Code는 4 MiB를 초과하는 파일은 건너뛰며 그 내용을 전혀 로드하지 않습니다. 경로 범위 규칙과 하위 디렉터리의 CLAUDE.md 파일에는 [별도의 더 작은 파일당 제한](#claude-ignores-the-end-of-my-subdirectory-claude-md)이 있습니다.

Claude Code는 시작 시 `user_role.md`나 `feedback_testing.md` 같은 주제 파일을 로드하지 않습니다. Claude는 정보가 필요할 때 표준 파일 도구를 사용해 필요에 따라 이 파일들을 읽습니다.

메인 대화의 자동 메모리는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#what-loads-at-startup)에 로드되지 않습니다. 예외는 상위 대화와 시스템 프롬프트를 상속하는 [포크](https://code.claude.com/docs/ko/sub-agents.md#fork-the-current-conversation)입니다. 서브에이전트의 `memory` 필드로 활성화되는 서브에이전트 자체의 자동 메모리는 별도의 디렉터리입니다.

Claude는 세션 중에 메모리 파일을 읽고 씁니다. Claude Code 인터페이스에서 "Saved 2 memories" 또는 "Recalled 2 memories" 같은 메시지가 표시되면 Claude가 `~/.claude/projects/<project>/memory/`를 적극적으로 업데이트하거나 읽고 있는 것입니다.

Claude가 YAML frontmatter로 시작하는 메모리 파일을 쓰면, Claude Code는 쓰기 시각을 `modified` frontmatter 필드에 ISO 8601 타임스탬프로 기록합니다. 이 타임스탬프는 사용자와, 메모리를 다시 읽을 때의 Claude 모두에게 해당 사실이 얼마나 최신인지 보여 줍니다.

### 메모리 감사 및 편집

자동 메모리 파일은 언제든지 편집하거나 삭제할 수 있는 일반 markdown 파일입니다. 세션 내에서 메모리 파일을 찾아보고 열려면 [`/memory`](#view-and-edit-with-%2Fmemory)를 실행합니다.

## `/memory`로 보기 및 편집

`/memory` 명령은 사용자 및 프로젝트 범위에 걸쳐 CLAUDE.md, CLAUDE.local.md 및 기타 메모리 파일 위치를 나열하며, 아직 존재하지 않는 파일에 대한 사용자 및 프로젝트 CLAUDE.md 항목도 포함합니다. 또한 자동 메모리를 켜거나 끌 수 있으며 자동 메모리 폴더를 열 수 있는 옵션을 제공합니다. 파일을 선택하여 편집기에서 엽니다. 아직 존재하지 않는 파일을 선택하면 먼저 생성합니다. 시작 시 로드된 `CLAUDE.md` 및 규칙 파일을 확인하려면 `/context`를 실행합니다.

VS Code와 같은 GUI 편집기는 파일을 별도 창에서 열며, 파일이 열려 있는 동안 세션을 계속 사용할 수 있습니다. Vim과 같은 터미널 편집기는 종료할 때까지 터미널을 차지합니다.

Claude에게 "항상 npm이 아닌 pnpm을 사용합니다" 또는 "API 테스트에 로컬 Redis 인스턴스가 필요하다는 것을 기억합니다"와 같이 뭔가를 기억하도록 요청하면 Claude는 자동 메모리에 저장합니다. 대신 CLAUDE.md에 지침을 추가하려면 Claude에게 직접 "이것을 CLAUDE.md에 추가합니다"라고 요청하거나 `/memory`를 통해 파일을 직접 편집합니다.

## 메모리 문제 해결

CLAUDE.md 및 자동 메모리와 관련된 가장 일반적인 문제와 이를 디버깅하는 단계입니다.

### Claude가 CLAUDE.md를 따르지 않습니다

CLAUDE.md 콘텐츠는 시스템 프롬프트의 일부가 아니라 시스템 프롬프트 이후에 사용자 메시지로 전달됩니다. Claude는 이를 읽고 따르려고 시도하지만, 특히 모호하거나 충돌하는 지시사항의 경우 엄격한 준수를 보장하지 않습니다.

디버깅하려면:

* `/context`를 실행하고 **Memory files** 아래의 목록을 확인하여 시작 시 로드되어야 하는 CLAUDE.md 및 CLAUDE.local.md 파일을 확인합니다. 파일이 여기에 없으면 Claude가 볼 수 없습니다. `/memory`를 사용하여 파일을 열고 편집합니다.
* `Instruction file not loaded` 알림이 표시되면 [그 의미와 대처 방법](https://code.claude.com/docs/ko/errors.md#instruction-file-not-loaded)을 참조합니다.
* 작업 디렉터리의 하위 디렉터리에 있는 `CLAUDE.md`는 시작 시가 아니라 필요할 때 로드되므로 **Memory files** 아래에 나타나지 않습니다. 로드되면 해당 경로가 포함된 `Loaded` 줄이 터미널에 표시됩니다. 새 파일을 테스트하려면 Claude에게 작성을 요청하지 말고 셸에서 직접 생성한 다음, Claude에게 해당 하위 디렉터리의 파일을 읽도록 요청합니다.
* 관련 CLAUDE.md가 세션에 대해 로드되는 위치에 있는지 확인합니다([CLAUDE.md 파일을 어디에 배치할지 선택](#choose-where-to-put-claude-md-files) 참조).
* 지시사항을 더 구체적으로 작성합니다. "2칸 들여쓰기 사용"이 "코드를 깔끔하게 포맷팅"보다 더 잘 작동합니다.
* CLAUDE.md 파일 전체에서 충돌하는 지시사항을 찾습니다. 두 파일이 동일한 동작에 대해 다른 지침을 제공하면 Claude가 임의로 하나를 선택할 수 있습니다.
* Claude Code가 자체적으로 추가하는 지침과 지시사항이 충돌하는지 확인합니다. CLAUDE.md가 커밋 또는 풀 리퀘스트 규칙을 설정하면 [`includeGitInstructions`](https://code.claude.com/docs/ko/settings-reference#includegitinstructions)로 기본 제공 규칙을 끄고 [`attribution`](https://code.claude.com/docs/ko/settings-reference#attribution)으로 속성 텍스트를 설정합니다.

지시사항이 모든 커밋 전이나 각 파일 편집 후와 같이 특정 시점에 실행되어야 하는 경우, 대신 [훅](https://code.claude.com/docs/ko/hooks-guide.md)으로 작성합니다. 훅은 고정된 라이프사이클 이벤트에서 셸 명령으로 실행되며 Claude가 무엇을 하기로 결정하든 관계없이 적용됩니다.

시스템 프롬프트 수준에서 원하는 지시사항의 경우 [`--append-system-prompt`](https://code.claude.com/docs/ko/cli-reference#system-prompt-flags)를 사용합니다. 시작할 때 전달하므로 대화형 사용보다는 스크립트 및 자동화에 더 적합합니다. 대화를 재개할 때의 동작 방식에 대해서는 [재개된 대화에서의 시스템 프롬프트 플래그](https://code.claude.com/docs/ko/cli-reference.md#system-prompt-flags-in-resumed-conversations)를 참조합니다.

> [!TIP]
>
> [`InstructionsLoaded` 훅](https://code.claude.com/docs/ko/hooks#instructionsloaded)을 사용하여 어떤 `CLAUDE.md` 및 규칙 파일이 로드되었는지, 언제 로드되었는지, 그리고 왜 로드되었는지 로그에 기록합니다. 이는 경로별 규칙이나 하위 디렉터리의 지연 로드 파일을 디버깅하는 데 유용합니다.

### 내 AGENTS.md가 로드되지 않습니다

저장소에 `AGENTS.md`가 있고 Claude가 그 내용을 알지 못하는 경우, 일반적인 원인은 프로젝트 경로의 어딘가에 있는 `CLAUDE.md`입니다. 기본적으로 Claude는 작업 디렉터리 또는 그 위에 `CLAUDE.md` 또는 `CLAUDE.local.md`가 없을 때만 `AGENTS.md`를 읽습니다. 다음 순서대로 확인합니다:

1. 작업 디렉터리 또는 그 위의 디렉터리에서 `CLAUDE.md`, `.claude/CLAUDE.md`, 또는 `CLAUDE.local.md`를 찾습니다. `~/.claude/CLAUDE.md`는 제외합니다. 찾은 경우, Claude는 **Project instructions**를 `claude-md-and-agents-md`로 설정하지 않는 한 `AGENTS.md` 대신 이를 읽습니다.
2. `claude --version`을 실행하고 v2.1.277 이상인지 확인합니다. v2.1.281 이전에는 Amazon Bedrock의 세션이나 텔레메트리가 비활성화된 세션과 같은 일부 세션도 [`AGENTS.md`를 로드할 수 없었으므로](#when-agents-md-support-is-unavailable), 해당 버전에서는 v2.1.281 이상으로 업데이트합니다.
3. 세션에서 `/config`를 입력하여 설정 패널을 열고 **Project instructions**가 `claude-md` 또는 `managed-only`로 설정되지 않았는지 확인합니다. 설정이 전혀 표시되지 않으면 세션이 [`AGENTS.md`를 로드할 수 없는](#when-agents-md-support-is-unavailable) 세션입니다.

Claude가 `AGENTS.md`를 읽었는지 확인하려면 `/memory`를 실행하고 목록에서 해당 경로를 찾습니다.

v2.1.280 이전에는 `/memory` 및 `/context`가 Claude가 직접 읽은 `AGENTS.md`를 나열하지 않았습니다. 해당 버전에서는 대신 Claude에게 프로젝트 지시사항이 무엇인지 물어봅니다.

찾은 `CLAUDE.md`를 유지하려 하거나 세션이 `AGENTS.md`를 로드할 수 없는 경우, [`AGENTS.md` 옆에 이를 가져오는 `CLAUDE.md`를 추가합니다](#share-one-file-with-other-coding-tools).

### 자동 메모리가 저장한 내용을 모릅니다

`/memory`를 실행하고 자동 메모리 폴더를 선택하여 Claude가 저장한 내용을 찾아봅니다. 모든 것이 읽고, 편집하거나 삭제할 수 있는 일반 markdown입니다.

### CLAUDE.md가 너무 큽니다

200줄을 초과하는 파일은 더 많은 컨텍스트를 소비하며 준수를 줄일 수 있습니다. Claude Code는 4 MiB를 초과하는 파일을 건너뜁니다. [경로별 규칙](#path-specific-rules)을 사용하여 Claude가 일치하는 파일로 작업할 때만 지시사항을 로드하거나, 모든 세션에서 필요하지 않은 콘텐츠를 정리합니다. [`@path` 가져오기](#import-additional-files)로 분할하면 구성에 도움이 되지만 가져온 파일은 이를 가져오는 CLAUDE.md와 함께 로드되므로 컨텍스트를 줄이지는 않습니다.

지시사항 파일 중 하나가 권장 길이를 초과하면 시작 시 경고가 표시되고 `/status`를 실행할 때도 경고가 표시됩니다. 각각 해당 길이 내에 있는 파일이 세션 시작 시 결합된 제한을 초과할 때도 경고가 표시됩니다. 각 CLAUDE.md, 규칙 파일 및 `@path` 가져오기는 별도의 파일로 계산됩니다.

[`/doctor`](https://code.claude.com/docs/ko/commands#all-commands) 점검은 체크인된 CLAUDE.md에 대한 정리를 제안합니다. 디렉터리 레이아웃, 의존성 목록, 아키텍처 개요와 같이 Claude가 코드베이스에서 파생할 수 있는 콘텐츠를 제거하고, 도구 기본값과 다른 함정, 근거 및 규칙을 유지합니다.

> [!NOTE]
>
> 각 경로별 규칙 파일은 [자체 파일별 크기 제한](#claude-ignores-the-end-of-my-subdirectory-claude-md) 이내로 유지합니다. 제한을 초과하는 파일은 Claude가 앞부분만 받기 때문입니다.

### Claude가 하위 디렉터리 CLAUDE.md의 끝부분을 무시합니다

하위 디렉터리의 `CLAUDE.md` 또는 필요할 때 로드되는 규칙 파일이 파일별 크기 제한을 초과하면 Claude는 파일의 앞부분만 받습니다. 해당 부분은 Read 도구로 나머지를 읽으라고 Claude에게 알리는 메모로 끝나며, Claude가 그렇게 하기로 선택할 때까지 이후의 지시사항은 컨텍스트에 포함되지 않습니다.

파일이 제한을 초과하는지 확인하고, 초과하면 크기를 줄입니다:

1. 제한이 해당 파일에 적용되는지 확인합니다. 제한은 필요할 때 로드되는 다음 파일에 적용됩니다:
   * Claude Code를 시작한 디렉터리의 하위 디렉터리에 있는 `CLAUDE.md` 및 `CLAUDE.local.md`, 그리고 이 파일들이 `@path`로 [가져오는](#import-additional-files) 파일
   * 하위 디렉터리의 `.claude/rules/`에 있는 규칙 파일
   * 프로젝트의 `.claude/rules/` 또는 `~/.claude/rules/`에 있는 [경로별 규칙](#path-specific-rules)
2. 세션의 [컨텍스트 윈도우](https://code.claude.com/docs/ko/model-config.md#extended-context)에 해당하는 제한을 찾습니다:
   * **200K 컨텍스트 윈도우**: 40,000자
   * **1M 컨텍스트 윈도우**: Claude Opus 4.6 및 Claude Sonnet 4.6에서는 200,000자, 이후 모델에서는 150,000자
3. Bash 또는 Zsh에서 `wc -m path/to/CLAUDE.md`를 실행하여 파일의 문자 수를 출력합니다.
4. 문자 수를 제한과 비교합니다:
   * **제한 초과**: 파일을 정리하거나, 일부를 하나 이상의 규칙 파일로 옮깁니다. 각 규칙 파일은 개별적으로 제한이 적용됩니다
   * **제한 이하**: [Claude가 CLAUDE.md를 따르지 않습니다](#claude-isn’t-following-my-claude-md)에서 다른 원인을 찾습니다

v2.1.309 이전에는 Claude Code가 필요할 때 로드되는 파일에 이 제한을 적용하지 않았습니다.

### `/compact` 후 지시사항이 손실된 것 같습니다

프로젝트 루트 CLAUDE.md는 압축 후에도 유지됩니다. `/compact` 후 Claude는 디스크에서 다시 읽고 세션에 다시 주입합니다. 하위 디렉터리의 중첩된 CLAUDE.md 파일과 [`paths:` frontmatter](#path-specific-rules)가 있는 규칙은 필요할 때 다시 로드됩니다.

압축 후 지시사항이 사라진 경우, 대화에서만 제공되었거나, 아직 다시 로드되지 않은 중첩된 CLAUDE.md에 있거나, 이후로 파일과 일치하지 않은 경로별 규칙입니다. 대화 전용 지시사항을 CLAUDE.md에 추가하여 지속되도록 합니다. 전체 분석은 [압축 후에도 유지되는 것](https://code.claude.com/docs/ko/context-window.md#what-survives-compaction)을 참조합니다.

크기, 구조 및 구체성에 대한 지침은 [효과적인 지시사항 작성](#write-effective-instructions)을 참조합니다.

## 관련 리소스

* [구성 디버깅](https://code.claude.com/docs/ko/debug-your-config.md): CLAUDE.md 또는 설정이 적용되지 않는 이유 진단
* [Skills](https://code.claude.com/docs/ko/skills.md): 필요에 따라 로드되는 반복 가능한 워크플로우 패키지
* [설정](https://code.claude.com/docs/ko/settings.md): 설정 파일로 Claude Code 동작 구성
* [Subagent 메모리](https://code.claude.com/docs/ko/sub-agents.md#enable-persistent-memory): subagent가 자신의 자동 메모리를 유지하도록 허용
