> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code를 위한 터미널 구성

> Shift+Enter를 개행으로 수정하고, Claude가 완료되면 터미널 벨을 받으며, tmux를 구성하고, 색상 테마를 일치시키고, Claude Code CLI에서 Vim 모드를 활성화합니다.

Claude Code는 구성 없이 모든 터미널에서 작동합니다. 이 페이지는 특정 항목이 예상대로 작동하지 않을 때를 위한 것입니다. 아래에서 증상을 찾아보십시오. 이미 모든 것이 올바르게 느껴진다면 이 페이지가 필요하지 않습니다.

* [Shift+Enter가 개행을 삽입하는 대신 제출합니다](#enter-multiline-prompts)
* [macOS에서 Option 키 단축키가 작동하지 않습니다](#enable-option-key-shortcuts-on-macos)
* [Claude가 완료되면 소리나 알림이 없습니다](#get-a-terminal-bell-or-notification)
* [tmux 내에서 Claude Code를 실행합니다](#configure-tmux)
* [Windows에서 백스페이스가 전체 단어를 삭제합니다](#fix-backspace-deleting-a-whole-word-on-windows)
* [디스플레이가 깜박이거나 스크롤백이 점프합니다](#switch-to-fullscreen-rendering)
* [프롬프트에서 Vim 키를 원합니다](#edit-prompts-with-vim-keybindings)

이 페이지는 터미널이 Claude Code에 올바른 신호를 보내도록 하는 것에 관한 것입니다. Claude Code 자체가 응답하는 키를 변경하려면 대신 [키 바인딩](https://code.claude.com/docs/ko/keybindings.md)을 참조하십시오.

## 여러 줄 프롬프트 입력

Enter를 누르면 메시지가 전송됩니다. 전송하지 않고 줄바꿈을 추가하려면 Ctrl+J를 누르거나 `\`를 입력한 후 Enter를 누르십시오. 두 방법 모두 모든 터미널에서 설정 없이 작동합니다.

대부분의 터미널에서는 Shift+Enter를 누를 수도 있지만, 터미널 에뮬레이터에 따라 지원이 다릅니다:

| 터미널 | 줄바꿈을 위한 Shift+Enter |
| :- | :- |
| Ghostty, Kitty, iTerm2, WezTerm, Warp, Apple Terminal, Windows Terminal | 설정 없이 작동 |
| kitty 키보드 프로토콜을 지원하는 기타 터미널(예: foot 및 Alacritty 0.16 이상) | 설정 없이 작동합니다. Claude Code v2.1.269 이상 필요 |
| VS Code, Cursor, Devin Desktop, Alacritty 0.16 이전, Zed | 한 번 `/terminal-setup` 실행 |
| gnome-terminal, PyCharm 및 Android Studio와 같은 JetBrains IDE | 사용 불가; Ctrl+J 또는 `\` 다음 Enter 사용 |

VS Code, Cursor, Devin Desktop, Alacritty 0.16 이전, 및 Zed의 경우, `/terminal-setup`은 Shift+Enter 키 바인딩을 터미널의 구성 파일에 작성합니다. 첫 번째 실행 시 `Installed VSCode terminal Shift+Enter key binding`과 같은 확인 메시지가 표시됩니다. 기존 바인딩은 그대로 유지되며, `VSCode terminal Shift+Enter key binding already configured`와 같은 메시지가 표시되면 변경이 없었던 것입니다. tmux 또는 screen 내부가 아닌 호스트 터미널에서 직접 `/terminal-setup`을 실행하십시오. 호스트 터미널의 구성에 작성해야 하기 때문입니다.

VS Code, Cursor 및 Devin Desktop에서 `/terminal-setup`은 또한 두 가지 편집기 설정을 업데이트합니다: 통합 터미널의 텍스트 손상을 방지하기 위해 `terminal.integrated.gpuAcceleration`을 `"off"`로 설정하고, [전체 화면 모드](https://code.claude.com/docs/ko/fullscreen.md)에서 더 부드러운 스크롤링을 위해 `terminal.integrated.mouseWheelScrollSensitivity`를 설정합니다. GPU 가속 변경을 취소하려면 `"auto"`로 다시 설정하고 편집기 창을 다시 로드하십시오.

Zed에서 `/terminal-setup`은 `keymap.json`을 제자리에서 업데이트합니다:

* 키맵에 이미 바인딩이 있고 그 중 어느 것도 Terminal `shift-enter`가 아닌 경우, Claude Code는 먼저 `keymap.json.1a2b3c4d.bak`과 같은 같은 디렉토리의 복사본으로 백업한 다음 Shift+Enter 바인딩을 키맵에 병합하여 다른 키 바인딩과 주석을 유지합니다.
* Claude Code가 키맵을 읽거나 구문 분석할 수 없거나, 백업할 수 없거나, 병합된 결과를 확인할 수 없는 경우, [파일을 변경하지 않은 상태로 두고 직접 추가할 키 바인딩 블록을 인쇄합니다](https://code.claude.com/docs/ko/errors.md#terminal-setup-left-your-zed-keymap-unchanged).

tmux 내부에서 실행 중인 경우, 외부 터미널이 지원하더라도 Shift+Enter는 [아래의 tmux 구성](#configure-tmux)이 필요합니다.

줄바꿈을 다른 키에 바인딩하거나 Enter가 줄바꿈을 삽입하고 Shift+Enter가 전송하도록 동작을 바꾸려면, [키 바인딩 파일](https://code.claude.com/docs/ko/keybindings.md)에서 `chat:newline` 및 `chat:submit` 작업을 매핑하십시오.

## macOS에서 Option 키 단축키 활성화

Claude Code의 일부 단축키는 Option 키를 사용합니다. 예를 들어 Option+Enter는 새 줄을 입력하고 Option+P는 모델을 전환합니다. macOS에서는 대부분의 터미널이 기본적으로 Option을 수정자로 전송하지 않으므로 이를 활성화할 때까지 이러한 단축키는 작동하지 않습니다. 터미널 설정은 일반적으로 "Use Option as Meta Key"로 표시됩니다. Meta는 현재 Option 또는 Alt로 표시된 키의 역사적 Unix 이름입니다.

> [tab] Apple Terminal
>
> 설정 → 프로필 → 키보드를 열고 "Use Option as Meta Key"를 선택합니다.
>
> Claude Code의 첫 실행 터미널 설정 프롬프트를 수락한 경우 이미 완료되었습니다. 해당 프롬프트는 `/terminal-setup`을 실행하여 Option을 Meta로 활성화하고 Apple Terminal 프로필에서 청각 벨을 끕니다.
>
> [화면 읽기 모드](https://code.claude.com/docs/ko/accessibility.md)에서 `/terminal-setup`은 벨 설정을 변경하지 않으므로 터미널 벨이 계속 들립니다. 이전 실행에서 벨을 껐다면 설정 → 프로필 → 고급 → "청각 벨"에서 다시 켭니다.

> [tab] iTerm2
>
> 설정 → 프로필 → 키 → 일반을 열고 왼쪽 Option 키와 오른쪽 Option 키를 "Esc+"로 설정합니다.
>
> iTerm2에서 `/terminal-setup`을 실행하면 설정 → 일반 → 선택 아래에서 "터미널의 응용 프로그램이 클립보드에 액세스할 수 있음"을 활성화하여 `/copy` 명령이 시스템 클립보드에 쓸 수 있습니다. 이 명령은 tmux 내부에서 실행되는 경우에도 iTerm2를 감지합니다. 변경 사항을 적용하려면 iTerm2를 다시 시작합니다.

> [tab] VS Code
>
> VS Code 설정에 `"terminal.integrated.macOptionIsMeta": true`를 추가합니다.

Ghostty, Kitty 및 기타 터미널의 경우 터미널의 구성 파일에서 Option-as-Alt 또는 Option-as-Meta 설정을 찾습니다.

## 터미널 벨 또는 알림 받기

Claude가 작업을 완료하거나 권한 프롬프트에서 일시 중지되었을 때, 사용자가 터미널에서 자리를 비운 것으로 보이면 알림 이벤트가 발생합니다. 각 알림 유형이 발생하는 정확한 시점은 [알림 유형별 발생 시점](https://code.claude.com/docs/ko/hooks.md#notification)을 참조하세요. 이를 터미널 벨 또는 데스크톱 알림으로 표시하면 긴 작업이 실행되는 동안 다른 작업으로 전환할 수 있습니다.

기본적으로 Claude Code는 일부 터미널에서는 데스크톱 알림을 전송하고, 다른 터미널에서는 벨 문자를 전송하거나 아무것도 전송하지 않습니다:

* **Ghostty, Kitty, iTerm2**: 데스크톱 알림을 전송하며, iTerm2는 알림 설정을 켠 후에만 이를 표시합니다.
* **Apple Terminal**: 소리가 나지 않습니다. Claude Code가 맨 앞 Terminal 창의 프로필에서 "Audible bell"이 꺼져 있음을 확인하면 무음 벨 문자를 전송하고, 그렇지 않으면 아무것도 전송하지 않습니다. 해당 프로필의 "Visual bell" 또는 Dock 바운스 옵션이 켜져 있으면 이 벨 문자는 창 깜박임으로 표시되거나, Terminal이 백그라운드에 있는 동안에는 Dock 바운스로 표시됩니다.
* **기타 터미널**: 아무것도 전송하지 않습니다.

터미널이나 프로필에 관계없이 Claude Code가 벨 문자를 전송하도록 하려면 [`preferredNotifChannel`](https://code.claude.com/docs/ko/settings-reference#preferrednotifchannel)을 `"terminal_bell"`로 설정하세요. Apple Terminal에서는 소리를 들으려면 **설정 > 프로필 > 고급**에서 **Audible bell**도 켜야 합니다. 다음 설정 항목은 채널을 설정합니다:

```json ~/.claude/settings.json theme={null}
{
  "preferredNotifChannel": "terminal_bell"
}
```

데스크톱 알림은 SSH를 통해 로컬 머신에 도달하므로 원격 세션도 사용자에게 알릴 수 있습니다. Ghostty와 Kitty는 추가 설정 없이 OS 알림 센터로 전달합니다. iTerm2는 전달을 활성화해야 합니다:

**1. iTerm2 알림 설정 열기**

설정 → 프로필 → 터미널로 이동합니다.

**2. 알림 활성화**

"Notification Center Alerts"를 확인한 다음 "Filter Alerts"를 클릭하고 "Send escape sequence-generated alerts"를 활성화합니다.

알림이 여전히 나타나지 않으면 터미널 애플리케이션이 OS 설정에서 알림 권한을 가지고 있는지 확인하고, tmux 내에서 실행 중인 경우 [passthrough를 활성화](#configure-tmux)하세요.

### Notification 훅으로 소리 재생하기

모든 터미널에서 [Notification 훅](https://code.claude.com/docs/ko/hooks-guide.md#get-notified-when-claude-needs-input)을 구성하여 Claude가 사용자의 주의가 필요할 때 소리를 재생하거나 사용자 정의 명령을 실행할 수 있습니다. 훅은 기본 제공 알림과 함께 실행되며 이를 대체하지 않으므로, Warp 또는 VS Code 통합 터미널과 같이 데스크톱 알림을 받지 않는 터미널은 훅을 사용하거나 `preferredNotifChannel`을 `"terminal_bell"`로 설정할 수 있습니다.

아래 예제는 macOS에서 시스템 소리를 재생합니다. 연결된 가이드에는 macOS, Linux, Windows용 데스크톱 알림 명령이 있습니다.

```json ~/.claude/settings.json theme={null}
{
  "hooks": {
    "Notification": [
      {
        "hooks": [{ "type": "command", "command": "afplay /System/Library/Sounds/Glass.aiff" }]
      }
    ]
  }
}
```

## 터미널에서 세션 상태 확인하기

터미널이 OSC 7501 Program Status Protocol을 구현하는 경우, 각 대화형 Claude Code 세션이 작업 중인지, 사용자의 응답을 기다리는 중인지, 완료되었는지를 표시할 수 있습니다. 이는 긴 작업을 실행하거나 여러 세션을 동시에 실행할 때 유용합니다. Claude Code에서 따로 켜야 할 설정은 없습니다. 터미널이 이 프로토콜을 구현하는지, 그리고 상태를 어디에 표시하는지 확인하려면 해당 터미널의 문서를 참조하십시오.

터미널이 프로토콜을 구현하는데도 세션의 상태가 표시되지 않는다면 다음 각 원인을 확인하십시오.

* **Claude Code 버전**: 상태 보고에는 Claude Code v2.1.295 이상이 필요합니다. 셸에서 `claude --version`을 실행하여 확인하십시오.
* **tmux**: tmux 내부에서는 Claude Code가 터미널 대신 tmux에서 지원 여부를 확인하며, [`allow-passthrough`](#configure-tmux)는 이에 영향을 주지 않습니다. tmux 외부에서 세션을 시작하십시오.
* **백그라운드 세션**: [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)은 세션에 연결되어 있는 동안에도 터미널에 상태를 보고하지 않습니다. 대신 에이전트 뷰에 상태가 표시됩니다.
* **[`CLAUDE_CODE_DISABLE_TERMINAL_TITLE`](https://code.claude.com/docs/ko/env-vars#variables)**: 이 변수를 `1`로 설정하면 Claude Code는 지원 여부를 확인하거나 상태를 보고하지 않습니다. 이 변수의 설정을 해제하십시오.

프로토콜 지원을 보고하는 터미널에서는 탭 제목이 상태 글리프로 시작하지 않습니다. 터미널이 세션의 상태를 직접 표시하므로, Claude Code는 다른 터미널에서 제목 앞에 붙이는 글리프를 생략합니다.

## tmux 구성

Claude Code가 tmux 내에서 실행될 때, 기본적으로 Shift+Enter가 새 줄을 삽입하는 대신 제출하고, 데스크톱 알림과 [진행률 표시줄](https://code.claude.com/docs/ko/settings-reference.md#terminalprogressbarenabled)이 외부 터미널에 도달하지 않습니다. `~/.tmux.conf`에 다음 줄을 추가한 후 `tmux source-file ~/.tmux.conf`를 실행하여 실행 중인 서버에 적용합니다:

```bash ~/.tmux.conf theme={null}
set -g allow-passthrough on
set -g focus-events on
set -s extended-keys on
set -as terminal-features 'xterm*:extkeys'
```

`allow-passthrough` 줄은 알림과 진행 상황 업데이트가 tmux에 의해 삼켜지는 대신 외부 터미널에 도달하도록 합니다. `extended-keys` 줄은 tmux가 Shift+Enter를 일반 Enter와 구별하여 새 줄 단축키가 작동하도록 합니다.

[mod의 `Image`](https://code.claude.com/docs/ko/plugins/mods/reference#elements)에는 `allow-passthrough` 및 `focus-events` 줄과 함께 [tmux 내부 그리기를 위한 기타 요구 사항](https://code.claude.com/docs/ko/plugins/mods/gallery.md#draw-an-image-inside-tmux)이 필요합니다. 줄을 추가한 후에는 tmux에서 분리(detach)했다가 다시 연결(attach)하고 Claude Code를 다시 시작해야 합니다.

## Windows에서 Backspace가 전체 단어를 삭제하는 문제 해결

Windows에서 Claude Code는 `^H`로 도착하는 Backspace를 Ctrl+Backspace로 읽으며, 이는 [이전 단어를 삭제합니다](https://code.claude.com/docs/ko/interactive-mode.md#text-editing). 단, `TERM_PROGRAM`이 `mintty`이거나 `TERM`이 `cygwin`인 경우는 예외입니다. macOS와 Linux에서 Claude Code는 이를 일반 Backspace로 읽습니다.

Backspace를 누를 때마다 전체 단어가 삭제되면, 터미널이 일반 Backspace에 대해 `^H`를 전송하는 것입니다. [`CLAUDE_CODE_BS_AS_CTRL_BACKSPACE=0`](https://code.claude.com/docs/ko/env-vars)을 설정하세요. 그러면 Backspace와 Ctrl+H가 각각 한 문자씩 삭제합니다. macOS 또는 Linux에서 터미널이 Ctrl+Backspace에 대해 `^H`를 전송하기 때문에 Ctrl+Backspace가 한 문자만 삭제하는 경우, 대신 변수를 `1`로 설정하세요.

## 색상 테마 맞추기

`/theme` 명령 또는 `/config`의 테마 선택기를 사용하여 터미널에 맞는 Claude Code 테마를 선택합니다. 자동 옵션을 선택하면 터미널의 밝은 배경 또는 어두운 배경을 감지하므로, 터미널이 OS 화면 모드 변경을 따를 때마다 테마도 함께 따라갑니다. Claude Code는 터미널 자체의 색 구성표를 제어하지 않으며, 이는 터미널 애플리케이션에서 설정됩니다.

인터페이스 하단에 표시되는 내용을 사용자 지정하려면 현재 모델, 작업 디렉터리, git 브랜치 또는 기타 컨텍스트를 보여주는 [사용자 지정 상태줄](https://code.claude.com/docs/ko/statusline.md)을 구성합니다.

### 사용자 지정 테마 만들기

`/theme`에는 기본 제공 프리셋 외에도 사용자가 정의한 사용자 지정 테마와 설치된 [플러그인](https://code.claude.com/docs/ko/plugins/components.md#themes-and-output-styles)이 제공하는 테마가 모두 나열됩니다. 목록 끝에 있는 \*\*New custom theme…\*\*을 선택하면 대화형으로 테마를 만들 수 있습니다. 테마 이름을 지정한 다음 재정의할 개별 색상 토큰을 선택합니다. 사용자 지정 테마가 강조 표시된 상태에서 `Ctrl+E`를 누르면 해당 테마를 편집할 수 있습니다.

각 사용자 지정 테마는 `~/.claude/themes/`에 있는 JSON 파일입니다. `.json` 확장자를 제외한 파일 이름이 테마의 슬러그가 되며, 테마를 선택하면 `custom:<slug>`가 테마 기본 설정으로 저장됩니다. 파일에는 세 가지 선택적 필드가 있습니다.

| 필드 | 유형 | 설명 |
| :- | :- | :- |
| `name` | string | `/theme`에 표시되는 레이블입니다. 기본값은 파일 이름 슬러그입니다 |
| `base` | string | 테마의 기반이 되는 기본 제공 프리셋으로, `dark`, `light`, `dark-daltonized`, `light-daltonized`, `dark-ansi`, `light-ansi` 중 하나입니다. 기본값은 `dark`입니다 |
| `overrides` | object | 색상 토큰 이름을 색상 값에 매핑한 객체입니다. 여기에 나열되지 않은 토큰은 기반 프리셋의 값을 사용합니다 |

색상 값으로는 `#rrggbb`, `#rgb`, `rgb(r,g,b)`, `ansi256(n)` 또는 `ansi:<name>`을 사용할 수 있으며, 여기서 `<name>`은 `red`나 `cyanBright`와 같은 16가지 표준 ANSI 색상 이름 중 하나입니다. 알 수 없는 토큰과 잘못된 색상 값은 무시되므로 오타로 인해 렌더링이 깨지지 않습니다.

다음 예시는 dark 프리셋을 유지하면서 프롬프트 강조 색상, 오류 텍스트, 성공 텍스트의 색상을 변경하는 테마를 정의합니다.

```json ~/.claude/themes/dracula.json theme={null}
{
  "name": "Dracula",
  "base": "dark",
  "overrides": {
    "claude": "#bd93f9",
    "error": "#ff5555",
    "success": "#50fa7b"
  }
}
```

Claude Code는 `~/.claude/themes/`를 감시하다가 파일이 추가되거나 변경되면 다시 로드하므로, 편집기에서 수정한 내용이 재시작 없이 실행 중인 세션에 적용됩니다. Claude Code를 시작할 때 `~/.claude/themes/` 폴더 자체가 존재하지 않았다면, 첫 번째 테마 파일을 만든 후 한 번 재시작합니다. 그 이후에는 변경 사항이 재시작 없이 적용됩니다.

아래 참조에서는 `overrides`에 설정할 수 있는 토큰을 다룹니다. `/theme`의 대화형 편집기는 동일한 토큰을 실시간 미리보기와 함께 보여주며, 여기서는 생략된 온보딩 화면 색상과 같은 몇 가지 단일 용도 강조 색상도 함께 표시합니다.

> [accordion] 색상 토큰 참조
>
> 다음 예시는 아래 여러 그룹의 토큰을 조합합니다. 브랜드 강조 색상, 플랜 모드 테두리, diff 배경, 메시지 배경이 포함됩니다.
>
> ```json ~/.claude/themes/midnight.json theme={null}
> {
>   "name": "Midnight",
>   "base": "dark",
>   "overrides": {
>     "claude": "#a78bfa",
>     "planMode": "#38bdf8",
>     "diffAdded": "#14532d",
>     "diffRemoved": "#7f1d1d",
>     "userMessageBackground": "#1e1b4b"
>   }
> }
> ```
>
> #### 텍스트 및 강조 색상
>
> 인터페이스 전반에서 사용되는 기본 브랜드 강조 색상과 전경 텍스트 색조를 제어합니다.
>
> | 토큰 | 제어 대상 |
> | :- | :- |
> | `claude` | 기본 브랜드 강조 색상으로, 스피너와 어시스턴트 레이블에 사용됩니다 |
> | `text` | 기본 전경 텍스트 |
> | `inverseText` | 상태 배지처럼 색상이 있는 배경 위에 그려지는 텍스트 |
> | `inactive` | 힌트, 타임스탬프, 비활성화된 항목과 같은 보조 텍스트 |
> | `subtle` | 희미한 테두리 및 덜 강조된 보조 텍스트 |
> | `suggestion` | 자동 완성 제안 및 선택기의 선택 강조 표시 |
> | `permission` | 권한 프롬프트와 선택기를 포함한 대화 상자 테두리 |
> | `remember` | 메모리 및 `CLAUDE.md` 표시기 |
>
> #### 상태 색상
>
> 메시지와 표시기 전반에서 성공, 실패, 경고 상태를 나타냅니다.
>
> | 토큰 | 제어 대상 |
> | :- | :- |
> | `success` | 성공 메시지 및 통과한 검사 |
> | `error` | 오류 메시지 및 실패 |
> | `warning` | 경고, 주의 메시지 및 자동 모드 표시기 |
> | `merged` | 병합된 풀 리퀘스트 상태 |
>
> #### 입력 상자 및 모드 표시기
>
> 입력 상자 테두리 색상과 권한 모드 또는 표시기가 활성화되어 있는 동안 표시되는 강조 색상을 설정합니다.
>
> | 토큰 | 제어 대상 |
> | :- | :- |
> | `promptBorder` | 입력 상자 테두리 |
> | `planMode` | 플랜 모드 강조 색상, 플랜 메시지 및 플랜 모드 대화 상자 |
> | `autoAccept` | 편집 수락 모드 강조 색상 |
> | `bashBorder` | `!` 셸 명령을 입력할 때의 입력 상자 테두리 |
> | `ide` | IDE 연결 표시기 |
> | `fastMode` | 빠른 모드 표시기 |
> | `effortUltra` | [ultracode](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)가 켜져 있는 동안 입력 상자 테두리에 표시되는 `ultracode` 태그. 이 색상의 재정의는 Claude Code v2.1.239 이상에서 적용됩니다 |
>
> #### diff 렌더링
>
> 파일 편집 및 검토에서 추가되거나 제거된 코드의 색상을 지정합니다.
>
> | 토큰 | 제어 대상 |
> | :- | :- |
> | `diffAdded` | 추가된 줄의 배경 |
> | `diffRemoved` | 제거된 줄의 배경 |
> | `diffAddedDimmed` | 편집을 거부한 후 표시되는 흐리게 처리된 diff에서 추가된 줄의 배경 |
> | `diffRemovedDimmed` | 편집을 거부한 후 표시되는 흐리게 처리된 diff에서 제거된 줄의 배경 |
> | `diffAddedWord` | 추가된 줄 내의 단어 수준 강조 표시 |
> | `diffRemovedWord` | 제거된 줄 내의 단어 수준 강조 표시 |
>
> #### 전체 화면 모드
>
> Claude Code는 `userMessageBackgroundHover`, `selectionBg`, `composerSidebarBackground`를 [전체 화면 렌더링 모드](https://code.claude.com/docs/ko/fullscreen.md)에서만 사용합니다. `userMessageBackground`, `bashMessageBackgroundColor`, `memoryBackgroundColor`는 기본 렌더러와 전체 화면 렌더러 모두에서 적용됩니다.
>
> | 토큰 | 제어 대상 |
> | :- | :- |
> | `userMessageBackground` | 트랜스크립트에서 사용자 메시지 뒤의 배경 |
> | `userMessageBackgroundHover` | 마우스를 올리거나 펼친 상태의 메시지 뒤 배경 |
> | `bashMessageBackgroundColor` | 트랜스크립트에서 `!` 셸 명령 항목 뒤의 배경 |
> | `memoryBackgroundColor` | 트랜스크립트에서 `#` 메모리 항목 뒤의 배경 |
> | `selectionBg` | 마우스로 선택한 텍스트의 배경 |
> | `composerSidebarBackground` | [diff 패널](https://code.claude.com/docs/ko/fullscreen.md#watch-your-changes-in-the-diff-panel)이나 [mod의 창](https://code.claude.com/docs/ko/plugins/mods/interface.md)처럼 대화 옆에 있는 패널의 배경 |
>
> #### 사용량 미터 및 화자 레이블
>
> `/usage` 보기에 표시되는 막대와 사용자의 메시지를 Claude의 메시지와 구분하는 레이블을 조정합니다.
>
> | 토큰 | 제어 대상 |
> | :- | :- |
> | `rate_limit_fill` | 사용량 미터의 채워진 부분 |
> | `rate_limit_empty` | 사용량 미터의 채워지지 않은 부분 |
> | `briefLabelYou` | 사용자 메시지에 표시되는 `You` 레이블의 색상 |
> | `briefLabelClaude` | 어시스턴트 메시지에 표시되는 `Claude` 레이블의 색상 |
>
> #### 시머 변형 및 서브에이전트 색상
>
> 여러 토큰에는 스피너의 애니메이션 그라데이션에 사용되는 더 밝은 색상을 제공하는 시머 변형이 짝지어져 있습니다. 애니메이션 색상이 어울리지 않아 보이면 기본 토큰과 함께 시머도 재정의합니다.
>
> * `claude` 및 `claudeShimmer`
> * `warning` 및 `warningShimmer`
> * `permission` 및 `permissionShimmer`
> * `promptBorder` 및 `promptBorderShimmer`
> * `inactive` 및 `inactiveShimmer`
> * `fastMode` 및 `fastModeShimmer`
>
> 각 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)와 병렬 작업은 트랜스크립트에서 구분할 수 있도록 8가지 이름이 지정된 색상 중 하나로 표시됩니다. 토큰 이름은 `<color>_FOR_SUBAGENTS_ONLY` 패턴을 따르며, 여기서 `<color>`는 `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan` 중 하나입니다. 이 토큰을 재정의하여 각 이름이 지정된 색상의 모양을 변경할 수 있습니다. 예를 들어 정의에 `color: blue`가 있는 서브에이전트는 `blue_FOR_SUBAGENTS_ONLY` 값을 사용하여 그려집니다.
>
> [`ultrathink`](https://code.claude.com/docs/ko/model-config#use-ultrathink-for-one-off-deep-reasoning)가 턴의 effort를 높일 수 있는 경우, Claude Code는 프롬프트 입력에서 해당 단어를 7가지 색상의 무지개 그라데이션으로 렌더링합니다. 토큰 이름은 `rainbow_<color>` 및 `rainbow_<color>_shimmer` 패턴을 따르며, 여기서 `<color>`는 `red`, `orange`, `yellow`, `green`, `blue`, `indigo`, `violet` 중 하나입니다.

## 전체 화면 렌더링으로 전환

[화면 읽기 모드](https://code.claude.com/docs/ko/accessibility.md)에서는 이 섹션이 적용되지 않습니다. Claude Code는 연결된 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)을 제외하고는 항상 일반 스크롤 텍스트로 렌더링되며, 다른 세션에서 `/tui fullscreen`을 실행하면 Claude Code는 전환하는 대신 설명을 출력합니다.

Claude가 작업 중일 때 디스플레이가 깜박이거나 스크롤 위치가 점프하면 [전체 화면 렌더링 모드](https://code.claude.com/docs/ko/fullscreen.md)로 전환하세요. 이 모드에서는 터미널의 기본 스크롤백이 아닌 마우스나 PageUp으로 Claude Code 내에서 스크롤합니다. 검색 및 복사 방법은 [전체 화면 페이지](https://code.claude.com/docs/ko/fullscreen.md#search-and-review-the-conversation)를 참조하세요.

깜박임이 유일한 문제이고 터미널이 동기화된 출력을 지원하지만 Emacs `eat`과 같이 자동 감지되지 않는 경우, [`CLAUDE_CODE_FORCE_SYNC_OUTPUT=1`](https://code.claude.com/docs/ko/env-vars)을 설정하여 렌더러를 변경하지 않고 깜박임을 중지할 수 있습니다.

`/tui fullscreen`을 실행하여 전환하고 기본 설정을 저장하세요. 대화가 그대로 다시 시작되며 [전체 화면 시작이 실패](https://code.claude.com/docs/ko/fullscreen.md#fullscreen-renderer-didnt-finish-starting)하지 않는 한 향후 세션은 전체 화면에서 시작됩니다. Claude Code를 시작하기 전에 `CLAUDE_CODE_NO_FLICKER` 환경 변수를 설정할 수도 있습니다.

```bash Bash and Zsh theme={null}
CLAUDE_CODE_NO_FLICKER=1 claude
```

```powershell PowerShell theme={null}
$env:CLAUDE_CODE_NO_FLICKER = "1"; claude
```

```json ~/.claude/settings.json theme={null}
{
  "env": {
    "CLAUDE_CODE_NO_FLICKER": "1"
  }
}
```

## 넓은 터미널에서 응답 너비 제한하기

넓은 터미널에서 Claude의 응답에 있는 각 줄의 문장이 창의 전체 너비로 표시됩니다. 대신 문장을 설정된 열 수에서 줄바꿈하려면 설정에서 [`maxProseWidth`](https://code.claude.com/docs/ko/settings-reference#maxprosewidth)를 설정하십시오.

## 대용량 콘텐츠 붙여넣기

프롬프트에 800자 이상 또는 3줄 이상의 텍스트를 붙여넣으면 Claude Code는 입력을 `[Pasted text #1 +120 lines]`과 같은 플레이스홀더로 축약하여 입력 상자를 사용 가능한 상태로 유지하고, 제출할 때 전체 콘텐츠를 여전히 전송합니다. 전체 파일이나 긴 로그와 같은 매우 큰 입력의 경우, 콘텐츠를 파일에 작성하고 붙여넣기 대신 Claude에 파일을 읽도록 요청합니다. 대화 기록을 읽기 쉽게 유지하고 Claude가 나중 차례에서 경로로 파일을 참조할 수 있습니다. VS Code 통합 터미널은 매우 큰 붙여넣기에서 Claude Code에 도달하기 전에 문자를 삭제할 수 있으므로, 거기서는 파일을 사용합니다.

붙여넣기에 [보이지 않는 유니코드 문자](https://code.claude.com/docs/ko/interactive-mode.md#invisible-characters-in-prompts)가 포함되어 있으면 Claude Code는 Enter를 누를 때 이를 제거하고 정리된 프롬프트를 입력 상자에 다시 넣어서 다른 Enter로 전송할 수 있도록 합니다.

### Claude가 붙여넣은 텍스트를 처리하는 방식

제출하면 Claude는 각 `[Pasted text #N]` 플레이스홀더 뒤의 콘텐츠를 입력한 것이 아니라 다른 곳에서 붙여넣은 텍스트로 표시된 것을 봅니다. Claude는 붙여넣기가 작성하지 않은 지시사항을 포함할 수 있으며, 입력한 메시지가 요청하는 경우에만 그 안의 지시사항을 따르도록 지시받습니다. [기능 플래그를 가져오지](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) 않는 세션에서는 붙여넣기가 표시되지 않습니다.

### 축약된 붙여넣기 삭제 및 복원

`Ctrl+W` 또는 `Ctrl+K`와 같은 단어 또는 줄 단축키로 삭제하거나, `df]`와 같은 `f`/`t` 모션을 통한 vim 삭제로 삭제하고, 삭제된 범위가 `[Pasted text #N]` 플레이스홀더 내부에 도달하면 Claude Code는 플레이스홀더 전체를 제거합니다. [`Ctrl+Y`](https://code.claude.com/docs/ko/interactive-mode#text-editing)를 단어 또는 줄 단축키 후에 사용하거나, vim 삭제 후 [`p` NORMAL 모드](https://code.claude.com/docs/ko/interactive-mode#editing-normal-mode)를 사용하여 삭제를 다시 붙여넣을 수 있습니다.

### 붙여넣은 텍스트가 있는 프롬프트 회수

Claude Code는 축약된 각 `[Pasted text #N]` 플레이스홀더 뒤의 콘텐츠를 `~/.claude/paste-cache/` 아래에 유지하므로, [명령 기록](https://code.claude.com/docs/ko/interactive-mode.md#command-history)에서 프롬프트를 회수하고 다시 제출하면 전체 붙여넣은 콘텐츠가 다시 전송되며, 나중 세션에서도 포함됩니다. [`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays)보다 오래된 캐시 파일은 [보존 스윕 규칙](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)에 따라 삭제되므로, 회수된 프롬프트는 더 이상 존재하지 않는 붙여넣은 텍스트를 참조할 수 있습니다. 이러한 프롬프트를 제출하면 Claude Code는 절대 리터럴 `[Pasted text #N]` 문자열을 전송하지 않으며, 누락된 붙여넣기의 이름을 지정하는 알림을 표시합니다:

* 남은 텍스트가 있는 일반 프롬프트에서 Claude Code는 플레이스홀더를 제거하고 남은 텍스트를 전송합니다.
* [셸 모드](https://code.claude.com/docs/ko/interactive-mode.md#shell-mode-with-prefix) 명령 또는 `/` 명령에서, 제거가 실행되는 내용을 변경할 수 있으며, 제거가 비어 있는 모든 프롬프트에서 Claude Code는 제출을 취소하고 원본 텍스트를 입력에 유지하며, 플레이스홀더는 여전히 포함됩니다. 플레이스홀더를 삭제하거나 명령을 편집한 후 다시 제출합니다.

## Vim 키바인딩으로 프롬프트 편집하기

Claude Code는 프롬프트 입력을 위한 Vim 스타일 편집 모드를 포함합니다. `/config` → Editor mode를 통해 활성화하거나, `~/.claude/settings.json`에서 [`editorMode`](https://code.claude.com/docs/ko/settings-reference#editormode)를 `"vim"`으로 설정하여 활성화할 수 있습니다. Editor mode를 `normal`로 다시 설정하여 비활성화합니다.

Vim 모드는 `hjkl` 네비게이션, `v`/`V` 선택, 텍스트 객체와 함께 `d`/`c`/`y` 같은 NORMAL 모드 및 VISUAL 모드 모션과 연산자의 부분 집합을 지원합니다. 전체 키 테이블은 [Vim 편집기 모드 참조](https://code.claude.com/docs/ko/interactive-mode.md#vim-editor-mode)를 참조하십시오.

Vim 모션은 키바인딩 파일을 통해 재매핑할 수 없습니다. `jj`를 Escape로 매핑하는 것과 같은 두 개의 키 INSERT 모드 시퀀스를 매핑하려면, 사용자 설정에서 [`vimInsertModeRemaps`](https://code.claude.com/docs/ko/interactive-mode#remap-insert-mode-key-sequences)를 설정하십시오.

INSERT 모드에서 Enter를 누르면 표준 Vim과 달리 프롬프트가 여전히 제출됩니다. 대신 NORMAL 모드에서 `o` 또는 `O`를 사용하거나 Ctrl+J를 사용하여 새 줄을 삽입하십시오.

## 관련 리소스

* [대화형 모드](https://code.claude.com/docs/ko/interactive-mode.md): 전체 키보드 단축키 참조 및 Vim 키 테이블
* [키 바인딩](https://code.claude.com/docs/ko/keybindings.md): Enter 및 Shift+Enter를 포함한 모든 Claude Code 단축키 다시 매핑
* [전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md): 전체 화면 모드에서 스크롤, 검색 및 복사에 대한 세부 정보
* [훅 가이드](https://code.claude.com/docs/ko/hooks-guide.md): Linux 및 Windows용 더 많은 알림 훅 예제
* [문제 해결](https://code.claude.com/docs/ko/troubleshooting.md): 터미널 구성 외부의 문제에 대한 수정 사항
