> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 모델 구성

> Claude Code 모델 구성에 대해 알아보기, opusplan과 같은 모델 별칭 포함

<h2 id="available-models">
  사용 가능한 모델
</h2>

Claude Code의 `model` 설정에서 다음 중 하나를 구성할 수 있습니다:

* **모델 별칭**
* **모델 이름**
  * Anthropic API: 전체 **[모델 이름](https://platform.claude.com/docs/ko/about-claude/models/overview)**
  * Bedrock: 추론 프로필 ARN
  * Foundry: 배포 이름
  * Vertex: 버전 이름

<Note>
  `ANTHROPIC_BASE_URL`은 요청이 전송되는 위치를 변경하며, 어느 모델이 응답하는지는 변경하지 않습니다. Claude를 LLM 게이트웨이를 통해 라우팅하려면 [LLM 게이트웨이](/ko/llm-gateway)를 참조하세요.
</Note>

<h3 id="model-aliases">
  모델 별칭
</h3>

모델 별칭은 정확한 버전 번호를 기억할 필요 없이 모델 설정을 선택하는 편리한 방법을 제공합니다:

| 모델 별칭            | 동작                                                                                                                                                                                                                                                              |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`default`**    | 모델 재정의를 제거하고 계정 유형에 따른 권장 모델로 되돌리는 특수 값입니다. 자체로는 모델 별칭이 아닙니다                                                                                                                                                                                                    |
| **`best`**       | 조직에서 액세스할 수 있는 경우 Fable 5를 사용하고, 그렇지 않으면 최신 Opus 모델을 사용합니다                                                                                                                                                                                                      |
| **`fable`**      | 가장 어렵고 오래 실행되는 작업을 위해 Claude Fable 5를 사용합니다                                                                                                                                                                                                                     |
| **`sonnet`**     | 일일 코딩 작업을 위해 최신 Sonnet 모델을 사용합니다                                                                                                                                                                                                                                |
| **`opus`**       | 복잡한 추론 작업을 위해 최신 Opus 모델을 사용합니다                                                                                                                                                                                                                                 |
| **`haiku`**      | 간단한 작업을 위해 빠르고 효율적인 Haiku 모델을 사용합니다                                                                                                                                                                                                                             |
| **`sonnet[1m]`** | 긴 세션을 위해 [100만 토큰 컨텍스트 윈도우](https://platform.claude.com/docs/ko/build-with-claude/context-windows#1m-token-context-window)를 사용하는 Sonnet을 사용합니다. `sonnet`이 이미 기본 1M 윈도우를 가진 Sonnet 5로 확인될 때는 효과가 없습니다. [LLM 게이트웨이](/ko/llm-gateway) 뒤에서는 Sonnet 5의 1M 윈도우를 선택합니다 |
| **`opus[1m]`**   | 긴 세션을 위해 [100만 토큰 컨텍스트 윈도우](https://platform.claude.com/docs/ko/build-with-claude/context-windows#1m-token-context-window)를 사용하는 Opus를 사용합니다                                                                                                                    |
| **`opusplan`**   | Plan Mode 중에 `opus`를 사용한 후 실행을 위해 `sonnet`으로 전환하는 특수 모드입니다                                                                                                                                                                                                      |

Anthropic API에서 `opus`는 Opus 4.8로, `sonnet`은 Sonnet 5로 확인됩니다. [Claude Platform on AWS](/ko/claude-platform-on-aws)에서 `opus`는 Opus 4.7로, `sonnet`은 Sonnet 4.6으로 확인됩니다. Bedrock, Vertex 및 Foundry에서 `opus`는 Opus 4.6으로, `sonnet`은 Sonnet 4.5로 확인됩니다. 더 새로운 모델은 전체 모델 이름을 명시적으로 선택하거나 `ANTHROPIC_DEFAULT_OPUS_MODEL` 또는 `ANTHROPIC_DEFAULT_SONNET_MODEL`을 설정하여 해당 제공자에서 사용할 수 있습니다.

별칭은 제공자에 대한 권장 버전을 가리키며 시간이 지남에 따라 업데이트됩니다. 특정 버전으로 고정하려면 전체 모델 이름(예: `claude-opus-4-8`)을 사용하거나 `ANTHROPIC_DEFAULT_OPUS_MODEL`과 같은 해당 환경 변수를 설정합니다.

<Note>
  Sonnet 5는 Claude Code v2.1.197 이상이 필요합니다. Opus 4.8은 v2.1.154 이상이 필요합니다. `claude update`를 실행하여 업그레이드하세요.
</Note>

<h3 id="work-with-fable-5">
  Fable 5로 작업하기
</h3>

[Claude Fable 5](https://platform.claude.com/docs/ko/about-claude/models/introducing-claude-fable-5-and-claude-mythos-5)는 Claude Code에서 가장 강력한 모델이며, 한 번의 세션보다 큰 작업에 적합합니다. 긴 자율 세션을 유지하고, 행동하기 전에 조사하며, 더 작은 모델보다 더 자주 작업을 검증합니다.

Fable 5는 기본 모델이 아닙니다. `/model fable`로 선택합니다. 안전 분류기가 플래그를 지정하는 요청(대부분 사이버 보안 및 생물학 도메인)은 [자동 모델 폴백](#automatic-model-fallback)을 트리거합니다.

Fable 5를 최대한 활용하려면:

* **결과를 설명하고 단계는 설명하지 마세요**: 원하는 결과를 제공하고 경로를 계획하도록 합니다. 해당 결과가 유지될 때까지 작업을 계속하려면 [목표를 설정](/ko/goal)하세요.
* **모호한 문제를 제공하세요**: 근본 원인 조사, 중단 디버깅 및 아키텍처 결정은 추가 조사 및 검증이 효과를 발휘하는 곳입니다.
* **검증 알림을 건너뛰세요**: 더 적은 프롬프팅으로 자신의 작업을 검증하므로 테스트 또는 확인 알림은 일반적으로 불필요합니다.
* **더 큰 작업을 크기 조정하세요**: 일반적으로 여러 부분으로 나누는 작업을 제공합니다. 긴 세션을 유지하면서 스레드를 잃지 않습니다.

<Note>
  Fable 5는 Claude Code v2.1.170 이상이 필요합니다. 이전 버전은 모델 선택기에 Fable 5를 표시하지 않으며 선택할 수 없습니다. `claude update`를 실행하여 업그레이드하세요. Fable 5는 [제로 데이터 보존](/ko/zero-data-retention) 하에서 사용할 수 없으며, `/model` 선택기는 이를 생략하거나 비활성화된 상태로 표시합니다.
</Note>

<h3 id="setting-your-model">
  모델 설정
</h3>

다음과 같은 여러 방법으로 모델을 구성할 수 있으며, 우선순위 순서대로 나열되어 있습니다:

1. **세션 중**: `/model <alias|name>`을 사용하여 즉시 전환하거나, 인수 없이 `/model`을 실행하여 선택기를 엽니다. 선택기는 대화에 이전 출력이 있을 때 확인을 요청합니다. 다음 응답이 캐시된 컨텍스트 없이 전체 기록을 다시 읽기 때문입니다.
2. **시작 시**: `claude --model <alias|name>`으로 실행합니다.
3. **환경 변수**: `ANTHROPIC_MODEL=<alias|name>`을 설정합니다.
4. **설정**: `model` 필드를 사용하여 설정 파일에서 영구적으로 구성합니다.

v2.1.153부터 `/model`은 사용자 설정에서 `model` 필드를 작성하여 새 세션의 기본값으로 선택 항목을 저장합니다. 선택기에서:

* `Enter`: 모델을 전환하고 기본값으로 저장합니다
* `s`: 이 세션에만 모델을 전환합니다

`/model <name>`을 직접 입력하면 `Enter`처럼 동작합니다. 프로젝트 및 관리되는 설정은 여전히 우선순위를 가지며 다음 실행 시 다시 적용됩니다.

v2.1.144부터 v2.1.152까지는 `/model`이 현재 세션에만 적용되었으며 선택기에서 `d`가 기본값을 저장했습니다.

`--model` 플래그 및 `ANTHROPIC_MODEL` 환경 변수는 이를 사용하여 실행한 세션에만 적용됩니다. 동시에 다른 터미널에서 다른 모델을 실행하려면 `/model`로 전환하는 대신 각각 자신의 `--model` 플래그로 실행합니다.

`claude --resume`, `--continue` 또는 `/resume` 선택기로 시작된 재개된 세션은 현재 `model` 설정에 관계없이 트랜스크립트가 저장되었을 때 사용 중이던 모델을 유지합니다. 해당 모델이 중단된 경우 또는 [`availableModels`](#restrict-model-selection)에 의해 제외된 경우, 세션은 일반 우선순위 순서로 폴백됩니다. 이는 다른 세션의 `/model` 선택이 재개 시 모델을 변경하는 것을 방지합니다.

새 실행 시 `--model` 또는 `ANTHROPIC_MODEL`로 선택한 모델은 여전히 복원된 모델보다 우선순위를 가집니다. {/* min-version: 2.1.195 */}v2.1.195부터 [`ANTHROPIC_DEFAULT_OPUS_MODEL`](#environment-variables) 계열 변수도 마찬가지입니다.

시작 시 활성 모델이 자신의 선택이 아닌 프로젝트 또는 관리되는 설정에서 나온 경우, 시작 헤더는 어느 설정 파일이 이를 설정했는지 표시합니다. `/model`을 실행하여 재정의합니다. 프로젝트 또는 관리되는 설정은 다음 실행 시 다시 적용됩니다.

요청된 모델에 예정된 중단 날짜가 있거나 자동으로 최신 버전으로 재매핑될 때, Claude Code는 요청된 모델의 이름을 지정하는 경고를 표시합니다. 대화형 세션은 이를 시작 알림으로 표시합니다. v2.1.182부터 [비대화형 모드](/ko/headless)에서 기본 텍스트 출력 형식을 사용할 때 동일한 경고가 stderr에 기록됩니다. 확인은 [서브에이전트 프론트매터](/ko/sub-agents)에 설정된 `model`도 포함합니다. stderr 경고는 `--output-format json` 및 `stream-json`에 대해 억제됩니다. [결과 메시지](/ko/headless#get-structured-output)의 `modelUsage` 필드에서 실제 모델을 읽으세요.

사용 예시:

```bash theme={null}
# Opus로 시작
claude --model opus

# 세션 중에 Sonnet으로 전환
/model sonnet
```

설정 파일 예시:

```json theme={null}
{
    "permissions": {
        ...
    },
    "model": "opus"
}
```

<h2 id="restrict-model-selection">
  모델 선택 제한
</h2>

엔터프라이즈 관리자는 [관리 또는 정책 설정](/ko/settings#settings-files)에서 `availableModels`을 사용하여 사용자가 선택할 수 있는 모델을 제한할 수 있습니다. 항목은 `sonnet`과 같은 모델 패밀리, `claude-sonnet-4-5`와 같은 버전 접두사 또는 `claude-sonnet-4-5-20250929`와 같은 전체 모델 ID와 일치합니다.

`availableModels`이 설정되면 허용 목록은 사용자가 모델을 지정할 수 있는 모든 위치에 적용됩니다:

* **메인 세션 모델**: `/model`, `--model` 플래그, `ANTHROPIC_MODEL` 환경 변수, `model` 설정 및 [세션을 재개할 때](#setting-your-model) 복원된 모델
* **별칭 해석**: {/* min-version: 2.1.176 */}`ANTHROPIC_DEFAULT_OPUS_MODEL`, `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL` 및 `ANTHROPIC_DEFAULT_FABLE_MODEL` 환경 변수는 허용된 별칭을 목록 외부의 모델로 리디렉션할 수 없습니다
* **빠른 모드**: {/* min-version: 2.1.176 */}`/fast`는 목록 외부의 Opus 모델로 암시적으로 전환될 때 토글을 거부하며, "is not in your organization's allowed models" 메시지를 표시합니다
* **서브에이전트 모델**: [서브에이전트](/ko/sub-agents#choose-a-model) frontmatter의 `model` 필드, Agent 도구의 `model` 매개변수, `/agents`의 모델 선택기 및 `CLAUDE_CODE_SUBAGENT_MODEL`
* **스킬 및 명령 모델**: [스킬 및 명령](/ko/skills)의 `model` frontmatter
* **어드바이저 모델**: 구성된 [`advisorModel`](/ko/advisor) 설정 및 `--advisor` 플래그
* **백그라운드 에이전트 모델**: [디스패치 선택기](/ko/agent-view)에서 선택된 모델

`/model`로 차단된 모델로 전환하면 오류로 거부되고, 차단된 `--model` 플래그, `ANTHROPIC_MODEL` 또는 `model` 설정 값은 시작 시 요청된 모델과 대체된 모델을 모두 이름 지은 경고와 함께 대체되며 세션은 기본 모델에서 시작됩니다. 차단된 서브에이전트, 스킬 또는 명령 재정의는 요청을 실패하지 않고 상속되거나 기본 모델로 폴백됩니다. 차단된 `advisorModel` 설정은 세션에 대해 어드바이저를 비활성화하고, 차단된 `--advisor` 플래그 값은 시작 시 오류로 종료됩니다. 제외된 모델은 `/model` 선택기에서 숨겨집니다.

자동 모델 변경은 동일한 방식으로 확인됩니다: [폴백 모델 체인](#fallback-model-chains)의 허용 목록 외부 요소는 삭제되고, [`opusplan`](#opusplan-model-setting)과 같은 계획 모드 업그레이드는 제외된 모델로 건너뛰어 계획이 세션의 모델에서 계속되며, 대상이 제외된 [자동 모델 폴백](#automatic-model-fallback)은 실행되지 않으므로 플래그된 요청은 거부로 끝납니다. [빠른 모드](/ko/fast-mode)를 활성화하면 세션이 실행될 모델이 허용 목록 외부에 있을 때 거부됩니다.

```json theme={null}
{
  "availableModels": ["sonnet", "haiku"]
}
```

<h3 id="surface-coverage">
  표면 범위
</h3>

모든 표면은 수신하는 허용 목록을 적용합니다. 각 표면에 도달하는 전달 메커니즘은 다릅니다:

| 전달 메커니즘                                        | CLI 및 IDE | 데스크톱 로컬 세션 | 웹, 모바일 및 클라우드 세션 | Agent SDK 및 비대화형 | Cowork       |
| :--------------------------------------------- | :-------- | :--------- | :--------------- | :--------------- | :----------- |
| 관리 콘솔의 [서버 관리 설정](/ko/server-managed-settings) | 적용됨       | 적용됨        | 적용됨              | 적용됨              | 전달되지 않음      |
| [MDM 또는 관리 설정 파일](/ko/settings#settings-files) | 적용됨       | 적용됨        | 전달되지 않음          | 적용됨              | 배포된 위치에서 적용됨 |

* 클라우드 세션은 [Claude Code on the web](/ko/claude-code-on-the-web) 또는 데스크톱 앱에서 Anthropic 관리 VM에서 실행됩니다: 장치에 배포된 설정은 이에 도달하지 않으므로 서버 관리 설정을 통해 허용 목록을 전달합니다. 클라우드 세션의 중간 세션 모델 전환은 요청된 모델이 허용 목록에 의해 제외될 때 거부됩니다. 세션 생성 시 서버 측 거부는 `availableModels` 설정 키가 아닌 [조직 모델 제한](#organization-model-restrictions)에 적용됩니다.
* Cowork는 Claude 데스크톱 앱의 에이전트 작업 탭이며 설계상 서버 관리 설정을 수신하지 않습니다. 관리 설정 파일은 세션이 실행되는 위치에 있을 때 Cowork 세션에 적용됩니다. 원격 Cowork 세션은 Anthropic 관리 VM에서 실행되며, 여기서 장치 배포 파일이 없습니다.
* [Bedrock, Vertex AI, Foundry 및 Claude Platform on AWS](/ko/claude-platform-on-aws)와 같은 [타사 제공자](/ko/server-managed-settings#platform-availability)의 세션은 서버 관리 설정을 수신하지 않으므로 MDM 또는 관리 설정 파일을 통해 허용 목록을 전달합니다.
* 서버 관리 전달은 또한 세션이 조직 로그인 또는 직접 구성된 API 키로 인증해야 합니다. [`apiKeyHelper`](/ko/settings#available-settings) 스크립트를 통해서만 키를 생성하는 플릿은 MDM 또는 관리 설정 파일을 통해 허용 목록을 전달해야 합니다.
* 데스크톱 Code 탭은 또한 [SSH 세션](/ko/desktop#ssh-sessions)을 호스팅하며, 이는 실행되는 원격 호스트에서 관리 설정 파일을 읽습니다. [데스크톱 관리 설정](/ko/desktop#managed-settings)을 참조하세요.
* claude.ai 및 데스크톱 앱의 모델 선택기는 조직의 허용 목록에 의해 제외된 모델을 숨기거나 회색으로 표시합니다. 선택기 상태는 사용자를 위한 편의입니다. 적용은 세션에서 발생합니다.

<h3 id="default-model-behavior">
  기본 모델 동작
</h3>

모델 선택기의 Default 옵션은 [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model)도 설정되지 않는 한 `availableModels`의 영향을 받지 않습니다. 자체적으로 `availableModels`은 Default를 사용 가능하게 두고, 시스템의 [런타임 기본값](#default-model-setting)으로 확인됩니다. 해당 기본값이 제한하려는 모델인 경우 `enforceAvailableModels`도 설정합니다.

빈 `availableModels` 배열은 Default 모델 강제를 활성화하지 않습니다: `availableModels: []`인 경우 명명된 모델 선택은 차단되지만 `enforceAvailableModels`에 관계없이 계정 유형에 대한 Default 모델은 사용 가능합니다.

<h3 id="enforce-the-allowlist-for-the-default-model">
  Default 모델에 대해 허용 목록 적용
</h3>

관리 설정에서 비어 있지 않은 `availableModels`과 함께 `enforceAvailableModels: true`를 설정하여 허용 목록을 Default 옵션으로 확장합니다. 이는 Claude Code v2.1.175 이상이 필요합니다.

```json theme={null}
{
  "availableModels": ["sonnet", "haiku"],
  "enforceAvailableModels": true
}
```

사용자의 계정 유형에 대한 기본 모델이 허용 목록에 없으면 Default 옵션은 대신 허용되고 사용 가능한 모델을 이름 지은 첫 번째 `availableModels` 항목으로 확인되며, `/model` 선택기의 Default 행은 해당 모델을 표시합니다. 이는 기본값에 도달하는 모든 위치에 적용됩니다: 세션 시작, `/model`에서 Default 선택, [폴백 모델 체인](#fallback-model-chains)의 `"default"` 키워드 및 제외된 선택이 삭제될 때 사용되는 폴백입니다.

`enforceAvailableModels`은 `availableModels`이 설정되지 않거나 비어 있을 때 효과가 없습니다: `availableModels: []`인 경우 계정 유형에 대한 Default 모델은 사용 가능하므로 설정이 사용자를 모든 모델에서 잠글 수 없습니다. `availableModels`이 비어 있지 않지만 허용되고 사용 가능한 모델을 확인하는 항목이 없으면 강제가 저하되고 Default는 계정 유형 기본값으로 폴스루되며, `--debug` 아래에서만 표시되는 경고가 있습니다. 이를 피하려면 목록에 최소한 하나의 보장된 사용 가능 항목을 유지합니다.

[최고 우선순위 관리 소스](/ko/settings#settings-precedence)에 두 키를 배포합니다: 관리자 배포 관리 소스는 병합되지 않으므로 관리 설정 파일에 배치된 쌍은 관리 콘솔이 설정을 전달할 때 무시됩니다.

<h3 id="control-the-model-users-run-on">
  사용자가 실행하는 모델 제어
</h3>

`model` 설정은 초기 선택이지 강제가 아닙니다. 세션이 시작될 때 활성화되는 모델을 설정하지만 사용자는 여전히 `/model`을 열고 Default를 선택할 수 있으며, 이는 [`enforceAvailableModels`](#enforce-the-allowlist-for-the-default-model)이 이를 리디렉션하지 않는 한 시스템의 [런타임 기본값](#default-model-setting)으로 확인됩니다.

모델 경험을 완전히 제어하려면 이러한 설정을 함께 사용합니다:

* **`availableModels`**: 사용자가 전환할 수 있는 명명된 모델을 제한합니다
* **`enforceAvailableModels`**: `availableModels` 허용 목록을 Default 옵션으로 확장하므로 Default는 목록 외부의 모델로 확인될 수 없습니다
* **`model`**: 세션이 시작될 때 초기 모델 선택을 설정합니다
* **`ANTHROPIC_DEFAULT_SONNET_MODEL`** / **`ANTHROPIC_DEFAULT_OPUS_MODEL`** / **`ANTHROPIC_DEFAULT_HAIKU_MODEL`** / **`ANTHROPIC_DEFAULT_FABLE_MODEL`**: Default 옵션과 `sonnet`, `opus`, `haiku`, `fable` 별칭이 확인되는 대상을 제어합니다

이 예시는 사용자를 Sonnet 4.5에서 시작하고, 선택기를 Sonnet과 Haiku로 제한하며, Default가 계층 기본값이 아닌 허용 목록의 모델로 확인되도록 합니다:

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

`enforceAvailableModels` 또는 `env` 블록이 없으면 선택기에서 Default를 선택하는 사용자는 자신의 계층에 대한 최신 릴리스를 받게 되어 `model` 및 `availableModels`의 버전 고정을 우회합니다. 두 설정은 서로 다른 범위를 다룹니다: `enforceAvailableModels`는 Default가 허용 목록을 따르도록 하고, `env` 블록은 `sonnet`과 같은 허용된 별칭이 확인되는 특정 버전을 고정합니다. 모델 패밀리 제한이 충분할 때는 `enforceAvailableModels`만 사용하고, 특정 버전을 고정해야 할 때는 `env` 블록을 추가합니다.

<h3 id="merge-behavior">
  병합 동작
</h3>

[최고 우선순위 관리 설정 소스](/ko/server-managed-settings#settings-precedence)가 `availableModels`을 정의하면 해당 목록만 적용됩니다: 사용자, 프로젝트 또는 로컬 설정의 항목은 이를 확대할 수 없으며, 관리자 배포 관리 소스는 서로 병합되지 않으므로 관리 설정 파일에 배포된 목록은 서버 관리 설정이 키를 전달할 때 무시됩니다. 그렇지 않으면 사용자, 프로젝트 및 로컬 설정의 목록은 다른 배열 설정처럼 [연결되고 중복이 제거됩니다](/ko/settings#settings-precedence). {/* min-version: 2.1.175 */}Claude Code v2.1.175부터 관리 목록은 낮은 우선순위 항목을 대체합니다. 이전 버전은 이들을 병합합니다.

유효한 목록 내에서 버전 접두사 또는 전체 모델 ID인지 여부에 관계없이 패밀리의 특정 모델을 이름 지은 항목은 해당 패밀리의 와일드카드 항목을 비활성화합니다: `["sonnet", "claude-sonnet-4-5"]`는 모든 Sonnet 모델이 아닌 Sonnet 4.5 버전만 허용합니다.

<h3 id="mantle-model-ids">
  Mantle 모델 ID
</h3>

[Bedrock Mantle 엔드포인트](/ko/amazon-bedrock#use-the-mantle-endpoint)가 활성화되면 `anthropic.`으로 시작하는 `availableModels`의 항목이 `/model` 선택기에 사용자 정의 옵션으로 추가되고 Mantle 엔드포인트로 라우팅됩니다. 이는 [타사 배포를 위한 모델 고정](#pin-models-for-third-party-deployments)에 설명된 별칭 일치에 대한 예외입니다. 설정은 여전히 선택기를 나열된 항목으로 제한하며, Mantle ID는 패밀리 이름을 포함하므로 특정 항목으로 계산되고 해당 패밀리의 와일드카드를 비활성화합니다: 모든 Mantle ID와 함께 유지하려는 버전 접두사 또는 전체 ID를 나열합니다. [병합 동작](#merge-behavior)을 참조하세요.

<h3 id="organization-model-restrictions">
  조직 모델 제한
</h3>

조직 관리자는 Claude 콘솔에서 개별 모델을 비활성화하여 구성원이 실행할 수 있는 모델을 제한합니다. 구성원이 Anthropic API를 통해 인증하고 설정 파일을 배포하지 않고 조직 전체 스위치를 원할 때 `availableModels` 대신 이 콘솔 토글을 사용합니다. 이 제한은 Claude Code가 인증할 때 계정의 자격과 함께 전달되며, 설정의 `availableModels` 목록과 별개이며, 서버는 세션이 생성될 때 동일한 제한을 독립적으로 적용합니다. Claude Code v2.1.187 이상이 필요합니다.

제한된 모델은 `/model` 선택기에서 숨겨집니다. `--model`, `ANTHROPIC_MODEL` 환경 변수 또는 `model` 설정으로 이름으로 선택하면 `Model "<name>" is restricted by your organization's settings. Using <model> instead.` 알림이 표시되고 세션은 허용된 모델에서 시작됩니다. 제한된 모델에 대해 `/model <name>`을 입력하면 `Model '<name>' is restricted by your organization's settings. Run /model to choose a different model.`로 거부되고 세션은 현재 모델을 유지합니다.

두 제한은 함께 적용됩니다: 모델은 `availableModels`에 의해 허용되고 조직에 의해 제한되지 않을 때만 선택 가능합니다. 조직 제한은 Anthropic API 및 [LLM 게이트웨이](/ko/llm-gateway) 배포의 세션에 전달됩니다. Bedrock, Vertex AI, Foundry 및 Claude Platform on AWS의 세션은 이를 수신하지 않으므로 대신 해당 제공자에서 `availableModels`을 사용합니다.

<h2 id="special-model-behavior">
  특수 모델 동작
</h2>

<h3 id="default-model-setting">
  `default` 모델 설정
</h3>

`default`의 동작은 계정 유형에 따라 다릅니다:

* **Max, Team Premium, Enterprise 종량제 및 Anthropic API**: Opus 4.8로 기본값 설정
* **AWS의 Claude Platform**: Opus 4.7로 기본값 설정
* **Pro, Team Standard 및 Enterprise 구독 시트**: Sonnet 5로 기본값 설정
* **Bedrock, Vertex 및 Foundry**: Sonnet 4.5로 기본값 설정

Enterprise 종량제는 구독 시트가 아닌 사용량으로 청구되는 Enterprise 조직을 의미합니다.

관리 설정이 [Default 모델에 대한 허용 목록을 적용](#enforce-the-allowlist-for-the-default-model)하고 계정 유형 기본값이 `availableModels`에 없을 때 `default`는 위의 계정 유형 기본값 대신 적용된 Default로 확인됩니다.

Fable 5는 어떤 계정 유형에서도 기본 모델이 아닙니다. 세션은 `/model fable`, `model` 설정 또는 Fable 5를 사용할 수 있는 `best` 별칭으로 선택한 후에만 Fable 5를 사용합니다. `/model`로 선택하면 사용자 설정에서 선택된 모델로 저장되므로 모델을 변경할 때까지 이후 세션이 Fable 5에서 시작됩니다.

<h3 id="opusplan-model-setting">
  `opusplan` 모델 설정
</h3>

`opusplan` 모델 별칭은 자동화된 하이브리드 접근 방식을 제공합니다:

* **Plan Mode에서** - 복잡한 추론 및 아키텍처 결정을 위해 `opus` 사용
* **실행 모드에서** - 코드 생성 및 구현을 위해 자동으로 `sonnet`으로 전환

이는 계획을 위한 Opus의 우수한 추론과 실행을 위한 Sonnet의 효율성이라는 두 가지 장점을 모두 제공합니다.

Plan Mode Opus 단계는 `opus` 모델 설정과 동일한 컨텍스트 윈도우를 사용합니다. Opus가 [자동으로 1M 컨텍스트로 업그레이드](#extended-context)되는 구독 계층에서 `opusplan`은 Plan Mode에서도 업그레이드를 받습니다. 자동 업그레이드 계층이 아닌 경우 두 단계 모두에 1M 컨텍스트를 강제하려면 모델을 `opusplan[1m]`으로 설정합니다.

[`availableModels`](#restrict-model-selection)이 Opus를 제외할 때 `opusplan`은 전환하는 대신 Plan Mode에서 Sonnet에 유지됩니다. 마찬가지로 Sonnet이 제외될 때 일반적으로 Plan Mode에서 Sonnet으로 업그레이드되는 Haiku 세션도 Haiku에 유지됩니다.

Claude가 Plan 경계에서 전환하는 대신 작업 중간에 두 번째 모델을 참고할 시기를 결정하는 하이브리드 접근 방식은 [advisor tool](/ko/advisor)을 참조하세요.

<h3 id="fallback-model-chains">
  폴백 모델 체인
</h3>

주 모델이 과부하 상태이거나 사용할 수 없거나 다른 재시도 불가능한 서버 오류를 반환할 때 Claude Code는 요청이 실패하는 대신 폴백 모델로 전환할 수 있습니다. 인증, 청구, 속도 제한, 요청 크기 및 전송 오류는 절대 전환을 트리거하지 않습니다. 이들은 정상적인 재시도 및 오류 처리를 따릅니다.

하나 이상의 폴백 모델을 구성하고 Claude Code는 순서대로 시도하며 전환할 때 알림을 표시합니다. 전환은 현재 턴에만 지속되므로 다음 메시지는 주 모델을 먼저 다시 시도합니다. 체인은 중복 제거 후 3개 모델로 제한되며 추가 항목은 무시됩니다.

`--fallback-model` 플래그로 한 세션에 대한 체인을 설정합니다. 이 플래그는 쉼표로 구분된 목록을 허용합니다:

```bash theme={null}
claude --fallback-model sonnet,haiku
```

세션 전체에 체인을 유지하려면 [settings](/ko/settings)에서 `fallbackModel`을 배열로 설정합니다:

```json theme={null}
{
  "fallbackModel": ["claude-sonnet-5", "claude-haiku-4-5"]
}
```

`--fallback-model` 플래그는 `fallbackModel` 설정보다 우선합니다. 각 요소는 모델 이름 또는 별칭을 허용하며 `"default"`는 기본 모델로 확장됩니다.

두 가지 경우로 인해 요소가 건너뛰어집니다:

* **사용할 수 없는 모델**: 설정에 고정된 폐기된 모델과 같이 도달할 수 없는 모델은 건너뛰어지고 Claude Code는 다음 요소로 계속됩니다.
* **허용 목록 외**: [`availableModels`](#restrict-model-selection)에서 허용되지 않는 요소는 체인을 읽을 때 삭제되고 시도되지 않습니다.

<h3 id="automatic-model-fallback">
  자동 모델 폴백
</h3>

이 섹션은 Fable 5의 콘텐츠 기반 폴백을 다룹니다. 모델이 과부하 상태이거나 사용할 수 없을 때의 가용성 기반 폴백은 [폴백 모델 체인](#fallback-model-chains)을 참조하세요.

Fable 5는 사이버 보안 및 생물학 콘텐츠에 대한 안전 분류기로 실행됩니다. 분류기가 요청에 플래그를 지정하면 Claude Code는 해당 요청을 기본 Opus 모델에서 다시 실행하고 트랜스크립트에 알림을 표시합니다: Anthropic API 및 [LLM gateway](/ko/llm-gateway) 배포의 경우 Opus 4.8, 또는 [Claude Platform on AWS](/ko/claude-platform-on-aws)의 경우 Opus 4.7.

세션은 그 Opus 모델에서 계속됩니다. Fable 5로 돌아가려면 `/model fable`을 실행합니다.

폴백 대상은 [`availableModels`](#restrict-model-selection)에 대해 확인됩니다. 차단되면 폴백이 발생하지 않습니다. 거부는 정상 오류로 표시되고 세션의 모델은 변경되지 않습니다.

<h4 id="check-what-triggered-fallback">
  폴백을 트리거한 것 확인
</h4>

폴백은 세션의 첫 번째 요청에서 트리거될 수 있습니다. 이는 첫 번째 요청이 CLAUDE.md 콘텐츠 및 git 상태와 같은 워크스페이스 컨텍스트를 전달하기 때문입니다. 보안 또는 생물학 자료를 포함하는 저장소는 해당 컨텍스트만으로도 분류기를 트리거할 수 있습니다.

사용자 정의가 트리거인지 확인하려면 `claude --safe-mode`로 세션을 시작합니다. 이는 CLAUDE.md, skills, MCP servers 및 hooks와 같은 사용자 정의를 비활성화합니다. Git 상태 및 디렉토리 이름은 사용자 정의가 아니며 여전히 포함됩니다.

<h4 id="ask-before-switching">
  전환하기 전에 묻기
</h4>

요청에 플래그가 지정될 때마다 자동으로 전환하는 대신 어떤 일이 발생할지 결정하려면 `/config`를 실행하고 "메시지에 플래그가 지정되면 모델 전환"을 끕니다. 플래그가 지정된 요청은 두 가지 옵션으로 세션을 일시 중지합니다: Opus 모델로 전환하거나 프롬프트를 편집하고 Fable 5에서 다시 시도합니다.

일부 경우는 다르게 동작합니다:

* 두 모델이 동일한 요청에 플래그를 지정하면 프롬프트를 편집하고 다시 시도하거나 새 세션을 시작할 수 있습니다.
* 모바일 [Claude Code on the web](/ko/claude-code-on-the-web) 세션에서는 편집 및 재시도가 지원되지 않습니다. 모델을 전환하거나 데스크톱 브라우저 또는 데스크톱 앱에서 세션을 계속합니다.
* [비대화형 모드](/ko/cli-reference#cli-flags) 및 프롬프트를 표시할 수 없는 SDK 통합에서 플래그가 지정된 요청은 거부로 턴을 종료합니다.
* 폴백 대상이 [`availableModels`](#restrict-model-selection)에 의해 차단되면 프롬프트가 표시되지 않습니다. 플래그가 지정된 요청은 거부로 종료되며, 대상이 차단될 때 자동 폴백과 동일합니다.

<h4 id="enable-fallback-on-bedrock-vertex-ai-and-foundry">
  Bedrock, Vertex AI 및 Foundry에서 폴백 활성화
</h4>

[Amazon Bedrock](/ko/amazon-bedrock), [Google Vertex AI](/ko/google-vertex-ai) 및 [Microsoft Foundry](/ko/microsoft-foundry)에서 모델 ID는 공급자별로 다르므로 자동 폴백은 Claude Code가 관련된 두 모델을 식별할 수 있을 때만 작동합니다:

* Claude Code는 현재 모델을 Fable 5로 인식해야 합니다: 모델 ID에 `claude-fable-5`가 포함되거나 `ANTHROPIC_DEFAULT_FABLE_MODEL`의 값과 일치하거나 [`modelOverrides`](#override-model-ids-per-version)로 매핑됩니다.
* 폴백 대상은 Opus 모델로 확인되어야 합니다: `ANTHROPIC_DEFAULT_OPUS_MODEL`의 값(설정된 경우) 또는 공급자의 모델 목록의 Opus 4.8 항목입니다.

모델을 식별할 수 없으면 Claude Code는 자동으로 전환하지 않습니다. 플래그가 지정된 요청은 거부 메시지로 종료되며 [`/model`](#setting-your-model)로 모델을 전환하고 다시 시도할 수 있습니다. 이러한 공급자에서 자동 폴백을 활성화하려면 `ANTHROPIC_DEFAULT_FABLE_MODEL`을 Fable 5 모델 ID로 설정하고 `ANTHROPIC_DEFAULT_OPUS_MODEL`을 Opus 4.8 모델 ID로 설정합니다.

<h4 id="security-research-and-biology-workloads">
  보안 연구 및 생물학 워크로드
</h4>

공격적인 보안 또는 생물학의 워크로드(침투 테스트, Capture the Flag(CTF) 연습 및 생물학 인접 코드베이스 포함)는 자주 폴백을 트리거하며 종종 첫 번째 요청에서 트리거됩니다. 실질적인 생물학 작업의 경우 거의 모든 요청이 재라우팅될 것으로 예상합니다.

이는 이러한 도메인에 대한 예상 라우팅이며 계정 플래그가 아닙니다. 조직이 이 작업을 위해 Fable 클래스 기능이 필요한 경우 신뢰할 수 있는 액세스 프로그램에 대해 Anthropic 계정 팀에 문의하세요.

<h3 id="adjust-effort-level">
  노력 수준 조정
</h3>

[노력 수준](https://platform.claude.com/docs/ko/build-with-claude/effort)은 적응형 추론을 제어하며, 작업 복잡도에 따라 모델이 각 단계에서 생각할지 여부와 얼마나 생각할지를 결정하도록 합니다. 낮은 노력은 간단한 작업의 경우 더 빠르고 저렴하며, 높은 노력은 복잡한 문제에 대해 더 깊은 추론을 제공합니다.

사용 가능한 노력 수준은 모델에 따라 다릅니다. 여기에 나열되지 않은 모델은 노력을 지원하지 않습니다:

| 모델                            | 수준                                      |
| :---------------------------- | :-------------------------------------- |
| Fable 5                       | `low`, `medium`, `high`, `xhigh`, `max` |
| Sonnet 5, Opus 4.8 및 Opus 4.7 | `low`, `medium`, `high`, `xhigh`, `max` |
| Opus 4.6 및 Sonnet 4.6         | `low`, `medium`, `high`, `max`          |

활성 모델이 지원하지 않는 수준을 설정하면 Claude Code는 설정한 수준 이하의 가장 높은 지원 수준으로 폴백합니다. 예를 들어 `xhigh`는 Opus 4.6에서 `high`로 실행됩니다.

기본 노력은 Fable 5, Sonnet 5, Opus 4.8, Opus 4.6 및 Sonnet 4.6에서 `high`이고 Opus 4.7에서 `xhigh`입니다.

Fable 5, Opus 4.8 또는 Opus 4.7을 처음 실행할 때 Claude Code는 이전에 다른 모델에 대해 다른 수준을 설정했더라도 해당 모델의 기본 노력을 적용합니다: Fable 5 및 Opus 4.8에서 `high`, Opus 4.7에서 `xhigh`. 전환 후 다른 수준을 선택하려면 `/effort`를 다시 실행하세요.

`low`, `medium`, `high` 및 `xhigh`는 세션 전체에 유지됩니다. `max`는 토큰 지출에 제약이 없어 가장 깊은 추론을 제공하며 현재 세션에만 적용됩니다. 단, `CLAUDE_CODE_EFFORT_LEVEL` 환경 변수를 통해 설정된 경우는 예외입니다.

`/effort` 메뉴는 또한 `ultracode`를 제공합니다. Ultracode는 모델 노력 수준이 아닌 Claude Code 설정입니다: 모델에 `xhigh`를 전송하고 추가로 Claude가 실질적인 작업을 위해 [동적 워크플로우](/ko/workflows)를 조율하도록 합니다. 현재 세션에만 적용됩니다. `/effort`를 통해 설정하거나, `--settings`를 통해 `"ultracode": true`를 전달하거나, Agent SDK 제어 요청을 통해 설정합니다. 이는 `effortLevel` 설정, `--effort` 플래그 또는 `CLAUDE_CODE_EFFORT_LEVEL`의 일부가 아닙니다.

<h4 id="choose-an-effort-level">
  노력 수준 선택
</h4>

각 수준은 토큰 지출과 기능을 절충합니다. 기본값은 대부분의 코딩 작업에 적합합니다. 다른 균형을 원할 때 조정하세요.

| 수준          | 사용 시기                                                                                    |
| :---------- | :--------------------------------------------------------------------------------------- |
| `low`       | 지능 민감도가 낮은 짧고 범위가 지정된 지연 시간 민감 작업을 위해 예약                                                 |
| `medium`    | 일부 지능을 절충할 수 있는 비용 민감 작업의 토큰 사용량 감소                                                      |
| `high`      | 토큰 사용량과 지능의 균형을 맞춥니다. Fable 5, Sonnet 5, Opus 4.8, Opus 4.6 및 Sonnet 4.6의 기본값            |
| `xhigh`     | 더 높은 토큰 지출로 더 깊은 추론. Opus 4.7의 기본값                                                       |
| `max`       | 까다로운 작업의 성능을 개선할 수 있지만 수익 감소를 보일 수 있으며 과도한 생각에 취약합니다. 광범위하게 채택하기 전에 테스트하세요               |
| `ultracode` | 각 실질적인 작업에 대해 `xhigh` 메시지별 추론으로 [동적 워크플로우](/ko/workflows)를 계획하는 Claude Code 설정입니다. 세션 전용 |

노력 척도는 모델별로 보정되므로 동일한 수준 이름이 모델 전체에서 동일한 기본 값을 나타내지 않습니다.

<h4 id="use-ultrathink-for-one-off-deep-reasoning">
  일회성 깊은 추론을 위해 ultrathink 사용
</h4>

프롬프트에 `ultrathink`를 포함하여 세션 노력 설정을 변경하지 않고 해당 턴에서 더 깊은 추론을 요청하세요. Claude Code는 키워드를 인식하고 컨텍스트 내 지시를 추가합니다. API로 전송되는 노력 수준은 변경되지 않습니다. "think", "think hard", "think more"와 같은 다른 구문은 일반 프롬프트 텍스트로 전달되며 키워드로 인식되지 않습니다.

<h4 id="set-the-effort-level">
  노력 수준 설정
</h4>

다음 중 하나를 통해 노력을 변경할 수 있습니다:

* **`/effort`**: 인수 없이 `/effort`를 실행하여 대화형 슬라이더를 열거나, 수준 이름 뒤에 `/effort`를 실행하여 직접 설정하거나, `/effort auto`를 실행하여 모델 기본값으로 재설정
* **`/model`에서**: 모델을 선택할 때 좌우 화살표 키를 사용하여 노력 슬라이더 조정
* **`--effort` 플래그**: Claude Code를 시작할 때 단일 세션에 대한 수준 이름을 전달
* **환경 변수**: `CLAUDE_CODE_EFFORT_LEVEL`을 수준 이름 또는 `auto`로 설정
* **설정**: 설정 파일에서 `effortLevel`을 `low`, `medium`, `high` 또는 `xhigh`로 설정합니다. `max` 및 `ultracode`는 [세션 전용](#adjust-effort-level)이며 여기서는 허용되지 않습니다
* **Skill 및 subagent frontmatter**: [skill](/ko/skills#frontmatter-reference) 또는 [subagent](/ko/sub-agents#supported-frontmatter-fields) markdown 파일에서 `effort`를 설정하여 해당 skill 또는 subagent가 실행될 때 노력 수준을 재정의

환경 변수가 모든 다른 방법보다 우선하고, 그 다음 구성된 수준, 그 다음 모델 기본값입니다. Frontmatter 노력은 해당 skill 또는 subagent가 활성화될 때 적용되어 세션 수준을 재정의하지만 환경 변수는 재정의하지 않습니다.

노력 슬라이더는 지원되는 모델이 선택되면 `/model`에 나타납니다. 현재 노력 수준은 로고 및 스피너 옆에도 표시되므로(예: "with low effort"), `/model`을 열지 않고도 어떤 설정이 활성화되어 있는지 확인할 수 있습니다.

<h4 id="adaptive-reasoning-and-fixed-thinking-budgets">
  적응형 추론 및 고정 사고 예산
</h4>

적응형 추론은 각 단계에서 사고를 선택 사항으로 만들므로 Claude는 일상적인 프롬프트에 더 빠르게 응답하고 이점을 얻는 단계를 위해 더 깊은 사고를 예약할 수 있습니다. Claude가 현재 수준이 생성하는 것보다 더 자주 또는 덜 자주 생각하기를 원하면 프롬프트 또는 `CLAUDE.md`에서 직접 말할 수 있습니다. 모델은 노력 설정 내에서 해당 지침에 응답합니다.

Fable 5, Sonnet 5 및 Opus 4.7 이상은 항상 적응형 추론을 사용합니다. 고정 사고 예산 모드 및 `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`은 이에 적용되지 않습니다.

Opus 4.6 및 Sonnet 4.6에서 `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`을 설정하여 `MAX_THINKING_TOKENS`로 제어되는 이전의 고정 사고 예산으로 되돌릴 수 있습니다. [환경 변수](/ko/env-vars)를 참조하세요.

<h3 id="extended-thinking">
  확장 사고
</h3>

확장 사고는 Claude가 응답하기 전에 내보내는 추론입니다. [적응형 추론](#adjust-effort-level)을 지원하는 모델에서 노력 수준은 얼마나 많은 사고가 발생하는지에 대한 주요 제어입니다. 아래 설정은 사고를 켜거나 끄고 표시 방식을 제어합니다.

| 제어            | 설정 방법                                                                                                                                                                                                                                                             |
| :------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 현재 세션에 대한 토글  | macOS에서 `Option+T` 또는 Windows 및 Linux에서 `Alt+T`를 누릅니다                                                                                                                                                                                                             |
| 전역 기본값 설정     | `/config`를 실행하고 사고 모드를 토글합니다. `~/.claude/settings.json`에 `alwaysThinkingEnabled`로 저장됩니다                                                                                                                                                                           |
| 노력에 관계없이 비활성화 | [`MAX_THINKING_TOKENS=0`](/ko/env-vars)을 설정합니다. 이는 Fable 5를 제외한 Anthropic API에서 사고를 끕니다. [타사 공급자](/ko/third-party-integrations)에서 이는 `thinking` 매개변수를 대신 생략하며 적응형 추론 모델은 여전히 생각할 수 있습니다. 다른 값은 [고정 사고 예산](#adaptive-reasoning-and-fixed-thinking-budgets)에만 적용됩니다 |

Fable 5에서는 사고를 끌 수 없습니다. 세션 토글, `alwaysThinkingEnabled` 및 `MAX_THINKING_TOKENS=0`은 여기서 효과가 없으며 Fable 5는 노력 수준에 따라 단계별로 얼마나 생각할지 결정합니다.

사고 출력은 기본적으로 축소됩니다. `Ctrl+O`를 눌러 자세한 모드를 토글하고 추론을 회색 기울임꼴 텍스트로 봅니다. Anthropic API의 대화형 세션은 기본적으로 편집된 사고 블록을 수신하므로 확장할 때 전체 요약을 사용할 수 있도록 하려면 [설정](/ko/settings)에서 `showThinkingSummaries: true`를 설정하세요. 축소되거나 편집된 경우에도 생성된 모든 사고 토큰에 대해 요금이 청구됩니다.

<h3 id="extended-context">
  확장 컨텍스트
</h3>

Fable 5, Sonnet 5, Opus 4.6 이상 및 Sonnet 4.6은 대규모 코드베이스를 사용한 긴 세션을 위해 [100만 토큰 컨텍스트 윈도우](https://platform.claude.com/docs/ko/build-with-claude/context-windows#1m-token-context-window)를 지원합니다.

가용성은 모델 및 플랜에 따라 다릅니다. Anthropic API에서 Fable 5, Sonnet 5, Opus 4.8 및 Opus 4.7은 항상 1M 윈도우로 실행됩니다. Max, Team 및 Enterprise 플랜에서 Opus는 추가 구성 없이 자동으로 1M 컨텍스트로 업그레이드됩니다. 이는 Team Standard 및 Team Premium 시트 모두에 적용됩니다. 1M 컨텍스트를 사용하는 Sonnet 4.6은 자동 업그레이드의 일부가 아니며 Max를 포함한 모든 구독 플랜에서 [사용 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans)이 필요합니다.

| 플랜                     | 1M 컨텍스트를 사용하는 Opus                                                                             | 1M 컨텍스트를 사용하는 Sonnet 4.6                                                                       |
| ---------------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Max, Team 및 Enterprise | 구독에 포함됨                                                                                        | [사용 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) 필요 |
| Pro                    | [사용 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) 필요 | [사용 크레딧](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) 필요 |
| API 및 종량제              | 전체 액세스                                                                                         | 전체 액세스                                                                                         |

1M 컨텍스트를 완전히 비활성화하려면 `CLAUDE_CODE_DISABLE_1M_CONTEXT=1`을 설정합니다. 이는 모델 선택기에서 1M 모델 변형을 제거합니다. [환경 변수](/ko/env-vars)를 참조하세요.

1M 컨텍스트 윈도우는 200K를 초과하는 토큰에 대한 프리미엄 없이 표준 모델 가격을 사용합니다. 확장 컨텍스트가 구독에 포함된 플랜의 경우 사용량은 구독으로 계속 적용됩니다. 사용 크레딧을 통해 확장 컨텍스트에 액세스하는 플랜의 경우 토큰은 사용 크레딧으로 청구됩니다.

계정이 1M 컨텍스트를 지원하면 최신 버전의 Claude Code에서 모델 선택기(`/model`)에 옵션이 나타납니다. 표시되지 않으면 세션을 다시 시작해 보세요.

모델 별칭 또는 전체 모델 이름과 함께 `[1m]` 접미사를 사용할 수도 있습니다:

```bash theme={null}
# opus[1m] 또는 sonnet[1m] 별칭 사용
/model opus[1m]
/model sonnet[1m]

# 또는 전체 모델 이름에 [1m] 추가
/model claude-opus-4-8[1m]
```

<h4 id="sonnet-5-context-window">
  Sonnet 5 컨텍스트 윈도우
</h4>

Anthropic API에서 Sonnet 5는 항상 1M 컨텍스트 윈도우로 실행됩니다. 200K 변형이 없고, 선택할 `[1m]` 접미사도 없으며, 어떤 플랜에서도 사용 크레딧이 필요하지 않습니다. 세션은 윈도우가 가득 차기 전에 자동 압축되며, 기본적으로 약 967K 토큰에서 압축됩니다. 다른 임계값을 선택하려면 [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](/ko/env-vars)를 설정하세요.

두 가지 구성은 대신 윈도우를 200K로 책정하고 해당 경계에서 자동 압축합니다:

* **LLM 게이트웨이**: `ANTHROPIC_BASE_URL`이 [게이트웨이](/ko/llm-gateway)를 가리킬 때 Claude Code는 1M 지원을 확인할 수 없습니다. 전체 윈도우를 사용하려면 모델 선택기에서 Sonnet 5 (1M context)를 선택하세요. 이는 `sonnet[1m]`에 매핑됩니다.
* **`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`**: 컨텍스트를 제한해야 하는 배포를 위해 Sonnet 5 세션을 200K 윈도우를 가진 것으로 처리합니다.

<h2 id="checking-your-current-model">
  현재 모델 확인
</h2>

현재 사용 중인 모델을 두 가지 위치에서 확인할 수 있습니다:

* [상태 줄](/ko/statusline)에서(구성된 경우)
* `/status`에서, 계정 정보도 표시합니다

<h2 id="add-a-custom-model-option">
  사용자 정의 모델 옵션 추가
</h2>

`ANTHROPIC_CUSTOM_MODEL_OPTION`을 사용하여 기본 제공 별칭을 대체하지 않고 `/model` 선택기에 단일 사용자 정의 항목을 추가합니다. 이는 Claude Code가 기본적으로 나열하지 않는 모델 ID를 테스트하는 데 유용합니다. LLM 게이트웨이 배포의 경우, Claude Code는 `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`이 설정되어 있을 때 게이트웨이의 `/v1/models` 엔드포인트에서 선택기를 자동으로 채울 수 있으므로, 이 변수는 검색이 비활성화되었거나 원하는 모델을 반환하지 않을 때만 필요합니다. [게이트웨이 모델 검색](/ko/llm-gateway-protocol#model-discovery)을 참조하십시오.

이 예시는 게이트웨이 라우팅된 Opus 배포를 선택 가능하게 하기 위해 세 가지 변수를 모두 설정합니다:

```bash theme={null}
export ANTHROPIC_CUSTOM_MODEL_OPTION="my-gateway/claude-opus-4-8"
export ANTHROPIC_CUSTOM_MODEL_OPTION_NAME="Opus via Gateway"
export ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION="Custom deployment routed through the internal LLM gateway"
```

사용자 정의 항목은 `/model` 선택기의 맨 아래에 나타납니다. `ANTHROPIC_CUSTOM_MODEL_OPTION_NAME` 및 `ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION`은 선택 사항입니다. 생략하면 모델 ID가 이름으로 사용되고 설명은 기본값으로 `Custom model (<model-id>)`입니다.

Claude Code는 `ANTHROPIC_CUSTOM_MODEL_OPTION`에 설정된 모델 ID에 대한 유효성 검사를 건너뜁니다. 따라서 API 엔드포인트가 허용하는 모든 문자열을 사용할 수 있습니다. [`availableModels`](#restrict-model-selection)이 설정되어 있을 때는 사용자 정의 모델 ID를 허용 목록에도 포함시켜야 합니다. 사용자 정의 항목이 선택기에서 필터링되고 `--model` 선택이 다른 제외된 모델처럼 거부됩니다. `my-gateway/claude-opus-4-8`과 같이 패밀리 이름을 포함하는 사용자 정의 ID는 해당 패밀리의 특정 항목으로 계산되며 와일드카드를 비활성화하므로, 선택 가능하게 유지하려는 버전도 나열해야 합니다. [병합 동작](#merge-behavior)을 참조하십시오.

<h2 id="environment-variables">
  환경 변수
</h2>

다음 환경 변수를 사용할 수 있으며, 이는 별칭이 매핑되는 모델 이름을 제어하기 위해 전체 모델 이름(또는 API 제공자에 해당하는 식별자)이어야 합니다.

| 환경 변수                            | 설명                                                                                                                                                                                          |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ANTHROPIC_DEFAULT_FABLE_MODEL`  | `fable`에 사용할 모델이며, Claude Code가 [자동 모델 폴백](#automatic-model-fallback)을 위해 타사 제공자에서 Fable 5로 인식하는 모델 ID입니다.                                                                                  |
| `ANTHROPIC_DEFAULT_OPUS_MODEL`   | `opus`에 사용할 모델 또는 Plan Mode가 활성화되었을 때 `opusplan`에 사용할 모델입니다.                                                                                                                                |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `sonnet`에 사용할 모델 또는 Plan Mode가 활성화되지 않았을 때 `opusplan`에 사용할 모델입니다.                                                                                                                           |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL`  | `haiku`에 사용할 모델 또는 [백그라운드 기능](/ko/costs#background-token-usage)입니다.                                                                                                                         |
| `CLAUDE_CODE_SUBAGENT_MODEL`     | 모든 [subagents](/ko/sub-agents#choose-a-model) 및 [agent teams](/ko/agent-teams)에 사용할 모델입니다. 호출별 `model` 매개변수와 subagent 정의의 `model` frontmatter를 재정의합니다. 대신 일반 모델 해석을 사용하려면 `inherit`로 설정합니다. |

참고: `ANTHROPIC_SMALL_FAST_MODEL`은 `ANTHROPIC_DEFAULT_HAIKU_MODEL`을 위해 더 이상 사용되지 않습니다.

<h3 id="pin-models-for-third-party-deployments">
  타사 배포를 위한 모델 고정
</h3>

[Bedrock](/ko/amazon-bedrock), [Vertex AI](/ko/google-vertex-ai), [Foundry](/ko/microsoft-foundry) 또는 [Claude Platform on AWS](/ko/claude-platform-on-aws)를 통해 Claude Code를 배포할 때 사용자에게 롤아웃하기 전에 모델 버전을 고정합니다.

고정하지 않으면 Claude Code는 `fable`, `opus`, `sonnet`, `haiku`와 같은 모델 별칭을 사용하며, 이는 각 제공자에 대한 기본 제공 기본 모델 ID로 확인됩니다. 해당 기본값은 최신 Anthropic 릴리스보다 뒤떨어질 수 있으며, 가리키는 모델이 사용자 계정에서 아직 활성화되지 않았을 수 있습니다. 기본값을 사용할 수 없으면 Bedrock 및 Vertex AI 사용자는 공지를 보고 해당 세션에 대해 이전 버전으로 폴백되며, Foundry 사용자는 Foundry에 동등한 시작 확인이 없기 때문에 오류를 봅니다.

<Warning>
  초기 설정의 일부로 모델 환경 변수를 특정 버전 ID로 설정합니다. 고정하면 사용자가 새 모델로 이동할 시기를 제어할 수 있습니다.
</Warning>

제공자에 대한 버전별 모델 ID와 함께 다음 환경 변수를 사용합니다:

| 제공자       | 예시                                                                   |
| :-------- | :------------------------------------------------------------------- |
| Bedrock   | `export ANTHROPIC_DEFAULT_OPUS_MODEL='us.anthropic.claude-opus-4-8'` |
| Vertex AI | `export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8'`              |
| Foundry   | `export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8'`              |

`ANTHROPIC_DEFAULT_FABLE_MODEL`, `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`에 대해 동일한 패턴을 적용합니다. 모든 제공자의 현재 및 레거시 모델 ID는 [모델 개요](https://platform.claude.com/docs/en/about-claude/models/overview)를 참조하세요. 사용자를 새 모델 버전으로 업그레이드하려면 이러한 환경 변수를 업데이트하고 다시 배포합니다.

고정된 모델에 대해 [확장 컨텍스트](#extended-context)를 활성화하려면 `ANTHROPIC_DEFAULT_OPUS_MODEL` 또는 `ANTHROPIC_DEFAULT_SONNET_MODEL`의 모델 ID에 `[1m]`을 추가합니다:

```bash theme={null}
export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8[1m]'
```

`[1m]` 접미사는 `opus` 및 `sonnet` 별칭의 모든 사용에 1M 컨텍스트 윈도우를 적용합니다. 이는 [`opusplan`](#opusplan-model-setting)의 plan-mode Opus 단계를 포함합니다.

* Claude Code는 모델 ID를 제공자에게 보내기 전에 접미사를 제거합니다.
* 기본 모델이 1M 컨텍스트를 [지원할 때만](https://platform.claude.com/docs/en/build-with-claude/context-windows#1m-token-context-window) `[1m]`을 추가합니다.
* 접미사는 모델별이 아닌 변수별로 읽혀집니다. Bedrock, Vertex 및 Foundry에서 한 변수의 `[1m]` 없는 모델 ID는 다른 변수가 접미사와 함께 동일한 모델을 설정하더라도 200K 컨텍스트를 사용합니다. Sonnet 5는 항상 이러한 제공자에서 1M 윈도우로 실행되며 접미사가 필요하지 않습니다.

<Note>
  `availableModels` 허용 목록은 타사 제공자를 사용할 때도 적용됩니다. [MDM 또는 관리 설정 파일](/ko/settings#settings-files)을 통해 전달된 `availableModels` 허용 목록은 여전히 타사 제공자를 사용할 때 적용됩니다. [서버 관리 설정은 그곳에 전달되지 않습니다](/ko/server-managed-settings#platform-availability). 필터링은 `opus`와 같은 모델 별칭, `claude-opus-4-8`과 같은 버전 접두사 또는 전체 제공자 형식 모델 ID와 일치합니다. `us.anthropic.`과 같은 제공자별 접두사는 제거되지 않으므로 특정 모델을 허용하려면 선택기가 표시하는 것과 동일한 제공자 형식 ID를 나열하거나 [`modelOverrides`](#override-model-ids-per-version)를 통해 매핑합니다. 모든 `[1m]` 접미사는 허용 목록 항목과 요청된 모델 모두에서 제거되어 일치합니다.
</Note>

<h3 id="customize-pinned-model-display-and-capabilities">
  고정된 모델 표시 및 기능 사용자 정의
</h3>

타사 제공자에서 모델을 고정하면 제공자별 ID가 `/model` 선택기에 그대로 나타나고 Claude Code는 모델이 지원하는 기능을 인식하지 못할 수 있습니다. 각 고정된 모델에 대한 동반 환경 변수로 표시 이름과 기능을 선언할 수 있습니다.

이러한 변수는 Bedrock, Vertex AI 및 Foundry와 같은 타사 제공자에서 적용됩니다. `_NAME` 및 `_DESCRIPTION` 변수는 `ANTHROPIC_BASE_URL`이 [LLM gateway](/ko/llm-gateway)를 가리킬 때도 적용됩니다. `api.anthropic.com`에 직접 연결할 때는 영향을 주지 않습니다.

| 환경 변수                                                 | 설명                                                                             |
| ----------------------------------------------------- | ------------------------------------------------------------------------------ |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_NAME`                   | `/model` 선택기에서 고정된 Opus 모델의 표시 이름입니다. 설정되지 않으면 모델 ID로 기본값 설정됩니다.               |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION`            | `/model` 선택기에서 고정된 Opus 모델의 표시 설명입니다. 설정되지 않으면 `Custom Opus model`로 기본값 설정됩니다. |
| `ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES` | 고정된 Opus 모델이 지원하는 기능의 쉼표로 구분된 목록입니다.                                           |

동일한 `_NAME`, `_DESCRIPTION` 및 `_SUPPORTED_CAPABILITIES` 접미사는 `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`, `ANTHROPIC_DEFAULT_FABLE_MODEL` 및 `ANTHROPIC_CUSTOM_MODEL_OPTION`에 사용 가능합니다.

Claude Code는 모델 ID를 알려진 패턴과 비교하여 [노력 수준](#adjust-effort-level) 및 [확장 사고](#extended-thinking)와 같은 기능을 활성화합니다. Bedrock ARN 또는 사용자 정의 배포 이름과 같은 제공자별 ID는 종종 이러한 패턴과 일치하지 않아 지원되는 기능이 비활성화됩니다. `_SUPPORTED_CAPABILITIES`를 설정하여 Claude Code에 모델이 실제로 지원하는 기능을 알립니다:

| 기능 값                   | 활성화                                          |
| ---------------------- | -------------------------------------------- |
| `effort`               | [노력 수준](#adjust-effort-level) 및 `/effort` 명령 |
| `xhigh_effort`         | {/* min-version: 2.1.111 */}`xhigh` 노력 수준    |
| `max_effort`           | `max` 노력 수준                                  |
| `thinking`             | [확장 사고](#extended-thinking)                  |
| `adaptive_thinking`    | 작업 복잡도에 따라 동적으로 사고를 할당하는 적응형 추론              |
| `interleaved_thinking` | 도구 호출 간의 사고                                  |

`_SUPPORTED_CAPABILITIES`가 설정되면 나열된 기능이 활성화되고 나열되지 않은 기능은 일치하는 고정된 모델에 대해 비활성화됩니다. 변수가 설정되지 않으면 Claude Code는 모델 ID를 기반으로 한 기본 제공 감지로 폴백합니다.

이 예시는 Opus를 Bedrock 사용자 정의 모델 ARN에 고정하고, 친화적인 이름을 설정하며, 기능을 선언합니다:

```bash theme={null}
export ANTHROPIC_DEFAULT_OPUS_MODEL='arn:aws:bedrock:us-east-1:123456789012:custom-model/abc'
export ANTHROPIC_DEFAULT_OPUS_MODEL_NAME='Opus via Bedrock'
export ANTHROPIC_DEFAULT_OPUS_MODEL_DESCRIPTION='Opus 4.7 routed through a Bedrock custom endpoint'
export ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTED_CAPABILITIES='effort,xhigh_effort,max_effort,thinking,adaptive_thinking,interleaved_thinking'
```

<h3 id="override-model-ids-per-version">
  버전별 모델 ID 재정의
</h3>

패밀리 수준 환경 변수는 패밀리 별칭당 하나의 모델 ID를 구성합니다. 동일한 패밀리 내의 여러 버전을 서로 다른 제공자 ID에 매핑해야 하는 경우 대신 `modelOverrides` 설정을 사용합니다.

`modelOverrides`는 개별 Anthropic 모델 ID를 Claude Code가 제공자의 API에 보내는 제공자별 문자열에 매핑합니다. 사용자가 `/model` 선택기에서 매핑된 모델을 선택하면 Claude Code는 기본 제공 기본값 대신 구성된 값을 사용합니다.

이를 통해 엔터프라이즈 관리자는 거버넌스, 비용 할당 또는 지역 라우팅을 위해 각 모델 버전을 특정 Bedrock 추론 프로필 ARN, Vertex AI 버전 이름 또는 Foundry 배포 이름으로 라우팅할 수 있습니다.

[설정 파일](/ko/settings#settings-files)에서 `modelOverrides`를 설정합니다:

```json theme={null}
{
  "modelOverrides": {
    "claude-opus-4-7": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/opus-prod",
    "claude-opus-4-6": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/opus-46-prod",
    "claude-sonnet-4-6": "arn:aws:bedrock:us-east-2:123456789012:application-inference-profile/sonnet-prod"
  }
}
```

키는 [모델 개요](https://platform.claude.com/docs/en/about-claude/models/overview)에 나열된 Anthropic 모델 ID여야 합니다. 날짜가 지정된 모델 ID의 경우 날짜 접미사를 정확히 표시된 대로 포함합니다. 알 수 없는 키는 무시됩니다.

재정의는 `/model` 선택기의 각 항목을 지원하는 기본 제공 모델 ID를 대체합니다. Bedrock에서 재정의는 Claude Code가 시작 시 자동으로 발견하는 모든 추론 프로필보다 우선합니다. `ANTHROPIC_MODEL`, `--model` 또는 `ANTHROPIC_DEFAULT_*_MODEL` 환경 변수를 통해 직접 제공하는 값은 제공자에게 그대로 전달되며 `modelOverrides`로 변환되지 않습니다.

`modelOverrides`는 `availableModels`과 함께 작동합니다. 허용 목록은 재정의 값이 아닌 Anthropic 모델 ID에 대해 평가되므로 `availableModels`의 `"opus"`와 같은 항목은 Opus 버전이 ARN에 매핑되어도 계속 일치합니다. `enforceAvailableModels`이 관리 설정에서 설정되면 강제된 기본값은 [가장 높은 우선순위 관리 소스](/ko/server-managed-settings#settings-precedence)에서만 `modelOverrides`를 통해 확인됩니다. 추론 프로필 ARN에 고정된 버전과 같은 관리자의 매핑이 강제된 기본값에서 인정됩니다. 사용자 또는 프로젝트 설정의 재정의는 이에 영향을 주지 않습니다.

<h3 id="prompt-caching-configuration">
  Prompt caching 구성
</h3>

Claude Code는 성능을 최적화하고 비용을 절감하기 위해 [prompt caching](/ko/prompt-caching)을 자동으로 사용합니다. 전역적으로 또는 특정 모델 계층에 대해 prompt caching을 비활성화할 수 있습니다:

| 환경 변수                           | 설명                                                            |
| ------------------------------- | ------------------------------------------------------------- |
| `DISABLE_PROMPT_CACHING`        | 모든 모델에 대해 prompt caching을 비활성화하려면 `1`로 설정합니다. 모델별 설정보다 우선합니다. |
| `DISABLE_PROMPT_CACHING_HAIKU`  | Haiku 모델에 대해서만 prompt caching을 비활성화하려면 `1`로 설정합니다.            |
| `DISABLE_PROMPT_CACHING_SONNET` | Sonnet 모델에 대해서만 prompt caching을 비활성화하려면 `1`로 설정합니다.           |
| `DISABLE_PROMPT_CACHING_OPUS`   | Opus 모델에 대해서만 prompt caching을 비활성화하려면 `1`로 설정합니다.             |
| `DISABLE_PROMPT_CACHING_FABLE`  | Fable 모델에 대해서만 prompt caching을 비활성화하려면 `1`로 설정합니다.            |

캐시 TTL을 변경하거나 캐시 미스를 트리거하는 것이 무엇인지 알아보려면 [Claude Code가 prompt caching을 사용하는 방법](/ko/prompt-caching)을 참조하세요.
