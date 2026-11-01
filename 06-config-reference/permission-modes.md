> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 권한 모드 선택

> Claude가 작업하기 전에 묻는지 여부를 제어합니다. CLI에서 Shift+Tab, VS Code의 모드 표시기 또는 Desktop의 모드 선택기로 권한 모드를 전환합니다.

권한 모드는 Claude가 먼저 묻지 않고 세션에서 수행할 수 있는 작업을 설정합니다. Manual 모드에서는 Claude Code가 파일을 편집하거나 셸 명령을 실행하거나 네트워크에 접근하는 대부분의 작업 전에 멈추고 사용자에게 묻습니다. [auto 모드](#eliminate-prompts-with-auto-mode)에서는 두 번째 모델인 분류기가 사용자 대신 작업을 검토합니다. [분류기가 작업을 평가하는 방식](#how-the-classifier-evaluates-actions)에서는 분류기가 검토하는 작업과 건너뛰는 작업을 나열합니다.

Claude Code v2.1.283 이상에서는 자동 모드가 대화형 터미널 및 VS Code 세션의 기본 제공 시작 권한 모드입니다. 이전 버전에서는 Pro, Max, Ultra, Team 플랜에서만 기본 제공되는 시작 권한 모드입니다. [세션이 시작되는 모드](#which-mode-a-session-starts-in)에서는 시작 권한 모드를 변경하는 사용 환경과 설정을 다룹니다. 실행 중인 세션의 권한 모드는 언제든지 변경할 수 있습니다.

## 사용 가능한 모드

각 모드는 편의성과 감시 사이에서 서로 다른 트레이드오프를 만듭니다. 아래 표는 각 모드에서 Claude가 권한 프롬프트 없이 수행할 수 있는 작업을 보여줍니다. 수동 모드는 구성 값인 `default` 아래에 나타납니다.

| 모드 | 요청 없이 실행되는 작업 | 최적 사용 사례 |
| :- | :- | :- |
| `default` | 읽기만 | 모든 작업을 직접 검토, 민감한 작업 |
| [`acceptEdits`](#auto-approve-file-edits-with-acceptedits-mode) | 읽기, 파일 편집, 일반적인 파일시스템 명령어 (`mkdir`, `touch`, `mv`, `cp` 등) | 검토 중인 코드 반복 작업 |
| [`plan`](#analyze-before-you-edit-with-plan-mode) | 읽기, 그리고 [자동 모드](#eliminate-prompts-with-auto-mode)를 사용할 수 있을 때 분류기 승인 명령어 | 변경 전 코드베이스 탐색 |
| [`auto`](#eliminate-prompts-with-auto-mode) | 백그라운드 안전 검사를 포함한 모든 작업 | 장시간 작업, 프롬프트 피로 감소 |
| [`dontAsk`](#allow-only-pre-approved-tools-with-dontask-mode) | 작업 디렉터리 내부의 파일 읽기 및 사전 승인된 도구; 프롬프트를 표시할 모든 작업은 거부됨. 단, 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 이러한 호출 중 일부를 여전히 승인할 수 있음 | 잠금된 CI 및 스크립트 |
| [`bypassPermissions`](#skip-all-checks-with-bypasspermissions-mode) | 모든 작업 | 격리된 컨테이너 및 VM만 해당 |

모든 작업을 검토하는 모드는 CLI에서 **Manual**이라고 명명되며, `claude --help`에서, VS Code 및 JetBrains 확장 프로그램에서, 그리고 데스크톱 앱에서도 **Manual**이라고 명명됩니다. 구성 값은 `default`이며, 이는 훅 및 SDK 통합이 사용하는 값입니다. CLI는 값을 입력하는 모든 곳에서 `manual`을 별칭으로 허용합니다. 예를 들어 `claude --permission-mode manual` 또는 `"defaultMode": "manual"`입니다.

[보호된 경로](#protected-paths)에 대한 쓰기는 `bypassPermissions` 모드에서와 bypass 권한을 사용할 수 있는 plan-mode 세션에서를 제외하고는 자동 승인되지 않습니다. 이는 [모드 사이클에 `bypassPermissions`를 배치하는 방식으로 시작된](#switch-permission-modes) 대화형 터미널 세션을 의미합니다.

모드는 기준선을 설정합니다. 특정 도구를 사전 승인하거나 차단하기 위해 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)을 위에 계층화합니다. 거부 규칙은 `bypassPermissions`를 포함한 모든 모드에서 차단합니다. 거부 및 요청 규칙은 Claude가 호출할 수 있는 다른 도구가 최소 하나 이상 있는 한 [`EndConversation`](https://code.claude.com/docs/ko/tools-reference#endconversation-tool-behavior)에 적용되지 않습니다. 허용 규칙은 `bypassPermissions`에서 효과가 없습니다.

### 어떤 모드도 자동 승인하지 않는 작업

Claude Code는 `bypassPermissions`를 포함한 어떤 모드에서도 다음을 자동 승인하지 않습니다. 단, `bypassPermissions` 모드에서는 [위험한 `rm` 명령에 대한 프롬프트를 끌 수 있습니다](#turn-off-the-critical-path-removal-prompt-in-bypasspermissions-mode). 각 항목은 각 모드에서 대신 어떤 일이 발생하는지를 설명하는 섹션으로 연결됩니다:

* 명시적 [요청 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)과 일치하는 도구
* 조직이 [`ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구, 해당 설정이 Claude Code에 도달하는 세션에서
* 사용자 상호작용이 필요한 도구: 기본 제공 `AskUserQuestion` 도구 및 [`requiresUserInteraction`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)으로 표시된 MCP 도구
* 어떤 허용 규칙이나 `PreToolUse` 훅 `"allow"`도 승인하지 않는 인식된 `rm` 및 `rmdir` [중요 경로 제거](#critical-paths), 그리고 [`Dangerous rm operation not ruled out`](#dangerous-rm-operation-not-ruled-out)으로 플래그가 지정된 Bash 명령
* [세션 간 메시징 보안 조치](#skip-all-checks-with-bypasspermissions-mode)
* [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)가 켜져 있는 동안 작업 디렉토리 외부의 읽기: 인식된 파일 읽기 Bash 명령어는 자동 모드 및 `bypassPermissions` 모드에서도 프롬프트하며, 샌드박스 외부에서 실행하기 위해 승인이 필요한 모든 [샌드박스 해제 재시도](https://code.claude.com/docs/ko/sandboxing.md#the-unsandboxed-retry-escape-hatch)도 마찬가지입니다. Claude Code v2.1.257 이상이 필요합니다.

  셸 파서가 추적할 수 없는 명령어(예: 두 번 이상 디렉토리를 변경하거나 서브셸을 실행하는 명령어)는 외부 경로를 명명하지 않더라도 동일한 방식으로 프롬프트합니다. 이 프롬프트는 명령어가 [샌드박스](https://code.claude.com/docs/ko/sandboxing.md)에서 실행되고 샌드박스가 블록을 적용할 때는 적용되지 않습니다.

## 일반적인 설정

권한 모드는 Claude가 작업 전에 물어보는지 여부를 결정하고, [Bash sandbox](https://code.claude.com/docs/ko/sandboxing.md) 및 외부 [isolation boundaries](https://code.claude.com/docs/ko/sandbox-environments.md)는 작업이 실행되면 도달할 수 있는 것을 결정합니다. 아래의 각 행은 목표를 시작점으로 그곳에 도달하는 플래그 또는 설정 및 필요한 격리와 쌍을 이룹니다. [사용 가능한 모드](#available-modes)는 각 모드에서 프롬프트 없이 실행되는 것을 나열합니다.

| 원하는 것 | 시작 | 필요한 격리 | 참고 |
| :- | :- | :- | :- |
| 모든 작업을 직접 검토 | Manual 모드: `claude --permission-mode default` | 없음 | 민감한 작업, 낯선 코드 |
| 분류기 없이 더 적은 프롬프트로 로컬에서 반복 | Manual 모드 + [auto-allow mode](https://code.claude.com/docs/ko/sandboxing.md#sandbox-modes)의 Bash sandbox: `claude --permission-mode default`, 그 다음 `/sandbox` 실행 및 auto-allow 선택 | 기본 제공 Bash sandbox, macOS, Linux, WSL2 | Deny 규칙은 여전히 적용되고, `Bash(git push *)`와 같이 명령을 지정하는 ask 규칙은 여전히 프롬프트합니다. 확인을 요청할 수 있는 그 밖의 명령은 [Auto-allow mode](https://code.claude.com/docs/ko/sandboxing.md#auto-allow-mode)에서 다룹니다. 설정 파일에서 대신 sandbox를 켜려면 [`sandbox.enabled`](https://code.claude.com/docs/ko/settings-reference#sandbox-enabled)를 `true`로 설정합니다. |
| 변경 전에 탐색 | `claude --permission-mode plan` | 없음 | Claude Code는 [계획을 승인](#review-and-approve-a-plan)할 때까지 편집을 차단합니다. |
| auto mode에서 자동 실행 | `claude --permission-mode auto`, [기본 제공 시작 권한 모드](#which-mode-a-session-starts-in) v2.1.283 이상 | 없음; sandbox 또는 컨테이너는 심층 방어를 추가합니다. | [지원되는 모델](#eliminate-prompts-with-auto-mode)이 필요하고, 조직이 [auto mode를 끌 수 있습니다](#eliminate-prompts-with-auto-mode). |
| 정확한 allowlist로 CI에서 실행 | `claude -p "run the test suite" --permission-mode dontAsk --allowedTools "Bash(npm test)" "Read"` | CI 러너가 제공하는 것 이상 없음 | [Cloud sessions](https://code.claude.com/docs/ko/claude-code-on-the-web.md)는 설정 파일의 `dontAsk`를 무시합니다. |
| 컨테이너 내에서 완전히 자동 실행 | `claude -p "<prompt>" --dangerously-skip-permissions` | 필수: 컨테이너, VM, 또는 [sandbox runtime](https://code.claude.com/docs/ko/sandbox-environments.md#sandbox-runtime); Linux 및 macOS에서 [non-root user](#skip-all-checks-with-bypasspermissions-mode)로 실행 | Cloud sessions는 설정 파일의 이 모드를 무시합니다. 이 `-p` 실행에서 [여전히 프롬프트할 몇 가지 호출](#skip-all-checks-with-bypasspermissions-mode)은 대신 거부됩니다. |

Bash sandbox와 auto mode는 독립적으로 작동하고 결합합니다. [Sandbox modes](https://code.claude.com/docs/ko/sandboxing.md#sandbox-modes)에 나열된 예외가 있습니다. 전체 상호작용은 [How sandboxing relates to permissions and permission modes](https://code.claude.com/docs/ko/sandboxing.md#how-sandboxing-relates-to-permissions-and-permission-modes) 및 [How isolation relates to permission modes](https://code.claude.com/docs/ko/sandbox-environments.md#how-isolation-relates-to-permission-modes)를 참조하세요.

## 세션이 시작되는 모드

터미널에서 새 세션을 시작할 때 Claude Code는 다음 중 적용되는 첫 번째 항목에서 권한 모드를 가져옵니다.

1. `--permission-mode` 플래그 또는 `--dangerously-skip-permissions`

2. [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)의 `permissions.defaultMode`

   `.claude/settings.json` 또는 `.claude/settings.local.json`에서 `"auto"`를 설정하면 해당 값이 적용되지 않으며, Claude Code는 `~/.claude/settings.json`의 `defaultMode` 대신 기본 제공 기본값을 사용합니다. 이 두 파일에서 `"bypassPermissions"`를 설정하면 역시 적용되지 않으며, 세션은 수동 모드에서 시작됩니다. 다른 값들은 모든 설정 파일에서 적용됩니다.

3. 기본 제공 기본값

VS Code 확장 프로그램이 시작하는 대화는 [권한 모드 전환](#switch-permission-modes)의 확장 프로그램 자체 목록을 따릅니다. Claude Code가 재개된 세션을 시작하는 권한 모드에 대해서는 [재개 시 권한 모드](https://code.claude.com/docs/ko/sessions.md#permission-mode-on-resume)를 참조하세요.

기본 제공 `auto` 기본값은 macOS, Linux 및 WSL에서 Claude Code v2.1.228 이상이 필요하며, 기본 Windows에서는 v2.1.233 이상이 필요합니다. 이전 버전에서는 기본 제공 기본값이 수동입니다.

기본 제공 기본값은 Claude Code를 실행하는 방식에 따라 달라집니다. 세션과 일치하는 첫 번째 행이 적용됩니다. 이 표는 터미널이나 VS Code 확장 프로그램을 통해 시작하는 세션을 다룹니다. 데스크톱 앱 및 claude.ai의 경우 [권한 모드 전환](#switch-permission-modes)의 데스크톱 및 웹 탭을 참조하세요.

| Claude Code를 실행하는 방식 | 기본 제공 시작 권한 모드 |
| :- | :- |
| 모든 설정 파일이 `disableAutoMode`를 `"disable"`로 설정 | `default` |
| `claude -p` 또는 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/permissions.md#permission-modes) | `default` |
| 조직에 [HIPAA 구성](#hipaa-configuration)이 적용되어 있고 세션이 [적용 대상](https://code.claude.com/docs/ko/hipaa-setup.md#check-how-developers-sign-in-and-connect)인 경우 | Claude Code v2.1.285 이상에서 `default`. 자동 모드로 전환하는 것은 계속 가능합니다 |
| 터미널 또는 [VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md)을 통해 | Claude Code v2.1.283 이상에서 `auto`; 이전 버전에서는 [기능 플래그를 가져오는](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) 세션에서 Pro, Max, Ultra 또는 Team 플랜의 `auto`, 그 외에는 `default` |

플래그, 설정 파일 또는 기본 제공 기본값이 `auto`를 선택하지만 자동 모드를 세션에서 사용할 수 없는 경우, Claude Code는 대신 수동 모드에서 세션을 시작합니다. 자동 모드는 세션이 [가용성 요구 사항](#eliminate-prompts-with-auto-mode)을 충족하지 않을 때(예: 설정 파일이 자동 모드를 비활성화하거나 지원하지 않는 모델) 또는 Anthropic이 서버 측에서 임시로 자동 모드를 비활성화했을 때 사용할 수 없습니다.

기본 제공 기본값이 처음으로 세션 중 하나를 자동 모드에서 시작할 때, Claude Code는 이 페이지로 연결되는 알림을 표시합니다.

* 터미널에서 세션 맨 위에 한 번
* VS Code 확장 프로그램에서 새 대화 화면의 카드로 표시되며, 이를 닫을 때까지 유지됩니다.

`~/.claude/settings.json`이 `auto` 이외의 `defaultMode`를 설정하고 다른 설정 파일이 설정하지 않으면, 세션은 계속해서 해당 모드에서 시작됩니다.

Pro, Max, Ultra 및 Team 플랜에서, 그리고 [기능 플래그를 가져오지 않는](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) 세션에서 Claude Code는 설정을 자동 모드로 변경할지 여부를 한 번 묻습니다. 이 질문은 터미널 또는 VS Code 확장 프로그램에 표시되며, 거절하면 설정은 그대로 유지됩니다.

### `claude -p` 및 Agent SDK 실행에서 거부되는 도구 호출

Claude Code v2.1.302 이상에서는 [권한 모드가 설정되지 않은](#which-mode-a-session-starts-in) `claude -p` 및 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/permissions.md#permission-modes) 실행이 수동 모드에서 시작됩니다. 이 모드는 SDK 옵션과 설정에서 `default`로 표시됩니다. 승인이 필요한 호출은 허용 규칙, 훅, `canUseTool` 콜백 또는 `--permission-prompt-tool`로 승인하지 않는 한 거부됩니다.

이러한 호출이 승인되도록 하려면 허용 규칙을 추가하거나 자동 모드에서 시작합니다.

* **[허용 규칙 추가](https://code.claude.com/docs/ko/permissions.md#manage-permissions)**: Claude는 나열된 호출을 실행합니다. `claude -p`에 [`--allowedTools "Bash(npm test)"`](https://code.claude.com/docs/ko/headless#auto-approve-tools)를 전달하거나 SDK의 [허용 도구 옵션](https://code.claude.com/docs/ko/agent-sdk/permissions.md#allow-and-deny-rules)을 설정합니다.
* **[자동 모드](#eliminate-prompts-with-auto-mode)에서 시작**: 분류기 모델이 호출을 검토하므로 미리 나열할 필요가 없습니다. `claude -p`에 `--permission-mode auto`를 전달하거나 SDK의 [권한 모드 옵션](https://code.claude.com/docs/ko/agent-sdk/permissions.md#set-permission-mode)을 설정합니다.

다음 예제는 CLI와 각 SDK에서 자동 모드를 사용하는 형태를 보여 줍니다.

> [tab] CLI
>
> ```bash theme={null}
> claude -p "Run the test suite and fix any failures" --permission-mode auto
> ```

> [tab] TypeScript
>
> ```typescript theme={null}
> const options = {
>   permissionMode: "auto"
> };
> ```

> [tab] Python
>
> ```python theme={null}
> from claude_agent_sdk import ClaudeAgentOptions
>
> options = ClaudeAgentOptions(permission_mode="auto")
> ```

v2.1.302 이전에는 이러한 실행이 [기능 플래그를 가져오지](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) 않는 경우(예: [타사 공급자](https://code.claude.com/docs/ko/third-party-integrations.md) 사용 시 또는 `DISABLE_TELEMETRY` 설정 시) 자동 모드에서 시작될 수 있었습니다.

### 다른 권한 모드에서 시작

한 세션에 대해 또는 머신, 프로젝트 또는 조직의 모든 세션에 대한 기본값으로 시작 권한 모드를 설정할 수 있습니다. 둘 이상의 설정 파일이 `permissions.defaultMode`를 설정할 때 [설정 우선순위](https://code.claude.com/docs/ko/settings.md#settings-precedence)가 결정하므로, 프로젝트 또는 관리형 값이 `~/.claude/settings.json`을 능가합니다. 이미 실행 중인 세션의 권한 모드를 변경하려면 [권한 모드 전환](#switch-permission-modes)을 참조하세요.

| 시작 권한 모드를 설정하는 대상 | 수행할 작업 |
| :- | :- |
| 시작하려는 한 세션 | 권한 모드를 플래그로 전달합니다. 예: `claude --permission-mode default` |
| 이 머신에서 시작하는 모든 터미널 세션 | `~/.claude/settings.json`에서 `permissions.defaultMode`를 설정합니다. VS Code 확장 프로그램이 읽는 내용은 [권한 모드 전환](#switch-permission-modes)을 참조하세요. |
| 한 프로젝트에서 시작하는 모든 터미널 세션 | 프로젝트의 `.claude/settings.json`에서 `permissions.defaultMode`를 설정합니다. 터미널에서 시작하는 세션은 `auto` 및 `bypassPermissions`을 제외한 모든 값을 준수합니다. VS Code 확장 프로그램이 시작하는 세션은 시작 권한 모드에 대한 프로젝트 설정을 읽지 않습니다. |
| 조직의 모든 터미널 세션 | [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `permissions.defaultMode`를 설정합니다. 터미널 세션은 해당 모드에서 시작되며 사용자는 여전히 자동 모드로 전환할 수 있습니다. VS Code 확장 프로그램이 읽는 내용은 [권한 모드 전환](#switch-permission-modes)을 참조하세요. 자동 모드를 제거하여 아무도 선택할 수 없도록 하려면 대신 `permissions.disableAutoMode`를 `"disable"`로 설정합니다. |

이 예제는 머신의 모든 터미널 세션이 수동 모드(구성 값은 `default`)에서 시작되도록 합니다. `~/.claude/settings.json`에 저장합니다.

```json theme={null}
{
  "permissions": {
    "defaultMode": "default"
  }
}
```

다음 세션을 시작하면 상태 표시줄에 `⏸ manual mode on`이 표시됩니다.

### HIPAA 구성에서의 권한 모드

[HIPAA 구성](https://code.claude.com/docs/ko/hipaa-setup.md)이 적용된 조직에서는 기본 제공 `auto` 기본값이 적용되지 않습니다. 시작 권한 모드를 선택하는 다른 항목이 없으면 터미널 또는 VS Code 세션은 수동 모드에서 시작됩니다. 터미널 세션에는 `Auto mode isn't the default for your organization · Shift+Tab to switch`도 표시되며, VS Code 확장 프로그램에는 알림이 표시되지 않습니다. 이 내용이 적용되는 세션은 [개발자의 로그인 및 연결 방식 확인](https://code.claude.com/docs/ko/hipaa-setup.md#check-how-developers-sign-in-and-connect)에 나와 있습니다.

자동 모드와 `bypassPermissions`는 계속 사용할 수 있습니다.

* **자동 모드로 전환**: `Shift+Tab`을 누르거나 [사용 중인 인터페이스의 컨트롤](#switch-permission-modes)을 사용합니다
* **자동 모드에서 시작**: `--permission-mode auto`를 전달하거나, 사용자 설정에서 또는 조직 전체의 경우 관리형 설정에서 `permissions.defaultMode`를 `auto`로 설정합니다. [다른 권한 모드에서 시작](#start-in-a-different-mode)을 참조하세요
* **자동 모드 제거**: 관리형 설정에서 [`permissions.disableAutoMode`](https://code.claude.com/docs/ko/settings-reference#disableautomode)를 `"disable"`로 설정합니다
* **`bypassPermissions` 차단**: 관리형 설정에서 [`permissions.disableBypassPermissionsMode`](https://code.claude.com/docs/ko/settings-reference#permissions-disablebypasspermissionsmode)를 `"disable"`로 설정합니다

[HIPAA 구성의 최소 버전](https://code.claude.com/docs/ko/hipaa-setup.md#update-claude-code-and-claude-desktop)인 Claude Code v2.1.285 이상이 필요합니다.

## 권한 모드 전환

각 인터페이스는 세션 중에 권한 모드를 전환하기 위한 자체 컨트롤과 새 세션이 시작되는 권한 모드를 선택하는 자체 방법을 가집니다. 인터페이스를 선택하여 컨트롤을 확인하세요.

> [tab] CLI
>
> **세션 중**: `Shift+Tab`을 눌러 권한 모드를 순환합니다. `auto`에서 처음 누르면 `default`로 전환되고, 이후 순환은 `default` → `acceptEdits` → `plan` 순으로 진행됩니다. 선택적 모드는 `plan` 뒤에 들어갑니다. 상태 표시줄은 활성 모드를 `default`의 경우 회색 `⏸ manual mode on`으로, 또는 `⏵⏵ accept edits on`, `⏸ plan mode on`, `⏵⏵ auto mode on`, `⏵⏵ don't ask on`, 또는 `⏵⏵ bypass permissions on`으로 표시합니다.
>
> 자동 모드에서 시작한 세션을 담은 이 클립에서 상태 표시줄을 확인하세요. `Shift+Tab`을 누를 때마다 상태 표시줄이 `auto mode on`에서 `manual mode on`, `accept edits on`, `plan mode on`으로 바뀌었다가 다시 `auto mode on`으로 돌아옵니다.
>
> <video autoPlay muted loop playsInline src="https://mintcdn.com/claude-code/tA-x-5L2YsYSVdee/images/permission-modes-cycle-light.mp4?fit=max&auto=format&n=tA-x-5L2YsYSVdee&q=85&s=3927dd62d59b01efd81b3578f2a6f971" aria-label="Claude Code 프롬프트 아래의 상태 표시줄이 Shift+Tab을 누를 때마다 auto mode on, manual mode on, accept edits on, plan mode on으로 바뀐 다음 다시 auto mode on으로 돌아옵니다." />
>
> 모든 모드가 기본 순환에 포함되는 것은 아닙니다:
>
> * `auto`: [auto mode를 사용할 수 있을 때](#eliminate-prompts-with-auto-mode) 나타나며, 이로 순환하면 확인 프롬프트 없이 권한 모드가 전환됩니다.
> * `bypassPermissions`: `--permission-mode bypassPermissions`, `--dangerously-skip-permissions`, `--allow-dangerously-skip-permissions`, 또는 [user, `--settings`, 또는 managed settings](https://code.claude.com/docs/ko/settings-reference#permissions-defaultmode)의 `permissions.defaultMode: "bypassPermissions"` 후에 나타납니다. `--allow-` 변형은 활성화하지 않고 순환에 권한 모드를 추가합니다.
> * `dontAsk`: 순환에 나타나지 않으며, `--permission-mode dontAsk`로 설정합니다.
>
> 활성화된 선택적 모드는 `plan` 후에 슬롯되며, `bypassPermissions`가 먼저이고 `auto`가 마지막입니다. 둘 다 활성화된 경우 `auto`로 가는 길에 `bypassPermissions`를 순환합니다.
>
> **Bash 권한 프롬프트에서**: Manual 및 `acceptEdits` 권한 모드에서 [auto mode](#eliminate-prompts-with-auto-mode)를 사용할 수 있을 때 Claude Code는 Bash 명령의 권한 프롬프트에 **Yes, and switch to auto mode**를 추가합니다. 이를 선택하여 명령을 승인하고 세션을 auto mode로 전환합니다. [PowerShell tool](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool) 프롬프트는 옵션을 제공하지 않습니다. Claude Code v2.1.247 이상이 필요합니다.
>
> Claude Code는 [`ask` 규칙](https://code.claude.com/docs/ko/permissions#manage-permissions) 중 하나 또는 [hook](https://code.claude.com/docs/ko/hooks.md#pretooluse-decision-control)에 의해 강제된 프롬프트에 옵션을 추가하지 않습니다. auto mode는 여전히 이러한 프롬프트를 표시하므로 전환해도 제거되지 않습니다.
>
> **시작 시**: 권한 모드를 플래그로 전달합니다.
>
> ```bash theme={null}
> claude --permission-mode plan
> ```
>
> **기본값으로**: [다른 권한 모드에서 시작](#start-in-a-different-mode)에 설명된 대로 원하는 범위에서 `permissions.defaultMode`를 설정합니다.
>
> 동일한 `--permission-mode` 플래그는 [비대화형 실행](https://code.claude.com/docs/ko/headless.md)을 위해 `-p`와 함께 작동합니다.

> [tab] VS Code
>
> **세션 중**: 프롬프트 상자 하단의 모드 표시기를 클릭합니다. 이 페이지의 모드에 대해 다음 레이블을 사용합니다:
>
> | UI 레이블 | 모드 |
> | :- | :- |
> | Manual | `default` |
> | Edit automatically | `acceptEdits` |
> | Plan | `plan` |
> | Auto | `auto` |
> | Bypass permissions | `bypassPermissions` |
>
> **기본값으로**: 대화가 시작되는 권한 모드를 고정하려면 VS Code 사용자 설정에서 `claudeCode.initialPermissionMode`를 `default`, `manual`, `acceptEdits`, `plan`, 또는 `bypassPermissions`로 설정합니다. 설정은 `auto`를 허용하지 않습니다. Auto에서 시작하려면 설정하지 않은 상태로 두고 아래 항목 2에 설명된 대로 모드 표시기에서 **Auto**를 한 번 선택합니다. 확장은 다음 중 첫 번째로 적용되는 것에서 각 새 대화를 시작합니다:
>
> 1. `claudeCode.initialPermissionMode`
> 2. 마지막으로 모드 표시기에서 선택한 모드(Manual, Edit automatically, 또는 Auto인 경우). Plan 또는 Bypass permissions를 선택하면 해당 대화에만 적용됩니다.
> 3. [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md) 또는 `~/.claude/settings.json`의 `permissions.defaultMode`
> 4. 플랜, 제공자, 조직 설정에 대한 [기본 제공 기본값](#which-mode-a-session-starts-in)
>
> 확장은 시작 권한 모드에 대해 프로젝트의 `.claude/settings.json` 또는 `.claude/settings.local.json`을 읽지 않습니다. `claudeCode.claudeProcessWrapper`가 설정되면 항목 3과 4도 적용되지 않습니다: 항목 1 또는 항목 2가 권한 모드를 설정하지 않으면 이러한 대화는 Manual에서 시작됩니다.
>
> v2.1.283 이전에는 항목 3이 [기능 플래그를 가져오는](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) Pro, Max, Ultra, Team 플랜에서만 적용되었습니다.
>
> Auto는 [auto mode를 사용할 수 있을 때](#eliminate-prompts-with-auto-mode) 모드 표시기에 나타납니다.
>
> Bypass permissions는 확장 설정의 **Allow dangerously skip permissions** 토글이 필요합니다. 없으면 권한 모드가 표시기에 나타나지 않으며, 항목 1 또는 항목 3의 `bypassPermissions` 값은 대신 대화를 Manual에서 시작합니다. 항목의 Auto는 auto mode를 사용할 수 없을 때 마찬가지로 대화를 Manual에서 시작합니다.
>
> [VS Code 가이드](https://code.claude.com/docs/ko/vs-code.md)에서 확장 관련 세부사항을 참조하세요.

> [tab] JetBrains
>
> JetBrains 플러그인은 IDE 터미널에서 Claude Code를 실행하므로 권한 모드 전환은 CLI와 동일하게 작동합니다: `Shift+Tab`을 눌러 순환하거나 시작할 때 `--permission-mode`를 전달합니다.

> [tab] Desktop
>
> **세션 중**: Code 탭에서 프롬프트 상자 아래 행에 있는 모드 선택기를 사용합니다. 모든 모드가 선택기에 나타나는 것은 아닙니다:
>
> * **Auto**: [auto mode를 사용할 수 있을 때](#eliminate-prompts-with-auto-mode) 나타납니다.
> * **Bypass permissions**: Pro, Max, Ultra 플랜에서 Desktop 설정의 **Allow bypass permissions mode** 토글이 필요합니다. Team 및 Enterprise 플랜에서는 조직 정책이 대신 제어합니다.
>
> Cowork는 이러한 모드를 사용하지 않습니다. Cowork는 별도로 활성화되는 자체 권한 모드를 가지며, 계정에 대해 기본값 이외의 모드가 활성화될 때까지 모드 선택기를 전혀 표시하지 않습니다. [Cowork 문서](https://claude.com/docs/cowork/overview)를 참조하세요.
>
> 데스크톱 관련 세부사항은 Desktop 가이드의 [권한 모드 선택](https://code.claude.com/docs/ko/desktop.md#choose-a-permission-mode)을 참조하세요.
>
> **기본값으로**: [설정](https://code.claude.com/docs/ko/settings.md#where-settings-live)에서 `defaultMode`를 설정합니다. 데스크톱 앱은 CLI와 동일한 설정 파일을 읽고 새 로컬 세션에 권한 모드를 적용합니다.
>
> 모드 선택기에서 선택한 모드는 폴더별로 기억되며 해당 폴더에 대해 `defaultMode`보다 우선합니다. Plan은 예외입니다: 선택하면 현재 세션에만 적용됩니다.
>
> [다른 권한 모드에서 시작](#start-in-a-different-mode) 아래의 예제에서 `defaultMode`가 설정 파일의 어디로 가는지 참조하세요.

> [tab] Web and mobile
>
> [claude.ai/code](https://claude.ai/code)에서는 프롬프트 상자 아래 행에 있는 모드 드롭다운을 사용합니다. 모바일 앱에서는 프롬프트 상자의 **+** 버튼을 탭한 다음 **Permission**을 탭합니다. 클라우드 세션과 Remote Control 세션은 서로 다른 권한 모드를 제공합니다:
>
> * **[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)**: Accept edits, Plan, Auto. Accept edits는 `default` 모드에 해당합니다: 클라우드 세션은 모드에 관계없이 파일 편집을 사전 승인하므로 드롭다운은 Manual 대신 Accept edits를 표시합니다. 클라우드 세션은 여전히 설정의 `defaultMode: "acceptEdits"`를 준수합니다. 자동 모드는 조직이 허용하고 선택한 모델이 지원할 때만 나타납니다. Bypass permissions는 사용할 수 없습니다.
> * **로컬 머신의 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션**: 직접 시작한 세션의 경우 Manual, Accept edits, Plan, Auto이며, 앱에서 Bypass permissions를 선택할 수 없습니다. Auto를 사용하려면 세션이 자동 모드 [사용 가능 요건](#eliminate-prompts-with-auto-mode)을 충족해야 합니다. 컴퓨터에서 실행 중인 프로젝트 스레드의 경우 [자신의 컴퓨터에서 스레드 실행](https://code.claude.com/docs/ko/claude-projects.md#run-a-thread-on-your-own-computer)을 참조하세요.
>   * Bypass permissions를 제외하고, 드롭다운은 터미널에서 설정된 모드를 포함하여 로컬 세션이 있는 권한 모드를 표시합니다. 앱 또는 터미널에서 권한 모드가 변경될 때 업데이트됩니다.
>   * [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md) 또는 [VS Code 확장](https://code.claude.com/docs/ko/vs-code.md)이 호스팅하는 세션은 터미널에서 호스팅하는 세션과 동일하게 권한 모드 변경이 발생할 때 claude.ai에 보고합니다.
>
> Remote Control의 경우 로컬 머신이 claude.ai 계정으로 로그인되어야 합니다. API 키는 지원되지 않습니다. 해당 로컬 세션을 시작할 때 시작 권한 모드를 설정할 수도 있습니다:
>
> ```bash theme={null}
> claude remote-control --permission-mode acceptEdits
> ```

## acceptEdits 모드로 파일 편집 자동 승인

`acceptEdits` 모드를 사용하면 Claude가 프롬프트 없이 작업 디렉토리에서 파일을 생성하고 편집할 수 있습니다. 이 모드가 활성화되어 있는 동안 상태 표시줄에 `⏵⏵ accept edits on`이 표시됩니다.

파일 편집 외에도 `acceptEdits` 모드는 일반적인 파일시스템 Bash 명령을 자동으로 승인합니다: `mkdir`, `touch`, `rm`, `rmdir`, `mv`, `cp`, `sed`. `touch`를 제외한 이러한 명령은 `LANG=C` 또는 `NO_COLOR=1`과 같은 안전한 환경 변수가 접두사로 붙거나 `timeout`, `nice`, `nohup`과 같은 프로세스 래퍼가 붙을 때도 자동으로 승인됩니다. 파일 편집과 마찬가지로 자동 승인은 작업 디렉터리 또는 `additionalDirectories` 내의 경로에만 적용됩니다.

다음 항목은 여전히 확인을 요청합니다:

* 해당 범위 밖의 경로
* [보호된 경로](#protected-paths)에 대한 쓰기
* 인식된 `rm` 및 `rmdir` [중요 경로 제거](#critical-paths)
* 일반 파일 경로 이외의 항목이 포함된 `touch`(예: 옵션, glob, 또는 `timeout 5`나 `LANG=C`와 같은 접두사)
* [기본 제공 읽기 전용 집합](https://code.claude.com/docs/ko/permissions.md#read-only-commands)을 제외한 다른 모든 Bash 명령

각 경로는 [심볼릭 링크 확인](https://code.claude.com/docs/ko/permissions.md#symlinks)도 거치므로, 해당 범위 밖으로 확인되는 쓰기 역시 자동으로 승인되지 않습니다.

[PowerShell tool](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool)이 활성화되어 있으면 `acceptEdits` 모드는 범위 내 경로에서 `Set-Content`, `Add-Content`, `Clear-Content`, `Remove-Item`과 이들의 일반적인 별칭도 자동으로 승인합니다. 동일한 범위 및 보호된 경로 규칙이 적용되고, `Remove-Item`은 [자체 확인](#remove-item-in-powershell)을 받습니다. `Set-Content .\notes.txt "It's done"`의 아포스트로피와 같이 따옴표 문자를 포함하는 위치 인수는 Claude Code가 따옴표 및 따옴표 없는 읽기가 다른 인수를 정적으로 검증할 수 없기 때문에 범위 내 경로에서도 여전히 프롬프트를 표시합니다. 프롬프트를 피하려면 `-Value`와 같은 명명된 매개변수를 통해 콘텐츠를 전달합니다.

편집을 인라인으로 승인하는 대신 편집기에서 또는 `git diff`를 통해 변경 사항을 검토하려는 경우 `acceptEdits`를 사용하세요.

Manual 모드에서 `Shift+Tab`을 한 번 누르면 이 모드로 진입하거나 직접 시작할 수 있습니다:

```bash theme={null}
claude --permission-mode acceptEdits
```

## 플랜 모드로 편집 전에 분석하기

플랜 모드는 Claude가 변경 사항을 직접 적용하지 않고 조사하여 제안하도록 합니다. Claude는 파일을 읽고, 탐색을 위해 셸 명령을 실행하고, 플랜을 작성하지만 소스는 편집하지 않습니다. [bypass permissions를 사용할 수 있는](#skip-all-checks-with-bypasspermissions-mode) 대화형 터미널 세션을 제외하면, 플랜을 승인할 때까지 편집은 차단된 상태로 유지됩니다.

플래닝 중 셸 명령이 어떻게 처리되는지는 세션에 따라 다르며, 다음 경우 중 처음으로 일치하는 항목이 적용됩니다.

* **bypass permissions를 사용할 수 있는 대화형 터미널 세션**: 플래닝 명령에는 분류기도 프롬프트도 적용되지 않습니다. 이 경우에도 여전히 확인을 요청하는 몇 가지 항목은 [bypassPermissions 모드로 모든 검사 건너뛰기](#skip-all-checks-with-bypasspermissions-mode)에서 설명합니다.
* **[자동 모드](https://code.claude.com/docs/ko/auto-mode-config.md)를 사용할 수 있고 `useAutoModeDuringPlan` 설정이 켜져 있는 경우**(기본값): 분류기가 [중요 경로 삭제](#critical-paths)를 제외한 셸 명령을 검토하며, 사용자에게 확인을 요청하지 않습니다. 승인된 명령은 실행되고 거부된 명령은 차단됩니다.
* **자동 모드를 사용할 수 없거나 `useAutoModeDuringPlan`이 꺼져 있는 경우**: [기본 제공 읽기 전용 명령 집합](https://code.claude.com/docs/ko/permissions.md#read-only-commands)에 속하지 않는 명령은 승인을 요청합니다. 샌드박스의 [auto-allow 모드](https://code.claude.com/docs/ko/sandboxing.md#sandbox-modes)가 활성화되어 있는 경우에도 마찬가지입니다.

`Shift+Tab`을 누르거나 단일 프롬프트 앞에 `/plan`을 붙여 플랜 모드로 들어갑니다. CLI에서 플랜 모드로 시작할 수도 있습니다.

```bash theme={null}
claude --permission-mode plan
```

플랜을 승인하지 않고 플랜 모드를 종료하려면 `Shift+Tab`을 다시 누릅니다.

### 플랜 검토 및 승인

플랜이 준비되면 Claude가 플랜을 제시하고 진행 방법을 묻습니다. 해당 프롬프트에서 다음 중 하나를 선택할 수 있습니다.

* **Yes, and use auto mode**: 승인하고 [자동 모드](#eliminate-prompts-with-auto-mode)로 시작합니다. 조직에서 자동 모드를 끈 경우처럼 자동 모드를 [세션에서 사용할 수 없는](#eliminate-prompts-with-auto-mode) 경우, 이 옵션은 **Yes, auto-accept edits**로 표시됩니다. bypass permissions를 활성화한 상태로 세션을 시작한 경우에는 대신 **Yes, and switch to BYPASS PERMISSIONS (no further prompts) for this session**으로 표시됩니다.
* **Yes, manually approve edits**: 승인하고 각 편집을 개별적으로 검토합니다.
* **No, keep planning**: 플랜 모드에 머물며 Claude에게 변경할 내용을 알려 줍니다.

플랜을 승인하면 플랜 모드가 종료되고 세션이 각 승인 옵션에 설명된 권한 모드로 전환되므로 Claude가 편집을 시작합니다. 다시 플래닝하려면 `Shift+Tab`으로 플랜 모드로 돌아가거나, 다음 프롬프트 앞에 `/plan`을 붙이면 됩니다.

Claude가 진행하기 전에 제안된 플랜을 기본 텍스트 편집기에서 열어 직접 편집하려면 `Ctrl+G`를 누릅니다. [`showClearContextOnPlanAccept`](https://code.claude.com/docs/ko/settings-reference#showclearcontextonplanaccept)가 활성화되어 있으면, 플랜을 승인하고 플래닝 컨텍스트를 지우는 옵션이 목록의 첫 번째 항목으로 추가됩니다.

플랜을 수락하면 세션 이름을 이미 지정하지 않은 경우 플랜을 기반으로 [생성된 제목](https://code.claude.com/docs/ko/sessions.md#name-your-sessions)도 세션에 부여됩니다.

### 플랜 모드를 기본값으로 설정

프로젝트의 터미널 세션에서 플랜 모드를 기본값으로 사용하려면, [다른 권한 모드로 시작하기](#start-in-a-different-mode)의 예시와 같은 위치에 배치하여 `.claude/settings.json`에서 `defaultMode`를 `plan`으로 설정합니다. [VS Code 확장](https://code.claude.com/docs/ko/vs-code.md)이 시작하는 대화는 시작 권한 모드에 대해 프로젝트 설정을 읽지 않습니다. 이 경우에는 대신 VS Code 사용자 설정에서 `claudeCode.initialPermissionMode`를 `plan`으로 설정합니다.

## 자동 모드로 권한 프롬프트 없애기

자동 모드를 사용하면 Claude가 일상적인 권한 프롬프트 없이 작업을 실행합니다. 별도의 분류기 모델이 작업 실행 전에 이를 검토하여, 사용자의 요청 범위를 넘어서는 작업, 인식되지 않은 인프라를 대상으로 하는 작업, 또는 Claude가 읽은 악의적인 콘텐츠에 의해 유도된 것으로 보이는 작업을 차단합니다. 명시적인 [ask 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)은 여전히 프롬프트를 강제합니다.

Claude Code v2.1.283 이상에서는 모든 플랜과 제공업체에서 대화형 터미널 및 VS Code 세션의 [기본 제공 시작 권한 모드](#which-mode-a-session-starts-in)가 자동 모드입니다. 이전 버전에서는 Pro, Max, Ultra, Team 플랜에서만 기본 제공 시작 권한 모드입니다.

분류기는 Claude가 [`SendMessage`](https://code.claude.com/docs/ko/tools-reference)로 다른 에이전트에 보내는 각 메시지도, 일반 텍스트이든 구조화된 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 메시지이든, Claude Code가 전달하기 전에 검토합니다. 이는 자동 모드와 [분류기가 명령을 검토하는 동안의 플랜 모드](#analyze-before-you-edit-with-plan-mode) 모두에서 적용되며, 전송 검토에는 Claude Code v2.1.222 이상이 필요합니다.

기본적으로 분류기는 `rm -rf /` 또는 `rm -rf ~`와 같이 인식된 `rm` 및 `rmdir` 중요 경로 삭제를 검토하지 않습니다. 각 권한 모드에서 이러한 삭제가 어떻게 처리되는지는 [중요 경로](#critical-paths)에서 다룹니다.

자동 모드는 또한 Claude가 명확히 하기 위한 질문으로 멈추지 않고 작업을 계속하도록 유도하지만, 사용자의 프롬프트나 스킬이 명시적으로 질문에 의존하는 경우에는 여전히 질문합니다. 여전히 확인을 요청하는 모드에서 더 강한 자율적 동작을 원한다면 대신 [Proactive 출력 스타일](https://code.claude.com/docs/ko/output-styles.md)을 설정하십시오.

> [!WARNING]
>
> 자동 모드는 권한 프롬프트를 줄여 주지만 안전을 보장하지는 않습니다. 전반적인 방향을 신뢰할 수 있는 작업에 사용하고, 민감한 작업에 대한 검토를 대체하는 용도로 사용하지 마십시오.

자동 모드는 계정이 다음 요구 사항을 모두 충족하는 경우에만 사용할 수 있습니다.

* **플랜**: 모든 플랜.
* **조직**: Team 및 Enterprise에서는 자동 모드를 기본적으로 사용할 수 있습니다. 관리자는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `permissions.disableAutoMode`를 `"disable"`로 설정하여 조직 전체에서 이 기능을 끌 수 있습니다.
* **모델**: Anthropic API와 [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md)에서는 Claude Opus 4.6 이상, Sonnet 4.6 이상, Haiku 5.5 또는 [Fable 모델](https://code.claude.com/docs/ko/model-config.md#work-with-fable). Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 및 로그인된 [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway) 세션에서는 Claude Sonnet 5 이상, Opus 4.7 이상, Haiku 5.5 및 Fable 모델만 지원됩니다. Sonnet 4.5, Opus 4.5, Haiku 4.5 및 claude-3 모델을 포함한 이전 모델은 어떤 제공업체에서도 지원되지 않습니다.
* **제공업체**: Anthropic API, Claude Platform on AWS, Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 및 로그인된 Claude apps gateway 세션에서 기본적으로 사용할 수 있습니다.

Claude Code에서 자동 모드를 사용할 수 없다고 보고하면, 먼저 이러한 요구 사항과 설정 파일에서 [`disableAutoMode`](https://code.claude.com/docs/ko/settings-reference#disableautomode)를 설정하고 있는지 확인하십시오. Anthropic이 서버 측에서 자동 모드를 꺼 두었거나, 서버가 해당 계정에 대해 자동 모드를 거부했을 수도 있습니다. 이러한 응답 중 하나를 받은 세션은 세션이 끝날 때까지 자동 모드가 꺼진 상태로 유지되므로, 나중에 새 세션을 시작하십시오.

모델 이름을 언급하며 자동 모드가 작업의 "안전성을 판단할 수 없다"고 알리는 별도의 메시지는 분류기 요청이 실패했음을 의미합니다. 이러한 실패는 대개 일시적이지만, Amazon Bedrock에서는 계정이 해당 모델을 호출할 수 있을 때까지 반복될 수 있습니다. 원인과 해결 방법은 [오류 참조](https://code.claude.com/docs/ko/errors.md#auto-mode-cannot-determine-the-safety-of-an-action)를 참조하십시오.

[설정](https://code.claude.com/docs/ko/settings-reference.md#all-settings)에서 `defaultMode: "auto"`를 설정했는데 터미널 세션이 오류 없이 Manual 모드로 시작된다면, 해당 설정이 `.claude/settings.json` 또는 `.claude/settings.local.json`에 있을 가능성이 높습니다. `auto`는 이러한 파일에서는 적용되지 않습니다. `~/.claude/settings.json`으로 옮기십시오. VS Code 확장 프로그램이 시작한 대화의 경우에는 대신 [권한 모드 전환](#switch-permission-modes)에 있는 확장 프로그램 자체 목록을 확인하십시오.

### Bedrock, Agent Platform 또는 Foundry에서의 자동 모드

[Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md), [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md) 및 로그인된 [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway) 세션에서는 자동 모드를 기본적으로 사용할 수 있습니다. 이러한 환경에서 권한 모드를 설정하지 않으면 대화형 세션은 자동 모드로 시작되고, `claude -p` 또는 Agent SDK 실행은 구성 값이 `default`인 Manual 모드로 시작됩니다.

* **대화형 터미널 및 VS Code 세션**: 자동 이외의 권한 모드로 시작하려면 [다른 권한 모드로 시작하기](#start-in-a-different-mode)에 설명된 대로 `permissions.defaultMode`를 설정하거나, VS Code 확장 프로그램의 [모드 표시기](#switch-permission-modes)에서 모드를 선택하십시오. 이러한 세션을 자동 모드로 시작하는 Claude Code 버전은 [세션이 시작되는 모드](#which-mode-a-session-starts-in)에 나와 있습니다.
* **`claude -p` 및 Agent SDK 실행**: 자동 모드로 시작하려면 `claude -p`에 `--permission-mode auto`를 전달하거나, TypeScript에서는 `permissionMode: "auto"`를, Python에서는 `permission_mode="auto"`를 전달하십시오. 권한 모드를 전달하지 않는 경우에는 [`claude -p` 및 Agent SDK 실행에서 거부되는 도구 호출](#which-mode-a-non-interactive-run-starts-in)을 참조하십시오. 이 섹션은 이전 Claude Code 버전도 다룹니다.

이러한 제공업체에서는 Claude Sonnet 5 이상, Opus 4.7 이상, Haiku 5.5 및 Fable 모델만 지원됩니다. 다른 모델에서는 세션이 대신 Manual로 시작됩니다. 이러한 제공업체에서 Haiku 5.5로 자동 모드를 사용하려면 Claude Code v2.1.293 이상이 필요합니다.

개발자가 자동 모드를 사용하지 못하도록 하려면 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `disableAutoMode`를 `"disable"`로 설정하십시오. 이렇게 하면 `Shift+Tab` 순환에서 `auto`가 제거되고, `--permission-mode auto`로 시작한 세션은 대신 Manual로 시작됩니다. 이미 자동 모드로 실행 중인 세션은 이 설정이 [관리자가 배포한 소스](https://code.claude.com/docs/ko/managed-settings.md#which-managed-source-claude-code-uses)에서 해당 세션에 도달하면 자동 모드를 벗어나고 `auto mode disabled by settings`를 표시합니다. v2.1.251 이전에는 실행 중인 세션이 종료될 때까지 자동 모드를 유지했습니다.

### 서버 측 분류기 검토

자동 모드에서 Claude Code는 자체 분류기 요청을 보내는 대신, 세션의 모델 요청의 일부로 [결정 순서](#how-the-classifier-evaluates-actions)가 검토 대상으로 보내는 작업을 확인하도록 서버에 요청할 수 있습니다. 다음 세션이 서버에 요청합니다.

* **Anthropic API에 대한 직접 연결**: 플랜이나 계정 유형에 관계없이 대화형 터미널 세션과 `-p`, Agent SDK, [VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md), [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md) 세션에서, Anthropic이 순차적으로 배포함에 따라 적용됩니다. 세션 유형에 해당하는 최소 Claude Code 버전을 확인하십시오.
  * 대화형 터미널 세션에서 서버에 요청하려면 Pro, Max, Ultra, Team 플랜의 경우 Claude Code v2.1.271 이상이 필요합니다. Enterprise 플랜과 Claude API 계정에서는 이러한 세션에 v2.1.278 이상이 필요합니다.
  * `-p`, Agent SDK, VS Code 확장 프로그램 및 데스크톱 앱 세션에서 서버에 요청하려면 Claude Code v2.1.281 이상이 필요합니다
  * v2.1.282부터는 예를 들어 텔레메트리를 꺼서 [기능 플래그를 가져오지 않는](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) 세션은 어떤 종류의 세션에서든 기본적으로 서버에 요청합니다
* **클라우드 제공업체 또는 LLM 게이트웨이나 프록시**: [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md), Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry에서, 그리고 `ANTHROPIC_BASE_URL`을 [LLM 게이트웨이 또는 프록시](https://code.claude.com/docs/ko/llm-gateway)로 지정할 때마다, 플랜에 관계없이 적용됩니다. 기본적으로 요청하려면 Claude Code v2.1.278 이상이 필요합니다.
* **로그인된 [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway) 세션**: Claude Code v2.1.280 이상이 필요합니다
* **Anthropic 호스팅 환경의 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)**: 플랜에 관계없이, 웹, 모바일 앱 또는 **Cloud**를 선택한 데스크톱 앱에서 시작할 때 적용됩니다. [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)으로 시작된 세션은 Anthropic이 순차적으로 배포함에 따라 서버에 요청합니다.

서버가 작업을 검토하는 경우 서버의 판정이 작업을 결정합니다. 그 밖에 두 가지 결과가 가능합니다.

* **서버가 세션을 검토하지 않는 경우**: 응답이 검토 결과 없이 완료되거나, 서버가 이 세션을 검토하지 않는다고 응답합니다. 가장 흔한 원인은 검토 요청이나 결과를 누락시키는 LLM 게이트웨이나 프록시, 그리고 아직 서버 측 확인을 지원하지 않는 플랫폼, 리전 또는 자격 증명입니다. Claude Code는 자체 분류기 요청으로 폴백합니다. 이 폴백이 세션의 나머지 기간 동안 유지되면, 해당 요청이 과금되는 계정에서는 [분류기 요청 요금에 대한 알림](https://code.claude.com/docs/ko/auto-mode-classifier-billing.md)을 표시합니다.
* **서버가 작업에 대한 판정을 내리지 않는 경우**: Claude Code는 검토되지 않은 작업을 실행하지 않고 거부합니다. 어떤 연결에서든 검토 결과가 도착하기 전에 응답이 끝나거나, Claude Code가 읽을 수 없는 형식으로 결과가 도착하면 이런 일이 발생합니다. 응답을 중간에 잘라내거나 결과를 다시 쓰는 LLM 게이트웨이나 프록시가 둘 다의 원인이 될 수 있습니다. Anthropic API에 직접 연결된 경우, 예를 들어 시간 초과로 인해 서버의 확인이 해당 작업에 대해 실패할 때도 이런 일이 발생합니다. 거부 메시지, 거부가 반복될 때 일어나는 일, 해결 방법은 [The server returned no safety verdict](https://code.claude.com/docs/ko/errors.md#the-server-returned-no-safety-verdict)에서 다룹니다.

서버에 요청하지 않고 항상 Claude Code의 자체 분류기 요청을 사용하려면 [`CLAUDE_CODE_AUTO_MODE_SERVER=0`](https://code.claude.com/docs/ko/env-vars)을 설정하십시오. Anthropic API에 직접 연결된 경우 이 변수에는 Claude Code v2.1.281 이상이 필요합니다. 여기서 이 변수를 `1`로 설정하면, `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`도 함께 설정하지 않은 한, 아직 서버 검토가 적용되지 않은 세션에서 서버 검토가 켜집니다. `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`을 설정하고 `CLAUDE_CODE_AUTO_MODE_SERVER`를 설정하지 않으면, [사전 출시 기능 비활성화](https://code.claude.com/docs/ko/llm-gateway-protocol.md#disable-pre-release-capabilities)에 설명된 경우를 제외하고 Claude Code는 서버에 요청하는 것도 중단합니다.

### 기본 분류기 모델

기본적으로 분류기 요청은 Claude Sonnet 5로 전송됩니다. `/status`에 `Auto mode server`가 `Enabled`로 표시되면, 분류기 요청은 [서버의 검토](#server-side-classifier-review) 대상이 아닌 호출에 대해서만 전송됩니다.

이 표에서 세션과 일치하는 첫 번째 행을 찾으십시오. Sonnet 5 대신 해당 행의 모델이 사용됩니다.

| 세션 | 분류기 모델 |
| - | - |
| Anthropic이 구성한 분류기 모델이 있음 | 구성된 모델. 어떤 모델인지는 [디버그 로그를 확인](#classifier-model-check)하십시오 |
| Claude Sonnet 4.6에서 실행됨 | Sonnet 4.6 |
| [`ANTHROPIC_DEFAULT_SONNET_MODEL`](https://code.claude.com/docs/ko/model-config#environment-variables)이 설정됨 | 해당 값. 값이 Claude Sonnet 5.5 또는 Claude Opus 5.5이면 Sonnet 5 |

Sonnet 5 또는 `ANTHROPIC_DEFAULT_SONNET_MODEL`의 모델을 제공업체에서 사용할 수 없거나 조직의 [모델 정책](https://code.claude.com/docs/ko/model-config.md#restrict-model-selection)에서 제외한 경우, Claude Code는 대체 모델을 사용합니다. 이는 세션의 모델이며, [Fable 세션](https://code.claude.com/docs/ko/model-config.md#work-with-fable)에서는 Opus 모델입니다.

### 분류기 모델 선택

Claude Code v2.1.302 이상에서는 [`CLAUDE_CODE_AUTO_MODE_MODEL`](https://code.claude.com/docs/ko/env-vars)을 전체 모델 ID로 설정하여 [기본값](#default-classifier-model)이 아닌 모델에서 분류기를 실행할 수 있습니다. 클라우드 제공업체 자체의 전체 모델 ID도 사용할 수 있습니다. 다음 `~/.claude/settings.json` 예시는 Claude Sonnet 4.6을 설정합니다.

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_AUTO_MODE_MODEL": "claude-sonnet-4-6"
  }
}
```

#### 설정한 모델이 검토하지 않는 경우

| 상황 | 결과 | 조치 |
| - | - | - |
| [디버그 로그](#classifier-model-check)에 Anthropic이 구성한 분류기 모델이 보고됨 | 해당 모델이 검토함 | 조치 필요 없음 |
| Claude Opus 5, Sonnet 5.5, Opus 5.5 또는 조직의 [모델 정책](https://code.claude.com/docs/ko/model-config.md#restrict-model-selection)에서 제외한 모델을 설정함 | [기본 분류기 모델](#default-classifier-model)이 검토함 | 다른 모델 설정 |
| 제공업체가 해당 모델을 제공할 수 없음 | 분류기 확인이 실패하므로 Claude Code가 [확인하는 각 작업을 거부함](https://code.claude.com/docs/ko/errors.md#auto-mode-cannot-determine-the-safety-of-an-action) | 제공업체가 제공하는 모델을 설정하거나 변수 제거 |
| 세션에서 `/status`에 [`Auto mode server`](#server-side-classifier-review)가 `Enabled`로 표시됨 | 설정한 모델 없이 서버가 검토함 | 조치 필요 없음 |

여러 상황이 해당하면 목록에서 먼저 나오는 상황을 따릅니다.

#### 분류기가 사용한 모델 확인

셸에서 [`--debug-file`](https://code.claude.com/docs/ko/cli-reference#cli-flags)을 사용하여 자동 모드 세션을 시작합니다.

```bash theme={null}
claude --permission-mode auto --debug-file classifier-debug.log
```

Claude가 읽기 전용이 아닌 셸 명령을 실행하도록 한 다음, 로그에서 `classifier_request_started`를 검색합니다.

* **`model=` 뒤에 설정한 모델이 있음**: 변수가 적용되었습니다
* **`model=` 뒤에 다른 모델이 있음**: 로그에서 `ignoring CLAUDE_CODE_AUTO_MODE_MODEL`을 검색하십시오. 이 줄에 이유와 필요한 조치가 나와 있습니다
* **해당 줄이 없음**: Claude Code 프롬프트에서 `/status`의 `Auto mode server`를 확인하십시오.
  * **`Enabled`**: [서버](#server-side-classifier-review)가 이 세션의 호출을 검토하도록 설정되어 있습니다.
  * **`Disabled`**: [권한 모드](#switch-permission-modes)가 auto인지 확인한 다음, Claude가 읽기 전용이 아닌 다른 명령을 실행하도록 하십시오.

### 분류기가 기본적으로 차단하는 항목

분류기는 작업 디렉터리와 세션 시작 시점에 해당 디렉터리에 구성되어 있던 원격 저장소를 신뢰합니다. 세션 중에 `git remote add` 또는 `git remote set-url`로 추가되거나 대상이 변경된 원격 저장소는 신뢰되지 않으며, [신뢰할 수 있는 인프라를 구성](https://code.claude.com/docs/ko/auto-mode-config.md)하기 전까지 그 밖의 모든 것은 외부로 취급됩니다.

**기본적으로 차단됨**:

* `curl | bash`처럼 코드를 다운로드하여 실행하는 작업
* 민감한 데이터를 외부 엔드포인트로 전송하는 작업
* 프로덕션 배포 및 마이그레이션
* 클라우드 스토리지의 대량 삭제
* IAM 또는 저장소 권한 부여
* 공유 인프라 수정
* 세션 이전부터 존재하던 파일을 되돌릴 수 없게 삭제하는 작업
* 강제 푸시
* 실행 시 시크릿이나 민감한 데이터를 저장소 외부로 보내거나, 배포가 노출하는 범위를 넓히는 변경을 커밋하거나 푸시하는 작업. 여기에는 시크릿을 아직 받지 않는 대상으로 전달하는 CI 워크플로나 배포 구성, 시크릿 저장소를 읽어 데이터를 외부로 보내는 스크립트나 설정 단계, 레지스트리, 공개 범위, 아티팩트 또는 소스맵 설정처럼 배포가 게시하는 범위를 넓히는 구성 변경이 포함됩니다. 이 확인은 모든 브랜치에 적용되고, 저장소가 공개 저장소인 경우에도 적용되며, 해당 커밋이나 푸시가 파이프라인을 트리거하는지 여부와 관계없이 변경이 커밋되거나 푸시될 때 발동합니다. 이를 해제하려면 커밋이나 푸시만이 아니라 실행 효과를 명시해야 합니다
* `git reset --hard`, `git checkout -- .`, `git restore .`, `git clean -fd`, `git stash drop` 또는 `git stash clear`. 분류기는 이러한 명령이 커밋되지 않은 변경 사항을 버린다고 가정합니다
* HEAD의 커밋이 이 세션에서 생성되지 않은 경우의 `git commit --amend`
* v2.1.198부터, HEAD의 커밋이 이미 푸시된 경우의 `git commit --amend`. 메시지만 바꾸는 경우는 차단되지 않습니다. 즉, 이 세션에서 Claude가 만든 커밋에 대해 새로 스테이징된 항목 없이 `--amend -m`을 사용하는 경우입니다
* `terraform destroy`, `pulumi destroy`, `cdk destroy` 또는 `terragrunt destroy`, 그리고 리소스를 삭제하는 플랜 적용
* 시크릿 매니저에 쓰기, 또는 DNS 레코드나 TLS 인증서 변경
* 사람이 승인하지 않은 풀 리퀘스트 병합, Claude 자신의 풀 리퀘스트 승인, 또는 CI 검사 비활성화
* `atlantis apply`나 봇의 `/deploy` 또는 `/merge`처럼 그 자체가 자동화에 대한 명령인 댓글 게시
* 프로덕션 기능 플래그의 전환, 점진적 확대 또는 삭제
* 보호된 IaC 범위에 인프라 변경 적용, 또는 클러스터 노드 드레인 및 제거
* 레이블 선택기나 다른 사용자의 작업까지 포함하는 `--all`처럼, 지정한 리소스를 넘어서는 공유 컴퓨팅 클러스터에 대한 쓰기
* DaemonSet 및 admission webhook처럼 모든 노드에서 실행되거나 클러스터 트래픽을 가로채는 Kubernetes 리소스 생성
* 민감한 원격 대상에 대한 대화형 셸 또는 포트 포워딩
* 로컬 서비스를 공용 인터넷에서 접근 가능하게 만드는 터널 또는 리버스 셸 열기
* 실제 자격 증명이나 토큰을 트랜스크립트나 파일에 출력하는 작업
* [환경](https://code.claude.com/docs/ko/auto-mode-config.md#define-trusted-infrastructure)에 민감한 데이터 위치로 나열된 위치에 접근하거나, 그곳에서 데이터를 복사하거나, 해당 항목이 제외하는 대상에게 그곳의 데이터를 보내는 작업
* 패키지 설치를 내부 패키지 레지스트리를 우회하여 공개 레지스트리로 라우팅하는 작업. 이는 내부 레지스트리나 미러가 환경에 나열되어 있거나 대화에서 Claude에게 내부 레지스트리가 있다고 알린 경우에 적용됩니다
* `--insecure`처럼 안전 장치를 해제하는 플래그를 사용하여 명령을 실행하는 작업
* `--dangerously-skip-permissions` 또는 `--no-sandbox`로 시작한 것처럼, 사람의 승인이나 샌드박스 없이 실행되는 자율 에이전트 루프 실행. 여기에는 `--yes-always`로 시작한 실행기처럼 격리와 작업별 승인이 비활성화된 서드파티 에이전트나 평가 하네스 실행도 포함됩니다
* 페이지 콘텐츠, 쿠키 또는 자격 증명을 다른 출처로 보낼 수 있는 [Claude in Chrome](https://code.claude.com/docs/ko/chrome.md) 브라우저 작업
* 특정 이름의 경로가 아닌 와일드카드, glob 또는 기간 필터로 `/tmp`, `$TMPDIR` 또는 기타 공유 임시 디렉터리나 캐시 디렉터리의 파일을 삭제하는 작업
* 사용자 본인의 메시지가 해당 수신자에게 허용하지 않은 민감한 세부 정보를, 다른 사람이나 공유 시스템으로 전송, 업로드, 게시 또는 작성되는 콘텐츠에 포함하는 작업. 저장소가 신뢰 경계 밖에 있거나 공개 저장소인 경우(조직 자체의 공개 저장소 포함) PR 및 이슈 본문, 커밋 메시지, 댓글이 이러한 외부 전송 콘텐츠에 해당합니다. 내부 파일 경로, 코드 이름, 이메일이나 계정 식별자 같은 실시간 API 응답 데이터, 인프라 식별자가 민감한 세부 정보에 해당합니다. PR 또는 이슈 본문에 이메일 주소, 계정이나 조직 식별자, 사용량 지표 같은 API 응답의 실시간 개인 데이터를 포함하려면, 저장소의 공개 범위나 신뢰 경계와 관계없이 해당 세부 정보와 수신자를 사용자가 직접 명시해야 합니다
* Claude Code 자체의 tmux 창에 키 입력을 보내 자신의 인터페이스를 조작하는 작업. 분류기는 이를 Claude가 자신의 권한이나 감독을 변경하는 것으로 취급합니다
* 인증, 접근 제어, 입력 검증 또는 샌드박싱 같은 보안 동작을 보호하는 테스트나 어설션을 주석 처리, 삭제 또는 강제 통과시키는 작업
* 더 구체적인 삭제 규칙이 적용되지 않고 사용자가 해당 리소스를 지정하지 않은 경우, Claude가 세션에서 생성하지 않은 상태 저장 리소스를 삭제하거나 해체하는 작업
* API 기본 URL, 프록시 엔드포인트, 웹훅 수신기 또는 레지스트리 미러를 작업에 맞지 않는 서드파티 호스트로 변경하는 작업. `.env.example` 같은 예시 파일에서의 변경도 포함됩니다
* 새 원격 저장소를 사용자가 지정하지 않은 경우, `git remote set-url` 또는 `git remote add`로 푸시 대상을 변경하는 작업
* 공개된 것으로 알려진 저장소에 시크릿이나 개인 데이터 또는 위탁받은 데이터를 푸시하거나, 해당 저장소 자체의 작업에 속하지 않는 기밀 자료를 푸시하는 작업. 개인 데이터나 위탁받은 데이터의 경우 dotfiles 저장소 자체의 주제가 유일한 예외이며, 비공개 저장소의 콘텐츠가 공개된 곳에 도달하는 것도 같은 방식으로 차단됩니다. 저장소의 공개 범위가 확인되지 않은 경우 분류기는 그것만으로 차단하지 않고, 대신 다른 규칙에 따라 콘텐츠를 판단합니다
* 외부 대상을 사용자가 지정하지 않은 경우, 다른 저장소나 조직을 대상으로 풀 리퀘스트를 열거나, `gh repo fork`로 포크하거나, 서드파티 저장소에 푸시하는 작업
* 출처와 대상을 모두 사용자가 지정하지 않은 경우, 민감한 로컬 저장 위치의 콘텐츠 또는 이름, 경로나 유형으로 민감함이 드러나는 파일의 콘텐츠가 커밋, 푸시, PR 또는 이슈 텍스트, gist나 paste, 패키지 게시에 포함되는 작업. 세션 트랜스크립트와 대화 로그, SSH 키, 클라우드 자격 증명, 브라우저 프로필, 셸 기록 같은 자격 증명 및 구성 점 폴더, 사용자 데이터 내보내기가 모두 해당하며, 저장소가 비공개라고 해서 허용되지 않습니다
* 직접 또는 셸 명령을 통해 Claude Code 세션 트랜스크립트, 즉 `~/.claude/projects/` 또는 구성된 설정 디렉터리 아래의 `.jsonl` 기록 파일에 쓰는 작업. 이 규칙은 Claude Code가 자체 확인을 위해 각 트랜스크립트 항목에 덧붙이는 메타데이터 줄도 다룹니다. 트랜스크립트를 읽는 것은 차단되지 않습니다
* 대상이 분류기가 보는 대화 어디에서도 할당되지 않은 셸 변수이거나 그러한 변수를 기준으로 하는 glob인 `rm -rf "$VAR"` 또는 `Remove-Item -Recurse -Force $dir` 같은 재귀적 강제 삭제. 해당 값은 분류기가 받지 못하는 이전 명령 출력에서만 나왔으므로, 분류기는 삭제 대상을 다른 삭제 규칙에 비추어 확인할 수 없습니다. 삭제되는 정확한 경로를 사용자가 지정하거나, Claude가 확인된 리터럴 경로를 명령에 직접 써서 삭제를 다시 실행하면 차단이 해제됩니다. 분류기가 대상을 확인할 수 있는 삭제는 영향을 받지 않습니다.

  `rm -rf "$VAR"/*`처럼 변수 바로 아래의 glob은 대신 [중요 경로](#critical-paths)에 해당합니다. 대상이 단독 `*`이거나 `/*` 또는 `\*`로 끝나는 `Remove-Item`은 분류기에 도달하지 않습니다. Claude Code가 [즉시 거부합니다](#remove-item-in-powershell).

이러한 범주 중 일부는 민감한 원격 대상이나 보호된 IaC 범위처럼 구체적인 이름으로 좁힐 수 있는 [환경](https://code.claude.com/docs/ko/auto-mode-config.md#define-trusted-infrastructure) 항목에 따라 달라집니다.

Claude Code v2.1.257 이상에서는 다음 항목도 기본적으로 차단합니다.

* `169.254.169.254` 같은 클라우드 인스턴스 메타데이터 엔드포인트에 자격 증명을 요청하거나, 머신 자체의 서비스 계정 또는 노드 ID로 클라우드, 클러스터 또는 레지스트리 호출을 명시적으로 인증하는 작업
* 터널, 리버스 셸, 또는 외부를 가리키도록 다시 작성된 리졸버나 프록시 구성처럼 직접 요청이 아닌 경로로 공개 호스트에 접근하는 작업
* 노드 인증서나 노드의 컨테이너 레지스트리 인증 정보처럼 작업이 아닌 호스트에 속한 자격 증명을 읽는 작업
* Claude가 시작하지 않은 형제 컨테이너, 파드 또는 VM이나 컨테이너 아래의 노드에 연결하거나 스캔하는 작업

Claude Code가 이 중 하나를 허용하도록 의도된 환경에서 실행되는 경우, `autoMode.environment`의 [Host containment 항목](https://code.claude.com/docs/ko/auto-mode-config.md#define-trusted-infrastructure)에 해당 구성을 설명하십시오.

Claude Code v2.1.261 이상에서는 다음 항목도 기본적으로 차단합니다.

* URL 자체에 공유되는 콘텐츠가 담겨 있는 경우, 메시지, PR 또는 이슈 텍스트, 문서 또는 링크가 열리거나 가져와지는 기타 위치에 공개 paste, 다이어그램 또는 데이터 공유 서비스 링크를 게시하거나 작성하는 작업. 사용자가 해당 서비스를 지정한 경우는 예외입니다

**기본적으로 허용됨**:

* 작업 디렉터리 내의 로컬 파일 작업
* 잠금 파일이나 매니페스트에 선언된 의존성 설치
* `.env`를 읽고 자격 증명을 해당 API로 전송하는 작업
* 읽기 전용 HTTP 요청
* 기본 브랜치를 포함하여 작업 중인 저장소의 모든 브랜치로 푸시하는 작업. `production`이나 `gh-pages`처럼 이름으로 배포 또는 게시 대상임을 나타내는 기본이 아닌 브랜치는 여기에 포함되지 않으며, 분류기는 해당 브랜치로의 푸시를 별도로 판단합니다.

  푸시의 콘텐츠는 여전히 분류기의 다른 규칙에 따라 확인되며, [`permissions.deny` 규칙](https://code.claude.com/docs/ko/permissions#manage-permissions)은 모든 모드에서 푸시 명령을 [작성된 그대로](https://code.claude.com/docs/ko/permissions.md#bash-rule-limits) 여전히 차단할 수 있습니다. 원격 저장소 자체의 브랜치 보호도 여전히 적용됩니다.
* 같은 세션에서 Claude가 앞서 생성한 바로 그 작업 삭제
* 작업의 일부로 보안 관련 코드, 구성 및 위협 모델을 읽고, 검토하고, 작성하는 작업
* 같은 멀티 에이전트 세션에서 함께 작업하는 에이전트 간의 메시지
* [`environment`](https://code.claude.com/docs/ko/auto-mode-config#define-trusted-infrastructure)에 나열한 신뢰할 수 있는 도메인, 버킷 및 서비스로 데이터를 보내는 작업. 이는 데이터 흐름만 다루며, 같은 인프라에 대한 파괴적 작업이나 자격 증명 작업은 포함하지 않습니다
* 신뢰할 수 있는 내부 도메인, localhost 또는 사용자가 지정한 URL로의 [Claude in Chrome](https://code.claude.com/docs/ko/chrome.md) 탐색

샌드박스 처리된 명령은 기본적으로 네트워크 접근 권한을 받지 않습니다. Claude는 명령에 필요한 호스트를 명령 자체에 명시하고, 분류기는 명령과 함께 이를 검토하며, 승인된 목록은 해당 명령 하나에 대해서만 그 호스트를 엽니다. 목록으로 열 수 있는 것과 열 수 없는 것, 그리고 명령이 목록에 없는 호스트에 접근하려 할 때 일어나는 일은 [명령별 허용 도메인](https://code.claude.com/docs/ko/sandboxing.md#per-command-allowed-domains-in-auto-mode)에서 다룹니다.

`claude auto-mode defaults`를 실행하면 전체 규칙 목록을 JSON으로 출력합니다. 일상적인 작업이 차단되는 경우 관리자는 `autoMode.environment` 설정을 통해 신뢰할 수 있는 저장소, 버킷 및 서비스를 추가할 수 있습니다. [자동 모드 구성](https://code.claude.com/docs/ko/auto-mode-config.md)을 참조하십시오.

작업 중인 저장소의 모든 브랜치로 푸시하는 작업과 요청에 부합하는 풀 리퀘스트를 생성하는 작업은, 시크릿이나 민감한 데이터가 저장소 밖으로 나가거나 풀 리퀘스트가 다른 저장소나 조직을 대상으로 하는 경우처럼 푸시나 풀 리퀘스트가 [차단 목록](#what-the-classifier-blocks-by-default)에 해당하지 않는 한 프롬프트 없이 실행됩니다. 자동 모드를 유지하면서 이러한 명령 전에 사람의 확인 단계를 요구하려면, 명령을 [작성된 그대로](https://code.claude.com/docs/ko/permissions.md#bash-rule-limits) 매칭하는 `permissions.ask` 규칙을 추가하십시오. [일반적인 경계](https://code.claude.com/docs/ko/auto-mode-config.md#common-boundaries)를 참조하십시오.

### 작업 디렉터리 밖의 첫 번째 읽기

[`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)가 꺼져 있는 동안, 자동 모드에서는 [네트워크 경로에서의 읽기](https://code.claude.com/docs/ko/permissions.md#network-paths)를 제외한 파일 읽기가 [작업 디렉터리](https://code.claude.com/docs/ko/permissions.md#working-directories) 밖의 읽기를 포함하여 프롬프트 없이 실행됩니다. Claude가 작업 디렉터리 밖의 경로에 처음으로 Read, Grep 또는 Glob 도구를 사용하면, Claude Code는 해당 읽기를 허용할지 묻습니다.

이 프롬프트는 비대화형 `-p` 실행이나 백그라운드 세션에서는 나타나지 않으며, 그곳에서는 읽기가 이전과 같이 실행됩니다.

어떻게 답하든 Claude는 작업을 계속합니다.

* **Yes, and keep allowing any reads outside the working directories**: 읽기가 실행되고, 이후 작업 디렉터리 밖의 읽기도 이전과 같이 실행되며, Claude Code는 프롬프트가 다시 나타나지 않도록 답변을 기록합니다
* **No, and block reads outside the working directories from now on**: 읽기가 거부되고, Claude Code는 사용자 설정에서 [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)를 `true`로 설정합니다. 이렇게 하면 이후의 모든 세션과 모든 권한 모드에서 파일 도구가 이러한 읽기를 거부합니다. 나중에 Claude가 그러한 경로를 읽을 수 있게 하려면 `/add-dir`로 해당 디렉터리를 추가하거나 설정을 제거하십시오.
* **No, and ask again next time**: 읽기가 거부되고, 다음에 작업 디렉터리 밖을 읽을 때 다시 프롬프트가 표시됩니다
* **Yes, but ask again next time**: 읽기가 실행되고, 아무것도 저장되지 않으며, 다음에 작업 디렉터리 밖을 읽을 때 다시 프롬프트가 표시됩니다

### 대화에서 명시한 경계

분류기는 대화에서 사용자가 명시한 경계를 차단 신호로 취급합니다. Claude에게 "푸시하지 마" 또는 "배포 전에 내가 검토할 때까지 기다려"라고 말하면, 기본 규칙이 허용하는 경우에도 분류기는 해당하는 작업을 차단합니다. 경계는 이후 메시지에서 사용자가 해제할 때까지 유효합니다. 조건이 충족되었다는 Claude 자신의 판단으로는 해제되지 않습니다.

경계는 규칙으로 저장되지 않습니다. 분류기는 확인할 때마다 트랜스크립트에서 경계를 다시 읽으므로, [컨텍스트 압축](https://code.claude.com/docs/ko/costs.md#reduce-token-usage)으로 경계를 명시한 메시지가 제거되면 경계가 사라질 수 있습니다. 확실한 보장이 필요하다면 대신 [deny 규칙](https://code.claude.com/docs/ko/permissions.md#permission-rule-syntax)을 추가하십시오.

### 대화에서 명시한 승인

차단된 작업이 허용된다고 Claude에게 말하면, 분류기는 이를 사용자의 승인으로 읽고 차단을 해제할 수 있습니다. 어떻게 표현했는지에 따라 작업의 실행 여부와 승인의 적용 범위가 결정됩니다.

* **작업과 그 세부 사항을 명시하십시오**: 메시지에서 작업과 그 작업을 위험하게 만드는 구체적인 대상, 예를 들어 강제 푸시의 브랜치를 명시해야 합니다. 동사만 언급해서는 아무것도 해제되지 않으므로, "강제 푸시해도 돼"라고 하면 차단이 그대로 유지됩니다.
* **하나의 작업에만 적용된다고 생각하십시오**: 승인은 사용자가 명시한 파괴적 작업에만 적용되므로, 승인을 지속적인 것으로 부여하지 않은 한 이후 작업은 다시 차단됩니다. 일상적인 패턴을 작업마다 하나씩 승인하지 않으려면 [`autoMode.allow`](https://code.claude.com/docs/ko/auto-mode-config#override-the-block-and-allow-rules)에 추가하십시오.
* **일부 차단은 유지됩니다**: 승인으로 해제할 수 있는 차단은 [분류기의 우선순위](https://code.claude.com/docs/ko/auto-mode-config.md#override-the-block-and-allow-rules)에 정해져 있습니다. 승인으로 해제되지 않는 단계를 실행하려면 [자동 모드를 벗어나](#switch-permission-modes) 권한 프롬프트에 답하십시오.

### 자동 모드가 폴백하는 경우

자동 모드가 세션의 작업을 승인할 수 없을 때 일어나는 일은 경우에 따라 다릅니다.

* **차단된 작업**: Claude Code는 알림을 표시하고 `/permissions`의 **Recently denied** 탭에 해당 작업을 나열합니다. 여기서 `r`을 눌러 수동 승인으로 재시도할 수 있습니다.
* **반복된 차단**: 분류기가 작업을 연속 3회 또는 총 20회 차단하면 자동 모드가 일시 중지되고 Claude Code가 다시 확인을 요청합니다. 확인 요청된 작업을 승인하면 자동 모드가 재개됩니다. 차단 횟수를 세는 방법은 [반복 차단 임계값](#repeated-block-thresholds)을 참조하십시오.
* **분류기의 판정 없음**: 자동 모드와는 별개인 안전 확인이 분류기 자체의 요청을 거부하거나 분류기의 응답을 파싱할 수 없으면, Claude Code는 알림이나 **Recently denied** 항목 없이 작업을 거부합니다. 각 경우에 표시되는 메시지와 해결 방법은 [Auto mode cannot determine the safety of an action](https://code.claude.com/docs/ko/errors.md#auto-mode-cannot-determine-the-safety-of-an-action)을 참조하십시오.
* **서버의 판정 없음**: [서버 측 분류기 검토](#server-side-classifier-review)에서 Claude Code는 서버가 판정을 내리지 않은 작업을 거부하고, 판정 없는 응답이 연속 10회 이어지면 턴을 중단합니다. [The server returned no safety verdict](https://code.claude.com/docs/ko/errors.md#the-server-returned-no-safety-verdict)를 참조하십시오.
* **확인 중 모드 전환**: 분류기 확인이 대기 중일 때 권한 모드를 전환하면, Claude Code는 새 모드에서는 요청하지 않았을 판정을 폐기합니다. 대신 승인 요청을 받거나, [`dontAsk` 모드](#allow-only-pre-approved-tools-with-dontask-mode)에서는 작업이 자동으로 거부됩니다.

#### 반복 차단 임계값

연속 3회 차단과 총 20회 차단이라는 임계값은 구성할 수 없습니다. 총 카운터는 세션 동안 유지되며, 자체 한도로 인해 폴백이 발생할 때만 초기화됩니다. 자동 모드와는 별개인 안전 확인이 분류기 자체의 요청을 거부한 경우, Claude Code는 해당 거부를 어느 임계값에도 포함하지 않습니다.

[`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 없는 [비대화형](https://code.claude.com/docs/ko/headless.md) `-p` 실행에는 폴백할 프롬프트가 없습니다. 반복된 차단이 임계값에 도달하면 해당 작업은 실행되지 않고 Claude는 작업을 계속합니다. Claude Code는 실행을 중단하지 않습니다.

반복된 차단은 대개 분류기에 인프라에 대한 컨텍스트가 부족하다는 의미입니다. `/feedback`을 사용하여 오탐을 보고하거나, 관리자에게 [신뢰할 수 있는 인프라를 구성](https://code.claude.com/docs/ko/auto-mode-config.md)하도록 요청하십시오.

### 자동 모드가 작업을 평가하는 방식

다음 섹션에서는 Claude Code가 작업을 평가하는 순서, 분류기가 서브에이전트 작업을 검토하는 방식, 분류기 호출로 추가되는 비용과 지연 시간을 다룹니다.

> [accordion] 분류기가 작업을 평가하는 방식
>
> 각 작업은 고정된 결정 순서를 거칩니다. 처음으로 일치하는 단계가 적용됩니다.
>
> 1. [allow, ask 또는 deny 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)과 일치하는 작업은 즉시 처리되며, 다음과 같은 예외가 있습니다.
>    * [보호된 경로](#protected-paths)에 대한 쓰기는 allow 규칙과 일치하더라도 분류기로 전달됩니다. 보호된 경로가 심볼릭 링크된 설정 파일이 가리키는 파일인 경우, [보호된 경로](#protected-paths) 목록에 설명된 대로 대신 확인을 요청할 수 있습니다
>    * 어떤 allow 규칙도 인식된 `rm` 및 `rmdir` [중요 경로 삭제](#critical-paths)를 승인하지 않습니다
>    * [`requiresUserInteraction`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)으로 표시된 MCP 도구는 allow 규칙과 일치하더라도 직접 확인을 요청하며, 해당 설정이 Claude Code에 적용되는 세션에서 [조직이 `ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구도 마찬가지입니다
>    * [명령별 허용 도메인](https://code.claude.com/docs/ko/sandboxing.md#per-command-allowed-domains-in-auto-mode)을 포함하는 셸 명령도 allow 규칙과 일치하더라도 분류기로 전달됩니다. 규칙은 명령을 승인할 뿐 그 호스트를 승인하지 않기 때문입니다
>    * `Bash(git push *)`처럼 명령의 내용과 매칭되는 ask 규칙은 권한 프롬프트로 폴백합니다
>    * [심볼릭 링크 확인](https://code.claude.com/docs/ko/permissions.md#symlinks)에서 보호된 경로로 확인되는 쓰기는, Claude가 요청한 경로 자체가 보호되지 않은 경우 확인을 요청합니다
>    * [네트워크 경로](https://code.claude.com/docs/ko/permissions.md#network-paths)에서의 읽기는 allow 규칙과 일치하더라도 확인을 요청합니다
> 2. 작업 디렉터리 내의 읽기 전용 작업과 파일 편집은 자동 승인됩니다. 단, [보호된 경로](#protected-paths)에 대한 쓰기와 확인을 요청하는 [작업 디렉터리 밖의 첫 번째 읽기](#first-read-outside-the-working-directories)는 예외입니다
>    * [서버 측 분류기 검토](#server-side-classifier-review)가 적용되는 세션에서는 읽기 전용 셸 명령과 [샌드박스 처리된](https://code.claude.com/docs/ko/sandboxing.md#sandbox-modes) 셸 명령이 해당 검토를 기다리며, 검토에서 문제가 지적되면 차단됩니다
>    * [심볼릭 링크 확인](https://code.claude.com/docs/ko/permissions.md#symlinks)에서 작업 디렉터리 밖의 위치로 확인되는 작업 디렉터리 내 쓰기는 확인을 요청합니다
>    * Claude가 [다른 사람이 만든 아티팩트](https://code.claude.com/docs/ko/artifacts.md#read-an-artifact-shared-with-you)를 읽는 경우, 해당 섹션에 나열된 승인 사례가 적용됩니다
>    * [네트워크 경로](https://code.claude.com/docs/ko/permissions.md#network-paths)에서의 읽기는 확인을 요청합니다
> 3. 기본 처리 방식이 적용되는 [중요 경로 삭제](#critical-paths)를 제외한 나머지는 모두 분류기로 전달됩니다. 1단계에서 직접 확인을 요청하는 커넥터 도구와 `requiresUserInteraction` MCP 도구도 분류기에 도달하지 않으므로, 조직이 요구한 승인이나 동의 단계는 자동 승인되지 않습니다
> 4. 분류기가 차단하면 Claude는 그 이유를 받습니다. 대부분의 세션에서 이유는 서술된 설명 대신 `[Data Exfiltration]`처럼 분류기가 매칭한 규칙의 이름입니다. [거부 검토](https://code.claude.com/docs/ko/auto-mode-config.md#review-denials)를 참조하십시오
>
> `tool.check`를 처리하는 설치된 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)도 작업을 승인할 수 있습니다. 해당 승인이 규칙과 훅을 통과하지 못하는 경우는 [훅으로 권한 확장](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)을 참조하십시오.
>
> VS Code 확장 프로그램에서 [Claude in Chrome](https://code.claude.com/docs/ko/chrome.md) 브라우저 작업이 승인되는 방식은 [VS Code 세션의 권한 프롬프트](https://code.claude.com/docs/ko/chrome.md#permission-prompts-in-vs-code-sessions)를 참조하십시오.
>
> 자동 모드에 진입하면 임의의 코드 실행을 허용하는 광범위한 allow 규칙이 제외됩니다.
>
> * 전면적인 `Bash(*)` 또는 `PowerShell(*)`
> * `Bash(python*)` 같은 와일드카드 인터프리터
> * 패키지 매니저 실행 명령
> * `Agent` allow 규칙
> * [`Monitor`](https://code.claude.com/docs/ko/tools-reference#monitor-tool) allow 규칙. Claude Code는 Monitor 명령을 셸을 통해 실행하기 때문입니다
>
> `Bash(npm test)` 같은 좁은 규칙은 그대로 유효합니다. 자동 모드를 벗어나면 Claude Code가 제외된 규칙을 복원합니다. v2.1.236 이전에는 Claude Code가 자동 모드에서 `Monitor` allow 규칙을 유효하게 유지했으므로, 도구 전체와 일치하는 규칙이 분류기 검토 없이 Monitor 명령을 승인했습니다.
>
> Claude Code는 또한 `git reset --hard`나 `rm -rf`처럼 커밋되지 않은 작업을 버릴 수 있는 명령 전에 직접 `git status`를 실행하여, 스테이징된 작업, 수정된 작업 또는 추적되지 않은 작업이 있는지를 분류기에 보여 줍니다. Claude Code는 저장소의 git 구성에서 `status.showUntrackedFiles=no`를 설정한 경우에도 해당 확인에서 추적되지 않은 파일을 보고합니다.
>
> Claude Code 자체가 보내는 분류기 요청에서 분류기는 사용자 메시지, 파일 읽기 및 검색 같은 읽기 전용 조회를 제외한 도구 호출, 그리고 CLAUDE.md 내용을 봅니다. 이러한 요청에서는 도구 결과가 제거되므로, 파일이나 웹 페이지의 악의적인 콘텐츠가 분류기를 직접 조작할 수 없습니다.
>
> [PostToolUse 훅의 `classifierContext` 필드](https://code.claude.com/docs/ko/hooks#annotate-a-result-for-the-auto-mode-classifier)로 호출 결과에 주석을 달 수 있으며, 분류기는 이를 애플리케이션이 제공한 컨텍스트로 읽습니다. 이 필드에는 Claude Code v2.1.236 이상이 필요합니다.
>
> 별도의 서버 측 프로브가 들어오는 도구 결과를 검사하여 Claude가 읽기 전에 의심스러운 콘텐츠를 표시합니다. 이러한 계층이 함께 작동하는 방식에 대한 자세한 내용은 [자동 모드 발표](https://claude.com/blog/auto-mode)와 [엔지니어링 심층 분석](https://www.anthropic.com/engineering/claude-code-auto-mode)을 참조하십시오.

> [accordion] 자동 모드가 서브에이전트를 처리하는 방식
>
> 분류기는 세 시점에서 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md) 작업을 확인합니다.
>
> 1. 서브에이전트가 시작되기 전에 위임된 작업 설명이 평가되므로, 위험해 보이는 작업은 생성 시점에 차단됩니다.
> 2. 서브에이전트가 실행되는 동안 각 작업은 부모 세션과 동일한 [결정 순서](#how-the-classifier-evaluates-actions)를 동일한 차단 및 허용 규칙으로 거칩니다. 서브에이전트의 frontmatter에 있는 `permissionMode`는 무시됩니다.
> 3. 서브에이전트가 완료되면, 부모가 보고서를 읽기 전에 분류기가 서브에이전트의 작업과 최종 보고서를 검토합니다. 분류기가 서브에이전트의 작업이나 보고서에서 문제를 지적하거나 별도의 API 안전 확인이 검토를 거부하는 경우에도 보고서는 전달되지만, 앞부분에 보안 경고가 추가됩니다. 검토에 분류기를 사용할 수 없는 경우, 보고서에는 이를 바탕으로 조치하기 전에 서브에이전트의 작업을 확인하라는 메모가 함께 전달됩니다.

> [accordion] 비용 및 지연 시간
>
> Claude Code의 분류기 요청은 `/model`에서 선택한 모델이 아닌 다른 모델에서 실행될 수 있습니다. [어떤 모델에서 실행되는지](#default-classifier-model)를 참조하십시오.
>
> Enterprise 플랜과 Claude API, [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md), Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry를 사용하는 계정에서는 분류기 호출이 토큰 사용량에 포함됩니다. 각 확인은 트랜스크립트의 일부와 대기 중인 작업을 전송하므로 실행 전에 왕복 과정이 추가됩니다. 보호된 경로 밖의 읽기와 작업 디렉터리 편집은 분류기를 건너뛰므로, 오버헤드는 주로 셸 명령과 네트워크 작업에서 발생합니다. 서버가 세션의 모델 요청의 일부로 작업을 검토하는 경우에는 집계할 별도의 분류기 호출이 없습니다. [서버 측 분류기 검토](#server-side-classifier-review)를 참조하십시오.
>
> 샌드박스 처리된 네트워크 접근은 연결마다 분류기 요청을 추가하지 않습니다. 분류기는 [명령이 명시한 호스트](https://code.claude.com/docs/ko/sandboxing.md#per-command-allowed-domains-in-auto-mode)를 명령과 함께 한 번의 검토로 판단하며, Claude Code는 분류기를 다시 호출하지 않고 승인된 목록에 따라 각 연결을 확인합니다.

## dontAsk 모드로 사전 승인된 도구만 허용

`dontAsk` 모드를 설정하면 Claude Code는 평소라면 확인을 요청했을 모든 도구 호출을 자동으로 거부합니다. 단, 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 이러한 호출 중 일부를 여전히 승인할 수 있습니다. mod가 승인할 수 있는 호출을 확인하려면 [훅으로 권한 확장](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)을 참조하세요.

Claude는 여전히 Manual 모드에서 승인이 필요 없는 작업을 실행합니다. 예를 들어 작업 디렉터리 내의 파일 읽기 및 [읽기 전용 Bash 명령](https://code.claude.com/docs/ko/permissions.md#read-only-commands)이 이에 해당합니다. `permissions.allow` 규칙과 일치하는 작업과 [PreToolUse 훅](https://code.claude.com/docs/ko/permissions.md#extend-permissions-with-hooks)으로 승인된 호출도 실행됩니다. 이 모드는 CI 파이프라인이나 Claude가 수행할 수 있는 작업을 사전에 정의하는 제한된 환경에서 사용합니다. 세션은 입력을 기다리지 않습니다. 이 모드에서는 상태 표시줄에 `⏵⏵ don't ask on`이 표시됩니다.

Claude Code는 프롬프트를 표시하는 대신 명시적인 [`ask` 규칙](https://code.claude.com/docs/ko/permissions#manage-permissions)과 일치하는 호출을 거부합니다. 또한 `allow` 규칙이 일치하더라도 기본 제공 `AskUserQuestion` 도구를 거부하며, 해당 설정이 Claude Code에 도달하는 세션에서 조직이 [`ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구도 동일하게 거부합니다. [`_meta["anthropic/requiresUserInteraction"]`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)로 표시된 MCP 도구도 동일한 방식으로 거부합니다. 이는 승인 카드가 이 모드에서 수집하지 않는 답변이 필요하기 때문입니다.

`allow` 규칙이나 `PreToolUse` 훅으로는 다음을 승인할 수 없습니다:

* 인식된 `rm` 및 `rmdir` [중요 경로](#critical-paths) 제거(예: `rm -rf /` 및 `rm -rf ~`)
* [네트워크 경로](https://code.claude.com/docs/ko/permissions.md#network-paths)에서의 읽기

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)은 `defaultMode: "dontAsk"`를 무시합니다. 자세한 내용은 [bypassPermissions](#skip-all-checks-with-bypasspermissions-mode)를 참조하세요.

시작 시 플래그로 설정합니다:

```bash theme={null}
claude --permission-mode dontAsk
```

## bypassPermissions 모드로 모든 확인 건너뛰기

`bypassPermissions` 모드는 권한 프롬프트와 안전 확인을 비활성화하여 [보호된 경로](#protected-paths)에 대한 쓰기를 포함한 도구 호출이 즉시 실행되도록 합니다.

`bypassPermissions` 모드에서도 [어떤 모드도 자동 승인하지 않는 작업](#actions-no-mode-auto-approves)은 각각 프롬프트를 표시하거나 거부되지만, [위험한 `rm` 명령에 대한 프롬프트는 끌 수 있습니다](#turn-off-the-critical-path-removal-prompt-in-bypasspermissions-mode). [다른 조직의 공개 아티팩트](https://code.claude.com/docs/ko/artifacts.md#read-an-artifact-shared-with-you)를 읽으려면 사용자의 승인이 필요한데, 이 모드는 승인을 요청하지 않으므로 Claude는 이를 읽을 수 없습니다. [PowerShell의 Remove-Item](#remove-item-in-powershell) 거부도 이 모드에서 적용됩니다.

두 가지 [세션 간 메시징](https://code.claude.com/docs/ko/cross-session-messaging.md) 보안 조치는 이 모드에서, 그리고 권한 우회가 가능한 대화형 터미널 계획 모드 세션에서도 계속 적용됩니다:

* 이 머신을 넘어 다른 세션으로의 메시지에 대한 [`isolatePeerMachines`](https://code.claude.com/docs/ko/settings-reference#isolatepeermachines) 승인 프롬프트는 계속 나타납니다.
* [`crossSessionInbound`](https://code.claude.com/docs/ko/cross-session-messaging#control-inbound-messages) 값이 적용되지 않을 때, Claude Code는 다른 세션에서의 인바운드 메시지를 승인 대기 상태로 유지하며, 송신 세션이 권한 프롬프트도 우회 중임을 식별할 때만 묻지 않고 전달합니다. 메시지가 대기 중인 상태에서 권한 모드를 종료하면, Claude Code는 인바운드 규칙을 다시 적용하고 현재 수락하는 대기 중인 메시지를 전달합니다.

권한 우회가 가능한 대화형 터미널 세션에서, Claude Code는 [플랜 모드의](#analyze-before-you-edit-with-plan-mode) 차단도 적용하지 않습니다. Claude는 여전히 편집 없이 계획하도록 지시받지만, 계획 중에 시도하는 파일 편집이나 셸 명령은 프롬프트 없이 실행됩니다. 명시적 [요청 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)과 [중요 경로](#critical-paths)를 대상으로 하는 `rm` 및 `rmdir` 제거는 계속 프롬프트를 표시합니다.

계획 모드는 Claude Code가 대화형 터미널 없이 실행되는 모든 곳에서 차단을 유지합니다. 여기에는 `-p`를 사용한 [비대화형 실행](https://code.claude.com/docs/ko/headless.md), [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/permissions.md#plan-mode-plan) 세션, 그리고 [VS Code 확장](https://code.claude.com/docs/ko/vs-code.md)의 채팅 패널의 대화가 포함됩니다. 거기서 `--allow-dangerously-skip-permissions`는 나중에 `bypassPermissions`를 선택 가능하게 합니다.

> [!WARNING]
>
> 이 모드는 인터넷 접근이 없는 컨테이너, VM 또는 개발 컨테이너와 같은 격리된 환경에서만 사용하십시오. 여기서 Claude Code는 호스트 시스템에 손상을 줄 수 없습니다.

활성화되지 않은 상태에서 시작한 세션에서 `bypassPermissions`로 진입할 수 없습니다. [`permissions.defaultMode: "bypassPermissions"`](https://code.claude.com/docs/ko/settings-reference#permissions-defaultmode)로 시작할 때 활성화하거나 활성화 플래그를 사용하십시오:

```bash theme={null}
claude --permission-mode bypassPermissions
```

`--dangerously-skip-permissions` 플래그는 동등합니다.

Claude Code는 [`--restricted`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 시작한 세션에서 `bypassPermissions`를 거부합니다. `--restricted`는 Claude Code v2.1.248 이상이 필요합니다.

이 모드를 활성화하여 대화형 세션을 처음 시작할 때, Claude Code는 권한 확인 없이 수행된 작업에 대한 책임을 수락하도록 요청하는 경고 대화상자를 표시합니다:

* **수락하는 경우**: Claude Code는 `skipDangerousModePermissionPrompt`를 `~/.claude/settings.json`에서 `true`로 설정하므로 이후 세션은 대화상자를 건너뜁니다. 대화상자를 다시 보려면 해당 파일에서 키를 제거하거나 `false`로 설정하십시오. [`skipDangerousModePermissionPrompt` 참조](https://code.claude.com/docs/ko/settings-reference#skipdangerousmodepermissionprompt)는 사용자 또는 조직이 설정할 수 있는 다른 설정 파일을 나열합니다.
* **거부하는 경우**: Claude Code가 종료됩니다.

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 대화상자가 표시되지 않습니다.

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)은 수락 기록이 사용자 설정 또는 관리형 설정에 있을 때 이를 적용합니다:

* 수락 기록이 없으면 `claude --bg --permission-mode bypassPermissions`가 거부됩니다. 먼저 대화형 세션에서 대화상자를 수락하십시오.
* `skipDangerousModePermissionPrompt`가 `.claude/settings.local.json`에만 설정되어 있으면, 백그라운드 세션은 [우회 요청을 무시한 채](#bypass-permissions-ignored-in-a-background-session) 시작됩니다:

  * `--allow-dangerously-skip-permissions`가 무시된 경우, `bypassPermissions`는 해당 세션의 `Shift+Tab` 순환에서 제외됩니다.
  * `--permission-mode bypassPermissions` 또는 `--dangerously-skip-permissions`가 무시된 경우, 세션은 대신 Manual 모드로 시작됩니다.

  `~/.claude/settings.json`에 `"skipDangerousModePermissionPrompt": true`를 추가한 다음 새 백그라운드 세션을 시작하십시오.

Linux 및 macOS에서, Claude Code는 root 또는 `sudo` 권한으로 실행할 때 `bypassPermissions` 모드에서 시작하기를 거부합니다:

```text theme={null}
--dangerously-skip-permissions cannot be used with root/sudo privileges for security reasons
```

확인은 인식된 샌드박스 내에서 자동으로 건너뜁니다. 컨테이너에서 자율적으로 실행하려면, Claude Code를 비루트 사용자로 실행하는 [개발 컨테이너](https://code.claude.com/docs/ko/devcontainer.md) 구성을 사용하십시오.

[웹의 Claude Code](https://code.claude.com/docs/ko/claude-code-on-the-web.md)는 설정 파일의 `defaultMode: "bypassPermissions"` 또는 `"dontAsk"`를 적용하지 않으므로, 저장소의 체크인된 설정은 클라우드 세션을 권한 우회 모드로 시작할 수 없습니다. 설정은 자동으로 무시되고 세션은 모드 드롭다운에 표시된 권한 모드로 시작됩니다. [권한 모드 전환](#switch-permission-modes)에서 클라우드 세션이 제공하는 모드를 참조하십시오.

> [!WARNING]
>
> `bypassPermissions`는 프롬프트 주입이나 의도하지 않은 작업에 대한 보호를 제공하지 않습니다. 훨씬 적은 권한 프롬프트로 백그라운드 안전 확인을 하려면 [자동 모드](#eliminate-prompts-with-auto-mode)를 대신 사용하십시오. 관리자는 [관리 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `permissions.disableBypassPermissionsMode`를 `"disable"`로 설정하여 이 모드를 차단할 수 있습니다.

### 백그라운드 세션에서 무시된 권한 우회

이 알림은 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)이 사용자 설정 또는 관리형 설정에서 [권한 우회 경고](#bypass-permissions-acceptance)에 대한 수락 기록을 찾지 못해, 시작 시 요청된 우회를 무시했음을 의미합니다:

```text theme={null}
Bypass permissions was requested at launch and ignored · if that was you, ~/.claude/settings.json needs "skipDangerousModePermissionPrompt": true
```

`~/.claude/settings.json`에 `"skipDangerousModePermissionPrompt": true`를 추가한 다음 새 백그라운드 세션을 시작하십시오.

### `claude agents`가 대화형 세션에서는 건너뛰는 권한 우회 경고를 표시하는 경우

대화형 세션에서는 [권한 우회 경고](#bypass-permissions-acceptance)를 건너뛰는데 [`claude agents`](https://code.claude.com/docs/ko/agent-view#dispatch-defaults)가 이 경고를 표시한다면, `skipDangerousModePermissionPrompt`가 `.claude/settings.local.json` 또는 `--settings` 파일에 설정되어 있는지 확인하십시오. 대화형 세션은 해당 위치의 키를 경고 수락으로 간주하지만, `claude agents`는 그렇지 않습니다. 해당 위치에서 키를 찾았는지 여부와 관계없이, 경고를 수락하여 `claude agents`가 키를 찾는 위치인 `~/.claude/settings.json`에 키를 추가하십시오.

## 보호된 경로

`bypassPermissions` 모드와 [bypass permissions를 사용할 수 있는](#skip-all-checks-with-bypasspermissions-mode) plan 모드의 대화형 터미널 세션을 제외하고는 특정 경로에 대한 쓰기는 자동으로 승인되지 않습니다. 이는 저장소 상태와 Claude의 자체 설정이 실수로 손상되는 것을 방지합니다.

| 모드 | 보호된 경로 쓰기 |
| :- | :- |
| `default`, `acceptEdits` | 프롬프트됨 |
| `plan` | [bypass permissions를 사용할 수 있는](#skip-all-checks-with-bypasspermissions-mode) 대화형 터미널 세션에서 허용됨. 그렇지 않으면 계획 중에 [auto mode](#eliminate-prompts-with-auto-mode)를 사용할 수 있을 때 분류기로 라우팅되고, 그렇지 않으면 프롬프트됨 |
| `auto` | 분류기로 라우팅됨 |
| `dontAsk` | 거부됨 |
| `bypassPermissions` | 허용됨 |

[`--restricted`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 시작된 세션에서(Claude Code v2.1.248 이상 필요) 분류기는 보호된 경로 쓰기를 승인할 수 없습니다.

보호된 경로 쓰기를 분류기로 라우팅하는 모드에서는 [symlink check](https://code.claude.com/docs/ko/permissions.md#symlinks)가 보호된 경로로 확인하는 쓰기가 Claude가 요청한 경로 자체가 보호되지 않을 때 대신 프롬프트를 표시합니다.

설정 파일의 [`permissions.allow`](https://code.claude.com/docs/ko/permissions#manage-permissions) 규칙은 보호된 경로 쓰기를 사전에 승인하지 않습니다. 안전 확인은 Claude Code가 설정에서 allow 규칙을 평가하기 전에 실행되므로, `~/.claude/settings.json` 또는 `.claude/settings.json`의 `Edit(.claude/**)` 같은 항목은 위 표의 모드별 결과를 변경하지 않습니다. 프롬프트를 표시하는 모드에서는 프로젝트의 `.claude/` 폴더 또는 `~/.claude/`에 대한 쓰기 프롬프트가 다음 세션 범위 옵션 중 하나를 제공할 수 있습니다:

* 프로젝트의 `.claude/` 폴더의 경우: **Yes, and allow Claude to edit files in this project's .claude folder for this session**
* `~/.claude/`의 경우: **Yes, and allow Claude to edit files in its \~/.claude folder for this session**

보호된 디렉토리:

* `.git`
* `.config/git`
* `.vscode`
* `.idea`
* `.husky`
* `.cargo`
* `.devcontainer`
* `.yarn`
* `.mvn`
* `.claude`. 단, 다음과 같은 몇 가지 예외가 있습니다:
  * `.claude/worktrees/` 아래에 있는 Claude 자체 git worktree
  * `~/.claude/plans/` 또는 직접 설정한 [`plansDirectory`](https://code.claude.com/docs/ko/settings-reference#plansdirectory)에 있는 현재 세션 자체의 플랜 파일
  * `~/.claude/jobs/<id>/tmp/`에 있는 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md#where-state-is-stored) 자체의 스크래치 디렉토리
  * `--restricted` 없이 시작된 세션에서 `~/.claude/projects/<project>/memory/` 같은 프로젝트 [자동 메모리](https://code.claude.com/docs/ko/memory.md#storage-location) 디렉토리에 있는 markdown 파일
  * `--restricted` 없이 시작된 세션에서 `.claude/agent-memory/` 같은 [서브에이전트 메모리](https://code.claude.com/docs/ko/sub-agents.md#enable-persistent-memory) 디렉토리에 있는 markdown 파일
* [`--plugin-dir`](https://code.claude.com/docs/ko/plugins/mods/create#change-a-mod-with-claude)로 로드한 디렉토리. Claude Code는 파일이 변경될 때 이 디렉토리에서 mod의 코드를 다시 로드하고 실행하기 때문입니다.
* `~/.claude/dev-mods/` 또는 [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars)이 가리키는 디렉토리의 `dev-mods/`. Claude가 [사용자를 위해 작성한 mod](https://code.claude.com/docs/ko/plugins/mods/create.md#ask-claude-for-a-mod)를 저장하는 위치입니다.

보호된 파일:

* `.gitconfig`, `.gitmodules`
* `.bashrc`, `.bash_profile`, `.bash_login`, `.bash_aliases`, `.bash_logout`, `.zshrc`, `.zprofile`, `.zshenv`, `.zlogin`, `.zlogout`, `.profile`, `.envrc`
* `.npmrc`, `.yarnrc`, `.yarnrc.yml`, `.pnp.cjs`, `.pnp.loader.mjs`, `.pnpmfile.cjs`, `bunfig.toml`, `.bunfig.toml`
* `.bazelrc`, `.bazelversion`, `.bazeliskrc`
* `.pre-commit-config.yaml`, `lefthook.yml`, `lefthook.yaml`, `.lefthook.yml`, `.lefthook.yaml`
* `gradle-wrapper.properties`, `maven-wrapper.properties`
* `.devcontainer.json`
* `.ripgreprc`, `pyrightconfig.json`
* `.mcp.json`, `.claude.json`
* 세션을 시작할 때 [`--settings`](https://code.claude.com/docs/ko/cli-reference#cli-flags), `--mcp-config` 또는 `--agents`에 전달한 파일
* 사용자, 프로젝트 또는 로컬 [설정 파일](https://code.claude.com/docs/ko/settings.md#settings-files-and-who-they-affect) 자체가 심볼릭 링크일 때(예: dotfiles 저장소로 연결되는 경우) 해당 설정 파일이 가리키는 파일. 보호된 경로 쓰기를 분류기로 라우팅하는 모드에서는 allow 규칙이 일치하더라도 이 파일에 대한 쓰기는 대신 확인을 요청합니다. 파일 자체의 경로가 다른 폴더의 `.claude/settings.json`처럼 설정 파일의 경로이기도 한 경우, 해당 쓰기는 다른 보호된 경로 쓰기와 마찬가지로 분류기로 전달됩니다

## 중요 경로

Critical paths는 Claude Code가 `rm` 및 `rmdir` 명령으로부터 보호하는 디렉터리로, 파일시스템 루트, 홈 디렉터리, 작업 디렉터리 등이 있습니다. Claude Code는 이러한 명령이 실행되기 전에 확인하며, 대상을 critical path로 인식한 명령은 어떤 [allow 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)으로도 승인되지 않습니다. 이 확인은 일부 명령을 놓칠 수 있으므로 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)과 같은 운영 체제 수준의 제어를 대체하지 않습니다.

Critical-path 제거란 Claude Code가 대상을 critical path로 인식하는 `rm` 또는 `rmdir` 명령입니다. `"allow"`를 반환하는 [`PreToolUse` 훅](https://code.claude.com/docs/ko/permissions#extend-permissions-with-hooks)도 이를 승인하지 않습니다. 다른 프롬프트를 건너뛰는 권한 모드에서도 allow 규칙이나 `PreToolUse` 훅은 이를 승인할 수 없습니다.

> [!WARNING]
>
> 확인이 놓친 명령은 특별한 처리를 받지 않으므로, 세션에서 Bash 명령을 승인하는 모든 수단이 프롬프트 없이 이를 승인할 수 있습니다. 여기에는 allow 규칙, `bypassPermissions` 모드, 샌드박스의 [auto-allow mode](https://code.claude.com/docs/ko/sandboxing.md#auto-allow-mode)가 포함됩니다. 이 확인은 `rm`과 `rmdir`에 적용되므로, 승인된 다른 명령도 critical path를 삭제할 수 있습니다.

다음 제어는 확인이 명령을 인식하는지 여부와 관계없이 적용됩니다:

* **Deny 규칙**: 명령과 일치하는 [deny 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)은 명령을 차단합니다. 단, 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 여전히 [그러한 호출 중 일부](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)를 승인할 수 있습니다
* **샌드박싱**: [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)은 운영 체제가 Bash 명령이 쓸 수 있는 경로를 제한하도록 합니다. 샌드박스 처리된 명령도 작업 디렉터리는 삭제할 수 있습니다
* **Strict sandbox mode**: 기본적으로 샌드박스 처리된 명령은 [샌드박스 외부에서 재시도](https://code.claude.com/docs/ko/sandboxing.md#the-unsandboxed-retry-escape-hatch)될 수 있으며, allow 규칙이나 `bypassPermissions` 모드가 프롬프트 없이 이 재시도를 승인할 수 있습니다. [Strict sandbox mode](https://code.claude.com/docs/ko/sandboxing.md#turn-off-the-retry-with-strict-sandbox-mode)는 이 재시도를 끕니다

Claude Code가 인식한 제거가 어떻게 처리되는지는 [권한 모드에 따라 달라집니다](#critical-path-removals-in-each-permission-mode). `Remove-Item` 및 `cmd` 제거 내장 명령은 자체 확인을 가지고 있으며, [PowerShell의 Remove-Item](#remove-item-in-powershell)에서 다룹니다.

### 중요 경로에 해당하는 경로

Claude Code는 `rm` 또는 `rmdir` 대상을 다음 중 하나일 때 critical path로 취급합니다:

* 파일시스템 루트
* 최상위 디렉토리, 즉 루트의 직접 자식(예: `/usr`, `/etc`, `/data`)
* 홈 디렉터리. Windows에서는 8.3 짧은 이름도 해당합니다(예: `C:\Users\LONGNA~1`)
* Windows 드라이브 루트 및 최상위 디렉터리(예: `C:\` 및 `C:\Windows`). `\\?\C:\` 및 `\\localhost\C$`와 같은 표기는 `C:\`로 간주됩니다
* 작업 디렉토리 및 부모
* 추가 작업 디렉토리 및 부모, 단 제거가 하나 아래의 glob일 때만(예: `rm -rf <dir>/*`). `rm -rf <dir>`은 디렉토리 자체에서 이 확인을 트리거하지 않습니다

`/mnt/c` 또는 `/Volumes/USB`와 같은 마운트된 드라이브 경로에 대해서는 [마운트된 드라이브 프롬프트](#the-mounted-drive-prompt)를 참조하십시오.

홈 디렉터리의 8.3 짧은 이름과 `\\?\C:\` 및 `\\localhost\C$` 표기에 대한 확인에는 Claude Code v2.1.292 이상이 필요합니다.

### 중요 경로로 간주되는 다른 대상

Claude Code는 또한 다음 `rm` 및 `rmdir` 대상을 critical paths로 취급합니다. 마지막 열은 각각이 계산되는 이유를 설명합니다.

| Target | Example | Why it counts |
| :- | :- | :- |
| 셸 변수 직접 아래의 glob 또는 후행 슬래시 | `rm -rf "$DIR"/*` | 변수가 비어 있으면 명령이 파일시스템 루트에서 제거가 됩니다 |
| `$1` 또는 `$@`와 같은 위치 매개변수 아래의 동일한 형식, 명령에서 값을 제공하는 것이 없을 때 | `rm -rf "$1"/*` | 명령이 루트에서 제거로 확장됩니다 |
| 셸 변수 다음에 하나의 일반적인 최상위 디렉토리 이름(예: `mnt`, `tmp`, `usr`, `Users`) | `rm -rf "$TMPDIR/mnt"` | 변수가 비어 있으면 명령이 `/mnt`를 제거합니다 |
| 같은 명령이 디렉토리 출력 치환(예: `$(pwd)` 또는 `$(git rev-parse --show-toplevel)`)에서 할당하는 변수 | `D=$(pwd); rm -rf "$D"` | 값은 작업 디렉토리 또는 저장소 루트의 이름을 지정할 수 있습니다 |
| 명령 치환의 출력만인 대상, `rm`이 recursive일 때 | `rm -rf "$(pwd)"` | Claude Code는 명령이 실행되기 전에 대상을 확인할 수 없습니다 |
| critical path 다음의 후행 명령 치환 | `rm -rf ~/$(cmd)` | Claude Code는 치환이 비어 있으면 남아 있을 경로(여기서는 홈 디렉토리)를 확인합니다 |
| 백슬래시만 있는 대상 | `rm -rf "\\"` | Windows의 Git Bash는 단일 백슬래시를 현재 드라이브의 루트로 읽으므로 확인이 모든 플랫폼에 적용됩니다 |
| 드라이브 문자 대신 GUID로 볼륨을 지정하는 Windows 경로 | `rm -rf '\\?\Volume{GUID}\work\build'` | 경로가 어느 드라이브에 있는지 나타내지 않으므로 critical path일 수 있습니다. Claude Code v2.1.292 이상이 필요합니다 |
| `/*` 또는 `/*/`로 끝나는 일부 대상 | `rm -rf logs/*/*`, `rm -rf logs/*/`, `cd logs && rm -rf a/*` | Claude Code는 명령이 실행되기 전에 이러한 대상이 어떤 디렉터리에 도달하는지 알 수 없습니다 |

명령 치환 출력만인 대상에 대한 확인을 끄려면 Claude Code를 시작하는 환경에서 [`CLAUDE_CODE_DISABLE_SUBSTITUTION_RM_PROMPT=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정합니다.

### 중첩된 명령 및 인라인 스크립트 내부의 제거

Claude Code는 또한 이러한 구성 내부를 살펴봅니다:

* **Nested commands**: `(...)`를 사용한 서브셸, `{ ...; }`를 사용한 brace group, `$(...)` 또는 백틱을 사용한 명령 치환, 또는 `<(...)`를 사용한 프로세스 치환. Claude Code는 `(rm -rf ~)` 또는 `echo "$(rm -rf ~)"`처럼 중첩된 형식 내부에 있든 같은 명령의 다른 곳에 있든 critical-path 제거를 찾습니다.
* **Inline scripts**: `bash -c 'rm -rf ~'`처럼 `-c`와 함께 `sh`, `bash`, `zsh` 또는 유사한 POSIX 셸에 전달된 스크립트.
  * 스크립트가 이중 인용되면 호출하는 셸이 내부 셸이 스크립트를 받기 전에 변수를 확장합니다. `find . -name '*.tmp' -exec sh -c "rm -rf \"$1\"/*" _ {} \;`에서 명령은 일치마다 한 번씩 파일시스템 루트에서 제거로 확장되고, Claude Code는 이를 critical-path 제거로 취급합니다.
  * `sh -c 'rm -rf "$1"/*' _ {}`처럼 `$1`을 실제 값에 바인딩하는 단일 인용 스크립트는 플래그되지 않습니다.

`~`처럼 `-c` 스크립트에 직접 입력된 critical path에 대한 확인을 끄려면 Claude Code를 시작하는 환경에서 [`CLAUDE_CODE_DISABLE_INLINE_SHELL_RM_PROMPT=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정합니다.

### 플래그된 명령 다시 작성

명령을 다시 작성하여 확인을 통과하는 방법은 사용하는 [다른 대상](#other-targets-that-count-as-critical-paths)에 따라 달라집니다:

* **`$DIR`과 같은 변수 아래의 glob 또는 후행 슬래시**: 각 확장을 보호하여 변수가 설정되지 않았거나 비어 있을 때 셸이 오류로 중지되도록 합니다(예: `rm -rf "${DIR:?}"/*`). 또는 리터럴 경로를 사용합니다. 이러한 방식으로 모든 확장이 보호되는 제거는 이 확인을 통과하므로 `bypassPermissions` mode에서는 다른 [중요 경로](#critical-paths) 확인이 플래그하지 않는 한 프롬프트 없이 실행됩니다.
* **`$HOME`과 같이 일반적으로 설정되는 변수 아래의 glob 또는 후행 슬래시**: 리터럴 경로를 사용합니다.
* **디렉토리 출력 치환에서 할당된 변수**: 리터럴 경로를 사용합니다. `"${D:?}"` 보호는 이 확인을 통과하지 않습니다. 변수가 비어 있지 않기 때문입니다.
* **명령 치환의 출력만인 대상**: 치환을 먼저 자체적으로 실행한 다음 인쇄하는 리터럴 경로를 제거합니다. 프롬프트는 Claude에게 동일하게 수행하도록 알려줍니다.

변수 아래의 glob 또는 후행 슬래시의 경우 프롬프트는 플래그된 `rm`의 이름을 지정하고 확인을 통과하도록 다시 작성하는 방법을 설명합니다.

### `Dangerous rm operation not ruled out` 프롬프트

전체 이유는 다음과 같습니다:

```text theme={null}
Dangerous rm operation not ruled out — the shell may read this command differently than it was parsed
```

이 이유는 셸이 Claude Code와 다르게 명령을 읽을 수 있다는 뜻이므로, `rm`이 없더라도 확인되지 않은 부분에 제거가 들어 있을 수 있습니다. `auto` 또는 `bypassPermissions` 모드에서 다음 문장이 포함된 거부도 같은 확인에서 비롯됩니다:

```text theme={null}
This command could not be checked for dangerous rm operations: the shell may read it differently than it was parsed.
```

[권한 모드에서](#critical-path-removals-in-each-permission-mode) critical-path 제거에 표시되는 것과 같은 프롬프트 또는 거부가 표시되며, `bypassPermissions`도 마찬가지입니다. 단, `bypassPermissions` 모드에서는 [이 프롬프트를 끌 수 있습니다](#turn-off-the-critical-path-removal-prompt-in-bypasspermissions-mode). `Bash` 또는 `Bash(*)` allow 규칙, 샌드박스 [auto-allow mode](https://code.claude.com/docs/ko/sandboxing.md#auto-allow-mode), `"allow"`를 반환하는 `PreToolUse` 훅으로는 이 명령을 승인할 수 없습니다. 명령을 읽은 다음 프롬프트를 승인하거나, 거부된 후에는 셸에서 직접 실행합니다.

### 마운트된 드라이브 프롬프트

마운트된 드라이브 프롬프트는 macOS, Linux, WSL에서 recursive `rm`이 `/mnt/c` 또는 `/Volumes/USB/build`와 같이 목록에 있는 [마운트된 드라이브 경로](#paths-that-get-the-mounted-drive-prompt)를 대상으로 할 때 표시됩니다. 이 프롬프트의 이유는 `Dangerous rm operation on mounted drive path: <path>`로 표시됩니다. `/*` 대상은 recursive 플래그 없이도 프롬프트가 표시됩니다. Claude Code는 `rm /Volumes/USB/build/*`를 `/Volumes/USB/build`의 제거로 읽기 때문입니다.

`rm`에 대한 allow 규칙이 있더라도 Claude Code는 이 명령을 [중요 경로 제거](#critical-paths)로 처리하며, [권한 모드에 따라](#critical-path-removals-in-each-permission-mode) 프롬프트를 표시하거나 거부합니다. 프롬프트를 승인하여 `rm`을 실행하거나, [프롬프트를 끌 수 있습니다](#turn-off-the-mounted-drive-prompt).

#### 마운트된 드라이브 프롬프트가 표시되는 경로

recursive `rm` 또는 `/*` 제거의 대상을 다음 경로 형태와 대조합니다. 여기서 `<drive>` 또는 `<name>`과 같은 각 자리 표시자는 정확히 하나의 경로 세그먼트를 나타냅니다:

| 상위 경로 | 프롬프트가 표시되는 경로 형태 | 예시 |
| :- | :- | :- |
| `/Volumes` | `/Volumes/<drive>`, `/Volumes/<drive>/<name>` | `/Volumes/USB`, `/Volumes/USB/build` |
| `/System/Volumes` | `/System/Volumes`, `/System/Volumes/<volume>`, `/System/Volumes/<volume>/<name>` | `/System/Volumes/Data` |
| `/media` | `/media/<user>`, `/media/<user>/<drive>`, `/media/<user>/<drive>/<name>` | `/media/alex` |
| `/run/media` | `/run/media`, `/run/media/<user>`, `/run/media/<user>/<drive>`, `/run/media/<user>/<drive>/<name>` | `/run/media/alex/USB/build` |
| `/mnt` | `/mnt/<name>`, 그리고 WSL의 `/mnt/c`와 같은 한 글자 마운트 아래의 `/mnt/<letter>/<name>` | `/mnt/data`, `/mnt/c/Users` |

`/Volumes`, `/media` 또는 `/mnt` 자체에 대한 recursive 또는 non-recursive `rm`의 경우에는 대신 [중요 경로](#which-paths-are-critical) 이유인 `Dangerous rm operation on critical path: <path>`가 표시됩니다.

상대 경로 대상은 작업 디렉터리를 기준으로 계산되므로, `/Volumes/USB`에서 작업하는 동안 `rm -rf build`를 실행하면 `/Volumes/USB/build`를 대상으로 하게 되어 프롬프트가 표시됩니다.

#### 마운트된 드라이브 프롬프트 끄기

[다른 원인으로 인한 프롬프트](#removals-that-still-prompt-with-the-mounted-drive-prompt-off)는 유지하면서 마운트된 드라이브 프롬프트만 표시되지 않도록 하려면, 환경에 [`CLAUDE_CODE_DISABLE_MOUNTED_DRIVE_RM_PROMPT=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정한 상태로 Claude Code를 시작합니다. 예를 들어 [셸](https://code.claude.com/docs/ko/env-vars.md#set-variables-in-your-shell)에서 변수를 설정하고 그 셸에서 `claude`를 시작합니다:

```bash theme={null}
export CLAUDE_CODE_DISABLE_MOUNTED_DRIVE_RM_PROMPT=1
claude
```

이렇게 시작한 세션에서는 `/Volumes/USB`와 같은 드라이브 전체와 다른 [목록에 있는 경로](#paths-that-get-the-mounted-drive-prompt)에 대해 마운트된 드라이브 프롬프트가 더 이상 표시되지 않습니다. `Bash(rm *)`를 허용하고 Manual mode를 사용하며 `/Volumes/USB`에서 작업하는 경우, `rm -rf build`는 프롬프트 없이 실행됩니다.

여전히 `Dangerous rm operation on mounted drive path`가 표시되는 프롬프트가 나타난다면 변수가 세션에 전달되지 않은 것입니다:

* **설정 파일의 변수**: Claude Code는 설정 파일의 종류와 관계없이 [설정 파일의 `env` 블록에 있는 변수를 무시](https://code.claude.com/docs/ko/settings-reference#variables-claude-code-ignores-in-env)하므로, 대신 `claude`를 시작하는 곳에서 변수를 설정합니다
* **변수 없이 시작된 세션**: 실행 중인 세션은 변수를 반영하지 않으므로, 변수가 설정된 환경에서 `claude`를 다시 시작합니다

#### 마운트된 드라이브 프롬프트를 꺼도 여전히 프롬프트가 표시되는 제거

`rm`에 대한 allow 규칙이 있는 Manual mode에서는 마운트된 드라이브 경로에 대한 `rm`이 `Dangerous rm operation on mounted drive path` 이유 없이 여전히 프롬프트를 표시할 수 있습니다:

* **작업 디렉터리 외부의 대상**: `/Volumes/USB/project`에서 작업하는 동안 `rm -rf /Volumes/USB/other`를 실행하면 프롬프트가 표시됩니다. 이 프롬프트를 없애려면 [대상을 포함하는 디렉터리를 세션에 추가](https://code.claude.com/docs/ko/permissions.md#working-directories)합니다
* **`*`가 포함된 대상**: `rm -rf build/*`는 프롬프트가 표시됩니다. 프롬프트를 승인하여 명령을 실행하거나, Claude에게 `*` 없이 각 대상을 지정하도록 요청합니다
* **중요 경로인 대상**: `/mnt` 자체와 작업 디렉터리 자체는 여전히 [중요 경로](#which-paths-are-critical)이므로, 둘 중 하나에 대한 `rm -rf`는 프롬프트가 표시됩니다. 프롬프트를 승인하여 `rm`을 실행합니다

### 권한 모드별 중요 경로 제거

Claude Code가 critical-path 제거로 수행하는 작업은 권한 모드에 따라 달라집니다:

| Mode | Outcome |
| :- | :- |
| `default`, `acceptEdits` | 승인을 요청합니다 |
| `plan` | 승인을 요청합니다. [계획 중에 분류기가 명령을 검토할 때](#analyze-before-you-edit-with-plan-mode) bypass permissions를 사용할 수 없으면 `auto` mode처럼 처리합니다 |
| `auto` | 터미널에서 [시간 제한](#time-limits-and-denials-in-auto-and-bypasspermissions-modes)과 함께 승인을 요청합니다. 다른 곳에서는 거부합니다 |
| `dontAsk` | 거부합니다 |
| `bypassPermissions` | 터미널에서는 시간 제한이 끝나기 전에 승인을 요청합니다. 다른 곳에서는 [각 위치에서의 동작](#time-limits-and-denials-in-auto-and-bypasspermissions-modes)을 참조하십시오 |

명시적 [ask 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)이 명령과 일치하면 Claude Code는 `auto` mode에서도 승인을 요청합니다. 시간 제한 없이 요청합니다. 승인을 요청하는 모드에서 [`PermissionRequest` hook](https://code.claude.com/docs/ko/hooks#permissionrequest)은 프롬프트에 답할 수 있습니다.

`bypassPermissions` 모드에서 이러한 제거를 프롬프트 없이 실행하려면 [중요 경로 제거 프롬프트 끄기](#turn-off-the-critical-path-removal-prompt-in-bypasspermissions-mode)를 참조하십시오.

### 자동 모드 및 bypassPermissions 모드의 시간 제한과 거부

`auto` 및 `bypassPermissions` mode에서 critical-path 제거에 대한 터미널 프롬프트는 2분 카운트다운을 표시합니다:

* 답변하기 전에 카운트다운이 끝나면 Claude Code는 명령을 거부하고 Claude에게 대신 수행할 작업을 알려주므로 무인 세션이 계속 작동합니다.
* 프롬프트가 열려 있는 동안 아무 키나 누르면 카운트다운이 중지되고 프롬프트는 답변을 기다립니다.
* 세션에서 이러한 프롬프트 3개가 답변 없이 끝나면 Claude Code는 더 이상 표시하지 않고 critical-path 제거를 즉시 거부합니다. 새 메시지를 보내면 카운트가 다시 시작됩니다.

시간 제한은 Claude Code v2.1.281 이상에서 적용되며, 터미널 외부에서의 `auto` mode 거부도 마찬가지입니다.

터미널 외부에서는 이 프롬프트가 표시되지 않습니다:

| 위치 | `auto` | `bypassPermissions` |
| :- | :- | :- |
| [VS Code 확장](https://code.claude.com/docs/ko/vs-code.md)의 채팅 패널 | 거부합니다 | [`PermissionRequest` 훅](https://code.claude.com/docs/ko/hooks#permissionrequest)이 허용하지 않는 한 거부합니다 |
| [Desktop 앱](https://code.claude.com/docs/ko/desktop.md) | 거부합니다 | `PermissionRequest` 훅이 허용하지 않는 한 거부합니다 |
| [`-p` 실행](https://code.claude.com/docs/ko/headless) 또는 [Agent SDK 세션](https://code.claude.com/docs/ko/agent-sdk/permissions.md) | 거부합니다 | [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 또는 [`canUseTool` 콜백](https://code.claude.com/docs/ko/agent-sdk/user-input#handle-tool-approval-requests)이 결정합니다. 둘 다 없거나 [`--permission-prompts none`](https://code.claude.com/docs/ko/headless#turn-off-permission-prompts-in-unattended-runs)을 사용하는 경우에는 `PermissionRequest` 훅이 허용하지 않는 한 거부합니다. 대신 이러한 제거를 프롬프트 없이 실행하려면 [중요 경로 제거 프롬프트 끄기](#turn-off-the-critical-path-removal-prompt-in-bypasspermissions-mode)를 참조하십시오 |

제거가 거부된 곳 어디에서든 전체 명령을 읽고 셸에서 직접 실행할 수 있습니다.

각 모드에서의 동작을 변경하려면 [`CLAUDE_CODE_DISABLE_DANGEROUS_RM_TIMEOUT`](https://code.claude.com/docs/ko/env-vars#variables)을 `1`로 설정합니다:

* **`bypassPermissions`**: 터미널 프롬프트에 시간 제한이 없으며, VS Code 채팅 패널에서는 승인을 요청합니다
* **`auto`**: 터미널, VS Code 채팅 패널, `-p` 실행 및 Agent SDK 세션에서 [분류기](#eliminate-prompts-with-auto-mode)가 결정합니다

Claude Code 설정 파일이 아니라, 셸이나 SDK의 `env` 옵션처럼 Claude Code를 시작하는 환경에서 설정합니다. 채팅 패널의 경우 VS Code 자체의 사용자 `settings.json`에 있는 [`claudeCode.environmentVariables`](https://code.claude.com/docs/ko/vs-code#extension-settings)에 추가한 다음 새 대화를 시작합니다:

```json theme={null}
{
  "claudeCode.environmentVariables": [
    { "name": "CLAUDE_CODE_DISABLE_DANGEROUS_RM_TIMEOUT", "value": "1" }
  ]
}
```

### bypassPermissions 모드에서 중요 경로 제거 프롬프트 끄기

`bypassPermissions` 모드에서 [중요 경로](#critical-paths)를 대상으로 하는 Bash `rm` 및 `rmdir` 명령을 프롬프트 없이 실행하려면, 환경에 [`CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정한 상태로 Claude Code를 시작합니다. 이를 위해서는 Claude Code v2.1.311 이상이 필요합니다. Claude Code는 시작 환경에서만 이 변수를 읽으며 [설정 파일의 `env` 블록에 있는 이 변수는 무시합니다](https://code.claude.com/docs/ko/settings-reference#variables-claude-code-ignores-in-env). 예를 들어 [셸](https://code.claude.com/docs/ko/env-vars.md#set-variables-in-your-shell)에서 변수를 설정하고 그 셸에서 `claude`를 시작합니다:

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> export CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS=1
> claude --permission-mode bypassPermissions
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> $env:CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS = "1"
> claude --permission-mode bypassPermissions
> ```

> [tab] Windows CMD
>
> ```batch theme={null}
> set CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS=1
> claude --permission-mode bypassPermissions
> ```

> [!WARNING]
>
> 이 변수를 설정하면 파괴적인 삭제에 대한 안전 프롬프트가 사라집니다. `rm -rf ~`와 같은 명령이 확인 없이 실행될 수 있습니다. 내용을 잃어도 괜찮은 [격리된 환경](#skip-all-checks-with-bypasspermissions-mode)에서만 설정하십시오.

제거가 프롬프트 없이 실행되는 것은 플랜 모드가 아닌 `bypassPermissions` 모드 자체에서만이며, Bash 및 [Monitor](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 도구에서 critical-path 확인이 플래그한 항목에만 해당합니다. 여기에는 Claude Code가 완전히 파싱할 수 없는 명령도 포함되며, 이러한 명령도 프롬프트 없이 실행됩니다.

#### 중요 경로 제거 프롬프트에 대한 시작 알림

`CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS`가 작동하는지 확인하려면 Claude Code가 시작 시 출력하는 줄을 읽습니다. `-p` 실행에서는 stderr에 출력됩니다. Agent SDK 앱에서는 [`stderr` 옵션](https://code.claude.com/docs/ko/agent-sdk/typescript#options)을 전달하여 읽습니다. 이 줄은 다음 중 하나를 나타냅니다:

* **`is set, so dangerous rm commands can run without a prompt`**: 관리형 설정과 플러그인 훅이 로드되면 제거가 프롬프트 없이 실행될 수 있습니다. 제거에 계속 프롬프트가 표시되거나 거부된다면 [중요 경로 제거 프롬프트가 꺼지지 않는 이유](#why-the-critical-path-removal-prompt-stays-on)를 참조하십시오
* **`has no effect in this session`**: 세션 전체에서 제거에 평소의 프롬프트 또는 거부가 유지됩니다. 이를 변경하려면 [중요 경로 제거 프롬프트가 꺼지지 않는 이유](#why-the-critical-path-removal-prompt-stays-on)에서 해당하는 경우를 찾으십시오
* **`has no effect while the Windows registry cannot be read for managed settings`**: 제거에 평소의 프롬프트 또는 거부가 유지되며, 이후 레지스트리 읽기에 성공하면 재시작 없이 변수가 적용됩니다. 제거에 계속 프롬프트가 표시되거나 거부된다면 [중요 경로 제거 프롬프트가 꺼지지 않는 이유](#why-the-critical-path-removal-prompt-stays-on)를 참조하십시오

줄이 없다고 해서 프롬프트가 켜져 있다는 뜻은 아닙니다. `stderr` 옵션이 없는 Agent SDK 앱에서는 줄이 표시되지 않지만, 제거는 여전히 프롬프트 없이 실행될 수 있습니다. 그 외의 경우에는 시작 환경에서 변수를 설정했는지, 세션이 [`bypassPermissions` 모드로 전환할 수 있는지](#skip-all-checks-with-bypasspermissions-mode), `claude`가 다른 세션 내부에서 실행되고 있지 않은지 확인합니다. 일부 세션은 [변수 없이 시작됩니다](#why-the-critical-path-removal-prompt-stays-on).

변수를 설정하지 않았는데 이러한 줄 중 하나가 표시된다면 셸 프로필 등 변수가 설정된 곳을 찾아 제거합니다.

#### 중요 경로 제거 프롬프트가 꺼지지 않는 이유

`CLAUDE_CODE_EVEN_MORE_DANGEROUSLY_SKIP_PERMISSIONS`가 효과가 없고 제거에 [평소의 프롬프트 또는 거부](#critical-path-removals-in-each-permission-mode)가 유지된다면, 다음과 같은 원인을 확인합니다:

* **다른 무언가가 권한 프롬프트를 처리하는 경우**: [`--permission-prompts none`](https://code.claude.com/docs/ko/headless#turn-off-permission-prompts-in-unattended-runs) 없이 사용하는 [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 또는 Agent SDK [`canUseTool` 콜백](https://code.claude.com/docs/ko/agent-sdk/user-input), matcher와 관계없는 [`PermissionRequest` 훅](https://code.claude.com/docs/ko/hooks#permissionrequest), 또는 해당 이벤트를 처리하는 [mod](https://code.claude.com/docs/ko/plugins/mods/events.md#hook-the-settings-hook-events)가 원인입니다. 훅, mod, 도구 또는 콜백을 제거하고 `claude`를 다시 시작합니다
* **[VS Code 확장](https://code.claude.com/docs/ko/vs-code.md)의 채팅 패널 또는 [Desktop 앱](https://code.claude.com/docs/ko/desktop.md)이 세션을 실행하는 경우**: 대신 IDE의 통합 터미널과 같은 터미널에서 `claude`를 시작합니다
* **Bash, Edit 또는 Read를 대상으로 하는 규칙이 있는 경우**: 시작 시 또는 세션 중에 Claude Code가 읽은, 이러한 도구 중 하나를 대상으로 하는 [deny 또는 ask 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)이 원인이며, 나중에 제거하더라도 마찬가지입니다. 규칙을 제거하고 `claude`를 다시 시작합니다. 도구를 제외하려면 deny 규칙 대신 [`--tools`](https://code.claude.com/docs/ko/cli-reference#cli-flags)를 사용합니다
* **[`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)가 켜져 있는 경우**: 이를 `true`로 설정하는 모든 설정 파일에서 해당 설정을 제거한 다음 `claude`를 다시 시작합니다
* **`claude`가 다른 세션 내부에서 실행되는 경우**: 세션의 Bash 도구나 훅에서 시작된 `claude`가 해당하며, 명령줄에 변수가 있더라도 마찬가지입니다. 자신의 셸에서 `claude`를 시작합니다. 이 중첩 세션 제한을 보안 경계로 의존하지 마십시오
* **`PreToolUse` 훅이 제거에 대해 `ask`로 응답하는 경우**: 훅이 반환하는 값을 변경합니다
* **Claude Code가 대신 세션을 시작하는 경우**: [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md), 분할 창의 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 팀원, [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 서버가 생성하는 세션은 변수 없이 시작됩니다. 자신의 셸에서 `claude`를 시작합니다
* **관리형 설정을 읽을 수 없는 경우**: Claude Code가 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md) 소스를 성공적으로 읽지 못했습니다. 서버 관리형 설정이 계속 로드되지 않는다면 [Remote managed settings failed to load](https://code.claude.com/docs/ko/errors.md#remote-managed-settings-failed-to-load)를 참조하십시오. 레지스트리 쿼리가 아닌 다른 실패의 경우 해당 소스를 관리하는 담당자에게 수정을 요청합니다
* **Windows 레지스트리를 쿼리할 수 없는 경우**: Windows 및 WSL에서는 [WSL이 설정에 레지스트리를 사용하지 않는 경우](https://code.claude.com/docs/ko/settings-reference.md#wslinheritswindowssettings)에도 이 변수에 레지스트리의 응답이 필요합니다. 영어가 아닌 Windows, interop이 꺼진 WSL, 또는 WSL2 커널의 컨테이너에서는 세션 내내 쿼리가 실패할 수 있습니다. interop이 꺼져 있다면 켭니다. 그렇지 않다면 해당 제거를 직접 실행합니다

### PowerShell의 Remove-Item

[PowerShell tool](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool)을 활성화하면 Claude Code는 `Remove-Item`과 `cmd` 내장 명령 `rd`, `rmdir`, `del`, `erase`에 `rm` critical-path 목록과 별개의 자체 확인을 제공합니다. `Remove-Item`의 경우 결과는 대상에 따라 달라지며 첫 번째 일치하는 경우가 적용됩니다:

* **System paths**: 파일시스템 루트 및 최상위 디렉토리, 드라이브 루트 및 최상위 디렉토리, 홈 디렉토리. Claude Code는 모든 모드에서 묻지 않고 명령을 거부합니다.
* **Wildcards**: bare `*`, 또는 `/*` 또는 `\*`로 끝나는 모든 대상(예: `$dir/*`과 같은 셸 변수 아래의 glob). Claude Code는 [분류기](#eliminate-prompts-with-auto-mode)가 보기 전에 모든 모드에서 묻지 않고 명령을 거부합니다.
* **작업 디렉토리 또는 부모, `-Recurse` 포함**: Claude Code는 다른 승인이 필요한 명령처럼 명령을 취급하므로 승인을 요청하는 모드에서 묻고, `auto` mode에서 분류기로 보내고, `dontAsk` mode에서 거부합니다. `bypassPermissions` mode는 이 확인을 건너뜁니다.

system-paths 경우는 Claude가 `cmd /c rd /s /q C:\Users`와 같이 `cmd`를 통해 실행할 때 `rd`, `rmdir`, `del`, `erase`에도 적용됩니다. 기본적으로 Claude Code는 모든 모드에서 묻지 않고 이러한 명령을 거부합니다. 이 `cmd` 확인에는 Claude Code v2.1.283 이상이 필요합니다.

`cmd` 대상을 판단할 때 Claude Code는 리터럴 텍스트 다음에 오는 PowerShell 변수를 비어 있는 것으로 취급합니다. 이는 `cmd /c rd /s /q "C:\$name"`을 `C:\`의 제거로 만들므로 역시 거부됩니다. 후행 와일드카드는 비우는 폴더로 계산되므로 `cmd /c del /q C:\*`는 거부되고 프로젝트의 `cmd /c del /q dist\*`는 거부되지 않습니다.

`cmd` 확인을 끄려면 Claude Code를 시작하는 환경에서 [`CLAUDE_CODE_DISABLE_POWERSHELL_CMD_RM_DENY=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정합니다. Claude Code는 설정 파일의 `env` 블록에서 이 변수를 무시합니다. system path의 `Remove-Item`은 어느 쪽이든 거부된 상태로 유지됩니다.

## 참고 항목

* [권한](https://code.claude.com/docs/ko/permissions.md): allow, ask, deny 규칙; 관리형 정책
* [auto mode 구성](https://code.claude.com/docs/ko/auto-mode-config.md): 분류기에 조직이 신뢰하는 인프라를 알립니다.
* [Hooks](https://code.claude.com/docs/ko/hooks.md): `PreToolUse` 및 `PermissionRequest` hooks를 통한 사용자 정의 권한 로직
* [보안](https://code.claude.com/docs/ko/security.md): safeguards 및 모범 사례
* [Sandboxing](https://code.claude.com/docs/ko/sandboxing.md): Bash 명령어에 대한 파일시스템 및 네트워크 격리
* [비대화형 모드](https://code.claude.com/docs/ko/headless.md): `-p` 플래그를 사용하여 Claude Code 실행
