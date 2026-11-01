> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Agent SDK 참조 - TypeScript

> TypeScript Agent SDK의 완전한 API 참조로, 모든 함수, 타입 및 인터페이스를 포함합니다.

## 설치

```bash theme={null}
npm install @anthropic-ai/claude-agent-sdk
```

> [!NOTE]
>
> SDK는 선택적 종속성으로 플랫폼용 네이티브 Claude Code 바이너리를 번들로 제공합니다(예: `@anthropic-ai/claude-agent-sdk-darwin-arm64`). 대부분의 설치에서는 Claude Code를 별도로 설치할 필요가 없습니다. SDK 버전은 번들된 Claude Code 버전을 추적합니다. SDK v0.3.191은 Claude Code v2.1.191을 번들로 제공하므로, 이 페이지의 특정 Claude Code 버전이 필요한 기능은 동일한 패치 번호 이상의 SDK 릴리스가 필요합니다. 패키지 관리자가 선택적 종속성을 건너뛰면 SDK는 `Native CLI binary for <platform>-<arch> not found` 오류를 발생시킵니다. 이 경우 [`pathToClaudeCodeExecutable`](#options)을 별도로 설치된 `claude` 바이너리로 설정하세요.
>
> 패키지 관리자가 npm의 `libc` 필드를 적용하지 않으면(Yarn 1.x의 경우처럼), Linux에서 glibc 및 musl 플랫폼 패키지를 모두 받게 되어 설치 크기가 대략 두 배로 증가합니다. Agent SDK v0.2.141 이상에서는 SDK가 여전히 올바른 변형을 실행합니다. 컨테이너 이미지에서 공간을 확보하려면 앱이 실행되는 libc와 일치하지 않는 플랫폼 패키지를 삭제하세요. x64의 glibc 런타임의 경우 `rm -rf node_modules/@anthropic-ai/claude-agent-sdk-linux-x64-musl`입니다. 개발 머신에서는 Yarn이 다음 종속성 변경 시 패키지를 다시 설치하므로 삭제가 임시적입니다.

### 단일 실행 파일로 컴파일

`bun build --compile`을 사용하여 애플리케이션을 단일 파일 실행 파일로 컴파일하면 SDK는 런타임에 번들된 CLI 바이너리를 확인할 수 없습니다. `require.resolve`는 컴파일된 실행 파일의 `$bunfs` 가상 파일 시스템 내에서 작동하지 않으므로 SDK는 `Native CLI binary for <platform>-<arch> not found` 오류를 발생시킵니다.

이를 해결하려면 플랫폼 바이너리를 파일 자산으로 포함하고, 시작 시 `extractFromBunfs()`를 사용하여 실제 경로로 추출한 다음, 해당 경로를 [`pathToClaudeCodeExecutable`](#options)에 전달하세요.

`extractFromBunfs()` 헬퍼는 `@anthropic-ai/claude-agent-sdk` v0.3.144 이상이 필요합니다. 아래 예제는 Apple Silicon의 macOS용으로 빌드합니다:

```typescript theme={null}
import binPath from "@anthropic-ai/claude-agent-sdk-darwin-arm64/claude" with { type: "file" };
import { extractFromBunfs } from "@anthropic-ai/claude-agent-sdk/extract";
import { query } from "@anthropic-ai/claude-agent-sdk";

const cliPath = extractFromBunfs(binPath);

for await (const message of query({
  prompt: "Hello",
  options: { pathToClaudeCodeExecutable: cliPath },
})) {
  console.log(message);
}
```

`extractFromBunfs()`는 컴파일된 실행 파일의 가상 파일 시스템에서 포함된 바이너리를 사용자별 임시 디렉터리로 복사하고 실제 경로를 반환합니다. 컴파일된 실행 파일 외부에서는 입력 경로를 변경하지 않고 반환하므로 동일한 코드가 수정 없이 개발 환경에서 실행됩니다.

각 컴파일된 실행 파일은 단일 플랫폼의 바이너리를 포함합니다. 가져오기의 플랫폼 패키지를 `--target`과 일치시키세요:

* 크로스 컴파일하려면 일치하지 않는 플랫폼 패키지를 설치하세요. 예를 들어 `npm install @anthropic-ai/claude-agent-sdk-linux-x64 --force`입니다.
* Windows에서 바이너리 하위 경로는 `claude.exe`입니다. 예를 들어 `@anthropic-ai/claude-agent-sdk-win32-x64/claude.exe`입니다.

### Agent SDK를 번들할 때 `/core` 항목을 가져오기

애플리케이션이 Agent SDK를 자체 종속성과 함께 번들로 제공하는 경우 패키지 루트 대신 `@anthropic-ai/claude-agent-sdk/core`에서 가져오세요. `/core` 항목은 TypeScript Agent SDK v0.3.282 이상이 필요하며, 해당 타입은 TypeScript 5.0 이상이 필요합니다.

`/core` 항목은 루트 항목과 동일한 `query()`, `startup()`, `tool()`, `createSdkMcpServer()`, `resolveSettings()`를 내보내며, 세션을 이름 바꾸기, 태그 지정 및 삭제하는 함수, `AbortError`, 런타임 상수 및 모든 타입을 내보냅니다. 자체 이름을 추가하지 않습니다. 애플리케이션이 로드하는 코드를 작게 유지하기 위해 `/core`는 `prewarm()`, `InMemorySessionStore` 클래스, 세션을 나열, 읽기, 포크, 가져오기 및 요약하는 헬퍼를 포함한 일부 루트 내보내기를 제외합니다. 이 중 하나가 필요한 경우 대신 루트 항목을 사용하세요.

루트 항목은 `zod` 및 `@modelcontextprotocol/sdk`의 자체 복사본을 인라인합니다. `/core` 항목은 Agent SDK의 `peerDependencies`가 선언하는 범위에서 `node_modules`에서 이들을 가져오므로, 이미 포함된 번들은 두 번째 복사본을 전달하지 않습니다. 주어진 프로세스에서 루트 또는 `/core` 중 하나에서 가져오세요. 둘 다에서 가져오지 마세요. 이들은 별도의 번들이며, 둘 다 로드하면 Agent SDK의 클래스 및 상태의 두 복사본을 얻게 됩니다.

## 함수

### `query()`

Claude Code와 상호작용하기 위한 주요 함수입니다. 메시지가 도착하는 대로 스트리밍하는 비동기 생성기를 생성합니다.

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

| 매개변수 | 유형 | 설명 |
| :- | :- | :- |
| `prompt` | `string \| AsyncIterable<`[`SDKUserMessage`](#sdkusermessage)`>` | 문자열 또는 스트리밍 모드용 비동기 반복 가능 객체로 입력 프롬프트 |
| `options` | [`Options`](#options) | 선택적 구성 객체 (아래 Options 유형 참조) |

#### 반환값

추가 메서드가 포함된 `AsyncGenerator<`[`SDKMessage`](#sdkmessage)`, void>`를 확장하는 [`Query`](#query-object) 객체를 반환합니다.

### `startup()`

프롬프트를 사용할 수 있기 전에 CLI 부프로세스를 생성하고 초기화 핸드셰이크를 완료하여 미리 준비합니다. 반환된 [`WarmQuery`](#warmquery) 핸들은 나중에 프롬프트를 수락하고 이미 준비된 프로세스에 작성하므로 첫 번째 `query()` 호출이 부프로세스 생성 및 초기화 비용을 인라인으로 지불하지 않고 해결됩니다. 세션의 작업 디렉터리를 아직 모르는 경우 대신 [`prewarm()`](#prewarm)을 사용합니다.

```typescript theme={null}
function startup(params?: {
  options?: Options;
  initializeTimeoutMs?: number;
}): Promise<WarmQuery>;
```

#### 매개변수

| 매개변수 | 유형 | 설명 |
| :- | :- | :- |
| `options` | [`Options`](#options) | 선택적 구성 객체입니다. `query()`의 `options` 매개변수와 동일합니다 |
| `initializeTimeoutMs` | `number` | 부프로세스 초기화를 기다릴 최대 시간(밀리초)입니다. 기본값은 `60000`입니다. 초기화가 시간 내에 완료되지 않으면 프로미스가 타임아웃 오류로 거부됩니다 |

#### 반환값

부프로세스가 생성되고 초기화 핸드셰이크를 완료한 후 해결되는 `Promise<`[`WarmQuery`](#warmquery)`>`를 반환합니다.

핸드셰이크가 완료되기 전에 `SessionStart` 또는 `Setup` 훅이 내보내는 [`hook_progress`](#sdkhookprogressmessage) 메시지 중에서는 가장 최신 메시지만 전달되며, 이 메시지에는 지금까지의 훅 출력 전체가 담겨 있습니다. `startup()`은 해당 메시지, 훅의 [`hook_started`](#sdkhookstartedmessage) 메시지, 그리고 핸드셰이크가 완료되기 전에 부프로세스가 내보내는 그 밖의 모든 메시지를 보관합니다. 보관된 메시지는 `WarmQuery`에서 `.query()`를 호출하고 결과를 반복할 때 전달됩니다.

#### 예제

`startup()`을 조기에 호출합니다(예: 애플리케이션 부팅 시). 그런 다음 프롬프트가 준비되면 반환된 핸들에서 `.query()`를 호출합니다. 이렇게 하면 부프로세스 생성 및 초기화가 중요 경로에서 제거됩니다.

```typescript theme={null}
import { startup } from "@anthropic-ai/claude-agent-sdk";

// 시작 비용을 미리 지불합니다
const warm = await startup({ options: { maxTurns: 3 } });

// 나중에 프롬프트가 준비되면 즉시 실행됩니다
for await (const message of warm.query("What files are here?")) {
  console.log(message);
}
```

### `prewarm()`

*알파.* 어느 세션을 제공할지 알기 전에 Claude Code 프로세스를 스페어로 미리 시작하여 나중에 [`claim()`](#spareprocess)으로 세션에 바인딩할 수 있습니다. 사용자가 폴더를 선택하기 전에 부팅되는 애플리케이션에서 사용합니다. TypeScript Agent SDK v0.3.282 이상이 필요합니다.

`prewarm()`은 [`startup()`](#startup)과 동일한 초기화 핸드셰이크를 완료하며, `options.cwd`를 설정할 때 해당 디렉터리에서 프로세스가 대기하고, 그렇지 않으면 Claude Code 구성 디렉터리 아래의 개인 임시 디렉터리에서 대기합니다. 세션의 작업 디렉터리, 해당 `SessionStart` 훅, 해당 stdio MCP 서버, 해당 CLAUDE.md 및 git 컨텍스트는 클레임을 기다립니다. 스페어는 대기하는 동안 대략 230\~260 MB의 메모리를 보유합니다. [`spawnClaudeCodeProcess`](#options)가 다른 머신이나 컨테이너에서 Claude Code를 실행하는 경우 `options.cwd`를 해당 환경에 존재하는 디렉터리로 설정하여 스페어가 그곳에서 대기하도록 합니다.

```typescript theme={null}
function prewarm(params?: {
  options?: Options;
  initializeTimeoutMs?: number;
}): Promise<SpareProcess>;
```

`options` 및 `initializeTimeoutMs`는 `startup()`과 동일한 의미를 가지며, `options.cwd`는 스페어가 대기하는 디렉터리만 설정합니다. 프로미스는 프로세스가 초기화 핸드셰이크를 완료한 후 [`SpareProcess`](#spareprocess)로 해결됩니다. `prewarm()`은 `options`가 `resume`, `continue` 또는 `forkSession`을 설정하면 throw합니다. 스페어는 아직 세션이 없기 때문입니다. 클레임이 설정할 수 없는 모든 것(예: `mcpServers`, `hooks`, `canUseTool`, `settingSources`, `systemPrompt` 및 `plugins`)은 스페어의 수명 동안 고정되므로 해당 옵션의 고유한 집합마다 하나의 스페어를 유지하고 변경될 때 다시 미리 준비합니다.

#### 예제

애플리케이션 부팅 시 미리 준비한 다음 사용자가 세션을 시작할 때 스페어를 클레임합니다:

```typescript theme={null}
import { prewarm } from "@anthropic-ai/claude-agent-sdk";

// 애플리케이션 부팅 시, 세션의 폴더가 알려지기 전
const spare = await prewarm({ options: { maxTurns: 3 } });

// 나중에 사용자가 폴더에서 세션을 시작할 때
const claimedQuery = spare.claim({
  prompt: "What files are here?",
  options: { cwd: "/path/to/project" },
});

spare.claimed.catch((error: Error) => {
  // 메시지가 "option_not_applied"로 시작하지 않으면 프롬프트가 실행되지 않았습니다:
  // 대신 이 세션을 query()로 시작합니다
  console.error("Claim failed:", error.message);
});

try {
  for await (const message of claimedQuery) {
    console.log(message);
  }
} catch (error) {
  // 클레임이 거부된 후, 클레임된 쿼리는 오류 결과를 생성한 뒤 throw합니다
  console.error(`Session ended with an error: ${error}`);
}
```

### `tool()`

SDK MCP 서버와 함께 사용할 유형 안전 MCP 도구 정의를 생성합니다.

```typescript theme={null}
function tool<Schema extends AnyZodRawShape>(
  name: string,
  description: string,
  inputSchema: Schema,
  handler: (args: InferShape<Schema>, extra: unknown) => Promise<CallToolResult>,
  extras?: { annotations?: ToolAnnotations; searchHint?: string; alwaysLoad?: boolean }
): SdkMcpToolDefinition<Schema>;
```

#### 매개변수

| 매개변수 | 유형 | 설명 |
| :- | :- | :- |
| `name` | `string` | 도구의 이름 |
| `description` | `string` | 도구가 수행하는 작업에 대한 설명 |
| `inputSchema` | `Schema extends AnyZodRawShape` | 도구의 입력 매개변수를 정의하는 Zod 스키마 (Zod 3 및 Zod 4 모두 지원) |
| `handler` | `(args, extra) => Promise<`[`CallToolResult`](#calltoolresult)`>` | 도구 로직을 실행하는 비동기 함수 |
| `extras` | `{ annotations?: `[`ToolAnnotations`](#toolannotations)`; searchHint?: string; alwaysLoad?: boolean }` | 선택적 추가 항목입니다. `annotations`는 클라이언트에 MCP 동작 힌트를 제공합니다. `searchHint`는 [도구 검색](https://code.claude.com/docs/ko/agent-sdk/tool-search.md)이 활성화되어 있을 때 지연된 도구 목록에 표시되는 한 줄의 기능 구문입니다. `alwaysLoad: true`는 이 도구의 전체 스키마를 초기 프롬프트에 유지하고 지연하지 않습니다 |

#### `ToolAnnotations`

`@modelcontextprotocol/sdk/types.js`에 정의되어 있습니다. 모든 필드는 선택적 힌트이며 클라이언트는 보안 결정을 위해 이를 신뢰해서는 안 됩니다.

| 필드 | 유형 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `title` | `string` | `undefined` | 도구의 사람이 읽을 수 있는 제목 |
| `readOnlyHint` | `boolean` | `false` | `true`인 경우 도구는 환경을 수정하지 않습니다 |
| `destructiveHint` | `boolean` | `true` | `true`인 경우 도구는 파괴적인 업데이트를 수행할 수 있습니다. [`always_ask`](#mcpservertoolpolicy)로 표시한 모든 도구에는 `destructiveHint: true`를 명시적으로 설정해야 합니다. 그렇지 않으면 자동 모드 분류기가 `canUseTool` 콜백 대신 해당 도구의 호출을 승인할 수 있습니다. `destructiveHint`를 설정하지 않은 채로 두는 것만으로는 충분하지 않습니다. MCP 사양의 기본값은 `true`이지만, Claude Code는 `always_ask` 호출을 처리할 때 설정되지 않은 `destructiveHint`를 `false`로 취급하기 때문입니다 |
| `idempotentHint` | `boolean` | `false` | `true`인 경우 동일한 인수로 반복 호출해도 추가 효과가 없습니다 (`readOnlyHint`가 `false`일 때만 의미 있음) |
| `openWorldHint` | `boolean` | `true` | `true`인 경우 도구는 외부 엔티티와 상호작용합니다 (예: 웹 검색). `false`인 경우 도구의 도메인은 폐쇄적입니다 (예: 메모리 도구) |

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

애플리케이션과 동일한 프로세스에서 실행되는 MCP 서버 인스턴스를 생성합니다.

```typescript theme={null}
function createSdkMcpServer(options: {
  name: string;
  version?: string;
  instructions?: string;
  tools?: Array<SdkMcpToolDefinition<any>>;
  alwaysLoad?: boolean;
  timeout?: number;
}): McpSdkServerConfigWithInstance;
```

#### 매개변수

| 매개변수 | 유형 | 설명 |
| :- | :- | :- |
| `options.name` | `string` | MCP 서버의 이름 |
| `options.version` | `string` | 선택적 버전 문자열 |
| `options.instructions` | `string` | 선택적 서버 지침이며, `initialize`에서 반환되고 MCP 지침 블록으로 모델에 표시됩니다 |
| `options.tools` | `Array<SdkMcpToolDefinition>` | [`tool()`](#tool)로 생성된 도구 정의 배열 |
| `options.alwaysLoad` | `boolean` | `true`인 경우 이 서버의 도구는 초기 프롬프트에 유지되며 [도구 검색](https://code.claude.com/docs/ko/agent-sdk/tool-search.md) 뒤에서 지연되지 않습니다. [`tool()`](#tool)의 도구별 `alwaysLoad`와 결합됩니다 |
| `options.timeout` | `number` | 이 서버의 도구 호출에 대한 타임아웃(밀리초)입니다. Claude Code는 [`MCP_TOOL_TIMEOUT`](https://code.claude.com/docs/ko/env-vars)을 대신하여 이 서버에 적용합니다. 최소 1000의 정수를 전달합니다. Claude Code는 다른 값을 무시합니다. TypeScript Agent SDK v0.3.248 이상이 필요합니다 |

### `listSessions()`

가벼운 메타데이터를 포함한 과거 세션을 발견하고 나열합니다. 프로젝트 디렉터리별로 필터링하거나 모든 프로젝트에서 세션을 나열합니다.

```typescript theme={null}
function listSessions(options?: ListSessionsOptions): Promise<SDKSessionInfo[]>;
```

#### 매개변수

| 매개변수 | 유형 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `options.dir` | `string` | `undefined` | 세션을 나열할 디렉터리입니다. 생략하면 모든 프로젝트에서 세션을 반환합니다 |
| `options.limit` | `number` | `undefined` | 반환할 최대 세션 수 |
| `options.includeWorktrees` | `boolean` | `true` | `dir`이 git 저장소 내에 있을 때 모든 worktree 경로에서 세션을 포함합니다 |

#### 반환 유형: `SDKSessionInfo`

| 속성 | 유형 | 설명 |
| :- | :- | :- |
| `sessionId` | `string` | 고유 세션 식별자 (UUID) |
| `summary` | `string` | 표시 제목: 사용자 정의 제목, 가장 최근 프롬프트, 자동 생성된 요약 또는 첫 번째 프롬프트 |
| `lastModified` | `number` | 마지막 수정 시간(에포크 이후 밀리초) |
| `fileSize` | `number \| undefined` | 세션 파일 크기(바이트)입니다. 로컬 JSONL 스토리지에만 채워집니다 |
| `customTitle` | `string \| undefined` | 사용자 정의 제목이 설정된 경우 세션의 사용자 정의 제목입니다(예: `--name`, `/rename`, 훅의 `sessionTitle` 출력 또는 [`renameSession()`](#renamesession)으로 설정). 그렇지 않으면 세션에 AI 생성 세션 제목이 있는 경우 해당 제목 |
| `firstPrompt` | `string \| undefined` | 세션의 첫 번째 의미 있는 사용자 프롬프트 |
| `gitBranch` | `string \| undefined` | 세션 끝의 Git 브랜치 |
| `cwd` | `string \| undefined` | 세션의 작업 디렉터리 |
| `tag` | `string \| undefined` | 사용자 설정 세션 태그 ([`tagSession()`](#tagsession) 참조) |
| `createdAt` | `number \| undefined` | 생성 시간(에포크 이후 밀리초)이며, 첫 번째 항목의 타임스탬프에서 가져옵니다 |

#### 예제

프로젝트의 10개 최신 세션을 인쇄합니다. 결과는 `lastModified` 내림차순으로 정렬되므로 첫 번째 항목이 가장 최신입니다. `dir`을 생략하여 모든 프로젝트에서 검색합니다.

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

| 매개변수 | 유형 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `sessionId` | `string` | 필수 | 읽을 세션 UUID (`listSessions()` 참조) |
| `options.dir` | `string` | `undefined` | 세션을 찾을 프로젝트 디렉터리입니다. 생략하면 모든 프로젝트를 검색합니다 |
| `options.limit` | `number` | `undefined` | 반환할 최대 메시지 수 |
| `options.offset` | `number` | `undefined` | 시작 부분에서 건너뛸 메시지 수 |
| `options.includeSystemMessages` | `boolean` | `false` | `true`인 경우 사용자 및 어시스턴트 메시지와 함께 압축 경계와 같은 시스템 메시지도 반환합니다 |

#### 반환 유형: `SessionMessage`

| 속성 | 유형 | 설명 |
| :- | :- | :- |
| `type` | `"user" \| "assistant" \| "system"` | 메시지 역할입니다. `"system"`은 `options.includeSystemMessages`가 `true`인 경우에만 나타납니다 |
| `uuid` | `string` | 고유 메시지 식별자 |
| `session_id` | `string` | 이 메시지가 속한 세션 |
| `message` | `unknown` | 트랜스크립트의 원본 메시지 페이로드 |
| `parent_tool_use_id` | `string \| null` | 서브에이전트 메시지의 경우 서브에이전트를 시작한 `Agent` 또는 `Skill` 도구 호출의 `tool_use_id`입니다. 주 세션 메시지 및 이전 세션의 경우 `null` |
| `parent_agent_id` | `string \| null` | [중첩된 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#let-subagents-spawn-their-own-subagents)의 메시지의 경우 해당 중첩 서브에이전트를 생성한 서브에이전트의 `agentId`입니다. 주 세션 메시지, 최상위 서브에이전트의 메시지 및 이전 세션의 경우 `null`입니다. Claude Code v2.1.202 이상이 필요합니다 |

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

전체 프로젝트 디렉터리를 스캔하지 않고 ID별로 단일 세션의 메타데이터를 읽습니다.

```typescript theme={null}
function getSessionInfo(
  sessionId: string,
  options?: GetSessionInfoOptions
): Promise<SDKSessionInfo | undefined>;
```

#### 매개변수

| 매개변수 | 유형 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `sessionId` | `string` | 필수 | 조회할 세션의 UUID |
| `options.dir` | `string` | `undefined` | 프로젝트 디렉터리 경로입니다. 생략하면 모든 프로젝트 디렉터리를 검색합니다 |

[`SDKSessionInfo`](#return-type-sdksessioninfo)를 반환하거나, 세션을 찾을 수 없으면 `undefined`를 반환합니다.

### `renameSession()`

사용자 정의 제목 항목을 추가하여 세션의 이름을 바꿉니다. 반복 호출은 안전하며 가장 최근 제목이 우선합니다.

```typescript theme={null}
function renameSession(
  sessionId: string,
  title: string,
  options?: SessionMutationOptions
): Promise<void>;
```

#### 매개변수

| 매개변수 | 유형 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `sessionId` | `string` | 필수 | 이름을 바꿀 세션의 UUID |
| `title` | `string` | 필수 | 새 제목입니다. 공백을 제거한 후 비어 있지 않아야 합니다 |
| `options.dir` | `string` | `undefined` | 프로젝트 디렉터리 경로입니다. 생략하면 모든 프로젝트 디렉터리를 검색합니다 |

### `tagSession()`

세션에 태그를 지정합니다. 태그를 지우려면 `null`을 전달합니다. 반복 호출은 안전하며 가장 최근 태그가 우선합니다.

```typescript theme={null}
function tagSession(
  sessionId: string,
  tag: string | null,
  options?: SessionMutationOptions
): Promise<void>;
```

#### 매개변수

| 매개변수 | 유형 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `sessionId` | `string` | 필수 | 태그를 지정할 세션의 UUID |
| `tag` | `string \| null` | 필수 | 태그 문자열 또는 지우려면 `null` |
| `options.dir` | `string` | `undefined` | 프로젝트 디렉터리 경로입니다. 생략하면 모든 프로젝트 디렉터리를 검색합니다 |

### `forkSession()`

세션의 트랜스크립트를 새 세션으로 복사하여 원본은 그대로 유지하면서 대화를 다른 방향으로 이어갈 수 있습니다. 대화의 이전 지점에서 분기하려면 `upToMessageId`를 전달합니다.

```typescript theme={null}
function forkSession(
  sessionId: string,
  options?: ForkSessionOptions
): Promise<ForkSessionResult>;
```

#### 매개변수

| 매개변수 | 유형 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `sessionId` | `string` | 필수 | 분기할 세션의 UUID |
| `options.dir` | `string` | `undefined` | 프로젝트 디렉터리 경로입니다. 생략하면 모든 프로젝트 디렉터리를 검색합니다 |
| `options.upToMessageId` | `string` | `undefined` | 이 `uuid`를 가진 메시지까지(해당 메시지 포함) 트랜스크립트를 복사합니다. 값은 [`getSessionMessages()`](#getsessionmessages)에서 얻은 값이거나 스트리밍된 [`SDKUserMessage`](#sdkusermessage)에 직접 설정한 `uuid`입니다. 생략하면 전체 트랜스크립트를 복사합니다 |
| `options.title` | `string` | `undefined` | 분기된 세션의 제목입니다. 생략하면 SDK가 원본 세션에서 제목을 파생하고 뒤에 `(fork)`를 붙입니다 |

새 세션의 UUID인 `{ sessionId }`를 반환합니다. 분기된 세션을 계속하려면 이를 [`resume`](#options)으로 전달합니다. 분기된 세션에는 원본 세션의 [파일 체크포인트](https://code.claude.com/docs/ko/agent-sdk/file-checkpointing.md)가 포함되지 않으므로 분기 이전에 캡처된 체크포인트로 되감을 수 없습니다.

`forkSession()`은 다음 경우에 throw합니다:

* `sessionId`가 UUID가 아닌 경우
* 세션을 찾을 수 없거나 세션에 메시지가 없는 경우
* `upToMessageId`가 트랜스크립트의 어떤 메시지와도 일치하지 않는 경우

### `resolveSettings()`

Claude CLI를 생성하지 않고 CLI와 동일한 병합 엔진을 사용하여 주어진 디렉터리에 대한 유효한 Claude Code 설정을 해결합니다. `query()` 호출을 실행하기 전에 해당 호출이 보게 될 구성을 검사하는 데 사용합니다.

> [!NOTE]
>
> 이 함수는 알파 버전이며 안정화 전에 API가 변경될 수 있습니다.

스냅샷은 라이브 `query()` 세션이 적용하는 것과 다릅니다:

* **`policyHelper`**: `resolveSettings()`는 macOS plist 및 Windows HKLM/HKCU를 포함한 MDM 소스를 읽지만 관리자 구성 `policyHelper` 부프로세스를 실행하지 않습니다.
* **서버 관리형 설정**: `resolveSettings()`는 [서버 관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md#fetch-and-caching-behavior)을 가져오지 않습니다. 포함하려면 `options.serverManagedSettings`으로 전달합니다.
* **`defaultMode`**: 스냅샷은 모든 계층에서 `permissions.defaultMode`를 그대로 반환하므로 프로젝트 및 로컬 설정의 `'auto'` 및 `'bypassPermissions'` 값을 포함할 수 있으며, [라이브 세션은 이를 무시합니다](https://code.claude.com/docs/ko/permission-modes.md#which-mode-a-session-starts-in).

```typescript theme={null}
function resolveSettings(
  options?: ResolveSettingsOptions
): Promise<ResolvedSettings>;
```

#### 매개변수

`resolveSettings()`는 단일 옵션 객체를 수락합니다. 모든 필드는 선택적입니다.

| 매개변수 | 유형 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `options.cwd` | `string` | `process.cwd()` | 프로젝트 및 로컬 설정을 상대적으로 해결할 디렉터리 |
| `options.settingSources` | [`SettingSource`](#settingsource)`[]` | 모든 소스 | 로드할 파일 시스템 소스입니다. 사용자, 프로젝트 및 로컬 설정을 건너뛰려면 `[]`을 전달합니다. [엔드포인트 관리형 정책](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms)은 모든 경우에 로드됩니다. `resolveSettings()`는 `options.serverManagedSettings`을 전달할 때만 서버 관리형 설정을 포함합니다 |
| `options.managedSettings` | `Settings` | `undefined` | 임베딩 호스트에서 제공하는 정책 계층 설정입니다. [`Options`의 `managedSettings`](#options)와 동일한 규칙을 따릅니다. 단, `resolveSettings()`는 구성된 [`policyHelper`](https://code.claude.com/docs/ko/settings-reference#policyhelper)를 실행하지 않으므로 스냅샷은 라이브 세션이 삭제하는 설정을 포함할 수 있습니다 |
| `options.serverManagedSettings` | `Settings` | `undefined` | `/api/claude_code/settings`의 서버 관리형 설정 페이로드입니다. 제한이 없는 키는 필터링되지 않고 통과합니다 |

#### 반환 유형: `ResolvedSettings`

`resolveSettings()`는 병합된 설정 및 각 키에 기여한 소스를 설명하는 객체를 반환합니다.

| 속성 | 유형 | 설명 |
| :- | :- | :- |
| `effective` | `Settings` | 모든 활성화된 소스를 우선순위 순서로 적용한 후 병합된 설정 |
| `provenance` | `Partial<Record<keyof Settings, ProvenanceEntry>>` | `effective`의 각 최상위 키에 대해 값을 제공한 소스 |
| `sources` | `Array<{ source, settings, path?, policyOrigin? }>` | 소스별 원본 설정이며, 가장 낮은 우선순위에서 가장 높은 우선순위 순서로 정렬됩니다 |

#### 예제

아래 예제는 프로젝트 디렉터리에 대한 설정을 해결하고 정리 기간을 제어하는 소스를 인쇄합니다. 설정 파일이 `cleanupPeriodDays`를 설정하지 않는 머신에서는 두 인쇄된 줄 모두 값에 대해 `undefined`를 표시하며, 이는 오류가 아닌 예상된 출력입니다.

```typescript theme={null}
import { resolveSettings } from "@anthropic-ai/claude-agent-sdk";

const { effective, provenance } = await resolveSettings({
  cwd: "/path/to/project",
  settingSources: ["user", "project", "local"],
});

console.log(`Cleanup period: ${effective.cleanupPeriodDays} days`);
console.log(`Set by: ${provenance.cleanupPeriodDays?.source}`);
```

## 타입

### `Options`

`query()` 함수의 구성 객체입니다.

| 속성 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `abortController` | `AbortController` | `new AbortController()` | 작업 취소를 위한 컨트롤러입니다 |
| `additionalDirectories` | `string[]` | `[]` | Claude가 액세스할 수 있는 추가 디렉터리입니다. SDK는 각 항목을 `--add-dir`로 Claude Code에 전달하므로, `project` 설정 소스를 사용하면 Claude Code는 [해당 디렉터리의 스킬, 명령, 서브에이전트도 로드합니다](https://code.claude.com/docs/ko/permissions.md#additional-directories-grant-file-access-not-configuration) |
| `agent` | `string` | `undefined` | 메인 스레드의 에이전트 이름입니다. 에이전트는 `agents` 옵션 또는 설정에 정의되어 있어야 합니다 |
| `agents` | `Record<string, [`AgentDefinition`](#agentdefinition)>` | `undefined` | 서브에이전트를 프로그래밍 방식으로 정의합니다 |
| `agentProgressSummaries` | `boolean` | `false` | `true`이면 서브에이전트에 대한 한 줄 진행 요약을 생성하고 `summary` 필드를 통해 [`task_progress`](#sdktaskprogressmessage) 이벤트로 전달합니다. 포그라운드 및 백그라운드 서브에이전트 모두에 적용됩니다 |
| `allowDangerouslySkipPermissions` | `boolean` | `false` | 권한 우회를 활성화합니다. 시작 시 또는 이후 `setPermissionMode()`를 통해 `permissionMode: 'bypassPermissions'`를 사용할 때 필요합니다. `permissionMode: 'plan'`과의 상호 작용 방식은 [플랜 모드](https://code.claude.com/docs/ko/agent-sdk/permissions.md#plan-mode-plan)를 참조하세요 |
| `allowedTools` | `string[]` | `[]` | [네트워크 경로](https://code.claude.com/docs/ko/permissions.md#network-paths)에서의 읽기를 제외하고, 확인을 요청하지 않고 자동 승인할 도구입니다. Claude가 이 도구만 사용하도록 제한하지는 않습니다. 여기에 [작업 추적 도구](https://code.claude.com/docs/ko/agent-sdk/todo-tracking.md#model-availability) 중 하나를 지정하면 Claude Code는 세션에서도 해당 기능을 사용하도록 설정합니다. 목록에 없는 다른 도구는 `permissionMode`와 `canUseTool`로 넘어갑니다. 도구를 차단하려면 `disallowedTools`를 사용하세요. [권한](https://code.claude.com/docs/ko/agent-sdk/permissions.md#allow-and-deny-rules)을 참조하세요 |
| `betas` | [`SdkBeta`](#sdkbeta)`[]` | `[]` | 베타 기능을 활성화합니다 |
| `canUseTool` | [`CanUseTool`](#canusetool) | `undefined` | 사용자 지정 권한 함수로, [권한 흐름](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)이 프롬프트로 넘어갈 때만 호출됩니다. `allowedTools`, 허용 규칙 또는 `permissionMode`에 의해 자동 승인된 호출에는 호출되지 않습니다. 허용 규칙은 [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)을 미리 승인하지 않습니다. 자세한 내용은 [`CanUseTool`](#canusetool)을 참조하세요 |
| `continue` | `boolean` | `false` | 가장 최근 대화를 이어갑니다 |
| `cwd` | `string` | `process.cwd()` | 현재 작업 디렉터리입니다 |
| `debug` | `boolean` | `false` | Claude Code 프로세스의 디버그 모드를 활성화합니다 |
| `debugFile` | `string` | `undefined` | 디버그 로그를 특정 파일 경로에 기록합니다. 디버그 모드를 암묵적으로 활성화합니다 |
| `disallowedTools` | `string[]` | `[]` | 거부할 도구입니다. `"Bash"`와 같은 단순 이름은 Claude의 컨텍스트에서 도구를 제거합니다. `"Bash(rm *)"`와 같은 범위 지정 규칙은 도구를 사용 가능한 상태로 두고, `bypassPermissions`를 포함한 모든 권한 모드에서 [작성된 그대로의](https://code.claude.com/docs/ko/permissions.md#bash-rule-limits) 명령과 일치하는 호출을 거부합니다. [권한](https://code.claude.com/docs/ko/agent-sdk/permissions.md#allow-and-deny-rules)을 참조하세요 |
| `effort` | `'low' \| 'medium' \| 'high' \| 'xhigh' \| 'max'` | `undefined` | Claude가 응답에 들이는 effort의 정도를 제어합니다. 적응형 사고와 함께 작동하여 사고 깊이를 안내합니다. [effort 수준 조정](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)을 참조하세요 |
| `enableFileCheckpointing` | `boolean` | `false` | 되감기를 위한 파일 변경 추적을 활성화합니다. [파일 체크포인트](https://code.claude.com/docs/ko/agent-sdk/file-checkpointing.md)를 참조하세요 |
| `env` | `Record<string, string \| undefined>` | `process.env` | 환경 변수입니다. 설정하면 `process.env`와 병합되는 대신 하위 프로세스 환경을 대체하므로, `PATH`와 같은 상속된 변수를 유지하려면 `{ ...process.env, YOUR_VAR: 'value' }`를 전달하세요. 이 패턴의 예는 [느리거나 멈춘 API 응답 처리](#handle-slow-or-stalled-api-responses)를, 기본 CLI가 읽는 변수는 [환경 변수](https://code.claude.com/docs/ko/env-vars.md)를 참조하세요. User-Agent 헤더에서 앱을 식별하려면 `CLAUDE_AGENT_SDK_CLIENT_APP`을 설정하세요 |
| `executable` | `'bun' \| 'deno' \| 'node'` | 자동 감지 | 사용할 JavaScript 런타임입니다 |
| `executableArgs` | `string[]` | `[]` | 실행 파일에 전달할 인수입니다 |
| `extraArgs` | `Record<string, string \| null>` | `{}` | 추가 인수입니다 |
| `fallbackModel` | `string` | `undefined` | 기본 모델이 실패할 경우 사용할 모델입니다. 쉼표로 구분된 목록을 허용합니다. 순서와 상한은 [폴백 모델 체인](https://code.claude.com/docs/ko/model-config.md#fallback-model-chains)을 참조하세요. 가이드는 [모델 선택](https://code.claude.com/docs/ko/agent-sdk/configuration.md#choose-a-model)을 참조하세요 |
| `forkSession` | `boolean` | `false` | `resume`으로 재개할 때 원래 세션을 이어가는 대신 새 세션 ID로 포크합니다 |
| `forwardSubagentText` | `boolean` | `false` | 서브에이전트의 텍스트 및 thinking 블록을 `parent_tool_use_id`가 설정된 assistant 및 user 메시지로 전달하여, 소비자가 중첩된 트랜스크립트를 렌더링할 수 있게 합니다. 이 옵션이 없으면 Claude Code는 [포그라운드](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)에서 실행되는 서브에이전트의 텍스트 및 thinking 블록을 생략합니다. 중첩된 서브에이전트, `context: fork`가 있는 스킬, 그리고 각각에 필요한 Claude Code 버전은 [서브에이전트 메시지 따라가기](https://code.claude.com/docs/ko/headless.md#follow-subagent-messages)를 참조하세요 |
| `hooks` | `Partial<Record<`[`HookEvent`](#hookevent)`, `[`HookCallbackMatcher`](#hookcallbackmatcher)`[]>>` | `{}` | 이벤트에 대한 훅 콜백입니다 |
| `includeHookEvents` | `boolean` | `false` | 훅 라이프사이클 이벤트를 [`SDKHookStartedMessage`](#sdkhookstartedmessage), [`SDKHookProgressMessage`](#sdkhookprogressmessage), [`SDKHookResponseMessage`](#sdkhookresponsemessage)로 메시지 스트림에 포함합니다. `SessionStart` 및 `Setup` 훅의 라이프사이클 이벤트는 항상 포함되며 이 옵션이 필요하지 않습니다. `Notification`, `SessionEnd`, `PreCompact`, `PostCompact`와 같은 일부 훅 이벤트는 이 옵션을 사용하더라도 `SDKHookStartedMessage`를 생성하지 않습니다. 이러한 이벤트의 경우에도 Claude Code는 1초 이상 실행되는 명령 훅이 출력을 생성하는 동안 `SDKHookProgressMessage`를 내보내며, [백그라운드에서 실행되는](https://code.claude.com/docs/ko/hooks.md#run-hooks-in-the-background) 훅이 완료될 때만 `SDKHookResponseMessage`를 내보냅니다 |
| `includePartialMessages` | `boolean` | `false` | 부분 메시지 이벤트를 포함합니다 |
| `loadTimeoutMs` | `number` | `60000` | *알파.* 재개 구체화 중 각 `sessionStore.load()` 및 `sessionStore.listSubkeys()` 호출에 대한 타임아웃(밀리초)입니다. 어댑터가 이 시간 내에 완료되지 않으면 쿼리가 멈춰 있는 대신 실패합니다. `sessionStore`가 설정되지 않은 경우 무시됩니다 |
| `managedSettings` | `Settings` | `undefined` | 호스트 프로세스가 생성된 세션에 제공하는 정책 계층 설정입니다. 관리자가 배포한 관리형 설정이 있는 머신에서는 관리자의 최우선 관리형 소스가 `parentSettingsBehavior: 'merge'`를 설정하지 않는 한 Claude Code가 이를 무시하며, [`policyHelper`](https://code.claude.com/docs/ko/settings-reference#policyhelper)가 관리형 설정을 제공하는 동안에는 절대 병합하지 않습니다. 병합된 값은 제한 전용 필터를 거칩니다. 필터가 허용하는 항목과 `allowManaged*Only` 잠금은 [상위 설정 제한](https://code.claude.com/docs/ko/claude-apps-gateway#restrict-parent-settings)에서 다룹니다. [`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](https://code.claude.com/docs/ko/env-vars)를 설정한 호스트는 대신 세 개의 키를 이 페이로드에서 직접 읽습니다. Claude Code v2.1.222 이상에서의 [모델 구성](https://code.claude.com/docs/ko/model-config.md#restrict-model-selection), v2.1.246 이상에서 관리형 소스가 설정하지 않은 경우의 [`modelPricing`](https://code.claude.com/docs/ko/settings-reference#modelpricing), v2.1.247 이상에서의 `ENABLE_TOOL_SEARCH` env 항목입니다 |
| `maxBudgetUsd` | `number` | `undefined` | 클라이언트 측 비용 추정치가 이 USD 값에 도달하면 쿼리를 중지합니다. 추정치가 이 값을 초과할 수 있으므로 [여유분을 두세요](https://code.claude.com/docs/ko/agent-sdk/agent-loop.md#budget-headroom). 해당 호출 자체의 지출만 집계하며, 재개된 세션에서 복원된 합계는 포함하지 않습니다. 정확도에 관한 주의 사항과 재설정 동작은 [비용 및 사용량 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md)을 참조하세요 |
| `maxThinkingTokens` | `number` | `undefined` | *지원 중단:* 대신 `thinking`을 사용하세요. 사고 과정의 최대 토큰 수입니다 |
| `maxTurns` | `number` | `undefined` | 최대 에이전트 [턴](https://code.claude.com/docs/ko/agent-sdk/agent-loop.md#turns-and-messages) 수 |
| `mcpServers` | `Record<string, [`McpServerConfig`](#mcpserverconfig)>` | `{}` | MCP 서버 구성입니다 |
| `model` | `string` | CLI의 기본값 | Claude 모델 별칭 또는 전체 모델 이름입니다. [허용되는 값 및 제공업체별 ID](https://code.claude.com/docs/ko/model-config.md#available-models)를 참조하세요 |
| `onElicitation` | `(request: ElicitationRequest, options: { signal: AbortSignal }) => Promise<ElicitationResult>` | `undefined` | MCP elicitation 요청을 처리하는 콜백입니다. MCP 서버가 사용자 입력을 요청하고 이를 먼저 처리하는 훅이 없을 때 호출됩니다. 제공되지 않으면 처리되지 않은 elicitation 요청은 자동으로 거부됩니다 |
| `outputFormat` | `{ type: 'json_schema', schema: JSONSchema }` | `undefined` | 에이전트 결과의 출력 형식을 정의합니다. 자세한 내용은 [구조화된 출력](https://code.claude.com/docs/ko/agent-sdk/structured-outputs.md)을 참조하세요 |
| `outputStyle` | `string` | `undefined` | `Options` 필드가 아닙니다. 대신 인라인 [`settings`](https://code.claude.com/docs/ko/settings) 객체나 설정 파일에서 `outputStyle`을 설정하세요. [출력 스타일 활성화](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#activate-an-output-style)를 참조하세요 |
| `pathToClaudeCodeExecutable` | `string` | 번들된 네이티브 바이너리에서 자동 확인 | Claude Code 실행 파일의 경로입니다. 설치 중 선택적 의존성을 건너뛰었거나 플랫폼이 지원 대상에 포함되지 않은 경우에만 필요합니다 |
| `permissionMode` | [`PermissionMode`](#permissionmode) | `undefined` | 세션의 권한 모드입니다. 이 옵션을 생략하고 [`permissions.defaultMode`](https://code.claude.com/docs/ko/settings-reference#permissions-defaultmode) 설정처럼 권한 모드를 설정하는 다른 요소가 없으면 세션은 `default`로 시작합니다. [권한 모드](https://code.claude.com/docs/ko/agent-sdk/permissions.md#permission-modes)를 참조하세요 |
| `permissionPromptToolName` | `string` | `undefined` | 권한 프롬프트용 MCP 도구 이름입니다 |
| `permissionPrompts` | `'host' \| 'none'` | `'host'` | 권한 프롬프트에 응답하는 주체입니다. `'host'`는 프롬프트를 [`canUseTool`](#canusetool) 콜백 또는 `permissionPromptToolName` 도구로 라우팅하고, `'none'`은 [프롬프트를 표시했을 호출을 거부합니다](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated). Claude Code v2.1.259 이상이 필요합니다 |
| `persistSession` | `boolean` | `true` | `false`이면 디스크에 세션을 저장하지 않습니다. 나중에 세션을 재개할 수 없습니다 |
| `planModeInstructions` | `string` | `undefined` | 플랜 모드용 사용자 지정 워크플로 지침입니다. `permissionMode`가 `'plan'`이면 이 문자열이 기본 플랜 모드 워크플로 본문을 대체합니다. CLI는 여전히 읽기 전용 적용 서문과 ExitPlanMode 프로토콜 꼬리말로 이를 감쌉니다 |
| `plugins` | [`SdkPluginConfig`](#sdkpluginconfig)`[]` | `[]` | 로컬 경로에서 사용자 지정 플러그인을 로드합니다. 자세한 내용은 [플러그인](https://code.claude.com/docs/ko/agent-sdk/plugins.md)을 참조하세요 |
| `projectConfigRoot` | `string` | `undefined` | `cwd`를 worktree로 두는 신뢰할 수 있는 체크아웃의 절대 경로입니다. Claude Code는 프로젝트 설정, `.mcp.json`, 프로젝트의 `.claude/` 명령, 에이전트, 스킬, 워크플로, 루틴, 출력 스타일을 `cwd` 대신 이 디렉터리에서 읽고, `CLAUDE_PROJECT_DIR`을 이 디렉터리로 설정합니다. 훅, `apiKeyHelper`와 같은 헬퍼 스크립트, stdio MCP 서버는 이 디렉터리를 작업 디렉터리로 하여 시작됩니다. `CLAUDE.md` 파일과 `.claude/rules/`는 여전히 `cwd`에서 로드됩니다. Claude Code v2.1.275 이상이 필요합니다 |
| `promptSuggestions` | `boolean` | `false` | 프롬프트 제안을 활성화합니다. 턴이 끝나면 Claude Code는 예측된 다음 사용자 프롬프트를 담은 `prompt_suggestion` 메시지를 내보냅니다. 계정이 사용 한도에 가까워졌거나 도달한 경우와 같이 일부 턴에서는 Claude Code가 제안을 생성하지 않습니다. [Claude Code가 제안을 건너뛰는 경우](https://code.claude.com/docs/ko/interactive-mode.md#when-claude-code-skips-suggestions)를 참조하세요 |
| `resume` | `string` | `undefined` | 재개할 세션 ID입니다 |
| `resumeDropsTurn` | `string` | `undefined` | `resumeSessionAt`과 함께 사용합니다. 잘라내는 재개가 버리려는 턴의 프롬프트 UUID입니다. 버려지는 범위에 흡수된 대기 메시지나 작업 알림처럼 해당 턴에 귀속되지 않는 항목이 포함되어 있으면 Claude Code는 재개를 거부하고, 거부 메시지에 `--resume-drops-turn` 플래그를 명시합니다. 이 쌍은 Agent SDK 및 print 모드 재개에서만 읽습니다. Claude Code v2.1.223 이상이 필요합니다 |
| `resumeSessionAt` | `string` | `undefined` | 특정 메시지 UUID에서 세션을 재개합니다 |
| `sandbox` | [`SandboxSettings`](#sandboxsettings) | `undefined` | 샌드박스 동작을 프로그래밍 방식으로 구성합니다. 자세한 내용은 [샌드박스 설정](#sandboxsettings)을 참조하세요 |
| `sessionId` | `string` | 자동 생성 | 자동 생성 대신 세션에 특정 UUID를 사용합니다 |
| `sessionStore` | [`SessionStore`](https://code.claude.com/docs/ko/agent-sdk/session-storage#the-sessionstore-interface) | `undefined` | 다른 호스트가 재개할 수 있도록 세션 트랜스크립트를 외부 백엔드에 미러링합니다. [외부 스토리지에 세션 유지](https://code.claude.com/docs/ko/agent-sdk/session-storage.md)를 참조하세요 |
| `sessionStoreFlush` | `'batched' \| 'eager'` | `'batched'` | *알파.* `sessionStore`의 플러시 모드입니다. `sessionStore`가 설정되지 않은 경우 무시됩니다 |
| `settings` | `string \| Settings` | `undefined` | 인라인 [설정](https://code.claude.com/docs/ko/settings.md) 객체, 설정 파일 경로 또는 인라인 JSON 문자열입니다. [우선순위](https://code.claude.com/docs/ko/settings.md#settings-precedence)의 플래그 설정 계층을 채웁니다. 런타임에는 [`applyFlagSettings()`](#applyflagsettings)로 변경합니다 |
| `settingSources` | [`SettingSource`](#settingsource)`[]` | CLI 기본값(모든 소스) | 로드할 파일 시스템 설정을 제어합니다. 사용자, 프로젝트, 로컬 설정을 비활성화하려면 `[]`를 전달하세요. [엔드포인트 관리형 정책](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms)은 이와 관계없이 로드되며, 서버 관리형 설정은 세션이 [적격 구성](https://code.claude.com/docs/ko/server-managed-settings.md#platform-availability)에서 조직 자격 증명으로 인증할 때 가져옵니다. [Claude Code 기능 사용](https://code.claude.com/docs/ko/agent-sdk/claude-code-features.md#what-settingsources-does-not-control)을 참조하세요 |
| `skills` | `string[] \| 'all'` | `undefined` | 세션에서 사용할 수 있는 스킬입니다. 발견된 모든 스킬을 활성화하려면 `'all'`을 전달하고, 그렇지 않으면 스킬 이름 목록을 전달하세요. 정확한 이름만 전달하세요. Agent SDK v0.3.221 이상에서는 SDK가 Claude Code 프로세스를 시작하기 전에 잘못된 형식 및 와일드카드 형식의 이름을 오류와 함께 거부합니다. 설정하면 SDK가 Skill 도구를 `allowedTools`에 자동으로 추가합니다. `tools`도 전달하는 경우 해당 목록에 `'Skill'`을 포함하세요. [스킬](https://code.claude.com/docs/ko/agent-sdk/skills.md)을 참조하세요 |
| `spawnClaudeCodeProcess` | `(options: SpawnOptions) => SpawnedProcess` | `undefined` | Claude Code 프로세스를 생성하는 사용자 지정 함수입니다. VM, 컨테이너 또는 원격 환경에서 Claude Code를 실행할 때 사용합니다 |
| `stderr` | `(data: string) => void` | `undefined` | stderr 출력용 콜백입니다 |
| `strictMcpConfig` | `boolean` | `false` | `mcpServers`로 전달된 서버만 사용하고 프로젝트 `.mcp.json`, 사용자 설정, 플러그인이 제공하는 MCP 서버, [claude.ai 커넥터](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai)를 무시합니다 |
| `systemPrompt` | `string \| string[] \| { type: 'custom'; prompt: string \| string[]; snapshot?: boolean } \| { type: 'preset'; preset: 'claude_code'; append?: string; excludeDynamicSections?: boolean; snapshot?: boolean }` | `undefined` (최소 프롬프트) | 시스템 프롬프트 구성입니다. 사용자 지정 프롬프트에는 문자열을 전달하고, Claude Code의 시스템 프롬프트를 사용하려면 `{ type: 'preset', preset: 'claude_code' }`를 전달하세요. [사용자 지정 프롬프트의 정적 부분을 캐시하려면](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#cache-the-static-part-of-a-custom-prompt) 정적 부분과 요청별 부분 사이에 내보낸 `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 상수를 둔 문자열 배열을 전달하세요. 프리셋 객체 형식을 사용할 때는 `append`를 추가하여 추가 지침으로 확장할 수 있으며, `excludeDynamicSections: true`를 설정하면 세션별 컨텍스트를 첫 번째 사용자 메시지로 옮겨 [머신 간 프롬프트 캐시 재사용을 개선](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#improve-prompt-caching-across-users-and-machines)할 수 있습니다. [세션이 첫 요청에서 기록한 프롬프트를 재사용하는](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#change-the-prompt-of-an-existing-session) 대신 모든 요청에서 프롬프트를 다시 빌드하려면 `snapshot: false`를 설정하세요. 사용자 지정 프롬프트에 `snapshot`을 설정하려면 `{ type: 'custom', prompt }` 형식을 전달하세요. `{ type: 'custom' }` 형식과 `snapshot` 필드에는 TypeScript Agent SDK v0.3.257 이상이 필요합니다 |
| `taskBudget` | `{ total: number }` | `undefined` | *알파.* 토큰 단위의 API 측 작업 예산입니다. 설정하면 모델에 남은 토큰 예산이 전달되어, 모델이 도구 사용 속도를 조절하고 한도에 도달하기 전에 작업을 마무리할 수 있습니다 |
| `thinking` | [`ThinkingConfig`](#thinkingconfig) | 지원되는 모델의 경우 `{ type: 'adaptive' }` | Claude의 사고/추론 동작을 제어합니다. 옵션은 [`ThinkingConfig`](#thinkingconfig)를 참조하세요 |
| `title` | `string` | `undefined` | 세션의 표시 제목입니다. `resume` 또는 `continue`로 재개할 때는 재개된 세션에 저장된 제목이 우선합니다. 기존 세션의 제목을 바꾸려면 [`renameSession()`](#renamesession)을 사용하세요 |
| `toolAliases` | `Record<string, string>` | `undefined` | Claude가 기본 제공 도구 대신 사용자의 MCP 구현을 호출하도록 기본 제공 도구 이름을 MCP 도구 이름에 매핑합니다. 예: `{ Bash: 'mcp__workspace__bash' }` |
| `toolConfig` | [`ToolConfig`](#toolconfig) | `undefined` | 기본 제공 도구 동작에 대한 구성입니다. 자세한 내용은 [`ToolConfig`](#toolconfig)를 참조하세요 |
| `tools` | `string[] \| { type: 'preset'; preset: 'claude_code' }` | `undefined` | 도구 구성입니다. 도구 이름 배열을 전달하거나, 프리셋을 사용하여 Claude Code의 기본 도구를 가져옵니다 |
| `verbatimPrompts` | `boolean` | `false` | 모든 프롬프트를 작성된 그대로 전달합니다. SDK는 각 사용자 메시지를 `client_composed: true`와 함께 보냅니다. 해당 메시지에서 Claude Code가 건너뛰는 항목은 [`client_composed`](#sdkusermessage)를 참조하세요. 프롬프트 텍스트에 최종 사용자가 입력하지 않은 콘텐츠가 포함된 경우 이 옵션을 사용하세요. 턴별로 제어하려면 이 옵션을 끈 상태로 두고 대신 개별 스트리밍 메시지에 `client_composed`를 설정하세요. TypeScript Agent SDK v0.3.280 이상 및 Claude Code v2.1.248 이상이 필요하며, 해당 SDK 버전에 번들된 Claude Code 버전은 Claude Code 요구 사항을 충족합니다 |

#### 느리거나 멈춘 API 응답 처리

CLI 하위 프로세스는 API 타임아웃과 멈춤 감지를 제어하는 여러 환경 변수를 읽습니다. 이 변수들을 `env` 옵션으로 전달하세요.

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

const result = query({
  prompt: "Analyze this code",
  options: {
    env: {
      ...process.env,
      API_TIMEOUT_MS: "120000",
      CLAUDE_CODE_MAX_RETRIES: "2",
      CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS: "120000",
    },
  },
});
```

* [`API_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars): 각 요청 시도가 응답 헤더를 기다릴 수 있는 시간(밀리초)입니다. 헤더가 도착한 후 스트리밍 응답이 실행되는 시간은 제한하지 않습니다. 기본값은 `600000`입니다. 메인 루프와 모든 서브에이전트에 적용됩니다.
* `CLAUDE_CODE_MAX_RETRIES`: 최대 API 재시도 횟수입니다. 기본값은 `10`이며 상한은 `15`입니다. 각 재시도는 자체 `API_TIMEOUT_MS` 시간 범위를 가집니다.

  더 긴 장애를 기다려야 하는 무인 실행의 경우 [`CLAUDE_CODE_RETRY_WATCHDOG=1`](https://code.claude.com/docs/ko/errors#tune-retry-behavior)을 설정하세요. 이 설정은 일시적인 용량 오류를 무기한 재시도하며, Claude Code v2.1.199 이상에서는 다른 일시적 오류에 대한 기본값을 `300`으로 올리고 이 변수의 상한을 제거합니다.
* `CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS`: 서브에이전트용 멈춤 감시기입니다. 스트림 감시기가 켜져 있는 동안 기본값은 `CLAUDE_STREAM_IDLE_TIMEOUT_MS`에 5분을 더한 값이며, 해당 변수를 높이지 않는 한 `600000`이 됩니다. 스트림 감시기가 꺼져 있으면 기본값은 `600000`입니다. v2.1.257 이전에는 기본값이 항상 `600000`이었습니다.

  타이머는 스트림 이벤트마다 재설정됩니다. 멈춤이 발생하면 Claude Code는 서브에이전트를 중단하고 상위 에이전트에 멈춤을 보고합니다. 백그라운드 서브에이전트의 경우 작업을 실패로 표시하고 부분 결과가 있으면 함께 첨부합니다.
* `CLAUDE_ENABLE_STREAM_WATCHDOG`과 `CLAUDE_STREAM_IDLE_TIMEOUT_MS`: 헤더는 도착했지만 응답 본문 스트리밍이 멈췄을 때 요청을 중단하는 스트림 감시기입니다. 감시기는 모든 제공업체에서 기본적으로 켜져 있으며, 비활성화하려면 `CLAUDE_ENABLE_STREAM_WATCHDOG=0`을 설정하세요. `CLAUDE_STREAM_IDLE_TIMEOUT_MS`의 기본값은 `300000`이며 이 값보다 작게 설정할 수 없습니다. 중단 후 Claude Code가 응답 진행 정도에 따라 수행하는 작업은 [자동 재시도](https://code.claude.com/docs/ko/errors.md#automatic-retries)에서 다룹니다.

  `ANTHROPIC_BASE_URL` 뒤의 게이트웨이가 keep-alive ping으로 열어 둔 응답을 감시기가 기다리는 동안, `includePartialMessages`를 설정한 호스트는 `ping` [스트림 이벤트](#sdkpartialassistantmessage)를 계속 수신합니다. 따라서 응답이 없다고 세션을 타임아웃 처리하지 말고 이러한 프레임을 활성 상태 신호로 읽으세요. v2.1.257 이전에는 마지막 실제 스트림 이벤트 후 5분이 지나면 프레임이 중단되었습니다.

### `Query` 객체

`query()` 함수가 반환하는 인터페이스입니다.

```typescript theme={null}
interface Query extends AsyncGenerator<SDKMessage, void> {
  interrupt(): Promise<SDKControlInterruptResponse | undefined>;
  rewindFiles(
    userMessageId: string,
    options?: { dryRun?: boolean }
  ): Promise<RewindFilesResult>;
  setPermissionMode(mode: PermissionMode): Promise<void>;
  setModel(model?: string): Promise<void>;
  setMaxThinkingTokens(maxThinkingTokens: number | null): Promise<void>;
  applyFlagSettings(settings: {
    [K in keyof Settings]?: K extends 'effortLevel'
      ? 'low' | 'medium' | 'high' | 'xhigh' | 'max' | null
      : Settings[K] | null;
  }): Promise<void>;
  updateSettings(
    source: 'localSettings' | 'userSettings',
    settings: Record<string, unknown>,
  ): Promise<void>;
  initializationResult(): Promise<SDKControlInitializeResponse>;
  reinitialize(): Promise<SDKControlInitializeResponse>;
  supportedCommands(): Promise<SlashCommand[]>;
  supportedModels(): Promise<ModelInfo[]>;
  supportedAgents(): Promise<AgentInfo[]>;
  mcpServerStatus(): Promise<McpServerStatus[]>;
  getContextUsage(opts?: {
    detail?: 'summary' | 'full';
  }): Promise<SDKControlGetContextUsageResponse>;
  readFile(
    path: string,
    options?: { maxBytes?: number; encoding?: 'utf-8' | 'base64' }
  ): Promise<SDKControlReadFileResponse | null>;
  reloadPlugins(options?: {
    holdOnCacheImpact?: boolean;
    addPlugins?: SdkPluginConfig[];
  }): Promise<SDKControlReloadPluginsResponse>;
  reloadSkills(): Promise<SDKControlReloadSkillsResponse>;
  reloadOutputStyles(): Promise<SDKControlReloadOutputStylesResponse>;
  seedReadState(path: string, mtime: number): Promise<void>;
  accountInfo(): Promise<AccountInfo>;
  reconnectMcpServer(serverName: string): Promise<void>;
  toggleMcpServer(serverName: string, enabled: boolean): Promise<void>;
  setMcpServers(servers: Record<string, McpServerConfig>): Promise<McpSetServersResult>;
  setMcpPermissionModeOverride(
    serverName: string,
    mode: 'default' | 'auto' | null
  ): Promise<{ warning?: string }>;
  readMcpResource(serverName: string, uri: string): Promise<SDKControlMcpReadResourceResponse>;
  streamInput(stream: AsyncIterable<SDKUserMessage>): Promise<void>;
  stopTask(taskId: string): Promise<void>;
  backgroundTasks(toolUseId?: string): Promise<boolean>;
  close(): void;
}
```

#### 메서드

| 메서드 | 설명 |
| :- | :- |
| `interrupt()` | 쿼리를 중단합니다. 스트리밍 입력 모드에서만 사용할 수 있습니다. CLI가 [`SDKSystemMessage.capabilities`](#sdksystemmessage)에서 `interrupt_receipt_v1` 기능을 알리는 경우, 중단 시점에 대기 중이던 메시지를 나열하는 [`SDKControlInterruptResponse`](#sdkcontrolinterruptresponse)로 resolve됩니다. v2.1.205 이전 CLI에서는 `undefined`로 resolve됩니다 |
| `rewindFiles(userMessageId, options?)` | 지정된 사용자 메시지 시점의 상태로 파일을 복원합니다. 변경 사항을 미리 보려면 `{ dryRun: true }`를 전달하세요. `enableFileCheckpointing: true`가 필요합니다. [파일 체크포인트](https://code.claude.com/docs/ko/agent-sdk/file-checkpointing.md)를 참조하세요 |
| `setPermissionMode()` | 권한 모드를 변경합니다(스트리밍 입력 모드에서만 사용 가능) |
| `setModel()` | 모델을 변경합니다(스트리밍 입력 모드에서만 사용 가능). `undefined` 또는 문자열 `"default"`를 전달하면 [Claude Code의 기본 모델](https://code.claude.com/docs/ko/model-config.md)로 초기화됩니다. 새 모델이 자동 모드를 지원하지 않으면 `auto` 모드의 세션은 [`default` 모드로 변경](https://code.claude.com/docs/ko/agent-sdk/permissions#auto-mode-auto)됩니다 |
| `setMaxThinkingTokens()` | *지원 중단:* 대신 `thinking` 옵션을 사용하세요. 최대 사고 토큰 수를 변경합니다. `null`을 전달하면 사고가 세션 기본값으로 재설정됩니다. 세션 중 재정의는 지워지며, 사고가 비활성화된 세션에서는 계속 꺼진 상태로 유지됩니다 |
| `applyFlagSettings(settings)` | 런타임에 세션의 플래그 설정 계층에 설정을 병합합니다(스트리밍 입력 모드에서만 사용 가능). [`applyFlagSettings()`](#applyflagsettings)를 참조하세요 |
| `updateSettings(source, settings)` | 허용 목록에 있는 키 하나를 프로젝트의 로컬 설정 파일 또는 사용자 설정 파일에 기록하여, 이후 세션에서도 값이 유지되도록 합니다. [`updateSettings()`](#updatesettings)를 참조하세요. Claude Code v2.1.257이 번들된 TypeScript SDK v0.3.257 이상이 필요합니다 |
| `initializationResult()` | 지원되는 명령, 모델, 계정 정보, 출력 스타일 구성을 포함한 전체 초기화 결과를 반환합니다 |
| `reinitialize()` | 실행 중인 CLI에 `initialize` 제어 요청을 다시 보내고, 캐시된 첫 연결 결과 대신 새 결과를 반환합니다. 연결이 끊긴 후 세션에 다시 연결하는 경우와 같이 전송 공백이 발생한 후에 사용하면, 대기 중인 권한 요청이 `canUseTool` 콜백에 다시 전달됩니다. 응답이 유실된 요청은 다시 전달되므로 콜백을 요청 ID별로 멱등하게 만드세요. Claude Code v2.1.195 이상이 필요합니다 |
| `supportedCommands()` | 사용 가능한 명령을 반환합니다. Agent SDK v0.3.216부터 이 목록에는 세션 중 명령 변경 사항이 반영됩니다. [`SDKCommandsChangedMessage`](#sdkcommandschangedmessage)를 참조하세요 |
| `supportedModels()` | 표시 정보와 함께 사용 가능한 모델을 반환합니다 |
| `supportedAgents()` | 사용 가능한 서브에이전트를 [`AgentInfo`](#agentinfo)`[]`로 반환합니다 |
| `mcpServerStatus()` | 연결된 MCP 서버의 상태를 [`McpServerStatus`](#mcpserverstatus)`[]`로 반환합니다 |
| `getContextUsage(opts?)` | 세션의 컨텍스트 윈도우 사용량을 카테고리, 스킬, 도구별로 분류한 [`SDKControlGetContextUsageResponse`](#sdkcontrolgetcontextusageresponse)를 반환합니다. 기본 `detail`에서는 대화형 세션에서 `/context`가 보여 주는 데이터를 포함하며, 메시지 스트림에 나타나지 않는 토큰 계산 API 요청으로 계산됩니다. [이러한 요청이 처리되는 방식](#sdkcontrolgetcontextusageresponse)을 참조하세요. [`detail` 옵션](#sdkcontrolgetcontextusageresponse)에는 Agent SDK v0.3.257 이상이 필요합니다 |
| `readFile(path, options?)` | 세션의 파일 시스템에서 파일을 읽습니다. Claude Code는 `cwd`를 기준으로 경로를 확인하며, 제공하는 파일은 [`readFile()`이 읽을 수 있는 파일](#what-readfile-can-read)에 나열되어 있습니다. 읽기 상한을 변경하려면 `{ maxBytes }`를 전달하고(기본값 1 MB, 최대 10 MB), 이미지와 같은 바이너리 파일에는 `{ encoding: 'base64' }`를 전달하세요. [`SDKControlReadFileResponse`](#sdkcontrolreadfileresponse)로 resolve되며, 권한 거부, 파일 없음 또는 전송 오류 시에는 `null`로 resolve됩니다. TypeScript SDK v0.2.121 이상이 필요합니다 |
| `reloadPlugins(options?)` | 디스크에서 플러그인을 다시 로드하여 세션 중에 설치하거나 편집한 플러그인이 실행 중인 세션에 반영되도록 합니다. 세션의 명령, 서브에이전트, 플러그인, MCP 서버 상태를 나열하는 [`SDKControlReloadPluginsResponse`](#sdkcontrolreloadpluginsresponse)로 확인됩니다. Agent SDK v0.2.85 이상이 필요합니다. [`holdOnCacheImpact` 옵션](#sdkcontrolreloadpluginsresponse)에는 Agent SDK v0.3.268 이상이 필요합니다. [`addPlugins` 옵션](#load-more-plugin-folders-with-addplugins)에는 Agent SDK v0.3.301 이상이 필요합니다 |
| `reloadSkills()` | 디스크에서 스킬을 다시 로드하여, 세션 중에 추가하거나 편집한 스킬을 실행 중인 세션에서 사용할 수 있게 합니다. 다시 로드한 후 사용 가능한 스킬을 나열하는 [`SDKControlReloadSkillsResponse`](#sdkcontrolreloadskillsresponse)로 resolve됩니다. Agent SDK v0.3.163 이상이 필요합니다 |
| `reloadOutputStyles()` | 디스크에서 [출력 스타일](https://code.claude.com/docs/ko/output-styles.md)을 다시 읽어, 세션 중에 추가하거나 편집한 스타일 파일을 실행 중인 세션에서 사용할 수 있게 합니다. 다시 로드한 후 사용 가능한 스타일 이름을 나열하는 [`SDKControlReloadOutputStylesResponse`](#sdkcontrolreloadoutputstylesresponse)로 resolve됩니다. Agent SDK v0.3.261 이상이 필요합니다 |
| `seedReadState(path, mtime)` | 파일을 이미 읽은 것으로 표시하여 이후 Edit가 `File has not been read yet`으로 실패하지 않도록 합니다. [`seedReadState()`](#seedreadstate)를 참조하세요. TypeScript SDK v0.2.83 이상이 필요합니다 |
| `accountInfo()` | 계정 정보를 반환합니다 |
| `reconnectMcpServer(serverName)` | 이름으로 MCP 서버에 다시 연결합니다. 이름이 `.mcp.json` 또는 `~/.claude.json`과 같은 설정 파일의 항목과도 일치하는 경우, Claude Code는 설정 파일 항목이 아니라 [`mcpServers`](#options) 또는 `setMcpServers()`로 구성한 서버에 다시 연결합니다. 이 확인 순서에는 Claude Code v2.1.257 이상이 필요합니다 |
| `toggleMcpServer(serverName, enabled)` | `reconnectMcpServer()`와 동일한 이름 확인 방식으로 이름을 통해 MCP 서버를 활성화하거나 비활성화합니다. 서버를 비활성화하면 연결이 끊기고 해당 도구가 제거됩니다. 서버 종류별로 필요한 Claude Code 버전은 [`toggleMcpServer()`](#togglemcpserver)를 참조하세요 |
| `setMcpServers(servers)` | 이 메서드가 관리하는 MCP 서버, 즉 이 메서드로 추가한 서버와 [프로세스 내 SDK 서버](#createsdkmcpserver)를 교체합니다. 추가 및 제거된 서버와 오류를 알려 주는 [`McpSetServersResult`](#mcpsetserversresult)로 resolve되며, 다른 어떤 서버가 연결 상태로 유지되는지는 해당 섹션에서 설명합니다 |
| `setMcpPermissionModeOverride(serverName, mode)` | 한 MCP 서버 도구의 권한 모드를 세션보다 엄격한 모드로 재정의하거나, `null`로 재정의를 지웁니다. 스트리밍 입력 모드에서만 사용할 수 있습니다. [`setMcpPermissionModeOverride()`](#setmcppermissionmodeoverride)를 참조하세요. TypeScript SDK v0.3.187 이상이 필요합니다 |
| `readMcpResource(serverName, uri)` | *알파.* 애플리케이션이 도구의 위젯을 렌더링할 수 있도록 연결된 MCP 서버에서 MCP Apps `ui://` 리소스 하나를 읽습니다. [`SDKControlMcpReadResourceResponse`](#sdkcontrolmcpreadresourceresponse)로 resolve됩니다. TypeScript Agent SDK v0.3.280 이상이 필요합니다 |
| `streamInput(stream)` | 멀티턴 대화를 위해 입력 메시지를 쿼리로 스트리밍합니다 |
| `stopTask(taskId)` | ID로 실행 중인 백그라운드 작업을 중지합니다 |
| `backgroundTasks(toolUseId?)` | 턴이 기다리고 있는 실행 중인 Bash 명령과 서브에이전트를 백그라운드로 이동합니다. 대화형 터미널에서 Ctrl+B를 누르는 것과 같습니다. [`backgroundTasks()`](#backgroundtasks)를 참조하세요. TypeScript SDK v0.2.139 이상이 필요합니다 |
| `close()` | 쿼리를 닫고 기본 프로세스를 종료합니다. 쿼리를 강제로 종료하고 모든 리소스를 정리합니다 |

#### `setMcpPermissionModeOverride()`

한 MCP 서버 도구의 권한 모드를 세션보다 엄격한 모드로 재정의하거나, `null`로 재정의를 지웁니다. 세션이 작업별 프롬프트를 건너뛰는 모드로 실행되지만 특정 서버의 도구는 여전히 검토해야 할 때 사용합니다. TypeScript SDK v0.3.187 이상이 필요합니다.

`mode`로 다음 세 가지 값 중 하나를 전달합니다.

* `'default'`: Claude Code는 해당 서버의 도구 호출을 [수동 모드](https://code.claude.com/docs/ko/permission-modes.md#available-modes)와 같은 방식으로 평가합니다.
* `'auto'`: Claude Code는 해당 서버의 도구 호출을 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) 분류기로 라우팅합니다. 세션에서 분류기를 사용할 수 없으면 Claude Code는 이 값을 거부합니다.
* `null`: 재정의를 지웁니다.

재정의는 세션이 작업별 프롬프트를 건너뛰는 모드인 `bypassPermissions` 또는 `auto`에 있는 동안에만 적용됩니다. 다른 세션 모드에서는 Claude Code가 재정의를 무시하므로, 재정의가 세션이 허용하는 범위를 넓히는 일은 없습니다.

해당 이름의 서버가 아직 알려지지 않은 경우 promise는 `{ warning }`으로 완료됩니다. Claude Code는 재정의를 그대로 저장하고, 정확히 그 이름을 가진 서버가 연결되면 적용하므로, 이 경고는 실패가 아니라 오타 확인용입니다.

`setModel()` 및 `setPermissionMode()`와 마찬가지로 스트리밍 입력 모드에서만 사용할 수 있습니다.

#### `seedReadState()`

파일을 이미 읽은 것으로 표시하여 이후 Edit가 `File has not been read yet`으로 실패하지 않도록 합니다. 애플리케이션이 대화 컨텍스트에서 이전 `Read` 결과를 제거했고 Claude가 다음에 해당 파일을 편집할 때 사용합니다. TypeScript SDK v0.2.83 이상이 필요합니다.

`mtime`에는 이전에 읽은 시점의 파일 수정 시간을 epoch 이후 정수 밀리초로 전달합니다(예: `Math.floor(stat.mtimeMs)`). 디스크의 파일이 그 시간 이후에 변경되었다면 Claude Code는 표시를 건너뜁니다.

promise는 파일이 표시되었는지 여부와 관계없이 완료되므로, promise가 완료되었다고 해서 어느 쪽이 일어났는지 알 수는 없습니다.

#### `backgroundTasks()`

턴이 기다리고 있는 실행 중인 Bash 명령과 서브에이전트를 백그라운드로 이동합니다. 대화형 터미널에서 Ctrl+B를 누르는 것과 같습니다. 특정 도구 호출이 시작한 Bash 명령이나 서브에이전트만 백그라운드로 보내려면 해당 도구 호출의 `toolUseId`를 전달하고, 모든 포그라운드 작업을 백그라운드로 보내려면 생략하세요. TypeScript SDK v0.2.139 이상이 필요합니다.

백그라운드로 보내진 각 도구 호출은 백그라운드에서 실행 중이라는 결과와 함께 즉시 Claude에 반환되고, 턴은 계속 진행되며, 작업이 완료되면 Claude Code가 [`SDKTaskNotificationMessage`](#sdktasknotificationmessage)를 내보냅니다.

백그라운드 작업이 활성화된 세션에서 promise는 boolean으로 완료됩니다.

* **`true`**: 작업이 백그라운드로 보내졌거나, `toolUseId`를 생략했습니다.
* **`false`**: 전달한 `toolUseId`와 일치하는 포그라운드 작업이 없습니다.

[`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`](https://code.claude.com/docs/ko/env-vars) 등으로 세션에서 백그라운드 작업이 비활성화된 경우에는 promise가 대신 거부되며 아무것도 백그라운드로 보내지지 않습니다.

#### `applyFlagSettings()`

쿼리를 다시 시작하지 않고 실행 중인 세션의 [설정](https://code.claude.com/docs/ko/settings.md)을 변경합니다. 에이전트가 신뢰할 수 없는 입력을 읽은 후 `permissions`를 강화하는 경우처럼, 전용 setter가 없는 설정을 세션 중에 변경해야 할 때 사용하세요. `setModel()`과 `setPermissionMode()`는 해당 두 키의 전용 setter이며, `applyFlagSettings()`는 설정 키의 어떤 하위 집합이든 허용하는 일반 형식입니다. 여기에 `model`을 전달하면 `setModel()`과 동일하게 동작합니다.

일부 키만 세션 중에 적용됩니다.

* **다음 턴에 적용**: `ultracode`, `permissions`, `hooks`, `skillOverrides`, `fastMode`, `agent`. `agent`를 전환하면 해당 에이전트의 모델 재정의와 훅도 다음 턴에 적용됩니다. 에이전트의 시스템 프롬프트는 다음 턴에 적용됩니다. [기록된 시스템 프롬프트를 재사용](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#change-the-prompt-of-an-existing-session)하는 세션에서는 세션이 압축된 후에 적용됩니다.
* **현재 턴 중에 적용**: `model`. Claude가 턴을 처리하는 동안 `model`을 전환하면, Claude가 이미 생성 중인 응답은 이전 모델로 완료되고, Claude Code가 모델에 보내는 다음 호출부터 턴의 나머지 부분은 새 모델을 사용합니다. 서브에이전트는 자체 모델을 유지합니다. v2.1.212 이전에는 턴 중간의 전환이 다음 턴까지 대기했습니다.
* **다음 턴까지 적용**: `effortLevel`. 수준은 Claude Code가 모델에 보내는 다음 호출부터 적용됩니다. API 키나 Claude 구독을 사용하는 Claude Opus 5.5처럼 [effort 변경 시 프롬프트 캐시가 유지되는](https://code.claude.com/docs/ko/prompt-caching.md#changing-effort-level) 경우에는 다음 턴에 적용된다고 예상하세요.
* **세션 중에는 효과 없음**: 시스템 프롬프트 옵션. 이 옵션은 시작 시 한 번만 확인되므로, 호출이 성공하더라도 실행 중인 세션은 원래 값을 유지합니다. 변경하려면 새 세션을 시작하세요.

`effortLevel`은 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level) 이름을 허용합니다. 또한 `"ultracode"`도 허용하는데, 이는 [ultracode](https://code.claude.com/docs/ko/workflows.md#let-claude-decide-with-ultracode)를 켠 상태에서 `xhigh` effort를 요청합니다. `applyFlagSettings()`는 이 값 없이 `effortLevel`을 선언하므로, TypeScript에서 동일한 결과를 얻으려면 `{ ultracode: true, effortLevel: "xhigh" }`를 전달하거나, 세션의 현재 effort 수준에서 ultracode를 켜려면 [`ultracode`](https://code.claude.com/docs/ko/settings-reference#ultracode) 키만 전달하세요. `ultracode` 값에는 Claude Code v2.1.203 이상이 필요하며, 설정 파일의 `effortLevel` 키가 아닌 `applyFlagSettings()`에서만 허용됩니다. v2.1.284 이전에는 `ultracode` 키만 전달해도 수준이 `xhigh`로 설정되었습니다.

값은 플래그 설정 계층에 기록되며, 시작 시 `query()`의 인라인 `settings` 옵션이 설정한 값 위에 병합됩니다. 이는 [페이지 내 우선순위 섹션](#settings-precedence)에서 프로그래밍 방식 옵션이라고 부르는 것과 같은 계층입니다. `effortLevel`은 예외입니다. [effort 해석 순서](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)에서 보듯이, 전달한 수준은 관리형 설정을 포함해 `--effort`나 설정에서 지정한 수준을 대체합니다.

연속 호출은 최상위 키를 얕게 병합합니다. `{ permissions: {...} }`로 두 번째 호출을 하면 이전 호출의 `permissions` 객체에 깊게 병합되지 않고 전체 객체가 대체됩니다.

`applyFlagSettings()`로 설정한 키를 지우려면 해당 키에 `null`을 전달하세요. 그러면 대부분의 키는 먼저 시작 시 `query()`의 `settings` 옵션이 설정한 값으로 폴백하고, 그다음 우선순위가 더 낮은 소스로 폴백합니다. 지워진 `model`은 설정 파일이 `model`을 설정하더라도 [Claude Code의 기본 모델](https://code.claude.com/docs/ko/model-config.md)로 재설정됩니다. `undefined`를 전달하면 JSON 직렬화 시 삭제되므로 효과가 없습니다.

`model` 외에 세 개의 키는 폴백하는 대신 세션 상태를 재설정합니다.

* `effortLevel: null`은 `query()`의 `effort` 옵션이나 설정 파일의 `effortLevel`이 아닌, 모델의 기본 effort 수준으로 세션을 되돌립니다.
* `agent: null`은 `query()`의 `agent` 옵션이나 설정 파일의 `agent`를 복원하는 대신, 다음 턴부터 에이전트 없이 메인 스레드를 실행합니다. 지워진 에이전트가 자체 모델을 적용했었다면 세션은 시작 시 확인된 모델로 돌아갑니다.
* `ultracode: null`은 설정 파일의 `ultracode` 값을 복원하는 대신 `false`와 마찬가지로 ultracode를 끕니다. 세션은 현재 effort 수준을 유지하므로, 변경하려면 같은 호출에서 `effortLevel`을 전달하세요.

`setModel()` 및 `setPermissionMode()`와 동일한 제약으로, 스트리밍 입력 모드에서만 사용할 수 있습니다.

아래 예시는 세션 중에 활성 모델을 전환한 다음, 재정의를 지워 모델을 [Claude Code의 기본 모델](https://code.claude.com/docs/ko/model-config.md)로 재설정합니다.

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

const q = query({ prompt: messageStream });

// Override the model for the rest of the session
await q.applyFlagSettings({ model: "claude-opus-4-6" });

// Later: clear the override; the model resets to Claude Code's default
await q.applyFlagSettings({ model: null });
```

> [!NOTE]
>
> `applyFlagSettings()`는 TypeScript 전용입니다. Python SDK에는 이에 해당하는 메서드가 없습니다.

#### `updateSettings()`

허용 목록에 있는 키 하나를 디스크의 설정 파일에 기록하여, 해당 소스를 로드하는 이후 세션에서도 값이 유지되도록 합니다. 각 소스는 문자열 값을 가진 키 하나를 허용합니다.

* **`"localSettings"`**: `outputStyle`을 허용하며, 이를 프로젝트의 로컬 설정 파일인 `.claude/settings.local.json`에 병합합니다. 새 스타일은 세션의 다음 요청부터 적용됩니다.
* **`"userSettings"`**: `effortLevel`을 허용하며, 이를 사용자 설정 파일의 [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings) 아래에 세션의 현재 모델에 대한 기본 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)으로 저장합니다. `max`는 세션 전용이므로 `max`를 전달하면 아무것도 기록되지 않습니다. 어느 경우든 실행 중인 세션은 현재 effort 수준을 유지하므로, 이것도 변경하려면 [`applyFlagSettings()`](#applyflagsettings)를 호출하세요. 이 소스에는 Claude Code v2.1.277이 번들된 TypeScript SDK v0.3.277 이상이 필요합니다.

요청에 다른 키가 포함된 경우, 세션이 원격 전송을 통해 실행되는 경우, 세션의 [`settingSources`](#options)가 지정한 소스를 제외하는 경우에는 호출이 거부됩니다. 키 삭제는 지원되지 않습니다.

#### `toggleMcpServer()`

서버를 비활성화하면 연결이 끊기고 해당 도구가 세션에서 제거됩니다. 세션 중에 추가한 서버와 프로세스 내 서버의 경우, 이는 Claude Code 버전에 따라 달라집니다.

* 세션 중에 `setMcpServers()`로 추가한 stdio, SSE 또는 HTTP 서버: 해당 도구를 제거하려면 Claude Code v2.1.285 이상이 필요합니다.
* [`createSdkMcpServer()`](#createsdkmcpserver)로 생성한 프로세스 내 서버(`mcpServers`로 전달했든 `setMcpServers()`로 전달했든): 연결을 끊고 해당 도구를 제거하려면 Claude Code v2.1.286 이상이 필요합니다. 이러한 서버를 비활성화하면 아직 실행 중인 해당 서버의 도구 호출도 실패 처리되므로, Claude는 핸들러가 반환될 때까지 기다리지 않고 각 호출에 대한 오류 결과를 즉시 받습니다.

### `WarmQuery`

[`startup()`](#startup)이 반환하는 핸들입니다. 하위 프로세스가 이미 생성되고 초기화되어 있으므로, 이 핸들에서 `query()`를 호출하면 시작 지연 없이 준비된 프로세스에 프롬프트를 직접 기록합니다.

```typescript theme={null}
interface WarmQuery extends AsyncDisposable {
  query(prompt: string | AsyncIterable<SDKUserMessage>): Query;
  close(): void;
}
```

#### 메서드

| 메서드 | 설명 |
| :- | :- |
| `query(prompt)` | 미리 준비된 하위 프로세스에 프롬프트를 보내고 [`Query`](#query-object)를 반환합니다. `WarmQuery`당 한 번만 호출할 수 있습니다 |
| `close()` | 프롬프트를 보내지 않고 하위 프로세스를 닫습니다. 더 이상 필요하지 않은 웜 쿼리를 폐기할 때 사용합니다 |

`WarmQuery`는 `AsyncDisposable`을 구현하므로, 자동 정리를 위해 `await using`과 함께 사용할 수 있습니다.

### `SpareProcess`

*알파.* [`prewarm()`](#prewarm)이 반환하는 핸들로, 아직 세션에 바인딩되지 않았으며 한 번 claim할 수 있는 시작된 Claude Code 프로세스입니다. TypeScript Agent SDK v0.3.282 이상이 필요합니다.

```typescript theme={null}
interface SpareProcess extends AsyncDisposable {
  claim(params: {
    prompt: string | AsyncIterable<SDKUserMessage>;
    options: ClaimOptions;
  }): Query;
  readonly claimed: Promise<{ cwd: string; sessionId: string; parkedMs?: number; sdkMcpSettled: boolean }>;
  readonly exited: Promise<void>;
  close(): void;
}
```

#### 멤버

| 멤버 | 설명 |
| :- | :- |
| `claim({ prompt, options })` | 예비 프로세스를 `options.cwd`의 세션에 바인딩하고 첫 번째 메시지를 보냅니다. `query()`와 마찬가지로 [`Query`](#query-object)를 동기적으로 반환합니다. 한 번만 호출할 수 있습니다 |
| `claimed` | Claude Code가 claim을 수락하면 세션의 작업 디렉터리와 ID로 resolve됩니다. Claude Code가 claim을 거부하는 경우, 프로세스가 먼저 종료되었거나 닫힌 경우에 reject되며, 요청한 `model` 또는 `maxThinkingTokens` 없이 세션이 실행되는 경우에는 `option_not_applied`로 시작하는 메시지와 함께 reject됩니다 |
| `exited` | claim 여부와 관계없이 프로세스가 종료되면 settle됩니다. claim하기 전에 종료된 예비 프로세스는 교체하세요 |
| `close()` | 프로세스를 종료합니다. claim 전에 호출하면 예비 프로세스를 폐기하고 `claimed`를 reject합니다 |

`options.cwd`는 필수입니다. claim에서는 `additionalDirectories`, `model`, `permissionMode`, `maxThinkingTokens`, `settings`의 플래그 설정 오버레이, `appendSystemPrompt`, `title`, `agents`, `env`의 세션별 토큰도 설정할 수 있습니다.

Claude Code는 존재하지 않는 폴더나 프로젝트 설정에서 `env`, `agent` 또는 `model`을 설정하는 폴더 등에 대해 claim을 거부할 수 있습니다. 거부된 후에는 `claim()`이 이미 보낸 프롬프트가 `not_claimed`로 시작하는 텍스트의 오류 결과를 받고, 반환된 쿼리는 예외를 던집니다. 예외 이후에도 계속 진행하려면 쿼리 루프를 try 블록으로 감싸세요. `claimed`가 `option_not_applied`로 시작하는 메시지와 함께 reject되면, 세션은 요청한 `model` 또는 `maxThinkingTokens` 없이 실행 중인 것입니다. 그 외의 reject 후에는 프롬프트가 실행되지 않았으므로, 대신 `query()`로 세션을 시작하세요.

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
  fast_mode_disabled_reason?: FastModeDisabledReason;
  hooks_applied?: boolean;
  sdk_mcp_manifests_parked?: Record<
    string,
    | "parked"
    | "already_connected"
    | "protocol_version_mismatch"
    | "malformed"
    | "not_honoured"
  >;
  claude_code_version?: string;
};
```

`hooks_applied`는 `initialize` 요청에 포함된 `hooks`를 Claude Code가 등록했는지 여부를 보고합니다. SDK는 세션이 시작될 때 이 요청을 한 번 보내고, [`reinitialize()`](#query-object)를 호출할 때마다 다시 보냅니다. 이 필드에는 Agent SDK v0.3.238 이상이 필요합니다.

요청에 훅이 포함되지 않은 경우 Claude Code는 이 필드를 생략합니다. 요청에 훅이 포함된 경우, 값은 해당 요청이 세션의 첫 번째 initialize인지, 그리고 반복된 요청이라면 어떤 경로로 세션에 도달했는지에 따라 달라집니다.

* `true`: Claude Code가 훅을 등록했습니다. 세션의 첫 번째 initialize는 이 값을 반환합니다. CLI의 stdin을 통해 전송된 반복 initialize도 `true`를 반환합니다. 이 경우 새 요청의 훅이 이전에 등록된 훅을 대체합니다.
* `false`: Claude Code가 훅을 무시했습니다. 원격 세션으로 전송된 반복 initialize는 이 값을 반환하므로, 세션에 참여하는 두 번째 클라이언트가 첫 번째 클라이언트가 등록한 훅을 대체할 수 없습니다.

Agent SDK v0.3.238 이전에는 응답에 이 필드가 포함되지 않았으며, Claude Code는 반복되는 모든 initialize에서 `hooks`를 무시했습니다.

요청의 `sdkMcpServerManifests` 필드와 응답의 `sdk_mcp_manifests_parked` 필드는 [`createSdkMcpServer()`](#createsdkmcpserver)로 생성한 프로세스 내 [SDK MCP 서버](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md)를 위한 것입니다. 애플리케이션에서는 두 필드 모두 설정하거나 읽지 않습니다.

`claude_code_version`은 세션의 턴을 실행하는 프로세스의 Claude Code 버전입니다. [`SDKSystemMessage`](#sdksystemmessage) init 메시지에 포함된 값과 동일하므로, 첫 번째 턴 전에 CLI 버전을 읽을 수 있습니다.

* 이 필드에는 Claude Code v2.1.296이 번들된 Agent SDK v0.3.296 이상이 필요합니다.
* 필드가 `undefined`이고 `pathToClaudeCodeExecutable`을 설정한 경우, 이를 Claude Code v2.1.296 이상으로 지정하세요.

응답은 항상 `fast_mode_state`를 보고하며, 무언가가 [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md)를 차단하는 경우 `fast_mode_disabled_reason`이 그와 함께 이유 코드를 전달하므로, 가용성을 다시 도출하는 대신 차단된 상태를 설명할 수 있습니다. 두 동작 모두 Claude Code v2.1.219 이상이 필요합니다. v2.1.219 이전에는 빠른 모드를 사용할 수 없을 때 응답에서 `fast_mode_state`가 생략되었고 이유도 전달되지 않았습니다. 이유 코드와 그 의미는 결과 메시지의 [`fast_mode_disabled_reason`](#sdkresultmessage)을 참조하세요.

성공한 `initialize`의 제어 응답 래퍼에는 `pending_permission_requests` 배열도 포함됩니다. 이 필드는 위의 `SDKControlInitializeResponse` 페이로드가 아니라 응답 래퍼 자체에 있습니다. 각 항목은 세션이 실행 중에 권한 요청을 위해 스트리밍하는 것과 동일한 `{ type: "control_request", request_id, request }` 형태의 완전한 `control_request` 메시지입니다.

이 배열은 이 Claude Code 프로세스가 발행했지만 아직 해결되지 않은 권한 요청을 나열합니다. SDK는 이 배열을 대신 읽고 각 항목을 [`canUseTool`](#canusetool) 콜백으로 전달하며, 이는 전송 공백 후 [`reinitialize()`](#query-object)가 트리거하는 것과 동일한 재전달입니다. 항목이 연결이 끊기기 전에 콜백이 이미 받은 요청을 반복할 수 있으므로, 반복되는 요청 ID를 멱등하게 처리하세요.

이 배열은 성공한 `initialize` 응답에 항상 존재하며, 이 프로세스에 해결되지 않은 권한 요청이 없으면 비어 있습니다. Claude Code v2.1.268 이상이 필요합니다. 이전 버전에서는 이 필드가 생략될 수 있으므로, 와이어 프로토콜을 직접 파싱하는 경우 필드가 없으면 대기 중인 항목이 없다는 증거가 아니라 이전 CLI로 간주하세요.

### `SDKControlInterruptResponse`

중단 확인 영수증으로, [`SDKSystemMessage.capabilities`](#sdksystemmessage)에서 `interrupt_receipt_v1` 기능을 알리는 CLI에서 [`interrupt()`](#query-object)가 resolve되는 값입니다. Claude Code v2.1.205 이상이 필요합니다. 이전 CLI는 빈 성공 페이로드로 중단에 응답하므로 `interrupt()`는 `undefined`로 resolve됩니다.

```typescript theme={null}
type SDKControlInterruptResponse = {
  still_queued: string[];
  cancelled?: string[];
};
```

`still_queued`는 중단 시점에 대기 중이던 사용자 메시지의 UUID를 나열합니다. 여기에는 아직 큐에 있는 메시지와, Claude Code가 다음 턴을 위해 이미 큐에서 꺼낸 메시지가 포함됩니다. 세션의 첫 번째 턴이 시작된 후에는, 먼저 취소하지 않는 한 Claude Code가 중단 후 나열된 메시지를 처리하며 여러 메시지를 하나의 턴으로 병합할 수 있습니다. 첫 번째 턴이 시작되기 전에 중단하면 Claude Code는 해당 턴이 시작되자마자 중단하며, 그 턴에 나열된 메시지는 응답을 받지 못합니다.

영수증을 사용하여 다시 보낼 항목이 있는지 결정하세요. 취소하지 않은 나열된 메시지는 응답을 받든 받지 않든 대화에 포함되므로, 다시 보내면 Claude에게 두 번 전달됩니다.

다음 주의 사항을 고려하여 목록을 해석하세요.

* UUID와 함께 큐에 추가된 메시지만 나타납니다. 빈 배열이 다른 어떤 것도 실행되지 않는다는 의미는 아닙니다.
* 메인 스레드 메시지만 나열됩니다. 서브에이전트에 전달되는 메시지는 범위에 포함되지 않습니다.
* 목록에는 [세션 범위 예약 작업](https://code.claude.com/docs/ko/scheduled-tasks.md) 트리거처럼 클라이언트가 보내지 않은 UUID가 포함될 수 있습니다. 인식하지 못하는 UUID는 오류로 취급하지 말고 무시하세요.

`interrupt()`를 사용하지 않고 CLI의 제어 프로토콜을 직접 구동하는 클라이언트는 `interrupt` 제어 요청에 `cancel_queued: true`를 설정할 수 있습니다. Claude Code v2.1.219 이상은 [`SDKSystemMessage.capabilities`](#sdksystemmessage)의 `interrupt_cancel_queued_v1` 기능으로 지원 여부를 알리며, 이전 CLI는 이 필드를 무시하고 대기 중인 메시지를 평소처럼 실행합니다. 이러한 중단은 원래 `still_queued`에 나열되었을 모든 메시지도 취소합니다. 영수증은 대신 이 메시지들을 `cancelled`에 나열하고, `still_queued`는 비어 있으며, 해당 메시지는 하나도 실행되지 않습니다.

`cancelled` 목록에는 `still_queued`와 동일한 주의 사항이 적용됩니다. `interrupt()` 메서드는 `cancel_queued`를 보내지 않으므로, 이 메서드가 resolve하는 영수증에는 `cancelled`가 포함되지 않습니다.

영수증은 중단이 처리되는 시점에 찍은 스냅샷이며, 정상적인 중단에서는 중단된 턴의 [`SDKResultMessage`](#sdkresultmessage)보다 먼저 도착합니다. 해당 결과 이후에 큐를 검사하지 말고 영수증을 읽으세요. 루프는 다음 대기 턴을 즉시 시작하므로, 결과 이후에 검사하는 큐는 이미 변경된 상태입니다.

### `SDKControlGetContextUsageResponse`

[`getContextUsage()`](#query-object)의 반환 타입입니다. 기본 `detail`에서 응답에는 Claude Code가 대화형 세션의 `/context` 명령에 대해 렌더링하는 페이로드가 포함됩니다. 토큰 수와 함께, 이 페이로드에는 Claude Code가 `/context` 사용량 그리드를 그리는 데 사용하는 `color`, `gridRows`와 같은 표시 필드도 포함됩니다.

메서드의 선택적 `detail` 인수는 Claude Code가 각 카테고리를 계산하는 방식을 선택합니다. `detail` 인수에는 Agent SDK v0.3.257 이상이 필요합니다.

* **`'full'`**: 기본값입니다. Claude Code는 [토큰 계산](https://platform.claude.com/docs/en/build-with-claude/token-counting) API 요청으로 각 카테고리를 계산합니다. 이러한 요청은 메시지 스트림에 나타나지 않으므로, 스트림을 읽는 비용 추적에서는 이를 볼 수 없습니다. Anthropic API에서는 토큰 계산에 요금이 청구되지 않습니다.
* **`'summary'`**: 대신 마지막 응답의 사용량과 로컬 추정치로 답을 얻으려면 `{ detail: 'summary' }`를 전달하세요. 토큰 계산 요청이 전송되지 않으며, 카테고리별 수치는 근삿값입니다.

메서드를 호출하는 대신 `/context`를 프롬프트로 보내면, Claude Code는 결과를 전달하는 assistant 메시지의 `context_usage` 필드에 [`SDKContextUsage`](#sdkcontextusage) 페이로드를 첨부합니다. 이 필드에는 Agent SDK v0.3.232 이상이 필요합니다.

`SDKControlGetContextUsageResponse`에서 `categories[].id`, `mcpInstructions`, 그리고 `agents` 및 `skills.skillFrontmatter` 항목의 `pluginId` 및 `path` 필드에는 Agent SDK v0.3.304 이상이 필요합니다.

```typescript theme={null}
type SDKControlGetContextUsageResponse = {
  categories: {
    id?:
      | "system_prompt"
      | "system_tools"
      | "mcp_tools"
      | "mcp_instructions"
      | "mcp_tools_deferred"
      | "system_tools_deferred"
      | "custom_agents"
      | "memory_files"
      | "skills"
      | "messages"
      | "autocompact_buffer"
      | "compact_buffer"
      | "free_space";
    name: string;
    tokens: number;
    color: string;
    isDeferred?: boolean;
    kind: "used" | "free" | "buffer" | "deferred";
  }[];
  totalTokens: number;
  maxTokens: number;
  rawMaxTokens: number;
  percentage: number;
  gridRows: {
    color: string;
    isFilled: boolean;
    categoryName: string;
    tokens: number;
    percentage: number;
    squareFullness: number;
  }[][];
  model: string;
  memoryFiles: {
    path: string;
    type: string;
    tokens: number;
  }[];
  mcpTools: {
    name: string;
    serverName: string;
    tokens: number;
    isLoaded?: boolean;
  }[];
  mcpInstructions?: {
    serverName: string;
    tokens: number;
  }[];
  deferredBuiltinTools?: {
    name: string;
    tokens: number;
    isLoaded: boolean;
  }[];
  systemTools?: {
    name: string;
    tokens: number;
  }[];
  systemPromptSections?: {
    name: string;
    tokens: number;
  }[];
  agents: {
    agentType: string;
    source: string;
    pluginId?: string;
    path?: string;
    tokens: number;
  }[];
  slashCommands?: {
    totalCommands: number;
    includedCommands: number;
    tokens: number;
  };
  skills?: {
    totalSkills: number;
    includedSkills: number;
    tokens: number;
    skillFrontmatter: {
      name: string;
      source: string;
      pluginName?: string;
      pluginId?: string;
      path?: string;
      tokens: number;
    }[];
  };
  autoCompactThreshold?: number;
  isAutoCompactEnabled: boolean;
  messageBreakdown?: {
    toolCallTokens: number;
    toolResultTokens: number;
    attachmentTokens: number;
    assistantMessageTokens: number;
    userMessageTokens: number;
    redirectedContextTokens: number;
    unattributedTokens: number;
    toolCallsByType: {
      name: string;
      callTokens: number;
      resultTokens: number;
    }[];
    attachmentsByType: {
      name: string;
      tokens: number;
    }[];
  };
  apiUsage: {
    input_tokens: number;
    output_tokens: number;
    cache_creation_input_tokens: number;
    cache_read_input_tokens: number;
  } | null;
};
```

토큰 귀속 정보는 컬렉션 필드에서 읽으세요.

* `categories`는 카테고리별 합계를 담습니다. 각 항목의 `kind`는 [`SDKContextUsageCategory`](#sdkcontextusagecategory)와 동일한 값으로 행을 분류합니다. 표시용 `name`이 아닌 이 필드를 기준으로 행을 분류하세요. 이 필드에는 Agent SDK v0.3.268 이상이 필요합니다.
* `mcpTools`와 `agents`는 개별 MCP 도구와 서브에이전트에 토큰을 귀속합니다.
* `memoryFiles`는 로드된 각 메모리 파일과 그 비용을 나열합니다.
* `skills.skillFrontmatter`는 스킬 목록의 토큰을 포함된 각 스킬에 귀속합니다. 스킬별 수치는 Claude Code가 실제로 보내는 각 스킬의 목록 항목을 측정하며, 이는 스킬의 전체 frontmatter보다 짧을 수 있습니다. 발견된 모든 스킬이 목록에 포함되었는지 확인하려면 `skills.totalSkills`와 `skills.includedSkills`를 비교하세요.

`totalTokens`는 세션의 현재 컨텍스트 사용량이고, `maxTokens`는 해당 사용량을 측정하는 기준 윈도우입니다. 이 윈도우는 모델의 컨텍스트 윈도우이거나, 적용되는 경우 더 낮은 자동 압축 윈도우입니다. `rawMaxTokens`는 `maxTokens`와 동일한 값을 가지며, `percentage`는 해당 윈도우에 대한 `totalTokens`의 반올림된 백분율입니다. `apiUsage`는 세션의 누적 합계가 아니라 최신 API 응답의 사용량을 담습니다.

Claude Code는 선택적 진단 필드인 `deferredBuiltinTools`, `systemTools`, `systemPromptSections`를 설정하지 않으므로, 타입에 선언되어 있더라도 이 필드들은 없을 것으로 예상하세요.

#### ID로 행 찾기, 서버의 지침 토큰, 항목의 플러그인 및 파일

MCP 서버 지침은 연결된 서버가 제공하고 Claude Code가 컨텍스트에 추가하는 사용 안내이며, `categories`의 `mcp_instructions` 행이 그 토큰을 계산합니다. 다음 [`getContextUsage()`](#query-object) 필드를 사용하여 `id`로 `categories` 행 하나를 골라내거나, `mcp_instructions` 토큰을 서버별로 나누거나, 에이전트 또는 스킬 항목의 출처인 플러그인과 파일을 찾으세요.

| 필드 | 위치 | 담고 있는 내용 |
| :- | :- | :- |
| `id` | 각 `categories` 행 | 행의 식별자로, `mcp_instructions`와 같이 [응답 타입](#sdkcontrolgetcontextusageresponse)에 나열된 값 중 하나입니다. 행 하나를 골라내려면 `id`로, 행을 그룹화하려면 `kind`로 일치시키세요. 이후 Claude Code 버전은 설치된 타입에 나열되지 않은 값을 보낼 수 있으므로, 인식하지 못하는 `id`는 없는 것으로 처리하세요 |
| `mcpInstructions` | 응답 | 지침을 제공하는 연결된 MCP 서버마다 `{ serverName, tokens }` 항목 하나, 또는 제공하는 서버가 없으면 빈 배열입니다. `tokens` 값은 합계가 `mcp_instructions` 행의 `tokens`가 되는 추정치입니다. `serverName`은 해당 서버에 대해 [`mcpServerStatus()`](#query-object)가 보고하는 `name`입니다 |
| `pluginId` | `agents` 및 `skills.skillFrontmatter` 항목 | 항목의 출처인 플러그인을 `name@marketplace` 형식의 ID로 명시하며, 플러그인에서 오지 않은 항목에는 없습니다. 플러그인이 마켓플레이스에서 오지 않은 경우 `@` 뒤의 부분은 대신 [그 출처](https://code.claude.com/docs/ko/plugins/loading.md#find-where-a-plugin-came-from)를 나타냅니다. 예를 들어 [`plugins`](#options) 옵션으로 로드한 플러그인은 `inline`입니다 |
| `path` | `agents` 및 `skills.skillFrontmatter` 항목 | Claude Code가 실행되는 머신에서 에이전트 또는 스킬을 정의하는 파일의 절대 경로입니다. [`agents`](#options) 옵션의 에이전트나 Claude Code에 기본 제공되는 스킬처럼 항목을 정의하는 파일이 없으면 이 필드는 없습니다 |

`id`로 일치시키는 예로, 다음 샘플은 `mcp_instructions` 행을 찾습니다.

```typescript theme={null}
// q is the Query object that query() returned
const usage = await q.getContextUsage();
// undefined if no connected server supplies instructions
const row = usage.categories.find((c) => c.id === "mcp_instructions");
```

### `SDKControlReadFileResponse`

[`readFile()`](#query-object)의 반환 타입입니다.

```typescript theme={null}
type SDKControlReadFileResponse = {
  contents: string;
  absPath: string;
  truncated?: boolean;
  encoding?: 'base64';
};
```

`contents`는 파일 텍스트를 담으며, `encoding: 'base64'`를 요청한 경우에는 base64 데이터를 담습니다. 이 경우 응답의 `encoding` 필드는 `'base64'`로 설정됩니다. `absPath`는 확인된 절대 경로입니다. `truncated`는 파일이 `maxBytes` 상한보다 길어서 내용이 해당 한도에서 잘린 경우에 설정됩니다.

#### `readFile()`이 읽을 수 있는 파일

`readFile()`은 Read 도구보다 좁은 범위의 파일을 제공합니다.

* `cwd` 및 `additionalDirectories`와 같은 세션의 작업 디렉터리 중 하나에 있는 일반 파일
* 도구 결과와 같이 세션에 대한 Claude Code 자체 파일 일부

`Read` 거부 및 확인 요청 규칙은 여전히 일치하는 경로를 차단하며, 광범위한 `Read` 허용 규칙이 나머지 파일 시스템을 `readFile()`에 개방하지는 않습니다. 그 외의 경우 호출은 `null`로 resolve됩니다.

### `SDKControlReloadPluginsResponse`

[`reloadPlugins()`](#query-object)의 반환 타입입니다.

```typescript theme={null}
type SDKControlReloadPluginsResponse = {
  commands: SlashCommand[];
  agents: AgentInfo[];
  plugins: {
    name: string;
    path: string;
    source?: string;
    version?: string;
  }[];
  mcpServers: McpServerStatus[];
  error_count: number;
  held?: boolean;
  cache_impact?: {
    mcp_servers_added: string[];
    mcp_servers_removed: string[];
    lsp_tool_change: ("adds" | "may-add" | "removes" | "may-remove") | null;
  };
};
```

컬렉션 필드는 호출 후의 세션을 설명합니다.

* `commands`, `agents`, `mcpServers`: 세션의 명령, 서브에이전트, MCP 서버 상태로, `supportedCommands()`, `supportedAgents()`, `mcpServerStatus()`가 반환하는 것과 동일한 형태입니다. `supportedAgents()`는 초기화 시 캡처된 목록을 계속 반환하므로, 다시 로드한 후의 집합은 여기의 `agents`에서 읽으세요
* `plugins`: 로드된 각 플러그인과 그 `name` 및 설치 `path`입니다. `version`은 플러그인 매니페스트가 선언한 내용을 그대로 반영하며 플러그인 작성자가 제어하므로, 신뢰하기 전에 검증하세요. 매니페스트에 선언이 없으면 생략됩니다
* `error_count`: 플러그인 로드 중 발생한 오류 수입니다

대화의 프롬프트 캐시를 무효화할 다시 로드를 적용하는 대신 보류하려면 `reloadPlugins()`에 `{ holdOnCacheImpact: true }`를 전달하세요. Claude Code는 대화형 `/reload-plugins` 명령이 [캐시 비용에 대해 경고하기](https://code.claude.com/docs/ko/prompt-caching.md#enabling-or-disabling-a-plugin) 전에 수행하는 검사를 실행합니다. 이 옵션에는 Agent SDK v0.3.268 이상이 필요합니다. `pathToClaudeCodeExecutable`로 지정한 실행 파일처럼 v2.1.268보다 오래된 Claude Code 실행 파일은 이 옵션을 무시하고 다시 로드를 적용합니다.

이 옵션을 전달한 경우 `held`를 읽어 결과를 확인하세요.

* `true`: 다시 로드가 적용되지 않았으며, 컬렉션 필드는 여전히 현재 상태의 세션을 설명합니다. `cache_impact`는 적용 시 무엇이 변경되는지 알려 줍니다. 그래도 적용하려면 옵션 없이 `reloadPlugins()`를 다시 호출하세요.
* `false`: 검사에서 캐시 영향이 발견되지 않았으며, 다시 로드가 적용되었습니다.
* 없음: 옵션을 전달하지 않았거나, Claude Code 실행 파일이 v2.1.268보다 오래되어 다시 로드를 적용했습니다.

`cache_impact`는 `held: true`와 함께 있을 때만 존재합니다. `mcp_servers_added`와 `mcp_servers_removed`는 다시 로드가 등록하거나 제거할 플러그인 MCP 서버를 범위가 지정된 `plugin:<plugin>:<server>` 이름으로 나타냅니다. 이 이름은 플러그인 작성자가 정하므로 표시하기 전에 검증하세요. `lsp_tool_change`는 적용 시 LSP 도구가 추가되는지 제거되는지를 나타내며, 둘 다 아니면 `null`입니다. `may-` 형식은 검사가 대기 중인 플러그인 집합을 완전히 파악할 수 없었음을 의미합니다.

#### `addPlugins`로 플러그인 폴더 추가 로드

시작 시 [`plugins`](#options) 옵션에 없던 플러그인 폴더를 로드하려면, `path`가 절대 경로인 [`SdkPluginConfig`](#sdkpluginconfig) 항목 목록을 `addPlugins`로 `reloadPlugins()`에 전달합니다. Claude Code는 새 폴더를 로드하고 세션의 기존 플러그인을 한 번에 다시 로드합니다. 해당 폴더 항목에 [`skipMcpDiscovery`](#sdkpluginconfig)를 설정하지 않는 한, 추가된 각 플러그인의 MCP 서버도 연결됩니다. Agent SDK v0.3.301 이상과 Claude Code v2.1.301 이상이 필요합니다.

다음 예시는 실행 중인 쿼리 `q`에 폴더 하나를 추가하고, 호출이 반환될 때 세션이 로드한 모든 플러그인의 설치 경로를 출력합니다.

```typescript theme={null}
const result = await q.reloadPlugins({
  addPlugins: [{ type: "local", path: "/opt/my-app/plugins/reports" }]
});

console.log(result.plugins.map((plugin) => plugin.path));
```

폴더가 로드되었다면 출력된 목록에 `/opt/my-app/plugins/reports`가 포함되며, 플러그인의 명령과 서브에이전트가 `result.commands`와 `result.agents`에 나타납니다.

추가된 폴더는 세션의 일부로 유지됩니다. `reloadPlugins()`를 다시 호출하면 Claude Code가 다른 플러그인과 함께 이를 다시 로드하므로, `addPlugins`에 다시 전달할 필요가 없습니다.

##### `reloadPlugins()`가 `addPlugins` 폴더를 로드하지 않는 경우

`reloadPlugins()`가 거부되면 `addPlugins` 폴더는 하나도 추가되지 않으므로, 재시도할 때 `addPlugins`에 다시 전달해야 합니다. 거부 원인이 다음 중 하나인 경우 세션은 기존에 가지고 있던 플러그인을 유지합니다.

* **상대 `path` 또는 잘못된 형식의 항목**: 오류 메시지에 `add_plugins must be a list of { type: "local", path } entries with absolute paths`가 표시됩니다. Claude Code는 잘못된 항목 하나 때문에 목록 전체를 거부하므로, 모든 항목을 절대 `path`를 가진 `{ type: "local", path }` 형식으로 전달해야 합니다
* **관리자가 관리형 설정에서 [`disableSideloadFlags`](https://code.claude.com/docs/ko/settings-reference#disablesideloadflags)를 켠 경우**: 메시지에 `reload_plugins add_plugins is disabled by managed settings (disableSideloadFlags)`가 표시됩니다. 폴더를 로드하려면 해당 관리자에게 설정 제거를 요청합니다
* **[샌드박스](https://code.claude.com/docs/ko/sandboxing.md)를 다시 빌드할 수 없는 경우**: [샌드박싱](#sandboxsettings)이 켜져 있으면 Claude Code는 샌드박스 처리된 셸 명령이 추가한 폴더에 쓸 수 없도록 샌드박스 구성을 다시 빌드합니다. 메시지에 `the sandbox could not be rebuilt to keep shell commands out of this folder`가 표시됩니다. [샌드박스 설정](#sandboxsettings)이 여전히 유효한 구성을 이루는지 확인합니다

`holdOnCacheImpact`를 전달했고 호출이 [`held: true`](#sdkcontrolreloadpluginsresponse)로 확인되면 `addPlugins` 폴더는 추가되지 않습니다. 그래도 추가하려면 동일한 `addPlugins` 목록으로, `holdOnCacheImpact` 없이 `reloadPlugins()`를 다시 호출합니다.

호출이 `held: true` 없이 확인되었는데도 폴더가 `result.plugins`에 없다면, 먼저 다음 원인을 확인합니다.

* **폴더가 존재하지 않거나 해당 플러그인 로드에 실패한 경우**: `result.error_count`가 `1` 이상입니다. 이 경우에도 폴더는 세션의 일부로 유지됩니다. 폴더를 수정한 후 `reloadPlugins()`를 다시 호출하여 로드하되, 이번에는 `addPlugins`에 나열하지 않습니다
* **Claude Code 실행 파일이 v2.1.301보다 오래된 경우**: v2.1.301보다 오래된 실행 파일은 `addPlugins`를 무시하고 세션에 이미 있던 플러그인만 다시 로드합니다. [init 메시지](#sdksystemmessage)의 `claude_code_version`을 확인하고, v2.1.301 이상의 실행 파일을 실행합니다

### `SDKControlReloadSkillsResponse`

[`reloadSkills()`](#query-object)의 반환 타입입니다.

```typescript theme={null}
type SDKControlReloadSkillsResponse = {
  skills: SlashCommand[];
};
```

`skills`는 다시 로드한 후 사용 가능한 스킬을 `supportedCommands()`가 반환하는 것과 동일한 [`SlashCommand`](#slashcommand) 형태로 나열합니다.

### `SDKControlReloadOutputStylesResponse`

[`reloadOutputStyles()`](#query-object)의 반환 타입입니다.

```typescript theme={null}
type SDKControlReloadOutputStylesResponse = {
  available_output_styles: string[];
};
```

`available_output_styles`는 다시 로드한 후 사용 가능한 기본 제공 및 사용자 지정 출력 스타일의 이름을 나열합니다.

### `SDKControlMcpReadResourceResponse`

[`readMcpResource()`](#query-object)의 반환 타입으로, MCP 서버의 `resources/read` 결과를 담습니다. TypeScript Agent SDK v0.3.280 이상이 필요합니다.

```typescript theme={null}
type SDKControlMcpReadResourceResponse = {
  contents: {
    uri: string;
    mimeType?: string;
    text?: string;
    blob?: string;
    _meta?: Record<string, unknown>;
  }[];
};
```

`readMcpResource()`에는 `mcpServerStatus()`가 보고하는 서버 이름과, 도구가 [`_meta`](#mcpserverstatus)에서 선언하는 `ui.resourceUri`와 같은 `ui://` URI를 전달하세요. 다른 URI 스킴, 애플리케이션이 직접 호스팅하는 [SDK MCP 서버](#createsdkmcpserver), 연결되지 않은 서버에 대해서는 호출이 거부됩니다. init 메시지의 [`capabilities`](#sdksystemmessage)에 `mcp_read_resource_v1`이 포함된 경우에 사용할 수 있습니다.

각 `contents` 항목은 서버가 보낸 콘텐츠 항목 하나이며, Claude Code용으로 예약된 `com.anthropic/` 접두사 아래의 `_meta` 키는 제외됩니다. `blob`은 바이너리 항목의 base64 데이터를 담고, `_meta`는 항목 자체의 `_meta`로, MCP Apps 서버가 리소스의 `ui.csp`와 `ui.permissions`를 넣는 곳입니다.

콘텐츠는 신뢰할 수 없는 서드파티 HTML이므로 샌드박스에서 렌더링하세요.

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
  autoCompactWindow?: number;
  background?: boolean;
  omitClaudeMd?: boolean;
  memory?: "user" | "project" | "local";
  effort?: "low" | "medium" | "high" | "xhigh" | "max" | number;
  permissionMode?: PermissionMode;
  criticalSystemReminder_EXPERIMENTAL?: string;
};
```

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `description` | 예 | 이 에이전트를 언제 사용해야 하는지에 대한 자연어 설명입니다 |
| `tools` | 아니요 | 허용되는 도구 이름의 배열입니다. 생략하면 [서브에이전트가 사용할 수 있는 모든 도구](https://code.claude.com/docs/ko/sub-agents.md#available-tools)를 상속합니다. 에이전트의 컨텍스트에 스킬을 미리 로드하려면 여기에 `'Skill'`을 나열하지 말고 `skills` 필드를 사용하세요 |
| `disallowedTools` | 아니요 | 이 에이전트에 대해 명시적으로 허용하지 않을 도구 이름의 배열입니다. MCP 서버 수준 패턴도 허용됩니다. `mcp__server` 또는 `mcp__server__*`는 해당 서버의 모든 도구를 제거하고, `mcp__*`는 모든 서버의 모든 MCP 도구를 제거합니다 |
| `prompt` | 예 | 에이전트의 시스템 프롬프트입니다 |
| `model` | 아니요 | 이 에이전트의 모델 재정의입니다. `'fable'`, `'opus'`, `'sonnet'`, `'haiku'`, `'inherit'`와 같은 별칭 또는 전체 모델 ID를 허용합니다. `'inherit'`는 메인 모델을 사용합니다. 생략하면 Claude Code는 [서브에이전트 모델 순서](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)에 따라 모델을 선택합니다 |
| `mcpServers` | 아니요 | 이 에이전트의 MCP 서버 사양입니다 |
| `skills` | 아니요 | 에이전트 컨텍스트에 미리 로드할 스킬 이름의 배열입니다 |
| `initialPrompt` | 아니요 | 이 에이전트가 메인 스레드 에이전트로 실행될 때 첫 번째 사용자 턴으로 자동 제출됩니다 |
| `maxTurns` | 아니요 | 중지하기 전 최대 에이전트 턴 수(API 왕복)입니다 |
| `autoCompactWindow` | 아니요 | 이 에이전트가 서브에이전트로 실행될 때 [자동 압축 윈도우](https://code.claude.com/docs/ko/sub-agents.md#subagent-auto-compact-window)를 `100000`에서 `1000000` 사이의 토큰 수로 낮춥니다. TypeScript Agent SDK v0.3.296 이상이 필요합니다 |
| `background` | 아니요 | 호출될 때 이 에이전트를 비차단 백그라운드 작업으로 실행합니다 |
| `omitClaudeMd` | 아니요 | 사용자, 프로젝트, 로컬 CLAUDE.md 파일을 이 에이전트의 초기 컨텍스트에서 제외합니다. 관리형 정책 파일은 여전히 로드됩니다. 필요한 모든 것을 Agent 도구 프롬프트에서 받는 에이전트에 사용하십시오. 이 에이전트가 메인 스레드 에이전트로 실행될 때는 무시됩니다. TypeScript Agent SDK v0.3.271 이상이 필요합니다 |
| `memory` | 아니요 | 이 에이전트의 메모리 소스입니다: `'user'`, `'project'` 또는 `'local'` |
| `effort` | 아니요 | 이 에이전트의 추론 effort 수준입니다. 이름이 지정된 수준 또는 정수를 허용합니다 |
| `permissionMode` | 아니요 | 이 에이전트 내에서 도구를 실행할 때의 권한 모드입니다. 적용 시점은 [서브에이전트 상속 규칙](https://code.claude.com/docs/ko/agent-sdk/permissions.md#available-modes)이 결정합니다. [`PermissionMode`](#permissionmode)를 참조하세요 |
| `criticalSystemReminder_EXPERIMENTAL` | 아니요 | 실험적 기능: 시스템 프롬프트에 추가되는 중요 알림입니다 |

### `AgentMcpServerSpec`

서브에이전트에서 사용할 수 있는 MCP 서버를 지정합니다. 서버 이름(상위의 `mcpServers` 구성에 있는 서버를 참조하는 문자열)이거나, 서버 이름을 구성에 매핑하는 인라인 서버 구성 레코드일 수 있습니다.

```typescript theme={null}
type AgentMcpServerSpec = string | Record<string, McpServerConfigForProcessTransport>;
```

여기서 `McpServerConfigForProcessTransport`는 `McpStdioServerConfig | McpSSEServerConfig | McpHttpServerConfig | McpSdkServerConfig`입니다.

### `SettingSource`

SDK가 설정을 로드하는 파일 시스템 기반 구성 소스를 제어합니다.

```typescript theme={null}
type SettingSource = "user" | "project" | "local";
```

| 값 | 설명 | 위치 |
| :- | :- | :- |
| `'user'` | 전역 사용자 설정 | `~/.claude/settings.json` |
| `'project'` | 공유 프로젝트 설정(버전 관리됨) | `.claude/settings.json` |
| `'local'` | 로컬 프로젝트 설정. Claude Code가 여기에 설정을 저장할 때 gitignore 처리됨 | `.claude/settings.local.json` |

#### 기본 동작

`settingSources`가 생략되거나 `undefined`인 경우, `query()`는 Claude Code CLI와 동일한 파일 시스템 설정(user, project, local)을 로드합니다. 이 옵션과 관계없이 읽히는 입력과 이를 비활성화하는 방법은 [settingSources가 제어하지 않는 항목](https://code.claude.com/docs/ko/agent-sdk/claude-code-features.md#what-settingsources-does-not-control)을 참조하세요.

#### settingSources를 사용하는 이유

**파일 시스템 설정 비활성화:**

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

// Do not load user, project, or local settings from disk
const result = query({
  prompt: "Analyze this code",
  options: { settingSources: [] }
});
```

**특정 설정 소스만 로드:**

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

// Load only project settings, ignore user and local
const result = query({
  prompt: "Run CI checks",
  options: {
    settingSources: ["project"] // Only .claude/settings.json
  }
});
```

CLAUDE.md 프로젝트 지침을 로드하려면 `settingSources`에 `"project"`를 포함하세요. CLAUDE.md 로딩이 시스템 프롬프트 옵션과 어떻게 상호 작용하는지는 [시스템 프롬프트 수정](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#claude-md-files-for-project-level-instructions)을 참조하세요.

#### 설정 우선순위

여러 소스가 로드되면 설정은 다음 우선순위(높은 순에서 낮은 순)에 따라 병합됩니다.

1. 로컬 설정(`.claude/settings.local.json`)
2. 프로젝트 설정(`.claude/settings.json`)
3. 사용자 설정(`~/.claude/settings.json`)

`agents`, `allowedTools`, `settings` 같은 프로그래밍 방식 옵션은 사용자, 프로젝트, 로컬 파일 시스템 설정을 재정의합니다. 관리형 정책 설정과 프로그래밍 방식 옵션이 같은 키를 설정하면 관리형 값이 적용되며, [`applyFlagSettings()`](#applyflagsettings)에 전달된 `effortLevel` 같은 예외가 있습니다.

### `PermissionMode`

```typescript theme={null}
type PermissionMode =
  | "default" // Standard permission behavior
  | "acceptEdits" // Auto-accept file edits
  | "bypassPermissions" // Bypass permission checks; explicit ask rules still prompt
  | "plan" // Planning mode - explore without editing
  | "dontAsk" // Don't prompt for permissions, deny if not pre-approved
  | "auto"; // A model classifier reviews actions such as shell commands and network requests
```

### `CanUseTool`

도구 사용을 제어하기 위한 사용자 정의 권한 함수 타입입니다.

이 함수는 대화형 권한 프롬프트를 대체하는 SDK 기능으로, [권한 평가 흐름](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)이 프롬프트로 귀결될 때만 호출됩니다. `allowedTools` 항목, 설정의 allow 규칙, 또는 `acceptEdits`나 `bypassPermissions` 같은 권한 모드에 의해 이미 승인된 도구 호출은 이 함수를 호출하지 않습니다. 모든 도구 호출을 제어하려면 대신 [`PreToolUse` 훅](https://code.claude.com/docs/ko/agent-sdk/hooks)을 사용하세요.

allow 규칙은 [어떤 모드에서도 자동 승인되지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)을 사전 승인하지 않습니다. 그중 어떤 작업이 콜백에 도달하는지, 그리고 `dontAsk` 및 `auto` 모드에서 어떻게 처리되는지는 [권한 평가 방식](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)을 참조하세요.

```typescript theme={null}
type CanUseTool = (
  toolName: string,
  input: Record<string, unknown>,
  options: {
    signal: AbortSignal;
    suggestions?: PermissionUpdate[];
    blockedPath?: string;
    mcpServer?: { name: string; source: string };
    decisionReason?: string;
    defaultToNo?: boolean;
    suppressAlwaysAllowRule?: boolean;
    toolUseID: string;
    agentID?: string;
    requestId: string;
  }
) => Promise<PermissionResult | null>;
```

| 옵션 | 타입 | 설명 |
| :- | :- | :- |
| `signal` | `AbortSignal` | 작업을 중단해야 하는 경우 신호가 전달됩니다 |
| `suggestions` | [`PermissionUpdate`](#permissionupdate)`[]` | 이 도구에 대해 사용자에게 다시 확인을 요청하지 않도록 하는 권한 업데이트 제안입니다. Bash 프롬프트에는 `localSettings` [대상](#permissionupdatedestination)을 가진 제안이 포함되므로, 이를 `updatedPermissions`로 반환하면 규칙이 `.claude/settings.local.json`에 기록되어 세션 간에 유지됩니다. |
| `blockedPath` | `string` | 해당되는 경우, 권한 요청을 트리거한 파일 경로 |
| `mcpServer` | `{ name: string; source: string }` | `mcp__*` 도구의 경우, 해당 도구를 제공하는 MCP 서버와 그 서버 정의의 출처로, [`McpServerProvenance`](#mcpserverprovenance)의 필드를 가집니다. 다른 도구에서는 없습니다. Agent SDK v0.3.274 이상이 필요합니다 |
| `decisionReason` | `string` | 이 권한 요청이 트리거된 이유를 설명합니다 |
| `defaultToNo` | `boolean` | `true`인 경우, 실수로 누른 키 하나로 이 요청이 승인되어서는 안 됩니다. 프롬프트를 거부 옵션에서 열고, 승인을 미리 선택하지 말며, 한 번의 키 입력으로 승인하는 단축키를 제공하지 마세요. Agent SDK v0.3.268 이상이 필요합니다 |
| `suppressAlwaysAllowRule` | `boolean` | `true`인 경우, 이 요청에 대해 영구적인 항상 허용 선택지를 제공하지 마세요. Agent SDK v0.3.268 이상이 필요합니다 |
| `toolUseID` | `string` | 어시스턴트 메시지 내에서 이 특정 도구 호출에 대한 고유 식별자 |
| `agentID` | `string` | 서브에이전트 내에서 실행 중인 경우, 서브에이전트의 ID |
| `requestId` | `string` | `control_request` 엔벨로프의 `request_id`입니다. 서명된 HTTP POST처럼 애플리케이션이 SDK 외부에서 보내는 `control_response`는 Claude Code 프로세스가 응답을 요청과 매칭할 수 있도록 이 값을 그대로 포함해야 합니다 |

콜백은 일반적으로 [`PermissionResult`](#permissionresult)를 반환하여 요청을 처리하며, SDK는 이를 자체 전송 계층을 통해 `control_response`로 다시 기록합니다. 애플리케이션이 `requestId`를 포함하여 자체 채널로 이 요청에 대한 `control_response`를 이미 보낸 경우에만 `null`을 반환하세요. 그러면 SDK는 전송 계층에 응답을 기록하는 작업을 건너뜁니다. 그 외의 경우에 `null`을 반환하면 `control_response`가 전송되지 않고 권한 프롬프트는 시간 초과되지 않으므로 도구 호출이 무기한 차단됩니다.

`requestId` 옵션과 `null` 반환 값은 Claude Code v2.1.199 이상이 필요합니다.

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

`updatedPermissions`에 4,096개를 초과하는 항목과 함께 `allow`를 반환하면 Claude Code는 결과를 유효하지 않은 것으로 처리하고 도구 호출을 거부합니다. 각 업데이트가 하나의 항목으로 계산되며, 해당 `rules` 또는 `directories` 목록의 각 항목도 마찬가지입니다. 거부 메시지는 `updatedPermissions may hold at most 4096 updates, rules and directories in all.`로 끝납니다. 호출이 허용되게 하려면 4,096개 이하의 항목을 반환하십시오.

### `ToolConfig`

기본 제공 도구 동작에 대한 구성입니다.

```typescript theme={null}
type ToolConfig = {
  askUserQuestion?: {
    previewFormat?: "markdown" | "html";
  };
};
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `askUserQuestion.previewFormat` | `'markdown' \| 'html'` | [`AskUserQuestion`](https://code.claude.com/docs/ko/agent-sdk/user-input#question-format) 옵션의 `preview` 필드를 활성화하고 해당 콘텐츠 형식을 설정합니다. 설정하지 않으면 Claude는 미리보기를 생성하지 않습니다 |

### `McpServerConfig`

MCP 서버에 대한 구성입니다.

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

인프로세스 MCP 서버의 구성입니다. [`createSdkMcpServer()`](#createsdkmcpserver)가 반환하는 값에, 사용자가 추가하는 선택적 [`McpServerToolPolicy`](#mcpservertoolpolicy) 항목의 `tools` 목록을 더한 것입니다.

```typescript theme={null}
type McpSdkServerConfigWithInstance = {
  type: "sdk";
  name: string;
  timeout?: number;
  tools?: McpServerToolPolicy[];
  instance: McpServer;
};
```

서버 도구 중 하나에 대한 호출에 승인을 요구하거나 이를 거부하려면, 해당 도구의 이름을 지정하는 정책 항목을 추가합니다. 함수의 `tools` 옵션은 정책 항목이 아닌 도구 정의를 받으므로, `createSdkMcpServer()`가 반환하는 값을 `mcpServers` 아래의 객체에 펼치고 해당 객체의 `tools` 목록에 항목을 넣으십시오. 정책 목록에는 Agent SDK v0.3.301 이상이 필요하며, 각 `permission_policy` 값의 동작은 [`McpServerToolPolicy`](#mcpservertoolpolicy)에 설명되어 있습니다.

이 스크립트에서는 `allowedTools` 와일드카드가 `records` 서버의 모든 도구를 사전 승인하지만, `delete_record`는 `always_ask`로 표시되어 있으므로 해당 호출은 어쨌든 `canUseTool`로 전달됩니다. `destructiveHint: true` 어노테이션이 있으므로 세션이 `auto` 모드로 실행되더라도 호출이 콜백에 도달합니다. 그렇지 않으면 자동 모드 [분류기](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 이를 승인할 수 있습니다.

```typescript theme={null}
import { query, tool, createSdkMcpServer } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

const deleteRecord = tool(
  "delete_record",
  "Delete a customer record by ID",
  { id: z.string() },
  async ({ id }) => ({ content: [{ type: "text", text: `Deleted record ${id}` }] }),
  { annotations: { destructiveHint: true } }
);

const records = createSdkMcpServer({ name: "records", tools: [deleteRecord] });

for await (const message of query({
  prompt: "Delete customer record 42",
  options: {
    mcpServers: {
      // Spread the returned config and add the policy list beside it
      records: {
        ...records,
        tools: [{ name: "delete_record", permission_policy: "always_ask" as const }]
      }
    },
    allowedTools: ["mcp__records__*"],
    canUseTool: async (toolName, input) => {
      console.log(`Approval requested for ${toolName}`);
      return { behavior: "allow", updatedInput: input };
    }
  }
})) {
  if (message.type === "result" && message.subtype === "success") {
    console.log(message.result);
  }
}
```

Claude가 `delete_record`를 호출하면 스크립트는 `Approval requested for mcp__records__delete_record`를 출력합니다.

세션 실행 중에 도구의 정책을 변경하거나 해제하려면, 새 `tools` 값을 포함한 서버 구성을 [`setMcpServers()`](#mcpsetserversresult)에 전달합니다. 전달한 `tools` 값은 Claude가 해당 서버의 도구를 다음에 호출할 때부터 적용됩니다.

* **항목이 있는 목록**: 항목이 현재 정책을 대체합니다
* **빈 목록**: 서버의 모든 정책이 해제됩니다
* **`tools` 키 없음**: 현재 정책이 유지됩니다

해당 호출에는 다른 인프로세스 서버와 이전 `setMcpServers()` 호출로 추가된 서버를 모두 포함해야 합니다. 그렇지 않으면 호출 시 해당 서버들의 연결이 끊어집니다.

#### `McpServerToolPolicy`

[`McpSdkServerConfigWithInstance`](#mcpsdkserverconfigwithinstance)의 `tools` 목록에 있는 항목 하나로, 서버 도구 중 하나의 이름을 지정하고 해당 도구 호출에 대한 권한 정책을 설정합니다. 이 목록에는 Agent SDK v0.3.301 이상과 Claude Code v2.1.301 이상이 필요합니다. `pathToClaudeCodeExecutable`로 지정한 실행 파일과 같은 이전 Claude Code 실행 파일은 이 목록을 무시합니다. 그러면 `always_ask`와 `always_deny`가 적용되지 않으며, 각 호출은 [권한 흐름](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)을 거칩니다.

```typescript theme={null}
type McpServerToolPolicy = {
  name: string;
  permission_policy?: "always_allow" | "always_ask" | "always_deny";
  org_max_permission?: "allow" | "ask" | "blocked";
};
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `name` | `string` | [`tool()`](#tool)에 전달된 도구의 기본 이름으로, `mcp__<server>__` 접두사를 제외합니다 |
| `permission_policy` | `'always_allow' \| 'always_ask' \| 'always_deny'` | 도구 호출에 대한 승인 정책으로, [`always_ask` 또는 `always_deny`](#permission-policy-values)입니다. 인프로세스 서버에서는 `always_allow`가 무시됩니다. 도구를 미리 승인하려면 대신 [`allowedTools`](#options)에 나열합니다 |
| `org_max_permission` | `'allow' \| 'ask' \| 'blocked'` | 조직 관리자가 설정하는 도구별 상한. 인프로세스 서버에서는 무시되므로 설정하지 않은 상태로 둡니다 |

##### `permission_policy` 값

각 호출을 직접 승인하려면 `always_ask`를, 도구를 완전히 차단하려면 `always_deny`를 선택합니다.

* **`always_ask`**: `allowedTools` 항목이나 허용 규칙이 해당하더라도 도구에 대한 각 호출은 [승인이 필요합니다](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated). 호출은 먼저 처리되지 않는 한 `canUseTool` 콜백 또는 [`permissionPromptToolName`](#options) 도구로 전달됩니다. 로드한 플러그인의 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)가 [먼저 승인할 수 있습니다](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods). 그렇지 않으면 `dontAsk` 모드에서는 거부되고, [`auto`, `plan`, `bypassPermissions` 모드](#permission-modes-that-can-approve-an-always_ask-call)에서는 콜백에 도달하기 전에 승인될 수 있습니다
* **`always_deny`**: `bypassPermissions`를 포함한 모든 권한 모드에서 도구 호출이 [거부됩니다](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated). 단, 로드한 플러그인의 mod는 [여전히 승인할 수 있습니다](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods)

`canUseTool`과 `permissionPromptToolName`을 모두 전달하지 않거나 [`permissionPrompts`](#options)를 `'none'`으로 설정하면, 먼저 처리되지 않은 `always_ask` 호출은 [`PermissionRequest` 훅](https://code.claude.com/docs/ko/hooks#permissionrequest)이 허용하지 않는 한 거부됩니다.

##### `always_ask` 호출을 승인할 수 있는 권한 모드

`auto`, `plan`, `bypassPermissions` 모드에서는 [`always_ask`](#permission-policy-values)로 표시된 도구에 대한 호출이 `canUseTool` 콜백에 도달하기 전에 승인될 수 있습니다.

* **`auto`**: 자동 모드 [분류기](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 호출을 검토하여 허용할 수 있습니다. `auto` 모드에서 모든 호출이 콜백에 도달하도록 하려면 도구의 [어노테이션](#toolannotations)에 `destructiveHint: true`를 설정합니다
* **`plan`**: 세션에서 [자동 모드를 사용할 수 있는](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode) 동안, `readOnlyHint: true`로 어노테이션된 `always_ask` 도구에 대한 호출은 자동 모드 분류기로 전달되며, 분류기가 이를 허용할 수 있습니다. 다른 `always_ask` 도구에 대한 호출은 콜백에 도달합니다. 읽기 전용 도구의 호출도 콜백에 도달하도록 하려면 해당 도구의 어노테이션에 `readOnlyHint: true`와 함께 `destructiveHint: true`를 추가합니다. 또는 [`useAutoModeDuringPlan`](https://code.claude.com/docs/ko/settings-reference#useautomodeduringplan)을 `false`로 설정하여 계획 중에 분류기를 끌 수 있습니다
* **`bypassPermissions`**: [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에서처럼 [`CLAUDE_CODE_REMOTE`](https://code.claude.com/docs/ko/env-vars#variables) 환경 변수가 `true`이면, 도구의 어노테이션과 관계없이 호출이 콜백 없이 승인됩니다. 그 외의 환경에서는 호출이 콜백에 도달합니다. 클라우드 세션에서도 콜백에 도달하도록 하려면 대신 `default` 또는 `acceptEdits` 모드로 세션을 실행합니다

`auto` 및 `plan` 모드에서는 `destructiveHint`를 명시적으로 `true`로 설정합니다. `always_ask` 호출의 경우, [`ToolAnnotations`](#toolannotations)에 나열된 기본값은 `true`이지만 Claude Code는 설정되지 않은 `destructiveHint`를 `false`로 읽습니다.

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
  skipMcpDiscovery?: boolean;
};
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `type` | `'local'` | 반드시 `'local'`이어야 합니다(현재 로컬 플러그인만 지원) |
| `path` | `string` | 플러그인 디렉터리 경로. 상대 경로는 세션 시작 시 [`cwd`](#options) 옵션을 기준으로 확인됩니다. 세션 도중 [`addPlugins`](#load-more-plugin-folders-with-addplugins)로 플러그인을 로드할 때는 경로가 절대 경로여야 합니다 |
| `skipMcpDiscovery` | `boolean` | `true`인 경우, SDK는 이 플러그인에서 스킬, 훅, 에이전트, 명령을 로드하지만 `.mcp.json`이나 매니페스트의 `mcpServers`는 읽지 않습니다. 애플리케이션이 플러그인의 MCP 연결을 직접 관리하는 경우 이 값을 설정하세요. |

**예시:**

```typescript theme={null}
plugins: [
  { type: "local", path: "./my-plugin" },
  { type: "local", path: "/absolute/path/to/plugin" }
];
```

플러그인 생성 및 사용에 대한 자세한 내용은 [플러그인](https://code.claude.com/docs/ko/agent-sdk/plugins.md)을 참조하세요.

## 메시지 타입

### `SDKMessage`

쿼리가 반환할 수 있는 모든 메시지의 유니온 타입입니다.

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
  | SDKBackgroundTasksChangedMessage
  | SDKThinkingTokensMessage
  | SDKSessionStateChangedMessage
  | SDKWorkerShuttingDownMessage
  | SDKCommandsChangedMessage
  | SDKNotificationMessage
  | SDKFilesPersistedEvent
  | SDKToolUseSummaryMessage
  | SDKMemoryRecallMessage
  | SDKRateLimitEvent
  | SDKElicitationCompleteMessage
  | SDKPermissionDeniedMessage
  | SDKPromptSuggestionMessage
  | SDKAPIRetryMessage
  | SDKControlRequestProgressMessage
  | SDKModelRefusalFallbackMessage
  | SDKModelRefusalNoFallbackMessage
  | SDKMirrorErrorMessage
  | SDKInformationalMessage
  | SDKConversationResetMessage;
```

이 유니온에 포함된 세 가지 메시지는 제어 요청 진행 상황과 모델 거부를 보고합니다. 세 메시지 모두 `type: "system"`을 가지므로, 각 항목에 함께 나열된 `subtype`으로 구분합니다:

* `SDKControlRequestProgressMessage`, `subtype: "control_request_progress"`: 클라이언트가 보낸 장시간 실행 제어 요청의 진행 상황을 보고합니다. `request_id`는 메시지를 해당 요청과 연결하며, `status`는 `"started"` 또는 `"api_retry"`입니다. Agent SDK v0.3.203 이상이 필요합니다.
* `SDKModelRefusalFallbackMessage`, `subtype: "model_refusal_fallback"`: 모델이 거부로 스트림을 종료하고 해당 턴이 폴백 모델로 재시도될 때 생성됩니다. `original_model`과 `fallback_model`을 포함합니다. Agent SDK v0.3.170 이상이 필요합니다.
* `SDKModelRefusalNoFallbackMessage`, `subtype: "model_refusal_no_fallback"`: 모델이 거부로 스트림을 종료했지만 재시도가 실행되지 않을 때 생성됩니다. 예를 들어 폴백 모델이 구성되지 않은 경우입니다. `original_model`을 포함합니다. Agent SDK v0.3.193 이상이 필요합니다.

### `SDKAssistantMessage`

어시스턴트 응답 메시지입니다.

```typescript theme={null}
type SDKAssistantMessage = {
  type: "assistant";
  uuid: UUID;
  session_id: string;
  message: BetaMessage; // From Anthropic SDK
  parent_tool_use_id: string | null;
  error?: SDKAssistantMessageError;
  aborted?: true;
  agent_id?: string;
  timestamp?: string;
  context_usage?: SDKContextUsage;
  usage_report?: SDKUsageReport;
  user_message_uuid?: string;
  user_message_uuids?: string[];
  resume_reason?: string;
};
```

`message` 필드는 Anthropic SDK의 [`BetaMessage`](https://platform.claude.com/docs/en/api/messages/create)입니다. 여기에는 `id`, `content`, `model`, `stop_reason`, `usage` 같은 필드가 포함됩니다.

`SDKAssistantMessageError`는 `'authentication_failed'`, `'oauth_org_not_allowed'`, `'account_on_hold'`, `'billing_error'`, `'rate_limit'`, `'overloaded'`, `'invalid_request'`, `'model_not_found'`, `'server_error'`, `'max_output_tokens'`, `'cloud_credential_error'`, `'unknown'` 중 하나입니다. 이 중 네 가지 값은 이름보다 더 많은 의미를 가집니다.

* `'model_not_found'`: 선택한 모델이 존재하지 않거나 사용자의 계정 또는 배포에서 사용할 수 없습니다
* `'overloaded'`: 서버 용량이 가득 차서 API가 529를 반환했습니다. 이는 할당량에 대한 429인 `'rate_limit'`과 구별됩니다
* `'account_on_hold'`: [계정이 보류 상태입니다](https://code.claude.com/docs/ko/errors.md#your-account-is-on-hold)
* `'cloud_credential_error'`: Claude Code가 실행 중인 머신에서 사용 가능한 AWS 또는 Google Cloud 자격 증명을 얻지 못해 어떤 요청도 클라우드 공급자에 도달하지 않았습니다. 일반적인 원인은 해당 머신에서 클라우드 로그인이 만료되었거나 완료되지 않은 것이지만, 자격 증명 서비스에 일시적으로 연결할 수 없는 경우에도 같은 값이 보고됩니다. [Could not load AWS or Google Cloud credentials](https://code.claude.com/docs/ko/errors.md#could-not-load-aws-or-google-cloud-credentials)를 참조하세요. Claude Code v2.1.267을 번들로 포함하는 TypeScript Agent SDK v0.3.267 이상이 필요합니다

`aborted`는 인터럽트 또는 중단으로 인해 스트림이 완료되기 전에 어시스턴트 메시지가 잘렸을 때 `true`입니다. 이 경우 메시지에는 `stop_reason`이 없으며 콘텐츠가 단어 중간에서 끝날 수 있습니다. 정상적으로 완료된 메시지에는 이 필드가 없습니다. Agent SDK v0.3.214 이상이 필요합니다.

`agent_id`는 메시지를 생성한 서브에이전트를 식별하며, 메인 스레드 메시지에는 없습니다. 값은 해당 서브에이전트의 [`task_started`](#sdktaskstartedmessage) 및 기타 작업 이벤트의 `task_id`와 같으며, 서브에이전트가 [재개](https://code.claude.com/docs/ko/agent-sdk/subagents.md#resume-subagents)되어도 변경되지 않습니다. [중첩된 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#let-subagents-spawn-their-own-subagents)의 메시지에서는 이를 생성한 서브에이전트가 아니라 중첩된 서브에이전트를 가리킵니다. 이 필드에는 Agent SDK v0.3.292 이상이 필요합니다.

서브에이전트의 메시지를 작업 이벤트와 매칭할 때는 메시지의 `parent_tool_use_id`를 작업 이벤트의 `tool_use_id`와 짝짓지 말고 `agent_id`를 기준으로 매칭하세요. 도구 호출이 서브에이전트를 재개하면 작업 이벤트는 해당 호출의 `tool_use_id`를 가지지만, 메시지는 서브에이전트를 처음 시작한 도구 호출의 `parent_tool_use_id`를 유지하므로 두 값이 더 이상 일치하지 않습니다.

Claude Code는 [`user_message_uuid`](#user_message_uuid)에 설명된 조건에 따라 턴의 첫 번째 어시스턴트 메시지에 `user_message_uuid`와 `user_message_uuids`를 설정합니다. 재시작으로 중단된 턴을 이어가는 턴인 경우, 해당 필드를 포함하는 어시스턴트 메시지에는 [`resume_reason`](#resume_reason)도 포함됩니다.

`timestamp`는 메시지를 생성한 프로세스에서 메시지 콘텐츠 생성이 완료된 ISO 8601 시각입니다. 이 값은 해당 머신의 시계에서 가져오므로 표시 용도로만 사용하고 메시지 정렬에는 사용하지 마세요. 하나의 API 턴이 같은 `message.id`를 공유하는 여러 어시스턴트 메시지를 생성할 수 있으며, 각 메시지는 고유한 `timestamp`를 가집니다. 이 필드가 없으면 메시지를 수신한 시각을 대신 사용하세요.

`context_usage`는 [`SDKContextUsage`](#sdkcontextusage) 타입으로 된 `/context` 보고서의 구조화된 사본이며 Agent SDK v0.3.232 이상이 필요합니다. `/context`를 프롬프트로 보내면 Claude Code는 `message.content`에 markdown 표가 담긴 어시스턴트 메시지로 보고서를 전달하고, 같은 메시지에 `context_usage`를 첨부합니다. Claude Code는 다른 어시스턴트 메시지에는 이 필드를 설정하지 않으며, 이전 버전은 이 필드 없이 `/context` 표를 전달합니다. 따라서 필드가 있으면 필드에서 세부 내역을 읽고, 없으면 markdown 텍스트를 사용하세요.

`usage_report`는 `/usage` 보고서의 구조화된 사본으로, 타입은 [`SDKUsageReport`](#sdkusagereport)이며 Agent SDK v0.3.273 이상이 필요합니다. `/usage`를 프롬프트로 보내면 Claude Code는 `message.content`에 텍스트를 담은 어시스턴트 메시지로 보고서를 전달합니다. 세션이 다음 조건을 모두 충족할 때만 같은 메시지에 `usage_report`를 첨부합니다.

* 세션이 claude.ai 자격 증명으로 인증됨
* 자격 증명이 알려진 플랜 유형을 나타내거나 `user:profile` 범위를 가짐
* 계정이 사용량 기반 청구를 사용하지 않음

`CLAUDE_CODE_OAUTH_TOKEN`으로 전달된 `claude setup-token` 토큰은 `user:inference` 범위만 가지므로 기본적으로 조건을 충족하지 않습니다. API 키 세션 같은 다른 세션은 이 필드 없이 텍스트를 전달하며, 이전 버전도 마찬가지입니다. 필드가 있으면 필드에서 보고서를 읽고 없으면 텍스트를 사용하십시오.

### `SDKUserMessage`

사용자 입력 메시지입니다.

```typescript theme={null}
type SDKUserMessage = {
  type: "user";
  uuid?: UUID;
  session_id?: string;
  agent_id?: string;
  message: MessageParam; // From Anthropic SDK
  pasted_content?: MessageParam["content"][];
  parent_tool_use_id: string | null;
  isSynthetic?: boolean;
  shouldQuery?: boolean;
  client_composed?: true;
  tool_use_result?: unknown;
  priority?: "now" | "next" | "later";
  origin?: SDKMessageOrigin;
  inline_pastes?: string[];
};
```

사용자가 프롬프트 UI에 직접 입력하지 않고 붙여 넣은 콘텐츠를 보내려면 `pasted_content`를 설정합니다. 붙여 넣기 한 번당 하나의 항목이며, 각 항목은 문자열 또는 콘텐츠 블록 배열입니다. Claude Code는 입력된 텍스트 뒤에 각 항목의 텍스트를 순서대로 추가하며, 각 붙여 넣기를 `<pasted_content>` 태그로 감쌀 수 있습니다. 텍스트 이외의 블록은 무시되므로 이미지와 문서는 `message.content`로 보내세요. Agent SDK v0.3.277 이상이 필요합니다.

`message.content` 중 사용자가 입력하지 않고 붙여 넣은 부분을 Claude Code에 알리려면 `inline_pastes`를 설정합니다. 붙여 넣기 한 번당 하나의 문자열입니다. 프롬프트 텍스트는 사용자가 넣은 위치에 그대로 유지됩니다. Claude Code는 나열된 각 붙여 넣기를 해당 위치에서 `<pasted_content>` 태그로 감쌀 수 있으므로, Claude는 붙여 넣은 자료와 사용자가 직접 쓴 말을 구별할 수 있습니다. 프롬프트의 마지막 텍스트 블록에 있는 붙여 넣기만 감싸집니다. TypeScript Agent SDK v0.3.280 이상이 필요합니다.

각 붙여넣기 필드에는 크기 제한이 있습니다.

* `pasted_content`: 항목과 그 안의 콘텐츠 블록을 합한 수가 1,000개를 넘으면 Claude Code는 필드 전체를 무시합니다.
* `inline_pastes`: Claude Code는 비어 있지 않은 처음 100개 항목을 사용하고 나머지는 무시합니다.

보내는 메시지를 Claude Code가 처리하는 방식을 바꾸려면 `shouldQuery`, `client_composed`, 또는 `priority`를 설정합니다.

* `shouldQuery`: `false`로 설정하면 어시스턴트 턴을 트리거하지 않고 메시지를 트랜스크립트에 추가합니다. 메시지는 보류되었다가 턴을 트리거하는 다음 사용자 메시지에 병합됩니다. 별도로 실행한 명령의 출력처럼 모델 호출을 소비하지 않고 컨텍스트를 주입할 때 사용합니다.
* `client_composed`: `true`로 설정하면 Claude Code가 메시지 텍스트를 작성된 그대로 전달합니다. 이 경우 Claude Code는 `@path` 또는 [`@server:resource`](https://code.claude.com/docs/ko/mcp#use-mcp-resources) 멘션을 확장하지 않으며, `/`로 시작하는 텍스트를 명령으로 실행하지 않습니다. [`verbatimPrompts`](#options) 옵션이 켜져 있는 동안에는 SDK가 모든 메시지에 이 필드를 설정합니다. TypeScript Agent SDK v0.3.280 이상과 Claude Code v2.1.248 이상이 필요합니다.
* `priority`: 턴이 실행 중일 때 보낸 메시지가 Claude에 도달하는 시점을 제어합니다.
  * `'next'` 또는 `priority` 필드 없음: Claude는 실행 중인 도구 호출이 끝나는 즉시 같은 턴에서 메시지를 읽습니다. 턴이 먼저 끝나면 메시지가 다음 턴을 시작합니다.
  * `'later'`: Claude Code는 턴이 끝날 때까지 메시지를 보류했다가 새 턴으로 보냅니다.
  * [`origin: { kind: "human" }`](#sdkmessageorigin)과 함께 `'now'`: Claude Code v2.1.286 이상에서는 백그라운드에서 계속될 수 있는 작업이 백그라운드로 이동하고, Claude는 같은 턴에서 메시지를 읽습니다. 이동할 수 있는 작업에는 셸 명령, 서브에이전트, MCP 도구 호출이 포함됩니다. v2.1.287 이상에서는 WebFetch 및 WebSearch 호출도 포함됩니다. Claude가 응답만 작성 중이거나 실행 중인 작업을 이동할 수 없는 경우, Claude Code는 대신 턴을 인터럽트하고 Claude가 다음으로 메시지를 읽습니다.
  * 해당 origin 없이 `'now'`: Claude Code가 턴을 인터럽트하고 Claude가 다음으로 메시지를 읽습니다.

턴이 실행 중일 때 보내는 다음 메시지는 아직 실행 중인 셸 명령을 잃지 않고 방향을 바꾸도록 Claude에 요청합니다.

```typescript theme={null}
const message: SDKUserMessage = {
  type: "user",
  message: { role: "user", content: "Skip the integration tests and summarize what you have so far" },
  parent_tool_use_id: null,
  priority: "now",
  origin: { kind: "human" },
};
```

서브에이전트가 생성하는 사용자 메시지(예: 자체 도구 호출 중 하나에 대한 `tool_result`)는 `agent_id`를 가집니다. 이 필드와 버전 요구 사항은 [`SDKAssistantMessage`](#sdkassistantmessage)에서 정의합니다.

`tool_result` 블록을 포함한 메시지에서 `tool_use_result`는 모델에 전송된 텍스트가 아니라 도구의 구조화된 출력 객체입니다. 그 형태는 대응하는 `tool_use` 블록이 지정한 도구에 따라 달라지므로 이 필드는 `unknown` 타입입니다. 기본 제공 형태는 [도구 출력 타입](#tool-output-types)에 나열되어 있습니다. 다음 결과는 나열된 형태 이상의 처리가 필요합니다.

* `Agent` 도구: `tool_use_result`는 [`AgentOutput`](#agent-2)입니다. `tool_result` 텍스트를 파싱하지 말고 이 값으로 렌더링하세요. `completed` 결과의 `content`에는 서브에이전트의 보고서가 담기며, 보고서를 `SubagentHandback` 도구 호출로 전달하는 서브에이전트의 경우에는 보고서 대신 해당 인계에 대한 짧은 메모가 담깁니다. Claude Code v2.1.271 이상의 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서는 [포크](https://code.claude.com/docs/ko/sub-agents.md#fork-the-current-conversation)가 아닌 한 `completed` 결과를 생성하는 모든 서브에이전트가 그런 방식으로 보고하며, Claude는 서브에이전트로부터 별도의 메시지로 보고서를 받습니다.
* `'now'` 메시지를 전달하기 위해 Claude Code가 백그라운드로 이동한 WebFetch 또는 WebSearch 호출: 해당 호출의 `tool_result`를 담은 사용자 메시지에서 `tool_use_result`는 `{ detachedToolCall: true }`로 설정됩니다. 호출은 계속 실행 중이며, Claude는 호출이 끝나면 결과를 받습니다. 해당 `tool_use_id`에 대한 두 번째 `tool_result`는 뒤따르지 않으므로, 애플리케이션에서 도구 호출마다 행을 그린다면 이 메시지가 도착할 때 해당 행을 백그라운드로 이동됨으로 표시하세요. Claude Code v2.1.287 이상이 필요합니다.
* 결과에 `resource_link` 블록이 포함된 MCP 도구: `tool_use_result`는 [`SDKMcpResourceLink`](#sdkmcpresourcelink) 항목의 `resourceLinks` 배열을 가진 객체입니다. Claude는 각 링크를 `tool_result` 블록의 텍스트 한 줄로 받으므로, 해당 텍스트를 파싱하는 대신 `resourceLinks`를 읽어 서버가 반환한 파일을 렌더링하세요. Claude Code는 결과에 링크가 없을 때와 서브에이전트의 결과에서는 `resourceLinks`를 생략하고, 결과당 최대 50개의 링크를 유지하며, 배열이 직렬화된 JSON 기준 64KiB에 도달하면 링크 추가를 중단합니다. `resourceLinks`에는 Agent SDK v0.3.257 이상이 필요합니다.
* [`structuredContent`](#calltoolresult)를 반환하는 MCP 도구: `tool_use_result`는 `structuredContent` 멤버에 서버가 보낸 내용을, `content` 멤버에 [`McpOutput`](#mcpoutput) 값을 담은 객체입니다. 서브에이전트의 결과에는 `structuredContent`가 포함되지 않습니다.
* `structuredContent`가 JSON으로 직렬화했을 때 1,048,576자를 넘는 MCP 도구: Claude Code는 `tool_use_result`에서 `structuredContent`를 제외하고 그 자리에 `structuredContentOmitted: true`를 설정하므로, 애플리케이션은 삭제된 객체와 아무것도 보내지 않은 도구를 구분할 수 있습니다. `content`와 `resourceLinks` 같은 다른 멤버는 유지되며, Claude가 받는 내용은 바뀌지 않습니다. Claude Code v2.1.287 이상에서 이 상한을 적용합니다. 두 종류의 도구는 다르게 동작합니다.
  * [인프로세스 SDK 서버](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md)의 도구는 예외이며 객체 전체를 전달합니다.
  * `tools/list` 항목에 [MCP Apps `ui://` 리소스](#mcpserverstatus)를 선언한 도구는 Claude Code v2.1.295 이상에서 8,388,608자로 제한되며, v2.1.295 이전 버전에서는 예외로 처리됩니다.

### `SDKUserMessageReplay`

필수 UUID가 있는 재생된 사용자 메시지입니다.

```typescript theme={null}
type SDKUserMessageReplay = {
  type: "user";
  uuid: UUID;
  session_id: string;
  message: MessageParam;
  parent_tool_use_id: string | null;
  isSynthetic?: boolean;
  client_composed?: true;
  tool_use_result?: unknown;
  origin?: SDKMessageOrigin;
  isReplay: true;
};
```

세션 외부에서 주입된 사용자 턴, 즉 [`origin`](#sdkmessageorigin) kind가 `peer` 또는 `channel`인 턴은 활성 턴 중에 전달되었든 세션이 유휴 상태일 때 새 턴을 시작했든 재생 메시지로 스트림에 도달합니다. v2.1.207 이전에는 세션이 유휴 상태일 때 전달된 주입 턴이 스트림에 메시지를 생성하지 않았으며, 트랜스크립트를 다시 읽을 때만 나타났습니다.

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
      api_error_status?: number | null;
      num_turns: number;
      result: string;
      stop_reason: string | null;
      ttft_ms?: number;
      ttft_stream_ms?: number;
      time_to_request_ms?: number;
      user_message_uuid?: string;
      user_message_uuids?: string[];
      resume_reason?: string;
      local_command?: string;
      request_sent_wall_ms?: number;
      first_content_frame_ms?: number;
      first_stream_post_ms?: number;
      first_stream_post_ack_ms?: number;
      first_stream_post_queue_wait_ms?: number;
      first_stream_post_queued_behind?: "durable_post" | "ephemeral_post" | "retry_backoff" | "hold" | "none";
      first_stream_post_wall_ms?: number;
      first_text_post_ms?: number;
      first_text_post_queue_wait_ms?: number;
      first_text_post_queued_behind?: "durable_post" | "ephemeral_post" | "retry_backoff" | "hold" | "none";
      first_text_post_wall_ms?: number;
      total_cost_usd: number;
      usage: NonNullableUsage;
      modelUsage: { [modelName: string]: ModelUsage };
      permission_denials: SDKPermissionDenial[];
      queued_turn_count?: number;
      structured_output?: unknown;
      deferred_tool_use?: { id: string; name: string; input: Record<string, unknown> };
      terminal_reason?: TerminalReason;
      result_index?: number;
      fast_mode_state?: FastModeState;
      fast_mode_disabled_reason?: FastModeDisabledReason;
      origin?: SDKMessageOrigin;
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
      queued_turn_count?: number;
      errors: string[];
      startup_failure_reason?: SDKStartupFailureReason;
      user_message_uuid?: string;
      user_message_uuids?: string[];
      resume_reason?: string;
      terminal_reason?: TerminalReason;
      result_index?: number;
      fast_mode_state?: FastModeState;
      fast_mode_disabled_reason?: FastModeDisabledReason;
      origin?: SDKMessageOrigin;
    };
```

결과의 여러 필드는 `subtype` 이상의 진단 정보를 제공합니다.

* `api_error_status`: 대화를 종료시킨 API 오류의 HTTP 상태 코드입니다. 턴이 API 오류 없이 끝난 경우 없거나 `null`입니다.
* `ttft_ms`: 첫 번째 완전한 어시스턴트 메시지가 도착한 시점에 측정한 첫 토큰까지의 시간(밀리초)입니다. success 분기에만 있습니다.
* `ttft_stream_ms`: 응답 스트림이 열리는 첫 번째 `message_start` 스트림 이벤트까지의 시간(밀리초)입니다. `ttft_ms`보다 작으며, 둘 사이의 차이는 첫 번째 메시지를 스트리밍하는 데 걸린 시간입니다. success 분기에만 있습니다.
* `time_to_request_ms`: 턴 시작부터 Claude Code가 API 요청을 보낼 때까지의 시간(밀리초)입니다. success 분기에만 있습니다. Claude Code v2.1.162 이상이 필요합니다.
* `user_message_uuid`: 이 턴이 응답한, 사용자가 보낸 메시지의 `uuid`입니다. 어떤 결과에 포함되는지는 [`user_message_uuid`](#user_message_uuid)를 참조하세요.
* `user_message_uuids`: 이 턴에서 Claude Code가 응답한, 사용자가 보낸 모든 메시지의 `uuid`입니다. [`user_message_uuids`](#user_message_uuids)를 참조하세요.
* `resume_reason`: 이 턴이 재시작으로 중단된 턴을 이어가는 이유입니다. 두 분기 모두에 있습니다. [`resume_reason`](#resume_reason)을 참조하세요.
* `local_command`: 턴이 디스패치한 명령의 이름으로, `/compact`처럼 에이전트 루프에 진입하지 않고 명령이 완료한 턴의 success 결과에 있습니다. 이름은 소문자와 밑줄로 변환되므로 `/reload-plugins`는 `reload_plugins`로 보고됩니다. MCP 서버가 제공하는 명령과 기본 제공 `/mcp`는 `mcp`로 보고됩니다. 사용자가 직접 정의한 명령은 `custom`으로 보고됩니다. 인수는 절대 포함되지 않습니다. 에이전트 루프에 진입한 모든 턴과 명령을 실행하지 않은 전송에는 없습니다. Agent SDK v0.3.268 이상이 필요합니다.
* `request_sent_wall_ms`: 서버 측 타임스탬프와 조인하기 위한, Claude Code가 API 요청을 디스패치한 시점의 epoch 밀리초입니다. API 요청을 보낸 턴의 `is_error`가 false인 success 결과에서 [`user_message_uuid`](#user_message_uuid)와 함께일 때만 있습니다.
* `first_content_frame_ms`: 첫 번째 `content_block_start` 또는 `content_block_delta` 스트림 이벤트까지의 시간(밀리초)이며, thinking 블록도 콘텐츠로 계산합니다. success 분기에서 `is_error`가 false일 때만 있습니다. Agent SDK v0.3.260 이상이 필요합니다.
* `first_stream_post_ms`, `first_stream_post_ack_ms`, `first_stream_post_wall_ms`: 턴의 첫 번째 스트림 이벤트를 업로드하는 데 걸린 시간입니다. Claude Code는 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)처럼 claude.ai로 스트리밍하는 세션에서만 이를 기록하며, `query()`가 생성하는 결과에는 포함되지 않습니다. Agent SDK v0.3.260 이상이 필요합니다.
* `usage`: 메인 에이전트 루프만 해당합니다. 서브에이전트와 보조 모델 호출은 제외되며, 스트리밍 입력 세션에서는 턴별 값입니다. 토큰/비용 집계에는 `modelUsage`를 사용하는 것이 좋습니다.
* `modelUsage`: 이 `query()` 호출 동안 쿼리 파이프라인을 통해 이루어진 모든 모델 호출의 모델별 합계로, 메인 루프, 서브에이전트, 그리고 압축 및 Workflow 에이전트 같은 내부 호출을 포함합니다. 권한 분류기와 토큰 계산 요청처럼 해당 파이프라인 밖의 헬퍼 호출은 제외됩니다. 세션을 재개하는 호출은 [세션의 이전 호출에서 복원된 모델별 합계](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#accumulate-costs-across-multiple-calls)도 포함합니다. 스트리밍 입력 세션에서는 합계가 턴에 걸쳐 누적되므로, 결과들을 합산하지 말고 최신 결과를 읽으세요. 재설정에 대해서는 [스트리밍 입력 모드에서 비용 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#track-costs-in-streaming-input-mode)을, 0으로 초기화된 결과에 대해서는 [세션 충돌 후 합계 복구](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#recover-totals-after-a-session-crash)를 참조하세요.
* `total_cost_usd`: USD 기준 누적 예상 비용으로, `modelUsage`와 같은 호출을 포함하며 같은 시점에 재설정됩니다. 세션을 재개하는 호출은 [세션의 이전 호출에서 복원된 합계](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#accumulate-costs-across-multiple-calls)도 포함합니다. 이는 추정치이며 청구 내역서가 아닙니다. 정확도에 대한 주의 사항은 [비용 및 사용량 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md)을 참조하세요.
* `queued_turn_count`: Claude Code가 결과를 생성한 시점에 아직 대기 중인, 사용자가 `origin: { kind: "human" }`으로 보낸 메시지의 수입니다. `0`과 필드가 없는 경우의 의미는 [`queued_turn_count`](#queued_turn_count)를 참조하세요.
* `result_index`: 프로세스가 기록하는 모든 결과에 걸쳐 0부터 세는, 실행의 전달 순서에서 이 결과의 위치입니다. 두 분기 모두에 있습니다. 기록에 실패한 결과도 번호를 소비하므로, 순서에 빈틈이 있으면 결과가 손실된 것입니다. Agent SDK v0.3.268 이상이 필요합니다.
* `startup_failure_reason`: Claude Code가 시작을 거부한 이유로, 알려진 시작 실패로 종료하기 전에 기록하는 `error_during_execution` 결과에 있습니다. 값과 이를 포함하는 실패 유형은 [`startup_failure_reason`](#startup_failure_reason)을 참조하세요. Agent SDK v0.3.274 이상이 필요합니다.
* `terminal_reason`: 루프가 종료된 이유입니다. `"completed"`, `"max_turns"`, `"tool_deferred"`, `"aborted_streaming"`, `"aborted_tools"`, `"hook_stopped"`, `"stop_hook_prevented"`, `"background_requested"`, `"blocking_limit"`, `"rapid_refill_breaker"`, `"prompt_too_long"`, `"image_error"`, `"model_error"`, `"api_error"`, `"malformed_tool_use_exhausted"`, `"budget_exhausted"`, `"structured_output_retry_exhausted"`, `"tool_deferred_unavailable"`, `"turn_setup_failed"` 중 하나입니다.
* `fast_mode_state`: `"on"`, `"off"`, `"cooldown"` 중 하나입니다.
* `fast_mode_disabled_reason`: 현재 [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md)를 사용할 수 없는 이유입니다. 빠른 모드를 막는 것이 없으면 없지만, 요청이 여전히 표준 속도로 실행될 수 있습니다. 빠른 모드 속도 제한 이후의 쿨다운 동안 Claude Code는 이유 코드 없이 `fast_mode_state: "cooldown"`을 보고하며, 쿨다운이 만료되면 빠른 모드를 다시 활성화합니다. Claude Code v2.1.219 이상이 필요합니다.

가용성을 다시 판단하는 대신 이유 코드를 사용해 자체 UI에서 빠른 모드가 꺼진 이유를 설명하세요. 각 코드는 빠른 모드를 막은 검사를 나타냅니다.

| 이유 코드 | 의미 |
| - | - |
| `free` | 계정에 빠른 모드에 필요한 유료 구독 또는 사용량 크레딧이 없습니다 |
| `preference` | 조직에서 빠른 모드를 비활성화했습니다 |
| `extra_usage_disabled` | 계정의 사용량 크레딧이 꺼져 있습니다 |
| `network_error` | [가용성 검사](https://code.claude.com/docs/ko/fast-mode.md#use-fast-mode-behind-proxies-and-llm-gateways)가 `api.anthropic.com`에 연결하지 못했습니다 |
| `unknown` | Claude Code가 가용성을 판단하지 못했습니다 |
| `not_first_party` | 세션이 Anthropic API 이외의 공급자를 사용합니다 |
| `disabled_by_env` | [`CLAUDE_CODE_DISABLE_FAST_MODE`](https://code.claude.com/docs/ko/env-vars)가 설정되어 있습니다 |
| `model_not_allowed` | 빠른 모드 Opus 모델이 조직의 [`availableModels`](https://code.claude.com/docs/ko/model-config#restrict-model-selection) 허용 목록에 없습니다 |
| `sdk_opt_in_required` | 세션이 빠른 모드를 옵트인하지 않았습니다. [`settings`](#options) 옵션 또는 [`applyFlagSettings()`](#applyflagsettings)를 통해 `fastMode: true`를 전달하세요 |
| `pending` | 가용성 검사가 아직 완료되지 않았습니다 |

같은 필드 쌍이 [`SDKSystemMessage`](#sdksystemmessage)와 [`SDKControlInitializeResponse`](#sdkcontrolinitializeresponse)에도 나타나므로, 첫 번째 턴 전에 빠른 모드 상태를 읽을 수 있습니다.

`origin` 필드는 이 결과를 트리거한 사용자 메시지의 [`SDKMessageOrigin`](#sdkmessageorigin)을 전달합니다. `origin: { kind: "task-notification" }`을 담는 결과는 다음과 같습니다.

* **합성 후속 턴**: SDK가 완료된 백그라운드 작업 등을 위해 합성 후속 턴을 주입하면, 그 결과로 생성되는 `SDKResultMessage`가 이 kind를 담습니다
* **실행된 예약 작업 및 다른 세션의 메시지**: 트리거가 실행된 클라우드 예약 작업과 사용자의 다른 세션에서 온 서버 검증 메시지도 이 kind로 도착하며, 각각 [작업 알림 subkind](#task-notification-subkinds)에 설명된 `subkind`를 가집니다

라우팅하거나 숨기기 전에 `kind`를 확인하여 프롬프트에 대한 응답 결과와 주입된 후속 결과를 구분하세요. 애플리케이션이 [예약 실행을 선언](#declare-a-scheduled-run)하는 경우 그 결과도 `kind: "task-notification"`을 담으므로, `kind`만으로 숨기지 마세요.

여러 백그라운드 작업 완료가 함께 대기열에 있을 때, Claude Code는 각각 한 턴씩이 아니라 한 턴에서 모두 응답할 수 있습니다. 각 완료는 여전히 이 origin을 가진 자체 결과를 생성합니다. Claude Code가 함께 응답하는 완료 중 마지막을 제외한 모든 완료는 순서대로 `num_turns: 0`인 빈 결과를 생성하며, 마지막 완료의 결과에 모두에 응답하는 턴이 담깁니다.

시작 오류처럼 사용자 턴 이전에 발생한 결과에는 이 필드가 없습니다.

`PreToolUse` 훅이 `permissionDecision: "defer"`를 반환하면, 결과는 `stop_reason: "tool_deferred"`를 가지며 `deferred_tool_use`에 보류 중인 도구의 `id`, `name`, `input`이 담깁니다. 이 필드를 읽어 자체 UI에 요청을 표시한 다음, 같은 `session_id`로 재개하여 계속하세요. 전체 흐름은 [나중을 위해 도구 호출 연기](https://code.claude.com/docs/ko/hooks.md#defer-a-tool-call-for-later)를 참조하세요.

#### `user_message_uuid`

턴이 응답하는 [`SDKUserMessage`](#sdkusermessage)의 `uuid`로, Claude Code의 응답을 사용자가 보낸 메시지와 매칭할 수 있도록 그대로 반환됩니다. Claude Code는 메시지에 `uuid`를 설정한 경우에만 이를 반환합니다. 이 필드는 `SDKUserMessage`에서 선택 사항이며, `query()`에 전달된 문자열 프롬프트에는 포함되지 않습니다.

턴이 어떤 메시지에 응답하는지는 턴이 시작된 방식에 따라 다릅니다.

* **사용자가 보낸 일반 메시지**, 즉 `isSynthetic: true`가 없는 메시지: 턴은 실행 내내 해당 메시지에 응답합니다. 여러 메시지를 짧은 간격으로 보내면 Claude Code가 이를 하나의 턴으로 병합할 수 있으며, 이때 이 필드에는 마지막 메시지의 `uuid`만 담깁니다. 병합된 메시지 중 어느 것과든 응답을 매칭하려면 [`user_message_uuids`](#user_message_uuids)를 사용하세요.
* **사용자가 `isSynthetic: true`로 보낸 메시지**: 턴은 처음에 해당 메시지에 응답합니다. Claude Code가 도구 호출 사이에 사용자의 일반 메시지를 받아들이면, 그때부터 턴은 받아들인 메시지에 응답합니다. 합성 메시지의 `uuid`를 반환하려면 Agent SDK v0.3.265 이상이 필요하며, 이전 버전은 합성 턴에서 아무것도 반환하지 않습니다.
* **[`CLAUDE_CODE_RESUME_INTERRUPTED_TURN`](https://code.claude.com/docs/ko/env-vars)에 따라 중단된 턴을 이어가기 위해 Claude Code가 생성하는 프롬프트**: 중단된 턴의 마지막 프롬프트가 사용자가 보낸 일반 메시지인 경우(턴을 시작한 메시지이든 턴 중에 Claude Code가 가져온 메시지이든), 이어가는 턴은 처음에 해당 메시지에 응답합니다. [`resume_reason`](#resume_reason)으로 이어가는 턴의 프레임과 중단된 시도의 프레임을 구분할 수 있습니다. 마지막 프롬프트가 사용자의 일반 메시지가 아니면, 이어가는 턴은 처음에 사용자의 어떤 메시지에도 응답하지 않습니다. Claude Code가 도구 호출 사이에 사용자의 일반 메시지를 가져오면, 그때부터 턴은 가져온 메시지에 응답합니다. 중단된 턴의 프롬프트를 되돌려 보내려면 Agent SDK v0.3.268 이상이 필요합니다.
* **Claude Code가 자체적으로 생성한 기타 프롬프트**: 턴은 처음에 사용자의 어떤 메시지에도 응답하지 않으며 프레임에 반환 값이 없습니다. Claude Code가 도구 호출 사이에 사용자의 일반 메시지를 받아들이면, 그때부터 턴은 해당 메시지에 응답합니다. 받아들인 메시지의 반환에는 Agent SDK v0.3.265 이상이 필요하며, 이전 버전은 이러한 턴에서 아무것도 반환하지 않습니다.

Claude Code는 응답한 메시지의 `uuid`를 세 종류의 프레임에 반환합니다.

* **결과**: 사용자가 보낸 메시지에 응답한 턴의 모든 결과입니다. Agent SDK v0.3.265 이상에서는 그러한 모든 결과에 포함됩니다. v0.3.265 이전에는 일반 메시지로 시작된 턴의 success 결과라도 턴이 API 요청을 보내지 않았거나 연기된 도구 호출로 끝난 경우 포함되지 않았습니다. v0.3.246 이전에는 오류 결과에도 포함되지 않았으며, v0.3.216 이전에는 모든 결과에 포함되지 않았습니다.
* **턴의 첫 번째 응답**: 첫 번째 [어시스턴트 메시지](#sdkassistantmessage), 그리고 `includePartialMessages`를 사용할 경우 `event.type`이 `ping`이 아닌 첫 번째 [스트림 이벤트](#sdkpartialassistantmessage)에도 포함되므로, 결과가 도착하기 전에 응답을 연결할 수 있습니다. 첫 번째 응답 반환에는 Agent SDK v0.3.246 이상이 필요합니다. v0.3.269 이전에는 `includePartialMessages`를 사용할 때 Claude Code가 첫 번째 스트림 이벤트에만 설정했으며, 턴이 아무것도 스트리밍하지 않은 경우에는 첫 번째 어시스턴트 메시지에 설정했습니다. Agent SDK v0.3.265 이상에서는 턴이 응답하는 메시지가 턴 도중 바뀌면 변경 후 첫 번째 응답에도 이 필드가 포함됩니다. 이전 버전은 턴당 하나의 응답 프레임에만 설정했습니다.
* **턴의 모든 [`thinking_tokens`](#sdkthinkingtokensmessage) 프레임**: 턴의 첫 번째 응답을 기다리지 않고 사고 진행 상황을 사용자가 보낸 메시지에 귀속시킬 수 있습니다. Agent SDK v0.3.260 이상이 필요합니다.

Claude Code는 다음 경우에 이 필드를 생략합니다.

* 위의 첫 번째 응답 이외의 응답 프레임
* 서브에이전트 프레임
* 사용자의 어떤 메시지에도 응답하지 않거나, `uuid` 없이 보낸 메시지에 응답하는 턴
* 충돌한 워커 프로세스 이후의 0으로 초기화된 결과처럼, 사용자가 보낸 어떤 메시지에도 응답하지 않는 결과

[`UserPromptSubmit`](https://code.claude.com/docs/ko/hooks#userpromptsubmit) 훅이 자체 턴을 시작하는 메시지를 차단하거나 `continue: false`로 중지하더라도 해당 메시지에 대한 결과는 여전히 받습니다. 이는 `is_error: false`와 `num_turns: 0`을 가진 성공 결과이며, `result`는 [차단 메시지](https://code.claude.com/docs/ko/hooks.md#what-a-blocked-prompt-leaves-behind) 또는 [중지 메시지](https://code.claude.com/docs/ko/hooks.md#json-output)이고, 다른 결과와 같은 규칙에 따라 메시지의 `uuid`를 반환합니다. 이 결과에는 `terminal_reason`이 없으며, `result` 텍스트 외에는 훅이 턴을 종료했음을 나타내는 것이 없습니다. 다른 턴이 실행 중일 때 훅이 차단한 메시지는 결과를 받지 못할 수 있습니다. [`user_message_uuids`](#user_message_uuids)를 참조하세요.

#### `user_message_uuids`

이 턴에서 Claude Code가 응답한, 사용자가 보낸 모든 메시지의 `uuid`입니다. 여러 메시지를 짧은 간격으로 보내면 Claude Code가 이를 하나의 턴으로 병합할 수 있으며, 이때 `user_message_uuid`는 그중 마지막 메시지만 나타냅니다. 병합된 메시지 중 어느 것과든 응답을 매칭하려면 이 목록에서 해당 메시지의 `uuid`를 찾으세요. Agent SDK v0.3.259 이상이 필요합니다.

Claude Code는 `user_message_uuid` 필드를 가진 각 응답 프레임과 결과에 이 목록을 함께 설정합니다. 응답한 메시지의 `uuid`를 반환하는 턴 프레임의 전체 목록과 각각에 필요한 버전은 [`user_message_uuid`](#user_message_uuid)를 참조하세요. 목록에는 항상 `user_message_uuid`가 포함되며 최대 64개 항목을 담습니다.

Claude Code가 턴 실행 중에 보낸 일반 메시지를 가져오면, 해당 메시지의 `uuid`를 결과의 목록에 추가합니다. [`UserPromptSubmit`](https://code.claude.com/docs/ko/hooks#userpromptsubmit) 훅이 가져오는 시점에 메시지를 차단하면 Claude Code는 대신 메시지를 폐기합니다. 메시지는 Claude에 도달하지 않으며 이후 턴을 위해 보관되지도 않습니다. 해당 메시지에 대한 결과는 없으며, 그 `uuid`는 어떤 결과의 목록에도 나타나지 않습니다. 훅이 메시지를 차단할 수 있다면, 턴 실행 중에 보낸 메시지가 나열된 결과를 기다릴 때 타임아웃을 설정하세요.

이는 훅의 출력이 차단만 있는 경우에 해당합니다. 출력이 `decision: "block"`과 함께라도 `continue: false`를 설정하거나, 훅이 `continueOnBlock: true` 없이 [`ok: false`](https://code.claude.com/docs/ko/hooks#response-schema)로 응답하는 프롬프트 훅인 경우, Claude Code는 메시지를 폐기하지 않고 중지합니다. 메시지는 자체 턴을 기다리고, 해당 메시지에 대한 결과를 받으며, 텍스트가 대화에 남으므로 Claude는 다음 턴에서 이를 봅니다.

첫 번째 응답이나 결과에 목록 없이 `user_message_uuid`만 있다면 이전 Claude Code 버전에서 온 것이므로 단일 필드를 사용하세요.

#### `resume_reason`

이 턴이 재시작으로 중단된 턴을 이어가는 이유입니다. Claude Code는 [`CLAUDE_CODE_RESUME_INTERRUPTED_TURN`](https://code.claude.com/docs/ko/env-vars)에 따라 중단된 턴을 이어가는 턴에 이 필드를 설정하므로, 이어가는 턴의 응답 및 결과를 중단된 시도의 것과 구분할 수 있습니다. Agent SDK v0.3.268 이상이 필요합니다.

Claude Code는 두 종류의 프레임에 이 필드를 설정합니다.

* **이어가는 턴의 결과**: 성공 분기와 오류 분기 모두에, 결과에 `user_message_uuid`가 포함되는지 여부와 관계없이 설정합니다.
* **이어가는 턴의 응답 프레임**: [`user_message_uuid`](#user_message_uuid)를 포함하는 프레임입니다.

값은 `interrupted_turn` 같은 짧은 소문자 토큰입니다.

#### `queued_turn_count`

Claude Code가 결과를 생성한 시점에 명령 대기열에서 아직 대기 중인, 사용자가 [`origin: { kind: "human" }`](#sdkmessageorigin)으로 보낸 메시지의 수입니다. Agent SDK v0.3.242 이상이 필요합니다.

`0`과 필드가 없는 경우의 의미는 다음과 같습니다.

* **`0`**: Claude Code는 해당 `origin` 없이 보낸 메시지와 작업 알림은 세지 않으므로, 여전히 턴이 뒤따를 수 있습니다.
* **없음**: 충돌 또는 치명적인 시작 오류 후 Claude Code가 내보내는 최종 결과는 이 필드를 생략하며, [합계가 0으로 초기화되어 있을 수 있습니다](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#recover-totals-after-a-session-crash).

#### `startup_failure_reason`

Claude Code가 시작을 거부한 이유로, 애플리케이션이 재시도 대신 해결 방법을 제시할 수 있게 합니다. Claude Code는 알려진 시작 실패로 종료하기 전에 기록하는 `error_during_execution` 결과에 이를 설정합니다. 해당 결과는 0으로 초기화된 합계를 가지며, `errors` 배열에는 stderr와 같은 텍스트가 담깁니다. 다른 모든 결과에는 이 필드가 없습니다. Agent SDK v0.3.274 이상이 필요합니다.

모든 `SDKStartupFailureReason` 값에 대해 이 결과를 받으려면 [`env`](#options)에서 `CLAUDE_CODE_STARTUP_FAILURE_RESULTS`를 `1`로 설정하세요. 이 변수가 없으면 Claude Code는 다음 실패에 대해서만 결과를 기록하며, 나머지는 stderr 출력과 0이 아닌 종료 코드로 끝나고 결과 메시지는 없습니다.

* Claude Code가 [세션을 해당 worktree로 되돌릴 수 없어](https://code.claude.com/docs/ko/worktrees.md#the-session-resumes-outside-its-worktree) 중단한 재개로, `worktree_unverified` 또는 `worktree_resume_refused`를 가집니다. 어떤 오류가 어떤 값을 가지는지는 해당 섹션에 설명되어 있습니다.
* 백그라운드 세션이 보유한 대화에 대한 거부된 [`continue`](#options)로, `session_held_by_background`를 가집니다. 그러한 대화에 대한 거부된 [`resume`](#options)의 경우, Claude Code는 변수가 설정된 경우에만 결과를 기록합니다.

```typescript theme={null}
type SDKStartupFailureReason =
  | "org_pin_api_key_conflict"
  | "provider_not_allowed"
  | "org_verify_failed"
  | "org_pin_mismatch"
  | "managed_settings_invalid"
  | "remote_settings_required_unavailable"
  | "gateway_signin_required"
  | "gateway_access_denied"
  | "proxy_invalid"
  | "temp_dir_unusable"
  | "cwd_unavailable"
  | "shell_tool_missing"
  | "session_held_by_background"
  | "worktree_resume_refused"
  | "worktree_unverified"
  | "cli_version_too_old"
  | "bypass_root"
  | "org_config_required_unavailable"
  | "org_config_refused";
```

각 값은 하나의 거부 사유를 나타냅니다.

| 값 | 세션을 중단시킨 원인 |
| :- | :- |
| `org_pin_api_key_conflict` | 관리형 설정이 [퍼스트 파티 또는 Cloud 게이트웨이 로그인을 요구](https://code.claude.com/docs/ko/authentication.md#restrict-login-to-your-organization)하는데, 대신 Anthropic API 키, 인증 토큰 또는 `apiKeyHelper`가 구성되어 있습니다 |
| `provider_not_allowed` | 관리형 설정이 [이 머신에서 사용할 수 있는 API 공급자를 나열](https://code.claude.com/docs/ko/settings-reference.md#allowedproviders)하는데, 세션이 목록에 없는 공급자나 설정이 고정하지 않은 엔드포인트로 설정되어 있습니다. Claude Code v2.1.285 이상이 필요합니다 |
| `org_verify_failed` | 네트워크 장애나 취소된 토큰 등으로 인해 로그인의 조직을 고정값과 대조하여 확인할 수 없었습니다 |
| `org_pin_mismatch` | 로그인이 고정값에서 허용하지 않는 조직에 속합니다 |
| `managed_settings_invalid` | 관리형 정책 설정을 읽을 수 없거나, 고정값에 조직이 지정되지 않았거나, [관리형 모델 제한](https://code.claude.com/docs/ko/errors.md#managed-settings-block-the-default-model)으로 인해 Default 옵션에 허용되는 모델이 없습니다 |
| `remote_settings_required_unavailable` | 조직이 요구하는 관리형 설정을 로드할 수 없었습니다 |
| `gateway_signin_required` | [Cloud 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)가 이 로그인을 종료했습니다 |
| `gateway_access_denied` | Cloud 게이트웨이에 대한 관리형 설정 요청이 403으로 반환되었으며, 이는 게이트웨이의 [문제 해결 표](https://code.claude.com/docs/ko/claude-apps-gateway-deploy.md#troubleshooting)에서 다룹니다 |
| `proxy_invalid` | 프록시 설정이 완전한 URL이 아닙니다 |
| `temp_dir_unusable` | 사용자별 임시 디렉터리가 안전하지 않거나 생성할 수 없었습니다 |
| `cwd_unavailable` | 작업 디렉터리가 삭제 또는 이동되었거나 읽을 수 없습니다 |
| `shell_tool_missing` | Windows에서 사용할 수 있는 셸 도구가 없습니다. Git Bash가 없고, PowerShell이 없거나 `CLAUDE_CODE_USE_POWERSHELL_TOOL`로 꺼져 있습니다 |
| `session_held_by_background` | 재개하거나 계속하려는 대화가 [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)으로 실행 중입니다 |
| `worktree_resume_refused` | 세션의 worktree가 안전 검사에 실패했거나, 재개가 worktree 내부에서 시작되었습니다. 같은 재개를 다시 실행하면 worktree 없이 계속되는지 여부는 `errors`에 나옵니다 |
| `worktree_unverified` | 현재 세션의 worktree를 확인할 수 없었으며, 재시도하면 성공할 수 있습니다 |
| `cli_version_too_old` | 이 Claude Code 버전이 Anthropic이 요구하는 최소 버전보다 낮습니다 |
| `bypass_root` | root로 실행 중인 상태에서 bypass permissions 모드가 요청되었습니다 |
| `org_config_required_unavailable` | 세션을 시작하려면 조직의 정책과 관리형 설정이 필요한데, 네트워크 장애나 Anthropic 서버 오류 등으로 인해 로드할 수 없습니다. Agent SDK v0.3.293 이상이 필요합니다 |
| `org_config_refused` | 로그인이 만료되었거나 취소되었거나, 조직이 이 계정에 Claude Code를 허용하지 않는 등의 이유로 Anthropic이 이 로그인에 대해 조직의 정책과 관리형 설정 제공을 거부했습니다. Agent SDK v0.3.293 이상이 필요합니다 |

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
    source?: string;
  }[];
  model: string;
  permissionMode: PermissionMode;
  slash_commands: string[];
  terminal_slash_commands?: string[];
  output_style: string;
  skills: string[];
  plugins: { name: string; path: string }[];
  plugin_errors?: {
    plugin: string;
    type: string;
    message: string;
    path?: string;
  }[];
  fast_mode_state?: FastModeState;
  fast_mode_disabled_reason?: FastModeDisabledReason;
  effort?: "low" | "medium" | "high" | "xhigh" | "max" | null;
  capabilities?: string[];
};
```

`fast_mode_state`는 세션의 [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md) 상태를 보고합니다. 빠른 모드를 막는 것이 있으면 `fast_mode_disabled_reason`이 이를 막은 검사를 나타내며, 이 필드에는 Claude Code v2.1.219 이상이 필요합니다. 이유 코드와 그 의미는 결과 메시지의 [`fast_mode_disabled_reason`](#sdkresultmessage)을 참조하세요.

`terminal_slash_commands`는 `slash_commands` 중 인터페이스가 로컬 터미널에 묶인 항목(예: `exit`)을 나열합니다. `slash_commands`의 다른 항목처럼 보낼 수 있으며, 이 필드는 원격 또는 모바일 클라이언트가 명령 메뉴에서 이를 숨길 수 있도록 존재합니다. 이 필드는 비어 있지 않을 때만 있으며, Agent SDK v0.3.229 이상이 필요합니다.

* 각 `mcp_servers` 항목의 `source`: 서버 정의의 출처로, [`McpServerStatus`](#mcpserverstatus)의 `source`와 같은 값을 가집니다. Agent SDK v0.3.274 이상이 필요합니다.
* `effort`: 세션의 다음 턴에 설정된 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)이며, Claude Code가 수준을 보내지 않으면 `null`입니다. Claude Code는 [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 클라이언트에 보내는 init 메시지에만 이 필드를 설정하며, 애플리케이션이 읽는 init 메시지에서는 생략합니다. Agent SDK v0.3.234 이상이 필요합니다.

`capabilities` 배열은 이 CLI가 구현하는 프로토콜 동작을 나열하므로, `claude_code_version` 문자열을 비교하는 대신 기능을 감지할 수 있습니다. 이는 열린 집합입니다. 인식하지 못하는 값은 무시하고, 의존하는 동작에 해당하는 특정 capability를 확인하세요. 이 필드에는 Claude Code v2.1.205 이상이 필요하며 이전 CLI에는 없습니다.

| Capability | 의미 |
| - | - |
| `interrupt_receipt_v1` | [`interrupt()`](#query-object)가 인터럽트 도착 시점에 보류 중이던 메시지를 나열하는 [`SDKControlInterruptResponse`](#sdkcontrolinterruptresponse) 영수증으로 resolve됩니다 |
| `interrupt_cancel_queued_v1` | `interrupt` 제어 요청이 `cancel_queued: true`를 적용하여, 영수증에서 `still_queued` 아래에 나열되었을 메시지를 취소하고 대신 `cancelled` 아래에 나열합니다. [`SDKControlInterruptResponse`](#sdkcontrolinterruptresponse)를 참조하세요. Claude Code v2.1.219 이상이 필요합니다 |
| `sdk_mcp_manifests` | `initialize` 제어 요청이 프로세스 내 [SDK MCP 서버](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md)에서 캡처한 MCP 핸드셰이크 결과인 `sdkMcpServerManifests`를 받습니다. Claude Code는 v2.1.286 이상에서 이 capability를 알립니다 |
| `sdk_mcp_tools_list_changed` | [SDK MCP 서버](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md)의 `tools/list_changed` 알림이 Claude Code가 해당 서버의 도구를 다시 나열하게 하므로, 서버가 세션 도중 추가한 도구가 Claude에 도달합니다. Claude Code는 v2.1.286 이상에서 이 capability를 알립니다 |

`plugin_errors` 배열은 플러그인 로드 실패를 나열합니다. 항목은 로드되지 않아 `plugins`에 없는 플러그인, 또는 hooks 파일처럼 일부 구성 요소 없이 로드된 플러그인을 설명합니다. 실패한 것이 없으면 키가 생략됩니다. `SDKSystemMessage`는 Agent SDK v0.3.283 이상에서 `plugin_errors`를 선언합니다.

[`plugins` 옵션](#options)의 디렉터리나 아카이브 자체가 로드에 실패하면, 항목의 `plugin` 필드에는 플러그인 이름 대신 `inline[0]` 같은 위치 태그가 담깁니다. 예를 들어 경로가 존재하지 않거나 매니페스트가 유효하지 않을 때 이런 일이 발생합니다. 그러한 항목은 `path` 필드로 옵션과 매칭하세요.

아래 표는 각 `plugin_errors` 항목의 필드를 나열합니다.

| 필드 | 타입 | 설명 |
| - | - | - |
| `plugin` | `string` | 실패한 플러그인의 ID이며, 플러그인 디렉터리나 아카이브 자체가 로드에 실패한 경우 `inline[0]` 같은 위치 태그입니다 |
| `type` | `string` | `path-not-found` 또는 `manifest-validation-error` 같은 열린 집합의 오류 범주입니다. 인식하지 못하는 값은 일반 실패로 처리하세요 |
| `message` | `string` | 실패를 설명하는 표시용 텍스트입니다 |
| `path` | `string` | 플러그인 디렉터리나 아카이브 자체가 로드에 실패한 경우에만 있습니다. 절대 경로이며, `plugins` 옵션의 상대 경로는 [`cwd`](#options) 옵션을 기준으로 해석됩니다 |

### `SDKPartialAssistantMessage`

스트리밍 부분 메시지입니다(`includePartialMessages`가 true인 경우에만).

`parent_tool_use_id` 필드는 항상 `null`입니다. 스트림 이벤트는 메인 세션에 대해서만 생성됩니다. 서브에이전트 귀속에는 [`agent_id`](#sdkassistantmessage)와 `parent_tool_use_id`를 가진 완전한 메시지를 사용하거나, [`forwardSubagentText`](#options)를 활성화하여 서브에이전트의 텍스트와 사고를 완전한 메시지로 받으세요.

```typescript theme={null}
type SDKPartialAssistantMessage = {
  type: "stream_event";
  event: BetaRawMessageStreamEvent; // From Anthropic SDK
  parent_tool_use_id: string | null;
  uuid: UUID;
  session_id: string;
  ttft_ms?: number; // Time to first token in ms, present only on message_start events
  user_message_uuid?: string;
  user_message_uuids?: string[];
  resume_reason?: string;
};
```

Claude Code는 [`user_message_uuid`](#user_message_uuid)에 설명된 조건에 따라 턴의 ping이 아닌 첫 번째 스트림 이벤트에 `user_message_uuid`와 `user_message_uuids`를 설정하고, 턴이 응답하는 메시지가 바뀔 때 다시 설정합니다. 재시작으로 중단된 턴을 이어가는 턴인 경우, 해당 필드를 포함하는 스트림 이벤트에는 [`resume_reason`](#resume_reason)도 포함됩니다.

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

### `SDKInformationalMessage`

루프가 내보내는 일반 텍스트 배너입니다. Claude Code가 발생시키는 경고, 알림, 기타 오류가 아닌 상태 줄과 `UserPromptSubmit` 훅의 차단 사유 같은 훅 피드백을 담습니다.

Claude Code v2.1.227 이상에서는 훅의 [`systemMessage`](https://code.claude.com/docs/ko/hooks#json-output)가 이 메시지로 도착할 수 있으며, 각 줄 앞에 `PostToolUse:Bash says:`처럼 훅 이름이 붙습니다. 출력이 표시되는 방식은 훅 페이지의 각 [이벤트 섹션](https://code.claude.com/docs/ko/hooks.md#hook-events)에 설명되어 있습니다.

`content`를 주어진 `level`에 맞춰 일반 텍스트로 렌더링하세요.

```typescript theme={null}
type SDKInformationalMessage = {
  type: "system";
  subtype: "informational";
  content: string;
  level: "info" | "notice" | "suggestion" | "warning";
  tool_use_id?: string;
  prevent_continuation?: boolean;
  uuid: UUID;
  session_id: string;
};
```

### `SDKWorkerShuttingDownMessage`

워커가 정상적으로 종료될 때 내보내지며, 원격 클라이언트가 하트비트 타임아웃을 기다리는 대신 워커가 종료된 이유를 표시할 수 있게 합니다. `reason`은 호스트 CLI가 설정하는 짧은 snake\_case 문자열이며, `"host_exit"` 또는 `"remote_control_disabled"` 등이 있습니다. 실시간으로 스트리밍할 때만 이에 대응하세요. 재개된 세션은 이 메시지의 과거 인스턴스를 재생하므로, 그 경우에는 무시하세요.

```typescript theme={null}
type SDKWorkerShuttingDownMessage = {
  type: "system";
  subtype: "worker_shutting_down";
  reason: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKPluginInstallMessage`

플러그인 설치 진행 이벤트입니다. [`CLAUDE_CODE_SYNC_PLUGIN_INSTALL`](https://code.claude.com/docs/ko/env-vars)이 설정된 경우 내보내지므로, Agent SDK 애플리케이션이 첫 번째 턴 전에 마켓플레이스 플러그인 설치를 추적할 수 있습니다. `started`와 `completed` 상태는 전체 설치의 시작과 끝을 나타냅니다. `installed`와 `failed` 상태는 개별 마켓플레이스를 보고하며 `name`을 포함합니다.

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

### `SDKPermissionDeniedMessage`

권한 시스템이 대화형 프롬프트 없이 도구 호출을 거부할 때 내보내지는 스트림 이벤트입니다. 뒤따르는 `is_error` 도구 결과만 관찰하는 대신, 이 이벤트를 사용해 거부가 발생하는 즉시 UI에 표시하세요. 보고하는 거부 유형은 실행이 권한 프롬프트를 처리하는 방식에 따라 다릅니다.

* **[`canUseTool`](#canusetool) 콜백**과 기본값 [`permissionPrompts: 'host'`](#options)를 사용하는 경우: 권한 프롬프트는 콜백으로 전달되며, 이 이벤트는 Claude Code가 콜백을 호출하지 않고 자체적으로 결정한 거부를 보고합니다.
* **둘 다 없는 경우**: 단순 `-p` 실행, 또는 `canUseTool`과 `permissionPromptToolName`을 모두 설정하지 않은 `query()`는 [`PermissionRequest` 훅](https://code.claude.com/docs/ko/hooks-guide#limitations)이 허용하지 않는 한 프롬프트가 필요했을 모든 도구 호출을 거부하며, 이 이벤트는 Claude Code가 자체적으로 결정한 거부와 함께 이러한 거부도 보고합니다. v2.1.223 이전에는 콜백이 없는 실행에서 Claude Code가 이 이벤트를 내보내지 않았습니다.
* **MCP 프롬프트 도구**를 `permissionPromptToolName` 또는 [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 플래그로 설정하고 기본값 `permissionPrompts: 'host'`를 사용하는 경우: Claude Code는 자체적으로 결정한 규칙 거부를 포함하여 이 이벤트를 전혀 내보내지 않습니다.
* **[`permissionPrompts: 'none'`](#options)을 사용하는 경우**: `canUseTool`이나 MCP 프롬프트 도구가 함께 설정되어 있어도 Claude Code는 프롬프트가 필요했을 호출을 거부하며, 이 이벤트는 Claude Code가 자체적으로 결정한 거부와 함께 이러한 거부도 보고합니다. Claude Code v2.1.259 이상이 필요합니다.

모든 구성에서 이 이벤트는 `PreToolUse` 훅 경로에서 결정된 거부를 건너뜁니다. 훅이 호출 자체를 거부했든, 거부 규칙이 훅의 allow 또는 ask 결정을 재정의했든 마찬가지입니다. 또한 이 이벤트는 최선의 노력 방식으로 제공됩니다. 간혹 Claude Code가 이 이벤트를 내보내지 않고 거부를 기록할 수 있으므로, [결과 메시지](#sdkresultmessage)의 `permission_denials`가 공식적인 기록입니다.

```typescript theme={null}
type SDKPermissionDeniedMessage = {
  type: "system";
  subtype: "permission_denied";
  tool_name: string;
  tool_use_id: string;
  agent_id?: string;
  decision_reason_type?: string;
  decision_reason?: string;
  message: string;
  uuid: UUID;
  session_id: string;
};
```

| 필드 | 타입 | 설명 |
| - | - | - |
| `tool_name` | `string` | 거부된 도구의 이름입니다 |
| `tool_use_id` | `string` | 이 거부가 응답하는 `tool_use` 블록의 ID입니다 |
| `agent_id` | `string` | 거부된 호출이 서브에이전트 내부에서 발생한 경우의 서브에이전트 ID입니다. 호스트 측 라우팅을 위해 `can_use_tool`의 필드를 그대로 반영합니다 |
| `decision_reason_type` | `string` | 결정한 구성 요소의 판별자이며, `"rule"`, `"mode"`, `"classifier"`, `"asyncAgent"` 등이 있습니다 |
| `decision_reason` | `string` | 결정한 구성 요소가 제공하는 사람이 읽을 수 있는 사유이며, 가능한 경우에 제공됩니다 |
| `message` | `string` | `tool_result`로 모델에 반환되는 거부 메시지입니다 |

### `SDKPermissionDenial`

거부된 도구 사용에 대한 정보입니다.

```typescript theme={null}
type SDKPermissionDenial = {
  tool_name: string;
  tool_use_id: string;
  tool_input: Record<string, unknown>;
};
```

### `SDKContextUsage`

`/context` 보고서의 구조화된 형태로, `/context` 결과를 전달하는 [`SDKAssistantMessage`](#sdkassistantmessage)에 `context_usage`로 포함됩니다. Agent SDK v0.3.232 이상에서 이 타입을 내보냅니다. [`SDKControlGetContextUsageResponse`](#sdkcontrolgetcontextusageresponse)와 달리, `color`와 `gridRows` 같은 표시용 필드 없이 사용량 세부 내역을 렌더링하는 데 필요한 데이터만 담습니다. Claude Code는 메시지 스트림에 나타나지 않는 토큰 계산 API 요청으로 보고서를 계산합니다. [이러한 요청이 처리되는 방식](#sdkcontrolgetcontextusageresponse)을 참조하세요.

```typescript theme={null}
type SDKContextUsage = {
  model: string;
  total_tokens: number;
  raw_max_tokens: number;
  percentage: number;
  over_limit?: {
    tokens_over: number;
    kind: "hard_limit" | "compaction_window";
  };
  categories: SDKContextUsageCategory[];
  mcp_tools: {
    name: string;
    server_name: string;
    tokens: number;
  }[];
  memory_files: {
    path: string;
    type: string;
    tokens: number;
  }[];
  agents: {
    agent_type: string;
    source: string;
    tokens: number;
  }[];
  skills?: {
    name: string;
    source: string;
    plugin_name?: string;
    tokens: number;
  }[];
};
```

다음 표는 Claude Code가 각 필드에 넣는 내용을 나열합니다. `model`부터 `over_limit`까지의 필드는 세션 전체를 설명하고, 컬렉션 필드는 토큰을 개별 항목에 귀속시킵니다.

| 필드 | 타입 | 설명 |
| - | - | - |
| `model` | `string` | Claude Code가 사용량을 계산한 메인 루프의 모델이며, 서브에이전트의 모델이 아닙니다 |
| `total_tokens` | `number` | 사용 중인 토큰에 대한 Claude Code의 추정치입니다. 윈도우 크기로 제한되지 않으므로, 세션이 한도를 초과하면 `raw_max_tokens`를 넘을 수 있습니다 |
| `raw_max_tokens` | `number` | 모델의 컨텍스트 윈도우이며, 더 낮은 [자동 압축 윈도우](https://code.claude.com/docs/ko/model-config.md#context-window-and-auto-compaction)가 적용되는 경우 그 값입니다. 예를 들어 사용자가 설정한 값이나, 1M 토큰 윈도우를 가진 일부 모델에 Claude Code가 적용하는 200K 경계가 있습니다. Claude Code는 이 윈도우를 기준으로 `total_tokens`를 측정합니다 |
| `percentage` | `number` | `raw_max_tokens` 대비 `total_tokens`의 반올림된 백분율이므로, 세션이 한도를 초과하면 100을 넘을 수 있습니다 |
| `over_limit` | `object` | `total_tokens`가 `raw_max_tokens`를 초과할 때만 있습니다. `tokens_over`는 초과량이며, `kind`는 Claude Code가 윈도우를 결정한 방식을 나타냅니다 |
| `categories` | [`SDKContextUsageCategory`](#sdkcontextusagecategory)`[]` | 범주별 사용량 세부 내역의 행마다 하나의 항목입니다 |
| `mcp_tools` | `object[]` | 각 MCP 도구에 귀속된 토큰으로, `mcp__linear__create_issue` 같은 와이어 이름과 `server_name`을 포함합니다 |
| `memory_files` | `object[]` | 로드된 각 메모리 파일에 귀속된 토큰으로, `path`와 `type`에 `Project` 또는 `User` 같은 출처 레이블을 포함합니다 |
| `agents` | `object[]` | 각 사용자 정의 서브에이전트 정의에 귀속된 토큰으로, `projectSettings`, `userSettings`, `plugin` 같은 출처 식별자를 포함합니다. 기본 제공 서브에이전트는 나열되지 않습니다 |
| `skills` | `object[]` | 스킬 목록의 각 스킬에 귀속된 토큰으로, 출처 식별자와 플러그인 스킬의 경우 `plugin_name`에 플러그인 이름을 포함합니다. 토큰을 차지하는 스킬이 없으면 없습니다 |

`over_limit.kind`는 API가 다음 요청을 받아들이는지 여부가 아니라, Claude Code가 윈도우를 결정한 방식을 기록합니다.

* `hard_limit`: 윈도우가 Claude Code가 판단하는 모델 자체의 한도이며, 이를 넘으면 API가 요청을 거부합니다
* `compaction_window`: 윈도우가 압축 정책 윈도우이며, 모델의 한도와 일치할 수도 있고 그렇지 않을 수도 있습니다

Claude Code는 기존 필드의 형태를 바꾸는 대신 새 데이터를 선택적 필드로 추가하는 방식으로 이 타입을 확장합니다. 알고 있는 필드를 읽고 인식하지 못하는 필드는 무시하세요.

### `SDKContextUsageCategory`

`/context` 범주별 사용량 세부 내역의 한 행입니다.

```typescript theme={null}
type SDKContextUsageCategory = {
  name: string;
  tokens: number;
  kind: "used" | "free" | "buffer" | "deferred";
};
```

다음 표는 Claude Code가 행의 각 필드에 넣는 내용을 나열합니다.

| 필드 | 타입 | 설명 |
| - | - | - |
| `name` | `string` | `/context`가 출력하는 행의 표시 이름이며, `Messages` 등이 있습니다. 행은 이름이 아니라 `kind`로 분류하세요 |
| `tokens` | `number` | 행의 토큰 수입니다. 행의 토큰이 0일 수 있습니다 |
| `kind` | `string` | 행이 나타내는 것으로, `used`, `free`, `buffer`, `deferred` 중 하나입니다 |

각 `kind` 값은 행의 토큰이 무엇인지를 나타냅니다.

* `used`: 컨텍스트 윈도우를 차지하는 콘텐츠
* `free`: 남은 윈도우
* `buffer`: 압축 예비 공간
* `deferred`: Claude Code가 윈도우 밖에 보관하고 사용량 계산에서 제외하는 도구 스키마로, 참고용으로 나열됩니다

### `SDKUsageReport`

`/usage` 보고서의 구조화된 형태로, `/usage` 결과를 전달하는 [`SDKAssistantMessage`](#sdkassistantmessage)에 `usage_report`로 담깁니다. Agent SDK v0.3.273 이상에서 이 타입을 내보냅니다. 이 타입은 실험적이며 형태가 변경될 수 있습니다.

```typescript theme={null}
type SDKUsageReport = {
  session: {
    total_cost_usd: number;
    total_api_duration_ms: number;
    total_duration_ms: number;
    total_lines_added: number;
    total_lines_removed: number;
    model_usage: { [modelName: string]: ModelUsage };
  };
  rate_limits: {
    limits:
      | {
          kind: string;
          group: string;
          percent: number;
          resets_at: string | null;
          scope?: {
            model?: { display_name: string } | null;
            surface?: { display_name: string } | null;
          } | null;
          severity: string;
          is_active: boolean;
        }[]
      | null;
    extra_usage?: {
      is_enabled: boolean;
      monthly_limit: number | null;
      used_credits: number | null;
      utilization: number | null;
      currency?: string | null;
    } | null;
  } | null;
};
```

최상위 필드는 `session`과 `rate_limits`입니다.

* `session`: Claude Code의 누적 비용 및 사용량 합계로, [`SDKResultMessage`](#sdkresultmessage)의 `total_cost_usd` 및 `modelUsage`와 같은 장부에서 읽습니다. 각 `model_usage` 항목은 [`ModelUsage`](#modelusage)입니다.
* `rate_limits`: `limits`의 플랜 사용량 행과 `extra_usage`의 사용량 크레딧 지출입니다. 세션의 OAuth 토큰에 `user:profile` 범위가 없는 경우처럼 Claude Code가 플랜의 사용량을 가져올 수 없으면 `null`입니다.

Claude Code는 `session.total_cost_usd`를 토큰 수로부터 로컬에서 계산하므로, 이는 추정치이며 플랜에서 청구하는 금액이 아닙니다. 서버가 보고하는 사용량 크레딧 지출은 별도의 `extra_usage` 블록입니다. 정확도에 관한 주의 사항은 [비용 및 사용량 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md)을 참조하십시오.

`limits`는 서버가 보낸 그대로의 사용량 행을 담습니다. 어떤 미터가 적용되는지, 그 범위, 레이블, 심각도, 순서는 서버가 결정하므로 행을 그대로 렌더링하십시오.

* 빈 배열은 서버가 미터를 보고하지 않았음을 의미합니다.
* `null`은 Claude Code가 보고할 행이 없음을 의미합니다.

`limits`의 각 행은 하나의 사용량 미터를 설명합니다.

| 필드 | 타입 | 설명 |
| - | - | - |
| `kind` | `string` | `session`, `weekly_all`, `weekly_scoped` 같은 서버의 미터 종류입니다. 행은 레이블이 아니라 항상 이 값으로 분류하십시오 |
| `group` | `string` | `session` 또는 `weekly` 같은 서버의 행 그룹입니다. 행은 서버의 순서대로 이 그룹 아래에 묶여 렌더링됩니다 |
| `percent` | `number` | 사용된 윈도우의 비율, 0-100 |
| `resets_at` | `string \| null` | 윈도우가 재설정되는 ISO 8601 타임스탬프 |
| `scope` | `object \| null` | 선택 사항입니다. 범위가 지정된 행의 대상(모델 또는 사용 환경)과 서버의 표시 레이블 |
| `severity` | `string` | 미터 색상을 위한 행에 대한 서버의 판단으로, `normal`, `warning`, `critical` 등이 있습니다 |
| `is_active` | `boolean` | 단일 값 표시기가 보여 줄 행으로 서버가 선택한 행에서 `true` |

Agent SDK v0.3.277 이전에는 타입이 `severity`와 `is_active`를 선택 사항이자 nullable로 선언했으며, 행이 이 값 없이 도착할 수 있었습니다.

`extra_usage`는 서버가 보고하는 청구 기간의 [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) 지출과 상한으로, 플랜에 사용량 크레딧이 있을 때 존재합니다. 금액은 `currency`의 보조 단위이며, USD의 경우 센트입니다.

* 이 계정에 자체 지출 상한이 없으면 `monthly_limit`은 `null`입니다. Team 및 Enterprise 플랜에서는 `null`을 무제한으로 렌더링하지 마십시오.
* 사용량 크레딧으로 요청 비용을 지불할 수 없는 동안 `is_enabled`는 `false`입니다.

### `SDKMessageOrigin`

사용자 역할 메시지의 출처입니다. 이는 [`SDKUserMessage`](#sdkusermessage)에 `origin`으로 나타나며, 해당하는 [`SDKResultMessage`](#sdkresultmessage)로 전달되므로 특정 턴을 무엇이 트리거했는지 알 수 있습니다.

```typescript theme={null}
type SDKMessageOrigin =
  | { kind: "human" }
  | { kind: "channel"; server: string }
  | {
      kind: "peer";
      from: string;
      fromMode?: "bypass" | "prompting";
      name?: string;
      fromSession?: string;
      senderTaskId?: string;
      body?: string;
      verifiedPeerPid?: number;
    }
  | {
      kind: "task-notification";
      subkind?: "scheduled-trigger" | "peer-send-message";
      fireReason?: string;
      runId?: string;
    }
  | { kind: "coordinator" }
  | { kind: "auto-continuation" }
  | { kind: "unclassified" };
```

| `kind` | 의미 |
| - | - |
| `human` | 최종 사용자의 직접 입력입니다. 애플리케이션이 사용자가 입력한 내용을 사용자 메시지로 전달하는 경우, `origin`을 명시적으로 `{ kind: "human" }`으로 설정하세요. Claude Code는 `origin`이 없는 사용자 메시지를 귀속되지 않은 것으로 처리하며, [`ultracode` 워크플로 키워드](https://code.claude.com/docs/ko/workflows#ask-for-a-workflow-in-your-prompt)처럼 사람이 입력한 프롬프트를 요구하는 검사는 이를 받아들이지 않습니다. v2.1.210 이전에는 Claude Code가 사용자 메시지에 `origin`이 없으면 사람의 입력으로 처리했습니다. |
| `channel` | [채널](https://code.claude.com/docs/ko/channels.md)에서 도착한 메시지입니다. `server`는 출처 MCP 서버 이름입니다. |
| `peer` | 다른 에이전트의 메시지입니다. 프로세스 내 [팀원](https://code.claude.com/docs/ko/agent-teams.md) 또는 사용자의 다른 Claude Code 세션인 [세션 간 피어](https://code.claude.com/docs/ko/cross-session-messaging.md)가 해당합니다. 필드별 의미와 신뢰 모델은 [피어 origin 필드](#peer-origin-fields)를 참조하세요. |
| `task-notification` | 완료된 백그라운드 작업처럼 새 사용자 프롬프트 없이 도착하는 전달을 위해 주입된 합성 턴입니다. 해당 분기는 [`SDKTaskNotificationMessage`](#sdktasknotificationmessage)를 참조하세요. 애플리케이션이 [예약 실행으로 선언](#declare-a-scheduled-run)한 프롬프트도 이 kind를 가집니다. 선택적 `subkind`는 알림을 발생시킨 원인을 표시합니다. [Task-notification 하위 유형](#task-notification-subkinds)을 참조하세요. |
| `coordinator` | [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md)의 팀 코디네이터가 보낸 메시지입니다. |
| `auto-continuation` | 후속 프롬프트를 트리거하는 명령 결과처럼 새 사용자 입력 없이 세션이 계속될 때 주입되는 합성 턴입니다. |
| `unclassified` | 출처를 판단할 수 없는 주입 턴입니다. Claude Code v2.1.223 이상이 필요합니다. Claude Code가 `isSynthetic: true`인 [`SDKUserMessage`](#sdkusermessage)를 받았는데 다른 `kind`로 분류할 수 없으면, 메시지가 도착할 때 이 kind를 설정하고 해당 턴을 사람의 입력으로 처리하는 대신 사용자가 아닌 출처로 모델에 제시합니다. 애플리케이션에서는 이 값을 설정하지 않아야 합니다. |

### Task-notification 하위 유형

Claude Code가 세션에 작업 알림을 전달할 때, Anthropic 서버가 해당 알림의 출처를 검증한 경우 알림의 `origin`에 `subkind`를 설정합니다. 애플리케이션이 직접 [메시지를 예약 실행으로 선언](#declare-a-scheduled-run)한 경우에도 `subkind`를 설정하며, 이를 위해서는 TypeScript Agent SDK v0.3.280 이상이 필요합니다. `subkind`에는 Claude Code v2.1.213 이상이 필요하며, 두 값 중 하나를 가집니다.

* `scheduled-trigger`: 이 알림은 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)의 저장된 프롬프트로, 해당 작업의 트리거 중 하나가 실행되어 전달된 것입니다. 트리거에는 일정, [API 트리거](https://code.claude.com/docs/ko/routines.md#add-an-api-trigger), [GitHub 트리거](https://code.claude.com/docs/ko/routines.md#add-a-github-trigger), 또는 **Run now**가 있습니다. 애플리케이션이 [예약 실행으로 선언](#declare-a-scheduled-run)한 프롬프트도 이 값을 가집니다. Claude Code는 이를 세션에 할당된 작업으로 모델에 제시하며, [다른 작업 알림에 포함되는 안내](#sdktasknotificationmessage)와는 다른 안내를 사용합니다.
* `peer-send-message`: 알림이 사용자의 다른 세션이 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md) 간 메시지 전송에 사용하는 서버 측 `send_message` 도구로 보낸 메시지이며([세션 간 `SendMessage` 도구](https://code.claude.com/docs/ko/cross-session-messaging)가 아님), Anthropic 서버가 두 세션이 같은 비공개 세션 그룹에 속한다는 것을 검증했습니다. Claude Code v2.1.224 이상이 필요합니다. 서버가 그렇게 검증하지 않은 `send_message` 전달에는 subkind가 없습니다.

다른 모든 작업 알림에는 `subkind`가 없습니다. 여기에는 세션에 전달된 [PR 활동](https://code.claude.com/docs/ko/claude-code-on-the-web.md#how-claude-responds-to-pr-activity)과 완료된 작업 같은 백그라운드 이벤트가 포함됩니다. [세션 간 `SendMessage` 도구](https://code.claude.com/docs/ko/cross-session-messaging)의 메시지는 아예 작업 알림이 아닙니다. 같은 머신의 세션에서 왔든 Anthropic 서버를 통해 다른 머신에서 왔든, Claude Code는 이 메시지에 `kind: "peer"`와 [피어 origin 필드](#peer-origin-fields)를 부여합니다.

`fireReason`은 `scheduled-trigger` 알림이 실행된 이유를 `scheduled`, `manual`, `retry`, `catch_up`, `api`와 같은 짧은 소문자 토큰으로 나타냅니다. Anthropic 서버는 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)의 전달에 이를 설정하고, 애플리케이션은 예약 실행을 선언할 때 이를 설정합니다. 둘 다 보내지 않은 경우에는 없습니다. TypeScript Agent SDK v0.3.280 이상이 필요합니다.

Claude가 [서브에이전트를 재개](https://code.claude.com/docs/ko/agent-sdk/subagents.md#resume-subagents)하는 경우처럼, 백그라운드 작업은 동일한 `task_id`로 여러 번 실행될 수 있습니다. 각 실행에는 고유한 [`run_id`](#sdktaskstartedmessage)가 있습니다. 실행의 알림이 사용자 메시지로 세션에 도달하면, 해당 메시지의 `task-notification` 출처에 있는 `runId`가 같은 값을 가집니다. 알림은 작업의 다음 실행이 시작된 후에 도착할 수도 있으며, 이 경우에도 이전 실행의 ID를 담고 있습니다. 턴이 어느 실행에 속하는지 구분하려면 `task_id`가 아니라 `runId`를 비교하세요. TypeScript Agent SDK v0.3.292 이상이 필요합니다.

#### 예약 실행 선언

애플리케이션이 자체 일정에 따라 프롬프트를 실행하는 경우, 각 실행을 선언하면 Claude Code가 해당 턴을 사용자의 실시간 입력이 아닌 예약 작업으로 모델에 제시합니다. [`env`](#options)에서 `CLAUDE_CODE_HOST_SCHEDULED_RUN`을 `1`로 설정하여 세션을 시작한 다음, `isSynthetic` 없이 `origin: { kind: "task-notification", subkind: "scheduled-trigger", fireReason: "scheduled" }`로 실행의 [`SDKUserMessage`](#sdkusermessage)를 보내세요. Claude Code는 해당 변수 없이 시작된 프로세스에서는 선언을 무시합니다. 환경에 [`CLAUDECODE`](https://code.claude.com/docs/ko/env-vars) 또는 `CLAUDE_CODE_CHILD_SESSION`이 있는 프로세스에서도 선언을 무시합니다. Claude Code는 값이 1\~32자의 소문자 또는 밑줄로 이루어진 경우에만 `fireReason`을 유지합니다. TypeScript Agent SDK v0.3.280 이상이 필요합니다.

### Peer origin 필드

`peer` origin은 메시지를 보낸 에이전트를 식별합니다. `SendMessage`로 `main`에 메시지를 보내는 프로세스 내 [팀원](https://code.claude.com/docs/ko/agent-teams.md), 또는 사용자의 다른 Claude Code 세션인 [세션 간 피어](https://code.claude.com/docs/ko/cross-session-messaging.md)가 이에 해당합니다. 세션 간 피어는 macOS와 Linux에서 Claude Code v2.1.224 이상이 필요합니다. 네이티브 Windows 요구 사항은 [세션 간 메시징 가용성](https://code.claude.com/docs/ko/cross-session-messaging.md#availability)을 참조하세요. 세션 간 피어는 같은 머신에서 실행될 수도 있고, 메시지가 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 통해 도착하는 경우 [사용자의 다른 머신](https://code.claude.com/docs/ko/cross-session-messaging.md#message-sessions-on-other-machines)에서 실행될 수도 있습니다.

* `from`: 팀원의 이름 또는 cross-session peer의 발신자 주소입니다. [단방향 cross-machine 메시지](https://code.claude.com/docs/ko/cross-session-messaging.md#message-sessions-on-other-machines)의 경우 발신자에게 회신 주소가 없으므로 `from`은 `"unknown"`입니다. 이 값은 발신자가 작성한 것이며, 검증된 신원은 `verifiedPeerPid`입니다.
* `fromMode`: 발신 세션의 권한 클래스(`bypass` 또는 `prompting`)로, [데스크톱 앱](https://code.claude.com/docs/ko/desktop.md#work-across-sessions)처럼 사용자의 세션 간에 peer 메시지를 중계하는 호스트가 선언합니다. Claude Code는 [인바운드 제어](https://code.claude.com/docs/ko/cross-session-messaging.md#control-inbound-messages)를 적용할 때 수신 세션에서 이 값을 읽습니다. Agent SDK v0.3.234 이상이 필요합니다.
* `senderTaskId`: 팀원의 작업 ID입니다. cross-session peer의 경우에는 존재하지 않습니다.
* `name`: Claude Code가 정규화한 발신자의 표시 이름입니다. Claude Code는 Unicode 제어, 서식, 서로게이트, 줄 또는 단락 구분자 코드 포인트를 제거한 다음, 결과의 앞뒤 공백을 제거하고 말줄임표를 붙여 최대 64개 코드 포인트로 제한합니다. Claude Code v2.1.205 이상이 필요합니다.
* `body`: 피어 엔벨로프를 제거한 디코딩된 메시지 본문으로, 모델이 보는 내용과 바이트 단위로 정확히 일치합니다. 단일 팀원 메시지에는 존재하며, 여러 메시지가 병합된 경우에는 존재하지 않습니다. 세션 간 피어의 경우 턴이 Claude Code가 구성한 정확히 하나의 피어 엔벨로프일 때만 존재합니다. 메시지 텍스트를 다시 파싱하는 대신 `name`과 `body`를 렌더링하세요. v2.1.299 이전에는 병합된 메시지가 첫 번째 메시지의 `body`를 유지했습니다. Claude Code v2.1.205 이상이 필요합니다.
* `fromSession`: 발신자의 호스트에서 열 수 있는 세션 ID로, UI가 발신 세션으로 다시 연결할 수 있도록 발신자의 호스트가 설정합니다. `from`과 마찬가지로 발신자가 주장하는 값이므로 탐색 대상으로만 사용하고, 발신자 신원의 증거로 취급하지 마세요. Claude Code v2.1.216 이상이 필요합니다.
* `verifiedPeerPid`: 이 세션의 cross-session 메시징 소켓에 연결한 프로세스의 프로세스 ID로, 커널이 검증하며 페이로드가 아닌 연결 자체에서 읽어옵니다. 발신자를 식별할 때는 `from`이 아닌 이 값을 사용하세요. `from`은 같은 사용자의 어떤 프로세스든 위조할 수 있습니다. Windows나 소켓이 아닌 유입 경로처럼 Claude Code가 검증할 수 없는 경우에는 이 필드가 존재하지 않으므로, 값이 없으면 발신자가 검증되지 않았다는 의미입니다. 중계된 트래픽의 경우 이 값은 메시지 작성자가 아닌 중계자를 식별하며, 프로세스 ID는 재사용될 수 있으므로 인증 토큰이 아닌 출처 정보로 취급하세요. Claude Code v2.1.216 이상이 필요합니다.

## 훅 타입

예제 및 일반적인 패턴을 포함한 훅 사용 가이드는 [훅 가이드](https://code.claude.com/docs/ko/agent-sdk/hooks.md)를 참조하세요.

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
  | "UserPromptExpansion"
  | "SessionStart"
  | "SessionEnd"
  | "Stop"
  | "StopFailure"
  | "SubagentStart"
  | "SubagentStop"
  | "PreCompact"
  | "PostCompact"
  | "PreModelSwitch"
  | "PostModelSwitch"
  | "PermissionRequest"
  | "PermissionDenied"
  | "Setup"
  | "TeammateIdle"
  | "TaskCreated"
  | "TaskCompleted"
  | "Elicitation"
  | "ElicitationResult"
  | "ConfigChange"
  | "DirectoryAdded"
  | "WorktreeCreate"
  | "WorktreeRemove"
  | "InstructionsLoaded"
  | "CwdChanged"
  | "FileChanged"
  | "MessageDisplay";
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
  | PermissionDeniedHookInput
  | NotificationHookInput
  | UserPromptSubmitHookInput
  | UserPromptExpansionHookInput
  | SessionStartHookInput
  | SessionEndHookInput
  | StopHookInput
  | StopFailureHookInput
  | SubagentStartHookInput
  | SubagentStopHookInput
  | PreCompactHookInput
  | PostCompactHookInput
  | PreModelSwitchHookInput
  | PostModelSwitchHookInput
  | PermissionRequestHookInput
  | SetupHookInput
  | TeammateIdleHookInput
  | TaskCreatedHookInput
  | TaskCompletedHookInput
  | ElicitationHookInput
  | ElicitationResultHookInput
  | ConfigChangeHookInput
  | InstructionsLoadedHookInput
  | DirectoryAddedHookInput
  | WorktreeCreateHookInput
  | WorktreeRemoveHookInput
  | CwdChangedHookInput
  | FileChangedHookInput
  | MessageDisplayHookInput;
```

### `BaseHookInput`

모든 훅 입력 타입이 확장하는 기본 인터페이스입니다.

```typescript theme={null}
type BaseHookInput = {
  session_id: string;
  transcript_path: string;
  cwd: string;
  prompt_id?: string;
  permission_mode?: string;
  effort?: { level: string };
  agent_id?: string;
  agent_type?: string;
};
```

`prompt_id` 필드는 현재 처리 중인 사용자 프롬프트를 식별하는 UUID입니다. [OpenTelemetry 이벤트의 `prompt.id` 속성](https://code.claude.com/docs/ko/monitoring-usage#event-correlation-attributes)과 일치하며 첫 번째 사용자 입력까지는 없습니다. Claude Code v2.1.196 이상이 필요합니다.

#### `PreToolUseHookInput`

```typescript theme={null}
type PreToolUseHookInput = BaseHookInput & {
  hook_event_name: "PreToolUse";
  tool_name: string;
  tool_input: unknown;
  tool_use_id: string;
  mcp_server?: McpServerProvenance;
};
```

`mcp_server`는 도구가 MCP 서버에서 올 때 나타납니다. [`McpServerProvenance`](#mcpserverprovenance)를 참조하세요. `PostToolUse`, `PostToolUseFailure`, `PermissionRequest` 및 `PermissionDenied` 입력은 동일한 필드를 전달합니다. 이 필드는 Agent SDK v0.3.274 이상이 필요합니다.

#### `PostToolUseHookInput`

```typescript theme={null}
type PostToolUseHookInput = BaseHookInput & {
  hook_event_name: "PostToolUse";
  tool_name: string;
  tool_input: unknown;
  tool_response: unknown;
  tool_use_id: string;
  duration_ms?: number;
  mcp_server?: McpServerProvenance;
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
  mcp_server?: McpServerProvenance;
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

#### `PermissionDeniedHookInput`

```typescript theme={null}
type PermissionDeniedHookInput = BaseHookInput & {
  hook_event_name: "PermissionDenied";
  tool_name: string;
  tool_input: unknown;
  tool_use_id: string;
  reason: string;
  mcp_server?: McpServerProvenance;
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
  session_title?: string;
};
```

#### `UserPromptExpansionHookInput`

```typescript theme={null}
type UserPromptExpansionHookInput = BaseHookInput & {
  hook_event_name: "UserPromptExpansion";
  expansion_type: "slash_command" | "mcp_prompt";
  command_name: string;
  command_args: string;
  command_source?: string;
  prompt: string;
};
```

#### `SessionStartHookInput`

```typescript theme={null}
type SessionStartHookInput = BaseHookInput & {
  hook_event_name: "SessionStart";
  source: "startup" | "resume" | "clear" | "compact" | "fork";
  agent_type?: string;
  model?: string;
  session_title?: string;
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
  background_tasks?: BackgroundTaskSummary[];
  session_crons?: SessionCronSummary[];
};
```

#### `StopFailureHookInput`

```typescript theme={null}
type StopFailureHookInput = BaseHookInput & {
  hook_event_name: "StopFailure";
  error: SDKAssistantMessageError;
  error_details?: string;
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
  background_tasks?: BackgroundTaskSummary[];
  session_crons?: SessionCronSummary[];
};

type BackgroundTaskSummary = {
  id: string;
  type: string;
  status: string;
  description: string;
  command?: string;
  agent_type?: string;
  server?: string;
  tool?: string;
  name?: string;
};

type SessionCronSummary = {
  id: string;
  schedule: string;
  recurring: boolean;
  prompt: string;
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

#### `PostCompactHookInput`

```typescript theme={null}
type PostCompactHookInput = BaseHookInput & {
  hook_event_name: "PostCompact";
  trigger: "manual" | "auto";
  compact_summary: string;
};
```

#### `PreModelSwitchHookInput`

요청된 모델 전환이 적용되기 전에 실행됩니다. `context_tokens` 및 그 이후의 필드는 새 모델로 대화를 다시 전송하는 비용을 추정합니다. 전체 필드 설명 및 차단 의미론은 [PreModelSwitch](https://code.claude.com/docs/ko/hooks.md#premodelswitch)를 참조하세요.

```typescript theme={null}
type PreModelSwitchHookInput = BaseHookInput & {
  hook_event_name: "PreModelSwitch";
  from_model: string;
  to_model: string;
  requested_model: string | null;
  source: "command" | "picker" | "sdk";
  context_tokens: number;
  prompt_cache_warm: boolean;
  cache_ttl: "5m" | "1h";
  estimated_cache_write_usd: number;
  pricing: "configured" | "catalog" | "default";
};
```

#### `PostModelSwitchHookInput`

세션의 모델이 변경된 후 실행됩니다. `PreModelSwitchHookInput`과 동일한 필드를 전달하며, 두 개의 추가 `source` 값이 있습니다. [PostModelSwitch](https://code.claude.com/docs/ko/hooks.md#postmodelswitch)를 참조하세요.

```typescript theme={null}
type PostModelSwitchHookInput = BaseHookInput & {
  hook_event_name: "PostModelSwitch";
  from_model: string;
  to_model: string;
  requested_model: string | null;
  source: "command" | "picker" | "sdk" | "auto" | "resume";
  context_tokens: number;
  prompt_cache_warm: boolean;
  cache_ttl: "5m" | "1h";
  estimated_cache_write_usd: number;
  pricing: "configured" | "catalog" | "default";
};
```

#### `PermissionRequestHookInput`

```typescript theme={null}
type PermissionRequestHookInput = BaseHookInput & {
  hook_event_name: "PermissionRequest";
  tool_name: string;
  tool_input: unknown;
  permission_suggestions?: PermissionUpdate[];
  mcp_server?: McpServerProvenance;
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
  /** @deprecated v2.1.178 이후로 사용되지 않음. 세션에서 파생된 팀 이름을 전달합니다. 제거될 예정입니다. */
  team_name: string;
};
```

#### `TaskCreatedHookInput`

```typescript theme={null}
type TaskCreatedHookInput = BaseHookInput & {
  hook_event_name: "TaskCreated";
  task_id: string;
  task_subject: string;
  task_description?: string;
  teammate_name?: string;
  /** @deprecated v2.1.178 이후로 사용되지 않음. 세션에서 파생된 팀 이름을 전달합니다. 제거될 예정입니다. */
  team_name?: string;
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
  /** @deprecated v2.1.178 이후로 사용되지 않음. 세션에서 파생된 팀 이름을 전달합니다. 제거될 예정입니다. */
  team_name?: string;
};
```

#### `ElicitationHookInput`

```typescript theme={null}
type ElicitationHookInput = BaseHookInput & {
  hook_event_name: "Elicitation";
  mcp_server_name: string;
  message: string;
  mode?: "form" | "url";
  url?: string;
  elicitation_id?: string;
  requested_schema?: Record<string, unknown>;
};
```

#### `ElicitationResultHookInput`

```typescript theme={null}
type ElicitationResultHookInput = BaseHookInput & {
  hook_event_name: "ElicitationResult";
  mcp_server_name: string;
  elicitation_id?: string;
  mode?: "form" | "url";
  action: "accept" | "decline" | "cancel";
  content?: Record<string, unknown>;
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

#### `InstructionsLoadedHookInput`

```typescript theme={null}
type InstructionsLoadedHookInput = BaseHookInput & {
  hook_event_name: "InstructionsLoaded";
  file_path: string;
  memory_type: "User" | "Project" | "Local" | "Managed";
  load_reason:
    | "session_start"
    | "nested_traversal"
    | "path_glob_match"
    | "include"
    | "compact";
  globs?: string[];
  trigger_file_path?: string;
  parent_file_path?: string;
};
```

#### `DirectoryAddedHookInput`

```typescript theme={null}
type DirectoryAddedHookInput = BaseHookInput & {
  hook_event_name: "DirectoryAdded";
  directory: string;
  source: "slash_command" | "register_repo_root";
};
```

`directory`는 추가된 디렉토리의 절대 경로입니다. `source`는 `/add-dir`이 추가했을 때 `"slash_command"`이고 SDK 제어 요청이 했을 때 `"register_repo_root"`입니다.

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

#### `CwdChangedHookInput`

```typescript theme={null}
type CwdChangedHookInput = BaseHookInput & {
  hook_event_name: "CwdChanged";
  old_cwd: string;
  new_cwd: string;
};
```

#### `FileChangedHookInput`

```typescript theme={null}
type FileChangedHookInput = BaseHookInput & {
  hook_event_name: "FileChanged";
  file_path: string;
  event: "change" | "add" | "unlink";
};
```

#### `MessageDisplayHookInput`

```typescript theme={null}
type MessageDisplayHookInput = BaseHookInput & {
  hook_event_name: "MessageDisplay";
  turn_id: string;
  message_id: string;
  index: number;
  final: boolean;
  delta: string;
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
  /**
   * Claude Code가 사용자를 대신하여 내보낼 터미널 이스케이프 시퀀스 (예: OSC 9 / OSC 777 데스크톱 알림)입니다.
   * 알림/제목 OSC (0, 1, 2, 9, 99, 777) 및 BEL만 허용됩니다. 다른 것을 포함하는 값은 전체적으로 무시됩니다.
   * 대화형 CLI만 내보냅니다. SDK는 이 필드를 무시합니다.
   */
  terminalSequence?: string;
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
        sessionTitle?: string;
        /** decision이 "block"일 때, 블록 메시지에서 원본 프롬프트를 생략합니다. */
        suppressOriginalPrompt?: boolean;
      }
    | {
        hookEventName: "UserPromptExpansion";
        additionalContext?: string;
      }
    | {
        hookEventName: "SessionStart";
        additionalContext?: string;
        initialUserMessage?: string;
        sessionTitle?: string;
        watchPaths?: string[];
        /**
         * SessionStart 훅이 완료된 후 스킬 및 명령 디렉토리를 다시 스캔하므로
         * 훅에 의해 설치된 스킬을 동일한 세션에서 사용할 수 있습니다.
         */
        reloadSkills?: boolean;
      }
    | {
        hookEventName: "Setup";
        additionalContext?: string;
      }
    | {
        hookEventName: "PreModelSwitch";
        /**
         * PreToolUse와 동일한 계약: "allow"는 진행, "deny"는 전환 취소,
         * "ask"는 사용자에게 확인을 요청합니다. 대화형 세션의 /model만
         * 해당 프롬프트를 표시합니다. 다른 모든 표면 (set_model 요청 포함)은
         * "ask"를 거부로 취급합니다.
         */
        permissionDecision?: "allow" | "deny" | "ask";
        permissionDecisionReason?: string;
      }
    | {
        hookEventName: "PostModelSwitch";
        /** 새 모델이 제공하는 다음 요청과 함께 모델에 도달합니다. */
        additionalContext?: string;
      }
    | {
        hookEventName: "SubagentStart";
        additionalContext?: string;
      }
    | {
        hookEventName: "PostToolUse";
        additionalContext?: string;
        /**
         * 자동 모드 권한 분류기를 위한 이 도구 호출 결과에 대한 짧은 참고입니다.
         * 2000자로 제한되며, 동일한 호출에 응답하는 모든 훅에서 공유됩니다.
         * 동기 훅 응답에서만 적용됩니다. 신뢰할 수 없는 도구 출력을 복사하지 마세요.
         */
        classifierContext?: string;
        updatedToolOutput?: unknown;
        /** @deprecated `updatedToolOutput`를 사용하세요. 모든 도구에 대해 작동합니다. */
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
        hookEventName: "Stop";
        additionalContext?: string;
      }
    | {
        hookEventName: "SubagentStop";
        additionalContext?: string;
      }
    | {
        hookEventName: "PermissionDenied";
        retry?: boolean;
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
      }
    | {
        hookEventName: "Elicitation";
        action?: "accept" | "decline" | "cancel";
        content?: Record<string, unknown>;
      }
    | {
        hookEventName: "ElicitationResult";
        action?: "accept" | "decline" | "cancel";
        content?: Record<string, unknown>;
      }
    | {
        hookEventName: "CwdChanged";
        watchPaths?: string[];
      }
    | {
        hookEventName: "FileChanged";
        watchPaths?: string[];
      }
    | {
        hookEventName: "WorktreeCreate";
        worktreePath: string;
      }
    | {
        hookEventName: "MessageDisplay";
        /** 델타 대신 표시되는 텍스트입니다. 원본을 표시하려면 생략하거나 델타를 변경하지 않은 상태로 반환합니다. */
        displayContent?: string;
      };
};
```

## 도구 입력 타입

기본 제공 Claude Code 도구의 입력 스키마 문서입니다. 이 타입은 `@anthropic-ai/claude-agent-sdk/sdk-tools`에서 내보내지며 타입 안전 도구 상호작용에 사용할 수 있습니다.

`StructuredOutput` 도구는 여기에 타입이 없습니다. Claude Code는 `outputFormat`에 전달한 스키마로부터 입력 스키마를 빌드하므로 내보낼 고정된 타입이 없습니다. 메시지 스트림에서 해당 호출이 어떻게 보이는지는 [StructuredOutput 도구 호출 인식하기](https://code.claude.com/docs/ko/agent-sdk/structured-outputs.md#recognize-the-structuredoutput-tool-call)를 참조하세요.

### `ToolInputSchemas`

`@anthropic-ai/claude-agent-sdk/sdk-tools`에서 내보낸 도구 입력 타입의 합집합입니다. 멤버는 다음을 포함합니다:

```typescript theme={null}
type ToolInputSchemas =
  | AgentInput
  | ArtifactInput
  | AskUserQuestionInput
  | BashInput
  | CronCreateInput
  | CronDeleteInput
  | CronListInput
  | EnterPlanModeInput
  | EnterWorktreeInput
  | ExitPlanModeInput
  | ExitWorktreeInput
  | FileEditInput
  | FileReadInput
  | FileWriteInput
  | GlobInput
  | GrepInput
  | ListMcpResourcesInput
  | McpInput
  | MonitorInput
  | NotebookEditInput
  | ProjectsInput
  | PushNotificationInput
  | ReadMcpResourceDirInput
  | ReadMcpResourceInput
  | RefreshMcpToolsInput
  | RemoteTriggerInput
  | ReportFindingsInput
  | ScheduleWakeupInput
  | ShowOnboardingRolePickerInput
  | TaskCreateInput
  | TaskGetInput
  | TaskListInput
  | TaskStopInput
  | TaskUpdateInput
  | TodoWriteInput
  | WebFetchInput
  | WebSearchInput
  | WorkflowInput;
```

### Agent

**도구 이름:** `Agent`. 이 도구를 세션에서 사용할 수 있을 때 이전 이름인 `Task`도 여전히 별칭으로 수락됩니다.

[`SDKSystemMessage`](#sdksystemmessage) 초기화 메시지의 `tools` 배열은 하위 호환성을 위해 이 도구를 `Task`로 나열합니다.

> [!NOTE]
>
> `mode` 필드는 Claude Code v2.1.212 이상에서 deprecated되었으며 무시됩니다. 서브에이전트는 부모 세션의 권한 모드 또는 해당 정의의 [`permissionMode`](#agentdefinition)에서 실행되며, [서브에이전트 상속 규칙](https://code.claude.com/docs/ko/agent-sdk/permissions.md#available-modes)이 어느 것인지 결정합니다.

```typescript theme={null}
type AgentInput = {
  description: string;
  prompt: string;
  subagent_type?: string;
  model?: "sonnet" | "opus" | "haiku" | "fable";
  effort?: "low" | "medium" | "high" | "xhigh" | "max";
  run_in_background?: boolean;
  name?: string;
  team_name?: string; // Deprecated; ignored
  mode?: "acceptEdits" | "auto" | "bypassPermissions" | "default" | "dontAsk" | "plan"; // Deprecated; ignored. The subagent inheritance rules decide a subagent's permission mode
  isolation?: "worktree" | "remote";
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
  answers?: Record<string, string>;
  annotations?: Record<string, { preview?: string; notes?: string }>;
  metadata?: { source?: string };
};
```

실행 중에 사용자에게 명확히 하는 질문을 합니다. 사용 세부 정보는 [승인 및 사용자 입력 처리](https://code.claude.com/docs/ko/agent-sdk/user-input.md#handle-clarifying-questions)를 참조하세요.

### Bash

**도구 이름:** `Bash`

```typescript theme={null}
type BashInput = {
  command: string;
  timeout?: number; // milliseconds. Foreground: capped at 600000 by default, higher values are clamped. With run_in_background (Claude Code v2.1.285 or later): the background time limit, 1800000 when omitted, capped at 7200000 unless raised
  description?: string;
  run_in_background?: boolean;
  dangerouslyDisableSandbox?: boolean;
};
```

선택적 타임아웃 및 백그라운드 실행을 포함한 Bash 명령을 실행합니다. 작업 디렉터리는 다중 턴 세션의 이후 턴에서 실행되는 명령을 포함하여 명령 간에 유지됩니다. 내보낸 환경 변수와 같은 셸 상태는 유지되지 않습니다. 어느 디렉터리 변경이 유지되는지에 대한 제한 사항은 [명령 간에 유지되는 것](https://code.claude.com/docs/ko/tools-reference.md#what-persists-between-commands)을 참조하세요. 포그라운드 상한을 설정하는 것에 대해서는 [타임아웃 및 출력 제한](https://code.claude.com/docs/ko/tools-reference.md#timeout-and-output-limits)을 참조하세요. 백그라운드 시간 제한에 대해서는 [백그라운드 명령의 시간 제한](https://code.claude.com/docs/ko/tools-reference.md#time-limit-for-background-commands)을 참조하세요.

### Monitor

**도구 이름:** `Monitor`

```typescript theme={null}
type MonitorInput = {
  description: string;
  timeout_ms: number;
  command?: string;
  ws?: {
    url: string;
    protocols?: string[];
  };
};
```

백그라운드 소스를 실행하고 각 이벤트를 Claude에 전달하므로 폴링 없이 반응할 수 있습니다: `command`는 스크립트를 실행하고 stdout 라인당 하나의 이벤트를 내보내며, `ws`는 WebSocket을 열고 텍스트 프레임당 하나의 이벤트를 내보냅니다. `command` 또는 `ws` 중 정확히 하나를 제공합니다. `ws` 소스는 Claude Code v2.1.195 이상이 필요합니다.

`timeout_ms`는 감시의 마감 시간(밀리초)입니다. 기본값은 300000이며 최대 3600000까지의 값을 허용합니다. 유효한 마감 시간은 최대 1800000(30분)이므로, 더 큰 허용 값은 그 값으로 단축됩니다. 마감 시간에 감시가 종료되고 Claude는 필요한 경우 새 감시를 시작할 수 있도록 하나의 알림을 받습니다.

내보낸 타입은 스키마가 기본값을 채우기 때문에 `timeout_ms`를 필수로 표시합니다. 이를 생략한 호출도 유효성 검사를 통과합니다.

Monitor가 명령을 실행할 때, Bash와 동일한 권한 규칙을 따릅니다. WebSocket 감시는 별도로 승인을 요청합니다. 동작 및 공급자 가용성은 [Monitor 도구 참조](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool)를 참조하세요.

### TaskOutput

Claude Code v2.1.277에서 제거되었으며, 해당 `TaskOutputInput` 타입도 함께 제거되었습니다. 이전에는 실행 중이거나 완료된 백그라운드 작업에서 출력을 검색했습니다. Claude는 `Read`를 사용하여 백그라운드 작업의 출력 파일을 읽습니다.

`disallowedTools` 항목 또는 여전히 `TaskOutput`의 이름을 지정하는 거부 규칙은 경고 없이 무시됩니다.

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
  allow_large?: boolean;
};
```

텍스트, 이미지, PDF 및 Jupyter 노트북을 포함한 로컬 파일 시스템에서 파일을 읽습니다.

* PDF 페이지 범위의 경우 `pages`를 사용합니다(예: `"1-5"`).
* `allow_large`를 사용하면 세션의 컨텍스트 윈도우에 여유가 있을 때 Claude가 [일반적인 크기 제한](https://code.claude.com/docs/ko/tools-reference.md#large-files)을 넘는 텍스트 파일을 읽을 수 있습니다. Claude Code v2.1.296을 번들로 포함하는 Agent SDK v0.3.296 이상이 필요합니다.

PDF의 경우 Claude는 Read 호출의 `tool_result` 콘텐츠 내에서 파일의 내용을 받습니다. `pdf` [출력](#tool-output-types)을 반환하는 읽기는 요약 `text` 블록 다음에 `document` 블록을 전달합니다. `parts` 출력을 반환하는 읽기는 요약 `text` 블록 다음에 추출된 페이지당 하나의 블록을 전달합니다: `image` 블록 또는 Claude Code가 이를 이미지로 렌더링할 수 없을 때 페이지의 이름을 지정하는 `text` 블록입니다. Agent SDK v0.3.242 이전에는 Claude Code가 도구 결과 후 별도의 `user` 메시지로 파일의 내용을 전달했습니다.

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
  "-o"?: boolean; // print only the matched parts of each line; requires output_mode: "content"
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

정규식을 지원하는 ripgrep 기반 검색 도구입니다.

### TaskStop

**도구 이름:** `TaskStop`

```typescript theme={null}
type TaskStopInput = {
  task_id?: string;
  shell_id?: string; // Deprecated: use task_id
};
```

ID로 실행 중인 백그라운드 작업 또는 셸을 중지합니다. v2.1.198부터 `task_id`는 에이전트 팀 팀원 또는 에이전트 ID 또는 이름으로 명명된 백그라운드 에이전트도 수락합니다.

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
  offset?: number;
};
```

URL에서 콘텐츠를 가져오고 AI 모델로 처리합니다.

`offset`은 페이지 시작 부분부터 건너뛸 문자 수입니다. Claude는 긴 페이지를 계속 읽기 위해 이 값을 설정합니다. 이 필드는 Agent SDK v0.3.290 이상이 필요합니다.

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

### Workflow

**도구 이름:** `Workflow`

```typescript theme={null}
type WorkflowInput = {
  script?: string;
  name?: string;
  scriptPath?: string;
  args?: unknown; // any JSON value; the published typings render this as an object map
  resumeFromRunId?: string;
  title?: string; // ignored; the script's meta block sets the title
  description?: string; // ignored; the script's meta block sets the description
};
```

[동적 워크플로](https://code.claude.com/docs/ko/workflows.md)를 실행합니다: 백그라운드에서 많은 서브에이전트를 조율하고 하나의 통합된 결과를 반환하는 스크립트입니다. `Workflow` 도구는 Agent SDK v0.3.149 이상에서 사용 가능합니다. `script`, `name` 또는 `scriptPath` 중 최소 하나가 필요합니다.

| 필드 | 타입 | 설명 |
| - | - | - |
| `script` | `string` | 인라인 워크플로 스크립트입니다. `export const meta = { name, description }`을 리터럴로 시작해야 하며, 그 뒤에 `agent()`, `parallel()`, `pipeline()` 및 `phase()`를 사용하는 스크립트 본문이 따릅니다. `meta`의 선택적 `phases` 배열은 진행 상황 보기에서 에이전트를 명명된 단계 아래에 그룹화합니다 |
| `name` | `string` | 기본 제공 워크플로의 이름 또는 `.claude/workflows/`에 저장된 워크플로입니다. 스크립트로 확인됩니다 |
| `scriptPath` | `string` | 디스크의 워크플로 스크립트 파일 경로입니다(예: 이전 실행이 반환한 `scriptPath`). `script` 및 `name`보다 우선합니다. 세션의 도구에 `Read`가 포함되어 있지 않으면 Claude Code는 오류와 함께 `scriptPath`를 거부합니다 |
| `args` | `unknown` | 스크립트에 전역 `args`로 노출되는 입력 값으로, 연구 질문이나 파일 경로 목록과 같은 매개변수화된 명명된 워크플로용입니다. 배열과 객체를 JSON 인코딩된 문자열이 아닌 실제 JSON 값으로 전달합니다 |
| `resumeFromRunId` | `string` | 재개할 이전 `Workflow` 호출의 실행 ID입니다. 입력이 변경되지 않은 완료된 `agent()` 호출은 일반적으로 캐시된 결과를 반환합니다. 나머지는 실시간으로 실행됩니다. [일시 중지 후 재개](https://code.claude.com/docs/ko/workflows.md#resume-after-a-pause)는 어느 완료된 호출이 다시 실행되는지 다룹니다. 동일한 세션만 해당됩니다 |
| `title` | `string` | 무시됨; 스크립트의 `meta` 블록이 제목을 설정합니다 |
| `description` | `string` | 무시됨; 스크립트의 `meta` 블록이 설명을 설정합니다 |

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

> [!NOTE]
>
> 다음 도구는 Claude Opus 4.7, Claude Sonnet 4.6, Claude Haiku 4.5 및 이전 모델에서만 기본적으로 사용 가능합니다. 다른 모든 모델(Claude Code가 인식하지 못하는 모델 ID 포함)에서는 옵트인하지 않는 한 사용할 수 없습니다:
>
> * `TodoWrite`
> * `TaskCreate`
> * `TaskGet`
> * `TaskUpdate`
> * `TaskList`
>
> 도구를 사용할 수 있는 모든 곳에서 Claude Code는 4개의 Task 도구를 제공하거나, `CLAUDE_CODE_ENABLE_TASKS=0`을 설정할 때 `TodoWrite`를 대신 제공합니다.
>
> 이 기본 집합은 Claude Code v2.1.268 이상에 적용되며, TypeScript Agent SDK는 v0.3.268부터 이를 번들로 제공합니다.
>
> [모델 가용성](https://code.claude.com/docs/ko/agent-sdk/todo-tracking.md#model-availability)을 참조하여 옵트인하세요.

### TaskCreate

**도구 이름:** `TaskCreate`

```typescript theme={null}
type TaskCreateInput = {
  subject: string;
  description: string;
  activeForm?: string;
  metadata?: Record<string, unknown>;
};
```

단일 작업을 만들고 할당된 ID를 반환합니다.

### TaskUpdate

**도구 이름:** `TaskUpdate`

```typescript theme={null}
type TaskUpdateInput = {
  taskId: string;
  status?: "pending" | "in_progress" | "completed" | "deleted";
  subject?: string;
  description?: string;
  activeForm?: string;
  addBlocks?: string[];
  addBlockedBy?: string[];
  owner?: string;
  metadata?: Record<string, unknown>;
};
```

ID로 하나의 작업을 패치합니다. `status`를 `"deleted"`로 설정하여 제거합니다.

### TaskGet

**도구 이름:** `TaskGet`

```typescript theme={null}
type TaskGetInput = {
  taskId: string;
};
```

하나의 작업에 대한 전체 세부 정보를 반환하거나, ID를 찾을 수 없을 때 `null`을 반환합니다.

### TaskList

**도구 이름:** `TaskList`

```typescript theme={null}
type TaskListInput = {};
```

현재 목록의 모든 작업의 스냅샷을 반환합니다.

### ExitPlanMode

**도구 이름:** `ExitPlanMode`

```typescript theme={null}
type ExitPlanModeInput = {
  /** Deprecated: no longer used. */
  allowedPrompts?: Array<{
    tool: "Bash";
    prompt: string;
  }>;
  [k: string]: unknown;
};
```

플랜 모드를 종료합니다. `allowedPrompts` 필드는 deprecated되었으며 무시됩니다. Claude Code는 기존 호출자 및 트랜스크립트가 유효성을 검사하도록 여전히 수락합니다. v2.1.205 이전에는 계획을 구현하기 위한 프롬프트 기반 Bash 권한을 요청했습니다.

### ListMcpResources

**도구 이름:** `ListMcpResourcesTool`

```typescript theme={null}
type ListMcpResourcesInput = {
  server?: string;
};
```

연결된 서버에서 사용 가능한 MCP 리소스를 나열합니다.

### ReadMcpResource

**도구 이름:** `ReadMcpResourceTool`

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

격리된 작업을 위한 임시 git worktree를 만들고 진입합니다. 새 worktree를 만드는 대신 기존 worktree로 전환하려면 `path`를 전달합니다. 처음 진입할 때 대상은 현재 저장소의 등록된 worktree이거나, 다중 저장소 워크스페이스에서는 그 안에 중첩된 저장소의 등록된 worktree여야 합니다. worktree 세션 내에서는 세션의 저장소의 `.claude/worktrees/` 아래에 있어야 합니다. `name` 및 `path`는 상호 배타적입니다.

### ExitWorktree

**도구 이름:** `ExitWorktree`

```typescript theme={null}
type ExitWorktreeInput = {
  action: "keep" | "remove";
  discard_changes?: boolean;
};
```

현재 git worktree를 종료하고 원래 작업 디렉터리로 돌아갑니다. `keep` 작업은 worktree와 브랜치를 디스크에 남기고, `remove`는 둘 다 삭제합니다. `discard_changes`는 커밋되지 않은 파일이나 병합되지 않은 커밋이 있는 worktree를 제거할 때 `true`여야 합니다.

### EnterPlanMode

**도구 이름:** `EnterPlanMode`

```typescript theme={null}
type EnterPlanModeInput = {};
```

플랜 모드에 진입합니다. 여기서 Claude는 변경을 수행하기 전에 계획을 연구하고 제시합니다.

### CronCreate

**도구 이름:** `CronCreate`

```typescript theme={null}
type CronCreateInput = {
  cron: string;
  prompt: string;
  recurring?: boolean;
  durable?: boolean;
};
```

로컬 시간의 5필드 cron 일정에서 실행할 프롬프트를 예약합니다. `recurring`을 `false`로 설정하여 다음 일치 시 한 번 실행합니다. 작업은 기본적으로 세션 범위이며, `--resume` 또는 `--continue`로 재개하면 만료되지 않은 작업이 복원됩니다. [세션 범위 예약 작업](https://code.claude.com/docs/ko/scheduled-tasks.md)을 참조하세요.

`durable`을 `true`로 설정하면 `.claude/scheduled_tasks.json`에 지속성을 요청하여 작업이 재시작을 견딜 수 있습니다. 지속적인 예약은 모든 세션에서 사용 가능하지 않습니다: 사용 불가능할 때 Claude Code는 `durable: true`를 수락하지만 작업을 세션 전용으로 만듭니다. 출력의 `durable` 필드를 읽어 작업이 지속되었는지 확인하세요.

### CronDelete

**도구 이름:** `CronDelete`

```typescript theme={null}
type CronDeleteInput = {
  id: string;
};
```

`CronCreate`에서 반환된 ID로 예약된 cron 작업을 삭제합니다.

### CronList

**도구 이름:** `CronList`

```typescript theme={null}
type CronListInput = {};
```

예약된 cron 작업을 나열합니다: `.claude/scheduled_tasks.json`의 지속적인 작업 및 현재 세션의 세션 전용 작업입니다.

### ScheduleWakeup

**도구 이름:** `ScheduleWakeup`

```typescript theme={null}
type ScheduleWakeupInput = {
  delaySeconds?: number;
  reason?: string;
  prompt?: string;
  noop?: boolean;
  stop?: boolean;
};
```

지연 후 주어진 프롬프트를 실행하는 일회성 웨이크업을 예약합니다. 이 도구는 자체 속도 `/loop` 명령을 지원합니다. 런타임은 `delaySeconds`를 60\~3600초 사이로 고정합니다. `stop`이 true가 아닌 한 `delaySeconds`, `reason`, `prompt` 및 `noop` 필드가 필요합니다. `noop: true`는 아무것도 변경되지 않은 웨이크업을 보고합니다. `stop: true`를 설정하면 보류 중인 웨이크업을 취소하고 자체 속도 `/loop`를 종료합니다. `stop` 필드는 Claude Code v2.1.202 이상이 필요합니다. [도구 참조의 ScheduleWakeup 행](https://code.claude.com/docs/ko/tools-reference.md)을 참조하세요.

### RemoteTrigger

**도구 이름:** `RemoteTrigger`

```typescript theme={null}
type RemoteTriggerInput = {
  action:
    | "list"
    | "get"
    | "create"
    | "update"
    | "run"
    | "create_webhook_trigger"
    | "list_runs"
    | "get_run_log";
  trigger_id?: string;
  session_id?: string;
  cursor?: string;
  body?: {
    [k: string]: unknown;
  };
};
```

클라우드에서 호스팅되는 예약 및 트리거 기반 Claude Code 실행인 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)(이전 명칭: 루틴)을 관리합니다. 이 도구는 `/schedule` 명령을 지원합니다. `trigger_id`는 `get`, `update`, `run` 및 `list_runs` 작업에 필요합니다. `body`는 `create`, `update` 및 `create_webhook_trigger`에 필요하며 `run`에는 선택 사항입니다.

`create_webhook_trigger`, `list_runs` 및 `get_run_log`는 각각 최소 Claude Code 버전이 필요합니다:

* **`create_webhook_trigger`**: 예약 작업을 실행하는 [GitHub 이벤트](https://code.claude.com/docs/ko/routines.md#add-a-github-trigger)와 같은 이벤트 소스를 기존 예약 작업에 연결합니다. `body`는 소스, 이벤트 및 실행할 작업의 이름을 지정합니다. Claude Code v2.1.225 이상이 필요합니다.
* **`list_runs` 및 `get_run_log`**: `list_runs`는 예약 작업의 최근 실행을 나열하고, `get_run_log`는 하나의 실행 로그를 읽습니다. `session_id`는 `list_runs` 결과에서 읽을 실행의 이름을 지정하고, `cursor`는 두 작업의 결과를 페이징합니다. 두 작업 모두 Claude Code v2.1.227 이상이 필요합니다.

이 도구는 세션이 클라우드 예약 작업이 활성화된 플랜의 claude.ai 계정으로 인증되었을 때만 사용 가능합니다. 조직의 정책이 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 비활성화하면 이 도구는 없습니다. Claude Code v2.1.227 이상에서는 소유자가 [조직의 예약 작업을 끈](https://code.claude.com/docs/ko/routines.md#routines-are-disabled-by-your-organizations-policy) 경우에도 도구가 없습니다.

### PushNotification

**도구 이름:** `PushNotification`

```typescript theme={null}
type PushNotificationInput = {
  message: string;
  status: "proactive";
};
```

사용자에게 사전 예방적 푸시 알림을 보냅니다. 모바일 운영 체제가 더 긴 텍스트를 자르기 때문에 `message`를 200자 이하로 유지하세요. [도구 참조의 PushNotification 행](https://code.claude.com/docs/ko/tools-reference.md)에서 공급자 가용성을 참조하세요. 푸시 전달은 Amazon Bedrock, Claude Platform on AWS, Google Cloud의 Agent Platform 또는 Microsoft Foundry에서 액세스할 수 없는 Anthropic 호스팅 인프라를 통해 실행됩니다.

### REPL

v2.1.275에서 제거되었습니다. v2.1.274까지 실험적 `REPL` 도구는 [`env` 옵션](#options)에서 `CLAUDE_CODE_REPL=1`을 설정하여 켤 수 있었습니다.

### ReportFindings

**도구 이름:** `ReportFindings`

```typescript theme={null}
type ReportFindingsInput = {
  level?: "low" | "medium" | "high" | "xhigh" | "max";
  findings: Array<{
    file: string;
    line?: number;
    summary: string;
    failure_scenario: string;
    short_summary?: string;
    category?: string;
    verdict?: "CONFIRMED" | "PLAUSIBLE";
    outcome?: "fixed" | "skipped" | "no_change_needed";
  }>;
};
```

코드 리뷰 결과를 구조화된 목록으로 보고하여 Claude Code가 텍스트로 인쇄하는 대신 렌더링할 수 있습니다. 결과는 가장 심각한 것부터 정렬되며 호출당 최대 32개이고, 배열은 남은 결과가 없을 때 비어 있습니다. Claude Code v2.1.196 이상이 필요합니다.

`level`은 선택 사항이며 Claude가 리뷰에 대해 보고하는 effort 수준을 담습니다. Claude Code는 이를 리뷰가 실행된 수준과 비교하지 않으므로 두 값이 다를 수 있습니다.

각 결과는 다음 필드를 전달합니다:

* `file`: 결과가 있는 저장소 상대 경로입니다. 선택적 `line`은 이를 고정하는 1 인덱싱된 라인입니다.
* `summary`: 결함의 한 문장 설명입니다. `failure_scenario`는 잘못된 출력 또는 충돌로 이어지는 구체적인 입력 및 상태를 설명합니다.
* `short_summary`: 컴팩트 디스플레이를 위한 최대 60자의 선택적 압축 레이블입니다. Claude Code v2.1.212 이상이 필요합니다.
* `category`: `correctness` 또는 `test-coverage`와 같은 결과 타입의 선택적 짧은 kebab-case 슬러그입니다. Claude Code v2.1.199 이상이 필요합니다.
* `verdict`: 검증 패스가 실행되었을 때 설정됩니다. 인라인 전용 검토에는 없습니다.
* `outcome`: 수정을 적용한 후 다시 보고할 때만 설정됩니다.

### Artifact

**도구 이름:** `Artifact`

```typescript theme={null}
type ArtifactInput = {
  action?: "publish" | "list";
  file_path?: string;
  favicon?: string;
  icon?: string;
  limit?: number;
  scope?: "mine" | "shared" | "all";
  title?: string;
  description?: string;
  label?: string;
  url?: string;
  force?: boolean;
  capabilities?: Record<string, unknown>;
  contract?: "latest" | string;
};
```

로컬 `.html` 또는 `.md` 파일을 호스팅된 아티팩트 페이지로 게시하거나 사용자의 게시된 아티팩트를 나열합니다. `action`을 생략하거나 `"publish"`를 전달하여 `file_path`를 게시합니다. 이는 게시 작업에 필요합니다. 아래의 각 필드는 게시에 적용됩니다:

* `icon`: 아티팩트의 브라우저 탭 아이콘에 대한 하나의 짧은 일반 단어(예: `chart` 또는 `map`). Claude는 첫 게시에 포함하고 업데이트에서 생략하여 아티팩트의 저장된 아이콘을 유지합니다.
* `favicon`: deprecated되었으며 Claude는 생략합니다.
* `title`: HTML 파일에 `<title>` 태그가 없을 때 브라우저 탭 및 갤러리에서 게시된 페이지의 이름을 지정합니다.
* `url`: 새 페이지를 만드는 대신 기존 아티팩트를 제자리에서 업데이트하도록 대상을 지정합니다.

`force`는 다른 세션이 게시한 최신 버전을 버리는 최후의 수단 덮어쓰기입니다. 충돌 시 실패한 게시는 최신 콘텐츠를 반환합니다. Claude는 해당 콘텐츠에 변경 사항을 병합하거나 아티팩트를 다시 읽고 다시 게시합니다. 사용자가 명시적으로 해당 버전을 버리도록 요청할 때만 `force`를 전달하세요.

`"list"`를 전달하여 사용자의 게시된 아티팩트를 열거합니다. `limit` 및 `scope`만 이를 동반할 수 있습니다. `scope`는 기본값이 `"mine"`이며, 사용자가 소유한 아티팩트를 나열합니다. `"shared"`는 다른 사람이 사용자와 공유한 아티팩트를 나열하고, `"all"`은 둘 다 나열합니다.

`limit`은 목록이 반환하는 최대 아티팩트 수를 1부터 200 사이로 설정합니다. 50을 초과하는 `limit`은 Agent SDK v0.3.292 이상이 필요합니다. `limit`이 없으면 목록은 최대 25개를 반환합니다.

* `capabilities`: 게시된 페이지가 사용하는 런타임 기능으로, 기능 이름으로 키 지정됩니다(예: [페이지가 호출할 수 있는 커넥터](https://code.claude.com/docs/ko/artifacts.md#pull-live-data-with-mcp-connectors)). 아티팩트 서비스는 선언을 검증하고 계정이 사용할 수 없거나 잘못된 구성을 제공하는 기능의 이름을 지정하는 게시를 거부합니다. `{}`를 전달하여 저장된 선언을 지우고, 재배포 시 필드를 생략하여 유지하세요. Agent SDK v0.3.235 이상이 필요합니다.
* `contract`: 게시된 페이지가 실행되는 런타임 버전입니다. 생략하여 아티팩트의 현재 버전을 유지하고, `"latest"`를 전달하여 업그레이드하거나, 특정 버전을 전달하여 고정하거나 롤백하세요. Agent SDK v0.3.235 이상이 필요합니다.

타입은 내보내지지만 도구는 Agent SDK 세션에서 기본적으로 꺼집니다. 게시는 또한 [아티팩트 가용성 표](https://code.claude.com/docs/ko/artifacts.md#availability)의 모든 조건이 필요하며, API 키로 인증된 세션은 이를 충족하지 않습니다.

### Projects

**도구 이름:** `Projects`

```typescript theme={null}
type ProjectsInput = {
  method:
    | "project_info"
    | "project_read"
    | "project_search"
    | "project_write"
    | "project_delete";
  path?: string;
  content?: string;
  local_path?: string;
  present_to_user?: boolean;
  query?: string;
  n?: number;
};
```

세션에 연결된 claude.ai 프로젝트를 읽고 씁니다. `method`에서 디스패치합니다:

* `project_info`: 프로젝트 메타데이터 및 문서 목록을 반환합니다.
* `project_read`: `path`로 하나의 문서를 읽습니다.
* `project_search`: `query`로 프로젝트의 지식 기반을 쿼리합니다. `n`은 히트를 제한하고 기본값은 `5`입니다.
* `project_write`: `content`(인라인 텍스트 전달) 또는 `local_path`(작업 디렉터리 내의 파일 이름) 중 정확히 하나에서 `path`에 문서를 만들거나 바꿉니다. `present_to_user: true`는 작성된 문서를 사용자가 봐야 할 결과물로 표시합니다.
* `project_delete`: `path`로 문서를 삭제합니다.

### ReadMcpResourceDir

**도구 이름:** `ReadMcpResourceDirTool`

```typescript theme={null}
type ReadMcpResourceDirInput = {
  server: string;
  uri: string;
};
```

MCP 서버의 디렉터리 리소스의 직접 자식을 나열합니다. 디렉터리 나열을 지원한다고 선언한 서버에 대해서만 사용 가능합니다. 나열은 재귀적이지 않습니다. 디렉터리 나열은 모든 세션에서 활성화되지 않습니다: 비활성화되면 호출은 빈 `resources` 목록을 반환하고 `error` 필드는 디렉터리 나열이 활성화되지 않았음을 보고합니다.

### RefreshMcpTools

**도구 이름:** `RefreshMcpTools`

```typescript theme={null}
type RefreshMcpToolsInput = {
  server?: string; // refresh only this server; omit to refresh all connected servers
};
```

연결된 MCP 서버의 도구 목록을 다시 쿼리하고 변경 사항을 적용합니다. 타입은 내보내지지만 [`env` 옵션](#options)에서 `CLAUDE_CODE_ENABLE_REFRESH_MCP_TOOLS=1`을 설정할 때만 Claude Code가 도구를 등록하며, 최소 하나의 MCP 서버가 있는 세션에서만 등록합니다. Claude Code v2.1.211 이상이 필요합니다.

### ShowOnboardingRolePicker

**도구 이름:** `ShowOnboardingRolePicker`

```typescript theme={null}
type ShowOnboardingRolePickerInput = {};
```

Cowork 온보딩 중에 클릭 가능한 역할 선택기 칩 행을 렌더링하여 사용자가 역할을 선택하고 일치하는 플러그인을 설치할 수 있습니다. 인수를 사용하지 않습니다. 역할 목록은 클라이언트에서 정의됩니다. 호출은 사용자가 응답할 때까지 차단됩니다.

### McpInput

**도구 이름:** `mcp__<server>__<tool>` 형식의 동적 MCP 도구 이름

```typescript theme={null}
type McpInput = {
  [k: string]: unknown;
};
```

MCP 도구 인수는 개방형 객체입니다: 각 서버는 자체 매개변수를 정의하므로 타입은 필드 이름이나 값에 제약을 두지 않습니다. 특정 도구가 수락하는 필드에 대해 서버의 자체 도구 스키마를 참조하세요.

## 도구 출력 타입

기본 제공 Claude Code 도구의 출력 스키마 문서입니다. 이 타입은 `@anthropic-ai/claude-agent-sdk/sdk-tools`에서 내보내지며 각 도구에서 반환된 실제 응답 데이터를 나타냅니다.

### `ToolOutputSchemas`

`@anthropic-ai/claude-agent-sdk/sdk-tools`에서 내보낸 도구 출력 타입의 합집합입니다. 멤버는 다음을 포함합니다:

```typescript theme={null}
type ToolOutputSchemas =
  | AgentOutput
  | ArtifactOutput
  | AskUserQuestionOutput
  | BashOutput
  | CronCreateOutput
  | CronDeleteOutput
  | CronListOutput
  | EnterPlanModeOutput
  | EnterWorktreeOutput
  | ExitPlanModeOutput
  | ExitWorktreeOutput
  | FileEditOutput
  | FileReadOutput
  | FileWriteOutput
  | GlobOutput
  | GrepOutput
  | ListMcpResourcesOutput
  | McpOutput
  | MonitorOutput
  | NotebookEditOutput
  | ProjectsOutput
  | PushNotificationOutput
  | ReadMcpResourceDirOutput
  | ReadMcpResourceOutput
  | RefreshMcpToolsOutput
  | RemoteTriggerOutput
  | ReportFindingsOutput
  | ScheduleWakeupOutput
  | ShowOnboardingRolePickerOutput
  | TaskCreateOutput
  | TaskGetOutput
  | TaskListOutput
  | TaskStopOutput
  | TaskUpdateOutput
  | TodoWriteOutput
  | WebFetchOutput
  | WebSearchOutput
  | WorkflowOutput;
```

### Agent

**도구 이름:** `Agent`. 이 도구를 세션에서 사용할 수 있을 때 이전 이름 `Task`도 여전히 별칭으로 수락됩니다.

```typescript theme={null}
type AgentOutput =
  | {
      status: "completed";
      agentId: string;
      agentType?: string;
      content: Array<{ type: "text"; text: string; citations?: unknown[] | null }>;
      resolvedModel?: string;
      modelsUsed?: string[];
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
        service_tier: string | null;
        cache_creation: {
          ephemeral_1h_input_tokens: number;
          ephemeral_5m_input_tokens: number;
        } | null;
        inference_geo?: string | null;
        speed?: string | null;
        iterations?: unknown;
        output_tokens_details?: {
          thinking_tokens?: number | null;
        } | null;
        fallback_credit?: unknown;
      };
      toolStats?: {
        readCount: number;
        searchCount: number;
        bashCount: number;
        editFileCount: number;
        linesAdded: number;
        linesRemoved: number;
        otherToolCount: number;
        frameCount?: number;
      };
      prompt: string;
      worktreePath?: string;
      worktreeBranch?: string;
    }
  | {
      status: "async_launched";
      isAsync?: true;
      agentId: string;
      description: string;
      resolvedModel?: string;
      modelsUsed?: string[];
      prompt: string;
      outputFile: string;
      canReadOutputFile?: boolean;
    }
  | {
      status: "remote_launched";
      taskId: string;
      sessionUrl: string;
      description: string;
      prompt: string;
      outputFile: string;
    };
```

서브에이전트의 결과를 반환합니다. `status` 필드에서 구분됩니다: 완료된 작업의 경우 `"completed"`, 백그라운드 작업의 경우 `"async_launched"`, Claude Code가 클라우드 세션으로 전달한 작업의 경우 `"remote_launched"`이며, 여기서 `sessionUrl`은 해당 세션으로 연결되고 `taskId`는 이를 식별합니다.

`completed` 변형에서 `resolvedModel`은 서브에이전트가 시작한 모델의 이름을 지정하며, 이는 [`availableModels`](https://code.claude.com/docs/ko/model-config#restrict-model-selection) 또는 다른 재정의가 적용될 때 요청된 `model` 입력과 다를 수 있습니다. 이 필드는 Claude Code v2.1.174 이상이 필요합니다. `async_launched`에서는 작업이 백그라운드로 이동했을 때 사용 중이던 모델의 이름을 지정합니다.

`modelsUsed`는 서브에이전트가 사용한 모델을 순서대로 나열합니다. 이 필드는 실행 중간에 모델 전환이 발생했을 때만 존재하며, 실행이 이전 모델로 다시 전환되면 해당 모델이 다시 나타납니다. `async_launched`에서 목록은 백그라운드로 이동하기 전에 사용된 모델을 포함합니다. `modelsUsed`와 `resolvedModel`의 백그라운드 처리 동작 모두 Claude Code v2.1.212 이상이 필요합니다.

Claude Code가 [서브에이전트의 격리된 worktree를 유지](https://code.claude.com/docs/ko/worktrees.md#isolate-subagents-with-worktrees)한 경우, `completed` 결과의 `worktreePath`는 이를 찾을 수 있는 위치입니다. `worktreeBranch`는 해당 브랜치이며, Claude Code가 git으로 worktree를 생성했을 때 존재합니다.

Claude Code는 전체 실행이 아닌 서브에이전트의 최종 API 요청에서 `usage`와 `totalTokens`를 채우므로, `usage.service_tier`는 해당 요청에 대해 API가 보고한 서비스 계층 문자열입니다. 존재할 때, `usage.output_tokens_details.thinking_tokens`는 해당 요청의 출력 토큰 중 사고 토큰인 토큰의 수입니다. `output_tokens_details` 필드는 TypeScript SDK v0.3.228 이상이 필요하며, 이는 Claude Code v2.1.228을 번들로 제공합니다. `fallback_credit` 필드는 TypeScript SDK v0.3.285 이상이 필요하며, 이는 Claude Code v2.1.285를 번들로 제공합니다.

`usage.output_tokens_details`는 의미에서 [`Usage.output_tokens_details`](#usage)와 일치하며, 해당 최종 요청으로 범위가 지정되지만, 이 모든 수준이 선택 사항입니다. 예를 들어 `usage.output_tokens_details?.thinking_tokens ?? 0`처럼 객체와 필드 모두를 보호하고, 직접 읽지 마십시오.

v2.1.207 이전에는 게시된 타입이 더 좁았습니다. `worktreePath`, `worktreeBranch`, `citations`, `toolStats.frameCount`, 그리고 `inference_geo`, `speed`, `iterations` 사용 필드를 생략했으며, `service_tier`의 타입을 `"standard" | "priority" | "batch"`로 지정했습니다. 타입이 선택 사항으로 표시하는 필드는 이전 버전에서 기록된 결과에 없을 수 있습니다.

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
  response?: string;
  annotations?: Record<string, { preview?: string; notes?: string }>;
  afkTimeoutMs?: number;
};
```

질문과 사용자의 답변을 반환합니다. `response`는 사용자가 구조화된 질문에 답하는 대신 자유 형식 답변을 입력했을 때 설정됩니다. 존재할 때, Claude는 질문별 답변 목록 대신 "The user responded: …"를 받습니다.

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
  timedOutAfterMs?: number;
  backgroundCwdHint?: string;
  backgroundEndsWithFinalResponse?: true;
  dangerouslyDisableSandbox?: boolean;
  returnCodeInterpretation?: string;
  noOutputExpected?: boolean;
  structuredContent?: unknown[];
  persistedOutputPath?: string;
  persistedOutputSize?: number;
  staleReadFileStateHint?: string;
  ghRateLimitHint?: string;
  gitOperation?: {
    commit?: { sha: string; kind: "committed" | "amended" | "cherry-picked"; branch?: string };
    push?: { branch: string };
    branch?: { ref: string; action: "merged" | "rebased" };
    pr?: {
      number: number;
      url?: string;
      action: "created" | "edited" | "merged" | "commented" | "closed" | "reopened" | "ready" | "draft" | "auto-merge-enabled" | "auto-merge-disabled";
    };
  };
};
```

`stdout`, `stderr`, `backgroundTaskId` 필드는 다음을 전달합니다:

| 필드 | 전달 내용 |
| - | - |
| `stdout` | 명령의 stdout과 stderr, 하나의 인터리브된 스트림으로 병합됨 |
| `stderr` | 셸 작업 디렉터리 재설정과 같이 도구 자체가 추가하는 알림, 명령의 stderr가 아님 |
| `backgroundTaskId` | 백그라운드 명령에 대해 존재함 |

`timedOutAfterMs`는 밀리초 단위의 타임아웃이며, 명령이 명시적으로 백그라운드에서 시작된 것이 아니라 타임아웃에 도달하여 백그라운드로 이동했을 때 설정됩니다. `backgroundCwdHint`는 백그라운드 명령에 `cd`, `pushd`, `popd` 또는 `chdir`과 같은 디렉터리 변경 내장 명령이 포함되어 있을 때 설정되며, 세션 작업 디렉터리가 변경되지 않았음을 알립니다. 두 필드 모두 Claude Code v2.1.210 이상이 필요합니다.

포그라운드에서 실행 중인 서브에이전트가 백그라운드 명령을 소유할 때, 명령은 [해당 서브에이전트의 실행이 끝날 때 종료됩니다](https://code.claude.com/docs/ko/tools-reference.md#when-a-background-command-stops). Claude Code는 이러한 명령에 `backgroundEndsWithFinalResponse`를 `true`로 설정하며, 주 대화나 백그라운드 서브에이전트가 시작한 명령처럼 명령이 턴이 끝난 후에도 유지되는 경우에는 이 필드를 생략합니다. 이 필드는 Claude Code v2.1.227 이상이 필요합니다.

Claude Code는 `gitOperation.commit.branch`를 git의 커밋 요약 줄에 명시된 브랜치로 설정하고, 분리된 HEAD에서 만든 커밋의 경우 생략합니다. 이 필드는 Agent SDK v0.3.227 이상이 필요합니다. Claude Code는 `gh pr reopen` 명령을 `reopened` PR 작업으로 보고하며, 이는 Agent SDK v0.3.234 이상이 필요합니다.

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
  originalFile: string | null;
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
    repository?: string | null;
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
        /** True when a whole-file read was auto-paginated because it exceeded the token cap (the content is a partial first page). */
        truncatedByTokenCap?: boolean;
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
      /** Document page number of the first extracted page; labels the page images in the tool_result content. */
      firstPage?: number;
      /** In-process only: the page-image bytes are delivered as image blocks in the tool_result content and aren't retained on the emitted tool_use_result, so this key is absent there. */
      pages?: {
        base64: string;
        mediaType: "image/jpeg" | "image/png" | "image/gif" | "image/webp";
        error?: string;
      }[];
    }
  | {
      type: "file_unchanged";
      file: {
        filePath: string;
      };
      /** Set when the dedup matched a startup-seeded entry (CLAUDE.md / nested memory) rather than a prior Read tool_result. */
      source?: "seeded";
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
    repository?: string | null;
  };
  userModified?: boolean;
};
```

구조화된 diff 정보를 포함한 쓰기 결과를 반환합니다. `originalFile`과 `structuredPatch`가 보유하는 내용은 쓰기에 따라 다릅니다:

* 새로 생성된 파일의 경우, `originalFile`은 null이고 `structuredPatch`는 비어 있습니다
* 덮어쓰기에서 `originalFile`은 이전 콘텐츠를 전달하지만, 해당 콘텐츠가 약 10MB보다 클 때는 예외입니다: Claude Code는 diff를 건너뛰고 `originalFile` null과 `structuredPatch` 빈 상태를 반환합니다
* 쓰기가 아무것도 변경하지 않거나 diff가 시간 초과되면 `structuredPatch`도 비어 있습니다

### Glob

**도구 이름:** `Glob`

```typescript theme={null}
type GlobOutput = {
  durationMs: number;
  numFiles: number;
  filenames: string[];
  truncated: boolean;
  totalMatches?: number;
  countIsComplete?: boolean;
};
```

glob 패턴과 일치하는 파일 경로를 수정 시간별로 정렬하여 반환합니다.

`totalMatches`와 `countIsComplete`는 Claude Code v2.1.191 이상이 필요합니다. `totalMatches`는 잘림 전 일치하는 파일의 수를 보고합니다. `countIsComplete`가 false일 때, `totalMatches`는 기본 검색이 자신의 출력을 잘랐기 때문에 하한입니다.

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
  totalFiles?: number;
  totalLines?: number;
  appliedLimit?: number;
  appliedOffset?: number;
};
```

검색 결과를 반환합니다. 형태는 `mode`에 따라 다릅니다: 파일 목록, 일치 항목이 있는 콘텐츠 또는 일치 항목 수. `count` 모드에서 `numFiles`와 `numMatches`는 페이지 매김된 슬라이스가 아닌 전체 결과 집합에 대한 합계입니다. v2.1.208 이전에는 나열된 항목을 자른 `head_limit` 또는 `offset`이 해당 합계도 잘랐습니다.

`totalFiles`는 Claude Code v2.1.208 이상이 필요하며 `files_with_matches` 모드에서 `head_limit` 및 `offset` 페이지 매김 전 결과의 총 수를 보고합니다. `totalLines`는 Claude Code v2.1.210 이상이 필요하며 `content` 모드에서 페이지 매김 전 줄의 총 수를 보고합니다.

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
  old_source?: string;
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
  artifactRead?: {
    slug: string;
    ver?: string;
    seeded?: false;
  };
};
```

HTTP 상태 및 메타데이터를 포함한 가져온 콘텐츠를 반환합니다.

`artifactRead`는 Claude Code 자체의 아티팩트 읽기 기록이며, Claude가 세션이 게시할 수 있는 아티팩트를 가져왔을 때만 존재합니다. Claude Code는 세션이 재개될 때 이를 다시 읽어서 나중의 게시가 올바른 버전을 기반으로 하도록 합니다. 코드는 이에 대해 조치할 필요가 없습니다. `slug`는 아티팩트의 이름을 지정하고, `ver`는 읽기가 기록한 버전이며 기록된 버전이 없으면 존재하지 않고, `seeded: false`는 전체 소스가 Claude에 도달하지 않은 읽기를 표시합니다. `seeded` 필드는 Agent SDK v0.3.239 이상이 필요합니다.

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
  searchCount?: number;
};
```

웹에서 검색 결과를 반환합니다.

### Workflow

**도구 이름:** `Workflow`

```typescript theme={null}
type WorkflowOutput = {
  status: "async_launched" | "remote_launched";
  taskId: string;
  taskType?: "local_workflow" | "remote_agent";
  workflowName?: string;
  runId?: string;
  summary?: string;
  transcriptDir?: string;
  scriptPath?: string;
  sessionUrl?: string; // set when the workflow launched as a cloud session
  warning?: string;
  error?: string;
};
```

도구가 호출을 수락한 후 즉시 반환됩니다. 최종 결과는 나중에 작업 완료로 도착합니다. 실행이 시작된 것으로 취급하기 전에 `error`를 확인하십시오: 구문 검사에 실패한 스크립트는 `status: "async_launched"`를 반환하고 `error`가 설정되며, 실행되지 않습니다.

| 필드 | 타입 | 설명 |
| - | - | - |
| `status` | `"async_launched" \| "remote_launched"` | 도구가 호출을 수락했습니다. 인프로세스 실행의 경우 `"async_launched"`, 인프로세스로 실행하는 대신 클라우드 세션으로 전달된 실행의 경우 `"remote_launched"` |
| `taskId` | `string` | 실행을 위한 백그라운드 작업 식별자 |
| `taskType` | `"local_workflow" \| "remote_agent"` | 등록된 백그라운드 작업의 작업 타입, `status` 분기 항목과 일치함 |
| `workflowName` | `string` | 워크플로 스크립트의 `meta.name` |
| `runId` | `string` | 나중의 호출에서 `resumeFromRunId`로 전달할 워크플로 실행 식별자. `remote_launched` 실행의 경우 없으며, 클라우드 세션 URL이 재개 핸들입니다 |
| `summary` | `string` | 워크플로가 수행하는 작업에 대한 한 줄 설명 |
| `transcriptDir` | `string` | 실행 중에 서브에이전트 트랜스크립트가 작성되는 디렉터리 |
| `scriptPath` | `string` | 이 실행을 위해 유지된 워크플로 스크립트의 경로입니다. 스크립트를 다시 보내지 않고 다시 실행하려면 편집하고 `scriptPath`로 다시 전달하십시오 |
| `sessionUrl` | `string` | 클라우드 세션 URL, `status`가 `"remote_launched"`일 때 설정됨 |
| `warning` | `string` | 로컬 git 상태가 클라우드 세션이 복제할 푸시된 브랜치와 달라진 경우와 같은 차단하지 않는 알림 |
| `error` | `string` | 스크립트가 구문 검사에 실패할 때 설정됩니다. 존재할 때, 실행은 시작된 상태에도 불구하고 시작되지 않았습니다 |

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

> [!NOTE]
>
> 다음 도구는 Claude Opus 4.7, Claude Sonnet 4.6, Claude Haiku 4.5 및 이전 모델에서만 기본적으로 사용 가능합니다. 다른 모든 모델(Claude Code가 인식하지 못하는 모델 ID 포함)에서는 옵트인하지 않는 한 사용할 수 없습니다:
>
> * `TodoWrite`
> * `TaskCreate`
> * `TaskGet`
> * `TaskUpdate`
> * `TaskList`
>
> 도구를 사용할 수 있는 모든 곳에서 Claude Code는 4개의 Task 도구를 제공하거나, `CLAUDE_CODE_ENABLE_TASKS=0`을 설정할 때 `TodoWrite`를 대신 제공합니다.
>
> 이 기본 집합은 Claude Code v2.1.268 이상에 적용되며, TypeScript Agent SDK는 v0.3.268부터 이를 번들로 제공합니다.
>
> [모델 가용성](https://code.claude.com/docs/ko/agent-sdk/todo-tracking.md#model-availability)을 참조하여 옵트인하십시오.

### TaskCreate

**도구 이름:** `TaskCreate`

```typescript theme={null}
type TaskCreateOutput = {
  task: {
    id: string;
    subject: string;
  };
};
```

할당된 ID와 함께 생성된 작업을 반환합니다.

### TaskUpdate

**도구 이름:** `TaskUpdate`

```typescript theme={null}
type TaskUpdateOutput = {
  success: boolean;
  taskId: string;
  updatedFields: string[];
  error?: string;
  statusChange?: {
    from: string;
    to: string;
  };
};
```

업데이트 결과를 반환하며, 어떤 필드가 변경되었는지 포함합니다.

### TaskGet

**도구 이름:** `TaskGet`

```typescript theme={null}
type TaskGetOutput = {
  task: {
    id: string;
    subject: string;
    description: string;
    status: "pending" | "in_progress" | "completed";
    blocks: string[];
    blockedBy: string[];
  } | null;
};
```

전체 작업 레코드를 반환하거나, ID를 찾을 수 없을 때 `null`을 반환합니다.

### TaskList

**도구 이름:** `TaskList`

```typescript theme={null}
type TaskListOutput = {
  tasks: Array<{
    id: string;
    subject: string;
    status: "pending" | "in_progress" | "completed";
    owner?: string;
    blockedBy: string[];
  }>;
};
```

현재 목록의 모든 작업의 스냅샷을 반환합니다.

### ExitPlanMode

**도구 이름:** `ExitPlanMode`

```typescript theme={null}
type ExitPlanModeOutput = {
  plan: string | null;
  isAgent: boolean;
  filePath?: string;
  hasTaskTool?: boolean;
  planWasEdited?: boolean;
  awaitingLeaderApproval?: boolean;
  requestId?: string;
};
```

플랜 모드 종료 후 계획 상태를 반환합니다.

### ListMcpResources

**도구 이름:** `ListMcpResourcesTool`

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

**도구 이름:** `ReadMcpResourceTool`

```typescript theme={null}
type ReadMcpResourceOutput = {
  contents: Array<{
    uri: string;
    mimeType?: string;
    text?: string;
    blobSavedTo?: string;
  }>;
  error?: string;
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

### ExitWorktree

**도구 이름:** `ExitWorktree`

```typescript theme={null}
type ExitWorktreeOutput = {
  action: "keep" | "remove";
  originalCwd: string;
  worktreePath: string;
  worktreeBranch?: string;
  tmuxSessionName?: string;
  discardedFiles?: number;
  discardedCommits?: number;
  message: string;
};
```

수행된 작업과 종료된 worktree에 대한 세부 정보를 반환합니다.

### EnterPlanMode

**도구 이름:** `EnterPlanMode`

```typescript theme={null}
type EnterPlanModeOutput = {
  message: string;
};
```

플랜 모드에 진입했음을 확인하는 메시지를 반환합니다.

### CronCreate

**도구 이름:** `CronCreate`

```typescript theme={null}
type CronCreateOutput = {
  id: string;
  humanSchedule: string;
  recurring: boolean;
  durable?: boolean; // true when persisted to .claude/scheduled_tasks.json; false when session-only
  nextFireAt?: number;
};
```

작업 ID, 사람이 읽을 수 있는 일정, 다음 실행 시간을 반환합니다. `nextFireAt`은 [지터](https://code.claude.com/docs/ko/scheduled-tasks.md#jitter)가 이미 적용된 epoch 밀리초 단위로 이 시간을 제공하므로, 작업이 실행되도록 설정된 시점을 나타냅니다. 이 필드는 TypeScript Agent SDK v0.3.299 이상 및 Claude Code v2.1.299 이상이 필요합니다.

### CronDelete

**도구 이름:** `CronDelete`

```typescript theme={null}
type CronDeleteOutput = {
  id: string;
};
```

삭제된 작업의 ID를 반환합니다.

### CronList

**도구 이름:** `CronList`

```typescript theme={null}
type CronListOutput = {
  jobs: {
    id: string;
    cron: string;
    humanSchedule: string;
    prompt: string;
    recurring?: boolean;
    durable?: boolean;
    nextFireAt?: number;
  }[];
};
```

예약된 cron 작업을 반환합니다: `.claude/scheduled_tasks.json`의 지속 가능한 작업과 현재 세션의 세션 전용 작업입니다. 세션 전용 작업은 `durable: false`를 전달합니다. 디스크에서 읽은 작업은 필드를 생략합니다.

`nextFireAt`은 [지터](https://code.claude.com/docs/ko/scheduled-tasks.md#jitter)가 포함된, epoch 밀리초 단위의 작업 다음 실행 시간입니다. 어떤 값도 `CronList` 호출 시점보다 이르지 않습니다: [실행되지 않은 채 시간이 지난](https://code.claude.com/docs/ko/scheduled-tasks.md#how-scheduled-tasks-run) 작업은 호출 시간을 전달합니다. 이 필드는 TypeScript Agent SDK v0.3.299 이상 및 Claude Code v2.1.299 이상이 필요합니다.

### ScheduleWakeup

**도구 이름:** `ScheduleWakeup`

```typescript theme={null}
type ScheduleWakeupOutput = {
  scheduledFor: number;
  clampedDelaySeconds: number;
  wasClamped: boolean;
  stopped?: boolean;
  cancelledWakeups?: number;
};
```

웨이크업이 발생할 시간을 epoch 밀리초 타임스탬프로, 실제로 사용된 지연, 요청된 지연이 고정되었는지 여부를 반환합니다. `stopped` 필드는 호출이 `stop: true`로 루프를 종료했을 때 `true`입니다. Claude Code v2.1.202 이상이 필요합니다. `cancelledWakeups` 필드는 `stop: true` 호출이 취소한 보류 중인 웨이크업의 수를 계산합니다. 0 값은 아무것도 보류 중이지 않음을 의미하며, 반복 `/loop` cron은 `stop: true`로 취소되지 않습니다. Claude Code v2.1.206 이상이 필요합니다.

### RemoteTrigger

**도구 이름:** `RemoteTrigger`

```typescript theme={null}
type RemoteTriggerOutput = {
  status: number;
  json: string;
  summary?: string;
};
```

트리거 작업에 대한 API 응답 상태 및 본문을 반환합니다.

### PushNotification

**도구 이름:** `PushNotification`

```typescript theme={null}
type PushNotificationOutput = {
  message: string;
  pushSent?: boolean;
  localSent?: boolean;
  disabledReason?: "config_off" | "user_present" | "no_transport";
  sentAt?: string;
};
```

푸시 또는 로컬 알림이 전송되었는지 여부와 전송이 건너뛰어진 이유를 포함한 전송 세부 정보를 반환합니다.

### ReportFindings

**도구 이름:** `ReportFindings`

```typescript theme={null}
type ReportFindingsOutput = {
  count: number;
  level?: "low" | "medium" | "high" | "xhigh" | "max";
  findings: Array<{
    file: string;
    line?: number;
    summary: string;
    failure_scenario: string;
    short_summary?: string;
    category?: string;
    verdict?: "CONFIRMED" | "PLAUSIBLE";
    outcome?: "fixed" | "skipped" | "no_change_needed";
  }>;
};
```

보고된 결과의 수, Claude가 전달한 `level` 값, 결과 본문을 위해 에코백된 결과를 반환합니다. Claude Code v2.1.196 이상이 필요합니다. 에코백된 `short_summary` 필드는 Claude Code v2.1.212 이상이 필요합니다.

### Artifact

**도구 이름:** `Artifact`

```typescript theme={null}
type ArtifactOutput =
  | {
      url: string;
      path: string;
      title?: string;
      version?: string;
      capabilities?: unknown;
      stored?: {
        contract: string;
        capabilities?: Record<string, unknown>;
      };
      warnings?: string[];
      contract?: string;
      updated?: boolean;
      liveSubscription?: string;
    }
  | {
      artifacts: Array<{
        title: string;
        url: string;
        updatedAt?: string;
        rel?: "mine" | "shared";
      }>;
      truncated?: boolean;
      total?: number;
      total_at_least?: true;
      scope?: "shared" | "all";
    };
```

게시 작업의 경우 게시된 페이지의 `url`과 게시된 로컬 `path`를 반환하며, 게시가 기존 아티팩트를 재배포했을 때 `updated`가 true로 설정되고, `warnings`는 게시 시점의 권고 사항을 전달합니다. 목록 작업은 대신 `artifacts` 행을 반환하며, 요청된 제한보다 더 많은 아티팩트가 존재할 때 `truncated`가 설정됩니다. 범위가 `"mine"`이 아닌 목록에서 각 행은 사용자가 아티팩트를 소유하는지 또는 공유받았는지를 표시하는 `rel`을 전달하고, 출력의 `scope`는 어떤 비기본 범위가 목록을 생성했는지 기록합니다. 둘 다 기본 목록에서는 존재하지 않습니다.

목록 결과는 또한 `total`을 보고합니다. 이는 나열된 범위와 일치하는 아티팩트의 수로, `limit`을 초과하는 아티팩트도 포함합니다. `total_at_least`가 설정되면 이 숫자는 하한이며 더 많은 아티팩트가 존재할 수 있습니다. 두 필드 모두 Agent SDK v0.3.292 이상이 필요합니다.

### Projects

**도구 이름:** `Projects`

```typescript theme={null}
type ProjectsOutput =
  | {
      method: "project_info";
      notice?: string;
      name: string;
      description: string;
      instructions: string;
      docs: Array<{ path: string; created_at: string | null }>;
      files?: Array<{
        path: string;
        file_kind: string;
        created_at: string | null;
      }>;
      sync_sources?: Array<{
        type: string | null;
        config: Record<string, unknown>;
      }>;
      knowledge: {
        knowledge_size: number;
        max_knowledge_size: number;
      };
    }
  | {
      method: "project_read";
      notice?: string;
      path: string;
      file_kind?: string;
      content?: string;
      local_file?: string;
      created_at: string | null;
    }
  | {
      method: "project_search";
      notice?: string;
      rag: boolean;
      hits?: Array<{ name?: string; doc_uuid?: string; text?: string }>;
      docs?: string[];
    }
  | {
      method: "project_write";
      notice?: string;
      path: string;
      doc_uuid: string;
      replaced: boolean;
      present_to_user?: boolean;
      local_path?: string;
    }
  | {
      method: "project_delete";
      notice?: string;
      path: string;
      deleted: boolean;
    };
```

`method` 필드에서 구분되며, 입력을 반영합니다. `project_read`는 작은 텍스트 문서를 `content`에 인라인으로 반환하고 더 큰 문서를 대신 `local_file` 경로에 작성합니다. `project_search`는 프로젝트의 인덱스를 사용할 수 있을 때 RAG `hits`를 `rag: true`로 반환하고 그렇지 않으면 `docs` 경로 목록으로 폴백합니다.

### ReadMcpResourceDir

**도구 이름:** `ReadMcpResourceDirTool`

```typescript theme={null}
type ReadMcpResourceDirOutput = {
  resources: Array<{
    uri: string;
    name: string;
    mimeType?: string;
  }>;
  error?: string;
};
```

디렉터리 리소스의 직접 자식을 반환합니다. 하위 디렉터리는 mimeType `"inode/directory"`로 나타나며, `error`는 서버가 디렉터리를 나열할 수 없을 때 사람이 읽을 수 있는 메시지를 전달합니다.

### RefreshMcpTools

**도구 이름:** `RefreshMcpTools`

```typescript theme={null}
type RefreshMcpToolsOutput = Array<{
  server: string;
  status: "refreshed" | "error" | "not_connected";
  toolCount?: number; // tools now available from this server
  added?: string[]; // tool names this refresh added
  removed?: string[]; // tool names this refresh removed
  error?: string; // why the refresh failed or the server was unavailable
}>;
```

서버당 하나의 항목을 반환합니다: `refreshed`는 다시 쿼리된 도구 목록이 적용되었음을 의미하고, `error`는 다시 쿼리가 실패했고 이전 도구 집합이 유지되었음을 의미하며, `not_connected`는 서버가 쿼리할 라이브 연결이 없음을 의미합니다.

### ShowOnboardingRolePicker

**도구 이름:** `ShowOnboardingRolePicker`

```typescript theme={null}
type ShowOnboardingRolePickerOutput = {
  role?: string;
  dismissed?: boolean;
};
```

사용자의 선택을 반환합니다: 역할 칩을 선택하거나 입력했을 때 `role`, 피커를 닫았을 때 `dismissed: true`. 빈 객체는 사용자가 역할을 선택하지 않고 호출을 승인했음을 의미합니다.

### McpOutput

**도구 이름:** `mcp__<server>__<tool>` 형식의 동적 MCP 도구 이름

```typescript theme={null}
type McpOutput =
  | string
  | {
      type: string;
      [k: string]: unknown;
    }[]
  | {
      [k: string]: unknown;
    };
```

MCP 도구 결과는 서버에 따라 문자열 또는 콘텐츠 블록 배열로 반환됩니다. 내보낸 타입의 후행 일반 객체 분기는 스키마 생성 과정의 산출물입니다. `structuredContent` 또는 리소스 링크도 함께 전달하는 결과의 경우, 이 값을 `content` 멤버에 담고 있는 [`tool_use_result`](#sdkusermessage)를 참조하십시오. 런타임에 값은 `undefined`일 수도 있지만, 내보낸 타입은 이를 모델링하지 않습니다.

## 권한 타입

### `PermissionUpdate`

권한을 업데이트하기 위한 작업입니다.

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
  | "localSettings" // 로컬 프로젝트 설정
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

세션의 요청에 사용된 API 키의 출처로, [`SDKSystemMessage`](#sdksystemmessage) init 메시지에 `apiKeySource`로 보고됩니다.

```typescript theme={null}
type ApiKeySource =
  | "ANTHROPIC_API_KEY"
  | "apiKeyHelper"
  | "/login managed key"
  | "none"
  | "user"
  | "project"
  | "org"
  | "temporary"
  | "oauth";
```

Claude Code는 다음 네 가지 값 중 하나를 보고합니다.

| 값 | 사용 중인 키 |
| - | - |
| `ANTHROPIC_API_KEY` | `ANTHROPIC_API_KEY` 환경 변수의 키 |
| `apiKeyHelper` | [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper) 명령이 반환한 키 |
| `/login managed key` | [Claude Console 계정](https://code.claude.com/docs/ko/authentication.md#claude-console-authentication)으로 로그인할 때 Claude Code가 저장한 키 |
| `none` | API 키가 없습니다. 세션은 claude.ai 로그인, bearer 토큰, 클라우드 제공자 등 다른 방식으로 인증합니다 |

Agent SDK v0.3.234 이상에서는 타입에 이 네 가지 값이 나열됩니다. 이전 코드가 계속 컴파일되도록 타입에는 `user`, `project`, `org`, `temporary`, `oauth`도 남아 있지만, Claude Code는 이 값들을 보고하지 않습니다.

### `SdkBeta`

`betas` 옵션으로 활성화할 수 있는 베타 기능입니다. 자세한 내용은 [베타 헤더](https://platform.claude.com/docs/en/api/beta-headers)를 참조하세요.

```typescript theme={null}
type SdkBeta = "context-1m-2025-08-07";
```

> [!WARNING]
>
> Claude API에서 `context-1m-2025-08-07` 베타는 Claude Sonnet 4.5와 Claude Sonnet 4에 대해 종료되었습니다. 두 모델 중 하나에 이 베타를 계속 전달하면 표준 200K 토큰 컨텍스트 윈도우를 초과하는 요청은 오류를 반환하므로, `betas`에서 제거해야 합니다. 1M 토큰 컨텍스트 윈도우로 세션을 실행하려면 `claude-sonnet-5-5` 또는 `claude-opus-5-5`처럼 [기본적으로 1M 윈도우로 실행되는](https://code.claude.com/docs/ko/model-config.md#extended-context) 모델로 `model`을 설정합니다. `[1m]` 변형을 통해서만 1M에 도달하는 모델의 경우 `claude-opus-4-6[1m]`처럼 모델 ID에 접미사를 추가합니다.

### `SlashCommand`

사용 가능한 명령에 대한 정보입니다.

```typescript theme={null}
type SlashCommand = {
  name: string;
  description: string;
  argumentHint: string;
  aliases?: string[];
  builtin?: boolean;
};
```

`builtin`은 해당 명령이 Claude Code 자체 명령이고 `/name`을 입력하면 그 명령이 실행되는 경우 해당 항목에서 `true`입니다. 사용자, 프로젝트, 플러그인 또는 MCP 서버가 정의한 명령, 그리고 이들 중 하나가 [이름으로 대체한](https://code.claude.com/docs/ko/skills.md#resolve-skills-that-share-a-name) 번들 명령에는 이 필드가 없습니다. Agent SDK v0.3.277 이상이 필요합니다.

### `ModelInfo`

사용 가능한 모델에 대한 정보입니다.

```typescript theme={null}
type ModelInfo = {
  value: string;
  resolvedModel?: string;
  displayName: string;
  description: string;
  supportsEffort?: boolean;
  supportedEffortLevels?: ("low" | "medium" | "high" | "xhigh" | "max")[];
  supportsAdaptiveThinking?: boolean;
  supportsFastMode?: boolean;
  supportsAutoMode?: boolean;
};
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `value` | `string` | API 호출에 전달할 모델 식별자 |
| `resolvedModel` | `string \| undefined` | 이 항목의 `value`가 해석되는 모델 ID입니다. 예를 들어 `sonnet` 별칭 항목의 경우 `claude-sonnet-5-5`입니다. Claude Code v2.1.197 이상이 필요합니다. |
| `displayName` | `string` | 사람이 읽을 수 있는 표시 이름 |
| `description` | `string` | 모델 기능에 대한 설명 |
| `supportsEffort` | `boolean \| undefined` | 이 모델이 effort 수준을 지원하는지 여부 |
| `supportedEffortLevels` | `("low" \| "medium" \| "high" \| "xhigh" \| "max")[] \| undefined` | 이 모델이 허용하는 effort 수준 |
| `supportsAdaptiveThinking` | `boolean \| undefined` | 이 모델이 Claude가 언제, 얼마나 사고할지 결정하는 적응형 사고를 지원하는지 여부 |
| `supportsFastMode` | `boolean \| undefined` | 이 모델이 빠른 모드를 지원하는지 여부 |
| `supportsAutoMode` | `boolean \| undefined` | 이 모델이 자동 모드를 지원하는지 여부 |

### `AgentInfo`

Agent 도구를 통해 호출할 수 있는 사용 가능한 서브에이전트에 대한 정보입니다.

```typescript theme={null}
type AgentInfo = {
  name: string;
  description: string;
  model?: string;
};
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `name` | `string` | 에이전트 타입 식별자(예: `"Explore"`, `"general-purpose"`) |
| `description` | `string` | 이 에이전트를 언제 사용해야 하는지에 대한 설명 |
| `model` | `string \| undefined` | 이 에이전트가 사용하는 모델입니다. 별칭 또는 모델 ID이거나, 상위 에이전트의 모델을 사용하는 경우 `'inherit'`입니다. `undefined`이면 Claude Code가 [서브에이전트 모델 순서](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)에 따라 모델을 선택합니다 |

### `McpServerProvenance`

`mcp__*` 도구를 제공하는 MCP 서버와 해당 서버 정의의 출처입니다. [`PreToolUse`](#pretoolusehookinput), `PostToolUse`, `PostToolUseFailure`, `PermissionRequest`, `PermissionDenied` 훅 입력은 이를 `mcp_server`로 전달하고, [`CanUseTool`](#canusetool) 옵션은 `mcpServer`로 전달합니다. 두 경우 모두 MCP 서버에서 오지 않은 도구에서는 이 값을 생략합니다.

```typescript theme={null}
type McpServerProvenance = {
  name: string;
  source: string;
};
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `name` | `string` | 서버가 등록된 이름으로, [`mcpServerStatus()`](#query-object)가 해당 서버에 대해 보고하는 값과 같습니다 |
| `source` | `string` | 서버 정의의 출처: `sdk`, `plugin` 또는 구성 범위 |

`source`는 다음 값 중 하나를 가집니다. 값의 집합은 열려 있으므로, 인식하지 못하는 값은 절대 `sdk`로 취급하지 말고 구성된 출처로 취급해야 합니다.

* **`sdk`**: 애플리케이션이 등록한 인프로세스 서버입니다. SDK 호스트 애플리케이션만 이를 등록할 수 있으므로, 구성된 서버는 이름과 관계없이 절대 `sdk`를 보고하지 않습니다.
* **`plugin`**: [플러그인](https://code.claude.com/docs/ko/agent-sdk/plugins.md)이 제공하는 서버입니다. 이 서버의 `name`은 [플러그인 제공 MCP 서버](https://code.claude.com/docs/ko/mcp.md#plugin-provided-mcp-servers)에서 설명하는 범위가 지정된 `plugin:<plugin-name>:<server-name>` 형식입니다.
* **구성 범위**: `user`, `project`, `local`, `dynamic`, `managed`, `enterprise`, `claudeai` 또는 `agent`입니다. `.mcp.json` 서버는 `project`를 보고하며, [MCP 설치 범위](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes)에서 `local`, `project`, `user`를 정의합니다. 애플리케이션이 [`mcpServers` 옵션](#options)으로 전달한 서버는 인프로세스 SDK 서버를 제외하고 `dynamic`을 보고합니다.

신뢰 결정은 `name`이나 `mcp__<server>__` 도구 이름 접두사가 아닌 `source`를 기준으로 내려야 합니다. `sdk` 이외의 출처에서 `name`은 신뢰할 수 없는 텍스트이므로 표시하기 전에 이스케이프해야 합니다.

`McpServerProvenance`와 이를 전달하는 필드에는 Agent SDK v0.3.274 이상이 필요합니다.

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
  source?: string;
  tools?: {
    name: string;
    description?: string;
    annotations?: {
      readOnly?: boolean;
      destructive?: boolean;
      openWorld?: boolean;
    };
    _meta?: Record<string, unknown>;
  }[];
};
```

서버를 얼마나 신뢰할지 결정하려면 `source`를 사용하고, 서버가 특정 도구에 첨부한 UI 리소스를 찾으려면 각 `tools` 항목의 `_meta`를 사용합니다.

* **`source`**: 서버 정의의 출처로, [`McpServerProvenance`](#mcpserverprovenance)의 `source`와 같은 값을 가집니다. 다른 서버가 어떤 이름으로 등록되어 있든 자체 인프로세스 서버만 `sdk`를 보고하므로, 신뢰 결정은 `name`이 아닌 `source`를 기준으로 내려야 합니다. 인식하지 못하는 `source` 값이 있으면 해당 서버를 `source`가 `sdk`가 아닌 다른 서버와 동일하게 취급합니다. Agent SDK v0.3.274 이상이 필요합니다
* **`_meta`**: 서버가 해당 도구에 대해 선언한 `_meta`의 `ui` 객체와 `ui/resourceUri` 문자열입니다. Claude Code는 그 외의 모든 `_meta` 키를 전달하지 않습니다. `ui/resourceUri`는 `ui.resourceUri`의 이전 최상위 표기입니다. 서버가 도구에 [MCP Apps UI 리소스](https://code.claude.com/docs/ko/mcp.md#reference-mcp-resources)를 첨부하면 `ui.resourceUri` 또는 `ui/resourceUri`에 해당 리소스의 `ui://` URI가 담깁니다. [`readMcpResource()`](#query-object)로 해당 URI를 가져와 애플리케이션에서 리소스를 렌더링합니다. Agent SDK v0.3.280 이상이 필요합니다

Claude Code는 subtype이 `init`인 `system` 메시지의 [`capabilities`](#sdksystemmessage) 배열에 `mcp_tool_ui_meta_v1`이 나열된 경우에만 `_meta`를 보냅니다. `mcp_tool_ui_meta_v1`은 사용자가 직접 켜는 것이 아닙니다.

#### 도구의 `_meta.ui`에 `visibility`만 있는 경우

서버가 도구에 대해 `ui.resourceUri`를 선언했지만 애플리케이션이 받은 `_meta.ui`에 `visibility`만 있다면, 서버가 보낸 `ui` 객체가 Claude Code의 검사 중 하나를 통과하지 못한 것입니다. 서버의 `tools/list` 응답에 있는 `_meta`를 각 키에 대한 검사와 비교해 보세요.

* **`ui`**: 다음 세 가지 검사를 모두 통과하면 `resourceUri`와 `visibility` 이외의 멤버를 포함해 변경 없이 애플리케이션에 전달됩니다.

  * `resourceUri`가 없거나, `ui://`로 시작하는 문자열입니다
  * `visibility`가 없거나, `"model"`과 `"app"`만 나열합니다
  * 객체 전체를 JSON으로 직렬화했을 때 최대 4,096자입니다

  검사 중 하나라도 실패하면 애플리케이션은 기껏해야 서버가 나열한 `"model"` 및 `"app"` 항목이 담긴 `visibility` 배열만을 유일한 멤버로 가진 `ui`를 받습니다.
* **`ui/resourceUri`**: `ui://`로 시작하고 최대 4,096자인 문자열이면 애플리케이션에 전달됩니다. 그렇지 않으면 Claude Code가 이를 삭제합니다

Claude Code가 보낼 `ui` 멤버도 `ui/resourceUri` 문자열도 남아 있지 않으면, 해당 `tools` 항목에는 `_meta`가 전혀 없습니다.

### `McpServerStatusConfig`

`mcpServerStatus()`가 보고하는 MCP 서버의 구성입니다. 모든 MCP 서버 전송 타입의 유니온입니다.

```typescript theme={null}
type McpServerStatusConfig =
  | McpStdioServerConfig
  | McpSSEServerConfig
  | McpHttpServerConfig
  | McpSdkServerConfig
  | McpClaudeAIProxyServerConfig;
```

각 전송 타입에 대한 자세한 내용은 [`McpServerConfig`](#mcpserverconfig)를 참조하세요.

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

결과 메시지에 반환되는 모델별 사용량 통계입니다. `costUSD` 값은 클라이언트 측 추정치입니다. 청구 관련 주의 사항은 [비용 및 사용량 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md)을 참조하세요.

```typescript theme={null}
type ModelUsage = {
  inputTokens: number;
  outputTokens: number;
  thinkingTokens?: number;
  cacheReadInputTokens: number;
  cacheCreationInputTokens: number;
  webSearchRequests: number;
  costUSD: number;
  contextWindow: number;
  maxOutputTokens: number;
  canonicalModel?: string;
  provider?: string;
  costBasis?: 'list' | 'managed' | 'unknown';
};
```

`thinkingTokens`는 이 모델이 생성한 사고 토큰 수를 셉니다. `outputTokens`에 이미 포함되어 있으므로 두 값을 더하면 안 됩니다. 이 필드는 이를 기록하는 Claude Code 버전에서 턴이 실행될 때까지 존재하지 않으므로, 이전 버전에서 시작되어 재개된 세션은 부분적인 수를 보고합니다. `thinkingTokens`에는 Agent SDK v0.3.257 이상이 필요합니다.

`canonicalModel` 및 `provider` 필드에는 Claude Code v2.1.218 이상이 필요합니다. `canonicalModel`은 가격 조회에 사용되는 정규 모델 ID이며, 예를 들어 항목의 키가 되는 원시 모델 문자열이 제공자별 ID나 별칭인 경우 해당 문자열과 다를 수 있습니다.

`provider`는 모델을 제공한 API 백엔드의 이름으로, `firstParty`, `bedrock`, `vertex`, `foundry`, `anthropicAws`, `mantle`, `gateway` 등이 있습니다.

`costBasis`는 모델의 최신 요청 가격을 책정한 가격표를 나타냅니다. 정가의 경우 `list`, [`modelPricing`](https://code.claude.com/docs/ko/settings-reference#modelpricing) 테이블의 경우 `managed`, 둘 다 모델 ID와 일치하지 않은 경우 `unknown`입니다. 이 필드에는 Claude Code v2.1.246 이상이 필요합니다.

### `ConfigScope`

```typescript theme={null}
type ConfigScope = "local" | "user" | "project";
```

### `NonNullableUsage`

여전히 `null`일 수 있는 `fallback_credit`을 제외하고 nullable 필드를 모두 non-nullable로 만든 [`Usage`](#usage) 버전입니다.

```typescript theme={null}
type NonNullableUsage = {
  [K in keyof Usage]: K extends "fallback_credit"
    ? Usage[K]
    : NonNullable<Usage[K]>;
};
```

### `Usage`

토큰 사용량 통계입니다. `@anthropic-ai/sdk`의 `BetaUsage` 타입입니다.

```typescript theme={null}
type Usage = {
  input_tokens: number;
  output_tokens: number;
  cache_creation_input_tokens: number | null;
  cache_read_input_tokens: number | null;
  cache_creation: {
    ephemeral_5m_input_tokens: number;
    ephemeral_1h_input_tokens: number;
  } | null;
  server_tool_use: BetaServerToolUsage | null;
  service_tier: "standard" | "priority" | "batch" | null;
  speed: "standard" | "fast" | null;
  inference_geo: string | null;
  iterations: BetaIterationsUsage | null;
  output_tokens_details: BetaOutputTokensDetails | null;
  fallback_credit: BetaFallbackCreditUsage | null;
};
```

`BetaServerToolUsage`, `BetaIterationsUsage`, `BetaOutputTokensDetails`, `BetaFallbackCreditUsage`는 `@anthropic-ai/sdk`에 정의되어 있습니다.

`output_tokens_details`는 청구된 출력을 카테고리별로 분류합니다. 현재는 `thinking_tokens: number` 필드 하나만 있으며, 사고 블록 구분자를 포함해 모델이 내부 추론으로 생성한 출력 토큰 수를 셉니다. `output_tokens_details` 필드에는 Claude Code v2.1.228이 번들된 TypeScript SDK v0.3.228 이상이 필요합니다.

* **청구**: 이 분류는 청구가 아닌 관측 목적으로 읽어야 합니다. `output_tokens`가 여전히 권위 있는 합계이며, `output_tokens - thinking_tokens`는 추론이 아닌 출력의 근사치입니다.
* **집계 대상**: 모델이 생성한 원시 추론으로, 응답 본문에 반환되는 사고 텍스트보다 길 수 있습니다. API는 해당 원시 텍스트를 다시 토큰화하여 계산하므로, 모델의 정확한 생성 수와 몇 토큰 차이가 날 수 있습니다.
* **스트리밍**: 스트리밍된 어시스턴트 메시지에서 이 분류는 `output_tokens`와 마찬가지로 `message_start` 자리 표시자이며 실제 수를 담고 있지 않으므로, [결과 메시지에서 출력 토큰 읽기](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#read-output-tokens-from-the-result-message)에서 설명하는 대로 결과 메시지의 `usage`에서 읽어야 합니다. 결과 메시지에서 모델이나 제공자가 분류를 보고하지 않으면 `thinking_tokens`는 `0`입니다.
* **`null`인 경우**: API 오류 메시지처럼 Claude Code가 합성한 어시스턴트 메시지에서는 `output_tokens_details` 자체가 `null`입니다.

`Usage`에 `fallback_credit`이 포함되는지는 설치된 `@anthropic-ai/sdk`에 따라 다르며, 0.115.0에서 추가되었습니다.

### `CallToolResult`

MCP 도구 결과 타입입니다(`@modelcontextprotocol/sdk/types.js`에서 제공). `structuredContent`는 이미지 블록을 포함한 `content`와 함께 반환할 수 있는 JSON 객체입니다. [구조화된 데이터 반환](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md#return-structured-data)을 참조하세요.

```typescript theme={null}
type CallToolResult = {
  content: Array<{
    type: "text" | "image" | "audio" | "resource" | "resource_link";
    // Additional fields vary by type
  }>;
  structuredContent?: Record<string, unknown>;
  isError?: boolean;
};
```

### `SDKMcpResourceLink`

MCP 도구가 참조로 반환한 파일 하나입니다. Claude Code는 도구 결과의 `resource_link` 블록에서 각 항목을 만들고, 목록을 [`SDKUserMessage.tool_use_result`](#sdkusermessage)의 `resourceLinks`로 전달하거나, 호출이 백그라운드에서 완료된 경우 [`SDKTaskNotificationMessage`](#sdktasknotificationmessage)의 `resource_links`로 전달합니다. Agent SDK v0.3.257 이상이 필요합니다.

```typescript theme={null}
type SDKMcpResourceLink = {
  uri: string;
  name: string;
  title?: string;
  description?: string;
  mimeType?: string;
  size?: number;
  annotations?: Record<string, unknown>;
};
```

Claude Code는 `uri` 또는 `name`이 문자열이 아닌 블록을 삭제하고, 값이 나열된 타입이 아닌 선택적 필드는 생략합니다.

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `uri` | `string` | 서버가 반환한 리소스의 URI |
| `name` | `string` | 서버가 리소스에 부여한 이름 |
| `title` | `string \| undefined` | 서버가 설정한 경우 표시 제목 |
| `description` | `string \| undefined` | 서버가 설정한 경우 설명 |
| `mimeType` | `string \| undefined` | 서버가 설정한 경우 MIME 타입 |
| `size` | `number \| undefined` | 서버가 설정한 경우 바이트 단위 크기 |
| `annotations` | `Record<string, unknown> \| undefined` | 서버가 설정한 경우 블록의 MCP annotations 객체 |

### `ThinkingConfig`

Claude의 사고/추론 동작을 제어합니다. deprecated된 `maxThinkingTokens`보다 우선합니다.

```typescript theme={null}
type ThinkingDisplay = "summarized" | "omitted";

type ThinkingConfig =
  | { type: "adaptive"; display?: ThinkingDisplay } // The model determines when and how much to reason (Opus 4.6+)
  | { type: "enabled"; budgetTokens?: number; display?: ThinkingDisplay } // Fixed thinking token budget
  | { type: "disabled" }; // No extended thinking
```

선택적 `display` 필드는 사고 텍스트를 `"summarized"`로 반환할지 `"omitted"`로 반환할지 제어합니다. Claude Opus 4.7 이상에서 API 기본값은 `"omitted"`이므로, `thinking` 블록에서 사고 내용을 받으려면 `"summarized"`로 설정합니다. Claude Code는 Amazon Bedrock이나 Google Cloud의 Agent Platform 같은 일부 제공자에는 `display` 값을 전달하지 않습니다. 이러한 제공자에서는 `display`를 `"summarized"`로 설정해도 Opus 4.7 이상이 빈 `thinking` 블록을 반환합니다.

### `SpawnedProcess`

사용자 지정 프로세스 생성을 위한 인터페이스입니다(`spawnClaudeCodeProcess` 옵션과 함께 사용). `ChildProcess`는 이미 이 인터페이스를 충족합니다.

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

사용자 지정 spawn 함수에 전달되는 옵션입니다.

```typescript theme={null}
interface SpawnOptions {
  command: string;
  args: string[];
  cwd?: string;
  env: Record<string, string | undefined>;
  signal: AbortSignal;
}
```

> [!NOTE]
>
> `signal` 필드는 spawn 함수에 프로세스를 종료할 시점을 알려 줍니다. Node의 `spawn()`에 `signal` 옵션으로 전달하거나, VM 또는 컨테이너 종료 핸들러에 전달합니다.
>
> 이 시그널은 [`Options.abortController`](#options)가 중단되는 즉시 발생하지 않습니다. SDK는 먼저 프로세스의 stdin을 닫고 CLI가 정상적으로 종료될 수 있도록 약 2초간 기다린 다음 이 시그널을 중단합니다. 호출자가 중단하는 순간 바로 반응하려면 자체 `Options.abortController.signal`을 수신 대기합니다. spawn 함수는 이를 상위 스코프에서 참조할 수 있습니다.

### `McpSetServersResult`

`setMcpServers()` 작업의 결과입니다.

```typescript theme={null}
type McpSetServersResult = {
  added: string[];
  removed: string[];
  errors: Record<string, string>;
};
```

`setMcpServers()` 프로미스는 새로 추가된 stdio, HTTP, SSE 서버가 연결되거나 실패한 후에 resolve되므로, 연결된 서버의 도구는 다음 턴에서 사용할 수 있습니다.

`setMcpServers()`를 호출하면 Claude Code는 다음 규칙을 적용합니다.

* **호출에서 지정하지 않은 서버**: [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md) 외부에서 Claude Code는 이전 `setMcpServers()` 호출이 추가한 서버와 인프로세스 SDK 서버의 연결을 끊고 `removed`에 나열합니다. 그 밖의 서버는 계속 실행되며 `removed`에 나열되지 않습니다. 여기에는 [`mcpServers`](#options) 옵션의 stdio, HTTP, SSE 서버, 설정 파일의 서버, 플러그인 제공 서버가 포함됩니다.
* **이전 `setMcpServers()` 호출이 추가한 stdio, HTTP, SSE 서버**: 클라우드 세션 외부에서 동일한 구성으로 다시 지정한 서버는 연결과 도구를 유지합니다. 이 서버는 `added`에도 `removed`에도 나타나지 않습니다. 변경된 구성을 전달하면 Claude Code는 해당 구성으로 서버를 다시 연결하고 `removed`가 아닌 `added`에 나열합니다.
* **이전 호출이 추가하지 않았고 이번 호출에서 지정한 stdio, HTTP, SSE 서버**: 클라우드 세션 외부에서 Claude Code는 서버를 추가하고 `added`에 나열하며, 서버를 거부하는 경우 `errors`에 나열합니다.
* **호출에서 지정한 인프로세스 SDK 서버**: `mcpServers` 또는 이전 호출을 통해 이미 등록된 서버는 실행 중인 인스턴스와 타임아웃을 유지합니다. 해당 서버에 대해 [`tools` 정책 목록](#mcpsdkserverconfigwithinstance)을 전달하면, 빈 목록이라도 정책이 대체되고, 그렇지 않으면 정책이 유지됩니다. 클라우드 세션 외부에서 새 인스턴스를 실행하려면 한 호출에서 서버를 생략한 다음 다음 호출에서 지정합니다.
* **CLI가 시작 시 시작한 기본 제공 서버**: 호출에서 이 서버를 지정하면 Claude Code는 해당 항목을 삭제하고 `errors`에 보고합니다.
* **`.mcp.json` 같은 MCP 설치 범위의 서버와 이름이 같은 stdio, HTTP 또는 SSE 서버**: 해당 이름으로 세션은 [설치 범위 서버](https://code.claude.com/docs/ko/mcp.md#mcp-installation-scopes)가 아닌 사용자 서버의 도구를 사용합니다. Claude Code v2.1.305 이전에는 앱이 [플러그인을 다시 로드](#query-object)할 때 Claude Code가 사용자 서버의 연결을 끊고 설치 범위 서버를 연결할 수 있었습니다.

`added`는 연결 여부와 관계없이 Claude Code가 추가하거나 대체한 서버를 나열합니다. 연결에 실패한 서버는 `added`와 `errors` 모두에 나타나며, `errors`에는 실패 텍스트가, [`mcpServerStatus()`](#methods)에는 `failed` 항목이 표시됩니다. Claude Code v2.1.257 이전에는 연결 시도에서 예외가 발생한 서버가 `errors`에만 보고되었습니다.

`Blocked by enterprise`로 시작하는 `errors` 값은 연결에 실패한 것이 아니라 정책이 서버를 거부했음을 의미합니다.

* `Blocked by enterprise policy (allowedMcpServers/deniedMcpServers)`: 서버가 `added`에 없습니다. [`deniedMcpServers`](https://code.claude.com/docs/ko/managed-mcp#policy-based-control-with-allowlists-and-denylists) 항목이 서버와 일치하거나, `allowedMcpServers` 목록이 설정되어 있고 해당 서버가 빠져 있습니다. 그 목록이 [`settingSources`](#options)로 로드하는 설정 파일에 있다면 파일을 편집합니다. 관리형 설정에 있다면 관리자에게 변경을 요청합니다.
* `Blocked by enterprise managed policy`: 서버가 `added`에 있으며, `mcpServerStatus()`에 `failed` 항목이 있습니다. 어떤 정책이 서버를 차단하는지 관리자에게 문의합니다.

### `RewindFilesResult`

`rewindFiles()` 작업의 결과입니다.

```typescript theme={null}
type RewindFilesResult = {
  canRewind: boolean;
  error?: string;
  filesChanged?: string[];
  insertions?: number;
  deletions?: number;
  skippedLinks?: number;
};
```

`skippedLinks`는 링크 안전성 때문에 되감기에서 복원이나 삭제를 거부한 추적 경로의 수를 셉니다. 추적 경로에 있는 심볼릭 링크, 하드 링크 또는 기타 일반 파일이 아닌 파일, 체크포인트를 생성할 때 가리키던 위치로 더 이상 해석되지 않는 상위 디렉터리, 또는 안전하게 읽을 수 없는 백업이 이에 해당합니다. 이 필드에는 Claude Code v2.1.216 이상이 필요합니다. `rewindFiles(userMessageId, { dryRun: true })`를 사용한 미리 보기 호출에서는 절대 설정되지 않습니다.

### `SDKStatusMessage`

상태 업데이트 메시지입니다(예: 압축 중).

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

백그라운드 작업이 완료되거나, 실패하거나, 중지될 때의 알림입니다. 백그라운드 작업에는 `run_in_background` Bash 명령, [Monitor](#monitor) 감시, 백그라운드 서브에이전트가 포함됩니다. `run_id` 및 `ambient` 필드에 대해서는 해당 필드와 버전 요구 사항을 정의하는 [`SDKTaskStartedMessage`](#sdktaskstartedmessage)를 참조하세요.

```typescript theme={null}
type SDKTaskNotificationMessage = {
  type: "system";
  subtype: "task_notification";
  task_id: string;
  run_id?: string;
  tool_use_id?: string;
  status: "completed" | "failed" | "stopped";
  reason?: "worker_restart";
  output_file: string;
  summary: string;
  ambient?: boolean;
  usage?: {
    total_tokens: number;
    tool_uses: number;
    duration_ms: number;
  };
  resource_links?: SDKMcpResourceLink[];
  uuid: UUID;
  session_id: string;
};
```

`reason`은 작업이 자체 완료, 실패 또는 중지 이외의 원인으로 종료될 때 설정되며, Agent SDK v0.3.273 이상이 필요합니다. Claude Code는 claude.ai를 통해 연결되는 세션, 즉 자체 호스팅 러너의 세션을 포함한 클라우드 세션과 Remote Control 세션에서만 이 값을 설정합니다. 로컬 `query()` 호출에서는 절대 설정되지 않습니다. 유일한 값인 `worker_restart`는 작업을 실행하던 Claude Code 프로세스가 재시작되었음을 의미합니다. 알림의 상태는 `"stopped"`이므로, 해당 작업은 완료도 실패도 아닌 것으로 취급해야 합니다.

Claude Code가 [오래 걸리는 MCP 도구 호출을 백그라운드로 이동](https://code.claude.com/docs/ko/mcp.md#automatic-backgrounding-of-long-tool-calls)하면, 해당 호출의 `tool_result` 블록에는 자리 표시자만 담기고 호출의 실제 결과는 이 알림으로 도착합니다. `tool_use_id`로 알림을 호출과 연결합니다. `completed` 알림에서 `resource_links`는 도구가 참조로 반환한 파일을 [`SDKMcpResourceLink`](#sdkmcpresourcelink) 항목으로 나열하며, [`tool_use_result.resourceLinks`](#sdkusermessage)와 동일한 50개 링크 및 64 KiB 제한이 적용됩니다. 결과에 링크가 없거나 MCP 도구 호출이 아닌 작업에 대한 알림에서는 Claude Code가 `resource_links`를 생략합니다. `resource_links`에는 Agent SDK v0.3.257 이상이 필요합니다.

Claude Code는 모델에 보내는 모든 작업 알림 앞에 안내문을 추가합니다. 단, [`scheduled-trigger` subkind](#task-notification-subkinds)가 지정된 전달은 예외이며, 이 경우 대신 할당된 작업이라는 프레이밍이 담깁니다. 안내문은 사람의 입력이 없었음을 명시하므로, 모델은 알림을 사용자 지시나 승인으로 취급하지 않습니다.

작업 알림 턴을 감지하려면 안내문 텍스트를 매칭하는 대신 [`SDKUserMessage`](#sdkusermessage) 또는 [`SDKResultMessage`](#sdkresultmessage)에서 `origin.kind === "task-notification"`을 확인합니다. 무엇이 알림을 발생시켰는지 알아야 하는 경우 같은 필드에서 `subkind`를 읽습니다. v2.1.205 이전에는 세션이 유휴 상태일 때 도착한 알림에 Claude Code가 안내문을 추가하지 않았습니다.

### `SDKToolUseSummaryMessage`

대화의 도구 사용 요약입니다.

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

훅 실행이 시작될 때 발생합니다.

Claude Code는 세션 시작 중 `SessionStart` 또는 `Setup` 훅이 아직 실행 중인 동안을 포함해, 이 메시지와 [`SDKHookProgressMessage`](#sdkhookprogressmessage), [`SDKHookResponseMessage`](#sdkhookresponsemessage)를 메시지 스트림에 즉시 전달합니다. Claude Code v2.1.169부터 v2.1.203까지는 `SessionStart` 또는 `Setup` 훅이 완료된 후 이 메시지들을 한 번에 전달했으며, v2.1.204에서 실시간 전달이 복원되었습니다.

[`startup()`](#startup)으로 세션을 시작하는 경우, `.query()`를 호출하고 그 결과를 반복하면 이러한 메시지가 전달됩니다.

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

훅이 실행되는 동안 stdout/stderr 출력과 함께 발생합니다.

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

훅 실행이 완료될 때 발생합니다.

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

도구가 실행되는 동안 진행 상황을 나타내기 위해 주기적으로 발생합니다.

```typescript theme={null}
type SDKToolProgressMessage = {
  type: "tool_progress";
  tool_use_id: string;
  tool_name: string;
  parent_tool_use_id: string | null;
  elapsed_time_seconds: number;
  task_id?: string;
  heartbeat?: boolean;
  subagent_type?: string;
  subagent_retry?: {
    agent_id: string;
    attempt: number;
    max_retries: number;
    retry_delay_ms: number;
    error_status: number | null;
    error_category: string;
  };
  uuid: UUID;
  session_id: string;
};
```

메인 대화에서 도구 호출이 실행되는 동안 Claude Code는 30초마다 `heartbeat: true`가 포함된 `tool_progress` 메시지를 내보냅니다. 각 하트비트에는 도구 이름과 경과 시간(초)이 담기므로, 오래 실행되는 호출과 멈춘 세션을 구분할 수 있습니다. Claude Code는 서브에이전트 내부의 도구 호출에 대해서는 하트비트를 내보내지 않습니다. `heartbeat` 필드에는 Agent SDK v0.3.214 이상이 필요합니다. v2.1.257 이전에는 Claude Code가 포그라운드 Agent 도구 호출에 대해서도 하트비트를 내보내지 않았습니다.

하트비트가 아닌 Agent 도구의 `tool_progress` 메시지에서 `subagent_type`은 `general-purpose`처럼 실행 중인 서브에이전트 타입을 나타냅니다. `subagent_retry`는 해당 서브에이전트가 속도 제한이나 과부하 같은 API 오류 백오프를 기다리는 동안 존재하며, 재시도 시도마다 메시지가 하나씩 발생합니다. 두 필드 모두 Agent SDK v0.3.214 이상이 필요합니다.

`subagent_retry`로 재시도 표시기를 렌더링하려면 다음을 따릅니다.

* 서브에이전트마다 고유한 `parent_tool_use_id`로 표시기를 추적합니다. `tool_use_id`는 한 어시스턴트 턴에서 나온 병렬 서브에이전트들이 공유하므로, 이를 기준으로 추적하면 한 서브에이전트의 업데이트가 다른 서브에이전트의 표시기를 지울 수 있습니다.
* 같은 `parent_tool_use_id`에 대해 `subagent_retry`도 `heartbeat: true`도 없는 이후의 `tool_progress`가 도착하거나, 도구의 결과 메시지가 도착하면 표시기를 지웁니다. `heartbeat: true`가 있는 프레임은 활성 상태만 보고하므로, 이러한 프레임이 도착해도 표시기를 유지합니다. 지속적인 재시도에서는 `attempt`가 `max_retries`를 초과할 수 있으므로, 카운터를 기준으로 지우기를 결정하면 안 됩니다.
* `error_category`는 표시 텍스트가 아니라 자체 메시지 텍스트를 선택하기 위한 토큰으로 취급합니다. 값은 `rate_limit`, `overloaded`, `authentication_failed`, `server_error`, `cloud_credential_error`, `unknown`입니다. 이후 릴리스에서 값이 추가될 수 있으므로, 인식하지 못하는 값은 `unknown`과 같은 방식으로 처리합니다.

### `SDKAuthStatusMessage`

인증 흐름 중에 발생합니다.

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

작업이 시작될 때 발생합니다. `task_type` 필드는 Bash 명령과 [Monitor](#monitor) 감시의 경우 `"local_bash"`, 서브에이전트의 경우 `"local_agent"`, 또는 `"remote_agent"`입니다.

```typescript theme={null}
type SDKTaskStartedMessage = {
  type: "system";
  subtype: "task_started";
  task_id: string;
  run_id?: string;
  tool_use_id?: string;
  description: string;
  task_type?: string;
  is_backgrounded?: boolean;
  spawn_depth?: number;
  parent_task_id?: string;
  ambient?: boolean;
  uuid: UUID;
  session_id: string;
};
```

`run_id`는 작업의 한 번의 실행을 식별합니다. [Claude가 재개한 서브에이전트](https://code.claude.com/docs/ko/agent-sdk/subagents.md#resume-subagents)처럼 작업이 같은 `task_id`로 다시 실행되면, 새 실행은 새 `run_id`를 받습니다. 이 필드에는 Agent SDK v0.3.292 이상이 필요합니다. 이를 사용해 한 작업의 실행들을 구분합니다.

* **메시지를 실행과 연결**: 한 실행의 `task_started`, [`task_progress`](#sdktaskprogressmessage), [`task_updated`](#sdktaskupdatedmessage), [`task_notification`](#sdktasknotificationmessage) 메시지는 같은 `run_id`를 가집니다. 각 [`SDKBackgroundTasksChangedMessage`](#sdkbackgroundtaskschangedmessage)에 있는 해당 실행의 항목에도 이 값이 담기며, 실행의 알림을 전달하는 사용자 메시지의 origin에 있는 [`runId`](#task-notification-subkinds)에도 담깁니다.
* **늦게 도착한 메시지 감지**: 일반 문자열로 비교하면 한 작업의 실행 ID는 실행이 시작된 순서대로 정렬되므로, `run_id`가 현재 표시 중인 실행보다 앞에 정렬되는 메시지는 이전 실행에서 온 것입니다. 이 비교 외에는 값을 불투명한 것으로 취급합니다.
* **`task_id`로 대체**: 이전 프로세스가 시작한 작업을 닫기 위해 재개된 세션이 내보내는 `task_notification`처럼 메시지에 `run_id`가 없는 경우, `task_id`로 귀속시킵니다.

예를 들어, 식별 필드만 남긴 다음 세 메시지는 Claude가 한 번 재개한 백그라운드 서브에이전트에서 나온 것입니다. 두 `task_started` 메시지는 `task_id`를 공유하며, 첫 번째 실행을 종료한 알림은 첫 번째 실행의 ID를 가집니다.

```json theme={null}
{"subtype": "task_started", "task_id": "a5c2e8f41b09d7a36", "run_id": "0mubbs7i8-6f0c2d41"}
{"subtype": "task_notification", "task_id": "a5c2e8f41b09d7a36", "run_id": "0mubbs7i8-6f0c2d41", "status": "completed"}
{"subtype": "task_started", "task_id": "a5c2e8f41b09d7a36", "run_id": "0mubc18m1-b7719e05"}
```

`ambient`는 Claude Code가 자체 운영을 위해 실행하는 작업처럼 세션의 작업에 속하지 않는 작업에 대해 `true`입니다. 사용자가 요청한 감시자를 포함해 실시간 업데이트 감시자도 ambient입니다. 활동 표시기에서 ambient 작업은 제외합니다. 이 필드에는 Agent SDK v0.3.247 이상이 필요합니다.

`ambient`는 [`SDKTaskNotificationMessage`](#sdktasknotificationmessage)와 [`SDKBackgroundTasksChangedMessage`](#sdkbackgroundtaskschangedmessage) 항목에도 나타납니다.

`is_backgrounded`와 `spawn_depth`는 Claude Code가 작업을 시작한 방식을 설명합니다. 두 필드 모두 Agent SDK v0.3.238 이상이 필요합니다.

* `is_backgrounded`: Claude Code는 `"local_agent"` 및 `"local_bash"` 작업에 이 값을 설정합니다. `true`는 작업이 백그라운드에서 실행됨을 의미합니다. `false`는 작업이 포그라운드에서 실행됨을 의미하며, 작업을 시작한 도구 호출은 작업이 완료되거나 백그라운드로 이동할 때까지 차단된 상태로 유지됩니다.
* `spawn_depth`: Claude Code는 `"local_agent"` 작업에만 이 값을 설정합니다. 메인 스레드가 생성한 서브에이전트의 깊이는 `1`입니다. 깊이 `1`인 서브에이전트가 생성한 서브에이전트의 깊이는 `2`이며, 이후도 마찬가지입니다.

Claude Code는 재개된 모든 서브에이전트를 백그라운드에서 실행하므로, [재개된 서브에이전트](https://code.claude.com/docs/ko/agent-sdk/subagents.md#resume-subagents)는 항상 `is_backgrounded: true`를 보고합니다. 포그라운드 작업이 나중에 백그라운드로 이동하면, Claude Code는 두 번째 `task_started`를 보내는 대신 [`task_updated`](#sdktaskupdatedmessage) 메시지로 새 `is_backgrounded` 값을 보고합니다.

`parent_task_id`에는 이 작업을 실행한 서브에이전트의 `task_id`가 담깁니다. 이를 사용해 각 작업을 시작한 서브에이전트 아래로 그룹화합니다. Claude Code는 서브에이전트, Bash, [Monitor](#monitor) 작업에 이 값을 설정합니다. 이 필드에는 Agent SDK v0.3.292 이상이 필요합니다. 다음의 경우에는 이 필드가 없습니다.

* 메인 스레드가 작업을 실행한 경우
* Claude Code가 더 이상 상위 작업을 추적하지 않는 경우
* [팀원](https://code.claude.com/docs/ko/agent-teams.md) 또는 워크플로 내부의 에이전트가 작업을 실행한 경우

상위 작업은 포그라운드 작업이거나 이미 종료된 작업일 수 있으므로, 인식하지 못하는 ID는 상위 작업이 없는 것으로 취급합니다.

### `SDKTaskProgressMessage`

서브에이전트 또는 백그라운드 작업이 실행되는 동안 주기적으로 발생합니다. `run_id` 필드에 대해서는 해당 필드와 버전 요구 사항을 정의하는 [`SDKTaskStartedMessage`](#sdktaskstartedmessage)를 참조하세요.

서브에이전트 작업의 경우 `summary` 필드에는 모델이 생성한 진행 상황 요약이 담기며, [`agentProgressSummaries`](#options)가 활성화된 경우에만 채워집니다. [백그라운드로 이동한 MCP 도구 호출](https://code.claude.com/docs/ko/mcp.md#automatic-backgrounding-of-long-tool-calls)의 경우 `summary`에는 MCP 서버가 마지막으로 보고한 진행 상황이 담기며, 해당 옵션과는 관계가 없습니다.

```typescript theme={null}
type SDKTaskProgressMessage = {
  type: "system";
  subtype: "task_progress";
  task_id: string;
  run_id?: string;
  tool_use_id?: string;
  description: string;
  subagent_type?: string;
  usage: {
    total_tokens: number;
    tool_uses: number;
    duration_ms: number;
  };
  last_tool_name?: string;
  summary?: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKTaskUpdatedMessage`

백그라운드 작업의 상태가 `running`에서 `completed`로 전환될 때처럼 변경될 때 발생합니다. `task_id`를 키로 하는 로컬 작업 맵에 `patch`를 병합합니다. `end_time` 필드는 밀리초 단위의 Unix epoch 타임스탬프로, `Date.now()`와 비교할 수 있습니다. `run_id` 필드에 대해서는 해당 필드와 버전 요구 사항을 정의하는 [`SDKTaskStartedMessage`](#sdktaskstartedmessage)를 참조하세요.

```typescript theme={null}
type SDKTaskUpdatedMessage = {
  type: "system";
  subtype: "task_updated";
  task_id: string;
  run_id?: string;
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

### `SDKBackgroundTasksChangedMessage`

활성 백그라운드 작업 집합이 변경될 때마다 발생합니다. 작업이 시작, 완료 또는 종료되거나, 포그라운드 에이전트가 백그라운드로 이동하거나, 작업의 `description`, `ambient` 또는 `parent_task_id` 필드가 변경되는 경우입니다. 각 항목의 `run_id` 및 `parent_task_id` 필드에 대해서는 해당 필드와 버전 요구 사항을 정의하는 [`SDKTaskStartedMessage`](#sdktaskstartedmessage)를 참조하세요.

`tasks` 배열은 전체 활성 집합입니다. `task_started`와 `task_notification` 이벤트를 짝짓는 대신 각 페이로드로 캐시된 집합을 대체하면, 놓친 이벤트가 있더라도 다음 구성원 변경 시 바로잡힙니다.

작업이 종료되면 해당 작업의 [`task_updated`](#sdktaskupdatedmessage)와 [`task_notification`](#sdktasknotificationmessage)이 목록에서 해당 작업을 제거하는 `background_tasks_changed`보다 먼저 도착합니다. 그 외에 작업별 이벤트와의 상대적 순서는 지정되어 있지 않습니다.

시작 시에는 아무것도 발생하지 않습니다. 세션의 CLI 프로세스가 시작되거나 재시작될 때마다 빈 집합으로 재설정하고, 다음 구성원 변경으로 다시 채워지도록 합니다.

전송 중단 후 [`reinitialize()`](#query-object)를 사용하는 경우처럼 실행 중인 세션에 반복된 `initialize` 제어 요청을 보내면, Claude Code는 응답 뒤에 현재 활성 집합의 스냅샷을 보내며, 집합이 비어 있어도 보냅니다. 따라서 다시 연결하는 호스트는 다음 구성원 변경을 기다리지 않고도 무엇이 실행 중인지 알 수 있습니다. Agent SDK v0.3.239 이전에는 반복된 `initialize` 후에 Claude Code가 스냅샷을 보내지 않았습니다.

Claude Code v2.1.203 이상이 필요합니다.

```typescript theme={null}
type SDKBackgroundTasksChangedMessage = {
  type: "system";
  subtype: "background_tasks_changed";
  tasks: {
    task_id: string;
    run_id?: string;
    task_type: string;
    subagent_type?: string;
    description: string;
    parent_task_id?: string;
    ambient?: boolean;
  }[];
  uuid: UUID;
  session_id: string;
};
```

`subagent_type`은 [`task_type`](#sdktaskstartedmessage)이 `"local_agent"`인 항목에서 `general-purpose`나 사용자 지정 서브에이전트의 이름처럼 서브에이전트 타입을 나타냅니다. 이 필드에는 Agent SDK v0.3.293 이상이 필요합니다.

### `SDKThinkingTokensMessage`

Claude가 수정된(redacted) 블록을 포함해 thinking 블록을 생성하는 동안 발생합니다. `estimated_tokens`는 현재 블록에서 지금까지 생성된 사고 토큰의 누적 추정치이고, `estimated_tokens_delta`는 이 프레임이 전달하는 증가분입니다. 이 추정치는 진행 상황 표시에 사용합니다.

모델이나 제공자가 분류를 보고하는 경우, 최상위 에이전트 루프의 최종 수는 결과 메시지의 [`usage.output_tokens_details.thinking_tokens`](#usage)이며, 여기에는 [서브에이전트 토큰이 포함되지 않습니다](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#get-the-total-cost-of-a-query).

Claude Code v2.1.153 이상이 필요합니다.

```typescript theme={null}
type SDKThinkingTokensMessage = {
  type: "system";
  subtype: "thinking_tokens";
  estimated_tokens: number;
  estimated_tokens_delta: number;
  user_message_uuid?: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKSessionStateChangedMessage`

Claude Code가 세션의 상태를 보고할 때 발생합니다. 이 메시지를 받으려면 [`CLAUDE_CODE_EMIT_SESSION_STATE_EVENTS=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정합니다. Claude Code는 같은 상태를 두 번 이상 보고할 수 있으므로, 메시지를 전환이 아닌 세션의 현재 상태로 읽어야 합니다.

`state` 필드에는 다음 값 중 하나가 담깁니다.

* `running`: 세션이 작업 중입니다.
* `idle`: Claude Code가 다음 프롬프트를 기다리고 있습니다.
* `requires_action`: 세션이 권한 프롬프트처럼 호스트에 보낸 요청에 대한 응답을 기다리며 차단되어 있습니다.

한 턴의 `idle` 메시지와 `result` 메시지는 어느 순서로든 도착할 수 있습니다. 백그라운드 서브에이전트나 [워크플로](https://code.claude.com/docs/ko/workflows.md) 실행 같은 백그라운드 작업을 `idle`이 기다릴지 여부를 변경하려면 [`CLAUDE_CODE_BG_TASKS_REPORT_RUNNING`](https://code.claude.com/docs/ko/env-vars#variables)을 참조하세요.

```typescript theme={null}
type SDKSessionStateChangedMessage = {
  type: "system";
  subtype: "session_state_changed";
  state: "idle" | "running" | "requires_action";
  uuid: UUID;
  session_id: string;
};
```

### `SDKFilesPersistedEvent`

파일 체크포인트가 디스크에 저장될 때 발생합니다.

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

세션이 속도 제한에 걸렸을 때 발생합니다.

```typescript theme={null}
type SDKRateLimitEvent = {
  type: "rate_limit_event";
  rate_limit_info: {
    status: "allowed" | "allowed_warning" | "rejected";
    resetsAt?: number;
    utilization?: number;
    errorCode?: "credits_required";
    canUserPurchaseCredits?: boolean;
    hasChargeableSavedPaymentMethod?: boolean;
  };
  uuid: UUID;
  session_id: string;
};
```

`errorCode`가 `"credits_required"`이면 포함된 사용량이 소진된 claude.ai 구독에서 거부된 것이며, 사용자가 사용량 크레딧을 구매할 때까지 세션을 계속할 수 없습니다. `canUserPurchaseCredits`는 인증된 사용자가 계정에 대한 크레딧을 구매할 수 있는지를 나타내고, `hasChargeableSavedPaymentMethod`는 저장된 결제 수단이 등록되어 있는지를 나타냅니다. 크레딧 필요로 인한 거부가 아닌 속도 제한 이벤트에는 세 필드 모두 없습니다. Claude Code v2.1.181 이상이 필요합니다.

### `SDKLocalCommandOutputMessage`

Claude Code는 이 메시지 타입을 내보내지 않습니다. `/context`나 `/usage` 같은 명령을 프롬프트로 보내면 그 출력은 [`SDKAssistantMessage`](#sdkassistantmessage)로 도착합니다.

```typescript theme={null}
type SDKLocalCommandOutputMessage = {
  type: "system";
  subtype: "local_command_output";
  content: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKCommandsChangedMessage`

에이전트가 하위 디렉터리에 들어갈 때 Claude Code가 스킬을 발견하는 경우처럼, 세션 중에 사용 가능한 명령 집합이 변경될 때 발생합니다. `commands` 배열은 업데이트된 전체 목록이므로, 캐시된 명령 목록을 이 페이로드로 대체합니다. 이 메서드는 최신 푸시를 추적하므로, 이 메시지 이후 [`supportedCommands()`](#query-object)를 호출하면 동일한 업데이트된 목록이 반환됩니다. 이를 위해서는 Agent SDK v0.3.216 이상이 필요합니다. 이전 SDK 버전에서는 `supportedCommands()`가 초기화 시 캡처한 스냅샷을 반환하며 세션 중 변경 사항을 절대 반영하지 않습니다.

Claude Code는 예를 들어 세션이 시작된 후 서버 연결이 완료될 때처럼 MCP 서버의 [프롬프트](https://code.claude.com/docs/ko/mcp.md#use-mcp-prompts-as-commands)가 목록에 추가되거나 목록에서 제거될 때도 이 메시지를 내보냅니다. 이를 위해서는 Claude Code v2.1.281 이상이 필요합니다.

```typescript theme={null}
type SDKCommandsChangedMessage = {
  type: "system";
  subtype: "commands_changed";
  commands: SlashCommand[];
  uuid: UUID;
  session_id: string;
};
```

### `SDKPromptSuggestionMessage`

[`promptSuggestions`](#options)가 활성화되어 있고 Claude Code가 해당 턴에 대한 제안을 생성한 경우, 턴이 끝난 후 발생합니다. 예측된 다음 사용자 프롬프트가 담깁니다. 제안을 받지 않는 턴에 대해서는 [Claude Code가 제안을 건너뛰는 경우](https://code.claude.com/docs/ko/interactive-mode.md#when-claude-code-skips-suggestions)를 참조하세요.

```typescript theme={null}
type SDKPromptSuggestionMessage = {
  type: "prompt_suggestion";
  suggestion: string;
  uuid: UUID;
  session_id: string;
};
```

### `SDKConversationResetMessage`

세션을 종료하지 않고 세션의 대화가 대체될 때 발생합니다. `query()` 호출에서는 `/clear`와 그 별칭만 이 메시지를 생성합니다. `new_conversation_id` 아래에 빈 트랜스크립트를 마운트하고 캐시된 세션 제목을 삭제합니다.

```typescript theme={null}
type SDKConversationResetMessage = {
  type: "conversation_reset";
  new_conversation_id: UUID;
  uuid: UUID;
  session_id: string;
  trigger?: "clear" | "plan_mode_exit" | "fresh_session" | "onboarding";
  user_message_uuid?: string;
  timestamp?: string;
};
```

선택적 필드는 재설정을 설명합니다.

* `trigger`: 대화를 폐기한 원인입니다. 이 필드가 없거나 인식하지 못하는 값이 담긴 경우를 포함해 모든 `conversation_reset` 메시지에서 트랜스크립트를 재설정합니다.
* `user_message_uuid`: `/clear`를 담은 사용자 메시지의 `uuid`입니다. 재설정을 해당 메시지와 연결하는 데 사용합니다.
* `timestamp`: 재설정이 발생한 시각으로, UTC 기준 ISO 8601 문자열입니다. 메시지 순서 지정이 아닌 표시 용도로 사용합니다.

`trigger`, `user_message_uuid`, `timestamp` 필드에는 Claude Code v2.1.281 이상이 필요합니다.

SDK의 공개 타입 정의는 Claude Code v2.1.203 이상에서 `SDKConversationResetMessage`를 선언합니다. v2.1.203 이전에는 `SDKMessage`가 이 타입을 선언 없이 참조했기 때문에, `skipLibCheck`가 비활성화된 경우 `type === "conversation_reset"`으로 타입을 좁히면 타입 검사에 실패했습니다.

### `BUILTIN_TOOL_NAMES` 및 `LEGACY_TOOL_NAME_ALIASES`

애플리케이션 사용자가 입력한 도구 이름을 확인하려면 이 두 상수를 사용합니다. 두 상수 모두 권한 규칙, 훅 matcher, `tools` 및 `disallowedTools` 옵션에서 작성하는 방식대로 각 이름을 표기합니다. `@anthropic-ai/claude-agent-sdk` 또는 `@anthropic-ai/claude-agent-sdk/core`에서 가져옵니다. Agent SDK v0.3.301 이상이 필요하며 알파 단계입니다.

SDK의 타입 선언은 `BUILTIN_TOOL_NAMES`에 readonly 튜플 타입을, `LEGACY_TOOL_NAME_ALIASES`에 문자열-문자열 레코드 타입을 부여합니다.

```typescript theme={null}
const BUILTIN_TOOL_NAMES: readonly ["Agent", /* ...more names... */ "Write"];
const LEGACY_TOOL_NAME_ALIASES: Readonly<Record<string, string>>;
```

* **`BUILTIN_TOOL_NAMES`**: `Agent`, `Bash`, `Read`처럼 Claude Code 기본 제공 도구의 이름을 알파벳순으로 나열합니다. MCP 도구 이름은 포함되지 않습니다. 타입이 문자열 리터럴의 튜플이므로 `(typeof BUILTIN_TOOL_NAMES)[number]`로 이름의 유니온 타입을 얻을 수 있습니다
* **`LEGACY_TOOL_NAME_ALIASES`**: 권한 규칙, 훅 matcher, `tools` 및 `disallowedTools` 옵션에서 여전히 허용되는 이전 도구 이름입니다. 각 키는 이전 이름이고 값은 현재 이름입니다. 예를 들어 `Task`는 `Agent`에 매핑되고, `KillShell`과 `KillBash`는 `TaskStop`에 매핑됩니다

이름은 두 가지 테스트 중 하나로 확인할 수 있습니다. `BUILTIN_TOOL_NAMES`에 포함되어 있거나, `Object.hasOwn(LEGACY_TOOL_NAME_ALIASES, name)`이 `true`를 반환하는 경우입니다. `BUILTIN_TOOL_NAMES`에는 MCP 도구와 일부 기본 제공 도구가 빠져 있으므로, 두 테스트를 모두 통과하지 못한 이름도 유효할 수 있습니다. `BUILTIN_TOOL_NAMES`로 거부 목록을 만들면 Claude는 이 상수에서 빠진 도구를 여전히 사용할 수 있습니다. 모든 도구를 거부하려면 대신 [`disallowedTools: ["*"]`](https://code.claude.com/docs/ko/agent-sdk/permissions#allow-and-deny-rules)를 설정합니다.

`BUILTIN_TOOL_NAMES`에서 이름을 찾았다고 해서 세션에 해당 도구가 있다는 의미는 아닙니다. 예를 들어 `TodoWrite`는 [기본적으로 비활성화](https://code.claude.com/docs/ko/tools-reference.md)되어 있지만 목록에 포함되어 있습니다. 세션에 어떤 도구가 있는지 확인하려면 해당 세션의 [`SDKSystemMessage`](#sdksystemmessage)에 있는 `tools` 배열을 읽습니다. 이 배열에는 MCP 도구가 포함되고 Agent 도구가 `Task`로 나열되므로, `BUILTIN_TOOL_NAMES`와 비교하기 전에 각 이름을 `LEGACY_TOOL_NAME_ALIASES`로 매핑합니다.

### `AbortError`

중단 작업을 위한 사용자 지정 오류 클래스입니다.

```typescript theme={null}
class AbortError extends Error {}
```

`AbortError`는 SDK의 타입이 지정된 API에서 유일한 오류 클래스입니다. Claude Code 프로세스가 종료되거나 실행에 실패하는 것과 같은 다른 실패는 매칭할 SDK 클래스가 없는 오류로 메시지 반복을 reject합니다. [문제 해결](https://code.claude.com/docs/ko/agent-sdk/troubleshooting.md)에서는 이러한 오류를 메시지별로 정리하고 각각의 원인과 해결 방법을 안내합니다.

## 샌드박스 구성

### `SandboxSettings`

샌드박스 동작의 구성입니다. 이를 사용하여 명령 샌드박싱을 활성화하고 프로그래밍 방식으로 네트워크 제한을 구성합니다.

```typescript theme={null}
type SandboxSettings = {
  enabled?: boolean;
  failIfUnavailable?: boolean;
  autoAllowBashIfSandboxed?: boolean;
  excludedCommands?: string[];
  allowUnsandboxedCommands?: boolean;
  network?: SandboxNetworkConfig;
  filesystem?: SandboxFilesystemConfig;
  ignoreViolations?: Record<string, string[]>;
  enableWeakerNestedSandbox?: boolean;
  allowNestedUserNamespaces?: boolean;
  ripgrep?: { command: string; args?: string[] };
};
```

| 속성 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `enabled` | `boolean` | `false` | 명령 실행을 위한 샌드박스 모드 활성화 |
| `failIfUnavailable` | `boolean` | `true` | `enabled`가 `true`이지만 샌드박스를 시작할 수 없는 경우 시작 시 중지합니다. stderr에 경고와 함께 샌드박스되지 않은 실행으로 폴백하려면 `false`로 설정합니다 |
| `autoAllowBashIfSandboxed` | `boolean` | `true` | 샌드박스가 활성화되었을 때 Bash 명령 자동 승인 |
| `excludedCommands` | `string[]` | `[]` | 샌드박스 제한을 무시하는 명령입니다(예: `['docker *']`). 이들은 모델 개입 없이 자동으로 샌드박스되지 않은 상태로 실행됩니다. [`sandbox.excludedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-excludedcommands)는 항목이 적용되는 시기를 다룹니다 |
| `allowUnsandboxedCommands` | `boolean` | `true` | 모델이 샌드박스 외부에서 명령을 실행하도록 요청하도록 허용합니다. `true`일 때 모델은 도구 입력에서 `dangerouslyDisableSandbox`를 설정할 수 있으며, 이는 [권한 시스템](#permissions-fallback-for-unsandboxed-commands)으로 폴백됩니다 |
| `network` | [`SandboxNetworkConfig`](#sandboxnetworkconfig) | `undefined` | 네트워크 특정 샌드박스 구성 |
| `filesystem` | [`SandboxFilesystemConfig`](#sandboxfilesystemconfig) | `undefined` | 읽기/쓰기 제한을 위한 파일 시스템 특정 샌드박스 구성 |
| `ignoreViolations` | `Record<string, string[]>` | `undefined` | 명령 부분 문자열 또는 모든 명령에 대해 `*`를 무시할 위반 텍스트의 부분 문자열에 매핑합니다 (예: `{ "*": ['/etc/hosts'] }`). [`sandbox.ignoreViolations`](https://code.claude.com/docs/ko/settings-reference#sandbox-ignoreviolations)을 참조합니다 |
| `enableWeakerNestedSandbox` | `boolean` | `false` | 호환성을 위해 더 약한 중첩 샌드박스 활성화 |
| `allowNestedUserNamespaces` | `boolean` | `false` | Linux 및 WSL2에서 샌드박스된 명령이 사용자 네임스페이스를 생성할 수 있도록 합니다. `true`로 설정하기 전에 이 설정이 필요한 도구와 해제되는 보안 경계를 다루는 [`sandbox.allowNestedUserNamespaces`](https://code.claude.com/docs/ko/settings-reference#sandbox-allownestedusernamespaces)를 읽어 보십시오. Claude Code v2.1.305 이상이 필요합니다 |
| `ripgrep` | `{ command: string; args?: string[] }` | `undefined` | 샌드박스 환경을 위한 사용자 정의 ripgrep 바이너리 구성 |

> [!NOTE]
>
> 샌드박스는 플랫폼 지원에 따라 다르며, Linux에서는 `bubblewrap` 및 `socat`과 같은 도구가 필요합니다. `enabled`가 `true`이고 샌드박스를 시작할 수 없는 경우 `query()`는 `subtype: "error_during_execution"`이 있는 `result` 메시지를 보고하고 `errors`에 이유를 표시합니다. 단일 메시지 `query()` 호출의 경우 SDK는 해당 오류 결과를 생성한 후 예외를 발생시키므로 루프를 try 블록으로 래핑하여 이를 지나 계속 진행합니다. 오류 계약에 대해서는 [결과 처리](https://code.claude.com/docs/ko/agent-sdk/agent-loop.md#handle-the-result)를 참조합니다.
>
> 대신 샌드박스되지 않은 상태로 실행하려면 `failIfUnavailable: false`를 설정합니다.

#### 사용 예제

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

try {
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
} catch (error) {
  // 단일 쿼리 query()는 오류 결과를 생성한 후 예외를 발생시킵니다.
  // 예를 들어 샌드박스를 시작할 수 없는 경우 (failIfUnavailable은 기본값이 true입니다).
  console.log(`Session ended with an error: ${error}`);
}
```

> [!WARNING]
>
> **Unix 소켓 보안:** `allowUnixSockets` 옵션은 샌드박스 외부에 도달하는 시스템 서비스에 대한 액세스를 부여할 수 있습니다. 예를 들어 `/var/run/docker.sock`을 허용하면 Docker API를 통해 전체 호스트 시스템 액세스를 효과적으로 부여하여 샌드박스 격리를 무시합니다. 엄격히 필요한 Unix 소켓만 허용하고 각각의 보안 영향을 이해합니다.

### `SandboxNetworkConfig`

샌드박스 모드를 위한 네트워크 특정 구성입니다. 이러한 설정은 부모 [`SandboxSettings`](#sandboxsettings)에서 `enabled`가 `true`일 때 샌드박스된 Bash 명령에 적용됩니다. 이들은 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#webfetch)을 대신 사용하는 WebFetch 도구를 제한하지 않습니다.

```typescript theme={null}
type SandboxNetworkConfig = {
  allowedDomains?: string[];
  deniedDomains?: string[];
  strictAllowlist?: boolean;
  allowManagedDomainsOnly?: boolean;
  allowLocalBinding?: boolean;
  allowUnixSockets?: string[];
  allowAllUnixSockets?: boolean;
  httpProxyPort?: number;
  socksProxyPort?: number;
};
```

| 속성 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `allowedDomains` | `string[]` | `[]` | 샌드박스된 프로세스가 액세스할 수 있는 도메인 이름 |
| `deniedDomains` | `string[]` | `[]` | 샌드박스된 프로세스가 액세스할 수 없는 도메인 이름입니다. `allowedDomains`보다 우선합니다 |
| `strictAllowlist` | `boolean` | `false` | [네트워크 허용 목록](https://code.claude.com/docs/ko/sandboxing.md#network-isolation) 외부의 호스트에 대한 샌드박스된 명령 액세스를 거부합니다. 프롬프트 대신 거부합니다. 샌드박스된 명령에만 적용됩니다. WebFetch와 같은 프로세스 내 도구는 이에 의해 제한되지 않습니다. 사용자, 관리형 또는 CLI `--settings` 설정에서만 적용됩니다. 프로젝트 설정은 무시됩니다. Claude Code v2.1.219 이상이 필요합니다 |
| `allowManagedDomainsOnly` | `boolean` | `false` | 관리형 설정 전용입니다. [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 설정되었을 때 관리형 설정의 `allowedDomains` 항목 및 관리형 설정의 `WebFetch(domain:...)` 허용 규칙만 적용되며 사용자, 프로젝트 또는 로컬 설정의 허용 항목은 무시됩니다. SDK에서 [`managedSettings`](#options) 옵션을 통해 전달합니다 |
| `allowLocalBinding` | `boolean` | `false` | 프로세스가 로컬 포트에 바인딩하도록 허용합니다 (예: 개발 서버의 경우) |
| `allowUnixSockets` | `string[]` | `[]` | 프로세스가 액세스할 수 있는 Unix 소켓 경로 (예: Docker 소켓) |
| `allowAllUnixSockets` | `boolean` | `false` | 모든 Unix 소켓 및 Linux에서는 VM 소켓(`AF_VSOCK`)에 대한 액세스 허용 |
| `httpProxyPort` | `number` | `undefined` | 네트워크 요청을 위한 HTTP 프록시 포트 |
| `socksProxyPort` | `number` | `undefined` | 네트워크 요청을 위한 SOCKS 프록시 포트 |

> [!NOTE]
>
> 기본 제공 샌드박스 프록시는 요청된 호스트명을 기반으로 `allowedDomains`를 적용하며 TLS 트래픽을 종료하거나 검사하지 않으므로 [도메인 프론팅](https://en.wikipedia.org/wiki/Domain_fronting)과 같은 기술이 이를 우회할 수 있습니다. 자세한 내용은 [샌드박싱 보안 제한 사항](https://code.claude.com/docs/ko/sandboxing.md#security-limitations)을 참조하고 TLS 종료 프록시 구성에 대해서는 [안전한 배포](https://code.claude.com/docs/ko/agent-sdk/secure-deployment.md#traffic-forwarding)를 참조합니다.

### `SandboxFilesystemConfig`

샌드박스 모드를 위한 파일 시스템 특정 구성입니다.

```typescript theme={null}
type SandboxFilesystemConfig = {
  allowWrite?: string[];
  denyWrite?: string[];
  denyRead?: string[];
};
```

| 속성 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `allowWrite` | `string[]` | `[]` | 쓰기 액세스를 허용할 파일 경로 패턴 |
| `denyWrite` | `string[]` | `[]` | 쓰기 액세스를 거부할 파일 경로 패턴입니다. 세션의 작업 디렉터리에 있는 파일에 대한 샌드박스된 쓰기를 차단하려면 해당 파일의 절대 경로를 나열합니다. |
| `denyRead` | `string[]` | `[]` | 읽기 액세스를 거부할 파일 경로 패턴 |

### 샌드박스되지 않은 명령에 대한 권한 폴백

`allowUnsandboxedCommands`가 활성화되었을 때 모델은 도구 입력에서 `dangerouslyDisableSandbox: true`를 설정하여 샌드박스 외부에서 명령을 실행하도록 요청할 수 있습니다. 이러한 요청은 기존 권한 시스템으로 폴백되므로 `canUseTool` 핸들러가 호출되어 사용자 정의 인증 로직을 구현할 수 있습니다.

`excludedCommands` 항목은 대신 샌드박스를 자동으로 무시하며 모델 개입이 없습니다. [`sandbox.excludedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-excludedcommands)는 항목이 적용되는 시기를 다룹니다.

아래 예제에서 `isCommandAuthorized`는 사용자가 정의하는 인증 확인을 나타냅니다.

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

> [!WARNING]
>
> `dangerouslyDisableSandbox: true`로 실행되는 명령은 전체 시스템 액세스 권한이 있습니다. `canUseTool` 핸들러가 이러한 요청을 신중하게 검증하는지 확인합니다.
>
> `permissionMode`가 `bypassPermissions`로 설정되고 `allowUnsandboxedCommands`가 활성화되면 모델은 [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)을 제외하고 승인 프롬프트 없이 샌드박스 외부에서 명령을 자율적으로 실행할 수 있습니다. 이 조합은 모델이 샌드박스 격리를 조용히 탈출하도록 효과적으로 허용합니다.

## 참고 항목

* [SDK 개요](https://code.claude.com/docs/ko/agent-sdk/overview.md) - 일반 SDK 개념
* [Python SDK 참조](https://code.claude.com/docs/ko/agent-sdk/python.md) - Python SDK 문서
* [CLI 참조](https://code.claude.com/docs/ko/cli-reference.md) - 명령줄 인터페이스
* [일반적인 워크플로우](https://code.claude.com/docs/ko/common-workflows.md) - 단계별 가이드
