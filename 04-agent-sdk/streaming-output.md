> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 실시간으로 응답 스트리밍하기

> 텍스트와 도구 호출이 스트리밍될 때 Agent SDK에서 실시간 응답 받기

기본적으로 Agent SDK는 Claude가 각 블록 생성을 완료한 후 텍스트 블록이나 도구 호출과 같은 비어있지 않은 각 콘텐츠 블록에 대해 완전한 `AssistantMessage`를 생성합니다. 텍스트와 도구 호출이 생성될 때 증분 업데이트를 받으려면 부분 메시지 스트리밍을 활성화하십시오.

> [!TIP]
>
> 이 페이지는 출력 스트리밍(실시간으로 토큰 수신)을 다룹니다. 입력 모드(메시지 전송 방법)는 [에이전트에 메시지 전송하기](https://code.claude.com/docs/ko/agent-sdk/streaming-vs-single-mode.md)를 참조하십시오. [CLI를 통해 Agent SDK를 사용하여 응답 스트리밍하기](https://code.claude.com/docs/ko/headless.md)도 가능합니다.

## 스트리밍 출력 활성화

스트리밍을 활성화하려면 옵션에서 `include_partial_messages`(Python) 또는 `includePartialMessages`(TypeScript)를 `true`로 설정하십시오. 이렇게 하면 SDK가 도착하는 대로 원본 API 이벤트를 포함하는 `StreamEvent` 메시지를 생성하며, 일반적인 `AssistantMessage` 및 `ResultMessage`도 함께 생성합니다.

코드는 다음을 수행해야 합니다:

1. 각 메시지의 유형을 확인하여 `StreamEvent`를 다른 메시지 유형과 구분합니다
2. `StreamEvent`의 경우 `event` 필드를 추출하고 해당 `type`을 확인합니다
3. `delta.type`이 `text_delta`인 `content_block_delta` 이벤트를 찾습니다. 이 이벤트에는 실제 텍스트 청크가 포함됩니다

아래 예제는 스트리밍을 활성화하고 도착하는 텍스트 청크를 인쇄합니다. 중첩된 유형 확인에 주목하십시오: 먼저 `StreamEvent`, 그 다음 `content_block_delta`, 그 다음 `text_delta`:

```python Python theme={null}
from claude_agent_sdk import query, ClaudeAgentOptions
from claude_agent_sdk.types import StreamEvent
import asyncio


async def stream_response():
    options = ClaudeAgentOptions(
        include_partial_messages=True,
        allowed_tools=["Bash", "Read"],
    )

    async for message in query(prompt="List the files in my project", options=options):
        if isinstance(message, StreamEvent):
            event = message.event
            if event.get("type") == "content_block_delta":
                delta = event.get("delta", {})
                if delta.get("type") == "text_delta":
                    print(delta.get("text", ""), end="", flush=True)


asyncio.run(stream_response())
```

```typescript TypeScript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "List the files in my project",
  options: {
    includePartialMessages: true,
    allowedTools: ["Bash", "Read"]
  }
})) {
  if (message.type === "stream_event") {
    const event = message.event;
    if (event.type === "content_block_delta") {
      if (event.delta.type === "text_delta") {
        process.stdout.write(event.delta.text);
      }
    }
  }
}
```

## StreamEvent 참조

부분 메시지가 활성화되면 객체로 래핑된 원본 Claude API 스트리밍 이벤트를 받습니다. 유형은 각 SDK에서 다른 이름을 가집니다:

* **Python**: [`StreamEvent`](https://code.claude.com/docs/ko/agent-sdk/python#streamevent) (`claude_agent_sdk.types`에서 가져오기)
* **TypeScript**: [`SDKPartialAssistantMessage`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkpartialassistantmessage) (`type: 'stream_event'` 포함)

둘 다 누적된 텍스트가 아닌 원본 Claude API 이벤트를 포함합니다. 텍스트 델타를 직접 추출하고 누적해야 합니다.

`parent_tool_use_id` 필드는 Python에서는 항상 `None`이고 TypeScript에서는 `null`입니다. 스트림 이벤트는 주 세션에서만 발생합니다. 서브에이전트의 토큰 수준 델타는 전달되지 않습니다. 출력을 서브에이전트에 귀속시키려면 `parent_tool_use_id`를 포함하는 완전한 메시지를 사용하십시오. [서브에이전트 호출 감지](https://code.claude.com/docs/ko/agent-sdk/subagents.md#detect-subagent-invocation)를 참조하십시오.

Claude Code는 턴의 첫 번째 비핑 스트림 이벤트에서 `user_message_uuid`를 설정하고, 턴이 응답하는 메시지가 변경될 때 다시 설정합니다. 이는 [`user_message_uuid`](https://code.claude.com/docs/ko/agent-sdk/typescript#user_message_uuid)의 조건에 따릅니다. Python `StreamEvent`는 이 필드를 노출하지 않습니다.

`event` 필드는 [Claude API](https://platform.claude.com/docs/en/build-with-claude/streaming#event-types)의 원본 스트리밍 이벤트를 포함합니다. 일반적인 이벤트 유형은 다음과 같습니다:

| 이벤트 유형 | 설명 |
| :- | :- |
| `message_start` | 새 메시지의 시작 |
| `content_block_start` | 새 콘텐츠 블록의 시작(텍스트 또는 도구 사용) |
| `content_block_delta` | 콘텐츠에 대한 증분 업데이트 |
| `content_block_stop` | 콘텐츠 블록의 끝 |
| `message_delta` | 메시지 수준 업데이트(중지 이유, 사용량) |
| `message_stop` | 메시지의 끝 |

## 메시지 흐름

Claude Code는 각 비어있지 않은 콘텐츠 블록이 완료될 때마다 `AssistantMessage`를 내보내므로, 텍스트 블록과 도구 호출을 포함하는 응답은 두 개의 `AssistantMessage` 객체를 생성합니다. 각 메시지는 자신의 콘텐츠 블록만 포함하며, 둘 다 동일한 메시지 ID를 공유합니다. 이는 TypeScript에서 `message.message.id`로, Python에서 `message.message_id`로 읽습니다. 부분 메시지가 활성화된 경우, 각 `AssistantMessage`는 해당 블록의 `content_block_stop` 이벤트 이전에 도착하며, 다음 순서로 메시지를 수신합니다:

```text theme={null}
StreamEvent (message_start)
StreamEvent (content_block_start) - text block
StreamEvent (content_block_delta) - text chunks...
AssistantMessage - complete text block
StreamEvent (content_block_stop)
StreamEvent (content_block_start) - tool_use block
StreamEvent (content_block_delta) - tool input chunks...
AssistantMessage - complete tool_use block
StreamEvent (content_block_stop)
StreamEvent (message_delta)
StreamEvent (message_stop)
... tool executes ...
... more streaming events for next turn ...
ResultMessage - final result
```

부분 메시지가 활성화되지 않은 경우, `StreamEvent`를 제외한 모든 메시지 유형을 수신합니다. 일반적인 유형으로는 `SystemMessage` (세션 초기화), `AssistantMessage` (완전한 콘텐츠 블록), `ResultMessage` (최종 결과), 그리고 대화 기록이 압축되었을 때를 나타내는 컴팩트 경계 메시지 (TypeScript의 `SDKCompactBoundaryMessage`; Python의 `SystemMessage`와 서브타입 `"compact_boundary"`)가 있습니다.

### 중단된 스트림 처리하기

스트림이 메시지 도중에 중단되더라도, 턴이 끝나기 전에 해당 메시지의 `message_stop`을 수신합니다. 스트림이 중단되는 원인으로는 턴 중단, 연결 끊김, 비스트리밍 요청으로의 폴백 등이 있습니다. 해당 `message_stop` 이전에 `content_block_stop`과 `message_delta`가 누락될 수 있습니다:

* **`content_block_stop`**: 열려 있던 블록에 대해 도착하지만, 해당 블록이 도구 호출인 경우에는 도착하지 않습니다. 도구 호출의 블록이 아직 열려 있는 상태에서 `message_stop`이 도착하면 해당 호출의 입력을 불완전한 것으로 처리하십시오.
* **`message_delta`**: 턴을 중단하면 도착하지만, 연결이 끊기거나 비스트리밍으로 폴백한 후에는 누락될 수 있으므로 중단된 메시지에서는 이를 기다리지 마십시오.

Claude Code v2.1.290 이전에는 중단된 스트림이 `message_stop` 없이 턴을 종료할 수 있었기 때문에, 스트림 이벤트로 렌더링한 응답이 계속 진행 중으로 표시될 수 있었습니다. TypeScript Agent SDK는 v0.3.290부터, Python Agent SDK는 v0.2.164부터 Claude Code v2.1.290 이상을 번들로 포함합니다. 턴이 끝난 후에도 응답이 계속 진행 중으로 표시된다면 SDK를 업데이트하십시오.

## 도구 호출 스트리밍

도구 호출도 증분적으로 스트리밍됩니다. 도구가 시작될 때를 추적하고, 생성되는 입력을 받고, 완료될 때를 볼 수 있습니다. 아래 예제는 현재 호출되는 도구를 추적하고 스트리밍되는 JSON 입력을 누적합니다. 세 가지 이벤트 유형을 사용합니다:

* `content_block_start`: 도구 시작
* `content_block_delta` with `input_json_delta`: 입력 청크 도착
* `content_block_stop`: 도구 호출 완료

```python Python theme={null}
from claude_agent_sdk import query, ClaudeAgentOptions
from claude_agent_sdk.types import StreamEvent
import asyncio


async def stream_tool_calls():
    options = ClaudeAgentOptions(
        include_partial_messages=True,
        allowed_tools=["Read", "Bash"],
    )

    # Track the current tool and accumulate its input JSON
    current_tool = None
    tool_input = ""

    async for message in query(prompt="Read the README.md file", options=options):
        if isinstance(message, StreamEvent):
            event = message.event
            event_type = event.get("type")

            if event_type == "content_block_start":
                # New tool call is starting
                content_block = event.get("content_block", {})
                if content_block.get("type") == "tool_use":
                    current_tool = content_block.get("name")
                    tool_input = ""
                    print(f"Starting tool: {current_tool}")

            elif event_type == "content_block_delta":
                delta = event.get("delta", {})
                if delta.get("type") == "input_json_delta":
                    # Accumulate JSON input as it streams in
                    chunk = delta.get("partial_json", "")
                    tool_input += chunk
                    print(f"  Input chunk: {chunk}")

            elif event_type == "content_block_stop":
                # Tool call complete - show final input
                if current_tool:
                    print(f"Tool {current_tool} called with: {tool_input}")
                    current_tool = None


asyncio.run(stream_tool_calls())
```

```typescript TypeScript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

// Track the current tool and accumulate its input JSON
let currentTool: string | null = null;
let toolInput = "";

for await (const message of query({
  prompt: "Read the README.md file",
  options: {
    includePartialMessages: true,
    allowedTools: ["Read", "Bash"]
  }
})) {
  if (message.type === "stream_event") {
    const event = message.event;

    if (event.type === "content_block_start") {
      // New tool call is starting
      if (event.content_block.type === "tool_use") {
        currentTool = event.content_block.name;
        toolInput = "";
        console.log(`Starting tool: ${currentTool}`);
      }
    } else if (event.type === "content_block_delta") {
      if (event.delta.type === "input_json_delta") {
        // Accumulate JSON input as it streams in
        const chunk = event.delta.partial_json;
        toolInput += chunk;
        console.log(`  Input chunk: ${chunk}`);
      }
    } else if (event.type === "content_block_stop") {
      // Tool call complete - show final input
      if (currentTool) {
        console.log(`Tool ${currentTool} called with: ${toolInput}`);
        currentTool = null;
      }
    }
  }
}
```

## 스트리밍 UI 구축

이 예제는 텍스트와 도구 스트리밍을 응집력 있는 UI로 결합합니다. 에이전트가 현재 도구를 실행 중인지 추적하기 위해 `in_tool` 플래그를 사용하여 도구가 실행되는 동안 `[Using Read...]`와 같은 상태 표시기를 표시합니다. 도구에 없을 때 텍스트가 정상적으로 스트리밍되고, 도구 완료가 "done" 메시지를 트리거합니다. 이 패턴은 다단계 에이전트 작업 중에 진행 상황을 표시해야 하는 채팅 인터페이스에 유용합니다.

```python Python theme={null}
from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage
from claude_agent_sdk.types import StreamEvent
import asyncio
import sys


async def streaming_ui():
    options = ClaudeAgentOptions(
        include_partial_messages=True,
        allowed_tools=["Read", "Bash", "Grep"],
    )

    # Track whether we're currently in a tool call
    in_tool = False

    async for message in query(
        prompt="Find all TODO comments in the codebase", options=options
    ):
        if isinstance(message, StreamEvent):
            event = message.event
            event_type = event.get("type")

            if event_type == "content_block_start":
                content_block = event.get("content_block", {})
                if content_block.get("type") == "tool_use":
                    # Tool call is starting - show status indicator
                    tool_name = content_block.get("name")
                    print(f"\n[Using {tool_name}...]", end="", flush=True)
                    in_tool = True

            elif event_type == "content_block_delta":
                delta = event.get("delta", {})
                # Only stream text when not executing a tool
                if delta.get("type") == "text_delta" and not in_tool:
                    sys.stdout.write(delta.get("text", ""))
                    sys.stdout.flush()

            elif event_type == "content_block_stop":
                if in_tool:
                    # Tool call finished
                    print(" done", flush=True)
                    in_tool = False

        elif isinstance(message, ResultMessage):
            # Agent finished all work
            print(f"\n\n--- Complete ---")


asyncio.run(streaming_ui())
```

```typescript TypeScript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

// Track whether we're currently in a tool call
let inTool = false;

for await (const message of query({
  prompt: "Find all TODO comments in the codebase",
  options: {
    includePartialMessages: true,
    allowedTools: ["Read", "Bash", "Grep"]
  }
})) {
  if (message.type === "stream_event") {
    const event = message.event;

    if (event.type === "content_block_start") {
      if (event.content_block.type === "tool_use") {
        // Tool call is starting - show status indicator
        process.stdout.write(`\n[Using ${event.content_block.name}...]`);
        inTool = true;
      }
    } else if (event.type === "content_block_delta") {
      // Only stream text when not executing a tool
      if (event.delta.type === "text_delta" && !inTool) {
        process.stdout.write(event.delta.text);
      }
    } else if (event.type === "content_block_stop") {
      if (inTool) {
        // Tool call finished
        console.log(" done");
        inTool = false;
      }
    }
  } else if (message.type === "result") {
    // Agent finished all work
    console.log("\n\n--- Complete ---");
  }
}
```

## 알려진 제한 사항

* **구조화된 출력**: 부분 메시지가 활성화된 경우, JSON은 도구 호출의 검증되지 않은 `input_json_delta` 청크로 스트리밍되며, 검증된 결과만 최종 `ResultMessage.structured_output`에 도달합니다. 해당 호출이 스트림에 어떻게 나타나는지는 [StructuredOutput 도구 호출 인식하기](https://code.claude.com/docs/ko/agent-sdk/structured-outputs.md#recognize-the-structuredoutput-tool-call)에서 설명합니다.

## 다음 단계

이제 실시간으로 텍스트와 도구 호출을 스트리밍할 수 있으므로 다음 관련 항목을 살펴보십시오:

* [대화형 vs 일회성 쿼리](https://code.claude.com/docs/ko/agent-sdk/streaming-vs-single-mode.md): 사용 사례에 맞는 입력 모드 선택
* [구조화된 출력](https://code.claude.com/docs/ko/agent-sdk/structured-outputs.md): 에이전트에서 입력된 JSON 응답 받기
* [권한](https://code.claude.com/docs/ko/agent-sdk/permissions.md): 에이전트가 사용할 수 있는 도구 제어
