> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 비용을 효과적으로 관리하기

> 토큰 사용량을 추적하고, 팀 지출 한도를 설정하며, 컨텍스트 관리, 모델 선택, 확장 사고 설정 및 전처리 훅을 통해 Claude Code 비용을 절감합니다.

Claude Code는 API 토큰 소비량으로 청구됩니다. 구독 요금제 가격(Pro, Max, Ultra, Team, Enterprise)은 [claude.com/pricing](https://claude.com/pricing)을 참조하십시오. 개발자당 비용은 모델 선택, 코드베이스 크기, 여러 인스턴스 실행 또는 자동화와 같은 사용 패턴에 따라 크게 달라집니다.

엔터프라이즈 배포 전반에 걸쳐 평균 비용은 개발자당 활성 일일 약 \$13이며, 개발자당 월 \$150-250이고, 90%의 사용자는 활성 일일 비용이 \$30 이하로 유지됩니다. 팀의 지출을 추정하려면 작은 파일럿 그룹으로 시작하고 아래의 추적 도구를 사용하여 더 광범위한 롤아웃 전에 기준선을 설정하십시오.

이 페이지에서는 Claude Code 사용량만 다루며, [비용 추적 방법](#track-your-costs), [조직 비용 관리](#manage-costs-for-your-organization), [토큰 사용량 감소](#reduce-token-usage) 방법을 설명합니다. 다른 Claude 제품의 사용 한도는 [Claude 고객 센터](https://support.claude.com)를 참조하십시오.

## 비용 추적

### `/usage` 명령 사용

> [!NOTE]
>
> `/usage`의 Session 블록은 API 토큰 사용량을 표시하며 API 사용자를 위한 것입니다. Claude Pro, Max 및 Ultra 구독자는 구독에 사용량이 포함되어 있으므로 세션 비용 수치는 청구 목적으로 관련이 없습니다. 구독자는 동일한 화면에서 요금제 사용량 막대, 활동 통계 및 사용량 분석을 볼 수 있습니다.

`/usage` 상단의 Session 블록은 현재 세션에 대한 자세한 토큰 사용량 통계를 표시합니다. Claude Code는 [`modelPricing`](https://code.claude.com/docs/ko/settings-reference#modelpricing) 테이블이 적용되지 않는 한 토큰 수에서 정가로 달러 수치를 로컬로 계산합니다. 관리자는 조직의 관리 설정에서 이를 설정하여 수치가 계약된 요금을 사용하도록 하며, 테이블이 적용되는 동안 `Total cost` 줄에는 `at your organization's configured rates` 메모가 표시됩니다. 수치는 추정치이므로 권위 있는 청구를 위해 [Claude Console](https://platform.claude.com/usage)의 사용량 페이지를 참조하십시오.

```text theme={null}
Total cost:            $0.55
Total duration (API):  6m 20s
Total duration (wall): 6h 33m 10s
Total code changes:    0 lines added, 0 lines removed
Usage by model:
   claude-sonnet-4-6:  1.2k input, 5.3k output, 940.0k cache read, 50.0k cache write ($0.55)
```

이러한 합계는 `/clear`가 새 세션을 시작할 때 재설정되므로 다음 세션의 총 비용은 \$0에서 시작합니다. v2.1.211 이전에는 `/clear`를 통해 Claude Code 프로세스의 수명 동안 계속 누적되었습니다.

1.1× [데이터 거주지 요금](https://platform.claude.com/docs/en/about-claude/pricing#data-residency-pricing)으로 청구되는 Claude API의 응답의 경우, Claude Code는 해당 응답의 토큰 정가에 1.1을 곱하여 세션 비용 수치에 적용합니다. 동일한 합계가 [상태줄의 비용 필드](https://code.claude.com/docs/ko/statusline.md#cost-and-duration-tracking)에도 표시되며, 곱해진 수치는 [`--max-budget-usd`](https://code.claude.com/docs/ko/cli-reference#cli-flags)에도 반영됩니다.

#### 프롬프트 캐시 통계

주 대화의 첫 번째 API 응답 후, Claude Code는 Session 블록에 `Prompt cache (main)` 줄을 추가하여 세션의 [프롬프트 캐시](https://code.claude.com/docs/ko/prompt-caching.md) 사용을 요약합니다: 요청 수, 캐시에서 제공된 입력 토큰의 공유, 캐시 미스 및 캐시가 현재 따뜻한지 여부입니다. Claude Code v2.1.251 이상이 필요합니다.

```text theme={null}
Prompt cache (main):   14 requests · 91% of input tokens from cache · 2 misses (last 6m 10s ago, 310.2k tokens re-cached) · 1 expected rebuild (compaction or tool-result clearing) · warm (1h TTL, last activity 40s ago)
```

줄의 미스, 예상 재구축 및 따뜻함 또는 차가움 부분은 다음을 의미합니다:

* **Misses**: 캐시가 이미 보유한 콘텐츠를 다시 처리한 요청이며, 마지막 미스의 시간과 해당 요청이 캐시에 다시 작성한 토큰 수입니다. [캐시를 무효화하는 작업](https://code.claude.com/docs/ko/prompt-caching.md#actions-that-invalidate-the-cache)은 일반적인 원인을 나열합니다. Claude Code가 마지막 미스의 가능한 원인을 식별할 수 있을 때, 줄은 이를 이름으로 지정합니다. 예를 들어 `likely cause: tool definitions changed`입니다. 가능한 원인 텍스트는 Claude Code v2.1.260 이상이 필요합니다.
* **Expected rebuilds**: Claude Code가 [압축](https://code.claude.com/docs/ko/prompt-caching.md#compacting-the-conversation)을 통해 또는 컨텍스트에서 이전 도구 결과를 지워서 대화를 다시 작성했을 때, 동일한 종류의 미스를 예상 재구축으로 계산합니다. 이 부분은 최소 하나의 예상 재구축이 발생한 후에만 나타납니다.
* **Warm or cold**: 캐시된 접두사가 여전히 [캐시 수명](https://code.claude.com/docs/ko/prompt-caching.md#cache-lifetime) 내에 있는지 여부이며, 적용 중인 TTL입니다. 캐시가 차가울 때, 줄은 세션이 유휴 상태인 기간을 표시합니다. 응답이 캐시 토큰을 보고하지 않았을 때, 줄은 대신 `no prompt caching reported by the API`로 끝납니다.

수는 API의 응답의 캐시 토큰 필드에서 나오므로, 줄은 모든 공급자 및 게이트웨이에서 작동합니다. 주 대화만 다루며, 서브에이전트는 다루지 않습니다. `/clear`는 Session 블록의 나머지와 함께 이를 재설정합니다.

상태 줄 스크립트는 [`prompt_cache` 객체](https://code.claude.com/docs/ko/statusline#prompt-cache-fields)에서 동일한 수를 읽을 수 있습니다.

#### 요금제 사용량 분석

Pro, Max, Ultra, Team 또는 Enterprise 요금제에서 `/usage`는 요금제 한도에 포함되는 항목의 분석과 권장 사항도 표시합니다:

* **Attribution**: skills, subagents, plugins 및 개별 MCP 서버에 귀속된 최근 사용량이며, 각각은 전체의 백분율로 표시됩니다. MCP 서버의 공유는 해당 도구 결과 중 하나를 사용한 요청만 계산합니다. v2.1.222 이전에는 MCP 서버에 대한 한 번의 호출 후 Claude Code는 모든 후속 요청을 해당 서버에 귀속시켜 공유를 과대 계산했습니다.
* **Recommendations**: 제안된 변경 사항이며, 행마다 하나씩 표시됩니다. 각 행은 `25%  Trim ~/code/api/CLAUDE.md · 49k tokens per request`와 같이 최근 사용량의 비율(최소 10%)로 시작합니다.
  * **비율을 읽는 방법**: 이 비율은 변경으로 절약되는 양이 아니라 해당 행이 적용되는 사용량이 얼마인지를 나타냅니다. 하나의 요청이 여러 행에 포함될 수 있으므로 비율의 합계가 100%를 넘을 수 있습니다.
  * **권장 사항을 적용하는 방법**: Claude Code가 적용할 수 있는 권장 사항을 적용하도록 하려면 [수정 단축키로 권장 사항 적용](#apply-recommendations-with-the-fix-shortcut)을 참조하십시오
* **Loops**: 최근에 실행된 가장 무거운 [`/loop` 또는 기타 세션 범위 예약 작업](https://code.claude.com/docs/ko/scheduled-tasks)마다 하나의 행이며, 총 토큰 순으로 정렬되고 나머지 수가 함께 표시됩니다. Claude Code v2.1.242 이상이 필요합니다.
  * **각 행이 보고하는 내용**: 작업이 실행되는 빈도, 실행된 횟수, 총 토큰 및 실행당 토큰, 마지막 실행 시간
  * **중지 후 다시 생성한 루프**: Claude Code는 작업의 프롬프트를 키로 행을 구분하므로 중지하고 다시 생성한 루프는 한 행으로 유지됩니다

`d` 또는 `w`를 눌러 지난 24시간과 지난 7일 사이를 전환합니다. 수치는 근사치이며 이 기기의 로컬 세션 기록에서 계산되므로 다른 기기 또는 claude.ai의 사용량은 포함되지 않습니다.

[VS Code 확장](https://code.claude.com/docs/ko/vs-code.md#check-account-and-usage)에서 귀속 공유 및 권장 사항은 Loops 행 없이 Day 및 Week 토글이 있는 Account & usage 대화 상자에 나타납니다.

#### 수정 단축키로 권장 사항 적용

`/usage` 하단에 `f to fix 2 of 3`과 같은 힌트가 표시되면 `f`를 눌러 Claude Code가 처리할 수 있는 권장 사항을 적용하도록 할 수 있습니다. `f` 단축키는 Claude Code v2.1.305 이상이 필요합니다.

1. 진행 중인 턴이 끝난 후, Claude Code는 행에 `run` 없이 표시된 각 [`/effort`](https://code.claude.com/docs/ko/model-config#adjust-effort-level) 명령을 실행합니다.
2. 그런 다음 Claude는 처리할 수 있는 나머지 각 행에 대한 단계가 담긴 하나의 프롬프트를 받습니다. 이 프롬프트는 Claude에게 각 변경을 적용하기 전에 사용자에게 먼저 보여 주도록 요청합니다.

`f`를 눌렀을 때 각 행에서 어떤 일이 일어나는지 확인하려면 첫 번째 열에서 해당 행의 형태를 찾으십시오:

| 행 형태 | 예시 행 | `f`를 누를 때 |
| :- | :- | :- |
| 앞에 `run`이 없는 `/effort` 명령으로 끝남 | `40%  Switch from max to high effort · /effort high` | Claude Code가 명령을 실행합니다 |
| `run`과 명령으로 끝남 | `30%  Compact before you step away · run /compact` | 이 행에 대해서는 아무 일도 일어나지 않습니다. Claude Code 프롬프트에서 직접 명령을 실행하십시오 |
| 그 외의 형태로 끝남 | `25%  Trim ~/code/api/CLAUDE.md · 49k tokens per request` | 이러한 행 중 일부에 대해서는 Claude가 프롬프트에서 단계를 받고, 나머지에 대해서는 아무 일도 일어나지 않습니다. Claude가 어떤 행에 대해 변경 사항을 보여 주지 않으면 해당 권장 사항을 직접 따르십시오 |

`f to fix 2 of 3`에서 첫 번째 숫자는 `f`를 눌렀을 때 Claude Code가 처리하는 행의 수이고, 두 번째 숫자는 표시된 행의 수입니다. `f to fix both`와 같이 `of`가 없는 힌트는 Claude Code가 표시된 모든 행을 처리한다는 의미입니다.

[Remote Control](https://code.claude.com/docs/ko/remote-control.md)이 연결되어 있는 동안에는 하단에 `f` 힌트가 표시되지 않습니다. `f`를 눌렀을 때 `Nothing was sent. Turn off Remote Control to use fixes.`와 함께 `/usage`가 닫히면 `/usage`가 열려 있는 동안 Remote Control이 연결된 것입니다. `f`를 다시 사용하려면 [Remote Control 연결을 해제](https://code.claude.com/docs/ko/remote-control.md#check-connection-status)한 다음 Claude Code 프롬프트에서 `/usage`를 실행하고 `f`를 다시 누르십시오.

#### 사용량 크레딧 지출 확인

`/usage`는 또한 [사용량 크레딧](#add-usage-credits-to-your-subscription)이 켜져 있는 동안 사용량 크레딧 행을 표시합니다. 행이 표시하는 내용은 요금제에 따라 다릅니다:

* **Pro, Max 및 Ultra**: 월간 지출 한도를 설정한 경우 월간 지출 한도에 대해 측정된 현재 월의 지출입니다. 한도를 설정하지 않았을 때, 행은 `Unlimited`를 표시하고 지출 수치는 표시하지 않습니다.
* **Team and Enterprise**: 귀하에게 적용되는 [조직이 설정한](#claude-for-teams-and-enterprise) 한도에 대해 측정된 현재 월의 자신의 지출입니다. 전체 조직을 다루는 한도는 행에 나타나지 않습니다. 자신의 한도가 없을 때, 행은 한도 없이 지출을 표시합니다. 사용량 크레딧이 귀하에게 꺼져 있는 동안, `/usage`는 사용량 크레딧 행을 표시하지 않습니다.

지출 한도가 있을 때, 행은 사용량 크레딧이 켜지자마자 나타나고 처음 사용량 크레딧을 지출할 때까지 0%를 표시합니다. v2.1.236 이전에는 `/usage`가 Pro, Max 및 Ultra 요금제에서만 행을 표시했으며, 지출 한도가 있는 행은 무언가를 지출할 때까지 숨겨져 있었습니다.

#### 사용량 요청이 실패할 때

요금제 한도에 대한 요청이 실패할 때(대부분 사용량 엔드포인트가 속도 제한되기 때문), `/usage`는 이 기기에서 지난 60분 이내에 로드한 마지막 사용량 막대를 표시하며, 해당 데이터를 얼마나 오래 전에 가져왔는지 나타내는 `Showing last-known usage` 메모가 함께 표시됩니다. `r`을 눌러 다시 시도하면, 성공적인 재시도는 마지막으로 알려진 막대를 새로운 데이터로 바꿉니다. 지난 60분 이내의 스냅샷이 없으면 `/usage`는 사용량 엔드포인트가 속도 제한되었다고 보고하고 동일한 재시도 단축키를 제공합니다. v2.1.208 이전에는 아직 사용량을 로드하지 않은 세션에서 속도 제한된 요청이 항상 막대 없이 오류를 표시했습니다.

`/usage`에 `rate limited until 3:14am`과 같은 메시지가 표시되면 Claude Code가 그 시각까지 요금제 한도를 다시 가져올 수 없다는 의미이며, Claude와의 작업이 제한된다는 의미는 아닙니다. 그 전에 `r`을 누르면 같은 메시지가 표시됩니다. 새로운 데이터를 보려면 해당 시각 이후에 `r`을 누르십시오.

### 스피너 옆의 토큰 수 읽기

Claude가 주 대화에서 작업하는 동안 스피너 옆의 줄은 `Deciphering… (10m 27s · ↓ 5.5k tokens)`와 같이 경과 시간과 토큰 수로 끝날 수 있습니다. 이는 현재 턴이 지금까지 생성한 출력의 실시간 근사치입니다. 수 옆의 화살표는 출력이 도착하거나 도구가 실행되는 동안 아래를 가리킵니다.

* **포함되는 항목**: Claude가 스트리밍하는 텍스트와 도구 호출, 사고, [포그라운드](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)에서 실행되는 서브에이전트의 출력 등 턴이 생성하는 출력
* **제외되는 항목**: Claude Code가 모델에 보내는 내용이므로 프롬프트, 대화 기록 및 나머지 컨텍스트는 이 수에 영향을 주지 않습니다
* **재설정 시점**: 각 턴이 시작될 때, 그리고 Claude Code가 [대화를 압축](https://code.claude.com/docs/ko/prompt-caching.md#compacting-the-conversation)할 때
* **숨겨지는 경우**: 출력이 도착하기 시작하기 전까지, 행이 너무 좁아 표시할 수 없을 때, 그리고 [스크린 리더 모드](https://code.claude.com/docs/ko/accessibility.md)에서

이 수는 `/usage` Session 블록의 `Usage by model` 출력 수치와 일치하지 않습니다. 해당 수치는 한 턴이 아닌 전체 세션을 합산하기 때문입니다. 또한 [verbose 모드가 추가하는](https://code.claude.com/docs/ko/statusline.md#notifications-share-the-status-line-row) 토큰 수와도 다릅니다. 그 수는 한 턴의 출력이 아닌 컨텍스트의 크기를 측정하기 때문입니다.

### 사용량 패턴 분석

[`/insights`](https://code.claude.com/docs/ko/commands#all-commands)를 실행하여 사용한 토큰 수가 아닌 작업 방식에 대한 보고서를 얻습니다. 이 기기의 최근 세션을 분석하고 작업 내용, 오해된 요청 또는 버그가 있는 코드와 같은 마찰 지점, Claude Code를 더 효과적으로 사용하기 위한 제안을 다루는 HTML 보고서를 작성합니다. 단일 실행은 이전에 보지 못한 최대 200개의 세션을 분석하고 매우 짧은 세션은 건너뜁니다. 세션이 제외될 때, 보고서 헤더는 분석된 수를 괄호 안의 총계와 함께 표시합니다. 예를 들어 `200 sessions (412 total)`입니다.

[auto mode](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)가 세션에서 사용 가능하고 최근 세션이 대부분 이를 사용하지 않고 실행되었을 때, 보고서는 또한 auto mode가 해당 세션에서 처리할 수 있었던 권한 프롬프트의 수에 대한 추정치를 포함할 수 있습니다.

Claude Code는 최신 보고서를 `~/.claude/usage-data/report.html`에 작성하고 각 실행의 타임스탬프가 지정된 사본을 동일한 디렉토리에 저장하므로 이전 보고서는 덮어쓰지 않습니다. Claude Code는 나머지 세션 데이터와 동일한 일정에 따라 보고서를 삭제합니다: 시작 시 [`cleanupPeriodDays`](https://code.claude.com/docs/ko/claude-directory#cleaned-up-automatically)보다 오래된 파일을 제거하며, 기본값은 30일입니다.

모든 요금제 및 모든 공급자에서 `/insights`를 실행할 수 있습니다. 분석은 일반 세션과 동일한 공급자 및 계정을 통해 실행되며, 토큰은 요금제 또는 API 사용량에 포함됩니다. 다른 기기 및 claude.ai의 세션은 포함되지 않습니다.

### 구독에 사용량 크레딧 추가

[사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)을 사용하면 요금제의 사용량 한도를 초과하여 계속 작업할 수 있습니다. 이를 관리하려면 `/login`을 통해 claude.ai 구독으로 로그인한 후 `/usage-credits`를 실행하십시오. 이 명령은 API 키 인증에서는 사용할 수 없습니다. 셀프 서비스 Enterprise 조직, Enterprise 평가판 및 AWS Marketplace를 통해 청구되는 Enterprise 조직에서 이 명령은 Claude Code v2.1.248 이상이 필요합니다. 이전 버전은 [`Unknown command: /usage-credits`](https://code.claude.com/docs/ko/errors#unknown-command)로 거부합니다. 열리는 내용은 역할에 따라 다릅니다:

| 역할 | `/usage-credits`가 수행하는 작업 |
| :- | :- |
| Pro, Max 또는 Ultra 구독자 | 브라우저에서 claude.ai의 [**Settings > Usage**](https://claude.ai/settings/usage)를 엽니다. **Usage credits** 섹션에서 사용량 크레딧을 켜거나 끌 수 있으며 크레딧 잔액, 이번 달의 지출 및 월간 지출 한도를 확인할 수 있습니다 |
| 청구 액세스 권한이 있는 Team 또는 Enterprise 구성원 | 브라우저에서 조직의 사용량 설정인 [**Organization settings > Usage**](https://claude.ai/admin-settings/usage)를 엽니다 |
| 청구 액세스 권한이 없는 Team 또는 Enterprise 구성원 | 확인을 요청한 후 조직의 관리자에게 요청을 보냅니다. v2.1.211 이전에는 Claude Code가 확인 단계 없이 요청을 보냈습니다 |

청구 액세스 권한이 없는 Team 및 Enterprise 구성원의 경우, 확인은 대화형 세션에서만 나타납니다: `-p` 플래그가 있는 비대화형 모드 및 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)에서 명령은 요청을 보내지 않으며 대화형 세션에서 실행하도록 지시합니다.

이전 요청이 관리자를 기다리는 동안 `/usage-credits`를 다시 실행하면, Claude Code는 중복을 보내지 않고 요청이 이미 전송되었다고 알려줍니다. 관리자가 요청을 거부한 후 명령을 다시 실행하면 새 요청을 보냅니다. v2.1.222 이전에는 거부된 요청도 새 요청을 차단했습니다.

Pro 및 Max 요금제에서 사용량 크레딧이 여전히 사용 가능한 상태에서 지출 한도에 도달하면, Claude Code는 CLI를 떠나지 않고 한도를 높이거나 제거하도록 메시지를 표시합니다. 서버가 변경을 거부하면 [Could not update your spend limit](https://code.claude.com/docs/ko/errors.md#could-not-update-your-spend-limit)를 참조하십시오.

## 조직의 비용 관리

사용할 수 있는 제어 방식은 조직이 Claude Code에 접근하는 방법에 따라 다릅니다. Claude for Teams 또는 Enterprise 플랜, Claude Console, 클라우드 제공업체 중 어떤 방식을 사용하는지에 따라 달라집니다. Teams 및 Enterprise 플랜에서는 사용량이 각 구성원의 시트 할당량에서 차감됩니다. Console과 클라우드 제공업체에서는 사용량이 토큰 단위로 조직에 청구됩니다. 조직에서 여러 로그인 방식을 혼용하는 경우 각 개발자의 사용량은 해당 개발자가 인증한 방식에 따라 측정됩니다.

아래 표는 각 설정별로 지출을 확인하는 위치, 지출 상한을 설정하는 위치, 사용자별 수치를 가져오는 방법을 정리한 것입니다. 개인 Pro, Max 또는 Ultra 플랜에서는 관리할 조직이 없으므로 [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md#see-where-fast-mode-spend-appears)를 포함한 본인의 사용량 크레딧 지출은 [구독에 사용량 크레딧 추가](#add-usage-credits-to-your-subscription)에서 추적합니다.

| 설정 | 지출 확인 | 지출 상한 설정 | 사용자별 보고 |
| :- | :- | :- | :- |
| [Claude for Teams 또는 Enterprise](#claude-for-teams-and-enterprise) | [조직 분석의 지출 보고서](https://support.claude.com/en/articles/12883420-view-usage-analytics-for-team-and-enterprise-plans) | 관리자 설정의 지출 한도 | [지출 보고서 CSV](https://support.claude.com/en/articles/12883420-view-usage-analytics-for-team-and-enterprise-plans), Enterprise의 경우 [Enterprise Analytics API](https://platform.claude.com/docs/en/api/admin/analytics) |
| [Claude Console (API)](#claude-console) | [Console 사용량 페이지](https://platform.claude.com/usage) | 워크스페이스 지출 한도 | [Console 대시보드](https://platform.claude.com/claude-code), [Claude Code Analytics API](https://platform.claude.com/docs/en/build-with-claude/claude-code-analytics-api) |
| [Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry](#cloud-providers) | 클라우드 청구 콘솔 | 클라우드의 예산 제어 | [OpenTelemetry](https://code.claude.com/docs/ko/monitoring-usage.md) 또는 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) |

[OpenTelemetry 내보내기](https://code.claude.com/docs/ko/monitoring-usage.md)는 모든 설정에서 작동하며, 사용자별 토큰 및 비용 메트릭을 거의 실시간으로 자체 관측성 스택에 스트리밍하는 유일한 옵션입니다.

### 계약 요금으로 지출 보고

기본적으로 Claude Code는 개발자에게 표시하는 모든 비용 수치를 정가 기준으로 계산하므로, 조직이 계약 요금을 지불하는 경우 `/usage`, 상태줄, OpenTelemetry의 수치가 청구서와 일치하지 않습니다. 수치를 일치시키려면 [`modelPricing`](https://code.claude.com/docs/ko/settings-reference#modelpricing) 관리형 설정을 조직의 요금으로 설정합니다. 이 설정은 Claude Code가 보고하는 내용을 변경할 뿐, Anthropic이 청구하는 금액을 변경하지는 않습니다. Claude Code v2.1.242 이상이 필요합니다.

**1. 계약서에서 요금 확인**

계약서에 명시된 백만 토큰당 요금을 입력합니다. Claude Code는 Claude Console에서 요금을 가져오지 않으므로 계약이 변경되면 설정을 업데이트해야 합니다.

**2. 설정 작성**

일괄 할인을 적용하려면 `multiplier`를 1 미만으로, 할증을 적용하려면 1 초과로 설정하거나, `overrides` 아래에 각 모델의 토큰당 요금 네 가지를 나열하거나, 두 가지를 모두 사용합니다. 할증을 적용하려면 Claude Code v2.1.271 이상이 필요합니다. [`modelPricing` 항목](https://code.claude.com/docs/ko/settings-reference#modelpricing)에서 형식과 바로 붙여 넣을 수 있는 예제를 확인할 수 있습니다.

**3. 관리형 설정을 통해 배포**

[관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)으로 배포합니다. 서버 관리형 설정, MDM 정책, `managed-settings.json` 또는 [정책 헬퍼](https://code.claude.com/docs/ko/managed-settings.md#compute-the-policy-with-a-helper-program)를 사용할 수 있습니다. Claude Code는 사용자, 프로젝트, 로컬 설정과 `--settings`에 있는 이 키를 무시합니다.

요금이 적용되었는지 확인하려면 [관리형 설정을 수신한](https://code.claude.com/docs/ko/managed-settings.md#read-the-source-in-%2Fstatus) 세션에서 `/usage`를 실행합니다. Session 블록의 `Total cost` 줄에 `at your organization's configured rates`라는 메모가 표시됩니다. 이 수치는 여전히 추정치이며 청구서가 아닙니다. `/model` 선택기의 백만 토큰당 가격은 정가로 유지됩니다.

### Claude for Teams 및 Enterprise

Claude for Teams 및 Enterprise 플랜에서는 각 구성원의 Claude Code 사용량이 시트별 할당량에서 차감되며, 이 할당량은 5시간 단위의 롤링 기간과 주간 기간에 따라 재설정됩니다. 할당량은 Claude 채팅 및 Cowork와 공유되며, 크기는 구성원의 [시트 등급](https://support.claude.com/en/articles/11845131-use-claude-code-with-your-team-or-enterprise-plan)(Standard 또는 Premium)에 따라 달라집니다. 제어 기능은 Claude Console이 아닌 claude.ai 관리자 콘솔에 있습니다.

* **지출 확인**: [조직 분석의 지출 보고서](https://support.claude.com/en/articles/12883420-view-usage-analytics-for-team-and-enterprise-plans)는 사용자별 및 모델별 예상 지출을 보여 주며, CSV로 내보낼 수 있고 매일 업데이트됩니다. 이 보고서는 사용량 크레딧 지출을 다루며 사용량 크레딧을 켜면 표시됩니다. 시트 할당량 내의 사용량은 달러로 측정되지 않습니다.
* **도입 현황 확인**: [분석 대시보드](https://claude.ai/analytics/claude-code)는 일일 활성 사용자, 세션, 기여 메트릭을 보여 주며, 기여 데이터를 CSV로 내보낼 수 있습니다. [분석으로 팀 사용량 추적](https://code.claude.com/docs/ko/analytics.md)을 참조하세요.
* **지출 상한 설정**: 시트 할당량이 기본 상한입니다. 구성원이 할당량을 초과해서 계속 사용할 수 있게 하려면 [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)을 켜고 조직, 그룹 또는 개별 구성원 수준에서 지출 한도를 설정합니다.
* **사용자별 수치 가져오기**: Enterprise 플랜에서는 [Enterprise Analytics API](https://platform.claude.com/docs/en/api/admin/analytics)가 Claude Code를 포함한 모든 Claude 사용 환경의 사용자별 사용량 및 비용 보고서를 반환합니다. Primary Owner가 [claude.ai/analytics/api-keys](https://claude.ai/analytics/api-keys)에서 `read:analytics` 범위를 가진 키를 생성합니다. Teams 플랜에서는 사용자별 및 모델별 토큰 사용량과 예상 지출이 나열된 [지출 보고서 CSV](https://support.claude.com/en/articles/12883420-view-usage-analytics-for-team-and-enterprise-plans)를 내보냅니다.

[Claude Enterprise 소비 가이드](https://support.claude.com/en/articles/14782391-claude-enterprise-consumption-guide)는 관리자를 위한 계획 참고 자료입니다. Claude 채팅, Claude Code, Cowork 간에 소비가 어떻게 다른지 설명하고, 예산 수립을 위한 사용자당 달러 기준점을 제공합니다. 코딩 시트에는 채팅 시트보다 더 많은 예산을 책정해야 합니다. Claude Code의 각 턴에는 파일 내용, 도구 호출, 다단계 추론이 포함되므로 디버깅 세션 하나가 하루 분량의 채팅보다 더 많이 소비될 수 있습니다.

### Claude Console

API 조직은 [워크스페이스](https://platform.claude.com/docs/en/build-with-claude/workspaces)를 통해 Claude Code 지출을 관리합니다. Console에서 전체 Claude Code 지출에 대한 [워크스페이스 지출 한도를 설정](https://platform.claude.com/docs/en/build-with-claude/workspaces#workspace-limits)하고 [비용 및 사용량 보고서를 확인](https://platform.claude.com/docs/en/build-with-claude/workspaces#usage-and-cost-tracking)할 수 있습니다.

> [!NOTE]
>
> Claude Console 계정으로 Claude Code를 처음 인증하면 "Claude Code"라는 워크스페이스가 자동으로 생성됩니다. 이 워크스페이스는 조직 내 모든 Claude Code 사용량에 대한 중앙 집중식 비용 추적 및 관리를 제공합니다. 이 워크스페이스에서는 API 키를 생성할 수 없으며, Claude Code 인증 및 사용 전용입니다.
>
> 사용자 지정 속도 제한이 있는 조직의 경우, 이 워크스페이스의 Claude Code 트래픽은 조직 전체의 API 속도 제한에 포함됩니다. Claude Console에서 이 워크스페이스의 Limits 페이지에 [워크스페이스 속도 제한](https://platform.claude.com/docs/en/api/rate-limits#setting-lower-limits-for-workspaces)을 설정하면 Claude Code의 점유율을 제한하고 다른 프로덕션 워크로드를 보호할 수 있습니다.

사용자별 보고의 경우, [Console 대시보드](https://platform.claude.com/claude-code)는 구성원별 지출과 수락된 줄 수를 보여 주며, [Claude Code Analytics API](https://platform.claude.com/docs/en/build-with-claude/claude-code-analytics-api)는 [Admin API 키](https://platform.claude.com/settings/admin-keys)를 사용해 동일한 일일 사용자별 메트릭을 프로그래밍 방식으로 반환합니다. [API 고객을 위한 분석](https://code.claude.com/docs/ko/analytics.md#access-analytics-for-api-customers)을 참조하세요.

#### 속도 제한 권장 사항

팀을 위해 Claude Code를 설정할 때는 조직 규모에 따른 다음의 사용자당 분당 토큰 수(TPM) 및 분당 요청 수(RPM) 권장 사항을 고려하세요.

| 팀 규모 | 사용자당 TPM | 사용자당 RPM |
| - | - | - |
| 1-5명 | 200k-300k | 5-7 |
| 5-20명 | 100k-150k | 2.5-3.5 |
| 20-50명 | 50k-75k | 1.25-1.75 |
| 50-100명 | 25k-35k | 0.62-0.87 |
| 100-500명 | 15k-20k | 0.37-0.47 |
| 500명 이상 | 10k-15k | 0.25-0.35 |

예를 들어 사용자가 200명이라면 사용자당 20k TPM, 즉 총 400만 TPM(200\*20,000 = 400만)을 요청할 수 있습니다.

규모가 큰 조직일수록 Claude Code를 동시에 사용하는 사용자가 적은 경향이 있으므로 팀 규모가 커질수록 사용자당 TPM이 줄어듭니다. 이러한 속도 제한은 개별 사용자가 아닌 조직 수준에서 적용되므로, 다른 사용자가 서비스를 활발히 사용하지 않을 때는 개별 사용자가 계산된 몫보다 일시적으로 더 많이 사용할 수 있습니다.

> [!NOTE]
>
> 대규모 그룹을 대상으로 한 실시간 교육 세션처럼 동시 사용량이 비정상적으로 높은 상황이 예상된다면 사용자당 더 높은 TPM 할당이 필요할 수 있습니다.

### 클라우드 제공업체

Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry에서는 Claude Code 사용량이 토큰 단위로 클라우드 계정에 청구되며, 지출 제어는 클라우드 제공업체의 청구 콘솔에서 이루어집니다. Claude Code는 클라우드의 메트릭을 Anthropic으로 다시 전송하지 않으므로 [분석 대시보드](https://code.claude.com/docs/ko/analytics.md)와 Claude Code Analytics API는 이 사용량을 다루지 않습니다.

사용자별 비용 귀속을 위한 옵션은 세 가지입니다.

* **OpenTelemetry**: 각 개발자의 머신에서 자체 관측성 스택으로 [메트릭을 내보냅니다](https://code.claude.com/docs/ko/monitoring-usage.md). 제공업체와 관계없이 사용자별 토큰 수, 비용, 도구 활동을 확인할 수 있습니다.
* **Claude apps 게이트웨이**: 자체 호스팅하는 [Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)는 이러한 제공업체에서 사용자별 사용량 귀속, 토큰 수가 포함된 OTLP 메트릭, [사용자별 지출 한도](https://code.claude.com/docs/ko/claude-apps-gateway-spend-limits.md)를 제공합니다.
* **LLM 게이트웨이**: 모든 Claude Code 트래픽을 키별 지출을 추적하는 프록시를 통해 라우팅합니다. 여러 대기업에서 [키별 지출을 추적](https://docs.litellm.ai/docs/proxy/virtual_keys#tracking-spend)하는 오픈 소스 도구인 [LiteLLM](https://code.claude.com/docs/ko/llm-gateway)을 사용한다고 보고했습니다. 이 프로젝트는 Anthropic과 관련이 없으며 보안 감사를 받지 않았습니다.

### 개발자가 한도에 대해 문의하는 경우

개발자는 보통 한도 관련 질문을 관리자에게 가져오므로, 개발자가 어떤 상한에 도달했는지 파악하는 것이 도움이 됩니다. 다음 상황은 각각 다른 의미를 갖습니다.

* **"You've hit your session limit" 또는 "You've hit your weekly limit"**: 구독 플랜의 시트 기반 사용 기간으로, 모든 모델에서 공유되므로 개발자가 `/model`로 모델을 전환해도 접근을 복구할 수 없습니다. 메시지에 기간이 재설정되는 시점이 표시됩니다. 모델별 메시지인 "You've hit your Opus limit" 또는 "You've hit your Sonnet limit"이 표시된 후에는 `/model`로 해당 계열 외의 모델로 전환하면 개발자가 작업을 계속할 수 있습니다. [사용 한도 오류](https://code.claude.com/docs/ko/errors.md#youve-hit-your-session-limit)를 참조하세요. 그동안 개발자가 할 수 있는 작업은 다음과 같습니다.
  * [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)이 켜져 있다면 `/usage-credits`를 실행해 할당량을 초과하는 사용량을 요청합니다.
  * Claude Code v2.1.234 이상에서는 [대기한 후 재설정 시 중단된 작업을 자동으로 계속](https://code.claude.com/docs/ko/interactive-mode.md#wait-for-a-usage-limit-to-reset)할 수 있습니다. 해당 섹션에는 Claude Code가 자체적으로 대기를 시작하는 경우와 개발자가 `/rate-limit-options`에서 선택하는 경우가 나와 있습니다. 전체 환경에서 Claude Code가 자체적으로 대기를 시작할지 여부를 제어하려면 [관리형 설정](https://code.claude.com/docs/ko/settings.md#settings-precedence)에서 [`autoContinueAtUsageLimit`](https://code.claude.com/docs/ko/settings-reference#autocontinueatusagelimit)를 설정합니다.
* **"You've hit your individual spend limit", "org's monthly spend limit" 또는 "team's shared budget"**: 개발자의 요청이 사용량 크레딧으로 청구될 예정이었으나, 해당 크레딧이 관리자가 설정한 지출 한도에 도달한 것입니다. 개발자가 계속 사용할 수 있게 하려면 [**Organization settings > Usage**](https://claude.ai/admin-settings/usage)로 이동해 메시지에 명시된 한도를 늘립니다. 메시지에 플랜 재설정 시간도 명시되어 있다면 개발자는 대신 그때까지 기다릴 수 있습니다. 각 변형은 [오류 참조](https://code.claude.com/docs/ko/errors.md#youve-hit-your-monthly-spend-limit)를 참조하세요.
* **[Claude apps 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)의 지출 한도 메시지**: 개발자가 자체 호스팅 게이트웨이에 설정된 지출 상한을 초과한 것으로, 기간이 재설정되거나 관리자가 상한을 올릴 때까지 게이트웨이가 해당 개발자의 요청을 차단합니다. 상한, 재설정 일정, 개발자에게 표시되는 메시지는 [게이트웨이 지출 한도](https://code.claude.com/docs/ko/claude-apps-gateway-spend-limits.md)를 참조하세요.
* **컨텍스트 또는 자동 압축 경고**: 사용 한도가 아닙니다. 대화가 세션의 [자동 압축 윈도우](https://code.claude.com/docs/ko/model-config.md#set-the-auto-compact-window), 즉 Claude Code가 공간을 확보하기 위해 이전 기록을 요약하는 임계값에 가까워진 것입니다. 개발자에게 [토큰 사용량 줄이기](#reduce-token-usage)를 안내합니다.
* **API 또는 클라우드 제공업체 플랜에서 예상보다 높은 지출**: 대개 한 번도 지우지 않은 긴 세션이나 기본 모델로 남아 있는 Opus가 원인입니다. 공유하기에 가장 효과적인 습관은 관련 없는 작업 사이에 대화를 지우는 것과 작업에 맞는 모델을 선택하는 것이며, 두 가지 모두 [토큰 사용량 줄이기](#reduce-token-usage)에서 다룹니다.

### 에이전트 팀 토큰 비용

[에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md)은 각각 고유한 컨텍스트 윈도우를 가진 여러 Claude Code 인스턴스를 생성합니다. 토큰 사용량은 활성 팀원 수와 각 팀원의 실행 시간에 비례해 증가합니다.

에이전트 팀 비용을 관리 가능한 수준으로 유지하려면 다음을 따르세요.

* 팀원에는 Sonnet을 사용합니다. 조정 작업에서 성능과 비용의 균형을 이룹니다.
* 팀 규모를 작게 유지합니다. 각 팀원은 자체 컨텍스트 윈도우를 실행하므로 토큰 사용량은 팀 규모에 대략 비례합니다.
* 생성 프롬프트를 간결하게 유지합니다. 팀원은 CLAUDE.md, MCP 서버, 스킬을 자동으로 로드하지만, 생성 프롬프트에 포함된 모든 내용은 처음부터 팀원의 컨텍스트에 추가됩니다.
* 작업이 끝난 팀원은 종료합니다. 각 활성 팀원은 종료되거나 세션이 끝날 때까지 계속 토큰을 소비합니다.
* 에이전트 팀은 기본적으로 비활성화되어 있습니다. 활성화하려면 [settings.json](https://code.claude.com/docs/ko/settings.md) 또는 환경에서 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`을 설정합니다. [에이전트 팀 활성화](https://code.claude.com/docs/ko/agent-teams.md#enable-agent-teams)를 참조하세요.

## 토큰 사용량 감소

토큰 비용은 컨텍스트 크기에 따라 확장됩니다. Claude가 처리하는 컨텍스트가 많을수록 더 많은 토큰을 사용합니다. Claude Code는 [프롬프트 캐싱](https://code.claude.com/docs/ko/prompt-caching.md)(시스템 프롬프트와 같은 반복되는 콘텐츠의 비용을 줄임)과 자동 압축(컨텍스트 한도에 접근할 때 대화 기록을 요약함)을 통해 비용을 자동으로 최적화합니다.

다음 전략은 컨텍스트를 작게 유지하고 메시지당 비용을 줄이는 데 도움이 됩니다.

### 컨텍스트를 사전에 관리하기

`/usage`를 사용하여 현재 토큰 사용량을 확인하거나, [상태줄을 구성](https://code.claude.com/docs/ko/statusline.md#context-window-usage)하여 지속적으로 표시하십시오.

* **작업 간 지우기**: 관련 없는 작업으로 전환할 때 `/clear`를 사용하여 새로 시작하십시오. 오래된 컨텍스트는 이후의 모든 메시지에서 토큰을 낭비합니다. 지우기 전에 `/rename`을 사용하여 나중에 세션을 쉽게 찾을 수 있도록 한 다음, `/resume`을 사용하여 돌아가십시오.
* **사용자 정의 압축 지침 추가**: `/compact Focus on code samples and API usage`는 Claude에게 요약 중에 보존할 내용을 알려줍니다.

프로젝트의 루트에 있는 CLAUDE.md 파일에서 압축 동작을 사용자 정의할 수도 있습니다:

```markdown theme={null}
# Compact instructions

When you are using compact, please focus on test output and code changes
```

### 올바른 모델 선택

Sonnet은 대부분의 코딩 작업을 잘 처리하며 Opus보다 비용이 적습니다. 복잡한 아키텍처 결정이나 다단계 추론을 위해 Opus를 예약하십시오. `/model`을 사용하여 세션 중간에 모델을 전환하거나, `/config`에서 기본값을 설정하십시오. Opus로 전환하면 [세션의 모델을 상속하는 서브에이전트](https://code.claude.com/docs/ko/model-config.md#setting-your-model)에도 적용됩니다. 간단한 서브에이전트 작업의 경우, [서브에이전트 구성](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)에서 `model: haiku`를 지정하십시오.

### MCP 서버 오버헤드 감소

MCP 도구 정의는 [기본적으로 연기됩니다](https://code.claude.com/docs/ko/mcp.md#scale-with-mcp-tool-search). 따라서 Claude가 특정 도구를 사용할 때까지 도구 이름과 서버 지침만 컨텍스트에 들어갑니다. `/context`를 실행하여 공간을 소비하는 것을 확인하십시오.

* **사용 가능한 경우 CLI 도구 선호**: `gh`, `aws`, `gcloud`, `sentry-cli`와 같은 도구는 도구별 목록을 추가하지 않기 때문에 여전히 MCP 서버보다 컨텍스트 효율적입니다. Claude는 CLI 명령을 직접 실행할 수 있습니다.
* **사용하지 않는 서버 비활성화**: `/mcp`를 실행하여 구성된 서버를 확인하고 적극적으로 사용하지 않는 것을 비활성화하십시오.

### 타입 언어를 위한 코드 인텔리전스 플러그인 설치

[코드 인텔리전스 플러그인](https://code.claude.com/docs/ko/plugins/code-intelligence.md)은 Claude에게 텍스트 기반 검색 대신 정확한 기호 탐색을 제공하여 낯선 코드를 탐색할 때 불필요한 파일 읽기를 줄입니다. 단일 "정의로 이동" 호출은 grep 다음에 여러 후보 파일을 읽는 것을 대체합니다. 설치된 언어 서버는 편집 후 자동으로 타입 오류를 보고하므로 Claude는 컴파일러를 실행하지 않고도 실수를 포착합니다.

### 훅 및 스킬로 처리 오프로드

사용자 정의 [훅](https://code.claude.com/docs/ko/hooks.md)은 Claude가 보기 전에 데이터를 전처리할 수 있습니다. Claude가 10,000줄 로그 파일을 읽어 오류를 찾는 대신, 훅은 `ERROR`를 grep하고 일치하는 줄만 반환하여 컨텍스트를 수만 개의 토큰에서 수백 개로 줄일 수 있습니다.

[스킬](https://code.claude.com/docs/ko/skills.md)은 Claude에게 도메인 지식을 제공하여 탐색할 필요가 없도록 할 수 있습니다. 예를 들어, "codebase-overview" 스킬은 프로젝트의 아키텍처, 주요 디렉토리 및 명명 규칙을 설명할 수 있습니다. Claude가 스킬을 호출하면, 구조를 이해하기 위해 여러 파일을 읽는 데 토큰을 소비하는 대신 즉시 이 컨텍스트를 얻습니다.

예를 들어, 이 PreToolUse 훅은 테스트 출력을 필터링하여 실패만 표시합니다:

> [tab] settings.json
>
> 이를 [settings.json](https://code.claude.com/docs/ko/settings.md#where-settings-live)에 추가하여 모든 Bash 명령 전에 훅을 실행하십시오:
>
> ```json theme={null}
> {
>   "hooks": {
>     "PreToolUse": [
>       {
>         "matcher": "Bash",
>         "hooks": [
>           {
>             "type": "command",
>             "command": "~/.claude/hooks/filter-test-output.sh"
>           }
>         ]
>       }
>     ]
>   }
> }
> ```

> [tab] filter-test-output.sh
>
> 훅은 이 스크립트를 호출합니다. `mkdir -p ~/.claude/hooks`로 폴더를 만들고, 아래 스크립트를 `~/.claude/hooks/filter-test-output.sh`로 저장한 다음, `chmod +x ~/.claude/hooks/filter-test-output.sh`로 실행 가능하게 만드십시오. 명령이 테스트 러너인지 확인하고 실패만 표시하도록 수정합니다:
>
> ```bash theme={null}
> #!/bin/bash
> input=$(cat)
> cmd=$(echo "$input" | jq -r '.tool_input.command')
>
> # If running tests, filter to show only failures
> pattern='^(npm test|pytest|go test)( [^;&|<>`$#\\[:cntrl:]]*)?$'
> if [[ "$cmd" =~ $pattern ]]; then
>   filtered_cmd="$cmd 2>&1 | grep -A 5 -E '(FAIL|ERROR|error:)' | head -100"
>   echo "$input" | jq --arg filtered "$filtered_cmd" \
>     '{hookSpecificOutput: {hookEventName: "PreToolUse", updatedInput: (.tool_input + {command: $filtered})}}'
> else
>   echo "{}"
> fi
> ```

설정을 확인하려면 `/hooks`를 실행하고 훅이 PreToolUse 아래에 나타나는지 확인하십시오. `claude --debug-file ./claude-debug.txt`로 Claude Code를 시작하고 Claude에게 `npm test`를 실행하도록 요청할 수도 있습니다. 훅이 명령을 다시 쓸 때, 해당 로그 파일에는 `command`와 다른 Bash 입력 필드를 나열하는 `modified tool input keys` 줄이 포함됩니다.

### CLAUDE.md에서 스킬로 지침 이동

[CLAUDE.md](https://code.claude.com/docs/ko/memory.md) 파일은 세션 시작 시 컨텍스트에 로드됩니다. PR 검토 또는 데이터베이스 마이그레이션과 같은 특정 워크플로에 대한 자세한 지침이 포함되어 있으면, 관련 없는 작업을 수행할 때도 해당 토큰이 존재합니다. [스킬](https://code.claude.com/docs/ko/skills.md)은 호출될 때만 필요에 따라 로드되므로, 특화된 지침을 스킬로 이동하면 기본 컨텍스트를 더 작게 유지합니다. CLAUDE.md를 필수 항목만 포함하여 200줄 이하로 유지하십시오.

### 확장 사고 조정

확장 사고는 기본적으로 활성화되어 있습니다. 복잡한 계획 및 추론 작업의 성능을 크게 향상시키기 때문입니다. 사고 토큰은 출력 토큰으로 청구되며, 기본 예산은 모델에 따라 요청당 수만 개의 토큰이 될 수 있습니다.

더 간단한 작업에서 깊은 추론이 필요하지 않은 경우, `/effort`를 사용하거나 `/model`에서 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)을 낮추거나, `/config`에서 사고를 비활성화하여 비용을 줄일 수 있습니다. Opus 5.5, Sonnet 5.5, Haiku 5.5 또는 Fable 모델에서는 사고를 끌 수 없으며, 항상 확장 사고를 사용합니다.

[고정 사고 예산](https://code.claude.com/docs/ko/model-config.md#adaptive-reasoning-and-fixed-thinking-budgets)이 있는 모델에서는 `MAX_THINKING_TOKENS` [환경 변수](https://code.claude.com/docs/ko/env-vars.md)를 설정하여 예산을 낮출 수도 있습니다(예: `MAX_THINKING_TOKENS=8000`). 적응형 추론 모델은 0이 아닌 예산을 무시하므로 대신 effort 수준을 사용하십시오.

### 자세한 작업을 서브에이전트에 위임

테스트 실행, 문서 가져오기 또는 로그 파일 처리는 상당한 컨텍스트를 소비할 수 있습니다. 이를 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#isolate-high-volume-operations)에 위임하여 자세한 출력이 서브에이전트의 컨텍스트에 유지되는 동안 요약만 주 대화로 반환되도록 하십시오.

서브에이전트의 자체 요청은 여전히 사용량을 소비합니다. 이에 대한 지출을 줄이려면, [서브에이전트에 더 작은 모델을 선택](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)하거나 [모든 서브에이전트를 하나의 모델에서 실행](https://code.claude.com/docs/ko/sub-agents.md#run-every-subagent-on-one-model)하십시오.

### 에이전트 팀 비용 관리

에이전트 팀은 팀원이 플랜 모드에서 실행될 때 표준 세션보다 약 7배 더 많은 토큰을 사용합니다. 각 팀원은 자체 컨텍스트 윈도우를 유지하고 별도의 Claude 인스턴스로 실행되기 때문입니다. 팀 작업을 작고 자체 포함되도록 유지하여 팀원당 토큰 사용량을 제한하십시오. 자세한 내용은 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md)을 참조하십시오.

### 구체적인 프롬프트 작성

"이 코드베이스 개선"과 같은 모호한 요청은 광범위한 스캔을 트리거합니다. "auth.ts의 로그인 함수에 입력 검증 추가"와 같은 구체적인 요청은 Claude가 최소한의 파일 읽기로 효율적으로 작업하도록 합니다.

### 복잡한 작업을 효율적으로 수행

더 길거나 복잡한 작업의 경우, 이러한 습관은 잘못된 경로로 인한 낭비된 토큰을 피하는 데 도움이 됩니다:

* **복잡한 작업에 플랜 모드 사용**: Shift+Tab을 눌러 구현 전에 [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에 들어가십시오. Claude는 코드베이스를 탐색하고 승인을 위한 접근 방식을 제안하여, 초기 방향이 잘못되었을 때 비용이 많이 드는 재작업을 방지합니다.
* **조기에 방향 수정**: Claude가 잘못된 방향으로 가기 시작하면, Escape를 눌러 즉시 중지하십시오. `/rewind`를 사용하거나 Escape를 두 번 눌러 대화 및 코드를 이전 체크포인트로 복원하십시오.
* **검증 대상 제공**: 테스트 케이스를 포함하고, 스크린샷을 붙여넣거나, 프롬프트에서 예상 출력을 정의하십시오. Claude가 자신의 작업을 검증할 수 있으면, 수정을 요청해야 하기 전에 문제를 포착합니다.
* **증분적으로 테스트**: 한 파일을 작성하고, 테스트한 다음, 계속하십시오. 이렇게 하면 문제를 조기에 포착할 수 있습니다.

## 백그라운드 토큰 사용량

세션 요약과 유휴 압축은 사용자가 유휴 상태일 때 토큰을 사용할 수 있습니다. 각 기능이 실행되는 시점과 끄는 방법은 [세션 요약](https://code.claude.com/docs/ko/interactive-mode.md#session-recap) 및 [유휴 압축](https://code.claude.com/docs/ko/settings-reference.md#idlecompaction)을 참조하십시오.

프롬프트 제안이 켜져 있으면, Claude Code는 Claude가 응답한 후 세션이 사용 중인 모델에 짧은 요청을 보내 [다음 프롬프트를 제안합니다](https://code.claude.com/docs/ko/interactive-mode.md#prompt-suggestions). 해당 요청은 대화의 프롬프트 캐시를 재사용하므로 대부분 캐시 읽기와 몇 가지 출력 토큰으로 구성됩니다. Claude Code는 [계정이 사용량 한도에 가깝거나 도달했을 때 제안을 건너뜁니다](https://code.claude.com/docs/ko/interactive-mode.md#when-claude-code-skips-suggestions). 이러한 요청을 중지하려면 [프롬프트 제안을 끕니다](https://code.claude.com/docs/ko/interactive-mode.md#turn-prompt-suggestions-off).

## 긴 세션에서 사용량이 증가하는 이유

몇 시간 동안 열려 있던 세션은 활동 수준보다 훨씬 더 많은 플랜 한도를 사용할 수 있으며, 일반적으로 다음 중 하나의 이유 때문입니다:

* **긴 컨텍스트**: Claude Code는 모든 요청과 함께 전체 대화를 전송하며, Claude가 도구를 사용할 때마다 해당 도구 결과 배치를 포함하는 또 다른 요청을 전송합니다. [프롬프트 캐싱](https://code.claude.com/docs/ko/prompt-caching.md)을 사용하면 Claude Code는 해당 기록을 [캐시된 토큰 요금](https://platform.claude.com/docs/en/about-claude/pricing)으로 다시 읽으므로, 하루 종일 열려 있던 세션의 한 줄 질문도 전체 대화에 대한 사용량을 소비합니다. 컨텍스트를 작게 유지하는 방법은 [컨텍스트 사전에 관리하기](#manage-context-proactively)를 참조하세요
* **캐시 미스**: [캐시 수명](https://code.claude.com/docs/ko/prompt-caching.md#cache-lifetime)보다 긴 휴식 후의 첫 번째 메시지는 캐시를 놓치고 전체 컨텍스트를 다시 처리합니다. [요청에 적용되는 수명](https://code.claude.com/docs/ko/prompt-caching.md#which-ttl-each-request-gets)과 [수명을 설정하는 제어 방법](https://code.claude.com/docs/ko/prompt-caching.md#choose-the-ttl-yourself)을 참조하세요
* **예약 작업**: [세션 범위 예약 작업](https://code.claude.com/docs/ko/scheduled-tasks.md)은 세션이 유휴 상태일 때도 해당 간격으로 실행되며, 매번 전체 컨텍스트를 전송합니다
* **세션 간 메시지**: Claude Code는 이 세션이 유휴 상태일 때 [다른 세션의 메시지](https://code.claude.com/docs/ko/cross-session-messaging.md)를 새로운 턴으로 전달하며, 매번 전체 컨텍스트를 전송합니다. 인바운드 메시지를 전달하지 않고 보류하려면 [`crossSessionInbound`](https://code.claude.com/docs/ko/settings-reference#crosssessioninbound)를 `hold`로 설정하세요
* **목표 체크인**: 백그라운드 작업이 활성 [목표](https://code.claude.com/docs/ko/goal.md)를 대기 상태로 유지하는 동안 Claude Code는 세션이 유휴 상태일 때도 [해당 작업을 확인하도록 Claude에 요청](https://code.claude.com/docs/ko/goal.md#background-work-defers-evaluation)하며, 전체 컨텍스트를 전송하는 새로운 턴을 시작합니다. Claude Code는 프롬프트 사이에 목표당 최대 3개의 유휴 체크인을 시작합니다. v2.1.246 이전에는 유휴 체크인이 무제한이었습니다. 체크인을 끄려면 [`CLAUDE_CODE_GOAL_CHECKIN_MINUTES`](https://code.claude.com/docs/ko/env-vars)를 `0`으로 설정하세요. 유휴 체크인에는 Claude Code v2.1.236 이상이 필요합니다
* **서브에이전트 및 워크플로우**: 모든 서브에이전트와 [동적 워크플로우](https://code.claude.com/docs/ko/workflows.md#cost)가 생성하는 모든 에이전트는 메인 대화 위에 자신의 요청을 전송합니다. [속성 분석](#plan-usage-breakdown)은 서브에이전트 점유율을 보여줍니다
* **에이전트 팀원**: 각 활성 [팀원](#agent-team-token-costs)은 종료될 때까지 계속 토큰을 소비합니다
* **압축**: `/compact`는 요약하는 대화를 읽으므로 [큰 컨텍스트 압축](https://code.claude.com/docs/ko/prompt-caching.md#compacting-the-conversation)은 그 자체로 큰 요청입니다. 연속성 대신 새로운 시작을 원할 때 `/clear`는 비용이 들지 않습니다

Pro, Max, Ultra, Team 또는 Enterprise 플랜에서 무엇을 변경해야 하는지 확인하려면 Claude Code 프롬프트에서 [`/usage`](#plan-usage-breakdown)를 실행하세요. 해당 분석은 최근 사용량의 10% 이상을 차지하는 동작에 대해 변경 사항을 권장합니다. 이러한 동작에는 긴 컨텍스트와 캐시 미스가 포함됩니다.

## Claude Code 동작 변경 사항 이해하기

Claude Code는 비용 보고를 포함한 기능 작동 방식을 변경할 수 있는 정기적인 업데이트를 받습니다. `claude --version`을 실행하여 현재 버전을 확인하십시오.

계정별 청구 관련 질문은 제품 내 메신저를 통해 Anthropic 지원팀에 문의하십시오:

* **구독 플랜**(Pro, Max, Ultra, Team, Enterprise): [claude.ai](https://claude.ai)에 로그인하여 왼쪽 아래의 이니셜을 클릭한 후 **Get help**를 선택하십시오
* **Console (API) 청구**: [platform.claude.com](https://platform.claude.com)에 로그인하여 이니셜을 클릭한 후 **Get help**를 선택하십시오

각 플랜에서 담당자와 연결할 수 있는 사람을 포함한 전체 절차는 [How to get support](https://support.claude.com/en/articles/9015913-how-to-get-support)를 참조하십시오.
