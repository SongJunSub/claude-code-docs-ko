> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Chrome에서 Claude Code 사용하기

> Claude Code를 Chrome 브라우저에 연결하여 웹 앱을 테스트하고, 콘솔 로그로 디버깅하며, 양식 작성을 자동화하고, 웹 페이지에서 데이터를 추출합니다.

Claude Code는 [Claude in Chrome 브라우저 확장 프로그램](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn)과 통합되어 CLI 또는 [VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md#automate-browser-tasks-with-chrome)에서 브라우저 자동화 기능을 제공합니다. 코드를 빌드한 후 컨텍스트를 전환하지 않고 브라우저에서 테스트하고 디버깅합니다.

Claude는 브라우저 작업을 위해 새 탭을 열고 브라우저의 로그인 상태를 공유하므로 이미 로그인한 모든 사이트에 액세스할 수 있습니다. 브라우저 작업은 실시간으로 표시되는 Chrome 창에서 실행됩니다. Claude가 로그인 페이지나 CAPTCHA를 만나면 일시 중지하고 수동으로 처리하도록 요청합니다.

확장 프로그램은 Claude가 연 탭을 세션에 연결된 Chrome 탭 그룹으로 모읍니다. 로컬 세션에서는 세션이 종료될 때 Claude Code가 해당 그룹을 닫는지 여부가 세션이 종료되는 방식에 따라 달라집니다.

* `/clear`를 입력하면 Claude Code는 열려 있는 페이지를 포함하여 그룹을 닫습니다. 단, clear 이후에도 유지되는 작업이 아직 실행 중인 경우는 예외입니다
* `/resume`과 같은 명령으로 세션을 전환하거나, Claude Code를 종료하거나, clear 이후에도 유지되는 작업이 아직 실행 중인 상태에서 `/clear`를 실행하면, Claude Code는 그룹에 빈 새 탭만 있는 경우에만 그룹을 닫으므로 아직 읽고 있을 수 있는 페이지는 열린 상태로 유지됩니다

> [!NOTE]
>
> Chrome 통합은 Google Chrome 및 Microsoft Edge에서 작동합니다. Claude Code는 Brave, Arc, Vivaldi, Opera를 포함한 기타 Chromium 기반 브라우저에서도 확장 프로그램을 감지하고 연결을 설정합니다. Chrome 통합은 Windows Subsystem for Linux(WSL)에서는 지원되지 않습니다.

## 기능

Chrome이 연결되면 단일 워크플로에서 브라우저 작업과 코딩 작업을 연결할 수 있습니다.

* **라이브 디버깅**: 콘솔 오류 및 DOM 상태를 직접 읽은 후 이를 유발한 코드를 수정합니다.
* **디자인 검증**: Figma 목업에서 UI를 만든 후 브라우저에서 열어 일치하는지 확인합니다.
* **웹 앱 테스트**: 양식 유효성 검사를 테스트하고, 시각적 회귀를 확인하거나, 사용자 흐름을 검증합니다.
* **인증된 웹 앱**: API 커넥터 없이 Google Docs, Gmail, Notion 또는 로그인한 모든 앱과 상호작용합니다.
* **데이터 추출**: 웹 페이지에서 구조화된 정보를 가져와 로컬에 저장합니다.
* **작업 자동화**: 데이터 입력, 양식 작성 또는 다중 사이트 워크플로와 같은 반복적인 브라우저 작업을 자동화합니다.
* **파일 업로드**: 로컬 컴퓨터의 파일을 웹 페이지의 업로드 필드에 첨부합니다.
* **세션 기록**: 브라우저 상호작용을 GIF로 기록하여 발생한 상황을 문서화하거나 공유합니다.

## 사전 요구 사항

Chrome에서 Claude Code를 사용하기 전에 다음이 필요합니다.

* [Google Chrome](https://www.google.com/chrome/), [Microsoft Edge](https://www.microsoft.com/edge) 또는 Brave, Arc, Vivaldi, Opera와 같은 기타 Chromium 기반 브라우저
* [Claude in Chrome 확장 프로그램](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) 버전 1.0.36 이상(Chrome 웹 스토어에서 제공)
* [Claude Code](https://code.claude.com/docs/ko/quickstart.md#step-1-install-claude-code)
* 직접 Anthropic 플랜 (Pro, Max, Ultra, Team 또는 Enterprise)

HIPAA가 활성화된 Enterprise 조직에서는 Claude in Chrome이 기본적으로 꺼져 있으며, [Owner](https://code.claude.com/docs/ko/server-managed-settings.md#access-control)가 [**Organization settings > Claude in Chrome**](https://claude.ai/admin-settings/browser-extension)에서 켤 수 있습니다. Anthropic과 체결한 비즈니스 제휴 계약(BAA)은 Claude in Chrome을 통해 타사 사이트로 전송되는 데이터를 보장하지 않습니다. 적격 서비스 목록은 [구현 가이드](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)를 참조하세요.

또한 Chrome 통합을 사용하려면 `/login`으로 로그인해야 합니다. API 키 또는 [`claude setup-token`](https://code.claude.com/docs/ko/authentication#generate-a-long-lived-token)으로 생성한 장기 토큰으로 인증하는 경우, `--chrome`을 전달하더라도 Claude Code는 Chrome 통합을 비활성화한 상태로 유지합니다. 브라우저 확장 프로그램은 해당 자격 증명으로 인증할 수 없습니다.

> [!NOTE]
>
> Chrome 통합은 Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry와 같은 타사 제공자를 통해 사용할 수 없습니다. 타사 제공자를 통해서만 Claude에 액세스하는 경우 이 기능을 사용하려면 별도의 claude.ai 계정이 필요합니다.

## CLI에서 시작하기

**1. Chrome과 함께 Claude Code 실행하기**

`--chrome` 플래그를 사용하여 Claude Code를 시작합니다.

```bash theme={null}
claude --chrome
```

Chrome과 함께 처음 실행하면 Claude Code가 통합 기능을 소개하고 사이트 권한의 작동 방식을 설명하는 일회성 대화 상자를 표시합니다. Enter 키를 눌러 계속합니다.

플래그 없이 이후 세션에서도 Chrome을 활성화하려면 [기본으로 Chrome 활성화하기](#enable-chrome-by-default)를 참조하십시오.

**2. Claude에게 브라우저 사용 요청하기**

이 예시는 터미널이나 에디터에서 페이지로 이동하고, 페이지와 상호작용하고, 발견한 내용을 보고하는 작업을 모두 수행합니다.

```text wrap theme={null}
Go to code.claude.com/docs, click on the search box,
type "hooks", and tell me what results appear
```

Claude Code가 브라우저 작업 전에 권한을 요청하면 승인합니다. 대화 상자는 `Claude in Chrome wants to`로 시작하며, 해당 세션 동안 그 사이트의 모든 작업을 허용하는 옵션을 제공합니다. Claude가 새 탭을 열고 작업을 시작합니다.

언제든지 `/chrome`을 실행하여 연결 상태를 확인하고, 권한을 관리하고, 확장 프로그램을 다시 연결하거나, 사용할 연결된 브라우저를 선택할 수 있습니다. 상태 패널에 `Status: Enabled` 및 `Extension: Installed`가 표시되면 통합 기능이 정상적으로 작동하는 것입니다.

둘 이상의 브라우저가 연결되어 있으면 Claude가 사용할 브라우저를 사용자가 선택합니다. 선택하기 전에 브라우저 작업이 시작되면 Claude가 브라우저를 하나 선택하도록 요청합니다. 나중에 브라우저를 전환하려면 `/chrome`을 실행하고 \*\*Select browser…\*\*를 선택합니다. 다른 브라우저가 연결되더라도 Claude는 사용자가 선택한 브라우저를 계속 사용합니다.

VS Code의 경우 [VS Code에서의 브라우저 자동화](https://code.claude.com/docs/ko/vs-code.md#automate-browser-tasks-with-chrome)를 참조하십시오.

### Claude가 요청할 때 확장 프로그램 설치하기

대화형 세션에서 Claude가 브라우저를 사용해야 하는데 Claude Code가 확장 프로그램을 감지하지 못하면, Claude Code는 "Claude wants to use your browser"라는 제목의 설치 프롬프트를 표시합니다. Claude Code는 세션당 최대 한 번만 묻습니다.

프롬프트는 세 가지 선택지를 제공합니다.

* **Install extension**: 브라우저에서 확장 프로그램 설치 페이지를 열고 안내에 따른 설정을 시작합니다. Claude Code는 설치가 완료될 때까지 기다린 후 확장 프로그램을 연결하고 같은 세션에서 브라우저 도구를 활성화합니다. 연결이 준비되면 "Continue with browser tools"를 선택하여 Claude가 브라우저에서 작업을 재개하도록 합니다. "Continue without browser tools"를 선택하여 설정을 중단하고 나중에 `/chrome`으로 완료할 수도 있습니다.
* **Not now**: 브라우저 도구 없이 작업을 계속합니다. Claude Code는 이후 세션에서 다시 물을 수 있습니다.
* **Don't ask again**: 이후 세션에서 프롬프트를 표시하지 않습니다. `/chrome`으로 언제든지 통합 기능을 설정할 수 있습니다.

두 가지 관리형 MCP 정책이 프롬프트를 끕니다.

* 조직에서 [`deniedMcpServers` 관리형 설정](https://code.claude.com/docs/ko/managed-mcp#policy-based-control-with-allowlists-and-denylists)으로 `claude-in-chrome` MCP 서버를 차단하면 Claude Code는 설치 프롬프트를 표시하지 않습니다.
* 조직에서 [관리 대상 세트와 함께 Claude in Chrome을 허용](https://code.claude.com/docs/ko/managed-mcp.md#allow-claude-in-chrome-alongside-the-managed-set)하지 않고 [`managed-mcp.json`](https://code.claude.com/docs/ko/managed-mcp#exclusive-control-with-managed-mcp-json) 파일을 배포하면 Claude Code는 설치 프롬프트를 표시하지 않습니다.

### 기본으로 Chrome 활성화하기

매번 `--chrome`을 전달하지 않고 Chrome을 연결하려면 CLI 세션에서 `/chrome`을 실행하고 \*\*`Enabled by default`\*\*를 선택합니다. [VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md#automate-browser-tasks-with-chrome)에서는 프롬프트 상자에 `/chrome`을 입력하고 **`Enabled by default`** 스위치를 켭니다. 두 곳은 하나의 설정을 공유하므로 어느 쪽에서 켜든 CLI와 VS Code 모두에서 켜집니다.

이 설정이 켜져 있고 Claude Code v2.1.287 이상을 사용하면 각 VS Code 세션이 시작될 때 브라우저에 연결되므로, 사용자가 `@browser`를 입력하기 전에도 Claude가 브라우저를 사용할 수 있습니다. 이전 버전이거나 설정이 꺼져 있으면 VS Code 세션은 `@browser`를 입력할 때 연결됩니다.

Chrome이 실행 중이 아니어도 Claude Code는 정상적으로 시작됩니다.

> [!NOTE]
>
> 기본으로 Chrome을 활성화하면 브라우저 도구와 해당 지침이 항상 로드되므로 컨텍스트 사용량이 증가합니다. 컨텍스트 소비가 늘어난 것을 발견하면 설정을 끄고 필요할 때만 연결하십시오. CLI에서는 `--chrome`을 사용하고, VS Code에서는 프롬프트 상자에 [`@browser`](https://code.claude.com/docs/ko/vs-code#automate-browser-tasks-with-chrome)를 입력합니다.

### 시작 대화 상자에 응답하기

`claude`를 시작할 때 "Claude in Chrome extension detected" 대화 상자가 나타나면, 선택한 응답에 따라 [**`Enabled by default`** 설정](#enable-chrome-by-default)이 변경됩니다.

* **Yes, use my browser**: 설정을 켜고 이 세션을 연결합니다
* **No, keep browser tools off** 또는 Esc: 설정을 끄며, Claude Code는 더 이상 Chrome 설정을 제안하지 않습니다

이후 세션에 적용할 응답을 변경하려면 `/chrome`을 실행합니다.

### 사이트 권한 관리하기

사이트 수준 권한은 Chrome 확장 프로그램에서 상속됩니다. Chrome 확장 프로그램 설정에서 권한을 관리하여 Claude가 탐색하고, 클릭하고, 입력할 수 있는 사이트를 제어합니다. [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서는 자동 모드 분류기 자체가 사이트에 대한 브라우저 호출을 승인하면, 권한 규칙이 Claude in Chrome에 대해 어떤 사이트든 거부하지 않는 한 확장 프로그램은 해당 호출에 대한 자체 사이트별 확인을 건너뜁니다.

### VS Code 세션의 권한 프롬프트

VS Code 세션에서 Claude Code가 브라우저 작업 전에 확인을 요청하면 프롬프트가 채팅 패널에 카드 형태로 나타납니다. 작업 대상이 허용하지 않은 사이트인 경우 카드에서 해당 사이트를 허용하는 옵션도 제공합니다.

[기본으로 Chrome 활성화](#enable-chrome-by-default)가 켜져 있어 시작 시 브라우저에 연결된 세션에서는, Manual, Edit automatically, Auto, Bypass permissions 모드에서 허용하지 않은 사이트에 대한 브라우저 작업 전에 Claude Code가 사용자에게 확인을 요청합니다. Auto 및 Bypass permissions 모드에서는 해당 세션에서 `@browser`를 입력할 때까지 이 동작이 적용됩니다.

### 플랜 모드의 브라우저 도구

[플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에서는 Claude가 GIF를 녹화하거나, 새 탭을 열거나, 단축키를 실행하기 전에 권한 프롬프트가 나타납니다. 대화형 CLI 세션에서 [bypass permissions 모드를 사용할 수 있고](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode) [기능 플래그 가져오기](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching)가 꺼져 있으면 이러한 호출은 프롬프트 없이 실행됩니다.

`tabs_context_mcp` 호출도 `createIfEmpty`를 설정하면 확인을 요청하며, 이러한 작업 중 하나라도 포함하는 `browser_batch` 호출도 마찬가지입니다.

## 예시 워크플로

다음 예시는 브라우저 작업을 코딩 작업과 결합하는 일반적인 방법을 보여 줍니다. 사용 가능한 브라우저 도구의 전체 목록을 확인하려면 `/mcp`를 실행하고 `claude-in-chrome`을 선택한 다음 **View tools**를 선택합니다.

### 로컬 웹 애플리케이션 테스트

웹 앱을 개발할 때 변경 사항이 올바르게 작동하는지 확인하도록 Claude에게 요청합니다.

```text wrap theme={null}
I just updated the login form validation. Can you open localhost:3000,
try submitting the form with invalid data, and check if the error
messages appear correctly?
```

Claude는 로컬 서버로 이동하여 폼과 상호 작용하고 관찰한 내용을 보고합니다.

### 콘솔 로그로 디버그

Claude는 콘솔 출력을 읽어 문제 진단을 도울 수 있습니다. 로그는 양이 많을 수 있으므로 전체 콘솔 출력을 요청하기보다는 어떤 패턴을 찾아야 하는지 Claude에게 알려 주는 것이 좋습니다.

```text wrap theme={null}
Open the dashboard page and check the console for any errors when
the page loads.
```

Claude는 콘솔 메시지를 읽고 특정 패턴이나 오류 유형으로 필터링할 수 있습니다.

### 폼 입력 자동화

반복적인 데이터 입력 작업의 속도를 높입니다.

```text wrap theme={null}
I have a spreadsheet of customer contacts in contacts.csv. For each row,
go to the CRM at crm.example.com, click "Add Contact", and fill in the
name, email, and phone fields.
```

Claude는 로컬 파일을 읽고 웹 인터페이스를 탐색하며 각 레코드의 데이터를 입력합니다.

### 웹 페이지에 파일 업로드

Claude는 사용자 컴퓨터의 파일을 페이지의 업로드 필드에 첨부할 수 있습니다. Claude Code가 파일을 읽고 그 내용을 브라우저로 전송하므로 업로드는 로컬 세션과 원격 세션 모두에서 작동합니다.

다음 예시는 로그 파일을 폼에 첨부합니다.

```text wrap theme={null}
Open the bug tracker at bugs.example.com, create a new issue,
and attach logs/session.log to it
```

Claude가 파일 첨부를 거부하거나 업로드가 실패하면 다음 원인을 확인합니다.

* **권한**: Claude는 세션이 파일을 읽도록 허용된 경우에만 해당 파일을 업로드할 수 있으므로, 파일에 대한 `Read` 접근을 거부하는 [권한 규칙](https://code.claude.com/docs/ko/settings-reference.md#permission-settings)은 해당 파일의 업로드도 차단합니다.
* **크기**: 한 번의 업로드에 포함할 수 있는 파일은 총 10 MB까지입니다.
* **하드 링크**: Claude는 하드 링크가 여러 개인 파일을 거부하며, 이는 `node_modules`와 같은 패키지 매니저 저장소 내부에서 흔히 발생합니다. 파일을 복사한 다음 복사본을 업로드합니다.
* **자격 증명 이름**: Claude는 `.env`, `.pem` 또는 `.key` 파일, `.ssh` 아래의 모든 항목처럼 자격 증명이 보관되는 이름이나 폴더에 해당하는 파일을 거부합니다. Claude Code v2.1.293 이상이 필요합니다.

### Google Docs에서 콘텐츠 초안 작성

API 설정 없이 Claude를 사용하여 문서에 직접 작성합니다.

```text wrap theme={null}
Draft a project update based on the recent commits and add it to my
Google Doc at docs.google.com/document/d/abc123
```

Claude는 문서를 열고 편집기를 클릭한 다음 콘텐츠를 입력합니다. 이 기능은 Gmail, Notion, Sheets 등 사용자가 로그인한 모든 웹 앱에서 작동합니다.

### 웹 페이지에서 데이터 추출

웹사이트에서 구조화된 정보를 가져옵니다.

```text wrap theme={null}
Go to the product listings page and extract the name, price, and
availability for each item. Save the results as a CSV file.
```

Claude는 페이지로 이동하여 콘텐츠를 읽고 데이터를 구조화된 형식으로 정리합니다.

### 여러 사이트에 걸친 워크플로 실행

여러 웹사이트에 걸쳐 작업을 조율합니다.

```text wrap theme={null}
Check my calendar for meetings tomorrow, then for each meeting with
an external attendee, look up their company website and add a note
about what they do.
```

Claude는 여러 탭을 오가며 정보를 수집하고 워크플로를 완료합니다.

### 데모 GIF 녹화

브라우저 상호 작용을 공유 가능한 녹화본으로 만듭니다.

```text wrap theme={null}
Record a GIF showing how to complete the checkout flow, from adding
an item to the cart through to the confirmation page.
```

Claude는 상호 작용 과정을 녹화하여 GIF 파일로 저장합니다. 녹화본에는 로그인된 페이지의 계정 정보를 포함하여 브라우저에 보이는 모든 내용이 담기므로, 팀 외부에 공유하기 전에 검토해야 합니다.

### 스크린샷을 디스크에 저장

스크린샷을 파일로 보관하도록 Claude에게 요청합니다.

```text wrap theme={null}
Take a screenshot of the checkout page and save it to disk
```

Claude는 이미지를 디스크에 저장하고 파일 경로를 알려 줍니다.

## 문제 해결

### 확장 프로그램이 감지되지 않음

Claude Code에서 Chrome 확장 프로그램을 감지할 수 없는 경우:

1. Chrome 확장 프로그램이 설치되어 있고 `chrome://extensions`에서 활성화되어 있는지 확인합니다.
2. `claude --version`을 실행하여 Claude Code가 최신 버전인지 확인합니다.
3. Chrome이 실행 중인지 확인합니다.
4. `/chrome`을 실행하고 "확장 프로그램 다시 연결"을 선택하여 연결을 다시 설정합니다.
5. 문제가 지속되면 Claude Code와 Chrome을 모두 다시 시작합니다.

Chrome 통합을 처음 활성화할 때 Claude Code는 네이티브 메시징 호스트 구성 파일을 설치합니다. Chrome은 시작 시 이 파일을 읽으므로 첫 번째 시도에서 확장 프로그램이 감지되지 않으면 Chrome을 다시 시작하여 새 구성을 선택합니다.

Claude Code는 첫 번째 설치 시에만 확장 프로그램을 연결하도록 요청하는 브라우저 탭을 엽니다. 빌드 또는 구성 디렉터리 전환 후와 같이 이후 세션에서 구성 파일을 다시 작성하는 경우에는 Claude Code가 탭을 다시 열지 않습니다.

연결이 계속 실패하면 다음 위치에 호스트 구성 파일이 있는지 확인합니다.

Chrome의 경우:

* **macOS**: `~/Library/Application Support/Google/Chrome/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
* **Linux**: `~/.config/google-chrome/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
* **Windows**: Windows 레지스트리에서 `HKCU\Software\Google\Chrome\NativeMessagingHosts\`를 확인합니다.

Edge의 경우:

* **macOS**: `~/Library/Application Support/Microsoft Edge/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
* **Linux**: `~/.config/microsoft-edge/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
* **Windows**: Windows 레지스트리에서 `HKCU\Software\Microsoft\Edge\NativeMessagingHosts\`를 확인합니다.

기타 Chromium 기반 브라우저는 브라우저 이름을 딴 자체 구성 디렉터리에서 동일한 파일을 읽습니다. 예를 들어 macOS의 Brave는 `~/Library/Application Support/BraveSoftware/Brave-Browser/NativeMessagingHosts/`를 사용하며, Windows에서는 각 브라우저에 `HKCU\Software\BraveSoftware\Brave-Browser\NativeMessagingHosts\`와 같은 자체 레지스트리 키가 있습니다.

### 프로젝트 설정으로 Chrome을 켤 수 없음

터미널에 다음 경고가 표시되면 작업 중인 프로젝트가 Chrome 통합을 켜려고 했지만 Claude Code가 이를 허용하지 않았다는 의미입니다.

```text wrap theme={null}
Claude Code ignored CLAUDE_CODE_ENABLE_CFC in this project's settings: a project can't turn on Claude in Chrome. To turn it on yourself, run /chrome or start with --chrome.
```

프로젝트의 `.claude/settings.json` 또는 `.claude/settings.local.json`이 Chrome 통합을 켜기 위해 `env` 블록에서 [`CLAUDE_CODE_ENABLE_CFC`](https://code.claude.com/docs/ko/env-vars#variables)를 `1`로 설정하고 있습니다. Claude Code가 이 설정을 적용하지 않았으므로 이 세션에서는 Chrome 통합이 꺼져 있으며 Claude에는 브라우저 도구가 없습니다.

이러한 파일은 프로젝트 디렉터리에 저장되며, 체크아웃한 저장소가 Claude를 사용자의 브라우저에 연결할 수 있어서는 안 되므로 Claude Code는 이 설정을 건너뜁니다.

현재 상태 그대로 계속 작업할 수 있습니다. 브라우저 도구가 필요하거나 경고를 없애려면 다음 중 하나를 수행합니다.

* **지금 브라우저 도구를 사용하려면**: 종료한 후 셸에서 `claude --chrome`으로 다시 시작합니다.
* **이후 세션에서 브라우저 도구를 사용하려면**: Claude Code 프롬프트에서 `/chrome`을 실행하고 [**Enabled by default**](#enable-chrome-by-default)를 선택합니다. 이는 실행 중인 세션이 아니라 이후에 시작하는 세션에 적용됩니다.
* **브라우저 도구 없이 경고를 없애려면**: 프로젝트의 설정 파일에서 `CLAUDE_CODE_ENABLE_CFC` 줄을 제거합니다.

### 브라우저가 응답하지 않음

Claude의 브라우저 명령이 작동하지 않는 경우:

1. 모달 대화 상자(경고, 확인, 프롬프트)가 페이지를 차단하고 있는지 확인합니다. JavaScript 대화 상자는 브라우저 이벤트를 차단하고 Claude가 명령을 수신하지 못하게 합니다. 대화 상자를 수동으로 닫은 후 Claude에게 계속하도록 알립니다.
2. Claude에게 새 탭을 만들고 다시 시도하도록 요청합니다.
3. `chrome://extensions`에서 Chrome 확장 프로그램을 비활성화했다가 다시 활성화하여 다시 시작합니다.

### 긴 세션 중 연결 끊김

Chrome 확장 프로그램의 서비스 워커는 확장 세션 중에 유휴 상태가 될 수 있으며, 이는 연결을 끊습니다. 비활성 기간 후 브라우저 도구가 작동하지 않으면 `/chrome`을 실행하고 "확장 프로그램 다시 연결"을 선택합니다.

`/chrome`을 실행하면 `Status` 줄을 확인합니다. "Not connected"로 표시되면 실행 중인 세션 자체의 Chrome 연결이 실패한 것입니다. "확장 프로그램 다시 연결"을 선택하여 해당 연결을 다시 시작합니다. 연결에 성공하면 Chrome에서 확장 프로그램의 다시 연결 페이지가 열립니다. v2.1.290 이전에는 "확장 프로그램 다시 연결"이 해당 페이지만 열 뿐 실패한 연결을 다시 시작하지 않았으므로, 이전 버전에서 브라우저 도구가 돌아오지 않으면 Claude Code를 업데이트합니다.

### 다른 조직으로 로그인된 확장 프로그램

둘 이상의 claude.ai 조직에 속해 있는 경우 확장 프로그램은 Claude Code와 동일한 조직으로 로그인되어 있어야 합니다. 두 조직이 다르면 둘 다 동일한 claude.ai 계정을 사용하더라도 Claude의 브라우저 도구가 "Browser extension is not connected"를 반환합니다.

Claude Code가 어떤 조직으로 로그인되어 있는지 확인하려면 Claude Code 프롬프트에서 [`/status`](https://code.claude.com/docs/ko/commands)를 실행하고 `Organization` 행을 확인합니다.

> [!WARNING]
>
> 확장 프로그램에서 로그아웃하면 확장 프로그램에 저장된 바로 가기와 예약 작업이 사라집니다. 먼저 [일반적인 오류 메시지](#common-error-messages)의 다른 해결 방법을 시도합니다.

확장 프로그램의 조직을 변경하려면 확장 프로그램 설정에서 로그아웃한 후 다시 로그인하고 `/status`에 표시된 조직을 선택합니다.

### Windows 관련 문제

Windows에서 다음을 만날 수 있습니다.

* **명명된 파이프 충돌 (EADDRINUSE)**: 다른 프로세스가 동일한 명명된 파이프를 사용 중인 경우 Claude Code를 다시 시작합니다. Chrome을 사용 중일 수 있는 다른 Claude Code 세션을 모두 닫습니다.
* **네이티브 메시징 호스트 오류**: 시작 시 네이티브 메시징 호스트가 충돌하면 Claude Code를 다시 설치하여 호스트 구성을 다시 생성해 봅니다.
* **설정 페이지가 열리지 않음**: Claude Code를 업데이트합니다. v2.1.211 이전에는 Windows에서 확장 프로그램 연결을 요청하는 브라우저 탭이 열리지 않을 수 있었습니다.

### 일반적인 오류 메시지

가장 자주 발생하는 오류와 해결 방법은 다음과 같습니다.

| 오류 | 원인 | 해결 방법 |
| - | - | - |
| "Browser extension is not connected" | 확장 프로그램이 Chrome에 설치되어 실행 중이지 않거나, 확장 프로그램이 Claude Code와 다른 claude.ai 계정 또는 조직으로 로그인되어 있거나, 조직의 IP 허용 목록이 `bridge.claudeusercontent.com`에 대한 연결을 거부함 | 확장 프로그램이 Claude Code와 동일한 claude.ai 계정 및 [조직](#extension-signed-in-to-a-different-organization)으로 로그인되어 있는지 확인하고, Chrome과 Claude Code를 다시 시작한 후 `/chrome`을 실행하여 다시 연결합니다. 조직에서 IP 허용 목록을 사용하고 오류가 지속되면 [조직 IP 허용 목록 및 프록시 egress](https://code.claude.com/docs/ko/network-config.md#organization-ip-allowlists-and-proxy-egress)를 참조합니다. |
| `/chrome`에서 확장 프로그램이 "감지되지 않음"으로 표시됨 | Chrome 확장 프로그램이 설치되지 않았거나 비활성화됨 | `chrome://extensions`에서 확장 프로그램을 설치하거나 활성화합니다. |
| "사용 가능한 탭 없음" | Claude가 탭이 준비되기 전에 작동하려고 시도함 | Claude에게 새 탭을 만들고 다시 시도하도록 요청합니다. |
| "수신 끝이 존재하지 않음" | 확장 프로그램 서비스 워커가 유휴 상태가 됨 | `/chrome`을 실행하고 "확장 프로그램 다시 연결"을 선택합니다. |
| "No browsers are connected" | Claude Code와 동일한 claude.ai 계정 및 조직으로 로그인된 확장 프로그램이 있는 Chrome이 열려 있지 않거나, Claude Code가 `bridge.claudeusercontent.com`에 연결할 수 없음 | Chrome이 열려 있고 확장 프로그램이 Claude Code와 동일한 claude.ai 계정 및 [조직](#extension-signed-in-to-a-different-organization)으로 로그인되어 있는지 확인합니다. 그렇다면 [네트워크 액세스 요구 사항](https://code.claude.com/docs/ko/network-config.md#network-access-requirements)에 나열된 `bridge.claudeusercontent.com`에 Claude Code가 연결할 수 있도록 네트워크가 허용하는지 확인합니다. |

## 참고 항목

* [컴퓨터 사용](https://code.claude.com/docs/ko/computer-use.md): 브라우저에서 작업을 수행할 수 없을 때 네이티브 macOS 앱을 제어합니다
* [VS Code에서 Claude Code 사용](https://code.claude.com/docs/ko/vs-code.md#automate-browser-tasks-with-chrome): VS Code 확장 프로그램의 브라우저 자동화
* [CLI 참조](https://code.claude.com/docs/ko/cli-reference.md): `--chrome`을 포함한 명령줄 플래그
* [일반적인 워크플로우](https://code.claude.com/docs/ko/common-workflows.md): Claude Code를 사용하는 더 많은 방법
* [데이터 및 개인정보](https://code.claude.com/docs/ko/data-usage.md): Claude Code가 데이터를 처리하는 방법
* [Chrome에서 Claude 시작하기](https://support.claude.com/en/articles/12012173-getting-started-with-claude-in-chrome): 바로 가기, 일정 예약 및 권한을 포함한 Chrome 확장 프로그램의 전체 문서
