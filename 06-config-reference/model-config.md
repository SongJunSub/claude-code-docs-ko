> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 모델 구성

> Claude Code가 사용하는 모델, 노력 수준, 확장된 컨텍스트 및 자동 압축 윈도우를 구성합니다

## 사용 가능한 모델

Claude Code의 `model` 설정에서 다음 중 하나를 구성할 수 있습니다:

* **모델 별칭**
* **모델 이름**
  * Anthropic API: 전체 **[모델 이름](https://platform.claude.com/docs/en/about-claude/models/overview)**
  * Amazon Bedrock: 추론 프로필 ARN
  * Microsoft Foundry: 배포 이름
  * Google Cloud의 Agent Platform: 버전 이름

어떤 모델과 effort 수준이 다양한 종류의 작업에 적합한지에 대한 지침은 블로그의 [Claude Code에서 Claude 모델 및 effort 수준 선택하기](https://claude.com/blog/claude-model-and-effort-level-in-claude-code)를 참조하십시오.

> [!NOTE]
>
> `ANTHROPIC_BASE_URL`은 요청이 전송되는 위치를 변경하며, 어떤 모델이 응답하는지는 변경하지 않습니다. Claude를 LLM 게이트웨이를 통해 라우팅하려면 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 참조하십시오.

### 모델 별칭

모델 별칭을 사용하여 정확한 버전 번호를 기억하지 않고도 모델 설정을 선택합니다:

| 모델 별칭 | 동작 |
| - | - |
| **`default`** | 모든 모델 재정의를 지우고 [계정의 런타임 기본값](#default-model-setting)으로 되돌리는 특수 값입니다. 자체로는 모델 별칭이 아닙니다 |
| **`best`** | Fable을 사용할 수 있는 경우 [`fable` 별칭이 확인되는](#fable-alias-resolution) 모델을 사용하고, 그렇지 않으면 `opus`와 동일한 모델을 사용합니다 |
| **`fable`** | 가장 어렵고 오래 실행되는 작업을 위해 [공급자의 Fable 모델](#fable-alias-resolution)을 사용합니다 |
| **`sonnet`** | 일상적인 코딩 작업을 위해 최신 Sonnet 모델을 사용합니다 |
| **`opus`** | 복잡한 추론 작업을 위해 최신 Opus 모델을 사용합니다 |
| **`haiku`** | 간단한 작업을 위해 빠르고 효율적인 Haiku 모델을 사용합니다 |
| **`sonnet[1m]`** | 긴 세션을 위해 [100만 토큰 컨텍스트 윈도우](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)를 가진 Sonnet을 사용합니다. `sonnet`이 이미 기본 100만 윈도우를 가진 Sonnet 5.5 또는 Sonnet 5로 확인되는 경우 효과가 없습니다 |
| **`opus[1m]`** | 긴 세션을 위해 [100만 토큰 컨텍스트 윈도우](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)를 가진 Opus를 사용합니다. `opus`가 이미 기본 100만 윈도우를 가진 Opus 4.7 이상으로 확인되는 경우 효과가 없습니다 |
| **`opusplan`** | 플랜 모드 중에 `opus`를 사용한 다음 실행을 위해 `sonnet`으로 전환하는 특수 모드입니다 |

`opus`, `sonnet`, `haiku` 별칭은 Anthropic API에서는 최신 버전으로 확인되고, 일부 다른 공급자에서는 이전 버전으로 확인됩니다:

| 공급자 | `opus` | `sonnet` | `haiku` |
| :- | :- | :- | :- |
| Anthropic API | Opus 5.5 | Sonnet 5.5 | Haiku 5.5 |
| [AWS의 Claude Platform](https://code.claude.com/docs/ko/claude-platform-on-aws.md) | Opus 5.5 | Sonnet 4.6 | Haiku 4.5 |
| Amazon Bedrock, Google Cloud의 Agent Platform | Opus 5.5 | Sonnet 4.5 | Haiku 4.5 |
| Microsoft Foundry | Opus 4.6 | Sonnet 4.5 | Haiku 4.5 |

`ANTHROPIC_DEFAULT_FABLE_MODEL`을 설정하지 않으면 `fable` 별칭은 Fable 5.1로 확인됩니다. 단, [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 세션에서는 `fable` 및 `best`가 Fable 5로 확인됩니다.

`claude-fable-5-1`을 제공하도록 구성되지 않은 게이트웨이는 해당 모델에 대한 요청을 거부합니다. 이를 제공하는 게이트웨이를 통해 Fable 5.1을 사용하려면 `/model claude-fable-5-1`로 선택합니다.

`opus` 또는 `sonnet`이 이전 모델로 확인되는 경우, 전체 모델 이름을 명시적으로 선택하거나 `ANTHROPIC_DEFAULT_OPUS_MODEL` 또는 `ANTHROPIC_DEFAULT_SONNET_MODEL`을 설정하여 최신 모델을 사용할 수 있습니다.

이전 버전은 이러한 별칭을 이전 모델로 확인합니다. 각 별칭이 변경된 버전은 [버전 기록](#version-history)을 참조하십시오.

별칭은 공급자의 권장 버전을 가리키며 시간이 지남에 따라 업데이트됩니다. 특정 버전으로 고정하려면 전체 모델 이름(예: `claude-opus-5-5`)을 사용하거나 `ANTHROPIC_DEFAULT_OPUS_MODEL`과 같은 해당 환경 변수를 설정합니다.

> [!NOTE]
>
> Sonnet 5.5는 Claude Code v2.1.284 이상이 필요하고, Opus 5.5는 v2.1.280 이상이 필요합니다. 이전 버전에서 이들 중 하나에 대한 요청이 실패하면 [Claude Code는 이 모델을 지원하지 않습니다](https://code.claude.com/docs/ko/errors.md#claude-code-does-not-support-this-model)를 참조하십시오. Haiku 5.5에는 v2.1.293 이상을 사용합니다. `claude update`를 실행하여 업그레이드합니다.

### Fable 작업하기

[Claude Fable 5.1](https://platform.claude.com/docs/en/about-claude/models/overview) 및 Claude Fable 5는 Claude Code에서 가장 강력한 모델로, 한 번의 세션보다 큰 작업에 적합합니다. 이들은 긴 자율 세션을 유지하고, 행동하기 전에 조사하며, 더 작은 모델보다 더 자주 자신의 작업을 검증합니다. Fable 5.1은 더 최신 릴리스입니다.

두 Fable 모델 모두 어떤 플랜이나 공급자에서도 계정 유형 기본값이 아닙니다. 명시적으로 선택합니다:

* **Fable 5.1**: `/model fable`을 실행하거나 `claude --model fable`로 시작합니다. [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 세션에서 별칭이 Fable 5로 확인되는 경우 대신 `/model claude-fable-5-1`을 실행합니다.
* **Fable 5**: 모델 ID로 선택합니다. Anthropic API에서 `/model claude-fable-5`를 실행하거나 `claude --model claude-fable-5`로 시작합니다. 다른 공급자에서는 공급자의 Fable 5 모델 ID를 사용하거나 `ANTHROPIC_DEFAULT_FABLE_MODEL`로 [고정합니다](#pin-models-for-third-party-deployments).

Anthropic API에 직접 연결하고 사용자 설정에 모델로 `claude-fable-5` 또는 `claude-fable-5[1m]`이 있는 경우(예: v2.1.257 이전에 `/model` 선택기에서 Fable을 선택했기 때문), Claude Code는 v2.1.257 이상을 처음 실행할 때 저장된 값을 `fable` 또는 `fable[1m]` 별칭으로 변경합니다. 시작 모델 라인은 한 번 `(auto-updated)`를 표시합니다. 프로젝트, 로컬 또는 관리형 설정의 `claude-fable-5` 값은 그대로 유지됩니다.

Fable 모델의 안전 분류기가 플래그를 지정하는 요청(대부분 사이버 보안 및 생물학 도메인)은 [자동 모델 폴백](#automatic-model-fallback)을 트리거합니다.

Fable을 최대한 활용하려면:

* **결과를 설명하고 단계는 설명하지 마십시오**: 원하는 결과를 제공하고 경로를 계획하도록 합니다. 해당 결과를 향해 작업하도록 유지하려면 [목표를 설정합니다](https://code.claude.com/docs/ko/goal.md).
* **모호한 문제를 제공합니다**: 근본 원인 조사, 중단 디버깅, 아키텍처 결정은 추가 조사 및 검증이 가치 있는 곳입니다.
* **검증 알림을 건너뜁니다**: 자신의 작업을 더 적은 프롬프트로 검증하므로 테스트 또는 확인 알림은 일반적으로 불필요합니다.
* **더 큰 작업을 크기 조정합니다**: 일반적으로 조각으로 나누는 작업을 제공합니다. 긴 세션을 유지하면서 스레드를 잃지 않습니다.

> [!NOTE]
>
> Fable 5.1은 Claude Code v2.1.257 이상이 필요합니다. 이전 버전의 요청이 실패하면 [Claude Code는 이 모델을 지원하지 않습니다](https://code.claude.com/docs/ko/errors.md#claude-code-does-not-support-this-model)를 참조하십시오. `claude update`를 실행하여 업그레이드합니다. 영점 데이터 보존 하에서의 가용성은 [ZDR 하의 모델 가용성](https://code.claude.com/docs/ko/zero-data-retention.md#model-availability-under-zdr)을 참조하십시오.

Anthropic API에서 Fable 모델은 [`availableModels`](#restrict-model-selection) 또는 [조직 모델 제한](#organization-model-restrictions)이 이를 제외하지 않는 한 `/model` 선택기에 나타납니다. 조직이 [영점 데이터 보존](https://code.claude.com/docs/ko/zero-data-retention.md#model-availability-under-zdr) 하에서와 같이 Fable을 전혀 사용할 수 없는 경우, 행은 선택기에서 회색으로 표시되며 이유에 대한 참고 사항이 있습니다.

#### Fable 및 사용량 크레딧

플랜 및 시트 계층에 따라 Fable 사용은 플랜에 포함된 한도를 사용하는 대신 [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)으로 청구될 수 있습니다. 그렇게 되면 `/model` 선택기는 Fable 행에 "사용량 크레딧 필요"를 표시합니다. 사용량 크레딧을 관리하려면 [구독에 사용량 크레딧 추가](https://code.claude.com/docs/ko/costs.md#add-usage-credits-to-your-subscription)를 참조하십시오.

대화형 세션에서 Claude Code는 Fable 사용량 크레딧 동의 프롬프트를 표시할 수 있습니다. 조직 청구가 있는 Enterprise 플랜의 구성원은 프롬프트를 보지 않습니다. 사용량 크레딧을 사용하여 Fable을 계속하거나 기본 모델로 전환할 수 있습니다. 프롬프트를 해제할 수도 있습니다:

* `/model`로 Fable 모델을 선택하면 현재 모델을 유지합니다.
* 세션 중간에 Claude Code는 기본 모델에서 턴을 계속합니다.

사용량 크레딧을 사용하여 Fable을 계속하도록 선택한 후 Claude Code는 프롬프트를 다시 표시하지 않습니다.

[Remote Control](https://code.claude.com/docs/ko/remote-control.md)이 연결된 세션, [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md), 또는 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 팀원의 세션에서 터미널에 아무도 없을 수 있으므로 Claude Code는 [`dialogExpiry`](https://code.claude.com/docs/ko/settings-reference#dialogexpiry) 기한(기본값 5분)까지 세션 중간 동의 프롬프트를 유지합니다. 기한까지 아무도 응답하지 않으면 Claude Code는 요청을 보내지 않고 턴을 종료하고 트랜스크립트에 알림을 추가하며, Remote Control 클라이언트도 이를 표시합니다. 모델 선택은 변경되지 않으며 Claude Code는 다음 메시지에서 동의를 다시 요청합니다.

프롬프트가 대기 중인 동안 수행할 수 있는 작업은 세션에 따라 다릅니다:

* Remote Control이 연결되었거나 팀원의 세션에서 터미널의 아무 키나 눌러 기한을 취소하면 Claude Code는 답변을 기다립니다.
* 백그라운드 세션에서 기한 전에 답변합니다.
* 터미널에서 아무도 입력하기 전에 원격 클라이언트에서 새 메시지를 보내면 Claude Code는 같은 방식으로 턴을 종료하고 새 메시지가 다음 턴을 시작합니다. 누군가 터미널에 입력한 후 Claude Code는 답변을 기다리고 새 메시지를 뒤에 대기열에 넣습니다.

[Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)를 통해 다른 애플리케이션이 호스팅하는 세션에서 프롬프트가 나타나는지 여부는 해당 애플리케이션에 따라 다릅니다. 프롬프트가 나타나고 동일한 [`dialogExpiry`](https://code.claude.com/docs/ko/settings-reference#dialogexpiry) 기한까지 아무도 응답하지 않으면 Claude Code는 요청을 보내지 않고 턴을 종료합니다.

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 `-p` 플래그를 사용하고 프롬프트를 표시하지 않는 Agent SDK 애플리케이션에서 Claude Code는 동의를 요청하지 않습니다. Fable 요청이 사용량 크레딧으로 청구될 때 Claude Code는 묻지 않고 청구합니다.

### 모델 설정하기

여러 가지 방법으로 모델을 구성할 수 있으며, 우선순위 순서대로 나열됩니다:

1. **세션 중**: `/model <alias|name>`을 사용하여 즉시 전환하거나 인수 없이 `/model`을 실행하여 선택기를 엽니다. [Claude Code가 전환을 확인하도록 요청할 때](https://code.claude.com/docs/ko/prompt-caching.md#switching-models)를 참조하십시오
2. **시작 시**: `claude --model <alias|name>`으로 시작합니다
3. **환경 변수**: `ANTHROPIC_MODEL=<alias|name>`을 설정합니다
4. **설정**: `model` 필드를 사용하여 설정 파일에서 영구적으로 구성합니다
5. **[새 세션의 기본값](#set-a-default-model-for-new-sessions)**: `ANTHROPIC_DEFAULT_MODEL=<alias|name>`을 설정합니다

`/model`은 사용자 설정에서 `model` 필드를 작성하여 선택을 새 세션의 기본값으로 저장합니다. 선택기에서:

* `Enter`: 모델을 전환하고 기본값으로 저장합니다
* `s`: 이 세션에만 모델을 전환하고 기본값은 변경하지 않습니다. 다른 키를 사용하려면 [`modelPicker:thisSessionOnly`](https://code.claude.com/docs/ko/keybindings#model-picker-actions)를 다시 바인딩합니다

`/model <name>`을 직접 입력하는 것은 `Enter`처럼 동작합니다. 이 세션에만 전환하려면 `/model`로 선택기를 열고 모델의 행에서 `s`를 누릅니다.

Enterprise 플랜에서 claude.ai 계정으로 로그인하고 `/model`로 기본값을 저장하면 Claude Code는 해당 계정에도 선택을 기록합니다. Claude Code v2.1.280 이상이 필요합니다.

* 관리자가 [조직 기본 모델](#organization-default-model)을 설정하지 않았을 때 [Default 옵션](#default-model-setting)은 기록된 모델로 확인될 수 있으며, 그렇게 되면 선택기의 Default 행은 해당 모델의 이름을 표시합니다.
* [모델 제한](#restrict-model-selection)이 기록된 모델을 제외하거나 계정에서 사용할 수 없으며, 관리자가 조직 기본 모델을 설정하지 않았으면 Default 옵션은 아무것도 기록되지 않은 것처럼 확인됩니다.
* Default 또는 `opusplan`을 `/model`에서 선택하면 기록된 선택은 변경되지 않습니다.

`/model`로 모델을 전환하면 전환은 [주 대화의 모델을 상속하는 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)에도 도달합니다. Claude Code는 Claude가 서브에이전트를 시작할 때 세션이 사용 중인 모델에서 해당 모델을 확인하기 때문입니다. Claude가 연구 또는 테스트 실행을 서브에이전트 중 하나에 위임하기 전에 Opus로 전환하면 해당 작업도 Opus에서 실행됩니다. 사용자 정의 서브에이전트를 더 작은 모델에 유지하려면 해당 정의에서 `model`을 설정합니다.

[비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 `-p` 플래그를 사용하여 `/model`로 모델을 설정하면 현재 세션에만 적용되며 기본값으로 저장되지 않습니다. `/model`은 해당 모드에서 Claude Code v2.1.205 이상이 필요합니다. 프로젝트 및 관리형 설정은 여전히 우선 적용되며 다음 시작 시 다시 적용됩니다. 관리자가 사용자 선택을 재정의하도록 구성한 [조직 기본 모델](#organization-default-model)도 다음 시작 시 다시 적용됩니다.

v2.1.144부터 v2.1.152까지 `/model`은 현재 세션에만 적용되었고 선택기의 `d`는 기본값을 저장했습니다.

`--model` 플래그 및 `ANTHROPIC_MODEL` 환경 변수는 시작한 세션에만 적용됩니다. 동시에 다른 터미널에서 다른 모델을 실행하려면 `/model`로 전환하는 대신 각각 자신의 `--model` 플래그로 시작합니다.

`/model` 선택기의 가격은 Claude Code가 Anthropic API와 직접 또는 이를 프록시하는 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 통해 통신할 때 나타나며, 행의 가격은 해당 행이 선택하는 모델의 가격입니다. Amazon Bedrock과 같은 [타사 공급자](https://code.claude.com/docs/ko/third-party-integrations.md) 및 [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway)에서는 공급자 또는 게이트웨이가 지불하는 금액을 결정하므로 선택기 행은 가격을 표시하지 않습니다. 가격은 표시 레이블일 뿐이며, 행이 선택하는 모델이나 공급자가 청구하는 금액에 영향을 주지 않습니다. v2.1.206 이전에는 [AWS의 Claude Platform](https://code.claude.com/docs/ko/claude-platform-on-aws.md) 및 게이트웨이 세션이 Anthropic 정가를 표시했으며, 행은 선택하는 모델과 다른 모델의 가격을 표시할 수 있었습니다.

`claude --resume`, `--continue` 또는 `/resume` 선택기로 시작된 재개된 세션은 트랜스크립트가 저장되었을 때 사용 중이던 모델을 유지합니다. 복원된 모델이 폐기되었거나 [`availableModels`](#restrict-model-selection)에 의해 제외되면 세션은 정상 우선순위 순서로 폴백됩니다. Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry와 같이 Anthropic 모델 ID 대신 공급자별 배포 ID를 사용하는 공급자에서는 트랜스크립트 모델이 전혀 복원되지 않으며 세션은 정상 우선순위 순서를 통해 모델을 확인합니다.

`model` 설정이 `haiku`인 경우, Haiku 모델에서 저장된 세션은 현재 `haiku`가 확인되는 모델에서 재개됩니다. 예를 들어 `haiku`가 Haiku 5.5로 확인되면, Haiku 4.5에서 저장된 세션은 Haiku 5.5에서 재개됩니다.

새 시작을 위해 `--model` 또는 `ANTHROPIC_MODEL`로 선택한 모델은 여전히 복원된 모델보다 우선 적용됩니다. v2.1.195부터 [`ANTHROPIC_DEFAULT_OPUS_MODEL`](#environment-variables) 패밀리 변수도 마찬가지입니다. [`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions)도 해당 섹션에 나열된 조건 하에서 가능합니다.

시작 시 활성 모델이 자신의 선택이 아닌 프로젝트 또는 관리형 설정에서 나오면 시작 헤더는 어떤 설정 파일이 설정했는지 표시합니다. `/model`을 실행하여 재정의합니다. 프로젝트 또는 관리형 설정은 다음 시작 시 다시 적용됩니다. Claude Code를 포함하고 [`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](https://code.claude.com/docs/ko/env-vars)를 설정하는 플랫폼에서 호스트의 모델 구성은 관리형 모델 설정보다 우선 적용되며, 호스트가 자체 허용 목록을 제공하지 않으면 관리형 `availableModels` 허용 목록이 계속 적용됩니다. [관리형 설정 우선순위의 예외](https://code.claude.com/docs/ko/settings.md#exceptions-to-managed-settings-precedence)는 호스트가 재정의하는 키 및 변수를 나타냅니다.

사용자 또는 조직이 [PreModelSwitch 훅](https://code.claude.com/docs/ko/hooks.md#premodelswitch)을 구성하면 요청된 전환이 적용되기 전에 실행되며 이를 차단하거나 확인을 요청할 수 있습니다.

Claude Code가 조직의 [관리형 플러그인](https://code.claude.com/docs/ko/settings-reference.md#enabledplugins)이 제공하는 PreModelSwitch 훅을 알 수 없는 경우(예: 관리형 플러그인이 로드되지 않음), 확인되지 않은 상태로 적용하는 대신 전환을 거부하며, 각 새 시도에서 다시 확인합니다. [PreModelSwitch 훅에 의해 모델 전환이 차단되었습니다](https://code.claude.com/docs/ko/errors.md#model-switch-was-blocked-by-a-premodelswitch-hook)를 참조하여 메시지 및 복구를 확인합니다.

[Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md) `setModel()` 메서드를 통해 모델을 전환하거나 [Desktop 앱](https://code.claude.com/docs/ko/desktop.md)과 같은 앱에서, 또는 [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 통해 연결된 장치에서 Claude Code는 값을 전환할 때 확인합니다:

* **Agent SDK 또는 앱**: Claude Code v2.1.268 이상에서 Claude Code가 로컬에서 모델 ID를 수락하지 않으면(예: [사용자 정의 모델 옵션](#add-a-custom-model-option)의 경우), 세션이 처음 전환할 때 공급자와 ID를 확인합니다. 확인은 모든 공급자에서 실행되며, 공급자가 제공하지 않는 ID는 다음 요청에서 실패하는 대신 전환 시 거부됩니다.
* **Remote Control**: Anthropic API에서 Claude Code는 값을 로컬에서 확인하고 요청을 보내지 않습니다.

[모델은 인식된 모델 ID가 아닙니다](https://code.claude.com/docs/ko/errors.md#model-is-not-a-recognized-model-id) 및 [모델을 찾을 수 없습니다](https://code.claude.com/docs/ko/errors.md#model-not-found)를 참조하여 메시지를 확인합니다.

`--model` 플래그, `ANTHROPIC_MODEL` 환경 변수 또는 `model` 설정으로 모델을 설정하면 Claude Code는 미리 확인하지 않으며, 잘못 입력된 값은 첫 번째 요청에서 [선택된 모델에 문제가 있습니다](https://code.claude.com/docs/ko/errors.md#theres-an-issue-with-the-selected-model)를 생성합니다.

요청된 모델에 예정된 폐기 날짜가 있거나 자동으로 최신 버전으로 다시 매핑되면 Claude Code는 요청된 모델의 이름을 지정하는 경고를 표시합니다. 대화형 세션은 시작 알림으로 표시합니다. v2.1.182부터 기본 텍스트 출력 형식을 사용할 때 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)에서 동일한 경고가 stderr에 작성됩니다. 확인은 또한 [서브에이전트 frontmatter](https://code.claude.com/docs/ko/sub-agents.md)에 설정된 `model`을 다룹니다. stderr 경고는 `--output-format json` 및 `stream-json`에 대해 억제됩니다. 대신 [결과 메시지](https://code.claude.com/docs/ko/headless.md#get-structured-output)의 `modelUsage` 필드에서 실제 모델을 읽습니다.

예를 들어 Opus에서 세션을 시작합니다:

```bash theme={null}
claude --model opus
```

그런 다음 세션 내에서 모델을 전환합니다:

```text theme={null}
/model sonnet
```

예제 설정 파일:

```json theme={null}
{
    "permissions": {
        "allow": ["Bash(npm run lint)"]
    },
    "model": "opus"
}
```

#### 새 세션의 기본 모델 설정하기

`ANTHROPIC_DEFAULT_MODEL=<alias|name>`을 설정하여 세션이 기본적으로 시작되는 모델을 선택합니다. Claude Code v2.1.236 이상이 필요합니다.

Claude Code는 다음 중 어느 것도 모델을 선택하지 않을 때만 변수의 모델에서 새 세션을 시작합니다:

* `--model` 플래그
* `ANTHROPIC_MODEL`
* 모든 설정 파일의 `model` 값(`/model`로 저장한 선택 포함)
* [조직 기본 모델](#organization-default-model)

`/model`로 저장한 선택은 이후 시작에서도 변수보다 우선 적용됩니다. 대신 `ANTHROPIC_MODEL`이 설정되면 Claude Code는 `/model`로 저장한 것에 관계없이 다음 시작에서 해당 변수의 모델로 돌아갑니다.

Claude Code는 또한 조직 기본 모델이 적용되지 않으면 Default 옵션을 변수의 모델로 확인합니다. Default 옵션이 변수의 모델로 확인되면 `/model` 선택기의 Default 행은 Set by ANTHROPIC\_DEFAULT\_MODEL 레이블을 표시합니다.

Claude Code는 이 경우들에서 변수를 무시하며, Default 옵션은 설정하지 않은 것처럼 확인됩니다:

* `default`, `inherit`, `opusplan` 또는 `haiku`로 설정합니다
* [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model)이 켜져 있습니다
* 조직의 [모델 제한](#restrict-model-selection)이 모델을 제외합니다
* 모델을 계정에서 사용할 수 없습니다

새 세션이 변수의 모델에서 시작되는 경우, `claude --resume`, `--continue` 또는 `/resume` 선택기로 재개한 세션도 해당 모델에서 시작됩니다. Claude Code는 해당 세션의 트랜스크립트에 저장된 모델을 복원하지 않습니다. 그렇지 않으면 Claude Code는 [세션을 재개할 때](#setting-your-model) 변수를 사용하지 않습니다.

#### 새 세션이 선택한 것과 다른 모델에서 시작됩니다

`/model`로 모델을 선택했는데 다음 세션이 다른 모델에서 시작되는 경우, 일반적인 원인은 다음과 같습니다:

* **한 세션에만 선택했습니다.** 선택기에서 `s`를 누르고, `--model`로 시작하고, 비대화형 모드에서 `/model`을 실행하는 것은 모두 현재 세션에 적용되며 저장된 기본값을 그대로 둡니다.
* **더 높은 우선순위를 가진 것이 모델을 설정합니다.** 프로젝트 또는 관리형 설정의 `model` 값, 셸의 `ANTHROPIC_MODEL`, 또는 관리자가 사용자 선택을 재정의하도록 설정한 [조직 기본값](#organization-default-model)은 모든 시작에서 다시 적용됩니다. `/model` 선택은 여전히 저장되어 있으며, 더 높은 우선순위의 설정에 밀릴 뿐입니다. 프로젝트 또는 관리형 설정이 모델을 설정하면 시작 헤더가 파일의 이름을 표시합니다.
* **Claude Code가 선택을 저장할 수 없었습니다.** `/model`은 `~/.claude/settings.json`에 `model`을 작성합니다. 다른 도구가 생성하거나 읽기 전용 복사본에 연결하는 경우와 같이 해당 파일에 쓸 수 없으면 선택한 모델은 세션 동안 지속되고 다음 시작은 이전 값을 읽습니다. 파일을 생성하는 도구에서 `model`을 설정하거나 파일을 쓰기 가능하게 만듭니다. [Claude Code에서 만든 변경 사항이 새 세션에서 손실됩니다](https://code.claude.com/docs/ko/settings.md#a-change-you-made-in-claude-code-is-lost-in-new-sessions)를 참조하십시오.
* **세션을 재개했습니다.** `claude --resume` 또는 `--continue`로 재개한 세션은 일반적으로 현재 기본값이 아닌 [사용 중이던 모델을 유지합니다](#setting-your-model).

## 모델 선택 제한

관리자는 [관리형 또는 정책 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `availableModels`를 사용하여 사용자가 선택할 수 있는 모델을 제한할 수 있습니다. 항목은 `sonnet`과 같은 모델 패밀리, `claude-sonnet-4-5`와 같은 버전 접두사, 또는 `claude-sonnet-4-5-20250929`와 같은 전체 모델 ID와 일치합니다. 버전 접두사는 또한 다른 세그먼트로 확장하는 이후 모델 ID와도 일치하므로, `claude-fable-5`는 Fable 5와 Fable 5.1을 모두 허용하고, `claude-fable-5-1`은 Fable 5.1만 허용합니다. 목록이 허용하는 모델을 차단하거나 각 모델 ID 항목이 이름을 지정하는 버전만 허용하도록 하려면 [특정 모델 또는 버전 차단](#block-specific-models-or-versions)을 참조하세요.

Claude Code를 포함하고 [`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](https://code.claude.com/docs/ko/env-vars)를 설정하는 플랫폼에서는 호스트의 모델 구성이 관리형 모델 설정보다 우선하며, 관리형 `availableModels` 허용 목록은 호스트가 자체 목록을 제공하지 않는 한 계속 적용됩니다. [관리형 설정 우선순위의 예외](https://code.claude.com/docs/ko/settings.md#exceptions-to-managed-settings-precedence)는 호스트가 재정의하는 키와 변수를 설명합니다.

`availableModels`가 설정되면, 허용 목록은 사용자가 모델을 지정할 수 있는 모든 곳에 적용됩니다:

* **메인 세션 모델**: `/model`, `--model` 플래그, `ANTHROPIC_MODEL` 환경 변수, `model` 설정, [`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions), 그리고 [세션을 재개할 때](#setting-your-model) 복원되는 모델
* **별칭 해석**: `ANTHROPIC_DEFAULT_OPUS_MODEL`, `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`, 그리고 `ANTHROPIC_DEFAULT_FABLE_MODEL` 환경 변수는 허용된 별칭을 목록 외부의 모델로 리디렉션할 수 없습니다
* **빠른 모드**: `/fast`는 목록 외부의 Opus 모델로 암묵적으로 전환될 때 토글을 거부하며, "is not in your organization's allowed models" 메시지를 표시합니다
* **서브에이전트 및 팀원 모델**: [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model) 프론트매터의 `model` 필드, Agent 도구의 `model` 매개변수, [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md#specify-teammates-and-models) 팀원 모델, `CLAUDE_CODE_SUBAGENT_MODEL`, 그리고 v2.1.197 이전에는 `/agents` 마법사의 모델 선택기&#x20;
* **스킬 및 명령 모델**: [스킬 및 명령](https://code.claude.com/docs/ko/skills.md)의 `model` 프론트매터
* **어드바이저 모델**: 구성된 [`advisorModel`](https://code.claude.com/docs/ko/advisor) 설정 및 `--advisor` 플래그
* **백그라운드 에이전트 모델**: [디스패치 선택기](https://code.claude.com/docs/ko/agent-view.md)에서 선택된 모델

Anthropic API 및 [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md)에서, 모델 패밀리 별칭 `opus`, `sonnet`, `haiku`, 또는 `fable`은 허용 목록이 해당 모델을 허용할 때 일반적인 모델로 해석됩니다. 허용 목록이 해당 모델을 차단할 때, Claude Code는 허용 목록이 허용하는 패밀리의 최신 버전으로 대체하고 요청된 모델과 대체된 모델을 모두 이름 지정하는 알림을 표시합니다. 예를 들어 `["sonnet", "claude-opus-4-6"]`을 사용하면, `/model opus`와 `--model opus` 모두 허용된 최신 Opus인 Claude Opus 4.6을 선택합니다. v2.1.205 이전에는 최신 릴리스 버전이 목록 외부에 있는 별칭은 목록이 이전 버전을 허용했을 때도 다른 차단된 선택처럼 거부되거나 대체되었습니다.

대체는 착지할 수 있는 허용된 버전이 필요합니다: 허용 목록이 별칭의 패밀리의 버전을 허용하지 않을 때, 별칭은 다른 차단된 값처럼 아래의 거부 및 대체 동작을 따릅니다.

Claude Code는 모델이 설정된 위치에 따라 다른 차단된 선택을 처리합니다:

* **`/model`**: Claude Code는 스위치를 오류로 거부합니다
* **`--model` 플래그, `ANTHROPIC_MODEL`, 또는 `model` 설정**: Claude Code는 시작 시 값을 요청된 모델과 대체된 모델을 모두 이름 지정하는 경고와 함께 대체하고, 세션은 기본 모델에서 시작됩니다
* **[`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions)**: Claude Code는 변수를 무시합니다
* **서브에이전트 또는 팀원 재정의**: Claude Code는 요청을 실패하지 않고 서브에이전트 또는 팀원을 폴백 모델에서 실행합니다. 서브에이전트 폴백은 [모델 선택](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)을 참조하고 팀원 폴백은 [팀원 및 모델 지정](https://code.claude.com/docs/ko/agent-teams.md#specify-teammates-and-models)을 참조하세요.

  대화형 세션에서, Claude Code는 이 폴백 또는 위의 최신 허용 버전 대체로 서브에이전트의 모델을 대체할 때 요청된 모델과 대체된 모델을 이름 지정하여 경고합니다. 팀원의 폴백은 보고하지 않습니다.

  위의 최신 허용 버전 대체가 작동하는 경우, 차단된 패밀리 별칭은 대신 이를 따릅니다. v2.1.222 이전에는 별칭이 모든 제공자에서 다른 차단된 값처럼 폴백했습니다
* **스킬 또는 명령 재정의**: Claude Code는 차단된 패밀리 별칭을 포함한 재정의를 무시하고, 스킬 또는 명령은 세션 모델에서 실행됩니다. [서브에이전트에서 실행되는](https://code.claude.com/docs/ko/skills.md#run-skills-in-a-subagent) 스킬 또는 명령은 대신 위의 서브에이전트 동작을 따릅니다
* **`advisorModel` 설정**: 어드바이저는 세션에 대해 비활성화됩니다
* **`--advisor` 플래그**: Claude Code는 시작 시 오류로 종료됩니다. [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md)에서는 종료하지 않고 어드바이저 없이 세션을 시작합니다
* **`CLAUDE_CODE_AUTO_MODE_MODEL`**: Claude Code는 변수를 무시하고, 이 변수를 설정하지 않은 것처럼 [자동 모드 분류기 요청](https://code.claude.com/docs/ko/permission-modes.md#default-classifier-model)에 사용할 모델을 선택합니다

Claude Code는 `/model` 선택기에서 제외된 모델을 숨깁니다. 나열한 모델 ID가 자체 행도 갖는지는 제공자에 따라 다릅니다:

* **Anthropic API, [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md), [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway), 또는 `ANTHROPIC_BASE_URL`로 설정한 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)**: 나열한 Anthropic 모델 ID 중 기본 제공 선택기 행이 없는 ID는 자체 레이블이 지정된 행으로 나타납니다. Claude Code는 목록이 고정하는 이전 버전과 같은 Opus, Sonnet, Haiku 버전에 대해 이러한 행을 추가합니다. [`modelPicker`](https://code.claude.com/docs/ko/settings-reference#modelpicker) 라인업에서 `replaceBuiltInOptions`를 설정하면 해당 행은 나타나지 않습니다. v2.1.199 이전에는 이러한 ID는 `/model <id>`를 입력해야만 선택할 수 있었습니다.
* **Amazon Bedrock, Google Cloud의 Agent Platform, 또는 Microsoft Foundry**: 나열한 모델 ID가 `anthropic.`으로 시작하지 않는 한, Anthropic 모델 ID이든 제공자별 ID이든 Claude Code는 해당 ID에 대한 행을 추가하지 않습니다. [Mantle 모델 ID](#mantle-model-ids)는 이 접두사를 가집니다. 기본 제공 행이 없는 나열된 버전을 표시하려면, 제공자 형식의 ID를 허용하는 [`modelPicker`](https://code.claude.com/docs/ko/settings-reference#modelpicker) 라인업에도 추가하세요.

Claude Code가 사용자를 대신하여 수행하는 모델 변경은 동일한 방식으로 확인됩니다:

* **[폴백 모델 체인](#fallback-model-chains)**: 허용 목록 외부의 항목은 삭제됩니다
* **계획 모드 업그레이드**: Anthropic API 및 Claude Platform on AWS에서, [`opusplan`](#opusplan-model-setting)과 같은 업그레이드를 제외된 모델로 수행하면 업그레이드 패밀리의 최신 허용 버전을 사용합니다. 제공자별 모델 ID가 있는 제공자에서, 그리고 허용된 버전이 없을 때, 업그레이드는 건너뛰고 계획은 세션의 모델에서 계속됩니다
* **[자동 모델 폴백](#automatic-model-fallback)**: 대상이 제외된 폴백은 실행되지 않으므로, 플래그된 요청은 거부로 끝납니다
* **[자동 모드 분류기](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)**: 허용 목록이 [기본 분류기 모델](https://code.claude.com/docs/ko/permission-modes.md#default-classifier-model)을 제외하면, 해당 모델을 사용하게 될 분류기 요청은 세션 모델에서 실행되거나, [Fable](#work-with-fable) 세션에서는 Opus 모델에서 실행됩니다. Anthropic API 이외의 제공자에서, 해당 Opus 폴백은 허용 목록을 참조하지 않고 `ANTHROPIC_DEFAULT_OPUS_MODEL`에 설정한 모델에서, 설정하지 않은 경우 Opus 5에서 실행됩니다. Claude Code v2.1.210 이상 필요
* **[빠른 모드](https://code.claude.com/docs/ko/fast-mode.md)**: 세션이 이후에 실행될 모델이 허용 목록 외부에 있을 때 빠른 모드 활성화가 거부됩니다
* **Amazon Bedrock 및 Google Cloud의 Agent Platform의 가용성 폴백**: 세션 도중 계정이 모델에 대한 액세스 권한을 잃으면, 다른 모델로 전환할 때 제외된 모델을 건너뜁니다. [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md#when-your-organization-enforces-a-model-allowlist) 및 [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md#when-your-organization-enforces-a-model-allowlist)의 시작 시 모델 확인은 관리형 설정이 [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model)도 설정할 때만 제외된 모델을 건너뜁니다

```json theme={null}
{
  "availableModels": ["sonnet", "haiku"]
}
```

### 표면 범위

모든 표면은 수신하는 허용 목록을 적용합니다. 각 표면에 도달하는 전달 메커니즘은 다릅니다:

| 전달 메커니즘 | CLI 및 IDE | 데스크톱 로컬 세션 | 웹, 모바일 및 클라우드 세션 | Agent SDK 및 비대화형 | Cowork |
| :- | :- | :- | :- | :- | :- |
| 관리 콘솔의 [서버 관리 설정](https://code.claude.com/docs/ko/server-managed-settings.md) | 적용됨 | 적용됨 | [Claude Tag](https://claude.com/docs/claude-tag/overview) 세션을 제외하고 적용됨 | 적용됨 | 원격 Cowork 세션: 서버가 모델을 확인합니다. 사용자의 머신에서: 전달되지 않음. |
| [MDM 또는 관리형 설정 파일](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms) | 적용됨 | 적용됨 | Anthropic 호스팅 환경에서는 전달되지 않음. [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)에서는 [Claude Code가 관리형 소스를 결합하는 방식](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)에 따라 러너 이미지에서 적용됨 | 적용됨 | 배포된 경우 적용됨 |

* [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)(데스크톱 앱에서 시작하는 세션 포함)은 기본적으로 Anthropic 관리 VM에서 실행됩니다: 장치에 배포된 설정은 이에 도달하지 않으므로, 서버 관리 설정을 통해 허용 목록을 전달합니다. 조직이 [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)으로 라우팅하는 세션은 자신의 컴퓨팅에서 실행되고 러너 이미지의 관리형 설정 파일도 읽습니다. [Claude Code가 관리형 소스를 결합하는 방식](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)은 해당 파일이 언제 적용되는지 설명합니다. 클라우드 세션의 중간 세션 모델 전환은 요청된 모델이 허용 목록에 의해 제외될 때 거부됩니다. 서버 관리 설정의 `availableModels` 목록이 비어있지 않을 때, 서버는 목록이 제외하는 모델에서 claude.ai/code 또는 데스크톱 앱에서 클라우드 세션을 시작하도록 요청하는 것을 거부합니다.
* [Claude Tag](https://claude.com/docs/claude-tag/overview) 세션은 클라우드 환경에서 실행되지만 서버 관리 설정을 수신하지 않습니다. [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)에서는 여전히 러너 이미지의 관리형 설정 파일을 읽습니다. 이러한 세션의 모델을 설정하려면 Claude Tag 관리자 가이드의 [범위에 대한 모델 선택](https://claude.com/docs/claude-tag/admins/customize#choose-the-model-for-a-scope)을 참조하세요.
* Cowork(Claude 데스크톱 앱의 에이전트 작업 탭)는 Claude Code에서 세션을 실행하지만, 설계상 claude.ai 관리 콘솔에서 서버 관리 설정을 수신하지 않습니다. 서버 관리 설정의 `availableModels` 목록이 비어있지 않고 사용자가 목록 외부의 모델을 선택하면, 서버는 원격 Cowork 세션에 대해 해당 모델을 거부합니다. 관리형 설정 파일은 세션이 실행되는 위치에 있을 때 Cowork 세션에 적용됩니다. 원격 Cowork 세션은 Anthropic 관리 VM에서 실행되며, 여기서 장치 배포 파일은 없습니다.
* [Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry, 그리고 Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md)와 같은 [제3자 제공자](https://code.claude.com/docs/ko/server-managed-settings.md#platform-availability)의 세션은 서버 관리 설정을 수신하지 않으므로, 허용 목록을 MDM 또는 관리형 설정 파일을 통해 전달합니다.
* 관리 콘솔을 통한 전달은 또한 세션이 조직에 대한 [적격 로그인](https://code.claude.com/docs/ko/server-managed-settings.md#platform-availability) 또는 조직에 대해 발급된 OAuth 토큰으로 설정을 가져와야 합니다. 직접 구성했든 [`apiKeyHelper`](https://code.claude.com/docs/ko/settings-reference#apikeyhelper) 스크립트로 생성했든 API 키로 인증하는 플릿의 경우, MDM 또는 관리형 설정 파일을 통해 허용 목록을 전달하세요.
* 데스크톱 Code 탭은 또한 [SSH 세션](https://code.claude.com/docs/ko/desktop.md#ssh-sessions)을 호스팅하며, 이는 실행되는 원격 호스트에서 관리형 설정 파일을 읽습니다. [데스크톱 관리형 설정](https://code.claude.com/docs/ko/desktop.md#managed-settings)을 참조하세요.
* claude.ai 및 데스크톱 앱의 모델 선택기는 조직의 허용 목록에 의해 제외된 모델을 숨기거나 회색으로 표시합니다. 선택기 상태는 사용자를 위한 편의입니다. 허용 목록을 적용하지 않습니다.

### 기본 모델 동작

기본 접두사 일치를 사용하면, `availableModels` 자체는 Default 옵션을 시스템의 [런타임 기본값](#default-model-setting)에 남겨두고, [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model)도 설정할 때까지 계정에 대해 남겨둡니다. 해당 기본값이 제한하려는 모델인 경우, `enforceAvailableModels`도 설정하거나 [해당 모델을 차단](#block-specific-models-or-versions)하세요.

`availableModels: []`를 사용하면, 명명된 모델 선택은 차단되고 `enforceAvailableModels`는 효과가 없습니다.

### Default 모델에 대한 허용 목록 적용

관리형 설정에서 비어있지 않은 `availableModels`와 함께 `enforceAvailableModels: true`를 설정하여 허용 목록을 Default 옵션으로 확장합니다. 이는 Claude Code v2.1.175 이상이 필요합니다.

```json theme={null}
{
  "availableModels": ["sonnet", "haiku"],
  "enforceAvailableModels": true
}
```

계정에 [기록된](#setting-your-model) 모델이 없는 멤버의 경우, Default 옵션은 계정 유형 기본값으로 해석되거나, 관리자가 설정한 경우 [조직 기본 모델](#organization-default-model)로 해석됩니다. 해당 모델이 허용 목록에 없을 때, Default 옵션은 대신 허용되고 사용 가능한 모델을 이름 지정하는 첫 번째 `availableModels` 항목으로 해석되고, `/model` 선택기의 Default 행은 해당 모델을 표시합니다. 이는 Default에 도달하는 모든 곳에 적용됩니다: 세션 시작, `/model`에서 Default 선택, [폴백 모델 체인](#fallback-model-chains)의 `"default"` 키워드, 그리고 제외된 선택이 삭제될 때 사용되는 폴백. 멤버의 계정에 기록된 모델도 `availableModels`에 대해 확인됩니다. [모델 설정](#setting-your-model)은 Default 옵션이 이를 처리하는 방식을 설명합니다.

`enforceAvailableModels`는 `availableModels`가 비어있지 않을 때만 Default 옵션을 다시 매핑합니다. `availableModels`가 비어있지 않지만 어떤 항목도 허용되고 사용 가능한 모델로 해석되지 않을 때, 적용은 `--debug` 아래에서만 볼 수 있는 경고와 함께 건너뜁니다. 이를 피하려면 목록에 최소한 하나의 보장된 사용 가능 항목을 유지하세요.

전달하는 최상위 순위 관리형 소스에 두 키를 함께 배포합니다. 기본적으로 Claude Code는 해당 소스만 읽으므로, 관리형 설정 파일에 배치된 쌍은 관리 콘솔이 설정을 전달할 때 무시됩니다. [Claude Code가 관리형 소스를 결합하는 방식](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)의 선택적 병합에서, Claude Code는 여전히 `availableModels`를 설정하는 소스 아래에 순위가 지정된 소스의 `modelOverrides` 맵을 무시합니다.

### 사용자가 실행하는 모델 제어

`model` 설정은 초기 선택이지, 적용이 아닙니다. 세션이 시작될 때 활성 모델을 설정하지만, 사용자는 여전히 `/model`을 열고 Default를 선택할 수 있으며, 이는 `model`이 설정된 것과 관계없이 시스템의 [런타임 기본값](#default-model-setting)으로 해석됩니다. [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model) 또는 [특정 버전을 차단하는 키](#block-specific-models-or-versions)가 이에 적용되지 않는 한.

모델 경험을 완전히 제어하려면 이러한 설정을 결합하세요:

* **`availableModels`**: 사용자가 전환할 수 있는 명명된 모델을 제한합니다
* **`enforceAvailableModels`**: `availableModels` 허용 목록을 Default 옵션으로 확장하므로 Default는 목록 외부의 모델로 해석될 수 없습니다
* **`deniedModels`** 및 **`availableModelsMatch`**: [특정 버전을 차단](#block-specific-models-or-versions)하여 `availableModels` 항목이 허용할 수 있습니다
* **`model`**: 세션이 시작될 때 초기 모델 선택을 설정합니다
* **`ANTHROPIC_DEFAULT_SONNET_MODEL`** / **`ANTHROPIC_DEFAULT_OPUS_MODEL`** / **`ANTHROPIC_DEFAULT_HAIKU_MODEL`** / **`ANTHROPIC_DEFAULT_FABLE_MODEL`**: `sonnet`, `opus`, `haiku`, 그리고 `fable` 별칭이 해석되는 것을 제어하고, [계정 유형 기본값](#default-model-setting)이 사용하는 버전을 제어합니다

이 예제는 사용자를 Sonnet 4.5에서 시작하고, 선택기를 Sonnet 및 Haiku로 제한하고, Default가 계층 기본값이 아닌 허용 목록의 모델로 해석되도록 합니다:

```json theme={null}
{
  "model": "claude-sonnet-4-5",
  "availableModels": ["claude-sonnet-4-5", "haiku"],
  "enforceAvailableModels": true,
  "env": {
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-4-5"
  }
}
```

`enforceAvailableModels` 또는 `env` 블록이 없으면, 선택기에서 Default를 선택하는 사용자는 `model`에 고정된 버전이 아닌 [런타임 기본값](#default-model-setting)을 얻습니다. 두 설정은 다른 범위를 다룹니다: `enforceAvailableModels`는 Default가 허용 목록을 따르도록 하고, `env` 블록은 `sonnet`과 같은 허용된 별칭이 해석되는 버전을 고정합니다. 모델 패밀리 제한이 충분할 때 `enforceAvailableModels`만 사용하세요. 특정 버전을 고정해야 할 때도 `env` 블록을 추가하세요.

### 병합 동작

Claude Code가 적용하는 관리형 설정이 `availableModels`를 정의할 때, 해당 목록만 적용됩니다. [자체 목록을 제공하는 호스트 플랫폼](https://code.claude.com/docs/ko/settings.md#exceptions-to-managed-settings-precedence) 제외: 사용자, 프로젝트 또는 로컬 설정의 항목은 이를 확장할 수 없고, Claude Code는 관리형 소스 전체에서 `availableModels`를 병합하지 않습니다. [Claude Code가 관리형 소스를 결합하는 방식](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)은 어느 소스의 목록이 적용되는지 설명합니다. 그렇지 않으면, 사용자, 프로젝트 및 로컬 설정의 목록은 다른 배열 설정처럼 [연결되고 중복 제거됩니다](https://code.claude.com/docs/ko/settings.md#settings-precedence). Claude Code v2.1.175 이전에는 하위 우선순위 범위의 항목이 관리형 목록으로 병합되었습니다.

유효한 목록 내에서, 패밀리의 특정 모델을 이름 지정하는 항목은 버전 접두사이든 전체 모델 ID이든 해당 패밀리의 와일드카드 항목을 비활성화합니다. 예를 들어 `["sonnet", "claude-sonnet-4-5"]`를 사용하면, 사용자는 모든 Sonnet 모델이 아니라 `claude-sonnet-4-5`가 [일치하는](#restrict-model-selection) 모델 ID만 선택할 수 있습니다.

### Mantle 모델 ID

`availableModels`의 항목 중 `anthropic.`으로 시작하는 항목은 `/model` 선택기에 사용자 정의 옵션으로 추가됩니다. 이는 [제3자 배포를 위한 모델 고정](#pin-models-for-third-party-deployments)에 설명된 별칭 일치에 대한 예외입니다. [Amazon Bedrock Mantle 엔드포인트](https://code.claude.com/docs/ko/amazon-bedrock.md#use-the-mantle-endpoint)가 활성화되면, Claude Code는 Mantle 형식과 일치하는 항목을 해당 엔드포인트로 라우팅합니다. 설정은 여전히 선택기를 나열된 항목으로 제한하고, Mantle ID는 패밀리 이름을 포함하므로, 특정 항목으로 계산되고 해당 패밀리의 와일드카드를 비활성화합니다: Mantle ID와 함께, 유지하려는 버전 접두사 또는 전체 ID를 나열하세요. [병합 동작](#merge-behavior)을 참조하세요.

### 특정 모델 또는 버전 차단

`claude-opus-5`와 같은 `availableModels` 항목은 또한 Claude Code가 이를 지원하는 즉시 Opus 5.5와 같은 이를 확장하는 이후 릴리스를 허용합니다. 두 관리형 설정을 사용하면 릴리스를 보류할 수 있으며, 둘 다 Claude Code v2.1.283 이상이 필요합니다:

* [`deniedModels`](https://code.claude.com/docs/ko/settings-reference#deniedmodels): 차단할 모델을 나열합니다. 나열된 모델은 `availableModels`가 이를 허용하더라도 차단되고, 키는 허용 목록이 없어도 작동합니다. 어떤 항목도 차단하지 않는 릴리스는 허용됩니다
* [`availableModelsMatch`](https://code.claude.com/docs/ko/settings-reference#availablemodelsmatch): 이를 `"exact"`로 설정하여 `availableModels`의 각 모델 ID가 이름을 지정하는 버전만 허용하도록 합니다. 나열된 모델 ID의 최신 버전은 목록에 추가할 때까지 차단된 상태로 유지됩니다

이전 버전은 두 키를 모두 무시하므로, 이러한 버전이 시작되지 않도록 [`requiredMinimumVersion`](https://code.claude.com/docs/ko/settings-reference#requiredminimumversion)도 설정하세요.

이 예제는 Opus 및 Sonnet 모델을 허용하고 날짜 및 제공자별 ID를 포함한 모든 철자로 Opus 5.5를 차단합니다:

```json theme={null}
{
  "availableModels": ["opus", "sonnet"],
  "deniedModels": ["claude-opus-5-5"]
}
```

차단된 모델(whether `deniedModels`가 이름을 지정하거나 `"exact"` 목록이 이를 생략)은 [허용 목록이 적용되는](#restrict-model-selection) 모든 곳에서 차단된 선택으로 처리됩니다. `/model` 선택기에서 숨겨지고, `/model <name>`은 이를 거부합니다. `--model`, `ANTHROPIC_MODEL`, 또는 `model` 설정으로 차단된 모델 ID를 이름 지정하면, Claude Code는 시작 시 이를 삭제하고 Default 옵션을 해석합니다. [훅](https://code.claude.com/docs/ko/hooks.md) 또는 백그라운드 요청이 `deniedModels`가 차단하는 모델(예: 에이전트 훅의 `model` 필드)을 이름 지정하면, 해당 요청은 세션의 모델에서 대신 실행됩니다.

Default 옵션은 [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model)를 설정했는지 여부와 관계없이 두 키를 모두 따릅니다. 비어있지 않은 `availableModels`로 설정하면, 차단된 기본값은 허용 목록 외부의 모델로 계산됩니다. 그렇지 않으면, 차단된 모델로 해석될 Default 옵션은 이 순서로 단계적으로 내려갑니다:

1. 동일한 패밀리의 최신 허용 버전
2. 각 하위 비용 패밀리의 최신 허용 모델: Sonnet, 그 다음 Haiku
3. 허용된 모델을 이름 지정하는 첫 번째 `availableModels` 항목

이 중 어느 것도 허용되지 않으면, Default 옵션에서 시작하는 세션은 [시작을 거부](https://code.claude.com/docs/ko/errors.md#managed-settings-block-the-default-model)하고 수정할 키를 이름 지정하는 오류가 발생합니다. `"exact"` 목록은 관리형 `availableModels` 목록이 최소한 하나의 모델 또는 패밀리를 이름 지정할 때만 Default 옵션에 영향을 미칩니다.

Claude Code는 관리형 설정에서만 두 키를 읽습니다. 사용자, 프로젝트 또는 로컬 설정이나 `--settings`로 둘 중 하나를 설정하면, Claude Code는 경고와 함께 이를 무시합니다.

### 조직 모델 제한

Claude Enterprise 플랜의 조직 관리자는 claude.ai 관리 콘솔에서 개별 모델을 비활성화하여 멤버가 실행할 수 있는 모델을 제한합니다. 이 제한은 설정의 `availableModels` 목록과 별도로 계정의 자격과 함께 전달되고, 서버는 세션이 생성될 때 동일한 제한을 독립적으로 적용합니다. Claude Code v2.1.187 이상 필요합니다.

제한은 멤버가 로그인하거나 자신의 API 키를 사용할 때 적용됩니다. 조직 서비스 키와 같은 조직 범위 자격은 사용자와 연결되지 않으므로, 제한이 이에 적용되지 않습니다.

Claude Console에는 모델 제한 제어가 없습니다. Claude Enterprise 플랜이 없는 조직(Anthropic API를 통해 인증하는 멤버를 포함)은 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 [`availableModels`](#restrict-model-selection)로 모델을 제한하고, Default 옵션을 다루기 위해 [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model)를 추가합니다. [표면 범위](#surface-coverage)는 각 표면이 이러한 설정을 수신하고 적용하는 방식을 설명합니다.

제한된 모델은 `/model` 선택기에서 숨겨집니다. `--model`, `ANTHROPIC_MODEL` 환경 변수, 또는 `model` 설정으로 이름으로 선택하면 `Model "<name>" is restricted by your organization's settings. Using <model> instead.` 알림을 표시하고 세션은 허용된 모델에서 시작됩니다. 제한된 모델에 대해 `/model <name>`을 입력하면 `Model '<name>' is restricted by your organization's settings. Run /model to choose a different model.`로 거부되고 세션은 현재 모델을 유지합니다.

`opus`와 같은 [모델 패밀리 별칭](#restrict-model-selection)은 조직이 이를 허용할 때 일반적인 모델로 해석됩니다. 조직이 해당 모델을 제한할 때, Claude Code는 조직이 허용하는 패밀리의 최신 버전으로 대체하고 동일한 대체 알림을 표시합니다. `/model <alias>`는 패밀리의 모든 버전이 제한될 때만 거부됩니다. `--model`, `ANTHROPIC_MODEL`, 또는 `model` 설정으로 설정된 별칭은 여전히 시작 시 해당 경우에 대체됩니다. v2.1.205 이전에는 패밀리 별칭이 최신 릴리스 버전만을 기반으로 대체되거나 거부되었으며, 이전 버전이 허용되었을 때도 마찬가지였습니다.

제한은 조직 전체 또는 역할별로 적용됩니다:

* 조직 수준에서 모델을 비활성화하면 모든 멤버에 대해 제거됩니다.
* 역할 수준 액세스는 다양한 사용자 정의 역할에 다양한 모델을 부여하고, 여러 역할을 보유한 멤버는 자신의 역할 중 하나가 부여하는 모든 모델을 사용할 수 있습니다.
* Haiku 모델은 항상 사용 가능하며 비활성화할 수 없으므로, 모든 멤버는 최소한 하나의 사용 가능한 모델을 유지합니다.
* 액세스 변경은 약 1분 내에 새 요청에 적용됩니다. `/model` 선택기는 다음 세션이 시작될 때 이를 반영합니다.

두 제한이 함께 적용됩니다: 모델은 `availableModels`에 의해 허용되고 조직에 의해 제한되지 않을 때만 선택 가능합니다. 조직 제한은 Anthropic API 및 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 배포의 세션에만 도달합니다. 다른 제공자에서는 `availableModels`를 대신 사용하세요.

## 조직 기본 모델

Claude Enterprise 플랜의 조직 관리자는 claude.ai 관리 콘솔에서 전체 조직 또는 사용자 정의 역할별로 Claude Code 멤버의 기본 모델을 설정할 수 있습니다. 기본 모델이 설정되면 기본값 옵션이 해당 모델로 확인됩니다. Claude Code v2.1.196 이상이 필요합니다.

`/model` 선택기의 기본값 행에는 조직 기본값의 이름이 Org default 레이블과 함께 표시됩니다. 관리자가 전체 조직에 대해 기본값을 설정했는지 또는 역할에 대해 설정했는지 여부에 관계없이 레이블은 Org default로 표시됩니다. 역할 기본값은 해당 사용자 정의 역할의 멤버를 포함하며 조직 전체 기본값보다 우선합니다. 여러 역할이 서로 다른 기본값을 설정한 경우 가장 성능이 우수한 모델이 적용됩니다.

조직 기본값은 시작점이지 제한이 아닙니다. 다음 선택 항목이 이를 우선합니다.

* `--model` 플래그 및 `ANTHROPIC_MODEL` 환경 변수
* [관리 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 제공되거나 `--settings`를 통해 제공되는 `model` 값
* 사용자, 프로젝트 또는 로컬 설정의 `model` 값(예: `/model`로 저장한 모델 포함)

관리자는 조직 기본값을 구성하여 사용자 선택을 재정의할 수도 있습니다. 재정의가 활성화되면 사용자, 프로젝트 및 로컬 설정의 `model` 값보다 우선하므로 `/model`로 저장한 모델은 현재 세션에 적용되고 다음 시작 시 조직 기본값으로 돌아갑니다. 선택 항목이 다를 경우 `/model`은 `Your organization's default (<model>) applies on restart`를 표시합니다. `--model` 플래그, `ANTHROPIC_MODEL`, 관리형 설정 및 `--settings`는 재정의가 활성화된 경우에도 계속 우선합니다.

멤버가 선택할 수 있는 모델을 제한하려면 [조직 모델 제한](#organization-model-restrictions) 또는 [`availableModels`](#restrict-model-selection)를 대신 사용하세요.

Claude Code는 시작 시 조직 기본값을 한 번만 읽으므로 관리자가 세션 중에 변경한 기본값은 다음 시작 시 적용됩니다.

조직 기본값이 사용자 선택을 재정의하지 않을 경우, 관리자가 변경한 후 첫 번째 대화형 시작 시 사용자 설정에서 `model` 키를 한 번 지워서 새 기본값이 적용되도록 합니다. 파일의 다른 항목은 변경하지 않으며, 해당 시작 후 `/model`로 저장한 모델은 유지됩니다.

조직 기본값은 채택되기 전에 다음 제한 확인을 통과합니다.

* 기본 접두사 일치를 사용하면 [`availableModels`](#restrict-model-selection)는 자체적으로 조직 기본값에 적용되지 않으므로 허용 목록 외부의 조직 기본값도 계속 적용됩니다. [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model)도 설정된 경우, 허용 목록 외부의 조직 기본값은 첫 번째 허용 목록 항목으로 다시 매핑됩니다.
* [조직 모델 제한](#organization-model-restrictions)이 계정에 대해 거부하는 조직 기본값은 해당 제품군의 최신 허용 모델로 바뀌거나, 모든 버전이 제한된 경우 더 저렴한 제품군으로 바뀝니다.
* `deniedModels` 또는 `"exact"` 목록이 차단하는 조직 기본값의 경우 [특정 모델 또는 버전 차단](#block-specific-models-or-versions)을 참조하세요.
* 계정에서 전혀 사용할 수 없는 조직 기본값은 건너뛰고, 기본값 옵션은 [조직 기본값 없이](#default-model-setting) 확인되는 것처럼 확인됩니다.

v2.1.199부터 조직 기본값이 계정 유형의 일반적인 기본값과 다른 모델 제품군인 경우, `/model` 선택기는 해당 일반적인 제품군에 대해 별도의 행을 유지하므로 세션에 대해 계속 전환할 수 있습니다. v2.1.196부터 v2.1.198까지는 해당 행이 선택기에서 누락됩니다.

조직 기본값은 Anthropic API로 인증된 세션에만 도달합니다. [LLM gateway](https://code.claude.com/docs/ko/llm-gateway) 배포를 포함하여 다른 곳에서 기본값을 설정하려면 [관리 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `model` 키를 대신 사용하세요.

## 조직 노력 제한

조직은 두 가지 방법으로 [노력 수준](#adjust-effort-level)을 제한할 수 있습니다. Claude Enterprise 플랜에서는 조직 관리자가 역할별 노력 제한을 설정하며, 이는 아래에 설명되어 있습니다. 모든 플랜 및 Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry를 포함한 모든 제공자에서 [`maxEffortLevel`](https://code.claude.com/docs/ko/settings-reference#maxeffortlevel) 관리 설정은 클라이언트에서 노력을 제한합니다. 모델에 둘 다 적용되는 경우 더 낮은 상한선이 적용됩니다.

Claude Enterprise 플랜의 조직 관리자는 역할 수준의 [조직 모델 제한](#organization-model-restrictions)과 함께 각 사용자 정의 역할에 대해 모델별 최대 [effort 수준](#adjust-effort-level)을 설정할 수 있습니다. Claude Code v2.1.195 이상이 필요합니다.

* 상한선을 초과하는 수준은 `/effort` 선택기에서 제공되지 않으며, `--effort` 또는 `/effort`로 더 높은 수준을 지정하면 대신 상한선에서 실행됩니다. 상한선보다 높은 `--effort`로 일반 텍스트 `--print` 실행을 시작하면 stderr에 요청된 수준과 적용된 수준을 명시하는 경고가 표시됩니다. 대화형 세션, `json` 또는 `stream-json` 출력, 백그라운드 에이전트에서는 해당 경고가 대신 [디버그 로그](https://code.claude.com/docs/ko/errors.md#configuration-warnings)에 기록됩니다.
* 상한선은 모델별이므로 모델을 전환하면 사용 가능한 수준이 변경될 수 있습니다.
* 여러 역할이 동일한 모델을 부여하는 경우 가장 제한이 적은 상한선이 적용됩니다.

노력 제한은 [조직 모델 제한](#organization-model-restrictions)과 함께 전달되며 동일한 세션에 도달합니다.

## 특수 모델 동작

### `default` 모델 설정

`default`의 동작은 계정 유형에 따라 달라집니다:

* **Pro, Max, Ultra, Team, Enterprise 및 Anthropic API**: Opus 5.5로 기본 설정됨
* **AWS의 Claude Platform, Amazon Bedrock 및 Google Cloud의 Agent Platform**: Opus 5.5로 기본 설정됨
* **Microsoft Foundry**: Sonnet 4.5로 기본 설정됨

v2.1.280 이전에는 `default`가 Pro 및 Team Standard에서 Sonnet 5로, Max, Ultra, Team Premium, Enterprise, Anthropic API, AWS의 Claude Platform, Amazon Bedrock 및 Google Cloud의 Agent Platform에서 v2.1.219부터 Opus 5로 확인되었습니다. v2.1.219 이전에는 `default`가 Anthropic API, Max, Ultra, Team Premium 및 Enterprise 종량제에서 v2.1.154부터 Opus 4.8로, AWS의 Claude Platform, Amazon Bedrock 및 Google Cloud의 Agent Platform에서 v2.1.207부터 Opus 4.8로 확인되었습니다. v2.1.207 이전에는 `default`가 AWS의 Claude Platform에서 Opus 4.7로, Amazon Bedrock 및 Google Cloud의 Agent Platform에서 Sonnet 4.5로 확인되었습니다.

관리자가 [조직 기본 모델](#organization-default-model)을 설정한 경우, `default`는 위의 계정 유형 기본값 대신 해당 모델로 확인됩니다. Claude Code v2.1.196 이상이 필요합니다. `default`는 [`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions)로 설정한 모델로도 확인될 수 있으며, 해당 섹션에 나열된 조건 하에서 또는 [계정에 기록된](#setting-your-model) 모델로 확인될 수 있습니다.

계정에 아무것도 기록되지 않았을 때, 관리형 설정이 [Default 모델에 대한 허용 목록을 적용](#enforce-the-allowlist-for-the-default-model)하고, 계정 유형 기본값이 `availableModels`에 없으면, `default`는 위의 계정 유형 기본값 대신 적용된 Default로 확인됩니다. 조직 기본값과 적용이 모두 적용될 때, 조직 기본값이 먼저 계정 유형 기본값을 대체하고 적용이 이에 적용됩니다: 허용 목록에 있는 조직 기본값은 유지되고, 목록 외의 값은 적용된 Default로 확인됩니다.

Fable 모델은 어떤 플랜이나 제공자에서도 계정 유형 기본값이 아닙니다. `/model`로 선택하면 사용자 설정에서 선택된 모델로 저장되므로, 이후 세션이 이 모델에서 시작됩니다. v2.1.257에서 Claude Code가 저장된 Fable 5 선택에 대해 수행하는 일회성 변경의 경우, [Fable 작업](#work-with-fable)을 참조하세요.

### `opusplan` 모델 설정

`opusplan` 모델 별칭은 자동화된 하이브리드 접근 방식을 제공합니다:

* **플랜 모드에서**: 복잡한 추론 및 아키텍처 결정을 위해 `opus`를 사용합니다
* **실행 모드에서**: 코드 생성 및 구현을 위해 자동으로 `sonnet`으로 전환합니다

이는 계획을 위한 Opus의 추론과 실행을 위한 Sonnet의 효율성을 결합합니다.

플랜 모드 Opus 단계는 `opus` 모델 설정과 동일한 컨텍스트 윈도우를 사용하고, 실행 단계는 `sonnet`과 동일한 윈도우를 사용합니다. `opus`와 `sonnet`이 [1M 컨텍스트 윈도우](#extended-context)로 기본 실행되는 모델로 확인될 때, Anthropic API의 현재 모델처럼, 두 단계 모두 이를 사용하여 실행됩니다. 이들이 그렇지 않은 경우 두 단계 모두에 대해 1M 컨텍스트를 요청하려면, [모델을 설정](#setting-your-model)하여 `opusplan[1m]`으로 설정하세요. 예를 들어 `/model opusplan[1m]`을 사용합니다. 이를 `/model`로 설정하려면 Claude Code v2.1.265 이상이 필요합니다. 이전 버전에서는 `--model` 플래그 또는 `model` 설정을 대신 사용하세요.

[`availableModels`](#restrict-model-selection)이 최신 Opus를 제외하지만 이전 버전(예: `["sonnet", "claude-opus-4-6"]`)을 허용할 때, `opusplan`은 계획을 위해 허용된 최신 Opus를 사용하고 모든 Opus가 제외될 때만 Sonnet에 유지됩니다. 플랜 모드에서 일반적으로 Sonnet으로 업그레이드할 Haiku 세션은 마찬가지로 허용된 최신 Sonnet을 사용하고, 모든 Sonnet이 제외될 때만 Haiku에 유지됩니다. v2.1.205 이전에는 플랜 모드가 허용 목록이 이전 버전을 허용했을 때에도 업그레이드 제품군의 최신 버전이 제외될 때마다 세션의 모델에 유지되었습니다.

이전 허용 버전의 대체는 Anthropic API 및 [AWS의 Claude Platform](https://code.claude.com/docs/ko/claude-platform-on-aws.md)에 적용됩니다. Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 및 Mantle에서는 제공자별 모델 ID를 사용하는 배포이므로, 플랜 모드는 업그레이드 모델이 제외될 때마다 세션의 모델에 유지됩니다.

Claude가 계획 경계에서 전환하는 대신 작업 중간에 두 번째 모델을 참조할 시기를 결정하는 하이브리드 접근 방식의 경우, [advisor 도구](https://code.claude.com/docs/ko/advisor.md)를 참조하세요.

### 폴백 모델 체인

기본 모델이 과부하 상태이거나 사용할 수 없거나 다른 재시도 불가능한 서버 오류를 반환할 때, Claude Code는 요청이 실패하는 대신 폴백 모델로 전환할 수 있습니다. 인증, 청구, 속도 제한, 요청 크기 및 전송 오류, 그리고 [조직의 정책 확인에 의한 거부](https://code.claude.com/docs/ko/errors.md#automatic-retries)는 전환을 트리거하지 않습니다. 이들은 정상적인 재시도 및 오류 처리를 따릅니다. [Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md#when-a-model-is-disabled-mid-session) 또는 [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md#when-a-model-is-disabled-mid-session)이 계정이 호출할 수 없는 모델을 거부할 때 전환되며, Claude Code는 이를 인증 오류가 아닌 모델을 사용할 수 없는 것으로 취급합니다.

하나 이상의 폴백 모델을 구성하고 Claude Code는 순서대로 시도하며, 전환할 때 알림을 표시합니다. 전환은 현재 턴에만 지속되므로, 다음 메시지는 기본 모델을 다시 먼저 시도합니다. Claude Code는 체인을 중복 제거 후 3개 모델로 제한하고 추가 항목을 무시합니다.

`--fallback-model` 플래그로 한 세션에 대한 체인을 설정하며, 이는 쉼표로 구분된 목록을 허용합니다:

```bash theme={null}
claude --fallback-model sonnet,haiku
```

세션 전체에 체인을 유지하려면, [설정](https://code.claude.com/docs/ko/settings.md)에서 `fallbackModel`을 배열로 설정하세요:

```json theme={null}
{
  "fallbackModel": ["claude-sonnet-5", "claude-haiku-4-5"]
}
```

`--fallback-model` 플래그는 `fallbackModel` 설정보다 우선합니다. 각 항목은 모델 이름 또는 별칭을 허용하고, `"default"`는 기본 모델로 확장됩니다.

Claude Code는 시작 시 체인을 확인하지 않으며 `/status`는 이를 표시하지 않습니다. 전환이 발생할 때 표시되는 알림이 폴백이 구성되었다는 첫 번째 눈에 띄는 신호입니다.

요청이 폴백될 때, Claude Code는 하나가 이를 수락할 때까지 순서대로 각 항목을 시도합니다. 설정에 고정된 폐기된 모델과 같이 도달할 수 없는 항목도 동일한 방식으로 다음 항목으로 폴백됩니다. Claude Code는 해당 이동을 시작하기 전에 두 가지 종류의 항목을 제거합니다:

* **허용 목록 외**: Claude Code는 체인을 읽을 때 [`availableModels`](#restrict-model-selection)에 의해 허용되지 않는 항목을 삭제합니다.
* **압축 중 더 작은 컨텍스트 윈도우**: 체인은 [압축](https://code.claude.com/docs/ko/context-window.md#what-survives-compaction)도 포함하지만, Claude Code는 기본 모델보다 더 작은 컨텍스트 윈도우를 가진 모델로 폴백하지 않습니다. 그곳에서 요약하면 대화의 일부가 먼저 잘리기 때문입니다. 모든 폴백이 더 작으면, 압축은 원래 오류를 표시하고 재시도할 수 있습니다.

Claude Code는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)에도 체인을 적용합니다. 서브에이전트의 요청이 폴백될 때, Claude Code는 순서대로 구성된 폴백 모델을 시도하고, 서브에이전트는 요청을 수락하는 모델에서 계속됩니다. 세션의 모델은 변경되지 않습니다. v2.1.247 이전에는 체인이 포함하는 실패가 서브에이전트를 종료했습니다.

### 자동 모델 폴백

이 섹션은 Fable 모델, Opus 5.5, Sonnet 5.5 및 Opus 5의 콘텐츠 기반 폴백을 다룹니다. 모델이 과부하 상태이거나 사용할 수 없을 때의 가용성 기반 폴백의 경우, [폴백 모델 체인](#fallback-model-chains)을 참조하세요.

Fable 모델, Opus 5.5, Sonnet 5.5 및 Opus 5는 안전 분류기로 실행되며, 이는 대부분 사이버 보안 및 생물학 콘텐츠에 플래그를 지정합니다. 이 두 카테고리의 경우, 폴백 모델은 어느 모델이 거부했는지에 따라 달라집니다:

* **Fable 5.1, Fable 5 및 Opus 5.5**: 생물학 플래그 요청은 Opus 5에서 다시 실행되고, 사이버 보안 플래그 요청은 Opus 4.8에서 다시 실행됩니다.
* **Sonnet 5.5**: 사이버 보안 플래그 요청은 Sonnet 5에서 다시 실행됩니다. 생물학 플래그 요청은 Sonnet 5.5에 생물학 폴백 모델이 없기 때문에 거부로 종료됩니다.
* **Opus 5**: 사이버 보안 플래그 요청은 Opus 4.8에서 다시 실행됩니다. 생물학 플래그 요청은 Opus 5가 폴백 모델이 없는 자체 생물학 분류기를 실행하기 때문에 거부로 종료됩니다.

Amazon Bedrock, Google Cloud의 Agent Platform 및 Microsoft Foundry에서는 Claude Code가 배포의 모델 ID를 통해 이러한 대상을 확인합니다. [Bedrock, Agent Platform 및 Foundry에서 폴백 활성화](#enable-fallback-on-bedrock-agent-platform-and-foundry)를 참조하세요.

Claude Code가 플래그된 요청을 해당 카테고리의 폴백 모델로 전환하면, 그 모델에서 요청을 다시 실행합니다. 메인 대화에서는 트랜스크립트에 알림을 표시합니다. 먼저 확인 요청을 받으려면 [전환하기 전에 확인](#ask-before-switching)을 참조하세요.

폴백 후, 세션은 폴백 모델에서 계속됩니다. 원래 모델로 돌아가려면 [`/model`](#setting-your-model)을 실행하세요.

카테고리 기반 폴백에는 Claude Code v2.1.219 이상이 필요합니다. v2.1.219 이전에는 모든 플래그된 Fable 5 요청이 제공자의 기본 Opus 모델에서 다시 실행되었고, Opus 5는 폴백 소스가 아니었습니다.

폴백 모델은 [`availableModels`](#restrict-model-selection)에 대해 확인됩니다. 차단되면 폴백이 발생하지 않습니다. 거부는 정상 오류로 표시되고 세션의 모델은 변경되지 않습니다.

#### 폴백 후 effort 수준

Claude Code가 세션을 폴백 모델로 전환할 때, 플래그된 요청이 실행된 effort 수준을 유지합니다. 예를 들어, 기본값 `medium`으로 Opus 5.5에서 실행되던 세션이 Opus 4.8로 폴백되면, Opus 4.8의 기본값이 `high`이더라도 `medium`으로 유지됩니다.

다음과 같은 경우에는 다른 수준이 적용됩니다:

* **사용자의 직접 변경**: effort 수준을 선택하거나, `/model`에서 모델을 고르거나, 나중에 세션을 재개하면 플래그된 요청의 수준은 더 이상 이어지지 않습니다.
* **한 턴에 대해 설정된 effort**: 플래그된 턴을 `ultrathink`로 높였거나 스킬의 `effort` frontmatter가 수준을 설정한 경우, 해당 수준은 그 턴에 적용됩니다. 이후 턴은 [effort 확인 순서](#adjust-effort-level)가 폴백 모델에 부여하는 수준으로 실행됩니다.

폴백 후 세션에 설정된 수준을 확인하려면 `/effort status`를 실행하세요. 변경하려면 `/effort`를 실행하세요.

#### 폴백을 트리거한 것 확인

폴백은 특이한 내용을 보내기 전인 세션의 첫 번째 요청에서도 트리거될 수 있습니다. 첫 번째 요청에는 CLAUDE.md 콘텐츠 및 git 상태와 같은 워크스페이스 컨텍스트가 포함되기 때문입니다. 보안 또는 생물학 자료를 포함하는 저장소는 해당 컨텍스트만으로 분류기를 트리거할 수 있습니다.

사용자 정의가 트리거인지 확인하려면, `claude --safe-mode`로 세션을 시작하세요. 이는 CLAUDE.md, 스킬, MCP 서버 및 훅과 같은 사용자 정의를 비활성화합니다. Git 상태 및 디렉토리 이름은 사용자 정의가 아니며 여전히 포함됩니다.

#### 전환하기 전에 확인

요청이 플래그될 때마다 어떤 일이 발생할지 결정하려면, `/config`를 실행하고 **Switch models when a message is flagged**를 선택한 다음 **Ask each time**을 선택하세요. 설정 파일에서 [`switchModelsOnFlag`](https://code.claude.com/docs/ko/settings-reference#switchmodelsonflag)를 `false`로 설정할 수도 있습니다. 그러면 Claude Code는 모델을 전환하게 될 플래그된 요청에서 일시 중지하고 두 가지 옵션을 제공합니다: 폴백 모델로 전환하거나, 프롬프트를 편집하고 재시도합니다.

대화형 세션에서 플래그된 요청이 처음으로 모델을 전환하게 될 때, Claude Code는 이후부터 자동으로 전환할지 물을 수 있습니다. `switchModelsOnFlag`를 설정하지 않은 경우에만 묻고, 선택한 내용을 사용자 설정에 해당 키로 저장합니다.

대신 현재 모델에 머무르기를 선택하면, 저장되는 값은 **Ask each time**과 동일한 `false`입니다. 질문을 닫으면 Claude Code는 아무것도 저장하지 않으며, 다음에 플래그된 요청이 모델을 전환하게 될 때 다시 묻습니다.

**Ask each time**을 선택한 경우, 일부 경우는 다르게 동작합니다:

* 플래그된 카테고리에 폴백 모델이 없을 때(예: Opus 5 또는 Sonnet 5.5의 생물학 플래그), Claude Code는 프롬프트를 표시하지 않으며 요청은 거부로 종료됩니다.
* 두 모델이 동일한 요청에 플래그를 지정하면, 프롬프트를 편집하고 재시도하거나 새 세션을 시작할 수 있습니다.
* 모바일 앱의 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에서는 편집 및 재시도가 지원되지 않습니다. 모델을 전환하거나 데스크톱 브라우저 또는 데스크톱 앱에서 세션을 계속하세요.
* [비대화형 모드](https://code.claude.com/docs/ko/cli-reference.md#cli-flags) 및 프롬프트를 표시할 수 없는 SDK 통합에서는 플래그된 요청이 거부로 턴을 종료합니다.
* [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)에서는 Claude Code가 프롬프트를 표시하지 않으며, 모델을 전환하게 될 플래그된 요청은 폴백 모델에서 다시 실행됩니다.
* 폴백 대상이 [`availableModels`](#restrict-model-selection)에 의해 차단될 때, Claude Code는 프롬프트를 표시하지 않습니다. 플래그된 요청은 거부로 종료되며, 대상이 차단될 때 자동 폴백과 동일합니다.

#### Bedrock, Agent Platform 및 Foundry에서 폴백 활성화

[Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md) 및 [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md)에서는 모델 ID가 제공자별이므로, 자동 폴백은 Claude Code가 관련된 각 모델을 식별할 수 있을 때만 작동합니다:

* Claude Code는 현재 모델을 폴백 소스로 인식해야 합니다. Fable 5.1 및 Fable 5는 모델 ID가 `claude-fable-5`를 포함하거나, `ANTHROPIC_DEFAULT_FABLE_MODEL`의 값과 일치하거나, [`modelOverrides`](#override-model-ids-per-version)로 매핑될 때 인식됩니다. Opus 5.5, Sonnet 5.5 및 Opus 5는 제공자 모델 ID 또는 [`modelOverrides`](#override-model-ids-per-version) 매핑으로 인식됩니다.
* 어느 모델이 거부했든 Opus 대상은 배포에서 확인되어야 합니다: `ANTHROPIC_DEFAULT_OPUS_MODEL`을 설정하거나, 제공자의 모델 목록에 Opus 4.8 항목을 유지하세요. 없으면, 폴백은 Sonnet 5.5를 포함한 모든 소스 모델에 대해 꺼지고, 플래그된 요청은 거부로 종료됩니다.
* 플래그된 카테고리의 폴백 모델은 배포에서 확인되어야 합니다. Fable 모델, Opus 5.5 또는 Opus 5에서, `ANTHROPIC_DEFAULT_OPUS_MODEL`을 설정하면, 플래그된 요청은 폴백이 있는 모든 카테고리에 대해 해당 모델에서 다시 실행됩니다. Opus 5의 생물학 플래그는 여전히 거부로 종료됩니다. 설정하지 않으면, 사이버 보안 플래그 요청은 Opus 4.8 항목에서 다시 실행되고, Fable 모델 또는 Opus 5.5의 생물학 플래그 요청은 Opus 5 항목에서 다시 실행됩니다. Sonnet 5.5에서는 사이버 보안 플래그 요청이 `ANTHROPIC_DEFAULT_SONNET_MODEL`에서 설정한 모델에서 다시 실행되거나, 설정하지 않으면 제공자의 모델 목록의 Sonnet 5 항목에서 다시 실행됩니다.

두 모델 중 하나를 식별할 수 없으면, Claude Code는 전환하지 않습니다. 플래그된 요청은 거부 메시지로 종료되고, [`/model`](#setting-your-model)로 모델을 전환하고 재시도할 수 있습니다. 두 모델을 모두 식별 가능하게 하려면, 소스 모델에 대한 핀을 설정하세요:

* **Fable 모델**: `ANTHROPIC_DEFAULT_FABLE_MODEL`을 Fable 모델 ID로 설정하여 Claude Code가 이를 폴백 소스로 인식하도록 합니다.
* **모든 소스 모델**: `ANTHROPIC_DEFAULT_OPUS_MODEL`을 Opus 모델 ID로 설정하여 폴백을 켜고 플래그된 카테고리에 대상을 제공합니다. Opus 제품군 외의 모델 또는 거부한 모델을 지정하는 핀은 거부를 그대로 유지합니다.
* **Sonnet 5.5**: Opus 핀 외에도, `ANTHROPIC_DEFAULT_SONNET_MODEL`을 설정하거나 제공자의 모델 목록에 Sonnet 5 항목을 유지하여 요청이 다시 실행되는 모델을 제공합니다. Sonnet 제품군 외의 모델 또는 Sonnet 5.5 자체를 지정하는 Sonnet 핀은 거부를 그대로 유지합니다.

폴백 모델은 또한 세션의 컨텍스트 윈도우 이상의 컨텍스트 윈도우를 가져야 합니다. 그렇지 않으면 Claude Code는 전환하지 않으며 플래그된 요청은 동일한 거부로 종료됩니다. 이러한 제공자에서 소스 모델은 기본적으로 [1M 컨텍스트 윈도우](#extended-context)로 실행됩니다. `ANTHROPIC_DEFAULT_OPUS_MODEL`의 Opus 4.8 또는 `ANTHROPIC_DEFAULT_SONNET_MODEL`의 Sonnet 5처럼 마찬가지로 1M으로 실행되는 모델을, Claude Code가 [해당 모델과 일치시킬 수 있는](#pin-models-for-third-party-deployments) ID로 고정하세요.

#### 보안 연구 및 생물학 워크로드

공격적 보안 또는 생물학의 워크로드(침투 테스트, Capture the Flag(CTF) 연습 및 생물학 인접 코드베이스 포함)는 폴백을 자주 트리거하며, 종종 첫 번째 요청에서 트리거합니다. Fable 5.1, Fable 5 또는 Opus 5.5의 실질적인 생물학 작업의 경우, 모델을 전환하는 첫 번째 플래그된 요청이 세션을 Opus 5로 이동하고, 이후 생물학 플래그 요청은 Opus 5에서 거부로 종료됩니다. Opus 5에 생물학 폴백이 없기 때문입니다. Opus 5 및 Sonnet 5.5에서는 첫 번째 플래그된 요청부터 이러한 거부를 받습니다.

이는 이러한 도메인에 대한 예상 라우팅이며, 계정 플래그가 아닙니다. 조직이 이 작업을 위해 Fable 클래스 기능이 필요한 경우, Anthropic 계정 팀에 신뢰할 수 있는 액세스 프로그램에 대해 문의하세요.

### effort 수준 조정

[effort 수준](https://platform.claude.com/docs/en/build-with-claude/effort)은 적응형 추론을 제어하며, 이는 모델이 각 단계에서 작업 복잡성에 따라 사고할지 여부와 얼마나 사고할지를 결정하도록 합니다. 낮은 effort는 간단한 작업에 더 빠르고 저렴하고, 높은 effort는 복잡한 문제에 더 깊은 추론을 제공합니다.

사용 가능한 effort 수준은 모델에 따라 다릅니다. 여기에 나열되지 않은 모델은 effort를 지원하지 않습니다:

| 모델 | 수준 |
| :- | :- |
| Fable 5.1 및 Fable 5 | `low`, `medium`, `high`, `xhigh`, `max` |
| Opus 5.5, Sonnet 5.5, Haiku 5.5, Opus 5, Sonnet 5, Opus 4.8 및 Opus 4.7 | `low`, `medium`, `high`, `xhigh`, `max` |
| Opus 4.6 및 Sonnet 4.6 | `low`, `medium`, `high`, `max` |

활성 모델이 지원하지 않는 수준을 설정하면, Claude Code는 설정한 수준 이하의 지원되는 최고 수준으로 폴백합니다. 예를 들어, `xhigh`는 Opus 4.6에서 `high`로 실행됩니다. 조직 또는 자신의 설정도 모델이 제공하는 수준을 제한할 수 있습니다. [조직 effort 제한](#organization-effort-limits)을 참조하세요.

Claude Code는 세션의 effort 수준을 이 순서로 확인하며, 적용되는 첫 번째를 사용합니다:

1. [`CLAUDE_CODE_EFFORT_LEVEL`](https://code.claude.com/docs/ko/env-vars#variables) 환경 변수
2. 세션에서 선택한 수준(예: `/effort`, `/model` 선택기 또는 [`applyFlagSettings()`](https://code.claude.com/docs/ko/agent-sdk/typescript#applyflagsettings) 사용)
3. `--effort`로 시작
4. 설정: 모델에 대해 저장한 수준 또는 [`effortLevel`](https://code.claude.com/docs/ko/settings-reference#effortlevel) 키이며, 둘 사이 및 설정 파일 간의 우선순위는 [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings)에 명시되어 있습니다
5. 모델의 기본 effort: effort를 지원하는 모든 모델에서 `high`이며, 단 Opus 5.5, Sonnet 5.5 및 Haiku 5.5는 `medium`, Opus 4.7은 `xhigh`가 기본값입니다. 조직이 [조직 기본 모델](#organization-default-model)에 대한 기본 effort 수준을 설정하면, 해당 모델을 실행할 때 그 수준이 기본값입니다.

자동 모델 폴백 후 적용되는 수준은 [폴백 후 effort 수준](#effort-level-after-a-fallback)을 참조하세요.

Opus 5.5는 위의 소스 중 하나가 수준을 설정하지 않으면 `medium`에서 시작하고, 사용자 설정 파일의 최상위 `effortLevel`은 Opus 5.5에 대해 계산되지 않습니다. 해당 키는 Claude Code가 모델별로 수준을 저장하기 전에 `/effort`가 작성한 이전 형식입니다: 이전에 적용된 곳, 즉 Opus 5, Fable 5.1 및 이전 모델에서 계속 적용되며, Opus 5.5 및 이후 릴리스된 모델은 `/effort` 또는 `/model` 선택기로 수준을 선택할 때까지 자신의 기본값에서 시작합니다. 프로젝트, 로컬 또는 관리형 설정의 최상위 `effortLevel` 또는 `--settings`로 전달된 것은 모든 모델에 적용됩니다.

사용자 컴퓨터의 대화형 세션에서 `low`, `medium`, `high` 또는 `xhigh`를 설정할 때, 확인 방식으로 지속 기간을 선택합니다:

* `/effort` 슬라이더 또는 `/model` 선택기에서 `Enter`, 또는 `/effort` 후 입력한 수준: 수준을 기본값으로 저장하고 이후 세션에 적용합니다
* `/effort` 슬라이더 또는 `/model` 선택기에서 `s`: 이 세션에만 수준을 적용합니다. Claude Code v2.1.257 이상이 필요합니다

Claude Code는 사용자 설정의 [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings) 키 아래에서 모델별로 수준을 저장하므로, 각 모델은 자신의 저장된 수준을 유지합니다.

`max`는 가장 깊은 추론 수준입니다. `CLAUDE_CODE_EFFORT_LEVEL` 환경 변수를 통해 설정하지 않으면, Claude Code는 `max`를 현재 세션에만 적용합니다.

> [!NOTE]
>
> [Remote Control](https://code.claude.com/docs/ko/remote-control.md#what-connected-devices-see)을 통해 연결된 휴대폰 또는 브라우저의 effort 제어에서 선택한 수준은 해당 세션에만 적용됩니다.

[`-p` 실행](https://code.claude.com/docs/ko/headless)에서 `/effort`로 수준을 설정할 때, Claude Code는 해당 세션에만 적용하고 기본값으로 저장하지 않습니다.

`/effort` 슬라이더에는 **Ultracode** 토글도 있습니다. Ultracode는 모델 effort 수준이 아닌 Claude Code 설정입니다: 켜져 있으면, Claude는 세션이 실행되는 effort 수준에서 실질적인 작업에 대해 [동적 워크플로](https://code.claude.com/docs/ko/workflows.md)를 조율합니다. 지속적으로 설정할 수 있는 위치는 [`ultracode`](https://code.claude.com/docs/ko/settings-reference#ultracode) 설정을 참조하세요.

`/effort` 또는 `ultracode` 설정으로 ultracode를 켜거나 끄면 effort 수준은 변경되지 않습니다. `--effort ultracode` 플래그 및 Agent SDK `effortLevel: "ultracode"` 값은 이를 켜고 수준을 `xhigh`로 설정합니다. `/effort` 슬라이더 또는 `/model` 선택기에서 수준을 선택하면 ultracode는 그대로 유지됩니다.

다음 중 하나를 통해 ultracode를 켤 수 있습니다:

* **`/effort`**: 현재 세션에 대해 켜려면 `/effort ultracode`를 실행하거나 끄려면 `/effort ultracode off`를 실행하세요. `/effort` 슬라이더에서 `Tab`을 눌러 **Ultracode** 토글을 전환한 다음 `Enter`를 눌러 적용합니다
* **`--effort` 플래그**: `claude --effort ultracode`로 시작하여 `xhigh` effort와 ultracode가 켜진 상태로 세션을 시작합니다
* **`ultracode` 설정**: 설정 파일, `--settings` 또는 Agent SDK 제어 요청에서 [`"ultracode": true`](https://code.claude.com/docs/ko/settings-reference#ultracode)를 설정합니다. [`applyFlagSettings()`](https://code.claude.com/docs/ko/agent-sdk/typescript#applyflagsettings) 요청도 `effortLevel: "ultracode"`를 허용하며, 이는 이를 켜고 effort 수준을 `xhigh`로 설정합니다

`/effort ultracode off` 형식, 슬라이더 토글 및 `xhigh` 이외의 effort 수준에서 ultracode를 켜진 상태로 유지하려면 Claude Code v2.1.284 이상이 필요합니다. v2.1.284 이전에는 ultracode를 켜면 세션이 `xhigh` effort로 설정되고, 다른 수준을 선택하면 꺼지고, `xhigh` 아래의 effort 제한이 이를 사용할 수 없게 만들었습니다.

`--effort` 플래그 또는 Agent SDK `effortLevel` 값에 `ultracode`를 전달하려면 Claude Code v2.1.203 이상이 필요합니다. v2.1.203 이전에는 `--effort ultracode`가 `Unknown --effort value 'ultracode'`를 출력했고 세션이 기본 effort로 시작되었습니다.

지속된 `effortLevel` 설정 및 `CLAUDE_CODE_EFFORT_LEVEL` 환경 변수는 `ultracode`를 허용하지 않습니다. `CLAUDE_CODE_EFFORT_LEVEL` 또는 [effort 제한](#organization-effort-limits)이 세션의 수준을 설정하면, ultracode는 해당 수준에서 켜진 상태로 유지됩니다.

Ultracode는 다음과 같은 경우 사용할 수 없습니다:

* [워크플로가 꺼짐](https://code.claude.com/docs/ko/workflows.md#turn-workflows-off)
* 모델이 `xhigh` effort를 지원하지 않음

이 경우 `--effort ultracode`는 모델 및 제한이 허용하는 최고 effort 수준(최대 `xhigh`)에서 ultracode가 꺼진 상태로 세션을 시작합니다.

#### effort 수준 선택

각 수준은 토큰 지출과 성능 사이에서 균형을 맞춥니다. 기본값은 대부분의 코딩 작업에 적합합니다. 다른 균형을 원할 때 조정하세요.

| 수준 | 사용 시기 |
| :- | :- |
| `low` | 각 결과를 검토하는 빠른 교환(예: 브레인스토밍, 첫 번째 스케치 또는 이름 바꾸기와 같은 작은 변경) |
| `medium` | Opus 5.5, Sonnet 5.5 및 Haiku 5.5의 기본값입니다. Opus 5.5 및 Sonnet 5.5에서는 명확한 범위의 일상적인 엔지니어링 작업(예: 새 기능 구현)에 적합합니다. 기본값이 더 높은 모델에서는 일부 지능을 양보할 수 있는 비용 민감한 작업의 토큰 사용을 줄입니다 |
| `high` | 검증이 중요하거나 엣지 케이스가 발생할 가능성이 높은 작업(예: 기존 코드베이스의 버그 수정). Opus 5.5, Sonnet 5.5, Haiku 5.5 및 Opus 4.7을 제외한 모든 모델의 기본값 |
| `xhigh` | 더 높은 토큰 지출로 더 깊은 추론. Opus 4.7의 기본값 |
| `max` | 사용자의 개입 없이 Claude가 끝까지 처리하기를 원하는 어려운 문제(예: 보안 취약점 찾기). `max`는 수익 감소를 보일 수 있고 과도한 사고에 빠지기 쉬우므로, 광범위하게 채택하기 전에 테스트하세요 |
| `ultracode` | 수준이 아닌 Claude Code 설정: 모든 effort 수준에서 각 실질적인 작업에 대해 [동적 워크플로](https://code.claude.com/docs/ko/workflows.md)를 계획합니다 |

Opus 5.5 및 Fable 5.1의 테스트에서, Claude는 더 높은 수준에서 더 많은 엣지 케이스를 테스트하고 답변하기 전에 더 많은 작업을 검증했습니다. 또한 더 많은 선택을 독립적으로 했습니다. 더 낮은 수준에서, Claude는 시작점을 더 빨리 반환했으며, 이는 각 결과를 검토하고 다음 단계를 조율하는 작업에 적합합니다. 각 수준에서 실행되는 동일한 작업을 보려면, 블로그의 [Using Claude Code: Spending your effort](https://claude.dev/blog/spending-your-effort/)를 읽으세요.

effort 척도는 모델별로 보정되므로, 동일한 수준 이름이 모델 전체에서 동일한 기본 값을 나타내지 않습니다.

Opus 5.5는 [기본값 `medium`](#adjust-effort-level)으로 시작하며, Opus 5의 기본값 `high`보다 한 수준 아래입니다. Anthropic의 테스트에서, `medium`의 Opus 5.5는 코딩 및 지식 작업 평가에서 `high`의 Opus 5와 같거나 이를 초과합니다. 주어진 수준에서, Opus 5.5는 Opus 5보다 턴당 더 많이 사고하는 경향이 있습니다. Opus 5에서 Opus 5.5로 이동할 때, Opus 5에서 사용한 수준을 이월하는 대신 `medium`에서 시작하세요. 자신의 작업에 대해 수준을 테스트하려면, Opus 5.5 프롬프팅 가이드의 [Calibrate effort](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5#calibrate-effort)를 참조하세요.

#### 일회성 깊은 추론을 위해 ultrathink 사용

프롬프트의 어디든 `ultrathink`를 포함하여 세션 effort 설정을 변경하지 않고 해당 턴에서 더 깊은 추론을 요청합니다. Claude Code는 키워드를 인식하고 컨텍스트 내 지시를 추가합니다. Claude Code는 "think", "think hard" 및 "think more"와 같은 다른 구문을 일반 프롬프트 텍스트로 전달하고 키워드로 인식하지 않습니다.

터미널 프롬프트에 입력하면, 이 단어는 해당 턴을 `xhigh` effort로 높일 수도 있습니다. 높일 수 있는 경우 단어가 무지개 색으로 표시됩니다. Claude Code v2.1.311 이상이 필요합니다. 새 턴을 시작할 때 단어가 무지개 색으로 표시되지 않으면 다음 중 하나를 시도하세요:

* 따옴표, 괄호, 경로 또는 명령과 같은 것의 바깥에서, `/`로 시작하지 않는 프롬프트에 다시 입력합니다
* `CLAUDE_CODE_EFFORT_LEVEL`이 `xhigh` 미만으로 설정되어 있으면 설정을 해제합니다. 또는 자신의 [`maxEffortLevel`](https://code.claude.com/docs/ko/settings-reference#maxeffortlevel)을 `xhigh` 이상으로 높이거나, 조직 관리자에게 [조직의 제한](#organization-effort-limits)을 높여 달라고 요청합니다
* 세션에서 `/model`을 실행하여 Opus 5.5, Sonnet 5.5, Haiku 5.5 또는 Fable 5.1 모델로 전환합니다. Amazon Bedrock처럼 이 단어가 턴을 높일 수 없는 경우에는 대신 [effort 수준을 설정](#set-the-effort-level)합니다

#### effort 수준 설정

다음 중 하나를 통해 effort를 변경할 수 있습니다:

* **`/effort`**: 대화형 슬라이더를 열려면 인수 없이 `/effort`를 실행하고, 직접 설정하려면 `/effort` 뒤에 수준 이름을 붙여 실행하거나, 활성 모델에 대해 저장된 수준을 지우려면 `/effort auto`를 실행합니다
* **`/model`에서**: 모델을 선택할 때 왼쪽/오른쪽 화살표 키를 사용하여 effort 슬라이더를 조정합니다. 새 수준은 늦어도 다음 메시지부터 시작됩니다. 그때까지 Claude는 새 모델에서도 이전 수준으로 계속 작업할 수 있습니다. `CLAUDE_CODE_EFFORT_LEVEL`처럼 [사용자의 선택보다 우선하는 소스](#adjust-effort-level)가 적용되는 동안에는 Claude가 대신 해당 소스의 수준으로 작업합니다.
* **`--effort` 플래그**: Claude Code를 시작할 때 단일 세션에 대해 설정하려면 수준 이름을 전달합니다
* **환경 변수**: `CLAUDE_CODE_EFFORT_LEVEL`을 수준 이름으로 설정합니다. Claude Code가 [effort 수준을 보내지 않도록](#send-no-effort-level) 하려면 대신 `auto` 또는 `unset`으로 설정합니다
* **설정**: [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings)에서 모델별 수준을 설정하거나, [`effortLevel`](https://code.claude.com/docs/ko/settings-reference#effortlevel)을 `low`, `medium`, `high` 또는 `xhigh`로 설정하여 수준이 없는 모델의 기본값으로 설정합니다. `max`는 두 키에서 수준으로 허용되지 않으며, `ultracode`는 자체 [`ultracode`](https://code.claude.com/docs/ko/settings-reference#ultracode) 키를 가집니다
* **연결된 장치에서**: [Remote Control](https://code.claude.com/docs/ko/remote-control.md#what-connected-devices-see) 세션에서, 휴대폰 또는 브라우저의 effort 제어에서 수준을 선택합니다. 수준은 현재 세션에만 적용됩니다. Claude Code v2.1.234 이상이 필요합니다
* **스킬 및 서브에이전트 frontmatter**: [스킬](https://code.claude.com/docs/ko/skills.md#frontmatter-reference) 또는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#supported-frontmatter-fields) markdown 파일에서 `effort`를 설정하여 해당 스킬 또는 서브에이전트가 실행될 때 effort 수준을 재정의합니다

스킬의 `effort`는 해당 스킬이 실행된 턴이 끝날 때까지 적용되며, `context: fork`를 사용하면 포크된 서브에이전트가 실행되는 동안 적용됩니다. 서브에이전트의 `effort`는 [호출 시 재정의](https://code.claude.com/docs/ko/sub-agents.md#choose-an-effort-level)되지 않는 한 서브에이전트가 실행되는 동안 적용됩니다. 둘 중 하나가 적용되는 동안에는 시작 시 지정하거나 저장하거나 선택한 수준과 관계없이 스킬 또는 서브에이전트가 자체 수준으로 실행됩니다. `CLAUDE_CODE_EFFORT_LEVEL`이 설정되어 있으면 대신 그 수준이 적용됩니다.

[`maxEffortLevel`](https://code.claude.com/docs/ko/settings-reference#maxeffortlevel) 또는 [조직 effort 제한](#organization-effort-limits)은 여전히 스킬 또는 서브에이전트가 실행되는 수준을 제한합니다. [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `effortLevel`을 설정하면, Claude Code는 [effort 확인 순서](#adjust-effort-level)의 설정 단계에서 적용하고, 사용자는 여전히 `/effort` 또는 `--effort`로 수준을 변경할 수 있습니다. 사용자를 특정 수준 이하로 유지하려면, [`maxEffortLevel`](https://code.claude.com/docs/ko/settings-reference#maxeffortlevel)을 설정하세요.

#### 설정한 effort 수준 확인

effort 슬라이더는 지원되는 모델이 선택되었을 때 `/model`에 나타납니다. 세션 헤더에 표시되는 수준(예: "with low effort")은 effort 설정에서 온 것이며, Claude가 [아직 이전 수준으로 작업 중](#when-a-new-effort-level-starts)이더라도 마찬가지입니다. 시작 시와 수준을 변경할 때 바닥글에도 세션에 설정된 수준이 잠시 표시됩니다.

#### 새 effort 수준이 시작되는 시점

터미널 세션에서 `/effort`가 새 수준을 확인하면, 다음에 보내는 메시지가 해당 수준으로 실행됩니다. 진행 중인 턴이 끝난 후 또는 [Claude가 아직 작업 중일 때](https://code.claude.com/docs/ko/interactive-mode.md#queue-messages-while-claude-works) 메시지를 보낼 수 있습니다:

* **턴이 끝난 후**: 그때까지 아무것도 할 필요가 없으며, 턴이 이전 수준으로 끝나는 것은 예상된 동작입니다
* **Claude가 아직 작업 중일 때**: `keep going`과 같은 메시지를 입력하고 `Enter`를 눌러 턴을 중단하지 않고 대기열에 추가합니다. Claude는 현재 도구 호출이 끝날 때, 늦어도 턴이 끝날 때 이를 받으며, 그때부터 새 수준으로 작업합니다.

v2.1.242 이전에는 Claude Code가 턴이 끝날 때까지 `/effort` 자체를 대기열에 넣을 수 있었으며, [서드파티 제공자](https://code.claude.com/docs/ko/third-party-integrations.md)에서처럼 [기능 플래그를 가져오지](https://code.claude.com/docs/ko/env-vars.md#features-that-need-feature-flag-fetching) 않는 세션에서는 항상 그렇게 했습니다.

#### effort 수준 보내지 않기

Claude Code가 [지원되는 모델](#adjust-effort-level)에 effort 수준을 보내지 않으면, Claude Code의 기본값 대신 [API의 기본값](https://platform.claude.com/docs/en/build-with-claude/effort)이 적용됩니다. Claude Code가 effort 수준을 보내지 않게 하려면, `CLAUDE_CODE_EFFORT_LEVEL`을 `auto` 또는 `unset` 값으로 export하는 셸에서 `claude`를 시작하세요. 두 값은 동일하게 동작합니다:

```bash theme={null}
export CLAUDE_CODE_EFFORT_LEVEL=auto
```

수준이 전송되지 않는 동안 세션 헤더와 바닥글에는 effort 수준이 표시되지 않습니다. 수준이 전송되지 않는지 확인하려면 Claude Code 프롬프트에서 `/effort status`를 실행하세요:

* **`Effort level: auto`**: effort 수준이 전송되지 않습니다.
* **`Effort level: auto (currently <level>)`**: 수준이 여전히 전송됩니다. 활성 모델에 `max` 미만의 [`maxEffortLevel`](https://code.claude.com/docs/ko/settings-reference#maxeffortlevel) 설정이 적용되면, Claude Code는 해당 모델에 대한 자체 기본값을 그 제한까지 낮춰 보냅니다. 해당 설정을 제거하거나 `max`로 설정하세요.

> [!NOTE]
>
> v2.1.304 이전에는 수준이 전송되지 않는 동안에도 `/effort status`가 `Effort level: auto (currently high)`를 출력했습니다.

#### 적응형 추론 및 고정 사고 예산

적응형 추론은 각 단계에서 사고를 선택 사항으로 만들므로, Claude는 일상적인 프롬프트에 더 빠르게 응답하고 이점을 얻는 단계를 위해 더 깊은 사고를 남겨 둘 수 있습니다. 현재 수준이 생성하는 것보다 Claude가 더 자주 또는 덜 자주 사고하기를 원하면, 프롬프트 또는 `CLAUDE.md`에서 직접 말할 수 있습니다. 모델은 effort 설정 내에서 해당 지침에 응답합니다.

Fable 모델, Sonnet 5 이상, Haiku 5.5 및 Opus 4.7 이상은 항상 적응형 추론을 사용합니다. 고정 사고 예산 모드 및 `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`은 이들에게 적용되지 않습니다.

Opus 4.6 및 Sonnet 4.6에서는 `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`을 설정하여 `MAX_THINKING_TOKENS`로 제어되는 이전 고정 사고 예산으로 되돌릴 수 있습니다. [환경 변수](https://code.claude.com/docs/ko/env-vars.md)를 참조하세요.

### 확장 사고

확장 사고는 Claude가 응답하기 전에 내보내는 추론입니다. [적응형 추론](#adjust-effort-level)을 지원하는 모델에서, effort 수준은 얼마나 많은 사고가 발생하는지에 대한 주요 제어이며, 아래 설정은 사고를 켜거나 끄고 표시 방식을 제어합니다. Anthropic API에서 사고가 꺼져 있으면, Claude Code는 Opus 5와 같이 [해당 조합을 허용하지 않는](https://code.claude.com/docs/ko/errors.md#effort-isnt-available-with-thinking-turned-off) 모델에 더 높은 수준 대신 effort `high`를 보냅니다.

| 제어 | 설정 방법 |
| :- | :- |
| 현재 세션에 대한 토글 | macOS에서 `Option+T` 또는 Windows 및 Linux에서 `Alt+T`를 누릅니다 |
| 전역 기본값 설정 | `/config`를 실행하고 사고 모드를 토글합니다. `~/.claude/settings.json`에서 `alwaysThinkingEnabled`로 저장됩니다 |
| 환경 변수를 통해 비활성화 | [`MAX_THINKING_TOKENS=0`](https://code.claude.com/docs/ko/env-vars)을 설정하면 Opus 5.5, Sonnet 5.5, Haiku 5.5 및 Fable 모델을 제외하고 Anthropic API에서 사고가 꺼집니다. [서드파티 제공자](https://code.claude.com/docs/ko/third-party-integrations.md)에서는 Claude Code가 대신 `thinking` 매개변수를 생략하며, 적응형 추론 모델은 여전히 사고할 수 있습니다 |

Opus 5.5, Sonnet 5.5, Haiku 5.5 또는 Fable 모델에서는 사고를 끌 수 없습니다. 세션 토글 및 `/config` 행은 스위치를 제공하는 대신 이 모델들에 대해 `Thinking can't be turned off`를 표시하고, 저장된 `alwaysThinkingEnabled: false` 또는 `MAX_THINKING_TOKENS=0`은 여기에 영향을 주지 않습니다. 이 모델들에서는 모델이 effort 수준에 따라 각 단계에서 얼마나 사고할지 결정합니다. 저장된 설정은 이를 허용하는 모델로 전환할 때 다시 적용됩니다.

Claude Code는 기본적으로 사고 출력을 축소합니다. `Ctrl+O`를 눌러 상세 모드를 토글하고 회색 기울임꼴 텍스트로 추론을 봅니다. Anthropic API의 대화형 세션은 기본적으로 편집된 thinking 블록을 수신하므로, 확장할 때 전체 요약을 사용 가능하게 하려면 [설정](https://code.claude.com/docs/ko/settings.md)에서 `showThinkingSummaries: true`를 설정하세요. 축소되거나 편집된 경우에도 생성된 모든 사고 토큰에 대해 청구됩니다.

### 확장 컨텍스트

Fable 5.1, Fable 5, Sonnet 5 이상, Haiku 5.5, Opus 4.6 이상 및 Sonnet 4.6은 큰 코드베이스가 있는 긴 세션을 위해 [1백만 토큰 컨텍스트 윈도우](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)를 지원합니다.

Fable 5.1, Fable 5, Sonnet 5 이상, Haiku 5.5 및 Opus 4.7 이상은 `[1m]` 접미사 없이 기본적으로 1M 윈도우로 실행됩니다. 여기에는 Amazon Bedrock, Google Cloud의 Agent Platform 및 Microsoft Foundry의 세션과 [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway) 세션이 포함됩니다. 대신 200K 윈도우로 실행하려면 [1M 컨텍스트 끄기](#turn-off-1m-context)를 참조하세요.

Opus 4.6 및 Sonnet 4.6은 `[1m]` 변형을 통해서만 1M에 도달하며, 해당 변형에 대한 액세스는 플랜에 따라 다릅니다. Max, Ultra, Team 및 Enterprise 플랜(Team Standard 및 Team Premium 좌석 모두 포함)에서, 1M 컨텍스트가 있는 Opus 4.6은 구독에 포함됩니다. 1M 컨텍스트가 있는 Sonnet 4.6은 모든 구독 플랜(Max 및 Ultra 포함)에서 [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)이 필요합니다.

| 플랜 | 1M 컨텍스트가 있는 Opus 4.6 | 1M 컨텍스트가 있는 Sonnet 4.6 |
| - | - | - |
| Max, Ultra, Team 및 Enterprise | 구독에 포함됨 | [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) 필요 |
| Pro | [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) 필요 | [사용량 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) 필요 |
| API 및 종량제 | 전체 액세스 | 전체 액세스 |

Claude Code는 Anthropic API에 직접 연결할 때만 이러한 플랜 요구 사항을 확인합니다. 저장된 claude.ai 로그인이 활성 자격 증명으로 유지되는 동안 `ANTHROPIC_BASE_URL`을 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway#subscriptions-and-gateways)로 지정하면, Claude Code는 플랜의 사용량 크레딧을 확인하지 않습니다. `[1m]` 옵션은 `/model`에서 사용 가능하게 유지되고, 게이트웨이가 요청의 성공 여부를 결정합니다. v2.1.229 이전에는 Claude Code가 해당 구성에서 계정의 사용량 크레딧을 확인할 수 없을 때 `/model sonnet[1m]`을 거부했습니다.

Anthropic API에서 1M 컨텍스트 윈도우는 200K를 초과하는 토큰에 대한 프리미엄 없이 표준 모델 가격을 사용합니다. 단, Haiku 5.5는 [100K 토큰보다 긴 프롬프트에서 비용이 더 높습니다](#haiku-5-5-context-window-and-pricing). 확장 컨텍스트가 구독에 포함된 플랜의 경우, 사용은 계속 구독에 포함됩니다. 사용량 크레딧을 통해 확장 컨텍스트에 액세스하는 플랜의 경우, 토큰은 사용량 크레딧으로 청구됩니다.

#### Opus 4.6 또는 Sonnet 4.6에 대해 1M 컨텍스트 선택

이름으로 1M 변형을 선택하려면, 모델 별칭 또는 전체 모델 이름에 `[1m]` 접미사를 추가하세요:

```text theme={null}
# Append [1m] to a full model name
/model claude-opus-4-6[1m]
/model claude-sonnet-4-6[1m]

# Or to an alias: the suffix applies to the model the alias resolves to
/model opus[1m]
```

#### LLM 게이트웨이 뒤의 컨텍스트 윈도우

`ANTHROPIC_BASE_URL`을 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 또는 다른 프록시로 설정하면, Claude Code는 인식하는 각 모델에 Anthropic API에서 해당 모델이 가진 것과 동일한 컨텍스트 윈도우를 제공합니다. Fable 5.1, Fable 5, Sonnet 5 이상, Haiku 5.5 및 Opus 4.7 이상은 선택할 `[1m]` 변형 없이 1M 윈도우를 얻고, Opus 4.6과 같이 `[1m]` 변형을 통해서만 1M에 도달하는 모델은 해당 변형 없이는 200K에서 실행됩니다. Claude Code는 게이트웨이 또는 그 뒤의 서버가 적용하는 더 낮은 제한을 감지할 수 없습니다. 게이트웨이가 200K 토큰을 초과하는 요청을 거부하면, Claude Code를 시작하는 환경에서 [`CLAUDE_CODE_AUTO_COMPACT_WINDOW=200000`](https://code.claude.com/docs/ko/env-vars)을 설정하여 모든 모델의 세션이 [해당 경계에서 압축](#set-the-auto-compact-window)되도록 하세요.

#### 1M 컨텍스트 끄기

세션을 200K 윈도우로 유지하려면, 셸 또는 [설정 파일](https://code.claude.com/docs/ko/env-vars.md#set-environment-variables)에서 `CLAUDE_CODE_DISABLE_1M_CONTEXT=1`을 설정하세요. Claude Code는 모델 선택기에서 `[1m]` 모델 변형을 제거합니다. Fable 모델, Sonnet 5 이상, Opus 4.7 이상처럼 기본적으로 1M 윈도우로 실행되는 모델에서는 모델을 200K 컨텍스트 윈도우를 가진 것으로 취급합니다:

* 자동 압축이 켜져 있으면, 세션은 [자동 압축](#set-the-auto-compact-window)을 통해 200K 경계에서 압축됩니다. 자동 압축 윈도우를 200K 위로 설정해도 보류가 해제되지 않습니다. Claude Code는 해당 윈도우를 모델의 컨텍스트 윈도우로 제한하기 때문입니다.
* 자동 압축이 꺼져 있으면, 세션은 압축하는 대신 200K 경계에서 [컨텍스트 제한 오류](https://code.claude.com/docs/ko/errors.md#prompt-is-too-long)로 중지됩니다.

#### Haiku 5.5 컨텍스트 윈도우 및 가격

Anthropic API에서, Haiku 5.5는 모든 플랜에서 1M 컨텍스트 윈도우로 실행되며, 선택할 `[1m]` 접미사가 없습니다. 모델 ID는 `claude-haiku-5-5`입니다. 사용하려면 세션에서 `/model claude-haiku-5-5`를 실행하거나, 셸에서 `claude --model claude-haiku-5-5`로 Claude Code를 시작하세요.

Haiku 5.5 요청은 프롬프트가 100K 토큰보다 길면 토큰당 비용이 더 높습니다. 두 요금은 [Anthropic 가격](https://platform.claude.com/docs/en/about-claude/pricing)을 참조하세요.

세션은 기본적으로 약 967K 토큰에서 자동 압축됩니다. 더 일찍 압축하려면, 해당 모델에 대해 [더 작은 자동 압축 윈도우를 설정](#set-the-auto-compact-window)하세요.

## 컨텍스트 윈도우 및 자동 압축

자동 압축 윈도우는 Claude Code가 대화를 압축하기 전에 컨텍스트 윈도우가 얼마나 찬 상태인지를 나타냅니다. 압축 메커니즘별로 유지되고 삭제되는 항목에 대해서는 [압축 후 유지되는 항목](https://code.claude.com/docs/ko/context-window.md#what-survives-compaction)을 참조하십시오.

### 자동 압축 윈도우 설정

> [!NOTE]
>
> Claude Code가 `CLAUDE_CODE_AUTO_COMPACT_WINDOW` 값에 대해 경고한 경우 [변수의 값과 경고](#claude_code_auto_compact_window-values)를 참조하십시오.

자동 압축 윈도우는 다음 위치에서 설정할 수 있습니다.

* **현재 모델에 대해, 이 세션 및 이후 세션의 경우**: `/autocompact`를 값과 함께 실행합니다(예: `/autocompact 500k`). Claude Code는 이를 사용자 설정의 [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings) 아래 현재 모델 항목에 저장하고 현재 세션에 적용합니다. 관리형 설정과 같은 더 높은 우선순위의 [설정 범위](https://code.claude.com/docs/ko/settings.md#settings-precedence)가 해당 모델 또는 모든 모델에 대해 자체 윈도우를 설정하면 명령은 값을 저장하지만 세션은 해당 범위의 윈도우를 유지하며 명령이 이를 알립니다. `/autocompact auto`를 실행하여 모델에 맞게 조정된 윈도우로 돌아갑니다. v2.1.288 이전에는 이 명령이 모든 모델에 대해 하나의 윈도우를 최상위 `autoCompactWindow`로 저장했습니다.
* **모든 모델의 경우**: 설정 파일에서 [`autoCompactWindow`](https://code.claude.com/docs/ko/settings-reference#autocompactwindow)를 설정합니다(예: `~/.claude/settings.json`의 `"autoCompactWindow": 200000`). `/autocompact`로 특정 모델에 대해 저장한 윈도우는 해당 모델에 대해 같은 파일의 이 키보다 우선합니다.
* **한 번의 실행의 경우**: Claude Code를 시작할 때 [`--autocompact`](https://code.claude.com/docs/ko/cli-reference#cli-flags)를 전달합니다. 플래그는 저장된 설정을 변경하지 않고 해당 실행에 대해 저장된 설정을 재정의하며, `claude --autocompact auto`는 저장된 설정에 값이 있더라도 조정된 윈도우에서 세션을 실행합니다. `/autocompact`와 달리 플래그는 관리형 설정과 같은 더 높은 우선순위의 설정 범위에 의해 선점되지 않습니다.
* **스크립트 및 클라우드 환경에서**: [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](https://code.claude.com/docs/ko/env-vars)를 `200000`과 같은 토큰 수로 설정합니다. Claude Code가 [값을 무시](#claude_code_auto_compact_window-values)하지 않는 한 이 변수는 명령, 플래그 및 `autoCompactWindow` 설정보다 우선합니다. 이 경우 `/autocompact`는 저장하지 않고 재정의를 보고합니다. 상태줄의 `used_percentage`는 모델의 전체 컨텍스트 윈도우를 기준으로 측정하므로, 변수가 설정되어 있는 동안에는 이 백분율이 압축이 실행되는 시점을 나타내지 않습니다.
* **하나의 서브에이전트의 경우**: [하나의 서브에이전트에 대한 자동 압축 윈도우 설정](https://code.claude.com/docs/ko/sub-agents.md#subagent-auto-compact-window)을 참조하십시오.

명령과 플래그는 다음 형식 중 하나로 100K에서 1M 토큰 범위의 윈도우 크기를 허용합니다.

* 일반 토큰 수(예: `200000`)
* `k` 또는 `M` 접미사(예: `500k` 또는 `1M`)
* 100에서 1000 사이의 숫자(천 단위를 의미하므로 `200`은 200,000을 설정함)

윈도우를 어떤 방식으로 설정하든 Claude Code는 윈도우를 모델의 컨텍스트 윈도우로 제한합니다.

#### `CLAUDE_CODE_AUTO_COMPACT_WINDOW`의 값과 경고

`CLAUDE_CODE_AUTO_COMPACT_WINDOW` 값을 인용하는 경고는 해당 값이 100,000에서 1,000,000 범위를 벗어나거나 토큰 수가 아니라는 의미입니다. 경고를 없애려면 `CLAUDE_CODE_AUTO_COMPACT_WINDOW=200000`과 같이 해당 범위의 숫자를 설정하십시오. Claude Code v2.1.304 이상에서는 `200k` 또는 `1M`처럼 천 단위에는 `k`, 백만 단위에는 `M`을 붙여 숫자를 작성할 수도 있습니다.

첫 번째 열에서 경고 문구를 찾은 다음, 같은 행에서 세션이 사용하는 윈도우와 변경할 사항을 확인하십시오.

| 경고에 포함된 문구 | 세션이 사용하는 윈도우 | 변경할 사항 |
| :- | :- | :- |
| `reads as <N> tokens, so Claude Code treats it as the 100k minimum` | 100,000 토큰과 모델의 컨텍스트 윈도우 중 더 작은 값 | `200000`처럼 `100000` 이상으로 설정하거나, `200`을 천 단위로 의도했다면 `200k`로 설정 |
| `is too large, so Claude Code treats it as the 1M maximum` | 1,000,000 토큰과 모델의 컨텍스트 윈도우 중 더 작은 값 | 이미 가장 큰 윈도우를 사용하고 있습니다. 경고를 없애려면 `1M` 또는 `1000000`으로 설정 |
| `isn't a usable size, so Claude Code ignores it` | `--autocompact`, `/autocompact` 또는 `autoCompactWindow`의 윈도우, 아무것도 설정되지 않은 경우 [기본값](#default-auto-compact-thresholds) | `200000`과 같은 숫자를 설정하거나 변수를 설정 해제 |

접미사가 없는 숫자는 그만큼의 토큰 수로 읽히므로, `/autocompact 200`은 200,000을 의미하지만 `CLAUDE_CODE_AUTO_COMPACT_WINDOW=200`은 200 토큰을 의미합니다.

### 기본 자동 압축 임계값

자동 압축 윈도우를 설정하지 않으면 Claude Code는 다음 세션을 제외하고 대화가 모델의 컨텍스트 제한에 도달할 때 압축합니다.

* [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)은 대화가 모델 제한에 접근할 때 압축합니다.
* Sonnet 4.6 및 Opus 4.6([확장 컨텍스트](#extended-context) 없음)은 200K 경계에서 압축합니다.
* [`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](https://code.claude.com/docs/ko/env-vars)을 설정하면 Sonnet 5 및 Fable 모델과 같이 기본 1M 윈도우가 있는 모델은 200K 경계에서 압축합니다.
* 기본 1M 윈도우로 실행되는 모델은 윈도우가 채워지기 전에 압축되며, 기본적으로 약 967K 토큰에서 압축됩니다. 여기에는 Fable 모델, Sonnet 5 이상, Haiku 5.5, Opus 4.7 이상이 포함됩니다. 사용자 정의 `ANTHROPIC_BASE_URL` 뒤에서는 [게이트웨이 뒤의 컨텍스트 윈도우](#context-window-behind-a-gateway)를 참조하십시오.
* Claude Code가 인식하지 못하는 모델 ID(예: [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 별칭)의 세션은 Claude Code가 ID에 대해 가정하는 컨텍스트 윈도우에서 압축합니다. [게이트웨이 또는 사용자 정의 모델 ID의 윈도우 수정](#correct-the-window-for-a-gateway-or-custom-model-id)을 참조하십시오.

유휴 상태로 둔 대화도 Claude Code가 압축하는 경우에 대해서는 [`idleCompaction`](https://code.claude.com/docs/ko/settings-reference#idlecompaction) 설정을 참조하십시오.

### 게이트웨이 또는 사용자 정의 모델 ID의 윈도우 수정

다음 시작 경고 중 하나가 표시되면 Claude Code가 세션의 모델 ID를 인식하지 못한다는 의미이며, 이 경우 Claude Code는 모델의 컨텍스트 윈도우를 파악할 수 없으므로 200K 토큰으로 가정합니다.

```text theme={null}
⚠ Model "my-gateway-opus" isn't recognized · context assumed to be 200k tokens · ...
Claude Code doesn't recognize the model "my-gateway-opus", so it assumes a context window of 200k tokens. Update Claude Code, or see https://code.claude.com/docs/en/model-config#correct-the-window-for-a-gateway-or-custom-model-id to set the window.
```

Claude Code는 가정된 200K에서 대화를 [자동 압축](#default-auto-compact-thresholds)하므로, 모델의 실제 컨텍스트 윈도우가 200K라면 수정할 것이 없습니다. 그렇지 않은 경우 다음 방법 중 ID에 맞는 방법으로 Claude Code에 실제 윈도우를 알려 주십시오.

* **사용 중인 Claude Code 버전보다 새로운 모델**: 셸에서 `claude update`를 실행합니다. 업데이트 후 Claude Code가 ID를 인식하면 다른 구성은 필요하지 않습니다.
* **Claude Code가 알고 있는 모델에 대한 게이트웨이 또는 공급자의 이름**: Anthropic 모델 ID를 사용자의 ID에 매핑하는 [`modelOverrides`](#override-model-ids-per-version) 항목을 추가합니다(예: `"claude-opus-4-8": "my-gateway-opus"`). 대신 `behavesAs`를 해당 모델로 설정한 [`modelPicker`](https://code.claude.com/docs/ko/settings-reference#fields-for-modelpicker) 행에 ID를 나열할 수도 있습니다. 어느 방법을 사용하든 Claude Code는 해당 ID를 그 모델로 취급합니다.
* **1M 윈도우가 있는 모델**: 모델을 설정하는 위치에서 ID에 `[1m]`을 추가합니다(예: 셸에서 `claude --model 'my-gateway-opus[1m]'`). [1M 컨텍스트를 끈](#turn-off-1m-context) 경우에는 접미사 유무와 관계없이 동일한 윈도우가 적용됩니다.
* **기타 윈도우**: Claude Code를 시작하는 환경에서 [`CLAUDE_CODE_MAX_CONTEXT_TOKENS`](https://code.claude.com/docs/ko/env-vars)를 토큰 단위의 윈도우 크기로 설정합니다(예: `CLAUDE_CODE_MAX_CONTEXT_TOKENS=400000`). `claude-`로 시작하지 않고 `[1m]` 접미사가 없는 인식되지 않은 ID의 경우 이 변수는 단독으로 적용됩니다. 그 외의 ID의 경우 먼저 [적용되는 ID](#which-ids-claude_code_max_context_tokens-applies-to)를 확인하십시오.

Claude Code가 ID를 인식하거나 지정한 윈도우를 사용하게 되면, 해당 ID로 세션을 시작할 때 더 이상 경고가 표시되지 않습니다.

#### `CLAUDE_CODE_MAX_CONTEXT_TOKENS`가 적용되는 ID

[LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway) 또는 기타 사용자 정의 배포에서 Claude Code는 모델 ID가 모델의 실제 윈도우와 다른 컨텍스트 윈도우를 가정할 수 있습니다(ID가 Claude 모델로 확인되는지 여부와 관계없이). [`CLAUDE_CODE_MAX_CONTEXT_TOKENS`](https://code.claude.com/docs/ko/env-vars)를 Claude Code가 대신 가정해야 하는 윈도우로 설정합니다.

변수가 적용되는 방식은 ID에 따라 다릅니다. Claude Code는 ID가 `claude-`로 시작하지 않을 때(대소문자 관계없이) 또는 Google Cloud의 Agent Platform에서 사용되는 `@YYYYMMDD` 날짜와 같이 Claude Code가 ID를 읽을 때 제거하는 접미사를 가질 때 ID를 공급자 또는 사용자 정의 철자로 취급합니다. v2.1.259 이전에는 Claude Code가 제거된 접미사를 계산하지 않았으므로 날짜 접미사가 있는 인식되지 않은 `claude-` ID는 베어 `claude-` 이름으로 취급되었습니다.

인식되지 않은 공급자 또는 사용자 정의 철자, `[1m]`이 있는 동일한 철자, 그리고 다른 모든 ID는 세 가지 별도의 경우입니다.

* Claude Code가 공급자 또는 사용자 정의 철자를 인식하는 모델로 확인할 수 없고 ID에 `[1m]`이 포함되지 않으면 변수가 직접 적용되고 선제적 압축은 선언된 윈도우에서 계속됩니다.
* Claude Code가 공급자 또는 사용자 정의 철자를 인식하는 모델로 확인할 수 없고 ID에 `[1m]`이 포함되면(대소문자 관계없이) Claude Code는 이에 대해 1M 윈도우를 가정하고 변수는 자체적으로 적용되지 않습니다. 선제적 압축을 유지하면서 윈도우를 수정하려면 [`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](https://code.claude.com/docs/ko/env-vars)도 설정합니다. 해당 변수가 설정되면 Claude Code는 ID를 `[1m]` 없는 동일한 철자처럼 크기를 조정하므로 `CLAUDE_CODE_MAX_CONTEXT_TOKENS`는 해당 태그 없는 철자에 적용될 때 적용됩니다.

  선언된 윈도우가 200K를 초과하면 이 구성에서는 [200K 제한이 적용되지 않는다](https://code.claude.com/docs/ko/errors.md#the-200k-limit-isnt-enforced)는 경고가 표시되는 것이 정상입니다.
* ID가 Claude Code가 인식하는 모델로 확인되거나 ID가 Claude Code가 제거할 접미사가 없는 베어 `claude-` 이름인 경우(대소문자 관계없이) 변수는 [`DISABLE_COMPACT`](https://code.claude.com/docs/ko/env-vars)도 설정할 때만 적용되며, 이는 모든 압축을 비활성화합니다.

  예를 들어 `anthropic/claude-opus-4-8`, `us.anthropic.claude-…-v1:0` 또는 날짜가 지정된 `claude-sonnet-4-5@20250929`와 같이 Claude Code가 알고 있는 Claude 모델 이름을 포함하는 ID는 해당 모델로 확인됩니다. 여기에는 `[1m]`도 포함하는 ID가 포함됩니다. Claude Code는 `CLAUDE_CODE_DISABLE_1M_CONTEXT`가 설정되어 있어도 `claude-opus-4-8[1m]`을 Opus 4.8로 확인합니다.

Claude Code가 인식하지 못하는 모델 ID의 경우 [`CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT=1`](https://code.claude.com/docs/ko/env-vars)을 설정하여 Claude Code가 [Claude Code가 인식하는 너무 긴 오류](https://code.claude.com/docs/ko/errors.md#prompt-is-too-long)로 API가 대화를 거부한 후에만 압축하도록 합니다. Claude Code는 게이트웨이가 [오류를 다시 작성](https://code.claude.com/docs/ko/llm-gateway-connect.md#troubleshoot-gateway-errors)하여 Claude Code가 인식하지 못하는 표현으로 변경할 때 해당 복구를 실행하지 않습니다.

## 현재 모델 확인

현재 사용 중인 모델을 두 가지 위치에서 확인할 수 있습니다:

* [상태 줄](https://code.claude.com/docs/ko/statusline.md)에서(구성된 경우)
* `/status`에서, 계정 정보도 표시합니다

## 사용자 정의 모델 옵션 추가

`ANTHROPIC_CUSTOM_MODEL_OPTION`을 사용하여 기본 제공 별칭을 대체하지 않고 `/model` 선택기에 단일 사용자 정의 항목을 추가합니다. 이는 Claude Code가 기본적으로 나열하지 않는 모델 ID를 테스트하는 데 유용합니다. LLM 게이트웨이 배포의 경우, Claude Code는 `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`이 설정되어 있을 때 게이트웨이의 `/v1/models` 엔드포인트에서 선택기를 자동으로 채울 수 있으므로, 이 변수는 검색이 비활성화되었거나 원하는 모델을 반환하지 않을 때만 필요합니다. [게이트웨이 모델 검색](https://code.claude.com/docs/ko/llm-gateway-protocol.md#model-discovery)을 참조하십시오.

여러 모델을 나열하려면 대신 자신의 순서대로 선택한 레이블 아래에 [`modelPicker`](https://code.claude.com/docs/ko/settings-reference#modelpicker)를 설정합니다. 해당 항목은 해당 라인업이 기본 제공 항목을 대체할 때 선택기가 유지하는 행을 나타냅니다.

이 예시는 게이트웨이 라우팅된 Opus 배포를 선택 가능하게 하기 위해 세 가지 변수를 모두 설정합니다. Claude Code는 시작 시 환경 변수를 읽으므로, `claude`를 시작하기 전에 내보내기를 실행하거나 기존 세션을 다시 시작하여 변수를 적용합니다:

```bash theme={null}
export ANTHROPIC_CUSTOM_MODEL_OPTION="my-gateway/claude-opus-5-5"
export ANTHROPIC_CUSTOM_MODEL_OPTION_NAME="Opus via Gateway"
export ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION="Custom deployment routed through the internal LLM gateway"
```

`ANTHROPIC_CUSTOM_MODEL_OPTION_NAME` 및 `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION`은 선택 사항입니다:

* 이름을 생략하면 Claude Code가 ID를 [인식](#customize-pinned-model-display-and-capabilities)할 때 항목에 모델의 이름이 표시되고, 그렇지 않으면 모델 ID가 표시됩니다.
* 설명을 생략하면 Claude Code는 `Custom model (<model-id>)`를 사용합니다.

Claude Code는 기본 제공 항목 다음에 사용자 정의 항목을 나열하며, 추가하는 모든 [`modelPicker`](https://code.claude.com/docs/ko/settings-reference#modelpicker) 행은 그 다음에 나타납니다.

Claude Code는 `ANTHROPIC_CUSTOM_MODEL_OPTION`에 설정된 모델 ID에 대한 유효성 검사를 건너뜁니다. 따라서 API 엔드포인트가 허용하는 모든 문자열을 사용할 수 있습니다.

[`availableModels`](#restrict-model-selection)이 설정되어 있을 때는 사용자 정의 모델 ID를 허용 목록에도 포함시켜야 합니다. 그렇지 않으면 Claude Code는 선택기에서 사용자 정의 항목을 필터링하고 다른 제외된 모델처럼 `--model` 선택을 거부합니다.

`my-gateway/claude-opus-5-5`와 같이 패밀리 이름을 포함하는 사용자 정의 ID는 해당 패밀리의 특정 항목으로 계산되며 와일드카드를 비활성화하므로, 선택 가능하게 유지하려는 버전도 나열해야 합니다. [병합 동작](#merge-behavior)을 참조하십시오.

## 환경 변수

다음 환경 변수를 사용하여 별칭이 매핑되는 모델 이름을 제어할 수 있습니다. 각 값은 전체 모델 이름이거나 API 제공업체의 동등한 식별자여야 합니다. 세션이 시작될 때 사용할 모델을 선택하려면 이 표에서 생략된 [`ANTHROPIC_DEFAULT_MODEL`](#set-a-default-model-for-new-sessions)을 설정합니다.

| 환경 변수 | 설명 |
| - | - |
| `ANTHROPIC_DEFAULT_FABLE_MODEL` | `fable`에 사용할 모델이며, 서드파티 제공업체에서 [자동 모델 폴백](#automatic-model-fallback)을 위해 Claude Code가 Fable 모델로 인식하는 모델 ID입니다 |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | `opus`에 사용할 모델 또는 플랜 모드가 활성화된 경우 `opusplan`에 사용할 모델입니다. |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `sonnet`에 사용할 모델 또는 플랜 모드가 활성화되지 않은 경우 `opusplan`에 사용할 모델입니다. |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `haiku` 또는 [백그라운드 기능](https://code.claude.com/docs/ko/costs.md#background-token-usage)에 사용할 모델입니다 |
| `CLAUDE_CODE_SUBAGENT_MODEL` | 다른 방식으로 모델이 지정되지 않은 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model), [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md#specify-teammates-and-models) 팀원, [워크플로](https://code.claude.com/docs/ko/workflows.md) 에이전트의 기본 모델입니다. `haiku` 같은 별칭 또는 전체 모델 이름을 사용할 수 있습니다. 호출별 모델 또는 정의의 `model` 필드(`inherit` 포함)가 우선합니다. 이를 변경하려면 [`CLAUDE_CODE_SUBAGENT_MODEL_FORCE`](https://code.claude.com/docs/ko/sub-agents#run-every-subagent-on-one-model)를 설정합니다 |

서드파티 제공업체에서 `/model` 선택기의 고정된 모델 행에 무엇이 표시되는지는 [고정된 모델의 표시 및 기능 사용자 지정](#customize-pinned-model-display-and-capabilities)에서 설명합니다.

참고: `ANTHROPIC_SMALL_FAST_MODEL`은 deprecated되었으며
`ANTHROPIC_DEFAULT_HAIKU_MODEL`로 대체되었습니다.

### 서드파티 배포를 위한 모델 고정

[Amazon Bedrock](https://code.claude.com/docs/ko/amazon-bedrock.md), [Google Cloud의 Agent Platform](https://code.claude.com/docs/ko/google-vertex-ai.md), [Microsoft Foundry](https://code.claude.com/docs/ko/microsoft-foundry.md) 또는 [Claude Platform on AWS](https://code.claude.com/docs/ko/claude-platform-on-aws.md)를 통해 Claude Code를 배포할 때는 사용자에게 배포하기 전에 모델 버전을 고정해야 합니다.

고정하지 않으면 Claude Code는 `fable`, `opus`, `sonnet`, `haiku` 같은 모델 별칭을 사용하며, 이 별칭은 각 제공업체별 기본 제공 기본 모델 ID로 확인됩니다. 이 기본값은 최신 Anthropic 릴리스보다 뒤처질 수 있으며, 기본값이 가리키는 모델이 사용자 계정에서 아직 활성화되지 않았을 수 있습니다. 기본값을 사용할 수 없는 경우 Amazon Bedrock 및 Google Cloud의 Agent Platform 사용자에게는 알림이 표시되고, 세션은 기본 모델의 이전 버전으로 폴백하거나, 기본값이 Opus 모델이고 사용 가능한 Opus 버전이 없으면 기본 Sonnet 모델로 폴백합니다. Microsoft Foundry에는 이에 상응하는 시작 시 확인 기능이 없으므로 Microsoft Foundry 사용자에게는 대신 오류가 표시됩니다.

Amazon Bedrock 및 Google Cloud의 Agent Platform에서 `--model`, `ANTHROPIC_MODEL` 또는 `model` 설정 등을 통해 특정 Sonnet 또는 Opus 버전으로 세션을 시작하는 사용자는 해당 버전을 일치하는 별칭에 대한 세션 기본값으로 고정하게 됩니다. 이 경우 시작 시 확인은 해당 버전이 대체하는 기본 제공 기본값을 건너뛰며 폴백 알림을 표시하지 않습니다. v2.1.211 이전에는 세션 모델이 명시적으로 구성된 경우에도 확인이 실행되어 알림이 표시될 수 있었습니다.

> [!WARNING]
>
> 초기 설정 과정에서 모델 환경 변수를 특정 버전 ID로 설정합니다. 고정하면 사용자가 새 모델로 전환되는 시점을 제어할 수 있습니다.

제공업체에 맞는 버전별 모델 ID와 함께 다음 환경 변수를 사용합니다.

| 제공업체 | 예시 |
| :- | :- |
| Amazon Bedrock | `export ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-8'` |
| Google Cloud's Agent Platform | `export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8'` |
| Microsoft Foundry | `export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8'` |

`ANTHROPIC_DEFAULT_FABLE_MODEL`, `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`에도 같은 패턴을 적용합니다. 모든 제공업체의 현재 및 레거시 모델 ID는 [모델 개요](https://platform.claude.com/docs/en/about-claude/models/overview)를 참조하십시오. 사용자를 새 모델 버전으로 업그레이드하려면 이러한 환경 변수를 업데이트하고 다시 배포합니다.

Opus 4.8 또는 Sonnet 5처럼 기본적으로 1M 윈도우를 지원하는 고정 모델은 Claude Code가 고정된 ID를 해당 모델과 일치시킬 수 있는 경우 접미사 없이 [1M 컨텍스트 윈도우](#extended-context)로 실행됩니다. `us.anthropic.claude-opus-4-8`이 `claude-opus-4-8`을 포함하는 것처럼 ID에 모델의 Anthropic API ID가 포함되어 있거나, [`modelOverrides`](#override-model-ids-per-version) 항목이 모델을 해당 ID에 매핑하는 경우 ID가 일치합니다. Claude Code가 모델과 일치시킬 수 없는 고정 ID에서는 ID에 `[1m]` 접미사가 없는 한 세션이 기본적으로 200K 윈도우로 실행됩니다.

Opus 4.6 또는 Sonnet 4.6처럼 `[1m]` 변형을 통해 1M에 도달하는 모델의 경우, `ANTHROPIC_DEFAULT_OPUS_MODEL` 또는 `ANTHROPIC_DEFAULT_SONNET_MODEL`의 모델 ID에 `[1m]`을 추가하여 확장 컨텍스트를 활성화합니다.

```bash theme={null}
export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-6[1m]'
```

`[1m]` 접미사를 사용하면 [`opusplan`](#opusplan-model-setting)의 플랜 모드 Opus 단계와 `model` frontmatter에서 해당 별칭을 지정하는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)를 포함하여 고정된 별칭의 모든 사용에 1M 컨텍스트 윈도우가 적용됩니다.

* Claude Code는 모델 ID를 제공업체로 보내기 전에 접미사를 제거합니다.
* 기반 모델이 [1M 컨텍스트를 지원](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)하는 경우에만 `[1m]`을 추가합니다.
* 접미사는 모델별이 아니라 변수별로 읽힙니다. Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry에서 한 변수에 `[1m]`이 없는 Opus 4.6 또는 Sonnet 4.6 ID를 지정하면, 다른 변수에서 동일한 모델을 접미사와 함께 설정하더라도 200K 컨텍스트를 사용합니다.

`ANTHROPIC_DEFAULT_*_MODEL` 변수를 설정하면 `/model` 선택기는 1M 컨텍스트 행을 포함한 해당 제품군의 기본 제공 행 대신 해당 모델에 대한 하나의 행을 표시합니다. 해당 변수에 접미사를 추가하지 않고 1M 윈도우를 사용하려면 사용자가 `/model opus[1m]`을 실행하면 되며, Claude Code는 변수가 지정한 모델에 접미사를 적용합니다. `/model sonnet[1m]`도 같은 방식으로 작동합니다.

> [!NOTE]
>
> [MDM 또는 관리형 설정 파일](https://code.claude.com/docs/ko/managed-settings.md#delivery-mechanisms)을 통해 전달된 `availableModels` 허용 목록은 서드파티 제공업체를 사용할 때도 계속 적용됩니다. [서버 관리형 설정은 해당 환경에 전달되지 않습니다](https://code.claude.com/docs/ko/server-managed-settings.md#platform-availability).
>
> 필터링은 `opus` 같은 모델 별칭, `claude-opus-4-8` 같은 버전 접두사 또는 제공업체 형식의 전체 모델 ID와 일치시킵니다. `us.anthropic.` 같은 제공업체별 접두사는 제거되지 않으므로, 특정 모델을 허용하려면 [`modelOverrides`](#override-model-ids-per-version)를 통해 매핑하거나 해당 모델의 제공업체 형식 전체 ID를 나열합니다.
>
> * **Google Cloud의 Agent Platform**: Claude Code가 요청하는 ID에 `claude-sonnet-4-5@20250929`처럼 `@` 날짜가 포함된 경우 허용 목록 항목에 날짜를 포함합니다. `claude-sonnet-4-5`만으로는 어느 [`availableModelsMatch`](https://code.claude.com/docs/ko/settings-reference#availablemodelsmatch) 설정에서도 해당 ID와 일치하지 않습니다.
> * **고정된 모델**: 해당 모델의 `ANTHROPIC_DEFAULT_*_MODEL` 변수에 설정한 값을 나열합니다
>
> `[1m]` 접미사는 일치 여부를 확인하기 전에 허용 목록 항목과 요청된 모델 양쪽에서 모두 제거됩니다.

### 고정된 모델의 표시 및 기능 사용자 지정

서드파티 제공업체에서 모델을 고정하면, `/model` 선택기의 해당 행에는 기본적으로 Claude Code가 고정된 ID를 인식하는 경우 모델 이름이, 그렇지 않은 경우 원시 ID가 표시됩니다.

* **인식됨**: Anthropic API ID 또는 제공업체나 게이트웨이 형식의 ID처럼 Claude Code가 알고 있는 모델의 정확한 ID이며, `[1m]` 접미사 유무는 관계없습니다. `us.anthropic.claude-sonnet-4-5-20250929-v1:0`을 고정하면 행에 `Sonnet 4.5`가 표시됩니다.
* **인식되지 않음**: 애플리케이션 추론 프로필 ARN이나 Claude Code가 알지 못하는 모델 버전 등 그 밖의 모든 ID이며, [`modelOverrides`](#override-model-ids-per-version) 항목이 모델을 해당 ID에 매핑하는 경우는 제외됩니다. Microsoft Foundry에서는 배포 이름이 사용자 정의이므로 Claude Code는 매핑 여부와 관계없이 고정된 ID를 인식하지 않으며, 행에는 기본적으로 배포 이름이 표시됩니다.

행에 모델 이름이 표시되는 경우 기본 설명에 고정된 ID가 포함되므로 어떤 ID가 고정되어 있는지 여전히 확인할 수 있습니다.

Claude Code가 고정된 모델이 지원하는 기능을 인식하지 못할 수도 있습니다. 각 고정 모델에 대해 보조 환경 변수를 사용하여 표시 이름과 설명을 직접 설정하고 기능을 선언할 수 있습니다.

이러한 변수는 Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 같은 서드파티 제공업체에서 적용됩니다. `_NAME` 및 `_DESCRIPTION` 변수는 `ANTHROPIC_BASE_URL`이 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 가리키는 경우에도 적용됩니다. `api.anthropic.com`에 직접 연결하는 경우에는 효과가 없습니다.

| 환경 변수 | 설명 |
| - | - |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_NAME` | `/model` 선택기에서 고정된 Opus 모델의 표시 이름입니다. 설정하지 않으면 Claude Code가 고정된 ID를 인식하는 경우 모델 이름을, 그렇지 않은 경우 고정된 ID를 행에 표시합니다 |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION` | `/model` 선택기에서 고정된 Opus 모델의 표시 설명입니다. 설정하지 않으면 행에 `Custom Opus model`로 시작하는 기본 설명이 표시됩니다 |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES` | 고정된 Opus 모델이 지원하는 기능의 쉼표로 구분된 목록입니다 |

동일한 `_NAME`, `_DESCRIPTION`, `_SUPPORTED_CAPABILITIES` 접미사를 `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`, `ANTHROPIC_DEFAULT_FABLE_MODEL`, `ANTHROPIC_CUSTOM_MODEL_OPTION`에도 사용할 수 있습니다.

Claude Code는 모델 ID를 알려진 패턴과 일치시켜 [effort 수준](#adjust-effort-level) 및 [확장 사고](#extended-thinking) 같은 기능을 활성화합니다. Amazon Bedrock ARN이나 사용자 지정 배포 이름 같은 제공업체별 ID는 이러한 패턴과 일치하지 않는 경우가 많아 지원되는 기능이 비활성화된 상태로 남습니다. `_SUPPORTED_CAPABILITIES`를 설정하여 모델이 실제로 지원하는 기능을 Claude Code에 알려 줍니다.

| 기능 값 | 활성화 대상 |
| - | - |
| `effort` | [effort 수준](#adjust-effort-level) 및 `/effort` 명령 |
| `xhigh_effort` | `xhigh` effort 수준 |
| `max_effort` | `max` effort 수준 |
| `thinking` | [확장 사고](#extended-thinking) |
| `adaptive_thinking` | 작업 복잡도에 따라 사고를 동적으로 할당하는 적응형 추론 |
| `interleaved_thinking` | 도구 호출 사이의 사고 |

`_SUPPORTED_CAPABILITIES`가 설정되면 Claude Code는 해당 고정 모델에 대해 나열된 기능을 활성화하고 나열되지 않은 기능을 비활성화합니다. 변수가 설정되지 않은 경우 Claude Code는 모델 ID 기반의 기본 제공 감지로 폴백합니다.

다음 예시는 Opus를 Amazon Bedrock 사용자 지정 모델 ARN에 고정하고, 알기 쉬운 이름을 설정하며, 기능을 선언합니다.

```bash theme={null}
export ANTHROPIC_DEFAULT_OPUS_MODEL='arn:aws:bedrock:us-east-1:123456789012:custom-model/abc'
export ANTHROPIC_DEFAULT_OPUS_MODEL_NAME='Opus via Bedrock'
export ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION='Opus 4.7 routed through a Bedrock custom endpoint'
export ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES='effort,xhigh_effort,max_effort,thinking,adaptive_thinking,interleaved_thinking'
```

### 버전별 모델 ID 재정의

Claude Code를 내장하고 [`CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`](https://code.claude.com/docs/ko/env-vars)를 설정하는 플랫폼에서는 호스트의 모델 구성이 관리형 모델 설정보다 우선하며, 관리형 `availableModels` 허용 목록은 호스트가 자체 허용 목록을 제공하지 않는 한 계속 적용됩니다. 호스트가 재정의하는 키와 변수는 [관리형 설정 우선순위의 예외](https://code.claude.com/docs/ko/settings.md#exceptions-to-managed-settings-precedence)에서 확인할 수 있습니다.

위의 제품군 수준 환경 변수는 제품군 별칭마다 하나의 모델 ID를 구성합니다. 같은 제품군 내의 여러 버전을 서로 다른 제공업체 ID에 매핑해야 하는 경우 대신 `modelOverrides` 설정을 사용합니다.

`modelOverrides`는 개별 Anthropic 모델 ID를 Claude Code가 제공업체 API로 보내는 제공업체별 문자열에 매핑합니다. 사용자가 `/model` 선택기에서 매핑된 모델을 선택하면 Claude Code는 기본 제공 기본값 대신 구성된 값을 사용합니다.

이를 통해 엔터프라이즈 관리자는 거버넌스, 비용 할당 또는 지역별 라우팅을 위해 각 모델 버전을 특정 Amazon Bedrock 추론 프로필 ARN, Google Cloud의 Agent Platform 버전 이름 또는 Microsoft Foundry 배포 이름으로 라우팅할 수 있습니다.

[설정 파일](https://code.claude.com/docs/ko/settings.md#where-settings-live)에서 `modelOverrides`를 설정합니다.

```json theme={null}
{
  "modelOverrides": {
    "claude-opus-4-7": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/opus-prod",
    "claude-opus-4-6": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/opus-46-prod",
    "claude-sonnet-4-6": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/sonnet-prod"
  }
}
```

키는 [모델 개요](https://platform.claude.com/docs/en/about-claude/models/overview)에 나열된 Anthropic 모델 ID여야 합니다. 날짜가 포함된 모델 ID의 경우 해당 문서에 표시된 날짜 접미사를 정확히 포함합니다. 알 수 없는 키는 무시됩니다.

게이트웨이 별칭 같은 ID에 대해 `[claude-code:unrecognized_model]` [진단 줄](https://code.claude.com/docs/ko/errors.md#unrecognized-model-id-on-a-request)이 표시되지 않도록 하려면 해당 ID를 값으로 하는 항목을 추가합니다.

재정의는 `/model` 선택기의 각 항목을 뒷받침하는 기본 제공 모델 ID를 대체합니다. Amazon Bedrock에서는 `modelOverrides` 항목이 Claude Code가 시작 시 자동으로 검색하는 추론 프로필보다 우선합니다. Amazon Bedrock 추론 프로필 ARN이나 Microsoft Foundry 배포 이름처럼 이미 제공업체 고유 형식인 값은 Claude Code가 그대로 제공업체에 전달합니다.

재정의는 `--model`, `ANTHROPIC_MODEL` 환경 변수 또는 `ANTHROPIC_DEFAULT_*_MODEL` 환경 변수를 통해 Anthropic 모델 ID를 직접 전달하는 경우에도 적용됩니다. Amazon Bedrock, Google Cloud의 Agent Platform, [Mantle](https://code.claude.com/docs/ko/amazon-bedrock.md#use-the-mantle-endpoint)에서 `modelOverrides` 항목이 없는 Anthropic 모델 ID는 제공업체가 해당 버전을 지원하는 경우 해당 버전의 `/model` 선택기 행과 동일한 제공업체별 ID로 확인됩니다. Mantle은 일부 버전만 지원합니다. 이 범위에 속하지 않는 Anthropic 모델 ID는 `modelOverrides` 항목이 해당 ID를 다루는 경우를 제외하고, Claude Code가 매핑 없이 원시 ID 그대로 Mantle에 보냅니다. v2.1.200 이전에는 `--model` 및 환경 변수 값이 재정의 맵을 거치지 않고 그대로 제공업체에 전달되었습니다.

`modelOverrides`는 `availableModels`와 함께 작동합니다. 허용 목록은 재정의 값이 아닌 Anthropic 모델 ID를 기준으로 평가되므로, Opus 버전이 ARN에 매핑되어 있어도 `availableModels`의 `"opus"` 같은 항목은 계속 일치합니다. 관리형 설정에서 `enforceAvailableModels`가 설정된 경우, 강제 적용되는 Default는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md#how-claude-code-combines-managed-sources)의 `modelOverrides`를 통해서만 확인됩니다. 추론 프로필 ARN에 고정된 버전처럼 관리자가 지정한 매핑은 강제 적용되는 Default에 반영됩니다. 사용자 또는 프로젝트 설정의 재정의는 이에 영향을 주지 않습니다.

[관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)에서 `availableModels`가 설정된 경우, `--model` 또는 위의 환경 변수를 통해 직접 전달된 Anthropic 모델 ID에는 관리형 설정의 `modelOverrides`만 적용됩니다. Claude Code는 해당 ID에 대해 사용자 또는 프로젝트 설정의 재정의를 무시하며, 관리형 목록에서 제외된 ID는 어떤 설정 소스의 `modelOverrides`를 통해서도 확인하지 않습니다. 이 관리형 소스 제한에는 Claude Code v2.1.200 이상이 필요합니다. 차단된 ID가 처리되는 방식은 [모델 선택 제한](#restrict-model-selection)을 참조하십시오.

### 프롬프트 캐싱 구성

Claude Code는 성능을 최적화하고 비용을 절감하기 위해 자동으로 [프롬프트 캐싱](https://code.claude.com/docs/ko/prompt-caching.md)을 사용합니다. 프롬프트 캐싱은 전역적으로 또는 특정 모델 티어에 대해 비활성화할 수 있습니다.

| 환경 변수 | 설명 |
| - | - |
| `DISABLE_PROMPT_CACHING` | 모든 모델에 대해 프롬프트 캐싱을 비활성화하려면 `1`로 설정합니다. 모델별 설정보다 우선합니다 |
| `DISABLE_PROMPT_CACHING_HAIKU` | [기본 Haiku 모델](https://code.claude.com/docs/ko/prompt-caching.md#disable-prompt-caching)에 대해 프롬프트 캐싱을 비활성화하려면 `1`로 설정합니다 |
| `DISABLE_PROMPT_CACHING_SONNET` | [기본 Sonnet 모델](https://code.claude.com/docs/ko/prompt-caching.md#disable-prompt-caching)에 대해 프롬프트 캐싱을 비활성화하려면 `1`로 설정합니다 |
| `DISABLE_PROMPT_CACHING_OPUS` | [기본 Opus 모델](https://code.claude.com/docs/ko/prompt-caching.md#disable-prompt-caching)에 대해 프롬프트 캐싱을 비활성화하려면 `1`로 설정합니다 |
| `DISABLE_PROMPT_CACHING_FABLE` | Fable 모델에 대해서만 프롬프트 캐싱을 비활성화하려면 `1`로 설정합니다 |

메인 대화와 서브에이전트의 캐시 TTL을 각각 선택하려면 [TTL 직접 선택하기](https://code.claude.com/docs/ko/prompt-caching.md#choose-the-ttl-yourself)를 참조하십시오. 캐시 미스가 발생하는 원인은 [Claude Code가 프롬프트 캐싱을 사용하는 방식](https://code.claude.com/docs/ko/prompt-caching.md)을 참조하십시오.

## 버전 이력

이 표는 각 모델 별칭이 해석하는 모델이 변경된 Claude Code 버전을 나열합니다. 최신 버전부터 표시됩니다.

| 버전 | 변경 사항 |
| :- | :- |
| v2.1.293 | `haiku`는 Anthropic API에서 Haiku 5.5로 해석됩니다 |
| v2.1.284 | `sonnet`은 Anthropic API에서 Sonnet 5.5로 해석됩니다 |
| v2.1.280 | `opus`는 Anthropic API, AWS의 Claude Platform, Amazon Bedrock 및 Google Cloud의 Agent Platform에서 Opus 5.5로 해석됩니다 |
| v2.1.257 | `fable`은 Claude 앱 게이트웨이 세션을 제외하고 Fable 5.1로 해석됩니다 |
| v2.1.219 | `opus`는 Anthropic API, AWS의 Claude Platform, Amazon Bedrock 및 Agent Platform에서 Opus 5로 해석됩니다 |
| v2.1.207 | `opus`는 AWS의 Claude Platform, Amazon Bedrock 및 Agent Platform에서 Opus 4.8로 해석됩니다 |
| v2.1.197 | `sonnet`은 Anthropic API에서 Sonnet 5로 해석됩니다 |
| v2.1.154 | `opus`는 Anthropic API에서 Opus 4.8로 해석됩니다 |
| 이전 버전 | `opus`는 AWS의 Claude Platform에서 Opus 4.7로, Amazon Bedrock 및 Agent Platform에서 Opus 4.6으로 해석됩니다. 모든 제공자에서 `fable`은 Fable 5로, `haiku`는 Haiku 4.5로 해석됩니다 |
