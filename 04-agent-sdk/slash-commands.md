> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# SDK의 슬래시 명령어

> SDK를 통해 Claude Code 세션을 제어하기 위해 슬래시 명령어를 사용하는 방법을 알아봅니다

슬래시 명령어는 `/`로 시작하는 특수 명령어를 사용하여 Claude Code 세션을 제어하는 방법을 제공합니다. 이러한 명령어는 SDK를 통해 전송되어 컨텍스트 압축, 컨텍스트 사용량 나열 또는 사용자 정의 명령어 호출과 같은 작업을 수행할 수 있습니다. 대화형 터미널 없이 작동하는 명령어만 SDK를 통해 전달할 수 있으며, `system/init` 메시지에 세션에서 사용 가능한 명령어가 나열됩니다.

## 사용 가능한 슬래시 명령어 발견

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
      // Example output: ["clear", "compact", "context", "usage"]
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
              # Example output: ["clear", "compact", "context", "usage"]


  asyncio.run(main())
  ```
</CodeGroup>

## 슬래시 명령어 전송

프롬프트 문자열에 슬래시 명령어를 포함하여 일반 텍스트처럼 전송합니다:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  // Send a slash command
  for await (const message of query({
    prompt: "/compact",
    options: { maxTurns: 1 }
  })) {
    if (message.type === "result" && message.subtype === "success") {
      console.log("Command executed:", message.result);
    }
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage


  async def main():
      # Send a slash command
      async for message in query(prompt="/compact", options=ClaudeAgentOptions(max_turns=1)):
          if isinstance(message, ResultMessage):
              print("Command executed:", message.result)


  asyncio.run(main())
  ```
</CodeGroup>

## 일반적인 슬래시 명령어

### `/compact` - 대화 기록 압축

