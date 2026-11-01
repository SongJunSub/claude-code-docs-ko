> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 키보드 단축키 사용자 정의

> keybindings 구성 파일을 사용하여 Claude Code에서 키보드 단축키를 사용자 정의합니다.

Claude Code는 사용자 정의 가능한 키보드 단축키를 지원합니다. `/keybindings`를 실행하여 `~/.claude/keybindings.json`에서 구성 파일을 만들거나 열 수 있습니다.

## 구성 파일

keybindings 구성 파일은 `bindings` 배열이 있는 객체입니다. 각 블록은 컨텍스트와 키 입력을 작업에 매핑하는 맵을 지정합니다.

> [!NOTE]
>
> keybindings 파일의 변경 사항은 자동으로 감지되고 Claude Code를 다시 시작하지 않고도 적용됩니다.

| 필드 | 설명 |
| :- | :- |
| `$schema` | 편집기 자동 완성을 위한 선택적 JSON Schema URL |
| `$docs` | 선택적 설명서 URL |
| `bindings` | 컨텍스트별 바인딩 블록 배열 |

이 예제는 채팅 컨텍스트에서 `Ctrl+E`를 외부 편집기를 열기에 바인딩하고 `Ctrl+S`를 바인딩 해제합니다:

```json theme={null}
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/ko/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+e": "chat:externalEditor",
        "ctrl+s": null
      }
    }
  ]
}
```

## 컨텍스트

각 바인딩 블록은 바인딩이 적용되는 **컨텍스트**를 지정합니다:

