> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# SDK의 슬래시 명령어

> SDK를 통해 Claude Code 세션을 제어하기 위해 슬래시 명령어를 사용하는 방법을 알아봅니다

슬래시 명령어는 `/`로 시작하는 특수 명령어를 사용하여 Claude Code 세션을 제어하는 방법을 제공합니다. 이러한 명령어는 SDK를 통해 전송되어 컨텍스트 압축, 컨텍스트 사용량 나열 또는 사용자 정의 명령어 호출과 같은 작업을 수행할 수 있습니다. 대화형 터미널 없이 작동하는 명령어만 SDK를 통해 전달할 수 있으며, `system/init` 메시지에 세션에서 사용 가능한 명령어가 나열됩니다.

<h2 id="discovering-available-slash-commands">
  사용 가능한 슬래시 명령어 발견
</h2>

Claude Agent SDK는 시스템 초기화 메시지에서 사용 가능한 슬래시 명령어에 대한 정보를 제공합니다. 세션이 시작될 때 이 정보에 접근합니다:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  for await (const message of query({
    prompt: "Hello Claude",
    options: { maxTurns: 1 }
  })) {
    if (message.type === "system" && message.subtype === "init") {
      console.log("Available slash commands:", message.slash_commands);
      // Includes built-in commands plus bundled skills, for example:
      // ["clear", "compact", "context", "usage", "code-review", "verify", ...]
    }
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions, SystemMessage


  async def main():
      async for message in query(prompt="Hello Claude", options=ClaudeAgentOptions(max_turns=1)):
          if isinstance(message, SystemMessage) and message.subtype == "init":
              print("Available slash commands:", message.data["slash_commands"])
              # Includes built-in commands plus bundled skills, for example:
              # ["clear", "compact", "context", "usage", "code-review", "verify", ...]


  asyncio.run(main())
  ```
</CodeGroup>

<h2 id="sending-slash-commands">
  슬래시 명령어 전송
</h2>

슬래시 명령어를 프롬프트 문자열에 포함하여 일반 텍스트처럼 전송합니다. `/compact`와 같이 대화 기록에 작용하는 명령어는 작업할 이전 메시지가 필요하므로, 아래 예제에서는 먼저 질문을 한 다음 같은 대화에 대한 후속 명령어로 명령어를 전송합니다:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  // Build up conversation history first
  try {
    for await (const message of query({
      prompt: "What does the README in this directory cover?",
      options: { maxTurns: 2 }
    })) {
      if (message.type === "result" && message.subtype === "success") {
        console.log(message.result);
      }
    }
  } catch (error) {
    // A single-shot query() throws after yielding an error result,
    // so the follow-up query below still runs.
    console.error(`Session ended with an error: ${error}`);
  }

  // Send a slash command as a follow-up to the same conversation
  for await (const message of query({
    prompt: "/compact",
    options: { continue: true, maxTurns: 1 }
  })) {
    if (message.type === "result") {
      console.log("Command executed, result subtype:", message.subtype);
      // Example output: Command executed, result subtype: success
    }
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage


  async def main():
      # Build up conversation history first
      try:
          async for message in query(
              prompt="What does the README in this directory cover?",
              options=ClaudeAgentOptions(max_turns=2),
          ):
              if isinstance(message, ResultMessage) and message.subtype == "success":
                  print(message.result)
      except Exception as error:
          # A single-shot query() raises after yielding an error result,
          # so the follow-up query below still runs.
          print(f"Session ended with an error: {error}")

      # Send a slash command as a follow-up to the same conversation
      async for message in query(
          prompt="/compact",
          options=ClaudeAgentOptions(continue_conversation=True, max_turns=1),
      ):
          if isinstance(message, ResultMessage):
              print("Command executed, result subtype:", message.subtype)
              # Example output: Command executed, result subtype: success


  asyncio.run(main())
  ```
</CodeGroup>

<Note>
  쿼리는 오류 결과로 끝날 수 있습니다. 예를 들어 작업이 완료되기 전에 `maxTurns` / `max_turns` 제한에 도달한 경우입니다. 최종 결과 메시지는 `is_error: true`를 가지며 `success` 대신 `error_max_turns`와 같은 오류 서브타입을 가집니다.

  해당 최종 결과 메시지를 생성한 후 SDK는 CLI 프로세스가 0이 아닌 코드로 종료되기 때문에 오류를 발생시킵니다.

  명령어가 제한에 도달할 수 있는 경우 TypeScript에서는 루프를 `try`/`catch`로 감싸거나 Python에서는 `try`/`except`로 감싸십시오. [단일 메시지 입력](/docs/ko/agent-sdk/streaming-vs-single-mode#single-message-input)에 표시된 대로 하거나, 작업이 완료될 수 있도록 `maxTurns`를 충분히 높게 설정하십시오. Python에서는 `Exception`을 캐치하십시오: SDK는 오류 결과를 일반 `Exception`으로 표시합니다.
</Note>

<h2 id="common-slash-commands">
  일반적인 슬래시 명령어
</h2>

<h3 id="/compact-compact-conversation-history">
  `/compact` - 대화 기록 압축
</h3>

`/compact` 명령어는 이전 메시지를 요약하면서 중요한 컨텍스트를 보존하여 대화 기록의 크기를 줄입니다. 압축을 수행하려면 최소 두 번의 이전 교환이 있는 기존 대화가 필요합니다. 이 예제는 먼저 대화를 진행한 후 압축을 수행하고 결과를 보고하는 `compact_boundary` 시스템 메시지를 읽습니다:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  // Compaction needs existing history, so have a conversation first
  try {
    for await (const message of query({
      prompt: "Explain what this project does",
      options: { maxTurns: 2 }
    })) {
      if (message.type === "result" && message.subtype === "success") {
        console.log(message.result);
      }
    }
  } catch (error) {
    // A single-shot query() throws after yielding an error result,
    // so the follow-up query below still runs.
    console.error(`Session ended with an error: ${error}`);
  }

  // Compact the same conversation
  for await (const message of query({
    prompt: "/compact",
    options: { continue: true, maxTurns: 1 }
  })) {
    if (message.type === "system" && message.subtype === "compact_boundary") {
      console.log("Compaction completed");
      console.log("Pre-compaction tokens:", message.compact_metadata.pre_tokens);
      console.log("Trigger:", message.compact_metadata.trigger);
      // Example output:
      // Compaction completed
      // Pre-compaction tokens: 1842
      // Trigger: manual
    }
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage, SystemMessage


  async def main():
      # Compaction needs existing history, so have a conversation first
      try:
          async for message in query(
              prompt="Explain what this project does",
              options=ClaudeAgentOptions(max_turns=2),
          ):
              if isinstance(message, ResultMessage) and message.subtype == "success":
                  print(message.result)
      except Exception as error:
          # A single-shot query() raises after yielding an error result,
          # so the follow-up query below still runs.
          print(f"Session ended with an error: {error}")

      # Compact the same conversation
      async for message in query(
          prompt="/compact",
          options=ClaudeAgentOptions(continue_conversation=True, max_turns=1),
      ):
          if isinstance(message, SystemMessage) and message.subtype == "compact_boundary":
              print("Compaction completed")
              print("Pre-compaction tokens:", message.data["compact_metadata"]["pre_tokens"])
              print("Trigger:", message.data["compact_metadata"]["trigger"])
              # Example output:
              # Compaction completed
              # Pre-compaction tokens: 1842
              # Trigger: manual


  asyncio.run(main())
  ```
</CodeGroup>

<Note>
  `compact_boundary` 메시지는 압축이 실행되었을 때만 도착합니다. 요약할 내용이 없으면 `/compact`는 대신 이유를 보고합니다. 실행은 여전히 `success` 결과로 끝나고, `compact_boundary` 메시지는 발생하지 않으며, 결과 텍스트에 메시지가 포함됩니다. 예를 들어 짧은 단일 교환 후 `Not enough messages to compact.`입니다. 새로운 일회성 `query()` 호출은 빈 컨텍스트로 시작하므로 이 패턴을 이전 턴이 있는 세션에서 사용하세요. 예를 들어 [스트리밍 입력 모드](/docs/ko/agent-sdk/streaming-vs-single-mode)에서 또는 세션을 재개할 때입니다.
</Note>

<h3 id="/clear-reset-conversation-context">
  `/clear` - 대화 컨텍스트 초기화
</h3>

`/clear` 명령어는 대화를 빈 컨텍스트로 초기화하므로 이후의 프롬프트는 이전 대화 기록 없이 시작됩니다. 이전 대화는 디스크에 남아 있으며 세션 ID를 [`resume` 옵션](/docs/ko/agent-sdk/sessions#resume-by-id)에 전달하여 돌아갈 수 있습니다.

이는 단일 연결을 통해 여러 프롬프트를 보내는 [스트리밍 입력 모드](/docs/ko/agent-sdk/streaming-vs-single-mode)에서 유용합니다. 일회성 `query()` 호출의 경우 각 호출은 이미 빈 컨텍스트로 시작하므로 `/clear`를 보내는 것은 실질적인 효과가 없습니다. 대신 새로운 `query()`를 시작하세요.

<Note>
  SDK의 `/clear`는 Claude Code v2.1.117 이상이 필요합니다. 이전 버전에서는 `slash_commands`에서 생략됩니다.
</Note>

<h2 id="creating-custom-slash-commands">
  사용자 정의 슬래시 명령어 만들기
</h2>

기본 제공 슬래시 명령어를 사용하는 것 외에도 SDK를 통해 사용 가능한 자신만의 사용자 정의 명령어를 만들 수 있습니다. 사용자 정의 명령어는 서브에이전트가 구성되는 방식과 유사하게 특정 디렉토리의 마크다운 파일로 정의됩니다.

<Note>
  `.claude/commands/` 디렉토리는 레거시 형식입니다. 권장되는 형식은 `.claude/skills/<name>/SKILL.md`이며, 이는 동일한 슬래시 명령어 호출(`/name`)과 Claude의 자율적 호출을 지원합니다. 현재 형식은 [Skills](/docs/ko/agent-sdk/skills)를 참조하세요. CLI는 두 형식을 모두 계속 지원하며, 아래 예제는 `.claude/commands/`에 대해 정확합니다.
</Note>

<h3 id="file-locations">
  파일 위치
</h3>

사용자 정의 슬래시 명령어는 범위에 따라 지정된 디렉토리에 저장됩니다:

* **프로젝트 명령어**: `.claude/commands/` - 현재 프로젝트에서만 사용 가능 (레거시; `.claude/skills/` 선호)
* **개인 명령어**: `~/.claude/commands/` - 모든 프로젝트에서 사용 가능 (레거시; `~/.claude/skills/` 선호)

<h3 id="file-format">
  파일 형식
</h3>

각 사용자 정의 명령어는 마크다운 파일이며:

* 파일명(`.md` 확장자 제외)이 명령어 이름이 됩니다
* 파일 내용이 명령어의 기능을 정의합니다
* 선택적 YAML frontmatter가 구성을 제공합니다

<h4 id="basic-example">
  기본 예제
</h4>

프로젝트에 `.claude/commands` 디렉토리가 없으면 생성한 후 `.claude/commands/refactor.md`를 생성합니다:

```markdown theme={null}
Refactor the selected code to improve readability and maintainability.
Focus on clean code principles and best practices.
```

이는 SDK를 통해 사용할 수 있는 `/refactor` 명령어를 만듭니다.

<h4 id="with-frontmatter">
  Frontmatter 포함
</h4>

`.claude/commands/security-check.md` 생성:

```markdown theme={null}
---
allowed-tools: Read, Grep, Glob
description: Run security vulnerability scan
model: claude-opus-4-8
---

Analyze the codebase for security vulnerabilities including:
- SQL injection risks
- XSS vulnerabilities
- Exposed credentials
- Insecure configurations
```

<h3 id="using-custom-commands-in-the-sdk">
  SDK에서 사용자 정의 명령어 사용
</h3>

파일 시스템에서 정의되면 사용자 정의 명령어는 SDK를 통해 자동으로 사용 가능합니다:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  // 사용자 정의 명령어 사용
  try {
    for await (const message of query({
      prompt: "/refactor src/auth/login.ts",
      options: { maxTurns: 3 }
    })) {
      if (message.type === "assistant") {
        console.log("Refactoring suggestions:", message.message);
      }
    }
  } catch (error) {
    // 단일 쿼리 query()는 오류 결과를 반환한 후 throw하므로,
    // 아래의 두 번째 쿼리는 여전히 실행됩니다.
    console.error(`Session ended with an error: ${error}`);
  }

  // 사용자 정의 명령어는 slash_commands 목록에 나타납니다
  for await (const message of query({
    prompt: "Hello",
    options: { maxTurns: 1 }
  })) {
    if (message.type === "system" && message.subtype === "init") {
      console.log("Available commands:", message.slash_commands);
      // 기본 제공 명령어와 번들된 스킬 및 사용자 정의 명령어를 포함합니다. 예를 들어:
      // ["clear", "compact", "context", "usage", "code-review", "verify", "refactor", "security-check", ...]
    }
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions, AssistantMessage, SystemMessage


  async def main():
      # 사용자 정의 명령어 사용
      try:
          async for message in query(
              prompt="/refactor src/auth/login.py", options=ClaudeAgentOptions(max_turns=3)
          ):
              if isinstance(message, AssistantMessage):
                  for block in message.content:
                      if hasattr(block, "text"):
                          print("Refactoring suggestions:", block.text)
      except Exception as error:
          # 단일 쿼리 query()는 오류 결과를 반환한 후 raise하므로,
          # 아래의 두 번째 쿼리는 여전히 실행됩니다.
          print(f"Session ended with an error: {error}")

      # 사용자 정의 명령어는 slash_commands 목록에 나타납니다
      async for message in query(prompt="Hello", options=ClaudeAgentOptions(max_turns=1)):
          if isinstance(message, SystemMessage) and message.subtype == "init":
              print("Available commands:", message.data["slash_commands"])
              # 기본 제공 명령어와 번들된 스킬 및 사용자 정의 명령어를 포함합니다. 예를 들어:
              # ["clear", "compact", "context", "usage", "code-review", "verify", "refactor", "security-check", ...]


  asyncio.run(main())
  ```
</CodeGroup>

<h3 id="advanced-features">
  고급 기능
</h3>

<h4 id="arguments-and-placeholders">
  인수 및 플레이스홀더
</h4>

사용자 정의 명령어는 플레이스홀더를 사용하여 동적 인수를 지원합니다:

`.claude/commands/fix-issue.md` 생성:

```markdown theme={null}
---
argument-hint: [issue-number] [priority]
description: Fix a GitHub issue
---

Fix issue #$0 with priority $1.
Check the issue description and implement the necessary changes.
```

SDK에서 사용:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  // 사용자 정의 명령어에 인수 전달
  for await (const message of query({
    prompt: "/fix-issue 123 high",
    options: { maxTurns: 5 }
  })) {
    // 명령어는 $0="123"과 $1="high"로 처리됩니다
    if (message.type === "result" && message.subtype === "success") {
      console.log("Issue fixed:", message.result);
    }
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage


  async def main():
      # 사용자 정의 명령어에 인수 전달
      async for message in query(prompt="/fix-issue 123 high", options=ClaudeAgentOptions(max_turns=5)):
          # 명령어는 $0="123"과 $1="high"로 처리됩니다
          if isinstance(message, ResultMessage):
              print("Issue fixed:", message.result)


  asyncio.run(main())
  ```
</CodeGroup>

<h4 id="bash-command-execution">
  Bash 명령어 실행
</h4>

사용자 정의 명령어는 bash 명령어를 실행하고 출력을 포함할 수 있습니다:

`.claude/commands/git-commit.md` 생성:

```markdown theme={null}
---
allowed-tools: Bash(git add *), Bash(git status *), Bash(git commit *)
description: Create a git commit
---

## Context

- Current status: !`git status`
- Current diff: !`git diff HEAD`

## Task

Create a git commit with appropriate message based on the changes.
```

<h4 id="file-references">
  파일 참조
</h4>

`@` 접두사를 사용하여 파일 내용을 포함합니다:

`.claude/commands/review-config.md` 생성:

```markdown theme={null}
---
description: Review configuration files
---

Review the following configuration files for issues:
- Package config: @package.json
- TypeScript config: @tsconfig.json
- Environment config: @.env

Check for security issues, outdated dependencies, and misconfigurations.
```

<h3 id="organization-with-namespacing">
  네임스페이싱을 통한 조직화
</h3>

더 나은 구조를 위해 명령어를 하위 디렉토리에 구성합니다:

```bash theme={null}
.claude/commands/
├── frontend/
│   ├── component.md      # /component 생성 (project:frontend)
│   └── style-check.md     # /style-check 생성 (project:frontend)
├── backend/
│   ├── api-test.md        # /api-test 생성 (project:backend)
│   └── db-migrate.md      # /db-migrate 생성 (project:backend)
└── review.md              # /review 생성 (project)
```

하위 디렉토리는 명령어 설명에 나타나지만 명령어 이름 자체에는 영향을 주지 않습니다.

<h3 id="practical-examples">
  실용적인 예제
</h3>

<h4 id="pull-request-review-command">
  풀 리퀘스트 리뷰 명령어
</h4>

`.claude/commands/review-pr.md`를 생성합니다:

```markdown theme={null}
---
allowed-tools: Read, Grep, Glob, Bash(git diff *)
description: Comprehensive code review
---

## Changed Files
!`git diff --name-only HEAD~1`

## Detailed Changes
!`git diff HEAD~1`

## Review Checklist

Review the above changes for:
1. Code quality and readability
2. Security vulnerabilities
3. Performance implications
4. Test coverage
5. Documentation completeness

Provide specific, actionable feedback organized by priority.
```

<Note>
  Claude Code에는 번들된 `code-review` 및 `verify` 스킬이 포함되어 있습니다. 예를 들어 `.claude/commands/code-review.md`와 같이 사용자 정의 명령어의 이름을 이 중 하나로 지정하면, 사용자 정의 명령어가 번들된 스킬을 가리고 `slash_commands`는 이름을 한 번만 나열합니다.
</Note>

<h4 id="test-runner-command">
  테스트 러너 명령어
</h4>

`.claude/commands/test.md` 생성:

```markdown theme={null}
---
allowed-tools: Bash, Read, Edit
argument-hint: [test-pattern]
description: Run tests with optional pattern
---

Run tests matching pattern: $ARGUMENTS

1. Detect the test framework (Jest, pytest, etc.)
2. Run tests with the provided pattern
3. If tests fail, analyze and fix them
4. Re-run to verify fixes
```

SDK를 통해 이러한 명령어를 사용합니다:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  // 코드 리뷰 실행
  try {
    for await (const message of query({
      prompt: "/review-pr",
      options: { maxTurns: 3 }
    })) {
      // 리뷰 피드백 처리
    }
  } catch (error) {
    // 단일 쿼리 query()는 오류 결과를 반환한 후 throw하므로,
    // 아래의 두 번째 쿼리는 여전히 실행됩니다.
    console.error(`Session ended with an error: ${error}`);
  }

  // 특정 테스트 실행
  for await (const message of query({
    prompt: "/test auth",
    options: { maxTurns: 5 }
  })) {
    // 테스트 결과 처리
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions


  async def main():
      # 코드 리뷰 실행
      try:
          async for message in query(prompt="/review-pr", options=ClaudeAgentOptions(max_turns=3)):
              # 리뷰 피드백 처리
              pass
      except Exception as error:
          # 단일 쿼리 query()는 오류 결과를 반환한 후 raise하므로,
          # 아래의 두 번째 쿼리는 여전히 실행됩니다.
          print(f"Session ended with an error: {error}")

      # 특정 테스트 실행
      async for message in query(prompt="/test auth", options=ClaudeAgentOptions(max_turns=5)):
          # 테스트 결과 처리
          pass


  asyncio.run(main())
  ```
</CodeGroup>

<h2 id="see-also">
  참고 항목
</h2>

* [Slash Commands](/docs/ko/skills) - 완전한 슬래시 명령어 문서
* [SDK의 서브에이전트](/docs/ko/agent-sdk/subagents) - 서브에이전트를 위한 유사한 파일 시스템 기반 구성
* [TypeScript SDK 참조](/docs/ko/agent-sdk/typescript) - 완전한 API 문서
* [SDK 개요](/docs/ko/agent-sdk/overview) - 일반 SDK 개념
* [CLI 참조](/docs/ko/cli-reference) - 명령줄 인터페이스
