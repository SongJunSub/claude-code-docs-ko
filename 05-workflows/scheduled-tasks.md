> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 일정에 따라 프롬프트 실행

> /loop와 cron 스케줄링 도구를 사용하여 Claude Code 세션 내에서 프롬프트를 반복 실행하거나, 상태를 폴링하거나, 일회성 알림을 설정합니다.

세션 범위 예약 작업을 통해 Claude는 Claude Code 세션 내에서 일정한 간격으로 프롬프트를 자동으로 다시 실행할 수 있습니다. 배포를 폴링하거나, PR을 감시하거나, 오래 실행되는 빌드를 확인하거나, 나중에 세션에서 무언가를 하도록 알림을 설정하는 데 사용합니다.

> [!NOTE]
>
> 다음 경우는 다른 페이지에서 다룹니다.
>
> * **폴링하는 대신 이벤트가 발생할 때 반응하기**: [Channels](https://code.claude.com/docs/ko/channels.md)를 참조하세요. CI가 실패를 세션에 직접 푸시할 수 있습니다.
> * **일정한 간격이 아닌 조건을 향해 턴마다 세션이 계속 작동하도록 유지하기**: [`/goal`](https://code.claude.com/docs/ko/goal)을 참조하세요.

작업은 세션 범위입니다. `--resume` 또는 `--continue`로 재개할 때, Claude Code는 [만료되지 않은](#seven-day-expiry) 작업을 복원합니다. 단, [제한 사항](#limitations)에 나열된 작업은 제외됩니다. 세션과 독립적으로 유지되는 스케줄링의 경우, [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)을 생성하거나, [Desktop 예약 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md)을 설정하거나, [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md)를 사용합니다.

## 스케줄링 옵션 비교하기

Claude Code는 반복되는 작업이나 일회성 작업을 예약하는 세 가지 방법을 제공합니다:

| | [Cloud](https://code.claude.com/docs/ko/routines.md) | [Desktop](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md) | [`/loop`](https://code.claude.com/docs/ko/scheduled-tasks) |
| :- | :- | :- | :- |
| 실행 위치 | Cloud, Anthropic 관리 기본값 | 사용자 머신 | 사용자 머신 |
| 머신 켜짐 필요 | 아니오 | 예 | 예 |
| 열린 세션 필요 | 아니오 | 아니오 | 예 |
| 재시작 후 지속 | 예 | 예 | `--resume`에서 복원, [예외](https://code.claude.com/docs/ko/scheduled-tasks.md#limitations) 포함 |
| 로컬 파일 접근 | 아니오 (새로운 클론) | 예 | 예 |
| MCP 서버 | 작업별로 구성된 커넥터 | [구성 파일](https://code.claude.com/docs/ko/mcp.md) 및 커넥터 | 세션에서 상속 |
| 권한 프롬프트 | 기본적으로 [자동 모드](https://code.claude.com/docs/ko/routines.md#permission-prompts-during-a-run) | 작업별로 구성 가능 | 세션에서 상속 |
| 사용자 정의 가능한 일정 | 예 | 예 | 예 |
| 최소 간격 | 1시간 | Claude가 설정하는 경우 1분, [양식에서는 1시간](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md#schedule-options) | 1분 |

> [!TIP]
>
> **클라우드 작업**은 머신 없이 안정적으로 실행되어야 하는 작업에 사용합니다. **Desktop 작업**은 로컬 파일 및 도구에 접근해야 할 때 사용합니다. \*\*`/loop`\*\*는 세션 중 빠른 폴링에 사용합니다.

## /loop로 반복 프롬프트 실행하기

`/loop` [번들 스킬](https://code.claude.com/docs/ko/commands.md)은 세션이 열려 있는 동안 프롬프트를 반복 실행하는 가장 빠른 방법입니다. 간격과 프롬프트는 모두 선택 사항이며, 제공하는 내용에 따라 루프의 동작이 결정됩니다.

| 제공하는 내용 | 예시 | 동작 |
| :- | :- | :- |
| 간격과 프롬프트 | `/loop 5m check the deploy` | 프롬프트가 [고정 스케줄](#run-on-a-fixed-interval)에서 실행됩니다 |
| 프롬프트만 | `/loop check the deploy` | 프롬프트가 각 반복에서 [Claude가 선택한 간격](#let-claude-choose-the-interval)으로 실행됩니다 |
| 간격만 또는 아무것도 없음 | `/loop` | [내장 유지보수 프롬프트](#run-the-built-in-maintenance-prompt)가 실행되거나, 존재하는 경우 `loop.md`가 실행됩니다 |

또한 스킬을 프롬프트로 전달할 수 있습니다. 예를 들어 `/loop 20m /review-pr 1234`는 각 반복에서 해당 스킬을 다시 실행합니다. 스케줄된 실행은 Claude가 [자체적으로 호출할 수 있도록 허용된](https://code.claude.com/docs/ko/skills.md#control-who-invokes-a-skill) 스킬만 실행합니다. 다음은 Claude에 일반 텍스트로 전달되며 실행되지 않습니다.

* `/permissions`, `/model`, `/clear`와 같은 내장 명령어
* [`disable-model-invocation: true`](https://code.claude.com/docs/ko/skills#frontmatter-reference)로 표시된 스킬 (번들 `/verify` 스킬 포함)
* [`skillOverrides`](https://code.claude.com/docs/ko/skills#override-skill-visibility-from-settings) 설정이나 `Skill` [거부 규칙](https://code.claude.com/docs/ko/skills.md#restrict-claude%E2%80%99s-skill-access)으로 Claude에서 제외된 스킬
* [MCP 프롬프트](https://code.claude.com/docs/ko/mcp.md#use-mcp-prompts-as-commands) (예: `/mcp__github__list_prs`)

### 고정 간격으로 실행하기

간격을 제공하면 Claude가 이를 cron 표현식으로 변환하고, 작업을 스케줄하고, 주기와 작업 ID를 확인합니다.

```text theme={null}
/loop 5m check if the deployment finished and tell me what happened
```

간격은 `30m`과 같은 선행 토큰으로 프롬프트 앞에 올 수도 있고, `every 2 hours`와 같은 절로 뒤에 올 수도 있습니다. 지원되는 단위는 초의 경우 `s`, 분의 경우 `m`, 시간의 경우 `h`, 일의 경우 `d`입니다.

cron은 1분 단위의 세분성을 가지므로 초는 가장 가까운 분으로 올림됩니다. `7m` 또는 `90m`과 같이 깔끔한 cron 단계로 매핑되지 않는 간격은 가장 가까운 간격으로 반올림되며 Claude가 선택한 것을 알려줍니다.

### Claude가 간격을 선택하도록 하기

간격을 생략하면 Claude가 고정 cron 스케줄 대신 동적으로 간격을 선택합니다. 각 반복 후 관찰한 내용을 기반으로 1분에서 1시간 사이의 지연을 선택합니다. 빌드가 완료되거나 PR이 활성화되는 동안 짧은 대기, 보류 중인 것이 없을 때 더 긴 대기입니다. 선택된 지연과 그 이유는 각 반복이 끝날 때 출력됩니다.

아래 예시는 CI와 검토 의견을 확인하며, Claude는 PR이 조용해지면 반복 사이에 더 오래 기다립니다.

```text theme={null}
/loop check whether CI passed and address any review comments
```

[Monitor 도구를 사용할 수 있는](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool) 세션에서 동적 `/loop` 스케줄을 요청하면 Claude는 Monitor 도구를 직접 사용할 수 있습니다. Monitor는 백그라운드 스크립트를 실행하고 각 출력 줄을 다시 스트리밍하므로 폴링을 완전히 피하고 프롬프트를 간격으로 다시 실행하는 것보다 토큰 효율적이고 반응성이 더 좋은 경우가 많습니다.

동적으로 스케줄된 루프는 다른 작업처럼 [예약 작업 목록](#manage-scheduled-tasks)에 나타나므로 동일한 방식으로 나열하거나 취소할 수 있습니다. 목록에는 보류 중인 웨이크업이 일회성 작업으로 표시되므로, `:00` 또는 `:30`으로 예약된 웨이크업은 [약간 일찍 실행될 수 있습니다](#when-a-one-shot-task-runs-early). [7일 만료](#seven-day-expiry)도 루프에 적용됩니다.

> [!NOTE]
>
> 동적으로 선택된 간격과 [내장 유지보수 프롬프트](#run-the-built-in-maintenance-prompt)는 모든 제공자에서 작동하며, [기능 플래그 가져오기](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching)가 꺼져 있어도 작동합니다. Amazon Bedrock, Claude Platform on AWS, Google Cloud의 Agent Platform, Microsoft Foundry에서 또는 가져오기가 꺼져 있을 때, 둘 다 Claude Code v2.1.248 이상이 필요합니다.

### 내장 유지보수 프롬프트 실행하기

프롬프트를 생략하면 Claude는 제공한 프롬프트 대신 내장 유지보수 프롬프트를 사용합니다. 각 반복에서 다음을 순서대로 진행합니다.

* 대화에서 미완료된 작업 계속하기
* 현재 브랜치의 풀 요청 관리: 검토 의견, 실패한 CI 실행, 병합 충돌
* 다른 것이 보류 중이지 않을 때 버그 사냥이나 단순화와 같은 정리 통과 실행

Claude는 해당 범위 외의 새로운 이니셔티브를 시작하지 않으며, 푸시나 삭제와 같은 되돌릴 수 없는 작업은 트랜스크립트가 이미 승인한 것을 계속할 때만 진행됩니다.

```text theme={null}
/loop
```

단순한 `/loop`는 [동적으로 선택된 간격](#let-claude-choose-the-interval)에서 이 프롬프트를 실행합니다. 고정 스케줄에서 실행하려면 `/loop 15m`과 같이 간격을 추가하세요. 내장 프롬프트를 자신의 기본값으로 바꾸려면 [loop.md로 기본 프롬프트 사용자 정의하기](#customize-the-default-prompt-with-loop-md)를 참조하세요.

### loop.md로 기본 프롬프트 사용자 정의하기

`loop.md` 파일을 생성하여 [내장 유지보수 프롬프트](#run-the-built-in-maintenance-prompt)를 자신의 지침으로 바꿉니다. 이는 단순한 `/loop`에 대한 단일 기본 프롬프트를 정의하며, 별도의 스케줄된 작업 목록이 아니고, 명령줄에서 프롬프트를 제공할 때마다 Claude Code가 무시합니다. 추가 프롬프트를 함께 스케줄하려면 `/loop <prompt>`를 사용하거나 [Claude에게 직접 요청](#manage-scheduled-tasks)하세요.

Claude는 두 위치에서 파일을 찾고 먼저 찾은 것을 사용합니다.

| 경로 | 범위 |
| :- | :- |
| `.claude/loop.md` | 프로젝트 수준. 두 파일이 모두 존재할 때 우선순위를 가집니다. |
| `~/.claude/loop.md` | 사용자 수준. 자신의 파일을 정의하지 않는 모든 프로젝트에 적용됩니다. |

파일은 필수 구조가 없는 일반 Markdown입니다. `/loop` 프롬프트를 직접 입력하는 것처럼 작성하세요. 다음 예시는 릴리스 브랜치를 건강하게 유지합니다.

```markdown title=".claude/loop.md" theme={null}
Check the `release/next` PR. If CI is red, pull the failing job log,
diagnose, and push a minimal fix. If new review comments have arrived,
address each one and resolve the thread. If everything is green and
quiet, say so in one line.
```

`loop.md`에 대한 편집은 다음 반복에서 적용되므로 루프가 실행 중인 동안 지침을 개선할 수 있습니다. 두 위치 중 어디에도 `loop.md`가 없으면 루프는 내장 유지보수 프롬프트로 폴백됩니다. 파일을 간결하게 유지하세요. 25,000바이트를 초과하는 내용은 잘립니다.

### 루프 중지하기

* **[자기 속도 루프](#let-claude-choose-the-interval)**: 루프가 다음 반복을 기다리는 동안 `Esc`를 눌러 중지합니다. Claude가 유휴 상태일 때 `Ctrl+C`로도 중지할 수 있지만, [연결된 백그라운드 세션](#detach-without-stopping-a-loop)에서는 예외입니다. `Pending wakeup cancelled` 알림이 루프가 다시 실행되지 않음을 확인해 줍니다.
* **[고정 간격 루프](#run-on-a-fixed-interval)**: `/loop 5m`과 같은 루프를 중지하려면 `cancel the deploy check loop`처럼 Claude에게 취소를 요청하세요. `Esc`와 `Ctrl+C`로는 이 루프나 [Claude에게 직접 요청하여 스케줄한](#manage-scheduled-tasks) 작업을 중지할 수 없습니다. 취소하지 않은 루프는 [7일이 경과](#seven-day-expiry)하면 종료됩니다.

[자기 속도 모드](#let-claude-choose-the-interval)에서 Claude는 작업이 완료되면 루프를 직접 종료할 수도 있습니다. Claude는 `stop: true`로 [`ScheduleWakeup` 도구](https://code.claude.com/docs/ko/tools-reference)를 호출하여 보류 중인 웨이크업을 즉시 취소합니다. 반복이 재스케줄링이나 중지 없이 끝나면 Claude Code는 약 20분 후에 하나의 폴백 웨이크업을 스케줄하고 해당 반복이 재스케줄링하지 않으면 루프를 종료합니다.

#### 루프를 중지하지 않고 분리하기

[백그라운드 세션에 연결](https://code.claude.com/docs/ko/agent-view.md#attach-to-a-session)되어 있고 Claude가 유휴 상태일 때, 빈 프롬프트에서 `Ctrl+C`를 두 번 누르면 분리됩니다. 그곳에서 다음 반복을 기다리던 자기 속도 루프는 계속 실행되며, 해당 반복은 예정대로 시작됩니다. 대신 루프를 중지하려면 분리하기 전에 `Esc`를 누르세요. 루프를 중지하지 않고 `Ctrl+C`로 분리하려면 Claude Code v2.1.295 이상이 필요합니다.

## 일회성 알림 설정하기

일회성 알림의 경우 `/loop`를 사용하는 대신 자연어로 원하는 것을 설명합니다. Claude는 실행 후 자신을 삭제하는 단일 실행 작업을 스케줄합니다.

```text theme={null}
remind me at 3pm to push the release branch
```

```text theme={null}
in 45 minutes, check whether the integration tests passed
```

Claude는 cron 표현식을 사용하여 실행 시간을 특정 분과 시간으로 고정하고 실행 시간을 확인합니다.

## 세션 범위 예약 작업 관리하기

Claude에게 자연어로 작업을 나열하거나 취소하도록 요청하거나 기본 도구를 직접 참조합니다.

```text theme={null}
what scheduled tasks do I have?
```

```text theme={null}
cancel the deploy check job
```

내부적으로 Claude는 다음 도구를 사용합니다.

| 도구 | 목적 |
| :- | :- |
| `CronCreate` | 새 작업을 스케줄합니다. 5필드 cron 표현식, 실행할 프롬프트, 반복 여부 또는 일회성 실행 여부를 허용합니다. |
| `CronList` | ID, 스케줄, [다음 실행 시간](#jitter), 프롬프트와 함께 예약 작업을 나열합니다. |
| `CronDelete` | ID로 작업을 취소합니다. |

각 스케줄된 작업에는 `CronDelete`에 전달할 수 있는 8자 ID가 있습니다. 세션은 한 번에 최대 50개의 스케줄된 작업을 보유할 수 있습니다.

## 세션 범위 예약 작업이 실행되는 방식

스케줄러는 매초 기한이 된 작업을 확인하고 낮은 우선순위로 큐에 넣습니다. 스케줄된 프롬프트는 차례 사이에 실행되며, Claude가 응답 중일 때는 실행되지 않습니다. Claude가 작업이 기한이 될 때 바쁘면 프롬프트는 현재 차례가 끝날 때까지 기다립니다.

모든 시간은 현지 시간대로 해석됩니다. `0 9 * * *`와 같은 cron 표현식은 UTC가 아니라 Claude Code를 실행 중인 곳의 오전 9시를 의미합니다.

### 지터

예약 작업은 일정에 지정된 시간과 다른 시간에 실행될 수 있습니다. 모든 세션의 작업이 정확히 일정대로 실행되면 많은 작업이 같은 순간에 API를 호출하게 되므로, Claude Code는 각 작업의 실행 시간을 조정합니다. 반복 작업은 늦게 실행되지만, `*/5 * * * *`로 작성된 5분마다 실행되는 작업은 예외입니다. 정시 또는 30분에 예약된 일회성 작업은 약간 일찍 실행됩니다.

작업의 다음 실행 예정 시간을 확인하려면 터미널에서 Claude의 `CronCreate` 호출 아래에 있는 행을 확인하세요. 이 행은 일정 뒤에 해당 시간을 표시합니다(예: `next run 10:21 AM`). 나중에 다시 확인하려면 [Claude에게 작업 목록을 요청](#manage-scheduled-tasks)하고 `CronList` 호출 아래의 행에서 `next run`을 찾으세요. 이 행에 다음 실행 시간이 표시되려면 Claude Code v2.1.299 이상이 필요합니다.

#### 반복 작업이 얼마나 늦게 실행되는지

5분마다 실행되는 경우가 아니라면, 반복 작업은 각 실행을 다음 실행까지 간격의 최대 절반만큼, 그리고 최대 30분까지 늦게 시작합니다. 작업은 다음 세 가지 경우 중 하나에 해당합니다:

* **균등한 간격의 실행**: 매시간, 매일 또는 10분마다처럼 간격이 동일한 작업은 세션이 유휴 상태일 때를 포함하여 매번 같은 분만큼 늦게 실행됩니다.
* **불균등한 간격의 실행**: 매시간 `:00`과 `:15`에 예약된 작업처럼 간격이 고르지 않은 작업은 각 실행마다 다른 분만큼 늦게 실행될 수 있습니다.
* **5분마다**: `*/5 * * * *`로 작성된 작업은 지연되지 않습니다. 마지막 실행으로부터 정확히 5분 후에 실행하면 5분짜리 [프롬프트 캐시](https://code.claude.com/docs/ko/prompt-caching.md#which-ttl-each-request-gets)가 만료된 후에 시작되므로, 각 실행은 15초 더 일찍 시작됩니다.

이 표의 첫 번째 열에서 해당 일정을 찾아 각 실행이 언제 시작되는지 확인하세요.

| 일정 | 각 실행이 시작되는 시점 |
| :- | :- |
| 5분마다, `*/5 * * * *`로 작성되며 `/loop 5m`이 생성하는 일정 | 이전 실행으로부터 4분 45초 후 |
| 10분마다 | 0분에서 5분 늦게 |
| 30분마다 | 0분에서 15분 늦게 |
| 매시간 또는 매일처럼 그보다 덜 자주 | 0분에서 30분 늦게 |

예를 들어 `7,37 * * * *`는 작업을 `:07`과 `:37`에 예약하며, 이 둘은 30분 간격이므로 지연 시간은 0분에서 15분 사이입니다. 이 작업의 지연 시간이 14분이라면 매시간 `:21`과 `:51`에 실행됩니다. 일정을 다른 분으로 변경하면 실행 시간이 이동하며, 여전히 그 위에 지연 시간이 더해집니다.

#### 일회성 작업이 일찍 실행되는 경우

`:00` 또는 `:30`에 예약된 일회성 작업은 최대 90초 일찍 실행됩니다. Claude Code는 그 외의 분에 예약된 일회성 작업은 조정하지 않으므로, 타이밍이 중요한 경우 정시와 30분을 피해 예약하세요: `0 9 * * *` 대신 `3 9 * * *`를 사용합니다.

### 7일 만료

반복 작업은 생성 후 7일 후 자동으로 만료됩니다. 작업은 마지막으로 한 번 실행된 후 자신을 삭제합니다. 이는 잊혀진 루프가 실행될 수 있는 기간을 제한합니다. 반복 작업이 더 오래 지속되어야 하는 경우 만료되기 전에 취소하고 다시 만들거나 지속적인 스케줄링을 위해 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md) 또는 [Desktop 예약 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md)을 사용하세요.

## Cron 표현식 참조

`CronCreate`는 표준 5필드 cron 표현식을 허용합니다: `minute hour day-of-month month day-of-week`. 모든 필드는 와일드카드(`*`), 단일 값(`5`), 단계(`*/15`), 범위(`1-5`), 쉼표로 구분된 목록(`1,15,30`)을 지원합니다.

| 예시 | 의미 |
| :- | :- |
| `*/5 * * * *` | 5분마다 |
| `0 * * * *` | 매시간 정각 |
| `7 * * * *` | 매시간 7분 |
| `0 9 * * *` | 매일 오전 9시(현지 시간) |
| `0 9 * * 1-5` | 평일 오전 9시(현지 시간) |
| `30 14 15 3 *` | 3월 15일 오후 2시 30분(현지 시간) |

요일은 일요일의 경우 `0` 또는 `7`, 토요일의 경우 `6`을 사용합니다. `L`, `W`, `?`와 같은 확장 구문 및 `MON` 또는 `JAN`과 같은 이름 별칭은 지원되지 않습니다.

월의 날짜와 요일이 모두 제한되면 두 필드 중 하나라도 일치하면 날짜가 일치합니다. 이는 표준 vixie-cron 의미론을 따릅니다.

## 세션 범위 예약 작업 비활성화하기

환경에서 `CLAUDE_CODE_DISABLE_CRON=1`을 설정하여 스케줄러를 완전히 비활성화합니다. cron 도구와 `/loop`를 사용할 수 없게 되며, 이미 스케줄된 모든 작업이 실행을 중지합니다. 비활성화 플래그의 전체 목록은 [Environment variables](https://code.claude.com/docs/ko/env-vars.md)를 참조하세요.

## 제한 사항

세션 범위 스케줄링에는 고유한 제약이 있습니다.

* 작업은 Claude Code가 실행 중이고 유휴 상태일 때만 실행됩니다. 터미널을 닫거나 세션을 종료하면 작업 실행이 중지됩니다. [세션을 백그라운드로 전환](https://code.claude.com/docs/ko/agent-view.md#from-inside-a-session)하면 `/loop` 작업이 백그라운드 세션으로 이동되어 터미널 없이 계속 실행됩니다.
* 놓친 실행에 대한 추적 없음. 작업의 스케줄된 시간이 Claude가 오래 실행되는 요청에 바쁠 때 지나가면 Claude가 유휴 상태가 될 때 한 번 실행되며, 놓친 각 간격마다 한 번씩 실행되지 않습니다.
* [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md#from-inside-a-session)에서 [자체 속도 루프](#let-claude-choose-the-interval)는 충돌 이후처럼 세션 프로세스가 실행 중이지 않을 때 다음 깨우기 시점이 도래하면 중지됩니다. 프로세스가 다시 시작되면 트랜스크립트에 [깨우기가 실행되지 않는다는 알림](https://code.claude.com/docs/ko/errors.md#restarted-after-its-next-loop-wakeup-was-due)이 표시됩니다. 루프를 계속하려면 [세션에 답장](https://code.claude.com/docs/ko/agent-view.md#peek-and-reply)하여 Claude에게 계속 실행하도록 요청하십시오.
* `claude --resume` 또는 `claude --continue`로 세션을 재개할 때 Claude Code는 `CronCreate`로 스케줄된 작업을 복원합니다. 단, [만료된](#seven-day-expiry) 반복 작업과 스케줄된 시간이 이미 지난 일회성 작업은 제외됩니다. [자체 속도 `/loop`](#let-claude-choose-the-interval)는 복원되지 않으므로 다시 시작하려면 `/loop`를 다시 실행하십시오.
* 복원된 반복 작업은 세션이 실행되지 않는 동안 놓친 실행을 수행하지 않습니다. 다음 실행은 재개 후 처음 도래하는 실행이며, 해당 실행에는 [지터](#jitter)가 적용됩니다.
* `claude --resume` 또는 `claude --continue`로 재개할 때 Claude Code는 세션이 종료될 때 실행 중이던 백그라운드 Bash 명령과 모니터를 다시 시작하지 않습니다. 여전히 필요한 경우 Claude에게 다시 시작하도록 요청하십시오.
* [기능 플래그 가져오기가 비활성화된 경우](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching), Claude Code는 세션 간에 유지하도록 요청한 작업을 프로젝트의 `.claude/scheduled_tasks.json` 파일에 저장합니다. `.claude` 디렉터리 또는 해당 파일이 심볼릭 링크인 경우 Claude Code는 작업을 스케줄하는 대신 오류를 반환합니다. 저장된 작업은 작업을 생성한 프로젝트 폴더에서만 실행됩니다. 파일을 새로운 worktree와 같은 다른 폴더로 복사하면 해당 세션에서 복사된 작업을 나열하지만 실행하지 않으므로 해당 폴더에서 작업을 다시 생성하십시오.

무인으로 실행해야 하는 cron 기반 자동화의 경우:

* [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md): 클라우드에서 스케줄에 따라, API 호출을 통해, 또는 GitHub 이벤트에서 실행됩니다.
* [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md): CI에서 `schedule` 트리거 사용
* [Desktop scheduled tasks](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md): 머신에서 로컬로 실행
