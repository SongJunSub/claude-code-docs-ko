> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 모니터링

> Claude Code에 대한 OpenTelemetry를 활성화하고 구성하는 방법을 알아봅니다.

OpenTelemetry(OTel)를 통해 텔레메트리 데이터를 내보내 조직 전체에서 Claude Code 사용, 비용 및 도구 활동을 추적합니다. Claude Code는 표준 메트릭 프로토콜을 통해 메트릭을 시계열 데이터로 내보내고, 로그/이벤트 프로토콜을 통해 이벤트를 내보내며, 선택적으로 [OpenTelemetry를 통한 분산 추적](#traces-beta)을 내보냅니다.

> [!NOTE]
>
> Claude API 또는 Managed Agents의 경우 [Claude API용 OpenTelemetry](https://platform.claude.com/docs/en/manage-claude/opentelemetry)를 참조하세요.

## 빠른 시작

환경 변수를 사용하여 OpenTelemetry를 구성합니다:

```bash theme={null}
# 1. 원격 측정 활성화
export CLAUDE_CODE_ENABLE_TELEMETRY=1

# 2. 내보내기 선택 (둘 다 선택 사항 - 필요한 것만 구성)
export OTEL_METRICS_EXPORTER=otlp       # 옵션: otlp, prometheus, console, none
export OTEL_LOGS_EXPORTER=otlp          # 옵션: otlp, console, none

# 3. OTLP 엔드포인트 구성 (OTLP 내보내기용)
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

# 4. 인증 설정 (필요한 경우)
export OTEL_EXPORTER_OTLP_HEADERS="Authorization=Bearer your-token"

# 5. 디버깅용: 내보내기 간격 단축, 프로덕션 사용을 위해 재설정
export OTEL_METRIC_EXPORT_INTERVAL=10000  # 10초 (기본값: 60000ms)
export OTEL_LOGS_EXPORT_INTERVAL=5000     # 5초 (기본값: 5000ms)

# 6. Claude Code 실행
claude
```

메트릭을 내보내는 설정을 확인하려면 백엔드에서 `claude_code.session.count` 메트릭을 확인하세요. Claude Code는 세션이 시작될 때 이 메트릭을 내보냅니다. 로그 전용 설정을 확인하려면 프롬프트를 제출하고 `claude_code.user_prompt` 이벤트를 확인하세요.

아무것도 도착하지 않으면 `claude --debug-file <path>`를 사용하여 Claude Code를 시작하고 해당 경로에 작성되는 로그를 확인하세요. Claude Code는 구성한 내보내기에서의 실패를 `[3P telemetry]` 오류로 보고합니다. 여기서 3P는 타사를 의미합니다. `[Anthropic telemetry]`로 시작하는 줄은 [Anthropic의 별도 운영 원격 측정](https://code.claude.com/docs/ko/data-usage.md#telemetry-services)을 설명하며 설정 문제를 나타내지 않습니다.

전체 구성 옵션은 [OpenTelemetry 사양](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/exporter.md#configuration-options)을 참조하세요.

## 관리자 구성

관리자는 [관리 설정 파일](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms)을 통해 모든 사용자에 대한 OpenTelemetry 설정을 구성할 수 있습니다. 설정이 적용되는 방식에 대한 자세한 내용은 [설정 우선순위](https://code.claude.com/docs/ko/settings.md#settings-precedence)를 참조하세요.

관리 설정 구성 예:

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "grpc",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://collector.example.com:4317",
    "OTEL_EXPORTER_OTLP_HEADERS": "Authorization=Bearer example-token"
  }
}
```

Claude Desktop 앱에서 Code 탭 세션은 [각 종류의 Desktop 세션에 도달하는 소스](https://code.claude.com/docs/ko/desktop.md#managed-settings)에서 이러한 관리 설정을 읽습니다. 관리 콘솔의 **모니터링** 아래 Cowork에 대한 OpenTelemetry 양식인 [데이터 및 개인정보 보호 설정](https://claude.ai/admin-settings/data-privacy-controls)은 Cowork 세션에만 적용되므로 터미널 CLI와 Code 탭 모두 거기에서 설정한 수집기로 내보내지 않습니다.

Claude Code는 저장소의 `.claude/settings.json` 및 `.claude/settings.local.json`에서 [OpenTelemetry 내보내기 변수](https://code.claude.com/docs/ko/settings-reference.md#variables-claude-code-ignores-in-env)를 무시하므로 저장소는 이를 사용하여 원격 측정을 켜거나, 이동 위치를 선택하거나, 콘텐츠를 캡처할 수 없습니다. 관리 설정에서 설정하거나 각 개발자가 자신의 셸 또는 `~/.claude/settings.json`에서 설정하세요. 저장소는 `OTEL_LOGS_EXPORTER`와 같은 내보내기 선택기를 `none`으로 설정하여 신호를 끌 수 있습니다. 단, 관리 설정, `--settings` 파일 또는 Claude Code를 시작하는 환경이 해당 변수를 설정하지 않는 경우에만 가능합니다.

Claude Code는 `OTEL_*` 환경 변수를 Bash 도구, 훅, MCP 서버 및 언어 서버를 포함하여 생성하는 하위 프로세스에 전달하지 않습니다. Bash 도구를 통해 실행하는 OpenTelemetry 계측 애플리케이션은 Claude Code의 내보내기 엔드포인트 또는 헤더를 상속하지 않으므로 해당 애플리케이션이 자신의 원격 측정을 내보내야 하는 경우 명령에서 직접 이러한 변수를 설정합니다.

### 관리 설정이 OTLP 대상을 잠그는 방식

관리 설정에서 `OTEL_EXPORTER_OTLP_*` 변수를 설정하면 Claude Code는 시작 시 충돌하는 개발자 설정 변수를 제거하고 디버그 로그에 경고를 기록합니다. 제거되는 항목은 설정하는 변수에 따라 달라집니다:

* **엔드포인트**: `OTEL_EXPORTER_OTLP_ENDPOINT`를 설정하면 Claude Code는 개발자가 설정한 모든 신호별 엔드포인트를 제거합니다. 개발자가 한 신호를 다른 수집기로 지정할 수 없으므로 관리 설정에서 신호별 엔드포인트 변수를 설정할 필요가 없습니다.
* **프로토콜**: `OTEL_EXPORTER_OTLP_PROTOCOL`을 설정하면 Claude Code는 개발자가 설정한 모든 신호별 프로토콜을 제거합니다.
* **자격증명**: `OTEL_EXPORTER_OTLP_HEADERS`, `OTEL_EXPORTER_OTLP_CLIENT_KEY` 또는 `OTEL_EXPORTER_OTLP_CLIENT_CERTIFICATE`를 설정하면 Claude Code는 해당 변수의 개발자 설정 신호별 버전과 모든 개발자 설정 엔드포인트 변수(일반 또는 신호별)를 제거합니다. 이러한 자격증명이 관리 설정이 선택하지 않은 수집기에 도달할 수 있기 때문입니다.
* **내보내기 선택기**: `OTEL_METRICS_EXPORTER`, `OTEL_LOGS_EXPORTER` 및 베타 `OTEL_TRACES_EXPORTER`는 일반적인 키별 우선순위를 따릅니다. 개발자의 설정이 여전히 신호를 비활성화하거나 콘솔 내보내기로 전환할 수 있으므로 필요한 경우 관리 설정에서도 선택기를 설정하세요. [관리 소스](https://code.claude.com/docs/ko/managed-settings.md#precedence-within-the-managed-tier)에서 `OTEL_LOGS_EXPORTER`는 [원격 측정 단위](https://code.claude.com/docs/ko/server-managed-settings.md#per-key-exceptions-across-managed-sources)를 따르는 반면 다른 두 선택기는 키별로 병합됩니다. Claude Code v2.1.223 이상이 필요합니다.
* **베타 추적 엔드포인트**: [상세 베타 추적](#traces-beta)이 활성화되면 Claude Code는 로그 및 추적 내보내기를 통해서가 아니라 `BETA_TRACING_ENDPOINT`로 내보냅니다. 따라서 Claude Code는 다음 관리 설정 중 하나가 신호의 대상을 결정할 때마다 개발자 설정 `BETA_TRACING_ENDPOINT`를 제거합니다:

  * 일반 또는 로그/추적 엔드포인트 또는 자격증명
  * [`otelHeadersHelper`](https://code.claude.com/docs/ko/settings-reference#otelheadershelper)
  * `none`, `console` 또는 비어있음으로 설정된 로그 또는 추적 내보내기 선택기(신호를 수집기에서 유지하는 값)
  * `CLAUDE_CODE_ENABLE_TELEMETRY` 비활성화

  메트릭 전용 엔드포인트 또는 자격증명은 제거하지 않습니다. v2.1.251 이전에는 개발자 설정 `BETA_TRACING_ENDPOINT`가 관리 설정이 수집기를 고정했을 때도 상세 베타 추적이 내보내는 로그 및 추적을 리디렉션했습니다.

Claude Code는 관리 설정 자체에서 설정한 신호별 변수를 제거하지 않으므로 해당 변수를 설정하여 한 신호를 다른 수집기로 라우팅할 수 있습니다([SIEM 예](#send-events-to-a-siem)에서 수행하는 것처럼). 신호별 자격증명을 설정하면 Claude Code는 해당 신호에 대한 개발자 설정 엔드포인트를 제거합니다.

이 제거 동작은 원격 측정이 전달되는 위치를 변경하며 Claude Code가 수집하는 항목은 변경하지 않습니다.

v2.1.217 이전에는 모든 변수가 키별 설정 우선순위를 독립적으로 따랐으므로 사용자 설정 또는 셸에서 설정한 신호별 엔드포인트가 해당 신호를 관리 수집기에서 리디렉션했습니다.

데스크톱 앱 또는 [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments) 실행기가 Claude Code를 시작하고 제공하는 환경에서 OTLP 엔드포인트를 지정하면 Claude Code는 동일한 방식으로 대상을 고정합니다: 실행기의 원격 측정 변수는 관리 설정과 정확히 동일하게 개발자 설정 변수를 제거합니다. Claude Code는 실행기 자체가 설정한 변수를 제거하지 않습니다. Claude Code v2.1.251 이상이 필요합니다.

## 구성 세부 정보

### 공통 구성 변수

이 변수들은 모든 배포에 대해 익스포터, 엔드포인트 및 내보내기 동작을 구성합니다.

`OTEL_EXPORTER_OTLP_METRICS_ENDPOINT`와 같은 신호별 엔드포인트 또는 프로토콜 변수를 설정하면 Claude Code는 해당 신호에 대해 일반 변수 대신 이를 사용합니다. `OTEL_EXPORTER_OTLP_METRICS_HEADERS`와 같은 신호별 헤더 변수를 설정하면 Claude Code는 해당 신호에 대해 이를 일반 `OTEL_EXPORTER_OTLP_HEADERS`와 병합합니다.

관리형 설정이 있는 머신에서 Claude Code가 제거하는 항목은 [관리형 설정이 OTLP 대상을 잠그는 방식](#how-managed-settings-lock-the-otlp-destination)을 참조하세요.

| 환경 변수 | 설명 | 예시 값 |
| - | - | - |
| `CLAUDE_CODE_ENABLE_TELEMETRY` | 텔레메트리 수집을 활성화합니다(필수) | `1` |
| `OTEL_METRICS_EXPORTER` | 메트릭 익스포터 유형(쉼표로 구분). 비활성화하려면 `none` 사용 | `console`, `otlp`, `prometheus`, `none` |
| `OTEL_LOGS_EXPORTER` | 로그/이벤트 익스포터 유형(쉼표로 구분). 비활성화하려면 `none` 사용 | `console`, `otlp`, `none` |
| `OTEL_EXPORTER_OTLP_PROTOCOL` | OTLP 익스포터용 프로토콜로, 모든 신호에 적용됩니다. Claude Code에는 기본 프로토콜이 없으므로 활성화하는 각 `otlp` 익스포터에 대해 이 변수 또는 신호별 프로토콜 변수를 설정해야 합니다 | `grpc`, `http/json`, `http/protobuf` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | 모든 신호에 대한 OTLP 수집기 엔드포인트 | `http://localhost:4317` |
| `OTEL_EXPORTER_OTLP_METRICS_PROTOCOL` | 메트릭용 프로토콜로, 일반 설정을 재정의합니다 | `grpc`, `http/json`, `http/protobuf` |
| `OTEL_EXPORTER_OTLP_METRICS_ENDPOINT` | OTLP 메트릭 엔드포인트로, 일반 설정을 재정의합니다 | `http://localhost:4318/v1/metrics` |
| `OTEL_EXPORTER_OTLP_LOGS_PROTOCOL` | 로그용 프로토콜로, 일반 설정을 재정의합니다 | `grpc`, `http/json`, `http/protobuf` |
| `OTEL_EXPORTER_OTLP_LOGS_ENDPOINT` | OTLP 로그 엔드포인트로, 일반 설정을 재정의합니다 | `http://localhost:4318/v1/logs` |
| `OTEL_EXPORTER_OTLP_HEADERS` | OTLP용 인증 헤더 | `Authorization=Bearer token` |
| `OTEL_EXPORTER_OTLP_METRICS_HEADERS` | 메트릭용 인증 헤더로, 일반 헤더와 병합됩니다 | `Authorization=Bearer token` |
| `OTEL_EXPORTER_OTLP_LOGS_HEADERS` | 로그용 인증 헤더로, 일반 헤더와 병합됩니다 | `Authorization=Bearer token` |
| `OTEL_METRIC_EXPORT_INTERVAL` | 밀리초 단위의 내보내기 간격(기본값: 60000) | `5000`, `60000` |
| `OTEL_LOGS_EXPORT_INTERVAL` | 밀리초 단위의 로그 내보내기 간격(기본값: 5000) | `1000`, `10000` |
| `OTEL_LOG_USER_PROMPTS` | 사용자 프롬프트 내용의 로깅을 활성화합니다(기본값: 비활성화) | 활성화하려면 `1` |
| `OTEL_LOG_ASSISTANT_RESPONSES` | `assistant_response` 이벤트에서 어시스턴트 응답 텍스트의 로깅을 활성화합니다(기본값: 비활성화). 설정하지 않으면 `OTEL_LOG_USER_PROMPTS`의 값을 따릅니다 | 활성화하려면 `1`, 마스킹 상태를 유지하려면 `0` |
| `OTEL_LOG_TOOL_DETAILS` | 도구 이벤트 및 트레이스 스팬 속성에서 도구 매개변수와 입력 인수의 로깅을 활성화합니다: Bash 명령, MCP 서버 및 도구 이름, 스킬 이름, 사용자가 작성한 워크플로 이름, 도구 입력. 또한 `user_prompt` 이벤트의 사용자 지정, 플러그인 및 MCP 명령 이름과 [비용 및 토큰 카운터](#cost-counter)의 실제 에이전트, 스킬, 플러그인, MCP 서버 및 도구 이름을 활성화합니다(기본값: 비활성화). Claude Desktop의 내장 서버의 경우, Claude Desktop이 소유한 세션에서는 플래그가 꺼져 있어도 `tool_decision`/`tool_result`에서 `mcp_server_name`/`mcp_tool_name`이 출력됩니다. 이 예외는 Claude Code v2.1.214 이상이 필요합니다 | 활성화하려면 `1` |
| `OTEL_LOG_TOOL_CONTENT` | [`tool.output` 스팬 이벤트](#tool-output-span-event)에서 도구 콘텐츠의 로깅을 활성화합니다(기본값: 비활성화). 스팬 속성은 [자체 게이트](#new-context-gates)에 따라 도구 콘텐츠를 포함합니다. [트레이싱](#traces-beta)이 필요합니다. 콘텐츠는 콘텐츠 한도(기본값 60 KB)에서 잘립니다 | 활성화하려면 `1` |
| `OTEL_LOG_MANAGED_SETTINGS` | 마스킹된 관리형 설정과 마스킹 전 설정의 SHA-256 다이제스트를 [관리형 설정 확인](#managed-settings-resolved-event) 이벤트에 추가합니다(기본값: 비활성화). 프로젝트 또는 로컬 설정의 값으로는 켜지지 않습니다. Claude Code v2.1.274 이상이 필요합니다 | 활성화하려면 `1` |
| `OTEL_LOG_RAW_API_BODIES` | 전체 Anthropic Messages API 요청 및 응답 JSON을 `api_request_body` / `api_response_body` 로그 이벤트로 출력합니다(기본값: 비활성화). 본문에는 전체 대화 기록이 포함됩니다. 이를 활성화하면 `OTEL_LOG_USER_PROMPTS`, `OTEL_LOG_TOOL_DETAILS`, `OTEL_LOG_TOOL_CONTENT`가 노출하는 모든 내용에 동의하는 것으로 간주됩니다 | 콘텐츠 한도(기본값 60 KB)에서 잘린 인라인 본문의 경우 `1`, 이벤트에 `body_ref` 포인터가 포함된 디스크상의 잘리지 않은 본문의 경우 `file:<dir>` |
| `CLAUDE_CODE_OTEL_CONTENT_MAX_LENGTH` | 콘텐츠 한도: 모델 응답, 도구 콘텐츠, 시스템 프롬프트, 원시 API 본문 등 콘텐츠를 포함하는 속성의 최대 길이로, 잘림 표시를 포함하며 UTF-16 코드 단위로 측정됩니다(기본값: 61440, 즉 60 KB). 기본값은 속성 값을 64 KB로 제한하는 백엔드에 맞춰져 있습니다. 백엔드가 더 큰 값을 허용하는 경우에만 늘리고, 텔레메트리 양을 줄이려면 낮추세요. OpenTelemetry SDK 속성 한도인 `OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT` 또는 그 logrecord 및 span 변형 중 하나가 더 낮게 설정되어 있으면, Claude Code는 `[TRUNCATED ...]` 표시가 SDK 한도 내에 머물도록 그 더 작은 값에서 자릅니다 | `262144` |
| `OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE` | 메트릭 시간성(temporality) 기본 설정(기본값: `delta`). 백엔드가 누적 시간성을 기대하는 경우 `cumulative`로 설정하세요 | `delta`, `cumulative` |
| `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS` | 동적 헤더 새로 고침 간격(기본값: 1740000ms / 29분) | `900000` |

`http/protobuf` 및 `http/json` 프로토콜의 경우 Claude Code는 각 내보내기 요청을 `Content-Length` 헤더와 함께 전송합니다.

### mTLS 인증

OTLP 익스포터의 클라이언트 인증서를 구성하는 방법은 해당 신호에 사용 중인 OTLP 프로토콜에 따라 달라지며, 이 프로토콜은 `OTEL_EXPORTER_OTLP_PROTOCOL` 또는 신호별 재정의를 통해 설정됩니다. 동일한 구성이 메트릭, 로그, 트레이스에 적용됩니다.

| 프로토콜 | 클라이언트 인증서 변수 | 수집기의 CA를 신뢰하는 방법 |
| :- | :- | :- |
| `http/protobuf`, `http/json` | `CLAUDE_CODE_CLIENT_CERT`, `CLAUDE_CODE_CLIENT_KEY`, 그리고 선택적으로 `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE`. [네트워크 구성](https://code.claude.com/docs/ko/network-config.md#mtls-authentication)을 참조하세요 | `NODE_EXTRA_CA_CERTS` |
| `grpc` | `OTEL_EXPORTER_OTLP_CLIENT_KEY` 및 `OTEL_EXPORTER_OTLP_CLIENT_CERTIFICATE`, 또는 신호마다 다른 인증서를 사용하려면 `OTEL_EXPORTER_OTLP_METRICS_CLIENT_KEY`와 같은 신호별 변형 | `OTEL_EXPORTER_OTLP_CERTIFICATE` |

`grpc`의 경우 OpenTelemetry SDK가 표준 OTLP 변수를 직접 읽으므로, 신호별 메트릭 변수를 설정하는 기존 구성은 계속 작동합니다. 관리형 설정이 있는 머신에서는 Claude Code가 시작 시 [개발자가 설정한 신호별 자격 증명과 엔드포인트를 제거할 수 있습니다](#how-managed-settings-lock-the-otlp-destination).

### 메트릭 카디널리티 제어

다음 환경 변수는 카디널리티를 관리하기 위해 메트릭에 포함되는 속성을 제어합니다.

| 환경 변수 | 설명 | 기본값 | 비활성화 예시 |
| - | - | - | - |
| `OTEL_METRICS_INCLUDE_SESSION_ID` | 메트릭에 session.id 속성과, 클라우드 세션의 경우 ccr.session.id 속성을 포함합니다 | `true` | `false` |
| `OTEL_METRICS_INCLUDE_VERSION` | 메트릭에 app.version 속성을 포함합니다 | `false` | `true` |
| `OTEL_METRICS_INCLUDE_ACCOUNT_UUID` | 메트릭에 user.account\_uuid 및 user.account\_id 속성을 포함합니다 | `true` | `false` |
| `OTEL_METRICS_INCLUDE_ENTRYPOINT` | 메트릭에 app.entrypoint 속성을 포함합니다 | `false` | `true` |
| `OTEL_METRICS_INCLUDE_RESOURCE_ATTRIBUTES` | `OTEL_RESOURCE_ATTRIBUTES`의 키를 메트릭 데이터 포인트의 속성으로 포함합니다 | `true` | `false` |
| `OTEL_METRICS_INCLUDE_REPOSITORY` | 메트릭과 이벤트에 `vcs.*` [저장소 식별 속성](#repository-attributes)을 포함합니다. Claude Code v2.1.269 이상이 필요합니다 | `false` | `true` |

일반적으로 카디널리티가 낮을수록 성능이 향상되고 스토리지 비용이 줄어들지만, 분석용 데이터의 세분성은 떨어집니다.

### 트레이스(베타)

분산 트레이싱은 각 사용자 프롬프트를 그 프롬프트가 트리거한 API 요청 및 도구 실행과 연결하는 스팬을 내보내므로, 트레이싱 백엔드에서 전체 요청을 하나의 트레이스로 볼 수 있습니다.

트레이싱은 기본적으로 꺼져 있습니다. 활성화하려면 `CLAUDE_CODE_ENABLE_TELEMETRY=1`과 `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1`을 모두 설정한 다음, `OTEL_TRACES_EXPORTER`를 설정하여 스팬을 보낼 위치를 선택하세요. 트레이스는 엔드포인트, 프로토콜, 헤더 및 [mTLS](#mtls-authentication)에 대해 [공통 OTLP 구성](#common-configuration-variables)을 재사용합니다. 관리형 설정이 있는 머신에서는 Claude Code가 시작 시 [개발자가 설정한 신호별 자격 증명과 엔드포인트를 제거할 수 있습니다](#how-managed-settings-lock-the-otlp-destination).

| 환경 변수 | 설명 | 예시 값 |
| - | - | - |
| `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA` | 스팬 트레이싱을 활성화합니다(필수). `ENABLE_ENHANCED_TELEMETRY_BETA`도 허용됩니다 | `1` |
| `OTEL_TRACES_EXPORTER` | 트레이스 익스포터 유형(쉼표로 구분). 비활성화하려면 `none` 사용 | `console`, `otlp`, `none` |
| `OTEL_EXPORTER_OTLP_TRACES_PROTOCOL` | 트레이스용 프로토콜로, `OTEL_EXPORTER_OTLP_PROTOCOL`을 재정의합니다 | `grpc`, `http/json`, `http/protobuf` |
| `OTEL_EXPORTER_OTLP_TRACES_ENDPOINT` | OTLP 트레이스 엔드포인트로, `OTEL_EXPORTER_OTLP_ENDPOINT`를 재정의합니다 | `http://localhost:4318/v1/traces` |
| `OTEL_EXPORTER_OTLP_TRACES_HEADERS` | 트레이스용 인증 헤더로, `OTEL_EXPORTER_OTLP_HEADERS`와 병합됩니다 | `Authorization=Bearer token` |
| `OTEL_TRACES_EXPORT_INTERVAL` | 밀리초 단위의 스팬 배치 내보내기 간격(기본값: 5000) | `1000`, `10000` |

스팬은 기본적으로 사용자 프롬프트 텍스트, 도구 입력 세부 정보 및 도구 콘텐츠를 마스킹합니다. 이를 포함하려면 `OTEL_LOG_USER_PROMPTS=1`, `OTEL_LOG_TOOL_DETAILS=1`, `OTEL_LOG_TOOL_CONTENT=1`을 설정하세요.

트레이싱이 활성화되어 있으면 Bash 및 PowerShell 하위 프로세스는 활성 도구 실행 스팬의 W3C 트레이스 컨텍스트를 담은 `TRACEPARENT` 환경 변수를 자동으로 상속합니다. 이를 통해 `TRACEPARENT`를 읽는 모든 하위 프로세스가 자체 스팬을 같은 트레이스 아래에 둘 수 있어, Claude가 실행하는 스크립트와 명령 전반에 걸쳐 엔드투엔드 분산 트레이싱이 가능해집니다.

트레이싱이 활성화되어 있고 Claude Code가 Anthropic API에 직접 연결된 경우, 각 모델 요청에는 `claude_code.llm_request` 스팬의 컨텍스트로 설정된 W3C `traceparent` 헤더가 포함되며, API의 `traceresponse` 헤더는 스팬 링크로 기록됩니다. 이 둘이 함께 규격을 준수하는 모든 중개자를 거쳐 Claude Code의 클라이언트 측 스팬을 서버 측 트레이스에 연결합니다. 아웃바운드 HTTP MCP 요청도 같은 방식으로 `traceparent`를 포함합니다. 이 헤더는 서드파티 제공업체에는 전송되지 않습니다.

일부 프록시는 인식되지 않는 헤더를 거부하므로, 기본적으로 모델 및 HTTP MCP 요청의 `traceparent` 헤더는 `ANTHROPIC_BASE_URL`이 설정되지 않았거나 Anthropic API를 가리킬 때만 전송됩니다. 일관성을 위해 하위 프로세스의 `TRACEPARENT` 변수도 같은 스위치로 제어됩니다. 사용자 지정 `ANTHROPIC_BASE_URL` 프록시를 통해 Claude Code를 실행하면서 트레이스 컨텍스트를 전파하려면 `CLAUDE_CODE_PROPAGATE_TRACEPARENT=1`을 설정하세요.

Agent SDK 및 `-p`로 시작된 비대화형 세션에서 Claude Code는 각 상호작용 스팬을 시작할 때 자체 환경에서 `TRACEPARENT`와 `TRACESTATE`도 읽습니다. 이를 통해 임베딩 프로세스가 활성 W3C 트레이스 컨텍스트를 하위 프로세스에 전달하여 Claude Code의 스팬이 호출자의 분산 트레이스의 자식으로 나타나게 할 수 있습니다. 대화형 세션은 CI 또는 컨테이너 환경의 주변 값을 실수로 상속하지 않도록 인바운드 `TRACEPARENT`를 무시합니다.

인바운드 트레이스 컨텍스트는 [이벤트](#events)에도 적용됩니다. `TRACEPARENT`가 설정된 Agent SDK 및 `-p` 세션에서는 트레이스 익스포터가 구성되지 않은 경우에도 각 OTLP 이벤트 로그 레코드에 애플리케이션의 트레이스와 연결하는 `trace_id` 및 `span_id` 값이 포함되므로, 로깅 백엔드에서 이벤트를 트레이스의 나머지 부분과 연관시킬 수 있습니다.

상호작용이 활성 상태일 때 출력된 레코드는 Claude Code가 스팬의 비동기 컨텍스트 밖에서 출력하더라도(예: 권한 프롬프트 콜백에서, 또는 시작 중에 버퍼링되었다가 나중에 내보내진 레코드의 경우) 상호작용 스팬의 ID를 포함합니다. 활성 상호작용 스팬이 없을 때 출력된 레코드는 인바운드 `TRACEPARENT` ID를 직접 포함합니다.

#### 스팬 계층 구조

각 사용자 프롬프트는 `claude_code.interaction` 루트 스팬을 시작합니다. API 호출, 도구 호출 및 훅 실행은 그 자식으로 기록됩니다. 도구 스팬에는 자체 자식 스팬이 두 개 있습니다. 하나는 권한 결정을 기다리는 데 소요된 시간에 대한 것이고, 다른 하나는 실행 자체에 대한 것입니다. Agent 도구 또는 레거시 Task 도구가 서브에이전트를 생성하면, 서브에이전트의 API 및 도구 스팬은 부모의 `claude_code.tool` 스팬 아래에 중첩됩니다.

```text theme={null}
claude_code.interaction
├── claude_code.llm_request
├── claude_code.hook                    (requires detailed beta tracing)
└── claude_code.tool
    ├── claude_code.tool.blocked_on_user
    ├── claude_code.tool.execution
    └── (Agent tool) subagent claude_code.llm_request / claude_code.tool spans
```

Agent SDK 및 `claude -p` 세션에서는 환경에 `TRACEPARENT`가 설정되어 있으면 `claude_code.interaction` 자체가 호출자 스팬의 자식이 됩니다.

`PreToolUse` 훅이 [도구 호출을 연기](https://code.claude.com/docs/ko/hooks.md#defer-a-tool-call-for-later)하면 Claude Code는 연기한 턴의 트레이스 컨텍스트를 저장합니다. 세션을 재개하여 도구가 다시 실행되면, 도구의 스팬은 해당 턴의 `claude_code.interaction` 스팬의 자식으로서 그 이전 턴의 트레이스에 합류합니다.

#### 스팬 속성

모든 스팬은 [표준 속성](#standard-attributes)과 함께 이름에 해당하는 `span.type` 속성을 포함합니다. 아래 표에는 각 스팬에 설정되는 추가 속성이 나열되어 있습니다. `llm_request`, `tool.execution`, `hook` 스팬은 실패를 기록할 때 OpenTelemetry 상태를 `ERROR`로 설정하며, 다른 스팬은 항상 `UNSET` 상태로 종료됩니다.

**`claude_code.interaction`**

| 속성 | 설명 | 게이트 |
| - | - | - |
| `user_prompt` | 프롬프트 텍스트. 게이트가 설정되지 않으면 값은 `<REDACTED>`입니다 | `OTEL_LOG_USER_PROMPTS` |
| `user_prompt_length` | 문자 단위의 프롬프트 길이 | |
| `interaction.sequence` | 1부터 시작하는 상호작용 카운터로, [`event.sequence`](#event-correlation-attributes)에서 설명한 대로 세션이 아닌 Claude Code 프로세스 단위로 계산됩니다 | |
| `parent.source` | 스팬이 트레이스 부모를 얻은 방식: 인바운드 `TRACEPARENT` 아래에 부모가 지정된 경우 `env`, 자체 트레이스를 시작한 경우 `none`. Claude Code v2.1.268 이상이 필요합니다 | |
| `interaction.duration_ms` | 턴의 실제 경과 시간 | |

**`claude_code.llm_request`**

| 속성 | 설명 | 게이트 |
| - | - | - |
| `model` | 모델 식별자 | |
| `gen_ai.system` | 항상 `anthropic`. OpenTelemetry GenAI 시맨틱 규칙 | |
| `gen_ai.request.model` | `model`과 같은 값. OpenTelemetry GenAI 시맨틱 규칙 | |
| `query_source` | 요청을 발행한 하위 시스템(예: `repl_main_thread` 또는 서브에이전트 이름) | `ENABLE_BETA_TRACING_DETAILED` |
| `query_source_safe` | 상세 베타 트레이싱의 활성화 여부와 관계없이 출력되는 `query_source`의 제한된 형태로, `repl_main_thread` 또는 `agent.builtin.general-purpose`와 같은 값을 가집니다. `:`는 `.`이 되며, 사용자가 이름을 지정한 에이전트는 `agent.custom`으로 표시됩니다. Claude Code v2.1.268 이상이 필요합니다 | |
| `agent_id` | 요청을 발행한 서브에이전트 또는 팀원의 식별자. 메인 세션에는 없습니다 | |
| `parent_agent_id` | 이 에이전트를 생성한 에이전트의 식별자. 메인 세션 및 메인 세션에서 직접 생성된 에이전트에는 없습니다 | |
| `workflow.run_id` | 이 에이전트를 생성한 [Workflow](https://code.claude.com/docs/ko/workflows.md) 도구 실행의 실행 식별자로, 접두사 `wf_`가 붙습니다. 워크플로에 의해 생성되지 않은 에이전트에는 없습니다 | |
| `workflow.name` | 이 에이전트를 생성한 워크플로의 이름. 게이트가 설정되지 않으면 사용자가 작성한 이름은 `custom`으로 대체됩니다 | `OTEL_LOG_TOOL_DETAILS` |
| `speed` | `fast` 또는 `normal` | |
| `effort` | 요청에 적용된 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level): `low`, `medium`, `high`, `xhigh` 또는 `max`. Claude Code가 effort 수준을 보내지 않는 경우(예: effort를 지원하지 않는 모델)에는 없습니다. Claude Code v2.1.274 이상이 필요합니다 | |
| `llm_request.context` | 부모 스팬에 따라 `interaction`, `tool` 또는 `standalone` | |
| `duration_ms` | 재시도를 포함한 실제 경과 시간 | |
| `ttft_ms` | 밀리초 단위의 첫 토큰까지의 시간 | |
| `first_content_ms` | 요청 시작부터 성공한 시도의 첫 콘텐츠 블록까지의 시간(밀리초). 비스트리밍 경로로 폴백된 요청에는 없습니다. Claude Code v2.1.268 이상이 필요합니다 | |
| `input_tokens` | API 사용량 블록의 입력 토큰 수. 프롬프트 캐시에서 읽거나 캐시에 쓴 토큰은 제외되며, 이는 `cache_read_tokens` 및 `cache_creation_tokens`에 보고됩니다 | |
| `output_tokens` | 출력 토큰 수 | |
| `cache_read_tokens` | 프롬프트 캐시에서 읽은 토큰 | |
| `cache_creation_tokens` | 프롬프트 캐시에 쓴 토큰 | |
| `request_id` | API 요청 ID. `request_id` [이벤트 상관 속성](#event-correlation-attributes)과 같은 값 | |
| `gen_ai.response.id` | `request_id`와 같은 값. OpenTelemetry GenAI 시맨틱 규칙 | |
| `client_request_id` | 최종 시도의 클라이언트 생성 `x-client-request-id` | |
| `attempt` | 이 요청에 대해 이루어진 총 시도 횟수 | |
| `success` | `true` 또는 `false` | |
| `status_code` | 요청이 실패한 경우의 HTTP 상태 코드 | |
| `error` | 요청이 실패한 경우의 오류 메시지 | |
| `error_class` | 요청이 실패한 경우의 짧은 오류 클래스 토큰(예: `api_timeout` 또는 `server_overload`). Claude Code v2.1.268 이상이 필요합니다 | |
| `response.has_tool_call` | 응답에 도구 사용 블록이 포함된 경우 `true` | |
| `stop_reason` | API 응답의 `stop_reason`(예: `end_turn`, `tool_use`, `max_tokens`, `stop_sequence`, `pause_turn` 또는 `refusal`) | |
| `gen_ai.response.finish_reasons` | `stop_reason`과 같은 값을 문자열 배열로 감싼 것. OpenTelemetry GenAI 시맨틱 규칙 | |

각 재시도도 `attempt` 및 `client_request_id` 속성을 가진 `gen_ai.request.attempt` 스팬 이벤트로 기록됩니다.

**`claude_code.tool`**

| 속성 | 설명 | 게이트 |
| - | - | - |
| `tool_name` | 도구 이름 | |
| `tool_name_safe` | 사용자가 선택한 이름을 포함하지 않는 `tool_name`의 형태. 내장 도구 이름은 그대로 전달됩니다. MCP 도구 이름은 `mcp_other`로 표시되지만, `browser_*`라는 이름의 `playwright` 도구처럼 몇 가지 고정된 형태와 일치하는 도구 이름은 그대로 전달됩니다. Claude Code v2.1.268 이상이 필요합니다 | |
| `bash_command_class` | Bash 도구의 경우: 고정된 목록에서 가져온 명령의 첫 번째 프로그램의 범주(예: `vcs` 또는 `package_manager`). 목록에 없는 프로그램은 `other`, 줄을 파싱할 수 없는 경우 `unparsed` Claude Code v2.1.268 이상이 필요합니다 | |
| `bash_argv0` | Bash 도구의 경우: 명령의 첫 번째 프로그램이 같은 고정 목록에 있을 때 그 프로그램(예: `git` 또는 `npm`). 목록에 없는 모든 프로그램은 `other`. Claude Code v2.1.268 이상이 필요합니다 | |
| `duration_ms` | 권한 대기 및 실행을 포함한 실제 경과 시간 | |
| `result_tokens` | 도구 결과의 대략적인 토큰 크기 | |
| `agent_id` | 도구를 실행한 서브에이전트 또는 팀원의 식별자. 메인 세션에는 없습니다 | |
| `parent_agent_id` | 이 에이전트를 생성한 에이전트의 식별자. 메인 세션 및 메인 세션에서 직접 생성된 에이전트에는 없습니다 | |
| `workflow.run_id` | 이 에이전트를 생성한 Workflow 도구 실행의 실행 식별자로, 접두사 `wf_`가 붙습니다. 워크플로에 의해 생성되지 않은 에이전트에는 없습니다 | |
| `workflow.name` | 이 에이전트를 생성한 워크플로의 이름. 게이트가 설정되지 않으면 사용자가 작성한 이름은 `custom`으로 대체됩니다 | `OTEL_LOG_TOOL_DETAILS` |
| `tool_use_id` | 이 호출에 대한 모델의 `tool_use` 블록 id. [tool\_result](#tool-result-event) 및 [tool\_decision](#tool-decision-event) 이벤트와 훅 페이로드의 `tool_use_id`와 일치하므로, 스팬을 해당 레코드와 연결할 수 있습니다 | |
| `gen_ai.tool.call.id` | `tool_use_id`와 같은 값. OpenTelemetry GenAI 시맨틱 규칙 | |
| `file_path` | Read, Edit, Write 도구의 대상 파일 경로 | `OTEL_LOG_TOOL_DETAILS` |
| `full_command` | Bash 도구의 명령 문자열 | `OTEL_LOG_TOOL_DETAILS` |
| `skill_name` | Skill 도구의 스킬 이름 | `OTEL_LOG_TOOL_DETAILS` |
| `subagent_type` | Agent 도구 또는 레거시 Task 도구의 서브에이전트 유형 | `OTEL_LOG_TOOL_DETAILS` |

**`claude_code.tool`의 `tool.output` 스팬 이벤트**

`OTEL_LOG_TOOL_CONTENT=1`을 설정하면 Read 및 Bash 호출이 `claude_code.tool` 스팬에 `tool.output` 스팬 이벤트를 기록할 수 있습니다. Edit 및 Write 호출은 `OTEL_LOG_TOOL_DETAILS=1`도 설정한 경우에만 이를 기록합니다. 이 변수는 이 두 도구에만 국한되지 않으므로, 다른 곳에서 추가되는 인수는 [구성 표의 해당 행](#common-configuration-variables)을 확인하세요.

Claude Code v2.1.283 이상에서는 MCP 도구, WebFetch, WebSearch도 이 이벤트를 기록합니다.

Claude Code는 도구 호출이 성공적으로 반환될 때 이 이벤트를 기록하므로, 도구와 관계없이 오류를 발생시킨 호출은 아무것도 기록하지 않습니다. 반환된 호출 중에서도 다음의 경우에는 `tool.output` 이벤트를 기록하지 않습니다.

* Read, Edit, Write, Bash, WebFetch, WebSearch 및 MCP 도구 이외의 도구 호출
* 이미지, PDF 또는 내용이 변경되지 않은 파일의 재읽기처럼 파일 텍스트 이외의 것을 반환하는 Read
* `OTEL_LOG_TOOL_DETAILS=1`도 설정하지 않은 경우의 Edit 또는 Write 호출
* 대기 중인 메시지가 Claude에 전달될 수 있도록 Claude Code가 실행 중에 백그라운드로 이동한 WebFetch 또는 WebSearch 호출. 나중에 도착하는 결과도 기록되지 않습니다. Claude Code가 호출을 이동하는 시점은 터미널의 경우 [대기열에 넣은 항목을 Claude Code가 보내는 시점](https://code.claude.com/docs/ko/interactive-mode.md#when-claude-code-sends-what-you-queued)을, Agent SDK 세션의 경우 [`priority` 필드](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkusermessage)를 참조하세요

이 이벤트에는 다음 속성이 포함되며, 각각 콘텐츠 한도(기본값 60 KB)에서 잘립니다. `게이트`는 `OTEL_LOG_TOOL_CONTENT=1`에 더해 속성에 필요한 변수를 나타내며, Edit 및 Write의 경우 해당 변수는 속성이 아니라 이벤트 자체를 제어합니다.

| 속성 | 설명 | 게이트 |
| - | - | - |
| `content` | Read 도구가 반환한 텍스트 또는 Write 호출이 쓰도록 요청받은 텍스트 | Write 도구의 경우 `OTEL_LOG_TOOL_DETAILS` |
| `output` | Bash 도구의 경우 stderr가 stdout에 섞인 명령의 결합 출력. MCP 도구, WebFetch 또는 WebSearch의 경우 도구가 반환한 결과로, 텍스트 블록은 줄바꿈으로 연결되고 이미지나 문서는 `[image]`와 같은 자리 표시자로 대체됩니다 | |
| `diff` | Edit 도구가 적용한 구조화된 패치 | `OTEL_LOG_TOOL_DETAILS` |
| `file_path` | Read, Edit, Write 도구의 대상 파일 경로로, 같은 이름의 스팬 속성을 반복합니다 | `OTEL_LOG_TOOL_DETAILS` |
| `bash_command` | Bash 도구의 명령 문자열 | `OTEL_LOG_TOOL_DETAILS` |

부모 스팬의 `tool_name` 속성으로 이벤트가 어느 도구에서 왔는지 알 수 있습니다. 콘텐츠 한도에서 잘린 속성에는 `<attribute>_truncated` 및 `<attribute>_original_length`가 함께 포함됩니다.

**`claude_code.tool.blocked_on_user`**

| 속성 | 설명 | 게이트 |
| - | - | - |
| `duration_ms` | 권한 결정을 기다리는 데 소요된 시간 | |
| `decision` | `accept`, `reject` 또는 `cancelled`. `cancelled`는 Claude Code가 도구 호출에 대한 권한 결정 대기를 중단하고 도구를 실행하지 않았음을 의미합니다 | |
| `source` | `accept` 또는 `reject`의 경우 결정이 나온 출처(예: `config`, `hook` 또는 `user_temporary`)로, 의미는 [도구 결정 이벤트](#tool-decision-event)에 설명되어 있습니다. `cancelled`의 경우 결정이 내려지기 전에 대기를 종료시킨 원인(예: `user_abort`) | |

`source`가 `user_abort`인 `cancelled` 결정은 권한 프롬프트 또는 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) 검사가 보류 중인 동안 즉시 전달이 필요한 메시지가 턴을 중단시켰음을 의미합니다. 예를 들어 자동 모드 검사 중에 사용자가 대기열에 메시지를 넣어 두었다가 [즉시 보낸](https://code.claude.com/docs/ko/interactive-mode.md#when-claude-code-sends-what-you-queued) 경우입니다.

**`claude_code.tool.execution`**

| 속성 | 설명 | 게이트 |
| - | - | - |
| `duration_ms` | 도구 본체를 실행하는 데 소요된 시간 | |
| `tool_use_id` | 부모 `claude_code.tool` 스팬과 같은 값 | |
| `gen_ai.tool.call.id` | `tool_use_id`와 같은 값. OpenTelemetry GenAI 시맨틱 규칙 | |
| `success` | `true` 또는 `false` | |
| `error` | 실행이 실패한 경우의 오류 범주 문자열(예: `Error:ENOENT` 또는 `ShellError`). 게이트가 설정되면 대신 전체 오류 메시지를 포함합니다 | `OTEL_LOG_TOOL_DETAILS` |
| `error_class` | 문자, 숫자, 밑줄 이외의 문자를 `_`로 대체한 식별자 형태의 오류 범주(예: `Error_ENOENT` 또는 `ShellError`). `error`가 전체 메시지를 포함하는 경우에도 범주를 담습니다. Claude Code v2.1.268 이상이 필요합니다 | |

**`claude_code.hook`**

이 스팬은 상세 베타 트레이싱이 활성화된 경우에만 나타나며, 이를 위해서는 `ENABLE_BETA_TRACING_DETAILED=1`과 `BETA_TRACING_ENDPOINT`가 필요합니다. 이 두 변수는 [로그와 트레이스가 전송되는 위치도 변경합니다](https://code.claude.com/docs/ko/env-vars.md#variables). 이 두 변수는 셸, 사용자 설정 또는 관리형 설정에서 설정하세요. 두 변수 모두 [프로젝트 및 로컬 설정](https://code.claude.com/docs/ko/settings-reference.md#variables-claude-code-ignores-in-env)에서는 무시됩니다. `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA`만으로는 이 스팬이 생성되지 않습니다.

대화형 CLI 세션에서 상세 베타 트레이싱을 사용하려면 조직이 해당 기능의 허용 목록에 등록되어 있어야 합니다. Agent SDK 및 비대화형 `-p` 세션에는 허용 목록 등록이 필요하지 않습니다.

| 속성 | 설명 | 게이트 |
| - | - | - |
| `hook_event` | 훅 이벤트 유형(예: `PreToolUse`) | |
| `hook_name` | 전체 훅 이름(예: `PreToolUse:Write`) | |
| `num_hooks` | 실행된 일치하는 훅 명령의 수 | |
| `hook_definitions` | JSON으로 직렬화된 훅 구성 | `OTEL_LOG_TOOL_DETAILS` |
| `duration_ms` | 일치하는 모든 훅의 실제 경과 시간 | |
| `num_success` | 성공적으로 완료된 훅 수 | |
| `num_blocking` | 차단 결정을 반환한 훅 수 | |
| `num_non_blocking_error` | 차단하지 않고 실패한 훅 수 | |
| `num_cancelled` | 완료 전에 취소된 훅 수 | |

**상세 베타 트레이싱의 콘텐츠 속성**

> [!NOTE]
>
> `new_context`, `system_reminders`, `system_prompt_preview`, `user_system_prompt`, `tool_input`, `response.model_output`과 같은 추가 콘텐츠 속성은 상세 베타 트레이싱이 활성화된 경우에만 출력됩니다. 이들은 안정적인 스팬 스키마의 일부가 아닙니다.

이 속성들은 아래 스팬에 나타나며, `게이트`는 상세 베타 트레이싱에 더해 속성에 필요한 변수를 나타냅니다. 콘텐츠 한도(기본값 60 KB)보다 긴 값은 잘립니다.

| 속성 | 스팬 | 설명 | 게이트 |
| - | - | - | - |
| `new_context` | `claude_code.interaction` | 사용자 프롬프트 | `OTEL_LOG_USER_PROMPTS` |
| `new_context` | `claude_code.llm_request` | 요청과 함께 전송된 새 사용자 메시지 및 도구 결과 | `OTEL_LOG_USER_PROMPTS` |
| `system_reminders` | `claude_code.llm_request` | 요청의 새 메시지 중 [시스템 리마인더](https://code.claude.com/docs/ko/glossary.md#system-reminder)의 텍스트 | `OTEL_LOG_USER_PROMPTS` |
| `system_prompt_preview` | `claude_code.llm_request` | 요청과 함께 전송된 전체 시스템 프롬프트의 처음 500자 | `OTEL_LOG_USER_PROMPTS` |
| `user_system_prompt` | `claude_code.llm_request` | `systemPrompt` SDK 옵션 또는 `--system-prompt` 및 `--append-system-prompt` 플래그를 통해 제공한 시스템 프롬프트 텍스트만 포함합니다. 요청마다가 아니라 세션당 한 번 출력됩니다 | `OTEL_LOG_USER_PROMPTS` |
| `response.model_output` | `claude_code.llm_request` | 요청에 대한 모델 응답의 텍스트 | `OTEL_LOG_USER_PROMPTS` |
| `new_context` | `claude_code.tool` | 도구와 관계없이 도구 호출의 결과 | `OTEL_LOG_TOOL_CONTENT` |
| `tool_input` | `claude_code.tool` | 도구 호출의 직렬화된 입력 | `OTEL_LOG_TOOL_DETAILS` |

`OTEL_LOG_USER_PROMPTS=1`이 설정된 상세 베타 트레이싱에서 Claude Code는 콘텐츠 한도에서 잘린 전체 시스템 프롬프트를 담은 `claude_code.system_prompt` 이벤트도 출력합니다. 이 이벤트는 세션이 각각의 고유한 시스템 프롬프트를 처음 전송할 때, 그리고 압축 후에 다시 도착합니다.

### 동적 헤더

동적 인증이 필요한 엔터프라이즈 환경에서는 스크립트를 구성하여 헤더를 동적으로 생성할 수 있습니다. 동적 헤더는 `http/protobuf` 및 `http/json` 프로토콜에만 적용됩니다. `grpc` 프로토콜에서 Claude Code는 정적 헤더 변수인 `OTEL_EXPORTER_OTLP_HEADERS`와 그 신호별 변형만 사용합니다.

#### 설정 구성

경로를 자신의 스크립트로 바꾸어 `.claude/settings.json`에 추가합니다.

```json theme={null}
{
  "otelHeadersHelper": "/path/to/generate-otel-headers.sh"
}
```

값은 공백이 포함된 경로를 포함한 실행 파일의 경로이거나, 인수가 있는 셸 명령줄일 수 있습니다. Windows에서는 값이 항상 셸을 통해 실행되므로, 공백이 포함된 경로는 JSON 값 안에서 따옴표로 감싸세요.

#### 스크립트 요구 사항

스크립트는 HTTP 헤더를 나타내는 문자열 키-값 쌍으로 구성된 유효한 JSON을 출력해야 합니다.

```bash theme={null}
#!/bin/bash
# Example: Multiple headers
echo "{\"Authorization\": \"Bearer $(get-token.sh)\", \"X-API-Key\": \"$(get-api-key.sh)\"}"
```

헬퍼가 실패하거나 이 요구 사항을 충족하지 않는 출력을 내보내면, 내보내기가 실패하고 헬퍼가 다시 작동할 때까지 텔레메트리 백엔드는 해당 세션에서 아무것도 받지 못합니다. Claude Code는 다음 위치에서 실패를 보고합니다.

* 대화형 세션의 경고 알림 [`otelHeadersHelper failed; telemetry is not being exported`](https://code.claude.com/docs/ko/errors#otelheadershelper-failed)로, 헬퍼가 처음 실패할 때 세션당 한 번 표시됩니다
* `/status` 출력
* [`--debug`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 실행하거나 세션에서 `/debug`를 실행한 후의 디버그 로그
* `-p`로 시작된 비대화형 세션의 stderr

#### 새로 고침 동작

헤더 헬퍼 스크립트는 토큰 새로 고침을 지원하기 위해 시작 시 실행되고 이후 주기적으로 실행됩니다. 기본적으로 스크립트는 29분마다 실행됩니다. `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS` 환경 변수로 간격을 사용자 지정할 수 있습니다.

### 다중 팀 조직 지원

여러 팀이나 부서가 있는 조직은 `OTEL_RESOURCE_ATTRIBUTES` 환경 변수를 사용하여 서로 다른 그룹을 구분하는 사용자 지정 속성을 추가할 수 있습니다.

```bash theme={null}
# Add custom attributes for team identification
export OTEL_RESOURCE_ATTRIBUTES="department=engineering,team.id=platform,cost_center=eng-123"
```

이러한 사용자 지정 속성은 모든 메트릭과 이벤트에 포함되므로 다음과 같은 작업을 할 수 있습니다.

* 팀 또는 부서별로 메트릭 필터링
* 비용 센터별 비용 추적
* 팀별 대시보드 생성
* 특정 팀에 대한 알림 설정

Claude Code는 이 값들을 OTLP 리소스 블록으로 전송할 뿐 아니라 모든 메트릭 데이터 포인트와 이벤트 레코드에 속성으로 첨부합니다. 대부분의 메트릭 백엔드는 데이터 포인트 속성을 쿼리 가능한 레이블로 노출하므로, 사용자 지정 키로 메트릭을 직접 그룹화하고 필터링할 수 있습니다. `vcs.*` [저장소 속성](#repository-attributes)을 제외하고, 사용자 지정 키는 `user.id`나 `session.id`와 같은 [표준 속성](#standard-attributes)을 재정의하지 않습니다. 키가 충돌하면 Claude Code는 내장 값을 유지합니다.

각 사용자 지정 키는 모든 메트릭 시리즈의 레이블이 되므로, 카디널리티가 높은 값은 메트릭 백엔드의 스토리지 비용을 증가시킵니다. 사용자 지정 속성을 리소스 블록으로만 전송하고 데이터 포인트 레이블에서는 생략하려면 `OTEL_METRICS_INCLUDE_RESOURCE_ATTRIBUTES=false`를 설정하세요. [메트릭 카디널리티 제어](#metrics-cardinality-control)를 참조하세요.

> [!WARNING]
>
> `OTEL_RESOURCE_ATTRIBUTES` 환경 변수는 엄격한 형식 요구 사항이 있는 쉼표로 구분된 key=value 쌍을 사용합니다.
>
> * **공백 허용 안 됨**: 값에 공백을 포함할 수 없습니다. 예를 들어 `user.organizationName=My Company`는 유효하지 않습니다
> * **형식**: 쉼표로 구분된 key=value 쌍이어야 합니다: `key1=value1,key2=value2`
> * **허용 문자**: 제어 문자, 공백, 큰따옴표, 쉼표, 세미콜론, 백슬래시를 제외한 US-ASCII 문자만 허용됩니다
> * **특수 문자**: 허용 범위를 벗어난 문자는 퍼센트 인코딩해야 합니다
>
> 공백이 필요한 값에는 대신 밑줄이나 camelCase를 사용하세요. 다음 예시는 각 형식으로 `org.name`을 설정합니다.
>
> ```bash theme={null}
> export OTEL_RESOURCE_ATTRIBUTES="org.name=Johns_Organization"
> export OTEL_RESOURCE_ATTRIBUTES="org.name=JohnsOrganization"
> ```
>
> 제외된 문자뿐 아니라 어떤 문자든 퍼센트 인코딩할 수 있습니다. 이 예시는 공백과 아포스트로피를 모두 인코딩합니다.
>
> ```bash theme={null}
> export OTEL_RESOURCE_ATTRIBUTES="org.name=John%27s%20Organization"
> ```
>
> 값을 따옴표로 감싸도 공백이 이스케이프되지 않습니다. 예를 들어 `org.name="My Company"`는 `My Company`가 아니라 따옴표가 포함된 리터럴 값 `"My Company"`가 됩니다.

### Desktop SSH 세션에 텔레메트리 귀속

[Desktop SSH 세션](https://code.claude.com/docs/ko/desktop.md#ssh-sessions)이 어느 원격 머신에서 실행되었는지 확인하려면 사용자 지정 속성으로 각 머신의 이름을 지정하세요. 메트릭과 이벤트에는 세션이 실행된 머신의 이름이 포함되지 않습니다.

각 원격 머신에서 [세션이 읽는 관리형 설정 파일](https://code.claude.com/docs/ko/desktop.md#managed-settings)의 텔레메트리를 켜는 `env` 블록에 [`OTEL_RESOURCE_ATTRIBUTES`](#multi-team-organization-support)를 추가합니다. 각 머신의 파일에 이름을 직접 적으세요. Claude Code는 값을 확장하지 않으므로 `host.name=$(hostname)`은 그 문자 그대로 도착합니다.

다음 예시는 머신 이름을 `build-7`로 지정합니다.

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "grpc",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://collector.example.com:4317",
    "OTEL_RESOURCE_ATTRIBUTES": "host.name=build-7"
  }
}
```

다른 어떤 것도 이 변수를 설정하지 않으면, `host.name`은 Desktop SSH 세션과 해당 머신의 CLI 모두에서 리소스 블록에 포함되어 도착합니다. 사용자 지정 속성이 나타나는 다른 위치는 [다중 팀 조직 지원](#multi-team-organization-support)을 참조하세요.

이름이 도착하지 않으면 다음 원인 중 하나인지 확인하세요.

* **Desktop을 실행하는 컴퓨터에서 설정한 경우**: Desktop은 그곳에서 설정한 값을 SSH 세션에 전달하지 않습니다
* **`/etc/profile` 또는 로그인 셸만 읽는 다른 파일에서 export한 경우**: 로그인 셸에서 `claude`를 실행하면 이름이 도착하지만 Desktop SSH 세션에서는 도착하지 않습니다. Desktop은 로그인 셸을 통해 Claude Code를 시작하지 않습니다. 대신 원격 머신의 [관리형 설정 파일](https://code.claude.com/docs/ko/desktop.md#managed-settings)에서 `env` 아래에 변수를 설정하세요.
* **값 안에 공백이 있는 경우**: 이때 Claude Code는 어떤 키도 이벤트나 데이터 포인트에 복사하지 않으며 오류도 보고하지 않습니다. [값에서 공백을 제거하세요](#multi-team-organization-support).
* **다른 무언가가 이미 변수를 설정한 경우**: 데스크톱 앱이 시작하는 세션에서는 실행 환경에 이미 설정된 변수가 [설정 파일보다 우선합니다](https://code.claude.com/docs/ko/settings-reference.md#how-env-values-interact-with-your-shell). [디버그 로그](https://code.claude.com/docs/ko/debug-your-config.md)에 무시된 각 변수의 이름이 표시됩니다. 서드파티 Desktop 배포가 제공하는 환경에서 [OTLP 엔드포인트를 지정](#how-managed-settings-lock-the-otlp-destination)하는 경우, 해당 환경에는 Desktop 자체의 `OTEL_RESOURCE_ATTRIBUTES`가 포함됩니다.

### 구성 예시

`claude`를 실행하기 전에 이 환경 변수들을 설정하세요. 아래의 각 시나리오는 완전한 구성을 보여 주며, 각 변수는 [공통 구성 변수](#common-configuration-variables)에 설명되어 있습니다. 구성이 적용되었는지 확인하려면 세션을 시작한 후 백엔드에서 `claude_code.session.count` 메트릭을 확인하세요. 로그 전용 확인 방법과 아무것도 도착하지 않을 때 확인할 사항은 [빠른 시작](#quick-start)에서 다룹니다.

1초 내보내기 간격으로 콘솔 디버깅을 하는 경우:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=console
export OTEL_METRIC_EXPORT_INTERVAL=1000
```

gRPC를 통한 OTLP의 경우:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

`http://localhost:9464/metrics`에서 스크레이핑하는 Prometheus의 경우:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=prometheus
```

[자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments-reference.md#pass-through-session-child-metrics)에서는 러너의 기본 용량이 1일 때만 세션이 포트 9464에 바인딩됩니다. 용량이 더 크면 러너가 대신 자체 `/metrics` 엔드포인트에서 세션 카운터와 게이지를 다시 노출합니다.

여러 익스포터로 메트릭을 보내려면:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=console,otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=http/json
```

메트릭과 로그를 서로 다른 엔드포인트 또는 백엔드로 보내려면:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_METRICS_PROTOCOL=http/protobuf
export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=http://metrics.example.com:4318
export OTEL_EXPORTER_OTLP_LOGS_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_LOGS_ENDPOINT=http://logs.example.com:4317
```

이벤트나 로그 없이 메트릭만 내보내려면:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

메트릭 없이 이벤트와 로그만 내보내려면:

```bash theme={null}
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

## 클라우드 세션 및 Claude Tag의 텔레메트리

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)(예: [Claude Tag](https://claude.com/docs/claude-tag/overview) 채널 세션)은 사용자의 디바이스가 아닌 [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md)에서 실행되므로, 해당 디바이스의 관리형 설정 파일이나 셸 프로필은 텔레메트리를 구성하지 않습니다. Anthropic 호스팅 환경의 세션의 경우, 이 섹션에서는 텔레메트리 변수를 설정할 위치, 환경에서 수집기에 접근 가능하게 하는 방법, 내보낸 데이터에서 클라우드 및 Claude Tag 세션을 구분하는 방법을 다룹니다.

해당 세션에서 텔레메트리를 내보내려면 `CLAUDE_CODE_ENABLE_TELEMETRY` 및 `OTEL_*` 변수를 [관리자 구성](#administrator-configuration) 예제와 동일한 키를 사용하여 다음 두 위치 중 하나에 설정합니다:

* **서버 관리 설정**: 조직의 [서버 관리 설정](https://code.claude.com/docs/ko/server-managed-settings.md)의 `env` 블록에 추가합니다. Claude Code는 [서버 관리 설정이 적용되는](https://code.claude.com/docs/ko/model-config.md#surface-coverage) 모든 곳(사용자의 머신 및 Claude Tag 채널 세션 이외의 클라우드 세션 포함)에서 시작 시 해당 설정을 가져옵니다. Claude Tag 세션은 서버 관리 설정을 받지 않으므로, 이 방법은 이들을 구성하지 않습니다.
* **환경의 변수**: 클라우드 환경의 [환경 변수](https://code.claude.com/docs/ko/cloud-environments.md#set-environment-variables)에 추가하여 해당 환경에서 실행되는 세션만 구성합니다. 이것이 Claude Tag 세션에 도달하는 방법입니다.

환경을 사용하는 모든 사람이 해당 변수를 읽을 수 있으므로, 수집기 토큰(예: `OTEL_EXPORTER_OTLP_HEADERS`)과 같은 자격 증명을 거기에 넣지 마십시오. 환경의 [네트워크 시크릿](https://code.claude.com/docs/ko/cloud-environments.md#add-network-secrets)도 도움이 되지 않습니다. Claude Code의 자체 텔레메트리 내보내기는 [시크릿을 받지 않는 요청](https://code.claude.com/docs/ko/cloud-environments.md#requests-that-never-get-the-credential) 중 하나이기 때문입니다. 수집기에 자격 증명이 필요한 경우, 서버 관리 설정을 통해 전체 내보내기를 구성하십시오. 거기에 자격 증명을 설정하면 [Claude Code는 관리형 설정 외부에서 설정된 엔드포인트 변수를 제거합니다](#how-managed-settings-lock-the-otlp-destination).

클라우드 세션에 대한 텔레메트리를 구성할 때 다음 제약 사항을 염두에 두십시오:

* **세션이 수집기에 도달하도록 허용**: Claude Code는 세션의 네트워크를 통해 내보내기를 전송하므로, `OTEL_EXPORTER_OTLP_ENDPOINT`의 호스트에 도달하는지 여부는 환경의 [네트워크 액세스 수준](https://code.claude.com/docs/ko/cloud-environments.md#access-levels)에 따라 달라집니다. 세션이 선택한 수준에서 수집기의 도메인에 도달할 수 없으면, [환경의 허용 목록에 도메인을 추가합니다](https://code.claude.com/docs/ko/cloud-environments.md#allow-specific-domains). 서버 관리 설정은 환경의 네트워크 허용 목록에 도메인을 추가하지 않기 때문입니다.
* **Claude Tag 채널**: 허용 목록 및 환경 변수 변경은 조직의 기본값으로 설정되었거나 채널에 고정된 [공유 환경](https://code.claude.com/docs/ko/cloud-environments.md#organization-shared-environments)에서 수행합니다.
* **Cowork는 별도로 구성됩니다**: [표면 범위 테이블](https://code.claude.com/docs/ko/model-config.md#surface-coverage)에서 보여주듯이 Cowork 세션은 서버 관리 설정을 받지 않으므로, 서버 관리 `env` 블록은 해당 텔레메트리를 구성하지 않습니다.

### 클라우드 세션에 텔레메트리 속성 지정

기본적으로 클라우드 세션의 메트릭 및 이벤트는 `session.id`, `ccr.session.id`, `organization.id`를 포함한 [표준 속성](#standard-attributes)을 전달하므로, 추가 구성 없이 세션 또는 조직별로 필터링할 수 있습니다. `ccr.session.id` 값은 세션의 `CLAUDE_CODE_REMOTE_SESSION_ID`입니다. 이를 세션의 트랜스크립트 URL로 변환하려면 [출력을 세션에 다시 연결](https://code.claude.com/docs/ko/cloud-environments.md#link-output-back-to-the-session)을 참조하십시오.

클라우드 세션을 구분하려면 `session.id`가 아닌 `ccr.session.id`를 기준으로 그룹화하거나 필터링하십시오.

더 자세하게 텔레메트리를 속성 지정하려면 다음 옵션을 사용합니다:

* **Claude Tag 세션 식별**: [메트릭 카디널리티 제어](#metrics-cardinality-control)에서 설명한 대로 `OTEL_METRICS_INCLUDE_ENTRYPOINT=true`를 설정합니다. 그러면 메트릭은 `app.entrypoint`를 전달하며, 그 값은 Claude Tag 세션의 경우 `claude-in-slack`입니다.
* **사용자 정의 속성 추가**: 해당 세션에 대한 다른 `OTEL_*` 변수를 설정하는 동일한 위치에 [`OTEL_RESOURCE_ATTRIBUTES`](#multi-team-organization-support)를 설정합니다. 환경의 [설정 스크립트](https://code.claude.com/docs/ko/cloud-environments.md#setup-scripts)에서 `export`하면, 값이 Claude Code에 도달하지 않습니다. 설정 스크립트는 Claude Code가 시작되기 전에 실행되는 별도의 Bash 스크립트이며, 이것이 내보내는 변수는 여기서 끝납니다.

Claude Tag 채널 세션에서 Claude는 조직의 [공유 ID](https://code.claude.com/docs/ko/cloud-environments.md#set-the-environment-a-claude-tag-channel-uses)로 작동하며 어떤 멤버로도 작동하지 않으므로, `user.*` 속성에 의존하여 Claude를 태그한 사람을 식별하지 마십시오.

## 사용 가능한 메트릭 및 이벤트

### 표준 속성

모든 메트릭과 이벤트는 다음 표준 속성을 공유합니다.

| 속성 | 설명 | 제어 방법 |
| - | - | - |
| `session.id` | Claude Code 자체의 세션 ID로, `/clear`를 실행하면 새 값으로 바뀝니다 | `OTEL_METRICS_INCLUDE_SESSION_ID` (기본값: true) |
| `ccr.session.id` | 클라우드 세션 식별자로, [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md)에서 실행되는 세션의 `CLAUDE_CODE_REMOTE_SESSION_ID` 값입니다 | `OTEL_METRICS_INCLUDE_SESSION_ID` (기본값: true) |
| `app.version` | 현재 Claude Code 버전 | `OTEL_METRICS_INCLUDE_VERSION` (기본값: false) |
| `app.entrypoint` | 세션이 시작된 방식으로, `cli`, `sdk-cli`, `sdk-ts`, `sdk-py`, `claude-vscode`, 또는 Claude Tag 세션의 경우 `claude-in-slack` 등이 있습니다 | `OTEL_METRICS_INCLUDE_ENTRYPOINT` (기본값: false) |
| `organization.id` | 조직 UUID(인증된 경우) | 사용 가능한 경우 항상 포함 |
| `user.account_uuid` | 계정 UUID(인증된 경우) | `OTEL_METRICS_INCLUDE_ACCOUNT_UUID` (기본값: true) |
| `user.account_id` | Anthropic 관리자 API와 일치하는 태그 형식의 계정 ID(인증된 경우)로, 예를 들면 `user_01BWBeN28...`입니다 | `OTEL_METRICS_INCLUDE_ACCOUNT_UUID` (기본값: true) |
| `user.id` | 최초 실행 시 생성되어 `~/.claude.json`에 저장되는 무작위 익명 식별자입니다. 개인 정보를 포함하지 않으며 Claude 계정에서 파생되지 않습니다. 파일을 삭제하면 다음 실행 시 관련 없는 새 값이 생성됩니다. | 항상 포함 |
| `user.email` | 사용자 이메일 주소로, 로그인 정보에서 가져오거나 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에서는 세션 자체의 자격 증명에서 가져옵니다 | 사용 가능한 경우 항상 포함 |
| `terminal.type` | 터미널 유형으로, `iTerm.app`, `vscode`, `cursor`, `tmux` 등이 있습니다 | 감지된 경우 항상 포함 |
| `OTEL_RESOURCE_ATTRIBUTES`의 키 | 사용자가 설정한 사용자 지정 속성으로, `department` 또는 `team.id` 등이 있습니다. [다중 팀 조직 지원](#multi-team-organization-support)을 참조하세요 | `OTEL_METRICS_INCLUDE_RESOURCE_ATTRIBUTES` (기본값: true) |
| `vcs.repository.url.full`, `vcs.owner.name`, `vcs.repository.name`, `vcs.provider.name` | 세션 저장소의 식별 정보로, `origin` 원격에서 파생됩니다. [저장소 속성](#repository-attributes)을 참조하세요 | `OTEL_METRICS_INCLUDE_REPOSITORY` (기본값: false). Claude Code v2.1.269 이상이 필요합니다 |

`/login`을 통해 [Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)에 로그인한 세션에서는 CLI가 내보내는 데이터에 인증된 ID를 기록합니다. `user.id`는 IdP subject이고, `user.email`은 로그인한 이메일이며, `user.groups`는 IdP 그룹 멤버십을 쉼표로 구분된 문자열로 담습니다. 각 내보내기에는 `identity.source: gateway-oidc`도 포함됩니다. 게이트웨이 ID가 마지막에 적용되므로 해당 세션에서는 `OTEL_RESOURCE_ATTRIBUTES`를 통해 설정한 `user.*` 및 `identity.*` 키가 무시됩니다.

> [!NOTE]
>
> 개발자가 로그인하기 전에 Claude Code가 로그에 기록하는 이벤트에는 게이트웨이 ID가 포함되지 않습니다. 예를 들어 [게이트웨이가 로그인을 종료한](https://code.claude.com/docs/ko/errors.md#cloud-gateway-session-expired) 후처럼 Claude Code가 게이트웨이에서 로그아웃된 상태로 세션을 열면, 로그인 전에 기록된 시작 이벤트에는 익명 `user.id`가 포함되고 `identity.source`는 포함되지 않습니다. 이러한 이벤트에는 [`managed_settings_resolved`](#managed-settings-resolved-event), [`plugin_loaded`](#plugin-loaded-event), [`mcp_server_connection`](#mcp-server-connection-event)이 포함됩니다.

게이트웨이를 통해 연결하는 Claude Desktop 및 Cowork 세션의 ID 속성은 [게이트웨이 `telemetry` 참조](https://code.claude.com/docs/ko/claude-apps-gateway-config#telemetry)를 확인하세요.

이벤트에는 다음 속성이 추가로 포함됩니다. 이러한 속성은 카디널리티가 무한히 증가할 수 있으므로 메트릭에는 절대 첨부되지 않습니다.

* `prompt.id`: 사용자 프롬프트와 다음 프롬프트 전까지의 모든 후속 이벤트를 연결하는 UUID입니다. [이벤트 상관 속성](#event-correlation-attributes)을 참조하세요.
* `workspace.host_paths`: 데스크톱 앱에서 선택한 호스트 워크스페이스 디렉터리로, 문자열 배열입니다
* `workflow.run_id`: [Workflow](https://code.claude.com/docs/ko/workflows.md) 도구 실행에 속한 에이전트가 내보내는 API 및 도구 이벤트에 포함되는 실행 식별자로, `wf_` 접두사가 붙습니다. 하나의 `workflow.run_id`로 이벤트를 필터링하면 해당 실행의 API 요청과 도구 결과를 재구성할 수 있습니다. 이 식별자는 워크플로 스크립트가 생성하는 에이전트와, 그 에이전트가 다시 생성하는 스킬 호출 등의 에이전트를 모두 포괄합니다. Workflow 도구 결과에 보고되는 실행 식별자와 일치합니다.
* `workflow.name`: 워크플로의 이름으로, 스크립트의 `meta.name`이며 `workflow.run_id`와 함께 내보내집니다. 실행이 수정되지 않은 기본 제공 스크립트를 실행하는 경우 기본 제공 워크플로 이름이 그대로 표시됩니다. 기본 제공 스크립트를 편집한 사본을 포함하여 사용자가 작성한 이름은 `OTEL_LOG_TOOL_DETAILS=1`이 설정되지 않은 한 `custom`으로 대체됩니다.
* `agent_id`: 이벤트를 발생시킨 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)의 식별자로, 예를 들면 `a3f2c1b4d5e6f7a80`입니다. 이 속성을 포함하는 이벤트에는 서브에이전트의 API 및 도구 이벤트, 해당 서브에이전트의 [`assistant_response`](#assistant-response-event) 이벤트, 완료된 서브에이전트에 대한 [`subagent_completed`](#subagent-completed-event)가 있습니다. 메인 세션 및 [인프로세스 팀원](https://code.claude.com/docs/ko/agent-teams.md#choose-a-display-mode) 이벤트에는 없습니다. 서브에이전트의 [스팬 `agent_id`](#span-attributes)는 같은 값이거나, `acompact-3f2c1b4d5e6f7a80`처럼 앞의 `a` 뒤에 레이블이 추가된 값입니다. Claude Code v2.1.310 이상이 필요합니다
* `parent_agent_id`: 이벤트를 발생시킨 서브에이전트를 생성하거나 마지막으로 재개한 에이전트의 `agent_id`입니다. 해당 에이전트가 메인 세션인 경우에는 없습니다. Claude Code v2.1.310 이상이 필요합니다

#### 저장소 속성

`OTEL_METRICS_INCLUDE_REPOSITORY=true`를 설정하면 메트릭과 이벤트에 세션 저장소의 식별 정보가 태그로 지정되므로, 공유 수집기에서 저장소별로 사용량을 집계할 수 있습니다. Claude Code v2.1.269 이상이 필요합니다.

Claude Code는 세션당 한 번 저장소의 `origin` 원격에서 이러한 속성을 파생합니다. GitHub, GitLab, Bitbucket Cloud처럼 저장소의 HTTPS 원격과 SSH 원격이 동일한 호스트와 동일한 경로를 가리키는 경우, 둘 다 동일한 값을 생성합니다.

| 속성 | 값 |
| - | - |
| `vcs.repository.url.full` | `.git`을 제외한 저장소의 브라우저 URL로, 예를 들면 `https://github.com/example-org/example-repo`입니다 |
| `vcs.owner.name` | 소유자 또는 그룹 경로로, 예를 들면 `example-org`입니다. 원격 경로에 세그먼트가 하나뿐인 경우 생략됩니다 |
| `vcs.repository.name` | 순수한 저장소 이름으로, 예를 들면 `example-repo`입니다 |
| `vcs.provider.name` | Claude Code가 원격의 호스트나 URL 형태를 해당 공급자 중 하나로 인식하면 `github`, `gitlab`, `bitbucket`, 또는 `gitea`입니다. 그렇지 않으면 생략됩니다 |

값은 소문자로 변환되며, 원격 URL의 자격 증명, 쿼리 문자열, 프래그먼트는 절대 포함되지 않습니다. 세션에 `origin` 원격이 없거나, 원격이 URL 형태가 아니거나, 이를 포함하는 유일한 저장소가 홈 디렉터리인 경우 이 속성은 생략됩니다.

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에서 이러한 속성을 얻으려면 해당 [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md#set-environment-variables)에 `OTEL_METRICS_INCLUDE_REPOSITORY`를 포함한 텔레메트리 변수를 설정하세요. 또한 환경의 [네트워크 액세스](https://code.claude.com/docs/ko/cloud-environments.md#network-access)에서 수집기의 도메인을 허용하세요.

[`OTEL_RESOURCE_ATTRIBUTES`](#multi-team-organization-support)에 선언한 `vcs.*` 키는 해당 키의 파생 값을 대체합니다. `vcs.repository.url.full`을 선언하면 Claude Code는 원격을 읽지 않고 사용자가 선언한 키만 보고합니다.

예를 들어 HTTPS 클론 URL에 SSH URL에는 없는 경로 접두사가 붙는 자체 호스팅 설치처럼, 한 저장소의 HTTPS 클론과 SSH 클론이 서로 다른 값을 보고하는 경우에는 `OTEL_RESOURCE_ATTRIBUTES`에 `vcs.repository.url.full`을 보고하려는 다른 모든 `vcs.*` 키와 함께 선언하세요. 그러면 모든 클론이 선언한 식별 정보를 보고합니다.

이 속성은 사용자 자신의 익스포터로만 전달되며, Anthropic의 텔레메트리는 모든 `vcs.*` 키를 삭제합니다.

### 메트릭

Claude Code는 다음 메트릭을 내보냅니다. 단위 열은 각 메트릭에 첨부된 OpenTelemetry 단위 문자열을 나타내며, 카운트 메트릭에는 단위가 없습니다.

| 메트릭 이름 | 설명 | 단위 |
| - | - | - |
| `claude_code.session.count` | 시작된 CLI 세션 수 | 없음 |
| `claude_code.lines_of_code.count` | 수정된 코드 줄 수 | 없음 |
| `claude_code.pull_request.count` | 생성된 풀 리퀘스트 수 | 없음 |
| `claude_code.commit.count` | 생성된 git 커밋 수 | 없음 |
| `claude_code.cost.usage` | Claude Code 세션 비용 | USD |
| `claude_code.token.usage` | 사용된 토큰 수 | tokens |
| `claude_code.code_edit_tool.decision` | 코드 편집 도구 권한 결정 수 | 없음 |
| `claude_code.active_time.total` | 총 활성 시간 | s |

`OTEL_METRICS_EXPORTER`에 나열된 유일한 내보내기 도구가 `prometheus`인 경우, Claude Code는 스크레이프가 유효한 Prometheus 텍스트 형식을 유지하도록 내보내는 메트릭에서 `USD`, `tokens`, `s` 단위를 생략합니다. 메트릭 이름은 변경되지 않으며, `otlp,prometheus`처럼 내보내기 도구를 결합한 구성에서는 단위가 유지됩니다.

### 메트릭 세부 정보

각 메트릭에는 위에 나열된 표준 속성이 포함됩니다. 컨텍스트별 추가 속성이 있는 메트릭은 아래에 표시되어 있습니다.

#### 세션 카운터

각 세션이 시작될 때 증가합니다.

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `start_type`: 세션이 시작된 방식입니다. `"fresh"`, `"resume"`, `"continue"`, `"agents_view"` 중 하나입니다. `"agents_view"` 값은 대화형 세션이 아니라 사용자가 실행한 로컬 UI인 `claude agents` 대시보드 프로세스를 나타냅니다. 대시보드에서 UI 프로세스 실행과 대화형 세션을 구분하려면 이 값으로 필터링하세요.

#### 코드 줄 카운터

코드가 추가되거나 제거될 때 증가합니다.

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `type`: (`"added"`, `"removed"`)
* `model`: 변경을 수행한 모델의 모델 식별자(예: "claude-sonnet-5")

#### 풀 리퀘스트 카운터

Claude Code가 셸 명령이나 MCP 도구를 통해 풀 리퀘스트 또는 병합 요청을 생성할 때 증가합니다.

**속성**:

* 모든 [표준 속성](#standard-attributes)

#### 커밋 카운터

Claude Code를 통해 git 커밋을 생성할 때 증가합니다.

**속성**:

* 모든 [표준 속성](#standard-attributes)

#### 비용 카운터

각 API 요청 후에 증가합니다.

`agent.name`, `skill.name`, `plugin.name`, `mcp_server.name`, `mcp_tool.name` 속성은 기본적으로 각각 일부 이름을 `"custom"` 또는 `"third-party"` 플레이스홀더로 수정합니다. `OTEL_LOG_TOOL_DETAILS=1`을 설정하면 대신 실제 이름이 포함됩니다. v2.1.273 이전에는 `OTEL_LOG_TOOL_DETAILS=1`이 설정되어 있어도 비용 및 토큰 카운터와 `api_request`, `api_error`, `api_refusal` 이벤트에 수정된 값이 포함되었습니다.

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `model`: 모델 식별자(예: "claude-sonnet-5")
* `query_source`: 요청을 발행한 하위 시스템의 범주입니다. `"main"`, `"subagent"`, `"auxiliary"` 중 하나입니다
* `speed`: 요청이 빠른 모드를 사용한 경우 `"fast"`입니다. 그렇지 않으면 없습니다
* `effort`: 요청에 적용된 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)으로, `"low"`, `"medium"`, `"high"`, `"xhigh"`, `"max"` 중 하나입니다. 예를 들어 effort를 지원하지 않는 모델처럼 Claude Code가 effort 수준을 보내지 않는 경우에는 없습니다.
* `agent.name`: 요청을 발행한 서브에이전트 유형입니다. 기본 제공 에이전트 이름과 공식 마켓플레이스 플러그인의 에이전트는 그대로 표시됩니다. 그 밖의 사용자 정의 에이전트 이름은 `"custom"`으로 대체됩니다. 이름이 지정된 서브에이전트 유형이 요청을 발행하지 않은 경우에는 없습니다.
* `skill.name`: 요청에 대해 활성화된 스킬로, Skill 도구나 `/` 명령으로 설정되거나 생성된 서브에이전트가 상속한 것입니다. 기본 제공, 번들, 사용자 정의, 공식 마켓플레이스 플러그인 스킬 이름은 그대로 표시됩니다. 서드파티 플러그인 스킬 이름은 `"third-party"`로 대체됩니다. 활성화된 스킬이 없으면 없습니다.
* `plugin.name`: 활성 스킬이나 서브에이전트가 플러그인에서 제공되는 경우 해당 소유 플러그인입니다. 공식 마켓플레이스 플러그인 이름은 그대로 표시됩니다. 서드파티 플러그인 이름은 `"third-party"`로 대체됩니다. 스킬과 서브에이전트 모두 소유 플러그인이 없으면 없습니다.
* `marketplace.name`: 소유 플러그인이 설치된 마켓플레이스입니다. `OTEL_LOG_TOOL_DETAILS=1`이 설정되어 있더라도 공식 마켓플레이스 플러그인에 대해서만 내보내집니다. 그 외에는 없습니다.
* `mcp_server.name`: 이 요청이 소비한 도구 결과를 제공한 MCP 서버입니다. 기본 제공, claude.ai 프록시, 공식 레지스트리 서버 이름은 그대로 표시됩니다. 사용자가 구성한 서버 이름은 `"custom"`으로 대체됩니다. 요청이 MCP 도구 결과를 소비하지 않은 경우에는 없습니다. v2.1.222 이전에는 Claude Code가 도구 결과를 소비한 요청뿐 아니라 MCP 도구 호출 이후의 모든 요청에 이 속성을 설정했으므로, 이 속성을 집계하는 대시보드에서는 업그레이드 후 값이 감소한 것으로 나타납니다.
* `mcp_tool.name`: 이 요청이 소비한 결과를 제공한 MCP 도구로, 수정 및 버전 동작은 `mcp_server.name`과 동일합니다. 요청이 MCP 도구 결과를 소비하지 않은 경우에는 없습니다.

#### 토큰 카운터

각 API 요청 후에 증가합니다.

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `type`: (`"input"`, `"output"`, `"cacheRead"`, `"cacheCreation"`). `"input"` 유형은 프롬프트 캐시에서 읽거나 캐시에 쓴 토큰을 제외하며, 이러한 토큰은 `"cacheRead"` 및 `"cacheCreation"`으로 집계됩니다. `"cacheCreation"` 유형은 5분 및 1시간 [캐시 수명](https://code.claude.com/docs/ko/prompt-caching.md#cache-lifetime)의 캐시 쓰기를 합산하여 집계합니다.
* `model`: 모델 식별자(예: "claude-sonnet-5")
* `query_source`: 요청을 발행한 하위 시스템의 범주입니다. `"main"`, `"subagent"`, `"auxiliary"` 중 하나입니다
* `speed`: 요청이 빠른 모드를 사용한 경우 `"fast"`입니다. 그렇지 않으면 없습니다
* `effort`: 요청에 적용된 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)입니다. 자세한 내용은 [비용 카운터](#cost-counter)를 참조하세요.
* `agent.name`, `skill.name`, `plugin.name`, `marketplace.name`, `mcp_server.name`, `mcp_tool.name`: 요청에 대한 스킬, 플러그인, 에이전트, MCP 귀속 정보입니다. 정의와 수정 동작은 [비용 카운터](#cost-counter)를 참조하세요.

#### 코드 편집 도구 결정 카운터

사용자가 Edit, Write 또는 NotebookEdit 도구 사용을 수락하거나 거부할 때 증가합니다.

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `tool_name`: 도구 이름(`"Edit"`, `"Write"`, `"NotebookEdit"`)
* `decision`: 사용자 결정(`"accept"`, `"reject"`)
* `source`: 결정의 출처입니다. `"config"`, `"hook"`, `"user_permanent"`, `"user_temporary"`, `"user_abort"`, `"user_reject"` 중 하나입니다. 각 값의 의미는 [도구 결정 이벤트](#tool-decision-event)를 참조하세요.
* `language`: 편집된 파일의 프로그래밍 언어로, `"TypeScript"`, `"Python"`, `"JavaScript"`, `"Markdown"` 등이 있습니다. 인식되지 않는 파일 확장자의 경우 `"unknown"`을 반환합니다.

#### 활성 시간 카운터

유휴 시간을 제외하고 Claude Code를 실제로 활발하게 사용한 시간을 추적합니다. 이 메트릭은 입력 및 응답 읽기와 같은 사용자 상호작용 중, 그리고 도구 실행 및 AI 응답 생성과 같은 CLI 처리 중에 증가합니다.

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `type`: 키보드 상호작용의 경우 `"user"`, 도구 실행 및 AI 응답의 경우 `"cli"`

### 이벤트

Claude Code는 OpenTelemetry 로그/이벤트를 통해 다음 이벤트를 내보냅니다(`OTEL_LOGS_EXPORTER`가 구성된 경우).

#### 이벤트 상관 속성

사용자가 프롬프트를 제출하면 Claude Code는 여러 API 호출을 수행하고 여러 도구를 실행할 수 있습니다. `prompt.id` 속성을 사용하면 이러한 모든 이벤트를 이를 촉발한 단일 프롬프트와 연결할 수 있습니다.

| 속성 | 설명 |
| - | - |
| `prompt.id` | 단일 사용자 프롬프트를 처리하는 동안 생성된 모든 이벤트를 연결하는 UUID v4 식별자 |
| `event.sequence` | 이벤트 순서를 정하기 위한 0부터 시작하는 카운터로, 세션 단위가 아니라 Claude Code 프로세스 단위로 집계됩니다 |
| `message.uuid` | 세션 트랜스크립트, 즉 `~/.claude/projects/*/*.jsonl` 파일에 저장된 메시지의 UUID입니다. `assistant_response`, `api_response_body`, 그리고 `user_prompt`에 포함되며, 0개 또는 여러 개의 메시지를 생성할 수 있는 명령 디스패치는 예외입니다. `assistant_response`와 `api_response_body`에서는 응답의 마지막 트랜스크립트 항목으로, 다음 턴의 `parentUuid`가 이 항목에 연결됩니다. `api_response_body`에서는 Claude Code v2.1.274 이상이 필요합니다 |
| `request_id` | `request-id` 응답 헤더에서 읽은, 서버가 할당한 API 요청 ID입니다. 예: `req_011...`. [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md)처럼 `request-id` 헤더가 없는 응답에서는 대신 `x-amzn-requestid` 헤더에서 값을 가져옵니다. 응답에 두 헤더 중 하나가 있으면 `api_request`, `api_error`, `api_refusal`, `assistant_response`, `api_response_body`, [`tool_result`](#tool-result-event), [`tool_decision`](#tool-decision-event)에 포함됩니다. `llm_request` 트레이스 스팬의 동일한 속성과 일치합니다. `x-amzn-requestid` 출처는 Claude Code v2.1.282 이상이 필요합니다 |
| `client_request_id` | `x-client-request-id` 요청 헤더로 전송되는 클라이언트 생성 UUID입니다. 퍼스트 파티 API 연결에서 `api_request`와 `api_error`에 포함되며, 서드파티 공급자 백엔드에서나 요청이 비스트리밍 폴백을 통해 재시도된 경우에는 없습니다. 요청과 응답을 짝지으며, 서버 `request_id`를 생성하지 못한 타임아웃 같은 실패에서도 사용할 수 있습니다. `llm_request` 트레이스 스팬의 동일한 속성과 일치합니다 |

단일 프롬프트가 촉발한 모든 활동을 추적하려면 특정 `prompt.id` 값으로 이벤트를 필터링하세요. 그러면 해당 프롬프트를 처리하는 동안 발생한 user\_prompt 이벤트, 모든 api\_request 이벤트, 모든 tool\_result 이벤트가 반환됩니다.

`event.sequence`는 Claude Code 프로세스가 시작될 때마다 0에서 시작하여 해당 프로세스가 유지되는 동안 증가합니다. 새 `session.id`를 할당하는 `/clear` 이후에도 계속 증가합니다. [분기하지 않고 세션을 재개](https://code.claude.com/docs/ko/how-claude-code-works.md#resume-or-fork-sessions)하면 세션은 `session.id`를 유지하지만 `event.sequence` 값은 세션을 재개한 프로세스에서 가져오므로, 한 세션 내에서 나중 이벤트가 이전 이벤트보다 낮은 값을 갖거나 같은 값을 반복할 수 있습니다. 세션의 이벤트 순서를 정하려면 `event.timestamp`로 정렬하고, 타임스탬프가 같은 이벤트의 순서는 `event.sequence`로 정하세요.

메시지 수준 재구성을 위해 각 이벤트 클래스에는 세션 트랜스크립트의 필드와 일치하는 키가 있습니다. 트랜스크립트 항목 형식은 [Claude Code 내부 형식](https://code.claude.com/docs/ko/sessions.md#where-transcripts-are-stored)이며 버전마다 변경되므로, 이러한 필드로 조인하는 파이프라인은 어떤 릴리스에서든 중단될 수 있습니다. 이러한 조인은 안정적인 계약이 아니라 버전별로 다른 것으로 취급하세요.

* `user_prompt`, `assistant_response`, `api_response_body`의 `message.uuid`
* API 이벤트의 `request_id`로, 트랜스크립트의 어시스턴트 항목에는 `requestId`로 저장됩니다
* `tool_result` 및 `tool_decision` 이벤트의 `tool_use_id`, 그리고 [턴 종료](#safety-event)에 대한 이벤트를 제외한 `safety_event` 이벤트의 `tool_use_id`

#### 사용자 프롬프트 이벤트

Claude Code가 스스로 시작하는 턴을 포함하여 프롬프트가 제출될 때 로그에 기록됩니다.

**이벤트 이름**: `claude_code.user_prompt`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"user_prompt"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `prompt_length`: 프롬프트 길이
* `prompt`: 프롬프트 내용입니다. 기본적으로 수정됩니다. 포함하려면 `OTEL_LOG_USER_PROMPTS=1`을 설정하세요
* `prompt_text`: `prompt`와 동일한 값으로, 동일한 조건에서 수정됩니다. 점이 포함된 속성 이름을 중첩 객체로 저장하는 백엔드는 `prompt.id`를 `prompt`라는 객체 안의 `id`로 읽어 프롬프트 문자열을 잃을 수 있습니다. 이 경우 대신 `prompt_text`를 읽으세요. Claude Code v2.1.287 이상이 필요합니다
* `message.uuid`: 결과로 생성된 사용자 메시지의 UUID로, 저장된 트랜스크립트 항목과 일치합니다. 0개 또는 여러 개의 메시지를 생성할 수 있는 명령 디스패치에서는 없습니다.
* `command_name`: 프롬프트가 명령을 호출하는 경우 명령 이름입니다. `compact`나 `debug` 같은 기본 제공 및 번들 명령 이름은 그대로 내보내지며, `reset` 같은 별칭은 정식 이름이 아니라 입력한 그대로 내보내집니다. 사용자 지정, 플러그인, MCP 명령 이름은 `OTEL_LOG_TOOL_DETAILS=1`이 설정되지 않은 한 `custom` 또는 `mcp`로 축약됩니다
* `command_source`: 명령이 있는 경우 명령의 출처로, `builtin`, `custom`, `mcp` 중 하나입니다. 플러그인이 제공하는 명령은 `custom`으로 보고됩니다

#### 어시스턴트 응답 이벤트

모델로부터 텍스트 콘텐츠를 반환하는 각 API 요청 후에 로그에 기록됩니다. 응답의 텍스트 블록만 포함되며, thinking 블록과 도구 사용 블록은 제외됩니다.

**이벤트 이름**: `claude_code.assistant_response`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"assistant_response"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `response_length`: 응답 텍스트의 길이(문자 수)
* `response`: 응답 텍스트로, 콘텐츠 한도(기본값 60 KB)에서 잘립니다. 기본적으로 `<REDACTED>`로 수정됩니다. 포함하려면 `OTEL_LOG_ASSISTANT_RESPONSES=1`을 설정하세요. `OTEL_LOG_ASSISTANT_RESPONSES`가 설정되지 않은 경우 `OTEL_LOG_USER_PROMPTS`가 대신 이를 제어하므로, 프롬프트 로깅이 켜져 있는 동안 응답을 수정된 상태로 유지하려면 `OTEL_LOG_ASSISTANT_RESPONSES=0`을 설정하세요
* `model`: 모델 식별자(예: "claude-sonnet-5")
* `request_id`: API 요청 ID로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `message.uuid`: 응답의 마지막 트랜스크립트 항목의 UUID입니다. API 응답은 콘텐츠 블록당 하나의 트랜스크립트 항목으로 저장되며, 이 값은 그중 마지막 항목으로 다음 턴의 `parentUuid`가 이 항목에 연결됩니다.
* `query_source`: 요청을 발행한 하위 시스템으로, `"repl_main_thread"`, `"compact"` 또는 서브에이전트 이름 등이 있습니다

#### 도구 결과 이벤트

도구 실행이 완료될 때 로그에 기록됩니다. 도구 호출이 거부된 경우에는 내보내지지 않습니다. 거부에 대해서는 [도구 결정 이벤트](#tool-decision-event)를 참조하세요.

**이벤트 이름**: `claude_code.tool_result`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"tool_result"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `tool_name`: 도구 이름
* `tool_use_id`: 이 도구 호출의 고유 식별자입니다. 훅에 전달되는 `tool_use_id`와 일치하므로 OTel 이벤트와 훅이 캡처한 데이터를 상호 연관시킬 수 있습니다.
* `request_id`: 이 도구 호출을 포함한 API 응답의 [`request_id`](#event-correlation-attributes)로, 이를 통해 호출을 해당 응답의 API 이벤트와 조인할 수 있습니다. 해당 응답에 요청 ID가 없거나 호출을 포함한 API 응답이 없는 경우에는 없습니다. Claude Code v2.1.310 이상이 필요합니다
* `success`: `"true"` 또는 `"false"`
* `duration_ms`: 실행 시간(밀리초)
* `error_type`: 도구가 실패한 경우 오류 범주 문자열로, `"Error:ENOENT"` 또는 `"ShellError"` 등이 있습니다
* `error` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): 도구가 실패한 경우 전체 오류 메시지
* `decision_type`: 이 이벤트는 도구가 실행된 후에만 내보내지므로 항상 `"accept"`입니다. 거부된 호출은 도구 결과를 생성하지 않습니다
* `decision_source`: 권한 결정의 출처입니다. `"config"`, `"hook"`, `"user_permanent"`, `"user_temporary"` 중 하나입니다. 각 값의 의미는 [도구 결정 이벤트](#tool-decision-event)를 참조하세요. 거부 전용 출처인 `"user_abort"` 및 `"user_reject"`는 이 이벤트에 절대 나타나지 않습니다.
* `tool_input_size_bytes`: JSON으로 직렬화된 도구 입력의 크기(바이트)
* `tool_result_size_bytes`: 도구 결과의 크기(바이트)
* `mcp_server_scope`: MCP 서버 범위 식별자(MCP 도구의 경우)
* `vcs.ref.head.revision`, `vcs.ref.head.name`, `vcs.ref.head.type` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): Bash 또는 PowerShell 도구가 실행한 성공적인 `git commit`의 커밋 식별 정보입니다. `vcs.ref.head.revision`은 커밋 SHA, `vcs.ref.head.name`은 커밋된 브랜치, `vcs.ref.head.type`은 `branch`입니다. detached HEAD에서 커밋된 경우 이름과 유형은 생략됩니다. Claude Code v2.1.269 이상이 필요합니다
* `tool_parameters` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): 도구별 매개변수를 포함하는 JSON 문자열입니다. Claude Desktop이 소유한 세션에서 Claude Desktop의 기본 제공 서버의 경우, 플래그가 꺼져 있어도 `mcp_server_name`/`mcp_tool_name` 쌍이 포함되며, 이는 [도구 결정 이벤트](#tool-decision-event)와 동일한 호스트 작성 예외입니다. 매개변수는 도구마다 다릅니다.
  * Bash 도구의 경우: `bash_command`, `full_command`, `timeout`, `description`, `dangerouslyDisableSandbox`를 포함하며, `git commit` 명령이 성공하면 `git_commit_id` 및 `git_branch`도 포함합니다. `git_commit_id`는 커밋이 세션 작업 디렉터리의 HEAD인 경우 전체 커밋 SHA이고, 그렇지 않으면 git의 축약된 SHA입니다. `git_branch`는 커밋된 브랜치이며, detached HEAD에서는 생략됩니다
  * `tool_name`을 `Bash`로 보고하는 데스크톱 앱의 워크스페이스 Bash 도구의 경우: `bash_command`, `full_command`, `timeout`만 포함합니다
  * MCP 도구의 경우: `mcp_server_name`, `mcp_tool_name`을 포함합니다
  * Skill 도구의 경우: `skill_name`을 포함합니다
  * Agent 도구 또는 레거시 Task 도구의 경우: `subagent_type`을 포함합니다
* `tool_input` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): JSON으로 직렬화된 도구 인수입니다. 512자를 초과하는 개별 값은 잘리며, 전체 페이로드는 약 4 K자로 제한됩니다. MCP 도구를 포함한 모든 도구에 적용됩니다.

#### API 요청 이벤트

Claude에 대한 각 API 요청에 대해 로그에 기록됩니다.

**이벤트 이름**: `claude_code.api_request`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"api_request"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `model`: 사용된 모델(예: "claude-sonnet-5")
* `cost_usd`: 예상 비용(USD)
* `cost_usd_micros`: 예상 비용을 미국 달러의 백만분의 1 단위로 나타낸 값으로, 정수로 내보내집니다
* `duration_ms`: 요청 소요 시간(밀리초)
* `input_tokens`: 입력 토큰 수로, 프롬프트 캐시에서 읽거나 캐시에 쓴 토큰은 제외합니다
* `output_tokens`: 출력 토큰 수
* `cache_read_tokens`: 캐시에서 읽은 토큰 수
* `cache_creation_tokens`: 캐시 생성에 사용된 토큰 수
* `cache_creation_5m_tokens`, `cache_creation_1h_tokens`: API 응답이 5분 [캐시 수명](https://code.claude.com/docs/ko/prompt-caching.md#cache-lifetime)으로 캐시에 쓴 것으로 보고한 토큰 수와 1시간 수명으로 쓴 토큰 수입니다. API 응답이 이를 보고하지 않으면 `cache_creation_tokens`가 0보다 크더라도 둘 다 `0`입니다. Claude Code v2.1.300 이상이 필요합니다
* `request_id`: API 요청 ID로, 예를 들면 `"req_011..."`이며 [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다.
* `client_request_id`: `x-client-request-id` 요청 헤더로 전송되는 클라이언트 생성 UUID입니다. 포함되는 경우는 [이벤트 상관 속성](#event-correlation-attributes) 표를 참조하세요
* `speed`: 빠른 모드가 활성화되었는지 여부를 나타내는 `"fast"` 또는 `"normal"`
* `query_source`: 요청을 발행한 하위 시스템으로, `"repl_main_thread"`, `"compact"` 또는 서브에이전트 이름 등이 있습니다
* `effort`: 요청에 적용된 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)으로, `"low"`, `"medium"`, `"high"`, `"xhigh"`, `"max"` 중 하나입니다. 예를 들어 effort를 지원하지 않는 모델처럼 Claude Code가 effort 수준을 보내지 않는 경우에는 없습니다.
* `agent.name`, `skill.name`, `plugin.name`, `marketplace.name`, `mcp_server.name`, `mcp_tool.name`: 요청에 대한 스킬, 플러그인, 에이전트, MCP 귀속 정보입니다. 정의와 수정 동작은 [비용 카운터](#cost-counter)를 참조하세요.

#### API 오류 이벤트

Claude에 대한 API 요청이 실패할 때 로그에 기록됩니다.

**이벤트 이름**: `claude_code.api_error`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"api_error"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `model`: 사용된 모델(예: "claude-sonnet-5")
* `error`: 오류 메시지
* `status_code`: 숫자 형식의 HTTP 상태 코드입니다. 연결 실패와 같은 비 HTTP 오류의 경우에는 없습니다.
* `duration_ms`: 요청 소요 시간(밀리초)
* `attempt`: 최초 요청을 포함한 시도 횟수입니다. 횟수가 다시 시작되는 시점은 [재시도 소진 감지](#detect-retry-exhaustion)에서 설명합니다
* `request_id`: API 요청 ID로, 예를 들면 `"req_011..."`이며 [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다.
* `client_request_id`: `x-client-request-id` 요청 헤더로 전송되는 클라이언트 생성 UUID입니다. 타임아웃이나 연결 오류 같은 실패로 서버 `request_id`가 생성되지 않은 경우에도 사용할 수 있습니다. 포함되는 경우는 [이벤트 상관 속성](#event-correlation-attributes) 표를 참조하세요.
* `speed`: 빠른 모드가 활성화되었는지 여부를 나타내는 `"fast"` 또는 `"normal"`
* `query_source`: 요청을 발행한 하위 시스템으로, `"repl_main_thread"`, `"compact"` 또는 서브에이전트 이름 등이 있습니다
* `effort`: 요청에 적용된 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)입니다. 예를 들어 effort를 지원하지 않는 모델처럼 Claude Code가 effort 수준을 보내지 않는 경우에는 없습니다.
* `agent.name`, `skill.name`, `plugin.name`, `marketplace.name`, `mcp_server.name`, `mcp_tool.name`: 요청에 대한 스킬, 플러그인, 에이전트, MCP 귀속 정보입니다. 정의와 수정 동작은 [비용 카운터](#cost-counter)를 참조하세요.

#### API 거부 이벤트

API 요청이 `stop_reason: "refusal"`을 반환할 때 로그에 기록됩니다. 거부는 HTTP 오류가 아니라 성공적인 응답 스트림으로 도착하므로 `api_error` 이벤트가 발생하지 않습니다. 이 이벤트를 사용하면 거부 빈도를 추적하고 `api_request` 및 `api_error`와 동일한 속성으로 거부를 그룹화할 수 있습니다.

**이벤트 이름**: `claude_code.api_refusal`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"api_refusal"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `model`: 요청의 모델 식별자
* `request_id`: API 요청 ID로, 예를 들면 `"req_011..."`이며 [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다.
* `query_source`: 요청을 발행한 하위 시스템으로, `"repl_main_thread"`, `"compact"` 또는 서브에이전트 이름 등이 있습니다. 정의는 [`api_request`](#api-request-event)를 참조하세요.
* `speed`: [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md)가 활성화된 경우 `"fast"`, 그렇지 않으면 `"normal"`
* `attempt`: 재시도 시도 번호입니다. 첫 번째 시도는 `1`입니다.
* `effort`: 요청에 적용된 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)입니다. 예를 들어 effort를 지원하지 않는 모델처럼 Claude Code가 effort 수준을 보내지 않는 경우에는 없습니다.
* `server_fallback_hop`: API의 서버 측 모델 폴백이 이미 이 거부를 다른 모델로 재시도하여 사용자가 이 특정 거부를 보지 않은 경우 `true`입니다. 요청이 거부로 끝난 경우 `false`입니다. 폴백 모델도 거부하는 경우 단일 턴에서 `true` 홉 이벤트와 이후의 `false` 최종 이벤트가 모두 내보내질 수 있습니다.
* `has_category`: API 응답에 `"cyber"`, `"bio"`, `"frontier_llm"`, `"reasoning_extraction"` 중 하나의 `stop_details.category`가 포함된 경우 `true`입니다. 응답에 범주가 없거나 해당 집합 외의 값이 포함된 경우 `false`입니다. 홉 블록에는 `stop_details`가 포함되지 않으므로 `server_fallback_hop`이 `true`인 경우에는 없습니다.
* `has_explanation`: API 응답에 `stop_details.explanation`이 포함된 경우 `true`, 그렇지 않으면 `false`입니다. `server_fallback_hop`이 `true`인 경우에는 없습니다.
* `category`: API 응답의 `stop_details.category` 값입니다. `"cyber"`, `"bio"`, `"frontier_llm"`, `"reasoning_extraction"` 중 하나입니다. `OTEL_LOG_TOOL_DETAILS=1`이 설정되어 있고 `has_category`가 `true`인 경우에만 포함됩니다.
* `agent.name`, `skill.name`, `plugin.name`, `marketplace.name`, `mcp_server.name`, `mcp_tool.name`: 요청에 대한 스킬, 플러그인, 에이전트, MCP 귀속 정보입니다. 정의와 수정 동작은 [비용 카운터](#cost-counter)를 참조하세요.

#### API 요청 본문 이벤트

`OTEL_LOG_RAW_API_BODIES`가 설정된 경우 각 API 요청 시도에 대해 로그에 기록됩니다. 시도당 하나의 이벤트가 내보내지므로, 매개변수를 조정한 재시도는 각각 자체 이벤트를 생성합니다.

**이벤트 이름**: `claude_code.api_request_body`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"api_request_body"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `body`: 시스템 프롬프트, 메시지, 도구 등 JSON으로 직렬화된 Messages API 요청 매개변수로, 콘텐츠 한도(기본값 60 KB)에서 잘립니다. 이전 어시스턴트 턴의 확장 사고 콘텐츠는 수정됩니다. 인라인 모드(`OTEL_LOG_RAW_API_BODIES=1`)에서만 내보내집니다.
* `body_ref`: 잘리지 않은 본문이 포함된 `<dir>/<uuid>.request.json` 파일의 절대 경로입니다. 파일 모드(`OTEL_LOG_RAW_API_BODIES=file:<dir>`)에서만 내보내집니다.
* `body_length`: 잘리지 않은 본문 길이입니다. `OTEL_LOG_RAW_API_BODIES=file:<dir>`인 경우 UTF-8 바이트, `=1`인 경우 UTF-16 코드 단위입니다
* `body_truncated`: 인라인 잘림이 발생한 경우 `"true"`입니다. 파일 모드이거나 잘림이 발생하지 않은 경우에는 없습니다.
* `model`: 요청 매개변수의 모델 식별자
* `query_source`: 요청을 발행한 하위 시스템(예: `"compact"`)
* `request_body_id`: 이 시도의 요청 본문을 식별하는 UUID입니다. 성공한 시도의 [`api_response_body` 이벤트](#api-response-body-event)에도 동일한 값이 포함되므로, 응답을 이를 생성한 정확한 요청과 짝지을 수 있습니다. Claude Code v2.1.274 이상이 필요합니다

#### API 응답 본문 이벤트

`OTEL_LOG_RAW_API_BODIES`가 설정된 경우 각 성공적인 API 응답에 대해 로그에 기록됩니다.

파일 모드(`OTEL_LOG_RAW_API_BODIES=file:<dir>`)에서 Claude Code는 각 성공적인 응답에 대해 `<dir>/index.jsonl`에 JSON 한 줄을 추가하며, 여기에는 `timestamp`, `session_id`, `query_source`, `model`, `request_id`, `message_id`, `message_uuid`, `request_file`, `response_file` 필드가 포함됩니다. 텔레메트리 백엔드를 쿼리하지 않고도 특정 트랜스크립트 메시지에 해당하는 요청 및 응답 파일을 찾으려면 이 파일을 읽으세요. 인덱스 파일은 Claude Code v2.1.274 이상이 필요합니다.

**이벤트 이름**: `claude_code.api_response_body`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"api_response_body"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `body`: id, 콘텐츠 블록, 사용량, 중지 이유를 포함하는 JSON으로 직렬화된 Messages API 응답으로, 콘텐츠 한도(기본값 60 KB)에서 잘립니다. 확장 사고 콘텐츠는 수정됩니다. 인라인 모드(`OTEL_LOG_RAW_API_BODIES=1`)에서만 내보내집니다.
* `body_ref`: 잘리지 않은 본문이 포함된 `<dir>/<request_id>.response.json` 파일의 절대 경로입니다. 파일 모드(`OTEL_LOG_RAW_API_BODIES=file:<dir>`)에서만 내보내집니다.
* `body_length`: 잘리지 않은 본문 길이입니다. `OTEL_LOG_RAW_API_BODIES=file:<dir>`인 경우 UTF-8 바이트, `=1`인 경우 UTF-16 코드 단위입니다
* `body_truncated`: 인라인 잘림이 발생한 경우 `"true"`입니다. 파일 모드이거나 잘림이 발생하지 않은 경우에는 없습니다.
* `model`: 모델 식별자
* `query_source`: 요청을 발행한 하위 시스템
* `request_id`: API 요청 ID로, 예를 들면 `"req_011..."`이며 [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다.
* `request_body_id`: 이 응답이 응답하는 [`api_request_body` 이벤트](#api-request-body-event)의 `request_body_id`입니다. Claude Code v2.1.274 이상이 필요합니다
* `message.id`: API가 응답에 할당한 메시지 ID로, 응답 본문의 `id` 필드입니다. Claude Code v2.1.274 이상이 필요합니다
* `message.uuid`: 응답의 마지막 트랜스크립트 항목의 UUID입니다. `request_body_id`와 함께 트랜스크립트 메시지를 그 배후의 요청 및 응답 본문과 연결합니다. Claude Code v2.1.274 이상이 필요합니다

#### 도구 결정 이벤트

도구 권한 결정(수락/거부)이 내려질 때 로그에 기록됩니다.

**이벤트 이름**: `claude_code.tool_decision`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"tool_decision"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `tool_name`: 도구 이름(예: "Read", "Edit", "Write", "NotebookEdit")
* `tool_use_id`: 이 도구 호출의 고유 식별자입니다. 훅에 전달되는 `tool_use_id`와 일치하므로 OTel 이벤트와 훅이 캡처한 데이터를 상호 연관시킬 수 있습니다.
* `request_id`: 이 도구 호출을 포함한 API 응답의 [`request_id`](#event-correlation-attributes)로, 이를 통해 호출을 해당 응답의 API 이벤트와 조인할 수 있습니다. 해당 응답에 요청 ID가 없거나 호출을 포함한 API 응답이 없는 경우에는 없습니다. Claude Code v2.1.310 이상이 필요합니다
* `decision`: `"accept"` 또는 `"reject"`
* `tool_source`: 항상 포함됩니다. 도구의 출처로, CLI가 작성한 닫힌 값 집합입니다.
  * `"builtin"`: CLI 자체 도구
  * `"mcp"`: 일반적인 MCP 서버
  * `"sdk_host_builtin_mcp"`: Claude Desktop이 소유한 세션에서 Claude Desktop 자체에 내장된 프로세스 내 서버입니다. Claude Desktop은 자체 진입점인 `claude-desktop`, `claude-desktop-3p`, `local-agent` 중 하나에서 시작한 세션이 중첩된 하위 세션이 아닌 경우 해당 세션을 소유합니다. Claude Code 자체가 생성하는 세션을 포함한 중첩 세션은 이러한 서버를 `"mcp"`로 보고합니다
* `source`: 결정의 출처입니다.
  * `"config"`: 다음 출처 중 하나에 의해 확인을 요청하지 않고 자동으로 결정되었습니다.

    * 프로젝트 설정
    * 사용자 개인 설정의 허용 또는 거부 규칙
    * 엔터프라이즈 관리형 정책
    * `--allowedTools` 또는 `--disallowedTools` 플래그
    * 활성 권한 모드
    * 자동 모드 분류기로, 그 판정은 동일한 이벤트의 `classifier_verdict`에 기록됩니다
    * 동일한 대화형 CLI 세션에서 이전 권한 프롬프트에서 부여된 세션 나머지 기간 동안의 권한 부여
    * 본질적으로 안전한 도구

    `source` 값은 이러한 출처 중 어느 것이 일치했는지 나타내지 않습니다. 어떤 출처가 호출을 거부했는지 확인하려면 동일한 `tool_use_id`를 가진 [안전 이벤트](#safety-event)를 찾아 `category` 및 `rule_source` 속성을 읽으세요. 일부 거부된 호출은 [안전 이벤트가 없습니다](#calls-without-a-safety-event).

    Claude Code는 권한 프롬프트 요청 자체가 실패한 경우에도 `"config"`를 보고합니다. 예를 들어 Agent SDK의 [`canUseTool`](https://code.claude.com/docs/ko/agent-sdk/typescript#canusetool) 콜백이나 [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 도구가 잘못된 결과를 반환하거나, 요청이 대기 중인 동안 입력 스트림이 닫히면 해당 요청이 실패합니다.
  * `"hook"`: `PreToolUse` 또는 `PermissionRequest` 훅이 결정을 반환했습니다.
  * `"user_permanent"`: 사용자가 권한 프롬프트에서 "Yes, and don't ask again for ..."를 선택한 경우 내보내지며, 이 선택은 개인 설정에 허용 규칙을 저장합니다. 대화형 CLI에서는 해당 선택 자체에 대해서만 내보내지며, 저장된 규칙과 일치하는 이후 호출은 대신 `"config"`를 내보냅니다. Agent SDK 또는 비대화형 `-p` 세션에서는 최초 선택과 이후 규칙 일치 모두 `"user_permanent"`를 내보냅니다. 수락으로 처리됩니다.
  * `"user_temporary"`: 사용자가 권한 프롬프트에서 일회성 승인으로 "Yes"를 선택했거나, 파일 편집 또는 읽기 프롬프트에서 세션 나머지 기간 동안 액세스를 허용하는 옵션을 선택한 경우 내보내집니다. 대화형 CLI에서는 선택 자체에 대해서만 내보내지며, 해당 세션 범위 허용으로 허용된 이후 호출은 대신 `"config"`를 내보냅니다. Agent SDK 또는 비대화형 `-p` 세션에서는 선택과 이후 일치 모두 `"user_temporary"`를 내보냅니다. 수락으로 처리됩니다.
  * `"user_abort"`: 사용자가 응답하지 않고 권한 프롬프트를 닫은 경우 내보내집니다. Agent SDK 및 비대화형 `-p` 세션에서는 `canUseTool` 또는 `--permission-prompt-tool` 권한 요청이 대기 중인 동안 턴을 중단한 경우도 포함됩니다. 거부로 처리됩니다.
  * `"user_reject"`: 사용자가 확인 요청 시 "No"를 선택한 경우 내보내집니다. 대화형 CLI에서는 해당 선택 자체에 대해서만 내보내지며, 사용자 개인 설정의 거부 규칙과 일치하는 호출은 대신 `"config"`를 내보냅니다. Agent SDK 또는 비대화형 `-p` 세션에서는 개인 설정의 거부 규칙과 일치하는 호출이 `"user_reject"`를 내보냅니다. 거부로 처리됩니다.
* `classifier_verdict`: 호출에 대한 자동 모드 [분류기](https://code.claude.com/docs/ko/permission-modes.md#how-the-classifier-evaluates-actions) 판정이거나, 판정이 없었을 때 Claude Code가 호출을 거부한 이유입니다. Claude Code v2.1.301 이상이 필요합니다

  * `"allow"`: 분류기가 호출을 승인했습니다
  * `"block"`: 분류기가 호출을 차단했습니다. 도중에 실패한 분류기 확인도 `"block"`으로 끝날 수 있으므로, 부분적인 분류기 장애는 `"unavailable"`이 아니라 차단 증가로 나타날 수 있습니다
  * `"no_verdict"`: 확인은 실행되었지만 [사용 가능한 판정이 나오지 않아](https://code.claude.com/docs/ko/errors.md#auto-mode-cannot-determine-the-safety-of-an-action) Claude Code가 호출을 거부했습니다. 이 거부는 분류기가 호출을 안전하지 않다고 판단했다는 의미가 아닙니다
  * `"unavailable"`: 예를 들어 속도 제한, 타임아웃 또는 연결 오류로 분류기에 대한 요청이 실패하여 Claude Code가 호출을 거부했습니다. [서버 측 분류기 검토](https://code.claude.com/docs/ko/permission-modes.md#server-side-classifier-review)에서는 [서버가 안전 판정을 반환하지 않아](https://code.claude.com/docs/ko/errors.md#the-server-returned-no-safety-verdict) 거부된 호출도 이 값으로 표시됩니다

  이 속성은 [분류기가 플랜 모드에서 명령을 검토](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)하는 경우 플랜 모드 호출에도 나타납니다. 다음 경우에는 이 속성이 없습니다.

  * 허용 또는 거부 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)이 호출을 결정한 경우
  * Claude Code가 분류기에 묻지 않고 자동 모드에서 호출을 승인한 경우
  * [반복 차단](https://code.claude.com/docs/ko/permission-modes.md#repeated-block-thresholds) 후 Claude Code가 표시한 프롬프트에 사용자가 응답한 경우
  * `--permission-prompt-tool` 없이 실행한 `-p`에서 프롬프트에 응답할 사람이 없어 반복 차단 후 Claude Code가 호출을 거부한 경우. 해당 이벤트는 `decision`을 `"reject"`로, `source`를 `"config"`로 보고합니다
* `classifier_category` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): 분류기가 호출을 차단할 때 지목한 [기본 제공 규칙](https://code.claude.com/docs/ko/auto-mode-config.md#inspect-the-defaults-and-your-effective-config)의 이름으로, 소문자와 밑줄로 표기됩니다. 예를 들어 Data Exfiltration 규칙은 `"data_exfiltration"`입니다. Claude Code v2.1.301 이상이 필요합니다. 다음 조건이 모두 충족될 때 이 속성이 있습니다.

  * `classifier_verdict`가 `"block"`인 경우
  * 분류기가 정확히 하나의 규칙을 지목했고, 그 규칙이 사용자가 작성한 규칙이 아니라 기본 제공 규칙인 경우

  v2.1.302 이전에는 [서버 측 분류기 검토](https://code.claude.com/docs/ko/permission-modes.md#server-side-classifier-review)가 결정한 차단에서도 이 속성이 없었습니다.
* `permission_mode`: 이 호출의 권한 확인이 시작될 때 활성화된 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)로, `"default"`, `"plan"`, `"acceptEdits"`, `"bypassPermissions"`, `"dontAsk"`, `"auto"` 중 하나입니다. 수동 모드는 `"default"`로 표시됩니다. [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#permission-modes) 호출은 세션의 권한 모드가 아니라 서브에이전트의 권한 모드를 보고합니다. Claude Code v2.1.301 이상이 필요합니다
* `tool_parameters` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): 도구별 매개변수를 포함하는 JSON 문자열입니다. [도구 결과 이벤트](#tool-result-event)와 형태가 같지만 `git_commit_id` 같은 실행 후 필드는 제외됩니다. 권한 결정이 `updatedInput`을 통해 도구 입력을 다시 작성하는 경우, 수락된 호출에 대해 값이 `tool_result`와 다를 수 있습니다. `decision`이 `"reject"`인 경우 어떤 명령이 거부되었는지 확인하려면 이 속성을 사용하세요.
  * `"sdk_host_builtin_mcp"` 도구의 경우: 호스트 애플리케이션이 이 이름을 정의하므로 `OTEL_LOG_TOOL_DETAILS`가 꺼져 있어도 `mcp_server_name`과 `mcp_tool_name`이 포함됩니다. 이 이름이 없으면 이러한 기본 제공 서버 중 하나에 대한 거부된 호출을 기본 스트림에서 식별할 수 없기 때문입니다. 사용자가 구성한 MCP 서버의 경우 이벤트의 `tool_name`은 항상 리터럴 `"mcp_tool"`이며, 서버 및 도구 이름은 플래그가 켜져 있을 때 `tool_parameters`에만 나타납니다. 인수 내용은 모든 경우에 플래그가 필요합니다.
  * Bash 도구의 경우: `bash_command`, `full_command`, `timeout`, `description`, `dangerouslyDisableSandbox`를 포함합니다. 데스크톱 앱의 워크스페이스 bash 도구도 `tool_name`을 `Bash`로 보고하지만, `bash_command`, `full_command`, `timeout`만 포함합니다
  * MCP 도구의 경우: `mcp_server_name`, `mcp_tool_name`을 포함합니다
  * Skill 도구의 경우: `skill_name`을 포함합니다
  * Agent 도구 또는 레거시 Task 도구의 경우: `subagent_type`을 포함합니다

OpenTelemetry SDK의 `OTEL_LOGRECORD_ATTRIBUTE_COUNT_LIMIT`을 `tool_decision` 이벤트의 속성 수보다 낮게 설정하면, SDK는 Claude Code가 마지막으로 설정한 속성을 삭제합니다. SDK는 다른 어떤 속성보다 먼저 다음 순서로 이 속성들을 삭제하며, 이벤트에 없는 속성은 건너뜁니다.

1. `parent_agent_id`
2. `agent_id`
3. `request_id`
4. `permission_mode`
5. `classifier_category`
6. `classifier_verdict`

`permission_mode`, `classifier_category`, `classifier_verdict`는 Claude Code v2.1.302 이상에서 이 순서로 삭제됩니다. `parent_agent_id`, `agent_id`, `request_id`는 v2.1.310 이상이 필요합니다.

#### 안전 이벤트

[안전 이벤트가 없는 호출](#calls-without-a-safety-event)을 제외하고, 검사가 도구 호출을 거부하거나 권한 프롬프트를 요구할 때 로그에 기록됩니다. [샌드박스의 네트워크 프록시](https://code.claude.com/docs/ko/sandboxing.md#network-isolation)가 연결이나 요청을 거부할 때, 그리고 훅이 결과를 차단할 때도 로그에 기록됩니다. Claude Code v2.1.307 이상이 필요합니다.

이 이벤트는 다른 이벤트와 함께 내보내지며 별도의 설정이 없습니다. 이벤트 자체의 속성에는 명령 텍스트, 파일 경로, 호스트 이름, MCP 서버 및 도구 이름이 포함되지 않습니다. 레코드에는 모든 이벤트에 포함되는 [표준 속성](#standard-attributes)도 포함되며, 여기에는 `workspace.host_paths`와 [저장소 속성](#repository-attributes)이 포함될 수 있습니다. 이벤트 배후의 명령이나 MCP 도구를 확인하려면 `OTEL_LOG_TOOL_DETAILS=1`을 설정하고 일치하는 `tool_decision` 이벤트의 `tool_parameters`를 읽으세요.

**이벤트 이름**: `claude_code.safety_event`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"safety_event"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 지정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `category`: 검사 또는 결과로, [범주 값](#safety-event-categories)입니다
* `decision`: `"accept"`, `"reject"`, 또는 훅이 결과나 턴 종료를 차단한 경우 `"sent_back"`
* `decision_source`: 결정한 주체로, [`tool_decision`](#tool-decision-event)의 `source` 값 또는 `"other"`입니다
* `reason_code`: 검사의 이유로, `"rule:policySettings"`, `"mode:dontAsk"`, `"hook:PreToolUse"`, `"classifier:auto-mode"`, `"bashMiss:too-complex"`, `"unknown"` 등이 있습니다
* `reason_type`: 검사의 이유 유형으로, `"rule"`, `"subcommandResults"`, `"mode"`, `"hook"`, `"classifier"`, `"asyncAgent"` 등이 있습니다
* `rule_source`: 관련된 규칙의 설정 출처로, `"policySettings"`, `"userSettings"`, `"projectSettings"`, `"localSettings"`, `"flagSettings"`, `"cliArg"`, `"session"` 등이 있습니다
* `grant_scope`: 설정 파일에 규칙을 저장하지 않고 승인된 프롬프트의 경우 `"once"` 또는 `"session"`
* `circuit_breaker`: 내장 안전 검사로, `"dangerousRemoval"`, `"outsideReadsBlocked"`, `"claudeSettingsFile"` 등이 있습니다
* `classifier_category`: `OTEL_LOG_TOOL_DETAILS=1`인 경우 자동 모드 차단의 근거가 된 [내장 규칙](https://code.claude.com/docs/ko/auto-mode-config.md#inspect-the-defaults-and-your-effective-config)으로, 예를 들면 `"data_exfiltration"`입니다
* `hook_event`: `PreToolUse` 훅의 경우 `"pre_tool_use"`, `"hook_review"` 이벤트의 경우 `"post_tool_use"`, `"post_tool_use_failure"`, `"stop"`, `"subagent_stop"` 중 하나입니다
* `tool_class`: Bash 및 [Monitor](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool)의 경우 `"bash"`, `"powershell"`, Read, Edit, Write, NotebookEdit, Glob, Grep의 경우 `"file"`, WebFetch 및 WebSearch의 경우 `"web"`, `"mcp"`, 또는 `"other"`
* `tool_name`: 도구 이름으로, 내장 도구의 경우 `"Bash"` 등이며, 또는 `"mcp_tool"`, `"skill_tool"`, `"dynamic_tool"`, `"other_tool"` 중 하나입니다
* `tool_source`: [`tool_decision`](#tool-decision-event)과 마찬가지로 `"builtin"`, `"mcp"`, `"sdk_host_builtin_mcp"` 중 하나입니다
* `permission_mode`: 검사 시점 호출의 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)로, `"default"`, `"plan"`, `"acceptEdits"`, `"bypassPermissions"`, `"dontAsk"`, `"auto"` 중 하나입니다
* `tool_use_id`: `tool_decision` 및 `tool_result`와 마찬가지로 호출의 ID입니다
* `sandbox_violation_count`: 호출의 명령에서 발생한 고유한 연결 또는 요청 중 샌드박스의 네트워크 프록시가 거부한 수로, `"0"`부터 `"20"`까지의 문자열입니다. 포그라운드에서 완료된 샌드박스 명령에 대해 거부가 집계됩니다
* `sandbox_enabled`: 세션에서 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)이 켜져 있으면 `"true"`, 그렇지 않으면 `"false"`

다음은 관리형 설정의 거부 규칙이 Bash 명령을 거부할 때 이벤트 자체의 속성입니다.

```json theme={null}
{
  "event.name": "safety_event",
  "category": "managed_policy",
  "decision": "reject",
  "decision_source": "config",
  "reason_code": "rule:policySettings",
  "rule_source": "policySettings",
  "tool_class": "bash",
  "tool_name": "Bash",
  "tool_source": "builtin",
  "permission_mode": "default",
  "tool_use_id": "toolu_01ABC123...",
  "sandbox_violation_count": "0",
  "sandbox_enabled": "false"
}
```

##### 안전 이벤트 범주

| 값 | 검사 또는 결과 | 세부 속성 |
| - | - | - |
| `"permission_rule"` | 관리형 설정 외부의 거부 또는 확인 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions) | `rule_source` |
| `"managed_policy"` | [관리형 설정](https://code.claude.com/docs/ko/permissions.md#managed-settings)의 거부 또는 확인 규칙 | `rule_source` |
| `"permission_mode"` | [`dontAsk`](https://code.claude.com/docs/ko/permission-modes#allow-only-pre-approved-tools-with-dontask-mode) 또는 [플랜](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode) 모드, 또는 [`--permission-prompts none`](https://code.claude.com/docs/ko/headless#turn-off-permission-prompts-in-unattended-runs)처럼 프롬프트를 표시할 수 없는 세션에서의 [범주가 없는](#prompts-with-no-category) 프롬프트 | `reason_code`, `reason_type` |
| `"hook"` | [`PreToolUse`](https://code.claude.com/docs/ko/hooks#pretooluse) 또는 [`PermissionRequest`](https://code.claude.com/docs/ko/hooks#permissionrequest) 같은 훅 | `hook_event`, `reason_code` |
| `"auto_mode_block"` | 자동 모드 [분류기](https://code.claude.com/docs/ko/permission-modes.md#how-the-classifier-evaluates-actions)가 호출을 차단함 | `classifier_category` |
| `"auto_mode_no_verdict"` | 요청 실패 후처럼 사용 가능한 [분류기 판정](https://code.claude.com/docs/ko/errors.md#auto-mode-cannot-determine-the-safety-of-an-action)이 없음 | `reason_code` |
| `"safety_check"` | [작업 디렉터리](https://code.claude.com/docs/ko/permissions.md#working-directories) 외부에서의 Read, Edit 또는 Write에 대한 검사 같은 내장 안전 검사 | `circuit_breaker` |
| `"static_analysis"` | 분석하기에 너무 복잡한 경우처럼 Bash 또는 Monitor 명령이 작성된 방식 | `reason_code` |
| `"sandbox_override"` | [샌드박스 외부에서 명령을 실행](https://code.claude.com/docs/ko/sandboxing.md#the-unsandboxed-retry-escape-hatch)하기 위한 프롬프트 | `reason_code` |
| `"user_rejected"` | [범주가 없거나](#prompts-with-no-category) 훅만 요구한 프롬프트를 누군가 거절하거나 닫았거나, `canUseTool` 콜백 또는 `--permission-prompt-tool` 도구가 이를 거부함 | `decision_source` |
| `"sandbox_network"` | 호출이 실행되었고 [샌드박스의 네트워크 프록시](https://code.claude.com/docs/ko/sandboxing.md#network-isolation)가 연결이나 요청을 거부함 | `sandbox_violation_count` |
| `"sandbox_other"` | `"sandbox_network"`와 같지만, 거부된 대상 중 호스트 이름이나 IP 주소로 읽히는 것이 없음 | `sandbox_violation_count` |
| `"hook_review"` | 훅이 [호출 결과](https://code.claude.com/docs/ko/hooks.md#posttooluse-decision-control) 또는 [턴 종료](https://code.claude.com/docs/ko/hooks.md#stop-decision-control)를 차단함 | `hook_event` |
| `"other"` | 다른 값으로 설명되지 않는 거부 | `reason_code` |

어떤 `category`에서든 프록시 거부를 찾으려면 `sandbox_violation_count`가 존재하고 `"0"`이 아닌 이벤트로 필터링하세요.

##### 안전 이벤트가 없는 호출

[범주가 없는 프롬프트](#prompts-with-no-category)에 아무도 응답할 수 없어 거부된 호출을 찾으려면, `source`가 `"config"`이고 `"reject"`를 보고하며 `tool_use_id`를 공유하는 안전 이벤트가 없는 [`tool_decision`](#tool-decision-event) 이벤트를 찾으세요. 이러한 거부는 [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags)과 `--permission-prompts none`이 모두 없는 `-p` 실행에서 발생합니다.

다음과 같은 호출은 실행 후 전송되는 [`"sandbox_network"`, `"sandbox_other"` 또는 `"hook_review"` 이벤트](#safety-event-categories)를 제외하면 안전 이벤트가 없으므로 `tool_decision` 이벤트를 확인하세요.

* 범주가 없는 프롬프트에서 승인된 호출
* `PreToolUse` 훅만 요구한 프롬프트에서 `canUseTool` 콜백 또는 `--permission-prompt-tool` 도구가 승인한 호출
* 거절 여부와 관계없이 [`AskUserQuestion`](https://code.claude.com/docs/ko/tools-reference#askuserquestion-tool-behavior) 또는 `ExitPlanMode` 호출

##### 범주가 없는 프롬프트

작업 디렉터리 내부의 편집에 대한 `default` 모드 프롬프트처럼, 어떤 [`category` 값](#safety-event-categories)도 해당 검사를 지칭하지 않는 경우 프롬프트에 범주가 없습니다.

#### 권한 모드 변경 이벤트

예를 들어 `Shift+Tab` 순환, 플랜 모드 종료, 자동 모드 게이트 확인 등으로 권한 모드가 변경될 때 로그에 기록됩니다.

각 도구 호출이 확인된 권한 모드별로 도구 호출을 그룹화하려면 [도구 결정 이벤트](#tool-decision-event)의 `permission_mode`를 사용하세요.

**이벤트 이름**: `claude_code.permission_mode_changed`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"permission_mode_changed"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `from_mode`: 이전 권한 모드로, 예를 들면 `"default"`, `"plan"`, `"acceptEdits"`, `"auto"`, `"bypassPermissions"`입니다
* `to_mode`: 새 권한 모드
* `trigger`: 변경의 원인으로, 예를 들면 `"shift_tab"`, `"exit_plan_mode"`, `"auto_gate_denied"`입니다. SDK가 [`setPermissionMode()`](https://code.claude.com/docs/ko/agent-sdk/typescript#query-object)를 통해 권한 모드를 설정하는 경우처럼 일부 변경에서는 없습니다

#### 인증 이벤트

`/login` 또는 `/logout`이 완료될 때 로그에 기록됩니다.

**이벤트 이름**: `claude_code.auth`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"auth"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `action`: `"login"` 또는 `"logout"`
* `success`: `"true"` 또는 `"false"`
* `auth_method`: 인증 방법으로, 예를 들면 `"oauth"`입니다
* `error_category`: 작업이 실패한 경우 범주형 오류 종류입니다. 원시 오류 메시지는 절대 포함되지 않습니다
* `status_code`: 작업이 HTTP 오류로 실패한 경우 문자열 형식의 HTTP 상태 코드

#### MCP 서버 연결 이벤트

MCP 서버가 연결되거나, 연결이 끊기거나, 연결에 실패할 때 로그에 기록됩니다.

**이벤트 이름**: `claude_code.mcp_server_connection`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"mcp_server_connection"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `status`: `"connected"`, `"failed"`, 또는 `"disconnected"`
* `transport_type`: 서버 전송 방식으로, `"stdio"`, `"sse"`, `"http"` 등이 있습니다
* `server_scope`: 서버가 구성된 범위로, `"user"`, `"project"`, `"local"` 등이 있습니다
* `duration_ms`: 연결 시도 소요 시간(밀리초)
* `error_code`: 연결이 실패한 경우 오류 코드
* `is_plugin`: 서버가 플러그인에서 제공되는 경우 `true`, 그렇지 않으면 `false`
* `plugin_id_hash` (`is_plugin`이 `true`인 경우): 플러그인 이름과 마켓플레이스의 안정적인 해시로, 이름을 노출하지 않고 플러그인별로 이벤트를 그룹화하는 데 사용됩니다. Claude Code는 [플러그인 로드 이벤트](#plugin-loaded-event)에 설명된 방식으로 이를 계산합니다
* `plugin.name` (`is_plugin`이 `true`인 경우): 서버를 제공하는 플러그인의 이름입니다. 서드파티 플러그인의 경우 `OTEL_LOG_TOOL_DETAILS=1`이 아닌 한 리터럴 문자열 `"third-party"`이며, 이를 통해 서드파티 플러그인 이름이 기본적으로 로그에 나타나지 않도록 보호합니다. 공식 Anthropic 출처의 플러그인은 항상 이름으로 식별됩니다. `plugin_id_hash` 및 `plugin.name` 속성은 사용자 자신의 모니터링 백엔드로 전달되며 Anthropic으로 전송되지 않습니다
* `server_name` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): 구성된 서버 이름
* `error` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): 연결이 실패한 경우 전체 오류 메시지

#### 내부 오류 이벤트

Claude Code가 예기치 않은 내부 오류를 포착할 때 로그에 기록됩니다. 오류 클래스 이름과 errno 스타일 코드만 기록됩니다. 오류 메시지와 스택 트레이스는 절대 포함되지 않습니다. 이 이벤트는 Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry에 대해 실행하는 경우나 `DISABLE_ERROR_REPORTING`이 설정된 경우에는 내보내지지 않습니다.

**이벤트 이름**: `claude_code.internal_error`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"internal_error"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `error_name`: 오류 클래스 이름으로, `"TypeError"` 또는 `"SyntaxError"` 등이 있습니다
* `error_code`: 오류에 포함된 경우 `"ENOENT"` 같은 Node.js errno 코드

#### 플러그인 설치 이벤트

`claude plugin install` CLI 명령과 대화형 `/plugin` UI 모두에서 플러그인 설치가 완료될 때 로그에 기록됩니다.

**이벤트 이름**: `claude_code.plugin_installed`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"plugin_installed"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `marketplace.is_official`: 마켓플레이스가 공식 Anthropic 마켓플레이스인 경우 `"true"`, 그렇지 않으면 `"false"`
* `install.trigger`: `"cli"` 또는 `"ui"`
* `plugin.name`: 설치된 플러그인의 이름입니다. 서드파티 마켓플레이스의 경우 `OTEL_LOG_TOOL_DETAILS=1`인 경우에만 포함됩니다
* `plugin.version`: 마켓플레이스 항목에 선언된 경우 플러그인 버전입니다. 서드파티 마켓플레이스의 경우 `OTEL_LOG_TOOL_DETAILS=1`인 경우에만 포함됩니다
* `marketplace.name`: 플러그인이 설치된 마켓플레이스입니다. 서드파티 마켓플레이스의 경우 `OTEL_LOG_TOOL_DETAILS=1`인 경우에만 포함됩니다

#### 플러그인 로드 이벤트

세션 시작 시 활성화된 플러그인마다 한 번씩 로그에 기록됩니다. 설치 작업 자체를 기록하는 `plugin_installed`를 보완하여, 전체 환경에서 어떤 플러그인이 활성화되어 있는지 목록을 파악하는 데 이 이벤트를 사용하세요.

**이벤트 이름**: `claude_code.plugin_loaded`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"plugin_loaded"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `plugin.name`: 플러그인 이름입니다. 공식 마켓플레이스 및 기본 제공 번들 외부의 플러그인의 경우 `OTEL_LOG_TOOL_DETAILS=1`이 아닌 한 값은 `"third-party"`입니다
* `marketplace.name`: 알려진 경우 플러그인이 설치된 마켓플레이스입니다. `plugin.name`과 동일한 조건에서 `"third-party"`로 수정됩니다
* `plugin.version`: 플러그인 매니페스트의 버전입니다. 이름이 수정되지 않았고 매니페스트에 버전이 선언된 경우에만 포함됩니다
* `plugin.scope`: 플러그인의 출처 범주로, `"official"`, `"community"`, `"org"`, `"user-local"`, `"default-bundle"` 중 하나입니다
* `enabled_via`: 플러그인이 활성화된 방식으로, `"default-enable"`, `"org-policy"`, `"admin-install"`, `"seed-mount"`, `"user-install"` 중 하나입니다. `"admin-install"` 값은 [**Organization settings > Plugins & skills**](https://claude.ai/admin-settings/skills?tab=inventory)에서 해당 플러그인이 조직에 대해 필수 또는 자동 설치로 설정되어 있음을 의미합니다. v2.1.246 이전에는 Claude Code가 이러한 플러그인을 `"user-install"` 또는 `"seed-mount"`로 보고했습니다
* `plugin_id_hash`: 플러그인 이름과 마켓플레이스의 결정적 해시로, 구성된 익스포터로만 전송됩니다. 이름을 기록하지 않고도 전체 환경에 로드된 서로 다른 서드파티 플러그인의 수를 셀 수 있습니다. [claude.ai에서 동기화된 플러그인](https://code.claude.com/docs/ko/plugins/loading.md#synced-plugins)의 경우, Claude Code는 claude.ai가 해당 플러그인에 대해 보고하는 마켓플레이스 이름으로, 그렇지 않으면 `synced`로 플러그인 이름을 해시합니다. v2.1.246 이전에는 Claude Code가 해시에 claude.ai가 보고하는 마켓플레이스 이름을 사용하지 않았습니다
* `has_hooks`: 플러그인이 [훅 구성](https://code.claude.com/docs/ko/plugins/components.md#hooks)을 통해 또는 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md#how-a-mod-works)로서 훅을 제공하는지 여부
* `has_mcp`: 플러그인이 MCP 서버를 제공하는지 여부
* `host_owned_mcp`: SDK 호스트가 이 플러그인의 MCP 연결을 관리하여 Claude Code가 플러그인의 MCP 서버 구성 읽기를 건너뛴 경우 `true`, 그렇지 않으면 `false`
* `skill_path_count`: 플러그인이 선언한 스킬 디렉터리 수
* `command_path_count`: 플러그인이 선언한 명령 디렉터리 수
* `agent_path_count`: 플러그인이 선언한 에이전트 디렉터리 수
* `safe_mode`: 세션이 [`--safe-mode`](https://code.claude.com/docs/ko/cli-reference)로 시작된 경우 `"true"`, 그렇지 않으면 `"false"`입니다. 안전 모드에서 이 이벤트는 구성된 목록만 보고하며, 플러그인의 명령, 스킬, 훅, MCP 서버는 로드되지 않습니다. Claude Code v2.1.169 이상이 필요합니다

#### 스킬 활성화 이벤트

Claude가 Skill 도구를 통해 호출하든 사용자가 `/` 명령으로 실행하든, 스킬이 호출될 때 로그에 기록됩니다.

**이벤트 이름**: `claude_code.skill_activated`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"skill_activated"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `skill.name`: 스킬 이름입니다. 사용자 정의 및 서드파티 플러그인 스킬의 경우 `OTEL_LOG_TOOL_DETAILS=1`이 아닌 한 값은 플레이스홀더 `"custom_skill"`입니다
* `invocation_trigger`: 스킬이 트리거된 방식(`"user-slash"`, `"claude-proactive"`, 또는 `"nested-skill"`)
* `skill.source`: 스킬이 로드된 위치(예: `"bundled"`, `"userSettings"`, `"projectSettings"`, `"plugin"`)
* `skill.kind`: 스킬이 워크플로 스킬인 경우 `"workflow"`입니다. 그렇지 않으면 없습니다
* `plugin.name` (`OTEL_LOG_TOOL_DETAILS=1`이거나 플러그인이 공식 마켓플레이스에서 온 경우): 스킬이 플러그인에서 제공되는 경우 소유 플러그인의 이름
* `marketplace.name` (`OTEL_LOG_TOOL_DETAILS=1`이거나 플러그인이 공식 마켓플레이스에서 온 경우): 스킬이 플러그인에서 제공되는 경우 소유 플러그인이 설치된 마켓플레이스

#### At 멘션 이벤트

Claude Code가 프롬프트의 `@` 멘션을 확인할 때 로그에 기록됩니다. 모든 멘션이 이벤트를 내보내는 것은 아닙니다. 권한 거부, 크기가 너무 큰 파일, PDF 참조 첨부 파일, 디렉터리 목록 실패와 같은 조기 종료 경로는 로그를 기록하지 않고 반환됩니다.

Claude Code는 프롬프트를 읽을 때마다 `mention_type`이 `"agent"`인 이벤트를 최대 100개, `"mcp_resource"`인 이벤트를 최대 100개까지 로그에 기록합니다. 두 한도 중 하나를 넘는 멘션은 여전히 확인되지만 이벤트를 내보내지 않습니다.

**이벤트 이름**: `claude_code.at_mention`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"at_mention"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `mention_type`: 멘션 유형(`"file"`, `"directory"`, `"agent"`, `"mcp_resource"`, `"peer"`)입니다. `"peer"` 값은 사용자가 [다른 Claude Code 세션 중 하나](https://code.claude.com/docs/ko/cross-session-messaging.md)를 멘션했음을 의미합니다. Claude Code v2.1.232 이상이 필요합니다
* `success`: 멘션이 성공적으로 확인되었는지 여부(`"true"` 또는 `"false"`)

#### API 재시도 소진 이벤트

API 요청이 두 번 이상 시도된 후 실패할 때 한 번 로그에 기록됩니다. 최종 `api_error` 이벤트와 함께 내보내집니다.

**이벤트 이름**: `claude_code.api_retries_exhausted`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"api_retries_exhausted"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `model`: 사용된 모델
* `error`: 최종 오류 메시지
* `status_code`: 숫자 형식의 HTTP 상태 코드입니다. 비 HTTP 오류의 경우에는 없습니다.
* `total_attempts`: 총 시도 횟수
* `total_retry_duration_ms`: 모든 시도에 걸친 총 경과 시간
* `speed`: `"fast"` 또는 `"normal"`

#### 훅 등록 이벤트

세션 시작 시 구성된 훅마다 한 번씩 로그에 기록됩니다. 실행별 `hook_execution_start` 및 `hook_execution_complete` 이벤트를 보완하여, 전체 환경에서 어떤 훅이 활성화되어 있는지 목록을 파악하는 데 이 이벤트를 사용하세요.

**이벤트 이름**: `claude_code.hook_registered`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"hook_registered"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `hook_event`: 훅 이벤트 유형으로, `"PreToolUse"` 또는 `"PostToolUse"` 등이 있습니다
* `hook_type`: 훅 구현 유형으로, `"command"`, `"prompt"`, `"mcp_tool"`, `"http"`, `"agent"` 중 하나입니다
* `hook_source`: 훅이 정의된 위치로, `"userSettings"`, `"projectSettings"`, `"localSettings"`, `"flagSettings"`, `"policySettings"`, `"pluginHook"` 중 하나입니다
* `safe_mode`: 세션이 [`--safe-mode`](https://code.claude.com/docs/ko/cli-reference)로 시작된 경우 `"true"`, 그렇지 않으면 `"false"`입니다. Claude Code v2.1.169 이상이 필요합니다
* `hook_matcher` (`OTEL_LOG_TOOL_DETAILS=1`인 경우): 훅 구성의 matcher 문자열로, 설정된 경우에만 포함됩니다
* `plugin.name` (`hook_source`가 `"pluginHook"`인 경우): 훅을 제공하는 플러그인의 이름입니다. 공식 마켓플레이스 및 기본 제공 번들 외부의 플러그인의 경우 `OTEL_LOG_TOOL_DETAILS=1`이 아닌 한 값은 `"third-party"`입니다
* `plugin_id_hash` (`hook_source`가 `"pluginHook"`인 경우): 플러그인 이름과 마켓플레이스의 결정적 해시로, 구성된 익스포터로만 전송됩니다. 이름을 기록하지 않고도 훅을 제공하는 서로 다른 플러그인의 수를 셀 수 있습니다. Claude Code는 [플러그인 로드 이벤트](#plugin-loaded-event)에 설명된 방식으로 이를 계산합니다

#### 훅 실행 시작 이벤트

훅 이벤트에 대해 하나 이상의 훅이 실행을 시작할 때 로그에 기록됩니다.

**이벤트 이름**: `claude_code.hook_execution_start`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"hook_execution_start"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 정하기 위한 프로세스별 카운터로, [이벤트 상관 속성](#event-correlation-attributes)에 설명되어 있습니다
* `hook_event`: 훅 이벤트 유형으로, `"PreToolUse"` 또는 `"PostToolUse"` 등이 있습니다
* `hook_name`: matcher를 포함한 전체 훅 이름으로, 예를 들면 `"PreToolUse:Write"`입니다
* `num_hooks`: 일치하는 훅 명령 수
* `managed_only`: 관리형 정책 훅만 허용되는 경우 `"true"`
* `hook_source`: `"policySettings"` 또는 `"merged"`
* `safe_mode`: 세션이 [`--safe-mode`](https://code.claude.com/docs/ko/cli-reference)로 시작된 경우 `"true"`, 그렇지 않으면 `"false"`입니다. Claude Code v2.1.169 이상이 필요합니다
* `hook_definitions`: JSON으로 직렬화된 훅 구성입니다. 상세 베타 트레이싱과 `OTEL_LOG_TOOL_DETAILS=1`이 모두 활성화된 경우에만 포함됩니다

#### 훅 실행 완료 이벤트

훅 이벤트에 대한 모든 훅이 완료되면 기록됩니다.

**이벤트 이름**: `claude_code.hook_execution_complete`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"hook_execution_complete"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 지정하기 위한 프로세스별 카운터로, [이벤트 상관관계 속성](#event-correlation-attributes)에서 설명합니다
* `hook_event`: 훅 이벤트 유형
* `hook_name`: matcher를 포함한 전체 훅 이름
* `num_hooks`: 일치하는 훅 명령의 수
* `num_success`: 성공적으로 완료된 수
* `num_blocking`: 차단 결정을 반환한 수
* `num_non_blocking_error`: 차단 없이 실패한 수
* `num_cancelled`: 완료 전에 취소된 수
* `total_duration_ms`: 일치하는 모든 훅의 실제 경과 시간
* `stdout_chars`: 성공한 일치 훅 전체의 stdout 총 문자 수. Claude Code v2.1.280 이상이 필요합니다
* `additional_context_chars`: 일치하는 훅이 반환한 `additionalContext`의 총 문자 수. Claude Code v2.1.280 이상이 필요합니다
* `system_message_chars`: 일치하는 훅이 반환한 `systemMessage`의 총 문자 수. Claude Code v2.1.280 이상이 필요합니다
* `initial_user_message_chars`: 일치하는 훅이 반환한 `initialUserMessage`의 총 문자 수. Claude Code v2.1.280 이상이 필요합니다
* `num_outputs_persisted`: [10,000자 상한](https://code.claude.com/docs/ko/hooks.md#json-output)을 초과하여 Claude Code가 파일로 저장한 훅 출력의 수. Claude Code v2.1.280 이상이 필요합니다
* `managed_only`: 관리형 정책 훅만 허용되는 경우 `"true"`
* `hook_source`: `"policySettings"` 또는 `"merged"`
* `safe_mode`: 세션이 [`--safe-mode`](https://code.claude.com/docs/ko/cli-reference)로 시작된 경우 `"true"`, 그렇지 않으면 `"false"`. Claude Code v2.1.169 이상이 필요합니다
* `hook_definitions`: JSON으로 직렬화된 훅 구성. 상세 베타 트레이싱과 `OTEL_LOG_TOOL_DETAILS=1`이 모두 활성화된 경우에만 포함됩니다

#### 훅 플러그인 메트릭 이벤트

공식 마켓플레이스 플러그인 훅이 호출별 메트릭을 내보낼 때 기록됩니다. 공식 Anthropic 마켓플레이스에서 설치된 플러그인만 이 메트릭을 내보낼 수 있습니다. 서드파티 마켓플레이스 플러그인과 사용자가 구성한 훅은 이 이벤트로 내보내지 않습니다. 이 이벤트를 사용하면 자체 관측 스택에서 발견 비율, 비용, 소요 시간 등 플러그인 동작을 모니터링할 수 있습니다.

**이벤트 이름**: `claude_code.hook_plugin_metrics`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"hook_plugin_metrics"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 지정하기 위한 프로세스별 카운터로, [이벤트 상관관계 속성](#event-correlation-attributes)에서 설명합니다
* `plugin_id`: `<name>@<marketplace>` 형식의 플러그인 식별자
* `hook_event`: 메트릭을 내보낸 훅 이벤트 유형
* 플러그인이 내보낸 메트릭 키 최대 20개. 이름은 `^[a-z][a-z0-9_]{0,39}$`와 일치해야 합니다. 값은 Boolean 또는 숫자입니다.

#### 압축 이벤트

대화 압축이 완료되면 기록됩니다.

**이벤트 이름**: `claude_code.compaction`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"compaction"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 지정하기 위한 프로세스별 카운터로, [이벤트 상관관계 속성](#event-correlation-attributes)에서 설명합니다
* `trigger`: `"auto"` 또는 `"manual"`
* `success`: `"true"` 또는 `"false"`
* `duration_ms`: 압축 소요 시간
* `pre_tokens`: 압축 전 대략적인 토큰 수
* `post_tokens`: 압축 후 대략적인 토큰 수
* `error`: 압축이 실패한 경우의 오류 메시지
* `precompute_reuse`: `trigger`가 `"manual"`인 경우, 또는 대화형 터미널 세션의 [유휴 압축](https://code.claude.com/docs/ko/settings-reference.md#idlecompaction)에서 `trigger`가 `"auto"`인 경우에만 설정됩니다. 자동 압축은 컨텍스트 윈도우가 가득 차기 전에 백그라운드에서 요약을 준비할 수 있으며, 이 속성은 압축이 준비된 요약을 재사용했는지 여부를 기록합니다. `"hit"`는 재사용되었음을 의미하며, `"miss_custom_instructions"`, `"miss_hook"`, `"miss_not_ready"`는 대신 새 요약을 계산한 이유를 나타냅니다

#### 서브에이전트 완료 이벤트

[서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)가 완료되어 자신을 시작한 대화로 결과를 반환할 때 기록됩니다. 서브에이전트 유형별로 도구 사용량과 실행 시간을 집계하는 데 사용합니다. 토큰 또는 비용 집계에는 `query_source` `"subagent"`로 필터링한 [토큰 카운터](#token-counter)와 [비용 카운터](#cost-counter)를 사용하십시오. 이 이벤트의 `total_tokens`는 최종 요청만 포함하기 때문입니다. `"subagent"` 범주에는 서브에이전트 이벤트를 내보내지 않는 에이전트 기반 훅의 요청도 포함됩니다.

**이벤트 이름**: `claude_code.subagent_completed`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"subagent_completed"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 지정하기 위한 프로세스별 카운터로, [이벤트 상관관계 속성](#event-correlation-attributes)에서 설명합니다
* `agent_type`: 서브에이전트 유형. 기본 제공 에이전트 이름과 공식 마켓플레이스 플러그인의 에이전트는 그대로 표시되며, 그 외 에이전트 이름은 `OTEL_LOG_TOOL_DETAILS=1`이 설정되지 않은 한 `"custom"`으로 대체됩니다
* `agent.source`: 에이전트 정의의 출처: `built-in`, `plugin`, 또는 `userSettings`나 `projectSettings`처럼 사용자 지정 에이전트를 정의한 설정 소스
* `is_built_in`: 서브에이전트가 기본 제공 에이전트 유형인지 여부
* `is_async`: 서브에이전트가 [백그라운드](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)에서 실행되었는지 여부
* `total_tokens`: 서브에이전트의 최종 API 요청의 토큰 사용량으로, 해당 요청 하나의 입력, 캐시 생성, 캐시 읽기, 출력 토큰이며 대략 완료 시점의 서브에이전트 컨텍스트 크기에 해당합니다. 실행 전체의 합계가 아닙니다
* `total_tool_uses`: 서브에이전트가 실행 전체에 걸쳐 수행한 도구 호출 수
* `duration_ms`: 밀리초 단위의 실행 시간
* `model`: 서브에이전트 실행에 확정된 모델
* `final_model`: 서브에이전트의 최종 응답을 생성한 모델로, 폴백 같은 실행 중 전환이 있었다면 `model`과 다릅니다
* `model_swapped`: 둘 이상의 모델이 서브에이전트의 요청을 처리했는지 여부
* `plugin_id_hash`, `plugin.name`: 플러그인이 제공하는 에이전트에 존재합니다. 공식 마켓플레이스 플러그인 이름은 그대로 표시되며, 그 외 플러그인 이름은 `OTEL_LOG_TOOL_DETAILS=1`이 설정되지 않은 한 `"third-party"`로 대체됩니다

#### 피드백 설문 이벤트

세션 품질 설문이 표시되거나 응답될 때 기록됩니다. 설문이 수집하는 내용과 제어 방법은 [세션 품질 설문](https://code.claude.com/docs/ko/data-usage.md#session-quality-surveys)을 참조하십시오.

**이벤트 이름**: `claude_code.feedback_survey`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"feedback_survey"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 지정하기 위한 프로세스별 카운터로, [이벤트 상관관계 속성](#event-correlation-attributes)에서 설명합니다
* `event_type`: 설문 수명 주기 이벤트. 예: `"appeared"`, `"responded"`, `"transcript_prompt_appeared"`
* `appearance_id`: 하나의 설문 인스턴스에 대해 내보낸 이벤트를 연결하는 고유 ID
* `survey_type`: 이벤트를 생성한 설문. `"session"`은 "How is Claude doing?" 평가 프롬프트입니다
* `response`: `responded` 이벤트에서의 사용자 선택
* `enabled_via_override`: [`CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL`](https://code.claude.com/docs/ko/env-vars)이 설정된 경우 `true`. 문자열이 아닌 Boolean으로 내보냅니다. `session` 설문 이벤트에 존재합니다. 이 속성으로 필터링하여 재정의가 전체 환경에 적용되었는지 확인할 수 있습니다

#### 보존 정리 이벤트

[`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays) 설정보다 오래된 [세션 트랜스크립트 및 기타 애플리케이션 데이터](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)를 삭제하는 보존 정리 작업이 실행될 때마다 한 번 기록됩니다. Claude Code는 세션당 최대 한 번 백그라운드에서 정리 작업을 실행하며, 아무것도 삭제하지 않은 실행도 이벤트를 내보냅니다. 지난 24시간 동안 같은 머신의 어느 세션에서든 Claude Code가 정리 작업을 실행했다면 이번 세션의 정리 작업을 최소 10분 지연하므로, 그보다 일찍 종료되는 세션은 아무것도 내보내지 않습니다. `--bare`와 함께 `claude -p`를 실행하면 Claude Code는 정리 작업을 실행하지 않으며 아무것도 내보내지 않습니다.

이 페이지의 다른 모든 OTel 이벤트와 마찬가지로, 이 이벤트는 사용자가 구성한 텔레메트리 백엔드로만 전송됩니다. Claude Code v2.1.227 이상이 필요합니다.

Claude Code가 보존 기간을 안전하게 결정할 수 없는 경우 정리 작업을 일시 중지하고 `result`를 `"skipped"`로 설정하고 `skip_reason`을 포함한 이벤트를 내보냅니다. [관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)이 `cleanupPeriodDays`를 설정하면 관리형 값이 보존 기간을 고정하며, 우선순위가 낮은 범위의 설정 파일이 손상되었거나 유효하지 않더라도 정리 작업이 실행됩니다. `managed-settings.json` 자체를 읽을 수 없는 경우, [관리형 계층](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)이 서버 관리형 설정이나 손상된 파일 옆의 `managed-settings.d/` 드롭인 등 다른 곳에서 `cleanupPeriodDays`를 제공하지 않는 한 Claude Code는 여전히 정리 작업을 일시 중지합니다. 삭제 카운터 속성은 `result`가 `"complete"`인 경우에만 존재합니다.

**이벤트 이름**: `claude_code.retention_sweep`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"retention_sweep"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 지정하기 위한 프로세스별 카운터로, [이벤트 상관관계 속성](#event-correlation-attributes)에서 설명합니다
* `result`: 정리 작업이 실행된 경우 `"complete"`, Claude Code가 일시 중지한 경우 `"skipped"`
* `period_days`: 병합된 설정의 `cleanupPeriodDays` 값(일 단위), 또는 이를 설정하는 소스가 없으면 `30`. 건너뛴 이벤트에서는 Claude Code가 읽을 수 있었던 설정 소스로 계산한, 정리 작업이 사용했을 값입니다
* `used_default`: 읽을 수 있는 설정 소스 중 `cleanupPeriodDays`를 설정한 소스가 없으면 `"true"`, 그렇지 않으면 `"false"`. 완료 이벤트에서 `"true"`는 30일 기본값이 적용되었음을 의미합니다
* `skip_reason`: Claude Code가 스윕을 일시 중지한 이유. `result`가 `"skipped"`인 경우에만 존재합니다:
  * `"user_source_disabled"`: [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 플래그나 SDK의 [`settingSources`](https://code.claude.com/docs/ko/agent-sdk/typescript#options) 옵션 등으로 사용자 설정이 제외되었고, 활성화된 소스 중 `cleanupPeriodDays`를 제공하는 것이 없습니다
  * `"settings_unknowable"`: 설정 파일을 읽거나 파싱할 수 없어 `cleanupPeriodDays` 또는 `desktopSessionCleanupPeriodDays`가 Claude Code가 볼 수 없는 값으로 설정되어 있을 수 있습니다
  * `"settings_invalid_key_set"`: 설정에 유효성 검사 오류가 있고 `cleanupPeriodDays` 또는 `desktopSessionCleanupPeriodDays`가 명시적으로 설정되어 있어, 기본값으로 폴백하면 해당 설정에 어긋나게 파일을 삭제하거나 유지할 수 있습니다
  * `"remote_settings_unknowable"`: 서드파티 배포의 Claude Desktop Code 탭 세션이 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)을 요청했으나 사용 가능한 응답을 받지 못해, `cleanupPeriodDays`가 Claude Code가 볼 수 없는 값으로 설정되어 있을 수 있습니다
* `transcripts_deleted`: 정리 작업이 삭제한 세션 트랜스크립트, 즉 최상위 `~/.claude/projects/*/*.jsonl` 파일의 수
* `transcripts_exempted_desktop`: 보존 기간이 지났지만 [Claude Desktop 및 Cowork 규칙](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)에 따라 정리 작업이 유지한 트랜스크립트의 수. 이 항목은 `files_past_cutoff`에 포함되지 않습니다. Claude Code v2.1.248 이상이 필요합니다
* `session_files_deleted`: 세션 파일 정리 작업이 삭제한 아티팩트의 수: 트랜스크립트와 사이드카, 녹화, 도구 결과 같은 세션별 부속 파일
* `artifacts_deleted`: 세션 파일을 포함하여 정리 작업이 다루는 데이터 디렉터리 전체에서 삭제한 항목의 총수. 일부 정리 작업은 제거된 디렉터리 트리 전체를 하나의 항목으로 계산하고 몇몇 정리 단계는 카운터에 반영되지 않으므로, 이 값은 정확한 파일 수가 아니라 하한으로 취급하십시오
* `files_retained_fresh`: 검사했지만 아직 보존 기간 내에 있어 그대로 둔 파일. 파일 단위 정리 작업만 이를 계산하므로 값은 하한입니다. 0이 아닌 값이 정상적인 안정 상태입니다
* `files_past_cutoff`: 보존 기간보다 오래되었지만 권한 오류나 열려 있는 파일 등의 이유로 정리 작업이 삭제하지 못한 파일. 이 수에는 정리 작업이 `skills/synced/` 또는 `plugins/synced/` 아래에서 발견한 오래된 폴더도, 해당 폴더를 휴지통으로 옮겼는지 여부와 관계없이 각각 포함됩니다. 이러한 폴더를 제외하면 0보다 큰 값은 파일이 구성된 보존 기간보다 오래 남아 있었음을 의미합니다. 하지만 디렉터리 전체 제거에 실패한 경우 대신 `error_count`에 계산되므로, 0이라고 해서 그런 파일이 없다는 증거는 아닙니다
* `error_count`: 정리 작업이 파일을 나열하거나 삭제하는 동안 발생한 오류 수

#### 관리형 설정 확정 이벤트

세션이 확정한 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)과 함께 기록됩니다: 세션 시작 시 한 번, 세션 중 관리형 설정이나 [정책 헬퍼](https://code.claude.com/docs/ko/managed-settings.md#compute-the-policy-with-a-helper-program)의 상태가 변경될 때 다시, 그리고 `error.type` 속성에 나열된 이유 중 하나로 Claude Code가 시작을 거부하거나 세션을 종료할 때 기록됩니다.
이 이벤트를 사용하면 예상치 못한 관리형 소스로 실행 중인 머신, 정책 헬퍼가 실패하고 있는 머신, 머신이 시작을 거부한 이유를 찾을 수 있습니다.
Claude Code v2.1.274 이상이 필요합니다.

기본적으로 이 이벤트는 관리형 소스와 정책 헬퍼의 상태를 포함하지만 설정 자체는 포함하지 않습니다. 마스킹된 `managed_settings.settings` 속성과 `managed_settings.resolved_sha256` 다이제스트를 추가하려면 `OTEL_LOG_MANAGED_SETTINGS=1`을 설정하십시오:

* 관리형 설정, 사용자 설정 또는 `--settings`의 `env` 블록에 설정하거나, Claude Code를 실행하는 환경에 설정합니다. 프로젝트 또는 로컬 설정의 값으로는 켜지지 않습니다. 복제된 저장소가 해당 설정을 작성할 수 있기 때문입니다.
* 서버 관리형 설정은 [보안 승인 대화 상자](https://code.claude.com/docs/ko/server-managed-settings.md#security-approval-dialogs)를 표시하지 않고 이 변수를 설정할 수 있습니다. 이 변수는 조직이 이미 수신하는 이벤트에 조직 자체의 마스킹된 정책을 추가할 뿐이기 때문입니다.

[신뢰](https://code.claude.com/docs/ko/permissions.md#what-runs-before-you-trust-a-folder)하지 않은 폴더의 대화형 세션에서는 Claude Code가 거부 이벤트를 내보내지 않습니다.

**이벤트 이름**: `claude_code.managed_settings_resolved`

**속성**:

* 모든 [표준 속성](#standard-attributes)
* `event.name`: `"managed_settings_resolved"`
* `event.timestamp`: ISO 8601 타임스탬프
* `event.sequence`: 이벤트 순서를 지정하기 위한 프로세스별 카운터로, [이벤트 상관관계 속성](#event-correlation-attributes)에서 설명합니다
* `managed_settings.trigger`: 세션 시작 이벤트의 경우 `"startup"`, 세션 후반에 관리형 설정이나 정책 헬퍼의 상태가 변경된 경우 `"change"`, 관리형 설정 정책이 세션을 중단한 경우 `"refused"`. Claude Code는 속성이 마지막으로 보낸 이벤트와 다를 때만 `change` 이벤트를 보내며, `OTEL_LOG_MANAGED_SETTINGS`가 꺼져 있어도 설정 값이 변경되면 변경으로 간주합니다
* `error.type`: Claude Code가 세션을 중단한 이유. `refused` 이벤트에만 존재합니다:
  * `"helper_failed"`: [정책 헬퍼 실행이 실패](https://code.claude.com/docs/ko/settings-reference.md#helper-failures)했습니다
  * `"policy_invalid"`: 관리형 설정에 Claude Code의 시작을 막는 오류가 있거나, 관리자 소스가 읽기 거부 이외의 이유로 로드되지 않아 Claude Code가 조직 로그인이나 공급자 적용을 확인할 수 없습니다
  * `"provider_not_allowed"`: 세션이 관리형 [`allowedProviders`](https://code.claude.com/docs/ko/settings-reference#allowedproviders) 목록에서 허용하지 않는 API 공급자를 사용하거나, 공급자의 트래픽을 허용되지 않는 호스트로 보내려 했습니다. Claude Code v2.1.285 이상이 필요합니다
  * `"consent_rejected"`: 사용자가 서버 관리형 설정에 대한 [보안 승인 대화 상자](https://code.claude.com/docs/ko/server-managed-settings.md#security-approval-dialogs)를 거부했습니다
  * `"force_refresh_failed"`: [`forceRemoteSettingsRefresh`](https://code.claude.com/docs/ko/settings-reference#forceremotesettingsrefresh)가 요구하는 설정 가져오기가 실패했습니다
  * `"gateway_rejected"`: [Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)가 관리형 설정 로드에 HTTP 403으로 응답했습니다
  * `"version_below_minimum"`: 이 버전의 Claude Code가 [`requiredMinimumVersion`](https://code.claude.com/docs/ko/settings-reference#requiredminimumversion)보다 낮거나 [`requiredMaximumVersion`](https://code.claude.com/docs/ko/settings-reference#requiredmaximumversion)보다 높습니다
  * `"_OTHER"`: Claude apps 게이트웨이 관리형 설정 로드가 다른 이유로 실패했습니다
* `managed_settings.sources`: [정책 키](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)를 하나 이상 제공하는 모든 관리형 소스로, 우선순위가 가장 높은 것부터 나열되며 `first-wins`에서 키가 적용되지 않는 소스도 포함됩니다. 값은 MDM 또는 OS 수준 정책의 경우 `"remote"`, `"plist"` 또는 `"hklm"`, 관리형 설정 파일 및 드롭인의 경우 `"file"`, [임베딩 호스트](https://code.claude.com/docs/ko/managed-settings.md#let-an-embedding-host-add-policy)가 설정을 제공하는 경우 `"parent"`, Claude Code가 [읽는 경우](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources) [Windows HKCU 레지스트리 값](https://code.claude.com/docs/ko/managed-settings.md#where-each-mechanism-stores-the-policy)에 대해 `"hkcu"`입니다. 제어 키만 포함하거나 Claude Code가 읽을 수 없었던 소스는 나열되지 않습니다. 문자열 배열로 내보내며, 정책 키를 제공하는 관리형 소스가 없으면 비어 있습니다
* `managed_settings.source_behavior`: Claude Code가 읽은 [`managedSourcesBehavior`](https://code.claude.com/docs/ko/settings-reference#managedsourcesbehavior) 값으로, `"first-wins"` 또는 `"merge"`입니다. 이 키를 설정하는 소스가 없으면 `"first-wins"`입니다
* `managed_settings.helper.state`: 선택된 MDM 또는 파일 소스가 구성하는 정책 헬퍼의 상태:
  * `"ok"`: 헬퍼의 출력이 관리형 설정으로 사용됩니다
  * `"bad_path"`, `"not_a_file"`, `"exit_nonzero"`, `"timed_out"`, `"oversize"`, `"parse_failed"`, `"envelope_invalid"` 또는 `"schema_rejected"`: 헬퍼의 마지막 실행이 실패했습니다. [헬퍼 실패](https://code.claude.com/docs/ko/settings-reference.md#helper-failures)에서 각 경우를 설명합니다
  * `"none"`: 헬퍼가 구성되지 않았거나, 헬퍼를 구성하는 소스가 MDM 정책 또는 관리형 설정 파일이 아닙니다
* `managed_settings.helper.applied`: 헬퍼 자체의 출력이 관리형 설정으로 사용되는 동안 `"output"`, 그렇지 않으면 `"none"`
* `managed_settings.helper.entry`: Claude Code가 [`policyHelper`](https://code.claude.com/docs/ko/settings-reference#policyhelper)를 선택한 경우 `"policyHelper"`. 헬퍼를 선택하지 않은 경우 존재하지 않습니다
* `managed_settings.helper.path`: 헬퍼에 구성된 [`path`](https://code.claude.com/docs/ko/settings-reference#policyhelper-path). `OTEL_LOG_MANAGED_SETTINGS` 설정 여부와 관계없이 Claude Code가 헬퍼를 선택한 경우 항상 존재합니다
* `managed_settings.resolved_sha256` (`OTEL_LOG_MANAGED_SETTINGS=1`인 경우): 마스킹 전 확정된 관리형 설정의 SHA-256으로, 키를 재귀적으로 정렬하고 공백 없이 JSON으로 직렬화한 값입니다. 다이제스트가 같은 머신은 같은 정책을 실행합니다. 짧은 정책은 추측값을 해싱하여 복원될 수 있으므로 Claude Code는 옵트인한 경우에만 다이제스트를 보냅니다. 확정된 관리형 설정이 없는 경우와 `refused` 이벤트에는 존재하지 않습니다
* `managed_settings.settings` (`OTEL_LOG_MANAGED_SETTINGS=1`인 경우): 확정된 관리형 설정의 이름과 구조를 값을 마스킹한 JSON 문자열로 나타냅니다. `refused` 이벤트에는 존재하지 않습니다. Claude Code는 설정 스키마를 기반으로 이를 생성합니다:

  * 스키마가 선언한 설정 이름은 내보내고, 선언하지 않은 키는 제외합니다
  * Boolean, 숫자, 그리고 `permissions.defaultMode`처럼 스키마가 고정된 옵션 집합으로 제한하는 문자열 값은 그대로 내보냅니다. `sandbox.network.httpProxyPort`와 `sandbox.network.socksProxyPort`는 `"[REDACTED]"`로 내보냅니다
  * `model`, `apiKeyHelper`, 모든 `env` 값, 모든 URL, 모든 명령 등 그 밖의 모든 문자열은 `"[REDACTED]"`로 내보냅니다
  * `env` 변수 이름이나 플러그인 ID 같은 맵의 항목 이름은 그대로 내보냅니다. `vimInsertModeRemaps`처럼 스키마가 항목의 유형을 지정하지 않는 설정은 단일 `"[REDACTED]"`로 내보내며, `sandbox.ignoreViolations`는 명령 패턴 없이 경로 목록의 목록으로 내보냅니다
  * 목록은 길이를 유지하며, 각 항목은 같은 규칙에 따라 마스킹됩니다
  * `permissions.allow`, `permissions.deny` 또는 `permissions.ask` 규칙은 도구가 이 버전의 Claude Code에 기본 제공되거나 `mcp__jira__create_issue` 같은 `mcp__` 참조인 경우 `Read([REDACTED])`처럼 내용을 마스킹한 도구 이름으로 내보냅니다. 그 밖의 규칙은 `"[REDACTED]"`로 내보냅니다
  * 훅도 같은 규칙을 따르므로, `type`과 `timeout` 같은 고정 옵션 및 숫자 필드는 표시되고, 각 명령, URL, `matcher`, `if` 조건은 `"[REDACTED]"`로 내보냅니다

  예를 들어 `apiKeyHelper`, 두 개의 `env` 변수, 거부 규칙이 있는 관리형 설정은 `{"apiKeyHelper":"[REDACTED]","env":{"HTTPS_PROXY":"[REDACTED]","CLAUDE_CODE_ENABLE_TELEMETRY":"[REDACTED]"},"permissions":{"deny":["Read([REDACTED])"]}}`로 내보냅니다.

  Claude Code는 값을 UTF-8 기준 8 KB에서 자르며, 잘린 값은 유효한 JSON이 아닙니다
* `managed_settings.settings_truncated` (`managed_settings.settings`가 존재하는 경우): Claude Code가 `managed_settings.settings`를 8 KB에서 잘랐으면 `true`, 그렇지 않으면 `false`. 문자열이 아닌 Boolean으로 내보냅니다

## 메트릭 및 이벤트 데이터 해석

내보낸 메트릭 및 이벤트는 다양한 분석을 지원합니다:

### 사용 모니터링

| 메트릭 | 분석 기회 |
| - | - |
| `claude_code.token.usage` | 토큰 [`type`](#token-counter), 사용자, 팀, 모델, `skill.name`, `plugin.name` 또는 `agent.name`별로 분류 |
| `claude_code.session.count` | 시간 경과에 따른 채택 및 참여 추적 |
| `claude_code.lines_of_code.count` | 코드 추가 및 제거를 추적하여 생산성 측정, 모델별로 분류 |
| `claude_code.commit.count` & `claude_code.pull_request.count` | 개발 워크플로우에 미치는 영향 이해 |

### 비용 모니터링

`claude_code.cost.usage` 메트릭은 다음에 도움이 됩니다:

* 팀 또는 개인 전체의 사용 추세 추적
* 최적화를 위한 높은 사용 세션 식별
* `skill.name`, `plugin.name` 및 `agent.name` 속성을 통해 특정 스킬, 플러그인 또는 서브에이전트 유형에 지출 귀속

> [!NOTE]
>
> 비용 메트릭은 근사값입니다. 공식 청구 데이터는 API 제공자(Claude Console, Amazon Bedrock 또는 Google Cloud의 Agent Platform)를 참조하세요.

Claude Code는 `ANTHROPIC_BASE_URL` 뒤의 게이트웨이 또는 프록시가 여러 프레임에 걸쳐 사용량을 점진적으로 스트리밍할 때를 포함하여 각 스트리밍 응답을 비용 및 토큰 메트릭에 정확히 한 번 계산합니다.

### 경고 및 세분화

일반적인 경고 고려 사항:

* 비용 급증
* 비정상적인 토큰 소비
* 특정 사용자의 높은 세션 볼륨

모든 메트릭은 [표준 속성](#standard-attributes)으로 세분화할 수 있습니다. `model` 속성은 `claude_code.token.usage`, `claude_code.cost.usage` 및 `claude_code.lines_of_code.count`에서 사용할 수 있습니다.

커밋의 모델별 분류는 한 세션이 여러 모델에 걸쳐 있을 수 있으므로 `session.id`에서 토큰 또는 비용 메트릭에 대해 조인하여만 근사할 수 있습니다. 토큰 또는 비용 측면을 `query_source`가 `"main"`인 행으로 필터링하여 보조 및 서브에이전트 요청이 세션의 커밋을 해당 요청을 수행하지 않은 모델에 귀속시키지 않도록 합니다.

### 재시도 소진 감지

Claude Code는 실패한 API 요청을 내부적으로 재시도하고 포기한 후에만 단일 `claude_code.api_error` 이벤트를 내보내므로 이벤트 자체가 해당 요청의 최종 신호입니다. 중간 재시도 시도는 별도의 이벤트로 기록되지 않습니다.

이벤트의 `attempt` 속성은 시도 횟수를 기록합니다. `CLAUDE_CODE_MAX_RETRIES`는 기본값이 10이고 최대 15입니다. [`CLAUDE_CODE_RETRY_WATCHDOG`](https://code.claude.com/docs/ko/env-vars)을 설정하면 기본값이 더 높아지고 상한이 없습니다.

요청이 일시적 오류에 대한 모든 재시도를 소진하면 `attempt`는 최대 해당 유효 제한보다 하나 많은 값이 됩니다: 기본값으로는 11입니다.

더 낮은 값도 재시도가 소진되었음을 의미할 수 있습니다: Claude Code가 스트리밍 실패 후 요청을 다시 보낼 때마다 `attempt`는 `1`부터 다시 시작합니다.

복구된 세션과 정체된 세션을 구분하려면 `session.id`로 이벤트를 그룹화하고 오류 후 나중에 `api_request` 이벤트가 존재하는지 확인합니다.

### 이벤트 분석

이벤트 데이터는 Claude Code 상호 작용에 대한 자세한 정보를 제공합니다:

**도구 사용 패턴**: 도구 결과 이벤트를 분석하여 다음을 식별합니다:

* 가장 자주 사용되는 도구
* 도구 성공률
* 평균 도구 실행 시간
* 도구 유형별 오류 패턴

**성능 모니터링**: API 요청 지속 시간 및 도구 실행 시간을 추적하여 성능 병목 현상을 식별합니다.

### 입력 토큰을 OpenTelemetry GenAI 시맨틱 규칙에 매핑

Claude Code는 입력 토큰 수를 API 응답의 usage 블록에 표시된 그대로 내보내므로, 이 값에는 [프롬프트 캐시](https://code.claude.com/docs/ko/prompt-caching.md)에서 읽거나 캐시에 기록한 토큰이 포함되지 않습니다:

* [`claude_code.llm_request`](#span-attributes) 스팬과 [`api_request`](#api-request-event) 이벤트의 `input_tokens`
* [`claude_code.token.usage`](#token-counter) 메트릭의 `"input"` 유형

Claude Code는 `gen_ai.usage.*` 속성을 설정하지 않습니다. [OpenTelemetry GenAI 시맨틱 규칙](https://github.com/open-telemetry/semantic-conventions-genai)에 따르면 `gen_ai.usage.input_tokens`에는 캐시에서 읽거나 캐시에 기록한 토큰이 포함되어야 합니다. 해당 합계를 계산하려면 다음과 같이 합니다:

* 스팬 또는 이벤트에서: `input_tokens`, `cache_read_tokens`, `cache_creation_tokens`를 더합니다
* `claude_code.token.usage` 메트릭에서: `"input"`, `"cacheRead"`, `"cacheCreation"` 유형을 더합니다

이 규칙은 캐시 읽기와 캐시 쓰기에 대한 별도의 속성도 정의합니다:

* `cache_read_tokens`는 `gen_ai.usage.cache_read.input_tokens`에 매핑됩니다
* `cache_creation_tokens`는 `gen_ai.usage.cache_write.input_tokens`에 매핑됩니다. 이전 버전의 규칙에서는 캐시 쓰기 속성의 이름이 `gen_ai.usage.cache_creation.input_tokens`이므로, 백엔드에서 요구하는 이름을 사용하세요.

## 감사 보안 이벤트

OpenTelemetry 이벤트는 Claude Code 활동의 감사 데이터 소스입니다. 모든 이벤트는 도구 호출, MCP 활동 및 권한 결정을 해당 이벤트를 트리거한 사용자에게 연결하는 ID 속성을 전달하며, OTLP 로그 내보내기는 이러한 이벤트를 OTLP 수신기가 있는 모든 SIEM(Security Information and Event Management) 플랫폼 또는 SIEM으로 전달하는 OpenTelemetry Collector에 전달할 수 있습니다.

### 속성 작업을 사용자에게 연결

각 이벤트의 [표준 속성](#standard-attributes)에는 인증된 사용자의 ID가 포함됩니다: Claude 계정으로 로그인할 때 또는 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에서 세션 자체의 자격 증명이 이들을 전달할 때의 `user.email`, `user.account_uuid`, `user.account_id` 및 `organization.id`, 그리고 `user.id` 및 세션별 `session.id`. `user.id`는 설치 범위 식별자이며, [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)를 통해 `/login`으로 로그인한 세션에서는 게이트웨이 발급 토큰의 IdP 주체입니다.

개발자가 시작한 세션에서 MCP 도구 호출, Bash 명령 및 파일 편집은 따라서 해당 개발자에게 귀속됩니다. 이 경우 Claude Code는 별도의 서비스 계정으로 작동하지 않습니다. 각 이벤트에 기록된 ID는 개발자 자신의 Claude 계정이거나 [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 세션의 개발자 IdP 신원입니다. Claude Tag 채널 세션에서는 Claude가 대신 조직의 [공유 신원](https://code.claude.com/docs/ko/cloud-environments.md#set-the-environment-a-claude-tag-channel-uses)으로 작동합니다.

Claude Code가 직접 API 키로 인증하거나 Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry에 대해 인증할 때 세션에 Claude 계정이 없으며 `user.id` 및 `session.id`만 채워집니다. 이러한 배포에서는 `OTEL_RESOURCE_ATTRIBUTES`를 사용하여 사용자 ID를 직접 첨부하고, [관리형 설정](#administrator-configuration) 파일 또는 시작 래퍼를 통해 사용자별로 설정합니다. Claude 앱 게이트웨이 세션은 이 중 어느 것도 필요하지 않습니다: [표준 속성](#standard-attributes)을 참조하여 해당 내보내기가 전달하는 ID를 확인합니다.

```bash theme={null}
export OTEL_RESOURCE_ATTRIBUTES="enduser.id=jdoe@example.com,enduser.directory_id=S-1-5-21-..."
```

### MCP 활동 감사

전체 호출 세부 정보로 MCP 서버 활동을 캡처하려면 로그 내보내기를 활성화하고 `OTEL_LOG_TOOL_DETAILS=1`을 설정합니다. 각 MCP 작업은 표준 ID 속성과 함께 서버 이름, 도구 이름 및 호출 인수를 전달하는 구조화된 이벤트를 생성합니다:

| 이벤트 | MCP에 대해 기록하는 것 |
| - | - |
| `mcp_server_connection` | 서버 연결, 연결 해제 및 연결 실패 (`server_name`, `transport_type`, `server_scope` 및 오류 세부 정보 포함) |
| `tool_result` | 각 MCP 도구 호출 (`tool_name` 및 `mcp_server_scope` 포함, `mcp_server_name` 및 `mcp_tool_name`을 포함하는 `tool_parameters` 페이로드, 호출 인수를 포함하는 `tool_input` 페이로드) |
| `tool_decision` | 호출이 허용되었는지 거부되었는지, 그리고 결정이 구성, 훅 또는 사용자에서 나왔는지 여부, 그리고 `mcp_server_name` 및 `mcp_tool_name`을 포함하는 `tool_parameters` 페이로드 |

`OTEL_LOG_TOOL_DETAILS` 없이 이러한 이벤트는 식별 세부 정보를 삭제합니다:

* `tool_result`: `mcp_server_scope`를 유지하고 사용자 구성 서버의 경우 `tool_name`을 리터럴 `"mcp_tool"`로 수정하며, 인수 내용을 생략합니다. Claude Desktop의 기본 제공 서버의 경우, Claude Desktop이 소유한 세션에서는 `tool_parameters` 내부의 `mcp_server_name`/`mcp_tool_name` 쌍도 유지하며, `tool_decision`과 동일한 호스트 작성 예외입니다
* `tool_decision`: `tool_source`를 유지하고 사용자 구성 서버의 경우 `tool_name`을 리터럴 `"mcp_tool"`로 수정하며, 인수 내용을 생략합니다. Claude Desktop의 기본 제공 서버의 경우, Claude Desktop이 소유한 세션에서는 `tool_parameters` 내부의 `mcp_server_name`/`mcp_tool_name` 쌍도 유지합니다
* `mcp_server_connection`: `server_name` 및 오류 메시지를 생략하지만, `is_plugin`, `plugin_id_hash` 및 `plugin.name`을 유지하며, Anthropic이 아닌 플러그인 이름은 리터럴 `"third-party"`로 수정되므로 플러그인 제공 서버는 상세 로깅 없이도 구별 가능합니다

### 보안 질문을 이벤트에 매핑

감지 규칙을 구축할 때 모니터링하려는 신호를 찾고 해당 이벤트 및 속성에 대해 백엔드를 쿼리합니다:

| 신호 | 이벤트 | 주요 속성 |
| - | - | - |
| 도구 호출 허용 또는 거부, 그리고 구성, 훅 또는 사용자 등 결정이 나온 출처 | [`tool_decision`](#tool-decision-event) | `decision`, `source`, `classifier_verdict`, `permission_mode`, `tool_name`; `OTEL_LOG_TOOL_DETAILS=1`을 설정한 경우 `tool_parameters` |
| 어떤 검사가 도구 호출을 거부했거나 해당 호출에 대해 권한 프롬프트를 요구했는지 | `category`가 `"managed_policy"`, `"permission_rule"`, `"hook"` 또는 `"auto_mode_block"`처럼 검사를 나타내는 [`safety_event`](#safety-event). 실행되지 않은 호출의 경우 `decision`은 `"reject"`입니다. 일부 호출에는 [안전 이벤트가 없습니다](#calls-without-a-safety-event) | `category`, `decision`, `reason_code`, `rule_source`, `tool_name`, `tool_use_id` |
| 자동 모드 분류기가 도구 호출을 허용 또는 차단했거나, Claude Code가 분류기 판정 없이 호출을 거부함 | `classifier_verdict`가 있는 [`tool_decision`](#tool-decision-event). 판정 없는 거부의 경우 `classifier_verdict`는 `"no_verdict"` 또는 `"unavailable"`입니다 | `classifier_verdict`, `permission_mode`, `tool_name`; `OTEL_LOG_TOOL_DETAILS=1`을 설정한 경우 `classifier_category` |
| 권한 모드 에스컬레이션 | `permission_mode_changed` | `from_mode`, `to_mode`, `trigger` |
| 서브에이전트가 수행하는 호출을 포함하여 각 도구 호출이 어떤 권한 모드에서 확인되었는지 | [`tool_decision`](#tool-decision-event) | `permission_mode`, `session.id` |
| 정책 훅이 작업을 차단함 | `hook_execution_complete` | `hook_event`, `num_blocking` |
| 훅이 어떤 도구 호출을 거부했는지, 그리고 훅이 어떤 결과 또는 턴 종료를 차단했는지 | 거부된 호출의 경우 `category`가 `"hook"`이고 `decision`이 `"reject"`인 [`safety_event`](#safety-event), 차단된 결과 또는 턴 종료의 경우 `category`가 `"hook_review"`인 이벤트 | `category`, `decision`, `hook_event`; 도구 호출의 경우 `tool_use_id` |
| 샌드박스의 네트워크 프록시가 Bash 또는 PowerShell 명령의 연결 또는 요청을 거부함 | `sandbox_violation_count`가 있고 `"0"`이 아닌 [`safety_event`](#safety-event) | `sandbox_violation_count`, `category`, `sandbox_enabled`, `tool_use_id` |
| 로그인, 로그아웃 및 인증 실패 | `auth` | `action`, `success`, `error_category` |
| MCP 서버 연결 또는 실패 | `mcp_server_connection` | `status`, `server_name`, `is_plugin`, `error_code` |
| 플러그인 설치 및 출처 | `plugin_installed` | `plugin.name`, `marketplace.name`, `marketplace.is_official` |
| 실행된 명령 및 터치된 파일 | `tool_result` (실행됨) 또는 `tool_decision` (거부됨) (`OTEL_LOG_TOOL_DETAILS=1` 포함) | `tool_parameters`; `tool_input` (`tool_result`만 해당) |
| 머신이 실행되는 관리형 설정 소스, 정책 도우미의 상태 및 머신이 시작을 거부한 이유 | `managed_settings_resolved` | `managed_settings.trigger`, `managed_settings.sources`, `managed_settings.source_behavior`, `managed_settings.helper.state`, `error.type`; `managed_settings.settings` 및 `managed_settings.resolved_sha256` (`OTEL_LOG_MANAGED_SETTINGS=1` 포함) |

Claude Code는 원본 이벤트 스트림만 내보냅니다. 이상 감지, 기준선 설정, 세션 간 상관 관계 및 경고는 SIEM 또는 관찰성 백엔드의 책임입니다.

### 이그레스 경로를 관리형 컨트롤 및 이벤트에 매핑

이 표는 세션 콘텐츠를 머신 외부로 전달할 수 있는 경로와 로컬 보존을, 이를 제한하는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md) 키 및 이를 기록하는 이벤트와 짝지어 보여 줍니다. `/feedback` 보고서처럼 Claude Code 자체가 Anthropic에 전송하는 내용은 [데이터 사용](https://code.claude.com/docs/ko/data-usage.md)을 참조하세요. 각 이름은 값과 기본값을 제공하는 참조 항목으로 연결됩니다.

| 경로 | 관리형 컨트롤 | 이벤트 |
| - | - | - |
| Bash 및 PowerShell 명령 | [`sandbox.enabled`](https://code.claude.com/docs/ko/settings-reference#sandbox-enabled), [`sandbox.failIfUnavailable`](https://code.claude.com/docs/ko/settings-reference#sandbox-failifunavailable), [`sandbox.allowUnsandboxedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-allowunsandboxedcommands), [`sandbox.network.allowManagedDomainsOnly`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowmanageddomainsonly), [`sandbox.network.allowedDomains`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-alloweddomains) | [`tool_decision`](#tool-decision-event), [`tool_result`](#tool-result-event) |
| MCP 서버 | [`allowedMcpServers`](https://code.claude.com/docs/ko/settings-reference#allowedmcpservers), [`allowManagedMcpServersOnly`](https://code.claude.com/docs/ko/settings-reference#allowmanagedmcpserversonly), [`deniedMcpServers`](https://code.claude.com/docs/ko/settings-reference#deniedmcpservers), [`managed-mcp.json`](https://code.claude.com/docs/ko/managed-mcp) | [`mcp_server_connection`](#mcp-server-connection-event), `tool_decision`, `tool_result` |
| 훅 | [`allowManagedHooksOnly`](https://code.claude.com/docs/ko/settings-reference#allowmanagedhooksonly), [`allowedHttpHookUrls`](https://code.claude.com/docs/ko/settings-reference#allowedhttphookurls) | [`hook_registered`](#hook-registered-event), [`hook_execution_start`](#hook-execution-start-event), [`hook_execution_complete`](#hook-execution-complete-event) |
| 플러그인 | [`strictKnownMarketplaces`](https://code.claude.com/docs/ko/settings-reference#strictknownmarketplaces), [`disableSideloadFlags`](https://code.claude.com/docs/ko/settings-reference#disablesideloadflags), [`syncClaudeAiPlugins`](https://code.claude.com/docs/ko/settings-reference#syncclaudeaiplugins), [`syncClaudeAiSkills`](https://code.claude.com/docs/ko/settings-reference#syncclaudeaiskills) | [`plugin_installed`](#plugin-installed-event), [`plugin_loaded`](#plugin-loaded-event) |
| [WebFetch](https://code.claude.com/docs/ko/permissions.md#webfetch) | [`permissions.deny`](https://code.claude.com/docs/ko/settings-reference#permissions-deny), [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ko/settings-reference#allowmanagedpermissionrulesonly) | `tool_decision`, `tool_result` |
| Artifact 등 claude.ai에 업로드하는 도구 | `permissions.deny`, [`enableArtifact`](https://code.claude.com/docs/ko/settings-reference#enableartifact) | `tool_decision`, `tool_result` |
| Remote Control | [`disableRemoteControl`](https://code.claude.com/docs/ko/settings-reference#disableremotecontrol) | 전용 이벤트 없음 |
| 로컬 트랜스크립트 보존 | [`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays) | [`retention_sweep`](#retention-sweep-event) |

`allowedHttpHookUrls`, `managed-mcp.json` 및 훅 이벤트 항목에는 표에 나온 것 이상의 설명이 필요합니다:

* **`allowedHttpHookUrls`**: 항목이 설정 파일 간에 병합되므로 개발자가 비어 있는 관리형 목록에 항목을 추가할 수 있습니다. 어떤 훅이 실행될지는 `allowManagedHooksOnly`가 결정합니다
* **`managed-mcp.json`**: MCP를 끄려면 [MCP 완전히 비활성화](https://code.claude.com/docs/ko/managed-mcp.md#disable-mcp-entirely)를 참조하세요. Claude Code가 파일을 읽는지 확인하려면 [구성 검증](https://code.claude.com/docs/ko/managed-mcp.md#validate-the-configuration)을 참조하세요
* **훅 이벤트**: Claude Code는 일치하는 모든 훅을 포괄하여 훅 이벤트당 한 번씩 `hook_execution_start` 및 `hook_execution_complete`를 로그에 기록합니다. `OTEL_LOG_TOOL_DETAILS=1`만으로는 HTTP 훅의 URL이 기록되지 않습니다. 훅 구성은 `hook_definitions`에만 나타나며, 여기에는 상세 베타 트레이싱도 필요합니다

`OTEL_LOG_TOOL_DETAILS=1`은 이러한 이벤트에 명령 문자열, 서버 및 도구 이름, 도구 입력을 추가합니다. 이 세부 정보에는 세션 자체와 동일한 민감한 콘텐츠가 포함될 수 있으므로, 수집기가 해당 콘텐츠를 보관하도록 승인된 경우에만 활성화하세요.

### 보존 정리 확인

모든 머신에 동일한 보존 기간을 적용하려면 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 [`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays)를 설정합니다. 머신이 해당 값으로 정리를 실행하는지 확인하려면 [`retention_sweep`](#retention-sweep-event) 이벤트를 수집합니다. `period_days`와 카운터는 문자열이므로 비교하기 전에 숫자로 변환합니다.

| 머신이 보고하는 내용 | 의미 |
| - | - |
| `result`가 `"skipped"` | Claude Code가 정리를 일시 중지했습니다. `skip_reason`에 원인이 표시됩니다 |
| `used_default`가 `"true"`이거나 `period_days`가 관리형 값과 다름 | 머신이 관리형 `cleanupPeriodDays`를 적용하지 않고 있습니다 |
| `error_count`가 0보다 큼 | 정리 중 파일을 나열하거나 삭제하는 동안 오류가 발생했으므로 보존 기간이 지난 데이터가 남아 있을 수 있습니다 |
| `files_past_cutoff`가 0보다 큼 | 정리에서 보존 기간이 지난 파일을 삭제하지 못했거나, 오래된 동기화된 스킬 및 플러그인 폴더를 발견했습니다. `error_count`와 함께 확인합니다 |
| 이벤트 없음 | 그 자체로는 실패가 아닙니다 |

의도한 대로 작동하는 머신도 다음과 같은 이유로 이벤트가 없을 수 있습니다:

* **아무도 Claude Code를 시작하지 않음**: 정리가 실행되지 않으며, 머신은 다음 실행 때까지 데이터를 유지합니다
* **세션이 계속 열려 있음**: Claude Code는 세션당 최대 한 번 정리를 실행합니다
* **세션이 일찍 종료됨**: 세션이 종료될 때 완료되지 않은 정리는 아무것도 내보내지 않으며, 예기치 않은 오류로 중지된 정리도 마찬가지입니다

정리가 모든 경로를 다루지는 않습니다. [삭제할 때까지 유지되는 항목](https://code.claude.com/docs/ko/claude-directory.md#kept-until-you-delete-them)에 남는 항목이 나열되어 있으며, [로컬 데이터 지우기](https://code.claude.com/docs/ko/claude-directory.md#clear-local-data)에서 이를 제거하는 방법을 확인할 수 있습니다.

### SIEM에 이벤트 전송

`OTEL_EXPORTER_OTLP_LOGS_ENDPOINT`를 SIEM의 OTLP 수신기 또는 SIEM의 기본 수집 API로 전달하는 OpenTelemetry Collector로 지정합니다. 다음 관리형 설정 예는 이벤트만 내보내고 MCP 및 Bash 감사를 위해 전체 도구 세부 정보를 활성화합니다:

```json theme={null}
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_LOG_TOOL_DETAILS": "1",
    "OTEL_EXPORTER_OTLP_LOGS_PROTOCOL": "http/protobuf",
    "OTEL_EXPORTER_OTLP_LOGS_ENDPOINT": "https://siem.example.com:4318/v1/logs",
    "OTEL_EXPORTER_OTLP_HEADERS": "Authorization=Bearer your-siem-token"
  }
}
```

이벤트가 도착하는지 확인하려면 이 구성에서 실행 중인 세션에서 프롬프트를 제출하고 `claude_code.user_prompt` 이벤트에 대해 SIEM을 확인합니다. 아무것도 도착하지 않으면 `claude --debug-file <path>`로 Claude Code를 시작하고 `[3P telemetry]` 내보내기 오류에 대해 해당 로그를 확인합니다.

## 백엔드 고려 사항

메트릭, 로그 및 추적 백엔드 선택은 수행할 수 있는 분석 유형을 결정합니다:

### 메트릭용 백엔드

* **시계열 데이터베이스**: 비율 계산, 집계된 메트릭
* **컬럼형 저장소**: 복잡한 쿼리, 고유 사용자 분석
* **완전한 기능의 관찰성 플랫폼**: 고급 쿼리, 시각화, 경고

### 이벤트 및 로그용 백엔드

* **로그 집계 시스템**: 전체 텍스트 검색, 로그 분석
* **컬럼형 저장소**: 구조화된 이벤트 분석
* **완전한 기능의 관찰성 플랫폼**: 메트릭과 이벤트 간의 상관 관계

### 추적용 백엔드

분산 추적 저장소 및 스팬 상관 관계를 지원하는 백엔드를 선택합니다:

* **분산 추적 시스템**: 스팬 시각화, 요청 워터폴, 지연 시간 분석
* **완전한 기능의 관찰성 플랫폼**: 추적 검색 및 메트릭과 로그와의 상관 관계

일일/주간/월간 활성 사용자 (DAU/WAU/MAU) 메트릭이 필요한 조직의 경우 효율적인 고유 값 쿼리를 지원하는 백엔드를 고려하세요.

## 서비스 정보

모든 메트릭 및 이벤트는 다음 리소스 속성과 함께 내보내집니다:

* `service.name`: 터미널 세션의 경우 `claude-code`, [Claude Desktop 앱](https://code.claude.com/docs/ko/desktop.md)의 Code 탭에서 시작된 로컬 세션의 경우 `claude-code-desktop`
* `service.version`: 현재 Claude Code 버전, 또는 로컬 Code 탭 세션의 경우 Desktop 앱 버전
* `os.type`: 운영 체제 유형 (예: `linux`, `darwin`, `windows`)
* `os.version`: 운영 체제 버전 문자열
* `host.arch`: 호스트 아키텍처 (예: `amd64`, `arm64`)
* `wsl.version`: WSL 버전 번호 (Windows Subsystem for Linux에서 실행할 때만 표시)
* 미터 이름: `com.anthropic.claude_code`

수집기 파이프라인 또는 대시보드에서 `service.name = claude-code`로 필터링하는 경우, 로컬 Code 탭 세션의 텔레메트리도 캡처하기 위해 필터에 `claude-code-desktop`을 추가하십시오.

## ROI 측정 리소스

Claude Code의 투자 수익률 측정에 대한 포괄적인 가이드(원격 측정 설정, 비용 분석, 생산성 메트릭 및 자동화된 보고 포함)는 [Claude Code ROI 측정 가이드](https://github.com/anthropics/claude-code-monitoring-guide)를 참조하세요. 이 저장소는 즉시 사용 가능한 Docker Compose 구성, Prometheus 및 OpenTelemetry 설정, Linear와 같은 도구와 통합된 생산성 보고서 생성 템플릿을 제공합니다.

## 보안 및 개인 정보 보호

* OpenTelemetry 내보내기는 선택 사항이며 명시적 구성이 필요합니다. Anthropic의 별도 운영 원격 측정 및 이를 비활성화하는 방법에 대해서는 [데이터 사용](https://code.claude.com/docs/ko/data-usage.md#telemetry-services)을 참조하세요
* 원본 파일 콘텐츠 및 코드 스니펫은 메트릭 또는 이벤트에 포함되지 않습니다. 추적 스팬은 별도의 데이터 경로입니다: 아래의 `OTEL_LOG_TOOL_CONTENT` 항목을 참조하세요
* OAuth를 통해 인증된 경우 `user.email`이 원격 측정 속성에 포함되며, 구성한 OTel 엔드포인트로만 전송되고 Anthropic으로는 절대 전송되지 않습니다. 조직에서 이것이 우려 사항인 경우 원격 측정 백엔드와 함께 작업하여 이 필드를 필터링하거나 수정하세요
* 사용자 프롬프트 콘텐츠는 기본적으로 수집되지 않습니다. 프롬프트 길이만 기록됩니다. 프롬프트 콘텐츠를 포함하려면 `OTEL_LOG_USER_PROMPTS=1`을 설정하세요. 활성화되면:
  * `user_prompt` 이벤트는 `prompt`와 [`prompt_text`](#user-prompt-event)라는 두 속성에 프롬프트 텍스트를 전달합니다. 수집기에서 속성 이름으로 이벤트의 프롬프트 텍스트를 삭제하거나 마스킹하는 경우 규칙에 두 속성을 모두 지정하세요

    다음 OpenTelemetry Collector `attributes` 프로세서는 이를 나열하는 파이프라인에서 두 속성을 모두 삭제합니다:

    ```yaml theme={null}
    processors:
      attributes/drop-prompt-text:
        actions:
          - key: prompt
            action: delete
          - key: prompt_text
            action: delete
    ```

  * [추적](#traces-beta)이 켜져 있으면 `claude_code.interaction` 스팬은 `user_prompt` 속성에 프롬프트 텍스트를 전달합니다

  * 상세 베타 추적에서는 스팬이 각 요청과 함께 전송되는 새 사용자 메시지, 도구 결과, 시스템 리마인더, 시스템 프롬프트 텍스트 및 모델 출력도 전달합니다. [상세 베타 추적의 콘텐츠 속성](#new-context-gates)에 각 속성이 나열되어 있습니다. `claude_code.system_prompt` 이벤트는 전체 시스템 프롬프트를 전달합니다
* 어시스턴트 응답 텍스트는 기본적으로 수집되지 않습니다. 응답 길이만 기록됩니다. 응답 텍스트를 포함하려면 `OTEL_LOG_ASSISTANT_RESPONSES=1`을 설정하세요. Claude Code의 모든 OpenTelemetry 데이터와 마찬가지로 응답 텍스트는 구성한 OTel 엔드포인트로만 전송되며 Anthropic으로는 전송되지 않습니다. 이 변수가 설정되지 않으면 `OTEL_LOG_USER_PROMPTS`가 폴백으로 사용되므로 이벤트에서 프롬프트 콘텐츠는 원하지만 응답 콘텐츠는 원하지 않는 경우 `OTEL_LOG_ASSISTANT_RESPONSES=0`을 설정하세요. 상세 베타 추적에서 `claude_code.llm_request` 스팬은 여전히 [`response.model_output`](#new-context-gates)에 모델 출력을 전달하며, 이는 이 변수가 아닌 `OTEL_LOG_USER_PROMPTS`를 따릅니다
* 도구 입력 인수 및 매개변수는 기본적으로 기록되지 않습니다. 이를 포함하려면 `OTEL_LOG_TOOL_DETAILS=1`을 설정하세요. Claude Desktop의 기본 제공 서버의 경우, Claude Desktop이 소유한 세션에서 `tool_decision` 및 `tool_result`는 인수 콘텐츠가 아닌 호스트 작성 이름인 `mcp_server_name`/`mcp_tool_name` 쌍을 전달하며, 플래그가 꺼져 있어도 그렇습니다. 이 데이터는 구성한 OTEL 엔드포인트로만 전송되며 Anthropic으로는 절대 전송되지 않습니다. 인수에는 여전히 민감한 값이 포함될 수 있으므로 필요에 따라 이러한 속성을 필터링하거나 수정하도록 텔레메트리 백엔드를 구성하세요. 활성화되면:
  * `tool_result` 및 `tool_decision` 이벤트는 Bash 명령, MCP 서버 및 도구 이름, 스킬 이름이 포함된 `tool_parameters` 속성을 포함합니다. `full_command`와 같은 필드는 잘리지 않은 상태로 내보내집니다
  * `tool_result` 이벤트는 추가로 파일 경로, URL, 검색 패턴 및 기타 인수가 포함된 `tool_input` 속성을 포함합니다. 512자를 초과하는 개별 값은 잘리고 전체는 약 4K 문자로 제한됩니다
  * `user_prompt` 이벤트는 사용자 정의, 플러그인 및 MCP 명령의 축자 `command_name`을 포함합니다
  * [비용 및 토큰 카운터](#cost-counter) 및 `api_request`, `api_error`, `api_refusal` 이벤트는 속성 귀속에서 실제 에이전트, 스킬, 플러그인, MCP 서버 및 도구 이름을 전달합니다
  * `claude_code.tool` 스팬은 `file_path`와 같은 입력 파생 속성을 전달합니다. 상세 베타 추적에서는 [`tool_input`](#new-context-gates) 속성도 전달합니다
* 도구 콘텐츠는 기본적으로 추적 스팬에 기록되지 않습니다. 이를 포함하려면 `OTEL_LOG_TOOL_CONTENT=1`을 설정하세요. 그러면 `claude_code.tool` 스팬은 원본 파일 콘텐츠, Bash 명령 출력, MCP 도구, WebFetch 및 WebSearch가 반환하는 것이 포함된 [`tool.output` 스팬 이벤트](#tool-output-span-event)를 전달하며, 속성당 콘텐츠 제한(기본값 60KB)에서 잘립니다. MCP 도구, WebFetch 및 WebSearch의 결과는 Claude Code v2.1.283 이상이 필요합니다. 도구 콘텐츠는 또한 [`new_context`를 통해 스팬에 도달하며, 그 제어는 스팬마다 다릅니다](#new-context-gates). 필요에 따라 이러한 속성을 필터링하거나 수정하도록 원격 측정 백엔드를 구성하세요
* 원본 Anthropic Messages API 요청 및 응답 본문은 기본적으로 기록되지 않습니다. 이를 포함하려면 셸, 사용자 설정 또는 관리 설정에서 `OTEL_LOG_RAW_API_BODIES`를 설정하세요. [프로젝트 및 로컬 설정](https://code.claude.com/docs/ko/settings-reference.md#variables-claude-code-ignores-in-env)에서는 무시됩니다. 본문에는 전체 대화 기록(시스템 프롬프트, 모든 이전 사용자 및 어시스턴트 턴, 도구 결과)이 포함되므로 이를 활성화하면 다른 `OTEL_LOG_*` 콘텐츠 플래그가 공개할 모든 것에 동의하는 것을 의미합니다. Claude Code는 다른 설정에 관계없이 항상 이러한 본문에서 Claude의 확장 사고 콘텐츠를 수정합니다. 설정한 값은 Claude Code가 본문을 전달하는 방식을 결정합니다:
  * `=1`일 때 Claude Code는 각 API 호출에 대해 `api_request_body` 및 `api_response_body` 로그 이벤트를 내보냅니다. 이벤트의 `body` 속성은 JSON 직렬화된 페이로드를 전달하며, 콘텐츠 제한(기본값 60KB)에서 잘립니다
  * `=file:<dir>`일 때 Claude Code는 잘리지 않은 본문을 해당 디렉토리 아래의 `.request.json` 및 `.response.json` 파일에 기록하고, 이벤트는 인라인 본문 대신 `body_ref` 경로를 전달합니다. 로그 수집기 또는 사이드카와 함께 디렉토리를 배포하되 원격 측정 스트림을 통해서는 배포하지 마세요.

    각 성공적인 응답에 대해 Claude Code는 또한 해당 디렉토리의 `index.jsonl`에 한 줄을 추가하여 응답 파일을 이를 생성한 요청 파일 및 이것이 된 트랜스크립트 메시지에 연결합니다. 각 줄은 메시지 콘텐츠를 포함하지 않으며, [API 응답 본문 이벤트](#api-response-body-event) 섹션에 해당 필드가 나열됩니다. 인덱스 파일은 Claude Code v2.1.274 이상이 필요합니다

## Amazon Bedrock에서 Claude Code 모니터링

Amazon Bedrock의 Claude Code 사용 모니터링에 대한 자세한 지침은 [Claude Code 모니터링 구현 (Amazon Bedrock)](https://github.com/aws-solutions-library-samples/guidance-for-claude-code-with-amazon-bedrock/blob/main/assets/docs/MONITORING.md)을 참조하세요.
