> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 권한 구성

> 세분화된 권한 규칙, 모드 및 관리형 정책을 통해 Claude Code가 액세스하고 수행할 수 있는 작업을 제어합니다.

Claude Code는 에이전트가 수행할 수 있는 작업과 수행할 수 없는 작업을 정확하게 지정할 수 있도록 세분화된 권한을 지원합니다. 권한 설정은 버전 제어에 체크인할 수 있으며 조직의 모든 개발자에게 배포할 수 있을 뿐만 아니라 개별 개발자가 사용자 정의할 수 있습니다.

## 권한 시스템

Claude Code는 강력함과 안전성의 균형을 맞추기 위해 계층화된 권한 시스템을 사용합니다. 다음 표는 각 도구 유형에 대해 수동 모드에서 작업 실행 전에 승인을 요청하는지 여부를 보여줍니다. 다른 [권한 모드](#permission-modes)는 이 중 어떤 것이 사용자에게 묻는지를 변경하며, [분류기가 작업을 평가하는 방식](https://code.claude.com/docs/ko/permission-modes.md#how-the-classifier-evaluates-actions)은 분류기가 보는 작업을 나열합니다.

| 도구 유형 | 예시 | 승인 필요 | "예, 다시 묻지 않기" 동작 |
| :- | :- | :- | :- |
| 읽기 전용 | 파일 읽기, Grep | 아니오, [작업 디렉토리 및 추가 디렉토리](#working-directories) 내에서 | 해당 없음 |
| Bash 명령 | 셸 실행 | 예, [읽기 전용 명령](#read-only-commands)의 기본 제공 집합 제외 | 저장소 및 명령당 영구적 |
| 파일 수정 | Edit/Write 파일 | 예 | 세션 종료까지 |
| 웹 가져오기 | WebFetch | 예, [사전 승인된 설명서 도메인](https://code.claude.com/docs/ko/tools-reference.md#webfetch-tool-behavior)의 기본 제공 집합 제외 | 저장소 및 도메인당 영구적 |
| 웹 검색 | WebSearch | 예 | 저장소당 영구적 |

권한 프롬프트는 Claude가 수행하려는 작업을 보여준 다음 선택할 수 있는 옵션을 표시합니다. 다음 예시는 수동 모드 세션에서 표시된 Bash 명령에 대한 프롬프트입니다:

![Bash command라는 제목의 Claude Code 권한 프롬프트. 자동 모드에 대한 팁 아래에 설명 'Run the test suite', 명령 npm test, 'This command requires approval' 줄이 표시되고, 이어서 'Do you want to proceed?'라고 묻고 네 가지 옵션을 제공합니다: Yes; Yes, and don't ask again for: npm test \*; Yes, and switch to auto mode; No. 하단에는 두 개의 키가 나열됩니다: 취소하는 Esc와 수정하는 Tab.](https://mintcdn.com/claude-code/oa7CKjMeIChox26S/images/permission-prompt-bash-light.png?fit=max\&auto=format\&n=oa7CKjMeIChox26S\&q=85\&s=87585d008a29304873466399f7b476f6)

세 번째 옵션인 **예, 자동 모드로 전환**은 [모든 프롬프트에 표시되지는 않습니다](https://code.claude.com/docs/ko/permission-modes.md#switch-permission-modes).

"예, 다시 묻지 않기"를 선택하고 Bash 명령 또는 WebFetch 도메인과 같이 승인이 영구적으로 저장되는 경우, Claude Code는 규칙을 git 저장소의 루트에 있는 `.claude/settings.local.json`에 저장하며, [worktrees](https://code.claude.com/docs/ko/worktrees.md)를 통해 주 체크아웃으로 해결됩니다. 규칙은 해당 저장소의 모든 향후 세션에 적용되며, 하위 디렉토리 및 worktrees에서 시작된 세션도 포함됩니다. 파일 수정 승인은 파일에 저장되지 않습니다. 표에서 보듯이 세션 종료까지만 지속됩니다. git 저장소 외부 또는 Windows의 경우와 같은 일부 경우에는 Claude Code가 저장소 루트를 사용하지 않습니다. [Claude Code가 각 파일을 찾는 위치](https://code.claude.com/docs/ko/settings.md#where-claude-code-looks-for-each-file)는 이러한 경우와 규칙을 저장하는 위치를 나열합니다.

때때로 권한 프롬프트는 "다시 묻지 않기" 옵션이 없고 세션의 나머지 부분에 대해 작업을 허용하는 옵션도 없는 일회성 승인만 제공합니다. Claude Code는 프롬프트가 허용할 모든 것을 보여줄 수 있을 때만 이러한 옵션을 제공하므로 프롬프트에서 저장하는 규칙은 이름이 지정된 옵션만 포함합니다. 프롬프트가 일회성 승인만 제공하는 경우, 작업을 한 번 승인하거나 [`/permissions`](#manage-permissions)에서 규칙을 직접 추가합니다. `watch`와 같은 exec 래퍼로 시작하는 명령이나 `-delete`와 같은 작업이 포함된 `find` 명령에 대한 프롬프트를 중지하려면 [Exec 래퍼 및 `find` 작업](#exec-wrappers-and-find-actions)을 참조하세요.

### 권한 프롬프트에 답할 때 주석 추가

작업을 승인하거나 거부할 때 Claude에 메모를 첨부할 수 있습니다. Bash, PowerShell, 파일 및 MCP 도구 프롬프트를 포함한 대부분의 권한 프롬프트에서 **예** 또는 **아니오**로 이동하고 `Tab`을 눌러 해당 옵션에서 주석 필드를 엽니다. WebFetch 및 브라우저 프롬프트는 필드를 제공하지 않습니다. 세션의 나머지 부분에 대해 작업을 허용하거나 규칙을 저장하는 옵션도 하나를 사용하지 않습니다.

필드가 열려 있으면 주석을 입력한 다음 다음 키 중 하나를 누릅니다:

* `Enter`: 주석이 첨부된 답변을 제출합니다. 필드를 비워두면 Claude Code는 주석 없이 답변을 제출합니다.
* `Tab`: 답변하지 않고 필드를 닫습니다. Claude Code는 입력한 텍스트를 유지하고 해당 옵션으로 답변하면 여전히 전송합니다.
* `Shift+Tab`: 파일 프롬프트(예: Edit 또는 Write 프롬프트)에서 `Tab`과 동일하게 필드를 닫습니다. v2.1.235 이전에는 필드 내에서 `Shift+Tab`을 누르면 세션의 나머지 부분에 대해 작업을 허용하는 옵션을 선택했으므로 Claude Code는 세션의 나머지 부분에 대해 작업을 승인하고 주석을 버렸습니다.

Claude Code는 답변 방식에 따라 주석을 다르게 전달합니다:

* **예**: Claude Code는 작업을 실행한 다음 결과 후에 Claude에 주석을 보냅니다.
* **아니오**: Claude Code는 주석을 거부 이유로 Claude에 보내고 Claude는 계속 작업합니다. 주 대화의 프롬프트에서 주석 없이 **아니오**를 선택하면 Claude Code는 턴을 중지합니다.

## 권한 관리

`/permissions`를 사용하여 Claude Code의 도구 권한을 보고 관리할 수 있습니다. 이 대화 상자는 모든 권한 규칙과 각 규칙이 출처한 `settings.json` 파일을 나열합니다. Claude가 작업 중일 때 이 대화 상자를 열 수 있습니다. 규칙을 추가하거나 제거하면 Claude Code는 같은 턴에서 Claude의 다음 도구 호출부터 변경 사항을 적용합니다. v2.1.234 이전에는 Claude Code가 턴이 끝날 때까지 명령을 대기열에 넣었습니다.

* **Allow** 규칙을 사용하면 Claude Code가 수동 승인 없이 지정된 도구를 사용할 수 있습니다.
* **Ask** 규칙은 Claude Code가 지정된 도구를 사용하려고 할 때마다 확인을 요청합니다.
* **Deny** 규칙은 Claude Code가 지정된 도구를 사용하지 못하도록 방지합니다.

규칙은 순서대로 평가됩니다: deny, ask, allow. 해당 순서의 첫 번째 일치 항목이 결과를 결정하며, 규칙 특이성은 순서를 변경하지 않습니다.

`Bash(aws *)`와 같은 광범위한 deny 규칙은 `Bash(aws s3 ls)`와 같은 더 좁은 allow 규칙과도 일치하는 호출을 포함하여 모든 일치하는 호출을 차단하므로, deny 규칙은 허용 목록 예외를 포함할 수 없습니다. ask와 allow 사이에도 동일한 우선순위가 적용됩니다: 일치하는 ask 규칙은 동일한 호출과도 일치하는 더 구체적인 allow 규칙이 있을 때도 프롬프트를 표시합니다.

Deny 규칙은 도구 이름을 지정하는지 또는 도구 내의 패턴 범위를 지정하는지에 따라 다르게 작동합니다. `Bash`와 같은 단순 도구 이름은 도구를 Claude의 컨텍스트에서 완전히 제거하므로 Claude는 이를 볼 수 없습니다. 세션 중간에 이러한 규칙을 추가하면 Claude는 다음 도구 호출부터 도구를 호출할 수 없습니다. [전체 도구 거부](https://code.claude.com/docs/ko/prompt-caching.md#denying-an-entire-tool)는 Claude가 이미 본 정의에 어떤 일이 발생하는지를 다룹니다. `Bash(rm *)`와 같은 범위 지정 규칙은 도구를 사용 가능하게 유지하고 Claude가 시도할 때 일치하는 호출을 차단합니다.

단순 이름 제거는 [`EndConversation`](https://code.claude.com/docs/ko/tools-reference#endconversation-tool-behavior)을 제외한 모든 도구에 적용됩니다: deny 규칙은 다른 도구가 남아 있는 동안 이를 제거할 수 없으며, ask 규칙은 이에 대해 프롬프트를 표시하지 않습니다.

> [!NOTE]
>
> 권한 규칙은 모델이 아닌 Claude Code에 의해 적용됩니다. 프롬프트 또는 `CLAUDE.md`의 지시사항은 Claude가 시도하는 작업을 형성하지만, Claude Code가 허용하는 것을 변경하지는 않습니다. 액세스 권한을 부여하거나 취소하려면 `/permissions`, 여기에 설명된 규칙, [권한 모드](https://code.claude.com/docs/ko/permission-modes.md), 또는 [PreToolUse hook](#extend-permissions-with-hooks)을 사용하십시오.

[자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 세션에서 사용 가능할 때, 이 대화 상자에는 [자동 모드 분류기 규칙](https://code.claude.com/docs/ko/auto-mode-config.md#edit-rules-from-permissions)도 포함됩니다. **자동 모드** 탭을 선택하여 이들을 확인하십시오.

## 권한 모드

Claude Code는 도구 승인 방식을 제어하는 여러 권한 모드를 지원합니다. [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)에서 각 모드를 사용할 시기를 확인합니다. 세션이 시작되는 모드를 변경하려면 [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)에서 `defaultMode`를 설정합니다. [세션이 시작되는 모드](https://code.claude.com/docs/ko/permission-modes.md#which-mode-a-session-starts-in)에서는 각 플랜의 기본 설정과 VS Code 확장이 읽는 내용을 다룹니다.

| 모드 | 설명 |
| :- | :- |
| `default` | 각 도구를 처음 사용할 때 권한을 요청합니다. CLI, VS Code 및 JetBrains 확장, 데스크톱 앱에서 Manual로 표시되며, Claude Code는 `manual`을 별칭으로 허용합니다 |
| `acceptEdits` | 작업 디렉토리 또는 `additionalDirectories`의 경로에 대해 파일 편집 및 `mkdir`, `touch`, `mv`, `cp` 등의 일반적인 파일 시스템 명령을 자동으로 수락합니다 |
| `plan` | Claude는 파일을 읽고 읽기 전용 셸 명령을 실행하여 탐색하지만 소스 파일을 편집하지 않습니다. [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)를 사용할 수 있는 경우 분류기 승인 명령도 실행됩니다. CLI 및 VS Code 확장에서 Plan으로 표시됩니다 |
| `auto` | 루틴 프롬프트 없이 실행됩니다. 셸 명령 및 네트워크 요청과 같은 작업이 실행되기 전에 백그라운드 [분류기](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 요청과 일치하는지 확인합니다 |
| `dontAsk` | 그 외에 확인을 요청할 모든 호출을 자동으로 거부합니다. 다만 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 이러한 호출 중 일부를 여전히 승인할 수 있습니다. 작업 디렉터리의 파일 읽기 및 승인이 필요 없는 기타 작업은 계속 실행되며, `/permissions` 또는 `permissions.allow` 규칙을 통해 사전 승인된 도구도 실행됩니다. `AskUserQuestion`, [`requiresUserInteraction`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)으로 표시된 MCP 도구, [네트워크 경로에서의 읽기](#network-paths), 그리고 해당 설정이 Claude Code에 도달하는 세션에서 [조직이 `ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구는 허용했더라도 거부됩니다 |
| `bypassPermissions` | 권한 프롬프트를 건너뜁니다. 단, [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)은 제외됩니다 |

> [!WARNING]
>
> `bypassPermissions` 모드에서 Claude Code는 `.git` 및 `.claude`와 같은 [보호된 경로](https://code.claude.com/docs/ko/permission-modes.md#protected-paths)에 대한 쓰기를 포함한 권한 프롬프트를 건너뜁니다. [세션 간 메시징 보안 조치](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)는 여전히 적용됩니다. 이 모드는 Claude Code가 손상을 일으킬 수 없는 컨테이너 또는 VM과 같은 격리된 환경에서만 사용합니다.

`bypassPermissions` 또는 `auto` 모드가 사용되는 것을 방지하려면 [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)에서 `permissions.disableBypassPermissionsMode` 또는 `permissions.disableAutoMode`를 `"disable"`로 설정합니다. 이들은 재정의될 수 없는 [관리형 설정](#managed-settings)에서 가장 유용합니다.

## 권한 규칙 구문

권한 규칙은 `Tool` 또는 `Tool(specifier)` 형식을 따릅니다. 지정자 내의 괄호는 리터럴이므로, 괄호를 포함하는 명령이나 경로는 이스케이프할 필요가 없습니다.

### 도구의 모든 사용 일치

도구의 모든 사용을 일치시키려면 괄호 없이 도구 이름만 사용합니다:

| 규칙 | 효과 |
| :- | :- |
| `Bash` | 모든 Bash 명령과 일치합니다 |
| `WebFetch` | 모든 웹 가져오기 요청과 일치합니다 |
| `Read` | 모든 파일 읽기와 일치합니다 |

`Bash(*)`는 `Bash`와 동등하며 모든 Bash 명령과 일치합니다. 거부 규칙으로서, 두 형식 모두 Claude의 컨텍스트에서 도구를 제거합니다.

트랜스크립트 및 권한 대화 상자에서 도구에 대해 표시되는 레이블은 정규 이름과 다를 수 있습니다. 예를 들어, 트랜스크립트에서 `Stop Task`로 표시되는 도구의 정규 이름은 `TaskStop`입니다. 권한 규칙 및 [훅 matcher](https://code.claude.com/docs/ko/hooks.md)는 레이블과 일치하지 않으므로, `Stop Task`로 작성된 규칙은 일치하지 않습니다. 거부 및 확인 규칙의 경우 [시작 경고](https://code.claude.com/docs/ko/errors.md#matches-no-tool)가 이를 알려줍니다. [도구 참조](https://code.claude.com/docs/ko/tools-reference.md)에 나열된 정규 이름을 사용합니다.

### 세분화된 제어를 위해 지정자 사용

괄호 안에 지정자를 추가하여 특정 도구 사용과 일치시킵니다:

| 규칙 | 효과 |
| :- | :- |
| `Bash(npm run build)` | 정확한 명령 `npm run build`와 일치합니다 |
| `Read(./.env)` | 현재 디렉토리의 `.env` 파일 읽기와 일치합니다 |
| `WebFetch(domain:example.com)` | example.com으로의 가져오기 요청과 일치합니다 |

### 입력 매개변수로 일치

거부 및 요청 규칙은 `Tool(param:value)`를 사용하여 모든 기본 제공 도구의 최상위 입력 매개변수와 일치할 수 있습니다.

MCP 도구의 매개변수와 일치시키려면 [`--disallowedTools`](https://code.claude.com/docs/ko/cli-reference#cli-flags)를 사용하여 거부 규칙을 전달합니다. Claude Code가 설정 파일을 로드할 때, 괄호가 있는 모든 `mcp__` 규칙을 건너뜁니다. Claude Code는 대화형 세션이 시작될 때 건너뛴 규칙을 유효하지 않은 설정 대화 상자에 나열하고, [`claude doctor`](https://code.claude.com/docs/ko/debug-your-config#check-resolved-settings) 출력에도 나열합니다.

매개변수 규칙은 Claude가 해당 매개변수가 정확한 값으로 설정된 도구를 호출할 때 일치합니다. 한 매개변수 값에 대한 허용 규칙은 호출이 전반적으로 안전하다는 것을 확립하지 않으므로, 허용 규칙은 각 도구의 자체 지정자 구문을 계속 사용합니다. 이는 도구가 허용하는 모든 스칼라 매개변수에 대해 작동합니다:

| 규칙 | 일치 |
| :- | :- |
| `Agent(model:opus)` | Opus 모델 계층을 요청하는 Agent 호출 |
| `Agent(isolation:worktree)` | git worktree를 요청하는 Agent 호출 |
| `Bash(run_in_background:true)` | 백그라운드에서 실행되는 Bash 호출 |

매개변수 일치는 다음 규칙을 따릅니다:

* 매개변수 이름은 Agent 도구의 `model`과 같이 도구 입력의 직접 필드여야 합니다. 객체 또는 배열 내에 중첩된 필드는 일치 가능하지 않습니다
* 각 규칙은 하나의 매개변수를 지정합니다. `model`과 `isolation` 모두에 대해 게이트하려면, 한 규칙에 결합하는 대신 `Agent(model:opus)` 및 `Agent(isolation:worktree)` 두 규칙을 작성합니다
* 값은 `*`를 와일드카드로 지원하여 모든 문자 시퀀스와 일치하므로, `Agent(isolation:*)`는 모든 명시적 격리 값과 일치합니다. `*` 없으면 일치는 정확합니다
* 모델이 생략한 매개변수는 절대 일치하지 않으므로, `Agent(model:*)`는 `model`을 설정하지 않은 호출과 일치하지 않습니다
* 값은 정규화 전에 Claude가 보내는 리터럴 입력과 비교됩니다. `Agent(model:opus)`는 별칭 `opus`와 일치하지만 전체 모델 ID와는 일치하지 않습니다
* `Skill(skill:<name>)` 거부 규칙은 대신 [별칭이나 표시 이름과 같은 모든 이름으로 스킬과 일치합니다](https://code.claude.com/docs/ko/skills.md#restrict-claude%E2%80%99s-skill-access)
* [`--verbose`](https://code.claude.com/docs/ko/cli-reference)로 실행하여 각 도구 호출의 정확한 매개변수 이름과 값을 확인합니다
* 콜론 주위의 공백은 무시됩니다

도구의 기본 콘텐츠 필드는 이 방식으로 일치 가능하지 않습니다: Bash 및 PowerShell의 `command`, Read, Edit 및 Write의 `file_path`, Grep 및 Glob의 `path`, NotebookEdit의 `notebook_path`, WebFetch의 `url`. `Bash(command:rm *)`와 같은 규칙은 복합 명령으로 우회 가능하므로, Claude Code는 이를 무시하고 시작 경고를 발생시킵니다. 대신 `Bash(rm *)`, `Read(./path)` 또는 `WebFetch(domain:host)`를 사용합니다.

### 와일드카드 패턴

Bash 규칙의 `*`는 공백을 포함한 모든 텍스트와 일치하므로, 한 규칙이 명령 계열을 포함합니다. `*`가 없는 규칙은 정확한 명령 하나와 일치합니다.

> [!WARNING]
>
> `*`를 부분 명령 뒤에 놓습니다. `git log --oneline main`에서 `git`는 프로그램이고 `log`는 부분 명령이며, 프로그램이 수행하는 작업을 결정하는 단어입니다. Claude Code는 첫 번째 `*` 앞의 모든 것을 작성된 대로 일치시키므로, 이러한 단어들이 규칙을 제한하는 것입니다: `Bash(git log *)`는 `git log` 명령만 허용하고, `Bash(git *)`는 모든 git 명령을 허용합니다. Claude Code는 `Bash(git * main)`과 같이 부분 명령 앞에 `*`가 있는 허용 규칙에 대해 [시작 시 경고](https://code.claude.com/docs/ko/errors.md#has-a-wildcard-before-the-rest-of-the-command)합니다.

Claude가 묻지 않고 실행하기를 원하는 명령을 작성하고, 변하는 부분을 `*`로 바꿉니다. 이 구성을 사용하면 Claude Code는 npm 스크립트와 git 커밋을 묻지 않고 실행하고 `git push`로 시작하는 명령을 거부합니다. `git -C . push`처럼 다른 방식으로 작성된 push는 일치하지 않습니다. [Bash 규칙이 일치하지 않는 것](#bash-rule-limits)을 참조하세요.

```json theme={null}
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git commit *)"
    ],
    "deny": [
      "Bash(git push *)"
    ]
  }
}
```

`*`는 규칙의 어느 곳에나 올 수 있습니다: 시작, 중간 또는 끝. 각 행은 규칙, 일치하는 명령, 일치하지 않는 근처 명령을 보여줍니다:

| 작성 내용 | 일치 | 일치하지 않음 |
| :- | :- | :- |
| `Bash(npm run build)` | `npm run build` | `npm run build --watch` |
| `Bash(npm run *)` | `npm run build`, `npm run test --watch`, `npm run` | `npm install` |
| `Bash(git log * main)` | `git log --oneline main`, `git log -5 main`, `git log --output=<file> main` | `git log main`, `git push origin main` |
| `Bash(git * main)` | `git merge main`, `git push origin main`, `git -c core.fsmonitor=<script> diff main` | `git log` |
| `Bash(* --version)` | `node --version`, `bash -c 'echo hi' --version` | `node -v` |
| `Bash(ls *)` | `ls -la`, `ls` | `lsof` |
| `Bash(ls*)` | `ls -la`, `lsof` | |
| `Bash(* --help *)` | `npm --help x` | `npm --help` |

세 가지 일치 규칙이 이러한 행을 생성합니다:

* **`*`는 해당 위치의 모든 텍스트를 나타냅니다.** `Bash(git * main)`에서, 이는 부분 명령을 나타내므로 Claude Code는 모든 git 부분 명령과 그 앞의 모든 옵션과 일치합니다. 여기에는 git이 사용자가 지정한 프로그램을 실행하도록 하는 `-c`가 포함됩니다. `Bash(* --version)`에서, `*`는 프로그램을 나타내므로 모든 프로그램이 일치합니다.
* **끝에 있는 `*`와 그 앞의 공백은 또한 단순 명령과도 일치합니다.** `Bash(ls *)`는 `ls`와 일치하고, `Bash(git log *)`는 `git log`와 일치합니다. 이는 뒤에 오는 `*`가 규칙의 유일한 와일드카드일 때만 유지됩니다: `Bash(* --help *)`는 `npm --help x`와 일치하지만 `npm --help`와는 일치하지 않습니다.
* **뒤에 오는 `*` 앞의 공백은 규칙의 일부입니다.** `Bash(ls *)`는 `ls` 뒤의 공백을 요구하므로 `lsof`는 일치하지 않습니다. `Bash(ls*)`는 공백이 없으므로 `lsof`도 일치합니다.

`:*` 접미사는 뒤에 오는 와일드카드를 작성하는 동등한 방법이므로, `Bash(ls:*)`는 `Bash(ls *)` 와 동일한 명령과 일치합니다.

권한 대화 상자는 명령 접두사에 대해 "예, 다시 묻지 않기"를 선택할 때 공백으로 구분된 형식을 작성합니다. `:*` 형식은 패턴의 끝에서만 인식됩니다. `Bash(git:* push)`와 같은 패턴에서 콜론은 리터럴 문자로 취급되며 git 명령과 일치하지 않습니다.

### 도구 이름 와일드카드

거부 및 요청 규칙은 도구 이름 위치에서도 glob 패턴을 허용합니다. 패턴은 전체 도구 이름과 일치해야 합니다: `"*"`는 모든 도구와 일치하며, `"mcp__*"`는 모든 서버의 모든 MCP 도구와 일치합니다. 단순 이름 glob 거부 규칙과 일치하는 도구는 Claude의 컨텍스트에서 제거되며, 이는 단순 도구 이름과 동일합니다. [`EndConversation`](https://code.claude.com/docs/ko/tools-reference#endconversation-tool-behavior) 예외를 포함하여: glob 거부는 다른 도구가 남아 있는 동안 이를 제거할 수 없으며, glob 요청은 절대 이에 대해 프롬프트하지 않습니다. 이 구성은 모든 MCP 도구를 거부합니다:

```json theme={null}
{
  "permissions": {
    "deny": [
      "mcp__*"
    ]
  }
}
```

허용 규칙은 리터럴 `mcp__<server>__` 접두사 이후에만 도구 이름 glob을 허용합니다. 서버 세그먼트는 glob이 없어야 하므로 규칙이 구성한 특정 서버를 지정합니다. `mcp__puppeteer__*`는 `puppeteer` 서버의 모든 도구와 일치하며, `mcp__github__get_*`는 해당 `get_` 도구와 일치합니다. `"*"`, `"B*"`, 또는 `"mcp__*"`와 같은 고정되지 않은 허용 glob은 건너뛰어지며 아무것도 자동으로 승인하지 않습니다.

도구 이름이 알려진 도구와 일치하지 않는 거부 또는 확인 규칙은 오타를 포착하기 위해 [시작 경고](https://code.claude.com/docs/ko/errors.md#matches-no-tool)를 생성합니다. `_` 또는 `*`를 포함하는 도구 이름은 확인에서 제외됩니다. Claude Code가 제거한 도구의 이름(예: `TaskOutput`)도 확인에서 제외됩니다.

## 도구별 권한 규칙

### Bash

Bash 규칙은 명령 텍스트 전체와 매칭되며, `*`는 임의의 텍스트를 나타냅니다. [와일드카드 패턴](#wildcard-patterns)에서 각 규칙 형태가 어떤 명령과 매칭되는지, 그리고 `*`를 어디에 두어야 하는지 확인할 수 있습니다. 이 섹션의 나머지 부분에서는 Claude Code가 복합 명령과 래퍼를 매칭하는 방식, 접두사 규칙으로 승인할 수 없는 래퍼와 `find` 액션, 규칙이 매칭하지 않는 대상, 읽기 전용 명령, 리디렉션을 다룹니다.

#### 복합 명령

> [!TIP]
>
> Claude Code는 셸 연산자를 인식하므로, `Bash(safe-cmd *)` 같은 규칙이 `safe-cmd && other-cmd` 명령을 실행할 권한을 부여하지는 않습니다. 인식되는 명령 구분자는 `&&`, `||`, `;`, `|`, `|&`, `&`, 그리고 줄바꿈입니다. 복합 명령이 프롬프트 없이 실행되려면 모든 하위 명령이 허용되어야 합니다. 예를 들어 하위 명령이 허용 규칙과 매칭되거나 [읽기 전용 명령](#read-only-commands)이면 허용됩니다.

거부 및 확인 규칙은 하위 명령 중 하나라도 매칭되면 적용되며, 서브셸, 명령 치환, 또는 `for` 루프와 같은 제어 흐름 본문 안에 중첩된 명령도 포함됩니다. `Bash(git clean *)` 같은 확인 규칙은 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서도 `cd /tmp && git clean -f`나 `echo "$(git clean -f)"`에 대해 여전히 확인을 요청합니다.

`npm test &&`처럼 `&&`나 `||` 뒤에 아무것도 없으면, Claude Code는 해당 명령을 파싱할 수 없는 것으로 취급하여 허용 규칙 매칭을 위해 하위 명령으로 분할하지 않으므로, `Bash(npm *)` 같은 규칙으로는 승인되지 않습니다.

"Yes, and don't ask again"으로 복합 명령을 승인하면, Claude Code는 전체 복합 문자열에 대한 단일 규칙 대신 승인이 필요한 각 하위 명령에 대해 별도의 규칙을 저장합니다. 예를 들어 `git status && npm test`를 승인하면 `npm test`에 대한 규칙이 저장되므로, 이후 `npm test` 호출은 `&&` 앞에 무엇이 오든 인식됩니다. 작업 디렉터리 밖의 디렉터리로 이동하는 `cd` 같은 하위 명령은 해당 경로에 대한 자체 Read 규칙을 생성합니다. 하나의 복합 명령에 대해 최대 5개의 규칙이 저장될 수 있습니다.

#### 래퍼

Bash 규칙을 매칭하기 전에 Claude Code는 고정된 래퍼 집합을 제거하므로, `Bash(npm test *)` 같은 규칙은 `timeout 30 npm test`와도 매칭됩니다. 제거되는 래퍼는 `timeout`, `time`, `nice`, `nohup`, `stdbuf`와 셸 내장 명령인 `command`, `builtin`, 그리고 zsh의 `noglob`입니다. 각각은 인수를 실제 명령으로 실행합니다. 관련된 두 가지 형태는 제거되지 않습니다. 명령을 실행하는 대신 조회하는 쿼리 형태 `command -v`와 zsh의 `nocorrect`입니다.

Claude Code는 또한 안전하다고 알려진 특정 환경 변수의 선행 할당을 제거하므로, `Bash(npm test *)`는 `NODE_ENV=test npm test`와 매칭됩니다. 허용 규칙은 그 밖의 다른 변수 할당을 건너뛰어 매칭되지 않습니다. 거부 또는 확인 규칙은 모든 선행 할당을 건너뛰어 매칭되므로, 거부 목록의 `Bash(rm *)`는 여전히 `FOO=bar rm -rf tmp/`와 매칭됩니다.

플래그 없는 `xargs`도 제거되므로, `Bash(grep *)`는 `xargs grep pattern`과 매칭됩니다. 제거는 `xargs`에 플래그가 없을 때만 적용됩니다. `xargs -n1 grep pattern` 같은 호출은 `xargs` 명령으로 매칭되므로, 내부 명령을 위해 작성된 규칙은 이를 포함하지 않습니다.

이 래퍼 목록은 내장되어 있으며 구성할 수 없습니다. `direnv exec`, `devbox run`, `mise exec`, `npx`, `docker exec` 같은 개발 환경 실행기는 목록에 포함되어 있지 않습니다. 이러한 도구는 인수를 명령으로 실행하므로, `Bash(devbox run *)` 같은 규칙은 `devbox run rm -rf .`를 포함하여 `run` 뒤에 오는 모든 것과 매칭됩니다. 환경 실행기 안의 작업을 승인하려면 `Bash(devbox run npm test)`처럼 실행기와 내부 명령을 모두 포함하는 구체적인 규칙을 작성하십시오. 허용하려는 내부 명령마다 규칙을 하나씩 추가합니다.

#### Exec 래퍼와 `find` 액션

`Bash(watch *)`나 `Bash(find *)` 같은 접두사 규칙은 다음 명령을 자동 승인할 수 없으므로, Manual 모드에서는 확인을 요청합니다.

* **Exec 래퍼**: `watch`, `setsid`, `ionice`, `flock` 등
* **`find`**: `-exec`, `-delete`, `-rm`, `-fprint`처럼 명령을 실행하거나, 파일을 삭제하거나, 파일을 쓰는 액션이 있는 경우, 또는 검색할 경로를 파일에서 가져오는 `-files0-from`이 있는 경우

`*`가 없는 특정 호출을 승인하려면 `Bash(find build -type f -delete)`처럼 전체 명령 문자열에 대한 정확히 일치하는 규칙을 작성하십시오.

`find . -name '*.tmp' -delete`처럼 명령에 `*`가 있으면, Claude Code는 규칙을 정확한 일치가 아닌 [와일드카드 패턴](#wildcard-patterns)으로 읽으므로 명령은 여전히 확인을 요청합니다. 확인을 요청할 때마다 승인하거나, 해당 명령에 대해 `"allow"`를 반환하는 [PreToolUse 훅](https://code.claude.com/docs/ko/hooks.md#pretooluse-decision-control)을 사용하십시오.

#### Bash 규칙이 매칭하지 않는 것

Bash 규칙은 Claude Code가 [복합 명령](#compound-commands)을 분할하고 [래퍼](#process-wrappers)를 제거한 후, Claude가 작성한 명령 텍스트와 매칭됩니다. 같은 프로그램을 다른 형태로 호출한 경우에는 매칭되지 않으므로, 거부 또는 확인 규칙은 Claude가 일반적으로 생성하는 호출을 다룰 뿐 프로그램을 둘러싼 보안 경계가 아닙니다. `deny` 또는 `ask`에 있는 다음 규칙은 첫 번째 형태는 막지만 다른 형태는 막지 않습니다.

| 규칙 | 막는 것 | 막지 않는 것 |
| :- | :- | :- |
| `Bash(curl *)` | `curl https://example.com` | `/usr/bin/curl https://example.com`, `sh -c 'curl https://example.com'` |
| `Bash(rm *)` | `rm -rf build/` | `/bin/rm -rf build/`, `bash -c 'rm -rf build/'` |
| `Bash(git push *)` | `git push origin main` | `git -C . push origin main`, `git -c push.default=current push origin main`, `git 'push' origin main` |

마지막 열의 명령은 다른 규칙과 권한 모드에 따라 결정됩니다.

명령 텍스트에 의존하지 않는 파일 시스템 및 네트워크 적용을 원한다면 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)을 사용하십시오. 실행 전에 자체 로직으로 전체 명령 텍스트를 검사하려면 [PreToolUse 훅](#extend-permissions-with-hooks)을 사용하십시오.

#### 읽기 전용 명령

Claude Code는 내장된 Bash 명령 집합을 읽기 전용으로 인식하며, 작업 디렉터리 밖의 경로에 대해 [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)가 동작을 바꾸는 경우를 제외하고 모든 모드에서 권한 프롬프트 없이 실행합니다. 이 집합에는 `ls`, `cat`, `echo`, `pwd`, `head`, `tail`, `grep`, `find`, `wc`, `which`, `diff`, `stat`, `du`, `cd`, 그리고 `git`의 읽기 전용 형태가 포함됩니다. 이 집합은 구성할 수 없습니다. 이러한 명령 중 하나에 프롬프트를 요구하려면 해당 명령에 대한 `ask` 또는 `deny` 규칙을 추가하십시오. 자동 모드에서는 이러한 명령도 분류기의 검토를 기다릴 수 있습니다. [분류기가 작업을 평가하는 방법](https://code.claude.com/docs/ko/permission-modes.md#how-the-classifier-evaluates-actions)을 참조하십시오.

`ls > out.txt` 같은 리디렉션은 대상에 대한 검사를 추가합니다. [리디렉션](#redirections)을 참조하십시오.

모든 플래그가 읽기 전용인 명령에는 따옴표 없는 glob 패턴이 허용되므로, `ls *.ts`와 `wc -l src/*.py`는 프롬프트 없이 실행됩니다.

Manual 모드에서 이 집합의 명령은 다음 경우에 여전히 확인을 요청합니다.

* **쓰기 가능한 플래그가 있는 명령의 따옴표 없는 glob**: `find`, `sort`, `sed`, `git`처럼 쓰기 또는 실행이 가능한 플래그가 있는 명령은 따옴표 없는 glob이 있으면 확인을 요청합니다. glob이 `-delete` 같은 플래그로 확장될 수 있기 때문입니다.
* **다른 데몬을 가리키는 `docker`**: `docker`의 읽기 전용 형태는 `-H`, `--context`, 또는 Podman의 `--url`과 `--connection`처럼 다른 데몬을 선택하는 플래그가 명령에 포함되어 있으면 확인을 요청합니다.
* **경로를 여는 플래그가 있는 `file`**: `file`은 `-m`/`--magic-file` 또는 `-f`/`--files-from`을 전달하면 확인을 요청합니다. 이러한 플래그는 `file`이 플래그 값에 지정된 경로를 열게 하기 때문입니다.
* **환경 변수를 출력할 수 있는 `ps`**: `ps`는 `ps auxe`나 `ps aux -e`처럼 인수 중 하나가 `e` 옵션으로 작동할 수 있으면 확인을 요청합니다. 이 옵션은 프로세스 환경 변수를 출력하기 때문입니다. `ps aux`와 `ps -ef`는 프롬프트 없이 실행됩니다. `ps aux -e` 같은 대시 형태에 대한 검사는 Claude Code v2.1.290 이상이 필요합니다.
* **Windows의 네트워크 경로**: `\\server\share\file`처럼 인수에 네트워크(UNC) 경로가 포함된 명령은 확인을 요청합니다. 네트워크 경로에 접근하면 Windows 자격 증명이 해당 경로가 가리키는 호스트로 전송될 수 있기 때문입니다. 동일한 검사가 [PowerShell 도구](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool) 명령에도 적용됩니다.
* **특수 셸 변수에 대한 쓰기**: `PATH`나 `IFS` 같은 특정 특수 셸 변수를 설정, 해제하거나 이를 대상으로 반복하는 명령은 명령의 나머지 부분이 읽기 전용이더라도 확인을 요청합니다.
* **분석으로 파싱할 수 없는 명령**: Claude Code가 명령을 완전히 파싱할 수 없으면 해당 명령을 읽기 전용으로 취급하지 않고 승인을 요청합니다. 10,000자를 초과하는 명령은 분석이 파싱하는 범위를 넘어서므로 항상 확인을 요청합니다.

작업 디렉터리 또는 [추가 디렉터리](#working-directories) 내부 경로로의 `cd`도 읽기 전용이며, `cd packages/api && ls` 같은 복합 명령은 각 부분이 개별적으로 조건을 충족하면 프롬프트 없이 실행됩니다. 다음 조합은 각 부분이 읽기 전용이더라도 확인을 요청합니다.

* **`git`과 함께 쓰인 `cd`**: `cd`가 다른 디렉터리로 이동하면 확인을 요청합니다. 새 디렉터리에서 `git`을 실행하면 해당 디렉터리의 훅이 실행될 수 있기 때문입니다. 대상이 현재 작업 디렉터리로 해석되는 `cd`는 아무 동작도 하지 않으므로 프롬프트를 발생시키지 않습니다.
* **리디렉션과 함께 쓰인 `cd`**: `cd`가 실행된 후 리디렉션 대상이 어느 디렉터리를 기준으로 해석되는지 Claude Code가 판단할 수 없으면 확인을 요청합니다. `cd app; grep -r pattern . 2>/dev/null`처럼 유일한 리디렉션 대상이 `/dev/null`인 명령은 확인을 요청하지 않습니다. `/dev/null`은 작업 디렉터리에 의존하지 않기 때문입니다.

> [!WARNING]
>
> 명령 인수를 제한하려는 Bash 권한 패턴은 취약합니다. 예를 들어 `Bash(curl http://github.com/ *)`는 curl을 GitHub URL로 제한하려는 의도이지만, 다음과 같은 변형과는 매칭되지 않습니다.
>
> * URL 앞의 옵션: `curl -X GET http://github.com/...`
> * 다른 프로토콜: `curl https://github.com/...`
> * 리디렉트: GitHub로 리디렉트되는 `curl -L http://short.example.com/xyz`
> * 변수: `URL=http://github.com && curl $URL`
>
> 보다 신뢰할 수 있는 URL 필터링을 위해 다음을 고려하십시오.
>
> * **Bash 네트워크 도구 제한**: 거부 규칙을 사용하여 `curl`, `wget` 및 유사한 명령을 차단한 다음, 허용된 도메인에 대해 `WebFetch(domain:github.com)` 권한으로 WebFetch 도구를 사용합니다. 거부 규칙은 경로로 호출되거나 `sh -c` 안에서 호출된 동일한 프로그램과는 매칭되지 않으므로, 제한이 반드시 유지되어야 한다면 [샌드박스 네트워크 허용 목록](https://code.claude.com/docs/ko/sandboxing.md#network-isolation)과 함께 사용하십시오. [Bash 규칙이 매칭하지 않는 것](#bash-rule-limits)을 참조하십시오.
> * **PreToolUse 훅 사용**: Bash 명령의 URL을 검증하고 허용되지 않은 도메인을 차단하는 훅을 구현합니다.
> * **CLAUDE.md 지침 추가**: 허용되는 curl 패턴을 `CLAUDE.md`에 설명합니다. 이는 Claude가 시도하는 내용에 영향을 주지만 경계를 강제하지는 않으므로, 위의 옵션 중 하나와 함께 사용하십시오.
>
> WebFetch만 사용해서는 네트워크 접근을 막을 수 없다는 점에 유의하십시오. Bash가 허용되어 있으면 Claude는 여전히 `curl`, `wget` 또는 다른 도구를 사용하여 모든 URL에 접근할 수 있습니다.

#### 리디렉션

명령이 출력이나 입력을 리디렉션하면, Claude Code는 Claude가 해당 파일을 직접 쓰거나 읽는 것처럼 리디렉션 대상을 파일 규칙과 대조하여 검사합니다.

* **출력 리디렉션**: `> file`, `>> file`, `2> file`의 경우, 검사는 `Edit` 허용 및 거부 규칙, [보호된 경로](https://code.claude.com/docs/ko/permission-modes.md#protected-paths), [작업 디렉터리](#working-directories)를 대상으로 합니다. `Bash(git commit *)` 같은 규칙은 대상이 아닌 명령을 허용합니다. `~`로 시작하거나 glob 문자를 포함하는 대상은 사용자의 승인이 필요합니다.
* **입력 리디렉션**: `< file`의 경우, 검사는 `Read` 허용 및 거부 규칙과 작업 디렉터리를 대상으로 합니다. 작업 디렉터리 밖의 대상은 허용 규칙이 이를 포함하지 않는 한 사용자의 승인이 필요하며, 허용 규칙이 포함하면 승인이 필요하지 않습니다. glob 패턴을 포함하는 대상, 또는 같은 명령에서 `cd` 뒤에 오는 상대 경로는 허용 규칙이 포함하더라도 사용자의 승인이 필요합니다. Claude Code는 v2.1.257 이상에서 입력 대상을 검사합니다.

뒤에 파일이 없는 대상은 검사하지 않습니다. `/dev/null`, `2>&1`과 `<&3` 같은 파일 디스크립터 형태, 그리고 here-doc과 here-string이 이에 해당합니다.

Claude Code는 `make | tee build.log` 같은 파이프라인을 포함하여 `tee` 명령이 쓰는 파일도 검사합니다. 검사는 `Edit` 허용 및 거부 규칙, [보호된 경로](https://code.claude.com/docs/ko/permission-modes.md#protected-paths), [작업 디렉터리](#working-directories)를 대상으로 합니다. `Bash(tee *)` 같은 허용 규칙은 작업 디렉터리 밖의 대상을 포함하지 않습니다. Claude Code는 v2.1.269 이상에서 `tee` 대상을 검사합니다.

### PowerShell

PowerShell 권한 규칙은 [Bash 규칙](#wildcard-patterns)과 같은 형태를 사용하며, 단독 `PowerShell` 또는 `PowerShell(*)`은 모든 명령과 매칭됩니다. 다음 구성은 `Get-ChildItem`과 `git commit` 명령을 허용하고 `Remove-Item`은 차단합니다.

```json theme={null}
{
  "permissions": {
    "allow": [
      "PowerShell(Get-ChildItem *)",
      "PowerShell(git commit *)"
    ],
    "deny": [
      "PowerShell(Remove-Item *)"
    ]
  }
}
```

일반적인 별칭은 매칭 전에 정규화됩니다. cmdlet 이름으로 작성된 규칙은 해당 별칭에도 매칭되므로, `PowerShell(Get-ChildItem *)`은 `gci`, `ls`, `dir`에도 매칭됩니다. 매칭은 대소문자를 구분하지 않습니다.

Claude Code는 PowerShell AST를 파싱하여 복합 명령의 각 명령을 독립적으로 검사합니다. 파이프라인 연산자 `|`, 문 구분자 `;`, 그리고 PowerShell 7 이상에서는 체인 연산자 `&&`와 `||`가 복합 명령을 하위 명령으로 분할합니다. 복합 명령이 프롬프트 없이 실행되려면 모든 하위 명령이 허용되어야 합니다. 예를 들어 허용 규칙과 매칭되면 허용됩니다.

### Read 및 Edit

Claude의 파일 도구가 파일이나 디렉터리를 읽지 못하도록 차단하려면 `Read(./.env)`나 `Read(./secrets/**)`처럼 해당 경로에 대한 `Read` 거부 규칙을 추가하십시오. [민감한 파일 제외](https://code.claude.com/docs/ko/settings-reference.md#exclude-sensitive-files)에 바로 붙여 넣을 수 있는 예시가 있습니다. 프로젝트에 `.claudeignore` 파일이 있더라도 아무 효과가 없으므로, 해당 항목을 `Read` 거부 규칙으로 옮기십시오.

#### `Read` 및 `Edit` 규칙이 적용되는 범위

`Edit` 규칙은 파일을 편집하는 모든 내장 도구에 적용됩니다. Claude는 `Read` 규칙을 Grep 및 Glob처럼 파일을 읽는 모든 내장 도구, 프롬프트의 `@file` 멘션, 그리고 연결된 [IDE](https://code.claude.com/docs/ko/vs-code.md#the-built-in-ide-mcp-server)가 Claude와 공유하는 선택 영역 및 열린 파일 컨텍스트에 최선의 노력으로 적용합니다.

`Read(path)` 거부 규칙은 프롬프트에 붙여 넣은 이미지 경로와 @-멘션한 디렉터리에도 적용됩니다.

* **이미지 경로**: 터미널에서 이미지 경로를 프롬프트에 붙여 넣거나 이미지 파일을 끌어다 놓았을 때 규칙이 해당 경로와 매칭되면, Claude Code는 이미지를 첨부하지 않습니다. 붙여 넣은 내용에 다른 이미지가 없으면 경로는 프롬프트에 텍스트로 남습니다.
* **디렉터리**: [Claude가 받는 목록](https://code.claude.com/docs/ko/common-workflows.md#reference-files-and-directories)에서 규칙과 매칭되는 파일 및 디렉터리 이름이 제외됩니다.

Claude Code는 v2.1.290 이상에서 붙여 넣은 이미지 경로와 디렉터리 목록을 검사합니다.

`Read` 거부 규칙은 동일한 경로에서 [Edit 및 Write 도구](https://code.claude.com/docs/ko/errors.md#file-is-covered-by-a-read-deny-rule)도 차단하며, 해당 위치에 새 파일을 만드는 것도 포함됩니다. NotebookEdit는 포함되지 않으므로, 어떤 도구도 변경해서는 안 되는 경로에는 `Edit` 거부 규칙을 추가하십시오. Write 도구에 대한 검사는 Claude Code v2.1.228 이상이 필요합니다.

> [!WARNING]
>
> Read 및 Edit 거부 규칙은 Claude의 내장 파일 도구, `cat`, `head`, `tail`, `sed`, `tee`처럼 Claude Code가 Bash에서 인식하는 파일 명령, 그리고 `> file`과 `< file` 같은 Bash [리디렉션](#redirections)의 대상에 적용됩니다. 파일이 있는 디렉터리에서 실행한 `grep -r pattern .`처럼 파일 이름을 지정하지 않고 파일을 읽는 명령이나, 파일을 직접 여는 Python 또는 Node 스크립트처럼 간접적으로 파일을 읽거나 쓰는 임의의 하위 프로세스에는 적용되지 않습니다. 모든 프로세스가 특정 경로에 접근하지 못하도록 OS 수준에서 강제하려면 [샌드박스를 활성화](https://code.claude.com/docs/ko/sandboxing.md)하십시오.

#### 절대 매칭되지 않는 `Write(path)`, `NotebookEdit(path)`, `Glob(path)` 규칙

Claude Code는 파일 권한을 `Edit(path)` 및 `Read(path)` 규칙에 대해서만 검사합니다. `Write`, `NotebookEdit`, `Glob` 또는 레거시 `MultiEdit`에 대한 경로 규칙을 작성하면, Claude Code는 규칙을 받아들이지만 어떤 읽기나 편집도 해당 규칙과 매칭하지 않습니다.

`Write(docs/**)`, `NotebookEdit(docs/**)`, `MultiEdit(docs/**)` 대신 `Edit(docs/**)`를, `Glob(docs/**)` 대신 `Read(docs/**)`를 사용하십시오. 경로와 관계없이 Write, NotebookEdit, Glob 도구의 모든 사용과 매칭하려면 도구 이름만 작성하십시오.

#### 경로 패턴의 매칭 방식

Read와 Edit 규칙은 모두 네 가지 패턴 유형이 있는 [gitignore](https://git-scm.com/docs/gitignore) 패턴 구문을 사용합니다.

| 패턴 | 의미 | 예시 | 매칭 대상 |
| - | - | - | - |
| `//path` | 파일 시스템 루트로부터의 절대 경로 | `Read(//Users/alice/secrets/**)` | `/Users/alice/secrets/**` |
| `~/path` | 홈 디렉터리로부터의 경로 | `Read(~/Documents/*.pdf)` | `/Users/alice/Documents/*.pdf` |
| `/path` | 설정 소스에 상대적인 경로 | `Edit(/src/**/*.ts)` | 프로젝트 설정에서 `<primary working directory>/src/**/*.ts` |
| `path` 또는 `./path` | 현재 디렉터리에 상대적인 경로 | `Read(*.env)` | `<cwd>/*.env` |

> [!WARNING]
>
> `/Users/alice/file` 같은 패턴은 절대 경로가 아닙니다. 앞에 붙은 단일 슬래시는 파일 시스템 루트가 아니라 설정 소스를 기준으로 고정됩니다. 절대 경로에는 `//Users/alice/file`을 사용하십시오.

##### 패턴의 고정 기준

`/path` 패턴은 이를 정의한 설정 소스와 연관된 디렉터리를 기준으로 고정되므로, 같은 규칙이라도 어디에 두느냐에 따라 다른 위치와 매칭됩니다.

| 규칙이 정의된 곳 | `/path`가 해석되는 위치 |
| :- | :- |
| `.claude/settings.json`의 프로젝트 설정 | `<primary working directory>/path` |
| `.claude/settings.local.json`의 로컬 설정 | `<primary working directory>/path` |
| `~/.claude/settings.json`의 사용자 설정 | `~/.claude/path` |
| `--settings <file>`로 전달된 파일 | `<directory of file>/path` |
| CLI 플래그 또는 세션 규칙 | `<primary working directory>/path` |

`/permissions`를 통해 추가한 규칙은 저장한 설정 파일에 해당하는 행을 따릅니다.

로컬 설정 규칙은 Claude Code가 [파일을 저장하는](#permission-system) 저장소 루트가 아니라 세션의 [기본 작업 디렉터리](#working-directories)를 기준으로 고정됩니다. 저장소 루트에서 시작한 세션에서는 두 디렉터리가 같습니다. [worktree](https://code.claude.com/docs/ko/worktrees.md) 세션에서는 `Edit(/src/**)` 같은 공유 규칙이 해당 워크트리 자체의 `src/` 디렉터리와 매칭됩니다.

사용자 설정의 `Read(/secrets/**)` 같은 거부 규칙은 프로젝트의 `secrets` 디렉터리가 아니라 `~/.claude/secrets/**`를 차단합니다. 모든 프로젝트 내부에 적용되는 규칙을 사용자 설정에 작성하려면 대신 `//` 절대 경로나 `~/` 홈 상대 경로를 사용하십시오.

Windows에서는 경로가 매칭 전에 POSIX 형식으로 정규화됩니다. `C:\Users\alice`는 `/c/Users/alice`가 되므로, 해당 드라이브 어디에 있든 `.env` 파일과 매칭하려면 `//c/**/.env`를 사용하십시오. 모든 드라이브에 걸쳐 매칭하려면 `//**/.env`를 사용하십시오.

예시:

* `Edit(/docs/**)`: `<primary working directory>/docs/`에서의 편집이며, `/docs/`나 `<primary working directory>/.claude/docs/`는 해당하지 않습니다
* `Read(~/.zshrc)`: 홈 디렉터리의 `.zshrc`를 읽습니다
* `Edit(//tmp/scratch.txt)`: 절대 경로 `/tmp/scratch.txt`를 편집합니다
* `Read(src/**)`: 허용 규칙으로는 `<current-directory>/src/`에서만 읽고, 거부 또는 확인 규칙으로는 현재 디렉터리 아래 모든 깊이의 `src` 디렉터리와 매칭됩니다

##### 패턴의 매칭 깊이

규칙은 고정 기준 아래의 파일과만 매칭됩니다. 그 범위 안에서 매칭 깊이는 패턴 형태에 따라, 그리고 단일 세그먼트 디렉터리 패턴의 경우 아래에서 설명하는 규칙 유형에 따라 달라집니다. 파일 이름만 있는 패턴은 gitignore 의미 체계를 따르며 모든 깊이에서 매칭되므로, `Read(.env)`와 `Read(**/.env)`는 동등합니다.

| 거부 규칙 | 차단 대상 | 차단하지 않는 대상 |
| - | - | - |
| `Read(.env)` 또는 `Read(**/.env)` | 현재 디렉터리 또는 그 아래의 모든 `.env` | 상위 디렉터리나 다른 프로젝트의 `.env` |
| `Read(//**/.env)` | 파일 시스템 어디에 있든 모든 `.env` | 없음. 규칙이 파일 시스템 루트에 고정되어 있습니다 |

`src/**`처럼 디렉터리 세그먼트가 하나인 상대 패턴은 규칙 유형에 따라 다른 깊이에서 매칭됩니다.

* **허용 규칙**: `Edit(src/**)`는 `<cwd>/src`와 그 아래의 파일과만 매칭됩니다. 모든 깊이의 디렉터리 이름을 허용하려면 `Edit(**/src/**)`를 작성하십시오.
* **거부 및 확인 규칙**: `Read(secrets/**)`는 현재 디렉터리 아래 모든 깊이에 있는 `secrets`라는 이름의 디렉터리와 매칭되므로, 규칙이 중첩된 사본에도 적용됩니다.

그 밖의 모든 패턴 형태는 모든 규칙 유형에서 같은 깊이로 매칭됩니다. `Edit(/src/**)`와 `Edit(src/components/**)`는 고정된 위치에서만 매칭되고, `Edit(**/src/**)`는 모든 깊이에서 매칭됩니다.

다음 예시는 최상위 `src/` 디렉터리와 `vendor/` 아래에 중첩된 사본이 있는 프로젝트에 각 패턴 형태를 적용한 결과를 보여 줍니다.

```text theme={null}
<current-directory>/
├── src/
│   └── app.ts
└── vendor/
    └── pkg/
        └── src/
            └── lib.js
```

| 규칙 | `src/app.ts`와 매칭 | `vendor/pkg/src/lib.js`와 매칭 |
| :- | :- | :- |
| 허용 규칙으로서의 `Edit(src/**)` | 예 | 아니요 |
| 거부 또는 확인 규칙으로서의 `Edit(src/**)` | 예 | 예 |
| 모든 규칙 유형에서의 `Edit(/src/**)` | 예 | 아니요 |
| 모든 규칙 유형에서의 `Edit(**/src/**)` | 예 | 예 |

> [!NOTE]
>
> gitignore 패턴에서 `*`는 단일 경로 세그먼트 내에서 매칭되며 패턴의 어느 위치에나 올 수 있고, `**`는 디렉터리를 가로질러 매칭됩니다.

#### 특수 문자와 `!` 부정

"Yes, and don't ask again"으로 파일 경로를 승인하면, Claude Code는 해당 경로의 `[`, `]`, `*` 같은 gitignore 패턴 문자를 이스케이프하므로, 생성된 규칙은 승인한 리터럴 경로와만 매칭됩니다. 직접 작성한 규칙은 이스케이프되지 않습니다.

경로의 괄호는 이스케이프할 필요가 없으므로, `Edit(./Finance (2024)/**)`는 표기된 그대로 `Finance (2024)` 폴더와 매칭됩니다.

경로를 gitignore 패턴으로 사용할 수 없는 거부 또는 확인 규칙도 해당 정확한 경로는 여전히 보호합니다. 사용할 수 없는 패턴이 있는 허용 규칙은 아무것도 승인하지 않습니다.

`!`로 시작하는 거부 또는 확인 패턴은 gitignore 부정입니다. 이 패턴은 앞에 나열된 `path` 또는 `./path` 규칙에서 자신과 매칭되는 경로를 제외합니다. 하나의 설정 파일의 `deny` 목록에서 `Read(*.env)` 뒤에 `Read(!sample.env)`가 오면, 이름이 `sample.env`인 파일을 제외하고 모든 깊이에서 이름이 `.env`로 끝나는 모든 파일이 차단됩니다. 처음에 나열된 `!` 규칙은 아무것도 제외하지 않습니다.

제외는 같은 소스의 규칙에만 적용됩니다. 프로젝트 설정이나 `--disallowedTools`의 `Read(!.env)`는 관리형 설정이나 다른 설정 파일의 `Read(./.env)` 거부를 취소하지 않습니다.

`!` 패턴이 제외할 수 있는 범위는 두 가지 제한으로 좁혀집니다.

* Claude Code는 `!` 뒤에 `/`, `~/`, `//`가 오더라도 `!` 패턴을 현재 디렉터리를 기준으로 읽으므로, 이 패턴은 해당 접두사 중 하나로 고정된 규칙에 닿을 수 없습니다. `Read(!~/notes/public/**)`는 `Read(~/notes/**)`에서 아무것도 제외하지 않습니다.
* 제외로는 규칙이 전체를 차단하는 디렉터리 안의 파일을 다시 열 수 없습니다. `Read(secrets/**)`와 `Read(!secrets/public/**)`가 있으면, Claude Code는 `secrets`의 나머지 부분과 함께 `secrets/public`도 계속 차단합니다.

#### 심볼릭 링크

Claude가 요청한 파일 경로가 심볼릭 링크를 거치는 경우, 권한 검사는 Claude가 요청한 경로와 그 경로가 해석되는 파일이라는 두 경로를 대상으로 합니다. 이는 macOS, Linux, Windows의 심볼릭 링크와 Windows의 디렉터리 정션에 적용됩니다.

##### 규칙이 심볼릭 링크 경로와 매칭되는 방식

허용 규칙과 거부 규칙은 요청된 경로와 그 경로가 해석되는 파일을 서로 다르게 취급합니다.

* **허용 규칙**: 요청된 경로와 해석되는 파일이 모두 매칭될 때만 적용됩니다. 허용된 디렉터리 안에 있으면서 그 밖을 가리키는 심볼릭 링크를 통한 읽기는 규칙과 매칭되지 않습니다.
* **거부 규칙**: 요청된 경로 또는 해석되는 파일 중 하나라도 매칭되면 적용됩니다. 거부된 파일을 가리키는 심볼릭 링크는 그 자체로 거부됩니다. 예를 들어 `Read(./project/**)`가 허용되고 `Read(~/.ssh/**)`가 거부된 경우, `~/.ssh/id_rsa`를 가리키는 `./project/key`의 심볼릭 링크는 차단됩니다. 대상이 허용 규칙을 충족하지 못하고 거부 규칙과 매칭되기 때문입니다.

macOS와 Linux에서 `//`, `~/`, `/` 패턴으로 심볼릭 링크된 디렉터리를 통해 작성한 거부 또는 확인 규칙은 디렉터리의 실제 위치에도 적용됩니다. 예를 들어 `/etc`가 `/private/etc`로 해석되는 macOS에서는 `Read(//etc/**)`가 `/private/etc/hosts`도 차단합니다. v2.1.268 이전에는 심볼릭 링크된 디렉터리를 통해 작성한 거부 또는 확인 규칙이 실제 위치로 지정된 경로에 적용되지 않았습니다.

Grep과 Glob은 `path` 인수가 해석되는 디렉터리를 검색합니다. Claude Code는 해당 디렉터리에 `Read` 거부 규칙을 적용합니다.

##### 심볼릭 링크를 통한 첨부

`Read` 거부 규칙은 다음 첨부도 포함하며, 각각을 지정된 경로 또는 해석되는 파일 중 하나와 매칭합니다. 규칙과 매칭되는 첨부는 Claude Code가 대화에서 제외합니다.

* **`@`-멘션**: 프롬프트에서 멘션한 파일 또는 디렉터리. 거부된 파일은 대화에 아무것도 남기지 않으며, [디렉터리 목록](#read-and-edit)에서는 규칙이 포함하는 이름이 제외됩니다.
* **붙여 넣은 이미지**: 터미널에서 경로를 프롬프트에 붙여 넣거나 끌어다 놓은 이미지
* **변경된 파일**: 디스크에서 변경된 후 Claude Code가 다시 읽는 파일
* **IDE 컨텍스트**: 연결된 IDE가 공유하는 선택 영역 및 열린 파일 컨텍스트

[`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)가 켜져 있거나 [`--restricted`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 세션인 경우, 해당 설정이나 플래그가 Claude의 파일 읽기를 거부하는 경로에서 온 첨부도 제외됩니다.

`@`-멘션한 파일 대신 다음 줄이 표시되면, 예를 들어 심볼릭 링크가 루프를 형성하는 등의 이유로 Claude Code가 경로가 어디로 이어지는지 파악하지 못했다는 뜻입니다.

```text theme={null}
Referenced <path> (not read: could not be examined)
```

이 경우 Claude는 대신 파일 도구로 경로를 읽도록 안내받으며, Claude Code가 경로를 검사할 시간이 부족했을 뿐이라면 이 방법이 성공할 수 있습니다.

경로의 심볼릭 링크가 해석되지 않으면 해당 읽기도 [거부](https://code.claude.com/docs/ko/errors.md#refusing-after-a-symlink-changed)되므로, 디스크의 링크를 수정하거나 해석되는 경로로 파일을 `@`-멘션하십시오.

##### 심볼릭 링크를 통한 쓰기

Claude가 편집하거나 쓰려는 경로 자체가 심볼릭 링크인 경우, Edit 및 Write 도구는 [쓰기를 거부하고 Claude에게 링크의 대상을 안내합니다](https://code.claude.com/docs/ko/errors.md#refusing-after-a-symlink-changed).

파일로 가는 경로상의 디렉터리가 심볼릭 링크이거나 Bash 또는 PowerShell 명령이 쓰기를 수행하는 경우에는 쓰기가 여전히 심볼릭 링크를 통과할 수 있습니다. 이러한 쓰기의 결과는 쓰기가 해석되는 파일이 [작업 디렉터리](#working-directories) 및 [보호된 경로](https://code.claude.com/docs/ko/permission-modes.md#protected-paths)에 대해 어디에 있는지에 따라 달라집니다.

* **작업 디렉터리 밖으로 해석되는 경우**: 요청된 경로는 작업 디렉터리 안에 있지만 해석되는 파일은 그렇지 않으면, [`acceptEdits` 모드](https://code.claude.com/docs/ko/permission-modes#auto-approve-file-edits-with-acceptedits-mode)에서 쓰기가 자동 승인되지 않습니다. [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서는 허용 규칙이 쓰기를 승인하지 않는 한, 분류기가 결정하는 대신 사용자에게 확인을 요청합니다. 프롬프트에는 쓰기가 해석되는 경로가 표시됩니다.
* **요청된 경로가 지정하지 않은 보호된 경로로 해석되는 경우**: [보호된 경로 표](https://code.claude.com/docs/ko/permission-modes.md#protected-paths)에 각 권한 모드별 결과가 나와 있습니다. 단, 표에서 쓰기를 분류기로 보내는 경우에는 이 쓰기가 대신 사용자에게 확인을 요청합니다.

##### 해석할 수 없거나 변경되는 경로

예를 들어 경로상의 심볼릭 링크가 루프를 형성하여 Claude Code가 경로가 디스크의 어디로 이어지는지 판단할 수 없으면, Read, Edit, Write 도구는 [작업을 거부합니다](https://code.claude.com/docs/ko/errors.md#refusing-after-a-symlink-changed).

이후 도구가 승인된 파일을 열 때, [경로가 여전히 권한 검사에서 승인된 위치로 해석되는지 확인합니다](https://code.claude.com/docs/ko/errors.md#refusing-after-a-symlink-changed).

#### 네트워크 경로

Read, Grep, Glob 같은 Claude의 파일 읽기 도구가 네트워크 경로에서 읽을 때, 해당 읽기에는 별도의 권한 검사가 적용됩니다. 네트워크 경로는 다른 컴퓨터에 접근할 수 있는 경로로, Windows에서는 `\\server\share\file` 같은 UNC 경로이고, macOS와 Linux에서는 `/net/fileserver/notes.txt` 같은 `/net` 자동 마운트 경로입니다. 이러한 경로를 조회하면 경로가 가리키는 호스트에 연결될 수 있으며, Windows에서는 그 연결로 자격 증명이 호스트에 전송될 수 있습니다. 셸 명령에는 별도의 검사가 있습니다. Manual 모드에서 인수에 UNC 경로가 포함된 읽기 전용 Bash 또는 PowerShell 명령은 [Windows에서 여전히 확인을 요청합니다](#read-only-commands).

Claude Code v2.1.292 이상에서는 다음 각각이 프롬프트를 그대로 유지합니다.

* **허용 규칙**: `Read`처럼 도구 전체에 대한 규칙을 포함하여, 규칙이 읽기를 사전 승인하지 않습니다
* **PreToolUse 훅**: `"allow"`를 반환하는 [훅](#extend-permissions-with-hooks)이 프롬프트를 건너뛰지 않습니다
* **자동 모드**: 프롬프트가 사용자에게 전달되며, [분류기](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 읽기를 결정하지 않습니다

`dontAsk` 모드에서는 Claude Code가 확인을 요청하는 대신 읽기를 거부합니다. `bypassPermissions` 모드, 그리고 [권한 우회](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)를 사용할 수 있는 플랜 모드의 대화형 터미널 세션에서는 이 프롬프트 없이 읽기가 실행됩니다.

이 프롬프트 없이 네트워크 공유의 파일을 읽으려면 먼저 공유에 로컬 경로를 부여하십시오.

* **Windows**: [작업 디렉터리](#working-directories)에서 설명하는 대로 공유를 드라이브 문자에 매핑하고, Claude Code를 시작할 때 `--add-dir`로 해당 드라이브를 전달합니다. `Z:`에 매핑된 공유의 경우 PowerShell에서 `claude --add-dir Z:\`를 실행합니다.
* **macOS 및 Linux**: [작업 디렉터리가 네트워크 경로임](https://code.claude.com/docs/ko/errors.md#working-directory-is-a-network-path)에서 설명하는 대로 `/mnt`나 `/Volumes` 아래의 디렉터리 같은 로컬 경로에 공유를 마운트하고 그곳에서 파일을 읽습니다

### WebFetch

WebFetch 규칙은 `domain:` 접두사를 사용하며 요청된 URL의 호스트 이름과 매칭됩니다. 매칭은 대소문자를 구분하지 않고, `*` 와일드카드를 지원하며, 규칙과 호스트 이름 모두에서 끝의 `.`을 제거하므로 `example.com.`과 `example.com`은 동일하게 취급됩니다.

* `WebFetch(domain:example.com)`은 `example.com`에 대한 요청과만 매칭됩니다. `api.example.com` 같은 하위 도메인도 포함하려면 `WebFetch(domain:*.example.com)` 규칙을 추가하십시오
* `WebFetch(domain:*.example.com)`은 `api.example.com`이나 `a.b.example.com`처럼 모든 깊이의 하위 도메인과 매칭되지만, `example.com` 자체와는 매칭되지 않습니다
* `WebFetch(domain:*)`은 모든 도메인과 매칭됩니다. 이는 단독 `WebFetch` 규칙과 같지 않습니다. [모든 가져오기 허용 또는 거부](#allow-or-deny-every-fetch)를 참조하십시오

앞에 오는 `*.`이나 단독 `*` 이외의 위치에서 와일드카드는 두 점 사이의 텍스트와만 매칭됩니다. `WebFetch(domain:example.*)`은 `*`가 `org`가 되는 `example.org`와는 매칭되지만, `*`가 `evil.com`이 되어 점을 넘어야 하는 `example.evil.com`과는 매칭되지 않습니다. 이를 통해 끝에 오는 와일드카드가 공격자가 등록할 수 있는 도메인과 매칭되는 것을 방지합니다.

`WebFetch` 규칙의 와일드카드가 가져오기와 매칭되려면 Claude Code v2.1.172 이상이 필요합니다.

#### 모든 가져오기 허용 또는 거부

단독 `WebFetch` 규칙은 `"deny": ["WebFetch"]`처럼 `domain:` 부분 없이 도구 이름만 있는 규칙입니다. 이 규칙과 `WebFetch(domain:*)`은 모두 모든 URL을 포함하지만 Claude Code는 이 둘을 다르게 적용하며, `domain:` 형태만 샌드박스의 [허용 또는 거부 도메인 목록](https://code.claude.com/docs/ko/sandboxing.md#network-isolation)에도 해당 도메인을 추가합니다. 해당 섹션에는 샌드박스가 따르는 와일드카드 형태와 단독 `*`가 추가된 버전이 나와 있습니다.

각 행은 규칙이 `allow` 목록과 `deny` 목록에서 어떤 동작을 하는지 보여 줍니다.

| 규칙 | `allow`에 있을 때 | `deny`에 있을 때 |
| :- | :- | :- |
| `WebFetch` | Claude가 확인을 요청하지 않고 가져옵니다. 샌드박스 명령이 접근할 수 있는 호스트는 변경되지 않습니다. | Claude Code가 `WebFetch` 도구를 제거하므로 Claude는 가져오기를 전혀 할 수 없습니다. 샌드박스 명령이 접근할 수 있는 호스트는 변경되지 않습니다. |
| `WebFetch(domain:*)` | Claude가 확인을 요청하지 않고 가져오며, 샌드박스 명령은 모든 호스트에 접근할 수 있습니다. | Claude Code는 도구를 유지하되 각 가져오기를 거부하며, 샌드박스 명령은 어떤 호스트에도 접근할 수 없습니다. |

두 형태는 Artifact 도구가 claude.ai에 게시하는 페이지인 [아티팩트](https://code.claude.com/docs/ko/artifacts.md)의 읽기에서도 다릅니다. 단독 `WebFetch` 거부 또는 확인 규칙은 이러한 읽기에 적용되지 않습니다. `WebFetch(domain:claude.ai)`나 `WebFetch(domain:*)`처럼 `claude.ai` 또는 `*.claudeusercontent.com` 콘텐츠 호스트를 포함하는 `domain:` 규칙은 각 읽기를 거부하거나 읽기 전에 확인을 요청합니다. [`Artifact` 규칙](https://code.claude.com/docs/ko/artifacts#disable-artifacts)도 같은 동작을 합니다.

규칙이 읽기를 차단하면 거부 메시지에 해당 규칙이 표시됩니다. v2.1.268 이전에는 단독 `WebFetch` 거부 규칙이 모든 아티팩트 읽기를 차단했고, 단독 확인 규칙은 각 읽기 전에 확인을 요청했습니다.

샌드박스 허용 목록을 그대로 유지하면서 Claude가 자유롭게 가져오도록 하려면 단독 형태를 사용하십시오. 다음 `settings.json`이 이를 수행합니다.

```json theme={null}
{
  "permissions": {
    "allow": ["WebFetch"]
  }
}
```

Claude에게 페이지를 가져오도록 요청하면 프롬프트 없이 가져옵니다. 샌드박스 허용 목록 밖의 호스트를 대상으로 [샌드박스](https://code.claude.com/docs/ko/sandboxing.md) `curl`을 실행하도록 요청하면, Claude Code는 여전히 해당 호스트에 대해 확인을 요청합니다. 단독 규칙은 호스트를 허용 목록에 추가하지 않았기 때문입니다.

[자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서는 대신 Claude가 분류기가 검토할 수 있도록 명령의 [명령별 허용 도메인](https://code.claude.com/docs/ko/sandboxing.md#per-command-allowed-domains-in-auto-mode)에 호스트를 지정합니다.

### MCP

MCP 서버의 모든 도구와 매칭하려면 `mcp__<server>__*`를 작성하십시오. 하나의 도구와 매칭하려면 전체 이름인 `mcp__<server>__<tool>`을 작성하십시오.

* `mcp__puppeteer`는 `puppeteer` 서버가 제공하는 모든 도구와 매칭됩니다
* `mcp__puppeteer__*`는 와일드카드 구문을 사용하며 역시 `puppeteer` 서버의 모든 도구와 매칭됩니다
* `mcp__puppeteer__puppeteer_navigate`는 `puppeteer` 서버가 제공하는 `puppeteer_navigate` 도구와 매칭됩니다

`<server>`에는 해당 서버의 도구 이름에 나타나는 방식 그대로 서버 이름을 작성하십시오. 다음 예시는 특수 문자가 있는 이름, 플러그인의 서버, 그리고 `__`를 포함하거나 `_`로 끝나는 이름에 대해 작성할 규칙을 보여 줍니다.

* **`.`이나 공백 같은 문자가 있는 이름**: 해당 문자는 `_`가 되므로, `my.server`로 구성한 서버의 경우 `mcp__my_server__*`를 작성합니다
* **플러그인이 제공하는 서버**: `<server>`는 [플러그인 범위 형태](https://code.claude.com/docs/ko/mcp.md#plugin-provided-mcp-servers)를 취하므로, `my-plugin`이라는 플러그인의 `database-tools` 서버의 경우 `mcp__plugin_my-plugin_database-tools__*`를 작성합니다
* **`__`를 포함하거나 `_`로 끝나는 `<server>`**: 전체 이름으로 와일드카드 형태인 `mcp__<server>__*`를 작성합니다. `reports__v2`라는 서버의 경우 `mcp__reports__v2__*`를 작성합니다. 단독 `mcp__reports__v2`와 더 짧은 `mcp__reports`는 허용 규칙으로서 해당 서버의 도구와 매칭되지 않습니다. Claude Code가 둘 다 `reports`라는 서버에 대한 규칙으로 읽기 때문입니다.

  그러나 거부 또는 확인 규칙으로서는 이 두 이름이 각각 `reports__v2` 서버의 모든 도구도 포함합니다. `reports`라는 서버만 포함하려면 `mcp__reports__<tool>` 형태로 도구마다 규칙을 하나씩 작성하거나, 서버 중 하나의 이름을 변경하십시오.

조직에서 [claude.ai 커넥터](https://code.claude.com/docs/ko/mcp.md#organization-controls-on-connector-tools) 도구를 `ask`로 설정했고 그 설정이 세션의 Claude Code에 전달되는 경우, 해당 도구에 대한 허용 규칙은 적용되지 않습니다. Claude Code는 `auto` 및 `bypassPermissions` 모드에서도 모든 호출에 대해 확인을 요청합니다. 확인을 요청하지 않는 `dontAsk` 모드에서는 Claude Code가 대신 호출을 거부합니다. Claude Code가 직접 가져오는 커넥터의 도구는 `mcp__claude_ai_<server>__<tool>`로 표시됩니다.

Claude Desktop 앱의 [Cowork](https://claude.com/docs/cowork/overview) 세션에서 Claude는 내장 `Bash` 도구 대신 Cowork의 `mcp__workspace__bash` 도구를 통해 셸 명령을 실행하며, Cowork는 마찬가지로 웹 가져오기를 위해 `mcp__workspace__web_fetch`를 제공합니다. Claude Code는 `Bash` 또는 `WebFetch` 도구 전체를 지정하는 거부 규칙을 이러한 Cowork 도구에도 적용하므로, 관리형 `Bash` 거부 규칙은 Claude가 Cowork에서 셸 명령을 실행하지 못하도록 막습니다. Claude Code가 이러한 호출을 차단하면 메시지에 Cowork 도구가 표시됩니다: `Permission to use mcp__workspace__bash has been denied.` 허용 규칙은 이어지지 않습니다. Claude Code는 `Bash` 허용 규칙을 `mcp__workspace__bash`에 절대 적용하지 않습니다.

### Agent (서브에이전트)

`Agent(AgentName)` 규칙을 사용하여 Claude가 사용할 수 있는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)를 제어합니다.

* `Agent(Explore)`는 Explore 서브에이전트와 매칭됩니다
* `Agent(Plan)`은 Plan 서브에이전트와 매칭됩니다
* `Agent(my-custom-agent)`는 `my-custom-agent`라는 이름의 사용자 지정 서브에이전트와 매칭됩니다

특정 에이전트를 비활성화하려면 설정의 `deny` 배열에 이러한 규칙을 추가하거나 `--disallowedTools` CLI 플래그를 사용하십시오. Explore 에이전트를 비활성화하려면 다음과 같이 합니다.

```json theme={null}
{
  "permissions": {
    "deny": ["Agent(Explore)"]
  }
}
```

### Cd

`Cd` 규칙은 [`/cd` 명령](https://code.claude.com/docs/ko/commands)이 세션을 이동시킬 수 있는 디렉터리를 제어합니다. `Cd`는 모델이 호출할 수 있는 도구가 아닙니다. Claude는 이를 호출할 수 없으며, 규칙은 사용자가 직접 `/cd`를 실행할 때만 적용됩니다.

단독 `Cd` 거부 규칙은 `/cd`를 완전히 비활성화합니다. `Cd(<path-pattern>)` 거부 규칙은 매칭되는 대상을 차단합니다. 거부 규칙은 대상이 거쳐 해석되는 각 심볼릭 링크 단계를 포함하여 대상의 모든 표기를 검사하므로, 한 경로에 대해 작성된 규칙은 그 경로로 해석되는 대상도 차단합니다.

`Cd` 허용 규칙을 하나라도 추가하면 `/cd`가 허용 목록 모드로 전환됩니다. 해석된 대상 디렉터리가 허용 규칙 중 하나와 매칭되어야 하며, 그렇지 않으면 `/cd`가 거부합니다. `Cd` 규칙이 구성되어 있지 않으면 `/cd`는 기본 동작을 유지하며 익숙하지 않은 디렉터리를 신뢰할지 확인을 요청합니다.

경로 패턴은 [Read 및 Edit 규칙](#read-and-edit)의 `//`, `~/`, `/` 고정 기준을 공유하지만, 매칭은 gitignore 스타일이 아니라 디렉터리 경로 전체에 고정됩니다. `*`는 정확히 하나의 경로 세그먼트와 매칭되고 `**`는 세그먼트를 가로질러 매칭됩니다. 끝에 오는 `/**`는 지정된 루트와도 매칭됩니다.

| 규칙 | 매칭 대상 | 매칭되지 않는 대상 |
| - | - | - |
| `Cd(~/code/*)` | `~/code/app` | `~/code/app/src`, `~/code` |
| `Cd(~/code/**)` | `~/code`와 그 아래의 모든 디렉터리 | `~/code` 밖의 디렉터리 |
| `Cd(**/node_modules)` | 현재 디렉터리 아래 모든 깊이의 `node_modules` 디렉터리 | `node_modules/pkg` |

## 훅으로 권한 확장

[Claude Code 훅](https://code.claude.com/docs/ko/hooks-guide.md)을 사용하면 런타임에 권한을 평가하는 사용자 정의 셸 명령을 등록할 수 있습니다. Claude Code가 도구 호출을 수행할 때, PreToolUse 훅은 [`EndConversation`](https://code.claude.com/docs/ko/tools-reference#endconversation-tool-behavior)을 제외한 모든 도구에 대해 권한 프롬프트 전에 실행됩니다. 훅 출력은 도구 호출을 거부하거나, 프롬프트를 강제하거나, 프롬프트를 건너뛰어 호출을 진행하도록 할 수 있습니다.

### 규칙, 훅, mod 간의 우선순위

PreToolUse 훅 결정은 권한 규칙을 우회하지 않습니다. Claude Code는 PreToolUse 훅이 반환하는 값에 관계없이 deny 및 ask 규칙을 평가합니다. 일치하는 deny 규칙은 호출을 차단하고, 일치하는 ask 규칙은 훅이 `"allow"` 또는 `"ask"`를 반환했을 때도 여전히 프롬프트합니다. 이는 [권한 관리](#manage-permissions)에서 설명한 deny 우선 우선순위를 유지하며, 관리형 설정에서 설정한 deny 규칙을 포함합니다.

이 우선순위는 설정 파일의 훅과 플러그인의 `hooks/hooks.json`에 있는 훅을 포함합니다. 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)가 [`tool.check`](https://code.claude.com/docs/ko/plugins/mods/events#approve-or-refuse-a-tool-call-before-the-user-is-asked) 이벤트를 처리하면, `PreToolUse` 훅이 실행된 후에 응답합니다. 머신에 [관리형 설정](https://code.claude.com/docs/ko/settings.md#check-what-your-organization-enforces)이 있거나 Team 또는 Enterprise [`/login`](https://code.claude.com/docs/ko/authentication#authentication-precedence)이 세션의 자격 증명인 경우, mod가 호출을 승인해도 다음 결과는 기본적으로 그대로 유지됩니다:

* deny 규칙이 거부하는 호출은 계속 거부되며, 조직에서 이를 변경할 수 있습니다.
* ask 규칙이 확인을 요청할 호출은 여전히 확인을 요청합니다.
* `PreToolUse` 훅 또는 [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)가 확인을 요청할 호출은 여전히 확인을 요청합니다.
* `PreToolUse` 훅이 차단한 호출은 훅이 어느 설정 파일에서 왔는지에 관계없이 계속 차단됩니다.
* [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 또는 Agent SDK [`canUseTool` 콜백](https://code.claude.com/docs/ko/agent-sdk/user-input#handle-tool-approval-requests)에 확인을 요청할 호출은 여전히 해당 도구나 콜백에 전달됩니다.

관리형 설정이 없고 Team 또는 Enterprise `/login`도 세션의 자격 증명이 아닌 경우, mod는 deny 규칙이 거부하는 호출이나 `PreToolUse` 훅이 차단한 호출을 승인할 수 있습니다. 대신 API 키나 장기 [`CLAUDE_CODE_OAUTH_TOKEN`](https://code.claude.com/docs/ko/authentication#generate-a-long-lived-token)으로 실행되는 세션은 해당 로그인이 저장되어 있더라도 그 로그인을 사용하지 않습니다.

이 구성에서는 ask 규칙, `PreToolUse` 훅 또는 `permissions.blockReadsOutsideWorkingDirectories`가 확인을 요청할 호출을 mod가 승인하면 확인을 요청하지 않습니다. mod가 승인한 호출에 대해서는 `--permission-prompt-tool` 또는 `canUseTool` 콜백에도 묻지 않습니다. 자동 모드, 플랜 모드, `dontAsk` 모드는 모든 구성에서 각각 고유한 결과를 추가합니다:

* **[자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)**: mod가 승인한 호출은 분류기 확인 없이 실행됩니다. 단, mod가 권한 프롬프트 도구나 Agent SDK 권한 콜백을 우회할 수 없는 경우는 예외이며, 이때는 분류기가 먼저 호출을 확인합니다.
* **[플랜 모드](#hook-approvals-in-plan-mode)**: mod는 파일 편집이나 쓰기를 수행하는 셸 명령처럼 읽기 전용이 아닌 호출을 승인할 수 없습니다.
* **[`dontAsk` 모드](https://code.claude.com/docs/ko/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)**: mod는 모드 외에는 아무것도 거부하지 않을 호출을 승인할 수 있습니다.

[mod를 신뢰할지 결정](https://code.claude.com/docs/ko/plugins/mods/overview.md#decide-whether-to-trust-a-mod)을 참조하거나, 관리형 설정을 배포하는 경우 [조직을 위한 mod 관리](https://code.claude.com/docs/ko/plugins/mods/admin.md#know-what-happens-by-default)를 참조하세요.

`AskUserQuestion` 또는 `requiresUserInteraction`으로 표시된 MCP 도구와 같은 [사용자 상호작용이 필요한 도구](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)의 경우, mod의 `tool.check` 승인은 프롬프트를 건너뛰지 않습니다. Claude Code v2.1.292 이상이 필요합니다. [`requiresUserInteraction`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)으로 표시된 MCP 도구는 훅이 `"allow"`를 반환할 때도 여전히 프롬프트하며, [네트워크 경로](#network-paths)에서의 읽기와 해당 설정이 Claude Code에 도달하는 세션에서 [조직이 `ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구도 마찬가지입니다.

차단 훅은 또한 allow 규칙보다 우선합니다. 종료 코드 2로 종료되는 훅은 권한 규칙이 평가되기 전에 도구 호출을 중지하므로, allow 규칙이 호출을 허용할 수 있는 경우에도 차단이 적용됩니다. 모든 Bash 명령을 프롬프트 없이 실행하되 차단하려는 몇 가지를 제외하려면, allow 목록에 `"Bash"`를 추가하고 해당 특정 명령을 거부하는 PreToolUse 훅을 등록합니다. 적응할 수 있는 훅 스크립트는 [보호된 파일에 대한 편집 차단](https://code.claude.com/docs/ko/hooks-guide.md#block-edits-to-protected-files)을 참조하세요.

### 플랜 모드에서의 훅 승인

[플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에서는 `ExitPlanMode`를 제외하고, `PreToolUse` 훅의 `"allow"`가 파일 편집이나 읽기 전용이 아닌 다른 호출에 아무런 영향을 주지 않습니다. 훅이 없을 때 해당 호출이 받는 것과 동일한 프롬프트, 차단 또는 승인이 적용되며, Claude Code는 훅이 반환하는 `updatedInput`을 여전히 적용합니다. 훅이 [`ExitPlanMode`](https://code.claude.com/docs/ko/hooks#allow-with-updatedinput)에 `"allow"` 및 `updatedInput`으로 응답하면 해당 도구는 여전히 프롬프트 없이 실행됩니다.

플랜 모드에서는 `tool.check`를 처리하는 mod도 파일 편집이나 읽기 전용이 아닌 다른 호출을 승인할 수 없지만, 이러한 호출을 차단할 수는 있습니다. 훅 및 mod 승인에 대한 이 제한을 해제하려면 [플랜을 승인](https://code.claude.com/docs/ko/permission-modes.md#review-and-approve-a-plan)하거나 다른 권한 모드로 전환하세요.

## 작업 디렉토리

기본적으로 Claude는 시작된 디렉토리의 파일에 액세스할 수 있습니다. 이 디렉토리는 [`/cd`](#move-the-session-to-another-directory)로 세션을 이동할 때까지 세션의 기본 작업 디렉토리입니다. 이 액세스를 확장할 수 있습니다:

* **시작 중**: `--add-dir <path>` CLI 인수 사용
* **세션 중**: `/add-dir` 명령 사용
* **영구 구성**: [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)의 `additionalDirectories`에 추가

추가 디렉터리의 파일은 원래 작업 디렉터리와 동일한 권한 규칙을 따릅니다: [네트워크 경로](#network-paths) 검사를 제외하면 확인 요청 없이 읽을 수 있게 되며, 파일 편집 권한은 현재 권한 모드를 따릅니다.

대부분의 [네트워크 경로](https://code.claude.com/docs/ko/errors.md#working-directory-is-a-network-path)(예: UNC 공유 `\\server\share`)는 작업 디렉토리로 추가할 수 없습니다. 이는 조회 시 이름이 지정하는 호스트에 연결할 수 있기 때문입니다. Windows에서는 대신 공유를 드라이브 문자로 매핑하고 시작 시 `--add-dir`으로 드라이브를 전달합니다.

[`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)를 설정하여 파일 도구가 모든 권한 모드에서 경계를 지은 경로를 거부하도록 합니다. 자동 모드에서 Claude Code는 Claude가 [작업 디렉토리 외부에서 읽을](https://code.claude.com/docs/ko/permission-modes.md#first-read-outside-the-working-directories) 때 처음으로 이를 켜도록 제안합니다.

macOS의 백그라운드 세션에서 세션 호스트는 Claude가 파일을 읽거나 쓸 필요가 있을 때 터미널과 별도로 `~/Desktop`, `~/Documents`, `~/Downloads`와 같은 보호된 폴더에 대한 액세스를 요청합니다. 읽기가 `Operation not permitted`로 실패하면 [백그라운드 세션에 폴더 액세스를 부여하는 방법](https://code.claude.com/docs/ko/agent-view.md#background-sessions-can%E2%80%99t-read-desktop-documents-or-downloads-on-macos)을 참조하세요.

### 세션을 다른 디렉토리로 이동

세션을 다른 기본 작업 디렉터리로 이동하려면, 현재 디렉터리 옆에 [디렉터리를 추가](#working-directories)하는 대신 `/cd <path>`를 실행합니다. Claude Code는 대화를 유지하고, 새 디렉터리의 `CLAUDE.md`를 로드하며, 이전에 작업하지 않은 경우 [워크스페이스를 신뢰](#project-allow-rules-and-workspace-trust)하도록 요청합니다. 그 후 Claude Code는 새 디렉터리에서 `--resume`을 실행할 때 [이동된 세션을 찾습니다](https://code.claude.com/docs/ko/sessions.md#where-the-session-picker-looks).

이동하는 즉시 Claude Code는 새 디렉토리의 프로젝트 구성을 적용합니다:

* 권한 규칙 및 [hooks](https://code.claude.com/docs/ko/hooks.md)를 포함한 프로젝트 설정
* [`.mcp.json` 서버](https://code.claude.com/docs/ko/mcp#project-scope)(시작 시와 동일한 [서버 승인](https://code.claude.com/docs/ko/mcp.md#project-server-approvals-and-workspace-trust) 및 [로컬 범위](https://code.claude.com/docs/ko/mcp.md#local-scope) MCP 서버의 적용을 받음)
* 설정이 활성화하는 [plugins](https://code.claude.com/docs/ko/plugins/overview.md), [skills](https://code.claude.com/docs/ko/skills.md#discovery-from-parent-and-nested-directories) 및 [subagents](https://code.claude.com/docs/ko/sub-agents.md)
* 이전 디렉토리의 설정에서 환경 변수 위에 적용되는 [`env`](https://code.claude.com/docs/ko/settings-reference#env) 값(이전 디렉토리의 설정은 계속 적용됨)

Claude Code는 또한 이전 디렉토리의 프로젝트 및 [로컬 범위](https://code.claude.com/docs/ko/mcp.md#local-scope) MCP 서버와 이동 후 더 이상 활성화되지 않는 [plugins](https://code.claude.com/docs/ko/mcp.md#plugin-provided-mcp-servers)의 서버를 연결 해제합니다. 이전 디렉토리의 설정 대신 새 디렉토리의 설정에서 [추가 디렉토리](#working-directories)를 가져오고, `--add-dir` 또는 `/add-dir`으로 추가한 디렉토리를 유지합니다. 이동이 활성화하는 Hooks는 여전히 [`${CLAUDE_PROJECT_DIR}`](https://code.claude.com/docs/ko/hooks#reference-scripts-by-path)를 세션이 시작된 프로젝트 루트로 설정하여 수신합니다.

새 디렉토리를 아직 신뢰하지 않을 때 Claude Code는 신뢰 프롬프트에서 디렉토리의 설정이 활성화할 허용 규칙, 추가 디렉토리, hooks 및 도우미 명령을 나열하므로 수락하기 전에 검토할 수 있습니다. 거부하면 세션은 현재 위치에 유지됩니다. v2.1.246 이전에는 `/cd`가 세션을 재개할 때까지 새 디렉토리의 설정, hooks, MCP 서버 또는 skills를 적용하지 않았으며, 신뢰 프롬프트는 디렉토리의 설정이 활성화할 항목을 나열하지 않았습니다.

[`Cd` 권한 규칙](#cd)으로 `/cd` 대상을 제한하거나 비활성화합니다.

### 추가 디렉토리는 파일 액세스를 부여하며, 구성은 아닙니다

디렉토리를 추가하면 Claude가 파일을 읽고 편집할 수 있는 위치가 확장됩니다. 해당 디렉토리를 전체 구성 루트로 만들지는 않습니다: 대부분의 `.claude/` 구성은 추가 디렉토리에서 발견되지 않지만 몇 가지 유형은 예외로 로드됩니다.

이러한 예외는 `--add-dir` 플래그 또는 `/add-dir` 명령으로 추가된 디렉토리에만 적용됩니다(Agent SDK가 플래그를 통해 추가하는 디렉토리 포함). 설정 파일의 `permissions.additionalDirectories`에 나열된 디렉토리는 파일 액세스만 부여하며 아래의 구성을 로드하지 않습니다.

Agent SDK의 TypeScript [`additionalDirectories`](https://code.claude.com/docs/ko/agent-sdk/typescript#options) 옵션 및 Python [`add_dirs`](https://code.claude.com/docs/ko/agent-sdk/python#claudeagentoptions) 옵션도 예외를 받습니다. TypeScript 옵션이 설정 키와 이름을 공유하지만 SDK는 각 항목을 Claude Code에 `--add-dir`로 전달하므로 이러한 디렉토리는 플래그로 추가된 디렉토리처럼 동작합니다. 모든 플래그로 추가된 디렉토리의 skills, 명령 및 subagents는 `project` [설정 소스](https://code.claude.com/docs/ko/agent-sdk/claude-code-features.md#control-filesystem-settings-with-settingsources)를 통해 로드되므로 CLI에서 [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference)로 해당 소스를 제외하거나 SDK에서 `settingSources`로 제외할 때 로드되지 않으며, [베어 모드](https://code.claude.com/docs/ko/headless.md#start-faster-with-bare-mode)는 이들 중 명령 및 subagents를 건너뜁니다.

다음 구성 유형은 `--add-dir` 디렉토리에서 로드됩니다:

| 구성 | `--add-dir`에서 로드됨 |
| :- | :- |
| `.claude/skills/`의 [Skills](https://code.claude.com/docs/ko/skills.md) | 예, 라이브 리로드 포함 |
| `.claude/commands/`의 [Command files](https://code.claude.com/docs/ko/skills.md#where-skills-live) | 예, 라이브 리로드 없음. 추가된 디렉토리와 프로젝트가 모두 동일한 이름의 명령을 정의할 때 Claude Code는 프로젝트의 명령을 실행합니다 |
| `.claude/agents/`의 [Subagents](https://code.claude.com/docs/ko/sub-agents.md) | 예, 라이브 리로드 없음 |
| `.claude/settings.json` 및 `.claude/settings.local.json`의 [Settings](https://code.claude.com/docs/ko/settings.md) | `enabledPlugins` 및 [`extraKnownMarketplaces`](https://code.claude.com/docs/ko/settings-reference#extraknownmarketplaces) 키만 |
| [CLAUDE.md](https://code.claude.com/docs/ko/memory.md) 파일, `.claude/rules/` 및 `CLAUDE.local.md` | `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`이 설정된 경우에만. `CLAUDE.local.md`는 추가로 `local` 설정 소스가 필요하며, 이는 기본적으로 활성화됩니다 |

[기본 작업 디렉토리](#working-directories)의 하위 디렉토리에서 skills, 명령 및 subagents를 세션 중에 로드하려면 해당 하위 디렉토리의 경로로 `/add-dir`을 실행합니다. Claude Code는 하위 디렉토리가 이미 읽을 수 있으므로 프롬프트 없이 또는 작업 디렉토리를 추가하지 않고 세션의 나머지 부분에 대해 로드합니다. 이는 Claude Code v2.1.257 이상이 필요합니다.

#### 출력 스타일, 훅 및 로컬 설정을 로드하는 위치

Claude Code는 현재 작업 디렉터리 및 해당 부모, `~/.claude/`의 사용자 디렉터리 및 관리형 설정에서 출력 스타일을 발견합니다. 훅 및 기타 `.claude/settings.json` 키는 현재 작업 디렉터리의 `.claude/` 폴더에서 로드되며 부모 디렉터리 폴백이 없고, 사용자 `~/.claude/settings.json` 및 관리형 설정과 함께 로드됩니다.

`.claude/settings.local.json`은 대신 git 저장소 루트에서 로드되며, Claude Code가 하위 디렉터리에서 시작되더라도 마찬가지입니다. 단, Windows와 같이 Claude Code가 [저장소 루트를 사용하지 않는](https://code.claude.com/docs/ko/settings.md#where-claude-code-looks-for-each-file) 경우는 제외됩니다.

프로젝트 전체에서 해당 구성을 공유하려면 다음 방법 중 하나를 사용합니다:

* **사용자 수준 구성**: `~/.claude/agents/`, `~/.claude/output-styles/` 또는 `~/.claude/settings.json`에 파일을 배치하여 모든 프로젝트에서 사용 가능하게 합니다
* **Plugins**: 팀이 설치할 수 있는 [plugin](https://code.claude.com/docs/ko/plugins/overview.md)으로 구성을 패키징하고 배포합니다
* **구성 디렉토리에서 시작**: 원하는 `.claude/` 구성이 포함된 디렉토리에서 Claude Code를 실행합니다

## 권한이 샌드박싱과 상호 작용하는 방식

권한과 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)은 상호 보완적인 보안 계층입니다:

* **권한**은 Claude Code가 사용할 수 있는 도구와 액세스할 수 있는 파일 또는 도메인을 제어합니다. Bash, Read, Edit, WebFetch, MCP 및 다른 모든 도구에 적용되지만, deny 또는 ask 규칙은 다른 도구가 남아 있는 동안 [`EndConversation`](https://code.claude.com/docs/ko/tools-reference#endconversation-tool-behavior)을 차단할 수 없습니다.
* **샌드박싱**은 셸 명령의 파일 시스템 및 네트워크 액세스를 제한하는 OS 수준 적용을 제공합니다. Bash, PowerShell 및 [Monitor](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 도구 명령과 해당 자식 프로세스에 적용됩니다.

심층 방어를 위해 둘 다 사용합니다. 샌드박스 제한은 프롬프트 주입이 Claude의 의사 결정을 우회하더라도 여전히 적용됩니다. 샌드박스 설정과 권한 규칙의 경로 및 도메인은 [최종 샌드박스 구성으로 병합됩니다](https://code.claude.com/docs/ko/sandboxing.md#permission-rules).

샌드박싱을 활성화하고 `autoAllowBashIfSandboxed`를 기본값인 `true`로 유지하면, 권한에 bare `Bash` ask 규칙이 포함되어 있거나 [동등한 `Bash(*)` 형식](#match-all-uses-of-a-tool)이 포함되어 있어도 샌드박스된 Bash 명령은 프롬프트 없이 실행됩니다. 샌드박스 경계는 전체 도구 프롬프트를 대체합니다.

[플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에서 Claude Code는 이 대체를 건너뜁니다. ask 규칙이 없으면 [기본 제공 읽기 전용 명령](#read-only-commands)은 여전히 프롬프트 없이 실행되고, 다른 모든 셸 명령은 계획 중일 때 일반 권한 흐름을 거칩니다. Claude Code가 거기서 명령을 제어하는 방식은 [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)를 참조하십시오. bare `Bash` ask 규칙이 있으면 샌드박스된 읽기 전용 명령을 포함한 모든 Bash 명령이 확인을 요청하며, 이는 샌드박싱 외부와 동일합니다.

이러한 검사는 여전히 적용됩니다:

* `Bash(git push *)`와 같은 콘텐츠 범위 ask 규칙은 여전히 프롬프트를 강제합니다
* [자동 허용 모드](https://code.claude.com/docs/ko/sandboxing.md#auto-allow-mode)에서 설명하는 것처럼 다른 샌드박스된 명령도 일반 권한 흐름을 거칠 수 있습니다

제외된 명령과 같이 샌드박스에서 실행되지 않는 명령은 bare `Bash` ask 규칙을 일반적으로 따릅니다. 이 동작을 변경하려면 [샌드박스 모드](https://code.claude.com/docs/ko/sandboxing.md#sandbox-modes)를 참조하십시오.

## 관리형 설정

중앙 집중식 제어가 필요한 조직의 경우, 관리자는 사용자 및 프로젝트 설정으로 재정의할 수 없는 관리형 설정을 배포합니다. 단, 몇 가지 [보안에 민감한 키](https://code.claude.com/docs/ko/settings.md#exceptions-to-managed-settings-precedence)는 예외입니다. [관리형 설정 배포](https://code.claude.com/docs/ko/managed-settings.md)에서는 전달 메커니즘, 관리형 계층 내 우선순위, 그리고 [관리형 설정만 설정할 수 있는 키](https://code.claude.com/docs/ko/managed-settings.md#managed-only-settings)를 다룹니다.

이러한 키 중 하나인 [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ko/settings-reference#allowmanagedpermissionrulesonly)는 관리형 설정을 권한 규칙의 유일한 설정 소스로 만듭니다. 이 항목은 Claude Code가 무시하는 모든 소스를 나열합니다.

`disableBypassPermissionsMode`는 일반적으로 조직 정책을 적용하기 위해 관리형 설정에 배치되지만, 모든 범위에서 작동합니다. 사용자는 자신의 설정에서 이를 설정하여 자신을 우회 모드에서 잠글 수 있습니다.

## 설정 우선순위

권한 규칙은 다른 모든 Claude Code 설정과 동일한 [설정 우선순위](https://code.claude.com/docs/ko/settings.md#settings-precedence)를 따릅니다. 관리형 설정이 가장 높은 우선순위를 가지며, 명령줄 인수를 포함한 다른 수준은 관리형 권한 규칙을 재정의할 수 없습니다.

도구가 어느 수준에서든 거부되면 다른 수준은 이를 허용할 수 없습니다. 예를 들어, 관리형 설정 deny는 `--allowedTools`로 재정의할 수 없으며, `--disallowedTools`는 관리형 설정이 정의하는 것 이상의 제한을 추가할 수 있습니다.

설정 범위 전체에서도 동일하게 적용됩니다: 사용자 설정에서 권한을 허용하고 프로젝트 설정에서 거부하면, deny 규칙이 이를 차단합니다. 그 반대도 마찬가지입니다: 사용자 수준의 deny는 프로젝트 수준의 allow를 차단합니다. 왜냐하면 모든 범위의 deny 규칙이 allow 규칙보다 먼저 평가되기 때문입니다.

이 우선순위는 설정 파일과 명령줄 인수 간의 관계입니다. deny 규칙이 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)에 대해 유지되는지 여부는 [훅으로 권한 확장](#extend-permissions-with-hooks)을 참조하십시오.

Embedding hosts는 SDK `managedSettings` 옵션을 통해 추가 관리형 정책을 제공할 수 있습니다. 여기에는 관리자가 `allowManaged*Only` 잠금을 설정하지 않은 경우 권한 허용 규칙이 포함됩니다. [Claude Desktop 세션에 정책 전달](https://code.claude.com/docs/ko/claude-apps-gateway#deliver-policy-to-claude-desktop-sessions)에서 embedder 정책이 언제 적용되는지 다룹니다.

## 프로젝트 허용 규칙 및 워크스페이스 신뢰

`permissions.allow` 규칙과 프로젝트의 `.claude/settings.json`에 있는 `permissions.additionalDirectories` 항목은 기능을 부여하므로, Claude Code는 해당 폴더에 대해 [워크스페이스 신뢰 대화상자](https://code.claude.com/docs/ko/security.md#additional-safeguards)를 수락한 후에만 이를 적용합니다. 대화상자는 폴더가 부여할 규칙과 디렉터리를 나열하므로 먼저 검토할 수 있습니다. `deny` 및 `ask` 규칙은 영향을 받지 않습니다. 이들은 제한만 하기 때문입니다.

Claude Code는 시작 위치에 따라 수락한 신뢰를 저장합니다:

* 저장소에서 Claude Code는 git 저장소 루트를 기준으로 신뢰를 저장하므로, 신뢰는 서브모듈과 같은 중첩된 git 저장소를 제외한 전체 저장소를 포함합니다. [worktree](https://code.claude.com/docs/ko/worktrees.md)에서는 [저장된 규칙](#permission-system)과 마찬가지로 주 체크아웃의 루트를 사용합니다.
* 저장소 외부에서 Claude Code는 시작한 디렉터리를 기준으로 신뢰를 저장하며, 신뢰는 클론과 같은 중첩된 git 저장소를 제외한 해당 디렉터리의 모든 하위 디렉터리를 포함합니다. 포함된 각 하위 디렉터리는 상위 디렉터리를 신뢰한 폴더로 간주됩니다.
* 홈 디렉터리에서 시작하면 Claude Code는 현재 세션에만 신뢰를 유지하며 디스크에 기록하지 않습니다. [추가 보안 조치](https://code.claude.com/docs/ko/security.md#additional-safeguards) 참고를 참조하세요.

Claude Code는 대화형 세션에서만 신뢰 대화상자를 표시합니다. `claude -p` 실행이나 SDK 세션은 절대 표시하지 않으며, 상위 폴더를 신뢰해도 이러한 규칙에는 적용되지 않으므로, [폴더를 신뢰하기 전에 실행되는 것](#what-runs-before-you-trust-a-folder)은 이 두 가지 상황 각각에서 Claude Code가 여전히 사용하는 저장소 콘텐츠를 설명합니다.

[배경 세션](https://code.claude.com/docs/ko/agent-view.md)을 시작하거나 다시 시작하기 전에, Claude Code는 세션이 실행되는 디렉터리에 대한 워크스페이스 신뢰도 확인합니다. 신뢰하지 않은 디렉터리의 터미널에서 `claude --bg`를 실행하면, 신뢰 대화상자가 먼저 나타나고 수락하면 세션이 시작됩니다. 스크립트와 같이 대화상자가 나타날 수 없는 곳에서는 명령이 대신 [`Workspace not trusted`](https://code.claude.com/docs/ko/errors#workspace-not-trusted-when-dispatching-a-background-session) 오류로 종료됩니다.

### 로컬 설정 파일이 신뢰가 필요한 경우

`.claude/settings.local.json`은 일반적으로 사용자 자신의 파일이므로 Claude Code는 신뢰 단계 없이 허용 규칙과 추가 디렉터리를 적용합니다. 파일이 git에서 추적되거나 `.claude`가 심볼릭 링크인 경우, Claude Code는 이를 저장소 제공 파일로 취급하고 폴더를 신뢰할 때까지 규칙 적용을 보류합니다.

Claude Code는 git을 실행하여 둘을 구분하며, 폴더를 신뢰한 후에만 git을 실행합니다: 폴더에 대한 신뢰 대화상자를 수락했거나 신뢰가 확장되는 상위 디렉터리에 대해 수락했거나, 수락된 것으로 간주되는 `-p` 또는 SDK 세션에 있습니다. 그 전까지는 Claude Code를 시작한 위치가 파일의 규칙에 어떤 일이 발생하는지 결정합니다:

* **구성 홈에서:** Claude Code는 git을 실행하지 않고 즉시 해당 폴더의 `.claude/settings.local.json`을 적용합니다. 구성 홈은 홈 디렉터리이거나 `.claude` 하위 디렉터리를 [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars#variables)으로 설정한 디렉터리입니다. 해당 `CLAUDE_CONFIG_DIR` 디렉터리가 git 저장소 내부에 있고 Claude Code가 [저장소 루트에서 로컬 설정을 유지](https://code.claude.com/docs/ko/settings.md#where-claude-code-looks-for-each-file)하는 경우, 다른 곳처럼 규칙 적용을 보류합니다.
* **다른 곳:** Claude Code는 프로젝트 설정처럼 파일의 규칙 적용을 보류합니다. 확인이 실행된 후 Claude Code는 추적되지 않은 파일의 규칙이나 git 저장소 외부 디렉터리의 파일 규칙을 적용합니다. 비록 해당 정확한 폴더를 신뢰하지 않았더라도 말입니다.

> [!NOTE]
>
> 구성 홈 예외는 신뢰 단계만 건너뜁니다. `~/.claude/settings.local.json`은 여전히 [로컬 범위](https://code.claude.com/docs/ko/settings.md#compare-the-scope-of-each-settings-file)이므로, Claude Code는 홈 디렉터리 자체에서 시작한 세션에서만 읽으며, 모든 프로젝트에서는 읽지 않습니다. 모든 프로젝트에 걸쳐 권한 규칙을 적용하려면 대신 사용자 설정에 추가하세요: `~/.claude/settings.json` 또는 `CLAUDE_CONFIG_DIR`이 설정된 경우 `$CLAUDE_CONFIG_DIR/settings.json`.

### 폴더를 신뢰하기 전에 실행되는 것

각 행은 저장소가 제공할 수 있는 한 종류의 콘텐츠입니다. 열은 폴더 자체를 신뢰하지 않은 두 가지 상황입니다: 상위 폴더만 신뢰했거나, 신뢰 대화상자를 절대 표시하지 않는 `claude -p` 또는 SDK를 실행했습니다. 상위 폴더 열은 [중첩된 저장소](#project-allow-rules-and-workspace-trust) 내부에는 적용되지 않습니다: 대화형 세션에서 Claude Code는 신뢰 대화상자를 표시하며, `claude -p` 또는 SDK 실행은 `claude -p` 열을 따릅니다.

| 저장소가 제공하는 것 | 상위 폴더만 신뢰한 경우 | `claude -p` 또는 SDK, 폴더를 신뢰하지 않은 경우 |
| :- | :- | :- |
| 설정 파일의 [훅](https://code.claude.com/docs/ko/hooks.md), [`env`](https://code.claude.com/docs/ko/settings-reference#env) 블록 및 [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper)와 같은 도우미 명령, 그리고 프로젝트 스킬의 [훅](https://code.claude.com/docs/ko/hooks.md#hooks-in-skills-and-agents) 및 [`allowed-tools`](https://code.claude.com/docs/ko/skills#pre-approve-tools-for-a-skill) | 사용됨 | 사용됨. 워크스페이스 신뢰는 어떤 세션에서도 스킬의 `allowed-tools`를 제한하지 않습니다 |
| `.claude/settings.json`의 `permissions.allow` 규칙 및 `additionalDirectories` | 신뢰 대화상자를 수락할 때까지 사용되지 않으며, 대화상자는 다시 나타나 이를 나열합니다 | 사용되지 않습니다. Claude Code는 [`this workspace has not been trusted`](https://code.claude.com/docs/ko/errors#workspace-has-not-been-trusted) 경고를 stderr에 출력합니다 |
| 프로젝트 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#hooks-in-subagent-frontmatter)의 frontmatter 훅, 프로젝트 [`@skills-dir` 플러그인](https://code.claude.com/docs/ko/plugins/loading#plugins-shared-through-a-repository), 그리고 저장소 또는 `--add-dir` 디렉터리의 [`extraKnownMarketplaces`](https://code.claude.com/docs/ko/settings-reference#extraknownmarketplaces) 항목 | 사용되지 않으며, 대화상자가 제공되지 않습니다 | 사용되지 않습니다 |
| 저장소 또는 `--add-dir` 디렉터리의 서브에이전트 frontmatter에 있는 인라인 [`mcpServers`](https://code.claude.com/docs/ko/sub-agents#scope-mcp-servers-to-a-subagent) | 사용되지 않으며, 대화상자가 제공되지 않습니다 | 사용되지 않습니다 |
| `.mcp.json`의 서버, 저장소가 [자체 설정에서 승인](https://code.claude.com/docs/ko/mcp.md#project-server-approvals-and-workspace-trust)하는 서버 포함 | Claude Code는 연결하기 전에 묻습니다. 저장소의 자체 승인은 계산되지 않습니다 | 승인 여부와 관계없이 묻지 않고 연결됩니다. SDK는 `settingSources`에 프로젝트 설정이 포함될 때만 로드합니다. 같은 폴더의 `claude mcp list`는 여전히 그러한 서버를 보류 중으로 보고합니다 |
| `.mcp.json`의 서버에 있는 [`headersHelper`](https://code.claude.com/docs/ko/mcp#trust-a-folder-before-its-headershelper-runs) | 신뢰 대화상자를 수락할 때까지 실행되지 않으며, 대화상자는 도우미가 선언된 위치를 다시 이름으로 지정합니다. Claude Code는 그때까지 정적 `headers`만으로 서버를 연결합니다 | 실행되지 않습니다. Claude Code는 정적 `headers`만으로 서버를 연결하고 서버당 [`headersHelper not run`](https://code.claude.com/docs/ko/errors#headershelper-not-run) 줄을 stderr에 출력합니다 |

이 정확한 폴더를 신뢰해야 하는 행의 경우, 수동으로 신뢰하세요: `~/.claude.json`에서 `projects["<path>"].hasTrustDialogAccepted`를 `true`로 설정하세요. 여기서 `<path>`는 저장소 루트이거나 저장소 외부의 폴더입니다. Claude Code는 건너뛴 서브에이전트 훅 또는 인라인 MCP 서버의 디버그 로그 줄에, 건너뛴 허용 규칙의 stderr 경고에, 그리고 건너뛴 도우미의 `headersHelper not run` 줄에 정확한 키를 출력합니다.

작성하지 않은 저장소에서 `claude -p`를 실행하기 전에, 머신에서 실행할 수 있는 것을 결정하세요:

* `--setting-sources user`를 전달하거나, 프로젝트 설정 없이 SDK의 `settingSources`를 설정하여 Claude Code가 프로젝트의 설정 파일이나 `.mcp.json`을 읽지 않도록 합니다
* [`--bare`](https://code.claude.com/docs/ko/headless#start-faster-with-bare-mode)로 시작하여 Claude Code가 프로젝트에서 훅, 스킬, 사용자 정의 명령, 서브에이전트, 플러그인, 또는 `.mcp.json` 서버를 읽지 않도록 합니다. 프로젝트의 `env` 블록 및 설정 파일의 `awsAuthRefresh`와 같은 도우미는 여전히 적용되며, Claude Code는 `apiKeyHelper`를 `--settings`에서만 읽습니다
* `--settings '{"disableAllHooks": true}'`를 전달하여 [해당 실행에 대해 훅을 끕니다](https://code.claude.com/docs/ko/hooks.md#disable-or-remove-hooks). 사용자 설정에만 설정하는 것으로는 충분하지 않습니다. 저장소의 프로젝트 설정이 사용자 설정보다 우선하며 이를 `false`로 다시 설정할 수 있기 때문입니다
* [`disabledMcpjsonServers`](https://code.claude.com/docs/ko/settings-reference#disabledmcpjsonservers) 항목을 추가하여 모든 세션 유형에서 이름으로 `.mcp.json` 서버를 거부합니다

## 예시 구성

이 [저장소](https://github.com/anthropics/claude-code/tree/main/examples/settings)에는 일반적인 배포 시나리오에 대한 시작 설정 구성이 포함되어 있습니다. 이를 시작점으로 사용하고 필요에 맞게 조정합니다.

## 참고 항목

* [모든 설정](https://code.claude.com/docs/ko/settings-reference.md#permission-settings): 권한 키를 포함한 모든 설정 키
* [자동 모드 구성](https://code.claude.com/docs/ko/auto-mode-config.md): 자동 모드 분류기에 조직이 신뢰하는 인프라를 알려줍니다
* [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md): Bash 명령에 대한 OS 수준 파일 시스템 및 네트워크 격리
* [인증](https://code.claude.com/docs/ko/authentication.md): Claude Code에 대한 사용자 액세스 설정
* [보안](https://code.claude.com/docs/ko/security.md): 보안 보호 및 모범 사례
* [훅](https://code.claude.com/docs/ko/hooks-guide.md): 워크플로우 자동화 및 권한 평가 확장
