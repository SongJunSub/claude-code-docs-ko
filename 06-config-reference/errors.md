> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 오류 참조

> Claude Code 런타임 오류 메시지를 조회하고 각 오류의 의미와 해결 방법을 확인합니다.

이 페이지에는 Claude Code가 표시하는 런타임 오류와 각 오류에서 복구하는 방법, 그리고 오류 없이 응답이 이상해 보일 때 확인할 사항이 나열되어 있습니다. 설정 중 `command not found` 또는 TLS 오류와 같은 설치 오류는 [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md)을 참조하십시오.

Claude Code 자체가 아닌 실행 프로그램이 출력하는 [래퍼 및 IDE 오류](#wrapper-and-ide-errors)를 제외하면, 이러한 오류와 복구 명령은 CLI, [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md), [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에 모두 적용됩니다. 세 가지 모두 동일한 Claude Code CLI를 래핑하기 때문입니다. 기타 사용 환경별 문제는 해당 사용 환경 페이지의 문제 해결 섹션을 참조하십시오.

> [!NOTE]
>
> Claude Code는 모델 응답을 위해 Claude API를 호출하므로 대부분의 런타임 오류는 기본 API 오류 코드에 매핑됩니다. 이 페이지에서는 Claude Code 내에서 각 오류의 의미와 복구 방법을 다룹니다. 원본 HTTP 상태 코드 정의는 [Claude Platform 오류 참조](https://platform.claude.com/docs/en/api/errors)를 참조하십시오.

## 오류 찾기

아래에서 보이는 메시지와 일치하는 섹션을 찾으세요.

| 메시지 | 섹션 |
| :- | :- |
| `API Error: 500 Internal server error` | [서버 오류](#api-error-500-internal-server-error) |
| `API Error: Repeated 529 Overloaded errors` | [서버 오류](#api-error-repeated-529-overloaded-errors) |
| `Opus is experiencing high load` / `Fable is experiencing high load` | [서버 오류](#api-error-repeated-529-overloaded-errors) |
| `Request timed out` | [서버 오류](#request-timed-out), 또는 메시지에 인터넷 연결이 언급된 경우 [네트워크](#unable-to-connect-to-api) |
| `API Error: No response from API` | [서버 오류](#no-response-from-api) |
| `API Error: Stream idle timeout - no chunks received` | [스트리밍 유휴 감시](https://code.claude.com/docs/ko/network-config.md#streaming-idle-watchdogs), 또는 Claude apps gateway를 사용하는 경우 [긴 사고가 프록시 타임아웃으로 끝남](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#long-thinking-ends-in-proxy-timeouts) |
| `Server error mid-response. The response above may be incomplete.` | [서버 오류](#the-response-above-may-be-incomplete) |
| `Connection lost mid-response` / `Your computer went to sleep mid-response` / `The response stopped arriving` | [서버 오류](#the-response-above-may-be-incomplete) |
| `Connection closed mid-response` / `Response stalled mid-stream` | [서버 오류](#the-response-above-may-be-incomplete) |
| `Part of the response never arrived` / `The response stream was malformed` | [서버 오류](#the-response-above-may-be-incomplete) |
| `API Error: Content block not found` / `API Error: Content block already closed` / `API Error: Stream event unreadable` | [서버 오류](#the-response-above-may-be-incomplete) |
| `Connection lost before a response was produced` / `Your computer went to sleep before a response was produced` / `The response stalled before a response was produced` | [자동 재시도](#automatic-retries) |
| `Connection closed while thinking` / `Response stalled while thinking` | [자동 재시도](#automatic-retries) |
| `Connection lost while your computer was asleep` | [자동 재시도](#automatic-retries) |
| `The model's tool call could not be parsed (retry also failed).` | [자동 재시도](#automatic-retries) |
| `<model> is temporarily unavailable, so auto mode cannot determine the safety of...` | [서버 오류](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `Auto mode could not evaluate this action and is blocking it for safety` | [서버 오류](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `Not run · auto mode's check had no usable answer` | [서버 오류](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `Auto mode classifier transcript exceeded context window` | [서버 오류](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `Agent aborted: auto mode classifier request refused by the safety safeguard` | [서버 오류](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `The server-side auto mode classifier gave no verdict` | [서버 오류](#the-server-returned-no-safety-verdict) |
| `<tool> was not reviewed and did not run: the conversation is too long for auto mode's classifier` | [서버 오류](#was-not-reviewed-and-did-not-run) |
| `Auto mode is unavailable — the server returned no safety verdict for the last 10 responses` | [서버 오류](#the-server-returned-no-safety-verdict) |
| `Agent terminated early due to an API error` | [서버 오류](#agent-terminated-early-due-to-an-api-error) |
| `You've hit your session limit` / `You've hit your weekly limit` / `You've hit your Opus limit` / `You've hit your Sonnet limit` | [사용 한도](#youve-hit-your-session-limit) |
| `Usage credits required for 1M context` | [사용 한도](#usage-credits-required-for-1m-context) |
| `the prompt to confirm went unanswered — nothing was sent` | [사용 한도](#the-prompt-to-confirm-went-unanswered) |
| `Server is temporarily limiting requests` | [사용 한도](#server-is-temporarily-limiting-requests) |
| `Request rejected (429)` | [사용 한도](#request-rejected-429) |
| `Credit balance is too low` | [사용 한도](#credit-balance-is-too-low) |
| `You've hit your monthly spend limit` / `You've hit your individual spend limit` / `You've hit your org's monthly spend limit` / `You've hit your channel's monthly spend limit` / `You've hit your team's shared budget` / `You've hit your individual usage limit` | [사용 한도](#youve-hit-your-monthly-spend-limit) |
| `Could not update your spend limit` | [사용 한도](#could-not-update-your-spend-limit) |
| `spend limit reached` / `spend limit unavailable` | [사용 한도](#spend-limit-reached) |
| `Not logged in · Please run /login` | [인증](#not-logged-in) |
| `Couldn't save your login` | [인증](#couldnt-save-your-login) |
| `Authentication required · Sign in again to continue` | [인증](#not-logged-in) |
| `Could not resolve authentication method` | [인증](#could-not-resolve-authentication-method) |
| `Invalid API key` | [인증](#invalid-api-key) |
| `Your apiKeyHelper script is failing` | [인증](#your-apikeyhelper-script-is-failing) |
| `Invalid auth token · Fix external auth token` | [인증](#invalid-request-header-value) |
| `Invalid ANTHROPIC_CUSTOM_HEADERS · Fix the environment variable` | [인증](#invalid-request-header-value) |
| `Invalid request header from the environment · Fix the environment variable` | [인증](#invalid-request-header-value) |
| `This organization has been disabled` | [인증](#this-organization-has-been-disabled) |
| `Your organization has disabled API key authentication` | [인증](#your-organization-has-disabled-api-key-authentication) |
| `Your organization has disabled Claude subscription access` | [인증](#your-organization-has-disabled-claude-subscription-access) |
| `Routines are disabled by your organization's policy` | [인증](#routines-are-disabled-by-your-organizations-policy) |
| `Remote Control is only available when using Claude via api.anthropic.com` | [인증](#remote-control-requires-the-anthropic-api) |
| `OAuth token refresh failed — run /login to re-authenticate` | [인증](#remote-control-couldnt-refresh-your-login) |
| `JWT refresh failed: no OAuth token — run /login` | [인증](#remote-control-couldnt-refresh-your-login) |
| `Claude.ai login expired` | [인증](#remote-control-couldnt-refresh-your-login) |
| `Claude.ai login was rejected — run /login, then /remote-control` | [인증](#remote-control-couldnt-refresh-your-login) |
| `OAuth token unavailable — run /login to restore Remote Control` | [인증](#remote-control-couldnt-refresh-your-login) |
| `Signed out of Claude — run /login, then /remote-control` | [인증](#remote-control-couldnt-refresh-your-login) |
| `Remote Control could not renew this computer's connection` | [인증](#remote-control-could-not-renew-this-computers-connection) |
| `signed-in claude.ai account or organization changed on this machine` | [인증](#remote-control-stopped-because-the-signed-in-account-changed) |
| `Remote Control stopped — the app running this session is now signed in to a different Claude account` | [인증](#remote-control-stopped-because-the-app-running-the-session-signed-out-or-switched-accounts) |
| `Remote Control stopped — the app running this session is signed out of Claude` | [인증](#remote-control-stopped-because-the-app-running-the-session-signed-out-or-switched-accounts) |
| `Couldn't verify your organization's policy for remote control` | [Remote Control 문제 해결](https://code.claude.com/docs/ko/remote-control.md#couldnt-verify-your-organizations-policy-for-remote-control) |
| `Remote Control is disabled by your organization's policy` | [Remote Control 문제 해결](https://code.claude.com/docs/ko/remote-control.md#remote-control-is-disabled-by-your-organizations-policy) |
| `Remote Control was turned off by your organization's policy` | [Remote Control 문제 해결](https://code.claude.com/docs/ko/remote-control.md#remote-control-was-turned-off-by-your-organizations-policy) |
| `OAuth token revoked` / `OAuth token has expired` | [인증](#oauth-token-revoked-or-expired) |
| `Failed to authenticate: OAuth token revoked` | [인증](#oauth-token-revoked-or-expired) |
| `Your account does not have access to Claude. Please login again or contact your administrator.` | [인증](#oauth-token-revoked-or-expired) |
| `API Error: 401 Invalid authentication credentials` | [인증](#api-error-401-invalid-authentication-credentials) |
| `Login expired · Please run /login` | [인증](#login-expired) |
| `The browser can't return the sign-in to Claude Code automatically` | [인증](#couldnt-start-the-local-sign-in-listener) |
| `Couldn't start the local listener that receives the browser sign-in. Try again.` | [인증](#couldnt-start-the-local-sign-in-listener) |
| `Failed to start OAuth callback server` | [인증](#failed-to-start-oauth-callback-server) |
| `Claude login not accepted · Run /login, then try again` | [인증](#claude-login-not-accepted) |
| `Artifacts need a claude.ai login` | [인증](#artifacts-need-a-claude-ai-login) |
| `Not signed in to the Cloud gateway — run /login.` | [인증](#administrator-policy-requires-a-cloud-gateway-sign-in) |
| `Administrator policy requires a Cloud gateway sign-in on this machine` | [인증](#administrator-policy-requires-a-cloud-gateway-sign-in) |
| `Failed to authenticate: OAuth session expired and could not be refreshed` | [인증](#login-expired) |
| `Could not refresh your login because another Claude Code process is refreshing it` | [인증](#could-not-refresh-your-login) |
| `Failed to refresh OAuth token: another Claude Code process is refreshing it or exited mid-refresh` | [인증](#could-not-refresh-your-login) |
| `Your account is on hold and can't use Claude Code. View details or appeal: https://claude.ai/restricted` | [인증](#your-account-is-on-hold) |
| `Your account is on hold and can't sign in to Claude Code. View details or appeal: https://claude.ai/restricted` | [인증](#your-account-is-on-hold) |
| `Anthropic profile login expired · Re-authenticate your Anthropic profile` | [인증](#anthropic-profile-login-expired) |
| `Login expired · Run /login to sign in again, or re-authenticate your Anthropic profile` | [인증](#anthropic-profile-login-expired) |
| `Anthropic profile login expired · Run /login to use your claude.ai account instead, or re-authenticate the profile` | [인증](#anthropic-profile-login-expired) |
| `does not meet scope requirement user:profile` | [인증](#oauth-scope-requirement) |
| `claude.ai rejected the session token` / `session token rejected` | [인증](#claude-ai-rejected-the-session-token) |
| `MCP server "<name>" needs you to sign in again (run /mcp to re-authenticate)` | [인증](#mcp-server-needs-you-to-sign-in-again) |
| `rejected the credential from its headersHelper` / `rejected the Authorization header in its config` | [인증](#mcp-server-needs-you-to-sign-in-again) |
| `(check the helper, then start a new task or chat)` / `(update it, then start a new task or chat)` | [인증](#mcp-credential-rejected-in-cowork) |
| `MCP server "<name>" needs additional permissions (scope: "<scope>") — run /mcp to re-authenticate` | [인증](#mcp-server-needs-you-to-sign-in-again) |
| `MCP server "<name>" requires re-authorization (token expired)` | [인증](#mcp-server-needs-you-to-sign-in-again) |
| `Couldn't read the stored credentials for MCP server "<name>", so the request didn't run` | [인증](#couldnt-read-the-stored-credentials-for-mcp-server) |
| `A request to MCP server "<name>" was sent without your stored credentials` | [인증](#couldnt-read-the-stored-credentials-for-mcp-server) |
| `This server's URL is missing or not a valid URL, so sign-in can't start` | [인증](#mcp-server-url-is-missing-or-not-a-valid-url) |
| `Issuer mismatch in authorization response (RFC 9207)` | [인증](#issuer-mismatch-in-authorization-response) |
| `Refusing to send credentials to non-https token endpoint` / `<short-name> from the MCP SDK for <server-url>` | [인증](#refusing-to-send-credentials-to-non-https-token-endpoint) |
| `Cloud gateway session expired — run /login to reconnect.` | [인증](#cloud-gateway-session-expired) |
| `Cloud gateway <url> no longer accepts this session` | [인증](#cloud-gateway-session-expired) |
| `Sign-in timed out while waiting for you to continue. Try again.` | [인증](#sign-in-timed-out-while-waiting-for-you-to-continue) |
| `AWS credentials expired or invalid` | [인증](#aws-credentials-expired-or-invalid) |
| `AWS authentication failed` | [인증](#aws-authentication-failed) |
| `Google Cloud credentials expired or invalid` | [인증](#google-cloud-credentials-expired-or-invalid) |
| `Google Cloud authentication failed` | [인증](#google-cloud-authentication-failed) |
| `Microsoft Foundry authentication failed` | [인증](#microsoft-foundry-authentication-failed) |
| `Gateway refused the request` | [인증](#gateway-refused-the-request) |
| `Could not load AWS credentials` / `Could not load Google Cloud credentials` | [인증](#could-not-load-aws-or-google-cloud-credentials) |
| `AWS default-chain credential resolve timed out` | [인증](#aws-default-chain-credential-resolve-timed-out) |
| `Timed out after 60s waiting for AWS` | [인증](#bedrock-setup-verification-timed-out-waiting-for-aws) |
| `A request to AWS timed out. Check your network and proxy settings, then try again.` | [인증](#bedrock-setup-verification-timed-out-waiting-for-aws) |
| `Could not load the default credentials` on Google Cloud's Agent Platform | [인증](#could-not-load-aws-or-google-cloud-credentials) |
| `Unable to connect to API` | [네트워크](#unable-to-connect-to-api) |
| `Connection refused —` / `Can't reach the API server —` / `No internet route —` / `Couldn't connect through your proxy` / `Connection dropped`, 각각 괄호 안의 오류 코드로 끝남 | [네트워크](#unable-to-connect-to-api) |
| `Unable to connect to Anthropic services` during setup | [네트워크](#unable-to-connect-to-anthropic-services) |
| `Socket is closed` | [네트워크](#socket-is-closed) |
| `Waiting for API response · will retry in` | [자동 재시도](#automatic-retries), 또는 지속되는 경우 [네트워크](#unable-to-connect-to-api) |
| `API returned an empty or malformed response` | [네트워크](#api-returned-an-empty-or-malformed-response) |
| `Streaming response ended before any complete data was received` | [네트워크](#streaming-response-ended-before-any-complete-data-was-received) |
| `Bedrock streaming response has content-type "..."; expected "application/vnd.amazon.eventstream"` | [네트워크](#bedrock-streaming-response-has-an-unexpected-content-type) |
| `SSL certificate verification failed` | [네트워크](#ssl-certificate-errors) |
| `SSL certificate error (...)` during login or startup | [네트워크](#ssl-certificate-errors) |
| `unable to get local issuer certificate` | [네트워크](#ssl-certificate-errors) |
| 클라우드 세션 또는 클라우드 예약 작업에서 `x-deny-reason: host_not_allowed`와 함께 표시되는 `403` | [네트워크](#host-not-allowed-in-a-cloud-session) |
| `proxy refused the connection` | [네트워크](#the-proxy-refused-the-connection) |
| `403` with `GitHub GraphQL is not available from Claude Code sessions` in a cloud session | [GitHub proxy](https://code.claude.com/docs/ko/cloud-environments.md#github-proxy) |
| `The cloud environments service returned an empty response` / `The cloud environments service returned a response in an unexpected format` | [네트워크](#the-cloud-environments-service-returned-an-empty-or-unexpected-response) |
| `Failed to fetch session from Sessions API: Failed to fetch session logs` | [네트워크](#failed-to-fetch-session-from-sessions-api) |
| `Couldn't reconnect to your Remote Control session` | [네트워크](#couldnt-reconnect-to-your-remote-control-session) |
| `N sessions ended while this machine was offline — the environment was cleaned up on the server and can't be resumed.` | [네트워크](#sessions-ended-while-this-machine-was-offline) |
| `Couldn't share the transcript.` | [네트워크](#couldnt-share-the-transcript) |
| `Couldn't send feedback` | [네트워크](#couldnt-send-feedback) |
| `Feedback payload too large. Try again without the transcript, or shorten the details.` | [네트워크](#feedback-payload-too-large) |
| `MCP server "<name>" connection timed out. Your computer went to sleep or its clock changed while connecting.` | [네트워크](#mcp-server-connection-timed-out-during-a-sleep-or-clock-change) |
| `Prompt is too long` / `Input is too long for requested model` | [요청 오류](#prompt-is-too-long) |
| `Prompt is too long · automatic compaction failed:` | [요청 오류](#prompt-is-too-long) |
| `Prompt is too long · this conversation is a single exchange` / `A single-exchange conversation cannot be compacted` | [요청 오류](#prompt-is-too-long) |
| `Context limit reached · /compact or /clear to continue` | [요청 오류](#prompt-is-too-long) |
| `Context limit reached · /clear to continue` | [요청 오류](#prompt-is-too-long) |
| `capability_rejected: prompt_too_long` on a Claude apps gateway session | [요청 오류](#prompt-is-too-long) |
| `upstream rejected the request` / `request too large for this upstream` on a Claude apps gateway session | [업스트림 오류 메시지](https://code.claude.com/docs/ko/claude-apps-gateway-config.md#upstream-error-messages) |
| `upstream rate limit exceeded` on a Claude apps gateway session | [업스트림 오류 메시지](https://code.claude.com/docs/ko/claude-apps-gateway-config.md#upstream-error-messages) |
| `all upstreams failed (N attempted)` on a Claude apps gateway session | [업스트림 오류 메시지](https://code.claude.com/docs/ko/claude-apps-gateway-config.md#upstream-error-messages) |
| `Claude Code may not be enabled for your organization` after a Claude apps gateway sign-in | [Claude apps gateway 문제 해결](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#troubleshooting) |
| `Context exceeds the ...-token limit by ... tokens` in `/context` output | [요청 오류](#context-exceeds-the-token-limit) |
| `Request too large` | [요청 오류](#request-too-large) |
| `Request too large for the API's 32MB request limit` | [요청 오류](#request-too-large) |
| `Image was too large` | [요청 오류](#image-was-too-large) |
| `API Error: an image in the conversation could not be processed and was removed` | [요청 오류](#image-was-too-large) |
| `Unable to resize image` | [요청 오류](#unable-to-resize-image) |
| `Request rejected as unprocessable by the model` | [요청 오류](#request-rejected-as-unprocessable-by-the-model) |
| `PDF too large` / `PDF is password protected` / `pdftoppm is not installed` | [요청 오류](#pdf-errors) |
| `Extra inputs are not permitted` | [요청 오류](#extra-inputs-are-not-permitted) |
| `API Error: 400 ... tools.N.custom.input_schema: JSON schema is invalid` / `Property keys should match pattern` | [요청 오류](#tool-input-schema-is-invalid) |
| `Tool "mcp__<server>__<tool>" is not sent to Claude: its name has <N> characters and the API accepts at most 128` | [요청 오류](#mcp-tool-name-over-128-characters) |
| `tools.N.custom.name: String should have at most 128 characters` | [요청 오류](#mcp-tool-name-over-128-characters) |
| `tool_use.name: String should have at most 200 characters` | [요청 오류](#tool-use-name-over-200-characters) |
| `There's an issue with the selected model` | [요청 오류](#theres-an-issue-with-the-selected-model) |
| `Model ... is not a recognized model id` | [요청 오류](#model-is-not-a-recognized-model-id) |
| `Model ... not found` | [요청 오류](#model-not-found) |
| `Couldn't confirm model ... with the API` | [요청 오류](#couldnt-confirm-model-with-the-api) |
| `API error: ... · model not changed` | [요청 오류](#api-error-model-not-changed) |
| `Claude Opus is not available with the Claude Pro plan` | [요청 오류](#claude-opus-is-not-available-with-the-claude-pro-plan) |
| `Claude Code ... does not support this model; version ... or newer is required` | [요청 오류](#claude-code-does-not-support-this-model) |
| `Claude Code ... is older than the minimum version required by your organization's policy` | [요청 오류](#claude-code-does-not-support-this-model) |
| `Model ... is restricted by your organization's settings` | [요청 오류](#model-is-restricted-by-your-organizations-settings) |
| `Model ... is not available. Your organization restricts model selection.` | [요청 오류](#model-is-restricted-by-your-organizations-settings) |
| `Can't switch to the default model` | [요청 오류](#cant-switch-to-the-default-model) |
| `Model switch ... blocked by a PreModelSwitch hook` | [요청 오류](#model-switch-was-blocked-by-a-premodelswitch-hook) |
| `couldn't save it as your default` / `couldn't confirm it was saved as your default` | [요청 오류](#couldnt-save-it-as-your-default) |
| `is less capable than the current main model` / `Advisor will not activate on the main model` / `cannot advise` | [요청 오류](#advisor-is-less-capable-than-the-current-main-model) |
| `thinking.type.enabled is not supported for this model` | [요청 오류](#thinking-type-enabled-is-not-supported-for-this-model) |
| `Effort '<level>' isn't available with thinking turned off on this model` | [요청 오류](#effort-isnt-available-with-thinking-turned-off) |
| `effort '<level>' is not supported when thinking is disabled` | [요청 오류](#effort-isnt-available-with-thinking-turned-off) |
| `max_tokens must be greater than thinking.budget_tokens` | [요청 오류](#thinking-budget-exceeds-output-limit) |
| `Claude's response exceeded the ... output token maximum` | [요청 오류](#response-exceeded-the-output-token-maximum) |
| `API Error: 400 due to tool use concurrency issues` | [요청 오류](#tool-use-or-thinking-block-mismatch) |
| `API Error: 400 orphaned tool_result in conversation history` | [요청 오류](#tool-use-or-thinking-block-mismatch) |
| `API Error: 400 duplicate tool_use ID in conversation history` | [요청 오류](#tool-use-or-thinking-block-mismatch) |
| `Invalid data in redacted_thinking block` | [요청 오류](#invalid-data-in-redacted-thinking-block) |
| `[Unsupported tool content removed]` | [요청 오류](#unsupported-tool-content-removed) |
| `role 'system' must precede an 'assistant' message` | [요청 오류](#role-system-must-precede-an-assistant-message) |
| `Invalid encrypted_content in search_result block` / `Invalid encrypted_index in text block` / `Failed to decrypt web search result content` | [요청 오류](#invalid-encrypted-content-in-search-result-block) |
| `Invalid encrypted_stdout in encrypted_code_execution_result block` | [요청 오류](#invalid-encrypted-content-in-search-result-block) |
| `server_tool_use.name: Input should be` on every turn of a resumed session | [요청 오류](#unsupported-tool-content-removed) |
| `<model> can't help with this. Start a new session to continue` | [요청 오류](#usage-policy-refusal) |
| `Claude Code is unable to respond to this request, which appears to violate our Usage Policy` | [요청 오류](#usage-policy-refusal) |
| `<model>'s safeguards flagged this message` | [요청 오류](#safety-measures-flagged-a-cybersecurity-topic) |
| `<model>'s safeguards flagged this session` | [요청 오류](#safety-measures-flagged-a-cybersecurity-topic) |
| `<model> has safety measures that flagged this message for a cybersecurity topic` | [요청 오류](#safety-measures-flagged-a-cybersecurity-topic) |
| `` Details: `[reasoning_extraction]` `` | [요청 오류](#safeguards-flagged-a-request-for-claudes-reasoning) |
| `API Error: Output blocked by content filtering policy` | [요청 오류](#output-blocked-by-content-filtering-policy) |
| `Installation was killed before it could finish (exit code 137)` | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#installation-was-killed-before-it-could-finish) |
| `The connection dropped while downloading the update` | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#the-connection-dropped-while-downloading-the-update) |
| `Download timed out: exceeded the total deadline` | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#the-connection-dropped-while-downloading-the-update) |
| `Release verification failed for Claude Code <version> (<reason>). The update was not installed.` | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#release-verification-failed) |
| `Auto-update failed · Run claude doctor` | [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#auto-update-failed) |
| `--bg and --print conflict` | [명령줄 오류](#conflict-between-bg-and-print) |
| `Couldn't tell whether --bg is a flag or text here, so nothing was started` | [명령줄 오류](#couldnt-tell-whether-bg-is-a-flag-or-text) |
| `Error: Cannot use both --append-subagent-system-prompt and --append-subagent-system-prompt-file. Please use only one.` | [명령줄 오류](#conflict-between-a-system-prompt-flag-and-its-file-form) |
| `Cloud sessions cannot be created from a --restricted session` | [명령줄 오류](#cloud-sessions-cannot-be-created-from-a-restricted-session) |
| `Cloud sessions are disabled by your organization's policy` | [명령줄 오류](#cloud-sessions-are-disabled-by-your-organizations-policy) |
| `Cloud sessions use your claude.ai login`, 자격 증명을 명시하는 정책 거부 메시지의 끝에 표시됨 | [명령줄 오류](#cloud-sessions-use-your-claude-ai-login) |
| `Couldn't verify your organization's policy for cloud sessions` | [명령줄 오류](#couldnt-verify-your-organizations-policy-for-cloud-sessions) |
| `Cloud sessions aren't available:` 뒤에 조직 정책을 불러올 수 없는 이유가 표시됨 | [명령줄 오류](#couldnt-verify-your-organizations-policy-for-cloud-sessions) |
| `Cloud sessions aren't available with this Console sign-in. They need a claude.ai sign-in.` | [조직 UUID를 가져올 수 없음](https://code.claude.com/docs/ko/claude-code-on-the-web.md#unable-to-get-organization-uuid) |
| `Cloud sessions need a claude.ai sign-in` | [조직 UUID를 가져올 수 없음](https://code.claude.com/docs/ko/claude-code-on-the-web.md#unable-to-get-organization-uuid) |
| `Nothing was stashed: "<path>" is now a folder in place of a tracked file or link` / `are now folders in place of tracked files or links` | [명령줄 오류](#nothing-was-stashed-because-a-folder-replaced-a-tracked-file) |
| `Error: --json-schema is not a valid JSON Schema` | [명령줄 오류](#the-json-schema-value-is-not-a-valid-json-schema) |
| `Error: Invalid --agents configuration:` | [명령줄 오류](#invalid-agents-configuration) |
| `Error: --agents takes a JSON object, or a file path only with --print (-p)` | [명령줄 오류](#invalid-agents-configuration) |
| `Error: --agents file not found` | [명령줄 오류](#invalid-agents-configuration) |
| `Error: Settings file exceeds the 2MiB limit` | [명령줄 오류](#settings-file-exceeds-the-2mib-limit) |
| `The current directory no longer exists (it was deleted or moved)` / `Can't read the current directory` | [명령줄 오류](#the-current-directory-no-longer-exists) |
| `Temp directory <dir> ... Refusing to use it` / `Claude Code's temporary directory <dir> could not be created` | [명령줄 오류](#temp-directory-refused-or-cannot-be-created) |
| `ENOSPC: no space left on device, mkdir '<dir>'` | [명령줄 오류](#temp-directory-refused-or-cannot-be-created) |
| `couldn't be resolved to a real location, so its skills, commands, and agents weren't loaded` | [명령줄 오류](#directory-couldnt-be-resolved-to-a-real-location) |
| `Error: Workspace not trusted` when starting Remote Control | [명령줄 오류](#workspace-not-trusted-when-starting-remote-control) |
| `claude ultrareview` 실행 시 표시되는 `Error: Workspace not trusted` | [명령줄 오류](#workspace-not-trusted-when-running-claude-ultrareview) |
| `Ultrareview did not start` | [명령줄 오류](#ultrareview-did-not-start) |
| `` `<flag>` before `remote-control` is not carried over to the sessions Remote Control starts `` | [명령줄 오류](#not-carried-over-to-the-sessions-remote-control-starts) |
| `--sandbox is not supported by claude remote-control` / `--no-sandbox is not supported by claude remote-control` | [명령줄 오류](#sandbox-is-not-supported-by-claude-remote-control) |
| `` `claude import` is not yet available in this build `` | [명령줄 오류](#claude-import-is-not-yet-available-in-this-build) |
| `Could not read Claude Code config` | [명령줄 오류](#could-not-read-claude-code-config) |
| `Could not import <server>: <reason>` | [명령줄 오류](#could-not-import-a-server-from-claude-desktop) |
| `Cannot add MCP server to scope: managed` | [명령줄 오류](#cannot-add-mcp-server-to-the-managed-scope) |
| `Cannot add MCP server: your organization's managed settings allow only MCP servers that plugins provide` | [명령줄 오류](#cannot-add-mcp-server-when-managed-settings-allow-only-plugin-servers) |
| `is Anthropic-hosted and doesn't support local OAuth` | [명령줄 오류](#anthropic-hosted-and-doesnt-support-local-oauth) |
| `Can't read .mcp.json: it isn't a regular file or is larger than 2097152 bytes` | [명령줄 오류](#cant-read-mcp-json) |
| `MCP server "<name>" was not saved to` / `was not removed from` | [명령줄 오류](#mcp-server-was-not-saved-or-removed) |
| `MCP server "<name>" may not have been saved` / `may not have been removed` | [명령줄 오류](#mcp-server-may-not-have-been-saved-or-removed) |
| `Server rejected the Authorization header minted by the configured headersHelper` | [명령줄 오류](#server-rejected-the-authorization-header-minted-by-the-configured-headershelper) |
| `This server (Java MCP SDK 0.17.0 or older) rejected Claude Code's elicitation capability` | [명령줄 오류](#mcp-server-rejected-the-elicitation-capability) |
| `Error: MCP tool <name> (passed via --permission-prompt-tool) not found` | [명령줄 오류](#mcp-permission-prompt-tool-not-found) |
| `OAuth callback port <port> is already in use — another process may be holding it` | [명령줄 오류](#oauth-callback-port-is-already-in-use) |
| `No available ports for OAuth redirect` | [명령줄 오류](#no-available-ports-for-oauth-redirect) |
| `Shell command failed for pattern "..."`, from `/security-review` or any skill that injects dynamic context | [명령줄 오류](#security-review-fails-without-origin-head) |
| `Shell command permission check failed for pattern "..."`, from a skill that injects dynamic context | [명령줄 오류](#security-review-fails-without-origin-head) |
| ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found`` | [명령줄 오류](#security-review-fails-without-origin-head) |
| `No shell command in <name> was run, because the <tool> tool does not accept one of them` | [명령줄 오류](#no-shell-command-was-run) |
| `Input must be provided either through stdin or as a prompt argument when using --print` | [명령줄 오류](#input-must-be-provided-when-using-print) |
| `Claude Code can't read the keyboard here: stdin is not a terminal` | [명령줄 오류](#claude-code-cant-read-the-keyboard-here) |
| `Error: Input contained only whitespace` | [명령줄 오류](#input-contained-only-whitespace) |
| `Blank prompt — the message was only whitespace, so nothing was sent to the model.` | [명령줄 오류](#input-contained-only-whitespace) |
| `Error: stream-json input carried over 256M characters with no newline` | [명령줄 오류](#stream-json-input-carried-over-256m-characters-with-no-newline) |
| `Unknown command: /<name>`, with or without a `Did you mean` suggestion | [명령줄 오류](#unknown-command) |
| `Diff is too large for ultrareview` / `PR #<N> is too large for ultrareview` | [명령줄 오류](#diff-is-too-large-for-ultrareview) |
| `Could not find merge-base with <branch>` | [명령줄 오류](#could-not-find-merge-base-with-the-base-branch) |
| `Your checkout has no branches (detached HEAD only)` | [명령줄 오류](#your-checkout-has-no-branches) |
| `Ultrareview clones <owner>/<repo> in the cloud with the GitHub account connected to your Claude account, and none is connected` | [명령줄 오류](#no-github-account-is-connected-to-your-claude-account) |
| `Your connected GitHub account can't see <owner>/<repo>` | [명령줄 오류](#your-connected-github-account-cant-see-the-repository) |
| `The GitHub App preflight failed transiently (network or service hiccup) — retry in a moment to start from GitHub instead` | [명령줄 오류](#the-github-app-preflight-failed-transiently) |
| `Not uploading this working tree` with `the upload cannot follow that setting` | [명령줄 오류](#the-repository-upload-cant-follow-a-git-setting) |
| `GitHub isn't connected to your Claude account, so this repository can't be cloned in the cloud` | [명령줄 오류](#github-isnt-connected-to-your-claude-account) |
| `Your GitHub organization has an IP allowlist that is blocking Claude` | [명령줄 오류](#a-github-organization-policy-is-blocking-claude) |
| `Your GitHub organization requires single sign-on` | [명령줄 오류](#a-github-organization-policy-is-blocking-claude) |
| `Your GitHub organization's identity provider (Microsoft Entra ID) has a Conditional Access policy that is blocking Claude` | [명령줄 오류](#a-github-organization-policy-is-blocking-claude) |
| `Single sign-on authorization needed` | [명령줄 오류](#single-sign-on-authorization-needed) |
| `Failed to resume the conversation` | [명령줄 오류](#failed-to-resume-the-conversation) |
| `No conversation found with session ID: <session-id>` | [명령줄 오류](#no-conversation-found-with-the-session-id) |
| `Windows reported an error (EBADF) when Claude Code read this session's transcript file` | [명령줄 오류](#windows-reported-an-error-ebadf) |
| `Cannot switch renderers in this session` | [명령줄 오류](#cannot-switch-renderers-in-this-session) |
| `Cannot switch renderers while work is running in the background` | [명령줄 오류](#cannot-switch-renderers-in-this-session) |
| `Can't restart while work is running in the background — wait for it to finish (or stop it via /tasks), then try again.` | [명령줄 오류](#cant-restart-while-work-is-running-or-remote-control-is-connected) |
| `Can't restart while Remote Control is connected. To use the installed version, exit and start Claude Code again, then run /resume.` | [명령줄 오류](#cant-restart-while-work-is-running-or-remote-control-is-connected) |
| `Claude Code couldn't restart` | [명령줄 오류](#claude-code-couldnt-restart) |
| `Couldn't open Claude Desktop` | [명령줄 오류](#couldnt-open-claude-desktop) |
| `Failed to open Claude Desktop. Please try opening it manually.` | [명령줄 오류](#couldnt-open-claude-desktop) |
| `Couldn't read your Zed keymap` / `Couldn't back up your Zed keymap` / `Couldn't update your Zed keymap` | [명령줄 오류](#terminal-setup-left-your-zed-keymap-unchanged) |
| `Your Zed keymap isn't a readable list of keybindings` | [명령줄 오류](#terminal-setup-left-your-zed-keymap-unchanged) |
| `Skill usage reports are not available on this connection.` | [명령줄 오류](#skill-usage-reports-are-not-available-on-this-connection) |
| `Custom output styles can't be selected over Remote Control or from a relayed message` | [명령줄 오류](#custom-output-styles-cant-be-selected-over-remote-control) |
| `Output styles are saved to local settings (.claude/settings.local.json), which this session doesn't load` | [명령줄 오류](#output-styles-are-saved-to-local-settings-which-this-session-doesnt-load) |
| `/recap only runs when you ask for it yourself in this session` | [명령줄 오류](#recap-only-runs-when-you-ask-for-it-yourself) |
| `/feedback is disabled by your organization's policy`, 또는 `/bug`나 `/share`에 대한 동일한 메시지 | [명령줄 오류](#feedback-is-disabled-by-your-organizations-policy) |
| `` `plugin eval` is currently in early access `` / `` `plugin eval` is currently unavailable `` | [플러그인 오류](#plugin-eval-is-currently-in-early-access) |
| `cannot be evaluated where sessions load it` | [eval로 플러그인 테스트](https://code.claude.com/docs/ko/plugin-evals.md#cannot-be-evaluated-where-sessions-load-it) |
| `Marketplace "<name>" is registered from an untrusted source` | [플러그인 오류](#marketplace-is-registered-from-an-untrusted-source) |
| `Claude Code refuses the marketplace name "<name>"` | [플러그인 오류](#claude-code-refuses-the-marketplace-name) |
| `Marketplace name impersonates an official Anthropic/Claude marketplace` | [플러그인 오류](#claude-code-refuses-the-marketplace-name) |
| `Marketplace "<name>" is already added from a different source` | [플러그인 오류](#marketplace-is-already-added-from-a-different-source) |
| `"<name>" is another spelling of "<reserved>", a reserved marketplace name` | [플러그인 오류](#marketplace-name-is-another-spelling-of-a-reserved-name) |
| `Cannot add marketplace "<name>": Claude Code cannot install plugins from a marketplace with this name` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#cannot-install-plugins-from-a-marketplace-with-this-name) |
| `Cannot add marketplace "<name>": Claude Code reserves this name and cannot register a marketplace under it` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#claude-code-reserves-this-name) |
| `Marketplace "<name>" is added but ignored` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#marketplace-is-added-but-ignored) |
| `Marketplace "<name>" is registered but was refused (see the debug log)` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#marketplace-is-added-but-ignored) |
| `references ${user_config.*} in a shell-form command` | [플러그인 오류](#plugin-command-references-user-config) |
| `Monitor "<name>" from plugin <plugin> references ${user_config.*} in its command` | [플러그인 오류](#plugin-command-references-user-config) |
| `headersHelper for MCP server '<name>' references ${user_config.*}` | [플러그인 오류](#plugin-command-references-user-config) |
| `Plugin archive integrity check failed` | [플러그인 오류](#plugin-archive-integrity-check-failed) |
| `An npm plugin source must name a registry package` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#an-npm-plugin-source-must-name-a-registry-package) |
| `The packages it lists are not installed` / `The packages it lists were not installed, because` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#the-packages-it-lists-are-not-installed) |
| `does not load (...), so Claude Code ignores the whole file` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#does-not-load-so-claude-code-ignores-the-whole-file) |
| `path escapes plugin directory` | [플러그인 오류](#path-escapes-plugin-directory) |
| `Plugin not loaded: its manifest <path> was not read` | [플러그인 오류](#plugin-not-loaded-its-manifest-was-not-read) |
| `path could not be checked` | [플러그인 오류](#path-could-not-be-checked) |
| `its marketplace entry path does not stay inside the marketplace directory` | [플러그인 오류](#marketplace-entry-path-does-not-stay-inside-the-marketplace-directory) |
| `Plugin source path refused` | [플러그인 오류](#marketplace-entry-path-does-not-stay-inside-the-marketplace-directory) |
| `Failed to load marketplace configuration` | [플러그인 오류](#failed-to-load-marketplace-configuration) |
| `Marketplace configuration file is corrupted` | [플러그인 오류](#failed-to-load-marketplace-configuration) |
| `Plugin "<name>@synced" is required by your organization and can't be disabled here` | [플러그인 오류](#plugin-is-required-by-your-organization) |
| `"<plugin>" was not uninstalled: it is still switched on in <file>` | [플러그인 오류](#plugin-was-not-uninstalled) |
| `"<plugin>" was not uninstalled: <file> is there and could not be read` | [플러그인 오류](#plugin-was-not-uninstalled) |
| `Plugin "<plugin>" was not uninstalled: installed_plugins.json` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#installed-plugins-json-holds-a-record-this-version-cannot-read) |
| `Plugin directory does not exist: <path>` | [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md#plugin-directory-does-not-exist) |
| `Skipping connection (recent failure cached; retries automatically in 15 min, or edit the plugin config to retry now)` | [플러그인 오류](#skipping-connection-recent-failure-cached) |
| `Error: No such tool available: <tool name>` | [도구 오류](#no-such-tool-available) |
| `MCP server "<name>" connection closed before the tool call was answered` | [도구 오류](#connection-closed-before-the-tool-call-was-answered) |
| `MCP server "<name>" is disabled — re-enable it via /mcp to use its tools` | [도구 오류](#mcp-server-is-disabled) |
| `MCP server "<name>" tool "<tool>" timed out after <N>s. The server asked the user a question, and no answer came before the time limit.` | [도구 오류](#mcp-tool-call-timed-out-with-the-servers-question-unanswered) |
| `would be spawned with zero tools — refusing` | [도구 오류](#agent-would-be-spawned-with-zero-tools) |
| `File is covered by a Read deny rule in your permission settings` | [도구 오류](#file-is-covered-by-a-read-deny-rule) |
| `cannot contain null bytes (\0)` | [도구 오류](#path-cannot-contain-null-bytes) |
| `Path contains null bytes` | [도구 오류](#path-cannot-contain-null-bytes) |
| `command contains the invisible character U+FEFF (byte order mark) or U+180E (Mongolian vowel separator), and was not run` | [도구 오류](#command-contains-an-invisible-character) |
| `File is too large to read as an image (the limit is 128MB)` | [도구 오류](#file-is-too-large-to-read-as-an-image) |
| `Cannot read this as an image: <path> is a pipe or a device` | [도구 오류](#file-is-too-large-to-read-as-an-image) |
| `subagent_type is required: the general-purpose agent is not available in this session` | [도구 오류](#subagent-type-is-required) |
| `Error: this write left the memory index at MEMORY.md at ..., over its ... read limit` | [도구 오류](#memory-index-is-over-its-read-limit) |
| `Sandbox is required but failed to initialize: <reason>` | [샌드박싱 문제 해결](https://code.claude.com/docs/ko/sandboxing.md#commands-refused-with-sandbox-is-required) |
| `Sandbox is required (sandbox.failIfUnavailable) and stopped being available in this session: <reason>` | [샌드박싱 문제 해결](https://code.claude.com/docs/ko/sandboxing.md#commands-refused-with-sandbox-is-required) |
| `pkill: refusing to run` | [도구 오류](#pkill-pattern-matches-the-claude-code-process) |
| `Failed to write to <name>'s inbox — nothing was sent` | [도구 오류](#failed-to-write-to-a-teammate-inbox) |
| `Failed to write the plan approval request to the lead's inbox — plan not submitted` | [도구 오류](#failed-to-write-to-a-teammate-inbox) |
| `Its agent definition was not restored: the folder its definition file came from is not trusted` | [도구 오류](#teammate-agent-definition-not-restored) |
| `Only a teammate can approve a shutdown request` | [도구 오류](#only-a-teammate-can-approve-a-shutdown-request) |
| `A command-line deny rule cannot be handed to a teammate intact` | [도구 오류](#command-line-deny-rule-cannot-be-handed-to-a-teammate) |
| `Message too large for cross-session delivery` | [도구 오류](#message-too-large-for-cross-session-delivery) |
| `Too many messages to this session just now` | [도구 오류](#too-many-messages-to-this-session-just-now) |
| `Cross-session message was dropped at the recipient session's inbox` | [도구 오류](#cross-session-message-dropped-at-the-inbox) |
| `Refusing to send: reply target is a symlink` / `Refusing to send: cannot vet reply target` | [도구 오류](#refusing-to-send-a-cross-session-message) |
| `Refusing to read <path>: its symlink resolution changed after permission was checked (<reason>)` / `Refusing to search <path>: its symlink resolution changed after permission was checked` | [도구 오류](#refusing-after-a-symlink-changed) |
| `Refusing to write <path>: its parent-directory symlink resolution changed after permission was checked` / `Refusing to write <path>: it is a symbolic link. Write to the link's target path instead` | [도구 오류](#refusing-after-a-symlink-changed) |
| `Refusing to write through symlink: <path>` / `Refusing to write into symlinked directory: <path>` | [도구 오류](#refusing-after-a-symlink-changed) |
| `Refusing to write <path>: where it leads on disk could not be determined` / `Refusing to read <path>: where it leads on disk could not be determined` | [도구 오류](#refusing-after-a-symlink-changed) |
| `Refusing to search <path>: a path one of its Read deny rules is written through changed while the search was being prepared` / `Refusing to search <path>: it could not be opened` | [도구 오류](#refusing-after-a-symlink-changed) |
| `its permission check expired before it ran (too many concurrent file operations)` / `ripgrep was found only by name on PATH` | [도구 오류](#refusing-after-a-symlink-changed) |
| `task output swap refused (tasks dir moved or linked)` | [도구 오류](#task-output-swap-refused) |
| `Command killed: its output file was replaced or could no longer be verified` | [도구 오류](#task-output-swap-refused) |
| `Disk full: this computer's volume holding <dir> (Claude Code's temporary directory) has <n> MB free` / `Nearly out of inodes: this computer's volume holding <dir>` | [도구 오류](#disk-quota-or-temp-filesystem-is-full) |
| `Disk full: a test write beside this command's output file` / `Disk quota used up: a test write beside this command's output file` | [도구 오류](#disk-quota-or-temp-filesystem-is-full) |
| `The command was not started: this computer's disk is full (ENOSPC)` / `the user's disk quota is used up (EDQUOT)` | [도구 오류](#disk-quota-or-temp-filesystem-is-full) |
| `Your disk quota is full on the filesystem with Claude Code's temp directory <dir> (EDQUOT)` / `The filesystem with Claude Code's temp directory <dir>, or your disk quota on it, is full (ENOSPC)` | [도구 오류](#disk-quota-or-temp-filesystem-is-full) |
| `Command output was lost: the temp filesystem at <dir> is full` / `is out of inodes` | [도구 오류](#disk-quota-or-temp-filesystem-is-full) |
| `File is not valid UTF-8. It may use a legacy encoding such as Windows-1252, Shift-JIS or GBK, or be binary` | [도구 오류](#file-is-not-valid-utf-8) |
| `git is not installed on this Mac. To install it, run xcode-select --install, then try again.` | [도구 오류](#git-is-not-installed-on-this-mac) |
| `the source file is not valid UTF-8 text` / `the source file is not valid UTF-16 text` | [도구 오류](#the-source-file-is-not-valid-utf-8-text) |
| `the source file has the replacement character U+FFFD` | [도구 오류](#the-source-file-is-not-valid-utf-8-text) |
| `Not published: that file is on a network share` | [도구 오류](#not-published-that-file-is-on-a-network-share) |
| `Not published: Claude sent the same content again after a newer version of the artifact turned it away` / `Not published: Claude sent its changes again over the same file after a newer version of the artifact turned them away` | [도구 오류](#not-published-a-newer-version-of-the-artifact-turned-it-away) |
| `Reading a local file from outside this session's connected folders, or through a link, needs the approval card` | [도구 오류](#reading-a-local-file-from-outside-the-connected-folders) |
| `cannot read file_path (...) — the file could not be examined, and no one can answer the approval card` | [도구 오류](#reading-a-local-file-from-outside-the-connected-folders) |
| `WebFetch cannot fetch localhost or other hostnames without a dot` | [도구 오류](#webfetch-cannot-fetch-localhost) |
| `The safety check for domain ... is rate-limited` | [도구 오류](#webfetch-domain-safety-check-failed) |
| `The safety check for domain ... is temporarily rate-limited` | [도구 오류](#webfetch-domain-safety-check-failed) |
| `Unable to verify if domain ... is safe to fetch` | [도구 오류](#webfetch-domain-safety-check-failed) |
| `Can't open MCP settings while no terminal is attached to this background session` | [백그라운드 세션 오류](#commands-refused-in-a-background-session) |
| `Can't open MCP settings in a background session` | [백그라운드 세션 오류](#commands-refused-in-a-background-session) |
| `blocked because the path is spelled in a form that cannot be safely resolved` | [백그라운드 세션 오류](#write-or-command-blocked-because-the-path-cannot-be-safely-resolved) |
| `blocked because the path is network-shaped` | [백그라운드 세션 오류](#write-or-command-blocked-because-the-path-names-a-network-location) |
| `is isolated in the worktree <path>, but this command <reason>. Refusing to run it` | [백그라운드 세션 오류](#command-blocked-by-the-worktree-isolation-checks) |
| `too complex to verify that it stays inside the worktree` | [백그라운드 세션 오류](#command-blocked-by-the-worktree-isolation-checks) |
| `This session has no saved transcript` | [백그라운드 세션 오류](#this-session-has-no-saved-transcript) |
| `Can't open — this session is running in another terminal` | [백그라운드 세션 오류](#this-session-is-running-in-another-terminal) |
| `This conversation is already open in another running Claude session` | [백그라운드 세션 오류](#this-session-is-running-in-another-terminal) |
| `This session's saved conversation is no longer on disk` | [백그라운드 세션 오류](#this-sessions-saved-conversation-is-no-longer-on-disk) |
| `Bypass permissions was requested at launch and ignored` | [백그라운드 세션에서 권한 우회가 무시됨](https://code.claude.com/docs/ko/permission-modes.md#bypass-permissions-ignored-in-a-background-session) |
| `kept <id> — its worktree is still at <path>` | 메시지의 다음 줄에 푸시되지 않은 커밋이 언급된 경우 [백그라운드 세션 오류](#worktree-has-commits-that-are-not-pushed-anywhere), 그렇지 않으면 [세션 삭제 시 제거되는 항목](https://code.claude.com/docs/ko/agent-view.md#what-deleting-a-session-removes) |
| `kept <id> — <n> unpushed commits on <branch>` | [백그라운드 세션 오류](#worktree-has-commits-that-are-not-pushed-anywhere) |
| `kept <id> — worktree has commits that are not pushed anywhere` | [백그라운드 세션 오류](#worktree-has-commits-that-are-not-pushed-anywhere) |
| `terminal host process died — press Enter to restart` / `This session's terminal host process died` | [백그라운드 세션 오류](#terminal-host-process-died) |
| `Session isn't responding` / `Press enter again to restart this session — it isn't responding` | [백그라운드 세션 오류](#session-isnt-responding) |
| `Session <id> was stopped while the respawn was in flight` | [백그라운드 세션 오류](#session-was-stopped-while-the-respawn-was-in-flight) |
| `This session was running agent '<name>', which is no longer available` | [백그라운드 세션 오류](#session-agent-no-longer-available) |
| `This session restarted <time> after its next /loop wakeup was due, so that wakeup will not fire` | [백그라운드 세션 오류](#restarted-after-its-next-loop-wakeup-was-due) |
| `No LLM gateway: a gateway set in your shell isn't passed to a session opened from another folder` | [백그라운드 세션 오류](#no-llm-gateway-opened-from-another-folder) |
| `No LLM gateway: opened from another folder · respawn from <folder>` | [백그라운드 세션 오류](#no-llm-gateway-opened-from-another-folder) |
| `CLAUDE_CODE_PROCESS_WRAPPER: launcher ...` | [백그라운드 세션 오류](#claude_code_process_wrapper-launcher-errors) |
| `EUNKNOWN: unknown error, uv_spawn` | [백그라운드 세션 오류](#eunknown-when-starting-a-background-session) |
| `EACCES: permission denied, posix_spawn` | [백그라운드 세션 오류](#eacces-when-starting-a-background-session) |
| `exited before it became reachable` | [백그라운드 세션 오류](#background-service-exited-before-it-became-reachable) |
| `Couldn't start a background session (working directory no longer exists or is not accessible: ...)` | [백그라운드 세션 오류](#working-directory-no-longer-exists-when-starting-a-background-session) |
| `Workspace not trusted.` when starting or restarting a background session | [백그라운드 세션 오류](#workspace-not-trusted-when-dispatching-a-background-session) |
| `Claude Code is being updated by npm on this machine (still not runnable after 2 min, ...)` | [백그라운드 세션 오류](#eacces-when-starting-a-background-session) |
| `Claude Code process exited with code N` | [래퍼 및 IDE 오류](#claude-code-process-exited-with-code-n) |
| `The connection to Claude Code ended before this message completed` | [래퍼 및 IDE 오류](#the-connection-to-claude-code-ended-before-this-message-completed) |
| `Could not locate the Claude CLI on PATH` | [래퍼 및 IDE 오류](#could-not-locate-the-claude-cli-on-path) |
| `The Claude Code program for this computer, the <build> build, could not be found` | [래퍼 및 IDE 오류](#the-claude-code-program-for-this-computer-could-not-be-found) |
| `Restored the code, but skipped N files` | [되돌리기 경고 및 오류](#restored-the-code-but-skipped-files) |
| `No files were restored: N files failed (backup missing, or the file could not be updated)` | [되돌리기 경고 및 오류](#no-files-were-restored) |
| `Transcript writes are failing (...)` | [세션 저장 경고](#transcript-writes-are-failing) |
| `Transcript saving is off — CLAUDE_CODE_SKIP_PROMPT_HISTORY is set` | [세션 저장 경고](#transcript-saving-is-off-skip-prompt-history) |
| `Transcript saving is off — inherited CLAUDE_CODE_CHILD_SESSION marker` | [세션 저장 경고](#transcript-saving-is-off-child-session-marker) |
| `Claude Code's fullscreen renderer didn't finish starting last time on this machine` / `Claude Code's fullscreen renderer has repeatedly failed to start on this machine` | [전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md#fullscreen-renderer-didnt-finish-starting) |
| `Claude Code exited after an unrecoverable interface error (...)` | [구성 경고](#exited-after-an-unrecoverable-interface-error) |
| `Agent descriptions are over the 15.0k-token limit` | [구성 경고](#agent-descriptions-are-over-the-15000-token-limit) |
| `hook needs quotes around a path with a space` | [구성 경고](#hook-needs-quotes-around-a-path-with-a-space) |
| `Instruction file not loaded` | [구성 경고](#instruction-file-not-loaded) |
| `Not loaded: rename <path>, then restart — its name uses "<name>", a name reserved for the skills synced from your claude.ai account` | [구성 경고](#a-skill-command-or-workflow-wasnt-loaded-because-its-name-is-reserved) |
| `N skill or command names refused: run with --debug to see which ([names]), rename, then restart` | [구성 경고](#skill-or-command-name-refused) |
| `Ignoring N permissions.allow entries from ... this workspace has not been trusted` | [구성 경고](#workspace-has-not-been-trusted) |
| `is a network path, which cannot be added as a working directory` | [구성 경고](#working-directory-is-a-network-path) |
| `Remote managed settings failed to load (<cause>)` | [구성 경고](#remote-managed-settings-failed-to-load) |
| `Managed settings were not approved; exiting without applying them.` | [구성 경고](#managed-settings-were-not-approved) |
| `Your organization's managed settings need your approval, which couldn't be asked for here.` | [구성 경고](#managed-settings-need-your-approval) |
| `Claude Code can't start: your organization's managed settings block the default model` / `Claude Code can't start: your organization allows only the models listed in "availableModels"` | [구성 경고](#managed-settings-block-the-default-model) |
| `Your organization's managed settings allow Claude Code to use: <providers>` | [구성 경고](#managed-settings-dont-allow-this-api-provider) |
| `Your organization's managed settings allow Claude Code to use no API provider at all` | [구성 경고](#managed-settings-dont-allow-this-api-provider) |
| `MCP server <name> is blocked by enterprise managed policy` | [구성 경고](#mcp-server-is-blocked-by-enterprise-managed-policy) |
| `"<name>" is a reserved MCP server name and was not loaded` | [구성 경고](#mcp-server-name-is-reserved) |
| `Managed settings document could not be parsed as a JSON object; none of its settings are in effect. Fix or remove it.` | [구성 경고](#managed-settings-document-could-not-be-parsed) |
| `Managed settings drop-in directory could not be read` | [구성 경고](#managed-settings-document-could-not-be-parsed) |
| `Unable to read managed policy settings` | [구성 경고](#unable-to-read-managed-policy-settings) |
| `Managed settings contain invalid entries, including PreToolUse/PermissionRequest hooks that are NOT loaded; fix or remove each entry:` | [구성 경고](#managed-settings-hooks-not-loaded) |
| `otelHeadersHelper failed; telemetry is not being exported. See /status: ...` | [구성 경고](#otelheadershelper-failed) |
| `"crossSessionInbound" must be one of "accept", "hold", "refuse"` | [구성 경고](#crosssessioninbound-must-be-one-of-accept-hold-refuse) |
| `API Error: ANTHROPIC_FOUNDRY_RESOURCE must be a Foundry resource name` | [구성 경고](#anthropic-foundry-resource-must-be-a-foundry-resource-name) |
| `headersHelper not run — this workspace has no persisted trust` | [구성 경고](#headershelper-not-run) |
| `Invalid permission rule "..." was skipped: Malformed Tool(content) rule` | [구성 경고](#malformed-tool-content-rule) |
| `matches no tool · check for typos` / `matches no known tool — check for typos` | [구성 경고](#matches-no-tool) |
| `... is not matched by file permission checks` | [구성 경고](#is-not-matched-by-file-permission-checks) |
| `Write(<path>) never matches · use Edit(<path>)` / `Glob(<path>) never matches · use Read(<path>)` | [구성 경고](#is-not-matched-by-file-permission-checks) |
| `... has a wildcard before the rest of the command` | [구성 경고](#has-a-wildcard-before-the-rest-of-the-command) |
| `allows any option at its * · use an exact value` | [구성 경고](#has-a-wildcard-before-the-rest-of-the-command) |
| `Denying Bash also turns off the PowerShell tool, so Claude has neither` | [구성 경고](#denying-bash-also-turns-off-the-powershell-tool) |
| `CLAUDE_CODE_DISABLE_1M_CONTEXT is set, but the 200K limit isn't enforced` | [구성 경고](#the-200k-limit-isnt-enforced) |
| `CLAUDE_CODE_AUTO_COMPACT_WINDOW="<value>" reads as <N> tokens, so Claude Code treats it as the 100k minimum` | [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`의 값 및 경고](https://code.claude.com/docs/ko/model-config#claude_code_auto_compact_window-values) |
| `CLAUDE_CODE_AUTO_COMPACT_WINDOW="<value>" is too large, so Claude Code treats it as the 1M maximum` | [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`의 값 및 경고](https://code.claude.com/docs/ko/model-config#claude_code_auto_compact_window-values) |
| `CLAUDE_CODE_AUTO_COMPACT_WINDOW="<value>" isn't a usable size, so Claude Code ignores it` | [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`의 값 및 경고](https://code.claude.com/docs/ko/model-config#claude_code_auto_compact_window-values) |
| `Model "<model>" isn't recognized · context assumed to be 200k tokens` | [게이트웨이 또는 사용자 지정 모델 ID의 윈도우 수정](https://code.claude.com/docs/ko/model-config.md#correct-the-window-for-a-gateway-or-custom-model-id) |
| `Claude Code doesn't recognize the model "<model>", so it assumes a context window of 200k tokens` | [게이트웨이 또는 사용자 지정 모델 ID의 윈도우 수정](https://code.claude.com/docs/ko/model-config.md#correct-the-window-for-a-gateway-or-custom-model-id) |
| `[claude-code:unrecognized_model]` | [구성 경고](#unrecognized-model-id-on-a-request) |
| `is ignored — managed settings set allowManagedReadPathsOnly` / `is ignored — managed settings set allowManagedDomainsOnly` | [구성 경고](#sandbox-allow-entries-are-ignored-under-a-managed-lock) |
| `Sandbox mask files left behind at write-deny paths` | [구성 경고](#stale-sandbox-mask-files-left-by-a-killed-session) |
| `Stale sandbox mask files left by a killed session` | [구성 경고](#stale-sandbox-mask-files-left-by-a-killed-session) |
| 응답 품질이 평소보다 낮아 보임 | [응답 품질](#responses-seem-lower-quality-than-usual) |

## 자동 재시도

Claude Code는 일시적인 실패가 발생하면 오류를 표시하기 전에 지수 백오프를 적용하여 최대 10회까지 재시도합니다. 다만 Claude의 응답 도중에 발생한 실패를 항상 재시도하는 것은 아닙니다. 이 페이지의 오류 중 하나가 표시되었다면, Claude Code는 해당 실패에 적용되는 재시도를 이미 모두 수행한 것입니다.

Claude Code는 다음 실패를 재시도합니다.

* Claude의 응답이 스트리밍되기 전에 발생한 서버 오류, 과부하 응답, 요청 시간 초과.
* Claude가 사고를 마친 후 텍스트나 도구 호출을 시작하기 전에 발생한 서버 오류 또는 과부하 응답. 이 시점의 서버 오류는 최대 2회까지 재시도합니다. v2.1.284 이전에는 이 시점에서 Claude Code가 오류와 함께 턴을 종료했습니다.
* 끊어진 연결. Claude가 사고를 포함하여 응답의 어떤 부분도 완료하기 전에 요청 도중 연결이 끊어지면, 일부 텍스트가 이미 스트리밍되기 시작했더라도 Claude Code는 동일한 백오프로 요청을 다시 보내고 턴이 계속됩니다. Claude가 사고를 마친 후 텍스트나 도구 호출을 시작하기 전에 연결이 끊어지면, Claude Code는 대신 요청을 빠르게 연달아 최대 2회 다시 보내며, 이 시점에서 연결이 계속 끊어지면 `Connection lost before a response was produced`와 함께 턴을 종료합니다.
* 요청 도중 컴퓨터가 절전 모드로 전환되어 연결이 끊어졌다고 Claude Code가 감지한 경우. Claude Code는 이를 위 규칙에 따른 끊어진 연결로 간주합니다. 재시도 레이블에 구체적인 이유가 표시되면 `Connection lost while your computer was asleep`로 표시되며, Claude가 사고를 마친 후 텍스트나 도구 호출 전에 턴이 종료되면 메시지는 `Your computer went to sleep before a response was produced`로 표시됩니다.
* 응답 헤더는 도착했지만 Claude의 응답이 전혀 도착하지 않았거나, Claude가 사고를 마쳤지만 텍스트나 도구 호출을 시작하지 않은 상태에서 멈춘 응답 스트림: Claude Code는 멈춘 연결을 중단하고 요청을 최대 1회 다시 스트리밍합니다. Claude가 사고를 마친 후 텍스트나 도구 호출 전에 응답이 두 번째로 멈추면, Claude Code는 `The response stalled before a response was produced`와 함께 턴을 종료합니다.
* [첫 바이트 기한이 적용되는](https://code.claude.com/docs/ko/network-config.md#streaming-idle-watchdogs) 연결에서 API가 응답 헤더로 전혀 응답하지 않는 스트리밍 요청. 기한에 도달하면 Claude Code는 요청을 중단하고 재시도 예산 내에서 다시 보냅니다. 다시 보낸 요청에서도 기한이 만료되면 [No response from API](#no-response-from-api)와 함께 턴이 종료됩니다. `CLAUDE_CODE_RETRY_WATCHDOG`을 설정하면 Claude Code는 대신 예산 내에서 계속 다시 보냅니다.
* Claude가 사고를 마치거나 텍스트 또는 도구 호출을 시작하기 전에 API의 출력 콘텐츠 필터가 중단시킨 스트리밍 응답. Claude Code는 재시도 예산 내에서 요청을 1회 다시 보내며, 필터가 두 번째 응답도 중단시키면 [Output blocked by content filtering policy](#output-blocked-by-content-filtering-policy)를 표시합니다.
* 일시적인 429 스로틀. 단, 게이트웨이의 지출 한도 `429`는 스로틀이 아니므로 제외됩니다. [Spend limit reached](#spend-limit-reached)를 참조하세요.
  * claude.ai 구독으로 로그인한 경우, 플랜의 할당량 헤더가 포함되지 않은 429 스로틀도 여기에 포함됩니다. v2.1.199 이전에는 Claude Code가 API 키 및 Enterprise 로그인에 대해서만 이러한 스로틀을 재시도했습니다.
* 입력과 `max_tokens`의 합이 컨텍스트 한도를 초과하여 거부된 요청. 변경 없이 다시 보내면 같은 방식으로 실패하므로, Claude Code는 `max_tokens`를 줄여서 재시도하며, 다음 두 경우에는 재시도를 중단하고 대신 압축을 수행합니다.
  * 어떤 감소로도 맞출 수 없는 경우. 예를 들어 대화 자체가 컨텍스트 윈도우를 거의 채운 경우입니다.
  * 재시도에서 `max_tokens`를 더 이상 줄일 수 없는 경우. v2.1.218 이전에는 확장 사고 예산이 남은 컨텍스트를 초과하는 경우처럼, 여전히 맞지 않는 축소된 요청을 재시도 예산이 소진될 때까지 다시 보낼 수 있었습니다.
* Claude가 도구를 호출한다고 나타내지만 도구 호출이 포함되지 않은 응답. Claude Code는 Claude에게 도구 호출을 요청하는 방식으로 최대 2회 재시도합니다. 두 재시도가 모두 같은 방식으로 실패하면 `The model's tool call could not be parsed (retry also failed).`가 표시되고 턴이 종료됩니다. 다시 시도하려면 다른 메시지를 보내세요. v2.1.307 이전에는 Claude Code가 턴을 종료하기 전에 1회 재시도했습니다.
* [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md)에서 만료되었거나 누락된 Google Cloud 자격 증명, 또는 사용자의 컴퓨터에서 로드에 실패한 AWS 자격 증명. Claude Code는 캐시된 자격 증명을 폐기하고 최대 2회 재시도한 다음, [Could not load AWS or Google Cloud credentials](#could-not-load-aws-or-google-cloud-credentials)에 설명된 대로 즉시 다시 인증할 수 있도록 오류를 보고합니다. v2.1.228 이전에는 실패한 Google Cloud 자격 증명을 전체 재시도 예산만큼 재시도한 후에 오류를 표시했습니다.
* [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper) 스크립트가 자격 증명을 제공하는 동안 Anthropic API에서 직접 또는 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 통해 받은 `401` 또는 `403`. Claude Code는 스크립트를 다시 실행하고 새 출력으로 전체 재시도 예산 내에서 재시도합니다. 다시 실행할 때 스크립트 자체가 실패하면, Claude Code는 대신 [Your apiKeyHelper script is failing](#your-apikeyhelper-script-is-failing)을 표시합니다.

v2.1.227 이전에는 `Connection lost before a response was produced`가 `Connection closed while thinking, before producing a response`로, `The response stalled before a response was produced`가 `Response stalled while thinking, before producing a response`로 표시되었습니다.

Claude Code는 다음 실패를 재시도하지 않습니다.

* TLS 검사 프록시, 누락된 `NODE_EXTRA_CA_CERTS` 번들, 만료된 인증서 등으로 인한 TLS 인증서 검증 실패. Claude Code는 첫 번째 시도에서 오류를 보고하므로 인증서 설정을 즉시 수정할 수 있습니다. [SSL 인증서 오류](#ssl-certificate-errors)를 참조하세요. 핸드셰이크 시간 초과와 같은 일시적인 TLS 상황은 여전히 재시도합니다. v2.1.199 이전에는 인증서 실패를 전체 재시도 예산만큼 재시도한 후에 오류를 표시했습니다.
* Claude가 텍스트 블록이나 도구 호출을 완료한 후, 또는 사고를 마친 후 이를 시작한 후, 응답을 마치기 전에 발생한 서버 오류, 끊어진 연결 또는 멈춘 스트림. 같은 도구 호출이 두 번 실행될 수 있으므로 Claude Code는 요청을 다시 실행하지 않습니다. 대신 Claude가 완료한 내용을 유지하고, Claude가 완료한 도구 호출을 실행한 다음, 그 결과에서 턴을 계속합니다. 대화형 세션과 비대화형 세션에서 표시되는 내용은 [The response above may be incomplete](#the-response-above-may-be-incomplete)를 참조하세요. v2.1.199 이전에는 스트림 도중 서버 오류가 발생하면 부분 출력을 폐기하고 전체 턴을 오류로 보고했습니다.
* Claude가 응답을 마친 후 발생한 실패: 재시도할 것이 없으므로 Claude Code는 완성된 응답을 유지하고 턴을 정상적으로 종료합니다.
* [예상치 못한 content-type을 가진 Amazon Bedrock 스트리밍 응답](#bedrock-streaming-response-has-an-unexpected-content-type). 응답을 재작성하는 게이트웨이나 프록시가 재시도도 같은 방식으로 재작성하기 때문입니다. Claude Code v2.1.208 이상이 필요합니다.
* 실패한 스트리밍 요청의 비스트리밍 재시도가 성공 상태를 받았지만 [본문에 Claude API 메시지가 없는](#api-returned-an-empty-or-malformed-response) 경우. Claude Code는 해당 오류와 함께 턴을 종료합니다.
* 조직의 정책 검사에서 거부된 요청. 이는 거부 메시지가 포함된 `API Error:` 줄로 표시됩니다. 조직의 관리자는 Claude Enterprise 기능인 [Inference hooks](https://platform.claude.com/docs/en/manage-claude/inference-hooks)로 검사를 설정하며, 메시지는 관리자가 구성한 안내로 끝나거나 기본적으로 관리자에게 문의하라고 안내합니다. 거부는 모델이 아니라 요청의 내용에 관한 것이므로, Claude Code는 거부된 요청을 같은 모델이나 [대체 모델](https://code.claude.com/docs/ko/model-config.md#fallback-model-chains)로 다시 보내지 않습니다. v2.1.239 이전에는 거부 내용을 표시하기 전에 거부된 요청을 스트리밍 없이 또는 구성된 대체 모델로 다시 보낼 수 있었습니다.

### Claude Code가 재시도하거나 대기하는 동안 표시되는 내용

재시도하는 동안 스피너는 오류 레이블 뒤에 `Retrying in Ns · attempt x/y` 카운트다운을 표시합니다. 네트워크 중단, TLS 핸드셰이크 실패, 속도 제한 도달처럼 즉시 조치할 수 있는 실패의 경우 레이블은 첫 번째 시도부터 구체적인 이유를 표시합니다. 그 밖의 오류는 처음에 `API error`로 표시됩니다. v2.1.198부터는 세 번째 시도부터, 또는 `CLAUDE_CODE_MAX_RETRIES`가 3회 미만을 허용하는 경우 마지막 시도에서 구체적인 이유로 전환됩니다. 이전 버전에서는 마지막 시도에서만 전환됩니다.

v2.1.198부터는 재시도 중에 일반적인 스피너 팁이 표시되지 않습니다. 오류 이유가 표시된 후 실패가 529 과부하인 경우, 카운트다운 아래 줄에 서비스 상태를 확인할 위치도 표시됩니다. Anthropic API에서는 `status.claude.com`, 다른 구성에서는 메시지에 명시된 공급자 또는 게이트웨이 호스트입니다.

#### Waiting for API response

`Waiting for API response · will retry in … · check your network` 배너는 Claude Code가 요청에 대한 데이터를 전혀 받지 못한 채 최소 20초 동안 기다렸음을 의미합니다. 요청이 아직 실패한 것은 아닙니다. 카운트다운은 Claude Code가 멈춘 연결을 중단하는 시점까지 진행됩니다. 중단이 발생하는 시점에 따라 다음과 같이 처리됩니다.

* Claude가 텍스트 블록이나 도구 호출을 완료하기 전, 또는 사고를 마친 후 이를 시작하기 전이라면, Claude Code는 요청을 재시도하거나 오류와 함께 턴을 종료합니다. 어떤 멈춤을 몇 번 재시도하는지는 [자동 재시도](#automatic-retries)에 설명되어 있습니다.
* Claude가 텍스트 블록이나 도구 호출을 완료한 후, 또는 사고를 마친 후 이를 시작한 후, Claude가 응답을 마치기 전이라면, Claude Code는 Claude가 완료한 내용을 유지하고 Claude가 완료한 도구 호출에서 턴을 계속하며 [The response above may be incomplete](#the-response-above-may-be-incomplete)를 표시합니다. 비대화형 세션에서, 그리고 모든 세션의 서브에이전트 응답에 대해서는 Claude Code가 먼저 Claude에게 응답을 계속하도록 요청할 수 있습니다. 언제 그렇게 하는지와 언제 여전히 해당 알림이 표시되는지는 해당 항목에 설명되어 있습니다.
* Claude가 응답을 마친 후라면, Claude Code는 턴을 정상적으로 종료합니다.

데이터가 다시 수신되거나 재시도가 성공하면 배너는 자동으로 사라집니다. 모든 시도에서 배너가 다시 나타나면 [네트워크 문제](#unable-to-connect-to-api)로 간주하세요. 게이트웨이를 통해 연결하는 경우 [게이트웨이 뒤에서 대기 배너가 나타났다 사라지는 경우](#waiting-banner-behind-a-gateway)를 참조하세요. v2.1.185 이전에는 배너가 10초 후에 다른 문구로 표시되었습니다.

#### 게이트웨이 뒤에서 대기 배너가 나타났다 사라지는 경우

게이트웨이를 통해 연결한 상태에서 Claude가 사고하는 동안 `Waiting for API response` 배너가 나타났다 사라지기를 반복한다면, [Claude Code를 업데이트](https://code.claude.com/docs/ko/setup.md#update-claude-code)하여 v2.1.309 이상을 사용하세요. 다음 연결에서는 데이터 없이 45초가 지나야 배너가 표시됩니다.

* [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)이 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)처럼 Anthropic API가 아닌 호스트로 설정된 경우
* [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway) 세션
* `ANTHROPIC_AWS_BASE_URL`이 설정된 [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md)

v2.1.309 이전에는 이러한 연결에서 20초 후에 배너가 표시되었습니다.

### 재시도 동작 조정

다음 환경 변수로 재시도 동작을 조정할 수 있습니다.

| 변수 | 기본값 | 효과 |
| :- | :- | :- |
| [`CLAUDE_CODE_MAX_RETRIES`](https://code.claude.com/docs/ko/env-vars) | 10 | 재시도 횟수입니다. v2.1.186부터 최대 15로 제한됩니다. v2.1.199부터는 `CLAUDE_CODE_RETRY_WATCHDOG`이 기본값을 높이고 상한을 제거합니다. 스크립트에서 실패를 더 빨리 확인하려면 값을 낮추세요. |
| [`CLAUDE_CODE_RETRY_WATCHDOG`](https://code.claude.com/docs/ko/env-vars) | 설정 안 됨 | CI 작업과 같은 무인 세션에서 `1`로 설정하면 `CLAUDE_CODE_MAX_RETRIES`회 시도 후 실패하는 대신 `429` 및 `529` 용량 오류를 무기한 재시도합니다. 표준 속도 요청이 지출 한도나 소진된 사용량 크레딧을 보고하는 `429`를 받으면, 일정에 따라 재설정되는 [게이트웨이 지출 한도](#spend-limit-reached)에서 온 것이라도 Claude Code는 즉시 실패합니다. v2.1.239 이전에는 워치독이 이를 무기한 재시도했습니다. 빠른 모드 요청에 대해서는 [속도 제한 처리](https://code.claude.com/docs/ko/fast-mode.md#handle-rate-limits)를 참조하세요. v2.1.199 이상에서는 서버 오류, 시간 초과, 끊어진 연결 등 다른 일시적인 오류의 기본 재시도 횟수도 약 3시간의 백오프에 해당하는 300으로 높이고, `CLAUDE_CODE_MAX_RETRIES`를 명시적으로 설정한 경우 15의 상한을 제거합니다. |
| [`CLAUDE_CODE_RETRY_WATCHDOG_MAX_WAIT_MS`](https://code.claude.com/docs/ko/env-vars) | 설정 안 됨 | `CLAUDE_CODE_RETRY_WATCHDOG`이 설정된 경우 각 API 요청이 `429` 및 `529` 오류가 해소되기를 기다리는 최대 시간(밀리초)입니다. 설정하지 않으면 대기 시간에 제한이 없습니다. Claude Code v2.1.295 이상이 필요합니다. |
| [`CLAUDE_CODE_RETRY_WATCHDOG_USAGE_LIMIT_RECHECK_MS`](https://code.claude.com/docs/ko/env-vars) | 설정 안 됨 | `CLAUDE_CODE_RETRY_WATCHDOG`이 설정된 상태에서 요청이 [사용 한도](#youve-hit-your-session-limit)가 재설정되기를 기다리는 동안, 해당 한도가 이미 해제되었는지 확인하는 검사 사이의 최소 간격(밀리초)입니다. 검사에서 한도가 해제된 것으로 확인되면 요청이 즉시 전송됩니다. `60000`에서 `10800000` 사이의 숫자만 입력하세요. 설정하지 않거나 해당 범위를 벗어나면 검사를 수행하지 않습니다. Claude Code가 이러한 검사를 건너뛰는 경우는 [환경 변수 참조](https://code.claude.com/docs/ko/env-vars.md)를 참조하세요. Claude Code v2.1.305 이상이 필요합니다. |
| [`CLAUDE_CODE_OVERLOADED_RETRY_BASE_DELAY_MS`](https://code.claude.com/docs/ko/env-vars) | 500 | API가 `529` 과부하 오류로 거부한 요청의 재시도 간 백오프 시작 지연 시간(밀리초)입니다. API가 용량 한계에 도달했을 때 재시도를 더 긴 기간에 걸쳐 분산하려면 최대 32000까지 값을 높이세요. `CLAUDE_CODE_RETRY_WATCHDOG`이 `1`로 설정되어 있거나 거부된 요청이 [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md#handle-rate-limits)로 전송된 경우에는 효과가 없습니다. Claude Code v2.1.292 이상이 필요합니다. |
| [`CLAUDE_CODE_OVERLOADED_RETRY_MAX_DELAY_MS`](https://code.claude.com/docs/ko/env-vars) | 32000 | API가 `529` 과부하 오류로 거부한 요청의 재시도 간 백오프 상한(밀리초)입니다. API가 용량 한계에 도달했을 때 이후 재시도 간격이 계속 벌어지도록 하려면 최대 64000까지 값을 높이세요. `CLAUDE_CODE_RETRY_WATCHDOG`이 `1`로 설정되어 있거나 거부된 요청이 [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md#handle-rate-limits)로 전송된 경우에는 효과가 없습니다. Claude Code v2.1.296 이상이 필요합니다. |
| [`API_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars) | 600000 | 각 요청 시도가 응답 헤더를 받기까지 주어지는 시간(밀리초)입니다. 그 이후 스트리밍 응답이 진행되는 시간은 제한하지 않습니다. 느린 네트워크나 프록시의 경우 값을 높이세요. 이 값이 첫 바이트 기한의 상한으로 사용되는 방식은 [No response from API](#no-response-from-api)를 참조하세요. |
| [`CLAUDE_CODE_NONSTREAMING_TIMEOUT_RETRIES`](https://code.claude.com/docs/ko/env-vars) | 설정 안 됨 | 시간 초과된 [비스트리밍 요청](#streaming-response-ended-before-any-complete-data-was-received)을 다시 보내는 횟수의 한도입니다. 한도에 도달하면 요청이 실패합니다. 생성하는 데 타임아웃보다 오래 걸리는 Claude의 응답은 다시 보낼 때마다 다시 시간 초과되므로, 더 빨리 실패하려면 `0`과 같은 낮은 값으로 설정하세요. 각 비스트리밍 시도는 로컬 세션에서 300초 후, 또는 `API_TIMEOUT_MS`를 양수 값으로 설정한 경우 해당 시간 후에 시간 초과됩니다. Claude Code v2.1.285 이상이 필요합니다. |
| [`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars) | 설정 안 됨 | 스트리밍 요청의 첫 번째 응답 바이트에 대한 기한(밀리초)입니다. Claude Code v2.1.242 이상이 필요합니다. 이 값이 설정되지 않았을 때 Claude Code가 기한을 정하는 방법은 [No response from API](#no-response-from-api)를 참조하세요. |

## 서버 오류

이러한 오류의 대부분은 추론 제공자에서 발생합니다: Anthropic API의 Anthropic 서비스, Amazon Bedrock의 해당 제공자 엔드포인트 뒤의 서비스, Google Cloud의 Agent Platform, Microsoft Foundry 또는 사용자 정의 게이트웨이입니다. [자동 모드가 작업의 안전성을 결정할 수 없음](#auto-mode-cannot-determine-the-safety-of-an-action) 및 [API 오류로 인해 에이전트가 조기에 종료됨](#agent-terminated-early-due-to-an-api-error)은 또한 사용자 측의 원인을 다룹니다. 예를 들어 분류기 모델을 호출할 수 없는 Amazon Bedrock 계정이나 사용 한도에 도달한 서브에이전트입니다.

### API 오류: 500 내부 서버 오류

Claude Code는 모든 5xx 응답에 대해 상태 코드와 API의 오류 메시지를 표시합니다. 아래 예제는 Anthropic API의 500 응답을 보여줍니다:

```text theme={null}
API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check https://status.claude.com.
```

뒤따르는 문장은 서비스 상태를 확인할 위치를 명시하며 제공자에 따라 다릅니다. Amazon Bedrock, Google Cloud의 Agent Platform 및 Microsoft Foundry 구성은 해당 제공자의 서비스 상태를 명시합니다. 사용자 정의 `ANTHROPIC_BASE_URL`은 게이트웨이 호스트를 명시합니다.

API 자체의 5xx는 API 내부의 예상치 못한 실패를 나타냅니다. 이는 사용자의 프롬프트, 설정 또는 계정으로 인해 발생하지 않습니다.

프록시, 로드 밸런서 또는 게이트웨이가 HTML 오류 페이지로 응답할 때 메시지는 상태 코드와 페이지의 제목(예: `API Error: 502 Bad Gateway`)을 표시합니다. 제목이 없는 페이지의 경우 메시지는 상태 코드와 표준 이름을 대신 표시합니다. v2.1.281 이전에는 페이지에 제목이 있을 때 상태 코드가 삭제되었고 제목이 없을 때 페이지의 원본 마크업이 인쇄되었습니다.

**수행할 작업:**

* [status.claude.com](https://status.claude.com) 또는 메시지에 명시된 제공자 상태 페이지에서 활성 인시던트를 확인합니다
* 1분 기다린 후 메시지를 다시 보냅니다. 원본 메시지는 여전히 대화에 있으므로 긴 프롬프트의 경우 전체를 다시 붙여넣는 대신 `try again`을 입력할 수 있습니다.
* [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)이 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 가리키고 모든 요청이 이런 방식으로 실패하면 게이트웨이가 Claude Code가 기본적으로 보내는 도구 검색 필드를 거부하는지 확인합니다. 확인하려면 [LLM 게이트웨이를 통한 도구 검색](https://code.claude.com/docs/ko/mcp.md#tool-search-through-a-gateway)에 설명된 대로 `ENABLE_TOOL_SEARCH=false`를 설정한 후 다시 시도합니다. v2.1.304 이전에는 `ENABLE_TOOL_SEARCH`로 켜지 않는 한 게이트웨이 뒤에서 도구 검색이 꺼져 있었습니다.
* 오류가 게시된 인시던트 없이 계속되면 `/feedback`을 실행하여 Anthropic이 요청 세부 정보로 조사할 수 있도록 합니다. 환경에서 `/feedback`을 사용할 수 없는 경우 [오류 보고](#report-an-error)를 참조하세요.

### API 오류: 반복된 529 오버로드 오류

API가 모든 사용자에게 일시적으로 용량이 부족합니다. Claude Code는 이 메시지를 표시하기 전에 이미 여러 번 재시도했습니다:

```text theme={null}
API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check https://status.claude.com.
```

뒤따르는 문장은 위의 500 오류와 동일한 방식으로 제공자에 따라 다릅니다.

529는 사용 한도가 아니며 할당량에 대해 계산되지 않습니다.

**수행할 작업:**

* [status.claude.com](https://status.claude.com) 또는 메시지에 명시된 제공자 상태 페이지에서 용량 공지를 확인합니다
* 몇 분 후에 다시 시도합니다
* `/model`을 실행하고 다른 모델로 전환하여 계속 작업합니다. 용량은 모델별로 추적되기 때문입니다. Claude Code는 한 모델이 특히 높은 부하를 받을 때 모델 전환을 요청합니다. 예를 들어 `Opus is experiencing high load, please use /model to switch to Sonnet`입니다. Fable 모델에서 메시지는 Fable을 명시합니다.

  Claude Desktop 앱이 실행하는 세션(예: Code 탭 또는 Cowork)에서 메시지는 `Opus is experiencing high load. Switch to Sonnet.`으로 읽히며 앱의 모델 선택기로 모델을 전환합니다.

### 요청 시간 초과

API가 연결 마감 시간 전에 응답하지 않았습니다.

```text theme={null}
Request timed out
```

기본 요청 타임아웃은 10분입니다. [`API_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars)를 `0`으로 설정하면 이 요청 타임아웃이 꺼집니다. [첫 바이트 마감 시간](#no-response-from-api)과 본문 유휴 타임아웃은 `0`으로 설정해도 꺼지지 않으므로, 스트리밍 요청은 여전히 [연결에 적용되는 타임아웃](https://code.claude.com/docs/ko/network-config.md#streaming-idle-watchdogs)에 따라 실행됩니다. 비스트리밍 시도는 로컬 세션에서 300초 제한을 유지하므로 여전히 이 메시지로 끝날 수 있습니다.

**수행할 작업:**

* 모든 요청이 이 메시지로 실패하고 `API_TIMEOUT_MS`를 `0`으로 설정한 경우 `claude --version`을 확인합니다. v2.1.305 이전 버전이면 Claude Code를 업데이트하거나 양수 값을 설정합니다.
* 요청을 다시 시도합니다
* 느린 네트워크 또는 프록시가 원인인 경우 [자동 재시도](#automatic-retries)에 설명된 대로 `API_TIMEOUT_MS`를 높입니다
* 시간 초과가 빈번하고 네트워크가 정상인 경우 아래의 [네트워크 및 연결 오류](#network-and-connection-errors)를 참조하세요

### API에서 응답 없음

Claude Code가 스트리밍 요청을 보냈고, API가 첫 바이트의 마감 시간 내에 응답 헤더를 반환하지 않았습니다. Claude Code는 이러한 요청을 전체 `API_TIMEOUT_MS` 요청 타임아웃까지 기다리지 않고 중단하며, [재시도 예산](#tune-retry-behavior)이 허용하는 경우 요청을 다시 보냅니다. 재시도에서도 마감 시간이 지나면 턴이 이 메시지로 끝나며, 각 시도가 대기한 시간을 표시합니다.

[`CLAUDE_CODE_RETRY_WATCHDOG`](https://code.claude.com/docs/ko/env-vars)을 설정하면 Claude Code는 턴을 종료하는 대신 [재시도 동작 조정](#tune-retry-behavior)에 설명된 예산 내에서 계속 재시도합니다.

```text theme={null}
API Error: No response from API (waited 3m, then 10m on the retry). If a proxy or gateway on your network holds responses until they complete, raise API_TIMEOUT_MS or CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS to wait longer.
```

Claude Code는 첫 시도의 응답 헤더 대기와 재시도의 대기를 별도로 설정합니다:

* **첫 시도**: 1 이상으로 설정할 때 [`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars), 10초에서 30분 사이로 제한됩니다. 그렇지 않으면 Claude Code는 [스트리밍 유휴 감시자](https://code.claude.com/docs/ko/network-config.md#streaming-idle-watchdogs)에 나열된 바이트 수준 감시자 타임아웃을 사용하므로 해당 타임아웃을 변경하는 변수가 이 대기도 변경합니다. 어느 쪽이든 Claude Code는 요청 본문의 32KB마다 1초를 추가합니다.
* **재시도**: `API_TIMEOUT_MS`보다 1초 적게, 기본값으로 거의 10분이므로 재시도가 응답을 생성이 완료될 때까지 보유하는 프록시 또는 게이트웨이를 초과할 수 있습니다. Amazon Bedrock에서 재시도는 첫 시도와 동일한 마감 시간을 사용하며 메시지는 두 가지 대신 하나의 기간을 표시합니다.

  Amazon Bedrock을 제외하고, `API_TIMEOUT_MS`를 `0`으로 설정하면 재시도는 10분에 32KB당 1초를 더한 시간 동안 대기하며, 첫 시도의 대기가 더 길면 첫 시도만큼 대기합니다.

어느 대기도 양수 `API_TIMEOUT_MS`보다 1초 적은 값을 초과하지 않으며, 11초 미만의 양수 `API_TIMEOUT_MS`는 마감 시간을 끕니다. 바이트 수준 감시자는 응답 헤더가 도착한 후에만 시작되므로 그 후 바이트 전송을 중지하는 응답은 이 마감 시간 대신 [정지된 스트림 규칙](#automatic-retries)을 따릅니다.

[Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway) 세션에서는 `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`를 `1` 이상으로 설정하여 [이 마감 시간을 켠](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#retry-an-unanswered-request-sooner-with-the-first-byte-deadline) 경우에만 이 마감 시간이 적용됩니다.

**수행할 작업:**

* 메시지를 다시 보냅니다. 원본 메시지는 여전히 대화에 있으므로 긴 프롬프트의 경우 전체를 다시 붙여넣는 대신 `try again`을 입력할 수 있습니다.
* 반복되면 [네트워크 또는 프록시 문제](#unable-to-connect-to-api)로 취급합니다.
* 네트워크의 프록시 또는 게이트웨이가 응답을 생성이 완료될 때까지 보유하는 경우 `API_TIMEOUT_MS`를 높여 재시도가 더 오래 대기하도록 합니다. Amazon Bedrock에서 `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`도 높입니다.
* 첫 시도가 계속 시간 초과되고 재시도가 성공하면 `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`를 높여 첫 시도도 충분히 오래 대기하도록 합니다.

v2.1.242 이전에는 Claude Code가 응답 없는 스트리밍 요청이 실패하기 전에 전체 `API_TIMEOUT_MS` 요청 타임아웃(기본값 10분)을 기다렸습니다. v2.1.261 이전에는 재시도가 첫 시도와 동일한 마감 시간을 기다렸고 메시지는 기간을 표시하지 않았습니다. v2.1.307 이전에는 Claude Code가 Claude apps gateway 세션에서 `CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`를 무시했습니다.

### 위의 응답이 불완전할 수 있음

스트리밍 요청이 응답이 진행 중일 때 실패했습니다. Claude가 텍스트 블록 또는 도구 호출을 완료한 후 또는 사고를 마친 후 하나를 시작했습니다. 요청을 다시 보내면 동일한 도구 호출을 두 번 실행할 수 있으므로 Claude Code는 Claude가 완료한 출력을 유지하고 턴을 버리는 대신 이 공지를 추가합니다. 표시되는 변형은 원인을 명시합니다:

```text theme={null}
API Error: Server error mid-response. The response above may be incomplete.
API Error: Connection lost mid-response. The response above may be incomplete.
API Error: Your computer went to sleep mid-response. The response above may be incomplete.
API Error: The response stopped arriving. The response above may be incomplete.
API Error: Part of the response never arrived. The response above may be incomplete.
API Error: The response stream was malformed. The response above may be incomplete.
```

* `Server error mid-response`: 스트림 중간 오버로드 또는 5xx 서버 오류입니다. 이 변형은 Claude Code v2.1.199 이상이 필요합니다. 그 이전에는 부분 출력을 버리고 전체 턴을 오류로 보고했습니다.
* `Connection lost mid-response`: 연결이 끊어졌습니다. 프록시 또는 게이트웨이가 응답이 완료되기 전에 응답 본문을 깔끔하게 종료할 때도 이 변형이 표시됩니다.
* `Your computer went to sleep mid-response`: Claude Code가 응답이 스트리밍되는 동안 컴퓨터가 절전 모드로 전환되었음을 감지했습니다. 컴퓨터가 깨어나면 Claude Code는 연결을 끊어진 것으로 취급하고 읽기를 중지합니다.
* `Part of the response never arrived`: 스트림 이벤트가 API와 Claude Code 사이에서 손실되어 나중 이벤트가 도착하지 않은 콘텐츠를 참조했습니다. v2.1.281 이전에는 이 경우 턴이 `API Error: Content block not found`로 종료되었습니다.
* `The response stream was malformed`: 이미 완료된 콘텐츠 블록에 대한 이벤트가 도착했거나 손상된 이벤트가 도착했습니다. 손상된 이벤트는 데이터가 유효한 JSON이 아니거나 콘텐츠가 누락되었거나 콘텐츠가 이벤트의 유형과 일치하지 않는 이벤트입니다. v2.1.284 이전에는 파서의 원본 오류(예: `API Error: JSON Parse error`로 시작하는 오류)가 Claude가 사고, 텍스트 블록 또는 도구 호출을 완료한 후 유효하지 않은 JSON이 있는 이벤트가 도착했을 때 대신 나타났습니다.
* `The response stopped arriving`: 연결은 열려 있었지만 데이터 전달을 중지했으므로 스트리밍 유휴 감시자가 중단했습니다. v2.1.222 이전에는 Claude Code가 `ANTHROPIC_BASE_URL` 또는 `ANTHROPIC_AWS_BASE_URL`을 통해 도달한 [게이트웨이](https://code.claude.com/docs/ko/gateways.md) 연결에서 서버의 킵얼라이브 핑이 여전히 도착하는 동안 이 실패를 보고할 수 있었습니다. 파싱된 응답 이벤트만 계산했기 때문입니다. 업그레이드하면 해당 경로에서 이러한 거짓 시간 초과를 중지합니다. `ANTHROPIC_BEDROCK_BASE_URL`과 같은 제공자 기본 URL을 통해 도달한 게이트웨이는 바이트 감시자로 래핑되지 않습니다. [스트리밍 유휴 감시자](https://code.claude.com/docs/ko/network-config.md#streaming-idle-watchdogs)를 참조하세요.

v2.1.227 이전에는 `Connection lost mid-response`가 `Connection closed mid-response`로 읽혔고 `The response stopped arriving`이 `Response stalled mid-stream`으로 읽혔습니다.

Claude가 텍스트 또는 도구 호출을 시작하기 전에 손실되거나 중복되거나 손상된 스트림 이벤트가 도착하면 이 공지가 표시되지 않습니다:

* Claude가 사고만 완료했으면 Claude Code가 요청을 다시 발급합니다. 다시 발급된 스트림이 동일한 방식으로 끊어지면 턴이 `Part of the response never arrived and no response was produced. Try again.` 또는 `The response stream was malformed and no response was produced. Try again.`으로 끝납니다.
* 아무것도 완료되지 않았으면 Claude Code가 스트리밍 없이 요청을 다시 보냅니다. [`CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK`](https://code.claude.com/docs/ko/env-vars)으로 해당 폴백을 끈 경우 턴이 손실된 이벤트에 대해 `API Error: Content block not found`로 끝나거나 중복된 이벤트에 대해 `API Error: Content block already closed`로 끝납니다. 손상된 이벤트의 경우 폴백이 꺼져 있으면 턴이 `API Error: Stream event unreadable` 또는 파서의 원본 오류로 끝납니다.

4가지 경우에 Claude Code는 이 공지를 즉시 표시하지 않고 실패를 처리합니다:

* 응답의 앞부분에서 Claude Code는 실패를 재시도하거나 다른 오류로 턴을 종료합니다. [자동 재시도](#automatic-retries)를 참조하세요.
* 이러한 실패 중 하나가 Claude가 응답을 마친 후에 도착하면 Claude Code는 완전한 응답을 유지하고 이 공지 없이 턴을 정상적으로 종료합니다. v2.1.222 이전에는 Claude Code가 응답이 완료된 후 연결이 끊어지거나 정지되었을 때 이 공지를 표시했고 응답이 완전했음에도 불구하고 턴을 오류로 보고했습니다.
* [비대화형 세션](https://code.claude.com/docs/ko/headless.md)(예: `-p` 실행, [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 실행 또는 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md))에서 잘린 응답이 주 대화에 있고 텍스트를 포함하지만 도구 호출이 없는 경우 `continue`를 직접 보낼 필요가 없습니다: Claude Code는 부분 출력을 유지하고 Claude에게 중단된 위치에서 계속하도록 요청하며, 최대 3번 연속으로 요청합니다. 이 공지는 Claude Code가 해당 연속을 모두 사용한 후에만 이러한 응답에 대해 표시됩니다. v2.1.246 이전에는 Claude Code가 비대화형 턴을 첫 번째 잘림에서 이 공지로 종료했습니다.
* [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#api-errors-in-subagents)에서, 세션이 대화형인지 여부와 관계없이: 잘린 응답이 텍스트를 포함하지만 도구 호출이 없을 때 Claude Code는 서브에이전트에게 계속하도록 요청합니다. 공지는 해당 연속을 모두 사용한 후에만 서브에이전트의 마지막 메시지가 됩니다. v2.1.257 이전에는 서브에이전트가 첫 번째 잘림에서 이 공지를 표시했습니다.

**수행할 작업:**

* 대화형 세션에서 화면에 남아 있는 응답을 읽습니다: Claude Code는 오류 전에 Claude가 완료한 모든 블록을 유지하지만 턴이 끝날 때 중단된 최종 블록을 버립니다. 따라서 최종 문장 또는 도구 호출이 누락될 수 있습니다. `continue`로 회신하여 Claude가 마지막으로 완료한 블록에서 계속하도록 합니다.
* [비대화형 모드](https://code.claude.com/docs/ko/headless.md)(`-p`):
  * 기본 텍스트 출력을 사용하면 Claude Code는 턴의 앞부분에서 여전히 보유한 마지막 완료된 텍스트 블록을 인쇄한 후 이 메시지를 인쇄합니다. 보유하지 않으면 Claude Code는 이 메시지만 인쇄합니다. 예를 들어 Claude Code가 턴 중간에 대화를 압축하고 해당 텍스트를 지웠기 때문입니다. v2.1.219 이전에는 Claude Code가 `-p` 텍스트 출력에서 이 메시지만 인쇄했고 이미 생성한 응답을 버렸습니다.
  * `--output-format json` 또는 `stream-json`을 사용하면 Claude Code는 이 메시지를 `result` 필드에 보고합니다.
  * 연결이 안정되면 턴을 계속하려면 세션을 재개하고 [대화 계속](https://code.claude.com/docs/ko/headless.md#continue-conversations)에 설명된 대로 `continue`를 보냅니다.

### 자동 모드가 작업의 안전성을 결정할 수 없음

[자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 작업을 분류하는 데 사용하는 모델이 결정을 내릴 수 없어 자동 모드가 작업을 자동으로 승인하지 않았습니다. 표시되는 메시지는 분류기가 실패한 방식에 따라 다릅니다.

작업 디렉터리 내의 읽기, 검색 및 편집은 분류기를 건너뛰므로 이러한 모든 경우에 계속 작동합니다.

분류기 모델을 사용할 수 없을 때:

```text theme={null}
<model> is temporarily unavailable, so auto mode cannot determine the safety of <tool> right now. Wait a moment and then try this action again.
```

대화형 세션에서는 이 메시지 대신 도구 호출 아래에 흐린 `Not run · auto mode's check had no usable answer` 행이 나타납니다. `Ctrl+O`를 눌러 [트랜스크립트 뷰어](https://code.claude.com/docs/ko/interactive-mode.md#transcript-viewer)에서 메시지를 확인합니다. [서버가 안전 판정을 반환하지 않음](#the-server-returned-no-safety-verdict) 아래의 `gave no verdict` 거부도 동일한 행을 표시합니다. v2.1.296 이전에는 메시지가 호출 아래에 빨간색 오류로 나타났습니다.

Claude Code가 실패 범주를 결정할 수 있을 때 `temporarily unavailable` 뒤의 괄호에 범주를 명시합니다. 예를 들어 `<model> is temporarily unavailable (rate-limited), so auto mode cannot determine the safety of <tool> right now`입니다. 범주는 `(rate-limited)`, `(overloaded)`, `(server error)`, `(timed out)` 및 `(connection failed)`입니다. `(timed out)` 또는 `(connection failed)`가 반복되면 연결을 확인하세요. [API에 연결할 수 없음](#unable-to-connect-to-api)을 참조하세요. v2.1.229 이전에는 메시지가 범주를 명시하지 않았고 `Wait briefly and then try this action again`으로 읽혔습니다.

맞는 범주가 없으면 메시지는 괄호에 범주 없이 나타납니다. 둘 이상의 실패가 해당 형식을 생성합니다. [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md)에서, [Mantle 엔드포인트](https://code.claude.com/docs/ko/amazon-bedrock.md#use-the-mantle-endpoint) 포함, AWS 계정이 메시지에 명시된 모델을 호출할 수 없을 때도 나타나며, 계정에 모델에 대한 액세스 권한이 부여될 때까지 모든 재시도에서 해당 실패가 반복됩니다.

**수행할 작업:**

* 몇 초 후 재시도합니다. Claude는 동일한 메시지를 보고 일반적으로 자동으로 재시도합니다. 일시적 실패는 [자동 모드 적격성](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)과 무관합니다. 설정을 변경할 필요가 없습니다
* 재시도가 계속 실패하면 읽기 전용 작업을 계속하고 나중에 차단된 작업으로 돌아옵니다
* Amazon Bedrock에서 메시지가 모든 재시도에서 반환되면 계정이 명시된 모델을 호출할 수 있는지 확인합니다: 표준 Amazon Bedrock 모델의 경우 [IAM 정책](https://code.claude.com/docs/ko/amazon-bedrock.md#iam-configuration)이 호출을 허용하는지 확인합니다. Mantle 모델 ID의 경우 [AWS 계정 팀에 문의](https://code.claude.com/docs/ko/amazon-bedrock.md#mantle-endpoint-errors)합니다
* 메시지가 모든 재시도에서 반환되고 [`CLAUDE_CODE_AUTO_MODE_MODEL`](https://code.claude.com/docs/ko/permission-modes#choose-the-classifier-model)에 설정한 모델을 명시하는 경우, 세션이 실행되는 API 또는 클라우드 제공자가 해당 모델 ID를 제공하는지 확인합니다. 제공하지 않으면 변수를 해당 제공자가 제공하는 모델 ID로 설정하거나, 변수를 해제하여 [기본 분류기 모델](https://code.claude.com/docs/ko/permission-modes.md#default-classifier-model)을 사용합니다.

분류기 요청이 OAuth 토큰이 만료되었거나 다른 세션에서 회전되었기 때문에 실패할 때 Claude Code는 토큰을 새로 고치고 요청을 한 번 재시도하므로 일상적인 토큰 만료는 이 메시지로 표시되지 않습니다. v2.1.216 이전에는 만료되었거나 회전된 토큰이 각 분류기 요청을 실패시켰고 토큰이 새로 고쳐질 때까지 자동 모드가 확인 대상인 모든 작업을 이 메시지와 함께 거부했습니다.

분류기가 파싱할 수 없는 응답을 반환했을 때:

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — run with --debug for details
```

**수행할 작업:**

* 작업을 재시도합니다. 이는 일반적으로 다음 시도에서 성공합니다
* `claude --debug`를 실행하고 작업을 반복하여 디버그 로그에서 세부 정보를 확인합니다

별도의 API 안전 검사가 이전 대화 내용으로 인해 분류기 요청을 차단했을 때:

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — a safety check separate from auto mode blocked this request because of earlier conversation content — it isn't about the action itself — run with --debug for details
```

Claude Code는 작업을 거부하지만 Claude에게 이것이 작업이 안전하지 않다는 판단이 아니며 재시도하는 대신 다른 작업을 계속하도록 알립니다. 이러한 거부는 [자동 모드의 일시 중지 임계값](https://code.claude.com/docs/ko/permission-modes.md#when-auto-mode-falls-back)에 대해 계산되지 않습니다. [비대화형](https://code.claude.com/docs/ko/headless.md) `-p` 실행에서 Claude Code는 실행을 중지하지 않습니다. Claude가 수신하는 내용은 작업을 요청한 위치에 따라 다릅니다:

* `-p` 실행 중 `--input-format stream-json` 없이 [백그라운드 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)에 Claude Code는 `Agent aborted: auto mode classifier request refused by the safety safeguard in headless mode`를 포함하는 오류 결과를 반환합니다
* 대화형 세션 및 `-p` 실행의 주 대화를 포함한 다른 모든 곳에서 Claude Code는 해당 거부를 Claude에게 반환합니다

v2.1.225 이전에는 Claude Code가 이러한 거부를 일시 중지 임계값에 대해 계산했고 진정한 분류기 차단과 동일한 거부 메시지를 반환했습니다.

**수행할 작업:**

* 이것은 작업에 대한 결정이 아닙니다. 대화에 이미 있는 내용이 자동 모드가 대화를 분류기에 보낼 때 API의 안전 필터를 트리거했습니다
* 재시도는 도움이 되지 않습니다. 동일한 대화 내용이 필터를 다시 트리거합니다
* 대화형 세션에서 다른 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)로 전환하여 확인 요청이 표시될 때 작업을 승인할 수 있습니다
* 트리거 내용 없이 새 대화를 시작합니다

대화가 Claude Code의 분류기 요청에 비해 너무 길고 Claude Code가 [자체적으로 압축](#was-not-reviewed-and-did-not-run)할 수 없을 때:

```text theme={null}
Auto mode classifier transcript exceeded context window — falling back to manual approval (try /compact to reduce conversation size)
```

작업에 발생하는 일은 Claude가 요청한 위치에 따라 다릅니다:

* 대화형 세션에서 자동 모드는 해당 작업에 대해 일반 권한 프롬프트로 폴백하므로 수동으로 승인하거나 거부할 수 있습니다
* [비대화형](https://code.claude.com/docs/ko/headless.md) `-p` 실행 중 `--input-format stream-json` 없이 [백그라운드 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)에 Claude Code는 `Agent aborted: auto mode classifier transcript exceeded context window in headless mode`를 포함하는 오류 결과를 반환하고 실행을 계속합니다
* [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 없이 `-p` 실행의 다른 곳에서 폴백할 프롬프트가 없으므로 작업이 실행되지 않고 실행이 계속됩니다

**수행할 작업:**

* 대화형 세션에서 나타나는 프롬프트에서 작업을 승인하거나 거부합니다
* 대화형 세션에서 `/compact`를 실행하여 대화 크기를 줄여 후속 작업이 분류기 윈도우에 다시 맞도록 합니다

### 서버가 안전 판정을 반환하지 않음

[서버 측 분류기 검토](https://code.claude.com/docs/ko/permission-modes.md#server-side-classifier-review) 하에서 자동 모드는 서버가 판정을 제공하지 않을 때 작업을 거부합니다. 거부는 Claude Code가 하나를 결정할 수 있을 때 괄호에 범주를 명시합니다. 예를 들어 `(timed out)`:

```text theme={null}
The server-side auto mode classifier gave no verdict (timed out), so auto mode cannot determine the safety of <tool>.
```

메시지의 나머지 부분은 Claude에게 한 번의 재시도가 도움이 될 수 있는지 알려줍니다. 이러한 거부 중 일부 전에 Claude Code는 대기하므로 Claude의 다음 시도가 즉시 따르지 않습니다. 대화형 세션에서 대기 중에 스피너는 `Auto mode check unavailable`을 카운트다운과 함께 표시하며, `Esc`를 누르면 턴이 중단됩니다.

10개 응답이 연속으로 판정이 없으면 자동 모드는 턴을 중지합니다:

```text theme={null}
Auto mode is unavailable — the server returned no safety verdict for the last 10 responses, so Claude stopped. Send a message to try again, or switch out of auto mode.
```

중지 메시지는 각 세션 종류에서 다른 위치에 나타납니다:

* 대화형 세션에서 메시지는 트랜스크립트에 경고로 나타나고 턴이 끝납니다
* [비대화형](https://code.claude.com/docs/ko/headless.md) `-p` 실행에서 실행이 끝나고 실행 오류를 보고합니다. 기본 텍스트 출력을 사용하면 메시지가 stderr에 인쇄됩니다.
* [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)가 한도에 도달했을 때 서브에이전트는 완료 전에 중지되고 Claude는 자동 모드가 중지했다는 메모와 함께 서브에이전트가 생성한 것을 받습니다

**수행할 작업:**

* 대화형 세션에서 `Ctrl+O`를 눌러 [트랜스크립트 뷰어](https://code.claude.com/docs/ko/interactive-mode.md#transcript-viewer)에서 거부 텍스트를 확인합니다.
* 거부가 `(the conversation is too long for the check)`를 명시하면 Claude Code 프롬프트에서 `/compact`를 실행하여 대화를 줄입니다. 대화가 짧아질 때까지는 다른 메시지를 보내도 동일한 거부를 받습니다. [자동 압축](https://code.claude.com/docs/ko/settings-reference.md#autocompactenabled)을 끈 경우 다시 켜서 다음에는 Claude Code가 자체적으로 압축하도록 합니다.
* 다른 메시지를 보내 Claude가 다시 시도하도록 합니다. 응답 수 계산이 다시 시작됩니다.
* 중지가 반복되고 요청이 [LLM 게이트웨이 또는 프록시](https://code.claude.com/docs/ko/llm-gateway)를 통과하면 스트리밍 응답을 자르거나 다시 쓰는지 확인합니다. [서버 측 분류기 검토](https://code.claude.com/docs/ko/permission-modes.md#server-side-classifier-review)는 어떤 게이트웨이 동작이 거부를 유발하는지 설명하며, [게이트웨이 호환성 가이드](https://code.claude.com/docs/ko/llm-gateway-protocol.md#feature-pass-through)는 변경되지 않은 상태로 통과시켜야 할 내용을 나열합니다.
* Claude Code를 시작하기 전에 `CLAUDE_CODE_AUTO_MODE_SERVER=0`을 설정하여 대신 자체 분류기 요청을 사용합니다. v2.1.281 이전에는 Claude Code가 Anthropic API에 대한 직접 연결에서 변수를 읽지 않았습니다.
* 대신 작업을 직접 승인하려면 [자동 모드에서 전환](https://code.claude.com/docs/ko/permission-modes.md#switch-permission-modes)합니다

v2.1.280 이전에는 Claude Code가 판정이 없는 응답의 각 작업을 즉시 거부했고 턴을 중지하지 않았습니다.

v2.1.302 이전에는 Anthropic API에 대한 직접 연결에서 Claude Code가 서버 검사에 비해 너무 길어진 대화를 압축하지 않았습니다.

### Was not reviewed and did not run

`was not reviewed and did not run` 거부는 대화가 너무 길어 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) 분류기가 작업을 검사할 수 없으므로 작업이 실행되지 않았음을 의미합니다. Claude Code는 Claude에게 다음 메시지를 반환합니다:

```text theme={null}
<tool> was not reviewed and did not run: the conversation is too long for auto mode's classifier. Claude Code will try to compact the conversation before the next request; if this action is still needed after that, issue it again and it will be reviewed normally.
```

압축이 실패하면 분류기가 검사할 수 없는 이후 작업은 다른 두 메시지 중 하나를 받습니다:

* [`gave no verdict (the conversation is too long for the check)`](#the-server-returned-no-safety-verdict) 거부
* [`Auto mode classifier transcript exceeded context window`](#auto-mode-cannot-determine-the-safety-of-an-action) 메시지

**수행할 작업:**

* 메시지가 알리는 압축이 성공하면 아무것도 할 필요가 없습니다.
* 두 메시지 중 하나가 표시되면 Claude Code 프롬프트에서 `/compact`를 실행하여 직접 대화를 줄입니다. [자동 압축](https://code.claude.com/docs/ko/settings-reference.md#autocompactenabled)을 끈 경우 다시 켜서 다음에는 Claude Code가 자체적으로 압축하도록 합니다.

### API 오류로 인해 에이전트가 조기에 종료됨

[서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)의 API 요청이 사용 한도에 도달했거나 서버 오류에 대한 재시도가 소진되는 등의 이유로 최종적으로 실패했으므로 서브에이전트가 작업을 마치기 전에 중지했습니다. 이 메시지는 Claude Code v2.1.199 이상이 필요합니다. 그 이전에는 API 오류 텍스트가 서브에이전트의 결과인 것처럼 Claude에게 반환되었습니다.

```text theme={null}
Agent terminated early due to an API error: <error detail>
```

**수행할 작업:**

* 콜론 뒤의 오류 세부 정보를 이 페이지의 해당 섹션(예: [사용 한도](#usage-limits) 또는 [서버 오류](#server-errors))과 대조하고 해당 섹션의 단계를 따릅니다
* 기본 오류가 해결되면 Claude에게 작업을 재시도하거나 [서브에이전트를 재개](https://code.claude.com/docs/ko/sub-agents.md#resume-subagents)하도록 요청합니다

속도 제한, 오버로드 또는 서버 오류가 이미 텍스트 출력을 생성한 포그라운드 서브에이전트를 중단할 때 Claude는 이 오류 대신 불완전으로 표시된 부분 출력을 수신합니다. 유일한 출력이 도구 호출인 서브에이전트도 이 오류를 받습니다. v2.1.199에서는 해당 형태가 빈 부분 결과를 대신 반환했습니다. [서브에이전트의 API 오류](https://code.claude.com/docs/ko/sub-agents.md#api-errors-in-subagents)를 참조하세요.

## 사용 한도

이 섹션의 오류 대부분은 계정 또는 플랜에 연결된 할당량에 도달했음을 의미합니다. 세 가지는 다르게 동작합니다. [`Server is temporarily limiting requests`](#server-is-temporarily-limiting-requests)는 플랜 할당량과 무관한 서버 측 제한이고, [`Usage credits required for 1M context`](#usage-credits-required-for-1m-context)는 할당량 소진이 아닌 사용 자격 확인이며, [`The prompt to confirm went unanswered`](#the-prompt-to-confirm-went-unanswered)는 할당량 도달 여부와 관계없이 사용량 크레딧 동의 프롬프트가 응답 없이 닫혔음을 의미합니다.

### You've hit your session limit

구독 플랜에는 롤링 방식의 사용 허용량이 포함되어 있습니다. 허용량이 소진되면 다음 메시지 중 하나가 표시됩니다.

```text theme={null}
You've hit your session limit · resets 3:45pm
You've hit your weekly limit · resets Mon 12:00am
You've hit your Opus limit · resets 3:45pm
You've hit your Sonnet limit · resets 3:45pm
```

Claude Code는 메시지에 표시된 재설정 시간까지 추가 요청을 차단합니다. 세션 한도와 주간 한도는 모든 모델에서 공유되므로 모델을 전환해도 접근이 복원되지 않습니다. Opus 한도와 Sonnet 한도는 각각 해당 모델 계열에 대한 요청에만 적용되므로, `/model`로 해당 계열 외의 모델로 전환하면 작업을 계속할 수 있습니다.

claude.ai 구독으로 로그인한 대화형 세션에서는 Claude Code가 열려 있는 세션에서 대기하다가 재설정 직후 중단된 작업을 이어서 진행할 수도 있습니다. 표시되는 내용, 대기를 시작하거나 취소하는 방법, 자동 계속을 끄는 방법은 [사용 한도 재설정 대기](https://code.claude.com/docs/ko/interactive-mode.md#wait-for-a-usage-limit-to-reset)를 참조하세요. v2.1.234 이전에는 Claude Code가 이 대기 기능을 제공하지 않았습니다.

사용량은 세션 허용량과 주간 허용량에 동시에 집계됩니다. 대규모 워크플로 팬아웃과 같은 한 번의 집중적인 활동만으로도 세션 윈도우가 재설정되기 전에 주간 허용량이 소진될 수 있습니다.

**해결 방법:**

* 오류에 표시된 재설정 시간까지 기다립니다
* [Desktop 앱](https://code.claude.com/docs/ko/desktop.md)의 Code 탭에서는 세션 한도 카드에 **Auto-continue when limits reset** 체크박스가 제공됩니다. 주간 한도 카드에는 제공되지 않습니다. 이 옵션을 선택하면 Desktop 앱이 재설정 후 중단된 턴을 재시도하고 카드에 재시도 시간을 표시합니다. Desktop 체크박스와 CLI의 `/config`에 있는 **Continue automatically at usage limit** 설정은 별개이므로 각각 따로 꺼야 합니다.
* Opus 또는 Sonnet 한도의 경우 `/model`을 실행하고 해당 계열 외의 모델로 전환하여 작업을 계속합니다. 각 모델에는 자체 프롬프트 캐시가 있으므로 다음 요청은 캐시 적중 없이 전체 대화를 다시 읽습니다. [모델 전환](https://code.claude.com/docs/ko/prompt-caching.md#switching-models)을 참조하세요
* `/usage`를 실행하여 플랜 한도와 재설정 시간을 확인합니다
* `/usage-credits`를 실행하여 Pro, Max 및 Ultra에서는 추가 사용량을 구매하거나, Team 및 Enterprise에서는 관리자에게 요청합니다. 청구 방식은 [유료 플랜의 사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)을 참조하세요.
* 더 높은 기본 한도를 위해 플랜을 업그레이드하려면 [claude.com/pricing](https://claude.com/pricing)을 참조하세요

윈도우가 소진되기 전에 Claude Code는 `You've used 85% of your session limit · resets 3:45pm`과 같은 메시지로 대부분을 사용했다고 경고할 수 있습니다. 남은 허용량을 지속적으로 확인하려면 [사용자 지정 상태줄](https://code.claude.com/docs/ko/statusline.md#rate-limit-usage)에 `rate_limits` 필드를 추가하거나, Desktop 앱에서 모델 선택기 옆의 [사용량 링](https://code.claude.com/docs/ko/desktop.md#check-usage)을 클릭하세요.

### Usage credits required for 1M context

선택한 모델이 100만 토큰 확장 컨텍스트 윈도우를 사용하는데, 사용자의 플랜에서는 사용량 크레딧을 통해서만 이를 제공합니다.

```text theme={null}
API Error: Usage credits required for 1M context · run /usage-credits to turn them on (they take effect after you restart Claude Code), or /model to switch to standard context
```

Claude Desktop 앱이 실행하는 세션에서는 안내 문구에 명령이 표시되지 않습니다. 대신 claude.ai 사용량 설정 페이지를 안내하거나, Team 및 Enterprise 플랜에서는 claude.ai/admin-settings/usage에서 사용량 크레딧을 켜거나 관리자에게 요청하라고 안내합니다.

이는 할당량 소진이 아닌 사용 자격 확인입니다. 세션 허용량과 주간 허용량이 남아 있어도 발생합니다. 어떤 플랜이 100만 컨텍스트를 직접 포함하고 어떤 플랜이 사용량 크레딧을 필요로 하는지는 [확장 컨텍스트](https://code.claude.com/docs/ko/model-config.md#extended-context)를 참조하세요.

컨텍스트가 20만 토큰을 넘어서 대화 도중 이 오류가 나타나면, Claude Code가 자동으로 대화를 압축하여 표준 컨텍스트 한도 아래로 되돌리고 이후 세션을 해당 한도로 유지하므로 별도의 조치가 필요하지 않습니다. v2.1.172 이전 버전에서는 `/compact`를 포함한 모든 후속 요청에서 오류가 반복되었으므로, 해당 버전에서는 `/clear`를 실행하여 복구합니다. 아래 단계는 `[1m]` 모델을 명시적으로 선택한 경우에 적용됩니다.

**해결 방법:**

* `/model`을 실행하고 `[1m]` 접미사가 없는 변형을 선택하여 표준 컨텍스트 윈도우로 되돌립니다
* 메시지에 `/usage-credits`가 표시된 경우, 이를 실행하여 Pro, Max 및 Ultra에서는 100만 변형에 대한 종량제 청구를 켜거나, Team 및 Enterprise에서는 관리자에게 사용량 크레딧을 요청합니다. 사용량 크레딧이 켜지면 메시지에 안내된 대로 Claude Code를 다시 시작하거나 새 세션을 시작합니다. 그전까지는 세션이 표준 컨텍스트 한도로 유지됩니다.
* `/model` 이후에도 오류가 계속되면 100만 모델 ID가 다른 곳에 설정되어 있을 수 있습니다. 우선순위 순서대로 확인할 구성 위치는 [모델 설정](https://code.claude.com/docs/ko/model-config.md#setting-your-model)을 참조하세요.
* 모델 선택기에서 100만 변형을 완전히 제거하려면 [`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](https://code.claude.com/docs/ko/env-vars)을 설정합니다

v2.1.268 이전에는 메시지가 `run /usage-credits to turn them on, or /model to switch to standard context`로 끝났으며 다시 시작에 대한 언급이 없었습니다.

### The prompt to confirm went unanswered

[Fable 사용량 크레딧 동의 프롬프트](https://code.claude.com/docs/ko/model-config.md#fable-and-usage-credits)가 아무도 응답하지 않은 채 닫히면 Claude Code는 다음 메시지 중 하나와 함께 턴을 종료합니다.

```text theme={null}
Fable limit reached · continuing on Fable 5.1 uses usage credits, and the prompt to confirm went unanswered — nothing was sent · answer it where this session is running, or /model to change
Fable 5.1 now uses usage credits · the prompt to confirm went unanswered — nothing was sent · answer it where this session is running, or /model to change
```

메시지에는 세션의 Fable 모델 이름이 표시되므로, Fable 5에서는 `continuing on Fable 5` 및 `Fable 5 now uses usage credits`로 표시됩니다. v2.1.257 이전에는 첫 번째 메시지가 `Fable 5 limit reached`로 시작했습니다.

이는 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션, [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md), [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 팀원 세션, 그리고 다른 애플리케이션이 Agent SDK를 통해 호스팅하는 세션에서 발생합니다. Claude Code가 프롬프트를 닫는 시점은 [Fable 및 사용량 크레딧](https://code.claude.com/docs/ko/model-config.md#fable-and-usage-credits)을 참조하세요.

**해결 방법:**

* 세션이 실행되는 곳, 즉 터미널이나 세션을 호스팅하는 애플리케이션에서 다른 프롬프트를 보내고 동의 프롬프트가 다시 나타나면 응답합니다. 백그라운드 세션의 경우 먼저 [에이전트 보기](https://code.claude.com/docs/ko/agent-view.md)에서 세션에 연결합니다. Remote Control 클라이언트에서 다시 보내면 클라이언트가 프롬프트를 표시할 수 없으므로 이 메시지가 다시 표시됩니다.
* `/model`을 실행하여 사용량 크레딧으로 청구되지 않는 모델로 전환합니다
* 응답할 시간을 더 확보하려면 [`dialogExpiry`](https://code.claude.com/docs/ko/settings-reference#dialogexpiry)를 더 긴 값이나 `"never"`로 설정합니다

v2.1.236 이전에는 이 메시지가 나타나지 않았습니다. Remote Control 클라이언트가 연결되어 있는 동안 Claude Code는 응답을 60초간 기다린 후 기본 모델로 턴을 계속 진행했습니다.

### Server is temporarily limiting requests

API가 플랜 할당량과 무관한 단기 제한을 적용했습니다.

```text theme={null}
API Error: Server is temporarily limiting requests (not your usage limit)
```

Claude Code는 실제 한도 응답에 포함되는 통합 할당량 헤더가 없는지를 기준으로 이를 플랜 한도와 구분합니다. v2.1.199부터는 인증 방식과 관계없이 표시되기 전에 백오프와 함께 [자동으로 재시도](#automatic-retries)됩니다. 이전 버전에서는 claude.ai 구독으로 로그인한 세션이 첫 발생 시 턴을 실패 처리했으며, API 키 및 Enterprise 로그인만 재시도했습니다.

**해결 방법:**

* 잠시 기다린 후 다시 시도합니다
* 문제가 지속되면 [status.claude.com](https://status.claude.com)을 확인합니다

### Request rejected (429)

API 키, Amazon Bedrock 프로젝트 또는 Google Cloud 프로젝트에 구성된 속도 제한에 도달했습니다.

```text theme={null}
API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check https://status.claude.com.
```

마지막 문장은 서비스 상태를 확인할 위치를 안내하며 제공업체에 따라 다릅니다. Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 구성에서는 Anthropic 상태 페이지 대신 해당 제공업체의 서비스 상태를 안내합니다. 사용자 지정 `ANTHROPIC_BASE_URL`을 사용하면 게이트웨이 호스트를 안내합니다.

Claude Code와 API 사이의 프록시, 로드 밸런서 또는 게이트웨이가 자체 HTML 429 페이지로 응답하면, `·` 뒤의 텍스트는 해당 페이지에 제목이 있는 경우 `Too Many Requests`와 같은 페이지 제목이 됩니다. v2.1.281 이전에는 페이지 전체 마크업이 `·` 뒤에 출력되었습니다.

**해결 방법:**

* `/status`를 실행하여 활성 자격 증명이 예상한 것인지 확인합니다. 환경에 남아 있는 `ANTHROPIC_API_KEY`로 인해 요청이 구독 대신 낮은 티어의 키를 통해 라우팅될 수 있습니다.
* 제공업체 콘솔에서 활성 한도를 확인하고 필요한 경우 더 높은 티어를 요청합니다
* Anthropic API 키의 경우 티어의 작동 방식과 워크스페이스별 상한을 설정하는 방법은 [속도 제한 참조](https://platform.claude.com/docs/en/api/rate-limits)를 확인하세요
* 동시성을 줄입니다. 여러 서브에이전트를 병렬로 실행하지 않거나, 대량 스크립트 실행 시 `/model`로 더 작은 모델로 전환합니다

### You've hit your monthly spend limit

플랜에 포함된 사용량으로는 이 요청을 처리할 수 없으며, 그 대신 비용을 지불할 [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)도 지출 한도에 도달했습니다. 이는 플랜의 사용량 윈도우 중 하나가 소진되었거나, [사용량 크레딧으로 청구되는](https://code.claude.com/docs/ko/model-config.md#fable-and-usage-credits) 모델에 대한 요청처럼 사용량 크레딧으로만 지불되는 요청인 경우에 발생합니다. 메시지에는 누구의 한도로 인해 차단되었는지가 표시됩니다. `·` 뒤의 텍스트는 해당 한도를 늘리는 방법을 안내하며, 플랜과 청구 관리 여부에 따라 다릅니다.

```text theme={null}
You've hit your monthly spend limit · raise it at https://claude.ai/settings/usage?from=cc_cli_limit_message
You've hit your individual spend limit · ask your admin for a higher limit
You've hit your org's monthly spend limit · visit https://claude.ai/admin-settings/usage to raise it
You've hit your team's shared budget · ask your admin to raise it at https://claude.ai/admin-settings/usage
You've hit your channel's monthly spend limit · an org owner or channel manager can raise it in the channel's Claude settings
```

`team's shared budget`는 관리자가 사용자가 속한 그룹에 할당한 공유 예산이며, 메시지에는 그룹 이름이 표시되지 않습니다. `channel's monthly spend limit`는 세션이 실행되는 단일 Slack 채널의 예산이므로, 조직에는 그 외의 예산이 남아 있을 수 있습니다.

플랜의 윈도우 중 하나가 소진된 경우, 메시지에는 `· your session limit resets 3:45pm`과 같이 해당 윈도우의 재설정 시간도 표시되며, 누군가 한도를 늘리지 않아도 그때 접근이 복원됩니다. 사용량 기반 청구를 사용하는 조직에서는 메시지에 `spend limit` 대신 `usage limit`가 표시되며, `You've hit your individual usage limit`와 같이 나타납니다.

Claude 앱 게이트웨이를 통해 연결하고 있으며 소문자 `spend limit reached`가 표시된다면, 이는 게이트웨이 운영자가 설정한 상한입니다. [Spend limit reached](#spend-limit-reached)를 참조하세요.

**해결 방법:**

* Pro, Max 및 Ultra에서는 claude.ai의 [**Settings > Usage**](https://claude.ai/settings/usage)에서 월간 지출 한도를 늘리거나 `/usage-credits`를 실행합니다
* Team 및 Enterprise에서는 청구를 관리하는 경우 [**Organization settings > Usage**](https://claude.ai/admin-settings/usage)에서 한도를 늘리거나 관리자에게 요청합니다. `/usage-credits`를 실행하면 해당 요청이 관리자에게 전송됩니다
* 채널 한도의 경우 조직 소유자나 채널 관리자에게 claude.ai에서 한도를 늘려 달라고 요청합니다. Claude Tag 문서의 [채널별 한도](https://claude.com/docs/claude-tag/admins/set-spend-limit#per-channel-limits)를 참조하세요
* 메시지에 플랜 윈도우의 재설정 시간이 표시된 경우 그때까지 기다릴 수도 있습니다
* `/usage`를 실행하여 플랜의 윈도우와 각 윈도우의 재설정 시간을 확인합니다

### Spend limit reached

[Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)를 통해 연결하고 있으며 게이트웨이 운영자가 설정한 [지출 상한](https://code.claude.com/docs/ko/claude-apps-gateway-spend-limits.md)을 초과했습니다. 게이트웨이는 명시된 기간이 재설정되거나 운영자가 상한을 올릴 때까지 요청을 차단합니다. 차단된 각 `429` 응답에는 `x-should-retry: false`가 표시되므로, Claude Code는 재시도하지 않고 이 메시지를 표시합니다.

```text theme={null}
spend limit reached (daily; resets 2026-08-09 00:00 UTC)
```

메시지에는 상한의 기간과 재설정 시간이 표시되며, 운영자가 `blocked_message`를 구성한 경우 그 뒤에 운영자의 안내가 이어집니다. v2.1.225 이전에는 메시지가 `spend limit reached`로만 표시되었으며, 이전 버전의 게이트웨이는 여전히 이 짧은 형식을 보냅니다.

**해결 방법:**

* 메시지에 표시된 재설정 시간까지 기다리거나, 메시지에 운영자의 안내가 포함되어 있으면 그 안내를 따릅니다
* 상한에 자주 도달한다면 게이트웨이 운영자에게 상한을 올려 달라고 요청합니다

관련 메시지인 `spend limit unavailable`은 게이트웨이가 지출 기록을 읽을 수 없어 상한 초과가 아닌 예방 차원에서 요청을 차단했음을 의미합니다. 보통 저절로 해소되며, 지속되면 게이트웨이 운영자에게 알리세요.

### Credit balance is too low

Console 조직의 선불 크레딧이 소진되었거나, 구독을 사용하려 했는데 Claude Code가 Console API 키로 요청을 보내고 있습니다.

```text theme={null}
Credit balance is too low
```

**해결 방법:**

* Pro, Max, Ultra, Team 또는 Enterprise 플랜을 사용 중인데 이 메시지가 표시되면 `/status`를 실행하고 `API key` 행을 확인합니다. 환경에 승인된 `ANTHROPIC_API_KEY`가 있으면 요청이 구독 대신 해당 키를 통해 라우팅됩니다. 현재 셸에서 이를 해제하고 셸 프로필에서 제거한 다음 `claude`를 다시 실행합니다. 아직 구독으로 로그인하지 않았다면 `/login`을 실행합니다.
* [platform.claude.com/settings/billing](https://platform.claude.com/settings/billing)에서 크레딧을 추가하고, 잔액이 0이 되기 전에 충전되도록 해당 페이지에서 자동 충전을 활성화하는 것을 고려합니다
* 단일 프로젝트가 조직 잔액을 모두 소진하지 않도록 Console에서 워크스페이스별 지출 상한을 설정합니다. [효과적인 비용 관리](https://code.claude.com/docs/ko/costs.md)를 참조하세요.

### Could not update your spend limit

지출 한도에 도달했을 때 나타나는 프롬프트에서 변경한 지출 한도를 서버가 거부했습니다.

```text theme={null}
Could not update your spend limit: <reason from the server>
```

서버가 거부 사유를 설명하면 메시지가 해당 사유로 끝나며, 같은 값으로 재시도하면 다시 실패합니다. 연결 끊김처럼 서버가 제공한 사유가 없는 실패의 경우 메시지는 `Could not update your spend limit. Press Enter to retry.`로 표시되며, 재시도하면 성공할 수 있습니다. v2.1.216 이전에는 Claude Code가 모든 실패에 대해 일반 형식을 표시했습니다.

**해결 방법:**

* 메시지에 사유가 포함되어 있으면 더 낮은 금액처럼 사유를 충족하는 한도를 선택합니다
* 메시지가 일반 형식만 표시하면 재시도합니다. 일시적인 실패일 수 있습니다
* 변경이 계속 실패하면 대신 브라우저에서 [claude.ai 청구 설정](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)을 통해 변경합니다

## 인증 오류

이 오류는 Claude Code가 API에 사용자의 신원을 증명할 수 없다는 뜻입니다. 언제든지 `/status`를 실행하면 현재 활성화된 자격 증명을 확인할 수 있습니다.

### 로그인되지 않음

이 세션에 사용할 수 있는 유효한 자격 증명이 없습니다.

```text theme={null}
Not logged in · Please run /login
```

Code 탭이나 Cowork처럼 Claude Desktop 앱이 실행하는 세션에서는 메시지가 `Authentication required · Sign in again to continue`로 표시되며, 앱에서 다시 로그인합니다.

같은 [구성 디렉터리](https://code.claude.com/docs/ko/claude-directory.md)를 사용하는 다른 Claude Code 창에서 claude.ai 계정으로 로그인하면, 이 메시지를 표시하던 대화형 세션이 자동으로 해당 로그인을 사용하기 시작합니다. 세션을 다시 시작할 필요가 없습니다.

macOS에서 v2.1.286 이전에는 다른 창에서 로그인한 후에도 세션이 계속 이 메시지를 표시할 수 있었습니다. 해당 버전에서는 메시지를 표시하는 세션을 다시 시작하십시오.

**해결 방법:**

* `/login`을 실행하여 Claude 구독 또는 Console 계정으로 인증합니다
* 환경 변수로 인증될 것으로 예상했다면, `claude`를 실행한 셸에서 `ANTHROPIC_API_KEY`가 설정되고 export되었는지 확인합니다
* 대화형 로그인이 불가능한 CI 또는 자동화 환경에서는 시작 시 키를 가져오는 [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper) 스크립트를 구성합니다
* 여러 자격 증명이 있을 때 Claude Code가 어떤 자격 증명을 사용하는지 알아보려면 [인증 우선순위](https://code.claude.com/docs/ko/authentication.md#authentication-precedence)를 참조하십시오

로그인을 반복적으로 요청받는 경우, 시스템 시계 확인 방법과 macOS 자격 증명 저장소 복구 단계는 [로그인되지 않음 또는 토큰 만료](https://code.claude.com/docs/ko/troubleshoot-install.md#not-logged-in-or-token-expired)를 참조하십시오.

### 인증 방법을 확인할 수 없음

세션이 자격 증명 없이 API 클라이언트에 도달했습니다. [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)과 클라우드 세션은 워커가 자격 증명 없이 시작될 때 이 메시지를 표시합니다. 대화형, `-p`, Agent SDK 실행에서는 같은 상황을 [로그인되지 않음](#not-logged-in)으로 보고하고 이 문자열은 디버그 로그에만 기록하므로, 디버그 로그에서 이 문자열을 발견했다면 해당 항목을 따르십시오.

```text theme={null}
Could not resolve authentication method. Expected one of apiKey, authToken, credentials, config, or profile to be set. Or for one of the "X-Api-Key" or "Authorization" headers to be explicitly omitted
```

현재 버전에서 이 오류는 워커 프로세스에 사용할 수 있는 자격 증명이 없었다는 뜻입니다. v2.1.174 이전에는 유휴 상태의 사전 초기화된 워커에 할당된 백그라운드 세션이 유효한 자격 증명이 구성되어 있어도 이렇게 실패할 수 있었습니다. v2.1.176 이전에는 할당되기 전에 유휴 상태로 있던 클라우드 세션도 마찬가지였습니다. 업그레이드하면 복구됩니다.

**해결 방법:**

* 백그라운드 또는 클라우드 세션에서 이 오류가 나타나고 자격 증명이 이미 구성되어 있다면 v2.1.176 이상으로 업그레이드합니다
* `ANTHROPIC_API_KEY`, `CLAUDE_CODE_OAUTH_TOKEN` 또는 클라우드 공급자 자격 증명이 대화형 셸뿐 아니라 워커를 실행하는 환경에도 설정되어 있는지 확인합니다
* Agent SDK의 경우 [빠른 시작의 인증 설정](https://code.claude.com/docs/ko/agent-sdk/quickstart.md#setup)을 참조하십시오
* 같은 환경의 대화형 세션에서 `/status`를 실행하여 어떤 자격 증명 소스가 확인되는지 확인합니다

### 유효하지 않은 API 키

`ANTHROPIC_API_KEY` 환경 변수 또는 `apiKeyHelper` 스크립트가 API에서 거부한 키를 반환했거나, Claude Code가 `ANTHROPIC_API_KEY`의 키를 전송하기 전에 차단했습니다.

```text theme={null}
Invalid API key · Fix external API key
```

메시지가 `Fix external API key` 뒤에 `Invalid X-Api-Key header value from ANTHROPIC_API_KEY: it contains a line break at character 41 (120 characters on 2 lines).`와 같은 설명으로 이어진다면, API는 키를 받지 못한 것입니다. Claude Code가 HTTP 헤더에 담을 수 없는 문자를 발견하고 요청을 전송하기 전에 중단했습니다. 설명을 읽는 방법과 값을 수정하는 방법은 [유효하지 않은 요청 헤더 값](#invalid-request-header-value)을 참조하십시오.

**해결 방법:**

* 오타가 있는지 확인하고, [Console](https://platform.claude.com/settings/keys)에서 키가 폐기되지 않았는지 확인합니다
* 같은 셸에서 `env | grep ANTHROPIC`을 실행하거나, PowerShell에서는 `Get-ChildItem Env:ANTHROPIC*`를 실행합니다. direnv, dotenv 셸 플러그인, IDE 터미널 같은 도구는 사용자가 명시적으로 설정하지 않아도 프로젝트의 `.env` 파일에서 오래된 키를 불러올 수 있습니다.
* `ANTHROPIC_API_KEY`를 해제하고 `/login`을 실행하여 대신 구독 인증을 사용합니다
* 키가 [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper) 스크립트에서 오는 경우, 스크립트를 직접 실행하여 stdout에 유효한 키를 출력하는지 확인합니다
* `/status`를 실행하여 Claude Code가 실제로 사용하는 자격 증명 소스를 확인합니다

### apiKeyHelper 스크립트가 실패함

Claude Code가 [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper) 설정의 명령을 실행했지만 키를 받지 못했습니다. 키가 없으면 요청이 자리표시자 자격 증명으로 API에 도달하고, API는 `401`로 이를 거부합니다. 터미널의 `Authentication` 패널에 다음 중 어떤 경우가 발생했는지 표시됩니다.

* 명령이 오류와 함께 종료되었거나 시간 초과되었습니다
* 명령이 stdout에 아무것도 출력하지 않았습니다
* 명령이 로그인 배너나 로그 줄처럼 키 이외의 내용을 출력했습니다. 패널에는 `returned output that cannot be used as an API key`가 표시되고, 출력 내용을 반복하지 않고 무엇이 잘못되었는지 알려줍니다. v2.1.227 이전에는 Claude Code가 앞뒤 공백을 제거한 후 명령이 출력한 내용을 그대로 전송했습니다.

```text theme={null}
Your apiKeyHelper script is failing · This usually means you need to re-authenticate with your provider · Run /status to see the script's error output
```

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 stderr에도 `apiKeyHelper failed:` 접두사와 함께 구체적인 이유가 출력됩니다.

Claude Code는 이 메시지를 표시하기 전에 스크립트를 다시 실행하고 요청을 최대 두 번 더 재시도하므로, 실패는 세 번의 시도 안에 드러납니다. v2.1.208 이전에는 Claude Code가 [재시도 한도](#automatic-retries) 전체를 자리표시자 자격 증명으로 요청을 다시 보내는 데 소모한 후, 스크립트 실패 대신 일반적인 `401` 인증 오류를 보고했습니다.

이 경우 `/login`을 실행해도 도움이 되지 않습니다. 설정이 있는 한 헬퍼의 출력이 저장된 로그인보다 [우선합니다](https://code.claude.com/docs/ko/authentication.md#authentication-precedence).

**해결 방법:**

* `apiKeyHelper`에 구성된 명령을 셸에서 직접 실행하여 실패를 재현합니다
* 명령이 만료된 세션을 보고하면, 예를 들어 SSO나 시크릿 볼트에 다시 로그인하는 방식으로 자격 증명 공급자에서 다시 인증합니다
* 명령이 최대 16,384자의 출력 가능한 ASCII로 이루어진 단일 토큰 형태로 키만 stdout에 출력하고 종료 코드 0으로 종료되도록 수정합니다. 동작하는 설정 예시는 [apiKeyHelper로 자격 증명 교체](https://code.claude.com/docs/ko/llm-gateway-connect.md#rotate-credentials-with-apikeyhelper)를 참조하십시오.
* `/status`를 실행하여 실패 내용을 확인하고 `apiKeyHelper`가 활성 자격 증명 소스인지 확인합니다. `apiKeyHelper` 행에는 `Failing`과 함께 종료 코드 및 명령의 오류 출력 같은 마지막 실패의 세부 정보가 표시되며, 다음 실행이 성공하면 사라집니다. v2.1.274 이전에는 `/status`가 실패 내용 없이 자격 증명 소스만 표시했습니다.
* 명령이 실패할 때마다 종료 코드와 오류 출력이 터미널의 `Authentication` 패널에도 표시됩니다. v2.1.212 이전에는 패널 제목이 `Cloud authentication`이었습니다.

### 유효하지 않은 요청 헤더 값

Claude Code가 요청 헤더로 보내려던 값에 HTTP 헤더에 담을 수 없는 문자, 즉 줄바꿈, NUL 바이트, 또는 둥근 따옴표나 폭 없는 공백처럼 `U+00FF`보다 큰 문자가 포함되어 있습니다. Claude Code는 아무것도 전송하기 전에 요청을 중단하고 수정해야 할 변수나 설정의 이름을 알려줍니다. 보통 문서나 채팅에서 붙여 넣은 자격 증명에 보이지 않는 문자나 불필요한 줄바꿈이 들어간 것이 원인입니다.

Claude Code는 Claude API에 직접 또는 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 통해 요청을 보낼 때 이 검사를 실행합니다. [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md) 같은 타사 클라우드 공급자에서는 전송 전에 이 검사를 실행하지 않습니다.

```text theme={null}
Invalid auth token · Fix external auth token
Invalid ANTHROPIC_CUSTOM_HEADERS · Fix the environment variable
Invalid request header from the environment · Fix the environment variable
```

메시지의 첫 부분은 잘못된 값이 어디에서 왔는지에 따라 달라집니다.

* `Invalid auth token`: [`ANTHROPIC_AUTH_TOKEN`](https://code.claude.com/docs/ko/env-vars) 또는 [`CLAUDE_CODE_OAUTH_TOKEN`](https://code.claude.com/docs/ko/env-vars)의 bearer 토큰
* `Invalid ANTHROPIC_CUSTOM_HEADERS`: [`ANTHROPIC_CUSTOM_HEADERS`](https://code.claude.com/docs/ko/env-vars)에 설정한 헤더 이름 또는 값. 설명에는 `distinct header 2 of 3 parsed from ANTHROPIC_CUSTOM_HEADERS`처럼 몇 번째 `Name: Value` 쌍이 문제인지 표시되며, 이름과 값은 사용자가 직접 정한 것이므로 반복하지 않습니다.
* `Invalid request header from the environment`: Claude Code가 `CLAUDE_AGENT_SDK_CLIENT_APP` 같은 다른 환경 변수에서 요청 헤더로 복사하는 값. 설명에 수정해야 할 변수 이름이 표시됩니다.

이 검사에서 발견된 잘못된 `ANTHROPIC_API_KEY`는 같은 후행 설명과 함께 [유효하지 않은 API 키](#invalid-api-key)로 보고됩니다. 잘못된 저장된 `/login` 자격 증명은 대신 [로그인되지 않음](#not-logged-in)으로 보고되며, `/login`을 실행하여 새 자격 증명을 저장하면 됩니다. [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper) 스크립트의 출력은 이 검사에 도달하지 않습니다. Claude Code는 스크립트가 실행될 때 출력을 검증하며, HTTP 헤더에 담을 수 없는 출력은 [apiKeyHelper 스크립트가 실패함](#your-apikeyhelper-script-is-failing)으로 실패합니다.

두 번째 `·` 뒤에서 메시지는 다음 전체 예시처럼 문제를 설명합니다.

```text theme={null}
Invalid auth token · Fix external auth token · Invalid Authorization header value from ANTHROPIC_AUTH_TOKEN: it contains a line break at character 41 (120 characters on 2 lines).
```

위치는 1부터 시작하여 문자 단위로 셉니다. 설명은 고정된 문구와 문자 수로 구성되므로 값 자체는 절대 포함되지 않습니다. 문제가 되는 문자가 바이트 순서 표시, 폭 없는 공백, 둥근 따옴표처럼 잘 알려진 보이지 않는 문자나 인쇄용 문자일 때만 해당 문자의 이름을 표시하고, 그 밖의 문자는 `a non-ASCII character`로 보고합니다.

**해결 방법:**

* 메시지에 표시된 변수나 설정을 다시 설정하되, 같은 소스에서 다시 붙여 넣지 말고 보고된 위치 주변의 문자를 직접 다시 입력합니다
* `ANTHROPIC_CUSTOM_HEADERS`의 경우 한 줄에 `Name: Value` 쌍 하나씩 유지하고, 메시지가 가리키는 쌍을 다시 작성합니다
* `/status`를 실행하여 활성 자격 증명 소스를 확인합니다

### 이 조직이 비활성화됨

Claude Code가 비활성화된 Console 조직의 오래된 `ANTHROPIC_API_KEY`를 사용하고 있습니다. 저장된 구독 로그인이 있어도 키가 이를 재정의합니다.

```text theme={null}
Your ANTHROPIC_API_KEY belongs to a disabled organization · Unset the environment variable to use your subscription instead
Your ANTHROPIC_API_KEY belongs to a disabled organization · Update or unset the environment variable
API Error: 400 ... This organization has been disabled.
```

`·` 뒤의 안내는 저장된 자격 증명에 따라 달라집니다. 첫 번째 형태는 키를 해제한 후 저장된 `/login`이 대신 사용될 수 있을 때 표시되고, 두 번째 형태는 키가 유일한 자격 증명일 때 표시됩니다.

셸 프로필에서 키를 export하거나 `.env`에서 키를 불러오면, Pro, Max 또는 Ultra 구독이 정상적으로 작동하더라도 Claude Code는 `/login` 대신 그 키를 사용합니다. 비대화형 모드(`-p`)에서는 키가 있으면 항상 키를 사용합니다.

**해결 방법:**

* 현재 셸에서 `ANTHROPIC_API_KEY`를 해제하고 셸 프로필에서 제거한 다음 `claude`를 다시 실행합니다
* 메시지에 `Update or unset`이 표시되면 대신 사용할 저장된 로그인이 없는 것입니다. 키를 해제하고 `/login`을 실행하거나, 활성 Console 조직의 키로 교체합니다.
* 이후 `/status`를 실행하여 활성 자격 증명이 구독인지 확인합니다
* 환경 변수가 설정되어 있지 않은데도 오류가 계속되면 지원팀에 문의하거나 다른 계정으로 로그인합니다.

### 조직에서 API 키 인증을 비활성화함

이 메시지는 Claude Code v2.1.169 이상이 필요합니다. Console 조직의 관리자가 API 키 인증을 꺼 두었기 때문에 API가 Claude Code가 보내는 키를 거부합니다. `·` 뒤의 복구 안내는 키를 가져온 위치에 따라 달라집니다.

```text theme={null}
Your organization has disabled API key authentication · Run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY to use your claude.ai account instead
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY and run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset the apiKeyHelper setting and run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Sign in again with your claude.ai account
```

마지막 형태는 Code 탭이나 Cowork처럼 Claude Desktop 앱이 실행하는 세션에서 표시되며, 이 경우 앱에서 다시 로그인합니다.

환경 변수와 `apiKeyHelper`는 `/login`보다 우선하므로, 둘 중 하나가 계속 키를 제공하는 동안에는 `/login`만 실행해서는 해결되지 않습니다. [인증 우선순위](https://code.claude.com/docs/ko/authentication.md#authentication-precedence)를 참조하십시오.

**해결 방법:**

* 메시지에 `ANTHROPIC_API_KEY`가 표시되면 현재 셸에서 해제하고 셸 프로필이나 `.env` 파일에서 제거한 다음 `claude`를 다시 실행합니다
* 메시지에 `apiKeyHelper`가 표시되면 `settings.json`에서 [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper) 설정을 제거합니다
* `/login`을 실행하여 claude.ai 계정으로 로그인합니다
* 이후 `/status`를 실행하여 활성 자격 증명이 API 키가 아닌 구독인지 확인합니다
* 자동화에 API 키 인증이 필요하다면 조직 관리자에게 Console에서 다시 활성화해 달라고 요청합니다

### 조직에서 Claude 구독 액세스를 비활성화함

Claude 조직에서 구독 로그인으로 Claude Code에 로그인하는 것을 허용하지 않습니다. 같은 계정으로 `/login`을 다시 실행해도 같은 오류가 반환됩니다.

```text theme={null}
Your organization has disabled Claude subscription access for Claude Code · Use an Anthropic API key instead, or ask your admin to enable access
```

이는 서버 측 조직 설정이므로 로컬 설정, 환경 변수, CLI 플래그로 재정의할 수 없습니다.

Agent SDK와 `-p` 비대화형 모드에서는 이 오류가 `oauth_org_not_allowed` 오류 코드로 표시됩니다.

**해결 방법:**

* 관리자에게 조직의 Claude Code 액세스를 활성화해 달라고 요청합니다
* 구독 대신 Console API 키로 인증합니다. 설정 방법은 [Claude Console 인증](https://code.claude.com/docs/ko/authentication.md#claude-console-authentication)을 참조하십시오.
* 관리자인데 액세스를 활성화하는 옵션이 보이지 않으면 [Anthropic 지원팀](https://support.claude.com)에 문의합니다

### 조직 정책에 의해 루틴이 비활성화됨

Team 또는 Enterprise 조직의 Owner가 조직 수준에서 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)(이전 명칭: 루틴)을 비활성화했습니다. 이 오류는 예를 들어 [claude.ai/code/routines](https://claude.ai/code/routines)에서 예약 작업을 만들거나 실행하려고 할 때 나타납니다. Claude Code v2.1.227 이상에서는 같은 설정이 CLI의 [`/schedule`도 숨깁니다](https://code.claude.com/docs/ko/routines#troubleshooting).

```text theme={null}
Routines are disabled by your organization's policy.
```

이는 서버 측 설정이므로 로컬 설정, 환경 변수, CLI 플래그로 재정의할 수 없습니다.

**해결 방법:**

* 조직의 Owner에게 [**Organization settings > Capabilities > Remote sessions**](https://claude.ai/admin-settings/capabilities)에서 **Scheduled tasks (Was Routines)** 토글을 켜 달라고 요청합니다

### Remote Control에는 Anthropic API가 필요함

세션이 Anthropic API와 직접 통신하고 있지 않지만, [Remote Control](https://code.claude.com/docs/ko/remote-control.md)은 직접 통신을 필요로 합니다.

```text theme={null}
Remote Control is only available when using Claude via api.anthropic.com. CLAUDE_CODE_USE_BEDROCK is set, so this session is using Amazon Bedrock — unset it (or run in a shell without it) to use Remote Control.
```

두 번째 문장은 세션이 Anthropic API가 아닌 다른 곳으로 라우팅된 원인을 설명합니다. v2.1.219 이전에는 메시지가 첫 번째 문장만으로 구성되었습니다. 원인에 따라 메시지에는 다음이 표시됩니다.

* [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md)의 `CLAUDE_CODE_USE_BEDROCK` 또는 [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md)의 `CLAUDE_CODE_USE_VERTEX` 같은 `CLAUDE_CODE_USE_*` 공급자 변수
* claude.ai로 로그인한 경우에도 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)나 프록시처럼 `api.anthropic.com`이 아닌 호스트를 가리키는 [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars). v2.1.196 이전에는 사용자 지정 기본 URL이 Remote Control을 차단하지 않았습니다
* 설정된 `ANTHROPIC_UNIX_SOCKET`. 이 경우 세션이 `api.anthropic.com`이 아닌 로컬 소켓을 통해 요청을 보냅니다
* `/login`을 통해 이루어진 엔터프라이즈 [클라우드 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 로그인. 이 방식은 Remote Control을 지원하지 않으며 해제할 변수가 없습니다

**해결 방법:**

* `CLAUDE_CODE_USE_BEDROCK`이나 `ANTHROPIC_BASE_URL`처럼 메시지에 표시된 변수를 해제하고 세션을 다시 시작하거나, Anthropic API와 직접 통신하는 세션에서 Remote Control을 시작합니다
* 셸에 변수가 설정되어 있지 않다면, 모든 세션에 환경 변수를 적용하는 [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)의 `env` 키를 확인합니다
* 이 메시지와 다른 Remote Control 시작 메시지는 [Remote Control 문제 해결](https://code.claude.com/docs/ko/remote-control.md#troubleshooting)을 참조하십시오

### Remote Control이 로그인을 갱신하지 못함

Claude Code는 저장된 claude.ai 로그인을 사용하여 얻고 갱신하는 단기 자격 증명으로 실시간 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 연결을 유지합니다. claude.ai가 해당 로그인을 더 이상 받아들이지 않거나 Claude Code에 저장된 로그인이 남아 있지 않으면, Claude Code는 Remote Control을 중지하며 다시 로그인해야 합니다. 두 가지 실패 모두 Claude Code가 아직 연결 중일 때 또는 나중에 자격 증명을 갱신할 때 발생할 수 있습니다.

Claude Code가 로그인 서비스에 저장된 로그인 갱신을 요청했는데 응답을 받지 못하면, Remote Control을 계속 실행하면서 연결의 현재 자격 증명이 아직 유효한 동안 갱신을 다시 시도합니다. Claude Code가 로그인 서비스에 연결할 수 없거나, 요청이 시간 초과되거나, 서비스가 로그인을 거부하지 않은 채 실패하면 갱신에 대한 응답이 없는 것입니다. 해당 자격 증명이 만료될 때까지 로그인 서비스가 여전히 응답하지 않으면, Claude Code는 Remote Control을 중지하고 `OAuth token refresh failed`를 보고합니다.

Claude Code가 Remote Control을 중지하면 경고와 `Remote Control disconnected`로 시작하는 트랜스크립트 줄에 이유를 표시합니다. 로컬 세션은 Remote Control 없이 계속 실행됩니다. 이 섹션에서는 다음 줄을 다룹니다.

```text theme={null}
Remote Control disconnected — Claude.ai login expired — run /login to restore Remote Control
Remote Control disconnected — Claude.ai login expired — run /login, then /remote-control
Remote Control disconnected — Claude.ai login was rejected — run /login, then /remote-control
Remote Control disconnected — OAuth token unavailable — run /login to restore Remote Control
Remote Control disconnected — OAuth token refresh failed — run /login to re-authenticate
Remote Control disconnected — JWT refresh failed: no OAuth token — run /login
Remote Control disconnected — Signed out of Claude — run /login, then /remote-control
```

Claude Code는 메시지 중간에 원인을 표시합니다.

* `Claude.ai login expired` 및 `Claude.ai login was rejected`: 저장된 로그인 토큰이 만료되었거나 폐기되어 claude.ai가 더 이상 받아들이지 않습니다
* `OAuth token unavailable`: 연결의 자격 증명을 갱신해야 할 때 Claude Code에 저장된 로그인 토큰이 없었습니다
* `OAuth token refresh failed`: Claude Code가 다시 연결하는 동안 claude.ai가 저장된 로그인 토큰을 거부했고, 토큰을 갱신해도 새 토큰이 생성되지 않았습니다
* `JWT refresh failed: no OAuth token`: Claude Code가 갱신에 사용할 저장된 로그인 토큰을 찾지 못했습니다
* `Signed out of Claude`: 예를 들어 다른 터미널에서 `/logout`을 실행하여 이 머신에서 로그아웃했기 때문에, Claude Code에 연결을 갱신할 저장된 로그인이 남아 있지 않습니다

**해결 방법:**

* `/login`을 실행하여 다시 로그인합니다
* `/remote-control`을 실행하여 세션을 다시 연결합니다. `run /login to restore Remote Control`로 끝나는 메시지는 이 단계가 필요하지 않습니다. 로그인하면 Claude Code가 자동으로 다시 연결합니다.

v2.1.224 이전에는 `OAuth token refresh failed — run /login to re-authenticate`가 `OAuth token refresh failed — re-authenticate, then re-enable Remote Control`로, `JWT refresh failed: no OAuth token — run /login`이 `no OAuth token available for recovery (code <N>)`로 표시되었습니다. `Claude.ai login expired`, `Claude.ai login was rejected`, `OAuth token unavailable` 메시지는 v2.1.225에서 추가되었습니다.

v2.1.238 이전에는 현재 `Signed out of Claude`로 표시되는 경우를 Claude Code가 `JWT refresh failed: no OAuth token — run /login`으로 보고했으며, 로그인 갱신 요청 하나에 응답이 없으면 즉시 `Claude.ai login expired — run /login to restore Remote Control`과 함께 Remote Control을 중지했습니다.

### Remote Control could not renew this computer's connection

이 경고는 서버가 claude.ai 로그인을 사용하여 연결의 자격 증명이 만료되기 전에 갱신할 수 없을 때 [`claude remote-control`](https://code.claude.com/docs/ko/remote-control#start-a-remote-control-session)을 실행 중인 터미널에 나타납니다. 경고의 마지막 문장은 현재 자격 증명이 얼마나 더 유효한지, 또는 이미 만료되었는지를 알려 줍니다.

```text theme={null}
Remote Control could not renew this computer's connection: claude.ai did not accept the sign-in it uses. Run `claude /login` to sign in again. The connection keeps working for about 26 hours; if it still cannot sign in then, it stops.
```

**해결 방법:**

* 경고에서 `claude /login`을 실행하라고 안내하면, 서버를 실행 중인 컴퓨터에서 다른 터미널을 열고 `claude /login`을 실행한 후 claude.ai 계정으로 로그인합니다
* 연결의 자격 증명이 만료된 후에도 서버가 로그인하지 못하면, `Poll: Authentication failed (401)`이 포함된 오류를 출력하고 중지됩니다. 경고의 두 번째 문장에 안내된 대로 다시 로그인한 후, 서버가 중지된 터미널에서 `claude remote-control`을 다시 실행합니다.

### 로그인된 계정이 변경되어 Remote Control이 중지됨

[Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션 중에 이 머신에서 다른 claude.ai 계정이나 조직으로 로그인하면 Claude Code가 이 줄을 표시합니다. 예를 들어 다른 터미널에서 `/login`을 실행하는 등 Claude Code 세션 외부에서 전환한 경우입니다.

`/login`으로 로그인한 상태에서 시작한 Remote Control 세션은 당시 로그인되어 있던 claude.ai 계정과 조직에 속합니다.

```text theme={null}
Remote Control disconnected — signed-in claude.ai account or organization changed on this machine — run /remote-control to start a session for the current account, or /login to switch back, then /remote-control
```

Claude Code는 claude.ai가 계정이나 조직이 변경되었음을 확인하는 즉시 Remote Control 세션을 중지합니다. 로컬 세션은 Remote Control 없이 계속 실행됩니다.

**해결 방법:**

* `/remote-control`을 실행하여 현재 계정이나 조직으로 새 Remote Control 세션을 시작합니다
* 이전으로 되돌리려면 `/login`을 실행하고 이전 계정이나 조직으로 다시 로그인한 다음 `/remote-control`을 실행합니다.

v2.1.234 이전에는 Claude Code 세션 외부에서 다른 계정이나 조직으로 전환해도 Claude Code가 이를 감지하지 못했습니다. Claude Code는 이후 Remote Control 서버에 대한 요청이 `Remote Control server rejected the request (HTTP 404)`로 실패할 때까지 Remote Control 세션을 연결된 상태로 유지했습니다. 이 실패는 전환 후 몇 시간 뒤에 발생할 수도 있었습니다.

### 세션을 실행하는 앱이 로그아웃하거나 계정을 전환하여 Remote Control이 중지됨

Claude 데스크톱 앱이나 IDE가 세션을 호스팅하는 경우, Claude Code는 `/login`이 아닌 해당 앱에서 로그인 토큰을 받습니다. claude.ai가 그 토큰을 거부하면 Claude Code는 앱에 새 토큰을 요청합니다. 앱이 로그아웃되어 있거나 이제 다른 Claude 계정으로 로그인되어 있다고 응답하면, Claude Code는 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션을 종료하고 앱에 다음 줄 중 하나를 보냅니다.

```text theme={null}
Remote Control stopped — the app running this session is now signed in to a different Claude account
Remote Control stopped — the app running this session is signed out of Claude. Sign in there, then turn Remote Control back on
```

로컬 세션은 Remote Control 없이 계속 실행됩니다.

**해결 방법:**

* 앱이 로그아웃된 경우 앱에 다시 로그인한 다음, 앱에서 Remote Control을 다시 켭니다
* 앱이 계정을 전환한 경우 Claude Code는 종료된 세션을 새 계정으로 이어갈 수 없습니다. 해당 계정으로 새 Remote Control 세션을 시작합니다.

v2.1.238 이전에는 두 경우 모두 Claude Code가 [Remote Control이 로그인을 갱신하지 못함](#remote-control-couldnt-refresh-your-login)에 나열된 `run /login` 메시지를 앱에 보냈습니다.

### OAuth 토큰이 폐기되었거나 만료됨

저장된 로그인이 더 이상 유효하지 않습니다. 토큰이 폐기되었다는 것은 모든 곳에서 로그아웃했거나 관리자가 액세스를 제거했다는 뜻이고, 토큰이 만료되었다는 것은 세션 도중 자동 갱신이 실패했다는 뜻입니다.

두 메시지 모두 Claude Code가 보낸 요청에 대해 API가 반환한 거부를 보고합니다. 갱신 실패 후 저장된 로그인이 이미 삭제된 경우에는 대신 [로그인 만료](#login-expired)가 표시됩니다. [`CLAUDE_CODE_OAUTH_TOKEN`](https://code.claude.com/docs/ko/env-vars)의 장기 토큰으로 인증하는 경우에도 해당 토큰이 만료되거나 폐기되면 같은 메시지가 표시됩니다.

```text theme={null}
OAuth token revoked · Please run /login
Please run /login · API Error: 401 OAuth token has expired ...
```

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)(`-p`)와 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)에서는 메시지가 다음과 같이 표시되며, 구조화된 오류 코드는 `authentication_failed`입니다.

```text theme={null}
Failed to authenticate: OAuth token revoked. Please log in again or contact your administrator.
Failed to authenticate. API Error: 401 OAuth token has expired ...
```

v2.1.287 이전에는 비대화형 모드와 Agent SDK에서 폐기 메시지가 `Your account does not have access to Claude. Please login again or contact your administrator.`로 표시되었습니다.

**해결 방법:**

* Claude Code 프롬프트에서 `/login`을 실행하여 다시 로그인합니다
* `-p` 명령이나 Agent SDK 프로그램이 저장된 로그인을 사용하는 경우, 같은 환경에서 `claude`를 실행하고 `/login`을 완료한 다음 명령이나 프로그램을 다시 실행합니다. 대화형으로 로그인할 수 없는 자동화의 경우 [`ANTHROPIC_API_KEY`](https://code.claude.com/docs/ko/env-vars)로 인증하거나 [`claude setup-token`으로 장기 토큰을 생성](https://code.claude.com/docs/ko/authentication#generate-a-long-lived-token)합니다.
* `CLAUDE_CODE_OAUTH_TOKEN` 환경 변수로 인증하는 경우, 요청이 401로 실패한 후에도 Claude Code는 저장된 로그인의 토큰으로 전환하지 않고 사용자가 설정한 값을 계속 보냅니다. [`/status`](https://code.claude.com/docs/ko/commands)는 이 자격 증명을 `CLAUDE_CODE_OAUTH_TOKEN`이라고 표시된 `Auth token` 행으로 보여줍니다. [`claude setup-token`](https://code.claude.com/docs/ko/authentication#generate-a-long-lived-token)으로 새 토큰을 생성하고 이를 사용해 다시 시작하거나, 변수를 해제하고 `/login`을 실행합니다. v2.1.225 이전에는 Claude Code가 세션 도중 변수의 값을 저장된 로그인의 단기 액세스 토큰으로 바꿀 수 있었고, 해당 토큰이 만료되면 세션이 다시 401 오류로 실패했습니다.
* 실행할 때마다 로그인을 반복적으로 요청받는 경우, [문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md#not-logged-in-or-token-expired)의 시스템 시계 확인 방법과 macOS 자격 증명 저장소 복구 단계를 참조하십시오
* `403 Forbidden` 및 OAuth 브라우저 문제를 포함한 기타 실패는 [로그인 및 인증](https://code.claude.com/docs/ko/troubleshoot-install.md#login-and-authentication)을 참조하십시오

### API Error: 401 Invalid authentication credentials

API가 자격 증명의 형식은 인식했지만 그 뒤에 있는 계정이나 조직을 거부했습니다. Anthropic은 자격 증명이 최근에 폐기되었거나, 조직이 비활성화되었거나 사용자의 액세스를 제거했거나, 계정 자체가 비활성화되었을 때 이 메시지를 반환하므로, 만료된 토큰은 원인이 아닙니다. 자격 증명은 저장된 로그인이거나 승인된 `ANTHROPIC_API_KEY`일 수 있으며 해결 방법이 다르므로, 먼저 `/status`를 실행하여 어떤 자격 증명이 활성 상태인지 확인하십시오.

```text theme={null}
Please run /login · API Error: 401 Invalid authentication credentials
```

**해결 방법:**

* `/status`에 사용되지 않음으로 표시되지 않은 `API key` 행이 있다면, 승인된 [`ANTHROPIC_API_KEY`](https://code.claude.com/docs/ko/authentication#authentication-precedence)가 활성 자격 증명이며 로그인보다 우선하므로 `/login`으로 대체되지 않습니다. Claude Console에서 키를 교체하거나, `unset ANTHROPIC_API_KEY`(PowerShell에서는 `Remove-Item Env:ANTHROPIC_API_KEY`)를 실행하여 구독으로 전환합니다.
* `/status`에 로그인만 표시된다면 `/login`을 한 번 실행합니다. 자격 증명이 폐기된 경우 새 로그인이 이를 대체합니다.
* 같은 로그인 계정에 대해 같은 메시지가 다시 나타나면 계정이나 조직이 더 이상 활성 상태가 아닙니다. `/status`가 보고하는 계정과 조직을 확인하고, 조직 관리자에게 액세스 복원을 요청합니다.
* [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)이 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 가리키는 경우, `401` 뒤의 텍스트는 Anthropic이 아닌 게이트웨이의 메시지이며 `/login`으로 바뀌지 않습니다. 대신 게이트웨이가 요구하는 자격 증명을 수정합니다.
* 게이트웨이에 필요한 자격 증명을 제공했는데도 모든 요청이 `401`로 실패한다면, Claude Code가 기본적으로 보내는 도구 검색 필드를 게이트웨이가 거부하고 있는지 확인합니다. 확인하려면 [LLM 게이트웨이를 통한 도구 검색](https://code.claude.com/docs/ko/mcp.md#tool-search-through-a-gateway)에 설명된 대로 `ENABLE_TOOL_SEARCH=false`를 설정한 다음 다시 시도합니다. v2.1.304 이전에는 `ENABLE_TOOL_SEARCH`로 켜지 않는 한 게이트웨이 뒤에서 도구 검색이 꺼져 있었습니다.

### 로그인 만료

Claude Code가 저장된 claude.ai 로그인을 갱신하려고 했지만 OAuth 서비스가 저장된 갱신 토큰을 거부했기 때문에, Claude Code가 저장된 자격 증명을 삭제했습니다. 그 이후 각 모델 요청은 API에 도달하기 전에 로컬에서 이 메시지와 함께 중단됩니다. 새 자격 증명은 `/login`으로만 만들 수 있기 때문입니다.

v2.1.206 이전에는 Claude Code가 환경에 남아 있는 자격 증명으로 모델 요청을 그대로 보냈으며, 모든 모델이 로그인 안내 대신 [선택한 모델에 문제가 있음](#theres-an-issue-with-the-selected-model) 또는 401로 실패했습니다.

```text theme={null}
Login expired · Please run /login
```

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)(`-p`)와 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)에서는 메시지가 다음과 같이 표시되며, 구조화된 오류 코드는 `authentication_failed`입니다.

```text theme={null}
Failed to authenticate: OAuth session expired and could not be refreshed
```

`or re-authenticate your Anthropic profile`로 끝나는 `Login expired` 메시지는 [Anthropic profile login expired](#anthropic-profile-login-expired)를 참조합니다.

이는 [OAuth 토큰이 폐기되었거나 만료됨](#oauth-token-revoked-or-expired)과 같은 상태가 아닙니다. 해당 메시지는 API가 반환한 거부를 보고합니다. `Login expired`는 이미 갱신에 실패한 로그인에 대해 Claude Code 자체가 생성하는 메시지이므로 요청을 보내지 않습니다. 로그인이 오래되어서가 아니라 계정 자체가 정지되어 갱신이 실패한 경우, Claude Code는 대신 [계정이 보류 상태임](#your-account-is-on-hold)을 표시합니다.

API 키, [`CLAUDE_CODE_OAUTH_TOKEN`](https://code.claude.com/docs/ko/env-vars) 또는 타사 공급자로 인증된 세션은 저장된 로그인을 사용하지 않으므로 이 메시지가 표시되지 않습니다.

요청이 실패하기 전에 이 상태를 확인할 수 있습니다. [`/status`](https://code.claude.com/docs/ko/commands)에 `Expired — log in again`이라고 표시된 `Login` 행과 함께, 만료된 로그인에 대해 저장된 조직과 이메일이 표시됩니다. 이 행은 저장된 로그인이 활성 자격 증명이고 더 이상 갱신할 수 없을 때만 나타납니다. 다른 방식으로 인증된 세션에서는 만료된 로그인이 저장되어 있더라도 이 행이 표시되지 않습니다. v2.1.210 이전에는 자격 증명이 삭제되어 보고할 내용이 없었기 때문에, 이 상태에서 `/status`가 로그인이 존재했었다는 어떤 표시도 하지 않았습니다.

**해결 방법:**

* `/login`을 실행하여 다시 로그인합니다. 로그인하지 않고 재시도하면 모든 요청에서 같은 메시지가 표시됩니다.
* 다른 Claude Code 창에서 claude.ai 계정으로 로그인하는 경우, 이 세션이 언제 자동으로 해당 로그인을 사용하기 시작하는지는 [로그인되지 않음](#not-logged-in)을 참조하십시오.
* 비대화형 모드에서는 같은 환경에서 `claude`를 실행하고 `/login`을 완료한 다음 명령을 다시 실행합니다. 대화형으로 로그인할 수 없는 자동화의 경우 `ANTHROPIC_API_KEY`로 인증하거나 [`claude setup-token`으로 장기 토큰을 생성](https://code.claude.com/docs/ko/authentication#generate-a-long-lived-token)합니다.
* 로그인이 계속 실패하면 [로그인 및 인증](https://code.claude.com/docs/ko/troubleshoot-install.md#login-and-authentication)을 참조하십시오

### 다른 Claude Code 프로세스가 갱신 중이어서 로그인을 갱신할 수 없음

이 메시지는 로그인이 거부되었다는 뜻이 아닙니다. 저장된 claude.ai 로그인이 만료되어 갱신이 필요했습니다. 같은 머신의 다른 Claude Code 프로세스가 공유 갱신 잠금을 보유하고 있었거나 잠금을 남긴 채 종료되었고, 이 세션이 기다리는 동안 갱신이 진행되지 않았습니다. Claude Code는 요청을 보내기 전에 중단합니다.

```text theme={null}
Could not refresh your login because another Claude Code process is refreshing it (or exited mid-refresh) · Try again in a minute; if it keeps happening, close other Claude Code windows or sign in again with /login
```

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)(`-p`)와 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)에서는 메시지가 다음과 같이 표시되며, 구조화된 오류 코드는 `server_error`입니다.

```text theme={null}
Failed to refresh OAuth token: another Claude Code process is refreshing it or exited mid-refresh. This is usually transient; retry in a minute, and if it persists close other Claude Code processes or sign in again
```

API 키, [`CLAUDE_CODE_OAUTH_TOKEN`](https://code.claude.com/docs/ko/env-vars) 또는 타사 공급자로 인증된 세션은 저장된 로그인을 사용하지 않으므로 이 메시지가 표시되지 않습니다.

**해결 방법:**

* 1분 후에 다시 시도합니다. 다른 프로세스가 먼저 갱신을 완료하면 이 세션은 갱신된 로그인을 사용합니다.
* 메시지가 계속 나타나면 다른 Claude Code 창과 프로세스를 닫은 다음 재시도합니다.
* 다른 Claude Code 프로세스가 실행되고 있지 않은데도 메시지가 나타나면 `/login`을 실행합니다. 다시 로그인하는 것은 갱신 잠금을 기다리지 않습니다.

### 로그인을 저장할 수 없음

claude.ai로 로그인했지만 Claude Code가 로그인을 자격 증명 저장소에 저장할 수 없어 로그인이 완료되지 않았습니다. macOS에서는 같은 세션 중에 Claude Code가 이미 로그인 키체인에서 자격 증명을 읽거나 저장한 후, 예를 들어 잠자기나 유휴 상태로 인해 키체인이 잠기면 이 문제가 발생할 수 있습니다.

```text theme={null}
Couldn't save your login. If your Mac's keychain is locked, unlock it and log in again.
Couldn't save your login. Try logging in again.
```

첫 번째 형태는 macOS에서, 두 번째 형태는 그 밖의 모든 환경에서 표시됩니다. 시간 초과나 읽을 수 없는 저장소 같은 일시적인 자격 증명 저장소 실패도 같은 메시지를 생성합니다.

**해결 방법:**

* macOS에서는 로그인 키체인의 잠금을 해제한 다음 `/login`을 다시 실행합니다
* 다른 플랫폼에서는 `/login`을 다시 실행합니다
* 로그인이 여전히 저장되지 않으면, 키체인 잠금 해제 명령과 기타 자격 증명 저장소 복구 단계는 [로그인되지 않음 또는 토큰 만료](https://code.claude.com/docs/ko/troubleshoot-install.md#not-logged-in-or-token-expired)를 참조하십시오

### Couldn't start the local listener that receives the browser sign-in

`/login`, `claude auth login` 또는 `claude setup-token`에서 표시되는 다음 메시지들은 모두 Claude Code가 브라우저가 로그인 결과를 반환하는 `127.0.0.1`의 포트를 열 수 없었다는 의미입니다.

`The browser can't return the sign-in to Claude Code automatically`로 시작하는 알림이 표시되면, 로그인은 해당 포트 없이 계속 진행됩니다. 브라우저는 열리지 않으며, 알림은 대신 로그인할 URL 위에 표시됩니다.

```text wrap theme={null}
The browser can't return the sign-in to Claude Code automatically. After you sign in, paste the code shown.
```

`Couldn't start the local listener`가 포함된 메시지가 표시되면 로그인이 중단된 것입니다. 예를 들어 `claude auth login`에 입력을 파이프로 전달하는 경우 이런 일이 발생합니다.

```text theme={null}
Couldn't start the local listener that receives the browser sign-in. Try again.
```

**해결 방법:**

* **`The browser can't return the sign-in to Claude Code automatically`**: 먼저 수정할 것은 없습니다. 알림 아래에 표시된 URL을 브라우저에서 열고 로그인합니다. 그러면 브라우저에 코드가 표시됩니다. `Paste code here >` 프롬프트에서 Claude Code에 코드를 붙여 넣으면 로그인이 계속 진행됩니다.
* **`Couldn't start the local listener that receives the browser sign-in`**: 같은 명령을 다시 실행합니다. 같은 방식으로 중단되면 브라우저 대신 토큰이나 API 키로 로그인합니다. 또는 `claude auth login`에 입력을 파이프로 전달했다면, 붙여 넣은 코드를 받을 수 있도록 터미널에서 실행합니다.
* **브라우저 대신 토큰이나 API 키로 로그인하려면**: claude.ai 구독을 사용한다면 로그인이 작동하는 머신에서 [`claude setup-token`](https://code.claude.com/docs/ko/authentication#generate-a-long-lived-token)을 실행합니다. 그런 다음 출력된 토큰을 이 머신에서 [`CLAUDE_CODE_OAUTH_TOKEN`](https://code.claude.com/docs/ko/env-vars) 환경 변수로 설정합니다. 그렇지 않다면 `ANTHROPIC_API_KEY` 환경 변수를 [Claude Console](https://platform.claude.com/settings/keys)의 키로 설정합니다. [인증 우선순위](https://code.claude.com/docs/ko/authentication.md#authentication-precedence)에서 Claude Code가 자격 증명 중 무엇을 선택하는지 설명합니다.
* **브라우저 자동 반환을 다시 사용하려면**: Claude Code가 `127.0.0.1`에서 수신 대기할 수 있어야 합니다. 샌드박스 안에서 실행 중이라면 샌드박스 정책이 로컬 포트 수신 대기를 허용하는지 확인한 다음 다시 로그인합니다. 수신 대기가 가능해야 하는 환경인데도 알림이 계속 표시된다면, 보고서에 환경 세부 정보가 포함되도록 `/feedback`을 실행합니다.

v2.1.305 이전에는 포트를 열 수 없으면 즉시 로그인이 중단되었고 로그인할 URL도 표시되지 않았습니다. 메시지는 예를 들어 `Failed to start OAuth callback server: Failed to start server. Is port 0 in use?`와 같았습니다. 해당 버전에서는 Claude Code를 업데이트하고 다시 로그인하거나, 브라우저 대신 토큰이나 API 키로 로그인하십시오.

### Claude 로그인이 수락되지 않음

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 시작하려고 했지만 서버가 401로 세션 생성을 거부했습니다. 서버가 이 머신이 보낸 Claude 로그인을 받아들이지 않았으며, 보통 로그인이 만료되었거나 폐기되었기 때문입니다.

줄의 첫 부분은 서버가 이유를 제공하는 경우 서버 자체의 이유입니다. 그렇지 않으면 다음과 같이 표시됩니다.

```text theme={null}
Claude login not accepted · Run /login, then try again
```

**해결 방법:**

* `/login`을 실행하고 로그인을 완료한 다음 세션을 다시 시작합니다

### 아티팩트에는 claude.ai 로그인이 필요함

세션에 아티팩트에 사용할 수 있는 claude.ai 로그인이 없어서 Claude Code가 [아티팩트](https://code.claude.com/docs/ko/artifacts.md) 게시 또는 읽기를 거부했습니다.

메시지의 모든 형태는 같은 문구로 시작하고, 세션의 인증 방식에 따라 달라지는 해결 방법이 뒤따릅니다. 경쟁하는 자격 증명이 없을 때는 다음과 같이 표시됩니다.

```text theme={null}
Artifacts need a claude.ai login. Run /login and select "Claude account with subscription", then retry — the "Anthropic Console account" option does not provide claude.ai credentials.
```

**해결 방법:**

* `/login`을 실행하고 **Claude account with subscription**을 선택합니다. **Anthropic Console account** 옵션은 claude.ai 자격 증명을 제공하지 않습니다.
* 메시지에 `ANTHROPIC_API_KEY`, `apiKeyHelper` 설정, 또는 이전 `/login`으로 저장된 Console 키처럼 우선하는 자격 증명이 표시되면, 메시지가 안내하는 방식으로 이를 제거한 다음 `/login`을 실행합니다
* 메시지에 이 원격 세션이 자신을 실행한 머신을 통해 인증한다고 표시되면, 해당 머신에서 claude.ai에 로그인한 다음 세션을 다시 연결합니다
* 메시지에 자격 증명이 세션의 호스트 환경에서 주입된다고 표시되면, 해당 세션에서는 변경할 수 없습니다. claude.ai에 로그인된 세션을 시작합니다
* 플랜, 모델 공급자, 조직 정책 등 아티팩트의 기타 요구 사항은 [사용 가능 여부](https://code.claude.com/docs/ko/artifacts.md#availability)를 참조하십시오

### 관리자 정책에 따라 Cloud 게이트웨이 로그인이 필요함

이 머신의 관리자 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)이 [`forceLoginMethod`](https://code.claude.com/docs/ko/settings-reference#forceloginmethod)를 `"gateway"`로 설정했거나 [`forceLoginGatewayUrl`](https://code.claude.com/docs/ko/settings-reference#forcelogingatewayurl)을 설정했습니다. 이 경우 `CLAUDE_CODE_USE_BEDROCK` 같은 변수로 클라우드 공급자를 선택하지 않는 한 Claude Code는 [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 로그인만 허용합니다. 다음 두 메시지 중 하나가 표시됩니다.

```text theme={null}
Not signed in to the Cloud gateway — run /login.
```

예를 들어 정책이 머신에 적용된 이후 `/login`을 실행하지 않아 세션에 게이트웨이 로그인이 없으면 모델 요청이 이 메시지와 함께 실패합니다.

머신에 Anthropic이 발급한 자격 증명도 있고 관리형 설정이 `forceLoginMethod` 또는 `forceLoginOrgUUID`를 설정한 경우, Claude Code는 대신 시작 시 종료됩니다. 해당 자격 증명은 `ANTHROPIC_API_KEY` 또는 `ANTHROPIC_AUTH_TOKEN` 변수, `apiKeyHelper` 설정, 또는 이전 Claude Console 로그인으로 저장된 API 키일 수 있습니다.

시작 메시지에는 세션에 구성된 자격 증명, 설정된 위치, 그리고 이를 제거하는 단계가 표시됩니다. 예를 들어 셸에 `ANTHROPIC_API_KEY` 변수가 설정되어 있으면 다음과 같이 표시됩니다.

```text theme={null}
Administrator policy requires a Cloud gateway sign-in on this machine, but this session is configured with an API key from ANTHROPIC_API_KEY, which a gateway machine does not accept.

To continue: unset ANTHROPIC_API_KEY (or run in a shell without it), then run claude and sign in with /login.
```

**해결 방법:**

* `Not signed in to the Cloud gateway`의 경우 `/login`을 실행하고 **Cloud gateway** 화면에서 로그인을 완료합니다
* 시작 메시지의 경우 메시지 끝의 단계에 따라 자격 증명을 제거합니다
* 머신에 게이트웨이가 필요하지 않아야 한다고 생각되면, 머신을 관리하는 관리자에게 관리형 설정에서 `forceLoginMethod`와 `forceLoginGatewayUrl`을 제거해 달라고 요청합니다

v2.1.284 이전에는 시작 메시지가 구성된 자격 증명의 이름을 표시하는 대신 가능한 자격 증명을 나열했습니다. 메시지는 `Administrator policy requires a Cloud gateway sign-in on this machine; the Anthropic-issued credential configured here (ANTHROPIC_API_KEY, ANTHROPIC_AUTH_TOKEN, or apiKeyHelper) is not used.`로 시작했습니다. 이 문구가 표시되고 어떤 자격 증명을 제거해야 할지 알 수 없다면 v2.1.284 이상으로 업데이트하고 `claude`를 다시 시작하십시오.

v2.1.265에서는 회귀 문제로 인해, 머신에 관리자 요구 사항이 없어도 API 키, `apiKeyHelper` 또는 사용자 지정 헤더로 인증하는 일부 LLM 게이트웨이 및 프록시 구성에서 첫 번째 메시지가 표시되기도 했습니다. v2.1.266 이상으로 업데이트하십시오. 구성을 변경할 필요는 없습니다.

v2.1.261 이전에는 `forceLoginMethod`를 `"gateway"`로 설정한 머신에서 Claude Code가 모델 요청을 실패시키는 대신 남아 있는 저장된 로그인을 사용했으며, 구성된 환경 자격 증명을 시작 메시지 대신 `This machine's managed settings require a first-party login`으로 보고했습니다.

### 계정이 보류 상태임

로그인에 연결된 Claude 계정이 정지되었습니다. Claude Code는 저장된 로그인을 갱신하려다가 보류 상태를 알게 되면 첫 번째 메시지를, 브라우저에서 완료한 로그인이 보류 상태를 보고하면 두 번째 메시지를 표시합니다.

```text theme={null}
Your account is on hold and can't use Claude Code. View details or appeal: https://claude.ai/restricted
Your account is on hold and can't sign in to Claude Code. View details or appeal: https://claude.ai/restricted
```

보류는 로그인이 아닌 계정에 적용되므로 같은 계정으로 다시 로그인해도 메시지가 사라지지 않습니다. [비대화형 모드](https://code.claude.com/docs/ko/headless.md)(`-p`)와 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)에서 구조화된 오류 코드는 `account_on_hold`입니다. v2.1.235 이전에는 Claude Code가 보류된 계정을 [Login expired · Please run /login](#login-expired)으로 보고했으며, 그 복구 단계로는 보류를 해제할 수 없었습니다.

**해결 방법:**

* 메시지의 링크를 열어 보류의 세부 정보를 확인하거나 이의를 제기합니다
* 보류의 영향을 받지 않는 다른 Claude 계정이나 API 키가 있다면, 보류가 해결되는 동안 계속 작업할 수 있습니다. 해당 계정으로 `/login`을 실행하거나 `ANTHROPIC_API_KEY`로 키를 설정합니다

### Anthropic 프로필 로그인 만료

Claude Code가 Anthropic 자격 증명 프로필을 통해 인증하고 있는데, 해당 프로필의 저장된 로그인 자격 증명이 만료되었고 프로필에 Claude Code가 갱신에 사용할 수 있는 리프레시 자격 증명이 없습니다. Claude Code는 재시도 없이 각 요청을 로컬에서 중단합니다.

```text theme={null}
Anthropic profile login expired · Re-authenticate your Anthropic profile
Login expired · Run /login to sign in again, or re-authenticate your Anthropic profile
```

**해결 방법:**

* 메시지가 `Login expired`로 시작하면 `/login`을 실행하여 다시 로그인합니다
* 키 없는 Console 로그인이나 Claude Platform CLI의 `ant auth login`이 작성한 프로필을 갱신하려면, [키 없는 로그인을 제공하는](https://code.claude.com/docs/ko/authentication.md#sign-in-without-an-api-key) 머신에서 `/login`을 실행합니다. Anthropic Console 계정을 선택한 다음 **Sign in with your Console account**를 선택합니다. Claude Code가 해당 프로필의 만료된 자격 증명을 교체합니다
* 다른 도구가 생성한 프로필을 갱신하려면 해당 도구로 다시 로그인합니다. 대신 `/login`에서 **Sign in with your Console account**를 선택하면 Claude Code는 프로필을 그대로 두고 API 키를 생성합니다
* 관리자가 프로필의 자격 증명을 프로비저닝한 경우 새 자격 증명 발급을 요청합니다
* `/status`를 실행하여 활성 자격 증명 소스와 프로필 이름을 확인합니다
* 프로필 사용을 중단하려면, `ANTHROPIC_PROFILE`을 설정했다면 해제한 다음 `/login`이나 `ANTHROPIC_API_KEY` 같은 다른 방법으로 인증합니다

메시지의 시작 부분을 보면 Claude Code가 프로필을 어떻게 찾았는지 알 수 있습니다.

* Claude Code가 구성 디렉터리에서 프로필을 발견했고 인증 모드가 `user_oauth`인 경우, 메시지는 `Login expired`로 시작하며 `/login`을 먼저 제안합니다. Claude Code는 작동하는 `/login`을 발견된 프로필보다 우선하여 claude.ai 계정으로 인증합니다. v2.1.234부터 v2.1.277 전까지 이 형식은 `Anthropic profile login expired · Run /login to use your claude.ai account instead, or re-authenticate the profile`로 표시되었습니다. v2.1.234 이전에는 이 경우에도 Claude Code가 `Re-authenticate your Anthropic profile` 형식을 표시했습니다.
* `ANTHROPIC_PROFILE`로 프로필을 선택한 경우 메시지는 `Anthropic profile login expired`로 시작합니다.

이 메시지는 활성 자격 증명이 Anthropic 자격 증명 프로필에서 오는 경우에만 나타납니다. 해당 프로필은 `ANTHROPIC_PROFILE` 환경 변수로 선택한 프로필, Claude Code가 Anthropic 구성 디렉터리에서 활성 프로필로 발견한 프로필, 또는 [API 키 없이 로그인](https://code.claude.com/docs/ko/authentication.md#sign-in-without-an-api-key)했을 때 Claude Code가 작성한 프로필입니다. API 키, `ANTHROPIC_AUTH_TOKEN` 같은 bearer 토큰, 또는 서드파티 제공업체로 인증하는 세션에서는 이 메시지가 표시되지 않습니다.

### OAuth 범위 요구 사항

저장된 토큰이 새 기능에 필요한 권한 범위보다 먼저 발급되었습니다.

```text theme={null}
OAuth token does not meet scope requirement: user:profile
```

**해결 방법:**

* `/login`을 실행하여 현재 범위가 포함된 새 토큰을 받습니다. 먼저 로그아웃할 필요는 없습니다.

### claude.ai가 세션 토큰을 거부함

claude.ai가 Claude Code 로그인의 토큰을 거부하여 [claude.ai 커넥터](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai) 요청이 실패했습니다. 거부된 토큰은 claude.ai에서 커넥터 자체의 권한 부여가 아니라 사용자의 로그인이므로, 커넥터를 다시 승인해도 해결되지 않습니다. `/mcp`에서 커넥터는 `session token rejected`로 표시되고, 세부 정보 보기에는 다음과 같이 표시됩니다.

```text theme={null}
claude.ai rejected the session token. Run /login, then reconnect.
```

**해결 방법:**

* `/login`을 실행하여 다시 로그인합니다
* `/mcp`에서 커넥터를 다시 연결하거나 `/mcp reconnect <server>`를 실행합니다. 다시 로그인하기 전에 다시 연결하면 커넥터가 같은 상태로 남습니다. `/mcp` 패널의 **Reconnect** 옵션은 `your claude.ai session token was rejected`를 보고하지만, 직접 입력하는 `/mcp reconnect <server>` 형태는 토큰이 여전히 거부된 상태인데도 다시 연결에 성공했다고 보고합니다.

v2.1.222 이전에는 Claude Code가 대신 커넥터를 인증이 필요한 상태로 표시했기 때문에, 커넥터의 권한 부여 흐름을 완료해도 상태가 해결되지 않는데도 해당 흐름으로 안내했습니다.

### MCP 서버에 다시 로그인해야 함

세션 도중 원격 [MCP 서버](https://code.claude.com/docs/ko/mcp.md)가 도구 호출의 자격 증명을 거부했습니다. 보통 로그인이나 토큰이 만료되었거나 토큰에 도구에 필요한 권한이 없기 때문입니다. 도구 호출이 실패하고, `/mcp`는 서버를 [인증이 필요한](https://code.claude.com/docs/ko/mcp.md#authenticate-with-remote-mcp-servers) 상태로 표시합니다.

claude.ai 커넥터를 포함하여 Claude Code에서 로그인하는 서버의 경우, 로그인이 만료되었거나 폐기되었습니다.

```text theme={null}
MCP server "<name>" needs you to sign in again (run /mcp to re-authenticate)
```

`/mcp`를 실행하고 서버를 선택한 다음 메뉴에서 다시 로그인합니다.

[`headersHelper`](https://code.claude.com/docs/ko/mcp#use-dynamic-headers-for-custom-authentication) 스크립트로 구성된 서버의 경우, Claude Code는 이 메시지를 표시하기 전에 이미 헬퍼를 다시 실행하고 호출을 한 번 재시도했습니다.

```text theme={null}
MCP server "<name>" rejected the credential from its headersHelper (check the helper and run /mcp to reconnect, or to authenticate if the server also uses OAuth)
```

헬퍼가 서버가 받아들이는 자격 증명을 반환하는지 확인한 다음, 헬퍼를 다시 실행하는 `/mcp`에서 다시 연결합니다.

구성에 정적 `Authorization` 헤더가 있는 서버의 경우:

```text theme={null}
MCP server "<name>" rejected the Authorization header in its config (update it, then run /mcp to reconnect)
```

서버가 구성된 위치에서 헤더 값을 업데이트한 다음 `/mcp`에서 다시 연결합니다.

Claude Desktop 앱에서 사용자의 머신에서 실행되는 [Cowork](https://claude.com/docs/cowork/overview) 세션의 경우, 다음 메시지는 MCP 서버가 제공받은 자격 증명을 거부했다는 의미입니다. 메시지에 표시된 항목을 수정한 후 Cowork에서 새 작업이나 채팅을 시작합니다.

```text theme={null}
MCP server "<name>" rejected the credential from its headersHelper (check the helper, then start a new task or chat)
MCP server "<name>" rejected the Authorization header in its config (update it, then start a new task or chat)
```

* **`headersHelper` 자격 증명 거부**: 헬퍼가 서버에서 받아들이는 자격 증명을 반환하는지 확인한 후 Cowork에서 새 작업이나 채팅을 시작합니다
* **`Authorization` 헤더 거부**: 해당 서버 구성의 `headers` 아래에 있는 `Authorization` 값을 업데이트한 후 Cowork에서 새 작업이나 채팅을 시작합니다

v2.1.302 이전에는 Cowork 세션에서 `/mcp`를 사용할 수 없는데도 `run /mcp to reconnect` 어미가 대신 표시되었습니다. Cowork에서 이러한 어미가 표시되더라도 헬퍼를 확인하거나 헤더를 업데이트한 후 새 작업이나 채팅을 시작하십시오. v2.1.273 이전에는 로그인 만료, `headersHelper`, `Authorization` 헤더의 경우 모두 `MCP server "<name>" requires re-authorization (token expired)`가 표시되었습니다.

서버는 범위 승인을 요청하기 위해 HTTP 403 `insufficient_scope`로 도구 호출을 거부할 수도 있으며, 때로는 토큰에 이미 포함된 범위를 요청하기도 합니다. 메시지에 해당 범위가 표시됩니다.

```text theme={null}
MCP server "<name>" needs additional permissions (scope: "<scope>") — run /mcp to re-authenticate
```

`/mcp`를 실행하고 서버를 선택한 다음 메뉴에서 다시 인증합니다.

서버 구성에 [`oauth.scopes`](https://code.claude.com/docs/ko/mcp#restrict-oauth-scopes)와 [`authServerMetadataUrl`](https://code.claude.com/docs/ko/mcp#override-oauth-metadata-discovery)이 모두 설정되어 있지 않으면, Claude Code는 서버가 지정한 범위를 요청합니다. 둘 중 하나가 설정되어 있으면 Claude Code는 대신 해당 설정의 범위를 요청합니다. `oauth.scopes`를 고정했다면 다시 인증하기 전에 누락된 범위를 해당 목록에 추가하십시오.

v2.1.274 이전에는 이 경우 `needs you to sign in again` 메시지가 표시되었고, v2.1.273 이전에는 다른 경우와 마찬가지로 `requires re-authorization (token expired)`가 표시되었습니다.

### Couldn't read the stored credentials for MCP server

Claude Code는 OAuth [MCP 서버](https://code.claude.com/docs/ko/mcp.md)의 로그인 정보를 자격 증명 저장소에 보관합니다. 이 메시지는 Claude Code가 해당 저장소를 읽을 수 없어서 서버에 대한 요청이 실행되지 않았다는 의미입니다:

```text theme={null}
Couldn't read the stored credentials for MCP server "<name>", so the request didn't run. If your Mac's keychain is locked, unlock it, then try again.
Couldn't read the stored credentials for MCP server "<name>", so the request didn't run. Try again.
```

저장된 로그인 정보는 변경되지 않았습니다. 저장소를 읽을 수 있게 되면 다시 시도하고, 서버가 요청할 때만 다시 로그인합니다.

macOS의 [`claude -p`](https://code.claude.com/docs/ko/headless) 또는 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 실행에서는 저장된 로그인 정보 없이 요청이 이미 전송된 후에 키체인을 읽을 수 있게 될 수 있습니다. 그 요청은 다음과 함께 실패합니다:

```text theme={null}
A request to MCP server "<name>" was sent without your stored credentials, so the server rejected it. The credentials are available now. Try again.
```

**해결 방법:**

* 메시지에서 Mac의 키체인 잠금을 해제하라고 안내하면, Claude Code를 실행하는 셸 세션에서 [`claude doctor`](https://code.claude.com/docs/ko/cli-reference#cli-commands)를 실행하고 보고서에 키체인 경고가 있는지 확인합니다:
  * 보고서에 `macOS Keychain is not writable`로 시작하는 경고가 있거나, 셸에 `claude` 명령이 없다면 해당 셸 세션에서 다음 잠금 해제 명령을 실행합니다:

    ```bash theme={null}
    security unlock-keychain ~/Library/Keychains/login.keychain-db
    ```

  * 보고서에 키체인 경고가 없다면 잠금 해제 명령을 건너뜁니다

* 메시지가 표시된 곳에서 다시 시도합니다:
  * `claude -p`의 경우 명령을 다시 실행합니다
  * 대화형 세션에서는 `/mcp`에서 서버가 실패로 표시되면 다시 연결한 후, Claude에게 다시 시도하도록 요청합니다
  * 계속 실행되는 Agent SDK 애플리케이션에서는 TypeScript의 [`reconnectMcpServer()`](https://code.claude.com/docs/ko/agent-sdk/typescript#methods) 또는 Python의 [`ClaudeSDKClient.reconnect_mcp_server()`](https://code.claude.com/docs/ko/agent-sdk/python#methods)를 호출하거나, 새 세션을 시작합니다

* 이후 서버가 인증이 필요하다고 보고하면, Claude Code가 해당 서버에 사용할 수 있는 로그인 정보를 찾지 못한 것입니다. 대화형으로 로그인합니다. Claude Code 세션에서 `/mcp`를 실행하거나, 셸에서 [`claude mcp login <name>`](https://code.claude.com/docs/ko/mcp#authenticate-from-the-command-line)을 실행합니다. Agent SDK 애플리케이션에서는 [Agent SDK의 OAuth2 인증](https://code.claude.com/docs/ko/agent-sdk/mcp.md#oauth2-authentication)을 참조하세요.

v2.1.307 이전에는 로그인 키체인이 잠긴 Mac에서 `claude -p` 또는 Agent SDK를 실행하면, 두 메시지 대신 서버가 인증이 필요하다고 보고했습니다.

### MCP 서버 URL이 없거나 유효한 URL이 아님

서버에 구성된 `url`이 URL로 파싱되지 않아서 Claude Code가 원격 MCP 서버의 OAuth 로그인 시작을 거부했습니다. Claude Code가 해당 서버에 대해 보고할 더 구체적인 구성 문제가 없는 한, 셸에서 [`claude mcp login <name>`](https://code.claude.com/docs/ko/mcp#authenticate-from-the-command-line)을 실행하면 거부 내용이 다음과 같이 출력됩니다.

```text theme={null}
Couldn't complete authentication for "<name>": This server's URL is missing or not a valid URL, so sign-in can't start. Fix the URL in its MCP config (or set the environment variable it uses) and try again.
```

**해결 방법:**

* 서버가 구성된 위치에서 항목의 `url`을 서버의 실제 엔드포인트로 설정하거나, 해당 [`${VAR}` 참조](https://code.claude.com/docs/ko/mcp#environment-variable-expansion-in-mcp-json)가 가리키는 환경 변수를 설정한 다음 로그인을 다시 실행합니다.

### 권한 부여 응답의 발급자 불일치

[MCP OAuth 로그인](https://code.claude.com/docs/ko/mcp.md#authenticate-with-remote-mcp-servers) 중에 권한 부여 서버가 Claude Code로 리디렉션하면서, Claude Code가 서버의 OAuth 메타데이터에서 예상한 발급자를 가리키지 않는 `iss` 매개변수를 보냈습니다. 이 단계에서 잘못된 발급자가 나타나는 것은 권한 부여 서버 혼동(mix-up) 공격의 징후이므로, Claude Code는 권한 부여 코드를 교환하는 대신 로그인을 실패 처리합니다. Claude Code는 브라우저 로그인 후 `/mcp` 서버 메뉴에 오류를 표시합니다.

```text theme={null}
Issuer mismatch in authorization response (RFC 9207): expected "https://auth.example.com", received "https://other.example.com"
```

`expected`는 서버의 OAuth 메타데이터에 있는 발급자이고, `received`는 리디렉션에 포함된 `iss` 값입니다. 리디렉션에 `iss` 매개변수가 없는 로그인은 검사를 통과하지만, 서버의 메타데이터가 `authorization_response_iss_parameter_supported`를 설정한 경우에는 Claude Code가 로그인을 실패 처리합니다.

**해결 방법:**

* `/mcp`에서 로그인을 다시 시도합니다
* 오류가 반복되면 서버 운영자에게 보고합니다. 해결 방법은 서버 측에 있습니다. 권한 부여 서버는 메타데이터에 명시한 것과 같은 발급자를 `iss` 매개변수로 반환해야 합니다
* 서버가 수정되는 동안 연결하려면 [`MCP_SDK_GENERATION=v1`](https://code.claude.com/docs/ko/env-vars)로 Claude Code를 시작합니다. 이 [런타임](https://code.claude.com/docs/ko/mcp.md#mcp-client-runtimes)은 이 검사를 실행하지 않습니다. 이렇게 하면 혼동 공격에 대한 보호가 제거되므로 서버 측 수정을 우선하십시오

v2.1.232 이전에는 Claude Code가 점진적 출시 대상이거나 `MCP_SDK_GENERATION=v2`를 설정한 경우에만 v2 런타임을 사용했습니다.

### HTTPS가 아닌 토큰 엔드포인트로 자격 증명 전송 거부

[v2 런타임](https://code.claude.com/docs/ko/mcp.md#mcp-client-runtimes)에서 Claude Code는 HTTPS로 제공되거나 `localhost`, `127.0.0.1`, `::1`에 있는 토큰 엔드포인트에만 [MCP OAuth](https://code.claude.com/docs/ko/mcp.md#authenticate-with-remote-mcp-servers) 토큰 요청을 보냅니다. 이 메시지는 서버의 토큰 엔드포인트가 둘 다 해당하지 않아 Claude Code가 요청을 보내기 전에 중단했다는 뜻입니다. 이는 브라우저 로그인 이후에 발생하므로 브라우저 단계는 먼저 성공하며, Claude Code가 서버의 토큰을 갱신할 때마다 다시 발생합니다.

메시지의 전체 형태는 MCP SDK에서 생성되며 거부한 토큰 엔드포인트를 인용합니다. 디버그 로그에서는 로그인의 경우 `Error during auth completion:` 뒤에, 갱신의 경우 `Token refresh failed:` 뒤에 나타납니다. 셸에서는 `claude mcp login <name>`이 `Couldn't complete authentication for "<name>":` 뒤에 이를 출력하고, 세션에서는 `/mcp`가 서버 메뉴 아래에 표시합니다.

```text theme={null}
Refusing to send credentials to non-https token endpoint 'http://192.168.1.50:8123/oauth/token'. OAuth token requests MUST use TLS (localhost / 127.0.0.1 / ::1 are exempt).
```

Claude Code는 쿼리 문자열이나 길고 무작위처럼 보이는 경로 세그먼트가 있는 서버 URL을 비밀 정보일 수 있다고 간주합니다. 이러한 서버의 경우 MCP SDK가 발생시킨 로그인 오류를 표시하거나 로그에 기록하기 전에 수정(redact)합니다. 이때 이 오류는 `io`처럼 릴리스마다 바뀔 수 있는 짧은 이름 뒤에 `from the MCP SDK for`와 수정된 서버 URL이 이어지는 형태로 표시됩니다. MCP SDK의 다른 오류도 같은 형태를 띱니다. 수정된 메시지가 이 오류일 수 있는 경우는 서버의 토큰 엔드포인트가 `localhost`, `127.0.0.1`, `::1` 이외의 주소에 있는 일반 `http://`일 때뿐입니다.

**해결 방법:**

* 해당 토큰 엔드포인트를 HTTPS로 제공합니다. 예를 들어 TLS를 종료하는 리버스 프록시나 터널 뒤에 서버를 두고, 서버가 `https://` 주소를 알리도록 구성합니다
* 서버를 변경하지 않고 연결하려면 [`MCP_SDK_GENERATION=v1`](https://code.claude.com/docs/ko/env-vars)로 Claude Code를 시작합니다. 이 [런타임](https://code.claude.com/docs/ko/mcp.md#mcp-client-runtimes)은 이 규칙을 적용하지 않고 일반 HTTP로 토큰 요청을 보냅니다. 이 선택은 종료할 때까지 유지되며 모든 서버에 적용됩니다. v1 런타임은 [발급자 검사](#issuer-mismatch-in-authorization-response)도 건너뛰므로, 엔드포인트를 HTTPS로 제공하는 방법을 우선하십시오

### AWS 자격 증명이 만료되었거나 유효하지 않음

AWS 세션 토큰이 만료되었거나 거부되었습니다. 이 메시지는 [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md) 또는 [Mantle 엔드포인트](https://code.claude.com/docs/ko/amazon-bedrock.md#use-the-mantle-endpoint)에서 401이 반환될 때 나타나며, 이는 해당 공급자가 만료된 보안 토큰을 보고하는 방식입니다.

중간의 작업 안내는 설정에 따라 달라집니다. 고정된 부분은 앞의 `AWS credentials expired or invalid`입니다.

```text theme={null}
AWS credentials expired or invalid · run /login and select "Claude Platform on AWS · refresh credentials", or run `aws sso login --profile myprofile` in another terminal · API Error: 401 ...
```

v2.1.273 이전에는 `awsAuthRefresh`가 구성된 경우에만 이 메시지가 나타났습니다.

**해결 방법:**

* 안내에 자격 증명이 이 환경에서 관리된다고 표시되면, Claude Code를 실행한 앱이 자격 증명을 소유하므로 여기의 다른 단계는 적용되지 않습니다. 재시도하거나 관리자에게 문의합니다
* [`awsAuthRefresh`](https://code.claude.com/docs/ko/amazon-bedrock#advanced-credential-configuration)가 설정되어 있으면 메시지에 표시된 `aws sso login --profile myprofile` 같은 명령을 다른 터미널에서 실행하고 브라우저 로그인을 완료한 다음 재시도합니다. 그렇지 않으면 사용하는 AWS 자격 증명, 즉 SSO 로그인, 액세스 키, API 키 또는 프록시 토큰을 직접 갱신합니다
* 대화형 세션에서 `awsAuthRefresh`가 설정되어 있으면, 대신 `/login`을 실행하고 **3rd-party platform**을 선택한 다음 **Using 3rd-party platforms** 아래의 **Claude Platform on AWS · refresh credentials**를 선택하여 Claude Code를 다시 시작하지 않고 같은 명령을 실행할 수 있습니다. [AWS 자격 증명 구성](https://code.claude.com/docs/ko/claude-platform-on-aws.md#1-configure-aws-credentials)을 참조하십시오
* 갱신 명령이 성공한 후에도 오류가 반복되면, 같은 셸과 프로필에서 `aws sts get-caller-identity`로 Claude Code 외부에서 ID가 유효한지 확인합니다

### AWS 인증 실패

AWS 공급자가 403을 반환했거나 [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md)이 401을 반환했습니다.

Amazon Bedrock은 만료된 보안 토큰을 403으로 보고하지만, IAM 권한 누락으로 인한 `AccessDeniedException` 같은 권한 부여 거부도 403으로 보고합니다. Claude Code는 이 두 원인을 구분할 수 없습니다.

Amazon Bedrock의 401도 [AWS 자격 증명이 만료되었거나 유효하지 않음](#aws-credentials-expired-or-invalid)이 아닌 여기에 해당합니다. Amazon Bedrock은 만료된 토큰을 401로 보고하지 않기 때문입니다. 해당 엔드포인트의 401은 일반적으로 회사 프록시처럼 요청 경로상의 다른 요소에서 발생합니다.

자격 증명 갱신으로 만료된 토큰은 해결되지만 다른 원인은 해결할 수 없으므로, 메시지는 두 가지를 모두 안내합니다.

```text theme={null}
AWS authentication failed · run /login and select "Claude Platform on AWS · refresh credentials", or run `aws sso login --profile myprofile` in another terminal · if credentials are current, check AWS permissions and model access · API Error: 403 ...
```

중간의 작업 안내는 설정에 따라 달라집니다. 고정된 부분은 앞의 `AWS authentication failed`입니다.

403이 지정된 모델 ID의 모델에 액세스할 수 없다는 Amazon Bedrock의 응답인 경우, 안내는 대신 Amazon Bedrock 콘솔에서 계정과 리전에 대해 모델을 활성화하라고 알려줍니다.

v2.1.273 이전에는 `awsAuthRefresh`가 구성된 경우에만 이 메시지가 나타났습니다.

**해결 방법:**

* 안내에 자격 증명이 이 환경에서 관리된다고 표시되면, Claude Code를 실행한 앱이 자격 증명을 소유하므로 여기의 다른 단계는 적용되지 않습니다. 재시도하거나 관리자에게 문의합니다
* 만료된 자격 증명이 원인일 경우에 대비해 AWS 자격 증명을 갱신합니다. 설정되어 있다면 메시지에 표시된 [`awsAuthRefresh`](https://code.claude.com/docs/ko/amazon-bedrock#advanced-credential-configuration) 명령을 실행하거나, SSO 로그인, 액세스 키, API 키 또는 프록시 토큰을 직접 갱신합니다
* 자격 증명이 최신 상태라면 [IAM 구성](https://code.claude.com/docs/ko/amazon-bedrock.md#iam-configuration)의 IAM 권한이 사용 중인 ID에 연결되어 있는지, 선택한 모델이 계정과 리전에 대해 활성화되어 있는지 확인합니다
* `aws sts get-caller-identity`를 실행하여 요청에 사용되는 ID를 확인합니다

### Google Cloud 자격 증명이 만료되었거나 유효하지 않음

[Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md)에 대한 Google Cloud 자격 증명이 만료되었거나 거부되었습니다. 요청이 401을 반환했으며, 이는 Agent Platform이 자격 증명 만료를 보고하는 방식입니다.

중간의 작업 안내는 설정에 따라 달라집니다. 고정된 부분은 앞의 `Google Cloud credentials expired or invalid`입니다.

```text theme={null}
Google Cloud credentials expired or invalid · refresh your Google Cloud credentials (application default sign-in, or the key file in GOOGLE_APPLICATION_CREDENTIALS) and retry · API Error: 401 ...
```

**해결 방법:**

* 안내에 자격 증명이 이 환경에서 관리된다고 표시되면, Claude Code를 실행한 앱이 자격 증명을 소유하므로 여기의 다른 단계는 적용되지 않습니다. 재시도하거나 관리자에게 문의합니다
* 애플리케이션 기본 자격 증명으로 인증하는 경우, 메시지에 표시된 [`gcpAuthRefresh`](https://code.claude.com/docs/ko/google-vertex-ai#advanced-credential-configuration) 명령 또는 `gcloud auth application-default login`을 실행하고 로그인을 완료한 다음 재시도합니다
* `CLAUDE_CODE_SKIP_VERTEX_AUTH`를 설정하고 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 통해 라우팅하는 경우, `ANTHROPIC_AUTH_TOKEN` 또는 `ANTHROPIC_CUSTOM_HEADERS`의 게이트웨이 토큰을 갱신한 다음 재시도합니다
* 서비스 계정 키 파일로 인증하는 경우, `GOOGLE_APPLICATION_CREDENTIALS`가 유효한 키를 가리키는지 확인합니다. [GCP 자격 증명 구성](https://code.claude.com/docs/ko/google-vertex-ai.md#3-configure-gcp-credentials)을 참조하십시오
* 갱신 후에도 오류가 반복되면, 같은 셸에서 `gcloud auth application-default print-access-token`으로 Claude Code 외부에서 ID가 작동하는지 확인합니다

v2.1.273 이전에는 Agent Platform의 401에 대해 Google Cloud 자격 증명을 갱신할 수 없는 일반적인 `Please run /login` 또는 `Failed to authenticate` 메시지가 대신 표시되었습니다.

### Google Cloud authentication failed

[Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md)이 403을 반환했습니다. Agent Platform은 만료된 자격 증명이 아니라 인가 거부에 403을 사용합니다. 일반적으로 인증에 사용하는 ID에 IAM 권한이 없거나, 프로젝트에서 모델이 활성화되어 있지 않은 경우입니다.

중간의 조치 안내는 설정에 따라 달라집니다. 변하지 않는 부분은 맨 앞의 `Google Cloud authentication failed`입니다.

```text theme={null}
Google Cloud authentication failed · refresh your Google Cloud credentials (application default sign-in, or the key file in GOOGLE_APPLICATION_CREDENTIALS) and retry · if credentials are current, check GCP IAM permissions and Vertex AI model access · API Error: 403 ...
```

**조치 방법:**

* 안내에 자격 증명이 이 환경에서 관리된다고 표시되면, Claude Code를 실행한 앱이 자격 증명을 소유하므로 여기의 다른 단계는 적용되지 않습니다. 재시도하거나 관리자에게 문의하십시오
* [IAM 구성](https://code.claude.com/docs/ko/google-vertex-ai.md#iam-configuration)의 역할이 인증에 사용하는 ID에 부여되어 있는지 확인합니다
* 프로젝트에서 모델이 활성화되어 있는지 확인합니다. [모델 액세스 요청](https://code.claude.com/docs/ko/google-vertex-ai.md#2-request-model-access)을 참조하십시오

v2.1.273 이전에는 Agent Platform의 403이 Google Cloud 자격 증명을 갱신할 수 없는 일반적인 `Please run /login` 또는 `Failed to authenticate` 메시지로 표시되었습니다.

### Microsoft Foundry authentication failed

[Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md)가 401 또는 403을 반환했습니다. 요청에 포함된 Azure 자격 증명이 거부되었거나, 그 자격 증명의 ID에 Foundry 리소스에 대한 액세스 권한이 없습니다. `/login`으로는 Azure 자격 증명을 발급할 수 없습니다. 중간의 조치 안내는 설정에 따라 달라집니다. 변하지 않는 부분은 맨 앞의 `Microsoft Foundry authentication failed`입니다.

```text theme={null}
Microsoft Foundry authentication failed · refresh your Foundry credential (ANTHROPIC_FOUNDRY_AUTH_TOKEN, ANTHROPIC_FOUNDRY_API_KEY, Azure sign-in for Entra, or your proxy token) and retry · if credentials are current, check access to the Foundry resource · API Error: 401 ...
```

**조치 방법:**

* 안내에 자격 증명이 이 환경에서 관리된다고 표시되면, Claude Code를 실행한 앱이 자격 증명을 소유하므로 여기의 다른 단계는 적용되지 않습니다. 재시도하거나 관리자에게 문의하십시오
* [Azure 자격 증명 구성](https://code.claude.com/docs/ko/microsoft-foundry.md#2-configure-azure-credentials)에서 구성한 자격 증명을 갱신합니다. `ANTHROPIC_FOUNDRY_API_KEY`를 교체하거나, 새 `ANTHROPIC_FOUNDRY_AUTH_TOKEN`을 발급하거나, 기본 Microsoft Entra 자격 증명 체인이 다시 로그인할 수 있도록 `az login`을 실행합니다
* 자격 증명이 최신 상태라면 해당 ID에 Foundry 리소스에 대한 액세스 권한이 있는지 확인합니다. [Azure RBAC 구성](https://code.claude.com/docs/ko/microsoft-foundry.md#azure-rbac-configuration)을 참조하십시오

v2.1.273 이전에는 Microsoft Foundry의 401 또는 403이 Azure 자격 증명을 갱신할 수 없는 일반적인 `Please run /login` 또는 `Failed to authenticate` 메시지로 표시되었습니다.

### Could not load AWS or Google Cloud credentials

Claude Code가 실행 중인 머신에서 AWS 자격 증명 공급자 체인이나 Google 애플리케이션 기본 자격 증명으로부터 사용 가능한 자격 증명을 얻지 못했으므로, 어떤 요청도 클라우드 공급자에 도달하지 않았습니다. `·` 뒤의 세부 정보는 구체적인 원인을 나타냅니다. 예를 들어 만료된 SSO 세션, `Could not load the default credentials`로 보고되는 애플리케이션 기본 자격 증명 누락, `invalid_grant`로 보고되는 취소된 로그인 등이 있습니다.

```text theme={null}
API Error: Could not load AWS credentials · Could not load credentials from any providers. Check or refresh your AWS credentials and try again.
API Error: Could not load Google Cloud credentials · invalid_grant. Check or refresh your Google Cloud credentials and try again.
```

`-p`를 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)와 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)에서 구조화된 오류 코드는 `cloud_credential_error`입니다. v2.1.267 이전에는 메시지에 `API Error:` 뒤의 세부 텍스트만 표시되었고, 구조화된 코드는 `server_error` 또는 `unknown`이었습니다.

**조치 방법:**

* `aws sso login --profile myprofile` 또는 `gcloud auth application-default login`과 같은 공급자의 로그인 명령을 실행한 다음 재시도합니다. [Bedrock, Agent Platform 또는 Foundry 자격 증명이 로드되지 않음](https://code.claude.com/docs/ko/troubleshoot-install.md#bedrock-agent-platform-or-foundry-credentials-not-loading)에서 Claude Code 외부에서 자격 증명을 확인하는 방법을 설명합니다
* 세부 정보가 `AWS default-chain credential resolve timed out`이면 체인이 실패한 것이 아니라 멈춘 것이므로, 대신 [AWS default-chain credential resolve timed out](#aws-default-chain-credential-resolve-timed-out)을 따르십시오

### AWS default-chain credential resolve timed out

AWS 기본 자격 증명 공급자 체인이 60초 이내에 자격 증명을 생성하지 못했으므로, Claude Code가 확인 작업을 중단하고 요청을 실패 처리했습니다. 이 타임아웃은 [Could not load AWS or Google Cloud credentials](#could-not-load-aws-or-google-cloud-credentials)의 원인 중 하나입니다. 이 실패는 로컬 자격 증명 확인 과정에서 발생한 것으로, 요청은 [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md) 또는 [Mantle 엔드포인트](https://code.claude.com/docs/ko/amazon-bedrock.md#use-the-mantle-endpoint)에 도달하지 않았습니다. Claude Code는 이 오류를 표시하기 전에 [자격 증명 캐시](https://code.claude.com/docs/ko/amazon-bedrock.md#credential-caching-and-resolution-timeout)를 지우고 재시도하므로, 이 오류가 표시될 때는 이미 반복된 시도에서 체인이 멈춘 상태입니다.

```text theme={null}
API Error: Could not load AWS credentials · AWS default-chain credential resolve timed out. Check or refresh your AWS credentials and try again.
```

일반적인 원인은 AWS 프로필의 `credential_process` 명령이 받을 수 없는 입력을 기다리는 경우, 그리고 컨테이너나 VM의 인스턴스 메타데이터 서비스(IMDS)가 체인의 프로브에 응답하지 않는 경우입니다.

v2.1.267 이전에는 메시지가 `API Error: AWS default-chain credential resolve timed out`으로 표시되었습니다.
v2.1.207 이전에는 체인이 멈추면 요청이 실패하지 않고 무기한 대기했습니다.

**조치 방법:**

* 같은 셸에서 같은 `AWS_PROFILE`로 `aws sts get-caller-identity`를 실행합니다. 이 명령도 멈춘다면 프로필을 수정하십시오. 대화형으로 입력을 요청하는 `credential_process` 명령이 흔한 원인입니다.
* Claude Code를 시작하기 전에 로그인 단계를 완료합니다. 예: `aws sso login --profile myprofile`
* `aws-vault`와 같은 래퍼를 통한 MFA 포함 SSO처럼 체인이 실제로 60초 이상 필요한 대화형 로그인을 실행한다면, [`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars)로 제한을 밀리초 단위로 늘리십시오

### Bedrock setup verification timed out waiting for AWS

[Bedrock 설정 마법사](https://code.claude.com/docs/ko/amazon-bedrock.md#sign-in-with-bedrock)의 자격 증명 확인 중 자격 증명 조회나 ID 확인과 같은 AWS 호출이 60초 제한 내에 완료되지 않았습니다. 마법사는 대기를 중단하고 확인 단계를 실패 처리합니다.

```text theme={null}
Timed out after 60s waiting for AWS. Check your network and proxy settings; if a credential helper needs longer to prompt you, raise CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS.
```

표시되는 숫자는 설정된 제한을 반영합니다. 기본값은 60초이며, [`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars)에 설정한 값이 있으면 그 값이 표시됩니다.

일반적인 원인은 SSO 토큰 갱신을 포함하여 AWS로의 요청을 지연시키는 네트워크나 프록시, 그리고 사용자에게 보이지 않는 입력을 계속 기다리는 자격 증명 도우미입니다. 도우미가 실제로 더 많은 시간이 필요한 경우에만 제한을 늘리십시오.

AWS로의 단일 요청이 멈추면 요청별 타임아웃으로 인해 자체적으로 실패할 수도 있으며, 이 경우 같은 단계에서 더 짧은 메시지가 표시됩니다.

```text theme={null}
A request to AWS timed out. Check your network and proxy settings, then try again.
```

모델 고정 단계에서 같은 시간 초과가 발생하면, 마법사는 두 메시지를 표시하는 대신 모델을 `unreachable`로 표시합니다.

**조치 방법:**

* 같은 셸에서 `aws sts get-caller-identity`를 실행합니다. 이 명령도 멈춘다면 지연은 Claude Code 외부, 즉 네트워크, 프록시 또는 AWS 프로필의 자격 증명 도우미에서 발생하는 것이므로 먼저 이를 해결하십시오.
* 마법사를 열기 전에 대화형 로그인을 완료합니다. 예: `aws sso login --profile myprofile`
* AWS 프로필의 자격 증명 도우미가 입력을 요청하는 데 실제로 60초 이상 필요하다면, [`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars)로 제한을 밀리초 단위로 늘리십시오

### Cloud gateway session expired

[Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)를 통해 로그인했으며, 이 머신에 저장된 게이트웨이 세션이 만료되어 갱신할 수 없거나, 예를 들어 게이트웨이의 [JWT 시크릿이 교체된](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#jwt-secret-rotation) 후와 같이 게이트웨이가 더 이상 해당 세션을 허용하지 않습니다. `claude`를 대화형으로 시작할 때 이 줄이 표시되면, 세션이 게이트웨이에서 로그아웃된 상태로 열린 것입니다.

```text theme={null}
Cloud gateway session expired — run /login to reconnect.
```

게이트웨이 자격 증명이 만료되고 Claude Code가 이를 갱신할 수 없으면 세션 도중에도 같은 줄이 표시될 수 있습니다.

[비대화형](https://code.claude.com/docs/ko/headless.md) 실행, 백그라운드 또는 기타 무인 세션, 또는 `claude auth` 이외의 `claude` 하위 명령에서는 게이트웨이가 더 이상 세션을 허용하지 않을 때 Claude Code가 대신 다음 메시지와 함께 종료됩니다.

```text theme={null}
Cloud gateway <url> no longer accepts this session. Start `claude` and sign in again with /login.
```

**조치 방법:**

* 세션에서 `/login`을 실행하고 브라우저 로그인을 완료합니다
* 비대화형 실행의 경우, 같은 환경에서 `claude`를 시작하고 `/login`을 실행한 다음 명령을 다시 실행합니다

### Sign-in timed out while waiting for you to continue

[Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 로그인 중에 게이트웨이가 로그인한 계정을 알려 주었고, Claude Code가 자격 증명을 저장하기 전에 해당 계정의 확인을 요청했습니다. 확인 화면을 로그인 자체의 만료 시간이 지나도록 열어 두었고, 게이트웨이가 이를 갱신할 수 있는 새로 고침 토큰을 발급하지 않았으므로, 계속 진행했을 때 Claude Code는 아무것도 저장하지 않았습니다.

```text theme={null}
Sign-in timed out while waiting for you to continue. Try again.
```

**조치 방법:**

* `/login`을 다시 실행하고 로그인이 만료되기 전에 계정을 확인합니다

### Gateway refused the request

[Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)를 통해 로그인한 상태에서 요청이 403을 반환했습니다. 게이트웨이 또는 그 뒤의 업스트림이 요청을 거부한 것입니다. 다시 로그인해도 거부는 바뀌지 않으므로, 메시지는 게이트웨이 관리자에게 문의하도록 안내합니다.

```text theme={null}
Gateway refused the request · signing in again won't change this — check with your gateway administrator · API Error: 403 ...
```

**조치 방법:**

* 게이트웨이 관리자에게 해당 요청을 조회해 달라고 요청합니다. `API Error:` 뒷부분에는 게이트웨이가 반환한 거부 내용이 포함되어 있습니다
* 관리자의 경우: 게이트웨이의 [액세스 제어 규칙](https://code.claude.com/docs/ko/claude-apps-gateway-config.md#http-tuning)은 403을 반환하며 [감사 로그](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#logs)에 그 사유가 기록됩니다. 업스트림의 인가 거부는 [업스트림 오류 메시지](https://code.claude.com/docs/ko/claude-apps-gateway-config.md#upstream-error-messages)에 따라 그대로 전달됩니다

v2.1.273 이전에는 게이트웨이 세션에서 발생한 403이 일반적인 `Please run /login` 또는 `Failed to authenticate` 메시지로 표시되었으며, 다시 로그인해도 거부가 해소되지 않았습니다.

## 네트워크 및 연결 오류

이러한 오류의 대부분은 Claude Code의 네트워크 요청이 목적지에 도달하지 못했거나, Claude Code와 API 사이의 무언가가 반환 경로에서 응답을 변경했음을 의미합니다. 항목에 실패한 아카이브 쓰기와 같은 로컬 원인도 있는 경우, 본문에 명시되어 있습니다. 이러한 오류는 일반적으로 로컬 네트워크, 프록시 또는 방화벽, 또는 클라우드 환경의 네트워크 정책에서 발생합니다.

### Unable to connect to API

API에 대한 TCP 연결이 실패했거나 완료되지 않았습니다. 일반적인 연결 오류 코드의 경우, 메시지는 실패의 종류를 명시하고 괄호 안에 코드를 유지합니다:

```text theme={null}
Unable to connect to API. Check your internet connection
Connection refused — a firewall or proxy may be blocking it (ConnectionRefused)
Can't reach the API server — check your internet or DNS (ENOTFOUND)
No internet route — check your connection or VPN (EHOSTUNREACH)
Couldn't connect through your proxy (ERR_PROXY_TUNNEL) — the proxy refused the tunnel: check its credentials and that it allows this host
Connection dropped (ECONNRESET)
Request timed out. Check your internet connection and proxy settings
```

Claude Code가 인식하지 못하는 코드는 `Unable to connect to API`로 표시되고 괄호 안에 코드가 나타납니다. 이러한 메시지 중 일부는 두 개 이상의 코드를 표시할 수 있습니다. 예를 들어 `Connection refused`는 `ConnectionRefused` 또는 `ECONNREFUSED`를 표시할 수 있고, `Can't reach the API server`는 `ENOTFOUND` 또는 `FailedToOpenSocket`을 표시할 수 있습니다.

v2.1.227 이전에는 이러한 각 코드화된 메시지가 `Unable to connect to API` 뒤에 코드가 붙는 형태였습니다. 예를 들어 `Unable to connect to API (ECONNREFUSED)`입니다.

일반적인 원인으로는 인터넷 접근 불가, `api.anthropic.com`을 차단하는 VPN, 또는 구성되지 않은 필수 회사 프록시가 있습니다.

**수행할 작업:**

* 동일한 셸에서 `curl -I https://api.anthropic.com`을 실행하여 API 호스트에 도달할 수 있는지 확인합니다. Windows PowerShell에서는 `curl.exe -I https://api.anthropic.com`을 사용하여 기본 제공 `Invoke-WebRequest` 별칭이 사용되지 않도록 합니다.
* 회사 프록시 뒤에 있는 경우, Claude Code를 시작하기 전에 `HTTPS_PROXY`를 설정하고 [네트워크 구성](https://code.claude.com/docs/ko/network-config.md)을 참조합니다.
* LLM 게이트웨이 또는 릴레이를 통해 라우팅하는 경우, [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)을 해당 주소로 설정합니다. 설정은 [Claude Code를 LLM 게이트웨이에 연결](https://code.claude.com/docs/ko/llm-gateway-connect.md)을 참조합니다.
* `ANTHROPIC_BASE_URL`이 이미 게이트웨이를 가리키고 있는데 모든 요청이 `Connection dropped`로 끝나는 경우, Claude Code가 기본적으로 보내는 도구 검색 필드를 게이트웨이가 거부하고 있는지 확인합니다. 확인하려면 [LLM 게이트웨이를 통한 도구 검색](https://code.claude.com/docs/ko/mcp.md#tool-search-through-a-gateway)에 설명된 대로 `ENABLE_TOOL_SEARCH=false`를 설정한 다음 다시 시도합니다. v2.1.304 이전에는 `ENABLE_TOOL_SEARCH`로 켜지 않는 한 게이트웨이 뒤에서 도구 검색이 꺼져 있었습니다.
* 방화벽이 [네트워크 액세스 요구 사항](https://code.claude.com/docs/ko/network-config.md#network-access-requirements)에 나열된 호스트를 허용하는지 확인합니다.
* 간헐적 실패는 [자동으로 재시도](#automatic-retries)됩니다.

`curl`이 성공하지만 Claude Code가 여전히 실패하는 경우, 원인은 일반적으로 네트워크 자체가 아니라 런타임과 네트워크 사이의 무언가입니다:

* `ANTHROPIC_BASE_URL`이 설정되어 있는지 `echo $ANTHROPIC_BASE_URL`을 실행하여 확인하거나, PowerShell에서 `echo $env:ANTHROPIC_BASE_URL`을 실행하고 [설정 파일](https://code.claude.com/docs/ko/settings.md)의 `env` 블록에서 찾습니다. 설정되면 Claude Code는 모델 요청을 `api.anthropic.com` 대신 해당 주소로 보내므로, 더 이상 실행되지 않는 로컬 프록시 또는 게이트웨이를 가리키는 남은 값은 `curl`이 API에 도달하더라도 `Connection refused`를 생성합니다. 셸 프로필 또는 설정에서 제거하고 새 터미널에서 Claude Code를 시작합니다.
* Linux 및 WSL에서 `/etc/resolv.conf`에서 도달할 수 없는 네임서버를 확인합니다. 특히 WSL은 호스트에서 손상된 리졸버를 상속할 수 있습니다.
* macOS에서 연결이 끊어지거나 제거된 VPN 클라이언트는 터널 인터페이스 또는 라우팅 규칙을 남길 수 있습니다. `ifconfig`에서 오래된 `utun` 인터페이스를 확인하고 시스템 설정에서 VPN의 네트워크 확장을 제거합니다.
* Docker Desktop 및 유사한 컨테이너 런타임은 아웃바운드 트래픽을 가로챌 수 있습니다. 이를 배제하기 위해 종료하고 다시 시도합니다.

### Unable to connect to Anthropic services

첫 실행 설정 중에 Claude Code는 로그인 단계를 표시하기 전에 `api.anthropic.com` 및 `platform.claude.com`에 도달할 수 있는지 확인합니다. 두 확인 중 하나라도 실패하면 Claude Code는 이유를 인쇄하고 종료합니다.

```text theme={null}
Unable to connect to Anthropic services
Failed to connect to api.anthropic.com: ECONNREFUSED
Connection to api.anthropic.com timed out after 10 seconds
A proxy is configured via HTTPS_PROXY. Check that it allows connections to the host above.
```

Claude Code는 API 요청과 동일한 [프록시 구성](https://code.claude.com/docs/ko/network-config.md)을 통해 확인을 보내고 각 프로브에 10초를 제공합니다. 실패한 프로브가 프록시를 통과한 경우, 메시지는 `HTTPS_PROXY`와 같이 이를 구성한 환경 변수의 이름을 지정합니다. v2.1.222 이전에는 확인이 타임아웃이 없는 다른 프록시 전송을 사용했습니다. `https://` 스키마가 있는 프록시 URL 뒤에서 `Checking connectivity...`에서 무한정 정지될 수 있었고, 동일한 프록시를 통한 API 요청이 성공하더라도 실패할 수 있었습니다.

Claude Code는 [관리형 설정 파일, MDM 정책 또는 정책 도우미](https://code.claude.com/docs/ko/managed-settings.md)가 [`forceLoginMethod`](https://code.claude.com/docs/ko/settings-reference#forceloginmethod)를 `"gateway"`로 설정하거나 `forceLoginMethod` 없이 [`forceLoginGatewayUrl`](https://code.claude.com/docs/ko/settings-reference#forcelogingatewayurl)을 설정할 때 이 확인을 건너뜁니다. 두 구성 중 하나를 사용하면 Claude Code는 Anthropic 로그인 방법이 아닌 **Cloud gateway** 화면에서 로그인 단계를 엽니다. Claude Code는 또한 머신에 관리형 설정 소스가 존재하지만 읽을 수 없을 때 확인을 건너뜁니다. 해당 소스가 게이트웨이 구성을 보유할 수 있기 때문입니다. v2.1.247 이전에는 Claude Code가 이 구성에서도 확인을 실행했고, Anthropic의 엔드포인트에 도달할 수 없을 때 이 오류로 종료했습니다.

Claude Code는 관리형 설정이 없는 머신에서 사용자 자신의 `~/.claude/settings.json`이 `forceLoginMethod` 및 `forceLoginGatewayUrl`로 [게이트웨이를 지정](https://code.claude.com/docs/ko/claude-apps-gateway#set-the-gateway-url-in-user-settings)하는 경우에도 확인을 건너뜁니다. v2.1.295 이전에는 Claude Code가 이 경우에도 확인을 실행했습니다.

**수행할 작업:**

* 메시지가 프록시 변수의 이름을 지정하는 경우, 해당 값이 올바른 프록시를 가리키는지 확인하고 네트워크 팀에 메시지의 호스트에 대한 HTTPS 연결을 허용하도록 요청합니다. [네트워크 구성](https://code.claude.com/docs/ko/network-config.md)을 참조합니다.
* [Unable to connect to API](#unable-to-connect-to-api)의 확인을 진행합니다. 거기의 `curl` 테스트 및 방화벽 지침이 이 확인에도 적용됩니다.
* 네트워크가 열려 있고 실패가 지속되는 경우, Claude Code가 [해당 국가에서 사용 가능하지 않을 수 있습니다](https://www.anthropic.com/supported-countries).

### Socket is closed

`Socket is closed`는 스트리밍 응답을 전달하는 연결이 응답이 여전히 도착하는 동안 닫혔음을 의미합니다. 가장 일반적인 원인은 Windows의 회사 프록시가 응답 중간에 설정된 터널을 삭제하는 것입니다.

응답이 진행된 정도에 따라 Claude Code는 요청을 재시도하거나, Claude가 생성한 내용을 유지하거나, 턴을 종료합니다. [자동 재시도](#automatic-retries)를 참조합니다.

v2.1.214 이전에는 Claude Code가 이 실패를 재시도하지 않았고, 턴이 `Socket is closed`를 포함하는 오류로 중지되었습니다.

**수행할 작업:**

* 이 오류가 표시되면 `claude update`로 v2.1.214 이상으로 업데이트한 다음 메시지를 다시 보냅니다.
* 업데이트 후 동일한 프록시 뒤에서 턴이 계속 실패하는 경우, [Unable to connect to API](#unable-to-connect-to-api)를 진행하고 [네트워크 구성](https://code.claude.com/docs/ko/network-config.md)에서 프록시 설정을 확인합니다.

### API returned an empty or malformed response

Claude Code는 실패한 스트리밍 요청의 비스트리밍 재시도가 HTTP 성공 상태를 받지만 본문이 Claude API 메시지가 아닐 때 이 오류를 표시합니다. 일반적으로 HTML 오류 또는 로그인 페이지, 빈 본문 또는 다른 형식의 JSON입니다. 프록시, 게이트웨이 또는 네트워크 로그인 페이지가 API 대신 응답하는 것이 일반적인 원인입니다. Claude Code는 요청을 재시도하지 않으며, 턴이 이 오류로 종료됩니다.

```text theme={null}
API returned an empty or malformed response (HTTP 200) — check for a proxy or gateway intercepting the request.
```

그 시작 후, 메시지는 반환된 내용과 실패한 요청을 보고합니다:

* 콘텐츠 유형, `body is an HTML page` 또는 `empty body`와 같은 본문의 종류, 바이트 단위의 크기, 응답이 Anthropic 요청 ID를 전달했는지 여부를 포함하는 `Response:` 절. 응답이 `nginx` 또는 `cloudflare`와 같은 인식 가능한 서버의 이름을 지정하거나 `cf-ray` 또는 `via`와 같은 중간 헤더를 전달하는 경우, 절은 이들도 나열합니다.
* 실패한 스트리밍 요청의 ID와 재시도를 트리거한 실패의 이름을 지정하는 문장. 스트림이 실패 전에 열린 경우, 도착한 스트림 이벤트의 수와, 이벤트가 하나라도 도착했다면 시도가 실패했을 때 스트림이 얼마나 오래 침묵했는지도 보고합니다.

v2.1.234 이전에는 메시지가 `intercepting the request` 후에 종료되었습니다.

v2.1.271 이전에는 `text/plain`과 같은 비 JSON 콘텐츠 유형 아래에서 유효한 API 메시지를 전달한 회신도 이 오류로 턴을 종료했습니다. 일부 LLM 게이트웨이는 비스트리밍 회신에 해당 콘텐츠 유형을 사용합니다.

**수행할 작업:**

* `Response:` 절을 읽어 어느 시스템이 응답했는지 확인합니다. HTML 본문, Anthropic 요청 ID 없음, 또는 `nginx` 또는 `cloudflare`와 같은 명명된 서버는 Claude Code와 API 사이의 무언가가 대신 응답했음을 의미합니다.
* [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway-connect.md#troubleshoot-gateway-errors)를 통해 라우팅하는 경우, 직접 요청으로 경로를 테스트하고 비 API 응답을 반환하는 홉을 수정합니다.
* 게스트 Wi-Fi와 같은 로그인 페이지가 있는 네트워크에서 브라우저에서 로그인을 완료한 다음 다시 시도합니다.
* 게이트웨이를 통한 비스트리밍 경로만 손상된 경우, [`CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정하여 스트리밍 엔드포인트 자체가 `404`를 반환할 때를 제외하고 이 폴백을 끕니다. 여기서 Claude Code는 여전히 폴백합니다.

### Streaming response ended before any complete data was received

모델 공급자의 스트리밍 응답이 사용 가능한 데이터를 전달하지 않고 완료되었으므로 Claude Code는 턴을 완료하기 위해 스트리밍 없이 요청을 다시 보냈습니다. Claude Code는 경고를 세션당 한 번, 대화형 세션에서만 표시합니다. v2.1.239 이전에는 Claude Code가 스트리밍 없이 자동으로 재시도했습니다.

```text theme={null}
Streaming response ended before any complete data was received. Retrying without streaming. If this keeps happening, check any proxy or gateway between Claude Code and your model provider.
```

Claude Code는 각 영향을 받는 요청을 두 번 보냅니다: 빈 스트리밍 시도 및 재시도. 일반적인 원인은 반환 경로에서 스트리밍 응답 본문을 소비하거나 변환하는 프록시 또는 게이트웨이입니다.

**수행할 작업:**

* Claude Code와 모델 공급자 사이의 프록시 또는 게이트웨이를 구성하여 스트리밍 응답 본문과 해당 헤더를 수정되지 않은 상태로 전달합니다.
* [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md)에서 헤더 및 본문 요구 사항에 대해 [게이트웨이 또는 프록시 뒤의 스트리밍 오류](https://code.claude.com/docs/ko/amazon-bedrock.md#streaming-errors-behind-a-gateway-or-proxy)를 참조합니다.

### Bedrock 스트리밍 응답에 예상치 못한 content-type이 있습니다

Claude Code와 [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md) 사이의 게이트웨이 또는 프록시가 스트리밍 응답 본문 또는 해당 `Content-Type` 헤더를 변환하고 있습니다. Amazon Bedrock은 응답을 `application/vnd.amazon.eventstream`으로 스트리밍합니다. Claude Code는 읽을 수 없는 본문을 디코딩하는 대신 다른 content-type을 보고하는 성공적인 스트리밍 응답을 거부합니다. Claude Code는 요청을 재시도하지 않습니다.

```text theme={null}
Bedrock streaming response has content-type "text/event-stream"; expected "application/vnd.amazon.eventstream". A gateway or proxy between Claude Code and Bedrock is likely transforming the response body — Bedrock's binary event-stream format must be passed through unmodified. Set CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD=1 to suppress this check while the gateway is being fixed.
```

v2.1.208 이전에는 동일한 잘못된 구성이 전체 응답이 버퍼링된 후 `API Error: Truncated event message received`로 표시되었습니다.

**수행할 작업:**

* 게이트웨이를 구성하여 `InvokeModelWithResponseStream` 응답 본문과 해당 `Content-Type` 헤더를 수정되지 않은 상태로 전달합니다. 스트림을 서버 전송 이벤트로 다시 내보내는 중간자가 일반적인 원인입니다.
* [`CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD=1`](https://code.claude.com/docs/ko/env-vars)을 설정하면 이 오류가 숨겨지지만, Claude Code는 다시 작성된 헤더 아래에서 이진 본문을 디코딩하지 않으므로 이러한 요청은 더 느린 비스트리밍 경로로 폴백합니다. [게이트웨이 또는 프록시 뒤의 스트리밍 오류](https://code.claude.com/docs/ko/amazon-bedrock.md#streaming-errors-behind-a-gateway-or-proxy)를 참조합니다.

### SSL 인증서 오류

네트워크의 프록시 또는 보안 어플라이언스가 자체 인증서로 TLS 트래픽을 가로채고 있으며, Claude Code가 이를 신뢰하지 않습니다.

```text theme={null}
Unable to connect to API: SSL certificate verification failed (UNABLE_TO_GET_ISSUER_CERT_LOCALLY). The certificate comes from an authority Claude Code doesn't trust, usually a TLS-inspecting corporate proxy or a gateway signed by a private CA: set NODE_EXTRA_CA_CERTS to that CA bundle, or add it to the system certificate store · see https://code.claude.com/docs/en/network-config
Unable to connect to API: Self-signed certificate detected (SELF_SIGNED_CERT_IN_CHAIN). The certificate comes from an authority Claude Code doesn't trust, usually a TLS-inspecting corporate proxy or a gateway signed by a private CA: set NODE_EXTRA_CA_CERTS to that CA bundle, or add it to the system certificate store · see https://code.claude.com/docs/en/network-config
```

v2.1.273 이전에는 두 메시지 모두 OpenSSL 코드 또는 `NODE_EXTRA_CA_CERTS` 힌트 없이 `Check your proxy or corporate SSL certificates`에서 종료되었습니다.

v2.1.199부터 인증서 검증 실패는 재시도되지 않으므로 이 오류는 전체 [재시도 예산](#automatic-retries) 후가 아닌 첫 시도에 나타납니다. 이전 버전은 표시하기 전에 몇 분 동안 재시도했습니다. 핸드셰이크 타임아웃과 같은 일시적 TLS 조건은 여전히 재시도됩니다.

`/login` 및 시작 연결 확인 중에 동일한 실패는 다른 메시지를 생성합니다:

```text theme={null}
SSL certificate error (UNABLE_TO_GET_ISSUER_CERT_LOCALLY). If you are behind a corporate proxy or TLS-intercepting firewall, set NODE_EXTRA_CA_CERTS to your CA bundle path, or ask IT to allowlist *.anthropic.com. Run `claude doctor` for details.
```

[Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md)에서 Claude Code 자체가 AWS로 보내는 요청(예: STS 및 SSO 역할 자격 증명 호출, 모델 검색 및 설정 마법사의 확인)은 동일한 인증서 구성에 따라 달라집니다. [TLS 검사 프록시 뒤의 인증서 오류](https://code.claude.com/docs/ko/amazon-bedrock.md#certificate-errors-behind-a-tls-inspecting-proxy)를 참조합니다.

**수행할 작업:**

* 조직의 CA 번들을 내보내고 `NODE_EXTRA_CA_CERTS=/path/to/ca-bundle.pem`으로 Claude Code를 가리킵니다.
* 전체 설정 지침은 [네트워크 구성](https://code.claude.com/docs/ko/network-config.md#custom-ca-certificates)을 참조합니다.
* `NODE_TLS_REJECT_UNAUTHORIZED=0`을 설정하지 마십시오. 이는 인증서 검증을 완전히 비활성화합니다.

### 클라우드 세션에서 호스트가 허용되지 않음

클라우드 세션 또는 클라우드 예약 작업의 아웃바운드 HTTP 요청이 환경의 네트워크 정책에 의해 차단되었습니다.

```text theme={null}
HTTP 403
x-deny-reason: host_not_allowed
```

대상의 실제 인증서와 일치하지 않는 TLS 인증서도 볼 수 있습니다. 클라우드 세션은 네트워크 정책을 적용하는 프록시를 통해 아웃바운드 트래픽을 라우팅하므로, 일치하지 않는 인증서는 프록시가 연결을 종료했음을 의미하며, 대상이 아닙니다.

이것은 클라이언트 측 네트워크 문제가 아닙니다. 클라우드 세션 및 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)은 세션의 네트워크를 통한 아웃바운드 트래픽이 [클라우드 환경의](https://code.claude.com/docs/ko/cloud-environments.md) 허용 목록으로 필터링되는 샌드박스 VM 내에서 실행됩니다:

* **GitHub 및 커넥터 트래픽**: [GitHub 작업](https://code.claude.com/docs/ko/cloud-environments.md#github-proxy) 및 MCP 커넥터 트래픽은 별도의 채널을 사용하므로 다른 호스트가 차단되는 동안에도 계속 작동할 수 있습니다.
* **기본 환경**: **기본** 환경은 **신뢰할 수 있는** 액세스를 사용하며, 이는 패키지 레지스트리, 클라우드 공급자 API, 컨테이너 레지스트리 및 일반적인 개발 도메인의 [기본 허용 목록](https://code.claude.com/docs/ko/cloud-environments.md#default-allowed-domains)을 허용하고 해당 경로의 다른 도메인을 차단합니다.

**수행할 작업:**

이러한 단계는 자신의 환경 중 하나를 변경합니다. [조직 공유 환경](https://code.claude.com/docs/ko/cloud-environments.md#organization-shared-environments)은 선택기에서 읽기 전용으로 열리므로, [관리자 설정](https://claude.ai/admin-settings)의 **클라우드 환경** 페이지에서 Owner에게 네트워크 액세스를 변경하도록 요청합니다.

* [클라우드 예약 작업의 양식](https://code.claude.com/docs/ko/routines.md#environments-and-network-access) 또는 클라우드 세션을 시작하는 [환경 선택기](https://code.claude.com/docs/ko/cloud-environments.md#configure-your-environment)에서 환경을 편집용으로 엽니다.
* **클라우드 환경 편집** 대화 상자에서 **네트워크 액세스**를 **신뢰할 수 있는**에서 **사용자 정의**로 변경한 다음 차단된 도메인을 **허용된 도메인**에 추가합니다. 한 줄에 하나의 도메인을 입력합니다. **또한 일반적인 패키지 관리자의 기본 목록 포함**을 확인하여 사용자 정의 도메인과 함께 [기본 허용 목록](https://code.claude.com/docs/ko/cloud-environments.md#default-allowed-domains)을 유지합니다. 제한 없는 액세스를 원하는 경우 대신 **전체**를 선택합니다.
* **변경 사항 저장**을 클릭합니다. 다음 실행은 업데이트된 허용 목록을 사용합니다. 이미 열려 있는 클라우드 세션의 경우, [네트워크 액세스 변경이 기존 세션에 도달할 때](https://code.claude.com/docs/ko/cloud-environments.md#network-access)를 참조합니다.

액세스 수준 및 기본 허용 목록은 [네트워크 액세스](https://code.claude.com/docs/ko/cloud-environments.md#network-access)를 참조합니다. 로컬 CLI 세션은 이 정책의 영향을 받지 않습니다.

### 프록시가 연결을 거부했습니다

`HTTPS_PROXY` 또는 관련 [프록시 변수](https://code.claude.com/docs/ko/network-config.md#environment-variables)에서 설정한 프록시를 통해 Claude가 [아티팩트](https://code.claude.com/docs/ko/artifacts.md)를 읽을 때 이 메시지가 표시됩니다. 아티팩트 콘텐츠는 `*.frame.claudeusercontent.com`에서 제공되므로 Claude Code는 먼저 프록시에 해당 호스트에 대한 터널을 열도록 요청하는 `CONNECT` 요청을 보냅니다. 프록시가 거부하면 아무것도 호스트에 도달하지 않으며, 메시지는 프록시의 HTTP 상태를 전달합니다:

```text theme={null}
artifact content fetch failed (proxy refused the connection: HTTP 407)
artifact content fetch failed (proxy refused the connection: HTTP 403)
the proxy refused the connection to the artifact's content host (HTTP 502)
```

상태는 `CONNECT`에 대한 프록시의 응답입니다. 호스트는 응답하지 않았으므로 각 상태는 다른 수정을 가리킵니다:

* `HTTP 407`: 프록시가 받지 못한 자격 증명이 필요합니다. [기본 인증](https://code.claude.com/docs/ko/network-config.md#basic-authentication)이 표시하는 대로 프록시 URL에 넣습니다.
* `HTTP 403`: 프록시가 `*.frame.claudeusercontent.com`으로의 터널링을 거부합니다. 프록시를 실행하는 사람에게 해당 호스트를 허용하도록 요청합니다. [네트워크 액세스 요구 사항](https://code.claude.com/docs/ko/network-config.md#network-access-requirements)에 나열되어 있습니다.
* `HTTP 502`와 같은 다른 상태: 프록시가 호스트에 도달하지 못하는 등의 자체 이유로 터널을 열지 않았습니다. 프록시의 로그에서 상태를 찾습니다.
* 상태 대신 `unreadable reply`: 프록시 주소의 무언가가 HTTP 상태 줄로 응답하지 않았습니다. 주소가 HTTP 프록시인지 확인합니다.

**수행할 작업:**

* [프록시 구성](https://code.claude.com/docs/ko/network-config.md#proxy-configuration)이 설명하는 대로 프록시 변수의 주소와 자격 증명을 확인한 다음 Claude Code를 시작하는 셸에서 `curl -x http://proxy.example.com:8080 -I https://api.anthropic.com`을 실행합니다. 자신의 프록시 URL을 사용합니다. Windows PowerShell에서 `curl.exe`를 실행합니다. 이 프로브가 동일한 방식으로 실패하면 먼저 프록시 설정을 수정합니다. 성공하면 거부는 아티팩트 호스트에만 해당됩니다.
* 네트워크가 Claude Code가 아티팩트 호스트에 직접 도달하도록 허용하는 경우, `.frame.claudeusercontent.com`을 [`NO_PROXY`](https://code.claude.com/docs/ko/network-config#environment-variables)에 추가합니다. 항목을 좁게 유지합니다: 더 넓은 `.claudeusercontent.com` 항목도 [IP 허용 목록](https://code.claude.com/docs/ko/network-config.md#organization-ip-allowlists-and-proxy-egress)이 있는 조직이 프록시에 유지해야 하는 `bridge.claudeusercontent.com`에 대한 프록시를 우회합니다.

v2.1.238 이전에는 Claude Code가 거부된 터널을 일반 네트워크 오류로 보고했습니다.

### 클라우드 환경 서비스가 빈 응답 또는 예상치 못한 응답을 반환했습니다

Claude Code는 CLI에서 클라우드 세션을 만들거나 [`/remote-env`](https://code.claude.com/docs/ko/cloud-environments#select-an-environment-from-the-cli)를 실행할 때와 같은 여러 지점에서 [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md) 목록을 요청합니다. 서버의 응답을 읽을 수 없으면 다음 메시지 중 하나를 표시합니다:

```text theme={null}
The cloud environments service returned an empty response (HTTP 200 with no body). This is usually temporary — try again in a moment.
The cloud environments service returned a response in an unexpected format (HTTP 200 with a non-JSON body). This is usually temporary — try again in a moment.
The cloud environments service returned a response in an unexpected format (HTTP 200 without a usable environments list). This is usually temporary — try again in a moment.
```

서버는 요청을 수락했지만 환경 목록이 아닌 본문으로 응답했습니다: 비어 있음, JSON이 아님, 또는 목록이 없는 JSON. 이는 일반적으로 서비스 측 중단을 동반하며 자체적으로 해결됩니다. 목록을 요청한 사용 환경에 따라 Claude Code는 `/remote-env` 대화 상자에서 `couldn't list environments:`와 같은 접두사를 추가할 수 있습니다.

**수행할 작업:**

* 작업을 다시 시도합니다. Claude Code는 매번 목록을 다시 요청합니다.
* 메시지가 계속 나타나면 활성 인시던트에 대해 [status.claude.com](https://status.claude.com)을 확인합니다.

v2.1.236 이전에는 Claude Code가 이러한 메시지 대신 원시 JavaScript TypeError를 표시했습니다.

### Failed to fetch session from Sessions API

이 메시지는 Claude Code가 [터미널로 가져오도록 요청한 클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#from-cloud-to-terminal)을 찾았지만 Anthropic 서버에서 해당 세션의 대화 기록을 읽을 수 없어 세션을 열지 않았음을 의미합니다:

```text theme={null}
Failed to fetch session from Sessions API: Failed to fetch session logs
```

이 메시지는 `claude --teleport`, `/teleport`를 실행하거나 [`/tasks`](https://code.claude.com/docs/ko/commands) 목록에서 세션을 선택한 후에 표시됩니다. `claude --teleport <session-id>`는 이 메시지를 출력하고 코드 1로 종료합니다.

**수행할 작업:**

* 동일한 Teleport를 다시 실행합니다. 같은 방식으로 실패하면 [문제를 보고](#report-an-error)합니다.

v2.1.296 이전에는 Claude Code가 실패한 읽기를 재시도하지 않았고, 읽기에 실패한 후 이 메시지를 출력하는 대신 빈 대화로 세션을 열고 성공을 보고할 수 있었습니다.

### Couldn't reconnect to your Remote Control session

```text theme={null}
Couldn't reconnect to your Remote Control session. Retry, or start a fresh session without --resume.
```

`claude --resume` 또는 `claude --continue`로 재개하면 해당 대화에 기록된 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션에 다시 연결됩니다. 이 메시지는 네트워크 중단 또는 서버 오류와 같이 일시적일 수 있는 이유로 재연결이 실패했음을 의미하므로 Claude Code는 원격 세션이 여전히 존재하는지 확인할 수 없습니다. 로컬 세션은 Remote Control 없이 계속 실행됩니다.

**수행할 작업:**

* `/remote-control`을 실행하여 연결을 다시 시도합니다.
* `claude --remote-control`로 새 세션을 시작하여 새 Remote Control 세션을 만듭니다.
* 다른 Remote Control 시작 메시지는 [Remote Control 문제 해결](https://code.claude.com/docs/ko/remote-control.md#troubleshooting)을 참조합니다.

서버가 대신 이전 세션이 없다고 보고하면 이 메시지가 표시되지 않습니다. Claude Code는 새 세션을 시작하거나 [`Previous session is unavailable — run /remote-control to start a new one`](https://code.claude.com/docs/ko/remote-control#previous-session-is-unavailable)을 표시합니다.

### Sessions ended while this machine was offline

Claude Code는 머신이 오프라인 상태인 동안 서버가 머신이 제공하던 Remote Control 환경을 정리할 만큼 충분히 오래 있었던 후 [`claude remote-control`](https://code.claude.com/docs/ko/remote-control#start-a-remote-control-session)을 실행하는 터미널에 이 메시지를 표시합니다. 해당 환경의 세션이 종료되었으며 재개할 수 없습니다. 개수는 종료된 세션의 수입니다.

```text theme={null}
2 sessions ended while this machine was offline — the environment was cleaned up on the server and can't be resumed.
```

**수행할 작업:**

* Claude Code가 이 메시지 아래에 유지된 worktree를 나열할 때 이들에서 커밋되지 않은 작업을 가져옵니다.
* `claude remote-control`을 실행하여 새로운 환경을 시작합니다.

### Couldn't share the transcript

[세션 품질 설문 조사](https://code.claude.com/docs/ko/data-usage.md#session-quality-surveys)와 같은 설문 조사 프롬프트에서 세션 트랜스크립트를 공유하기로 동의한 후 Claude Code는 이를 Anthropic에 업로드하거나 타사 공급자, [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 세션 및 Anthropic 자격 증명을 사용할 수 없을 때 로컬 아카이브를 대신 저장합니다. 이 메시지는 공유가 완료되지 않았음을 의미합니다.

```text theme={null}
Couldn't share the transcript.
```

업로드는 8 MiB 제한에 맞아야 합니다. 긴 세션에서 Claude Code는 점진적으로 공유의 일부를 삭제합니다. 마지막 요청의 모델 설정이 먼저, 그 다음 구조화된 대화 및 서브에이전트 트랜스크립트이며, 축소된 버전을 보낼 수 없거나 네트워크 또는 서버 오류가 업로드를 중지할 때 이 메시지를 표시합니다. Claude Code가 로컬 아카이브를 대신 저장할 때, 메시지는 아카이브를 쓸 수 없었음을 의미합니다.

**수행할 작업:**

* `/feedback`을 실행하여 발생한 상황에 대한 설명과 함께 트랜스크립트를 보냅니다. 환경에서 `/feedback`을 사용할 수 없는 경우 [오류 보고](#report-an-error)를 참조합니다.
* 다른 요청도 실패하는 경우, 네트워크 연결을 확인하고 [Unable to connect to API](#unable-to-connect-to-api)를 참조합니다.

### Couldn't send feedback

`Couldn't send feedback`으로 시작하는 메시지는 [`/feedback`, `/bug` 또는 `/share` 대화 상자](https://code.claude.com/docs/ko/commands#all-commands)에서 제출한 보고서나 큐에 있는 [피드백 초안](https://code.claude.com/docs/ko/tools-reference.md#sendfeedback-tool-behavior)을 피드백 서비스가 확인하지 않았음을 의미합니다. 수신되지 않은 것으로 간주합니다. 콜론 뒤에 조직에 관한 문장이 이어지면 조직이 피드백을 거부하는 것이며, 같은 보고서는 같은 응답을 받습니다.

다음 두 예시 중 두 번째는 조직의 거부입니다:

```text wrap theme={null}
Couldn't send feedback (couldn't reach the service). If it keeps failing, you can file at https://github.com/anthropics/claude-code/issues instead.

Couldn't send feedback: Feedback has not been enabled for your organization. To report a bug, open an issue at https://github.com/anthropics/claude-code/issues. Issues are public, so leave out anything confidential.
```

**수행할 작업:**

* **로그인되지 않음**: 메시지가 `: not signed in. Run /login, then retry.`로 이어집니다. `/login`을 실행한 다음 다시 보냅니다.
* **조직의 거부**: 예를 들어 `: Feedback has not been enabled for your organization.` 또는 `: Feedback collection is not available for organizations with custom data retention policies.`입니다. 메시지에 `To report a bug, open an issue`가 추가되어 있으면 [github.com/anthropics/claude-code/issues](https://github.com/anthropics/claude-code/issues)에서 이슈를 엽니다. 큐에 있는 초안은 큐에 남아 있으며, [초안을 삭제](https://code.claude.com/docs/ko/tools-reference.md#discard-or-keep-a-draft)할 수 있습니다.
* **거부된 자격 증명**: 메시지가 `: the sign-in this session uses is not allowed to send feedback` 또는 `: the server did not accept the credentials this session uses`로 이어집니다. Claude Code 프롬프트에서 `/status`를 실행하여 이 세션이 보내는 로그인, 토큰 또는 API 키를 확인합니다.
* **`Couldn't send feedback` 바로 뒤의 `(request timed out)` 또는 `(couldn't reach the service)`**: 보고서 또는 큐에 있는 초안을 다시 보냅니다. 대화 상자는 텍스트를 유지하며, 큐에 있는 초안의 메시지에는 `The draft is still queued.`라고 표시됩니다. 다른 요청도 실패하는 경우, 네트워크 연결을 확인하고 [Unable to connect to API](#unable-to-connect-to-api)를 참조합니다. 계속 실패하면 [github.com/anthropics/claude-code/issues](https://github.com/anthropics/claude-code/issues)에서 보고서를 제출합니다.
* **`Couldn't send feedback` 바로 뒤의 `(server returned <status>)` 또는 이유 없음**: 상태는 서비스의 응답 코드입니다. 서비스가 자체 메시지를 보낸 경우 `(server returned 403: Access Forbidden)`처럼 상태 뒤에 이어집니다. 계속 실패하면 [github.com/anthropics/claude-code/issues](https://github.com/anthropics/claude-code/issues)에서 보고서를 제출합니다.

github.com/anthropics/claude-code의 이슈는 공개되므로, 이슈를 열 때 코드, 트랜스크립트 및 기타 기밀 정보는 제외합니다.

v2.1.281 이전에는 Remote Control **중지** 또는 긴급 교차 세션 메시지가 대화가 열려 있는 동안 도착했을 때 모든 전송이 이 메시지로 실패했습니다. 이러한 버전에서는 대화를 닫고, 다시 열고, 다시 보냅니다.

### Feedback payload too large

[피드백 초안](https://code.claude.com/docs/ko/tools-reference.md#sendfeedback-tool-behavior)의 [검토 화면](https://code.claude.com/docs/ko/tools-reference.md#review-and-edit-a-draft)에 표시되는 이 메시지는 서비스가 초안을 수락했다는 확인을 Claude Code가 받지 못했음을 의미합니다. 수신되지 않은 것으로 간주합니다. 초안은 `/feedback` 큐에 남아 있으므로 다시 보낼 수 있습니다.

```text wrap theme={null}
Feedback payload too large. Try again without the transcript, or shorten the details.
```

**수행할 작업:**

* 검토 화면에서 **Send transcript**를 `no`로 설정한 다음 초안을 다시 보냅니다. 세부 정보를 줄여도 최대 10 KB의 텍스트만 줄어들며, 이는 초안의 세부 정보에 담을 수 있는 전체 용량입니다.

### 절전 또는 시계 변경 중 MCP 서버 연결 시간 초과

이 메시지는 [MCP 서버](https://code.claude.com/docs/ko/mcp.md)에 대한 연결이 시간 초과되었으며, 연결 시도 중에 시스템 시계가 앞으로 건너뛴 것을 Claude Code가 발견했음을 의미합니다:

```text theme={null}
MCP server "<name>" connection timed out. Your computer went to sleep or its clock changed while connecting.
```

Claude Code는 컴퓨터가 절전 상태였는지 시계가 앞으로 설정되었는지 구분할 수 없으므로 메시지에 두 가지를 모두 명시합니다.

**수행할 작업:**

서버에 다시 연결하고, 시도가 끝날 때까지 컴퓨터가 절전 상태로 전환되지 않도록 합니다. 서버가 연결되면 수정할 것이 없습니다.

* **대화형 세션에서**: `/mcp`를 실행하고 서버를 선택한 다음 **Reconnect**를 선택합니다.
* **셸에서**: [`claude -p`](https://code.claude.com/docs/ko/headless), [`claude mcp list`](https://code.claude.com/docs/ko/mcp#managing-your-servers) 또는 `claude mcp get` 명령을 다시 실행합니다. 그 후 서버가 `Skipping connection (recent failure cached`로 시작하는 메시지와 함께 실패하면 15분을 기다린 후 명령을 다시 실행합니다.
* **[Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 애플리케이션에서**: TypeScript에서는 [`reconnectMcpServer()`](https://code.claude.com/docs/ko/agent-sdk/typescript#methods)를, Python에서는 [`ClaudeSDKClient.reconnect_mcp_server()`](https://code.claude.com/docs/ko/agent-sdk/python#methods)를 호출합니다.
* **서버가 다시 실패하는 경우**: 메시지가 이 메시지와 다르면 [MCP 서버가 연결되지 않을 때 확인할 사항](https://code.claude.com/docs/ko/mcp-quickstart.md#troubleshooting)을 참조합니다. 컴퓨터가 절전 상태로 전환되지 않았고 시계를 변경한 것이 없는데도 이 메시지가 다시 나타나면 [오류 보고](#report-an-error)를 참조합니다.

v2.1.307 이전에는 Claude Code가 이 메시지 대신 `MCP server "<name>" connection timed out after <N>ms`와 같은 시간 초과 메시지를 표시했습니다.

## 요청 오류

이 오류들은 요청의 내용과 관련이 있습니다. 대부분은 API가 요청을 거부한 후 반환되며, 일부는 요청이 전송되기 전에 Claude Code가 로컬에서 생성합니다.

### Prompt is too long

대화와 첨부 파일의 합이 모델의 컨텍스트 윈도우를 초과했습니다.

```text theme={null}
Prompt is too long
```

대화형 세션에서 Claude Code는 이 오류를 다음과 같이 표시합니다.

```text theme={null}
Context limit reached · /compact or /clear to continue
```

[`DISABLE_COMPACT`](https://code.claude.com/docs/ko/env-vars)가 설정된 경우 이 줄에는 `/clear`만 표시됩니다. 아래의 압축 실패 형태와 같은 더 긴 형태의 오류는 `Prompt is too long ·` 문구를 유지합니다. `-p` 출력과 트랜스크립트에서는 텍스트가 `Prompt is too long`으로 유지됩니다.

[사용자 설정](https://code.claude.com/docs/ko/settings-reference.md#autocompactenabled)에서 자동 압축을 끈 경우, 이 줄에 해당 내용도 표시됩니다.

```text theme={null}
Context limit reached · /compact or /clear to continue · auto-compact is off · /config to turn it on
```

`/config`의 **Auto-compact** 토글은 사용자 설정에 `autoCompactEnabled`를 기록합니다. 이 힌트는 `/config` 변경이 실제로 적용될 때만 표시됩니다. 예를 들어 [`DISABLE_AUTO_COMPACT`](https://code.claude.com/docs/ko/env-vars) 또는 [`DISABLE_COMPACT`](https://code.claude.com/docs/ko/env-vars)로 자동 압축이 꺼진 경우에는 표시되지 않습니다. 또한 프로젝트 설정이나 관리형 설정처럼 우선순위가 더 높은 범위에서 `autoCompactEnabled`를 `false`로 설정한 경우에도 표시되지 않습니다. v2.1.235 이전에는 이 줄에 자동 압축 힌트가 없었습니다.

Amazon Bedrock은 이 상황을 `Input is too long for requested model.`로 보고하며, Claude Code는 이를 동일하게 처리합니다. v2.1.217 이전에는 Claude Code가 Bedrock 문구를 인식하지 못했기 때문에 자동 압축이 트리거되지 않았고 `/compact`도 같은 오류로 실패했습니다.

[Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway-config.md#upstream-error-messages)는 클라우드 업스트림이 공급자 고유의 오류 형태로 요청을 거부할 때 이 상황을 `capability_rejected: prompt_too_long`으로 보고합니다. Claude Code는 이 토큰을 `Prompt is too long`과 동일하게 처리합니다. v2.1.228 이전에는 Claude Code가 이 토큰을 인식하지 못했기 때문에 자동 압축이 트리거되지 않았습니다.

이번 턴에서 자동 압축이 실행되었지만 사용할 수 없는 모델이나 인증 실패와 같은 근본 오류로 실패한 경우, 메시지는 구분 기호 뒤에 해당 오류를 표시합니다.

```text theme={null}
Prompt is too long · automatic compaction failed: <the underlying error>
```

표시된 오류를 먼저 해결하십시오. 해결하기 전까지 `/compact`도 같은 오류로 실패합니다. v2.1.229 이전에는 자동 압축이 실패하면 원인 없이 `Prompt is too long`만 표시되었습니다.

이 오류에 대해 자동 압축이 실행되면 일반적으로 가장 오래된 대화 교환을 요약하고 최신 교환은 유지합니다. 최후의 수단으로 Claude Code는 다르게 요약합니다.

* 어떤 교환 전체도 요약할 수 없는 경우, Claude Code는 최신 프롬프트를 그대로 유지하고 그 이전의 모든 내용을 요약합니다.
* 이 경우 대화가 사용자의 프롬프트로 끝나지 않으면, Claude Code는 대신 대화 전체를 요약합니다.

이어서 전달할 내용에 모델 응답이 없고 사용자 자신의 텍스트가 약 1,000 토큰 미만인 경우(예: 너무 큰 붙여넣기 후 보낸 짧은 재시도), Claude Code는 이 복구를 건너뜁니다. 새로 시작하려면 `/clear`를 실행하십시오. v2.1.269 이전에는 교환 전체를 요약할 수 없을 때마다 압축이 실패했기 때문에, 그런 상태의 세션은 매 턴마다 이 오류가 다시 발생했습니다.

단일 교환으로 이루어진 대화에는 요약할 이전 턴이 없습니다. 이런 대화에서 자동 압축이 실행될 상황이 되면, Claude Code는 시도를 건너뛰고 대신 요청을 채우는 내용이 무엇인지 설명합니다. API가 오류에 토큰 수를 보고하지 않는 경우 메시지는 다음과 같습니다.

```text theme={null}
Prompt is too long · this conversation is a single exchange and cannot be compacted — the request size comes mostly from system prompt, tool definitions, or attachments.
```

API가 오류에 토큰 수를 보고하는 경우, Claude Code는 이를 대화 크기에 대한 자체 추정치와 비교하여 요청의 대부분이 대화 자체의 내용인지, 아니면 Claude Code가 함께 보내는 시스템 프롬프트, 도구 정의, 첨부 내용인지 판단합니다. 대화 자체의 내용이 요청의 대부분인 경우 메시지는 다음과 같습니다.

```text theme={null}
Prompt is too long · the request is ~<request tokens> tokens (limit <limit>) and this conversation's own content is most of it. A single-exchange conversation cannot be compacted; start with less content (smaller files or pasted text).
```

요청의 대부분이 대화 외부에 있는 경우 메시지는 다음과 같습니다.

```text theme={null}
Prompt is too long · the request is ~<request tokens> tokens (limit <limit>) but this conversation is only ~<conversation tokens> tokens — the rest is system prompt, tool definitions, and attachment content. A single-exchange conversation cannot be compacted; reduce attached files/tools or start with less context.
```

v2.1.162 이전에는 Claude Code가 그래도 압축을 시도했고, 실패하면 `Prompt is too long`만 표시했습니다.

**해결 방법:**

* `/compact`를 실행하여 이전 턴을 요약하고 공간을 확보하거나, `/clear`를 실행하여 새로 시작합니다. `/compact`가 `Not enough messages to compact.`로 응답하면 대화가 요약할 이전 내용이 없는 단일 교환이라는 뜻이므로, 공간은 그 하나의 프롬프트와 Claude Code가 모든 요청에 함께 보내는 내용이 차지하고 있습니다. `/clear`를 실행하고 붙여넣은 텍스트를 줄이거나 더 작은 첨부 파일로 다시 보내거나, 아래 단계에 따라 도구 정의와 메모리 파일을 줄이십시오
* `/context`를 실행하여 시스템 프롬프트, 도구, 메모리 파일, 메시지 등 윈도우를 차지하는 항목의 세부 내역을 확인합니다
* 사용하지 않는 MCP 서버를 `/mcp disable <name>`으로 비활성화하여 해당 도구 정의를 컨텍스트에서 제거합니다
* 큰 `CLAUDE.md` 메모리 파일을 정리하거나, 관련 있을 때만 로드되는 [경로 범위 규칙](https://code.claude.com/docs/ko/memory.md#path-specific-rules)으로 지침을 옮깁니다
* 자동 압축은 기본적으로 켜져 있으며 일반적으로 이 오류를 방지합니다. `/config` 또는 [`DISABLE_AUTO_COMPACT`](https://code.claude.com/docs/ko/env-vars)로 끈 경우 다시 켜십시오. 계속 꺼 두려면 윈도우가 가득 차기 전에 직접 `/compact`를 실행하십시오.
* 더 큰 컨텍스트를 지원하는 모델에서 200K 토큰 근처에서 오류가 발생한다면, 한 가지 원인은 Claude Code가 인식하지 못하는 모델 ID입니다. Claude Code는 그런 ID에 대해 200K 윈도우를 가정하므로, 그 이상으로 계속 작업하려면 [모델의 실제 컨텍스트 윈도우를 지정](https://code.claude.com/docs/ko/model-config.md#correct-the-window-for-a-gateway-or-custom-model-id)하십시오.
  * 사용자 지정 [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)을 사용하고 오류가 `Prompt is too long · automatic compaction failed`로 시작한다면, [모델의 컨텍스트 윈도우를 설정](https://code.claude.com/docs/ko/model-config.md#correct-the-window-for-a-gateway-or-custom-model-id)하거나 v2.1.299 이상으로 [업데이트](https://code.claude.com/docs/ko/setup.md#update-claude-code)하십시오. v2.1.299 이전에는 Claude Code가 가정된 200K 윈도우 근처에서 요청을 보내는 대신 이 메시지로 턴을 종료했습니다.
* Claude가 대화를 압축하는 도중에 중지한 직후 오류가 나타났다면, 대화는 변경되지 않았으며 여전히 압축이 필요할 만큼 큽니다. `/compact`를 실행하고 메시지를 다시 보내세요. 오류가 재발하지 않도록 하려면 Claude Code를 v2.1.304 이상으로 [업데이트](https://code.claude.com/docs/ko/setup.md#update-claude-code)하세요. v2.1.304 이전에는 그 시점에 중지하면 턴이 이 오류로 끝날 수 있었습니다.
* v2.1.305에서 MCP 도구가 많고 Anthropic API에 직접 연결된 경우, 이 오류가 API의 관련 없는 400 또는 422 오류를 가릴 수 있습니다. 원래 오류를 확인하려면 [Claude Code를 업데이트](https://code.claude.com/docs/ko/setup.md#update-claude-code)하여 v2.1.306 이상으로 올리십시오.

컨텍스트가 채워지는 방식을 대화형으로 확인하려면 [컨텍스트 윈도우 살펴보기](https://code.claude.com/docs/ko/context-window.md)를 참조하십시오.

### Context exceeds the token limit

대화가 모델의 컨텍스트 윈도우를 넘어서 커진 경우 `/context`는 출력 상단에 이 경고를 표시합니다. 공간을 확보할 때까지 요청은 [`Prompt is too long`](#prompt-is-too-long)으로 실패합니다. 대화형 세션은 이 오류를 `Context limit reached` 줄로 표시합니다.

```text theme={null}
Context exceeds the 200k-token limit by 94k tokens — run /compact or /clear to continue.
```

초과한 한도가 1M 컨텍스트 모델의 200K 경계와 같은 압축 윈도우인 경우 경고 문구가 달라집니다. 압축 윈도우는 모델의 컨텍스트 윈도우보다 작을 수 있으므로, 이를 넘은 요청도 여전히 성공할 수 있습니다.

```text theme={null}
Context is 94k tokens past the 200k-token compaction window — run /compact to reduce usage.
```

[`DISABLE_COMPACT`](https://code.claude.com/docs/ko/env-vars)를 설정한 경우 두 형태 모두 `/compact` 대신 `/clear`를 표시합니다.

**해결 방법:**

* 여러 턴으로 이루어진 대화에서는 `/compact`를 실행하여 이전 턴을 요약하고 공간을 확보합니다. 대신 새로 시작하려면 `/clear`를 실행합니다
* 사용량을 줄이는 다른 방법은 [Prompt is too long](#prompt-is-too-long)을 참조하십시오

v2.1.216 이전에는 `/context`가 100%를 넘는 사용량을 표시하면서도 그 의미나 복구 방법을 설명하는 경고 줄을 표시하지 않았습니다.

### Request too large

토큰화 이전의 원시 요청 본문이 API의 32MB 한도를 초과했습니다. 보통 큰 붙여넣기 내용, 도구 결과 또는 첨부 파일 때문입니다. 이 한도는 [컨텍스트 윈도우](#prompt-is-too-long)와는 별개입니다.

```text theme={null}
Request too large (max 32MB). Accumulated images and attachments in the conversation pushed the request over the limit. Run /compact, or double press esc to go back and remove attachments.
```

요청이 Claude API로 직접 전송되었고 API 자체가 이를 거부한 경우, Claude Code는 대화를 측정하고 복구가 가능한지에 따라 메시지 문구를 정합니다. 프록시, 게이트웨이 또는 클라우드 공급자를 거치는 경우에는 일반 메시지가 표시됩니다. 측정된 형태는 다음과 같습니다.

* `Request too large (max 32MB; 20.1MB of about 33.4MB is images or documents).`: 이미지나 문서 때문에 요청이 한도를 초과했습니다. Claude Code는 이를 제거한 상태로 재시도합니다.
* `Request too large for the API's 32MB request limit`: 메시지만으로도 한도를 초과하므로, 메시지에 `compacting cannot make it fit`이 표시되고 Claude Code는 재시도하지 않습니다. [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 대신 입력을 줄이거나 새 세션을 시작하라는 메시지가 표시됩니다.

v2.1.212 이전에는 이미지가 충분히 누적된 대화가 매 턴마다 `Request too large (max 32MB). Double press esc to go back and try with a smaller file.`로 실패했습니다. v2.1.229 이전에는 압축으로 해결할 수 없는 경우에도 Claude Code가 모든 거부에 대해 첨부 파일 관련 안내를 표시했습니다.

**해결 방법:**

* 메시지에 `compacting cannot make it fit`이 표시되면 Esc를 두 번 눌러 큰 내용을 추가한 턴 이전으로 되돌아가거나, `/clear`를 실행하여 새로 시작합니다
* 그렇지 않으면 누적된 이미지와 첨부 파일을 제거하는 `/compact`를 실행합니다
* 큰 파일은 내용을 붙여넣는 대신 경로로 참조하여 Claude가 나누어 읽을 수 있게 합니다
* 이미지의 경우 아래의 [Image was too large](#image-was-too-large)를 참조하십시오

### Image was too large

붙여넣거나 첨부한 이미지가 API의 크기 또는 해상도 한도를 초과했습니다.

```text theme={null}
Image was too large. Double press esc to go back and try again with a smaller image.
API Error: 400 ... image dimensions exceed max allowed size
API Error: an image in the conversation could not be processed and was removed.
```

`could not be processed and was removed` 줄은 API가 대화 내의 이미지(예: 크기 또는 해상도 한도를 초과한 이미지)를 거부했다는 뜻입니다.

이러한 오류 중 하나가 계속 발생하면 Claude Code를 업데이트하십시오. 이전 버전에서는 다음과 같은 이유로 이미지 오류가 반복될 수 있었습니다.

* v2.1.299 이전에는 이미지가 많은 긴 대화에서 Claude Code가 한도를 초과한 이미지 대신 마지막으로 첨부한 이미지를 제거할 수 있었습니다. 그 결과 `was removed` 줄이 매 턴마다 반복되었고, Claude는 새 이미지를 볼 수 없었습니다.
* v2.1.299 이전에는 VS Code, Desktop 앱, Agent SDK에서 Claude가 작업하는 동안 첨부한 이미지가 다른 첨부 이미지와 달리 크기 조정되지 않았습니다. 이 이미지는 원래 크기 그대로 API에 전달되어 긴 대화에서 이미지 오류가 반복되었습니다.
* v2.1.166 이전에는 붙여넣은 이미지가 대화에 남아 이후 모든 메시지에서 같은 오류가 반복될 수 있었습니다

**해결 방법:**

* 붙여넣기 전에 이미지 크기를 줄입니다. API는 단일 이미지의 경우 긴 변 기준 최대 8000픽셀, 컨텍스트에 이미지가 20개를 초과하는 경우 최대 3000픽셀까지 허용합니다.
* 전체 화면 대신 관련 영역만 좁게 스크린샷을 찍습니다

### Unable to resize image

Claude Code가 첨부된 이미지를 API로 보내기 전에 축소하지 못했습니다.

```text theme={null}
Unable to resize image — image processing is unavailable and dimensions could not be read from the file header. Please convert the image to PNG, JPEG, GIF, or WebP.
Unable to resize image — dimensions exceed the 2000x2000px limit and image processing failed. Please resize the image to reduce its pixel dimensions.
Unable to resize image (… raw, … base64). The image exceeds the … API limit and compression failed. Please resize the image manually or use a smaller image.
Unable to resize image — could not verify image dimensions are within the 2000x2000px API limit.
Unable to resize image — it is a CMYK JPEG, which Claude Code cannot decode, and at …px it is over the 2000x2000px limit, so it cannot be sent. Re-save it as an RGB PNG or JPEG and try again.
Unable to resize image — it is an animated WebP whose first frame Claude Code cannot decode, and at …px it is over the 2000x2000px limit, so it cannot be sent. Save its first frame as a PNG or JPEG and try again.
Unable to resize image — its pixels could not be decoded (the file may be damaged, or use an encoding Claude Code cannot read), and it is over the … API limit (… raw, … base64), so it cannot be sent. Re-save it as a PNG or JPEG and try again.
```

Claude Code는 일반적으로 큰 이미지의 크기를 자동으로 조정합니다. 이러한 오류는 이미지를 디코딩하거나 API 한도에 맞게 크기를 조정할 수 없었다는 뜻입니다.

**해결 방법:**

* 메시지가 이미지 변환을 요청하면 PNG, JPEG, GIF 또는 WebP로 변환한 후 다시 첨부합니다. Claude Code는 이러한 형식의 경우 이미지를 디코딩하지 않고도 파일 헤더에서 해상도를 확인할 수 있습니다.
* 메시지가 해상도 또는 크기 한도를 보고하면, 첨부하기 전에 이미지를 해당 한도 이하로 크기 조정하거나 다시 압축합니다.
* 메시지가 CMYK JPEG, 애니메이션 WebP, 손상되었을 수 있는 파일과 같은 원인을 명시하면, 메시지가 제안하는 형식으로 이미지를 다시 저장한 후 다시 첨부합니다.

### Request rejected as unprocessable by the model

API가 모델이 처리할 수 없는 요청으로 판단하여 거부했습니다. 이 메시지는 API 자체의 메시지입니다.

```text theme={null}
API Error: 400 Request rejected as unprocessable by the model (too many or oversized images, or unsupported parameters)
```

Claude Code는 거부된 요청에서 가장 오래된 이미지와 문서를 제거한 후 다시 보낼 수 있습니다. v2.1.290 이전에는 Claude Code가 이 거부에 대해 이미지를 제거하지 않았기 때문에, 이미지가 수백 개 누적된 긴 세션은 매 턴마다 이 오류로 실패할 수 있었습니다.

**해결 방법:**

* 이미지나 문서가 포함된 대화에서 이 메시지가 계속 나타나면 직접 제거하십시오. Esc를 두 번 눌러 해당 내용을 추가한 턴 이전으로 되돌아가거나, `/clear`를 실행하여 새로 시작합니다.

### PDF 오류

첨부한 PDF를 처리할 수 없었습니다. 여기에 표시된 메시지는 비대화형 형태이며, 대화형 세션에서는 대신 esc를 두 번 눌러 다시 시도하라는 안내가 표시됩니다.

```text theme={null}
PDF too large (max 100 pages, 20MB). Try reading the file a different way (e.g., extract text with pdftotext).
PDF is password protected. Try using a CLI tool to extract or convert the PDF.
The PDF file was not valid. Try converting it to text first (e.g., pdftotext).
```

**해결 방법:**

* 크기가 큰 PDF의 경우 파일 전체를 첨부하는 대신 Claude에게 Read 도구로 페이지 범위를 읽도록 요청하거나, `pdftotext` 같은 도구로 텍스트를 추출한 후 출력 파일을 경로로 참조합니다
* 보호되었거나 유효하지 않은 PDF의 경우 비밀번호를 제거하거나 원본 애플리케이션에서 파일을 다시 내보낸 후 다시 시도합니다

Claude가 Read 도구로 PDF의 페이지 범위를 읽을 때, 다른 메시지와 함께 읽기가 실패할 수 있습니다.

```text theme={null}
pdftoppm is not installed. Install poppler-utils (e.g. `brew install poppler` or `apt-get install poppler-utils`) to enable PDF page rendering.
```

페이지 범위 읽기는 `pdftoppm`으로 페이지를 렌더링합니다. 메시지가 제시하는 명령으로 poppler-utils를 설치하거나, 다른 플랫폼에서는 `PATH`에 `pdftoppm`을 추가하는 poppler 빌드를 설치하십시오. 어떤 PDF가 페이지 범위로 읽히는지는 [Read 도구 동작](https://code.claude.com/docs/ko/tools-reference.md#read-tool-behavior)을 참조하십시오.

### Extra inputs are not permitted

요청을 받은 엔드포인트가 요청의 필드 중 하나를 허용하지 않는 입력으로 판단하여 거부했으며, 엔드포인트의 메시지에 해당 필드가 명시됩니다.

```text theme={null}
API Error: 400 ... context_management: Extra inputs are not permitted
```

Claude Code는 `context_management`나 도구 검색의 `defer_loading` 같은 베타 전용 필드를 이를 활성화하는 `anthropic-beta` 헤더와 함께 보냅니다. 게이트웨이가 본문은 전달하지만 헤더를 삭제하면, API는 인식하지 못하는 필드를 보게 됩니다. 게이트웨이가 Anthropic 형식의 본문을 스키마가 다른 업스트림으로 전달하면, 해당 업스트림이 그런 필드를 거부합니다. [베타 헤더와 본문 필드 쌍](https://code.claude.com/docs/ko/llm-gateway-protocol.md#beta-header-and-body-field-pairs)에서 두 경우를 모두 다룹니다.

**해결 방법:**

* 메시지에 `context_management: Extra inputs are not permitted`가 포함되어 있으면 [Claude Code를 v2.1.304 이상으로 업데이트](https://code.claude.com/docs/ko/setup.md#update-claude-code)하십시오. 업데이트 후에는 Claude Code가 이 거부에 대해 해당 필드 없이 요청을 한 번 더 보냅니다. v2.1.304 이전에는 Claude Code가 이 거부에 대해 재시도하지 않았습니다.
* 메시지에 `defer_loading` 또는 `tool_reference`가 명시되어 있으면 Claude Code를 업데이트하거나 [도구 검색](https://code.claude.com/docs/ko/mcp.md#tool-search-through-a-gateway)을 끄십시오.
  * [Claude Code를 v2.1.305 이상으로 업데이트](https://code.claude.com/docs/ko/setup.md#update-claude-code)합니다. 그러면 Claude Code가 이 거부에 대해 도구 검색 필드 없이 요청을 한 번 더 보냅니다.
  * 업데이트할 수 없거나 업데이트 후에도 메시지가 계속 나타나면, 셸 또는 [설정 `env`](https://code.claude.com/docs/ko/settings-reference#env)에서 `ENABLE_TOOL_SEARCH=false`를 설정합니다. 설정 파일에서 이미 이 변수를 설정하고 있다면, 그 값이 [셸 export를 재정의할 수 있으므로](https://code.claude.com/docs/ko/settings-reference.md#how-env-values-interact-with-your-shell) 해당 파일에서 변경하십시오. 그러면 Claude Code는 MCP 도구를 미리 로드합니다.
* 게이트웨이가 헤더를 삭제하는 경우, `anthropic-beta` 헤더를 전달하도록 게이트웨이를 구성하십시오. 게이트웨이가 전달해야 하는 항목은 [기능 패스스루](https://code.claude.com/docs/ko/llm-gateway-protocol.md#feature-pass-through)를 참조하십시오.
* 대안으로, 실행하기 전에 [`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](https://code.claude.com/docs/ko/env-vars)을 설정하십시오. 정확한 범위는 [사전 출시 기능 비활성화](https://code.claude.com/docs/ko/llm-gateway-protocol.md#disable-pre-release-capabilities)에서 다룹니다.

v2.1.302 이전에는 게이트웨이가 관여하지 않아도 이 오류가 `diagnostics` 필드를 명시할 수 있었습니다. 이는 이미 Anthropic API를 사용한 세션이 재시작 없이 Amazon Bedrock 또는 Google Cloud's Agent Platform으로 전환될 때 발생했습니다. 예를 들어 열어 둔 세션은 다른 Claude Code 창에서 [`/setup-bedrock`](https://code.claude.com/docs/ko/commands)을 실행하면 Bedrock으로 전환됩니다. 해당 버전에서는 그 세션에서 `/clear`를 실행하거나 세션을 재시작하십시오.

### Tool input schema is invalid

요청에 포함된 도구가 API의 JSON Schema 검증을 통과하지 못하는 `input_schema`를 선언했기 때문에 API가 요청 전체를 거부했습니다. `tools.` 뒤의 숫자는 요청의 도구 목록에서 실패한 도구의 위치이며, 조회할 수 있는 이름이 아닙니다.

```text theme={null}
API Error: 400 ... tools.N.custom.input_schema: JSON schema is invalid
API Error: 400 ... tools.N.custom.input_schema.properties: Property keys should match pattern '^[a-zA-Z0-9_.-]{1,64}$'
```

첫 번째 형태는 스키마가 유효한 JSON Schema draft 2020-12가 아니라는 뜻입니다. 두 번째 형태는 최상위 속성 이름이 메시지에 인용된 패턴과 일치하지 않는다는 뜻입니다.

Claude Code는 서버의 도구를 로드할 때 [입력 스키마가 이 검증에 실패할 MCP 도구를 제외](https://code.claude.com/docs/ko/mcp.md#tools-with-invalid-input-schemas)하므로, 일반적으로 요청에 그런 도구가 포함되지 않습니다.

[플래그 가져오기가 꺼진 배포](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching)나 플래그를 한 번도 받지 못한 머신에서는 Claude Code가 어떤 도구가 거부될지를 서버 로그에 기록하지만 그래도 해당 도구를 보내므로, 이 오류가 여전히 발생할 수 있습니다.

스키마가 `$schema`에서 draft 2020-12 이외의 JSON Schema 방언을 선언한 도구에서도 이 오류가 발생할 수 있습니다. Claude Code는 이러한 스키마를 JSON Schema 메타 스키마와 대조하여 검사하지 않지만, 최상위 속성 이름 검사는 여전히 적용됩니다.

v2.1.216 이전에는 어떤 배포에서도 제외 검사가 실행되지 않았습니다.

**해결 방법:**

* Claude Code 버전이 v2.1.300보다 이전이면 셸에서 [`claude update`](https://code.claude.com/docs/ko/setup#update-claude-code)를 실행하세요. v2.1.300 이전에는 Claude Code가 [거부된 도구의 매개변수 없이 요청을 재시도](https://code.claude.com/docs/ko/mcp.md#tools-whose-input-schema-the-api-refuses)하지 않았기 때문에, 해당 도구가 포함된 모든 요청에서 이 오류가 반복되었습니다.
* 유효하지 않은 스키마를 선언한 MCP 서버를 제거하거나 [비활성화](https://code.claude.com/docs/ko/mcp.md#disable-a-server-without-removing-it)합니다. 오류는 도구를 위치로만 표시합니다. v2.1.216 이상에서는 각 서버의 로그에서 입력 스키마가 거부될 도구를 명시하는 줄을 확인하십시오. 해당 도구를 명시하는 로그가 없으면 서버를 하나씩 비활성화해 보십시오.
* 서버를 직접 관리한다면 도구의 `input_schema`를 수정하십시오. 스키마는 유효한 JSON Schema여야 하며, 최상위 속성 이름은 1\~64자 길이에 ASCII 문자와 숫자, `_`, `.`, `-`만 사용해야 합니다. [입력 스키마가 유효하지 않은 도구](https://code.claude.com/docs/ko/mcp.md#tools-with-invalid-input-schemas)를 참조하십시오.

### 128자를 초과하는 MCP 도구 이름

MCP 서버가 `mcp__<server>__<tool>` 같은 전체 이름이 API가 허용하는 128자보다 긴 도구를 나열합니다. Claude Code는 [해당 도구를 Claude에게 보내는 도구 목록에서 제외](https://code.claude.com/docs/ko/mcp.md#tools-with-names-longer-than-128-characters)하며, 서버의 다른 도구는 계속 작동합니다. 셸에서 `claude --debug`로 시작한 세션에서는 Claude Code가 `~/.claude/debug/<session-id>.txt`의 디버그 로그에 다음 메시지를 기록합니다.

```text theme={null}
Tool "mcp__<server>__<tool>" is not sent to Claude: its name has <N> characters and the API accepts at most 128
```

**해결 방법:**

* 서버를 직접 관리한다면 도구 이름을 줄이십시오.
* 서버가 [MCP 구성](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes)에 있다면 그곳에서 `analytics-database` 대신 `db`처럼 더 짧은 이름을 지정하십시오. 그런 다음 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#mcp)과 [훅 matcher](https://code.claude.com/docs/ko/hooks.md#match-mcp-tools)처럼 이전 이름으로 서버나 도구를 참조하는 항목을 업데이트하십시오.
* [플러그인이 서버를 번들로 포함](https://code.claude.com/docs/ko/mcp.md#plugin-provided-mcp-servers)하는 경우 도구의 전체 이름에 플러그인 이름도 포함됩니다. 플러그인 관리자에게 서버 또는 도구 이름을 줄여 달라고 요청하십시오.

v2.1.292 이전에는 Claude Code가 그래도 도구를 보냈고, API는 해당 도구가 포함된 모든 요청을 `API Error: 400 ... tools.N.custom.name: String should have at most 128 characters`로 거부했습니다.

### 200자를 초과하는 tool\_use.name

대화 기록의 도구 호출이 API가 요청에서 허용하는 200자보다 긴 이름을 가지고 있습니다.

```text theme={null}
API Error: 400 ... tool_use.name: String should have at most 200 characters
```

Claude Code는 응답이 도착할 때와 저장된 대화를 로드할 때 이런 이름을 200자로 자르므로, 해당 호출은 [`No such tool available`](#no-such-tool-available) 도구 오류로 실패하고 대화는 이 API 오류 없이 계속됩니다.

**해결 방법:**

* `claude update`를 실행한 후 대화를 재개합니다. 업데이트된 버전은 트랜스크립트를 로드할 때 너무 긴 이름을 복구하므로, 멈춰 있던 대화가 다시 작동합니다.

v2.1.281 이전에는 너무 긴 이름이 기록에 남아 API가 `/compact`와 `--resume`을 포함하여 대화를 다시 보내는 모든 요청을 거부했기 때문에, 이 오류가 반복되고 대화가 멈춰 있었습니다.

### There's an issue with the selected model

구성된 모델 이름이 인식되지 않았거나 계정에 해당 모델에 대한 액세스 권한이 없습니다. v2.1.160부터 끝부분의 힌트(여기서는 대화형 형태로 표시)는 사용 환경에 따라 다릅니다.

```text theme={null}
There's an issue with the selected model (claude-...). It may not exist or you may not have access to it. Run /model to pick a different model.
```

**해결 방법:**

* **대화형 CLI**: `/model`을 실행하여 계정에서 사용할 수 있는 모델 중에서 선택합니다.
* **비대화형 모드(`-p`)**: 유효한 별칭이나 ID와 함께 `--model`을 전달하거나 [`ANTHROPIC_MODEL`](https://code.claude.com/docs/ko/env-vars)을 설정합니다. 이 사용 환경에서는 오류 텍스트에 `Run --model`이 표시됩니다.
* **Agent SDK**: 모델이 프로그래밍 방식으로 설정되므로 오류 텍스트에 힌트가 생략됩니다. TypeScript에서는 [`Options`의 `model`](https://code.claude.com/docs/ko/agent-sdk/typescript#options)을, Python에서는 [`ClaudeAgentOptions(model=...)`](https://code.claude.com/docs/ko/agent-sdk/python#claudeagentoptions)을 설정하고, 구조화된 `model_not_found` 오류를 처리하여 자체 재시도나 모델 선택기를 제공하십시오.
* 버전이 포함된 전체 ID 대신 `sonnet`이나 `opus` 같은 별칭을 사용하십시오. 별칭은 관리되는 기본값으로 해석되므로 오래되지 않습니다. [모델 구성](https://code.claude.com/docs/ko/model-config.md)을 참조하십시오.
* CLI에서 잘못된 모델이 계속 다시 나타난다면 어딘가에 오래된 ID가 설정되어 있는 것입니다. 모델을 설정할 수 있는 위치를 [우선순위 순서](https://code.claude.com/docs/ko/model-config.md#setting-your-model)대로 확인하고 오래된 값을 제거하십시오.
* Claude Code는 만료된 claude.ai 로그인을 이 오류가 아닌 [Login expired](#login-expired)로 보고합니다. v2.1.206 이전에는 더 이상 갱신할 수 없는 만료된 로그인이 모든 모델에서 이 오류로 실패했습니다. 이전 버전에서 이 현상이 나타나면 `/login`을 실행하십시오.
* [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)이 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 가리키고 모든 모델이 이런 방식으로 실패한다면, 게이트웨이가 Claude Code가 기본적으로 보내는 도구 검색 필드를 거부하고 있는지 확인하세요. 확인하려면 [LLM 게이트웨이를 통한 도구 검색](https://code.claude.com/docs/ko/mcp.md#tool-search-through-a-gateway)에 설명된 대로 `ENABLE_TOOL_SEARCH=false`를 설정한 후 다시 시도하세요. v2.1.304 이전에는 `ENABLE_TOOL_SEARCH`로 켜지 않는 한 게이트웨이 뒤에서 도구 검색이 꺼져 있었습니다.
* Google Cloud's Agent Platform 배포의 경우 [Google Cloud's Agent Platform 문제 해결](https://code.claude.com/docs/ko/google-vertex-ai.md#troubleshooting)을 참조하십시오.

### Model is not a recognized model id

모델 전환에 전달한 문자열을 Claude Code가 모델로 사용할 수 없으므로, 요청을 보내지 않고 전환을 거부했으며 세션은 현재 모델을 유지합니다. 이 오류는 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/typescript.md)의 `setModel()` 메서드로 모델을 설정할 때, [Desktop 앱](https://code.claude.com/docs/ko/desktop.md)처럼 Claude Code CLI를 대신 실행하는 앱이 모델을 설정할 때, 또는 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)로 연결된 기기에서 모델을 선택할 때 발생할 수 있습니다. v2.1.200 이전에는 Claude Code가 문자열을 저장한 후 다음 요청에서 [There's an issue with the selected model](#theres-an-issue-with-the-selected-model)로 실패했습니다.

```text theme={null}
Model "Sonnet5" is not a recognized model id. Did you mean 'claude-sonnet-5'?
```

이 예에서는 앱이 표시 이름 `Sonnet 5`를 보냈고, 메시지는 이를 공백 없이 반복합니다. 끝부분의 힌트는 가장 가깝게 일치하는 별칭이나 모델 ID를 표시합니다. 충분히 가까운 항목이 없으면 대신 `Run /model to see available models.`가 표시됩니다. [Desktop 앱](https://code.claude.com/docs/ko/desktop.md)이 시작한 세션에서는 일치 항목이 없을 때의 힌트가 `Switch to a different model.`로 표시됩니다.

Anthropic API에서 Agent SDK나 앱을 통해 전환할 때는 표시 이름이나 빈 문자열처럼 모델 ID가 될 수 없는 문자열만 이 오류가 발생합니다.

Remote Control 기기에서 모델을 선택하면 Claude Code가 문자열을 로컬에서 검사합니다. 모델 별칭, Claude Code가 나열하거나 사용자가 구성한 모델, 또는 `claude-`로 시작하는 ID가 아닌 모든 문자열은 이 오류가 발생하며, `claud-sonnet-5` 같은 오타가 있는 ID도 포함됩니다. v2.1.260 이전에는 이 검사가 Remote Control 선택을 다루지 않았기 때문에, 인식되지 않은 문자열이 적용된 후 다음 요청에서 실패했습니다.

**해결 방법:**

* 인수 없이 `/model`을 실행하여 선택기를 열고 계정에서 사용할 수 있는 모델 중에서 선택한 후, 그곳에 표시된 별칭이나 ID를 전달합니다
* 최신 Claude Code 버전에서만 지원하는 별칭을 사용한 경우 `claude update`를 실행하거나 대신 모델의 전체 ID를 전달합니다. 서버는 여전히 해당 모델에 대해 최소 Claude Code 버전을 요구할 수 있습니다. [Claude Code does not support this model](#claude-code-does-not-support-this-model)을 참조하십시오.
* v2.1.200 이전에 저장된 모델은 이 검사로 복구되지 않습니다. 오래된 값이 계속 다시 나타나면 [모델 설정](https://code.claude.com/docs/ko/model-config.md#setting-your-model)에 나열된 위치에서 제거하십시오.
* Anthropic API 이외의 공급자에서, 또는 게이트웨이나 사용자 지정 `ANTHROPIC_BASE_URL` 뒤에서는 빈 문자열만 이 오류가 발생합니다. Claude Code는 모든 공급자에서 요청 시점에 [인식되지 않은 모델 진단 줄](#unrecognized-model-id-on-a-request)을 여전히 기록할 수 있습니다.

### Model not found

이름으로 모델을 전환했지만 Claude Code가 해당 이름의 모델이 존재하는지 확인할 수 없었습니다. 이름이 [모델 별칭](https://code.claude.com/docs/ko/model-config.md#model-aliases)이나 Claude Code가 로컬에서 허용하는 다른 표기가 아닌 경우, Claude Code는 최소한의 API 요청으로 이를 확인하며, 이 오류는 보통 API 엔드포인트의 응답입니다. `/model <name>`에서 공백이 포함된 이름처럼 모델 ID가 될 수 없는 이름은 같은 메시지가 표시됩니다.

```text theme={null}
Model 'claude-opus-9' not found
```

공급자별 모델 ID를 사용하는 공급자에서는 메시지에 공급자의 대체 모델 ID를 명시하는 `Try '...' instead` 제안이 추가될 수 있습니다.

**해결 방법:**

* 인수 없이 `/model`을 실행하고 계정에서 사용할 수 있는 모델 중에서 선택하거나, 관리되는 기본값으로 해석되는 `sonnet` 같은 [모델 별칭](https://code.claude.com/docs/ko/model-config.md#model-aliases)을 사용합니다
* 전체 ID를 입력했다면 공급자의 모델 카탈로그와 대조하여 확인합니다. 새로 출시된 모델은 공급자나 리전에서 제공되기 전에 Anthropic API에서 먼저 사용 가능할 수 있습니다.
* Agent SDK에서는 `setModel()`이 이 메시지로 실패하고 세션은 이전 모델로 계속 실행됩니다. TypeScript SDK에서는 [`supportedModels()`](https://code.claude.com/docs/ko/agent-sdk/typescript#query-object)를 호출하여 전환할 수 있는 모델 목록을 확인하십시오.
* v2.1.265 이전에는 `/model`이 `opusplan[1m]` 별칭 표기도 이 오류로 거부했습니다. 해당 버전에서는 Claude Code를 업데이트하거나 대신 [설정](https://code.claude.com/docs/ko/model-config.md#setting-your-model) 또는 `--model`로 모델을 설정하십시오.

### Couldn't confirm model with the API

[Agent SDK](https://code.claude.com/docs/ko/agent-sdk/typescript.md) `setModel()` 메서드나 [Desktop 앱](https://code.claude.com/docs/ko/desktop.md)처럼 Claude Code CLI를 대신 실행하는 앱을 통해 모델을 전환했는데, API 엔드포인트에서 모델 ID를 확인하는 요청이 15초 이내에 응답을 받지 못했습니다. 세션은 현재 모델을 유지합니다.

```text theme={null}
Couldn't confirm model "claude-sonnet-5" with the API. Try again, or run /model to see available models.
```

[Desktop 앱](https://code.claude.com/docs/ko/desktop.md)이 시작한 세션에서는 메시지가 `Try again.`에서 끝납니다.

**해결 방법:**

* 모델로 다시 전환합니다
* 전환이 계속 실패하면 Claude Code가 API 엔드포인트에 연결할 수 있는지 확인하십시오. [네트워크 및 연결 오류](#network-and-connection-errors)를 참조하십시오

### 선택한 모델 확인 중 API 오류

`/model <name>`으로 모델을 선택했거나, 세션에 연결된 앱이 전환을 요청했습니다. API가 속도 제한이나 서버 오류처럼 별도 항목이 없는 이유로, Claude Code가 모델 확인을 위해 보내는 최소한의 요청을 거부했습니다. 세션은 현재 모델을 유지하며, 메시지 끝에 그 사실이 표시됩니다.

```text theme={null}
API error: 429 <the server's explanation> · model not changed
```

메시지 중간 부분은 HTTP 상태와 서버 자체의 설명입니다.

**해결 방법:**

* 서버의 설명에 따라 조치합니다. 속도 제한이나 5xx 상태인 경우 잠시 기다린 후 모델을 다시 선택합니다
* 고유한 문구가 있는 거부는 [Model not found](#model-not-found)와 [Model is restricted by your organization's settings](#model-is-restricted-by-your-organizations-settings) 같은 주변 항목에서 다룹니다

### Claude Opus is not available with the Claude Pro plan

현재 구독 플랜에 선택한 모델이 포함되어 있지 않습니다.

```text theme={null}
Claude Opus is not available with the Claude Pro plan. If you have updated your subscription plan recently, run /logout and /login for the plan to take effect.
```

Claude Desktop 앱이 실행하는 세션에서는 메시지가 명령 이름 대신 `sign out and sign in again`이라고 안내합니다.

**해결 방법:**

* `/model`을 실행하고 플랜에 포함된 모델을 선택합니다
* 최근에 플랜을 업그레이드했는데도 이 메시지가 나타나면 `/logout`을 실행한 후 `/login`을 실행합니다. 저장된 토큰은 로그인 시점의 플랜을 반영하므로, claude.ai에서 업그레이드해도 다시 인증하기 전까지 기존 세션에는 적용되지 않습니다.
* 각 플랜에 포함된 모델은 [claude.com/pricing](https://claude.com/pricing)을 참조하십시오

### Claude Code does not support this model

Claude Code 버전이 요구되는 최소 버전보다 낮아서 API가 400으로 요청을 거부했습니다. 선택한 모델이 서버가 모델별로 검사하는 더 새로운 버전을 요구하거나, 조직 정책이 특정 버전을 요구하는 경우입니다. 400에는 오류 코드 `claude_code_version_too_old`가 포함되며, 메시지에 어떤 최소 버전이 적용되는지 표시됩니다.

```text theme={null}
API Error: 400 Claude Code 2.1.219 does not support this model; version 2.1.255 or newer is required. Run 'claude update', or update the Claude desktop app, then try again.
```

조직 정책 문구는 다음과 같습니다.

```text theme={null}
API Error: 400 Claude Code 2.1.240 is older than the minimum version required by your organization's policy. Run 'claude update', or update the Claude desktop app, to continue.
```

API가 검사하는 버전은 요청을 보낸 Claude Code 바이너리가 보고하는 버전입니다.

**해결 방법:**

해당 바이너리를 업데이트한 후 새 세션을 시작하십시오. [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments-deploy.md#pin-the-version)을 제외하면, 바이너리의 출처에 따라 업데이트 방법이 결정됩니다.

| 요청을 보낸 바이너리 | 업데이트 방법 |
| :- | :- |
| 직접 설치한 Claude Code | `claude update` 실행 |
| Claude desktop 앱 | 앱 업데이트 |
| [VS Code 확장](https://code.claude.com/docs/ko/vs-code.md)에 번들로 포함된 바이너리 | 확장 업데이트 |
| Agent SDK 패키지에 번들로 포함된 바이너리 | [SDK 패키지를 업그레이드](https://code.claude.com/docs/ko/agent-sdk/hosting.md#runtime-dependencies)한 후 애플리케이션을 재시작합니다. [컴파일된 단일 파일 실행 파일](https://code.claude.com/docs/ko/agent-sdk/typescript.md#compile-to-a-single-executable)의 경우 다시 빌드합니다 |

* [stable 릴리스 채널](https://code.claude.com/docs/ko/setup.md#configure-release-channel)에서 `claude update`를 실행하면 최신 stable 릴리스보다 더 새로운 버전으로 이동하지 않으며, 이 릴리스도 요구되는 최소 버전보다 낮을 수 있습니다. latest 채널로 이동한 후 다시 업데이트하십시오. 조직이 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)으로 채널이나 버전을 고정한 경우 관리자에게 변경을 요청하십시오
* 모델별 문구의 경우 다른 모델로 전환하여 현재 세션에서 계속 작업할 수 있습니다. CLI에서는 `/model`을 실행하고, 스트리밍 입력 모드에서는 TypeScript SDK의 `Query` 객체에서 [`setModel()`](https://code.claude.com/docs/ko/agent-sdk/typescript#query-object)을, Python SDK의 `ClaudeSDKClient`에서 [`set_model()`](https://code.claude.com/docs/ko/agent-sdk/python#claudesdkclient)을 호출하십시오
* 조직 정책 문구의 경우 계속하기 전에 업데이트하십시오

### Model is restricted by your organization's settings

조직 관리자가 claude.ai 관리 콘솔에서 이 모델을 비활성화했거나, 관리형 설정이 [`availableModels`](https://code.claude.com/docs/ko/model-config#restrict-model-selection) 허용 목록이나 [`deniedModels`](https://code.claude.com/docs/ko/model-config#block-specific-models-or-versions) 목록으로 이 모델을 제외했습니다. 이 알림은 `--model`, `ANTHROPIC_MODEL` 또는 `model` 설정이 제한된 모델을 지정했을 때 시작 시 표시되며, 세션이 대신 사용하는 모델을 명시합니다. 관리형 설정으로 인해 세션이 사용할 수 있는 허용된 모델이 없는 경우 [관리형 설정이 기본 모델을 차단하는 경우](#managed-settings-block-the-default-model)를 참조하십시오. 관리자가 claude.ai 관리 콘솔에서 세션이 실행 중인 모델을 비활성화하면 세션 도중에도 대체 알림이 표시될 수 있습니다.

```text theme={null}
Model "claude-opus-4-8" is restricted by your organization's settings. Using claude-sonnet-4-6 instead.
```

제한된 모델에 대해 `/model <name>`을 입력하면 거부되고 세션은 현재 모델을 유지합니다. 관리 콘솔에서 비활성화된 모델의 경우 거부 메시지는 `Model '<name>' is restricted by your organization's settings. Run /model to choose a different model.`입니다. 관리형 설정이 제외한 모델의 경우 `Model '<name>' is not available. Your organization restricts model selection.`입니다.

에이전트, 스킬 또는 명령 이름이 앞에 붙은 알림은 제한이 해당 [서브에이전트가 요청한 모델](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)에 적용되었다는 뜻입니다. 서브에이전트는 대체된 모델에서 실행되고 세션의 모델은 변경되지 않습니다. v2.1.223 이전에는 Claude Code가 Agent 도구로 실행된 서브에이전트에 대해서만 이 알림을 표시했습니다.

Claude Code는 `opus`, `sonnet`, `haiku`, `fable` 중 하나인 모델 패밀리 별칭을 최신 버전이 아닌 해당 패밀리에 대한 요청으로 처리합니다. Anthropic API와 [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md)에서는 제한된 패밀리 별칭이 조직 설정에서 허용하는 해당 패밀리의 최신 버전으로 해석되며, 대체 알림에 해당 버전이 표시됩니다. Claude Code는 패밀리의 모든 버전이 제한된 경우에만 `/model <alias>`를 거부합니다. v2.1.205 이전에는 같은 패밀리의 이전 버전이 허용되더라도 패밀리 별칭이 최신 버전만을 기준으로 대체되거나 거부되었습니다.

**해결 방법:**

* `/model`을 실행하여 조직이 허용하는 모델 중에서 선택합니다. 제한된 모델은 선택기에 표시되지 않습니다.
* 제한된 모델이 `--model`, `ANTHROPIC_MODEL`, 설정 파일의 `model` 필드, 또는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model), 스킬, 명령의 `model` frontmatter에 설정되어 있다면, 알림이 반복되지 않도록 해당 값을 제거하거나 업데이트하십시오
* 제한된 모델에 액세스해야 한다면 조직 관리자에게 활성화를 요청하십시오. [조직 모델 제한](https://code.claude.com/docs/ko/model-config.md#organization-model-restrictions)을 참조하십시오.

### Can't switch to the default model

`/model` 선택기에서 Default 행을 선택하거나 `/model default`를 입력하는 등의 방법으로 Default 모델을 선택했습니다. Claude Code가 전환을 거부했으므로 세션은 현재 모델을 유지합니다.

```text theme={null}
Can't switch to the default model: your organization's managed settings block it (claude-opus-4-6) in "deniedModels", and none of the models they allow can be used as the default instead. Ask your administrator to update "deniedModels" or "availableModels".
```

콜론 뒤의 문구는 전환을 차단한 원인을 나타냅니다.

* **`your organization's managed settings block it ... in "deniedModels"`**: 관리형 거부 목록이 Default 옵션이 해석되는 모델을 차단합니다
* **`your organization allows only the models listed in "availableModels"`**: [`availableModelsMatch`](https://code.claude.com/docs/ko/settings-reference#availablemodelsmatch)가 `"exact"`로 설정된 관리형 [`availableModels`](https://code.claude.com/docs/ko/model-config#restrict-model-selection) 허용 목록에 Default 옵션이 해석되는 모델이 없습니다
* **`Claude Code couldn't read your organization's managed settings to check which models they allow`**: [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 읽을 수 없어서, Claude Code가 확인 없이 전환을 적용하는 대신 거부했습니다

**해결 방법:**

* [`deniedModels`](https://code.claude.com/docs/ko/settings-reference#deniedmodels) 및 `availableModels` 문구의 경우 `/model`을 실행하고 조직이 허용하는 모델을 이름으로 선택합니다
* 관리자에게 메시지가 명시하는 관리형 설정을 업데이트해 달라고 요청합니다
* `couldn't read` 문구의 경우 Claude Code를 재시작합니다. 계속 발생하면 관리자에게 관리형 설정을 확인해 달라고 요청하십시오

이러한 관리형 설정에서 세션이 대신 `Claude Code can't start` 메시지와 함께 시작되지 않는 경우 [관리형 설정이 기본 모델을 차단하는 경우](#managed-settings-block-the-default-model)를 참조하십시오.

### Model switch was blocked by a PreModelSwitch hook

[PreModelSwitch 훅](https://code.claude.com/docs/ko/hooks.md#premodelswitch)이 사용자나 클라이언트가 요청한 모델 전환을 승인하지 않았으므로 세션은 현재 모델을 유지합니다. 직접 입력한 명령이 아니라 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 호스트나 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)에서 전환이 요청된 경우, 메시지는 대상 모델을 명시하지 않고 `Model switch blocked by a PreModelSwitch hook`으로 표시됩니다.

```text theme={null}
Model switch to Opus 4.6 was blocked by a PreModelSwitch hook: Opus 4.6 is retired for this project. Use a newer model.
```

콜론 뒤의 이유는 무엇이 전환을 거부했는지를 나타냅니다.

* **훅이 작성한 이유**: PreModelSwitch 훅이 [전환을 거부하거나 확인을 요청](https://code.claude.com/docs/ko/hooks.md#premodelswitch-decision-control)할 때 해당 이유를 제공했습니다. 요청 사항을 해결하거나 훅이 허용하는 모델을 선택하십시오.
* **`PreModelSwitch hook <name> did not respond before its timeout`**: [타임아웃](https://code.claude.com/docs/ko/hooks.md#timeouts) 전에 응답하지 않는 훅은 전환을 차단합니다. 멈춘 명령을 수정하거나 해당 훅의 `timeout`을 늘린 후 다시 전환하십시오.
* **`confirmation required, and this session cannot ask`**: 훅이 이유 없이 `ask`로 응답했으며, 제어 요청에는 확인 프롬프트를 표시할 방법이 없습니다. [`-p` 실행](https://code.claude.com/docs/ko/headless)의 `/model` 명령은 이유 뒤에 `(run /model interactively to confirm)`을 붙여 같은 상황을 보고합니다. 대화형 세션에서 전환하거나, 이 모델에 대한 훅의 결정을 변경하십시오.
* **`so organization-managed PreModelSwitch hooks could not be checked`**: 예를 들어 관리형 플러그인 로드가 실패하여, Claude Code가 조직의 [관리형 플러그인](https://code.claude.com/docs/ko/settings-reference.md#enabledplugins)이 제공하는 PreModelSwitch 훅을 확인할 수 없었습니다. 그 훅 중 하나가 전환을 차단할 수 있으므로, Claude Code는 확인 없이 전환을 적용하는 대신 거부합니다. 이유의 시작 부분에 무엇이 실패했는지 표시됩니다. Claude Code는 전환을 시도할 때마다 다시 확인하므로, 이미 해소된 실패는 더 이상 차단하지 않습니다. 계속 실패하면 `claude --debug`를 실행하고 다시 전환하여 세부 정보를 확인한 후, 플러그인을 수정하거나 관리자에게 수정을 요청하십시오.
* **`a PreModelSwitch hook failed before answering`** 또는 **`PreModelSwitch hooks were cancelled (the control stream closed) before answering`**: 훅 실행이 판정 없이 종료되었으며, Claude Code는 이를 승인으로 처리하지 않습니다. `claude --debug`를 실행하여 무엇이 실패했는지 확인한 후 다시 전환하십시오.

v2.1.260 이전에는 관리형 플러그인 거부 메시지가 `plugin hooks could not be loaded, so PreModelSwitch hooks could not be checked; see the debug log`였습니다. Claude Code는 플러그인 로드를 한 번 재시도한 후, 조직이 관리하는 플러그인이 없는 경우에도 세션의 이후 전환을 거부했습니다. 해당 버전에서는 세션을 재시작하여 플러그인 로드를 다시 실행하십시오.

### Couldn't save it as your default

`/model <name>` 또는 `/model` 선택기에서 `Enter`를 누르는 등의 방법으로 기본값으로 저장할 모델을 선택했지만, Claude Code가 사용자 설정 파일인 `~/.claude/settings.json`에 선택 내용을 기록할 수 없었습니다. 전환 자체는 적용되었으므로 현재 세션은 선택한 모델로 실행되지만, 기본값은 변경되지 않았으며 다음 세션은 이전 값으로 시작됩니다.

```text theme={null}
Set model to Fable 5.1 for this session only · couldn't save it as your default: ~/.claude/settings.json can't be written (EROFS)
```

파일 경로 뒤의 이유는 무엇이 실패했는지를 나타냅니다.

* **`can't be written (<code>)`**: 괄호 안의 운영 체제 오류 코드와 함께 기록이 실패했습니다. 예를 들어 파일 또는 파일이 링크하는 대상이 쓰기를 거부하는 파일 시스템에 있는 경우 `EROFS`가 표시됩니다. 파일을 쓰기 가능하게 만든 후 다시 전환하십시오. 다른 도구가 파일을 생성하는 경우 대신 해당 도구에서 `model` 키를 설정하십시오. [Claude Code에서 변경한 내용이 새 세션에서 사라지는 경우](https://code.claude.com/docs/ko/settings.md#a-change-you-made-in-claude-code-is-lost-in-new-sessions)를 참조하십시오.
* **`isn't valid JSON`**: 디스크의 파일을 파싱할 수 없으며, Claude Code는 다시 읽을 수 없는 내용을 덮어쓰지 않고 그대로 둡니다. 구문 오류를 수정한 후 다시 전환하십시오. [손상된 설정 파일 수정](https://code.claude.com/docs/ko/settings.md#fix-a-broken-settings-file)을 참조하십시오.

`couldn't confirm it was saved as your default (~/.claude/settings.json is still being written)`로 끝나는 알림은 3초가 지나도 기록이 완료되지 않았다는 뜻입니다. 기록은 백그라운드에서 계속되므로 기본값이 여전히 저장될 수 있습니다. 다음 세션이 어떤 모델로 시작되는지 확인하거나 `/model <name>`을 다시 실행하십시오.

v2.1.265 이전에는 기록이 실패한 경우에도 알림에 모델이 `saved as your default for new sessions`라고 표시되었습니다.

### Advisor is less capable than the current main model

[advisor 모델](https://code.claude.com/docs/ko/advisor.md)의 순위가 세션의 메인 모델보다 낮으므로, Claude Code는 선택 내용을 유지하지만 advisor를 메인 모델의 요청에 연결하지 않습니다.

```text theme={null}
Advisor set to Opus 4.8
Note: Opus 4.8 is less capable than the current main model (Sonnet 5.5), so the advisor will not activate. Choose a more capable advisor, or switch to a smaller main model.
```

다른 메시지도 같은 상황을 보고합니다.

* 대화형 세션에서는 `Advisor will not activate on the main model (advisor is less capable); subagents may still use it and may use more tokens · /advisor`라는 알림이 표시됩니다.
* [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 `--advisor` 플래그와 함께 실행하고 해당 실행이 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)이 아닌 경우, stderr에 경고가 출력되고 실행은 그대로 시작됩니다. 경고는 `"<advisor>" cannot advise "<main model>" (the advisor must be at least as capable as the main model). The advisor will not be used for the main model.`입니다. 대화형 세션은 이 경고를 [디버그 로그](#configuration-warnings)에만 기록합니다.

**해결 방법:**

* 순위가 더 높은 advisor나 순위가 더 낮은 메인 모델을 선택합니다. [advisor 모델 선택](https://code.claude.com/docs/ko/advisor.md#choose-an-advisor-model)에서 순위를 확인하고 각 메인 모델에 허용되는 advisor 목록을 볼 수 있습니다.
* advisor가 자문할 수 있는 모델의 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)가 계속 advisor를 사용하도록 하려면 advisor 설정을 그대로 두십시오

v2.1.287 이전에는 Claude Code가 여러 조합의 순위를 다르게 매겼습니다. Opus 4.7 또는 Opus 4.8 메인 모델과 Sonnet 5.5 advisor 조합에 대해 이 안내를 표시했지만, 현재는 이 조합을 허용합니다. 또한 Sonnet 5.5 메인 모델과 Opus 4.8 advisor처럼 현재는 이 안내를 표시하는 일부 advisor를 연결했습니다.

### thinking.type.enabled is not supported for this model

Claude Code 버전이 선택한 모델에 필요한 최소 버전보다 오래되었습니다. CLI가 모델이 더 이상 허용하지 않는 사고 구성을 보냈습니다.

```text theme={null}
API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use "thinking.type.adaptive" and "output_config.effort" to control thinking behavior.
```

**해결 방법:**

* `claude update`를 실행하고 Claude Code를 재시작합니다. Opus 4.7에는 v2.1.111 이상이 필요합니다. Opus 4.8에는 v2.1.154 이상이 필요합니다. Sonnet 5에는 v2.1.197 이상이 필요합니다. Opus 5에는 v2.1.219 이상이 필요합니다. Opus 5.5에는 v2.1.280 이상이 필요합니다. Sonnet 5.5에는 v2.1.284 이상이 필요합니다
* [stable 릴리스 채널](https://code.claude.com/docs/ko/setup.md#configure-release-channel)에서는 업데이트해도 최신 stable 릴리스보다 더 새로운 버전으로 이동하지 않으며, 이 릴리스도 위 버전보다 오래되었을 수 있습니다. latest 채널로 이동한 후 업데이트하십시오
* 업그레이드할 수 없다면 `/model`을 실행하고 대신 Opus 4.6 또는 Sonnet 4.6을 선택합니다
* [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)에서 이 오류가 발생하면 대신 SDK 패키지를 업그레이드하십시오. Opus 4.8에는 TypeScript SDK v0.3.154 이상과 Python SDK v0.2.88 이상이 필요합니다. Sonnet 5에는 TypeScript SDK v0.3.197 이상이 필요합니다. Opus 5에는 TypeScript SDK v0.3.219 이상이 필요합니다. Opus 5.5에는 TypeScript SDK v0.3.280 이상이 필요합니다. Sonnet 5.5에는 TypeScript SDK v0.3.284 이상이 필요합니다

### 사고가 꺼진 상태에서는 effort를 사용할 수 없음

[확장 사고](https://code.claude.com/docs/ko/model-config.md#extended-thinking)를 끈 상태에서 `high`보다 높은 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)으로 실행했습니다. 모델이 이 조합을 허용하지 않으므로 API가 요청을 거부했습니다.

```text theme={null}
API Error: Effort 'xhigh' isn't available with thinking turned off on this model · run /effort high to continue, or turn thinking back on (unset MAX_THINKING_TOKENS=0)
```

`·` 뒤의 힌트는 세션에 따라 다릅니다. 비대화형 세션에서는 `use --effort high (or the effortLevel setting)`으로, Claude Desktop 앱이 실행하는 세션에서는 `you can lower effort to High`로 표시됩니다.

**해결 방법:**

* [effort 수준을](https://code.claude.com/docs/ko/model-config.md#set-the-effort-level) `high` 이하로 낮춥니다.
* 예를 들어 [`MAX_THINKING_TOKENS`](https://code.claude.com/docs/ko/env-vars) 설정을 해제하거나 설정에서 [`"alwaysThinkingEnabled": false`](https://code.claude.com/docs/ko/settings-reference#alwaysthinkingenabled)를 제거하여 사고를 다시 켭니다.

v2.1.242 이전에는 Claude Code가 API 자체의 메시지를 표시했습니다: `API Error: 400 output_config.effort 'xhigh' is not supported when thinking is disabled on this model. Use effort 'high' or below, or enable thinking.` v2.1.251 이전에는 Claude Code가 설정한 effort 수준 그대로 요청을 보냈기 때문에, 사고가 꺼진 상태에서 Opus 5는 `high`보다 높은 모든 요청을 거부했습니다. 이제 Claude Code는 Opus 5처럼 이 조합을 거부하는 것으로 알려진 모델에는 대신 effort `high`로 요청을 보냅니다.

### Thinking budget exceeds output limit

구성된 확장 사고 예산이 최대 응답 길이를 초과하여 실제 답변을 위한 공간이 남아 있지 않습니다.

```text theme={null}
API Error: 400 ... max_tokens must be greater than thinking.budget_tokens
```

**해결 방법:**

* [`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](https://code.claude.com/docs/ko/env-vars)를 사고 예산보다 높게 올립니다
* 예산이 출력 길이와 어떻게 상호 작용하는지는 [확장 사고](https://code.claude.com/docs/ko/model-config.md#extended-thinking)를 참조하십시오

### Response exceeded the output token maximum

Claude의 응답이 요청에서 허용한 최대 출력 토큰 수에 도달하여 그 지점에서 잘렸습니다.

```text theme={null}
API Error: Claude's response exceeded the ... output token maximum. To configure this behavior, set the CLAUDE_CODE_MAX_OUTPUT_TOKENS environment variable.
API Error: Claude's response exceeded the 64000 output token maximum for a request sent without streaming. The CLAUDE_CODE_MAX_OUTPUT_TOKENS environment variable cannot raise this limit.
```

`a request sent without streaming`을 명시하는 형태는 스트리밍 요청이 실패하여 Claude Code가 스트리밍 없이 다시 보냈다는 뜻이며, 이 경우 응답은 64,000 출력 토큰으로 제한됩니다. v2.1.299 이전에는 이렇게 다시 보낸 요청에서 잘린 응답이 이 메시지 없이 응답이 완료된 것처럼 턴을 종료했습니다.

**해결 방법:**

* 응답이 잘리기 전에 Claude가 일부 텍스트를 작성했다면, 대화형 세션에서 `continue`로 답하여 나머지를 요청합니다. 그 텍스트는 대화에 남아 있습니다.
* 메시지가 `CLAUDE_CODE_MAX_OUTPUT_TOKENS`를 설정하라고 안내하면, 값의 상한은 [`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](https://code.claude.com/docs/ko/env-vars)를, 설정 위치는 [환경 변수 설정](https://code.claude.com/docs/ko/env-vars.md#set-environment-variables)을 참조하십시오
* 각 응답이 한도를 넘지 않도록 하려면, 응답당 파일 하나나 섹션 하나처럼 Claude에게 출력을 더 작은 단위로 요청하십시오

### Tool use or thinking block mismatch

대화 기록이 일관되지 않은 상태로 API에 도달했습니다.

```text theme={null}
API Error: 400 due to tool use concurrency issues. Run /rewind to recover the conversation.
API Error: 400 orphaned tool_result in conversation history. Run /rewind to recover the conversation.
API Error: 400 duplicate tool_use ID in conversation history. Run /rewind to recover the conversation.
API Error: 400 ... unexpected `tool_use_id` found in `tool_result` blocks
API Error: 400 ... thinking blocks ... cannot be modified
```

모든 변형은 같은 의미입니다. 기록에 있는 `tool_use`, `tool_result`, `thinking` 블록의 순서가 더 이상 API가 기대하는 것과 일치하지 않습니다.

**해결 방법:**

* Opus 4.7 또는 Opus 4.8을 사용 중이라면 먼저 `claude update`를 실행하십시오. v2.1.156 이전 버전은 일반적인 도구 사용 중에도 이 오류를 일으킬 수 있으며, `/rewind`로 해결되지 않습니다.
* `/rewind`를 실행하거나 Esc를 두 번 눌러 손상된 턴 이전의 체크포인트로 되돌아간 후 그 지점부터 계속합니다. 체크포인트가 생성되고 복원되는 방식은 [체크포인트](https://code.claude.com/docs/ko/checkpointing.md)를 참조하십시오.

### Invalid data in redacted\_thinking block

대화 기록의 이전 턴에 포함된 `redacted_thinking` 블록을 API가 수락할 수 없어서 400으로 요청을 거부했습니다.

```text theme={null}
API Error: 400 ... Invalid `data` in `redacted_thinking` block
```

Claude Code는 대화의 이전 사고를 요청에서 제외하고 한 번 재시도하므로, 세션은 오류를 표시하지 않고 계속됩니다. v2.1.282 이전에는 Claude Code가 거부된 블록을 유지했기 때문에 이후 모든 턴이 같은 오류로 실패했습니다.

**해결 방법:**

* v2.1.281 이하 버전에서 모든 턴이 이 오류로 실패한다면 `claude update`를 실행하고 세션을 재개합니다
* 오류가 계속되면 `/clear`를 실행하여 해당 블록이 없는 대화를 시작합니다

### Unsupported tool content removed

Claude Code가 Anthropic API에 직접 연결하여 저장된 세션을 로드하거나 미리 볼 때, Anthropic API가 허용하지 않는 도구 내용을 제거하고, 제거된 내용이 두 thinking 블록 사이에 있던 위치에 다음 줄을 남깁니다.

```text theme={null}
[Unsupported tool content removed]
```

이러한 내용은 Anthropic API 이외의 무언가가 API 형식으로 응답했을 때 세션 파일에 들어갑니다. 일반적으로 다른 공급자의 도구 호출을 변환하는, [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)로 설정된 서드파티 프록시가 원인입니다. Claude Code는 세션이 Anthropic API에 직접 연결된 경우에만 이를 제거하며, 세션이 프록시를 거치거나 다른 공급자에서 실행되는 경우에는 저장된 기록을 그대로 로드합니다. v2.1.246 이전에는 Claude Code가 도구 사용과 그 결과를 API로 다시 보냈기 때문에, 재개된 세션의 모든 턴이 `messages.1.content.0.server_tool_use.name: Input should be 'web_search', 'web_fetch', ...` 같은 400 오류로 실패했습니다.

**해결 방법:**

* 자리 표시자 줄이 보이면 별도 조치가 필요하지 않습니다. 세션은 제거된 내용 없이 계속됩니다.
* 대신 재개된 세션의 모든 턴이 400 오류로 실패한다면 `claude update`를 실행하고 세션을 다시 재개하십시오. v2.1.246 이전 버전은 해당 내용을 제거하지 않습니다.

### role 'system' must precede an 'assistant' message

시스템 메시지가 대화에서 API가 허용하지 않는 위치에 있기 때문에 API가 400으로 요청을 거부했습니다.

```text theme={null}
API Error: 400 messages.6: role 'system' must precede an 'assistant' message or end the array; ...
```

Claude Code는 일부 리마인더 및 첨부 텍스트를 대화 내의 시스템 메시지로 보냅니다. API가 그 위치를 거부하면, Claude Code는 해당 텍스트를 일반 사용자 메시지로 보내는 방식으로 요청을 한 번 재시도합니다. `use the top-level 'system' parameter for the initial system prompt` 같은 API의 유사한 위치 관련 문구도 같은 방식으로 복구됩니다.

오류가 실제로 표시된다면, 거부된 시스템 메시지는 Claude Code가 제거할 수 있는 것이 아닙니다. 이는 보통 Claude Code와 API 사이의 프록시나 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)가 자체 시스템 메시지를 추가했다는 뜻입니다.

**해결 방법:**

* [`ANTHROPIC_BASE_URL`](https://code.claude.com/docs/ko/env-vars)로 구성된 프록시나 게이트웨이 뒤에서 오류가 매 턴마다 반복된다면, 프록시 없이 연결하여 원인을 확인하고 해당 프록시 운영자에게 오류를 보고하십시오
* `/clear`를 실행하여 새 대화를 시작합니다. 거기서도 오류가 다시 발생한다면, 원인은 저장된 대화가 아니라 요청 경로에 있습니다.

v2.1.280 이전에는 Claude Code가 이 문구를 인식하지 못했기 때문에, 거부된 시스템 메시지가 Claude Code 자신이 보낸 것일 때도 오류가 표시되었고 대화의 이후 모든 턴이 같은 방식으로 실패했습니다.

### Invalid encrypted\_content in search\_result block

대화 기록에 API가 복호화할 수 없는 호스팅 웹 검색 내용이 포함되어 있어 API가 400으로 요청을 거부했습니다. 문구에는 읽을 수 없는 필드가 명시됩니다.

```text theme={null}
API Error: 400 ... Invalid `encrypted_content` in `search_result` block
API Error: 400 ... Invalid `encrypted_index` in `text` block
API Error: 400 ... Failed to decrypt web search result content
API Error: 400 ... Invalid `encrypted_stdout` in `encrypted_code_execution_result` block
```

API의 호스팅 [웹 검색 도구](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-search-tool) 결과에는 API만 읽을 수 있는 암호화된 필드가 포함됩니다. `encrypted_stdout` 문구는 이러한 결과를 읽은 호스팅 코드 실행 프로그램의 출력을 가리키며, API는 이 출력도 암호화합니다. API는 다른 조직을 위해 생성된 내용처럼 복호화할 수 없는 내용을 다시 보내는 요청을 거부합니다.

Claude Code 자체의 [WebSearch 도구](https://code.claude.com/docs/ko/tools-reference.md#websearch-tool-behavior)는 검색 결과를 일반 텍스트로 기록하므로, 이러한 블록은 보통 호스팅 웹 검색을 직접 실행한 프록시나 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 통해 대화에 들어옵니다.

세 가지 웹 검색 문구의 경우, Claude Code는 검색 호출, 결과, 인용을 전송 내용에서 제외하고 요청을 한 번 재시도하므로, 세션은 오류를 표시하지 않고 계속됩니다. `encrypted_stdout` 문구에는 이러한 복구가 없으므로 해당 메시지는 여전히 표시됩니다. v2.1.282 이전에는 Claude Code가 거부된 웹 검색 블록도 유지했기 때문에, 이후 모든 턴과 `/compact`가 같은 방식으로 실패했습니다.

**해결 방법:**

* v2.1.281 이하 버전에서 모든 턴이 웹 검색 문구 중 하나로 실패한다면 `claude update`를 실행하고 세션을 재개합니다
* 오류가 계속되거나 메시지에 `encrypted_stdout`이 명시된 경우, `/rewind`를 실행하여 해당 내용을 추가한 턴 이전의 체크포인트로 되돌아가거나, `/clear`를 실행하여 해당 내용이 없는 대화를 시작합니다
* 프록시나 게이트웨이 뒤에서 Claude Code를 실행한다면 해당 운영자에게 오류를 보고하십시오

### Usage Policy refusal

대화의 내용이 [이용 정책](https://www.anthropic.com/legal/aup) 검사를 트리거하여 API가 응답을 거절했습니다.

메시지에 `` Details: `[reasoning_extraction]` `` 줄이 포함되어 있다면 [세이프가드가 Claude의 추론에 대한 요청을 감지한 경우](#safeguards-flagged-a-request-for-claudes-reasoning)를 참조하십시오.

메시지에는 거절이 잘못되었다고 판단될 때 지원팀에 전달할 수 있는 Request ID와 Message ID가 포함됩니다.

```text theme={null}
API Error: Opus 4.6 can't help with this. Start a new session to continue.

Send feedback with /feedback or learn more: https://www.anthropic.com/legal/aup
```

메시지에는 거절한 모델의 이름이 표시되며, 기록된 모델이 없으면 `Claude`가 표시됩니다.

검사는 최신 프롬프트뿐만 아니라 대화 전체를 평가하므로, 같은 세션에서 새 메시지를 보내면 보통 같은 거절이 다시 트리거됩니다. 디스크의 트랜스크립트에 여전히 트리거한 내용이 남아 있으므로, 세션을 종료한 후 `--continue` 또는 `--resume`으로 다시 열어도 마찬가지입니다. [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Google Cloud's Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md), [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md)에서는 이 메시지가 모델의 안전 조치가 사이버 보안 주제로 감지한 요청에도 표시됩니다. [안전 조치가 사이버 보안 주제를 감지한 경우](#safety-measures-flagged-a-cybersecurity-topic)를 참조하십시오.

v2.1.219 이전에는 메시지가 `Claude Code is unable to respond to this request, which appears to violate our Usage Policy (https://www.anthropic.com/legal/aup). Please double press esc to edit your last message or start a new session for Claude Code to assist with a different task.`였습니다.

**해결 방법:**

* Esc를 두 번 누르거나 `/rewind`를 실행하여 거절을 트리거한 턴 이전의 체크포인트로 되돌아간 후, 표현을 바꾸거나 다른 접근 방식을 사용합니다. [체크포인트](https://code.claude.com/docs/ko/checkpointing.md)를 참조하십시오.
* 어떤 턴이 원인인지 파악할 수 없다면 `/clear`를 실행하여 같은 프로젝트에서 새 대화를 시작합니다. 이전 대화는 디스크에 보존되며 `/resume`에서 계속 사용할 수 있습니다.
* 되감기를 사용할 수 없는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)(`-p`)에서는 `--continue` 없이 새 세션에서 표현을 바꾼 프롬프트로 재시도하십시오. 정책 검사는 모델마다 다르므로, 경우에 따라 `--model`로 다른 모델로 전환하면 거절이 해결될 수도 있습니다.

### 안전 조치가 사이버 보안 주제로 플래그 지정함

모델의 안전 조치가 대화 내용을 사이버 보안 주제로 플래그 지정했습니다. 메시지에는 요청을 플래그 지정한 모델의 이름이 표시됩니다.

```text theme={null}
API Error: Opus 4.8's safeguards flagged this message. Our intentionally broad safeguards allow us to deliver more capabilities faster, but can sometimes flag legitimate cybersecurity work. Send feedback with /feedback or learn more: https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude
```

메시지에 `` Details: `[reasoning_extraction]` `` 줄이 포함되어 있다면 [안전 장치가 Claude의 추론을 요청하는 것으로 플래그 지정함](#safeguards-flagged-a-request-for-claudes-reasoning)을 참조하세요.

이 메시지는 정당한 사이버 보안 작업에 대한 액세스 권한을 부여하는 [Cyber Verification Program](https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude)으로 연결됩니다. [자동 모델 폴백](https://code.claude.com/docs/ko/model-config.md#automatic-model-fallback)이 적용되는 모델은 이 링크 없이 다른 메시지를 출력하며, Opus 5.5와 Sonnet 5.5에서는 `<model>'s safeguards flagged this session`으로 시작합니다. 해당 섹션에서는 Claude Code가 대신 모델을 전환하는 경우도 다룹니다.

[Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Google Cloud's Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md), [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md)에서는 사이버 보안 플래그가 지정되면 대신 [사용 정책 거부](#usage-policy-refusal) 메시지가 표시됩니다.

**해결 방법:**

* 작업에 이 콘텐츠가 필요한 경우 [Cyber Verification Program](https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude)을 통해 액세스를 신청합니다
* 요청이 사이버 보안 주제와 관련이 없었다면 `/feedback`을 실행하여 오탐을 보고합니다
* 같은 세션에서 작업을 계속하려면 Esc를 두 번 누르거나 `/rewind`를 실행하여 플래그를 유발한 턴 이전의 체크포인트로 되돌아간 다음 다른 방식으로 접근합니다. [체크포인트](https://code.claude.com/docs/ko/checkpointing.md)를 참조하세요.

표시되는 메시지의 문구가 다음 중 하나와 같다면 이전 Claude Code 버전에서 표시되는 동일한 플래그입니다.

* v2.1.219부터 v2.1.296까지는 메시지의 마지막 문장 앞에 `Apply to the Cyber Verification Program to reduce these interruptions.`가 포함될 수도 있었습니다
* v2.1.203부터 v2.1.218까지는 메시지가 `<model> has safety measures that flagged this message for a cybersecurity topic. To learn about the Cyber Verification Program and apply for access, visit our help center:`였으며 그 뒤에 동일한 고객 센터 링크가 이어졌습니다. 대화형 세션에서는 `If you were not engaging in a cybersecurity topic, please send feedback via /feedback.`가 이어졌습니다
* v2.1.203 이전에는 메시지가 `<model>'s safeguards flagged this message for a cybersecurity topic. If your work requires this access, you can apply for an exemption:`였으며 그 뒤에 예외 신청 양식 링크가 이어졌습니다

### 안전 장치가 Claude의 추론을 요청하는 것으로 플래그 지정함

안전 장치가 요청을 모델의 내부 추론을 응답에 재현하도록 요구하는 것으로 플래그 지정하여 API가 요청을 거부했습니다. API는 이 [거부 범주](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback#refusal-response)를 `reasoning_extraction`이라고 부르며, 거부 메시지에는 다음 줄이 포함됩니다.

```text theme={null}
Details: `[reasoning_extraction]`
```

v2.1.234 이전에는 거부 메시지에 `Details` 줄이 포함되지 않았습니다.

**해결 방법:**

* Claude에게 사고나 추론을 그대로 또는 고정된 형식으로 작성하도록 요청하는 지시(예: `<thinking>` 섹션, 스크래치패드 섹션, JSON 출력의 `reasoning` 필드)를 제거하거나 다르게 표현합니다. 이러한 지시는 프롬프트에 있을 수도 있고, CLAUDE.md, 스킬, 서브에이전트 프롬프트, 출력 스타일, MCP 도구 설명처럼 Claude Code가 함께 로드하는 사용자 지정 항목에 있을 수도 있습니다.
* 사용자 지정 항목이 원인인지 확인하려면 터미널에서 [`claude --safe-mode`](https://code.claude.com/docs/ko/cli-reference#cli-flags)를 실행하여 사용자 지정 항목이 비활성화된 세션을 시작한 다음 같은 프롬프트를 보냅니다
* 사용자 지정 항목을 변경한 후에는 새 세션을 시작합니다
* 이미 보낸 프롬프트를 다르게 표현하려면 [되감기 및 요약](https://code.claude.com/docs/ko/checkpointing.md#rewind-and-summarize)을 참조하세요
* Claude에게 답변에 대한 설명을 요청하는 것은 여전히 가능합니다. 간단한 설명, 결과의 근거, 수행한 작업의 요약을 요청하세요. Claude의 사고 요약을 읽으려면 [`showThinkingSummaries`](https://code.claude.com/docs/ko/settings-reference#showthinkingsummaries)를 참조하세요.
* 더 많은 예시와 다르게 표현한 요청이 여전히 거부될 때의 해결 방법은 [추론을 thinking 블록에 유지하기](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback#keep-reasoning-in-thinking-blocks)를 참조하세요

### Output blocked by content filtering policy

API의 출력 콘텐츠 필터가 Claude가 생성 중이던 응답을 중단했습니다. 메시지 텍스트는 API에서 제공됩니다.

```text theme={null}
API Error: Output blocked by content filtering policy
```

**해결 방법:**

* 마지막 메시지를 다르게 표현하거나 다른 방식으로 접근합니다
* 차단을 유발한 턴 이전의 체크포인트로 되돌아가려면 Esc를 두 번 누르거나 `/rewind`를 실행합니다. [체크포인트](https://code.claude.com/docs/ko/checkpointing.md)를 참조하세요

## 명령줄 오류

이러한 오류는 `claude` 명령줄과 그 하위 명령, 프롬프트에 제출한 명령 이름, 그리고 `/security-review`처럼 프롬프트가 실행되기 전에 셸 명령을 실행하여 컨텍스트를 수집하는 명령에서 발생합니다. CLI를 다시 시작하는 `/tui`에서도 발생합니다.

### `--bg`와 `--print` 간의 충돌

이 메시지는 Claude Code v2.1.198 이상이 필요합니다. 같은 `claude` 호출에서 `--bg`를 `-p` 또는 `--print`와 함께 사용했습니다. `--bg`는 나중에 `claude agents`로 연결하는 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md#from-your-shell)을 시작하는 반면, `--print`는 [비대화형으로](https://code.claude.com/docs/ko/headless.md) 실행되며 `claude agents`가 연결하는 대화형 세션을 시작하지 않습니다. v2.1.198 이전에는 이 조합이 아무런 알림 없이 연결할 수 없는 백그라운드 작업을 생성했습니다.

```text theme={null}
--bg and --print conflict: --print never starts the interactive session that `claude agents` attaches to, so the job would be unattachable. The prompt is the positional — drop --print: `claude --bg '<task>'`.
```

**해결 방법:**

* `-p` 또는 `--print`를 제거합니다. `--bg`는 프롬프트를 위치 인수로 받으므로 `claude --bg "<task>"`만으로 완전한 명령이 됩니다. [셸에서 새 에이전트 Dispatch하기](https://code.claude.com/docs/ko/agent-view.md#from-your-shell)를 참조하십시오.
* 백그라운드 세션을 만드는 대신 프롬프트를 비대화형으로 실행하고 결과를 출력하려면 `--bg`를 제거하고 `claude -p "<task>"`를 실행합니다

### Couldn't tell whether `--bg` is a flag or text

`claude`를 실행할 때 `--bg` 또는 `--background`를 Claude Code가 백그라운드 플래그인지 텍스트인지 구분할 수 없는 위치에 넣은 경우입니다. 이 명령은 아무것도 시작하지 않고 다음 줄을 출력한 뒤 종료 코드 1로 종료되었습니다:

```text theme={null}
Couldn't tell whether --bg is a flag or text here, so nothing was started. To start a background session put it first: claude --bg <prompt>
```

`--background`를 입력한 경우에는 이 줄에 `--background`가 표시됩니다.

**해결 방법:**

* [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md#from-your-shell)을 시작하려면 셸에서 플래그를 맨 앞에 두고 명령을 다시 실행합니다: `claude --bg --name nightly-audit "<task>"`

### 시스템 프롬프트 플래그와 파일 형식 간의 충돌

하나의 `claude` 호출에서 [`--append-subagent-system-prompt`](https://code.claude.com/docs/ko/cli-reference#cli-flags)와 `--append-subagent-system-prompt-file`을 함께 전달했기 때문에 `claude`가 세션을 시작하지 않고 종료 코드 1로 종료됩니다:

```text theme={null}
Error: Cannot use both --append-subagent-system-prompt and --append-subagent-system-prompt-file. Please use only one.
```

v2.1.283 이전에는 `--system-prompt`와 `--system-prompt-file`, 또는 `--append-system-prompt`와 `--append-system-prompt-file`을 함께 전달했을 때도 `claude`가 같은 방식으로 종료되었습니다. 이러한 쌍이 [결합](https://code.claude.com/docs/ko/cli-reference.md#system-prompt-flags)되지 않고 충돌했기 때문입니다. 해당 버전에서는 메시지에 함께 사용한 쌍이 표시됩니다.

**해결 방법:**

* 플래그의 한 가지 형식만 유지하고 다른 하나는 제거합니다. 고정된 프롬프트 파일과 실행별 텍스트를 결합하려면 두 플래그를 모두 전달하는 대신 실행 전에 텍스트를 파일에 병합합니다

### 잘못된 `--agents` 구성

`--agents`에 전달한 값이 잘못되어 `claude`가 세션을 시작하지 않고 종료 코드 1로 종료됩니다. `--safe-mode`를 전달하거나 [`CLAUDE_CODE_SAFE_MODE`](https://code.claude.com/docs/ko/env-vars#variables)를 설정하면 Claude Code는 `--agents`를 완전히 무시합니다. `--resume` 또는 `--continue`를 사용하면 인라인 JSON 값은 검사되지 않고 세션이 시작되지만, 파일에서 읽은 값은 매번 실행할 때마다 검사됩니다. v2.1.242 이전에는 Claude Code가 그래도 세션을 시작했습니다.

```text theme={null}
Error: Invalid --agents configuration:
<what failed>
```

첫 번째 줄 다음에 오는 내용은 값이 실패한 방식에 따라 달라집니다. Claude Code는 다음 검사를 순서대로 실행하고 처음 실패한 검사에서 멈춥니다. 값에 두 종류의 문제가 있으면 첫 번째 문제를 수정한 후에야 두 번째 문제가 표시됩니다:

1. 값이 `{`로 시작하지만 JSON으로 파싱되지 않거나 `--agents` 파일의 내용이 파싱되지 않으면, Claude Code는 JSON 파서 자체의 메시지를 담은 `invalid JSON:` 줄 하나를 출력합니다
2. 파싱은 되지만 에이전트 정의가 [CLI로 정의한 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#choose-the-subagent-scope)의 스키마와 일치하지 않으면, Claude Code는 문제마다 한 줄씩 출력합니다
3. 에이전트 이름이 `-`로 시작하면 Claude Code는 `<name>: agent names must not start with '-'`를 출력합니다

문제 줄이 20개를 넘으면 Claude Code는 처음 20개를 출력하고 나머지는 `…and N more`로 대체합니다.

`--print`와 함께 사용하면 `--agents`는 인라인 객체 대신 [JSON 파일 경로](https://code.claude.com/docs/ko/sub-agents.md#choose-the-subagent-scope)도 받습니다. v2.1.281 이전에는 `--agents`가 인라인 JSON만 받았으며 파일 경로를 잘못된 JSON으로 처리했습니다. 파일 형식에는 자체적인 거부 메시지가 있으며, 이 메시지 대신 출력됩니다. 다음은 그 예입니다:

* **`Error: --agents takes a JSON object, or a file path only with --print (-p)`**: Claude Code가 대화형 세션에서 값을 파일 경로로 읽었습니다. 정의를 인라인 JSON으로 전달하거나, 파일에서 읽으려면 `-p`를 추가합니다.
* **`Error: --agents file not found: <path>`**: 해당 경로에 파일이 없습니다. `{`로 시작하지 않고 유효한 JSON이 아닌 값은 경로로 읽히므로, 셸이 망가뜨린 인라인 JSON도 이런 방식으로 실패할 수 있습니다. 경로나 따옴표 처리를 확인하고 명령을 다시 실행합니다.

**해결 방법:**

* 메시지에 나열된 각 문제를 수정한 다음 명령을 다시 실행합니다. [CLI로 정의한 서브에이전트가 받는 필드](https://code.claude.com/docs/ko/sub-agents.md#choose-the-subagent-scope)를 참조하십시오.

### `--restricted` 세션에서는 클라우드 세션을 만들 수 없음

[`--restricted`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 세션을 시작하면 Claude Code는 해당 세션에서 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#from-terminal-to-cloud)을 만드는 것을 거부합니다. 새 세션은 제한된 프로세스 외부에서 실행되어 제한 모드를 적용하지 않기 때문입니다. Claude Code는 서버에 연결하기 전에 클라이언트에서 거부하므로 클라우드 세션이 생성되지 않습니다:

```text theme={null}
Cloud sessions cannot be created from a --restricted session: they would not enforce it.
```

**해결 방법:**

* 제한된 세션에서 작업을 로컬로 실행합니다
* 세션 실행 방식을 제어할 수 있다면 `--restricted` 없이 새 `claude` 세션을 시작하고 그곳에서 클라우드 세션을 만듭니다

v2.1.248 이전의 Claude Code에는 `--restricted` 플래그가 없었으며, 이전 버전은 알 수 없는 옵션 오류로 플래그 자체를 거부합니다.

### 조직 정책에 의해 클라우드 세션이 비활성화됨

조직의 `allow_remote_sessions` 정책이 꺼져 있어 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)과 이를 사용하는 명령을 사용할 수 없습니다:

```text theme={null}
Cloud sessions are disabled by your organization's policy. Contact your organization admin to enable them.
```

이 메시지는 [터미널에서 클라우드 세션을 만들 때](https://code.claude.com/docs/ko/claude-code-on-the-web.md#from-terminal-to-cloud)와 `/teleport`, `/remote-env`, `/web-setup`처럼 클라우드 세션이 필요한 명령을 제출할 때 표시됩니다. v2.1.268 이전에는 이러한 명령을 제출하면 대신 [`Unknown command`](#unknown-command)가 반환되었습니다.

메시지가 대신 이 세션에서 사용 중인 자격 증명을 지목하고 `Cloud sessions use your claude.ai login.`으로 끝나는 경우, [Cloud sessions use your claude.ai login](#cloud-sessions-use-your-claude-ai-login)을 참조하십시오. Claude Code가 조직의 정책을 전혀 로드하지 못한 경우에는 대신 [다른 메시지](#couldnt-verify-your-organizations-policy-for-cloud-sessions)가 표시됩니다.

**해결 방법:**

* 조직의 [Owner](https://code.claude.com/docs/ko/server-managed-settings.md#access-control)에게 [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code)의 Claude Code 관리자 설정에서 클라우드 세션을 활성화하도록 요청합니다

### Cloud sessions use your claude.ai login

[정책 거부](#cloud-sessions-are-disabled-by-your-organizations-policy) 메시지가 이 세션에서 사용 중인 자격 증명을 지목하고 이 문장으로 끝나는 경우, Claude Code는 해당 자격 증명을 발급한 조직의 클라우드 세션 정책을 확인한 것입니다. 그 조직은 claude.ai 로그인이 속한 조직과 다를 수 있습니다:

```text theme={null}
Cloud sessions are disabled by your organization's policy. This session is using ANTHROPIC_API_KEY, so Claude Code checked the policy for the organization that key belongs to. Cloud sessions use your claude.ai login.
```

마지막 문장은 클라우드 세션이 해당 자격 증명이 아니라 claude.ai 로그인으로 실행된다는 의미입니다. 이 형식은 `--cloud` 또는 `--teleport` 등으로 셸에서 클라우드 세션을 시작하거나, 재개하거나, 메시지를 보낼 때 나타납니다. v2.1.296 이전에는 이 경우에도 Claude Code가 조직 관리자에게 문의하라는 형식을 출력했습니다.

### Couldn't verify your organization's policy for cloud sessions

이 메시지들은 Claude Code가 조직의 정책을 로드하지 못했음을 의미합니다. Claude Code는 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 생성하거나, 재개하거나, 메시지를 보내기 전에 이 정책을 확인합니다. 정책 요청이 아직 완료되지 않은 동안에는 메시지가 다음과 같습니다:

```text theme={null}
Couldn't verify your organization's policy for cloud sessions. Check your network connection and try again.
```

세션 내에서 `/teleport`나 `/web-setup`처럼 클라우드 세션이 필요한 명령도 이 메시지를 표시합니다. 셸이라면 `Cloud sessions aren't available:` 형식을 출력할 상황에서도 마찬가지이며, 두 번째 문장은 `Check your network connection, then restart Claude Code and try again.`입니다.

정책 요청이 실패하면 메시지에 무엇이 실패했는지가 표시됩니다. 이는 `--cloud` 또는 `--teleport` 같은 플래그로 셸에서 클라우드 세션을 시작하거나, 재개하거나, 메시지를 보낼 때 적용됩니다. API에 연결할 경로가 없으면 다음과 같이 표시됩니다:

```text theme={null}
Cloud sessions aren't available: couldn't reach api.anthropic.com to load your organization's policy. Check your network or proxy.
```

다른 실패도 같은 시작 문구 뒤에 HTTP 403으로 요청을 거부한 프록시, 서버 오류, API가 받아들이지 않은 자격 증명 등 각자의 원인이 이어집니다. 이 세션이 claude.ai 로그인 대신 사용하는 자격 증명(예: `ANTHROPIC_API_KEY` 환경 변수)을 API가 받아들이지 않은 경우, 메시지에 해당 자격 증명이 지목되고 설정을 해제하라는 안내가 포함될 수도 있습니다:

```text theme={null}
Cloud sessions aren't available: api.anthropic.com didn't accept this session's credentials when Claude Code asked for your organization's policy. Cloud sessions use your claude.ai login. ANTHROPIC_API_KEY is set, so this session is using API-key auth — unset it (or run in a shell without it) to use cloud sessions.
```

v2.1.296 이전에는 이러한 실패에서도 `Couldn't verify` 메시지가 출력되었습니다.

**해결 방법:**

* `Couldn't verify` 메시지의 경우 네트워크 연결을 확인하고 다시 시도합니다. 세션 내라면 먼저 Claude Code를 다시 시작합니다
* `Cloud sessions aren't available:` 메시지의 경우 프록시 확인이나 메시지가 지목한 자격 증명의 설정 해제 등 원인에 맞는 조치를 취한 다음 명령을 다시 실행합니다

### 폴더가 추적 중인 파일을 대체하여 아무것도 stash되지 않음

이 메시지는 체크아웃에서 git이 추적하던 파일이나 링크가 있던 자리에 이제 폴더가 있다는 의미입니다. 예를 들어 `claude --teleport` 또는 `/teleport`로 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#from-cloud-to-terminal)을 터미널로 가져오는 중에 stash 옵션을 선택한 후 나타납니다. 이 상태를 stash하면 폴더 안의 파일이 삭제될 수 있으므로, Claude Code는 stash를 거부하고 체크아웃과 인덱스를 변경하지 않은 채 둡니다:

```text wrap theme={null}
Error: Nothing was stashed: "f" is now a folder in place of a tracked file or link, and stashing could delete what's in it for good. Commit the change or move the folder somewhere else, then try again.
```

**해결 방법:**

* 메시지에 안내된 대로 변경 사항을 커밋하거나 폴더를 다른 곳으로 옮긴 다음 teleport를 다시 실행합니다

### `--json-schema` 값이 유효한 JSON Schema가 아님

[비대화형 모드](https://code.claude.com/docs/ko/headless.md#get-structured-output)에서 [`--json-schema`](https://code.claude.com/docs/ko/cli-reference#cli-flags)에 전달한 스키마가 JSON Schema 컴파일에 실패하여 `claude`가 프롬프트를 실행하지 않고 종료 코드 1로 종료됩니다. v2.1.205 이전에는 잘못된 스키마가 오류 없이 구조화되지 않은 출력을 생성했으며, `format` 키워드를 사용하는 스키마는 모두 잘못된 것으로 처리되었습니다.

```text theme={null}
Error: --json-schema is not a valid JSON Schema: data/type must be equal to one of the allowed values
```

두 번째 콜론 뒤의 텍스트는 검증기의 진단 내용이며 실패한 키워드나 위치를 알려 줍니다. `"format": "email"`처럼 `format` 키워드를 사용하는 스키마는 유효합니다. Claude Code는 `format`을 주석으로 받아들이며 이를 강제하지 않습니다.

Claude Code는 스키마 컴파일 전에 두 가지 검사를 실행합니다. 파싱할 수 없는 JSON 값은 `Error: --json-schema is not valid JSON`으로 거부하고, 객체가 아닌 유효한 JSON은 `Error: --json-schema must be a JSON object`로 거부합니다.

**해결 방법:**

* 진단 내용이 가리키는 스키마 부분을 수정한 다음 명령을 다시 실행합니다
* 작동하는 스키마와 명령은 [구조화된 출력 얻기](https://code.claude.com/docs/ko/headless.md#get-structured-output)를 참조하십시오

### 설정 파일이 2MiB 제한을 초과함

[`--settings`](https://code.claude.com/docs/ko/cli-reference#cli-flags)에 전달한 파일이 2MiB보다 커서 `claude`가 파일을 로드하지 않고 시작 시 종료 코드 1로 종료됩니다. v2.1.214 이전에는 Claude Code가 크기 검사 없이 파일을 읽었기 때문에, 수 기가바이트 크기의 파일이나 `/dev/zero` 같은 장치 파일로 인해 메모리가 무한히 증가했습니다.

```text theme={null}
Error: Settings file exceeds the 2MiB limit: /path/to/settings.json
```

Claude Code는 일반 파일이 아닌 `--settings` 경로도 같은 방식으로 거부합니다. 장치, FIFO 또는 소켓의 경우 `Error: Cannot use settings file (Not a regular file (device, FIFO, or socket))` 뒤에 경로가 표시되고, 디렉터리의 경우 `EISDIR` 사유가 표시됩니다.

**해결 방법:**

* `--settings`가 2MiB 미만의 일반 JSON 설정 파일을 가리키도록 합니다. 형식은 [설정](https://code.claude.com/docs/ko/settings.md)을 참조하십시오.

### 현재 디렉터리가 더 이상 존재하지 않음

셸이 진입한 후 삭제되거나 이동된 디렉터리(예: 다른 셸이 제거한 worktree 또는 임시 디렉터리)에서 `claude`를 시작했습니다. Claude Code는 작업 디렉터리를 읽을 수 없으므로 대화형 모드와 [비대화형](https://code.claude.com/docs/ko/headless.md) 모드 모두에서 세션을 시작하기 전에 종료 코드 1로 종료됩니다. v2.1.239 이전에는 이 메시지 대신 Claude Code가 축소된 번들 소스와 원시 `ENOENT ... uv_cwd` 스택을 stderr에 출력하며 충돌했습니다.

```text theme={null}
The current directory no longer exists (it was deleted or moved). Start Claude Code from an existing directory.
error: The current working directory was deleted, so that command didn't work. Please cd into a different directory and try again.
```

두 형식 모두 원인과 해결 방법이 같습니다.

권한 변경 등 다른 이유로 Claude Code가 작업 디렉터리를 읽을 수 없는 경우, 메시지에는 대신 오류 코드가 표시됩니다: `Can't read the current directory (EACCES). Start Claude Code from a different directory.`

macOS에서 `~/Desktop`, `~/Documents`, `~/Downloads` 또는 iCloud Drive에 있는 디렉터리에 대한 `EPERM`은 대개 macOS가 터미널 앱의 해당 폴더 접근을 차단하고 있음을 의미합니다. 해당 폴더를 읽는 다른 명령도 같은 방식으로 실패합니다. 그곳에서 `ls`를 실행하면 `sudo`를 사용하더라도 `Operation not permitted`가 표시됩니다.

**해결 방법:**

* 홈 디렉터리나 프로젝트 디렉터리처럼 존재하는 디렉터리로 이동한 다음 `claude`를 다시 실행합니다
* 디렉터리가 같은 경로에 다시 생성된 경우에도 셸은 여전히 삭제된 디렉터리를 붙잡고 있습니다. `cd "$PWD"`를 실행하거나 디렉터리에서 나갔다가 다시 들어간 다음 `claude`를 다시 실행합니다
* macOS에서 `EPERM`이 발생하면 Cmd+Q로 터미널 앱을 종료하고 다시 연 다음, 해당 폴더로 돌아가 `claude`를 실행합니다. 그 폴더에서 `ls`가 여전히 실패하면 **시스템 설정 > 개인정보 보호 및 보안 > 파일 및 폴더**를 열고 터미널 앱에 대해 해당 폴더를 켠 다음 터미널을 다시 엽니다

### 임시 디렉터리가 거부되었거나 생성할 수 없음

macOS와 Linux에서 Claude Code는 시작 시 시스템 임시 디렉터리 또는 [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars) 재정의 경로 아래에 비공개 임시 디렉터리 `claude-<uid>`를 만듭니다. 디렉터리를 만들 수 없거나 해당 경로에 이미 있는 항목이 안전 검사를 통과하지 못하면, Claude Code는 세션을 시작하지 않고 실패 내용을 stderr에 출력한 후 종료 코드 1로 종료됩니다:

```text wrap theme={null}
Claude Code's temporary directory /tmp/claude-501 could not be created: the volume holding /tmp is full (ENOSPC). Free space on that volume, or set CLAUDE_CODE_TMPDIR to a directory on another one, then try again.

Temp directory /tmp/claude-501 is not a directory (may be an attacker-planted symlink). Refusing to use it. Set CLAUDE_CODE_TMPDIR to a directory you control, or ask an administrator to remove it.

Temp directory /tmp/claude-501 is owned by uid 502, expected 501. Refusing to use it — another user may have pre-created it. Set CLAUDE_CODE_TMPDIR to a directory you control, or ask an administrator to remove it.

Temp directory /tmp/claude-501 is not readable (its mode may have been altered, or a path component denies search). Refusing to use it — restore its permissions (chmod 0700) or remove it. Set CLAUDE_CODE_TMPDIR to a directory you control, or ask an administrator to remove it.
```

**해결 방법:**

* `could not be created` 뒤에 `is full (ENOSPC)`가 오는 경우, 메시지에 표시된 볼륨의 디스크 공간을 확보합니다. 대신 `your disk quota on the volume holding /tmp is used up (EDQUOT)`가 표시되면 해당 볼륨에서 더 이상 필요하지 않은 자신의 파일을 삭제합니다
* `Refusing to use it` 형식의 경우 링크가 가리키는 대상이 아니라 메시지에 표시된 항목 자체를 제거하고 Claude Code를 다시 시작합니다. `owned by uid` 형식의 경우 관리자나 해당 사용자만 제거할 수 있습니다
* `is not readable`의 경우 표시된 디렉터리에 `chmod 0700`을 실행하거나, 디렉터리를 제거하고 다시 시작합니다
* 어떤 경우든 거부된 경로는 그대로 두고 [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars)를 직접 제어하는 디렉터리로 설정한 다음 Claude Code를 다시 시작할 수 있습니다

v2.1.309 이전에는 볼륨이 가득 차거나 할당량을 모두 사용한 경우 Claude Code가 운영 체제의 오류 텍스트만 출력했습니다. 예를 들어 `ENOSPC: no space left on device, mkdir '/tmp/claude-501'`이며, 같은 단계가 적용됩니다.

### 디렉터리를 실제 위치로 확인할 수 없음

작업 디렉터리의 하위 디렉터리에 대해 `/add-dir`을 실행했지만 Claude Code가 해당 디렉터리의 실제 위치를 확인할 수 없었습니다.

작업 디렉터리의 하위 디렉터리에는 이미 파일 접근 권한이 있으므로 `/add-dir`은 해당 디렉터리의 스킬, 명령, 에이전트만 로드합니다. 이를 로드하기 전에 Claude Code는 심볼릭 링크를 모두 확인한 디렉터리의 실제 위치가 작업 디렉터리 내부에 있는지 검사합니다. Claude Code가 그 위치를 확인할 수 없으면 아무것도 로드하지 않고 다음 메시지를 표시합니다:

```text theme={null}
packages/app couldn't be resolved to a real location, so its skills, commands, and agents weren't loaded. Check that it is a directory inside the working directory and try again.
```

**해결 방법:**

* 경로가 작업 디렉터리 내부의 실제 디렉터리를 가리키는지 확인한 다음 `/add-dir`을 다시 실행합니다
* 이 메시지는 파일 접근 권한을 변경하지 않으며, 디렉터리의 `.claude/` 콘텐츠가 로드되지 않았음을 알릴 뿐입니다

v2.1.261 이전에는 작업 디렉터리가 `/net/<host>` 자동 마운트에 있을 때 모든 `/add-dir <subdirectory>`에 대해 이 메시지가 표시되었습니다. Claude Code는 설계상 그러한 위치의 경로를 확인하지 않으므로, 디렉터리에 문제가 없었고 재시도해도 소용이 없었습니다.

### Remote Control 시작 시 워크스페이스를 신뢰하지 않음

> [!NOTE]
>
> `claude ultrareview`가 `Error: Workspace not trusted`를 출력한 경우 대신 [claude ultrareview 실행 시 워크스페이스를 신뢰하지 않음](#workspace-not-trusted-when-running-claude-ultrareview)을 참조하세요.

신뢰하지 않은 디렉터리에서 `claude remote-control` 또는 그 별칭인 `claude rc`로 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 서버 모드를 시작했지만, 명령이 디렉터리를 신뢰할지 물을 수 없었습니다. 예를 들어 표준 입력이나 표준 출력 중 하나가 리디렉션되거나 파이프로 연결되어 터미널이 아닌 경우입니다. 명령은 종료 코드 1로 종료됩니다:

```text theme={null}
Error: Workspace not trusted. Please run `claude` in /Users/you/project first to review and accept the workspace trust dialog.
```

`Error: Workspace not trusted.`로 시작하는 두 가지 변형은 디렉터리를 신뢰하면 켜지는 항목을 표시하기에 너무 작은 터미널이나 크기를 보고하지 않는 터미널에서도 나타납니다. 창을 키우거나 일반 터미널 창으로 전환한 다음 `claude rc`를 다시 실행합니다.

홈 디렉터리에서는 메시지가 다릅니다. 워크스페이스 신뢰 대화 상자는 홈 디렉터리에 대한 신뢰를 절대 저장하지 않으므로, 그곳에서 신뢰를 수락해도 이 검사를 통과할 수 없기 때문입니다. v2.1.214 이전에는 홈 디렉터리에서 위의 메시지가 표시되었으며, 그 조언은 홈 디렉터리에서 성공할 수 없었습니다.

```text theme={null}
Error: Workspace not trusted. /Users/you is your home directory, and for security home-directory trust is never saved, so running `claude` here first won't help. Run `claude rc` from a project directory instead (run `claude` there once to accept the trust dialog).
```

[`Trust <directory>?` 질문](https://code.claude.com/docs/ko/remote-control#requirements)에 `n`으로 답하거나 Enter를 누르면, 명령은 디렉터리 이름이 포함된 `Remote Control did not start` 메시지를 출력하고 종료 코드 1로 종료됩니다. `claude rc`를 다시 실행하여 `y`로 답합니다.

**해결 방법:**

* 먼저 터미널에서 디렉터리를 신뢰합니다. 그곳에서 `claude rc`를 실행하고 `y`로 답하거나, `claude`를 실행하고 [워크스페이스 신뢰 대화 상자](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)를 수락한 다음 원래 명령을 다시 실행합니다
* 홈 디렉터리에 있다면 프로젝트 디렉터리로 이동하여 그곳에서 Remote Control을 시작합니다

v2.1.284 이전에는 터미널에서도 명령이 묻지 않았습니다.

### claude ultrareview 실행 시 워크스페이스를 신뢰하지 않음

신뢰하지 않은 폴더에서 [`claude ultrareview`](https://code.claude.com/docs/ko/ultrareview#trust-the-folder-before-the-review-runs)가 폴더를 신뢰하는지 물어볼 수 없으면, 리뷰가 시작되기 전에 실행이 종료 코드 1로 종료됩니다:

```text theme={null}
Error: Workspace not trusted. Please run `claude` in /Users/you/project first to review and accept the workspace trust dialog. Or, in a script or CI job, pass `--trust-workspace` to trust the folder for this run only.
```

예를 들어 표준 입력이나 표준 출력이 터미널이 아니면 하위 명령이 물어볼 수 없습니다. `claude ultrareview --json > findings.json`처럼 출력을 파일로 보내면 표준 출력이 터미널이 아니게 됩니다.

**해결 방법:**

* 스크립트나 CI 작업에서는 `--trust-workspace`를 추가하여 해당 실행에 한해 폴더를 신뢰합니다: `claude ultrareview --trust-workspace`. 이 플래그를 추가하면 git과 Claude Code가 폴더의 git 구성과 프로젝트 설정에 지정된 프로그램을 실행할 수 있으므로, 신뢰하는 코드에만 추가합니다. 코드를 신뢰하지 않는 풀 리퀘스트의 경우 [신뢰하는 브랜치에서 리뷰를 실행](https://code.claude.com/docs/ko/ultrareview.md#trust-the-folder-before-the-review-runs)합니다.
* 자신의 컴퓨터에서는 해당 폴더에서 `claude`를 실행하고 [워크스페이스 신뢰 대화 상자](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)를 수락한 다음 원래 명령을 다시 실행합니다

`claude ultrareview`의 다음 각 메시지는 리뷰가 시작되지 않았고 종료 코드가 1이라는 의미입니다:

* **`Error: Workspace not trusted. This terminal ...`**: 터미널이 행과 열 수를 보고하지 않았거나 신뢰 질문과 경고를 표시할 수 없습니다. 터미널을 키우거나 크기를 보고하는 터미널을 사용한 다음 `claude ultrareview`를 다시 실행합니다. 홈 디렉터리 밖이라면 해당 폴더에서 `claude`를 한 번 실행하고 신뢰 대화 상자를 수락하여 이후 실행에서 묻지 않도록 할 수도 있습니다.
* **`Error: Workspace not trusted. <folder> is your home directory`**: 홈 디렉터리에 대한 신뢰는 저장되지 않으므로, 먼저 그곳에서 `claude`를 실행해도 도움이 되지 않습니다. 대신 프로젝트 디렉터리에서 `claude`를 한 번 실행하여 신뢰 대화 상자를 수락한 후 그곳에서 `claude ultrareview`를 실행하거나, `--trust-workspace`를 추가합니다.
* **`No answer in time.` 뒤에 `Error: Workspace not trusted`**: `Trust <folder>? [y/N]` 질문에 5분 동안 답하지 않았습니다. `claude ultrareview`를 다시 실행하고 답합니다.
* **`Ultrareview did not start: <folder> is not trusted`**: `n`으로 답하거나 Enter를 누르는 등 `Trust <folder>? [y/N]` 질문을 거절했습니다. 리뷰를 시작하려면 `claude ultrareview`를 다시 실행하고 `y`로 답합니다.
* **``Ultrareview did not start: `--trust-workspace` takes no value``**: `--trust-workspace` 뒤에 PR 번호나 `false`처럼 플래그가 아닌 것이 왔습니다. 폴더를 신뢰하지 않는다면 플래그를 빼세요. 이번 실행에 대해 신뢰하려면 PR 번호나 기준 브랜치를 플래그 앞에 둡니다: `claude ultrareview 1234 --trust-workspace`.

v2.1.309 이전에는 `claude ultrareview`가 `--trust-workspace`를 받지 않았습니다.

### Remote Control이 시작하는 세션으로 전달되지 않음

`remote-control` 동사 앞에 전역 `claude` 플래그를 붙여 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 시작했는데, 그 플래그가 `--settings`, `--setting-sources`, `--permission-mode`, `--disallowed-tools`, `--mcp-config`처럼 Remote Control이 시작하는 세션을 제한하거나 구성하는 플래그였습니다. 동사 앞에 놓인 플래그는 해당 세션에 전달되지 않습니다. Claude Code는 대신 플래그 이름을 표시하며 시작을 거부합니다:

```text theme={null}
Error: `--settings` before `remote-control` is not carried over to the sessions Remote Control starts, so Remote Control refuses to start rather than drop it — remove it, and give Remote Control's own options after the verb (see `claude remote-control --help`).
```

`--verbose`, `--model`, 또는 래퍼가 주입한 `--session-id`나 `--plugin-dir`처럼 제외해도 무해한 전역 플래그는 거부하지 않습니다. Claude Code는 이를 무시하고 Remote Control을 시작합니다.

Claude Code는 아직 무해한 것으로 인식하지 못한 전역 플래그에 대해서도 시작을 거부하므로, 새 릴리스에서 추가된 플래그가 이후 릴리스에서 무해한 것으로 표시될 때까지 이 메시지에 나타날 수 있습니다.

**해결 방법:**

* 동사 앞에서 플래그를 제거하고 [Remote Control 자체 옵션](https://code.claude.com/docs/ko/remote-control.md#start-a-remote-control-session)을 동사 뒤에 전달합니다. `claude remote-control --help`로 옵션 목록을 확인할 수 있습니다
* 거부된 플래그가 `--permission-mode`인 경우 `claude remote-control --permission-mode <mode>`를 실행하여 Remote Control이 시작하는 세션의 권한 모드를 설정합니다

v2.1.248 이전에는 전역 플래그가 먼저 오면 `claude remote-control`이 자체 플래그를 받지 않았으며, 명령이 `unknown option` 오류로 실패했습니다.

### `--sandbox` or `--no-sandbox` is not supported by claude remote-control

이 오류는 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 서버를 시작하는 명령이 `remote-control` 뒤에 `--sandbox` 또는 `--no-sandbox`를 전달하는데, `claude remote-control`이 두 플래그를 모두 받지 않는다는 뜻입니다. 서버는 시작하지 않고 코드 1로 종료됩니다:

```text theme={null}
Error: --sandbox is not supported by claude remote-control. The flag had no effect and was removed. To sandbox sessions, set sandbox.enabled to true in settings.
Error: --no-sandbox is not supported by claude remote-control. The flag had no effect and was removed. Remove it from the command.
```

**해결 방법:**

* 서버를 대신 시작하는 스크립트나 서비스 정의를 포함해 명령에서 플래그를 제거한 다음 다시 실행합니다
* 서버가 시작하는 세션을 샌드박스에서 실행하려면 [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)에서 [`sandbox.enabled`](https://code.claude.com/docs/ko/settings-reference#sandbox-enabled)를 `true`로 설정해 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)을 켭니다

두 플래그 모두 v2.1.300에서 `claude remote-control`에서 제거되었으므로, 이전 버전용으로 작성된 명령에는 여전히 플래그가 포함되어 있을 수 있습니다.

### 이 빌드에서는 아직 claude import를 사용할 수 없음

[`claude import`](https://code.claude.com/docs/ko/cli-reference#cli-commands)를 실행했지만 Claude Code가 가져오기 흐름이 꺼져 있음을 확인했으므로, 명령이 가져오기를 시작하지 않고 종료 코드 1로 종료됩니다. v2.1.222 이전에는 가져오기 흐름이 꺼진 빌드에서 `import`를 프롬프트로 처리하여 이 메시지를 출력하는 대신 대화형 세션을 시작했습니다.

```text theme={null}
`claude import` is not yet available in this build. Run `claude` and use /mcp or edit ~/.claude/settings.json directly.
```

Claude Code는 Anthropic에서 가져와 디스크에 캐시하는 기능 플래그를 통해 `claude import`를 켭니다. 이 메시지는 캐시된 값이 꺼져 있음을 의미합니다. 원인은 대개 다음 중 하나입니다:

* 설치 후 아직 세션을 시작하지 않아 Claude Code가 플래그를 가져오지 못했습니다. 기능을 사용할 수 있는 경우에도 첫 번째 `claude import`에서 이 메시지가 출력될 수 있습니다.
* Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry, Claude Platform on AWS 또는 [Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway#availability-and-limitations)를 통해 Claude Code를 사용합니다. 이러한 세션에서는 Claude Code가 기능 플래그를 가져오지 않으므로 `claude import`를 계속 사용할 수 없습니다.
* 기능 플래그 가져오기를 끄는 `DISABLE_TELEMETRY`, `DO_NOT_TRACK`, `DISABLE_GROWTHBOOK` 또는 [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](https://code.claude.com/docs/ko/env-vars)를 설정했으므로 `claude import`를 계속 사용할 수 없습니다.

**해결 방법:**

* 새로 설치한 경우 `claude`를 시작하고 세션이 로드될 때까지 기다린 다음 종료하고 `claude import`를 다시 실행합니다
* 기능 플래그 가져오기가 계속 꺼져 있는 환경에서는 구성을 직접 설정합니다. [`claude mcp add`](https://code.claude.com/docs/ko/mcp#installing-mcp-servers)로 MCP 서버를 추가하고, 옮기려는 [`CLAUDE.md` 파일](https://code.claude.com/docs/ko/memory#how-claude-md-files-load), [스킬과 명령](https://code.claude.com/docs/ko/skills.md#where-skills-live), [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#choose-the-subagent-scope)를 만듭니다. 메시지에는 `~/.claude/settings.json`도 언급됩니다. `claude import`가 옮기는 구성 중 해당 파일에는 [권한 모드](https://code.claude.com/docs/ko/settings-reference.md#permission-settings)만 들어 있으며, Claude Code는 이 파일에서 MCP 서버를 읽지 않습니다.

### Claude Code 구성을 읽을 수 없음

Claude Code가 계정 세부 정보와 프로젝트별 상태를 저장하는 파일인 `~/.claude.json`을 파싱할 수 없는 상태에서 [`claude import`](https://code.claude.com/docs/ko/cli-reference#cli-commands)를 실행했습니다. 이 하위 명령은 가용성을 확인하기 위해 해당 파일을 읽지만 대화형 세션이 표시하는 복구 대화 상자를 표시하지 않으므로 종료 코드 1로 종료됩니다. v2.1.222 이전에는 읽을 수 없는 설정 파일이 있을 때 `claude import`가 대화형 세션을 시작했으며, 그 세션의 복구 대화 상자가 파일을 처리했습니다.

```text theme={null}
Could not read Claude Code config — run `claude` with no arguments to recover it.
```

**해결 방법:**

* 인수 없이 `claude`를 실행합니다. Claude Code가 잘못된 파일을 감지하고 재설정을 제안합니다. 그런 다음 `claude import`를 다시 실행합니다.
* 직접 수정한 내용을 유지하려면 대신 편집기에서 `~/.claude.json`의 JSON 구문을 수정한 다음 `claude import`를 다시 실행합니다

### Claude Desktop에서 서버를 가져올 수 없음

Claude Code가 `claude mcp add-from-claude-desktop`에서 선택한 서버 중 하나를 추가할 수 없었습니다. 명령은 선택한 다른 서버는 계속 가져오며, 추가할 수 없었던 서버마다 한 줄씩 출력합니다. v2.1.205 이전에는 처음 실패한 서버에서 가져오기가 중단되었습니다.

```text theme={null}
Could not import my server: Invalid name my server. Names can only contain letters, numbers, hyphens, and underscores.
```

서버 이름 뒤의 텍스트가 사유입니다. 가장 흔한 사유는 이름 검사입니다. Claude Desktop은 서버 이름에 공백이나 마침표 같은 문자를 허용하지만, `claude mcp`는 문자, 숫자, 하이픈, 밑줄로 제한합니다. 그 밖의 사유로는 검증에 실패한 서버 구성과 조직의 [MCP 정책](https://code.claude.com/docs/ko/managed-mcp.md)에 의해 차단된 서버가 있습니다.

**해결 방법:**

* `claude_desktop_config.json`에서 서버 이름을 문자, 숫자, 하이픈, 밑줄만 사용하도록 변경한 다음 `claude mcp add-from-claude-desktop`을 다시 실행합니다
* 유효한 이름으로 `claude mcp add` 또는 `claude mcp add-json`을 사용해 해당 서버를 직접 추가합니다. [Claude Desktop에서 MCP 서버 가져오기](https://code.claude.com/docs/ko/mcp.md#import-mcp-servers-from-claude-desktop)를 참조하십시오.

### managed 범위에 MCP 서버를 추가할 수 없음

`--scope managed`와 함께 `claude mcp add` 또는 `claude mcp add-json`을 실행했습니다. 이 범위에는 조직이 [`managedMcpServers`](https://code.claude.com/docs/ko/settings-reference#managedmcpservers) 관리형 설정을 통해 제공하는 서버가 들어 있습니다. Claude Code는 관리형 설정에서만 이를 읽으므로 명령이 해당 범위에 서버를 쓸 수 없습니다.

```text theme={null}
Cannot add MCP server to scope: managed
```

**해결 방법:**

* 쓸 수 있는 범위(`local`, `user` 또는 `project`)에 서버를 추가합니다. `--scope`가 없으면 명령은 `local`을 사용합니다. [MCP 설치 범위](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes)를 참조하십시오
* 조직의 모든 사용자에게 서버를 제공하려면 배포하는 관리형 설정의 [`managedMcpServers`](https://code.claude.com/docs/ko/settings-reference#managedmcpservers)에 추가합니다

### 관리형 설정이 플러그인 서버만 허용할 때 MCP 서버를 추가할 수 없음

조직의 관리형 설정이 [`strictPluginOnlyCustomization`](https://code.claude.com/docs/ko/settings-reference#strictpluginonlycustomization)을 `true` 또는 `mcp`가 포함된 목록으로 설정한 상태에서 `claude mcp add` 또는 `claude mcp add-json`을 실행했습니다. 이 설정이 있으면 Claude Code는 `~/.claude.json`이나 `.mcp.json`에서 MCP 서버를 로드하지 않으므로, 명령은 절대 로드되지 않을 서버를 저장하는 대신 종료 코드 1로 종료됩니다:

```text theme={null}
Cannot add MCP server: your organization's managed settings allow only MCP servers that plugins provide. Install a plugin that provides this server, or ask your administrator to make it available.
```

`claude mcp add-from-claude-desktop`은 선택한 각 서버를 가져오지 않은 것으로 보고하며, 이 메시지를 사유로 표시합니다. [`/import`](https://code.claude.com/docs/ko/commands#all-commands)는 추가하려는 각 MCP 서버에 대해 이 메시지를 보고하고, 찾은 다른 항목은 계속 가져옵니다.

v2.1.284 이전에는 이러한 명령이 서버를 저장하고 성공을 보고했지만 서버는 로드되지 않았습니다.

**해결 방법:**

* 해당 서버를 제공하는 [플러그인](https://code.claude.com/docs/ko/plugins/install.md)을 설치합니다
* 관리자에게 서버를 [플러그인](https://code.claude.com/docs/ko/plugins/org.md)으로 배포하거나, 원격 HTTP 또는 SSE 서버인 경우 [`managedMcpServers`](https://code.claude.com/docs/ko/settings-reference#managedmcpservers)를 통해 제공하도록 요청합니다

### .mcp.json을 읽을 수 없음

`--scope project`와 함께 실행한 `claude mcp add` 또는 `claude mcp add-json`, 또는 `claude mcp remove`처럼 프로젝트의 [`.mcp.json`](https://code.claude.com/docs/ko/mcp#project-scope)을 읽는 명령이 현재 디렉터리의 파일이 일반 파일이 아니거나 2MiB보다 크다는 것을 발견했기 때문에, 파일을 읽지 않고 이 오류와 함께 종료됩니다.

```text theme={null}
Can't read .mcp.json: it isn't a regular file or is larger than 2097152 bytes. Fix or remove it, then run the command again.
```

v2.1.257 이전에는 `.mcp.json` 위치에 FIFO가 있으면 명령이 출력 없이 무한히 대기했고, `/dev/zero` 같은 장치 파일을 가리키는 심볼릭 링크가 있으면 프로세스가 종료될 때까지 메모리가 증가했습니다.

**해결 방법:**

* 현재 디렉터리의 `.mcp.json` 위치에 무엇이 있는지 확인합니다. [프로젝트 범위 형식](https://code.claude.com/docs/ko/mcp.md#project-scope)의 일반 JSON 파일로 교체하거나 삭제한 다음 명령을 다시 실행합니다.

### MCP 서버가 저장되거나 제거되지 않음

`user` 또는 `local` [범위](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes)의 서버에 대해 `claude mcp add`, `claude mcp add-json` 또는 `claude mcp remove`를 실행했습니다. 두 범위 모두 `~/.claude.json`에 저장되는데, 쓰기 후 Claude Code가 파일을 다시 읽었을 때 변경 사항이 파일에 없었습니다. 명령은 성공 메시지 대신 이 오류와 함께 종료됩니다.

```text theme={null}
MCP server "example" was not saved to /home/user/.claude.json. If that file is read-only or protected by a sandbox, make it writable or run the command outside the sandbox, then add the server again.
```

제거 후에는 메시지가 `was not removed from`으로 표시되고 `then remove the server again`으로 끝납니다. `local` 범위 서버의 경우 경로 뒤에 해당 항목이 속한 프로젝트 디렉터리가 `(local scope for /path/to/project)` 형식으로 표시됩니다.

v2.1.283 이전에는 변경 사항이 파일에 반영되지 않은 경우에도 `claude mcp add`, `claude mcp add-json`, `claude mcp remove`가 성공을 보고했습니다.

**해결 방법:**

* 메시지에 표시된 파일을 쓰기 가능하게 만들거나 샌드박스 외부에서 명령을 실행한 다음, 같은 추가 또는 제거 명령을 다시 실행합니다.

### MCP 서버가 저장되거나 제거되지 않았을 수 있음

`user` 또는 `local` [범위](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes)의 서버에 대해 `claude mcp add`, `claude mcp add-json` 또는 `claude mcp remove`를 실행했지만, Claude Code가 변경 사항을 확인하기 위해 `~/.claude.json`을 다시 읽을 수 없었습니다. 변경 사항이 디스크에 반영되었을 수도 있고 그렇지 않을 수도 있습니다. 괄호 안의 텍스트는 해당 읽기에서 발생한 오류입니다.

```text theme={null}
MCP server "example" may not have been saved: /home/user/.claude.json could not be read to confirm the change (EACCES: permission denied, open '/home/user/.claude.json'). Run `claude mcp get example` to check, then add the server again if it is missing.
```

제거 후에는 메시지가 `may not have been removed`로 표시되고 `then remove the server again if it is still listed`로 끝납니다.

v2.1.283 이전에는 변경 사항을 확인할 수 없는 경우에도 명령이 성공을 보고했습니다.

**해결 방법:**

* `claude mcp get <name>`을 실행하여 변경 사항이 디스크에 있는지 확인합니다. `local` 범위 서버의 경우 로컬 범위는 프로젝트별이므로 서버가 속한 프로젝트 디렉터리에서 실행합니다.
* 추가 후 서버가 없거나 제거 후에도 여전히 목록에 있으면 같은 추가 또는 제거 명령을 다시 실행합니다.

### 서버가 Anthropic에서 호스팅되며 로컬 OAuth를 지원하지 않음

URL이 타사 ID 공급자를 통해 인증하는 Anthropic 호스팅 커넥터 호스트를 가리키는 MCP 서버에 대해 로그인을 시작했습니다. 이러한 호스트에는 `microsoft365.mcp.claude.com`, `gmail.mcp.claude.com`, `gcal.mcp.claude.com`이 포함됩니다. [이들의 로그인은 claude.ai를 통해서만 작동](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai)하므로, Claude Code는 `/mcp` 패널과 `claude mcp login` 모두에서 이러한 호스트에 대한 로컬 OAuth 흐름 시작을 거부합니다.

```text theme={null}
"gmail" is Anthropic-hosted and doesn't support local OAuth. Connect it via Settings → Connectors on claude.ai (requires `claude login`), then it'll be available here automatically.
```

**해결 방법:**

* 같은 URL의 claude.ai 커넥터를 가리지 않도록 `claude mcp remove <name>`으로 항목을 제거합니다
* 제거한 후 Claude Code에서 사용하는 계정으로 로그인한 상태에서 [claude.ai/customize/connectors](https://claude.ai/customize/connectors)에서 서비스를 연결합니다. 연결되면 활성 인증 방법이 claude.ai 구독 로그인인 경우 [커넥터가 Claude Code에 자동으로 표시됩니다](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai)

### 구성된 headersHelper가 생성한 Authorization 헤더를 서버가 거부함

[`headersHelper`](https://code.claude.com/docs/ko/mcp#use-dynamic-headers-for-custom-authentication)가 `Authorization` 헤더를 제공하는 MCP 서버가 연결에 HTTP 401 또는 403으로 응답했기 때문에 Claude Code가 연결을 실패로 보고합니다. 헬퍼가 `Authorization` 헤더를 제공하므로 Claude Code는 해당 서버에 대해 [OAuth로 폴백하지 않습니다](https://code.claude.com/docs/ko/mcp.md#authenticate-with-remote-mcp-servers):

```text theme={null}
Server rejected the Authorization header minted by the configured headersHelper (HTTP 401). Check that the helper command returns a valid credential for this MCP endpoint — OAuth fallback is disabled when the helper supplies Authorization.
```

Claude Code는 연결을 시도할 때마다 헬퍼를 다시 실행하므로, 토큰 교체 경합처럼 일시적인 거부 이후의 재시도는 새 자격 증명으로 성공할 수 있습니다.

**해결 방법:**

* Claude Code가 실행하는 방식 그대로 `headersHelper` 명령을 직접 실행합니다. [Claude Code가 실행하는 디렉터리](https://code.claude.com/docs/ko/mcp.md#where-the-helper-runs)에서, [Claude Code가 설정하는 환경 변수](https://code.claude.com/docs/ko/mcp.md#use-dynamic-headers-for-custom-authentication)와 함께, 그리고 프로젝트 `.mcp.json`, 플러그인 또는 프로젝트 에이전트 파일의 서버인 경우 [Claude Code가 제거하는 자격 증명 변수](https://code.claude.com/docs/ko/mcp.md#which-variables-a-helper-can-read) 없이 실행합니다. 서버의 엔드포인트가 수락하는 `Authorization` 값이 출력되는지 확인합니다
* 헬퍼나 자격 증명 소스를 수정한 후 `/mcp`에서 서버를 선택하고 **Reconnect**를 선택합니다

v2.1.248 이전에는 헬퍼가 `Authorization` 헤더를 제공하는 서버에 대해서도 Claude Code가 OAuth 검색을 실행했습니다. 이 검색은 거부된 자격 증명을 보고하는 대신 `Incompatible auth server: does not support dynamic client registration`으로 실패할 수 있었습니다.

### MCP server rejected the elicitation capability

Java MCP SDK 0.11.0부터 0.17.0까지로 빌드된 MCP 서버가 연결을 거부했습니다. 이 SDK 버전은 Claude Code가 핸드셰이크에서 선언하는 `form` 및 `url` [elicitation 모드](https://code.claude.com/docs/ko/mcp.md#elicitation-modes-claude-code-declares)를 파싱할 수 없습니다. 메시지는 다음과 같습니다:

```text theme={null}
This server (Java MCP SDK 0.17.0 or older) rejected Claude Code's elicitation capability. Set "bareElicitationCapability": true for it, or upgrade to Java MCP SDK 0.17.1+ (Spring AI 1.0.7+ or 1.1.6+).
```

**해결 방법:**

* 서버를 Java MCP SDK 0.17.1 이상 또는 메시지에 표시된 Spring AI 릴리스 중 하나로 업그레이드합니다
* 또는 MCP 구성의 해당 서버 항목에 `"bareElicitationCapability": true`를 추가한 뒤 Claude Code를 다시 시작합니다. 이 필드는 stdio, `sse`, `http`, `ws` 항목에서 허용되며 Claude Code v2.1.281 이상이 필요합니다

다음 `.mcp.json` 항목은 하나의 HTTP 서버에 이 필드를 설정합니다:

```json theme={null}
{
  "mcpServers": {
    "inventory": {
      "type": "http",
      "url": "https://mcp.example.com/mcp",
      "bareElicitationCapability": true
    }
  }
}
```

다시 시작한 후 `/mcp`에서 서버가 연결된 것으로 표시됩니다. Claude Code는 해당 서버에만 form 모드를 선언하므로, 서버를 업그레이드하면 이 필드를 제거합니다.

서버가 `Unrecognized field "form"`이 포함된 오류처럼 자체 오류 텍스트로 실패할 수도 있습니다. 같은 해결 방법이 적용됩니다.

### MCP 권한 프롬프트 도구를 찾을 수 없음

실행에서 처음으로 권한 결정이 필요했을 때 [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags)에 전달한 도구가 연결된 MCP 도구 중에 없었습니다. 해당 서버가 연결되지 않았거나, 연결된 서버 중 그 이름의 도구를 노출하는 서버가 없기 때문입니다. Claude Code는 여전히 프롬프트를 전송합니다. [비대화형](https://code.claude.com/docs/ko/headless.md) 실행은 첫 번째 도구 호출에서 이 오류와 종료 코드 1로 종료되므로, 요청은 이루어졌지만 응답은 생성되지 않습니다. 첫 번째 프롬프트 전에 Claude Code는 [`MCP_TIMEOUT`](https://code.claude.com/docs/ko/env-vars)으로 설정된 서버별 연결 타임아웃인 최대 30초 동안 해당 서버가 연결되기를 기다립니다. v2.1.206 이전에는 시작 시 서버 연결이 완료될 때까지 기다리지 않았기 때문에, 시작이 느리지만 정상인 서버에서도 이 오류가 발생했습니다.

```text theme={null}
Error: MCP tool mcp__permissions__approve (passed via --permission-prompt-tool) not found. Available MCP tools: none
```

`Available MCP tools:` 뒤의 목록은 연결되어 있던 MCP 도구를 나타냅니다.

**해결 방법:**

* 서버가 시작되어 연결을 유지하는지 확인합니다. 같은 디렉터리에서 `claude mcp list`를 실행하고 서버가 연결된 상태로 표시되는지 확인합니다
* 도구 이름이 서버가 노출하는 `mcp__<server>__<tool>` 이름과 일치하는지 확인합니다
* 서버 시작에 30초 넘게 걸리면 [`MCP_TIMEOUT`](https://code.claude.com/docs/ko/env-vars)을 늘립니다

### OAuth 콜백 포트가 이미 사용 중임

OAuth로 원격 MCP 서버에 로그인하면 Claude Code는 로그인 콜백을 받기 위해 로컬 리스너를 시작합니다. 리스너에 필요한 포트를 다른 프로세스가 점유하고 있으면 이 메시지와 함께 로그인이 실패합니다. 이는 주로 [`MCP_OAUTH_CALLBACK_PORT`](https://code.claude.com/docs/ko/env-vars) 변수나 `--callback-port`로 [고정 콜백 포트](https://code.claude.com/docs/ko/mcp.md#use-a-fixed-oauth-callback-port)를 설정한 경우에 발생합니다. 고정 포트가 없으면 Claude Code가 사용 가능한 포트를 선택하기 때문입니다.

```text theme={null}
OAuth callback port <port> is already in use — another process may be holding it. Run `lsof -ti:<port> -sTCP:LISTEN` to find it.
```

Windows에서는 대신 `netstat -ano | findstr :<port>` 명령이 제안됩니다.

**해결 방법:**

* 메시지의 명령을 실행하여 포트를 점유한 프로세스를 찾고, 해당 프로세스를 중지하거나 완료될 때까지 기다립니다
* 다른 프로그램이 해당 포트를 계속 사용해야 한다면 서버에 다른 리디렉션 URI를 등록하고, 사용하는 방식에 따라 `MCP_OAUTH_CALLBACK_PORT` 또는 `--callback-port`로 그 포트를 설정합니다
* 그런 다음 `/mcp`에서 서버를 선택하는 등의 방법으로 로그인을 다시 시작합니다

### OAuth 리디렉션에 사용할 수 있는 포트가 없음

[OAuth](https://code.claude.com/docs/ko/mcp.md#authenticate-with-remote-mcp-servers)로 원격 MCP 서버에 로그인하면 Claude Code는 로그인 콜백을 받기 위해 로컬 리스너를 시작합니다. Claude Code가 이를 위한 로컬 포트를 바인딩할 수 없으면 이 메시지와 함께 로그인이 실패합니다. 보안 소프트웨어나 로컬 리스너를 거부하는 샌드박스 정책처럼 시스템의 무언가가 `127.0.0.1`에서의 수신을 막고 있습니다.

```text theme={null}
No available ports for OAuth redirect
```

v2.1.268 이전에는 Claude Code가 운영 체제가 할당한 포트로 폴백하지 않았기 때문에, 자체적으로 선택한 포트만 바인딩할 수 없는 경우에도 이 메시지가 표시되었습니다. 이는 Hyper-V가 Claude Code가 선택하는 포트를 포함하는 포트 범위를 예약하는 Windows 호스트에서 발생할 수 있습니다.

**해결 방법:**

* 보안 소프트웨어나 샌드박스 정책이 프로세스의 `127.0.0.1` 수신을 차단하는지 확인하고, Claude Code가 로컬 포트를 바인딩하도록 허용합니다
* 그런 다음 `/mcp`에서 서버를 선택하는 등의 방법으로 로그인을 다시 시작합니다

### origin/HEAD가 없으면 /security-review가 실패함

[`/security-review`](https://code.claude.com/docs/ko/commands#all-commands)는 `origin` 원격의 기본 브랜치를 기록하는 로컬 ref인 `origin/HEAD`와 현재 브랜치를 비교한 diff로 리뷰 컨텍스트를 구성합니다. 해당 ref가 없으면 diff를 수집하는 git 명령이 실패하고 리뷰가 시작되기 전에 중단됩니다.

```text theme={null}
Error: Shell command failed for pattern "!`git diff --name-only origin/HEAD...`": [stderr]
fatal: ambiguous argument 'origin/HEAD...': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
```

메시지에 `git log`나 다른 `git diff`가 대신 표시될 수도 있습니다. Git은 원격이 기본 브랜치를 알리고 fetch refspec이 그 브랜치를 포함할 때만 `origin/HEAD`를 만듭니다. 커밋이 있는 원격을 전체 `git clone`하면 이 조건이 충족됩니다. 다음과 같은 환경에서는 ref가 없습니다:

* 너무 좁은 refspec을 가져오는 단일 브랜치 또는 CI 체크아웃
* 서버 측 HEAD가 아무도 푸시하지 않은 브랜치를 가리키는 원격
* `origin` 원격이 없거나 한 번도 fetch하지 않은 저장소

Claude Code는 [동적 컨텍스트를 주입하는](https://code.claude.com/docs/ko/skills.md#when-an-injected-command-fails) 모든 스킬에 대해 같은 오류를 표시하며, 주입된 명령이 실패하면 해당 스킬 호출이 중단됩니다.

관련 메시지는 명령이 실행되기도 전에 발생합니다:

* `Shell command permission check failed for pattern "..."`: 명령의 권한 검사가 허용하지 않았습니다. [주입된 명령의 권한 검사](https://code.claude.com/docs/ko/skills.md#permission-checks-on-injected-commands)에서 각 권한 모드에서 어떤 결과가 중단되는지와 `allowed-tools`로 명령을 미리 승인하는 방법을 다룹니다
* ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found``: 스킬의 frontmatter가 bash가 없는 컴퓨터에서 bash를 요구합니다. Git for Windows를 설치하거나 frontmatter를 `shell: powershell`로 변경합니다. [주입된 명령이 실행되는 방식](https://code.claude.com/docs/ko/skills.md#how-injected-commands-run)을 참조하세요

**해결 방법:**

* 원격의 기본 브랜치 이름을 지정하여 ref를 만듭니다: `git remote set-head origin <default-branch>`. 이는 로컬 추적 ref `origin/<default-branch>`가 있으면 항상 작동합니다. 단일 브랜치 클론처럼 해당 ref가 없으면 먼저 브랜치를 fetch합니다. `git remote set-branches --add origin <branch>`를 실행하고, 이어서 `git fetch origin`을 실행한 다음, set-head 명령을 다시 실행합니다. 그런 다음 `/security-review`를 다시 실행합니다.
* 브랜치 이름을 지정하고 싶지 않다면 `git fetch origin`을 실행한 다음 `git remote set-head origin --auto`를 실행합니다. 이 명령은 원격에 기본 브랜치가 무엇인지 묻습니다. 원격이 비어 있거나 HEAD가 아무도 푸시하지 않은 브랜치를 가리켜 기본 브랜치를 알리지 않으면 `error: Cannot determine remote HEAD`로 실패하므로, 대신 브랜치 이름을 명시적으로 지정합니다. 클론이 해당 브랜치를 fetch하지 않으면 `error: Not a valid ref`로 실패하므로, 먼저 위와 같이 refspec을 넓힙니다.
* 저장소에 원격이 없으면 `git remote add origin <url>`로 원격을 추가하고 ref를 만들기 전에 fetch합니다. 원격이 비어 있으면 먼저 `git push -u origin HEAD`로 브랜치를 푸시하고 set-head 명령에 해당 브랜치 이름을 지정합니다. 그러면 `origin/HEAD`가 방금 푸시한 브랜치를 가리키므로, 브랜치가 그로부터 갈라질 때까지 `/security-review`는 빈 diff를 보게 됩니다.

### No shell command in a skill or command was run

`No shell command in <name> was run`은 해당 스킬 또는 명령 파일의 `` !`<command>` `` [동적 컨텍스트 명령](https://code.claude.com/docs/ko/skills.md#inject-dynamic-context)에 Bash 또는 PowerShell 도구가 거부하는 문자가 포함되어 있다는 의미입니다:

* **두 도구 모두**: 탭이나 줄 바꿈이 아닌 원시 제어 문자
* **PowerShell 도구**: 추가로 U+FEFF 또는 U+180E

메시지는 거부된 명령으로 끝나며, 거부된 각 문자는 다음 Bash 도구 예시처럼 `�`로 표시됩니다:

```text theme={null}
No shell command in /my-skill was run, because the Bash tool does not accept one of them: command contains control characters that would be hidden in the approval dialog. Unprintable characters are shown as � below: remove them from the skill or command file, or from the arguments or options substituted into it.
build.sh --target�dist
```

**해결 방법:**

* 메시지 끝에 인용된 명령에서 각 `�`를 찾습니다. 그것이 나타내는 문자를 [스킬 또는 명령 파일](https://code.claude.com/docs/ko/skills.md#where-skills-live)에서, 또는 파일에 대입되는 인수나 [옵션](https://code.claude.com/docs/ko/plugins/manifest-reference.md#user-configuration)에서 제거합니다.

### `--print` 사용 시 입력을 제공해야 함

인수 없는 `claude`는 대화형 UI를 시작하기 위해 stdout이 터미널이어야 합니다. stdout이 리디렉션되었거나, PowerShell ISE나 일부 IDE 출력 창처럼 콘솔이 실제 터미널이 아니면 `claude`는 대신 [비대화형으로](https://code.claude.com/docs/ko/headless.md) 실행됩니다. 이는 프롬프트가 필요한 `claude -p`와 같은 모드이므로, 플래그를 전달하지 않았더라도 메시지에 `--print`가 표시됩니다. 프롬프트 없이, stdin으로 파이프된 내용도 없이 `-p`/`--print`를 전달하면 어디서든 같은 오류가 발생합니다.

```text theme={null}
Error: Input must be provided either through stdin or as a prompt argument when using --print
```

**해결 방법:**

* 대화형으로 사용하려면 실제 터미널에서 `claude`를 실행합니다. ISE 대신 Windows Terminal이나 PowerShell 콘솔을, 출력 창 대신 IDE의 통합 터미널을 사용합니다
* 일회성으로 사용하려면 프롬프트를 전달합니다: `claude -p "your question"`, 또는 `echo "your question" | claude -p`로 파이프합니다

### 이 환경에서는 Claude Code가 키보드 입력을 읽을 수 없음

[`-p`](https://code.claude.com/docs/ko/headless) 없이 `claude`를 실행하여 [대화형 세션](https://code.claude.com/docs/ko/interactive-mode.md)을 시작했지만, 표준 입력이 터미널이 아닙니다. 무언가가 입력을 파이프하거나 리디렉션했거나, `claude`를 실행한 프로그램이 자체 입력 스트림을 제공했습니다.

대화형 세션은 키 입력을 읽을 터미널이 필요하며, 터미널이 없을 때 Claude Code의 동작은 플랫폼에 따라 다릅니다:

* **Windows**: Claude Code는 인터페이스를 시작하지 않고 stderr에 메시지를 출력한 후 종료 코드 1로 종료됩니다
* **macOS 및 Linux**: Claude Code는 `/dev/tty`에서 키 입력을 읽어 세션을 시작하며, 파이프된 텍스트가 있으면 첫 번째 프롬프트로 사용합니다. `/dev/tty`를 열 수 없을 때 메시지가 표시되며, 첫 번째 줄에는 Windows 문구 대신 `/dev/tty`가 표시됩니다.

Windows에서는 메시지가 다음과 같습니다:

```text theme={null}
Claude Code can't read the keyboard here: stdin is not a terminal (it is piped, redirected, or supplied by the program that launched claude), and on Windows it can't fall back to the console for input yet.
Run claude directly in Windows Terminal, PowerShell, or Command Prompt, without piping or redirecting its input.
To send text as a prompt and print the reply instead, add -p; it also works with --continue and --resume <session-id> (for example: type notes.md | claude -p --continue).
```

**해결 방법:**

* 대화형으로 작업하려면 입력을 파이프하거나 리디렉션하지 않고 터미널에서 직접 `claude`를 실행합니다
* 스크립트에서처럼 대화형 인터페이스 없이 응답을 받으려면 `-p`를 추가하고 프롬프트를 인수나 stdin으로 전달합니다. 예: `claude -p "your question"` 또는 `echo "your question" | claude -p`. `--continue` 및 `--resume <session-id>`와도 같은 방식으로 작동합니다.

v2.1.287 이전에는 Claude Code가 이 메시지를 출력하는 대신 인터페이스를 시작했고, 화면에 아무것도 표시하지 않거나 `Raw mode is not supported`가 포함된 오류로 실패했습니다.

대신 `claude install` 중에 `Raw mode is not supported`가 표시되면 [설치 중 `Raw mode is not supported`](https://code.claude.com/docs/ko/troubleshoot-install#raw-mode-is-not-supported-during-install)를 참조하십시오.

### 입력에 공백만 포함됨

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 Claude Code는 공백, 탭 또는 줄 바꿈으로만 이루어진 프롬프트를 전송하지 않고 거부합니다. API가 보이는 텍스트가 없는 메시지를 거부하기 때문입니다. 표시되는 메시지는 빈 프롬프트가 어디에서 왔는지에 따라 다릅니다:

* **`claude -p`의 프롬프트 인수 또는 파이프된 stdin**: `claude`가 `Error: Input contained only whitespace. Provide a prompt with text through stdin or as a prompt argument when using --print`와 함께 종료됩니다
* **실행 중인 `--input-format stream-json` 또는 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 세션에 제출된 메시지**: Claude Code는 모델을 호출하지 않고 턴을 종료하며 세션은 계속 사용할 수 있습니다. 거부 내용은 정보 메시지와 턴의 결과 텍스트로 전달됩니다: `Blank prompt — the message was only whitespace, so nothing was sent to the model.`

v2.1.229 이전에는 Claude Code가 공백만 있는 메시지를 API에 전송했고, API는 400 오류로 요청을 거부했습니다.

**해결 방법:**

* 프롬프트에 보이는 텍스트를 포함합니다. 스크립트가 변수나 파일에서 프롬프트를 만든다면 Claude Code를 호출하기 전에 소스가 비어 있지 않은지 확인합니다.

### stream-json 입력이 줄 바꿈 없이 256M 문자를 초과함

프로그램이 `claude -p --input-format stream-json` 실행의 stdin에 줄 바꿈 없이 268,435,456자를 넘게 보냈기 때문에, Claude Code는 더 이상 입력을 버퍼링하지 않고 stderr에 이 오류를 출력한 후 종료 코드 1로 종료됩니다. 메시지는 이 한도를 `256M`으로 표시합니다. v2.1.257 이전에는 Claude Code가 이러한 입력을 제한 없이 버퍼링하여, 프로세스가 충돌하거나 종료될 때까지 메모리가 증가했습니다.

```text theme={null}
Error: stream-json input carried over 256M characters with no newline. Each stream-json message must be a single newline-terminated JSON line: either the producer is not newline-terminating its messages, or one message exceeded this budget.
```

줄 바꿈 없이 이렇게 긴 입력은 대개 생산자가 애초에 stream-json 생산자가 아님을 의미합니다. 예를 들어 바이너리 파일이나 일반 로그 출력이 실수로 파이프된 경우입니다. 한도를 초과하는 단일 메시지도 같은 검사에서 실패합니다.

**해결 방법:**

* stdin으로 무엇이 파이프되는지 확인합니다. [`--input-format stream-json`](https://code.claude.com/docs/ko/cli-reference#cli-flags)에서는 모든 메시지가 줄 바꿈으로 끝나는 JSON 한 줄이어야 합니다
* 대신 일반 텍스트를 보내려면 `--input-format stream-json`을 제거합니다. `claude -p`는 기본적으로 stdin에서 일반 텍스트 프롬프트를 읽습니다

### Unknown command

대화형 터미널 세션에서 이 세션의 어떤 명령과도 일치하지 않는 `/` 이름을 제출했기 때문에, Claude Code는 아무것도 실행하지 않고 해당 이름을 보고합니다:

```text theme={null}
Unknown command: /hepl. Did you mean /help?
```

Claude Code는 이 세션의 메뉴에 나열된 명령 이름이나 별칭 중 가장 가까운 것을 제안합니다. 가까운 것이 없으면 메시지는 이름 뒤에서 끝납니다. 원인은 대개 다음 중 하나입니다:

* `/help`를 `/hepl`로 입력한 것 같은 오타. [명령 메뉴가 입력 내용과 일치시키는 방식](https://code.claude.com/docs/ko/commands.md#how-the-command-menu-matches-what-you-type)에서 제출 전에 가까운 항목을 선택하는 방법을 다룹니다
* 명령은 존재하지만 플랫폼, 플랜, 인증 방법 등의 요구 사항이 충족되지 않아 이 세션에서 사용할 수 없습니다. [`/web-setup`](https://code.claude.com/docs/ko/web-quickstart#web-setup-shows-no-commands-match-or-unknown-command), [`/schedule`](https://code.claude.com/docs/ko/routines#schedule-returns-unknown-command), [`/auto-mode-setup`](https://code.claude.com/docs/ko/auto-mode-config#auto-mode-setup-returns-unknown-command) 항목을 참조하세요. 일부 명령은 조직 정책에 의해 비활성화되었을 때 [`Cloud sessions are disabled by your organization's policy`](#cloud-sessions-are-disabled-by-your-organizations-policy)처럼 자체 메시지로 응답합니다
* 이 세션에 설치되거나 연결되지 않은 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md) 또는 [MCP 서버](https://code.claude.com/docs/ko/mcp.md#use-mcp-prompts-as-commands)의 명령

Claude Code는 대화형 터미널 세션에서만 일치하지 않는 `/` 이름에 이런 방식으로 응답합니다. 그 밖의 모든 세션에서는 프롬프트를 일반 메시지로 Claude에 보내며, 명령이 실행되지 않았다는 메모와 세션에서 Claude가 실행할 수 있는 명령 목록을 함께 보냅니다. 이러한 세션은 다음과 같습니다:

* `-p` 실행
* [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 애플리케이션
* [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md)의 Code 탭
* [VS Code 확장](https://code.claude.com/docs/ko/vs-code.md)의 채팅 패널
* [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md) 및 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)

이러한 세션 중 하나에서 실행할 수 없는 내장 명령의 경우, Claude Code는 Claude에 전송하지 않고 여전히 해당 명령을 사용할 수 없다고 응답합니다. v2.1.274 이전에는 클라우드 세션과 클라우드 예약 작업만 일치하지 않는 이름을 Claude에 전송했습니다. v2.1.273 이전에는 이들도 `Unknown command`로 응답했습니다.

Claude Code는 `/`로 시작하는 모든 프롬프트를 명령으로 처리하지 않습니다. `/` 다음의 첫 단어가 Lean 문서 주석을 여는 `/--`처럼 문장 부호로 시작하거나 `/var/log/syslog` 같은 경로이면 프롬프트를 일반 메시지로 Claude에 보냅니다.

v2.1.236 이전에는 명령 메뉴에 입력한 이름과 가까운 항목이 나열된 상태에서 `Enter`를 누르면 Claude Code가 그 항목을 실행했기 때문에, `/hepl` 같은 오타는 이 메시지를 표시하는 대신 `/help`를 실행했습니다.

**해결 방법:**

* 제안된 이름을 실행하거나, `/` 다음에 이름의 일부를 입력하여 이 세션에서 사용 가능한 명령을 확인합니다
* Claude Code가 문서화된 명령을 알 수 없는 명령으로 보고하면 [명령 참조](https://code.claude.com/docs/ko/commands.md)에서 해당 행에 명시된 요구 사항을 확인합니다

### diff가 너무 커서 ultrareview를 할 수 없음

커밋되지 않은 변경 사항과 스테이징된 변경 사항을 포함하여 브랜치와 기본 브랜치 사이의 diff가 [ultrareview](https://code.claude.com/docs/ko/ultrareview.md)의 크기 제한을 초과했기 때문에, `/code-review ultra`와 `claude ultrareview` 하위 명령이 클라우드 세션 시작 전에 리뷰를 거부합니다. 거부된 리뷰는 무료 실행 횟수를 사용하지 않으며 사용량 크레딧도 청구되지 않습니다. 메시지에는 적용 중인 제한, diff 크기, 그리고 변경된 줄이 가장 많은 파일이 표시됩니다. v2.1.216 이전에는 메시지에 원시 diff 통계만 표시되었습니다.

```text theme={null}
Diff is too large for ultrareview: 812 files, 96,410 lines changed (limits: 500 files, 8,000 lines). Largest files: package-lock.json (41,904 lines), dist/bundle.js (18,210 lines), src/generated/api.ts (9,876 lines). Pass a closer base branch (`/code-review ultra <branch>`) to narrow the scope, or split the change.
```

풀 리퀘스트를 리뷰할 때도 같은 제한이 적용됩니다. 이 경우 메시지는 `PR #<N> is too large for ultrareview`로 시작하며 PR의 파일 수와 줄 수가 표시됩니다.

**해결 방법:**

* `/code-review ultra develop`처럼 작업에 더 가까운 기본 브랜치를 전달하여 리뷰가 해당 브랜치와의 diff만 다루도록 합니다
* 변경 사항을 더 작은 브랜치로 나누고 각각 리뷰합니다. 메시지에 표시된 파일이 변경된 줄이 가장 많으므로, 먼저 해당 파일을 별도 브랜치로 옮기는 것부터 시작합니다.

### 기본 브랜치와의 merge-base를 찾을 수 없음

`/code-review ultra`와 `claude ultrareview` 하위 명령은 브랜치와 기본 브랜치 사이의 diff를 리뷰하며, 이를 위해서는 두 브랜치가 공유하는 커밋이 필요합니다. `git merge-base`가 그런 커밋을 찾지 못하면 Claude Code는 클라우드 세션 시작 전에 리뷰를 거부합니다. Claude Code가 완전한 것으로 확인할 수 있고 브랜치가 하나 이상 있는 클론에서는 거부하는 대신 [추적 중인 모든 파일을 리뷰](https://code.claude.com/docs/ko/ultrareview.md#diff-limits-and-fallbacks)하는 방식으로 폴백합니다. 이 거부는 기본 브랜치를 전혀 찾을 수 없을 때, Claude Code가 클론이 완전한지 확인할 수 없을 때, 또는 SHA-256 객체 형식처럼 전체 트리 diff가 불가능한 드문 저장소에서 표시됩니다.

```text theme={null}
Could not find merge-base with main. Pass the base branch explicitly (e.g. `/code-review ultra develop`) or make sure you're in a git repo with a main branch.
```

첫 문장 뒤의 힌트는 Claude Code가 관찰한 내용에 따라 달라집니다:

* **기본 브랜치를 전달하지 않은 경우**: Claude Code는 저장소의 기본 브랜치와 비교했으며, 위 예시처럼 기본 브랜치를 명시적으로 전달하도록 제안합니다
* **클론에 이미 있는 기본 브랜치를 전달한 경우**: 힌트는 ``Make sure <branch> exists locally or on origin (try `git fetch origin <branch>`)``입니다
* **클론에 없던 기본 브랜치를 전달한 경우**: Claude Code는 비교하기 전에 origin에서 해당 브랜치를 가져왔습니다. 힌트는 ``<branch> was fetched from origin but shares no history with HEAD. If another branch is your real base, pass it explicitly (`/code-review ultra <branch>`)``이며, Claude Code가 클론이 shallow인지 판단할 수 없는 경우에는 대신 `git fetch --unshallow origin`을 제안합니다. v2.1.221 이전에는 가져온 모든 기본 브랜치에 대해 힌트가 `git fetch --unshallow origin`을 제안했으며, 완전한 클론에서는 이 명령이 `fatal: --unshallow on a complete repository does not make sense`와 함께 실패했습니다.

**해결 방법:**

* 다른 브랜치가 실제 기본 브랜치라면 명시적으로 전달합니다: `/code-review ultra <branch>`
* 클론에 전체 히스토리가 없을 수 있다면 `git fetch --unshallow origin`을 실행하고 리뷰를 다시 실행합니다

### 체크아웃에 브랜치가 없음

체크아웃에는 커밋이 있어도 브랜치가 없을 수 있습니다. `git init`을 실행한 후 `git fetch <url>`과 `git checkout FETCH_HEAD`를 실행하면 ref가 없는 detached HEAD 상태가 됩니다. Claude Code는 [ultrareview](https://code.claude.com/docs/ko/ultrareview.md)를 위해 저장소를 git 번들로 패키징하여 업로드하는데, 브랜치나 다른 ref가 없는 저장소는 번들로 만들 수 없으므로 `/code-review ultra`와 `claude ultrareview` 하위 명령이 클라우드 세션 시작 전에 리뷰를 거부합니다.

```text theme={null}
Your checkout has no branches (detached HEAD only), which cloud review can't bundle. Create one first — `git checkout -b <name>` — then rerun /code-review ultra.
```

v2.1.221 이전에는 Claude Code가 이 체크아웃에서 추적 중인 모든 파일을 리뷰하려고 시도했고 업로드가 실패했습니다.

**해결 방법:**

* `git checkout -b <name>`으로 현재 커밋에서 브랜치를 만든 다음 리뷰를 다시 실행합니다

### Claude 계정에 연결된 GitHub 계정이 없음

`/code-review ultra <PR#>` 또는 `claude ultrareview <PR#>`를 실행하면 Claude Code는 클라우드 세션을 만들기 전에 [Claude 계정에 연결된 GitHub 계정](https://code.claude.com/docs/ko/ultrareview.md#review-a-pull-request)이 PR의 저장소에 접근할 수 있는지 서버에 확인합니다. 연결된 계정이 없거나 연결이 만료되어 클라우드 클론이 실패할 것이므로 Claude Code가 실행을 거부합니다. 거부된 실행에 대해서는 무료 실행 횟수를 사용하거나 사용량 크레딧을 청구하지 않습니다.

```text theme={null}
Ultrareview clones <owner>/<repo> in the cloud with the GitHub account connected to your Claude account, and none is connected (or the connection expired). To fix: run /web-setup to reuse your GitHub CLI login, or connect an account at https://claude.ai/connect-github — then re-run /code-review ultra 1234 (allow a minute after connecting).
```

세션에서 [`/web-setup`](https://code.claude.com/docs/ko/web-quickstart#connect-from-your-terminal)을 사용할 수 없으면 메시지에는 claude.ai 링크만 표시됩니다.

**해결 방법:**

* `/web-setup`을 실행하여 GitHub CLI 로그인을 Claude 계정에 연결하거나, [claude.ai/connect-github](https://claude.ai/connect-github)에서 계정을 연결합니다
* 연결하고 1분 후에 리뷰를 다시 실행합니다

v2.1.248 이전에는 Claude Code가 실행 전에 이를 확인하지 않았습니다.

### 연결된 GitHub 계정이 저장소를 볼 수 없음

`/code-review ultra <PR#>` 또는 `claude ultrareview <PR#>`를 실행했지만 [Claude 계정에 연결된 GitHub 계정](https://code.claude.com/docs/ko/ultrareview.md#review-a-pull-request)이 PR의 저장소를 읽을 수 없어 클라우드 클론이 실패할 것이므로 Claude Code가 실행을 거부합니다. 거부된 실행에 대해서는 무료 실행 횟수를 사용하거나 사용량 크레딧을 청구하지 않습니다.

```text theme={null}
Your connected GitHub account can't see <owner>/<repo> — usually the Claude GitHub app isn't installed on <owner> or wasn't granted this repo (web-connected accounts need it for private repos), or a different GitHub account is connected. To fix: run /web-setup to reuse your GitHub CLI login, or install the app at https://github.com/apps/claude/installations/new — then re-run /code-review ultra 1234.
```

세션에서 [`/web-setup`](https://code.claude.com/docs/ko/web-quickstart#connect-from-your-terminal)을 사용할 수 없으면 메시지에는 앱 설치만 표시됩니다.

**해결 방법:**

* 로컬 `gh` CLI가 저장소를 읽을 수 있다면 `/web-setup`을 실행하여 그 로그인을 Claude 계정에 연결합니다
* 변경 후 리뷰를 다시 실행합니다

v2.1.248 이전에는 Claude Code가 실행 전에 이를 확인하지 않았습니다.

### GitHub App 사전 검사가 일시적으로 실패함

로컬 저장소에서 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 시작했는데 두 단계가 함께 실패했습니다. Claude Code가 저장소 번들을 빌드하거나 업로드할 수 없었습니다. 업로드 전에 Claude Code는 클라우드 서비스가 GitHub에서 저장소를 클론할 수 있는지 확인했는데, 이 확인이 명확한 답 대신 네트워크 오류, 시간 초과, 일시적인 서버 오류처럼 재시도하면 해소될 수 있는 오류로 끝났습니다. 전체 메시지는 `Could not upload repo bundle (<error>)`처럼 번들을 막은 원인으로 시작하고 사전 검사 문장으로 끝납니다:

```text theme={null}
Could not upload repo bundle (<error>). The GitHub App preflight failed transiently (network or service hiccup) — retry in a moment to start from GitHub instead
```

**해결 방법:**

* 잠시 후 명령을 다시 실행합니다. GitHub 확인이 통과하면 Claude Code가 GitHub 클론에서 세션을 시작할 수 있으므로 실패한 업로드가 더 이상 실행을 막지 않습니다
* 재시도가 계속 실패하면 메시지 앞부분에 업로드를 막은 원인이 표시됩니다. 그 원인을 수정할 수 있다면 수정하여 로컬 저장소에서 세션을 시작할 수 있도록 합니다

v2.1.251 이전에는 GitHub 확인이 일시적으로만 실패한 경우에도 Claude Code가 메시지를 `Please set up GitHub on https://claude.ai/code`로 끝냈으며, 설정 조언으로는 일시적인 실패를 해결할 수 없었습니다.

### 저장소 업로드가 git 설정을 따를 수 없음

[로컬 저장소를 업로드하는 클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#send-local-repositories-without-github) 또는 브랜치의 [ultrareview](https://code.claude.com/docs/ko/ultrareview.md)를 시작했는데, 파일에 어떤 속성 규칙이 적용되는지 결정하는 git 설정 중 하나를 업로드가 따를 수 없습니다. 업로드가 진행되어 규칙을 놓치면, clean 필터로 암호화되는 파일처럼 git이 저장 전에 변환하는 파일이 디스크에 있는 그대로 클라우드에 전달될 수 있습니다. 따라서 Claude Code는 업로드를 거부하며 아무것도 업로드되지 않습니다:

```text theme={null}
Not uploading this working tree: core.ignoreCase (which decides whether .gitattributes patterns match file names regardless of letter case) is set in <file>, and the upload cannot follow that setting, so a file git would change before storing it (to encrypt it, for example) could be uploaded as it is on disk. Move the core.ignoreCase line into this repository’s .git/config or directly into your ~/.gitconfig, then retry.
```

메시지에는 설정과 설정된 위치가 표시되며, 해당하는 경우에 대한 해결 방법으로 끝납니다. `core.attributesFile`과 `attr.tree`에 대해서도 각각의 해결 방법과 함께 같은 거부가 표시됩니다.

메시지에는 git 구성이 `include` 또는 `includeIf` 지시문을 통해 불러오는 설정 파일이 표시될 수 있으며, 해당 지시문의 조건이 이 저장소에 적용되지 않는 경우에도 마찬가지입니다.

**해결 방법:**

* 메시지의 마지막 문장에 있는 해결 방법을 적용합니다

### GitHub가 Claude 계정에 연결되어 있지 않음

`/autofix-pr` 등을 사용하여 로컬 저장소에서 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 시작했습니다. Claude 계정에 연결된 GitHub 계정이 없거나 연결이 만료되었으므로 Claude Code가 실행을 거부합니다:

```text theme={null}
GitHub isn't connected to your Claude account, so this repository can't be cloned in the cloud. Run /web-setup to connect with your GitHub CLI login, or connect on the web at https://claude.ai/connect-github
```

[`/schedule`](https://code.claude.com/docs/ko/routines)로 클라우드 예약 작업을 만들 때는 동일한 메시지가 저장소 이름이 포함된 설정 안내로 표시되며, 이 안내는 작업 생성을 막지 않습니다.

**해결 방법:**

* `/web-setup`을 실행하여 GitHub CLI 로그인을 Claude 계정에 연결하거나, [claude.ai/connect-github](https://claude.ai/connect-github)에서 계정을 연결합니다. 두 방법의 차이는 [GitHub 인증 옵션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#github-authentication-options)을 참조하십시오.
* 연결하고 1분 후에 명령을 다시 실행합니다

v2.1.268 이전에는 Claude Code가 이를 Claude GitHub App 확인의 일시적인 실패로 보고하고 재시도하거나 앱을 설치하도록 제안했지만, 둘 다 GitHub 계정을 연결하지 않습니다.

### GitHub 조직 정책이 Claude를 차단하고 있음

Claude Code 프롬프트에서 [`/autofix-pr`](https://code.claude.com/docs/ko/claude-code-on-the-web#auto-fix-pull-requests)처럼 클라우드 세션을 시작하는 명령을 실행했습니다. Claude Code는 세션을 생성하기 전에 GitHub에서 Claude의 저장소 접근 권한을 확인하는데, GitHub 조직에 Claude를 차단하는 정책이 있어 GitHub가 이를 거부했습니다. Claude Code는 그 시점에서 중단하고 해당 정책을 명시하는 메시지를 표시합니다.

IP 허용 목록이 접근을 차단하는 경우 메시지는 다음과 같습니다.

```text theme={null}
Your GitHub organization has an IP allowlist that is blocking Claude. Add Claude's IP ranges to your GitHub allowlist.
```

싱글 사인온이 차단하는 경우 메시지는 다음과 같습니다.

```text theme={null}
Your GitHub organization requires single sign-on. Disconnect and reconnect GitHub on the Connectors page in Claude on the web, click Authorize next to your organization when GitHub asks, then try again.
```

Microsoft Entra ID 조건부 액세스 정책이 차단하는 경우 메시지는 다음과 같습니다.

```text theme={null}
Your GitHub organization's identity provider (Microsoft Entra ID) has a Conditional Access policy that is blocking Claude. Ask your GitHub Enterprise or Entra ID admin to allow Claude in that policy.
```

**해결 방법:**

* **IP 허용 목록**: GitHub 조직 또는 엔터프라이즈의 소유자에게 Anthropic의 아웃바운드 IP 주소를 허용하도록 요청합니다. 주소와 변경할 GitHub 설정은 [GitHub 허용 목록 및 방화벽](https://code.claude.com/docs/ko/network-config.md#github-allow-lists-and-firewalls)을 참조하십시오.
* **싱글 사인온**: [claude.ai/customize/connectors](https://claude.ai/customize/connectors)에서 GitHub 연결을 해제한 다음 다시 연결합니다. GitHub가 요청하면 조직 옆의 **Authorize**를 클릭하여 새 연결이 해당 조직의 싱글 사인온에 대해 승인되도록 합니다.
* **조건부 액세스 정책**: GitHub Enterprise 또는 Microsoft Entra ID 관리자에게 해당 정책에서 Claude를 허용하도록 요청합니다
* 변경 후 명령을 다시 실행합니다

### 싱글 사인온 승인 필요

[`/install-github-app`](https://code.claude.com/docs/ko/github-actions#quick-setup)을 실행하고 SAML 싱글 사인온을 적용하는 조직의 저장소를 선택했습니다. Claude Code는 설정 전에 GitHub CLI로 저장소 접근 권한을 확인하는데, `gh` 토큰이 아직 해당 조직에 대해 승인되지 않아 GitHub가 이 확인을 거부했습니다. 마법사는 승인 단계와 함께 경고를 표시합니다.

```text theme={null}
Single sign-on authorization needed
<owner>/<repo> belongs to an organization that enforces SAML single sign-on, and your GitHub CLI token isn't authorized for it yet.
```

**해결 방법:**

* `gh auth refresh -h github.com -s repo,workflow`를 실행하여 `repo` 및 `workflow` 범위로 GitHub CLI 로그인을 다시 승인하고, GitHub가 싱글 사인온을 요청하면 조직을 승인합니다
* `GH_TOKEN`의 개인 액세스 토큰으로 인증하는 경우 [github.com/settings/tokens](https://github.com/settings/tokens)를 열고 토큰에서 **Configure SSO**를 선택한 다음 조직을 승인합니다
* `/install-github-app`을 다시 실행합니다

v2.1.273 이전에는 이 상황에서 Claude Code가 대신 `Admin permissions required` 경고를 표시했습니다.

### 대화를 재개하지 못함

Claude Code가 [`claude --resume` 선택기](https://code.claude.com/docs/ko/sessions#use-the-session-picker)에서 선택한 세션의 저장된 트랜스크립트를 읽거나 처리할 수 없어, 부분적으로 로드된 상태로 계속하는 대신 프로세스를 종료합니다. 메시지에는 재시도할 명령이 포함됩니다.

```text theme={null}
Failed to resume the conversation.
Run claude --resume <session-id> to retry, or claude to start a new session.
```

Claude Code는 메시지를 표시한 후 코드 1로 종료됩니다. 실행 중인 세션 내의 `/resume` 선택기는 대신 대화에 `Failed to resume conversation`을 보고하며, 현재 세션은 계속 실행됩니다. v2.1.216 이전에는 `claude --resume` 선택기에서 재개에 실패하면 이 메시지를 표시하는 대신 `Resuming conversation…` 스피너에 무기한 머물러 있었습니다.

**해결 방법:**

* 메시지의 세션 ID로 `claude --resume <session-id>`를 실행하여 재시도합니다
* v2.1.285 이전 버전에서 재시도가 같은 방식으로 실패하면 `claude update`를 실행하고 다시 재개합니다. 해당 버전은 저장된 트랜스크립트에 읽을 수 없는 항목이 포함되어 있으면 재개에 실패합니다.
* 재시도가 다시 실패하면 `claude`를 실행하여 새 세션을 시작합니다

### 해당 세션 ID의 대화를 찾을 수 없음

`claude --resume <session-id>`에 세션 ID를 전달했지만 일치하는 저장된 트랜스크립트가 없습니다.

```text theme={null}
No conversation found with session ID: <session-id>
```

Claude Code는 메시지를 표시한 후 코드 1로 종료합니다. Claude Code는 [현재 프로젝트를 먼저 검색한 다음 이 머신의 다른 모든 프로젝트](https://code.claude.com/docs/ko/sessions.md#where-the-session-picker-looks)에서 ID를 찾습니다. v2.1.223 이전에는 조회가 현재 프로젝트 디렉터리와 해당 git worktree에서 멈췄으므로, 세션이 마지막으로 작업한 디렉터리에서 재개해야 합니다.

일반적인 원인:

* **잘못 입력한 ID**: 비대화형 실행의 경우 ID는 [`--output-format json` 출력](https://code.claude.com/docs/ko/headless#get-structured-output)의 `session_id` 필드입니다
* **삭제된 트랜스크립트**: Claude Code는 [보존 정리 규칙](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)에 따라 [보존 기간](https://code.claude.com/docs/ko/sessions.md#where-transcripts-are-stored)(기본값 30일)이 지나면 트랜스크립트를 제거합니다
* **다른 머신**: Claude Code는 트랜스크립트를 로컬에 저장하므로 세션이 실행된 머신에서 재개해야 합니다
* **중복 사본**: `~/.claude/projects` 아래의 프로젝트 디렉터리를 복사하여 두 트랜스크립트가 같은 ID를 갖게 된 경우, Claude Code는 임의로 한 사본을 재개하는 대신 이 메시지를 보고합니다

**해결 방법:**

* 대화형 세션의 경우 `claude --resume`으로 [세션 선택기](https://code.claude.com/docs/ko/sessions.md#use-the-session-picker)를 열고 `Ctrl+A`를 눌러 이 머신의 모든 프로젝트로 범위를 넓힌 다음 세션을 선택합니다
* `claude -p` 또는 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)로 생성된 세션은 선택기에 나타나지 않으므로, 원래 실행에서 출력된 `session_id`와 ID를 다시 대조합니다

### Claude Code가 이 세션의 트랜스크립트 파일을 읽을 때 Windows가 오류(EBADF)를 보고함

Windows에서 세션을 재개했고, 저장된 [트랜스크립트 파일](https://code.claude.com/docs/ko/sessions.md#where-transcripts-are-stored)은 정상적으로 열렸지만 이후 읽기가 시스템 오류 EBADF로 실패했습니다. 시스템 오류는 읽기가 실패한 이유를 알려주지 않으므로, 메시지에서 가능한 원인과 시도할 방법을 제안합니다.

```text theme={null}
Windows reported an error (EBADF) when Claude Code read this session's transcript file, although the file had opened normally. This can happen when other software intercepts file reads — security, encryption or endpoint-management tools, for example. If it keeps happening for this conversation, try excluding the folder that holds Claude Code's session transcripts from such software (the .claude folder in your user profile, unless the app or CLAUDE_CONFIG_DIR points Claude Code elsewhere), or adding Claude Code to its allowed applications, then resume again.
```

이 메시지는 `Failed to resume session <session-id>`처럼 명령 자체의 실패 줄 다음에 표시됩니다. `claude --resume` 또는 [`claude -p`](https://code.claude.com/docs/ko/headless) 명령은 이를 표시한 후 코드 1로 종료됩니다. 세션 내에서 `/resume`을 실행한 경우에는 현재 세션이 계속 실행됩니다.

**해결 방법:**

* 보안, 암호화 또는 엔드포인트 관리 도구처럼 파일 읽기를 검사하거나 가로채는 소프트웨어에서 세션 트랜스크립트가 있는 폴더를 제외합니다. 트랜스크립트는 기본적으로 `%USERPROFILE%\.claude\projects` 아래에 있거나, [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars)이 지정하는 디렉터리 아래에 있습니다
* 제외를 추가할 수 없는 경우 대신 해당 소프트웨어의 허용된 애플리케이션에 Claude Code를 추가합니다
* 세션을 다시 재개합니다

v2.1.282 이전에는 실패 시 아무런 설명이 없었습니다. `claude --resume <session-id>`는 `Failed to resume session <session-id>`로 끝났고, `-p` 실행은 `Failed to resume session: EBADF: bad file descriptor, read`처럼 시스템 오류 텍스트만 출력했습니다.

### 이 세션에서 렌더러를 전환할 수 없음

렌더러를 전환하면 Claude Code는 프로세스를 다시 시작합니다. Claude Code가 다시 시작을 거부하는 세션에서 [`/tui`](https://code.claude.com/docs/ko/fullscreen#enable-fullscreen-rendering)를 실행했으므로, 전환하지 않고 아무것도 저장하지 않습니다. 표시되는 메시지로 원인을 알 수 있습니다.

* `Cannot switch renderers while work is running in the background`: 백그라운드 셸이나 서브에이전트처럼 다시 시작하면 중단될 백그라운드 작업이 실행 중입니다. 작업이 끝날 때까지 기다리거나 [`/tasks`](https://code.claude.com/docs/ko/commands)로 중지한 다음 `/tui fullscreen` 또는 `/tui default`를 다시 실행합니다
* `Cannot switch renderers in this session`: 세션에 Claude Code가 다시 시작된 프로세스로 전달할 수 없는 제한이 있습니다. v2.1.234 이전에는 Claude Code가 그래도 다시 시작했고, 다시 실행된 세션은 해당 제한 없이 실행되었습니다

제한 메시지에서 괄호 안의 부분은 Claude Code가 발견한 제한을 나타냅니다.

```text theme={null}
Cannot switch renderers in this session — it has restrictions a restart can't carry over (permission rules set for this session only). Nothing was changed. Running /tui fullscreen in a session started without them switches every later session too.
```

메시지의 괄호 안에 표시될 수 있는 각 이유는 다음과 같습니다.

* `launch flags: a custom system prompt, a tool allowlist, or restricted settings`: Claude Code가 다시 시작된 프로세스로 다시 전달하지 않는 플래그로 세션을 시작했습니다. 이러한 플래그에는 [`--system-prompt`](https://code.claude.com/docs/ko/cli-reference#cli-flags), `--system-prompt-file`, `--append-system-prompt-file`, [`--tools`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 허용 목록, [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference#cli-flags), [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags)이 포함됩니다
* `permission rules set for this session only`: 훅 또는 SDK 호출자의 [권한 업데이트](https://code.claude.com/docs/ko/hooks.md#permission-update-entries)가 `session` 대상으로 거부 또는 확인 규칙을 추가했습니다. 세션 범위의 허용 규칙은 거부를 유발하지 않습니다. 다시 시작하면 해당 규칙이 삭제되고 Claude Code가 대신 다시 확인을 요청합니다
* `ask-before-running rules with no command-line form`: 훅 또는 SDK 호출자의 권한 업데이트가 Claude Code가 `--allowed-tools` 및 `--disallowed-tools`로 다시 전달하는 규칙과 함께 확인 규칙을 추가했습니다. 확인 규칙에 대한 플래그는 존재하지 않습니다
* `permission rules a command line cannot carry intact` 및 `added directories a command line cannot carry intact`: 권한 업데이트가 세션 도중에 규칙이나 디렉터리 경로를 추가했습니다. 다시 시작된 프로세스의 명령줄은 해당 텍스트를 동일한 값으로 전달할 수 없습니다

**해결 방법:**

* 해당 제한 없이 시작된 세션에서 `/tui fullscreen`을 실행하거나, 다시 전환하려면 `/tui default`를 실행합니다. Claude Code는 그곳에서 [`tui` 설정](https://code.claude.com/docs/ko/settings-reference#tui)을 저장합니다

### Can't restart while work is running or Remote Control is connected

Claude Code가 다시 시작되지 않았으며 세션은 그대로 계속 실행됩니다. 메시지의 해결 방법을 따르세요.

### Claude Code couldn't restart

이 메시지에 대화가 저장되었다고 표시되면, 대화는 디스크에 있으며 중단된 지점부터 이어서 진행할 수 있습니다. Claude Code가 자체적으로 다시 시작하는 중이었는데(예: [`/tui`](https://code.claude.com/docs/ko/fullscreen#enable-fullscreen-rendering)를 실행한 후 전체 화면 렌더링으로 전환하거나 해제하기 위해), 새 프로세스를 시작할 수 없어 상태 1로 종료되었습니다:

```text theme={null}
Claude Code couldn't restart. Your conversation is saved. Start Claude Code again and run /resume to pick it up.
```

다시 시작할 때 다시 열 대화가 없었던 경우(예: 새 세션에서 `/tui`가 첫 입력이었던 경우) 메시지는 `Claude Code couldn't restart. Start Claude Code again.`입니다.

**해결 방법:**

* 셸에서 `claude`를 다시 실행합니다. 메시지에 대화가 저장되었다고 표시되었다면 새 세션에서 [`/resume`](https://code.claude.com/docs/ko/sessions#resume-a-session)을 실행하고 해당 대화를 선택합니다. 목록에 없으면 [세션 선택기의 범위를 넓힙니다](https://code.claude.com/docs/ko/sessions.md#where-the-session-picker-looks)
* 다시 시작이 계속 실패하면 셸에서 [`claude --debug-file claude-debug.log`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 Claude Code를 시작합니다. 해당 세션에서 다시 시작이 실패하면, 시작한 디렉터리의 `claude-debug.log`에 운영 체제의 오류와 함께 `Failed to relaunch:` 줄이 기록됩니다. [문제를 보고](#report-an-error)할 때 해당 줄을 포함하십시오

### Claude Desktop을 열 수 없음

세션에서 [`/desktop`](https://code.claude.com/docs/ko/desktop#coming-from-the-cli) 또는 그 별칭인 `/app`을 실행했거나, 셸에서 [`claude --desktop`](https://code.claude.com/docs/ko/cli-reference#cli-flags)을 실행했는데 Claude Code가 Claude Desktop을 열기 위해 사용하는 시스템 명령이 실패했습니다. `/desktop` 이후에는 세션이 터미널에 유지되며, `claude --desktop`은 `Error:` 접두사 없이 메시지를 출력하고 상태 1로 종료됩니다.

괄호 안의 텍스트는 실패한 명령을 나타내며, 종료 상태와 오류 출력의 첫 줄이 생성된 경우 함께 표시합니다. macOS에서는 이 예시처럼 해당 명령이 `open`이며, Windows에서는 `rundll32`입니다.

```text theme={null}
Error: Couldn't open Claude Desktop (`open` exited 1: LSOpenURLsWithRole() failed for the URL claude://resume?session=<session-id> with error -10814). Open Claude Desktop and try again.
```

**해결 방법:**

* Claude Desktop을 직접 연 다음 `/desktop` 또는 `claude --desktop`을 다시 실행합니다
* 실패한 명령의 전체 오류 출력을 확인하려면 `/debug`로 디버그 로깅을 켜고 `/desktop`을 다시 실행하거나, `claude --desktop --debug-file <path>`를 실행한 다음 디버그 로그를 확인합니다

v2.1.285 이전에는 메시지가 `Open Claude Desktop and run /desktop again.`으로 끝났습니다. v2.1.275 이전에는 `Failed to open Claude Desktop. Please try opening it manually.`였으며 무엇이 실패했는지 알려주지 않았습니다.

### /terminal-setup이 Zed 키맵을 변경하지 않음

Zed에서 [`/terminal-setup`](https://code.claude.com/docs/ko/terminal-config#enter-multiline-prompts)을 실행했지만 Claude Code가 Zed `keymap.json` 업데이트를 완료할 수 없어 파일을 그대로 두었습니다.

각 메시지는 키맵 경로를 명시하고, 직접 추가할 키보드 단축키 블록으로 끝납니다.

```text theme={null}
Couldn't update your Zed keymap, so it was left unchanged.
To add the binding yourself, add this block to the keymap array in <path to keymap.json>:
{ "context": "Terminal", "bindings": { "shift-enter": ["terminal::SendText", "\u001b\r"] } }
```

메시지의 첫 줄은 원인을 나타냅니다.

* `Couldn't read your Zed keymap, so it was left unchanged.`: 파일 권한 등의 이유로 Claude Code가 파일을 읽을 수 없었습니다
* `Your Zed keymap isn't a readable list of keybindings, so it was left unchanged.`: 파일은 정상적으로 읽었지만, `//` 주석과 후행 쉼표를 허용하더라도 키보드 단축키 블록의 배열로 파싱되지 않습니다
* `Couldn't back up your Zed keymap; not modifying it.`: Claude Code가 파일 옆에 `.bak` 백업으로 복사할 수 없어 아무것도 변경하지 않았습니다
* `Couldn't update your Zed keymap, so it was left unchanged.`: 병합된 결과가 해당 바인딩을 포함하는 유효한 키맵으로 검증되지 않아 Claude Code가 쓰지 않고 폐기했습니다. 키가 중복된 키보드 단축키 블록이 원인일 수 있습니다

**해결 방법:**

* 메시지의 블록을 메시지가 명시하는 경로의 `keymap.json` 최상위 배열에 복사합니다
* `isn't a readable list of keybindings`의 경우 구문 오류를 수정하거나 파일의 최상위 값을 배열로 만든 다음 `/terminal-setup`을 다시 실행합니다

v2.1.247 이전에는 `/terminal-setup`이 `//` 주석이나 후행 쉼표를 사용하는 Zed 키맵을 파싱할 수 없었으며, 바인딩이 설치되었다고 보고하면서 전체 파일을 자체 바인딩만으로 대체했습니다. 이전 버전이 대체한 키맵을 복원하려면 [여러 줄 프롬프트 입력](https://code.claude.com/docs/ko/terminal-config.md#enter-multiline-prompts)에 설명된 `.bak` 백업 파일을 사용하십시오.

### 이 연결에서는 스킬 사용 보고서를 사용할 수 없음

휴대폰이나 브라우저에서 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 통해 [`/skill-doctor`](https://code.claude.com/docs/ko/skills#find-unused-skills)를 실행했습니다. Claude Code는 Remote Control을 통해 스킬 사용 보고서를 보내지 않으며, 대신 다음 메시지로 응답합니다.

```text theme={null}
Skill usage reports are not available on this connection.
```

**해결 방법:**

* 세션이 실행 중인 머신의 터미널에서 `/skill-doctor`를 실행하거나, 해당 머신에서 `claude -p "/skill-doctor"`를 실행합니다

### Remote Control을 통해서는 사용자 지정 출력 스타일을 선택할 수 없음

[Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 통해 모바일 앱 또는 웹에서 [`/output-style`](https://code.claude.com/docs/ko/output-styles#change-your-output-style)을 실행했거나, 세션으로 전달된 메시지에 해당 명령이 포함되어 있었습니다. 이러한 턴은 계정 소유자가 보낸 것이 아닐 수 있으므로, Claude Code는 해당 턴에서 [기본 제공 스타일](https://code.claude.com/docs/ko/output-styles.md#built-in-output-styles)만 나열하고 선택하며, 명령이 스타일을 나열하거나 입력한 이름을 인식하지 못할 때마다 이 안내를 추가합니다. [사용자 지정 스타일](https://code.claude.com/docs/ko/output-styles.md#create-a-custom-output-style) 이름은 존재하지 않는 이름과 동일한 응답을 받습니다.

```text theme={null}
Custom output styles can't be selected over Remote Control or from a relayed message. Select one in the session itself, or pick a built-in style here.
```

**해결 방법:**

* 기본 제공 스타일을 선택합니다(예: `/output-style concise`)
* 사용자 지정 스타일을 사용하려면 프로젝트의 `.claude/settings.local.json`에서 [`outputStyle`](https://code.claude.com/docs/ko/settings-reference#outputstyle)을 설정하거나, 세션 자체의 터미널이 있다면 그곳에서 `/output-style <style>`을 실행합니다

### 출력 스타일은 이 세션이 로드하지 않는 로컬 설정에 저장됨

설정 소스에서 `local`을 제외하는 세션에서 `/output-style <style>` 또는 `/config outputStyle=<style>`로 [출력 스타일](https://code.claude.com/docs/ko/output-styles.md)을 전환하려고 했습니다. 예를 들어 [`settingSources`](https://code.claude.com/docs/ko/agent-sdk/typescript#options)에서 `"local"`을 제외한 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/typescript.md) 세션이나, `local`을 제외하는 [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 값으로 시작된 CLI 세션이 있습니다. 두 명령 모두 스타일을 `.claude/settings.local.json`에 저장하는데, 이러한 세션은 이 파일을 다시 읽지 않으므로 Claude Code는 효과가 없을 설정을 쓰는 대신 거부합니다.

```text theme={null}
Output styles are saved to local settings (.claude/settings.local.json), which this session doesn't load, so the style can't be changed here.
```

**해결 방법:**

* 세션의 설정 소스에 `local`을 추가하고 다시 전환합니다
* 프로젝트의 `.claude/settings.json` 또는 `~/.claude/settings.json`처럼 세션이 로드하는 설정 파일에서 [`outputStyle`](https://code.claude.com/docs/ko/settings-reference#outputstyle) 키를 설정합니다. TypeScript SDK에서는 대신 인라인 `settings` 객체 내에서 `outputStyle`을 설정합니다. [출력 스타일 활성화](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#activate-an-output-style)를 참조하십시오

### /recap은 직접 요청할 때만 실행됨

[`/recap`](https://code.claude.com/docs/ko/interactive-mode#session-recap) 요청이 사용자 본인의 입력에서 온 것이 아닙니다. Slack, Teams 또는 [프로젝트](https://code.claude.com/docs/ko/claude-projects.md) 스레드에서 세션으로 전달된 메시지에 포함되어 도착했거나, [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md) 또는 다른 프로그램이 보낸 프롬프트에 포함되어 도착했습니다.

전달된 메시지는 사용자가 직접 작성한 경우에도 이 안내를 받습니다. Claude Code는 전달되거나 자동화된 메시지가 세션을 실행하는 계정의 소유자로부터 온 것인지 알 수 없으므로, 요약 대신 다음 안내로 응답합니다.

```text theme={null}
/recap only runs when you ask for it yourself in this session: from the terminal, the Claude app or claude.ai/code, or over Remote Control. A message relayed from Slack, Teams or a project thread, or sent by a routine or another program, can't request it.
```

`claude -p`에 전달하는 `/recap`이나, 사용자 자신의 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 애플리케이션이 실행한 세션에 보내는 `/recap`은 사용자의 직접 입력으로 간주됩니다.

**해결 방법:**

* 세션을 직접 열고 그곳에서 `/recap`을 실행합니다: 해당 터미널, [Desktop 앱](https://code.claude.com/docs/ko/desktop.md) 또는 [모바일 앱](https://code.claude.com/docs/ko/mobile.md), [claude.ai/code](https://claude.ai/code), 또는 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 통해 실행할 수 있습니다
* 클라우드 예약 작업이나 다른 프로그램이 보낸 경우 해당 프롬프트에서 `/recap`을 제거합니다

### /feedback is disabled by your organization's policy

이 메시지는 조직의 정책이 Claude Code에서의 제품 피드백을 허용하지 않아 `/feedback`, `/bug`, `/share`가 피드백 대화 상자를 열지 않는다는 의미입니다. 메시지에는 Claude Code 프롬프트에 입력한 명령이 표시됩니다.

```text wrap theme={null}
/feedback is disabled by your organization's policy. To report a bug, open an issue at https://github.com/anthropics/claude-code/issues. Issues are public, so leave out anything confidential.
```

메시지가 첫 문장만으로 표시될 수도 있습니다.

**해결 방법:**

* 버그를 보고하려면 [github.com/anthropics/claude-code/issues](https://github.com/anthropics/claude-code/issues)에서 이슈를 엽니다. 이곳의 이슈는 누구나 읽을 수 있으므로 코드, 트랜스크립트 및 기타 기밀 정보는 포함하지 않습니다.

v2.1.302 이전에는 전체 메시지가 `/feedback is disabled by your organization's policy. Contact your organization admin to enable it.`였습니다.

## 플러그인 오류

이러한 오류는 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md) 및 [마켓플레이스](https://code.claude.com/docs/ko/plugins/overview.md) 구성에서 발생합니다. 이 페이지의 메시지 중 하나를 생성하지 않는 플러그인 문제(예: 로드되지 않는 마켓플레이스 URL 또는 설치되지만 나타나지 않는 플러그인)의 경우 [플러그인 문제 해결](https://code.claude.com/docs/ko/plugins/troubleshooting.md)을 참조하십시오.

### plugin eval is currently in early access

[`claude plugin eval`](https://code.claude.com/docs/ko/plugin-evals) 또는 `claude plugin eval init`을 실행했으며 아무것도 수행하기 전에 다음 메시지 중 하나와 함께 종료 코드 1로 종료되었습니다:

```text theme={null}
`plugin eval` is currently in early access
```

```text theme={null}
`plugin eval` is currently unavailable
```

첫 번째 메시지는 빌드가 v2.1.269보다 오래되었음을 의미합니다. v2.1.269는 명령이 일반적으로 사용 가능한 첫 번째 버전입니다. 두 번째 메시지는 Anthropic이 서버 측에서 명령을 비활성화했음을 의미합니다. 머신의 아무것도 이를 다시 켤 수 없습니다.

**수행할 작업:**

* `claude --version`을 실행한 다음 `claude update`를 실행하고 새 세션에서 명령을 다시 실행하십시오. [플러그인 평가 요구 사항](https://code.claude.com/docs/ko/plugin-evals.md#requirements)을 참조하십시오.
* 현재 빌드에서 두 번째 메시지가 표시되면 다른 `claude update` 후 나중에 다시 시도하십시오.

### Marketplace is registered from an untrusted source

마켓플레이스가 [공식 Anthropic 마켓플레이스용으로 예약된](https://code.claude.com/docs/ko/plugins/marketplace-reference.md#marketplace-file) 이름으로 등록되어 있지만 등록된 소스가 `anthropics` GitHub 저장소가 아닙니다. Claude Code는 마켓플레이스를 로드하거나 새로 고칠 때마다 예약된 이름을 다시 확인하므로 마켓플레이스와 여기서 설치된 플러그인이 로드되지 않습니다. v2.1.205 이전에는 이름이 예약되기 전에 등록된 항목이 계속 로드되었습니다.

```text theme={null}
Marketplace "claude-community" is registered from an untrusted source: The name 'claude-community' is reserved for official Anthropic marketplaces. Only repositories from 'github.com/anthropics/' can use this name. To fix it, remove the marketplace and re-add it from the official source.
```

소스가 GitHub 저장소 또는 Git URL이 아닌 마켓플레이스(예: 로컬 디렉터리)의 경우 중간 문장은 `can only be used with GitHub sources from the 'anthropics' organization` 대신 읽습니다. `claude plugin marketplace add`는 동일한 확인을 실행하며 예약된 이름을 `Failed to add marketplace:` 다음에 동일한 예약된 이름 문장으로 거부합니다.

**수행할 작업:**

* 마켓플레이스가 이미 등록된 경우 `claude plugin marketplace remove <name>`을 실행한 다음 공식 `github.com/anthropics` 저장소에서 다시 추가하십시오.
* 이름이 예약되기 전에 이름을 사용한 타사 마켓플레이스를 게시하는 경우 이름을 바꾸고 사용자에게 소스에서 다시 추가하도록 요청하십시오.
* [마켓플레이스 스키마](https://code.claude.com/docs/ko/plugins/marketplace-reference.md#marketplace-file)에서 예약된 이름 목록을 참조하십시오.

### Marketplace name is another spelling of a reserved name

마켓플레이스의 이름 자체는 예약된 이름이 아니지만 Claude Code는 이를 예약된 이름의 다른 철자로 취급합니다. [예약된 이름](https://code.claude.com/docs/ko/plugins/marketplace-reference.md#reserved-name-spellings)은 어떤 철자가 예약된 이름으로 간주되는지 나열합니다. Claude Code는 마켓플레이스를 추가할 때 이러한 이름을 거부합니다:

```text theme={null}
Failed to add marketplace: "claude.code.plugins" is another spelling of "claude-code-plugins", a reserved marketplace name.
```

마켓플레이스가 이미 이러한 이름으로 등록된 경우 해당 항목이 로드되지 않으며 `/plugin`, `claude plugin install` 및 `claude plugin update`는 경고합니다:

```text wrap theme={null}
known_marketplaces.json has an entry named "claude.code.plugins", another spelling of the reserved marketplace name "claude-code-plugins", so it is ignored. Remove it with: claude plugin marketplace remove claude.code.plugins
```

이름에 셸 인용이 필요한 경우 추가 시간 거부는 `This marketplace's name is another spelling of "<reserved>", a reserved marketplace name. It is not exactly the reserved name it appears to be.`로 읽습니다.

**수행할 작업:**

* 마켓플레이스의 이름을 예약된 이름의 철자를 지정하지 않는 이름으로 바꾸고 다시 추가하십시오.
* 무시된 항목 경고의 경우 제공하는 `claude plugin marketplace remove` 명령을 실행하거나 `~/.claude/plugins/known_marketplaces.json`에서 항목을 제거하십시오.

### Claude Code refuses the marketplace name

등록된 마켓플레이스의 이름이 [공식 Anthropic 마켓플레이스를 사칭합니다](https://code.claude.com/docs/ko/plugins/marketplace-reference.md#reserved-names). 해당 섹션에 나열된 규칙에 따릅니다.

마켓플레이스가 확인이 이를 차단하기 전에 이러한 이름으로 등록된 경우 마켓플레이스와 여기서 설치된 플러그인이 로드되지 않습니다. Claude Code는 마켓플레이스의 카탈로그를 읽을 때마다 이름을 확인하기 때문입니다. 이름이 공식 이름을 모방할 때 `claude plugin list` 및 `/plugin` **오류** 탭은 다음과 같이 시작하는 메시지와 함께 영향을 받는 각 플러그인을 보고합니다:

```text theme={null}
Claude Code refuses the marketplace name "anthropic-plugins-v2"
```

모방하는 이름의 경우 마켓플레이스 자체의 오류는 `Claude Code refuses this marketplace's name: it looks like one of Anthropic's own` 대신 읽습니다. `claude plugin marketplace add`는 모든 사칭 이름을 `Marketplace name impersonates an official Anthropic/Claude marketplace`로 거부합니다.

v2.1.282 이전에는 `claude plugin list` 및 `/plugin`이 모방하는 이름의 플러그인을 마켓플레이스의 이름을 원인으로 명명하지 않고 로드 실패로 보고했습니다.

**수행할 작업:**

* 설정 파일이 `"source": "settings"`로 인라인 선언한 마켓플레이스를 유지하려면 이전 이름을 제거하기 전에 이름을 바꾸십시오. 마켓플레이스를 제거하면 설정 파일에서도 해당 항목이 삭제되기 때문입니다. Claude Code v2.1.292 이상에서는 메시지에 다음 단계가 나열됩니다:
  1. `extraKnownMarketplaces` 아래에 마켓플레이스를 나열하는 각 설정 파일에서 항목의 키와 해당 `source.name`에 공식 이름처럼 보이지 않는 새로운 일반 ASCII 이름 하나를 지정하십시오. 관리자가 조직의 관리형 설정을 통해 마켓플레이스를 추가하는 경우 이 단계는 관리자가 수행합니다.
  2. `claude plugin marketplace remove <old-name>`을 실행하거나 `/plugin`의 **마켓플레이스** 탭에서 이전 이름을 제거하십시오. 이렇게 하면 해당 플러그인도 제거되고 그 데이터, 옵션 및 비밀이 삭제됩니다.
  3. Claude Code를 다시 시작하십시오. 파일이 프로젝트의 설정 파일인 경우 해당 프로젝트 폴더에서 시작하십시오. 그런 다음 이름이 바뀐 마켓플레이스에서 플러그인을 설치하십시오.
* 다른 마켓플레이스를 유지하려면 유지 관리자가 이름을 바꿀 때까지 기다린 다음 `claude plugin marketplace update <name>`을 실행하십시오.
* 마켓플레이스를 제거하려면 `claude plugin marketplace remove <name>`을 실행하십시오. 이렇게 하면 마켓플레이스에서 설치된 플러그인도 제거되고 그 데이터, 옵션 및 비밀이 삭제됩니다.
* 마켓플레이스를 게시하는 경우 `marketplace.json`에서 이름을 바꾸십시오. 사용자는 제거하는 대신 마켓플레이스를 업데이트합니다.

### Marketplace is already added from a different source

세션 또는 셸에서 [설치 명령의 `--marketplace <source>`](https://code.claude.com/docs/ko/plugins/install#add-a-marketplace-and-install-in-one-command)로 새 마켓플레이스 소스를 지정했습니다. Claude Code가 해당 소스에서 가져온 카탈로그의 이름이 이미 다른 소스에서 추가한 마켓플레이스의 이름과 같습니다. Claude Code는 기존 마켓플레이스를 대체하지 않고 유지하며, 플러그인은 설치되지 않습니다.

```text theme={null}
Marketplace "acme-tools" is already added from a different source (github:acme/plugins). To use this source instead, remove that marketplace first with /plugin marketplace remove acme-tools.
```

**수행할 작업:**

* 이미 추가한 마켓플레이스가 원하는 마켓플레이스인 경우 이름으로 설치하십시오: `/plugin install <plugin>@<name>`
* 새 소스로 전환하려면 `/plugin marketplace remove <name>`을 실행한 다음 설치를 다시 시도하십시오.

### Plugin command references user\_config in a shell command

플러그인 훅, [모니터](https://code.claude.com/docs/ko/plugins/components.md#monitors) 또는 MCP [`headersHelper`](https://code.claude.com/docs/ko/mcp#use-dynamic-headers-for-custom-authentication) 명령이 `${user_config.KEY}` [플러그인 옵션](https://code.claude.com/docs/ko/plugins/manifest-reference.md#user-configuration)을 참조하며 대체된 문자열이 셸에 전달됩니다. 구성된 값에 `$(...)`, 백틱 또는 `;`이 포함되면 여기서 코드로 실행되므로 Claude Code는 값을 대체하는 대신 구성 요소를 시작하기를 거부합니다. 확인은 명령 템플릿에서 실행되므로 아직 값이 구성되지 않았을 때도 오류가 나타납니다. v2.1.207 이전에는 값이 셸 명령으로 대체되었습니다.

표현은 어느 사용 환경이 옵션을 참조했는지에 따라 다릅니다. 셸 형식 훅은 다음을 보고합니다:

```text theme={null}
Hook from plugin formatter@acme-tools references ${user_config.*} in a shell-form command. The substituted value would be re-parsed by the shell. Use exec form instead — {"command": "<executable>", "args": ["${user_config.KEY}", ...]} — or read $CLAUDE_PLUGIN_OPTION_<KEY> from the hook's environment. Command: ./scripts/notify.sh ${user_config.webhook_url}
```

모니터는 다음을 보고합니다:

```text theme={null}
Monitor "deploy-status" from plugin deploy-tools references ${user_config.*} in its command. The substituted value would be passed to a shell. Monitor commands cannot safely reference ${user_config.*}; have the monitor script read the value from a config file or prompt instead.
```

MCP `headersHelper`는 다음을 보고합니다:

```text theme={null}
headersHelper for MCP server 'internal-api' references ${user_config.*}. The substituted value would be passed to a shell; read the value inside the helper script instead (e.g. from an env var set in the server's "env" block).
```

**수행할 작업:**

* 훅의 경우 `args` 배열을 추가하여 [exec 형식](https://code.claude.com/docs/ko/hooks.md#exec-form-and-shell-form)에서 실행되도록 하십시오. 여기서 각 `${user_config.KEY}`는 그 사이에 셸이 없는 하나의 인수가 됩니다. 또는 참조를 제거하고 스크립트 내에서 `$CLAUDE_PLUGIN_OPTION_<KEY>` 환경 변수를 읽으십시오.
* 모니터의 경우 참조를 제거하고 모니터 스크립트가 구성 파일에서 값을 읽도록 하십시오.
* `headersHelper`의 경우 `${user_config.KEY}`를 셸 구문 분석되지 않는 서버의 `headers` 필드로 이동하거나 헬퍼 스크립트 내에서 값을 읽으십시오.

### Plugin archive integrity check failed

플러그인의 마켓플레이스 항목이 `sha256` 핀이 있는 [`archive` 소스](https://code.claude.com/docs/ko/plugins/marketplace-reference#archive-plugin-source)를 사용하며 다운로드된 파일의 다이제스트가 핀과 일치하지 않습니다. Claude Code는 설치를 거부하므로 플러그인 캐시에서 아무것도 변경되지 않습니다. 불일치에는 세 가지 가능한 원인이 있습니다:

* 작성자가 핀을 계산한 후 URL의 파일이 변경됨
* 작성자가 마켓플레이스 항목에 잘못된 다이제스트를 입력함
* URL이 작성자가 핀한 파일과 다른 파일을 제공함

```text theme={null}
Plugin archive integrity check failed for https://artifacts.example.com/claude-plugins/my-plugin.zip: expected sha256 6bfa50e3d2e00c052b46abe51fff89346ac803e45771f76dcf6df1ab74cca5e1, got ac52220c0914ef8ca6a602e4a7362f88d30fb021110f72a6d15b68c3fe7df2b7. The archive was not installed. Verify the sha256 in the marketplace entry, or that the URL serves the intended file.
```

**수행할 작업:**

* 플러그인을 게시하는 경우 URL이 제공하는 정확한 파일의 다이제스트를 다시 계산하십시오. 예를 들어 `shasum -a 256 my-plugin.zip` 또는 PowerShell에서 `Get-FileHash -Algorithm SHA256 my-plugin.zip`을 사용하고 마켓플레이스 항목의 `sha256`을 업데이트하십시오.
* 플러그인을 설치하는 경우 `/plugin marketplace update <name>`을 실행하여 항목이 수정된 경우 카탈로그를 새로 고친 다음 설치를 다시 시도하십시오.
* 새로 고침 후에도 다이제스트가 계속 불일치하면 설치하기 전에 마켓플레이스 소유자에게 어떤 파일을 핀했는지 물어보십시오.

### Path escapes plugin directory

플러그인의 구성 요소 경로 중 하나가 플러그인 디렉터리 외부로 이어지거나 플러그인 내부에 있는지 확인할 수 없으므로 Claude Code는 해당 경로를 삭제하고 플러그인의 나머지 부분을 로드합니다. 플러그인이 `plugin.json` 또는 [마켓플레이스 항목](https://code.claude.com/docs/ko/plugins/marketplace-reference.md#plugin-entries)에서 선언한 경로의 경우 메시지의 구성 요소 이름(예: `commands` 또는 `hooks`)은 경로를 선언한 필드의 이름을 지정합니다.

```text theme={null}
commands path escapes plugin directory: ./../shared.md
```

`claude plugin` 명령 출력에서 동일한 오류는 `Path escapes plugin directory: ./../shared.md (commands)`로 읽습니다.

Claude Code는 `../shared-utils`와 같이 플러그인 외부를 가리키는 경로와 [마켓플레이스 심볼릭 링크 규칙](https://code.claude.com/docs/ko/plugins/host-marketplace.md#share-files-within-a-marketplace-with-symlinks)이 허용하지 않는 플러그인 외부로 이어지는 심볼릭 링크를 모두 거부합니다. 심볼릭 링크의 경우 메시지는 경로가 확인되는 위치도 표시합니다:

```text theme={null}
commands path escapes plugin directory: ./commands/deploy.md — it resolves to /home/user/shared/deploy.md, outside the plugin directory
```

마켓플레이스 플러그인 자체 파일 중 하나(예: `hooks/hooks.json`)의 전체 경로를 제공하는 메시지는 Claude Code가 해당 파일을 건너뛰었음을 의미합니다. 이는 Claude Code가 파일이 플러그인 내부에 있는지, 또는 [로컬 마켓플레이스](https://code.claude.com/docs/ko/plugins/loading.md#in-place-and-copied-plugins)의 플러그인의 경우 해당 마켓플레이스 내부에 있는지 확인할 수 없을 때 발생합니다. 메시지는 이러한 각 파일을 다음 구성 요소 이름으로 보고합니다:

* `hooks/hooks.json`: `hooks`
* `monitors/monitors.json`: `monitors`
* `settings.json`: `settings`
* 플러그인 루트의 `SKILL.md`: `skills`

예를 들어 이 메시지는 플러그인과 해당 로컬 마켓플레이스 모두의 외부로 확인되는 `hooks/hooks.json`에 대한 것입니다:

```text theme={null}
hooks path escapes plugin directory: /home/user/my-marketplace/my-plugin/hooks/hooks.json — it resolves to /home/user/dotfiles/hooks.json, outside the plugin directory and its marketplace directory
```

macOS 및 Linux에서 Claude Code는 경로가 플러그인 내부에 머물러 있을 때도 경로의 어디든지 백슬래시를 포함하는 구성 요소 경로를 거부합니다. 구성 요소 경로가 Windows 스타일 구분 기호를 사용하는 플러그인은 Windows에서 로드되고 다른 플랫폼에서 이 거부를 트리거합니다:

```text theme={null}
commands path escapes plugin directory: ./commands\deploy.md — its path contains a backslash, which is not resolved reliably on this platform
```

v2.1.251 이전에는 Claude Code가 마켓플레이스 항목에서 선언된 `commands` 경로를 플러그인 디렉터리 외부를 가리킬 때도 로드했습니다.

v2.1.257 이전에는 플러그인이 선언한 경로에 대한 확인이 경로의 철자만 보았으며 심볼릭 링크가 이어지는 위치는 보지 않았습니다.

**수행할 작업:**

* 플러그인을 설치했지만 유지 관리하지 않는 경우 메시지를 작성자에게 보고하십시오.
* 플러그인이 선언한 경로의 경우 참조된 파일을 플러그인 디렉터리 내부로 이동하고 `./` 상대 경로로 경로를 가리키십시오.
* 경로 또는 플러그인 내부에서 그 위에 있는 폴더가 플러그인 외부로 이어지는 심볼릭 링크인 경우 심볼릭 링크를 그것이 가리키는 대상의 복사본으로 바꾸십시오.
* 메시지가 플러그인이 선언한 경로에 백슬래시가 포함되어 있다고 말하면 경로를 정방향 슬래시로 작성하십시오. 예를 들어 `./commands/deploy.md`
* 메시지가 `EACCES`로 끝나면 경로가 지정하는 파일 또는 폴더로 이어지는 모든 디렉터리에 대한 실행 권한을 복원하십시오. 경로 위의 디렉터리를 확인한 다음 도달하는 각 심볼릭 링크를 따라가 그것이 가리키는 위치로 이어지는 디렉터리를 확인하십시오. 다른 오류 코드의 경우 [확인할 수 없는 경로의 원인 및 단계](#path-could-not-be-checked)에서 찾아보십시오.
* 동일한 마켓플레이스의 다른 플러그인과 파일을 공유하려면 플러그인 디렉터리 내의 심볼릭 링크로 연결하고 [심볼릭 링크 규칙](https://code.claude.com/docs/ko/plugins/host-marketplace.md#share-files-within-a-marketplace-with-symlinks)을 따르십시오.

### Plugin not loaded: its manifest was not read

Claude Code는 `.claude-plugin/plugin.json`에 있는 마켓플레이스 플러그인의 [매니페스트](https://code.claude.com/docs/ko/plugins/manifest-reference.md)가 플러그인 내부에 있는지 확인할 수 없었으므로 해당 플러그인에서 아무것도 로드하지 않습니다. [로컬 마켓플레이스](https://code.claude.com/docs/ko/plugins/loading.md#in-place-and-copied-plugins)의 플러그인의 경우 Claude Code는 매니페스트가 해당 마켓플레이스 내부에 있는지도 확인할 수 없었습니다. 메시지는 `/plugin` **오류** 탭에 나타나며, 끝부분의 이유는 Claude Code가 발견한 내용을 알려 줍니다.

예를 들어 이 메시지는 `.claude-plugin` 폴더가 마켓플레이스 외부로 이어지는 심볼릭 링크인 로컬 마켓플레이스의 플러그인에 대한 것입니다:

```text theme={null}
Plugin not loaded: its manifest /home/user/my-marketplace/my-plugin/.claude-plugin/plugin.json was not read, because it resolves to /home/user/dotfiles/my-plugin/.claude-plugin/plugin.json, outside the plugin directory and its marketplace directory
```

**수행할 작업:**

* 이유가 `EACCES`로 끝나면 매니페스트로 이어지는 모든 디렉터리에 대한 실행 권한을 복원하십시오. 매니페스트 위의 디렉터리를 확인한 다음 도달하는 각 심볼릭 링크를 따라가 그것이 가리키는 위치로 이어지는 디렉터리를 확인하십시오. 다른 오류 코드의 경우 [확인할 수 없는 경로의 원인 및 단계](#path-could-not-be-checked)에서 찾아보십시오.
* 플러그인을 유지 관리하고 있으며 이유에 매니페스트가 확인되는 위치가 표시되어 있다면 `.claude-plugin` 폴더 또는 `plugin.json` 자체가 그 위치로 이어지는 심볼릭 링크입니다. 해당 링크를 그것이 가리키는 대상의 복사본으로 바꾸십시오.
* 플러그인을 설치했지만 유지 관리하지 않는 경우 메시지를 작성자에게 보고하십시오.

### Path could not be checked

Claude Code는 플러그인 경로가 존재하는지 운영 체제에 물었고 "찾을 수 없음" 이외의 오류를 받았으므로 경로가 이름을 지정하는 것을 로드하지 않습니다. 플러그인의 얼마나 많은 부분이 로드되는지는 어느 경로가 실패했는지에 따라 다릅니다:

* 플러그인의 [기본 구성 요소 위치](https://code.claude.com/docs/ko/plugins/manifest-reference.md#standard-layout) 중 하나(예: `skills/` 폴더, `monitors/monitors.json` 파일 또는 [플러그인 루트의 `SKILL.md`](https://code.claude.com/docs/ko/plugins/components#skills)): 플러그인의 다른 구성 요소는 여전히 로드됨
* 플러그인의 자체 디렉터리: 해당 플러그인에서 아무것도 로드되지 않음

전혀 존재하지 않는 경로에 대해서는 이 오류가 표시되지 않습니다. `/plugin`에서 오류는 플러그인 아래에 나타나고 경로와 운영 체제가 반환한 코드의 이름을 지정합니다:

```text theme={null}
skills path could not be checked: /home/user/my-plugin/skills (ELOOP)
```

`claude plugin list`에서 동일한 오류는 `Path not found: /home/user/my-plugin/skills (skills, ELOOP)`로 읽습니다.

이 오류를 생성하는 원인은 다음을 포함합니다:

* `ELOOP`: 경로의 심볼릭 링크가 자신을 가리키거나 루프를 형성함
* `EIO` 또는 `ESTALE`: 경로가 끊어지거나 오래된 네트워크 마운트에 있음
* `EACCES`: 경로 위의 디렉터리 중 하나가 이를 통과할 권한을 거부함

**수행할 작업:**

* 자신을 가리키는 심볼릭 링크를 실제 폴더로 바꾸거나 삭제하십시오.
* 경로가 네트워크 마운트에 있으면 공유를 다시 마운트하십시오.
* 코드가 `EACCES`이면 경로 위의 디렉터리에 대한 실행 권한을 복원하십시오.
* 경로를 수정한 후 `/reload-plugins`을 실행하거나 Claude Code를 다시 시작하여 플러그인 또는 구성 요소를 로드하십시오.

v2.1.265 이전에는 Claude Code가 확인할 수 없는 기본 구성 요소 폴더를 없는 것으로 취급하고 오류 없이 해당 구성 요소 없이 플러그인을 로드했습니다.

### Marketplace entry path does not stay inside the marketplace directory

플러그인의 [마켓플레이스 항목](https://code.claude.com/docs/ko/plugins/marketplace-reference.md#plugin-entries)이 Claude Code가 마켓플레이스의 자체 디렉터리 내부의 위치로 확인할 수 없는 소스 경로를 선언하므로 플러그인이 설치되거나 로드되지 않습니다. 거부는 다음을 포함합니다:

* 절대 경로, `..`로 마켓플레이스를 벗어나거나 네트워크 경로처럼 철자된 항목 경로
* macOS 및 Linux에서 선행 `./` 이후 어디든지 백슬래시를 포함하는 항목 경로
* git 또는 URL과 같은 원격 소스에서 가져온 마켓플레이스의 항목이 마켓플레이스 디렉터리 외부로 확인되는 심볼릭 링크를 통해 대상에 도달함
* 마켓플레이스의 `marketplace.json`에 대한 직접 URL에서 추가된 마켓플레이스의 상대 항목: Claude Code는 해당 파일만 다운로드하므로 경로가 이름을 지정할 로컬 플러그인 파일이 없습니다. [URL 기반 마켓플레이스에서 상대 경로가 있는 플러그인 실패](https://code.claude.com/docs/ko/plugins/troubleshooting.md#plugins-with-relative-paths-fail-in-url-based-marketplaces)를 참조하십시오.

`claude plugin install`은 다음과 같이 거부를 보고합니다:

```text theme={null}
Cannot install my-plugin@my-marketplace: its marketplace entry path does not stay inside the marketplace directory (an absolute, climbing, network-shaped, backslash-containing or link-traversing entry, an entry of a fetched marketplace that resolves or opens outside its tree — or a relative entry in a url-catalog marketplace, which has no local directory)
```

이미 설치된 플러그인의 항목이 동일한 확인에 실패하면 `claude plugin list`는 플러그인을 `failed to load`로 표시합니다:

```text theme={null}
Plugin source path refused: ./my-plugin does not stay inside its marketplace directory. Check that the marketplace entry has a plain relative path.
```

**수행할 작업:**

* 마켓플레이스를 유지하는 경우 항목의 `source`를 `./plugins/my-plugin`과 같은 일반 상대 경로로 작성하고 이를 통과하는 모든 심볼릭 링크가 마켓플레이스 디렉터리 내부를 가리키도록 하십시오.
* 마켓플레이스를 직접 URL에서 추가한 경우 상대 항목을 확인할 수 없습니다. 마켓플레이스 작성자에게 [다른 플러그인 소스](https://code.claude.com/docs/ko/plugins/marketplace-reference.md#plugin-sources)를 사용하도록 요청하거나 git 저장소에서 마켓플레이스를 추가하십시오.

### Failed to load marketplace configuration

Claude Code는 `~/.claude/plugins/known_marketplaces.json`의 레지스트리 파일에 추가한 플러그인 마켓플레이스를 유지합니다. `claude plugin install`과 같이 레지스트리가 필요한 플러그인 명령은 Claude Code가 파일을 사용할 수 없을 때 두 가지 메시지 중 하나로 실패합니다:

* `Failed to load marketplace configuration`: 파일이 존재하지만 유효한 JSON이 아니거나 읽을 수 없습니다. 빈 파일도 이런 식으로 실패합니다.
* `Marketplace configuration file is corrupted`: 파일이 유효한 JSON이지만 내용이 레지스트리 스키마와 일치하지 않습니다.

빈 파일의 경우 `claude plugin install`은 다음을 보고합니다:

```text theme={null}
✘ Failed to install plugin "my-plugin": Failed to load marketplace configuration: JSON Parse error: Unexpected EOF
```

v2.1.246 이전에는 `claude plugin install`이 이 실패를 보고하지 않았습니다.

**수행할 작업:**

* `~/.claude/plugins/known_marketplaces.json`을 열고 JSON을 복구하거나 메시지가 레지스트리 스키마와 일치하지 않는 것으로 이름을 지정한 항목을 수정하십시오.
* 복구할 수 없으면 파일을 삭제하거나 내용을 `{}`로 바꾼 다음 `claude plugin marketplace add <source>`로 각 마켓플레이스를 다시 추가하십시오. Claude Code는 신뢰한 폴더에서 다음에 시작할 때 사용자 또는 관리형 설정이 [`extraKnownMarketplaces`](https://code.claude.com/docs/ko/settings-reference#extraknownmarketplaces)에서 선언한 마켓플레이스를 다시 등록합니다.

### Plugin is required by your organization

`claude plugin disable`을 실행했거나 `/plugin` **설치됨** 탭을 사용하여 조직이 필수로 표시한 [claude.ai에서 동기화된](https://code.claude.com/docs/ko/plugins/loading.md#synced-plugins) 플러그인을 비활성화하려고 했습니다:

```text theme={null}
Plugin "<name>@synced" is required by your organization and can't be disabled here. Contact your admin to change it.
```

Claude Code는 아무것도 저장하지 않으며 플러그인은 활성화된 상태로 유지됩니다.

필수 플러그인이 의존하는 플러그인을 비활성화하려고 하면 Claude Code는 필수 플러그인이 필요로 하는 플러그인의 이름을 지정하는 메시지와 함께 동일한 방식으로 거부합니다.

**수행할 작업:**

* claude.ai 조직의 관리자에게 claude.ai에서 플러그인의 필수 상태를 변경하도록 요청하십시오.

### Plugin was not uninstalled

[`claude plugin uninstall`](https://code.claude.com/docs/ko/plugins/cli-reference#plugin-uninstall)을 실행했거나 `/plugin` **설치됨** 탭에서 **제거**를 선택했으며 제거가 `"<plugin>" was not uninstalled:`로 시작하는 메시지와 함께 중지되었습니다. 그 뒤의 텍스트가 설정 파일 이름을 지정하는 대신 `installed_plugins.json`으로 시작하면 원인은 이 버전의 Claude Code가 읽을 수 없는 `installed_plugins.json`의 내용입니다. 해당 형식의 경우 [`installed_plugins.json` holds a record this version can't read](https://code.claude.com/docs/ko/plugins/troubleshooting#installed-plugins-json-holds-a-record-this-version-cannot-read)를 참조하십시오.

Claude Code가 `enabledPlugins`에서 플러그인의 항목을 제거하고 해당 범위의 설정 파일을 다시 읽었을 때 플러그인이 여전히 켜져 있었거나 이를 켤 수 있는 파일을 읽거나 확인할 수 없었습니다. 설정 항목이 이를 다시 켤 수 있는 동안 플러그인의 저장된 옵션, 비밀 및 데이터를 삭제하면 이를 잃게 되므로 제거가 대신 중지됩니다: 플러그인은 설치된 상태로 유지되고 저장된 것은 삭제되지 않습니다.

```text theme={null}
✘ Failed to uninstall plugin "formatter": "formatter" was not uninstalled: it is still switched on in /home/user/project/.claude/settings.local.json, although the settings change reported no error. It is still installed. Take it out of "enabledPlugins" in that file yourself, then uninstall it again.
```

메시지의 중간 부분은 파일과 원인의 이름을 지정합니다:

* `it is still switched on in <file>, although the settings change reported no error`: 설정 쓰기가 성공을 보고했지만 파일을 읽을 때 항목이 여전히 있음
* `it is still switched on in <file>, and the settings change failed (<error>)`: 파일을 저장할 수 없음. 괄호 안의 이유
* `<file> is there and could not be read`: 파일이 존재하지만 설정으로 읽을 수 없음. 예를 들어 유효한 JSON이 아니므로 플러그인을 여전히 활성화할 수 있음
* `<file> (not read: it is on a network path or is a link to one, or could not be checked)`: Claude Code가 프로젝트 또는 로컬 설정 파일을 읽지 않았습니다. 파일 또는 이를 보유한 `.claude` 폴더가 네트워크 위치로 이어지는 링크이거나 해당 경로를 검사할 수 없기 때문입니다.

`claude plugin uninstall`은 종료 코드 1로 종료되며 `--json`을 사용하면 결과는 `failureCode: "settings_still_on"`을 전달합니다. `/plugin`은 동일한 메시지를 표시합니다.

**수행할 작업:**

* 메시지의 마지막 문장을 따르십시오: 이를 명명한 설정 파일을 복구하거나 바꾸거나 해당 파일의 `enabledPlugins`에서 플러그인의 항목을 직접 제거한 다음 제거를 다시 실행하십시오.

### Skipping connection (recent failure cached; retries automatically in 15 min, or edit the plugin config to retry now)

이 메시지는 해당 서버에 대한 연결이 15분 이내에 실패했기 때문에 Claude Code가 [플러그인이 제공하는 stdio MCP 서버](https://code.claude.com/docs/ko/mcp.md#plugin-provided-mcp-servers)를 시작하지 않았음을 의미합니다:

```text theme={null}
Skipping connection (recent failure cached; retries automatically in 15 min, or edit the plugin config to retry now)
```

세션은 서버의 도구 없이 계속되며, 15분이 지나도 Claude Code는 해당 세션에서 서버를 다시 시도하지 않습니다. 가장 최근의 연결 실패로부터 15분 이상 지난 후 새 세션 또는 [`claude -p`](https://code.claude.com/docs/ko/headless) 실행을 시작하면 Claude Code가 서버를 다시 시도합니다.

**수행할 작업:**

기다리지 않고 Claude Code가 서버를 다시 시도하도록 하려면:

* **대화형 세션에서**: `/mcp`를 실행하고 서버를 선택한 다음 **Reconnect**를 선택하십시오.
* **[Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 애플리케이션에서**: 서버 이름과 함께 TypeScript에서는 [`reconnectMcpServer()`](https://code.claude.com/docs/ko/agent-sdk/typescript#methods)를, Python에서는 [`ClaudeSDKClient.reconnect_mcp_server()`](https://code.claude.com/docs/ko/agent-sdk/python#methods)를 호출하십시오.
* **`claude -p`에서**: 실행 시와 동일한 머신에서 동일한 운영 체제 계정과 동일한 [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars) 값으로 같은 플러그인을 로드하는 대화형 세션을 시작하십시오. 그곳에서 `/mcp`를 통해 서버를 다시 연결하십시오. 연결되면 Claude Code는 다음 실행에서 연결을 시도합니다.
* **플러그인을 개발하는 경우**: 플러그인의 `.mcp.json` 또는 `plugin.json`에서 서버의 `command`, `args` 또는 `env`를 변경하십시오. Claude Code는 변경된 항목을 로드하는 다음 세션 또는 `claude -p` 실행에서 연결을 시도합니다.

이 메시지는 실패한 연결의 오류를 대체합니다. 새 시도도 실패하면 Claude Code는 이 메시지 대신 해당 시도의 오류를 보고합니다.

## 도구 오류

이 오류들은 Claude의 도구 호출에서 발생합니다. 대부분의 도구 오류는 Claude가 스스로 수정합니다. 사용자가 무언가를 변경해야 하는 경우에는 해당 오류의 **조치 방법** 목록에 변경할 내용이 안내되어 있습니다.

### No such tool available

Claude가 세션의 도구 목록에 없는 이름으로 도구를 호출했습니다. Claude Code는 이 오류를 도구 호출의 결과로 Claude에 반환하며, 턴은 계속 진행됩니다. Claude Code가 도구가 없는 이유를 파악할 수 있는 경우에는 두 번째 줄처럼 도구 이름 뒤에 이유를 설명하거나 대신 호출할 도구를 알려 주는 문장을 덧붙입니다.

```text theme={null}
Error: No such tool available: <tool name>
Error: No such tool available: read. Tool names are case-sensitive: call Read instead.
```

세션을 재개한 직후에는 Claude가 MCP 서버의 도구를 호출할 때 해당 서버가 아직 첫 번째 연결을 시도하는 중일 수 있습니다. 이 경우 Claude Code는 [서버를 기다리며](https://code.claude.com/docs/ko/mcp.md#tool-availability), 대기가 끝났을 때도 도구를 사용할 수 없으면 이 오류를 반환합니다. v2.1.284 이전에는 이러한 호출이 기다리지 않고 즉시 실패했습니다.

Claude Code가 도구 이름을 [200자로 잘라낸](#tool-use-name-over-200-characters) 호출도 이 오류로 실패합니다.

**조치 방법:**

* 한 번만 발생했다면 별도로 조치할 필요가 없습니다. Claude가 오류를 읽고 턴이 계속 진행됩니다.
* MCP 서버의 도구 호출이 이 오류로 계속 실패한다면 세션에서 `/mcp`를 실행하거나 셸에서 `claude mcp list`를 실행하여 서버의 [상태](https://code.claude.com/docs/ko/mcp.md#server-status)를 확인하고, 실패한 서버는 `/mcp`에서 다시 연결합니다. Agent SDK에서는 [오류 처리](https://code.claude.com/docs/ko/agent-sdk/mcp.md#error-handling)를 참조하세요.

### MCP server connection closed before the tool call was answered

HTTP [MCP 서버](https://code.claude.com/docs/ko/mcp.md) 또는 [claude.ai 커넥터](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai)에 대한 도구 호출이 서버가 응답하기 전에 연결이 끊겼기 때문에, Claude Code는 도구가 실행되었는지 알 수 없습니다.

```text theme={null}
MCP server "<name>" connection closed before the tool call was answered. The tool may have run: check whether it did before running it again.
```

호출을 반복하면 두 번째 이슈를 생성하는 것처럼 도구의 작업이 반복될 수 있습니다. 따라서 Claude Code는 서버가 해당 도구를 반복해도 안전한 것으로 표시한 경우에만 호출을 스스로 한 번 반복합니다.

**조치 방법:**

* 도구가 작업하는 서비스에서 작업이 실행되었는지 확인합니다. 예를 들어 생성하려던 이슈나 레코드가 있는지 확인합니다
* 작업이 실행되었다면 도구를 다시 실행하지 마세요. Claude는 도구의 결과 대신 이 메시지를 받았으므로 Claude에게 결과를 알려 줍니다.
* 작업이 실행되지 않았다면 Claude에게 도구를 다시 실행하도록 요청합니다. Claude Code가 해당 서버의 도구를 다음에 호출할 때 다시 연결하므로 서버를 먼저 다시 연결할 필요는 없습니다. 그 연결도 실패한다면 [원격 서버의 세션 중 연결 끊김](https://code.claude.com/docs/ko/mcp.md#mid-session-drops-of-a-remote-server)을 참조하세요.
* 서버를 직접 만들고 있고 해당 도구를 두 번 호출해도 안전하다면 Claude Code가 유실된 호출을 반복할 수 있도록 [반복해도 안전한 것으로 표시](https://code.claude.com/docs/ko/mcp.md#tool-calls-pending-when-a-connection-closes)합니다

### MCP server is disabled

도구 결과에 이 메시지가 표시되면 Claude가 [꺼져 있는](https://code.claude.com/docs/ko/mcp.md#disable-a-server-without-removing-it) [MCP 서버](https://code.claude.com/docs/ko/mcp.md)의 도구를 호출했다는 뜻입니다. Claude Code는 서버에 연결하지 않았으므로 도구는 실행되지 않았고, Claude는 결과 대신 다음 텍스트를 받았습니다.

```text wrap theme={null}
MCP server "<name>" is disabled — re-enable it via /mcp to use its tools
```

**조치 방법:**

* 의도적으로 서버를 끈 것이라면 별도로 조치할 필요가 없습니다
* Claude가 서버의 도구를 사용해야 한다면 Claude Code 프롬프트에서 `/mcp`로 서버를 다시 켭니다
* [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 애플리케이션에서는 TypeScript의 경우 `enabled`를 `true`로 설정하여 [`toggleMcpServer()`](https://code.claude.com/docs/ko/agent-sdk/typescript#togglemcpserver)를 호출하고, Python의 경우 `enabled`를 `True`로 설정하여 [`toggle_mcp_server()`](https://code.claude.com/docs/ko/agent-sdk/python#claudesdkclient)를 호출하여 서버를 다시 켭니다

### 서버의 질문에 답변이 없어 MCP 도구 호출이 시간 초과됨

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 [MCP 서버](https://code.claude.com/docs/ko/mcp.md)가 도구 호출 중에 [elicitation](https://code.claude.com/docs/ko/mcp.md#respond-to-mcp-elicitation-requests)을 통해 입력을 요청했으나, 답변이 오기 전에 호출의 시간 제한이 끝났습니다.

```text theme={null}
MCP server "<name>" tool "<tool>" timed out after <N>s. The server asked the user a question, and no answer came before the time limit. Do not call this tool again in this turn. Tell the user that the server's question got no answer, and wait for their reply.
```

v2.1.310 이전에는 결과가 `timed out after <N>s`로 끝났으며 질문에 대해서는 아무것도 언급하지 않았습니다.

**조치 방법:**

* 서버의 요청에 답변하는 [`Elicitation` 훅](https://code.claude.com/docs/ko/hooks#elicitation)을 설정합니다
* TypeScript Agent SDK 애플리케이션에서는 [`onElicitation`](https://code.claude.com/docs/ko/agent-sdk/typescript#options) 콜백이 제한 시간이 끝나기 전에 답변을 반환하도록 합니다
* 답변할 시간을 더 주려면 서버의 구성 항목에서 더 긴 [`timeout`](https://code.claude.com/docs/ko/mcp#time-limits-on-mcp-tool-calls)을 밀리초 단위로 설정합니다. 예를 들어 10분이라면 `"timeout": 600000`으로 설정합니다
* 대신 대화형 세션에서 작업을 실행하고 서버의 [대화 상자](https://code.claude.com/docs/ko/mcp.md#respond-to-mcp-elicitation-requests)에 직접 답변합니다

### Agent would be spawned with zero tools

서브에이전트의 [`tools` 목록](https://code.claude.com/docs/ko/sub-agents#supported-frontmatter-fields)에 있는 모든 항목이 사용 가능한 도구와 일치하지 않았기 때문에 Claude Code가 서브에이전트 실행을 거부했습니다. 도구가 없으면 서브에이전트는 아무 작업도 할 수 없습니다. 메시지는 항목을 문제 유형별로 분류합니다.

* **Unrecognized**: 항목이 어떤 도구 이름과도 일치하지 않습니다. 보통 `Grep`을 `Grpe`로 쓴 것과 같은 오타입니다.
* **Not available to subagents**: 항목이 실제 도구를 가리키지만 [서브에이전트가 사용할 수 없는](https://code.claude.com/docs/ko/sub-agents.md#available-tools) 도구입니다. 백그라운드 서브에이전트는 더 작은 내장 도구 세트를 유지하므로, 포그라운드 서브에이전트만 사용할 수 있는 항목은 서브에이전트가 기본값인 백그라운드에서 실행될 때 여기에 분류됩니다. `Agent`를 나열한 경우에는 메시지가 대신 다음 그룹에서 이를 보고합니다.
* **Matched no tools in this session**: 항목은 유효하지만 현재 세션에서 지금 일치하는 도구가 없습니다. 예를 들어 GitHub MCP 서버가 연결되지 않은 상태의 `mcp__github__*`나, [깊이 제한](https://code.claude.com/docs/ko/sub-agents.md#let-subagents-spawn-their-own-subagents)에 도달한 서브에이전트의 `Agent`가 여기에 해당합니다.

`tools` 필드를 생략하면 이 거부가 발생하지 않습니다. `tools` 목록을 비워 두거나 `disallowedTools`가 그 안의 모든 항목을 제거하는 경우에도 Claude Code는 거부를 건너뛰고 도구 없이 서브에이전트를 실행합니다.

v2.1.208 이전에는 서브에이전트가 도구 없이 실행되어 빈 결과나 혼란스러운 결과를 반환할 수 있었습니다.

```text theme={null}
Agent 'code-reviewer' would be spawned with zero tools — refusing. Its tools list resolved to nothing: unrecognized [Grpe]. Fix the agent's tools frontmatter or pass a different subagent_type.
```

**조치 방법:**

* 오류가 지목한 각 항목을 [서브에이전트가 사용할 수 있는 도구](https://code.claude.com/docs/ko/sub-agents.md#available-tools)와 대조하여 수정합니다
* 연결되지 않은 서버의 MCP 도구처럼 세션에 없는 도구의 항목은 제거합니다
* 항목이 연결된 MCP 서버를 가리킨다면, 항목을 해당 서버의 [도구 이름](https://code.claude.com/docs/ko/permissions.md#mcp)에 표기된 서버 이름과 비교합니다. 예를 들어 `mcp__reports__v2__get_totals`에서는 `reports__v2`입니다. 이 서버의 경우 `mcp__reports__v2__*`, 즉 `mcp__` 뒤에 전체 이름과 `__*`를 붙여 작성합니다. `reports`라는 서버를 가리키는 더 짧은 `mcp__reports`를 사용하면 서브에이전트는 `reports__v2` 도구를 하나도 받지 못합니다
* `CronCreate`처럼 [백그라운드 서브에이전트에서 제외되는](https://code.claude.com/docs/ko/sub-agents.md#available-tools) 도구의 경우 해당 항목을 제거합니다
* 대신 `CronCreate` 같은 도구를 유지하려면 [Claude가 서브에이전트를 기다리도록](https://code.claude.com/docs/ko/sub-agents.md#let-claude-wait-for-a-subagent) 합니다. Claude가 기다리는 서브에이전트는 포그라운드에서 실행되며 해당 도구를 유지합니다. 정의에 `background: true`가 설정되어 있다면 이 필드가 서브에이전트를 백그라운드에 머물게 하므로 먼저 해당 필드를 제거합니다
* 서브에이전트에게 [서브에이전트가 사용할 수 있는 모든 도구](https://code.claude.com/docs/ko/sub-agents.md#available-tools)를 제공하려면 도구를 나열하는 대신 `tools` 필드를 삭제합니다
* `Agent`만 포함된 `tools` 목록의 경우 [깊이 제한](https://code.claude.com/docs/ko/sub-agents.md#let-subagents-spawn-their-own-subagents)을 높이거나 에이전트에게 다른 도구를 하나 이상 제공합니다. Claude Code는 해당 제한에서 `Agent`를 제공하지 않으므로, 다른 항목이 없는 목록은 도구가 없는 것으로 처리됩니다

### File is covered by a Read deny rule

[`Read` 거부 규칙](https://code.claude.com/docs/ko/permissions#read-and-edit)과 일치하는 경로에 대해 Edit 또는 Write 도구가 호출되었습니다. 해당 경로에 새 파일을 만드는 경우도 포함됩니다. 두 도구 모두 Claude가 다시 읽을 수 있어야 하는 콘텐츠를 변경하므로, Claude Code는 파일에 접근하기 전에 호출을 거부합니다. NotebookEdit은 `Read` 거부 규칙의 적용을 받지 않습니다. v2.1.228 이전에는 이 규칙이 Edit 도구만 차단했고, v2.1.208 이전에는 `Edit` 거부 규칙만 편집을 차단했습니다.

```text theme={null}
File is covered by a Read deny rule in your permission settings and cannot be edited.
```

Claude Code가 Write 도구를 거부하는 경우에는 메시지가 `and cannot be written`으로 끝납니다.

**조치 방법:**

* Claude가 파일을 변경할 수 있어야 한다면 `/permissions` 또는 [설정](https://code.claude.com/docs/ko/settings-reference.md#permission-settings)에서 `Read` 거부 규칙을 제거하거나 범위를 좁힙니다
* 파일을 그대로 유지해야 한다면 규칙을 유지하고, NotebookEdit 도구도 차단되도록 같은 경로에 대한 `Edit` 거부 규칙을 추가합니다

### Path cannot contain null bytes

파일 도구 호출의 경로 또는 패턴 인수에 파일 시스템과 검색 도구가 허용하지 않는 null 바이트가 포함되어 있었습니다. Read, Write, Edit, NotebookEdit, Glob, Grep이 이를 검사하며, 메시지에는 도구와 인수가 표시됩니다.

```text theme={null}
Read file_path cannot contain null bytes (\0). Remove the null byte and try again.
```

도구 호출은 실패하고, Claude는 오류를 확인하며, 턴은 계속 진행됩니다.

**조치 방법:**

* 사용자 측에서 할 일은 없습니다. 오류는 도구의 결과로 Claude에 반환되며, 메시지 자체가 Claude에게 null 바이트를 제거하고 다시 시도하라고 안내합니다

v2.1.281 이전에는 Read, Write, Edit, NotebookEdit 경로에 null 바이트가 있으면 `Path contains null bytes`를 언급하는 오류와 함께 턴 전체가 종료되었고, 도구는 실행되지 않았습니다.

### Command contains an invisible character

[PowerShell 도구](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool)가 U+FEFF 또는 U+180E가 포함된 명령의 실행을 거부했습니다.

```text theme={null}
Error: command contains the invisible character U+FEFF (byte order mark) or U+180E (Mongolian vowel separator), and was not run. Remove the character, keep the text that needs it in a file that the command reads, or write it as $([char]0xFEFF) or $([char]0x180E) inside a double-quoted string
```

**조치 방법:**

* **Claude가 작성한 명령의 경우**: 수정할 것이 없습니다. 메시지가 Claude에게 명령을 다시 작성하는 방법을 알려 줍니다.
* **스킬 또는 명령 파일의 경우**: 메시지는 `No shell command in <name> was run` 뒤에 표시됩니다. [문자를 찾아 제거하는 위치](#no-shell-command-was-run)를 참조하세요.

### File is too large to read as an image

Claude가 [Read 도구](https://code.claude.com/docs/ko/tools-reference.md#read-tool-behavior)로 파일을 이미지로 읽으려 했지만, 파일이 Read가 이미지 파일에서 불러올 수 있는 최대 크기인 128MB보다 큽니다. 아무것도 읽히지 않았으며, Claude는 도구 결과로 다음 오류를 받습니다.

```text wrap theme={null}
File is too large to read as an image (the limit is 128MB): <path>. If it is an image, resize it or export a smaller copy, then read that.
```

경로가 일반 파일이 아니라 파이프나 디바이스인 경우, Read는 128MB를 초과하는 데이터가 도착하면 읽기를 중단하고 대신 다음 오류를 반환합니다.

```text wrap theme={null}
Cannot read this as an image: <path> is a pipe or a device, not a regular file, and it sent more than 128MB without ending.
```

**조치 방법:**

* Claude가 `File is too large` 메시지에 따라 이미지 크기를 조정하거나 더 작은 사본을 읽었다면 별도로 조치할 필요가 없습니다
* Claude가 오류에서 멈췄다면 더 낮은 해상도 등으로 128MB 미만의 사본을 직접 내보낸 다음 Claude에게 해당 파일을 지정합니다
* 경로가 파이프나 디바이스였다면 대신 일반 이미지 파일을 Claude에게 지정합니다

### subagent\_type is required

```text theme={null}
subagent_type is required: the general-purpose agent is not available in this session. Available agents: ...
```

Claude가 `subagent_type` 없이 [Agent 도구](https://code.claude.com/docs/ko/tools-reference.md#agent-tool-behavior)를 호출했는데, 이 세션에는 대체로 사용할 [범용 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#built-in-subagents)가 없습니다. 이는 다음 두 가지 설정에서 발생합니다.

* 비대화형 모드에서 [`CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS=1`](https://code.claude.com/docs/ko/env-vars)이 설정되어 모든 내장 서브에이전트가 제거된 경우
* 세션의 메인 스레드 에이전트에 `general-purpose`를 제외한 [`tools: Agent(...)` 허용 목록](https://code.claude.com/docs/ko/sub-agents#restrict-which-subagents-can-be-spawned)이 있는 경우

**조치 방법:**

* 보통은 조치할 필요가 없습니다. 메시지에 세션에서 사용할 수 있는 서브에이전트가 나열되므로 Claude가 그중 하나로 재시도할 수 있습니다
* Claude가 계속 실패한다면 `tools: Agent(...)` 허용 목록에 `general-purpose`를 추가하거나 `CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS` 설정을 해제합니다

v2.1.235 이전에는 같은 호출이 `Agent type 'general-purpose' not found`로 실패했습니다.

### 메모리 인덱스가 읽기 제한을 초과함

Claude가 [자동 메모리](https://code.claude.com/docs/ko/memory.md#auto-memory) 인덱스 `MEMORY.md`에 쓰기를 수행했고, 그 결과 파일이 읽기 제한인 200줄 또는 25KB 중 하나를 초과했습니다. 쓰기는 성공했지만 세션 시작 시 처음 200줄 또는 25KB 중 먼저 도달하는 분량만 로드되므로, 인덱스를 읽을 때마다 제한을 넘는 내용은 모두 누락됩니다. v2.1.210 이전에는 제한을 초과한 인덱스가 쓰기 시점에 아무런 신호 없이 다음 로드 시 조용히 잘렸습니다.

```text theme={null}
Error: this write left the memory index at MEMORY.md at 214 lines, over its 200-line read limit. The write succeeded, but everything past the limit is silently dropped each time the index is loaded — entries at the end are already invisible to readers. Rewrite it to under 140 lines now: keep one line per entry, move detail into topic files, and merge or drop stale entries.
```

실제로 로드되는 콘텐츠만 제한에 포함됩니다. YAML frontmatter와 블록 수준 HTML 주석은 인덱스가 로드되기 전에 제거되므로 측정에서 제외됩니다. v2.1.211 이전에는 Claude Code가 원본 파일을 측정했기 때문에, 로드되는 콘텐츠가 제한 내에 있어도 frontmatter나 주석 때문에 이 오류가 발생할 수 있었습니다.

Claude Code는 이 오류를 터미널에 배너로 출력하지 않고 쓰기 후 Claude에 전달하므로, 트랜스크립트에서만 확인할 수 있을 수 있습니다.

Claude의 쓰기로 파일이 제한에 가까워졌지만 넘지 않은 경우에는, Claude Code가 이 오류 대신 인덱스를 압축하라는 더 완곡한 알림을 반환합니다.

**조치 방법:**

* Claude가 `MEMORY.md`를 다시 작성하도록 두거나 요청합니다. 항목당 한 줄을 유지하고, 세부 내용은 주제 파일로 옮기고, 오래된 항목은 병합하거나 삭제합니다
* 인덱스를 직접 정리하려면 [메모리 감사 및 편집](https://code.claude.com/docs/ko/memory.md#audit-and-edit-your-memory)을 참조하세요

### pkill 패턴이 Claude Code 프로세스와 일치함

Bash 도구 호출의 `pkill` 명령이 보통 `-f`와 함께 Claude Code 프로세스 자체와 일치하는 패턴을 사용했기 때문에, Claude Code는 해당 명령이 세션을 종료하도록 두지 않고 명령을 거부합니다. Claude Code는 `pkill`을 실행하기 전에 `pgrep`으로 패턴을 테스트하고, 결과에 자신의 프로세스 ID가 있으면 거부합니다. 이 검사는 Linux에서만 실행되며, macOS에서는 `pkill`이 수정 없이 실행됩니다. v2.1.214 이전에는 명령이 실행되어, 일치하는 패턴이 턴 도중에 Claude Code 세션을 종료시켰습니다.

```text theme={null}
pkill: refusing to run — this pattern matches the Claude CLI process (PID 12345). Narrow the pattern, or target your own children with `pkill -P $$ ...`.
```

거부는 터미널의 배너가 아니라 Bash 도구 결과에 표시되며, 보통 Claude가 스스로 명령을 조정합니다.

**조치 방법:**

* 짧은 부분 문자열 대신 대상 바이너리의 전체 경로를 사용하는 등 의도한 프로세스만 일치하도록 패턴을 좁힙니다
* 현재 셸이 시작한 프로세스를 중지하려면 패턴과 함께 `pkill -P $$`를 사용합니다. 이렇게 하면 일치 대상이 셸 자신의 자식 프로세스로 제한됩니다

### Failed to write to a teammate's inbox

Claude Code가 `~/.claude/teams/{team-name}/inboxes/` 아래에 있는 팀원의 메일함 파일에 메시지를 쓰지 못했으므로 수신자는 아무것도 받지 못했습니다. 디스크가 가득 찼거나, 디렉터리에 쓰기 권한이 없거나, 다른 에이전트가 받은 편지함 잠금을 너무 오래 점유하는 등의 이유로 Claude Code가 파일을 생성하거나 업데이트할 수 없을 때 쓰기가 실패합니다. v2.1.224 이전에는 쓰기가 실패해도 Claude Code가 메시지를 전송된 것으로 보고했습니다.

오류는 터미널의 배너가 아니라 보낸 에이전트의 도구 결과에 표시되며, 오류 텍스트가 Claude에게 다시 시도하라고 안내합니다.

```text theme={null}
Failed to write to researcher's inbox — nothing was sent. Try again, or message the lead.
```

구조화된 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 프로토콜 메시지도 같은 방식으로 실패하며, 오류에는 전달되지 않은 메시지가 표시됩니다. Claude Code가 플랜 승인, 플랜 거부, 종료 요청 또는 종료 거부를 쓰지 못하면 오류는 `Failed to write the <message> to <name>'s inbox — nothing was sent`로 표시됩니다. 이 목록의 `plan approval`은 팀원의 플랜을 승인하는 리드의 결정이며, 팀원의 플랜 제출은 별도의 `plan approval request` 메시지입니다. 이 메시지와 다른 두 프로토콜 메시지는 각각 고유한 메시지 텍스트와 결과를 가집니다.

* `Failed to write the plan approval request to the lead's inbox — plan not submitted; try again`: 팀원의 플랜이 리드에게 전달되지 않았으며, 재제출이 성공할 때까지 팀원은 플랜 모드에 머뭅니다
* `The permission request could not be delivered to the team lead (mailbox write failed)`: 팀원의 권한 요청이 리드에게 전달되지 않았으므로 아무도 도구 호출을 승인하지 않았습니다
* `The confirmation could not be written to team-lead's inbox.`: 종료 승인 자체는 적용되어 팀원이 종료됩니다. 리드에게 보내는 확인만 누락되었습니다

리드 세션에서 `@name` 뒤에 메시지를 입력하여 팀원에게 직접 메시지를 보내는 경우, 같은 실패가 `Couldn't write to @name's inbox — message not sent. Try again.` 알림으로 표시되며, Claude Code는 다시 보낼 수 있도록 입력한 텍스트를 프롬프트 상자에 유지합니다.

**조치 방법:**

* 보낸 쪽에 메시지를 다시 보내도록 요청합니다. 받은 편지함 잠금 경합은 일시적이며 재시도하면 해결됩니다
* 여유 디스크 공간을 확인하고, `~/.claude/teams`와 그 아래 파일에 사용자 계정의 쓰기 권한이 있는지 확인합니다

### Teammate's agent definition was not restored

Claude가 중지된 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 팀원에게 메시지를 보냈고, Claude Code는 팀원을 생성할 때 사용한 [서브에이전트 정의](https://code.claude.com/docs/ko/agent-teams.md#use-subagent-definitions-for-teammates)를 다시 적용하지 않고 팀원을 복귀시켰습니다. 이 알림은 보낸 에이전트의 도구 결과에서 재개 보고 뒤에 표시되며 이유를 알려 줍니다. 정의 파일이 신뢰가 저장되지 않은 폴더에서 온 경우 다음과 같이 표시됩니다.

```text wrap theme={null}
Its agent definition was not restored: the folder its definition file came from is not trusted (source: projectSettings), so the teammate is running with the team-essential tools and no custom instructions. To restore it, the user needs to run Claude Code in that folder once and accept the trust dialog (the --debug log names the folder); do not change trust settings on the user's behalf.
```

이 검사는 프로젝트 또는 `--add-dir` 디렉터리의 `.claude/agents/` 디렉터리에 있는 정의에 적용되며, 상위 폴더에 대한 신뢰 대화 상자를 수락해도 충족되지 않습니다.

**조치 방법:**

* [디버그 로그](https://code.claude.com/docs/ko/debug-your-config.md)에 표시된 폴더에서 `claude`를 실행하고 신뢰 대화 상자를 수락합니다. 다음에 Claude Code가 팀원을 복귀시킬 때 정의가 다시 적용되며, 리드 세션을 다시 시작할 필요는 없습니다
* 또는 디버그 로그에 출력된 정확한 `projects["<path>"]` 키를 사용하여 `~/.claude.json`에서 `hasTrustDialogAccepted` 항목을 `true`로 설정합니다

### Only a teammate can approve a shutdown request

전송한 세션이 팀원으로 실행 중이 아니기 때문에 Claude Code가 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 종료 승인을 거부했습니다. 아무것도 전송되지 않았고 아무것도 종료되지 않았습니다. 거부는 전송한 세션의 도구 결과에 표시됩니다.

```text wrap theme={null}
Only a teammate can approve a shutdown request, and this session is not running as one. Nothing was sent. To shut down a teammate, send that teammate a shutdown_request message. The teammate is the one that approves it.
```

**조치 방법:**

* 리드 세션에 거부가 표시되었다면 먼저 그 사이에 팀원이 종료되었는지 확인합니다. 거부는 대신 `shutdown_request`를 보내라는 지시와 함께 Claude에 반환되며, 턴은 계속 진행됩니다. 대화형 리드 세션에서는 팀원이 종료 요청을 승인하면 `<name> has shut down.`이 표시됩니다.
* 팀원이 아직 실행 중이라면 리드의 프롬프트에서 팀원을 종료하도록 요청합니다. 예: `Ask the researcher teammate to shut down`. [팀원 종료](https://code.claude.com/docs/ko/agent-teams.md#shut-down-teammates)를 참조하세요.
* `claude --resume`으로 직접 재개한 이전 팀원이 이 거부를 받았다면 아무것도 전송되지 않았습니다. 해당 세션을 종료하려면 그 프롬프트에서 `/exit`를 실행합니다.

### A command-line deny rule cannot be handed to a teammate intact

이 메시지는 Claude Code가 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md)에서 [분할 창](https://code.claude.com/docs/ko/agent-teams.md#choose-a-display-mode) 팀원을 시작하지 않았다는 뜻입니다. Claude Code는 리드의 명령줄 거부 규칙을 분할 창 팀원 자체의 명령줄로 전달하며, 팀원이 그중 하나를 다르게 해석하게 될 경우 중단합니다.

```text wrap theme={null}
A command-line deny rule cannot be handed to a teammate intact, so the teammate would not enforce it — spawn aborted
```

**조치 방법:**

* 리드 세션에서 `/config`를 실행하고 **Teammate mode**를 `in-process`로 설정한 다음, Claude에게 팀원을 다시 시작하도록 요청합니다. 규칙을 찾거나 리드를 다시 시작할 필요는 없습니다. 인프로세스 팀원은 [리드의 실시간 거부 규칙에 따라 실행됩니다](https://code.claude.com/docs/ko/agent-teams.md#permissions).
* `/config`는 선택 사항을 사용자 설정에 저장하므로, 사용자 설정에서 [`teammateMode`](https://code.claude.com/docs/ko/settings-reference#teammatemode)를 가져오는 이후 세션도 팀원을 인프로세스로 시작합니다. 이후 세션에서 분할 창으로 돌아가려면 **Teammate mode**를 이전에 사용하던 `auto`, `tmux` 또는 `iterm2` 중 하나로 설정합니다.

### Message too large for cross-session delivery

이 머신의 다른 세션으로 보낸 Claude의 [세션 간 메시지](https://code.claude.com/docs/ko/cross-session-messaging.md)가 너무 길어서 전송할 수 없었습니다. Claude Code가 이를 거부했으며, 수신 세션은 아무것도 받지 못했습니다. 거부는 터미널의 배너가 아니라 전송한 세션의 도구 결과에 표시됩니다. 거부 메시지에는 두 크기와 메시지를 제한에 맞추는 방법이 표시됩니다.

```text wrap theme={null}
Failed to send to api-worker: Message too large for cross-session delivery: the serialized message is 1,203,844 characters and the limit is 1,048,576. Shorten the message text — put bulk content in a file the recipient can read rather than in the message — or split it into smaller messages.
```

같은 텍스트를 다시 보내도 같은 방식으로 실패합니다.

**조치 방법:**

* Claude에게 메시지를 요약하거나, 대용량 콘텐츠를 파일에 넣고 파일 경로를 보내도록 요청합니다
* Claude에게 콘텐츠를 여러 개의 짧은 메시지로 나누도록 요청합니다

v2.1.235 이전에는 Claude Code가 너무 큰 메시지를 전송된 것으로 보고했습니다. 수신 세션은 이를 읽지 않고 폐기했습니다.

### Too many messages to this session just now

Claude가 이 머신의 세션 중 하나에 [세션 간 메시지](https://code.claude.com/docs/ko/cross-session-messaging.md)를 짧은 시간에 연달아 보냈고, 그 양이 해당 세션의 받은 편지함이 수용하는 한도에 도달했습니다. Claude Code는 다음 전송을 거부했으며, 수신 세션은 그 메시지를 받지 못했습니다. 거부는 터미널의 배너가 아니라 전송한 세션의 도구 결과에 표시됩니다.

```text wrap theme={null}
Failed to send to api-worker: Too many messages to this session just now: 30 were sent recently and more would be dropped by its rate limit, so this one was not sent. Batch what remains into one message, or wait a little before sending more.
```

**조치 방법:**

* 보통은 조치할 필요가 없습니다. Claude가 남은 콘텐츠를 하나의 메시지로 묶거나, 잠시 기다린 후 더 보냅니다
* 연속 전송을 직접 요청했다면 Claude에게 남은 내용을 하나의 메시지로 합치도록 요청합니다

v2.1.236 이전에는 Claude Code가 이러한 전송을 전송된 것으로 보고했습니다. 수신 세션은 이를 읽지 않고 폐기했습니다.

### Cross-session message was dropped at the recipient session's inbox

Claude가 이 머신의 다른 세션에 [세션 간 메시지](https://code.claude.com/docs/ko/cross-session-messaging.md)를 보냈지만, 해당 세션의 Claude가 읽기 전에 그 세션의 받은 편지함이 메시지를 폐기했습니다. 이 줄에는 수신자가 표시되며, 수신자가 이유를 제공한 경우 대시 뒤에 이유가 추가됩니다.

```text wrap theme={null}
Cross-session message was dropped at the recipient session's inbox (recipient: uds:/tmp/cc-socks/13605.sock) and not delivered — its queue of undelivered peer messages was full. Claude was told not to resend right away.
```

한 줄이 여러 개의 폐기된 메시지를 다룰 수 있습니다. 이 경우 `Cross-session messages (12) were dropped`처럼 복수형으로 시작합니다. 주소가 어느 세션에 속하는지 확인하려면 각 세션에서 `/status`가 표시하는 [`Peer address` 행](https://code.claude.com/docs/ko/cross-session-messaging#the-sessions-inbox-socket)과 비교합니다.

대시 뒤에는 다음 이유 중 하나 이상이 표시됩니다.

* `its queue of undelivered peer messages was full`: 수신자가 이미 큐가 허용하는 만큼의 다른 세션 미전달 메시지를 보유하고 있었습니다
* `you sent faster than that session accepts`: 전송한 세션의 메시지가 수신자가 한 발신자로부터 받아들이는 속도보다 빠르게 도착했습니다
* `it repeated your previous message`: 메시지가 전송한 세션이 직전에 이 수신자에게 보낸 메시지와 동일했습니다
* `a relay loop between sessions was cut`: 메시지가 세션끼리 서로 메시지를 주고받는 연쇄를 이어 갔고, 그 연쇄가 수신자를 너무 여러 번 거쳤거나 너무 길어졌습니다

**조치 방법:**

* 수신자가 폐기된 메시지를 보지 못했다고 가정합니다. Claude Code도 Claude에게 같은 내용을 알리며, 즉시 다시 보내는 대신 여전히 중요한 내용을 이후 메시지 하나에 포함하라고 안내합니다
* 세션들이 서로 업데이트를 자주 보낸다면 Claude에게 세션이 작업을 마쳤을 때 보고서 하나를 보내는 식으로 더 적고 큰 메시지를 보내도록 요청합니다
* `a relay loop between sessions was cut`의 경우 세션 중 하나에 다음 지시를 직접 입력합니다. 사용자의 프롬프트에 대한 응답으로 Claude가 보내는 메시지는 새로운 연쇄를 시작합니다

v2.1.238 이전에는 수신자의 받은 편지함이 메시지를 폐기해도 전송한 세션이 아무런 보고를 받지 못했습니다.

### 세션 간 메시지 전송 거부

Claude Code는 이 머신의 다른 세션에 [세션 간 메시지](https://code.claude.com/docs/ko/cross-session-messaging.md)를 쓰기 전에, 대상 세션의 받은 편지함 소켓이 메시지가 지정된 엔드포인트인지 확인합니다. 검사가 실패하면 Claude Code는 전송한 세션에서 전송을 거부하며, 대상 세션은 아무것도 받지 못합니다. Claude가 보내는 메시지의 경우 거부는 전송한 세션의 도구 결과에 표시됩니다.

```text theme={null}
Failed to send to api-worker: Refusing to send: reply target is a symlink
```

`Refusing to send:` 뒤의 텍스트는 실패한 검사를 나타냅니다.

* `reply target is a symlink`: 대상 세션의 소켓 경로에 심볼릭 링크가 있습니다. 그 위치의 링크가 대상 세션이 만들지 않은 엔드포인트로 메시지를 리디렉션할 수 있으므로 Claude Code는 이를 통해 전달하지 않습니다.
* `cannot vet reply target`: 대상 경로를 읽는 중 권한 오류가 발생하는 등의 이유로 Claude Code가 대상 경로를 전혀 검사할 수 없었습니다.

**조치 방법:**

* 보통은 조치할 필요가 없습니다. 이 검사는 메시지가 지정된 세션 이외의 엔드포인트에 도달하지 않도록 하며, 아무것도 전송되지 않았습니다
* 한 세션에서 `reply target is a symlink`가 반복된다면 해당 세션의 `/status`에서 `Peer address` 아래에 표시되는 소켓 경로에 무엇이 링크를 만들었는지 확인합니다

### 경로 읽기, 쓰기 또는 검색 거부

Claude Code는 파일 경로의 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#read-and-edit)을 확인한 다음, 도구가 파일을 열거나 검색을 시작할 때 경로 해석을 다시 확인합니다. 경로가 여전히 검사에서 승인된 위치로 이어지는지 확인할 수 없으면 Claude Code는 그 경로를 따라가는 대신 작업을 거부합니다. 거부는 도구 결과에 표시됩니다.

```text wrap theme={null}
Refusing to read /path/to/file: its symlink resolution changed after permission was checked (a link on the way now leads somewhere the check did not see). If a link in the working directory is being rewritten concurrently, stop that and retry.
```

각 거부에는 이유가 표시됩니다.

* `its symlink resolution changed after permission was checked`: 권한 검사와 작업 사이에 경로상의 심볼릭 링크 또는 Grep이나 Glob 검색 루트의 심볼릭 링크가 교체되었습니다. 읽기 거부에서는 괄호 안의 문구가 어떤 비교가 실패했는지 알려 줍니다.
* `its parent-directory symlink resolution changed after permission was checked`: 쓰기 경로가 거치는 디렉터리가 더 이상 승인된 위치로 해석되지 않습니다
* `where it leads on disk could not be determined (a link on the way could not be examined, or the links do not resolve)`: 경로상의 심볼릭 링크가 루프를 형성하는 등의 이유로 Claude Code가 경로를 디스크상의 최종 위치까지 따라갈 수 없었습니다
* `it is a symbolic link. Write to the link's target path instead`: `AGENTS.md`에 대한 심볼릭 링크인 `CLAUDE.md`처럼 요청된 쓰기 위치 자체에 심볼릭 링크가 있습니다. 메시지는 Claude에게 링크의 대상을 안내합니다
* `Refusing to write through symlink: <path>. Resolve the symlink and pass the real target path explicitly.`: 심볼릭 링크된 `.mcp.json`에 쓰는 경우처럼 다른 쓰기 주체가 파일을 열 때 감지된 같은 상황입니다
* `Refusing to write into symlinked directory: <path>`: 다른 위치에 링크된 프로젝트의 `.claude/` 디렉터리처럼 파일을 담고 있는 디렉터리 자체가 심볼릭 링크입니다
* `a path one of its Read deny rules is written through changed while the search was being prepared. Retry.`: 검색에 대한 `Read` 거부 규칙이 심볼릭 링크를 거치는 경로를 지정하며, Claude Code가 검색을 준비하는 동안 그 링크가 변경되었습니다
* `it could not be opened (EACCES) — it is unreadable, or is being replaced concurrently.`: 검색 루트는 존재하지만 열 수 없었습니다. 괄호 안의 코드는 운영 체제 오류입니다
* `its permission check expired before it ran (too many concurrent file operations). Retry.`: 동시에 많은 파일 작업이 수행되는 상황에서 도구가 사용하기 전에 Claude Code가 승인 기록을 제거했습니다. 재시도하면 새로운 권한 검사가 실행됩니다
* `ripgrep was found only by name on PATH, and a search outside the working directory cannot apply your Read deny rules in that configuration`: Claude Code가 `rg` 바이너리를 절대 경로로 해석할 수 없었기 때문에, 거부 규칙이 적용되지 않는 검색을 실행하는 대신 작업 디렉터리 외부의 검색을 거부합니다

**조치 방법:**

* 보통은 조치할 필요가 없습니다. 거부는 도구 결과로 Claude에 전달되며, 거부된 작업은 실행되지 않습니다
* 한 경로에서 심볼릭 링크 거부가 반복된다면 빌드 도구나 파일 감시자처럼 그 위치의 링크를 계속 다시 쓰는 주체를 찾거나, Claude에게 링크된 경로 대신 파일의 해석된 경로를 사용하도록 요청합니다
* Windows에서 AppContainer 또는 제한된 토큰 샌드박스 안에서 Claude Code를 실행할 때 모든 파일에 대해 이 거부가 표시된다면 v2.1.265 이상으로 업그레이드합니다
* macOS에서 프롬프트에 끌어다 놓은 스크린샷처럼 아무것도 다시 쓰지 않는 파일에 대해 읽기 거부가 표시된다면 v2.1.273 이상으로 업그레이드합니다
* ripgrep 거부의 경우 `rg`가 `PATH`에서 절대 경로로 해석되도록 패키지 관리자로 ripgrep을 설치하거나, 검색을 작업 디렉터리 아래로 유지합니다

v2.1.251 이전에는 Claude Code가 파일 쓰기에 대해서만 경로 해석을 다시 확인했기 때문에, 권한 검사 후 교체된 링크가 메시지 없이 읽기나 검색을 다른 위치로 리디렉션할 수 있었습니다. 이 중 이전 버전에서도 표시되는 것은 상위 디렉터리, 심볼릭 링크 경유, 심볼릭 링크된 디렉터리에 대한 쓰기 거부뿐입니다.

v2.1.280 이전에는 `where it leads on disk could not be determined` 거부가 표시되지 않았습니다.

### Task output swap refused

Claude Code는 각 Bash 명령의 출력을 임시 디렉터리 아래의 파일에 저장합니다. 이러한 파일을 열 때마다 심볼릭 링크, 추가 하드 링크 또는 이동된 디렉터리가 경로를 리디렉션하지 않고 경로가 여전히 자신이 만든 파일로 이어지는지 확인합니다. 이 메시지는 해당 검사가 실패했다는 뜻이므로, Claude Code는 그 경로를 통해 출력을 쓰거나 읽는 대신 작업을 거부했습니다. 메시지는 Bash 도구 결과에 표시됩니다.

```text wrap theme={null}
task output swap refused (tasks dir moved or linked): /private/tmp/claude-501/-Users-you-my-project/1f0e62dc-4b0a-4f5e-9c2d-8a7b6c5d4e3f/tasks/b7k2f9m3q.output. To recover: restart Claude Code with CLAUDE_CODE_TMPDIR set to a fresh directory; or, if /private/tmp/claude-501/-Users-you-my-project is a stray directory or a symbolic link that should not be there, remove that entry itself (not what it points to) and restart.
```

괄호 안의 텍스트는 실패한 검사를 나타냅니다. `output symlink was re-pointed`, `output file identity changed`, `not a regular file` 같은 이유는 모두 같은 상황을 보고합니다. 즉, 출력 경로 자체 또는 그 경로상의 무언가가 더 이상 Claude Code가 만든 파일이 아닙니다. 일부 이유에만 `To recover:` 문장이 포함됩니다.

명령이 아직 실행 중일 때 검사가 실패하면 Claude Code는 명령을 중지하며, 결과에 다음과 같이 보고됩니다.

```text theme={null}
Command killed: its output file was replaced or could no longer be verified
```

**조치 방법:**

* v2.1.260 이상으로 업그레이드합니다. 이전 버전에서는 링크나 이동된 디렉터리가 없을 때도 이 메시지가 표시되는 경우가 있었습니다
* [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars)를 새 디렉터리로 설정하여 Claude Code를 다시 시작합니다
* 또는 Claude Code 임시 디렉터리 아래의 프로젝트 디렉터리를 확인합니다. 예시 메시지에서는 `/private/tmp/claude-501/-Users-you-my-project`입니다. 해당 경로가 심볼릭 링크이거나 있어서는 안 되는 디렉터리라면 링크의 대상이 아닌 링크나 디렉터리 자체를 제거하고 Claude Code를 다시 시작합니다
* 거부가 반복된다면 세션이 실행되는 동안 어떤 프로세스가 Claude Code 임시 디렉터리 아래의 항목을 교체, 링크 또는 제거하고 있는 것입니다. [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars)를 다른 어떤 것도 관리하지 않는 디렉터리로 설정하고 다시 시작합니다

### Disk full or disk quota used up

Claude Code의 임시 디렉터리가 있는 볼륨에서 공간, inode 또는 디스크 할당량을 확보합니다. 명령 결과에서 `Disk full:`, `Disk quota used up:` 또는 `Nearly out of inodes:`로 시작하는 줄에 해당 디렉터리가 표시됩니다.

Claude Code는 각 Bash 및 PowerShell 명령의 출력을 해당 디렉터리 아래의 파일에 저장합니다. 볼륨 또는 해당 볼륨의 사용자 할당량이 가득 차서 이 파일을 만들 수 없으면 명령이 시작되지 않으며, Claude가 읽는 결과는 다음과 같습니다.

```text wrap theme={null}
The command was not started: this computer's disk is full (ENOSPC) on the volume holding /tmp/claude-501 (Claude Code's temporary directory), so the file that captures command output could not be created there and nothing ran. Free space on that volume, or restart Claude Code with CLAUDE_CODE_TMPDIR set to a directory on another one, then retry. If this is the user's own computer, tell them before deleting anything to make room.
```

`Disk full:`, `Disk quota used up:`, `Nearly out of inodes:` 메시지는 실행된 후 0이 아닌 코드로 종료된 명령 뒤에 표시됩니다. 예:

```text wrap theme={null}
Disk full: this computer's volume holding /tmp/claude-501 (Claude Code's temporary directory) has 3 MB free, so whatever this command printed was lost and its own writes may have failed with "No space left on device". Free space on that volume, or restart Claude Code with CLAUDE_CODE_TMPDIR set to a directory on another one, then retry. If this is the user's own computer, tell them before deleting anything to make room.
```

**조치 방법:**

* macOS와 Linux에서는 셸에서 `df -h <dir>`를 실행하여 어떤 볼륨에 디렉터리가 있으며 얼마나 찼는지 확인합니다. `df -i <dir>`는 사용 가능한 inode 수를 보여 줍니다. `<dir>`는 메시지에 표시된 디렉터리이며, 예를 들어 `df -i /tmp/claude-501`처럼 사용합니다
* **`Disk full: this computer's volume` 또는 `disk is full (ENOSPC)`**: 해당 볼륨의 아무 위치에서나 필요 없는 파일을 삭제합니다
* **`Disk quota used up:`, `disk quota is used up (EDQUOT)` 또는 `Disk full: a test write`**: 볼륨에 여유 공간이 있는 것으로 표시되더라도 해당 볼륨에서 사용자 본인의 파일을 삭제합니다
* **`Nearly out of inodes:`**: 해당 볼륨에서 많은 파일을 삭제합니다. 파일은 크기와 관계없이 각각 inode 하나를 차지하므로, 크기가 아니라 파일 개수가 중요합니다
* 또는 [`CLAUDE_CODE_TMPDIR`](https://code.claude.com/docs/ko/env-vars)를 여유 공간이 있는 볼륨의 디렉터리로 설정하여 Claude Code를 다시 시작합니다
* 그런 다음 Claude에게 명령을 다시 실행하도록 합니다

v2.1.309 이전에는 메시지가 다음과 같았으며, 같은 단계가 적용됩니다.

* `Your disk quota is full on the filesystem with Claude Code's temp directory <dir> (EDQUOT)`
* `The filesystem with Claude Code's temp directory <dir>, or your disk quota on it, is full (ENOSPC)`
* `Command output was lost: the temp filesystem at <dir> is full` 또는 `... is out of inodes`
* `The command was not started: this computer's disk is full (ENOSPC), so the file that captures command output could not be created. Nothing ran.` 또는 `(EDQUOT)`가 포함된 같은 메시지. 이 형식에는 디렉터리가 표시되지 않으므로 `/tmp` 같은 시스템 임시 디렉터리 또는 `CLAUDE_CODE_TMPDIR`에 설정된 디렉터리가 있는 볼륨을 확인합니다

v2.1.305 이전에는 디스크가 가득 차서 Claude Code가 시작할 수 없었던 명령이 운영 체제의 오류 텍스트만 반환했습니다. 해당 텍스트는 예를 들어 `ENOSPC: no space left on device, open <path>.output`과 같았습니다.

### git is not installed on this Mac

이 메시지는 Claude Code의 어떤 단계에 git이 필요했는데, 찾은 git이 `/usr/bin/git`에 있는 Apple의 대체 실행 파일이라는 뜻입니다. git을 제공하는 개발자 도구가 설치되어 있지 않습니다.

Claude Code는 대체 실행 파일을 시작하지 않고 대신 이 텍스트를 표시하며, 예를 들어 더 긴 메시지 안에 포함될 수 있습니다.

```text wrap theme={null}
git is not installed on this Mac. To install it, run xcode-select --install, then try again.
```

**조치 방법:**

* 터미널에서 `xcode-select --install`을 실행하고, 시작된 설치를 완료한 다음, Claude Code에서 하던 작업을 다시 시도합니다

### File is not valid UTF-8

Claude가 바이트를 UTF-8로 디코딩할 수 없는 파일에 Edit 또는 NotebookEdit 도구를 사용했고, Claude Code가 변경을 거부했습니다. 아무것도 쓰이지 않았으므로 파일은 그대로입니다. 이 도구들은 파일 전체를 UTF-8로 다시 저장하므로, 디코딩할 수 없는 모든 바이트가 대체 문자 `U+FFFD`로 바뀌었을 것입니다. 메시지는 도구 결과에 표시됩니다.

```text wrap theme={null}
File is not valid UTF-8. It may use a legacy encoding such as Windows-1252, Shift-JIS or GBK, or be binary. This tool saves the whole file as UTF-8, which would replace every byte it cannot decode with U+FFFD. Nothing was written. Make the change with a shell command that reads and writes the file in its own encoding, or ask the user whether to convert the file to UTF-8 first.
```

검사는 파일의 바이트 전체를 대상으로 하므로, UTF-8로 의도된 파일도 잘못된 바이트 시퀀스가 하나라도 포함되어 있으면 이 메시지를 받습니다.

**조치 방법:**

* 파일을 현재 인코딩으로 유지하려면 메시지의 안내대로 Claude가 해당 인코딩으로 파일을 읽고 쓰는 셸 명령으로 변경하도록 합니다
* Edit 도구로 파일을 계속 편집하려면 파일을 UTF-8로 변환하거나, UTF-8로 의도된 파일이라면 잘못된 바이트를 수정한 다음, Claude에게 편집을 다시 하도록 요청합니다

v2.1.296 이전에는 Edit과 NotebookEdit이 이러한 편집을 적용하고 디코딩할 수 없는 모든 바이트를 `U+FFFD`로 저장했습니다. 해당 버전을 사용 중이라면 Claude Code를 업데이트합니다.

### The source file is not valid UTF-8 text

Claude가 바이트를 텍스트로 디코딩할 수 없거나 텍스트에 이미 대체 문자 `U+FFFD`가 포함된 파일에서 [아티팩트](https://code.claude.com/docs/ko/artifacts.md)를 게시하려 했기 때문에, Claude Code가 아무것도 업로드하기 전에 게시를 거부했습니다. 메시지는 Artifact 도구 결과에 표시되며 수정해야 할 첫 번째 위치를 알려 줍니다.

```text wrap theme={null}
file_path: the source file is not valid UTF-8 text (first invalid byte at line 12, column 40). It may be saved in another encoding or contain binary data. Rewrite it as UTF-8, then publish again. Nothing was published.

file_path: the source file has the replacement character U+FFFD at line 12, column 40, usually left where an earlier edit or paste lost a character. Replace it with the intended text (in HTML, write an intended U+FFFD as &#xFFFD;), then publish again. Nothing was published.
```

Claude Code는 파일을 UTF-8로 디코딩하며, 파일이 리틀 엔디언 UTF-16 바이트 순서 표시로 시작하는 경우에는 UTF-16으로 디코딩합니다. 이러한 UTF-16 파일을 디코딩할 수 없으면 첫 번째 메시지에 `UTF-16`이 표시되며, 여전히 파일을 UTF-8로 다시 작성하라고 안내합니다. 표시된 위치 뒤에 더 많은 위치가 있으면 메시지는 위치 뒤에 `(+2 more)` 같은 개수를 추가합니다.

**조치 방법:**

* 보통은 조치할 필요가 없습니다. Claude가 파일을 다시 작성하고 다시 게시합니다
* 직접 작성하거나 내보낸 파일이라면 UTF-8로 다시 저장하고, 각 `U+FFFD`를 이전 편집, 붙여넣기 또는 변환에서 손실된 문자로 바꿉니다
* 페이지에 의도적으로 `U+FFFD`를 표시하려면 HTML에서 리터럴 문자 대신 `&#xFFFD;`로 작성합니다

v2.1.267 이전에는 Claude Code가 이러한 파일을 검사하지 않고 업로드했으며, 대신 서버가 게시를 거부했습니다.

### Not published: that file is on a network share

Claude가 네트워크 호스트를 지정하는 경로의 파일에서 [아티팩트](https://code.claude.com/docs/ko/artifacts.md)를 게시하려 했습니다.

* Windows의 경우, 시작 시 [`--add-dir`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 전달한 매핑된 네트워크 드라이브 아래에 있지 않은 `\\server\share` 경로
* macOS 또는 Linux의 경우, `/net/<host>/page.html` 같은 자동 마운트 경로

이러한 경로를 조회하면 경로가 지정하는 호스트에 연결되며, Windows에서는 이 연결로 인해 호스트에 사용자의 자격 증명이 전송될 수 있습니다. Claude Code는 파일 게시를 거부하며 파일을 읽지 않습니다. 거부는 Artifact 도구 결과에 표시됩니다.

```text theme={null}
Not published: that file is on a network share. Publish a file from this session's folders instead.
```

**조치 방법:**

* 그 파일이 꼭 필요한 것이 아니라면 조치할 필요가 없습니다. 메시지가 Claude에게 대신 세션의 폴더에 있는 파일을 게시하라고 안내합니다
* 그 파일을 그대로 게시하려면 로컬 디스크의 폴더로 복사한 다음 다시 요청합니다
* Windows에서 Claude가 공유 위치에서 직접 게시할 수 있도록 하려면 공유 위치를 드라이브 문자에 매핑하고 Claude Code를 시작할 때 해당 드라이브를 전달합니다. 예를 들어 PowerShell에서 `net use Z: \\server\share`를 실행한 다음 `claude --add-dir Z:\`를 실행합니다. 그러면 Claude가 해당 드라이브의 파일을 게시할 수 있습니다. 세션 도중 `/add-dir`로 드라이브를 추가하는 것만으로는 충분하지 않습니다.
* macOS 또는 Linux에서는 `/mnt` 또는 `/Volumes` 아래 디렉터리 같은 곳에 공유 위치를 마운트하고, 자동 마운트 경로 대신 해당 경로에서 게시합니다

### Not published: Claude sent the same content again after a newer version of the artifact turned it away

Artifact 호출 아래의 이 빨간 줄은 Claude Code가 반복된 게시를 중단했다는 뜻입니다. [아티팩트](https://code.claude.com/docs/ko/artifacts.md)는 업데이트되지 않았으며, Claude가 게시하는 원본 파일에도 아무것도 쓰이지 않았습니다. Claude가 게시하지 않고 멈춘 경우에만 조치가 필요하며, 그렇지 않다면 별도로 조치할 필요가 없습니다.

세션 초반에 아티팩트에 더 새로운 버전이 있었기 때문에 Claude Code가 게시를 거부했습니다. 예를 들어 [편집자](https://code.claude.com/docs/ko/artifacts.md#let-someone-edit-with-you) 또는 사용자의 다른 세션이 게시한 버전이 있었던 경우입니다. 줄의 끝부분은 Claude가 다음에 해야 할 일을 알려 줍니다.

```text wrap theme={null}
Not published: Claude sent the same content again after a newer version of the artifact turned it away. Claude needs to work from that newer version first.
Not published: Claude sent the same content again after a newer version of the artifact turned it away. The artifact hasn't changed since, so publishing it once more should go through.
Not published: Claude sent its changes again over the same file after a newer version of the artifact turned them away. Claude needs to work from that newer version first.
Not published: Claude sent its changes again over the same file after a newer version of the artifact turned them away. The artifact hasn't changed since, so publishing once more should go through.
```

**조치 방법:**

* **`Claude needs to work from that newer version first`로 끝나는 경우**: Claude가 거기서 멈췄다면 아티팩트의 현재 버전을 가져와 변경 사항을 병합한 다음 다시 게시하도록 요청합니다
* **`should go through`로 끝나는 경우**: Claude가 거기서 멈췄다면 다시 게시하도록 요청합니다

### Cowork 세션에서 연결된 폴더 외부의 로컬 파일 읽기

Claude Desktop 앱에서 사용자의 머신으로 실행되는 [Cowork](https://claude.com/docs/cowork/overview) 세션에서 Claude가 [아티팩트](https://code.claude.com/docs/ko/artifacts.md)에 사용할 로컬 파일을 지정했습니다. Claude Code는 해당 파일이 세션의 연결된 폴더 안에 있는 일반 파일인지 확인할 수 없었습니다. 경로가 해당 폴더 외부에 있거나, 심볼릭 링크를 거치거나, 겉보기와 다른 파일을 가리킬 수 있는 방식으로 작성되어 있습니다. 이러한 파일을 읽으려면 사용자의 승인이 필요하며, 모든 승인을 건너뛰도록 설정된 세션처럼 승인 카드를 표시할 수 없는 세션에서는 Claude Code가 읽기를 거부합니다.

거부는 Artifact 도구 결과에 표시되며, 파일을 전혀 검사할 수 없었던 경우에는 대신 그 실패를 알려 줍니다.

```text wrap theme={null}
Reading a local file from outside this session's connected folders, or through a link, needs the approval card, and no one can answer it in this Cowork session. Use a plain file inside the connected folders; do not retry this file in this session.

cannot read file_path (ENOENT) — the file could not be examined, and no one can answer the approval card in this Cowork session. Check that the file exists as a plain file inside the connected folders, then retry with that path.
```

**조치 방법:**

* 보통은 조치할 필요가 없습니다. 메시지가 Claude에게 대신 연결된 폴더 안의 일반 파일을 사용하라고 안내합니다
* 그 파일을 그대로 아티팩트에 넣으려면 심볼릭 링크가 아닌 일반 파일로 세션의 연결된 폴더 중 하나에 복사한 다음 다시 요청합니다

### WebFetch cannot fetch localhost

Claude가 `http://localhost:3000`이나 `http://wiki/` 같은 단순 인트라넷 이름처럼 호스트 이름에 점이 없는 URL로 [WebFetch](https://code.claude.com/docs/ko/tools-reference.md#webfetch-tool-behavior)를 호출했습니다. WebFetch는 요청을 보내기 전에 이러한 URL을 거부합니다.

```text wrap theme={null}
WebFetch cannot fetch localhost or other hostnames without a dot. To reach a local server, use Bash with curl instead.
```

**조치 방법:**

* 보통은 조치할 필요가 없습니다. 메시지가 Claude에게 로컬 및 인트라넷 서버에 접근할 수 있는 Bash 도구를 통한 `curl`을 안내합니다

v2.1.268 이전에는 WebFetch가 이러한 URL을 일반적인 `Invalid URL` 오류로 보고했습니다.

### WebFetch 도메인 안전 검사 실패

URL을 가져오기 전에 WebFetch는 URL의 호스트 이름을 `api.anthropic.com`으로 보내 Anthropic의 [도메인 안전 차단 목록](https://code.claude.com/docs/ko/data-usage.md#webfetch-domain-safety-check)과 대조합니다. 검사를 완료할 수 없으면 WebFetch는 도메인이 안전한지 확인할 수 없으므로 페이지를 가져오지 않으며, 도구 결과에 대신 다음 메시지 중 하나가 표시됩니다.

```text wrap theme={null}
The safety check for domain example.com is rate-limited (too many domain checks from this network; the limit is shared and can stay exhausted for minutes). Do not retry WebFetch in a loop or sleep to wait it out; continue without this page and report that its safety check was rate-limited. A single later attempt is fine; if that is rate-limited too, stop.

Unable to verify if domain example.com is safe to fetch. This may be due to network restrictions or enterprise security policies blocking claude.ai.
```

* `rate-limited`: 검사 엔드포인트가 HTTP `429`로 응답했습니다. 메시지는 Claude에게 해당 페이지 없이 계속 진행하고 나중에 최대 한 번만 다시 시도하라고 안내합니다. Claude Code는 실패한 검사를 캐시하지 않으므로, 이후 해당 도메인을 가져올 때 검사가 다시 실행됩니다. 네트워크의 세션에서 이 문제가 자주 발생한다면 설정에서 [`skipWebFetchPreflight: true`](https://code.claude.com/docs/ko/settings-reference#skipwebfetchpreflight)로 검사를 건너뛸 수 있습니다.
* `Unable to verify`: 검사 요청이 실패했거나, 시간 초과되었거나, 다른 오류 상태를 받았습니다. 네트워크에서 `api.anthropic.com`을 차단한다면 해당 도메인을 허용 목록에 추가하거나, 설정에서 [`skipWebFetchPreflight: true`](https://code.claude.com/docs/ko/settings-reference#skipwebfetchpreflight)로 검사를 건너뜁니다.

v2.1.286 이전에는 속도 제한 메시지가 `The safety check for domain example.com is temporarily rate-limited (too many domain checks from this network). Retry after about a minute; retrying sooner will fail the same way.`로 표시되었습니다.
v2.1.285 이전에는 속도 제한된 검사가 대신 `Unable to verify` 메시지로 보고되었습니다.

## 백그라운드 세션 오류

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)은 자체 대화형 터미널 없이 실행되므로 터미널이 필요한 명령은 다르게 작동합니다. 이러한 메시지는 백그라운드 세션의 트랜스크립트, 백그라운드 세션에 연결된 터미널, 디스패치하는 세션 또는 셸에 나타나거나, 아래의 [worktree-guard 항목](#write-or-command-blocked-because-the-path-cannot-be-safely-resolved)의 경우 worktree에 격리된 모든 세션이나 worktree 격리 서브에이전트를 실행하는 세션에 나타납니다. 메시지가 특정 사용 환경에만 해당하는 경우 해당 항목에 명시됩니다.

### 백그라운드 세션에서 거부된 명령

대화형 대화 상자를 여는 명령은 백그라운드 세션에 터미널이 연결되지 않은 상태에서는 그렇게 할 수 없습니다. `/install-github-app`, `/mcp` 설정 목록 및 MCP 서버 메뉴의 인증 작업은 메시지로 응답하며, `/install-github-app` 및 `/mcp` 설정 목록의 경우 세션은 [에이전트 뷰](https://code.claude.com/docs/ko/agent-view.md)의 **입력 필요** 아래에 나타나므로 찾아서 연결하고 명령을 다시 실행할 수 있습니다. 터미널이 연결되어 있는 동안 이러한 명령은 정상적으로 작동합니다.

v2.1.216 이전에는 `/install-github-app` 또는 `/mcp` 설정 목록이 거부된 후 세션이 **입력 필요** 아래에 나타나지 않았습니다. v2.1.213부터 v2.1.215까지는 터미널이 연결되어 있는 동안 명령이 여전히 작동했으며, 거부 메시지는 연결하고 명령을 다시 실행하도록 지시했습니다. v2.1.208부터 v2.1.212까지는 Claude Code가 터미널이 연결되어 있는 동안에도 이를 거부했으며, `Can't open MCP settings in a background session`과 같은 메시지가 표시되었습니다. 이러한 버전에서는 일반 `claude` 세션에서 명령을 실행하거나 업그레이드하십시오. v2.1.208 이전에는 백그라운드 세션 내에서 대화 상자를 열었습니다. v2.1.208에서만 Claude Code는 백그라운드 세션에서 `/model` 선택기도 거부했으며, `/upgrade`는 브라우저를 열지 않고 업그레이드 URL을 인쇄했습니다.

표현은 명령의 이름을 지정합니다. `/mcp` 설정 목록은 다음을 보고합니다:

```text theme={null}
Can't open MCP settings while no terminal is attached to this background session. This session now shows "needs input" in agent view — open it and run /mcp to manage servers, or use `/mcp enable|disable|reconnect <server>` to steer without the panel.
```

**할 일:**

* 에이전트 뷰에서 세션에 연결하고 명령을 다시 실행합니다.
* 또는 `/mcp reconnect <server>`, `/mcp enable` 또는 `/mcp disable`과 같이 메시지가 명시하는 형식을 사용합니다. 이는 연결하지 않고도 작동합니다.

### 경로를 안전하게 확인할 수 없어서 쓰기 또는 명령이 차단됨

Claude가 [worktree 격리 가드](https://code.claude.com/docs/ko/agent-view.md#how-file-edits-are-isolated)가 하나의 확인 가능한 위치로 확인할 수 없는 철자로 파일 또는 작업 디렉터리를 처리했습니다. 가드는 [worktree에 격리된 모든 세션](https://code.claude.com/docs/ko/worktrees.md#how-claude-code-enforces-isolation)(대화형 또는 백그라운드)과 [worktree 격리 서브에이전트](https://code.claude.com/docs/ko/worktrees.md#isolate-subagents-with-worktrees)에서 쓰기 및 명령 작업 디렉터리를 확인합니다. 공유 체크아웃에 도달하지 않는지 확인하기 전에 심볼릭 링크를 확인하며, 확인이 실패하면 공유 체크아웃에 도달하도록 하는 대신 작업을 차단합니다. 메시지는 거부하는 경로 형식과 재시도 방법을 명시합니다:

```text theme={null}
This write was blocked because the path is spelled in a form that cannot be safely resolved (for example through a symlink storing a raw dot segment, a network-share or device-namespace shape, or an unreadable ancestor directory). If the file is inside the worktree /path/to/worktree, address it by its direct symlink-free path instead.
```

차단된 명령은 작업 디렉터리에 대해 동일한 원인을 보고하고 `re-run the command from its direct symlink-free path`로 끝납니다. v2.1.217 이전에는 가드가 심볼릭 링크를 확인하지 않고 경로 철자를 비교했으므로 이러한 철자는 차단되지 않았으며 심볼릭 링크를 통한 쓰기는 공유 체크아웃에 도달할 수 있었습니다.

**할 일:**

* 일반적으로 아무것도 하지 않습니다: 전체 메시지는 Claude에 도구 오류로 전달되며 Claude는 명시하는 직접 경로로 재시도합니다. 차단된 파일 편집의 경우 대화 뷰에는 짧은 `Error editing file` 줄만 표시됩니다. 전체 메시지는 `Ctrl+O`로 열 수 있는 트랜스크립트 뷰에 나타납니다. 차단된 명령은 명령 출력에 인쇄합니다.
* 같은 파일에서 차단이 반복되면 경로가 `docs/current -> ../README.md`와 같이 `..`를 포함하는 대상을 가진 커밋된 심볼릭 링크를 통해 실행될 가능성이 높습니다. Claude에 링크를 통하지 않고 실제 경로로 대상 파일을 편집하도록 요청합니다.

### 경로가 네트워크 위치를 명시하기 때문에 쓰기 또는 명령이 차단됨

Claude가 머신에 없는 드라이브, `\\server\share\file`과 같은 UNC 공유 또는 `/net` 자동 마운트 경로를 명시하는 경로를 통해 파일 또는 작업 디렉터리를 처리했으며, 세션의 체크아웃은 로컬 디스크에 있습니다. 동일한 [worktree 격리 가드](#write-or-command-blocked-because-the-path-cannot-be-safely-resolved)는 그러한 경로가 공유 체크아웃을 벗어나는지 확인할 수 없으므로 작업을 차단합니다. 세션을 worktree에 격리해도 차단이 해제되지 않습니다. 메시지는 대신 사용할 경로 형식을 명시합니다:

```text theme={null}
This write was blocked because the path is network-shaped (a UNC share or /net automount spelling) while this session's checkout is local. Isolating cannot unblock it. If the file is genuinely inside the worktree /path/to/worktree, address it by its local, plainly-spelled path instead.
```

차단된 명령은 작업 디렉터리에 대해 동일한 원인을 보고하고 `re-run the command from its local, plainly-spelled path`로 끝납니다. v2.1.217 이전에는 가드가 경로 텍스트만 비교했으므로 UNC 또는 `/net` 경로를 통해 체크아웃 내부의 파일을 처리하는 것은 차단되지 않았습니다.

**할 일:**

* 일반적으로 아무것도 하지 않습니다: Claude는 메시지가 요청하는 로컬 철자로 재시도합니다.

### Worktree 격리 확인으로 인해 명령이 차단됨

Claude가 [worktree에 격리된 세션](https://code.claude.com/docs/ko/worktrees.md#how-claude-code-enforces-isolation)에서 Bash, [PowerShell](https://code.claude.com/docs/ko/tools-reference.md#powershell-tool) 또는 [Monitor](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 명령을 실행했으며, Claude Code가 다음 이유 중 하나로 거부했습니다:

* 명령이 주 체크아웃 또는 다른 worktree에서 실행됩니다. 메시지는 작업 디렉터리가 `resolved to the shared checkout` 또는 `is in a different worktree`라고 표시합니다.
* Bash 또는 Monitor 명령이 git을 주 체크아웃으로 지정합니다.
* Claude Code는 Bash 또는 Monitor 명령의 텍스트에서 명령이 실행하는 모든 git이 worktree 내에 머물러 있는지 확인할 수 없습니다. git을 명시하지 않는 명령도 이 이유로 거부될 수 있습니다. `${!name}`과 같은 변수 간접 참조를 확장하거나 `${ command; }`와 같은 Bash 함수 치환을 실행하면 자체가 명령일 수 있는 런타임 값이 생성되기 때문입니다.

메시지는 `is isolated in the worktree <path>, but this command` 뒤에 이유를 표시합니다. 예를 들어 Claude Code가 텍스트를 확인할 수 없는 명령의 경우 다음과 같습니다:

```text wrap theme={null}
This session is isolated in the worktree /path/to/worktree, but this command evaluates ${!x@P} arithmetically inside a construct too complex to verify, which can run a command hidden in a variable's value. Refusing to run it — a worktree-isolated session's git operations must target its own worktree. Split it into plain, separate commands and run them from /path/to/worktree.
```

**할 일:**

* **git이 주 체크아웃을 가리키거나 명령 텍스트를 확인할 수 없는 경우**: 아무것도 하지 않습니다. Claude는 메시지를 읽고 최종 문장이 요청하는 방식으로 명령을 다시 작성합니다. 요청한 명령이 텍스트의 확장 때문에 계속 거부되면 플래그된 값을 문자 그대로 작성하고 worktree 내에서 git을 자체 일반 명령으로 실행합니다.
* 의도적으로 주 체크아웃에 작용하려면 세션 외부의 터미널에서 명령을 직접 실행합니다.

### 이 세션에는 저장된 트랜스크립트가 없습니다

`←` 또는 `/background`로 [백그라운드로 이동한](https://code.claude.com/docs/ko/agent-view.md#from-inside-a-session) 세션이 자체 턴을 실행하기 전에 중지되었으며, 해당 세션에 연결했습니다. Claude Code가 세션을 이동해 온 원래 대화를 찾을 수 없으므로 세션에는 재개할 내용이 없습니다. 메시지는 이 세션에 대한 `claude respawn` 명령으로 끝납니다:

```text theme={null}
This session has no saved transcript — it was stopped before its first response finished. If it was backgrounded from another conversation, that one is still intact; `claude respawn <id>` starts this one fresh.
```

[에이전트 뷰](https://code.claude.com/docs/ko/agent-view.md)에서 같은 세션의 행을 열면 대신 목록 아래에 `Press enter again to restart this session fresh`가 표시되며, 행에서 두 번째 `Enter`를 누르면 빈 대화로 세션을 다시 시작합니다.

**할 일:**

* 중지된 세션을 새로 시작하려면 메시지의 ID로 `claude respawn <id>`를 실행하거나 에이전트 뷰의 행에서 `Enter`를 두 번 누릅니다.
* 세션이 응답을 완료했는데도 v2.1.214 이전 버전에서 이 거부가 표시되면 `~/.claude/projects`의 읽을 수 없는 폴더로 인해 트랜스크립트 스캔이 저장된 대화를 놓칠 수 있습니다. v2.1.214 이상으로 업데이트하면 스캔 중에 읽을 수 없는 폴더를 허용합니다.

### 이 세션이 다른 터미널에서 실행 중입니다

[에이전트 뷰](https://code.claude.com/docs/ko/agent-view.md)에서 중지된 세션의 행을 열었으며, 저장된 대화가 이미 이 머신의 다른 라이브 Claude Code 프로세스에서 열려 있으므로 Claude Code는 같은 트랜스크립트에 쓸 두 번째 프로세스를 시작하기를 거부합니다. 표시되는 메시지는 [대화를 보유한 것](https://code.claude.com/docs/ko/agent-view.md#opening-a-session-says-the-conversation-is-already-open)에 따라 다릅니다:

```text theme={null}
Can't open — this session is running in another terminal
This conversation is already open in another running Claude session — use that one, or close it and try again
```

* **`running in another terminal`**: 터미널이 대화를 보유합니다. 예를 들어 `claude --resume` 또는 `/resume`으로 재개한 터미널입니다. 행에는 `Open in a terminal`도 표시됩니다.
* **`already open in another running Claude session`**: 다른 비대화형 Claude Code 프로세스가 이를 보유합니다. 예를 들어 같은 대화에 대한 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md#the-supervisor-process) 프로세스가 아직 종료되지 않았습니다.

**할 일:**

* 열려 있는 프로세스에서 대화를 계속하거나 해당 프로세스를 종료하고 행을 다시 엽니다.

v2.1.248 이전에는 `already open in another running Claude session` 거부만 존재했습니다: 터미널에서 재개된 대화는 열려 있는 것으로 계산되지 않았으며, 행을 열면 같은 대화에 쓰는 두 번째 Claude Code 프로세스가 시작되었습니다.

### 이 세션의 저장된 대화가 더 이상 디스크에 없습니다

백그라운드 서비스가 꺼져 있는 동안 종료된 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)을 열었으며, [트랜스크립트 정리](https://code.claude.com/docs/ko/settings-reference.md#cleanupperioddays)가 저장된 대화를 제거했습니다. 예를 들어 머신이 몇 주 동안 꺼져 있었습니다. 일반적으로 이러한 행을 열면 [저장된 대화를 재개](https://code.claude.com/docs/ko/agent-view.md#sessions-show-as-failed-after-shutdown)합니다. 재개할 것이 없으면 Claude Code는 묻지 않고 세션의 원래 프롬프트를 다시 실행하는 대신 거부합니다:

```text theme={null}
This session's saved conversation is no longer on disk (it ended while the background service was off, and old transcripts are cleaned up), so there is nothing to resume. `claude rm 7c5dcf5d` deletes the row; `claude respawn 7c5dcf5d` runs its original prompt again instead.
```

`claude attach <id>`는 이 텍스트를 인쇄합니다. 에이전트 뷰에서 바닥글은 더 짧으며 `ctrl+x deletes the row`로 끝납니다.

**할 일:**

* `claude rm <id>`를 실행하여 행을 삭제합니다. [유지된 경우](https://code.claude.com/docs/ko/agent-view.md#what-deleting-a-session-removes) 중 하나가 적용되면 `claude rm`은 행과 worktree를 유지하고 이유를 명시합니다.
* 세션의 원래 프롬프트를 새 대화로 다시 실행하려면 `claude respawn <id>`를 실행합니다.

v2.1.248 이전에는 이러한 행을 열면 거부하는 대신 세션의 원래 프롬프트를 다시 실행했으며, 몇 주 된 작업을 전경으로 끌어올렸습니다.

### Worktree에 어디에도 푸시되지 않은 커밋이 있습니다

Claude Code가 다른 곳에 저장되었는지 확인할 수 없는 커밋을 worktree에 보유한 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md#what-deleting-a-session-removes)을 삭제하려고 했습니다. Claude Code는 커밋을 보지 않고 파괴하는 대신 worktree와 세션 행을 유지합니다. `claude rm`은 브랜치와 푸시되지 않은 커밋을 명시하고 진행 방법을 설명합니다:

```text theme={null}
kept 7c5dcf5d — its worktree is still at “/home/you/project/.claude/worktrees/fix-login”
  2 unpushed commits on “claude/fix-login”: a1b2c3d “Fix login flow” and 1 more. They exist on no remote, so deleting the worktree would lose them.
  push them and run 'claude rm 7c5dcf5d' again, or discard the worktree and its commits: claude rm 7c5dcf5d --discard-unpushed a1b2c3d000000000000000000000000000000000@0123456789abcdef0123456789abcdef
```

Claude Code가 커밋을 요약할 수 없으면 세부 정보 줄에 `The worktree has unpushed commits`가 대신 표시됩니다. [에이전트 뷰](https://code.claude.com/docs/ko/agent-view.md)에서 세션의 행은 `not deleted`를 표시하고 같은 이유를 표시합니다.

원격의 커밋은 삭제를 차단하지 않습니다. `origin` 원격의 기본 브랜치의 로컬 복사본의 커밋도 차단하지 않습니다. 해당 브랜치가 주 체크아웃(저장소 디렉터리 자체, worktree가 아님)에서 체크아웃되어 있는 한.

**할 일:**

* 커밋을 유지하려면 worktree의 브랜치를 푸시하거나 주 체크아웃에서 체크아웃된 기본 브랜치로 병합한 다음 세션을 다시 삭제합니다.
* 커밋을 버리려면 메시지가 인쇄한 `claude rm <id> --discard-unpushed` 명령을 실행하거나 에이전트 뷰의 세션 행에서 `Ctrl+X`를 다시 두 번 누릅니다. 이는 세션과 worktree를 브랜치, 푸시되지 않은 커밋 및 커밋되지 않은 변경 사항과 함께 제거합니다. 삭제가 다시 거부되면 새 메시지를 따릅니다.
* 메시지가 worktree가 다른 완료된 세션에 의해서도 기록되었다고 말하면 다시 삭제해도 버리지 않습니다: 커밋을 푸시한 다음 세션을 다시 삭제합니다.

v2.1.268 이전에는 `claude rm`이 커밋 요약을 `kept` 줄 자체에 배치했습니다. `claude rm`이 커밋을 요약할 수 없으면 `kept` 줄은 요약 대신 `worktree has commits that are not pushed anywhere`를 표시했습니다.

v2.1.260 이전에는 메시지가 브랜치 또는 커밋을 명시하지 않았으며, 버리는 방법도 없었습니다. 그래도 커밋되지 않은 변경 사항은 잃지만 브랜치와 커밋은 유지한 채 세션을 삭제할 수 있습니다. 거부 메시지가 인쇄한 경로로 `git worktree remove --force --force <path>`를 실행한 다음 `claude rm <id>`를 실행합니다. 잠긴 worktree의 경우 Git에는 `--force`가 두 번 필요합니다.

v2.1.248 이전에는 주 체크아웃에서 체크아웃된 기본 브랜치가 계산되지 않았습니다: 이미 병합한 브랜치는 커밋이 원격에 도달할 때까지 이 거부를 트리거했습니다.

### 터미널 호스트 프로세스가 종료됨

각 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)의 터미널은 백그라운드 서비스 아래의 호스트 프로세스에서 실행되며, 서비스가 여전히 연결을 유지하는 동안 해당 프로세스가 종료되어 세션에 도달할 수 없었습니다.

Linux 및 WSL에서 백그라운드 서비스는 몇 초마다 각 호스트 프로세스를 확인하고, 프로세스가 종료되었지만 서비스에 대한 연결이 닫히지 않으면 세션을 실패로 표시하고 [에이전트 뷰](https://code.claude.com/docs/ko/agent-view.md#read-session-state)의 행에 이유를 표시합니다:

```text theme={null}
terminal host process died — press Enter to restart
```

셸에서 `claude attach <id>`는 이미 죽은 호스트로 실패 표시된 세션을 다시 시작하고, 그렇지 않으면 원인을 인쇄하고 종료합니다:

```text theme={null}
Couldn't attach to <id> — This session's terminal host process died (the conversation is saved) — run `claude attach <id>` again to restart it on a fresh host.
```

어느 쪽이든 대화가 저장됩니다.

[셸 명령](https://code.claude.com/docs/ko/agent-view.md#run-a-shell-command)을 실행하는 행은 대신 `terminal host process died — its output is gone; the command was not run again`을 표시하고, `claude attach`는 `This command's terminal host process died — its output is gone and the command was not run again`을 인쇄합니다. Claude Code는 절대 명령을 대신 다시 실행하지 않습니다.

**할 일:**

* 에이전트 뷰에서 실패한 행에 `Enter`를 누릅니다. 세션이 새 호스트 프로세스에서 다시 시작되고 대화가 재개됩니다.
* 셸에서 `claude attach <id>`를 다시 실행합니다. Claude Code는 `Session <id>'s terminal host died — restarting it on a fresh one…`을 인쇄하고 세션을 다시 엽니다.
* 이 방식으로 셸 명령 행을 다시 시작할 수 없습니다. 명령을 다시 디스패치하여 다시 실행합니다.

v2.1.247 이전에는 죽은 호스트 프로세스가 백그라운드 서비스가 실행한 모든 생존 확인을 통과할 수 있었으므로 세션을 열면 `opening… · esc to cancel`이 무한정 표시되고 `claude attach <id>`는 오류를 보고하지 않고 대기했습니다.

### 세션이 응답하지 않습니다

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)을 열었으며 백그라운드 서비스가 열기를 수락했지만 약 10초 동안 출력이 도착하지 않아 Claude Code는 세션의 터미널을 중계하는 프로세스가 출력을 전달할 수 없다고 결론짓고 대기하는 대신 시도를 종료합니다.

에이전트 뷰에서 Claude Code는 바닥글에 재시작을 제공합니다:

```text theme={null}
Press enter again to restart this session — it isn't responding (its conversation is saved and resumes).
```

셸에서 `claude attach <id>`는 원인을 인쇄하고 종료합니다:

```text theme={null}
Couldn't attach to <id> — Session isn't responding — `claude stop <id>`, then `claude attach <id>` restarts it (the conversation is saved).
```

Claude Code는 [셸 명령](https://code.claude.com/docs/ko/agent-view.md#run-a-shell-command)을 실행하는 행을 절대 다시 시작하지 않습니다. 재시작하면 명령이 다시 실행되기 때문입니다.

**할 일:**

* 에이전트 뷰에서 같은 행에 `Enter`를 다시 누릅니다. Claude Code는 응답하지 않는 프로세스를 중지하고 세션을 다시 시작하며 대화가 재개됩니다. 두 번째 누름 없이는 아무것도 중지되지 않습니다.
* 셸에서 `claude stop <id>`를 실행한 다음 `claude attach <id>`를 실행합니다.
* 셸 명령 행의 경우 에이전트 뷰에서 `Ctrl+X`를 누르거나 `claude stop <id>`를 실행하여 중지합니다. 명령을 다시 디스패치하여 다시 실행합니다.

### 재시작이 진행 중인 동안 세션이 중지됨

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)을 열었으며 해당 프로세스가 실행 중이 아니었고, Claude Code가 이를 다시 시작하는 동안 다른 Claude Code 프로세스가 이를 중지했습니다. 예를 들어 다른 터미널에서 `claude stop`을 실행했습니다. Claude Code는 세션을 중지된 상태로 유지합니다:

```text theme={null}
Session <id> was stopped while the respawn was in flight
```

방금 디스패치한 세션을 열면서 프로세스가 여전히 시작 중인 동안 프로세스가 시작될 때까지 대기합니다. v2.1.246 이전에는 그 순간에 열면 중지되고 이 메시지가 표시될 수 있었습니다.

**할 일:**

* 세션을 중지하지 않았으면 에이전트 뷰에서 행을 다시 열거나 `claude respawn <id>`를 실행하여 다시 시작합니다.
* 직접 중지했으면 남은 것이 없습니다: 세션은 중지된 상태로 유지됩니다.

### 세션 에이전트를 더 이상 사용할 수 없습니다

[사용자 정의 에이전트](https://code.claude.com/docs/ko/sub-agents.md#invoke-subagents-explicitly)를 실행 중이던 세션을 재개했으며, `--agent` 또는 `agent` 설정으로 시작했으며, Claude Code가 해당 이름의 에이전트를 찾지 못했습니다. 세션의 원래 디렉터리를 먼저 검색하며, [해당 워크스페이스를 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)한 경우, 그 다음 재개하는 디렉터리를 검색합니다. 세션은 여전히 재개되지만 기본 도구를 사용하므로 에이전트의 도구 제한이 더 이상 적용되지 않습니다:

```text theme={null}
This session was running agent 'code-reviewer', which is no longer available (no agent by that name in /home/you/project). Continuing with the default tools and system prompt — the agent's tool restrictions no longer apply. To restore it, re-create the agent, or resume with an explicit --agent <name>.
```

경고는 Claude Code가 검색한 디렉터리만 명시하며, [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)을 깨우거나, `/resume` 또는 `claude --resume`을 실행하거나, [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 재개할 때 재개된 대화에 나타나며, 비대화형 모드에서는 stderr로도 출력됩니다. `--input-format stream-json`을 사용하는 세션은 Agent SDK가 시작 후 에이전트를 제공하므로 표시하지 않습니다.

Claude Code는 폴백을 세션에 저장하지 않으므로 경고는 조치할 때까지 각 재개에서 반복됩니다. 기본 제공 `claude` 에이전트는 기본 도구 세트로 폴백해도 아무것도 변경되지 않으므로 경고를 트리거하지 않습니다. v2.1.216 이전에는 Claude Code가 기본 에이전트로 자동으로 계속했으며, 조회는 재개하는 디렉터리만 포함했으므로 프로젝트 범위 에이전트는 다른 디렉터리에서 재개할 때 손실되었습니다.

**할 일:**

* 세션의 프로젝트에서 `.claude/agents/<name>.md`에 또는 개인 에이전트의 경우 `~/.claude/agents/<name>.md`에 에이전트 파일을 다시 만든 다음 다시 재개합니다.
* 또는 존재하는 에이전트를 명시하는 `--agent <name>`으로 재개하여 대신 해당 에이전트로 세션을 실행합니다.
* 에이전트가 프로젝트 범위이고 세션의 원래 디렉터리를 신뢰하지 않았으면 거기서 Claude Code를 한 번 실행하고 신뢰 대화 상자를 수락한 다음 다시 재개합니다.

### 다음 /loop 깨우기 예정 시간이 지난 후 이 세션이 다시 시작됨

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)의 [자체 페이스 `/loop`](https://code.claude.com/docs/ko/scheduled-tasks#let-claude-choose-the-interval)가 중지되었습니다. 루프가 다음 깨우기를 기다리는 동안 세션의 프로세스가 종료되었고, 세션의 [다음 프로세스](https://code.claude.com/docs/ko/agent-view.md#the-supervisor-process)가 시작되기 전에 해당 깨우기 예정 시간이 지났습니다. 놓친 깨우기는 늦게 실행되지 않습니다. 알림은 세션이 다시 시작되었을 때 깨우기가 얼마나 지연되었는지 표시합니다:

```text theme={null}
This session restarted 12m after its next /loop wakeup was due, so that wakeup will not fire. The loop stays stopped until Claude schedules it again: reply to continue it.
```

v2.1.295 이전에는 이 상황에서 알림 없이 루프가 중지되었습니다.

**할 일:**

* 루프를 계속하려면 [세션에 답장](https://code.claude.com/docs/ko/agent-view.md#peek-and-reply)하여 `keep the loop running`과 같이 그렇게 말합니다. Claude는 답장과 함께 알림을 읽고 다음 깨우기를 예약할 수 있습니다.
* 루프를 더 이상 사용하지 않으려면 아무것도 하지 않습니다. 루프는 이미 중지되었습니다.

### No LLM gateway: a gateway set in your shell isn't passed to a session opened from another folder

이 메시지를 표시하는 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)은 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 사용하지 않습니다. 게이트웨이 주소를 받지 못했으므로 요청이 실패합니다. 메시지는 Claude의 응답 대신 대화에 나타나며, 세션의 ID와 폴더가 채워져 있습니다:

```text wrap theme={null}
No LLM gateway: a gateway set in your shell isn't passed to a session opened from another folder. To fix, run `claude respawn abc12345` from ~/project in another terminal where your gateway is set, or set ANTHROPIC_BASE_URL and its API key or token in a settings file's env block.
```

세션에 연결되어 있는 동안 프롬프트 아래의 알림에는 짧은 형식인 `No LLM gateway: opened from another folder · respawn from ~/project`가 표시됩니다.

`ANTHROPIC_BASE_URL`이 게이트웨이로 설정된 상태에서 메시지가 명시하는 폴더가 아닌 다른 폴더에서 세션을 디스패치하거나, 깨우거나, 다시 시작했습니다. 셸에서 내보낸 게이트웨이가 백그라운드 세션에 전달되는 경우는 [LLM 게이트웨이](https://code.claude.com/docs/ko/agent-view.md#llm-gateway)를 참조하십시오.

**할 일:**

* **설정에서 게이트웨이를 지정하는 프로젝트에서 에이전트 뷰를 사용한 경우**: `ANTHROPIC_BASE_URL`과 해당 API 키 또는 토큰을 [설정 파일의 `env` 블록](https://code.claude.com/docs/ko/llm-gateway-connect#set-in-a-settings-file)에 넣습니다. `~/.claude/settings.json` 또는 세션 자체 프로젝트의 `.claude/settings.local.json`을 사용하십시오. 둘 다 다시 시작된 세션이 읽는 파일입니다. 그런 다음 아무 폴더에서나 셸에서 `claude respawn <id>`를 실행합니다.
* **터미널에서 게이트웨이를 내보낸 경우**: 게이트웨이 변수를 내보낸 터미널에서 메시지가 명시하는 폴더로 `cd`한 다음 메시지의 `claude respawn <id>` 명령을 실행합니다. 세션은 저장된 대화에서 다시 시작됩니다.
  * 게이트웨이는 [슈퍼바이저](https://code.claude.com/docs/ko/agent-view.md#the-supervisor-process) 자체가 같은 게이트웨이를 내보낸 셸에서 시작된 경우에만 세션에 전달됩니다. 그렇지 않은 경우 [`Could not resolve authentication method`로 디스패치가 실패하는 경우](https://code.claude.com/docs/ko/agent-view#dispatch-fails-with-could-not-resolve-authentication-method)에 설명된 대로 해당 터미널에서 슈퍼바이저를 다시 시작한 다음 respawn 명령을 다시 실행합니다.

v2.1.302 이전에는 이 상황의 백그라운드 세션이 폴더를 명시하지 않고 대신 [`Not logged in · Please run /login`](#not-logged-in)과 같은 로그인 오류를 표시했습니다.

### CLAUDE\_CODE\_PROCESS\_WRAPPER 런처 오류

[`CLAUDE_CODE_PROCESS_WRAPPER`](https://code.claude.com/docs/ko/corporate-launcher)가 설정되었으며 해당 값을 사용할 수 없으므로 Claude Code는 런처 없이 실행하는 대신 영향을 받는 프로세스를 시작하기를 거부합니다. 구성 문제는 변수 이름으로 시작하고 이유를 명시하는 메시지로 보고됩니다. 예를 들어:

```text theme={null}
CLAUDE_CODE_PROCESS_WRAPPER: launcher `/opt/corp/launcher` is not an executable regular file
```

시작하지만 Claude Code로 자신을 대체하지 않고 종료하는 런처는 시작 중이던 세션을 실패하게 하며, 에이전트 뷰의 세션 행은 런처가 `must exec, not daemonize`라고 보고하고 런처가 인쇄한 모든 것을 따릅니다. 런처 때문에 시작할 수 없거나 백그라운드 서비스에 도달할 수 없는 세션은 `Couldn't reach the background service (...)`의 이유로 런처 문제를 보고합니다.

**할 일:**

* 변수를 `exec "$@"`를 호출하여 끝나는 실행 파일의 절대 경로로 설정합니다. 전체 계약은 [런처 계약](https://code.claude.com/docs/ko/corporate-launcher.md#the-launcher-contract)을 참조하십시오.
* `/status`를 확인하면 자체 실행 항목에서 확인된 시작 명령을 표시하고 실행 중인 백그라운드 서비스가 일치하지 않을 때 경고하거나, 셸에서 `claude daemon status`를 실행합니다.
* [설정](https://code.claude.com/docs/ko/corporate-launcher.md#set-up-the-launcher)의 `env` 블록에서 값을 수정한 후 `claude daemon stop --any`로 백그라운드 서비스를 다시 시작하여 다음 디스패치가 래핑된 것을 시작하도록 합니다.

### 백그라운드 세션을 시작할 때 EUNKNOWN

Windows가 표준 이름이 없는 오류 코드로 프로그램을 시작하기를 거부했으므로 실패는 `EUNKNOWN`으로 표시됩니다. 일반적인 트리거는 시작 중인 프로그램을 차단하는 그룹 정책 또는 AppLocker와 같은 소프트웨어 제한 정책입니다. 오류는 `/background` 또는 `claude --bg`로 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)을 시작할 때 나타납니다:

```text theme={null}
Couldn't reach the background service (spawn background service: EUNKNOWN: unknown error, uv_spawn) — run 'claude daemon status'
```

일부 계정에서 메시지는 `background service` 대신 `daemon`을 말합니다.

npm 설치에서 `npm install -g @anthropic-ai/claude-code`가 바이너리를 대체하는 동안 나타나는 `EUNKNOWN`은 [재설치 중 `EACCES`](#eacces-when-starting-a-background-session)와 같은 원인을 가지며 설치가 완료된 후 재시도할 때 지워집니다.

Claude Code는 서비스가 터미널을 닫을 때 생존하도록 PowerShell을 통해 백그라운드 서비스를 시작하며, PowerShell 7이 설치되어 있으면 PowerShell 7을 사용하고 그렇지 않으면 Windows PowerShell 5.1을 사용합니다. 어느 PowerShell도 실행될 수 없으면 Claude Code는 대신 서비스를 직접 시작하므로 PowerShell만 차단하는 정책은 이 오류를 발생시키지 않습니다.

v2.1.212 이전에는 Claude Code가 Windows PowerShell 5.1만 사용하여 서비스를 시작했으므로 그룹 정책이 PowerShell 5.1을 차단한 모든 머신이 PowerShell 7이 설치되어 있어도 `Couldn't start the session — EUNKNOWN: unknown error, uv_spawn`으로 실패했습니다.

**할 일:**

* 메시지가 `Couldn't start the session`이면 v2.1.212 이상으로 업그레이드합니다. 이전 버전에서는 별도의 터미널에서 `claude daemon run`을 먼저 실행한 다음 백그라운드 세션을 다시 시작할 수 있습니다. 해당 명령은 백그라운드 서비스를 터미널의 전경에서 실행하므로 서비스는 해당 터미널이 열려 있는 동안만 지속됩니다.
* npm 설치가 바이너리를 대체 중이면 완료될 때까지 기다린 다음 백그라운드 세션을 다시 시작합니다.
* npm 설치가 실행 중이 아닌 동안 v2.1.212 이상에서 오류가 나타나면 제한 정책이 Claude Code 실행 파일을 차단하는지 Windows 관리자에게 확인합니다.
* 터미널을 닫을 때 백그라운드 서비스가 중지되면 Claude Code는 PowerShell 없이 시작했습니다. PowerShell 7을 설치하거나 관리자에게 PowerShell을 차단 해제하도록 요청하여 서비스가 터미널보다 오래 유지될 수 있도록 합니다.

### 백그라운드 세션을 시작할 때 EACCES

Claude Code는 백그라운드 세션을 호스팅하는 [백그라운드 서비스](https://code.claude.com/docs/ko/agent-view.md#the-supervisor-process)를 시작하기 위해 자신의 바이너리를 실행할 수 없었습니다. npm 설치에서 이는 일반적으로 `npm install -g @anthropic-ai/claude-code`가 그 순간에 바이너리를 대체했다는 의미입니다. 직접 실행했든 [자동 업데이터](https://code.claude.com/docs/ko/setup.md#auto-updates)가 실행했든 상관없습니다. 오류는 [에이전트 뷰](https://code.claude.com/docs/ko/agent-view.md)에서 세션을 열 때 나타납니다:

```text theme={null}
Couldn't start the background service — spawn background service: EACCES: permission denied, posix_spawn '/usr/local/lib/node_modules/@anthropic-ai/claude-code/bin/claude'
```

`/background` 또는 `claude --bg`로 세션을 시작하면 같은 이유가 `Couldn't reach the background service (...)`에 나타납니다. 같은 재설치 창 동안 오류는 `ENOENT` 또는 `ENOEXEC`과 같은 다른 코드를 명시할 수 있으며, Windows에서는 `EUNKNOWN` 또는 `EPERM`을 명시할 수 있습니다. 재시도 전체에서 지속되는 `EUNKNOWN`은 [다른 원인](#eunknown-when-starting-a-background-session)을 가집니다.

npm 설치에서 Claude Code는 재설치가 완료될 때까지 대기하고 자동으로 재시도합니다: 최대 10초, 그리고 Claude Code의 npm 설치가 머신에서 여전히 명백히 실행 중인 동안 최대 2분입니다. 이는 다른 Claude Code 프로세스가 업데이트를 다운로드하는 것을 포함합니다. 설치가 해당 대기를 초과하면 실패는 베어 오류 코드 대신 업데이트를 명시합니다:

```text theme={null}
Claude Code is being updated by npm on this machine (still not runnable after 2 min, EACCES) — try again when the update finishes
```

v2.1.257 이전에는 대기가 모든 경우에 10초에서 중지되었으므로 다른 Claude Code 프로세스가 여전히 업데이트를 다운로드하는 동안 이 오류가 나타났습니다. v2.1.246 이전에는 Claude Code가 즉시 실패했으며 대기하지 않았습니다.

**할 일:**

* 몇 초 기다린 다음 세션을 열거나 다시 디스패치합니다. 메시지가 Claude Code가 업데이트 중이라고 말하면 업데이트가 완료된 후 재시도합니다.
* npm 설치가 실행 중이 아닌 동안 오류가 지속되면 사용자가 설치된 바이너리를 실행할 수 없습니다. 바이너리와 해당 디렉터리의 권한을 확인하거나 Claude Code를 다시 설치합니다.

### 백그라운드 서비스가 도달 가능해지기 전에 종료됨

Claude Code가 [백그라운드 서비스](https://code.claude.com/docs/ko/agent-view.md#the-supervisor-process)로 시작한 프로세스가 연결을 수락하기 전에 종료되어 Claude Code가 세션을 열 수 없었습니다. 서비스가 종료되기 전에 오류를 인쇄했으면 괄호의 이유는 종료 코드 또는 신호와 서비스가 인쇄한 첫 번째 줄을 제공하며, 이는 중지된 원인을 명시합니다:

```text theme={null}
Couldn't reach the background service (background service exited before it became reachable (exit code N): <the service's first error line>) — run 'claude daemon status'
```

[에이전트 뷰](https://code.claude.com/docs/ko/agent-view.md)에서 세션을 열 때 같은 이유가 `Couldn't start the background service —` 뒤에 나타납니다. 서비스가 종료되기 전에 아무것도 인쇄하지 않으면 메시지는 `nothing on stderr`을 대신 말합니다.

Claude Code는 서비스의 오류 줄로 실패를 보고합니다. v2.1.246 이전에는 실패가 45초 대기 후에만 표시되었으며, `background service did not become reachable within 45s`로 서비스의 오류 줄 없이 표시되었습니다.

두 인용된 이유는 알려진 원인을 가집니다:

* `Error: claude native binary not installed.`: npm 설치가 그 순간에 Claude Code 바이너리를 대체했으므로 서비스가 npm의 자리 표시자를 대신 실행했습니다. 설치가 완료된 후 재시도합니다. 설치가 실행 중이 아닌 동안 줄이 지속되면 [npm 설치를 완료](https://code.claude.com/docs/ko/troubleshoot-install.md#native-binary-not-found-after-npm-install)합니다. v2.1.257 이전에는 macOS npm 자체 업데이트가 설치 창 동안 모든 시작에서 이 실패를 생성했습니다.
* Windows에서 모든 시작에서 종료 코드 1로 `nothing on stderr`: `daemon.lock`은 Claude Code가 신호를 보낼 수도 없고 종료되었음을 증명할 수도 없는 프로세스를 명시하므로 각 새 서비스는 다른 서비스가 잠금을 보유한다고 결론짓고 종료합니다. Claude Code가 작성자가 종료되었음을 증명할 수 있는 잠금은 자동으로 대체되며 이 실패를 생성하지 않습니다. 실패가 모든 시작에서 반복되면 `~/.claude/daemon.lock`을 삭제한 다음 세션을 열거나 다시 디스패치합니다. v2.1.257 이전에는 그러한 잠금이 파일을 삭제할 때까지 모든 시작을 차단했습니다.

**할 일:**

* 메시지가 줄을 인용하면 명시하는 것을 수정한 다음 세션을 열거나 다시 디스패치합니다. 다음 시도는 서비스를 다시 시작합니다.
* `claude daemon status`를 실행하여 서비스가 지금 실행 중인지 확인합니다.

### 백그라운드 세션을 시작할 때 작업 디렉터리가 더 이상 존재하지 않음

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)을 시작한 디렉터리가 세션이 시작되는 동안 제거되었습니다. Claude Code는 세션을 시작하지 않으며 메시지는 누락된 디렉터리를 명시합니다:

```text theme={null}
Couldn't start a background session (working directory no longer exists or is not accessible: /tmp/demo)
```

v2.1.257 이전에는 세션이 시작된 것처럼 보였다가 에이전트 뷰에서 같은 이유로 실패한 행으로 표시되었습니다.

v2.1.281 이전에는 이 메시지가 세션을 시작하기 전에 디렉터리가 이미 없었을 때도 나타났습니다. 그 경우는 [`could not be resolved on disk`](#workspace-not-trusted-when-dispatching-a-background-session)를 보고합니다.

**할 일:**

* 메시지가 명시하는 디렉터리를 다시 만들거나 존재하는 디렉터리에서 디스패치한 다음 다시 시도합니다.

### 백그라운드 세션을 디스패치할 때 워크스페이스를 신뢰하지 않음

[신뢰하지 않은](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust) 디렉터리에서 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)을 시작하거나 다시 시작했으며, 워크스페이스 신뢰 대화 상자가 나타나 확인을 요청할 수 없었습니다. Claude Code는 세션을 시작하지 않습니다:

```text theme={null}
Workspace not trusted. Run `claude` in /path/to/project once and accept the trust prompt, then retry.
```

세션의 자체 디렉터리의 터미널에서 같은 명령은 신뢰 대화 상자를 대신 표시하고 수락하면 세션을 시작합니다. 이 메시지는 스크립트와 같이 대화 상자가 나타날 수 없는 곳이나 세션 자체 디렉터리가 아닌 다른 디렉터리에서 세션을 다시 시작할 때 나타납니다.

두 가지 변형은 다른 원인을 명시합니다:

* **`The home directory is trusted one session at a time`**: 세션의 디렉터리는 홈 디렉터리입니다. Claude Code는 홈 디렉터리에 대한 신뢰를 절대 저장하지 않으므로 이전 세션에서 그곳의 대화 상자를 수락해도 계산되지 않습니다.
* **`<path> could not be resolved on disk`**: Claude Code가 디스크에서 세션의 디렉터리를 찾을 수 없었습니다.

v2.1.286 이전에는 Windows에서 신뢰 기록이 다른 대소문자의 경로로 저장된 경우 이미 신뢰한 디렉터리에서도 이 메시지가 나타날 수 있었습니다. v2.1.286 이상으로 업데이트하십시오.

**할 일:**

* 메시지가 명시하는 디렉터리에서 `claude`를 실행하고 신뢰 대화 상자를 수락한 다음 명령을 다시 실행합니다.
* 홈 디렉터리 메시지의 경우 홈 디렉터리의 터미널에서 명령을 실행하여 대화 상자가 나타날 수 있도록 하거나 프로젝트 디렉터리에서 대신 세션을 시작합니다.
* `could not be resolved on disk` 메시지의 경우 디렉터리를 다시 만들거나 존재하는 디렉터리에서 새 세션을 시작합니다.

## 래퍼 및 IDE 오류

이러한 오류는 Claude Code 자체가 아니라 IDE 확장 프로그램이나 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) 애플리케이션과 같이 Claude Code를 실행한 프로그램에서 발생합니다.

### Claude Code 프로세스가 코드 N으로 종료됨

기본 `claude` 프로세스가 0이 아닌 코드로 종료되었습니다. 종료 코드만으로는 무엇이 실패했는지 알 수 없습니다. 실제 오류는 프로세스 자체의 출력에 있으며, 래퍼가 캡처한 경우 이를 추가하고 그렇지 않으면 로그에 유지합니다.

```text theme={null}
Error: Claude Code process exited with code 1
```

Windows에서 기본 빌드는 턴이 완료된 직후 코드 `4294967295`로 종료될 수 있습니다. 해당 종료가 턴 경계에서 발생하고 대기 중인 메시지가 없으며 백그라운드 작업이 실행 중이 아닐 때 [VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md)은 이 오류를 표시하지 않고 세션을 조용히 닫습니다. 다음 메시지는 대화를 재개합니다.

v2.1.273 이전에는 확장 프로그램이 아무것도 손실되지 않았음에도 불구하고 모든 턴 경계에서 해당 종료에 대한 오류를 표시했습니다.

**수행할 작업:**

* VS Code에서 오류와 함께 표시되는 **View output logs** 링크를 따라 기본 오류를 확인합니다.
* Agent SDK 애플리케이션에서 메시지 루프 주변의 오류를 캡처합니다. [CLI 프로세스 종료](https://code.claude.com/docs/ko/agent-sdk/troubleshooting.md#cli-process-exit) 아래의 항목은 각 SDK 언어에서 코드가 수신하는 내용을 다룹니다.
* 터미널에서 동일한 프로젝트에서 `claude`를 실행합니다. 오류는 일반적으로 실제 오류 메시지와 함께 재현되며, 이를 이 페이지에서 조회할 수 있습니다.
* 터미널에서 `claude doctor`를 실행하여 설치 및 구성을 확인합니다.

### PATH에서 Claude CLI를 찾을 수 없음

[VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md)은 Windows에서 통합 터미널에서 Claude Code를 열 때, 터미널의 셸이 PowerShell이고 확장 프로그램이 PATH에서 설치된 `claude` 실행 파일을 찾을 수 없을 때 이 오류를 표시합니다. 확장 프로그램은 PATH에서 설치된 `claude`를 찾을 때까지 Claude Code 실행을 거부합니다.

```text theme={null}
Failed to run Claude Code: Error: Could not locate the Claude CLI on PATH. Launching by name in a PowerShell terminal would run a 'claude' from the open folder instead of the installed CLI, so the launch was blocked. Make sure the Claude CLI's install directory is on your system PATH (not only your PowerShell profile), then restart VS Code and try again. VS Code reads PATH when it starts, so PATH changes take effect only after a restart.
```

**수행할 작업:**

* VS Code 외부에서 새 PowerShell 창을 열고 `where.exe claude`를 실행합니다. 경로를 출력하지 않으면 CLI가 PATH에 없습니다. [PATH 확인](https://code.claude.com/docs/ko/troubleshoot-install.md#verify-your-path)을 따라 설치 디렉터리를 추가합니다. 경로를 출력하면 항목은 PowerShell 프로필에서 오거나 VS Code가 아직 반영하지 않은 PATH 변경에서 옵니다. 다음 두 단계는 이러한 경우를 다룹니다.
* PowerShell 프로필이 아닌 사용자 또는 시스템 환경 변수로 PATH 항목을 설정합니다. 확장 프로그램은 프로필을 실행하지 않으므로 거기에만 있는 PATH 편집은 절대 도달하지 않습니다.
* PATH를 변경한 후 VS Code를 다시 시작합니다. 확장 프로그램은 VS Code가 시작할 때 캡처한 PATH를 확인하므로 PATH 변경은 다시 시작한 후에만 적용됩니다.

### The Claude Code program for this computer could not be found

[VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md)이 내부에 번들된 Claude Code 사본을 찾았지만 현재 컴퓨터용으로 빌드된 사본이 없습니다. 메시지에는 컴퓨터에 필요한 빌드가 표시됩니다.

```text theme={null}
The Claude Code program for this computer, the Linux (linux-x64) build, could not be found.
```

**수행할 작업:**

* 메시지에 확장 프로그램이 포함하고 있는 빌드가 명시되어 있으면 다른 플랫폼용 확장 프로그램 패키지를 설치한 것입니다. 메시지에 표시된 빌드용으로 만들어진 패키지를 설치합니다.
* 메시지에 확장 프로그램이 포함하고 있는 빌드가 명시되어 있지 않으면 편집기의 Extensions 뷰에서 Claude Code 확장 프로그램을 다시 설치합니다.
* 또는 두 경우 모두 [`claudeCode.claudeProcessWrapper`](https://code.claude.com/docs/ko/vs-code#extension-settings)를 별도로 설치한 `claude` 바이너리로 설정합니다.

v2.1.290 이전에는 이 오류가 `Unsupported platform: <platform>-<arch>. No compatible Claude Code binary found.`로 표시되었습니다.

### Claude Code로의 연결이 이 메시지가 완료되기 전에 종료됨

[VS Code 확장 프로그램](https://code.claude.com/docs/ko/vs-code.md)이 메시지를 `claude` 프로세스로 보냈고, 프로세스가 이를 인정하거나 완료하기 전에 오류 없이 연결이 종료되었습니다. 확장 프로그램은 메시지가 처리되었는지 여부를 알 수 없으므로 다시 보내도록 요청합니다.

```text theme={null}
The connection to Claude Code ended before this message completed — it may not have been processed, so please send it again.
```

**수행할 작업:**

* 메시지를 다시 보냅니다. 다음 메시지는 대화를 재개하는 새로운 `claude` 프로세스를 시작합니다.
* 반복되면 동일한 프로젝트의 터미널에서 `claude`를 실행합니다. 프로세스를 계속 종료하는 오류는 일반적으로 실제 오류 메시지와 함께 재현됩니다.

## 되돌리기 경고 및 오류

이 메시지들은 [`/rewind`](https://code.claude.com/docs/ko/checkpointing) 코드 복원에서 나옵니다. `Restored the code, but skipped N files`는 Claude Code가 일부 경로를 건너뛰었다는 경고입니다. `No files were restored`는 아무것도 복원하지 못했다는 의미의 오류입니다.

### 코드는 복원되었지만 파일을 건너뜀

`/rewind` 코드 복원이 추적된 경로 중 하나 이상을 작성하거나 삭제하지 않고 건너뛰었습니다. Claude Code는 다음과 같은 경우에 경로를 건너뜁니다:

* 심볼릭 링크, 하드 링크 또는 기타 일반 파일이 아닌 경우
* 체크포인트 이후 디렉토리가 변경된 경우
* 백업을 안전하게 읽을 수 없는 경우

건너뛴 경로는 현재 내용을 유지합니다. v2.1.216 이전에는 `/rewind`가 추적된 경로의 링크를 통해 작성하고 삭제했으며, 부분 복원을 보고하지 않았습니다.

```text theme={null}
Restored the code, but skipped 2 files: the tracked path is (or became) a link or other non-regular file, its directory changed since the checkpoint, or its backup could not be safely read. Skipped files were left untouched — run with --debug for the paths.
```

**해야 할 일:**

* 건너뛴 파일을 식별하여 아래 단계로 각각을 처리할 수 있도록 합니다. 메시지는 개수만 제공하므로, 복원이 실행될 때 건너뛴 각 경로를 이름으로 나열하는 디버그 로그 `~/.claude/debug/<session-id>.txt`를 확인하고, 다음 복원 전에 `/debug`로 디버그 로깅을 켭니다. macOS 또는 Linux에서는 대신 링크를 직접 찾을 수 있습니다: 심볼릭 링크는 `find . -type l`, 하드 링크된 파일은 `find . -type f -links +1`을 사용합니다.
* 건너뛴 파일이 dotfile 관리자가 관리하는 설정 파일이나 pnpm과 같은 도구로 하드 링크된 파일처럼 의도적으로 만든 링크인 경우, 되돌리기는 해당 내용을 그대로 두었습니다. 세션의 변경 사항을 취소하려면 Claude에게 편집을 되돌리도록 요청하거나 파일을 직접 편집합니다.
* 링크를 만들지 않았다면, 해당 경로의 내용을 신뢰하기 전에 검사합니다.

### 파일이 복원되지 않음

Claude Code는 [`/rewind`](https://code.claude.com/docs/ko/checkpointing)로 코드를 복원할 때 해당 체크포인트의 파일 중 어느 것도 복원할 수 없으면 이 메시지를 표시합니다. 각 파일에 대해 Claude Code가 편집하기 전에 저장한 백업이 누락되었거나, Claude Code가 파일을 작성하거나 삭제할 수 없습니다.

```text theme={null}
Failed to restore the code:
No files were restored: 1 file failed (backup missing, or the file could not be updated)
```

Claude Code는 [보존 스윕](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)에서 세션의 백업을 삭제하며, 기본적으로 세션이 마지막으로 저장한 후 약 30일 후입니다. 그 이후에 세션을 재개하면 `/rewind`는 여전히 체크포인트를 나열하지만, 그 중 하나로 되돌리면 이 오류로 실패할 수 있습니다. 메시지에 `N paths were skipped for link safety`도 표시되면, 해당 경로에 대해 [코드는 복원되었지만 파일을 건너뜀](#restored-the-code-but-skipped-files)을 참조합니다.

세션을 포크할 때, 예를 들어 [`--fork-session`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 또는 [`/branch`](https://code.claude.com/docs/ko/sessions#branch-a-session)를 사용하면, Claude Code는 원본 세션의 백업을 포크로 복사합니다. Claude Code가 백업을 복사할 수 없을 때, 예를 들어 디스크가 가득 찼을 때, 해당 백업은 포크에서 누락됩니다. 이를 필요로 하는 체크포인트로 되돌리면 이 오류로 실패할 수 있습니다.

**해야 할 일:**

* 다른 방법으로 변경 사항을 취소합니다: Claude에게 편집을 되돌리도록 요청하거나, 버전 제어에서 파일을 복원합니다. 백업이 없으면 `/rewind`를 다시 실행해도 같은 방식으로 실패합니다.
* Claude Code가 파일을 작성하거나 삭제할 수 없으면, 파일 권한과 같이 작성을 차단하는 것을 수정한 후 `/rewind`를 다시 실행합니다.
* 향후 세션에서 백업을 더 오래 유지하려면 [`cleanupPeriodDays`](https://code.claude.com/docs/ko/settings-reference#cleanupperioddays)를 높입니다.

v2.1.260 이전에는 Claude Code가 백업이 누락된 파일을 자동으로 건너뛰었으며, 되돌리기가 성공한 것처럼 보였습니다.

## 세션 저장 경고

Claude Code는 세션 트랜스크립트를 저장하지 않을 때 입력 상자 아래의 지속적인 줄에 이러한 경고를 표시합니다. 세션은 어느 쪽이든 계속 작동합니다. 경고는 나중에 [`--resume`](https://code.claude.com/docs/ko/sessions)에서 세션이 누락될 수 있음을 알려줍니다.

### 트랜스크립트 쓰기가 실패하고 있습니다

Claude Code는 작업할 때 트랜스크립트를 디스크에 저장하며, [트랜스크립트 파일](https://code.claude.com/docs/ko/sessions.md#where-transcripts-are-stored)에 대한 쓰기가 실패하고 있습니다. 메시지는 원인을 기본 오류 코드와 함께 이름 지정합니다. 예를 들어 디스크가 가득 찬 경우:

```text theme={null}
Transcript writes are failing (disk full — ENOSPC) · recent messages may not be saved for resume
```

경고는 오류에 따라 다른 지점에 나타납니다:

* 자체적으로 해결되지 않는 조건의 첫 번째 실패: 디스크 가득 참, 디스크 할당량 초과, 읽기 전용 파일 시스템, 파일 시스템의 길이 제한을 초과하는 경로, 또는 macOS 및 Linux에서 권한 오류
* 최소 1분에 걸친 반복 실패(다른 모든 경우 포함): Windows의 권한 오류(바이러스 백신 스캔이 단일 쓰기를 실패하게 한 후 재시도 시 성공할 수 있음)

v2.1.217 이전에는 Claude Code가 경고 없이 실패한 쓰기를 삭제했으며, 나중에 `--resume`에서 최근 메시지가 누락된 것이 첫 번째 신호였습니다.

**할 일:**

* 오류 코드가 이름 지정하는 조건을 수정합니다: `ENOSPC`의 경우 디스크 공간 확보; `EDQUOT`의 경우 할당량 올리기 또는 지우기; `EACCES`, `EPERM` 또는 `EROFS`의 경우 트랜스크립트 위치에 대한 쓰기 액세스 복구
* 경고는 다음 성공적인 쓰기에서 자동으로 지워집니다. 재시작이 필요하지 않습니다.
* 경고가 표시되는 동안 전송된 메시지는 나중에 세션을 재개할 때 여전히 누락될 수 있습니다.

### CLAUDE\_CODE\_SKIP\_PROMPT\_HISTORY가 설정되어 있어서 트랜스크립트 저장이 꺼져 있습니다

이 세션은 [`CLAUDE_CODE_SKIP_PROMPT_HISTORY`](https://code.claude.com/docs/ko/env-vars)가 설정된 상태로 시작되었으므로 Claude Code는 이에 대한 트랜스크립트나 프롬프트 기록을 작성하지 않습니다:

```text theme={null}
Transcript saving is off — CLAUDE_CODE_SKIP_PROMPT_HISTORY is set · --resume will not find this session; if unintended, unset it and restart
```

이 변수는 임시 스크립팅된 세션에 대한 의도적인 옵트아웃이지만, 셸 프로필, 래퍼 스크립트 또는 이를 내보낸 부모 프로세스를 통해 세션에 도달할 수도 있습니다.

**할 일:**

* 의도적으로 변수를 설정한 경우 조치가 필요하지 않습니다. 공지는 세션이 `--resume`, `--continue` 또는 위쪽 화살표 기록에 나타나지 않음을 확인합니다.
* 그렇지 않은 경우 `claude`를 시작하는 셸 또는 스크립트에서 변수를 제거한 다음 새 세션을 시작합니다. 현재 세션의 메시지는 소급하여 저장되지 않습니다.

### 상속된 CLAUDE\_CODE\_CHILD\_SESSION 마커로 인해 트랜스크립트 저장이 꺼져 있습니다

Claude Code는 생성하는 서브프로세스에서 [`CLAUDE_CODE_CHILD_SESSION`](https://code.claude.com/docs/ko/env-vars)을 설정하고, 이를 상속하는 대화형 세션을 중첩된 것으로 취급합니다: Claude Code는 이에 대한 트랜스크립트를 저장하지 않으므로 Claude 자체가 시작하는 세션이 `--resume` 목록을 채우지 않습니다. 이 공지는 현재 세션이 마커를 상속했음을 의미합니다:

```text theme={null}
Transcript saving is off — inherited CLAUDE_CODE_CHILD_SESSION marker · restart with CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1 to keep future transcripts
```

공지는 다른 Claude Code 세션 내부에서 `claude`를 실행했을 때 예상되며, 마커가 오래 지속되는 중간 매개체(예: 터미널, `screen` 세션 또는 Claude Code 세션이 원래 시작한 런처)를 통해 누출되었을 때 오분류를 신호합니다.

tmux 내에서 Claude Code는 tmux 서버의 전역 환경을 통해 도착한 마커를 감지하고 저장을 계속하므로 이 경우 이 공지가 나타나지 않습니다.

**할 일:**

* 의도적으로 다른 Claude Code 세션 내부에서 이 세션을 시작한 경우 조치가 필요하지 않습니다.
* 이것이 최상위 세션인 경우 [`CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1`](https://code.claude.com/docs/ko/env-vars)을 설정하여 종료하고 재시작합니다. 저장은 재시작부터 적용되므로 이전에 전송된 메시지는 저장되지 않습니다.
* 동일한 터미널 또는 런처에서 향후 시작을 수정하려면 해당 환경에서 `CLAUDE_CODE_CHILD_SESSION`을 제거합니다.

## 구성 경고

대화형 세션에서 Claude Code가 시작 시 표시한 경고를 찾으려면 먼저 시작 배너 아래를 확인한 다음 디버그 로그를 확인하세요:

* **시작 배너 아래의 행**: [`⚠ Deny rule Bsh matches no tool · check for typos`](#matches-no-tool)처럼 [권한 규칙](https://code.claude.com/docs/ko/permissions.md)에 관한 일부 경고
* **디버그 로그**: Claude Code는 디버그 모드에서만 이 로그를 유지합니다. 로그의 경고를 읽으려면 셸에서 `claude --debug-file <path>`로 Claude Code를 시작한 다음 해당 경로의 파일을 여세요.

텍스트 출력을 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)이 아닌 경우 stderr에서 시작 경고를 확인하세요.

v2.1.305 이전에는 대화형 세션에서도 stderr를 확인하세요. 현재 배너 아래에 행으로 표시되는 권한 규칙 경고도 마찬가지입니다.

### Claude Code가 복구 불가능한 인터페이스 오류 후 종료됨

Claude Code는 터미널 인터페이스가 복구할 수 없는 오류에 부딪혀 종료될 때 이 메시지를 출력하며, 이는 두 렌더러 모두에서 발생할 수 있습니다. 두 번째 문장은 [전체 화면](https://code.claude.com/docs/ko/fullscreen.md) 렌더러가 시작되는 동안 오류가 발생했을 때만 나타납니다:

```text theme={null}
Claude Code exited after an unrecoverable interface error (<error>). It happened while the fullscreen renderer was starting, so the next launch will use the classic renderer (CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1 forces that any time).
```

**할 일:**

* Claude Code를 다시 시작하세요. 대화를 이어서 진행하려면 같은 디렉터리에서 `claude --resume`을 실행하세요.
* 메시지가 전체 화면 렌더러를 언급하면 [전체 화면 렌더링](https://code.claude.com/docs/ko/fullscreen.md#fullscreen-renderer-didnt-finish-starting)에서 전체 화면을 켠 방식에 따라 다음 실행이 어떻게 동작하는지, 그리고 전체 화면을 다시 시도하거나 클래식 렌더러를 유지하는 방법을 확인하세요.

v2.1.236 이전에는 Claude Code가 이런 종류의 오류 후 메시지를 출력하지 않고 종료되었습니다.

### 에이전트 설명이 15.0k 토큰 제한을 초과함

Claude Code는 stderr가 아닌 대화 보기의 시작 알림으로 이 경고를 표시합니다. 기본 제공 에이전트를 제외한 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)의 설명을 합친 양이 Claude Code의 추정으로 15,000 토큰을 초과합니다. 각 에이전트는 이름과 `description` frontmatter가 계산에 포함됩니다. Claude Code는 합계가 제한을 초과하는지 여부와 관계없이 모든 에이전트를 로드하므로 이 경고는 로드되는 내용을 변경하지 않습니다.

```text theme={null}
Agent descriptions are over the 15.0k-token limit (~16.2k tokens) · ask Claude to trim agent descriptions in .claude/agents/
```

**할 일:**

* 에이전트 파일의 `description` frontmatter를 줄이거나 Claude에게 정리하도록 요청하세요.
* 더 이상 사용하지 않는 에이전트 파일을 제거하세요.

### 훅에서 공백이 포함된 경로에 따옴표가 필요함

대화 보기의 이 알림은 훅의 스크립트 경로에 공백이 있는데 따옴표로 묶이지 않아 스크립트가 실행되지 않았다는 의미입니다. 해당 훅은 셸 형식의 [`asyncRewake`](https://code.claude.com/docs/ko/hooks#run-hooks-in-the-background) 훅입니다. 훅의 `command`에서 `python3` 같은 인터프리터 뒤에 따옴표로 묶이지 않은 경로 자리 표시자가 오며, 해석된 경로에 공백이 포함되어 있습니다.

알림은 훅의 이벤트 이름으로 시작하며 스크립트를 명시합니다:

```text theme={null}
Stop hook needs quotes around a path with a space (check.py)
```

**할 일:**

* 알림이 명시한 스크립트를 실행하는 훅의 `command`에서 경로를 큰따옴표로 묶으세요. JSON 파일에서는 `"command": "python3 \"${CLAUDE_PLUGIN_ROOT}/hooks/check.py\""`처럼 작성합니다.

### 지침 파일이 로드되지 않음

대화형 세션의 대화 보기에 나타나는 이 알림은 존재하는 [메모리 파일](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load)이 로드되지 않았다는 의미입니다. 읽기 제한이 적용되어 있습니다.

```text theme={null}
Instruction file not loaded (a Read deny rule covers it):
path: .claude/rules/shared.md
```

괄호 안의 내용은 이유를 나타냅니다. 예를 들면 다음과 같습니다:

* **`a Read deny rule covers it`**: `Read` [거부 규칙](https://code.claude.com/docs/ko/permissions.md#read-and-edit)이 작성된 그대로의 파일 경로 또는 해당 파일의 링크가 가리키는 위치와 일치합니다
* **`it's read from outside your working directories, where reads are blocked`**: [`permissions.blockReadsOutsideWorkingDirectories`](https://code.claude.com/docs/ko/settings-reference#permissions-blockreadsoutsideworkingdirectories)가 켜져 있는 동안 파일이 [작업 디렉터리](https://code.claude.com/docs/ko/settings-reference.md#permissions-blockreadsoutsideworkingdirectories) 외부로 해석됩니다
* **`where it leads couldn't be worked out`**: 예를 들어 파일이 직접 또는 다른 링크를 통해 자기 자신을 다시 가리키는 링크인 경우입니다

Claude가 하위 디렉터리의 파일로 작업할 때 해당 하위 디렉터리 자체의 메모리 파일을 로드할 수 없으면, 턴 중에 같은 줄이 대화에 나타납니다. 줄에 명시된 것보다 더 많은 파일이 보류되면 마지막 줄에 `and 3 more instruction files not loaded`처럼 나머지 개수가 표시됩니다.

**할 일:**

* 제한이 의도된 것이라면 아무것도 하지 않아도 됩니다. 세션은 해당 파일의 지침 없이 실행됩니다.
* `a Read deny rule covers it` 때문에 보류된 파일을 로드하려면 [해당 규칙을 제거하거나 범위를 좁히세요](https://code.claude.com/docs/ko/permissions.md#manage-permissions). 그런 다음 새 세션을 시작하세요.
* `it's read from outside your working directories, where reads are blocked` 때문에 보류된 파일을 로드하려면 파일 또는 링크 대상을 작업 디렉터리 안으로 옮기세요. 그런 다음 새 세션을 시작하세요.
* `where it leads couldn't be worked out` 때문에 보류된 파일을 로드하려면 파일이 자기 자신을 다시 가리키는 링크인지 확인하세요. 그렇다면 링크가 존재하는 파일을 가리키도록 하거나 그 자리에 일반 파일을 두세요. 그런 다음 새 세션을 시작하세요.

v2.1.292 이전에는 알림이 같은 줄에서 이유 뒤 끝부분에 파일을 명시했습니다.

### 스킬, 명령 또는 워크플로가 로드되지 않았습니다(이름이 예약됨)

스킬 폴더, frontmatter `name`, `.claude/commands/`의 파일 또는 하위 폴더, 또는 [저장된 워크플로](https://code.claude.com/docs/ko/workflows.md#save-the-workflow-for-reuse)가 `anthropic-skills` 이름을 사용하거나 `anthropic-skills:`로 시작하는 이름을 사용합니다. Claude Code는 [claude.ai에서 동기화된 스킬을 위해 해당 이름을 예약](https://code.claude.com/docs/ko/skills.md#names-reserved-for-synced-skills)하며 해당 항목을 로드하지 않습니다.

Claude Code는 stderr가 아닌 대화 보기의 시작 알림으로 이 경고를 표시합니다:

```text theme={null}
Not loaded: rename .claude/skills/anthropic-skills, then restart — its name uses "anthropic-skills", a name reserved for the skills synced from your claude.ai account
```

알림은 거부된 첫 번째 항목에 대해 변경할 대상을 명시합니다: 이름을 바꿀 폴더 또는 파일, 편집할 `name:` 줄, 또는 이름을 바꿀 워크플로. 둘 이상의 항목이 거부되면 알림은 `· 2 more` 같은 개수로 끝나며 [디버그 로그](https://code.claude.com/docs/ko/debug-your-config.md)에 각 항목이 명시됩니다.

**할 일:**

* 알림이 명시한 항목의 이름을 바꾸거나 알림이 가리키는 `name:` 줄을 편집한 후 세션을 다시 시작하세요.

v2.1.282 이전에는 Claude Code가 이러한 이름의 스킬과 명령을 로드했습니다.

### 스킬 또는 명령 이름이 거부됨

이 시작 알림은 Claude Code가 하나 이상의 [스킬 또는 사용자 지정 명령](https://code.claude.com/docs/ko/skills.md)의 이름을 거부했다는 의미이며, 해당 항목은 로드되지 않았거나 `name` 필드 없이 로드되었습니다:

```text theme={null}
1 skill or command name refused: run with --debug to see which ([names]), rename, then restart — a name may not hold hidden, direction-changing or blank-like characters, < or >, or be over 256 characters
```

* **로드되지 않음**: Claude Code가 디렉터리 이름이나 명령 파일의 이름 또는 하위 폴더처럼 스킬 또는 명령이 사용하는 이름을 거부했습니다. 해당 항목은 `/` 메뉴에 없으며 Claude가 호출할 수 없습니다. 디버그 로그의 해당 줄은 `<name> is not offered`로 표시됩니다.
* **`name` 필드 무시됨**: Claude Code가 스킬의 frontmatter `name`을 거부했습니다. 스킬은 여전히 로드되지만 `/` 메뉴에 `name` 값이 표시되지 않으며, 해당 값을 입력해도 스킬이 호출되지 않습니다. 디버그 로그의 해당 줄은 `<name value> is not shown for <skill>`로 표시됩니다.

**할 일:**

* 셸에서 `claude --debug`로 Claude Code를 시작하고 [디버그 로그](https://code.claude.com/docs/ko/debug-your-config.md)에서 `[names]`를 검색하세요. 알림이 집계한 각 이름마다 한 줄이 있습니다. 해당 줄은 폭이 없는 공백을 `\u{200B}`로 표기하는 것처럼 일부 숨겨진 문자를 코드로 표기하므로 문자의 위치를 확인할 수 있습니다.
* 폴더나 파일의 이름을 바꾸거나 `name:` 줄을 편집하여 [스킬 이름에 포함할 수 없는 문자](https://code.claude.com/docs/ko/skills.md#characters-a-skill-name-cant-hold)를 제거하거나, 256자를 초과하는 이름을 줄이세요. 그런 다음 파일이 Claude Code가 [변경 사항을 감시](https://code.claude.com/docs/ko/skills.md#live-change-detection)하는 디렉터리에 있는 경우가 아니라면 세션을 다시 시작하세요. 직접 작성하지 않은 플러그인의 스킬이라면 플러그인 작성자에게 이름 변경을 요청하세요.

### 워크스페이스가 신뢰되지 않음

Claude Code는 프로젝트의 `.claude/settings.json` 또는 `.claude/settings.local.json`에서 `permissions.allow` 규칙 또는 `permissions.additionalDirectories` 항목을 찾았지만 [프로젝트 설정의 허용 규칙에는 워크스페이스 신뢰가 필요](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)하기 때문에 적용하지 않았습니다. 메시지에 표시되는 개수, 설정 이름, 파일은 구성에 따라 다릅니다. `deny` 및 `ask` 규칙은 영향을 받지 않습니다.

```text theme={null}
Ignoring 2 permissions.allow entries from .claude/settings.local.json: this workspace has not been trusted. Run Claude Code interactively here once and accept the trust dialog, or set projects["/Users/you/project"].hasTrustDialogAccepted: true in /Users/you/.claude.json.
```

**할 일:**

* 해당 디렉터리에서 `claude`를 실행하고 신뢰 대화 상자를 수락하세요. [프로젝트 허용 규칙 및 워크스페이스 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)에서 해당 수락이 어느 폴더에 적용되는지 설명합니다.
* `-p`를 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 대화 상자가 표시되지 않습니다. 메시지가 출력하는 정확한 `projects` 키를 사용하여 `~/.claude.json`에 `hasTrustDialogAccepted` 항목을 설정하세요.
* 메시지가 `.claude/settings.local.json`을 명시하고 git 저장소 외부 또는 홈 디렉터리에서 Claude Code를 시작했다면 v2.1.200 이상으로 업데이트하세요. 버전 2.1.196부터 2.1.199까지는 이러한 워크스페이스에서 사용자 자신의 `.claude/settings.local.json`을 저장소에서 제공된 것으로 취급했습니다. v2.1.207 이상에서는 폴더를 신뢰하지 않은 경우 git 저장소 외부에서 업데이트만으로는 충분하지 않습니다. 폴더가 저장소 내부에 있지 않음을 확인하려면 git을 실행해야 하며, Claude Code는 신뢰 대화 상자를 수락한 후에만 이 검사를 실행하므로 첫 번째 단계를 사용하세요. 홈 디렉터리와 기타 [구성 홈](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)은 예외이며 대화 상자를 기다리지 않습니다. [프로젝트 허용 규칙 및 워크스페이스 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)를 참조하세요.

### 작업 디렉터리가 네트워크 경로임

Claude Code는 네트워크 경로를 작업 디렉터리로 추가하지 않습니다. 네트워크 경로를 조회하면 경로에 지정된 호스트에 연결할 수 있으며, Windows에서는 이 연결로 호스트에 자격 증명이 전송될 수 있습니다. 따라서 Claude Code는 조회하지 않고 경로를 거부합니다.

네트워크 경로로 `/add-dir`을 실행하면 다음 메시지가 표시됩니다:

```text theme={null}
\\server\share is a network path, which cannot be added as a working directory. On Windows, map the share to a drive letter and pass it at launch with --add-dir (a drive letter added mid-session does not yet carry remote-read trust).
```

대신 시작 시 `--add-dir` 또는 `permissions.additionalDirectories`로 네트워크 경로를 전달하면 Claude Code는 해당 디렉터리 없이 시작합니다. 대화형 세션에서는 메시지가 다른 [시작 경고](#configuration-warnings)와 함께 디버그 로그에 기록되므로 시작 시 메시지가 표시되지 않습니다.

Claude Code가 이 방식으로 거부하는 경로는 다음과 같습니다:

* `\\server\share` 같은 UNC 공유
* `/net/<host>` 같은 자동 마운트 경로(해당 호스트의 자동 마운트 아래 디렉터리에서 Claude Code를 실행한 경우 제외). 해당 자동 마운트 아래의 읽기는 여전히 [네트워크 경로 검사](https://code.claude.com/docs/ko/permissions.md#network-paths)를 거칩니다.
* 심볼릭 링크 또는 정션을 통해 네트워크 위치에 도달하는 로컬 경로

매핑된 드라이브 문자 및 `\\wsl$` 경로는 네트워크 경로로 간주되지 않습니다.

**할 일:**

* Windows에서는 공유를 드라이브 문자에 매핑하고 실행 시 해당 드라이브를 전달하세요. 예를 들어 PowerShell에서 `net use Z: \\server\share`를 실행한 다음 `claude --add-dir Z:\`를 실행합니다.
* macOS 또는 Linux에서는 공유를 로컬 경로에 마운트하고 대신 해당 경로를 추가하세요.
* 경로가 `permissions.additionalDirectories`에 있으면 해당 경로를 나열한 설정 파일에서 제거하세요.

v2.1.257 이전에는 Claude Code가 도달 가능한 네트워크 경로를 작업 디렉터리로 수락했습니다.

### 원격 관리형 설정을 로드하지 못함

세션이 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md) 적용 대상이지만 Claude Code가 설정을 가져오지 못했거나 서버가 반환한 내용을 적용하지 못했으므로 대화형 세션에서 이 경고를 표시합니다.

괄호 안의 원인은 `network error`, `request timed out`, `authentication rejected (401)`처럼 무엇이 실패했는지를 나타냅니다. `no setting in the server response could be applied as written` 원인은 서버가 응답했지만 반환된 설정 중 [검증](https://code.claude.com/docs/ko/server-managed-settings.md#invalid-entries-in-delivered-settings)을 통과한 것이 없음을 의미합니다. v2.1.282 이전에는 이 원인이 `server returned invalid settings`로 표시되었습니다.

줄의 나머지 부분은 세션이 어떤 정책으로 실행되는지를 나타냅니다:

* **이전에 성공한 가져오기에서 캐시된 설정**: Claude Code는 [보류된 환경 변수](https://code.claude.com/docs/ko/server-managed-settings.md#fetch-and-caching-behavior)를 제외한 캐시된 정책으로 세션을 실행하며, 줄에 `using cached policy`가 표시됩니다.
* **캐시 없음**: Claude Code는 서버 관리형 설정 없이 세션을 실행하며, 줄에 `no remote policy applied`가 표시됩니다.

**할 일:**

* 메시지가 명시한 원인에 따라 조치하세요: 네트워크 원인의 경우 이 머신이 `api.anthropic.com`에 도달할 수 있는지 확인하고, 인증 원인의 경우 `/status`로 로그인 상태를 확인하세요.
* `no setting in the server response could be applied as written`의 경우 관리자에게 서버의 설정을 수정하도록 요청하세요.
* 전체 진단을 보려면 `/status` 또는 `claude doctor`를 실행하세요.

v2.1.248 이전에는 Claude Code가 설정 가져오기 실패를 디버그 로그에서만 보고했습니다.

### 관리형 설정이 승인되지 않음

조직의 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)에 승인이 필요한 설정이 포함되어 있는데 [보안 승인 대화 상자](https://code.claude.com/docs/ko/server-managed-settings.md#security-approval-dialogs)를 거부했으므로, Claude Code는 설정을 적용하지 않고 종료합니다:

```text theme={null}
Managed settings were not approved; exiting without applying them.
```

**할 일:**

* Claude Code를 다시 시작하고 대화 상자를 승인하여 조직의 설정으로 계속 진행하세요. 거부한 대화 상자는 기억되지 않으므로 다음 시작 시 다시 나타납니다.
* 대화 상자에 나열된 설정이 확실하지 않으면 승인하기 전에 조직의 관리형 설정을 유지 관리하는 담당자에게 문의하세요.

### 관리형 설정에 승인이 필요함

조직의 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)에 [보안 승인 대화 상자](https://code.claude.com/docs/ko/server-managed-settings.md#security-approval-dialogs)에서 승인이 필요한 설정이 포함되어 있습니다. 실행한 `claude plugin` 명령은 키보드에서 입력을 읽을 수 없었으므로 해당 대화 상자를 표시할 수 없었습니다. 이는 명령의 입력을 파이프하거나 리디렉션하고, macOS와 Linux에서는 `/dev/tty`도 열 수 없을 때 발생합니다. 명령은 아무것도 변경하기 전에 중지되었습니다:

```text theme={null}
Your organization's managed settings need your approval, which couldn't be asked for here. Run `claude` in a terminal and approve them, then run this command again.
```

**할 일:**

* 터미널에서 `claude`를 실행하고 대화 상자가 나타나면 설정을 승인한 다음, 같은 `claude plugin` 명령을 다시 실행하세요. Claude Code는 승인과 승인된 설정을 [구성 디렉터리](https://code.claude.com/docs/ko/server-managed-settings.md#approval-memory)에 보관합니다. 중지된 명령이 다른 사용자로 실행되었거나 `CLAUDE_CONFIG_DIR`이 설정된 상태로 실행되었다면, 두 명령이 같은 디렉터리를 사용하도록 `claude`도 같은 방식으로 실행하세요.

### 관리형 설정이 기본 모델을 차단함

조직의 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)이 Default 옵션이 가리키는 모델과 단계적으로 낮출 수 있는 모든 모델을 차단합니다. Default 옵션으로 시작하려던 세션은 차단된 모델을 실행하는 대신 시작 시 종료됩니다. 표시되는 메시지는 차단하는 설정에 따라 다릅니다. [`deniedModels`](https://code.claude.com/docs/ko/model-config#block-specific-models-or-versions) 목록이 차단하는 경우 메시지는 다음과 같습니다:

```text theme={null}
Claude Code can't start: your organization's managed settings block the default model (claude-opus-5-5) in "deniedModels", and none of the models they allow can be used as the default instead. Ask your administrator to update "deniedModels" or "availableModels".
```

[`availableModelsMatch`](https://code.claude.com/docs/ko/settings-reference#availablemodelsmatch)가 `"exact"`로 설정된 `availableModels` 목록에서 해당 모델이 빠진 경우 메시지는 다음과 같습니다:

```text theme={null}
Claude Code can't start: your organization allows only the models listed in "availableModels", and none of them can be used as the default model (claude-opus-5-5 isn't listed). Ask your administrator to update "availableModels".
```

**할 일:**

* 설정을 관리하는 경우 사용자가 실행할 수 있는 모델을 `availableModels`에 추가하거나 모든 폴백을 차단하는 `deniedModels` 항목의 범위를 좁히세요. [특정 모델 또는 버전 차단](https://code.claude.com/docs/ko/model-config.md#block-specific-models-or-versions)에서 Default 옵션이 단계적으로 낮아지는 방식을 설명합니다.
* 설정을 관리하지 않는 경우 메시지를 관리자에게 보내세요. 사용자 자신의 설정 파일로는 관리형 `availableModels` 또는 `deniedModels` 목록을 확장할 수 없습니다.

### 관리형 설정이 이 API 공급자를 허용하지 않음

조직의 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)이 [`allowedProviders`](https://code.claude.com/docs/ko/settings-reference#allowedproviders) 목록을 설정했는데, 세션의 API 공급자가 목록에 없거나 세션이 해당 항목이 요구하는 방식으로 고정되지 않은 엔드포인트를 사용합니다. Claude Code는 시작 시, 로그인 전, 또는 세션이 다음에 API에 연결할 때 거부합니다. 메시지는 허용된 공급자로 시작합니다:

```text theme={null}
Your organization's managed settings allow Claude Code to use: Anthropic API, Amazon Bedrock.
```

목록이 비어 있으면 메시지는 대신 다음과 같습니다:

```text theme={null}
Your organization's managed settings allow Claude Code to use no API provider at all (allowedProviders is an empty list), so it cannot start on this machine.
```

모든 항목이 인식되지 않으면 괄호 안의 내용이 대신 `(allowedProviders lists only unrecognized entries)`로 표시됩니다.

**할 일:**

* 메시지의 `To continue:` 단계를 따르세요.
* 설정을 관리하는 경우 메시지에서 `Admins:`로 시작하는 줄이 추가할 항목 또는 고정할 값을 명시하며, [`allowedProviders`](https://code.claude.com/docs/ko/settings-reference#allowedproviders) 항목에서 어느 소스의 `env` 블록으로 고정할 수 있는지 설명합니다.

### MCP 서버가 엔터프라이즈 관리 정책에 의해 차단됨

`/mcp`에서 서버의 **Reconnect**를 선택했거나 비활성화된 서버를 다시 켰는데, [MCP 서버를 제한](https://code.claude.com/docs/ko/managed-mcp.md)하는 설정이 해당 서버를 차단합니다. Claude Code는 연결을 거부하고 다음을 표시합니다:

```text theme={null}
MCP server <name> is blocked by enterprise managed policy
```

다음 설정 중 하나가 이 메시지를 발생시킬 수 있습니다:

* 사용자 자신의 `~/.claude/settings.json` 또는 프로젝트의 `.claude/settings.json`에 있는 것을 포함하여 서버와 일치하는 [`deniedMcpServers`](https://code.claude.com/docs/ko/managed-mcp#policy-based-control-with-allowlists-and-denylists) 항목
* 서버가 일치하지 않는 [`allowedMcpServers`](https://code.claude.com/docs/ko/managed-mcp#policy-based-control-with-allowlists-and-denylists) 목록
* `mcp`가 잠긴 [`strictPluginOnlyCustomization`](https://code.claude.com/docs/ko/settings-reference#strictpluginonlycustomization)으로, `~/.claude.json` 및 `.mcp.json`에 구성된 서버를 차단합니다
* 서버가 claude.ai 커넥터인 경우 [`disableClaudeAiConnectors`](https://code.claude.com/docs/ko/mcp#disable-claude-ai-connectors)

**할 일:**

* 사용자 자신의 사용자 및 프로젝트 설정 파일에서 이러한 설정이 있는지 확인하고 변경하거나 제거하세요.
* 사용자 자신의 설정으로 차단이 설명되지 않으면 관리자에게 어떤 관리형 설정이 서버를 차단하는지 문의하세요.

v2.1.257 이전에는 `/mcp`의 **Reconnect** 및 다시 활성화로 세션 중 정책 업데이트가 차단한 서버를 연결할 수 있었습니다.

### MCP 서버 이름이 예약됨

이 메시지는 MCP 서버 중 하나를 명시하며, 해당 서버의 이름은 기본 제공 서버의 이름처럼 Claude Code가 예약한 이름 중 하나입니다:

```text theme={null}
"workspace" is a reserved MCP server name and was not loaded
```

**할 일:**

* 서버를 정의한 곳에서 서버 이름을 바꾸세요. 예를 들어 `workspace`를 `my-workspace`로 바꿉니다.
* 피해야 할 다른 예약된 이름은 [MCP 구성 경고](https://code.claude.com/docs/ko/mcp.md#configuration-warnings)를 참조하세요.

### 관리형 설정 문서를 구문 분석할 수 없음

조직이 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 배포했는데 배포된 문서 중 하나가 존재하지만 JSON 객체로 구문 분석할 수 없으므로, Claude Code는 해당 문서가 담고 있는 정책 없이 실행하는 대신 시작 시 코드 1로 종료합니다. 줄은 메시지 앞에 실패한 소스를 명시합니다:

```text theme={null}
/Library/Application Support/ClaudeCode/managed-settings.json: Managed settings document could not be parsed as a JSON object; none of its settings are in effect. Fix or remove it.
```

소스는 다음 중 하나입니다:

* `managed-settings.json` 파일 또는 `managed-settings.d` 아래 드롭인 파일의 경로
* macOS 관리 기본 설정 프로필, `per-user managed preferences` 또는 `device-level managed preferences`
* Windows 레지스트리 값, `Registry: HKLM\SOFTWARE\Policies\ClaudeCode\Settings`

[Claude Code가 삭제한 항목 찾기](https://code.claude.com/docs/ko/managed-settings.md#find-entries-claude-code-dropped)에서 각 소스를 구문 분석할 수 없게 만드는 원인을 나열합니다.

Claude Code는 다른 관리자 소스가 유효한 정책을 제공하더라도 시작을 거부합니다. 이 오류는 대화형 세션, `claude -p`, Agent SDK 세션, [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md), 그리고 `claude doctor`를 포함한 대부분의 하위 명령에서 표시됩니다. 이 거부는 의도적으로 안전하게 실패(fail closed)하도록 설계되었습니다. Claude Code가 구문 분석할 수 없는 문서의 설정은 적용할 수 없으며, 그래도 시작하면 조직의 통제 없이 세션이 실행되기 때문입니다.

구문 분석 가능한 문서의 스키마 문제는 이 오류를 발생시키지 않습니다. [Claude Code가 삭제한 항목 찾기](https://code.claude.com/docs/ko/managed-settings.md#find-entries-claude-code-dropped)에서 이 경우 Claude Code가 어떻게 처리하는지 다룹니다.

`managed-settings.d/` 디렉터리가 존재하지만 목록을 읽을 수 없으면 Claude Code는 대신 `Managed settings drop-in directory could not be read:` 뒤에 근본 오류를 보고합니다. [Claude Code가 삭제한 항목 찾기](https://code.claude.com/docs/ko/managed-settings.md#find-entries-claude-code-dropped)에서 읽기 실패로 시작 시 종료되는 경우를 다룹니다.

**할 일:**

* 머신을 관리하는 경우 명시된 문서가 JSON 객체로 구문 분석되도록 수정하거나 파일, 프로필 또는 레지스트리 값을 제거하세요. 빈 `managed-settings.json`은 `{}`로 간주되며 실행을 차단하지 않습니다.
* 관리하지 않는 경우 관리자에게 배포된 문서를 수정하도록 요청하세요. 사용자 자신의 설정 파일은 이 오류를 일으키지도 해결하지도 않습니다.

### 관리 정책 설정을 읽을 수 없음

조직이 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 배포했는데, 배포된 소스 중 하나가 존재하지만 운영 체제가 읽기를 거부한 것이 아니라 I/O 오류 같은 이유로 읽을 수 없습니다. 다른 관리자 소스가 정책을 제공하지 않으면, Claude Code는 해당 소스가 담고 있을 수 있는 정책 없이 실행하는 대신 시작 시 종료합니다:

```text theme={null}
Unable to read managed policy settings.
This machine may require organization login enforcement, but the policy file failed to load.
Contact your administrator.

Detail: <source>: <reason>
```

같은 상태에서 로그인 흐름, 이미 실행 중인 세션의 API 요청, [`claude gateway`](https://code.claude.com/docs/ko/claude-apps-gateway) 서버는 [`allowedProviders`](https://code.claude.com/docs/ko/settings-reference#allowedproviders)를 명시하는 첫 번째 줄의 변형 메시지와 함께 거부됩니다.

루트 전용 파일처럼 운영 체제가 읽기를 거부한 경우에는 이 종료가 발생하지 않으며, [세션은 해당 소스의 정책 없이 시작됩니다](https://code.claude.com/docs/ko/managed-settings.md#find-entries-claude-code-dropped). 구문 분석할 수 없는 소스의 경우 Claude Code는 [소스를 명시하는 다른 메시지](#managed-settings-document-could-not-be-parsed)와 함께 종료합니다.

**할 일:**

* 머신을 관리하는 경우 `Detail:` 줄이 명시한 문제를 수정하여 배포된 소스를 읽을 수 있게 하거나 소스를 제거하세요.
* 관리하지 않는 경우 메시지를 관리자에게 보내세요. 사용자 자신의 설정 파일은 이 오류를 일으키지도 해결하지도 않습니다.

v2.1.285 이전에는 claude.ai 또는 Claude Console 자격 증명으로 로그인한 세션만 이 메시지와 함께 종료되었으며, 운영 체제가 거부한 읽기도 이 메시지를 발생시켰습니다.

### Managed settings contain invalid entries, including PreToolUse/PermissionRequest hooks that are NOT loaded

`-p` 실행에서 출력되는 이 stderr 블록은 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md) 소스에 Claude Code가 로드할 수 없는 훅 항목이 있다는 의미입니다. 해당 훅은 실행되지 않으며, 어떤 줄에서 소스의 `hooks` 필드가 무시된 것으로 나열되면 해당 소스의 훅은 하나도 실행되지 않습니다.

각 줄은 소스, 필드(있는 경우), 그리고 알 수 없는 훅 `type`이나 `hooks` 키 외부에 선언된 훅 같은 문제를 명시합니다:

```text theme={null}
Managed settings contain invalid entries, including PreToolUse/PermissionRequest hooks that are NOT loaded; fix or remove each entry:
  <source> (<field>): <message>
```

**할 일:**

* 소스를 관리하는 경우 블록에 나열된 각 항목을 수정하거나 제거하세요. [훅 구성](https://code.claude.com/docs/ko/hooks.md#configuration)에서 Claude Code가 `hooks` 아래에 기대하는 형태를 확인할 수 있습니다.
* 줄의 소스가 `parent managed settings`이면 Claude Code를 실행한 애플리케이션이 해당 항목을 [상위 설정](https://code.claude.com/docs/ko/managed-settings.md#parent-settings-from-embedding-hosts)으로 전달한 것이므로, 해당 애플리케이션의 개발자에게 보고하세요.
* 그 외의 경우 블록을 관리자에게 보내세요.

v2.1.300 이전에는 `-p` 실행에서 이 경우가 `Managed settings failed to load; policies from the failed source are NOT in effect:` 헤더 아래에 나열되었습니다.

### otelHeadersHelper 실패

Claude Code는 [`otelHeadersHelper`](https://code.claude.com/docs/ko/settings-reference#otelheadershelper) 스크립트가 실패하거나 [스크립트 요구 사항](https://code.claude.com/docs/ko/monitoring-usage.md#script-requirements)을 충족하지 않는 출력을 내보낼 때, 대화형 세션당 한 번 터미널 인터페이스에 알림으로 이 경고를 표시합니다.

스크립트가 계속 실패하는 동안 내보내기가 실패하며 텔레메트리 백엔드는 세션에서 아무것도 받지 못합니다.

`See /status:` 뒤의 텍스트는 스크립트의 종료 코드와 그 뒤의 오류 출력처럼 무엇이 실패했는지를 나타냅니다:

```text theme={null}
otelHeadersHelper failed; telemetry is not being exported. See /status: exited 1: token service unreachable
```

**할 일:**

* `/status`를 실행하여 실패 세부 정보를 확인하세요.
* 스크립트가 30초 이내에 0으로 종료되고 stdout에 문자열 헤더 값으로 이루어진 JSON 객체를 출력하도록 수정하세요. [스크립트 요구 사항](https://code.claude.com/docs/ko/monitoring-usage.md#script-requirements)을 참조하세요.
* 조직이 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 통해 스크립트를 배포하는 경우 이를 유지 관리하는 담당자에게 수정을 요청하세요.

`-p`를 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 같은 실패가 대신 stderr에 `otelHeadersHelper failed (OpenTelemetry export headers unavailable): <error>`로 나타납니다.

### headersHelper 실행되지 않음

Claude Code는 MCP 서버를 정적 `headers`만으로 연결했으며 서버의 [`headersHelper`](https://code.claude.com/docs/ko/mcp#use-dynamic-headers-for-custom-authentication)를 건너뛰었습니다. 헬퍼는 셸 명령인데 해당 폴더에 저장된 신뢰가 없기 때문입니다. 폴더는 `~/.claude.json`에서 해당 항목을 직접 설정하거나, 홈 디렉터리 외부에서는 대화형 세션에서 신뢰 대화 상자를 수락할 때 저장된 신뢰를 얻습니다. 이 검사가 어떤 서버에 적용되는지는 [headersHelper가 실행되기 전에 폴더 신뢰](https://code.claude.com/docs/ko/mcp.md#trust-a-folder-before-its-headershelper-runs)를 참조하세요.

Claude Code는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서만 서버당 한 번 이 줄을 기록합니다. 대화형 세션에서는 같은 거부를 대신 디버그 로그에 기록합니다.

```text theme={null}
MCP server 'internal-api': headersHelper not run — this workspace has no persisted trust; accept the trust dialog here once interactively, or set projects["/Users/you/project"].hasTrustDialogAccepted in /Users/you/.claude.json.
```

메시지가 출력하는 `projects` 키는 [프로젝트 허용 규칙 및 워크스페이스 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)에서 설명하는, Claude Code가 신뢰의 기준으로 삼는 폴더입니다. 상위 폴더에 대한 신뢰 대화 상자를 수락해도 이 검사를 통과하지 못하며, `-p` 또는 SDK 세션으로도 통과하지 못합니다.

**할 일:**

* 메시지가 명시한 폴더에서 `claude`를 실행하고 신뢰 대화 상자를 수락한 후 `-p` 또는 SDK 명령을 다시 실행하세요.
* 메시지가 출력하는 정확한 `projects` 키를 사용하여 `~/.claude.json`에 `hasTrustDialogAccepted` 항목을 직접 설정하세요.
* 홈 디렉터리에서 세션을 시작했다면 신뢰한 프로젝트 디렉터리에서 작업하세요. 홈 디렉터리에서 신뢰 대화 상자를 수락하면 Claude Code는 현재 세션에만 해당 신뢰를 유지합니다.

### 잘못된 형식의 Tool(content) 규칙

설정 파일 중 하나의 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#permission-rule-syntax)이 `Tool` 또는 `Tool(content)` 형태가 아닙니다. 예를 들어 닫는 괄호 뒤에 텍스트가 있거나 괄호 중 하나가 누락된 경우입니다. Claude Code는 규칙을 건너뛰고, 대화형 세션이 시작될 때 유효하지 않은 설정 대화 상자와 [`claude doctor`](https://code.claude.com/docs/ko/debug-your-config#check-resolved-settings) 출력에 해당 규칙을 나열합니다:

```text theme={null}
Invalid permission rule "Bash(ls) x" was skipped: Malformed Tool(content) rule. Rules take the form Tool or Tool(content) and must end at the closing ")"; parentheses inside the content are literal
```

**할 일:**

* 메시지와 함께 나열된 설정 파일에서 규칙이 닫는 괄호에서 끝나도록 다시 작성하세요. 예를 들어 `Bash(ls) x` 대신 `Bash(ls *)`를 사용합니다.
* 내용 안의 괄호는 그대로 두세요. 괄호는 리터럴로 처리되므로 `Edit(./Finance (2024)/**)` 같은 규칙은 이스케이프 없이도 유효합니다.

v2.1.260 이전에는 Claude Code가 괄호가 짝이 맞지 않는 규칙을 `Mismatched parentheses`로 보고했습니다.

### Matches no tool · check for typos

시작 배너 아래의 이 행은 Claude Code가 도구 이름을 인식하지 못하는 거부 또는 확인 [권한 규칙](https://code.claude.com/docs/ko/permissions.md)을 명시하며, 해당 규칙은 의도한 도구에 적용되지 않습니다. `Bsh`로 작성한 거부 규칙은 Bash에 적용되지 않으며, 도구의 표준 이름 대신 트랜스크립트에 표시되는 레이블을 사용한 규칙도 마찬가지입니다. 행은 작성한 그대로의 규칙을 반복해서 보여 줍니다:

```text theme={null}
⚠ Deny rule Bsh matches no tool · check for typos
```

텍스트 출력을 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 Claude Code가 대신 더 긴 형태의 경고를 stderr에 출력합니다:

```text theme={null}
Permission deny rule "Bsh" matches no known tool — check for typos.
```

**할 일:**

* 규칙의 도구 이름을 수정하세요. 예를 들어 `Bsh` 대신 `Bash`를 사용합니다. 표준 이름은 [도구 참조](https://code.claude.com/docs/ko/tools-reference.md)에서 확인하세요.
* 규칙이 정의된 위치를 찾으려면 세션에서 `/permissions`를 실행하고 규칙을 선택하세요. 세부 정보에 `From project local settings`, 또는 `--disallowedTools` 값의 경우 `From CLI argument`처럼 규칙의 출처가 표시됩니다.
* 세부 정보가 `From enterprise managed settings`로 표시되면 사용자가 직접 해당 규칙을 변경할 수 없으므로 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 유지 관리하는 담당자에게 해당 행을 전달하세요.

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)에서 또는 `--output-format json`이나 `stream-json`을 사용하는 경우, Claude Code는 경고를 stderr 대신 디버그 로그에 기록합니다. `--debug`로 실행하면 `~/.claude/debug/<session-id>.txt`에서 확인할 수 있습니다.

v2.1.305 이전에는 대화형 세션이 행을 표시하는 대신 시작 시 더 긴 형태의 경고를 stderr에 출력했습니다.

### 파일 권한 검사와 일치하지 않음

Claude Code는 [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live), [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md), 또는 `--allowedTools`, `--disallowedTools`, `--settings` 플래그 값에서 경로가 포함된 `Write`, `NotebookEdit`, `MultiEdit`, 또는 `Glob` [권한 규칙](https://code.claude.com/docs/ko/permissions.md#read-and-edit)을 찾았습니다. Claude Code는 파일 권한을 `Edit` 및 `Read` 규칙에 대해서만 검사하므로, 다른 파일 도구를 명시하는 경로 규칙은 전혀 참조하지 않습니다. 규칙은 유지되며 다른 것은 변경되지 않습니다.

* **대화형 세션**: 전체 경고는 [디버그 로그](#configuration-warnings)에 기록되며, 이 형태의 거부 또는 확인 규칙은 시작 배너 아래에 다음 행으로도 표시됩니다:

  ```text theme={null}
  ⚠ Deny rule Write(docs/**) never matches · use Edit(docs/**)
  ```

  이 형태의 허용 규칙은 행이 표시되지 않습니다. 규칙이 정의된 위치를 찾으려면 세션에서 `/permissions`를 실행하고 규칙을 선택하세요.
* **텍스트 출력을 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)**: stderr의 전체 경고는 규칙, 괄호 안의 소스, 그리고 대신 작성할 규칙을 명시합니다:

  ```text theme={null}
  Permission deny rule (.claude/settings.json): Write(docs/**) is not matched by file permission checks — only Edit(path) rules are. Use Edit(docs/**) instead (Edit rules cover all file-editing tools).
  ```
* **[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md), 또는 `--output-format json`이나 `stream-json`**: 기계가 읽는 출력을 깨끗하게 유지하기 위해 전체 경고는 stderr 대신 디버그 로그에 기록됩니다. `--debug`로 실행하면 `~/.claude/debug/<session-id>.txt`에서 확인할 수 있습니다.

**할 일:**

* `Write(path)`, `NotebookEdit(path)`, 레거시 `MultiEdit(path)` 규칙을 `Edit(path)`로 바꾸세요. `Edit` 규칙은 모든 파일 편집 도구에 적용됩니다.
* Claude Code가 경고 없이 `Glob` 규칙을 수락하는 `--allowedTools`를 제외하고, `Glob(path)` 규칙을 `Read(path)`로 바꾸세요.
* 전체 경고가 괄호 안에 명시한 소스에서 규칙을 수정하세요: 설정 파일 경로, 또는 `--allowed-tools` 및 `--disallowed-tools`의 경우 플래그 자체입니다. 디스크에 존재하지 않는 `claude-settings-<hash>.json` 경로는 인라인 `--settings` 값을 나타냅니다. 해당 플래그에 전달하는 JSON을 수정하세요.
* `Write` 또는 `Glob` 같은 도구 이름만 있는 규칙은 그대로 두세요. Claude Code는 이러한 규칙을 [도구 수준](https://code.claude.com/docs/ko/permissions.md#match-all-uses-of-a-tool)에서 일치시키며 경고하지 않습니다.
* 관리형 설정의 규칙인 경우 전체 경고의 괄호 안에 `managed policy settings`가 표시되고 `/permissions`의 규칙 세부 정보에 `From enterprise managed settings`가 표시됩니다. 사용자가 직접 해결할 수 없으므로 관리형 설정을 유지 관리하는 담당자에게 해당 경고를 전달하세요.

v2.1.210 이전에는 Claude Code가 경고 없이 이러한 규칙을 수락했습니다. v2.1.305 이전에는 대화형 세션이 전체 경고를 stderr에 출력했습니다.

### 명령의 나머지 부분 앞에 와일드카드가 있음

Claude Code는 [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live), [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md), 또는 `--allowedTools`나 `--settings` 플래그 값에서 `Bash(git * main)` 또는 `Bash(git -C * status *)`처럼 `*`가 어떤 명령인지를 결정하는 뒤쪽 단어보다 앞에 오는 `Bash` 허용 규칙을 찾았습니다. `*`는 해당 위치에 삽입된 옵션을 포함한 모든 텍스트와 일치합니다. 예를 들어 `Bash(git * main)`은 `git -c core.fsmonitor=<script> diff main`도 승인하는데, 여기서 `-c`는 git이 명령에 지정된 프로그램을 실행하게 만듭니다. [와일드카드 패턴](https://code.claude.com/docs/ko/permissions.md#wildcard-patterns)에서 일치 규칙을 확인할 수 있습니다.

이 경고는 의도보다 넓은 와일드카드를 가진 규칙의 범위를 좁힐 수 있도록 하기 위한 것입니다. Claude Code는 규칙을 유지하며 일치 방식도 변경하지 않습니다. 텍스트 출력을 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 stderr의 경고가 규칙과 괄호 안의 소스를 명시합니다:

```text theme={null}
Permission allow rule (.claude/settings.json): Bash(git -C * status *) has a wildcard before the rest of the command, so it also matches any options inserted at that position and approves them without a prompt. For git, options such as -c and --exec-path can run arbitrary commands. Replace that * with the exact value you mean, or only use * after the subcommand (for example Bash(git status *)).
```

대화형 세션에서는 전체 경고가 [디버그 로그](#configuration-warnings)에 기록되며, 규칙은 시작 배너 아래에 다음 행으로 표시됩니다:

```text theme={null}
⚠ Allow rule Bash(git -C * status *) allows any option at its * · use an exact value
```

규칙이 정의된 위치를 찾으려면 세션에서 `/permissions`를 실행하고 규칙을 선택하세요.

**할 일:**

* 하위 명령 앞의 `*`를 의도한 정확한 값으로 바꾸세요: `Bash(git * main)` 대신 `Bash(git checkout main)`.
* 모든 `*`를 하위 명령 뒤로 옮기세요: `Bash(git -C * status *)` 대신 `Bash(git status *)`. 허용하려는 하위 명령마다 규칙을 하나씩 작성하세요.
* 전체 경고가 괄호 안에 명시한 소스에서 규칙을 수정하세요: 설정 파일 경로 또는 `--allowed-tools` 플래그 자체입니다. 디스크에 존재하지 않는 `claude-settings-<hash>.json` 경로는 인라인 `--settings` 값을 나타냅니다. 해당 플래그에 전달하는 JSON을 수정하세요.
* 관리형 설정의 규칙인 경우 전체 경고의 괄호 안에 `managed policy settings`가 표시되고 `/permissions`의 규칙 세부 정보에 `From enterprise managed settings`가 표시됩니다. 사용자가 직접 해결할 수 없으므로 관리형 설정을 유지 관리하는 담당자에게 해당 경고를 전달하세요.

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)에서 또는 `--output-format json`이나 `stream-json`을 사용하는 경우, Claude Code는 기계가 읽는 출력을 깨끗하게 유지하기 위해 경고를 stderr 대신 디버그 로그에 기록합니다. `--debug`로 실행하면 `~/.claude/debug/<session-id>.txt`에서 확인할 수 있습니다. v2.1.246 이전에는 Claude Code가 경고 없이 이러한 규칙을 수락했습니다.

v2.1.305 이전에는 대화형 세션이 행을 표시하는 대신 전체 경고를 stderr에 출력했습니다.

### Bash를 거부하면 PowerShell 도구도 꺼짐

예를 들어 `--disallowedTools Bash`를 사용하거나 설정 파일 중 하나에 `Bash` 또는 `Bash(*)`만 있는 [거부 규칙](https://code.claude.com/docs/ko/permissions.md#match-all-uses-of-a-tool)을 사용하여 Bash 도구 전체를 제거했습니다. Git Bash가 설치된 Windows에서는 [Bash를 거부하면 PowerShell 도구도 꺼지므로](https://code.claude.com/docs/ko/tools-reference.md#bash-deny-rules-also-turn-off-the-powershell-tool) 세션이 셸 도구 없이 시작됩니다.

텍스트 출력을 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 Claude Code가 시작 시 stderr에 이 경고를 출력하며, 대화형 세션에서는 [디버그 로그](#configuration-warnings)에만 기록합니다:

```text theme={null}
Denying Bash also turns off the PowerShell tool, so Claude has neither. To use PowerShell, set CLAUDE_CODE_USE_POWERSHELL_TOOL=1.
```

**할 일:**

* Claude가 PowerShell을 사용하도록 하려면 [PowerShell 도구 활성화](https://code.claude.com/docs/ko/tools-reference.md#enable-the-powershell-tool)에 나온 대로 환경 또는 설정 파일의 `env` 블록에서 [`CLAUDE_CODE_USE_POWERSHELL_TOOL`](https://code.claude.com/docs/ko/env-vars)을 `1`로 설정하세요. 그러면 PowerShell 도구는 Bash 거부 규칙과 함께 켜진 상태로 유지됩니다.
* 도구 전체 대신 특정 명령을 차단하려면 같은 설정 파일 또는 플래그에서 `Bash`만 있는 항목을 `Bash(git push *)` 같은 범위가 지정된 규칙으로 바꾸세요. Claude는 Bash 도구를 유지하며, PowerShell 도구는 변수를 설정하거나 범위가 지정된 [`PowerShell` 권한 규칙](https://code.claude.com/docs/ko/permissions#powershell)을 추가할 때까지 꺼진 상태로 유지됩니다.

[백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)에서 또는 `--output-format json`이나 `stream-json`을 사용하는 경우, Claude Code는 경고를 stderr 대신 디버그 로그에 기록합니다. `--debug`로 실행하면 `~/.claude/debug/<session-id>.txt`에서 확인할 수 있습니다. v2.1.287 이전에는 Claude Code가 경고를 출력하지 않고 같은 방식으로 PowerShell 도구를 껐습니다.

v2.1.305 이전에는 대화형 세션도 시작 시 경고를 stderr에 출력했습니다.

### crossSessionInbound는 accept, hold, refuse 중 하나여야 함

설정 파일이 [`crossSessionInbound`](https://code.claude.com/docs/ko/settings-reference#crosssessioninbound)를 오타 `"reject"`처럼 Claude Code가 인식하지 못하는 값으로 설정했습니다. 경고의 두 번째 문장은 어느 파일에 값이 있는지에 따라 다르며, 사용자, 프로젝트, 로컬 또는 `--settings` 파일에서는 다음과 같습니다:

```text theme={null}
"crossSessionInbound" must be one of "accept", "hold", "refuse"; received "reject". This value was ignored; while it is present, cross-session messages are held for your approval instead of being delivered. Set it to one of the values above.
```

[관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서는 Claude Code가 인식되지 않는 값을 가장 제한적인 값인 `refuse`로 취급하며, 경고는 관리자가 수정할 때까지 세션 간 메시지가 거부된다고 알립니다. 보류가 다른 설정 파일의 값과 어떻게 결합되는지는 [`crossSessionInbound`](https://code.claude.com/docs/ko/settings-reference#crosssessioninbound)를 참조하세요.

**할 일:**

* 키를 `"accept"`, `"hold"`, 또는 `"refuse"`로 설정하거나 제거하세요.
* 경고가 관리형 설정을 명시하면 관리자에게 값을 수정하도록 요청하세요.

v2.1.248 이전에는 Claude Code가 인식되지 않는 값을 경고 없이 무시했습니다.

### ANTHROPIC\_FOUNDRY\_RESOURCE는 Foundry 리소스 이름이어야 함

[`ANTHROPIC_FOUNDRY_RESOURCE`](https://code.claude.com/docs/ko/env-vars)를 엔드포인트 URL이나 해당 호스트 이름처럼 순수한 [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md) 리소스 이름이 아닌 값으로 설정했습니다. Claude Code는 요청을 보내기 전에 해당 값을 거부했습니다. 이 메시지는 시작 경고가 아니라 Claude의 응답 대신 나타납니다:

```text theme={null}
API Error: ANTHROPIC_FOUNDRY_RESOURCE must be a Foundry resource name (2-64 letters, digits and hyphens, not starting or ending with a hyphen, such as my-resource), not a URL or host name. To use a full URL, set ANTHROPIC_FOUNDRY_BASE_URL instead.
```

**할 일:**

* `ANTHROPIC_FOUNDRY_RESOURCE`를 리소스 이름만으로 설정하고 Claude Code를 다시 시작하세요. 엔드포인트 `https://my-resource.services.ai.azure.com/anthropic`의 경우 이름은 `my-resource`입니다.
* 대신 전체 엔드포인트 URL을 지정하려면 [`ANTHROPIC_FOUNDRY_BASE_URL`](https://code.claude.com/docs/ko/env-vars)을 해당 URL로 설정하고 `ANTHROPIC_FOUNDRY_RESOURCE`를 제거한 후 Claude Code를 다시 시작하세요. Claude Code는 두 변수 중 하나만 허용합니다.

### 200K 제한이 적용되지 않음

[`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](https://code.claude.com/docs/ko/env-vars)을 설정하면 일반적으로 [자동 압축](https://code.claude.com/docs/ko/model-config.md#default-auto-compact-thresholds)이 1M 컨텍스트 모델의 세션을 200K 윈도우로 유지하지만, 이 세션을 200K 이하로 제한하는 압축 임계값이 없으므로 대화가 200K를 넘어 커질 수 있습니다.

```text theme={null}
CLAUDE_CODE_DISABLE_1M_CONTEXT is set, but the 200K limit isn't enforced for <model>, so this session can grow past it. To enforce it, set CLAUDE_CODE_AUTO_COMPACT_WINDOW=200000 (or the autoCompactWindow setting).
```

Claude Code는 기본적으로 1M 윈도우를 가진 것으로 인식하는 모든 모델에 대해 200K 제한을 자체적으로 적용하며, 인식하지 못하는 모델 ID에 대해서는 가정한 윈도우에서 압축합니다. 이 경고는 다른 구성이 이러한 적용을 무력화할 때 나타납니다:

* 모델 ID가 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 별칭처럼 Claude Code가 인식하지 못하는 것이고, [`CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT=1`](https://code.claude.com/docs/ko/env-vars)을 설정했거나 [`CLAUDE_CODE_MAX_CONTEXT_TOKENS`](https://code.claude.com/docs/ko/env-vars)로 가정 윈도우를 200K 이상으로 올린 경우. 이 경우 메시지는 해결책으로 `or update to a Claude Code version that recognizes <model>`도 제시합니다.
* [`ANTHROPIC_BETAS`](https://code.claude.com/docs/ko/env-vars) 또는 [`--betas`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 플래그로 요청한 `context-1m` 베타가 해당 베타를 지원하는 모델에서 여전히 API에 1M 윈도우를 요청하는 반면, 200K에서 세션을 압축하는 것이 없는 경우

**할 일:**

* [`CLAUDE_CODE_AUTO_COMPACT_WINDOW=200000`](https://code.claude.com/docs/ko/env-vars)을 설정하거나 [`autoCompactWindow`](https://code.claude.com/docs/ko/settings-reference#autocompactwindow) 설정을 `200000`으로 설정하여 자동 압축이 200K 경계에서 압축하도록 하세요.
* 메시지가 이 버전이 인식하지 못하는 모델 ID를 명시하면 `claude update`를 실행하세요. 해당 ID를 1M 컨텍스트 모델로 인식하는 버전은 추가 구성 없이 제한을 적용합니다.
* 세션이 대신 모델의 전체 윈도우를 사용하기를 원하면 `CLAUDE_CODE_DISABLE_1M_CONTEXT`를 설정 해제하세요. 이 경고는 200K 제한이 적용되지 않는다는 사실만 알립니다.

텍스트 출력을 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 이 경고가 stderr에 나타납니다. 대화형 세션, [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md), 또는 `--output-format json`이나 `stream-json`을 사용하는 경우에는 대신 디버그 로그에 기록됩니다. `--debug`로 실행하면 `~/.claude/debug/<session-id>.txt`에서 확인할 수 있습니다.

v2.1.305 이전에는 대화형 세션이 시작 시 경고를 stderr에 출력했습니다.

### 요청에서 인식되지 않은 모델 ID

Claude Code가 사용 중인 Claude Code 버전이 인식하지 못하는 모델 ID로 요청을 보냈으며, 해당 ID를 인식하는 모델에 매핑하는 [`modelOverrides`](https://code.claude.com/docs/ko/model-config#override-model-ids-per-version) 항목을 찾지 못했습니다. Claude Code는 여전히 구성된 그대로의 ID로 요청을 보내며, 종료하거나 모델을 전환하지 않습니다.

```text theme={null}
[claude-code:unrecognized_model] {"model":"my-proxy-model","query_source":"sdk"}
```

stderr를 읽는 스크립트나 하네스에서는 `[claude-code:unrecognized_model]` 접두사로 일치시키세요. 접두사와 공백 하나 뒤에 Claude Code는 한 줄짜리 JSON 객체를 기록합니다. Claude Code는 이후 버전에서 필드를 추가할 수 있으므로 예상하지 못한 필드는 무시하세요. 최소한 다음 두 필드는 기록됩니다:

* `model`: 구성된 그대로의 모델 문자열
* `query_source`: 모델을 사용한 요청 경로. Claude Code는 `-p` 실행에 대해 `sdk`를, 서브에이전트에 대해 `agent:`로 시작하는 값을 보고합니다.

Claude Code는 실행 방식에 따라 두 곳 중 하나에 이 줄을 기록합니다:

* `-p`를 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서는 모든 `--output-format`에서 stderr에 기록하므로, 이 줄을 걸러내지 않고도 stdout을 구문 분석할 수 있습니다.
* 대화형 세션 또는 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)에서는 대신 디버그 로그에 기록합니다. `--debug`로 실행하면 `~/.claude/debug/<session-id>.txt`에서 확인할 수 있습니다.

Claude Code는 프로세스당 모델 문자열마다 한 번씩 이 줄을 기록합니다. [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)나 [백그라운드 기능](https://code.claude.com/docs/ko/costs.md#background-token-usage)이 사용하는 것처럼 추가로 인식되지 않는 ID마다 별도의 줄을 기록합니다.

Claude Code는 Amazon Bedrock `us.anthropic.claude-...` ID, `@` 버전 접미사가 있는 Google Cloud의 Agent Platform ID, Claude 모델 ID를 포함하는 Microsoft Foundry 배포 이름처럼 인식하는 모델로 해석되는 공급자 ID에 대해서는 이 줄을 기록하지 않습니다. Amazon Bedrock [애플리케이션 추론 프로필 ARN](https://code.claude.com/docs/ko/amazon-bedrock.md#map-each-model-version-to-an-inference-profile)의 경우 ARN 자체가 아니라 그 뒤의 모델을 확인합니다. 잘못 입력한 ARN처럼 해석할 수 없는 ARN에 대해서는 줄을 기록하지 않습니다.

**할 일:**

* [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 별칭처럼 ID를 의도적으로 설정한 경우, 해당 ID를 값으로 하는 [`modelOverrides`](https://code.claude.com/docs/ko/model-config#override-model-ids-per-version) 항목을 [설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)에 추가하세요. 키로는 `opus` 같은 패밀리 별칭이 아닌 Anthropic 모델 ID를 사용하세요. 예시 줄의 `my-proxy-model`에 대해서는 다음 항목을 추가합니다:

  ```json theme={null}
  {
    "modelOverrides": {
      "claude-opus-4-6": "my-proxy-model"
    }
  }
  ```

  그러면 Claude Code는 `my-proxy-model`을 `claude-opus-4-6`으로 취급하고 줄 기록을 중지합니다.

* ID가 사용 중인 Claude Code 버전보다 최신 모델을 가리키면 `claude update`를 실행하세요.

* ID가 오타인 경우 [모델을 설정할 수 있는 위치](https://code.claude.com/docs/ko/model-config.md#setting-your-model) 또는 [별칭 변수](https://code.claude.com/docs/ko/model-config.md#environment-variables) 중 해당 ID가 있는 곳에서 수정하세요. `query_source`가 `agent:`로 시작하면 대신 [서브에이전트의 모델](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)을 설정한 곳에서 수정하세요.

v2.1.233 이전에는 Claude Code가 인식하지 못하는 모델 ID로 요청을 보낼 때 줄을 기록하지 않았습니다.

### 관리형 잠금에서 샌드박스 허용 항목이 무시됨

`/status` 및 `claude doctor`의 이 경고는 관리형 설정이 [`allowManagedReadPathsOnly`](https://code.claude.com/docs/ko/settings-reference#sandbox-filesystem-allowmanagedreadpathsonly) 또는 [`allowManagedDomainsOnly`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-allowmanageddomainsonly)를 설정했으므로, 경고가 명시한 파일의 [`allowRead`](https://code.claude.com/docs/ko/settings-reference#sandbox-filesystem-allowread) 또는 [`allowedDomains`](https://code.claude.com/docs/ko/settings-reference#sandbox-network-alloweddomains) 항목이 적용되지 않는다는 의미입니다:

```text wrap theme={null}
sandbox.filesystem.allowRead is ignored — managed settings set allowManagedReadPathsOnly, so only allowRead paths from managed settings are honored. The 3 entries in /home/you/.claude/settings.json will NOT apply (see https://code.claude.com/docs/en/settings#sandbox-settings).
```

네트워크 잠금의 경우 경고는 `sandbox.network.allowedDomains`와 `allowManagedDomainsOnly`를 명시하고, `only allowed domains (and WebFetch domain rules) from managed settings are honored`라고 알립니다.

**할 일:**

* 이 경고에 대해 조치할 필요는 없습니다.
* 해당 경로나 도메인이 필요하고 조직의 관리형 설정이 잠금을 설정한 경우 관리자에게 해당 설정에 추가하도록 요청하세요. 명시된 파일에서 항목을 제거하기 전까지 경고는 계속 표시됩니다.
* 경고를 없애려면 명시된 파일에서 항목을 제거하세요. 프로젝트의 `.claude/settings.json`처럼 공유하는 파일의 경우, 잠금이 없는 팀원을 위해 항목을 그대로 두고 경고가 표시되도록 둘 수 있습니다.

### 쓰기 거부 경로에 남은 샌드박스 마스크 파일

`claude doctor` 및 `/status`의 이 경고는 마스크 파일, 즉 [샌드박스](https://code.claude.com/docs/ko/sandboxing.md)가 쓰기를 거부하는 경로에 있는 0바이트 읽기 전용 자리 표시자 파일을 나열합니다. 이 경고는 Linux 및 WSL2에서 파일 시스템 격리가 켜진 상태로 샌드박싱이 활성화된 경우에 나타납니다. 해당 파일이 있는 프로젝트에 열려 있는 Claude Code 세션이 없을 때 셸에서 삭제하세요.

샌드박스는 샌드박스된 명령이 실행되는 동안 자리 표시자를 만들고 명령이 끝나면 제거합니다. 다음과 같은 경우에는 자리 표시자가 남습니다:

* 명령이 끝나기 전에 SIGKILL 등으로 세션이 강제 종료된 경우
* 백그라운드에서 실행 중인 명령처럼 샌드박스된 명령이 아직 실행 중인 상태에서 세션을 종료한 경우

`claude doctor`에서 경고는 다음과 같이 표시됩니다:

```text theme={null}
- Sandbox mask files left behind at write-deny paths: /home/you/project/.claude/settings.local.json
  Fix: A session leaves one where it was killed, or where it exited while a sandboxed command was still running. Remove each with `rm <path>` while no other Claude Code session is running in that project — a 0-byte read-only file where a settings file belongs makes "Yes, and don't ask again" fail to save, and the sandbox binds it read-only again on every start
```

**할 일:**

* `/status`에 경고가 표시된 세션을 포함하여 나열된 파일이 있는 프로젝트에 열려 있는 모든 Claude Code 세션을 종료한 다음 셸에서 작업하세요. 다른 세션의 샌드박스가 아직 사용 중인 자리 표시자는 해당 세션의 쓰기 보호에서 실제로 작동하는 부분입니다.
* 셸에서 나열된 각 파일을 `rm`으로 삭제하고, `rm`이 쓰기 보호된 파일에 대해 물으면 확인하세요. 경고는 최대 3개의 파일을 명시하고 나머지는 개수로 표시하므로, 삭제 후 경고가 더 이상 나타나지 않을 때까지 `claude doctor`를 다시 실행하세요.
* "Yes, and don't ask again"으로 저장한 권한 선택이 유지되지 않았다면 자리 표시자를 삭제한 후 다시 저장하세요.

v2.1.309 이전에는 경고가 `Stale sandbox mask files left by a killed session`으로 표시되었습니다.

v2.1.257 이전에는 `claude doctor`가 이러한 파일을 표시하지 않았으며, 이전 버전에서도 세션이 강제 종료되면 같은 자리 표시자가 남습니다.

## 응답 품질이 평소보다 낮아 보입니다

Claude의 답변이 예상보다 덜 능력 있어 보이지만 오류가 표시되지 않는 경우, 원인은 일반적으로 모델 자체가 아니라 대화 상태입니다. Claude Code는 모델 버전을 자동으로 변경하지 않습니다. 다음의 경우에 폴백 모델로 전환할 수 있습니다:

* 구성된 [`--fallback-model`](https://code.claude.com/docs/ko/cli-reference#cli-flags)은 가용성 오류 후 해당 턴에만 제어를 인수받으며, 트랜스크립트에 공지가 표시됩니다
* Amazon Bedrock 또는 Google Cloud의 Agent Platform 시작 확인에서 기본 모델을 사용할 수 없음을 발견하거나, 계정이 [세션 중간에 모델에 대한 액세스를 잃음](https://code.claude.com/docs/ko/amazon-bedrock.md#when-a-model-is-disabled-mid-session)
* [자동 모델 폴백](https://code.claude.com/docs/ko/model-config.md#automatic-model-fallback)은 Fable 5.1, Fable 5, Opus 5.5, Sonnet 5.5, Opus 5에서 세션을 플래그된 카테고리의 폴백 모델로 이동하며, 해당 카테고리에 폴백 모델이 있을 때 트랜스크립트에 공지를 표시합니다

아래의 모델 선택 확인은 두 번째와 세 번째 경우를 포착합니다. 첫 번째는 `/model` 변경이 아니라 트랜스크립트 공지로 나타납니다. [모델 구성](https://code.claude.com/docs/ko/model-config.md)에서 각 폴백이 적용되는 시기를 설명합니다.

먼저 다음을 확인하십시오:

* **모델 선택**: `/model`을 실행하여 예상하는 모델에 있는지 확인합니다. 이전 `/model` 선택 또는 `ANTHROPIC_MODEL` 환경 변수로 인해 의도한 것보다 작은 모델에 있을 수 있습니다.
* **노력 수준**: `/effort`를 실행하여 현재 추론 수준을 확인하고 어려운 디버깅 또는 설계 작업을 위해 높입니다. 기본값은 모델에 따라 다르므로 최대값 이하에 있다고 가정하기 전에 확인하십시오. [노력 수준 조정](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)에서 모델별 기본값과 `ultrathink` 바로가기를 참조하십시오.
* **컨텍스트 압력**: `/context`를 실행하여 윈도우가 얼마나 찼는지 확인합니다. 용량에 가까우면 자연스러운 지점에서 `/compact`를 실행하거나 `/clear`를 실행하여 새로 시작합니다. [컨텍스트 윈도우 탐색](https://code.claude.com/docs/ko/context-window.md)에서 자동 압축이 이전 턴에 어떻게 영향을 미치는지 확인하십시오.
* **오래된 지침**: 크거나 오래된 `CLAUDE.md` 파일과 MCP 도구 정의는 컨텍스트를 소비하고 응답을 조종할 수 있습니다. `/doctor` 점검은 크기가 큰 메모리 파일과 사용하지 않는 확장을 플래그하며, `/context`는 MCP 도구 토큰 사용량을 표시합니다. v2.1.205 이전에는 `/doctor`가 크기가 큰 메모리 파일과 서브에이전트 정의를 플래그하는 진단 화면을 열었습니다.

응답이 잘못되면 수정으로 회신하는 것보다 되감기가 일반적으로 더 잘 작동합니다. Esc를 두 번 누르거나 `/rewind`를 실행하여 잘못된 턴 이전으로 돌아간 다음 더 구체적인 내용으로 프롬프트를 다시 표현합니다. 스레드 내에서 수정하면 잘못된 시도가 컨텍스트에 남아 있어 나중의 답변을 고정할 수 있습니다. [체크포인팅](https://code.claude.com/docs/ko/checkpointing.md)을 참조하십시오.

위의 항목을 확인한 후에도 품질이 여전히 좋지 않으면 `/feedback`을 실행하고 예상한 것과 얻은 것을 설명합니다. 이 방식으로 제출된 피드백에는 대화 트랜스크립트가 포함되어 있으며, 이는 Anthropic이 실제 회귀를 진단하는 가장 빠른 방법입니다. 환경에서 `/feedback`을 사용할 수 없는 경우 [오류 보고](#report-an-error)를 참조하십시오.

Claude가 의심되는 프롬프트 주입에 대해 경고하거나 의심되는 주입으로 인해 요청을 거부하고, 경고가 명명하는 텍스트가 파일 또는 웹 콘텐츠가 아니라 Claude Code가 대화에 자동으로 추가하는 컨텍스트인 경우 `claude update`를 실행하고 다시 시도합니다. 업데이트 후 경고가 반복되면 플래그된 콘텐츠를 프롬프트에 다시 붙여넣는 대신 [보고](#report-an-error)합니다. v2.1.201 이전에는 Sonnet 5가 같은 방식으로 일부 요청을 거부했습니다.

## 오류 보고

이 페이지에서 다루지 않는 구성 요소의 오류는 관련 가이드를 참조하십시오:

* MCP 서버 연결 또는 인증 실패: [MCP](https://code.claude.com/docs/ko/mcp.md)
* 훅 스크립트 실패 또는 도구 차단: [훅 디버깅](https://code.claude.com/docs/ko/hooks.md#debug-hooks)
* 설치 중 권한 거부 또는 파일 시스템 오류: [설치 및 로그인 문제 해결](https://code.claude.com/docs/ko/troubleshoot-install.md)

오류가 여기에 나열되지 않았거나 제안된 해결 방법이 도움이 되지 않는 경우:

* Claude Code 내에서 `/feedback`을 실행하여 기록 및 설명을 Anthropic에 전송하십시오. 이 명령은 미리 작성된 GitHub 이슈를 열 수 있는 옵션도 제공합니다. Anthropic에 전송하려면 [인증](https://code.claude.com/docs/ko/authentication.md)이 필요합니다. Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 및 기타 타사 제공자에서 또는 Anthropic 자격 증명이 구성되지 않은 경우, `/feedback`은 대신 Anthropic 계정 담당자에게 보낼 수 있는 로컬 아카이브를 저장합니다.
* `/feedback`이 조직의 정책에 의해 비활성화되었다고 응답하는 경우 [해당 메시지 항목](#feedback-is-disabled-by-your-organizations-policy)을 참조하십시오
* 셸에서 `claude doctor`를 실행하여 설치의 읽기 전용 진단을 수행하거나, Claude Code 내에서 `/doctor` 점검을 실행하여 설정 문제를 찾고 수정하십시오
* [status.claude.com](https://status.claude.com)에서 활성 인시던트를 확인하십시오
* GitHub의 [기존 이슈](https://github.com/anthropics/claude-code/issues)를 검색하십시오
