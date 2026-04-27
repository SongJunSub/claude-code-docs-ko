> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Agent SDK 참조 - TypeScript

> TypeScript Agent SDK의 완전한 API 참조로, 모든 함수, 타입 및 인터페이스를 포함합니다.

<script src="/components/typescript-sdk-type-links.js" defer />

<Note>
  **새로운 V2 인터페이스 시도 (미리보기):** `send()` 및 `stream()` 패턴을 사용하는 간소화된 인터페이스가 이제 사용 가능하며, 다중 턴 대화를 더 쉽게 만듭니다. [TypeScript V2 미리보기에 대해 자세히 알아보기](/ko/agent-sdk/typescript-v2-preview)
</Note>

## 설치

```bash theme={null}
npm install @anthropic-ai/claude-agent-sdk
```

<Note>
  SDK는 선택적 종속성으로 플랫폼용 네이티브 Claude Code 바이너리를 번들로 제공합니다(예: `@anthropic-ai/claude-agent-sdk-darwin-arm64`). Claude Code를 별도로 설치할 필요가 없습니다. 패키지 관리자가 선택적 종속성을 건너뛰면 SDK는 `Native CLI binary for <platform> not found` 오류를 발생시킵니다. 이 경우 [`pathToClaudeCodeExecutable`](#options)을 별도로 설치된 `claude` 바이너리로 설정하세요.
</Note>

## 함수

### `query()`

Claude Code와 상호작용하기 위한 주요 함수입니다. 메시지가 도착할 때 스트리밍하는 비동기 생성기를 만듭니다.

```typescript theme={null}
function query({
  prompt,
  options
}: {
  prompt: string | AsyncIterable<SDKUserMessage>;
  options?: Options;
}): Query;
```

#### 매개변수

| 매개변수      | 타입                                                                | 설명                                      |
| :-------- | :---------------------------------------------------------------- | :-------------------------------------- |
| `prompt`  | `string \| AsyncIterable<`[`SDKUserMessage`](#sdkuser-message)`>` | 문자열 또는 스트리밍 모드용 비동기 반복 가능 객체로서의 입력 프롬프트 |
| `options` | [`Options`](#options)                                             | 선택적 구성 객체 (아래 Options 타입 참조)            |

#### 반환값

[`Query`](#query-object) 객체를 반환하며, 이는 추가 메서드를 포함하는 `AsyncGenerator<`[`SDKMessage`](#sdk-message)`, void>`를 확장합니다.

### `startup()`

프롬프트를 사용할 수 있기 전에 CLI 서브프로세스를 생성하고 초기화 핸드셰이크를 완료하여 미리 준비합니다. 반환된 [`WarmQuery`](#warm-query) 핸들은 나중에 프롬프트를 수락하고 이미 준비된 프로세스에 작성하므로, 첫 번째 `query()` 호출은 서브프로세스 생성 및 초기화 비용을 지불하지 않고 해결됩니다.

```typescript theme={null}
function startup(params?: {
  options?: Options;
  initializeTimeoutMs?: number;
}): Promise<WarmQuery>;
```

#### 매개변수

| 매개변수                  | 타입                    | 설명                                                                                       |
| :-------------------- | :-------------------- | :--------------------------------------------------------------------------------------- |
| `options`             | [`Options`](#options) | 선택적 구성 객체입니다. `query()`의 `options` 매개변수와 동일합니다                                           |
| `initializeTimeoutMs` | `number`              | 서브프로세스 초기화를 기다릴 최대 시간(밀리초)입니다. 기본값은 `60000`입니다. 초기화가 시간 내에 완료되지 않으면 프로미스는 타임아웃 오류로 거부됩니다 |

#### 반환값

서브프로세스가 생성되고 초기화 핸드셰이크를 완료하면 해결되는 `Promise<`[`WarmQuery`](#warm-query)`>`를 반환합니다.

#### 예제

`startup()`을 조기에 호출합니다(예: 애플리케이션 부팅 시). 그런 다음 프롬프트가 준비되면 반환된 핸들에서 `.query()`를 호출합니다. 이렇게 하면 서브프로세스 생성 및 초기화가 중요 경로에서 벗어납니다.

```typescript theme={null}
import { startup } from "@anthropic-ai/claude-agent-sdk";

// 시작 비용을 미리 지불합니다
const warm = await startup({ options: { maxTurns: 3 } });

// 나중에 프롬프트가 준비되면 이것은 즉시입니다
for await (const message of warm.query("What files are here?")) {
  console.log(message);
}
```

### `tool()`

SDK MCP 서버와 함께 사용하기 위한 타입 안전 MCP 도구 정의를 만듭니다.

```typescript theme={null}
function tool<Schema extends AnyZodRawShape>(
  name: string,
  description: string,
  inputSchema: Schema,
  handler: (args: InferShape<Schema>, extra: unknown) => Promise<CallToolResult>,
  extras?: { annotations?: ToolAnnotations }
): SdkMcpToolDefinition<Schema>;
```

#### 매개변수

| 매개변수          | 타입                                                                  | 설명                                              |
| :------------ | :------------------------------------------------------------------ | :---------------------------------------------- |
| `name`        | `string`                                                            | 도구의 이름                                          |
| `description` | `string`                                                            | 도구가 수행하는 작업에 대한 설명                              |
| `inputSchema` | `Schema extends AnyZodRawShape`                                     | 도구의 입력 매개변수를 정의하는 Zod 스키마 (Zod 3 및 Zod 4 모두 지원) |
| `handler`     | `(args, extra) => Promise<`[`CallToolResult`](#call-tool-result)`>` | 도구 로직을 실행하는 비동기 함수                              |
| `extras`      | `{ annotations?: `[`ToolAnnotations`](#tool-annotations)` }`        | 클라이언트에 동작 힌트를 제공하는 선택적 MCP 도구 주석                |

#### `ToolAnnotations`

`@modelcontextprotocol/sdk/types.js`에서 다시 내보냅니다. 모든 필드는 선택적 힌트입니다. 클라이언트는 보안 결정을 위해 이들을 신뢰해서는 안 됩니다.

| 필드                | 타입        | 기본값         | 설명                                                                            |
| :---------------- | :-------- | :---------- | :---------------------------------------------------------------------------- |
| `title`           | `string`  | `undefined` | 도구의 사람이 읽을 수 있는 제목                                                            |
| `readOnlyHint`    | `boolean` | `false`     | `true`이면 도구는 환경을 수정하지 않습니다                                                    |
| `destructiveHint` | `boolean` | `true`      | `true`이면 도구는 파괴적인 업데이트를 수행할 수 있습니다 (`readOnlyHint`가 `false`일 때만 의미 있음)        |
| `idempotentHint`  | `boolean` | `false`     | `true`이면 동일한 인수로 반복 호출해도 추가 효과가 없습니다 (`readOnlyHint`가 `false`일 때만 의미 있음)      |
| `openWorldHint`   | `boolean` | `true`      | `true`이면 도구는 외부 엔티티와 상호작용합니다 (예: 웹 검색). `false`이면 도구의 도메인은 폐쇄적입니다 (예: 메모리 도구) |

```typescript theme={null}
import { tool } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

const searchTool = tool(
  "search",
  "Search the web",
  { query: z.string() },
  async ({ query }) => {
    return { content: [{ type: "text", text: `Results for: ${query}` }] };
  },
  { annotations: { readOnlyHint: true, openWorldHint: true } }
);
```

### `createSdkMcpServer()`

애플리케이션과 동일한 프로세스에서 실행되는 MCP 서버 인스턴스를 만듭니다.

```typescript theme={null}
function createSdkMcpServer(options: {
  name: string;
  version?: string;
  tools?: Array<SdkMcpToolDefinition<any>>;
}): McpSdkServerConfigWithInstance;
```

#### 매개변수

| 매개변수              | 타입                            | 설명                              |
| :---------------- | :---------------------------- | :------------------------------ |
| `options.name`    | `string`                      | MCP 서버의 이름                      |
| `options.version` | `string`                      | 선택적 버전 문자열                      |
| `options.tools`   | `Array<SdkMcpToolDefinition>` | [`tool()`](#tool)로 만든 도구 정의의 배열 |

### `listSessions()`

가벼운 메타데이터를 포함한 과거 세션을 발견하고 나열합니다. 프로젝트 디렉토리별로 필터링하거나 모든 프로젝트에서 세션을 나열합니다.

```typescript theme={null}
function listSessions(options?: ListSessionsOptions): Promise<SDKSessionInfo[]>;
```

#### 매개변수

| 매개변수                       | 타입        | 기본값         | 설명                                                |
| :------------------------- | :-------- | :---------- | :------------------------------------------------ |
| `options.dir`              | `string`  | `undefined` | 세션을 나열할 디렉토리입니다. 생략하면 모든 프로젝트에서 세션을 반환합니다         |
| `options.limit`            | `number`  | `undefined` | 반환할 최대 세션 수                                       |
| `options.includeWorktrees` | `boolean` | `true`      | `dir`이 git 저장소 내에 있을 때 모든 worktree 경로에서 세션을 포함합니다 |

#### 반환 타입: `SDKSessionInfo`

| 속성             | 타입                    | 설명                                                 |
| :------------- | :-------------------- | :------------------------------------------------- |
| `sessionId`    | `string`              | 고유 세션 식별자 (UUID)                                   |
| `summary`      | `string`              | 표시 제목: 사용자 정의 제목, 자동 생성된 요약 또는 첫 번째 프롬프트           |
| `lastModified` | `number`              | 에포크 이후 밀리초 단위의 마지막 수정 시간                           |
| `fileSize`     | `number \| undefined` | 세션 파일 크기(바이트)입니다. 로컬 JSONL 저장소에만 채워집니다             |
| `customTitle`  | `string \| undefined` | 사용자가 설정한 세션 제목 (`/rename`을 통해)                     |
| `firstPrompt`  | `string \| undefined` | 세션의 첫 번째 의미 있는 사용자 프롬프트                            |
| `gitBranch`    | `string \| undefined` | 세션 끝의 git 분기                                       |
| `cwd`          | `string \| undefined` | 세션의 작업 디렉토리                                        |
| `tag`          | `string \| undefined` | 사용자가 설정한 세션 태그 ([`tagSession()`](#tag-session) 참조) |
| `createdAt`    | `number \| undefined` | 첫 번째 항목의 타임스탬프에서 에포크 이후 밀리초 단위의 생성 시간              |

#### 예제

프로젝트의 10개 최신 세션을 인쇄합니다. 결과는 `lastModified` 내림차순으로 정렬되므로 첫 번째 항목이 가장 최신입니다. 모든 프로젝트에서 검색하려면 `dir`을 생략합니다.

```typescript theme={null}
import { listSessions } from "@anthropic-ai/claude-agent-sdk";

const sessions = await listSessions({ dir: "/path/to/project", limit: 10 });

for (const session of sessions) {
  console.log(`${session.summary} (${session.sessionId})`);
}
```

### `getSessionMessages()`

과거 세션 트랜스크립트에서 사용자 및 어시스턴트 메시지를 읽습니다.

```typescript theme={null}
function getSessionMessages(
  sessionId: string,
  options?: GetSessionMessagesOptions
): Promise<SessionMessage[]>;
```

#### 매개변수

| 매개변수             | 타입       | 기본값         | 설명                                                 |
| :--------------- | :------- | :---------- | :------------------------------------------------- |
| `sessionId`      | `string` | 필수          | 읽을 세션 UUID ([`listSessions()`](#list-sessions) 참조) |
| `options.dir`    | `string` | `undefined` | 세션을 찾을 프로젝트 디렉토리입니다. 생략하면 모든 프로젝트를 검색합니다           |
| `options.limit`  | `number` | `undefined` | 반환할 최대 메시지 수                                       |
| `options.offset` | `number` | `undefined` | 시작 부분에서 건너뛸 메시지 수                                  |

#### 반환 타입: `SessionMessage`

| 속성                   | 타입                      | 설명                  |
| :------------------- | :---------------------- | :------------------ |
| `type`               | `"user" \| "assistant"` | 메시지 역할              |
| `uuid`               | `string`                | 고유 메시지 식별자          |
| `session_id`         | `string`                | 이 메시지가 속한 세션        |
| `message`            | `unknown`               | 트랜스크립트의 원본 메시지 페이로드 |
| `parent_tool_use_id` | `null`                  | 예약됨                 |

#### 예제

```typescript theme={null}
import { listSessions, getSessionMessages } from "@anthropic-ai/claude-agent-sdk";

const [latest] = await listSessions({ dir: "/path/to/project", limit: 1 });

if (latest) {
  const messages = await getSessionMessages(latest.sessionId, {
    dir: "/path/to/project",
    limit: 20
  });

  for (const msg of messages) {
    console.log(`[${msg.type}] ${msg.uuid}`);
  }
}
```

### `getSessionInfo()`

전체 프로젝트 디렉토리를 스캔하지 않고 ID로 단일 세션의 메타데이터를 읽습니다.

```typescript theme={null}
function getSessionInfo(
  sessionId: string,
  options?: GetSessionInfoOptions
): Promise<SDKSessionInfo | undefined>;
```

#### 매개변수

| 매개변수          | 타입       | 기본값         | 설명                                        |
| :------------ | :------- | :---------- | :---------------------------------------- |
| `sessionId`   | `string` | 필수          | 조회할 세션의 UUID                              |
| `options.dir` | `string` | `undefined` | 프로젝트 디렉토리 경로입니다. 생략하면 모든 프로젝트 디렉토리를 검색합니다 |

[`SDKSessionInfo`](#return-type-sdk-session-info)를 반환하거나, 세션을 찾을 수 없으면 `undefined`를 반환합니다.

### `renameSession()`

사용자 정의 제목 항목을 추가하여 세션의 이름을 바꿉니다. 반복 호출은 안전합니다. 가장 최신 제목이 우선합니다.

```typescript theme={null}
function renameSession(
  sessionId: string,
  title: string,
  options?: SessionMutationOptions
): Promise<void>;
```

#### 매개변수

| 매개변수          | 타입       | 기본값         | 설명                                        |
| :------------ | :------- | :---------- | :---------------------------------------- |
| `sessionId`   | `string` | 필수          | 이름을 바꿀 세션의 UUID                           |
| `title`       | `string` | 필수          | 새 제목입니다. 공백을 제거한 후 비어 있지 않아야 합니다          |
| `options.dir` | `string` | `undefined` | 프로젝트 디렉토리 경로입니다. 생략하면 모든 프로젝트 디렉토리를 검색합니다 |

### `tagSession()`

세션에 태그를 지정합니다. `null`을 전달하여 태그를 지웁니다. 반복 호출은 안전합니다. 가장 최신 태그가 우선합니다.

```typescript theme={null}
function tagSession(
  sessionId: string,
  tag: string | null,
  options?: SessionMutationOptions
): Promise<void>;
```

#### 매개변수

| 매개변수          | 타입               | 기본값         | 설명                                        |
| :------------ | :--------------- | :---------- | :---------------------------------------- |
| `sessionId`   | `string`         | 필수          | 태그를 지정할 세션의 UUID                          |
| `tag`         | `string \| null` | 필수          | 태그 문자열 또는 지우려면 `null`                     |
| `options.dir` | `string`         | `undefined` | 프로젝트 디렉토리 경로입니다. 생략하면 모든 프로젝트 디렉토리를 검색합니다 |

## 타입

### `Options`

`query()` 함수의 구성 객체입니다.

| 속성                                | 타입                                                                                                       | 기본값                                | 설명                                                                                                                                                                                                                                                                                                                                                          |
| :-------------------------------- | :------------------------------------------------------------------------------------------------------- | :--------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `abortController`                 | `AbortController`                                                                                        | `new AbortController()`            | 작업 취소를 위한 컨트롤러                                                                                                                                                                                                                                                                                                                                              |
| `additionalDirectories`           | `string[]`                                                                                               | `[]`                               | Claude가 액세스할 수 있는 추가 디렉토리                                                                                                                                                                                                                                                                                                                                   |
| `agent`                           | `string`                                                                                                 | `undefined`                        | 메인 스레드의 에이전트 이름입니다. 에이전트는 `agents` 옵션 또는 설정에서 정의되어야 합니다                                                                                                                                                                                                                                                                                                     |
| `agents`                          | `Record<string, [`AgentDefinition`](#agent-definition)>`                                                 | `undefined`                        | 프로그래밍 방식으로 서브에이전트 정의                                                                                                                                                                                                                                                                                                                                        |
| `allowDangerouslySkipPermissions` | `boolean`                                                                                                | `false`                            | 권한 건너뛰기 활성화합니다. `permissionMode: 'bypassPermissions'`를 사용할 때 필수입니다                                                                                                                                                                                                                                                                                          |
| `allowedTools`                    | `string[]`                                                                                               | `[]`                               | 프롬프트 없이 자동 승인할 도구입니다. 이것은 Claude를 이 도구들로만 제한하지 않습니다. 나열되지 않은 도구는 `permissionMode` 및 `canUseTool`로 넘어갑니다. `disallowedTools`를 사용하여 도구를 차단합니다. [권한](/ko/agent-sdk/permissions#allow-and-deny-rules) 참조                                                                                                                                                         |
| `betas`                           | [`SdkBeta`](#sdk-beta)`[]`                                                                               | `[]`                               | 베타 기능 활성화                                                                                                                                                                                                                                                                                                                                                   |
| `canUseTool`                      | [`CanUseTool`](#can-use-tool)                                                                            | `undefined`                        | 도구 사용을 위한 사용자 정의 권한 함수                                                                                                                                                                                                                                                                                                                                      |
| `continue`                        | `boolean`                                                                                                | `false`                            | 가장 최근 대화 계속                                                                                                                                                                                                                                                                                                                                                 |
| `cwd`                             | `string`                                                                                                 | `process.cwd()`                    | 현재 작업 디렉토리                                                                                                                                                                                                                                                                                                                                                  |
| `debug`                           | `boolean`                                                                                                | `false`                            | Claude Code 프로세스에 대한 디버그 모드 활성화                                                                                                                                                                                                                                                                                                                             |
| `debugFile`                       | `string`                                                                                                 | `undefined`                        | 특정 파일 경로에 디버그 로그를 작성합니다. 암묵적으로 디버그 모드를 활성화합니다                                                                                                                                                                                                                                                                                                               |
| `disallowedTools`                 | `string[]`                                                                                               | `[]`                               | 항상 거부할 도구입니다. 거부 규칙이 먼저 확인되고 `allowedTools` 및 `permissionMode` (`bypassPermissions` 포함)를 재정의합니다                                                                                                                                                                                                                                                             |
| `effort`                          | `'low' \| 'medium' \| 'high' \| 'xhigh' \| 'max'`                                                        | `'high'`                           | Claude가 응답에 투입하는 노력의 양을 제어합니다. 적응형 사고와 함께 작동하여 사고 깊이를 안내합니다                                                                                                                                                                                                                                                                                                 |
| `enableFileCheckpointing`         | `boolean`                                                                                                | `false`                            | 되감기를 위한 파일 변경 추적을 활성화합니다. [파일 체크포인팅](/ko/agent-sdk/file-checkpointing) 참조                                                                                                                                                                                                                                                                                   |
| `env`                             | `Record<string, string \| undefined>`                                                                    | `process.env`                      | 환경 변수입니다. User-Agent 헤더에서 앱을 식별하려면 `CLAUDE_AGENT_SDK_CLIENT_APP`을 설정합니다                                                                                                                                                                                                                                                                                     |
| `executable`                      | `'bun' \| 'deno' \| 'node'`                                                                              | 자동 감지                              | 사용할 JavaScript 런타임                                                                                                                                                                                                                                                                                                                                          |
| `executableArgs`                  | `string[]`                                                                                               | `[]`                               | 실행 파일에 전달할 인수                                                                                                                                                                                                                                                                                                                                               |
| `extraArgs`                       | `Record<string, string \| null>`                                                                         | `{}`                               | 추가 인수                                                                                                                                                                                                                                                                                                                                                       |
| `fallbackModel`                   | `string`                                                                                                 | `undefined`                        | 기본 모델이 실패할 경우 사용할 모델                                                                                                                                                                                                                                                                                                                                        |
| `forkSession`                     | `boolean`                                                                                                | `false`                            | `resume`으로 재개할 때 원본 세션을 계속하는 대신 새 세션 ID로 포크합니다                                                                                                                                                                                                                                                                                                              |
| `hooks`                           | `Partial<Record<`[`HookEvent`](#hook-event)`, `[`HookCallbackMatcher`](#hook-callback-matcher)`[]>>`     | `{}`                               | 이벤트에 대한 훅 콜백                                                                                                                                                                                                                                                                                                                                                |
| `includePartialMessages`          | `boolean`                                                                                                | `false`                            | 부분 메시지 이벤트 포함                                                                                                                                                                                                                                                                                                                                               |
| `maxBudgetUsd`                    | `number`                                                                                                 | `undefined`                        | 클라이언트 측 비용 추정이 이 USD 값에 도달하면 쿼리를 중지합니다. `total_cost_usd`와 동일한 추정과 비교됩니다. [비용 및 사용량 추적](/ko/agent-sdk/cost-tracking) 참조                                                                                                                                                                                                                                      |
| `maxThinkingTokens`               | `number`                                                                                                 | `undefined`                        | *더 이상 사용되지 않음:* 대신 `thinking`을 사용합니다. 사고 프로세스의 최대 토큰                                                                                                                                                                                                                                                                                                        |
| `maxTurns`                        | `number`                                                                                                 | `undefined`                        | 최대 에이전트 턴 (도구 사용 왕복)                                                                                                                                                                                                                                                                                                                                        |
| `mcpServers`                      | `Record<string, [`McpServerConfig`](#mcp-server-config)>`                                                | `{}`                               | MCP 서버 구성                                                                                                                                                                                                                                                                                                                                                   |
| `model`                           | `string`                                                                                                 | CLI의 기본값                           | 사용할 Claude 모델                                                                                                                                                                                                                                                                                                                                               |
| `outputFormat`                    | `{ type: 'json_schema', schema: JSONSchema }`                                                            | `undefined`                        | 에이전트 결과의 출력 형식을 정의합니다. [구조화된 출력](/ko/agent-sdk/structured-outputs) 참조                                                                                                                                                                                                                                                                                       |
| `pathToClaudeCodeExecutable`      | `string`                                                                                                 | 번들된 네이티브 바이너리에서 자동 해결              | Claude Code 실행 파일의 경로입니다. 설치 중에 선택적 종속성을 건너뛰었거나 플랫폼이 지원되는 집합에 없을 때만 필요합니다                                                                                                                                                                                                                                                                                   |
| `permissionMode`                  | [`PermissionMode`](#permission-mode)                                                                     | `'default'`                        | 세션의 권한 모드                                                                                                                                                                                                                                                                                                                                                   |
| `permissionPromptToolName`        | `string`                                                                                                 | `undefined`                        | 권한 프롬프트용 MCP 도구 이름                                                                                                                                                                                                                                                                                                                                          |
| `persistSession`                  | `boolean`                                                                                                | `true`                             | `false`일 때 디스크에 세션 지속성을 비활성화합니다. 세션을 나중에 재개할 수 없습니다                                                                                                                                                                                                                                                                                                         |
| `plugins`                         | [`SdkPluginConfig`](#sdk-plugin-config)`[]`                                                              | `[]`                               | 로컬 경로에서 사용자 정의 플러그인을 로드합니다. [플러그인](/ko/agent-sdk/plugins) 참조                                                                                                                                                                                                                                                                                                |
| `promptSuggestions`               | `boolean`                                                                                                | `false`                            | 프롬프트 제안을 활성화합니다. 각 턴 후 예측된 다음 사용자 프롬프트를 포함하는 `prompt_suggestion` 메시지를 내보냅니다                                                                                                                                                                                                                                                                                 |
| `resume`                          | `string`                                                                                                 | `undefined`                        | 재개할 세션 ID                                                                                                                                                                                                                                                                                                                                                   |
| `resumeSessionAt`                 | `string`                                                                                                 | `undefined`                        | 특정 메시지 UUID에서 세션 재개                                                                                                                                                                                                                                                                                                                                         |
| `sandbox`                         | [`SandboxSettings`](#sandbox-settings)                                                                   | `undefined`                        | 프로그래밍 방식으로 샌드박스 동작을 구성합니다. [샌드박스 설정](#sandbox-settings) 참조                                                                                                                                                                                                                                                                                                  |
| `sessionId`                       | `string`                                                                                                 | 자동 생성                              | 자동 생성하는 대신 세션에 특정 UUID를 사용합니다                                                                                                                                                                                                                                                                                                                               |
| `sessionStore`                    | [`SessionStore`](/ko/agent-sdk/session-storage#the-session-store-interface)                              | `undefined`                        | 세션 대화를 외부 백엔드로 미러링하여 모든 호스트가 이를 재개할 수 있습니다. [세션을 외부 저장소에 유지](/ko/agent-sdk/session-storage) 참조                                                                                                                                                                                                                                                              |
| `settingSources`                  | [`SettingSource`](#setting-source)`[]`                                                                   | CLI 기본값 (모든 소스)                    | 로드할 파일 시스템 설정을 제어합니다. 사용자, 프로젝트 및 로컬 설정을 비활성화하려면 `[]`을 전달합니다. 관리되는 정책 설정은 어쨌든 로드됩니다. [Claude Code 기능 사용](/ko/agent-sdk/claude-code-features#what-settingsources-does-not-control) 참조                                                                                                                                                                        |
| `spawnClaudeCodeProcess`          | `(options: SpawnOptions) => SpawnedProcess`                                                              | `undefined`                        | Claude Code 프로세스를 생성하는 사용자 정의 함수입니다. VM, 컨테이너 또는 원격 환경에서 Claude Code를 실행하는 데 사용합니다                                                                                                                                                                                                                                                                          |
| `stderr`                          | `(data: string) => void`                                                                                 | `undefined`                        | stderr 출력에 대한 콜백                                                                                                                                                                                                                                                                                                                                            |
| `strictMcpConfig`                 | `boolean`                                                                                                | `false`                            | 엄격한 MCP 검증 적용                                                                                                                                                                                                                                                                                                                                               |
| `systemPrompt`                    | `string \| { type: 'preset'; preset: 'claude_code'; append?: string; excludeDynamicSections?: boolean }` | `undefined` (최소 프롬프트)              | 시스템 프롬프트 구성입니다. 사용자 정의 프롬프트의 경우 문자열을 전달하거나, Claude Code의 시스템 프롬프트를 사용하려면 `{ type: 'preset', preset: 'claude_code' }`를 전달합니다. 프리셋 객체 형식을 사용할 때 `append`를 추가하여 추가 지침으로 확장하고, `excludeDynamicSections: true`를 설정하여 세션별 컨텍스트를 첫 번째 사용자 메시지로 이동하여 [머신 간 프롬프트 캐시 재사용 개선](/ko/agent-sdk/modifying-system-prompts#improve-prompt-caching-across-users-and-machines) |
| `thinking`                        | [`ThinkingConfig`](#thinking-config)                                                                     | 지원되는 모델의 경우 `{ type: 'adaptive' }` | Claude의 사고/추론 동작을 제어합니다. [`ThinkingConfig`](#thinking-config) 참조                                                                                                                                                                                                                                                                                            |
| `toolConfig`                      | [`ToolConfig`](#tool-config)                                                                             | `undefined`                        | 기본 제공 도구 동작의 구성입니다. [`ToolConfig`](#tool-config) 참조                                                                                                                                                                                                                                                                                                         |
| `tools`                           | `string[] \| { type: 'preset'; preset: 'claude_code' }`                                                  | `undefined`                        | 도구 구성입니다. 도구 이름의 배열을 전달하거나 프리셋을 사용하여 Claude Code의 기본 도구를 가져옵니다                                                                                                                                                                                                                                                                                              |

### `Query` 객체

`query()` 함수에서 반환된 인터페이스입니다.

```typescript theme={null}
interface Query extends AsyncGenerator<SDKMessage, void> {
  interrupt(): Promise<void>;
  rewindFiles(
    userMessageId: string,
    options?: { dryRun?: boolean }
  ): Promise<RewindFilesResult>;
  setPermissionMode(mode: PermissionMode): Promise<void>;
  setModel(model?: string): Promise<void>;
  setMaxThinkingTokens(maxThinkingTokens: number | null): Promise<void>;
  initializationResult(): Promise<SDKControlInitializeResponse>;
  supportedCommands(): Promise<SlashCommand[]>;
  supportedModels(): Promise<ModelInfo[]>;
  supportedAgents(): Promise<AgentInfo[]>;
  mcpServerStatus(): Promise<McpServerStatus[]>;
  accountInfo(): Promise<AccountInfo>;
  reconnectMcpServer(serverName: string): Promise<void>;
  toggleMcpServer(serverName: string, enabled: boolean): Promise<void>;
  setMcpServers(servers: Record<string, McpServerConfig>): Promise<McpSetServersResult>;
  streamInput(stream: AsyncIterable<SDKUserMessage>): Promise<void>;
  stopTask(taskId: string): Promise<void>;
  close(): void;
}
```

#### 메서드

| 메서드                                    | 설명                                                                                                                                                           |
| :------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `interrupt()`                          | 쿼리를 중단합니다 (스트리밍 입력 모드에서만 사용 가능)                                                                                                                              |
| `rewindFiles(userMessageId, options?)` | 파일을 지정된 사용자 메시지의 상태로 복원합니다. 변경 사항을 미리 보려면 `{ dryRun: true }`를 전달합니다. `enableFileCheckpointing: true`가 필요합니다. [파일 체크포인팅](/ko/agent-sdk/file-checkpointing) 참조 |
| `setPermissionMode()`                  | 권한 모드를 변경합니다 (스트리밍 입력 모드에서만 사용 가능)                                                                                                                           |
| `setModel()`                           | 모델을 변경합니다 (스트리밍 입력 모드에서만 사용 가능)                                                                                                                              |
| `setMaxThinkingTokens()`               | *더 이상 사용되지 않음:* 대신 `thinking` 옵션을 사용합니다. 최대 사고 토큰을 변경합니다                                                                                                     |
| `initializationResult()`               | 지원되는 명령, 모델, 계정 정보 및 출력 스타일 구성을 포함한 전체 초기화 결과를 반환합니다                                                                                                         |
| `supportedCommands()`                  | 사용 가능한 슬래시 명령을 반환합니다                                                                                                                                         |
| `supportedModels()`                    | 표시 정보를 포함한 사용 가능한 모델을 반환합니다                                                                                                                                  |
| `supportedAgents()`                    | 사용 가능한 서브에이전트를 [`AgentInfo`](#agent-info)`[]`로 반환합니다                                                                                                         |
| `mcpServerStatus()`                    | 연결된 MCP 서버의 상태를 반환합니다                                                                                                                                        |
| `accountInfo()`                        | 계정 정보를 반환합니다                                                                                                                                                 |
| `reconnectMcpServer(serverName)`       | 이름으로 MCP 서버를 다시 연결합니다                                                                                                                                        |
| `toggleMcpServer(serverName, enabled)` | 이름으로 MCP 서버를 활성화 또는 비활성화합니다                                                                                                                                  |
| `setMcpServers(servers)`               | 이 세션의 MCP 서버 집합을 동적으로 바꿉니다. 추가, 제거 및 오류가 발생한 서버에 대한 정보를 반환합니다                                                                                                |
| `streamInput(stream)`                  | 다중 턴 대화를 위해 입력 메시지를 쿼리로 스트리밍합니다                                                                                                                              |
| `stopTask(taskId)`                     | ID로 실행 중인 백그라운드 작업을 중지합니다                                                                                                                                    |
| `close()`                              | 쿼리를 닫고 기본 프로세스를 종료합니다. 쿼리를 강제로 종료하고 모든 리소스를 정리합니다                                                                                                            |

### `WarmQuery`

[`startup()`](#startup)에서 반환된 핸들입니다. 서브프로세스가 이미 생성되고 초기화되었으므로 이 핸들에서 `query()`를 호출하면 시작 지연 없이 준비된 프로세스에 프롬프트를 직접 작성합니다.

```typescript theme={null}
interface WarmQuery extends AsyncDisposable {
  query(prompt: string | AsyncIterable<SDKUserMessage>): Query;
  close(): void;
}
```

#### 메서드

| 메서드             | 설명                                                                                     |
| :-------------- | :------------------------------------------------------------------------------------- |
| `query(prompt)` | 미리 준비된 서브프로세스에 프롬프트를 보내고 [`Query`](#query-object)를 반환합니다. `WarmQuery`당 한 번만 호출할 수 있습니다 |
| `close()`       | 프롬프트를 보내지 않고 서브프로세스를 닫습니다. 더 이상 필요하지 않은 따뜻한 쿼리를 버리는 데 사용합니다                            |

`WarmQuery`는 `AsyncDisposable`을 구현하므로 자동 정리를 위해 `await using`과 함께 사용할 수 있습니다.

### `SDKControlInitializeResponse`

`initializationResult()`의 반환 타입입니다. 세션 초기화 데이터를 포함합니다.

```typescript theme={null}
type SDKControlInitializeResponse = {
  commands: SlashCommand[];
  agents: AgentInfo[];
  output_style: string;
  available_output_styles: string[];
  models: ModelInfo[];
  account: AccountInfo;
  fast_mode_state?: "off" | "cooldown" | "on";
};
```

### `AgentDefinition`

프로그래밍 방식으로 정의된 서브에이전트의 구성입니다.

```typescript theme={null}
type AgentDefinition = {
  description: string;
  tools?: string[];
  disallowedTools?: string[];
  prompt: string;
  model?: string;
  mcpServers?: AgentMcpServerSpec[];
  skills?: string[];
  initialPrompt?: string;
  maxTurns?: number;
  background?: boolean;
  memory?: "user" | "project" | "local";
  effort?: "low" | "medium" | "high" | "xhigh" | "max" | number;
  permissionMode?: PermissionMode;
  criticalSystemReminder_EXPERIMENTAL?: string;
};
```

| 필드                                    | 필수  | 설명                                                                                                                         |
| :------------------------------------ | :-- | :------------------------------------------------------------------------------------------------------------------------- |
| `description`                         | 예   | 이 에이전트를 사용할 시기에 대한 자연어 설명                                                                                                  |
| `tools`                               | 아니오 | 허용된 도구 이름의 배열입니다. 생략하면 부모의 모든 도구를 상속합니다                                                                                    |
| `disallowedTools`                     | 아니오 | 이 에이전트에 대해 명시적으로 허용하지 않을 도구 이름의 배열                                                                                         |
| `prompt`                              | 예   | 에이전트의 시스템 프롬프트                                                                                                             |
| `model`                               | 아니오 | 이 에이전트의 모델 재정의입니다. `'sonnet'`, `'opus'`, `'haiku'`, `'inherit'` 같은 별칭 또는 전체 모델 ID를 허용합니다. 생략하거나 `'inherit'`이면 메인 모델을 사용합니다 |
| `mcpServers`                          | 아니오 | 이 에이전트에 사용 가능한 MCP 서버 사양                                                                                                   |
| `skills`                              | 아니오 | 에이전트 컨텍스트에 미리 로드할 스킬 이름의 배열                                                                                                |
| `initialPrompt`                       | 아니오 | 이 에이전트가 메인 스레드 에이전트로 실행될 때 첫 번째 사용자 턴으로 자동 제출됨                                                                             |
| `maxTurns`                            | 아니오 | 중지하기 전의 최대 에이전트 턴 수 (API 왕복)                                                                                               |
| `background`                          | 아니오 | 호출될 때 이 에이전트를 비차단 백그라운드 작업으로 실행                                                                                            |
| `memory`                              | 아니오 | 이 에이전트의 메모리 소스: `'user'`, `'project'` 또는 `'local'`                                                                         |
| `effort`                              | 아니오 | 이 에이전트의 추론 노력 수준입니다. 명명된 수준 또는 정수를 허용합니다                                                                                   |
| `permissionMode`                      | 아니오 | 이 에이전트 내 도구 실행을 위한 권한 모드입니다. [`PermissionMode`](#permission-mode) 참조                                                       |
| `criticalSystemReminder_EXPERIMENTAL` | 아니오 | 실험적: 시스템 프롬프트에 추가된 중요한 알림                                                                                                  |

### `AgentMcpServerSpec`

서브에이전트에 사용 가능한 MCP 서버를 지정합니다. 서버 이름 (부모의 `mcpServers` 구성에서 서버를 참조하는 문자열) 또는 서버 이름을 구성에 매핑하는 인라인 서버 구성 레코드일 수 있습니다.

```typescript theme={null}
type AgentMcpServerSpec = string | Record<string, McpServerConfigForProcessTransport>;
```

여기서 `McpServerConfigForProcessTransport`는 `McpStdioServerConfig | McpSSEServerConfig | McpHttpServerConfig | McpSdkServerConfig`입니다.

### `SettingSource`

SDK가 설정을 로드하는 파일 시스템 기반 구성 소스를 제어합니다.

```typescript theme={null}
type SettingSource = "user" | "project" | "local";
```

| 값           | 설명                      | 위치                            |
| :---------- | :---------------------- | :---------------------------- |
| `'user'`    | 전역 사용자 설정               | `~/.claude/settings.json`     |
| `'project'` | 공유 프로젝트 설정 (버전 제어됨)     | `.claude/settings.json`       |
| `'local'`   | 로컬 프로젝트 설정 (gitignored) | `.claude/settings.local.json` |

#### 기본 동작

`settingSources`가 생략되거나 `undefined`일 때 `query()`는 Claude Code CLI와 동일한 파일 시스템 설정을 로드합니다: 사용자, 프로젝트 및 로컬입니다. 관리되는 정책 설정은 모든 경우에 로드됩니다. [settingSources가 제어하지 않는 것](/ko/agent-sdk/claude-code-features#what-settingsources-does-not-control)을 참조하여 이 옵션과 관계없이 읽히는 입력과 이를 비활성화하는 방법을 확인하세요.

#### settingSources를 사용하는 이유

**파일 시스템 설정 비활성화:**

```typescript theme={null}
// 디스크에서 사용자, 프로젝트 또는 로컬 설정을 로드하지 않습니다
const result = query({
  prompt: "Analyze this code",
  options: { settingSources: [] }
});
```

**모든 파일 시스템 설정을 명시적으로 로드:**

```typescript theme={null}
const result = query({
  prompt: "Analyze this code",
  options: {
    settingSources: ["user", "project", "local"] // 모든 설정 로드
  }
});
```

**특정 설정 소스만 로드:**

```typescript theme={null}
// 프로젝트 설정만 로드, 사용자 및 로컬 무시
const result = query({
  prompt: "Run CI checks",
  options: {
    settingSources: ["project"] // .claude/settings.json만
  }
});
```

**테스트 및 CI 환경:**

```typescript theme={null}
// CI에서 일관된 동작을 보장하기 위해 로컬 설정 제외
const result = query({
  prompt: "Run tests",
  options: {
    settingSources: ["project"], // 팀 공유 설정만
    permissionMode: "bypassPermissions"
  }
});
```

**SDK 전용 애플리케이션:**

```typescript theme={null}
// 모든 것을 프로그래밍 방식으로 정의합니다.
// 파일 시스템 설정 소스를 거부하려면 []을 전달합니다.
const result = query({
  prompt: "Review this PR",
  options: {
    settingSources: [],
    agents: {
      /* ... */
    },
    mcpServers: {
      /* ... */
    },
    allowedTools: ["Read", "Grep", "Glob"]
  }
});
```

**CLAUDE.md 프로젝트 지침 로드:**

```typescript theme={null}
// 프로젝트 설정을 로드하여 CLAUDE.md 파일 포함
const result = query({
  prompt: "Add a new feature following project conventions",
  options: {
    systemPrompt: {
      type: "preset",
      preset: "claude_code" // Claude Code의 시스템 프롬프트 사용
    },
    settingSources: ["project"], // 프로젝트 디렉토리에서 CLAUDE.md 로드
    allowedTools: ["Read", "Write", "Edit"]
  }
});
```

#### 설정 우선순위

여러 소스가 로드될 때 설정은 이 우선순위로 병합됩니다 (높음에서 낮음):

1. 로컬 설정 (`.claude/settings.local.json`)
2. 프로젝트 설정 (`.claude/settings.json`)
3. 사용자 설정 (`~/.claude/settings.json`)

`agents` 및 `allowedTools`와 같은 프로그래밍 방식의 옵션은 사용자, 프로젝트 및 로컬 파일 시스템 설정을 재정의합니다. 관리되는 정책 설정은 프로그래밍 방식의 옵션보다 우선합니다.

### `PermissionMode`

```typescript theme={null}
type PermissionMode =
  | "default" // 표준 권한 동작
  | "acceptEdits" // 파일 편집 자동 수락
  | "bypassPermissions" // 모든 권한 확인 무시
  | "plan" // 계획 모드 - 실행 없음
  | "dontAsk" // 권한에 대해 프롬프트하지 않음, 미리 승인되지 않으면 거부
  | "auto"; // 모델 분류기를 사용하여 각 도구 호출을 승인 또는 거부
```

### `CanUseTool`

도구 사용을 제어하기 위한 사용자 정의 권한 함수 타입입니다.

```typescript theme={null}
type CanUseTool = (
  toolName: string,
  input: Record<string, unknown>,
  options: {
    signal: AbortSignal;
    suggestions?: PermissionUpdate[];
    blockedPath?: string;
    decisionReason?: string;
    toolUseID: string;
    agentID?: string;
  }
) => Promise<PermissionResult>;
```

| 옵션               | 타입                                           | 설명                                      |
| :--------------- | :------------------------------------------- | :-------------------------------------- |
| `signal`         | `AbortSignal`                                | 작업을 중단해야 하는 경우 신호됨                      |
| `suggestions`    | [`PermissionUpdate`](#permission-update)`[]` | 사용자가 이 도구에 대해 다시 프롬프트되지 않도록 제안된 권한 업데이트 |
| `blockedPath`    | `string`                                     | 해당하는 경우 권한 요청을 트리거한 파일 경로               |
| `decisionReason` | `string`                                     | 이 권한 요청이 트리거된 이유를 설명합니다                 |
| `toolUseID`      | `string`                                     | 어시스턴트 메시지 내 이 특정 도구 호출의 고유 식별자          |
| `agentID`        | `string`                                     | 서브에이전트 내에서 실행 중인 경우 서브에이전트의 ID          |

### `PermissionResult`

권한 확인의 결과입니다.

```typescript theme={null}
type PermissionResult =
  | {
      behavior: "allow";
      updatedInput?: Record<string, unknown>;
      updatedPermissions?: PermissionUpdate[];
      toolUseID?: string;
    }
  | {
      behavior: "deny";
      message: string;
      interrupt?: boolean;
      toolUseID?: string;
    };
```

### `ToolConfig`

기본 제공 도구 동작의 구성입니다.

```typescript theme={null}
type ToolConfig = {
  askUserQuestion?: {
    previewFormat?: "markdown" | "html";
  };
};
```

| 필드                              | 타입                     | 설명                                                                                                                                    |
| :------------------------------ | :--------------------- | :------------------------------------------------------------------------------------------------------------------------------------ |
| `askUserQuestion.previewFormat` | `'markdown' \| 'html'` | [`AskUserQuestion`](/ko/agent-sdk/user-input#question-format) 옵션의 `preview` 필드를 옵트인하고 콘텐츠 형식을 설정합니다. 설정하지 않으면 Claude는 미리보기를 내보내지 않습니다 |

### `McpServerConfig`

MCP 서버의 구성입니다.

```typescript theme={null}
type McpServerConfig =
  | McpStdioServerConfig
  | McpSSEServerConfig
  | McpHttpServerConfig
  | McpSdkServerConfigWithInstance;
```

#### `McpStdioServerConfig`

```typescript theme={null}
type McpStdioServerConfig = {
  type?: "stdio";
  command: string;
  args?: string[];
  env?: Record<string, string>;
};
```

#### `McpSSEServerConfig`

```typescript theme={null}
type McpSSEServerConfig = {
  type: "sse";
  url: string;
  headers?: Record<string, string>;
};
```

#### `McpHttpServerConfig`

```typescript theme={null}
type McpHttpServerConfig = {
  type: "http";
  url: string;
  headers?: Record<string, string>;
};
```

#### `McpSdkServerConfigWithInstance`

```typescript theme={null}
type McpSdkServerConfigWithInstance = {
  type: "sdk";
  name: string;
  instance: McpServer;
};
```

#### `McpClaudeAIProxyServerConfig`

```typescript theme={null}
type McpClaudeAIProxyServerConfig = {
  type: "claudeai-proxy";
  url: string;
  id: string;
};
```

### `SdkPluginConfig`

SDK에서 플러그인을 로드하기 위한 구성입니다.

```typescript theme={null}
type SdkPluginConfig = {
  type: "local";
  path: string;
};
```

| 필드     | 타입        | 설명                                 |
| :----- | :-------- | :--------------------------------- |
| `type` | `'local'` | `'local'`이어야 합니다 (현재 로컬 플러그인만 지원됨) |
| `path` | `string`  | 플러그인 디렉토리의 절대 또는 상대 경로             |

**예제:**

```typescript theme={null}
plugins: [
  { type: "local", path: "./my-plugin" },
  { type: "local", path: "/absolute/path/to/plugin" }
];
```

플러그인 생성 및 사용에 대한 완전한 정보는 [플러그인](/ko/agent-sdk/plugins)을 참조하세요.

## 메시지 타입

### `SDKMessage`

쿼리에서 반환된 모든 가능한 메시지의 합집합 타입입니다.

```typescript theme={null}
type SDKMessage =
  | SDKAssistantMessage
  | SDKUserMessage
  | SDKUserMessageReplay
  | SDKResultMessage
  | SDKSystemMessage
  | SDKPartialAssistantMessage
  | SDKCompactBoundaryMessage
  | SDKStatusMessage
  | SDKLocalCommandOutputMessage
  | SDKHookStartedMessage
  | SDKHookProgressMessage
  | SDKHookResponseMessage
  | SDKPluginInstallMessage
  | SDKToolProgressMessage
  | SDKAuthStatusMessage
  | SDKTaskNotificationMessage
  | SDKTaskStartedMessage
  | SDKTaskProgressMessage
  | SDKTaskUpdatedMessage
  | SDKFilesPersistedEvent
  | SDKToolUseSummaryMessage
  | SDKRateLimitEvent
  | SDKPromptSuggestionMessage;
```

### `SDKAssistantMessage`

어시스턴트 응답 메시지입니다.

```typescript theme={null}
type SDKAssistantMessage = {
  type: "assistant";
  uuid: UUID;
  session_id: string;
  message: BetaMessage; // Anthropic SDK에서
  parent_tool_use_id: string | null;
  error?: SDKAssistantMessageError;
};
```

`message` 필드는 Anthropic SDK의 [`BetaMessage`](https://platform.claude.com/docs/ko/api/messages/create)입니다. `id`, `content`, `model`, `stop_reason` 및 `usage`와 같은 필드를 포함합니다.

`SDKAssistantMessageError`는 다음 중 하나입니다: `'authentication_failed'`, `'billing_error'`, `'rate_limit'`, `'invalid_request'`, `'server_error'`, `'max_output_tokens'` 또는 `'unknown'`.

### `SDKUserMessage`

사용자 입력 메시지입니다.

```typescript theme={null}
type SDKUserMessage = {
  type: "user";
  uuid?: UUID;
  session_id: string;
  message: MessageParam; // Anthropic SDK에서
  parent_tool_use_id: string | null;
  isSynthetic?: boolean;
  shouldQuery?: boolean;
  tool_use_result?: unknown;
};
```

`shouldQuery`를 `false`로 설정하여 어시스턴트 턴을 트리거하지 않고 메시지를 트랜스크립트에 추가합니다. 메시지는 보류되고 턴을 트리거하는 다음 사용자 메시지로 병합됩니다. 이를 사용하여 모델 호출을 소비하지 않고 대역 외에서 실행한 명령의 출력과 같은 컨텍스트를 주입합니다.

### `SDKUserMessageReplay`

필수 UUID를 포함한 재생된 사용자 메시지입니다.

```typescript theme={null}
type SDKUserMessageReplay = {
  type: "user";
  uuid: UUID;
  session_id: string;
  message: MessageParam;
  parent_tool_use_id: string | null;
  isSynthetic?: boolean;
  tool_use_result?: unknown;
  isReplay: true;
};
```

### `SDKResultMessage`

최종 결과 메시지입니다.

```typescript theme={null}
type SDKResultMessage =
  | {
      type: "result";
      subtype: "success";
      uuid: UUID;
      session_id: string;
      duration_ms: number;
      duration_api_ms: number;
      is_error: boolean;
      num_turns: number;
      result: string;
      stop_reason: string | null;
      total_cost_usd: number;
      usage: NonNullableUsage;
      modelUsage: { [modelName: string]: ModelUsage };
      permission_denials: SDKPermissionDenial[];
      structured_output?: unknown;
      deferred_tool_use?: { id: string; name: string; input: Record<string, unknown> };
    }
  | {
      type: "result";
      subtype:
        | "error_max_turns"
        | "error_during_execution"
        | "error_max_budget_usd"
        | "error_max_structured_output_retries";
      uuid: UUID;
      session_id: string;
      duration_ms: number;
      duration_api_ms: number;
      is_error: boolean;
      num_turns: number;
      stop_reason: string | null;
      total_cost_usd: number;
      usage: NonNullableUsage;
      modelUsage: { [modelName: string]: ModelUsage };
      permission_denials: SDKPermissionDenial[];
      errors: string[];
    };
```

`PreToolUse` 훅이 `permissionDecision: "defer"`를 반환할 때, 결과는 `stop_reason: "tool_deferred"`를 가지며 `deferred_tool_use`는 보류 중인 도구의 `id`, `name` 및 `input`을 전달합니다. 이 필드를 읽어 요청을 자신의 UI에 표시한 다음 동일한 `session_id`로 재개하여 계속합니다. 전체 왕복은 [나중을 위해 도구 호출 연기](/ko/hooks#defer-a-tool-call-for-later)를 참조하십시오.

### `SDKSystemMessage`

시스템 초기화 메시지입니다.

```typescript theme={null}
type SDKSystemMessage = {
  type: "system";
  subtype: "init";
  uuid: UUID;
  session_id: string;
  agents?: string[];
  apiKeySource: ApiKeySource;
  betas?: string[];
  claude_code_version: string;
  cwd: string;
  tools: string[];
  mcp_servers: {
    name: string;
    status: string;
  }[];
  model: string;
  permissionMode: PermissionMode;
  slash_commands: string[];
  output_style: string;
  skills: string[];
  plugins: { name: string; path: string }[];
};
```

### `SDKPartialAssistantMessage`

스트리밍 부분 메시지 (`includePartialMessages`가 true일 때만).

```typescript theme={null}
type SDKPartialAssistantMessage = {
  type: "stream_event";
  event: BetaRawMessageStreamEvent; // Anthropic SDK에서
  parent_tool_use_id: string | null;
  uuid: UUID;
  session_id: string;
};
```

### `SDKCompactBoundaryMessage`

대화 압축 경계를 나타내는 메시지입니다.

```typescript theme={null}
type SDKCompactBoundaryMessage = {
  type: "system";
  subtype: "compact_boundary";
  uuid: UUID;
  session_id: string;
  compact_metadata: {
    trigger: "manual" | "auto";
    pre_tokens: number;
  };
};
```

### `SDKPluginInstallMessage`

플러그인 설치 진행 이벤트입니다. [`CLAUDE_CODE_SYNC_PLUGIN_INSTALL`](/ko/env-vars)이 설정되면 내보내지므로 Agent SDK 애플리케이션이 첫 번째 턴 전에 마켓플레이스 플러그인 설치를 추적할 수 있습니다. `started` 및 `completed` 상태는 전체 설치를 괄호로 묶습니다. `installed` 및 `failed` 상태는 개별 마켓플레이스를 보고하고 `name`을 포함합니다.

```typescript theme={null}
type SDKPluginInstallMessage = {
  type: "system";
  subtype: "plugin_install";
  status: "started" | "installed" | "failed" | "completed";
  name?: string;
  error?: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKPermissionDenial`

거부된 도구 사용에 대한 정보입니다.

```typescript theme={null}
type SDKPermissionDenial = {
  tool_name: string;
  tool_use_id: string;
  tool_input: Record<string, unknown>;
};
```

## 훅 타입

훅 사용에 대한 포괄적인 가이드, 예제 및 일반적인 패턴은 [훅 가이드](/ko/agent-sdk/hooks)를 참조하세요.

### `HookEvent`

사용 가능한 훅 이벤트입니다.

```typescript theme={null}
type HookEvent =
  | "PreToolUse"
  | "PostToolUse"
  | "PostToolUseFailure"
  | "PostToolBatch"
  | "Notification"
  | "UserPromptSubmit"
  | "SessionStart"
  | "SessionEnd"
  | "Stop"
  | "SubagentStart"
  | "SubagentStop"
  | "PreCompact"
  | "PermissionRequest"
  | "Setup"
  | "TeammateIdle"
  | "TaskCompleted"
  | "ConfigChange"
  | "WorktreeCreate"
  | "WorktreeRemove";
```

### `HookCallback`

훅 콜백 함수 타입입니다.

```typescript theme={null}
type HookCallback = (
  input: HookInput, // 모든 훅 입력 타입의 합집합
  toolUseID: string | undefined,
  options: { signal: AbortSignal }
) => Promise<HookJSONOutput>;
```

### `HookCallbackMatcher`

선택적 매처를 포함한 훅 구성입니다.

```typescript theme={null}
interface HookCallbackMatcher {
  matcher?: string;
  hooks: HookCallback[];
  timeout?: number; // 이 매처의 모든 훅에 대한 타임아웃 (초)
}
```

### `HookInput`

모든 훅 입력 타입의 합집합 타입입니다.

```typescript theme={null}
type HookInput =
  | PreToolUseHookInput
  | PostToolUseHookInput
  | PostToolUseFailureHookInput
  | PostToolBatchHookInput
  | NotificationHookInput
  | UserPromptSubmitHookInput
  | SessionStartHookInput
  | SessionEndHookInput
  | StopHookInput
  | SubagentStartHookInput
  | SubagentStopHookInput
  | PreCompactHookInput
  | PermissionRequestHookInput
  | SetupHookInput
  | TeammateIdleHookInput
  | TaskCompletedHookInput
  | ConfigChangeHookInput
  | WorktreeCreateHookInput
  | WorktreeRemoveHookInput;
```

### `BaseHookInput`

모든 훅 입력 타입이 확장하는 기본 인터페이스입니다.

```typescript theme={null}
type BaseHookInput = {
  session_id: string;
  transcript_path: string;
  cwd: string;
  permission_mode?: string;
  agent_id?: string;
  agent_type?: string;
};
```

#### `PreToolUseHookInput`

```typescript theme={null}
type PreToolUseHookInput = BaseHookInput & {
  hook_event_name: "PreToolUse";
  tool_name: string;
  tool_input: unknown;
  tool_use_id: string;
};
```

#### `PostToolUseHookInput`

```typescript theme={null}
type PostToolUseHookInput = BaseHookInput & {
  hook_event_name: "PostToolUse";
  tool_name: string;
  tool_input: unknown;
  tool_response: unknown;
  tool_use_id: string;
  duration_ms?: number;
};
```

#### `PostToolUseFailureHookInput`

```typescript theme={null}
type PostToolUseFailureHookInput = BaseHookInput & {
  hook_event_name: "PostToolUseFailure";
  tool_name: string;
  tool_input: unknown;
  tool_use_id: string;
  error: string;
  is_interrupt?: boolean;
  duration_ms?: number;
};
```

#### `PostToolBatchHookInput`

배치의 모든 도구 호출이 해결된 후, 다음 모델 요청 전에 한 번 실행됩니다. `tool_response`는 모델이 보는 직렬화된 `tool_result` 콘텐츠를 전달합니다. 형태는 `PostToolUseHookInput`의 구조화된 `Output` 객체와 다릅니다.

```typescript theme={null}
type PostToolBatchHookInput = BaseHookInput & {
  hook_event_name: "PostToolBatch";
  tool_calls: PostToolBatchToolCall[];
};

type PostToolBatchToolCall = {
  tool_name: string;
  tool_input: unknown;
  tool_use_id: string;
  tool_response?: unknown;
};
```

#### `NotificationHookInput`

```typescript theme={null}
type NotificationHookInput = BaseHookInput & {
  hook_event_name: "Notification";
  message: string;
  title?: string;
  notification_type: string;
};
```

#### `UserPromptSubmitHookInput`

```typescript theme={null}
type UserPromptSubmitHookInput = BaseHookInput & {
  hook_event_name: "UserPromptSubmit";
  prompt: string;
};
```

#### `SessionStartHookInput`

```typescript theme={null}
type SessionStartHookInput = BaseHookInput & {
  hook_event_name: "SessionStart";
  source: "startup" | "resume" | "clear" | "compact";
  agent_type?: string;
  model?: string;
};
```

#### `SessionEndHookInput`

```typescript theme={null}
type SessionEndHookInput = BaseHookInput & {
  hook_event_name: "SessionEnd";
  reason: ExitReason; // EXIT_REASONS 배열의 문자열
};
```

#### `StopHookInput`

```typescript theme={null}
type StopHookInput = BaseHookInput & {
  hook_event_name: "Stop";
  stop_hook_active: boolean;
  last_assistant_message?: string;
};
```

#### `SubagentStartHookInput`

```typescript theme={null}
type SubagentStartHookInput = BaseHookInput & {
  hook_event_name: "SubagentStart";
  agent_id: string;
  agent_type: string;
};
```

#### `SubagentStopHookInput`

```typescript theme={null}
type SubagentStopHookInput = BaseHookInput & {
  hook_event_name: "SubagentStop";
  stop_hook_active: boolean;
  agent_id: string;
  agent_transcript_path: string;
  agent_type: string;
  last_assistant_message?: string;
};
```

#### `PreCompactHookInput`

```typescript theme={null}
type PreCompactHookInput = BaseHookInput & {
  hook_event_name: "PreCompact";
  trigger: "manual" | "auto";
  custom_instructions: string | null;
};
```

#### `PermissionRequestHookInput`

```typescript theme={null}
type PermissionRequestHookInput = BaseHookInput & {
  hook_event_name: "PermissionRequest";
  tool_name: string;
  tool_input: unknown;
  permission_suggestions?: PermissionUpdate[];
};
```

#### `SetupHookInput`

```typescript theme={null}
type SetupHookInput = BaseHookInput & {
  hook_event_name: "Setup";
  trigger: "init" | "maintenance";
};
```

#### `TeammateIdleHookInput`

```typescript theme={null}
type TeammateIdleHookInput = BaseHookInput & {
  hook_event_name: "TeammateIdle";
  teammate_name: string;
  team_name: string;
};
```

#### `TaskCompletedHookInput`

```typescript theme={null}
type TaskCompletedHookInput = BaseHookInput & {
  hook_event_name: "TaskCompleted";
  task_id: string;
  task_subject: string;
  task_description?: string;
  teammate_name?: string;
  team_name?: string;
};
```

#### `ConfigChangeHookInput`

```typescript theme={null}
type ConfigChangeHookInput = BaseHookInput & {
  hook_event_name: "ConfigChange";
  source:
    | "user_settings"
    | "project_settings"
    | "local_settings"
    | "policy_settings"
    | "skills";
  file_path?: string;
};
```

#### `WorktreeCreateHookInput`

```typescript theme={null}
type WorktreeCreateHookInput = BaseHookInput & {
  hook_event_name: "WorktreeCreate";
  name: string;
};
```

#### `WorktreeRemoveHookInput`

```typescript theme={null}
type WorktreeRemoveHookInput = BaseHookInput & {
  hook_event_name: "WorktreeRemove";
  worktree_path: string;
};
```

### `HookJSONOutput`

훅 반환값입니다.

```typescript theme={null}
type HookJSONOutput = AsyncHookJSONOutput | SyncHookJSONOutput;
```

#### `AsyncHookJSONOutput`

```typescript theme={null}
type AsyncHookJSONOutput = {
  async: true;
  asyncTimeout?: number;
};
```

#### `SyncHookJSONOutput`

```typescript theme={null}
type SyncHookJSONOutput = {
  continue?: boolean;
  suppressOutput?: boolean;
  stopReason?: string;
  decision?: "approve" | "block";
  systemMessage?: string;
  reason?: string;
  hookSpecificOutput?:
    | {
        hookEventName: "PreToolUse";
        permissionDecision?: "allow" | "deny" | "ask" | "defer";
        permissionDecisionReason?: string;
        updatedInput?: Record<string, unknown>;
        additionalContext?: string;
      }
    | {
        hookEventName: "UserPromptSubmit";
        additionalContext?: string;
      }
    | {
        hookEventName: "SessionStart";
        additionalContext?: string;
      }
    | {
        hookEventName: "Setup";
        additionalContext?: string;
      }
    | {
        hookEventName: "SubagentStart";
        additionalContext?: string;
      }
    | {
        hookEventName: "PostToolUse";
        additionalContext?: string;
        updatedMCPToolOutput?: unknown;
      }
    | {
        hookEventName: "PostToolUseFailure";
        additionalContext?: string;
      }
    | {
        hookEventName: "PostToolBatch";
        additionalContext?: string;
      }
    | {
        hookEventName: "Notification";
        additionalContext?: string;
      }
    | {
        hookEventName: "PermissionRequest";
        decision:
          | {
              behavior: "allow";
              updatedInput?: Record<string, unknown>;
              updatedPermissions?: PermissionUpdate[];
            }
          | {
              behavior: "deny";
              message?: string;
              interrupt?: boolean;
            };
      };
};
```

## 도구 입력 타입

모든 기본 제공 Claude Code 도구의 입력 스키마 문서입니다. 이 타입은 `@anthropic-ai/claude-agent-sdk`에서 내보내지며 타입 안전 도구 상호작용에 사용할 수 있습니다.

### `ToolInputSchemas`

모든 도구 입력 타입의 합집합으로, `@anthropic-ai/claude-agent-sdk`에서 내보냅니다.

```typescript theme={null}
type ToolInputSchemas =
  | AgentInput
  | AskUserQuestionInput
  | BashInput
  | TaskOutputInput
  | EnterWorktreeInput
  | ExitPlanModeInput
  | FileEditInput
  | FileReadInput
  | FileWriteInput
  | GlobInput
  | GrepInput
  | ListMcpResourcesInput
  | McpInput
  | MonitorInput
  | NotebookEditInput
  | ReadMcpResourceInput
  | SubscribeMcpResourceInput
  | SubscribePollingInput
  | TaskStopInput
  | TodoWriteInput
  | UnsubscribeMcpResourceInput
  | UnsubscribePollingInput
  | WebFetchInput
  | WebSearchInput;
```

### Agent

**도구 이름:** `Agent` (이전 `Task`, 여전히 별칭으로 수락됨)

```typescript theme={null}
type AgentInput = {
  description: string;
  prompt: string;
  subagent_type: string;
  model?: "sonnet" | "opus" | "haiku";
  resume?: string;
  run_in_background?: boolean;
  max_turns?: number;
  name?: string;
  team_name?: string;
  mode?: "acceptEdits" | "bypassPermissions" | "default" | "dontAsk" | "plan";
  isolation?: "worktree";
};
```

복잡한 다단계 작업을 자율적으로 처리할 새로운 에이전트를 시작합니다.

### AskUserQuestion

**도구 이름:** `AskUserQuestion`

```typescript theme={null}
type AskUserQuestionInput = {
  questions: Array<{
    question: string;
    header: string;
    options: Array<{ label: string; description: string; preview?: string }>;
    multiSelect: boolean;
  }>;
};
```

실행 중에 사용자에게 명확히 하는 질문을 합니다. 사용 세부 정보는 [승인 및 사용자 입력 처리](/ko/agent-sdk/user-input#handle-clarifying-questions)를 참조하세요.

### Bash

**도구 이름:** `Bash`

```typescript theme={null}
type BashInput = {
  command: string;
  timeout?: number;
  description?: string;
  run_in_background?: boolean;
  dangerouslyDisableSandbox?: boolean;
};
```

선택적 타임아웃 및 백그라운드 실행을 포함한 지속적인 셸 세션에서 bash 명령을 실행합니다.

### Monitor

**도구 이름:** `Monitor`

```typescript theme={null}
type MonitorInput = {
  command: string;
  description: string;
  timeout_ms?: number;
  persistent?: boolean;
};
```

백그라운드 스크립트를 실행하고 각 stdout 라인을 Claude에 이벤트로 전달하므로 폴링 없이 반응할 수 있습니다. 로그 테일과 같은 세션 길이 감시의 경우 `persistent: true`를 설정합니다. Monitor는 Bash와 동일한 권한 규칙을 따릅니다. [Monitor 도구 참조](/ko/tools-reference#monitor-tool)에서 동작 및 공급자 가용성을 참조하세요.

### TaskOutput

**도구 이름:** `TaskOutput`

```typescript theme={null}
type TaskOutputInput = {
  task_id: string;
  block: boolean;
  timeout: number;
};
```

실행 중이거나 완료된 백그라운드 작업에서 출력을 검색합니다.

### Edit

**도구 이름:** `Edit`

```typescript theme={null}
type FileEditInput = {
  file_path: string;
  old_string: string;
  new_string: string;
  replace_all?: boolean;
};
```

파일에서 정확한 문자열 교체를 수행합니다.

### Read

**도구 이름:** `Read`

```typescript theme={null}
type FileReadInput = {
  file_path: string;
  offset?: number;
  limit?: number;
  pages?: string;
};
```

텍스트, 이미지, PDF 및 Jupyter 노트북을 포함한 로컬 파일 시스템에서 파일을 읽습니다. PDF 페이지 범위의 경우 `pages`를 사용합니다 (예: `"1-5"`).

### Write

**도구 이름:** `Write`

```typescript theme={null}
type FileWriteInput = {
  file_path: string;
  content: string;
};
```

로컬 파일 시스템에 파일을 작성하고 존재하면 덮어씁니다.

### Glob

**도구 이름:** `Glob`

```typescript theme={null}
type GlobInput = {
  pattern: string;
  path?: string;
};
```

모든 코드베이스 크기에서 작동하는 빠른 파일 패턴 매칭입니다.

### Grep

**도구 이름:** `Grep`

```typescript theme={null}
type GrepInput = {
  pattern: string;
  path?: string;
  glob?: string;
  type?: string;
  output_mode?: "content" | "files_with_matches" | "count";
  "-i"?: boolean;
  "-n"?: boolean;
  "-B"?: number;
  "-A"?: number;
  "-C"?: number;
  context?: number;
  head_limit?: number;
  offset?: number;
  multiline?: boolean;
};
```

정규식 지원을 포함한 ripgrep 기반의 강력한 검색 도구입니다.

### TaskStop

**도구 이름:** `TaskStop`

```typescript theme={null}
type TaskStopInput = {
  task_id?: string;
  shell_id?: string; // 더 이상 사용되지 않음: task_id 사용
};
```

ID로 실행 중인 백그라운드 작업 또는 셸을 중지합니다.

### NotebookEdit

**도구 이름:** `NotebookEdit`

```typescript theme={null}
type NotebookEditInput = {
  notebook_path: string;
  cell_id?: string;
  new_source: string;
  cell_type?: "code" | "markdown";
  edit_mode?: "replace" | "insert" | "delete";
};
```

Jupyter 노트북 파일의 셀을 편집합니다.

### WebFetch

**도구 이름:** `WebFetch`

```typescript theme={null}
type WebFetchInput = {
  url: string;
  prompt: string;
};
```

URL에서 콘텐츠를 가져오고 AI 모델로 처리합니다.

### WebSearch

**도구 이름:** `WebSearch`

```typescript theme={null}
type WebSearchInput = {
  query: string;
  allowed_domains?: string[];
  blocked_domains?: string[];
};
```

웹을 검색하고 형식화된 결과를 반환합니다.

### TodoWrite

**도구 이름:** `TodoWrite`

```typescript theme={null}
type TodoWriteInput = {
  todos: Array<{
    content: string;
    status: "pending" | "in_progress" | "completed";
    activeForm: string;
  }>;
};
```

진행 상황을 추적하기 위한 구조화된 작업 목록을 만들고 관리합니다.

### ExitPlanMode

**도구 이름:** `ExitPlanMode`

```typescript theme={null}
type ExitPlanModeInput = {
  allowedPrompts?: Array<{
    tool: "Bash";
    prompt: string;
  }>;
};
```

계획 모드를 종료합니다. 선택적으로 계획을 구현하는 데 필요한 프롬프트 기반 권한을 지정합니다.

### ListMcpResources

**도구 이름:** `ListMcpResources`

```typescript theme={null}
type ListMcpResourcesInput = {
  server?: string;
};
```

연결된 서버에서 사용 가능한 MCP 리소스를 나열합니다.

### ReadMcpResource

**도구 이름:** `ReadMcpResource`

```typescript theme={null}
type ReadMcpResourceInput = {
  server: string;
  uri: string;
};
```

서버에서 특정 MCP 리소스를 읽습니다.

### EnterWorktree

**도구 이름:** `EnterWorktree`

```typescript theme={null}
type EnterWorktreeInput = {
  name?: string;
  path?: string;
};
```

격리된 작업을 위한 임시 git worktree를 만들고 입력합니다. 새 worktree를 만드는 대신 현재 저장소의 기존 worktree로 전환하려면 `path`를 전달합니다. `name` 및 `path`는 상호 배타적입니다.

## 도구 출력 타입

모든 기본 제공 Claude Code 도구의 출력 스키마 문서입니다. 이 타입은 `@anthropic-ai/claude-agent-sdk`에서 내보내지며 각 도구에서 반환된 실제 응답 데이터를 나타냅니다.

### `ToolOutputSchemas`

모든 도구 출력 타입의 합집합입니다.

```typescript theme={null}
type ToolOutputSchemas =
  | AgentOutput
  | AskUserQuestionOutput
  | BashOutput
  | EnterWorktreeOutput
  | ExitPlanModeOutput
  | FileEditOutput
  | FileReadOutput
  | FileWriteOutput
  | GlobOutput
  | GrepOutput
  | ListMcpResourcesOutput
  | MonitorOutput
  | NotebookEditOutput
  | ReadMcpResourceOutput
  | TaskStopOutput
  | TodoWriteOutput
  | WebFetchOutput
  | WebSearchOutput;
```

### Agent

**도구 이름:** `Agent` (이전 `Task`, 여전히 별칭으로 수락됨)

```typescript theme={null}
type AgentOutput =
  | {
      status: "completed";
      agentId: string;
      content: Array<{ type: "text"; text: string }>;
      totalToolUseCount: number;
      totalDurationMs: number;
      totalTokens: number;
      usage: {
        input_tokens: number;
        output_tokens: number;
        cache_creation_input_tokens: number | null;
        cache_read_input_tokens: number | null;
        server_tool_use: {
          web_search_requests: number;
          web_fetch_requests: number;
        } | null;
        service_tier: ("standard" | "priority" | "batch") | null;
        cache_creation: {
          ephemeral_1h_input_tokens: number;
          ephemeral_5m_input_tokens: number;
        } | null;
      };
      prompt: string;
    }
  | {
      status: "async_launched";
      agentId: string;
      description: string;
      prompt: string;
      outputFile: string;
      canReadOutputFile?: boolean;
    }
  | {
      status: "sub_agent_entered";
      description: string;
      message: string;
    };
```

서브에이전트의 결과를 반환합니다. `status` 필드에서 구분됩니다: 완료된 작업의 경우 `"completed"`, 백그라운드 작업의 경우 `"async_launched"`, 대화형 서브에이전트의 경우 `"sub_agent_entered"`.

### AskUserQuestion

**도구 이름:** `AskUserQuestion`

```typescript theme={null}
type AskUserQuestionOutput = {
  questions: Array<{
    question: string;
    header: string;
    options: Array<{ label: string; description: string; preview?: string }>;
    multiSelect: boolean;
  }>;
  answers: Record<string, string>;
};
```

질문과 사용자의 답변을 반환합니다.

### Bash

**도구 이름:** `Bash`

```typescript theme={null}
type BashOutput = {
  stdout: string;
  stderr: string;
  rawOutputPath?: string;
  interrupted: boolean;
  isImage?: boolean;
  backgroundTaskId?: string;
  backgroundedByUser?: boolean;
  dangerouslyDisableSandbox?: boolean;
  returnCodeInterpretation?: string;
  structuredContent?: unknown[];
  persistedOutputPath?: string;
  persistedOutputSize?: number;
};
```

stdout/stderr가 분할된 명령 출력을 반환합니다. 백그라운드 명령은 `backgroundTaskId`를 포함합니다.

### Monitor

**도구 이름:** `Monitor`

```typescript theme={null}
type MonitorOutput = {
  taskId: string;
  timeoutMs: number;
  persistent?: boolean;
};
```

실행 중인 모니터의 백그라운드 작업 ID를 반환합니다. 이 ID를 `TaskStop`과 함께 사용하여 감시를 조기에 취소합니다.

### Edit

**도구 이름:** `Edit`

```typescript theme={null}
type FileEditOutput = {
  filePath: string;
  oldString: string;
  newString: string;
  originalFile: string;
  structuredPatch: Array<{
    oldStart: number;
    oldLines: number;
    newStart: number;
    newLines: number;
    lines: string[];
  }>;
  userModified: boolean;
  replaceAll: boolean;
  gitDiff?: {
    filename: string;
    status: "modified" | "added";
    additions: number;
    deletions: number;
    changes: number;
    patch: string;
  };
};
```

편집 작업의 구조화된 diff를 반환합니다.

### Read

**도구 이름:** `Read`

```typescript theme={null}
type FileReadOutput =
  | {
      type: "text";
      file: {
        filePath: string;
        content: string;
        numLines: number;
        startLine: number;
        totalLines: number;
      };
    }
  | {
      type: "image";
      file: {
        base64: string;
        type: "image/jpeg" | "image/png" | "image/gif" | "image/webp";
        originalSize: number;
        dimensions?: {
          originalWidth?: number;
          originalHeight?: number;
          displayWidth?: number;
          displayHeight?: number;
        };
      };
    }
  | {
      type: "notebook";
      file: {
        filePath: string;
        cells: unknown[];
      };
    }
  | {
      type: "pdf";
      file: {
        filePath: string;
        base64: string;
        originalSize: number;
      };
    }
  | {
      type: "parts";
      file: {
        filePath: string;
        originalSize: number;
        count: number;
        outputDir: string;
      };
    };
```

파일 타입에 적합한 형식의 파일 콘텐츠를 반환합니다. `type` 필드에서 구분됩니다.

### Write

**도구 이름:** `Write`

```typescript theme={null}
type FileWriteOutput = {
  type: "create" | "update";
  filePath: string;
  content: string;
  structuredPatch: Array<{
    oldStart: number;
    oldLines: number;
    newStart: number;
    newLines: number;
    lines: string[];
  }>;
  originalFile: string | null;
  gitDiff?: {
    filename: string;
    status: "modified" | "added";
    additions: number;
    deletions: number;
    changes: number;
    patch: string;
  };
};
```

구조화된 diff 정보를 포함한 쓰기 결과를 반환합니다.

### Glob

**도구 이름:** `Glob`

```typescript theme={null}
type GlobOutput = {
  durationMs: number;
  numFiles: number;
  filenames: string[];
  truncated: boolean;
};
```

glob 패턴과 일치하는 파일 경로를 수정 시간별로 정렬하여 반환합니다.

### Grep

**도구 이름:** `Grep`

```typescript theme={null}
type GrepOutput = {
  mode?: "content" | "files_with_matches" | "count";
  numFiles: number;
  filenames: string[];
  content?: string;
  numLines?: number;
  numMatches?: number;
  appliedLimit?: number;
  appliedOffset?: number;
};
```

검색 결과를 반환합니다. 형태는 `mode`에 따라 다릅니다: 파일 목록, 일치 항목이 있는 콘텐츠 또는 일치 항목 수.

### TaskStop

**도구 이름:** `TaskStop`

```typescript theme={null}
type TaskStopOutput = {
  message: string;
  task_id: string;
  task_type: string;
  command?: string;
};
```

백그라운드 작업 중지 후 확인을 반환합니다.

### NotebookEdit

**도구 이름:** `NotebookEdit`

```typescript theme={null}
type NotebookEditOutput = {
  new_source: string;
  cell_id?: string;
  cell_type: "code" | "markdown";
  language: string;
  edit_mode: string;
  error?: string;
  notebook_path: string;
  original_file: string;
  updated_file: string;
};
```

원본 및 업데이트된 파일 콘텐츠를 포함한 노트북 편집 결과를 반환합니다.

### WebFetch

**도구 이름:** `WebFetch`

```typescript theme={null}
type WebFetchOutput = {
  bytes: number;
  code: number;
  codeText: string;
  result: string;
  durationMs: number;
  url: string;
};
```

HTTP 상태 및 메타데이터를 포함한 가져온 콘텐츠를 반환합니다.

### WebSearch

**도구 이름:** `WebSearch`

```typescript theme={null}
type WebSearchOutput = {
  query: string;
  results: Array<
    | {
        tool_use_id: string;
        content: Array<{ title: string; url: string }>;
      }
    | string
  >;
  durationSeconds: number;
};
```

웹에서 검색 결과를 반환합니다.

### TodoWrite

**도구 이름:** `TodoWrite`

```typescript theme={null}
type TodoWriteOutput = {
  oldTodos: Array<{
    content: string;
    status: "pending" | "in_progress" | "completed";
    activeForm: string;
  }>;
  newTodos: Array<{
    content: string;
    status: "pending" | "in_progress" | "completed";
    activeForm: string;
  }>;
};
```

이전 및 업데이트된 작업 목록을 반환합니다.

### ExitPlanMode

**도구 이름:** `ExitPlanMode`

```typescript theme={null}
type ExitPlanModeOutput = {
  plan: string | null;
  isAgent: boolean;
  filePath?: string;
  hasTaskTool?: boolean;
  awaitingLeaderApproval?: boolean;
  requestId?: string;
};
```

계획 모드 종료 후 계획 상태를 반환합니다.

### ListMcpResources

**도구 이름:** `ListMcpResources`

```typescript theme={null}
type ListMcpResourcesOutput = Array<{
  uri: string;
  name: string;
  mimeType?: string;
  description?: string;
  server: string;
}>;
```

사용 가능한 MCP 리소스의 배열을 반환합니다.

### ReadMcpResource

**도구 이름:** `ReadMcpResource`

```typescript theme={null}
type ReadMcpResourceOutput = {
  contents: Array<{
    uri: string;
    mimeType?: string;
    text?: string;
  }>;
};
```

요청된 MCP 리소스의 콘텐츠를 반환합니다.

### EnterWorktree

**도구 이름:** `EnterWorktree`

```typescript theme={null}
type EnterWorktreeOutput = {
  worktreePath: string;
  worktreeBranch?: string;
  message: string;
};
```

git worktree에 대한 정보를 반환합니다.

## 권한 타입

### `PermissionUpdate`

권한 업데이트 작업입니다.

```typescript theme={null}
type PermissionUpdate =
  | {
      type: "addRules";
      rules: PermissionRuleValue[];
      behavior: PermissionBehavior;
      destination: PermissionUpdateDestination;
    }
  | {
      type: "replaceRules";
      rules: PermissionRuleValue[];
      behavior: PermissionBehavior;
      destination: PermissionUpdateDestination;
    }
  | {
      type: "removeRules";
      rules: PermissionRuleValue[];
      behavior: PermissionBehavior;
      destination: PermissionUpdateDestination;
    }
  | {
      type: "setMode";
      mode: PermissionMode;
      destination: PermissionUpdateDestination;
    }
  | {
      type: "addDirectories";
      directories: string[];
      destination: PermissionUpdateDestination;
    }
  | {
      type: "removeDirectories";
      directories: string[];
      destination: PermissionUpdateDestination;
    };
```

### `PermissionBehavior`

```typescript theme={null}
type PermissionBehavior = "allow" | "deny" | "ask";
```

### `PermissionUpdateDestination`

```typescript theme={null}
type PermissionUpdateDestination =
  | "userSettings" // 전역 사용자 설정
  | "projectSettings" // 디렉토리별 프로젝트 설정
  | "localSettings" // Gitignored 로컬 설정
  | "session" // 현재 세션만
  | "cliArg"; // CLI 인수
```

### `PermissionRuleValue`

```typescript theme={null}
type PermissionRuleValue = {
  toolName: string;
  ruleContent?: string;
};
```

## 기타 타입

### `ApiKeySource`

```typescript theme={null}
type ApiKeySource = "user" | "project" | "org" | "temporary" | "oauth";
```

### `SdkBeta`

`betas` 옵션을 통해 활성화할 수 있는 사용 가능한 베타 기능입니다. [베타 헤더](https://platform.claude.com/docs/ko/api/beta-headers)를 참조하세요.

```typescript theme={null}
type SdkBeta = "context-1m-2025-08-07";
```

<Warning>
  `context-1m-2025-08-07` 베타는 2026년 4월 30일부터 폐기되었습니다. Claude Sonnet 4.5 또는 Sonnet 4와 함께 이 값을 전달하면 효과가 없으며, 표준 200k 토큰 컨텍스트 윈도우를 초과하는 요청은 오류를 반환합니다. 1M 토큰 컨텍스트 윈도우를 사용하려면 [Claude Sonnet 4.6, Claude Opus 4.6 또는 Claude Opus 4.7](https://platform.claude.com/docs/ko/about-claude/models/overview)로 마이그레이션하세요. 이들은 베타 헤더 없이 표준 가격으로 1M 컨텍스트를 포함합니다.
</Warning>

### `SlashCommand`

사용 가능한 슬래시 명령에 대한 정보입니다.

```typescript theme={null}
type SlashCommand = {
  name: string;
  description: string;
  argumentHint: string;
  aliases?: string[];
};
```

### `ModelInfo`

사용 가능한 모델에 대한 정보입니다.

```typescript theme={null}
type ModelInfo = {
  value: string;
  displayName: string;
  description: string;
  supportsEffort?: boolean;
  supportedEffortLevels?: ("low" | "medium" | "high" | "xhigh" | "max")[];
  supportsAdaptiveThinking?: boolean;
  supportsFastMode?: boolean;
};
```

### `AgentInfo`

Agent 도구를 통해 호출할 수 있는 사용 가능한 서브에이전트에 대한 정보입니다.

```typescript theme={null}
type AgentInfo = {
  name: string;
  description: string;
  model?: string;
};
```

| 필드            | 타입                    | 설명                                                |
| :------------ | :-------------------- | :------------------------------------------------ |
| `name`        | `string`              | 에이전트 타입 식별자 (예: `"Explore"`, `"general-purpose"`) |
| `description` | `string`              | 이 에이전트를 사용할 시기에 대한 설명                             |
| `model`       | `string \| undefined` | 이 에이전트가 사용하는 모델 별칭입니다. 생략하면 부모의 모델을 상속합니다         |

### `McpServerStatus`

연결된 MCP 서버의 상태입니다.

```typescript theme={null}
type McpServerStatus = {
  name: string;
  status: "connected" | "failed" | "needs-auth" | "pending" | "disabled";
  serverInfo?: {
    name: string;
    version: string;
  };
  error?: string;
  config?: McpServerStatusConfig;
  scope?: string;
  tools?: {
    name: string;
    description?: string;
    annotations?: {
      readOnly?: boolean;
      destructive?: boolean;
      openWorld?: boolean;
    };
  }[];
};
```

### `McpServerStatusConfig`

`mcpServerStatus()`에서 보고한 MCP 서버의 구성입니다. 이는 모든 MCP 서버 전송 타입의 합집합입니다.

```typescript theme={null}
type McpServerStatusConfig =
  | McpStdioServerConfig
  | McpSSEServerConfig
  | McpHttpServerConfig
  | McpSdkServerConfig
  | McpClaudeAIProxyServerConfig;
```

각 전송 타입의 세부 정보는 [`McpServerConfig`](#mcp-server-config)를 참조하세요.

### `AccountInfo`

인증된 사용자의 계정 정보입니다.

```typescript theme={null}
type AccountInfo = {
  email?: string;
  organization?: string;
  subscriptionType?: string;
  tokenSource?: string;
  apiKeySource?: string;
};
```

### `ModelUsage`

결과 메시지에서 반환된 모델별 사용 통계입니다. `costUSD` 값은 클라이언트 측 추정입니다. [비용 및 사용량 추적](/ko/agent-sdk/cost-tracking)에서 청구 주의 사항을 참조하세요.

```typescript theme={null}
type ModelUsage = {
  inputTokens: number;
  outputTokens: number;
  cacheReadInputTokens: number;
  cacheCreationInputTokens: number;
  webSearchRequests: number;
  costUSD: number;
  contextWindow: number;
  maxOutputTokens: number;
};
```

### `ConfigScope`

```typescript theme={null}
type ConfigScope = "local" | "user" | "project";
```

### `NonNullableUsage`

모든 nullable 필드가 non-nullable로 만들어진 [`Usage`](#usage)의 버전입니다.

```typescript theme={null}
type NonNullableUsage = {
  [K in keyof Usage]: NonNullable<Usage[K]>;
};
```

### `Usage`

토큰 사용 통계 (`@anthropic-ai/sdk`에서).

```typescript theme={null}
type Usage = {
  input_tokens: number | null;
  output_tokens: number | null;
  cache_creation_input_tokens?: number | null;
  cache_read_input_tokens?: number | null;
};
```

### `CallToolResult`

MCP 도구 결과 타입 (`@modelcontextprotocol/sdk/types.js`에서).

```typescript theme={null}
type CallToolResult = {
  content: Array<{
    type: "text" | "image" | "resource";
    // 추가 필드는 타입에 따라 다릅니다
  }>;
  isError?: boolean;
};
```

### `ThinkingConfig`

Claude의 사고/추론 동작을 제어합니다. 더 이상 사용되지 않는 `maxThinkingTokens`보다 우선합니다.

```typescript theme={null}
type ThinkingConfig =
  | { type: "adaptive" } // 모델이 언제 그리고 얼마나 추론할지 결정합니다 (Opus 4.6+)
  | { type: "enabled"; budgetTokens?: number } // 고정 사고 토큰 예산
  | { type: "disabled" }; // 확장된 사고 없음
```

### `SpawnedProcess`

사용자 정의 프로세스 생성을 위한 인터페이스 (`spawnClaudeCodeProcess` 옵션과 함께 사용). `ChildProcess`는 이미 이 인터페이스를 만족합니다.

```typescript theme={null}
interface SpawnedProcess {
  stdin: Writable;
  stdout: Readable;
  readonly killed: boolean;
  readonly exitCode: number | null;
  kill(signal: NodeJS.Signals): boolean;
  on(
    event: "exit",
    listener: (code: number | null, signal: NodeJS.Signals | null) => void
  ): void;
  on(event: "error", listener: (error: Error) => void): void;
  once(
    event: "exit",
    listener: (code: number | null, signal: NodeJS.Signals | null) => void
  ): void;
  once(event: "error", listener: (error: Error) => void): void;
  off(
    event: "exit",
    listener: (code: number | null, signal: NodeJS.Signals | null) => void
  ): void;
  off(event: "error", listener: (error: Error) => void): void;
}
```

### `SpawnOptions`

사용자 정의 생성 함수에 전달된 옵션입니다.

```typescript theme={null}
interface SpawnOptions {
  command: string;
  args: string[];
  cwd?: string;
  env: Record<string, string | undefined>;
  signal: AbortSignal;
}
```

### `McpSetServersResult`

`setMcpServers()` 작업의 결과입니다.

```typescript theme={null}
type McpSetServersResult = {
  added: string[];
  removed: string[];
  errors: Record<string, string>;
};
```

### `RewindFilesResult`

`rewindFiles()` 작업의 결과입니다.

```typescript theme={null}
type RewindFilesResult = {
  canRewind: boolean;
  error?: string;
  filesChanged?: string[];
  insertions?: number;
  deletions?: number;
};
```

### `SDKStatusMessage`

상태 업데이트 메시지 (예: 압축).

```typescript theme={null}
type SDKStatusMessage = {
  type: "system";
  subtype: "status";
  status: "compacting" | null;
  permissionMode?: PermissionMode;
  uuid: UUID;
  session_id: string;
};
```

### `SDKTaskNotificationMessage`

백그라운드 작업이 완료, 실패 또는 중지될 때의 알림입니다. 백그라운드 작업에는 `run_in_background` Bash 명령, [Monitor](#monitor) 감시 및 백그라운드 서브에이전트가 포함됩니다.

```typescript theme={null}
type SDKTaskNotificationMessage = {
  type: "system";
  subtype: "task_notification";
  task_id: string;
  tool_use_id?: string;
  status: "completed" | "failed" | "stopped";
  output_file: string;
  summary: string;
  usage?: {
    total_tokens: number;
    tool_uses: number;
    duration_ms: number;
  };
  uuid: UUID;
  session_id: string;
};
```

### `SDKToolUseSummaryMessage`

대화에서의 도구 사용 요약입니다.

```typescript theme={null}
type SDKToolUseSummaryMessage = {
  type: "tool_use_summary";
  summary: string;
  preceding_tool_use_ids: string[];
  uuid: UUID;
  session_id: string;
};
```

### `SDKHookStartedMessage`

훅이 실행을 시작할 때 내보내집니다.

```typescript theme={null}
type SDKHookStartedMessage = {
  type: "system";
  subtype: "hook_started";
  hook_id: string;
  hook_name: string;
  hook_event: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKHookProgressMessage`

훅이 실행 중일 때 stdout/stderr 출력과 함께 내보내집니다.

```typescript theme={null}
type SDKHookProgressMessage = {
  type: "system";
  subtype: "hook_progress";
  hook_id: string;
  hook_name: string;
  hook_event: string;
  stdout: string;
  stderr: string;
  output: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKHookResponseMessage`

훅이 실행을 완료할 때 내보내집니다.

```typescript theme={null}
type SDKHookResponseMessage = {
  type: "system";
  subtype: "hook_response";
  hook_id: string;
  hook_name: string;
  hook_event: string;
  output: string;
  stdout: string;
  stderr: string;
  exit_code?: number;
  outcome: "success" | "error" | "cancelled";
  uuid: UUID;
  session_id: string;
};
```

### `SDKToolProgressMessage`

도구가 실행 중일 때 진행 상황을 나타내기 위해 주기적으로 내보내집니다.

```typescript theme={null}
type SDKToolProgressMessage = {
  type: "tool_progress";
  tool_use_id: string;
  tool_name: string;
  parent_tool_use_id: string | null;
  elapsed_time_seconds: number;
  task_id?: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKAuthStatusMessage`

인증 흐름 중에 내보내집니다.

```typescript theme={null}
type SDKAuthStatusMessage = {
  type: "auth_status";
  isAuthenticating: boolean;
  output: string[];
  error?: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKTaskStartedMessage`

백그라운드 작업이 시작될 때 내보내집니다. `task_type` 필드는 백그라운드 Bash 명령 및 [Monitor](#monitor) 감시의 경우 `"local_bash"`, 서브에이전트의 경우 `"local_agent"` 또는 `"remote_agent"`입니다.

```typescript theme={null}
type SDKTaskStartedMessage = {
  type: "system";
  subtype: "task_started";
  task_id: string;
  tool_use_id?: string;
  description: string;
  task_type?: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKTaskProgressMessage`

백그라운드 작업이 실행 중일 때 주기적으로 내보내집니다.

```typescript theme={null}
type SDKTaskProgressMessage = {
  type: "system";
  subtype: "task_progress";
  task_id: string;
  tool_use_id?: string;
  description: string;
  usage: {
    total_tokens: number;
    tool_uses: number;
    duration_ms: number;
  };
  last_tool_name?: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKTaskUpdatedMessage`

백그라운드 작업의 상태가 변경될 때 내보내집니다. 예를 들어 `running`에서 `completed`로 전환될 때입니다. `patch`를 `task_id`로 키가 지정된 로컬 작업 맵에 병합합니다. `end_time` 필드는 Unix epoch 타임스탬프(밀리초)이며 `Date.now()`와 비교할 수 있습니다.

```typescript theme={null}
type SDKTaskUpdatedMessage = {
  type: "system";
  subtype: "task_updated";
  task_id: string;
  patch: {
    status?: "pending" | "running" | "completed" | "failed" | "killed";
    description?: string;
    end_time?: number;
    total_paused_ms?: number;
    error?: string;
    is_backgrounded?: boolean;
  };
  uuid: UUID;
  session_id: string;
};
```

### `SDKFilesPersistedEvent`

파일 체크포인트가 디스크에 지속될 때 내보내집니다.

```typescript theme={null}
type SDKFilesPersistedEvent = {
  type: "system";
  subtype: "files_persisted";
  files: { filename: string; file_id: string }[];
  failed: { filename: string; error: string }[];
  processed_at: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKRateLimitEvent`

세션이 속도 제한을 만날 때 내보내집니다.

```typescript theme={null}
type SDKRateLimitEvent = {
  type: "rate_limit_event";
  rate_limit_info: {
    status: "allowed" | "allowed_warning" | "rejected";
    resetsAt?: number;
    utilization?: number;
  };
  uuid: UUID;
  session_id: string;
};
```

### `SDKLocalCommandOutputMessage`

로컬 슬래시 명령의 출력 (예: `/voice` 또는 `/usage`). 트랜스크립트에서 어시스턴트 스타일 텍스트로 표시됩니다.

```typescript theme={null}
type SDKLocalCommandOutputMessage = {
  type: "system";
  subtype: "local_command_output";
  content: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKPromptSuggestionMessage`

`promptSuggestions`가 활성화되었을 때 각 턴 후에 내보내집니다. 예측된 다음 사용자 프롬프트를 포함합니다.

```typescript theme={null}
type SDKPromptSuggestionMessage = {
  type: "prompt_suggestion";
  suggestion: string;
  uuid: UUID;
  session_id: string;
};
```

### `AbortError`

중단 작업을 위한 사용자 정의 오류 클래스입니다.

```typescript theme={null}
class AbortError extends Error {}
```

## 샌드박스 구성

### `SandboxSettings`

샌드박스 동작의 구성입니다. 이를 사용하여 명령 샌드박싱을 활성화하고 프로그래밍 방식으로 네트워크 제한을 구성합니다.

```typescript theme={null}
type SandboxSettings = {
  enabled?: boolean;
  autoAllowBashIfSandboxed?: boolean;
  excludedCommands?: string[];
  allowUnsandboxedCommands?: boolean;
  network?: SandboxNetworkConfig;
  filesystem?: SandboxFilesystemConfig;
  ignoreViolations?: Record<string, string[]>;
  enableWeakerNestedSandbox?: boolean;
  ripgrep?: { command: string; args?: string[] };
};
```

| 속성                          | 타입                                                      | 기본값         | 설명                                                                                                                                                                     |
| :-------------------------- | :------------------------------------------------------ | :---------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `enabled`                   | `boolean`                                               | `false`     | 명령 실행을 위한 샌드박스 모드 활성화                                                                                                                                                  |
| `autoAllowBashIfSandboxed`  | `boolean`                                               | `true`      | 샌드박스가 활성화되었을 때 bash 명령 자동 승인                                                                                                                                           |
| `excludedCommands`          | `string[]`                                              | `[]`        | 항상 샌드박스 제한을 무시하는 명령 (예: `['docker']`). 이들은 모델 개입 없이 자동으로 샌드박스되지 않은 상태로 실행됩니다                                                                                           |
| `allowUnsandboxedCommands`  | `boolean`                                               | `true`      | 모델이 샌드박스 외부에서 명령을 실행하도록 요청하도록 허용합니다. `true`일 때 모델은 도구 입력에서 `dangerouslyDisableSandbox`를 설정할 수 있으며, 이는 [권한 시스템](#permissions-fallback-for-unsandboxed-commands)으로 폴백됩니다 |
| `network`                   | [`SandboxNetworkConfig`](#sandbox-network-config)       | `undefined` | 네트워크 특정 샌드박스 구성                                                                                                                                                        |
| `filesystem`                | [`SandboxFilesystemConfig`](#sandbox-filesystem-config) | `undefined` | 읽기/쓰기 제한을 위한 파일 시스템 특정 샌드박스 구성                                                                                                                                         |
| `ignoreViolations`          | `Record<string, string[]>`                              | `undefined` | 무시할 위반 카테고리를 패턴에 매핑합니다 (예: `{ file: ['/tmp/*'], network: ['localhost'] }`)                                                                                             |
| `enableWeakerNestedSandbox` | `boolean`                                               | `false`     | 호환성을 위해 더 약한 중첩 샌드박스 활성화                                                                                                                                               |
| `ripgrep`                   | `{ command: string; args?: string[] }`                  | `undefined` | 샌드박스 환경을 위한 사용자 정의 ripgrep 바이너리 구성                                                                                                                                     |

#### 사용 예제

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Build and test my project",
  options: {
    sandbox: {
      enabled: true,
      autoAllowBashIfSandboxed: true,
      network: {
        allowLocalBinding: true
      }
    }
  }
})) {
  if ("result" in message) console.log(message.result);
}
```

<Warning>
  **Unix 소켓 보안:** `allowUnixSockets` 옵션은 강력한 시스템 서비스에 대한 액세스를 부여할 수 있습니다. 예를 들어 `/var/run/docker.sock`을 허용하면 Docker API를 통해 전체 호스트 시스템 액세스를 효과적으로 부여하여 샌드박스 격리를 무시합니다. 엄격히 필요한 Unix 소켓만 허용하고 각각의 보안 영향을 이해합니다.
</Warning>

### `SandboxNetworkConfig`

샌드박스 모드를 위한 네트워크 특정 구성입니다.

```typescript theme={null}
type SandboxNetworkConfig = {
  allowedDomains?: string[];
  deniedDomains?: string[];
  allowManagedDomainsOnly?: boolean;
  allowLocalBinding?: boolean;
  allowUnixSockets?: string[];
  allowAllUnixSockets?: boolean;
  httpProxyPort?: number;
  socksProxyPort?: number;
};
```

| 속성                        | 타입         | 기본값         | 설명                                                        |
| :------------------------ | :--------- | :---------- | :-------------------------------------------------------- |
| `allowedDomains`          | `string[]` | `[]`        | 샌드박스된 프로세스가 액세스할 수 있는 도메인 이름                              |
| `deniedDomains`           | `string[]` | `[]`        | 샌드박스된 프로세스가 액세스할 수 없는 도메인 이름입니다. `allowedDomains`보다 우선합니다 |
| `allowManagedDomainsOnly` | `boolean`  | `false`     | 네트워크 액세스를 `allowedDomains`의 도메인으로만 제한합니다                  |
| `allowLocalBinding`       | `boolean`  | `false`     | 프로세스가 로컬 포트에 바인딩하도록 허용합니다 (예: 개발 서버의 경우)                  |
| `allowUnixSockets`        | `string[]` | `[]`        | 프로세스가 액세스할 수 있는 Unix 소켓 경로 (예: Docker 소켓)                 |
| `allowAllUnixSockets`     | `boolean`  | `false`     | 모든 Unix 소켓에 대한 액세스 허용                                     |
| `httpProxyPort`           | `number`   | `undefined` | 네트워크 요청을 위한 HTTP 프록시 포트                                   |
| `socksProxyPort`          | `number`   | `undefined` | 네트워크 요청을 위한 SOCKS 프록시 포트                                  |

### `SandboxFilesystemConfig`

샌드박스 모드를 위한 파일 시스템 특정 구성입니다.

```typescript theme={null}
type SandboxFilesystemConfig = {
  allowWrite?: string[];
  denyWrite?: string[];
  denyRead?: string[];
};
```

| 속성           | 타입         | 기본값  | 설명                   |
| :----------- | :--------- | :--- | :------------------- |
| `allowWrite` | `string[]` | `[]` | 쓰기 액세스를 허용할 파일 경로 패턴 |
| `denyWrite`  | `string[]` | `[]` | 쓰기 액세스를 거부할 파일 경로 패턴 |
| `denyRead`   | `string[]` | `[]` | 읽기 액세스를 거부할 파일 경로 패턴 |

### 샌드박스되지 않은 명령에 대한 권한 폴백

`allowUnsandboxedCommands`가 활성화되었을 때 모델은 도구 입력에서 `dangerouslyDisableSandbox: true`를 설정하여 샌드박스 외부에서 명령을 실행하도록 요청할 수 있습니다. 이러한 요청은 기존 권한 시스템으로 폴백되므로 `canUseTool` 핸들러가 호출되어 사용자 정의 인증 로직을 구현할 수 있습니다.

<Note>
  **`excludedCommands` vs `allowUnsandboxedCommands`:**

  * `excludedCommands`: 항상 자동으로 샌드박스를 무시하는 명령의 정적 목록 (예: `['docker']`). 모델은 이에 대한 제어가 없습니다.
  * `allowUnsandboxedCommands`: 모델이 도구 입력에서 `dangerouslyDisableSandbox: true`를 설정하여 런타임에 샌드박스되지 않은 실행을 요청하도록 합니다.
</Note>

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Deploy my application",
  options: {
    sandbox: {
      enabled: true,
      allowUnsandboxedCommands: true // 모델이 샌드박스되지 않은 실행을 요청할 수 있습니다
    },
    permissionMode: "default",
    canUseTool: async (tool, input) => {
      // 모델이 샌드박스를 무시하도록 요청하는지 확인합니다
      if (tool === "Bash" && input.dangerouslyDisableSandbox) {
        // 모델이 이 명령을 샌드박스 외부에서 실행하도록 요청합니다
        console.log(`Unsandboxed command requested: ${input.command}`);

        if (isCommandAuthorized(input.command)) {
          return { behavior: "allow" as const, updatedInput: input };
        }
        return {
          behavior: "deny" as const,
          message: "Command not authorized for unsandboxed execution"
        };
      }
      return { behavior: "allow" as const, updatedInput: input };
    }
  }
})) {
  if ("result" in message) console.log(message.result);
}
```

이 패턴을 사용하면 다음을 수행할 수 있습니다:

* **모델 요청 감사:** 모델이 샌드박스되지 않은 실행을 요청할 때 로그합니다
* **허용 목록 구현:** 특정 명령만 샌드박스되지 않은 상태로 실행하도록 허용합니다
* **승인 워크플로우 추가:** 권한 있는 작업에 대한 명시적 인증이 필요합니다

<Warning>
  `dangerouslyDisableSandbox: true`로 실행되는 명령은 전체 시스템 액세스 권한이 있습니다. `canUseTool` 핸들러가 이러한 요청을 신중하게 검증하는지 확인합니다.

  `permissionMode`가 `bypassPermissions`로 설정되고 `allowUnsandboxedCommands`가 활성화되면 모델은 승인 프롬프트 없이 샌드박스 외부에서 명령을 자율적으로 실행할 수 있습니다. 이 조합은 모델이 샌드박스 격리를 조용히 탈출하도록 효과적으로 허용합니다.
</Warning>

## 참고 항목

* [SDK 개요](/ko/agent-sdk/overview) - 일반 SDK 개념
* [Python SDK 참조](/ko/agent-sdk/python) - Python SDK 문서
* [CLI 참조](/ko/cli-reference) - 명령줄 인터페이스
* [일반적인 워크플로우](/ko/common-workflows) - 단계별 가이드
