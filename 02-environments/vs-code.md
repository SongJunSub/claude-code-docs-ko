> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# VS Code에서 Claude Code 사용하기

> VS Code용 Claude Code 확장 프로그램을 설치하고 구성합니다. 인라인 diff, @-멘션, 계획 검토 및 키보드 단축키를 통해 AI 코딩 지원을 받습니다.

![VS Code 편집기와 오른쪽에 열린 Claude Code 확장 프로그램 패널, Claude와의 대화를 표시](https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?fit=max\&auto=format\&n=-YhHHmtSxwr7W8gy\&q=85\&s=300652d5678c63905e6b0ea9e50835f8)

VS Code 확장 프로그램은 Claude Code를 위한 기본 그래픽 인터페이스를 제공하며, IDE에 직접 통합됩니다. 이것이 VS Code에서 Claude Code를 사용하는 권장 방법입니다.

확장 프로그램을 사용하면 다음을 수행할 수 있습니다.

* Claude의 계획을 수락하기 전에 검토하고 편집
* 편집이 이루어질 때 자동으로 수락
* 선택 항목에서 특정 줄 범위가 있는 파일을 @-멘션
* 대화 기록에 액세스
* 별도의 탭이나 창에서 여러 대화 열기

## 필수 조건

설치하기 전에 다음을 확인하십시오:

