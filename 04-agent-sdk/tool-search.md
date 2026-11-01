> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 많은 도구로 확장하기 - 도구 검색

> 수백 개 또는 수천 개의 도구로 에이전트를 확장하고, 필요한 것만 동적으로 발견하여 로드합니다.

도구 검색을 통해 에이전트는 수백 개 또는 수천 개의 도구로 작업할 수 있으며, 필요에 따라 동적으로 도구를 발견하고 로드합니다. 모든 도구 정의를 미리 컨텍스트 윈도우에 로드하는 대신, 에이전트가 도구 카탈로그를 검색하고 필요한 도구만 로드합니다.

이 접근 방식은 도구 라이브러리가 확장될 때 두 가지 문제를 해결합니다:

* **컨텍스트 효율성:** 도구 정의는 컨텍스트 윈도우의 큰 부분을 차지할 수 있습니다(50개의 도구는 10-20K 토큰을 사용할 수 있음). 이로 인해 실제 작업을 위한 공간이 줄어듭니다.
* **도구 선택 정확도:** 30-50개 이상의 도구가 동시에 로드되면 도구 선택 정확도가 저하됩니다.

## 도구 검색의 작동 방식

도구 검색이 기본적으로 활성화되어 있으며, [도구 검색 구성](#configure-tool-search)에 나열된 예외가 있습니다.

활성화되면 도구 정의는 컨텍스트 윈도우에서 제외됩니다. 에이전트는 사용 가능한 도구의 요약을 받고, 작업에 이미 로드되지 않은 기능이 필요할 때 관련 도구를 검색합니다. 가장 관련성이 높은 최대 5개의 도구가 기본적으로 컨텍스트에 로드되며, SDK가 에이전트가 도구를 발견한 메시지를 압축할 때까지 이후 턴에서도 계속 사용할 수 있습니다. 그 압축 이후에는 에이전트가 필요할 때 해당 도구를 다시 검색합니다.

도구 검색은 Claude가 도구를 검색할 때마다 한 번의 추가 왕복을 추가하지만, 큰 도구 세트의 경우 모든 턴에서 더 작은 컨텍스트로 인한 이점이 있습니다. 컨텍스트 윈도우에 편하게 맞는 약 10개 미만의 도구가 있는 경우, 모든 것을 미리 로드하는 것이 일반적으로 더 빠릅니다.

기본 API 메커니즘에 대한 자세한 내용은 [API의 도구 검색](https://platform.claude.com/docs/ko/agents-and-tools/tool-use/tool-search-tool)을 참조하십시오.

> [!NOTE]
>
> 도구 검색은 Microsoft Foundry [Azure에서 호스팅되는 배포](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)에서 지원되지 않으며, 서버 측에서 거부합니다. SDK는 거부를 감지하고 해당 배포에 대해 대신 도구 정의를 미리 로드합니다. [`ENABLE_TOOL_SEARCH`](#configure-tool-search)는 배포 자체에서 거부가 발생하므로 이를 재정의할 수 없습니다.

## 도구 검색 구성

도구 검색은 기본적으로 켜져 있습니다. SDK의 지원되지 않는 모델 목록에 있는 모델의 경우 SDK는 도구 정의를 미리 로드하며, `ENABLE_TOOL_SEARCH` 값이 이를 재정의할 수 없습니다. Google Cloud의 Agent Platform에서는 SDK가 모델 세대에 따라 결정합니다:

* **Claude Opus 4.5, Sonnet 4.5, Haiku 4.5 및 이후 버전**: 도구 검색이 기본적으로 켜져 있습니다.
* **이전 Agent Platform 모델**: SDK는 도구 정의를 미리 로드합니다. 필요한 베타 헤더를 거부하는 서빙 스택이 있기 때문입니다. `ENABLE_TOOL_SEARCH`는 이를 재정의할 수 없습니다.

Claude Code v2.1.221 이전에는 `ENABLE_TOOL_SEARCH`를 설정하지 않으면 SDK가 Google Cloud의 Agent Platform의 모든 모델에 대해 도구 검색을 비활성화했습니다.

> [!NOTE]
>
> `ANTHROPIC_BASE_URL` 게이트웨이 뒤에서도 별도로 설정할 필요 없이 도구 검색이 기본적으로 켜져 있습니다. 게이트웨이가 이를 거부하는 경우 [LLM 게이트웨이를 통한 도구 검색](https://code.claude.com/docs/ko/mcp.md#tool-search-through-a-gateway)을 참조하세요. Claude Code v2.1.304 이전에는 `ENABLE_TOOL_SEARCH`가 `true`, `auto` 또는 `auto:N`이 아니면 SDK가 이러한 게이트웨이 뒤에서 도구 검색을 비활성화했습니다.

도구 정의를 지연할지 여부와 시점은 `ENABLE_TOOL_SEARCH` 환경 변수로 제어하며, 이 변수는 다음 값을 사용합니다:

| 값 | 동작 |
| :- | :- |
| (설정 안 함) | 도구 검색이 켜져 있습니다. 도구 정의는 지연되고 필요에 따라 발견됩니다. Opus 4 및 Sonnet 4보다 이전 모델, [이전 Agent Platform 모델](#configure-tool-search), 그리고 Azure에서 호스팅되는 Microsoft Foundry 배포에서는 미리 로드로 폴백됩니다. |
| `true` | 도구 검색이 켜져 있으며, (설정 안 함)과 동일한 폴백이 적용됩니다. |
| `auto` | 도구 검색이 연기할 수 있는 정의가 모델 컨텍스트 윈도우의 10%에 도달할 때까지는 도구 검색이 꺼져 있으며 도구 정의가 미리 로드됩니다. 그 후 도구 검색이 활성화되며, 이후 해당 정의가 10% 아래로 떨어지더라도 [같은 대화에서 켜진 상태로 유지](https://code.claude.com/docs/ko/mcp.md#tools-that-stay-deferred-below-the-threshold)될 수 있습니다. |
| `auto:N` | `auto`와 동일하지만 사용자 정의 백분율입니다. `auto:5`는 해당 정의가 컨텍스트 윈도우의 5%에 도달할 때 활성화됩니다. 낮은 값은 더 빨리 활성화됩니다. |
| `false` | 도구 검색이 꺼져 있습니다. 모든 도구 정의는 매 턴마다 컨텍스트에 로드됩니다. |

[`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS`](https://code.claude.com/docs/ko/env-vars) 설정은 도구 검색을 끕니다. `ENABLE_TOOL_SEARCH`를 직접 설정하여 이를 재정의할 수 없습니다. 조직은 Claude Code v2.1.227 이상에서 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 통해 이 변수가 설정된 상태에서도 도구 검색을 켜진 상태로 유지할 수 있습니다. [HIPAA 구성을 받는](https://code.claude.com/docs/ko/hipaa-setup.md#check-how-developers-sign-in-and-connect) 세션에서는 도구 검색이 꺼지며, `ENABLE_TOOL_SEARCH`와 관리형 설정 모두 이를 다시 켤 수 없습니다. [사전 릴리스 기능 비활성화](https://code.claude.com/docs/ko/llm-gateway-protocol.md#disable-pre-release-capabilities)는 재정의가 적용되는 위치와 변수가 제거하는 항목을 다룹니다.

도구 검색은 원격 MCP 서버에서 오든 [사용자 정의 SDK MCP 서버](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md)에서 오든 모든 등록된 도구에 적용됩니다. `auto`를 사용할 때 SDK는 도구 검색이 연기할 수 있는 모든 정의를 하나의 결합된 임계값으로 계산합니다: [`alwaysLoad`](https://code.claude.com/docs/ko/mcp#exempt-a-server-from-deferral)로 표시되지 않은 모든 MCP 도구(모든 서버에서), 그리고 필요에 따라 로드되는 기본 제공 도구입니다. SDK는 Bash, Read, Edit과 같은 핵심 기본 제공 도구를 미리 로드하고 임계값에 계산하지 않습니다. 플러그인 중 하나에 포함된 [mod](https://code.claude.com/docs/ko/plugins/mods/reference.md#tools)도 도구를 연기하거나 미리 로드할 수 있으며, 이에 따라 해당 계산이 달라집니다.

`query()`의 `env` 옵션에서 값을 설정합니다. TypeScript에서 `env`는 서브프로세스 환경을 대체하므로 상속된 변수를 유지하려면 `...process.env`를 전개합니다. Python에서 `env`는 상속된 환경 위에 병합됩니다. 이 예제는 많은 도구를 노출하는 원격 MCP 서버에 연결하고, 와일드카드로 모두 사전 승인하며, 도구 검색이 연기할 수 있는 정의가 컨텍스트 윈도우의 5%에 도달할 때 도구 검색이 활성화되도록 `auto:5`를 사용합니다:

```typescript TypeScript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

try {
  for await (const message of query({
    prompt: "Find and run the appropriate database query",
    options: {
      mcpServers: {
        "enterprise-tools": {
          // Connect to a remote MCP server
          type: "http",
          url: "https://tools.example.com/mcp"
        }
      },
      allowedTools: ["mcp__enterprise-tools__*"], // Wildcard pre-approves all tools from this server
      env: {
        ...process.env, // env replaces the subprocess environment, so keep inherited variables
        ENABLE_TOOL_SEARCH: "auto:5" // Activate tool search when deferrable definitions reach 5% of context
      }
    }
  })) {
    if (message.type === "result" && message.subtype === "success") {
      console.log(message.result);
    }
  }
} catch (error) {
  // A single-shot query() throws after yielding an error result
  console.log(`Session ended with an error: ${error}`);
}
```

```python Python theme={null}
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage


async def main():
    options = ClaudeAgentOptions(
        mcp_servers={
            "enterprise-tools": {
                "type": "http",
                "url": "https://tools.example.com/mcp",
            }
        },
        allowed_tools=[
            "mcp__enterprise-tools__*"
        ],  # Wildcard pre-approves all tools from this server
        env={
            "ENABLE_TOOL_SEARCH": "auto:5"  # Activate tool search when deferrable definitions reach 5% of context
        },
    )

    try:
        async for message in query(
            prompt="Find and run the appropriate database query",
            options=options,
        ):
            if isinstance(message, ResultMessage) and message.subtype == "success":
                print(message.result)
    except Exception as error:
        # A single-shot query() raises after yielding an error result
        print(f"Session ended with an error: {error}")


asyncio.run(main())
```

이 예제를 실행하려면 `https://tools.example.com/mcp`를 자신의 MCP 서버 URL로 바꿉니다. 성공하면 결과 텍스트가 콘솔에 출력됩니다.

이것이 단일 `query()` 호출이므로 SDK는 오류 결과를 생성한 후 발생시키므로 예제는 루프를 try 블록으로 래핑합니다. 실행이 실패한 이유를 확인하려면 루프 내에서 결과 메시지의 `subtype`(예: `error_during_execution`)을 확인합니다. 결과 메시지에 대한 자세한 내용은 [결과 처리](https://code.claude.com/docs/ko/agent-sdk/agent-loop.md#handle-the-result)를 참조하세요.

## 도구 발견 최적화

검색 메커니즘은 도구 이름과 설명에 대해 쿼리를 일치시킵니다. `search_slack_messages`와 같은 이름은 `query_slack`보다 더 넓은 범위의 요청에 대해 표시됩니다. 특정 키워드가 있는 설명("키워드, 채널 또는 날짜 범위별로 Slack 메시지 검색")은 일반적인 설명("Slack 쿼리")보다 더 많은 쿼리와 일치합니다.

사용 가능한 도구 카테고리를 나열하는 시스템 프롬프트 섹션을 추가할 수도 있습니다. 이는 에이전트에게 검색할 수 있는 도구의 종류에 대한 컨텍스트를 제공합니다. TypeScript에서는 `query()`의 `systemPrompt` 옵션을 통해, Python에서는 `system_prompt`를 통해 텍스트를 전달합니다. `claude_code` 프리셋과 함께 `append`를 사용하여 프리셋의 프롬프트에 텍스트를 추가합니다(대체하지 않음):

```typescript TypeScript theme={null}
options: {
  systemPrompt: {
    type: "preset",
    preset: "claude_code",
    append: "You can search for tools to interact with Slack, GitHub, and Jira."
  }
}
```

```python Python theme={null}
options = ClaudeAgentOptions(
    system_prompt={
        "type": "preset",
        "preset": "claude_code",
        "append": "You can search for tools to interact with Slack, GitHub, and Jira.",
    }
)
```

전체 시스템 프롬프트 옵션 세트는 [시스템 프롬프트 수정](https://code.claude.com/docs/ko/agent-sdk/modifying-system-prompts.md)을 참조하십시오.

## 제한 사항

* **최대 도구:** 카탈로그에 10,000개의 도구
* **검색 결과:** 기본적으로 검색당 가장 관련성이 높은 5개의 도구 반환
* **모델 지원:** Opus 4, Sonnet 4, Haiku 4.5 및 이후 모델, 또는 Google Cloud의 Agent Platform에서는 Opus 4.5, Sonnet 4.5, Haiku 4.5 및 이후 모델. 이전 모델에서는 [도구 검색 구성](#configure-tool-search)에서 설명하는 것처럼 SDK가 도구 정의를 미리 로드합니다.

## 관련 문서

* [API의 도구 검색](https://platform.claude.com/docs/ko/agents-and-tools/tool-use/tool-search-tool): 사용자 정의 구현을 포함한 도구 검색의 전체 API 문서
* [MCP 서버 연결](https://code.claude.com/docs/ko/agent-sdk/mcp.md): MCP 서버를 통해 외부 도구에 연결
* [사용자 정의 도구](https://code.claude.com/docs/ko/agent-sdk/custom-tools.md): SDK MCP 서버로 자신의 도구 구축
* [TypeScript SDK 참조](https://code.claude.com/docs/ko/agent-sdk/typescript.md): 전체 API 참조
* [Python SDK 참조](https://code.claude.com/docs/ko/agent-sdk/python.md): 전체 API 참조
