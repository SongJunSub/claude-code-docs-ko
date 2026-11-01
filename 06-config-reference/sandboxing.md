> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 샌드박스 Bash 도구 구성

> 기본 제공 샌드박스로 Claude Code의 셸 명령이 접근할 수 있는 파일과 네트워크 호스트를 제한합니다. 샌드박스를 켜고, 경계를 설정하고, 샌드박스로 인해 발생하는 문제를 해결합니다.

Bash 샌드박스는 Claude가 사용자의 머신에서 실행하는 셸 명령 주위에 운영 체제가 적용하는 경계입니다. 이러한 명령이 접근할 수 있는 파일과 네트워크 도메인을 설정할 수 있으며, 이 제한은 Bash, PowerShell, Monitor 명령과 이들이 시작하는 프로세스에 적용됩니다. 명령이 실행되는 동안 운영 체제가 제한을 적용하므로, Claude Code는 각 명령마다 승인을 요청하지 않고 [샌드박스 명령을 실행](#sandbox-modes)할 수 있습니다.

샌드박스는 셸 명령에만 적용됩니다. Claude의 파일 도구, MCP 서버, 훅은 [샌드박스 외부에서 실행됩니다](#what-runs-outside-the-sandbox).

샌드박스는 macOS, Linux, WSL2에서 실행됩니다. 네이티브 Windows에서는 Claude Code가 샌드박스 없이 명령을 실행합니다. Windows 머신에서 샌드박스를 사용하려면 WSL2 배포판 내에서 Claude Code를 실행하십시오.

> [!NOTE]
>
> 이 페이지에서는 사용자 자신의 머신에서 셸 명령을 둘러싼 샌드박스를 다룹니다. 관련 질문은 다른 페이지에서 다룹니다.
>
> * 클라우드 세션이 격리되는 방식은 [보안 및 격리](https://code.claude.com/docs/ko/claude-code-on-the-web.md#security-and-isolation)를 참조하십시오
> * 개발 컨테이너, 사용자 지정 컨테이너, 가상 머신 등 다른 격리 방식을 비교하려면 [샌드박스 환경](https://code.claude.com/docs/ko/sandbox-environments.md)을 참조하십시오
> * Bash 이외의 도구에 대한 권한 프롬프트를 줄이려면 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)를 참조하십시오

## 샌드박스가 제한하는 항목

샌드박스가 켜져 있는 동안 Claude가 실행하는 셸 명령은 샌드박스 경계 안에서 시작되며, 해당 명령이 시작하는 프로세스도 마찬가지입니다. 샌드박스는 기본적으로 꺼져 있습니다. 샌드박스를 켜려면 [시작하기](#get-started)에 나온 대로 세션에서 `/sandbox`를 실행하거나, `~/.claude/settings.json` 같은 [설정 파일](https://code.claude.com/docs/ko/settings.md)에서 [`sandbox.enabled`](https://code.claude.com/docs/ko/settings-reference#sandbox-enabled)를 `true`로 설정합니다.

다음 표는 샌드박스 처리된 명령이 기본적으로 접근할 수 있는 항목과 각 기본값을 변경하는 설정을 보여 줍니다.

| 접근 | 기본값 | 변경 방법 |
| :- | :- | :- |
| 쓰기 | 작업 디렉터리, 사용자별 임시 디렉터리, [추가한 디렉터리](https://code.claude.com/docs/ko/permissions.md#additional-directories-grant-file-access-not-configuration). [보호된 경로](#protected-paths)는 계속 쓰기가 거부됩니다 | [`filesystem.allowWrite`](https://code.claude.com/docs/ko/settings-reference#sandbox-filesystem-allowwrite), [`filesystem.denyWrite`](https://code.claude.com/docs/ko/settings-reference#sandbox-filesystem-denywrite) |
| 읽기 | `~/.ssh` 및 `~/.aws/credentials` 같은 자격 증명 파일을 포함한 머신의 대부분 | [`filesystem.denyRead`](https://code.claude.com/docs/ko/settings-reference#sandbox-filesystem-denyread), [`credentials`](#protect-credentials) |
| 네트워크 | 외부로 나가는 직접 경로가 없습니다. 연결은 머신의 프록시를 거치며, 프록시는 각 호스트를 허용된 도메인 목록과 대조합니다. 이 목록은 처음에 비어 있습니다. [다른 호스트에 대한 처리 방식](#hosts-outside-your-allowed-domains)은 권한 모드에 따라 결정됩니다 | [`network.allowedDomains`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-alloweddomains), [`network.deniedDomains`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-denieddomains) |
| 환경 변수 | Claude Code 환경에 있는 모든 시크릿을 포함하여 Claude Code에서 상속됩니다 | [`credentials`](#protect-credentials), [`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](https://code.claude.com/docs/ko/env-vars) |

Claude Code는 오픈 소스 패키지인 [`@anthropic-ai/sandbox-runtime`](https://github.com/anthropics/sandbox-runtime)을 기반으로 샌드박스를 구축합니다.

### 샌드박스 외부에서 실행되는 항목

샌드박스는 셸 명령을 감쌉니다. 다음 도구와 프로세스는 샌드박스 외부에서 실행됩니다.

* **기본 제공 파일 및 웹 도구**: Read, Edit, Write, WebFetch, WebSearch 같은 도구는 대신 [권한 규칙](https://code.claude.com/docs/ko/permissions.md)을 따릅니다. `denyRead` 항목은 Read 도구를 막지 않으며, `allowedDomains`는 WebFetch를 제한하지 않습니다
* **Claude Code가 시작하는 기타 프로세스**: 명령 [훅](https://code.claude.com/docs/ko/hooks.md), 로컬 [MCP 서버](https://code.claude.com/docs/ko/mcp.md), [플러그인 모니터](https://code.claude.com/docs/ko/plugins/components.md#monitors), [LSP 서버](https://code.claude.com/docs/ko/tools-reference.md#lsp-tool-behavior), 그리고 [상태줄](https://code.claude.com/docs/ko/statusline.md) 명령 및 `apiKeyHelper` 같은 헬퍼 명령은 사용자의 전체 접근 권한으로 실행됩니다

설정에 따라 일부 셸 명령도 샌드박스 외부에서 실행됩니다.

* **사용자가 직접 입력하는 명령**: [`!` 셸 모드 프롬프트](https://code.claude.com/docs/ko/interactive-mode#shell-mode-with-prefix)에서 입력하는 명령은 대부분의 세션에서 샌드박스 없이 실행됩니다. 직접 입력한 명령이 샌드박스에서 실행되는 세션은 [엄격한 샌드박스 모드](#turn-off-the-retry-with-strict-sandbox-mode)에 나와 있습니다
* **제외된 명령**: [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands)와 일치하는 명령은 샌드박스 없이 실행됩니다
* **샌드박스 없는 재시도**: Claude는 일반적으로 샌드박스에서 명령이 실패한 후 [샌드박스 없이 명령을 실행하도록 요청](#the-unsandboxed-retry-escape-hatch)할 수 있습니다

이 섹션의 도구, 프로세스, 명령을 하나의 경계 안에 두려면 Claude Code 프로세스 자체를 [컨테이너, 가상 머신 또는 샌드박스 런타임](https://code.claude.com/docs/ko/sandbox-environments.md)에서 실행합니다.

## 시작하기

샌드박스는 Claude Code에 내장되어 있습니다. 설치해야 할 항목은 플랫폼에 따라 다릅니다.

* **macOS**: 샌드박싱은 내장된 Seatbelt 프레임워크를 사용하므로 바로 아래 단계로 진행할 수 있습니다
* **Linux 및 WSL2**: 샌드박스는 `bubblewrap`과 `socat`에 의존하며, 이는 [Linux 및 WSL2 설정](#set-up-linux-and-wsl2)에서 다룹니다. 아직 설치하지 않았더라도 `/sandbox`로 시작할 수 있습니다. 해당 패널에 누락된 항목이 표시되기 때문입니다

**1. /sandbox 실행**

Claude Code 세션을 시작하고 `/sandbox` 명령을 실행합니다.

```text theme={null}
/sandbox
```

그러면 세 개의 탭이 있는 샌드박스 패널이 열리며, Linux에서 선택 사항인 seccomp 필터가 누락된 경우 Dependencies 탭이 추가로 표시됩니다.

* **Mode**: 샌드박스 처리된 명령의 승인 방식을 선택합니다. 다음 단계에서 다룹니다
* **Overrides**: 샌드박스에서 실패한 명령이 샌드박스 없이 실행되도록 대체할 수 있는지 선택합니다. 이는 [`allowUnsandboxedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-allowunsandboxedcommands) 설정입니다
* **Config**: 확정된 샌드박스 설정을 확인합니다

패널에 Dependencies 탭만 표시된다면 필수 패키지가 누락된 것입니다. [Linux 및 WSL2 설정](#set-up-linux-and-wsl2)의 설명에 따라 설치한 후 Claude Code를 재시작하고 `/sandbox`를 다시 실행합니다.

**2. 모드 선택**

Mode 탭에서 auto-allow 또는 regular permissions를 선택합니다. auto-allow는 샌드박스 처리된 명령을 확인 요청 없이 실행하며, regular permissions는 명령이 샌드박스 처리된 경우에도 일반 권한 프롬프트를 유지합니다. auto-allow 모드에서도 확인을 요청하는 명령은 [샌드박스 모드](#sandbox-modes)를 참조하세요.

**3. Bash 명령 실행**

빌드나 테스트 스위트 같은 명령을 실행하도록 Claude에 요청합니다. 기본적으로 샌드박스 내부의 명령은 작업 디렉터리, [사용자별 임시 디렉터리](https://code.claude.com/docs/ko/env-vars.md), 그리고 `--add-dir`, `/add-dir` 또는 `permissions.additionalDirectories`로 [추가한 디렉터리](https://code.claude.com/docs/ko/permissions.md#additional-directories-grant-file-access-not-configuration)에 쓸 수 있습니다.

명령이 처음으로 새 네트워크 도메인을 필요로 하면 Claude Code가 승인을 요청합니다. [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서는 대신 Claude가 명령에 필요한 호스트를 [명령 자체에](#per-command-allowed-domains-in-auto-mode) 명시하여 분류기가 명령과 함께 검토하도록 합니다.

샌드박스가 허용하는 범위를 넓히거나 좁히려면 [샌드박싱 구성](#configure-sandboxing)을 참조하세요.

컨테이너 내부에서 샌드박스 처리된 명령이 `Operation not permitted`로 실패하는 경우 [컨테이너 내부에서 Bubblewrap이 시작되지 않음](#bubblewrap-fails-to-start-inside-a-container)을 참조하세요.

패널에서 모드를 선택하면 Claude Code는 이를 현재 프로젝트에 적용되는 프로젝트 로컬 설정 `.claude/settings.local.json`에 저장합니다. Claude Code는 이 파일에 설정을 저장할 때 해당 파일을 전역 gitignore에 추가합니다. 모든 프로젝트에서 샌드박스를 활성화하려면 `~/.claude/settings.json`의 사용자 설정에서 [`sandbox.enabled`](https://code.claude.com/docs/ko/settings-reference#sandbox-enabled)를 `true`로 설정합니다. 조직의 모든 개발자에게 샌드박싱을 강제하려면 [관리형 설정](#enforce-sandboxing-with-managed-settings)을 사용합니다.

설정 파일에 쓰지 않고 한 세션에 대해서만 샌드박스를 변경하려면 [`--settings`](https://code.claude.com/docs/ko/settings#change-a-setting-for-one-session)로 Claude Code를 시작합니다. 예를 들어 다음 명령은 Claude가 차단된 명령을 샌드박스 밖에서 재시도할 수 없는 샌드박스 세션을 시작합니다.

```bash theme={null}
claude --settings '{"sandbox": {"enabled": true, "allowUnsandboxedCommands": false}}'
```

> [!WARNING]
>
> 기본적으로 의존성이 누락되었거나 플랫폼이 지원되지 않아 샌드박스를 시작할 수 없으면 Claude Code는 샌드박싱 없이 명령을 실행합니다. 대신 Claude Code가 시작 시 종료되도록 하려면 [`sandbox.failIfUnavailable`](https://code.claude.com/docs/ko/settings-reference#sandbox-failifunavailable)을 `true`로 설정합니다. 샌드박싱을 보안 관문으로 요구하는 관리형 배포에서 이 설정을 사용할 수 있습니다.

### 명령이 샌드박스 내부에서 실행되는지 확인

샌드박스가 작동하는지 확인하려면 표의 각 줄을 실행하도록 Claude에 요청합니다. [`!` 프롬프트](#what-runs-outside-the-sandbox)에 직접 입력한 내용은 일반적으로 샌드박스 밖에서 실행되므로, 직접 입력해서는 테스트가 되지 않습니다.

| 명령 | 샌드박스 내부에서의 결과 |
| :- | :- |
| `touch ~/sandbox-probe` | macOS에서는 `Operation not permitted`, Linux 및 WSL2에서는 `Read-only file system`으로 실패합니다 |
| `curl --noproxy '*' https://example.com` | 명령이 샌드박스 프록시를 우회할 경로가 없으므로 `Could not resolve host`로 실패합니다 |

Claude가 실패한 명령을 샌드박스 밖에서 재시도하겠다고 요청하면 재시도를 거부합니다. `touch`가 성공했고 홈 디렉터리가 샌드박스에서 명령의 쓰기를 허용하는 디렉터리가 아니라면 `~/sandbox-probe`를 삭제합니다. 그런 다음 `/sandbox`를 실행하여 샌드박스가 켜져 있고 의존성이 설치되어 있는지 확인합니다.

### Linux 및 WSL2 설정

Linux 및 WSL2에서 샌드박스는 다음 패키지에 의존합니다.

* [`bubblewrap`](https://github.com/containers/bubblewrap): 파일 시스템 격리를 적용하는 비특권 샌드박싱 도구
* [`socat`](http://www.dest-unreach.org/socat/): 네트워크 트래픽을 샌드박스 프록시를 통해 라우팅하는 데 사용되는 릴레이

배포판의 패키지 관리자로 설치합니다.

> [tab] Ubuntu/Debian
>
> ```bash theme={null}
> sudo apt-get install bubblewrap socat
> ```

> [tab] Fedora
>
> ```bash theme={null}
> sudo dnf install bubblewrap socat
> ```

의존성이 누락된 경우 `/sandbox`의 Dependencies 탭에 `ripgrep`, `bubblewrap`, `socat`, seccomp 필터 중 플랫폼에 없는 항목이 나열됩니다. 설치 후 Claude Code를 재시작했는데 이 탭이 보이지 않는다면 모든 의존성이 갖춰진 것입니다.

Ripgrep은 네이티브 Claude Code 바이너리에 번들로 포함되어 있습니다. seccomp 필터는 선택 사항이며 Unix 도메인 소켓 차단 기능을 추가합니다. 누락된 경우 `npm install -g @anthropic-ai/sandbox-runtime`으로 설치합니다.

필수 의존성이 누락된 경우 설치하기 전까지 Dependencies 탭만 표시됩니다. 선택 사항인 seccomp 필터만 누락된 경우에는 Dependencies 탭이 다른 탭과 함께 표시됩니다. 의존성 검사는 시작 시 실행되므로, 패키지를 설치한 후 `/sandbox`가 이를 감지하도록 Claude Code를 재시작합니다.

> [accordion] Ubuntu 24.04 이상: bubblewrap이 사용자 네임스페이스를 생성하도록 허용
>
> Ubuntu 24.04 이상에서는 기본 AppArmor 정책이 bubblewrap이 격리에 필요한 사용자 네임스페이스를 생성하지 못하도록 막습니다.
>
> WSL2 내부를 포함해 환경에 이 제한이 적용되는지 확인하려면 `sysctl kernel.apparmor_restrict_unprivileged_userns`를 실행합니다. 명령이 `0`을 반환하면 이 단계를 건너뜁니다. `No such file or directory` 오류가 출력되면 해당 키가 존재하지 않는 것이므로 이 단계를 건너뛸 수 있습니다. `1`을 반환하면 `bwrap`에 이 기능을 부여하는 AppArmor 프로필을 추가합니다.
>
> ```bash theme={null}
> sudo tee /etc/apparmor.d/bwrap > /dev/null <<'EOF'
> abi <abi/4.0>,
> include <tunables/global>
>
> profile bwrap /usr/bin/bwrap flags=(unconfined) {
>   userns,
>   include if exists <local/bwrap>
> }
> EOF
> ```
>
> 이 프로필은 `bwrap` 자체에만 적용되며, 샌드박스 내부에서 실행하는 명령에는 적용되지 않습니다. 적용하려면 AppArmor를 다시 로드합니다.
>
> ```bash theme={null}
> sudo systemctl reload apparmor
> ```

> [accordion] WSL2 참고 사항
>
> PowerShell에서 `wsl -l -v`로 WSL 버전을 확인합니다. `Sandboxing requires WSL2`가 표시되면 배포판이 WSL1에서 실행 중인 것입니다. WSL2로 업그레이드하거나 샌드박싱 없이 Claude Code를 실행합니다.
>
> WSL2에서 WSL은 `cmd.exe`, `powershell.exe` 또는 `/mnt/c/` 아래의 모든 항목과 같은 Windows 바이너리 실행을 Unix 소켓을 통해 Windows 호스트에 넘깁니다. 따라서 샌드박스 처리된 명령이 이를 실행할 수 있는지는 샌드박스의 [Unix 소켓 설정](https://code.claude.com/docs/ko/settings-reference.md#sandbox-network-allowunixsockets)을 따르며, 애초에 소켓을 차단하려면 선택 사항인 seccomp 필터가 설치되어 있어야 합니다. 이러한 실행을 허용하려면 `allowAllUnixSockets`를 설정합니다. 이 설정은 샌드박스 처리된 명령에 모든 Unix 소켓을 엽니다.

### 샌드박스 모드

Claude Code는 두 가지 샌드박스 모드를 제공합니다. 두 모드 모두 샌드박스가 동일한 파일 시스템 및 네트워크 제한을 적용하며, 차이는 샌드박스 처리된 명령이 자동 승인되는지 아니면 명시적 권한이 필요한지뿐입니다.

#### Auto-allow 모드

명령이 샌드박스 내부에서 실행되면 Claude Code는 확인 요청 없이 자동으로 승인합니다. 명령이 [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands)에 해당하거나 Claude가 [샌드박스 없이 재시도](#the-unsandboxed-retry-escape-hatch)하여 샌드박스 밖에서 실행되는 경우에는 일반 [권한 흐름](https://code.claude.com/docs/ko/permissions.md)을 거칩니다.

허용하지 않은 호스트에 연결하는 샌드박스 처리된 명령은 샌드박스에 그대로 남습니다. 연결 허용 여부를 누가 결정하는지는 [허용된 도메인 밖의 호스트](#hosts-outside-your-allowed-domains)에서 다룹니다.

auto-allow 모드에서도 다음은 계속 적용됩니다.

* [`Bash` 거부 규칙이 일치하는 형식](https://code.claude.com/docs/ko/permissions#bash-rule-limits)의 명령은 여전히 차단됩니다
* [중요 경로](https://code.claude.com/docs/ko/permission-modes.md#which-paths-are-critical)를 대상으로 하는 것으로 인식된 `rm` 또는 `rmdir` 명령은 여전히 일반 권한 흐름을 거칩니다
* `Bash(git push *)` 같은 내용 범위 [ask 규칙](https://code.claude.com/docs/ko/permissions.md)은 샌드박스 처리된 명령에도 여전히 확인을 요청합니다
* 단순 `Bash` ask 규칙 또는 이와 동일한 `Bash(*)` 형식은 샌드박스에서 실행되는 명령에는 건너뛰지만, 샌드박스 밖에서 실행되는 명령에는 여전히 적용됩니다. [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에서는 이 규칙을 건너뛰지 않으며, 읽기 전용 명령을 포함해 샌드박스 처리된 명령에도 확인을 요청합니다
* [Monitor 도구](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 명령은 샌드박스에서 실행되기는 하지만 자동으로 승인되지 않습니다. 확인 요청을 건너뛰려면 `Bash(npm run *)`처럼 명령과 일치하는 [allow 규칙](https://code.claude.com/docs/ko/permissions.md#bash)을 추가합니다

일부 샌드박스 처리된 명령도 자동으로 승인되지 않고 일반 [권한 흐름](https://code.claude.com/docs/ko/permissions.md)을 거칩니다. 명령 앞에 설정한 변수가 실행되는 프로그램을 바꿀 수 있는 `FOO=bar npm test` 같은 명령과 `make CC=clang` 또는 `eval "ls"`가 이에 해당합니다. 이 경우 allow 규칙과 권한 모드에 따라 프롬프트 표시 여부가 결정되며, 명령은 여전히 샌드박스 내부에서 실행됩니다.

이 세 가지 명령의 경우 명령과 일치하는 [allow 규칙](https://code.claude.com/docs/ko/permissions.md#bash)을 추가하면 반복되는 확인 요청이 사라집니다. 다음 규칙은 그 패턴을 보여 줍니다.

* `Bash(make *)`는 `make CC=clang`을 승인합니다
* `Bash(FOO=bar npm *)`는 `FOO=bar npm test`를 승인합니다. 명령이 변수 할당으로 시작하면 규칙에 해당 할당을 포함합니다
* `Bash(eval "ls")`는 `eval "ls"`를 승인합니다. `Bash(eval *)` 같은 와일드카드 규칙으로는 이 확인 요청이 사라지지 않으므로 전체 명령과 일치하는 규칙을 작성합니다

명령과 일치하는 allow 규칙은 해당 명령의 [샌드박스 없는 재시도](#the-unsandboxed-retry-escape-hatch)도 승인하므로, 명령이 확인 요청 없이 샌드박스 밖에서 실행될 수 있습니다.

> [!NOTE]
>
> auto-allow 모드는 권한 모드 설정과 독립적으로 작동하지만, 세 가지 예외가 있습니다. [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode), [명령별 허용 도메인](#per-command-allowed-domains-in-auto-mode)을 포함한 자동 모드 명령, 그리고 자동 모드에서 샌드박스 처리된 명령에 대한 [서버 측 분류기 검토](https://code.claude.com/docs/ko/permission-modes.md#how-the-classifier-evaluates-actions)입니다. "accept edits" 모드가 아니더라도 auto-allow가 활성화되어 있으면 샌드박스 처리된 Bash 명령은 자동으로 실행됩니다. 즉, 파일 편집 도구가 확인을 요청하는 Manual 모드에서도 샌드박스 경계 내에서 파일을 수정하는 Bash 명령은 확인 요청 없이 실행됩니다.
>
> 플랜 모드에서는 auto-allow가 승인 범위를 넓히지 않습니다. 계획하는 동안 Claude Code가 명령을 제어하는 방식은 [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)를 참조하세요.

#### Regular permissions 모드

모든 Bash 명령은 샌드박스 처리된 경우에도 일반 권한 흐름을 거칩니다. 더 많은 제어를 제공하지만 더 많은 승인이 필요합니다.

#### 샌드박스 없는 재시도 탈출구

샌드박스 없는 재시도는 샌드박스와 호환되지 않는 도구처럼 샌드박스 내부에서 실패하는 명령을 위한 탈출구입니다. 샌드박스가 네트워크 연결을 차단하면 Claude Code는 명령 결과에 거부된 호스트를 명시하므로 Claude는 무엇이 차단되었는지 알 수 있습니다. Claude는 실패를 분석하고 `dangerouslyDisableSandbox` 파라미터로 명령을 재시도할 수 있습니다.

재시도된 명령은 샌드박스 없이 실행됩니다. 대화형 터미널 세션에서 누가 이를 승인하는지는 권한 모드에 따라 다릅니다.

* **`bypassPermissions` 모드**: 재시도가 확인 요청 없이 실행됩니다
* **Manual 모드 및 `acceptEdits` 모드**: "Bash command (unsandboxed)"라는 제목의 프롬프트가 표시됩니다
* **[자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)**: 별도의 분류기 모델이 기본 명령을 평가합니다
* **`dontAsk` 모드**: Claude Code가 재시도를 거부합니다
* **플랜 모드**: [계획하는 동안 Claude Code가 명령을 제어하는 방식](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)을 참조하세요

다음 규칙과 설정은 재시도를 승인하는 주체를 변경합니다.

* **일치하는 allow 규칙**: `Bash(curl *)` 같은 allow 규칙이 명령과 일치하면 재시도도 승인하므로, 명령이 확인 요청 없이 샌드박스 밖에서 실행됩니다
* **파라미터에 대한 ask 규칙**: `Bash(dangerouslyDisableSandbox:true)`에 대한 [ask 규칙](https://code.claude.com/docs/ko/permissions.md#match-by-input-parameter)을 추가하면 Bash 재시도 시 확인을 요청받습니다. 자동 모드와 `bypassPermissions` 모드에서도 프롬프트가 표시되며, 이 규칙은 일치하는 allow 규칙보다 우선합니다
* **[`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)**: 이 설정이 켜져 있을 때 확인을 요청하는 재시도는 [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)에서 다룹니다

명령이 [`Sandbox is required` 메시지](#commands-refused-with-sandbox-is-required)와 함께 거부되는 동안에는 Claude Code가 `dangerouslyDisableSandbox` 파라미터를 무시하고 재시도도 거부합니다.

#### strict 샌드박스 모드로 재시도 끄기

[샌드박스 설정](https://code.claude.com/docs/ko/settings-reference.md#sandbox-settings)에서 `"allowUnsandboxedCommands": false`를 설정하여 샌드박스 없는 재시도를 비활성화할 수 있습니다. 재시도가 비활성화되면 Claude Code는 `dangerouslyDisableSandbox` 파라미터를 무시합니다. 그러면 샌드박스가 실행 중인 동안 Claude가 실행하는 명령은 `excludedCommands` 항목과 일치하지 않는 한 샌드박스 처리됩니다. 샌드박스를 시작할 수 없을 때 Claude Code가 샌드박스 없이 명령을 실행하지 않도록 하려면 [`failIfUnavailable`](https://code.claude.com/docs/ko/settings-reference#sandbox-failifunavailable)도 설정합니다. `/sandbox` **Overrides** 탭에서는 이 설정이 **Strict sandbox mode**로 표시됩니다.

사용자 설정, `--settings` 또는 관리형 설정의 `false`는 프로젝트 설정이 `true`로 설정하더라도 유지됩니다. 사용자 설정의 `false`는 샌드박스를 관리자 필수로 만들지 않으므로 프로젝트의 다른 샌드박스 설정은 계속 적용됩니다. v2.1.285 이전에는 프로젝트의 `true`가 사용자 설정의 `false`를 재정의했습니다.

사용자 또는 관리자가 관리형 설정이나 `--settings` 플래그로 재시도를 비활성화하면 샌드박스는 관리자 필수가 됩니다. 그러면 Claude Code는 저장소 파일에서 샌드박스를 완화하는 설정을 `excludedCommands` 항목을 포함해 무시합니다. 해당 설정 목록은 [관리자 필수 샌드박스에서의 저장소 설정](#repository-settings-under-an-admin-required-sandbox)에 나와 있습니다.

strict 샌드박스 모드는 Claude가 실행하는 명령에 적용됩니다. [`!` 셸 모드 프롬프트](https://code.claude.com/docs/ko/interactive-mode#shell-mode-with-prefix)에 직접 입력한 명령은 세션이 다음 중 하나가 아닌 한 샌드박스 밖에서 실행됩니다.

* **[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)**: strict 샌드박스 모드가 셸 모드 명령에도 적용됩니다
* **[`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](https://code.claude.com/docs/ko/env-vars#variables)이 설정된 Linux 세션**: 셸 모드 명령을 포함해 모든 명령이 샌드박스에서 실행됩니다

v2.1.260 이전에는 strict 샌드박스 모드가 모든 세션에서 셸 모드 명령을 샌드박스 처리했습니다.

#### 임시 디렉터리

기본적으로 작업 디렉터리와 함께 사용자별 임시 디렉터리도 샌드박스 내부에서 쓰기가 가능합니다. [파일 시스템 격리를 비활성화](#disable-filesystem-isolation)하지 않는 한, Claude Code는 샌드박스 처리된 명령에 대해 `$TMPDIR`을 이 디렉터리로 설정하므로 임시 파일을 쓰는 도구가 추가 구성 없이 작동합니다.

샌드박스 없는 명령은 셸의 `$TMPDIR`이 설정되어 있으면 이를 상속하므로, 파일 시스템 격리가 켜져 있는 동안 샌드박스 처리된 명령과 샌드박스 없는 명령은 `$TMPDIR`을 서로 다른 디렉터리로 해석합니다. 셸에서 `$TMPDIR`이 설정되지 않았거나 비어 있으면, `$TMPDIR`을 참조하는 샌드박스 없는 명령은 [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars) 재정의 값을 받거나, 이를 설정하지 않았거나 재정의 값이 긴 경로인 경우 운영 체제의 임시 디렉터리를 받으므로 변수가 빈 문자열로 확장되지 않습니다. 두 명령 간에 임시 파일을 주고받으려면 대신 작업 디렉터리 아래에 파일을 씁니다.

## 샌드박싱 구성

`settings.json` 파일을 통해 샌드박스 동작을 사용자 지정할 수 있습니다. 전체 구성 참조는 [설정](https://code.claude.com/docs/ko/settings-reference.md#sandbox-settings)을 참조하세요.

기본적으로 샌드박스 처리된 명령은 현재 작업 디렉터리, 사용자별 임시 디렉터리, 그리고 `--add-dir`, `/add-dir` 또는 `permissions.additionalDirectories`로 [추가한 디렉터리](https://code.claude.com/docs/ko/permissions.md#additional-directories-grant-file-access-not-configuration)에 쓸 수 있습니다. `kubectl`, `terraform`, `npm` 같은 하위 프로세스 명령이 이 디렉터리 외부에 써야 하는 경우 `sandbox.filesystem.allowWrite`를 사용하여 특정 경로에 대한 접근 권한을 부여합니다:

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "allowWrite": ["~/.kube", "/tmp/build"]
    }
  }
}
```

이 경로들은 OS 수준에서 적용되므로 샌드박스 내부에서 실행되는 모든 명령과 그 하위 프로세스가 이를 따릅니다. 도구에 특정 위치에 대한 쓰기 권한이 필요한 경우, `excludedCommands`로 해당 도구를 샌드박스에서 완전히 제외하는 대신 이 방법을 사용하는 것이 권장됩니다.

동일한 파일 시스템 배열을 여러 [설정 범위](https://code.claude.com/docs/ko/settings.md#settings-precedence)에서 정의하면 Claude Code는 이를 병합하며, 한 범위의 배열을 다른 범위의 배열로 대체하는 대신 모든 범위의 경로를 결합합니다. Claude Code는 [개발자가 정책을 넓히지 못하도록 하기](#keep-developers-from-widening-the-policy)의 잠금이 적용되는 항목은 병합에서 제외합니다.

CLI에서 [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference)로, 또는 Agent SDK에서 [`settingSources`](https://code.claude.com/docs/ko/agent-sdk/claude-code-features#control-filesystem-settings-with-settingsources)로 특정 소스를 제외하면, Claude Code는 샌드박스 구성을 만들 때 해당 소스의 `sandbox.filesystem` 항목, `Edit` 권한 규칙, `Read` 거부 규칙을 무시합니다. Claude Code v2.1.246 이상이 필요합니다.

세션 중에 이 파일 시스템 목록을 편집하면 Claude Code는 [실행 중인 세션에 변경 사항을 적용](https://code.claude.com/docs/ko/settings.md#when-edits-take-effect)하므로, 다음에 실행되는 샌드박스 명령은 새 경로로 실행됩니다.

샌드박스 파일 시스템 경로는 표준 규칙을 따릅니다. `/tmp/build`는 절대 경로이고 `~/.kube`는 홈 디렉터리 기준 상대 경로입니다. 이는 절대 경로에 `//path`를, 프로젝트 기준 상대 경로에 `/path`를 사용하는 [Read 및 Edit 권한 규칙](https://code.claude.com/docs/ko/permissions.md#read-and-edit)과 다릅니다. 상대 경로, 후행 슬래시, 와일드카드에 대해서는 [샌드박스 경로 접두사](https://code.claude.com/docs/ko/settings-reference.md#sandbox-path-prefixes)를 참조하세요.

`sandbox.filesystem.denyWrite` 및 `sandbox.filesystem.denyRead`를 사용하여 쓰기 또는 읽기 접근을 거부할 수도 있으며, `sandbox.filesystem.allowRead`를 사용하여 거부된 영역 내의 특정 경로를 다시 허용할 수 있습니다. 읽기 규칙이 겹치는 경우 더 좁은 경로의 규칙이 적용됩니다:

| 예시 규칙 | 결과 |
| :- | :- |
| `"denyRead": ["~/"]`와 `"allowRead": ["~/projects"]` | `~/projects`는 읽을 수 있고 홈 디렉터리의 나머지 부분은 차단된 상태로 유지됩니다. 더 좁은 허용 규칙이 거부된 영역의 해당 부분을 다시 엽니다 |
| `"allowRead": ["~/"]`와 `"denyRead": ["~/.env"]` | `~/.env`는 차단된 상태로 유지되고 홈 디렉터리의 나머지 부분은 읽을 수 있습니다. 거부 규칙은 더 넓은 허용 규칙 안에서도 유지되므로, 광범위한 허용 규칙이 비밀 정보를 조용히 다시 노출할 수 없습니다 |
| `"allowRead": ["~/"]`와 `"denyRead": ["~/**/.env"]` | 홈 디렉터리 아래의 모든 `.env`는 차단된 상태로 유지되고 나머지는 읽을 수 있습니다. [와일드카드 거부 규칙](https://code.claude.com/docs/ko/settings-reference.md#sandbox-path-prefixes)은 정확한 경로와 같은 방식으로 더 넓은 허용 규칙 안에서도 유지됩니다 |

아래 예시는 현재 프로젝트에서의 읽기는 허용하면서 홈 디렉터리 전체에서의 읽기를 차단합니다. 상대 경로 `.`는 구성이 프로젝트 설정에 있을 때만 프로젝트 루트로 해석되므로, 이 구성을 프로젝트의 `.claude/settings.json`에 배치합니다:

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["."]
    }
  }
}
```

동일한 구성을 `~/.claude/settings.json`에 배치하면 `.`가 대신 `~/.claude`로 해석되므로, 프로젝트 파일은 `denyRead` 규칙에 의해 계속 차단됩니다.

작업 디렉터리는 읽을 수 있도록 유지하면서 샌드박스 처리된 명령의 홈 디렉터리 및 마운트된 볼륨 읽기 접근을 거부하려면, 경로 규칙을 작성하는 대신 [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)를 설정합니다.

### `excludedCommands`로 샌드박스 외부에서 명령 실행

[`sandbox.excludedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-excludedcommands)에 명령 패턴을 나열하면 일치하는 명령이 샌드박스 외부에서 실행되며, 이는 파일 시스템 제한과 네트워크 프록시가 모두 적용되지 않음을 의미합니다. 샌드박스 내부에서 작동할 수 없고 전체 접근 권한을 맡길 만큼 신뢰하는 도구에 사용합니다. 디렉터리 하나나 호스트 하나만 더 필요한 도구는 명령을 샌드박스 안에 유지하는 `allowWrite` 또는 `allowedDomains`로 작동할 수 있습니다.

이 예시는 `docker compose` 명령을 샌드박스에서 제외합니다. 모든 프로젝트에 적용하려면 `~/.claude/settings.json`에 저장합니다:

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "excludedCommands": ["docker compose *"]
  }
}
```

Claude Code는 각 Bash 및 Monitor 호출을 항목과 대조합니다. 호출은 Claude가 보내는 전체 명령줄이며, 여러 명령을 연결할 수 있습니다. 호출이 샌드박스를 벗어나는지 여부는 다음 규칙으로 결정됩니다:

* **패턴을 ` *`로 끝내기**: 항목은 `Bash(...)` [권한 규칙](https://code.claude.com/docs/ko/permissions.md#permission-rule-syntax)과 동일한 구문을 사용하며, 와일드카드가 없는 패턴은 정확히 일치해야 합니다. `docker`는 인수가 없는 `docker`에만 일치합니다. `docker *`는 인수 유무와 관계없이 `docker`에 일치합니다
* **호출의 모든 명령이 일치해야 함**: `npm ci && docker compose build`는 다른 항목이 `npm ci`를 포함하지 않는 한 샌드박스 안에 유지됩니다
* **Claude Code는 호출의 텍스트를 대조함**: 내부적으로 `docker`를 호출하는 스크립트나 `make` 타깃은 일치하지 않으며, `/usr/local/bin/docker`도 일치하지 않습니다
* **일부 호출은 샌드박스 안에 유지됨**: 파일로의 리디렉션, `cd`, 또는 `$(...)` 같은 명령 치환이 있으면 전체 호출이 샌드박스 안에 유지됩니다. [참조 항목](https://code.claude.com/docs/ko/settings-reference.md#sandbox-excludedcommands)에 샌드박스 안에 유지되는 더 많은 호출이 나열되어 있습니다
* **`git clone`에는 상대 경로가 필요함**: 절대 경로, `~`로 시작하는 경로, 또는 `..` 세그먼트가 있는 경로를 지정하는 clone은 항목에 포함되지 않습니다. clone을 작업 디렉터리 안에 둘 수 있다면 Claude에게 `vendor/lib`처럼 `..` 세그먼트가 없는 상대 경로를 사용하도록 요청합니다
* **항목을 저장하는 위치가 중요할 수 있음**: 샌드박스가 [관리자 필수](#repository-settings-under-an-admin-required-sandbox)인 동안 Claude Code는 `.claude/settings.json` 및 `.claude/settings.local.json`의 항목을 무시합니다

제외된 명령은 일반 권한 흐름을 거칩니다:

* [읽기 전용 명령](https://code.claude.com/docs/ko/permissions.md#read-only-commands)과 허용 규칙에 포함된 명령은 프롬프트 없이 실행됩니다
* 자동 모드에서는 분류기가 그 외의 제외된 명령을 검토합니다
* `bypassPermissions` 모드에서는 확인 규칙이 일치하지 않는 한 제외된 명령이 프롬프트 없이 실행됩니다

항목이 일치하는지 확인하려면 Manual 모드로 전환한 뒤 Claude에게 `docker compose up -d`처럼 무언가를 변경하는 일치 명령을 실행하도록 요청합니다. 권한 프롬프트의 제목은 "Bash command (unsandboxed)"입니다.

> [!WARNING]
>
> 제외된 명령은 사용자의 전체 접근 권한으로 실행됩니다. `docker *` 같은 광범위한 항목은 해당 도구가 할 수 있는 모든 작업을 포함합니다. 인터프리터, 작업 디렉터리 내부의 스크립트, 또는 `docker compose`가 compose 파일에 대해 작동하듯 그곳의 파일에 작용하는 도구를 포함하는 패턴을 작성하면, Claude가 해당 파일을 작성한 다음 샌드박스 외부에서 실행할 수 있습니다. 더 좁은 패턴을 사용할수록 Claude가 샌드박스 외부에서 실행할 수 있는 범위가 줄어듭니다.

### 파일 시스템 격리 비활성화

네트워크 격리는 유지하면서 파일 시스템 격리를 건너뛰려면 `sandbox.filesystem.disabled`를 `true`로 설정합니다. 아래 예시는 네트워크 도메인 허용 목록을 유지하면서 파일 시스템 격리를 끕니다:

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "disabled": true
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

샌드박스에는 두 개의 독립적인 계층이 있습니다. [파일 시스템 격리](#filesystem-isolation)는 샌드박스 처리된 명령이 읽고 쓸 수 있는 경로를 제어하고, [네트워크 격리](#network-isolation)는 접근할 수 있는 도메인을 제어합니다. 파일 시스템 계층을 끄면 샌드박스 처리된 명령은 호스트 파일 시스템에 대한 무제한 읽기 및 쓰기 접근 권한을 얻지만, 네트워크 송신은 허용된 도메인으로 계속 제한됩니다. 명령이 무엇을 쓰는지보다 어디에 연결하는지를 제어하기 위해 샌드박스를 사용하는 경우 이 계층을 끕니다.

`sandbox.filesystem.disabled`의 기본값은 `false`입니다.

> [!WARNING]
>
> 파일 시스템 격리가 꺼져 있고 명령이 자동 허용되는 경우, 샌드박스 처리된 명령은 셸 시작 파일, `$PATH`에 있는 실행 파일, `~/.claude/settings.json`처럼 이후 명령이 실행하거나 읽는 파일을 작성하고, 이를 이용해 다음 실행 시 자신의 접근 권한을 넓힐 수 있습니다. 자신의 접근 권한을 확대하지 않을 것으로 신뢰하는 워크로드에 대해서만 `filesystem.disabled`를 `true`로 설정하세요. [`allowManagedDomainsOnly`](#keep-developers-from-widening-the-policy)로 네트워크 도메인을 잠그면 위험이 줄어들지만 제거되지는 않습니다. 이 잠금은 샌드박스 내부에서 실행되는 명령에만 적용되기 때문입니다.

#### 비활성화할 수 있는 설정

파일 시스템 격리를 끄면 샌드박스 처리된 명령이 할 수 있는 작업이 넓어지므로, Claude Code는 다음 설정 소스의 `filesystem.disabled`만 적용합니다:

* 사용자 설정, 관리형 설정, `--settings` CLI 플래그에서 설정할 수 있습니다. `.claude/settings.json` 및 `.claude/settings.local.json`의 프로젝트 설정에서는 설정할 수 없으므로, 체크아웃한 프로젝트가 파일 시스템 격리를 끌 수 없습니다.
* 관리형 설정이 `sandbox.filesystem`을 조금이라도 구성하거나 `"mode": "deny"`인 `sandbox.credentials.files` 항목을 하나라도 나열하는 경우, 관리형 설정만 이 키를 설정할 수 있습니다. 이를 통해 개발자가 이러한 배포에서 파일 시스템 격리를 끌 수 없게 됩니다. 모든 사용자에 대해 파일 시스템 격리를 끄려면 관리형 설정에서 `"disabled": true`를 설정합니다.
* [`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](https://code.claude.com/docs/ko/env-vars)이 설정된 경우, Claude Code는 관리형 설정을 포함한 모든 소스의 `filesystem.disabled`를 무시하고 파일 시스템 격리를 켜 둡니다.

[유효한](https://code.claude.com/docs/ko/settings-reference.md#invalid-credential-entries-in-managed-settings) `mask` 항목은 Claude Code가 시작 시 해당 항목을 [`deny`로 폴백](#mask-credential-files)하더라도 키를 고정하지 않습니다. 자격 증명 디렉터리처럼 마스킹할 수 없는 경로는 관리형 설정에서 명시적인 `deny` 항목으로 나열하면 키가 고정됩니다.

#### 파일 시스템 격리가 꺼지면 달라지는 점

`filesystem.disabled`를 설정하면 파일 시스템 계층 자체가 적용하는 보호가 해제됩니다. 다른 계층이 적용하는 보호는 계속 적용됩니다:

| 보호 | 파일 시스템 격리가 꺼진 경우 |
| - | - |
| `filesystem.denyRead` 및 [`credentials.files`](#protect-credentials) `deny` 읽기 차단 | 적용되지 않습니다. 둘 다 파일 시스템 계층이 적용합니다 |
| `credentials.envVars` `deny` 및 `mask` 항목 | 적용됩니다. 환경 변수 제거는 파일 시스템 계층과 독립적입니다 |
| 마스크로 적용된 [`credentials.files` `mask` 항목](#mask-credential-files) | 적용됩니다: 마스킹은 파일 시스템 계층과 독립적입니다. [`deny`로 폴백된](#mask-credential-files) 항목은 다른 `deny` 항목과 마찬가지로 적용되지 않습니다 |

다른 두 가지도 달라집니다:

* 모든 임시 디렉터리에 쓸 수 있게 되어 Claude Code가 더 이상 명령을 사용자별 임시 디렉터리로 리디렉션하지 않으므로, 샌드박스 처리된 명령은 사용자별 임시 디렉터리 대신 셸의 `$TMPDIR`을 상속합니다.

  Linux에서는 상위 셸에 이 변수가 설정되지 않은 경우가 많습니다. Bash 도구 지침은 Claude에게 `$TMPDIR`에 의존하는 대신 `mktemp -d`로 임시 작업 디렉터리를 만들도록 안내합니다.
* [`autoAllowBashIfSandboxed`](https://code.claude.com/docs/ko/settings-reference#sandbox-autoallowbashifsandboxed)는 여전히 기본값이 `true`이므로 샌드박스 처리된 명령은 계속 프롬프트 없이 실행됩니다. 샌드박스 처리된 명령에 대해 확인을 요청하려면 `false`로 설정합니다.

### 자격 증명 보호

`sandbox.credentials` 설정은 샌드박스 처리된 명령으로부터 보호할 자격 증명 파일과 환경 변수를 선언합니다. 각 항목은 파일 경로 또는 환경 변수와 `mode`를 지정합니다. 전용 `credentials` 블록은 자격 증명 규칙을 한곳에 모아 일반 파일 시스템 규칙과 분리해 둡니다.

`"mode": "deny"` 항목의 경우, 파일 경로는 `filesystem.denyRead`가 적용하는 것과 동일한 제한으로 샌드박스 내부에서 읽기가 거부되며, 환경 변수는 각 샌드박스 명령이 실행되기 전에 설정 해제됩니다. 파일 보호는 파일 시스템 계층의 일부이므로 [파일 시스템 격리를 비활성화](#disable-filesystem-isolation)하면 적용되지 않지만, 환경 변수 보호는 계속 적용됩니다.

아래 예시는 AWS 자격 증명 파일과 SSH 디렉터리의 읽기를 차단하고, 샌드박스 처리된 명령의 환경에서 `GITHUB_TOKEN`과 `NPM_TOKEN`을 제거합니다:

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "credentials": {
      "files": [
        { "path": "~/.aws/credentials", "mode": "deny" },
        { "path": "~/.ssh", "mode": "deny" }
      ],
      "envVars": [
        { "name": "GITHUB_TOKEN", "mode": "deny" },
        { "name": "NPM_TOKEN", "mode": "deny" }
      ]
    }
  }
}
```

환경 변수 항목과 파일 항목은 [자격 증명 마스킹](#mask-credentials)에서 설명하는 `"mode": "mask"`도 허용합니다.

파일 경로는 `sandbox.filesystem.*` 설정과 동일한 [접두사 규칙](https://code.claude.com/docs/ko/settings-reference.md#sandbox-path-prefixes)을 따릅니다.

Claude Code는 세션이 로드하는 모든 [설정 범위](https://code.claude.com/docs/ko/settings.md#settings-precedence)의 `deny` 항목을 병합합니다. `deny` 항목은 접근을 좁히기만 하므로 어떤 범위든 항목을 추가할 수 있지만, 다른 범위가 추가한 항목을 제거할 수 있는 범위는 없습니다.

[설정 소스를 제외](#configure-sandboxing)하는 경우:

* **프로젝트 또는 로컬 설정**: Claude Code는 해당 설정의 `credentials` 항목을 전혀 적용하지 않습니다. Claude Code v2.1.246 이상이 필요합니다.
* **사용자 설정**: Claude Code는 `~/.claude/settings.json`의 `deny` 항목을 여전히 적용하고 [파일 `mask` 항목](#mask-credential-files)을 더 이상 프록시가 실제 값을 치환하도록 승인하지 않는 제한으로 유지하지만, [환경 변수 `mask` 항목](#mask-environment-variables)은 제외합니다.

기본 제공되는 자격 증명 거부 목록은 없으므로, 나열한 파일과 변수만 제한됩니다.

`sandbox.credentials`는 샌드박스 처리된 Bash 명령에만 영향을 줍니다. 샌드박싱 여부와 관계없이 모든 하위 프로세스에서 자격 증명을 제거하려면 [`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](https://code.claude.com/docs/ko/env-vars)을 설정합니다.

### 자격 증명 마스킹

자격 증명을 마스킹하면 Claude Code는 샌드박스 처리된 명령에 센티널이라는 세션별 플레이스홀더를 보여 주고, [샌드박스 프록시](#network-isolation)는 허용한 호스트로 나가는 요청에서 실제 값으로 치환합니다. [자격 증명 보호](#protect-credentials)의 `deny` 항목은 대신 자격 증명을 차단합니다. macOS의 파일의 경우 Claude Code는 마스킹하는 대신 [파일을 차단합니다](#mask-credential-files). [`sandbox.credentials`](https://code.claude.com/docs/ko/settings-reference#sandbox-credentials) 참조에 모든 필드가 나열되어 있습니다.

마스킹에는 다음이 필요합니다:

* **TLS 종료**: 프록시는 요청 내용 안에서 실제 값을 치환하므로 내용을 볼 수 있어야 합니다. 프록시가 TLS를 직접 종료하도록 [`network.tlsTerminate`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-tlsterminate)를 설정합니다. 이 설정이 없으면 마스킹은 아무것도 노출하지 않은 채 실패합니다. 명령은 여전히 센티널만 보지만, 센티널이 변경되지 않은 채 서버에 도달하여 인증이 실패합니다. 이 잘못된 구성을 확인하려면 터미널에서 `claude doctor`를 실행하고 `TLS termination is unavailable` 경고가 있는지 살펴봅니다.
* **허용된 대상**: 각 `mask` 항목에는 실제 값이 도달할 수 있는 호스트인 `injectHosts`를 나열할 수 있습니다. 프록시는 [도메인 허용 목록](#network-isolation)이 허용하는 연결에만 주입하므로, 각 `injectHosts` 호스트는 `network.allowedDomains`를 통해서도 접근 가능해야 합니다. `injectHosts`가 없는 `mask` 항목의 경우, 프록시는 `network.allowedDomains`의 모든 호스트에 대한 요청에서 실제 값을 치환합니다.
* **신뢰할 수 있는 설정 범위**: 마스킹은 프록시가 실제 자격 증명을 어딘가로 보내도록 승인하므로, Claude Code는 `mask` 항목, `network.tlsTerminate`, [`credentials.allowPlaintextInject`](https://code.claude.com/docs/ko/settings-reference#sandbox-credentials-allowplaintextinject), `awsPairs`, `sigv4`를 사용자 설정, 관리형 설정, `--settings` 플래그에서만 적용합니다. 저장소의 `.claude/settings.json` 또는 `.claude/settings.local.json`에 있는 이러한 항목은 무시합니다. 관리자가 서버 관리형 설정을 통해 `mask` 항목, `network.tlsTerminate` 또는 `credentials.allowPlaintextInject`를 제공하는 경우, 이는 [승인이 필요한 설정](https://code.claude.com/docs/ko/server-managed-settings.md#security-approval-dialogs)으로 간주됩니다.

#### 환경 변수 마스킹

환경 변수를 마스킹하려면 해당 `credentials.envVars` 항목에 `"mode": "mask"`를 설정합니다. 명령과 그 명령이 로그에 기록하는 내용은 실제 자격 증명을 절대 보유하지 않지만, 요청은 여전히 인증됩니다. 동일한 변수가 어떤 범위에서든 `deny`로 나열되어 있으면 `deny`가 우선합니다.

아래 예시는 두 개의 토큰을 마스킹합니다. `GH_TOKEN`은 `api.github.com`에 대한 요청에서만 치환되는 반면, `NPM_TOKEN`은 `injectHosts`가 없으므로 `network.allowedDomains`의 모든 호스트에 대한 요청에서 치환됩니다:

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "network": {
      "tlsTerminate": {},
      "allowedDomains": ["*.github.com", "registry.npmjs.org"]
    },
    "credentials": {
      "envVars": [
        { "name": "GH_TOKEN", "mode": "mask", "injectHosts": ["api.github.com"] },
        { "name": "NPM_TOKEN", "mode": "mask" }
      ]
    }
  }
}
```

마스킹은 기본적으로 전체 값을 교체합니다. `DATABASE_URL` 연결 문자열이나 JWT처럼 구조가 있는 값의 경우, 값을 파싱하는 도구가 계속 작동하도록 [`extract`, `decode`, `maskClaims`, `onExtractNoMatch` 필드](https://code.claude.com/docs/ko/settings-reference#sandbox-credentials-envvars)를 사용합니다.

IPv6 대상은 두 목록에서 서로 다르게 표기합니다:

* **`network.allowedDomains`**: `"[::1]"`처럼 대괄호 형식
* **`injectHosts`**: `"::1"`처럼 표준 압축 형식의 순수 주소

프록시는 포트를 무시하고 각 `injectHosts` 항목을 연결의 순수 대상 주소와 대조하므로, 대괄호 형식, 영역 ID 포함 형식 또는 다르게 압축된 표기는 절대 일치하지 않습니다. `claude doctor`는 절대 일치할 수 없는 항목을 `Sandbox credential injectHosts entries can never match their destination` 경고로 표시합니다. 이 검사에는 Claude Code v2.1.229 이상이 필요합니다.

#### AWS 요청 재서명

AWS 요청은 요청 내용에 대한 SigV4 서명을 포함하므로 `AWS_ACCESS_KEY_ID`와 `AWS_SECRET_ACCESS_KEY`를 함께 마스킹합니다. 프록시는 액세스 키의 [센티널](#mask-credentials)로 SigV4 요청을 감지하고 실제 값으로 요청을 다시 서명하며, 이를 위해서는 Claude Code v2.1.221 이상이 필요합니다. 비밀 키만 마스킹하면 프록시가 감지할 수 없는 플레이스홀더로 요청이 서명되므로 AWS에서 실패합니다.

관례적인 `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` 변수의 전체 값을 마스킹하면 Claude Code는 이를 자동으로 하나의 자격 증명으로 연결합니다. AWS 자격 증명이 다른 이름의 변수에 있는 경우, Claude Code v2.1.224 이상이 필요한 [`credentials.awsPairs`](https://code.claude.com/docs/ko/settings-reference#sandbox-credentials-awspairs)로 그룹화합니다.

스트리밍 업로드, 미리 서명된 URL, SigV4A 요청은 프록시가 다시 계산할 수 없는 서명을 포함합니다. 이러한 요청이 마스킹된 페어의 플레이스홀더로 서명된 경우, 프록시는 손상된 서명을 전달하는 대신 요청을 실패시킵니다. 마스킹되지 않은 자격 증명으로 서명된 요청은 영향을 받지 않습니다. 이러한 요청 형식 중 하나를 대신 전달하려면 Claude Code v2.1.224 이상이 필요한 [`credentials.sigv4`](https://code.claude.com/docs/ko/settings-reference#sandbox-credentials-sigv4)를 사용합니다. AWS는 여전히 요청을 거부하므로, 호출하는 도구는 프록시 오류 대신 AWS 자체의 거부 응답을 받습니다.

#### 자격 증명 파일 마스킹

자격 증명 파일을 마스킹하려면 해당 `credentials.files` 항목에 `"mode": "mask"`를 설정합니다. 파일 마스킹에는 Claude Code v2.1.221 이상이 필요합니다. 샌드박스 처리된 명령이 보는 내용은 플랫폼에 따라 다릅니다:

* **Linux 및 WSL2**: 샌드박스 처리된 명령은 파일의 [센티널](#mask-credentials) 사본을 읽고, 프록시가 나가는 요청에서 실제 값으로 치환합니다.
* **macOS**: 샌드박스 처리된 명령은 파일을 전혀 읽을 수 없습니다. Claude Code는 센티널 사본을 만들지 않으므로, 해당 파일로 인증하는 도구는 샌드박스 내부에서 작동하지 않으며 이는 `deny`와 같은 효과입니다. 읽기 차단은 [파일 시스템 격리를 비활성화](#disable-filesystem-isolation)한 경우에도 유지됩니다.

아래 예시는 `~/.config/gh/hosts.yml`에 저장된 GitHub 토큰을 마스킹합니다. `extract` 패턴은 파일의 어느 부분이 비밀 정보인지 표시하므로, Linux 및 WSL2에서 `gh`는 여전히 구성의 나머지 부분을 파싱합니다:

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "network": {
      "tlsTerminate": {},
      "allowedDomains": ["*.github.com"]
    },
    "credentials": {
      "files": [
        {
          "path": "~/.config/gh/hosts.yml",
          "mode": "mask",
          "extract": "oauth_token:\\s*(\\S+)",
          "injectHosts": ["api.github.com"]
        }
      ]
    }
  }
}
```

마스크가 활성 상태인지 확인하려면 Claude에게 샌드박스 처리된 명령으로 `cat ~/.config/gh/hosts.yml`을 실행하도록 요청합니다. Linux 및 WSL2에서는 출력에 토큰 대신 센티널이 표시되고, macOS에서는 읽기가 실패합니다.

`extract`나 `decode`가 없으면 Claude Code는 파일 전체를 하나의 센티널로 교체하며, 이는 단일 비밀 정보만 담은 파일에 적합합니다. 부분 마스킹과 패턴이 아무것도 일치하지 않을 때의 동작을 제어하려면 [`extract`, `decode`, `maskClaims`, `onExtractNoMatch`, `maskDuplicates` 필드](https://code.claude.com/docs/ko/settings-reference#sandbox-credentials-files)를 사용합니다.

> [!WARNING]
>
> 일치 과정에서 마스킹할 대상을 찾지 못하면 기본 `onExtractNoMatch` 값인 `warn`이 항목을 건너뛰므로, 샌드박스 처리된 명령이 마스킹되지 않은 실제 파일을 읽을 수 있습니다. macOS에서는 파일 시스템 격리가 켜져 있으면 Claude Code가 패턴이 실행되기 전에 `mask` 항목을 `deny`로 적용하므로, 일치 없음 결과는 [파일 시스템 격리가 꺼져 있을](#disable-filesystem-isolation) 때만 적용됩니다. 기본값은 정상적으로 존재하지 않을 수 있는 자격 증명에 적합합니다. 비밀 정보가 존재하지만 패턴이 이를 놓칠 수 있는 경우에는 [`deny`](https://code.claude.com/docs/ko/settings-reference#mask-fields-for-files)를 사용하세요.

`mask`는 단일 파일에 적용되므로 각 자격 증명 파일을 개별적으로 나열합니다. Claude Code는 안전하게 마스킹할 수 없는 `mask` 항목, 즉 디렉터리 경로, glob 패턴, 8 MiB보다 큰 파일, 또는 UTF-8 텍스트가 아닌 파일에 대해 `deny`로 폴백합니다.

## 샌드박싱 작동 방식

### 파일 시스템 격리

샌드박스된 Bash 도구는 파일 시스템 접근을 특정 디렉터리로 제한합니다.

* **기본 쓰기 동작**: 현재 작업 디렉터리와 그 하위 디렉터리, `--add-dir`, `/add-dir` 또는 [`permissions.additionalDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-additionaldirectories)로 추가한 모든 디렉터리, 그리고 `$TMPDIR`이 가리키는 사용자별 임시 디렉터리에 대한 읽기 및 쓰기 접근
* **기본 읽기 동작**: 특정 거부된 디렉터리를 제외한 컴퓨터 전체에 대한 읽기 접근. 이 기본값에서도 자격 증명 파일을 읽을 수 있으므로, 명령이 읽지 않기를 원하는 [자격 증명을 보호](#protect-credentials)하십시오.
* **읽기 차단**: [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)를 켜면 샌드박스된 명령은 홈 디렉터리와 사용자 파일을 보관하는 기타 디렉터리에 대한 읽기 접근도 잃습니다. 단, [차단 상태의 샌드박스된 명령](https://code.claude.com/docs/ko/settings-reference.md#sandboxed-commands-under-the-block)에 나열된 경로는 예외입니다. 해당 섹션에서는 차단의 이 부분이 적용되지 않는 경우도 설명합니다.
* **Git worktree**: 작업 디렉터리가 [연결된 git worktree](https://code.claude.com/docs/ko/worktrees.md)인 경우, 샌드박스는 `git commit` 같은 명령이 ref와 인덱스를 업데이트할 수 있도록 메인 저장소의 공유 `.git` 디렉터리에 대한 쓰기도 허용합니다. 해당 디렉터리 안의 `hooks/`와 `config`에 대한 쓰기는 계속 거부됩니다.

네트워크 격리는 유지하면서 파일 시스템 격리를 완전히 건너뛰려면 [`sandbox.filesystem.disabled`](#disable-filesystem-isolation)를 설정하십시오.

### 보호된 경로

샌드박스된 명령이 쓸 수 있는 디렉터리 안에서도, 샌드박스는 Claude Code가 구성과 코드를 로드하는 파일에 대한 쓰기를 여전히 거부합니다. 이러한 파일을 편집할 수 있는 명령은 스스로 권한을 부여하거나, Claude Code가 샌드박스 외부에서 실행하는 훅이나 MCP 서버를 추가할 수 있기 때문입니다. 권한 시스템에는 별도의 [보호된 경로](https://code.claude.com/docs/ko/permission-modes.md#protected-paths)가 있으며, 이는 도구가 실행되기 전에 Claude Code가 무엇을 승인할지를 제어합니다. 샌드박스의 목록은 이미 실행 중인 명령에 적용됩니다. 이 목록은 네 가지 경로 그룹을 다룹니다.

* **작업 디렉터리와 그 상위 디렉터리**: `.claude` 설정 파일, `.claude/skills`, `.claude/agents`, `.claude/commands`, `.claude/hooks` 디렉터리, `.mcp.json`, 그리고 `.claude/workflows`와 `.claude/scheduled_tasks.json`처럼 Claude Code가 자체적으로 실행하는 파일
* **작업 디렉터리에만 해당**: `.bashrc`와 `.zshrc` 같은 셸 시작 파일, `.gitconfig`, `.vscode`와 `.idea` 디렉터리, 그리고 `.git` 안의 `hooks`와 `config`
* **작업 디렉터리를 bare git 저장소로 바꿀 수 있는 파일**: 최상위 수준의 `HEAD`, `objects`, `refs`, 그리고 그 옆에 `HEAD` 파일이나 심볼릭 링크가 있을 때 해당 위치에 이미 존재하는 `config`와 `hooks` 항목. `config`라는 이름의 파일은 `HEAD`가 없어도 거부됩니다. [나중에 나타나는 `HEAD`, `objects` 또는 `refs`는 삭제될 수 있습니다](#when-the-sandbox-deletes-head-objects-or-refs). Linux와 WSL2에서는 샌드박스된 명령이 해당 항목이 없는 위치에 새로 만들 수 있습니다.
* **`~/.claude` 또는 `CLAUDE_CONFIG_DIR`이 가리키는 디렉터리**: 해당 디렉터리 내용의 대부분, 그리고 `~/.claude.json`과 `.credentials.json` 자격 증명 저장소

세션 중에 보호된 설정 파일의 경로에 심볼릭 링크가 나타나면, 샌드박스는 다음 명령부터 해당 링크가 가리키는 파일에 대한 쓰기도 거부합니다.

이러한 경로 중 하나를 포함하는 `allowWrite` 항목이나 `Edit` 허용 규칙을 추가하더라도 보호는 계속 적용됩니다. 보호를 끄려면 [`filesystem.disabled`](#disable-filesystem-isolation)를 설정하십시오. 이 설정은 나머지 파일 시스템 격리도 함께 끕니다.

> [!WARNING]
>
> Linux 또는 WSL2에서 [`allowNestedUserNamespaces`](https://code.claude.com/docs/ko/settings-reference#sandbox-allownestedusernamespaces)를 `true`로 설정한 경우 보호된 경로에 의존하지 마십시오. 샌드박스된 명령의 코드가 결국 샌드박스 외부에서 실행될 수 있습니다.

사용자 컴퓨터에서 해석된 이러한 경로 대부분을 확인하려면 `/sandbox`를 실행하고 **Config** 탭을 여십시오. 이 탭에서는 **Denied within allowed** 아래에 사용자가 직접 지정한 `denyWrite` 항목과 함께 이러한 경로가 나열됩니다.

이러한 경로 중 하나에서 `git merge` 또는 `git checkout`이 `unable to unlink old`와 함께 실패하면 [git 명령이 `unable to unlink old`로 실패하는 경우](#a-git-command-fails-with-unable-to-unlink-old)를 참조하십시오.

#### 샌드박스가 `HEAD`, `objects` 또는 `refs`를 삭제하는 경우

샌드박스된 명령이 끝난 후, 작업 디렉터리에 새로 생긴 최상위 `HEAD`, `objects` 또는 `refs` 항목은 내용이 있는 폴더가 아닌 한 삭제됩니다. 새로 생긴 항목이란 샌드박스가 마지막으로 구성을 빌드했을 때, 즉 세션 시작 시 또는 [`/cd`](https://code.claude.com/docs/ko/commands) 같은 변경 후에 존재하지 않았던 항목을 의미합니다.

샌드박스가 마지막으로 구성을 빌드했을 때 `HEAD` 파일이나 심볼릭 링크가 있었다면, 새로 생긴 내용이 있는 `objects` 또는 `refs` 폴더도 그 내용과 함께 삭제됩니다. 폴더를 유지하려면 [명령 실행 후 `objects` 또는 `refs`라는 이름의 폴더가 사라지는 경우](#a-folder-named-objects-or-refs-disappears-after-a-command)를 참조하십시오.

#### 심볼릭 링크를 통과하는 거부된 경로

macOS에서 거부된 경로가 심볼릭 링크를 통과하는 경우(예: dotfiles 저장소로 연결된 링크인 `~/.claude`), 샌드박스는 해당 경로의 실제 위치도 거부합니다. 이는 샌드박스 자체의 거부와 사용자가 문자 그대로 지정한 `denyWrite` 및 `denyRead` 항목 모두에 적용됩니다.

`*`, `?` 또는 `[`를 포함하는 `denyWrite` 항목도 이러한 문자 중 첫 번째 문자 앞에 있는 폴더가 심볼릭 링크인 경우 적용 대상에 포함됩니다. 예를 들어 `~/.claude/*.json`은 `~/.claude`의 실제 위치 아래에서도 거부됩니다.

### 네트워크 격리

샌드박스된 명령에는 네트워크로 향하는 직접 경로가 없습니다.

* **Linux 및 WSL2**: 명령은 사용자 네트워크와 연결되지 않은 별도의 네트워크 네임스페이스에서 실행됩니다
* **macOS**: Seatbelt 샌드박스 프레임워크가 기본적으로 샌드박스 프록시로의 연결 외의 연결을 차단합니다

Claude Code는 샌드박스 외부인 사용자 컴퓨터에서 샌드박스 프록시를 실행하고, `HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY` 및 관련 환경 변수를 통해 명령이 이 프록시를 사용하도록 합니다. 프록시는 각 연결의 호스트 이름을 허용 및 거부된 도메인과 대조하여 확인합니다.

도구가 접근할 수 있는 대상은 해당 도구가 프록시를 사용하는지에 따라 달라집니다.

* **프록시 변수를 읽는 도구**: `curl`, `npm`, HTTPS를 통한 `git` 및 유사한 도구는 호스트가 허용되면 연결됩니다. 포트가 없는 `allowedDomains` 항목은 해당 호스트의 모든 포트를 허용합니다
* **프록시 변수를 무시하는 도구**: 일반 `ssh`, 대부분의 데이터베이스 드라이버 및 유사한 도구는 허용된 호스트에도 연결할 수 없습니다. [데이터베이스 클라이언트 또는 기타 비 HTTP 도구가 허용된 호스트에 연결하지 못하는 경우](#a-database-client-or-other-non-http-tool-fails-to-reach-an-allowed-host)를 참조하십시오
* **TCP가 아닌 모든 것**: UDP, QUIC 기반 HTTP/3, `ping` 같은 ICMP 도구는 샌드박스를 벗어날 수 없습니다

다음 설정과 동작은 프록시가 허용하는 호스트를 제어합니다.

* **도메인 제한**: 허용된 도메인은 처음에 비어 있습니다. 명령이 처음으로 새 도메인을 필요로 할 때 어떤 일이 일어나는지는 [허용된 도메인 외부의 호스트](#hosts-outside-your-allowed-domains)에서 설명합니다.
* **승인 선택**: 프롬프트에서 Yes를 선택하면 Claude Code는 현재 세션의 나머지 기간 동안 해당 호스트를 허용합니다. "Yes, and don't ask again"을 선택하면 Claude Code는 `WebFetch(domain:...)` 허용 규칙을 [로컬 설정](https://code.claude.com/docs/ko/permissions.md#permission-system)에 저장하므로, 이후 세션에서도 해당 호스트가 계속 허용됩니다. 샌드박스가 [관리자 필수](#repository-settings-under-an-admin-required-sandbox)인 동안에는 Claude Code가 규칙을 사용자 설정에 저장하며, 이 규칙은 모든 프로젝트에 적용됩니다.
* **사전 허용된 도메인**: [`allowedDomains`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-alloweddomains)로 도메인을 사전 허용하면 프롬프트를 완전히 피할 수 있습니다. [권한 규칙](#permission-rules)에 설명된 대로, Claude Code는 `WebFetch(domain:...)` 허용 규칙의 도메인도 사전 허용합니다.
* **엄격한 허용 목록**: 사용자, 관리형 또는 CLI `--settings` 설정에서 [`strictAllowlist`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-strictallowlist)를 `true`로 설정하면, Claude Code는 확인을 요청하는 대신 샌드박스된 명령이 허용 목록 외부의 호스트에 접근하는 것을 거부합니다. 허용 목록은 `allowedDomains`와 `WebFetch(domain:...)` 허용 규칙의 도메인을 합친 것이며, `allowManagedDomainsOnly`가 설정된 경우에는 관리형 설정 항목만 해당합니다. 저장소의 항목에 대해서는 [관리자 필수 샌드박스 없이 적용되는 잠금](#locks-that-apply-without-an-admin-required-sandbox)에서 설명합니다. Claude Code는 이 설정을 샌드박스된 명령에만 적용합니다. `WebFetch` 같은 프로세스 내 도구는 여전히 해당 [권한 규칙](#permission-rules)을 따릅니다. 저장소의 `.claude/settings.json` 또는 `.claude/settings.local.json`에서 설정하면 효과가 없습니다. Claude Code v2.1.219 이상이 필요합니다.
* **관리형 잠금**: 관리형 설정에서 [`allowManagedDomainsOnly`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowmanageddomainsonly)가 설정된 경우, 허용되지 않은 도메인은 확인을 요청하는 대신 자동으로 차단되며, 관리형 설정의 `allowedDomains`와 `WebFetch(domain:...)` 허용 규칙만 적용됩니다.
* **기업 프록시**: 네트워크에서 아웃바운드 트래픽이 기업 프록시를 거쳐야 하는 경우, [프록시 구성](https://code.claude.com/docs/ko/network-config.md#proxy-configuration)에 설명된 대로 `HTTPS_PROXY`, `HTTP_PROXY`, `NO_PROXY`를 설정하십시오. [백그라운드 에이전트](https://code.claude.com/docs/ko/network-config.md#set-network-variables-in-settings-not-the-shell)도 이를 받을 수 있도록 설정의 `env` 블록에 지정하거나, Claude Code를 실행하는 환경에 지정합니다. Claude Code는 도메인 허용 목록을 적용한 다음, 허용된 연결을 해당 업스트림 프록시를 통해 터널링합니다. `http://` 및 `https://` 프록시 URL이 작동하며, 필요한 경우 URL에 기본 인증을 포함할 수 있습니다.

`WebFetch(domain:...)` 규칙에서 샌드박스는 두 가지 와일드카드 형식을 인식합니다. `*.example.com`처럼 앞에 오는 `*.`과 단독 `*`입니다. 단독 `*` 형식에는 Claude Code v2.1.186 이상이 필요합니다. `WebFetch(domain:example.*)`처럼 다른 위치에 있는 와일드카드는 여전히 fetch와 일치하지만 샌드박스된 명령에는 영향을 주지 않습니다.

> [!NOTE]
>
> 기본 제공 프록시는 요청된 호스트 이름을 기준으로 허용 목록을 적용하며, 기본적으로 TLS 트래픽을 종료하거나 검사하지 않습니다. 실험적 설정인 [`network.tlsTerminate`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-tlsterminate)를 사용하면 기본 제공 프록시가 직접 TLS를 종료하며, 이는 [`mask` 자격 증명 항목](#mask-credentials)에 필요합니다. 기본값의 영향에 대해서는 [보안 제한 사항](#security-limitations)을 참조하고, 위협 모델상 TLS 검사가 필요한 경우 [사용자 지정 프록시 구성](#custom-proxy-configuration)을 참조하십시오.

#### 허용된 도메인 외부의 호스트

샌드박스된 명령이 허용된 도메인에 없는 호스트에 연결하면, 명령은 샌드박스에 머문 채 결정을 기다립니다. 대화형 터미널 세션에서는 결정이 권한 모드에 따라 달라집니다.

| 권한 모드 | 연결에 일어나는 일 |
| :- | :- |
| `bypassPermissions` 모드, 그리고 [권한 우회를 사용할 수 있는](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode) 플랜 모드 | 프롬프트 없이 허용됨 |
| 수동 모드, `acceptEdits` 모드, 그 외의 플랜 모드 | 프롬프트가 표시됨 |
| 자동 모드 | 명령이 [호스트를 나열](#per-command-allowed-domains-in-auto-mode)하고 분류기가 그 목록을 승인한 경우에만 허용되며, 그렇지 않으면 거부됨 |
| `dontAsk` 모드 | 거부됨 |

[`strictAllowlist`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-strictallowlist) 또는 [`allowManagedDomainsOnly`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowmanageddomainsonly)가 켜져 있으면, 기본 제공 샌드박스 프록시는 모든 권한 모드에서 연결을 거부합니다. `bypassPermissions` 모드에서는 둘 중 하나가 켜져 있지 않는 한 허용된 도메인 외부의 호스트가 허용됩니다. 해당 모드에서 명령이 샌드박스를 벗어날 수 있는 경우는 [샌드박스 없이 재시도하는 탈출구](#the-unsandboxed-retry-escape-hatch)에서 설명합니다. [`deniedDomains`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-denieddomains)에 있는 호스트로의 연결도 모든 권한 모드에서 거부됩니다.

#### 로컬 주소로 해석되는 호스트 이름

호스트 이름이 허용 목록을 통과한 후, 샌드박스 프록시는 이를 해석하고 해당 이름이 로컬 주소로만 해석되면 연결을 거부합니다. 로컬 주소에는 `127.0.0.1` 같은 루프백 주소, `169.254.169.254` 클라우드 메타데이터 엔드포인트 같은 링크 로컬 주소, 그리고 사용자 컴퓨터에 할당된 주소가 포함됩니다. `localhost`와 `*.localhost`라는 이름은 루프백으로 해석되는 것이 허용됩니다.

`10.0.0.0/8` 같은 사설 범위로 해석되는 허용된 인트라넷 호스트 이름은 연결됩니다. 이름이 거부되는 주소로 해석되도록 허용하려면 `"127.0.0.1:8080"`처럼 해당 IP 주소를 `allowedDomains`에 추가하십시오.

이 검사는 호스트 이름에 적용됩니다. IP 주소로의 연결은 허용된 도메인과 권한 모드에 따라 결정됩니다. 또한 프록시는 업스트림 기업 프록시를 통해 보내는 연결에 대해서는 이 검사를 건너뜁니다. 해당 프록시가 이름을 해석하기 때문입니다.

#### 자동 모드의 명령별 허용 도메인

샌드박싱이 켜진 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서는 Claude가 각 연결마다 네트워크 승인을 트리거하는 대신, 명령에 필요한 호스트를 명령 자체에 지정합니다. 샌드박스에서 실행되는 각 Bash, PowerShell 또는 [Monitor](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 명령은 샌드박스 허용 목록 외의 호스트 목록을 포함할 수 있습니다. 이 목록에는 `registry.npmjs.org` 같은 도메인, `*.pythonhosted.org` 같은 와일드카드 또는 IP 주소를 지정할 수 있으며, 각각 선택적으로 `:port`를 붙일 수 있습니다. 분류기는 명령과 함께 호스트를 검토합니다. Claude Code v2.1.271 이상이 필요합니다.

승인된 목록은 해당 명령 하나에 대해서만, 그 명령이 실행되는 동안 해당 호스트를 엽니다. 세션의 허용된 호스트나 설정에는 아무것도 추가되지 않으며, 다음 명령은 자체 호스트를 지정합니다.

호스트를 포함하는 명령은 권한 규칙이나 샌드박스의 [자동 허용 모드](#sandbox-modes)에 의해 승인되는 대신 분류기로 전달됩니다. [확인 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)이 해당 명령에 대해 프롬프트를 강제하는 경우, 터미널의 권한 대화 상자는 명령 옆에 호스트를 나열하며, 그곳에서 승인하면 둘 다 승인됩니다.

명령별 목록은 샌드박스가 기본적으로 거부하는 대상만 넓힙니다. [`deniedDomains`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-denieddomains) 항목은 여전히 차단됩니다. [`strictAllowlist`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-strictallowlist) 또는 [`allowManagedDomainsOnly`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowmanageddomainsonly)가 허용 목록을 잠그면 Claude Code는 명령별 목록을 거부합니다.

명령별 목록이 적용되는 동안, Claude Code는 승인된 어떤 명령에도 나열되지 않은 호스트로의 연결을 프롬프트나 분류기 검사 없이 거부합니다. 거부 시 명령의 결과에 해당 호스트가 표시되며, Claude는 호스트를 추가하여 명령을 다시 실행합니다.

#### 도메인 목록의 IPv6 주소

`allowedDomains`, `deniedDomains` 또는 `WebFetch(domain:...)` 규칙에서 IPv6 주소와 일치시키려면 주소를 대괄호로 묶어 작성하십시오. `"[::1]"`은 모든 포트에서 해당 주소와 일치하고, `"[::1]:443"`은 포트 443에서만 일치합니다. 대괄호 형식에는 Claude Code v2.1.229 이상이 필요합니다.

`::1:443` 같은 대괄호 없는 항목은 주소인지, 포트가 붙은 주소인지 모호합니다.

* **거부 목록**: Claude Code는 항목이 해석될 수 있는 모든 방식을 거부하므로, 사용자가 의도한 방식이 무엇이든 차단됩니다. 해석 가능한 방식이 없는 항목의 경우 Claude Code는 아무것도 차단하지 않습니다
* **허용 목록**: Claude Code는 작성된 것보다 더 많이 허용하지 않습니다. 모호한 항목이 호스트와 포트 형식으로 깔끔하게 해석되면 그 형식으로 다시 작성하며, 허용 목록을 넓히는 대신 항목을 완전히 제외할 수도 있습니다

모호한 항목을 찾으려면 터미널에서 `claude doctor`를 실행하고 `Sandbox network domain entries have unreliable spellings` 경고를 확인하십시오. 모호한 각 항목을 대괄호 형식으로 다시 작성하십시오.

### OS 수준 적용

샌드박스된 Bash 도구는 운영 체제 보안 기본 요소를 사용합니다.

* **macOS**: 샌드박스 적용에 Seatbelt를 사용합니다
* **Linux**: 격리에 [bubblewrap](https://github.com/containers/bubblewrap)을 사용합니다
* **WSL2**: Linux와 동일하게 bubblewrap을 사용합니다

[`@anthropic-ai/sandbox-runtime`](https://github.com/anthropics/sandbox-runtime) 패키지를 단독으로 실행하여 Claude Code 프로세스를 감쌀 수도 있습니다. [샌드박스 런타임](https://code.claude.com/docs/ko/sandbox-environments.md#sandbox-runtime)을 참조하십시오.

## 샌드박싱이 권한 및 권한 모드와 어떻게 관련되는지

샌드박싱, [권한 규칙](https://code.claude.com/docs/ko/permissions.md), 및 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)는 상호 보완적인 계층입니다. 아래 섹션에서는 샌드박스가 각각과 어떻게 상호작용하는지 다룹니다.

### 권한 규칙

권한 규칙과 샌드박싱은 서로 다른 것들을 제어합니다:

* **권한 규칙**은 Claude Code가 사용할 수 있는 도구를 제어하며 도구가 실행되기 전에 평가됩니다. 이들은 모든 도구(Bash, Read, Edit, WebFetch, MCP 및 기타)에 적용되지만, deny 또는 ask 규칙은 다른 도구가 남아 있는 동안 [`EndConversation`](https://code.claude.com/docs/ko/tools-reference#endconversation-tool-behavior)을 차단할 수 없습니다.
* **샌드박싱**은 OS 수준의 강제 실행을 제공하여 셸 명령이 파일 시스템 및 네트워크 수준에서 접근할 수 있는 것을 제한합니다. 이는 Bash, PowerShell 및 [Monitor](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 도구 명령과 그 자식 프로세스에 적용됩니다.

두 계층은 또한 강제 실행 방식이 다릅니다. Claude Code는 명령 문자열을 기반으로 명령이 실행되기 전에 권한 결정을 평가하며, 자동 모드에서는 명령이 안전한지 여부에 대한 별도 분류기의 판단을 기반으로 합니다. 운영 체제는 실행 중인 프로세스에 샌드박스 경계를 강제 실행하므로, 모델이 실행하도록 선택한 것과 관계없이 그리고 허용된 명령이 이름이 시사하는 것보다 더 많은 작업을 수행하더라도 유지됩니다.

파일 시스템 및 네트워크 제한은 샌드박스 설정과 권한 규칙을 통해 모두 구성됩니다:

| 설정 또는 규칙 | 수행하는 작업 |
| :- | :- |
| `sandbox.filesystem.allowWrite` | 작업 디렉토리 외부의 경로에 대한 부프로세스 쓰기 액세스 권한 부여 |
| `sandbox.filesystem.denyWrite` 및 `sandbox.filesystem.denyRead` | 특정 경로에 대한 부프로세스 액세스 차단 |
| `sandbox.filesystem.allowRead` | `denyRead` 영역 내에서 특정 경로 읽기를 다시 허용 |
| [`sandbox.filesystem.disabled`](#disable-filesystem-isolation) | 네트워크 격리를 유지하면서 파일 시스템 계층을 완전히 끔 |
| `Edit` allow 규칙 | 특정 경로에 대한 쓰기 액세스 권한 부여, `sandbox.filesystem.allowWrite`와 동일한 방식 |
| `Read` 및 `Edit` deny 규칙 | 특정 파일 또는 디렉토리에 대한 액세스 차단 |
| `WebFetch(domain:...)` allow 및 deny 규칙 | 도메인 액세스 제어 |
| 샌드박스 `allowedDomains` | Bash 명령이 도달할 수 있는 도메인 제어 |
| 샌드박스 `deniedDomains` | 더 광범위한 `allowedDomains` 와일드카드가 그렇지 않으면 허용할 특정 도메인 차단 |

샌드박스 설정과 권한 규칙의 경로 및 도메인은 최종 샌드박스 구성으로 병합됩니다.

[claude-code 저장소의 examples 디렉토리](https://github.com/anthropics/claude-code/tree/main/examples/settings)에는 샌드박스 관련 예제를 포함한 일반적인 배포 시나리오에 대한 시작 설정 구성이 포함되어 있습니다. 이들을 시작점으로 사용하고 필요에 맞게 조정하십시오.

### 권한 모드

`/sandbox`는 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)가 아닙니다. 권한 모드는 도구 호출이 실행되는지 여부와 먼저 프롬프트를 받는지 여부를 결정하는 반면, 샌드박스는 Bash 명령이 실행되면 접근할 수 있는 것을 제한합니다. 이들은 제어하는 것과 작업별 프롬프트를 대체하는 것이 다릅니다:

| | 제어하는 것 | 프롬프트를 대체하는 것 |
| :- | :- | :- |
| `/sandbox` | Bash 명령이 실행되면 접근할 수 있는 것 | [자동 허용 모드](#sandbox-modes)의 샌드박스 경계 자체 |
| [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) | 각 도구 호출이 실행되는지 여부 | 작업을 검토하는 분류기 |
| `--dangerously-skip-permissions` | 각 도구 호출이 실행되는지 여부 | 없음. [보호된 경로](https://code.claude.com/docs/ko/permission-modes.md#protected-paths) 검사도 건너뜀; [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)은 여전히 적용됨 |

샌드박스의 [자동 허용 모드](#sandbox-modes)는 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)와 별개입니다: 자동 허용은 샌드박스 경계가 이들을 포함하기 때문에 Bash 명령을 승인하는 반면, 자동 모드는 분류기를 사용하여 작업을 검토합니다. 이 둘은 독립적으로 작동하며 [샌드박스 모드](#sandbox-modes)에 나열된 예외를 제외하고 결합될 수 있습니다. 무인 실행을 위한 격리 경계를 선택하려면 [샌드박스 환경](https://code.claude.com/docs/ko/sandbox-environments.md#how-isolation-relates-to-permission-modes)을 참조하십시오. 일반적인 권한 모드 및 샌드박스 쌍과 각각을 시작하는 플래그의 표는 [일반적인 설정](https://code.claude.com/docs/ko/permission-modes.md#common-setups)을 참조하십시오.

## 조직을 위해 샌드박스 구성

관리자는 모든 사용자에게 샌드박싱을 요구하고, 개발자가 정책을 확대하는 것을 방지하고, 샌드박스 트래픽을 회사 프록시를 통해 라우팅할 수 있습니다.

### 관리형 설정으로 샌드박싱 적용

모든 개발자에게 샌드박스를 요구하려면 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms)을 통해 `sandbox` 키를 제공합니다. MDM으로 관리되는 파일 또는 claude.ai의 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)을 통해 제공합니다.

다음 관리형 설정 구성은 샌드박스를 활성화하고, 플랫폼이 지원되지 않거나 의존성이 누락된 경우 Claude Code 시작을 거부하고, 모델이 샌드박스 외부에서 명령을 재시도하는 것을 방지합니다:

```json theme={null}
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true,
    "allowUnsandboxedCommands": false
  }
}
```

`enabled` 외의 두 키는 샌드박스가 명령을 실행할 수 없을 때 발생하는 일을 제어합니다:

* **`failIfUnavailable`**: Linux의 bubblewrap과 같은 의존성이 누락되면 샌드박싱 없는 실행으로 폴백하는 대신 Claude Code가 시작되지 않도록 차단합니다
* **`allowUnsandboxedCommands: false`**: Claude Code가 `dangerouslyDisableSandbox` 탈출 해치를 무시하므로 샌드박스에서 명령이 실패할 때 Claude가 샌드박스 없이 재시도할 수 없습니다

다음 항목도 함께 추가하는 것을 고려하십시오:

* 격리 없이 실행해야 하는 조직 승인 도구에 대해 `excludedCommands`를 추가합니다. 이 구성은 [저장소의 설정이 명령을 샌드박스에서 제외하지 못하도록 막기](#repository-settings-under-an-admin-required-sandbox) 때문입니다
* `~/.aws` 및 `~/.ssh`와 같은 자격 증명 디렉토리와 비밀 환경 변수에 대해 [`sandbox.credentials`](#protect-credentials) 항목을 추가합니다. 기본 읽기 정책은 여전히 이를 허용하기 때문입니다

이 구성은 Claude가 실행하는 명령을 샌드박싱합니다. 개발자는 여전히 [`!` 셸 모드 프롬프트](https://code.claude.com/docs/ko/interactive-mode#shell-mode-with-prefix)에서 명령을 입력하고 Claude Code 외부의 모든 터미널에서 이미 가지고 있는 것과 동일한 액세스 권한으로 샌드박스 외부에서 실행할 수 있습니다. 입력된 명령이 샌드박싱되는 세션에 대해서는 [엄격한 샌드박스 모드](#turn-off-the-retry-with-strict-sandbox-mode)를 참조하십시오.

샌드박스는 기본 Windows에서 실행되지 않으므로 `failIfUnavailable`이 설정되어 있으면 해당 머신에서는 Claude Code가 시작 시 종료됩니다. 플릿에 Windows 호스트가 포함되어 있다면 다음과 같이 할 수 있습니다:

* **운영 체제별로 구성 제공**: MDM을 통해 또는 [관리형 설정 파일](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms)로 macOS 및 Linux 머신에만 배포합니다. [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md#current-limitations)은 조직의 모든 사용자에게 적용됩니다
* **Windows 사용자를 지원되는 환경으로 이동**: WSL2 또는 컨테이너 내에서 Claude Code를 실행하도록 합니다

### 개발자가 정책을 확대하는 것을 방지

관리형 설정이 `enabled` 또는 `failIfUnavailable`과 같은 부울 키를 설정하면 Claude Code는 관리형 값을 사용하고 개발자가 로컬로 설정한 모든 것을 무시합니다. `allowRead`와 같은 배열 키의 경우 Claude Code는 세션이 로드하는 범위의 항목을 병합하므로, 해당 키에 잠금이 적용되지 않는 한 개발자는 정책을 확대하는 항목을 추가할 수 있습니다.

관리형 설정에서 설정하지 않는 한, 개발자의 사용자 설정 또는 `--settings`로 다음 키를 켤 수 있습니다. 샌드박스가 [관리자 필수](#repository-settings-under-an-admin-required-sandbox)가 아닌 한 저장소의 `.claude/settings.json`으로도 켤 수 있습니다. 각 키는 샌드박스를 약화시키므로, 사용되지 않기를 원한다면 관리형 설정에서 `false`로 설정하십시오:

* [`enableWeakerNestedSandbox`](https://code.claude.com/docs/ko/settings-reference#sandbox-enableweakernestedsandbox)
* [`enableWeakerNetworkIsolation`](https://code.claude.com/docs/ko/settings-reference#sandbox-enableweakernetworkisolation)
* [`network.allowAllUnixSockets`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowallunixsockets)
* [`network.allowLocalBinding`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowlocalbinding)
* [`allowAppleEvents`](https://code.claude.com/docs/ko/settings-reference#sandbox-allowappleevents) (저장소에서는 켤 수 없음)
* [`allowNestedUserNamespaces`](https://code.claude.com/docs/ko/settings-reference#sandbox-allownestedusernamespaces) (저장소에서는 켤 수 없음)

관리형 설정에서 `allowManagedReadPathsOnly`를 `true`로 설정하여 관리형 설정의 `allowRead` 항목만 존중되도록 합니다. 이는 개발자가 조직 승인 경로 이상으로 읽기 액세스를 확대하는 것을 방지합니다. 네트워크 도메인을 동일한 방식으로 관리형 값으로 잠그려면 [`allowManagedDomainsOnly`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowmanageddomainsonly)를 설정합니다. `allowManagedDomainsOnly`가 켜져 있으면 관리형 설정만 [프록시 포트](#custom-proxy-configuration)를 설정할 수 있습니다.

관리형 설정이 `sandbox.filesystem`을 구성하거나 `"mode": "deny"`를 사용하여 `sandbox.credentials.files` 항목을 나열할 때 관리형 설정만 [`filesystem.disabled`](#disable-filesystem-isolation)를 설정할 수 있으므로 개발자는 해당 키로 파일 시스템 격리를 끌 수 없습니다. [유효한](https://code.claude.com/docs/ko/settings-reference.md#invalid-credential-entries-in-managed-settings) `mask` 항목은 키를 잠그지 않습니다. [어떤 설정이 이를 비활성화할 수 있는지](#which-settings-can-disable-it)를 참조하십시오.

#### 관리자 필수 샌드박스에서의 저장소 설정

다음 설정 중 하나가 적용되어 있는 동안 샌드박스는 관리자 필수 상태가 됩니다:

* 관리형 설정에서 `false`로 설정되었거나, 관리형 설정이 `true`로 설정하지 않은 상태에서 `--settings` 플래그로 `false`로 설정된 [`allowUnsandboxedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-allowunsandboxedcommands)
* 관리형 설정에서 `true`로 설정된 [`allowManagedDomainsOnly`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowmanageddomainsonly)

이 설정들은 샌드박스를 켜지 않으므로 `enabled`도 함께 설정하십시오.

샌드박스가 관리자 필수 상태인 동안 Claude Code는 샌드박스를 완화하는 설정을 관리형 설정, `--settings` 플래그, 각 개발자의 `~/.claude/settings.json`에서만 가져옵니다. 저장소의 `.claude/settings.json` 및 `.claude/settings.local.json`에 있는 다음 설정은 무시합니다:

| 저장소 설정 | Claude Code가 무시하는 내용 |
| :- | :- |
| `excludedCommands`, `ignoreViolations`, `network.allowedDomains`, `network.allowUnixSockets`, `network.allowMachLookup`, `network.httpProxyPort`, `network.socksProxyPort` | 모든 항목 |
| `filesystem.allowWrite`, `Edit(...)` 허용 규칙, `permissions.additionalDirectories` | 각 항목이 샌드박싱된 명령에 부여하는 쓰기 액세스. Claude의 파일 도구는 여전히 `Edit(...)` 규칙과 추가 디렉토리를 따릅니다 |
| `WebFetch(domain:...)` 허용 규칙 | 각 규칙이 샌드박스 허용 목록에 추가하는 호스트. WebFetch 도구는 여전히 해당 규칙을 따릅니다 |
| `enableWeakerNestedSandbox`, `enableWeakerNetworkIsolation`, `network.allowAllUnixSockets`, `network.allowLocalBinding` | `true`. `false`는 여전히 적용됩니다 |
| `enabled`, `failIfUnavailable` | 개발자의 `~/.claude/settings.json`이 `true`로 설정한 경우의 `false` |
| `filesystem.allowRead` | 관리형 설정, `--settings` 또는 사용자 설정이 읽기를 거부하는 경로 또는 그 하위 경로에 있는 항목, 또는 그러한 경로와 일치할 수 있는 glob |

샌드박스가 관리자 필수 상태인 동안에도 다음 설정은 여전히 적용됩니다:

* **저장소의 파일에서**: 거부 항목과 `autoAllowBashIfSandboxed` 값. 저장소가 이를 변경하지 못하도록 하려면 관리형 설정에서 해당 키를 설정하십시오
* **개발자 본인의 설정에서**: `allowManagedDomainsOnly`와 같은 관리형 전용 잠금이 적용되지 않는 한, 표에 있는 설정은 `~/.claude/settings.json` 또는 `--settings`에서 여전히 적용됩니다. `excludedCommands` 및 `filesystem.allowWrite`와 같은 대부분의 설정에는 관리형 전용 잠금이 없습니다

[관리형 설정으로 샌드박싱 적용](#enforce-sandboxing-with-managed-settings) 아래의 구성은 샌드박스를 관리자 필수 상태로 만듭니다. 저장소에서는 제공할 수 없으므로, 승인된 도구에 필요한 `excludedCommands`, `allowWrite` 및 소켓 항목을 관리형 설정에 추가하십시오.

Claude Code v2.1.285 이상이 필요합니다. v2.1.282부터 v2.1.284까지는 동일한 설정으로 인해 Claude Code가 저장소의 `excludedCommands` 항목을 무시했습니다.

#### 관리자 필수 샌드박스 없이 적용되는 잠금

일부 설정은 샌드박스가 관리자 필수 상태가 아닐 때에도 Claude Code가 하나의 제한을 직접 재정의하는 저장소 키를 무시하도록 합니다. 각 설정은 해당 행에 명시된 파일에서 설정한 경우에만 이러한 효과가 있으며, 저장소의 다른 샌드박스 설정은 여전히 적용됩니다. Claude Code v2.1.285 이상이 필요합니다.

| 설정 | 설정 위치 | Claude Code가 저장소 설정에서 무시하는 내용 |
| :- | :- | :- |
| `network.deniedDomains` 또는 `WebFetch(domain:...)` 거부 규칙 | 관리형 설정, `--settings` | `httpProxyPort` 및 `socksProxyPort` |
| `network.strictAllowlist` | 관리형 설정, `--settings`, 사용자 설정 | 프록시 포트, `allowedDomains`, `WebFetch(domain:...)` 허용 규칙 |
| `filesystem.denyRead`, `Read(...)` 거부 규칙 또는 `credentials.files` 항목 | 관리형 설정, `--settings` | 관리형 설정, `--settings` 또는 사용자 설정이 읽기를 거부하는 경로 또는 그 하위 경로에 있는 `allowRead`, `allowWrite`, `Edit(...)` 허용 또는 `additionalDirectories` 항목, 또는 그러한 경로와 일치할 수 있는 glob |

이러한 잠금은 샌드박싱된 명령이 접근할 수 있는 대상을 변경합니다. WebFetch 도구와 Claude의 파일 도구는 여전히 저장소의 규칙과 추가 디렉토리를 따릅니다.

### 사용자 정의 프록시 구성

자체 도구로 샌드박스 트래픽을 검사, 필터링 또는 로깅하려면 기본 제공 샌드박스 프록시를 동일한 머신에서 실행하는 프록시로 교체합니다.

네트워크의 다른 위치에 있는 회사 프록시를 통해 샌드박스 트래픽을 라우팅하려면 [네트워크 격리](#network-isolation) 아래의 **회사 프록시** 항목에 설명된 대로 대신 `HTTPS_PROXY`를 설정하십시오. 이렇게 하면 Claude Code의 허용 목록이 계속 적용됩니다.

샌드박싱된 명령을 프록시로 보내려면 [샌드박스 설정](https://code.claude.com/docs/ko/settings-reference.md#sandbox-settings)에서 프록시가 수신 대기하는 localhost 포트를 설정합니다:

```json theme={null}
{
  "sandbox": {
    "network": {
      "httpProxyPort": 8080,
      "socksProxyPort": 8081
    }
  }
}
```

포트를 설정하면서 `HTTPS_PROXY` 또는 `HTTP_PROXY`도 설정하면, Claude Code는 샌드박싱된 명령이 사용자의 프록시로 보내는 내용을 해당 변수가 지정하는 프록시로 전달하지 않습니다. 회사 프록시에 도달하려면 자체 프록시가 회사 프록시로 전달하도록 구성하십시오.

포트를 설정할 수 있는 파일은 다른 샌드박스 설정에 따라 달라집니다. 가장 먼저 일치하는 경우가 적용됩니다:

* **`allowManagedDomainsOnly`가 켜져 있는 경우**: 관리형 설정만
* **샌드박스가 [관리자 필수](#repository-settings-under-an-admin-required-sandbox) 상태이거나 [더 좁은 네트워크 잠금](#locks-that-apply-without-an-admin-required-sandbox)이 적용되는 경우**: 관리형 설정, `--settings`, 사용자 설정
* **그 외의 경우**: 모든 설정 파일

Claude Code는 그 외의 위치에서 설정된 포트를 무시합니다. v2.1.285 이전에는 모든 설정 파일에서 포트를 설정할 수 있었습니다.

> [!WARNING]
>
> 두 포트 중 하나라도 적용되면 프록시로 전송되는 모든 항목을 필터링하는 책임은 사용자의 프록시에 있습니다. `allowedDomains`, `deniedDomains`, `strictAllowlist`, 승인 프롬프트, [로컬 주소 검사](#hostnames-that-resolve-to-local-addresses)와 같은 Claude Code 자체의 네트워크 제어는 해당 트래픽에 더 이상 적용되지 않습니다. 샌드박싱된 명령은 두 프록시 중 어느 쪽에도 연결할 수 있으므로, 포트를 하나만 설정하면 다른 프록시에 대한 Claude Code의 도메인 목록은 명령이 사용자의 프록시를 통해 접근하는 대상을 제한하지 않습니다.

## 문제 해결

일부 명령은 샌드박스 외부에서는 작동하지만 샌드박스 내에서는 실패합니다. 증상이나 오류 메시지와 일치하는 제목을 찾습니다.

조직의 샌드박스가 [관리자 필수](#repository-settings-under-an-admin-required-sandbox)인 경우 Claude Code는 이러한 해결 방법에서 언급하는 설정을 프로젝트의 설정 파일에서 무시하므로, 모든 프로젝트에 적용되는 `~/.claude/settings.json`에 저장합니다. 해결 방법이 여전히 효과가 없다면 조직의 관리형 설정에서 해당 키를 설정하고 있을 수 있습니다.

`excludedCommands` 패턴을 추가하는 해결 방법은 해당 패턴과 일치하는 명령에서 샌드박스를 제거합니다. [제외된 명령이 할 수 있는 작업](#run-commands-outside-the-sandbox-with-excludedcommands)을 참조하세요.

### 명령이 host-not-allowed 오류로 실패

많은 CLI 도구는 특정 호스트에 도달해야 합니다. 확인 요청이 표시되면 호스트를 승인하거나 [`allowedDomains`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-alloweddomains)에 추가합니다. 조직에서 `allowManagedDomainsOnly`로 허용 목록을 잠근 경우 프롬프트가 표시되지 않으므로 관리자에게 호스트 추가를 요청합니다.

### `jest`가 중단되거나 실패

`watchman`은 샌드박스와 호환되지 않습니다. 대신 `jest --no-watchman`을 실행합니다.

### Go 기반 CLI가 macOS에서 TLS 검증 실패

`gh`, `gcloud`, `terraform`과 같은 도구는 [Seatbelt](#os-level-enforcement)에서 TLS 검증에 실패할 수 있습니다. 이러한 도구를 샌드박스 외부에서 실행하려면 각 도구에 대해 `gh *`와 같은 패턴을 [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands)에 추가합니다. 그러면 해당 도구는 사용자의 전체 액세스 권한과 저장된 자격 증명으로 실행됩니다. MITM 프록시 및 사용자 정의 CA와 함께 `httpProxyPort`를 사용하는 경우 대신 [`enableWeakerNetworkIsolation`](https://code.claude.com/docs/ko/settings-reference#sandbox-enableweakernetworkisolation)을 `true`로 설정합니다.

### `open`, `osascript`, 또는 브라우저 기반 인증 흐름이 macOS에서 오류 `-600`으로 실패

샌드박스는 기본적으로 Apple Events를 차단합니다. 사용자, 관리형 또는 CLI 설정에서 [`allowAppleEvents`](https://code.claude.com/docs/ko/settings-reference#sandbox-allowappleevents)를 `true`로 설정하여 이를 허용합니다. Claude Code는 프로젝트 설정에서 이 키를 무시합니다.

`allowAppleEvents`를 활성화하면 샌드박싱된 명령이 사용자 프롬프트 없이 다른 애플리케이션을 비샌드박싱된 상태로 시작할 수 있고 실행 중인 애플리케이션에 AppleScript 명령을 보낼 수 있으므로 코드 실행 격리가 제거됩니다. 이는 macOS 자동화 동의 프롬프트(TCC)의 적용을 받습니다. 또는 `open *`과 같은 패턴을 [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands)에 추가합니다. 그러면 각 `open` 호출이 권한 흐름을 거치며, `open`은 Claude가 작성한 파일이나 앱을 포함하여 모든 파일 또는 앱을 실행할 수 있습니다.

### `docker` 명령 실패

`docker`는 샌드박스와 호환되지 않습니다. `docker compose *`와 같은 `excludedCommands` 패턴으로 필요한 `docker` 명령을 샌드박스 밖으로 꺼냅니다. [`excludedCommands`로 샌드박스 외부에서 명령 실행](#run-commands-outside-the-sandbox-with-excludedcommands)에서는 제외된 `docker` 명령이 도달할 수 있는 범위를 설명합니다. 범위가 좁은 패턴일수록 샌드박스 밖으로 꺼내는 명령이 적어집니다.

### Chromium 또는 rootless Podman이 Linux의 샌드박스 내에서 실패

Linux 및 WSL2에서 샌드박스 내의 명령은 기본적으로 사용자 네임스페이스를 생성할 수 없으므로, 이에 의존하는 도구는 실패합니다.

* Chromium이 `No usable sandbox!`와 함께 종료됩니다
* `unshare -U true`가 `unshare: unshare failed: Operation not permitted`를 출력합니다. [`allowAllUnixSockets`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowallunixsockets)가 켜져 있으면 대신 `No space left on device`를 출력할 수 있습니다
* Rootless Podman이 `cannot clone: Operation not permitted`를 출력하거나, 자체 폴더 중 하나에서 `read-only file system`으로 더 일찍 중단됩니다

[`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`](https://code.claude.com/docs/ko/env-vars#variables)가 `1`로 설정된 세션에서는 Chromium 또는 Electron을 `--no-sandbox`로 시작하고, 그 밖의 도구는 Claude Code 외부에서 직접 실행합니다. 해당 세션에서는 [모든 명령이 샌드박스에서 실행되며](#turn-off-the-retry-with-strict-sandbox-mode), 아래의 다른 해결 방법에서 언급하는 설정은 효과가 없습니다.

각 해결 방법은 언급된 도구에 대해 작동하며, 일부 격리를 포기합니다.

* Chromium 또는 Electron의 경우 브라우저를 `--no-sandbox`로 시작합니다. Claude Code 샌드박스는 그대로 유지되지만, 브라우저는 자체 샌드박스 없이 웹 콘텐츠를 실행합니다.
* rootless Podman, Buildah, 또는 브라우저나 `unshare`를 실행하는 스크립트나 테스트 명령의 경우 `podman *`과 같은 패턴을 [`sandbox.excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands)에 추가합니다. 일치하는 명령은 사용자의 전체 액세스 권한으로 샌드박스 외부에서 실행되며, Claude는 실행하기 전에 작업 디렉터리의 스크립트를 편집할 수 있습니다. 패턴은 Claude가 실행하는 명령과 일치해야 하므로, 브라우저의 경우 브라우저가 아닌 테스트 명령과 일치시킵니다.
* Chromium 또는 Electron의 자체 샌드박스를 유지하거나 중첩된 bubblewrap 또는 `unshare`를 실행하려면 프로젝트의 `.claude/settings.json`이 아닌 `~/.claude/settings.json`에서 [`sandbox.allowNestedUserNamespaces`](https://code.claude.com/docs/ko/settings-reference#sandbox-allownestedusernamespaces)를 `true`로 설정합니다. Claude Code v2.1.305 이상이 필요합니다. `unshare`로 시작하는 명령은 `unshare`가 다른 모든 프로그램을 시작할 수 있으므로, 어떤 `excludedCommands` 패턴을 나열하든 샌드박스 내에 유지됩니다. 이 설정만으로는 rootless Podman이나 Buildah에 충분하지 않습니다. 샌드박스가 다른 방식으로도 이들을 중단시키기 때문입니다.

> [!WARNING]
>
> `allowNestedUserNamespaces`를 `true`로 설정하면 보안 경계가 꺼집니다. 샌드박싱된 명령의 코드가 결국 샌드박스 외부에서 실행될 수 있습니다.
>
> [보호된 경로](#protected-paths) 및 [`credentials.files`](https://code.claude.com/docs/ko/settings-reference#sandbox-credentials-files) 항목을 포함하여, 악성 명령을 막는 데 샌드박스의 어떤 제한에도 의존하지 마세요. [자동 허용 모드](#auto-allow-mode)에서는 해당 명령이 권한 프롬프트 없이 실행될 수 있습니다. 조직에 보안 팀이 있다면 이 설정을 켜기 전에 보안 팀과 확인하세요.

### `pbcopy`, `xclip`, 또는 `wl-copy`가 클립보드를 업데이트하지 않음

`pbcopy`, `xclip`, `wl-copy` 클립보드 유틸리티는 샌드박스 내에서 시스템 클립보드에 도달하지 못할 수 있으며, 이 경우 이들에게 파이프된 텍스트가 도착하지 않습니다.

Claude의 출력을 클립보드에 넣으려면 Claude에게 응답에서 인쇄하도록 요청한 다음 [`/copy`](https://code.claude.com/docs/ko/commands)를 실행합니다. `/copy`는 샌드박싱된 명령이 아닌 Claude Code 프로세스에서 클립보드에 씁니다.

Claude가 텍스트를 이러한 도구 중 하나로 파이프할 때, 도구를 [`excludedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-excludedcommands)에 추가해도 그 자체로는 그 호출을 샌드박스 외부로 꺼내지 않습니다.

### git 명령이 `unable to unlink old`로 실패

`git merge`, `git checkout` 및 유사한 명령은 샌드박스가 쓰기를 거부하는 파일을 교체해야 할 때 `unable to unlink old`로 실패합니다. Linux 및 WSL2에서 오류는 `Read-only file system`으로 끝납니다. 해당 파일은 다음 위치 중 하나에 있을 수 있습니다.

* `.claude/skills`와 같은 [보호된 경로](#protected-paths) 아래
* `denyWrite` 항목 중 하나 아래
* 샌드박스가 명령에 쓰기를 허용하는 디렉터리 외부

실패 후 Claude는 [명령을 샌드박스 외부에서 다시 실행하도록 제안](#the-unsandboxed-retry-escape-hatch)할 수 있습니다. 해당 재시도를 승인하거나 다른 터미널에서 git 명령을 직접 실행합니다. `allowUnsandboxedCommands`를 `false`로 설정한 경우 Claude는 재시도를 제안할 수 없으므로 명령을 직접 실행합니다.

### `objects` 또는 `refs`라는 폴더가 명령 후 사라짐

세션 중에 나타난 최상위 `objects` 또는 `refs` 폴더는 [샌드박싱된 명령이 끝난 후 삭제될](#when-the-sandbox-deletes-head-objects-or-refs) 수 있습니다. 명령, Claude, 사용자 중 누가 만들었는지는 관계없습니다. 폴더를 유지하려면 폴더 안에 무언가를 남겨 둡니다. 세션 중에 `HEAD` 파일이나 심볼릭 링크가 최상위에 있었다면 이를 다른 곳으로 옮긴 다음, 해당 작업 디렉터리에서 열려 있는 모든 Claude Code 세션을 다시 시작합니다.

v2.1.307 이전에는 `HEAD`가 없고 폴더 안에 무언가가 있어도 폴더가 삭제되었습니다. 이전 버전을 사용 중이라면 [Claude Code를 업데이트](https://code.claude.com/docs/ko/setup.md#update-claude-code)합니다.

### Bubblewrap이 컨테이너 내에서 시작 실패

권한 없는 컨테이너에서 [bubblewrap](#os-level-enforcement)은 새로운 `/proc` 파일시스템을 마운트할 수 없으므로 샌드박싱된 명령은 `bwrap` 오류(예: `Can't mount proc on /newroot/proc: Operation not permitted`)로 실패합니다. [`enableWeakerNestedSandbox`](https://code.claude.com/docs/ko/settings-reference#sandbox-enableweakernestedsandbox)를 `true`로 설정하여 샌드박스가 대신 컨테이너의 기존 `/proc`을 바인드 마운트하도록 합니다. 외부 컨테이너가 이미 필요한 격리 경계를 제공할 때만 이 설정을 사용합니다. 새로운 `/proc` 마운트가 숨길 프로세스 정보를 샌드박싱된 명령에 노출하기 때문입니다.

### 0바이트 읽기 전용 파일이 `.claude` 설정 경로에 나타나고 "예, 다시 묻지 않기"가 저장되지 않음

Linux 및 WSL2에서 샌드박스는 샌드박싱된 명령이 실행되는 동안 아직 존재하지 않는 파일에 대한 쓰기 거부를 해당 위치에 0바이트 읽기 전용 자리 표시자를 만들어 유지합니다. 샌드박스는 그 후 자리 표시자를 제거합니다.

다음과 같은 경우에는 자리 표시자가 남아 있습니다.

* 예를 들어 SIGKILL에 의해 세션이 정리 실행 전에 종료되는 경우
* 백그라운드 명령처럼 샌드박싱된 명령이 아직 실행 중인 상태에서 세션이 종료되는 경우

이후 세션은 매번 시작할 때마다 자리 표시자를 다시 읽기 전용으로 바인드하므로 권한 선택 저장과 같은 설정 쓰기가 자리 표시자가 남아 있는 경로에서 실패합니다.

터미널에서 `claude doctor`를 실행하여 남은 자리 표시자 파일을 나열합니다. [`Sandbox mask files left behind at write-deny paths`](https://code.claude.com/docs/ko/errors#stale-sandbox-mask-files-left-by-a-killed-session) 경고는 그중 일부의 이름을 표시하고 나머지는 개수로 표시합니다. 해당 프로젝트에서 다른 Claude Code 세션이 실행되지 않는 동안 `rm`으로 각 파일을 삭제합니다. v2.1.257 이전에는 세션이 종료될 때 Claude Code가 동일한 자리 표시자를 남겨두면서도 이를 알리지 않았습니다.

### 샌드박스가 켜진 상태에서 SSH를 통한 `git`이 실패

macOS에서는 SSH 원격 저장소에 대한 `git fetch`, `git pull`, `git push`가 호스트가 허용된 경우에도 샌드박스 내에서 실패합니다. Linux 및 WSL2에서는 호스트가 허용되면 작동합니다. Claude Code는 git의 SSH 연결을 [샌드박스 프록시](#network-isolation)를 통해 터널링하는데, macOS 터널은 해당 프록시에 인증할 수 없습니다.

Linux 및 WSL2에서 연결이 여전히 실패하면 다음을 확인합니다.

* **호스트가 포트 22에서 허용되는지**: `"git.example.com"`처럼 포트가 없는 `allowedDomains` 항목이 이를 포함합니다
* **회사 프록시가 포트 22를 허용하는지**: 네트워크에 업스트림 프록시가 필요한 경우 터널도 해당 프록시를 거칩니다
* **키를 파일로 읽을 수 있는지**: 샌드박스는 `ssh-agent` 소켓을 차단할 수 있으며, `~/.ssh`에 대한 `denyRead` 또는 `credentials` 항목은 키 파일을 숨깁니다

macOS에서는 원격 저장소를 HTTPS로 전환합니다. 이 경우 개인 액세스 토큰과 같은 HTTPS 자격 증명이 필요합니다.

```bash theme={null}
git remote set-url origin https://git.example.com/example-org/example-repo.git
```

SSH 원격 저장소를 유지해야 하는 경우 [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands)로 git의 네트워크 명령을 샌드박스 밖으로 꺼냅니다.

```json theme={null}
{
  "sandbox": {
    "excludedCommands": ["git fetch *", "git pull *", "git push *"]
  }
}
```

이 항목은 `git push origin main`과 일치합니다. `cd`를 추가하거나, `git -C`를 사용하거나, 명령 치환을 포함하는 호출은 샌드박스 내에 유지됩니다. 제외된 git 명령은 `allowedDomains`에 있는 호스트뿐만 아니라 모든 호스트에 도달할 수 있습니다.

SSH를 통한 일반 `ssh`, `scp`, `rsync`는 [데이터베이스 클라이언트 항목](#a-database-client-or-other-non-http-tool-fails-to-reach-an-allowed-host)에서 설명하는 이유로 실패합니다.

### 데이터베이스 클라이언트 또는 기타 비 HTTP 도구가 허용된 호스트에 도달하지 못함

프록시 환경 변수를 무시하는 도구는 `allowedDomains`에 있는 호스트라도 샌드박스 내에서 연결할 수 없습니다. 샌드박싱된 명령에는 [네트워크로 가는 직접 경로가 없으므로](#network-isolation), 자체 연결을 여는 도구는 실패합니다. 대부분의 데이터베이스 드라이버, 일반 `ssh`, UDP를 사용하는 도구가 이렇게 동작합니다.

실패는 네트워크 또는 이름 확인 오류처럼 보입니다.

* **macOS**: `Operation not permitted` 또는 `Could not resolve host`와 같은 이름 확인 오류
* **Linux 및 WSL2**: `Network is unreachable` 또는 `Temporary failure in name resolution`과 같은 이름 확인 오류

프록시를 사용하는 도구는 호스트가 허용되지 않았을 때 다르게 실패합니다. 네트워크 프롬프트가 표시되거나, 도구가 프록시로부터 `403` 응답을 받습니다.

도구가 연결할 수 있도록 하려면 해당 도구가 필요한 명령을 [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands)로 샌드박스 외부에서 실행합니다. 다음 예시는 스크립트 하나를 제외하고 [ask 규칙](https://code.claude.com/docs/ko/permissions.md)을 추가하여 각 실행을 승인하도록 합니다.

```json theme={null}
{
  "sandbox": {
    "excludedCommands": ["python scripts/load_orders.py *"]
  },
  "permissions": {
    "ask": ["Bash(python scripts/load_orders.py *)"]
  }
}
```

스크립트는 사용자의 전체 액세스 권한으로 실행되며, Claude는 작업 디렉터리 내의 스크립트를 편집할 수 있으므로 프롬프트가 표시되면 스크립트를 검토합니다.

### 명령이 localhost의 서버에 도달하지 못함

기본적으로 샌드박싱된 명령은 개발 서버나 컨테이너의 데이터베이스처럼 샌드박스 외부에서 사용자의 머신에서 실행 중인 서버에 직접 연결할 수 없습니다. 변경할 수 있는 사항은 플랫폼에 따라 다릅니다.

* **macOS**: [`network.allowLocalBinding`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowlocalbinding)을 `true`로 설정합니다. 그러면 샌드박싱된 명령이 네트워크 포트에서 수신 대기하고 localhost의 모든 포트에 연결할 수 있으며, 여기에는 그곳에서 수신 대기하는 다른 모든 서비스가 포함됩니다. 디버거처럼 인증이 필요 없는 localhost 서비스는 샌드박스 외부에서 명령을 대신하여 동작할 수 있고, 비 루프백 주소에서 수신 대기하는 명령은 다른 머신의 연결을 수락합니다
* **Linux 및 WSL2**: 샌드박싱된 명령의 `localhost`는 해당 명령 전용입니다. 명령은 포트에서 수신 대기하고 자신이 시작한 서버에 도달할 수 있습니다. `localhost` 또는 `127.0.0.1`에 대한 직접 연결은 호스트의 서버에 도달하지 않으며, `allowLocalBinding`은 효과가 없습니다. 호스트의 서버가 필요한 명령은 [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands)로 샌드박스 외부에서 실행하며, 이 경우 파일시스템이나 네트워크 제한이 없습니다. 샌드박스 프록시를 거치는 연결에 대해서는 [로컬 주소로 확인되는 호스트 이름](#hostnames-that-resolve-to-local-addresses)을 참조하세요

다음 예시는 macOS에서 이 설정을 켭니다.

```json theme={null}
{
  "sandbox": {
    "network": {
      "allowLocalBinding": true
    }
  }
}
```

`localhost`에 대한 `allowedDomains` 항목은 프록시를 거치는 연결에 적용되므로 직접 연결은 변경하지 않습니다. Claude Code는 샌드박싱된 명령이 프록시를 거치지 않고 `localhost`에 직접 연결하도록 `NO_PROXY`를 설정합니다. 또한 이 항목은 프록시를 사용하는 명령에 머신의 localhost 모든 포트를 노출합니다. `127.0.0.1`을 가리키는 개발용 호스트 이름에 대해서는 [허용된 호스트 이름이 `resolved to a loopback address`로 거부됨](#an-allowed-hostname-is-refused-with-resolved-to-a-loopback-address)을 참조하세요.

### 허용된 호스트 이름이 `resolved to a loopback address`로 거부됨

샌드박스 프록시는 [로컬 주소로 확인되는](#hostnames-that-resolve-to-local-addresses) 허용된 호스트 이름을 거부하며, 이는 `127.0.0.1`을 가리키는 `myapp.test`와 같은 개발용 이름에 영향을 줍니다. 명령은 `Connection to myapp.test blocked: resolved to a loopback address`처럼 본문에 주소 종류가 명시된 `403` 응답을 받습니다.

`allowedDomains`에 호스트 이름과 함께 해당 이름이 확인되는 IP 주소를 추가하고, 각각에 서버가 수신 대기하는 포트를 지정합니다.

```json theme={null}
{
  "sandbox": {
    "network": {
      "allowedDomains": ["myapp.test:3000", "127.0.0.1:3000"]
    }
  }
}
```

포트가 없는 IP 주소 항목은 샌드박싱된 명령이 해당 주소에서 수신 대기하는 모든 서비스에 도달할 수 있게 합니다.

v2.1.284 이전에는 프록시가 허용된 호스트 이름이 확인되는 주소가 무엇이든 연결했습니다.

### 명령이 `Sandbox is required`로 거부됨

[`sandbox.failIfUnavailable`](https://code.claude.com/docs/ko/settings-reference#sandbox-failifunavailable)로 샌드박스를 필수로 지정했는데 Claude Code가 시작된 후 샌드박스가 다음 중 한 가지 방식으로 실패하면, Claude가 실행하는 각 샌드박싱된 명령은 표시된 메시지와 함께 거부됩니다. 세션은 계속 실행되며, 거부된 명령은 샌드박스 없이 실행되지 않습니다.

* **`Sandbox is required but failed to initialize: <reason>`**: Claude Code는 시작되었지만 이후 샌드박스 초기화에 실패했습니다. 메시지에 표시된 조치(`Restart to retry.` 또는 `Fix the sandbox settings to retry`)를 따릅니다.
* **`Sandbox is required (sandbox.failIfUnavailable) and stopped being available in this session: <reason>`**: Linux 또는 WSL2에서 샌드박스가 시작된 후 Claude Code가 누락된 의존성을 발견했습니다. [누락된 의존성 설치](#set-up-linux-and-wsl2)처럼 이유에 명시된 문제를 해결한 다음 Claude Code를 다시 시작합니다.

제외된 명령과 사용자가 직접 입력한 명령은 계속 실행되며, Claude는 거부된 명령을 샌드박스 없이 재시도할 수 없습니다.

* **제외된 명령**: [`excludedCommands`](#run-commands-outside-the-sandbox-with-excludedcommands) 항목과 일치하는 명령은 샌드박스 외부에서 계속 실행됩니다. 이러한 명령이 작업 디렉터리 외부의 [`filesystem.allowWrite`](https://code.claude.com/docs/ko/settings-reference#sandbox-filesystem-allowwrite) 경로에 쓰면 해당 쓰기는 일반 권한 흐름을 거칩니다. [관리자 필수 샌드박스](#repository-settings-under-an-admin-required-sandbox)에서는 Claude Code가 저장소 설정의 항목을 무시합니다
* **[`!` 셸 모드 프롬프트](https://code.claude.com/docs/ko/interactive-mode#shell-mode-with-prefix)에서 입력한 명령**: 샌드박스 외부에서 계속 실행됩니다. [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)에서는 이 명령도 거부됩니다
* **샌드박스 없는 재시도**: Claude Code는 [샌드박스 없는 재시도](#the-unsandboxed-retry-escape-hatch)의 `dangerouslyDisableSandbox` 매개변수를 무시합니다

`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`가 설정된 Linux 세션에서는 모든 명령이 샌드박스에서 실행되므로, 제외된 명령과 사용자가 입력한 명령도 거부됩니다.

### `/sandbox`가 `Sandbox settings are overridden by a higher-priority configuration`으로 실패

더 높은 [설정 수준](https://code.claude.com/docs/ko/settings.md#settings-precedence)에서 `sandbox.enabled`, `sandbox.autoAllowBashIfSandboxed` 또는 `sandbox.allowUnsandboxedCommands`를 설정하면 `/sandbox`는 패널을 여는 대신 `Error: Sandbox settings are overridden by a higher-priority configuration and cannot be changed locally.`를 출력합니다. 패널은 선택 사항을 `.claude/settings.local.json`에 저장하는데, 그곳에 저장된 값은 해당 수준을 재정의할 수 없습니다.

관리형 설정과 `--settings`는 로컬 설정보다 우선순위가 높습니다. 이번 세션에서 이 중 무엇이 로드되었는지 확인하려면 `/status`를 실행하고 `Setting sources` 줄을 확인합니다.

* **`Command line arguments`**: [`--settings`](https://code.claude.com/docs/ko/settings#change-a-setting-for-one-session)로 Claude Code를 시작한 경우 전달한 파일 또는 JSON이 해당 키 중 하나를 설정하는지 확인합니다. 설정한다면 그곳에서 값을 변경하거나, 해당 키 없이 Claude Code를 다시 시작합니다.
* **`Enterprise managed settings`**: 조직의 관리형 설정이 로드되어 있습니다. 이 설정이 해당 키 중 하나를 설정한다면 `/sandbox`나 사용자가 제어하는 어떤 설정 파일에서도 해당 키를 변경할 수 없으므로 관리자에게 요청합니다.

### `/sandbox`가 `Sandbox settings not changed`를 출력

이 줄은 `/sandbox`가 패널에서 선택한 내용을 프로젝트의 `.claude/settings.local.json`에 저장하지 못했다는 의미입니다.

```text theme={null}
✗ Sandbox settings not changed: /home/you/project/.claude/settings.local.json couldn't be updated (EACCES). Start Claude Code in a project folder you can write to.
```

괄호 안의 이유가 `EACCES`, `EPERM` 또는 `EROFS`인 경우 쓰기 권한이 있는 프로젝트 폴더에서 Claude Code를 시작한 다음 해당 세션에서 `/sandbox`를 다시 실행합니다. 이유가 `Invalid JSON syntax in settings file`로 시작하는 경우 프로젝트의 `.claude/settings.local.json`에 있는 JSON을 수정한 다음 `/sandbox`를 다시 실행합니다.

쓰기 권한이 있는 프로젝트 폴더를 사용할 수 없는 경우 대신 사용자 설정에서 샌드박스를 켭니다. `~/.claude/settings.json`에 다음을 추가합니다.

```json theme={null}
{
  "sandbox": {
    "enabled": true
  }
}
```

이렇게 하면 [자동 허용 모드](#sandbox-modes)가 켜집니다. 일반 권한 모드를 사용하려면 [`sandbox.autoAllowBashIfSandboxed`](https://code.claude.com/docs/ko/settings-reference#sandbox-autoallowbashifsandboxed)도 `false`로 설정합니다. 변경 사항은 실행 중인 세션에서 Claude가 다음 셸 명령을 실행할 때 적용되며, 이후 `/sandbox`의 **Mode** 탭에 적용 중인 모드가 표시됩니다.

## 제한 사항

샌드박싱은 위험을 줄이지만 완전한 격리 경계는 아닙니다. 이를 하드 보안 제어로 사용하기 전에 아래 제한 사항을 검토합니다.

### 보안 제한 사항

* **네트워크 필터링**: 샌드박스는 프로세스가 연결할 수 있는 도메인을 제한합니다. 기본적으로 기본 제공 프록시는 아웃바운드 트래픽의 TLS를 종료하거나 검사하지 않으므로 암호화된 연결의 내용은 검사되지 않습니다. 실험적인 [`network.tlsTerminate`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-tlsterminate) 설정은 [`mask` 자격 증명 대체](#mask-credentials)를 위해 프록시에서 TLS를 종료하지만 콘텐츠 필터링을 추가하지 않습니다. 정책에서 신뢰할 수 있는 도메인만 허용하도록 보장하는 것은 사용자의 책임입니다.

> [!WARNING]
>
> `github.com`과 같은 광범위한 도메인을 허용하면 데이터 유출 경로가 생성될 수 있습니다. 프록시가 TLS를 검사하지 않고 클라이언트 제공 호스트 이름에서 허용 결정을 내리기 때문에 샌드박스 내에서 실행되는 코드는 잠재적으로 [도메인 프론팅](https://en.wikipedia.org/wiki/Domain_fronting) 또는 유사한 기술을 사용하여 허용 목록 외부의 호스트에 도달할 수 있습니다. 위협 모델이 더 강력한 보장을 요구하면 TLS를 종료하고 트래픽을 검사하는 [사용자 정의 프록시](#custom-proxy-configuration)를 구성하고 그 CA 인증서를 샌드박스 내에 설치합니다. 더 강력한 TLS 인식 네트워크 격리는 활발한 개발 영역입니다.

* **Unix 소켓을 통한 권한 상승**: `allowUnixSockets` 구성은 실수로 샌드박스 우회로 이어질 수 있는 시스템 서비스에 대한 액세스를 부여할 수 있습니다. 예를 들어 `/var/run/docker.sock`에 대한 액세스를 허용하면 Docker 소켓을 통해 호스트 시스템에 대한 액세스를 효과적으로 부여합니다. 샌드박스를 통해 허용하는 모든 Unix 소켓을 신중하게 고려합니다.
* **파일시스템 권한 상승**: 과도하게 광범위한 파일시스템 쓰기 권한은 권한 상승 공격을 가능하게 할 수 있습니다. `$PATH`의 실행 파일을 포함하는 디렉토리, 시스템 구성 디렉토리 또는 `.bashrc` 또는 `.zshrc`와 같은 사용자 셸 구성 파일에 대한 쓰기를 허용하면 다른 사용자 또는 시스템 프로세스가 이러한 파일에 액세스할 때 다른 보안 컨텍스트에서 코드 실행으로 이어질 수 있습니다.
* **Linux 샌드박스 강도**: Linux 구현은 강력한 파일시스템 및 네트워크 격리를 제공하지만 권한 있는 네임스페이스 없이 Docker 환경 내에서 작동할 수 있도록 하는 `enableWeakerNestedSandbox` 모드를 포함합니다. 이 옵션은 보안을 상당히 약화시키며 추가 격리가 다른 방식으로 적용되는 경우에만 사용해야 합니다.
* **macOS의 Apple Events**: macOS 샌드박스는 기본적으로 Apple Events를 차단합니다. `allowAppleEvents` 설정은 이 제한을 해제하여 `open` 및 `osascript`와 같은 도구가 작동하지만 코드 실행 격리를 제거합니다. 샌드박싱된 명령은 사용자 프롬프트 없이 다른 애플리케이션을 샌드박싱되지 않은 상태로 시작할 수 있으며 실행 중인 애플리케이션에 AppleScript 명령을 보낼 수 있습니다. 이는 앱별 macOS 자동화 동의 프롬프트(TCC)의 적용을 받습니다. 이는 사용자, 관리 또는 CLI 설정에서만 적용됩니다. 프로젝트 설정은 이를 활성화할 수 없습니다.
* **Linux 및 WSL2의 사용자 네임스페이스**: 기본적으로 샌드박싱된 명령은 사용자 네임스페이스를 생성할 수 없습니다. [`allowNestedUserNamespaces`](https://code.claude.com/docs/ko/settings-reference#sandbox-allownestedusernamespaces)를 `true`로 설정하면 보안 경계를 끄게 됩니다. 샌드박싱된 명령의 코드가 결국 샌드박스 외부에서 실행될 수 있습니다. 이 설정을 켜기 전에 [Linux에서 샌드박스 내 Chromium 또는 rootless Podman이 실패하는 경우](#chromium-or-rootless-podman-fails-inside-the-sandbox-on-linux)의 경고를 읽습니다.

### 범위

샌드박스는 셸 명령과 그 하위 프로세스를 격리합니다. [샌드박스 외부에서 실행되는 항목](#what-runs-outside-the-sandbox)에는 샌드박스가 다루지 않는 도구와 헬퍼 프로세스가 나열되어 있습니다. 컴퓨터 사용과 서브에이전트는 다음과 같이 샌드박스와 관련됩니다:

* **컴퓨터 사용**: Claude가 앱을 열고 화면을 제어할 때 격리된 환경이 아닌 실제 데스크톱에서 실행됩니다. 앱별 권한 프롬프트가 각 애플리케이션을 제어합니다. [CLI의 컴퓨터 사용](https://code.claude.com/docs/ko/computer-use.md) 또는 [Desktop의 컴퓨터 사용](https://code.claude.com/docs/ko/desktop.md#let-claude-use-your-computer)을 참조합니다.
* **서브에이전트**: [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)는 부모 세션과 동일한 프로세스에서 실행되며 동일한 샌드박스 구성을 사용합니다. 부모 세션에서 샌드박싱이 활성화되면 서브에이전트 내의 Bash 명령이 샌드박싱됩니다.
* **백그라운드 세션**: [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)은 자체 프로세스에서 실행되며, [해당 설정](https://code.claude.com/docs/ko/agent-view.md#settings-and-provider)에서 샌드박싱을 활성화하면 그 Bash 명령이 샌드박싱됩니다.
* **전체 프로세스를 둘러싼 경계**: [샌드박스 외부에서 실행되는 항목](#what-runs-outside-the-sandbox)에 나열된 프로세스도 경계 안에 두려면, 승인한 호스트로 제한된 네트워크 허용 목록과 함께 [샌드박스 런타임](https://code.claude.com/docs/ko/sandbox-environments.md#sandbox-runtime) 내에서 Claude Code(로컬 모드)를 실행하거나, 방화벽 스크립트가 포함된 [dev container](https://code.claude.com/docs/ko/devcontainer.md)에서 실행합니다. 백그라운드 서비스와 해당 서비스가 호스팅하는 세션에 대해서는 [회사 런처 뒤에서 Claude Code 실행](https://code.claude.com/docs/ko/corporate-launcher.md)을 참조합니다.
* **모드**: [모드](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 Claude Code 내에서 자체 코드를 실행하는 플러그인이며, 모드가 시작하는 프로세스는 샌드박스 외부에서 실행됩니다. [모드가 접근할 수 있는 범위](https://code.claude.com/docs/ko/plugins/mods/overview.md#what-a-mod-can-reach)를 참조합니다.

> [!WARNING]
>
> 효과적인 샌드박싱은 파일시스템 및 네트워크 격리 모두를 필요로 합니다. 네트워크 격리가 없으면 손상된 에이전트가 SSH 키와 같은 민감한 파일을 유출할 수 있습니다. 파일시스템 격리가 없으면 권한 있는 정책이나 [파일시스템 레이어 비활성화](#disable-filesystem-isolation)로 인해 손상된 에이전트가 시스템 리소스를 백도어하여 네트워크 액세스를 얻을 수 있습니다. 기본값을 확대할 때 `allowWrite` 경로, 광범위한 `allowedDomains` 항목 또는 `excludedCommands` 예외가 다른 쪽의 제한을 취소하지 않는지 확인합니다.

## 참고 항목

* [샌드박스 환경](https://code.claude.com/docs/ko/sandbox-environments.md): 기본 제공 샌드박스를 dev 컨테이너, 컨테이너 및 VM과 비교
* [보안](https://code.claude.com/docs/ko/security.md): 보안 기능 및 모범 사례
* [권한](https://code.claude.com/docs/ko/permissions.md): 권한 구성 및 액세스 제어
* [모든 설정](https://code.claude.com/docs/ko/settings-reference.md): 모든 설정 키
* [CLI 참조](https://code.claude.com/docs/ko/cli-reference.md): 명령줄 옵션
