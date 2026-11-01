> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 엔터프라이즈 네트워크 구성

> 프록시 서버, 사용자 정의 인증 기관(CA), 상호 전송 계층 보안(mTLS) 인증을 통해 엔터프라이즈 환경에서 Claude Code를 구성합니다.

Claude Code는 환경 변수를 통해 다양한 엔터프라이즈 네트워크 및 보안 구성을 지원합니다. 여기에는 회사 프록시 서버를 통한 트래픽 라우팅, 사용자 정의 인증 기관(CA) 신뢰, 향상된 보안을 위한 상호 전송 계층 보안(mTLS) 인증서를 사용한 인증이 포함됩니다.

Claude Code를 시작하기 전에 이러한 환경 변수를 설정합니다. 셸에서 내보낸 변수는 시작 시 한 번만 읽혀지므로, 실행 중인 세션은 나중에 셸 환경에 대한 변경 사항을 선택하지 않습니다.

> [!NOTE]
>
> 이 페이지에 표시된 모든 환경 변수는 [`settings.json`](https://code.claude.com/docs/ko/settings)에서도 구성할 수 있습니다.

## 프록시 구성

### 환경 변수

Claude Code는 표준 프록시 환경 변수를 준수합니다. Claude Desktop 세션에서 앱이 공급자 연결을 관리하는 경우, Claude Code는 관리되는 설정 및 `~/.claude/settings.json`에서만 읽습니다. 범위 규칙은 [mTLS 인증](#mtls-authentication)을 참조하십시오.

```bash theme={null}
# HTTPS 프록시 (권장)
export HTTPS_PROXY=https://proxy.example.com:8080

# HTTP 프록시 (HTTPS를 사용할 수 없는 경우)
export HTTP_PROXY=http://proxy.example.com:8080

# 특정 요청에 대해 프록시 우회 - 공백으로 구분된 형식
export NO_PROXY="localhost 192.168.1.1 example.com .example.com"
# 특정 요청에 대해 프록시 우회 - 쉼표로 구분된 형식
export NO_PROXY="localhost,192.168.1.1,example.com,.example.com"
# 모든 요청에 대해 프록시 우회
export NO_PROXY="*"
```

소문자 변형도 작동하며, Claude Code는 `https_proxy`, `HTTPS_PROXY`, `http_proxy`, `HTTP_PROXY` 순서로 설정된 첫 번째 변수를 사용합니다.

Claude Code는 `localhost`, `::1` 또는 `127.0.0.0/8`에 대한 WebSocket 연결을 프록시를 통해 보내지 않으므로 `NO_PROXY`에 루프백 항목을 추가할 필요가 없습니다.

> [!NOTE]
>
> Claude Code는 SOCKS 프록시를 지원하지 않습니다.

### 기본 인증

프록시에 기본 인증이 필요한 경우 프록시 URL에 자격 증명을 포함합니다:

```bash theme={null}
export HTTPS_PROXY=http://username:password@proxy.example.com:8080
```

> [!WARNING]
>
> 스크립트에 암호를 하드코딩하지 마십시오. 대신 환경 변수 또는 보안 자격 증명 저장소를 사용하십시오.

> [!TIP]
>
> 고급 인증(NTLM, Kerberos 등)이 필요한 프록시의 경우 인증 방법을 지원하는 LLM Gateway 서비스 사용을 고려하십시오.

## CA 인증서 저장소

기본적으로 Claude Code는 번들로 제공되는 Mozilla CA 인증서와 운영 체제의 인증서 저장소를 모두 신뢰합니다. OS 저장소를 읽으려면 `tls.getCACertificates`가 있는 런타임이 필요합니다. 네이티브 설치 프로그램은 항상 이를 포함하고 있으며, npm 설치는 Node 22.15 이상이 필요합니다. 이전 Node 버전에서는 번들로 제공되는 세트와 `NODE_EXTRA_CA_CERTS`만 적용됩니다. 엔터프라이즈 TLS 검사 프록시는 루트 인증서가 OS 신뢰 저장소에 설치되어 있고 런타임이 이를 읽을 수 있을 때 추가 구성 없이 작동합니다. 이러한 프록시가 gzip으로 압축된 요청 본문을 제대로 처리하지 못하는 경우 [`CLAUDE_CODE_GZIP_REQUEST_BODIES=0`](https://code.claude.com/docs/ko/env-vars)을 설정하여 Claude API, 텔레메트리, 아티팩트 게시 요청에 대한 압축을 끄십시오.

`CLAUDE_CODE_CERT_STORE`는 쉼표로 구분된 소스 목록을 허용합니다. 인식되는 값은 Claude Code와 함께 제공되는 Mozilla CA 세트의 경우 `bundled`, 운영 체제 신뢰 저장소의 경우 `system`입니다. 기본값은 `bundled,system`입니다.

번들로 제공되는 Mozilla CA 세트만 신뢰하려면:

```bash theme={null}
export CLAUDE_CODE_CERT_STORE=bundled
```

OS 인증서 저장소만 신뢰하려면:

```bash theme={null}
export CLAUDE_CODE_CERT_STORE=system
```

> [!NOTE]
>
> `CLAUDE_CODE_CERT_STORE`에는 전용 `settings.json` 스키마 키가 없습니다. `~/.claude/settings.json`의 `env` 블록에서 또는 프로세스 환경에서 직접 설정합니다.

## 사용자 정의 CA 인증서

엔터프라이즈 환경에서 사용자 정의 CA를 사용하는 경우 Claude Code를 구성하여 이를 직접 신뢰하도록 합니다:

```bash theme={null}
export NODE_EXTRA_CA_CERTS=/path/to/ca-cert.pem
```

## mTLS 인증

엔터프라이즈 환경에서 클라이언트 인증서 인증이 필요한 경우:

```bash theme={null}
# 인증용 클라이언트 인증서
export CLAUDE_CODE_CLIENT_CERT=/path/to/client-cert.pem

# 클라이언트 개인 키
export CLAUDE_CODE_CLIENT_KEY=/path/to/client-key.pem

# 선택 사항: 암호화된 개인 키의 암호
export CLAUDE_CODE_CLIENT_KEY_PASSPHRASE="your-passphrase"
```

Claude Code는 시작 시 인증서 및 키 파일을 읽고, [관리되는 설정](https://code.claude.com/docs/ko/server-managed-settings.md)의 `env` 블록을 조직에서 세션 중간에 변경할 때와 같이 설정을 적용할 때마다 다시 읽습니다.

인증서 및 키를 회전하려면 동일한 경로의 파일을 교체합니다. Claude Code는 재시작 없이 실행 중인 세션에서 교체를 선택합니다. API 요청이 연결 재설정 또는 TLS 핸드셰이크 오류와 같은 연결 수준 오류로 실패하면 두 파일을 다시 읽고 새 쌍으로 요청을 다시 시도합니다. v2.1.232 이전에는 Claude Code가 연결 오류 시 다시 읽지 않았으므로 다음 설정을 적용하거나 재시작할 때까지 이미 로드된 쌍을 유지했습니다.

Claude Code는 파일 변경을 감시하지 않고 실패한 요청에 응답하여 파일을 다시 읽습니다:

* **타이밍**: Claude Code는 파일을 교체하는 순간 아무것도 하지 않습니다. 적격 실패 후 재시도 시 또는 설정을 적용한 후 다음 요청 중 먼저 오는 것에서 새 쌍을 제시합니다.
* **게이트웨이 거부**: Claude Code는 게이트웨이가 이전 쌍을 더 이상 수락하지 않은 후 연결을 재설정하거나 TLS 핸드셰이크를 거부할 때 다시 읽습니다. 게이트웨이가 핸드셰이크를 완료하고 HTTP 오류로 응답할 때는 다시 읽지 않습니다. 이 경우 Claude Code는 다음 설정을 적용할 때 또는 재시작할 때 새 쌍을 로드합니다.
* **부분 작성 회전**: Claude Code가 회전이 진행 중일 때 다시 읽을 때, 예를 들어 서로 일치하지 않는 인증서 및 키를 읽을 때 이전 쌍을 유지하고 다음 실패 시 다시 읽습니다.
* **OTLP 텔레메트리 내보내기**: Claude Code는 [내보내기](https://code.claude.com/docs/ko/monitoring-usage.md#mtls-authentication)가 처음 사용할 때 로드한 인증서를 유지하므로 회전된 인증서가 텔레메트리 수집기에 도달하려면 Claude Code를 재시작합니다.
* **다시 로드 끄기**: [`CLAUDE_CODE_DISABLE_MTLS_RELOAD_ON_STALE_CONNECTION=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정하여 연결 오류 다시 읽기를 끕니다. Claude Code는 다음 설정을 적용할 때 또는 다음 시작 시에만 회전된 파일을 선택합니다.

Claude Code가 회전을 선택했는지 확인하려면 [디버그 로깅으로 세션을 시작](#verify-your-configuration)하고 로그에서 `Stale connection — reloaded rotated mTLS client material`을 찾습니다. Claude Code는 대신 설정을 적용하는 동안 회전을 선택할 때 이 줄을 기록하지 않으므로 누락된 줄만으로는 회전이 실패했다는 의미가 아닙니다.

Claude Code가 다음 시작 시 이미 만료된 쌍을 로드하지 않도록 현재 쌍이 만료되기 전에 파일을 교체합니다.

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에서 호스팅 환경은 API에 대한 연결을 관리하므로 Claude Code는 설정 파일 `env` 블록에서 오는 다음 변수를 무시합니다:

* `CLAUDE_CODE_CLIENT_CERT`
* `CLAUDE_CODE_CLIENT_KEY`
* `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE`
* `NODE_EXTRA_CA_CERTS`
* `NODE_TLS_REJECT_UNAUTHORIZED`
* `CLAUDE_CODE_OAUTH_SCOPES`

Claude Code는 세션의 디버그 로그에서 무시된 각 키를 기록합니다.

앱이 공급자 연결을 관리하는 [Claude Desktop](https://code.claude.com/docs/ko/desktop.md) 세션에서, 예를 들어 [타사 공급자](https://code.claude.com/docs/ko/third-party-integrations.md)의 Code 탭 및 Cowork 세션에서 Claude Code는 이러한 변수와 프록시 변수 `HTTP_PROXY`, `HTTPS_PROXY`, 및 `NO_PROXY`를 [관리되는 설정](https://code.claude.com/docs/ko/managed-settings.md) 및 `~/.claude/settings.json`에서만 읽습니다: 저장소의 자체 설정 파일에서는 무시하므로 체크아웃된 저장소는 앱에서 자격 증명이 오는 세션의 TLS 또는 프록시 경로를 리디렉션할 수 없습니다. claude.ai를 통해 로그인한 로컬, SSH 또는 WSL Code 탭 세션에서 앱은 연결을 관리하지 않으며 Claude Code는 모든 터미널 세션처럼 모든 설정 범위에서 이러한 변수를 읽습니다; [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)은 시작 위치에 관계없이 위의 클라우드 세션 규칙을 따릅니다. v2.1.217 이전에는 앱이 연결을 관리할 때 Claude Code가 모든 설정 파일에서 이러한 변수를 무시했습니다.

## 구성 확인

일반적으로 잘못된 프록시 주소나 잘못된 인증서 경로는 Claude Code가 이러한 설정을 읽을 때 대부분의 설정을 검증하지 않으므로 나중의 요청에서 [연결 또는 인증서 오류](https://code.claude.com/docs/ko/errors.md#network-and-connection-errors)로 알게 됩니다. 시작 시 확인하는 유일한 설정은 프록시 URL입니다. Claude Code가 `http://` 스킴이 없는 것처럼 값을 구문 분석할 수 없으면 Claude Code는 수정할 변수의 이름을 지정하는 오류와 함께 시작을 중지합니다.

요청을 보내기 전에 구성이 로드되었는지 확인하려면 디버그 로깅을 사용하여 Claude Code를 시작하세요:

```bash theme={null}
claude --debug
```

디버그 출력은 터미널이 아닌 `~/.claude/debug/<session-id>.txt`로 이동하거나 `--debug-file <path>`로 설정한 경로로 이동합니다. 로그에서 각 파일이 로드되었음을 확인하는 줄을 찾으세요:

```text theme={null}
CA certs: Appended extra certificates from NODE_EXTRA_CA_CERTS (/etc/ssl/certs/corp-ca.pem)
mTLS: Loaded client certificate from CLAUDE_CODE_CLIENT_CERT
mTLS: Loaded client key from CLAUDE_CODE_CLIENT_KEY
```

Claude Code가 이러한 파일 중 하나를 읽을 수 없으면 로그에 대신 이유와 함께 `Failed to read` 또는 `Failed to load` 줄이 표시됩니다.

대화형 세션에서 `/status`를 실행하고 다음 행을 확인할 수도 있습니다:

* **Proxy**: 활성 프록시 URL을 표시하고 구문 분석할 수 없는 값을 유효하지 않음으로 표시하고 무시합니다.
* **mTLS client cert** 및 **mTLS client key**: 파일이 로드되었을 때만 나타나므로 행이 없으면 로드가 실패했으며 디버그 로그에 이유가 있습니다.
* **Additional CA cert(s)**: 파일이 로드되었는지 확인하지 않고 `NODE_EXTRA_CA_CERTS` 경로를 표시하므로 디버그 로그에서 이를 확인하세요.

## 백그라운드 에이전트에 네트워크 설정 적용

[백그라운드 에이전트](https://code.claude.com/docs/ko/agent-view.md)는 이를 실행한 터미널 내부에서 실행되지 않습니다. 사용자별 감시자 프로세스가 필요에 따라 시작되어 셸보다 오래 유지되며 모든 `claude agents`, `--bg`, `/background` 세션을 호스팅합니다. [백그라운드 세션이 호스팅되는 방식](https://code.claude.com/docs/ko/agent-view.md#how-background-sessions-are-hosted)을 참조하십시오. 이는 이 페이지의 구성이 해당 세션에 도달하는 방식을 변경합니다.

### 셸이 아닌 설정에서 네트워크 변수 설정

감시자는 모든 터미널에서 공유하는 하나의 프로세스입니다. 이는 먼저 시작하는 셸의 환경을 상속합니다. 프록시, CA 경로 또는 mTLS 변수를 셸에서만 내보내면 해당 셸이 감시자를 콜드 스타트했을 때는 백그라운드 에이전트에 도달하지만, 다른 셸이 시작했을 때는 조용히 도달하지 않습니다.

대신 `~/.claude/settings.json`의 `env` 블록 또는 [관리되는 설정](https://code.claude.com/docs/ko/settings.md)에 동일한 변수를 입력하십시오. 이 페이지의 모든 변수를 여기에 설정할 수 있으며, 설정은 모든 머신의 모든 백그라운드 세션에 도달하는 유일한 구성입니다.

### 기업 런처를 설정으로 구성

일부 조직에서는 모든 Claude Code 프로세스가 샌드박싱, 네트워크 제어 또는 자격 증명 주입을 적용하는 기업 런처를 통해 시작되어야 합니다. 감시자와 그 워커는 `PATH`에서 `claude`를 조회하는 대신 고정된 경로에서 Claude Code를 시작하므로 모든 백그라운드 에이전트는 `PATH`의 앞에 배치한 래퍼를 우회합니다.

[`processWrapper`](https://code.claude.com/docs/ko/settings-reference#processwrapper) 설정을 감시자, 그 워커 및 [런처가 포함하는 항목](https://code.claude.com/docs/ko/corporate-launcher.md#what-the-launcher-covers)에 나열된 다른 백그라운드 프로세스 앞에 런처를 붙이도록 설정하십시오. 동등한 [`CLAUDE_CODE_PROCESS_WRAPPER`](https://code.claude.com/docs/ko/env-vars) 환경 변수는 둘 다 설정되었을 때 우선하며, 동일한 규칙이 적용됩니다. 셸 내보내기가 아닌 관리되는 설정 또는 `~/.claude/settings.json`을 통해 전달하십시오. [기업 런처 뒤에서 Claude Code 실행](https://code.claude.com/docs/ko/corporate-launcher.md)은 런처가 만족해야 하는 계약, 도달하는 항목과 도달하지 않는 항목, 그리고 배포 방법을 다룹니다.

> [!NOTE]
>
> 이미 실행 중인 감시자는 시작할 때 사용한 시작 구성을 유지합니다. 런처 설정을 배포한 후 [`claude daemon stop --any`](https://code.claude.com/docs/ko/agent-view#the-supervisor-process)를 실행하여 다음 `claude agents` 또는 `--bg`가 이를 준수하는 감시자를 시작하도록 하십시오.

## 스트리밍 유휴 워치독

Claude Code는 스트리밍 모델 응답이 잠잠해지면 이를 중단하는 네 개의 독립적인 타이머를 실행하므로, 끊긴 연결은 멈춘 채로 대기하는 대신 실패하고 재시도됩니다. 응답 헤더를 전혀 받지 못한 요청은 다음 두 가지 방식 중 하나로 종료됩니다.

* **첫 바이트 기한이 실행되는 경우**: 첫 번째 시도는 늦어도 해당 기한 내에 종료됩니다. 이를 변경하려면 `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`를 설정합니다. 재시도 대기 시간은 [No response from API](https://code.claude.com/docs/ko/errors.md#no-response-from-api)를 참조하세요.
* **그 외 연결의 경우**: 본문 유휴 타임아웃을 끄지 않았다면 요청은 본문 유휴 타임아웃이 발생하는 5\~6분 후에 종료됩니다. 요청을 더 빨리 종료하려면 `API_TIMEOUT_MS`를 낮춥니다. [Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 세션에서는 대신 [첫 바이트 기한을 켜서](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#retry-an-unanswered-request-sooner-with-the-first-byte-deadline) 첫 번째 시도를 더 빨리 종료할 수 있습니다.

| 타이머 | 중단 조건 | 실행 대상 | 기본 타임아웃 |
| :- | :- | :- | :- |
| 첫 바이트 기한 | Claude Code가 요청을 보낸 후 응답 헤더가 도착하지 않음 | 직접 Anthropic API 및 [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md)(HTTPS 프록시를 통한 연결 포함). 단, `ANTHROPIC_BASE_URL` 또는 `ANTHROPIC_AWS_BASE_URL`이 이를 [게이트웨이](https://code.claude.com/docs/ko/gateways.md)를 통해 라우팅하는 경우는 제외됩니다. [Claude apps 게이트웨이 세션](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#retry-an-unanswered-request-sooner-with-the-first-byte-deadline)과 `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1`을 설정한 Amazon Bedrock에서는 옵트인 방식이며, Google Cloud의 Agent Platform 또는 Microsoft Foundry에서는 실행되지 않습니다 | 직접 Anthropic API에서는 180초, Claude Platform on AWS 또는 Amazon Bedrock에서는 300초이며, 요청 본문 32KB당 1초가 추가됩니다 |
| 이벤트 수준 워치독 | 파싱되는 응답 이벤트가 없음. 바이트 수준 워치독이 Amazon Bedrock 이외의 연결에서 실행되는 경우, keep-alive ping을 포함해 도착하는 바이트도 파싱된 이벤트 없이 제한된 시간 동안 이 워치독을 재설정합니다. 이 시간은 바이트가 최소 10초마다 도착할 때 약 5분입니다. Claude apps 게이트웨이의 15초 간격 ping에서는 약 7.5분이므로, 기본 타임아웃에서 ping만 있는 스트림은 약 12.5분 후에 종료됩니다. | 모든 제공업체 | 300초 |
| 바이트 수준 워치독 | SSE keep-alive ping을 포함해 네트워크로 바이트가 도착하지 않음 | 직접 Anthropic API, [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md), 사용자 지정 `ANTHROPIC_BASE_URL`을 포함한 [게이트웨이](https://code.claude.com/docs/ko/gateways.md) 연결. `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1`을 설정하면 Amazon Bedrock `vnd.amazon.eventstream` 응답에서 옵트인 방식으로 실행되며, Google Cloud의 Agent Platform 또는 Microsoft Foundry에서는 실행되지 않습니다 | 직접 Anthropic API에서는 180초. Claude Platform on AWS, Amazon Bedrock, [Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 세션, 사용자 지정 `ANTHROPIC_BASE_URL`을 통한 연결에서는 300초 |
| 본문 유휴 타임아웃 | 응답 헤더 대기 시간을 포함해 5분 동안 바이트가 도착하지 않음 | 직접 Anthropic API, Claude Platform on AWS, `CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1`을 설정한 Amazon Bedrock 이외의 제공업체. 단, [`API_FORCE_IDLE_TIMEOUT`](https://code.claude.com/docs/ko/env-vars)으로 이를 변경할 수 있습니다 | 5분 |

`CLAUDE_ENABLE_BYTE_WATCHDOG_BEDROCK=1`을 설정하면 Bedrock에서 바이트 수준 워치독은 본문 유휴 타임아웃과 함께 실행되는 것이 아니라 이를 대체합니다. 이 경우 `CLAUDE_STREAM_IDLE_TIMEOUT_MS`는 아래에 나열된 한도 내에서 Claude Code가 연결이 끊긴 것으로 간주하기 전까지 Bedrock 스트림이 침묵 상태를 유지할 수 있는 시간도 제어합니다. Bedrock에서는 도착하는 바이트가 여전히 이벤트 수준 워치독을 재설정하지 않습니다. 디버그 로깅이 켜져 있으면 각 Bedrock 스트림은 `wire-heartbeat: _chunkTimes absent`로 시작하는 디버그 메시지를 로그에 기록합니다.

다음 변수로 타이머를 구성합니다. 각 변수에 대한 자세한 내용은 [환경 변수 레퍼런스](https://code.claude.com/docs/ko/env-vars.md)에 있습니다.

* `CLAUDE_ENABLE_STREAM_WATCHDOG`과 `CLAUDE_ENABLE_BYTE_WATCHDOG`은 표에 나열된 연결 내에서 `1`로 해당 워치독을 강제로 켜거나 `0`으로 강제로 끕니다. 두 변수 모두 워치독이 다루지 않는 연결 유형으로 워치독을 확장하지는 않습니다. `CLAUDE_ENABLE_BYTE_WATCHDOG`을 `0`으로 설정하면 첫 바이트 기한도 꺼집니다.
* `CLAUDE_STREAM_IDLE_TIMEOUT_MS`는 두 워치독의 타임아웃을 모두 설정합니다. Claude Code는 5분 미만의 값을 5분으로 올리며, 바이트 수준 워치독의 경우 값을 30분으로 제한합니다.
* `CLAUDE_BYTE_STREAM_IDLE_TIMEOUT_MS`는 이벤트 수준 워치독의 타임아웃을 변경하지 않고 바이트 수준 워치독의 타임아웃을 설정하며, 값은 10초에서 30분 사이로 제한됩니다. 해당 워치독에 대해서는 `CLAUDE_STREAM_IDLE_TIMEOUT_MS`보다 우선합니다.
* `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`는 첫 바이트 기한을 설정합니다. Claude apps 게이트웨이 세션에서는 이 변수를 설정하여 [기한을 켭니다](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#retry-an-unanswered-request-sooner-with-the-first-byte-deadline). 기한이 실행되는 다른 연결에서 이 변수를 설정하지 않으면 Claude Code는 바이트 수준 워치독의 타임아웃을 사용하므로, `CLAUDE_STREAM_IDLE_TIMEOUT_MS`와 `CLAUDE_BYTE_STREAM_IDLE_TIMEOUT_MS`도 기한을 변경합니다. 값의 한도는 [No response from API](https://code.claude.com/docs/ko/errors.md#no-response-from-api)를 참조하세요.
* `API_TIMEOUT_MS`는 응답 헤더 대기 시간을 제한하며, 헤더 이후 응답이 스트리밍되는 시간은 제한하지 않습니다. 첫 바이트 기한이 실행되지 않는 경우, 응답 없는 요청을 5분 이내에 재시도하려면 `API_TIMEOUT_MS`를 `300000` 미만의 양수 값으로 설정합니다. `API_TIMEOUT_MS`는 예상되는 가장 긴 헤더 대기 시간과 가장 긴 [비스트리밍 요청](https://code.claude.com/docs/ko/errors.md#streaming-response-ended-before-any-complete-data-was-received)보다 크게 유지하세요. 그보다 오래 걸리는 요청은 재시도할 때마다 다시 시간 초과됩니다.
* `API_FORCE_IDLE_TIMEOUT`을 `0`으로 설정하면 본문 유휴 타임아웃이 꺼지고, `1`로 설정하면 모든 제공업체에서 켜집니다. 워치독은 이 변수와 독립적으로 실행되므로, 스트림이 워치독의 임계값보다 오래 일시 정지할 수 있도록 하려면 워치독의 값도 높이거나 워치독을 비활성화해야 합니다.

워치독이 멈춘 스트림을 중단하면 Claude Code는 이 중단을 스트림 도중 실패로 처리하며, 표시되는 내용은 응답이 얼마나 진행되었는지에 따라 달라집니다. Claude Code는 요청을 재시도하거나 오류와 함께 턴을 종료하거나, 완료된 출력을 유지하고 [불완전한 응답 알림](https://code.claude.com/docs/ko/errors.md#the-response-above-may-be-incomplete)을 표시하거나, 턴을 정상적으로 종료합니다. 각 결과가 적용되는 경우는 [자동 재시도](https://code.claude.com/docs/ko/errors.md#automatic-retries)에서 설명합니다.

[비대화형 세션](https://code.claude.com/docs/ko/headless.md)에서, 그리고 모든 세션의 서브에이전트 응답에 대해서는 Claude Code가 먼저 Claude에게 중단된 응답을 이어서 작성하도록 프롬프트할 수 있습니다. 언제 그렇게 하는지와 언제 여전히 알림이 표시되는지는 [해당 알림 항목](https://code.claude.com/docs/ko/errors.md#the-response-above-may-be-incomplete)에서 설명합니다.

첫 바이트 기한이 발생하면 아직 응답이 시작되지 않았으므로 유지할 부분 출력이 없습니다. Claude Code가 요청을 다시 보내는 방식과 대신 턴이 종료되는 경우는 [No response from API](https://code.claude.com/docs/ko/errors.md#no-response-from-api)를 참조하세요.

## 네트워크 액세스 요구사항

Claude Code는 다음 URL에 대한 액세스가 필요합니다. 특히 컨테이너화되거나 제한된 네트워크 환경에서 프록시 구성 및 방화벽 규칙에 이러한 URL을 허용 목록에 추가하십시오. 첫 실행 설정 연결 확인은 `api.anthropic.com` 또는 `platform.claude.com`에 도달할 수 없을 때 여기를 가리킵니다. 확인 메시지 및 복구 단계는 [Anthropic 서비스에 연결할 수 없음](https://code.claude.com/docs/ko/errors.md#unable-to-connect-to-anthropic-services)을 참조하십시오.

| URL | 필요한 용도 |
| - | - |
| `api.anthropic.com` | Claude API 요청, WebFetch [도메인 안전 확인](https://code.claude.com/docs/ko/data-usage.md#webfetch-domain-safety-check), 기능 플래그 가져오기 및 원격 분석 이벤트 로깅 포함 |
| `claude.ai` | claude.ai 계정 인증 |
| `claude.com` | claude.ai 계정 로그인이 브라우저에서 `claude.com` 페이지를 열고, 이는 `claude.ai`로 리디렉션됩니다. 사전 승인된 WebFetch 문서 조회도 CLI에서 이 호스트에 도달합니다 |
| `platform.claude.com` | Anthropic Console 계정 인증. OAuth 토큰 교환, 새로 고침 및 취소도 claude.ai 계정의 경우 이 호스트로 이동하므로 Console 및 claude.ai 로그인 모두 필요합니다 |
| `sso.claude.com` | SSO(Single Sign-On)를 사용하는 조직의 브라우저 로그인 흐름의 일부. 프록시가 이 호스트를 차단하면 해당 로그인이 실패할 수 있습니다 |
| `mcp-proxy.anthropic.com` | [claude.ai의 MCP 커넥터](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai), 조직 관리자가 구성하는 커넥터 포함. 커넥터 트래픽은 이 프록시를 통해 라우팅되며, claude.ai 인증 사용자의 경우 기본적으로 활성화됩니다. Claude Code가 커넥터를 가져오지 않도록 하려면 [`ENABLE_CLAUDEAI_MCP_SERVERS=false`](https://code.claude.com/docs/ko/env-vars)를 설정하거나 [`disableClaudeAiConnectors`](https://code.claude.com/docs/ko/settings-reference#disableclaudeaiconnectors) 설정을 사용하십시오 |
| `downloads.claude.ai` | 플러그인 실행 파일 다운로드, 네이티브 설치 프로그램, 네이티브 자동 업데이터 및 업데이트 버전 확인 |
| `storage.googleapis.com` | `/plugin`에 표시되는 플러그인 설치 횟수 및 메타데이터 |
| `storage.googleapis.com` | 2.1.116 이전 버전의 네이티브 설치 프로그램 및 네이티브 자동 업데이터 |
| `registry.npmjs.org` | 플러그인 설치(npm 소스 플러그인 패키지 가져오기 및 플러그인의 Node.js 패키지 종속성 설치), `npx` 실행 MCP 서버 및 Claude Code 자체의 npm 및 bun 설치를 위한 패키지 레지스트리 |
| `bridge.claudeusercontent.com` | [Chrome의 Claude](https://code.claude.com/docs/ko/chrome.md) 확장 프로그램 WebSocket 브리지 |
| `*.frame.claudeusercontent.com` | [Artifact](https://code.claude.com/docs/ko/artifacts.md) 콘텐츠 읽기. CLI는 Claude가 Artifact를 열 때 이 호스트에서 Artifact의 파일을 가져오며, Artifact 도구가 계정에 [사용 가능](https://code.claude.com/docs/ko/artifacts.md#availability)할 때만 가져옵니다. 도구를 끄고 이 요구사항을 제거하려면 [`"enableArtifact": false`](https://code.claude.com/docs/ko/settings-reference#enableartifact) 또는 [`CLAUDE_CODE_DISABLE_ARTIFACT=1`](https://code.claude.com/docs/ko/env-vars)을 설정하십시오 |
| `github.com` | GitHub 호스팅 [플러그인 마켓플레이스](https://code.claude.com/docs/ko/plugins/overview.md) 및 플러그인 복제, 공식 Anthropic 마켓플레이스 포함, HTTPS 또는 SSH를 통해. GitHub `owner/repo` 소스를 HTTPS를 통해서만 복제하려면 [`CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1`](https://code.claude.com/docs/ko/env-vars)을 설정하십시오 |
| `raw.githubusercontent.com` | [`/release-notes`](https://code.claude.com/docs/ko/commands)에 대한 변경 로그 피드. 대화형 세션에서 Claude Code는 캐시된 변경 로그가 실행 중인 버전을 아직 다루지 않을 때(예: 업데이트 후 첫 시작) 시작 시 백그라운드에서도 가져옵니다. 비대화형 및 클라우드 세션은 절대 가져오지 않습니다 |
| `*-review.googlesource.com` | `googlesource.com` 체크아웃에서 Gerrit 변경 조회. Claude Desktop Code 탭 세션이 `origin`이 `googlesource.com` 호스트인 [신뢰할 수 있는](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust) 체크아웃에서 시작되거나 재개될 때, Claude Code는 HEAD의 `Change-Id`와 일치하는 열린 변경에 대해 해당 호스트의 `-review` 서버에 익명으로 한 번 요청합니다. 다른 세션 유형은 조회를 건너뛰며, 다른 Gerrit 호스트는 연결되지 않습니다. 선택 사항: [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](https://code.claude.com/docs/ko/env-vars)으로 비활성화 |
| `http-intake.logs.us5.datadoghq.com` | 운영 원격 분석 이벤트, CLI가 Anthropic API를 직접 사용할 때만 전송되며, Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry의 경우는 절대 전송되지 않습니다. 선택 사항: [`DISABLE_TELEMETRY`](https://code.claude.com/docs/ko/data-usage#telemetry-services) 또는 `DO_NOT_TRACK`으로 비활성화 |
| `browser-intake-us5-datadoghq.com` | CLI가 Anthropic API를 직접 사용하고 서버 측 롤아웃 게이트가 활성화할 때 전송되는 운영 오류 보고서. 선택 사항: `DISABLE_ERROR_REPORTING` 또는 `DISABLE_TELEMETRY`로 비활성화. [원격 분석 서비스](https://code.claude.com/docs/ko/data-usage.md#telemetry-services)를 참조하십시오 |
| `formulae.brew.sh` | Homebrew 설치에서 버전 확인을 업데이트합니다. 다른 설치 방법은 이 호스트에 연결하지 않습니다 |
| `code.claude.com` | 기본 제공 claude-code-guide 에이전트 및 사전 승인된 WebFetch 요청에 의한 Claude Code 문서 조회. 이 호스트를 차단하면 문서 조회에만 영향을 미칩니다 |

npm을 통해 Claude Code를 설치하거나 자신의 바이너리 배포를 관리하는 경우, 최종 사용자는 네이티브 설치 프로그램의 `downloads.claude.ai` 및 자동 업데이터 사용이 필요하지 않지만, npm 및 bun 설치는 조직이 미러링하지 않는 한 패키지 레지스트리인 `registry.npmjs.org`가 필요합니다. 표의 다른 사용은 설치 방법에 관계없이 적용됩니다.

두 개의 Datadog 수집 호스트는 선택적 운영 원격 분석만 전달하며, [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](https://code.claude.com/docs/ko/env-vars)을 설정하면 둘 다 비활성화됩니다. 타사 제공자의 세션은 플랫폼이 [`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](https://code.claude.com/docs/ko/env-vars)를 설정하고 원격 분석 메트릭이 기본적으로 켜져 있더라도 이러한 호스트로 절대 전송하지 않습니다. Claude Code가 전송하는 모든 것과 허용 목록을 최종화하기 전에 비활성화하는 방법은 [원격 분석 서비스](https://code.claude.com/docs/ko/data-usage.md#telemetry-services)를 참조하십시오.

### 클라우드 제공자 및 LLM 게이트웨이 라우팅

[Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md), [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md) 또는 로그인한 [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 세션을 사용할 때, 모델 트래픽 및 인증은 `api.anthropic.com`, `claude.ai` 또는 `platform.claude.com` 대신 제공자 또는 게이트웨이로 이동합니다. WebFetch 도구는 [설정](https://code.claude.com/docs/ko/settings.md)에서 `skipWebFetchPreflight: true`를 설정하지 않는 한 여전히 [도메인 안전 확인](https://code.claude.com/docs/ko/data-usage.md#webfetch-domain-safety-check)을 위해 `api.anthropic.com`을 호출합니다.

개발자가 [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/llm-gateway-connect#set-the-base-url-and-credential)로 설정된 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 뒤에서 [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md)를 사용하는 경우, 프록시를 통해 `api.anthropic.com`에 도달할 수 있도록 유지하십시오. Claude Code가 빠른 모드 가용성 확인을 전송할 때, 이 확인은 구성된 HTTP 프록시를 통해 해당 호스트로 전송되며 게이트웨이로는 절대 전송되지 않습니다. 확인이 전송되지 않는 경우와 각 경우에 빠른 모드를 복원하는 변수는 [프록시 및 LLM 게이트웨이 뒤에서 빠른 모드 사용](https://code.claude.com/docs/ko/fast-mode.md#use-fast-mode-behind-proxies-and-llm-gateways)을 참조하십시오.

### 조직 IP 허용 목록 및 프록시 송신

조직에 Claude에 대한 [IP 허용 목록](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting)이 활성화되어 있는 경우, `bridge.claudeusercontent.com`을 `claude.ai` 및 `api.anthropic.com`과 동일한 프록시 송신을 통해 라우팅하십시오. 예를 들어 동일한 Zscaler 앱 세그먼트 또는 Netskope 스티어링 정책에 배치하십시오. 그렇게 할 수 없는 경우, 프록시가 해당 호스트에 사용하는 송신 주소를 조직의 IP 허용 목록에 추가하되, 해당 주소가 조직에 전용되는 경우에만 추가하십시오. 공유 프록시 송신 범위는 프록시 공급업체의 다른 고객도 허용합니다.

Anthropic은 조직의 IP 허용 목록에 대한 `bridge.claudeusercontent.com` 연결을 도착 주소를 사용하여 확인합니다. 프록시가 해당 호스트의 트래픽을 해당 허용 목록에 없는 주소를 통해 전송하는 경우, Claude Code의 나머지 부분이 작동하더라도 [Chrome의 Claude](https://code.claude.com/docs/ko/chrome.md) 확장 프로그램에 연결할 수 없습니다.

### GitHub 허용 목록 및 방화벽

Anthropic 호스팅 환경의 [웹의 Claude Code](https://code.claude.com/docs/ko/claude-code-on-the-web.md) 및 [코드 검토](https://code.claude.com/docs/ko/code-review.md)는 Anthropic 관리 인프라에서 리포지토리에 연결합니다. [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)의 세션은 실행자가 [Anthropic git 프록시](https://code.claude.com/docs/ko/self-hosted-environments-deploy.md#use-the-anthropic-git-proxy)를 선택하지 않는 한 네트워크 내부에서 연결하며, 이는 Anthropic 측에서 가져옵니다.

GitHub Enterprise Cloud 조직이 IP 주소로 액세스를 제한하는 경우, [설치된 GitHub 앱에 대한 IP 허용 목록 상속](https://docs.github.com/en/enterprise-cloud@latest/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/managing-allowed-ip-addresses-for-your-organization#allowing-access-by-github-apps)을 활성화하고 Anthropic의 [아웃바운드 IP 주소](https://platform.claude.com/docs/en/api/ip-addresses#outbound-ip-addresses)에 대한 [허용 목록 항목을 추가](https://docs.github.com/en/enterprise-cloud@latest/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/managing-allowed-ip-addresses-for-your-organization#adding-an-allowed-ip-address)하십시오. 상속은 Claude GitHub 앱이 설치로 수행하는 요청만 다루며, 사용자를 대신하여 수행하는 요청은 다루지 않습니다. 다른 방화벽의 경우 [Anthropic API IP 주소](https://platform.claude.com/docs/en/api/ip-addresses)를 참조하십시오.

방화벽 뒤의 자체 호스팅 [GitHub Enterprise Server](https://code.claude.com/docs/ko/github-enterprise-server.md) 인스턴스의 경우, Anthropic 인프라가 GHES 호스트에 도달하여 리포지토리를 복제하고 검토 의견을 게시할 수 있도록 Anthropic의 [아웃바운드 IP 주소](https://platform.claude.com/docs/en/api/ip-addresses#outbound-ip-addresses)를 허용 목록에 추가하십시오. [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments-deploy.md#configure-git)의 세션은 네트워크 내부에서 GHES 호스트에 도달하므로, 해당 노출은 Anthropic 호스팅 세션, 리포지토리 선택기와 같은 호스팅 사전 세션 흐름 및 [Anthropic git 프록시](https://code.claude.com/docs/ko/self-hosted-environments-deploy.md#use-the-anthropic-git-proxy)를 선택하는 자체 호스팅 실행자에만 적용되며, 이는 Anthropic 측에서 가져옵니다. [SCM 커넥터](https://code.claude.com/docs/ko/self-hosted-environments-reference.md#scm-connector-flags)는 사용할 수 없으므로, 호스팅된 사전 세션 흐름은 네트워크 내부에서만 라우팅 가능한 GHES 호스트에 도달할 수 없습니다.

### 데스크톱 및 claude.ai

앞의 표는 독립 실행형 CLI를 다룹니다. Claude Desktop 앱 및 브라우저의 claude.ai는 `assets-proxy.anthropic.com` 및 해당 앱에서 [Artifact](https://code.claude.com/docs/ko/artifacts.md)를 제공하는 다른 `*.claudeusercontent.com` 원본을 포함한 추가 Anthropic CDN 호스트에서 애플리케이션 코드 및 사용자 콘텐츠를 로드합니다. `claude.ai`를 허용하면서 해당 호스트를 차단하면 오류 대신 빈 페이지가 생성됩니다. Desktop 페이지의 [네트워크 액세스 요구사항](https://code.claude.com/docs/ko/desktop.md#network-access-requirements)을 참조하십시오.

Claude Desktop 및 claude.ai는 일부 커넥터가 제공하는 [MCP Apps](https://claude.com/docs/connectors/building/mcp-apps/getting-started)와 같이 대화 내의 일부 도구 결과를 대화형 위젯으로 렌더링하기도 합니다. 이러한 위젯은 `claudemcpcontent.com`의 생성된 하위 도메인에서 로드되므로, 와일드카드를 그대로 유지하여 `*.claudemcpcontent.com`을 허용하십시오. 이를 차단하면 앱의 나머지 부분은 계속 작동하지만 해당 위젯은 로드되지 않습니다.

#### 아티팩트 글꼴 및 라이브러리용 타사 호스트

[Google Fonts](https://code.claude.com/docs/ko/artifacts.md#improve-the-visual-design)에서 글꼴을 로드하는 [Artifact](https://code.claude.com/docs/ko/artifacts.md)는 `fonts.googleapis.com` 및 `fonts.gstatic.com`도 요청합니다. 두 호스트 모두 선택 사항입니다. 차단하면 Artifact는 대체 글꼴로 렌더링됩니다. 글꼴 요청이 페이지의 첫 렌더링을 지연시키는 대신 즉시 실패하도록 빠른 거부로 차단하십시오.

Artifact는 또한 React 또는 차트 패키지와 같은 JavaScript 라이브러리를 `cdnjs.cloudflare.com`, `cdn.jsdelivr.net`, `cdn.tailwindcss.com`, `code.jquery.com` 및 `unpkg.com`에서 로드할 수 있으며, 다른 외부 호스트에서는 로드할 수 없습니다. 해당 호스트를 차단하면 라이브러리에 종속된 Artifact의 부분이 작동하지 않으며, 차단된 글꼴과 달리 차단된 라이브러리는 대체가 없습니다. 차단된 라이브러리 요청이 시간 초과될 때까지 중단되는 대신 즉시 실패하도록 빠른 거부로 차단하십시오.

## 추가 리소스

* [설정 파일 및 우선순위](https://code.claude.com/docs/ko/settings.md)
* [환경 변수 참조](https://code.claude.com/docs/ko/env-vars.md)
* [문제 해결 가이드](https://code.claude.com/docs/ko/troubleshooting.md)
