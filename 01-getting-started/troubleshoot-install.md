> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 설치 및 로그인 문제 해결

> Claude Code 설치 또는 로그인 시 command not found, PATH, 권한, 네트워크 및 인증 오류를 수정합니다.

설치가 실패하거나 로그인할 수 없는 경우 아래에서 오류를 찾으세요. Claude Code가 작동한 후 런타임 문제의 경우 [문제 해결](https://code.claude.com/docs/ko/troubleshooting.md)을 참조하세요. 설정이 적용되지 않거나 훅이 실행되지 않는 등의 구성 문제의 경우 [구성 디버깅](https://code.claude.com/docs/ko/debug-your-config.md)을 참조하세요.

## 오류 찾기

표시되는 오류 메시지 또는 증상을 수정 사항과 일치시키세요:

| 표시되는 내용 | 해결책 |
| :- | :- |
| `command not found: claude` 또는 `'claude' is not recognized` | [PATH 수정](#command-not-found-claude-after-installation) |
| `Native installation exists but ... is not in your PATH` | [설치 디렉터리를 PATH에 추가](#verify-your-path) |
| `where.exe claude` 실행 시 `INFO: Could not find files for the given pattern(s).` | [Claude Code가 설치되어 있는지 확인](#check-for-conflicting-installations) |
| `zsh: permission denied: /Users/you/.zshrc` 또는 `bash: /home/you/.bashrc: Permission denied` | [셸 구성 파일을 쓰기 가능하도록 설정](#permission-denied-when-adding-to-your-path) |
| `syntax error near unexpected token '<'` | [설치 스크립트가 HTML 반환](#install-script-returns-html-instead-of-a-shell-script) |
| CMD에서 `< was unexpected at this time` | [설치 스크립트가 HTML 반환](#install-script-returns-html-instead-of-a-shell-script) |
| `The term 'System.Xml.XmlDocument' is not recognized` | [설치 스크립트가 HTML 반환](#install-script-returns-html-instead-of-a-shell-script) |
| `curl: (22) The requested URL returned error: 403` | [설치 스크립트가 403 반환](#install-script-returns-html-instead-of-a-shell-script) |
| `curl: (23)` 또는 `curl: (56) Failure writing output to destination` | [연결성 확인 또는 대체 설치 프로그램 사용](#curl-56-failure-writing-output-to-destination) |
| Linux에서 설치 중 `Killed` | [메모리 확보 또는 스왑 공간 추가](#install-killed-on-low-memory-linux-servers) |
| `Installation was killed before it could finish` | [메모리 확보 후 설치 프로그램 다시 실행](#installation-was-killed-before-it-could-finish) |
| 설치 중 `Raw mode is not supported` | [설치 프로그램 다시 실행](#raw-mode-is-not-supported-during-install) |
| 설치 중 `EACCES: permission denied` | [설치 디렉터리의 권한 수정](#permission-errors-during-installation) |
| `TLS connect error` 또는 `SSL/TLS secure channel` | [CA 인증서 업데이트](#tls-or-ssl-connection-errors) |
| `CRYPT_E_NO_REVOCATION_CHECK` 또는 `CRYPT_E_REVOCATION_OFFLINE` | [차단된 인증서 해지 확인 우회](#tls-or-ssl-connection-errors) |
| `Failed to fetch version` 또는 다운로드 서버에 도달할 수 없음 | [네트워크 및 프록시 설정 확인](#check-network-connectivity) |
| `The connection dropped while downloading the update` 또는 `Download timed out: exceeded the total deadline` | [업데이트 다시 실행 또는 프록시 설정](#the-connection-dropped-while-downloading-the-update) |
| `Release verification failed for Claude Code` | [`claude update` 또는 `claude install` 다시 실행](#release-verification-failed) |
| 세션 하단에 빨간색으로 `Auto-update failed · Run claude doctor` 표시 | [셸에서 `claude update` 실행](#auto-update-failed) |
| `irm is not recognized` 또는 `The token '&&' is not a valid statement separator` | [셸에 맞는 명령 사용](#wrong-install-command-on-windows) |
| `Cask 'claude-code' is unavailable: No Cask with this name exists` | [Homebrew 업데이트](#homebrew-cask-unavailable-or-outdated) |
| `Cask 'claude-code@latest' is not installed` | [설치한 cask 업그레이드](#cask-is-not-installed) |
| `'bash' is not recognized as the name of a cmdlet` | [Windows 설치 프로그램 명령 사용](#wrong-install-command-on-windows) |
| `A parameter cannot be found that matches parameter name 'fsSL'` | [Windows 설치 프로그램 명령 사용](#wrong-install-command-on-windows) |
| `Claude Code on Windows requires either Git for Windows (for bash) or PowerShell` | [셸 설치](#claude-code-on-windows-requires-either-git-for-windows-for-bash-or-powershell) |
| `Claude Code does not support 32-bit Windows` | [Windows PowerShell 열기, x86 항목 아님](#claude-code-does-not-support-32-bit-windows) |
| `The process cannot access the file ... because it is being used by another process` | [다운로드 폴더 지우기 및 다시 시도](#the-process-cannot-access-the-file-during-windows-install) |
| `Error loading shared library` | [시스템에 맞는 잘못된 바이너리 변형](#linux-musl-or-glibc-binary-mismatch) |
| `Illegal instruction` | [아키텍처 또는 CPU 명령어 세트 불일치](#illegal-instruction) |
| WSL에서 `cannot execute binary file: Exec format error` | [WSL1 네이티브 바이너리 회귀](#exec-format-error-on-wsl1) |
| 세션 실행 중 `Bus error` 또는 `oh no: Bun has crashed` | [실행 파일을 읽기 가능한 상태로 유지](#bus-error-while-a-session-is-running) |
| PowerShell 설치 프로그램이 완료되지만 `claude`를 찾을 수 없거나 이전 버전 표시 | [설치 디렉터리를 PATH에 추가](#verify-your-path), 그런 다음 새 터미널 열기 |
| macOS에서 `dyld: Symbol not found`, `dyld: cannot load` 또는 `Abort trap` | [바이너리 비호환성](#dyld-cannot-load-on-macos) |
| `claude update`가 `Checking for updates` 후 중단되거나 `claude doctor`가 출력 없이 중단됨 | [셸 구성 경로의 디렉터리 이동](#claude-update-or-claude-doctor-hangs) |
| `Invoke-Expression` 또는 `iex` 구문 분석 오류로 HTML 태그 또는 CSS 인용, 또는 `ParseException`이 있는 `ParserError` | [설치 스크립트가 HTML 반환](#install-script-returns-html-instead-of-a-shell-script) |
| `running scripts is disabled on this system` 또는 `PSSecurityException` | [npm shim이 실행되도록 허용](#running-scripts-is-disabled-on-this-system) |
| `Error: claude native binary not installed` | [npm 설치 완료](#native-binary-not-found-after-npm-install) |
| 업데이트 또는 재설치 중 `npm error code ENOTEMPTY` | [남은 패키지 디렉터리 제거](#npm-enotempty-during-update-or-reinstall) |
| Windows에서 업데이트 직후 `'claude' is not recognized` | [`claude.exe`를 백업에서 복원](#claude-exe-missing-after-an-update-on-windows) |
| Windows에서 설치 명령이 스크립트 텍스트를 인쇄하고 아무것도 설치되지 않음 | [전체 설치 명령 실행](#wrong-install-command-on-windows) |
| `App unavailable in region` | Claude Code는 귀국에서 사용할 수 없습니다. [지원되는 국가](https://www.anthropic.com/supported-countries)를 참조하세요. |
| `unable to get local issuer certificate` | [회사 CA 인증서 구성](#tls-or-ssl-connection-errors) |
| `OAuth error` 또는 `403 Forbidden` | [인증 수정](#login-and-authentication) |
| `Claude Code access has not been granted for this account` | [Claude Code를 포함하는 역할 얻기](#claude-code-access-has-not-been-granted-for-this-account) |
| 설정 중 `Unable to connect to Anthropic services` | 오류 참조에서 [Anthropic 서비스에 연결할 수 없음](https://code.claude.com/docs/ko/errors.md#unable-to-connect-to-anthropic-services)을 참조하세요 |
| `Could not load the default credentials` 또는 `Could not load credentials from any providers` | [Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry 자격 증명](#bedrock-agent-platform-or-foundry-credentials-not-loading) |
| `ChainedTokenCredential authentication failed` 또는 `CredentialUnavailableError` | [Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry 자격 증명](#bedrock-agent-platform-or-foundry-credentials-not-loading) |
| `API Error: 500`, `529 Overloaded`, `429` 또는 위에 나열되지 않은 기타 4xx 및 5xx 오류 | [오류 참조](https://code.claude.com/docs/ko/errors.md)를 참조하세요 |

문제가 나열되지 않은 경우 아래의 진단 검사를 수행하여 원인을 좁혀보세요.

> [!TIP]
>
> 터미널을 완전히 건너뛰고 싶다면 [Claude Code Desktop 앱](https://code.claude.com/docs/ko/desktop-quickstart.md)을 사용하여 그래픽 인터페이스를 통해 Claude Code를 설치하고 사용할 수 있습니다. [macOS](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code\&utm_medium=docs) 또는 [Windows](https://claude.com/download?utm_source=claude_code\&utm_medium=docs)용으로 다운로드하고 명령줄 설정 없이 코딩을 시작하세요. Linux에서는 [Linux 설치 지침](https://code.claude.com/docs/ko/desktop-linux.md)을 따라 apt로 앱을 설치하세요.

## 진단 검사 실행

### 네트워크 연결성 확인

설치 프로그램은 `downloads.claude.ai`에서 다운로드합니다. 도달할 수 있는지 확인하세요:

> [tab] macOS/Linux
>
> ```bash theme={null}
> curl -sI https://downloads.claude.ai/claude-code-releases/latest
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> curl.exe -sI https://downloads.claude.ai/claude-code-releases/latest
> ```
>
> PowerShell은 `curl`을 `Invoke-WebRequest`로 별칭 지정하며, 이는 `-sI` 플래그를 거부합니다. 따라서 `curl.exe`를 명시적으로 호출하세요.

첫 번째 줄에 `200` 상태가 표시되면 서버에 도달했습니다. macOS 및 Linux에서는 `HTTP/2 200`이 표시되고, Windows에 포함된 `curl.exe`에서는 `HTTP/1.1 200 OK`가 표시됩니다. 다른 결과는 원인을 나타냅니다:

* `403`: 일반적으로 호스트를 차단하는 프록시 또는 네트워크 필터이거나, Claude Code가 [해당 지역에서 사용 불가능](https://www.anthropic.com/supported-countries)합니다.
* `5xx`: 일반적으로 임시 서비스 문제입니다. 몇 분 기다렸다가 다시 시도하세요.

출력이 없거나 `Could not resolve host` 또는 연결 시간 초과가 표시되면 네트워크가 연결을 차단하고 있습니다. 일반적인 원인:

* `downloads.claude.ai`를 차단하는 회사 방화벽 또는 프록시
* 지역 네트워크 제한: VPN 또는 대체 네트워크 시도
* TLS/SSL 문제: 시스템의 CA 인증서를 업데이트하거나 `HTTPS_PROXY`가 구성되어 있는지 확인

회사 프록시 뒤에 있는 경우 설치하기 전에 `HTTPS_PROXY` 및 `HTTP_PROXY`를 프록시 주소로 설정하세요. 프록시 URL을 모르는 경우 IT 팀에 문의하거나 브라우저의 프록시 설정을 확인하세요.

이 예제는 두 프록시 변수를 설정한 다음 프록시를 통해 설치 프로그램을 실행합니다:

> [tab] macOS/Linux
>
> ```bash theme={null}
> export HTTP_PROXY=http://proxy.example.com:8080
> export HTTPS_PROXY=http://proxy.example.com:8080
> curl -fsSL https://claude.ai/install.sh | bash
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> $env:HTTP_PROXY = 'http://proxy.example.com:8080'
> $env:HTTPS_PROXY = 'http://proxy.example.com:8080'
> irm https://claude.ai/install.ps1 | iex
> ```

### PATH 확인

설치가 성공했지만 `claude`를 실행할 때 `command not found` 또는 `not recognized` 오류가 발생하면 설치 디렉터리가 PATH에 없습니다. 셸은 PATH에 나열된 디렉터리에서 프로그램을 검색하고 설치 프로그램은 macOS/Linux에서 `~/.local/bin/claude`에 또는 Windows에서 `%USERPROFILE%\.local\bin\claude.exe`에 `claude`를 배치합니다.

설치 프로그램은 이 경우를 감지하여 출력의 `Setup notes:` 아래에 보고합니다. macOS 및 Linux에서는 `Native installation exists but ~/.local/bin is not in your PATH.`, Windows에서는 `Native installation exists but C:\Users\you\.local\bin is not in your PATH.`가 표시됩니다. 이 메모와 함께 해결 방법을 출력하지만 PATH 자체를 변경하지는 않습니다.

> [!NOTE]
>
> [VS Code 확장](https://code.claude.com/docs/ko/vs-code.md)은 `claude`를 이 위치에 배치하지 않습니다. 확장 디렉터리 내에 CLI의 개인 복사본을 번들로 제공하며 자체 채팅 패널용으로 사용하고 PATH에 추가하지 않습니다. 확장만 설치한 경우 `~/.local/bin/claude`가 존재하지 않습니다. [독립 실행형 설치](https://code.claude.com/docs/ko/setup.md)를 실행하여 터미널에서 `claude`를 사용한 다음 아래를 계속하세요.

먼저 프로그램이 존재하는지 확인한 다음, 해당 폴더가 PATH에 있는지 확인하세요. PATH 수정은 영구적이므로 한 번만 적용하면 됩니다. 사용 중인 플랫폼의 탭을 선택하고 해당 명령을 실행하세요. macOS 및 Linux에서는 터미널에서, Windows에서는 PowerShell 또는 명령 프롬프트에서 실행합니다.

> [tab] macOS/Linux
>
> 설치 프로그램이 프로그램을 제자리에 배치했는지 확인하세요:
>
> ```bash theme={null}
> ls -la ~/.local/bin/claude
> ```
>
> * **`No such file or directory`**: 네이티브 설치가 없습니다. npm, Homebrew 또는 Linux 패키지 관리자 등 다른 방법으로 Claude Code를 설치하지 않았다면 [Claude Code를 설치](https://code.claude.com/docs/ko/setup.md#install-claude-code)하세요. 다른 방법으로 설치했다면 [충돌하는 설치 확인](#check-for-conflicting-installations)을 참조하세요.
> * **파일 목록이 표시됨**: 프로그램이 존재합니다. 다음으로 PATH를 확인하세요.
>
> PATH 항목을 나열하고 설치 폴더를 필터링하세요:
>
> ```bash theme={null}
> echo $PATH | tr ':' '\n' | grep -Fx "$HOME/.local/bin"
> ```
>
> 이것이 `/Users/you/.local/bin` 또는 `/home/you/.local/bin`을 출력하면 디렉터리가 PATH에 있으므로 [충돌하는 설치 확인](#check-for-conflicting-installations)으로 건너뛸 수 있습니다. 출력이 없으면 사용 중인 셸에 해당하는 두 명령으로 셸 구성에 추가하세요. `echo` 명령은 모든 새 터미널에 적용되도록 설정을 저장하고, `source`는 현재 창에 설정을 적용합니다. `echo` 명령은 성공하면 아무것도 출력하지 않습니다.
>
> macOS의 기본값인 Zsh의 경우:
>
> ```bash theme={null}
> echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
> source ~/.zshrc
> ```
>
> 대부분의 Linux 배포판의 기본값인 Bash의 경우:
>
> ```bash theme={null}
> echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
> source ~/.bashrc
> ```
>
> macOS의 Bash의 경우 대신 `~/.bash_profile`에 줄을 추가하세요. macOS의 터미널은 Bash를 로그인 셸로 시작하며, 이는 `~/.bashrc`를 무시하고 존재하는 `~/.bash_profile`, `~/.bash_login` 또는 `~/.profile` 중 첫 번째만 읽습니다. 이미 `~/.bash_login` 또는 `~/.profile`이 있고 `~/.bash_profile`이 없으면 `~/.bash_profile`을 만드는 대신 해당 파일에 줄을 넣으세요:
>
> ```bash theme={null}
> echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
> source ~/.bash_profile
> ```
>
> 또는 터미널을 닫았다가 다시 여세요.
>
> `echo` 명령이 `permission denied`를 출력하면 [PATH에 추가할 때 `permission denied`](#permission-denied-when-adding-to-your-path)를 참조하세요.
>
> fish 또는 Nushell과 같은 다른 셸의 경우 셸의 자체 구성 구문을 사용하여 `~/.local/bin`을 PATH에 추가한 다음 터미널을 다시 시작하세요.
>
> 수정이 작동했는지 확인하세요:
>
> ```bash theme={null}
> claude --version
> ```
>
> `claude`를 여전히 찾을 수 없다면 다음 원인을 확인하세요:
>
> * **변경 이전에 열린 터미널**: 이미 열려 있던 창은 이전 PATH를 유지하며, 편집기 내부의 터미널은 편집기에서 PATH를 가져옵니다. 새 창을 열거나 편집기를 종료했다가 다시 여세요.
> * **줄이 저장되지 않음**: 사용 중인 셸의 파일 이름으로 `grep -n '.local/bin' ~/.zshrc`를 실행하세요. 줄이 있으면 줄 번호와 함께 해당 줄을 출력합니다. 아무것도 출력되지 않으면 두 PATH 명령을 다시 실행하세요.
> * **줄이 다른 셸의 파일에 추가됨**: `echo $0`을 실행하여 사용 중인 셸을 확인한 다음, 해당 셸에 맞는 두 PATH 명령을 실행하세요.

> [tab] Windows PowerShell
>
> 설치 프로그램이 프로그램을 제자리에 배치했는지 확인하세요:
>
> ```powershell theme={null}
> Test-Path "$env:USERPROFILE\.local\bin\claude.exe"
> ```
>
> * **`False`**: 네이티브 설치가 없습니다. npm 또는 WinGet 등 다른 방법으로 Claude Code를 설치하지 않았다면 [Claude Code를 설치](https://code.claude.com/docs/ko/setup.md#install-claude-code)하세요. 다른 방법으로 설치했다면 [충돌하는 설치 확인](#check-for-conflicting-installations)을 참조하세요.
> * **`True`**: 프로그램이 존재합니다. 다음으로 PATH를 확인하세요.
>
> PATH 항목을 나열하고 설치 폴더를 필터링하세요:
>
> ```powershell theme={null}
> $env:PATH -split ';' | Select-String '\.local\\bin'
> ```
>
> 이것이 `C:\Users\you\.local\bin`을 출력하면 디렉터리가 PATH에 있으므로 [충돌하는 설치 확인](#check-for-conflicting-installations)으로 건너뛸 수 있습니다. 출력이 없으면 설치 디렉터리를 사용자 PATH에 추가하세요:
>
> ```powershell theme={null}
> $currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
> [Environment]::SetEnvironmentVariable('PATH', "$currentPath;$env:USERPROFILE\.local\bin", 'User')
> ```
>
> 변경 사항이 적용되려면 터미널을 다시 시작하세요.
>
> 수정이 작동했는지 확인하세요:
>
> ```powershell theme={null}
> claude --version
> ```
>
> 새 터미널에서도 `claude`를 여전히 찾을 수 없다면 다음 원인을 확인하세요:
>
> * **터미널이 편집기 내부에서 실행됨**: 편집기에서 PATH를 가져오므로 편집기를 종료했다가 다시 여세요.
> * **변경 사항이 저장되지 않음**: `[Environment]::GetEnvironmentVariable('PATH', 'User')`를 실행하고 출력된 PATH에서 `.local\bin`을 찾으세요. 없으면 두 명령을 다시 실행하세요.

> [tab] Windows CMD
>
> 설치 프로그램이 프로그램을 제자리에 배치했는지 확인하세요:
>
> ```batch theme={null}
> dir "%USERPROFILE%\.local\bin\claude.exe"
> ```
>
> * **`File Not Found` 또는 `The system cannot find the path specified.`**: 네이티브 설치가 없습니다. npm 또는 WinGet 등 다른 방법으로 Claude Code를 설치하지 않았다면 [Claude Code를 설치](https://code.claude.com/docs/ko/setup.md#install-claude-code)하세요. 다른 방법으로 설치했다면 [충돌하는 설치 확인](#check-for-conflicting-installations)을 참조하세요.
> * **`claude.exe` 목록이 표시됨**: 프로그램이 존재합니다. 다음으로 PATH를 확인하세요.
>
> PATH 항목을 나열하고 설치 폴더를 필터링하세요:
>
> ```batch theme={null}
> echo %PATH% | findstr /i "local\bin"
> ```
>
> 출력이 없으면 시스템 설정을 열고 환경 변수로 이동한 다음 `%USERPROFILE%\.local\bin`을 사용자 PATH 변수에 추가하세요. 터미널을 다시 시작하세요.
>
> 수정이 작동했는지 확인하세요:
>
> ```batch theme={null}
> claude --version
> ```
>
> 새 터미널에서도 `claude`를 여전히 찾을 수 없다면, 편집기 내부의 터미널은 편집기에서 PATH를 가져오므로 편집기도 종료했다가 다시 여세요.

### 충돌하는 설치 확인

여러 Claude Code 설치로 인해 버전 불일치 또는 예기치 않은 동작이 발생할 수 있습니다. 설치된 항목을 확인하세요:

> [tab] macOS/Linux
>
> PATH에서 찾은 모든 `claude` 바이너리를 나열하세요:
>
> ```bash theme={null}
> which -a claude
> ```
>
> 이것이 `claude not found`, `no claude in` 줄을 출력하거나 아무것도 출력하지 않으면 PATH에 `claude`가 없습니다. 다음 검사를 통해 설치되어 있는지 여부를 확인할 수 있습니다.
>
> `claude` 바이너리가 올 수 있는 세 위치를 확인하세요. `~/.local/bin/claude`는 네이티브 설치 프로그램이고 `~/.claude/local/`은 Claude Code의 이전 버전에서 생성한 레거시 로컬 npm 설치이며 npm 글로벌 목록은 `-g` 설치를 표시합니다:
>
> ```bash theme={null}
> ls -la ~/.local/bin/claude
> ```
>
> 네이티브 설치는 `~/.local/share/claude/versions/`로의 심볼릭 링크를 표시합니다. 이 경로에서 직접 만든 스크립트 또는 심볼릭 링크는 사용자 정의 런처이며, [자동 업데이트는 제자리에 남겨둡니다](https://code.claude.com/docs/ko/setup.md#auto-updates).
>
> `ls` 명령 중 하나가 `No such file or directory`를 출력하면 오류가 아닙니다. 이는 해당 위치에 아무것도 설치되지 않았음을 의미하므로 다음 검사로 이동하세요.
>
> ```bash theme={null}
> ls -la ~/.claude/local/
> ```
>
> ```bash theme={null}
> npm -g ls @anthropic-ai/claude-code 2>/dev/null
> ```
>
> `ls -la ~/.local/bin/claude`가 `No such file or directory`를 출력했다면 네이티브 설치가 없습니다. npm, Homebrew 또는 Linux 패키지 관리자 등 다른 방법으로 Claude Code를 설치하지 않았다면 [Claude Code를 설치](https://code.claude.com/docs/ko/setup.md#install-claude-code)하세요. `~/.local/bin/claude`가 존재하지만 `which -a claude`에 나열되지 않았다면 해당 폴더가 PATH에 없는 것입니다. [PATH 확인](#verify-your-path)을 참조하세요.

> [tab] Windows PowerShell
>
> PATH에서 찾은 모든 `claude` 바이너리를 나열하세요:
>
> ```powershell theme={null}
> where.exe claude
> ```
>
> 이것이 `INFO: Could not find files for the given pattern(s).`를 출력하면 PATH에 `claude`가 없습니다.
>
> 네이티브 설치 프로그램이 바이너리를 배치했는지 확인하세요:
>
> ```powershell theme={null}
> Test-Path "$env:USERPROFILE\.local\bin\claude.exe"
> ```
>
> * **`True`**: 네이티브 설치가 존재합니다. `where.exe`가 아무것도 찾지 못했다면 해당 폴더가 PATH에 없는 것입니다. [PATH 확인](#verify-your-path)을 참조하세요.
> * **`False`**: 네이티브 설치가 없습니다. npm 또는 WinGet 등 다른 방법으로 Claude Code를 설치하지 않았다면 [Claude Code를 설치](https://code.claude.com/docs/ko/setup.md#install-claude-code)하세요.

여러 설치를 찾으면 하나만 유지하세요. macOS/Linux의 `~/.local/bin/claude` 또는 Windows의 `%USERPROFILE%\.local\bin\claude.exe`에서의 네이티브 설치가 권장됩니다. 추가 항목을 제거하세요:

npm 글로벌 설치 제거:

```bash theme={null}
npm uninstall -g @anthropic-ai/claude-code
```

레거시 로컬 npm 설치 제거:

> [tab] macOS/Linux
>
> ```bash theme={null}
> rm -rf ~/.claude/local
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\local"
> ```

macOS에서 Homebrew 설치 제거. `claude-code@latest` cask를 설치한 경우 해당 이름으로 대체하세요:

```bash theme={null}
brew uninstall --cask claude-code
```

Windows에서 WinGet 설치 제거:

```powershell theme={null}
winget uninstall Anthropic.ClaudeCode
```

### 디렉터리 권한 확인

권한 문제로 실패한 설치는 생성하거나 쓸 수 없었던 경로를 표시합니다. Windows에서는 설치가 `%USERPROFILE%` 아래에 기록되며, 이 위치는 기본적으로 사용자가 쓸 수 있으므로 이 섹션은 거의 적용되지 않습니다.

macOS 및 Linux에서는 설치가 다음 위치에 기록됩니다:

* `~/.claude/downloads/`: 설치 명령이 다운로드한 바이너리를 두는 위치
* `~/.local/bin/`: `claude` 런처
* `~/.local/share/claude/`: 다운로드하는 각 버전
* `~/.local/state/claude/`: 잠금 파일
* `~/.cache/claude/`: 스테이징된 다운로드
* [`~/.claude.json`](https://code.claude.com/docs/ko/claude-directory): 설치 프로그램이 설치 방법을 기록하는 전역 설정 파일

`XDG_DATA_HOME`, `XDG_STATE_HOME` 또는 `XDG_CACHE_HOME`을 설정한 경우 설치는 `~/.local/share`, `~/.local/state`, `~/.cache` 대신 해당 경로를 사용합니다. [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars)을 설정한 경우 전역 설정 파일은 홈 디렉터리 대신 해당 디렉터리 아래에 위치합니다.

디렉터리가 쓸 수 있는지 확인하세요:

```bash theme={null}
test -w ~/.local/bin && echo "writable" || echo "not writable"
test -w ~/.claude && echo "writable" || echo "not writable"
```

디렉터리를 쓸 수 없으면 설치 디렉터리를 만들고 사용자를 소유자로 설정하세요:

```bash theme={null}
sudo mkdir -p ~/.local/bin
sudo chown -R $(whoami) ~/.local
```

### 바이너리 작동 확인

`claude --version`이 버전을 인쇄하지만 `claude`가 시작 시 충돌하거나 중단되면 이 검사를 실행하여 원인을 좁혀보세요. `claude --version`이 command not found를 표시하면 먼저 [PATH 확인](#verify-your-path)으로 이동하세요. 아래 명령은 `claude`가 PATH에 있다고 가정합니다.

바이너리가 존재하고 실행 가능한지 확인하세요:

> [tab] macOS/Linux
>
> ```bash theme={null}
> ls -la "$(command -v claude)"
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> Get-Command claude | Select-Object Source
> ```

Linux에서 누락된 공유 라이브러리를 확인하세요. `ldd`가 누락된 라이브러리를 표시하면 시스템 패키지를 설치해야 할 수 있습니다. Alpine Linux 및 기타 musl 기반 배포판의 경우 [Alpine Linux 설정](https://code.claude.com/docs/ko/setup.md#alpine-linux-and-musl-based-distributions)을 참조하세요.

```bash theme={null}
ldd "$(command -v claude)" | grep "not found"
```

바이너리가 실행될 수 있는지 확인하세요:

```bash theme={null}
claude --version
```

## 일반적인 설치 문제

가장 자주 발생하는 설치 문제와 해결 방법입니다.

### 설치 스크립트가 셸 스크립트 대신 HTML을 반환합니다

설치 명령이 다운로드한 내용이 설치 스크립트가 아니면 다음 오류 중 하나와 함께 실패합니다.

**Bash 또는 Zsh**: 오류가 반환된 페이지의 첫 줄을 인용합니다.

```text theme={null}
bash: line 1: syntax error near unexpected token `<'
bash: line 1: `<!DOCTYPE html>'
```

**PowerShell, 구문 분석 오류**: 오류가 반환된 페이지를 가리키며, `iex`가 HTML과 CSS를 PowerShell로 실행하려고 시도합니다.

```text theme={null}
iex : At line:1 char:2310
+ ... igin="anonymous"/><script type="text/javascript">!function(o,c){var n ...
Missing argument in parameter list.
...
```

표현은 PowerShell 버전과 시스템 언어에 따라 다릅니다. `Missing expression after unary operator '--'` 또는 `ParserError`와 함께 `ParseException`이 표시될 수 있습니다. 인용된 텍스트의 HTML 태그 또는 CSS는 이 오류를 식별합니다. `-OutFile install.ps1`로 다운로드하면 저장된 파일도 동일한 웹 페이지이므로 도움이 되지 않습니다.

**PowerShell, `System.Xml.XmlDocument`**: 오류가 페이지를 인용하는 대신 이 타입의 이름을 표시합니다.

```text theme={null}
System.Xml.XmlDocument : The term 'System.Xml.XmlDocument' is not recognized as the name of a cmdlet, function, script
file, or operable program.
```

`irm`이 응답을 XML로 구문 분석할 수 있으면 텍스트 대신 XML 객체를 반환하고, `iex`는 해당 객체의 타입 이름을 명령으로 실행하려고 시도합니다. 설치 스크립트는 PowerShell 코드이며 XML로 구문 분석되지 않으므로, 이 오류 역시 응답이 스크립트가 아닌 다른 것이었음을 의미합니다. 타입 이름 주변의 표현은 PowerShell 버전과 시스템 언어에 따라 다르지만 `System.Xml.XmlDocument` 자체는 동일하게 유지되므로 타입 이름으로 식별합니다.

**CMD**: 다음 오류가 표시되고 그 뒤에 반환된 페이지의 HTML이 이어집니다.

```text theme={null}
< was unexpected at this time.

C:\Users\you><!DOCTYPE html>...
```

첫 줄은 시스템 언어로 표시되므로 그 뒤에 이어지는 HTML을 확인합니다.

**페이지 없는 403**: 요청이 라우팅된 방식에 따라 curl이 HTML 본문 없이 403 상태를 보고할 수 있습니다.

```text theme={null}
curl: (22) The requested URL returned error: 403
```

이 모든 경우는 설치 URL이 설치 스크립트 대신 웹 페이지, XML 문서 또는 오류 상태를 반환했음을 의미합니다. 오류 출력에 "App unavailable in region"이 인용되어 있으면 Claude Code를 사용할 수 없는 국가입니다. [지원되는 국가](https://www.anthropic.com/supported-countries)를 참조하세요.

본문이 없는 단순 403은 동일한 원인을 가질 수 있지만 회사 프록시 또는 방화벽이 다운로드를 차단할 수도 있습니다. 지원되는 국가에 있는데도 403이 표시되면 아래의 대체 설치 프로그램을 시도하기 전에 [네트워크 연결 확인](#check-network-connectivity)을 진행하세요. 대체 설치 프로그램도 동일한 호스트에 도달하기 때문입니다.

그 외에는 네트워크 문제, 지역 라우팅 또는 일시적인 서비스 중단으로 인해 발생할 수 있습니다.

**해결 방법:**

1. **몇 분 후 다시 시도합니다**: 이 문제는 종종 일시적입니다. 기다렸다가 원래 명령을 다시 시도합니다.

2. **대체 설치 방법 사용**: 네이티브 설치와 달리 Homebrew 또는 WinGet 설치는 [기본적으로 자동 업데이트되지 않습니다](https://code.claude.com/docs/ko/setup.md#auto-updates).

   macOS에서는 Homebrew를 통해 설치합니다.

   ```bash theme={null}
   brew install --cask claude-code
   ```

   Windows에서는 WinGet을 통해 설치합니다.

   ```powershell theme={null}
   winget install Anthropic.ClaudeCode
   ```

   그런 다음 `claude --version`을 실행하여 확인합니다. 명령은 `2.1.211 (Claude Code)`와 같은 버전 번호를 출력합니다. 셸에서 `claude`를 찾을 수 없다고 보고하면 새 터미널 창을 열고 다시 시도합니다. 설치한 세션은 이전 `PATH`를 유지합니다.

### 설치 후 `command not found: claude`

설치가 완료되었지만 `claude`가 작동하지 않습니다. 정확한 오류는 플랫폼에 따라 다릅니다.

| 플랫폼 | 오류 메시지 |
| :- | :- |
| macOS | `zsh: command not found: claude` |
| Linux | `bash: claude: command not found` |
| Windows CMD | `'claude' is not recognized as an internal or external command` |
| PowerShell | `claude : The term 'claude' is not recognized as the name of a cmdlet` |

Windows에서 Claude Code가 업데이트된 직후 이 오류가 발생하기 시작했다면 [백업에서 `claude.exe` 복원](#claude-exe-missing-after-an-update-on-windows)을 참조하세요.

그 외의 경우 각 플랫폼의 수정 방법은 [PATH 확인](#verify-your-path)을 참조하세요.

### PATH에 추가할 때 `permission denied`

`~/.local/bin`을 PATH에 추가하는 `echo` 명령이 `zsh: permission denied: /Users/you/.zshrc` 또는 `bash: /home/you/.bashrc: Permission denied`를 출력하면 현재 사용자가 해당 파일에 쓸 수 없으며 아무것도 저장되지 않은 것입니다. 터미널에서 `~/.zshrc` 대신 사용 중인 셸의 파일 이름을 사용하여 파일 소유자를 확인합니다.

```bash theme={null}
ls -l ~/.zshrc
```

출력의 세 번째 필드가 소유자입니다.

* **소유자가 `root`와 같은 다른 사용자인 경우**: 관리자 권한이 필요한 `sudo chown $(whoami) ~/.zshrc`로 소유권을 가져옵니다.
* **소유자가 본인인 경우**: 파일이 읽기 전용입니다. `chmod u+w ~/.zshrc`로 쓰기 가능하게 만듭니다.

그런 다음 [PATH 확인](#verify-your-path)에 있는 해당 셸용 PATH 명령 두 개를 다시 실행합니다.

### `curl: (56) Failure writing output to destination`

`curl ... | bash` 명령은 스크립트를 다운로드하고 Bash로 실행하기 위해 파이프합니다. 이 오류와 관련된 `curl: (23) Failure writing output to destination`은 Bash가 완전한 스크립트를 받지 못했음을 의미합니다. 종료 코드 56은 다운로드 자체가 중단되었음을 나타내고, 종료 코드 23은 curl이 받은 내용을 파이프에 쓸 수 없었음을 나타냅니다. 보통 Bash가 조기에 종료되었기 때문입니다.

[네트워크 연결 확인](#check-network-connectivity)의 확인으로 `downloads.claude.ai`에 도달할 수 있는지 테스트합니다. 서버에 도달했다면 원래 오류는 일시적일 가능성이 높습니다. 설치 명령을 다시 시도합니다. [대체 설치 방법](https://code.claude.com/docs/ko/setup.md#install-claude-code)을 시도할 수도 있습니다.

### Homebrew cask를 사용할 수 없거나 오래되었습니다

Homebrew가 `Error: Cask 'claude-code' is unavailable: No Cask with this name exists`를 보고하면 Homebrew cask 인덱스의 로컬 복사본이 cask의 게시 이전입니다. 인덱스를 새로 고치고 다시 시도합니다.

```bash theme={null}
brew update
brew install --cask claude-code
```

Homebrew가 예상보다 오래된 Claude Code 버전을 설치하면 동일한 오래된 인덱스가 보통 원인입니다. `claude-code` cask는 안정 채널을 추적하며 보통 최신 릴리스보다 약 1주일 뒤떨어져 있습니다. 최신 버전을 원하면 `brew install --cask claude-code@latest`를 대신 실행합니다. 두 cask의 차이점은 [릴리스 채널 구성](https://code.claude.com/docs/ko/setup.md#configure-release-channel)을 참조하세요.

### `Cask 'claude-code@latest' is not installed`

Homebrew는 `claude-code`와 `claude-code@latest` 두 가지 cask를 제공합니다. 설치된 cask가 `claude-code@latest`가 아닌데 `brew upgrade --cask claude-code@latest`를 실행하면 `Error: Cask 'claude-code@latest' is not installed.`가 출력됩니다. 어떤 cask가 설치되어 있는지 확인하려면 터미널에서 다음을 실행합니다.

```bash theme={null}
brew list --cask | grep claude-code
```

출력된 cask를 업그레이드합니다. 아무것도 출력되지 않으면 두 cask 모두 설치되어 있지 않은 것입니다.

### TLS 또는 SSL 연결 오류

다음과 같은 오류는 TLS 핸드셰이크가 실패했음을 의미합니다.

* `curl: (35) TLS connect error`
* `schannel: next InitializeSecurityContext failed`
* PowerShell의 `Could not create SSL/TLS secure channel`
* PowerShell의 `Could not establish trust relationship for the SSL/TLS secure channel`

`CRYPT_E_NO_REVOCATION_CHECK` 또는 `CRYPT_E_REVOCATION_OFFLINE`의 경우 4단계로 이동합니다.

**해결 방법:**

1. **시스템 CA 인증서 업데이트**:

   Ubuntu/Debian에서:

   ```bash theme={null}
   sudo apt-get update && sudo apt-get install ca-certificates
   ```

   macOS에서는 시스템 curl이 Keychain 신뢰 저장소를 사용합니다. macOS 자체를 업데이트하면 루트 인증서가 업데이트됩니다.

2. **Windows PowerShell 5.1에서 TLS 1.2 활성화**:
   ```powershell theme={null}
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   ```
   그런 다음 같은 창에서 설치 프로그램을 실행합니다.
   ```powershell theme={null}
   irm https://claude.ai/install.ps1 | iex
   ```

3. **프록시 또는 방화벽 간섭 확인**: TLS 검사를 수행하는 회사 프록시는 `unable to get local issuer certificate` 및 `SELF_SIGNED_CERT_IN_CHAIN`을 포함한 이러한 오류를 유발할 수 있습니다. 설치 단계의 경우 설치 다운로드가 회사 프록시의 CA를 신뢰하도록 합니다.

   > [tab] macOS/Linux
   >
   > ```bash theme={null}
   > curl --cacert /path/to/corporate-ca.pem -fsSL https://claude.ai/install.sh | bash
   > ```

   > [tab] Windows PowerShell
   >
   > PowerShell 설치 프로그램은 .NET을 통해 다운로드하며, Windows 인증서 저장소에 대해 TLS를 검증합니다. IT 팀에 프록시의 CA 인증서를 Windows 저장소에 추가하도록 요청합니다(아직 없는 경우). 그런 다음 설치 프로그램을 실행합니다.
   >
   > ```powershell theme={null}
   > irm https://claude.ai/install.ps1 | iex
   > ```

   설치된 Claude Code 자체의 경우 `NODE_EXTRA_CA_CERTS`를 설정하여 API 요청이 동일한 번들을 신뢰하도록 합니다.

   > [tab] macOS/Linux
   >
   > ```bash theme={null}
   > export NODE_EXTRA_CA_CERTS=/path/to/corporate-ca.pem
   > ```

   > [tab] Windows PowerShell
   >
   > ```powershell theme={null}
   > $env:NODE_EXTRA_CA_CERTS = 'C:\path\to\corporate-ca.pem'
   > ```

   인증서 파일이 없으면 IT 팀에 요청합니다. 프록시가 원인인지 확인하기 위해 직접 연결에서 시도할 수도 있습니다.

4. **Windows에서 차단된 해지 확인 해결**. 오류 `CRYPT_E_NO_REVOCATION_CHECK (0x80092012)` 및 `CRYPT_E_REVOCATION_OFFLINE (0x80092013)`은 curl이 서버에 도달했지만 네트워크가 인증서 해지 조회를 차단함을 의미합니다. 이는 회사 방화벽 뒤에서 일반적입니다. 실패한 명령이 `install.cmd`를 다운로드하는 `curl`인 경우 `--ssl-revoke-best-effort`를 추가하여 명령 프롬프트에서 다시 실행합니다.
   ```batch theme={null}
   curl --ssl-revoke-best-effort -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
   ```
   스크립트 자체의 다운로드가 동일한 오류에 직면하면 자동으로 최선의 노력 해지 확인으로 다시 시도하므로 플래그는 직접 실행하는 명령에만 필요합니다. 최선의 노력 확인은 도달할 수 없는 해지 서버를 허용하지만 알려진 해지된 인증서는 거부하며, 브라우저가 해지를 처리하는 방식과 일치합니다. PowerShell에서 PowerShell 설치 프로그램을 실행하여 curl의 해지 확인을 완전히 피할 수도 있습니다. PowerShell 설치 프로그램은 .NET을 통해 다운로드하며 해지 서버에 도달할 수 없을 때 실패하지 않습니다.
   ```powershell theme={null}
   irm https://claude.ai/install.ps1 | iex
   ```
   `winget install Anthropic.ClaudeCode`로 설치할 수도 있으며, 이는 curl을 완전히 피합니다.

### `Failed to fetch version from downloads.claude.ai`

설치 프로그램이 다운로드 서버에 도달할 수 없습니다. 이는 보통 `downloads.claude.ai`가 네트워크에서 차단되었음을 의미합니다. [네트워크 연결 확인](#check-network-connectivity)을 참조하세요.

### The connection dropped while downloading the update

`claude install` 또는 `claude update`가 Claude Code 바이너리를 가져오는 동안 다운로드 서버와의 연결이 끊겼고 재시도로도 복구되지 않았습니다. Claude Code는 연결이 끊기거나, 전송이 멈추거나, 다운로드된 파일이 체크섬 검증에 실패하면 총 세 번까지 다운로드를 재시도합니다. 404와 같이 완료된 HTTP 오류는 서버가 이미 응답했으므로 재시도하지 않습니다. v2.1.202 이전에는 연결이 한 번만 끊겨도 재시도하지 않고 단순한 `aborted` 오류와 함께 다운로드가 즉시 실패했습니다.

```text theme={null}
The connection dropped while downloading the update (attempt 3/3: aborted). Check your network — proxies sometimes cut off large downloads.
```

괄호 안의 텍스트는 어느 시도가 실패했는지와 기본 네트워크 오류를 나타냅니다. `claude update`는 이 메시지 앞에 stderr로 `Error: Failed to install native update`를 출력합니다.

연결은 유지되지만 10분 이내에 완료되지 않는 다운로드는 대신 `Download timed out: exceeded the total deadline`으로 실패합니다. 기한 내에 완료하기에 너무 느린 연결은 즉시 재시도해도 완료되지 않으므로 Claude Code는 시간 초과된 다운로드를 재시도하지 않습니다. 아래 단계는 두 메시지 모두에 적용됩니다.

프록시 또는 게이트웨이는 긴 전송을 완료되기 전에 닫을 수 있으며, Claude Code 바이너리는 용량이 큰 다운로드입니다.

**해결 방법:**

* `claude update`를 다시 실행합니다. 그 외에는 정상적인 네트워크라면 보통 다음 실행에서 다운로드가 성공합니다. 시간 초과 메시지의 경우 더 빠르거나 제한이 덜한 네트워크에서 다시 실행합니다.
* 네트워크에 프록시가 필요한 경우 설치 프로그램 또는 `claude update`를 실행하기 전에 `HTTPS_PROXY`를 설정합니다. [네트워크 연결 확인](#check-network-connectivity)을 참조하세요.
* 회사 프록시가 계속 전송을 닫는 경우 네트워크 팀에 `downloads.claude.ai`로부터의 전체 다운로드를 허용하도록 요청합니다. [네트워크 액세스 요구 사항](https://code.claude.com/docs/ko/network-config.md#network-access-requirements)을 참조하세요.
* 셸에서 `claude doctor`를 실행하여 설치 진단을 확인합니다

### Release verification failed for Claude Code

`claude update` 또는 `claude install`에서 표시되는 이 메시지는 Claude Code가 설치하려던 릴리스가 정품인지 확인할 수 없어 아무것도 설치하지 않았음을 의미합니다. 이미 설치된 버전은 계속 작동합니다.

```text theme={null}
Release verification failed for Claude Code <version> (<reason>). The update was not installed.
```

메시지의 괄호 안 값에 해당하는 조치를 취합니다.

* **`sidecar_fetch_`로 시작하는 값**: 셸에서 같은 명령을 다시 실행합니다. `claude update`는 `Successfully updated from`으로 시작하는 줄을 출력하면 성공한 것이고, `claude install`은 `Claude Code successfully installed!`를 출력하면 성공한 것입니다.
* **그 외의 값**: 나중에 같은 명령을 다시 시도합니다

어떤 값이든 메시지가 반복되면 전체 메시지를 포함하여 [문제를 보고](#still-stuck)하세요.

### 세션 푸터의 `Auto-update failed · Run claude doctor`

이 빨간색 줄은 Claude Code가 백그라운드에서 자체 업데이트를 시도했지만 업데이트가 설치되지 않았음을 의미합니다. 아무 조치 없이 계속 작업할 수 있습니다.

이 줄은 `claude doctor`를 안내하지만, 해당 명령의 `Last update attempt: failed (install_failed)` 줄은 날짜만 표시하고 원인은 알려 주지 않습니다. 업데이트를 완료하거나 실패 원인을 확인하려면 대신 셸에서 `claude update`를 실행합니다. 해당 설치도 실패하면 `claude update`가 출력하는 오류를 [오류 찾기](#find-your-error)에서 찾아봅니다.

### Windows에서 잘못된 설치 명령

`'irm' is not recognized`, `The token '&&' is not a valid statement separator`, `A parameter cannot be found that matches parameter name 'fsSL'` 또는 `'bash' is not recognized as the name of a cmdlet`이 표시되면 다른 셸 또는 운영 체제의 설치 명령을 복사했습니다. 명령이 아무것도 설치하지 않고 스크립트의 텍스트를 출력하면 일부만 실행했습니다.

* **`irm` not recognized**: CMD에 있으며 PowerShell이 아닙니다. 두 가지 옵션이 있습니다.

  시작 메뉴에서 "PowerShell"을 검색하여 PowerShell을 열고 원래 설치 명령을 실행합니다.

  ```powershell theme={null}
  irm https://claude.ai/install.ps1 | iex
  ```

  또는 CMD에 머물러 있고 CMD 설치 프로그램을 대신 사용합니다.

  ```batch theme={null}
  curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
  ```

* **`&&` not a valid statement separator**: PowerShell에 있지만 CMD 설치 프로그램 명령을 실행했습니다. PowerShell 설치 프로그램을 사용합니다.
  ```powershell theme={null}
  irm https://claude.ai/install.ps1 | iex
  ```

* **`A parameter cannot be found that matches parameter name 'fsSL'`**: Windows PowerShell에서 macOS/Linux `curl -fsSL ... | bash` 설치 프로그램을 실행했습니다. 여기서 `curl`은 `Invoke-WebRequest`의 별칭이며 `-fsSL` 플래그를 거부합니다. PowerShell 설치 프로그램을 대신 사용합니다.
  ```powershell theme={null}
  irm https://claude.ai/install.ps1 | iex
  ```

* **`bash` not recognized**: Windows에서 macOS/Linux 설치 프로그램을 실행했습니다. PowerShell 설치 프로그램을 대신 사용합니다.
  ```powershell theme={null}
  irm https://claude.ai/install.ps1 | iex
  ```

* **명령이 설치하지 않고 스크립트 텍스트를 출력합니다**: 실행하는 부분 없이 명령의 다운로드 절반만 실행했습니다. `irm https://claude.ai/install.ps1`은 단독으로 다운로드된 스크립트를 터미널에 출력합니다. `iex`로 파이프하여 실행합니다.

  ```powershell theme={null}
  irm https://claude.ai/install.ps1 | iex
  ```

  CMD에서 `-o` 없이 `curl -fsSL https://claude.ai/install.cmd`는 배치 스크립트를 저장하는 대신 출력합니다. 완전한 명령을 실행합니다.

  ```batch theme={null}
  curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
  ```

어떤 설치 프로그램을 사용하든 작동했는지 확인합니다. 새 터미널을 열고 `claude --version`을 실행합니다. 이는 `2.1.211 (Claude Code)`와 같은 버전 번호를 출력합니다.

### `running scripts is disabled on this system`

Windows에서 npm을 통해 Claude Code를 설치하거나 실행하면 `SecurityError`로 실패할 수 있습니다.

```text theme={null}
npm : File C:\Program Files\nodejs\npm.ps1 cannot be loaded because running scripts is disabled on this system. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
...
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
```

npm 설치 후 `claude`를 실행할 때 동일한 오류가 `claude.ps1`의 이름을 지정합니다. PowerShell의 실행 정책이 npm이 명령에 대해 생성하는 `.ps1` 런처 스크립트를 차단합니다. 정책은 스크립트 파일에 적용되므로 다운로드된 텍스트를 직접 실행하는 PowerShell 설치 프로그램 `irm https://claude.ai/install.ps1 | iex`에는 영향을 주지 않습니다.

**해결 방법:**

1. **사용자에 대해 로컬로 생성된 스크립트 허용**한 다음 다시 시도합니다.
   ```powershell theme={null}
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. **`.cmd` 런처 대신 호출**: `npm.cmd` 및 `claude.cmd`는 동일한 작업을 수행하며 정책이 이를 적용하지 않습니다.
3. **npm 대신 [PowerShell 설치 프로그램](https://code.claude.com/docs/ko/setup.md#install-claude-code) 사용**. `.ps1` 스크립트가 아닌 바이너리를 설치합니다.

### Windows 설치 중 `The process cannot access the file`

PowerShell 설치 프로그램이 `Failed to download binary: The process cannot access the file ... because it is being used by another process`로 실패하면 설치 프로그램이 `%USERPROFILE%\.claude\downloads`에 쓸 수 없습니다. 이는 보통 이전 설치 시도가 여전히 실행 중이거나 바이러스 백신 소프트웨어가 해당 폴더의 부분적으로 다운로드된 바이너리를 스캔하고 있음을 의미합니다.

설치 프로그램을 실행하는 다른 PowerShell 창을 닫고 바이러스 백신 스캔이 파일을 해제할 때까지 기다립니다. 그런 다음 다운로드 폴더를 삭제하고 설치 프로그램을 다시 실행합니다.

```powershell theme={null}
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\downloads"
irm https://claude.ai/install.ps1 | iex
```

### Windows에서 업데이트 후 `claude.exe` 누락

터미널이 Windows에서 Claude Code가 업데이트된 직후 `'claude' is not recognized`를 보고하면 `%USERPROFILE%\.local\bin`에 여전히 `claude.exe`가 포함되어 있는지 확인합니다. 해당 디렉터리가 PATH에 전혀 없으면 대신 [PATH 확인](#verify-your-path)을 참조하세요. Windows에서 업데이트하려면 Claude Code가 기존 `claude.exe`를 백업으로 이름을 바꾸고 새 버전을 제자리에 이동합니다. 새 버전을 제자리에 이동하지 못하고 Claude Code가 백업을 다시 이름을 바꿀 수도 없으면 디렉터리는 백업을 유지하지만 `claude.exe`가 없습니다.

백업은 `claude.exe.old.` 다음에 숫자 타임스탬프가 오는 이름으로 시작하는 동일한 디렉터리의 파일입니다. PowerShell에서 다음을 실행하여 최신 백업을 `claude.exe`로 이름을 바꿉니다.

```powershell theme={null}
Get-ChildItem "$env:USERPROFILE\.local\bin\claude.exe.old.*" | Sort-Object Name | Select-Object -Last 1 | Rename-Item -NewName claude.exe
```

그런 다음 `claude --version`을 실행하여 수정을 확인합니다. 복원된 `claude.exe`는 버전 번호를 출력합니다.

`claude.exe.old.*` 파일이 없거나 이름 바꾸기 후에도 `claude`가 실패하면 대신 다시 설치합니다.

```powershell theme={null}
irm https://claude.ai/install.ps1 | iex
```

v2.1.281 이전에는 Claude Code가 `claude.exe`가 여전히 누락된 상태에서 백업을 삭제할 수 있었습니다.

### 메모리 부족 Linux 서버에서 설치 중단

설치 중 `Killed` 메시지는 보통 Linux OOM(메모리 부족) 킬러가 시스템의 여유 메모리가 부족하여 `claude install` 단계를 종료했음을 의미합니다. 이는 작은 VPS 및 클라우드 인스턴스에서 일반적입니다. 설치 스크립트는 원인을 보고하고 코드 137로 종료합니다. 이 예에서 줄 번호와 프로세스 ID는 릴리스 및 실행에 따라 다릅니다.

```text theme={null}
Setting up Claude Code...
bash: line 183: 34803 Killed    "$binary_path" install ${TARGET:+"$TARGET"}
Installation was killed before it could finish (exit code 137). This usually means the system ran out of memory.
Claude Code needs roughly 512MB of free memory to install. Free up memory, then run this script again.
```

설치하려면 대략 512MB의 여유 메모리가 필요하며, Claude Code를 실행하려면 더 많은 메모리가 필요합니다. [시스템 요구 사항](https://code.claude.com/docs/ko/setup.md#system-requirements)을 참조하세요.

**해결 방법:**

1. **서버의 RAM이 제한되어 있으면 스왑 공간 추가**. 스왑은 디스크 공간을 오버플로우 메모리로 사용하여 물리적 RAM이 낮아도 설치를 완료할 수 있습니다.

   2GB 스왑 파일을 생성하고 활성화합니다.

   ```bash theme={null}
   sudo fallocate -l 2G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```

   그런 다음 설치를 다시 시도합니다.

   ```bash theme={null}
   curl -fsSL https://claude.ai/install.sh | bash
   ```

2. **설치 전에 다른 프로세스를 닫아** 메모리를 확보합니다.

3. **가능하면 더 큰 인스턴스 사용**. Claude Code는 최소 4GB의 RAM이 필요합니다.

### Installation was killed before it could finish

설치 스크립트는 `claude install` 단계가 시그널로 종료되면 이를 보고합니다. Linux에서 종료 코드 137은 프로세스가 SIGKILL을 받았음을 의미하며, 메모리가 부족한 호스트에서는 보통 커널의 OOM(메모리 부족) 킬러가 원인입니다. 스크립트는 다음 설명을 출력하고 코드 137로 종료합니다.

```text theme={null}
Installation was killed before it could finish (exit code 137). This usually means the system ran out of memory.
Claude Code needs roughly 512MB of free memory to install. Free up memory, then run this script again.
```

그 외의 치명적인 시그널이나 macOS의 종료 코드 137의 경우, 스크립트는 실제 종료 코드와 함께 `Installation was killed before it could finish (exit code <N>)`를 출력하고 메모리 부족 설명은 생략합니다. 이 메시지는 macOS와 Linux에서 사용하는 설치 스크립트에서 출력되며, WSL 내부의 설치도 여기에 포함됩니다. 네이티브 Windows 설치 스크립트는 이 메시지를 출력하지 않습니다. v2.1.200 이전에는 스크립트가 셸의 단순한 `Killed` 줄만 남기고 종료되었습니다.

**해결 방법:**

* 다른 프로세스를 중지하여 메모리를 확보한 다음 설치 프로그램을 다시 실행합니다
* 스왑 공간을 추가하거나 더 큰 인스턴스로 이동합니다. 스왑 파일 명령은 [메모리 부족 Linux 서버에서 설치 중단](#install-killed-on-low-memory-linux-servers)을 참조하세요.

### Docker에서 설치 중단

Docker 컨테이너에서 Claude Code를 설치할 때 `/`에 루트로 설치하면 중단될 수 있습니다.

**해결 방법:**

1. **설치 프로그램을 실행하기 전에 작업 디렉터리 설정**. `/`에서 실행하면 설치 프로그램이 전체 파일 시스템을 스캔하여 과도한 메모리 사용을 유발합니다. `WORKDIR`을 설정하면 스캔이 작은 디렉터리로 제한됩니다.
   ```dockerfile theme={null}
   WORKDIR /tmp
   RUN curl -fsSL https://claude.ai/install.sh | bash
   ```

2. **Docker Desktop을 사용하는 경우 Docker에 더 많은 메모리 제공**. 빌드 컨테이너는 Docker Desktop 가상 머신에 할당된 메모리를 공유하므로 Docker Desktop에서 **Settings > Resources**를 열고 메모리 제한을 높인 다음 빌드를 다시 실행합니다.

### 설치 중 `Raw mode is not supported`

조직의 [서버 관리 설정](https://code.claude.com/docs/ko/server-managed-settings.md)에 [보안 승인](https://code.claude.com/docs/ko/server-managed-settings.md#security-approval-dialogs)이 필요한 변경 사항이 포함되어 있으면 2.1.246 이전의 Claude Code 버전은 `claude install` 중에 승인 대화 상자를 표시하려고 시도합니다. 대화 상자는 stdin의 터미널이 필요합니다. 설치 프로그램이 `curl -fsSL https://claude.ai/install.sh | bash`처럼 파이프에서 `claude install`을 실행하면 stdin은 터미널이 아닌 파이프이므로 설치가 `Raw mode is not supported`를 포함하는 오류로 실패합니다.

Claude Code v2.1.246 이상은 `claude install` 또는 `claude update` 중에 대화 상자를 표시하지 않습니다. 명령은 마지막으로 승인한 설정으로 실행되며 Claude Code는 다음 대화형 세션에서 대화 상자를 표시합니다. 조직의 시작 구성이 [설정 가져오기를 기다리는](https://code.claude.com/docs/ko/server-managed-settings.md#enforce-fail-closed-startup) 경우(예: `forceRemoteSettingsRefresh`를 설정할 때) 대화 상자는 여전히 이러한 명령 중에 나타나며 파이프에서 실행되는 설치는 여전히 실패합니다.

다른 모든 구성에서는 설치 프로그램을 다시 실행하면 이 오류를 지나갑니다. 스크립트는 이전 버전을 설치하도록 요청할 때도 최신 릴리스의 `install` 명령을 실행하기 때문입니다. 플랫폼에 대한 명령을 다시 실행합니다.

> [tab] macOS/Linux
>
> ```bash theme={null}
> curl -fsSL https://claude.ai/install.sh | bash
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> irm https://claude.ai/install.ps1 | iex
> ```

`claude --version`은 다시 실행이 설치한 버전을 출력합니다.

### `claude update` 또는 `claude doctor` 중단

`claude update` 및 `claude doctor`는 셸 설정 파일에서 오래된 `claude` 별칭을 스캔합니다. `~/.zshrc`, `~/.bashrc` 및 `~/.config/fish/config.fish`, macOS에서는 존재하는 `~/.bash_profile`, `~/.bash_login` 또는 `~/.profile` 중 첫 번째입니다. `ZDOTDIR`을 설정하면 Zsh 파일은 `$ZDOTDIR/.zshrc`입니다. 이러한 경로 중 하나가 디렉터리인 경우 Claude Code는 이를 건너뛰고 두 명령 모두 정상적으로 완료됩니다. v2.1.214 이전에는 이러한 경로의 디렉터리가 두 명령을 중단하게 했으며 `/status`의 System diagnostics 섹션을 비워 두었습니다. `claude doctor`는 출력 없이 중단되었습니다. `claude update`는 `Checking for updates`를 출력한 직후 중단되었습니다.

이전 버전에서 중단이 발생하면 디렉터리를 찾습니다. 이 명령의 출력에서 `d`로 시작하는 줄은 해당 경로를 디렉터리로 표시합니다. `No such file or directory` 줄은 해당 경로에 아무것도 없으며 원인이 아님을 의미합니다.

```bash theme={null}
ls -ld ~/.zshrc ~/.bashrc ~/.bash_profile ~/.bash_login ~/.profile ~/.config/fish/config.fish
```

디렉터리를 옆으로 이동하거나 v2.1.214 이상으로 업데이트합니다. `claude update`는 영향을 받는 버전에서 중단되므로 [설치 스크립트](https://code.claude.com/docs/ko/setup.md#install-claude-code)를 다시 실행하여 업데이트합니다.

### Claude Desktop이 Windows에서 `claude` 명령을 재정의합니다

이전 버전의 Claude Desktop을 설치했으면 `WindowsApps` 디렉터리에 `Claude.exe`를 등록할 수 있으며, 이는 Claude Code CLI보다 PATH 우선 순위를 가집니다. `claude`를 실행하면 CLI 대신 Desktop 앱이 열립니다.

Claude Desktop을 최신 버전으로 업데이트하여 이 문제를 해결합니다.

### Claude Code on Windows requires either Git for Windows (for bash) or PowerShell

Git for Windows는 선택 사항입니다. Claude Code는 Git Bash가 없을 때 [PowerShell 도구](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool)를 사용하므로 이 오류는 어느 셸도 찾을 수 없음을 의미합니다.

**PowerShell이 PATH에서 누락된 경우** 기본 위치는 `C:\Windows\System32\WindowsPowerShell\v1.0\`입니다. 해당 디렉터리를 `PATH`에 추가하거나 `pwsh`를 제공하는 [PowerShell 7](https://aka.ms/powershell)을 설치합니다.

**Git for Windows를 대신 설치하려면** [git-scm.com/downloads/win](https://git-scm.com/downloads/win)에서 다운로드합니다. 설정 중에 "Add to PATH"를 선택합니다. 설치 후 터미널을 다시 시작합니다. 설치하면 Bash 도구가 활성화되어 Bash 기반 스크립트 및 도구로 작업할 때 유용합니다.

**Git이 이미 설치되어 있지만 Claude Code가 찾을 수 없으면** 해당 위치를 Claude Code가 확인하는 위치와 비교합니다. `CLAUDE_CODE_GIT_BASH_PATH`가 설정되지 않으면 Claude Code는 다음 순서로 `bash.exe`를 찾습니다.

1. 기본 설치 위치 `C:\Program Files\Git` 및 `C:\Program Files (x86)\Git`.
2. `PATH`의 `git`을 사용하여 해당 Git 설치의 `bin\bash.exe`.

2단계에서 Claude Code는 Claude Code를 시작한 폴더에 있거나 `node_modules` 또는 `.venv` 또는 `env`와 같은 가상 환경 폴더를 포함하는 경로 아래에 있는 `git`을 건너뜁니다. 예를 들어 `C:\dev\env\myproject`에서 시작했을 때 `C:\dev\env\myproject\Git`. 이는 Claude Code가 프로젝트가 배치한 실행 파일을 실행하지 않도록 합니다. Git이 그러한 위치에 있으면 `CLAUDE_CODE_GIT_BASH_PATH`가 해당 위치를 가리키도록 설정합니다.

**Claude Code를 특정 Git 설치로 가리키려면** PowerShell에서 `where.exe git`을 실행하여 찾은 다음 해당 설치의 `bin\bash.exe` 경로를 [settings.json 파일](https://code.claude.com/docs/ko/settings.md)에서 `CLAUDE_CODE_GIT_BASH_PATH`로 설정합니다.

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe"
  }
}
```

**`CLAUDE_CODE_GIT_BASH_PATH`가 올바른 경로로 설정되고 파일이 존재하지만** Claude Code가 여전히 사용하지 않으면 먼저 파일의 이름을 확인합니다. Claude Code는 `bash.exe`, `sh.exe`, `bash` 또는 `sh`라는 이름의 파일만 허용합니다. Git for Windows의 `git-bash.exe` 런처와 같은 다른 이름의 경우 변수를 무시하고 설정되지 않은 것처럼 Git Bash를 자동 감지하며 `--debug`로 볼 수 있는 경고를 기록합니다. 존재하지 않는 경로는 동일한 폴백 및 경고를 받습니다. v2.1.219 이전에는 Claude Code가 이름을 확인하지 않고 존재하는 모든 파일을 셸로 사용했으며 경로가 존재하지 않을 때 `Claude Code was unable to find CLAUDE_CODE_GIT_BASH_PATH path`로 시작 시 종료되었습니다.

파일의 이름이 맞으면 AppLocker, 그룹 정책 소프트웨어 제한 정책 또는 EDR 에이전트와 같은 엔드포인트 보안 소프트웨어가 간섭할 수 있습니다. IT 팀에 엔드포인트 보호 정책에서 `claude.exe` 및 `cmd.exe` 및 `bash.exe`를 포함한 생성하는 프로세스를 허용 목록에 추가하도록 요청합니다.

### Claude Code는 32비트 Windows를 지원하지 않습니다

Windows는 시작 메뉴에 두 개의 PowerShell 항목을 포함합니다. `Windows PowerShell` 및 `Windows PowerShell (x86)`. x86 항목은 32비트 프로세스로 실행되며 64비트 머신에서도 이 오류를 트리거합니다. 어느 경우인지 확인하려면 오류를 생성한 동일한 창에서 다음을 실행합니다.

```powershell theme={null}
[Environment]::Is64BitOperatingSystem
```

이것이 `True`를 출력하면 운영 체제는 정상입니다. 창을 닫고 x86 접미사 없이 `Windows PowerShell`을 열고 설치 명령을 다시 실행합니다.

이것이 `False`를 출력하면 32비트 Windows 버전에 있습니다. Claude Code는 64비트 운영 체제가 필요합니다. [시스템 요구 사항](https://code.claude.com/docs/ko/setup.md#system-requirements)을 참조하세요.

### Linux musl 또는 glibc 바이너리 불일치

설치 후 `libstdc++.so.6` 또는 `libgcc_s.so.1`과 같은 누락된 공유 라이브러리에 대한 오류가 표시되면 설치 프로그램이 시스템에 대해 잘못된 바이너리 변형을 다운로드했을 수 있습니다.

```text theme={null}
Error loading shared library libstdc++.so.6: No such file or directory
```

이는 musl 교차 컴파일 패키지가 설치된 glibc 기반 시스템에서 발생할 수 있으며, 설치 프로그램이 시스템을 musl로 잘못 감지하게 합니다.

**해결 방법:**

1. **시스템이 사용하는 libc 확인**:
   ```bash theme={null}
   ldd --version 2>&1 | head -1
   ```
   `GNU libc` 또는 `GLIBC`를 언급하는 출력은 glibc를 의미합니다. `musl`을 언급하는 출력은 musl을 의미합니다.

2. **glibc에 있지만 musl 바이너리를 받은 경우** 설치를 제거하고 다시 설치합니다. `https://downloads.claude.ai/claude-code-releases/{VERSION}/manifest.json`의 매니페스트를 사용하여 올바른 바이너리를 수동으로 다운로드할 수도 있습니다. `ldd --version` 및 `ls /lib/libc.musl*`의 출력으로 [GitHub 이슈](https://github.com/anthropics/claude-code/issues)를 제출합니다.

3. **실제로 Alpine Linux와 같은 musl에 있으면** 필요한 패키지를 설치합니다.
   ```bash theme={null}
   apk add libgcc libstdc++ ripgrep
   ```
   Alpine에서 `ripgrep`은 커뮤니티 저장소에 있습니다. `apk`가 패키지가 누락되었다고 보고하면 [Alpine Linux 설정](https://code.claude.com/docs/ko/setup.md#alpine-linux-and-musl-based-distributions)을 참조하세요.

### `Illegal instruction`

`claude`를 실행하거나 설치 프로그램이 `Illegal instruction`을 출력하면 네이티브 바이너리가 프로세서가 지원하지 않는 CPU 명령을 사용합니다. 두 가지 서로 다른 원인이 있습니다.

**아키텍처 불일치.** 설치 프로그램이 잘못된 바이너리를 다운로드했습니다. 예를 들어 ARM 서버의 x86. macOS 또는 Linux에서 `uname -m`으로 확인하거나 PowerShell에서 `$env:PROCESSOR_ARCHITECTURE`로 확인합니다. 결과가 받은 바이너리와 일치하지 않으면 출력으로 [GitHub 이슈](https://github.com/anthropics/claude-code/issues)를 제출합니다.

**AVX 명령 집합 누락.** 아키텍처는 맞지만 여전히 `Illegal instruction`이 표시되면 CPU에 바이너리가 필요로 하는 AVX 또는 다른 명령이 없을 가능성이 높습니다. 이는 대략 2013년 이전의 Intel 및 AMD 프로세서와 하이퍼바이저가 게스트에 AVX를 전달하지 않는 가상 머신에 영향을 줍니다.

VPS 또는 VM에서 `grep -m1 -ow avx /proc/cpuinfo`를 실행합니다. 빈 결과는 AVX를 게스트에서 사용할 수 없음을 의미합니다.

네이티브 바이너리 해결 방법이 없습니다. [이슈 #50384](https://github.com/anthropics/claude-code/issues/50384)에서 상태를 추적하고 보고할 때 Linux의 `grep -m1 "model name" /proc/cpuinfo` 또는 macOS의 `sysctl -n machdep.cpu.brand_string`에서 CPU 모델을 포함합니다.

대체 설치 방법은 동일한 네이티브 바이너리를 다운로드하며 어느 원인도 해결하지 않습니다.

### macOS에서 `dyld: cannot load`

설치 중에 `dyld: Symbol not found`, `dyld: cannot load` 또는 `Abort trap: 6`이 표시되면 바이너리가 macOS 버전 또는 하드웨어와 호환되지 않습니다.

`libicucore`를 참조하는 `Symbol not found` 오류는 macOS 버전이 바이너리가 지원하는 것보다 오래되었음을 의미합니다.

```text theme={null}
dyld: Symbol not found: _ubrk_clone
  Referenced from: claude-darwin-x64 (which was built for Mac OS X 13.0)
  Expected in: /usr/lib/libicucore.A.dylib
```

로더는 대신 바이너리의 로드 명령을 거부할 수 있으며, 이는 macOS 버전이 너무 오래되었음을 의미합니다.

```text theme={null}
dyld: cannot load 'claude-2.1.42-darwin-x64' (load command 0x80000034 is unknown)
Abort trap: 6
```

**해결 방법:**

1. **macOS 버전 확인**: Claude Code는 macOS 13.0 이상이 필요합니다. Apple 메뉴를 열고 이 Mac에 대해를 선택하여 버전을 확인합니다.

2. **이전 버전에 있으면 macOS 업데이트**. 바이너리는 이전 macOS 버전이 지원하지 않는 로드 명령 및 시스템 라이브러리를 사용합니다. Homebrew와 같은 대체 설치 방법은 동일한 바이너리를 다운로드하며 이 오류를 해결하지 않습니다.

### 세션 실행 중 `Bus error`

실행 중인 세션이 종료되고 셸에 `Bus error`가 출력되면, 한 가지 원인은 Claude Code가 더 이상 디스크에서 자체 실행 파일을 읽을 수 없게 된 것입니다. 예를 들어 세션이 실행되는 동안 파일이 잘리거나 네트워크 스토리지에서 삭제된 경우입니다.

셸의 메시지 앞에 Claude Code의 런타임이 `panic(main thread): Bus error at address` 및 `oh no: Bun has crashed. This indicates a bug in Bun, not your code.`를 포함하는 크래시 보고서를 출력할 수 있습니다. 실행 파일을 읽을 수 없게 된 경우 크래시는 Bun의 버그가 아니라 읽을 수 없는 파일로 인해 발생합니다. 런타임이 보고서를 출력하는 코드조차 읽을 수 없었다면 보고서가 없을 수도 있습니다.

계속하려면 새 세션을 시작합니다. Claude Code가 네트워크 스토리지에 설치되어 있으면 [네트워크 스토리지에 설치](https://code.claude.com/docs/ko/setup.md#install-on-network-storage)를 따라 업그레이드가 실행 중인 세션에 여전히 필요한 바이너리를 제거하지 않도록 합니다.

### WSL1에서 `Exec format error`

WSL에서 `claude`를 실행하면 `cannot execute binary file: Exec format error`가 출력되면 WSL1에 있으며 [이슈 #38788](https://github.com/anthropics/claude-code/issues/38788)에서 추적되는 알려진 네이티브 바이너리 회귀에 직면하고 있습니다. 바이너리의 프로그램 헤더가 WSL1의 로더가 처리할 수 없는 방식으로 변경되었습니다.

가장 깔끔한 수정은 PowerShell에서 배포판을 WSL2로 변환하는 것입니다.

```powershell theme={null}
wsl --set-version <DistroName> 2
```

WSL1에 머물러야 하면 동적 링커를 통해 바이너리를 호출합니다. WSL 내의 `~/.bashrc`에 이 함수를 추가하고 홈 디렉터리가 다르면 경로를 바꿉니다.

```bash theme={null}
claude() {
  /lib64/ld-linux-x86-64.so.2 "$(readlink -f "$HOME/.local/bin/claude")" "$@"
}
```

그런 다음 `source ~/.bashrc`를 실행하고 `claude`를 다시 시도합니다.

### WSL에서 npm 설치 오류

이러한 문제는 WSL 내에서 `npm install -g`로 Claude Code를 설치한 경우 적용됩니다. [네이티브 설치 프로그램](https://code.claude.com/docs/ko/setup.md)을 사용한 경우 이 섹션을 건너뜁니다. npm 12에서는 [npm 12 설치 수정](#fix-an-npm-12-install)에 설명된 대로 설치합니다.

**OS 또는 플랫폼 감지 문제.** npm이 설치 중에 플랫폼 불일치를 보고하면 WSL이 Windows `npm`을 선택하고 있을 가능성이 높습니다. 먼저 `npm config set os linux`를 실행한 다음 `npm install -g @anthropic-ai/claude-code --force`로 설치합니다. `sudo`를 사용하지 마세요.

**`claude` 실행 시 `exec: node: not found`.** WSL 환경이 Node.js의 Windows 설치를 사용하고 있을 가능성이 높습니다. `which npm` 및 `which node`로 확인합니다. `/mnt/c/`로 시작하는 경로는 Windows 바이너리이고 Linux 경로는 `/usr/`로 시작합니다. 이를 수정하려면 Linux 배포판의 패키지 관리자 또는 [`nvm`](https://github.com/nvm-sh/nvm)을 통해 Node를 설치합니다.

**nvm 버전 충돌.** WSL과 Windows 모두에 nvm이 설치되어 있으면 WSL에서 Node 버전을 전환하면 WSL이 기본적으로 Windows PATH를 가져오고 Windows nvm이 우선 순위를 가지기 때문에 중단될 수 있습니다. 가장 일반적인 원인은 nvm이 셸에 로드되지 않는 것입니다. nvm 로더를 `~/.bashrc` 또는 `~/.zshrc`에 추가합니다.

```bash theme={null}
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

또는 현재 세션에서 로드합니다.

```bash theme={null}
source ~/.nvm/nvm.sh
```

nvm이 로드되었지만 Windows 경로가 여전히 우선 순위를 가지면 Linux Node 경로를 명시적으로 앞에 추가합니다.

```bash theme={null}
export PATH="$HOME/.nvm/versions/node/$(node -v)/bin:$PATH"
```

> [!WARNING]
>
> `appendWindowsPath = false`를 통해 Windows PATH 가져오기를 비활성화하지 마세요. 이는 WSL에서 Windows 실행 파일을 호출하는 기능을 중단합니다. 마찬가지로 Windows 개발에 사용하는 경우 Windows에서 Node.js를 제거하지 마세요.

### 설치 중 권한 오류

네이티브 설치 프로그램이 권한 오류로 실패하면 대상 디렉터리를 쓸 수 없을 수 있습니다. [디렉터리 권한 확인](#check-directory-permissions)을 참조하세요.

이전에 npm으로 설치했고 npm 특정 권한 오류에 직면하면 네이티브 설치 프로그램으로 전환합니다.

```bash theme={null}
curl -fsSL https://claude.ai/install.sh | bash
```

### npm 설치 후 네이티브 바이너리를 찾을 수 없습니다

`@anthropic-ai/claude-code` npm 패키지는 `@anthropic-ai/claude-code-darwin-arm64`와 같은 플랫폼별 선택적 의존성으로 네이티브 바이너리를 다운로드합니다. `@anthropic-ai/claude-code` 패키지의 postinstall 단계가 실행되어 자리 표시자를 해당 바이너리로 교체하기 전까지 `claude`는 자리 표시자 스크립트입니다. 다운로드 또는 postinstall 단계 중 하나가 건너뛰어지면 자리 표시자가 제자리에 남아 있으며 macOS 및 Linux에서 `claude`를 실행하면 다음이 출력됩니다.

```text theme={null}
Error: claude native binary not installed.

Either postinstall did not run (--ignore-scripts, some pnpm configs)
or the platform-native optional dependency was not downloaded
(--omit=optional).

Run the postinstall manually (adjust path for local vs global install):
  node node_modules/@anthropic-ai/claude-code/install.cjs

Or reinstall without --ignore-scripts / --omit=optional.
```

Windows에서 `bin/claude.exe`는 실제 실행 파일이 아닌 동일한 셸 스크립트 자리 표시자이므로 PowerShell 및 CMD는 이 메시지를 출력하는 대신 파일을 실행할 수 없다고 보고합니다.

다음 원인을 확인합니다.

* **npm 12는 기본적으로 postinstall 단계를 건너뜀.** npm 12로 Claude Code를 설치하거나 업데이트하면 npm은 이 단계를 실행하지 않고도 설치를 완료합니다. [npm 12 설치 수정](#fix-an-npm-12-install)을 참조하세요.
* **선택적 의존성이 비활성화됨.** npm 설치 명령에서 `--omit=optional`을 제거하고 pnpm에서 `--no-optional`을 제거하고 yarn에서 `--ignore-optional`을 제거하고 `.npmrc`가 `optional=false`를 설정하지 않는지 확인합니다. 그런 다음 다시 설치합니다. 네이티브 바이너리는 선택적 의존성으로만 제공되므로 건너뛰어지면 JavaScript 폴백이 없으며 `install.cjs`를 다시 실행해도 다운로드되지 않은 바이너리를 배치할 수 없습니다.
* **설치 스크립트가 비활성화됨.** `--ignore-scripts` 및 일부 pnpm 구성은 postinstall 단계를 건너뛰지만 여전히 플랫폼 패키지를 다운로드합니다. 메시지가 제안하는 대로 `node node_modules/@anthropic-ai/claude-code/install.cjs`를 실행하거나 플래그 없이 다시 설치합니다. postinstall이 환경에서 실행될 수 없으면 `node node_modules/@anthropic-ai/claude-code/cli-wrapper.cjs`가 다운로드된 패키지를 찾고 시작하며, 각 시작 시 추가 Node 프로세스의 비용이 발생합니다. 래퍼가 `Could not find native binary package`를 출력하면 플랫폼 패키지가 다운로드되지 않았으므로 먼저 위의 선택적 의존성 원인을 수정합니다.
* **지원되지 않는 플랫폼.** 미리 빌드된 바이너리는 `darwin-arm64`, `darwin-x64`, `linux-x64`, `linux-arm64`, `linux-x64-musl`, `linux-arm64-musl`, `win32-x64` 및 `win32-arm64`에 대해 게시됩니다. Claude Code는 다른 플랫폼에 대한 바이너리를 제공하지 않습니다. [시스템 요구 사항](https://code.claude.com/docs/ko/setup.md#system-requirements)을 참조하세요. FreeBSD에서 설치 프로그램은 플랫폼을 지원되지 않는 것으로 보고합니다. v2.1.205 이전에는 FreeBSD를 Linux로 취급하고 실행할 수 없는 바이너리를 다운로드했습니다.
* **회사 npm 미러가 플랫폼 패키지를 누락함.** 레지스트리가 메타 패키지 외에도 8개의 `@anthropic-ai/claude-code-*` 플랫폼 패키지를 모두 미러링하는지 확인합니다.

#### npm 12 설치 수정

npm 설치 또는 업데이트 후 `claude`가 `Error: claude native binary not installed.`를 출력하거나 Windows에서 셸이 이를 실행할 수 없으면 `npm --version`을 실행합니다. 버전이 `12`로 시작하면 npm 설정에서 허용하지 않는 한 npm이 바이너리를 제자리에 배치하는 Claude Code의 postinstall 단계를 건너뛴 것입니다. 다른 버전이면 [다른 원인](#native-binary-not-found-after-npm-install)을 확인합니다.

npm 12 설치를 수정하려면 네이티브 설치 프로그램으로 전환하거나 해당 단계를 허용합니다.

* **네이티브 설치 프로그램으로 전환**: [네이티브 설치 프로그램으로 설치](https://code.claude.com/docs/ko/setup.md#install-claude-code)한 다음 [npm 패키지를 제거](https://code.claude.com/docs/ko/setup.md#uninstall-with-npm)합니다. 이후 업데이트는 npm을 사용하지 않으므로 오류가 다시 발생하지 않습니다.
* **npm 계속 사용**: 전역 npm 설치의 경우 사용자 npm 설정의 `allow-scripts`에 Claude Code를 추가합니다. 그러면 npm은 이후의 모든 설치 및 업데이트와 `package.json`에 `allowScripts`가 설정되지 않은 프로젝트 설치에서 Claude Code의 설치 스크립트를 실행합니다.

  `~/.claude/local`의 로컬 설치에는 네이티브 설치 프로그램을 사용합니다. `package.json` 스크립트가 `npm install`을 호출하고 이를 pnpm 9, pnpm 10, Yarn 1 또는 이 설정을 해당 스크립트에 전달하는 다른 도구로 실행하는 경우에도 네이티브 설치 프로그램을 사용합니다. npm 12.1 이상에서는 설정이 저장되면 이러한 설치가 `EALLOWSCRIPTS`로 실패할 수 있습니다.

  1. `npm --version`이 12.0.x를 출력했다면 `npm install -g npm@latest` 등으로 npm을 12.1 이상으로 업데이트합니다. 12.0.x에서는 설정이 저장되면 `npx` 도구나 `npm run` 스크립트가 시작하는 프로젝트 설치가 `EALLOWSCRIPTS`로 실패할 수 있습니다.

  2. 다음 명령이 전체 값을 교체하므로 `npm config get allow-scripts`를 실행하여 나열되는 패키지를 기록해 둡니다. `"allow-scripts=@anthropic-ai/claude-code,<package>"`처럼 해당 패키지를 따옴표 안에 포함하여 설정을 저장합니다.

     ```bash theme={null}
     npm config set "allow-scripts=@anthropic-ai/claude-code" --location=user
     ```

  3. 다시 설치합니다.

     ```bash theme={null}
     npm install -g @anthropic-ai/claude-code
     ```

     이 단계나 1단계가 `EACCES`로 실패하면 `sudo`로 다시 실행하지 말고 네이티브 설치 프로그램으로 전환합니다. Claude Code는 자체 업데이트 시 `sudo` 없이 npm을 실행하므로 자동 업데이트도 같은 방식으로 실패하게 됩니다.

  4. `claude --version`이 버전 번호를 출력하지 않으면 [다른 원인](#native-binary-not-found-after-npm-install)을 확인합니다.

  되돌리려면 `@anthropic-ai/claude-code`를 제외하고 목록을 다시 설정하거나 `npm config delete allow-scripts --location=user`로 전체 목록을 제거합니다. npm 12에서는 그 후 다음 업데이트 이후 오류가 다시 발생합니다.

### npm 업데이트 또는 재설치 중 `ENOTEMPTY` 오류

기존 설치에 대해 `npm install -g @anthropic-ai/claude-code`를 실행하면 npm이 이전 패키지 디렉터리를 옆으로 이동하는 동안 실패할 수 있습니다.

```text theme={null}
npm error code ENOTEMPTY
npm error syscall rename
npm error path /home/you/.nvm/versions/node/v22.13.1/lib/node_modules/@anthropic-ai/claude-code
npm error dest /home/you/.nvm/versions/node/v22.13.1/lib/node_modules/@anthropic-ai/.claude-code-tVWAnUUt
npm error errno -39
npm error ENOTEMPTY: directory not empty, rename '...'
```

`npm error path` 줄은 npm이 이동할 수 없는 디렉터리의 이름을 지정합니다. 해당 디렉터리와 옆에 있는 모든 `.claude-code-*` 디렉터리를 삭제합니다. 이전 중단된 실행이 남길 수 있습니다. 아래 명령은 `npm root -g`로 전역 패키지 디렉터리를 찾습니다. `npm error path` 줄이 이름을 지정하는 디렉터리가 `npm root -g`가 출력하는 디렉터리 아래에 없으면(예: nvm으로 Node 버전을 전환했기 때문에) 오류가 이름을 지정하는 디렉터리를 대신 삭제합니다.

> [tab] macOS/Linux
>
> ```bash theme={null}
> rm -rf "$(npm root -g)/@anthropic-ai/claude-code"
> ```
>
> 그런 다음 남은 임시 디렉터리를 제거합니다. Zsh가 `no matches found`를 출력하면 제거할 것이 없었습니다.
>
> ```bash theme={null}
> rm -rf "$(npm root -g)/@anthropic-ai/.claude-code-"*
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> Remove-Item -Recurse -Force "$(npm root -g)/@anthropic-ai/claude-code", "$(npm root -g)/@anthropic-ai/.claude-code-*"
> ```

그런 다음 다시 설치합니다. npm 12에서는 [npm 12 설치 수정](#fix-an-npm-12-install)을 따릅니다. 그 외의 경우 다음을 실행합니다.

```bash theme={null}
npm install -g @anthropic-ai/claude-code
```

`claude --version`으로 확인합니다. 이는 `2.1.211 (Claude Code)`와 같은 버전 번호를 출력합니다.

## 로그인 및 인증

이 섹션은 로그인 실패, OAuth 오류 및 토큰 문제를 다룹니다.

### 로그인 재설정

로그인이 실패하고 원인이 명확하지 않으면 깨끗한 재인증이 대부분의 경우를 해결합니다:

1. `/logout`을 실행하여 완전히 로그아웃
2. Claude Code 닫기
3. `claude`로 다시 시작하고 인증 프로세스 완료

브라우저가 로그인 중에 자동으로 열리지 않으면 `c`를 눌러 OAuth URL을 클립보드에 복사한 다음 수동으로 브라우저에 붙여넣으세요. 이는 URL이 좁은 또는 SSH 터미널에서 줄을 넘어 래핑되고 직접 클릭할 수 없을 때도 작동합니다.

### OAuth 오류: 유효하지 않은 코드

`OAuth error: Invalid code. Please make sure the full code was copied`가 표시되면 로그인 코드가 만료되었거나 복사-붙여넣기 중에 잘렸습니다.

**해결책:**

* Enter를 눌러 다시 시도하고 브라우저가 열린 후 빠르게 로그인 완료
* 브라우저가 자동으로 열리지 않으면 `c`를 입력하여 전체 URL 복사
* 원격/SSH 세션을 사용하는 경우 브라우저가 잘못된 머신에서 열릴 수 있습니다. 터미널에 표시된 URL을 복사하고 로컬 브라우저에서 대신 열어보세요.

### 로그인 후 403 Forbidden

로그인 후 `API Error: 403 Request not allowed`가 표시되면:

* **Claude Pro/Max/Ultra 사용자**: [claude.ai/settings](https://claude.ai/settings)에서 구독이 활성화되어 있는지 확인
* **Anthropic Console 사용자**: 계정에 "Claude Code" 또는 "Developer" 역할이 있는지 확인. 관리자는 [platform.claude.com/settings/members](https://platform.claude.com/settings/members)의 Console 멤버 페이지에서 이를 할당합니다.
* **프록시 뒤에 있음**: 회사 프록시가 API 요청을 방해할 수 있습니다. 프록시 설정은 [네트워크 구성](https://code.claude.com/docs/ko/network-config.md)을 참조하세요.

### Claude Code 액세스가 이 계정에 대해 부여되지 않음

Claude Code에서 로그인한 후 로그인 페이지에 `Authorization failed`와 함께 `Claude Code access has not been granted for this account. Contact your administrator.` 메시지가 표시되면 Claude Enterprise 조직이 역할을 Custom으로 설정했으며 그룹에 할당된 [사용자 정의 역할](https://support.claude.com/en/articles/13930452) 중 Claude Code를 부여하는 역할이 없습니다. Custom 역할에서는 해당 사용자 정의 역할에서만 액세스 권한을 얻으므로 Claude Code에서 변경하는 것은 이 오류를 해결하지 못합니다.

액세스 권한을 얻으려면:

1. Claude 조직의 Owner에게 Claude Code 액세스를 부여하는 사용자 정의 역할을 그룹 중 하나에 할당하거나 역할을 Custom에서 User와 같은 표준 역할로 변경하도록 요청하세요. Owner는 조직의 [역할 설정](https://claude.ai/admin-settings/roles)에서 역할을 관리합니다.
2. Owner가 변경한 후 `claude`를 실행하고 다시 로그인하세요.

### 이 조직은 활성 구독으로 비활성화되었습니다

활성 Claude 구독이 있음에도 불구하고 `API Error: 400 ... "This organization has been disabled"`가 표시되면 `ANTHROPIC_API_KEY` 환경 변수가 구독을 무시하고 있습니다. 이는 이전 고용주 또는 프로젝트의 이전 API 키가 여전히 셸 프로필에 설정되어 있을 때 일반적으로 발생합니다.

`ANTHROPIC_API_KEY`가 있고 승인한 경우 Claude Code는 구독의 OAuth 자격 증명 대신 해당 키를 사용합니다. `-p` 플래그를 사용한 비대화형 모드에서는 키가 있을 때 항상 사용됩니다. 전체 해결 순서는 [인증 우선순위](https://code.claude.com/docs/ko/authentication.md#authentication-precedence)를 참조하세요.

대신 구독을 사용하려면 환경 변수를 설정 해제하고 셸 프로필에서 제거하세요:

> [tab] macOS/Linux
>
> ```bash theme={null}
> unset ANTHROPIC_API_KEY
> claude
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> Remove-Item Env:ANTHROPIC_API_KEY
> claude
> ```

`~/.zshrc`, `~/.bashrc` 또는 `~/.profile`에서 `export ANTHROPIC_API_KEY=...` 줄을 확인하고 변경을 영구적으로 만들려면 제거하세요. Windows에서 `$PROFILE`의 PowerShell 프로필과 `ANTHROPIC_API_KEY`의 사용자 환경 변수를 확인하세요. Claude Code 내에서 `/status`를 실행하여 어느 인증 방법이 활성화되어 있는지 확인하세요.

### WSL2, SSH 또는 컨테이너에서 OAuth 로그인 실패

브라우저가 열리지 않거나, 브라우저에서 로그인한 후 `localhost` 주소에 대한 연결 오류가 표시되더라도 두 문제 중 어느 것도 해결하지 않고 로그인을 완료할 수 있습니다. 대신 터미널이 붙여넣기 프롬프트 위에 표시하는 별도의 로그인 URL을 통해 로그인하세요:

**1. 로그인 URL 복사**

대화형 로그인 프롬프트에서 `c`를 눌러 URL을 복사하거나 터미널에서 URL을 선택하세요. `claude auth login`을 사용하는 경우 출력되는 URL을 복사하세요.

**2. 해당 URL을 통해 로그인**

로컬 머신의 브라우저에서 URL을 열고 로그인하세요. 그러면 브라우저는 `localhost`로 돌아가는 대신 코드를 표시합니다.

**3. 코드 붙여넣기**

`Paste code here`로 시작하는 프롬프트에서 해당 코드를 터미널에 붙여넣으세요.

대화형 프롬프트에 코드를 붙여넣어도 아무것도 하지 않으면 터미널의 붙여넣기 바인딩이 입력 필드에 도달하지 않을 가능성이 높습니다. 터미널의 대체 붙여넣기 바로 가기를 시도해보세요. 종종 Windows Terminal에서 우클릭 또는 Shift+Insert이거나 대신 `claude auth login`을 사용하세요. 이는 표준 입력에서 붙여넣은 코드를 읽습니다:

```bash theme={null}
claude auth login
```

이 폴백은 네이티브 Windows 또는 대화형 프롬프트에 붙여넣기가 실패하는 모든 터미널에도 적용됩니다.

WSL2에서 브라우저가 열리지 않았다면 `BROWSER` 환경 변수를 해당 브라우저의 경로로 설정하여 다음번에는 Claude Code가 Windows 브라우저를 열도록 할 수도 있습니다:

```bash theme={null}
export BROWSER="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
claude
```

### 로그인하지 않음 또는 토큰 만료

Claude Code가 세션 후 다시 로그인하도록 요청하면 OAuth 토큰이 만료되었을 수 있습니다.

`/login`을 실행하여 다시 인증하세요. 이것이 자주 발생하면 토큰 검증이 올바른 타임스탬프에 따라 달라지므로 시스템 시계가 정확한지 확인하세요.

한 머신의 병렬 세션은 저장된 로그인을 공유하고 그 갱신을 조정하여 한 번에 하나의 프로세스만 토큰을 새로고침합니다. 그중 한 세션에서 다시 로그인한 후 다른 세션이 어떻게 동작하는지는 [로그인하지 않음](https://code.claude.com/docs/ko/errors.md#not-logged-in)을 참조하세요.

v2.1.211 이전에는 머신을 절전 모드에서 깨우면 두 세션이 같은 토큰으로 갱신될 수 있어서 저장된 로그인이 취소되고 모든 열린 세션이 한 번에 다시 로그인하도록 요청받았습니다.

macOS에서 Claude Code는 자격 증명을 로그인 Keychain에 저장합니다. Keychain이 쓰기를 거부할 때(예: SSH 세션에서 잠겨 있거나 암호가 계정 암호와 동기화되지 않은 경우) Claude Code는 대신 로그인을 일반 텍스트 `~/.claude/.credentials.json` 파일에 저장합니다. API 키를 생성하는 Console 로그인은 Keychain이 다시 쓰기 가능해질 때까지 실패합니다.

Keychain을 다시 쓰기 가능하게 만들고 로그인을 암호화된 Keychain으로 다시 이동하려면:

**1. Keychain 액세스 확인**

`claude doctor`를 실행하여 Keychain 액세스를 확인하세요. Keychain이 쓰기를 거부할 때 보고서는 `macOS Keychain is not writable`로 시작하는 경고를 나열하고 그 뒤에 제안된 수정 사항이 있습니다. 보고서에 Keychain 경고가 없으면 Keychain은 쓰기 가능하며 마지막 단계로 건너뛸 수 있습니다.

**2. Keychain 잠금 해제**

```bash theme={null}
security unlock-keychain ~/Library/Keychains/login.keychain-db
```

명령이 요청할 때 Keychain 암호를 입력한 다음 `claude doctor`를 다시 실행하세요. 잠금 해제가 작동했으면 보고서는 더 이상 Keychain 경고를 나열하지 않습니다.

**3. 잠금 해제가 도움이 되지 않으면 Keychain 암호 재동기화**

Keychain Access를 열고 `login` keychain을 선택한 다음 **편집 > Keychain "login"의 암호 변경**을 선택하여 계정 암호와 재동기화하세요. 그런 다음 `claude doctor`를 다시 실행하세요. 보고서에 더 이상 Keychain 경고가 없으면 다음 단계로 진행하세요.

**4. 로그아웃 후 다시 로그인**

Keychain이 다시 쓰기 가능해지면 Claude Code는 다음 번에 자격 증명을 쓸 때 자격 증명을 다시 Keychain으로 이동합니다. 지금 강제하려면 `/logout`을 실행한 다음 `/login`을 실행하세요. 로그아웃하면 일반 텍스트 파일의 내용, 저장된 MCP 서버 로그인 및 플러그인 민감한 값을 포함한 모든 저장된 자격 증명이 제거되므로 그 후에 MCP 서버를 다시 인증하고 플러그인 비밀을 다시 입력해야 합니다. 다시 로그인하면 Keychain에 로그인이 저장됩니다.

### Bedrock, Agent Platform 또는 Foundry 자격 증명이 로드되지 않음

Claude Code를 클라우드 공급자를 사용하도록 구성했고 Amazon Bedrock에서 `Could not load credentials from any providers`, Google Cloud의 Agent Platform에서 `Could not load the default credentials` 또는 Microsoft Foundry에서 `ChainedTokenCredential authentication failed`가 표시되면 클라우드 공급자 CLI가 현재 셸에서 인증되지 않았을 가능성이 높습니다.

Amazon Bedrock의 경우 AWS 자격 증명이 유효한지 확인하세요:

```bash theme={null}
aws sts get-caller-identity
```

Google Cloud의 Agent Platform의 경우 `ANTHROPIC_VERTEX_PROJECT_ID` 및 `CLOUD_ML_REGION`이 셸에 설정되어 있는지 확인한 다음 애플리케이션 기본 자격 증명을 설정하세요:

```bash theme={null}
gcloud auth application-default login
```

Microsoft Foundry의 경우 `ANTHROPIC_FOUNDRY_API_KEY`가 설정되어 있는지 확인하거나 Azure CLI로 로그인하여 기본 자격 증명 체인이 계정을 찾을 수 있도록 하세요:

```bash theme={null}
az login
```

자격 증명이 터미널에서 작동하지만 VS Code 또는 JetBrains 확장에서 작동하지 않으면 IDE 프로세스가 셸 환경을 상속하지 않았을 가능성이 높습니다. IDE의 자체 설정에서 공급자 환경 변수를 설정하거나 이미 내보낸 터미널에서 IDE를 시작하세요.

전체 공급자 설정은 [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md) 또는 [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md)를 참조하세요.

## 여전히 막혔습니다

위의 어느 것도 문제를 해결하지 못하면:

1. [GitHub 저장소](https://github.com/anthropics/claude-code/issues)에서 알려진 문제를 확인하거나 운영 체제, 실행한 설치 명령 및 전체 오류 출력과 함께 새 문제를 열어보세요
2. `claude --version`이 작동하지만 다른 것이 잘못되면 `claude doctor`를 실행하여 자동화된 진단 보고서를 받으세요
3. 세션을 시작할 수 있으면 Claude Code 내에서 `/feedback`을 사용하여 문제를 보고하세요
4. 설치 문제가 아니라 계정 문제인 경우(예: 로그인 루프, 인식되지 않는 구독 또는 비활성화된 조직)에는 Anthropic 지원팀에 문의하세요. [claude.ai](https://claude.ai)에 로그인하고(Console 사용자: [platform.claude.com](https://platform.claude.com)), 왼쪽 아래의 이니셜을 클릭한 후 **도움말 받기**를 선택하세요. 전체 절차는 [지원을 받는 방법](https://support.claude.com/en/articles/9015913-how-to-get-support)을 참조하세요.
