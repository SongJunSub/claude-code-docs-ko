> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 컨텍스트 윈도우 살펴보기

> Claude Code의 컨텍스트 윈도우가 세션 중에 어떻게 채워지는지 보여주는 대화형 시뮬레이션입니다. 자동으로 로드되는 항목, 각 파일 읽기의 비용, 규칙과 훅이 언제 실행되는지 확인하세요.

Claude Code의 컨텍스트 윈도우는 Claude가 세션에 대해 알고 있는 모든 것을 보유합니다: 사용자의 지시사항, 읽은 파일, Claude 자신의 응답, 그리고 터미널에 나타나지 않는 콘텐츠입니다. 아래 타임라인은 시작부터 압축까지 전체 세션을 재생합니다: 사용자가 입력하기 전에 무엇이 로드되고, 각 파일 읽기, 규칙, 훅이 Claude가 작업할 때 무엇을 추가하는지, 그리고 서브에이전트가 어떻게 대용량 읽기를 컨텍스트 밖으로 유지하는지 보여줍니다. 동일한 콘텐츠를 목록으로 보려면 [작성된 분석](#what-the-timeline-shows)을 참조하세요.

## 타임라인이 보여주는 것

세션은 대표적인 토큰 수를 포함한 현실적인 흐름을 따릅니다:

* **아무것도 입력하기 전**: CLAUDE.md, 자동 메모리, MCP 도구 이름, 그리고 스킬 설명이 모두 컨텍스트에 로드됩니다. [AGENTS.md 파일](https://code.claude.com/docs/ko/memory.md#agents-md)이 CLAUDE.md 대신 로드될 수도 있습니다. 사용자의 설정에 따라 [출력 스타일](https://code.claude.com/docs/ko/output-styles.md) 또는 [`--append-system-prompt`](https://code.claude.com/docs/ko/cli-reference)의 텍스트와 같이 추가 항목이 있을 수 있습니다.
* **Claude가 작업할 때**: 각 파일 읽기가 컨텍스트에 추가되고, [경로 범위 규칙](https://code.claude.com/docs/ko/memory.md#path-specific-rules)이 일치하는 파일과 함께 자동으로 로드되며, [PostToolUse 훅](https://code.claude.com/docs/ko/hooks-guide.md)이 각 편집 후에 실행됩니다.
* **후속 프롬프트**: [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)가 자신의 별도 컨텍스트 윈도우에서 연구를 처리하므로 대용량 파일 읽기가 사용자의 윈도우에서 벗어납니다. 요약과 작은 메타데이터 트레일러만 돌아옵니다.
* **끝에서**: `/compact`가 대화를 구조화된 요약으로 바꿉니다. 대부분의 시작 콘텐츠는 자동으로 다시 로드됩니다. 아래 표는 각 메커니즘에 어떤 일이 발생하는지 보여줍니다.

## 압축 후 유지되는 것

긴 세션이 압축될 때, Claude Code는 대화 기록을 요약하여 컨텍스트 윈도우에 맞춥니다. v2.1.198부터는 요약 요청이 세션의 [확장 사고](https://code.claude.com/docs/ko/model-config.md#extended-thinking) 구성을 상속하므로, 세션에서 사고가 활성화되어 있을 때는 사고를 활성화하여 추론하고 그렇지 않으면 비활성화된 상태로 유지됩니다. 사고는 요약이 생성되는 방식에만 영향을 미치며, 이후 세션 설정은 변경되지 않습니다. 각 콘텐츠 종류에 어떤 일이 발생하는지는 로드된 방식에 따라 달라집니다:

| 메커니즘 | 압축 후 |
| :- | :- |
| 시스템 프롬프트 및 출력 스타일 | 계속 적용됨 |
| 프로젝트 루트 CLAUDE.md 및 범위 미지정 규칙 | 디스크에서 다시 주입됨 |
| 자동 메모리 | 디스크에서 다시 주입됨 |
| 스킬 설명 | 현재 [스킬](https://code.claude.com/docs/ko/skills.md)에서 다시 구성되어 다시 주입됨. Claude Code v2.1.304 이상 필요 |
| [Git 상태 스냅샷](https://code.claude.com/docs/ko/settings-reference.md#includegitinstructions) | 세션이 스냅샷과 함께 시작된 경우, Claude Code가 저장소에서 새로운 스냅샷을 읽음 |
| [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에서 Claude가 작성한 계획 | 디스크에서 다시 주입됨 |
| `paths:` frontmatter가 있는 규칙 | Claude Code가 [필요할 때](https://code.claude.com/docs/ko/memory.md#path-specific-rules) 다시 로드함 |
| 하위 디렉토리의 중첩 CLAUDE.md | Claude Code가 [필요할 때](https://code.claude.com/docs/ko/memory.md#how-claude-md-files-load) 다시 로드함 |
| Claude가 읽거나 편집한 파일 | Claude Code가 최대 5개를 다시 읽음, 가장 최근에 수정된 것부터 |
| 호출된 스킬 본문 | 다시 주입됨, 스킬당 5,000 토큰 및 총 25,000 토큰으로 제한됨; 가장 오래된 것부터 삭제됨 |
| [백그라운드 명령](https://code.claude.com/docs/ko/interactive-mode.md#background-bash-commands) 및 백그라운드 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background) | 계속 실행됨. Claude Code는 Claude에게 어떤 것이 여전히 실행 중인지 상기시켜 중복을 시작하지 않도록 함 |
| 훅이 이전에 추가한 컨텍스트 | 대화의 나머지 부분과 함께 요약됨 |
| `compact` 소스와 일치하는 [SessionStart 훅](https://code.claude.com/docs/ko/hooks-guide.md#re-inject-context-after-compaction) | Claude Code가 실행하고 압축된 컨텍스트에 출력을 추가함 |

압축 직후, Claude Code는 세션에서 Claude가 읽거나 편집한 파일 중 최대 5개를 다시 읽으며, 가장 최근에 수정된 파일을 선택합니다. 5,000 토큰을 초과하는 파일은 내용 없이 경로 참조로 돌아오며, `Read` 대신 `Referenced file`로 표시됩니다.

경로 범위 규칙 및 중첩 CLAUDE.md 파일은 Claude가 트리거 파일을 읽거나, 쓰거나, 편집할 때 메시지 기록에 로드되므로 압축은 다른 모든 것과 함께 이들을 요약합니다. 규칙이 압축 전체에서 유지되어야 하는 경우 `paths:` frontmatter를 삭제하거나 프로젝트 루트 CLAUDE.md로 이동하세요.

스킬 본문은 압축 후 다시 주입되지만 큰 스킬은 스킬당 제한에 맞게 잘리고, 총 예산을 초과하면 가장 오래된 호출된 스킬이 삭제됩니다. 잘림은 파일의 시작을 유지하므로 `SKILL.md`의 맨 위에 가장 중요한 지시사항을 배치하세요.

## 컨텍스트가 가득 찰 때

Claude Code는 한도에 가까워지면 자동으로 압축하므로, 컨텍스트 윈도우가 가득 차도 세션이 끝나지 않습니다. 자동 압축은 타임라인의 `/compact` 단계와 같은 방식으로 작동합니다. 무엇이 보존되는지는 [컨텍스트가 가득 찰 때](https://code.claude.com/docs/ko/how-claude-code-works.md#when-context-fills-up)를 참조하세요. 유휴 상태로 둔 대화를 Claude Code가 압축하는 경우에 대해서는 [유휴 압축](https://code.claude.com/docs/ko/settings-reference.md#idlecompaction)을 참조하세요.

자동 압축이 실행되기 전에 직접 조치를 취할 수도 있습니다.

* **초점을 지정하여 압축**: 긴 새 작업을 시작하기 전에 `/compact focus on the auth bug fix`처럼 지침과 함께 `/compact`를 실행합니다. 요약에는 자동 압축이 중요하다고 추측한 내용 대신 사용자가 선택한 내용이 유지됩니다.
* **대화의 일부를 압축**: `/rewind`를 실행하고 메시지를 선택한 다음 **Summarize from here** 또는 **Summarize up to here**를 선택합니다. 각 옵션이 무엇을 유지하는지와 요약을 안내하는 방법은 [되감기 및 요약](https://code.claude.com/docs/ko/checkpointing.md#rewind-and-summarize)을 참조하세요.
* **더 일찍 압축**: `/autocompact 500k`처럼 토큰 수와 함께 [`/autocompact`](https://code.claude.com/docs/ko/commands#all-commands)를 실행하여 자동 압축이 실행되기 전에 컨텍스트 윈도우가 얼마나 찰 수 있는지 설정합니다. 허용되는 값과 재정의 방법은 [자동 압축 윈도우 설정](https://code.claude.com/docs/ko/model-config.md#set-the-auto-compact-window)을 참조하세요.
* **작업 사이에 지우기**: 관련 없는 작업으로 전환할 때 `/clear`를 실행합니다. 이전 대화는 다음에 필요한 파일이 들어갈 공간을 차지하고 모든 메시지마다 토큰을 소비합니다.
* **대용량 읽기 위임**: 조사 작업을 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)에 맡기면 파일 내용이 사용자의 컨텍스트 윈도우가 아닌 서브에이전트의 컨텍스트 윈도우에 남습니다.

대화를 줄이는 대신 더 큰 윈도우가 필요하다면, Fable 모델, Sonnet 5 이상, Haiku 5.5, Opus 4.6 이상, Sonnet 4.6은 100만 토큰 컨텍스트 윈도우를 지원합니다. 플랜별 사용 가능 여부와 `[1m]` 모델 변형을 선택하는 방법은 [확장 컨텍스트](https://code.claude.com/docs/ko/model-config.md#extended-context)를 참조하세요. 더 큰 한도에서도 압축은 동일하게 작동합니다.

자동 압축이 실행되는 시점은 모델과 구성에 따라 다릅니다. 모델별 경계는 [기본 자동 압축 임계값](https://code.claude.com/docs/ko/model-config.md#default-auto-compact-thresholds)을 참조하고, [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 별칭처럼 Claude Code가 모델 ID에 대해 잘못된 윈도우를 가정하는 경우에는 [게이트웨이 또는 사용자 지정 모델 ID에 맞게 윈도우 수정](https://code.claude.com/docs/ko/model-config.md#correct-the-window-for-a-gateway-or-custom-model-id)을 참조하세요.

## 자신의 세션 확인

시각화는 대표적인 숫자를 사용합니다. 언제든지 실제 컨텍스트 사용량을 보려면 `/context`를 실행하여 카테고리별 라이브 분석과 최적화 제안을 확인하세요. 로드된 CLAUDE.md 및 자동 메모리 파일을 포함한 최적화 제안을 확인하세요. `/memory`를 실행하여 해당 파일을 열고 편집하세요.

## 관련 리소스

타임라인에 표시된 기능에 대한 더 깊은 내용은 다음 페이지를 참조하세요:

* [Claude Code 확장](https://code.claude.com/docs/ko/features-overview.md): CLAUDE.md vs 스킬 vs 규칙 vs 훅 vs MCP를 언제 사용할지
* [지시사항 및 메모리 저장](https://code.claude.com/docs/ko/memory.md): CLAUDE.md 계층 구조 및 자동 메모리
* [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md): 연구를 별도 컨텍스트 윈도우에 위임
* [모범 사례](https://code.claude.com/docs/ko/best-practices.md#keep-cost-and-context-down): 세션을 집중적으로 유지하고 비용 절감
* [프롬프트 캐싱](https://code.claude.com/docs/ko/prompt-caching.md): 캐시된 접두사를 무효화하는 작업
* [토큰 사용량 감소](https://code.claude.com/docs/ko/costs.md#reduce-token-usage): 컨텍스트 사용량을 낮게 유지하기 위한 전략
