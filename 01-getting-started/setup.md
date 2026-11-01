> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 고급 설정

> Claude Code의 시스템 요구사항, 플랫폼별 설치, 버전 관리 및 제거.

이 페이지에서는 시스템 요구사항, 플랫폼별 설치 세부사항, 업데이트 및 제거에 대해 다룹니다. 첫 번째 세션의 단계별 안내는 [빠른 시작](https://code.claude.com/docs/ko/quickstart.md)을 참조하세요. 터미널을 처음 사용하는 경우 [터미널 가이드](https://code.claude.com/docs/ko/terminal-guide)를 참조하세요.

## 시스템 요구사항

Claude Code는 다음 플랫폼 및 구성에서 실행됩니다:

* **운영 체제**:
  * macOS 13.0+
  * Windows 10 1809+ 또는 Windows Server 2019+
  * Ubuntu 20.04+
  * Debian 10+
  * Alpine Linux 3.19+
* **하드웨어**: 4GB 이상 RAM, x64 또는 ARM64 프로세서
* **네트워크**: 인터넷 연결 필수. [네트워크 구성](https://code.claude.com/docs/ko/network-config.md#network-access-requirements)을 참조하세요.
* **셸**: Bash, Zsh, PowerShell 또는 CMD.
* **위치**: [Anthropic 지원 국가](https://www.anthropic.com/supported-countries)

### 추가 종속성

* **ripgrep**: 일반적으로 Claude Code에 포함됩니다. 검색이 실패하면 [검색 문제 해결](https://code.claude.com/docs/ko/troubleshooting.md#search-and-discovery-issues)을 참조하세요.

## Claude Code 설치

> [!TIP]
>
> 그래픽 인터페이스를 선호하시나요? [Desktop 앱](https://code.claude.com/docs/ko/desktop-quickstart.md)을 사용하면 터미널 없이 Claude Code를 사용할 수 있습니다. [macOS](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect?utm_source=claude_code\&utm_medium=docs), [Windows](https://claude.com/download?utm_source=claude_code\&utm_medium=docs) 또는 [Linux](https://code.claude.com/docs/ko/desktop-linux.md)용으로 다운로드하세요.

Claude Code를 설치하려면 터미널을 열고 시스템에 맞는 명령을 실행하십시오. 이전에 터미널을 사용해본 적이 없다면 [터미널 가이드](https://code.claude.com/docs/ko/terminal-guide)에서 터미널을 열고 명령을 붙여넣는 방법을 확인할 수 있습니다.

> [tab] 기본 설치 (권장)
>
> **macOS, Linux, WSL:**
>
> ```bash theme={null}
> curl -fsSL https://claude.ai/install.sh | bash
> ```
>
> Windows에서 PowerShell에 있을 때는 프롬프트에 `PS C:\`가 표시되고, CMD에 있을 때는 `PS` 없이 `C:\`만 표시됩니다.
>
> **Windows PowerShell:**
>
> ```powershell theme={null}
> irm https://claude.ai/install.ps1 | iex
> ```
>
> **Windows CMD:**
>
> ```batch theme={null}
> curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
> ```
>
> 설치 명령은 Claude Code를 다운로드하는 동안 진행 상황을 표시하지 않습니다. 설치 프로그램이 완료되면 새 터미널 창을 열고 `claude --version`을 실행하십시오. 설치가 제대로 되었으면 버전 번호가 출력됩니다. 셸에서 `claude`를 찾을 수 없거나 인식되지 않는다고 표시되면 설치 디렉토리가 아직 PATH에 없는 것입니다. [PATH 수정](https://code.claude.com/docs/ko/troubleshoot-install.md#command-not-found-claude-after-installation)을 참조하십시오.
>
> `The token '&&' is not a valid statement separator` 오류가 표시되면 CMD가 아닌 PowerShell에 있는 것입니다. `'irm' is not recognized as an internal or external command` 오류가 표시되면 PowerShell이 아닌 CMD에 있는 것입니다.
>
> 설치 명령이 `syntax error near unexpected token '<'`, `403` 또는 다른 오류로 실패하면 [설치 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#find-your-error)을 참조하여 오류를 수정 방법과 일치시키고 대체 설치 방법을 확인하십시오.
>
> [Git for Windows](https://git-scm.com/downloads/win)는 Claude Code가 Bash 도구를 사용할 수 있도록 기본 Windows에서 권장됩니다. Git for Windows가 설치되지 않은 경우 Claude Code는 대신 PowerShell을 셸 도구로 사용합니다. WSL 설정에는 Git for Windows가 필요하지 않습니다.
>
> > [!NOTE]
> >
> > 기본 설치는 최신 버전으로 유지하기 위해 백그라운드에서 자동으로 업데이트됩니다.

> [tab] Homebrew
>
> ```bash theme={null}
> brew install --cask claude-code
> ```
>
> Homebrew는 두 가지 cask를 제공합니다. `claude-code`는 안정적인 릴리스 채널을 추적하며, 일반적으로 약 1주일 뒤에 있고 주요 회귀가 있는 릴리스를 건너뜁니다. `claude-code@latest`는 최신 채널을 추적하고 새 버전이 출시되는 즉시 받습니다.
>
> > [!NOTE]
> >
> > Homebrew 설치는 자동으로 업데이트되지 않습니다. 설치한 cask에 따라 `brew upgrade claude-code` 또는 `brew upgrade claude-code@latest`를 실행하여 최신 기능 및 보안 수정 사항을 받으십시오.

> [tab] WinGet
>
> ```powershell theme={null}
> winget install Anthropic.ClaudeCode
> ```
>
> > [!NOTE]
> >
> > WinGet 설치는 자동으로 업데이트되지 않습니다. 최신 기능 및 보안 수정 사항을 받으려면 주기적으로 `winget upgrade Anthropic.ClaudeCode`를 실행하십시오.

또한 Debian, Fedora, RHEL 및 Alpine에서 [apt, dnf 또는 apk](https://code.claude.com/docs/ko/setup.md#install-with-linux-package-managers)로 설치할 수 있습니다.

설치가 완료된 후 작업하려는 프로젝트에서 터미널을 열고 Claude Code를 시작하세요:

```bash theme={null}
claude
```

Claude Code는 터미널에서 대화형 세션을 엽니다.

설치 중에 문제가 발생하면 [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md)을 참조하세요.

### Windows에서 설정

Claude Code를 Windows에서 기본적으로 실행하거나 WSL 내에서 실행할 수 있습니다. 프로젝트가 위치한 곳과 필요한 기능을 기반으로 선택하세요:

| 옵션 | 필요 사항 | [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md) | 사용 시기 |
| - | - | - | - |
| [네이티브 Windows](#install-on-native-windows) | 없음; [Git for Windows](https://git-scm.com/downloads/win)는 선택 사항 | 지원되지 않음 | Windows 기본 프로젝트 및 도구 |
| [WSL 2](#install-in-wsl) | WSL 2 활성화 | 지원됨 | Linux 도구 체인 또는 샌드박싱된 명령 실행 |
| [WSL 1](#install-in-wsl) | WSL 1 활성화 | 지원되지 않음 | WSL 2를 사용할 수 없는 경우 |

#### 네이티브 Windows에 설치

PowerShell 또는 CMD에서 [설치 명령](#install-claude-code)을 실행하세요. 관리자로 실행할 필요가 없습니다. [Git for Windows](https://git-scm.com/downloads/win) 설치는 선택 사항입니다. 이는 [Bash 도구](https://code.claude.com/docs/ko/tools-reference.md#bash-tool-behavior)와 [Monitor 도구](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool)에 필요한 Git Bash를 제공합니다.

PowerShell 또는 CMD에서 설치하는지 여부는 실행하는 설치 명령에만 영향을 줍니다. 프롬프트는 PowerShell에서 `PS C:\Users\YourName>`을 표시하고 CMD에서는 `PS` 없이 `C:\Users\YourName>`을 표시합니다. 터미널이 처음이라면 [터미널 가이드](https://code.claude.com/docs/ko/terminal-guide#windows)에서 각 단계를 안내합니다.

설치 후 모든 터미널에서 `claude`를 실행하세요.

* **Git for Windows 없음**, Claude Code는 [PowerShell 도구](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool)를 통해 셸 명령을 실행합니다.
* **Git for Windows 포함**, Claude Code는 [Bash 도구](https://code.claude.com/docs/ko/tools-reference.md#bash-tool-behavior)에 Git Bash를 사용합니다. Claude Code가 Git Bash를 찾을 수 없으면 [settings.json 파일](https://code.claude.com/docs/ko/settings.md)에서 경로를 설정하세요:

  ```json theme={null}
  {
    "env": {
      "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe"
    }
  }
  ```

Git for Windows가 설치되면 PowerShell 도구는 Bash와 함께 사용 가능합니다: claude.ai 및 Console 계정의 경우 기본적으로 활성화되며, Amazon Bedrock, Google Cloud의 Agent Platform 및 Microsoft Foundry 세션에서는 `CLAUDE_CODE_USE_POWERSHELL_TOOL=1`로 활성화됩니다. 도구를 끄려면 `0`으로 설정하세요. 설정 및 제한사항은 [PowerShell 도구](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool)를 참조하세요.

#### WSL에 설치

WSL 배포판을 열고 [설치 지침](#install-claude-code)에서 Linux 설치 프로그램을 실행하세요. PowerShell 또는 CMD가 아닌 WSL 터미널 내에서 `claude`를 설치하고 실행합니다.

### Alpine Linux 및 musl 기반 배포판

Alpine 및 기타 musl/uClibc 기반 배포판에 Claude Code를 설치하려면 설치 명령을 위해 `bash` 및 `curl`이 필요하며, 런타임에는 `libgcc`, `libstdc++` 및 `ripgrep`이 필요합니다. Alpine은 기본적으로 `bash` 또는 `curl`을 포함하지 않으므로 문서화된 설치 명령은 이들을 설치할 때까지 `not found` 오류로 실패합니다. 배포판의 패키지 관리자를 사용하여 이들 패키지를 설치한 후 `USE_BUILTIN_RIPGREP=0`을 설정하세요.

이 예제는 Alpine에 필요한 패키지를 설치합니다:

```bash theme={null}
apk add bash curl libgcc libstdc++ ripgrep
```

Alpine에서 `ripgrep`은 커뮤니티 저장소에 있습니다. `apk`가 패키지가 누락되었다고 보고하면 Alpine 버전을 사용하여 `/etc/apk/repositories`에 커뮤니티 저장소를 추가하세요:

```bash theme={null}
echo "https://dl-cdn.alpinelinux.org/alpine/v3.22/community" >> /etc/apk/repositories
```

`apk update`를 실행하여 패키지 인덱스를 새로 고친 후 `apk add` 명령을 다시 시도하세요.

그런 다음 [`settings.json`](https://code.claude.com/docs/ko/settings-reference#all-settings) 파일에서 `USE_BUILTIN_RIPGREP`을 `0`으로 설정하세요:

```json theme={null}
{
  "env": {
    "USE_BUILTIN_RIPGREP": "0"
  }
}
```

## 설치 확인

설치 후 Claude Code가 작동하는지 확인하세요:

```bash theme={null}
claude --version
```

작동하는 설치는 `2.1.211 (Claude Code)`와 같은 버전 번호를 출력합니다.

이 명령이 `command not found` 또는 다른 오류로 실패하면 [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md)을 참조하세요.

설치 및 구성을 더 자세히 확인하려면 [`claude doctor`](https://code.claude.com/docs/ko/troubleshooting#get-more-help)를 실행하세요:

```bash theme={null}
claude doctor
```

`claude doctor`는 세션을 시작하지 않고 읽기 전용 설치 및 설정 진단을 출력합니다. 여기에는 설치 상태, 설정 파일 검증 오류, 그리고 제안된 수정 사항이 포함된 모든 경고가 포함됩니다.

## 인증

Claude Code는 Pro, Max, Ultra, Team, Enterprise 또는 Console 계정이 필요합니다. 무료 claude.ai 플랜에는 Claude Code 액세스가 포함되지 않습니다. [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md) 또는 [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md)와 같은 타사 API 제공자와 함께 Claude Code를 사용할 수도 있습니다.

설치 후 `claude`를 실행하고 브라우저 프롬프트를 따라 로그인하세요. `ANTHROPIC_API_KEY` 환경 변수가 설정되어 있고 Claude Code가 해당 키를 사용할지 물을 때 키를 승인하면, Claude Code는 로그인 프롬프트를 건너뜁니다. 모든 계정 유형 및 팀 설정 옵션은 [인증](https://code.claude.com/docs/ko/authentication.md)을 참조하세요.

## Claude Code 업데이트

네이티브 설치는 백그라운드에서 자동으로 업데이트됩니다. [릴리스 채널을 구성](#configure-release-channel)하여 즉시 업데이트를 받을지 또는 지연된 안정적인 일정으로 받을지 제어하거나, [자동 업데이트를 비활성화](#disable-auto-updates)할 수 있습니다. Homebrew, WinGet 및 [Linux 패키지 관리자](#install-with-linux-package-managers) 설치는 기본적으로 수동 업데이트가 필요합니다.

### 자동 업데이트

Claude Code는 시작 시 및 실행 중에 주기적으로 업데이트를 확인합니다. 업데이트는 백그라운드에서 다운로드 및 설치되며 다음 번에 Claude Code를 시작할 때 적용됩니다.

셸에서 `claude doctor`를 실행하면 Claude Code가 기록한 마지막 업데이트 시도의 결과를 확인할 수 있습니다. 네이티브 설치에서 실패한 시도가 보고되면 다음에 수행할 작업은 [세션 푸터의 `Auto-update failed`](https://code.claude.com/docs/ko/troubleshoot-install#auto-update-failed)를 참조하세요.

macOS 및 Linux에서 네이티브 설치 프로그램은 `~/.local/bin/claude`의 런처를 `~/.local/share/claude/versions/`로의 심볼릭 링크로 관리합니다. 해당 런처를 자신의 스크립트 또는 심볼릭 링크로 바꾸면 자동 업데이트 및 `claude update`는 이를 제자리에 그대로 둡니다. 새 버전은 여전히 `versions/` 디렉터리 아래에 설치되며 런처가 실행할 버전을 결정합니다.

사용자 정의 런처를 사용하면 Claude Code는 런처가 필요한 버전을 알 수 없기 때문에 설치된 모든 버전을 디스크에 유지합니다. `claude doctor`는 네이티브 설치 프로그램이 만들지 않은 런처를 보고합니다.

Claude Code가 런처를 다시 관리하도록 하려면 `~/.local/bin/claude`를 제거하고 `claude update`를 실행하세요.

npm 전역 설치가 npm 전역 디렉터리를 쓸 수 없기 때문에 자동 업데이트할 수 없는 경우, Claude Code는 시작 시 일회성 알림을 표시하고 `claude doctor`는 사용 가능한 수정 사항을 나열합니다. 자세한 내용은 [설치 중 권한 오류](https://code.claude.com/docs/ko/troubleshoot-install.md#permission-errors-during-installation)를 참조하세요.

> [!NOTE]
>
> Homebrew, WinGet, apt, dnf 및 apk 설치는 기본적으로 자동으로 업데이트되지 않습니다. Homebrew 및 WinGet에 대해 옵트인하려면 아래를 참조하세요. Homebrew를 수동으로 업그레이드하려면 설치한 cask에 따라 `brew upgrade claude-code` 또는 `brew upgrade claude-code@latest`를 실행하세요. WinGet의 경우 `winget upgrade Anthropic.ClaudeCode`를 실행하세요. Linux 패키지 관리자의 경우 [Linux 패키지 관리자로 설치](#install-with-linux-package-managers)의 업그레이드 명령을 참조하세요.
>
> Claude Code가 Homebrew 또는 WinGet에서 업그레이드 명령을 실행하도록 하려면 [`CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE`](https://code.claude.com/docs/ko/env-vars)를 `1`로 설정하세요. Claude Code는 새 버전을 사용할 수 있을 때 백그라운드에서 업그레이드를 실행하고 성공 시 재시작 프롬프트를 표시합니다. 업그레이드는 Claude Code 패키지만 대상으로 하며 설치한 다른 소프트웨어에는 영향을 주지 않습니다.
>
> WinGet에서는 Claude Code가 실행 중일 때 Windows가 실행 파일을 잠그기 때문에 업그레이드가 실패할 수 있습니다. 이 경우 Claude Code는 수동 명령을 대신 표시합니다. apt, dnf 및 apk는 이러한 명령이 상승된 권한이 필요하기 때문에 계속 수동 업그레이드가 필요합니다.
>
> **알려진 문제:** Claude Code는 새 버전이 이러한 패키지 관리자에서 사용 가능하기 전에 업데이트를 알릴 수 있습니다. 업그레이드가 실패하면 잠시 기다렸다가 나중에 다시 시도하세요.
>
> Homebrew는 업그레이드 후 디스크에 이전 버전을 유지합니다. 디스크 공간을 확보하려면 주기적으로 `brew cleanup`을 실행하세요.

### 릴리스 채널 구성

`autoUpdatesChannel` 설정으로 Claude Code가 자동 업데이트 및 `claude update`에 대해 따르는 릴리스 채널을 제어하세요:

* `"latest"`, 기본값: 새 기능이 릴리스되는 즉시 받기
* `"stable"`: 일반적으로 약 1주일 된 버전을 사용하여 주요 회귀가 있는 릴리스 건너뛰기

이를 `/config` → **자동 업데이트 채널**을 통해 구성하거나 [settings.json 파일](https://code.claude.com/docs/ko/settings.md)에 추가하세요:

```json theme={null}
{
  "autoUpdatesChannel": "stable"
}
```

새로 출시된 모델은 stable 채널이 제공하는 버전보다 새로운 Claude Code 버전을 요구할 수 있습니다. 해당 모델을 바로 실행하려면 latest 채널로 전환하세요.

엔터프라이즈 배포의 경우 [관리 설정](https://code.claude.com/docs/ko/managed-settings.md)을 사용하여 조직 전체에서 일관된 릴리스 채널을 적용할 수 있습니다.

Homebrew 설치는 이 설정 대신 cask 이름으로 채널을 선택합니다: `claude-code`는 안정적인 버전을 추적하고 `claude-code@latest`는 최신 버전을 추적합니다.

apt, dnf 및 apk 저장소에서 설치한 경우 이 설정 대신 저장소로 채널을 선택합니다. 채널을 전환하려면 [Linux 패키지 관리자로 설치](#install-with-linux-package-managers)를 따르세요.

### 최소 버전 고정

`minimumVersion` 설정은 하한을 설정합니다. 백그라운드 자동 업데이트 및 `claude update`는 이 값 이하의 버전 설치를 거부하므로 `"stable"` 채널로 이동해도 이미 최신 `"latest"` 빌드에 있는 경우 다운그레이드되지 않습니다.

`/config`를 통해 `"latest"`에서 `"stable"`로 전환하면 현재 버전을 유지하거나 다운그레이드를 허용하라는 메시지가 표시됩니다. 현재 버전을 유지하도록 선택하면 `minimumVersion`이 해당 버전으로 설정됩니다. `"latest"`로 다시 전환하면 이를 지웁니다.

[settings.json 파일](https://code.claude.com/docs/ko/settings.md)에 추가하여 하한을 명시적으로 고정하세요:

```json theme={null}
{
  "autoUpdatesChannel": "stable",
  "minimumVersion": "2.1.100"
}
```

[관리 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 이는 사용자 및 프로젝트 설정이 재정의할 수 없는 조직 전체 최소값을 적용합니다.

`minimumVersion` 핀은 업데이트만 제한합니다. Claude Code가 버전 범위 외에서 시작되지 않도록 하려면 관리 설정 `requiredMinimumVersion` 및 `requiredMaximumVersion`을 대신 사용하세요. 업데이트는 또한 `requiredMaximumVersion` 상한을 준수합니다. [`requiredMinimumVersion`](https://code.claude.com/docs/ko/settings-reference#requiredminimumversion) 및 [`requiredMaximumVersion`](https://code.claude.com/docs/ko/settings-reference#requiredmaximumversion)을 참조하세요.

### 자동 업데이트 비활성화

[`settings.json`](https://code.claude.com/docs/ko/settings-reference#all-settings) 파일의 `env` 키에서 `DISABLE_AUTOUPDATER`를 `"1"`로 설정하세요:

```json theme={null}
{
  "env": {
    "DISABLE_AUTOUPDATER": "1"
  }
}
```

네이티브 또는 npm 설치에서 `claude doctor`를 실행하고 `Auto-updates` 줄이 `enabled` 대신 `disabled (set by env: DISABLE_AUTOUPDATER)`를 표시하는지 확인하여 변경 사항이 적용되었는지 확인하세요.

`DISABLE_AUTOUPDATER`는 백그라운드 확인만 중지합니다. `claude update` 및 `claude install`은 계속 작동합니다. 수동 업데이트를 포함한 모든 업데이트 경로를 차단하려면 [`DISABLE_UPDATES`](https://code.claude.com/docs/ko/env-vars)를 대신 설정하세요. Claude Code를 자신의 채널을 통해 배포하고 사용자가 제공하는 버전에 머물러야 할 때 이를 사용하세요.

### 수동으로 업데이트

다음 백그라운드 확인을 기다리지 않고 즉시 업데이트를 적용하려면 다음을 실행하세요:

```bash theme={null}
claude update
```

업데이트가 설치되면 명령은 `Successfully updated from <old version> to version <new version>`을 보고합니다. 이미 최신 버전을 사용 중인 경우 `Claude Code is up to date (<version>)`을 보고합니다. Homebrew, WinGet 또는 apk로 관리되는 설치는 `Claude is up to date!`를 대신 보고합니다.

## 고급 설치 옵션

이러한 옵션은 버전 고정, Linux 패키지 관리자, npm, 네트워크 스토리지 및 바이너리 무결성 확인을 위한 것입니다.

### 특정 버전 설치

네이티브 설치 프로그램은 특정 버전 번호 또는 릴리스 채널(`latest` 또는 `stable`)을 허용합니다. 설치 시 선택한 채널이 자동 업데이트의 기본값이 됩니다. 자세한 내용은 [릴리스 채널 구성](#configure-release-channel)을 참조하세요.

최신 버전을 설치하려면(기본값):

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> curl -fsSL https://claude.ai/install.sh | bash
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> irm https://claude.ai/install.ps1 | iex
> ```

> [tab] Windows CMD
>
> ```batch theme={null}
> curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
> ```

안정적인 버전을 설치하려면:

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> curl -fsSL https://claude.ai/install.sh | bash -s stable
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> & ([scriptblock]::Create((irm https://claude.ai/install.ps1))) stable
> ```

> [tab] Windows CMD
>
> ```batch theme={null}
> curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd stable && del install.cmd
> ```

특정 버전 번호를 설치하려면:

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> curl -fsSL https://claude.ai/install.sh | bash -s 2.1.89
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> & ([scriptblock]::Create((irm https://claude.ai/install.ps1))) 2.1.89
> ```

> [tab] Windows CMD
>
> ```batch theme={null}
> curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd 2.1.89 && del install.cmd
> ```

설치된 버전을 확인하려면 `claude --version`을 실행하세요. 이 명령은 전달한 정확한 버전(예: `2.1.89 (Claude Code)`)을 출력합니다.

### Linux 패키지 관리자로 설치

Claude Code는 서명된 apt, dnf 및 apk 저장소를 게시합니다. 각 저장소는 두 가지 채널을 제공합니다. `stable`은 일반적으로 약 1주일 된 버전을 제공하며 주요 회귀가 있는 릴리스를 건너뛰고, `latest`는 모든 릴리스를 출시되는 즉시 제공합니다. 아래 명령은 대부분의 사용자에게 적합한 `stable` 채널을 구성합니다. 각 탭에는 `latest` 저장소 URL도 표시됩니다. 패키지 관리자 설치는 Claude Code를 통해 자동 업데이트되지 않습니다. 업데이트는 일반적인 시스템 업그레이드 워크플로우를 통해 제공됩니다.

모든 저장소는 [Claude Code 릴리스 서명 키](#binary-integrity-and-code-signing)로 서명됩니다. 키를 신뢰하기 전에 각 탭에 설명된 대로 확인하세요.

> [tab] apt
>
> Debian 및 Ubuntu용입니다. 아래의 설치 명령은 `curl`로 서명 키를 다운로드하고 `gpg`로 확인합니다. 새로운 Debian 및 Ubuntu 설치에는 이 중 하나가 포함되지 않을 수 있습니다. 명령이 `command not found`를 보고하면 먼저 둘 다 설치하세요:
>
> ```bash theme={null}
> sudo apt install curl gnupg
> ```
>
> 서명 키를 다운로드합니다:
>
> ```bash theme={null}
> sudo install -d -m 0755 /etc/apt/keyrings
> sudo curl -fsSL https://downloads.claude.ai/keys/claude-code.asc \
>   -o /etc/apt/keyrings/claude-code.asc
> ```
>
> 이 다운로드가 실패하면 나중에 `apt update`가 `NO_PUBKEY BAA929FF1A7ECACE`로 실패합니다. 키가 다운로드되었고 계속하기 전에 Anthropic에 속하는지 확인하세요:
>
> ```bash theme={null}
> gpg --show-keys /etc/apt/keyrings/claude-code.asc
> ```
>
> gpg가 인쇄하는 지문은 `31DDDE24DDFAB679F42D7BD2BAA929FF1A7ECACE`여야 합니다. gpg가 파일을 열 수 없거나 유효한 OpenPGP 데이터가 없다고 보고하면 다운로드가 실패했거나 잘못된 콘텐츠를 반환했습니다. 네트워크가 `downloads.claude.ai`에 도달할 수 있는지 확인한 후 다운로드 명령을 다시 실행하세요.
>
> `stable` 채널에 저장소를 등록하고 설치합니다:
>
> ```bash theme={null}
> echo "deb [signed-by=/etc/apt/keyrings/claude-code.asc] https://downloads.claude.ai/claude-code/apt/stable stable main" \
>   | sudo tee /etc/apt/sources.list.d/claude-code.list
> sudo apt update
> sudo apt install claude-code
> ```
>
> 대신 `latest` 채널을 사용하려면 URL 경로와 제품군 이름이 모두 변경됩니다. 이 `deb` 줄을 사용하세요:
>
> ```bash theme={null}
> echo "deb [signed-by=/etc/apt/keyrings/claude-code.asc] https://downloads.claude.ai/claude-code/apt/latest latest main" \
>   | sudo tee /etc/apt/sources.list.d/claude-code.list
> ```
>
> 나중에 업그레이드하려면 `sudo apt update && sudo apt upgrade claude-code`를 실행하세요.

> [tab] dnf
>
> Fedora 및 RHEL용입니다. 다음 명령은 `stable` 채널을 구성합니다:
>
> ```bash theme={null}
> sudo tee /etc/yum.repos.d/claude-code.repo <<'EOF'
> [claude-code]
> name=Claude Code
> baseurl=https://downloads.claude.ai/claude-code/rpm/stable
> enabled=1
> gpgcheck=1
> gpgkey=https://downloads.claude.ai/keys/claude-code.asc
> EOF
> sudo dnf install claude-code
> ```
>
> 대신 `latest` 채널을 사용하려면 `baseurl`을 `latest` 저장소로 설정하세요:
>
> ```ini theme={null}
> baseurl=https://downloads.claude.ai/claude-code/rpm/latest
> ```
>
> dnf는 첫 설치 시 키를 다운로드하고 지문을 확인하도록 요청합니다. `31DD DE24 DDFA B679 F42D 7BD2 BAA9 29FF 1A7E CACE`와 일치하는지 확인한 후 수락하세요.
>
> 나중에 업그레이드하려면 `sudo dnf upgrade claude-code`를 실행하세요.

> [tab] apk
>
> Alpine Linux용입니다. 다음 명령은 `stable` 채널을 구성합니다:
>
> ```sh theme={null}
> wget -O /etc/apk/keys/claude-code.rsa.pub \
>   https://downloads.claude.ai/keys/claude-code.rsa.pub
> echo "https://downloads.claude.ai/claude-code/apk/stable" >> /etc/apk/repositories
> apk add claude-code
> ```
>
> `latest` 채널로 전환하려면 `stable` 저장소 줄을 제거하고 `latest` 저장소를 추가하세요:
>
> ```sh theme={null}
> sed -i '\|downloads.claude.ai/claude-code/apk/stable|d' /etc/apk/repositories
> echo "https://downloads.claude.ai/claude-code/apk/latest" >> /etc/apk/repositories
> ```
>
> `sha256sum /etc/apk/keys/claude-code.rsa.pub`로 다운로드한 키를 확인하세요. 이는 `395759c1f7449ef4cdef305a42e820f3c766d6090d142634ebdb049f113168b6`을 보고해야 합니다.
>
> 나중에 업그레이드하려면 `apk update && apk upgrade claude-code`를 실행하세요.

### npm으로 설치

> [!NOTE]
>
> 셸에서 `npm --version`이 `12`로 시작하는 버전을 출력하면 대신 [npm 12 설치 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#fix-an-npm-12-install)을 따르세요. `sudo`로 설치하지 마세요. Claude Code는 자체 업데이트 시 `sudo` 없이 npm을 실행하므로, `sudo`가 필요한 설치는 자동으로 업데이트될 수 없습니다.

Claude Code를 전역 npm 패키지로 설치할 수도 있습니다. npm 패키지에는 [Node.js 22 이상](https://nodejs.org/en/download)이 필요합니다. 이전 Node.js 버전에서는 npm이 설치 중에 실패하는 대신 `EBADENGINE` 경고를 인쇄합니다. 설치가 완료되고 `claude`는 여전히 실행됩니다. 패키지가 런타임에 Node.js를 사용하지 않는 네이티브 바이너리를 다운로드하기 때문입니다.

```bash theme={null}
npm install -g @anthropic-ai/claude-code
```

npm 패키지는 독립 실행형 설치 프로그램과 동일한 네이티브 바이너리를 설치합니다. npm은 `@anthropic-ai/claude-code-darwin-arm64`와 같은 플랫폼별 선택적 종속성을 통해 바이너리를 가져오고 설치 후 단계가 이를 제자리에 연결합니다. 설치된 `claude` 바이너리는 자체적으로 Node를 호출하지 않습니다.

지원되는 npm 설치 플랫폼은 `darwin-arm64`, `darwin-x64`, `linux-x64`, `linux-arm64`, `linux-x64-musl`, `linux-arm64-musl`, `win32-x64` 및 `win32-arm64`입니다. 패키지 관리자는 선택적 종속성을 허용해야 합니다. 설치 후 바이너리가 누락된 경우 [문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#native-binary-not-found-after-npm-install)을 참조하세요.

npm 설치를 업그레이드하려면 `npm install -g @anthropic-ai/claude-code@latest`를 실행하세요. `npm update -g`는 원래 설치의 semver 범위를 존중하며 최신 릴리스로 이동하지 않을 수 있으므로 피하세요.

> [!WARNING]
>
> `sudo npm install -g`를 사용하지 마세요. 이는 권한 문제 및 보안 위험으로 이어질 수 있습니다. 권한 오류가 발생하면 [설치 중 권한 오류 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#permission-errors-during-installation)을 참조하세요.

### 네트워크 스토리지에 설치

실행 중인 세션은 시작 시뿐만 아니라 작업하는 동안에도 Claude Code 실행 파일의 일부를 디스크에서 읽습니다. 세션 도중 파일을 읽을 수 없게 되면(예: 네트워크 스토리지에서 파일이 잘리거나 삭제된 경우) 세션이 중단됩니다. Linux에서는 셸이 이를 `Bus error`로 보고합니다.

여러 머신에 마운트된 NFS 홈처럼 홈 디렉터리가 네트워크 스토리지에 있는 경우, 각 세션의 실행 파일이 세션이 끝날 때까지 읽기 가능한 상태로 유지되도록 설치를 구성하세요:

* **로컬 디스크에 설치**: 예를 들어 [Linux 패키지 관리자](#install-with-linux-package-managers)나 자체 배포 도구를 사용하여 각 머신의 로컬 파일 시스템에 바이너리를 배치하세요. 사용자별 npm prefix와 네이티브 설치 프로그램의 기본 `~/.local/share/claude/versions/` 디렉터리는 모두 홈 디렉터리에 위치합니다.
* **각 버전을 별도의 디렉터리에 보관**: `npm install -g`로 npm 설치를 제자리에서 업그레이드하면 이전 바이너리가 삭제됩니다. 여러 머신이 공유하는 스토리지에서는 이로 인해 다른 머신의 세션이 여전히 실행 중인 파일이 제거됩니다. 새 버전은 각각 기존 버전 옆에 설치하고 사용자를 새 버전으로 옮기세요.
* **어떤 머신에서도 실행 중일 가능성이 없을 때만 이전 버전 삭제**: 머신은 다른 머신에서 실행 중인 프로세스를 볼 수 없으므로, 삭제하기 전에 실행 중인 프로세스를 확인하는 것만으로는 충분하지 않습니다.
* **Claude Code 자체 업데이트 끄기**: [`DISABLE_UPDATES`](https://code.claude.com/docs/ko/env-vars)를 설정하고 자체 도구로 새 버전을 설치하세요. 그렇지 않으면 한 머신에서 npm 설치의 자동 업데이트가 동일한 제자리 업그레이드를 실행하여 다른 머신의 세션이 실행 중인 바이너리를 제거합니다. 사용자가 여전히 `claude update` 및 `claude install`을 실행할 수 있으므로 `DISABLE_AUTOUPDATER`만 설정하는 것으로는 충분하지 않습니다. [자동 업데이트 비활성화](#disable-auto-updates)를 참조하세요.

네이티브 설치 프로그램은 `~/.local/share/claude/versions/`에서 이전 버전을 자체적으로 삭제하며, 이는 해당 디렉터리가 공유 스토리지에 있을 때 중요합니다. 런처가 가리키는 버전과 같은 머신의 세션이 실행 중인 버전 외에, 최신 버전 두 개를 유지하고 나머지는 삭제합니다. 다른 머신에서 삭제된 버전을 실행 중인 세션은 바이너리를 잃게 됩니다. [사용자 지정 런처](#auto-updates)를 사용하면 Claude Code는 설치된 모든 버전을 유지하고 정리는 사용자에게 맡깁니다.

### 바이너리 무결성 및 코드 서명

각 릴리스는 모든 플랫폼 바이너리에 대한 SHA256 체크섬을 포함하는 `manifest.json`을 게시합니다. 매니페스트는 Anthropic GPG 키로 서명되므로 매니페스트의 서명을 확인하면 이것이 나열하는 모든 바이너리를 전이적으로 확인합니다.

#### 매니페스트 서명 확인

단계 1-3에는 `gpg` 및 `curl`이 있는 POSIX 셸이 필요합니다. Windows에서는 Git Bash 또는 WSL에서 실행하세요. 단계 4에는 PowerShell 옵션이 포함됩니다.

**1. 공개 키 다운로드 및 가져오기**

릴리스 서명 키는 고정 URL에 게시됩니다.

```bash theme={null}
curl -fsSL https://downloads.claude.ai/keys/claude-code.asc | gpg --import
```

가져온 키의 지문을 표시합니다.

```bash theme={null}
gpg --fingerprint security@anthropic.com
```

출력에 이 지문이 포함되어 있는지 확인하세요:

```text theme={null}
31DD DE24 DDFA B679 F42D  7BD2 BAA9 29FF 1A7E CACE
```

**2. 매니페스트 및 서명 다운로드**

`VERSION`을 확인하려는 릴리스로 설정하세요.

```bash theme={null}
REPO=https://downloads.claude.ai/claude-code-releases
VERSION=2.1.89
curl -fsSLO "$REPO/$VERSION/manifest.json"
curl -fsSLO "$REPO/$VERSION/manifest.json.sig"
```

**3. 서명 확인**

매니페스트에 대해 분리된 서명을 확인합니다.

```bash theme={null}
gpg --verify manifest.json.sig manifest.json
```

유효한 결과는 `Good signature from "Anthropic Claude Code Release Signing <security@anthropic.com>"`을 보고합니다.

`gpg`는 또한 새로 가져온 키에 대해 `WARNING: This key is not certified with a trusted signature!`을 인쇄합니다. 이는 예상된 것입니다. `Good signature` 줄은 암호화 확인이 통과했음을 확인합니다. 단계 1의 지문 비교는 키 자체가 진정함을 확인합니다.

**4. 바이너리를 매니페스트와 비교**

현재 디렉터리의 `claude` 바이너리의 SHA256 체크섬을 `manifest.json`의 `platforms.<platform>.checksum` 아래에 나열된 값과 비교합니다. 설치된 네이티브 바이너리를 대신 확인하려면 `~/.local/share/claude/versions/VERSION`에 대해 명령을 실행하고 VERSION을 단계 2에서 설정한 릴리스로 바꾸세요.

> [tab] Linux
>
> ```bash theme={null}
> sha256sum claude
> ```

> [tab] macOS
>
> ```bash theme={null}
> shasum -a 256 claude
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> (Get-FileHash claude.exe -Algorithm SHA256).Hash.ToLower()
> ```

> [!NOTE]
>
> 매니페스트 서명은 `2.1.89` 이상의 릴리스에 사용 가능합니다. 이전 릴리스는 분리된 서명 없이 `manifest.json`에 체크섬을 게시합니다.

#### 플랫폼 코드 서명

서명된 매니페스트 외에도 개별 바이너리는 지원되는 플랫폼에서 플랫폼 기본 코드 서명을 수행합니다.

* **macOS**: "Anthropic PBC"에서 서명하고 Apple에서 공증합니다. `codesign --verify --verbose ./claude`로 확인하세요.
* **Windows**: "Anthropic, PBC"에서 서명합니다. `Get-AuthenticodeSignature .\claude.exe`로 확인하세요.
* **Linux**: 바이너리는 개별적으로 코드 서명되지 않습니다. `claude-code-releases` 버킷에서 직접 다운로드하거나 네이티브 설치 프로그램을 사용하는 경우 위의 매니페스트 서명으로 무결성을 확인하세요. [apt, dnf 또는 apk](#install-with-linux-package-managers)로 설치하는 경우 패키지 관리자가 저장소 서명 키를 사용하여 서명을 자동으로 확인합니다.

## Claude Code 제거

Claude Code를 제거하려면 설치 방법에 따른 지침을 따르세요. 제거 후에도 `claude`가 계속 실행되면 두 번째 설치 또는 이전 설치 프로그램의 남은 셸 별칭이 있을 가능성이 높습니다. [충돌하는 설치 확인](https://code.claude.com/docs/ko/troubleshoot-install.md#check-for-conflicting-installations)을 참조하여 이를 찾아 제거하세요.

### 네이티브 설치 제거

Claude Code 바이너리 및 버전 파일을 제거하세요:

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> rm -f ~/.local/bin/claude
> rm -rf ~/.local/share/claude
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> Remove-Item -Path "$env:USERPROFILE\.local\bin\claude.exe" -Force
> Remove-Item -Path "$env:USERPROFILE\.local\share\claude" -Recurse -Force
> ```

### Homebrew로 제거

설치한 Homebrew cask를 제거하세요. 안정적인 cask를 설치한 경우:

```bash theme={null}
brew uninstall --cask claude-code
```

최신 cask를 설치한 경우:

```bash theme={null}
brew uninstall --cask claude-code@latest
```

### WinGet으로 제거

WinGet 패키지를 제거하세요:

```powershell theme={null}
winget uninstall Anthropic.ClaudeCode
```

### apt, dnf 또는 apk로 제거

패키지 및 저장소 구성을 제거하세요:

> [tab] apt
>
> ```bash theme={null}
> sudo apt remove claude-code
> sudo rm /etc/apt/sources.list.d/claude-code.list /etc/apt/keyrings/claude-code.asc
> ```

> [tab] dnf
>
> ```bash theme={null}
> sudo dnf remove claude-code
> sudo rm /etc/yum.repos.d/claude-code.repo
> ```

> [tab] apk
>
> ```sh theme={null}
> apk del claude-code
> sed -i '\|downloads.claude.ai/claude-code/apk|d' /etc/apk/repositories
> rm /etc/apk/keys/claude-code.rsa.pub
> ```

### npm으로 제거

전역 npm 패키지를 제거하세요:

```bash theme={null}
npm uninstall -g @anthropic-ai/claude-code
```

### 구성 파일 제거

> [!WARNING]
>
> 구성 파일을 제거하면 모든 설정, 허용된 도구, MCP 서버 구성 및 세션 기록이 삭제됩니다.

VS Code 확장 프로그램, JetBrains 플러그인 및 Desktop 앱도 `~/.claude/`에 씁니다. 이들 중 하나라도 여전히 설치되어 있으면 다음 실행 시 디렉토리가 다시 생성됩니다. Claude Code를 완전히 제거하려면 이 파일을 삭제하기 전에 [VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md#uninstall-the-extension), JetBrains 플러그인 및 Desktop 앱을 제거하세요.

Claude Code 설정 및 캐시된 데이터를 제거하려면:

> [tab] macOS, Linux, WSL
>
> ```bash theme={null}
> # 사용자 설정 및 상태 제거
> rm -rf ~/.claude
> rm ~/.claude.json
>
> # 프로젝트별 설정 제거(프로젝트 디렉토리에서 실행)
> rm -rf .claude
> rm -f .mcp.json
> ```

> [tab] Windows PowerShell
>
> ```powershell theme={null}
> # 사용자 설정 및 상태 제거
> Remove-Item -Path "$env:USERPROFILE\.claude" -Recurse -Force
> Remove-Item -Path "$env:USERPROFILE\.claude.json" -Force
>
> # 프로젝트별 설정 제거(프로젝트 디렉토리에서 실행)
> Remove-Item -Path ".claude" -Recurse -Force
> Remove-Item -Path ".mcp.json" -Force
> ```