`/compact` 명령어는 이전 메시지를 요약하면서 중요한 컨텍스트를 보존하여 대화 기록의 크기를 줄입니다:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  for await (const message of query({
    prompt: "/compact",
    options: { maxTurns: 1 }
  })) {
    if (message.type === "system" && message.subtype === "compact_boundary") {
      console.log("Compaction completed");
      console.log("Pre-compaction tokens:", message.compact_metadata.pre_tokens);
      console.log("Trigger:", message.compact_metadata.trigger);
    }
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions, SystemMessage


  async def main():
      async for message in query(prompt="/compact", options=ClaudeAgentOptions(max_turns=1)):
          if isinstance(message, SystemMessage) and message.subtype == "compact_boundary":
              print("Compaction completed")
              print("Pre-compaction tokens:", message.data["compact_metadata"]["pre_tokens"])
              print("Trigger:", message.data["compact_metadata"]["trigger"])


  asyncio.run(main())
  ```
</CodeGroup>

### `/clear` - 대화 컨텍스트 초기화

`/clear` 명령어는 대화를 빈 컨텍스트로 초기화하므로 이후의 프롬프트는 이전 대화 기록 없이 시작됩니다. 이전 대화는 디스크에 남아 있으며 세션 ID를 [`resume` 옵션](/ko/agent-sdk/sessions#resume-by-id)에 전달하여 돌아갈 수 있습니다.

이는 단일 연결을 통해 여러 프롬프트를 보내는 [스트리밍 입력 모드](/ko/agent-sdk/streaming-vs-single-mode)에서 유용합니다. 일회성 `query()` 호출의 경우 각 호출은 이미 빈 컨텍스트로 시작하므로 `/clear`를 보내는 것은 실질적인 효과가 없습니다. 대신 새로운 `query()`를 시작하세요.

<Note>
  SDK의 `/clear`는 Claude Code v2.1.117 이상이 필요합니다. 이전 버전에서는 `slash_commands`에서 생략됩니다.
</Note>

## 사용자 정의 슬래시 명령어 만들기

기본 제공 슬래시 명령어를 사용하는 것 외에도 SDK를 통해 사용 가능한 자신만의 사용자 정의 명령어를 만들 수 있습니다. 사용자 정의 명령어는 서브에이전트가 구성되는 방식과 유사하게 특정 디렉토리의 마크다운 파일로 정의됩니다.

<Note>
  `.claude/commands/` 디렉토리는 레거시 형식입니다. 권장되는 형식은 `.claude/skills/<name>/SKILL.md`이며, 이는 동일한 슬래시 명령어 호출(`/name`)과 Claude의 자율적 호출을 지원합니다. 현재 형식은 [Skills](/ko/agent-sdk/skills)를 참조하세요. CLI는 두 형식을 모두 계속 지원하며, 아래 예제는 `.claude/commands/`에 대해 정확합니다.
</Note>

### 파일 위치

사용자 정의 슬래시 명령어는 범위에 따라 지정된 디렉토리에 저장됩니다:

* **프로젝트 명령어**: `.claude/commands/` - 현재 프로젝트에서만 사용 가능 (레거시; `.claude/skills/` 선호)
* **개인 명령어**: `~/.claude/commands/` - 모든 프로젝트에서 사용 가능 (레거시; `~/.claude/skills/` 선호)

### 파일 형식

각 사용자 정의 명령어는 마크다운 파일이며:

* 파일명(`.md` 확장자 제외)이 명령어 이름이 됩니다
* 파일 내용이 명령어의 기능을 정의합니다
* 선택적 YAML frontmatter가 구성을 제공합니다

#### 기본 예제

`.claude/commands/refactor.md` 생성:

```markdown theme={null}
Refactor the selected code to improve readability and maintainability.
Focus on clean code principles and best practices.
```

이는 SDK를 통해 사용할 수 있는 `/refactor` 명령어를 만듭니다.

#### Frontmatter 포함

`.claude/commands/security-check.md` 생성:

```markdown theme={null}
---
allowed-tools: Read, Grep, Glob
description: Run security vulnerability scan
model: claude-opus-4-7
---

Analyze the codebase for security vulnerabilities including:
- SQL injection risks
- XSS vulnerabilities
- Exposed credentials
- Insecure configurations
```

### SDK에서 사용자 정의 명령어 사용

파일 시스템에서 정의되면 사용자 정의 명령어는 SDK를 통해 자동으로 사용 가능합니다:

<CodeGroup>
  ```typescript TypeScript theme={null}
  import { query } from "@anthropic-ai/claude-agent-sdk";

  // 사용자 정의 명령어 사용
  for await (const message of query({
    prompt: "/refactor src/auth/login.ts",
    options: { maxTurns: 3 }
  })) {
    if (message.type === "assistant") {
      console.log("Refactoring suggestions:", message.message);
    }
  }

  // 사용자 정의 명령어는 slash_commands 목록에 나타납니다
  for await (const message of query({
    prompt: "Hello",
    options: { maxTurns: 1 }
  })) {
    if (message.type === "system" && message.subtype === "init") {
      // 기본 제공 명령어와 사용자 정의 명령어를 모두 포함합니다
      console.log("Available commands:", message.slash_commands);
      // 예: ["clear", "compact", "context", "usage", "refactor", "security-check"]
    }
  }
  ```

  ```python Python theme={null}
  import asyncio
  from claude_agent_sdk import query, ClaudeAgentOptions, AssistantMessage, SystemMessage


  async def main():
      # 사용자 정의 명령어 사용
      async for message in query(
          prompt="/refactor src/auth/login.py", options=ClaudeAgentOptions(max_turns=3)
      ):
          if isinstance(message, AssistantMessage):
              for block in message.content:
                  if hasattr(block, "text"):
                      print("Refactoring suggestions:", block.text)

      # 사용자 정의 명령어는 slash_commands 목록에 나타납니다
      async for message in query(prompt="Hello", options=ClaudeAgentOptions(max_turns=1)):
          if isinstance(message, SystemMessage) and message.subtype == "init":
              # 기본 제공 명령어와 사용자 정의 명령어를 모두 포함합니다
              print("Available commands:", message.data["slash_commands"])
              # 예: ["clear", "compact", "context", "usage", "refactor", "security-check"]


  asyncio.run(main())
  ```
</CodeGroup>

### 고급 기능

#### 인수 및 플레이스홀더

사용자 정의 명령어는 플레이스홀더를 사용하여 동적 인수를 지원합니다:

`.claude/commands/fix-issue.md` 생성:

```markdown theme={null}
---
argument-hint: [issue-number] [priority]
description: Fix a GitHub issue
---

Fix issue #$1 with priority $2.
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
    // 명령어는 $1="123"과 $2="high"로 처리됩니다
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
          # 명령어는 $1="123"과 $2="high"로 처리됩니다
          if isinstance(message, ResultMessage):
              print("Issue fixed:", message.result)


  asyncio.run(main())
  ```
</CodeGroup>

#### Bash 명령어 실행

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

#### 파일 참조

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

### 네임스페이싱을 통한 조직화

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

### 실용적인 예제

#### 코드 리뷰 명령어

`.claude/commands/code-review.md` 생성:

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

#### 테스트 러너 명령어

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
  for await (const message of query({
    prompt: "/code-review",
    options: { maxTurns: 3 }
  })) {
    // 리뷰 피드백 처리
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
      async for message in query(prompt="/code-review", options=ClaudeAgentOptions(max_turns=3)):
          # 리뷰 피드백 처리
          pass

      # 특정 테스트 실행
      async for message in query(prompt="/test auth", options=ClaudeAgentOptions(max_turns=5)):
          # 테스트 결과 처리
          pass


  asyncio.run(main())
  ```
</CodeGroup>

## 참고 항목

* [Slash Commands](/ko/skills) - 완전한 슬래시 명령어 문서
* [SDK의 서브에이전트](/ko/agent-sdk/subagents) - 서브에이전트를 위한 유사한 파일 시스템 기반 구성
* [TypeScript SDK 참조](/ko/agent-sdk/typescript) - 완전한 API 문서
* [SDK 개요](/ko/agent-sdk/overview) - 일반 SDK 개념
* [CLI 참조](/ko/cli-reference) - 명령줄 인터페이스