| 컨텍스트 | 설명 |
| :- | :- |
| `Global` | 앱의 모든 곳에 적용됩니다 |
| `Chat` | 메인 채팅 입력 영역 |
| `Autocomplete` | 자동완성 메뉴가 열려 있습니다 |
| `Settings` | 설정 메뉴 |
| `Confirmation` | 권한 및 확인 대화상자 |
| `Tabs` | 탭 네비게이션 컴포넌트 |
| `Help` | 도움말 메뉴가 표시됩니다 |
| `Transcript` | 트랜스크립트 뷰어 |
| `HistorySearch` | 히스토리 검색 모드 (Ctrl+R) |
| `Task` | 포그라운드에서 작업이 실행 중입니다 |
| `ThemePicker` | 테마 선택기 대화상자 |
| `Attachments` | 선택 대화상자에서 이미지 첨부 네비게이션 |
| `Footer` | 푸터 표시기 네비게이션 (작업, 팀, diff, 아티팩트) |
| `MessageSelector` | 되돌리기 및 요약 대화상자 메시지 선택 |
| `DiffDialog` | [diff 뷰어](#diff-actions) 네비게이션 |
| `DiffPanel` | [diff 패널](https://code.claude.com/docs/ko/interactive-mode.md#diff-panel)이 열려 있습니다 |
| `ModelPicker` | 모델 선택기 노력 수준 |
| `EffortSlider` | `/effort`로 열린 노력 슬라이더 |
| `Select` | 일반 선택/목록 컴포넌트 |
| `Plugin` | 플러그인 대화상자 (찾아보기, 발견, 관리) |
| `AbovePrompt` | [프롬프트 위 영역](#above-prompt-actions) 또는 그 안의 버튼에 키보드 포커스가 있습니다 |
| `AbovePromptInput` | 프롬프트 위 영역 또는 mod 창의 입력 필드에 키보드 포커스가 있습니다 |
| `AbovePromptSelect` | 프롬프트 위 영역 또는 mod 창의 선택 항목에 키보드 포커스가 있습니다 |
| `Pane` | [mod](https://code.claude.com/docs/ko/plugins/mods/interface.md#know-which-keys-your-mod-can-receive)가 그린 창에 키보드 포커스가 있습니다 |
| `PaneField` | mod 창의 입력 필드 또는 선택 항목에 키보드 포커스가 있습니다 |
| `Agents` | [에이전트 보기](https://code.claude.com/docs/ko/agent-view.md) (`claude agents`) |
| `Scroll` | 전체 화면 모드에서 대화 스크롤 및 텍스트 선택 |

v2.1.205 이전에는 `/doctor` 진단 화면에 대한 `Doctor` 컨텍스트와 `doctor:fix` 작업이 존재했습니다.

## 사용 가능한 작업

작업은 `namespace:action` 형식을 따르며, 예를 들어 메시지를 보내는 `chat:submit` 또는 작업 목록을 표시하는 `app:toggleTodos`와 같습니다. 각 컨텍스트에는 특정 작업이 사용 가능합니다.

### 앱 작업

`Global` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `app:interrupt` | Ctrl+C | 현재 작업 취소 |
| `app:exit` | Ctrl+D | Claude Code 종료. 800ms 내에 두 번 누르면 확인됨 |
| `app:redraw` | (바인딩 안 됨) | 터미널 다시 그리기 강제 실행 |
| `app:toggleTodos` | Ctrl+T | Claude의 할 일 체크리스트 표시 여부 전환. 이는 [`/tasks`](https://code.claude.com/docs/ko/commands) 백그라운드 작업 보기가 아닙니다 |
| `app:toggleTranscript` | Ctrl+O | 상세 기록 전환 |

### 기록 작업

명령 기록을 탐색하기 위한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `history:search` | Ctrl+R | 기록 검색 열기 |
| `history:previous` | Up | 이전 기록 항목 |
| `history:next` | Down | 다음 기록 항목 |

### 채팅 작업

`Chat` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `chat:cancel` | Escape | 현재 입력 취소 |
| `chat:clearInput` | Ctrl+L | 입력과 대화를 유지하면서 전체 화면 다시 그리기 강제 실행 |
| `chat:clearScreen` | Cmd+K | `chat:clearInput`과 동일. iTerm2 및 Terminal.app에서 Cmd+K의 동작 방식은 [대화 지우기](https://code.claude.com/docs/ko/fullscreen.md#clear-the-conversation)를 참조하세요 |
| `chat:killAgents` | Ctrl+X Ctrl+K | 이 세션의 모든 실행 중인 [백그라운드 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)를 중지하고 나머지 세션에 대해 [아티팩트 자동 회신](https://code.claude.com/docs/ko/artifacts.md#let-claude-reply-to-comments-on-its-own)을 끕니다. 확인하려면 3초 이내에 단축키를 두 번 누릅니다. 백그라운드 서브에이전트의 권한 프롬프트가 열려 있는 동안에도 누를 수 있습니다 |
| `chat:cycleMode` | Shift+Tab\* | 권한 모드 순환 |
| `chat:modelPicker` | Meta+P | 모델 선택기 열기 |
| `chat:fastMode` | Meta+O | 빠른 모드 전환 |
| `chat:thinkingToggle` | Meta+T | 확장 사고 전환 |
| `chat:submit` | Enter | 메시지 제출 |
| `chat:queueSubmit` | Ctrl+X Enter | 메시지를 제출하고 차례를 기다리도록 표시: Claude가 작업 중일 때 Claude Code는 [메시지를 큐에 넣고](https://code.claude.com/docs/ko/interactive-mode.md#queue-messages-while-claude-works) 턴을 중단하지 않습니다. `chat:submit`과 달리 자동 완성 제안이 강조 표시되어 있어도 초안을 제출합니다. v2.1.247 이상 필요 |
| `chat:sendNow` | Ctrl+Enter, Ctrl+X Ctrl+S | [큐에 넣은 메시지](https://code.claude.com/docs/ko/interactive-mode.md#queue-messages-while-claude-works)와 초안을 즉시 보냅니다. [Claude Code가 큐에 넣은 메시지를 보낼 때](https://code.claude.com/docs/ko/interactive-mode.md#when-claude-code-sends-what-you-queued)는 Claude가 작업 중인 턴에 어떤 일이 발생하는지 설명합니다. 실행 중인 것이 없으면 키가 초안을 제출하고 [셸 모드](https://code.claude.com/docs/ko/interactive-mode.md#shell-mode-with-prefix)에서는 명령만 큐에 넣습니다. 확장 키를 보고하지 않는 터미널은 `Ctrl+Enter`를 일반 `Enter`로 전달하므로 `Ctrl+X Ctrl+S`가 모든 터미널에서 작동하는 바인딩입니다. v2.1.275 이상 필요 |
| `chat:newline` | Ctrl+J | 제출하지 않고 새 줄 삽입 |
| `chat:undo` | Ctrl+\_, Ctrl+Shift+- | 마지막 작업 실행 취소 |
| `chat:externalEditor` | Ctrl+G, Ctrl+X Ctrl+E | 외부 편집기에서 열기. [에이전트 보기 디스패치 입력](https://code.claude.com/docs/ko/agent-view.md#keyboard-shortcuts)도 이 작업의 단일 키 바인딩을 따릅니다 |
| `chat:stash` | Ctrl+S | 현재 프롬프트 숨기기 |
| `chat:imagePaste` | Ctrl+V (Windows 및 WSL에서 Alt+V) | 클립보드에서 이미지 붙여넣기. WSL에서는 두 바로 가기 모두 기본적으로 바인딩됩니다 |
| `command:<name>` | (바인딩 안 됨) | [명령](https://code.claude.com/docs/ko/commands.md) `/<name>` 실행. 예를 들어 `Chat` 블록에 `"meta+g": "command:compact"`를 지정하면 `Meta+G`가 `/compact`를 실행합니다 |

\*VT 모드가 없는 Windows에서(Node \<24.2.0/\<22.17.0, Bun \<1.2.23)는 기본값이 Meta+M입니다.

### 자동 완성 작업

`Autocomplete` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `autocomplete:accept` | Tab | 제안 수락 |
| `autocomplete:dismiss` | Escape | 메뉴 닫기 |
| `autocomplete:previous` | Up | 이전 제안 |
| `autocomplete:next` | Down | 다음 제안 |

### 확인 작업

`Confirmation` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `confirm:yes` | Enter | 작업 확인 |
| `confirm:no` | Escape | 작업 거부 |
| `confirm:previous` | Up | 이전 옵션 |
| `confirm:next` | Down | 다음 옵션 |
| `confirm:nextField` | Tab | `/fast` 대화 상자에서 빠른 모드를 켜거나 끕니다 |
| `confirm:previousField` | (바인딩 안 됨) | Claude Code는 이 작업에 응답하지 않으며, 이를 지정하는 `keybindings.json`은 계속 유효합니다 |
| `confirm:toggle` | Space | 선택 전환 |
| `confirm:cycleMode` | Shift+Tab\* | 파일 권한 프롬프트에서 열린 [댓글 필드](https://code.claude.com/docs/ko/permissions.md#add-a-comment-when-you-answer-a-permission-prompt)를 닫습니다. 열린 필드가 없으면 프롬프트가 해당 옵션을 제공할 때 나머지 세션에 대해 작업을 허용하는 옵션을 선택합니다 |

\*VT 모드가 없는 Windows에서(Node \<24.2.0/\<22.17.0, Bun \<1.2.23)는 기본값이 Meta+M입니다.

v2.1.257 이전에는 `confirm:toggleExplanation` 작업이 기본적으로 `Ctrl+E`에 바인딩되어 Bash 및 PowerShell 권한 프롬프트에서 명령의 모델 생성 설명을 표시했습니다.

대화 상자는 예/아니오 질문을 하지 않을 때도 `confirm:yes` 및 `confirm:no`를 사용하여 수락하고 취소합니다. 이 컨텍스트에서 `y` 또는 `n`과 같은 단순 문자를 바인딩하면 해당 문자도 키로 표시하지 않는 대화 상자에 작용합니다. `y` 및 `n`을 키로 표시하는 대화 상자는 해당 문자를 직접 읽고 바인딩이 필요하지 않습니다.

대부분의 대화 상자에서 `Ctrl+C` 또는 `Ctrl+D`를 두 번 누르면 Claude Code를 종료하는 대신 대화 상자를 닫습니다. 첫 번째 누름 후의 힌트는 두 번째 누름이 대화 상자를 닫는지 아니면 종료하는지 나타냅니다. 두 키 모두 [예약됨](#reserved-shortcuts)이며 다시 바인딩할 수 없습니다.

이 예제는 `y`를 `confirm:yes`에, `n`을 `confirm:no`에 바인딩합니다:

```json theme={null}
{
  "bindings": [
    {
      "context": "Confirmation",
      "bindings": {
        "y": "confirm:yes",
        "n": "confirm:no"
      }
    }
  ]
}
```

이러한 바인딩을 사용하면 [텍스트 필드](#text-fields)에 포커스가 있을 때도 `y` 및 `n`이 문자로 입력됩니다.

v2.1.280 이전에는 `y`도 기본적으로 `confirm:yes`에, `n`도 `confirm:no`에 바인딩되었습니다. v2.1.280 이전에 `/keybindings`로 `keybindings.json`을 생성한 경우 파일에 두 바인딩이 나열되고 해당 두 줄을 삭제할 때까지 유지됩니다.

### 권한 작업

권한 대화 상자에 대한 `Confirmation` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `permission:toggleDebug` | (바인딩 안 됨) | Claude Code는 이 작업에 응답하지 않으며, 이를 지정하는 `keybindings.json`은 계속 유효합니다 |

### 기록 작업

`Transcript` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `transcript:toggleShowAll` | Ctrl+E | 모든 콘텐츠 표시 전환 |
| `transcript:exit` | q, Ctrl+C, Escape | 기록 보기 종료 |

`transcript:toggleShowAll`은 클래식 렌더러에만 적용됩니다. [전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md)에서는 기록 뷰어가 모두 표시 전환을 제공하지 않습니다.

### 기록 검색 작업

`HistorySearch` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `historySearch:next` | Ctrl+R | 다음 일치 항목 |
| `historySearch:accept` | Escape, Tab | 선택 수락 |
| `historySearch:cancel` | Ctrl+C | 검색 취소 |
| `historySearch:execute` | Enter | 선택한 명령 실행 |
| `historySearch:cycleScope` | Ctrl+S | 범위 순환: 세션, 프로젝트, 모든 곳 |

`historySearch:next`, `historySearch:accept`, `historySearch:cancel` 및 `historySearch:execute` 기본값은 클래식 렌더러의 인라인 기록 검색에 적용되며, 이는 항상 모든 프로젝트의 프롬프트를 검색합니다. `historySearch:cycleScope`는 [전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md)에서만 적용되며, 여기서 `Ctrl+R`은 검색 대화 상자를 열고 `Ctrl+S`는 범위를 순환합니다. 대화 상자의 다른 키는 고정되어 있으며 다시 바인딩할 수 없습니다: `Enter` 또는 `Tab`은 강조 표시된 일치 항목을 프롬프트 입력에 배치하고 `Esc`는 취소합니다.

### 작업 작업

`Task` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `task:background` | Ctrl+B, Ctrl+X Ctrl+B | 현재 작업을 백그라운드로 이동 |

### 테마 작업

`ThemePicker` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `theme:toggleSyntaxHighlighting` | Ctrl+T | 구문 강조 전환 |

### 도움말 작업

`Help` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `help:dismiss` | Escape | 도움말 메뉴 닫기 |

### 탭 작업

`Tabs` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `tabs:next` | Tab, Right | 다음 탭 |
| `tabs:previous` | Shift+Tab, Left | 이전 탭 |

탭 대화 상자에서 `tabs:next` 및 `tabs:previous`는 탭 행에 포커스가 있을 때 탭을 전환합니다. `/help` 및 `/sandbox`와 같은 일부 대화 상자에서는 탭 전환 키가 탭의 콘텐츠 내부에서도 작동합니다.

`Up` 및 `Down`은 탭 행과 탭의 콘텐츠 사이의 포커스를 이동하고, 콘텐츠의 목록은 포커스가 있을 때만 키에 응답합니다.

### 첨부 파일 작업

`Attachments` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `attachments:next` | Right | 다음 첨부 파일 |
| `attachments:previous` | Left | 이전 첨부 파일 |
| `attachments:remove` | Backspace, Delete | 선택한 첨부 파일 제거 |
| `attachments:exit` | Down, Escape | 첨부 파일 탐색 종료 |

### 바닥글 작업

`Footer` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `footer:next` | Right | 다음 바닥글 항목 |
| `footer:previous` | Left | 이전 바닥글 항목 |
| `footer:up` | Up, Ctrl+P | 바닥글에서 위로 탐색 (맨 위에서 선택 해제) |
| `footer:down` | Down, Ctrl+N | 바닥글에서 아래로 탐색 |
| `footer:openSelected` | Enter | 선택한 바닥글 항목 열기 |
| `footer:clearSelection` | Escape | 바닥글 선택 지우기 |
| `footer:close` | x | 선택한 [에이전트](https://code.claude.com/docs/ko/sub-agents.md#observe-and-steer-running-forks) 또는 [워크플로](https://code.claude.com/docs/ko/workflows.md#manage-runs)를 중지하거나, 더 이상 실행 중이 아니면 해당 행을 닫습니다 |
| `footer:dismiss` | (바인딩 안 됨) | 이 작업에 키를 바인딩하는 것은 아무 효과가 없으며, 이를 명명하는 `keybindings.json`은 유효합니다. v2.1.281 이전에는 Backspace 및 Delete가 바인딩되어 바닥글에서 선택한 아티팩트 링크를 닫았습니다. |

바닥글 항목이 선택되어 있을 때(예: 프롬프트 아래의 에이전트 패널의 행) `Enter`는 `Chat` 컨텍스트에서 `Enter`를 `chat:queueSubmit` 또는 `chat:newline`으로 다시 바인딩한 경우에도 열립니다.

`Chat` 바인딩은 `Footer` 컨텍스트가 바인딩하지 않는 키(예: `chat:cycleMode`의 `Shift+Tab`)에서 항목이 선택되어 있을 때도 작동합니다.

### 메시지 선택기 작업

[되감기 메뉴](https://code.claude.com/docs/ko/checkpointing.md)의 메시지 목록에서 [선택 작업](#select-actions)과 해당 기본 키를 사용하여 메시지를 이동하고 선택합니다. 해당 작업에 대한 `Select` 바인딩도 여기에 적용됩니다. `MessageSelector` 컨텍스트에는 자체 작업이나 기본 바인딩이 없습니다. 이 목록에만 키를 변경하려면 `MessageSelector` 블록에서 `select:accept`와 같은 선택 작업을 바인딩하세요.

이 예제는 다른 목록을 변경하지 않고 되감기 메뉴에서 강조 표시된 메시지를 선택하기 위해 `o`를 `select:accept`에 바인딩합니다:

```json theme={null}
{
  "bindings": [
    {
      "context": "MessageSelector",
      "bindings": {
        "o": "select:accept"
      }
    }
  ]
}
```

v2.1.283 이전에는 이 목록이 `Select` 바인딩을 무시했으며 자체 작업이 있었습니다: `messageSelector:up`, `messageSelector:down`, `messageSelector:top`, `messageSelector:bottom` 및 `messageSelector:select`. `keybindings.json`이 해당 이름 중 하나를 바인딩하면 바인딩이 이 목록에서 동일한 작업을 수행하는 선택 작업으로 계속 작동합니다. `Home` 및 `End`는 목록의 양쪽 끝으로 이동합니다. v2.1.283 이전에는 `Shift+K` 및 `Shift+J`와 같은 키가 기본적으로 그렇게 했습니다.

### 차이 작업

이 작업들은 `/plugin`에서 [`cc-plugin-diff` mod](https://code.claude.com/docs/ko/plugins/mods/overview#mods-built-into-claude-code)를 비활성화한 후 [전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md) 외부에서 `/diff`가 여는 Claude Code의 이전 diff 뷰어에서만 작동합니다. 해당 mod가 활성화되어 있는 동안에는 `/diff`가 대신 [diff 대화 상자](https://code.claude.com/docs/ko/interactive-mode.md#diff-dialog)를 엽니다. 이 작업들을 지정하는 `keybindings.json`은 어느 경우든 오류 없이 로드됩니다.

`DiffDialog` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `diff:dismiss` | Escape | 차이 뷰어 닫기. 상세 보기에서는 파일 목록으로 돌아갑니다 |
| `diff:previousSource` | Left | 이전 차이 소스 |
| `diff:nextSource` | Right | 다음 차이 소스 |
| `diff:previousFile` | Up, K | 파일 목록의 이전 파일. 상세 보기에서 한 줄 위로 스크롤 |
| `diff:nextFile` | Down, J | 파일 목록의 다음 파일. 상세 보기에서 한 줄 아래로 스크롤 |
| `diff:back` | (바인딩 안 됨) | 차이 뷰어에서 뒤로 이동. Escape는 `diff:dismiss`를 통해 뒤로 작업을 수행합니다. 상세 보기에서 Left의 이전 기본값은 v2.1.203에서 제거되었습니다 |

파일 목록은 또한 [선택 작업](#select-actions)에 응답하며, 해당 기본 키와 `Select` 바인딩을 통해 응답합니다. `select:previous` 및 `select:next`는 이전 및 다음 파일로 이동하고, `Enter`는 `select:accept`를 통해 선택한 파일의 차이를 엽니다. 파일 목록에만 해당 키 중 하나를 변경하려면 `DiffDialog` 블록에서 선택 작업을 바인딩하세요.

v2.1.283 이전에는 파일 목록이 `Select` 바인딩을 무시했으며, `Enter`는 별도의 `diff:viewDetails` 작업을 통해 선택한 파일의 차이를 열었습니다. `keybindings.json`이 `diff:viewDetails`를 바인딩하면 바인딩이 파일 목록에서 `select:accept`로 계속 작동합니다.

차이 상세 보기는 또한 페이저 스타일 키를 표준 [스크롤 작업](#scroll-actions)에 바인딩합니다. 이러한 바인딩은 `DiffDialog` 컨텍스트의 일부이며 상세 보기에만 적용됩니다. [스크롤 작업](#scroll-actions) 아래에 나열된 `Scroll` 컨텍스트 기본값은 변경되지 않습니다.

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `scroll:pageUp` | PageUp | 뷰포트의 절반 위로 스크롤 |
| `scroll:pageDown` | PageDown | 뷰포트의 절반 아래로 스크롤 |
| `scroll:fullPageUp` | Shift+Space, B | 전체 뷰포트 위로 스크롤 |
| `scroll:fullPageDown` | Space | 전체 뷰포트 아래로 스크롤 |
| `scroll:top` | G, Home | 맨 위로 이동 |
| `scroll:bottom` | Shift+G, End | 맨 아래로 이동 |

### 차이 패널 작업

`/diff`가 전체 화면 렌더링에서 여는 [diff 패널](https://code.claude.com/docs/ko/interactive-mode.md#diff-panel)에 대한 작업입니다. `app:cycleDiffBase`는 패널이 열려 있을 때 활성화되는 `DiffPanel` 컨텍스트에 있습니다. 다른 것들은 `Global`입니다.

기본 제공 [`cc-plugin-diff` mod](https://code.claude.com/docs/ko/plugins/mods/overview#mods-built-into-claude-code)가 이 패널을 그리고 `app:cycleDiffBase`, `app:diffFileListUp` 및 `app:diffFileListDown`을 처리합니다. `app:toggleReplTab`, `app:toggleDiffNoiseFilter` 및 `app:toggleDiffPreSession`은 `/plugin`에서 `cc-plugin-diff`를 비활성화한 후 `/diff`가 여는 Claude Code의 이전 패널에서만 작동합니다.

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `app:toggleReplTab` | (바인딩 안 됨) | diff 패널을 열거나 닫습니다 |
| `app:cycleDiffBase` | Ctrl+X B | 패널의 비교 기준을 순환합니다: 이 세션, 커밋되지 않음, 그 다음 분기 |
| `app:diffFileListUp` | Ctrl+Up, Meta+Up | 패널의 파일 목록이 오버플로우할 때 위로 스크롤 |
| `app:diffFileListDown` | Ctrl+Down, Meta+Down | 패널의 파일 목록이 오버플로우할 때 아래로 스크롤 |
| `app:toggleDiffNoiseFilter` | (바인딩 안 됨) | 패널에서 테스트 및 생성된 파일 표시 또는 숨기기 |
| `app:toggleDiffPreSession` | (바인딩 안 됨) | 이 세션 이전의 변경 사항 확장 또는 축소 |

### 모델 선택기 작업

`ModelPicker` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `modelPicker:decreaseEffort` | Left | 노력 수준 감소 |
| `modelPicker:increaseEffort` | Right | 노력 수준 증가 |
| `modelPicker:thisSessionOnly` | s | 강조 표시된 모델을 이 세션에만 적용 |

### 노력 슬라이더 작업

`EffortSlider` 컨텍스트에서 사용 가능한 작업. 인수 없이 `/effort`를 실행할 때 열리는 슬라이더입니다. 슬라이더의 Enter 및 Escape 키는 다시 바인딩할 수 없습니다.

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `effortSlider:decreaseEffort` | Left | 슬라이더를 다음 낮은 노력 수준으로 이동합니다. v2.1.284 이상 필요 |
| `effortSlider:increaseEffort` | Right | 슬라이더를 다음 높은 노력 수준으로 이동합니다. v2.1.284 이상 필요 |
| `effortSlider:toggleUltracode` | Tab | 이 세션에 대해 [ultracode](https://code.claude.com/docs/ko/workflows.md#let-claude-decide-with-ultracode)를 켜거나 끕니다. 슬라이더가 [제공할 때](https://code.claude.com/docs/ko/model-config.md#when-ultracode-is-available). v2.1.284 이상 필요 |
| `effortSlider:thisSessionOnly` | s | 포커스된 [노력 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)을 이 세션에만 적용합니다. v2.1.257 이상 필요 |

### 선택 작업

`Select` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `select:next` | Down, J, Ctrl+N | 다음 옵션 |
| `select:previous` | Up, K, Ctrl+P | 이전 옵션 |
| `select:pageUp` | PageUp | 옵션 한 페이지 위로 이동 |
| `select:pageDown` | PageDown | 옵션 한 페이지 아래로 이동 |
| `select:first` | Home | 첫 번째 옵션 |
| `select:last` | End | 마지막 옵션 |
| `select:accept` | Enter | 선택 수락 |
| `select:cancel` | Escape | 선택 취소 |

`/skills`, `/mcp` 및 `/tasks`와 같은 목록 패널에서 Claude Code는 `select:pageUp`, `select:pageDown`, `select:first` 및 `select:last` 바인딩을 적용합니다. `/model` 선택기와 같은 대부분의 다른 목록에서는 `select:first` 및 `select:last` 바인딩이 적용됩니다. PageUp 및 PageDown은 바인딩에 관계없이 해당 목록의 옵션을 페이징합니다.

v2.1.280 이전에는 다른 목록들이 Home, End 및 `select:first`와 `select:last` 바인딩을 무시했습니다.

v2.1.283 이전에는 `/mcp` 도구 목록이 바인딩에 관계없이 고정된 PageUp 및 PageDown 키로 페이징했습니다.

### 플러그인 작업

`Plugin` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `plugin:toggle` | Space | 플러그인 선택 전환 |
| `plugin:install` | I | 선택한 플러그인 설치 |
| `plugin:favorite` | F | 선택한 플러그인을 즐겨찾기에 추가하여 설치된 탭 상단 근처에 정렬되도록 합니다 |

### 프롬프트 위 영역 작업

프롬프트 위 영역에 대한 작업입니다. 이 영역은 [mod](https://code.claude.com/docs/ko/plugins/mods/interface.md#pick-where-to-draw)가 버튼, 입력 필드, 선택 상자를 그리는 공유 스트립입니다. `abovePrompt:toggle` 및 `abovePrompt:focus`는 `Chat` 컨텍스트에서 적용됩니다. 다른 작업은 영역 또는 창에서 키보드 포커스를 가진 요소의 [컨텍스트](#contexts)에서 적용됩니다.

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `abovePrompt:toggle` | Ctrl+X Ctrl+A | 영역을 한 줄 힌트로 축소하거나 다시 확장 |
| `abovePrompt:focus` | Ctrl+X Tab | 키보드 포커스를 영역으로 이동한 다음 열려 있는 각 [창](#pane-actions)으로 이동하고, 마지막 창에서 프롬프트로 돌아옵니다 |
| `abovePrompt:next` | Tab | 다음 컨트롤에 포커스 |
| `abovePrompt:previous` | Shift+Tab | 이전 컨트롤에 포커스 |
| `abovePrompt:press` | Enter | 포커스된 버튼을 누르거나, 포커스된 입력 필드를 제출하거나, 선택 상자에서 강조 표시된 옵션을 선택합니다 |
| `abovePrompt:leave` | Escape | 키보드 포커스를 프롬프트로 되돌립니다 |
| `abovePrompt:highlightNext` | Down | 포커스된 선택 상자에서 다음 옵션 강조 표시 |
| `abovePrompt:highlightPrevious` | Up | 포커스된 선택 상자에서 이전 옵션 강조 표시 |

[`AbovePrompt` 컨텍스트](#contexts)에서는 기본적으로 Right 및 Left도 `abovePrompt:next` 및 `abovePrompt:previous`를 실행하고, Space도 `abovePrompt:press`를 실행합니다.

`AbovePrompt` 컨텍스트는 또한 Up, Down, PageUp, PageDown, Home 및 End를 [창 스크롤 작업](#pane-actions)인 `pane:scrollUp`부터 `pane:bottom`까지에 바인딩하므로, 영역에 대해 해당 키 중 하나를 변경하려면 `AbovePrompt` 블록에서 스크롤 작업을 바인딩하세요.

### 창 작업

[mod](https://code.claude.com/docs/ko/plugins/mods/interface.md#know-which-keys-your-mod-can-receive)가 그리는 창(pane)에 대한 작업입니다. 스크롤, 크기 조정 및 닫기 작업은 `Pane` [컨텍스트](#contexts)에서 적용됩니다. `pane:close`는 `PaneField` 컨텍스트에서도 적용되므로 창의 필드 중 하나에 포커스가 있을 때도 작동합니다. `pane:next` 및 `pane:previous`는 둘 이상의 창이 열려 있을 때 `Global` 컨텍스트에서 적용됩니다.

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `pane:scrollUp` | Up | 창에 표시할 수 있는 것보다 많은 행이 있을 때 창을 위로 스크롤 |
| `pane:scrollDown` | Down | 창에 표시할 수 있는 것보다 많은 행이 있을 때 창을 아래로 스크롤 |
| `pane:pageUp` | PageUp | 창을 한 페이지 위로 스크롤 |
| `pane:pageDown` | PageDown | 창을 한 페이지 아래로 스크롤 |
| `pane:top` | Home | 창의 맨 위로 이동 |
| `pane:bottom` | End | 창의 맨 아래로 이동 |
| `pane:grow` | Ctrl+X Left, Ctrl+X Up | 창에 더 많은 공간을 부여합니다: 트랜스크립트 옆에 있을 때는 너비, 프롬프트 위에 있을 때는 높이 |
| `pane:shrink` | Ctrl+X Right, Ctrl+X Down | 창에 더 적은 공간을 부여합니다: 트랜스크립트 옆에 있을 때는 너비, 프롬프트 위에 있을 때는 높이 |
| `pane:close` | Ctrl+X X | 창 닫기 |
| `pane:next` | (바인딩 안 됨) | 열려 있는 다음 창 표시 |
| `pane:previous` | (바인딩 안 됨) | 열려 있는 이전 창 표시 |

`Pane` 컨텍스트는 또한 Tab, Shift+Tab, Enter 및 Escape를 영역과 동일한 [프롬프트 위 영역 작업](#above-prompt-actions)에 바인딩하며, 창의 입력 필드와 선택 상자는 `AbovePromptInput` 및 `AbovePromptSelect` 컨텍스트를 사용합니다. [키보드 포커스 및 단축키](https://code.claude.com/docs/ko/plugins/mods/interface.md#know-which-keys-your-mod-can-receive)에서 창에서 각 키가 수행하는 작업을 확인할 수 있습니다.

### 설정 작업

`Settings` 컨텍스트에서 사용 가능한 작업. `select:accept` 및 `confirm:no` 작업은 설정별 동작을 포함하여 [선택](#select-actions) 및 [확인](#confirmation-actions) 컨텍스트에서 재사용됩니다: 변경 사항은 변경하는 즉시 각 설정에 적용되므로 Escape는 변경 사항이 저장된 상태로 패널을 닫습니다.

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `settings:search` | / | 검색 모드 입력 |
| `settings:retry` | R | 오류 시 사용 데이터 로드 다시 시도 |
| `settings:fixUsage` | F | `/usage` 바닥글이 수정을 제안할 때, Claude Code가 적용할 수 있는 [`/usage` 권장 사항](https://code.claude.com/docs/ko/costs#apply-recommendations-with-the-fix-shortcut)을 세션에 보냅니다. v2.1.305 이상 필요 |
| `select:accept` | Enter, Space | 선택한 설정을 변경하거나 해당 하위 메뉴 열기 |
| `confirm:no` | Escape | 패널 닫기. 변경 사항이 이미 저장됨 |

### 에이전트 작업

`Agents` 컨텍스트에서 사용 가능한 작업. `claude agents`로 열리는 [에이전트 보기](https://code.claude.com/docs/ko/agent-view.md)에 적용됩니다. v2.1.257 이상 필요합니다.

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `agents:switchView` | Ctrl+S | [세션 그룹화](https://code.claude.com/docs/ko/agent-view.md#organize-the-list)를 상태와 디렉토리 사이에서 전환합니다 |
| `agents:togglePin` | Ctrl+T | 선택한 세션을 [고정 또는 고정 해제](https://code.claude.com/docs/ko/agent-view.md#organize-the-list)합니다 |
| `agents:find` | Ctrl+F | [`n:` 필터](https://code.claude.com/docs/ko/agent-view#filter-sessions)를 사용하여 이름으로 세션을 찾습니다. v2.1.288 이상 필요 |
| `agents:rename` | Ctrl+R | 선택한 세션의 [이름을 변경](https://code.claude.com/docs/ko/agent-view.md#organize-the-list)합니다. v2.1.288 이상 필요 |
| `agents:previousGroup` | Ctrl+Up, Meta+Up | 이전 [그룹 헤더](https://code.claude.com/docs/ko/agent-view.md#organize-the-list)로 이동합니다. v2.1.288 이상 필요 |
| `agents:nextGroup` | Ctrl+Down, Meta+Down | 다음 그룹 헤더로 이동합니다. v2.1.288 이상 필요 |

에이전트 보기가 열려 있을 때 Claude Code는 `Agents` 컨텍스트가 바인딩하는 모든 키에 대해 `Agents` 바인딩을 사용하고 동일한 키의 `Chat` 또는 `Global` 바인딩을 무시합니다. 예를 들어 에이전트 보기에서 Ctrl+S를 누르면 기본 `chat:stash`를 트리거하는 대신 세션 그룹화를 전환합니다.

디스패치 입력의 외부 편집기 바로 가기는 `Agents` 작업이 아닙니다. 에이전트 보기는 `Chat` 컨텍스트의 `chat:externalEditor` 바인딩(기본값 Ctrl+G)을 따릅니다.

바인딩은 에이전트 보기에서 단일 키 입력에서 발생하므로 `chat:externalEditor`에 바인딩된 Ctrl+X Ctrl+E 코드는 편집기를 열지 않습니다.

### 음성 작업

[음성 받아쓰기](https://code.claude.com/docs/ko/voice-dictation.md)가 활성화되어 있을 때 `Chat` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `voice:pushToTalk` | Space | 프롬프트를 받아쓰기. `/voice` 모드에 따라 누르거나 탭합니다 |

### 스크롤 작업

[전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md)이 활성화되어 있을 때 `Scroll` 컨텍스트에서 사용 가능한 작업:

| 작업 | 기본값 | 설명 |
| :- | :- | :- |
| `scroll:lineUp` | `wheelup` | 한 줄 위로 스크롤. 마우스 휠 스크롤이 이 작업을 트리거합니다 |
| `scroll:lineDown` | `wheeldown` | 한 줄 아래로 스크롤. 마우스 휠 스크롤이 이 작업을 트리거합니다 |
| `scroll:pageUp` | PageUp | 뷰포트 높이의 절반 위로 스크롤 |
| `scroll:pageDown` | PageDown | 뷰포트 높이의 절반 아래로 스크롤 |
| `scroll:top` | Ctrl+Home | 대화의 시작으로 이동 |
| `scroll:bottom` | Ctrl+End | 최신 메시지로 이동하고 자동 팔로우 다시 활성화 |
| `scroll:halfPageUp` | (바인딩 안 됨) | 뷰포트 높이의 절반 위로 스크롤. `scroll:pageUp`과 동일한 동작이며 vi 스타일 재바인딩을 위해 제공됩니다 |
| `scroll:halfPageDown` | (바인딩 안 됨) | 뷰포트 높이의 절반 아래로 스크롤. `scroll:pageDown`과 동일한 동작이며 vi 스타일 재바인딩을 위해 제공됩니다 |
| `scroll:fullPageUp` | (바인딩 안 됨) | 전체 뷰포트 높이 위로 스크롤 |
| `scroll:fullPageDown` | (바인딩 안 됨) | 전체 뷰포트 높이 아래로 스크롤 |
| `selection:copy` | Ctrl+Shift+C / Cmd+C | 선택한 텍스트를 클립보드에 복사 |
| `selection:clear` | (바인딩 안 됨) | 활성 텍스트 선택 지우기. v2.1.234 이상 필요 |
| `selection:extendLeft` | Shift+Left | 활성 선택을 한 열 왼쪽으로 확장 |
| `selection:extendRight` | Shift+Right | 활성 선택을 한 열 오른쪽으로 확장 |
| `selection:extendUp` | Shift+Up | 활성 선택을 한 행 위로 확장. 선택이 위쪽 가장자리에 도달하면 뷰포트를 스크롤합니다 |
| `selection:extendDown` | Shift+Down | 활성 선택을 한 행 아래로 확장. 선택이 아래쪽 가장자리에 도달하면 뷰포트를 스크롤합니다 |
| `selection:extendLineStart` | Shift+Home | 활성 선택을 줄의 시작으로 확장 |
| `selection:extendLineEnd` | Shift+End | 활성 선택을 줄의 끝으로 확장 |

## 키 입력 구문

### 수정자

`+` 구분자로 수정자 키를 사용합니다:

* `ctrl` 또는 `control` - Control 키
* `shift` - Shift 키
* `alt`, `opt`, `option`, 또는 `meta` - Windows 및 Linux의 Alt 키, macOS의 Option 키
* `cmd`, `command`, `super`, 또는 `win` - macOS의 Command 키, Windows의 Windows 키, Linux의 Super 키

`cmd` 그룹은 Kitty 키보드 프로토콜 또는 xterm의 `modifyOtherKeys` 모드를 지원하는 것과 같이 Super 수정자를 보고하는 터미널에서만 감지됩니다. 대부분의 터미널은 이를 전송하지 않으므로 모든 곳에서 작동하기를 원하는 바인딩에는 `ctrl` 또는 `meta`를 사용합니다.

예를 들어:

```text theme={null}
ctrl+k          Ctrl + K
shift+tab       Shift + Tab
meta+p          macOS의 Option + P, 다른 곳의 Alt + P
ctrl+shift+c    여러 수정자
```

### 대문자

Claude Code는 키 이름을 대소문자를 구분하지 않고 파싱하므로 `K`는 `k`와 동일한 바인딩이고 `ctrl+K`는 `ctrl+k`와 동일합니다. Shift와 문자를 바인딩하려면 `shift+k`를 작성합니다.

### 비US 키보드 레이아웃

활성 키보드 레이아웃이 다른 문자를 입력하더라도 Ctrl 바로가기의 키 이름을 라틴 문자로 작성합니다.

Claude Code가 누른 키를 바인딩과 일치시키는 방식은 레이아웃의 종류에 따라 다릅니다:

* Cyrillic과 같은 비라틴 레이아웃에서 Claude Code는 터미널이 Kitty 키보드 프로토콜을 사용하고 해당 위치를 보고할 때 키의 US 레이아웃 위치로 Ctrl 바로가기를 일치시킵니다. 러시아어 레이아웃이 활성화된 그러한 터미널에서 Ctrl과 물리적 W 키를 누르면 `ctrl+w`가 트리거됩니다. 위치를 보고하지 않는 터미널에서 Claude Code는 키 입력에 대해 터미널이 전송하는 것과 일치합니다: ASCII 제어 코드는 라틴 바로가기를 트리거하고 Cyrillic 문자로 도착하는 키 입력은 바인딩과 일치하지 않습니다
* AZERTY와 같이 라틴 문자를 재배열하는 레이아웃에서 Claude Code는 키가 입력하는 문자와 일치하므로 Ctrl과 A로 표시된 키를 누르면 `ctrl+a`가 트리거됩니다

### 코드

코드는 공백으로 구분된 키 입력 시퀀스입니다:

```text theme={null}
ctrl+k ctrl+s   Ctrl+K를 누르고 놓은 다음 Ctrl+S를 누릅니다
```

각 키 입력을 이전 키 입력 후 3초 이내에 누릅니다. 더 오래 기다리면 Claude Code는 코드를 취소하고 그렇게 했다는 짧은 알림을 표시합니다.

### 특수 키

* `escape` 또는 `esc` - Escape 키
* `enter` 또는 `return` - Enter 키
* `tab` - Tab 키
* `space` - 스페이스바
* `up`, `down`, `left`, `right` - 화살표 키
* `pageup`, `pagedown` - Page Up 및 Page Down 키
* `home`, `end` - Home 및 End 키
* `backspace`, `delete` - Delete 키
* `wheelup`, `wheeldown` - 마우스 휠 스크롤 이벤트

## 기본 단축키 바인딩 해제

작업을 `null`로 설정하여 기본 단축키 바인딩을 해제합니다:

```json theme={null}
{
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+s": null
      }
    }
  ]
}
```

이는 코드 바인딩에도 작동합니다. 접두사를 공유하는 모든 코드를 바인딩 해제하면 해당 접두사를 단일 키 바인딩으로 사용할 수 있습니다. 활성 컨텍스트의 코드는 접두사를 예약된 상태로 유지하므로 해당 코드를 정의하는 컨텍스트에서 각 코드를 바인딩 해제해야 합니다.

Claude Code는 `ctrl+x` 접두사에서 컨텍스트별로 다음과 같은 기본 코드를 바인딩합니다:

* `Chat`: `ctrl+x ctrl+k`, `ctrl+x ctrl+e`, `ctrl+x enter`, `ctrl+x ctrl+a`, `ctrl+x ctrl+s`, `ctrl+x tab`
* `Task`: `ctrl+x ctrl+b`
* `DiffPanel`: `ctrl+x b`
* `Pane`: `ctrl+x left`, `ctrl+x right`, `ctrl+x up`, `ctrl+x down`, `ctrl+x x`
* `PaneField`: `ctrl+x x`

`ctrl+x enter` 코드는 v2.1.247 이상이 필요하며, `ctrl+x b`, `ctrl+x ctrl+a`, `ctrl+x tab`은 v2.1.260 이상이 필요하고, `ctrl+x ctrl+s`는 v2.1.275 이상이 필요합니다.

`ctrl+x` 자체를 단일 키 바인딩으로 되찾으려면 모두 바인딩 해제합니다:

```json theme={null}
{
  "bindings": [
    {
      "context": "Task",
      "bindings": {
        "ctrl+x ctrl+b": null
      }
    },
    {
      "context": "DiffPanel",
      "bindings": {
        "ctrl+x b": null
      }
    },
    {
      "context": "Pane",
      "bindings": {
        "ctrl+x left": null,
        "ctrl+x right": null,
        "ctrl+x up": null,
        "ctrl+x down": null,
        "ctrl+x x": null
      }
    },
    {
      "context": "PaneField",
      "bindings": {
        "ctrl+x x": null
      }
    },
    {
      "context": "Chat",
      "bindings": {
        "ctrl+x ctrl+k": null,
        "ctrl+x ctrl+e": null,
        "ctrl+x enter": null,
        "ctrl+x ctrl+a": null,
        "ctrl+x ctrl+s": null,
        "ctrl+x tab": null,
        "ctrl+x": "chat:newline"
      }
    }
  ]
}
```

접두사의 일부 코드만 바인딩 해제하고 모두 바인딩 해제하지 않으면 접두사를 누르면 여전히 남은 바인딩에 대한 코드 대기 모드로 진입합니다.

## 예약된 단축키

이러한 단축키는 다시 바인딩할 수 없습니다:

| 단축키 | 이유 |
| :- | :- |
| Ctrl+C | 하드코딩된 중단/취소 |
| Ctrl+D | 하드코딩된 종료 |
| Ctrl+M | Claude Code는 항상 이를 Enter로 수신합니다 |
| Ctrl+\[ | Claude Code는 항상 이를 Escape로 수신합니다. Kitty 키보드 프로토콜을 사용하는 터미널에서는 v2.1.242 이상이 필요합니다 |
| Ctrl+I | Claude Code는 항상 이를 Tab으로 수신합니다 |
| Ctrl+H | ASCII 백스페이스 바이트를 전송합니다. [Claude Code가 Windows에서 이를 읽는 방식](https://code.claude.com/docs/ko/terminal-config.md#fix-backspace-deleting-a-whole-word-on-windows)은 터미널과 [`CLAUDE_CODE_BS_AS_CTRL_BACKSPACE`](https://code.claude.com/docs/ko/env-vars) 환경 변수에 따라 다릅니다 |
| Caps Lock | 터미널 애플리케이션에 전달되지 않음 |

## 터미널 충돌

일부 단축키는 터미널 멀티플렉서와 충돌할 수 있습니다:

| 단축키 | 충돌 |
| :- | :- |
| Ctrl+B | tmux 접두사(두 번 눌러서 보내기) |
| Ctrl+A | GNU screen 접두사 |
| Ctrl+Z | Unix 프로세스 일시 중단(SIGTSTP) |

## 텍스트 필드

맨 글자, 숫자 또는 스페이스를 바인딩하면, 대화 상자나 패널 내의 텍스트 필드에서 여전히 해당 문자를 입력할 수 있습니다. 이러한 필드 중 하나는 Claude가 질문하는 `Other` 답변입니다. 필드에 포커스가 있는 동안, Ctrl, Alt 또는 Cmd 없이 누르는 인쇄 가능한 키는 필드로 이동하며, Claude Code는 바인딩과 일치시키지 않습니다.

이러한 키는 필드에 포커스가 있는 동안에도 바인딩을 실행합니다:

* Enter, Escape, Tab 및 화살표 키와 같이 문자를 입력하지 않는 키
* Ctrl, Alt 또는 Cmd와 함께 누르는 모든 키
* 이미 진행 중인 [코드](#chords)의 두 번째 키 입력

주 프롬프트에서 Claude Code는 모든 키를 `Chat`과 같은 활성 컨텍스트와 비교하고, 바인딩이 키를 가져가지 않을 때만 키를 입력합니다.

## Vim 모드 상호 작용

`/config`의 편집기 모드 설정으로 vim 모드를 활성화하면 키보드 단축키와 vim 모드는 독립적으로 작동합니다:

* **Vim 모드**는 텍스트 입력 수준에서 입력을 처리합니다: 커서 이동, 모드, 모션
* **키보드 단축키**는 할 일 전환이나 메시지 제출과 같은 작업을 구성 요소 수준에서 처리합니다.
* vim 모드에서 Escape 키는 INSERT 모드를 NORMAL 모드로 전환하며, `chat:cancel`을 트리거하지 않습니다
* 대부분의 Ctrl+key 단축키는 vim 모드를 통과하여 키바인딩 시스템으로 이동합니다.
* Vim 키는 키바인딩 파일을 통해 다시 매핑할 수 없습니다. `jj`를 Escape로 매핑하는 것과 같은 두 키 INSERT 모드 시퀀스를 매핑하려면 [`vimInsertModeRemaps`](https://code.claude.com/docs/ko/interactive-mode#remap-insert-mode-key-sequences) 설정을 사용합니다.
* vim NORMAL 모드에서 `?`는 도움말 메뉴를 표시합니다(vim 동작).
* vim NORMAL 모드에서 `/`는 히스토리 검색을 열며, 표준 모드의 Ctrl+R과 동일합니다.

Claude가 묻는 질문의 `Other` 행에서는 vim 모드일 때 Escape를 눌러도 질문이 바로 취소되지 않습니다. [화면 읽기 프로그램 모드](https://code.claude.com/docs/ko/accessibility.md)가 아닌 경우, 이 행은 포커스될 때마다 INSERT 모드로 시작합니다. `Other` 행에서 Escape를 누르면 행이 NORMAL 모드로 전환되거나 입력하던 vim 명령이 취소되며, 질문은 열린 상태로 유지됩니다. 질문을 취소하려면 NORMAL 모드에서 Escape를 한 번 더 누릅니다.

### 키 한 번으로 질문 취소하기

vim 모드에서 키 한 번으로 질문을 취소하려면 `Select` 컨텍스트에서 다른 키를 `select:cancel`에 바인딩합니다. 이 방법은 옵션 하나를 선택하는 질문의 `Other` 행에서 사용할 수 있습니다. [화면 읽기 프로그램 모드](https://code.claude.com/docs/ko/accessibility.md)이거나 여러 옵션을 선택할 수 있는 질문에서는 바인딩된 키로 취소되지 않으므로 Escape로 취소합니다.

Ctrl 또는 Alt와 함께 누르는 키를 선택합니다. 단독 문자나 숫자는 바인딩에 전달되지 않고 대신 [`Other` 행으로 입력됩니다](#text-fields). 예를 들어 `Ctrl+Q`를 바인딩하려면 `~/.claude/keybindings.json`에 다음을 추가합니다:

```json theme={null}
{
  "bindings": [
    {
      "context": "Select",
      "bindings": {
        "ctrl+q": "select:cancel"
      }
    }
  ]
}
```

파일을 저장한 후 옵션 하나를 선택하는 질문의 `Other` 행에서 `Ctrl+Q`를 누릅니다. 행이 INSERT 모드이든 NORMAL 모드이든 질문이 닫힙니다.

## 유효성 검사

Claude Code는 키보드 단축키의 유효성을 검사하며, 다음과 같은 경우 디버그 로그에 경고를 기록합니다.

* 구문 분석 오류(잘못된 JSON 또는 구조)
* `ctl+k`와 같이 철자가 잘못된 수정자 키. Claude Code는 인식하지 못하는 부분을 제외하고 나머지 키 입력(이 예에서는 `k`)에 바인딩을 적용합니다.
* `ctrl+ k`와 같이 키 문자열에서 `+` 옆에 공백이 있는 경우. Claude Code는 이 문자열을 `ctrl+` 다음에 `k`가 오는 [코드](#chords)로 읽습니다. `ctrl+` 단독과 일치하는 키 입력은 없으므로 이 바인딩은 절대 실행되지 않습니다. 공백을 제거하세요.
* 잘못된 컨텍스트 이름
* 문자열도 `null`도 아닌 작업과 같은 잘못된 작업 값
* 등록된 작업 이름의 오타와 같은 알 수 없는 작업 이름. Claude Code는 해당 바인딩을 건너뛰고 그 키에 대한 기본 바인딩을 계속 적용합니다.
* 예약된 단축키 충돌
* 동일한 컨텍스트 내의 중복 바인딩

자세한 내용을 확인하려면 [`--debug`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 옵션으로 Claude Code를 시작합니다.
