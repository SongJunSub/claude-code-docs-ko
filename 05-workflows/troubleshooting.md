> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 문제 해결

> Claude Code에서 높은 CPU 또는 메모리 사용량, 중단, 자동 압축 스래싱 및 검색 문제를 해결하고 다른 문제에 대한 올바른 페이지를 찾습니다.

이 페이지는 Claude Code가 실행 중일 때의 성능, 안정성 및 검색 문제를 다룹니다. 다른 문제의 경우 문제가 있는 위치와 일치하는 페이지부터 시작하세요:

| 증상 | 이동 |
| :- | :- |
| `command not found`, 설치 실패, PATH 문제, `EACCES`, TLS 오류 | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md) |
| `The connection dropped while downloading the update` 또는 `aborted`로 업데이트 또는 설치 다운로드 실패 | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#the-connection-dropped-while-downloading-the-update) |
| `Release verification failed for Claude Code`로 업데이트 또는 설치 실패 | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#release-verification-failed) |
| 세션 하단에 빨간색으로 `Auto-update failed · Run claude doctor`가 표시됨 | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#auto-update-failed) |
| 로그인 루프, OAuth 오류, `403 Forbidden`, "organization disabled", Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry 자격 증명 | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#login-and-authentication) |
| 설정이 적용되지 않음, hooks가 실행되지 않음, MCP 서버가 로드되지 않음 | [구성 디버깅](https://code.claude.com/docs/ko/debug-your-config.md) |
| 세션이 자동 모드에서 시작되었거나 Claude가 묻지 않고 파일을 편집하고 명령을 실행함 | [세션이 시작되는 모드](https://code.claude.com/docs/ko/permission-modes.md#which-mode-a-session-starts-in) |
| Claude Code 또는 Agent SDK를 업데이트한 후 `--permission-mode`, `permissionMode` 또는 `permission_mode`를 전달하지 않는 `claude -p` 또는 SDK 실행에서 도구 호출이 거부됨 | [`claude -p` 및 Agent SDK 실행에서 거부되는 도구 호출](https://code.claude.com/docs/ko/permission-modes#which-mode-a-non-interactive-run-starts-in) |
| `API Error: 5xx`, `529 Overloaded`, `429`, 요청 검증 오류 | [오류 참조](https://code.claude.com/docs/ko/errors.md) |
| `model not found` 또는 `you may not have access to it` | [오류 참조](https://code.claude.com/docs/ko/errors.md#theres-an-issue-with-the-selected-model) |
| Claude가 실행하는 명령이 `Disk full:`, `Disk quota used up:`, `Nearly out of inodes:`, `The command was not started:`, `Your disk quota is full`, `is full (ENOSPC)` 또는 `Command output was lost`로 실패함 | [오류 참조](https://code.claude.com/docs/ko/errors.md#disk-quota-or-temp-filesystem-is-full) |
| VS Code 확장이 Claude에 연결되지 않거나 감지하지 못함 | [VS Code 통합](https://code.claude.com/docs/ko/vs-code.md#fix-common-issues) |
| VS Code 또는 SDK 앱에서 `Claude Code process exited with code 1` | [오류 참조](https://code.claude.com/docs/ko/errors.md#claude-code-process-exited-with-code-n) |
| JetBrains 플러그인 또는 IDE가 감지되지 않음 | [JetBrains 통합](https://code.claude.com/docs/ko/jetbrains.md#troubleshooting) |
| 높은 CPU 또는 메모리, 느린 응답, 중단, 검색이 파일을 찾지 못함 | [성능 및 안정성](#performance-and-stability) 아래 |

어떤 것이 적용되는지 확실하지 않으면 Claude Code 내에서 `/doctor`를 실행하여 설치, 설정, 확장 및 컨텍스트 사용을 자동으로 확인하세요. 이 도구는 확인 후 적용할 수 있는 수정 사항을 제안합니다. `claude`가 전혀 시작되지 않으면 셸에서 `claude doctor`를 대신 실행하세요. `/mcp`를 실행하여 MCP 서버 상태를 확인하세요.

## 성능 및 안정성

이 섹션에서는 리소스 사용, 응답성 및 검색 동작과 관련된 문제를 다룹니다.

### 높은 CPU 또는 메모리 사용량

Claude Code는 대부분의 개발 환경에서 작동하도록 설계되었지만 대규모 코드베이스를 처리할 때 상당한 리소스를 소비할 수 있습니다. 성능 문제가 발생하는 경우:

1. `/compact`를 정기적으로 사용하여 컨텍스트 크기를 줄입니다. `Not enough messages to compact.`를 반환하면 대화에 요약할 턴이 너무 적습니다. 이는 단일 대규모 붙여넣기가 컨텍스트를 채웠을 때 전체 컨텍스트가 있어도 발생할 수 있습니다.
2. 주요 작업 사이에 Claude Code를 닫고 다시 시작합니다.
3. 큰 빌드 디렉토리를 `.gitignore` 파일에 추가하는 것을 고려합니다.
4. [`claude --safe-mode`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 다시 시작하여 플러그인, MCP 서버 또는 hook이 원인인지 확인합니다. 이는 세션의 모든 사용자 정의를 비활성화합니다. 사용량이 감소하면 [구성 디버깅](https://code.claude.com/docs/ko/debug-your-config.md#test-against-a-clean-configuration)을 참조하여 어느 것이 원인인지 찾습니다.

세션의 힙 메모리가 2.5GB를 초과하면 중요한 메모리 사용량 경고가 나타납니다. 메모리를 해제하려면 Claude Code를 다시 시작하고 [`claude --continue`](https://code.claude.com/docs/ko/cli-reference#cli-flags)를 실행하여 새로운 프로세스에서 대화를 재개합니다.

[전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md) 외부에서 `/compact`를 실행하면 메모리도 해제됩니다. 메모리 사용량이 2.5GB 아래로 떨어지면 경고가 사라집니다.

이 단계 후에도 메모리 사용량이 높게 유지되면 `/heapdump`를 실행하여 두 개의 파일을 `~/Desktop`에 작성합니다. `<session-id>.heapsnapshot`이라는 JavaScript 힙 스냅샷과 `<session-id>-diagnostics.json`이라는 메모리 분석입니다. Claude Code는 [명령 메뉴에서 명령을 숨깁니다](https://code.claude.com/docs/ko/commands.md#how-the-command-menu-matches-what-you-type). 전체를 입력합니다. Linux에 Desktop 폴더가 없으면 파일이 홈 디렉토리에 작성됩니다.

> [!WARNING]
>
> `.heapsnapshot` 파일에는 프로세스의 모든 문자열이 포함되어 있으며, 전체 대화 및 자격 증명을 포함합니다. 공개 이슈에 첨부하거나 공유하지 마십시오.

명령은 또한 대화에 요약을 인쇄하여 프로세스의 총 메모리, JS 힙에 있는 양, 힙 외부에 있는 양을 표시합니다. 요약은 또한 높은 메모리 증가율 또는 비정상적으로 높은 열린 핸들 수와 같은 누수 표시기를 나열합니다. 요약은 대부분의 메모리가 스냅샷이 캡처하는 JS 힙에 있는지 또는 스냅샷이 캡처하지 않는 네이티브 메모리에 있는지 나타냅니다.

출력으로 다음 두 가지 중 하나를 수행합니다:

* **보고합니다**: [GitHub 이슈](https://github.com/anthropics/claude-code/issues)를 열고 `-diagnostics.json` 파일만 첨부합니다. 이 파일은 인쇄된 요약 뒤의 통계를 포함하며 대화 내용이나 자격 증명은 포함하지 않습니다.
* **직접 조사합니다**: 요약이 대부분의 메모리가 JS 힙에 있다고 말하면 Chrome DevTools의 Memory → Load에서 `.heapsnapshot` 파일을 열고 보유된 크기로 정렬하여 메모리를 보유하고 있는 것을 확인합니다.

요약이 대부분의 메모리가 네이티브라고 말하면 스냅샷이 이를 표시할 수 없습니다. 대신 요약의 누수 표시기를 보고에 포함합니다.

### 터미널에서 큰 테이블이 잘림

200개 이상의 행이 있는 Markdown 테이블은 처음 200개 행을 렌더링한 후 `… N more rows not shown` 줄을 표시합니다. 표시만 제한됩니다. 전체 테이블은 대화에 남아 있으며 [`/copy`](https://code.claude.com/docs/ko/commands)는 모든 행을 복사합니다. 터미널에서 읽기에 너무 큰 테이블의 경우 Claude에게 대신 파일에 작성하도록 요청합니다. v2.1.208 이전에는 Claude Code가 모든 행을 렌더링했으므로 매우 큰 테이블이 포함된 세션을 다시 시작하면 다시 렌더링하는 동안 중단될 수 있었습니다.

### 자동 압축이 스래싱 오류로 중단됨

`Autocompact is thrashing: the context refilled to the limit...`이 표시되면 자동 압축이 성공했지만 파일 또는 도구 출력이 즉시 컨텍스트 창을 여러 번 연속으로 다시 채웠습니다. Claude Code는 진행되지 않는 루프에서 API 호출을 낭비하지 않기 위해 재시도를 중단합니다.

복구하려면:

1. Claude에게 전체 파일 대신 특정 줄 범위 또는 함수와 같은 더 작은 청크로 큰 파일을 읽도록 요청합니다.
2. 큰 출력을 삭제하는 포커스로 `/compact`를 실행합니다. 예: `/compact keep only the plan and the diff`
3. 큰 파일 작업을 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)로 이동하여 별도의 컨텍스트 창에서 실행합니다.
4. 이전 대화가 더 이상 필요하지 않으면 `/clear`를 실행합니다.

`/clear` 후에도 오류가 다시 발생하면 [`/context`](https://code.claude.com/docs/ko/debug-your-config)를 실행하고 `Messages` 행을 그 위의 행들과 비교합니다:

* **`Messages`가 가장 큰 행인 경우**: 새 대화의 파일 또는 도구 출력이 윈도우를 다시 채우고 있으므로 1\~3단계를 다시 진행합니다.
* **나머지 행을 합친 것이 더 큰 경우**: 세션 시작 시 로드되는 항목 때문에 작업할 공간이 너무 적게 남으므로 [시작 시 로드되는 항목을 줄입니다](https://code.claude.com/docs/ko/errors.md#prompt-is-too-long).

### 명령 중단 또는 정지

Claude Code가 응답하지 않는 것처럼 보이면:

1. Ctrl+C를 눌러 현재 작업을 취소하려고 시도합니다.
2. 응답하지 않으면 터미널을 닫고 다시 시작해야 할 수 있습니다.

다시 시작해도 대화가 손실되지 않습니다. 같은 디렉토리에서 `claude --resume`을 실행하여 세션을 다시 시작합니다.

### 편집기의 통합 터미널에서 손상되거나 깨진 텍스트

VS Code, Cursor 또는 Devin Desktop 통합 터미널에서 Claude Code를 실행할 때 문자가 상자, 얼룩 또는 잘못된 글리프로 렌더링되면 터미널의 GPU 렌더러가 원인일 가능성이 높습니다. Claude Code 내에서 `/terminal-setup`을 실행하여 `terminal.integrated.gpuAcceleration`을 `"off"`로 설정하거나 편집기 설정에서 수동으로 설정하고 창을 다시 로드합니다. `/terminal-setup`이 작성하는 다른 설정에 대해서는 [터미널 구성](https://code.claude.com/docs/ko/terminal-config.md)을 참조합니다.

### 시작 시 `>0q` 또는 종료 후 `>4m`이 표시됨

0.53보다 오래된 VTE 라이브러리를 기반으로 하는 터미널에서 출력되는 이 문자들은 두 Claude Code 제어 시퀀스의 끝부분입니다. 이 텍스트가 나타나지 않게 하려면 [Claude Code를 업데이트](https://code.claude.com/docs/ko/setup.md#update-claude-code)하여 v2.1.301 이상을 사용합니다. 이 버전은 해당 터미널을 식별하면 두 시퀀스를 모두 건너뜁니다.

텍스트가 계속 나타나면 터미널의 셸에서 VTE 버전을 출력합니다:

```bash theme={null}
echo $VTE_VERSION
```

VTE 기반 터미널에서 결과가 `5300` 미만이면 0.53보다 오래된 라이브러리라는 의미입니다. 터미널을 업데이트하거나 교체하여 VTE 0.53 이상을 사용합니다. 그렇지 않으면 [추가 도움 받기](#get-more-help)를 참조합니다.

### 전체 화면 렌더링에서 마우스 휠이 한 번에 한 줄씩 스크롤됨

[전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md)에서 Claude Code는 대화 자체를 스크롤하며 터미널에 맡기지 않습니다. 각 휠 노치가 원하는 것보다 적은 줄을 이동하면 `/scroll-speed`를 실행하여 노치당 줄 수를 높이고 저장하거나 `CLAUDE_CODE_SCROLL_SPEED` 환경 변수를 설정합니다. JetBrains IDE 터미널에서는 Claude Code가 자체 스크롤 처리를 적용하므로 둘 다 적용되지 않습니다. 각각이 허용하는 값에 대해서는 [마우스 휠 스크롤](https://code.claude.com/docs/ko/fullscreen.md#mouse-wheel-scrolling)을 참조합니다.

더 빠르게 이동하려면 속도를 변경하지 않고 `PgUp` 및 `PgDn`을 눌러 한 번에 반 화면씩 스크롤합니다. 스크롤을 터미널의 기본 스크롤백으로 돌려주려면 `/tui default`를 실행하여 클래식 렌더러로 전환합니다.

### 샌드박스 내에서 `pbcopy`와 같은 클립보드 명령이 실패함

[샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)이 켜져 있으면 `pbcopy`, `xclip` 및 `wl-copy`와 같은 클립보드 유틸리티가 샌드박스된 Bash 명령 내에서 시스템 클립보드에 도달하지 못할 수 있으며, Claude가 텍스트를 파이프한 후 클립보드가 변경되지 않은 상태로 남습니다.

Claude의 출력을 클립보드에 넣으려면 Claude에게 응답에서 내용을 인쇄하도록 요청한 다음 [`/copy`](https://code.claude.com/docs/ko/commands)를 실행합니다. `/copy`는 샌드박스된 명령이 아닌 Claude Code 프로세스 자체에서 클립보드에 작성하므로 샌드박싱이 이를 차단하지 않습니다. 전체 응답 대신 단일 코드 블록을 복사할 수 있으며, 복사한 내용을 파일에 작성하고 경로를 인쇄하므로 SSH를 통한 경우와 같이 클립보드 쓰기가 터미널에 도달하지 않을 때 폴백을 제공합니다.

Claude가 텍스트를 이러한 도구 중 하나로 파이프할 때 [`excludedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-excludedcommands)에 `pbcopy *`, `wl-copy *` 또는 `xclip *`을 추가하면 해당 호출이 자동으로 샌드박스 외부에서 실행되지는 않습니다.

### SSH를 통해 복사된 텍스트가 로컬 클립보드에 도달하지 않음

Claude Code가 SSH를 통해 원격 머신에서 실행되면 로컬 머신에서 클립보드 도구를 실행할 수 없습니다. tmux 외부에서 [전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md)에서 텍스트를 선택하거나 `/copy`를 실행하면 Claude Code는 텍스트를 OSC 52 이스케이프 시퀀스로 터미널에 보냅니다. 터미널이 클립보드에 넣을지 여부를 결정합니다. `/copy`는 텍스트 도착 여부와 관계없이 `Copied to clipboard`를 보고하며, tmux 외부의 선택 알림은 `sent N chars via OSC 52`를 읽습니다.

일부 터미널은 OSC 52에 작동하지 않습니다. iTerm2는 **Settings > General > Selection > Applications in terminal may access clipboard**를 켤 때까지 무시하며, macOS Terminal.app은 이를 지원하지 않습니다.

OSC 52 없이 텍스트를 얻으려면:

* 터미널의 기본 선택 키를 누른 상태에서 드래그한 다음 `Cmd+C`와 같은 터미널의 일반적인 단축키로 복사합니다. 키는 Terminal.app에서 `Fn`이고 iTerm2에서 `Option`입니다. [기본 텍스트 선택 유지](https://code.claude.com/docs/ko/fullscreen.md#keep-native-text-selection)는 다른 터미널에 대해 나열합니다.
* 원격 머신에서 [`CLAUDE_CODE_DISABLE_MOUSE=1`](https://code.claude.com/docs/ko/env-vars)을 설정하여 터미널이 전체 세션에 대해 선택을 처리하도록 합니다.

### 검색 및 발견 문제

Search 도구, `@file` 언급, 사용자 정의 에이전트 또는 사용자 정의 skills가 파일을 찾지 못하면 번들된 `ripgrep` 바이너리가 시스템에서 실행되지 않을 수 있습니다. 플랫폼의 `ripgrep` 패키지를 설치하고 Claude Code에 대신 사용하도록 지시합니다:

> [tab] macOS
>
> ```bash theme={null}
> brew install ripgrep
> ```

> [tab] Ubuntu/Debian
>
> ```bash theme={null}
> sudo apt install ripgrep
> ```

> [tab] Alpine
>
> ```bash theme={null}
> apk add ripgrep
> ```
>
> `ripgrep`은 Alpine의 커뮤니티 저장소에 있습니다. `apk`가 패키지가 누락되었다고 보고하면 [Alpine Linux 설정](https://code.claude.com/docs/ko/setup.md#alpine-linux-and-musl-based-distributions)을 참조합니다.

> [tab] Arch
>
> ```bash theme={null}
> pacman -S ripgrep
> ```

> [tab] Windows
>
> ```powershell theme={null}
> winget install BurntSushi.ripgrep.MSVC
> ```

그런 다음 `USE_BUILTIN_RIPGREP`을 `0`으로 설정합니다. 셸 [환경](https://code.claude.com/docs/ko/env-vars.md) 또는 [`settings.json`](https://code.claude.com/docs/ko/settings-reference#all-settings)의 `env` 블록에서:

```json theme={null}
{
  "env": {
    "USE_BUILTIN_RIPGREP": "0"
  }
}
```

전환이 적용되었는지 확인하려면 터미널에서 `claude doctor`를 실행하고 Search 줄이 `OK (bundled)` 대신 시스템 ripgrep의 경로를 표시하는지 확인합니다.

### WSL에서 느리거나 불완전한 검색 결과

[WSL에서 파일 시스템 간 작업](https://learn.microsoft.com/en-us/windows/wsl/filesystems)할 때 디스크 읽기 성능 저하로 인해 WSL에서 Claude Code를 사용할 때 예상보다 적은 일치 항목이 발생할 수 있습니다. 검색은 여전히 작동하지만 네이티브 파일 시스템보다 적은 결과를 반환합니다.

> [!NOTE]
>
> `claude doctor`는 이 경우 검색을 OK로 표시합니다.

**해결책:**

1. **더 구체적인 검색 제출**: 디렉토리 또는 파일 유형을 지정하여 검색되는 파일 수를 줄입니다: "auth-service 패키지에서 JWT 검증 로직 검색" 또는 "JS 파일에서 md5 해시 사용 찾기".

2. **프로젝트를 Linux 파일 시스템으로 이동**: 가능하면 프로젝트가 Windows 파일 시스템(`/mnt/c/`) 대신 Linux 파일 시스템(`/home/`)에 있는지 확인합니다.

3. **Windows 기본 사용**: 더 나은 파일 시스템 성능을 위해 WSL 대신 Windows에서 기본적으로 Claude Code를 실행하는 것을 고려합니다.

## 추가 도움 받기

여기에 다루지 않은 문제가 발생하는 경우:

1. `/doctor`를 실행하여 설치 상태를 확인하고 `/mcp`를 사용하여 MCP 서버 상태를 확인하세요
2. Claude Code 내에서 `/feedback` 명령을 사용하여 Anthropic에 문제를 직접 보고하세요
3. [GitHub 저장소](https://github.com/anthropics/claude-code)에서 알려진 문제를 확인하세요
4. Claude에게 직접 기능 및 특징에 대해 물어보세요. Claude는 문서에 대한 기본 제공 액세스 권한이 있습니다.

계정, 청구 또는 구독 문제의 경우 대신 Anthropic 지원팀에 문의하세요. [claude.ai](https://claude.ai)에 로그인하고(Console 사용자: [platform.claude.com](https://platform.claude.com)), 왼쪽 아래의 이니셜을 클릭한 후 **도움 받기**를 선택하세요. 각 플랜에서 담당자에게 연락할 수 있는 사람을 포함한 전체 절차는 [지원을 받는 방법](https://support.claude.com/en/articles/9015913-how-to-get-support)을 참조하세요.
