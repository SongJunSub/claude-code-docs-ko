> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude에 사용자 정의 도구 제공

> Claude Agent SDK의 인프로세스 MCP 서버로 사용자 정의 도구를 정의하여 Claude가 함수를 호출하고, API를 사용하며, 도메인별 작업을 수행할 수 있도록 합니다.

사용자 정의 도구는 Claude가 대화 중에 호출할 수 있는 자신의 함수를 정의하도록 하여 Agent SDK를 확장합니다. SDK의 인프로세스 MCP 서버를 사용하면 Claude에 데이터베이스, 외부 API, 도메인별 로직 또는 애플리케이션에 필요한 다른 기능에 대한 액세스 권한을 부여할 수 있습니다.

## 빠른 참조

| 원하는 작업 | 수행 방법 |
| :- | :- |
| 도구 정의 | 이름, 설명, 스키마 및 핸들러를 사용하여 [`@tool`](https://code.claude.com/docs/ko/agent-sdk/python#tool) (Python) 또는 [`tool()`](https://code.claude.com/docs/ko/agent-sdk/typescript#tool) (TypeScript)을 사용합니다. [사용자 정의 도구 만들기](#create-a-custom-tool)를 참조하세요. |
| 매개변수를 선택 사항으로 만들기 | 스키마에서 선택 사항으로 선언하고 핸들러에서 기본값을 적용합니다. [매개변수를 선택 사항으로 만들기](#make-a-parameter-optional)를 참조하세요. |
| Claude에 도구 등록 | `create_sdk_mcp_server` / `createSdkMcpServer`로 래핑하고 `query()`의 `mcpServers`에 전달합니다. [사용자 정의 도구 호출](#call-a-custom-tool)을 참조하세요. |
| 도구 사전 승인 | 허용된 도구에 추가합니다. [허용된 도구 구성](#configure-allowed-tools)을 참조하세요. |
| 도구 호출에 승인 요구 또는 도구 차단 | TypeScript SDK에서 `createSdkMcpServer()`가 반환하는 구성 객체에 해당 도구의 `permission_policy`를 추가합니다. [특정 도구에 승인 요구](#require-approval-for-specific-tools)를 참조하세요. |
| Claude의 컨텍스트에서 기본 제공 도구 제거 | 원하는 기본 제공 도구만 나열하는 `tools` 배열을 전달합니다. [허용된 도구 구성](#configure-allowed-tools)을 참조하세요. |
| Claude가 도구를 병렬로 호출하도록 허용 | 부작용이 없는 도구에 `readOnlyHint: true`를 설정합니다. [도구 주석 추가](#add-tool-annotations)를 참조하세요. |
| Claude가 읽는 오류 메시지 제어 | 원시 예외를 표시하는 대신 메시지를 작성하려면 `isError: true`를 반환합니다. [오류 처리](#handle-errors)를 참조하세요. |
| 이미지 또는 파일 반환 | 콘텐츠 배열에서 `image` 또는 `resource` 블록을 사용합니다. [이미지 및 리소스 반환](#return-images-and-resources)을 참조하세요. |
| 머신 판독 가능한 JSON 결과 반환 | 결과에 `structuredContent`를 설정합니다. [구조화된 데이터 반환](#return-structured-data)을 참조하세요. |
| 많은 도구로 확장 | [도구 검색](https://code.claude.com/docs/ko/agent-sdk/tool-search.md)을 사용하여 필요에 따라 도구를 로드합니다. |

## 사용자 정의 도구 만들기

도구는 TypeScript의 [`tool()`](https://code.claude.com/docs/ko/agent-sdk/typescript#tool) 헬퍼 또는 Python의 [`@tool`](https://code.claude.com/docs/ko/agent-sdk/python#tool) 데코레이터에 인수로 전달되는 네 가지 부분으로 정의됩니다:

* **이름:** Claude가 도구를 호출할 때 사용하는 고유 식별자입니다.
* **설명:** 도구가 수행하는 작업입니다. Claude는 이를 읽고 도구를 호출할 시기를 결정합니다.
* **입력 스키마:** 도구가 받는 인수이며, 언어별로 다음과 같이 선언합니다:
  * **TypeScript**: [Zod 스키마](https://zod.dev/)입니다. 핸들러의 `args`는 이 스키마에서 타입을 가져옵니다. 필드에 `.describe()`를 호출하면 Claude가 보는 설명을 필드에 부여할 수 있습니다.
  * **Python**: `{"latitude": float}`와 같이 이름을 타입에 매핑하는 딕셔너리이며, SDK가 이를 JSON 스키마로 변환합니다. `{"latitude": Annotated[float, "Latitude coordinate"]}`와 같이 타입을 `Annotated`로 감싸면 Claude가 보는 설명을 필드에 부여할 수 있습니다. 열거형, 범위, 선택적 필드 또는 중첩된 객체가 필요할 때는 데코레이터에 전체 [JSON 스키마](https://json-schema.org/understanding-json-schema/about) 딕셔너리를 직접 전달할 수도 있습니다.
* **핸들러:** Claude가 도구를 호출할 때 실행되는 비동기 함수입니다. 검증된 인수를 받으며 다음을 포함하는 객체를 반환해야 합니다:
  * `content` (필수): 각각 `"text"`, `"image"`, `"audio"`, `"resource"` 또는 `"resource_link"`의 `type`을 가진 결과 블록의 배열입니다. 텍스트가 아닌 블록은 [이미지 및 리소스 반환](#return-images-and-resources)을 참조하세요.
  * `structuredContent` (선택사항): 결과를 기계 판독 가능한 데이터로 보유하는 JSON 객체이며, `content`와 함께 반환됩니다. [구조화된 데이터 반환](#return-structured-data)을 참조하세요.
  * `isError` (선택사항): 도구 실패를 신호하려면 `true`로 설정하여 Claude가 이에 반응할 수 있도록 합니다. [오류 처리](#handle-errors)를 참조하세요.

도구를 정의한 후 [`createSdkMcpServer`](https://code.claude.com/docs/ko/agent-sdk/typescript#createsdkmcpserver) (TypeScript) 또는 [`create_sdk_mcp_server`](https://code.claude.com/docs/ko/agent-sdk/python#create_sdk_mcp_server) (Python)를 사용하여 서버에 래핑합니다. 서버는 별도의 프로세스가 아닌 애플리케이션 내에서 인프로세스로 실행됩니다.

이 페이지에서 HTTP 요청을 수행하는 Python 예제는 [httpx](https://www.python-httpx.org/)를 사용합니다. 프로젝트에서 사용하는 패키지 관리자로 추가하세요:

> [tab] Python (uv)
>
> ```bash theme={null}
> uv add httpx
> ```

> [tab] Python (pip)
>
> ```bash theme={null}
> pip install httpx
> ```

### 날씨 도구 예제

이 예제는 `get_temperature` 도구를 정의하고 MCP 서버에 래핑하며, 서버를 `query`에 전달하지는 않습니다. 도구를 실행하려면 아래의 [사용자 정의 도구 호출](#call-a-custom-tool)을 참조하세요.

```python Python theme={null}
from typing import Annotated, Any
import httpx
from claude_agent_sdk import tool, create_sdk_mcp_server


# Define a tool: name, description, input schema, handler
@tool(
    "get_temperature",
    "Get the current temperature at a location",
    {
        "latitude": Annotated[float, "Latitude coordinate"],
        "longitude": Annotated[float, "Longitude coordinate"],
    },
)
async def get_temperature(args: dict[str, Any]) -> dict[str, Any]:
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://api.open-meteo.com/v1/forecast",
            params={
                "latitude": args["latitude"],
                "longitude": args["longitude"],
                "current": "temperature_2m",
                "temperature_unit": "fahrenheit",
            },
        )
        data = response.json()

    # Return a content array - Claude sees this as the tool result
    return {
        "content": [
            {
                "type": "text",
                "text": f"Temperature: {data['current']['temperature_2m']}°F",
            }
        ]
    }


# Wrap the tool in an in-process MCP server
weather_server = create_sdk_mcp_server(
    name="weather",
    version="1.0.0",
    tools=[get_temperature],
)
```

```typescript TypeScript theme={null}
import { tool, createSdkMcpServer } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

// Define a tool: name, description, input schema, handler
const getTemperature = tool(
  "get_temperature",
  "Get the current temperature at a location",
  {
    latitude: z.number().describe("Latitude coordinate"), // .describe() adds a field description Claude sees
    longitude: z.number().describe("Longitude coordinate")
  },
  async (args) => {
    // args is typed from the schema: { latitude: number; longitude: number }
    const response = await fetch(
      `https://api.open-meteo.com/v1/forecast?latitude=${args.latitude}&longitude=${args.longitude}&current=temperature_2m&temperature_unit=fahrenheit`
    );
    const data: any = await response.json();

    // Return a content array - Claude sees this as the tool result
    return {
      content: [{ type: "text", text: `Temperature: ${data.current.temperature_2m}°F` }]
    };
  }
);

// Wrap the tool in an in-process MCP server
const weatherServer = createSdkMcpServer({
  name: "weather",
  version: "1.0.0",
  tools: [getTemperature]
});
```

전체 매개변수 세부 정보(JSON 스키마 입력 형식 및 반환 값 구조 포함)는 [`tool()`](https://code.claude.com/docs/ko/agent-sdk/typescript#tool) TypeScript 참조 또는 [`@tool`](https://code.claude.com/docs/ko/agent-sdk/python#tool) Python 참조를 참조하세요.

### 매개변수를 선택사항으로 만들기

매개변수를 선택사항으로 만들려면 스키마에서 선택사항으로 선언하고 핸들러에서 기본값을 적용합니다:

* **TypeScript**: Zod 필드에 `.optional()`을 추가합니다.
* **Python**: 딕셔너리 스키마는 모든 키를 필수로 요구합니다. JSON 스키마 형식을 사용하고, 매개변수를 `required`에서 제외한 뒤 `args.get()`으로 읽습니다. 선택적 키가 있는 타입 지정 스키마는 [TypedDict 클래스](https://code.claude.com/docs/ko/agent-sdk/python.md#input-schema-options)를 참조하세요.

[아래의 `get_precipitation_chance` 도구](#add-more-tools)는 두 패턴을 모두 보여줍니다.

### 사용자 정의 도구 호출

`mcpServers` 옵션을 통해 생성한 MCP 서버를 `query`에 전달하고, 도구가 권한 프롬프트 없이 실행되도록 각 도구의 [정규화된 이름](https://code.claude.com/docs/ko/agent-sdk/mcp.md#tool-naming-convention)을 `allowedTools`에 나열합니다. 이 이름은 `mcp__{server_name}__{tool_name}`이며, 여기서 `{server_name}`은 `mcpServers`에서 서버에 지정한 키입니다. 키에 `.`이나 공백과 같은 문자가 포함되어 있으면 `{server_name}`을 작성할 때 해당 문자를 `_`로 바꿉니다.

이 스니펫들은 [날씨 도구 예제](#weather-tool-example)의 `weatherServer`를 재사용하여 Claude에게 특정 위치의 날씨를 묻습니다.

```python Python theme={null}
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage


async def main():
    options = ClaudeAgentOptions(
        mcp_servers={"weather": weather_server},
        allowed_tools=["mcp__weather__get_temperature"],
    )

    async for message in query(
        prompt="What's the temperature in San Francisco?",
        options=options,
    ):
        # ResultMessage is the final message after all tool calls complete
        if isinstance(message, ResultMessage) and message.subtype == "success":
            print(message.result)


asyncio.run(main())
```

```typescript TypeScript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "What's the temperature in San Francisco?",
  options: {
    mcpServers: { weather: weatherServer },
    allowedTools: ["mcp__weather__get_temperature"]
  }
})) {
  // "result" is the final message after all tool calls complete
  if (message.type === "result" && message.subtype === "success") {
    console.log(message.result);
  }
}
```

이 스니펫을 [날씨 도구 예제](#weather-tool-example)의 도구 및 서버 정의와 함께 `weather.py` 또는 `weather.ts` 한 파일에 결합한 후 터미널에서 실행합니다:

> [tab] TypeScript
>
> ```bash theme={null}
> npx tsx weather.ts
> ```

> [tab] Python (uv)
>
> ```bash theme={null}
> uv run weather.py
> ```

> [tab] Python (pip)
>
> SDK를 설치한 가상 환경을 활성화한 후 다음을 실행합니다:
>
> ```bash theme={null}
> python weather.py
> ```

Claude는 `get_temperature`를 호출하고 스크립트는 샌프란시스코의 현재 온도를 포함한 한 줄 답변을 출력합니다.

### 더 많은 도구 추가

서버는 `tools` 배열에 나열한 만큼 많은 도구를 보유합니다. 서버에 둘 이상의 도구가 있으면 `allowedTools`에서 각각을 개별적으로 나열하거나 와일드카드 `mcp__weather__*`를 사용하여 서버가 노출하는 모든 도구를 포함할 수 있습니다.

아래 예제는 두 번째 도구 `get_precipitation_chance`를 정의하고 [날씨 도구 예제](#weather-tool-example)의 `weatherServer` 정의를 배열의 두 도구를 모두 나열하는 것으로 바꿉니다.

```python Python theme={null}
# Define a second tool for the same server
@tool(
    "get_precipitation_chance",
    "Get the hourly precipitation probability for a location",
    {
        "type": "object",
        "properties": {
            "latitude": {"type": "number"},
            "longitude": {"type": "number"},
            "hours": {
                "type": "integer",
                "minimum": 1,
                "maximum": 24,
                "description": "How many hours of forecast to return",
            },
        },
        # 'hours' is left out of required, so Claude can omit it
        "required": ["latitude", "longitude"],
    },
)
async def get_precipitation_chance(args: dict[str, Any]) -> dict[str, Any]:
    # 'hours' isn't in required - read it with .get() to fall back to a default
    hours = args.get("hours", 12)
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://api.open-meteo.com/v1/forecast",
            params={
                "latitude": args["latitude"],
                "longitude": args["longitude"],
                "hourly": "precipitation_probability",
                "forecast_days": 1,
            },
        )
        data = response.json()
    chances = data["hourly"]["precipitation_probability"][:hours]

    return {
        "content": [
            {
                "type": "text",
                "text": f"Next {hours} hours: {'%, '.join(map(str, chances))}%",
            }
        ]
    }


# Rebuild the server with both tools in the array
weather_server = create_sdk_mcp_server(
    name="weather",
    version="1.0.0",
    tools=[get_temperature, get_precipitation_chance],
)
```

```typescript TypeScript theme={null}
// Define a second tool for the same server
const getPrecipitationChance = tool(
  "get_precipitation_chance",
  "Get the hourly precipitation probability for a location",
  {
    latitude: z.number(),
    longitude: z.number(),
    hours: z
      .number()
      .int()
      .min(1)
      .max(24)
      .optional() // .optional() lets Claude omit the parameter
      .describe("How many hours of forecast to return")
  },
  async (args) => {
    const hours = args.hours ?? 12; // Apply the default in the handler
    const response = await fetch(
      `https://api.open-meteo.com/v1/forecast?latitude=${args.latitude}&longitude=${args.longitude}&hourly=precipitation_probability&forecast_days=1`
    );
    const data: any = await response.json();
    const chances = data.hourly.precipitation_probability.slice(0, hours);

    return {
      content: [{ type: "text", text: `Next ${hours} hours: ${chances.join("%, ")}%` }]
    };
  }
);

// Rebuild the server with both tools in the array
const weatherServer = createSdkMcpServer({
  name: "weather",
  version: "1.0.0",
  tools: [getTemperature, getPrecipitationChance]
});
```

[도구 검색](https://code.claude.com/docs/ko/agent-sdk/tool-search.md)은 기본적으로 활성화되어 있으며 SDK MCP 도구를 연기합니다: Claude는 각 도구의 이름을 간단한 목록으로 보고 필요에 따라 전체 스키마를 로드합니다. 도구 검색이 비활성화되면 이 배열의 모든 도구는 매 턴마다 컨텍스트 윈도우 공간을 소비합니다. TypeScript에서는 [`tool()`](https://code.claude.com/docs/ko/agent-sdk/typescript#tool)의 `extras` 인수 또는 [`createSdkMcpServer()`](https://code.claude.com/docs/ko/agent-sdk/typescript#createsdkmcpserver)의 옵션에서 `alwaysLoad: true`를 전달하여 도구의 전체 스키마를 초기 프롬프트에 유지합니다.

### 도구 주석 추가

[도구 주석](https://modelcontextprotocol.io/docs/concepts/tools#tool-annotations)은 도구의 동작을 설명하는 선택사항 메타데이터입니다. TypeScript의 `tool()` 헬퍼에 다섯 번째 인수로 또는 Python의 `@tool` 데코레이터에 대해 `annotations` 키워드 인수로 전달합니다. 모든 힌트 필드는 부울입니다.

| 필드 | 기본값 | 의미 |
| :- | :- | :- |
| `readOnlyHint` | `false` | 도구는 환경을 수정하지 않습니다. 도구를 다른 읽기 전용 도구와 병렬로 호출할 수 있는지 여부를 제어합니다. |
| `destructiveHint` | `true` | 도구는 파괴적인 업데이트를 수행할 수 있습니다. [`always_ask`로 표시](#require-approval-for-specific-tools)하는 모든 도구에는 이 값을 명시적으로 `true`로 설정하세요. |
| `idempotentHint` | `false` | 동일한 인수로 반복 호출해도 추가 효과가 없습니다. 정보 제공용입니다. |
| `openWorldHint` | `true` | 도구는 프로세스 외부의 시스템에 도달합니다. 정보 제공용입니다. |

주석은 메타데이터이지 강제 사항이 아닙니다. `readOnlyHint: true`로 표시된 도구도 핸들러가 그렇게 하면 디스크에 쓸 수 있습니다. 주석을 핸들러와 정확하게 유지하세요.

이 예제는 [날씨 도구 예제](#weather-tool-example)의 `get_temperature` 도구에 `readOnlyHint`를 추가합니다.

```python Python theme={null}
from claude_agent_sdk import tool, ToolAnnotations


@tool(
    "get_temperature",
    "Get the current temperature at a location",
    {"latitude": float, "longitude": float},
    annotations=ToolAnnotations(
        readOnlyHint=True
    ),  # Lets Claude batch this with other read-only calls
)
async def get_temperature(args):
    return {"content": [{"type": "text", "text": "..."}]}
```

```typescript TypeScript theme={null}
import { tool } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

tool(
  "get_temperature",
  "Get the current temperature at a location",
  { latitude: z.number(), longitude: z.number() },
  async (args) => ({ content: [{ type: "text", text: `...` }] }),
  { annotations: { readOnlyHint: true } } // Lets Claude batch this with other read-only calls
);
```

[TypeScript](https://code.claude.com/docs/ko/agent-sdk/typescript.md#toolannotations) 또는 [Python](https://code.claude.com/docs/ko/agent-sdk/python.md#toolannotations) 참조에서 `ToolAnnotations`를 참조하세요.

## 도구 접근 제어

[날씨 도구 예제](#weather-tool-example)에서 등록한 서버는 `allowedTools`에 도구를 나열했습니다. 이 섹션에서는 여러 도구가 있거나 기본 제공 도구를 제한하려는 경우 접근 범위를 지정하는 방법을 다룹니다. 도구 이름이 구성되는 방식에 대해서는 [사용자 정의 도구 호출](#call-a-custom-tool)을 참조하십시오.

### 허용된 도구 구성

`tools` 옵션과 허용/거부 목록은 두 가지 계층에 영향을 미칩니다. 가용성은 Claude의 컨텍스트에 도구가 표시되는지 여부를 제어하고, 권한은 Claude가 호출을 시도한 후 호출이 승인되는지 여부를 제어합니다. `tools`와 단순 이름 `disallowedTools` 항목은 가용성을 변경합니다. `allowedTools`와 범위가 지정된 `disallowedTools` 규칙은 권한을 변경합니다. [작업 추적 도구](https://code.claude.com/docs/ko/agent-sdk/todo-tracking.md#model-availability) 중 하나를 `allowedTools`에 지정하면 Claude Code는 해당 세션에서 작업 추적 도구도 활성화합니다.

| 옵션 | 계층 | 효과 |
| :- | :- | :- |
| `tools: ["Read", "Grep"]` | 가용성 | 나열된 기본 제공 도구만 Claude의 컨텍스트에 있습니다. 나열되지 않은 기본 제공 도구는 제거됩니다. MCP 도구는 영향을 받지 않습니다. |
| `tools: []` | 가용성 | 모든 기본 제공 도구가 제거됩니다. Claude는 MCP 도구만 사용할 수 있습니다. |
| 허용된 도구 | 권한 | 나열된 도구는 권한 프롬프트 없이 실행됩니다. 다른 나열되지 않은 도구는 계속 사용 가능하며, 호출은 [권한 흐름](https://code.claude.com/docs/ko/agent-sdk/permissions.md)을 거칩니다. |
| 거부된 도구 | 둘 다 | `"Bash"`와 같은 단순 도구 이름은 도구를 Claude의 컨텍스트에서 제거하며, `tools`에서 생략하는 것과 동일합니다. `"Bash(rm *)"` 같은 범위가 지정된 규칙은 도구를 컨텍스트에 남겨두고 [작성된 대로](https://code.claude.com/docs/ko/permissions.md#bash-rule-limits) 일치하는 호출만 거부합니다. |

기본 제공 도구를 완전히 제거하려면 `tools`에서 생략하거나 `disallowedTools`(Python: `disallowed_tools`)에 단순 이름을 나열하십시오. 둘 다 도구를 컨텍스트 밖에 유지하므로 Claude는 절대 시도하지 않습니다. 범위가 지정된 `disallowedTools` 규칙은 일치하는 호출을 차단하지만 도구를 표시된 상태로 유지하므로 Claude가 시도하는 데 턴을 낭비할 수 있습니다. 전체 평가 순서는 [권한 구성](https://code.claude.com/docs/ko/agent-sdk/permissions.md)을 참조하십시오.

### 특정 도구에 승인 요구

도구의 `permission_policy`를 `always_ask`로 설정하면 `allowedTools`가 해당 도구의 호출을 더 이상 승인하지 않으므로, 도구가 목록에 있더라도 호출이 [`canUseTool`](https://code.claude.com/docs/ko/agent-sdk/user-input) 콜백에 도달할 수 있습니다. 대신 `always_deny`로 설정하면 [도구 호출이 거부](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)되지만, 로드한 플러그인의 [mod](https://code.claude.com/docs/ko/plugins/mods/overview.md)는 [여전히 호출을 승인할 수 있습니다](https://code.claude.com/docs/ko/permissions.md#precedence-among-rules-hooks-and-mods). 이 필드는 TypeScript 전용이며 Agent SDK v0.3.301 이상이 필요합니다.

정책 항목은 해당 함수에 전달하는 `tools` 옵션이 아니라, `createSdkMcpServer()`가 반환하는 구성 객체의 `tools` 배열에 넣으십시오. 이 예제는 [날씨 도구 예제](#weather-tool-example)의 `weatherServer`를 펼치고 `get_temperature`에 `always_ask` 정책을 부여하는 `tools` 배열을 추가합니다.

```typescript TypeScript theme={null}
options: {
  mcpServers: {
    weather: {
      ...weatherServer,
      tools: [{ name: "get_temperature", permission_policy: "always_ask" as const }]
    }
  },
  allowedTools: ["mcp__weather__get_temperature"],
  permissionMode: "default",
  canUseTool: async (toolName, input) => {
    console.log(`Approval requested for ${toolName}`);
    return { behavior: "allow", updatedInput: input };
  }
}
```

정책을 시험해 보려면 [사용자 정의 도구 호출](#call-a-custom-tool) 스크립트의 `options`를 이 예제의 `options`로 교체한 다음 터미널에서 해당 스크립트를 실행하십시오. 스크립트는 `Approval requested for mcp__weather__get_temperature`를 출력한 뒤 온도에 대한 Claude의 답변을 출력합니다. 전체 스크립트는 [TypeScript 레퍼런스](https://code.claude.com/docs/ko/agent-sdk/typescript.md#mcpsdkserverconfigwithinstance)를 참조하십시오.

`auto` 또는 `plan` [권한 모드](https://code.claude.com/docs/ko/agent-sdk/permissions.md#permission-modes)를 사용하는 경우, 도구 호출이 계속 콜백에 도달하도록 도구의 [어노테이션](#add-tool-annotations)에 `destructiveHint: true`를 설정하십시오. 그렇지 않으면 [자동 모드 분류기](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 [TypeScript 레퍼런스에 나열된 조건](https://code.claude.com/docs/ko/agent-sdk/typescript.md#permission-modes-that-can-approve-an-always_ask-call)에 따라 일부 `always_ask` 호출을 승인할 수 있으며, 분류기가 승인한 호출은 콜백에 도달하지 않습니다. 설정되지 않은 `destructiveHint`는 `always_ask` 호출에서 기본값 `true`가 아니라 `false`로 간주되므로 힌트를 명시적으로 설정하십시오.

## 오류 처리

핸들러 오류는 에이전트 루프를 중단하지 않습니다. SDK의 인프로세스 MCP 서버는 포착되지 않은 예외를 캐치하고 오류 결과로 반환하므로, 오류를 보고하는 방식이 Claude가 읽는 내용을 결정하며, 쿼리 실패 여부는 결정하지 않습니다.

| 발생하는 상황 | 결과 |
| :- | :- |
| 핸들러가 포착되지 않은 예외를 발생시킴 | MCP 서버는 이를 원본 예외 메시지를 포함하는 오류 결과로 변환합니다. Claude는 해당 메시지를 보고 에이전트 루프가 계속됩니다. |
| 핸들러가 오류를 캐치하고 `isError: true` (TS) / `"is_error": True` (Python)을 반환함 | Claude는 사용자가 작성한 메시지를 봅니다. 원본 예외가 부족한 컨텍스트(예: 어떤 요청이 실패했는지 또는 대신 시도할 사항)를 추가할 수 있습니다. |

두 경우 모두 Claude는 재시도하거나, 다른 도구를 시도하거나, 실패를 설명할 수 있습니다. 원본 예외 메시지가 Claude가 작용하기에 충분하지 않을 때 오류를 직접 캐치합니다.

아래 예제는 핸들러 내에서 두 가지 종류의 실패를 캐치하고 Claude가 읽는 오류 메시지를 작성합니다. 200이 아닌 HTTP 상태는 응답에서 캐치되어 오류 결과로 반환됩니다. 네트워크 오류 또는 잘못된 JSON은 주변 `try/except` (Python) 또는 `try/catch` (TypeScript)에 의해 캐치되어 오류 결과로도 반환됩니다. 두 경우 모두 Claude는 단순한 예외 문자열 대신 실패를 설명하는 메시지를 받습니다.

```python Python theme={null}
import json
import httpx
from typing import Any
from claude_agent_sdk import tool


@tool(
    "fetch_data",
    "Fetch data from an API",
    {"endpoint": str},  # Simple schema
)
async def fetch_data(args: dict[str, Any]) -> dict[str, Any]:
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(args["endpoint"])
            if response.status_code != 200:
                # Return the failure as a tool result so Claude can react to it.
                # is_error marks this as a failed call rather than odd-looking data.
                return {
                    "content": [
                        {
                            "type": "text",
                            "text": f"API error: {response.status_code} {response.reason_phrase}",
                        }
                    ],
                    "is_error": True,
                }

            data = response.json()
            return {"content": [{"type": "text", "text": json.dumps(data, indent=2)}]}
    except Exception as e:
        # Composes the message Claude reads. An uncaught exception would
        # reach Claude as the raw str(e) with no context.
        return {
            "content": [{"type": "text", "text": f"Failed to fetch data: {str(e)}"}],
            "is_error": True,
        }
```

```typescript TypeScript theme={null}
import { tool } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

tool(
  "fetch_data",
  "Fetch data from an API",
  {
    endpoint: z.string().url().describe("API endpoint URL")
  },
  async (args) => {
    try {
      const response = await fetch(args.endpoint);

      if (!response.ok) {
        // Return the failure as a tool result so Claude can react to it.
        // isError marks this as a failed call rather than odd-looking data.
        return {
          content: [
            {
              type: "text",
              text: `API error: ${response.status} ${response.statusText}`
            }
          ],
          isError: true
        };
      }

      const data = await response.json();
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(data, null, 2)
          }
        ]
      };
    } catch (error) {
      // Composes the message Claude reads. An uncaught throw would
      // reach Claude as the raw error message with no context.
      return {
        content: [
          {
            type: "text",
            text: `Failed to fetch data: ${error instanceof Error ? error.message : String(error)}`
          }
        ],
        isError: true
      };
    }
  }
);
```

## 이미지 및 리소스 반환

도구 결과의 `content` 배열은 `text`, `image`, `audio`, `resource`, `resource_link` 블록을 허용합니다. 동일한 응답에서 이들을 혼합할 수 있습니다. TypeScript에서 SDK는 오디오 블록을 디스크에 저장하고 Claude는 저장된 파일 경로가 포함된 텍스트 블록을 수신합니다. Python에서는 SDK가 도구 결과에서 오디오 블록을 제거하고 경고를 기록합니다.

Claude는 각 리소스 링크 블록을 링크의 이름, URI, 설명이 포함된 텍스트 블록으로 수신합니다. TypeScript에서 애플리케이션은 사용자 메시지의 `tool_use_result`에서 [`resourceLinks`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkmcpresourcelink)로 링크 자체를 수신합니다. Python에서는 SDK가 CLI에서 결과를 보기 전에 이들을 텍스트로 평탄화하므로, Python [`resourceLinks` 키](https://code.claude.com/docs/ko/agent-sdk/python#usermessage)는 프로세스 내 도구에 대해 생성되지 않습니다.

### 이미지

이미지 블록은 이미지 바이트를 인라인으로 base64로 인코딩하여 전달합니다. URL 필드는 없습니다. URL에 있는 이미지를 반환하려면 핸들러에서 이를 가져오고, 응답 바이트를 읽은 후 base64로 인코딩하여 반환합니다. PNG, JPEG, GIF 또는 WebP 이미지는 Claude에 시각적 입력으로 도달합니다. 다른 유형의 이미지는 디스크에 저장되고 Claude는 파일 경로를 텍스트로 수신합니다.

| 필드 | 유형 | 참고 |
| :- | :- | :- |
| `type` | `"image"` | |
| `data` | `string` | Base64로 인코딩된 바이트입니다. 원본 base64만 해당하며, `data:image/...;base64,` 접두사는 없습니다 |
| `mimeType` | `string` | 필수입니다. 예: `image/png`, `image/jpeg`, `image/webp`, `image/gif` |

```python Python theme={null}
import base64
import httpx
from claude_agent_sdk import tool


# URL에서 이미지를 가져와 Claude에 반환하는 도구를 정의합니다
@tool("fetch_image", "Fetch an image from a URL and return it to Claude", {"url": str})
async def fetch_image(args):
    async with httpx.AsyncClient() as client:  # 이미지 바이트를 가져옵니다
        response = await client.get(args["url"])

    return {
        "content": [
            {
                "type": "image",
                "data": base64.b64encode(response.content).decode(
                    "ascii"
                ),  # 원본 바이트를 base64로 인코딩합니다
                "mimeType": response.headers.get(
                    "content-type", "image/png"
                ),  # 응답에서 MIME 유형을 읽습니다
            }
        ]
    }
```

```typescript TypeScript theme={null}
import { tool } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

tool(
  "fetch_image",
  "Fetch an image from a URL and return it to Claude",
  {
    url: z.string().url()
  },
  async (args) => {
    const response = await fetch(args.url); // 이미지 바이트를 가져옵니다
    const buffer = Buffer.from(await response.arrayBuffer()); // base64 인코딩을 위해 버퍼로 읽습니다
    const mimeType = response.headers.get("content-type") ?? "image/png";

    return {
      content: [
        {
          type: "image",
          data: buffer.toString("base64"), // 원본 바이트를 base64로 인코딩합니다
          mimeType
        }
      ]
    };
  }
);
```

### 리소스

리소스 블록은 URI로 식별되는 콘텐츠를 포함합니다. 실제 콘텐츠는 블록의 `text` 또는 `blob` 필드에 있습니다. 도구가 생성된 파일이나 외부 시스템의 레코드를 생성할 때 이를 사용합니다.

| 필드 | 유형 | 참고 |
| :- | :- | :- |
| `type` | `"resource"` | |
| `resource.uri` | `string` | 콘텐츠의 식별자입니다. 모든 URI 스키마 |
| `resource.text` | `string` | 텍스트인 경우 콘텐츠입니다. 이것 또는 `blob`을 제공하되, 둘 다 제공하지는 마십시오 |
| `resource.blob` | `string` | 바이너리인 경우 base64로 인코딩된 콘텐츠입니다. TypeScript만 해당: Python SDK는 도구 결과에서 바이너리 리소스를 제거하고 경고를 기록합니다 |
| `resource.mimeType` | `string` | 선택사항 |

이 예제는 도구 핸들러 내부에서 반환된 리소스 블록을 보여줍니다. SDK는 예제의 URI인 `file:///tmp/report.md`에서 읽지 않습니다.

```typescript TypeScript theme={null}
return {
  content: [
    {
      type: "resource",
      resource: {
        uri: "file:///tmp/report.md", // Claude가 참조할 수 있는 레이블이며, SDK가 읽는 경로가 아닙니다
        mimeType: "text/markdown",
        text: "# Report\n..." // 실제 콘텐츠이며, 인라인입니다
      }
    }
  ]
};
```

```python Python theme={null}
return {
    "content": [
        {
            "type": "resource",
            "resource": {
                "uri": "file:///tmp/report.md",  # SDK가 읽는 경로가 아닙니다
                "mimeType": "text/markdown",
                "text": "# Report\n...",  # 실제 콘텐츠이며, 인라인입니다
            },
        }
    ]
}
```

이러한 블록 형태는 MCP `CallToolResult` 유형에서 나옵니다. 전체 정의는 [MCP 사양](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#tool-result)을 참조하십시오.

## 구조화된 데이터 반환

`structuredContent`는 결과의 선택적 JSON 객체로, `content` 배열과 별도입니다. Claude가 텍스트 문자열이나 이미지에서 구문 분석하는 대신 정확한 필드로 읽을 수 있는 원본 값을 반환하는 데 사용합니다.

`structuredContent`가 설정되면 Claude는 JSON과 `content`의 모든 이미지 또는 리소스 블록을 수신합니다. `content`의 텍스트 블록은 구조화된 데이터를 복제한다고 가정하므로 전달되지 않습니다. 아래 예제는 차트를 이미지 블록으로 렌더링하고 동일한 핸들러의 `structuredContent`에서 뒤에 있는 데이터 포인트를 반환합니다. 스니펫에서 `chartPngBuffer`는 렌더링된 PNG 바이트를 보유하는 `Buffer`입니다.

```typescript TypeScript theme={null}
return {
  content: [
    {
      type: "image",
      data: chartPngBuffer.toString("base64"),
      mimeType: "image/png"
    }
  ],
  structuredContent: {
    series: "temperature_2m",
    unit: "fahrenheit",
    points: [62.1, 63.4, 65.0, 64.2]
  }
};
```

> [!NOTE]
>
> Python `@tool` 데코레이터는 핸들러의 반환 딕셔너리에서 `content`와 `is_error`만 전달합니다. Python에서 `structuredContent`를 반환하려면 in-process SDK 서버 대신 [독립형 MCP 서버](https://code.claude.com/docs/ko/agent-sdk/mcp.md)를 실행합니다.

## 예제: 단위 변환기

이 도구는 길이, 온도, 무게 단위 간의 값을 변환합니다. 사용자가 "100킬로미터를 마일로 변환해줘" 또는 "72°F는 섭씨온도로 몇 도야?"라고 물어보면, Claude가 요청에서 올바른 단위 유형과 단위를 선택합니다.

두 가지 패턴을 보여줍니다:

* **Enum 스키마:** `unit_type`은 고정된 값 집합으로 제한됩니다. TypeScript에서는 `z.enum()`을 사용합니다. Python에서는 dict 스키마가 enum을 지원하지 않으므로 전체 JSON Schema dict가 필요합니다.
* **지원되지 않는 입력 처리:** 변환 쌍을 찾을 수 없을 때, 핸들러는 `isError: true`를 반환하므로 Claude가 실패를 일반적인 결과로 취급하는 대신 사용자에게 무엇이 잘못되었는지 알려줄 수 있습니다.

```python Python theme={null}
from typing import Any
from claude_agent_sdk import tool, create_sdk_mcp_server


# z.enum() in TypeScript becomes an "enum" constraint in JSON Schema.
# The dict schema has no equivalent, so full JSON Schema is required.
@tool(
    "convert_units",
    "Convert a value from one unit to another",
    {
        "type": "object",
        "properties": {
            "unit_type": {
                "type": "string",
                "enum": ["length", "temperature", "weight"],
                "description": "Category of unit",
            },
            "from_unit": {
                "type": "string",
                "description": "Unit to convert from, e.g. kilometers, fahrenheit, pounds",
            },
            "to_unit": {"type": "string", "description": "Unit to convert to"},
            "value": {"type": "number", "description": "Value to convert"},
        },
        "required": ["unit_type", "from_unit", "to_unit", "value"],
    },
)
async def convert_units(args: dict[str, Any]) -> dict[str, Any]:
    conversions = {
        "length": {
            "kilometers_to_miles": lambda v: v * 0.621371,
            "miles_to_kilometers": lambda v: v * 1.60934,
            "meters_to_feet": lambda v: v * 3.28084,
            "feet_to_meters": lambda v: v * 0.3048,
        },
        "temperature": {
            "celsius_to_fahrenheit": lambda v: (v * 9) / 5 + 32,
            "fahrenheit_to_celsius": lambda v: (v - 32) * 5 / 9,
            "celsius_to_kelvin": lambda v: v + 273.15,
            "kelvin_to_celsius": lambda v: v - 273.15,
        },
        "weight": {
            "kilograms_to_pounds": lambda v: v * 2.20462,
            "pounds_to_kilograms": lambda v: v * 0.453592,
            "grams_to_ounces": lambda v: v * 0.035274,
            "ounces_to_grams": lambda v: v * 28.3495,
        },
    }

    key = f"{args['from_unit']}_to_{args['to_unit']}"
    fn = conversions.get(args["unit_type"], {}).get(key)

    if not fn:
        return {
            "content": [
                {
                    "type": "text",
                    "text": f"Unsupported conversion: {args['from_unit']} to {args['to_unit']}",
                }
            ],
            "is_error": True,
        }

    result = fn(args["value"])
    return {
        "content": [
            {
                "type": "text",
                "text": f"{args['value']} {args['from_unit']} = {result:.4f} {args['to_unit']}",
            }
        ]
    }


converter_server = create_sdk_mcp_server(
    name="converter",
    version="1.0.0",
    tools=[convert_units],
)
```

```typescript TypeScript theme={null}
import { tool, createSdkMcpServer } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

const convert = tool(
  "convert_units",
  "Convert a value from one unit to another",
  {
    unit_type: z.enum(["length", "temperature", "weight"]).describe("Category of unit"),
    from_unit: z
      .string()
      .describe("Unit to convert from, e.g. kilometers, fahrenheit, pounds"),
    to_unit: z.string().describe("Unit to convert to"),
    value: z.number().describe("Value to convert")
  },
  async (args) => {
    type Conversions = Record<string, Record<string, (v: number) => number>>;

    const conversions: Conversions = {
      length: {
        kilometers_to_miles: (v) => v * 0.621371,
        miles_to_kilometers: (v) => v * 1.60934,
        meters_to_feet: (v) => v * 3.28084,
        feet_to_meters: (v) => v * 0.3048
      },
      temperature: {
        celsius_to_fahrenheit: (v) => (v * 9) / 5 + 32,
        fahrenheit_to_celsius: (v) => ((v - 32) * 5) / 9,
        celsius_to_kelvin: (v) => v + 273.15,
        kelvin_to_celsius: (v) => v - 273.15
      },
      weight: {
        kilograms_to_pounds: (v) => v * 2.20462,
        pounds_to_kilograms: (v) => v * 0.453592,
        grams_to_ounces: (v) => v * 0.035274,
        ounces_to_grams: (v) => v * 28.3495
      }
    };

    const key = `${args.from_unit}_to_${args.to_unit}`;
    const fn = conversions[args.unit_type]?.[key];

    if (!fn) {
      return {
        content: [
          {
            type: "text",
            text: `Unsupported conversion: ${args.from_unit} to ${args.to_unit}`
          }
        ],
        isError: true
      };
    }

    const result = fn(args.value);
    return {
      content: [
        {
          type: "text",
          text: `${args.value} ${args.from_unit} = ${result.toFixed(4)} ${args.to_unit}`
        }
      ]
    };
  }
);

const converterServer = createSdkMcpServer({
  name: "converter",
  version: "1.0.0",
  tools: [convert]
});
```

서버가 정의되면, 날씨 예제와 동일한 방식으로 `query`에 전달합니다. 이 예제는 동일한 도구가 다양한 단위 유형을 처리하는 것을 보여주기 위해 루프에서 세 가지 다른 프롬프트를 보냅니다. 각 응답에 대해 `AssistantMessage` 객체(Claude가 해당 턴 동안 수행한 도구 호출을 포함)를 검사하고 최종 `ResultMessage` 텍스트를 출력하기 전에 각 `ToolUseBlock`을 출력합니다. 이를 통해 Claude가 도구를 사용하는 시점과 자체 지식에서 답변하는 시점을 볼 수 있습니다.

[도구 검색](https://code.claude.com/docs/ko/agent-sdk/tool-search.md)이 기본적으로 활성화되어 있으므로, 출력에는 Claude가 지연된 도구 스키마를 로드할 때 `ToolSearch` 호출도 포함될 수 있습니다.

```python Python theme={null}
import asyncio
from claude_agent_sdk import (
    query,
    ClaudeAgentOptions,
    ResultMessage,
    AssistantMessage,
    ToolUseBlock,
)


async def main():
    options = ClaudeAgentOptions(
        mcp_servers={"converter": converter_server},
        allowed_tools=["mcp__converter__convert_units"],
    )

    prompts = [
        "Convert 100 kilometers to miles.",
        "What is 72°F in Celsius?",
        "How many pounds is 5 kilograms?",
    ]

    for prompt in prompts:
        try:
            async for message in query(prompt=prompt, options=options):
                if isinstance(message, AssistantMessage):
                    for block in message.content:
                        if isinstance(block, ToolUseBlock):
                            print(f"[tool call] {block.name}({block.input})")
                elif isinstance(message, ResultMessage) and message.subtype == "success":
                    print(f"Q: {prompt}\nA: {message.result}\n")
        except Exception as error:
            # A single-shot query() raises after yielding an error result. Only success
            # results are printed above, so handle the failure here and continue with
            # the next prompt.
            print(f"Call failed: {error}")


asyncio.run(main())
```

```typescript TypeScript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

const prompts = [
  "Convert 100 kilometers to miles.",
  "What is 72°F in Celsius?",
  "How many pounds is 5 kilograms?"
];

for (const prompt of prompts) {
  try {
    for await (const message of query({
      prompt,
      options: {
        mcpServers: { converter: converterServer },
        allowedTools: ["mcp__converter__convert_units"]
      }
    })) {
      if (message.type === "assistant") {
        for (const block of message.message.content) {
          if (block.type === "tool_use") {
            console.log(`[tool call] ${block.name}`, block.input);
          }
        }
      } else if (message.type === "result" && message.subtype === "success") {
        console.log(`Q: ${prompt}\nA: ${message.result}\n`);
      }
    }
  } catch (error) {
    // A single-shot query() throws after yielding an error result. Only success
    // results are logged above, so handle the failure here and continue with
    // the next prompt.
    console.error(`Call failed: ${error}`);
  }
}
```

## 다음 단계

이 페이지의 패턴들을 동일한 서버에서 혼합할 수 있습니다. 단일 서버는 데이터베이스 도구, API 게이트웨이 도구, 이미지 렌더러를 함께 보유할 수 있습니다.

여기서:

* 서버가 수십 개의 도구로 확장되는 경우, [도구 검색](https://code.claude.com/docs/ko/agent-sdk/tool-search.md)을 참조하여 Claude가 필요할 때까지 로드를 연기합니다.
* 자신의 서버를 구축하는 대신 외부 MCP 서버(파일시스템, GitHub, Slack)에 연결하려면, [MCP 서버 연결](https://code.claude.com/docs/ko/agent-sdk/mcp.md)을 참조합니다.
* 어떤 도구가 자동으로 실행되는지 또는 승인이 필요한지를 제어하려면, [권한 구성](https://code.claude.com/docs/ko/agent-sdk/permissions.md)을 참조합니다.
