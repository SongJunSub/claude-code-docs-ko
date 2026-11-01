> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Desktop 애플리케이션

> Claude Code Desktop을 더 활용하기: Git 격리를 통한 병렬 세션, 드래그 앤 드롭 패널 레이아웃, 통합 터미널 및 파일 편집기, 사이드 채팅, 컴퓨터 사용, 휴대폰에서 Dispatch 세션 전송, 시각적 diff 검토, 앱 미리보기, PR 모니터링, 커넥터, 엔터프라이즈 구성.

Claude Desktop 앱에서 Claude Code는 **Code** 탭입니다. 앱에는 채팅과 함께, Dispatch 및 더 긴 에이전트 작업을 처리하는 [Cowork](https://claude.com/product/cowork)도 있습니다. 이 페이지는 Code 탭에 대한 참고 자료입니다.

> [card] [macOS용 다운로드](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code\&utm_medium=docs)
>
> Intel 및 Apple Silicon용 범용 빌드

> [card] [Windows용 다운로드](https://claude.ai/api/desktop/win32/x64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)
>
> x64 프로세서용

> [card] [Linux용 Claude 다운로드(베타)](https://code.claude.com/docs/ko/desktop-linux.md)
>
> Ubuntu 및 Debian용 apt 또는 .deb

Windows ARM64의 경우 [ARM64 설치 프로그램](https://claude.ai/api/desktop/win32/arm64/setup/latest/redirect?utm_source=claude_code\&utm_medium=docs)을 다운로드하십시오. Linux에서는 apt로 설치하십시오. [Linux의 Claude Desktop](https://code.claude.com/docs/ko/desktop-linux.md)을 참조하십시오.

설치 후 Claude를 실행하고, 로그인한 다음 **Code** 탭을 클릭합니다. 첫 번째 세션의 전체 안내는 [시작하기 가이드](https://code.claude.com/docs/ko/desktop-quickstart.md)를 참조하세요.

Code 탭에서 각 대화는 **세션**입니다: 자신의 채팅 기록과 프로젝트 폴더를 가지고 있으며, 다른 세션과는 독립적입니다. 사이드바에는 세션이 나열되어 있으며 여러 세션을 병렬로 실행할 수 있습니다. 세션 내에서 다음을 수행할 수 있습니다:

* [diff를 검토하고 댓글 달기](#review-changes-with-diff-view), 그 다음 [CI를 통해 결과 PR 모니터링](#monitor-pull-request-status)
* [실행 중인 앱 미리보기](#preview-your-app) (Browser 패널에서 Claude가 자신의 변경 사항을 확인하는 동안), 그리고 [외부 사이트 열기](#browse-external-sites)
* [iOS Simulator 패널에서 Claude가 iOS 앱을 실행하고 테스트하는 것을 보기](https://code.claude.com/docs/ko/desktop-ios-simulator.md)
* [패널 정렬](#arrange-your-workspace) (채팅, diff, 브라우저, 터미널, 파일 편집기를 나란히 배치)
* [세션을 벗어나지 않고 부가 질문 하기](#ask-a-side-question-without-derailing-the-session) (세션의 컨텍스트를 사용하되 벗어나지 않음)
* Claude가 [다른 세션을 확인하고, 메시지를 보내거나, 보관](#work-across-sessions)하도록 허용
* [외부 도구 연결](#connect-external-tools) (GitHub, Slack, Linear 등)
* Claude가 [앱을 열고 화면을 제어](#let-claude-use-your-computer)하도록 허용
* 머신에서, [클라우드](#run-long-running-tasks-in-the-cloud)에서, 또는 [SSH](#ssh-sessions)를 통해 실행

[예약된 반복 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md), [키보드 단축키](#keyboard-shortcuts), 또는 [휴대폰에서 작업 전송](#sessions-from-dispatch)에 대해서는 연결된 페이지 및 섹션을 참조하세요. 이미 터미널 기반 CLI를 사용 중이라면, [CLI 비교](#coming-from-the-cli)에서 어떤 것이 이월되는지 확인하세요.

## 세션 시작하기

첫 번째 메시지를 보내기 전에 프롬프트 상자 아래 행에서 환경, 프로젝트 폴더, 권한 모드, 모델을 선택합니다:

* **환경**: 행의 첫 번째 컨트롤인 환경 선택기를 사용하여 Claude가 실행되는 위치를 선택합니다. [환경 구성](#environment-configuration)을 참조하세요.
  * 새 세션의 프롬프트 상자 아래에 환경이 표시되지 않는다면 [이전 레이아웃의 단계](#check-which-layout-you-have)를 따르세요.
* **프로젝트 폴더**: 환경 선택기 옆에 있는 프로젝트 폴더 컨트롤을 클릭하여 Claude가 작업할 폴더를 선택합니다.
  * **클라우드 세션**: 폴더 대신 [저장소](#run-long-running-tasks-in-the-cloud)를 선택합니다
  * **[저장된 로컬 또는 SSH 환경](#create-a-saved-environment)**: 환경에 이미 폴더가 포함되어 있으므로 행에 프로젝트 폴더 컨트롤이 표시되지 않습니다. 폴더를 변경하려면 [환경을 편집](#use-edit-or-remove-a-saved-environment)합니다.
* **권한 모드**: [모드 선택기](#choose-a-permission-mode)를 사용하여 Claude가 가질 자율성을 선택합니다. 세션 중에 권한 모드를 변경할 수 있습니다.
* **모델**: 행의 오른쪽 끝 부분에 있는 모델 선택기에서 [모델](https://code.claude.com/docs/ko/model-config.md#available-models)을 선택합니다. 세션 중에 모델을 변경할 수 있습니다.

작업을 입력하고 **Enter**를 눌러 시작합니다. 각 세션은 자신의 컨텍스트와 변경 사항을 독립적으로 추적합니다.

## 코드 작업하기

Claude에게 올바른 컨텍스트를 제공하고, 자동으로 수행할 작업의 양을 제어하고, 변경 사항을 검토합니다.

### 프롬프트 상자 사용하기

Claude가 수행할 작업을 입력하고 **Enter**를 눌러 보냅니다. Claude는 프로젝트 파일을 읽고, 변경 사항을 만들고, [권한 모드](#choose-a-permission-mode)에 따라 명령을 실행합니다. 언제든지 Claude를 중단할 수 있습니다: 중지 버튼을 클릭하여 즉시 중단하거나, 수정 사항을 입력하고 **Enter**를 눌러 실행 중인 작업을 중지하지 않고 보냅니다. Claude는 현재 작업이 완료되면 수정 사항을 읽고 다음 단계 전에 조정합니다.

프롬프트 상자 옆의 **+** 버튼을 클릭하면 파일 첨부, [skills](#use-skills), [connectors](#connect-external-tools), [plugins](#install-plugins)에 액세스할 수 있습니다.

### 제안된 프롬프트 수락하기

Claude가 응답한 후 Code 탭은 빈 프롬프트 상자에 다음 프롬프트 제안을 회색 텍스트로 표시할 수 있습니다. Claude Code는 대화를 바탕으로 짧은 백그라운드 요청을 통해 [각 제안을 생성](https://code.claude.com/docs/ko/interactive-mode.md#prompt-suggestions)하며, 이 요청은 플랜의 사용 한도 또는 API 비용에 포함됩니다.

* **제안 사용하기**: **Tab** 또는 **Right arrow**를 눌러 제안을 프롬프트 상자에 넣고, 필요하면 편집한 다음 **Enter**를 눌러 보냅니다. 제안을 수락하기 전에 **Enter**를 누르면 제안이 전송되지 않습니다.
* **직접 프롬프트 작성하기**: 입력을 시작합니다. 제안은 프롬프트 상자가 비어 있고 첨부된 파일이 없을 때만 표시됩니다.

제안을 중지하려면 **Settings > Code** 또는 **Settings > Claude Code**에서 **Prompt suggestions**를 끕니다. 각 세션은 다음에 시작되거나 재개될 때부터 제안을 표시하지 않습니다.

### 프롬프트에 파일 및 컨텍스트 추가하기

Claude에게 파일을 제공하려면 프롬프트 상자에서 파일을 @mention하거나 첨부합니다:

* **@mention 파일**: `@` 다음에 파일 이름을 입력하여 파일을 대화 컨텍스트에 추가합니다.
  * **클라우드 세션에서**: `@`는 첫 번째 메시지를 보낸 후에만 파일을 나열할 수 있습니다. `@`가 아무 파일도 나열하지 않으면 파일 없이 첫 번째 메시지를 보낸 다음, 다음 메시지에서 파일을 @mention합니다.
* **파일 첨부**: 프롬프트 상자 옆의 **+** 버튼에서 이미지, PDF 및 기타 파일을 프롬프트에 첨부하거나, 파일을 프롬프트에 직접 드래그 앤 드롭합니다. 이는 버그 스크린샷, 디자인 목업 또는 참고 문서를 공유하는 데 유용합니다.
  * **[WSL 세션](https://code.claude.com/docs/ko/desktop-wsl.md)에서**: **+** 메뉴에 **Add files or photos** 대신 **Add image**가 표시되면 이미지만 첨부할 수 있습니다. 세션 폴더의 다른 파일을 Claude에게 제공하려면 해당 파일을 @mention합니다.

### 권한 모드 선택하기

권한 모드는 세션 중에 Claude가 가질 자율성을 제어합니다: 파일 편집, 명령 실행 또는 둘 다 전에 묻는지 여부입니다. 프롬프트 상자 아래 줄의 모드 선택기를 사용하여 언제든지 권한 모드를 전환할 수 있습니다. 각 변경 사항을 직접 승인하려면 Manual로 전환합니다.

새 로컬 세션의 기본 모드를 설정하려면 [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)에 `permissions.defaultMode`를 추가합니다. 데스크톱 앱은 CLI와 동일한 설정 파일을 읽습니다. 선택기에서 선택한 모드는 폴더별로 기억되며 해당 폴더의 `defaultMode`보다 우선하지만, Plan은 현재 세션에만 적용됩니다.

| 모드 | 설정 키 | 동작 |
| - | - | - |
| **Manual** | `default` | Claude는 파일을 편집하거나 명령을 실행하기 전에 요청합니다. diff를 보고 각 변경 사항을 수락하거나 거부할 수 있습니다. |
| **Accept edits** | `acceptEdits` | Claude는 파일 편집을 자동으로 수락하고 `mkdir`, `touch`, `mv`와 같은 일반적인 파일시스템 명령을 자동으로 수락하지만 다른 터미널 명령 실행 전에는 여전히 요청합니다. 파일 변경을 신뢰하고 더 빠른 반복을 원할 때 사용합니다. |
| **Plan** | `plan` | Claude는 파일을 읽고 명령을 실행하여 탐색한 다음 소스 코드를 편집하지 않고 계획을 제안합니다. 먼저 접근 방식을 검토하려는 복잡한 작업에 좋습니다. |
| **Auto** | `auto` | Claude는 일상적인 프롬프트 없이 실행됩니다. 셸 명령 및 네트워크 요청과 같은 작업이 실행되기 전에 백그라운드 분류기가 요청과의 정렬을 확인합니다. [자동 모드가 사용 가능](#auto-mode-availability)할 때 나타나며, 별도의 Settings 토글이 없습니다. |
| **Bypass permissions** | `bypassPermissions` | Claude는 [어떤 모드도 자동으로 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves), Claude가 [외부 사이트에서 작동](#browse-external-sites)할 때의 안전 분류기, 또는 세션 삭제와 같은 데스크톱 작업(단, [세션 아카이브](#work-across-sessions)는 해당되지 않음)을 제외하고 권한 프롬프트 없이 실행됩니다. CLI의 `--dangerously-skip-permissions`와 동일합니다. Pro, Max, Ultra 플랜에서는 **Settings > Code** 또는 **Settings > Claude Code**에서 "Allow bypass permissions mode"를 활성화합니다. Team 및 Enterprise 플랜에서는 Settings 토글이 없으며 조직 정책이 대신 제어합니다. 샌드박스 컨테이너 또는 VM에서만 사용합니다. |

이전 버전의 Code 탭은 이러한 모드를 Ask permissions, Auto accept edits, Plan mode로 표시했습니다.

`dontAsk` 권한 모드는 [CLI](https://code.claude.com/docs/ko/permission-modes.md#allow-only-pre-approved-tools-with-dontask-mode)에서만 사용 가능합니다.

> [!TIP]
>
> 복잡한 작업을 Plan에서 시작하여 Claude가 변경하기 전에 접근 방식을 매핑하도록 합니다. 계획을 승인한 후 Accept edits 또는 Manual로 전환하여 실행합니다. 이 워크플로에 대한 자세한 내용은 [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)를 참조하세요.

클라우드 세션은 Accept edits, Plan, Auto를 지원합니다. Accept edits는 `default` 모드에 해당합니다: 클라우드 세션은 파일 편집을 미리 승인하므로 선택기는 Manual 대신 Accept edits를 표시합니다. Bypass permissions는 클라우드 세션에서 사용할 수 없으며, [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)의 세션을 포함합니다.

엔터프라이즈 관리자는 사용 가능한 권한 모드를 제한할 수 있습니다. 자세한 내용은 [엔터프라이즈 구성](#enterprise-configuration)을 참조하세요.

#### 자동 모드 사용 가능 여부

자동 모드는 Anthropic API의 모든 사용자에게 제공되며 Claude Opus 4.6 이상, Sonnet 4.6 이상, Haiku 5.5, 또는 [Fable 모델](https://code.claude.com/docs/ko/model-config.md#work-with-fable)이 필요합니다. 조직 관리자는 [관리형 설정](#managed-settings)에서 `disableAutoMode` 키를 사용하여 자동 모드를 끌 수 있습니다.

Desktop을 Google Cloud의 Agent Platform으로 라우팅하는 Enterprise 배포에서도 자동 모드는 기본적으로 사용 가능합니다. 지원되는 모델은 [Bedrock, Agent Platform, 또는 Foundry에서 자동 모드 활성화](https://code.claude.com/docs/ko/permission-modes.md#enable-auto-mode-on-bedrock-agent-platform-or-foundry)를 참조하세요.

### 앱 미리보기

Claude는 개발 서버를 시작하고 Browser 패널에서 열어 변경 사항을 확인할 수 있습니다. 이는 프론트엔드 웹 앱뿐만 아니라 백엔드 서버에도 작동합니다: Claude는 API 엔드포인트를 테스트하고, 서버 로그를 보고, 발견한 문제를 반복할 수 있습니다. 대부분의 경우 Claude는 프로젝트 파일을 편집한 후 자동으로 서버를 시작합니다. 언제든지 Claude에게 미리보기를 요청할 수도 있습니다. 기본적으로 Claude는 모든 편집 후 [자동으로 변경 사항을 확인](#auto-verify-changes)합니다.

로컬 세션에서는 채팅에서 HTML, PDF 또는 비디오 경로를 클릭하여 Browser 패널에서 엽니다.

> [!NOTE]
>
> [SSH 세션](#ssh-sessions)에서는 Claude가 Browser 패널의 도구를 사용할 수 없으므로 Browser 패널에서 앱을 열 수 없습니다. 앱을 직접 확인하려면 [앱의 포트를 컴퓨터로 포워딩](#reach-a-port-on-the-remote-machine)합니다.

로컬 세션에서 Claude가 서버를 시작한 후 Browser 패널이 열려 있지 않으면 채팅에서 서버 카드의 **Open**을 클릭합니다.

Browser 패널에서 다음을 수행할 수 있습니다:

* Browser 패널에서 실행 중인 앱과 직접 상호작용합니다
* Claude가 자동으로 자신의 변경 사항을 확인하는 것을 봅니다: 스크린샷을 찍고, DOM을 검사하고, 요소를 클릭하고, 양식을 채우고, 발견한 문제를 수정합니다
* Browser 패널 헤더의 **Dev servers** 메뉴에서 서버를 시작하거나 중지하거나, 모든 서버를 한 번에 중지합니다
* Browser 패널의 **⋮** 메뉴에 있는 **Keep cookies**로 앱을 종료한 후에도 Browser가 쿠키를 유지할지 선택하여 개발 중에 다시 로그인할 필요가 없도록 합니다

Claude는 프로젝트를 기반으로 초기 서버 구성을 만듭니다. 앱이 사용자 정의 개발 명령을 사용하는 경우 `.claude/launch.json`을 편집하여 설정과 일치시킵니다. 전체 참조는 [미리보기 서버 구성](#configure-preview-servers)을 참조하세요.

Browser에 저장된 데이터를 지우려면 Browser 패널의 **⋮** 메뉴에서 **Clear browsing data**를 선택합니다. Browser를 완전히 끄려면 **Settings > Code** 또는 **Settings > Claude Code**에서 **Browser tools**를 끕니다.

### 외부 사이트 탐색하기

Browser 패널은 탭 브라우저이므로 실행 중인 앱 옆에 문서, 이슈 추적기 또는 다른 사이트를 열 수 있습니다. Browser를 열려면 macOS에서 **Cmd+Shift+B**를 누르거나 Windows에서 **Ctrl+Shift+B**를 누르거나, 세션 제목 표시줄에서 **Browser**를 클릭합니다. Google OAuth와 같은 팝업 로그인 흐름을 포함하여 패널의 사이트에 로그인할 수 있습니다.

채팅에서 외부 링크를 처음 클릭하면 링크를 Browser 패널에서 열지 기본 브라우저에서 열지 묻는 대화 상자가 나타납니다. 나중에 선택을 변경하려면 Browser 패널의 **⋮** 메뉴에서 **Open links in built-in browser**를 사용합니다. macOS에서 **Cmd**-클릭하거나 Windows에서 **Ctrl**-클릭하면 기본 브라우저에서 링크를 직접 엽니다.

Claude는 [앱을 확인](#preview-your-app)하는 데 사용하는 동일한 도구를 사용하여 외부 페이지를 읽고 상호작용할 수 있으며, 두 가지 추가 안전 검사가 있습니다:

* 안전 분류기는 모든 권한 모드에서 클릭 및 입력과 같은 외부 페이지에 대한 Claude의 쓰기 작업을 검토합니다. 이는 [자동 모드](#choose-a-permission-mode)가 사용하는 동일한 분류기이며, 작업에 플래그를 지정하면 모드에 관계없이 권한 프롬프트를 받습니다.
* Auto 및 Bypass permissions 이외의 권한 모드에서는 Claude가 새 사이트로 이동하기 전에 도메인 허용 목록 확인도 적용됩니다.

#### 사이트에서 Claude의 작업 승인하기

Claude가 처음으로 외부 사이트에서 작동할 때 권한 카드가 나타나고 Claude는 선택을 기다립니다: **Allow once**, **Always allow**, 또는 **Deny**. **Allow once**는 아무것도 저장하지 않고 작업을 승인합니다. **Always allow**는 장치에 해당 사이트에 대한 승인을 저장하며, Settings에서 취소할 수 있습니다. 하위 도메인을 포함하여 각 사이트는 자체 승인이 필요합니다. 로컬 개발 서버 및 프로젝트 파일은 승인이 필요하지 않으므로 [auto-verify](#auto-verify-changes)는 프롬프트 없이 계속 작동합니다.

승인된 사이트에서도 Claude는 입력 없이 항목을 구매하거나, 계정을 만들거나, CAPTCHA를 우회하지 않습니다. Browser 패널에서 탐색하면 [Claude in Chrome extension](https://code.claude.com/docs/ko/chrome.md)과 동일한 안전 모델을 사용합니다. Claude가 민감한 사이트 및 위험한 작업을 처리하는 방법은 [Using Claude in Chrome safely](https://support.claude.com/en/articles/12902428-using-claude-in-chrome-safely)를 참조하세요.

#### Browser와 Chrome 확장 프로그램 중 선택하기

Browser 패널은 개인 브라우저와 별도의 깨끗한 브라우저 프로필을 사용하며 저장된 로그인이나 기록이 없습니다. 앱을 빌드 및 테스트하고 신원이 필요하지 않은 사이트에 사용합니다. Claude가 로그인한 세션에서 사용자로 작동하기를 원할 때는 대신 [Claude in Chrome extension](https://code.claude.com/docs/ko/chrome.md)을 사용하세요. 이는 브라우저의 로그인 상태를 공유합니다.

#### 조직의 외부 탐색 제한하기

Browser는 Claude in Chrome 확장 프로그램과 동일한 [site allowlist and blocklist controls](https://support.claude.com/en/articles/13065128-claude-in-chrome-admin-controls)를 따릅니다. 조직이 이미 확장 프로그램에 대해 해당 목록을 구성한 경우 Browser는 자동으로 이를 준수합니다. 관리자는 [`browserExternalPageTools` 관리형 설정](#managed-settings)으로 외부 페이지에서 Claude의 도구를 끌 수도 있습니다. 도구가 비활성화되면 사용자는 여전히 외부 사이트로 이동할 수 있습니다; Claude의 도구는 이를 읽거나 작동할 수 없습니다.

외부 탐색을 완전히 끄려면 [`disableBrowserExternalNavigation` 관리형 설정](#managed-settings)을 `true`로 설정합니다. 이는 조직의 허용 목록에 있는 사이트를 포함하여 Browser의 모든 외부 탐색을 차단합니다; localhost 개발 서버 및 파일 미리보기는 계속 작동합니다. `browserExternalPageTools`를 사용하여 사용자가 Claude의 도구 없이 외부 사이트를 계속 탐색하도록 하고, `disableBrowserExternalNavigation`을 사용하여 사용자와 Claude 모두에 대해 외부 사이트를 차단합니다.

### diff 보기로 변경 사항 검토하기

Claude가 코드를 변경한 후 diff 보기를 사용하면 풀 리퀘스트를 만들기 전에 파일별로 수정 사항을 검토할 수 있습니다. diff 보기를 열려면 [세션 세부 정보 패널](#see-session-details)의 **Changes** 카드에서 `+12 -1`과 같은 줄 수를 클릭합니다. 세션 제목 표시줄에서 **Changes**를 클릭할 수도 있습니다. 클라우드 세션의 기본 브랜치 대비 diff에는 [아직 푸시되지 않은 변경 사항이 빠져 있을 수 있습니다](https://code.claude.com/docs/ko/claude-code-on-the-web.md#troubleshoot-a-missing-file-in-the-diff-view).

특정 줄에 댓글을 달려면 줄 위에 마우스를 올리고 줄 번호 옆에 나타나는 \*\*+\*\*를 클릭하여 댓글 상자를 엽니다. 피드백을 입력하고 **Enter**를 눌러 댓글을 추가합니다. 여러 줄에 댓글을 추가한 후 모든 댓글을 한 번에 제출합니다:

* **macOS**: **Cmd+Enter** 누르기
* **Windows**: **Ctrl+Enter** 누르기

Claude는 댓글을 읽고 요청된 변경 사항을 만들며, 이는 검토할 수 있는 새로운 diff로 나타납니다.

### 코드 리뷰하기

커밋하기 전에 Claude가 변경 사항을 리뷰하도록 하려면 [프롬프트 상자](#use-the-prompt-box)에 `/code-review`를 입력합니다. 리뷰가 완료되면 결과가 대화에 표시됩니다.

로컬, [SSH](#ssh-sessions), [WSL](https://code.claude.com/docs/ko/desktop-wsl.md) 세션에서는 결과가 파일별로 그룹화된 **Code review** 카드로 나타납니다. 카드를 사용하여 결과에 대응합니다:

* **Walk through in diff**를 클릭하면 diff 보기가 열리고 결과를 하나씩 살펴볼 수 있습니다. 현재 diff에 있는 결과는 해당 줄에 표시되며, 여기서 **Fix this one**을 클릭하거나 결과를 닫을 수 있습니다.
* **Apply fixes**를 클릭하면 아직 열려 있는 결과를 수정하도록 Claude에게 요청합니다.

어떤 세션에서든 프롬프트 상자에서 리뷰 결과를 수정하도록 Claude에게 요청할 수도 있습니다. `/code-review`가 확인하는 항목과 사용하는 인수는 [`/code-review`로 로컬에서 리뷰하기](https://code.claude.com/docs/ko/code-review-local)를 참조하세요.

### 풀 리퀘스트 상태 모니터링하기

Claude가 실패한 확인을 수정하도록 하거나 GitHub가 풀 리퀘스트를 병합하도록 하려면 **Auto-fix** 또는 **Merge when ready**를 켭니다. 풀 리퀘스트를 열면 [세션 세부 정보 패널](#see-session-details)의 **Changes** 카드에 CI 확인 상태와 함께 표시됩니다. 제목 옆의 **⋮** 메뉴를 엽니다:

* **Auto-fix**: 로컬 세션에서는 사용자 이외의 사람이 남긴 새 리뷰 댓글에도 Claude가 대응합니다. 댓글 작성자는 저장소 소유자, 조직 구성원, 협업자 또는 GitHub App이어야 합니다.
* **Merge when ready**: PR에 대해 GitHub의 auto-merge를 켭니다. 로컬 세션에서는 기본 브랜치가 병합 큐를 사용하지 않는 한 Desktop이 squash 병합을 요청합니다.
  * **SSH 및 WSL 세션에서**: **Merge when ready**가 비활성화되어 있으므로 GitHub에서 풀 리퀘스트의 auto-merge를 켭니다
  * **저장소가 auto-merge를 허용하지 않는 경우**: **Merge when ready**가 켜지지 않으므로 먼저 [GitHub 저장소 설정](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository)에서 auto-merge를 활성화합니다
* **[이전 레이아웃](#check-which-layout-you-have)**: 세션에 풀 리퀘스트가 생기면 상태 표시줄에서 **CI**를 클릭합니다.

PR이 병합되거나 닫히면 세션을 자동으로 아카이브하려면 **Settings > Code** 또는 **Settings > Claude Code**에서 [auto-archive](#archive-a-session)를 켭니다.

> [!NOTE]
>
> PR 모니터링에는 [GitHub CLI (`gh`)](https://cli.github.com/)가 머신에 설치되고 인증되어야 합니다. `gh`가 설치되지 않은 경우 Desktop은 처음으로 PR을 만들려고 할 때 설치하도록 요청합니다.
>
> [SSH 세션](#ssh-sessions)에서는 Claude가 원격 머신에서 브랜치를 푸시하고 `gh pr create`를 실행하므로, **Create PR**을 클릭하기 전에 원격 머신에 `git`과 `gh`를 설정합니다. SSH 세션에서는 Desktop이 설치를 요청하지 않으므로 원격 머신에 `gh`를 직접 설치합니다. 그런 다음 원격 머신에서 `git push`가 작동하는지, 그리고 `gh auth status`가 로그인된 상태로 보고하는지 확인합니다.

## 워크스페이스 정렬하기

Code 탭은 모든 레이아웃으로 정렬할 수 있는 패널을 중심으로 구축되어 있습니다: 채팅, diff, 브라우저, 터미널, 파일, 계획, 작업, 서브에이전트, 그리고 macOS의 [iOS Simulator](https://code.claude.com/docs/ko/desktop-ios-simulator.md). 패널을 헤더로 드래그하여 위치를 변경하거나 패널 가장자리를 드래그하여 크기를 조정합니다. macOS에서 \*\*Cmd+\\\*\*를 누르거나 Windows에서 \*\*Ctrl+\\\*\*를 눌러 포커스된 패널을 닫습니다.

다른 패널을 열려면 세션 제목 표시줄에서 해당 아이콘 버튼을 클릭합니다. 마우스를 올리면 **Terminal**, diff 보기용 **Changes**, **Browser**, **Files**와 같은 각 버튼의 이름을 볼 수 있습니다. 원하는 패널의 버튼이 제목 표시줄에 없으면 버튼 옆의 **⋮** 메뉴에서 선택합니다:

* **창이 좁을 때**: 표시할 공간이 없는 버튼은 메뉴로 이동합니다
* **버튼이 없는 패널의 경우**: **Background tasks** 및 **Plan**과 같은 패널은 세션에 해당 패널에 표시할 내용이 생기면 메뉴에 나열됩니다

화면 전체에서 작업하려면 diff 또는 터미널과 같은 패널을 자신의 창으로 팝업하고 완료되면 다시 도킹합니다. Claude는 주 창에서 계속 작동합니다.

> [!NOTE]
>
> 이 섹션의 패널 레이아웃, 터미널, 파일 편집기, 보기 모드는 Claude Desktop v1.2581.0 이상이 필요합니다. macOS에서 \*\*Claude > Check for Updates…\*\*를 열거나 Windows에서 \*\*Help > Check for Updates…\*\*를 열어 업데이트합니다.

### 세션 세부 정보 보기

세션 세부 정보 패널은 채팅 옆에 표시되는 카드 모음으로, 세션이 실행되는 위치, 세션이 변경한 내용, 현재 실행 중인 항목, 컨텍스트 사용량을 보여줍니다. 이 패널은 세션을 시작한 후 채팅 영역이 충분히 넓을 때 나타납니다.

#### 세션 세부 정보 패널 숨기기 또는 표시하기

패널을 숨기거나 표시하려면 세션 제목 표시줄 또는 표시줄의 **⋮** 메뉴에서 **Hide session rail** 또는 **Show session rail**을 클릭합니다. 그래도 패널이 보이지 않으면 [사용 중인 Code 탭 레이아웃을 확인합니다](#check-which-layout-you-have).

### 터미널에서 명령 실행하기

통합 터미널을 사용하면 다른 앱으로 전환하지 않고 세션과 함께 명령을 실행할 수 있습니다. 세션 제목 표시줄에서 **Terminal**을 클릭하거나 macOS 또는 Windows에서 \*\*Ctrl+\`\*\*를 누릅니다. 터미널은 세션의 작업 디렉터리에서 열리고 Claude와 동일한 환경을 공유하므로 `npm test` 또는 `git status`와 같은 명령은 Claude가 편집하는 것과 동일한 파일을 봅니다. 두 번째 터미널 탭을 열려면 터미널 패널 헤더의 \*\*+\*\*를 클릭하거나 채팅의 폴더를 마우스 오른쪽 버튼으로 클릭하여 **Open in terminal**을 선택합니다.

WSL 세션에 터미널이 없으면 [터미널 또는 커넥터를 사용할 수 없는 경우](https://code.claude.com/docs/ko/desktop-wsl.md#check-for-the-terminal-and-connectors)를 참조하세요. 터미널은 로컬 및 [SSH](#ssh-sessions) 세션에서 사용 가능하며, [Windows 원격 머신](#windows-remote-machines)에서는 제한이 있습니다.

### 파일 열기 및 편집하기

Claude가 언급한 파일을 열려면 채팅에서 해당 경로를 클릭합니다.

파일을 직접 편집하려면 [파일 패널](#arrange-your-workspace)을 사용합니다:

* **로컬 세션**: 세션의 작업 디렉터리 안에 있는 파일을 편집할 수 있지만, `.mcp.json` 및 `.claude/settings.json`과 같은 일부 보기 전용 파일은 예외입니다. 이러한 파일을 변경하려면 [다른 앱에서 엽니다](#open-files-in-other-apps).
* **클라우드, SSH, WSL 세션**: 파일 패널은 보기 전용이므로 Claude에게 편집을 요청합니다.

#### 파일 패널에서 편집 내용 저장하기

기본적으로 파일 패널의 편집 내용은 자동으로 저장되므로 패널에 **Save** 버튼이 표시되지 않습니다. 편집 내용을 직접 저장하려면 패널의 **⋮** 메뉴에서 **Auto save**를 선택 해제합니다. **Auto save**가 꺼져 있으면 파일을 변경한 후 **Save**를 클릭하여 편집 내용을 기록하거나 **Cancel**을 클릭하여 되돌립니다.

파일이 디스크에서 변경되었다는 경고가 패널에 표시되면 **Override**를 클릭하여 디스크의 버전을 편집 내용으로 덮어쓰거나 **Discard**를 클릭하여 편집 내용을 버립니다.

### 다른 앱에서 파일 열기

채팅, diff 뷰어 또는 파일 패널의 모든 파일 경로를 마우스 오른쪽 버튼으로 클릭하여 컨텍스트 메뉴를 엽니다:

* **Attach as context**: 파일을 다음 프롬프트에 추가
* **Open in**: VS Code, Cursor, Zed와 같은 설치된 편집기에서 파일 열기
* **Show in Finder** (macOS), **Show in Explorer** (Windows): 포함된 폴더 열기
* **Copy**: 파일의 **Absolute path**, **Relative path** 또는 **Filename**을 복사하는 하위 메뉴

### 보기 모드 전환하기

보기 모드는 채팅 트랜스크립트에 나타나는 세부 정보의 양을 제어합니다. 보기 모드를 전환하려면 세션 제목 옆의 캐럿에서 세션 메뉴를 열고 **Transcript view**를 선택하거나, macOS 또는 Windows에서 **Ctrl+O**를 눌러 모드를 순환합니다. Thinking 모드는 보고 있는 세션에서 Claude가 사고를 생성한 후에만 메뉴에 나타납니다.

| 모드 | 표시되는 것 |
| - | - |
| **Normal** | 도구 호출이 요약으로 축소되고 전체 텍스트 응답 |
| **Thinking** | 도구 호출이 요약으로 축소되고 Claude의 thinking |
| **Verbose** | 모든 도구 호출, 파일 읽기, Claude가 수행하는 중간 단계, 그리고 Claude의 thinking |

Thinking을 사용하여 도구 호출이 여전히 축소된 상태에서 Claude의 추론을 따릅니다. Claude가 특정 작업을 수행한 이유를 디버깅할 때 Verbose를 사용합니다. Claude Desktop 1.46388.1 이전 버전은 Summary 모드도 나열하며, Summary로 설정된 세션은 업데이트 후 Normal로 열립니다.

### 키보드 단축키

macOS에서 \*\*Cmd+/\*\*를 누르거나 Windows에서 \*\*Ctrl+/\*\*를 눌러 Code 탭에서 사용 가능한 모든 단축키를 봅니다. 이 섹션의 표는 macOS 키를 보여줍니다. Windows 및 Linux에서는 다음 키를 바꿔 사용합니다:

* **Cmd+Option**: **Alt**를 누릅니다
* **Cmd+Ctrl**: **Ctrl+Alt**를 누릅니다
* **Cmd**: **Ctrl**을 누릅니다

`Ctrl`로 시작하는 단축키는 모든 플랫폼에서 동일합니다.

| 단축키 | 작업 |
| - | - |
| `Cmd` `/` | 키보드 단축키 표시 |
| `Cmd` `N` | 새 세션 |
| `Cmd` `Option` `1`–`9` | [현재 레이아웃](#check-which-layout-you-have)의 새 세션 화면에서 환경 선택 |
| `Cmd` `Option` `0` | 현재 레이아웃의 새 세션 화면에서 [**New environment** 대화 상자](#create-a-saved-environment) 열기 |
| `Cmd` `W` | 세션 닫기 |
| `Ctrl` `Tab` / `Ctrl` `Shift` `Tab` | 세션 간 전환 |
| `Cmd` `Shift` `]` / `Cmd` `Shift` `[` | 다음 또는 이전 세션 |
| `Esc` | Claude의 응답 중지 |
| `Tab` / `Right arrow` | 빈 프롬프트 상자에서 [제안된 프롬프트 수락](#accept-a-suggested-prompt) |
| `Cmd` `Shift` `D` | diff 패널 토글 |
| `Cmd` `Shift` `B` | 브라우저 패널 토글 |
| `Cmd` `Shift` `S` | 브라우저에서 요소 선택 |
| `Ctrl` `` ` `` | 터미널 패널 토글 |
| `Cmd` `\` | 포커스된 패널 닫기 |
| `Cmd` `Ctrl` `W` | 포커스된 세션을 [분할 보기](#work-in-parallel-with-sessions)에서 빼기 |
| `Cmd` `;` | 사이드 채팅 열기 |
| `Ctrl` `O` | 보기 모드 순환 |
| `Cmd` `Shift` `M` | 권한 모드 메뉴 열기 |
| `Cmd` `Shift` `I` | 모델 메뉴 열기 |
| `Cmd` `Shift` `E` | 노력 메뉴 열기 |
| `1`–`9` | 열린 메뉴에서 항목 선택 |

이러한 단축키는 Code 탭에 적용됩니다. Desktop에서는 터미널의 [대화형 모드](https://code.claude.com/docs/ko/interactive-mode.md#keyboard-shortcuts)와 달리 `Shift+Tab`으로 권한 모드를 순환하지 않습니다.

### 사용량 확인하기

이 세션의 컨텍스트 윈도우가 얼마나 찼는지 확인하려면 사용 중인 Code 탭 레이아웃을 찾습니다:

* **현재 레이아웃**: [세션 세부 정보 패널](#see-session-details)의 **Context** 카드 헤더에 백분율로 표시됩니다. 카드를 열면 무엇이 윈도우를 사용하고 있는지 범주별로 볼 수 있습니다.
* **[이전 레이아웃](#check-which-layout-you-have)**: 모델 선택기 옆의 사용량 링을 클릭합니다. 팝오버에 컨텍스트 윈도우 사용량이 표시됩니다.

어느 레이아웃에서든 프롬프트 상자에 `/context`를 입력하면 이 세션의 컨텍스트 윈도우에 대한 범주별 분석이 채팅에 출력됩니다.

두 레이아웃 모두 모델 선택기 옆에 사용량 링이 있습니다. 이를 클릭하면 계획 사용량을 볼 수 있으며, 계획 사용량은 모든 Claude Code 사용 환경에서 공유됩니다.

## Claude가 컴퓨터를 사용하도록 하기

컴퓨터 사용을 통해 Claude는 앱을 열고, 화면을 제어하고, 사용자가 하는 방식으로 머신에서 직접 작업할 수 있습니다. Claude에게 CLI가 없는 데스크톱 도구와 상호작용하거나, GUI를 통해서만 작동하는 것을 자동화하도록 요청합니다. iOS 앱을 실행하고 테스트하기 위해 Desktop은 화면을 제어하는 대신 전용 [iOS Simulator 창](https://code.claude.com/docs/ko/desktop-ios-simulator.md)을 엽니다. 이 창은 컴퓨터 사용을 활성화하지 않고도 작동합니다.

> [!NOTE]
>
> 컴퓨터 사용은 Pro, Max 또는 Ultra 계획이 필요한 macOS 및 Windows의 리서치 프리뷰입니다. Team 또는 Enterprise 계획에서는 사용할 수 없습니다. Claude Desktop 앱이 실행 중이어야 합니다. macOS에서 컴퓨터 사용을 하려면 macOS 14 이상이 필요합니다.

컴퓨터 사용은 기본적으로 꺼져 있습니다. Claude가 화면을 제어할 수 있도록 [Settings에서 활성화](#enable-computer-use)합니다. macOS에서는 Accessibility 및 Screen Recording 권한도 부여해야 합니다.

macOS에서는 컴퓨터 사용이 백그라운드에서도 실행될 수 있습니다. Claude는 사용자가 계속 작업하는 동안 승인한 앱에서 작동합니다.

> [!WARNING]
>
> [샌드박스 Bash 도구](https://code.claude.com/docs/ko/sandboxing.md)와 달리 컴퓨터 사용은 승인한 모든 것에 액세스할 수 있는 실제 데스크톱에서 실행됩니다. Claude는 각 작업을 확인하고 화면 콘텐츠에서 잠재적 프롬프트 주입을 플래그하지만 신뢰 경계가 다릅니다. 모범 사례는 [컴퓨터 사용 안전 가이드](https://support.claude.com/en/articles/14128542)를 참조합니다.

### 컴퓨터 사용이 적용되는 경우

Claude는 앱 또는 서비스와 상호작용하는 여러 방법을 가지고 있으며 컴퓨터 사용이 가장 광범위하고 느립니다. 가장 정확한 도구를 먼저 시도합니다:

* 서비스에 대한 [커넥터](#connect-external-tools)가 있으면 Claude는 커넥터를 사용합니다.
* 작업이 셸 명령이면 Claude는 Bash를 사용합니다.
* 작업이 브라우저 작업이고 [Claude in Chrome](https://code.claude.com/docs/ko/chrome.md)이 설정되어 있으면 Claude는 그것을 사용합니다.
* 작업이 iOS 앱을 실행하거나 테스트하는 것이면 Claude는 [iOS Simulator 창](https://code.claude.com/docs/ko/desktop-ios-simulator.md)을 사용하며, 이는 화면 제어를 사용하지 않습니다.
* 위의 어느 것도 적용되지 않으면 Claude는 컴퓨터 사용을 사용합니다.

[앱별 액세스 계층](#app-permissions)은 이를 강화합니다: 브라우저는 보기 전용으로 제한되고, 터미널 및 IDE는 클릭 전용으로 제한되어 컴퓨터 사용이 활성화되어 있어도 Claude를 전용 도구로 유도합니다. 화면 제어는 네이티브 앱, 하드웨어 제어판, 또는 API가 없는 독점 도구와 같이 다른 것이 도달할 수 없는 것을 위해 예약되어 있습니다.

### 컴퓨터 사용 활성화하기

컴퓨터 사용은 기본적으로 꺼져 있습니다. Claude가 필요한 작업을 하도록 요청하는데 꺼져 있으면 Claude는 Settings에서 컴퓨터 사용을 활성화하면 작업을 수행할 수 있다고 알려줍니다.

**1. 데스크톱 앱 업데이트**

최신 버전의 Claude Desktop이 있는지 확인합니다. macOS 및 Windows에서는 [claude.com/download](https://claude.com/download)에서 다운로드하거나 업데이트하고, Linux에서는 패키지 관리자를 통해 업데이트합니다([지침](https://code.claude.com/docs/ko/desktop-linux.md)). 그런 다음 앱을 다시 시작합니다.

**2. 토글 켜기**

데스크톱 앱에서 **Settings**를 연 다음:

* **Settings 메뉴에 This computer가 표시되는 경우**: **This computer > System**으로 이동합니다
* **그렇지 않은 경우**: **Capabilities**로 이동합니다

**Computer use** 아래에서 **Enable computer use**를 켭니다:

* **Windows**: 토글이 즉시 적용되고 설정이 완료됩니다
* **macOS**: 다음 단계로 계속합니다

토글이 보이지 않으면 macOS 또는 Windows에서 Pro, Max 또는 Ultra 계획을 사용하고 있는지 확인한 다음 업데이트하고 앱을 다시 시작합니다.

**3. macOS 권한 부여**

macOS에서는 토글이 적용되기 전에 두 가지 시스템 권한을 부여합니다:

* **Accessibility**: Claude가 클릭, 입력, 스크롤할 수 있게 합니다
* **Screen Recording**: Claude가 화면에 있는 것을 볼 수 있게 합니다

Settings 페이지는 각 권한의 현재 상태를 표시합니다. 둘 중 하나가 거부되면 배지를 클릭하여 관련 System Settings 창을 엽니다.

### 앱 권한

Claude가 처음 앱을 사용해야 할 때 세션에 프롬프트가 나타납니다. **Allow for this session** 또는 **Deny**를 클릭합니다. 승인은 현재 세션 또는 [Dispatch 생성 세션](#sessions-from-dispatch)에서 30분 동안 지속됩니다.

프롬프트는 또한 Claude가 해당 앱에 대해 얻는 제어 수준을 표시합니다. 이러한 계층은 앱 카테고리별로 고정되며 변경할 수 없습니다:

| 계층 | Claude가 할 수 있는 것 | 적용 대상 |
| :- | :- | :- |
| 보기 전용 | 스크린샷에서 앱 보기 | 브라우저, 거래 플랫폼 |
| 클릭 전용 | 클릭 및 스크롤하지만 입력 또는 키보드 단축키 사용 불가 | 터미널, IDE |
| 전체 제어 | 클릭, 입력, 드래그, 키보드 단축키 사용 | 기타 모든 것 |

Terminal, Finder 또는 File Explorer, System Settings 또는 Settings와 같이 광범위한 영향을 미치는 앱은 승인이 부여하는 것을 알 수 있도록 프롬프트에 추가 경고를 표시합니다.

Settings에서 [컴퓨터 사용을 켠](#enable-computer-use) **Computer use** 섹션에는 다음 옵션이 포함되어 있습니다:

* **Denied apps**: 프롬프트 없이 거부하려면 여기에 앱을 추가합니다. Claude는 허용된 앱의 작업을 통해 거부된 앱에 간접적으로 영향을 미칠 수 있지만 거부된 앱과 직접 상호작용할 수 없습니다.
* **Unhide apps when Claude finishes**: 컴퓨터 사용이 백그라운드에서 실행되지 않을 때 Claude가 작업하는 동안 다른 창이 숨겨져 승인된 앱하고만 상호작용합니다. Claude가 완료되면 이 설정을 끄지 않는 한 숨겨진 창이 복원됩니다.

## 세션 관리

각 세션은 자체 컨텍스트와 변경 사항을 가진 독립적인 대화입니다. 여러 세션을 병렬로 실행하고, 사이드 채팅으로 분기하고, Claude가 다른 세션을 확인하고 메시지를 보내게 하고, 작업을 클라우드로 보내거나, Dispatch가 휴대폰에서 세션을 시작하도록 할 수 있습니다.

### 세션으로 병렬 작업하기

사이드바에서 **+ New**를 클릭하거나 macOS에서는 **Cmd+N**, Windows에서는 **Ctrl+N**을 눌러 여러 작업을 병렬로 진행할 수 있습니다. **Ctrl+Tab**과 **Ctrl+Shift+Tab**을 누르면 세션 간에 전환할 수 있습니다.

두 번째 세션을 현재 세션 옆이나 별도 창에서 열 수도 있습니다.

* **나란히 보기**: macOS에서는 **Option**, Windows에서는 **Alt**를 누른 채 사이드바의 세션을 클릭하거나, 세션을 마우스 오른쪽 버튼으로 클릭하고 **Open in**을 선택한 다음 **Split view**를 선택합니다
* **별도 창에서 보기**: macOS에서는 **Cmd**, Windows에서는 **Ctrl**을 누른 채 세션을 클릭하거나, 세션을 마우스 오른쪽 버튼으로 클릭하고 **Open in**을 선택한 다음 **New window**를 선택합니다

분할 보기에서는 마지막으로 열었거나 클릭한 창에 포커스가 있고, 다른 창은 흐리게 표시됩니다. 창에 표시되는 세션을 변경하려면 해당 창을 클릭하여 포커스를 준 다음 사이드바에서 세션을 클릭합니다. 포커스된 세션을 분할 보기에서 빼려면 macOS에서는 **Cmd+Ctrl+W**, Windows에서는 **Ctrl+Alt+W**를 누릅니다.

#### 별도 worktree에서 세션 실행하기

Git 저장소인 프로젝트에서는 세션을 시작하기 전에 **Worktree**를 켜서 프로젝트의 격리된 사본인 별도의 [Git worktree](https://code.claude.com/docs/ko/worktrees.md)에서 세션을 실행할 수 있습니다. 기본적으로 **Worktree**는 꺼져 있으며 Claude는 프로젝트 폴더 자체에서 작업합니다. [현재 레이아웃](#check-which-layout-you-have)에서는 [프롬프트 상자 아래 행](#start-a-session)의 **Worktree** 버튼을 켭니다.

* **[서드 파티 공급자](https://code.claude.com/docs/ko/third-party-integrations.md) 사용 시**: 프롬프트 상자 아래 행에 프로젝트 폴더 컨트롤은 표시되지만 **Worktree** 버튼이 없으면 해당 컨트롤을 클릭하고 **Worktree**를 켭니다
* **[저장된 로컬 또는 SSH 환경](#create-a-saved-environment)의 기본값으로 설정 시**: 환경을 만들거나 편집할 때 **Worktree**를 설정합니다
* **[이전 레이아웃](#check-which-layout-you-have)**: 프롬프트 상자 위의 브랜치 이름 옆에 있는 **worktree** 체크박스를 선택합니다

워크트리는 기본적으로 `<project-root>/.claude/worktrees/`에 저장됩니다. 대신 사용자 지정 디렉터리에 저장하려면 다음과 같이 합니다.

* **로컬 세션**: **Settings > Code** 또는 **Settings > Claude Code**에서 **Worktree location**을 설정합니다
* **SSH 세션**: [SSH 연결](#choose-where-ssh-session-worktrees-go)에서 **Worktree folder**를 설정합니다

**Settings > Code** 또는 **Settings > Claude Code**에서 **Branch prefix**를 설정할 수도 있습니다. Desktop은 모든 워크트리 브랜치 이름 앞에 이 접두사를 붙이며, 이는 Claude가 만든 브랜치를 정리하는 데 유용합니다.

`.env`처럼 gitignore된 파일을 새 워크트리에 포함하려면 프로젝트 루트에 [`.worktreeinclude` 파일](https://code.claude.com/docs/ko/worktrees#copy-gitignored-files-into-worktrees)을 만듭니다. 워크트리 세션이 프로젝트 설정, 훅, 스킬을 어디서 읽는지는 [워크트리가 메인 체크아웃과 공유하는 항목](https://code.claude.com/docs/ko/worktrees.md#what-worktrees-share-with-the-main-checkout)을 참조하세요.

> [!NOTE]
>
> 세션 격리에는 [Git](https://git-scm.com/downloads)이 필요합니다. 대부분의 Mac에는 Git이 기본으로 포함되어 있습니다. 터미널에서 `git --version`을 실행하여 확인할 수 있으며, 버전 번호가 출력되면 Git이 설치된 것입니다. Git 오류가 발생하면 [Cowork](https://claude.com/product/cowork)에서 Claude에게 설정 문제 해결을 도와달라고 요청하세요.

### 세션에 폴더 추가하기

세션이 시작되기 전이나 실행 중에 폴더를 추가할 수 있습니다.

* **로컬 세션이 시작되기 전**: [저장된 환경을 만들거나](#create-a-saved-environment) 편집할 때 **Folders** 아래에 폴더를 추가한 다음 [해당 저장된 환경에서 세션을 시작](#use-edit-or-remove-a-saved-environment)합니다.
* **로컬 또는 [SSH](#ssh-sessions) 세션이 실행되는 동안**: 프롬프트 상자 옆의 \*\*+\*\*를 클릭하고 **Add folder**를 선택합니다. Claude는 [워크트리](#run-a-session-in-its-own-worktree) 없이 해당 폴더 자체에서 작업합니다.

### 세션 보관하기

워크트리에 커밋되지 않은 변경 사항이 있는 세션을 보관하기 전에 [세션 보관 시 커밋되지 않은 변경 사항 유지하기](#keep-uncommitted-changes-when-a-session-is-archived)를 참조하세요. 세션을 보관하려면 사이드바에서 세션 위에 마우스를 올리고 메뉴를 열어 **Archive**를 선택합니다. 세션은 [보관된 세션](#organize-and-find-sessions)으로 이동합니다.

풀 리퀘스트가 병합되거나 닫힐 때 세션이 자동으로 보관되도록 하려면 **Settings > Code** 또는 **Settings > Claude Code**에서 **Auto-archive after PR merge or close**를 켭니다. 클라우드 세션과 아직 실행 중인 세션은 자동으로 보관되지 않습니다.

#### 세션 보관 시 커밋되지 않은 변경 사항 유지하기

세션이 보관될 때 세션 워크트리의 커밋되지 않은 변경 사항이 손실될 수 있으므로, 유지하려는 항목을 먼저 커밋하세요.

* **Desktop이 변경 사항에 대해 묻는 경우**: **Archive anyway**를 선택하여 변경 사항을 삭제하거나, 취소하고 커밋합니다
* **변경 사항이 추적되지 않는 파일뿐인 경우**: Claude가 세션에서 연 풀 리퀘스트가 병합되기 전에 유지하려는 파일을 커밋합니다. 병합 후에는 Desktop이 묻지 않고 해당 파일을 삭제할 수 있기 때문입니다
* **그 외의 경우**: 워크트리는 변경 사항과 함께 디스크에 남아 있습니다. 로컬 세션의 경우 Desktop은 세션이 보관된 시점과 마지막으로 세션을 연 시점 중 더 늦은 시점으로부터 약 30일 후에 둘 다 제거합니다. 변경 사항을 유지하려면 [**Archived** 탭](#organize-and-find-sessions)에서 세션을 열고 **Unarchive**를 선택합니다

### 세션 정리 및 찾기

사이드바 세션 목록의 아이콘에서 세션을 그룹화, 정렬하고 찾을 수 있습니다.

* **현재 레이아웃**: 세션 목록의 제목 위에 마우스를 올려 **Group and sort** 아이콘을 표시한 다음 클릭합니다. 보관된 세션을 찾으려면 메뉴의 마지막 행인 **View all**을 선택한 다음 **Archived** 탭을 엽니다.
* **[이전 레이아웃](#check-which-layout-you-have)**: **Filter** 아이콘이 마우스를 올리지 않아도 표시됩니다. 클릭하여 **Group by** 또는 **Sort by**로 목록을 정렬합니다. 보관된 세션을 표시하려면 **Status**를 선택한 다음 **Archived**를 선택합니다.

세션 이름을 변경하려면 세션을 열고 제목 표시줄의 세션 제목을 클릭합니다.

### 컨텍스트 확인 및 확보하기

컨텍스트 사용량을 확인하려면 [사용량 확인](#check-usage)을 참조하세요. 컨텍스트가 가득 차면 Claude는 자동으로 대화를 요약하고 작업을 계속합니다. `/compact`를 입력하여 요약을 더 일찍 실행하고 컨텍스트 공간을 확보할 수도 있습니다. 압축이 작동하는 방식에 대한 자세한 내용은 [컨텍스트 윈도우](https://code.claude.com/docs/ko/how-claude-code-works.md#the-context-window)를 참조하세요.

### 세션 완료 시 알림 받기

데스크톱 앱은 Code 세션이 작업을 완료했을 때 사용자가 해당 세션을 보고 있지 않으면 OS 알림을 보냅니다. [프로젝트](https://code.claude.com/docs/ko/claude-projects.md#see-what-needs-you-in-overview)에 속한 세션의 경우에는 대신 프로젝트의 알림을 받습니다.

### 세션을 방해하지 않고 곁가지 질문하기

사이드 채팅을 사용하면 세션의 컨텍스트를 활용하되 메인 대화에는 아무것도 추가하지 않는 질문을 Claude에게 할 수 있습니다. 세션의 방향을 벗어나지 않으면서 코드 일부를 이해하거나, 가정을 확인하거나, 아이디어를 탐색하고 싶을 때 사용하세요.

macOS에서는 **Cmd+;**, Windows에서는 \*\*Ctrl+;\*\*를 눌러 사이드 채팅을 열거나, 프롬프트 상자에 `/btw`를 입력합니다. 사이드 채팅은 그 시점까지의 메인 스레드 내용을 모두 읽을 수 있습니다. 완료되면 사이드 채팅을 닫고 중단한 지점에서 메인 세션을 계속합니다.

사이드 채팅은 로컬, SSH, WSL 세션에서 사용할 수 있습니다. 데스크톱 앱은 사이드 채팅을 디스크에 저장하지 않으므로 앱을 닫은 후에는 사이드 채팅으로 돌아갈 수 없습니다.

### 백그라운드 작업 보기

작업 창에는 현재 세션 내에서 실행 중인 백그라운드 작업, 즉 서브에이전트, 백그라운드 셸 명령, [동적 워크플로](https://code.claude.com/docs/ko/workflows.md)가 표시됩니다. 세션에 백그라운드 작업이 있으면 제목 표시줄의 **⋮** 메뉴에서 **Background tasks**로 창을 엽니다.

항목을 클릭하면 서브에이전트 창에서 출력을 보거나 중지할 수 있습니다. 다른 세션이 무엇을 하고 있는지 보려면 [사이드바](#work-in-parallel-with-sessions)를 사용하거나 Claude에게 [대신 확인하도록](#work-across-sessions) 요청하세요.

### 여러 세션에 걸쳐 작업하기

Claude는 다른 Code 탭 세션을 나열하고, 각 세션이 무엇을 해 왔는지 읽고, 세션 간에 메시지를 보낼 수 있습니다. "어떤 세션이 auth 리팩터링을 건드렸어?", "API 세션은 어떤 결론을 냈어?", "payments 세션에 스키마가 변경되었다고 알려 줘"처럼 일상적인 언어로 요청하세요.

Claude에게 세션의 이름을 변경하거나 세션을 보관하도록 요청할 수도 있습니다. 예를 들어 PR이 병합된 세션을 보관하도록 요청할 수 있습니다.

이 사용 환경을 통해 Claude는 데스크톱 앱이 직접 실행하는 세션, 즉 Code 탭의 로컬, [SSH](#ssh-sessions), [WSL](https://code.claude.com/docs/ko/desktop-wsl.md) 세션만 볼 수 있습니다. Claude는 같은 프로젝트의 워크트리에 있더라도 클라우드 세션이나 터미널 CLI 또는 VS Code 확장에서 시작한 세션은 볼 수 없습니다. 따라서 터미널 워크트리 9개와 데스크톱 세션 2개가 열려 있는 경우, 그중 한 데스크톱 세션에서 응답하는 Claude는 나머지 데스크톱 세션 하나만 보고합니다. Claude는 사용자가 질문하고 있는 바로 그 세션은 절대 나열하지 않습니다. 기본적으로 Claude는 가장 최근에 활성화된 20개 세션을 볼 수 있으며, 요청하지 않는 한 보관된 세션은 건너뜁니다. 이와 별개로 [세션 간 메시징](https://code.claude.com/docs/ko/cross-session-messaging.md)을 사용하면 Claude가 터미널 세션을 포함한 [다른 Claude Code 세션](https://code.claude.com/docs/ko/cross-session-messaging.md#see-which-sessions-claude-can-reach)에 메시지를 보낼 수 있습니다.

Claude가 이 사용 환경을 통해 다른 세션에 메시지를 보내면, Claude Code는 해당 세션에 보낸 세션의 제목과 원래 세션으로 돌아가는 링크가 표시된 카드로 메시지를 보여 주므로 메시지의 출처를 항상 알 수 있습니다. 받는 세션이 작업 중이면 Claude Code는 메시지를 보류하고, 현재 작업이 끝나면 Claude가 메시지를 읽습니다. 받는 쪽의 Claude는 회신할 수 있으며, Claude Code는 이 사용 환경을 통해 회신을 다시 전달합니다. Claude는 보관된 세션에는 메시지를 전달할 수 없으며, 메시지가 전달되지 않으면 사용자에게 알려 줍니다.

Claude Code는 세션 간에 세 가지 안전 동작을 적용합니다.

* Claude가 세션을 보관하기 전에 승인 카드가 표시됩니다. 단, 자동 모드와 Bypass permissions 모드에서는 Claude가 승인 카드 없이 세션을 보관할 수 있습니다. 확인을 요청받으려면 Manual로 전환하세요.
* Claude Code는 받는 세션 자체에 [세션 간 메시징](https://code.claude.com/docs/ko/cross-session-messaging.md#availability)이 없더라도 이 사용 환경에서 온 각 메시지를 받는 세션의 [수신 제어](https://code.claude.com/docs/ko/cross-session-messaging.md#control-inbound-messages)와 대조하여 확인합니다. 받는 세션에서 [`crossSessionInbound`](https://code.claude.com/docs/ko/settings-reference#crosssessioninbound)를 `refuse`로 설정하면 Claude Code는 이 사용 환경에서 온 메시지를 삭제합니다. Claude Code는 거부 사실을 Claude 데스크톱 앱에 보고합니다. v2.1.234 이전에는 Claude Code가 세션 간 메시징이 없는 받는 세션으로 향하는 이 사용 환경의 모든 메시지를 삭제했습니다.
* Claude Code는 들어오는 각 메시지를 인용하고 해당 메시지를 보낸 세션을 출처로 표시하며, Claude는 메시지에 따라 작업할 때도 받는 세션 자체의 권한 설정을 계속 따릅니다.

### Claude가 제안한 작업 시작하기

Claude가 현재 작업 외에 수정할 만한 사항을 발견하면 해당 작업을 작업으로 제안합니다. [현재 레이아웃](#check-which-layout-you-have)의 로컬 및 SSH 세션에서는 제안이 채팅에 카드로 표시되며, 카드의 버튼으로 작업을 시작하거나 이 세션에서 처리할 수 있습니다.

* **Start**: 다른 세션에서 작업을 시작합니다. 기본적으로 작업은 현재 세션의 환경에서 실행됩니다. 그러면 카드에 시작된 세션의 상태가 표시되고, [사이드바](#work-in-parallel-with-sessions)에서는 시작된 세션이 현재 세션 아래에 나열됩니다.
* **Do it here**: 작업을 현재 세션에 메시지로 보냅니다
* **Options**: **Start**를 클릭하기 전에 환경, 모델, [워크트리](#run-a-session-in-its-own-worktree), 권한 등의 설정을 검토하거나 변경합니다
* **Start all**: 카드에 여러 작업이 나열된 경우, 한 작업이 끝나기를 기다리지 않고 각 작업을 별도의 세션에서 시작합니다

클라우드 세션과 이전 레이아웃의 로컬 및 SSH 세션에서는 제안이 **Suggested task** 카드로 표시됩니다. **Send to cloud**나 **Start with worktree**처럼 카드의 기본 버튼에 표시된 방식으로 작업을 시작하려면 해당 버튼을 클릭합니다. 기본 버튼 옆의 캐럿을 클릭하면 **Do it here**를 포함하여 작업을 시작하는 다른 방법을 볼 수 있습니다.

### 클라우드에서 장시간 실행 작업 실행하기

대규모 리팩터링, 테스트 스위트, 마이그레이션 또는 기타 장시간 실행되는 작업의 경우, 세션을 시작할 때 [환경 선택기](#start-a-session)에서 **Cloud** 아래의 환경을 선택합니다. 클라우드 세션은 기본적으로 Anthropic이 관리하는 인프라에서 실행되며 앱을 닫거나 컴퓨터를 종료해도 계속됩니다. 언제든지 다시 확인하여 진행 상황을 보거나 Claude를 다른 방향으로 안내할 수 있습니다. [claude.ai/code](https://claude.ai/code) 또는 [Claude 모바일 앱](https://code.claude.com/docs/ko/mobile.md)에서 클라우드 세션을 모니터링할 수도 있습니다.

클라우드 세션은 여러 저장소도 지원합니다. 저장소는 다음 위치에서 선택합니다.

* **현재 레이아웃**: 클라우드 환경을 선택한 후 프롬프트 상자 아래 행에서 선택합니다.
* **[이전 레이아웃](#check-which-layout-you-have)**: 프롬프트 상자 위에서 선택합니다. 다른 저장소를 추가하려면 선택된 저장소 옆의 \*\*+\*\*를 클릭합니다.

클라우드 세션의 작동 방식에 대한 자세한 내용은 [클라우드에서 Claude Code 사용하기](https://code.claude.com/docs/ko/claude-code-on-the-web.md)를 참조하세요. 하나의 작업 묶음에 여러 클라우드 세션이 필요한 경우 [프로젝트](https://code.claude.com/docs/ko/claude-projects.md)를 사용하세요. Claude가 하나의 대화에서 세션을 대신 시작하고 추적합니다. 단계는 [프로젝트 만들기](https://code.claude.com/docs/ko/claude-projects.md#create-a-project)를 참조하세요.

> [!NOTE]
>
> [SSH 세션](#ssh-sessions)의 작업도 [Desktop 연결이 끊긴 동안 계속 실행](#keep-a-task-running-while-desktop-is-disconnected)될 수 있지만, Claude 계정을 사용하는 경우 로그인이 만료되면 중지될 수 있습니다.

### 다른 사용 환경에서 계속하기

세션을 다른 곳에서 계속하려면 세션 제목 옆의 캐럿이나 사이드바의 세션 행에서 세션 메뉴를 연 다음 **Open in**을 선택합니다.

* **Cloud**를 선택하면 대화가 요약으로 이어진 채 세션을 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)으로 계속합니다. 확인하기 전에 대화 상자에 파일도 함께 이동하는지, 그리고 클라우드 세션이 준비되면 이 세션이 보관되는지가 표시됩니다. [SSH](#ssh-sessions) 또는 [WSL](https://code.claude.com/docs/ko/desktop-wsl.md)에서 실행되는 세션은 이 방법으로 이동할 수 없습니다.
* 설치된 편집기나 파일 관리자를 선택하면 디스크에 있는 세션 폴더를 해당 프로그램에서 엽니다.

### 다른 기기에 표시되는 세션 제어하기

로컬 세션은 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)이 연결하면 다른 기기에 표시됩니다. 연결된 세션은 [claude.ai/code](https://claude.ai/code)의 세션 목록과 claude.ai 계정으로 로그인한 기기의 Claude 앱에 표시됩니다.

로컬 세션은 사용자가 해당 세션에 Remote Control을 켜거나, 세션이 시작될 때 자동으로 연결됩니다.

* **해당 세션에 직접 켜기**: 세션의 **Remote Control** 스위치를 사용하거나 프롬프트 상자에 `/remote-control`을 입력합니다.
* **시작 시 연결**: **Settings > Code** 또는 **Settings > Claude Code**에서 **Connect new sessions to Remote Control**이 켜져 있으면 새 세션이 자동으로 연결됩니다. 이 설정을 변경한 적이 없다면 Desktop은 사용자 설정 또는 관리형 설정의 [`remoteControlAtStartup`](https://code.claude.com/docs/ko/settings-reference#remotecontrolatstartup)을 따르고, 그다음 조직의 기본값을 따릅니다.

세션이 연결되어 있는지 확인하려면 [세션 세부 정보 패널](#see-session-details)의 **Environment** 카드에서 **Remote Control** 스위치를 확인합니다.

세션이 다른 기기에 표시되지 않도록 하려면 필요한 수준에서 Remote Control을 끕니다.

* **세션 하나**: 해당 세션의 **Remote Control** 스위치를 끕니다. 시작 시 연결된 세션에서 `/remote-control`을 입력하면 Remote Control이 켜진 상태로 유지되며 `Remote Control is already on. This session connected automatically when it started.`가 표시됩니다. 연결을 끊으려면 해당 줄에서 **Turn off**를 클릭합니다.
* **이 컴퓨터의 새 Desktop 세션**: **Settings > Code** 또는 **Settings > Claude Code**에서 **Connect new sessions to Remote Control**을 끕니다. 이미 꺼져 있는 것으로 표시되면 켰다가 다시 꺼서 Desktop이 선택을 저장하도록 합니다. 저장된 설정은 `remoteControlAtStartup`과 기본값보다 우선합니다.
* **CLI를 포함한 이 컴퓨터의 모든 세션**: `~/.claude/settings.json`에서 [`disableRemoteControl`](https://code.claude.com/docs/ko/settings-reference#disableremotecontrol)을 `true`로 설정하여 세션이 연결되지 않도록 합니다. 파일을 저장할 때 이미 연결되어 있던 세션은 해당 세션의 Remote Control을 끌 때까지 연결된 상태로 유지됩니다.

이미 다른 기기에 표시된 세션을 숨기려면 Desktop에서 해당 세션을 보관합니다. Desktop은 세션의 Remote Control 사본도 보관하므로 해당 기기의 기본 세션 목록에서 사라집니다. 해당 기기에서 세션을 보거나 삭제하려면 [세션 보관하기](https://code.claude.com/docs/ko/claude-code-on-the-web.md#archive-sessions)를 참조하세요.

### Dispatch에서 시작한 세션

[Dispatch](https://support.claude.com/en/articles/13947068)는 [Cowork](https://claude.com/product/cowork)에 있는 Claude와의 지속적인 대화입니다. Dispatch에 작업을 메시지로 보내면 Dispatch가 처리 방법을 결정합니다.

작업이 Code 세션이 되는 방법은 두 가지입니다. "Claude Code 세션을 열고 로그인 버그를 수정해 줘"처럼 직접 요청하거나, Dispatch가 작업을 개발 작업으로 판단하고 스스로 세션을 생성하는 경우입니다. 일반적으로 Code로 전달되는 작업에는 버그 수정, 의존성 업데이트, 테스트 실행, 풀 리퀘스트 열기 등이 있습니다. 리서치, 문서 편집, 스프레드시트 작업은 Cowork에 남습니다.

#### Dispatch가 시작한 세션 따라가기

Dispatch가 시작한 세션은 Code 탭의 사이드바에 다른 세션과 함께 표시됩니다. 사이드바의 [기본 그룹화 및 정렬](#organize-and-find-sessions)을 사용하는 경우, 세션이 실행되는 폴더의 그룹에서 가장 최근 세션을 찾으세요. 세션이 완료되거나 승인이 필요하면 휴대폰으로 푸시 알림을 받습니다.

[컴퓨터 사용](#let-claude-use-your-computer)이 활성화되어 있으면 Dispatch가 생성한 Code 세션에서도 이를 사용할 수 있습니다. 이러한 세션의 앱 승인은 일반 Code 세션처럼 세션 전체 동안 유지되지 않고 30분 후에 만료되어 다시 확인을 요청합니다.

#### Dispatch 설정하기

* **플랜**: Dispatch에는 Pro, Max 또는 Ultra 플랜이 필요하며 Team 또는 Enterprise 플랜에서는 사용할 수 없습니다
* **설정, 페어링, Dispatch 설정**: [Dispatch 도움말 문서](https://support.claude.com/en/articles/13947068)를 참조하세요

Dispatch는 터미널을 떠나 있을 때 Claude와 함께 작업하는 여러 방법 중 하나입니다. 다른 옵션과의 비교는 [플랫폼 및 통합](https://code.claude.com/docs/ko/platforms.md#work-when-you-are-away-from-your-terminal)을 참조하세요.

## Claude Code 확장하기

외부 서비스를 연결하고, 재사용 가능한 워크플로를 추가하고, Claude의 동작을 사용자 정의하고, 미리보기 서버를 구성합니다. 한 곳에서 커넥터, 스킬, 플러그인을 관리하려면 사이드바에서 **Customize**를 클릭합니다. Desktop 앱의 [Cowork](https://claude.com/product/cowork)는 CLI의 `~/.claude` 디렉터리가 아닌 이 Customize 구성에서 스킬, 플러그인, 커넥터를 가져오며, 이는 claude.ai 계정을 통해 동기화됩니다.

Claude Code는 또한 동일한 계정으로 로그인한 터미널 세션에서 claude.ai 계정에 대해 활성화된 skills 및 플러그인을 로드합니다. [claude.ai에서 동기화된 Skills](https://code.claude.com/docs/ko/skills.md#how-synced-skills-behave) 및 [claude.ai에서 동기화된 Plugins](https://code.claude.com/docs/ko/plugins/loading.md#synced-plugins)를 참조하세요.

### 외부 도구 연결하기

커넥터는 그래픽 설정 흐름을 갖춘 [MCP 서버](https://code.claude.com/docs/ko/mcp.md)입니다.

Claude 계정을 사용하는 로컬 또는 [SSH](#ssh-sessions) 세션에서 커넥터를 추가하려면 세션 전이나 중에 프롬프트 상자 옆의 \*\*+\*\*를 클릭합니다. **Add connectors**를 선택하여 커넥터 디렉터리를 엽니다. 메뉴에 **Connectors**가 대신 표시되면 이를 선택한 다음 **Browse connectors**를 선택합니다.

> [!NOTE]
>
> 다음 경우는 다른 페이지에서 다룹니다:
>
> * **WSL 세션에서 Connectors가 회색으로 비활성화된 경우**: [터미널 또는 커넥터를 사용할 수 없는 경우](https://code.claude.com/docs/ko/desktop-wsl.md#check-for-the-terminal-and-connectors)를 참조하세요
> * **클라우드 세션**: [커넥터가 Claude Code에 연결되는 방식](https://code.claude.com/docs/ko/mcp.md#how-connectors-reach-claude-code)을 참조하세요

연결되면 Claude는 캘린더를 읽고, 메시지를 보내고, 이슈를 만들고, 도구와 직접 상호작용할 수 있습니다. Claude에게 세션에 구성된 커넥터가 무엇인지 물어볼 수 있습니다. 커넥터를 관리하거나 연결을 해제하려면 사이드바에서 **Customize**를 클릭하고 **Connectors**를 엽니다.

Connectors에 나열되지 않은 통합의 경우 [설정 파일](https://code.claude.com/docs/ko/mcp.md#installing-mcp-servers)을 통해 MCP 서버를 수동으로 추가합니다. [사용자 정의 커넥터를 만들](https://support.claude.com/en/articles/11175166-getting-started-with-custom-connectors-using-remote-mcp) 수도 있습니다.

### skills 사용하기

[Skills](https://code.claude.com/docs/ko/skills.md)는 Claude가 할 수 있는 것을 확장합니다. Claude는 관련이 있을 때 자동으로 로드하거나 직접 호출할 수 있습니다: 프롬프트 상자에서 `/`를 입력하거나 **+** 버튼을 클릭하고 **Slash commands**를 선택하여 사용 가능한 것을 찾아봅니다. 여기에는 [내장 명령](https://code.claude.com/docs/ko/commands.md), [사용자 정의 skills](https://code.claude.com/docs/ko/skills.md#create-your-first-skill), 코드베이스의 프로젝트 skills, [설치된 플러그인](https://code.claude.com/docs/ko/plugins/install.md)의 skills가 포함됩니다. 하나를 선택하면 입력 필드에 강조 표시됩니다. 그 후 작업을 입력하고 평소대로 보냅니다.

Claude가 작업 중일 때 다른 메시지와 동일하게 명령을 보낼 수 있으며, 턴이 완료되면 세션이 유휴 상태로 돌아갑니다.

로컬 세션은 `~/.claude/skills/`에서 개인 skills를 로드합니다. [SSH](#ssh-sessions) 세션은 사용자 머신이 아닌 원격 호스트의 홈 디렉토리에서 `~/.claude/skills/`를 읽습니다.

로컬 및 클라우드 세션은 또한 claude.ai 계정에 대해 활성화된 skills를 로드합니다. 단, 조직이 [`disableSideloadFlags`](https://code.claude.com/docs/ko/settings-reference#disablesideloadflags)를 설정한 경우 로컬 세션은 제외됩니다. 클라우드 세션은 [Cowork 및 클라우드 세션의 Skills](https://code.claude.com/docs/ko/skills.md#skills-in-cowork-and-cloud-sessions)에서 설명하는 대로 `~/.claude/skills/` 대신 이를 로드합니다.

### 플러그인 설치하기

[Plugins](https://code.claude.com/docs/ko/plugins/overview.md)는 Claude Code에 skills, agents, hooks, MCP servers, LSP 구성을 추가하는 재사용 가능한 패키지입니다. 터미널을 사용하지 않고 데스크톱 앱에서 플러그인을 설치할 수 있습니다.

로컬 세션 또는 [SSH 세션](#ssh-sessions)에서 프롬프트 상자 옆의 \*\*+\*\*를 클릭하고 **Add plugins**를 선택하여 플러그인 브라우저를 엽니다. 메뉴에 **Plugins**가 대신 표시되면 이를 선택한 다음 **Browse plugins**를 선택하거나, 플러그인을 활성화, 비활성화 또는 제거하려면 **Manage plugins**를 선택합니다.

플러그인은 사용자 계정, 특정 프로젝트 또는 로컬 전용으로 범위를 지정할 수 있습니다. 조직이 플러그인을 중앙에서 관리하는 경우 해당 플러그인은 CLI에서와 동일한 방식으로 데스크톱 세션에서 사용 가능합니다. 단, 데스크톱 앱이 [`disableSideloadFlags`](https://code.claude.com/docs/ko/settings-reference#disablesideloadflags)에서 보류하는 플러그인은 제외됩니다.

플러그인 브라우저는 클라우드 세션에서 사용할 수 없으며, 데스크톱 앱에서 설치한 플러그인은 클라우드 세션에서 사용할 수 없습니다. 클라우드 세션도 저장소의 `.claude/settings.json`에서 선언하는 플러그인을 설치하지 않습니다. [설정에서 가져오는 것](https://code.claude.com/docs/ko/cloud-environments.md#what-carries-over-from-your-setup)에서 설명합니다. 플러그인은 WSL 세션에서 사용할 수 없습니다. 자신의 플러그인을 만드는 것을 포함한 전체 플러그인 참조는 [plugins](https://code.claude.com/docs/ko/plugins/overview.md)를 참조하세요.

### 미리보기 서버 구성하기

Claude는 개발 서버 설정을 자동으로 감지하고 세션을 시작할 때 선택한 폴더의 루트에 있는 `.claude/launch.json`에 구성을 저장합니다. Preview는 이 폴더를 작업 디렉토리로 사용하므로 부모 폴더를 선택한 경우 자신의 개발 서버가 있는 하위 폴더는 자동으로 감지되지 않습니다. 하위 폴더의 서버로 작업하려면 해당 폴더에서 직접 세션을 시작하거나 구성을 수동으로 추가합니다.

예를 들어 `npm run dev` 대신 `yarn dev`를 사용하거나 포트를 변경하는 등 서버가 시작되는 방식을 사용자 정의하려면 `.claude/launch.json`을 편집합니다. 파일은 주석이 있는 JSON을 지원합니다.

```json theme={null}
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "my-app",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "port": 3000
    }
  ]
}
```

동일한 프로젝트에서 프론트엔드 및 API와 같은 다양한 서버를 실행하도록 여러 구성을 정의할 수 있습니다. 아래의 [예제](#examples)를 참조하세요.

#### 자동 변경 사항 확인

`autoVerify`가 활성화되면 Claude는 파일을 편집한 후 자동으로 코드 변경 사항을 확인합니다. 스크린샷을 찍고, 오류를 확인하고, 응답을 완료하기 전에 변경 사항이 작동하는지 확인합니다.

자동 확인은 기본적으로 켜져 있습니다. `.claude/launch.json`에 `"autoVerify": false`를 추가하여 프로젝트별로 비활성화하거나, Browser 창의 **⋮** 메뉴에서 **Auto-verify changes**를 끕니다.

```json theme={null}
{
  "version": "0.0.1",
  "autoVerify": false,
  "configurations": [
    {
      "name": "my-app",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "port": 3000
    }
  ]
}
```

비활성화되면 미리보기 도구는 여전히 사용 가능하며 언제든지 Claude에게 확인을 요청할 수 있습니다. 자동 확인은 모든 편집 후 자동으로 만듭니다.

#### 구성 필드

`configurations` 배열의 각 항목은 다음 필드를 허용합니다:

| 필드 | 유형 | 설명 |
| - | - | - |
| `name` | string | 이 서버의 고유 식별자 |
| `runtimeExecutable` | string | 실행할 명령 (예: `npm`, `yarn`, `node`) |
| `runtimeArgs` | string\[] | `runtimeExecutable`에 전달되는 인수 (예: `["run", "dev"]`) |
| `port` | number | 서버가 수신하는 포트. 기본값은 3000 |
| `cwd` | string | 프로젝트 루트에 상대적인 작업 디렉토리. 기본값은 프로젝트 루트입니다. 프로젝트 루트를 명시적으로 참조하려면 `${workspaceFolder}`를 사용합니다 |
| `env` | object | `{ "NODE_ENV": "development" }`와 같은 키-값 쌍으로 된 추가 환경 변수. 이 파일은 저장소에 커밋되므로 여기에 비밀 정보를 넣지 마세요. 비밀 정보는 [개발 서버의 환경 변수 설정](#set-environment-variables-for-dev-servers)을 참조하세요. |
| `autoPort` | boolean | 포트 충돌을 처리하는 방법. [포트 충돌](#port-conflicts) 참조 |
| `program` | string | `node`로 실행할 스크립트. [언제 `program` vs `runtimeExecutable`을 사용할지](#when-to-use-program-vs-runtimeexecutable) 참조 |
| `args` | string\[] | `program`에 전달되는 인수. `program`이 설정된 경우에만 사용됨 |
| `url` | string | Preview가 `http://localhost:<port>` 대신 열 주소. [특정 URL에서 preview 열기](#open-the-preview-at-a-specific-url) 참조 |

##### `program` vs `runtimeExecutable` 사용 시기

`runtimeExecutable`을 `runtimeArgs`와 함께 사용하여 패키지 관리자를 통해 개발 서버를 시작합니다. 예를 들어 `"runtimeExecutable": "npm"`과 `"runtimeArgs": ["run", "dev"]`는 `npm run dev`를 실행합니다.

`node`로 직접 실행하려는 독립 실행형 스크립트가 있을 때 `program`을 사용합니다. 예를 들어 `"program": "server.js"`는 `node server.js`를 실행합니다. `args`로 추가 플래그를 전달합니다.

##### 특정 URL에서 preview 열기

기본적으로 preview는 `http://localhost:<port>`를 엽니다. 서버가 다른 주소가 필요할 때 `url`을 설정합니다. 일반적인 경우는 로컬 HTTPS가 필요한 서버, `*.localhost` 서브도메인을 사용하는 앱, 리다이렉트를 통해 사용자를 로그인하는 앱입니다.

```json theme={null}
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "my-app",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "port": 8443,
      "url": "https://localhost:8443"
    }
  ]
}
```

Localhost 주소는 기본 포트 주소와 정확히 동일하게 직접 열립니다. 여기에는 `localhost`, 모든 `*.localhost` 서브도메인, `127.0.0.1`, `::1`이 포함됩니다. 보안상 localhost `url`은 서버의 origin만 있어야 합니다 — 경로나 쿼리가 없어야 하며, 포트는 항목의 포트와 일치해야 합니다. 특정 페이지를 표시하려면 preview가 열린 후 Claude에게 거기로 이동하도록 요청합니다. 경로, 쿼리 또는 일치하지 않는 포트가 있는 localhost `url`은 url을 이름으로 지정하고 수정 사항을 표시하는 구성 오류로 보고됩니다.

다른 주소의 경우 Desktop은 preview가 처음 열 때 권한을 요청하며, preview에서 새 사이트를 탐색할 때와 동일합니다. 외부 주소에는 경로가 포함될 수 있습니다. **Always allow**를 선택하여 향후 해당 사이트에 대한 프롬프트를 건너뜁니다. preview에서 외부 사이트를 제한하는 조직 정책이 여전히 적용됩니다.

이미 직접 실행 중인 서버를 preview하려면 명령 없이 `url`을 설정합니다. Claude는 서버를 시작하는 대신 실행 중인 서버에 preview를 연결합니다:

```json theme={null}
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "my-app",
      "url": "https://app.localhost:3000"
    }
  ]
}
```

`url`은 `http` 또는 `https`여야 하며, 사용자 이름이나 비밀번호를 포함하지 않아야 합니다.

#### 포트 충돌

`autoPort` 필드는 선호하는 포트가 이미 사용 중일 때 발생하는 상황을 제어합니다:

* **`true`**: Claude는 자동으로 사용 가능한 포트를 찾아 사용합니다. 대부분의 개발 서버에 적합합니다.
* **`false`**: Claude는 오류로 실패합니다. OAuth 콜백 또는 CORS allowlists와 같이 서버가 특정 포트를 사용해야 할 때 사용합니다.
* **설정되지 않음 (기본값)**: 아래의 한 가지 경우를 제외하고 `true`와 마찬가지로 서버가 다음으로 사용 가능한 포트를 받습니다. Claude Desktop v2.37337.0 이전에는 대신 Claude가 서버에 해당 포트가 정확히 필요한지 묻고, 답변을 `launch.json`에 저장합니다.

선호하는 포트가 사용 중이고 `autoPort`가 설정되지 않은 경우, 다음 조건이 모두 충족되면 서버는 중지된 상태로 유지됩니다:

* `npm`, `yarn`, `pnpm` 또는 `bun` 스크립트를 통해 서버를 시작합니다.
* 선호하는 포트가 해당 스크립트에 하드코딩되어 있거나, Claude가 스크립트를 검사할 수 없습니다.
* `runtimeArgs`에서 포트를 전달하지 않습니다.

이 경우 포트를 비우거나, 하드코딩된 값을 제거하거나, 스크립트와 일치하도록 `port`를 변경합니다. 대신 `"autoPort": true`를 설정하는 방법은 `PORT`를 읽는 스크립트에서만 작동합니다.

할당된 포트를 전달하는 `PORT` 환경 변수에서 서버가 포트를 읽도록 합니다. Claude가 서버를 다른 포트로 옮기면 `runtimeArgs`의 `--port` 또는 `-p` 값도 일치하도록 다시 작성합니다.

#### 예제

이러한 구성은 다양한 프로젝트 유형에 대한 일반적인 설정을 보여줍니다:

> [tab] Next.js
>
> 이 구성은 Yarn을 사용하여 포트 3000에서 Next.js 앱을 실행합니다:
>
> ```json theme={null}
> {
>   "version": "0.0.1",
>   "configurations": [
>     {
>       "name": "web",
>       "runtimeExecutable": "yarn",
>       "runtimeArgs": ["dev"],
>       "port": 3000
>     }
>   ]
> }
> ```

> [tab] Multiple servers
>
> 프론트엔드 및 API 서버가 있는 monorepo의 경우 여러 구성을 정의합니다. 프론트엔드는 `autoPort: true`를 사용하므로 3000이 사용 중이면 사용 가능한 포트를 선택하고, API 서버는 포트 8080을 정확히 요구합니다:
>
> ```json theme={null}
> {
>   "version": "0.0.1",
>   "configurations": [
>     {
>       "name": "frontend",
>       "runtimeExecutable": "npm",
>       "runtimeArgs": ["run", "dev"],
>       "cwd": "apps/web",
>       "port": 3000,
>       "autoPort": true
>     },
>     {
>       "name": "api",
>       "runtimeExecutable": "npm",
>       "runtimeArgs": ["run", "start"],
>       "cwd": "server",
>       "port": 8080,
>       "env": { "NODE_ENV": "development" },
>       "autoPort": false
>     }
>   ]
> }
> ```

> [tab] Node.js script
>
> 패키지 관리자 명령 대신 Node.js 스크립트를 직접 실행하려면 `program` 필드를 사용합니다:
>
> ```json theme={null}
> {
>   "version": "0.0.1",
>   "configurations": [
>     {
>       "name": "server",
>       "program": "server.js",
>       "args": ["--verbose"],
>       "port": 4000
>     }
>   ]
> }
> ```

## 환경 구성

[세션을 시작](#start-a-session)할 때 선택하는 환경은 Claude가 실행되는 위치와 연결 방식을 결정합니다:

* **Local**: 머신에서 실행되며 파일에 직접 액세스합니다
* **Cloud**: Anthropic이 관리하는 인프라에서 기본적으로 실행됩니다. 앱을 닫아도 세션이 계속됩니다.
* **SSH**: SSH를 통해 연결하는 원격 머신(예: 자신의 서버, 클라우드 VM 또는 개발 컨테이너)에서 실행됩니다. 실행 중인 작업은 [Desktop 연결이 끊긴 동안에도 계속 진행](#keep-a-task-running-while-desktop-is-disconnected)될 수 있지만, Claude 계정을 사용하는 경우 로그인이 만료되면 중지될 수 있습니다.
* **WSL** (Windows): 머신의 [WSL 2 배포판](https://code.claude.com/docs/ko/desktop-wsl.md)에서 실행되며, Linux 도구 모음 및 기본 경로를 사용합니다

### 저장된 환경 만들기

저장된 환경은 Claude가 실행되는 위치를 기록하는 [환경 선택기](#start-a-session)의 항목으로, 이후 세션을 그곳에서 시작할 수 있게 해 줍니다. 로컬 또는 SSH 환경에는 Claude가 작업하는 폴더도 함께 저장됩니다. 저장된 로컬 및 SSH 환경은 [현재 레이아웃](#check-which-layout-you-have)의 일부이므로, 보이지 않는다면 어떤 레이아웃을 사용 중인지, 그리고 현재 레이아웃을 사용하는 방법을 확인하세요.

**1. New environment 대화 상자 열기**

프롬프트 상자 아래의 환경 선택기를 열고 메뉴 하단에서 **New environment**를 선택합니다.

**2. Claude가 실행될 위치 선택**

**Local**, **SSH** 또는 [**Cloud**](#cloud-sessions) 탭을 선택하고 해당 탭의 양식을 작성합니다. **SSH** 탭에서는 [연결](#ssh-sessions)과 원격 머신의 폴더를 선택합니다.

**3. 환경 저장**

**Create environment**를 선택하거나, **Cloud** 탭에서는 **Add environment**를 선택합니다.

#### Desktop이 자동으로 만드는 환경

직접 만들지 않은 로컬 또는 SSH 환경이 환경 선택기에 표시된다면 Desktop이 자동으로 만든 것입니다. [현재 레이아웃](#check-which-layout-you-have)에서 Code 탭을 처음 열면 Desktop은 최대 8개의 환경을 만듭니다. 이 환경은 지난 한 달 동안 가장 많이 사용한 로컬 및 SSH 폴더를 기반으로 합니다. 이 환경은 [편집하거나 삭제](#use-edit-or-remove-a-saved-environment)할 수 있습니다.

#### 저장된 환경 사용, 편집 또는 제거

[환경 선택기](#start-a-session)에서 해당 환경의 항목을 찾습니다.

* **세션 시작**: 항목을 선택합니다.
* **편집 또는 삭제**: 항목 위에 마우스를 올리고 톱니바퀴 아이콘을 클릭합니다. 로컬 또는 SSH 환경을 삭제하려면 **Edit environment**에서 **Delete environment**를 클릭합니다.
* **클라우드 환경 보관**: [환경 보관](https://code.claude.com/docs/ko/cloud-environments.md#archive-an-environment)을 참조하십시오.

### 로컬 세션의 환경 변수

로컬 세션에 환경 변수를 설정하려면 [저장된 로컬 환경에 추가](#set-environment-variables-for-local-sessions)한 다음 해당 환경에서 새 세션을 시작합니다.

`PATH`, `CLAUDE_CONFIG_DIR` 같은 변수에는 별도의 안내가 있습니다.

| 변수 | 대신 해야 할 일 |
| :- | :- |
| `PATH`, 즉 시스템이 `npm` 같은 프로그램을 찾는 폴더 | [세션이 설치된 도구를 찾지 못하는 경우](#session-not-finding-installed-tools)를 참조하세요. Windows에서는 Desktop이 PowerShell 프로필을 읽지 않으므로 사용자 또는 시스템 환경 변수에 `PATH`를 설정한 다음 Desktop을 종료했다가 다시 엽니다. |
| [`claude_desktop_config.json`](#mcp-servers-from-the-claude-desktop-chat-app)의 MCP 서버용 변수 | Desktop을 종료하고 해당 서버의 `env` 블록에 설정한 다음 Desktop을 다시 엽니다 |
| [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars#variables) 또는 [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars#variables) | [개발 서버용 변수를 설정하는 위치 중 하나](#set-environment-variables-for-dev-servers)에 설정한 다음 Desktop을 종료했다가 다시 엽니다 |
| `API_TIMEOUT_MS`, `ANTHROPIC_BASE_URL` 또는 Desktop이 직접 설정하는 다른 변수 | [Desktop이 직접 설정하는 환경 변수](#environment-variables-desktop-sets-itself)를 참조하세요 |

macOS 또는 Linux에서 `export`로 설정한 변수가 Claude가 실행하는 명령에서 누락되거나 잘못된 경우 [Claude가 실행하는 명령에서 내보낸 변수가 누락되거나 잘못된 경우](#exported-variable-missing-or-wrong-in-commands-claude-runs)를 참조하세요.

#### 로컬 세션의 환경 변수 설정

저장된 로컬 환경에 변수를 추가하고 그 환경에서 세션을 시작합니다. Desktop은 `API_TIMEOUT_MS` 같은 [일부 변수를 직접 설정](#environment-variables-desktop-sets-itself)하며, 이러한 변수의 경우 세션은 사용자가 설정한 값 대신 Desktop의 값을 받습니다.

> [!NOTE]
>
> 새 세션의 프롬프트 상자 아래에 환경이 표시되지 않는다면 저장된 로컬 환경이 없는 [이전 레이아웃](#check-which-layout-you-have)을 사용 중인 것입니다. 대신 [로컬 환경 편집기](#use-the-local-environment-editor)를 사용하십시오.

**1. 로컬 환경 양식 열기**

* **저장된 로컬 환경을 만들려면**: 환경 선택기 메뉴 하단에서 [**New environment**](#create-a-saved-environment)를 선택한 다음 **Local** 탭을 선택합니다
* **기존 환경을 변경하려면**: 환경 선택기에서 **Local** 아래의 저장된 환경 위에 마우스를 올리고 톱니바퀴 아이콘을 클릭하여 [**Edit environment**](#use-edit-or-remove-a-saved-environment)를 엽니다

**2. 변수 입력**

**Environment variables**를 선택하고 한 줄에 하나씩 `KEY=value`를 입력한 다음 **Done**을 선택합니다.

**3. 환경 저장**

**Create environment** 또는 **Save**를 선택합니다.

해당 환경에서 시작한 세션만 이 변수를 받습니다.

모든 로컬 세션에 변수를 설정하려면 `~/.claude/settings.json` 파일의 [`env` 키](https://code.claude.com/docs/ko/env-vars#set-variables-in-settings-files)에 추가합니다. Desktop이 세션을 시작하는 환경에 해당 변수가 이미 있으면 Claude Code는 [그 값을 무시](https://code.claude.com/docs/ko/settings-reference.md#how-env-values-interact-with-your-shell)합니다. 지원되는 전체 변수 목록은 [환경 변수](https://code.claude.com/docs/ko/env-vars.md)를 참조하십시오.

#### 개발 서버의 환경 변수 설정

비밀 값을 [`launch.json`](#configure-preview-servers)에 커밋하지 않고 개발 서버에 제공하려면 다음 위치 중 하나에 설정한 다음 Desktop을 다시 시작합니다.

* **macOS 및 Linux**: 셸 프로필에서 export합니다
* **Windows**: 사용자 또는 시스템 환경 변수에 추가합니다
* **모든 플랫폼**: 열 수 있는 경우 [로컬 환경 편집기](#use-the-local-environment-editor)에 저장합니다

개발 서버는 [저장된 환경](#create-a-saved-environment)이나 `~/.claude/settings.json`에 추가한 변수를 받지 않습니다.

#### 로컬 환경 편집기 사용

로컬 환경 편집기를 열려면 저장된 환경의 항목이 아니라 사용자 컴퓨터 항목의 톱니바퀴 아이콘을 클릭합니다.

* **프롬프트 상자 아래의 선택기**: **Local** 아래 첫 번째 항목인 사용자 컴퓨터 항목 위에 마우스를 올립니다. 톱니바퀴 아이콘이 나타나면 클릭합니다. 나타나지 않으면 편집기를 사용할 수 없으므로 [로컬 세션](#set-environment-variables-for-local-sessions) 또는 [개발 서버](#set-environment-variables-for-dev-servers)의 변수를 다른 방법으로 설정합니다.
* **프롬프트 상자 위의 선택기**: **Local** 위에 마우스를 올리고 톱니바퀴 아이콘을 클릭합니다

한 줄에 하나씩 `KEY=value`를 입력하고 **Save changes**를 선택합니다. 여기에 저장한 변수는 사용자의 컴퓨터에 암호화되어 저장됩니다. 로컬 세션은 이 변수를 받지만, `API_TIMEOUT_MS`처럼 [Desktop이 직접 설정하는](#environment-variables-desktop-sets-itself) 변수는 예외입니다. 개발 서버에 변수를 제공하려면 Desktop을 다시 시작합니다.

#### Claude가 실행하는 명령에서 내보낸 변수가 없거나 잘못된 경우

macOS 또는 Linux에서 Claude가 실행하는 명령이 `~/.zshrc`나 `~/.bashrc`에 `export`로 설정한 변수를 받지 못하거나 잘못된 값을 받는다면 다음을 순서대로 시도하세요.

**1. 새 세션 시작**

Claude에게 명령을 다시 실행하도록 요청합니다.

**2. Desktop 종료 후 다시 열기**

그런 다음 새 세션을 시작합니다.

**3. 저장된 변수 확인**

명령이 잘못된 값을 받는다면 [저장된 환경](#use-edit-or-remove-a-saved-environment)이나 [로컬 환경 편집기](#use-the-local-environment-editor)에도 해당 변수를 설정했는지 확인합니다. 설정했다면 그곳에서 값을 변경하고 새 세션을 시작합니다.

**4. 저장된 환경 사용**

[저장된 로컬 환경](#set-environment-variables-for-local-sessions)에 변수를 추가한 다음 해당 환경에서 새 세션을 시작합니다. `PATH`, `CLAUDE_CONFIG_DIR`, `API_TIMEOUT_MS` 같은 변수는 대신 [해당 변수의 안내](#environment-variables-in-local-sessions)를 따릅니다.

v2.1.304 이전의 Claude Code는 내보낸 변수를 명령에 전달하지 않으므로 [세션이 실행하는 버전을 확인](#claude-code-version-in-the-code-tab)하세요.

#### Desktop이 직접 설정하는 환경 변수

`API_TIMEOUT_MS` 또는 `ANTHROPIC_BASE_URL`을 설정했는데 로컬 세션에서 아무것도 바뀌지 않았다면, Desktop이 이 [변수](https://code.claude.com/docs/ko/env-vars.md#variables)를 비롯한 여러 변수를 직접 설정하기 때문입니다. 셸 프로필, Windows 사용자 또는 시스템 변수, 로컬 환경 편집기, 저장된 환경 중 어디에서 설정하든 로컬 세션은 Desktop의 값을 받습니다. 로컬 세션에서 Claude Code는 설정 파일의 [값을 무시](https://code.claude.com/docs/ko/settings-reference.md#how-env-values-interact-with-your-shell)하므로, 설정 파일로 옮겨도 효과가 없습니다.

* `API_TIMEOUT_MS`: 로컬 세션은 15분에 해당하는 `900000`을 받습니다. 더 긴 타임아웃이 필요하면 [Claude Code CLI를 설치](https://code.claude.com/docs/ko/quickstart.md)하여 Desktop 대신 사용하십시오. [셸에서 변수를 설정](https://code.claude.com/docs/ko/env-vars.md#set-variables-in-your-shell)하고 터미널에서 `claude`를 실행합니다.
* `ANTHROPIC_BASE_URL`: Claude 계정으로 로그인한 경우 로컬 세션은 Anthropic의 API 호스트를 받습니다. 게이트웨이를 사용하려면 대신 Desktop의 [타사 추론 구성](https://code.claude.com/docs/ko/llm-gateway-connect.md#desktop-app)을 설정하십시오.

#### 확장 사고 끄기

[확장 사고](https://code.claude.com/docs/ko/model-config.md#extended-thinking)는 기본적으로 활성화되어 있으며, 복잡한 추론 작업의 성능을 향상시키지만 추가 토큰을 사용합니다. 끄려면 [저장된 로컬 환경](#set-environment-variables-for-local-sessions) 또는 [로컬 환경 편집기](#use-the-local-environment-editor)에서 `MAX_THINKING_TOKENS`를 `0`으로 설정합니다. 그러면 Anthropic API에서 사고가 꺼지지만, 항상 확장 사고를 사용하는 Opus 5.5, Sonnet 5.5, Haiku 5.5 및 Fable 모델은 예외입니다.

Opus 5에서는 세션을 시작하기 전에 effort를 `high` 이하로 선택해야 합니다. [현재 레이아웃](#check-which-layout-you-have)에서 모델 선택기를 열고 **Effort** 아래에서 수준을 선택합니다. 더 높은 수준으로 세션을 시작했다면 `high` 이하로 새 세션을 시작하십시오.

#### 고정 사고 예산

[적응형 추론](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)이 있는 모델에서는 적응형 추론이 사고 깊이를 제어하기 때문에 Claude Code가 양수 `MAX_THINKING_TOKENS` 값의 숫자 자체를 무시합니다. Opus 4.6 및 Sonnet 4.6에서는 `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`을 `1`로 설정하여 고정 사고 예산을 사용합니다. Fable 모델, Sonnet 5 이상, Haiku 5.5, Opus 4.7 이상은 항상 적응형 추론을 사용하며 고정 예산 모드가 없습니다.

### 관리되는 기기의 로컬 세션

환경 선택기에서 사용자 컴퓨터 항목이 **Disabled by your organization** 툴팁과 함께 회색으로 표시된다면 관리자가 [로컬 세션을 끈](#managed-settings) 것입니다. Windows에서는 관리 대상 기기에서의 사용 가능 여부가 [별도로 관리되는](https://code.claude.com/docs/ko/admin-setup.md#wsl-sessions-in-claude-code-desktop) [WSL](https://code.claude.com/docs/ko/desktop-wsl.md) 항목도 같은 방식으로 회색으로 표시됩니다.

SSH 연결이 구성되어 있으면 새 세션은 기본적으로 첫 번째 SSH 연결을 사용합니다. 기존 로컬 세션을 계속하려고 하면 Desktop은 이 기기에서 로컬 세션을 사용할 수 없다는 메시지를 표시합니다. [저장된 로컬 환경](#create-a-saved-environment)을 선택하면 다음 오류가 표시됩니다: `Couldn’t switch environments: the Local environment isn’t available anymore.` 대신 [SSH](#ssh-sessions) 또는 [클라우드](#cloud-sessions) 환경을 선택하거나 IT 팀에 문의하십시오.

### 클라우드 세션

클라우드 세션은 앱을 닫아도 백그라운드에서 계속됩니다. 사용량은 별도의 컴퓨팅 요금 없이 [구독 계획 한도](https://code.claude.com/docs/ko/costs.md)에 포함됩니다.

클라우드 환경을 추가, 편집 또는 [보관](https://code.claude.com/docs/ko/cloud-environments.md#archive-an-environment)하려면 [환경 선택기](#start-a-session)를 엽니다.

* **환경 추가**: 선택기 메뉴 하단에서 **New environment**를 선택한 다음 [**New environment** 대화 상자](#create-a-saved-environment)의 **Cloud** 탭을 선택합니다
* **자신의 환경 중 하나를 편집하거나 보관**: 위에 마우스를 올린 다음 기어 아이콘을 클릭합니다

네트워크 액세스 및 환경 변수 구성에 대한 자세한 내용은 [클라우드 환경 구성](https://code.claude.com/docs/ko/cloud-environments.md)을 참조하세요.

### SSH 세션

SSH 세션을 사용하면 데스크톱 앱을 인터페이스로 사용하면서 원격 머신에서 Claude Code를 실행할 수 있습니다. 이는 클라우드 VM, 개발 컨테이너 또는 특정 하드웨어 또는 종속성이 있는 서버에 있는 코드베이스로 작업할 때 유용합니다.

> [!NOTE]
>
> Desktop을 [타사 제공업체](https://code.claude.com/docs/ko/third-party-integrations.md)와 함께 사용하는 경우 SSH 세션에는 별도의 설정이 필요합니다. [SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions)를 참조하세요.

[**New environment** 대화 상자](#create-a-saved-environment)에서 SSH 연결을 추가한 다음 해당 연결에서 세션을 시작합니다. 새 세션의 프롬프트 상자 아래에 환경이 표시되지 않는다면 이전 레이아웃을 사용 중인 것입니다. [사용 중인 레이아웃 확인](#check-which-layout-you-have)을 참조하십시오.

**1. New environment 대화 상자 열기**

세션을 시작하기 전에 프롬프트 상자 아래의 환경 선택기를 열고 메뉴 하단에서 **New environment**를 선택합니다.

**2. 연결 추가**

**New environment** 대화 상자의 **SSH** 탭에서 **Host** 목록을 열고 \*\*Add SSH connection…\*\*을 선택한 다음 연결 세부 정보를 입력합니다.

* **Name**: 이 연결을 식별하기 위한 이름입니다.
* **SSH host**: `user@hostname` 또는 `~/.ssh/config`에 정의된 호스트입니다.
* **SSH port**: 비워 두면 기본값 22를 사용하거나 SSH 구성의 포트를 사용합니다.
* **SSH key (optional)**: `~/.ssh/id_ed25519` 같은 개인 키 경로입니다. SSH 구성이나 SSH 에이전트를 사용하려면 비워 둡니다.
* **Worktree folder**: 새 세션이 worktree를 만드는 원격 머신의 폴더입니다(예: `~/worktrees`). [원격 머신의 기본값](#choose-where-ssh-session-worktrees-go)을 사용하려면 비워 둡니다.

그런 다음 **Add SSH connection**을 선택합니다.

**3. 연결에서 세션 시작**

원격 머신의 폴더를 선택하고 **Create environment**를 클릭합니다. 머신과 폴더는 이후 세션을 위해 [저장된 환경](#create-a-saved-environment)으로 함께 유지됩니다. Desktop이 새 세션에 이 환경을 선택하므로, 작업을 입력하고 **Enter**를 누르십시오.

원격 머신은 Linux, macOS 또는 [Windows](#windows-remote-machines)를 실행할 수 있습니다. 데스크톱은 처음 연결할 때 원격 머신에 Claude Code를 자동으로 설치합니다. 연결되면 SSH 세션은 권한 모드, 커넥터, 플러그인 및 MCP 서버를 지원합니다.

#### SSH 세션의 원격 머신 요구 사항

Linux 또는 macOS 원격 머신에는 지원되는 프로세서, SFTP를 지원하는 SSH 서버, `noexec`로 마운트되지 않은 설치 폴더, 작동하는 셸, 네트워크 액세스가 필요합니다. 연결하기 전에, 또는 로그인한 후 연결이 실패할 때 각 요구 사항을 확인하세요:

* **시스템**: x86\_64 또는 arm64 프로세서. 머신은 Claude Code의 [시스템 요구 사항](https://code.claude.com/docs/ko/setup.md#system-requirements)도 충족해야 합니다. Linux에서 Claude Code에는 glibc 2.17 이상 또는 musl이 필요합니다. 머신에 어느 것이 있는지 확인하려면 해당 머신에서 `ldd --version`을 실행합니다. Alpine Linux와 같은 musl 기반 배포판에서는 [Claude Code에 필요한 패키지](https://code.claude.com/docs/ko/setup.md#alpine-linux-and-musl-based-distributions)도 설치합니다.
* **SFTP**: SSH 서버가 SFTP 하위 시스템을 제공해야 하며, 이는 `sshd_config`의 `Subsystem sftp` 줄로 켜집니다. 확인하려면 컴퓨터의 터미널에서 `sftp`로 동일한 호스트와 포트에 연결합니다. 정상적으로 작동하는 서버는 `sftp>` 프롬프트를 표시합니다.
* **서버의 `MaxSessions 1`**: `sshd_config`에서 `MaxSessions 1`을 설정한 서버에 연결하려면 다음 중 하나를 수행합니다:
  * **컴퓨터가 macOS 또는 Linux를 실행하는 경우**: Claude Desktop v3.1623.0 이상으로 업데이트합니다
  * **컴퓨터가 Windows를 실행하는 경우**: Desktop의 기본 제공 SSH 클라이언트는 해당 서버에 연결할 수 없으므로 Desktop이 [OpenSSH 클라이언트를 통해 연결](#use-your-ssh-configuration)하는지 확인합니다
  * **서버를 변경할 수 있는 경우**: `MaxSessions`를 예를 들어 OpenSSH의 기본값인 10으로 늘립니다
* **`MaxSessions 1`에서의 로그인**: SSH 에이전트가 보유한 키처럼 프롬프트 없이 작동하는 로그인을 사용합니다. Desktop은 연결하거나 다시 연결할 때마다 최소 두 번 로그인합니다. 각 [터미널](#run-commands-in-the-terminal) 탭마다, 그리고 `!`로 시작하는 명령을 실행하는 각 Desktop 세션마다 최소 한 번의 로그인이 추가됩니다. Claude가 실행하는 명령에는 추가 로그인이 없습니다.
* **`MaxSessions 1`에서의 일회용 코드**: 일회용 코드처럼 로그인할 때마다 확인을 요청하는 경우 `!` 명령이 실패합니다. 대신 자체 창에서 확인을 요청하는 터미널 탭에서 해당 명령을 실행하세요.
* **설치 폴더**: Desktop은 홈 디렉터리의 `~/.claude/remote/` 아래에 도우미 프로그램과 Claude Code를 설치합니다. 해당 위치에서 이를 실행하므로 이 폴더는 `noexec`로 마운트된 파일 시스템에 있으면 안 됩니다. 연결하는 각 사용자의 홈 디렉터리에 약 1 GB의 디스크 공간을 확보하세요. 이 폴더에 담긴 내용은 [원격 머신의 파일 및 프로세스](#files-and-processes-on-the-remote-machine)를 참조하세요.
* **셸**: 원격 머신에서 계정에 설정된 셸은 Bash, Zsh, `sh`처럼 SSH를 통해 전송된 명령을 실행할 수 있어야 합니다
* **네트워크**: Claude Code는 원격 머신에서 실행되며 네트워크 요청도 그곳에서 보내므로, 머신에는 [Claude Code에 필요한 네트워크 액세스](https://code.claude.com/docs/ko/network-config.md#network-access-requirements)가 있어야 합니다. 머신이 Claude Code를 다운로드할 수 없는 경우 Desktop이 컴퓨터에서 다운로드하여 업로드합니다. Claude Code의 다른 요청은 여전히 원격 머신에서 전송됩니다. Linux 원격 머신에서 이러한 요청에 프록시가 필요하다면 [SSH 세션에 프록시를 설정](#set-a-proxy-or-a-ca-certificate-for-ssh-sessions)하세요.

#### 원격 머신의 호스트 키 확인

호스트 키는 원격 머신이 자신이 어떤 머신인지 증명하기 위해 제시하는 키이며, 지문(fingerprint)은 그 키의 짧은 형태입니다. 키를 신뢰하면 컴퓨터가 키를 저장하고 다시 묻지 않고 그 키를 제시하는 대상에 연결합니다. 무언가가 연결을 가로채고 있을 수 있으므로 키를 신뢰하기 전에 확인하십시오.

먼저 지문이 표시된 위치를 보고 키가 어느 머신의 것인지 파악합니다.

* **Desktop이 `Connect to <host> for the first time?`을 묻거나 Review new key를 선택한 경우**: Desktop이 이름을 표시하는 머신 `<host>`
* **Desktop이 `Connect through <jump host> for the first time?`을 묻는 경우**: 점프 호스트, 즉 연결하려는 머신이 아니라 연결이 거쳐 가는 머신
* **터미널에서 `ssh`가 묻거나 경고하는 경우**: 메시지에 이름이 표시된 머신이며, 입력한 머신과 다를 수 있습니다

확인하려는 연결을 통하지 않고 해당 머신에서 직접 지문을 가져옵니다.

* **다른 사람이 머신을 관리하는 경우**: 관리자에게 호스트 키 지문을 요청합니다
* **직접 관리하며 Linux 또는 macOS를 실행하는 경우**: 머신의 콘솔에서 또는 이미 신뢰하는 연결을 통해 `ssh-keygen -lf /etc/ssh/ssh_host_<type>_key.pub`을 실행합니다. `<type>`에는 Desktop 또는 `ssh`가 지문 옆에 표시하는 키 유형을 소문자로 사용합니다: `ED25519` 또는 `ssh-ed25519`이면 `ed25519`.

그런 다음 머신의 지문을 표시된 지문과 비교합니다.

* **일치하는 경우**: 키를 신뢰합니다. Desktop에서 **Trust and connect** 또는 **Trust new key**를 선택하거나 터미널에서 `yes`로 답합니다.
* **다르거나 확인할 수 없는 경우**: 연결하지 마십시오. Desktop에서 **Cancel**을 선택하거나 터미널에서 `no`로 답합니다. 다른 사람이 머신을 관리한다면 표시된 지문을 알려 주십시오.

문제 해결 단계에서 이곳으로 왔다면 어느 결과든 해당 단계로 돌아가십시오.

#### SSH 세션에 프록시 또는 CA 인증서 설정

Linux 원격 머신이 프록시를 통해 인터넷에 연결하거나 CA 인증서가 필요한 경우, 해당 머신의 `~/.claude/settings.json`에 있는 `env` 아래에 [프록시 및 CA 변수](https://code.claude.com/docs/ko/network-config.md)를 추가합니다. 해당 머신의 `~/.profile`, `~/.bash_profile`, `~/.zprofile` 또는 `~/.zshrc`에서 이미 내보내고 있더라도 추가하세요.

SSH 세션에서 Claude Code는 해당 머신의 터미널에서 실행한 `claude`가 이러한 파일의 변수를 받는 경우에도 그 변수를 받지 않습니다. 그러면 세션이 멈추거나 **The connection from … to the API failed** 또는 **Authentication failed**가 표시될 수 있으며, 다시 로그인해도 도움이 되지 않습니다.

**1. 변수 추가**

CA 파일에는 [`NODE_EXTRA_CA_CERTS`](https://code.claude.com/docs/ko/network-config#custom-ca-certificates)를 사용하세요. Claude Code는 `~/.claude/settings.json`의 `SSL_CERT_FILE`에 있는 CA를 신뢰하지 않기 때문입니다. 다음 예제는 프록시와 CA 파일을 설정합니다:

```json ~/.claude/settings.json theme={null}
{
  "env": {
    "HTTPS_PROXY": "http://proxy.example.com:8080",
    "NODE_EXTRA_CA_CERTS": "/etc/ssl/certs/example-ca.pem"
  }
}
```

**2. 메시지 다시 보내기**

해당 파일에서 추가하거나 변경한 변수는 몇 초 내에 적용되므로 메시지를 다시 보내세요. 그래도 실패하면 새 세션을 시작하세요.

##### 원격 머신의 다른 곳에서 설정된 프록시 또는 CA 변수 찾기

Linux 원격 머신이 프록시 또는 CA 변수를 다른 곳에서 설정하는지 확인하세요. 세션은 그 값을 사용하고 [모든 설정 파일의 값을 무시](https://code.claude.com/docs/ko/settings-reference.md#how-env-values-interact-with-your-shell)하기 때문입니다:

**1. 원격 머신이 설정하는 변수 나열**

컴퓨터의 터미널에서 자신의 호스트로 `ssh devbox env`를 실행합니다.

**2. 변수가 설정된 곳에서 변경**

목록에 해당 변수가 있으면 원격 머신의 `~/.zshenv`, `/etc/environment`, `~/.bashrc`처럼 변수를 설정하는 파일에서 변경합니다.

**3. 세션에 새 값 적용**

원격 머신을 재시작하거나, [도우미 제거](#files-and-processes-on-the-remote-machine)의 처음 두 단계처럼 Desktop을 종료하고 도우미의 프로세스를 종료합니다. 어느 방법이든 Claude의 작업을 중단시키므로 실행 중인 작업이 없을 때 수행하세요.

#### SSH 구성 사용

Desktop이 컴퓨터의 OpenSSH 클라이언트를 통해 연결하는 경우 macOS, Linux, Windows에서 SSH 구성을 사용할 수 있습니다:

* **macOS 및 Linux**: Desktop은 컴퓨터에서 OpenSSH 클라이언트를 실행하여 연결하므로 `~/.ssh/config`를 사용합니다. OpenSSH 클라이언트를 통한 연결에는 Claude Desktop v1.37937.0 이상이 필요합니다.
* **Windows**: Desktop이 OpenSSH 클라이언트를 통해 연결하면 `%USERPROFILE%\.ssh\config`를 사용합니다. 서드 파티 제공업체가 아닌 Claude 계정을 사용하는 경우 OpenSSH 클라이언트를 통해 연결하려면 다음이 모두 필요합니다:

  * Claude Desktop v2.2553.0 이상. 버전을 확인하려면 [버전 확인](#check-your-version)을 참조하세요.
  * Microsoft의 OpenSSH 9.4 이상
  * 이 페이지 상단의 다운로드 버튼으로 설치한 Desktop. Microsoft Store의 Desktop은 OpenSSH 클라이언트를 통해 연결하지 않기 때문입니다

  이러한 요구 사항을 충족할 수 없거나 서드 파티 제공업체를 사용하는 경우 [OpenSSH 클라이언트 없이 Windows에서 연결](#connect-on-windows-without-the-openssh-client)을 참조하세요.

OpenSSH 클라이언트를 사용하는 경우 **SSH host** 필드에 구성 파일의 `Host` 이름을 입력합니다. 그러면 Desktop은 `HostName`, `User`, `IdentityFile`, `CertificateFile`, `ProxyJump`, `ProxyCommand` 등 해당 `Host` 항목의 설정을 사용합니다.

연결을 추가하기 전에 컴퓨터의 터미널에서 클라이언트와 항목을 확인하세요:

* **macOS 및 Linux의 클라이언트 버전**: `ssh -V`를 실행합니다. 클라이언트는 OpenSSH 7.6 이상이어야 합니다.
* **Windows의 클라이언트 버전**: Desktop은 먼저 `PATH`에 있는 `ssh`를 시도하므로 `ssh -V`를 실행합니다. 출력에 `OpenSSH_for_Windows_`와 9.4 이상이 표시되면 통과입니다. 통과하지 못하면 Desktop이 다음으로 시도하는 두 폴더를 확인합니다: `C:\Windows\System32\OpenSSH`에서 `.\ssh.exe -V`를 실행한 다음 `C:\Program Files\OpenSSH`에서 실행합니다.
* **Windows에서 통과하는 클라이언트가 없는 경우**: Windows에서 **OpenSSH Client** 선택적 기능을 추가하고 보류 중인 Windows 업데이트를 설치하거나, [Microsoft의 최신 빌드](https://learn.microsoft.com/en-us/troubleshoot/windows-server/system-management-components/upgrade-in-box-openssh-to-latest-openssh-release)를 설치합니다. 그런 다음 Desktop을 종료했다가 다시 엽니다. Desktop이 사용 가능한 OpenSSH 클라이언트를 찾았는지 확인하려면 [`ssh.log`](#get-desktops-logs-for-an-ssh-problem)에서 `Windows OpenSSH client:`와 버전, 또는 `no usable Windows OpenSSH client`를 찾습니다.
* **항목**: Windows에서는 버전 확인을 통과한 클라이언트를 사용합니다. `ssh devbox`처럼 `Host` 이름으로 `ssh`를 실행합니다. 실패하면 먼저 항목을 수정합니다.

**SSH port** 및 **SSH key (optional)** 필드는 비워 둘 수 있습니다. 값을 입력하면 Desktop은 이를 항목과 함께 사용합니다:

* **SSH port**: 여기에 입력한 값은 항목의 `Port`를 재정의합니다
* **SSH key (optional)**: OpenSSH 클라이언트를 사용하면 Desktop은 항목의 `IdentityFile` 및 SSH 에이전트의 키와 함께 선택한 키 파일도 제시합니다. Windows에서는 `ssh`가 PuTTY `.ppk` 파일을 읽지 않으므로 OpenSSH 형식의 키를 선택하세요.

##### OpenSSH 클라이언트 없이 Windows에서 연결

Windows에서 컴퓨터가 [OpenSSH 클라이언트 요구 사항](#use-your-ssh-configuration)을 충족하지 않으면 Desktop의 기본 제공 SSH 클라이언트를 통해 연결합니다. 서드 파티 제공업체를 사용하는 경우 기본적으로 기본 제공 클라이언트를 통해 연결하며, 관리자가 이를 변경할 수 있습니다. 해당 설정은 [3P의 Claude Desktop에서 SSH 원격 세션](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions)을 참조하세요.

기본 제공 클라이언트를 사용하는 경우에도 `PATH`에 `ssh` 명령이 있으면 **SSH host** 필드에 SSH 구성의 `Host` 이름을 입력할 수 있으며, 다음과 같은 제한이 있습니다:

* **항목의 설정**: Desktop은 `HostName`, `User`, `Port`, `IdentityFile`을 가져옵니다. `PATH`에 `sh` 셸이 있으면 `ProxyCommand`도 가져옵니다.
* **SSH key (optional)**: 여기서 선택한 키 파일은 `IdentityFile`을 대체하므로, 항목의 `IdentityFile`을 유지하려면 이 필드를 비워 둡니다
* **`CertificateFile` 및 `ProxyJump`**: Desktop은 `CertificateFile`을 무시하며, 항목에 `ProxyJump`가 설정되어 있으면 연결이 실패합니다. 두 설정 중 하나를 사용하려면 [OpenSSH 클라이언트를 통해 연결](#use-your-ssh-configuration)하세요.

##### 점프 호스트 뒤의 머신에 연결

bastion이라고도 하는 점프 호스트 뒤의 머신에 연결하려면 항목에 `ProxyJump` 또는 `ProxyCommand`를 설정합니다. 다음 항목은 `bastion.example.com`을 통해 `devbox.internal.example.com`에 연결합니다:

```text ~/.ssh/config theme={null}
Host devbox
  HostName devbox.internal.example.com
  User alice
  ProxyJump bastion.example.com
```

**SSH host** 필드에 `devbox`를 입력합니다.

관리자가 [SSH 호스트를 제한](#allow-jump-hosts)하는 경우 점프 호스트도 목록에 있어야 합니다. 사용자 컴퓨터의 터미널에서 `ssh -G bastion.example.com`을 실행하고, 출력되는 `hostname`을 허용해 달라고 관리자에게 요청하십시오.

##### 원격 머신의 컨테이너에 연결

SSH 포트를 게시하지 않는 컨테이너 안에서 세션을 실행하려면 `ProxyCommand`로 컨테이너에 연결하세요. Desktop은 연결하는 항목의 `RemoteCommand`를 실행하지 않기 때문입니다. 항목에서 `RemoteCommand`를 사용하여 컨테이너에 들어가는 경우, 세션은 컨테이너가 아니라 항목이 로그인하는 머신에서 실행됩니다.

**1. 항목 추가**

`~/.ssh/config`의 끝에, 또는 첫 번째 `Host *` 항목이 있다면 그 바로 위에 다음 항목을 추가합니다. Docker 컨테이너 `devbox`, 해당 사용자 `dev`, 머신 `build.example.com`을 자신의 값으로 바꿉니다. 이 항목의 명령은 연결할 때마다 컨테이너 안에서 SSH 서버를 시작합니다:

```text ~/.ssh/config theme={null}
Host devbox-container
  User dev
  ProxyCommand ssh build.example.com docker exec -i devbox /usr/sbin/sshd -i
```

**2. 컨테이너 준비**

* 이미지를 다시 빌드하거나 컨테이너를 다시 만들어도 동일하게 유지되는 호스트 키와 함께 OpenSSH 서버를 설치합니다
* `User`에 지정된 계정에 `authorized_keys` 파일과 같은 로그인 수단을 제공합니다
* 컨테이너가 [원격 머신 요구 사항](#remote-machine-requirements-for-ssh-sessions)을 충족하는지 확인합니다

**3. 허용 목록 확인**

관리자가 [SSH 호스트를 제한](#restrict-which-ssh-hosts-users-can-connect-to)하는 경우 컴퓨터의 터미널에서 `ssh -G devbox-container`를 실행합니다. 출력되는 `hostname`(여기서는 `devbox-container`)을 `sshHostAllowlist`에서 허용해 달라고 관리자에게 요청하세요. 관리자가 이 이름을 허용하면 항목의 `ProxyCommand`가 연결하는 대상도 무엇이든 허용됩니다.

**4. 항목을 테스트한 후 연결**

컴퓨터의 터미널에서 `ssh devbox-container`를 실행합니다. 보고되는 문제를 수정하고, 아무것도 묻지 않고 컨테이너에서 셸이 열릴 때까지 다시 실행합니다:

* **`ssh`가 비밀번호, 암호 문구 또는 코드를 요청하는 경우**: SSH 에이전트가 보유한 키처럼 프롬프트 없이 작동하는 로그인으로 전환합니다
* **`ssh`가 `Cannot execute command-line and remote command.` 또는 `Bad packet length`를 보고하는 경우**: `build.example.com`에 대한 항목에서 `RemoteCommand`와 `RequestTTY`를 제거합니다. 그러면 컴퓨터의 터미널에서 `ssh build.example.com`은 컨테이너가 아니라 해당 머신의 셸을 엽니다.
* **`ssh`가 `Connection closed by UNKNOWN port 65535`를 보고하는 경우**: 같은 터미널에서 `ssh build.example.com docker exec devbox /usr/sbin/sshd -t`를 실행합니다.
  * `Missing privilege separation directory: /run/sshd`가 출력되면 컨테이너에 해당 폴더를 만듭니다.
  * `no hostkeys available`가 출력되고 컨테이너에 호스트 키가 있다면, 이 명령과 항목에서 `exec` 뒤에 `-u root`를 추가합니다.

그런 다음 **SSH host** 필드에 `devbox-container`를 입력합니다.

##### `ProxyCommand`에서 셸의 변수 사용

macOS 및 Linux에서 `ProxyCommand` 또는 `Match exec` 명령에 자신의 환경 변수를 사용하려면 `~/.zshrc` 같은 셸 시작 파일에서 export합니다. 그런 다음 Desktop을 종료했다가 다시 엽니다. Desktop은 시작할 때 로그인 셸이 export하는 값을 읽고, 종료할 때까지 그 값을 유지합니다.

이 기능을 사용하려면 Claude Desktop v2.37337.0 이상과 `-0`을 허용하는 `env` 명령이 필요합니다. 컴퓨터의 터미널에서 `env -0`을 실행하여 확인할 수 있습니다.

> [!NOTE]
>
> 셸이 임시 AWS 자격 증명을 설정하는 경우 `AWS_*` 변수를 내보내는 대신 [AWS CLI에 프로필을 제공](#use-aws-credentials-in-a-proxycommand)하세요.

##### macOS 및 Linux에서 `ProxyCommand`에 AWS 자격 증명 사용

셸 시작 파일에서 임시 AWS 자격 증명을 설정하는 경우, AWS CLI를 실행하는 `ProxyCommand`가 터미널에서는 연결되지만 Desktop에서는 실패할 수 있습니다. 셸이 `AWS_SESSION_TOKEN`, `AWS_SECURITY_TOKEN` 또는 `AWS_CREDENTIAL_EXPIRATION`을 내보내면 Desktop의 `ssh`와 `ProxyCommand`는 셸의 AWS 자격 증명, `AWS_REGION`, `AWS_PROFILE`을 받지 못합니다.

AWS CLI에 리전이나 자격 증명을 얻을 다른 소스가 없으면 `You must specify a region` 또는 `Unable to locate credentials`와 함께 실패합니다. Desktop에서 연결하려면 AWS CLI가 `~/.aws/config`에서 읽는 프로필을 제공하세요:

**1. 리전과 자격 증명 소스가 있는 프로필 추가**

다음 예제는 도우미 프로그램에서 자격 증명을 가져오는 `corp`라는 프로필을 추가합니다:

```ini ~/.aws/config theme={null}
[profile corp]
region = us-east-1
credential_process = /full/path/to/your-credential-helper
```

* **`region`**: 연결하는 머신의 AWS 리전을 지정합니다
* **`credential_process`**: [AWS가 문서화한 JSON 형식](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sourcing-external.html)으로 자격 증명을 출력하는 프로그램의 전체 경로를 지정합니다. AWS CLI는 자리를 비운 동안의 재연결을 포함하여 연결할 때마다 이 프로그램을 실행하므로, 사용자 입력이 필요 없는 프로그램을 선택하세요.
* **IAM Identity Center**: `credential_process` 대신 프로필의 [IAM Identity Center 설정](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)을 추가합니다. 연결하기 전에, 그리고 해당 로그인이 만료되었을 때 다시 터미널에서 `aws sso login --profile corp`를 실행합니다.

**2. ProxyCommand에 프로필 지정**

다음 예제는 [AWS가 Session Manager용으로 문서화한 명령](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html)에 `--profile`을 추가합니다:

```text ~/.ssh/config theme={null}
Host i-*
  ProxyCommand sh -c "aws ssm start-session --profile corp --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

**3. 다시 연결**

터미널에서 호스트를 지정하여 `ssh`를 실행해 항목이 그곳에서 여전히 연결되는지 확인한 다음 Desktop에서 연결합니다.

##### SSH 연결 타임아웃 늘리기

SSH 구성에서 호스트에 `ConnectTimeout`을 설정하지 않은 경우 Desktop은 `ssh`에 연결 시간으로 30초를 줍니다. 점프 호스트나 `ProxyCommand`를 거치는 경우 이 시간에는 경로가 연결되는 데 걸리는 시간이 포함됩니다. 경로에 더 긴 시간이 필요하다면 항목에 더 높은 값을 추가합니다:

```text ~/.ssh/config theme={null}
Host devbox
  HostName devbox.internal.example.com
  User alice
  ProxyJump bastion.example.com
  ConnectTimeout 120
```

`ssh`는 호스트에 대해 처음 찾은 값을 사용하므로, 이 항목을 `ConnectTimeout`을 설정하는 `Host *` 항목보다 위에 두세요. 확인하려면 컴퓨터의 터미널에서 `ssh -G devbox`를 실행합니다. 출력에 `connecttimeout 120`이 포함됩니다. 값을 변경한 후에는 Desktop을 종료했다가 다시 엽니다.

원격 머신 자체가 휴대폰에서의 승인을 기다리는 경우, 설정한 `ConnectTimeout`과 관계없이 45초 이내에 승인하세요. Desktop이 `ServerAliveInterval`과 `ServerAliveCountMax`를 직접 설정하며, 그러면 `ssh`는 원격 머신이 그 시간 동안 아무것도 보내지 않는 로그인을 닫기 때문에 이 제한은 늘릴 수 없습니다. 대신 점프 호스트나 `ProxyCommand`가 사용자를 기다리는 경우에는 원격 머신 항목의 `ConnectTimeout`을 늘려 그 시간을 포함하세요.

##### Desktop에서만 적용되는 `Match host` 블록 수정

터미널의 `ssh devbox`가 사용하지 않는 설정을 Desktop이 사용한다면, 항목의 `HostName` 줄 위에 있는 `Match host` 블록을 찾아보세요. 터미널에서 `ssh`는 그 위치의 블록을 `HostName` 줄보다 먼저 읽으므로 블록을 `devbox`와 비교합니다. Desktop은 `ssh`에 명령줄로 `HostName` 값을 전달하므로 `ssh`는 블록을 그 값과 비교합니다.

확인하려면 Desktop처럼 항목의 `HostName` 및 `User` 값을 명령줄에 지정하여 컴퓨터의 터미널에서 `ssh -G`를 실행합니다:

```bash theme={null}
ssh -G -o HostName=devbox.internal.example.com -l alice devbox
```

출력을 `ssh -G devbox`의 출력과 비교합니다. `proxycommand`와 같은 블록의 설정이 첫 번째 출력에만 표시된다면 해당 블록은 Desktop에서만 적용됩니다. Desktop에서도 이 블록을 건너뛰게 하려면 `Match` 줄에 `!originalhost devbox`를 추가합니다:

```text ~/.ssh/config theme={null}
Match host *.internal.example.com !originalhost devbox
```

확인하려면 첫 번째 명령을 다시 실행합니다. 블록의 설정이 더 이상 출력에 표시되지 않습니다.

##### Desktop이 끄는 포워딩 설정

원격 머신에 대한 연결에서 Desktop은 SSH 구성이 `ForwardAgent`, `ForwardX11`, `LocalForward`, `RemoteForward`, `DynamicForward`, `Tunnel`을 켜더라도 이를 끈 상태로 둡니다. [터미널](#run-commands-in-the-terminal) 또는 `!` 명령에서는 Desktop이 이러한 설정을 따르는 별도의 `ssh`를 시작할 수 있으므로, 포워딩 설정이 [일부 경우에만](#limits-while-desktop-is-disconnected) 적용된다고 예상하세요.

* **원격 머신의 포트에 연결하려면**: [직접 포워딩합니다](#reach-a-port-on-the-remote-machine)
* **원격 머신에서 자신의 키를 사용하려면**: `git push`용 자격 증명처럼 원격 머신 자체에 자격 증명을 설정합니다

Desktop이 SSH 에이전트나 포트를 포워딩하지 않도록 하려면 컴퓨터의 터미널에서 `ssh -G devbox`를 실행합니다. 그런 다음 `ssh -G -o HostName=devbox.internal.example.com -l alice devbox`처럼, 출력된 `hostname` 및 `user` 값을 사용하여 Desktop이 실행할 수 있는 방식으로 다시 실행합니다. 두 번째 출력에는 첫 번째 출력에서 건너뛴 `Match` 블록의 설정이 표시될 수 있습니다.

두 출력에서 `no`가 아닌 값을 가진 `forwardagent` 줄과 `localforward`, `remoteforward`, `dynamicforward`로 시작하는 줄을 찾습니다. 찾으면 SSH 구성에서 해당 설정을 제거합니다. `ProxyCommand`가 `ssh`로 연결하는 호스트에 대해서도 동일하게 수행합니다.

#### 원격 머신의 포트에 연결

포트 3000의 개발 서버처럼 원격 머신에서 실행되는 서버를 열려면 포트를 직접 포워딩합니다. 컴퓨터의 터미널에서 `-L`과 연결하는 호스트(예: `devbox`)를 지정하여 `ssh`를 실행합니다:

```bash theme={null}
ssh -N -L 3000:localhost:3000 devbox
```

연결에 **SSH port** 또는 \*\*SSH key (optional)\*\*를 입력했다면 같은 값으로 `-p` 또는 `-i`를 추가합니다. 이 명령을 실행 상태로 두고 컴퓨터의 브라우저에서 `http://localhost:3000`을 열면 원격 머신의 포트 3000에 연결됩니다. `ssh`가 `open failed: administratively prohibited`를 출력하면 머신의 관리자에게 TCP 포워딩을 허용해 달라고 요청하세요. 이는 SSH 서버의 `sshd_config`에 있는 `AllowTcpForwarding`이 제어합니다.

#### Windows 원격 머신

Windows 원격 머신을 사용하려면 Claude Desktop v2.31226.0 이상이 필요합니다.

Microsoft의 OpenSSH Server를 사용하세요. 머신은 x64 또는 ARM64일 수 있습니다. SSH 서버가 시작하는 셸은 `cmd.exe`, Windows PowerShell 5.1 또는 Git Bash일 수 있습니다.

Windows 원격 머신은 Linux 원격 머신보다 테스트가 덜 이루어졌습니다. 이에 의존하기 전에 직접 작업을 시도해 보세요.

Windows 원격 머신에서는 특히 다음과 같은 제한이 있습니다:

* **터미널**: 폴더가 `C:/projects/app`과 같은 Windows 경로인 세션에서는 [터미널](#run-commands-in-the-terminal)이 열리지 않습니다
* **샌드박스**: Claude Code는 그곳에서 네이티브 Windows로 실행되며, 네이티브 Windows에서는 명령을 샌드박스 없이 실행합니다. [샌드박스가 실행되는 위치](https://code.claude.com/docs/ko/sandboxing.md)를 참조하세요.
* **플러그인**: Desktop은 `:`가 포함된 이름처럼 Windows가 저장할 수 없는 파일 또는 폴더 이름을 가진 플러그인을 복사하지 않습니다. 세션에는 Desktop이 제외한 플러그인이 나열됩니다.
* **MCP 서버**: 일부 Windows 원격 머신에서는 `claude_desktop_config.json`의 MCP 서버에 대한 Claude의 호출이 Desktop을 거치므로, [Desktop 연결이 끊긴 동안](#limits-while-desktop-is-disconnected) Claude가 해당 도구를 호출할 수 없습니다. Claude Desktop v2.37337.0 이전에는 모든 Windows 원격 머신에서 이 제한이 적용됩니다.
* **워크트리**: 워크트리는 `<project-root>/.claude/worktrees/`에 생성됩니다. [다른 폴더를 선택](#choose-where-ssh-session-worktrees-go)해도 Desktop은 이를 무시합니다.
* **이전 메시지**: SSH 서버의 셸이 `cmd.exe` 또는 Windows PowerShell인 경우 세션의 이전 메시지를 보려면 먼저 연결해야 할 수 있습니다
* **포크**: SSH 서버의 셸이 `cmd.exe` 또는 Windows PowerShell인 경우 세션은 첫 번째 메시지에서만 포크할 수 있습니다
* **연결이 끊긴 동안 실행**: 작업은 SSH 서버가 프로그램을 시작한 연결보다 프로그램이 오래 실행되도록 허용하는 경우에만 [Desktop 연결이 끊긴 동안 계속 실행](#keep-a-task-running-while-desktop-is-disconnected)됩니다. 확인하려면 [원격 머신을 테스트](#prepare-a-long-task)하세요.
* **남은 프로세스**: 세션이 끝난 후 Claude Code가 시작한 프로그램이 계속 실행될 수 있으므로 머신을 확인하세요. Desktop이 설치하는 [백그라운드 도우미](#keep-a-task-running-while-desktop-is-disconnected)는 그곳에서 자체적으로 중지되지 않습니다.

#### Desktop 연결이 끊긴 동안 작업 계속 실행

컴퓨터가 절전 모드로 전환되거나, 네트워크가 끊기거나, Desktop을 종료해도 작업은 완료되거나, 사용자의 입력이 필요하거나, [제한](#limits-while-desktop-is-disconnected) 중 하나에 도달할 때까지 계속 진행됩니다. 덮개를 닫는 것은 절전으로 간주됩니다. 업데이트를 위한 재시작을 포함하여 Desktop 또는 컴퓨터를 재시작하는 것은 종료로 간주됩니다.

Claude Code는 Desktop이 원격 머신에 설치하는 백그라운드 도우미 아래에서 프로세스로 실행되므로, 계속 실행되는 데 SSH 연결이 필요하지 않습니다. 이 섹션의 동작을 사용하려면 Claude Desktop v2.31226.0 이상이 필요합니다.

> [!WARNING]
>
> Claude 계정으로 Desktop에 로그인하는 경우 작업이 밤새 실행될 것으로 기대하지 마세요. Desktop은 Desktop이 실행 중이고 연결되어 있는 동안에만 작업의 로그인을 갱신하므로, 연결이 끊긴 후 작업의 로그인이 만료될 수 있으며 그러면 작업이 중지됩니다. 연결이 끊길 때 남아 있는 시간은 상황에 따라 다르며, 단 몇 분일 수도 있습니다.
>
> 지금까지 수행한 작업은 원격 머신에 남아 있으며, 돌아와서 메시지를 보내 계속할 수 있습니다.
>
> 작업을 밤새 실행해야 하는 경우:
>
> * 덮개를 열고 Desktop을 실행한 상태로 [컴퓨터를 깨어 있는 상태](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md#how-scheduled-tasks-run)와 온라인 상태로 유지하세요
> * 원격 머신과 경로상의 모든 점프 호스트에 대해 SSH 에이전트가 보유한 키처럼 프롬프트 없이 작동하는 로그인을 사용하세요. 그러면 연결이 끊겼을 때 Desktop이 자동으로 다시 연결할 수 있습니다.
>
> 컴퓨터가 절전 상태이거나 꺼져 있는 동안 실행되어야 하는 작업이라면 대신 [클라우드 세션](#run-long-running-tasks-in-the-cloud)을 시작하세요.

* **절전 또는 네트워크 끊김 후**: 프로세스가 [여전히 실행 중](#limits-while-desktop-is-disconnected)이고 Desktop이 프롬프트 없이 로그인할 수 있으면 실행 중인 작업을 되찾을 수 있습니다. 그렇지 않으면 [메시지를 보내세요](#reconnect-after-sleep-or-a-network-loss).
* **종료 후**: 작업은 계속 실행되지만, Desktop이 해당 프로세스에 다시 연결할 수 없으면 세션이 다시 열릴 때 작업을 잃습니다. 종료하기 전에 [Desktop이 다시 연결할 수 있는 경우](#reopen-a-session-after-you-quit-desktop)를 확인합니다. 작업을 잃었다면 메시지를 보내 계속합니다.

돌아왔을 때 작업이 완료되지 않았다면 Desktop이 다시 연결할 수 없다는 안내, 인증 오류 또는 대기 중인 요청이 있는지 확인하세요:

* **Desktop이 다시 연결할 수 없음**: 세션에 이유가 표시되며, 알림에도 표시될 수 있습니다. Desktop에서 [로그인이 필요](#reconnect-after-sleep-or-a-network-loss)할 수 있습니다.
* **인증 오류**: [로그인 토큰 또는 자격 증명](#limits-while-desktop-is-disconnected)이 만료되었을 수 있습니다. Claude 계정을 사용하는 경우 메시지를 보내 계속하세요. 타사 제공업체를 사용하는 경우 [SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions)를 참조하세요.
* **대기 중인 요청**: [요청에 응답합니다](#handle-requests-that-arrive-while-you-are-away)
* **해당 사항 없음**: 메시지를 보내 계속합니다

##### 긴 작업 준비

* **먼저 업데이트**: 긴 작업을 시작하기 전에 Desktop을 업데이트합니다. macOS 및 Windows에서 Desktop은 다운로드한 업데이트를 설치하기 위해 자동으로 다시 시작할 수 있습니다. 이 재시작은 Claude가 SSH 작업을 수행하는 동안 대기합니다. 기본적으로 업데이트가 72시간 동안 대기한 후에는 Desktop이 [이후 작업에 다시 연결](#reopen-a-session-after-you-quit-desktop)할 수 있는 경우 작업 중에도 재시작이 진행될 수 있습니다.
* **종료 전 확인**: 일부 Desktop 업데이트 후처럼 종료나 재시작 후 실행 중인 작업을 항상 다시 가져올 수 있는 것은 아닙니다. 해당 경우는 [Desktop 종료 후 세션 다시 열기](#reopen-a-session-after-you-quit-desktop)를 참조하세요.
* **이전 버전에서는 Desktop을 열어 두기**: v3.1623.0 이전 Claude Desktop을 사용하는 Windows에서는 Desktop이 종료되거나 다시 시작된 후 실행 중인 작업을 다시 가져올 수 없습니다. v2.42304.0 이전 버전의 macOS 또는 Linux에서 서드 파티 제공업체를 사용하는 경우에도 마찬가지입니다. 두 경우 모두 작업 중에는 Desktop을 열어 두세요. 버전을 확인하려면 [버전 확인](#check-your-version)을 참조하세요.
* **요청 줄이기**: [작업이 사용자를 기다리는 빈도를 줄이는](#handle-requests-that-arrive-while-you-are-away) 권한 모드, 규칙 또는 훅을 선택하세요
* **점프 호스트 확인**: 점프 호스트가 휴대폰 푸시와 같은 로그인을 요구하는 경우 프롬프트 없이 작동하는 로그인으로 전환하세요. 그렇지 않으면 Desktop이 다시 연결을 시도할 때마다 푸시를 다시 보낼 수 있습니다.
* **원격 머신 테스트**: 짧은 작업을 시작하고, 작업이 아직 실행 중일 때 Desktop을 종료한 다음, 작업이 완료되었어야 할 시점이 충분히 지난 후 세션을 다시 엽니다. 작업이 완료되지 않았고 세션에 인증 오류가 표시되지 않으면 원격 머신에서 [작업을 종료시킬 수 있는 요인](#limits-while-desktop-is-disconnected)을 확인하세요.
* **Desktop 터미널에서 명령 실행하지 않기**: 원격 머신이 [유휴 터미널을 로그아웃](#limits-while-desktop-is-disconnected)시키는 경우 Desktop 외부의 SSH 로그인에서 직접 명령을 실행하세요

##### Desktop 연결이 끊긴 동안의 제한

실행 중인 상태로 둔 작업은 로그인이 만료되거나, 원격 머신이 작업을 종료하거나, 도우미가 중지되거나 교체될 때 종료될 수 있습니다:

* **로그인 토큰 또는 자격 증명**: Claude 계정을 사용하는 경우 토큰이 만료되면 작업이 인증 오류와 함께 중지됩니다. 타사 제공업체를 사용하는 경우 싱글 사인온이나 자격 증명 도우미에서 받은 자격 증명처럼 만료되는 자격 증명에도 동일하게 적용됩니다. [SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions)를 참조하세요. Claude 계정을 사용하는 경우 Desktop이 로그인을 갱신할 수 있도록 [Desktop을 실행하고 연결된 상태로 유지](#keep-a-task-running-while-desktop-is-disconnected)하세요.
* **원격 머신**: 원격 머신이 재시작되거나, SSH 연결이 닫힐 때 프로세스를 종료하면 실행 중인 작업이 종료됩니다. Desktop 연결이 끊긴 동안에는 아무것도 이를 다시 시작하지 않습니다. systemd-logind의 `KillUserProcesses`가 `yes`이고 사용자에게 적용되는 Linux 머신은 이런 방식으로 프로세스를 종료합니다. 그곳에서 작업을 계속 실행하려면 관리자에게 `KillExcludeUsers` 등으로 사용자를 예외 처리해 달라고 요청하세요.
* **유휴 터미널**: 일부 Linux 원격 머신은 일정 시간 동안 아무도 입력하지 않은 터미널을 로그아웃시킵니다(systemd-logind의 `StopIdleSessionSec`). macOS 또는 Linux의 Desktop에서는 세션의 [터미널](#run-commands-in-the-terminal)과 `!` 명령이 기본적으로 Desktop의 SSH 연결을 공유합니다. 그러면 이 로그아웃이 Desktop이 연결되어 있는 동안 연결을 종료하며, 실행 중인 작업도 함께 종료될 수 있습니다. 터미널 창을 닫아도 이를 막을 수 없으므로 [해당 터미널에서 명령을 실행하지 마세요](#prepare-a-long-task).
* **Desktop 업데이트**: 업데이트에 새 도우미가 포함된 경우 Desktop은 이후 연결 시 원격 머신의 도우미를 교체하며, 이로 인해 아직 실행 중인 작업이 종료될 수 있습니다
* **장기간 부재**: Linux 또는 macOS 원격 머신에서 Desktop이 30일 동안 연결하지 않으면 도우미가 중지되고 그 아래에서 실행되는 모든 Claude Code 프로세스가 종료됩니다. 그 전에 연결하세요.

Desktop 연결이 끊긴 동안에는 파일 편집 및 일부 도구가 실패할 수 있습니다. 작업에 이들이 필요하다면 Desktop을 연결된 상태로 유지하세요:

* **Worktree**: [worktree](#run-a-session-in-its-own-worktree)를 사용하는 세션에서 Desktop은 Claude가 각 파일을 편집하기 전에 이를 확인합니다. Desktop 연결이 끊긴 동안 각 편집은 약 30초간 대기한 후 실패합니다. 셸 명령은 계속 실행됩니다. Linux 또는 macOS 원격 머신에서는 [편집이 계속 작동할 수 있습니다](#worktree-edits-while-disconnected). 확실하지 않다면 worktree 없이 세션을 시작하십시오.
* **폴더 제한**: 조직에서 세션이 사용할 수 있는 폴더를 제한하는 경우 Desktop은 워크트리 여부와 관계없이 각 파일 읽기, 검색, 편집을 확인합니다. Desktop 연결이 끊긴 동안에는 각 작업이 최대 10분간 대기한 후 실패합니다.
* **커넥터**: [커넥터](#connect-external-tools) 및 Desktop이 제공하는 기타 도구는 Desktop을 통해 실행되므로, 연결이 끊긴 동안에는 각 호출이 약 30초 후에 실패합니다
* **워크플로**: Desktop은 각 새 [워크플로](https://code.claude.com/docs/ko/workflows.md)가 시작되기 전에 이를 확인하므로, Desktop 연결이 끊긴 동안에는 새 워크플로가 최대 10분간 대기한 후 실패합니다
* **MCP 서버**: Claude Code가 원격 머신에서 시작하는 MCP 서버는 Desktop을 거치지 않으므로 Claude가 해당 도구를 계속 호출할 수 있습니다. `claude_desktop_config.json`의 서버는 Desktop이 [기본 제공 SSH 클라이언트](#worktree-edits-while-disconnected)를 사용하지 않는 경우에만 여기에 포함됩니다. 그렇지 않은 경우와 [일부 Windows 원격 머신](#windows-remote-machines)에서는 Desktop 연결이 끊긴 동안 Claude가 해당 도구를 호출할 수 없습니다.

> [accordion] 워크트리의 편집이 계속 작동하는 경우
>
> Linux 또는 macOS 원격 머신에서는 확인이 Desktop을 거치지 않으므로, Desktop 연결이 끊긴 동안에도 워크트리 내부의 편집이 계속 작동합니다. Claude Desktop v2.37337.0 이전에는 Linux 원격 머신에서만 해당됩니다.
>
> 다음을 포함한 일부 경우에는 여전히 편집이 실패합니다:
>
> * **기본 제공 SSH 클라이언트**: Desktop이 이를 사용하는 경우. 예를 들어 Microsoft Store 설치, Microsoft의 OpenSSH 9.4 이상이 없는 Windows 컴퓨터, 또는 타사 제공업체를 사용하는 Windows의 기본 동작
> * **저장소 위치**: 저장소가 홈 디렉터리, 그 상위 폴더 또는 `~/.claude`인 경우
> * **macOS 경로**: macOS 원격 머신에서 저장소가 `/Volumes` 아래에 있거나, 저장소 또는 워크트리 경로의 폴더 이름에 `~` 또는 비ASCII 문자가 포함된 경우
> * **폴더 제한**: 조직에서 세션이 사용할 수 있는 폴더를 제한하는 경우
> * **회사 런처**: Claude Desktop v2.37337.0 이전에서 Claude 계정으로 로그인하고, 조직이 [회사 런처](https://code.claude.com/docs/ko/corporate-launcher.md)를 통해 원격 머신에서 Claude Code를 시작하는 경우
>
> 워크트리가 없는 세션에는 조직에서 세션이 사용할 수 있는 폴더를 제한하지 않는 한 이러한 확인이 없습니다.

##### 부재 중에 도착하는 요청 처리

Desktop 연결이 끊긴 동안 Claude가 승인을 필요로 하거나 질문을 하면 Claude는 원격 머신에서 대기합니다. 대기 자체에는 시간 제한이 없습니다. Desktop이 프로세스에 다시 합류하면 요청을 표시합니다. 대신 Desktop이 새 프로세스를 시작하면 요청을 잃게 됩니다.

돌아왔을 때 대기 중이던 요청이 사라졌다면, 한 가지 원인은 업데이트 설치 등을 위해 Desktop이 자동으로 다시 시작된 것입니다. 재시작 후에도 요청이 유지되는 것은 Desktop이 프로세스에 다시 연결할 수 있는 경우뿐이므로, 작업을 실행 상태로 두기 전에 [Desktop이 다시 연결할 수 있는 경우](#reopen-a-session-after-you-quit-desktop)를 확인합니다.

요청을 잃은 경우 메시지를 보내 계속하세요.

작업이 사용자를 기다리기 위해 멈추는 빈도를 줄이고 부재 중에도 작업 소식을 받으려면, 자리를 비우기 전에 다음 중 하나를 설정하세요:

* **자동 모드**: [사용할 수 있는 경우](#auto-mode-availability) [자동 모드](#choose-a-permission-mode)를 선택합니다. 반복적으로 차단되면 [다시 확인을 요청받습니다](https://code.claude.com/docs/ko/permission-modes.md#when-auto-mode-falls-back).
* **허용 규칙**: 원격 머신의 사용자 설정 파일인 `~/.claude/settings.json`에 작업에 필요한 명령에 대한 [허용 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)을 추가합니다. 조직이 [관리형 설정의 권한 규칙만 허용](https://code.claude.com/docs/ko/settings-reference.md#allowmanagedpermissionrulesonly)하는 경우 관리자에게 원격 머신에 적용되는 [관리형 설정](#managed-settings)에 이를 추가해 달라고 요청하세요. 프로젝트의 `.claude/settings.json`에 있는 허용 규칙은 [프로젝트 허용 규칙 및 워크스페이스 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)를 참조하세요.
* **응답하는 훅**: 원격 머신의 `~/.claude/settings.json`에 [`PermissionRequest` 훅](https://code.claude.com/docs/ko/hooks#permissionrequest)을 구성하여 사용자 대신 요청을 허용하거나 거부합니다
* **알림을 보내는 훅**: 같은 파일에 `permission_prompt` matcher와 함께 [`Notification` 훅](https://code.claude.com/docs/ko/hooks#notification)을 구성하여 요청이 대기 중일 때 자신에게 메시지를 보냅니다
* **Claude가 완료되면 알려 주는 훅**: 같은 파일에 [`Stop` 훅](https://code.claude.com/docs/ko/hooks#stop)을 구성하여 Claude가 응답을 마쳤을 때 자신에게 메시지를 보냅니다. API 오류로 턴이 끝나면 실행되지 않습니다. 이 경우에는 [`StopFailure` 훅](https://code.claude.com/docs/ko/hooks#stopfailure)을 구성하세요.

조직이 [관리형 훅만 실행](https://code.claude.com/docs/ko/settings-reference.md#allowmanagedhooksonly)하는 경우 관리자에게 원격 머신에 적용되는 [관리형 설정](#managed-settings)에 훅을 추가해 달라고 요청하세요.

Claude Code는 Bypass permissions를 포함한 어떤 권한 모드에서도 [일부 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)을 자동 승인하지 않습니다. 권한 모드에 따라 Claude Code는 이러한 작업을 거부하거나 사용자에게 묻고, 그러면 작업은 사용자의 응답을 기다립니다.

##### 절전 또는 네트워크 끊김 후 다시 연결

돌아왔을 때 Desktop이 다시 연결되지 않았다면 세션에서 메시지를 보내세요. Desktop은 SSH 에이전트가 보유한 키처럼 프롬프트 없이 로그인할 수 있는 경우에만 자동으로 다시 연결합니다.

* **저장된 비밀번호**: Desktop이 기억하도록 허용한 비밀번호도 프롬프트 없이 작동하지만, 장기간 자리를 비우는 경우에는 SSH 에이전트가 보유한 키를 사용하는 것이 좋습니다. 해당 비밀번호로 로그인이 중단되거나 멈추면 Desktop은 다시 연결을 중단하고 사용자를 기다릴 수 있습니다.
* **기타 프롬프트**: 원격 머신이 일회용 코드와 같은 다른 항목을 요청하면 컴퓨터에서 알림을 받을 수 있습니다. 알림을 클릭하거나 세션에서 메시지를 보내면 Desktop이 프롬프트를 표시합니다.

> [accordion] 점프 호스트가 로그인을 요청하거나, 중단이 길거나, 출력이 누락되었거나, 프로세스가 사라진 경우
>
> * **점프 호스트, 부재 중 푸시 중지**: macOS 또는 Linux의 Desktop에서 휴대폰 푸시와 같은 점프 호스트의 로그인 요청에 아무도 응답하지 않을 때 발생할 수 있습니다. 그러면 Desktop은 컴퓨터 앞에 아무도 없는 동안 다시 연결을 중단합니다. 컴퓨터 잠금을 해제하거나 컴퓨터를 사용하면 Desktop이 다시 시도할 수 있으므로 푸시를 다시 받을 수 있습니다. 응답 없는 시도가 세 번 이어지면 사용자가 재시도하거나 메시지를 보낼 때까지 기다립니다.
> * **점프 호스트, 푸시가 계속 옴**: Windows의 Desktop처럼 아무도 응답하지 않는다는 것을 Desktop이 알 수 없는 경우, 다시 합류할 프로세스가 있는 동안에는 해당 프로세스가 여전히 실행 중인지와 관계없이 계속 시도합니다. 시도할 때마다 푸시를 다시 받을 수 있습니다. 시도를 끝내려면 Desktop을 종료하세요. 단, 이로 인해 [실행 중인 작업을 잃을 수 있습니다](#reopen-a-session-after-you-quit-desktop).
> * **긴 중단**: Desktop은 약 5분마다 한 번 시도하도록 속도를 늦춥니다. 더 빨리 다시 연결하려면 세션에서 재시도하거나 메시지를 보내세요. 메시지는 Desktop이 연결되면 전달됩니다.
> * **누락된 출력**: Desktop 연결이 끊긴 동안 도우미는 각 세션의 가장 최근 Claude Code 출력을 16 MiB 버퍼에 보관하고 오래된 출력은 삭제합니다. Desktop이 다시 연결된 후 세션에 `Loading recent output from <host>…`가 표시될 수 있습니다. Desktop이 모든 출력을 불러올 수 없으면 `Some output produced while you were disconnected may be missing here.` 행이 표시됩니다. 이 행은 작업이 중지되었다는 의미가 아닙니다.
> * **프로세스 사라짐**: 원격 머신이 다시 시작되는 경우처럼 Desktop 연결이 끊긴 동안 프로세스가 끝난 것입니다. 그러면 Desktop은 대화의 저장된 기록에서 새 프로세스를 시작하고 Claude에게 작업을 계속하도록 지시할 수 있습니다. 작업이 계속 중지된 상태이면 메시지를 보냅니다. 타사 제공업체를 사용하는 경우 Claude Desktop v2.42304.0 이상으로 업데이트합니다. 이전 버전은 작업을 자동으로 계속하지 않기 때문입니다.

##### Desktop 종료 후 세션 다시 열기

Desktop을 종료한 후에도 작업은 원격 머신에서 계속 실행되지만, Desktop이 해당 프로세스에 다시 연결할 수 없으면 세션이 다시 열릴 때 중지됩니다. Desktop이 닫혀 있는 동안 작업은 완료되거나, 사용자의 응답이 필요하거나, [제한](#limits-while-desktop-is-disconnected) 중 하나에 도달할 때까지 실행됩니다.

* **Windows의 Desktop, v3.1623.0 이전 버전에서 시작한 작업**: 그 이후 Desktop이 업데이트되었더라도 작업을 다시 가져올 수 없습니다. Desktop이 시작될 때 세션이 열릴 수 있고 세션이 열리면 작업이 중지되므로, 작업이 완료되었을 것으로 예상될 때만 Desktop을 다시 시작하세요. 어떤 버전에서 작업을 시작했는지 모르는 경우에도 작업이 완료되었을 것으로 예상될 때까지 기다리세요.
* **macOS 또는 Linux의 서드 파티 제공업체, v2.42304.0 이전 버전에서 시작한 작업**: 작업을 다시 가져올 수 없습니다. 작업이 완료되었을 것으로 예상될 때만 Desktop을 다시 시작하세요.
* **기타 모든 작업**: Desktop을 시작하고 세션을 열면 Desktop이 다시 연결되는 경우 작업이 계속됩니다. 일부 Desktop 업데이트 후처럼 항상 다시 연결할 수 있는 것은 아니므로 [긴 작업 전에 업데이트](#prepare-a-long-task)하세요.

작업이 중지되면 Desktop이 새 프로세스를 시작하는 동안 세션에 `Restarting Claude Code on <host>…`가 표시될 수 있습니다. 대기 중이던 승인이나 질문도 잃게 됩니다. Claude가 자동으로 계속하지 않으면 메시지를 보내세요. 그러면 Claude가 대화의 저장된 기록에서 계속합니다.

타사 배포의 경우 [SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions)를 참조하세요.

> [!WARNING]
>
> 대화의 Claude Code 프로세스가 아직 실행 중인 동안에는 원격 머신에서 해당 대화에 대해 [`claude --resume`](https://code.claude.com/docs/ko/cli-reference#cli-flags)을 실행하지 마세요. Claude Code는 이를 막지 않으며, 그러면 두 프로세스가 같은 대화에 기록합니다. 확실하지 않다면 대화의 사본에서 계속하는 `--fork-session`을 추가하세요. 단, 두 프로세스는 여전히 같은 파일에서 작업합니다.

#### SSH 세션 워크트리 위치 선택

조직에서 세션이 사용할 수 있는 폴더를 제한하지 않는 한, 새 SSH 세션은 다음 위치 중 설정된 첫 번째 위치에 [worktree](#run-a-session-in-its-own-worktree)를 만듭니다.

1. SSH 연결의 **Worktree folder**
2. 원격 머신의 `~/.claude/settings.json`에 있는 [`worktree.location`](https://code.claude.com/docs/ko/settings-reference#worktree-location)
3. 기본값인 `<project-root>/.claude/worktrees/`

각 프로젝트는 설정한 폴더 안에 자체 하위 폴더를 가지므로, `~/worktrees`를 사용하면 워크트리 경로는 `~/worktrees/<project>-<id>/<worktree-name>`이 됩니다. 설정한 폴더가 프로젝트 내부에 있으면 Desktop은 해당 프로젝트에 대해 이를 무시하고 기본값을 사용합니다. [Windows 원격 머신](#windows-remote-machines)에서는 Desktop이 항상 기본값을 사용합니다.

##### 기존 연결에서 worktree 폴더 설정

이전에 추가한 연결이나 조직에서 관리하는 연결의 설정에서 **Worktree folder**를 설정합니다. 이 필드에는 Claude Desktop v1.44121.0 이상이 필요합니다. 조직에서 세션이 사용할 수 있는 폴더를 제한하는 경우 Desktop은 이 필드를 숨기고 worktree를 프로젝트 내부에 둡니다.

**1. 연결 찾기**

[환경 선택기](#start-a-session)를 열고 **SSH** 아래에서 연결을 찾습니다.

**2. 연결 설정 열기**

연결 위에 마우스를 올리고 톱니바퀴 아이콘을 클릭합니다. 열린 대화 상자에서 **Host** 옆에 \*\*Edit connection…\*\*이 표시되면 \*\*Edit connection…\*\*을 선택합니다.

**3. 폴더 설정**

**Worktree folder**에 원격 머신의 폴더(예: `~/worktrees`)를 입력하고 **Save changes**를 선택합니다.

#### 원격 머신의 파일 및 프로세스

Desktop은 Linux 또는 macOS 원격 머신에 연결하는 각 사용자의 홈 디렉터리에 있는 `~/.claude/remote/` 아래에 도우미 프로그램과 Claude Code를 설치합니다. 도우미는 어떤 네트워크 포트에서도 수신 대기하지 않지만, Claude Code와 Claude Code가 시작하는 MCP 서버 및 개발 서버와 같은 프로그램은 수신 대기할 수 있습니다.

| 폴더 | 내용 |
| - | - |
| `~/.claude/remote/srv/` | 도우미. 버전마다 하나의 폴더 |
| `~/.claude/remote/ccd-cli/` | Claude Code. 버전마다 하나의 파일 |
| `~/.claude/remote/run/` | 소켓 및 로그와 같은 도우미의 런타임 파일. 연결하는 컴퓨터마다 하나의 폴더 |
| `~/.claude/remote/plugins/` | Desktop이 사용자의 컴퓨터에서 복사하는 플러그인 |
| [`~/.claude/uploads/`](https://code.claude.com/docs/ko/claude-directory#clear-local-data) | 사용자가 메시지에 첨부하는 파일. 세션마다 하나의 폴더 |

한 사용자의 프로세스를 나열하려면 원격 머신에서 해당 사용자로 `pgrep -fl "$HOME/.claude/remote/"`를 실행하거나, `$HOME` 대신 해당 사용자의 홈 디렉터리를 넣어 실행합니다:

* **도우미**: 연결하는 각 컴퓨터에 대해 하나 이상의 `server` 프로세스
* **Claude Code**: 도우미가 사용자의 세션을 위해 시작하는 프로세스로, 각각 `2.1.295-…`와 같이 버전 이름을 딴 파일에서 실행됩니다

Desktop은 사용자의 SSH 연결을 통해 `~/.claude/remote/run/` 아래 도우미 폴더에 있는 Unix 소켓 `rpc.sock`으로 도우미에 접근합니다. 소켓의 모드는 600이고 해당 폴더의 모드는 700이므로, root를 제외한 머신의 다른 사용자는 이 소켓에 연결할 수 없습니다.

도우미가 자체적으로 중지되는 경우는 [Desktop 연결이 끊긴 동안의 제한](#limits-while-desktop-is-disconnected)을 참조하세요.

한 사용자에 대해 도우미와 Claude Code를 제거하려면:

**1. Desktop 종료**

사용자가 연결하는 각 컴퓨터에서 Desktop을 종료합니다. Desktop은 다음에 연결할 때 두 프로그램을 다시 설치하며, 자동으로 다시 연결할 수 있습니다.

**2. 프로세스 종료**

원격 머신에 해당 사용자로 로그인한 상태에서 [`pgrep`](#files-and-processes-on-the-remote-machine)이 나열하는 각 Claude Code 프로세스의 ID로 `kill`을 실행합니다. 목록에서 이 프로세스들이 사라지면 각 `server` 프로세스의 ID로 `kill`을 실행합니다. `server` 프로세스를 먼저 종료하면 Claude Code가 실행 중인 명령이 계속 실행될 수 있습니다.

그런 다음 `ps -u "$(id -un)" -f` 등으로 사용자의 나머지 프로세스를 나열하고, Claude Code가 시작한 것으로 확인되는 프로세스를 종료합니다. Claude Code가 백그라운드에 남겨 둔 프로그램은 Claude Code가 종료된 후에도 `pgrep` 목록에 나타나지 않은 채 계속 실행될 수 있습니다.

**3. 폴더 삭제**

`~/.claude/remote/`를 삭제합니다. `~/.claude/` 및 `~/.claude.json`에 있는 Claude Code 자체 파일을 제거하려면 [설정 파일 제거](https://code.claude.com/docs/ko/setup.md#remove-configuration-files)를 참조하세요.

##### 한 세션의 프로세스 종료

한 세션의 Claude Code 프로세스를 종료하려면, Desktop이 원격 머신에 연결되어 있는 동안 Desktop에서 [세션을 보관](#archive-a-session)합니다. 프로세스는 작업이 완료된 후에도, Desktop을 종료한 후에도 계속 실행됩니다.

worktree에 커밋되지 않은 변경 사항이 있는 세션을 보관하기 전에 [세션 보관 시 커밋되지 않은 변경 사항 유지](#keep-uncommitted-changes-when-a-session-is-archived)를 참조하십시오.

##### 프로세스가 실행되는 사용자 확인

도우미와 Claude Code는 Desktop이 SSH로 로그인하는 사용자로 실행됩니다. 이를 설치하고 시작하는 데 `sudo`는 필요하지 않습니다. 사용자를 확인하려면 원격 머신에서 [`pgrep`](#files-and-processes-on-the-remote-machine)이 나열하는 프로세스 ID로 `ps -o user= -p`를 실행합니다.

셸 명령 및 MCP 서버와 같이 Claude Code가 시작하는 프로그램도 해당 사용자로 시작됩니다. 원격 머신에서 명령을 실행하는 사람에게 하듯이, `sudo` 규칙을 포함하여 해당 사용자의 권한을 검토하세요.

##### 원격 머신에 연결한 사용자 확인

원격 머신에 누가 연결했는지 확인하려면 해당 머신에서 SSH 서버의 로그를 읽습니다. 로그에서 Desktop의 로그인은 터미널의 로그인과 같은 형태로 표시됩니다. macOS 또는 Linux의 Desktop에서는 세션마다가 아니라 Desktop이 연결할 때마다 항목이 하나씩 기록됩니다.

서버에 `MaxSessions 1`이 설정되어 있으면 Desktop이 연결하거나 다시 연결할 때마다 최소 두 개의 항목이 기록됩니다. 또한 터미널 탭마다, 그리고 `!`로 시작하는 명령을 실행하는 Desktop 세션마다 최소 하나의 항목이 추가로 기록됩니다.

Claude Code의 [메트릭 및 이벤트](https://code.claude.com/docs/ko/monitoring-usage.md#available-metrics-and-events)에서는 Desktop의 SSH 연결을 찾을 수 없습니다. 이를 통해 SSH 세션이 어느 원격 머신에서 실행되었는지 확인하려면 [Desktop SSH 세션에 텔레메트리 귀속](https://code.claude.com/docs/ko/monitoring-usage.md#attribute-telemetry-to-desktop-ssh-sessions)을 참조하십시오. Desktop 자체의 연결 기록은 [SSH 문제에 대한 Desktop 로그 가져오기](#get-desktops-logs-for-an-ssh-problem)를 참조하십시오.

#### 로그인 전에 닫히는 연결

SSH 서버 로그에 로그인 전에 닫히는 연결이 표시된다면, 이는 Desktop의 SSH 포트 테스트일 수 있습니다. Desktop은 머신에 대한 연결이 실패한 후 등에 머신이 응답하는지 테스트합니다. 포트에 연결을 열고 아무것도 보내지 않은 채 즉시 닫습니다. 한 번의 테스트 또는 연속된 여러 번의 테스트가 있을 수 있습니다(예: 약 2분 동안 8번).

이러한 연결에 대해 주소를 차단하거나 거부하는 것이 없다면 Desktop의 테스트에 대해 아무것도 할 필요가 없습니다. Desktop이 연결하는 주소가 거부되거나 차단되는 경우, [SSH 서버 자체가 주소를 거부하는지](#check-whether-the-ssh-server-itself-refuses-the-address)와 [fail2ban이 Desktop의 테스트를 집계하는지](#check-whether-fail2ban-counts-desktops-tests)를 확인하십시오.

##### SSH 서버 로그에서 테스트 식별

로그의 줄을 서버 버전에 해당하는 행에서, 기본 `LogLevel`의 Linux OpenSSH 서버가 테스트에 대해 기록하는 줄과 비교하십시오. Desktop이 연결을 닫기 전에 서버의 인사말이 도착하면 마지막 열의 줄이 대신 표시될 수 있습니다.

| OpenSSH 버전 | 테스트에 대한 줄 | 인사말이 먼저 도착한 경우의 줄 |
| - | - | - |
| 6.6\~7.9 | `Did not receive identification string from 203.0.113.7`이 포함된 줄 | 같은 줄 |
| 8.0\~8.2 | `error: kex_exchange_identification: Connection closed by remote host` | `error: kex_exchange_identification: read: Connection reset by peer` |
| 8.3\~9.4 | `error: kex_exchange_identification: Connection closed by remote host` 다음에 `Connection closed by 203.0.113.7 port 51234` | `error: kex_exchange_identification: read: Connection reset by peer` 다음에 `Connection reset by 203.0.113.7 port 51234` |
| 9.5\~10.2 | `Connection closed by 203.0.113.7 port 51234` | `error: kex_exchange_identification: read: Connection reset by peer` 다음에 `Connection reset by 203.0.113.7 port 51234` |
| 10.3\~10.5 | `Connection closed by 203.0.113.7 port 51234 [preauth]` | `error: kex_exchange_identification: read: Connection reset by peer [preauth]` 다음에 `Connection reset by 203.0.113.7 port 51234 [preauth]` |

포트를 열고 닫는 다른 프로그램도 같은 줄을 남길 수 있습니다. 줄에 주소가 있는 경우, 그것이 Desktop이 설치된 컴퓨터가 연결하는 주소인지 확인하십시오.

8.0\~8.2의 줄에는 주소가 없습니다. 주소를 얻으려면 `sshd_config`에서 `LogLevel VERBOSE`를 설정하고 root로 `sshd -T | grep -i loglevel`을 실행합니다. `loglevel VERBOSE`가 출력되면 SSH 서버를 다시 로드합니다. 그런 다음 테스트 줄 앞에 `Connection from 203.0.113.7 port 51234`가 포함된 줄을 찾습니다.

##### SSH 서버 자체가 주소를 거부하는지 확인

Desktop이 설치된 여러 컴퓨터가 공유하는 주소에서의 연결이 거부되는 경우, SSH 서버 로그에서 다음과 같이 끝나는 줄을 찾으십시오.

```text theme={null}
drop connection #0 from [203.0.113.7]:51234 on [192.0.2.10]:22 penalty: connections without attempting authentication
```

기본 `LogLevel`에서 OpenSSH 9.8 이상은 Desktop의 테스트처럼 로그인을 시도하지 않고 닫힌 연결에 대해 주소를 거부할 때 이러한 줄을 기록할 수 있습니다. 기본 설정에서는 몇 번의 테스트만으로 이러한 줄이 표시되지 않습니다.

거부를 방지하려면 `sshd_config`에서 `PerSourcePenaltyExemptList`를 사람들이 연결하는 주소로 설정합니다(예: `PerSourcePenaltyExemptList 203.0.113.7`). 그러면 서버는 로그인 실패에 대한 페널티를 포함하여 해당 주소에 어떠한 페널티도 적용하지 않습니다. 파일을 확인하려면 root로 `sshd -T | grep -i persourcepenalt`를 실행합니다. 목록이 출력되면 SSH 서버를 다시 로드합니다.

##### fail2ban이 Desktop의 테스트를 집계하는지 확인

fail2ban 0.10.5 이상이 Desktop이 연결하는 주소를 차단한 경우, `jail.conf`, `jail.local` 또는 `jail.d/` 아래에서 jail의 모드를 찾으십시오.

* **대괄호 안에 모드를 지정하는 `filter` 줄**(예: `filter = sshd[mode=aggressive]`): 해당 모드를 사용합니다.
* **`[mode=%(mode)s]`가 있는 기본 `filter` 줄만 있는 경우**: `mode` 줄을 사용하거나, 없으면 `normal`을 사용합니다.

모드가 `normal`이면 fail2ban은 Desktop 테스트의 줄을 집계하지 않으므로 차단의 다른 원인을 찾으십시오.

다른 모드인 경우 자신의 로그에서 줄을 원격 머신의 파일로 복사합니다. 각 줄을 날짜부터 끝까지 통째로 복사하고, 테스트가 두 줄을 남기는 경우 두 줄을 모두 복사합니다. 해당 머신에서 파일과 jail의 모드(예: `aggressive`)로 `fail2ban-regex`를 실행합니다.

```bash theme={null}
fail2ban-regex -o ip lines.log "sshd[mode=aggressive]"
```

fail2ban이 집계하는 각 실패에 대해 명령은 `203.0.113.7`처럼 주소를 별도의 줄에 출력합니다. 이 경우 [차단을 방지](#prevent-a-ban-by-fail2ban)하십시오. 아무것도 출력되지 않으면 fail2ban은 해당 모드에서 이 줄들을 집계하지 않으므로 차단의 다른 원인을 찾으십시오.

##### fail2ban의 차단 방지

fail2ban이 Desktop의 테스트 때문에 주소를 차단하지 않도록 하려면 jail의 두 설정 중 하나를 변경합니다. 각각에는 대가가 따릅니다.

* **`mode`**: jail이 설정하는 모든 곳, 즉 `mode` 줄이나 `filter = sshd[mode=aggressive]` 같은 줄의 대괄호 안에서 `normal`로 설정합니다. 로그인을 시도하지 않고 연결했다가 떠나는 클라이언트처럼 다른 모드에서만 집계되는 모든 항목을 포기하게 됩니다.
* **`ignoreip`**: 사람들이 연결하는 주소로 설정합니다(예: `ignoreip = 203.0.113.7`). 그러면 fail2ban은 로그인 실패를 포함하여 해당 주소에서 오는 어떤 것도 집계하지 않습니다.

#### 원격 머신에 설정된 MCP 서버 사용

SSH 세션에서 `~/.claude.json` 또는 프로젝트의 `.mcp.json`에 있는 [MCP 서버](https://code.claude.com/docs/ko/mcp.md)를 사용하려면 원격 머신의 해당 파일에 서버를 설정합니다. Claude Code는 해당 stdio 서버를 원격 머신에서 시작하므로, 이러한 서버가 실행하는 명령을 원격 머신에 설치하세요. `claude_desktop_config.json`의 서버에 대해서는 [Desktop 연결이 끊긴 동안의 제한](#limits-while-desktop-is-disconnected)을 참조하세요.

#### 링크에서 SSH 세션 열기

`claude://code/new` 링크는 Desktop의 새 세션 페이지를 열며, SSH 연결을 지정할 수 있습니다. 이러한 링크를 런북, 대시보드 또는 위키 페이지에 넣어 두면 적절한 머신과 폴더로 설정된 상태로 Desktop을 열 수 있습니다. 이러한 링크를 제거하는 플랫폼의 경우 [링크가 클릭할 수 없는 일반 텍스트로 표시됨](https://code.claude.com/docs/ko/deep-links.md#the-link-renders-as-plain-text-instead-of-being-clickable)을 참조하세요.

SSH 링크를 사용하려면 Claude Desktop v2.110.0 이상이 필요합니다.

다음 링크는 `build.example.com`의 사용자 `dev`, 포트 2222, 폴더 `/srv/payments`를 지정하고 프롬프트를 채웁니다:

```text theme={null}
claude://code/new?ssh_host=dev%40build.example.com&ssh_port=2222&ssh_folder=/srv/payments&q=Investigate%20the%20failed%20deploy
```

SSH 링크는 다음 매개변수를 사용하며, `ssh_host`만 필수입니다:

| 매개변수 | 값 |
| :- | :- |
| `ssh_host` | **SSH host** 필드에 쓰는 것과 같은 형식의 `host` 또는 `user@host`. 값은 `-`로 시작할 수 없으며, 호스트 부분에는 문자, 숫자, `.`, `_`, `:`, `-`만 사용할 수 있습니다 |
| `ssh_port` | 1부터 65535까지의 포트 번호 |
| `ssh_folder` | 원격 머신의 폴더. `/` 또는 `~/`로 시작하거나 `~`를 사용합니다 |
| `q` | 프롬프트 상자에 들어갈 URL 인코딩된 텍스트 |

`~/.ssh/config`의 별칭은 해당 항목이 있는 사용자에게만 `ssh_host`로 작동합니다. 사용자가 이미 가지고 있는 연결과 일치시키려면 링크에 해당 연결과 동일한 사용자, 호스트, 포트를 지정합니다.

링크를 열면 Desktop은 연결을 선택하기 전에 확인을 요청합니다:

* **이미 가지고 있는 연결**: 호스트, 사용자, 포트가 기존 연결 중 하나와 일치하면 Desktop은 해당 연결을 사용할지 묻고, 연결의 이름과 호스트, 그리고 링크에 폴더가 지정된 경우 폴더를 표시합니다.
* **새 연결**: 그렇지 않으면 Desktop은 SSH 연결 추가 대화 상자를 엽니다. 연결을 추가하면 Desktop은 아무것도 저장하기 전에 연결할지 묻고, 링크의 호스트와 링크에 지정된 경우 포트 및 폴더를 표시합니다.

확인하기 전까지 Desktop은 링크의 호스트, 포트 또는 폴더를 저장하지 않으며, 이를 사용하여 연결을 선택하거나 열지 않습니다. SSH 연결이 이미 선택되어 있는 경우 새 세션 페이지는 링크가 동일한 호스트를 지정하더라도 링크가 없을 때와 마찬가지로 해당 연결에 자체적으로 연결할 수 있습니다. 링크에는 키 파일, 비밀번호 또는 명령을 포함할 수 없습니다.

누구나 링크를 작성할 수 있으므로 링크가 채운 내용을 확인하세요:

* **확인하기 전**: 호스트와 폴더를 확인합니다.
* **보내기 전**: 프롬프트와 선택된 환경을 확인합니다.

Desktop은 링크가 열릴 때 보내지 않은 텍스트를 대체하여 프롬프트를 채우며, 절대 자동으로 보내지 않습니다. 프롬프트를 일반 텍스트로 처리하므로 앞에 오는 `/` 또는 `!`와 `@` 파일 멘션은 명령이나 멘션으로 작동하지 않습니다. 취소하면 프롬프트는 상자에 그대로 남아 있고 선택했던 환경은 변경되지 않습니다.

링크는 [`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to)를 우회하지 않습니다. Desktop은 연결할 때 허용 목록을 확인합니다.

링크가 연결에 대한 대화 상자 없이 Desktop을 여는 경우 다음 원인 중 하나를 확인하세요:

* **로그아웃된 상태**: 로그인한 다음 링크를 다시 엽니다.
* **다른 대화 상자가 열려 있음**: 해당 대화 상자를 닫은 다음 링크를 다시 엽니다.
* **링크가 유효하지 않음**: Desktop은 수정할 내용을 알려 주는 메시지를 표시하며 프롬프트를 채우지 않습니다.
* **Desktop이 v2.110.0보다 오래됨**: 이전 버전은 SSH 매개변수를 무시하고 프롬프트만 포함된 새 세션 페이지를 엽니다.
* **SSH 세션이 꺼져 있음**: 관리자가 허용 목록을 빈 배열로 설정한 경우 Desktop은 SSH 링크를 거부합니다.

#### 명령으로 SSH 연결 만들기

명령줄 도구가 필요할 때 원격 머신을 만드는 경우, 해당 명령을 [`~/.claude/settings.json`](https://code.claude.com/docs/ko/settings#settings-files)의 `sshHostCommands`에 추가합니다. 그러면 환경 선택기에 **Create Dev box**처럼 항목 이름을 딴 항목이 표시됩니다. 이를 선택하면 Desktop은 사용자의 컴퓨터에서 명령을 실행하고, 명령이 출력한 호스트를 SSH 연결로 저장한 뒤 연결합니다.

> [!NOTE]
>
> 명령으로 만드는 연결은 macOS 또는 Linux에서 Claude 계정으로 로그인한 Claude Desktop v3.6556.0 이상이 필요합니다. 관리자는 [명령을 팀에 배포](#distribute-commands-to-your-team)할 수 있습니다.

Desktop은 연결할 때마다가 아니라 연결을 만들거나 [다른 머신을 만들](#create-another-machine) 때만 명령을 실행합니다. 각 항목은 하나의 연결이며, 이 연결은 Desktop이 해당 항목의 명령으로부터 마지막으로 저장한 호스트를 가리킵니다.

> [!WARNING]
>
> Desktop은 머신을 중지하거나 삭제하지 않습니다. 다음 각 항목은 사용자가 도구로 삭제할 때까지 계속 실행되며 비용이 계속 발생할 수 있습니다.
>
> * [다른 머신을 만들기](#create-another-machine) 전에 항목이 가리키던 머신
> * 파일에서 제거했거나 `id`를 변경한 항목의 머신
> * Desktop이 호스트를 저장하지 않은 상태에서 명령이 만든 머신. 예를 들어 다음과 같은 경우입니다.
>   * 명령이 실패하거나 시간이 초과된 경우
>   * Desktop이 출력된 호스트를 사용할 수 없거나, 다른 연결이 이미 해당 호스트를 사용하거나, 조직에서 허용하지 않는 경우
>   * 명령이 실행되는 동안 명령을 취소하거나, 해당 항목을 제거하거나, `command` 또는 `id`를 변경하거나, Desktop을 종료한 경우

다음 예시는 Dev box라는 연결을 추가합니다. 파일이 없으면 새로 만듭니다. 파일에 이미 설정이 있으면 그 옆에 키를 추가합니다. `acme-dev create` 명령은 사용자 자신의 도구를 나타내며, `~/project`는 명령이 만드는 각 머신에서 Desktop이 선택하는 폴더입니다.

```json ~/.claude/settings.json theme={null}
{
  "sshHostCommands": [
    {
      "id": "devbox",
      "name": "Dev box",
      "command": "acme-dev create",
      "startDirectory": "~/project"
    }
  ]
}
```

각 항목은 다음 필드를 받으며, `id`, `name`, `command`는 필수입니다.

| 필드 | 값 |
| :- | :- |
| `id` | 문자 또는 숫자로 시작하는, 최대 64자의 ASCII 문자, 숫자, `.`, `_`, `-`. `sshHostCommands` 또는 [`sshConfigs`](#pre-configure-ssh-connections-for-your-team)의 다른 항목에 없는 `id`를 사용하세요. Desktop은 연결의 호스트를 이 값 아래에 보관하므로, 이를 변경하면 연결은 호스트 없이 다시 시작되고 해당 머신은 계속 실행되며 Desktop은 [여전히 해당 머신에 연결할 수 있습니다](#remove-an-entry). |
| `name` | 환경 선택기에 표시되는 연결 이름으로, 한 줄에 최대 200자 |
| `command` | [명령 작성하기](#write-the-command)에서 설명하는 대로 작성한 프로그램과 인수 |
| `sshIdentityFile` | `~/.ssh/id_ed25519`와 같은 개인 키 경로. SSH 구성 또는 SSH 에이전트를 사용하려면 생략합니다. |
| `startDirectory` | 원격 머신의 기본 폴더. `/` 또는 `~/`로 시작하거나 `~`를 사용합니다. |

연결을 변경하거나 제거하려면 파일에서 해당 항목을 편집합니다. 앱의 SSH 연결 대화 상자는 이 연결에 대해 열리지 않기 때문입니다. 파일을 편집한 후 Desktop을 다시 시작할 필요는 없습니다. 항목이 표시되지 않거나 선택할 수 없으면 [명령이 없거나 회색으로 표시되는 경우](#if-a-command-is-missing-or-gray)를 참조하세요.

##### 명령 작성하기

Desktop은 셸이나 터미널 없이 프로그램을 직접 시작합니다.

* **프로그램**: 공백 없이 이름 또는 `/`부터 시작하는 전체 경로를 작성합니다. Desktop은 로그인 셸이 내보내는 `PATH`에서 단순 이름을 찾습니다. `./acme-dev`와 같은 상대 경로, `~`로 시작하는 경로, 셸 별칭 및 함수는 작동하지 않습니다.
* **인수**: 일반 인수는 공백으로 구분합니다. 명령에는 공백, ASCII 문자, 숫자, `+,-./:=@_~` 문자만 포함할 수 있으며, 어떤 단어도 `~`로 시작할 수 없습니다.
* **스크립트**: 따옴표, 파이프, 변수, `?` 또는 `&`가 포함된 URL 등 다른 것이 필요하면 스크립트에 넣습니다. 스크립트를 실행 가능하게 만들고 `#!` 줄로 시작한 다음, `command`를 `/Users/you/bin/make-devbox`와 같은 전체 경로로 설정합니다. macOS에서는 macOS가 스크립트를 차단할 수 있는 Documents, Desktop, Downloads 폴더에 스크립트를 두지 마세요.
* **입력**: 프로그램은 입력이나 터미널을 받지 않으므로 그곳에서 사용자에게 확인을 요청할 수 없습니다. 도구가 브라우저나 프롬프트를 통해 로그인하는 경우, 먼저 터미널에서 로그인하고 해당 로그인이 만료될 때마다 다시 로그인합니다.
* **환경**: 프로그램은 로그인 셸이 내보내는 변수와 함께 홈 디렉터리에서 실행됩니다. Desktop은 [`ProxyCommand`](#use-variables-from-your-shell-in-a-proxycommand)의 경우와 마찬가지로 시작할 때 이 변수를 읽으므로, 변수를 변경한 후에는 Desktop을 종료했다가 다시 엽니다.
* **시간 제한**: Desktop은 10분이 지나도 실행 중인 프로그램을 중지합니다. Desktop의 진행 메시지에는 프로그램의 출력이 표시되지 않습니다. 프로그램을 더 일찍 중지하려면 해당 메시지 옆의 **Cancel**을 선택합니다.

프로그램은 코드 0으로 종료되어야 하며, 표준 출력에 호스트만 다음 두 형식 중 하나로 출력해야 합니다.

* **한 줄**: [SSH 링크](#open-an-ssh-session-from-a-link)의 `ssh_host`와 같은 형식의 `host` 또는 `user@host`. 포트를 지정하려면 JSON 형식을 사용합니다.
* **하나의 JSON 객체**: `sshHost`, 그리고 선택적으로 숫자 `sshPort`와 항목의 값을 대체하는 `startDirectory`. 예: `{"sshHost": "dev@devbox-1234.example.com", "sshPort": 2222}`

Desktop이 읽는 출력을 확인하려면 입력 없이 표준 출력을 파일로 보내도록 터미널에서 명령을 실행합니다.

```bash theme={null}
acme-dev create < /dev/null > host.txt
```

파일에는 호스트만 있어야 합니다. 이 테스트를 실행하면 도구가 머신도 만들므로, 이후에 도구로 삭제하세요.

도구가 진행 메시지처럼 호스트 앞에 다른 줄을 출력하는 경우, 호스트만 출력하는 스크립트로 감쌉니다. 다음 스크립트는 도구 출력의 마지막 줄을 출력합니다. 도구가 실패하면 스크립트는 동일한 코드로 종료되므로 Desktop이 실패를 보고합니다.

```bash theme={null}
#!/bin/bash
out=$(mktemp) || exit
trap 'rm -f "$out"' EXIT
acme-dev create > "$out" || exit
tail -n 1 "$out"
```

명령이 실패하면 Desktop 메시지의 **View details**에 명령이 표준 오류에 마지막으로 쓴 줄이 있는 경우 해당 줄이 표시됩니다.

##### 새 호스트에 연결하기

각 새 호스트에 처음 연결할 때 두 가지 질문에 답합니다.

* **호스트 키**: OpenSSH의 기본 호스트 키 검사를 사용하는 경우, 키의 지문을 확인한 다음 연결할지 선택합니다. 이 질문을 건너뛰려면 명령이 호스트를 출력하기 전에 도구가 머신을 만들 때 알게 된 키를 사용하여 `~/.ssh/known_hosts`에 키를 추가하도록 합니다. 22가 아닌 포트의 경우 해당 줄은 `[host]:port`로 시작합니다. 도구가 호스트 이름을 재사용하는 경우 이전 키의 줄도 제거합니다.
* **폴더**: 그곳에서 여는 폴더를 신뢰할지 선택합니다

이러한 호스트에 대해서는 호스트 키 검사를 켜 두고 `known_hosts` 파일을 유지하세요. `StrictHostKeyChecking`이 `no` 또는 `accept-new`이면서 `UserKnownHostsFile`도 `/dev/null` 또는 `none`이면 키를 기록하는 것이 없습니다. 이 상태에서 도구가 이름을 재사용하면 경고 없이 다른 머신에 연결될 수 있습니다.

Desktop은 이러한 호스트에 스스로 연결하므로, 컴퓨터 앞에 아무도 없을 때도 재사용된 이름이 문제가 됩니다. 예를 들어 호스트에 연결할 수 없는 동안 보낸 메시지를 호스트가 응답하면 전달합니다. 호스트 키 확인이 켜져 있더라도 다음 경우에는 메시지가 해당 이름의 새 머신에 도달할 수 있으므로, 머신이 삭제되기 전에 [머신 사용을 중지](#stop-using-a-machine)하세요.

* 사용자, 명령 또는 다른 프로그램이 새 키를 `known_hosts`에 추가했거나 이전 키의 줄을 제거한 경우(명령이 호스트 키를 추가하는 경우 명령이 하는 작업과 같습니다)
* 도구의 머신들이 호스트 키를 공유하는 경우
* 도구의 머신들이 `known_hosts`가 신뢰하는 인증 기관을 공유하는 경우
* 사용자 또는 관리자가 `KnownHostsCommand` 또는 `VerifyHostKeyDNS yes`를 설정하여 SSH가 `known_hosts` 외부의 키를 수락하는 경우

##### 다른 머신 만들기

**Create another Dev box**를 선택한 후에도 이전 머신의 세션은 계속 작동하며, 새 세션은 새 머신을 사용합니다. 새 머신을 만들거나 사라진 머신을 대체하려면 환경 선택기에서 이 항목을 선택합니다. 새 세션 페이지에서 Desktop이 호스트에 연결할 수 없다는 메시지에서도 이 항목을 제공합니다.

* **이전 머신의 세션**: 선택기에는 이전 머신이 아니라 Dev box의 현재 머신이 표시되므로 사이드바에서 해당 세션을 계속합니다. Desktop은 시작할 때 등 해당 머신에 스스로 연결할 수 있으므로, 작업이 끝나면 [머신 사용을 중지](#stop-using-a-machine)하세요.
* **Claude Desktop v4.4212.0 이전에 대체된 호스트**: 해당 버전에서는 **Replace Dev box's host**가 표시되며 대체된 호스트에 대한 연결을 중지합니다. 해당 호스트의 세션을 계속하려면 세션을 열고 **Add SSH connection**을 선택한 다음 Desktop이 채운 연결을 저장합니다. 다른 호스트를 대체하기 전에 Desktop을 업데이트하세요.
* **두 머신에서의 새 세션**: [`sshHostCommands`](#create-an-ssh-connection-from-a-command)에 두 번째 항목을 추가합니다
* **아직 응답하지 않는 새 호스트**: 새 세션 페이지가 계속 연결을 시도하는 동안 최대 10분간 열어 둡니다. 호스트가 여전히 응답하지 않으면 페이지 메시지에서 **Create another Dev box**를 선택합니다.
* **곧이어 또 다른 머신**: 한 시간 안에 명령을 여러 번 실행한 후에는 Desktop이 여는, 명령을 보여주는 대화 상자에서 이후의 각 실행을 확인해야 합니다

##### 머신 사용 중지하기

명령이 만든 머신에 Desktop이 스스로 연결하지 않도록 하려면 해당 머신의 모든 세션을 보관합니다.

1. 사이드바에서 해당 머신의 세션을 찾습니다. 세션의 [세부 정보 패널](#see-session-details)에 세션이 실행되는 호스트가 표시됩니다.
2. [각 세션을 보관](#archive-a-session)하고, 보관된 상태로 둡니다.
3. 이 머신을 만든 이후 같은 `sshHostCommands` 항목에서 다른 머신을 만들지 않았다면 [하나를 만들거나](#create-another-machine) [항목을 제거](#remove-an-entry)하기도 합니다. 그 전까지 이 머신은 항목의 저장된 연결이며, 해당 연결이 선택된 상태로 새 세션 페이지를 열면 Desktop이 이 머신에 연결할 수 있습니다.
4. 앱에서 해당 머신에 대한 다른 SSH 연결을 삭제하거나, 해당 [`sshConfigs`](#pre-configure-ssh-connections-for-your-team) 항목을 제거합니다.
5. Desktop을 종료했다가 다시 열어 머신에 대한 연결을 닫고 연결 시도를 끝냅니다.
6. 도구로 머신을 삭제합니다.

##### 항목 제거하기

설정 파일에서 항목을 제거하거나 `id`를 변경한 후에도 해당 머신의 세션은 남아 있으므로 Desktop은 여전히 그 머신에 연결할 수 있습니다. 세션의 실행 중인 프로세스에 다시 연결하거나 전송 대기 중인 메시지를 전달하기 위해, 컴퓨터 앞에 아무도 없을 때도 연결할 수 있습니다. 이를 중지하려면 [머신 사용 중지하기](#stop-using-a-machine)에서 설명하는 대로 세션을 보관하세요.

관리자가 관리형 항목을 제거한 경우에도 사용자의 세션은 남아 있으며, 각 사용자가 직접 자신의 세션을 보관해야 합니다. 관리자가 직접 해당 항목의 머신을 차단하려면 사용자에게 여전히 필요한 호스트와는 일치하고 해당 머신의 호스트 이름과는 일치하지 않는 [`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to)를 설정합니다. 이는 패턴으로 둘을 구별할 수 있는 경우에만 가능합니다.

##### 팀에 명령 배포하기

팀에 연결을 제공하려면 데스크톱 앱 자체의 [기기 관리 정책](#device-management-policies)이 아니라, 각 컴퓨터의 Claude Code [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md) 파일 또는 MDM 정책에서 `sshHostCommands`를 설정합니다. 사용자는 자신의 항목과 함께 관리자의 항목을 볼 수 있으며, 앱에서는 사용자의 항목이든 관리자의 항목이든 편집하거나 제거할 방법을 제공하지 않습니다.

다음 관리형 설정 파일은 사용자에게 Dev box라는 연결을 제공하고, 사용자 자신의 항목과 함께 사용자, 프로젝트, 로컬 설정의 Claude Code 훅을 끕니다.

```json managed-settings.json theme={null}
{
  "sshHostCommands": [
    {
      "id": "acme-devbox",
      "name": "Dev box",
      "command": "/usr/local/bin/acme-dev create"
    }
  ],
  "strictPluginOnlyCustomization": ["hooks"]
}
```

키를 배포하기 전에 다음 각 사항을 결정하세요.

* **키를 넣을 위치**: Claude Code용 MDM 정책이 이미 [정책 키](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)를 설정하고 있다면 그곳에 넣습니다. 그렇지 않으면 관리형 설정 파일에 넣습니다. 기본적으로 이러한 정책은 파일보다 우선하며, 이 경우 Desktop은 파일의 항목을 무시합니다. [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)이 적용되는 경우에도 컴퓨터에 설정하세요. Desktop은 서버 관리형 설정과 프로젝트 및 로컬 설정에 있는 이 키를 무시합니다.
* **`id`**: 사용자의 `sshHostCommands` 항목이 관리자의 `id`를 사용하면 관리자의 항목만 작동합니다. 사용자의 `sshConfigs`에 있는 연결처럼 다른 SSH 연결이 이를 사용하면 관리자의 항목이 회색으로 표시됩니다. 사용자가 선택할 가능성이 낮은 `id`를 고르십시오.
* **프로그램**: Desktop은 각 사용자 자신의 `PATH`에서 단순 이름을 찾으므로 전체 경로를 지정합니다. 프로그램은 해당 사용자의 로그인 셸이 내보내는 변수와 함께 해당 사용자로 실행됩니다.
* **사용자 자신의 항목**: Desktop은 사용자의 항목을 [훅](https://code.claude.com/docs/ko/hooks.md)처럼 취급합니다. 둘 다 컴퓨터에서 프로그램을 실행하기 때문입니다. 관리자의 항목만 허용하려면 [`strictPluginOnlyCustomization`](https://code.claude.com/docs/ko/settings-reference#strictpluginonlycustomization)을 `["hooks"]`로 설정하거나 해당 목록에 `"hooks"`를 추가합니다. 이렇게 하면 사용자, 프로젝트, 로컬 설정의 Claude Code 훅도 중지되며, 이를 유지할 방법은 없습니다. 대신 이 키 또는 [`allowManagedHooksOnly`](https://code.claude.com/docs/ko/settings-reference#allowmanagedhooksonly)를 `true`로 설정하면 각 키의 항목에 나열된 대로 더 많은 것이 차단됩니다.
* **모든 항목**: 관리자의 항목도 끄려면 관리형 설정에서 [`disableAllHooks`](https://code.claude.com/docs/ko/settings-reference#disableallhooks)를 설정합니다. [`disableDesktopLocalSessions`](https://code.claude.com/docs/ko/settings-reference#disabledesktoplocalsessions)를 설정하거나 어떤 호스트도 허용하지 않는 `sshHostAllowlist`를 설정하면 선택기에 **Create** 또는 **Create another** 항목이 표시되지 않습니다.
* **잠금이 적용되는 위치**: 이러한 항목에 대해 Desktop은 서버 관리형 설정과 컴퓨터 자체의 파일 또는 정책에서 `allowManagedHooksOnly`, `strictPluginOnlyCustomization`, `disableAllHooks`를 읽고 더 엄격한 결과를 적용합니다. 조직에 서버 관리형 설정이 없더라도 Desktop이 claude.ai에서 서버 관리형 설정을 확인할 때까지 모든 항목은 회색으로 유지됩니다.
* **허용된 호스트**: [`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to)를 설정한 경우, 도구가 출력하는 각 호스트 이름과 일치하는 패턴이 있는지 확인하고 패턴에서 `user@`는 생략합니다. Desktop은 명령이 실행된 후에야 출력된 이름을 확인하므로, 목록에서 거부된 머신은 이미 존재하며 사용자가 도구로 삭제해야 합니다. 각 연결 시 확인된 `HostName`도 일치해야 합니다.

키를 배포한 후 테스트 컴퓨터에서 Desktop을 다시 시작합니다. Code 탭의 환경 선택기에서 **SSH** 아래 또는 단일 **SSH** 행을 확인합니다. 항목은 **Create** 항목으로 표시되거나, 마우스를 올리면 이유를 알려주는 회색 항목으로 표시됩니다. 항목이 없으면 키를 넣은 위치를 확인한 다음 [명령이 없거나 회색으로 표시되는 경우](#if-a-command-is-missing-or-gray)의 사례를 확인하세요.

##### 명령이 없거나 회색으로 표시되는 경우

다음 경우에는 환경 선택기에 **Create** 또는 **Create another** 항목이 표시되지 않습니다.

* **파일**: `~/.claude/settings.json`에 [잘못된 JSON 또는 스키마가 거부하는 값](https://code.claude.com/docs/ko/settings.md#fix-a-broken-settings-file)이 있거나, 키 철자가 틀렸거나, 키를 프로젝트 설정에 넣은 경우입니다. 파일을 수정하세요.
* **플랫폼 및 계정**: Windows를 사용하거나, Claude 계정 대신 [서드파티 제공업체](https://code.claude.com/docs/ko/third-party-integrations.md)를 사용하는 경우입니다. 각 호스트를 직접 [SSH 연결](#ssh-sessions)로 추가하세요.
* **조직의 설정**: 관리자가 로컬 세션을 껐거나 SSH 세션을 끈 경우입니다. 명령을 사용할 수 있는지 관리자에게 문의하세요.
* **`ssh` 프로그램 없음**: Desktop이 컴퓨터에서 OpenSSH 클라이언트를 시작할 수 없는 경우입니다. 클라이언트를 설치하거나 관리자에게 허용을 요청한 다음 Desktop을 다시 시작하세요.

선택할 수 없는 항목은 회색으로 표시됩니다. 마우스를 올리면 이유를 볼 수 있습니다.

* **항목의 오류**: 메시지가 지정하는 필드 또는 명령을 수정합니다. `id`가 사용 중이면 항목에 다른 `id`를 지정합니다.
* **손상된 설정 파일**: 사용자 자신의 설정 파일이 손상된 동안에는 관리자의 항목이 파일을 지정하는 메시지와 함께 회색으로 표시될 수 있습니다. [파일을 수정](https://code.claude.com/docs/ko/settings.md#fix-a-broken-settings-file)하세요.
* **새 호스트**: Desktop이 호스트를 저장한 후 1분 동안 [**Create another**](#create-another-machine)가 회색으로 표시됩니다. 1분이 지난 후 선택하세요. Claude Desktop v4.4212.0 이전에는 **Replace Dev box's host**가 10분 동안 회색으로 표시됩니다.
* **훅이 꺼져 있거나 제한됨**: 사용자 자신의 항목은 사용자 자신의 훅을 실행할 수 있는 곳에서만 작동합니다. 설정에서 `disableAllHooks`를 제거하거나 관리자에게 문의하세요.
* **설정을 아직 로드하는 중**: Desktop이 조직의 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)을 로드할 때까지 모든 항목은 회색으로 표시되며, 보통 실행 후 몇 초가 걸립니다. 항목이 계속 회색으로 표시되면 claude.ai와의 연결을 확인하세요.

#### 팀을 위해 SSH 연결을 미리 구성합니다

관리자는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `sshConfigs`를 설정하여 팀원에게 SSH 연결을 배포할 수 있습니다.

* **사용자에게 표시되는 내용**: 이 방식으로 정의된 연결은 각 사용자의 환경 선택기에 자동으로 나타납니다.
* **사용자가 변경할 수 있는 내용**: 사용자는 관리형 연결을 선택하고 해당 연결에 대해 [자신의 **Worktree folder**를 설정](#set-the-worktree-folder-on-an-existing-connection)할 수 있습니다. 앱에서 다른 필드를 편집하거나 연결을 삭제할 수는 없습니다.

다음 예제는 단일 연결을 미리 구성합니다:

```json theme={null}
{
  "sshConfigs": [
    {
      "id": "shared-dev-vm",
      "name": "Shared Dev VM",
      "sshHost": "user@dev.example.com",
      "sshPort": 22,
      "sshIdentityFile": "~/.ssh/id_ed25519"
    }
  ]
}
```

각 항목에는 `id`, `name`, `sshHost`가 필요합니다. `sshPort` 및 `sshIdentityFile` 필드는 선택 사항입니다. 사용자는 자신의 `~/.claude/settings.json`에 `sshConfigs`를 추가할 수도 있습니다.

`sshHost`에서 `user@`를 생략하면 Desktop은 각 개발자의 `~/.ssh/config`가 해당 호스트에 대해 설정한 `User`로 연결하며, 그렇지 않으면 개발자 자신의 컴퓨터 사용자 이름으로 연결합니다.

#### SSH 호스트 연결을 제한하여 사용자가 연결할 수 있는 호스트를 제한합니다

관리자는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `sshHostAllowlist`를 설정하여 Desktop의 SSH 세션을 승인된 호스트 집합으로 제한할 수 있습니다. 설정되면 사용자는 확인된 호스트명이 패턴 중 하나와 일치하는 호스트에만 연결할 수 있습니다. SSH 세션을 비활성화하려면 빈 배열로 설정합니다. 빈 배열이 다른 관리형 소스의 목록과 어떻게 결합되는지는 [`sshHostAllowlist` 참조 항목](https://code.claude.com/docs/ko/settings-reference#sshhostallowlist)에서 설명합니다.

다음 예제는 `devboxes.example.com` 아래의 모든 호스트 및 단일 명명된 bastion 호스트에 대한 연결을 허용합니다:

```json theme={null}
{
  "sshHostAllowlist": ["*.devboxes.example.com", "bastion.example.com"]
}
```

> [!WARNING]
>
> 조직에서 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)을 제공하는 경우 `sshHostAllowlist`를 그곳에서 설정하세요. 기본적으로 Desktop은 [정책 키를 제공하는 가장 높은 순위의 관리형 소스](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)에서만 키를 읽습니다. 해당 소스가 키를 설정하지 않으면 Desktop은 더 낮은 순위의 MDM 정책 또는 관리형 설정 파일에 있는 목록을 무시하고 키를 [설정되지 않은 것](https://code.claude.com/docs/ko/settings-reference.md#sshhostallowlist)으로 처리합니다. Desktop은 경고를 표시하지 않습니다.
>
> 또한 각 사용자의 머신에서 가장 높은 순위의 MDM 정책 또는 관리형 설정 파일에 동일한 목록을 유지하세요. Desktop은 실행 시 서버 관리형 설정을 가져오며 캐시된 사본을 보관하지 않으므로, 가져오기가 성공할 때까지는 머신의 목록이 적용됩니다.

패턴은 대소문자를 구분하지 않습니다. `*`는 모든 호스트와 일치하고, `*.example.com`은 `example.com` 및 모든 하위 도메인과 일치합니다. 그 외의 패턴은 정확히 일치해야 합니다. 검사는 `ssh -G`를 통한 `~/.ssh/config` 확인 이후의 호스트 이름을 대상으로 실행되므로, 확인된 `HostName`이 일치하는 한 `Host` 별칭도 허용됩니다. 세션의 [점프 호스트](#allow-jump-hosts)도 일치해야 합니다.

`sshHostAllowlist`는 관리 설정에서만 읽혀집니다. 사용자 또는 프로젝트 설정의 값은 무시됩니다. Claude Desktop 앱만 이 설정을 인식합니다. Claude Code CLI 및 IDE 확장은 이를 읽지 않으며, Bash 도구를 통해 실행되는 `ssh` 명령을 제한하지 않습니다. 이는 Desktop 앱이 연결하는 호스트를 제어하며, 네트워크 송신을 제어하지 않으므로 하드 경계가 필요한 경우 조직의 네트워크 또는 제로 트러스트 제어와 함께 사용합니다.

##### 점프 호스트 허용

Desktop이 검사하는 각 점프 호스트를 자체의 확인된 `HostName`으로 `sshHostAllowlist`에 추가합니다. 사용자가 Claude Desktop v3.1623.0 이상으로 업데이트하기 전에 점프 호스트를 추가하세요. 그렇지 않으면 사용자가 점프 호스트를 통해 연결할 수 없습니다.

> [!WARNING]
>
> 목록에는 한 종류의 항목만 있으므로, 사용자는 목록에 있는 모든 호스트에서 세션을 시작할 수도 있습니다. 사용자가 세션을 실행하도록 허용해도 되는 점프 호스트만 목록에 추가하세요.

Desktop은 사용자의 `~/.ssh/config`가 세션 호스트에 대해 설정한 `ProxyJump`, 또는 `ssh -W %h:%p <host>` 형식으로 작성된 `ProxyCommand`에 있는 점프 호스트를 검사합니다. Desktop이 세션을 연결하거나 다시 연결할 때 검사하는 점프 호스트가 목록에 없으면 연결이 실패합니다. 사용자가 세션을 시작하거나 메시지를 보내면 오류 세부 정보에 해당 점프 호스트의 `HostName`이 표시되며, 이것이 추가해야 할 이름입니다.

```text theme={null}
SSH host "bastion.example.com" is not allowed by your organization's managed settings. It is a jump host on the way to "devbox".
```

메시지에 `managed settings on this computer`라고 표시되면 사용자 컴퓨터의 목록에 이름을 추가합니다. 누락된 점프 호스트가 둘 이상이면 오류는 한 번에 하나씩 이름을 표시합니다. 사용자가 업데이트하기 전에 모든 이름을 찾으려면 사용자 컴퓨터의 터미널을 사용합니다.

**1. 경로 찾기**

사용자가 연결하는 호스트로 `ssh -G`를 실행합니다(예: `ssh -G devbox`). `proxyjump` 줄 또는 `ssh -W %h:%p <host>` 형식으로 작성된 `proxycommand` 줄을 찾습니다. 명령에 `-l`, `-p`, `-J`, `-q`, `-v`, `-N`, `-T`, `-x`, `-a` 중 어느 것이 포함되어도 해당 형식으로 간주되며, `-J` 뒤의 호스트도 점프 호스트입니다. `proxycommand` 줄이 `ssh` 이외의 프로그램을 실행하는 경우 해당 줄에 대해서는 아무것도 추가하지 않습니다.

**2. 각 점프 호스트 조회**

해당 줄의 각 점프 호스트로 `:port` 없이 `ssh -G`를 실행하고, 출력되는 `hostname`을 기록합니다. 해당 줄의 첫 번째 점프 호스트 출력에 두 종류 중 어느 하나의 줄이 있으면 그 줄로 이 단계를 반복합니다. 이후 점프 호스트의 출력에 있는 이러한 줄은 무시합니다.

**3. 이름 추가**

목록을 설정하는 모든 관리형 소스의 `sshHostAllowlist`에 각 호스트 이름 또는 이를 포함하는 와일드카드를 추가합니다. 그런 다음 Desktop은 실행 시 서버 관리형 설정을 가져오므로 사용자에게 Desktop을 종료했다가 다시 열도록 합니다.

#### 로컬 세션 끄기 및 SSH 연결 배포

로컬 세션을 끄고 SSH 세션을 선택한 호스트로 제한하려면 [`disableDesktopLocalSessions`](https://code.claude.com/docs/ko/settings-reference#disabledesktoplocalsessions), [`sshConfigs`](#pre-configure-ssh-connections-for-your-team), [`sshHostAllowlist`](#restrict-which-ssh-hosts-users-can-connect-to)를 함께 배포합니다.

> [!NOTE]
>
> 이 설정은 Claude 계정으로 로그인하는 사용자를 위한 것입니다. [타사 제공업체](https://code.claude.com/docs/ko/third-party-integrations.md)를 사용하는 경우 SSH 세션은 기본적으로 꺼져 있으며, `sshHostAllowlist`를 설정하면 이를 켤 수 있습니다. 이러한 키를 배포하기 전에 [SSH remote sessions in Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/ssh-remote-sessions)를 읽어 보세요.

다음 예제는 로컬 세션을 끄고, 연결 하나를 추가하며, SSH 세션을 해당 연결의 호스트로 제한합니다:

```json managed-settings.json theme={null}
{
  "disableDesktopLocalSessions": true,
  "sshConfigs": [
    {
      "id": "shared-dev-vm",
      "name": "Shared Dev VM",
      "sshHost": "dev.example.com"
    }
  ],
  "sshHostAllowlist": ["dev.example.com"]
}
```

이 키들은 데스크톱 앱에 적용됩니다. CLI, Cowork, 클라우드 세션과 같이 Claude Code를 실행하는 다른 방법은 그대로 유지됩니다:

* **CLI**: 어떤 키도 개발자가 자신의 컴퓨터에서 Claude Code CLI를 실행하는 것을 막지 않습니다
* **Cowork**: 어떤 키도 [Cowork](https://claude.com/docs/cowork/overview) 세션이나 Cowork 예약 작업에 적용되지 않습니다
* **클라우드 세션**: 어떤 키도 [클라우드 세션](#cloud-sessions)의 사용 가능 여부를 변경하지 않습니다. 클라우드 세션을 끄려면 [Admin console controls](#admin-console-controls)의 **Cloud sessions** 설정을 사용합니다.

예제를 조정할 때는 호스트명, Desktop 버전, 파일 권한을 확인하세요:

* **호스트 이름**: `sshHostAllowlist`의 패턴이 `user@`를 제외한 각 `sshConfigs` 항목의 호스트 이름과 일치하는지 확인하세요. 그렇지 않으면 개발자가 해당 호스트에 연결할 수 없습니다. 또한 Desktop이 해당 호스트로 가는 경로에서 검사하는 각 [점프 호스트](#allow-jump-hosts)와 일치하는 패턴도 추가하세요. Desktop이 호스트 이름을 일치시키는 방법은 [사용자가 연결할 수 있는 SSH 호스트 제한](#restrict-which-ssh-hosts-users-can-connect-to)을 참조하세요.
* **버전**: `disableDesktopLocalSessions`를 사용하려면 Claude Desktop v1.37937.0 이상이 필요합니다
* **파일 권한**: 컴퓨터에서 각 개발자의 계정이 관리형 설정 파일을 읽을 수 있는지 확인합니다. Desktop은 계정이 읽을 수 없는 파일의 키를 적용하지 않으며, Claude Code도 [해당 키 없이 시작됩니다](https://code.claude.com/docs/ko/managed-settings.md#find-entries-claude-code-dropped).

세 키를 하나의 [관리형 소스](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources), 즉 제공하는 소스 중 가장 높은 순위의 소스에 넣습니다. [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)을 제공하는 경우 각 컴퓨터의 가장 높은 순위의 MDM 정책 또는 관리형 설정 파일에도 세 키의 사본을 유지하세요. Desktop은 실행 시 서버 관리형 설정을 가져오며, 가져오기가 성공할 때까지는 컴퓨터의 사본이 적용됩니다.

설정이 적용되는지 확인하려면 개발자의 컴퓨터를 확인합니다:

**1. 환경 선택기 확인**

Desktop을 종료했다가 다시 연 다음 [환경 선택기](#start-a-session)를 엽니다. 다음이 표시되면 설정이 적용된 것입니다.

* 해당 컴퓨터 항목이 회색으로 표시됨
* **SSH** 아래에 **Shared Dev VM**이 표시됨. 목록에 없다면 단일 **SSH** 행이나 그룹 끝의 **More**를 클릭하세요.

컴퓨터 항목을 여전히 사용할 수 있다면 다음 원인을 확인하세요.

* **Desktop 버전**: Desktop이 v1.37937.0보다 이전 버전이라면 업데이트하세요.
* **관리형 설정 파일**: 파일이 유효한 JSON인지 확인하세요.
* **관리형 소스**: 컴퓨터가 키를 담고 있는 [관리형 소스](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)를 읽는지 확인하세요.

**2. 허용 목록에 없는 호스트 추가**

`other.example.com`처럼 허용 목록에 없는 호스트 이름으로 [SSH 연결을 추가](#ssh-sessions)합니다. Desktop은 연결을 저장하지만 연결을 거부하며, 조직의 설정에서 해당 연결을 허용하지 않는다고 알립니다.

## 엔터프라이즈 구성

Team 또는 Enterprise 플랜의 조직은 관리자 콘솔 제어, 관리형 설정 파일, 기기 관리 정책을 통해 데스크톱 앱의 동작을 관리할 수 있습니다.

### 관리자 콘솔 제어

다음 설정은 [관리자 설정 콘솔](https://claude.ai/admin-settings/claude-code)에서 구성합니다.

* **Desktop**: 조직의 사용자가 데스크톱 앱에서 Claude Code에 액세스할 수 있는지 여부를 제어합니다
* **Cloud sessions**: 조직의 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 활성화하거나 비활성화합니다
* **Remote Control**: 조직의 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 활성화하거나 비활성화합니다

HIPAA가 활성화된 Enterprise 조직에서는 **Desktop** 토글이 기본적으로 꺼져 있으며, [Owner](https://code.claude.com/docs/ko/server-managed-settings.md#access-control)가 켤 수 있습니다. [HIPAA 구성](https://code.claude.com/docs/ko/hipaa-setup.md)을 적용하면 이 토글이 켜져 있었더라도 꺼지므로, 이후 Owner가 다시 켜야 합니다. **Cloud sessions**와 **Remote Control**도 기본적으로 꺼져 있으며, 조직에 HIPAA 구성이 적용된 후에는 Owner도 이를 켤 수 없습니다.

> [!NOTE]
>
> 관리자 콘솔의 [데이터 및 개인정보 설정](https://claude.ai/admin-settings/data-privacy-controls)에서 **Monitoring** 아래에 있는 Cowork용 OpenTelemetry 양식은 Cowork 세션에만 적용됩니다. 이 머신의 Cowork 세션에서는 데스크톱 앱이 해당 컬렉터를 `OTEL_*` 환경 변수로 Claude Code에 전달하므로, 해당 세션의 Claude Code가 [관리자 콘솔 설정을 가져오지 않더라도](#managed-settings) 이 양식이 적용됩니다.
>
> Code 탭 세션에서 텔레메트리를 내보내려면 [모니터링을 위한 관리자 구성](https://code.claude.com/docs/ko/monitoring-usage.md#administrator-configuration)에 나온 대로 Claude Code 관리형 설정의 `env` 블록에 `CLAUDE_CODE_ENABLE_TELEMETRY`와 `OTEL_*` 변수를 설정합니다. 로컬 세션, 클라우드 세션, SSH 세션은 각각 [서로 다른 소스에서 관리형 설정](#managed-settings)을 읽습니다. 클라우드 세션이 접근할 수 있는 호스트는 [네트워크 액세스](https://code.claude.com/docs/ko/cloud-environments.md#network-access)를 참조하십시오. Code 탭 세션이 보고하는 `service.name`은 [서비스 정보](https://code.claude.com/docs/ko/monitoring-usage.md#service-information)를 참조하십시오.
>
> SSH 세션이 어느 원격 머신에서 실행되었는지 확인하려면 [Desktop SSH 세션에 텔레메트리 귀속](https://code.claude.com/docs/ko/monitoring-usage.md#attribute-telemetry-to-desktop-ssh-sessions)을 참조하십시오.

### 관리형 설정

관리형 설정은 프로젝트 설정과 사용자 설정을 재정의하며 Desktop의 Claude Code 세션에 적용됩니다. 키의 행에 달리 명시되지 않는 한, 이러한 키는 조직의 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md) 파일에서 설정하거나 관리자 콘솔을 통해 원격으로 푸시할 수 있습니다.

| 키 | 설명 |
| - | - |
| `permissions.disableBypassPermissionsMode` | `"disable"`로 설정하면 사용자가 Bypass permissions 모드를 활성화할 수 없습니다. |
| `disableAutoMode` | `"disable"`로 설정하면 모드 선택기에서 [Auto](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) 모드가 제거됩니다. `permissions` 아래에서도 사용할 수 있습니다. |
| `autoMode` | 조직 전체에서 자동 모드 분류기가 신뢰하고 차단하는 항목을 사용자 지정합니다. [자동 모드 구성](https://code.claude.com/docs/ko/auto-mode-config.md)을 참조하십시오. |
| `browserExternalPageTools` | `"disabled"`로 설정하면 Claude가 [Browser 창](#browse-external-sites)에서 외부 페이지를 읽거나 조작하는 도구를 사용할 수 없습니다. 사용자는 여전히 직접 외부 사이트로 이동할 수 있으며, 로컬 개발 서버 미리보기는 영향을 받지 않습니다. |
| `disableMobileSimulatorTools` | `true`로 설정하면 [iOS Simulator 창](https://code.claude.com/docs/ko/desktop-ios-simulator.md#turn-off-simulator-access)에서 기기를 제어하고 캡처하는 Claude의 도구가 차단됩니다. 사용자가 직접 탭하는 용도로는 창을 계속 사용할 수 있으며, Claude의 액세스만 제거됩니다. 값은 JSON 불리언 `true`여야 하며, 문자열 `"true"`는 무시됩니다. |
| `disableBrowserExternalNavigation` | `true`로 설정하면 [Browser 창](#browse-external-sites)에서 외부 탐색이 완전히 꺼집니다. 사용자와 Claude 모두 외부 사이트로 이동할 수 없으며, localhost 개발 서버 미리보기는 영향을 받지 않습니다. 값은 JSON 불리언 `true`여야 하며, 문자열 `"true"`는 무시됩니다. |
| `sshConfigs` | 환경 선택기에 표시되는 [SSH 연결](#pre-configure-ssh-connections-for-your-team)을 미리 구성합니다. 사용자는 관리되는 연결을 삭제할 수 없으며, 자신의 **Worktree folder** 외에는 아무것도 편집할 수 없습니다. |
| `sshHostCommands` | 사용자 자신의 연결과 함께 [명령에서 호스트를 가져오는 SSH 연결](#distribute-commands-to-your-team)을 제공합니다. Desktop은 컴퓨터의 관리형 설정 파일 또는 MDM 정책에서 이 키를 읽으며, [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)에서는 무시합니다. macOS 또는 Linux에서 Claude 계정으로 로그인한 Claude Desktop v3.6556.0 이상이 필요합니다. |
| `sshHostAllowlist` | [SSH 세션](#restrict-which-ssh-hosts-users-can-connect-to)을 확인된 호스트 이름이 이 패턴 중 하나와 일치하는 호스트로 제한합니다. 관리형 설정에서만 읽습니다. |
| `disableDesktopLocalSessions` | `true`로 설정하면 [기기에서 실행되는 Code 세션](#local-sessions-on-managed-devices)이 꺼지고, 다른 호스트로의 SSH 세션과 클라우드 세션은 계속 사용할 수 있습니다. 값은 JSON 불리언 `true`여야 합니다. 관리형 설정에서만 읽습니다. Claude Desktop v1.37937.0 이상이 필요합니다. |
| `disableSshSavedPasswords` | `true`로 설정하면 Desktop이 SSH 비밀번호 저장을 제안하지 않으며, 이전에 저장한 비밀번호를 사용하거나 표시하지도 않습니다. 이 설정을 켜도 저장된 비밀번호가 삭제되지는 않습니다. 관리형 설정에서만 읽습니다. Claude Desktop v1.49585.0 이상이 필요합니다. |
| `managedMcpServers` | 모든 사용자에게 MCP 서버 구성을 푸시합니다. 서드파티(3P) Desktop 배포에서만 사용할 수 있습니다. 각 항목에서 `"http"`, `"sse"`, `"stdio"` 중 하나의 전송 방식과 연결 세부 정보를 설정하고, 선택적으로 `toolPolicy` 맵을 설정하여 사용자가 호출할 수 있는 해당 서버의 도구를 제한합니다. 3P 배포는 관리자 콘솔 설정을 받지 않으므로 관리형 설정 파일, MDM 또는 Claude apps 게이트웨이 정책의 [`desktop` 블록](https://code.claude.com/docs/ko/claude-apps-gateway-config#claude-desktop-overlay)을 통해 전달하십시오. 게이트웨이를 통해 전달하려면 게이트웨이 서버에 Claude Code v2.1.232 이상이 필요합니다. 이 키는 데스크톱 앱 고유의 키이며, Claude Code는 항목 형식이 다른 [동일한 이름의 자체 관리형 설정](https://code.claude.com/docs/ko/managed-mcp.md#provide-servers-through-managed-settings)을 읽습니다. |

Desktop 세션에 어떤 관리형 설정이 적용되는지는 해당 세션이 실행되는 위치에 따라 달라집니다. [`availableModels`](https://code.claude.com/docs/ko/model-config#restrict-model-selection)와 같은 모델 제한은 터미널 CLI와 동일한 방식으로 Desktop의 Claude Code 세션에 적용됩니다. [사용 환경별 적용 범위](https://code.claude.com/docs/ko/model-config.md#surface-coverage)를 참조하십시오.

* **이 머신의 로컬 세션**: 디스크에 배포된 관리형 설정 파일이 적용됩니다. 세션이 [적격 로그인](https://code.claude.com/docs/ko/server-managed-settings.md#platform-availability)으로 인증하는 경우, 관리자 콘솔을 통해 원격으로 푸시된 관리형 설정도 Anthropic API를 사용하는 이러한 세션에 적용되며, 터미널 CLI와 동일한 [설정 우선순위](https://code.claude.com/docs/ko/settings.md#settings-precedence)를 따릅니다.
* **[클라우드 세션](#cloud-sessions)**: [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)을 받습니다. 클라우드 세션은 Anthropic이 관리하는 VM에서 실행되므로 기기에 배포된 파일은 적용되지 않습니다. [셀프 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)으로 라우팅된 세션은 러너 이미지의 관리형 설정 파일도 읽습니다. 해당 파일이 언제 적용되는지는 [Claude Code가 관리형 소스를 결합하는 방법](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)에 설명되어 있습니다.
* **[SSH 세션](#ssh-sessions)**: 세션은 원격 호스트의 관리형 설정 파일을 읽습니다. Desktop 자체는 로컬 머신에서 `sshConfigs`, `sshHostAllowlist`, `disableSshSavedPasswords`, `disableDesktopLocalSessions`를 읽습니다. 둘 이상의 관리형 소스를 전달하는 경우, Desktop은 [기본적으로 그중 하나](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)에서 이 키들을 읽습니다.
* **[Cowork](https://claude.com/docs/cowork/overview) 세션**: 이 머신의 Cowork 세션에서 Claude Code는 사용자가 Team 또는 Enterprise 계정으로 로그인하더라도 관리자 콘솔 설정을 가져오지 않으며, 머신에 배포된 정책을 읽습니다. 단, Claude Desktop 구성에서 `requireCoworkFullVmSandbox`를 설정한 경우에는 이 정책을 읽지 않습니다. 원격 Cowork 세션은 둘 다 받지 않습니다. 어떤 기기 파일이 Cowork에 적용되는지는 [정책이 적용되는 위치와 시점](https://code.claude.com/docs/ko/managed-settings.md#where-and-when-a-policy-applies)을, `Bash` 및 `WebFetch` 규칙이 Cowork의 도구에 적용되는 방식은 [MCP 권한 규칙](https://code.claude.com/docs/ko/permissions.md#mcp)을 참조하십시오.

로컬 세션과 SSH 세션에서는 데스크톱 앱이 각 사용자가 연결한 claude.ai 커넥터를 Claude Code에 직접 전달합니다. 어떤 설정 소스나 파일 위치를 사용하든 MCP 설정이나 `managed-mcp.json`은 이러한 커넥터에 적용되지 않습니다. 이러한 세션에서 커넥터의 도구를 차단하려면 조직의 [커넥터 도구 제어](https://code.claude.com/docs/ko/mcp.md#organization-controls-on-connector-tools)를 사용하십시오. [커넥터가 Claude Code에 전달되는 방식](https://code.claude.com/docs/ko/mcp.md#how-connectors-reach-claude-code)에서 각 세션 유형별로 커넥터를 관리하는 설정을 확인할 수 있습니다.

`permissions.disableBypassPermissionsMode`와 `disableAutoMode`는 사용자 설정과 프로젝트 설정에서도 작동하지만, 관리형 설정에 배치하면 사용자가 이를 재정의할 수 없습니다.

관리형 소스에서만 설정할 수 있는 권한, 플러그인, 전달 관련 키는 [관리형 설정에서만 설정할 수 있는 키](https://code.claude.com/docs/ko/managed-settings.md#managed-only-settings)를 참조하십시오.

### 기기 관리 정책

IT 팀은 macOS에서는 MDM, Windows에서는 그룹 정책, Linux에서는 정책 파일을 통해 데스크톱 앱을 관리할 수 있습니다. 사용 가능한 정책에는 Claude Code 기능 활성화 또는 비활성화, macOS 및 Windows의 자동 업데이트 제어, 사용자 지정 배포 URL 설정이 포함됩니다.

* **macOS**: Jamf 또는 Kandji와 같은 도구를 사용하여 `com.anthropic.claudefordesktop` 환경설정 도메인을 통해 구성합니다
* **Windows**: `SOFTWARE\Policies\Claude`의 레지스트리를 통해 구성합니다
* **Linux**: 정책 키를 JSON 객체로 담고 있는 root 소유 파일 `/etc/claude-desktop/managed-settings.json`을 통해 구성합니다. root 이외의 사용자가 이 파일이나 해당 폴더에 쓸 수 있는 경우 Desktop은 이 파일을 거부합니다. 이 파일은 Claude Code의 [관리형 설정 파일](https://code.claude.com/docs/ko/managed-settings.md)과는 다른 파일입니다.

#### 조직으로 로그인 제한

Claude Desktop에 로그인할 수 있는 claude.ai 조직을 제한하려면 Claude Desktop 정책에서 `forceLoginOrgUUID`를 설정하십시오.

이 키를 사용하려면 Claude Desktop v1.2581.0 이상이 필요합니다.

Linux에서 이 키만 설정하는 정책 파일은 다음과 같습니다.

```json /etc/claude-desktop/managed-settings.json theme={null}
{
  "forceLoginOrgUUID": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

자리 표시자를 [claude.ai 관리자 설정](https://claude.ai/admin-settings/organization)에 표시되는 claude.ai 조직 ID로 바꾸십시오. 이 ID는 Claude Code의 [`forceLoginOrgUUID`](https://code.claude.com/docs/ko/settings-reference#forceloginorguuid) 설정에 사용하는 것과 동일한 ID입니다. 이 키를 설정하는 macOS 및 Windows 샘플은 HIPAA 대응 조직을 위한 Cowork 가이드의 [Claude Desktop 정책 배포](https://claude.com/docs/cowork/hipaa-setup#deploy-the-claude-desktop-policy)를 참조하십시오.

> [!WARNING]
>
> 배포하기 전에 `forceLoginOrgUUID` 값을 확인하십시오. ID가 조직의 ID가 아니면, 조직 구성원은 해당 ID를 가진 조직에도 속해 있지 않는 한 Claude Desktop을 사용할 수 없습니다. 복구하려면 올바른 ID를 배포하고 구성원이 Claude Desktop을 다시 시작하도록 하십시오.

Claude Code의 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `forceLoginMethod`와 `forceLoginOrgUUID`를 설정해도 Claude Desktop 로그인 화면은 변경되지 않습니다.

### 네트워크 액세스 요구 사항

Desktop은 Anthropic CDN 호스트에서 애플리케이션 코드와 사용자 콘텐츠를 로드합니다.

```text theme={null}
anthropic.com
*.anthropic.com
claude.ai
*.claude.ai
claude.com
*.claude.com
claude.app
*.claude.app
*.claudeusercontent.com
*.claudemcpcontent.com
```

[OTLP](https://code.claude.com/docs/ko/monitoring-usage.md), LLM 게이트웨이 또는 MCP 서버에 사용자 지정 포트를 구성하지 않는 한 트래픽은 포트 443의 HTTPS를 사용합니다.

프록시 서버, 사용자 지정 인증 기관, mTLS 및 독립 실행형 CLI에 필요한 도메인은 [네트워크 구성](https://code.claude.com/docs/ko/network-config.md)을 참조하십시오.

방화벽 와일드카드 수를 줄이려면 대신 다음 Anthropic 호스트를 허용하십시오. 일부 하위 도메인은 동적으로 생성되므로 와일드카드로 유지해야 합니다.

```text theme={null}
anthropic.com
api.anthropic.com
a-api.anthropic.com
a-cdn.anthropic.com
s-cdn.anthropic.com
assets-proxy.anthropic.com
claude.ai
a.claude.ai
assets.claude.ai
downloads.claude.ai
*.livepreview.claude.ai
claude.com
platform.claude.com
sso.claude.com
*.livepreview.claude.app
*.claudeusercontent.com
*.claudemcpcontent.com
```

조직에서 Claude에 대해 [IP 허용 목록](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting)을 활성화한 경우, `bridge.claudeusercontent.com`을 `claude.ai` 및 `api.anthropic.com`과 동일한 프록시 이그레스를 통해 라우팅하십시오. 그렇게 라우팅할 수 없는 경우, 프록시가 해당 호스트에 사용하는 이그레스 주소를 조직의 IP 허용 목록에 추가하되, 해당 주소가 조직 전용인 경우에만 추가하십시오. 공유 프록시 이그레스 범위를 추가하면 프록시 공급업체의 다른 고객도 허용됩니다.

Anthropic은 해당 호스트로의 연결이 들어오는 주소를 사용하여 조직의 IP 허용 목록과 대조합니다. 프록시가 해당 호스트의 트래픽을 허용 목록에 없는 주소를 통해 내보내면, 앱의 나머지 부분은 계속 작동하지만 Claude in Chrome 및 브리지를 통해 연결되는 기타 기능은 작동하지 않습니다.

[Google Fonts](https://code.claude.com/docs/ko/artifacts.md#improve-the-visual-design)에서 서체를 로드하는 [아티팩트](https://code.claude.com/docs/ko/artifacts.md)는 `fonts.googleapis.com`과 `fonts.gstatic.com`도 요청합니다. 두 호스트 모두 선택 사항입니다. 이를 차단하면 아티팩트는 폴백 서체로 렌더링됩니다. 페이지의 첫 렌더링이 지연되지 않고 글꼴 요청이 즉시 실패하도록, 응답 없이 드롭하는 대신 빠르게 거부하는 방식으로 차단하십시오.

아티팩트는 React나 차트 패키지 같은 JavaScript 라이브러리를 `cdnjs.cloudflare.com`, `cdn.jsdelivr.net`, `cdn.tailwindcss.com`, `code.jquery.com`, `unpkg.com`에서도 로드할 수 있으며, 그 외의 외부 호스트에서는 로드하지 않습니다. 이러한 호스트를 차단하면 라이브러리에 의존하는 아티팩트 부분이 작동하지 않으며, 차단된 글꼴과 달리 차단된 라이브러리에는 폴백이 없습니다. 여기에서도 빠르게 거부하는 방식으로 차단하여, 차단된 라이브러리 요청이 시간 초과될 때까지 대기하지 않고 즉시 실패하도록 하십시오.

### 인증 및 SSO

Team 및 Enterprise 조직은 모든 사용자에게 SSO를 요구할 수 있습니다. 플랜별 세부 정보는 [인증](https://code.claude.com/docs/ko/authentication.md)을, SAML 구성은 [SSO 설정](https://support.claude.com/en/articles/13132885-setting-up-single-sign-on-sso)을 참조하십시오. OIDC 설정은 [Claude Enterprise 관리자 가이드](https://claude.com/resources/tutorials/claude-enterprise-administrator-guide)에서 다룹니다.

### 데이터 처리

Claude Code는 로컬 세션에서는 코드를 로컬로 처리하며, 클라우드 세션에서는 조직이 [셀프 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)으로 라우팅하지 않는 한 Anthropic이 관리하는 인프라에서 처리합니다. 셀프 호스팅 환경을 포함한 클라우드 세션은 처리를 위해 대화와 코드 컨텍스트를 Anthropic API로 전송합니다. 로컬 세션과 SSH 세션은 배포에서 구성한 [모델 제공업체](#feature-comparison)로 이를 전송하며, 기본값은 Anthropic API입니다. 데이터 보존, 개인정보 보호 및 규정 준수에 대한 자세한 내용은 [데이터 처리](https://code.claude.com/docs/ko/data-usage.md)를 참조하십시오.

### 배포

Desktop은 엔터프라이즈 배포 도구를 통해 배포할 수 있습니다.

* **macOS**: `.dmg` 설치 프로그램을 사용하여 Jamf 또는 Kandji와 같은 MDM을 통해 배포합니다
* **Windows**: MSIX 패키지를 통해 배포합니다. 자동 설치를 포함한 엔터프라이즈 배포 옵션은 [Windows용 Claude Desktop 배포](https://support.claude.com/en/articles/12622703-deploy-claude-desktop-for-windows)를 참조하십시오

방화벽에서 허용 목록에 추가할 도메인은 위의 [네트워크 액세스 요구 사항](#network-access-requirements)을 참조하십시오. 프록시 설정, 사용자 지정 인증 기관 및 LLM 게이트웨이는 [네트워크 구성](https://code.claude.com/docs/ko/network-config.md)을 참조하십시오.

전체 엔터프라이즈 구성 참조는 [엔터프라이즈 구성 가이드](https://support.claude.com/en/articles/12622667-enterprise-configuration)를 참조하십시오.

## CLI에서 전환하시나요?

Claude Code CLI를 이미 사용 중이라면, Desktop은 동일한 기본 엔진을 그래픽 인터페이스로 실행합니다. 동일한 머신에서, 심지어 동일한 프로젝트에서도 두 가지를 동시에 실행할 수 있습니다. 각각은 자체 세션 목록을 유지하며, CLI 세션을 Desktop으로 가져올 수 있습니다. CLAUDE.md 파일을 통해 구성 및 프로젝트 메모리를 공유합니다.

CLI 세션을 Desktop으로 이동하려면 터미널에서 `/desktop`을 실행하세요. Claude가 세션을 저장하고 데스크톱 앱에서 연 후 CLI를 종료합니다. 이 명령은 Claude 구독으로 로그인했을 때 macOS 및 x64 Windows에서 사용 가능합니다. API 키 인증이나 Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry에서는 사용할 수 없습니다.

셸에서 [`claude --desktop`](https://code.claude.com/docs/ko/cli-reference#cli-flags)은 터미널 세션을 시작하지 않고 Desktop을 직접 엽니다. Claude Code v2.1.285 이상이 필요하며 `/desktop`과 동일한 플랫폼 및 로그인 요구 사항이 있습니다. 다른 인수가 없으면 현재 디렉토리에서 Desktop을 엽니다. Desktop에서 기존 CLI 세션을 열려면 이 디렉토리의 가장 최근 대화를 위해 `--continue`를 추가하거나, `/status`가 표시하는 세션 ID로 `--resume`을 추가합니다:

```bash theme={null}
claude --desktop --resume <session-id>
```

Claude Code는 `Opening session <session-id> in Claude Desktop`을 출력하고, 세션이 앱에서 열리며, 명령이 종료됩니다. 세션 이름은 ID 대신 작동하지 않습니다. Claude Code는 다른 터미널에서 열려 있거나 백그라운드에서 여전히 실행 중인 세션을 이동하지 않습니다. Claude Desktop이 설치되지 않은 경우, 명령은 다운로드 링크를 출력하고 종료됩니다.

Desktop 내에서 `/resume`을 사용하여 CLI 세션을 계속할 수도 있습니다. 이 명령은 로컬 세션에서 사용 가능하며, SSH, WSL 또는 클라우드 세션에서는 사용할 수 없습니다.

Desktop에서 터미널 세션을 계속하려면:

1. 터미널에서 세션을 닫습니다.
2. Desktop 프롬프트 상자에서 `/resume`을 입력합니다. Desktop은 이 컴퓨터의 CLI에서 시작한 세션을 나열합니다. 제목, 폴더 또는 브랜치로 검색하고 각 세션이 어디서 중단되었는지 미리 봅니다.
3. 세션을 선택합니다. 전체 대화 및 컨텍스트와 함께 앱에서 계속됩니다.

Desktop은 복사본이 아닌 동일한 세션을 계속하므로, 터미널에서 `claude --resume`을 실행하면 이후에도 여전히 찾을 수 있습니다.

> [!TIP]
>
> Desktop과 CLI를 언제 사용할지: 한 창에서 병렬 세션을 관리하거나, 창을 나란히 배열하거나, 변경 사항을 시각적으로 검토하려면 Desktop을 사용하세요. 스크립팅, 자동화가 필요하거나 터미널 워크플로를 선호하면 CLI를 사용하세요.

### CLI 플래그 동등물

이 표는 일반적인 CLI 플래그에 대한 데스크톱 앱 동등물을 보여줍니다. 나열되지 않은 플래그는 스크립팅 또는 자동화를 위해 설계되었기 때문에 데스크톱 동등물이 없습니다.

| CLI | Desktop 동등물 |
| - | - |
| `--model sonnet` | 프롬프트 상자 아래 행의 모델 선택기 |
| `--resume`, `--continue` | 사이드바에서 세션을 클릭하거나, 프롬프트 상자에서 `/resume`을 입력하여 CLI에서 시작한 세션을 선택합니다 |
| `--permission-mode` | 프롬프트 상자 아래 행의 모드 선택기 |
| `--dangerously-skip-permissions` | 권한 모드 무시. Pro, Max 및 Ultra 플랜에서는 **설정 > Code** 또는 **설정 > Claude Code**에서 "권한 모드 무시 허용"을 활성화합니다. Team 및 Enterprise 플랜에서는 조직 정책이 제어합니다 |
| `--add-dir` | 로컬 및 SSH 세션에서는 [세션에 폴더 추가](#add-folders-to-a-session), 클라우드 세션에서는 [여러 저장소](#run-long-running-tasks-in-the-cloud) 선택 |
| `--allowedTools`, `--disallowedTools` | 세션별 동등물 없음. [설정 파일](https://code.claude.com/docs/ko/settings.md)의 권한 규칙이 여전히 적용됩니다. |
| `--verbose` | [상세 보기 모드](#switch-view-modes) |
| `--print`, `--output-format` | 사용할 수 없음. Desktop은 대화형만 가능합니다. |
| `ANTHROPIC_MODEL` 환경 변수 | 프롬프트 상자 아래 행의 모델 선택기 |
| `MAX_THINKING_TOKENS` 환경 변수 | [확장 사고 끄기](#turn-off-extended-thinking)를 참조하세요 |

### 공유 구성

Desktop과 CLI는 동일한 구성 파일을 읽으므로 설정이 그대로 유지됩니다:

* 프로젝트의 **[CLAUDE.md](https://code.claude.com/docs/ko/memory.md)** 및 `CLAUDE.local.md` 파일은 둘 다에서 사용됩니다
* `~/.claude.json` 또는 `.mcp.json`에 구성된 \*\*[MCP 서버](https://code.claude.com/docs/ko/mcp.md)\*\*는 둘 다에서 작동합니다
* 설정에 정의된 **[훅](https://code.claude.com/docs/ko/hooks.md)** 및 \*\*[스킬](https://code.claude.com/docs/ko/skills.md)\*\*은 둘 다에 적용됩니다
* `~/.claude.json` 및 `~/.claude/settings.json`의 \*\*[설정](https://code.claude.com/docs/ko/settings.md)\*\*은 공유됩니다. `settings.json`의 권한 규칙, 허용된 도구 및 기타 설정은 Desktop 세션에 적용됩니다.
* **모델**: 동일한 [모델](https://code.claude.com/docs/ko/model-config.md#available-models)을 둘 다에서 사용할 수 있습니다. Desktop에서는 프롬프트 상자 아래 행의 모델 선택기에서 모델을 선택합니다. 동일한 선택기에서 세션 중간에 모델을 변경할 수 있습니다.

#### Claude Desktop 채팅 앱의 MCP 서버

Desktop 앱은 `claude_desktop_config.json`에서 MCP 서버를 로컬 Code 탭 세션으로 로드하며, `~/.claude.json` 및 `.mcp.json`의 서버와 함께 로드됩니다. `claude_desktop_config.json`에서 정의한 서버는 Desktop 채팅 사용 환경과 로컬 Code 탭 세션 모두에서 사용 가능합니다.

`claude_desktop_config.json`과 `~/.claude.json` 또는 `.mcp.json`에서 동일한 서버 이름을 정의하면, 로컬 세션의 Code 탭은 한 번 연결되고 `claude_desktop_config.json` 정의를 사용합니다.

앱은 또한 `~/.claude.json`의 stdio 서버를 로컬 세션의 임베드된 CLI로 다시 전달합니다. `~/.claude.json`(사용자 범위)의 최상위 수준과 `.mcp.json`이 동일한 stdio 서버 이름을 정의할 때, Code 탭은 `~/.claude.json` 정의를 사용하며, CLI [범위 계층](https://code.claude.com/docs/ko/mcp.md#scope-hierarchy-and-precedence)에서 벗어납니다.

> [!NOTE]
>
> 독립 실행형 CLI는 `claude_desktop_config.json`을 읽지 않습니다. macOS 및 WSL에서는 `claude mcp add-from-claude-desktop`을 실행하여 해당 서버를 `~/.claude.json`으로 복사합니다. 가져오기 흐름 및 범위 옵션은 [Claude Desktop에서 MCP 서버 가져오기](https://code.claude.com/docs/ko/mcp.md#import-mcp-servers-from-claude-desktop)를 참조하세요.

### 기능 비교

이 표는 CLI와 Desktop 간의 핵심 기능을 비교합니다. CLI 플래그의 전체 목록은 [CLI 참조](https://code.claude.com/docs/ko/cli-reference.md)를 참조하세요.

| 기능 | CLI | Desktop |
| - | - | - |
| 권한 모드 | `dontAsk`를 포함한 모든 모드 | 수동, 편집 수락, 계획 및 자동. 권한 무시는 활성화되면 모드 선택기에 나타나며, Pro, Max 및 Ultra 플랜에서는 설정 토글을 통해, Team 및 Enterprise 플랜에서는 조직 정책을 통해 활성화됩니다 |
| [타사 제공자](https://code.claude.com/docs/ko/third-party-integrations.md) | Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry | 기본적으로 Anthropic의 API. 게이트웨이 라우팅의 경우 [데스크톱 앱을 게이트웨이에 연결](https://code.claude.com/docs/ko/llm-gateway-connect.md#desktop-app)을 참조하세요. Code 탭을 Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 또는 자체 호스팅 LLM 게이트웨이에서 실행하려면 [Claude Desktop on 3P](https://claude.com/docs/third-party/claude-desktop/overview)를 참조하세요. |
| [MCP 서버](https://code.claude.com/docs/ko/mcp.md) | 설정 파일에서 구성 | 로컬 및 SSH 세션의 커넥터 UI 또는 설정 파일 |
| [플러그인](https://code.claude.com/docs/ko/plugins/overview.md) | `/plugin` 명령 | 플러그인 관리자 UI |
| @mention 파일 | 텍스트 기반 | 자동 완성 포함(클라우드 세션의 첫 메시지 제외) |
| 파일 첨부 | 사용할 수 없음 | 이미지, PDF |
| 세션 격리 | [`--worktree`](https://code.claude.com/docs/ko/cli-reference) 플래그 | [자체 worktree에서 세션 실행](#run-a-session-in-its-own-worktree) |
| 여러 세션 | 별도 터미널 | 사이드바 탭 |
| 반복 작업 | Cron 작업, CI 파이프라인 | [예약 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md) |
| 컴퓨터 사용 | macOS에서 [`/mcp`](https://code.claude.com/docs/ko/computer-use)를 통해 활성화 | macOS 및 Windows에서 [앱 및 화면 제어](#let-claude-use-your-computer) |
| iOS 시뮬레이터 | [컴퓨터 사용](https://code.claude.com/docs/ko/computer-use.md#test-a-simulator-flow)을 통해 시뮬레이터 구동 | [iOS 시뮬레이터 창](https://code.claude.com/docs/ko/desktop-ios-simulator.md)이 자동으로 열립니다 |
| Dispatch 통합 | 사용할 수 없음 | 사이드바의 [Dispatch 세션](#sessions-from-dispatch) |
| 스크립팅 및 자동화 | [`--print`](https://code.claude.com/docs/ko/cli-reference), [Agent SDK](https://code.claude.com/docs/ko/headless.md) | 사용할 수 없음 |

### Desktop에서 사용할 수 없는 기능

다음 기능은 Desktop에서 사용할 수 없습니다(명시된 경우 제외):

* **타사 제공자**: Desktop은 기본적으로 Anthropic의 API에 연결됩니다. Desktop을 게이트웨이를 통해 라우팅하거나 Code 탭을 Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 또는 자체 호스팅 LLM 게이트웨이에서 실행하려면 [타사 제공자 행](#feature-comparison)의 링크를 따르세요.
* **Linux (베타)**: 컴퓨터 사용은 아직 Linux 데스크톱 앱에서 사용할 수 없습니다. [Claude Desktop on Linux](https://code.claude.com/docs/ko/desktop-linux.md)를 참조하세요.
* **인라인 코드 제안**: Desktop은 자동 완성 스타일의 코드 완성을 제공하지 않습니다. 대화형 프롬프트 및 명시적 코드 변경을 통해 작동하며, Claude가 응답한 후 [다음 프롬프트를 제안](#accept-a-suggested-prompt)할 수 있습니다.
* **에이전트 팀**: 공유 작업 목록에서 팀 리더로서의 Claude가 팀원에게 작업을 할당하는 조정된 팀은 [CLI](https://code.claude.com/docs/ko/agent-teams.md)에서 사용 가능하며, Desktop에서는 사용할 수 없습니다. 한 세션 내에서 다중 에이전트 작업의 경우 Desktop에서 실행되는 [동적 워크플로](https://code.claude.com/docs/ko/workflows.md)를 사용하세요. Claude는 또한 [다른 세션에 직접 메시지를 보내고 관리](#work-across-sessions)할 수 있습니다.
* **터미널 대화 명령**: 터미널에서 대화형 패널을 여는 기본 제공 명령은 Code 탭에서 다르게 작동합니다. [설정 파일](https://code.claude.com/docs/ko/settings.md)을 직접 편집하여 권한 규칙 및 구성을 관리하거나, 독립 실행형 CLI에서 명령을 실행합니다.
  * 인수 형식이 없는 명령(예: `/permissions`)은 `isn't available in this environment`로 응답합니다.
  * `/config`는 **설정 > Code** 또는 **설정 > Claude Code**를 엽니다.

## 문제 해결

아래 섹션은 데스크톱 앱에 특정한 문제를 다룹니다. `API Error: 500`, `529 Overloaded`, `429`, `Prompt is too long`과 같이 채팅에 나타나는 런타임 API 오류의 경우 [오류 참조](https://code.claude.com/docs/ko/errors.md)를 참조하세요.

### 버전 확인하기

실행 중인 데스크톱 앱의 버전을 보려면:

* **macOS**: 메뉴 모음에서 **Claude**를 클릭한 다음 **About Claude**를 클릭합니다
* **Windows**: **Help**를 클릭한 다음 **About Claude**를 클릭합니다

버전 번호를 클릭하여 클립보드에 복사합니다.

#### Code 탭의 Claude Code 버전

세션에서 실행되는 Claude Code 버전을 확인하려면 **Code** 탭의 로컬 세션에서 `/status`를 입력하고 **Claude Code** 행을 확인합니다. 이 행에는 `2.1.286`과 같은 버전이 표시됩니다.

로컬 세션용 최신 버전을 받으려면 macOS에서는 \*\*Claude > Check for Updates…\*\*를, Windows에서는 \*\*Help > Check for Updates…\*\*를 연 다음 새 세션을 시작합니다.

로컬 세션에서 **Code** 탭은 자체 버전 번호를 가진 별도의 Claude Code 사본을 실행합니다. 데스크톱 앱이 해당 사본을 다운로드하고 업데이트하므로 터미널의 `claude` 명령과 버전이 다를 수 있으며, 한쪽을 업데이트해도 다른 쪽은 업데이트되지 않습니다.

### 사용 중인 레이아웃 확인하기

새 세션에서 [환경](#start-a-session)이 프롬프트 상자 아래가 아닌 위에 표시되면 이전 레이아웃을 사용 중인 것입니다:

* **[v2.37337.0 이전 데스크톱](#check-your-version)**: 업데이트하여 현재 레이아웃을 사용합니다. macOS에서는 \*\*Claude > Check for Updates…\*\*를, Windows에서는 \*\*Help > Check for Updates…\*\*를 선택합니다.
* **[타사 제공업체](https://code.claude.com/docs/ko/third-party-integrations.md)를 사용하며 세션이 컴퓨터에서 실행되는 경우**: 현재 레이아웃에는 Claude Desktop v3.1623.0 이상이 필요하므로 [버전을 확인합니다](#check-your-version). 업데이트하려면 macOS에서는 \*\*Claude > Check for Updates…\*\*를, Windows에서는 \*\*Help > Check for Updates…\*\*를 선택합니다. 조직에서 [자동 업데이트를 끈 경우](#device-management-policies) \*\*Check for Updates…\*\*가 숨겨지므로 관리자에게 v3.1623.0 이상을 요청하세요.
* **타사 제공업체를 사용하며 세션이 조직의 인프라에서 실행되는 경우**: 현재 레이아웃에는 Claude Desktop v4.29.0 이상이 필요하므로 [버전을 확인합니다](#check-your-version). 이전 버전을 사용 중이라면 관리자에게 v4.29.0 이상을 요청하세요. 세션이 어디에서 실행되는지 모르는 경우 관리자에게 문의하세요.

이전 레이아웃에서는 프롬프트 상자 위에서 환경과 프로젝트 폴더 또는 저장소를 선택하고, 그 아래 행에서 권한 모드와 모델을 선택합니다. 이전 레이아웃에는 [세션 세부 정보 패널](#see-session-details)과 [저장된 로컬 및 SSH 환경](#create-a-saved-environment)이 없습니다.

### Code 탭의 403 또는 인증 오류

Code 탭을 사용할 때 `Error 403: Forbidden` 또는 기타 인증 실패가 표시되면:

1. 앱 메뉴에서 로그아웃했다가 다시 로그인합니다. 이것이 가장 일반적인 수정입니다.
2. 활성 유료 구독이 있는지 확인합니다: Pro, Max, Ultra, Team 또는 Enterprise.
3. CLI는 작동하지만 Desktop은 작동하지 않으면 데스크톱 앱을 완전히 종료하고 (창만 닫지 말고) 다시 열고 로그인합니다.
4. 인터넷 연결 및 프록시 설정을 확인합니다.

### 시작 시 빈 화면 또는 정지된 화면

앱이 열리지만 빈 화면이나 응답하지 않는 화면이 표시되면:

1. 앱을 다시 시작합니다.
2. 보류 중인 업데이트를 확인합니다. macOS 및 Windows에서 앱은 시작 시 자동으로 업데이트됩니다. Linux에서는 [Claude Desktop on Linux](https://code.claude.com/docs/ko/desktop-linux.md)에 설명된 대로 apt를 통해 업데이트합니다.
3. 관리되는 네트워크에서 방화벽이 [네트워크 액세스 요구 사항](#network-access-requirements)의 CDN 호스트를 허용하는지 확인합니다.
4. Windows에서 Event Viewer의 **Windows Logs → Application** 아래에서 충돌 로그를 확인합니다.

### "Failed to load session"

`Failed to load session`이 표시되면 선택한 폴더가 더 이상 존재하지 않거나, Git 저장소에 설치되지 않은 Git LFS가 필요하거나, 파일 권한이 액세스를 방지할 수 있습니다. 다른 폴더를 선택하거나 앱을 다시 시작해 보세요.

### 세션이 설치된 도구를 찾지 못함

Claude가 `npm`, `node` 또는 기타 CLI 명령과 같은 도구를 찾을 수 없으면 도구가 일반 터미널에서 작동하는지 확인하고, 셸 프로필이 PATH를 올바르게 설정하는지 확인하고, 데스크톱 앱을 다시 시작하여 환경 변수를 다시 로드합니다.

### Git 및 Git LFS 오류

자신의 worktree에서 실행되는 세션에는 Git이 필요합니다. "Git is required"가 표시되면 [Git](https://git-scm.com/downloads)을 설치하거나 Windows에서 [Windows용 Git](https://git-scm.com/downloads/win)을 설치하고 다시 시도합니다. Windows에서 1.49585.0 이전의 Claude Desktop 버전은 로컬 세션을 시작하기 전에 Git을 요청했습니다. 해당 프롬프트가 표시되고 worktree를 사용하지 않으면 앱을 업데이트합니다.

"Git LFS is required by this repository but is not installed"가 표시되면 [git-lfs.com](https://git-lfs.com/)에서 Git LFS를 설치하고 `git lfs install`을 실행한 다음 앱을 다시 시작합니다.

### Windows에서 MCP 서버가 작동하지 않음

MCP 서버 토글이 응답하지 않거나 Windows에서 서버가 연결되지 않으면 서버가 설정에 올바르게 구성되었는지 확인하고, 앱을 다시 시작하고, Task Manager에서 서버 프로세스가 실행 중인지 확인하고, 연결 오류에 대한 서버 로그를 검토합니다.

### SSH host key verification failed

다음 메시지는 각각 Desktop이 [호스트 키](#check-a-remote-machines-host-key)를 거부했음을 의미합니다:

* `Couldn't connect to <host>` 카드의 **View details** 아래에 표시되는 `SSH host key verification failed` 또는 `Host denied (verification failed)`
* 프롬프트 상자 옆 또는 **Test connection** 후에 표시되는 `Connection failed: Host key changed or not trusted`
* 연결이 끊긴 세션에 표시되는 `<host>'s host key is not trusted` 또는 `<host>'s host key has changed`

Desktop은 일반적으로 키가 컴퓨터에 저장된 키와 다르거나 해당 머신에 대해 저장된 키가 없기 때문에 키를 거부합니다. 재구축되거나 재설치된 머신은 일반적으로 새 키를 제시하며, 연결을 가로채는 무언가도 마찬가지입니다. 다시 연결하기 전에 Desktop이 메시지와 함께 표시하는 내용부터 시작하여 키를 확인합니다:

* **Windows를 사용 중이고 Desktop에 `Connection failed: Host key changed or not trusted`가 표시되는 경우**: 먼저 [OpenSSH 클라이언트 누락](#ssh-host-key-refused-on-windows-without-an-openssh-client) 가능성을 배제합니다
* **Desktop이 `UserKnownHostsFile`을 설정하라고 안내하는 경우**: `~/.ssh/config`에서 이를 `~/.ssh/known_hosts`로 설정한 다음 [터미널에서 키를 확인합니다](#check-the-host-key-from-a-terminal)
* **Review new key 버튼이 표시되는 경우**: 버튼을 선택하고 Desktop이 표시하는 지문을 머신 자체의 지문과 [비교합니다](#check-a-remote-machines-host-key). 일치하면 **Trust new key**를 선택하여 저장된 키를 교체합니다. 그렇지 않으면 **Cancel**을 선택합니다.
* **Review new key 버튼이 표시되지 않거나, Desktop에 `Couldn't show the new key`가 표시되거나, Trust new key 후에도 Desktop이 키를 다시 거부하는 경우**: [터미널에서 키를 확인합니다](#check-the-host-key-from-a-terminal)

#### 터미널에서 호스트 키 확인하기

Desktop의 [SSH 연결](#ssh-sessions)에 있는 **SSH host** 값으로 컴퓨터에서 `ssh <SSH host>`를 실행합니다. 연결에 **SSH port** 값이 있으면 `-p <SSH port>`를 추가합니다. Windows에서는 Desktop이 Git Bash 또는 WSL의 `ssh`로 연결하지 않으므로 PowerShell을 사용합니다. PowerShell에서 `ssh`를 찾을 수 없으면 [Microsoft의 OpenSSH 클라이언트를 설치합니다](#ssh-host-key-refused-on-windows-without-an-openssh-client).

`ssh`가 메시지에서 어떤 머신을 언급하는지 확인한 다음(`<SSH host>`가 아닌 점프 호스트일 수 있습니다), 해당하는 경우를 따릅니다:

* **`ssh`가 계속 연결할지 묻는 경우**: 표시된 지문을 해당 머신 자체의 지문과 [비교합니다](#check-a-remote-machines-host-key). 일치하는 경우에만 `yes`로 답합니다.
* **`ssh`가 호스트 키가 변경되었다고 경고하는 경우**: 경고의 지문을 해당 머신 자체의 지문과 [비교합니다](#check-a-remote-machines-host-key). 일치하는 경우에만 `Offending <type> key in <file>:<line>`이 가리키는 줄을 삭제하고 `ssh`를 다시 실행합니다. `ssh`가 다른 줄에 대해 다시 경고하면 앞서와 같이 비교, 삭제, 재실행을 반복합니다.
* **`ssh`가 묻지 않고 알 수 없는 키를 거부하는 경우**: 확인 중인 연결을 통해서가 아니라 해당 머신을 관리하는 사람에게서 그 머신의 `known_hosts` 줄을 받습니다. `ssh` 메시지에 나온 이름을 호스트 이름으로 하여 해당 줄을 `known_hosts` 파일에 추가하고 `ssh`를 다시 실행합니다.
* **`ssh`가 호스트 키에 대해 묻지 않고 바로 로그인을 진행하는 경우**: 아직 암호를 입력하지 마세요. [`ssh`가 이미 신뢰하는 키를 확인합니다](#check-the-keys-that-ssh-already-trusts).

확인했거나 추가한 키를 `ssh`가 수락하면 Desktop에서 재시도합니다. Desktop이 키를 다시 거부하면 [SSH 문제에 대한 Desktop 로그 가져오기](#get-desktops-logs-for-an-ssh-problem)를 참조하세요.

##### `ssh`가 이미 신뢰하는 키 확인하기

동일한 `ssh` 명령에 `-v -S none`을 추가하여 다시 실행합니다. 출력에서 `Server host key:` 줄은 지문을 보여 주고, 그다음 `Host '<name>' is known` 줄은 해당 지문이 속한 머신의 이름을 보여 줍니다. 찾은 각 지문을 해당 머신 자체의 지문과 [비교합니다](#check-a-remote-machines-host-key).

* **점프 호스트에 `Server host key:` 줄이 없는 경우**: `ssh -v -S none <jump host>`도 실행하고 같은 방식으로 해당 지문을 비교합니다.
* **지문이 일치하지 않거나 확인할 수 없는 경우**: 다시 연결하지 마세요. 저장된 키를 제거합니다. `Host '<name>' is known` 아래의 `Found key in <file>:<line>` 줄이 키가 저장된 파일을 가리킵니다. `ssh-keygen -R "<name>" -f <file>`을 실행합니다. 호스트 키를 둘 이상의 파일에 보관하는 경우 각 파일에서 키를 제거합니다. 파일을 변경할 수 없으면 컴퓨터를 관리하는 사람에게 알립니다.
* **모든 지문이 일치하는 경우**: Desktop에서 재시도합니다. Desktop이 키를 다시 거부하면 [SSH 문제에 대한 Desktop 로그 가져오기](#get-desktops-logs-for-an-ssh-problem)를 참조하세요.

### OpenSSH 클라이언트가 없는 Windows에서 SSH 호스트 키가 거부됨

OpenSSH 클라이언트가 없는 Windows에서는 Desktop이 올바른 호스트 키조차 `Connection failed: Host key changed or not trusted`와 함께 거부합니다. Desktop은 저장된 키를 조회하는 데 이 클라이언트가 필요합니다. 클라이언트가 있는지 확인하려면 PowerShell에서 `ssh`를 실행합니다. PowerShell이 `ssh`를 인식하지 못하면 [Microsoft의 OpenSSH 클라이언트](https://learn.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse)를 설치하고 Desktop을 다시 시작합니다.

그런 다음 다시 연결합니다. Desktop이 처음으로 연결할지 묻는 경우 신뢰하기 전에 [머신의 호스트 키를 확인합니다](#check-a-remote-machines-host-key). Desktop이 여전히 키를 거부하면 [SSH host key verification failed](#ssh-host-key-verification-failed) 아래의 다른 경우를 따릅니다.

### 로그인 후 SSH 연결 실패

이 표에서 카드의 제목 또는 오류 메시지 끝에 있는 코드를 찾은 다음 마지막 열의 안내를 따릅니다. 메시지를 보려면 실패 카드에서 **View details**를 선택합니다.

| 카드의 제목 | 코드 | 조치 |
| - | - | - |
| `<host>'s SSH server has SFTP turned off` | `[SFTP_UNAVAILABLE]` | [원격 머신 요구 사항](#remote-machine-requirements-for-ssh-sessions)에 설명된 대로 서버의 `sshd_config`에서 SFTP를 켭니다 |
| `SFTP doesn't start on <host>` | `[SFTP_NOT_STARTED]` | 컴퓨터의 터미널에서 `sftp`로 동일한 호스트에 연결하여 무엇이 시작을 막는지 확인한 다음, Desktop 메시지에 언급된 설정과 파일을 확인합니다 |
| `<host> allows too few SSH sessions per connection` | `[SESSION_LIMIT]` | Claude Desktop v3.1623.0 이상으로 업데이트하거나, 서버의 `sshd_config`에서 `MaxSessions`를 높입니다. 예를 들어 OpenSSH 기본값인 10으로 설정합니다 |
| `<host> is out of disk space` | `[ENOSPC]` 또는 `[EDQUOT]` | 원격 머신의 홈 디렉터리 또는 `/tmp`에서 공간 또는 할당량을 확보합니다 |
| `Free up disk space on this computer` | `Couldn't prepare the deploy locally`로 시작하는 메시지의 `[ENOSPC]` 또는 `[EDQUOT]` | 컴퓨터의 공간을 확보합니다 |
| `Claude Code won't start on <host>` | `[CLI_UNRESPONSIVE]` | 1분 정도 기다린 후 다시 시도합니다. 계속 실패하면 원격 머신에서 메시지에 언급된 명령을 실행하여 Claude Code가 그곳에서 응답하는지 확인합니다. |

그 외의 메시지는 [원격 머신 요구 사항](#remote-machine-requirements-for-ssh-sessions)을 확인합니다.

### SSH 문제에 대한 Desktop 로그 가져오기

Desktop의 SSH 연결 기록인 `ssh.log`는 **Help** 메뉴에서 저장하는 Desktop 로그 zip 파일에 포함되어 있습니다. 저장하려면 **Help > Troubleshooting**을 열고 사용 중인 시스템에 해당하는 항목을 선택합니다:

* **macOS**: **Show Logs in Finder**
* **Windows**: **Show Logs in File Explorer**
* **Linux**: **Show Logs in File Manager**

파일을 보내기 전에 내용을 살펴보세요. 환경의 이름과 기타 세부 정보가 포함될 수 있습니다. `<host>`와 `<user>`는 Desktop이 대체한 이름을 나타냅니다. Desktop이 모든 이름을 대체하지는 않으므로 SSH 호스트 또는 사용자 이름이 작성된 그대로 나타날 수 있습니다. zip 파일을 다른 사람에게 보내는 경우 로그에 해당 호스트 이름이 없을 수 있으므로 어떤 호스트가 언제 실패했는지 알려 주세요.

zip 파일에는 Desktop이 원격 머신에 설치하는 도우미 프로그램의 로그가 포함되어 있지 않습니다. 해당 로그도 가져오려면 연결한 사용자의 홈 디렉터리에 있는 [`~/.claude/remote/run/`](#files-and-processes-on-the-remote-machine) 아래 도우미 폴더에서 `remote-server.log`를 복사합니다. 이 파일도 보내기 전에 내용을 살펴보세요.

### 앱이 종료되지 않음

* **macOS**: Cmd+Q를 누릅니다. 앱이 응답하지 않으면 Cmd+Option+Esc로 강제 종료를 사용하고 Claude를 선택한 다음 Force Quit를 클릭합니다.
* **Windows**: Ctrl+Shift+Esc로 Task Manager를 사용하여 Claude 프로세스를 종료합니다.

### Windows 특정 문제

* **설치 후 PATH가 업데이트되지 않음**: 새 터미널 창을 엽니다. PATH 업데이트는 새 터미널 세션에만 적용됩니다.
* **동시 설치 오류**: 진행 중인 다른 설치에 대한 오류가 표시되지만 없으면 관리자로 설치 프로그램을 실행해 보세요.

### CLI에서 열 때 "Branch doesn't exist yet"

클라우드 세션은 로컬 머신에 존재하지 않는 브랜치를 만들 수 있습니다. 세션에서 브랜치 이름을 클릭하고 **Copy branch name**을 선택한 다음 로컬로 가져옵니다:

```bash theme={null}
git fetch origin <branch-name>
git checkout <branch-name>
```

### 여전히 막혔나요?

* 데스크톱 앱에서 Help → Get Support를 열거나 [Claude 지원 센터](https://support.claude.com/)를 직접 방문합니다
* 독립 실행형 `claude` CLI에서도 재현되는 문제의 경우 [GitHub Issues](https://github.com/anthropics/claude-code/issues)에서 검색하거나 버그를 제출합니다

문제를 보고할 때 데스크톱 앱 버전, 운영 체제, 정확한 오류 메시지, 관련 로그를 포함합니다. macOS에서는 Console.app을 확인합니다. Windows에서는 Event Viewer → Windows Logs → Application을 확인합니다. 공개 이슈에 게시하기 전에 로그 발췌를 검토하세요. 환경의 파일 경로 및 기타 세부 정보가 포함될 수 있습니다.
