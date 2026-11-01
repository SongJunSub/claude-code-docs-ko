> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Agent SDK 참조 - Python

> Python Agent SDK의 완전한 API 참조로, 모든 함수, 타입 및 클래스를 포함합니다.

## 설치

최근 Debian, Ubuntu, 및 Homebrew Python 설치에서 가상 환경에 패키지를 설치합니다. 시스템 Python에 대해 `pip install`을 실행하면 `error: externally-managed-environment` 오류가 발생합니다.

```bash theme={null}
python3 -m venv .venv
source .venv/bin/activate
pip install claude-agent-sdk
```

uv, Windows PowerShell, 및 API 키 설정에 대해서는 [Agent SDK 빠른 시작에서 설정](https://code.claude.com/docs/ko/agent-sdk/quickstart.md#setup)을 참조합니다.

## `query()`와 `ClaudeSDKClient` 중 선택하기

Python SDK는 Claude Code와 상호작용하는 두 가지 방법을 제공합니다.

| 기능 | `query()` | `ClaudeSDKClient` |
| :- | :- | :- |
| **세션** | 기본적으로 새 세션 생성 | 동일한 세션 재사용 |
| **대화** | 단일 교환 | 동일한 컨텍스트에서 여러 교환 |
| **연결** | 자동으로 관리됨 | 수동 제어 |
| **스트리밍 입력** | ✅ 지원됨 | ✅ 지원됨 |
| **중단** | ❌ 지원 안 함 | ✅ 지원됨 |
| **Hooks** | ✅ 지원됨 | ✅ 지원됨 |
| **사용자 정의 도구** | ✅ 지원됨 | ✅ 지원됨 |
| **대화 계속하기** | `continue_conversation` 또는 `resume`을 통한 수동 | ✅ 자동 |
| **사용 사례** | 일회성 작업 | 지속적인 대화 |

`ClaudeSDKClient`는 채팅 인터페이스와 같은 대화형 애플리케이션이나 다음 작업이 Claude의 응답에 따라 달라질 때 사용합니다.

## 함수

> [!NOTE]
>
> 이 페이지의 서명 블록과 bare `async for` / `async with` 조각은 설명용입니다. 실행하려면 본문을 `async def main(): ...`으로 래핑하고 `asyncio.run(main())`을 호출하세요.

### `query()`

Claude Code와의 각 상호작용을 위해 기본적으로 새 세션을 생성합니다. 메시지가 도착하면 생성하는 비동기 반복자를 반환합니다. `query()`에 대한 각 호출은 `continue_conversation=True` 또는 [`ClaudeAgentOptions`](#claudeagentoptions)에서 `resume`을 전달하지 않는 한 이전 상호작용의 메모리 없이 새로 시작합니다. [세션](https://code.claude.com/docs/ko/agent-sdk/sessions.md)을 참조하세요.

```python theme={null}
async def query(
    *,
    prompt: str | AsyncIterable[dict[str, Any]],
    options: ClaudeAgentOptions | None = None,
    transport: Transport | None = None
) -> AsyncIterator[Message]
```

#### 매개변수

| 매개변수 | 타입 | 설명 |
| :- | :- | :- |
| `prompt` | `str \| AsyncIterable[dict]` | 문자열 또는 스트리밍 모드용 비동기 반복 가능 객체로서의 입력 프롬프트 |
| `options` | `ClaudeAgentOptions \| None` | 선택적 구성 객체 (None인 경우 `ClaudeAgentOptions()`로 기본값 설정) |
| `transport` | `Transport \| None` | CLI 프로세스와 통신하기 위한 선택적 사용자 정의 전송 |

#### 반환값

대화에서 메시지를 생성하는 `AsyncIterator[Message]`를 반환합니다.

#### 예제 - 옵션 포함

```python theme={null}
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions


async def main():
    options = ClaudeAgentOptions(
        system_prompt="You are an expert Python developer",
        permission_mode="acceptEdits",
    )

    async for message in query(prompt="Create a Python web server", options=options):
        print(message)


asyncio.run(main())
```

### `tool()`

타입 안전성을 갖춘 MCP 도구를 정의하기 위한 데코레이터입니다.

```python theme={null}
def tool(
    name: str,
    description: str,
    input_schema: type | dict[str, Any],
    annotations: ToolAnnotations | None = None
) -> Callable[[Callable[[Any], Awaitable[dict[str, Any]]]], SdkMcpTool[Any]]
```

#### 매개변수

| 매개변수 | 타입 | 설명 |
| :- | :- | :- |
| `name` | `str` | 도구의 고유 식별자 |
| `description` | `str` | 도구가 수행하는 작업에 대한 인간이 읽을 수 있는 설명 |
| `input_schema` | `type \| dict[str, Any]` | 도구의 입력 매개변수를 정의하는 스키마. [입력 스키마 옵션](#input-schema-options) 참조 |
| `annotations` | [`ToolAnnotations`](#toolannotations)` \| None` | 클라이언트에 동작 힌트를 제공하는 선택적 MCP 도구 주석 |

#### 입력 스키마 옵션

1. **간단한 타입 매핑** (권장):

   ```python theme={null}
   {"text": str, "count": int, "enabled": bool}
   ```

2. **JSON Schema 형식** (복잡한 검증용):
   ```python theme={null}
   {
       "type": "object",
       "properties": {
           "text": {"type": "string"},
           "count": {"type": "integer", "minimum": 0},
       },
       "required": ["text"],
   }
   ```

3. **TypedDict 클래스**: `NotRequired` 키가 `required`에서 제외되는 타입 지정 스키마입니다.

   * **Python 3.11 이상**: `typing`에서 `TypedDict`와 `NotRequired`를 가져옵니다.
   * **Python 3.10**: `typing`에는 `NotRequired`가 없습니다. SDK가 Python 3.10에 설치하는 `typing_extensions`에서 `TypedDict`와 `NotRequired`를 가져옵니다.

   ```python theme={null}
   from typing import Annotated, Any, NotRequired, TypedDict
   from claude_agent_sdk import tool


   class ForecastArgs(TypedDict):
       latitude: Annotated[float, "Latitude coordinate"]
       hours: NotRequired[Annotated[int, "How many hours of forecast to return"]]


   @tool("get_forecast", "Get the hourly forecast for a location", ForecastArgs)
   async def get_forecast(args: dict[str, Any]) -> dict[str, Any]:
       hours = args.get("hours", 12)
       return {"content": [{"type": "text", "text": f"{hours}-hour forecast for {args['latitude']}"}]}
   ```

간단한 매핑 및 TypedDict 형식에서는 타입을 `Annotated[type, "description"]`으로 감싸 필드의 설명을 설정합니다.

#### 반환값

도구 구현을 래핑하고 `SdkMcpTool` 인스턴스를 반환하는 데코레이터 함수입니다.

#### 예제

```python theme={null}
from claude_agent_sdk import tool
from typing import Any


@tool("greet", "Greet a user", {"name": str})
async def greet(args: dict[str, Any]) -> dict[str, Any]:
    return {"content": [{"type": "text", "text": f"Hello, {args['name']}!"}]}
```

#### `ToolAnnotations`

[`tool()`](#tool)의 `annotations` 인수로 전달되는 도구의 동작 힌트입니다. `ToolAnnotations`는 MCP SDK의 `mcp.types.ToolAnnotations`를 `maxResultSizeChars` 필드로 확장하며, 각 힌트를 camelCase 또는 snake\_case로 작성할 수 있습니다: `ToolAnnotations(readOnlyHint=True)`와 `ToolAnnotations(read_only_hint=True)`는 동등합니다. 객체에서 힌트를 다시 읽으려면 설치된 `mcp` 패키지가 선언하는 표기를 사용합니다: `mcp` 1.x에서는 `.readOnlyHint`, 2.x에서는 `.read_only_hint`를 사용하며, `.maxResultSizeChars`는 두 버전 모두에서 작동합니다. SDK가 주석을 허용하는 곳에 일반 `mcp.types.ToolAnnotations`를 전달할 수도 있습니다.

snake\_case 이름과 타입이 지정된 `maxResultSizeChars` 필드는 Python Agent SDK 0.2.140 이상이 필요합니다. 버전 0.1.31부터 0.2.139까지는 `mcp.types.ToolAnnotations`를 변경하지 않고 다시 내보냅니다. 버전 0.1.55부터 0.2.139까지는 여전히 `maxResultSizeChars`를 키워드 인수로 전달할 수 있습니다: MCP 클래스는 추가 필드를 허용하고 SDK는 값을 Claude Code로 전달합니다.

모든 필드는 선택적입니다. 클라이언트는 보안 결정을 위해 힌트에 의존해서는 안 됩니다.

| 필드 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `title` | `str \| None` | `None` | 도구의 인간이 읽을 수 있는 제목 |
| `readOnlyHint` | `bool \| None` | `False` | `True`인 경우, 도구는 환경을 수정하지 않습니다 |
| `destructiveHint` | `bool \| None` | `True` | `True`인 경우, 도구는 파괴적인 업데이트를 수행할 수 있습니다 (`readOnlyHint`가 `False`일 때만 의미 있음) |
| `idempotentHint` | `bool \| None` | `False` | `True`인 경우, 동일한 인수로 반복 호출해도 추가 효과가 없습니다 (`readOnlyHint`가 `False`일 때만 의미 있음) |
| `openWorldHint` | `bool \| None` | `True` | `True`인 경우, 도구는 외부 엔티티와 상호작용합니다 (예: 웹 검색). `False`인 경우, 도구의 도메인은 폐쇄적입니다 (예: 메모리 도구) |
| `maxResultSizeChars` | `int \| None` | `None` | Claude Code가 이 도구의 텍스트 결과를 파일에 저장하는 대신 대화에 인라인으로 유지하는 문자 수 (최대 500,000). 이미지를 포함하는 결과는 영향을 받지 않습니다. MCP 힌트가 아닌 Claude Code 설정입니다: SDK는 도구의 `_meta`에서 `anthropic/maxResultSizeChars`로 전송합니다. [특정 도구의 제한 상향](https://code.claude.com/docs/ko/mcp.md#raise-the-limit-for-a-specific-tool) 참조 |

```python theme={null}
from claude_agent_sdk import tool, ToolAnnotations
from typing import Any


@tool(
    "search",
    "Search the web",
    {"query": str},
    annotations=ToolAnnotations(readOnlyHint=True, openWorldHint=True),
)
async def search(args: dict[str, Any]) -> dict[str, Any]:
    return {"content": [{"type": "text", "text": f"Results for: {args['query']}"}]}
```

### `create_sdk_mcp_server()`

Python 애플리케이션 내에서 실행되는 인프로세스 MCP 서버를 생성합니다.

```python theme={null}
def create_sdk_mcp_server(
    name: str,
    version: str = "1.0.0",
    tools: list[SdkMcpTool[Any]] | None = None
) -> McpSdkServerConfig
```

#### 매개변수

| 매개변수 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `name` | `str` | - | 서버의 고유 식별자 |
| `version` | `str` | `"1.0.0"` | 서버 버전 문자열 |
| `tools` | `list[SdkMcpTool[Any]] \| None` | `None` | `@tool` 데코레이터로 생성된 도구 함수 목록 |

#### 반환값

`ClaudeAgentOptions.mcp_servers`에 전달할 수 있는 `McpSdkServerConfig` 객체를 반환합니다.

#### 예제

```python theme={null}
from claude_agent_sdk import tool, create_sdk_mcp_server, ClaudeAgentOptions


@tool("add", "Add two numbers", {"a": float, "b": float})
async def add(args):
    return {"content": [{"type": "text", "text": f"Sum: {args['a'] + args['b']}"}]}


@tool("multiply", "Multiply two numbers", {"a": float, "b": float})
async def multiply(args):
    return {"content": [{"type": "text", "text": f"Product: {args['a'] * args['b']}"}]}


calculator = create_sdk_mcp_server(
    name="calculator",
    version="2.0.0",
    tools=[add, multiply],  # Pass decorated functions
)

# Use with Claude
options = ClaudeAgentOptions(
    mcp_servers={"calc": calculator},
    allowed_tools=["mcp__calc__add", "mcp__calc__multiply"],
)
```

### `list_sessions()`

메타데이터가 포함된 과거 세션을 나열합니다. 프로젝트 디렉토리로 필터링하거나 모든 프로젝트의 세션을 나열합니다. 동기식이며 즉시 반환됩니다.

```python theme={null}
def list_sessions(
    directory: str | None = None,
    limit: int | None = None,
    offset: int = 0,
    include_worktrees: bool = True
) -> list[SDKSessionInfo]
```

#### 매개변수

| 매개변수 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `directory` | `str \| None` | `None` | 세션을 나열할 디렉토리. 생략하면 모든 프로젝트의 세션을 반환합니다 |
| `limit` | `int \| None` | `None` | 반환할 최대 세션 수 |
| `offset` | `int` | `0` | 정렬된 결과의 시작 부분에서 건너뛸 세션 수. `limit`과 함께 페이지 매김에 사용합니다 |
| `include_worktrees` | `bool` | `True` | `directory`가 git 저장소 내에 있을 때, 모든 worktree 경로의 세션을 포함합니다 |

#### 반환 타입: `SDKSessionInfo`

| 속성 | 타입 | 설명 |
| :- | :- | :- |
| `session_id` | `str` | 고유 세션 식별자 |
| `summary` | `str` | 표시 제목: 사용자 정의 제목, 가장 최근 프롬프트, 자동 생성된 요약 또는 첫 프롬프트 |
| `last_modified` | `int` | 에포크 이후 마지막 수정 시간 (밀리초) |
| `file_size` | `int \| None` | 세션 파일 크기 (바이트) (원격 저장소 백엔드의 경우 `None`) |
| `custom_title` | `str \| None` | 사용자가 설정한 세션 제목 |
| `first_prompt` | `str \| None` | 세션의 첫 번째 의미 있는 사용자 프롬프트 |
| `git_branch` | `str \| None` | 세션 끝의 Git 브랜치 |
| `cwd` | `str \| None` | 세션의 작업 디렉토리 |
| `tag` | `str \| None` | 사용자가 설정한 세션 태그 ([`tag_session()`](#tag_session) 참조) |
| `created_at` | `int \| None` | 에포크 이후 세션 생성 시간 (밀리초) |

#### 예제

프로젝트의 10개 최신 세션을 인쇄합니다. 결과는 `last_modified` 내림차순으로 정렬되므로 첫 번째 항목이 가장 최신입니다. `directory`를 생략하면 모든 프로젝트를 검색합니다.

```python theme={null}
from claude_agent_sdk import list_sessions

for session in list_sessions(directory="/path/to/project", limit=10):
    print(f"{session.summary} ({session.session_id})")
```

### `get_session_messages()`

과거 세션에서 메시지를 검색합니다. 동기식이며 즉시 반환됩니다.

```python theme={null}
def get_session_messages(
    session_id: str,
    directory: str | None = None,
    limit: int | None = None,
    offset: int = 0
) -> list[SessionMessage]
```

#### 매개변수

| 매개변수 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `session_id` | `str` | 필수 | 메시지를 검색할 세션 ID |
| `directory` | `str \| None` | `None` | 검색할 프로젝트 디렉토리. 생략하면 모든 프로젝트를 검색합니다 |
| `limit` | `int \| None` | `None` | 반환할 최대 메시지 수 |
| `offset` | `int` | `0` | 시작 부분에서 건너뛸 메시지 수 |

#### 반환 타입: `SessionMessage`

| 속성 | 타입 | 설명 |
| :- | :- | :- |
| `type` | `Literal["user", "assistant"]` | 메시지 역할 |
| `uuid` | `str` | 고유 메시지 식별자 |
| `session_id` | `str` | 세션 식별자 |
| `message` | `Any` | 원본 메시지 콘텐츠 |
| `parent_tool_use_id` | `str \| None` | 서브에이전트 메시지의 경우, 생성하는 `Agent` 도구 사용 블록의 ID입니다. 메인 세션 메시지 및 이전 세션의 경우 `None` |
| `parent_agent_id` | `str \| None` | [중첩된 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#let-subagents-spawn-their-own-subagents)의 메시지의 경우, 부모 서브에이전트의 에이전트 ID입니다. 메인 세션 메시지, 최상위 서브에이전트 메시지 및 이전 세션의 경우 `None`입니다. Python Agent SDK 0.2.140 이상이 필요합니다 |

#### 예제

```python theme={null}
from claude_agent_sdk import list_sessions, get_session_messages

sessions = list_sessions(limit=1)
if sessions:
    messages = get_session_messages(sessions[0].session_id)
    for msg in messages:
        print(f"[{msg.type}] {msg.uuid}")
```

### `get_session_info()`

전체 프로젝트 디렉토리를 스캔하지 않고 ID로 단일 세션의 메타데이터를 읽습니다. 동기식이며 즉시 반환됩니다.

```python theme={null}
def get_session_info(
    session_id: str,
    directory: str | None = None,
) -> SDKSessionInfo | None
```

#### 매개변수

| 매개변수 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `session_id` | `str` | 필수 | 조회할 세션의 UUID |
| `directory` | `str \| None` | `None` | 프로젝트 디렉토리 경로. 생략하면 모든 프로젝트 디렉토리를 검색합니다 |

[`SDKSessionInfo`](#return-type-sdksessioninfo)를 반환하거나, 세션을 찾을 수 없으면 `None`을 반환합니다.

#### 예제

프로젝트 디렉토리를 스캔하지 않고 단일 세션의 메타데이터를 조회합니다. 이전 실행에서 세션 ID를 이미 가지고 있을 때 유용합니다.

```python theme={null}
from claude_agent_sdk import get_session_info

info = get_session_info("550e8400-e29b-41d4-a716-446655440000")
if info:
    print(f"{info.summary} (branch: {info.git_branch}, tag: {info.tag})")
```

### `rename_session()`

사용자 정의 제목 항목을 추가하여 세션의 이름을 바꿉니다. 반복 호출은 안전하며, 가장 최신 제목이 우선합니다. 동기식입니다.

```python theme={null}
def rename_session(
    session_id: str,
    title: str,
    directory: str | None = None,
) -> None
```

#### 매개변수

| 매개변수 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `session_id` | `str` | 필수 | 이름을 바꿀 세션의 UUID |
| `title` | `str` | 필수 | 새 제목. 공백을 제거한 후 비어 있지 않아야 합니다 |
| `directory` | `str \| None` | `None` | 프로젝트 디렉토리 경로. 생략하면 모든 프로젝트 디렉토리를 검색합니다 |

`session_id`가 유효한 UUID가 아니거나 `title`이 비어 있으면 `ValueError`를 발생시킵니다. 세션을 찾을 수 없으면 `FileNotFoundError`를 발생시킵니다.

#### 예제

가장 최신 세션의 이름을 바꿔서 나중에 찾기 쉽게 합니다. 새 제목은 이후 읽기에서 [`SDKSessionInfo.custom_title`](#return-type-sdksessioninfo)에 나타납니다.

```python theme={null}
from claude_agent_sdk import list_sessions, rename_session

sessions = list_sessions(directory="/path/to/project", limit=1)
if sessions:
    rename_session(sessions[0].session_id, "Refactor auth module")
```

### `tag_session()`

세션에 태그를 지정합니다. 태그를 지우려면 `None`을 전달합니다. 반복 호출은 안전하며, 가장 최신 태그가 우선합니다. 동기식입니다.

```python theme={null}
def tag_session(
    session_id: str,
    tag: str | None,
    directory: str | None = None,
) -> None
```

#### 매개변수

| 매개변수 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `session_id` | `str` | 필수 | 태그를 지정할 세션의 UUID |
| `tag` | `str \| None` | 필수 | 태그 문자열 또는 지우려면 `None`. 저장하기 전에 유니코드 정규화됨 |
| `directory` | `str \| None` | `None` | 프로젝트 디렉토리 경로. 생략하면 모든 프로젝트 디렉토리를 검색합니다 |

`session_id`가 유효한 UUID가 아니거나 `tag`가 정규화 후 비어 있으면 `ValueError`를 발생시킵니다. 세션을 찾을 수 없으면 `FileNotFoundError`를 발생시킵니다.

#### 예제

세션에 태그를 지정한 다음, 나중에 읽을 때 해당 태그로 필터링합니다. 기존 태그를 지우려면 `None`을 전달합니다.

```python theme={null}
from claude_agent_sdk import list_sessions, tag_session

# Tag the most recent session
sessions = list_sessions(directory="/path/to/project", limit=1)
if sessions:
    tag_session(sessions[0].session_id, "needs-review")

# Later: find all sessions with that tag
for session in list_sessions(directory="/path/to/project"):
    if session.tag == "needs-review":
        print(session.summary)
```

### `fork_session()`

세션의 트랜스크립트를 새 세션으로 복사하여, 원본은 그대로 유지하면서 대화를 다른 방향으로 이어갈 수 있습니다. 대화의 이전 지점에서 분기하려면 `up_to_message_id`를 전달합니다. 동기식입니다.

```python theme={null}
def fork_session(
    session_id: str,
    directory: str | None = None,
    up_to_message_id: str | None = None,
    title: str | None = None,
) -> ForkSessionResult
```

#### 매개변수

| 매개변수 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `session_id` | `str` | 필수 | 분기할 세션의 UUID |
| `directory` | `str \| None` | `None` | 프로젝트 디렉터리 경로. 생략하면 모든 프로젝트 디렉터리를 검색합니다 |
| `up_to_message_id` | `str \| None` | `None` | 이 UUID를 가진 메시지까지(해당 메시지 포함) 트랜스크립트를 복사합니다. 예를 들어 [`get_session_messages()`](#get_session_messages)의 `uuid`를 사용할 수 있습니다. 생략하면 전체 트랜스크립트를 복사합니다 |
| `title` | `str \| None` | `None` | 분기된 세션의 제목. 생략하면 SDK가 원본 세션에서 제목을 도출하고 뒤에 `(fork)`를 붙입니다 |

`session_id`가 새 세션의 UUID인 `ForkSessionResult`를 반환합니다. 분기된 세션을 계속하려면 이 값을 [`resume`](#claudeagentoptions)으로 전달합니다. 분기된 세션에는 원본 세션의 [파일 체크포인트](https://code.claude.com/docs/ko/agent-sdk/file-checkpointing.md)가 포함되지 않으므로, 분기 이전에 캡처된 체크포인트로 되돌릴 수 없습니다.

`fork_session()`은 다음 경우에 예외를 발생시킵니다:

* `ValueError`: `session_id` 또는 `up_to_message_id`가 유효한 UUID가 아닌 경우
* `ValueError`: 세션에 메시지가 없거나, `up_to_message_id`가 트랜스크립트의 어떤 메시지와도 일치하지 않는 경우
* `FileNotFoundError`: 세션을 찾을 수 없는 경우

#### 예제

가장 최신 세션을 새 제목으로 분기한 다음, 분기된 세션을 재개합니다. 원본 세션은 자체 기록을 유지합니다.

```python theme={null}
from claude_agent_sdk import fork_session, list_sessions

sessions = list_sessions(directory="/path/to/project", limit=1)
if sessions:
    forked = fork_session(sessions[0].session_id, title="Try the OAuth approach")
    print(forked.session_id)  # pass as ClaudeAgentOptions(resume=...) to continue the fork
```

## 클래스

### `ClaudeSDKClient`

**여러 교환에 걸쳐 대화 세션을 유지합니다.** 이것은 TypeScript SDK의 `query()` 함수가 내부적으로 작동하는 방식의 Python 동등물입니다 - 대화를 계속할 수 있는 클라이언트 객체를 생성합니다. [`query()`와의 비교](#choosing-between-query-and-claudesdkclient)를 참조하십시오.

```python theme={null}
class ClaudeSDKClient:
    def __init__(self, options: ClaudeAgentOptions | None = None, transport: Transport | None = None)
    async def connect(self, prompt: str | AsyncIterable[dict] | None = None) -> None
    async def query(self, prompt: str | AsyncIterable[dict], session_id: str = "default") -> None
    async def receive_messages(self) -> AsyncIterator[Message]
    async def receive_response(self) -> AsyncIterator[Message]
    async def interrupt(self) -> None
    async def set_permission_mode(self, mode: PermissionMode) -> None
    async def set_model(self, model: str | None = None) -> None
    async def rewind_files(self, user_message_id: str) -> None
    async def get_mcp_status(self) -> McpStatusResponse
    async def get_context_usage(self) -> ContextUsageResponse
    async def reconnect_mcp_server(self, server_name: str) -> None
    async def toggle_mcp_server(self, server_name: str, enabled: bool) -> None
    async def stop_task(self, task_id: str) -> None
    async def get_server_info(self) -> dict[str, Any] | None
    async def disconnect(self) -> None
```

#### 메서드

| 메서드 | 설명 |
| :- | :- |
| `__init__(options)` | 선택적 구성으로 클라이언트 초기화 |
| `connect(prompt)` | 선택적 초기 프롬프트 또는 메시지 스트림으로 Claude에 연결 |
| `query(prompt, session_id)` | 스트리밍 모드에서 새 요청 전송 |
| `receive_messages()` | Claude의 모든 메시지를 비동기 반복자로 수신 |
| `receive_response()` | ResultMessage를 포함하여 메시지 수신 |
| `interrupt()` | 중단 신호 전송 (스트리밍 모드에서만 작동) |
| `set_permission_mode(mode)` | 현재 세션의 권한 모드 변경 |
| `set_model(model)` | 현재 세션의 모델 변경. [Claude Code의 기본 모델](https://code.claude.com/docs/ko/model-config.md)로 재설정하려면 `None` 전달. 새 모델이 자동 모드를 지원하지 않으면 `auto` 모드의 세션은 [`default` 모드로 변경됩니다](https://code.claude.com/docs/ko/agent-sdk/permissions#auto-mode-auto) |
| `rewind_files(user_message_id)` | 지정된 사용자 메시지의 상태로 파일 복원. `enable_file_checkpointing=True` 필요. [파일 체크포인팅](https://code.claude.com/docs/ko/agent-sdk/file-checkpointing.md) 참조 |
| `get_mcp_status()` | 구성된 모든 MCP 서버의 상태 가져오기. [`McpStatusResponse`](#mcpstatusresponse) 반환 |
| `get_context_usage()` | 카테고리, 스킬 및 도구별 컨텍스트 윈도우 사용량의 분석 가져오기. 대화형 세션에서 `/context`가 표시하는 것과 동일한 데이터입니다. [`ContextUsageResponse`](#contextusageresponse)를 반환합니다. 분석을 계산하기 위해 Claude Code는 메시지 스트림에 나타나지 않는 여러 토큰 계산 API 요청을 수행합니다. [이러한 요청이 어떻게 처리되는지](#contextusageresponse) 참조 |
| `reconnect_mcp_server(server_name)` | 실패했거나 연결이 끊긴 MCP 서버에 다시 연결 시도 |
| `toggle_mcp_server(server_name, enabled)` | 세션 중간에 MCP 서버 활성화 또는 비활성화. stdio, SSE 또는 HTTP 서버를 비활성화하면 해당 도구가 제거됩니다 |
| `stop_task(task_id)` | 실행 중인 백그라운드 작업 중지. 상태 `"stopped"`인 [`TaskNotificationMessage`](#tasknotificationmessage)가 메시지 스트림에서 따릅니다 |
| `get_server_info()` | 사용 가능한 명령 및 출력 스타일을 포함한 서버의 초기화 정보 가져오기 |
| `disconnect()` | Claude에서 연결 해제 |

#### 컨텍스트 관리자 지원

클라이언트는 자동 연결 관리를 위한 비동기 컨텍스트 관리자로 사용할 수 있습니다.

```python theme={null}
import asyncio
from claude_agent_sdk import ClaudeSDKClient


async def main():
    async with ClaudeSDKClient() as client:
        await client.query("Hello Claude")
        async for message in client.receive_response():
            print(message)


asyncio.run(main())
```

> **중요:** 메시지를 반복할 때, asyncio 정리 문제를 일으킬 수 있으므로 `break`를 사용하여 조기에 종료하지 마십시오. 대신 반복이 자연스럽게 완료되도록 하거나 플래그를 사용하여 필요한 것을 찾았을 때를 추적하십시오.

#### 예제 - 대화 계속하기

```python theme={null}
import asyncio
from claude_agent_sdk import ClaudeSDKClient, AssistantMessage, TextBlock, ResultMessage


async def main():
    async with ClaudeSDKClient() as client:
        # First question
        await client.query("What's the capital of France?")

        # Process response
        async for message in client.receive_response():
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if isinstance(block, TextBlock):
                        print(f"Claude: {block.text}")

        # Follow-up question - the session retains the previous context
        await client.query("What's the population of that city?")

        async for message in client.receive_response():
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if isinstance(block, TextBlock):
                        print(f"Claude: {block.text}")

        # Another follow-up - still in the same conversation
        await client.query("What are some famous landmarks there?")

        async for message in client.receive_response():
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if isinstance(block, TextBlock):
                        print(f"Claude: {block.text}")


asyncio.run(main())
```

#### 예제 - ClaudeSDKClient를 사용한 스트리밍 입력

`query()`는 사용자 메시지 딕셔너리의 비동기 반복 가능 객체도 허용하므로, 전송 시간에 프롬프트를 조립하거나 이미지와 같은 콘텐츠 블록을 포함할 수 있습니다. Claude Code는 반복 가능 객체가 완료될 때까지 기다리지 않고 첫 번째 생성된 메시지가 도착하는 즉시 응답을 시작하며, `receive_response()`는 해당 응답을 종료하는 `ResultMessage`에서 중지됩니다. Claude가 답변하기 전에 읽어야 할 모든 것을 이 생성기처럼 하나의 메시지에 넣고, 각 `query()` 호출을 자신의 `receive_response()` 루프와 쌍을 이루십시오.

```python theme={null}
import asyncio
from claude_agent_sdk import ClaudeSDKClient


async def message_stream():
    """Assemble the prompt at send time and yield it as one user message."""
    readings = {"Temperature": "25°C", "Humidity": "60%"}
    data = ", ".join(f"{name}: {value}" for name, value in readings.items())
    yield {
        "type": "user",
        "message": {
            "role": "user",
            "content": f"Analyze the following sensor data and describe any patterns you see: {data}",
        },
    }


async def main():
    async with ClaudeSDKClient() as client:
        # Stream input to Claude
        await client.query(message_stream())

        # Process response
        async for message in client.receive_response():
            print(message)

        # Follow-up in same session
        await client.query("Should we be concerned about these readings?")

        async for message in client.receive_response():
            print(message)


asyncio.run(main())
```

#### 예제 - 중단 사용

```python theme={null}
import asyncio
from claude_agent_sdk import ClaudeSDKClient, ClaudeAgentOptions, ResultMessage


async def interruptible_task():
    options = ClaudeAgentOptions(allowed_tools=["Bash"], permission_mode="acceptEdits")

    async with ClaudeSDKClient(options=options) as client:
        # Start a long-running task
        await client.query("Count from 1 to 100 slowly, using the bash sleep command")

        # Let it run for a bit
        await asyncio.sleep(2)

        # Interrupt the task
        await client.interrupt()
        print("Task interrupted!")

        # Drain the interrupted task's messages (including its ResultMessage)
        async for message in client.receive_response():
            if isinstance(message, ResultMessage):
                print(f"Interrupted task: terminal_reason={message.terminal_reason!r}")
                # terminal_reason is "aborted_streaming" or "aborted_tools"
                # for interrupted turns

        # Send a new command
        await client.query("Just say hello instead")

        # Now receive the new response
        async for message in client.receive_response():
            if isinstance(message, ResultMessage) and message.subtype == "success":
                print(f"New result: {message.result}")


asyncio.run(interruptible_task())
```

> [!NOTE]
>
> **중단 후 버퍼 동작:** `interrupt()`는 중지 신호를 보내지만 메시지 버퍼를 지우지 않습니다. 중단된 작업에서 이미 생성된 메시지(해당 `ResultMessage` 포함)는 스트림에 남아 있습니다. 새 쿼리의 응답을 읽기 전에 `receive_response()`로 이들을 드레인해야 합니다. `interrupt()` 직후에 새 쿼리를 보내고 `receive_response()`를 한 번만 호출하면, 새 쿼리의 응답이 아닌 중단된 작업의 메시지를 받게 됩니다.

#### 예제 - 고급 권한 제어

```python theme={null}
import asyncio
from claude_agent_sdk import ClaudeSDKClient, ClaudeAgentOptions
from claude_agent_sdk.types import (
    PermissionResultAllow,
    PermissionResultDeny,
    ToolPermissionContext,
)


async def custom_permission_handler(
    tool_name: str, input_data: dict, context: ToolPermissionContext
) -> PermissionResultAllow | PermissionResultDeny:
    """Custom logic for tool permissions."""

    # Block writes to system directories
    if tool_name == "Write" and input_data.get("file_path", "").startswith("/system/"):
        return PermissionResultDeny(
            message="System directory write not allowed", interrupt=True
        )

    # Redirect sensitive file operations
    if tool_name in ["Write", "Edit"] and "config" in input_data.get("file_path", ""):
        safe_path = f"./sandbox/{input_data['file_path']}"
        return PermissionResultAllow(
            updated_input={**input_data, "file_path": safe_path}
        )

    # Allow everything else
    return PermissionResultAllow(updated_input=input_data)


async def main():
    # 게이트된 도구를 allowed_tools에도 나열하지 마십시오: allow 규칙은 can_use_tool이 실행되기 전에 호출을 승인합니다
    options = ClaudeAgentOptions(can_use_tool=custom_permission_handler)

    async with ClaudeSDKClient(options=options) as client:
        await client.query("Update the system config file")

        async for message in client.receive_response():
            # Will use sandbox path instead
            print(message)


asyncio.run(main())
```

## 타입

> [!NOTE]
>
> **`@dataclass` vs `TypedDict`:** 이 SDK는 두 가지 종류의 타입을 사용합니다. `@dataclass`로 장식된 클래스 (`ResultMessage`, `AgentDefinition`, `TextBlock`)는 런타임에 객체 인스턴스이며 속성 접근을 지원합니다: `msg.result`. `TypedDict`로 정의된 클래스 (`ThinkingConfigEnabled`, `McpStdioServerConfig`, `SyncHookJSONOutput`)는 **런타임에 일반 딕셔너리**이며 키 접근이 필요합니다: `config["budget_tokens"]`, `config.budget_tokens`가 아닙니다. `ClassName(field=value)` 호출 구문은 둘 다에서 작동하지만, dataclass만 속성이 있는 객체를 생성합니다.

### `SdkMcpTool`

`@tool` 데코레이터로 생성된 SDK MCP 도구의 정의입니다.

```python theme={null}
@dataclass
class SdkMcpTool(Generic[T]):
    name: str
    description: str
    input_schema: type[T] | dict[str, Any]
    handler: Callable[[T], Awaitable[dict[str, Any]]]
    annotations: ToolAnnotations | None = None
```

| 속성 | 타입 | 설명 |
| :- | :- | :- |
| `name` | `str` | 도구의 고유 식별자 |
| `description` | `str` | 인간이 읽을 수 있는 설명 |
| `input_schema` | `type[T] \| dict[str, Any]` | 입력 검증을 위한 스키마 |
| `handler` | `Callable[[T], Awaitable[dict[str, Any]]]` | 도구 실행을 처리하는 비동기 함수 |
| `annotations` | [`ToolAnnotations`](#toolannotations)` \| None` | 선택적 도구 주석 (예: `readOnlyHint`, `destructiveHint`, `openWorldHint`, `maxResultSizeChars`) |

### `Transport`

사용자 정의 전송 구현을 위한 추상 기본 클래스입니다. 이를 사용하여 사용자 정의 채널 (예: 로컬 서브프로세스 대신 원격 연결)을 통해 Claude 프로세스와 통신합니다.

> [!WARNING]
>
> 이것은 낮은 수준의 내부 API입니다. 인터페이스는 향후 릴리스에서 변경될 수 있습니다. 사용자 정의 구현은 인터페이스 변경에 맞게 업데이트되어야 합니다.

```python theme={null}
from abc import ABC, abstractmethod
from collections.abc import AsyncIterator
from typing import Any


class Transport(ABC):
    @abstractmethod
    async def connect(self) -> None: ...

    @abstractmethod
    async def write(self, data: str) -> None: ...

    @abstractmethod
    def read_messages(self) -> AsyncIterator[dict[str, Any]]: ...

    @abstractmethod
    async def close(self) -> None: ...

    @abstractmethod
    def is_ready(self) -> bool: ...

    @abstractmethod
    async def end_input(self) -> None: ...
```

| 메서드 | 설명 |
| :- | :- |
| `connect()` | 전송을 연결하고 통신을 준비합니다 |
| `write(data)` | 원본 데이터 (JSON + 줄바꿈)를 전송에 씁니다 |
| `read_messages()` | 구문 분석된 JSON 메시지를 생성하는 비동기 반복자 |
| `close()` | 연결을 닫고 리소스를 정리합니다 |
| `is_ready()` | 전송이 송수신할 수 있으면 `True`를 반환합니다 |
| `end_input()` | 입력 스트림을 닫습니다 (예: 서브프로세스 전송의 stdin 닫기) |

가져오기: `from claude_agent_sdk import Transport`

### `ClaudeAgentOptions`

Claude Code 쿼리를 위한 구성 dataclass입니다.

```python theme={null}
@dataclass
class ClaudeAgentOptions:
    tools: list[str] | ToolsPreset | None = None
    allowed_tools: list[str] = field(default_factory=list)
    system_prompt: str | SystemPromptPreset | SystemPromptCustom | SystemPromptFile | None = None
    mcp_servers: dict[str, McpServerConfig] | str | Path = field(default_factory=dict)
    strict_mcp_config: bool = False
    permission_mode: PermissionMode | None = None
    continue_conversation: bool = False
    resume: str | None = None
    session_id: str | None = None
    max_turns: int | None = None
    max_budget_usd: float | None = None
    disallowed_tools: list[str] = field(default_factory=list)
    model: str | None = None
    fallback_model: str | None = None
    betas: list[SdkBeta] = field(default_factory=list)
    output_format: dict[str, Any] | None = None
    permission_prompt_tool_name: str | None = None
    cwd: str | Path | None = None
    cli_path: str | Path | None = None
    settings: str | None = None
    add_dirs: list[str | Path] = field(default_factory=list)
    env: dict[str, str] = field(default_factory=dict)
    extra_args: dict[str, str | None] = field(default_factory=dict)
    max_buffer_size: int | None = None
    debug_stderr: Any = sys.stderr  # Deprecated
    stderr: Callable[[str], None] | None = None
    can_use_tool: CanUseTool | None = None
    hooks: dict[HookEvent, list[HookMatcher]] | None = None
    user: str | None = None
    include_partial_messages: bool = False
    include_hook_events: bool = False
    forward_subagent_text: bool = False
    verbatim_prompts: bool = False
    fork_session: bool = False
    resume_session_at: str | None = None
    resume_drops_turn: str | None = None
    agents: dict[str, AgentDefinition] | None = None
    setting_sources: list[SettingSource] | None = None
    skills: list[str] | Literal["all"] | None = None
    sandbox: SandboxSettings | None = None
    plugins: list[SdkPluginConfig] = field(default_factory=list)
    max_thinking_tokens: int | None = None  # Deprecated: use thinking instead
    thinking: ThinkingConfig | None = None
    effort: EffortLevel | None = None
    enable_file_checkpointing: bool = False
    session_store: SessionStore | None = None
    session_store_flush: SessionStoreFlushMode = "batched"
    load_timeout_ms: int = 60_000
    task_budget: TaskBudget | None = None
```

| 속성 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `tools` | `list[str] \| ToolsPreset \| None` | `None` | 도구 구성. Claude Code의 기본 도구를 위해 `{"type": "preset", "preset": "claude_code"}` 사용 |
| `allowed_tools` | `list[str]` | `[]` | 프롬프트 없이 자동 승인할 도구. 단, [네트워크 경로](https://code.claude.com/docs/ko/permissions.md#network-paths)에서의 읽기는 제외됩니다. 이것은 Claude를 이 도구로만 제한하지 않습니다. [작업 추적 도구](https://code.claude.com/docs/ko/agent-sdk/todo-tracking.md#model-availability) 중 하나를 여기에 지정하면 Claude Code는 해당 세션에서 작업 추적 도구도 활성화합니다. 나열되지 않은 도구는 `permission_mode` 및 `can_use_tool`로 넘어갑니다. `disallowed_tools`를 사용하여 도구를 차단합니다. [권한](https://code.claude.com/docs/ko/agent-sdk/permissions.md#allow-and-deny-rules) 참조 |
| `system_prompt` | `str \| SystemPromptPreset \| SystemPromptCustom \| SystemPromptFile \| None` | `None` | 시스템 프롬프트 구성. 사용자 정의 프롬프트의 경우 문자열을 전달하거나, Claude Code의 시스템 프롬프트를 위해 선택적 `"append"`와 함께 `{"type": "preset", "preset": "claude_code"}`를 사용하거나, 사용자 정의 프롬프트를 위해 `{"type": "custom", "prompt": "..."}` 형식으로 `"snapshot"`도 설정할 수 있거나, 디스크에서 큰 프롬프트를 로드하기 위해 `{"type": "file", "path": "..."}` 형식을 사용합니다. [`SystemPromptPreset`](#systempromptpreset), [`SystemPromptCustom`](#systempromptcustom) 및 [`SystemPromptFile`](#systempromptfile) 참조 |
| `mcp_servers` | `dict[str, McpServerConfig] \| str \| Path` | `{}` | MCP 서버 구성 또는 설정 파일 경로 |
| `strict_mcp_config` | `bool` | `False` | `True`일 때, `mcp_servers`에 전달된 서버만 사용하고 프로젝트 `.mcp.json`, 사용자 설정, 플러그인 제공 MCP 서버 및 [claude.ai 커넥터](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai)를 무시합니다. CLI `--strict-mcp-config` 플래그에 매핑됩니다 |
| `permission_mode` | `PermissionMode \| None` | `None` | 도구 사용을 위한 권한 모드 |
| `continue_conversation` | `bool` | `False` | 가장 최신 대화 계속하기 |
| `resume` | `str \| None` | `None` | 재개할 세션 ID |
| `session_id` | `str \| None` | `None` | 자동 생성된 세션 ID 대신 특정 세션 ID를 사용합니다. 유효한 UUID여야 합니다. `fork_session`도 설정되지 않으면 `continue_conversation` 또는 `resume`과 결합할 수 없습니다 |
| `max_turns` | `int \| None` | `None` | 최대 에이전트 [턴](https://code.claude.com/docs/ko/agent-sdk/agent-loop.md#turns-and-messages) |
| `max_budget_usd` | `float \| None` | `None` | 클라이언트 측 비용 추정이 이 USD 값에 도달하면 쿼리 중지. 추정치가 이 값을 넘어설 수 있으므로 [여유분을 남겨 두십시오](https://code.claude.com/docs/ko/agent-sdk/agent-loop.md#budget-headroom). 호출 자체의 지출만 계산합니다. 재개된 세션에서 복원된 총액은 계산되지 않습니다. 정확도 주의 사항 및 재설정 동작은 [비용 및 사용량 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md) 참조 |
| `disallowed_tools` | `list[str]` | `[]` | 거부할 도구. `"Bash"`와 같은 단순 이름은 Claude의 컨텍스트에서 도구를 제거합니다. `"Bash(rm *)"` 같은 범위 지정 규칙은 도구를 사용 가능하게 유지하고, `bypassPermissions`를 포함한 모든 권한 모드에서 [작성된 대로의](https://code.claude.com/docs/ko/permissions.md#bash-rule-limits) 명령과 일치하는 호출을 거부합니다. [권한](https://code.claude.com/docs/ko/agent-sdk/permissions.md#allow-and-deny-rules) 참조 |
| `enable_file_checkpointing` | `bool` | `False` | 되감기를 위한 파일 변경 추적 활성화. [파일 체크포인트](https://code.claude.com/docs/ko/agent-sdk/file-checkpointing.md) 참조 |
| `model` | `str \| None` | `None` | Claude 모델 별칭 또는 전체 모델 이름. [허용되는 값 및 공급자별 ID](https://code.claude.com/docs/ko/model-config.md#available-models) 참조 |
| `fallback_model` | `str \| None` | `None` | 기본 모델이 실패할 경우 사용할 폴백 모델. 쉼표로 구분된 목록을 허용합니다. 지침은 [모델 선택](https://code.claude.com/docs/ko/agent-sdk/configuration.md#choose-a-model) 참조 |
| `betas` | `list[SdkBeta]` | `[]` | 활성화할 베타 기능. 사용 가능한 옵션은 [`SdkBeta`](#sdkbeta) 참조 |
| `output_format` | `dict[str, Any] \| None` | `None` | 구조화된 응답을 위한 출력 형식 (예: `{"type": "json_schema", "schema": {...}}`). 자세한 내용은 [구조화된 출력](https://code.claude.com/docs/ko/agent-sdk/structured-outputs.md) 참조 |
| `permission_prompt_tool_name` | `str \| None` | `None` | 권한 프롬프트를 위한 MCP 도구 이름 |
| `cwd` | `str \| Path \| None` | `None` | 현재 작업 디렉터리 |
| `cli_path` | `str \| Path \| None` | `None` | Claude Code CLI 실행 파일의 사용자 정의 경로 |
| `settings` | `str \| None` | `None` | 설정 파일 경로 또는 인라인 JSON 문자열 |
| `add_dirs` | `list[str \| Path]` | `[]` | Claude가 접근할 수 있는 추가 디렉터리. SDK는 각 항목을 Claude Code에 `--add-dir`로 전달하므로, `project` 설정 소스를 사용하면 Claude Code도 [디렉터리의 스킬, 명령 및 서브에이전트를 로드합니다](https://code.claude.com/docs/ko/permissions.md#additional-directories-grant-file-access-not-configuration) |
| `env` | `dict[str, str]` | `{}` | 상속된 프로세스 환경 위에 병합된 환경 변수. 기본 CLI가 읽는 변수는 [환경 변수](https://code.claude.com/docs/ko/env-vars.md) 참조. 타임아웃 관련 변수는 [느리거나 정지된 API 응답 처리](#handle-slow-or-stalled-api-responses) 참조. `CLAUDE_AGENT_SDK_CLIENT_APP`을 설정하여 User-Agent 헤더에서 앱을 식별합니다 |
| `extra_args` | `dict[str, str \| None]` | `{}` | CLI에 직접 전달할 추가 CLI 인수 |
| `max_buffer_size` | `int \| None` | `None` | CLI stdout 버퍼링 시 최대 바이트 |
| `debug_stderr` | `Any` | `sys.stderr` | *Deprecated* - SDK는 이 값을 무시합니다. CLI stderr 출력을 위해 `stderr` 콜백 사용 |
| `stderr` | `Callable[[str], None] \| None` | `None` | CLI의 stderr 출력을 위한 콜백 함수 |
| `can_use_tool` | [`CanUseTool`](#canusetool) ` \| None` | `None` | 도구 권한 콜백. [권한 흐름](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)이 프롬프트로 넘어갈 때만 호출됩니다. `allowed_tools`, 허용 규칙 또는 `permission_mode`로 자동 승인된 호출에 대해서는 호출되지 않습니다. 허용 규칙은 [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)을 사전 승인하지 않습니다. [`CanUseTool`](#canusetool)에서 자세한 내용 참조 |
| `hooks` | `dict[HookEvent, list[HookMatcher]] \| None` | `None` | 이벤트 가로채기를 위한 훅 구성 |
| `user` | `str \| None` | `None` | POSIX 플랫폼에서 Claude Code 서브프로세스가 실행되는 OS 사용자 계정. Claude Code는 `HOME`을 포함한 부모 프로세스의 환경을 유지하고 `cwd`에서 실행됩니다 |
| `include_partial_messages` | `bool` | `False` | 부분 메시지 스트리밍 이벤트 포함. 활성화되면 [`StreamEvent`](#streamevent) 메시지가 생성됩니다 |
| `include_hook_events` | `bool` | `False` | 메시지 스트림에 훅 라이프사이클 이벤트를 `HookEventMessage` 객체로 포함 |
| `forward_subagent_text` | `bool` | `False` | 메시지 스트림에서 서브에이전트 텍스트 및 thinking 블록을 전달합니다. 이 옵션이 없으면 Claude Code는 [포그라운드](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)에서 실행되는 서브에이전트의 텍스트 및 thinking 블록을 생략합니다. 중첩된 서브에이전트, `context: fork`가 있는 스킬, 그리고 각각에 필요한 Claude Code 버전은 [서브에이전트 메시지 따라가기](https://code.claude.com/docs/ko/headless.md#follow-subagent-messages)를 참조하십시오. Python Agent SDK 0.2.140 이상 필요 |
| `verbatim_prompts` | `bool` | `False` | 모든 프롬프트를 작성된 대로 전달합니다. SDK는 각 사용자 메시지를 `client_composed`가 `True`로 설정되어 전송합니다. Claude Code가 이 메시지에서 건너뛰는 것은 [`client_composed`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkusermessage)를 참조하십시오. 프롬프트 텍스트에 최종 사용자가 입력하지 않은 콘텐츠가 포함될 때 이 옵션을 사용합니다. 턴별 제어를 위해 이를 끄고 대신 스트리밍된 메시지에서 개별적으로 `"client_composed": True`를 설정합니다. 옵션이 켜져 있는 동안 SDK는 설정한 모든 `client_composed` 값을 덮어씁니다. Python Agent SDK 0.2.158 이상 및 Claude Code v2.1.248 이상 필요. 이 SDK 버전과 함께 번들된 CLI는 Claude Code 요구사항을 충족합니다 |
| `fork_session` | `bool` | `False` | `resume`으로 재개할 때, 원본 세션을 계속하는 대신 새 세션 ID로 포크합니다 |
| `resume_session_at` | `str \| None` | `None` | 재개할 때, 이 UUID를 가진 메시지까지 포함하여 대화만 로드합니다. `resume`과 함께 사용하고, 보통 `fork_session`과 함께 사용하여 이전 지점에서 분기합니다. Python Agent SDK 0.2.137 이상 필요 |
| `resume_drops_turn` | `str \| None` | `None` | UUID는 `resume_session_at` 잘림이 버리는 턴의 사용자 프롬프트입니다. 설정하면 CLI는 버려진 범위가 해당 턴에 귀속되지 않는 항목을 보유하는 경우 재개를 거부합니다. Python Agent SDK 0.2.137 이상 및 Claude Code v2.1.223 이상 필요. 이 SDK 버전과 함께 번들된 CLI는 Claude Code 요구사항을 충족합니다 |
| `agents` | `dict[str, AgentDefinition] \| None` | `None` | 프로그래밍 방식으로 정의된 서브에이전트 |
| `plugins` | `list[SdkPluginConfig]` | `[]` | 로컬 경로에서 사용자 정의 플러그인 로드. 자세한 내용은 [플러그인](https://code.claude.com/docs/ko/agent-sdk/plugins.md) 참조 |
| `sandbox` | [`SandboxSettings`](#sandboxsettings) ` \| None` | `None` | 프로그래밍 방식으로 샌드박스 동작 구성. 자세한 내용은 [샌드박스 설정](#sandboxsettings) 참조 |
| `setting_sources` | `list[SettingSource] \| None` | `None` (CLI 기본값: 모든 소스) | 로드할 파일 시스템 설정을 제어합니다. 사용자, 프로젝트 및 로컬 설정을 비활성화하려면 `[]`를 전달합니다. `skills` 설정 및 이 필드 미설정 시 사용자 및 프로젝트 소스만 로드됩니다. 로컬 설정을 유지하려면 `setting_sources`를 명시적으로 설정합니다. 엔드포인트 관리 정책은 어쨌든 로드됩니다. 서버 관리 설정은 [적격 구성](https://code.claude.com/docs/ko/server-managed-settings.md#platform-availability)에서 조직 자격 증명으로 세션이 인증될 때 가져옵니다. 이 옵션과 관계없이 읽히는 입력은 [settingSources가 제어하지 않는 항목](https://code.claude.com/docs/ko/agent-sdk/claude-code-features.md#what-settingsources-does-not-control) 참조 |
| `skills` | `list[str] \| Literal["all"] \| None` | `None` | 세션에서 사용 가능한 스킬. 모든 발견된 스킬을 활성화하려면 `"all"`을 전달하거나, 스킬 이름 목록을 전달합니다. 정확한 이름만 전달합니다. SDK는 Claude Code 프로세스를 시작하기 전에 형식이 잘못되거나 와일드카드 형식인 이름을 `ValueError`로 거부합니다. 이 검사는 Python Agent SDK 0.2.129 이상이 필요합니다. 설정하면 SDK는 `allowed_tools`에 Skill 도구를 자동으로 추가합니다. `tools`도 전달하는 경우 해당 목록에 `"Skill"`을 포함합니다. [스킬](https://code.claude.com/docs/ko/agent-sdk/skills.md) 참조 |
| `max_thinking_tokens` | `int \| None` | `None` | *Deprecated* - thinking 블록의 최대 토큰. 대신 `thinking` 사용 |
| `thinking` | [`ThinkingConfig`](#thinkingconfig) ` \| None` | `None` | 확장 사고 동작을 제어합니다. `max_thinking_tokens`보다 우선합니다 |
| `effort` | [`EffortLevel`](#effortlevel) ` \| None` | `None` | 사고 깊이를 위한 effort 수준. [effort 수준 조정](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level) 참조 |
| `session_store` | [`SessionStore`](https://code.claude.com/docs/ko/agent-sdk/session-storage#the-sessionstore-interface) ` \| None` | `None` | 세션 트랜스크립트를 외부 백엔드로 미러링하여 다른 호스트가 이를 재개할 수 있도록 합니다. [외부 저장소에 세션 유지](https://code.claude.com/docs/ko/agent-sdk/session-storage.md) 참조 |
| `session_store_flush` | `Literal["batched", "eager"]` | `"batched"` | `session_store`에 미러링된 트랜스크립트 항목을 플러시할 시기. `"batched"`는 턴당 한 번 또는 버퍼가 가득 찰 때 플러시합니다. `"eager"`는 모든 프레임 후에 백그라운드 플러시를 트리거합니다. `session_store`가 `None`일 때 무시됩니다 |
| `load_timeout_ms` | `int` | `60000` | 재개 구체화 중 `session_store.load()` 및 `list_subkeys()`에 대한 호출당 타임아웃 (밀리초) |
| `task_budget` | `TaskBudget \| None` | `None` | API 측 토큰 예산. `task-budgets-2026-03-13` 베타 헤더와 함께 `output_config.task_budget`으로 전송됩니다. `{"total": <int>}`를 전달합니다. |

#### 느리거나 정지된 API 응답 처리

CLI 서브프로세스는 API 타임아웃 및 정지 감지를 제어하는 여러 환경 변수를 읽습니다. `ClaudeAgentOptions.env`를 통해 전달합니다:

```python theme={null}
from claude_agent_sdk import ClaudeAgentOptions

options = ClaudeAgentOptions(
    env={
        "API_TIMEOUT_MS": "120000",
        "CLAUDE_CODE_MAX_RETRIES": "2",
        "CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS": "120000",
    },
)
```

* [`API_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars): 각 요청 시도가 응답 헤더를 기다릴 수 있는 시간 (밀리초). 헤더가 도착한 후 스트리밍 응답이 실행되는 시간은 제한하지 않습니다. 기본값 `600000`. 주 루프 및 모든 서브에이전트에 적용됩니다.
* `CLAUDE_CODE_MAX_RETRIES`: 최대 API 재시도. 기본값 `10`, 최대 `15`로 제한됨. 각 재시도는 자체 `API_TIMEOUT_MS` 윈도우를 가집니다.

  더 긴 중단을 기다려야 하는 무인 실행의 경우, [`CLAUDE_CODE_RETRY_WATCHDOG=1`](https://code.claude.com/docs/ko/errors#tune-retry-behavior)을 설정합니다. 이 설정은 일시적 용량 오류를 무한정 재시도하며, Claude Code v2.1.199 이상에서는 다른 일시적 오류의 기본값을 `300`으로 올리고 이 변수의 상한을 제거합니다.
* `CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS`: 서브에이전트의 정지 감시견. 스트림 감시견이 켜져 있는 동안 기본값은 `CLAUDE_STREAM_IDLE_TIMEOUT_MS` 더하기 5분이며, 이는 해당 변수를 올리지 않으면 `600000`입니다. 스트림 감시견이 꺼져 있으면 기본값은 `600000`입니다. v2.1.257 이전에는 기본값이 항상 `600000`이었습니다.

  타이머는 각 스트림 이벤트에서 재설정됩니다. 정지 시 Claude Code는 서브에이전트를 중단하고 정지를 부모에게 보고합니다. 백그라운드 서브에이전트의 경우 작업을 실패로 표시하고 부분 결과를 첨부합니다.
* `CLAUDE_ENABLE_STREAM_WATCHDOG` 및 `CLAUDE_STREAM_IDLE_TIMEOUT_MS`: 헤더가 도착했지만 응답 본문이 스트리밍을 중지할 때 요청을 중단하는 스트림 감시견. 감시견은 모든 공급자에 대해 기본적으로 켜져 있습니다. `CLAUDE_ENABLE_STREAM_WATCHDOG=0`으로 설정하여 비활성화합니다. `CLAUDE_STREAM_IDLE_TIMEOUT_MS`는 기본값 `300000`이고 해당 최소값으로 제한됩니다. 중단 후 [자동 재시도](https://code.claude.com/docs/ko/errors.md#automatic-retries)는 응답이 얼마나 진행되었는지에 따라 Claude Code가 수행하는 작업을 다룹니다.

  감시견이 `ANTHROPIC_BASE_URL` 뒤의 게이트웨이가 keep-alive ping으로 열어 두는 응답을 기다리는 동안, `include_partial_messages`를 설정한 호스트는 계속 `ping` [`StreamEvent`](#streamevent) 메시지를 수신합니다. 이 프레임을 침묵으로 인해 세션을 시간 초과시키는 대신 생존 신호로 읽습니다. v2.1.257 이전에는 마지막 실제 스트림 이벤트 후 5분 후에 프레임이 중지되었습니다.

### `OutputFormat`

구조화된 출력 검증을 위한 구성입니다. 이를 `ClaudeAgentOptions`의 `output_format` 필드에 `dict`로 전달합니다:

```python theme={null}
# output_format에 대한 예상 dict 형태
{
    "type": "json_schema",
    "schema": {...},  # Your JSON Schema definition
}
```

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `type` | 예 | JSON Schema 검증을 위해 `"json_schema"`이어야 합니다 |
| `schema` | 예 | 출력 검증을 위한 JSON Schema 정의 |

### `SystemPromptPreset`

선택적 추가 사항과 함께 Claude Code의 프리셋 시스템 프롬프트를 사용하기 위한 구성입니다.

```python theme={null}
class SystemPromptPreset(TypedDict):
    type: Literal["preset"]
    preset: Literal["claude_code"]
    append: NotRequired[str]
    exclude_dynamic_sections: NotRequired[bool]
    snapshot: NotRequired[bool]
```

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `type` | 예 | 프리셋 시스템 프롬프트를 사용하려면 `"preset"`이어야 합니다 |
| `preset` | 예 | Claude Code의 시스템 프롬프트를 사용하려면 `"claude_code"`이어야 합니다 |
| `append` | 아니오 | 프리셋 시스템 프롬프트에 추가할 추가 지침 |
| `exclude_dynamic_sections` | 아니오 | 사용자별 컨텍스트 (예: 자동 메모리 위치)를 시스템 프롬프트에서 첫 사용자 메시지로 이동합니다. 사용자 및 머신 간 프롬프트 캐시 재사용을 개선합니다. [시스템 프롬프트 수정](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#improve-prompt-caching-across-users-and-machines) 참조 |
| `snapshot` | 아니오 | `False`로 설정하여 [세션이 첫 요청에서 기록한 프롬프트를 재사용](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#change-the-prompt-of-an-existing-session)하는 대신 모든 요청에서 시스템 프롬프트를 다시 빌드합니다. `claude-agent-sdk` v0.2.153 이상 필요 |

### `SystemPromptCustom`

`system_prompt`로 문자열을 전달하는 것과 동등한 객체 형식의 사용자 정의 시스템 프롬프트이며, `snapshot`도 설정할 수 있습니다. `claude-agent-sdk` v0.2.153 이상이 필요합니다.

```python theme={null}
class SystemPromptCustom(TypedDict):
    type: Literal["custom"]
    prompt: str
    snapshot: NotRequired[bool]
```

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `type` | 예 | `"custom"`이어야 합니다 |
| `prompt` | 예 | 시스템 프롬프트 텍스트. CLI에 명령줄 인수로 전달되므로, [명령줄 길이 제한](#systempromptfile)이 적용됩니다 |
| `snapshot` | 아니오 | [`SystemPromptPreset.snapshot`](#systempromptpreset)과 동일하며, `prompt`에 적용됩니다 |

### `SystemPromptFile`

사용자 정의 시스템 프롬프트를 문자열로 전달하는 대신 파일에서 로드하기 위한 구성입니다. SDK는 이를 CLI [`--system-prompt-file`](https://code.claude.com/docs/ko/cli-reference#system-prompt-flags) 플래그에 매핑합니다. 프롬프트가 큰 경우 파일 형식을 사용합니다: SDK는 문자열 `system_prompt`를 CLI 서브프로세스 argv에 전달하며, 이는 SDK가 API 요청을 보내기 전에 OS 명령줄 길이 제한의 대상입니다. Linux에서 대략 128 KB보다 긴 단일 인수는 `Argument list too long` 오류로 프로세스 생성에 실패합니다. Windows에서는 전체 명령줄이 대략 32 KB로 제한되므로 문자열 형식은 더 낮은 임계값에서 실패합니다.

```python theme={null}
class SystemPromptFile(TypedDict):
    type: Literal["file"]
    path: str
```

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `type` | 예 | 디스크에서 프롬프트를 로드하려면 `"file"`이어야 합니다 |
| `path` | 예 | 시스템 프롬프트를 포함하는 파일의 경로 |

### `SettingSource`

SDK가 설정을 로드하는 파일 시스템 기반 구성 소스를 제어합니다.

```python theme={null}
SettingSource = Literal["user", "project", "local"]
```

| 값 | 설명 | 위치 |
| :- | :- | :- |
| `"user"` | 전역 사용자 설정 | `~/.claude/settings.json` |
| `"project"` | 공유 프로젝트 설정 (버전 제어됨) | `.claude/settings.json` |
| `"local"` | 로컬 프로젝트 설정. Claude Code가 이 파일에 설정을 저장할 때 gitignore 처리됨 | `.claude/settings.local.json` |

#### 기본 동작

`setting_sources`가 생략되거나 `None`이고 `skills`가 설정되지 않은 경우, `query()`는 Claude Code CLI와 동일한 파일 시스템 설정을 로드합니다: 사용자, 프로젝트 및 로컬. `skills` 설정 시 [`setting_sources`](#claudeagentoptions) 행은 현재 기본값을 설명합니다. 엔드포인트 관리 정책은 모든 경우에 로드됩니다. 서버 관리 설정은 [적격 구성](https://code.claude.com/docs/ko/server-managed-settings.md#platform-availability)에서 조직 자격 증명으로 세션이 인증될 때 가져옵니다. 자세한 내용은 [settingSources가 제어하지 않는 항목](https://code.claude.com/docs/ko/agent-sdk/claude-code-features.md#what-settingsources-does-not-control)을 참조하십시오.

#### setting\_sources를 사용하는 이유

**파일 시스템 설정 비활성화:**

```python theme={null}
# 디스크에서 사용자, 프로젝트 또는 로컬 설정을 로드하지 않습니다
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions


async def main():
    async for message in query(
        prompt="Analyze this code",
        options=ClaudeAgentOptions(
            setting_sources=[]
        ),
    ):
        print(message)


asyncio.run(main())
```

> [!NOTE]
>
> Python SDK 0.1.59 이하에서는 빈 목록이 옵션을 생략하는 것과 동일하게 처리되었으므로 `setting_sources=[]`는 파일 시스템 설정을 비활성화하지 않았습니다. 빈 목록이 적용되어야 하는 경우 최신 릴리스로 업그레이드하십시오. TypeScript SDK는 영향을 받지 않습니다.

**특정 설정 소스만 로드:**

```python theme={null}
# 프로젝트 설정만 로드, 사용자 및 로컬 무시
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions


async def main():
    async for message in query(
        prompt="Run CI checks",
        options=ClaudeAgentOptions(
            setting_sources=["project"]  # Only .claude/settings.json
        ),
    ):
        print(message)


asyncio.run(main())
```

**SDK 전용 애플리케이션:**

```python theme={null}
# 모든 것을 프로그래밍 방식으로 정의합니다.
# 파일 시스템 설정 소스를 거부하려면 []를 전달합니다.
import asyncio
from claude_agent_sdk import AgentDefinition, ClaudeAgentOptions, query


async def main():
    async for message in query(
        prompt="Review this PR",
        options=ClaudeAgentOptions(
            setting_sources=[],
            agents={
                "code-reviewer": AgentDefinition(
                    description="Reviews code changes",
                    prompt="You are a code reviewer. Report issues in the diff.",
                ),
            },
            allowed_tools=["Read", "Grep", "Glob"],
        ),
    ):
        print(message)


asyncio.run(main())
```

CLAUDE.md 프로젝트 지침을 로드하려면 `setting_sources`에 `"project"`를 포함합니다. [시스템 프롬프트 수정](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md#claude-md-files-for-project-level-instructions)에서 CLAUDE.md 로딩이 시스템 프롬프트 옵션과 상호 작용하는 방식을 참조하십시오.

#### 설정 우선순위

여러 소스가 로드될 때, 설정은 이 우선순위로 병합됩니다 (높음에서 낮음):

1. 로컬 설정 (`.claude/settings.local.json`)
2. 프로젝트 설정 (`.claude/settings.json`)
3. 사용자 설정 (`~/.claude/settings.json`)

`agents`, `allowed_tools` 및 `settings`와 같은 프로그래밍 방식의 옵션은 사용자, 프로젝트 및 로컬 파일 시스템 설정을 재정의합니다. 관리형 정책 설정은 프로그래밍 방식의 옵션보다 우선합니다.

### `AgentDefinition`

프로그래밍 방식으로 정의된 서브에이전트의 구성입니다.

```python theme={null}
@dataclass
class AgentDefinition:
    description: str
    prompt: str
    tools: list[str] | None = None
    disallowedTools: list[str] | None = None
    model: str | None = None
    skills: list[str] | None = None
    memory: Literal["user", "project", "local"] | None = None
    mcpServers: list[str | dict[str, Any]] | None = None
    initialPrompt: str | None = None
    maxTurns: int | None = None
    background: bool | None = None
    effort: EffortLevel | int | None = None
    permissionMode: PermissionMode | None = None
```

| 필드 | 필수 | 설명 |
| :- | :- | :- |
| `description` | 예 | 이 에이전트를 사용할 시기에 대한 자연어 설명 |
| `prompt` | 예 | 에이전트의 시스템 프롬프트 |
| `tools` | 아니오 | 허용된 도구 이름의 배열. 생략하면 [서브에이전트가 사용할 수 있는 모든 도구](https://code.claude.com/docs/ko/sub-agents.md#available-tools)를 상속합니다 |
| `disallowedTools` | 아니오 | 에이전트의 도구 세트에서 제거할 도구 이름의 배열. MCP 서버 수준 패턴도 허용됩니다: `mcp__server` 또는 `mcp__server__*`는 해당 서버의 모든 도구를 제거하고, `mcp__*`는 모든 서버의 모든 MCP 도구를 제거합니다 |
| `model` | 아니오 | 이 에이전트의 모델 재정의. `"sonnet"`, `"opus"`, `"haiku"`, `"inherit"` 같은 별칭 또는 전체 모델 ID를 허용합니다. 생략하면 Claude Code는 [서브에이전트 모델 순서](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)에서 모델을 선택합니다 |
| `skills` | 아니오 | 시작 시 에이전트의 컨텍스트에 미리 로드할 스킬 이름 목록. 나열되지 않은 스킬도 Skill 도구를 통해 계속 호출할 수 있습니다 |
| `memory` | 아니오 | 이 에이전트의 메모리 소스: `"user"`, `"project"`, 또는 `"local"` |
| `mcpServers` | 아니오 | 이 에이전트가 사용할 수 있는 MCP 서버. 각 항목은 서버 이름 또는 인라인 `{name: config}` dict입니다 |
| `initialPrompt` | 아니오 | 이 에이전트가 주 스레드 에이전트로 실행될 때 첫 사용자 턴으로 자동 제출됨 |
| `maxTurns` | 아니오 | 에이전트가 중지되기 전의 최대 에이전트 턴 수 |
| `background` | 아니오 | 호출될 때 이 에이전트를 비차단 백그라운드 작업으로 실행합니다 |
| `effort` | 아니오 | 이 에이전트의 추론 effort 수준. 명명된 수준 또는 정수를 허용합니다. [`EffortLevel`](#effortlevel) 참조 |
| `permissionMode` | 아니오 | 이 에이전트 내의 도구 실행을 위한 권한 모드. [서브에이전트 상속 규칙](https://code.claude.com/docs/ko/agent-sdk/permissions.md#available-modes)은 적용 시기를 결정합니다. [`PermissionMode`](#permissionmode) 참조 |

> [!NOTE]
>
> `AgentDefinition` 필드 이름은 `disallowedTools`, `permissionMode`, `maxTurns`와 같은 camelCase를 사용합니다. 이 이름은 TypeScript SDK와 공유되는 와이어 형식에 직접 매핑됩니다. 이는 `disallowed_tools` 및 `permission_mode`와 같은 동등한 최상위 필드에 Python snake\_case를 사용하는 `ClaudeAgentOptions`와 다릅니다. `AgentDefinition`은 dataclass이므로, snake\_case 키워드를 전달하면 구성 시 `TypeError`를 발생시킵니다.

### `PermissionMode`

도구 실행을 제어하기 위한 권한 모드입니다.

```python theme={null}
PermissionMode = Literal[
    "default",  # Standard permission behavior
    "acceptEdits",  # Auto-accept file edits
    "plan",  # Planning mode - explore without editing
    "dontAsk",  # Deny anything not pre-approved instead of prompting
    "bypassPermissions",  # Bypass permission checks; explicit ask rules still prompt (use with caution)
    "auto",  # A model classifier reviews actions such as shell commands and network requests
]
```

### `EffortLevel`

사고 깊이를 안내하기 위한 effort 수준입니다.

```python theme={null}
EffortLevel = Literal[
    "low",  # Minimal thinking, fastest responses
    "medium",  # Moderate thinking
    "high",  # Deep reasoning
    "xhigh",  # Extended reasoning; falls back to "high" on models that don't support it
    "max",  # Maximum effort
]
```

### `CanUseTool`

도구 권한 콜백 함수의 타입 별칭입니다.

```python theme={null}
CanUseTool = Callable[
    [str, dict[str, Any], ToolPermissionContext], Awaitable[PermissionResult]
]
```

콜백은 다음을 수신합니다:

* `tool_name`: 호출되는 도구의 이름
* `input_data`: 도구의 입력 매개변수
* `context`: 추가 정보가 있는 `ToolPermissionContext`

`PermissionResult` (`PermissionResultAllow` 또는 `PermissionResultDeny`)를 반환합니다.

콜백은 대화형 권한 프롬프트의 SDK 대체입니다: [권한 평가 흐름](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)이 프롬프트로 해결될 때만 호출됩니다. `allowed_tools` 항목, 설정 허용 규칙 또는 `acceptEdits` 또는 `bypassPermissions`와 같은 권한 모드로 이미 승인된 도구 호출은 이를 호출하지 않습니다. 모든 도구 호출을 제어하려면 [`PreToolUse` 훅](https://code.claude.com/docs/ko/agent-sdk/hooks)을 대신 사용합니다.

허용 규칙은 [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)을 사전 승인하지 않습니다. 이 중 어떤 작업이 콜백에 도달하는지, 그리고 `dontAsk` 및 `auto` 모드에서 어떤 일이 발생하는지는 [권한 평가 방식](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)을 참조하십시오.

### `ToolPermissionContext`

도구 권한 콜백에 전달되는 컨텍스트 정보입니다.

```python theme={null}
@dataclass
class ToolPermissionContext:
    signal: Any | None = None  # Future: abort signal support
    suggestions: list[PermissionUpdate] = field(default_factory=list)
    tool_use_id: str | None = None
    agent_id: str | None = None
    blocked_path: str | None = None
    decision_reason: str | None = None
    title: str | None = None
    display_name: str | None = None
    description: str | None = None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `signal` | `Any \| None` | 향후 중단 신호 지원을 위해 예약됨 |
| `suggestions` | `list[PermissionUpdate]` | CLI의 권한 업데이트 제안. Bash 프롬프트는 `localSettings` 대상이 있는 제안을 포함하므로, `updated_permissions`에서 반환하면 규칙을 `.claude/settings.local.json`에 쓰고 세션 간에 유지합니다. |
| `tool_use_id` | `str \| None` | 이 프롬프트가 대상으로 하는 특정 도구 호출의 식별자. `can_use_tool`에 전달될 때 항상 채워집니다 |
| `agent_id` | `str \| None` | 호출이 서브에이전트에서 발생할 때 서브에이전트 ID. 주 에이전트의 경우 `None` |
| `blocked_path` | `str \| None` | 권한 요청을 트리거한 파일 경로 (해당하는 경우). 예를 들어, Bash 명령이 허용된 디렉터리 외부의 경로에 접근하려고 할 때 |
| `decision_reason` | `str \| None` | 이 권한 요청이 트리거된 이유. PreToolUse 훅이 `"ask"`를 반환했을 때 훅의 `permissionDecisionReason`에서 전달됨 |
| `title` | `str \| None` | 전체 권한 프롬프트 문장 (예: `Claude wants to read foo.txt`). 존재할 때 기본 프롬프트 텍스트로 사용 |
| `display_name` | `str \| None` | 도구 작업의 짧은 명사구 (예: `Read file`), 버튼 레이블에 적합 |
| `description` | `str \| None` | 권한 UI를 위한 인간이 읽을 수 있는 부제목 |

### `PermissionResult`

권한 콜백 결과의 합집합 타입입니다.

```python theme={null}
PermissionResult = PermissionResultAllow | PermissionResultDeny
```

### `PermissionResultAllow`

도구 호출이 허용되어야 함을 나타내는 결과입니다.

```python theme={null}
@dataclass
class PermissionResultAllow:
    behavior: Literal["allow"] = "allow"
    updated_input: dict[str, Any] | None = None
    updated_permissions: list[PermissionUpdate] | None = None
```

| 필드 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `behavior` | `Literal["allow"]` | `"allow"` | "allow"이어야 합니다 |
| `updated_input` | `dict[str, Any] \| None` | `None` | 원본 대신 사용할 수정된 입력 |
| `updated_permissions` | `list[PermissionUpdate] \| None` | `None` | 적용할 권한 업데이트 |

`updated_permissions`에 4,096개를 초과하는 항목이 포함된 `PermissionResultAllow`를 반환하면 Claude Code는 결과를 유효하지 않은 것으로 처리하고 도구 호출을 거부합니다. 각 [`PermissionUpdate`](#permissionupdate)는 하나의 항목으로 계산되며, 해당 `rules` 또는 `directories` 목록의 각 항목도 마찬가지입니다. 거부 메시지는 `updatedPermissions may hold at most 4096 updates, rules and directories in all.`로 끝납니다. 거부를 피하려면 4,096개 이하의 항목을 반환하십시오.

### `PermissionResultDeny`

도구 호출이 거부되어야 함을 나타내는 결과입니다.

```python theme={null}
@dataclass
class PermissionResultDeny:
    behavior: Literal["deny"] = "deny"
    message: str = ""
    interrupt: bool = False
```

| 필드 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `behavior` | `Literal["deny"]` | `"deny"` | "deny"이어야 합니다 |
| `message` | `str` | `""` | 도구가 거부된 이유를 설명하는 메시지 |
| `interrupt` | `bool` | `False` | 현재 실행을 중단할지 여부 |

### `PermissionUpdate`

프로그래밍 방식으로 권한을 업데이트하기 위한 구성입니다.

```python theme={null}
@dataclass
class PermissionUpdate:
    type: Literal[
        "addRules",
        "replaceRules",
        "removeRules",
        "setMode",
        "addDirectories",
        "removeDirectories",
    ]
    rules: list[PermissionRuleValue] | None = None
    behavior: Literal["allow", "deny", "ask"] | None = None
    mode: PermissionMode | None = None
    directories: list[str] | None = None
    destination: (
        Literal["userSettings", "projectSettings", "localSettings", "session"] | None
    ) = None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `type` | `Literal[...]` | 권한 업데이트 작업의 타입 |
| `rules` | `list[PermissionRuleValue] \| None` | 추가/교체/제거 작업을 위한 규칙 |
| `behavior` | `Literal["allow", "deny", "ask"] \| None` | 규칙 기반 작업을 위한 동작 |
| `mode` | `PermissionMode \| None` | setMode 작업을 위한 모드 |
| `directories` | `list[str] \| None` | 디렉터리 추가/제거 작업을 위한 디렉터리 |
| `destination` | `Literal[...] \| None` | 권한 업데이트를 적용할 위치 |

### `PermissionRuleValue`

권한 업데이트에서 추가, 교체 또는 제거할 규칙입니다.

```python theme={null}
@dataclass
class PermissionRuleValue:
    tool_name: str
    rule_content: str | None = None
```

### `ToolsPreset`

Claude Code의 기본 도구 세트를 사용하기 위한 프리셋 도구 구성입니다.

```python theme={null}
class ToolsPreset(TypedDict):
    type: Literal["preset"]
    preset: Literal["claude_code"]
```

### `ThinkingConfig`

확장 사고 동작을 제어합니다. 세 가지 구성의 합집합입니다:

```python theme={null}
ThinkingDisplay = Literal["summarized", "omitted"]


class ThinkingConfigAdaptive(TypedDict):
    type: Literal["adaptive"]
    display: NotRequired[ThinkingDisplay]


class ThinkingConfigEnabled(TypedDict):
    type: Literal["enabled"]
    budget_tokens: int
    display: NotRequired[ThinkingDisplay]


class ThinkingConfigDisabled(TypedDict):
    type: Literal["disabled"]


ThinkingConfig = ThinkingConfigAdaptive | ThinkingConfigEnabled | ThinkingConfigDisabled
```

| 변형 | 필드 | 설명 |
| :- | :- | :- |
| `adaptive` | `type`, `display` | Claude가 사고할 시기를 적응적으로 결정합니다 |
| `enabled` | `type`, `budget_tokens`, `display` | 특정 토큰 예산으로 사고 활성화 |
| `disabled` | `type` | 사고 비활성화 |

선택적 `display` 필드는 사고 텍스트가 `"summarized"` 또는 `"omitted"`로 반환되는지 제어합니다. Claude Opus 4.7 이상에서 API 기본값은 `"omitted"`이므로, [`ThinkingBlock`](#thinkingblock) 출력에서 사고 콘텐츠를 받으려면 `"summarized"`를 설정합니다. Claude Code는 Amazon Bedrock 및 Google Cloud의 Agent Platform과 같은 일부 공급자에는 설정한 `display` 값을 전달하지 않습니다. 이러한 공급자에서 Opus 4.7 이상은 `display`를 `"summarized"`로 설정하더라도 빈 `ThinkingBlock` 출력을 반환합니다.

이들은 `TypedDict` 클래스이므로 런타임에 일반 dict입니다. dict 리터럴로 구성하거나 클래스를 생성자처럼 호출합니다. 둘 다 `dict`를 생성합니다. `config.budget_tokens`가 아닌 `config["budget_tokens"]`로 필드에 접근합니다:

```python theme={null}
from claude_agent_sdk import ClaudeAgentOptions, ThinkingConfigEnabled

# Option 1: dict literal (recommended, no import needed)
options = ClaudeAgentOptions(thinking={"type": "enabled", "budget_tokens": 20000})

# Option 2: constructor-style (returns a plain dict)
config = ThinkingConfigEnabled(type="enabled", budget_tokens=20000)
print(config["budget_tokens"])  # 20000
# config.budget_tokens would raise AttributeError
```

### `TaskBudget`

`ClaudeAgentOptions`의 `task_budget` 필드와 함께 사용되는 토큰 단위의 API 측 작업 예산입니다.

```python theme={null}
class TaskBudget(TypedDict):
    total: int
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `total` | `int` | 작업의 총 토큰 예산 |

이것은 `TypedDict`이므로, `ClaudeAgentOptions(task_budget={"total": 50000})`과 같은 일반 dict로 전달합니다.

### `SdkBeta`

SDK 베타 기능의 리터럴 타입입니다.

```python theme={null}
SdkBeta = Literal["context-1m-2025-08-07"]
```

`ClaudeAgentOptions`의 `betas` 필드와 함께 사용하여 베타 기능을 활성화합니다.

> [!WARNING]
>
> Claude API에서 `context-1m-2025-08-07` 베타는 Claude Sonnet 4.5 및 Claude Sonnet 4에 대해 폐기되었습니다. 두 모델 중 하나와 함께 이를 계속 전달하면 표준 200K 토큰 컨텍스트 윈도우를 초과하는 요청이 오류를 반환하므로, `betas`에서 제거하십시오. 1M 토큰 컨텍스트 윈도우로 세션을 실행하려면 `model`을 `claude-sonnet-5-5` 또는 `claude-opus-5-5`와 같이 [기본적으로 1M 윈도우로 실행되는](https://code.claude.com/docs/ko/model-config.md#extended-context) 모델로 설정합니다. `[1m]` 변형을 통해서만 1M에 도달하는 모델의 경우 `claude-opus-4-6[1m]`처럼 모델 ID에 접미사를 추가합니다.

### `McpSdkServerConfig`

`create_sdk_mcp_server()`로 생성된 SDK MCP 서버의 구성입니다.

```python theme={null}
class McpSdkServerConfig(TypedDict):
    type: Literal["sdk"]
    name: str
    instance: Any  # MCP Server instance
```

### `McpServerConfig`

MCP 서버 구성의 합집합 타입입니다.

```python theme={null}
McpServerConfig = (
    McpStdioServerConfig | McpSSEServerConfig | McpHttpServerConfig | McpSdkServerConfig
)
```

#### `McpStdioServerConfig`

```python theme={null}
class McpStdioServerConfig(TypedDict):
    type: NotRequired[Literal["stdio"]]  # Optional for backwards compatibility
    command: str
    args: NotRequired[list[str]]
    env: NotRequired[dict[str, str]]
```

#### `McpSSEServerConfig`

```python theme={null}
class McpSSEServerConfig(TypedDict):
    type: Literal["sse"]
    url: str
    headers: NotRequired[dict[str, str]]
```

#### `McpHttpServerConfig`

```python theme={null}
class McpHttpServerConfig(TypedDict):
    type: Literal["http"]
    url: str
    headers: NotRequired[dict[str, str]]
```

### `McpServerStatusConfig`

[`get_mcp_status()`](#methods)에서 보고한 MCP 서버의 구성입니다. 이것은 모든 [`McpServerConfig`](#mcpserverconfig) 전송 변형의 합집합에 claude.ai를 통해 프록시된 서버를 위한 출력 전용 `claudeai-proxy` 변형을 더한 것입니다.

```python theme={null}
McpServerStatusConfig = (
    McpStdioServerConfig
    | McpSSEServerConfig
    | McpHttpServerConfig
    | McpSdkServerConfigStatus
    | McpClaudeAIProxyServerConfig
)
```

`McpSdkServerConfigStatus`는 [`McpSdkServerConfig`](#mcpsdkserverconfig)의 직렬화 가능한 형식이며 `type` (`"sdk"`) 및 `name` (`str`) 필드만 있습니다. 인프로세스 `instance`는 생략됩니다. `McpClaudeAIProxyServerConfig`는 `type` (`"claudeai-proxy"`), `url` (`str`) 및 `id` (`str`) 필드를 가집니다.

### `McpStatusResponse`

[`ClaudeSDKClient.get_mcp_status()`](#methods)의 응답입니다. 서버 상태 목록을 `mcpServers` 키 아래에 래핑합니다.

```python theme={null}
class McpStatusResponse(TypedDict):
    mcpServers: list[McpServerStatus]
```

### `McpServerStatus`

[`McpStatusResponse`](#mcpstatusresponse)에 포함된 연결된 MCP 서버의 상태입니다.

```python theme={null}
class McpServerStatus(TypedDict):
    name: str
    status: McpServerConnectionStatus  # "connected" | "failed" | "needs-auth" | "pending" | "disabled"
    serverInfo: NotRequired[McpServerInfo]
    error: NotRequired[str]
    config: NotRequired[McpServerStatusConfig]
    scope: NotRequired[str]
    tools: NotRequired[list[McpToolInfo]]
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `name` | `str` | 서버 이름 |
| `status` | `str` | `"connected"`, `"failed"`, `"needs-auth"`, `"pending"` 또는 `"disabled"` 중 하나 |
| `serverInfo` | `dict` (선택사항) | 서버 이름 및 버전 (`{"name": str, "version": str}`) |
| `error` | `str` (선택사항) | 서버가 연결에 실패한 경우 오류 메시지 |
| `config` | [`McpServerStatusConfig`](#mcpserverstatusconfig) (선택사항) | 서버 구성. [`McpServerConfig`](#mcpserverconfig)와 동일한 형태 (stdio, SSE, HTTP 또는 SDK), 더하기 claude.ai를 통해 연결된 서버를 위한 `claudeai-proxy` 변형 |
| `scope` | `str` (선택사항) | 구성 범위 |
| `tools` | `list` (선택사항) | 이 서버가 제공하는 도구, 각각 `name`, `description` 및 `annotations` 필드 포함 |

### `ContextUsageResponse`

[`ClaudeSDKClient.get_context_usage()`](#methods)의 응답입니다. 응답에는 Claude Code가 대화형 세션에서 `/context` 명령을 위해 렌더링하는 페이로드가 포함됩니다. 이 페이로드는 토큰 수와 함께 Claude Code가 `/context` 사용량 그리드를 그리는 데 사용하는 `color` 및 `gridRows`와 같은 표시 필드를 포함합니다.

Claude Code는 [토큰 계산](https://platform.claude.com/docs/en/build-with-claude/token-counting) API에 여러 요청을 보내 이 페이로드를 빌드합니다. 이 요청은 메시지 스트림에 나타나지 않으므로, 스트림을 읽는 비용 추적은 이를 보지 못합니다. Anthropic API에서 토큰 계산은 청구되지 않습니다.

```python theme={null}
class ContextUsageResponse(TypedDict):
    categories: list[ContextUsageCategory]
    totalTokens: int
    maxTokens: int
    rawMaxTokens: int
    percentage: float
    model: str
    isAutoCompactEnabled: bool
    memoryFiles: list[dict[str, Any]]
    mcpTools: list[dict[str, Any]]
    agents: list[dict[str, Any]]
    gridRows: list[list[dict[str, Any]]]
    autoCompactThreshold: NotRequired[int]
    deferredBuiltinTools: NotRequired[list[dict[str, Any]]]
    systemTools: NotRequired[list[dict[str, Any]]]
    systemPromptSections: NotRequired[list[dict[str, Any]]]
    slashCommands: NotRequired[dict[str, Any]]
    skills: NotRequired[dict[str, Any]]  # skill usage with frontmatter breakdown
    messageBreakdown: NotRequired[dict[str, Any]]  # message tokens by type
    apiUsage: NotRequired[dict[str, Any] | None]
```

각 `ContextUsageCategory` 항목은 `name`, `tokens`, `color` 및 선택적 `isDeferred` 플래그를 포함합니다. `totalTokens`는 세션의 현재 컨텍스트 사용량이고, `maxTokens`는 사용량이 측정되는 윈도우입니다. 해당 윈도우는 모델의 컨텍스트 윈도우이거나, 적용되는 경우 더 작은 자동 압축 윈도우이며, `rawMaxTokens`는 `maxTokens`와 동일한 값을 포함합니다. `apiUsage`는 세션의 실행 총계가 아닌 최신 API 응답의 사용량을 보유합니다. Claude Code는 선택적 `deferredBuiltinTools`, `systemTools` 및 `systemPromptSections` 키를 설정하지 않으므로, 타입이 이를 선언하더라도 이들이 없을 것으로 예상합니다.

### `SdkPluginConfig`

SDK에서 플러그인을 로드하기 위한 구성입니다.

```python theme={null}
class SdkPluginConfig(TypedDict):
    type: Literal["local"]
    path: str
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `type` | `Literal["local"]` | `"local"`이어야 합니다 (현재 로컬 플러그인만 지원됨) |
| `path` | `str` | 플러그인 디렉터리의 절대 또는 상대 경로 |

**예제:**

```python theme={null}
plugins = [
    {"type": "local", "path": "./my-plugin"},
    {"type": "local", "path": "/absolute/path/to/plugin"},
]
```

플러그인 생성 및 사용에 대한 완전한 정보는 [플러그인](https://code.claude.com/docs/ko/agent-sdk/plugins.md)을 참조하십시오.

## 메시지 유형

### `Message`

가능한 모든 메시지의 유니온 타입입니다.

```python theme={null}
Message = (
    UserMessage
    | AssistantMessage
    | SystemMessage
    | ResultMessage
    | StreamEvent
    | RateLimitEvent
    | ConversationResetMessage
)
```

### `UserMessage`

사용자 입력 메시지입니다.

```python theme={null}
@dataclass
class UserMessage:
    content: str | list[ContentBlock]
    uuid: str | None = None
    parent_tool_use_id: str | None = None
    tool_use_result: dict[str, Any] | None = None
    origin: MessageOrigin | None = None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `content` | `str \| list[ContentBlock]` | 텍스트 또는 콘텐츠 블록 형태의 메시지 콘텐츠 |
| `uuid` | `str \| None` | 고유 메시지 식별자 |
| `parent_tool_use_id` | `str \| None` | 이 메시지가 도구 결과 응답인 경우의 도구 사용 ID |
| `tool_use_result` | `dict[str, Any] \| None` | 해당하는 경우 도구 결과 데이터 |
| `origin` | `MessageOrigin \| None` | 이 메시지의 출처로, 작업 알림이나 피어 메시지 같은 주입된 턴에서 채워집니다. CLI가 출처를 지정하지 않은 경우 `None`입니다. Python Agent SDK 0.2.137 이상이 필요합니다 |

SDK는 `tool_use_result`를 CLI에서 수정 없이 그대로 전달합니다. 외부 MCP 서버의 도구 결과에 `resource_link` 블록이 포함된 경우, 이 dict에는 TypeScript [`SDKMcpResourceLink`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkmcpresourcelink) 타입의 키를 가진 dict 목록을 담은 `resourceLinks` 키가 있습니다. Claude는 각 링크를 도구 결과의 텍스트 한 줄로 받습니다. 서버가 반환한 파일을 렌더링하려면 해당 텍스트를 파싱하는 대신 `resourceLinks`를 읽으십시오. `resourceLinks` 키에는 Python Agent SDK 0.2.150 이상과 Claude Code v2.1.257 이상이 필요하며, 해당 SDK 버전에 번들된 CLI는 Claude Code 요구 사항을 충족합니다.

결과에 링크가 없거나 서브에이전트의 결과인 경우 CLI는 이 키를 생략합니다. CLI는 결과당 최대 50개의 링크를 유지하며, 목록이 직렬화된 JSON 기준 64 KiB에 도달하면 링크 추가를 중단합니다. [`tool()`](#tool)로 프로세스 내에서 정의한 도구는 이 키를 생성하지 않습니다. SDK가 CLI에 결과가 전달되기 전에 해당 도구의 `resource_link` 블록을 텍스트로 평탄화하기 때문입니다.

### `AssistantMessage`

콘텐츠 블록을 포함하는 어시스턴트 응답 메시지입니다.

```python theme={null}
@dataclass
class AssistantMessage:
    content: list[ContentBlock]
    model: str
    parent_tool_use_id: str | None = None
    error: AssistantMessageError | None = None
    usage: dict[str, Any] | None = None
    message_id: str | None = None
    stop_reason: str | None = None
    session_id: str | None = None
    uuid: str | None = None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `content` | `list[ContentBlock]` | 응답에 포함된 콘텐츠 블록 목록 |
| `model` | `str` | 응답을 생성한 모델 |
| `parent_tool_use_id` | `str \| None` | 중첩된 응답인 경우의 도구 사용 ID |
| `error` | [`AssistantMessageError`](#assistantmessageerror) ` \| None` | 응답에서 오류가 발생한 경우의 오류 유형 |
| `usage` | `dict[str, Any] \| None` | 메시지별 토큰 사용량([`ResultMessage.usage`](#resultmessage)와 동일한 키) |
| `message_id` | `str \| None` | API 메시지 ID. 하나의 턴에서 나온 여러 메시지는 동일한 ID를 공유합니다 |
| `stop_reason` | `str \| None` | API의 중지 이유(예: `end_turn`, `tool_use`) |
| `session_id` | `str \| None` | 이 메시지가 속한 세션의 ID |
| `uuid` | `str \| None` | 세션 트랜스크립트 내의 고유 메시지 식별자 |

### `AssistantMessageError`

어시스턴트 메시지에서 발생할 수 있는 오류 유형입니다.

```python theme={null}
AssistantMessageError = Literal[
    "authentication_failed",
    "billing_error",
    "rate_limit",
    "invalid_request",
    "server_error",
    "unknown",
]
```

기반 CLI 프로세스는 `max_output_tokens`처럼 이 Literal에 나열되지 않은 오류 유형을 내보낼 수 있습니다. SDK는 값을 수정 없이 그대로 전달하므로, 이 목록에 없는 문자열은 `unknown`과 동일하게 처리하십시오. TypeScript [`SDKAssistantMessageError`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkassistantmessage) 타입에는 CLI가 내보낼 수 있는 전체 값 목록이 나와 있습니다.

### `SystemMessage`

메타데이터가 포함된 시스템 메시지입니다.

```python theme={null}
@dataclass
class SystemMessage:
    subtype: str
    data: dict[str, Any]
```

자체 dataclass가 없는 하위 유형은 `SystemMessage`로 도착합니다. 턴 사이의 세션 상태를 추적하려면 [`CLAUDE_CODE_EMIT_SESSION_STATE_EVENTS=1`](https://code.claude.com/docs/ko/env-vars#variables)을 설정하고 `subtype`이 `session_state_changed`인 각 메시지에서 `message.data["state"]`를 읽으십시오. [`SDKSessionStateChangedMessage`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdksessionstatechangedmessage)에는 이 메시지가 담을 수 있는 상태가 나와 있습니다. 이를 읽으려면 `receive_messages()`로 순회하십시오. `receive_response()`는 `ResultMessage`에서 멈추며, `session_state_changed` 메시지는 해당 결과 뒤에 올 수 있습니다.

### `ResultMessage`

비용 및 사용량 정보가 포함된 최종 결과 메시지입니다.

```python theme={null}
@dataclass
class ResultMessage:
    subtype: str
    duration_ms: int
    duration_api_ms: int
    is_error: bool
    num_turns: int
    session_id: str
    stop_reason: str | None = None
    total_cost_usd: float | None = None
    usage: dict[str, Any] | None = None
    result: str | None = None
    structured_output: Any = None
    model_usage: dict[str, ModelUsage] | None = None
    permission_denials: list[Any] | None = None
    deferred_tool_use: DeferredToolUse | None = None
    errors: list[str] | None = None
    api_error_status: int | None = None
    uuid: str | None = None
    terminal_reason: str | None = None
    origin: MessageOrigin | None = None
```

`subtype` 필드에 따라 어떤 다른 필드가 채워질지 결정됩니다. 값은 `"success"`, `"error_during_execution"`, `"error_max_turns"`, `"error_max_budget_usd"`, `"error_max_structured_output_retries"` 중 하나입니다. Python dataclass는 모든 변형을 하나의 형태로 평탄화하므로, 반환된 하위 유형에 해당하지 않는 필드는 `None`입니다.

여러 필드가 대화 종료 방식에 대한 진단 정보를 담고 있습니다.

* `is_error`: 대화가 오류 상태로 종료된 경우 `True`입니다. `error_*` 하위 유형에서는 항상 `True`입니다. `subtype="success"`에서는 세 가지 경우에 `True`입니다. `stop_reason`을 확인하여 구분하십시오.
  * `"refusal"`: 모델이 응답을 거부했습니다. 거부 텍스트는 `result`에서 읽거나, `result`가 비어 있으면 직전 `AssistantMessage`에서 읽으십시오.
  * `"tool_deferred_unavailable"`: 세션을 재개했을 때 [지연된 도구](https://code.claude.com/docs/ko/hooks.md#defer-a-tool-call-for-later)를 더 이상 사용할 수 없었습니다. 예를 들어 해당 MCP 서버가 연결되지 않은 경우입니다. 아래 두 경우에서, 재개 후 보내는 프롬프트는 재개와 함께 전달한 프롬프트와 동일하게 취급됩니다.
    * 프롬프트 없음: 호출은 여전히 보류 중입니다. 도구를 사용할 수 있게 한 뒤 프롬프트 없이 다시 재개하면 해당 호출이 먼저 실행됩니다.
    * 프롬프트 있음: Claude Code는 도구 결과 없이 프롬프트에 답하며, 지연된 호출은 사라집니다. 여전히 도구 호출이 필요하다면 새 프롬프트를 보내십시오.
  * 그 외의 값: 모델 응답 대신 Claude Code가 보고한 오류(예: API 오류)로 턴이 종료되었습니다. 원인은 `terminal_reason`에서, 메시지는 `result`에서, API가 HTTP 상태를 반환한 경우 해당 상태는 `api_error_status`에서 읽으십시오.
* `api_error_status`: 종료를 일으킨 API 오류의 HTTP 상태 코드입니다. 그러한 오류 없이 턴이 종료된 경우 `None`입니다. `subtype="success"`에서만 채워집니다.
* `result`: `subtype="success"`에서는 최종 어시스턴트 메시지의 텍스트이며, `error_*` 하위 유형에서는 `None`입니다. `subtype="success"`이고 `is_error=True`인 경우, 사용 가능하면 API 오류 문자열을 담지만 비어 있을 수도 있으므로 자세한 내용은 `api_error_status`와 직전 `AssistantMessage` 콘텐츠를 확인하십시오.
* `errors`: 최대 턴 메시지와 같은 루프 수준의 오류 문자열입니다. `error_*` 하위 유형에서만 채워집니다.
* `terminal_reason`: 쿼리 루프가 종료된 이유로, `"completed"`, `"max_turns"`, `"api_error"`, `"aborted_streaming"`, `"aborted_tools"` 등이 있습니다. `"aborted_streaming"` 또는 `"aborted_tools"` 값은 턴이 완료되기 전에 중단되었음을 의미합니다. 일반적인 원인은 [`interrupt()`](#claudesdkclient)와 `interrupt=True`로 [`PermissionResultDeny`](#permissionresultdeny)를 반환하는 권한 콜백입니다. 이 필드가 도입되기 전의 CLI 버전, 쿼리 루프를 거치지 않는 `/voice`나 `/usage` 같은 로컬 명령의 결과, 또는 세션이 치명적으로 실패했을 때 생성되는 합성 오류 결과에서는 `None`입니다. TypeScript SDK의 [`SDKResultMessage.terminal_reason`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkresultmessage)과 대응되며, 해당 문서에 전체 값 목록이 나와 있습니다.
* `origin`: 이 턴을 트리거한 사용자 메시지의 출처입니다. [스트리밍 입력 모드](https://code.claude.com/docs/ko/agent-sdk/streaming-vs-single-mode.md)에서 이 값을 확인하면 `origin`이 `None` 또는 `{"kind": "human"}`인 직접 보낸 프롬프트의 결과와, 백그라운드 작업 알림 같은 주입된 턴의 결과를 구분할 수 있습니다. Python Agent SDK 0.2.137 이상이 필요합니다.

여러 백그라운드 작업이 거의 동시에 완료되면, Claude Code는 각각 하나의 턴으로 답하는 대신 하나의 턴에서 여러 알림에 답할 수 있습니다. 이 경우에도 알림마다 하나의 `ResultMessage`를 순서대로 받으며, 각각의 `origin`은 `kind`가 `"task-notification"`입니다. 마지막을 제외한 모든 메시지는 `num_turns`가 `0`으로 설정되고 `result`가 비어 있으며, 마지막 메시지가 모든 알림에 답하는 턴을 담습니다.

`usage` dict는 메인 에이전트 루프만 포함하며, 서브에이전트 및 기타 중첩되거나 보조적인 모델 호출은 제외합니다. [스트리밍 입력 모드](https://code.claude.com/docs/ko/agent-sdk/streaming-vs-single-mode.md)에서는 값이 턴 단위입니다. 토큰 및 비용 집계에는 `model_usage`를 사용하는 것이 좋습니다. `usage` dict에는 다음 키가 있는 경우 포함됩니다.

| 키 | 타입 | 설명 |
| - | - | - |
| `input_tokens` | `int` | 최상위 에이전트 루프가 소비한 입력 토큰입니다. [서브에이전트 토큰은 포함되지 않습니다](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#get-the-total-cost-of-a-query). 전체 트리 집계에는 `model_usage`를 사용하십시오. |
| `output_tokens` | `int` | 최상위 에이전트 루프가 생성한 출력 토큰입니다. 서브에이전트 토큰은 포함되지 않습니다. |
| `cache_creation_input_tokens` | `int` | 새 캐시 항목을 생성하는 데 사용된 토큰입니다. |
| `cache_read_input_tokens` | `int` | 기존 캐시 항목에서 읽은 토큰입니다. |

`model_usage` dict는 모델 이름을 모델별 사용량에 매핑합니다. 메인 루프, 서브에이전트, 압축 및 Workflow 에이전트 같은 내부 호출 등 쿼리 파이프라인을 통해 이루어진 모든 모델 호출을 포함합니다. 권한 분류기 및 토큰 계산 요청처럼 해당 파이프라인 밖의 보조 호출은 `model_usage`에서 제외됩니다. `model_usage`는 청구 내역이 아닌 추정치로 취급하십시오.

[스트리밍 입력 모드](https://code.claude.com/docs/ko/agent-sdk/streaming-vs-single-mode.md)에서 `model_usage`와 `total_cost_usd`는 턴 전체에 걸쳐 누적되므로, 결과들을 합산하지 말고 최신 결과를 읽으십시오. 세션을 재개하는 호출은 [세션의 이전 호출에서 복원된 합계](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#accumulate-costs-across-multiple-calls)도 함께 집계합니다. 초기화에 대해서는 [스트리밍 입력 모드에서 비용 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#track-costs-in-streaming-input-mode)을, 0으로 표시된 결과에 대해서는 [세션 충돌 후 합계 복구](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#recover-totals-after-a-session-crash)를 참조하십시오.

`model_usage`의 각 값은 `from claude_agent_sdk.types import ModelUsage`로 가져오는 `ModelUsage` TypedDict입니다. SDK가 기반 CLI 프로세스의 값을 수정 없이 그대로 전달하기 때문에 키는 camelCase를 사용하며, TypeScript [`ModelUsage`](https://code.claude.com/docs/ko/agent-sdk/typescript#modelusage) 타입과 일치합니다.

| 키 | 타입 | 설명 |
| - | - | - |
| `inputTokens` | `int` | 이 모델의 입력 토큰입니다. |
| `outputTokens` | `int` | 이 모델의 출력 토큰입니다. |
| `cacheReadInputTokens` | `int` | 이 모델의 캐시 읽기 토큰입니다. |
| `cacheCreationInputTokens` | `int` | 이 모델의 캐시 생성 토큰입니다. |
| `webSearchRequests` | `int` | 이 모델이 수행한 웹 검색 요청 수입니다. |
| `thinkingTokens` | `int` | 이 모델이 생성한 사고 토큰으로, 이미 `outputTokens`에 포함되어 있습니다. 이를 기록하는 Claude Code 버전에서 턴이 실행되기 전까지는 존재하지 않으며 TypedDict에 선언되어 있지 않으므로 `.get()`으로 읽으십시오. 이를 기록하는 CLI가 번들된 Python Agent SDK 0.2.150 이상이 필요합니다. |
| `costUSD` | `float` | 클라이언트 측에서 계산한 이 모델의 예상 비용(USD)입니다. 청구 관련 주의 사항은 [비용 및 사용량 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md)을 참조하십시오. |
| `contextWindow` | `int` | 이 모델의 컨텍스트 윈도우 크기입니다. |
| `maxOutputTokens` | `int` | 이 모델의 최대 출력 토큰 한도입니다. |
| `canonicalModel` | `str` | 가격 조회에 사용된 정식 모델 ID입니다. 제공업체별 ID나 별칭처럼 항목의 키로 사용된 원시 모델 문자열과 다를 수 있습니다. 항상 존재하지는 않습니다. |
| `provider` | `str` | 이 모델을 제공한 API 제공업체로, `firstParty`, `bedrock`, `vertex`, `foundry`, `anthropicAws`, `mantle`, `gateway` 등이 있습니다. 항상 존재하지는 않습니다. |
| `costBasis` | `str` | 이 모델의 최신 요청 가격을 책정한 가격표입니다. 정가는 `list`, [`modelPricing`](https://code.claude.com/docs/ko/settings-reference#modelpricing) 테이블은 `managed`, 둘 다 모델 ID와 일치하지 않으면 `unknown`입니다. 항상 존재하지는 않으며 TypedDict에 선언되어 있지 않으므로 `.get()`으로 읽으십시오. Claude Code v2.1.246 이상이 필요합니다. |

### `StreamEvent`

스트리밍 중 부분 메시지 업데이트를 위한 스트림 이벤트입니다. `ClaudeAgentOptions`에서 `include_partial_messages=True`인 경우에만 수신됩니다. `from claude_agent_sdk.types import StreamEvent`로 가져옵니다.

```python theme={null}
@dataclass
class StreamEvent:
    uuid: str
    session_id: str
    event: dict[str, Any]  # The raw Claude API stream event
    parent_tool_use_id: str | None = None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `uuid` | `str` | 이 이벤트의 고유 식별자 |
| `session_id` | `str` | 세션 식별자 |
| `event` | `dict[str, Any]` | 원시 Claude API 스트림 이벤트 데이터 |
| `parent_tool_use_id` | `str \| None` | 항상 `None`입니다. 스트림 이벤트는 메인 세션에서만 발생합니다. 서브에이전트 귀속 정보에는 [`AssistantMessage`](#assistantmessage) 같은 완전한 메시지를 사용하십시오 |

### `RateLimitEvent`

속도 제한 상태가 변경될 때(예: `"allowed"`에서 `"allowed_warning"`으로) 발생합니다. 사용자가 하드 리밋에 도달하기 전에 경고하거나, 상태가 `"rejected"`일 때 백오프하는 데 사용하십시오.

```python theme={null}
@dataclass
class RateLimitEvent:
    rate_limit_info: RateLimitInfo
    uuid: str
    session_id: str
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `rate_limit_info` | [`RateLimitInfo`](#ratelimitinfo) | 현재 속도 제한 상태 |
| `uuid` | `str` | 고유 이벤트 식별자 |
| `session_id` | `str` | 세션 식별자 |

### `RateLimitInfo`

[`RateLimitEvent`](#ratelimitevent)가 전달하는 속도 제한 상태입니다.

```python theme={null}
RateLimitStatus = Literal["allowed", "allowed_warning", "rejected"]
RateLimitType = Literal[
    "five_hour", "seven_day", "seven_day_opus", "seven_day_sonnet", "overage"
]


@dataclass
class RateLimitInfo:
    status: RateLimitStatus
    resets_at: int | None = None
    rate_limit_type: RateLimitType | None = None
    utilization: float | None = None
    overage_status: RateLimitStatus | None = None
    overage_resets_at: int | None = None
    overage_disabled_reason: str | None = None
    raw: dict[str, Any] = field(default_factory=dict)
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `status` | `RateLimitStatus` | 현재 상태로, `"allowed"`, `"allowed_warning"`, `"rejected"` 중 하나입니다. `"allowed_warning"`은 한도에 근접했음을, `"rejected"`는 한도에 도달했음을 의미합니다 |
| `resets_at` | `int \| None` | 속도 제한 기간이 초기화되는 Unix 타임스탬프 |
| `rate_limit_type` | `RateLimitType \| None` | 적용되는 속도 제한 기간 |
| `utilization` | `float \| None` | 소비된 속도 제한의 비율(0.0\~1.0) |
| `overage_status` | `RateLimitStatus \| None` | 해당하는 경우 종량제 초과 사용량의 상태 |
| `overage_resets_at` | `int \| None` | 초과 사용 기간이 초기화되는 Unix 타임스탬프 |
| `overage_disabled_reason` | `str \| None` | 상태가 `"rejected"`인 경우 초과 사용을 이용할 수 없는 이유 |
| `raw` | `dict[str, Any]` | 위에서 모델링되지 않은 필드를 포함한 CLI의 전체 원시 dict |

### `ConversationResetMessage`

`/clear` 이후처럼 연결을 종료하지 않고 대화가 교체될 때 발생합니다. 초기화가 이후 `ResultMessage` 객체의 누적 합계에 어떤 영향을 미치는지는 [스트리밍 입력 모드에서 비용 추적](https://code.claude.com/docs/ko/agent-sdk/cost-tracking.md#track-costs-in-streaming-input-mode)을 참조하십시오. Python Agent SDK 0.2.137 이상이 필요합니다.

```python theme={null}
@dataclass
class ConversationResetMessage:
    new_conversation_id: str
    uuid: str
    session_id: str
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `new_conversation_id` | `str` | 새 대화의 불투명 식별자입니다. 이후 메시지의 `session_id`가 아니며, 해당 값은 다음 메시지에서 읽으십시오 |
| `uuid` | `str` | 고유 메시지 식별자 |
| `session_id` | `str` | 초기화된 세션의 ID입니다. 초기화 이후의 메시지에는 새 `session_id`가 담깁니다 |

### `TaskStartedMessage`

백그라운드 작업이 시작될 때 발생합니다. 백그라운드 작업은 메인 턴 밖에서 추적되는 모든 것으로, 백그라운드로 실행된 Bash 명령, [Monitor](#monitor) 감시, Agent 도구로 생성된 서브에이전트, 원격 에이전트 등이 있습니다. `task_type` 필드로 어떤 종류인지 알 수 있습니다. 이 이름은 `Task`에서 `Agent`로의 도구 이름 변경과는 관련이 없습니다.

```python theme={null}
@dataclass
class TaskStartedMessage(SystemMessage):
    task_id: str
    description: str
    uuid: str
    session_id: str
    tool_use_id: str | None = None
    task_type: str | None = None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `task_id` | `str` | 작업의 고유 식별자 |
| `description` | `str` | 작업 설명 |
| `uuid` | `str` | 고유 메시지 식별자 |
| `session_id` | `str` | 세션 식별자 |
| `tool_use_id` | `str \| None` | 연관된 도구 사용 ID |
| `task_type` | `str \| None` | 백그라운드 작업의 종류: 백그라운드 Bash 및 Monitor 감시의 경우 `"local_bash"`, `"local_agent"`, 또는 `"remote_agent"` |

### `TaskUsage`

백그라운드 작업의 토큰 및 시간 데이터입니다.

```python theme={null}
class TaskUsage(TypedDict):
    total_tokens: int
    tool_uses: int
    duration_ms: int
```

### `TaskProgressMessage`

실행 중인 백그라운드 작업의 진행 상황 업데이트와 함께 주기적으로 발생합니다.

```python theme={null}
@dataclass
class TaskProgressMessage(SystemMessage):
    task_id: str
    description: str
    usage: TaskUsage
    uuid: str
    session_id: str
    tool_use_id: str | None = None
    last_tool_name: str | None = None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `task_id` | `str` | 작업의 고유 식별자 |
| `description` | `str` | 현재 상태 설명 |
| `usage` | `TaskUsage` | 지금까지 이 작업의 토큰 사용량 |
| `uuid` | `str` | 고유 메시지 식별자 |
| `session_id` | `str` | 세션 식별자 |
| `tool_use_id` | `str \| None` | 연관된 도구 사용 ID |
| `last_tool_name` | `str \| None` | 작업이 마지막으로 사용한 도구의 이름 |

### `TaskNotificationMessage`

백그라운드 작업이 완료, 실패 또는 중지될 때 발생합니다. 백그라운드 작업에는 `run_in_background` Bash 명령, Monitor 감시, 백그라운드 서브에이전트가 포함됩니다.

```python theme={null}
@dataclass
class TaskNotificationMessage(SystemMessage):
    task_id: str
    status: TaskNotificationStatus  # "completed" | "failed" | "stopped"
    output_file: str
    summary: str
    uuid: str
    session_id: str
    tool_use_id: str | None = None
    usage: TaskUsage | None = None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `task_id` | `str` | 작업의 고유 식별자 |
| `status` | `TaskNotificationStatus` | `"completed"`, `"failed"`, `"stopped"` 중 하나 |
| `output_file` | `str` | 작업 출력 파일 경로 |
| `summary` | `str` | 작업 결과 요약 |
| `uuid` | `str` | 고유 메시지 식별자 |
| `session_id` | `str` | 세션 식별자 |
| `tool_use_id` | `str \| None` | 연관된 도구 사용 ID |
| `usage` | `TaskUsage \| None` | 작업의 최종 토큰 사용량 |

CLI가 [오래 걸리는 MCP 도구 호출을 백그라운드로 이동](https://code.claude.com/docs/ko/mcp.md#automatic-backgrounding-of-long-tool-calls)하면, 해당 호출의 도구 결과에는 자리 표시자만 담기고 호출의 실제 결과는 이 메시지로 도착합니다. 이러한 호출에 대한 `"completed"` 알림에서, CLI는 도구가 참조로 반환한 파일을 나열하는 `resource_links` 키를 추가하며, 항목과 제한은 [`UserMessage.tool_use_result`](#usermessage)의 `resourceLinks` 키와 동일합니다. `resource_links` 키에는 Python Agent SDK 0.2.150 이상과 Claude Code v2.1.257 이상이 필요하며, 해당 SDK 버전에 번들된 CLI는 Claude Code 요구 사항을 충족합니다.

dataclass에는 `resource_links`에 대한 필드가 없습니다. 메시지가 [`SystemMessage`](#systemmessage)로부터 상속한 `data` dict에서 `message.data.get("resource_links")`로 읽으십시오. `tool_use_id`로 알림과 호출을 매칭하십시오. 결과에 링크가 없었거나 MCP 도구 호출이 아닌 작업에 대한 알림인 경우 CLI는 이 키를 생략합니다.

## 콘텐츠 블록 타입

### `ContentBlock`

모든 콘텐츠 블록의 합집합 타입입니다.

```python theme={null}
ContentBlock = (
    TextBlock
    | ThinkingBlock
    | ToolUseBlock
    | ToolResultBlock
    | ServerToolUseBlock
    | ServerToolResultBlock
)
```

### `TextBlock`

텍스트 콘텐츠 블록입니다.

```python theme={null}
@dataclass
class TextBlock:
    text: str
```

### `ThinkingBlock`

생각 콘텐츠 블록입니다 (생각 기능이 있는 모델용).

```python theme={null}
@dataclass
class ThinkingBlock:
    thinking: str
    signature: str
```

### `ToolUseBlock`

도구 사용 요청 블록입니다.

```python theme={null}
@dataclass
class ToolUseBlock:
    id: str
    name: str
    input: dict[str, Any]
```

### `ToolResultBlock`

도구 실행 결과 블록입니다.

```python theme={null}
@dataclass
class ToolResultBlock:
    tool_use_id: str
    content: str | list[dict[str, Any]] | None = None
    is_error: bool | None = None
```

## 오류 타입

아래의 타입들은 코드가 포착하는 내용을 정의합니다. 이러한 타입이 발생시키는 오류 메시지, 원인 및 각 오류의 해결 방법에 대한 항목은 [문제 해결](https://code.claude.com/docs/ko/agent-sdk/troubleshooting.md)을 참조하십시오.

### `ClaudeSDKError`

모든 SDK 오류의 기본 예외 클래스입니다.

```python theme={null}
class ClaudeSDKError(Exception):
    """Base error for Claude SDK."""
```

단일 `query()`가 오류 결과로 끝나면(예: 턴 제한 오류) SDK는 [`ResultError`](#resulterror)를 발생시킵니다.

### `CLINotFoundError`

Claude Code CLI가 설치되지 않았거나 찾을 수 없을 때 발생합니다.

```python theme={null}
class CLINotFoundError(CLIConnectionError):
    def __init__(
        self, message: str = "Claude Code not found", cli_path: str | None = None
    ):
        """
        Args:
            message: Error message (default: "Claude Code not found")
            cli_path: Optional path to the CLI that was not found
        """
```

### `CLIConnectionError`

Claude Code 연결이 실패할 때 발생합니다.

```python theme={null}
class CLIConnectionError(ClaudeSDKError):
    """Failed to connect to Claude Code."""
```

### `ProcessError`

Claude Code 프로세스가 실패할 때 발생합니다.

```python theme={null}
class ProcessError(ClaudeSDKError):
    def __init__(
        self, message: str, exit_code: int | None = None, stderr: str | None = None
    ):
        self.exit_code = exit_code
        self.stderr = stderr
```

### `ResultError`

턴 제한 오류 또는 API 오류와 같은 오류 [결과 메시지](#resultmessage)로 실행이 끝나 Claude Code 프로세스가 종료될 때 발생합니다. `ResultError`는 `ProcessError`의 서브클래스이므로 기존 `except ProcessError` 핸들러도 이를 포착합니다. 해당 속성은 결과 메시지의 필드를 포함하므로 메시지 텍스트를 구문 분석하지 않고도 실행이 실패한 이유에 따라 분기할 수 있습니다. Python Agent SDK 0.2.140 이상이 필요합니다.

```python theme={null}
class ResultError(ProcessError):
    subtype: str | None  # "error_max_turns", "error_during_execution", ...; "success" when the run ended on a failed request
    errors: list[str]  # an empty list when the result message reported none
    result: str | None
    api_error_status: int | None
    terminal_reason: str | None  # "max_turns", "api_error", ...; check after data["stop_reason"], before subtype
    session_id: str | None
    data: dict[str, Any]  # the raw result message payload
```

실패를 구분하려면 먼저 `data["stop_reason"]`을 확인한 다음 `terminal_reason`, 그다음 `subtype`을 확인하십시오. 거부된 응답은 `stop_reason`이 `"refusal"`이며 일반적으로 `subtype`은 `"success"`입니다. 이 경우 `terminal_reason`만으로는 거부를 식별할 수 없으며 값이 `"completed"` 또는 `"api_error"`일 수 있습니다. 최종 요청이 실패하면 `subtype`은 `"success"`이고 원인은 `terminal_reason`에 표시됩니다(예: API 오류의 경우 `"api_error"`). 실행이 설정한 제한(예: `max_turns` 또는 `max_budget_usd`)에 도달하면 `error_*` 서브타입이 반환됩니다.

### `CLIJSONDecodeError`

JSON 구문 분석이 실패할 때 발생합니다.

```python theme={null}
class CLIJSONDecodeError(ClaudeSDKError):
    def __init__(self, line: str, original_error: Exception):
        """
        Args:
            line: The line that failed to parse
            original_error: The original JSON decode exception
        """
        self.line = line
        self.original_error = original_error
```

## Hook 타입

hooks 사용에 대한 포괄적인 가이드, 예제 및 일반적인 패턴은 [Hooks 가이드](https://code.claude.com/docs/ko/agent-sdk/hooks.md)를 참조하십시오.

### `HookEvent`

지원되는 hook 이벤트 타입입니다.

```python theme={null}
HookEvent = Literal[
    "PreToolUse",  # Called before tool execution
    "PostToolUse",  # Called after tool execution
    "PostToolUseFailure",  # Called when a tool execution fails
    "UserPromptSubmit",  # Called when a prompt is submitted
    "Stop",  # Called when stopping execution
    "SubagentStop",  # Called when a subagent stops
    "PreCompact",  # Called before message compaction
    "Notification",  # Called for notification events
    "SubagentStart",  # Called when a subagent starts
    "PermissionRequest",  # Called when a permission decision is needed
]
```

> [!NOTE]
>
> TypeScript SDK는 Python에서 아직 사용할 수 없는 추가 hook 이벤트를 지원합니다. SDK별 지원에 대해서는 [hook 가용성 표](https://code.claude.com/docs/ko/agent-sdk/hooks.md#available-hooks)를 참조하십시오.

### `HookCallback`

hook 콜백 함수의 타입 정의입니다.

```python theme={null}
HookCallback = Callable[[HookInput, str | None, HookContext], Awaitable[HookJSONOutput]]
```

매개변수:

* `input`: `hook_event_name`을 기반으로 한 판별된 합집합이 있는 강타입 훅 입력 ([`HookInput`](#hookinput) 참조)
* `tool_use_id`: 선택적 도구 사용 식별자 (도구 관련 hooks의 경우)
* `context`: 추가 정보가 있는 hook 컨텍스트

[`HookJSONOutput`](#hookjsonoutput)을 반환합니다.

### `HookContext`

hook 콜백에 전달되는 컨텍스트 정보입니다.

```python theme={null}
class HookContext(TypedDict):
    signal: Any | None  # Future: abort signal support
```

### `HookMatcher`

특정 이벤트 또는 도구에 hooks를 일치시키기 위한 구성입니다.

```python theme={null}
@dataclass
class HookMatcher:
    matcher: str | None = (
        None  # Tool name or pattern to match (e.g., "Bash", "Write|Edit")
    )
    hooks: list[HookCallback] = field(
        default_factory=list
    )  # List of callbacks to execute
    timeout: float | None = (
        None  # Timeout in seconds. When omitted, the per-event default applies:
        # 600 for most events, 30 for UserPromptSubmit
    )
```

### `HookInput`

모든 hook 입력 타입의 합집합 타입입니다. 실제 타입은 `hook_event_name` 필드에 따라 달라집니다.

```python theme={null}
HookInput = (
    PreToolUseHookInput
    | PostToolUseHookInput
    | PostToolUseFailureHookInput
    | UserPromptSubmitHookInput
    | StopHookInput
    | SubagentStopHookInput
    | PreCompactHookInput
    | NotificationHookInput
    | SubagentStartHookInput
    | PermissionRequestHookInput
)
```

### `BaseHookInput`

모든 hook 입력 타입에 존재하는 기본 필드입니다.

```python theme={null}
class BaseHookInput(TypedDict):
    session_id: str
    transcript_path: str
    cwd: str
    permission_mode: NotRequired[str]
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `session_id` | `str` | 현재 세션 식별자 |
| `transcript_path` | `str` | 세션 기록 파일의 경로 |
| `cwd` | `str` | 현재 작업 디렉토리 |
| `permission_mode` | `str` (선택사항) | 현재 권한 모드 |

### `PreToolUseHookInput`

`PreToolUse` hook 이벤트의 입력 데이터입니다.

```python theme={null}
class PreToolUseHookInput(BaseHookInput):
    hook_event_name: Literal["PreToolUse"]
    tool_name: str
    tool_input: dict[str, Any]
    tool_use_id: str
    agent_id: NotRequired[str]
    agent_type: NotRequired[str]
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["PreToolUse"]` | 항상 "PreToolUse" |
| `tool_name` | `str` | 실행될 도구의 이름 |
| `tool_input` | `dict[str, Any]` | 도구의 입력 매개변수 |
| `tool_use_id` | `str` | 이 도구 사용의 고유 식별자 |
| `agent_id` | `str` (선택사항) | 서브에이전트 식별자, hook이 서브에이전트 내에서 발생할 때 존재 |
| `agent_type` | `str` (선택사항) | 서브에이전트 타입, hook이 서브에이전트 내에서 발생할 때 존재 |

### `PostToolUseHookInput`

`PostToolUse` hook 이벤트의 입력 데이터입니다.

```python theme={null}
class PostToolUseHookInput(BaseHookInput):
    hook_event_name: Literal["PostToolUse"]
    tool_name: str
    tool_input: dict[str, Any]
    tool_response: Any
    tool_use_id: str
    agent_id: NotRequired[str]
    agent_type: NotRequired[str]
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["PostToolUse"]` | 항상 "PostToolUse" |
| `tool_name` | `str` | 실행된 도구의 이름 |
| `tool_input` | `dict[str, Any]` | 사용된 입력 매개변수 |
| `tool_response` | `Any` | 도구 실행의 응답 |
| `tool_use_id` | `str` | 이 도구 사용의 고유 식별자 |
| `agent_id` | `str` (선택사항) | 서브에이전트 식별자, hook이 서브에이전트 내에서 발생할 때 존재 |
| `agent_type` | `str` (선택사항) | 서브에이전트 타입, hook이 서브에이전트 내에서 발생할 때 존재 |

### `PostToolUseFailureHookInput`

`PostToolUseFailure` hook 이벤트의 입력 데이터입니다. 도구 실행이 실패할 때 호출됩니다.

```python theme={null}
class PostToolUseFailureHookInput(BaseHookInput):
    hook_event_name: Literal["PostToolUseFailure"]
    tool_name: str
    tool_input: dict[str, Any]
    tool_use_id: str
    error: str
    is_interrupt: NotRequired[bool]
    agent_id: NotRequired[str]
    agent_type: NotRequired[str]
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["PostToolUseFailure"]` | 항상 "PostToolUseFailure" |
| `tool_name` | `str` | 실패한 도구의 이름 |
| `tool_input` | `dict[str, Any]` | 사용된 입력 매개변수 |
| `tool_use_id` | `str` | 이 도구 사용의 고유 식별자 |
| `error` | `str` | 실패한 실행의 오류 메시지 |
| `is_interrupt` | `bool` (선택사항) | 실패가 중단으로 Claude Code에 도달했을 때 true입니다. 도구가 보고한 오류가 아닌 중단으로 도달했을 때입니다. `interrupt()`로 실행 중인 도구를 취소해도 이 hook이 발생하지 않습니다. 도구 결과에 중단 메시지가 포함됩니다. |
| `agent_id` | `str` (선택사항) | 서브에이전트 식별자, hook이 서브에이전트 내에서 발생할 때 존재 |
| `agent_type` | `str` (선택사항) | 서브에이전트 타입, hook이 서브에이전트 내에서 발생할 때 존재 |

### `UserPromptSubmitHookInput`

`UserPromptSubmit` hook 이벤트의 입력 데이터입니다.

```python theme={null}
class UserPromptSubmitHookInput(BaseHookInput):
    hook_event_name: Literal["UserPromptSubmit"]
    prompt: str
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["UserPromptSubmit"]` | 항상 "UserPromptSubmit" |
| `prompt` | `str` | 제출된 프롬프트 |

### `StopHookInput`

`Stop` hook 이벤트의 입력 데이터입니다.

```python theme={null}
class StopHookInput(BaseHookInput):
    hook_event_name: Literal["Stop"]
    stop_hook_active: bool
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["Stop"]` | 항상 "Stop" |
| `stop_hook_active` | `bool` | stop hook이 활성화되어 있는지 여부 |

### `SubagentStopHookInput`

`SubagentStop` hook 이벤트의 입력 데이터입니다.

```python theme={null}
class SubagentStopHookInput(BaseHookInput):
    hook_event_name: Literal["SubagentStop"]
    stop_hook_active: bool
    agent_id: str
    agent_transcript_path: str
    agent_type: str
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["SubagentStop"]` | 항상 "SubagentStop" |
| `stop_hook_active` | `bool` | stop hook이 활성화되어 있는지 여부 |
| `agent_id` | `str` | 서브에이전트의 고유 식별자 |
| `agent_transcript_path` | `str` | 서브에이전트의 기록 파일 경로 |
| `agent_type` | `str` | 서브에이전트의 타입 |

### `PreCompactHookInput`

`PreCompact` hook 이벤트의 입력 데이터입니다.

```python theme={null}
class PreCompactHookInput(BaseHookInput):
    hook_event_name: Literal["PreCompact"]
    trigger: Literal["manual", "auto"]
    custom_instructions: str | None
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["PreCompact"]` | 항상 "PreCompact" |
| `trigger` | `Literal["manual", "auto"]` | 압축을 트리거한 것 |
| `custom_instructions` | `str \| None` | 압축을 위한 사용자 정의 지침 |

### `NotificationHookInput`

`Notification` hook 이벤트의 입력 데이터입니다.

```python theme={null}
class NotificationHookInput(BaseHookInput):
    hook_event_name: Literal["Notification"]
    message: str
    title: NotRequired[str]
    notification_type: str
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["Notification"]` | 항상 "Notification" |
| `message` | `str` | 알림 메시지 콘텐츠 |
| `title` | `str` (선택사항) | 알림 제목 |
| `notification_type` | `str` | 알림의 타입 |

### `SubagentStartHookInput`

`SubagentStart` hook 이벤트의 입력 데이터입니다.

```python theme={null}
class SubagentStartHookInput(BaseHookInput):
    hook_event_name: Literal["SubagentStart"]
    agent_id: str
    agent_type: str
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["SubagentStart"]` | 항상 "SubagentStart" |
| `agent_id` | `str` | 서브에이전트의 고유 식별자 |
| `agent_type` | `str` | 서브에이전트의 타입 |

### `PermissionRequestHookInput`

`PermissionRequest` hook 이벤트의 입력 데이터입니다. hooks가 프로그래밍 방식으로 권한 결정을 처리할 수 있습니다.

```python theme={null}
class PermissionRequestHookInput(BaseHookInput):
    hook_event_name: Literal["PermissionRequest"]
    tool_name: str
    tool_input: dict[str, Any]
    permission_suggestions: NotRequired[list[Any]]
    agent_id: NotRequired[str]
    agent_type: NotRequired[str]
```

| 필드 | 타입 | 설명 |
| :- | :- | :- |
| `hook_event_name` | `Literal["PermissionRequest"]` | 항상 "PermissionRequest" |
| `tool_name` | `str` | 권한을 요청하는 도구의 이름 |
| `tool_input` | `dict[str, Any]` | 도구의 입력 매개변수 |
| `permission_suggestions` | `list[Any]` (선택사항) | CLI의 제안된 권한 업데이트 |
| `agent_id` | `str` (선택사항) | 서브에이전트 식별자, hook이 서브에이전트 내에서 발생할 때 존재 |
| `agent_type` | `str` (선택사항) | 서브에이전트 타입, hook이 서브에이전트 내에서 발생할 때 존재 |

### `HookJSONOutput`

hook 콜백 반환 값의 합집합 타입입니다.

```python theme={null}
HookJSONOutput = AsyncHookJSONOutput | SyncHookJSONOutput
```

#### `SyncHookJSONOutput`

제어 및 결정 필드가 있는 동기식 hook 출력입니다.

```python theme={null}
class SyncHookJSONOutput(TypedDict):
    # Control fields
    continue_: NotRequired[bool]  # Whether to proceed (default: True)
    suppressOutput: NotRequired[bool]  # Hide stdout from transcript
    stopReason: NotRequired[str]  # Message when continue is False

    # Decision fields
    decision: NotRequired[Literal["block"]]
    systemMessage: NotRequired[str]  # Warning message for user
    reason: NotRequired[str]  # Feedback for Claude

    # Hook-specific output
    hookSpecificOutput: NotRequired[HookSpecificOutput]
```

> [!NOTE]
>
> Python 코드에서 `continue_` (언더스코어 포함)를 사용합니다. CLI로 전송할 때 자동으로 `continue`로 변환됩니다.

#### `HookSpecificOutput`

이벤트 특정 출력 타입의 판별된 합집합입니다. `hookEventName` 필드가 어느 필드가 유효한지 결정합니다. hook 이벤트별 사용 가능한 필드에 대한 전체 세부 정보는 [hooks로 실행 제어](https://code.claude.com/docs/ko/agent-sdk/hooks.md#outputs)를 참조하십시오.

```python theme={null}
class PreToolUseHookSpecificOutput(TypedDict):
    hookEventName: Literal["PreToolUse"]
    permissionDecision: NotRequired[Literal["allow", "deny", "ask", "defer"]]
    permissionDecisionReason: NotRequired[str]
    updatedInput: NotRequired[dict[str, Any]]
    additionalContext: NotRequired[str]


class PostToolUseHookSpecificOutput(TypedDict):
    hookEventName: Literal["PostToolUse"]
    additionalContext: NotRequired[str]
    updatedToolOutput: NotRequired[Any]
    updatedMCPToolOutput: NotRequired[Any]  # MCP tools only. Prefer updatedToolOutput, which works for all tools


class PostToolUseFailureHookSpecificOutput(TypedDict):
    hookEventName: Literal["PostToolUseFailure"]
    additionalContext: NotRequired[str]


class UserPromptSubmitHookSpecificOutput(TypedDict):
    hookEventName: Literal["UserPromptSubmit"]
    additionalContext: NotRequired[str]


class NotificationHookSpecificOutput(TypedDict):
    hookEventName: Literal["Notification"]
    additionalContext: NotRequired[str]


class SubagentStartHookSpecificOutput(TypedDict):
    hookEventName: Literal["SubagentStart"]
    additionalContext: NotRequired[str]


class PermissionRequestHookSpecificOutput(TypedDict):
    hookEventName: Literal["PermissionRequest"]
    decision: dict[str, Any]


HookSpecificOutput = (
    PreToolUseHookSpecificOutput
    | PostToolUseHookSpecificOutput
    | PostToolUseFailureHookSpecificOutput
    | UserPromptSubmitHookSpecificOutput
    | NotificationHookSpecificOutput
    | SubagentStartHookSpecificOutput
    | PermissionRequestHookSpecificOutput
)
```

#### `AsyncHookJSONOutput`

hook 실행을 연기하는 비동기 hook 출력입니다.

```python theme={null}
class AsyncHookJSONOutput(TypedDict):
    async_: Literal[True]  # Set to True to defer execution
    asyncTimeout: NotRequired[int]  # Timeout in milliseconds
```

> [!NOTE]
>
> Python 코드에서 `async_` (언더스코어 포함)를 사용합니다. CLI로 전송할 때 자동으로 `async`로 변환됩니다.

### Hook 사용 예제

이 예제는 두 개의 hooks를 등록합니다: `rm -rf /`와 같은 위험한 bash 명령을 차단하는 하나, 감사를 위해 모든 도구 사용을 기록하는 다른 하나. 보안 hook은 `matcher`를 통해 Bash 명령에서만 실행되고, 로깅 hook은 모든 도구에서 실행됩니다.

```python theme={null}
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions, HookMatcher, HookContext
from typing import Any


async def validate_bash_command(
    input_data: dict[str, Any], tool_use_id: str | None, context: HookContext
) -> dict[str, Any]:
    """Validate and potentially block dangerous bash commands."""
    if input_data["tool_name"] == "Bash":
        command = input_data["tool_input"].get("command", "")
        if "rm -rf /" in command:
            return {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": "deny",
                    "permissionDecisionReason": "Dangerous command blocked",
                }
            }
    return {}


async def log_tool_use(
    input_data: dict[str, Any], tool_use_id: str | None, context: HookContext
) -> dict[str, Any]:
    """Log all tool usage for auditing."""
    print(f"Tool used: {input_data.get('tool_name')}")
    return {}


options = ClaudeAgentOptions(
    hooks={
        "PreToolUse": [
            HookMatcher(
                matcher="Bash", hooks=[validate_bash_command], timeout=120
            ),  # 2 min for validation
            HookMatcher(
                hooks=[log_tool_use]
            ),  # Applies to all tools (per-event default timeout)
        ],
        "PostToolUse": [HookMatcher(hooks=[log_tool_use])],
    }
)

async def main():
    async for message in query(prompt="Analyze this codebase", options=options):
        print(message)


asyncio.run(main())
```

## 도구 입력/출력 타입

기본 제공 Claude Code 도구의 입력/출력 스키마에 대한 문서입니다. Python SDK는 이를 타입으로 export하지 않지만, 이 스키마는 메시지에 포함된 도구 입력과 출력의 구조를 나타냅니다.

아래에 표시된 각 출력은 해당 도구에 대해 [`UserMessage.tool_use_result`](#usermessage)에서 읽는 값입니다. 키 이름은 Claude Code가 내보내는 그대로 표시됩니다. `| None`으로 표시되고 "present when" 또는 "optional" 주석이 달린 키는 해당되지 않을 때 생략됩니다.

### Agent

**도구 이름:** `Agent`. 이 도구를 세션에서 사용할 수 있는 경우 이전 이름인 `Task`도 별칭으로 계속 허용됩니다.

init [`SystemMessage`](#systemmessage)의 `tools` 목록은 하위 호환성을 위해 이 도구를 `Task`로 보고합니다.

**입력:**

```python theme={null}
{
    "description": str,  # 작업에 대한 짧은(3~5단어) 설명
    "prompt": str,  # 에이전트가 수행할 작업
    "subagent_type": str | None,  # 사용할 전문 에이전트의 유형
    "model": "sonnet" | "opus" | "haiku" | "fable" | None,  # 이 에이전트에 대한 모델 재정의
    "effort": "low" | "medium" | "high" | "xhigh" | "max" | None,  # 이 에이전트의 추론 노력 수준
    "run_in_background": bool | None,  # 생략 시 기본값: 메인 에이전트의 호출은 새 에이전트를 백그라운드에서 실행하고, 서브에이전트의 호출은 새 에이전트를 기다림
    "name": str | None,  # 생성되는 에이전트의 이름
    "team_name": str | None,  # deprecated; 무시됨
    "mode": "acceptEdits" | "auto" | "bypassPermissions" | "default" | "dontAsk" | "plan" | None,  # deprecated; 무시됨. 서브에이전트의 권한 모드는 서브에이전트 상속 규칙에 따라 결정됨
    "isolation": "worktree" | "remote" | None,  # 에이전트 변경 사항에 대한 격리 모드
}
```

복잡한 다단계 작업을 자율적으로 처리하기 위해 새 에이전트를 실행합니다.

Claude가 `Agent` 호출에서 `run_in_background`를 생략하면, 기본적으로 메인 에이전트는 새 에이전트를 기다리지 않고 서브에이전트는 기다립니다.

* **메인 에이전트에서 호출한 경우**: 새 에이전트가 백그라운드에서 실행되며, 결과에는 `status: "async_launched"`가 포함됩니다. 메인 에이전트가 대신 새 에이전트를 기다리게 하려면 [Claude가 서브에이전트를 기다릴지 선택하기](https://code.claude.com/docs/ko/agent-sdk/subagents.md#choose-whether-claude-waits-for-subagents)를 참조하세요.
* **서브에이전트 중 하나에서 호출한 경우**: 호출한 서브에이전트가 [새 에이전트를 기다립니다](https://code.claude.com/docs/ko/sub-agents.md#let-subagents-spawn-their-own-subagents). 새 에이전트의 정의에서 [`background`](#agentdefinition)를 `True`로 설정하거나, `CLAUDE_CODE_FORK_SUBAGENT`를 `0`으로 설정하여 [fork 모드를 끄면](https://code.claude.com/docs/ko/sub-agents.md#turn-fork-mode-on-or-off) 새 에이전트가 대신 백그라운드에서 실행됩니다.

Python SDK v0.2.169 이전에는 서브에이전트가 시작한 에이전트도 기본적으로 백그라운드에서 실행되었습니다. 해당 릴리스는 Claude Code v2.1.302 이상을 번들로 포함하는 첫 번째 릴리스입니다.

**출력 (status: `"completed"`):**

```python theme={null}
{
    "status": "completed",
    "agentId": str,  # 실행된 에이전트의 ID
    "agentType": str | None,  # 작업을 처리한 서브에이전트 유형
    "content": [  # 결과 콘텐츠 블록
        {
            "type": "text",
            "text": str,
            "citations": list | None,
        }
    ],
    "resolvedModel": str | None,  # 서브에이전트가 시작할 때 사용한 모델
    "modelsUsed": list[str] | None,  # 사용된 모델 목록(순서대로, 연속 중복은 하나로 합침)
    "totalToolUseCount": int,  # 에이전트가 수행한 도구 호출 수
    "totalDurationMs": int,  # 실행 시간(밀리초)
    "totalTokens": int,  # 전체 실행이 아닌 마지막 API 요청의 토큰 수
    "usage": {  # 토큰 사용량 통계
        "input_tokens": int,
        "output_tokens": int,
        "cache_creation_input_tokens": int | None,
        "cache_read_input_tokens": int | None,
        "server_tool_use": {"web_search_requests": int, "web_fetch_requests": int} | None,
        "service_tier": str | None,
        "cache_creation": {"ephemeral_1h_input_tokens": int, "ephemeral_5m_input_tokens": int} | None,
        "inference_geo": str | None,
        "speed": str | None,
        "iterations": Any | None,
        "output_tokens_details": {"thinking_tokens": int | None} | None,
        "fallback_credit": Any | None,
    },
    "toolStats": {  # 실행 전체의 도구 활동 집계
        "readCount": int,
        "searchCount": int,
        "bashCount": int,
        "editFileCount": int,
        "linesAdded": int,
        "linesRemoved": int,
        "otherToolCount": int,
        "frameCount": int | None,
    } | None,
    "prompt": str,  # 에이전트가 실행한 프롬프트
    "worktreePath": str | None,  # Claude Code가 서브에이전트의 worktree를 유지한 경우 존재
    "worktreeBranch": str | None,  # Claude Code가 git으로 해당 worktree를 생성한 경우 존재
}
```

**출력 (status: `"async_launched"`):**

```python theme={null}
{
    "status": "async_launched",
    "isAsync": bool | None,  # 백그라운드 실행 시 True
    "agentId": str,  # 실행된 에이전트의 ID
    "description": str,  # 작업 설명
    "resolvedModel": str | None,  # 백그라운드로 전환되는 시점에 사용 중이던 모델
    "modelsUsed": list[str] | None,  # 백그라운드 전환 전에 사용된 모델 목록(순서대로, 연속 중복은 하나로 합침)
    "prompt": str,  # 에이전트가 실행하는 프롬프트
    "outputFile": str,  # 에이전트의 출력이 기록되는 파일 경로
    "canReadOutputFile": bool | None,  # 출력 파일을 직접 읽을 수 있는지 여부
}
```

**출력 (status: `"remote_launched"`):**

```python theme={null}
{
    "status": "remote_launched",
    "taskId": str,  # 디스패치된 작업의 ID
    "sessionUrl": str,  # 클라우드 세션 링크
    "description": str,  # 작업 설명
    "prompt": str,  # 에이전트가 실행하는 프롬프트
    "outputFile": str,  # 에이전트의 출력이 기록되는 파일 경로
}
```

서브에이전트의 결과를 반환합니다. 출력은 `status` 필드로 구분됩니다. 완료된 작업은 `"completed"`, 백그라운드 작업은 `"async_launched"`, Claude Code가 클라우드 세션으로 디스패치한 작업은 `"remote_launched"`이며, 이 경우 `sessionUrl`은 해당 세션으로 연결되고 `taskId`는 해당 세션을 식별합니다. Claude Code가 [서브에이전트의 격리된 worktree를 유지한 경우](https://code.claude.com/docs/ko/worktrees.md#isolate-subagents-with-worktrees), `completed` 변형의 `worktreePath`는 해당 worktree의 위치이며, Claude Code가 git으로 worktree를 생성한 경우 `worktreeBranch`는 해당 브랜치입니다.

`completed` 변형에서 `resolvedModel`은 서브에이전트가 시작할 때 사용한 모델을 나타내며, [`availableModels`](https://code.claude.com/docs/ko/model-config#restrict-model-selection) 또는 다른 재정의가 적용되는 경우 요청된 `model` 입력과 다를 수 있습니다. 이 필드는 Claude Code v2.1.174 이상이 필요합니다. `async_launched` 변형에서 `resolvedModel`은 에이전트가 백그라운드로 전환될 때 사용 중이던 모델을 나타내므로, 백그라운드 전환 전에 발생한 모델 교체가 여기에 반영됩니다. 두 변형 모두의 `modelsUsed` 필드는 사용된 모델을 순서대로 나열하며 연속 중복은 하나로 합칩니다. 이 필드는 실행 도중 모델이 교체된 경우에만 설정됩니다. `modelsUsed`와 백그라운드 전환 시점의 `resolvedModel` 동작은 Claude Code v2.1.212 이상이 필요합니다.

Claude Code는 `usage`와 `totalTokens`를 전체 실행이 아닌 서브에이전트의 마지막 API 요청을 기준으로 채웁니다. `usage`의 `output_tokens_details` 아래에 `thinking_tokens`가 있는 경우, 이 값은 해당 요청의 출력 토큰 중 사고 토큰의 수입니다. `output_tokens_details` 키는 Claude Code v2.1.228을 번들로 포함하는 Python SDK v0.2.136 이상이 필요합니다. `fallback_credit` 키는 Claude Code v2.1.285를 번들로 포함하는 Python SDK v0.2.162 이상이 필요합니다.

### AskUserQuestion

**도구 이름:** `AskUserQuestion`

실행 중에 사용자에게 명확히 하기 위한 질문을 합니다. 사용법에 대한 자세한 내용은 [승인 및 사용자 입력 처리](https://code.claude.com/docs/ko/agent-sdk/user-input.md#handle-clarifying-questions)를 참조하세요.

**입력:**

```python theme={null}
{
    "questions": [  # 사용자에게 할 질문(1~4개)
        {
            "question": str,  # 사용자에게 할 전체 질문
            "header": str,  # 칩/태그로 표시되는 매우 짧은 레이블(최대 12자)
            "options": [  # 사용 가능한 선택지(2~4개)
                {
                    "label": str,  # 이 옵션의 표시 텍스트(1~5단어)
                    "description": str,  # 이 옵션의 의미에 대한 설명
                    "preview": str | None,  # 옵션에 포커스가 있을 때 렌더링되는 미리보기 콘텐츠
                }
            ],
            "multiSelect": bool,  # 다중 선택을 허용하려면 true로 설정
        }
    ],
    "answers": dict[str, str] | None,
    # 권한 시스템이 채우는 사용자 답변. 다중 선택
    # 답변은 선택된 레이블을 쉼표로 연결한 문자열이며,
    # 입력 시 레이블 목록도 허용되고 해당 형식으로 변환됨
    "annotations": dict[str, dict] | None,
    # 질문 텍스트를 키로 하는 사용자의 질문별 주석.
    # 각 값에는 "preview"(선택된 옵션의 미리보기
    # 콘텐츠)와 "notes"(선택에 대한 자유 텍스트 메모)가 포함될 수 있음
    "metadata": dict | None,  # {"source": "remember"}와 같은 분석용 메타데이터; 사용자에게 표시되지 않음
}
```

**출력:**

```python theme={null}
{
    "questions": [  # 질문했던 내용
        {
            "question": str,
            "header": str,
            "options": [{"label": str, "description": str, "preview": str | None}],
            "multiSelect": bool,
        }
    ],
    "answers": dict[str, str],  # 질문 텍스트를 답변 문자열에 매핑
    # 다중 선택 답변은 쉼표로 구분됨
    "response": str | None,
    # 질문에 답하는 대신 입력한 자유 형식 응답; 설정된 경우
    # Claude는 답변 목록 대신 "The user responded: ..."를 받음
    "annotations": dict[str, dict] | None,  # 사용자 선택에 대한 질문별 "preview" 및 "notes"
    "afkTimeoutMs": int | None,  # 이 밀리초 동안 사용자가 활동하지 않아 대화 상자가 자동으로 종료된 경우 설정됨; 사용자가 답변한 경우 없음
}
```

### Bash

**도구 이름:** `Bash`

포그라운드 상한을 결정하는 요소는 [타임아웃 및 출력 제한](https://code.claude.com/docs/ko/tools-reference.md#timeout-and-output-limits)을 참조하세요. 백그라운드 시간 제한은 [백그라운드 명령의 시간 제한](https://code.claude.com/docs/ko/tools-reference.md#time-limit-for-background-commands)을 참조하세요.

**입력:**

```python theme={null}
{
    "command": str,  # 실행할 명령
    "timeout": int | None,  # 밀리초. 포그라운드: 기본적으로 600000으로 제한되며, 더 큰 값은 잘림. run_in_background 사용 시(Claude Code v2.1.285 이상): 백그라운드 시간 제한으로, 생략 시 1800000이며 상향하지 않는 한 7200000으로 제한됨
    "description": str | None,  # 명확하고 간결한 설명(5~10단어)
    "run_in_background": bool | None,  # 백그라운드에서 실행하려면 true로 설정
}
```

**출력:**

```python theme={null}
{
    "stdout": str,  # 명령의 출력; stdout과 stderr가 하나의 인터리브된 스트림으로 병합되어 전달됨
    "stderr": str,  # 명령의 stderr가 아닌, 도구 자체가 추가하는 알림
    "interrupted": bool,  # 명령이 중단되었는지 여부
    "isImage": bool | None,  # stdout에 이미지 데이터가 포함되어 있는지 여부
    "backgroundTaskId": str | None,  # 명령이 백그라운드에서 실행 중인 경우 백그라운드 작업의 ID
}
```

### Monitor

**도구 이름:** `Monitor`

백그라운드 소스를 실행하고 각 이벤트를 Claude에 전달하여 폴링 없이 반응할 수 있게 합니다. `command`는 스크립트를 실행하고 stdout 한 줄마다 이벤트 하나를 내보내며, `ws`는 WebSocket을 열고 텍스트 프레임 하나마다 이벤트 하나를 내보냅니다. `command`와 `ws` 중 정확히 하나만 제공하세요.

Monitor가 명령을 실행할 때는 Bash와 동일한 권한 규칙을 따르며, WebSocket 감시는 별도로 승인을 요청합니다. `ws` 소스는 Claude Code v2.1.195 이상이 필요합니다. 동작과 제공업체별 사용 가능 여부는 [Monitor 도구 레퍼런스](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool)를 참조하세요.

**입력:**

```python theme={null}
{
    "command": str | None,  # 셸 스크립트; stdout 각 줄이 이벤트이며, 종료되면 감시가 끝남
    "ws": dict | None,  # WebSocket 소스: {"url": str, "protocols": list[str] | None}; 각 텍스트 프레임이 이벤트
    "description": str,  # 알림에 표시되는 짧은 설명
    "timeout_ms": int | None,  # 기한(밀리초)(기본값 300000, 최대 3600000; 실제 적용 기한은 최대 1800000)
}
```

**출력:**

```python theme={null}
{
    "taskId": str,  # 백그라운드 모니터 작업의 ID
    "timeoutMs": int,  # 감시의 실제 적용 기한(밀리초)
    "persistent": bool | None,  # False: 모든 감시에는 기한이 있음
}
```

### Edit

**도구 이름:** `Edit`

**입력:**

```python theme={null}
{
    "file_path": str,  # 수정할 파일의 절대 경로
    "old_string": str,  # 교체될 기존 텍스트
    "new_string": str,  # 기존 텍스트를 대신할 새 텍스트
    "replace_all": bool | None,  # 모든 일치 항목 교체(기본값 False)
}
```

**출력:**

```python theme={null}
{
    "filePath": str,  # 편집된 파일
    "oldString": str,  # 교체된 기존 텍스트
    "newString": str,  # 기존 텍스트를 대신한 새 텍스트
    "originalFile": str | None,  # 편집 전 파일 내용
    "structuredPatch": [  # 변경에 대한 diff 헝크
        {
            "oldStart": int,
            "oldLines": int,
            "newStart": int,
            "newLines": int,
            "lines": list[str],
        }
    ],
    "userModified": bool,  # 사용자가 수락하기 전에 제안된 편집을 변경했는지 여부
    "replaceAll": bool,  # 모든 일치 항목이 교체되었는지 여부
    "gitDiff": {  # 파일에 대한 선택적 git diff 요약
        "filename": str,
        "status": "modified" | "added",
        "additions": int,
        "deletions": int,
        "changes": int,
        "patch": str,
        "repository": str | None,  # 사용 가능한 경우 GitHub owner/repo
    } | None,
}
```

### Read

**도구 이름:** `Read`

**입력:**

```python theme={null}
{
    "file_path": str,  # 읽을 파일의 절대 경로
    "offset": int | None,  # 읽기를 시작할 줄 번호
    "limit": int | None,  # 읽을 줄 수
}
```

출력은 Claude가 읽은 대상에 따라 다음 형태 중 하나를 가집니다. `type` 키를 확인하여 구분하세요.

**출력 (type: `"text"`):**

```python theme={null}
{
    "type": "text",
    "file": {
        "filePath": str,  # 읽은 파일
        "content": str,  # 반환된 내용
        "numLines": int,  # 반환된 내용의 줄 수
        "startLine": int,  # 내용이 시작되는 줄 번호
        "totalLines": int,  # 파일의 전체 줄 수
        "truncatedByTokenCap": bool | None,  # 전체 파일 읽기가 토큰 상한을 초과하여 content가 첫 페이지인 경우 존재하며 True
    },
}
```

**출력 (type: `"image"`):**

```python theme={null}
{
    "type": "image",
    "file": {
        "base64": str,  # Base64로 인코딩된 이미지 데이터
        "type": "image/jpeg" | "image/png" | "image/gif" | "image/webp",  # 이미지 MIME 타입
        "originalSize": int,  # 원본 파일 크기(바이트)
        "dimensions": {  # 좌표 매핑을 위한 선택적 크기 정보
            "originalWidth": int | None,  # 선택 사항; 원본 너비(픽셀)
            "originalHeight": int | None,  # 선택 사항; 원본 높이(픽셀)
            "displayWidth": int | None,  # 선택 사항; 크기 조정 후 너비
            "displayHeight": int | None,  # 선택 사항; 크기 조정 후 높이
        } | None,
    },
}
```

**출력 (type: `"notebook"`):**

```python theme={null}
{
    "type": "notebook",
    "file": {
        "filePath": str,  # 읽은 노트북
        "cells": list,  # 노트북 셀
    },
}
```

**출력 (type: `"pdf"`):**

```python theme={null}
{
    "type": "pdf",
    "file": {
        "filePath": str,  # 읽은 PDF
        "base64": str,  # Base64로 인코딩된 PDF 데이터
        "originalSize": int,  # 파일 크기(바이트)
    },
}
```

**출력 (type: `"parts"`):**

```python theme={null}
{
    "type": "parts",
    "file": {
        "filePath": str,  # 읽은 PDF
        "originalSize": int,  # 파일 크기(바이트)
        "count": int,  # 이미지로 추출된 페이지 수
        "outputDir": str,  # 추출된 페이지 이미지가 있는 디렉터리
    },
    "firstPage": int | None,  # 선택 사항; 첫 번째로 추출된 페이지의 문서 페이지 번호
}
```

**출력 (type: `"file_unchanged"`):**

```python theme={null}
{
    "type": "file_unchanged",  # 이 세션에서 Claude가 마지막으로 읽은 이후 파일이 변경되지 않았으므로 내용이 반복되지 않음
    "file": {
        "filePath": str,
    },
    "source": "seeded" | None,  # 이전 사본이 Read 호출이 아닌 시작 시 로드된 CLAUDE.md 또는 메모리 파일에서 온 경우 존재
}
```

### Write

**도구 이름:** `Write`

**입력:**

```python theme={null}
{
    "file_path": str,  # 쓸 파일의 절대 경로
    "content": str,  # 파일에 쓸 내용
}
```

**출력:**

```python theme={null}
{
    "type": "create" | "update",  # 쓰기가 새 파일을 생성했는지 기존 파일을 덮어썼는지 여부
    "filePath": str,  # 쓴 파일
    "content": str,  # 쓴 내용
    "structuredPatch": [  # diff 헝크; 새 파일인 경우, 변경 사항이 없는 경우, 또는 Claude Code가 diff를 건너뛴 경우 비어 있음
        {
            "oldStart": int,
            "oldLines": int,
            "newStart": int,
            "newLines": int,
            "lines": list[str],
        }
    ],
    "originalFile": str | None,  # 이전 내용; 새 파일이거나 이전 내용이 너무 커서 포함할 수 없는 경우 None
    "gitDiff": {  # 파일에 대한 선택적 git diff 요약
        "filename": str,
        "status": "modified" | "added",
        "additions": int,
        "deletions": int,
        "changes": int,
        "patch": str,
        "repository": str | None,  # 사용 가능한 경우 GitHub owner/repo
    } | None,
    "userModified": bool | None,  # 선택 사항; 사용자가 수락하기 전에 제안된 내용을 편집했는지 여부
}
```

### Glob

**도구 이름:** `Glob`

**입력:**

```python theme={null}
{
    "pattern": str,  # 파일과 일치시킬 glob 패턴
    "path": str | None,  # 검색할 디렉터리(기본값은 cwd)
}
```

**출력:**

```python theme={null}
{
    "durationMs": int,  # 검색 실행에 걸린 시간(밀리초)
    "numFiles": int,  # 잘림 적용 후 반환된 경로 수
    "filenames": list[str],  # 일치하는 파일 경로
    "truncated": bool,  # 결과가 100개 파일 제한에서 잘렸는지 여부
    "totalMatches": int | None,  # 선택 사항; 잘림 전 일치하는 파일의 총 수; countIsComplete가 False인 경우 하한값
    "countIsComplete": bool | None,  # 선택 사항; totalMatches가 정확한지 여부
}
```

`totalMatches`와 `countIsComplete`는 Claude Code v2.1.191 이상이 필요합니다.

### Grep

**도구 이름:** `Grep`

**입력:**

```python theme={null}
{
    "pattern": str,  # 정규 표현식 패턴
    "path": str | None,  # 검색할 파일 또는 디렉터리
    "glob": str | None,  # 파일을 필터링할 glob 패턴
    "type": str | None,  # 검색할 파일 유형
    "output_mode": str | None,  # "content", "files_with_matches" 또는 "count"
    "-i": bool | None,  # 대소문자 구분 없는 검색
    "-n": bool | None,  # 줄 번호 표시
    "-B": int | None,  # 각 일치 항목 앞에 표시할 줄 수
    "-A": int | None,  # 각 일치 항목 뒤에 표시할 줄 수
    "-C": int | None,  # 앞뒤로 표시할 줄 수
    "context": int | None,  # 앞뒤로 표시할 줄 수; -C는 별칭
    "-o": bool | None,  # 각 줄에서 일치하는 부분만 출력
    "head_limit": int | None,  # 출력을 처음 N개 줄/항목으로 제한
    "offset": int | None,  # head_limit 적용 전에 처음 N개 줄/항목 건너뛰기
    "multiline": bool | None,  # 여러 줄 모드 활성화
}
```

**출력:**

```python theme={null}
{
    "mode": "content" | "files_with_matches" | "count" | None,  # 사용된 출력 모드
    "numFiles": int,  # 결과에 포함된 파일 수; content 모드에서는 항상 0
    "filenames": list[str],  # files_with_matches 모드에서 일치하는 파일; 다른 모드에서는 비어 있음
    "content": str | None,  # content 모드에서는 일치하는 줄, count 모드에서는 파일별 개수
    "numLines": int | None,  # content의 줄 수, content 모드에서 존재
    "numMatches": int | None,  # 전체 일치 개수, count 모드에서 존재
    "totalFiles": int | None,  # 선택 사항; head_limit 및 offset 적용 전 총계, files_with_matches 모드
    "totalLines": int | None,  # 선택 사항; head_limit 및 offset 적용 전 총계, content 모드
    "appliedLimit": int | None,  # head_limit으로 결과가 잘린 경우 존재
    "appliedOffset": int | None,  # offset이 적용된 경우 존재
}
```

Grep은 모든 출력 모드에서 이 dict 형태를 반환합니다. 어떤 선택적 키가 존재하는지는 `output_mode`에 따라 달라집니다.

`totalFiles`는 Claude Code v2.1.208 이상이 필요합니다. `totalLines`는 Claude Code v2.1.210 이상이 필요합니다.

### NotebookEdit

**도구 이름:** `NotebookEdit`

**입력:**

```python theme={null}
{
    "notebook_path": str,  # Jupyter 노트북의 절대 경로
    "cell_id": str | None,  # 편집할 셀의 ID
    "new_source": str,  # 셀의 새 소스
    "cell_type": "code" | "markdown" | None,  # 셀의 유형
    "edit_mode": "replace" | "insert" | "delete" | None,  # 편집 작업 유형
}
```

**출력:**

```python theme={null}
{
    "new_source": str,  # 셀에 쓴 소스
    "old_source": str | None,  # 이전 셀 소스, replace 및 delete에서 존재
    "cell_id": str | None,  # 사용 가능한 경우 편집된 셀의 ID
    "cell_type": "code" | "markdown",  # 셀 유형
    "language": str,  # 노트북의 프로그래밍 언어
    "edit_mode": str,  # 사용된 편집 모드
    "error": str | None,  # 작업이 실패한 경우 오류 메시지
    "notebook_path": str,  # 노트북 파일
    "original_file": str,  # 편집 전 노트북 내용
    "updated_file": str,  # 편집 후 노트북 내용
}
```

### WebFetch

**도구 이름:** `WebFetch`

**입력:**

```python theme={null}
{
    "url": str,  # 콘텐츠를 가져올 URL
    "prompt": str,  # 가져온 콘텐츠에 실행할 프롬프트
    "offset": int | None,  # 페이지 시작 부분에서 건너뛸 문자 수. Python Agent SDK 0.2.164 이상 필요
}
```

**출력:**

```python theme={null}
{
    "bytes": int,  # 가져온 콘텐츠의 크기(바이트)
    "code": int,  # HTTP 응답 코드
    "codeText": str,  # HTTP 응답 코드 텍스트
    "result": str,  # 콘텐츠에 프롬프트를 적용하여 처리한 결과
    "durationMs": int,  # 콘텐츠를 가져와 처리하는 데 걸린 시간(밀리초)
    "url": str,  # 가져온 URL
}
```

### WebSearch

**도구 이름:** `WebSearch`

**입력:**

```python theme={null}
{
    "query": str,  # 사용할 검색 쿼리
    "allowed_domains": list[str] | None,  # 이 도메인의 결과만 포함
    "blocked_domains": list[str] | None,  # 이 도메인의 결과는 절대 포함하지 않음
}
```

**출력:**

```python theme={null}
{
    "query": str,  # 검색 쿼리
    "results": list[str | {"tool_use_id": str, "content": list[{"title": str, "url": str}]}],
    "durationSeconds": float,  # 검색 소요 시간(초)
}
```

### TodoWrite

**도구 이름:** `TodoWrite`

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
> 옵트인하려면 [모델 사용 가능 여부](https://code.claude.com/docs/ko/agent-sdk/todo-tracking.md#model-availability)를 참조하세요.

**입력:**

```python theme={null}
{
    "todos": [
        {
            "content": str,  # 작업 설명
            "status": "pending" | "in_progress" | "completed",  # 작업 상태
            "activeForm": str,  # 설명의 진행형
        }
    ]
}
```

**출력:**

```python theme={null}
{
    "oldTodos": [  # 업데이트 전 할 일 목록
        {
            "content": str,
            "status": "pending" | "in_progress" | "completed",
            "activeForm": str,
        }
    ],
    "newTodos": [  # 업데이트 후 할 일 목록
        {
            "content": str,
            "status": "pending" | "in_progress" | "completed",
            "activeForm": str,
        }
    ],
}
```

### TaskCreate

**도구 이름:** `TaskCreate`

**입력:**

```python theme={null}
{
    "subject": str,  # 짧은 작업 제목
    "description": str,  # 자세한 작업 본문
    "activeForm": str | None,  # 진행 중에 표시되는 현재 진행형 레이블
    "metadata": dict | None,  # 호출자가 지정하는 임의의 메타데이터
}
```

**출력:**

```python theme={null}
{
    "task": {"id": str, "subject": str},  # ID가 할당된 생성된 작업
}
```

### TaskUpdate

**도구 이름:** `TaskUpdate`

**입력:**

```python theme={null}
{
    "taskId": str,  # 수정할 작업의 ID
    "status": Literal["pending", "in_progress", "completed", "deleted"] | None,
    "subject": str | None,
    "description": str | None,
    "activeForm": str | None,
    "addBlocks": list[str] | None,  # 이 작업이 이제 차단하는 작업 ID
    "addBlockedBy": list[str] | None,  # 이제 이 작업을 차단하는 작업 ID
    "owner": str | None,
    "metadata": dict | None,
}
```

**출력:**

```python theme={null}
{
    "success": bool,
    "taskId": str,
    "updatedFields": list[str],  # 변경된 필드 이름
    "error": str | None,
    "statusChange": {"from": str, "to": str} | None,
}
```

### TaskGet

**도구 이름:** `TaskGet`

**입력:**

```python theme={null}
{
    "taskId": str,  # 읽을 작업의 ID
}
```

**출력:**

```python theme={null}
{
    "task": {
        "id": str,
        "subject": str,
        "description": str,
        "status": Literal["pending", "in_progress", "completed"],
        "blocks": list[str],
        "blockedBy": list[str],
    } | None,  # ID를 찾을 수 없는 경우 None
}
```

### TaskList

**도구 이름:** `TaskList`

**입력:**

```python theme={null}
{}
```

**출력:**

```python theme={null}
{
    "tasks": [
        {
            "id": str,
            "subject": str,
            "status": Literal["pending", "in_progress", "completed"],
            "owner": str | None,
            "blockedBy": list[str],
        }
    ],
}
```

### TaskOutput

Claude Code v2.1.277에서 제거되었습니다. 이전에는 실행 중이거나 완료된 백그라운드 작업의 출력을 가져왔으며 `BashOutput`이 별칭으로 허용되었습니다. 이제 Claude는 대신 `Read`로 백그라운드 작업의 출력 파일을 읽습니다.

두 이름 중 하나를 여전히 지정하는 `disallowed_tools` 항목이나 거부 규칙은 경고 없이 무시됩니다.

### TaskStop

**도구 이름:** `TaskStop`. 이전 이름인 `KillShell`과 `KillBash`는 권한 규칙, 훅 matcher, 그리고 `tools`, `allowed_tools`, `disallowed_tools` 옵션에서 계속 사용할 수 있습니다.

**입력:**

```python theme={null}
{
    "task_id": str | None,  # 중지할 백그라운드 작업의 ID
    "shell_id": str | None,  # deprecated: 대신 task_id 사용
}
```

**출력:**

```python theme={null}
{
    "message": str,  # 작업에 대한 상태 메시지
    "task_id": str,  # 중지된 작업의 ID
    "task_type": str,  # 중지된 작업의 유형
    "command": str | None,  # 중지된 작업의 명령 또는 설명
}
```

### ExitPlanMode

**도구 이름:** `ExitPlanMode`

**입력:**

```python theme={null}
{
    "plan": str  # 사용자 승인을 받기 위해 제시할 계획
}
```

**출력:**

```python theme={null}
{
    "plan": str | None,  # 사용자에게 제시된 계획
    "isAgent": bool,  # 서브에이전트가 도구를 호출한 경우 True
    "filePath": str | None,  # 계획이 파일에 저장된 경우 존재
    "hasTaskTool": bool | None,  # 선택 사항; 현재 컨텍스트에서 Agent 도구를 사용할 수 있는지 여부
    "planWasEdited": bool | None,  # 사용자가 승인 전에 계획을 편집한 경우 존재하며 True
    "awaitingLeaderApproval": bool | None,  # 팀원이 승인을 위해 팀 리드에게 계획을 보낸 경우 존재하며 True
    "requestId": str | None,  # 선택 사항; 해당 승인 요청의 ID
}
```

### ListMcpResources

**도구 이름:** `ListMcpResourcesTool`

**입력:**

```python theme={null}
{
    "server": str | None  # 리소스를 필터링할 선택적 서버 이름
}
```

결과는 dict가 아닌 list이므로, 이 도구의 `tool_use_result`는 `list`를 담습니다.

**출력:**

```python theme={null}
[  # 리소스마다 하나의 항목
    {
        "uri": str,  # 리소스 URI
        "name": str,  # 리소스 이름
        "mimeType": str | None,  # 선택적 MIME 타입
        "description": str | None,  # 선택적 설명
        "server": str,  # 이 리소스를 제공하는 서버
    }
]
```

### ReadMcpResource

**도구 이름:** `ReadMcpResourceTool`

**입력:**

```python theme={null}
{
    "server": str,  # MCP 서버 이름
    "uri": str,  # 읽을 리소스 URI
}
```

**출력:**

```python theme={null}
{
    "contents": [
        {
            "uri": str,  # 리소스 URI
            "mimeType": str | None,  # 선택적 MIME 타입
            "text": str | None,  # 텍스트 콘텐츠 또는 바이너리 콘텐츠에 대한 안내
            "blobSavedTo": str | None,  # Claude Code가 바이너리 콘텐츠를 디스크에 저장한 경우 존재; 저장된 파일의 경로
        }
    ],
    "error": str | None,  # 서버가 리소스를 읽을 수 없는 경우 존재
}
```

## 지속적인 대화 인터페이스 구축

다음 예제는 하나의 `ClaudeSDKClient`를 여러 턴에 걸쳐 연결된 상태로 유지하므로 Claude가 이전 메시지를 기억합니다. `new`를 입력하여 연결을 해제하고 다시 연결하여 새로운 세션을 시작하거나, `exit`를 입력하여 대화를 종료합니다.

```python theme={null}
from claude_agent_sdk import (
    ClaudeSDKClient,
    ClaudeAgentOptions,
    AssistantMessage,
    TextBlock,
)
import asyncio


class ConversationSession:
    """Maintains a single conversation session with Claude."""

    def __init__(self, options: ClaudeAgentOptions | None = None):
        self.client = ClaudeSDKClient(options)
        self.turn_count = 0

    async def start(self):
        await self.client.connect()
        print("Starting conversation session. Claude will remember context.")
        print(
            "Commands: 'exit' to quit, 'interrupt' to stop current task, 'new' for new session"
        )

        while True:
            user_input = input(f"\n[Turn {self.turn_count + 1}] You: ")

            if user_input.lower() == "exit":
                break
            elif user_input.lower() == "interrupt":
                await self.client.interrupt()
                print("Task interrupted!")
                continue
            elif user_input.lower() == "new":
                # Disconnect and reconnect for a fresh session
                await self.client.disconnect()
                await self.client.connect()
                self.turn_count = 0
                print("Started new conversation session (previous context cleared)")
                continue

            # Send message - the session retains all previous messages
            await self.client.query(user_input)
            self.turn_count += 1

            # Process response
            print(f"[Turn {self.turn_count}] Claude: ", end="")
            async for message in self.client.receive_response():
                if isinstance(message, AssistantMessage):
                    for block in message.content:
                        if isinstance(block, TextBlock):
                            print(block.text, end="")
            print()  # New line after response

        await self.client.disconnect()
        print(f"Conversation ended after {self.turn_count} turns.")


async def main():
    options = ClaudeAgentOptions(
        allowed_tools=["Read", "Write", "Bash"], permission_mode="acceptEdits"
    )
    session = ConversationSession(options)
    await session.start()


# Example conversation:
# Turn 1 - You: "Create a file called hello.py"
# Turn 1 - Claude: "I'll create a hello.py file for you..."
# Turn 2 - You: "What's in that file?"
# Turn 2 - Claude: "The hello.py file I just created contains..." (remembers!)
# Turn 3 - You: "Add a main function to it"
# Turn 3 - Claude: "I'll add a main function to hello.py..." (knows which file!)

asyncio.run(main())
```

## 오류 처리

다음 예제는 `query()` 호출을 SDK가 발생시키는 [오류 유형](#error-types) 중 네 가지에 대한 핸들러로 래핑합니다.

이 예제는 Python Agent SDK 0.2.140 이상이 필요한 [`ResultError`](#resulterror)를 캐치합니다.

```python theme={null}
import asyncio

from claude_agent_sdk import (
    query,
    CLINotFoundError,
    ProcessError,
    ResultError,
    CLIJSONDecodeError,
)


async def main():
    try:
        async for message in query(prompt="Hello"):
            print(message)
    except CLINotFoundError:
        print(
            "Claude Code CLI not found. Try reinstalling: pip install --force-reinstall claude-agent-sdk"
        )
    # Catch ResultError before ProcessError, which it subclasses. Its message
    # carries the error text. A refusal and a failed final request both usually
    # arrive with subtype "success", so check stop_reason, then terminal_reason.
    except ResultError as e:
        if e.data.get("stop_reason") == "refusal":
            print(f"Model declined to respond: {e}")
        elif e.terminal_reason == "api_error":
            print(f"API request failed: {e}")
        else:
            print(f"Query ended with an error result ({e.terminal_reason or e.subtype}): {e}")
    except ProcessError as e:
        print(f"Process failed with exit code: {e.exit_code}")
    except CLIJSONDecodeError as e:
        print(f"Failed to parse response: {e}")


asyncio.run(main())
```

## 샌드박스 구성

### `SandboxSettings`

샌드박스 동작을 위한 구성입니다. 이를 사용하여 명령 샌드박싱을 활성화하고 프로그래밍 방식으로 네트워크 제한을 구성합니다.

```python theme={null}
class SandboxSettings(TypedDict, total=False):
    enabled: bool
    autoAllowBashIfSandboxed: bool
    excludedCommands: list[str]
    allowUnsandboxedCommands: bool
    network: SandboxNetworkConfig
    ignoreViolations: SandboxIgnoreViolations
    enableWeakerNestedSandbox: bool
```

| 속성 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `enabled` | `bool` | `False` | 명령 실행을 위한 샌드박스 모드 활성화 |
| `autoAllowBashIfSandboxed` | `bool` | `True` | 샌드박스가 활성화되면 bash 명령 자동 승인 |
| `excludedCommands` | `list[str]` | `[]` | 샌드박스 제한을 우회하는 명령 (예: `["docker *"]`). 이들은 모델 개입 없이 자동으로 샌드박스되지 않은 상태로 실행됩니다. [`sandbox.excludedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-excludedcommands)에서 항목이 적용되는 시기를 다룹니다 |
| `allowUnsandboxedCommands` | `bool` | `True` | 모델이 샌드박스 외부에서 명령 실행을 요청하도록 허용합니다. `True`일 때, 모델은 도구 입력에서 `dangerouslyDisableSandbox`를 설정할 수 있으며, 이는 [권한 시스템](#permissions-fallback-for-unsandboxed-commands)으로 폴백됩니다 |
| `network` | [`SandboxNetworkConfig`](#sandboxnetworkconfig) | `None` | 네트워크 특정 샌드박스 구성 |
| `ignoreViolations` | [`SandboxIgnoreViolations`](#sandboxignoreviolations) | `None` | 무시할 샌드박스 위반을 구성합니다 |
| `enableWeakerNestedSandbox` | `bool` | `False` | 호환성을 위해 더 약한 중첩 샌드박스 활성화 |

> [!NOTE]
>
> 샌드박스는 플랫폼 지원에 따라 달라지며, Linux에서는 `bubblewrap` 및 `socat`과 같은 도구가 필요합니다. 기본적으로 `enabled`가 `True`이지만 샌드박스를 시작할 수 없을 때, 명령은 stderr에 경고와 함께 샌드박스되지 않은 상태로 실행됩니다. 이 기본값은 `failIfUnavailable`이 `true`로 기본 설정되는 TypeScript SDK와 다릅니다.
>
> 대신 중지하려면 샌드박스 설정에서 `"failIfUnavailable": True`를 설정하십시오. SDK는 선언된 `SandboxSettings` 필드와 함께 `failIfUnavailable`을 Claude Code로 전달합니다. 그러면 `query()`는 `subtype="error_during_execution"`과 `errors`의 이유를 포함한 `ResultMessage`를 보고합니다. 이것이 단일 샷 `query()` 호출이므로, SDK는 해당 오류 결과를 생성한 후 발생시키므로, 루프를 try 블록으로 감싸서 이를 지나 계속 진행하십시오. [결과 처리](https://code.claude.com/docs/ko/agent-sdk/agent-loop.md#handle-the-result)에서 오류 계약을 참조하십시오.

샌드박스된 명령이 파일에 쓰지 못하도록 하려면, 샌드박스 설정의 [`denyWrite`](https://code.claude.com/docs/ko/settings-reference#sandbox-filesystem-denywrite) 아래에 해당 파일의 절대 경로를 나열하십시오(예: `"filesystem": {"denyWrite": ["/home/user/project/.env"]}`). SDK는 선언된 `SandboxSettings` 필드와 함께 `filesystem`을 Claude Code로 전달합니다. 샌드박스가 시작되면 나열된 각 절대 경로에 대한 쓰기를 차단합니다.

#### 사용 예제

```python theme={null}
import asyncio

from claude_agent_sdk import query, ClaudeAgentOptions

sandbox_settings = {
    "enabled": True,
    "autoAllowBashIfSandboxed": True,
    "failIfUnavailable": True,
    "network": {"allowLocalBinding": True},
}


async def main():
    try:
        async for message in query(
            prompt="Build and test my project",
            options=ClaudeAgentOptions(sandbox=sandbox_settings),
        ):
            print(message)
    except Exception as error:
        # A single-shot query() raises after yielding an error result,
        # such as when failIfUnavailable is set and the sandbox can't start.
        print(f"Session ended with an error: {error}")


asyncio.run(main())
```

> [!WARNING]
>
> **Unix 소켓 보안**: `allowUnixSockets` 옵션은 샌드박스 외부에 도달하는 시스템 서비스에 대한 접근을 부여할 수 있습니다. 예를 들어, `/var/run/docker.sock`을 허용하면 Docker API를 통해 샌드박스 격리를 우회하여 전체 호스트 시스템 접근을 효과적으로 부여합니다. 엄격히 필요한 Unix 소켓만 허용하고 각각의 보안 영향을 이해하십시오.

### `SandboxNetworkConfig`

샌드박스 모드를 위한 네트워크 특정 구성입니다. 이러한 설정은 부모 [`SandboxSettings`](#sandboxsettings)에서 `enabled`가 `True`일 때 샌드박스된 Bash 명령에 적용됩니다. 이들은 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#webfetch)을 대신 사용하는 WebFetch 도구를 제한하지 않습니다.

```python theme={null}
class SandboxNetworkConfig(TypedDict, total=False):
    allowedDomains: list[str]
    deniedDomains: list[str]
    allowManagedDomainsOnly: bool
    allowUnixSockets: list[str]
    allowAllUnixSockets: bool
    allowLocalBinding: bool
    allowMachLookup: list[str]
    httpProxyPort: int
    socksProxyPort: int
```

| 속성 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `allowedDomains` | `list[str]` | `[]` | 샌드박스된 프로세스가 접근할 수 있는 도메인 이름 |
| `deniedDomains` | `list[str]` | `[]` | 샌드박스된 프로세스가 접근할 수 없는 도메인 이름입니다. `allowedDomains`보다 우선합니다 |
| `allowManagedDomainsOnly` | `bool` | `False` | 관리되는 설정만: 관리되는 설정에서 설정되면, 관리되지 않는 설정 소스의 `allowedDomains` 및 `WebFetch(domain:...)` 허용 규칙을 무시합니다. SDK 옵션을 통해 설정할 때는 효과가 없습니다 |
| `allowUnixSockets` | `list[str]` | `[]` | macOS만 해당: 프로세스가 접근할 수 있는 Unix 소켓 경로 (예: Docker 소켓). Linux에서는 무시됩니다 |
| `allowAllUnixSockets` | `bool` | `False` | 모든 Unix 소켓에 대한 접근 허용, Linux에서는 VM 소켓(`AF_VSOCK`)에 대한 접근도 허용 |
| `allowLocalBinding` | `bool` | `False` | 프로세스가 로컬 포트에 바인딩하도록 허용 (예: 개발 서버용) |
| `allowMachLookup` | `list[str]` | `[]` | macOS만 해당: 허용할 XPC/Mach 서비스 이름입니다. 후행 와일드카드를 지원합니다 |
| `httpProxyPort` | `int` | `None` | 네트워크 요청을 위한 HTTP 프록시 포트 |
| `socksProxyPort` | `int` | `None` | 네트워크 요청을 위한 SOCKS 프록시 포트 |

> [!NOTE]
>
> 기본 제공 샌드박스 프록시는 요청된 호스트명을 기반으로 네트워크 허용 목록을 적용하며 TLS 트래픽을 종료하거나 검사하지 않으므로, [도메인 프론팅](https://en.wikipedia.org/wiki/Domain_fronting)과 같은 기술이 이를 우회할 수 있습니다. 자세한 내용은 [샌드박싱 보안 제한 사항](https://code.claude.com/docs/ko/sandboxing.md#security-limitations)을 참조하고, TLS 종료 프록시 구성은 [안전한 배포](https://code.claude.com/docs/ko/agent-sdk/secure-deployment.md#traffic-forwarding)를 참조하십시오.

### `SandboxIgnoreViolations`

특정 샌드박스 위반을 무시하기 위한 구성입니다.

```python theme={null}
class SandboxIgnoreViolations(TypedDict, total=False):
    file: list[str]
    network: list[str]
```

| 속성 | 타입 | 기본값 | 설명 |
| :- | :- | :- | :- |
| `file` | `list[str]` | `[]` | 위반을 무시할 파일 경로 패턴 |
| `network` | `list[str]` | `[]` | 위반을 무시할 네트워크 패턴 |

### 샌드박스되지 않은 명령을 위한 권한 폴백

`allowUnsandboxedCommands`가 활성화되면, 모델은 도구 입력에서 `dangerouslyDisableSandbox: True`를 설정하여 샌드박스 외부에서 명령 실행을 요청할 수 있습니다. 이러한 요청은 기존 권한 시스템으로 폴백되므로, `can_use_tool` 핸들러가 호출되어 사용자 정의 인증 로직을 구현할 수 있습니다.

`excludedCommands` 항목은 대신 모델 개입 없이 샌드박스를 우회합니다. [`sandbox.excludedCommands`](https://code.claude.com/docs/ko/settings-reference#sandbox-excludedcommands)에서 항목이 적용되는 시기를 다룹니다.

다음 예제는 각 샌드박스되지 않은 요청을 로깅하고 사용자 정의 인증 로직이 허용하지 않으면 거부합니다:

```python theme={null}
import asyncio
from claude_agent_sdk import (
    query,
    ClaudeAgentOptions,
    HookMatcher,
    PermissionResultAllow,
    PermissionResultDeny,
    ToolPermissionContext,
)


def is_command_authorized(command: str | None) -> bool:
    # Replace with your own authorization logic
    return False



async def can_use_tool(
    tool: str, input: dict, context: ToolPermissionContext
) -> PermissionResultAllow | PermissionResultDeny:
    # Check if the model is requesting to bypass the sandbox
    if tool == "Bash" and input.get("dangerouslyDisableSandbox"):
        # The model is requesting to run this command outside the sandbox
        print(f"Unsandboxed command requested: {input.get('command')}")

        if is_command_authorized(input.get("command")):
            return PermissionResultAllow()
        return PermissionResultDeny(
            message="Command not authorized for unsandboxed execution"
        )
    return PermissionResultAllow()


# Required: dummy hook keeps the stream open for can_use_tool
async def dummy_hook(input_data, tool_use_id, context):
    return {"continue_": True}


async def prompt_stream():
    yield {
        "type": "user",
        "message": {"role": "user", "content": "Deploy my application"},
    }


async def main():
    async for message in query(
        prompt=prompt_stream(),
        options=ClaudeAgentOptions(
            sandbox={
                "enabled": True,
                "allowUnsandboxedCommands": True,  # Model can request unsandboxed execution
            },
            permission_mode="default",
            can_use_tool=can_use_tool,
            hooks={"PreToolUse": [HookMatcher(matcher=None, hooks=[dummy_hook])]},
        ),
    ):
        print(message)


asyncio.run(main())
```

> [!WARNING]
>
> `dangerouslyDisableSandbox: True`로 실행되는 명령은 전체 시스템 접근 권한이 있습니다. `can_use_tool` 핸들러가 이러한 요청을 신중하게 검증하는지 확인하십시오.
>
> `permission_mode`가 `bypassPermissions`로 설정되고 `allowUnsandboxedCommands`가 활성화되면, 모델은 [어떤 모드도 자동 승인하지 않는 작업](https://code.claude.com/docs/ko/permission-modes.md#actions-no-mode-auto-approves)을 제외하고 승인 프롬프트 없이 샌드박스 외부에서 명령을 자동으로 실행할 수 있습니다. 이 조합은 모델이 샌드박스 격리를 조용히 탈출할 수 있도록 효과적으로 허용합니다.

## 참고 항목

* [SDK 개요](https://code.claude.com/docs/ko/agent-sdk/overview.md) - 일반 SDK 개념
* [TypeScript SDK 참조](https://code.claude.com/docs/ko/agent-sdk/typescript.md) - TypeScript SDK 문서
* [사용자 정의 도구](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md) - Claude가 호출할 수 있는 인프로세스 MCP 도구 정의
* [CLI 참조](https://code.claude.com/docs/ko/cli-reference.md) - 명령줄 인터페이스
* [일반적인 워크플로우](https://code.claude.com/docs/ko/common-workflows.md) - 단계별 가이드
