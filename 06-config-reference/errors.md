> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 오류 참조

> Claude Code 런타임 오류 메시지를 조회하고 각 오류의 의미와 해결 방법을 확인합니다.

이 페이지에는 Claude Code가 표시하는 런타임 오류와 각 오류에서 복구하는 방법, 그리고 오류 없이 응답이 이상해 보일 때 확인할 사항이 나열되어 있습니다. `command not found` 또는 설정 중 TLS 오류와 같은 설치 오류는 [문제 해결](/ko/troubleshoot-install)을 참조하십시오.

이러한 오류 및 복구 명령은 CLI, [데스크톱 앱](/ko/desktop), [웹의 Claude Code](/ko/claude-code-on-the-web)에 모두 적용됩니다. 세 가지 모두 동일한 Claude Code CLI를 래핑하기 때문입니다. 표면별 문제는 해당 표면의 페이지에 있는 문제 해결 섹션을 참조하십시오.

<Note>
  Claude Code는 모델 응답을 위해 Claude API를 호출하므로 대부분의 런타임 오류는 기본 API 오류 코드에 매핑됩니다. 이 페이지에서는 Claude Code 내에서 각 오류의 의미와 복구 방법을 다룹니다. 원본 HTTP 상태 코드 정의는 [Claude Platform 오류 참조](https://platform.claude.com/docs/en/api/errors)를 참조하십시오.
</Note>

## 오류 찾기

터미널에 표시되는 메시지를 아래 섹션과 일치시킵니다.

| 메시지                                                                                           | 섹션                                                                                    |
| :-------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------ |
| `API Error: 500 Internal server error`                                                        | [서버 오류](#api-error-500-internal-server-error)                                         |
| `API Error: Repeated 529 Overloaded errors`                                                   | [서버 오류](#api-error-repeated-529-overloaded-errors)                                    |
| `Request timed out`                                                                           | [서버 오류](#request-timed-out), 또는 메시지에 인터넷 연결이 언급된 경우 [네트워크](#unable-to-connect-to-api) |
| `<model> is temporarily unavailable, so auto mode cannot determine the safety of...`          | [서버 오류](#auto-mode-cannot-determine-the-safety-of-an-action)                          |
| `Auto mode could not evaluate this action and is blocking it for safety`                      | [서버 오류](#auto-mode-cannot-determine-the-safety-of-an-action)                          |
| `Auto mode classifier transcript exceeded context window`                                     | [서버 오류](#auto-mode-cannot-determine-the-safety-of-an-action)                          |
| `You've hit your session limit` / `You've hit your weekly limit`                              | [사용 제한](#youve-hit-your-session-limit)                                                |
| `Server is temporarily limiting requests`                                                     | [사용 제한](#server-is-temporarily-limiting-requests)                                     |
| `Request rejected (429)`                                                                      | [사용 제한](#request-rejected-429)                                                        |
| `Credit balance is too low`                                                                   | [사용 제한](#credit-balance-is-too-low)                                                   |
| `Not logged in · Please run /login`                                                           | [인증](#not-logged-in)                                                                  |
| `Invalid API key`                                                                             | [인증](#invalid-api-key)                                                                |
| `This organization has been disabled`                                                         | [인증](#this-organization-has-been-disabled)                                            |
| `Your organization has disabled Claude subscription access`                                   | [인증](#your-organization-has-disabled-claude-subscription-access)                      |
| `Routines are disabled by your organization's policy`                                         | [인증](#routines-are-disabled-by-your-organizations-policy)                             |
| `OAuth token revoked` / `OAuth token has expired`                                             | [인증](#oauth-token-revoked-or-expired)                                                 |
| `does not meet scope requirement user:profile`                                                | [인증](#oauth-scope-requirement)                                                        |
| `Unable to connect to API`                                                                    | [네트워크](#unable-to-connect-to-api)                                                     |
| `SSL certificate verification failed`                                                         | [네트워크](#ssl-certificate-errors)                                                       |
| `403` with `x-deny-reason: host_not_allowed` in a cloud or routine session                    | [네트워크](#host-not-allowed-in-a-cloud-session)                                          |
| `Prompt is too long`                                                                          | [요청 오류](#prompt-is-too-long)                                                          |
| `Error during compaction: Conversation too long`                                              | [요청 오류](#error-during-compaction-conversation-too-long)                               |
| `Request too large`                                                                           | [요청 오류](#request-too-large)                                                           |
| `Image was too large`                                                                         | [요청 오류](#image-was-too-large)                                                         |
| `Unable to resize image`                                                                      | [요청 오류](#unable-to-resize-image)                                                      |
| `PDF too large` / `PDF is password protected`                                                 | [요청 오류](#pdf-errors)                                                                  |
| `Extra inputs are not permitted`                                                              | [요청 오류](#extra-inputs-are-not-permitted)                                              |
| `There's an issue with the selected model`                                                    | [요청 오류](#theres-an-issue-with-the-selected-model)                                     |
| `Claude Opus is not available with the Claude Pro plan`                                       | [요청 오류](#claude-opus-is-not-available-with-the-claude-pro-plan)                       |
| `thinking.type.enabled is not supported for this model`                                       | [요청 오류](#thinking-type-enabled-is-not-supported-for-this-model)                       |
| `max_tokens must be greater than thinking.budget_tokens`                                      | [요청 오류](#thinking-budget-exceeds-output-limit)                                        |
| `API Error: 400 due to tool use concurrency issues`                                           | [요청 오류](#tool-use-or-thinking-block-mismatch)                                         |
| `Claude Code is unable to respond to this request, which appears to violate our Usage Policy` | [요청 오류](#usage-policy-refusal)                                                        |
| 응답 품질이 평소보다 낮아 보임                                                                             | [응답 품질](#responses-seem-lower-quality-than-usual)                                     |

## 자동 재시도

Claude Code는 오류를 표시하기 전에 일시적 오류를 재시도합니다. 서버 오류, 과부하 응답, 요청 시간 초과, 임시 429 스로틀, 끊어진 연결은 모두 지수 백오프를 사용하여 최대 10회 재시도됩니다. 재시도하는 동안 스피너는 `Retrying in Ns · attempt x/y` 카운트다운을 표시합니다.

이 페이지의 오류 중 하나를 보면 해당 재시도가 이미 소진되었습니다. 두 가지 환경 변수로 동작을 조정할 수 있습니다.

| 변수                                        | 기본값    | 효과                                                          |
| :---------------------------------------- | :----- | :---------------------------------------------------------- |
| [`CLAUDE_CODE_MAX_RETRIES`](/ko/env-vars) | 10     | 재시도 횟수입니다. 스크립트에서 오류를 더 빨리 표시하려면 낮추고, 더 긴 인시던트를 기다리려면 높입니다. |
| [`API_TIMEOUT_MS`](/ko/env-vars)          | 600000 | 요청당 시간 초과(밀리초)입니다. 느린 네트워크 또는 프록시의 경우 높입니다.                 |

## 서버 오류

이러한 오류는 계정이나 요청이 아닌 추론 제공자에서 발생합니다. Anthropic API의 경우 Anthropic 인프라를 의미합니다. Bedrock, Vertex AI, Foundry 또는 사용자 정의 게이트웨이의 경우 해당 제공자의 인프라를 의미합니다.

### API Error: 500 Internal server error

Claude Code는 모든 5xx 응답에 대해 상태 코드와 API의 오류 메시지를 표시합니다. 아래 예제는 Anthropic API의 500 응답을 보여줍니다.

```text theme={null}
API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check https://status.claude.com.
```

뒤따르는 문장은 서비스 상태를 확인할 위치를 나타내며 제공자에 따라 다릅니다. Bedrock, Vertex AI 및 Foundry 구성은 해당 제공자의 서비스 상태를 나타냅니다. 사용자 정의 `ANTHROPIC_BASE_URL`은 게이트웨이 호스트를 나타냅니다.

이는 API 내부의 예기치 않은 오류를 나타냅니다. 프롬프트, 설정 또는 계정으로 인한 것이 아닙니다.

**할 일:**

* [status.claude.com](https://status.claude.com) 또는 메시지에 나열된 제공자 상태 페이지에서 활성 인시던트 확인
* 1분 기다린 후 메시지를 다시 보냅니다. 원본 메시지는 여전히 대화에 있으므로 긴 프롬프트의 경우 전체를 다시 붙여넣는 대신 `try again`을 입력할 수 있습니다.
* 게시된 인시던트가 없는데도 오류가 지속되면 `/feedback`을 실행하여 Anthropic이 요청 세부 정보로 조사할 수 있도록 합니다. 환경에서 `/feedback`을 사용할 수 없는 경우 [오류 보고](#report-an-error)를 참조하십시오.

### API Error: Repeated 529 Overloaded errors

API가 모든 사용자에게 일시적으로 용량이 가득 찼습니다. Claude Code는 이 메시지를 표시하기 전에 이미 여러 번 재시도했습니다.

```text theme={null}
API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check https://status.claude.com.
```

뒤따르는 문장은 500 오류와 동일한 방식으로 제공자에 따라 다릅니다. 529는 사용 제한이 아니며 할당량에 대해 계산되지 않습니다.

**할 일:**

* [status.claude.com](https://status.claude.com) 또는 메시지에 나열된 제공자 상태 페이지에서 용량 공지 확인
* 몇 분 후 다시 시도
* `/model`을 실행하고 다른 모델로 전환하여 계속 작업합니다. 용량은 모델별로 추적되기 때문입니다. Claude Code는 한 모델이 특히 높은 부하를 받을 때 이를 수행하도록 프롬프트합니다. 예를 들어 `Opus is experiencing high load, please use /model to switch to Sonnet`.

### Request timed out

API가 연결 기한 전에 응답하지 않았습니다.

```text theme={null}
Request timed out
```

이는 높은 부하 기간 또는 매우 큰 응답이 생성될 때 발생할 수 있습니다. 기본 요청 시간 초과는 10분입니다.

**할 일:**

* 요청 재시도
* 장기 실행 작업의 경우 작업을 더 작은 프롬프트로 나눕니다.
* 느린 네트워크 또는 프록시가 원인인 경우 [자동 재시도](#automatic-retries)에 설명된 대로 `API_TIMEOUT_MS`를 높입니다.
* 시간 초과가 자주 발생하고 네트워크가 정상인 경우 아래 [네트워크 및 연결 오류](#network-and-connection-errors)를 참조하십시오.

### Auto mode cannot determine the safety of an action

[자동 모드](/ko/permission-modes#eliminate-prompts-with-auto-mode)가 작업을 분류하는 데 사용하는 모델이 결정을 생성할 수 없어서 자동 모드가 작업을 자동으로 승인하지 않았습니다. 표시되는 메시지는 분류기가 실패한 이유에 따라 다릅니다.

작업 디렉토리 내의 읽기, 검색 및 편집은 분류기를 건너뛰므로 이러한 모든 경우에 계속 작동합니다.

분류기 모델이 과부하 상태일 때:

```text theme={null}
<model> is temporarily unavailable, so auto mode cannot determine the safety of <tool> right now. Wait briefly and then try this action again.
```

**할 일:**

* 몇 초 후 재시도합니다. Claude는 동일한 메시지를 보고 일반적으로 자동으로 재시도합니다.
* 재시도가 계속 실패하면 읽기 전용 작업을 계속하고 나중에 차단된 작업으로 돌아갑니다.
* 이는 일시적이며 [자동 모드 적격성](/ko/permission-modes#eliminate-prompts-with-auto-mode)과 무관합니다. 설정을 변경할 필요가 없습니다.

분류기가 구문 분석할 수 없는 응답을 반환했을 때:

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — run with --debug for details
```

**할 일:**

* 작업을 재시도합니다. 일반적으로 다음 시도에서 성공합니다.
* `claude --debug`를 실행하고 작업을 반복하여 디버그 로그에서 기본 분류기 응답을 확인합니다.

대화가 분류기의 컨텍스트 윈도우보다 커졌을 때:

```text theme={null}
Auto mode classifier transcript exceeded context window — falling back to manual approval (try /compact to reduce conversation size)
```

대화형 세션에서 자동 모드는 해당 작업에 대해 일반 권한 프롬프트로 폴백하므로 수동으로 승인하거나 거부할 수 있습니다. [비대화형 모드](/ko/headless)에서는 트랜스크립트만 증가하고 재시도가 성공할 수 없기 때문에 실행이 중단됩니다.

**할 일:**

* 나타나는 프롬프트에서 작업을 승인하거나 거부합니다.
* `/compact`를 실행하여 대화 크기를 줄여서 후속 작업이 분류기 윈도우에 맞도록 합니다.

## 사용 제한

이러한 오류는 계정 또는 플랜에 연결된 할당량에 도달했음을 의미합니다. 이는 모든 사람에게 영향을 미치는 [서버 오류](#server-errors)와는 다릅니다.

### 세션 제한에 도달했습니다

구독 플랜에는 롤링 사용 허용량이 포함됩니다. 소진되면 다음 메시지 중 하나가 표시됩니다.

```text theme={null}
You've hit your session limit · resets 3:45pm
You've hit your weekly limit · resets Mon 12:00am
You've hit your Opus limit · resets 3:45pm
```

Claude Code는 메시지에 표시된 재설정 시간까지 추가 요청을 차단합니다.

**할 일:**

* 오류에 표시된 재설정 시간을 기다립니다.
* `/usage`를 실행하여 플랜 제한 및 재설정 시간을 확인합니다.
* `/usage-credits`를 실행하여 Pro 및 Max에서 추가 사용을 구매하거나 Team 및 Enterprise에서 관리자에게 요청합니다. [유료 플랜에 대한 사용 크레딧](https://support.claude.com/ko/articles/12429409-extra-usage-for-paid-claude-plans)을 참조하여 청구 방식을 확인하십시오.
* 더 높은 기본 제한을 위해 플랜을 업그레이드하려면 [claude.com/pricing](https://claude.com/pricing)을 참조하십시오.

제한에 도달하기 전에 남은 허용량을 확인하려면 `rate_limits` 필드를 [사용자 정의 상태 줄](/ko/statusline#rate-limit-usage)에 추가하거나 데스크톱 앱에서 모델 선택기 옆의 [사용 링](/ko/desktop#check-usage)을 클릭합니다.

### 서버가 일시적으로 요청을 제한 중입니다

API가 플랜 할당량과 무관한 단기 스로틀을 적용했습니다.

```text theme={null}
API Error: Server is temporarily limiting requests (not your usage limit)
```

이는 표시되기 전에 [자동으로 재시도](#automatic-retries)됩니다.

**할 일:**

* 잠시 기다린 후 다시 시도합니다.
* 지속되면 [status.claude.com](https://status.claude.com)을 확인합니다.

### 요청 거부됨 (429)

API 키, Amazon Bedrock 프로젝트 또는 Google Vertex AI 프로젝트에 대해 구성된 속도 제한에 도달했습니다.

```text theme={null}
API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check https://status.claude.com.
```

뒤따르는 문장은 서비스 상태를 확인할 위치를 나타내며 제공자에 따라 다릅니다. Bedrock, Vertex AI 및 Foundry 구성은 Anthropic 상태 페이지 대신 해당 제공자의 서비스 상태를 나타냅니다. 사용자 정의 `ANTHROPIC_BASE_URL`은 게이트웨이 호스트를 나타냅니다.

**할 일:**

* `/status`를 실행하고 활성 자격 증명이 예상한 것인지 확인합니다. 환경의 잘못된 `ANTHROPIC_API_KEY`가 구독 대신 저가형 키를 통해 요청을 라우팅할 수 있습니다.
* 제공자 콘솔에서 활성 제한을 확인하고 필요한 경우 더 높은 계층을 요청합니다.
* Anthropic API 키의 경우 [속도 제한 참조](https://platform.claude.com/docs/ko/api/rate-limits)에서 계층이 작동하는 방식과 워크스페이스별 상한을 설정하는 방법을 참조하십시오.
* 동시성 감소: [`CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY`](/ko/env-vars)를 낮추고, 많은 병렬 서브에이전트 실행을 피하거나, 대량 스크립팅 실행을 위해 `/model`로 더 작은 모델로 전환합니다.

### 크레딧 잔액이 너무 낮습니다

Console 조직이 선불 크레딧을 모두 사용했습니다.

```text theme={null}
Credit balance is too low
```

**할 일:**

* [platform.claude.com/settings/billing](https://platform.claude.com/settings/billing)에서 크레딧을 추가하고 자동 재로드를 활성화하여 잔액이 0에 도달하기 전에 자동으로 충전되도록 합니다.
* Pro, Max, Team 또는 Enterprise 플랜이 있는 경우 `/login`으로 구독 인증으로 전환합니다.
* Console에서 워크스페이스별 지출 상한을 설정하여 단일 프로젝트가 조직 잔액을 소진하지 않도록 합니다. [비용 효율적으로 관리](/ko/costs)를 참조하십시오.

## 인증 오류

이러한 오류는 Claude Code가 API에 대한 신원을 증명할 수 없음을 의미합니다. 언제든지 `/status`를 실행하여 현재 활성 자격 증명을 확인합니다.

### Not logged in

이 세션에 유효한 자격 증명이 없습니다.

```text theme={null}
Not logged in · Please run /login
```

**할 일:**

* `/login`을 실행하여 Claude 구독 또는 Console 계정으로 인증합니다.
* 환경 변수가 인증할 것으로 예상한 경우 `ANTHROPIC_API_KEY`가 설정되어 있고 `claude`를 시작한 셸에서 내보내졌는지 확인합니다.
* 대화형 로그인이 불가능한 CI 또는 자동화의 경우 시작 시 키를 가져오는 [`apiKeyHelper`](/ko/settings#available-settings) 스크립트를 구성합니다.
* [인증 우선순위](/ko/authentication#authentication-precedence)를 참조하여 여러 자격 증명이 있을 때 어느 것이 우선하는지 이해합니다.

반복적으로 로그인하라는 메시지가 표시되면 시스템 시계 및 macOS Keychain 수정을 위해 [로그인되지 않음 또는 토큰 만료](/ko/troubleshoot-install#not-logged-in-or-token-expired)를 참조하십시오.

### Invalid API key

`ANTHROPIC_API_KEY` 환경 변수 또는 `apiKeyHelper` 스크립트가 API가 거부한 키를 반환했습니다.

```text theme={null}
Invalid API key · Fix external API key
```

**할 일:**

* 오타를 확인하고 [Console](https://platform.claude.com/settings/keys)에서 키가 취소되지 않았는지 확인합니다.
* 동일한 셸에서 `env | grep ANTHROPIC`을 실행합니다. direnv, dotenv 셸 플러그인, IDE 터미널과 같은 도구는 명시적으로 설정하지 않고도 프로젝트의 `.env` 파일에서 오래된 키를 로드할 수 있습니다.
* `ANTHROPIC_API_KEY`를 설정 해제하고 `/login`을 실행하여 대신 구독 인증을 사용합니다.
* 키가 [`apiKeyHelper`](/ko/settings#available-settings) 스크립트에서 오는 경우 스크립트를 직접 실행하여 stdout에 유효한 키를 인쇄하는지 확인합니다.
* `/status`를 실행하여 Claude Code가 실제로 사용 중인 자격 증명 소스를 확인합니다.

### This organization has been disabled

비활성화된 Console 조직의 오래된 `ANTHROPIC_API_KEY`가 구독 로그인을 재정의하고 있습니다.

```text theme={null}
Your ANTHROPIC_API_KEY belongs to a disabled organization · Unset the environment variable to use your other credentials
API Error: 400 ... This organization has been disabled.
```

환경 변수는 `/login`보다 우선하므로 셸 프로필에서 내보내거나 `.env` 파일에서 로드된 키는 작동하는 Pro 또는 Max 구독이 있어도 사용됩니다. 비대화형 모드(`-p`)에서는 키가 있을 때 항상 사용됩니다.

**할 일:**

* 현재 셸에서 `ANTHROPIC_API_KEY`를 설정 해제하고 셸 프로필에서 제거한 후 `claude`를 다시 시작합니다.
* 그 후 `/status`를 실행하여 활성 자격 증명이 구독인지 확인합니다.
* 환경 변수가 설정되지 않았는데도 오류가 지속되면 비활성화된 조직이 `/login`에 연결된 것입니다. 지원팀에 문의하거나 다른 계정으로 로그인합니다.

### Your organization has disabled Claude subscription access

Claude 조직이 구독 로그인으로 Claude Code에 로그인하는 것을 허용하지 않습니다. 동일한 계정으로 `/login`을 다시 실행하면 동일한 오류가 반환됩니다.

```text theme={null}
Your organization has disabled Claude subscription access for Claude Code · Use an Anthropic API key instead, or ask your admin to enable access
```

이는 서버 측 조직 설정이므로 로컬 설정, 환경 변수 또는 CLI 플래그에서 재정의할 수 없습니다. Agent SDK 및 `-p` 비대화형 모드는 이를 `oauth_org_not_allowed` 오류 코드로 표시합니다.

**할 일:**

* 관리자에게 조직에 대해 Claude Code 액세스를 활성화하도록 요청합니다.
* 구독 대신 Console API 키로 인증합니다. 설정은 [Claude Console 인증](/ko/authentication#claude-console-authentication)을 참조하십시오.
* 관리자이고 액세스를 활성화하는 옵션이 보이지 않으면 [Anthropic 지원](https://support.claude.com)에 문의합니다.

### Routines are disabled by your organization's policy

팀 또는 엔터프라이즈 관리자가 조직 수준에서 루틴을 비활성화했습니다. 오류는 `/schedule` 및 claude.ai/code의 [Routines](/ko/routines) UI에서 루틴을 생성하거나 실행하려고 할 때 나타납니다.

```text theme={null}
Routines are disabled by your organization's policy.
```

이는 서버 측 설정이므로 로컬 설정, 환경 변수 또는 CLI 플래그에서 재정의할 수 없습니다.

**할 일:**

* 관리자에게 [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code)에서 **Routines** 토글을 활성화하도록 요청합니다.
* 조직 수준의 루틴이 필요하지 않은 일회성 예약 작업의 경우 [예약된 작업](/ko/scheduled-tasks)을 참조하십시오.

### OAuth token revoked or expired

저장된 로그인이 더 이상 유효하지 않습니다. 취소된 토큰은 어디서나 로그아웃했거나 관리자가 액세스를 제거했음을 의미합니다. 만료된 토큰은 자동 새로 고침이 세션 중에 실패했음을 의미합니다.

```text theme={null}
OAuth token revoked · Please run /login
OAuth token has expired · Please run /login
API Error: 401 ... authentication_error
```

**할 일:**

* `/login`을 실행하여 다시 로그인합니다.
* 동일한 세션 내에서 재인증 후 오류가 반환되면 먼저 `/logout`을 실행하여 저장된 토큰을 완전히 지운 후 `/login`을 실행합니다.
* 시작 간 반복적인 로그인 프롬프트의 경우 [문제 해결](/ko/troubleshoot-install#not-logged-in-or-token-expired)의 시스템 시계 및 macOS Keychain 확인을 참조하십시오.
* `403 Forbidden` 및 OAuth 브라우저 문제를 포함한 기타 오류는 [로그인 및 인증](/ko/troubleshoot-install#login-and-authentication)을 참조하십시오.

### OAuth scope requirement

저장된 토큰은 최신 기능이 필요한 권한 범위보다 앞서 있습니다. 이는 `/usage` 및 상태 줄 사용 표시기에서 가장 자주 표시됩니다.

```text theme={null}
OAuth token does not meet scope requirement: user:profile
```

**할 일:**

* `/login`을 실행하여 현재 범위로 새 토큰을 발급합니다. 먼저 로그아웃할 필요가 없습니다.

## 네트워크 및 연결 오류

이러한 오류는 Claude Code의 네트워크 요청이 목적지에 도달하지 못했음을 의미합니다. 일반적으로 로컬 네트워크, 프록시 또는 방화벽, 또는 클라우드 환경의 네트워크 정책에서 발생합니다.

### Unable to connect to API

API에 대한 TCP 연결이 실패했거나 완료되지 않았습니다.

```text theme={null}
Unable to connect to API. Check your internet connection
Unable to connect to API (ECONNREFUSED)
Unable to connect to API (ECONNRESET)
Unable to connect to API (ETIMEDOUT)
fetch failed
Request timed out. Check your internet connection and proxy settings
```

일반적인 원인으로는 인터넷 액세스 없음, `api.anthropic.com`을 차단하는 VPN, 또는 구성되지 않은 필수 회사 프록시가 있습니다.

**할 일:**

* 동일한 셸에서 `curl -I https://api.anthropic.com`을 실행하여 API 호스트에 도달할 수 있는지 확인합니다. Windows PowerShell에서는 `curl.exe -I https://api.anthropic.com`을 사용하여 기본 제공 `Invoke-WebRequest` 별칭이 사용되지 않도록 합니다.
* 회사 프록시 뒤에 있는 경우 Claude Code를 시작하기 전에 `HTTPS_PROXY`를 설정하고 [네트워크 구성](/ko/network-config)을 참조하십시오.
* LLM 게이트웨이 또는 릴레이를 통해 라우팅하는 경우 [`ANTHROPIC_BASE_URL`](/ko/env-vars)을 해당 주소로 설정합니다. 설정은 [LLM 게이트웨이 구성](/ko/llm-gateway)을 참조하십시오.
* 방화벽이 [네트워크 액세스 요구 사항](/ko/network-config#network-access-requirements)에 나열된 호스트를 허용하는지 확인합니다.
* 간헐적 오류는 [자동으로 재시도](#automatic-retries)됩니다. 지속적인 오류는 로컬 네트워크 문제를 나타냅니다.

`curl`이 성공하지만 Claude Code가 여전히 실패하면 원인은 일반적으로 네트워크 자체가 아닌 런타임과 네트워크 사이의 무언가입니다.

* Linux 및 WSL에서 `/etc/resolv.conf`에서 도달할 수 없는 네임서버를 확인합니다. 특히 WSL은 호스트에서 손상된 리졸버를 상속할 수 있습니다.
* macOS에서 연결이 끊어지거나 제거된 VPN 클라이언트는 터널 인터페이스 또는 라우팅 규칙을 남길 수 있습니다. `ifconfig`에서 오래된 `utun` 인터페이스를 확인하고 시스템 설정에서 VPN의 네트워크 확장을 제거합니다.
* Docker Desktop 및 유사한 컨테이너 런타임은 아웃바운드 트래픽을 가로챌 수 있습니다. 이를 종료하고 재시도하여 이를 배제합니다.

### SSL certificate errors

네트워크의 프록시 또는 보안 어플라이언스가 자체 인증서로 TLS 트래픽을 가로채고 있으며 Claude Code가 이를 신뢰하지 않습니다.

```text theme={null}
Unable to connect to API: SSL certificate verification failed. Check your proxy or corporate SSL certificates
Unable to connect to API: Self-signed certificate detected
```

**할 일:**

* 조직의 CA 번들을 내보내고 `NODE_EXTRA_CA_CERTS=/path/to/ca-bundle.pem`으로 Claude Code를 가리킵니다.
* 전체 설정 지침은 [네트워크 구성](/ko/network-config#custom-ca-certificates)을 참조하십시오.
* 인증서 검증을 완전히 비활성화하는 `NODE_TLS_REJECT_UNAUTHORIZED=0`을 설정하지 마십시오.

### Host not allowed in a cloud session

클라우드 세션 또는 루틴의 아웃바운드 HTTP 요청이 환경의 네트워크 정책에 의해 차단되었습니다.

```text theme={null}
HTTP 403
x-deny-reason: host_not_allowed
```

대상의 실제 인증서와 일치하지 않는 TLS 인증서도 표시될 수 있습니다. 클라우드 환경은 아웃바운드 트래픽을 네트워크 정책을 적용하는 프록시를 통해 라우팅하므로 인증서 불일치는 대상이 아닌 프록시가 연결을 종료했음을 의미합니다.

이것은 클라이언트 측 네트워크 문제가 아닙니다. 클라우드 세션 및 [루틴](/ko/routines)은 아웃바운드 트래픽이 환경의 허용 목록으로 필터링되는 샌드박스 환경 내에서 실행됩니다. **기본** 환경은 **신뢰할 수 있는** 액세스를 사용하며, 이는 패키지 레지스트리, 클라우드 공급자 API, 컨테이너 레지스트리 및 일반적인 개발 도메인의 [기본 허용 목록](/ko/claude-code-on-the-web#default-allowed-domains)을 허용하지만 다른 모든 것은 차단합니다.

**할 일:**

* 루틴을 편집하기 위해 열거나 클라우드 세션을 시작합니다. **기본**과 같은 환경 이름을 표시하는 클라우드 아이콘을 선택하여 선택기를 엽니다. 환경 위에 마우스를 올리고 설정 아이콘을 클릭합니다.
* **클라우드 환경 업데이트** 대화 상자에서 **네트워크 액세스**를 **신뢰할 수 있는**에서 **사용자 정의**로 변경한 다음 차단된 도메인을 **허용된 도메인**에 추가합니다. 한 줄에 하나의 도메인을 입력합니다. **일반적인 패키지 관리자의 기본 목록도 포함**을 확인하여 사용자 정의 도메인과 함께 [기본 허용 목록](/ko/claude-code-on-the-web#default-allowed-domains)을 유지합니다. 제한 없는 액세스를 원하면 대신 **전체**를 선택합니다.
* **변경 사항 저장**을 클릭합니다. 다음 실행은 업데이트된 허용 목록을 사용합니다.

액세스 수준 및 기본 허용 목록은 [네트워크 액세스](/ko/claude-code-on-the-web#network-access)를 참조하십시오. 로컬 CLI 세션은 이 정책의 영향을 받지 않습니다.

## 요청 오류

이러한 오류는 API가 요청을 수신했지만 내용을 거부했음을 의미합니다.

### Prompt is too long

대화 및 첨부 파일이 모델의 컨텍스트 윈도우를 초과합니다.

```text theme={null}
Prompt is too long
```

**할 일:**

* `/compact`를 실행하여 이전 턴을 요약하고 공간을 확보하거나 `/clear`를 실행하여 새로 시작합니다.
* `/context`를 실행하여 윈도우를 소비하는 것의 분석을 확인합니다. 시스템 프롬프트, 도구, 메모리 파일, 메시지입니다.
* `/mcp disable <name>`으로 사용하지 않는 MCP 서버를 비활성화하여 컨텍스트에서 도구 정의를 제거합니다.
* 큰 `CLAUDE.md` 메모리 파일을 자르거나 지침을 [경로 범위 규칙](/ko/memory#path-specific-rules)으로 이동하여 관련이 있을 때만 로드합니다.
* 서브에이전트는 부모 세션에서 모든 MCP 도구 정의를 상속하므로 첫 번째 턴 전에 컨텍스트 윈도우를 채울 수 있습니다. 서브에이전트를 생성하기 전에 사용하지 않는 MCP 서버를 비활성화합니다.
* 자동 압축은 기본적으로 켜져 있으며 일반적으로 이 오류를 방지합니다. [`DISABLE_AUTO_COMPACT`](/ko/env-vars)를 설정한 경우 다시 활성화하거나 윈도우가 가득 차기 전에 `/compact`를 수동으로 실행합니다.

[컨텍스트 윈도우 탐색](/ko/context-window)을 참조하여 컨텍스트가 어떻게 채워지는지 대화형으로 확인합니다.

### Error during compaction: Conversation too long

`/compact` 자체가 실패했습니다. 생성하는 요약을 보유할 충분한 여유 컨텍스트가 없기 때문입니다.

```text theme={null}
Error during compaction: Conversation too long. Press esc twice to go up a few messages and try again.
```

이는 윈도우가 자동 압축이 트리거되는 순간 이미 가득 차 있거나 `Prompt is too long`을 본 후 `/compact`를 실행할 때 발생할 수 있습니다.

**할 일:**

* Esc를 두 번 눌러 메시지 목록을 열고 몇 턴 뒤로 이동합니다. 이는 컨텍스트에서 가장 최근 메시지를 제거합니다. 그런 다음 `/compact`를 다시 실행합니다.
* 뒤로 이동해도 충분한 공간이 확보되지 않으면 `/clear`를 실행하여 새 세션을 시작합니다. 이전 대화는 보존되며 `/resume`으로 다시 열 수 있습니다.

### Request too large

원본 요청 본문이 토큰화 전에 API의 바이트 제한을 초과했습니다. 일반적으로 큰 붙여넣은 파일 또는 첨부 파일 때문입니다.

```text theme={null}
Request too large (max 30 MB). Double press esc to go back and remove or shrink the attached content.
```

이는 [컨텍스트 윈도우 제한](#prompt-is-too-long)과 별개인 HTTP 요청의 크기 제한입니다.

**할 일:**

* Esc를 두 번 눌러 뒤로 이동하고 과도한 크기의 콘텐츠를 추가한 턴을 지나갑니다.
* 콘텐츠를 붙여넣는 대신 경로로 큰 파일을 참조하여 Claude가 청크 단위로 읽을 수 있도록 합니다.
* 이미지의 경우 아래 [Image was too large](#image-was-too-large)를 참조하십시오.

### Image was too large

붙여넣거나 첨부한 이미지가 API의 크기 또는 치수 제한을 초과합니다.

```text theme={null}
Image was too large. Double press esc to go back and try again with a smaller image.
API Error: 400 ... image dimensions exceed max allowed size
```

이미지는 오류 후 대화 기록에 남아 있으므로 제거할 때까지 모든 후속 메시지가 동일한 오류로 실패합니다.

**할 일:**

* Esc를 두 번 눌러 뒤로 이동하고 이미지가 추가된 턴을 지나갑니다.
* 붙여넣기 전에 이미지 크기를 조정합니다. API는 단일 이미지의 경우 가장 긴 가장자리에서 최대 8000픽셀을 허용하거나 많은 이미지가 컨텍스트에 있을 때 2000픽셀을 허용합니다.
* 전체 화면 대신 관련 영역의 더 타이트한 스크린샷을 찍습니다.

### Unable to resize image

Claude Code가 API로 보내기 전에 첨부된 이미지를 축소할 수 없습니다.

```text theme={null}
Unable to resize image — image processing is unavailable and dimensions could not be read from the file header. Please convert the image to PNG, JPEG, GIF, or WebP.
Unable to resize image — dimensions exceed the 2000x2000px limit and image processing failed. Please resize the image to reduce its pixel dimensions.
Unable to resize image (… raw, … base64). The image exceeds the … API limit and compression failed. Please resize the image manually or use a smaller image.
Unable to resize image — could not verify image dimensions are within the 2000x2000px API limit.
```

Claude Code는 일반적으로 큰 이미지를 자동으로 축소합니다. 이러한 오류는 네이티브 이미지 프로세서가 로드되지 않았거나 오류를 반환했으므로 이미지를 API 제한 내에 맞게 축소할 수 없음을 의미합니다.

**할 일:**

* 메시지가 이미지를 변환하도록 요청하면 PNG, JPEG, GIF 또는 WebP로 변환하고 다시 첨부합니다. Claude Code는 이미지 프로세서 없이 이러한 형식의 치수를 확인할 수 있습니다.
* 메시지가 치수 또는 크기 제한을 보고하면 첨부하기 전에 이미지를 해당 제한 아래로 크기 조정하거나 다시 압축합니다.

### PDF errors

첨부한 PDF를 처리할 수 없습니다.

```text theme={null}
PDF too large (max 100 pages, 32 MB). Try splitting it or extracting text first.
PDF is password protected. Try removing protection or extracting text first.
The PDF file was not valid. Try converting to a different format first.
```

**할 일:**

* 과도한 크기의 PDF의 경우 Claude에게 전체 파일을 첨부하는 대신 Read 도구로 페이지 범위를 읽도록 요청하거나 `pdftotext`와 같은 도구로 텍스트를 추출하고 경로로 출력 파일을 참조합니다.
* 보호되거나 유효하지 않은 PDF의 경우 암호를 제거하거나 소스 애플리케이션에서 파일을 다시 내보낸 후 다시 시도합니다.

### Extra inputs are not permitted

Claude Code와 API 사이의 프록시 또는 LLM 게이트웨이가 `anthropic-beta` 요청 헤더를 제거했으므로 API가 이에 따라 달라지는 필드를 거부했습니다.

```text theme={null}
API Error: 400 ... Extra inputs are not permitted ... context_management
API Error: 400 ... Extra inputs are not permitted ... tools.0.custom.input_examples
API Error: 400 ... Unexpected value(s) for the `anthropic-beta` header
```

Claude Code는 `context_management`, `effort`, 도구 `input_examples`와 같은 베타 전용 필드를 이를 활성화하는 `anthropic-beta` 헤더와 함께 보냅니다. 게이트웨이가 본문을 전달하지만 헤더를 제거하면 API는 인식하지 못하는 필드를 봅니다.

**할 일:**

* `anthropic-beta` 헤더를 전달하도록 게이트웨이를 구성합니다. [LLM 게이트웨이 구성](/ko/llm-gateway)을 참조하십시오.
* 대체로 시작하기 전에 [`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](/ko/env-vars)을 설정합니다. 이는 베타 헤더가 필요한 기능을 비활성화하여 헤더를 전달할 수 없는 게이트웨이를 통해 요청이 성공하도록 합니다.

### There's an issue with the selected model

구성된 모델 이름이 인식되지 않았거나 계정이 이에 액세스할 수 없습니다.

```text theme={null}
There's an issue with the selected model (claude-...). It may not exist or you may not have access to it. Run /model to select a different one.
```

**할 일:**

* `/model`을 실행하여 계정에서 사용 가능한 모델 중에서 선택합니다.
* 전체 버전 ID 대신 `sonnet` 또는 `opus`와 같은 별칭을 사용합니다. 별칭은 최신 릴리스를 추적하므로 오래되지 않습니다. [모델 구성](/ko/model-config)을 참조하십시오.
* 잘못된 모델이 계속 돌아오면 오래된 ID가 어딘가에 설정되어 있습니다. [우선순위 순서](/ko/model-config#setting-your-model)로 확인합니다. `--model` 플래그, `ANTHROPIC_MODEL` 환경 변수, 그 다음 `.claude/settings.local.json`의 `model` 필드, 프로젝트의 `.claude/settings.json`, 그리고 `~/.claude/settings.json`입니다. 오래된 값을 제거하면 Claude Code는 계정 기본값으로 폴백합니다.
* Vertex AI 배포의 경우 [Vertex AI 문제 해결](/ko/google-vertex-ai#troubleshooting)을 참조하십시오.

### Claude Opus is not available with the Claude Pro plan

활성 구독 플랜에 선택한 모델이 포함되지 않습니다.

```text theme={null}
Claude Opus is not available with the Claude Pro plan · Select a different model in /model
```

**할 일:**

* `/model`을 실행하고 플랜에 포함된 모델을 선택합니다.
* 최근에 플랜을 업그레이드했는데도 여전히 이를 보면 `/logout`을 실행한 후 `/login`을 실행합니다. 저장된 토큰은 로그인 시 플랜을 반영하므로 웹에서 업그레이드해도 기존 세션에서 적용되지 않을 때까지 적용되지 않습니다.
* 각 플랜에 포함된 모델은 [claude.com/pricing](https://claude.com/pricing)을 참조하십시오.

### thinking.type.enabled is not supported for this model

Claude Code 버전이 Opus 4.7 또는 Opus 4.8의 최소값보다 오래되었습니다. CLI가 모델이 더 이상 허용하지 않는 생각 구성을 보냈습니다.

```text theme={null}
API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use "thinking.type.adaptive" and "output_config.effort" to control thinking behavior.
```

**할 일:**

* `claude update`를 실행하고 Claude Code를 다시 시작합니다. Opus 4.7은 v2.1.111 이상이 필요합니다. Opus 4.8은 v2.1.154 이상이 필요합니다.
* 업그레이드할 수 없으면 `/model`을 실행하고 Opus 4.6 또는 Sonnet을 선택합니다.
* Agent SDK에서 이를 맞으면 [SDK 문제 해결](/ko/agent-sdk/quickstart#troubleshooting)을 참조하십시오.

### Thinking budget exceeds output limit

구성된 확장 생각 예산이 최대 응답 길이를 초과하므로 실제 답변을 위한 공간이 남지 않습니다.

```text theme={null}
API Error: 400 ... max_tokens must be greater than thinking.budget_tokens
```

Claude Code는 Anthropic API에서 이러한 값을 자동으로 조정합니다. 일반적으로 [`MAX_THINKING_TOKENS`](/ko/env-vars)이 제공자의 출력 제한보다 높게 설정되었거나 플랜 모드가 생각 예산을 높일 때 Amazon Bedrock 또는 Google Vertex AI에서 이 오류를 봅니다.

**할 일:**

* `MAX_THINKING_TOKENS`를 낮추거나 [`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/ko/env-vars)를 생각 예산 위로 높입니다.
* [확장 생각](/ko/model-config#extended-thinking)을 참조하여 예산이 출력 길이와 어떻게 상호 작용하는지 확인합니다.

### Tool use or thinking block mismatch

대화 기록이 일관성 없는 상태로 API에 도달했습니다. 일반적으로 도구 호출이 중단되거나 턴이 스트림 중간에 편집된 후입니다.

```text theme={null}
API Error: 400 due to tool use concurrency issues. Run /rewind to recover the conversation.
API Error: 400 ... unexpected `tool_use_id` found in `tool_result` blocks
API Error: 400 ... thinking blocks ... cannot be modified
```

세 가지 변형 모두 동일한 의미입니다. 기록의 `tool_use`, `tool_result`, `thinking` 블록 시퀀스가 더 이상 API가 예상하는 것과 일치하지 않습니다.

**할 일:**

* {/* max-version: 2.1.155 */}Opus 4.7 또는 Opus 4.8을 사용하는 경우 먼저 `claude update`를 실행합니다. v2.1.156 이전 버전은 정상적인 도구 사용 중에 이 오류를 트리거할 수 있으며 `/rewind`는 이를 지우지 않습니다.
* `/rewind`를 실행하거나 Esc를 두 번 눌러 손상된 턴 전의 체크포인트로 뒤로 이동하고 거기서 계속합니다. [체크포인팅](/ko/checkpointing)을 참조하여 체크포인트가 생성되고 복원되는 방식을 확인합니다.

### Usage Policy refusal

API가 대화의 내용이 [사용 정책](https://www.anthropic.com/legal/aup) 확인을 트리거했기 때문에 응답을 거부했습니다. 메시지에는 거부가 잘못되었다고 생각하는 경우 지원팀에 인용할 수 있는 요청 ID가 포함됩니다.

```text theme={null}
API Error: Claude Code is unable to respond to this request, which appears to violate our Usage Policy (https://www.anthropic.com/legal/aup). Please double press esc to edit your last message or start a new session for Claude Code to assist with a different task.
```

확인은 최신 프롬프트뿐만 아니라 전체 대화를 평가하므로 동일한 세션에서 새 메시지를 보내면 일반적으로 동일한 거부를 다시 트리거합니다. `--continue` 또는 `--resume`으로 세션을 종료하고 다시 열 때도 마찬가지입니다. 디스크의 기록에 여전히 트리거 콘텐츠가 포함되어 있기 때문입니다.

**할 일:**

* Esc를 두 번 누르거나 `/rewind`를 실행하여 거부를 트리거한 턴 전의 체크포인트로 뒤로 이동한 후 다시 표현하거나 다른 접근 방식을 시도합니다. [체크포인팅](/ko/checkpointing)을 참조하십시오.
* 어느 턴이 원인인지 식별할 수 없으면 `/clear`를 실행하여 동일한 프로젝트에서 새 대화를 시작합니다. 이전 대화는 디스크에 보존되며 `/resume`에서 사용 가능합니다.
* [비대화형 모드](/ko/headless)(`-p`)에서는 되감기를 사용할 수 없으므로 다시 표현된 프롬프트로 다시 시도하거나 `--continue` 없이 새 세션을 시작합니다.

## 응답 품질이 평소보다 낮아 보임

Claude의 답변이 오류 없이 예상보다 덜 유능해 보이면 원인은 일반적으로 모델 자체가 아닌 대화 상태입니다. Claude Code는 모델 버전을 자동으로 변경하지 않습니다. Opus 할당량에 도달하거나 Bedrock 또는 Vertex AI 지역이 모델이 없는 경우와 같은 특정 경우에 대체 모델로 전환할 수 있습니다. 아래의 모델 선택 확인이 둘 다 포착하고 [모델 구성](/ko/model-config)은 대체가 적용되는 시기를 설명합니다.

먼저 다음을 확인합니다.

* **모델 선택**: `/model`을 실행하여 예상한 모델에 있는지 확인합니다. 이전 `/model` 선택 또는 `ANTHROPIC_MODEL` 환경 변수가 의도한 것보다 더 작은 모델에 있을 수 있습니다.
* **노력 수준**: `/effort`를 실행하여 현재 추론 수준을 확인하고 어려운 디버깅 또는 설계 작업을 위해 높입니다. 기본값은 모델에 따라 다르므로 최대값 아래에 있다고 가정하기 전에 확인합니다. [노력 수준 조정](/ko/model-config#adjust-effort-level)을 참조하여 모델별 기본값 및 `ultrathink` 바로가기를 확인합니다.
* **컨텍스트 압력**: `/context`를 실행하여 윈도우가 얼마나 가득 찼는지 확인합니다. 용량에 가까우면 자연스러운 중단점에서 `/compact`를 실행하거나 새로 시작하려면 `/clear`를 실행합니다. [컨텍스트 윈도우 탐색](/ko/context-window)을 참조하여 자동 압축이 이전 턴에 어떻게 영향을 미치는지 확인합니다.
* **오래된 지침**: 크거나 오래된 `CLAUDE.md` 파일 및 MCP 도구 정의는 컨텍스트를 소비하고 응답을 조종할 수 있습니다. `/doctor`는 과도한 크기의 메모리 파일 및 서브에이전트 정의를 플래그합니다. `/context`는 MCP 도구 토큰 사용을 표시합니다.

응답이 잘못되면 수정으로 회신하는 것보다 일반적으로 되감기가 더 잘 작동합니다. Esc를 두 번 누르거나 `/rewind`를 실행하여 나쁜 턴 전으로 뒤로 이동한 후 더 구체적으로 프롬프트를 다시 표현합니다. 스레드 내에서 수정하면 잘못된 시도가 컨텍스트에 남아 있어 나중의 답변을 이에 고정할 수 있습니다. [체크포인팅](/ko/checkpointing)을 참조하십시오.

위의 확인 후에도 품질이 여전히 이상해 보이면 `/feedback`을 실행하고 예상한 것과 얻은 것을 설명합니다. 이 방식으로 제출된 피드백에는 대화 기록이 포함되어 있으므로 Anthropic이 실제 회귀를 진단하는 가장 빠른 방법입니다. 제공자에서 `/feedback`을 사용할 수 없는 경우 [오류 보고](#report-an-error)를 참조하십시오.

## 오류 보고

이 페이지는 Claude API의 오류를 다룹니다. Claude Code의 다른 구성 요소의 오류는 관련 가이드를 참조하십시오.

* MCP 서버가 연결 또는 인증에 실패함: [MCP](/ko/mcp)
* 훅 스크립트가 실패했거나 도구를 차단함: [훅 디버그](/ko/hooks#debug-hooks)
* 설치 중 권한 거부 또는 파일 시스템 오류: [설치 및 로그인 문제 해결](/ko/troubleshoot-install)

오류가 여기에 나열되지 않았거나 제안된 수정이 도움이 되지 않으면:

* Claude Code 내에서 `/feedback`을 실행하여 기록 및 설명을 Anthropic에 보냅니다. 명령은 미리 채워진 GitHub 문제를 열 수도 있습니다. Bedrock, Vertex AI, Foundry 및 기타 타사 제공자에서 `/feedback`은 Anthropic 계정 담당자에게 보낼 수 있는 로컬 아카이브를 저장합니다.
* `/doctor`를 실행하여 로컬 구성 문제를 확인합니다.
* [status.claude.com](https://status.claude.com)에서 활성 인시던트를 확인합니다.
* GitHub의 [기존 문제](https://github.com/anthropics/claude-code/issues)를 검색합니다.
