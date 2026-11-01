> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 권한 구성

> 권한 모드, 훅, 선언적 허용/거부 규칙을 사용하여 에이전트가 도구를 사용하는 방식을 제어합니다.

Claude Agent SDK는 Claude가 도구를 사용하는 방식을 관리하기 위한 권한 제어를 제공합니다. 권한 모드와 규칙을 사용하여 자동으로 허용되는 항목을 정의하고, [`canUseTool` 콜백](https://code.claude.com/docs/ko/agent-sdk/user-input)을 사용하여 런타임에 다른 모든 항목을 처리합니다.

## 권한이 평가되는 방식

> [!NOTE]
>
> [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)가 포함된 플러그인을 로드하는 경우 [규칙과 훅 사이에서 mod의 결정이 차지하는 위치](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)를 참조하세요.

Claude가 도구를 요청할 때 SDK는 다음 순서로 권한을 확인합니다.

**1. Hooks**

먼저 [hooks](https://code.claude.com/docs/ko/agent-sdk/hooks.md)를 실행합니다. 훅은 호출을 완전히 거부하거나 통과시킬 수 있습니다. `allow`를 반환하는 훅은 아래의 거부 및 확인 규칙을 건너뛰지 않습니다. 이러한 규칙은 훅 결과와 관계없이 평가됩니다.

또한 `allow`를 반환하는 `PreToolUse` 훅은 `rm -rf ~`처럼 Claude Code가 [중요 경로](https://code.claude.com/docs/ko/permission-modes.md#critical-paths)로 인식하는 대상에 대한 `rm` 또는 `rmdir` 명령을 승인할 수 없습니다. 플랜 모드에서 해당 `allow`가 어떻게 작동하는지는 [플랜 모드의 훅 승인](https://code.claude.com/docs/ko/permissions.md#hook-approvals-in-plan-mode)을 참조하세요.

**2. 거부 규칙**

`disallowed_tools` 또는 [settings.json](https://code.claude.com/docs/ko/settings-reference.md#permission-settings)의 거부 규칙이 일치하면 [`bypassPermissions`](#bypass-permissions-mode-bypasspermissions) 모드에서도, 훅이 `allow`를 반환한 경우에도 호출이 거부되며 [`canUseTool`](https://code.claude.com/docs/ko/agent-sdk/user-input)은 호출되지 않습니다.

TypeScript SDK에서 [사용자 정의 도구](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md#require-approval-for-specific-tools)의 `permission_policy`를 [`always_deny`](https://code.claude.com/docs/ko/agent-sdk/typescript#mcpservertoolpolicy)로 설정하면 해당 도구에 대한 호출은 이 단계에서 거부됩니다.

**3. 확인 규칙**

[settings.json](https://code.claude.com/docs/ko/settings-reference.md#permission-settings)에서 `ask` 규칙을 확인합니다. ask 규칙이 일치하면 `bypassPermissions` 모드에서도 호출이 확인을 위해 [`canUseTool` 콜백](https://code.claude.com/docs/ko/agent-sdk/user-input)으로 전달됩니다.

사용자 상호작용이 필요한 도구는 동일하게 작동합니다. `AskUserQuestion` 및 서버가 [`_meta["anthropic/requiresUserInteraction"]`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)을 설정하는 MCP 도구는 allow 규칙이 일치할 때도 항상 콜백으로 전달됩니다. `dontAsk` 모드에서는 이 모드가 절대 프롬프트하지 않기 때문에 두 경우 모두 거부됩니다. MCP 주석에는 Claude Code v2.1.199 이상이 필요합니다.

조직이 `ask`로 설정한 [claude.ai connector](https://code.claude.com/docs/ko/mcp.md#organization-controls-on-connector-tools) 도구도 이 단계에서 흐름을 떠납니다. 모든 호출은 `bypassPermissions` 모드에서도, allow 규칙이 일치할 때도 콜백으로 전달됩니다. 콜백은 `Your organization requires approval for this tool` 이유를 받습니다. `dontAsk` 모드에서는 이 모드가 절대 프롬프트하지 않기 때문에 호출이 거부됩니다.

TypeScript SDK에서 사용자 정의 도구의 `permission_policy`를 [`always_ask`](https://code.claude.com/docs/ko/agent-sdk/custom-tools#require-approval-for-specific-tools)로 설정하면 어떤 allow 규칙도, 심지어 `allowedTools` 항목도 해당 도구의 호출을 승인하지 않습니다. `dontAsk` 모드에서는 Claude Code가 이러한 호출을 거부하며, `auto`, `plan` 또는 `bypassPermissions` 모드에서는 콜백이 실행되기 전에 [이를 승인할 수 있습니다](https://code.claude.com/docs/ko/agent-sdk/typescript.md#permission-modes-that-can-approve-an-always_ask-call).

**4. 권한 모드**

활성 [권한 모드](#permission-modes)를 적용합니다.

* `bypassPermissions` 모드에서 Claude Code는 이 단계에 도달하는 모든 것을 승인합니다. 단, 인식된 [중요 경로 제거](https://code.claude.com/docs/ko/permission-modes.md#critical-paths)와 [`Dangerous rm operation not ruled out`](https://code.claude.com/docs/ko/permission-modes#dangerous-rm-operation-not-ruled-out)으로 표시된 Bash 명령은 승인되지 않고 대신 전달됩니다.
  * 프롬프트 없이 이러한 제거를 실행하려면 [중요 경로 제거 프롬프트 끄기](https://code.claude.com/docs/ko/permission-modes.md#turn-off-the-critical-path-removal-prompt-in-bypasspermissions-mode)를 참조하세요.
* `acceptEdits` 모드에서 Claude Code는 [Accept edits mode](#accept-edits-mode-acceptedits)에 나열된 파일 작업을 승인합니다.
* `plan` 모드에서 Claude Code는 allow 규칙과 관계없이 파일 편집 도구를 `canUseTool` 콜백으로 보냅니다.
* 다른 모드에서는 요청이 전달됩니다.

**5. 허용 규칙**

`allow` 규칙(`allowed_tools` 및 settings.json에서)을 확인합니다. 규칙이 일치하면 도구가 승인됩니다. 도구가 자체적으로 승인하는 호출도 이 단계에서 규칙 없이 해결됩니다. 예를 들어 작업 디렉터리 내의 파일 읽기 또는 [읽기 전용 Bash 명령](https://code.claude.com/docs/ko/permissions.md#read-only-commands)입니다.

인식된 [중요 경로 제거](https://code.claude.com/docs/ko/permission-modes.md#critical-paths)는 allow 규칙으로 승인되지 않으며, `Dangerous rm operation not ruled out`으로 표시된 명령은 `Bash` 또는 `Bash(*)` 규칙으로 승인되지 않습니다. 그 후 콜백에 도달하는지 여부는 권한 모드에 따라 달라집니다. 예를 들어 `auto` 모드의 Agent SDK 세션에서 Claude Code는 기본적으로 콜백을 호출하지 않고 이를 거부합니다. [중요 경로 모드 테이블](https://code.claude.com/docs/ko/permission-modes.md#critical-path-removals-in-each-permission-mode)은 각 모드가 이들을 어떻게 처리하는지 나열합니다.

allow 규칙은 [네트워크 경로](https://code.claude.com/docs/ko/permissions.md#network-paths)에서의 읽기를 승인하지 않습니다.

**6. canUseTool 콜백**

위의 어느 것도 해결하지 못하면 결정을 위해 [`canUseTool` 콜백](https://code.claude.com/docs/ko/agent-sdk/user-input)을 호출합니다. `dontAsk` 모드에서는 이 단계를 건너뛰고 도구가 거부됩니다. 다만 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 여전히 [이러한 호출 중 일부](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)를 승인할 수 있습니다.

TypeScript SDK에서 [`permissionPrompts: 'none'`](https://code.claude.com/docs/ko/agent-sdk/typescript#options)을 설정하면 콜백이 이 단계에서 호출되지 않습니다. [`PermissionRequest` hook](https://code.claude.com/docs/ko/hooks#permissionrequest)은 여전히 결정할 기회를 얻으며, 그렇지 않으면 Claude Code가 호출을 거부합니다. 이 옵션에는 Claude Code v2.1.259 이상이 필요합니다.

![위의 단계와 일치하는 6단계 권한 평가 흐름의 다이어그램: 도구 요청이 hooks, 거부 규칙, 확인 규칙, 권한 모드, 허용 규칙 및 canUseTool을 통과합니다. Hooks, 거부 규칙 및 canUseTool은 Blocked로 라우팅할 수 있습니다. 권한 모드 bypass, 허용 규칙 및 canUseTool은 Execute로 라우팅할 수 있습니다. 확인 규칙은 canUseTool로 라우팅합니다.](https://mintcdn.com/claude-code/jYgs7qigNjO1Badj/images/agent-sdk/permissions-flow.svg?fit=max\&auto=format\&n=jYgs7qigNjO1Badj\&q=85\&s=c771ad9085b1277d3708027a49c744bc)

TypeScript SDK가 평가 순서를 자동 승인하도록 예상하는 구성에서 `canUseTool` 콜백을 전달하면 쿼리가 구성될 때 SDK는 Node.js 프로세스 경고를 한 번 내보냅니다. 경고의 코드는 `CLAUDE_SDK_CAN_USE_TOOL_SHADOWED`입니다. 두 가지 구성이 이를 트리거합니다.

* `permissionMode: 'bypassPermissions'`: 경고 텍스트는 `canUseTool will not be invoked: permissionMode 'bypassPermissions'`로 시작합니다. 도구 호출은 `canUseTool`이 참조되기 전에 승인되므로, 콜백은 [Bypass permissions mode](#bypass-permissions-mode-bypasspermissions)에 나열된 호출과 같은 소수의 호출에 대해서만 실행됩니다. 승인된 호출도 확인하려면 콜백의 확인 로직을 [`PreToolUse` hook](https://code.claude.com/docs/ko/agent-sdk/hooks)에 넣으세요
* `"Read"`처럼 도구 이름만 있는 `allowedTools` 항목: 경고는 `canUseTool will not be invoked for:` 뒤에 이러한 각 항목을 나열합니다. 나열된 도구에 대한 호출은 [allow 규칙이 절대 승인하지 않는 호출](#calls-an-allow-rule-never-approves)을 제외하고 `canUseTool`이 참조되기 전에 승인됩니다. 나열된 도구의 호출 중 승인이 필요한 호출에 대해 콜백이 실행되도록 하려면 `allowedTools`에서 해당 도구의 항목을 제거하세요

`Bash(ls *)`와 같은 지정자가 있는 항목과 `acceptEdits` 모드는 이를 트리거하지 않으며, 설정 파일에서 오는 허용 규칙은 확인에 표시되지 않습니다.

이 경고는 어떤 호출도 차단하지 않으며 어떤 옵션도 변경하지 않습니다. 콜백이 이미 확인하려는 모든 호출을 받고 있다면 구성을 그대로 두세요. 경고를 로그에 기록하려면 `process.on('warning', ...)`으로 수신하고 `CLAUDE_SDK_CAN_USE_TOOL_SHADOWED` 코드를 일치시키세요.

이 페이지는 **허용 및 거부 규칙** 및 **권한 모드**에 중점을 둡니다. 다른 단계의 경우:

* **Hooks:** 도구 요청을 허용, 거부 또는 수정하는 사용자 정의 코드를 실행합니다. [Hooks로 실행 제어](https://code.claude.com/docs/ko/agent-sdk/hooks.md)를 참조하세요.
* **canUseTool 콜백:** 이전 단계에서 호출을 해결하지 못할 때 런타임에 사용자에게 승인을 요청합니다. [승인 및 사용자 입력 처리](https://code.claude.com/docs/ko/agent-sdk/user-input.md)를 참조하세요.

## 허용 및 거부 규칙

`allowed_tools` 및 `disallowed_tools` (TypeScript: `allowedTools` / `disallowedTools`)는 위의 평가 흐름에서 허용 및 거부 규칙 목록에 항목을 추가합니다. [작업 추적 도구](https://code.claude.com/docs/ko/agent-sdk/todo-tracking.md#model-availability) 중 하나를 `allowed_tools`에 지정하면 Claude Code는 해당 세션에서 작업 추적 도구도 활성화합니다. `allowed_tools`에 나열되지 않은 다른 도구는 여전히 Claude에서 사용 가능하며, 승인이 필요한 호출은 권한 모드로 넘어갑니다. 거부 규칙은 도구의 이름을 지정하는지 또는 도구 내의 패턴을 범위 지정하는지에 따라 다르게 작동합니다.

| 옵션 | 효과 |
| :- | :- |
| `allowed_tools=["Read", "Grep"]` | `Read` 및 `Grep`은 [네트워크 경로에서의 읽기](https://code.claude.com/docs/ko/permissions.md#network-paths)를 제외하고 자동 승인됩니다. 여기에 나열되지 않은 다른 도구는 여전히 존재하며, 승인이 필요한 호출은 권한 모드 및 `canUseTool`로 넘어갑니다. |
| `disallowed_tools=["Bash"]` | `Bash` 도구 정의가 요청에서 제거됩니다. Claude는 도구를 보지 못하며 시도할 수 없습니다. |
| `disallowed_tools=["Bash(rm *)"]` | `Bash`는 사용 가능한 상태로 유지됩니다. `rm *` [작성된 대로](https://code.claude.com/docs/ko/permissions.md#bash-rule-limits) 일치하는 호출은 `bypassPermissions`를 포함한 모든 권한 모드에서 거부됩니다. `/bin/rm`을 포함한 다른 `Bash` 호출은 권한 모드로 넘어갑니다. |
| `disallowed_tools=["*"]` | 모든 도구 정의가 요청에서 제거됩니다. 도구 이름 글롭은 거부 규칙에서 지원됩니다: `"*"`는 모든 도구와 일치하고 `"mcp__*"`는 모든 서버의 모든 MCP 도구와 일치합니다. |

허용 규칙은 리터럴 `mcp__<server>__` 접두사 이후에만 도구 이름 글롭을 허용합니다. 서버 세그먼트는 글롭이 없어야 하므로 규칙이 구성한 특정 서버의 이름을 지정합니다: `mcp__puppeteer__*`는 `puppeteer` 서버의 모든 도구와 일치하고, `mcp__github__get_*`는 해당 `get_` 도구와 일치합니다. `allowed_tools=["*"]` 또는 `allowed_tools=["mcp__*"]`와 같은 앵커되지 않은 항목은 무시되며 아무것도 자동 승인하지 않습니다.

`Read` 및 `Edit`에 대한 범위 지정 규칙은 경로 패턴을 사용합니다. `Edit(path)` 규칙은 `Write` 및 `NotebookEdit`을 포함하여 파일을 쓰는 모든 기본 제공 도구를 관리합니다. `Write(path)` 규칙은 파일 권한 검사에 의해 일치되지 않습니다.

절대 파일 시스템 경로에는 `//path`를 사용합니다: `Edit(//secrets/**)` 거부 규칙은 디스크의 `/secrets` 아래 어디든지 쓰기를 차단합니다. 단일 슬래시를 사용하면 `Edit(/secrets/**)`는 규칙의 소스에서 앵커됩니다. `allowed_tools` 또는 `disallowed_tools`를 통해 전달된 규칙의 경우, 이는 세션의 작업 디렉토리를 의미하므로 규칙은 디스크의 `/secrets`를 차단하지 않습니다. 네 가지 앵커 형식과 설정 파일의 규칙이 어떻게 해결되는지는 [Read 및 Edit 규칙](https://code.claude.com/docs/ko/permissions.md#read-and-edit)을 참조하십시오.

> [!WARNING]
>
> **자동 승인된 도구는 `canUseTool`에 도달하지 않습니다.** `acceptEdits` 또는 `bypassPermissions`에 의해 또는 허용 규칙에 의해 이전 단계에서 승인된 도구 호출은 `canUseTool` 콜백을 건너뛰므로, 거기에 넣은 권한 검사는 해당 도구에 대해 자동으로 무시됩니다.
>
> `allowed_tools`에 있는 도구에 대한 호출이 여전히 `canUseTool` 콜백에 도달하거나 `dontAsk` 모드에서 거부된다면, 해당 호출이 [네트워크 경로에서의 읽기](https://code.claude.com/docs/ko/permissions.md#network-paths)인지 또는 다음 호출 중 하나인지 확인하십시오. 어떤 허용 규칙도 이러한 호출을 승인하지 않습니다. 확인을 요청하지 않는 `dontAsk` 모드에서 Claude Code는 `canUseTool`을 호출하지 않고 이러한 호출을 거부하며, 다른 권한 모드에서는 각 항목에 설명된 대로 처리합니다:
>
> * `AskUserQuestion`, [`_meta["anthropic/requiresUserInteraction"]`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)로 표시된 MCP 도구, [조직이 `ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구: 콜백에서 응답합니다. `AskUserQuestion`에 응답하는 방법은 [명확화 질문 처리](https://code.claude.com/docs/ko/agent-sdk/user-input.md#handle-clarifying-questions)에 나와 있으며, 커넥터 호출은 `Your organization requires approval for this tool`이라는 사유와 함께 도착합니다
>
> * 애플리케이션이 [`always_ask`](https://code.claude.com/docs/ko/agent-sdk/custom-tools#require-approval-for-specific-tools)로 표시한 사용자 지정 도구: 콜백에서 호출을 결정합니다. 이러한 호출이 도착하지 않도록 하려면 [세션 중에 정책을 변경](https://code.claude.com/docs/ko/agent-sdk/typescript.md#mcpsdkserverconfigwithinstance)합니다. `auto`, `plan`, `bypassPermissions` 모드에서는 [`always_ask` 호출을 승인할 수 있는 권한 모드](https://code.claude.com/docs/ko/agent-sdk/typescript#permission-modes-that-can-approve-an-always_ask-call)에 나열된 경우에 호출이 콜백 전에 승인될 수 있습니다
>
> * 인식된 `rm` 및 `rmdir` [중요 경로 제거](https://code.claude.com/docs/ko/permission-modes.md#critical-paths): `default`, `acceptEdits`, `bypassPermissions` 모드에서는 콜백에서 제거를 허용하거나 거부하며, 이때 [`decisionReason`](https://code.claude.com/docs/ko/agent-sdk/typescript#canusetool)은 `Dangerous rm`으로 시작합니다. `auto` 및 `plan` 모드의 경우 [각 권한 모드의 중요 경로 제거](https://code.claude.com/docs/ko/permission-modes.md#critical-path-removals-in-each-permission-mode)를 참조하십시오. 이러한 제거를 인식하는 검사는 [일부 명령을 놓칠 수 있습니다](https://code.claude.com/docs/ko/permission-modes.md#critical-paths)
>
> * **단순 이름**: `Read` 또는 `mcp__github__get_issue`와 같은 항목은 [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)과 [네트워크 경로에서의 읽기](https://code.claude.com/docs/ko/permissions.md#network-paths)를 제외하고 해당 도구에 대한 모든 호출을 자동 승인합니다.
>
> * **범위 지정 규칙**: `Bash(npm test *)`와 같은 항목은 일치하는 호출만 자동 승인하며, 승인이 필요한 다른 `Bash` 호출은 여전히 콜백으로 넘어갑니다.
>
> 모든 도구 호출에서 실행되어야 하는 검사의 경우 [`PreToolUse` 훅](https://code.claude.com/docs/ko/agent-sdk/hooks)을 사용합니다: 훅은 다른 모든 단계 전에 실행되고, 훅 거부는 `bypassPermissions` 모드에서도 적용됩니다.

잠금된 에이전트의 경우 `allowedTools`를 `permissionMode: "dontAsk"`와 쌍으로 지정합니다:

```typescript theme={null}
const options = {
  allowedTools: ["Read", "Glob", "Grep"],
  permissionMode: "dontAsk"
};
```

나열된 `Read`, `Glob`, `Grep` 호출은 [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)과 [네트워크 경로에서의 읽기](https://code.claude.com/docs/ko/permissions.md#network-paths)를 제외하고 승인됩니다. 프롬프트를 표시할 다른 모든 호출은 대신 거부되지만, 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 여전히 [그러한 호출 중 일부](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)를 승인할 수 있습니다.

`default` 모드에서 승인이 필요 없는 호출은 나열 여부와 관계없이 실행됩니다. 예를 들어 [읽기 전용 Bash 명령](https://code.claude.com/docs/ko/permissions.md#read-only-commands), 실행 전에 묻지 않는 `Agent`와 같은 도구, 작업 디렉터리 내의 파일 읽기 등입니다. 기본 제공 도구의 호출을 거부하는 대신 Claude에게서 도구를 완전히 숨기려면 `disallowedTools`에 해당 도구의 단순 이름을 추가합니다.

> [!WARNING]
>
> **`allowed_tools`는 `bypassPermissions`를 제한하지 않습니다.** `allowed_tools`는 나열한 도구를 사전 승인합니다. 나열되지 않은 다른 도구는 허용 규칙과 일치하지 않으며 권한 모드로 넘어가고, 여기서 `bypassPermissions`는 이들을 승인합니다. `allowed_tools=["Read"]`를 `permission_mode="bypassPermissions"`와 함께 설정하면 `Bash`, `Write`, `Edit`을 포함한 모든 도구를 여전히 승인합니다. `bypassPermissions`가 필요하지만 특정 도구를 차단하려면 `disallowed_tools`를 사용합니다.

`.claude/settings.json`에서 허용, 거부 및 요청 규칙을 선언적으로 구성할 수도 있습니다. 이러한 규칙은 `project` 설정 소스가 활성화될 때 읽혀지며, 기본 `query()` 옵션에 대해 활성화됩니다. `setting_sources` (TypeScript: `settingSources`)를 명시적으로 설정하면 적용되도록 `"project"`를 포함합니다. 규칙 구문은 [권한 설정](https://code.claude.com/docs/ko/settings-reference.md#permission-settings)을 참조하십시오.

## 권한 모드

권한 모드는 Claude가 도구를 사용하는 방식을 전역적으로 제어합니다. `query()`를 호출할 때 권한 모드를 설정하거나 스트리밍 세션 중에 동적으로 변경할 수 있습니다.

Claude Code v2.1.302 이상에서는 사용자가 권한 모드를 설정하거나 앱이 설정 파일의 [`permissions.defaultMode`](https://code.claude.com/docs/ko/settings-reference#permissions-defaultmode)에서 권한 모드를 가져오는 경우를 제외하면 앱은 `default` 모드로 시작합니다. `default` 모드에서 Claude Code는 허용 규칙, 훅, `canUseTool` 콜백 또는 권한 프롬프트 도구를 통해 승인되지 않은 한 승인이 필요한 모든 도구 호출을 거부합니다. 도구 호출이 거부되는 경우 [`claude -p` 및 Agent SDK 실행에서 거부되는 도구 호출](https://code.claude.com/docs/ko/permission-modes#which-mode-a-non-interactive-run-starts-in)을 참조하세요.

### 사용 가능한 모드

SDK는 다음 권한 모드를 지원합니다.

| 모드 | 설명 | 도구 동작 |
| :- | :- | :- |
| `default` | 표준 권한 동작 | 모드 기반 자동 승인이 없으며, 승인이 필요하고 어떤 허용 규칙과도 일치하지 않는 호출은 `canUseTool` 콜백을 트리거합니다 |
| `dontAsk` | 확인을 요청하는 대신 거부 | 원래 확인을 요청했을 모든 호출은 `canUseTool`을 호출하지 않고 거부되지만, 사용자가 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 여전히 [그중 일부 호출](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)을 승인할 수 있습니다. `allowed_tools` 또는 `settings.json` 허용 규칙으로 승인된 호출은 실행되며, `default` 모드에서 승인이 필요 없는 호출도 실행됩니다. [네트워크 경로에서의 읽기](https://code.claude.com/docs/ko/permissions.md#network-paths)와 같은 일부 호출은 `allowed_tools` 또는 허용 규칙이 일치하더라도 거부됩니다. 전체 목록은 [묻지 않음 모드](#don’t-ask-mode-dontask)를 참조하세요 |
| `acceptEdits` | 파일 편집 자동 수락 | 파일 편집과 [파일 시스템 작업](#accept-edits-mode-acceptedits)(`mkdir`, `rm`, `mv` 등)이 자동으로 승인됩니다 |
| `bypassPermissions` | 권한 확인 우회 | [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)과, [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md) 외부에서 애플리케이션이 [`always_ask`로 지정한](https://code.claude.com/docs/ko/agent-sdk/custom-tools#require-approval-for-specific-tools) 커스텀 도구를 제외하고 도구가 권한 프롬프트 없이 실행됩니다. 주의해서 사용하세요 |
| `plan` | 플랜 모드 | Claude가 소스 파일을 편집하지 않고 탐색하고 계획합니다. 파일 편집은 자동 승인되지 않으며 `canUseTool` 콜백을 통해 확인을 요청합니다 |
| `auto` | 모델 분류 기반 승인 | 모델 분류기가 셸 명령 및 네트워크 요청과 같은 작업을 검토하고, 검토하는 각 작업을 허용하거나 차단합니다. 사용 가능 여부와 결정 순서는 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)를 참조하세요 |

> [!WARNING]
>
> **서브에이전트 상속:** 메인 세션이 [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)인 경우, [`AgentDefinition`](https://code.claude.com/docs/ko/agent-sdk/typescript#agentdefinition)에서 `permissionMode: "acceptEdits"`를 설정한 서브에이전트도 여전히 플랜 모드로 실행됩니다. 해당 서브에이전트가 소스 파일에 대해 수행하는 `Edit` 및 `Write` 호출은 여전히 `canUseTool` 콜백으로 전달됩니다. 직접 정의한 서브에이전트에도 플랜 모드가 유지되므로, 작업을 서브에이전트에 넘기더라도 계획을 먼저 검토하는 과정을 우회할 수 없습니다.
>
> 서브에이전트는 메인 세션의 `plan`, `acceptEdits`, `auto` 또는 `bypassPermissions` 모드를 상속하며, 메인 세션이 `default` 또는 `dontAsk` 모드인 경우에는 사용자가 설정한 모드로 실행됩니다. 그런 경우에도 Claude Code는 `"bypassPermissions"` 값을 적용하지 않으며, `"auto"` 값은 해당 서브에이전트에서 [자동 모드를 사용할 수 있는](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) 경우에만 적용합니다. `bypassPermissions` 예외에는 Claude Code v2.1.267 이상이 필요합니다.
>
> 서브에이전트는 메인 에이전트와 다른 시스템 프롬프트를 가지고 덜 제약된 동작을 할 수 있으므로, `bypassPermissions`를 상속하면 완전하고 자율적인 시스템 액세스 권한이 부여됩니다. [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)은 여전히 적용됩니다.

### 권한 모드 설정

쿼리를 시작할 때 권한 모드를 한 번 설정하거나, 세션이 활성 상태인 동안 동적으로 변경할 수 있습니다.

> [tab] 쿼리 시점
>
> 쿼리를 생성할 때 `permission_mode`(Python) 또는 `permissionMode`(TypeScript)를 전달합니다.
>
> ```python Python theme={null}
> import asyncio
> from claude_agent_sdk import query, ClaudeAgentOptions
>
>
> async def main():
>     async for message in query(
>         prompt="Help me refactor this code",
>         options=ClaudeAgentOptions(
>             permission_mode="default",  # Set the mode here
>         ),
>     ):
>         if hasattr(message, "result"):
>             print(message.result)
>
>
> asyncio.run(main())
> ```
>
> ```typescript TypeScript theme={null}
> import { query } from "@anthropic-ai/claude-agent-sdk";
>
> async function main() {
>   for await (const message of query({
>     prompt: "Help me refactor this code",
>     options: {
>       permissionMode: "default" // Set the mode here
>     }
>   })) {
>     if ("result" in message) {
>       console.log(message.result);
>     }
>   }
> }
>
> main();
> ```

> [tab] 스트리밍 중
>
> 세션 중간에 모드를 변경하려면 `set_permission_mode()`(Python) 또는 `setPermissionMode()`(TypeScript)를 호출합니다. 새 모드는 이후의 모든 도구 요청에 즉시 적용됩니다. 이를 통해 제한적으로 시작한 후 신뢰가 쌓이면 권한을 완화할 수 있습니다. 예를 들어 Claude의 초기 접근 방식을 검토한 후 `acceptEdits`로 전환할 수 있습니다.
>
> ```python Python theme={null}
> import asyncio
> from claude_agent_sdk import ClaudeSDKClient, ClaudeAgentOptions
>
>
> async def main():
>     async with ClaudeSDKClient(
>         options=ClaudeAgentOptions(
>             permission_mode="default",  # Start in default mode
>         )
>     ) as client:
>         await client.query("Help me refactor this code")
>
>         # Change mode dynamically mid-session
>         await client.set_permission_mode("acceptEdits")
>
>         # Process messages with the new permission mode
>         async for message in client.receive_response():
>             if hasattr(message, "result"):
>                 print(message.result)
>
>
> asyncio.run(main())
> ```
>
> ```typescript TypeScript theme={null}
> import { query } from "@anthropic-ai/claude-agent-sdk";
>
> async function main() {
>   const q = query({
>     prompt: "Help me refactor this code",
>     options: {
>       permissionMode: "default" // Start in default mode
>     }
>   });
>
>   // Change mode dynamically mid-session
>   await q.setPermissionMode("acceptEdits");
>
>   // Process messages with the new permission mode
>   for await (const message of q) {
>     if ("result" in message) {
>       console.log(message.result);
>     }
>   }
> }
>
> main();
> ```

### 모드 세부 정보

#### 편집 수락 모드(`acceptEdits`)

파일 작업을 자동 승인하므로 Claude가 확인을 요청하지 않고 코드를 편집할 수 있습니다. 다른 도구(파일 시스템 작업이 아닌 Bash 명령 등)는 여전히 일반 권한이 필요합니다.

**자동 승인되는 작업:**

* 파일 편집(Edit, Write 도구)
* 파일 시스템 명령: `mkdir`, `touch`, `rm`, `rmdir`, `mv`, `cp`, `sed`

두 가지 모두 작업 디렉터리 또는 `additionalDirectories` 내부의 경로에만 적용됩니다. `acceptEdits` 모드에서 Claude Code는 Claude가 다음을 수행할 때 요청을 자동 승인하지 않습니다.

* 해당 범위 밖의 경로에서 작업하는 경우
* 보호된 경로에 쓰는 경우
* Claude Code가 [중요 경로](https://code.claude.com/docs/ko/permission-modes.md#critical-paths)로 인식하는 경로를 `rm` 또는 `rmdir`로 삭제하는 경우
* 예를 들어 옵션, glob, 또는 `timeout 5`나 `LANG=C` 접두사와 함께 [`touch`](https://code.claude.com/docs/ko/permission-modes#auto-approve-file-edits-with-acceptedits-mode)를 실행하는 경우

**사용 시기:** Claude의 편집을 신뢰하고 프로토타이핑 중이거나 격리된 디렉터리에서 작업할 때처럼 더 빠른 반복을 원하는 경우에 사용합니다.

#### 묻지 않음 모드(`dontAsk`)

`canUseTool`을 호출하지 않고 모든 권한 프롬프트를 거부로 전환하지만, 사용자가 설치한 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 여전히 [그중 일부 호출](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)을 승인할 수 있습니다. `allowed_tools`, `settings.json` 허용 규칙 또는 훅으로 사전 승인된 도구는 정상적으로 실행됩니다. 작업 디렉터리 내부의 파일 읽기나 `Agent` 호출처럼 `default` 모드에서 승인이 필요 없는 호출도 실행됩니다.

다음 호출은 허용 규칙이 일치하더라도 거부됩니다.

* [조직이 `ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구
* `AskUserQuestion`, 그리고 서버가 [`_meta["anthropic/requiresUserInteraction"]`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)을 설정한 MCP 도구처럼 사용자 상호작용이 필요한 도구
* 애플리케이션이 `permission_policy`를 [`always_ask`](https://code.claude.com/docs/ko/agent-sdk/custom-tools#require-approval-for-specific-tools)로 설정한 커스텀 도구
* [네트워크 경로에서의 읽기](https://code.claude.com/docs/ko/permissions.md#network-paths)
* 인식된 [중요 경로 삭제](https://code.claude.com/docs/ko/permission-modes.md#critical-paths)

`PreToolUse` 훅이 인식된 중요 경로 삭제, 네트워크 경로에서의 읽기 또는 `always_ask`로 지정된 도구 호출에 대해 `allow`를 반환하더라도 해당 호출은 여전히 거부됩니다. 이러한 삭제를 인식하는 검사는 [일부 명령을 놓칠 수 있습니다](https://code.claude.com/docs/ko/permission-modes.md#critical-paths).

**사용 시기:** 헤드리스 에이전트에 고정되고 명시적인 도구 집합을 제공하고, `canUseTool`이 없다는 점에 암묵적으로 의존하기보다 확실한 거부를 선호하는 경우에 사용합니다.

#### 권한 우회 모드(`bypassPermissions`)

[어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)을 제외하고 확인을 요청하지 않고 도구 사용을 자동 승인합니다. 훅은 여전히 실행되며 필요한 경우 작업을 차단할 수 있습니다. Linux 및 macOS에서 Claude Code는 [인식된 샌드박스](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode) 외부에서 root로 또는 `sudo` 아래에서 이 모드로 시작하는 것을 거부하며, 쿼리는 첫 번째 턴 전에 실패합니다.

> [!WARNING]
>
> 매우 주의해서 사용하세요. 이 모드에서 Claude는 완전한 시스템 액세스 권한을 가집니다. 가능한 모든 작업을 신뢰할 수 있는 통제된 환경에서만 사용하세요.
>
> `allowed_tools`는 이 모드를 제한하지 않습니다. 나열한 도구뿐만 아니라 모든 도구가 승인됩니다. 다음 제어는 여전히 적용됩니다.
>
> * 거부 규칙, 명시적 `ask` 규칙 및 훅은 모드 확인 전에 평가되며 여전히 도구를 차단할 수 있습니다.
> * [조직이 `ask`로 설정한](https://code.claude.com/docs/ko/mcp#organization-controls-on-connector-tools) 커넥터 도구, 사용자 상호작용이 필요한 도구, 그리고 인식된 [중요 경로 삭제](https://code.claude.com/docs/ko/permission-modes.md#critical-paths)는 여전히 `canUseTool` 콜백으로 넘어갑니다. 이러한 삭제를 인식하는 검사는 [일부 명령을 놓칠 수 있으며](https://code.claude.com/docs/ko/permission-modes.md#critical-paths), [중요 경로 삭제 프롬프트를 끌 수도 있습니다](https://code.claude.com/docs/ko/permission-modes.md#turn-off-the-critical-path-removal-prompt-in-bypasspermissions-mode). [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md) 외부에서는 애플리케이션이 [`always_ask`로 지정한](https://code.claude.com/docs/ko/agent-sdk/custom-tools#require-approval-for-specific-tools) 커스텀 도구 호출도 콜백으로 넘어갑니다.
> * [세션 간 메시징 보호 장치](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode)는 여전히 적용됩니다.

#### 플랜 모드(`plan`)

Claude는 소스 파일을 편집하지 않고 코드베이스를 탐색하여 계획을 작성합니다. 플랜 모드에서는 허용 규칙이 일치하거나 `PreToolUse` 훅이 `allow`를 반환하더라도 파일 편집이 자동 승인되지 않습니다. 대신 `canUseTool` 콜백을 통해 확인을 요청합니다.

세션에서 자동 모드를 사용할 수 있는 동안에는 Claude가 계획 중에 실행하는 명령이 기본적으로 콜백에 도달하지 않습니다. [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 사용하는 분류기 모델이 [대신 이를 검토](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)하기 때문입니다. 이 검토가 켜져 있으면 분류기는 허용 규칙이 없는 `WebFetch` 호출처럼 원래 콜백에 도달했을 읽기 전용 호출도 승인할 수 있습니다.

> [!NOTE]
>
> TypeScript SDK에서 `permissionMode: 'plan'`과 함께 `allowDangerouslySkipPermissions: true`를 설정하더라도, 파일 편집은 여전히 `canUseTool` 콜백에 도달합니다. 플랜 모드로 시작하는 세션을 나중에 `setPermissionMode()`로 `bypassPermissions`로 전환하려면 처음부터 `allowDangerouslySkipPermissions`를 설정해야 합니다.

Claude는 계획을 확정하기 전에 요구 사항을 명확히 하기 위해 `AskUserQuestion`을 사용할 수 있습니다. 이러한 프롬프트를 처리하는 방법은 [승인 및 사용자 입력 처리](https://code.claude.com/docs/ko/agent-sdk/user-input.md#handle-clarifying-questions)를 참조하세요.

**사용 시기:** 코드 리뷰 중이거나 변경 사항이 적용되기 전에 승인해야 하는 경우처럼, Claude가 변경 사항을 실행하지 않고 제안하기를 원하는 경우에 사용합니다.

#### 자동 모드(`auto`)

분류기 모델이 셸 명령 및 네트워크 요청과 같은 작업을 실행 전에 검토하고, 검토하는 각 작업을 허용하거나 차단합니다. 자동 모드에 필요한 모델 및 제공자와 작업을 평가하는 순서는 [자동 모드로 권한 프롬프트 없애기](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)를 참조하세요.

[`set_model()`](https://code.claude.com/docs/ko/agent-sdk/python#claudesdkclient), [`setModel()`](https://code.claude.com/docs/ko/agent-sdk/typescript#query-object) 또는 [`applyFlagSettings()`](https://code.claude.com/docs/ko/agent-sdk/typescript#applyflagsettings)를 사용하여 자동 모드인 세션을 자동 모드가 지원하지 않는 모델로 전환하면 세션이 `default` 모드로 변경됩니다.

* **표시되는 내용**: 하위 유형이 `status`이고 `permissionMode`가 `"default"`로 설정된 `system` 메시지이며, TypeScript SDK에서는 [`SDKStatusMessage`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkstatusmessage) 타입입니다. 이후 승인이 필요하고 어떤 허용 규칙과도 일치하지 않는 호출은 `canUseTool` 콜백에 도달합니다.
* **자동 모드로 돌아가려면**: 지원되는 모델로 전환한 다음 `set_permission_mode("auto")` 또는 `setPermissionMode("auto")`를 호출합니다. 해당 호출 없이 모델만 다시 전환하면 세션은 `default` 모드로 유지됩니다. 지원되지 않는 모델이 활성 상태인 동안에는 호출이 `Cannot set permission mode to auto: auto mode unavailable for this model` 오류와 함께 실패합니다.

`set_model()`, `setModel()` 또는 `applyFlagSettings()` 호출 후 `default` 모드로 변경되는 동작에는 Claude Code v2.1.299 이상이 필요합니다.

## 관련 리소스

권한 평가 흐름의 다른 단계들:

* [승인 및 사용자 입력 처리](https://code.claude.com/docs/ko/agent-sdk/user-input.md): 대화형 승인 프롬프트 및 명확히 하는 질문
* [Hooks 가이드](https://code.claude.com/docs/ko/agent-sdk/hooks.md): 에이전트 라이프사이클의 주요 지점에서 사용자 정의 코드 실행
* [권한 규칙](https://code.claude.com/docs/ko/settings-reference.md#permission-settings): `settings.json`의 선언적 허용/거부 규칙