* VS Code 1.94.0 이상
* Anthropic 계정: 모든 유료 Claude 구독(Pro, Max, Ultra, Team 또는 Enterprise) 또는 Claude Console 계정이 작동하며, API 키가 필요하지 않습니다. 확장 프로그램을 처음 열 때 이 계정으로 [로그인](https://code.claude.com/docs/ko/authentication.md#log-in-to-claude-code)합니다. Amazon Bedrock이나 Google Cloud의 Agent Platform과 같은 타사 공급자를 통해 Claude에 액세스하는 경우 설정 지침은 [타사 공급자 사용](#use-third-party-providers)을 참조하십시오.

> [!TIP]
>
> 확장 프로그램에는 채팅 패널용 CLI(명령줄 인터페이스)의 자체 복사본이 포함되어 있습니다. VS Code의 통합 터미널에서 `claude`를 실행하려면 [독립 실행형 CLI 설치](https://code.claude.com/docs/ko/setup.md)도 필요합니다. 자세한 내용은 [VS Code 확장 프로그램 vs. Claude Code CLI](#vs-code-extension-vs-claude-code-cli)를 참조하십시오.

## 확장 프로그램 설치

사용 중인 IDE의 링크를 클릭하여 바로 설치합니다:

* [VS Code용 설치](vscode:extension/anthropic.claude-code)
* [Cursor용 설치](cursor:extension/anthropic.claude-code)

또는 VS Code에서 `Cmd+Shift+X`(Mac) 또는 `Ctrl+Shift+X`(Windows/Linux)를 눌러 Extensions 보기를 열고, "Claude Code"를 검색한 다음 **Install**을 클릭합니다.

> [!NOTE]
>
> 확장 프로그램 마켓플레이스는 서드파티 소프트웨어로, Anthropic이 보증, 유지 관리 또는 감사하지 않습니다. Anthropic은 Visual Studio Marketplace와 Open VSX Registry에 확장 프로그램 게시를 신청합니다.

확장 프로그램의 버전 번호는 확장 프로그램에 번들로 포함된 Claude Code 버전입니다. 예를 들어 Claude Code v2.1.286 이상이 필요한 기능을 사용하려면 확장 프로그램 버전 2.1.286 이상이 필요하며, 이 버전은 Extensions 보기에서 확인할 수 있습니다.

Claude Code는 다른 편집기와 컨테이너에서도 실행됩니다:

* **기타 VS Code 포크**: 이 확장 프로그램은 Devin Desktop이나 Kiro 같은 포크에도 설치할 수 있습니다. 에디터의 Extensions 뷰에서 "Claude Code"를 검색하거나 [Open VSX Registry](https://open-vsx.org/extension/Anthropic/claude-code)에서 설치하세요.
* **확장 프로그램을 설치할 수 없는 편집기**: 대신 [CLI를 설치](https://code.claude.com/docs/ko/quickstart.md)하고 편집기의 통합 터미널에서 `claude`를 실행합니다. CLI는 모든 터미널에서 작동합니다.
* **개발 컨테이너**: 개발 컨테이너 내부에서 Claude Code를 실행하려면 [개발 컨테이너](https://code.claude.com/docs/ko/devcontainer.md)를 참조하세요.

> [!NOTE]
>
> 설치 후 확장 프로그램이 나타나지 않으면 VS Code를 다시 시작하거나 Command Palette에서 "Developer: Reload Window"를 실행합니다.

## 시작하기

설치가 완료되면 VS Code 인터페이스를 통해 Claude Code를 사용할 수 있습니다.

**1. Claude Code 패널 열기**

VS Code 전반에서 Spark 아이콘은 Claude Code를 나타냅니다: ![Spark 아이콘](https://mintcdn.com/claude-code/c5r9_6tjPMzFdDDT/images/vs-code-spark-icon.svg?fit=max\&auto=format\&n=c5r9_6tjPMzFdDDT\&q=85\&s=3ca45e00deadec8c8f4b4f807da94505)

Claude를 가장 빠르게 여는 방법은 **Editor Toolbar**(에디터 오른쪽 상단 모서리)에서 Spark 아이콘을 클릭하는 것입니다. 이 아이콘은 파일이 열려 있을 때만 표시됩니다.

![Editor Toolbar에 Spark 아이콘이 표시된 VS Code 에디터](https://mintcdn.com/claude-code/mfM-EyoZGnQv8JTc/images/vs-code-editor-icon.png?fit=max\&auto=format\&n=mfM-EyoZGnQv8JTc\&q=85\&s=eb4540325d94664c51776dbbfec4cf02)

Claude Code를 여는 다른 방법은 다음과 같습니다.

* **Activity Bar**: 왼쪽 사이드바에서 Spark 아이콘을 클릭하면 세션 목록이 열립니다. 세션을 클릭하면 [선호하는 위치](#extension-settings)에서 열리며, 새 세션을 시작할 수도 있습니다. 이 아이콘은 Activity Bar에 항상 표시됩니다.
* **Command Palette**: `Cmd+Shift+P`(Mac) 또는 `Ctrl+Shift+P`(Windows/Linux)를 누르고 "Claude Code"를 입력한 다음 "Open in New Tab"과 같은 옵션을 선택합니다.
* **Status Bar**: 창 오른쪽 하단 모서리의 **✻ Claude Code**를 클릭합니다. 파일이 열려 있지 않아도 작동합니다.

Claude 패널을 드래그하여 VS Code 내 원하는 위치로 옮길 수 있습니다. 자세한 내용은 [워크플로 사용자 지정](#customize-your-workflow)을 참조하세요.

**2. 로그인**

패널을 처음 열면 로그인 화면이 나타납니다. **Sign in**을 클릭하고 브라우저에서 인증을 완료합니다.

이후 **Not logged in · Please run /login**이 표시되면 확장 프로그램이 자동으로 로그인 화면을 다시 엽니다. 로그인 화면이 나타나지 않으면 Command Palette에서 **Developer: Reload Window**로 창을 다시 로드합니다.

셸에 `ANTHROPIC_API_KEY`를 설정했는데도 로그인 프롬프트가 표시된다면 VS Code가 셸 환경을 상속하지 못했을 수 있습니다. 환경 변수를 상속하도록 터미널에서 `code .`로 VS Code를 실행하거나, 대신 Claude 계정으로 로그인합니다.

로그인하면 **Learn Claude Code** 체크리스트가 나타납니다. **Show me**를 클릭하여 각 항목을 진행하거나 X를 눌러 닫을 수 있습니다. 나중에 다시 열려면 VS Code 설정의 **Extensions > Claude Code**에서 **Hide Onboarding**의 체크를 해제합니다.

**3. 프롬프트 보내기**

무언가의 작동 방식 설명, 문제 디버깅, 변경 작업 등 코드나 파일과 관련된 도움을 Claude에게 요청합니다.

> [!TIP]
>
> Claude는 선택한 텍스트를 자동으로 인식합니다. `Option+K`(Mac) / `Alt+K`(Windows/Linux)를 누르면 @-멘션 참조(예: `@file.ts#5-10`)도 프롬프트에 삽입됩니다.

다음은 파일의 특정 줄에 대해 질문하는 예시입니다.

![Python 파일에서 2-3번째 줄이 선택된 VS Code 에디터와, 해당 줄에 대한 질문을 @-멘션 참조와 함께 보여주는 Claude Code 패널](https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-send-prompt.png?fit=max\&auto=format\&n=FVYz38sRY-VuoGHA\&q=85\&s=ede3ed8d8d5f940e01c5de636d009cfd)

**4. 변경 사항 검토**

프롬프트 상자 하단에 표시된 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md#which-mode-a-session-starts-in)를 확인합니다.

* Auto 또는 Edit automatically 모드에서는 Claude가 확인 없이 워크스페이스의 [대부분의 파일](https://code.claude.com/docs/ko/permission-modes.md#protected-paths)을 편집합니다.
* Manual 모드에서는 Claude가 파일을 편집하려 할 때 원본과 제안된 변경 사항을 나란히 비교하여 보여준 다음 권한을 요청합니다. 수락하거나 거부할 수 있으며, 대신 무엇을 해야 할지 Claude에게 지시할 수도 있습니다. 수락하기 전에 diff 보기에서 제안된 내용을 직접 편집하면, Claude는 사용자가 내용을 수정했다는 사실을 전달받으므로 파일이 원래 제안과 일치한다고 가정하지 않습니다.

  ![편집 여부를 묻는 권한 프롬프트와 함께 Claude가 제안한 변경 사항의 diff를 보여주는 VS Code](https://mintcdn.com/claude-code/FVYz38sRY-VuoGHA/images/vs-code-edits.png?fit=max\&auto=format\&n=FVYz38sRY-VuoGHA\&q=85\&s=e005f9b41c541c5c7c59c082f7c4841c)

제안된 편집을 변경 하나씩 검토하려면 diff의 각 변경 아래에 있는 **Accept this change** 및 **Reject this change** 버튼을 사용합니다. 변경을 거부하면 제안된 내용에서 해당 변경이 되돌려지고, 수락하면 검토 완료로 표시됩니다. 변경별 검토에는 Claude Code v2.1.275 이상이 필요합니다.

파일 전체를 수락하거나 거부해도 검토가 완료됩니다. 변경이 100개를 초과하는 diff는 변경별 버튼 없이 열리므로 파일 전체 단위로 검토합니다.

동일한 작업은 에디터의 컨텍스트 메뉴에서 커서 위치에 대해 수행할 수 있으며, Command Palette에서도 **Claude Code: Accept Change at Cursor** 및 **Claude Code: Reject Change at Cursor**로 사용할 수 있습니다.

Claude Code로 할 수 있는 작업에 대한 더 많은 아이디어는 [일반적인 워크플로](https://code.claude.com/docs/ko/common-workflows.md)를 참조하세요.

> [!TIP]
>
> 기본 사항을 안내받으려면 Command Palette에서 "Claude Code: Open Walkthrough"를 실행하세요.

## 프롬프트 상자 사용하기

프롬프트 상자는 여러 기능을 지원합니다.

* **권한 모드**: 프롬프트 상자 하단의 모드 표시기를 클릭하여 권한 모드를 전환합니다. Claude Code v2.1.283 이상에서는 Auto가 기본 제공 시작 권한 모드이며, 이전 버전에서는 Pro, Max, Ultra, Team 플랜에서만 그렇습니다. 이를 바꾸는 요인과 표시기가 제공하는 모든 권한 모드는 [확장 프로그램이 시작 권한 모드를 선택하는 방식](https://code.claude.com/docs/ko/permission-modes.md#switch-permission-modes)을 참조하세요.
  * **Auto**: 사용자에게 묻는 대신 분류기가 대부분의 작업을 검토합니다. 검토 및 차단 대상은 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)를 참조하세요.
  * **Manual**: Claude가 파일 편집 및 대부분의 셸 명령 전에 권한을 요청합니다.
  * **Plan**: Claude가 수행할 작업을 설명하고 변경하기 전에 승인을 기다립니다. VS Code는 플랜을 전체 Markdown 문서로 자동으로 열며, Claude가 작업을 시작하기 전에 인라인 댓글을 추가하여 피드백을 제공할 수 있습니다.

    프롬프트 상자에 `/plan`을 입력할 수도 있습니다. Claude Code v2.1.280 이상이 필요합니다.

    * `/plan`: 플랜 모드로 전환합니다. 이미 플랜 모드인 경우 현재 플랜을 대신 보여줍니다.
    * `/plan fix the auth bug`처럼 작업과 함께 입력한 `/plan`: 플랜 모드로 전환하고 해당 작업의 계획을 시작합니다.
    * `/plan open`: 이미 플랜 모드인 경우 편집기에서 플랜 파일을 엽니다.
  * **Edit automatically**: Claude가 묻지 않고 편집합니다.
* **모델**: 명령 메뉴에서 \*\*Switch model…\*\*을 선택하여 세션 중에 모델을 변경합니다. 프롬프트 상자 하단의 모델 이름을 클릭하여 같은 선택기를 열 수도 있습니다. Claude Code v2.1.284 이상에서는 프롬프트 상자에 `/model`만 입력해도 선택기가 열립니다.

  현재 모델이 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)을 지원하는 경우 선택기에 **Effort** 행도 표시되며, 모델 이름 버튼에 선택된 수준이 표시됩니다. `max` 이외의 수준을 선택하면 Claude Code는 이를 현재 모델의 기본값으로 사용자 설정의 [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings) 아래에 저장합니다. `max`는 현재 세션에만 적용됩니다. 모델 이름 버튼과 **Effort** 행에는 Claude Code v2.1.257 이상이 필요합니다.

  [동적 워크플로](https://code.claude.com/docs/ko/workflows.md)가 활성화되어 있고 현재 모델이 이를 지원하면 **Effort** 행 아래에 **Ultracode** 스위치가 나타납니다. 이를 켜면 Claude가 이 세션의 각 실질적인 작업에 대해 선택된 effort 수준으로 [워크플로](https://code.claude.com/docs/ko/workflows.md#let-claude-decide-with-ultracode)를 계획합니다. 켜져 있는 동안 모델 이름 버튼에는 수준 뒤에 `· Ultracode`가 표시됩니다. 이 스위치에는 Claude Code v2.1.284 이상이 필요합니다.
* **명령 메뉴**: `/`를 클릭하거나 입력하여 명령 메뉴를 엽니다. 파일 첨부, 모델 전환 등의 옵션이 있습니다.

  Customize 섹션에는 MCP 서버, 명령, 출력 스타일, 훅, 메모리, 지침, 권한, 플러그인 같은 항목이 포함됩니다. 터미널 아이콘이 있는 항목은 통합 터미널에서 열립니다.

  * `/usage`나 [`/remote-control`](https://code.claude.com/docs/ko/remote-control) 같은 명령을 찾아보려면 Customize 섹션에서 **Slash commands**를 선택합니다. 필터 상자와 함께 명령 목록이 대화 상자에 표시됩니다. 하나를 선택하면 실행됩니다. 프롬프트 상자에 `/`를 입력하면 여전히 인라인으로 명령이 제안됩니다. Claude Code v2.1.257 이상이 필요합니다.

    `/skills`를 입력해도 이 대화 상자가 열립니다. 각 [스킬](https://code.claude.com/docs/ko/skills.md) 행에는 **On** 또는 **Name only** 같은 [표시 여부](https://code.claude.com/docs/ko/skills.md#override-skill-visibility-from-settings)가 나타납니다. 표시 여부를 클릭하여 변경할 수 있지만, 플러그인 스킬처럼 **locked**로 표시된 행은 제외됩니다. `/skills` 단축 명령과 표시 여부 컨트롤에는 Claude Code v2.1.280 이상이 필요합니다.
  * Customize 섹션에서 **Output styles**를 선택하여 사용자 지정 스타일을 포함한 [출력 스타일](https://code.claude.com/docs/ko/output-styles.md)을 선택합니다. Claude Code v2.1.257 이상이 필요합니다.

    대신 사용자 지정 스타일을 만들려면 **Output styles** 메뉴에서 **Build a custom style**을 선택합니다. Claude Code가 프로젝트 또는 사용자 수준에서 [스타일 파일](https://code.claude.com/docs/ko/output-styles.md#create-a-custom-output-style)을 대신 작성합니다. Claude Code v2.1.261 이상이 필요합니다.
  * Customize 섹션에서 **Hooks**를 선택하면 세션에 로드된 [훅](https://code.claude.com/docs/ko/hooks.md)을 이벤트별로 그룹화하여 볼 수 있습니다. 사용자, 프로젝트, 로컬 설정 파일에 저장된 훅을 추가, 편집, 제거할 수 있습니다. 관리형 설정이나 플러그인 같은 다른 소스의 훅은 읽기 전용입니다. Claude Code v2.1.269 이상이 필요합니다.
  * Customize 섹션에서 **Permissions**를 선택하면 세션의 [권한 규칙](https://code.claude.com/docs/ko/permissions.md)을 Allow, Ask, Deny로 그룹화하여 볼 수 있습니다. 사용자, 프로젝트 또는 로컬 설정에 규칙을 추가하고 그곳에 저장된 규칙을 제거할 수 있습니다. 관리형 설정이나 이 세션에만 적용되는 승인 같은 다른 소스의 규칙은 읽기 전용입니다. Claude Code v2.1.269 이상이 필요합니다.
  * Customize 섹션에서 **Memory**를 선택하여 [자동 메모리](https://code.claude.com/docs/ko/memory.md#auto-memory)를 켜거나 끕니다. 켜져 있는 동안 Claude가 저장한 메모리를 찾아보고, 메모리가 저장된 폴더를 파일 관리자에서 열 수도 있습니다. Claude Code v2.1.274 이상이 필요합니다.

    저장된 메모리를 클릭하면 대화 상자에서 읽을 수 있으며, 그곳에서 텍스트를 편집하거나 메모리를 삭제하거나 편집기에서 파일을 열 수 있습니다. 대화 상자에서 메모리를 보고, 편집하고, 삭제하려면 Claude Code v2.1.275 이상이 필요합니다.
  * Customize 섹션에서 **Instructions**를 선택하여 Claude가 읽는 [CLAUDE.md 파일](https://code.claude.com/docs/ko/memory.md#claude-md-files)을 편집합니다. 파일을 선택하면 편집기에서 열립니다. 파일이 아직 없으면 Claude Code가 먼저 생성합니다. Claude Code v2.1.274 이상이 필요합니다.
  * Customize 섹션에서 **Status**를 선택하거나 `/status`를 입력하여 세션의 Claude Code 버전, 계정, 모델, MCP 서버 세부 정보를 확인합니다. Claude Code v2.1.280 이상이 필요합니다.
  * Customize 섹션에서 **Sandbox**를 선택하거나 `/sandbox`를 입력하여 Claude의 Bash 명령이 [샌드박스에서](https://code.claude.com/docs/ko/sandboxing.md) 실행되는지 확인합니다. 그곳에서 샌드박스 모드를 전환하고 [제외 명령](https://code.claude.com/docs/ko/settings-reference.md#sandbox-excludedcommands)을 추가할 수 있습니다. Claude Code v2.1.280 이상이 필요합니다.
  * Customize 섹션에서 **Claude in Chrome**을 선택하거나 `/chrome`을 입력하여 [Claude in Chrome](https://code.claude.com/docs/ko/chrome.md) 연결을 확인하고 관리합니다. 두 방법 모두 claude.ai 계정으로 로그인해야 합니다. Claude Code v2.1.280 이상이 필요합니다.
  * Context 섹션에서 **Export conversation**을 선택하거나 `/export`를 입력하여 대화를 일반 텍스트로 복사하거나 파일로 저장합니다. `/export notes.txt`처럼 파일 이름을 추가하면 대화 상자를 건너뛰고 파일을 저장할 위치를 선택할 수 있습니다. Claude Code v2.1.280 이상이 필요합니다.
  * Settings 섹션에는 **Enable Remote Control for all sessions**가 포함되어 있으며, 이는 [`remoteControlAtStartup`](https://code.claude.com/docs/ko/settings-reference#remotecontrolatstartup)을 설정하여 [새 대화형 세션이 Remote Control에 자동으로 연결되는지](https://code.claude.com/docs/ko/remote-control.md#enable-remote-control-for-all-sessions) 여부를 제어합니다. Claude Code v2.1.203 이상이 필요합니다.

    VS Code 창에서 토글을 켜거나 끄면 변경 사항은 이후에 시작하는 세션에만 국한되지 않습니다. 해당 VS Code 창에 이미 열려 있는 세션에도 적용됩니다. 끄면 열려 있는 세션의 연결이 해제됩니다. Claude Code v2.1.261 이상에서는 다른 VS Code 창에 열려 있는 세션에도 변경 사항이 적용됩니다.
  * Settings 섹션에는 **Focus view**도 포함되어 있으며, 이는 도구 호출, 도구 결과, 사고를 확장 가능한 행 뒤에 숨기고 사용자의 프롬프트와 Claude의 응답만 남깁니다. 그곳에서 켜고 끄거나, `Ctrl+Option+F`(Mac) / `Ctrl+Alt+F`(Windows/Linux)를 누르거나, 명령 팔레트에서 **Claude Code: Toggle Focus view**를 사용합니다. 변경 사항은 열려 있는 모든 세션에 적용되며 세션 간에 유지됩니다. Claude Code v2.1.221 이상이 필요합니다.

    Claude의 최신 할 일 목록은 계속 표시되며, Claude의 대기 중인 질문이 묻고 있는 텍스트도 마찬가지입니다. 이 기능에는 Claude Code v2.1.225 이상이 필요합니다. Claude가 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)를 실행하는 동안, 최신 활동이 담긴 실시간 진행 상황 행이 해당 서브에이전트를 시작한 도구 호출 그룹 아래에 나타납니다. 이 기능에는 Claude Code v2.1.269 이상이 필요합니다.
  * Anthropic 계정에서 로그아웃하려면 Settings 섹션에서 **Sign out**을 선택하거나 `/logout`을 입력합니다. [서드파티 제공업체](#use-third-party-providers)에서는 메뉴가 둘 다 제공하지 않습니다. Claude Code v2.1.277 이상이 필요합니다.
  * 버그를 신고하려면 메뉴 하단의 **Report a problem**을 클릭하거나, 보고서를 미리 채우는 선택적 설명과 함께 `/bug` 또는 `/feedback`을 입력합니다. 보고서를 제출할 때 퍼스트 파티 연결에서 Anthropic에 로그인되어 있으면 Claude Code가 이를 Anthropic에 전송합니다. Claude Code v2.1.229 이상이 필요합니다.

    서드파티 제공업체에서 또는 Anthropic 자격 증명 없이 사용하는 경우에는 아무것도 전송되지 않습니다. 작성하기 전에 대화 상자에 그렇게 안내됩니다. 제출하면 알려진 API 키와 토큰 패턴이 삭제된 상태로 보고서가 [`~/.claude/feedback-bundles/` 아래의 로컬 아카이브](https://code.claude.com/docs/ko/data-usage#telemetry-services)로 저장됩니다. 보고서를 컴퓨터에 저장하려면 Claude Code v2.1.284 이상이 필요합니다.

    보고서가 저장되면 확인 메시지에 파일 이름이 표시되고 **Show folder** 버튼이 포함됩니다. 해당 파일을 Anthropic 계정 담당자에게 보내거나 지원 요청에 첨부합니다.

    조직의 정책이 제품 피드백을 끈 경우 **Report a problem**이 메뉴에 나타나지 않으며, `/bug`와 `/feedback`은 보고서를 여는 대신 `Feedback is turned off by your organization's policy or this environment's settings.` 알림을 표시합니다. Claude Code v2.1.284 이상에서는 `DISABLE_FEEDBACK_COMMAND` 또는 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` 환경 변수를 설정한 경우에도 피드백이 꺼지며, 보고서를 열면 대신 해당 알림이 표시됩니다.
* **곁가지 질문**: `/btw` 뒤에 질문을 입력하여 [대화에 추가하지 않고](https://code.claude.com/docs/ko/interactive-mode.md#side-questions-with-%2Fbtw) 세션에 대해 질문합니다. 답변은 채팅 옆 패널에 열리며, 그곳에서 후속 질문을 할 수 있습니다. Claude Code v2.1.227 이상이 필요합니다.

  스레드는 창을 다시 로드해도 유지됩니다. Claude Code는 최신 20개의 주고받은 내용을 보관하며, Claude Code가 [보존 기간을 안전하게 결정할 수 있는](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically) 한 [`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays) 일정에 따라 저장된 스레드를 만료시킵니다. 스레드를 지우려면 패널의 휴지통 아이콘을 클릭합니다.
* **응답 복사**: 응답 위에 마우스를 올리고 **Copy response**를 클릭하여 클립보드에 복사하거나, `/copy`를 입력하여 최신 응답을 복사합니다. `/copy 2`는 끝에서 두 번째 응답을 복사합니다. Claude Code v2.1.277 이상이 필요합니다.
* **북마크**: 응답 위에 마우스를 올리고 **Bookmark response**를 클릭하여 저장하거나, 저장된 응답에서 **Remove bookmark**를 클릭하여 제거합니다.

  저장된 응답을 검토하려면 Bookmarks 패널을 엽니다. Claude Code 패널 상단의 북마크 아이콘을 클릭하거나, 명령 메뉴의 Context 섹션에서 **Bookmarks**를 선택하거나, `/bookmarks`를 입력하면 됩니다. Claude Code v2.1.286 이상이 필요합니다.
* **Claude가 보내는 파일**: 세션이 [Remote Control](https://code.claude.com/docs/ko/remote-control.md#start-a-remote-control-session)에 연결되어 있고 Claude가 [`SendUserFile` 도구](https://code.claude.com/docs/ko/tools-reference)로 파일을 보내면, 대화에 **Sent report.md, chart.png** 같은 행이 표시됩니다. 파일 이름을 클릭하면 편집기에서 열립니다. 이 행은 Focus view에서도 계속 표시됩니다. Claude Code v2.1.295 이상이 필요합니다.

  파일 경로가 네트워크 호스트를 가리키는 경우, 해당 파일은 `\\server\share\report.md`처럼 클릭할 수 없는 전체 경로로 표시됩니다. 파일을 열면 해당 호스트에 연결하게 되고, Windows에서는 [사용자의 Windows 자격 증명이 해당 호스트로 전송될 수 있기](https://code.claude.com/docs/ko/permissions.md#read-only-commands) 때문에 Claude Code는 해당 파일을 링크하지 않습니다.
* **컨텍스트 표시기**: 프롬프트 상자에 Claude의 컨텍스트 윈도우를 얼마나 사용하고 있는지 표시됩니다. Claude는 필요할 때 자동으로 압축하며, `/compact`를 수동으로 실행할 수도 있습니다.
* **프롬프트 캐시 시계**: 컨텍스트 표시기 옆의 시계 아이콘은 대화의 [프롬프트 캐시](https://code.claude.com/docs/ko/prompt-caching.md)가 만료되기까지 남은 시간을 추정합니다. 캐시의 5분 또는 1시간 [수명](https://code.claude.com/docs/ko/prompt-caching.md#cache-lifetime)부터 카운트다운하며, 캐시를 사용하는 각 응답마다 카운트다운이 다시 시작됩니다. 압축을 제외하면 [캐시를 무효화하는 작업](https://code.claude.com/docs/ko/prompt-caching.md#actions-that-invalidate-the-cache)은 시계를 재설정하지 않으므로, 모델을 전환한 후에도 남은 시간(분)이 계속 표시될 수 있습니다.
  * 카운트다운이 끝나기 전까지 아이콘에는 **12m**처럼 남은 시간(분)이 표시됩니다.
  * 카운트다운이 끝나면 다음 응답까지 분 표시가 사라지고 아이콘이 빨간색 또는 테마의 오류 색상으로 바뀝니다. 캐시가 만료되었을 가능성이 높으므로, 캐시가 다시 구축되는 동안 다음 메시지에 대한 응답은 더 느리고 비용이 더 많이 들 수 있습니다. 메시지 사이에 5분 수명이 계속 만료된다면 [TTL 직접 선택하기](https://code.claude.com/docs/ko/prompt-caching.md#choose-the-ttl-yourself)를 참조하세요.
  * 대화가 [압축](https://code.claude.com/docs/ko/prompt-caching.md#compacting-the-conversation)된 직후에도 캐시가 아직 압축된 대화를 포함하지 않기 때문에, 다음 응답까지 아이콘이 분 표시 없이 빨간색으로 바뀝니다.
* **에이전트 맵**: 대화에 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)가 포함되면 프롬프트 상자 하단에 **2 agents** 같은 에이전트 수가 나타납니다. 점은 서브에이전트가 작업 중인지 또는 사용자의 권한을 기다리고 있는지를 보여줍니다.

  에이전트 수를 클릭하면 에이전트 맵이 열리며, 대화의 서브에이전트가 메인 에이전트 아래 트리로 표시되고 각각 상태, 경과 시간, 토큰 수가 나타납니다. 서브에이전트를 클릭하면 해당 프롬프트와 도구 호출을 보거나, 읽기 전용 트랜스크립트를 열거나, 실행 중에 중지할 수 있습니다. Claude Code v2.1.269 이상이 필요합니다.

  맵에는 에이전트 아래에 백그라운드 셸 명령 및 [모니터](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 같은 세션의 다른 [백그라운드 작업](https://code.claude.com/docs/ko/tools-reference.md#background-commands)도 나열됩니다. 행을 클릭하면 작업 카드가 열리며 그곳에서 작업을 중지할 수 있습니다.

  Claude가 서브에이전트 없이 백그라운드 셸만 시작한 경우처럼 에이전트 수가 표시되지 않을 때 맵을 열려면 프롬프트 상자에 `/tasks`를 입력합니다. 맵의 백그라운드 작업과 `/tasks` 입력에는 Claude Code v2.1.277 이상이 필요합니다.

  Claude Code v2.1.286 이상에서는 **Stop**을 클릭하거나 `Esc`를 누르면 현재 턴이 종료됩니다. 백그라운드 에이전트는 완료되거나 맵에서 중지할 때까지 계속 실행됩니다.
* **확장 사고**: Claude가 복잡한 문제를 추론하는 데 더 많은 시간을 쓸 수 있게 합니다. 끄거나 다시 켜려면 명령 메뉴(`/`)의 Model 섹션에 있는 **Thinking** 스위치를 사용합니다. [사고를 끌 수 없는](https://code.claude.com/docs/ko/model-config.md#extended-thinking) 모델에서는 메뉴에 **Thinking** 스위치가 없으며 사고가 계속 켜져 있습니다.

  `Thought for 12s`처럼 레이블만 표시되는 사고 블록은 텍스트가 없으며 클릭해도 열리지 않습니다. 사고 요약을 보려면 `~/.claude/settings.json`에서 [`showThinkingSummaries`](https://code.claude.com/docs/ko/settings-reference#showthinkingsummaries)를 `true`로 설정한 다음, 명령 팔레트에서 **Developer: Reload Window**를 실행합니다.

  이미 있는 사고 블록은 비어 있는 상태로 유지됩니다. 다시 로드한 후의 응답에서는 블록을 클릭하거나 `Ctrl+O`를 눌러 모두 펼칠 수 있습니다.
* **여러 줄 입력**: `Shift+Enter`를 누르면 전송하지 않고 새 줄을 추가합니다. 이는 질문 대화 상자의 "Other" 자유 텍스트 입력에서도 작동합니다.

### 파일 및 폴더 참조하기

@-멘션을 사용하여 특정 파일이나 폴더에 대한 컨텍스트를 Claude에 제공합니다. `@` 뒤에 파일 또는 폴더 이름을 입력하면 Claude가 해당 내용을 읽고 이에 대한 질문에 답하거나 변경할 수 있습니다. Claude Code는 퍼지 매칭을 지원하므로 이름의 일부만 입력해도 원하는 항목을 찾을 수 있습니다.

```text wrap theme={null}
Explain the logic in @auth (fuzzy matches auth.js, AuthService.ts, etc.)
What's in @src/components/ (include a trailing slash for folders)
```

### PDF의 특정 페이지 읽기

큰 PDF의 경우 전체 파일 대신 특정 페이지를 읽도록 Claude에 요청할 수 있습니다. 단일 페이지, 1-10페이지 같은 범위, 또는 3페이지 이후 같은 끝이 열린 범위를 요청하세요. 특정 페이지를 읽으려면 Claude Code가 실행되는 머신에 [poppler-utils](https://code.claude.com/docs/ko/tools-reference.md#read-tool-behavior)가 필요합니다.

### 프롬프트에 터미널 출력 포함하기

`@terminal:name`을 사용하여 프롬프트에서 터미널 출력을 참조합니다. 여기서 `name`은 터미널의 제목입니다. 이렇게 하면 복사하여 붙여넣지 않고도 Claude가 명령 출력, 오류 메시지 또는 로그를 볼 수 있습니다.

### 이미지 및 파일 첨부하기

* 이미지를 첨부하려면 클립보드에서 프롬프트 상자에 붙여넣습니다.
* 파일을 첨부하려면 `Shift`를 누른 상태로 프롬프트 상자에 드래그합니다.
* 컨텍스트에서 첨부 파일을 제거하려면 첨부 파일의 X를 클릭합니다.

### 텍스트 붙여넣기

붙여넣은 텍스트는 [터미널에서](https://code.claude.com/docs/ko/terminal-config.md#paste-large-content)처럼 자리 표시자로 접히지 않고 프롬프트 상자에 그대로 표시됩니다. Claude Code가 [붙여넣은 텍스트를 표시하는](https://code.claude.com/docs/ko/terminal-config.md#how-claude-treats-pasted-text) 세션에서는, Claude가 여전히 큰 붙여넣기를 직접 입력한 것이 아니라 붙여넣은 텍스트로 인식합니다.

Claude Code는 프롬프트 상자에 붙여넣은 텍스트와 전송하는 다른 모든 내용에서 [보이지 않는 유니코드 문자](https://code.claude.com/docs/ko/interactive-mode.md#invisible-characters-in-prompts)도 제거합니다.

* 붙여넣을 때 `Removed 3 invisible characters from the pasted text` 같은 알림이 나타나면, 해당 문자가 제거된 상태로 텍스트가 입력된 것입니다.
* 전송할 때 제거된 문자에 대한 알림이 나타나면 아무것도 전송되지 않은 것입니다. 정리된 텍스트가 프롬프트 상자에 다시 들어가 있습니다. 표시된 텍스트를 보내려면 다시 전송합니다.

### 선택 영역과 열린 파일에서 자동으로 제공되는 컨텍스트

편집기에서 텍스트를 선택하면 Claude가 강조 표시된 코드를 자동으로 볼 수 있습니다. 프롬프트 상자 하단에 선택된 줄 수가 표시됩니다. Claude는 아무것도 선택하지 않은 경우에도 편집기에 열려 있는 파일을 알 수 있으며, 프롬프트 상자에 그 이름이 표시됩니다.

`Option+K`(Mac) / `Alt+K`(Windows/Linux)를 누르면 `@app.ts#5-10`처럼 파일 경로와 줄 번호가 포함된 @-멘션이 삽입됩니다.

#### 선택 영역과 열린 파일을 메시지에서 제외하기

선택한 텍스트나 열린 파일이 메시지에 포함되지 않도록 하려면 VS Code 설정에서 해당 설정을 끕니다.

* **선택한 텍스트**: [Attach Selection 설정](vscode://settings/claudeCode.attachSelection)을 끕니다. Claude Code v2.1.300 이상이 필요합니다. 선택 영역 하나만 제외하려면 줄 수 옆의 **X**를 클릭합니다. 다른 텍스트를 선택하면 줄 수가 다시 나타납니다.
* **열린 파일**: [Attach Open File 설정](vscode://settings/claudeCode.attachOpenFile)을 끕니다. Claude Code v2.1.271 이상이 필요합니다. 메시지에 해당 파일에서 선택한 텍스트가 포함되지 않는 한 파일은 제외됩니다.

Attach Selection이 꺼진 상태에서 텍스트를 @-멘션으로 추가하려면 텍스트를 선택하고 Mac에서는 `Option+K`, Windows 및 Linux에서는 `Alt+K`를 누릅니다.

두 설정 모두 VS Code의 통합 터미널에서 `claude`를 실행할 때도 적용됩니다.

#### 제외되거나 무시된 파일에서 선택한 텍스트

채팅 패널에서 확장 프로그램은 일부 파일에서 선택한 텍스트를 전달하지 않습니다.

* 파일이 워크스페이스 안에 있고 `files.exclude` 또는 `search.exclude` 설정과 일치하면, Claude는 선택한 텍스트가 아닌 최대 파일 경로만 받습니다.
* VS Code의 `search.useIgnoreFiles` 설정과 확장 프로그램의 [`respectGitIgnore` 설정](#extension-settings)이 모두 켜져 있으면(기본값) git이 무시하는 파일에도 동일하게 적용됩니다.

이 필터는 채팅 패널에만 적용됩니다. Claude Code가 통합 터미널에서 실행되면 Claude는 이러한 파일에서 선택한 텍스트를 받을 수 있습니다. 그곳에서 파일 내용을 Claude에게서 보호하려면 [`Read` 거부 규칙](https://code.claude.com/docs/ko/permissions#read-and-edit)을 추가합니다.

### 응답의 LaTeX 수식

채팅 패널은 Claude 응답의 LaTeX 수식을 조판된 공식으로 표시합니다. 수식 렌더링에는 Claude Code v2.1.301 이상이 필요합니다. [터미널 모드](#switch-to-terminal-mode)에서는 수식이 조판되지 않습니다. 패널은 디스플레이 수식과 인라인 수식을 모두 조판합니다.

* **디스플레이 수식**: 한 줄 또는 여러 줄에 단독으로 있는 `$$ … $$` 또는 `\[ … \]` 블록, 그리고 언어가 `math`인 펜스 코드 블록
* **인라인 수식**: `$E = mc^2$` 또는 `\(a^2 + b^2 = c^2\)`처럼 같은 줄에서 열리고 닫히는 `$…$` 또는 `\(…\)`

패널은 수식을 같은 문자의 다른 용도와 구분하려고 시도하므로, `$HOME`, `$5` 같은 가격, `sed 's/\(foo\)/\1/'` 같은 텍스트는 조판되지 않습니다. 코드 스팬 안의 텍스트나 펜스 `math` 블록 이외의 코드 블록 안의 텍스트도 조판되지 않습니다. 조판될 것으로 예상한 공식이 작성된 그대로 표시되면 [수식이 원시 LaTeX로 표시되는 경우](#a-formula-shows-as-raw-latex)를 참조하세요.

조판된 공식이 포함된 텍스트를 선택하여 복사하면, 그려진 기호 대신 `$…$` 또는 `$$…$$` 구분 기호로 감싼 공식의 TeX 소스를 얻습니다. [**Copy response**](#use-the-prompt-box)와 `/copy`는 TeX 소스를 포함하여 Claude가 작성한 그대로의 응답을 제공합니다.

### 이전 대화 재개하기

Claude Code 패널 상단의 **Session history** 버튼을 클릭하여 대화 기록에 접근합니다. 키워드로 검색하거나 시간별로 찾아볼 수 있습니다.

대화를 클릭하면 재개됩니다. 대화가 현재 창의 다른 탭에 이미 열려 있으면 클릭 시 해당 탭으로 전환됩니다. 대화가 아직 다른 곳에서 열려 있다는 알림이 표시되면 [이 창에서 계속하는 방법](#the-conversation-is-still-open-somewhere-else)을 참조하세요. 메시지가 표시되지 않은 채로 대화가 열리면 [재개한 대화가 처음에 비어 있는 이유](#a-resumed-conversation-is-blank-at-first)를 참조하세요. 세션 재개에 대한 자세한 내용은 [세션 관리](https://code.claude.com/docs/ko/sessions.md)를 참조하세요.

* **세션 제목**: 새 세션은 첫 메시지를 기반으로 AI가 생성한 제목을 받습니다.
* **이름 변경 및 보관**: 세션 위에 마우스를 올리면 이러한 작업이 나타납니다. 이름을 변경하여 설명적인 제목을 부여하거나, 보관하여 목록 하단의 **Archived sessions** 그룹으로 이동합니다.
* **[`claudeProcessWrapper`](#extension-settings)가 설정된 경우 누락된 대화**: 확장 프로그램을 버전 2.1.304 이상으로 업데이트합니다. 그러면 누락되었던 대화와 함께 이 워크스페이스에서 `claude -p` 또는 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)가 시작한 세션도 목록에 포함됩니다.

기본적으로 14일 동안 활동이 없는 세션은 열려 있거나, 읽지 않았거나, [그룹](#organize-sessions-into-groups)에 속해 있지 않은 한 자동으로 **Archived sessions**로 이동합니다. 자동 보관에는 Claude Code v2.1.265 이상이 필요합니다. 기간을 변경하거나 끄려면 [Archive Inactive Sessions 설정](vscode://settings/claudeCode.archiveInactiveSessions)을 열고 일수 또는 **Never**를 선택합니다.

보관된 세션을 복원하려면 다음과 같이 합니다.

* **세션 하나**: **Archived sessions**를 펼치고 **Unarchive session**을 클릭합니다.
* **보관된 모든 세션 한꺼번에**: 활동 표시줄의 세션 목록에서 **Archived sessions** 헤더 위에 마우스를 올리고 보관 해제 아이콘을 클릭합니다. Claude Code v2.1.277 이상이 필요합니다.

v2.1.257 이전에는 이 작업이 **Delete session**이었으며, 복원할 방법 없이 세션을 숨겼습니다. 당시 삭제한 세션은 업그레이드 후 **Archived sessions** 아래에 나타납니다.

재개한 대화가 플랜 모드에서 종료되었다면 Claude Code가 플랜 모드를 복원합니다. Claude Code v2.1.246 이상이 필요합니다. 다음 경우에는 Claude Code가 플랜 모드를 복원하지 않습니다.

* 확장 프로그램이 `claudeCode.initialPermissionMode` 또는 이전 대화에서 이어진 선택으로부터 [시작 권한 모드를 선택하는](https://code.claude.com/docs/ko/permission-modes.md#switch-permission-modes) 경우
* `claudeCode.claudeProcessWrapper`가 구성되어 있는 경우
* [거부 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)이 [`ExitPlanMode`](https://code.claude.com/docs/ko/tools-reference) 도구를 제거하는 경우

#### 대화가 아직 다른 곳에서 열려 있는 경우

대화가 아직 다른 곳에서 열려 있다는 알림이 표시될 때 이 창에서 계속하려면, 해당하는 경우의 단계를 수행한 후 **Open here anyway**를 클릭합니다.

* **다른 곳에 열어 둔 것이 없는 경우**: 확장 프로그램이 다시 시작되기 전의 Claude 프로세스가 아직 대화를 열고 있을 수 있습니다. 이 프로세스는 보통 약 10분 이내에 자동으로 종료되므로, 그 정도 기다린 후 클릭합니다. 종료되기 전에 클릭하면 프로세스가 종료될 때까지 대화가 두 곳에서 열려 있게 됩니다.
* **다른 곳에 대화를 열어 둔 경우**: 예를 들어 터미널에서 `claude`를 종료하거나 다른 VS Code 창에서 해당 탭을 닫는 방식으로 먼저 그곳에서 대화를 닫습니다

대화가 다른 Claude Code 프로세스에서 아직 열려 있으면 프롬프트 상자 대신 다음 알림이 나타납니다.

```text theme={null}
This conversation is still open somewhere else. Using it in two places at once can mix up its messages. If the extension restarted recently, a Claude process from before the restart may still be finishing. It usually ends on its own within about 10 minutes. This notice stays until you choose Open here anyway.
```

[`claudeProcessWrapper`](#extension-settings)가 설정되어 있으면 확장 프로그램은 이 확인을 건너뛰고 대화를 바로 엽니다.

### claude.ai의 클라우드 세션 재개하기

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 실행하는 경우 VS Code에서 바로 재개할 수 있습니다. 이를 위해서는 Anthropic Console이 아닌 **Claude.ai Subscription**으로 로그인해야 합니다.

**1. 세션 기록 열기**

Claude Code 패널 상단의 **Session history** 버튼을 클릭합니다.

**2. Web 탭 선택**

대화 상자에 Local과 Web 두 개의 탭이 표시됩니다. **Web**을 클릭하여 claude.ai의 세션을 확인합니다.

**3. 재개할 세션 선택**

세션을 찾아보거나 검색합니다. 하나를 클릭하면 로컬에서 대화를 이어갑니다.

> [!NOTE]
>
> 열려 있는 폴더가 GitHub 저장소인 경우, Web 탭에는 해당 저장소의 세션만 표시됩니다.
>
> 클라우드 세션을 재개하면 확장 프로그램이 대화 기록의 사본을 다운로드합니다. 변경 사항은 claude.ai로 다시 동기화되지 않습니다.

Web 탭에는 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션도 나열됩니다. 열려 있는 폴더에서 실행된 세션을 클릭하면, 확장 프로그램은 사본을 다운로드하는 대신 해당 로컬 대화를 엽니다. 이미 이를 표시하는 탭이 있으면 그 탭에 포커스를 맞춥니다. 다른 Claude 프로세스가 대화를 열고 있을 가능성을 배제할 수 없으면, 대신 다운로드된 사본을 받습니다.

대화의 일부라도 다운로드에 실패하면 오류가 나타나고 사본이 저장되지 않습니다. 재시도하려면 세션을 다시 선택합니다. 아직 다운로드할 대화가 없는 세션을 선택하면, 대신 어디서 이어갈 수 있는지 알려주는 오류가 표시됩니다.

### 계정 및 사용량 확인하기

`/usage`를 실행하여 Account & usage 대화 상자를 엽니다. 이 대화 상자에는 로그인한 계정과 사용량이 표시됩니다. 사용량 수치는 로그인 방식에 따라 다릅니다.

* **claude.ai 플랜**: 현재 세션 및 주간 같은 플랜 한도에 대한 사용량 막대가 표시됩니다.

  대화 상자는 플랜 한도에 영향을 주는 요인도 분석합니다.

  * **Recommendations**: `Trim ~/code/api/CLAUDE.md · 49k tokens per request`처럼 제안된 변경 사항이 행마다 하나씩 표시됩니다
  * **Fix 버튼**: Claude Code가 적용할 수 있는 권장 사항을 적용하게 하려면 그 아래에 있는 **Fix both** 같은 버튼을 클릭합니다. 버튼이 어떤 행에 작용하는지와 이후 세션에서 어떤 일이 일어나는지 알아보려면 [수정 단축키로 권장 사항 적용하기](https://code.claude.com/docs/ko/costs.md#apply-recommendations-with-the-fix-shortcut)를 참조하세요. Claude Code v2.1.305 이상이 필요합니다.

    [Remote Control](https://code.claude.com/docs/ko/remote-control.md)이 연결되어 있는 동안에는 버튼이 표시되지 않습니다. Remote Control이 연결된 후 `The usage fix wasn’t fully sent. Open usage and try again.`이라는 경고가 나타나면, 다시 시도하기 전에 [Remote Control 연결을 해제](https://code.claude.com/docs/ko/remote-control.md#check-connection-status)하세요.
  * **Attribution**: 각 스킬, 서브에이전트, 플러그인, MCP 서버에서 발생한 사용량을 보여주는 표

  Day 및 Week 토글을 사용하여 지난 24시간과 지난 7일 간에 전환합니다. 수치는 근사치이며 이 머신의 로컬 세션에서 계산되므로, 다른 기기나 claude.ai의 사용량은 포함되지 않습니다.
* **기타 로그인**: [서드파티 제공업체](#use-third-party-providers)를 사용하거나 API 키를 사용하는 경우처럼 플랜 한도가 로그인에 적용되지 않으면, Usage 섹션에 대신 세션 자체의 비용과 토큰 사용량이 표시됩니다. CLI의 `/usage`는 [Session 블록](https://code.claude.com/docs/ko/costs.md#track-your-costs)에 동일한 합계를 표시합니다. 활동 표시줄의 세션 목록도 **Account & usage** 헤더 아래에 활성 세션의 합계를 표시합니다. Claude Code v2.1.277 이상이 필요합니다.

사용량 추적 및 절감에 대한 자세한 내용은 [비용 추적하기](https://code.claude.com/docs/ko/costs.md#track-your-costs)를 참조하세요.

### 체크포인트로 되감기

VS Code 확장 프로그램은 체크포인트를 지원합니다. 체크포인트는 Claude의 파일 편집을 추적하고 이전 상태로 되감을 수 있게 합니다. 메시지 위에 마우스를 올리면 되감기 버튼이 나타나며, 세 가지 옵션 중에서 선택할 수 있습니다.

* **Fork conversation from here**: 모든 코드 변경 사항을 그대로 유지하면서 이 메시지에서 새 대화 분기를 시작합니다
* **Rewind code to here**: 전체 대화 기록을 유지하면서 파일 변경 사항을 대화의 이 시점으로 되돌립니다
* **Fork conversation and rewind code**: 새 대화 분기를 시작하고 파일 변경 사항을 이 시점으로 되돌립니다

체크포인트의 작동 방식과 제한 사항에 대한 자세한 내용은 [체크포인트](https://code.claude.com/docs/ko/checkpointing.md)를 참조하세요.

## 워크플로 사용자 지정

Claude 패널의 위치를 바꾸거나, 여러 대화를 실행하거나, 세션 목록을 그룹화 또는 필터링하거나, 터미널 모드로 전환할 수 있습니다.

### Claude 위치 선택

Claude 패널을 드래그하여 VS Code 내 원하는 위치로 옮길 수 있습니다. 패널의 탭이나 제목 표시줄을 잡고 다음 위치로 드래그합니다.

* **보조 사이드바**: 창의 오른쪽입니다. 코딩하는 동안 Claude를 계속 표시해 둘 수 있습니다.
* **기본 사이드바**: 탐색기, 검색 등의 아이콘이 있는 왼쪽 사이드바입니다.
* **편집기 영역**: 파일과 나란히 Claude를 탭으로 엽니다. 부수적인 작업에 유용합니다.

Claude가 새 편집기 그룹에 탭을 열면 확장 프로그램이 해당 그룹을 잠급니다. 이후 Claude 탭에 포커스가 있는 상태에서 여는 파일은 그 옆이 아니라 다른 그룹으로 열립니다.

확장 프로그램이 그룹을 잠그지 않도록 하려면 [Lock Editor Groups 설정](vscode://settings/claudeCode.lockEditorGroups)을 끕니다. 이미 잠긴 그룹은 잠금을 해제할 때까지 잠긴 상태로 유지됩니다. 이 설정에는 Claude Code v2.1.274 이상이 필요합니다.

> [!TIP]
>
> 주 Claude 세션에는 사이드바를 사용하고 부수적인 작업에는 추가 탭을 여는 것이 좋습니다. Claude는 선호하는 위치를 기억합니다. 활동 표시줄의 세션 목록 아이콘은 Claude 패널과 별개입니다. 세션 목록은 활동 표시줄에 항상 표시되지만, Claude 패널 아이콘은 패널이 왼쪽 사이드바에 도킹된 경우에만 활동 표시줄에 나타납니다.

### 다시 로드 후 대화 이어가기

**Developer: Reload Window**를 실행하거나 VS Code를 다시 시작한 후에는 대화가 열려 있던 위치를 확인합니다.

* **편집기 탭**: 대화가 해당 탭과 함께 다시 열립니다.
* **사이드바**: 최근 10분 이내에 메시지를 보냈거나 Claude가 응답한 경우 대화가 다시 열립니다. 다시 열리지 않으면 [세션 기록](#resume-past-conversations)에서 대화를 재개합니다.

프롬프트 상자 대신 대화가 아직 다른 곳에서 열려 있다는 알림이 표시되면 [여기서 대화를 이어가는 방법](#the-conversation-is-still-open-somewhere-else)을 참조하세요. 처음에 메시지가 비어 있는 경우 [비어 있는 이유와 표시되는 시점](#a-resumed-conversation-is-blank-at-first)을 참조하세요.

#### 다시 로드 후 중단된 단계

다시 로드로 인해 Claude가 단계를 진행하던 중 중단된 경우, 대화가 다시 열리면 Claude가 해당 단계를 이어서 진행하며 채팅에 이어서 진행한다는 알림이 표시됩니다. Claude Code v2.1.274 이상이 필요합니다. 단계가 1시간 이상 전에 중단되었거나 세션이 다른 곳에서 열려 있으면 대화는 유휴 상태로 다시 열립니다.

#### 다시 로드 후 이어서 진행 끄기

다시 로드 후 Claude가 중단된 단계를 이어서 진행하지 않도록 하려면 [Continue After Reload 설정](vscode://settings/claudeCode.continueAfterReload)을 열고 선택을 해제합니다.

VS Code 환경이나 [`environmentVariables` 설정](#extension-settings)에서 [`CLAUDE_CODE_RESUME_INTERRUPTED_TURN`](https://code.claude.com/docs/ko/env-vars#variables) 또는 다른 `CLAUDE_CODE_RESUME_` 변수를 설정해도 패널에서는 아무런 효과가 없습니다. 확장 프로그램이 패널의 세션을 시작하기 전에 해당 변수를 제거하기 때문입니다.

#### 대화가 다시 열리지 않은 경우

다시 로드 후 프롬프트 상자 위에 다음과 같은 알림이 있는 새 채팅이 표시되면, 대화의 마지막 두 번의 열기가 완료되지 않아 패널이 대화를 닫힌 상태로 둔 것입니다.

```text theme={null}
“Fix the login bug” was not reopened. It did not finish opening the last 2 times, and opening it again may stop Claude Code from responding here.
```

대화를 로드하는 중에 패널이 충돌하거나 응답을 멈춘 경우, 또는 대화가 열린 후 약 3초 이내에 창을 다시 로드하거나 닫은 경우 열기가 완료되지 않습니다. 대화 자체는 변경되지 않으며 [세션 기록](#resume-past-conversations)에 그대로 남아 있습니다.

* **그래도 열려면**: **Open it anyway**를 클릭하거나 세션 기록에서 대화를 선택합니다. 대화가 완전히 열리면 이후 다시 로드할 때 [평소처럼 다시 열립니다](#continue-conversations-after-a-reload).
* **대화를 로드하는 중에 패널이 응답을 멈춘 경우**: 창을 다시 로드합니다. 새 채팅이 열립니다.
* **닫힌 상태로 두려면**: 새 채팅에서 계속 작업합니다. 프롬프트를 보내면 알림이 사라집니다.

### 여러 대화 실행

명령 팔레트에서 **Open in New Tab** 또는 **Open in New Window**를 사용하여 추가 대화를 시작합니다. 각 대화는 자체 기록과 컨텍스트를 유지하므로 서로 다른 작업을 병렬로 진행할 수 있습니다.

탭을 사용할 때는 스파크 아이콘의 작은 색상 점이 상태를 나타냅니다. 파란색은 권한 요청이 대기 중임을, 주황색은 탭이 숨겨져 있는 동안 Claude가 작업을 완료했음을 의미합니다.

### 세션을 그룹으로 정리

활동 표시줄의 세션 목록에서 관련 세션을 이름이 지정된 접을 수 있는 그룹으로 모을 수 있습니다. Claude Code v2.1.229 이상이 필요합니다.

* **세션 그룹화 또는 그룹 해제**: 세션을 마우스 오른쪽 버튼으로 클릭하여 해당 세션으로 그룹을 만들거나, 기존 그룹으로 이동하거나, 그룹에서 제거합니다. 각 세션은 한 번에 하나의 그룹에만 속하므로 다른 그룹으로 이동하면 처음 그룹에서 제거됩니다.
* **여러 세션을 한 번에 이동**: 각 세션을 `Cmd`-클릭(Mac) / `Ctrl`-클릭(Windows/Linux)하거나 `Shift`-클릭하여 범위를 선택한 다음, 선택 항목을 마우스 오른쪽 버튼으로 클릭합니다.
* **탭에서 세션 그룹화**: 명령 팔레트에서 **Claude Code: Add Session Tab to Group**을 실행한 다음 그룹을 선택하거나 만듭니다. Claude Code v2.1.257 이상이 필요합니다.
* **그룹 이름 변경 또는 삭제**: 그룹 헤더를 마우스 오른쪽 버튼으로 클릭합니다. 그룹을 삭제하면 그룹만 제거되며, 해당 세션은 그룹화되지 않은 목록으로 돌아갑니다.

확장 프로그램은 워크스페이스 폴더별로 그룹을 저장하므로, 그룹은 창을 다시 로드해도 유지되며 같은 폴더를 여는 모든 창에 표시됩니다. 목록을 검색하면 확장 프로그램은 모든 그룹에 걸친 일치 항목을 하나의 평면 목록으로 표시합니다.

### 세션 목록 필터링

활동 표시줄의 긴 세션 목록을 좁히려면 목록 상단의 두 필터 컨트롤을 사용합니다. Claude Code v2.1.271 이상이 필요합니다. 두 필터 중 하나라도 켜져 있으면 보관된 세션은 표시되지 않습니다.

* **Active**: 이 토글을 켜면 입력이 필요하거나, 작업 중이거나, 읽지 않은 세션과 함께 마지막으로 포커스한 Claude 탭의 세션만 표시됩니다.
* **상태별 필터링**: 깔때기 아이콘을 클릭한 다음 **Needs input**, **Working** 또는 **Completed**를 선택하여 해당 상태 중 하나에 있는 세션을 표시합니다. **Open** 또는 **Closed**를 선택하면 세션이 열려 있는지 여부로 목록을 좁힐 수 있습니다. 세션이 이 창에 탭을 가지고 있거나, 터미널과 같이 이 컴퓨터의 다른 Claude Code 프로세스에서 실행 중이면 열린 것으로 간주됩니다.

**Active**가 켜져 있는 상태에서 상태, **Open** 또는 **Closed**를 선택하면 선택한 항목과 일치하는 모든 세션도 목록에 표시됩니다. 설정한 필터는 창을 다시 로드해도 유지됩니다.

### 터미널 모드로 전환

기본적으로 확장 프로그램은 그래픽 채팅 패널을 엽니다. CLI 스타일 인터페이스를 선호한다면 [Use Terminal 설정](vscode://settings/claudeCode.useTerminal)을 열고 확인란을 선택합니다.

Mac에서는 `Cmd+,`, Windows/Linux에서는 `Ctrl+,`를 눌러 VS Code 설정을 열고 **Extensions > Claude Code**로 이동하여 **Use Terminal**을 선택할 수도 있습니다.

## 플러그인 관리

VS Code 확장 프로그램에는 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)을 설치하고 관리하기 위한 그래픽 인터페이스가 포함되어 있습니다. 프롬프트 상자에 `/plugins`를 입력하면 **Manage plugins** 인터페이스가 열립니다.

### 플러그인 설치

플러그인 대화 상자에는 **Plugins**와 **Marketplaces** 두 개의 탭이 있습니다.

Plugins 탭에서는 다음과 같습니다.

* **설치된 플러그인**이 상단에 표시되며, 토글 스위치로 활성화하거나 비활성화할 수 있습니다.
  * 프로젝트의 공유 `.claude/settings.json`에서 켜 둔 플러그인을 끄려고 하면 확장 프로그램이 먼저 확인을 요청합니다. **Disable for me**는 본인에게만 플러그인을 끄고, **Disable for everyone**은 공유 파일을 변경합니다.
  * 로드에 실패한 플러그인은 해당 행에 간단한 이유를 표시합니다. 이유를 클릭하면 취할 수 있는 조치를 확인할 수 있으며, 여기에는 [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md)에서 찾아볼 수 있도록 전체 오류 메시지를 복사하는 기능도 포함됩니다.
* 구성된 마켓플레이스의 **사용 가능한 플러그인**이 아래에 표시됩니다
* 검색을 통해 이름이나 설명으로 플러그인을 필터링할 수 있습니다
* 사용 가능한 플러그인에서 **Install**을 클릭합니다

플러그인을 설치할 때 설치 범위를 선택합니다.

* **Install for you**: 모든 프로젝트에서 사용 가능(사용자 범위)
* **Install for this project**: 프로젝트 협업자와 공유(프로젝트 범위)
* **Install locally**: 본인만, 이 저장소에서만 사용 가능(로컬 범위)

설치가 완료되면 아직 설정되지 않은 플러그인의 [구성 옵션](https://code.claude.com/docs/ko/plugins/components.md#user-configuration)을 입력하는 양식이 표시됩니다. 나중에 옵션을 검토하거나 변경하려면 플러그인 행의 톱니바퀴 아이콘을 클릭합니다.

민감한 텍스트 필드는 마스킹 처리되며, 이전에 저장한 비밀 값에는 \*\*(unchanged)\*\*가 표시됩니다. 저장된 값을 유지하려면 필드를 비워 둡니다. 변경 사항을 저장하면 열려 있는 세션이 플러그인을 다시 로드하고, 대화 상자에 **Restart Claude to apply plugin changes**가 표시됩니다.

### 플러그인 제거

설치된 각 행에는 설치된 [범위](https://code.claude.com/docs/ko/plugins/install.md#choose-an-install-scope)가 표시됩니다. 해당 설치를 제거하려면 행의 휴지통 아이콘을 클릭합니다. 흐리게 표시된 휴지통 아이콘은 조직에서 관리하는 플러그인이나 다른 프로젝트에 설치된 플러그인처럼 이 워크스페이스에서 제거할 수 없는 행을 나타냅니다.

확장 프로그램은 다음 두 가지 경우에 먼저 확인을 요청합니다.

* **프로젝트의 공유 `.claude/settings.json`에서 켜 둔 플러그인**: 협업자에게는 플러그인이 설치된 상태로 유지되는 **Disable for me**를 선택하거나, [`--keep-data`](https://code.claude.com/docs/ko/plugins/cli-reference#what-an-uninstall-deletes-and-keeps)와 함께 프로젝트의 설치를 제거하여 플러그인의 저장된 데이터 디렉터리는 남겨 두는 **Uninstall for everyone**을 선택합니다. 이미 본인에 대해 플러그인을 꺼 둔 경우에는 휴지통 아이콘을 클릭하면 확인 없이 본인의 설치가 제거됩니다.
* **그 외의 경우, 저장된 데이터가 있는 플러그인의 마지막 설치**: 데이터를 유지할지 삭제할지 선택합니다. 기본값은 **Keep**입니다

### 플러그인 설치 링크 공유

특정 플러그인을 바로 설치할 수 있도록 안내하려면 확장 프로그램의 `install-plugin` URL을 전달합니다. 이 URL을 열면 VS Code가 실행되거나 포커스되고, Claude Code 패널이 열리며, 해당 플러그인의 범위 선택 화면에서 **Manage plugins** 대화 상자가 열립니다. 받는 사람이 범위를 선택하기 전까지는 아무것도 설치되지 않습니다. 플러그인의 마켓플레이스가 받는 사람의 Claude Code에 아직 구성되어 있지 않으면, 대화 상자가 먼저 마켓플레이스를 추가하도록 요청합니다.

```text theme={null}
vscode://anthropic.claude-code/install-plugin?plugin=code-review&marketplace=anthropics/claude-plugins-official
```

이 URL은 두 개의 쿼리 매개변수를 사용합니다.

| 매개변수 | 설명 |
| - | - |
| `plugin` | 마켓플레이스에 등록된 플러그인의 이름입니다. 필수입니다. |
| `marketplace` | 마켓플레이스의 [소스](https://code.claude.com/docs/ko/plugins/install.md#add-a-marketplace)로, GitHub `owner/repo`, `https://` URL 또는 `git@github.com:owner/repo.git`과 같은 git SSH 주소입니다. 생략하면 기본값은 `anthropics/claude-plugins-official`입니다. |

확장 프로그램은 무언가를 열기 전에 두 값을 모두 확인합니다.

* **플러그인 이름**: 최대 100자이며, ASCII 문자 또는 숫자로 시작하고 나머지는 ASCII 문자, 숫자, `.`, `_`, `-`만 사용해야 합니다.
* **마켓플레이스 소스**: `marketplace` 매개변수에 나열된 형식만 허용되므로, 로컬 경로, `http://` 주소 또는 `claude-plugins-official`과 같은 마켓플레이스 이름은 사용할 수 없습니다. `https://` URL에는 사용자 이름, 비밀번호 또는 쿼리 문자열을 포함할 수 없습니다.
* **Git ref**: 마켓플레이스를 브랜치나 태그에 고정하려면 `marketplace=owner/repo%23v1.0`처럼 `#`의 인코딩 형식인 `%23` 뒤에 ref를 소스에 덧붙입니다. 인코딩되지 않은 `#`이 포함된 링크는 실패합니다. `anthropics` GitHub 조직의 마켓플레이스는 링크에서 고정할 수 없습니다.

이러한 규칙을 위반하는 링크를 열면 `Invalid plugin installation URL`로 시작하는 오류가 표시됩니다. Claude Code 패널과 대화 상자는 열리지 않으며 아무것도 설치되지 않습니다. 플러그인의 이름이나 마켓플레이스를 링크에 넣을 수 없는 경우, **Marketplaces** 탭에서 마켓플레이스를 추가한 다음 **Plugins** 탭에서 플러그인을 설치하도록 안내합니다.

다음 경우에는 범위 선택 대신 대화 상자의 메시지로 끝납니다.

* **마켓플레이스에 해당 이름의 플러그인이 없는 경우**: 대화 상자에 플러그인을 찾을 수 없다고 표시됩니다. `plugin` 값을 마켓플레이스의 목록과 대조하여 확인합니다.
* **플러그인이 이미 설치된 경우**: 대화 상자에 그 사실이 표시되며, 아무것도 변경되지 않습니다.
* **같은 이름의 다른 마켓플레이스가 이미 추가된 경우**: 대화 상자에 링크의 마켓플레이스가 추가되지 않았다고 표시되며, 아무것도 설치되지 않습니다.

GitHub README, 이슈 및 일부 다른 Markdown 호스트는 스킴이 `http` 또는 `https`가 아닌 링크를 제거하므로, 이러한 곳에서는 `vscode://` 링크가 일반 텍스트로 렌더링됩니다. 해당 호스트에서는 `claude-cli://` 링크에 대해 [링크가 일반 텍스트로 렌더링되고 클릭 가능하지 않음](https://code.claude.com/docs/ko/deep-links.md#the-link-renders-as-plain-text-instead-of-being-clickable)에서 설명하는 것처럼 URL을 코드 블록에 넣습니다.

### 마켓플레이스 관리

**Marketplaces** 탭으로 전환하여 플러그인 소스를 추가하거나 제거합니다.

* GitHub 저장소, URL 또는 로컬 경로를 입력하여 새 마켓플레이스를 추가합니다
* 새로고침 아이콘을 클릭하여 마켓플레이스의 플러그인 목록을 업데이트합니다
* 휴지통 아이콘을 클릭하여 마켓플레이스를 제거합니다. 마켓플레이스를 제거하면 [해당 마켓플레이스에서 설치한 모든 플러그인이 제거](https://code.claude.com/docs/ko/plugins/install.md#manage-marketplaces)되므로, 먼저 해당 플러그인 이름을 표시하는 확인 창이 나타납니다

대화 상자에서 변경한 플러그인 설정은 해당 VS Code 창에 열려 있는 Claude Code 세션에 즉시 적용됩니다.

대화 상자를 연 세션이 플러그인을 다시 로드할 수 없는 경우, 대화 상자에서 다시 시도하거나 해당 세션에서 Claude를 다시 시작하는 옵션을 제공합니다.

> [!NOTE]
>
> 확장 프로그램은 CLI와 동일한 명령을 실행하여 플러그인을 관리합니다. 확장 프로그램에서 구성한 플러그인과 마켓플레이스는 CLI에서도 사용할 수 있으며, 그 반대도 마찬가지입니다.

플러그인 시스템에 대한 자세한 내용은 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md) 및 [플러그인 마켓플레이스](https://code.claude.com/docs/ko/plugins/overview.md)를 참조하십시오.

### 패널에 그리는 플러그인

[mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)를 포함하는 플러그인은 채팅 패널에 그릴 수 있습니다. 그리기 기능을 사용하려면 확장 프로그램 버전 2.1.299 이상이 필요합니다. Amazon Bedrock 세션처럼 [기능 플래그를 가져오지 않는](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) 세션에는 2.1.304 이상이 필요합니다. 이러한 플러그인에서는 다음을 볼 수 있습니다.

* 대화 옆 또는 프롬프트 상자 위의 창
* 프롬프트 상자 위의 토스트 또는 상태줄
* 플러그인 고유의 방식으로 그려진 메시지나 도구 호출

설치한 플러그인이 패널에 무언가를 추가하거나 변경하면, 다음과 같은 문구로 해당 플러그인을 표시하는 레이블이 나타납니다.

* **From the token-chart plugin**: 플러그인이 이것을 그리거나 출력했거나, 이 카드가 플러그인이 사용자에게 무언가를 묻는 것입니다
* **Edited by the token-chart plugin**: 플러그인이 도구 호출처럼 Claude Code가 그리는 항목을 변경했습니다
* **Prompt from the token-chart plugin**: 플러그인이 사용자를 대신하여 이 메시지를 보냈습니다

플러그인이 그리지 못하도록 하려면 [플러그인 대화 상자](#install-plugins)에서 플러그인을 끕니다.

## Chrome으로 브라우저 작업 자동화하기

Claude를 Chrome 브라우저에 연결하면 VS Code를 벗어나지 않고도 웹 앱을 테스트하고, 콘솔 로그로 디버깅하고, 브라우저 워크플로를 자동화할 수 있습니다. 이 기능을 사용하려면 [Claude in Chrome 확장 프로그램](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) 버전 1.0.36 이상이 필요합니다.

프롬프트 상자에 `@browser`를 입력한 다음 Claude가 수행할 작업을 입력합니다:

```text wrap theme={null}
@browser go to localhost:3000 and check the console for errors
```

첨부 메뉴를 열어 새 탭 열기나 페이지 콘텐츠 읽기와 같은 특정 브라우저 도구를 선택할 수도 있습니다.

Claude는 브라우저 작업을 위해 새 탭을 열고 브라우저의 로그인 상태를 공유하므로, 이미 로그인되어 있는 모든 사이트에 접근할 수 있습니다.

브라우저 사용에 대한 자세한 내용은 다음을 참조하세요:

* [기본적으로 Chrome 활성화하기](https://code.claude.com/docs/ko/chrome.md#enable-chrome-by-default): `@browser`를 입력하지 않아도 각 세션이 시작될 때 브라우저에 연결되도록 설정합니다
* [VS Code 세션의 권한 프롬프트](https://code.claude.com/docs/ko/chrome.md#permission-prompts-in-vs-code-sessions): Claude Code가 브라우저 작업 전에 확인을 요청하는 경우를 설명합니다
* [Chrome과 함께 Claude Code 사용하기](https://code.claude.com/docs/ko/chrome.md): 설정 방법, 전체 기능 목록, 문제 해결을 다룹니다

## git으로 작업하기

Claude Code는 git과 통합되어 VS Code에서 직접 버전 제어 워크플로우를 지원합니다. Claude에게 변경 사항을 커밋하거나, 풀 리퀘스트를 생성하거나, 브랜치 간에 작업하도록 요청할 수 있습니다. 자체 파일과 브랜치가 있는 격리된 worktree에서 Claude를 시작하려면 [worktree를 사용하여 병렬 세션 실행](https://code.claude.com/docs/ko/worktrees.md)을 참조하십시오.

### 커밋 및 풀 리퀘스트 생성

Claude는 변경 사항을 스테이징하고, 커밋 메시지를 작성하며, 작업을 기반으로 풀 리퀘스트를 생성할 수 있습니다:

```text wrap theme={null}
commit my changes with a descriptive message
create a pr for this feature
summarize the changes I've made to the auth module
```

풀 리퀘스트를 생성할 때, Claude는 실제 코드 변경 사항을 기반으로 설명을 생성하며 테스트 또는 구현 결정에 대한 컨텍스트를 추가할 수 있습니다.

### 워크트리로 이동한 대화 다시 열기

다시 연 대화에서 **This session is in worktree** 배너는 대화의 작업 디렉터리가 이 창에서 열려 있는 폴더가 아니라 배너에 표시된 [worktree](https://code.claude.com/docs/ko/worktrees.md)임을 의미합니다. 새 VS Code 창에서 워크트리를 열려면 배너의 **Open worktree**를 클릭하십시오.

예를 들어 [Claude에게 워크트리에서 작업하도록 요청](https://code.claude.com/docs/ko/worktrees.md#ask-claude-to-create-a-worktree)하면 대화가 워크트리로 이동합니다. 대화를 다시 열거나 [창을 다시 로드한 후 패널이 대화를 다시 열면](#continue-conversations-after-a-reload), Claude Code가 `.claude/worktrees/` 아래에 워크트리를 생성했고 해당 워크트리가 아직 존재하는 경우 대화가 워크트리에서 재개됩니다. Claude Code v2.1.300 이전에는 대신 빈 대화가 열렸습니다. 해당 버전을 사용 중이라면 확장 프로그램을 업데이트하십시오.

## 백그라운드에서 작업 실행하기

오래 실행되는 명령이나 서브에이전트를 백그라운드로 보낸 다음, 프롬프트 상자에서 상태를 확인할 수 있습니다.

### 실행 중인 명령 또는 서브에이전트를 백그라운드로 이동하기

명령이나 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md) 때문에 Claude가 원하는 것보다 오래 기다리고 있다면, 대화에서 해당 도구 호출 아래에 있는 **Run in background**를 클릭합니다. Claude Code v2.1.287 이상이 필요합니다.

* **표시 시점**: 이 동작은 명령이 약 2초 동안 실행된 후, 또는 Claude가 메인 대화에서 생성한 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)를 기다리기 시작하는 즉시 나타납니다.
* **클릭한 후**: Claude는 기다리는 것을 멈추고 턴을 계속 진행합니다. 명령 또는 서브에이전트는 완료 시 Claude에게 알리는 [백그라운드 작업](https://code.claude.com/docs/ko/tools-reference.md#background-commands)으로 계속 실행됩니다.

그동안 작업 상태를 확인하거나 작업을 중지하려면 프롬프트 상자에 `/tasks`를 입력하여 [에이전트 맵](#use-the-prompt-box)을 엽니다. 서브에이전트는 그곳의 에이전트 트리에서 자신의 위치를 유지하며, 명령은 에이전트 아래에 나열되고 [카드에 최신 출력](#monitor-background-processes)이 표시됩니다.

#### 서브에이전트 아래에 Run in background 동작이 없는 경우

VS Code에서는 기본적으로 서브에이전트에 이 동작이 표시되지 않습니다. 특정 서브에이전트에 표시되지 않는 이유를 확인하려면 [에이전트 맵](#use-the-prompt-box)에서 해당 카드를 열고 `Spawned by` 줄을 확인합니다.

* **`Spawned by the main agent`**: 서브에이전트가 백그라운드에서 시작되었으므로 Claude가 이를 기다리지 않으며, 별도로 조치할 필요가 없습니다. Claude가 서브에이전트를 기다리도록 하려면 [Claude가 서브에이전트를 기다리도록 하기](https://code.claude.com/docs/ko/sub-agents.md#let-claude-wait-for-a-subagent)를 참조하세요.
* **`Spawned by`에 다른 서브에이전트 이름이 표시되는 경우**: 이 동작은 메인 에이전트가 생성한 서브에이전트에만 나타나며, 다른 서브에이전트가 기다리고 있는 [중첩 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#let-subagents-spawn-their-own-subagents)에는 나타나지 않습니다. 중첩 서브에이전트를 일찍 종료하려면 해당 카드에서 **Stop agent**를 클릭합니다. 그러면 기다리던 서브에이전트는 해당 결과 없이 계속 진행합니다.

### 백그라운드 프로세스 모니터링하기

프롬프트 상자에 `/tasks`를 입력하면 [에이전트 맵](#use-the-prompt-box)이 열리며, 여기에는 Claude가 백그라운드 셸 명령으로 실행 상태로 둔 개발 서버와 같은 세션의 백그라운드 작업이 나열됩니다. 작업을 클릭하면 해당 카드가 열리고, 카드에서 작업을 중지할 수 있습니다. Claude Code v2.1.277 이상이 필요합니다.

백그라운드 셸 명령 또는 명령을 실행하는 [모니터](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool)의 경우, 카드에는 명령의 최신 출력도 표시되며 명령이 실행되는 동안 출력이 새로 고쳐집니다.

#### 백그라운드 서브에이전트의 도구 호출 보기

서브에이전트가 도구 호출 없이 상태줄 하나로만 표시되는 경우, 프롬프트 상자에 `/tasks`를 입력하여 [에이전트 맵](#use-the-prompt-box)을 열고 그곳에서 해당 서브에이전트를 클릭합니다. 이 서브에이전트는 [백그라운드에서 실행 중](#the-run-in-background-action-is-missing-under-a-subagent)이며, 해당 카드에는 서브에이전트의 도구 호출과 트랜스크립트를 여는 버튼이 표시됩니다.

## VS Code 명령 및 단축키

Command Palette를 열려면 Mac에서는 `Cmd+Shift+P`, Windows/Linux에서는 `Ctrl+Shift+P`를 누릅니다. 여기에 "Claude Code"를 입력하면 Claude Code 확장 프로그램에서 사용할 수 있는 모든 VS Code 명령을 확인할 수 있습니다.

일부 단축키는 어떤 패널이 "포커스"되어 있는지(키보드 입력을 받고 있는지)에 따라 달라집니다. 커서가 코드 파일에 있으면 편집기가 포커스된 상태입니다. 커서가 Claude의 프롬프트 상자에 있으면 Claude가 포커스된 상태입니다. `Cmd+Esc` / `Ctrl+Esc`를 사용하여 둘 사이를 전환합니다.

> [!NOTE]
>
> 이 명령들은 확장 프로그램을 제어하기 위한 VS Code 명령입니다. 모든 기본 제공 Claude Code 명령을 확장 프로그램에서 사용할 수 있는 것은 아닙니다. 자세한 내용은 [VS Code 확장 프로그램과 Claude Code CLI 비교](#vs-code-extension-vs-claude-code-cli)를 참조하세요.

| 명령 | 단축키 | 설명 |
| - | - | - |
| Focus Input | `Cmd+Esc` (Mac) / `Ctrl+Esc` (Windows/Linux) | 편집기와 Claude 사이에서 포커스를 전환합니다 |
| Focus last message | - | 키보드 포커스를 대화의 최신 메시지 또는 대기 중인 권한 프롬프트로 이동하여 키보드나 스크린 리더로 그 위치부터 읽을 수 있게 합니다. [터미널 모드](#switch-to-terminal-mode)에서는 사용할 수 없습니다. Claude Code v2.1.268 이상이 필요합니다 |
| Open in Side Bar | - | 사이드바에서 Claude를 엽니다 |
| Open in Terminal | - | 터미널 모드에서 Claude를 엽니다 |
| Open in New Tab | `Cmd+Shift+Esc` (Mac) / `Ctrl+Shift+Esc` (Windows/Linux) | 새 대화를 편집기 탭으로 엽니다 |
| Open in New Window | - | 새 대화를 별도의 창에서 엽니다 |
| New Conversation | `Cmd+N` (Mac) / `Ctrl+N` (Windows/Linux) | 새 대화를 시작합니다. Claude가 포커스되어 있고 `enableNewConversationShortcut`이 `true`로 설정되어 있어야 합니다 |
| Reopen Closed Session | `Cmd+Shift+T` (Mac) / `Ctrl+Shift+T` (Windows/Linux) | 가장 최근에 닫은 Claude 세션 탭을 다시 엽니다. 마지막으로 닫은 탭이 Claude 세션이 아니면 VS Code의 일반적인 닫은 편집기 다시 열기 동작으로 넘어갑니다. `enableReopenClosedSessionShortcut`으로 비활성화할 수 있습니다 |
| Insert @-Mention Reference | `Option+K` (Mac) / `Alt+K` (Windows/Linux) | 현재 파일과 선택 영역에 대한 참조를 삽입합니다(편집기가 포커스되어 있어야 함) |
| Accept Change at Cursor | - | [제안된 편집을 한 번에 하나의 변경 사항씩 검토](#get-started)하는 동안 커서 위치의 변경 사항을 수락합니다. Claude Code v2.1.275 이상이 필요합니다 |
| Reject Change at Cursor | - | 제안된 편집을 한 번에 하나의 변경 사항씩 검토하는 동안 커서 위치의 변경 사항을 되돌립니다. Claude Code v2.1.275 이상이 필요합니다 |
| Toggle Focus view | `Ctrl+Option+F` (Mac) / `Ctrl+Alt+F` (Windows/Linux) | 대화에서 도구 활동을 숨기거나 표시합니다. Claude 패널이나 사이드바가 표시되어 있는 동안 작동합니다. Windows/Linux에서는 포커스가 Debug Console이나 Explorer 같은 검색 가능한 목록에 있을 때 `Ctrl+Alt+F`가 대신 VS Code의 Find를 엽니다. 편집기나 Claude 패널에 포커스를 둔 후 다시 누르세요. Claude Code v2.1.221 이상이 필요합니다 |
| Rename Session Tab | - | 활성 Claude 탭의 세션 이름을 변경합니다. Claude Code v2.1.257 이상이 필요합니다 |
| Add Session Tab to Group | - | 활성 Claude 탭의 세션을 선택하거나 새로 만든 [세션 그룹](#organize-sessions-into-groups)에 추가합니다. Claude Code v2.1.257 이상이 필요합니다 |
| Mark Session as Unread | - | 활성 Claude 탭의 세션을 세션 목록에서 읽지 않음으로 표시합니다. Claude Code v2.1.257 이상이 필요합니다 |
| Show Logs | - | 확장 프로그램 디버그 로그를 확인합니다 |
| Logout | - | Anthropic 계정에서 로그아웃합니다 |

### 다른 도구에서 VS Code 탭 실행하기

확장 프로그램은 `vscode://anthropic.claude-code/open`에 URI 핸들러를 등록합니다. 이를 사용하면 셸 별칭, 브라우저 북마클릿 또는 URL을 열 수 있는 모든 스크립트 등 자체 도구에서 새 Claude Code 탭을 열 수 있습니다. VS Code가 아직 실행 중이 아니면 URL을 열 때 먼저 VS Code가 실행됩니다. VS Code가 이미 실행 중이면 현재 포커스된 창에서 URL이 열립니다.

운영 체제의 URL 열기 도구로 핸들러를 호출합니다.

> [tab] macOS
>
> ```bash theme={null}
> open "vscode://anthropic.claude-code/open"
> ```

> [tab] Linux
>
> ```bash theme={null}
> xdg-open "vscode://anthropic.claude-code/open"
> ```
>
> `xdg-open` 명령은 `xdg-utils` 패키지에서 제공됩니다. 셸에서 이 명령을 찾을 수 없다고 표시되면 [Linux에서 xdg-open을 찾을 수 없음](https://code.claude.com/docs/ko/deep-links.md#xdg-open-is-not-found-on-linux)을 참조하세요.

> [tab] Windows
>
> PowerShell에서:
>
> ```powershell theme={null}
> Start-Process "vscode://anthropic.claude-code/open"
> ```
>
> `cmd.exe`에서 `start`는 따옴표로 묶인 첫 번째 인수를 창 제목으로 처리하므로 URL 앞에 빈 제목을 전달합니다:
>
> ```cmd theme={null}
> start "" "vscode://anthropic.claude-code/open"
> ```

핸들러는 두 가지 선택적 쿼리 매개변수를 받습니다:

| 매개변수 | 설명 |
| - | - |
| `prompt` | 프롬프트 상자에 미리 채울 텍스트입니다. URL 인코딩되어 있어야 합니다. 프롬프트는 미리 채워지지만 자동으로 제출되지는 않습니다. |
| `session` | VS Code에 열려 있는 폴더에서 재개할 세션의 ID입니다. Claude Code v2.1.300 이상에서는 해당 폴더 저장소의 메인 체크아웃 또는 [worktree](https://code.claude.com/docs/ko/worktrees.md)에 속한 세션도 재개됩니다. 세션을 찾을 수 없으면 대신 새 대화가 시작됩니다. 세션이 이미 탭에서 열려 있으면 해당 탭이 포커스됩니다. 프로그래밍 방식으로 세션 ID를 얻으려면 [대화 계속하기](https://code.claude.com/docs/ko/headless.md#continue-conversations)를 참조하세요. |

예를 들어 "review my changes"가 미리 채워진 탭을 열려면 다음과 같이 합니다:

```text theme={null}
vscode://anthropic.claude-code/open?prompt=review%20my%20changes
```

확장 프로그램은 `vscode://anthropic.claude-code/install-plugin`도 처리하며, 이는 [특정 플러그인에 대한 플러그인 대화 상자를 엽니다](#share-a-plugin-install-link). VS Code 탭 대신 터미널 세션을 실행하려면 CLI의 `claude-cli://` 핸들러를 사용합니다. [링크에서 세션 실행하기](https://code.claude.com/docs/ko/deep-links.md)를 참조하세요.

## 설정 구성

확장 프로그램은 VS Code의 확장 프로그램 설정과 Claude Code 설정 파일, 두 곳에서 구성합니다:

* VS Code의 **확장 프로그램 설정**: VS Code 내에서 확장 프로그램의 동작을 제어합니다. `Cmd+,`(Mac) 또는 `Ctrl+,`(Windows/Linux)로 연 다음 **Extensions > Claude Code**로 이동합니다. `/`를 입력하고 \*\*General config…\*\*를 선택하여 설정을 열 수도 있습니다.
* `~/.claude/settings.json`의 **Claude Code 설정**: 확장 프로그램과 CLI 간에 공유됩니다. 허용된 명령, 환경 변수, 훅, MCP 서버에 사용합니다. Claude Code v2.1.283 이상에서는 대화가 시작되는 권한 모드를 결정하는 입력 중 하나이기도 하며, 이전 버전에서는 Pro, Max, Ultra, Team 플랜에서만 해당됩니다. [권한 모드 전환](https://code.claude.com/docs/ko/permission-modes.md#switch-permission-modes)에 그 순서가 나와 있습니다. 자세한 내용은 [설정](https://code.claude.com/docs/ko/settings.md)을 참조하세요.

> [!TIP]
>
> `settings.json`에 `"$schema": "https://json.schemastore.org/claude-code-settings.json"`을 추가하면 VS Code에서 바로 사용 가능한 모든 설정에 대한 자동 완성과 인라인 유효성 검사를 사용할 수 있습니다.

### 확장 프로그램 설정

VS Code는 사용자 설정에서 `initialPermissionMode`를 읽고 워크스페이스 값은 무시합니다. v2.1.225 이전에는 VS Code가 이 설정의 기본값을 `default`로 지정하고 워크스페이스 값을 적용했습니다.

| 설정 | 기본값 | 설명 |
| - | - | - |
| `useTerminal` | `false` | 그래픽 패널 대신 터미널 모드에서 Claude를 실행합니다 |
| `initialPermissionMode` | - | 새 대화의 승인 프롬프트를 제어합니다: `default`, `plan`, `acceptEdits` 또는 `bypassPermissions`. `manual`은 `default`의 별칭이며 모드 표시기에서 **Manual**로 표시된 모드를 선택합니다. 설정하지 않으면 확장 프로그램은 [권한 모드 전환](https://code.claude.com/docs/ko/permission-modes.md#switch-permission-modes)에 설명된 대로 시작 권한 모드를 선택합니다. |
| `preferredLocation` | `panel` | Claude가 열리는 위치: `sidebar`(오른쪽) 또는 `panel`(새 탭) |
| `lockEditorGroups` | `true` | [Claude가 탭용으로 시작하는 편집기 그룹을 잠가](#choose-where-claude-lives) Claude 탭에 포커스가 있는 동안 여는 파일이 다른 그룹으로 이동하도록 합니다. 끄면 확장 프로그램은 편집기 그룹을 잠그지 않습니다. Claude Code v2.1.274 이상이 필요합니다 |
| `autosave` | `true` | Claude가 파일을 읽거나 쓰기 전에 파일을 자동 저장합니다 |
| `attachOpenFile` | `true` | 편집기에 열려 있는 파일을 메시지에 추가하고 프롬프트 상자에 표시합니다. 끄면 파일은 선택한 텍스트와 함께일 때만 추가됩니다. Claude Code v2.1.271 이상이 필요합니다 |
| `attachSelection` | `true` | 편집기에서 선택한 텍스트를 메시지에 추가하고 프롬프트 상자에 표시합니다. 끄더라도 [선택 영역을 @-멘션으로 추가](#automatic-context-from-your-selection-and-open-file)할 수 있습니다. Claude Code v2.1.300 이상이 필요합니다 |
| `useCtrlEnterToSend` | `false` | 프롬프트를 보낼 때 Enter 대신 Ctrl/Cmd+Enter를 사용합니다 |
| `scrollToBottomOnSend` | `true` | 메시지를 보낼 때 대화를 맨 아래로 스크롤합니다. 끄면 대화가 마지막 위치에 그대로 유지됩니다. Claude Code v2.1.275 이상이 필요합니다 |
| `showMessageTimestamps` | `true` | 각 메시지를 보낸 시간을 표시합니다. 날짜가 바뀌는 지점에 날짜 줄이 표시됩니다. Claude Code v2.1.284 이상이 필요합니다. v2.1.290 이전에는 기본값이 `false`였습니다 |
| `spinnerVerbs` | `{"mode": "append", "verbs": []}` | 턴이 실행되는 동안 대화 스피너에 순환 표시되는 동사를 설정하며, CLI의 [`spinnerVerbs`](https://code.claude.com/docs/ko/settings-reference#spinnerverbs)와 동일한 `mode` 및 `verbs` 필드를 사용합니다. |
| `enableNewConversationShortcut` | `false` | Cmd/Ctrl+N으로 새 대화를 시작할 수 있도록 합니다 |
| `enableReopenClosedSessionShortcut` | `true` | Cmd/Ctrl+Shift+T를 사용하여 가장 최근에 닫은 Claude 세션 탭을 다시 엽니다. 마지막으로 닫은 탭이 Claude 세션이 아닌 경우, 이 단축키는 대신 VS Code의 일반적인 닫은 편집기 다시 열기 명령을 실행합니다. |
| `archiveInactiveSessions` | `14` | 활동이 없는 상태로 이 일수가 지나면 [세션을 자동으로 보관](#resume-past-conversations)합니다: `1`, `2`, `7` 또는 `14`. 끄려면 `0`으로 설정합니다. Claude Code v2.1.265 이상이 필요합니다 |
| `continueAfterReload` | `true` | 창을 다시 로드한 후 Claude가 복원된 세션에서 [중단된 단계를 계속 진행](#continue-conversations-after-a-reload)합니다. Claude Code v2.1.274 이상이 필요합니다 |
| `hideOnboarding` | `false` | 온보딩 체크리스트(학사모 아이콘)를 숨깁니다 |
| `focusView` | `false` | 도구 호출, 도구 결과, 사고를 펼칠 수 있는 행 뒤로 숨기고 프롬프트와 Claude의 응답만 남깁니다. Claude의 최신 할 일 목록은 계속 표시되며, 이를 위해서는 Claude Code v2.1.225 이상이 필요합니다. 명령 메뉴에서 Focus view를 전환할 수도 있습니다. Claude Code v2.1.221 이상이 필요합니다 |
| `respectGitIgnore` | `true` | 파일 검색 및 [선택 컨텍스트](#selected-text-from-excluded-or-ignored-files)에서 .gitignore 패턴을 제외합니다 |
| `usePythonEnvironment` | `true` | Claude를 실행할 때 워크스페이스의 Python 환경을 활성화합니다. Python 확장 프로그램이 필요합니다. |
| `environmentVariables` | `[]` | Claude 프로세스의 환경 변수를 설정합니다. 공유 구성에는 대신 Claude Code 설정을 사용하세요. [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars) 항목은 값이 절대 경로인 경우에만 적용되며, 확장 프로그램은 `~`를 확장하지 않고 상대 값은 무시합니다. |
| `disableLoginPrompt` | `false` | 인증 프롬프트를 건너뜁니다(서드파티 제공업체 설정용) |
| `allowDangerouslySkipPermissions` | `false` | 모드 선택기에 Bypass permissions를 추가합니다. 인터넷 접근이 없는 샌드박스에서만 사용하세요. |
| `claudeProcessWrapper` | - | Claude 프로세스를 실행하는 데 사용되는 실행 파일입니다. 번들 바이너리가 있는 경우 해당 경로가 인수로 전달됩니다. 확장 프로그램 빌드에 사용 중인 플랫폼용 바이너리가 포함되어 있지 않다면 별도로 설치한 `claude` 바이너리로 설정하세요. |

## 서드파티 공급자 사용

기본적으로 Claude Code는 Anthropic의 API에 직접 연결됩니다. 조직에서 Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry를 사용하여 Claude에 액세스하는 경우, 대신 해당 공급자를 사용하도록 확장 프로그램을 구성합니다.

**1. 로그인 프롬프트 비활성화**

[Disable Login Prompt 설정](vscode://settings/claudeCode.disableLoginPrompt)을 열고 확인란을 선택합니다.

Mac에서는 `Cmd+,`, Windows/Linux에서는 `Ctrl+,`를 눌러 VS Code 설정을 열고 "Claude Code login"을 검색한 다음 **Disable Login Prompt**를 선택할 수도 있습니다.

**2. 공급자 구성**

사용하는 공급자의 설정 가이드를 따릅니다.

* [Amazon Bedrock에서 Claude Code 사용](https://code.claude.com/docs/ko/amazon-bedrock.md)
* [Google Cloud의 Agent Platform에서 Claude Code 사용](https://code.claude.com/docs/ko/google-vertex-ai.md)
* [Microsoft Foundry에서 Claude Code 사용](https://code.claude.com/docs/ko/microsoft-foundry.md)

이 가이드에서는 `~/.claude/settings.json`에서 공급자를 구성하는 방법을 다루며, 이를 통해 VS Code 확장 프로그램과 CLI 간에 설정이 공유됩니다.

서드파티 공급자를 사용하는 경우, 확장 프로그램은 플랜 사용량 표시줄, [음성 받아쓰기](https://code.claude.com/docs/ko/voice-dictation.md), [클라우드 세션](#resume-cloud-sessions-from-claude-ai)용 Web 탭 등 claude.ai 계정이 필요한 기능을 제공하지 않습니다. 이러한 로그인 방식에서 Account & usage 대화 상자에 표시되는 내용은 [계정 및 사용량 확인](#check-account-and-usage)을 참조하십시오.

이전 `/login`에서 남아 있는 claude.ai 로그인은 사용되지 않습니다. 확장 프로그램은 어떤 요청에도 이를 함께 보내지 않습니다.

## 스크린 리더 사용

확장 프로그램의 채팅 패널은 스크린 리더와 함께 작동합니다. 별도로 켜야 할 설정은 없습니다. 확장 프로그램은 시각적인 변화 없이 모든 사용자에게 대화 활동을 안내합니다. 이는 터미널 인터페이스를 조정하는 CLI의 옵트인 [스크린 리더 모드](https://code.claude.com/docs/ko/accessibility.md)와는 별개입니다.

채팅 패널의 스크린 리더 지원에는 Claude Code v2.1.236 이상이 필요합니다.

대화 중에 확장 프로그램은 다음을 안내합니다.

* **Claude의 응답**: 확장 프로그램은 각 응답이 완료되었을 때 한 번 안내하며, 텍스트가 스트리밍되는 동안에는 안내하지 않습니다. 스크린 리더는 코드 블록을 줄 수 요약으로 읽고, 링크는 레이블로 읽으며, 표는 셀 단위로 읽습니다. 전체 응답은 트랜스크립트에서 계속 읽을 수 있습니다.
* **권한 요청 및 질문**: 확장 프로그램은 권한 프롬프트가 나타날 때 Claude가 사용하려는 도구의 이름과 함께 요청을 안내합니다. Claude가 사용자에게 질문할 때와 Claude가 계획을 마치고 사용자의 검토를 기다릴 때도 같은 방식으로 안내합니다.
* **상태 변경**: 확장 프로그램은 Claude가 작업을 시작할 때, Claude가 사용자의 입력을 받을 준비가 되었을 때, Claude Code가 대화 압축을 시작할 때 안내합니다. 세션의 [SessionStart](https://code.claude.com/docs/ko/hooks.md#sessionstart) 훅이 아직 실행 중일 때 프롬프트를 보내면 스크린 리더는 "Running start-up hooks."라고도 안내합니다.
* **대기 중인 메시지**: Claude가 작업하는 동안 메시지를 보내면 확장 프로그램은 해당 메시지에 대해 "Message queued."라고 안내합니다.
* **오류 및 모델 프롬프트**: 확장 프로그램은 대화 중 발생한 오류를 안내하며, [사용량 크레딧 동의 프롬프트](https://code.claude.com/docs/ko/model-config.md#fable-and-usage-credits) 또는 [플래그된 요청 프롬프트](https://code.claude.com/docs/ko/model-config.md#ask-before-switching)가 나타날 때도 안내합니다.

Claude가 작업하는 동안 스크린 리더는 진행 스피너 애니메이션 대신 텍스트 레이블을 읽습니다.

세션을 다시 열거나 다른 세션으로 전환하면 확장 프로그램은 아무것도 안내하지 않습니다. 복원된 기록, 대기 중인 권한 프롬프트, 진행 중인 상태는 새로운 일이 발생할 때까지 안내되지 않습니다.

### 키보드로 채팅 패널 사용

트랜스크립트의 각 턴은 해당 턴을 시작한 프롬프트로 레이블이 지정된, 시각적으로 숨겨진 제목으로 시작합니다. 스크린 리더의 제목 탐색 기능을 사용하여 턴 사이를 이동할 수 있습니다.

턴 안에서 이동할 때 스크린 리더는 현재 위치한 메시지가 누구의 것인지 안내합니다.

* **사용자의 메시지**: "You"
* **Claude의 메시지**: "Claude"
* **도구 단계**: "Claude"와 도구 이름(예: "Claude, Bash")
* **사고 블록**: "Claude, thinking"

확장 프로그램은 트랜스크립트를 레이블이 지정된 영역으로 노출하므로, `Tab`으로 트랜스크립트 자체에 포커스를 옮겨 원하는 속도로 읽을 수도 있습니다. 대신 최신 메시지나 대기 중인 권한 프롬프트로 포커스를 옮기려면 [명령 팔레트](#vs-code-commands-and-shortcuts)에서 **Claude Code: Focus last message**를 실행합니다.

권한 프롬프트 옵션이 권한 규칙이나 디렉터리 접근을 저장하는 경우, 해당 레이블의 끝에는 "all projects" 또는 "this session"처럼 승인이 저장되는 위치가 표시됩니다. 저장 위치를 변경하려면 다음과 같이 합니다.

* 해당 옵션에 포커스를 둔 상태에서 `Left` 또는 `Right` 화살표 키를 누릅니다. 각 저장 위치로 이동할 때마다 확장 프로그램이 해당 위치를 안내합니다. 화살표 키를 사용하려면 Claude Code v2.1.268 이상이 필요합니다.
* 레이블에서 저장 위치를 클릭합니다.

## VS Code 확장 프로그램과 Claude Code CLI 비교

Claude Code는 VS Code 확장 프로그램(그래픽 패널)과 CLI(터미널의 명령줄 인터페이스) 두 가지 형태로 제공됩니다. 일부 기능은 CLI에서만 사용할 수 있습니다. CLI 전용 기능이 필요하다면 VS Code의 통합 터미널에서 `claude`를 실행하면 됩니다. 이를 위해서는 [독립 실행형 CLI 설치](https://code.claude.com/docs/ko/setup.md)가 필요합니다. 확장 프로그램은 `claude`를 PATH에 추가하지 않습니다. [VS Code에서 CLI 실행](#run-cli-in-vs-code)을 참조하세요.

| 기능 | CLI | VS Code 확장 프로그램 |
| - | - | - |
| 명령 및 스킬 | [전체](https://code.claude.com/docs/ko/commands.md) | 일부(`/`를 입력하여 사용 가능한 항목 확인) |
| MCP 서버 구성 | 예 | 예: 채팅 패널에서 `/mcp`로 [서버 추가 및 관리](#connect-to-external-tools-with-mcp) |
| 체크포인트 | 예 | 예 |
| `!` Bash 단축키 | 예 | 아니요 |
| 탭 자동 완성 | 예 | 아니요 |

### VS Code에서 CLI 실행

VS Code를 벗어나지 않고 CLI를 사용하려면 Windows/Linux에서는 `` Ctrl+` ``, Mac에서는 `` Cmd+` ``를 눌러 통합 터미널을 연 다음 `claude`를 실행합니다. CLI는 diff 보기 및 진단 정보 공유와 같은 기능을 위해 IDE와 자동으로 통합됩니다. 외부 터미널을 사용하는 경우 Claude Code 내에서 `/ide`를 실행하여 VS Code에 연결합니다.

확장 프로그램을 설치해도 `claude`가 셸 PATH에 추가되지는 않습니다. 확장 프로그램은 채팅 패널용으로 CLI의 비공개 사본을 번들로 포함하지만, 터미널에서 `claude`를 입력하려면 [독립 실행형 CLI 설치](https://code.claude.com/docs/ko/setup.md)가 필요합니다. 설치를 한 번 실행하면 `claude mcp add` 및 `claude --resume`을 포함하여 이 페이지의 명령을 모든 터미널에서 사용할 수 있습니다. 설치 후에도 `claude`를 찾을 수 없다면 [PATH를 확인](https://code.claude.com/docs/ko/troubleshoot-install.md#verify-your-path)하세요.

### 확장 프로그램과 CLI 간 전환

확장 프로그램과 CLI는 동일한 대화 기록을 공유합니다. 확장 프로그램에서 진행하던 대화를 CLI에서 이어가려면 터미널에서 `claude --resume`을 실행합니다. 그러면 대화를 검색하고 선택할 수 있는 대화형 선택 화면이 열립니다.

## MCP로 외부 도구에 연결하기

MCP (Model Context Protocol) 서버를 사용하면 Claude가 외부 도구, 데이터베이스, API에 액세스할 수 있습니다.

VS Code를 벗어나지 않고 MCP 서버를 관리하려면 채팅 패널에 `/mcp`를 입력합니다. 열리는 대화 상자에서 다음 작업을 수행할 수 있습니다.

* 서버 추가
* 로컬, 사용자 또는 프로젝트 [범위](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes)에 저장된 서버 제거
* 서버 활성화 또는 비활성화
* 서버에 다시 연결
* OAuth 인증 관리

대화 상자에서 서버를 추가하고 제거하려면 Claude Code v2.1.261 이상이 필요합니다.

VS Code의 통합 터미널(`` Ctrl+` `` 또는 `` Cmd+` ``)에서 `claude mcp add`를 실행할 수도 있습니다. 대화 상자와 터미널 명령은 동일한 MCP 구성에 저장되며, 어느 쪽에서 변경하든 이후에 시작하는 대화에 적용됩니다. 아래 예시는 헤더로 전달되는 [개인 액세스 토큰](https://github.com/settings/personal-access-tokens)으로 인증하는 GitHub의 원격 MCP 서버를 추가합니다.

```bash theme={null}
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer YOUR_GITHUB_PAT"
```

`YOUR_GITHUB_PAT`를 개인 액세스 토큰으로 바꿉니다. `claude mcp add` 명령은 자격 증명을 검증하지 않고 구성을 저장하므로, 여기서는 자리 표시자 값도 허용되지만 나중에 서버 연결에 실패합니다. 연결을 확인하려면 새 대화를 시작하고 `/mcp`를 입력한 다음 서버가 **Connected**로 표시되는지 확인합니다. 자격 증명이 잘못된 서버는 **Failed**로 표시됩니다.

구성이 완료되면 Claude에게 도구를 사용하도록 요청합니다(예: "Review PR #456").

> [!NOTE]
>
> 연결할 서버를 찾으려면 [MCP 서버 찾기 및 빌드하기](https://code.claude.com/docs/ko/mcp.md#find-and-build-mcp-servers)를 참조하세요.

## 내장 IDE MCP 서버

확장 프로그램이 활성화되면 CLI가 자동으로 연결하는 로컬 MCP 서버가 실행됩니다. 이 서버를 통해 CLI는 다음을 수행합니다.

* VS Code의 기본 diff 뷰어에서 diff를 엽니다
* `@` 멘션을 위해 현재 선택 영역을 읽습니다
* Jupyter 노트북에서 작업할 때 VS Code에 셀 실행을 요청합니다

이 서버의 이름은 `ide`이며, 구성할 항목이 없으므로 `/mcp`에 표시되지 않습니다. 다만 조직에서 `PreToolUse` 훅을 사용해 MCP 도구를 허용 목록으로 관리한다면 이 서버의 존재를 알고 있어야 합니다.

**선택 영역 및 열린 파일 컨텍스트.** 연결되어 있는 동안 CLI는 전송하는 각 프롬프트에 현재 편집기 선택 영역과 활성 파일의 경로를 컨텍스트로 포함합니다. 이 경우 트랜스크립트에 `⧉ Selected N lines from <file>` 줄이 표시됩니다. 다음 경우에는 이 컨텍스트가 달라집니다.

* **[Attach Selection 설정](#keep-your-selection-and-open-file-out-of-your-messages) 꺼짐**: CLI가 선택 영역을 컨텍스트로 포함하지 않습니다.
* **Attach Open File 설정 꺼짐**: CLI는 선택 영역도 함께 포함하는 경우에만 활성 파일의 경로를 포함합니다.
* **대기열에 추가된 메시지**: [Claude가 작업하는 동안 메시지를 대기열에 추가](https://code.claude.com/docs/ko/interactive-mode.md#queue-messages-while-claude-works)하면, 이후에 무엇을 선택하든 `Enter`를 눌렀을 때의 선택 영역이 유지됩니다.
* **민감한 파일**: `.env`와 같은 민감한 파일을 제외하려면 해당 경로에 대한 [`Read` 거부 규칙](https://code.claude.com/docs/ko/permissions#read-and-edit)을 추가합니다. 일치하는 거부 규칙이 있으면 해당 파일의 선택된 텍스트와 열린 파일 알림이 모두 Claude에 전달되지 않습니다.

**전송 방식 및 인증.** 서버는 10000–65535 범위의 임의 포트로 `127.0.0.1`에 바인딩되며, 포트는 구성할 수 없습니다. 전송 방식과 인증 토큰은 다음과 같이 작동합니다.

* **전송 방식**: 암호화되지 않은 `ws://`입니다. 소켓은 루프백 전용이므로 트래픽을 가로챌 수 있는 프로세스라면 잠금 파일에서 토큰도 읽을 수 있어, TLS를 사용해도 보호 수준이 높아지지 않습니다.
* **인증 토큰**: 확장 프로그램이 활성화될 때마다 새로운 임의 인증 토큰이 생성되어 `~/.claude/ide/<port>.lock`의 잠금 파일에 기록됩니다. CLI가 연결하려면 이 토큰을 `X-Claude-Code-Ide-Authorization` 헤더로 제시해야 합니다.
* **잠금 파일 권한**: 잠금 파일은 `0700` 디렉터리 안에 `0600` 권한으로 저장되므로 VS Code를 실행하는 사용자만 읽을 수 있습니다. `CLAUDE_CONFIG_DIR`이 설정되어 있으면 잠금 파일은 대신 `$CLAUDE_CONFIG_DIR/ide/`에 기록됩니다.

**모델에 노출되는 도구.** 서버는 십여 개의 도구를 호스팅하지만 모델에 표시되는 도구는 두 개뿐입니다. 나머지는 diff 열기, 선택 영역 읽기, 파일 저장 등 CLI가 자체 UI에 사용하는 내부 RPC입니다. 이러한 도구는 도구 목록이 Claude에 전달되기 전에 필터링됩니다.

| 도구 이름(훅에 표시되는 이름) | 기능 | 읽기 전용 |
| - | - | - |
| `mcp__ide__getDiagnostics` | 언어 서버 진단 정보, 즉 VS Code의 Problems 패널에 있는 오류와 경고를 반환합니다. 선택적으로 하나의 파일로 범위를 제한할 수 있습니다. | 예 |
| `mcp__ide__executeCode` | 활성 Jupyter 노트북의 커널에서 Python 코드를 실행합니다. 아래의 확인 절차를 참조하세요. | 아니요 |

**채팅 패널의 진단 정보.** Claude Code v2.1.285 이상의 채팅 패널에서는 Claude가 `claude-vscode`라는 별도의 내장 서버를 통해 VS Code의 Problems 패널을 읽습니다. Claude는 이 서버에 하나의 파일 또는 VS Code에 진단 정보가 있는 모든 파일의 현재 오류와 경고를 요청할 수 있습니다.

훅과 권한 규칙에서는 채팅 패널의 진단 도구가 `mcp__claude-vscode__getDiagnostics`로 표시됩니다. CLI와 채팅 패널 양쪽의 진단 정보를 모두 다루려면 훅이나 규칙에 `mcp__ide__getDiagnostics`와 `mcp__claude-vscode__getDiagnostics`를 모두 지정합니다.

다음 `settings.json` 예시는 두 도구를 모두 거부합니다.

```json theme={null}
{
  "permissions": {
    "deny": [
      "mcp__ide__getDiagnostics",
      "mcp__claude-vscode__getDiagnostics"
    ]
  }
}
```

`Read` 거부 규칙은 두 도구 어느 쪽에도 적용되지 않으므로, 예시처럼 [거부 규칙](https://code.claude.com/docs/ko/permissions.md#mcp)을 사용해 이름으로 차단합니다.

**Jupyter 실행은 항상 먼저 확인을 요청합니다.** `mcp__ide__executeCode`는 아무것도 조용히 실행할 수 없습니다. 각 호출은 다음 단계를 거칩니다.

1. 코드가 활성 노트북 끝에 새 셀로 삽입됩니다.
2. VS Code가 해당 셀이 보이도록 스크롤합니다.
3. 기본 Quick Pick이 **Execute** 또는 **Cancel**을 선택하도록 묻습니다.

취소하거나 `Esc`로 선택기를 닫으면 Claude에 오류가 반환되고 아무것도 실행되지 않습니다. 또한 활성 노트북이 없거나, Jupyter 확장 프로그램(`ms-toolsai.jupyter`)이 설치되어 있지 않거나, 커널이 Python이 아닌 경우에는 도구가 즉시 실행을 거부합니다.

> [!NOTE]
>
> Quick Pick 확인은 `PreToolUse` 훅과는 별개입니다. `mcp__ide__executeCode`에 대한 허용 목록 항목은 Claude가 셀 실행을 *제안*할 수 있게 할 뿐이며, 셀을 *실제로* 실행하게 하는 것은 VS Code 내부의 Quick Pick입니다.

## 일반적인 문제 해결

로그인, 네트워크, 실행 오류는 설치 문제 해결 페이지와 오류 참조 페이지에 각각 별도 항목이 있습니다. 표에서 표시된 내용을 찾은 다음 링크를 따라가십시오.

| 표시되는 내용 | 참조할 위치 |
| - | - |
| 로그인한 후 `API Error: 403 Request not allowed` 발생 | [로그인 후 403 Forbidden](https://code.claude.com/docs/ko/troubleshoot-install.md#403-forbidden-after-login) |
| 이미 로그인했는데 다시 로그인하라는 요청을 받음 | [로그인되지 않았거나 토큰이 만료됨](https://code.claude.com/docs/ko/troubleshoot-install.md#not-logged-in-or-token-expired) |
| 클라우드 제공업체 자격 증명이 터미널에서는 작동하지만 확장 프로그램에서는 작동하지 않음 | [Bedrock, Agent Platform 또는 Foundry 자격 증명이 로드되지 않음](https://code.claude.com/docs/ko/troubleshoot-install.md#bedrock-agent-platform-or-foundry-credentials-not-loading) |
| `SSL certificate verification failed` 또는 `Self-signed certificate detected` | [SSL 인증서 오류](https://code.claude.com/docs/ko/errors.md#ssl-certificate-errors) |
| `Dictation error: WebSocket error:` 뒤에 `unable to get local issuer certificate` 같은 인증서 오류가 표시되거나, Web 탭에 `Remote server is not connected`가 표시됨 | [TLS 검사 프록시 뒤에서 받아쓰기 또는 Web 탭이 실패하는 경우](#dictation-or-the-web-tab-fails-behind-a-tls-inspecting-proxy) |
| `Claude Code process exited with code 1` 또는 다른 코드 | [Claude Code process exited with code N](https://code.claude.com/docs/ko/errors.md#claude-code-process-exited-with-code-n) |
| `Could not locate the Claude CLI on PATH` | [Could not locate the Claude CLI on PATH](https://code.claude.com/docs/ko/errors.md#could-not-locate-the-claude-cli-on-path) |
| `The connection to Claude Code ended before this message completed` | [The connection to Claude Code ended before this message completed](https://code.claude.com/docs/ko/errors.md#the-connection-to-claude-code-ended-before-this-message-completed) |
| `The Claude Code program for this computer, the <build> build, could not be found` | [The Claude Code program for this computer could not be found](https://code.claude.com/docs/ko/errors.md#the-claude-code-program-for-this-computer-could-not-be-found) |
| VS Code의 통합 터미널에서 `claude`를 찾을 수 없음 | [VS Code에서 CLI 실행](#run-cli-in-vs-code) |

### 확장 프로그램이 설치되지 않는 경우

* 호환되는 VS Code 버전(1.94.0 이상)인지 확인합니다
* VS Code에 확장 프로그램을 설치할 권한이 있는지 확인합니다
* [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code)에서 직접 설치해 봅니다

### Spark 아이콘이 보이지 않는 경우

Spark 아이콘은 파일이 열려 있을 때 **Editor Toolbar**(편집기 오른쪽 상단)에 표시됩니다. 아이콘이 보이지 않는 경우:

1. **파일 열기**: 아이콘을 표시하려면 파일이 열려 있어야 합니다. 폴더만 열려 있는 것으로는 충분하지 않습니다.
2. **VS Code 버전 확인**: 1.94.0 이상이 필요합니다. **Help > About**에서 확인합니다
3. **VS Code 재시작**: Command Palette에서 "Developer: Reload Window"를 실행합니다
4. **충돌하는 확장 프로그램 비활성화**: 다른 AI 확장 프로그램(Cline, Continue 등)을 일시적으로 비활성화합니다
5. **워크스페이스 신뢰 확인**: 확장 프로그램은 Restricted Mode에서 작동하지 않습니다

또는 창 오른쪽 하단 모서리의 **Status Bar**에서 **✻ Claude Code**를 클릭합니다. 이 방법은 파일이 열려 있지 않아도 작동합니다. **Command Palette**(`Cmd+Shift+P` / `Ctrl+Shift+P`)를 열고 "Claude Code"를 입력할 수도 있습니다.

### macOS에서 Cmd+Esc가 작동하지 않는 경우

macOS Tahoe 이상에서는 시스템 Game Overlay 단축키가 기본적으로 `Cmd+Esc`에 지정되어 있어 키 입력이 VS Code에 도달하기 전에 가로챕니다. 단축키를 해제하려면:

1. System Settings를 엽니다
2. Keyboard, Keyboard Shortcuts, Game Controllers 순으로 이동합니다
3. Game Overlay 체크박스를 해제합니다

또는 확장 프로그램을 다른 키에 다시 지정합니다. VS Code [Keyboard Shortcuts 편집기](https://code.visualstudio.com/docs/configure/keybindings)(`Cmd+K Cmd+S`)를 열고 `Claude Code: Focus input`을 검색한 다음 새 키보드 단축키를 지정합니다.

### 프롬프트 상자에서 Ctrl+J가 새 줄을 추가하는 경우

프롬프트 상자에서 `Ctrl+J`가 새 줄을 추가하지 않도록 하려면 Claude Code의 `keybindings.json` 파일에서 [키의 바인딩을 해제](https://code.claude.com/docs/ko/keybindings.md#unbind-default-shortcuts)하십시오. 확장 프로그램은 버전 2.1.309 이상에서 이 파일을 읽으므로, 이전 버전의 확장 프로그램을 사용 중이라면 먼저 Extensions 보기에서 업데이트하십시오.

다음 예시는 키의 바인딩을 해제하는 항목 하나, 즉 `Chat` 블록 안의 `"ctrl+j": null`만 담긴 전체 파일입니다.

```json theme={null}
{
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+j": null
      }
    }
  ]
}
```

이 파일은 Claude Code 구성 디렉터리에 두며, `CLAUDE_CONFIG_DIR`로 위치를 옮기지 않았다면 이 디렉터리는 `~/.claude`입니다. 해당 디렉터리를 확인하고 발견한 내용에 맞는 단계를 수행하십시오.

* **`keybindings.json`이 아직 없는 경우**: 예시와 정확히 같은 내용으로 파일을 만듭니다
* **`keybindings.json`에 `Chat` 블록이 없는 경우**: 최상위 `bindings` 배열에 예시의 `Chat` 블록을 추가합니다. 위치는 어디든 상관없습니다
* **`Chat` 블록에 `"ctrl+j"` 줄이 없는 경우**: 해당 블록의 `bindings`에 `"ctrl+j": null`을 추가합니다
* **`Chat` 블록에 이미 `"ctrl+j"` 줄이 있는 경우**: 해당 줄의 값을 `null`로 변경합니다

파일을 저장하고 나면 프롬프트 상자에서 `Ctrl+J`를 눌러도 새 줄이 추가되지 않습니다.

그래도 프롬프트 상자에서 `Ctrl+J`가 줄을 추가한다면 Command Palette에서 다음 두 명령을 순서대로 실행하십시오.

1. **Developer: Reload Window**를 실행한 다음 프롬프트 상자에서 `Ctrl+J`를 다시 누릅니다
2. **Claude Code: Show Logs**를 실행한 다음 `Ctrl+J in the chat input still inserts a newline`이 포함된 경고를 찾습니다. 경고가 알려 주는 파일에서 보고된 문제를 수정하고 파일을 저장한 다음 `Ctrl+J`를 다시 누릅니다.

로그에 그러한 경고가 없다면 파일이 Claude Code 구성 디렉터리에 있는지, 그리고 파일의 `Chat` 블록이 `"ctrl+j"`를 `null`로 설정하는지 확인하십시오. 그래도 `Ctrl+J`가 줄을 추가한다면 [이슈를 보고](https://github.com/anthropics/claude-code/issues)하십시오.

### Claude Code 패널이 비어 있거나 로드되지 않는 경우

Claude Code 패널이 열리지만 프롬프트 상자조차 없이 아무것도 표시되지 않는다면 Extensions 보기에서 확장 프로그램을 v2.1.309 이상으로 업데이트하십시오. 그런 다음 Command Palette에서 **Developer: Reload Window**를 실행합니다. 이후 `Claude Code couldn’t load` 알림이 표시되면 알림에 나열된 단계를 순서대로 수행하십시오.

그래도 패널이 로드되지 않으면 확장 프로그램의 로그를 열고 로그 사본과 함께 [이슈를 보고](https://github.com/anthropics/claude-code/issues)하십시오.

* **v2.1.309 이상에서도 여전히 비어 있는 경우**: Command Palette에서 **Claude Code: Show Logs**로 로그를 엽니다
* **알림의 단계로 해결되지 않은 경우**: 알림에서 **Show logs**를 클릭하여 로그를 엽니다

### 재개한 대화가 처음에 비어 있는 경우

[이전 대화를 재개](#resume-past-conversations)하거나 대화가 [다시 로드 후 돌아올](#continue-conversations-after-a-reload) 때, 해당 대화의 Claude Code 프로세스가 시작되는 동안 메시지가 비어 있을 수 있습니다. 약 1초 후 빈 공간에 `Waiting for your plugins…`가 표시됩니다.

별도로 조치할 필요는 없습니다. 프로세스가 시작되고 먼저 메시지를 확인해야 하는 플러그인이 없음이 확인되면 메시지가 표시되며, 시작이 더 오래 걸리는 경우에는 20초 후에 표시됩니다.

### 다시 로드로 대화가 다시 열릴 때마다 패널이 응답하지 않는 경우

다시 로드하여 대화가 돌아올 때마다 패널 전체가 충돌하거나, 멈추거나, `Something went wrong`만 표시된다면 확장 프로그램을 v2.1.301 이상으로 업데이트하십시오. 그런 다음 창을 다시 로드하거나 VS Code를 다시 시작합니다. 대화가 두 번 연속으로 열기를 완료하지 못하면 그 자리에 새 채팅이 열리고, [대화가 다시 열리지 않았다](#a-conversation-was-not-reopened)는 알림이 표시됩니다.

### 수식이 원시 LaTeX로 표시되는 경우

Claude의 응답에 있는 수식이 하나도 조판되지 않는다면 Extensions 보기에서 확장 프로그램의 버전을 확인하십시오. [수식 렌더링](#latex-math-in-responses)에는 버전 2.1.301 이상이 필요합니다. 버전과 관계없이 수식을 조판하지 않는 [터미널 모드](#switch-to-terminal-mode)를 사용하는 경우, [Use Terminal 설정](vscode://settings/claudeCode.useTerminal)을 해제하여 Claude Code가 채팅 패널에서 열리도록 합니다.

주변의 다른 수식은 조판되는데 특정 수식 하나만 작성된 그대로 표시된다면 다음 원인을 확인하십시오.

* **인라인 수식을 패널이 수식으로 처리하지 않는 경우**: 별도의 줄에 `$$` 블록으로 다시 보내 달라고 Claude에게 요청하십시오. 패널은 `$…$` 구분 기호 사이의 텍스트가 다음에 해당하면 인라인 수식을 작성된 그대로 둡니다.
  * `$O(n log n)$`처럼 단순한 산술 이상이지만 `=`, `+`, `^` 같이 수식임을 표시하는 문자가 없는 경우
  * `$30$`, `$1/N$`처럼 숫자로 시작하고 그러한 문자가 없는 경우
  * `$ x^2 $`처럼 달러 기호 안쪽에 공백이 있는 경우
  * 60자보다 긴 경우
  * 두 줄로 나뉜 경우. 두 줄로 나뉜 `\(…\)` 수식도 조판되지 않습니다.
* **수식에 TeX 구문 오류가 있는 경우**: 오류를 수정하여 다시 작성해 달라고 Claude에게 요청하십시오.
* **수식이 매크로를 정의하는 경우**: `\newcommand`나 `\def` 같은 매크로 정의가 있는 수식은 작성된 그대로 표시됩니다. 매크로 없이 다시 작성해 달라고 Claude에게 요청하십시오.
* **수식에 이스케이프되지 않은 `%`가 포함된 경우**: 퍼센트 기호에 `\%`를 사용하여 다시 작성해 달라고 Claude에게 요청하십시오.
* **수식이 너무 큰 경우**: 8,192자보다 긴 수식이나 조판된 출력이 TeX 소스보다 훨씬 커지는 수식은 작성된 그대로 표시됩니다. 더 작은 수식으로 나누거나 더 간결하게 작성해 달라고 Claude에게 요청하십시오.
* **많은 양의 수식 뒤에 오는 경우**: 응답의 한 텍스트 블록 안에서 패널은 한도까지 수식을 순서대로 조판합니다. 한도를 넘어서는 이후 수식은 작성된 그대로 표시됩니다. 필요한 수식만 따로 다시 보내 달라고 Claude에게 요청하십시오.

### TLS 검사 프록시 뒤에서 받아쓰기 또는 Web 탭이 실패하는 경우

받아쓰기 또는 Web 탭이 `unable to get local issuer certificate` 같은 인증서 오류로 실패하면 `~/.claude/settings.json`의 `env` 블록에 [`NODE_EXTRA_CA_CERTS`](https://code.claude.com/docs/ko/network-config#custom-ca-certificates)를 설정하십시오. 값은 프록시의 루트 CA 인증서가 담긴 PEM 파일의 경로로 설정하며, 이 파일은 IT 팀에서 받을 수 있습니다. 이 실패는 마이크 버튼이나 Web 탭, 또는 로그에 표시됩니다.

* **받아쓰기**: 마이크 버튼에 `Dictation error: WebSocket error:` 뒤에 오류 텍스트가 표시됩니다.
* **Web 탭**: [클라우드 세션](#resume-cloud-sessions-from-claude-ai)을 나열하는 탭에는 오류 텍스트 없이 `Remote server is not connected`만 표시됩니다. 로그에서 오류 텍스트를 확인하려면:
  1. [Command Palette](#vs-code-commands-and-shortcuts)에서 **Claude Code: Show Logs**를 실행하여 `Claude VSCode` 출력 채널을 엽니다.
  2. 탭에서 **Reconnect**를 클릭하고 `Connecting…`이 더 이상 표시되지 않을 때까지 기다립니다.
  3. 채널에서 `Error fetching remote sessions:` 또는 `Failed to fetch organization UUID:`를 검색한 다음, 일치하는 줄 중 가장 최근 줄에서 해당 접두사 뒤의 오류 텍스트를 확인합니다.
* **로그 경고**: `an authority that Claude Code does not trust`를 언급하는 경고는 인증서 오류를 보고합니다. TLS 검사 프록시 뒤에 있다면 `~/.claude/settings.json`의 `env`에 `NODE_EXTRA_CA_CERTS`를 설정하십시오. v2.1.309 이전 버전은 이 경고를 로그에 기록하지 않습니다.

이 해결 방법에는 확장 프로그램 버전 2.1.307 이상이 필요하므로 먼저 확장 프로그램을 업데이트하십시오. 그런 다음 `NODE_EXTRA_CA_CERTS`를 `~` 없이 작성한 인증서 파일의 전체 경로로 설정합니다. Windows 경로의 경우 `settings.json`에서 `C:\\certs\\example-ca.pem`처럼 각 백슬래시를 두 번 작성합니다.

> [!NOTE]
>
> WSL, SSH 호스트, 개발 컨테이너 또는 다른 시스템에 연결된 창에서는 로컬 컴퓨터가 아닌 해당 시스템에 인증서 파일을 저장하고 `~/.claude/settings.json`을 편집하십시오.

다음 예시는 Linux 또는 macOS 경로 `/etc/ssl/certs/example-ca.pem`에 있는 인증서 파일을 지정합니다.

```json ~/.claude/settings.json theme={null}
{
  "env": {
    "NODE_EXTRA_CA_CERTS": "/etc/ssl/certs/example-ca.pem"
  }
}
```

`settings.json`을 저장한 다음 녹음을 시작하거나 **Reconnect**를 다시 클릭합니다. 오류가 다시 발생하면 **Claude Code: Show Logs**로 출력 채널을 열고 `use the CA certificates file`을 검색하십시오. 이 경고는 확장 프로그램이 파일을 사용할 수 없는 이유와 경로를 읽어 온 위치를 알려 줍니다. 그런 다음 이 표에서 `NODE_EXTRA_CA_CERTS`를 설정한 각 위치를 찾아 해당 행의 안내에 따르십시오.

| 설정한 위치 | 조치 방법 |
| - | - |
| VS Code가 시작될 때의 환경 | 여기에 설정한 값은 지정된 파일을 사용할 수 없는 경우에도 `~/.claude/settings.json`의 값보다 우선합니다. 값을 수정하거나 제거한 다음 VS Code를 다시 시작합니다 |
| `~/.claude/settings.json`의 `env` | 값이나 값이 지정하는 파일을 수정한 다음 녹음을 시작하거나 **Reconnect**를 다시 클릭합니다 |
| VS Code의 [`claudeCode.environmentVariables`](#extension-settings) 설정, `~/.claude.json`, 프로젝트의 `.claude/settings.json` 또는 `.claude/settings.local.json`, 또는 관리형 설정 | 여기에 설정한 값은 받아쓰기나 Web 탭에 적용되지 않습니다. `~/.claude/settings.json`의 `env`에도 변수를 설정합니다 |

### Claude Code가 응답하지 않는 경우

Claude Code가 프롬프트에 응답하지 않는 경우:

1. **인터넷 연결 확인**: 인터넷 연결이 안정적인지 확인합니다
2. **새 대화 시작**: 새 대화를 시작하여 문제가 계속되는지 확인합니다
3. **CLI 사용해 보기**: 터미널에서 `claude`를 실행하여 더 자세한 오류 메시지가 표시되는지 확인합니다

문제가 계속되면 오류에 대한 세부 정보와 함께 [GitHub에 이슈를 제출](https://github.com/anthropics/claude-code/issues)하십시오.

## 확장 프로그램 제거

Claude Code 확장 프로그램을 제거하려면 다음을 수행합니다.

1. Mac에서는 `Cmd+Shift+X`, Windows/Linux에서는 `Ctrl+Shift+X`를 눌러 확장 프로그램 보기를 엽니다
2. "Claude Code"를 검색합니다
3. **Uninstall**을 클릭합니다

VS Code 통합 터미널에서 `claude`를 실행하면 Claude Code가 확장 프로그램을 자동으로 다시 설치합니다. 제거된 상태를 유지하려면 `/config`에서 **Auto-install IDE extension**을 끄거나 [`autoInstallIdeExtension`](https://code.claude.com/docs/ko/settings-reference#autoinstallideextension)을 `false`로 설정합니다. [`CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL`](https://code.claude.com/docs/ko/env-vars) 환경 변수를 `1`로 설정할 수도 있습니다.

확장 프로그램 데이터도 제거하고 모든 설정을 초기화하려면 플랫폼에 해당하는 확장 프로그램 저장소 디렉터리를 삭제합니다.

macOS의 경우:

```bash theme={null}
rm -rf ~/Library/"Application Support"/Code/User/globalStorage/anthropic.claude-code
```

Linux의 경우:

```bash theme={null}
rm -rf ~/.config/Code/User/globalStorage/anthropic.claude-code
```

Windows의 경우 PowerShell에서:

```powershell theme={null}
Remove-Item -Recurse -Force "$env:APPDATA\Code\User\globalStorage\anthropic.claude-code"
```

추가 도움이 필요하면 [문제 해결 가이드](https://code.claude.com/docs/ko/troubleshooting.md)를 참조하세요.

## 다음 단계

이제 VS Code에서 Claude Code 설정을 마쳤으니 다음 단계를 진행해 보세요.

* [일반적인 워크플로 살펴보기](https://code.claude.com/docs/ko/common-workflows.md)를 통해 Claude Code를 최대한 활용할 수 있습니다
* [MCP 서버 설정](https://code.claude.com/docs/ko/mcp.md)으로 외부 도구를 사용하여 Claude의 기능을 확장할 수 있습니다. 채팅 패널에서 `/mcp`를 사용하여 MCP 서버를 추가하고 관리합니다.
* [Claude Code 설정 구성](https://code.claude.com/docs/ko/settings.md)으로 허용된 명령, 훅 등을 사용자 지정할 수 있습니다. 이 설정은 확장 프로그램과 CLI 간에 공유됩니다.
* Claude Code의 [보안 안전 장치](https://code.claude.com/docs/ko/security.md) 및 [데이터 사용](https://code.claude.com/docs/ko/data-usage.md)을 검토합니다
