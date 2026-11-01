> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 모든 기기에서 로컬 세션 계속하기 (Remote Control)

> Remote Control을 사용하여 휴대폰, 태블릿 또는 모든 브라우저에서 로컬 Claude Code 세션을 계속할 수 있습니다. claude.ai/code 및 Claude 모바일 앱과 함께 작동합니다.

Remote Control은 [claude.ai/code](https://claude.ai/code) 또는 [iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) 및 [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude)용 Claude 앱을 사용자의 머신에서 실행 중인 Claude Code 세션에 연결합니다. 책상에서 작업을 시작한 후 소파의 휴대폰이나 다른 컴퓨터의 브라우저에서 계속할 수 있습니다.

사용자의 머신에서 Remote Control 세션을 시작하면 Claude는 전체 시간 동안 로컬에서 계속 실행되므로 코드 실행 및 파일시스템 액세스는 사용자의 머신에 유지됩니다. Remote Control을 사용하면 다음을 수행할 수 있습니다:

* **전체 로컬 환경을 원격으로 사용**: 파일시스템, [MCP 서버](https://code.claude.com/docs/ko/mcp.md), 도구 및 프로젝트 구성이 모두 사용 가능하게 유지되며, `@`를 입력하면 로컬 프로젝트의 파일 경로가 자동 완성됩니다.
* **두 개의 표면에서 동시에 작업**: 대화 및 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md) 및 [동적 워크플로우](https://code.claude.com/docs/ko/workflows.md)의 진행 상황이 모든 연결된 기기에서 동기화되므로 터미널, 브라우저 및 휴대폰에서 상호 교환 가능하게 메시지를 보낼 수 있습니다.
* **휴대폰 또는 브라우저에서 이미지 및 파일 전송**: Claude 앱 또는 claude.ai/code에서 캡션 포함 여부와 관계없이 사진 또는 파일을 첨부합니다. Claude는 첨부된 사진을 메시지의 일부로 직접 봅니다. Claude Code는 다른 파일을 사용자의 머신에 다운로드하고 `@` 파일 참조로 Claude에 전달합니다.
* **중단에서 복구**: 노트북이 절전 모드로 전환되거나 네트워크가 끊어지면 머신이 다시 온라인 상태가 될 때 Claude Code가 자동으로 다시 연결됩니다.

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)은 클라우드 인프라에서 실행되는 것과 달리, Remote Control 세션은 사용자의 머신에서 직접 실행되며 로컬 파일시스템과 상호 작용합니다. 웹 및 모바일 인터페이스는 해당 로컬 세션으로의 창이므로 컴퓨터는 계속 켜져 있어야 하고 `claude` 프로세스는 계속 실행되어야 합니다.

> [!NOTE]
>
> Remote Control은 Claude Code 기능입니다. 다른 Claude 제품의 대화에 대해서는 [Claude 고객센터](https://support.claude.com)를 참조하세요.

## 요구 사항

Remote Control을 사용하기 전에 환경이 다음 조건을 충족하는지 확인하세요:

* **구독**: Pro, Max, Ultra, Team 및 Enterprise 요금제에서 사용 가능합니다. API 키는 지원되지 않습니다. Team 및 Enterprise의 경우 Owner가 먼저 [Claude Code 관리자 설정](https://claude.ai/admin-settings/claude-code)에서 Remote Control 토글을 활성화해야 합니다.
* **사용자 지정 역할**: Enterprise 조직에서 [사용자 지정 역할](https://support.claude.com/en/articles/13930452)로 액세스를 관리하는 경우, 역할에 클라우드 세션 권한과 **Claude Code remote control** 권한이 모두 부여되어 있어야 합니다. 둘 중 하나라도 없으면 Remote Control을 시작할 때 [`Remote Control is disabled by your organization's policy`](#remote-control-is-disabled-by-your-organizations-policy)가 표시됩니다. Owner에게 역할을 확인하고 [**Organization settings > Roles**](https://claude.ai/admin-settings/roles)에서 누락된 권한을 추가해 달라고 요청하세요.
* **인증**: `claude`를 실행하고 아직 로그인하지 않았다면 `/login`을 사용하여 claude.ai를 통해 로그인하세요. 적격 로그인이 없으면 `claude remote-control`은 오류로 종료되고, `claude --remote-control`은 여전히 대화형 세션을 시작하며 시작 직후 Remote Control 실패 알림을 표시합니다.
* **API 엔드포인트**: 다음 구성 중 어느 것도 사용할 수 없습니다:
  * Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry를 사용합니다.
  * [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)이 `api.anthropic.com` 이외의 호스트(예: [LLM gateway](https://code.claude.com/docs/ko/llm-gateway) 또는 프록시)를 가리킵니다. Remote Control을 사용하려면 변수를 설정 해제하세요.
  * enterprise [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway)를 통해 로그인합니다.
* **기능 플래그 평가**: [환경 변수를 설정하여 기능 플래그 평가를 비활성화](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching)하는 경우, Remote Control의 가용성은 어느 것을 설정했는지에 따라 달라집니다:
  * `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` 또는 `DISABLE_GROWTHBOOK`을 설정하면 Remote Control을 사용할 수 없습니다. Remote Control을 사용하려면 셸 환경이나 [`settings.json` 파일](https://code.claude.com/docs/ko/settings-reference#all-settings)의 `env` 블록에서 변수가 설정된 곳 어디든 설정 해제하세요.
  * 만약 `DISABLE_TELEMETRY` 또는 `DO_NOT_TRACK`만 설정하면, 조직에서 [신뢰할 수 있는 디바이스](#trusted-devices)를 요구하지 않는 한 Remote Control은 계속 사용 가능합니다. 요구하는 경우 Remote Control을 사용하려면 변수를 설정 해제하세요. 두 변수 중 하나를 설정한 상태에서 Remote Control을 사용하려면 Claude Code v2.1.283 이상, Claude Desktop 앱에서는 v2.1.304 이상이 필요합니다.
* **작업 공간 신뢰**: 아직 신뢰하지 않은 디렉토리에서 `claude remote-control`은 신뢰하면 어떤 기능이 활성화되는지 출력하고 시작하기 전에 `Trust <directory>? [y/N]`을 묻습니다. `y`로 답하면 선택 사항이 저장되지만, 홈 디렉토리에서는 신뢰가 절대 저장되지 않으며 매번 실행할 때마다 질문이 반복됩니다. 표준 입력 또는 출력이 터미널이 아닐 때, 명령은 질문할 수 없으며 [`Workspace not trusted`](https://code.claude.com/docs/ko/errors#workspace-not-trusted-when-starting-remote-control) 오류로 종료됩니다.

## Remote Control 세션 시작하기

Remote Control 세션은 CLI, [Claude Desktop 앱](https://code.claude.com/docs/ko/desktop.md) 또는 VS Code 확장 프로그램에서 시작할 수 있습니다. CLI는 세 가지 호출 모드를 제공하며, Desktop 앱과 VS Code는 `/remote-control` 명령을 사용합니다.

> [tab] 서버 모드
>
> 프로젝트 디렉터리에서 다음을 실행합니다.
>
> ```bash theme={null}
> claude remote-control
> ```
>
> Remote Control의 일회성 확인을 수락하기 전까지 `claude remote-control`은 서버를 시작하기 전에 기능을 설명하고 `Enable Remote Control? (y/n)`을 묻습니다. `y`로 답하면 수락하고 서버를 시작합니다. 거절하면 Claude Code는 서버를 시작하지 않고 종료되며, 다음에 명령을 실행할 때 다시 묻습니다.
>
> 서버 모드에서는 프로세스가 터미널에서 계속 실행되며 원격 연결을 기다립니다. [다른 기기에서 연결](#connect-from-another-device)하는 데 사용할 수 있는 세션 URL이 표시되며, 스페이스바를 누르면 휴대폰에서 빠르게 접속할 수 있는 QR 코드가 표시됩니다. 원격 세션이 활성화된 동안 터미널에는 연결 상태와 도구 활동이 표시됩니다.
>
> `remote-control` 뒤에 다음 플래그를 전달할 수 있습니다.
>
> | 플래그 | 설명 |
> | - | - |
> | `--name "My Project"` | claude.ai/code의 세션 목록에 표시되는 사용자 지정 세션 제목을 설정합니다. |
> | `--remote-control-session-name-prefix <prefix>` | 명시적인 이름이 설정되지 않았을 때 자동 생성되는 세션 이름의 접두사입니다. 기본값은 머신의 호스트 이름이며, `myhost-graceful-unicorn`과 같은 이름이 생성됩니다. `CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX`를 설정해도 같은 효과를 얻을 수 있습니다. |
> | `-c`, `--continue` | 새 세션을 만드는 대신, 이 디렉터리에서 마지막으로 실행된 서버가 시작할 때 사용한 세션을 다시 불러옵니다. [서버 중지 후 세션 재개하기](#resume-sessions-after-stopping-the-server)를 참조하세요. `--session-id`, `--spawn`, `--capacity`, `--create-session-in-dir`와 함께 사용할 수 없습니다. Claude Code v2.1.200 이상이 필요합니다. |
> | `--session-id <id>` | ID로 세션 하나를 다시 불러옵니다. [서버 중지 후 세션 재개하기](#resume-sessions-after-stopping-the-server)를 참조하세요. `--continue`, `--spawn`, `--capacity`, `--create-session-in-dir`와 함께 사용할 수 없습니다. Claude Code v2.1.200 이상이 필요합니다. |
> | `--spawn <mode>` | 서버가 세션을 생성하는 방식입니다. • `same-dir`(저장된 모드가 없을 때의 기본값): 모든 세션이 현재 작업 디렉터리를 공유하므로, 같은 파일을 편집하면 충돌이 발생할 수 있습니다. • `worktree`: 요청 시 생성되는 각 세션이 자체 [git worktree](https://code.claude.com/docs/ko/worktrees.md)를 갖습니다. git 저장소 또는 [`WorktreeCreate` 훅](https://code.claude.com/docs/ko/hooks#worktreecreate)이 필요합니다. • `session`: 단일 세션 모드입니다. 정확히 하나의 세션만 제공하고 추가 연결은 거부합니다. 시작 시에만 설정할 수 있습니다. 실행 중에 `w`를 누르면 `same-dir`와 `worktree` 간에 전환됩니다. 전환한 모드는 [이 프로젝트의 기본값](#set-the-default-spawn-mode-for-a-project)이 됩니다. |
> | `--capacity <N>` | 최대 동시 세션 수입니다. 기본값은 32입니다. `--spawn=session`과 함께 사용할 수 없습니다. |
> | `--[no-]create-session-in-dir` | 서버가 시작될 때 현재 디렉터리에 세션 하나를 미리 생성하여 즉시 입력할 수 있도록 합니다. `worktree` 모드에서는 이 세션이 현재 디렉터리에 유지되고, 요청 시 생성되는 세션은 격리된 워크트리를 갖습니다. 기본적으로 켜져 있습니다. `--no-create-session-in-dir`을 전달하여 세션 없이 시작하면, 서버를 중지할 때 Claude Code가 서버의 세션을 보관 처리하므로 [재개](#resume-sessions-after-stopping-the-server)할 세션이 남지 않습니다. |
> | `--permission-mode <mode>` | 서버 세션의 시작 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)를 `acceptEdits` 등으로 설정합니다. `manual`을 `default`의 별칭으로 허용합니다. 인식할 수 없는 모드를 지정하면 시작 시 서버가 중지되고 유효한 모드 목록이 표시됩니다. |
> | `--chrome` / `--no-chrome` | 서버가 생성하는 세션에서 [Chrome 통합](https://code.claude.com/docs/ko/chrome.md)을 켜거나 꺼, 다른 기기에서 작업하는 동안 Claude가 사용자 머신의 Chrome을 사용할 수 있도록 합니다. 두 플래그 모두 없으면, [Chrome을 기본으로 활성화](https://code.claude.com/docs/ko/chrome.md#enable-chrome-by-default)한 경우에도 서버가 미리 생성하는 세션과 claude.ai/code 또는 Claude 앱에서 직접 시작하는 세션은 Chrome이 꺼진 상태로 시작합니다. 서버가 [프로젝트](https://code.claude.com/docs/ko/claude-projects.md) 스레드 중 하나를 위해 시작하는 세션은 대신 해당 설정을 따르며, `bypassPermissions` 모드에서는 예외입니다. Claude Code v2.1.273 이상이 필요합니다. |
> | `-d`, `--debug[=<filter>]` | 서버의 디버그 로깅을 켜며, 선택적으로 카테고리별로 필터링할 수 있습니다. 필터는 `--debug=api,hooks`와 같이 `=` 형식으로만 전달합니다. Claude Code v2.1.282 이상이 필요합니다. |
> | `--debug-file <path>` | 디버그 로그를 지정한 파일에 기록합니다. |
> | `--verbose` | 자세한 연결 및 세션 로그를 표시합니다. |
> | `--sandbox`, `--no-sandbox` | v2.1.300에서 제거되었습니다. 두 플래그 중 하나를 전달하면 서버가 시작되지 않고 [오류와 함께 종료](https://code.claude.com/docs/ko/errors.md#sandbox-is-not-supported-by-claude-remote-control)됩니다. |
>
> `remote-control` 앞에 전역 `claude` 플래그를 전달하거나 래퍼 스크립트가 이를 추가하는 경우, Claude Code는 해당 플래그를 서버가 생성하는 세션으로 전달하지 않습니다. Claude Code는 `--verbose`나 `--model`처럼 플래그를 제외해도 해당 세션이 할 수 있는 일이 바뀌지 않는 것으로 알려진 경우에만 플래그를 허용합니다. `--settings` 등 그 외의 플래그에 대해서는 Claude Code가 [시작을 거부](https://code.claude.com/docs/ko/errors.md#not-carried-over-to-the-sessions-remote-control-starts)하고 제거해야 할 플래그 이름을 알려 줍니다.
>
> 서버가 시작하는 세션을 샌드박스로 격리하려면 설정 파일에서 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)을 켭니다.
>
> 터미널에 `remote-control` 플래그를 출력하려면 `claude remote-control --help`를 실행합니다. v2.1.302 이전에는 자격이 있는 계정으로 로그인하지 않은 경우 이 명령이 대신 [문제 해결](#troubleshooting)에 나열된 오류 중 하나를 반환했습니다.

> [tab] 대화형 세션
>
> Remote Control이 활성화된 일반 대화형 Claude Code 세션을 시작하려면 `--remote-control` 플래그(또는 `--rc`)를 사용합니다.
>
> ```bash theme={null}
> claude --remote-control
> ```
>
> 선택적으로 세션 이름을 전달할 수 있습니다.
>
> ```bash theme={null}
> claude --remote-control "My Project"
> ```
>
> 이렇게 하면 터미널에서 완전한 대화형 세션을 사용하면서 claude.ai 또는 Claude 앱에서도 제어할 수 있습니다. `claude remote-control`(서버 모드)과 달리, 세션을 원격으로도 사용할 수 있는 동안 로컬에서 메시지를 입력할 수 있습니다.

> [tab] 기존 세션에서
>
> 이미 Claude Code 세션에 있고 원격으로 계속하려면 `/remote-control`(또는 `/rc`) 명령을 사용합니다.
>
> ```text theme={null}
> /remote-control
> ```
>
> 인수로 이름을 전달하면 사용자 지정 세션 제목을 설정할 수 있습니다.
>
> ```text theme={null}
> /remote-control My Project
> ```
>
> 이렇게 하면 현재 대화 기록을 이어받는 Remote Control 세션이 시작됩니다.
>
> Remote Control의 일회성 확인을 수락하기 전까지는 `/remote-control`이 연결되기 전에 대화 상자가 나타납니다. **Enable Remote Control**을 선택하면 수락하고 연결합니다. **Never mind**를 선택하거나 Esc를 누르면 Claude Code는 연결하지 않으며, 다음에 `/remote-control`을 실행할 때 다시 묻습니다.
>
> 이 명령에서는 `--verbose` 플래그를 사용할 수 없습니다.

> [tab] VS Code
>
> [Claude Code VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md)의 프롬프트 상자에 `/remote-control` 또는 `/rc`를 입력합니다.
>
> ```text theme={null}
> /remote-control
> ```
>
> Remote Control이 켜져 있는 동안 Claude Code는 프롬프트 상자 하단에 **Remote Control** 표시기를 보여 줍니다. 세션이 연결되면 표시기를 클릭하여 세션으로 바로 이동하거나, [claude.ai/code](https://claude.ai/code)의 세션 목록에서 찾을 수 있습니다. Claude Code는 대화에 세션 URL도 게시합니다. 연결을 끊으려면 `/remote-control`을 다시 실행합니다.
>
> CLI와 달리 VS Code 명령은 이름 인수를 받지 않으며 QR 코드도 표시하지 않습니다. 세션 제목은 대화 기록 또는 첫 번째 프롬프트에서 생성됩니다.

> [tab] Desktop 앱
>
> [Claude Desktop 앱](https://code.claude.com/docs/ko/desktop.md)의 Code 탭에 있는 로컬 세션에서 프롬프트 상자에 `/remote-control` 또는 `/rc`를 입력합니다.
>
> ```text theme={null}
> /remote-control
> ```
>
> 세션이 연결되면 [claude.ai/code](https://claude.ai/code)의 세션 목록에서 찾을 수 있습니다. 연결을 끊으려면 `/remote-control`을 다시 실행합니다.
>
> 대신 모든 세션에서 기본적으로 Remote Control을 켜려면 [모든 세션에서 Remote Control 활성화하기](#enable-remote-control-for-all-sessions)를 참조하세요.

### 연결 상태 확인하기

대화형 세션에서 Remote Control이 연결되어 있는 동안 터미널에는 claude.ai의 세션으로 연결되는 `/rc active` 표시기가 나타납니다. 터미널 너비가 너무 좁으면 표시기가 숨겨집니다. 세션 URL과 [다른 기기에서 연결](#connect-from-another-device)하기 위한 QR 코드를 보려면 `/remote-control`을 다시 실행하여 상태 패널을 엽니다. 이 패널에서는 로컬 세션을 계속 실행하면서 Remote Control 연결을 끊을 수도 있습니다.

대화형 세션에서 연결이 실패하면 표시기가 실패 상태로 바뀌고, Claude Code는 알림으로 이유를 보여 주며 대화에도 추가합니다. 이유가 세션이 다른 곳에서 변경되었다고 나타내는 경우가 아니라면 `/remote-control`을 실행하여 다시 연결합니다.

* **Another connection took over this session**: 다른 기기나 Claude Code 세션이 현재 세션을 가져갔습니다. 다시 가져오려는 경우에만 `/remote-control`을 실행합니다.
* **This session was ended or archived from another device or app**: 세션을 다시 가져오려는 경우에만 `/remote-control`을 실행합니다. Claude Code는 보관 처리된 세션을 다시 엽니다.
* **The server no longer reports this session**: 다른 기기나 앱에서 세션이 삭제되었을 수 있습니다.

### 다른 기기에서 연결하기

Remote Control 세션이 활성화되면 다른 기기에서 연결하는 방법은 몇 가지가 있습니다.

* 아무 브라우저에서 **세션 URL을 열어** [claude.ai/code](https://claude.ai/code)의 세션으로 바로 이동합니다.
* 세션 URL과 함께 표시되는 **QR 코드를 스캔**하여 Claude 앱에서 바로 엽니다. `claude remote-control`에서는 스페이스바를 눌러 QR 코드 표시를 전환합니다.
* **[claude.ai/code](https://claude.ai/code) 또는 Claude 앱을 열고** 세션 목록에서 이름으로 세션을 찾습니다. Claude 모바일 앱에서는 내비게이션의 **Code**를 탭하여 세션 목록으로 이동합니다. Remote Control 세션은 온라인 상태일 때 초록색 상태 점이 있는 컴퓨터 아이콘으로 표시됩니다.

연결하면 기기에 세션이 이미 백그라운드에서 실행 중인 서브에이전트와 워크플로가 표시됩니다. 기기에서 그중 하나를 중지하면 Claude Code는 사용자 머신에서 해당 작업을 중지합니다.

원격 세션 제목은 다음 순서로 결정됩니다.

1. `--name`, `--remote-control` 또는 `/remote-control`에 전달한 이름
2. `/rename`으로 설정한 제목
3. 기존 대화 기록의 마지막 의미 있는 메시지
4. `myhost-graceful-unicorn`과 같이 자동 생성된 이름. 여기서 `myhost`는 머신의 호스트 이름 또는 `--remote-control-session-name-prefix`로 설정한 접두사입니다

명시적인 이름을 설정하지 않은 경우, 프롬프트를 보내면 Claude Code가 해당 프롬프트를 반영하도록 제목을 업데이트합니다. claude.ai 또는 Claude 앱에서 세션 이름을 변경하면 Claude Code는 `claude --resume`에 표시되는 로컬 제목도 업데이트합니다.

아직 Claude 앱이 없다면 Claude Code에서 `/mobile`을 실행하여 [claude.ai/mobile](https://claude.ai/mobile)용 QR 코드를 표시합니다. 이 QR 코드는 휴대폰에 맞는 앱 스토어를 엽니다.

### 연결된 기기에 표시되는 내용

연결된 기기에는 터미널의 대화가 실시간으로 표시됩니다. 다음은 일반 메시지 이외의 경우입니다.

* **압축과 `/clear`**: Claude Code가 [대화를 압축](https://code.claude.com/docs/ko/context-window.md#what-survives-compaction)하는 동안 연결된 기기에는 진행 상황과 함께 대화가 압축된 지점이 표시됩니다. `/clear`를 실행하면 연결된 기기에서도 대화가 초기화됩니다.
* **`/resume`으로 대화 전환**: 연결된 기기는 전환된 대화의 제목이나 이전 기록을 받지 않지만, 양방향의 새 메시지는 터미널에서 열려 있는 대화와 주고받습니다. 기기에서 원래 대화로 다시 작업하려면 터미널에서 `/resume`을 실행하여 원래 대화로 다시 전환합니다.
* **`/teleport`로 세션 가져오기**: `/teleport`로 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#from-cloud-to-terminal)을 터미널로 가져오면 연결된 기기는 가져온 대화의 이전 기록을 받지 않습니다. 양방향의 새 메시지는 이제 터미널에서 열려 있는 가져온 대화와 주고받습니다.
* **다른 세션의 메시지**: [세션 간 메시징](https://code.claude.com/docs/ko/cross-session-messaging.md)을 사용하면 같은 연결을 통해 여러 머신에 있는 사용자 자신의 세션 간에 메시지가 전달됩니다.
* **변경 사항의 diff**: 세션의 디렉터리가 git 저장소에 있으면 연결된 기기의 diff 창에 변경 사항이 표시됩니다. 저장소의 기본 브랜치보다 앞선 커밋이 있는 브랜치에서는 커밋되지 않은 편집을 포함하여 브랜치가 기본 브랜치에서 갈라진 이후의 변경 사항이 표시됩니다. 기본 브랜치 자체 또는 기본 브랜치보다 앞서지 않은 브랜치에서는 커밋되지 않은 변경 사항만 표시됩니다.
* **모델**: 연결된 기기에서 [모델](https://code.claude.com/docs/ko/model-config.md)을 선택하면 Claude Code는 해당 모델로 세션을 실행합니다. Claude Code v2.1.238 이상이 필요합니다. 기기의 모델 컨트롤에서 선택한 모델은 현재 세션에만 적용됩니다. 기기에서 대화형 세션으로 `/model <name>`을 보내면 Claude Code는 새 세션의 기본값도 설정합니다.
* **Effort 수준**: 연결된 기기에서 `/effort` 또는 기기의 effort 컨트롤로 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)을 설정하면 Claude Code는 사용자 머신의 세션에 이를 적용합니다. `CLAUDE_CODE_EFFORT_LEVEL`로 수준을 고정한 경우 세션은 해당 수준을 유지하며, Claude Code는 effort 컨트롤에서 다른 값을 선택해도 거부합니다. effort 컨트롤에서 수준을 선택하려면 사용자 머신에 Claude Code v2.1.234 이상이 필요합니다.
* **연결 실패 후 다시 연결**: `/remote-control`을 실행하여 다시 연결합니다. 그 사이에 압축으로 대화가 다시 작성되었거나 `/resume`으로 대화를 전환한 경우, Claude Code는 사용하던 서버 세션을 세션 목록에 남겨 두는 대신 보관 처리합니다. claude.ai/code의 [보관된 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#find-an-archived-session)에서 해당 세션을 여전히 찾을 수 있습니다. 기기가 연결된 상태에서 대화를 전환하면 세션이 보관 처리되지 않습니다.

### 모든 세션에서 Remote Control 활성화하기

자동 연결이 켜져 있지 않으면 Remote Control은 `claude remote-control`, `claude --remote-control` 또는 `/remote-control`을 명시적으로 실행할 때만 활성화됩니다. 모든 대화형 세션에서 자동 연결을 켜려면 Claude Code에서 `/config`를 실행하고 **Enable Remote Control for all sessions**를 설정합니다. 이 토글은 세 가지 값을 가집니다.

* **`true`**: 대화형 세션이 시작될 때 자동으로 연결합니다.
* **`false`**: 자동 연결을 끕니다. 다만 Claude Code는 이 선택을 사용자 설정에 저장하므로 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)의 `true`가 이보다 우선합니다. 프로젝트 또는 로컬 설정(`.claude/settings.json`, `.claude/settings.local.json`)의 `false`는 관리형 `true`보다도 우선하여 자동 연결을 끕니다.
* **`default`**: 선택을 지우고, 조직의 관리자 기본값이 설정되어 있으면 이를 따르고, 그렇지 않으면 Claude Code의 현재 기본값을 따릅니다. `DISABLE_TELEMETRY` 또는 `DO_NOT_TRACK`을 설정한 경우 [`DISABLE_TELEMETRY` 또는 `DO_NOT_TRACK`이 설정된 경우의 자동 연결](#auto-connect-with-disable-telemetry-or-do-not-track)을 참조하세요.

VS Code 확장 프로그램과 Desktop 앱에도 자동 연결 토글이 있습니다.

* **VS Code 확장 프로그램**: [명령 메뉴](https://code.claude.com/docs/ko/vs-code.md#use-the-prompt-box)의 Settings 섹션에 있는 **Enable Remote Control for all sessions**.
* **Desktop 앱**: **Settings > Code** 또는 **Settings > Claude Code**에 있는 **Connect new sessions to Remote Control**. [다른 기기에 표시되는 세션 제어하기](https://code.claude.com/docs/ko/desktop.md#control-which-sessions-appear-on-your-other-devices)를 참조하세요.

대신 설정 파일에서 자동 연결을 켜려면 사용자 `~/.claude/settings.json` 또는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 [`remoteControlAtStartup`](https://code.claude.com/docs/ko/settings-reference#remotecontrolatstartup)을 `true`로 설정합니다. 프로젝트 또는 로컬 설정(`.claude/settings.json`, `.claude/settings.local.json`)에서는 Claude Code가 `false`를 적용하여 해당 저장소의 자동 연결을 끄지만 `true`는 무시하므로, 체크인된 파일로 저장소를 여는 모든 사람에게 Remote Control을 켤 수는 없습니다.

자동 연결은 사용자 자신의 claude.ai 계정으로 로그인하므로, 자동 연결로 시작된 세션은 사용자 본인 계정의 Claude 앱에만 표시되며 다른 누구에게도 접근 권한을 부여하지 않습니다.

이 설정을 켜면 각 대화형 Claude Code 프로세스가 하나의 원격 세션을 등록합니다. 여러 인스턴스를 실행하면 각 인스턴스가 자체 원격 세션을 갖습니다. 단일 프로세스에서 여러 동시 세션을 실행하려면 대신 [서버 모드](#start-a-remote-control-session)를 사용합니다.

#### `DISABLE_TELEMETRY` 또는 `DO_NOT_TRACK`이 설정된 경우의 자동 연결

`DISABLE_TELEMETRY` 또는 `DO_NOT_TRACK`만 설정된 경우, 세션은 조직의 관리자 기본값이나 Claude Code 자체 기본값을 통해 자동 연결되지 않습니다. `DISABLE_GROWTHBOOK`이나 LLM 게이트웨이 등 다른 요인으로 Remote Control을 사용할 수 없는 경우에는 대신 [요구 사항](#requirements)부터 확인하세요.

`DISABLE_TELEMETRY` 또는 `DO_NOT_TRACK`만 설정된 상태에서 자동 연결을 켜기 전에, Claude Code 버전이 [이러한 변수에 대한 요구 사항](#requirements)을 충족하는지 확인합니다. 그런 다음 조직에서 [Trusted Devices](#trusted-devices)를 요구하는지 확인합니다.

* **요구하지 않는 경우**: `/config`에서 **Enable Remote Control for all sessions**를 `true`로 설정합니다.
* **요구하는 경우**: `DISABLE_TELEMETRY` 또는 `DO_NOT_TRACK`이 설정되어 있는 동안에는 Remote Control을 사용할 수 없습니다. 두 변수 중 설정한 변수를 해제합니다. 그래도 세션이 자동 연결되지 않으면 `/config`에서 **Enable Remote Control for all sessions**를 `true`로 설정합니다.

### 서버 중지 후 세션 재개하기

Ctrl+C로 `claude remote-control`을 중지하면 서버가 제공하던 세션은 휴대폰이나 브라우저에서 더 이상 응답하지 않습니다. 같은 디렉터리에서 다른 `claude remote-control`을 실행하고 있지 않았고 이 서버를 `--no-create-session-in-dir`로 시작하지 않았다면, Claude Code는 해당 세션을 보관 처리하지 않습니다. 세션을 다시 불러오려면 같은 디렉터리에서 다음 명령 중 하나를 실행합니다.

* **`claude remote-control`**: 서버가 제공하던 모든 세션을 다시 불러옵니다.
* **`claude remote-control --continue`**: 서버가 시작할 때 사용한 세션만 다시 불러오며, 해당 세션이 종료되면 종료됩니다. 이 디렉터리에 기록이 없으면 Claude Code는 이 저장소의 다른 git worktree에서 가장 최근 기록을 사용합니다.
* **`claude remote-control --session-id <id>`**: 전달한 ID의 세션만 다시 불러오며, 해당 세션이 종료되면 종료됩니다. ID는 claude.ai/code에 있는 세션 URL에서 `/code/`와 `?` 사이의 부분입니다.

이 명령은 서버가 중지된 후 약 4시간 동안 작동합니다. 그 이후에는 `claude remote-control`을 실행하여 새 세션을 시작합니다. 그 사이에 세션을 보관 처리한 경우, Claude Code v2.1.228 이상에서는 `--continue`와 `--session-id`가 세션의 보관 처리를 해제합니다.

`claude --remote-control` 또는 `/remote-control`로 시작한 세션을 다시 불러오려면 `claude --continue` 또는 `claude --resume`으로 대화를 재개합니다. 재개된 대화가 시작되는 권한 모드에 대해서는 [재개 시 권한 모드](https://code.claude.com/docs/ko/sessions.md#permission-mode-on-resume)를 참조하세요. Remote Control이 다시 연결되지 않으면 [Couldn't reconnect to your Remote Control session](#couldnt-reconnect-to-your-remote-control-session)을 참조하세요.

첫 번째 터미널에서 Remote Control이 아직 켜져 있는 상태로 두 번째 터미널에서 대화를 재개하면, Claude Code는 두 번째 터미널에 `Remote Control not started here` 알림을 출력하고 첫 번째 터미널에서 세션을 가져오는 대신 두 번째 터미널에서는 Remote Control을 끈 상태로 둡니다. Remote Control을 두 번째 터미널로 옮기려면 두 번째 터미널에서 `/remote-control`을 실행합니다.

Remote Control이 켜져 있던 대화를 Claude Desktop 또는 IDE 확장 프로그램에서 재개하면, Claude Code는 세션 목록에 새 세션을 추가하는 대신 기존 claude.ai 세션에 다시 연결합니다.

### 프로젝트의 기본 spawn 모드 설정하기

시작 시 `claude remote-control`이 `Spawn mode: <mode> (saved for this folder; press w to change)`를 출력하면, 서버는 이전에 이 프로젝트에 저장된 spawn 모드로 시작하는 것입니다.

저장된 모드는 사용자가 자신의 터미널에서 선택한 값에서 비롯됩니다. 해당 터미널에서 `claude remote-control`이 `Spawn mode for this project:`를 물었다면, Claude Code는 사용자가 답한 값(`same-dir`는 `1`, `worktree`는 `2`)을 저장했습니다. 실행 중에 `w`를 눌렀다면, `--spawn same-dir` 또는 `--spawn worktree`로 시작한 실행에서도 Claude Code는 전환한 모드를 저장했습니다.

* 서버가 `same-dir` 또는 `worktree` 모드로 실행되는 동안 서버의 터미널에서 `w`를 누르면 다른 모드로 전환됩니다. 전환하려면 git 저장소 또는 `WorktreeCreate` 훅이 필요합니다.
* 한 번의 실행에만 다른 모드를 사용하려면 `--spawn <mode>`를 전달합니다.

## 연결 및 보안

로컬 Claude Code 세션은 아웃바운드 HTTPS 요청만 수행하며 컴퓨터에서 인바운드 포트를 열지 않습니다. Remote Control을 시작하면 Anthropic API에 등록되고 작업을 폴링합니다. 다른 기기에서 연결하면 서버는 웹 또는 모바일 클라이언트와 로컬 세션 간의 메시지를 스트리밍 연결을 통해 라우팅합니다.

모든 트래픽은 TLS를 통해 Anthropic API를 통해 이동하며, 이는 모든 Claude Code 세션과 동일한 전송 보안입니다. 연결은 각각 단일 목적으로 범위가 지정되고 독립적으로 만료되는 여러 단기 자격 증명을 사용합니다.

Remote Control이 연결되어 있는 동안 메시지, Claude의 응답 및 도구 활동을 포함한 세션 기록이 Anthropic 서버에 저장됩니다. 저장된 기록은 기기 간에 대화를 동기화 상태로 유지하고 네트워크 중단 후 세션을 다시 연결할 수 있게 합니다. 실행 및 파일 시스템 액세스는 컴퓨터에 유지되며, 저장된 기록은 [데이터 사용](https://code.claude.com/docs/ko/data-usage.md) 정책에 따라 보관됩니다.

Remote Control을 완전히 끄려면 [`disableRemoteControl`](https://code.claude.com/docs/ko/settings-reference#disableremotecontrol) 설정을 사용합니다. [Zero Data Retention](https://code.claude.com/docs/ko/zero-data-retention.md)이 활성화되어 있거나 [HIPAA 구성](https://code.claude.com/docs/ko/hipaa-setup.md)이 적용된 조직은 Remote Control을 활성화할 수 없습니다.

## 신뢰할 수 있는 기기

> [!NOTE]
>
> 신뢰할 수 있는 기기는 현재 베타 단계입니다. 경험이 개선됨에 따라 기능이 변할 수 있습니다.
>
> 신뢰할 수 있는 기기는 Pro, Max, Ultra, Team 및 Enterprise 요금제에서 사용할 수 있으며 기본적으로 꺼져 있습니다. Team 및 Enterprise 요금제에서는 Owner가 조직에 대해 이를 켭니다. Pro, Max 및 Ultra 요금제에서는 설정의 Cowork 또는 Account 페이지에서 **신뢰할 수 있는 기기 필요**를 직접 켭니다.

신뢰할 수 있는 기기를 사용하면 claude.ai, Claude 모바일 앱 또는 Claude Desktop에서 Remote Control 세션을 보거나 제어하기 전에 확인된 기기가 있어야 합니다. 이 요구 사항은 조직의 각 구성원에게 적용되며, Pro, Max 또는 Ultra 요금제에서는 사용자 본인에게만 적용됩니다. Remote Control 액세스를 로그인된 계정만이 아니라 알려진 기기 및 최근 인증에 연결합니다.

설정이 켜져 있으면 Remote Control 세션과 상호 작용하려면 다음 두 가지가 모두 필요합니다:

* **등록된 기기**: 구성원이 Remote Control에 사용하는 각 브라우저, 휴대폰 또는 데스크톱 앱은 자체 자격 증명을 등록합니다. 등록은 전체 로그인 직후에만 제공되므로 기기는 백그라운드에서 자동으로 신뢰 목록에 추가되지 않고 실제 인증의 일부로 참여합니다.
* **최근 로그인**: 구성원의 로그인은 18시간 이상 되지 않아야 합니다. 매일 다시 로그인하는 대신 구성원은 Face ID, Touch ID, Windows Hello 또는 passkey로 존재를 확인합니다. 이 생체 인식 단계는 세션을 즉시 새로 고칩니다.

생체 인식 확인은 passkey 로그인과 동일한 메커니즘인 운영 체제 또는 브라우저를 통해 기기에서 실행됩니다. Anthropic은 지문, 얼굴 데이터 또는 기타 생체 인식 정보를 받거나 저장하지 않습니다. 기기의 공개 키 및 표시 이름, 플랫폼, 등록 시간 등의 기본 메타데이터만 저장됩니다.

설정은 Claude Code의 Remote Control과 [Cowork](https://claude.com/docs/cowork/overview)의 Computer access에 적용됩니다. 이 페이지에서는 Claude Code 측면을 다룹니다. 일반 Claude 채팅, 터미널의 Claude Code 및 API 사용은 영향을 받지 않습니다.

### Team 또는 Enterprise 조직에 대해 신뢰할 수 있는 기기 활성화

소유자는 claude.ai 조직 설정에서 설정을 활성화합니다.

**1. Capabilities 페이지로 이동**

[**조직 설정 > Capabilities > Remote sessions**](https://claude.ai/admin-settings/capabilities)로 이동합니다. **신뢰할 수 있는 기기 필요** 토글이 해당 섹션에 나타납니다.

**2. 신뢰할 수 있는 기기 필요 켜기**

설정은 조직의 모든 구성원과 토글을 활성화한 후 시작된 Remote Control 세션에 적용됩니다. 토글이 켜지기 전에 이미 실행 중이던 세션은 소급 적용되지 않으며 기기 요구 사항 없이 종료될 때까지 계속됩니다. 팀별 또는 프로젝트별 범위 지정은 사용할 수 없습니다.

**3. 구성원에게 예상되는 사항 알리기**

설정이 활성화된 후 구성원이 브라우저, 휴대폰 또는 데스크톱 앱에서 새 Remote Control 세션을 처음 보거나 제어할 때 해당 기기를 등록하라는 메시지가 표시됩니다. 미리 알려주면 혼동을 피할 수 있습니다.

### 구성원이 보는 것

등록은 기기당 일회성 단계입니다. 그 후 유일한 눈에 띄는 변화는 가끔 생체 인식 프롬프트입니다.

* **각 기기에서 처음 사용**: 구성원에게 등록하라는 메시지가 표시됩니다. 로그인이 최근이 아니면 SSO가 구성된 경우를 포함하여 일반적인 흐름을 통해 먼저 로그인한 다음 등록을 확인합니다.
* **일상적으로**: 등록된 기기와 최근 로그인이 있는 구성원은 프롬프트를 보지 않습니다. 로그인이 18시간을 초과하면 다음 Remote Control 상호 작용에서 단일 Face ID, Touch ID, Windows Hello 또는 passkey 프롬프트가 표시됩니다.
* **등록되지 않은 기기**: 기기가 등록될 때까지 Remote Control 세션을 보거나 제어할 수 없습니다. 해당 기기의 일반 Claude 채팅은 영향을 받지 않습니다.
* **플랫폼 인증자 없음**: Face ID, Touch ID 또는 Windows Hello가 없는 기계의 구성원은 하드웨어 보안 키를 사용하거나 단계를 올리는 대신 다시 로그인할 수 있습니다.
* **터미널에서**: Claude Code를 실행하는 기계는 개발자가 CLI에 로그인할 때 자동으로 자체 자격 증명을 받습니다. 터미널에는 별도의 등록 단계가 없습니다.

### 등록된 기기 관리

구성원은 계정 설정에서 자신의 기기를 검토하고 취소할 수 있습니다.

[claude.ai/settings/account](https://claude.ai/settings/account#trusted-devices)를 열고 **신뢰할 수 있는 기기** 섹션을 찾아 이름, 플랫폼 및 등록 날짜가 있는 모든 등록된 기기를 확인하세요. 기기를 제거하면 자격 증명이 즉시 취소되며, 기기는 새로운 로그인 후 나중에 다시 등록할 수 있습니다. 자격 증명은 갱신되지 않으면 자동으로 만료되므로 사용하지 않는 기기는 신뢰 목록에서 자동으로 제거됩니다.

분실하거나 도난당한 기기의 경우 구성원이 이 페이지에서 제거합니다. 구성원이 로그인할 수 없으면 관리자는 관리자 콘솔에서 **모든 곳에서 로그아웃**을 사용하여 해당 구성원의 모든 세션 및 등록된 기기를 취소한 후 구성원이 여전히 보유한 기기를 다시 등록합니다.

## 원격 제어 vs 클라우드 세션

원격 제어와 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)은 모두 claude.ai/code 인터페이스를 사용합니다. 주요 차이점은 세션이 실행되는 위치입니다. 원격 제어는 사용자의 컴퓨터에서 실행되므로 로컬 MCP 서버, 도구 및 프로젝트 구성이 계속 사용 가능합니다. 클라우드 세션은 클라우드 인프라에서 실행되며, 기본적으로 Anthropic에서 관리합니다.

로컬 작업 중에 있으면서 다른 기기에서 계속 진행하고 싶을 때는 원격 제어를 사용하세요. 로컬 설정 없이 작업을 시작하거나, 복제하지 않은 저장소에서 작업하거나, 여러 작업을 병렬로 실행하고 싶을 때는 클라우드 세션을 사용하세요. [프로젝트](https://code.claude.com/docs/ko/claude-projects.md)는 두 가지를 결합합니다. 프로젝트의 스레드는 클라우드에서 실행되며, 사용자가 요청할 때 원격 제어를 사용하여 [컴퓨터에서 스레드를 실행](https://code.claude.com/docs/ko/claude-projects.md#run-a-thread-on-your-own-computer)합니다.

Claude Code는 터미널에 있지 않을 때 작업할 수 있는 여러 방법을 제공합니다. 이들은 작업을 트리거하는 것, Claude가 실행되는 위치, 그리고 설정해야 할 양이 다릅니다.

| | 트리거 | Claude 실행 위치 | 설정 | 최적 용도 |
| :- | :- | :- | :- | :- |
| [Dispatch](https://code.claude.com/docs/ko/desktop.md#sessions-from-dispatch) | Claude 모바일 앱에서 작업 메시지 전송 | 사용자 머신 (Desktop) | [모바일 앱을 Desktop과 페어링](https://support.claude.com/en/articles/13947068) | 외출 중 작업 위임, 최소 설정 |
| [Remote Control](https://code.claude.com/docs/ko/remote-control.md) | [claude.ai/code](https://claude.ai/code) 또는 Claude 모바일 앱에서 실행 중인 세션 제어 | 사용자 머신 (CLI, Desktop, 또는 VS Code) | [`claude remote-control` 또는 `/remote-control` 실행](https://code.claude.com/docs/ko/remote-control#start-a-remote-control-session) | 다른 기기에서 진행 중인 작업 조종 |
| [Channels](https://code.claude.com/docs/ko/channels.md) | Telegram 또는 Discord와 같은 채팅 앱이나 자체 서버에서 이벤트 푸시 | 사용자 머신 (CLI) | [채널 플러그인 설치](https://code.claude.com/docs/ko/channels.md#quickstart) 또는 [직접 구축](https://code.claude.com/docs/ko/channels-reference.md) | CI 실패 또는 채팅 메시지와 같은 외부 이벤트에 반응 |
| [Slack](https://code.claude.com/docs/ko/slack.md) | 팀 채널에서 `@Claude` 언급 | Anthropic 클라우드 | Pro, Max 및 Ultra 플랜에서 [Claude Code on the web](https://code.claude.com/docs/ko/claude-code-on-the-web.md)이 활성화된 상태로 [Slack 앱 설치](https://code.claude.com/docs/ko/slack.md#setting-up-claude-code-in-slack) | 팀 채팅에서 PR 및 리뷰 |
| [Self-hosted environments](https://code.claude.com/docs/ko/self-hosted-environments) | [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 시작하고 조직의 환경 선택 | 조직의 인프라 | [러너 배포](https://code.claude.com/docs/ko/self-hosted-environments-quickstart.md), Team 및 Enterprise 플랜 | 네트워크 내에서 실행해야 하는 클라우드 세션 |
| [Scheduled tasks](https://code.claude.com/docs/ko/scheduled-tasks.md) | 일정 설정 | [CLI](https://code.claude.com/docs/ko/scheduled-tasks.md), [Desktop](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md), 또는 [클라우드](https://code.claude.com/docs/ko/routines.md) | 빈도 선택 | 일일 검토와 같은 반복 자동화 |

## 모바일 푸시 알림

Remote Control이 활성화되어 있으면 Claude가 휴대폰으로 푸시 알림을 보낼 수 있습니다.

Claude가 푸시를 보낼 시기를 결정합니다. 일반적으로 오래 실행되는 작업이 완료되거나 계속 진행하기 위해 사용자의 결정이 필요할 때 알림을 보냅니다. 프롬프트에서 푸시를 요청할 수도 있습니다. 예를 들어 `notify me when the tests finish`와 같이 입력할 수 있습니다. 아래의 두 가지 켜기/끄기 토글 외에는 이벤트별 구성이 없습니다.

모바일 푸시 알림을 설정하려면:

**1. Claude 모바일 앱 설치**

[iOS](https://apps.apple.com/us/app/claude-by-anthropic/id6473753684) 또는 [Android](https://play.google.com/store/apps/details?id=com.anthropic.claude)용 Claude 앱을 다운로드합니다.

**2. Claude Code 계정으로 로그인**

터미널에서 Claude Code에 사용하는 동일한 계정 및 조직을 사용합니다.

**3. 알림 허용**

운영 체제의 알림 권한 프롬프트를 수락합니다.

**4. Claude Code에서 푸시 활성화**

터미널에서 `/config`를 실행하고 사전 알림을 위해 **Push when Claude decides**를 활성화하거나, 권한 프롬프트 및 질문을 위해 **Push when actions required**를 활성화하거나, 둘 다 활성화합니다.

알림이 도착하지 않는 경우:

* `/config`에 **No mobile registered**가 표시되면 휴대폰에서 Claude 앱을 열어 푸시 토큰을 새로 고칠 수 있도록 합니다. Remote Control이 다음에 연결될 때 경고가 해제됩니다.
* iOS에서는 포커스 모드 및 알림 요약이 푸시를 억제하거나 지연시킬 수 있습니다. 설정 → 알림 → Claude를 확인합니다.
* Android에서는 적극적인 배터리 최적화로 인해 전달이 지연될 수 있습니다. 시스템 설정에서 Claude 앱을 배터리 최적화에서 제외합니다.

Claude Code는 사용자가 연결된 터미널에 입력하거나 포커스할 때 모바일 푸시 알림을 건너뜁니다. 이를 다른 창에 있더라도 기계에 있는 모든 시간으로 확장하려면 [`CLAUDE_CLIENT_PRESENCE_FILE`](https://code.claude.com/docs/ko/env-vars)을 마커 파일 경로로 설정합니다. 파일이 존재하는 동안 알림이 건너뜁니다. 화면이 잠금 해제될 때 파일을 생성하고 화면이 잠금될 때 파일을 삭제하도록 화면 잠금 수신기 또는 유사한 도구를 구성합니다.

## 제한 사항

* **대화형 프로세스당 원격 세션 하나**: 서버 모드가 아닌 경우 각 Claude Code 인스턴스는 한 번에 하나의 원격 세션만 지원합니다. 단일 프로세스에서 여러 세션을 동시에 실행하려면 [서버 모드](#start-a-remote-control-session)를 사용합니다.
* **로컬 프로세스가 계속 실행되어야 함**: Remote Control은 로컬 프로세스로 실행됩니다. 터미널을 닫거나, 머신에서 세션을 실행하는 Desktop 앱 또는 VS Code를 종료하거나, 그 밖의 방식으로 `claude` 프로세스를 중지하면, [다시 시작](#resume-sessions-after-stopping-the-server)할 때까지 세션이 오프라인 상태가 됩니다. 원격 머신의 터미널에서 `claude`를 실행하는 경우 SSH 연결을 끊은 후에도 세션이 계속 실행되도록 `tmux` 또는 `screen` 안에서 시작합니다.
* **서버 모드에서 충돌한 세션**: `claude remote-control`이 제공하는 세션이 충돌하면 연결된 기기에서 해당 세션에 메시지를 보냅니다. 그러면 Claude Code가 세션을 다시 제공합니다. 서버를 다시 시작할 필요는 없습니다. Claude Code v2.1.238 이상이 필요합니다.
* **연결된 세션에서의 HTTP 403 거부**: 대화형 세션이 연결되면, 사용자의 머신과 Anthropic 서버 사이의 무언가가 HTTP 403으로 응답할 때 Claude Code는 최대 3분 동안 재시도를 계속합니다. 이는 VPN이나 네트워크 변경 후에 발생할 수 있습니다. 거부가 더 오래 지속되면 Claude Code는 연결을 끊고, 그 사유에 거부한 주체가 명시됩니다. 즉, 네트워크 엣지인지 또는 사용자 네트워크의 프록시, VPN, 방화벽인지가 표시됩니다.
* **장시간 네트워크 중단**: 머신이 깨어 있지만 네트워크에 연결할 수 없는 경우, 다음에 할 일은 모드에 따라 다릅니다.
  * **서버 모드**: Claude Code는 약 10분 후에 포기하고 `claude remote-control` 프로세스가 종료됩니다. 새 세션을 시작하려면 `claude remote-control`을 다시 실행합니다.
  * **대화형 세션**: 로컬에서 계속 작업합니다. Claude Code는 중단이 지속되는 동안 계속 재시도하며, 네트워크가 복구되면 자동으로 다시 연결됩니다.
* **다운로드되지 않는 첨부 파일**: 휴대폰이나 브라우저에서 첨부한 파일을 머신으로 다운로드할 수 없는 경우에도 Claude는 메시지와 다운로드된 파일을 받습니다. 누락된 파일 대신 Claude Code는 메시지에 `[1 of 3 attachments did not arrive]`와 같은 메모를 추가합니다.
* **프레즌스 하트비트 실패**: 대화형 세션이 `could not reach the Remote Control server for about 30 minutes`와 함께 연결이 끊어지면 `/remote-control`을 실행하여 다시 연결합니다.
* **전달된 대화 상자의 만료**: Claude Code는 권한 프롬프트와 `AskUserQuestion` 질문을 사용자가 응답할 때까지 열어 둡니다. 안전 거부 후 표시되는 모델 선택 프롬프트처럼 다른 종류의 대화 상자를 원격 세션으로 전달할 때는 기본적으로 5분 동안 기다린 다음 대화 상자를 닫고 해당 대화 상자의 무동작 기본값으로 계속 진행합니다. 기한을 조정하거나 비활성화하려면 [`dialogExpiry`](https://code.claude.com/docs/ko/settings-reference#dialogexpiry)를 설정합니다. Claude Code v2.1.224 이상이 필요합니다.
* **Fable 사용량 크레딧 동의 프롬프트는 전달되지 않음**: Claude Code는 세션 도중의 [Fable 사용량 크레딧 동의 프롬프트](https://code.claude.com/docs/ko/model-config.md#fable-and-usage-credits)를 사용자의 기기가 아닌 세션이 실행되는 곳에만 표시합니다. 세션이 터미널에서 실행되고 Claude Code가 프롬프트를 닫기 전에 그곳에서 아무도 응답하지 않으면, 요청을 보내지 않고 턴이 종료됩니다. [The prompt to confirm went unanswered](https://code.claude.com/docs/ko/errors.md#the-prompt-to-confirm-went-unanswered)를 참조하세요.
* **일부 명령은 로컬 전용**: `/plugin`이나 `/resume`처럼 터미널 인터페이스에서만 실행되는 명령은 인수 전달 여부와 관계없이 로컬 CLI에서만 작동합니다. `/claude-api`도 모바일이나 웹에서 입력하면 사용할 수 없습니다. 다만 그곳에서도 Claude가 [해당 스킬을 스스로 로드](https://code.claude.com/docs/ko/skills.md#work-on-claude-api-projects)할 수는 있습니다. 다음은 모바일과 웹에서 작동합니다.
  * 텍스트 출력 명령: `/compact`, `/clear`, `/context`, `/usage`, `/exit`, `/usage-credits`, `/recap`, `/reload-plugins`. `/usage-credits`는 브라우저를 여는 대신 청구 URL을 출력합니다. `/reload-plugins`는 세션이 대화형 터미널에서 실행될 때만 작동하며, 대화형 터미널이 없는 세션은 이를 거부합니다.
  * `/model`, `/effort`, `/fast`, `/color`, `/rename`: 값을 인수로 전달합니다. 예를 들어 `/model sonnet` 또는 `/effort high`와 같습니다. 모바일과 웹에서 `/model`과 `/effort`는 터미널의 선택기나 슬라이더 대신 인수를 받습니다.
  * `/mcp`: 모바일 앱에서는 선택기를 여는 대신 서버 상태의 텍스트 요약을 반환합니다. 웹에서는 `/mcp`만 입력하면 요약을 반환하는 대신 [claude.ai 커넥터](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai) 디렉터리가 열립니다. `reconnect`, `enable`, `disable` [하위 명령](https://code.claude.com/docs/ko/commands.md#all-commands)은 세션이 대화형 터미널에서 실행될 때 양쪽 모두에서 작동합니다. 서버 이름 없이 `/mcp reconnect`를 실행하면 실패했거나 인증이 필요한 모든 서버를 재시도합니다. 선택기 없이 claude.ai 커넥터를 인가하려면 [Authorize a connector again from your shell](#authorize-a-connector-again-from-your-shell)을 참조하세요.
  * `/config`: 모바일 앱에서는 `key=value`를 전달하여 설정을 지정하거나, 인수 없이 실행하여 설정할 수 있는 키 목록을 확인합니다. 웹에서는 `/config`가 대신 **Settings > Code** 또는 **Settings > Claude Code**를 엽니다.
  * Team 및 Enterprise에서는 모바일이나 웹에서 `/usage-credits`를 실행해도 [관리자에게 사용량 크레딧 요청](https://code.claude.com/docs/ko/costs.md#add-usage-credits-to-your-subscription)이 전송되지 않습니다. 전송하려면 대화형 CLI에서만 표시되는 확인이 필요하므로, 명령은 대신 그곳에서 실행하라고 안내합니다.
  * `/autocompact`, v2.1.221부터: 윈도우 크기를 인수로 전달합니다. 예를 들어 `/autocompact 500k`와 같습니다. 인수 없이 실행하면 터미널 세션에서 이 명령이 표시하는 대화 상자를 여는 대신 현재 윈도우 크기를 텍스트로 출력합니다.
  * `/advisor`, v2.1.260부터: 모델을 인수로 전달하거나(예: `/advisor opus`), `off`를 전달하여 advisor를 끕니다. 두 형식 모두 현재 세션에만 적용되며 저장된 기본값은 변경되지 않습니다. 인수 없이 실행하면 선택기를 여는 대신 현재 advisor를 텍스트로 출력합니다.
  * `/output-style`, v2.1.269부터: 스타일 이름을 인수로 전달하거나(예: `/output-style concise`), 인수 없이 실행하여 스타일 목록을 확인합니다. 모바일과 웹에서는 [기본 제공 스타일](https://code.claude.com/docs/ko/output-styles.md#built-in-output-styles)만 나열하고 선택할 수 있습니다. [사용자 지정 스타일](https://code.claude.com/docs/ko/output-styles.md#create-a-custom-output-style)을 사용하려면 세션 자체에서 선택합니다.
  * `/focus`, v2.1.281부터: `on` 또는 `off`를 인수로 전달하거나(예: `/focus on`), 인수 없이 실행하여 [포커스 뷰](https://code.claude.com/docs/ko/commands.md#all-commands)를 전환합니다. 두 형식 모두 현재 세션에만 적용되며 저장된 선택은 변경되지 않습니다.

## 셸에서 커넥터 다시 인가하기

Remote Control로 조작하는 세션에서 claude.ai 커넥터에 인증이 필요한 경우, 모바일 앱이나 웹에서는 `/mcp` 패널을 사용할 수 없습니다. 세션이 실행 중인 머신의 터미널에서 인가 링크를 받은 다음, 사용 중인 기기에서 해당 링크를 엽니다. 이 명령은 모바일 앱이나 웹에서 실행할 수 없습니다. 그곳에서 보내는 `!`로 시작하는 줄은 Claude에게 메시지로 전달되며 [셸 모드](https://code.claude.com/docs/ko/interactive-mode.md#shell-mode-with-prefix)에서 실행되지 않습니다.

**1. 인가 링크 받기**

SSH를 통한 접속 등으로 세션이 실행 중인 머신의 터미널에서 커넥터 이름을 따옴표로 묶어 `claude mcp login`을 실행합니다. 커넥터 이름은 `claude.ai`로 시작하며, 예를 들어 Slack 커넥터의 이름은 `claude.ai Slack`입니다. 다음 명령은 Slack 커넥터의 링크를 받습니다:

```bash theme={null}
claude mcp login "claude.ai Slack" --no-browser
```

이 명령은 claude.ai 링크를 출력한 후 종료됩니다. 브라우저에서 링크를 열고 claude.ai에서 인가를 완료합니다. `--no-browser`는 명령이 해당 머신에서 브라우저를 열지 않도록 합니다. 해당 머신은 사용 중인 기기가 아닐 수 있기 때문입니다.

**2. 세션에서 커넥터 사용하기**

새 세션을 시작하거나, 이미 실행 중인 세션에서 커넥터를 다시 연결합니다:

* **새 세션**: 인가 후에 시작하는 세션은 추가 단계 없이 커넥터에 연결됩니다.
* **실행 중인 세션**: Claude Code 프롬프트에서 또는 모바일 앱이나 웹에서 동일한 이름을 따옴표 없이 사용하여 `/mcp reconnect`를 실행합니다. 세션이 모바일 앱이나 웹에서 이 명령을 받아들이는지 확인하려면 [모바일과 웹에서 작동하는 명령](#limitations)의 `/mcp` 항목을 참조하세요.

다음 명령은 Slack 커넥터를 다시 연결합니다:

```text theme={null}
/mcp reconnect claude.ai Slack
```

터미널에서는 Claude Code가 `Successfully reconnected to claude.ai Slack`을 출력합니다. 모바일 앱이나 웹에서의 응답은 `Reconnected "claude.ai Slack".`입니다.

## 문제 해결

### "Remote Control disconnected" or "Can't reach"

[claude.ai/code](https://claude.ai/code) 또는 Desktop 앱에서 **Remote Control disconnected** 또는 **Can't reach** 메시지가 표시되면 브라우저나 앱이 컴퓨터의 Claude Code와 연결이 끊어졌다는 의미입니다. 두 메시지 모두 Claude나 지켜보던 서브에이전트가 컴퓨터에서 여전히 작업 중인지는 알려 주지 않습니다. 해당 컴퓨터에서 Claude Code가 어떤 상태인지 확인하고, 그에 맞는 단계에 따라 다시 연결합니다:

* **대화형 세션에 `Remote Control disconnected`가 표시됨**: [해당 줄에 표시된 이유에 맞는 재연결 단계](#session-ended-elsewhere)를 따릅니다
* **Claude Code가 실행 중이며 실패가 표시되지 않음**: 대화형 세션은 머신이 절전 모드에서 깨어나 온라인 상태가 되면 자동으로 다시 연결되므로 별도의 조치가 필요하지 않습니다. `claude remote-control`을 사용한 경우 [제한 사항](#limitations)의 **Extended network outage**를 참조하세요
* **Claude Code가 실행 중이 아님**: [다시 시작하여 세션을 복구합니다](#resume-sessions-after-stopping-the-server)

### "Remote Control requires a claude.ai subscription"

Claude.ai 계정으로 로그인하지 않았거나 다른 자격 증명이 로그인보다 우선순위를 가지고 있습니다. 메시지는 다음 중 하나의 형태를 띱니다:

* 로그아웃 상태, `/remote-control` 또는 `--remote-control`에서: `Remote Control requires a claude.ai subscription.` 또는 `/remote-control requires a claude.ai subscription.`
* 로그아웃 상태, `claude remote-control`에서: `You must be logged in to use Remote Control. Remote Control is only available with claude.ai subscriptions.`
* 로그인 상태이지만 API 키 또는 토큰이 사용 중: `Remote Control requires claude.ai subscription auth.` 뒤에 사용 중인 자격 증명이 따라옵니다. 예: `ANTHROPIC_API_KEY is set, so this session is using API-key auth`. `apiKeyHelper` 설정과 `ANTHROPIC_AUTH_TOKEN`도 같은 방식으로 명명됩니다.

`claude auth login`을 실행하고 claude.ai 옵션을 선택합니다. 메시지에 `ANTHROPIC_API_KEY` 또는 `ANTHROPIC_AUTH_TOKEN`이 명시되어 있으면, 설정된 위치(셸 환경 또는 [설정 파일](https://code.claude.com/docs/ko/settings-reference.md#env)의 `env` 블록)에서 제거합니다. `apiKeyHelper`가 명시되어 있으면 해당 설정을 제거합니다.

### "Remote Control requires a full-scope login token"

`claude setup-token` 또는 `CLAUDE_CODE_OAUTH_TOKEN` 환경 변수에서 얻은 장기 토큰으로 인증되었습니다. 이러한 토큰은 모델 요청만 수행할 수 있으므로 Remote Control 세션을 설정할 수 없습니다. 대신 `claude auth login`을 실행하여 전체 범위 세션 토큰으로 인증합니다.

### "Unable to determine your organization for Remote Control eligibility"

캐시된 계정 정보가 오래되었거나 불완전합니다. `claude auth login`을 실행하여 새로고침합니다.

### "Remote Control isn't enabled for this account"

Claude Code가 로그인한 계정의 Remote Control 가용성을 확인했고 비활성화 상태로 반환되었습니다. 일반적인 원인은 플랜 변경 후 오래된 캐시된 권한입니다. `claude auth logout`을 실행한 후 `claude auth login`을 실행하여 새로고침하고, 이전 버전을 사용 중인 경우 Claude Code를 업데이트합니다.

`claude doctor`를 실행하여 어떤 개별 적격성 확인이 실패했는지 확인합니다. 환경 변수 충돌, 도달 불가능한 확인, 조직의 Remote Control 설정은 각각 자신의 메시지를 생성하므로, 이 오류는 계정 수준 확인 자체를 의미합니다.

v2.1.239 이전에는 이 메시지가 "Remote Control is not yet enabled for your account"로 표시되었습니다.

### "Couldn't verify Remote Control eligibility"

Claude Code가 Remote Control이 계정에 대해 활성화되어 있는지 확인하기 위해 기능 플래그 서비스에 도달할 수 없습니다. 일반적으로 오프라인 상태이거나 프록시가 요청을 차단하고 있기 때문입니다. 네트워크 액세스가 있으면 다시 시도하거나 `claude doctor`를 실행하여 세부 정보를 확인합니다. 관련 메시지 "Couldn't verify your organization's Remote Control policy"는 Claude Code가 해당 정책을 읽는 중에 오류가 발생했음을 의미하며, 동일한 해결 방법이 있습니다.

### "Remote Control requires feature-flag evaluation"

기능 플래그 평가를 비활성화하는 [환경 변수](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching)가 설정되어 있으며, 전체 메시지는 Claude Code가 찾은 변수를 명시합니다. v2.1.154 이전 버전에서는 동일한 구성이 대신 "Remote Control is not yet enabled for your account"를 생성합니다. 수행할 작업은 메시지가 명시하는 변수에 따라 다릅니다:

* **`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` 또는 `DISABLE_GROWTHBOOK`**: 설정된 위치(셸 환경 또는 [`settings.json` 파일](https://code.claude.com/docs/ko/settings-reference#all-settings)의 `env` 블록)에서 변수를 설정 해제합니다.
* **`DISABLE_TELEMETRY` 또는 `DO_NOT_TRACK`**: Pro, Max, Ultra, Team 또는 Enterprise 플랜에서 `DISABLE_GROWTHBOOK`이 설정 해제된 경우, 이러한 변수는 조직이 [Trusted Devices](#trusted-devices)를 요구하지 않는 한 Remote Control을 사용 가능하게 둡니다. 요구하는 경우, Remote Control을 사용하기 위해 설정된 위치에서 변수를 설정 해제합니다. v2.1.154부터 v2.1.282까지는 어느 변수든 설정되어 있으면 이 메시지가 표시되므로, Claude Code를 [이러한 변수에 대한 요구 사항](#requirements)을 충족하는 버전으로 업데이트합니다.

### "Remote Control is only available when using Claude via api.anthropic.com"

세션이 Anthropic API와 직접 통신하지 않고 있으며, Remote Control에는 직접 통신이 필요합니다. 이는 Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry에서 발생합니다. [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)이 `api.anthropic.com` 이외의 호스트(예: [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 또는 프록시)를 가리킬 때도 발생하며, claude.ai로 로그인한 경우에도 마찬가지입니다. 전체 원인 목록은 [오류 참조](https://code.claude.com/docs/ko/errors.md#remote-control-requires-the-anthropic-api)를 참조하세요.

메시지는 세션을 Anthropic API에서 멀어지게 한 것을 명시합니다. 예: `CLAUDE_CODE_USE_BEDROCK` 또는 사용자 정의 `ANTHROPIC_BASE_URL`. 적격 claude.ai 로그인이 있으면, 명시된 변수를 설정 해제하고, [설정](https://code.claude.com/docs/ko/settings.md)에서 `env` 키에 설정한 경우 제거한 후 세션을 다시 시작합니다.

### "Remote Control is disabled by your organization's policy"

정책이 Remote Control을 차단합니다. 다음 원인을 순서대로 확인합니다:

* **오류에 `disableRemoteControl`이 언급됨**: IT 관리자가 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 통해 이 장치에서 Remote Control을 비활성화했으며, 조직 전체 토글 및 로그인 방식과 무관합니다.
* **Claude.ai 플랜이 Pro, Max 또는 Ultra**: Claude Code가 여전히 이전 로그인의 Team 또는 Enterprise 조직 아래에 로그인되어 있으므로, 해당 조직의 Remote Control 정책을 확인합니다. `/status`를 실행하여 로그인이 사용하는 플랜과 조직을 확인합니다. `claude auth logout`을 실행한 후 `claude auth login`을 실행하여 현재 플랜 아래에서 다시 로그인합니다.
* **메시지에 조직 관리자에게 문의하라고 하지 않음**: 조직에 [HIPAA 구성](https://code.claude.com/docs/ko/hipaa-setup.md)이 적용되어 있으며, 이 구성은 Remote Control을 끕니다. 확인하려면 `/status`를 실행하고 `Organization configuration` 행에서 `HIPAA`를 찾습니다. Owner에게는 [관리자 설정](https://claude.ai/admin-settings/claude-code)의 **Remote Control** 토글이 회색으로 표시되며 켤 수 없습니다. 구성에 대해 궁금한 점이 있으면 Owner에게 문의하세요. Owner는 조직의 Anthropic 계정 팀에 연락할 수 있습니다. v2.1.267 이전에는 이 경우 "Remote Control isn't available for your organization due to its compliance policy"로 표시되었습니다.
* **Remote Control이 조직의 다른 구성원에게는 작동하지만 사용자에게는 작동하지 않음**: Enterprise 조직이 [사용자 지정 역할](https://support.claude.com/en/articles/13930452)로 액세스를 관리하는 경우, 사용자의 역할이 원인일 수 있습니다. Remote Control에는 클라우드 세션 권한과 **Claude Code remote control** 권한이 모두 필요합니다. Owner에게 역할에 두 권한이 모두 포함되어 있는지 확인하고 누락된 권한을 [**Organization settings > Roles**](https://claude.ai/admin-settings/roles)에서 추가하도록 요청하세요.
* **그 외의 경우, Owner가 조직에 대해 활성화하지 않음**: Remote Control은 Team 및 Enterprise 플랜에서 기본적으로 비활성화됩니다. Owner는 [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code)에서 **Remote Control** 토글을 켜서 활성화할 수 있습니다. 이 토글은 서버 측 조직 설정입니다.

v2.1.281 이전에는 이 메시지가 Claude Code가 이 머신에서 조직의 정책을 로드하지 않았을 때도 나타났습니다. 예를 들어 오프라인으로 시작한 후입니다. 이후 버전은 해당 상태를 [`Couldn't verify your organization's policy for remote control`](#couldnt-verify-your-organizations-policy-for-remote-control)로 보고합니다.

### "Remote Control was turned off by your organization's policy"

세션이 연결되어 있는 동안 조직의 정책이 Remote Control 허용을 중단하여 Claude Code가 연결을 해제했습니다. 세션이 어떻게 되는지는 Remote Control을 시작한 방법에 따라 다릅니다:

* **`/remote-control`, `claude --remote-control` 또는 [자동 연결](#enable-remote-control-for-all-sessions)로 시작한 경우**: 세션은 Remote Control 없이 계속 실행되며, Claude Code는 claude.ai에서 해당 세션을 보관합니다
* **`claude remote-control`로 시작한 경우**: 서버가 중지되고 제공하던 세션을 보관한 후 종료됩니다

이러한 세션을 다시 찾으려면 claude.ai/code에서 [보관된 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#find-an-archived-session)을 엽니다.

Remote Control은 자동으로 다시 연결되지 않습니다. 조직이 다시 허용한 후 Remote Control을 다시 켜려면 세션에서 `/remote-control`을 실행하거나 셸에서 `claude remote-control`을 실행합니다. 이 머신의 Claude Code가 변경된 정책을 가져올 때까지 두 명령 모두 [`Remote Control is disabled by your organization's policy`](#remote-control-is-disabled-by-your-organizations-policy)로 실패합니다. 열려 있는 세션은 약 1시간에 한 번 정책을 가져옵니다. 무엇이 Remote Control을 차단하고 있는지 확인하려면 명령이 출력하는 전체 텍스트를 해당 항목과 대조합니다.

### "Couldn't verify your organization's policy for remote control"

Claude Code가 조직의 정책을 가져올 수 없으며 이 머신에 대신 사용할 저장된 복사본이 없으므로, 조직이 이를 허용한다는 것을 확인할 때까지 Remote Control을 비활성화 상태로 유지합니다. 이는 일반적으로 Claude Code를 오프라인으로 시작하거나 VPN이 연결되기 전에 시작할 때, 또는 프록시가 요청을 방해할 때 발생합니다. 느린 연결에서는 첫 번째 요청이 아직 진행 중일 때도 나타날 수 있습니다.

메시지는 다음 중 하나의 형태를 띱니다:

* `/remote-control`, `claude remote-control` 또는 `claude --remote-control`에서: `Couldn't verify your organization's policy for remote control. Check your network connection and try again.`
* [자동 연결](#enable-remote-control-for-all-sessions)에서 세션이 시작될 때: `couldn't verify your organization's policy — check your network connection and try again`. 알림에서 `Remote Control failed`로 접두사가 붙고 대화에서 `Remote Control disconnected`로 접두사가 붙습니다. 그러면 세션이 Remote Control을 비활성화 상태로 둡니다.

네트워크 연결을 복구한 후 `/remote-control`을 실행하거나 명령을 다시 실행합니다. 각 시도는 정책을 다시 확인하므로 Claude Code를 다시 시작할 필요가 없습니다. 메시지가 계속 나타나면 `claude doctor`를 실행하고 `Organization policy` 행을 읽으면 정책이 로드되지 않은 이유가 표시됩니다.

v2.1.281 이전에는 이 상태가 `Remote Control is disabled by your organization's policy`로 표시되었습니다.

### "Remote credentials fetch failed"

Claude Code가 Anthropic API에서 연결을 설정하기 위한 단기 자격 증명을 얻을 수 없습니다. `--verbose`로 다시 실행하여 전체 오류를 확인합니다:

```bash theme={null}
claude remote-control --verbose
```

일반적인 원인:

* 로그인하지 않음: `claude`를 실행하고 `/login`을 사용하여 claude.ai 계정으로 인증합니다. API 키 인증은 Remote Control에 지원되지 않습니다.
* 네트워크 또는 프록시 문제: 방화벽 또는 프록시가 아웃바운드 HTTPS 요청을 차단할 수 있습니다. Remote Control은 포트 443의 Anthropic API에 대한 액세스가 필요합니다.
* 세션 생성 실패: `Session creation failed — see debug log`도 표시되면, 실패가 설정의 이전 단계에서 발생했습니다. 구독이 활성화되어 있는지 확인합니다.

### "Couldn't reconnect to your Remote Control session"

`claude --resume` 또는 `claude --continue`로 대화를 재개할 때, Claude Code는 해당 대화에 기록된 Remote Control 세션에 다시 연결합니다. 이 메시지는 네트워크 중단 또는 서버 오류와 같이 일시적일 수 있는 이유로 재연결이 실패했음을 의미하므로, Claude Code는 원격 세션이 여전히 존재하는지 확인할 수 없습니다.

`/remote-control`을 실행하여 연결을 다시 시도하거나, `claude --remote-control`로 새 세션을 시작하여 새 Remote Control 세션을 만듭니다. 로컬 세션은 그 동안 Remote Control 없이 계속 실행됩니다.

### "Previous session is unavailable — run /remote-control to start a new one"

Claude Code가 이전 Remote Control 세션을 복구할 수 없었고 자체적으로 새 세션을 시작하지 않고 대신 중지했습니다. `claude --resume` 또는 `claude --continue`로 대화를 재개한 후, 또는 Claude Code가 [연결 해제 후 자체적으로 다시 연결](https://code.claude.com/docs/ko/errors.md#remote-control-couldnt-refresh-your-login)한 후 이 메시지를 볼 수 있습니다.

`/remote-control`을 실행하여 현재 로그인 아래에서 새 Remote Control 세션을 시작합니다. 로컬 세션은 그 동안 Remote Control 없이 계속 실행됩니다. 관련 메시지 `Remote Control could not verify the signed-in account — run /remote-control to reconnect`는 동일한 해결 방법이 있습니다. Claude Code를 다시 시작하지 않고 `Previous session is unavailable` 후에 `/remote-control`을 실행하면, Claude Code는 대화의 이전 메시지를 새 세션에서 제외합니다.

### "Remote Control got an unexpected server response"

Remote Control 서버가 요청을 수락했지만 이 버전의 Claude Code가 읽을 수 없는 형태로 응답했으며, 원격 세션을 생성하거나 자격 증명을 가져올 때입니다. 동일한 버전에서 다시 시도하면 동일한 방식으로 실패합니다. `claude update`를 실행한 후 `/remote-control`을 실행하여 다시 연결합니다.

### "Your organization requires Trusted Devices for Remote Control, but this device is not enrolled"

조직이 [Trusted Devices](#trusted-devices)를 활성화했으며 이 머신이 아직 등록되지 않았습니다. Claude Code에서 `/login`을 실행합니다. 등록은 로그인의 일부로 발생하며 별도의 등록 명령이 없습니다.

### "session expired for trusted-device check"

로그인이 18시간 이상 경과했습니다. Claude Code에서 `/login`을 실행하거나, claude.ai 또는 모바일 앱이 Face ID, Touch ID, Windows Hello 또는 passkey로 확인하라고 할 때 확인합니다. [Trusted Devices](#trusted-devices)를 참조하세요.

## 관련 리소스

* [웹의 Claude Code](https://code.claude.com/docs/ko/claude-code-on-the-web.md): 머신 대신 클라우드에서 세션을 실행하며, [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md)을 통해 구성합니다
* [크로스 세션 메시징](https://code.claude.com/docs/ko/cross-session-messaging.md): Claude가 다른 머신이나 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)으로 메시지를 보낼 수 있습니다
* [채널](https://code.claude.com/docs/ko/channels.md): Telegram, Discord 또는 iMessage를 세션으로 전달하여 Claude가 자리를 비운 동안 메시지에 반응하도록 합니다
* [Dispatch](https://code.claude.com/docs/ko/desktop.md#sessions-from-dispatch): 휴대폰에서 작업을 메시지로 보내면 Desktop 세션을 생성하여 처리할 수 있습니다
* [인증](https://code.claude.com/docs/ko/authentication.md): `/login` 설정 및 claude.ai 자격 증명 관리
* [CLI 참조](https://code.claude.com/docs/ko/cli-reference.md): `claude remote-control`을 포함한 플래그 및 명령의 전체 목록
* [보안](https://code.claude.com/docs/ko/security.md): Remote Control 세션이 Claude Code 보안 모델에 어떻게 적합한지
* [데이터 사용](https://code.claude.com/docs/ko/data-usage.md): 로컬, Remote Control 및 클라우드 세션 중에 Anthropic API를 통해 흐르는 데이터
