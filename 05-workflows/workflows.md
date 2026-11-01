> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 동적 워크플로우로 대규모 서브에이전트 조율하기

> 동적 워크플로우는 Claude가 작성한 스크립트에서 많은 서브에이전트를 조율하며, 이를 다시 실행할 수 있습니다. 코드베이스 감사, 대규모 마이그레이션, 교차 검증 연구에 사용합니다.

> [!NOTE]
>
> 동적 워크플로우는 모든 유료 요금제, Anthropic API 액세스, Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry에서 사용 가능합니다. Pro에서는 `/config`의 동적 워크플로우 행에서 활성화하십시오.

동적 워크플로우는 대규모로 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)를 조율하는 JavaScript 스크립트입니다. Claude는 설명한 작업에 대한 스크립트를 작성하고, 런타임이 백그라운드에서 실행하는 동안 세션은 응답성을 유지합니다.

한 번의 대화로 조율할 수 있는 것보다 더 많은 에이전트가 필요한 작업이거나, 읽고 다시 실행할 수 있는 스크립트로 조율을 코드화하려는 경우 워크플로우를 사용하십시오. 예시로는 코드베이스 전체 버그 스윕, 500개 파일 마이그레이션, 서로에 대해 소스를 교차 검증해야 하는 연구 질문, 하나에 커밋하기 전에 여러 독립적인 각도에서 작성할 가치가 있는 어려운 계획이 있습니다.

## 워크플로우를 언제 사용할지

[서브에이전트](https://code.claude.com/docs/ko/sub-agents.md), [스킬](https://code.claude.com/docs/ko/skills.md), [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md), 그리고 워크플로우는 모두 다단계 작업을 실행할 수 있습니다. 차이점은 계획을 누가 보유하는지입니다:

| | 서브에이전트 | 스킬 | 에이전트 팀 | 워크플로우 |
| :- | :- | :- | :- | :- |
| 정의 | Claude가 생성하는 워커 | Claude가 따르는 지침 | 피어 세션을 감독하는 리드 에이전트 | 런타임이 실행하는 스크립트 |
| 다음에 무엇을 실행할지 결정하는 사람 | Claude, 차례대로 | Claude, 프롬프트를 따르며 | 리드 에이전트, 차례대로 | 스크립트 |
| 중간 결과가 있는 위치 | Claude의 컨텍스트 윈도우 | Claude의 컨텍스트 윈도우 | 공유 작업 목록 | 스크립트 변수 |
| 반복 가능한 것 | 워커 정의 | 지침 | 팀 정의 | 조율 자체 |
| 규모 | 차례당 몇 가지 위임된 작업 | 서브에이전트와 동일 | 소수의 장기 실행 피어 | 실행당 수십 개에서 수백 개의 에이전트 |
| 중단 | 차례 다시 시작 | 차례 다시 시작 | 팀원들이 계속 실행 | 같은 세션에서 재개 가능 |

워크플로우는 계획을 코드로 이동합니다. 서브에이전트, 스킬, 에이전트 팀을 사용하면 Claude가 조율자입니다: 차례대로 다음에 무엇을 생성할지 또는 할당할지 결정하고, 모든 결과는 컨텍스트 윈도우에 들어갑니다. 워크플로우 스크립트는 루프, 분기, 중간 결과를 자체적으로 보유하므로 Claude의 컨텍스트는 최종 답변만 보유합니다.

계획을 코드로 이동하면 워크플로우가 반복 가능한 품질 패턴을 적용할 수 있으며, 단순히 더 많은 에이전트를 실행하는 것이 아닙니다: 독립적인 에이전트가 서로의 발견을 적대적으로 검토한 후 보고하거나, 여러 각도에서 계획을 작성하고 서로 비교하여 단일 패스보다 더 신뢰할 수 있는 결과를 얻을 수 있습니다.

## 번들된 워크플로우 실행

워크플로우가 실제로 어떻게 작동하는지 가장 빠르게 확인하는 방법은 `/deep-research`를 실행하는 것입니다. 이는 Claude Code에 포함된 [내장 워크플로우](#bundled-workflows)로, 여러 소스에서 질문을 조사합니다. 세션이 자유로운 상태로 유지되는 동안 백그라운드에서 에이전트가 여러 단계를 거쳐 작동하며, 턴별 기록 대신 최종 보고서 하나를 받게 됩니다.

**1. 워크플로우 실행**

조사하고 싶은 질문과 함께 `/deep-research`를 실행합니다. 여러 각도에서 웹 검색을 확산시키고, 찾은 소스를 가져와 교차 검증한 후, 인용된 보고서를 종합합니다.

```text wrap theme={null}
/deep-research What changed in the Node.js permission model between v20 and v22?
```

**2. 워크플로 허용**

Claude Code가 워크플로를 허용할지 묻습니다. **예**를 선택하여 계속 진행합니다. 정확한 프롬프트는 사용자의 권한 모드에 따라 달라집니다. 모드별 옵션은 [실행 전 계획 승인](#approve-the-plan-before-it-runs)을 참조하세요.

**3. 진행 상황 확인**

실행이 백그라운드에서 시작됩니다. `/workflows`를 실행하여 진행 상황 보기를 엽니다:

```text wrap theme={null}
/workflows
```

`/workflows`에 실행 목록이 대신 표시되면 방금 시작한 실행을 선택하고 Enter를 누릅니다. 보기에는 각 단계가 에이전트 수와 함께 표시됩니다. 모든 단계를 드릴다운하여 해당 에이전트와 각 에이전트가 찾은 내용을 확인할 수 있습니다. 전체 제어 옵션은 [실행 확인](#watch-the-run)을 참조하세요.

입력 상자 아래의 작업 패널에서도 확인할 수 있습니다. 실행이 진행되는 동안 한 줄의 진행 상황 요약이 표시됩니다. 아래쪽 화살표를 눌러 포커스를 맞춘 후 Enter를 눌러 확장할 수 있습니다.

**4. 보고서 읽기**

실행이 완료되면 보고서가 세션에 표시됩니다. 각 주장이 인용된 소스를 표시하며, 교차 검증을 통과하지 못한 주장은 이미 필터링되어 있습니다.

검증 에이전트가 속도 제한이나 API 오류 이후와 같이 주장을 확인할 수 없는 경우, 보고서는 해당 주장을 반박된 것으로 계산하지 않고 검증되지 않은 것으로 나열합니다.

자신의 작업을 위해 워크플로우를 실행하려면 [Claude가 워크플로우를 작성하도록](#have-claude-write-a-workflow) 하고, 실행이 원하는 대로 작동하면 [저장](#save-the-workflow-for-reuse)하여 자신만의 명령으로 만들 수 있습니다.

### 번들된 워크플로우

Claude Code에는 `/deep-research`가 내장 워크플로우로 포함되어 있습니다:

| 명령 | 기능 |
| :- | :- |
| `/deep-research <question>` | 질문에 대해 여러 각도에서 웹 검색을 확산시키고, 찾은 소스를 가져와 교차 검증하며, 각 주장에 투표하고, 교차 검증을 통과하지 못한 주장이 필터링된 인용된 보고서를 반환합니다. [WebSearch 도구](https://code.claude.com/docs/ko/tools-reference.md#websearch-tool-behavior)를 사용할 수 있어야 합니다 |

`/deep-research`는 사용자가 호출할 때만 실행됩니다.

[직접 저장](#save-the-workflow-for-reuse)한 워크플로우는 같은 방식으로 명령이 되며 번들된 워크플로우와 함께 `/` 자동 완성에 나타납니다.

### 실행 확인

워크플로는 백그라운드에서 실행되므로 에이전트가 작동하는 동안 세션이 반응성을 유지합니다. 언제든지 `/workflows`를 실행하여 실행 중이거나 완료된 워크플로를 나열한 후 하나를 선택하여 진행 상황 보기를 엽니다. 세션에 실행이 하나뿐이면 `/workflows`는 목록을 건너뛰고 해당 실행을 엽니다. 실행 중인 워크플로를 열지 않고 목록에서 중지하려면 선택하고 `x`를 누르세요.

진행 상황 보기에는 각 단계가 에이전트 수와 함께 표시됩니다. 바닥글에는 각 작업의 키가 나열됩니다:

| 키 | 작업 |
| :- | :- |
| `↑` / `↓` | 단계 또는 에이전트 선택 |
| `Enter` 또는 `→` | 선택한 단계로 드릴다운한 후 에이전트의 세부 정보로 드릴다운합니다. 세부 정보에서 `Enter`는 이를 확장하거나 축소합니다 |
| `Esc` 또는 `←` | 한 수준 뒤로 이동합니다 |
| `j` / `k` | 에이전트 세부 정보가 오버플로우할 때 스크롤 |
| `f` | 선택한 단계의 에이전트 목록을 상태별로 필터링합니다. 다시 누르면 순환합니다 |
| `p` | 실행을 일시 중지하거나 재개합니다 |
| `x` | 선택한 에이전트를 중지하거나, 포커스가 실행에 있을 때 전체 워크플로우를 중지합니다 |
| `r` | 선택한 실행 중인 에이전트를 다시 시작합니다 |
| `s` | 실행의 스크립트를 명령으로 [저장](#save-the-workflow-for-reuse)합니다 |

에이전트 세부 정보에는 에이전트의 프롬프트, 최근 도구 호출, 결과가 나열됩니다. 각 호출은 여전히 실행 중이거나 실패한 것과 같은 상태를 표시합니다. 에이전트가 자체 작업 목록을 유지할 때, 세부 정보는 각 작업의 상태와 함께 이를 표시합니다.

`Enter`를 눌러 세부 정보를 확장합니다. 그러면 프롬프트와 결과가 전체적으로 표시되고, 나열된 각 호출은 입력과 결과의 시작을 표시합니다.

## Claude에게 워크플로 작성 맡기기

Claude가 작업에 맞는 워크플로를 작성하도록 하는 방법은 두 가지입니다.

* 프롬프트에서 [워크플로 요청하기](#ask-for-a-workflow-in-your-prompt): 직접 요청하거나 `ultracode` 키워드를 포함하면 Claude가 해당 작업에 맞는 워크플로를 작성합니다.
* [ultracode로 Claude가 판단하도록 하기](#let-claude-decide-with-ultracode): `/effort ultracode`를 설정하면 Claude가 세션의 모든 실질적인 작업에 대해 워크플로를 계획합니다.

이미 존재하는 워크플로 명령을 실행할 수도 있습니다. `/deep-research` 같은 [번들 워크플로](#bundled-workflows)나 직접 [저장한](#save-the-workflow-for-reuse) 워크플로를 실행할 수 있습니다.

### 프롬프트에서 워크플로 요청하기

세션의 effort 수준을 변경하지 않고 단일 작업을 워크플로로 실행하려면 프롬프트에 `ultracode` 키워드를 포함합니다. "use a workflow"나 "run a workflow"처럼 직접 요청해도 됩니다. Claude는 직접적인 요청도 동일한 옵트인으로 처리합니다.

```text wrap theme={null}
ultracode: audit every API endpoint under src/routes/ for missing auth checks
```

Claude Code는 입력에서 키워드를 강조 표시하고, Claude는 작업을 턴 단위로 진행하는 대신 해당 작업에 맞는 워크플로 스크립트를 작성합니다. 키워드는 Claude가 작업을 구성하는 방식만 결정합니다. 에이전트의 도구 호출은 세션의 다른 모든 도구 호출과 동일한 권한 검사와 [샌드박싱](https://code.claude.com/docs/ko/sandboxing.md)을 거칩니다.

실행 결과가 원하는 대로 나왔다면 이후에 [명령으로 저장](#save-the-workflow-for-reuse)할 수 있습니다. 서브에이전트 프롬프트 폴더나 작업을 분산하는 스킬처럼 다른 방식으로 구축한 오케스트레이터가 이미 있다면, Claude에게 이를 알려 주고 같은 일을 하는 워크플로를 요청할 수 있습니다.

#### 키워드 무시 또는 끄기

워크플로를 시작할 의도가 아니었다면 macOS에서는 `Option+W`, Windows와 Linux에서는 `Alt+W`를 눌러 이번 프롬프트의 강조 표시를 해제하거나, 커서가 강조 표시된 키워드 바로 뒤에 있을 때 백스페이스를 누릅니다. 키워드가 아예 작동하지 않도록 하려면 `/config`에서 Ultracode keyword trigger를 끕니다.

#### 키워드가 작동하는 위치

키워드는 사용자가 직접 입력한 프롬프트에서만 옵트인으로 작동합니다. 즉, 대화형 프롬프트, IDE 확장 패널, [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 클라이언트, 또는 키보드 입력의 [`origin`](https://code.claude.com/docs/ko/agent-sdk/typescript#sdkmessageorigin)을 `{ kind: "human" }`으로 표시하는 Agent SDK 애플리케이션에서만 작동합니다. 다른 경로로 세션에 전달되는 경우에는 워크플로를 시작하지 않습니다.

* `-p`로 전달된 프롬프트
* Agent SDK 애플리케이션이 사람의 입력으로 표시하지 않고 보낸 프롬프트
* 예약 작업 프롬프트
* 대화로 전달된 웹훅 페이로드 또는 풀 리퀘스트 댓글

### ultracode로 Claude가 판단하도록 하기

Ultracode는 세션이 실행되는 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)에 관계없이 해당 세션에서 자동 워크플로 오케스트레이션을 켜는 Claude Code 설정입니다. 이 설정을 켜면 Claude는 사용자의 요청을 기다리지 않고 각 실질적인 작업에 대해 워크플로를 계획합니다. Claude Code 프롬프트에서 다음과 같이 켭니다.

```text wrap theme={null}
/effort ultracode
```

ultracode가 켜진 상태로 세션을 시작하려면 `claude --effort ultracode`로 실행합니다. 이 경우 effort 수준도 `xhigh`로 설정됩니다.

`/effort` 슬라이더에서 켜려면 `Tab`을 눌러 **Ultracode** 토글을 전환한 다음 `Enter`를 눌러 적용합니다. ultracode를 켜는 방법은 [effort 수준 조정](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)에 나와 있습니다.

ultracode가 켜져 있으면 Claude가 작업에 워크플로가 필요한 시점을 판단합니다. 하나의 요청이 여러 워크플로로 연이어 이어질 수 있습니다. 코드를 이해하는 워크플로, 변경을 수행하는 워크플로, 이를 검증하는 워크플로가 각각 실행될 수 있습니다. 이는 세션의 모든 작업에 적용되므로, 각 요청은 워크플로 없이 같은 요청을 처리할 때보다 더 많은 토큰을 사용하고 더 오래 걸립니다. 구독 플랜에서는 이러한 토큰이 사용 한도에서 차감되므로, ultracode를 켠 세션은 끈 상태로 같은 작업을 할 때보다 세션 한도나 주간 한도에 더 빨리 도달합니다.

ultracode를 켜면 이미 대규모 실행에 옵트인한 것이므로, 켜져 있는 동안에는 다음 검사가 적용되지 않습니다.

* 워크플로 실행 시 [`Large workflow` 경고](#cost)가 표시되지 않습니다
* Claude가 Agent 도구로 생성하는 서브에이전트에는 세션의 [동시 서브에이전트 제한](https://code.claude.com/docs/ko/sub-agents.md#concurrent-subagent-limit)이 적용되지 않습니다
* 자동 권한 모드에서 [첫 워크플로 실행 승인](#approve-the-plan-before-it-runs)을 요청받지 않습니다

`/effort ultracode`는 현재 세션 동안 유지됩니다. 모든 세션이 이 설정으로 시작되도록 하려면 [`ultracode`](https://code.claude.com/docs/ko/settings-reference#ultracode) 설정을 지정합니다. 일상적인 작업으로 돌아갈 때는 `/effort ultracode off`로 끕니다. `/effort` 슬라이더는 [ultracode를 사용할 수 있는 경우](https://code.claude.com/docs/ko/model-config.md#when-ultracode-is-available)에만 토글을 제공합니다. v2.1.284 이전에는 `/effort ultracode`가 세션을 `xhigh`로 설정했고, `/effort ultracode off`는 `Invalid argument`로 실패했습니다.

### 실행 전 계획 승인하기

CLI에서는 실행별 프롬프트에 계획된 단계와 다음 옵션이 표시됩니다.

* **Yes, run it**: 실행을 시작합니다
* **Yes, and don't ask again for `<name>` in `<path>`**: 실행을 시작하고, 이후 이 프로젝트에서 이 워크플로에 대해서는 이 프롬프트를 건너뜁니다. Claude Code는 번들, 저장된, 또는 플러그인 워크플로를 이름으로 실행할 때 이 옵션을 제공하며, Claude가 현재 작업을 위해 작성한 스크립트에는 제공하지 않습니다.
* **View raw script**: 결정하기 전에 스크립트를 확인합니다
* **No**: 취소합니다

`Ctrl+G`를 누르면 편집기에서 스크립트가 열립니다. **Yes, run it** 또는 **No**를 선택한 상태에서 `Tab`을 눌러 응답에 [댓글을 추가](https://code.claude.com/docs/ko/permissions.md#add-a-comment-when-you-answer-a-permission-prompt)할 수 있습니다.

이 프롬프트가 표시되는지 여부는 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)에 따라 달라집니다.

| 권한 모드 | 확인을 요청하는 시점 |
| :- | :- |
| Auto | 첫 실행 시에만 요청합니다. **Yes** 중 하나를 선택하면 사용자 설정에 동의가 기록되며, 이후 실행은 확인 없이 시작됩니다. ultracode가 켜져 있으면 완전히 건너뜁니다 |
| Manual, accept edits | 해당 프로젝트에서 해당 워크플로에 대해 **Yes, and don't ask again**을 선택하지 않은 한 매 실행 시 요청합니다 |
| Bypass permissions | Claude Code가 확인을 요청하지 않습니다. 실행이 즉시 시작됩니다 |
| `claude -p`, Agent SDK | Claude Code가 확인을 요청하지 않습니다 |

`claude -p`와 Agent SDK에서는 Claude Code가 이 프롬프트를 표시하지 않습니다. Workflow 도구 호출은 세션의 나머지 부분과 동일한 [권한 평가](https://code.claude.com/docs/ko/agent-sdk/permissions.md#how-permissions-are-evaluated)를 거치므로, 거부 규칙, 확인 규칙, `dontAsk` 모드가 모든 도구 호출과 마찬가지로 실행에도 적용됩니다. 이러한 실행에서 워크플로가 시작되도록 하려면 다음 중 하나를 사용합니다.

* **권한 규칙**: 모든 워크플로를 승인하려면 허용 규칙에 `Workflow`를 추가하고, 저장된 워크플로 하나를 이름으로 승인하려면 `Workflow(<name>)`를 추가합니다.
* **자동 권한 모드**: [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)로 실행하면 분류기가 호출을 검토하고 승인할 수 있습니다.
* **Bypass permissions 모드**: bypass permissions 모드로 실행합니다.
* **훅**: [`PreToolUse`](https://code.claude.com/docs/ko/hooks#pretooluse) 훅에서 해당 호출에 대해 `"allow"`를 반환합니다. [플랜 모드](https://code.claude.com/docs/ko/permission-modes.md#analyze-before-you-edit-with-plan-mode)에서는 훅의 승인만으로 워크플로가 시작되지 않으므로, 이 경우에는 권한 규칙이나 호스트의 승인을 사용합니다.
* **호스트**: [`--permission-prompt-tool`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 또는 Agent SDK의 [`canUseTool`](https://code.claude.com/docs/ko/agent-sdk/permissions) 콜백이 승인합니다.

Desktop 앱에서는 승인 카드에 워크플로 이름, 단계 목록, 토큰 사용량 주의 사항이 **Once**, **Always**, **Deny** 동작과 함께 표시됩니다. 진행 상황 보기는 Background tasks 사이드 패널에 나타납니다.

워크플로가 생성하는 서브에이전트는 사용자의 [권한 규칙](https://code.claude.com/docs/ko/settings-reference.md#permission-settings)을 사용하며, Claude Code는 [서브에이전트가 실행되는 권한 모드](https://code.claude.com/docs/ko/sub-agents.md#permission-modes)의 규칙에 따라 해당 권한 모드를 선택합니다. 장시간 실행에서 프롬프트가 표시되지 않도록 하려면 시작하기 전에 에이전트에 필요한 도구를 허용 규칙에 추가합니다.

### 재사용을 위해 워크플로 저장하기

Claude가 반복할 작업을 위한 워크플로를 작성하면 해당 실행의 스크립트를 명령으로 저장할 수 있습니다. 그러면 모든 브랜치에서 실행하는 리뷰 같은 프로세스가 매번 동일한 오케스트레이션으로 실행됩니다.

`/workflows`를 실행하고 보관할 실행을 선택한 다음 `s`를 누릅니다. 저장 대화 상자에서 Tab을 누르면 두 저장 위치 간에 전환됩니다.

* 프로젝트의 `.claude/workflows/`: 저장소를 복제하는 모든 사람과 공유됩니다
* 홈 디렉터리의 `~/.claude/workflows/`: 모든 프로젝트에서 사용할 수 있으며 본인에게만 표시됩니다. [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars)를 설정한 경우 이 위치는 해당 경로 아래의 `workflows/` 디렉터리입니다.

저장 대화 상자에는 개인 위치의 확인된 경로가 표시됩니다. Enter를 눌러 저장합니다. 어느 위치에 저장하든 이후 세션에서 워크플로가 `/<name>`으로 실행됩니다.

Claude Code는 쓰기 전에 저장 위치에 심볼릭 링크가 있는지 확인하며, 심볼릭 링크를 통해 쓰는 대신 오류를 표시합니다.

* 프로젝트 위치: `.claude`, `.claude/workflows` 또는 대상 파일이 심볼릭 링크이면 Claude Code가 거부합니다.
* 개인 위치: 대상 파일 자체가 심볼릭 링크인 경우에만 Claude Code가 거부하므로, dotfiles 도구로 관리하는 `~/.claude` 디렉터리도 계속 작동합니다.

`.claude/` 디렉터리가 여러 개인 모노레포에서는 워크플로를 해당 워크플로가 적용되는 패키지와 함께 보관할 수 있습니다. 프로젝트 위치에 저장하면 작업 디렉터리와 저장소 루트 사이에 이미 존재하는 가장 가까운 `.claude/workflows/` 디렉터리에 쓰며, 아직 없으면 저장소 루트에 씁니다. 프로젝트 워크플로는 해당 경로상의 모든 `.claude/workflows/`에서도 로드되며, 둘 이상이 같은 이름을 정의하는 경우 Claude Code는 작업 디렉터리에 가장 가까운 것을 실행합니다.

프로젝트 워크플로와 개인 워크플로의 이름이 같으면 프로젝트 워크플로가 실행됩니다.

### 플러그인으로 워크플로 배포하기

팀이나 저장소 간에 워크플로를 공유하려면 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)에 포함합니다. 스크립트를 플러그인 루트의 `workflows/` 디렉터리에 두거나, [`workflows` 매니페스트 필드](https://code.claude.com/docs/ko/plugins/manifest-reference#fields)로 다른 위치를 지정합니다.

플러그인 워크플로는 플러그인 이름으로 네임스페이스가 지정됩니다. `meta.name`이 `release-audit`인 스크립트를 포함하는 `acme-tools`라는 플러그인은 `/acme-tools:release-audit`로 실행됩니다.

### 저장된 워크플로에 입력 전달하기

저장된 워크플로는 `args` 파라미터를 통해 입력을 받을 수 있습니다. 스크립트는 이를 `args`라는 전역 변수로 읽습니다. 실행할 때마다 스크립트를 편집하는 대신 호출 시점에 연구 질문, 대상 경로 목록 또는 구성 객체를 제공하는 데 사용합니다.

다음 프롬프트는 이슈 번호 목록으로 저장된 워크플로를 실행합니다.

```text wrap theme={null}
Run /triage-issues on issues 1024, 1025, and 1030
```

Claude는 목록을 구조화된 데이터로 전달하므로, 스크립트는 먼저 파싱하지 않고도 `args`에서 배열 및 객체 메서드를 직접 호출할 수 있습니다. `args`를 생략하면 스크립트 내에서 전역 변수는 `undefined`입니다.

## 워크플로 프롬프트 예시

워크플로는 작업이 하나의 에이전트가 컨텍스트에 담을 수 있는 범위보다 크거나, 같은 단계를 여러 항목에 걸쳐 실행해야 할 때 가장 적합합니다. 아래 프롬프트는 일반적인 형태를 보여 줍니다. 각 프롬프트는 Claude에게 해당 작업을 위한 워크플로를 작성하고 실행하도록 요청하므로, 스크립트를 직접 작성할 필요가 없습니다.

### 여러 파일에서 같은 문제 감사하기

파일마다 에이전트를 하나씩 분산 실행한 다음, 발견 사항을 수집하고 검증합니다.

```text wrap theme={null}
use a workflow to audit every route handler under src/routes/ for missing authentication checks, and adversarially verify each finding before reporting it
```

### 검사를 통과할 때까지 계속 수정하기

검사기를 실행하고, 실패한 부분을 수정한 뒤, 통과하거나 더 이상 진전이 없을 때까지 반복합니다.

```text wrap theme={null}
use a workflow to run npx tsc --noEmit and keep fixing the reported errors until the type check passes or two rounds in a row make no progress
```

### 여러 파일을 병렬로 마이그레이션하기

마이그레이션할 파일을 찾고, 편집이 충돌하지 않도록 각 파일을 격리된 사본에서 변환한 다음, 각 결과를 검증합니다.

```text wrap theme={null}
use a workflow to migrate every component under src/components/ from JavaScript to TypeScript, working on each file in its own isolated copy
```

### 변경된 모든 파일을 리뷰하고 하나의 요약 작성하기

파일마다 리뷰어를 실행한 다음, 모든 발견 사항을 하나의 에이전트에 전달하여 순위를 매기고 중복을 제거합니다.

```text wrap theme={null}
use a workflow to review every file changed in this PR for correctness issues, then merge the per-file findings into one ranked summary
```

### 여러 출처에 걸쳐 주제 조사하기

변경 로그, 이슈, 문서에 걸쳐 리더를 분산 실행한 다음 종합합니다. 번들로 제공되는 `/deep-research` 워크플로가 이 작업을 수행하며, 더 좁은 범위의 버전을 직접 설명할 수도 있습니다.

```text wrap theme={null}
use a workflow to research how our three competitors handle rate limiting: read their public docs and recent changelog entries in parallel, then compare the approaches
```

### 목록이 더 이상 늘어나지 않을 때까지 문제 찾기

여러 라운드에 걸쳐 계속 탐색하고, 새 라운드에서 새로운 것이 발견되지 않으면 중단합니다.

```text wrap theme={null}
use a workflow to find flaky tests in this repo: run the suite repeatedly, record which tests fail intermittently, and stop once two rounds in a row find nothing new
```

### 저장된 스크립트의 모습

[워크플로를 저장](#save-the-workflow-for-reuse)하면 `.claude/workflows/`의 파일에는 `meta` 블록과 그 뒤에 서브에이전트를 오케스트레이션하는 스크립트 본문이 담깁니다. 일반적으로 이 파일을 편집할 필요는 없지만, Claude가 생성한 내용을 알아볼 수 있도록 작은 스크립트의 형태를 아래에 보여 드립니다.

```javascript theme={null}
export const meta = {
  name: 'audit-routes',
  description: 'Audit every route handler for missing auth checks',
}

const found = await agent('List every .ts file under src/routes/.', {
  schema: { type: 'object', required: ['files'], properties: { files: { type: 'array', items: { type: 'string' } } } },
})

const audits = await pipeline(found.files, file =>
  agent(`Audit ${file} for missing authentication checks.`, { label: file }),
)

return audits.filter(Boolean)
```

본문은 최상위 `await`를 사용하는 일반 JavaScript입니다. `agent()`는 서브에이전트 하나를 생성하고, `pipeline()`은 목록의 항목마다 하나씩 실행하며, `parallel()`은 에이전트 작업 집합을 동시에 실행하고 모두 완료될 때까지 기다립니다.

사용자가 실행 도중에 `agent()` 호출을 중지하거나 해당 호출이 복구할 수 없는 API 오류를 만나면, 호출은 `null`로 확인됩니다. `pipeline()`은 각 `null`을 결과 배열에 그대로 유지하므로, 예시는 [모든 시도에서 멈춘 에이전트](#when-an-agent-stalls-and-restarts)의 슬롯을 포함한 해당 항목을 제거하기 위해 `.filter(Boolean)`으로 끝납니다.

[자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)에서 분류기가 서브에이전트의 작업을 검토할 때, 스크립트가 `agent()`에 전달하는 프롬프트는 사용자의 요청으로 간주되지 않습니다. Claude Code가 이를 스크립트가 계산한 텍스트로 표시하기 때문입니다.

`agent()` 호출에 `schema`를 전달하면, 해당 서브에이전트는 산문 대신 그 형태에 맞는 JSON을 반환합니다. Claude Code는 서브에이전트를 시작하기 전에 스키마를 검사합니다. 스키마가 자기모순임을 증명할 수 있으면 호출은 해당 모순을 명시한 오류와 함께 실패하며, 서브에이전트는 시작되지 않습니다. 증명할 수 있는 모순의 한 예는 `additionalProperties: false`가 배제하는 `required` 키입니다.

서브에이전트의 출력이 다섯 번 시도한 후에도 여전히 검증에 실패하면, 호출은 마지막 검증 실패 내용을 포함한 오류와 함께 실패합니다. 시도 횟수를 변경하려면 [`MAX_STRUCTURED_OUTPUT_RETRIES`](https://code.claude.com/docs/ko/env-vars)를 설정합니다.

### 저장된 스크립트 편집하기

[저장한 워크플로](#save-the-workflow-for-reuse)를 변경하려면 해당 `.js` 파일을 편집하거나 Claude에게 변경을 요청합니다. 편집하거나 요청하기 전에 `/workflow-authoring` [번들 스킬](https://code.claude.com/docs/ko/skills.md#bundled-skills)을 실행하여 Claude가 참고하는 스크립트 작성 레퍼런스를 로드합니다. 이 스킬에는 Claude Code v2.1.248 이상이 필요합니다.

현재 세션에서 편집된 버전을 실행하려면 [`/reload-skills`](https://code.claude.com/docs/ko/commands#all-commands)를 실행하여 워크플로 디렉터리를 다시 읽은 다음, `/<name>`을 다시 실행합니다.

Claude Code는 스크립트를 로드하고 실행할 때 파일의 각 부분에 다음 규칙을 적용합니다.

* **`meta` 블록**: `export const meta`를 첫 번째 문으로 유지하고, `name`과 `description`을 가진 일반 객체 리터럴로 유지합니다. 변수, 함수 호출, 스프레드처럼 리터럴 값이 아닌 것이 포함되어 있으면 Claude Code는 `/` 자동 완성에서 `/<name>`을 제외합니다.
* **본문**: `agent()`, `pipeline()`, `parallel()` 외에도 `phase()`를 호출하여 이후의 에이전트를 진행 상황 보기에서 하나의 제목 아래로 그룹화하고, `log()`를 호출하여 단계 위에 메시지를 표시하며, [`args`](#pass-input-to-a-saved-workflow) 전역 변수를 읽을 수 있습니다. 본문에 구문 오류가 있으면 Claude Code는 워크플로를 실행할 때 이를 보고합니다.
* **`phases`**: `meta`에 나열하는 경우, 각 항목에 `phase()`에 전달하는 제목을 정확히 그대로 지정합니다. 항목이 없는 `phase()` 제목은 별도의 진행 상황 그룹을 갖게 됩니다.
* **타임스탬프와 무작위성**: Claude Code는 스크립트 내에서 `Date.now()`, `Math.random()`, 인수 없는 `new Date()`가 예외를 발생시키도록 하여, [다시 시작된 실행](#resume-after-a-pause)이 동일한 `agent()` 호출을 반복하도록 합니다. 대신 `args`를 통해 타임스탬프를 전달합니다.

저장된 사본 대신 [단일 실행의 스크립트](#how-a-workflow-runs)를 편집할 수도 있습니다. 편집된 스크립트를 다시 시작할 때 어떤 에이전트가 다시 실행되는지는 [일시 중지 후 재개하기](#resume-after-a-pause)에서 다룹니다. Workflow 도구의 입력에 대해서는 [Agent SDK 레퍼런스](https://code.claude.com/docs/ko/agent-sdk/typescript.md#workflow)의 해당 항목을 참조하세요.

## 워크플로우가 어떻게 실행되는지

워크플로우 런타임은 대화와 분리된 격리된 환경에서 스크립트를 실행합니다. 중간 결과는 Claude의 컨텍스트에 들어가는 대신 스크립트 변수에 남아 있습니다.

Claude가 스크립트 파일 경로에서 실행을 시작하는 경우가 아니라면, Claude Code는 실행의 스크립트를 `~/.claude/projects/` 아래의 세션 디렉터리에 있는 파일에 작성합니다. Claude는 실행이 시작될 때 스크립트의 경로를 받으므로 경로를 요청할 수 있습니다. 해당 파일을 열어 Claude가 작성한 오케스트레이션을 읽거나, 이전 실행의 스크립트와 diff를 비교하거나, 편집한 후 Claude에 편집된 버전에서 다시 시작하도록 요청할 수 있습니다.

Claude는 세션이 이미 읽을 수 있는 스크립트 파일에서만 워크플로우를 시작할 수 있습니다. 작업 디렉토리 외부에 보관된 스크립트를 실행하려면 먼저 [`/add-dir`](https://code.claude.com/docs/ko/permissions#working-directories)을 사용하거나 [Read 허용 규칙](https://code.claude.com/docs/ko/permissions.md#read-and-edit)을 추가합니다.

런타임은 실행이 진행되면서 각 에이전트의 결과를 추적하며, 이것이 실행을 [같은 세션 내에서 재개 가능](#resume-after-a-pause)하게 만드는 것입니다.

### 팬아웃에서의 프롬프트 캐싱

같은 실행의 에이전트들은 서로의 [프롬프트 캐시](https://code.claude.com/docs/ko/prompt-caching.md#subagents-and-the-cache)를 읽을 수 있습니다. 같은 모델, 노력 수준, 에이전트 유형, 도구, 출력 스키마 및 작업 디렉토리로 실행되는 두 에이전트는 동일한 도구 및 시스템 프롬프트 접두사를 구축하므로, 일치하는 형제 에이전트의 응답이 시작된 후에 시작되는 에이전트는 첫 번째 요청에서 해당 형제의 캐시를 읽습니다.

워크플로우 에이전트의 요청은 주 대화의 [캐시 TTL 버킷](https://code.claude.com/docs/ko/prompt-caching.md#which-ttl-each-request-gets) 외부에 있으므로, Claude 구독에서도 기본적으로 5분 동안 캐시가 유지됩니다. 1시간 동안 유지하려면 [`subagentPromptCacheTtl`](https://code.claude.com/docs/ko/settings-reference#subagentpromptcachettl)을 `1h`로 설정합니다. API는 1시간 캐시 쓰기를 더 높은 요금으로 청구합니다.

팬아웃이 여러 일치하는 에이전트를 한 번에 시작할 때, Claude Code는 첫 번째 에이전트를 제외한 모든 에이전트를 첫 번째 에이전트의 응답이 시작될 때까지 보류한 다음, 보류된 에이전트들을 함께 해제하여 각각 캐시되지 않은 상태로 처리하는 대신 공유 접두사를 읽도록 합니다. Claude Code는 보류를 [`CLAUDE_CODE_WORKFLOW_PREFIX_STAGGER_MS`](https://code.claude.com/docs/ko/env-vars) 밀리초(기본값 `5000`)로 제한합니다. 보류를 비활성화하려면 `0`으로 설정합니다.

### 동작 및 제한

런타임은 다음 제약을 적용합니다:

| 제약 | 이유 |
| :- | :- |
| 실행 중 사용자 입력 없음 | 실행은 에이전트 권한 프롬프트와 [사용량 제한 대기](#when-a-run-hits-your-usage-limit)에서만 일시 중지됩니다. 단계 간 승인을 위해 각 단계를 자신의 워크플로우로 실행합니다 |
| 워크플로우 자체에서 직접 파일 시스템 또는 셸 액세스 없음 | 에이전트가 읽고, 쓰고, 명령을 실행합니다. 스크립트가 에이전트를 조율합니다 |
| 모듈 로딩 없음: `import()`를 포함하는 스크립트는 실행이 시작되기 전에 실패합니다 | 스크립트 본문은 순수 JavaScript입니다. 라이브러리가 필요한 작업은 에이전트의 작업에 넣습니다 |
| 최대 16개의 동시 에이전트, CPU 코어가 제한된 머신에서는 더 적음 (CPU 제한 컨테이너 내부 포함). 제한을 변경하려면 [`CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS`](https://code.claude.com/docs/ko/env-vars#variables)를 1에서 256 사이의 값으로 설정합니다. 이는 Claude Code v2.1.269 이상이 필요합니다 | 로컬 리소스 사용 제한 |
| 팬아웃에서, 첫 번째 에이전트의 프롬프트 캐시 접두사를 공유하는 에이전트는 기본적으로 최대 5초 후에 시작됩니다 | 첫 번째를 제외한 모든 에이전트는 각각 캐시되지 않은 상태로 처리하는 대신 [첫 번째 에이전트가 캐시한 접두사](#prompt-caching-in-a-fan-out)를 읽습니다 |
| 단일 `parallel()` 또는 `pipeline()` 호출에서 최대 4,096개 항목: 런타임은 더 긴 목록을 오류로 거부합니다 | 자동 제한은 스크립트에 알리지 않고 작업의 일부를 삭제할 수 있습니다 |
| 실행당 총 1,000개의 에이전트 | 폭주 루프 방지 |

## 실행 관리

실행이 시작되면 `/workflows` 보기에서, 또는 입력 상자 아래 작업 패널에서 해당 실행의 진행 줄을 펼쳐 관리할 수 있습니다.

실행을 중지하면 해당 실행의 에이전트 프로세스가 아직 실행 중인 동안에는 작업 패널에 계속 남아 있습니다. 다시 중지하면 Claude Code가 해당 프로세스에 다시 신호를 보냅니다.

### 일시 중지 후 재개

일시 중지된 실행은 `/workflows`에서 선택한 후 `p`를 눌러 재개합니다. 중지한 실행의 경우 Claude에게 같은 스크립트로 워크플로를 다시 시작하도록 요청합니다. 중지된 실행의 에이전트가 아직 종료되지 않았다면 Claude Code는 해당 에이전트가 종료될 때까지 재시작을 거부하므로, 같은 에이전트의 두 번째 사본이 함께 실행될 수 없습니다.

#### 다시 실행되는 에이전트

Claude Code는 에이전트가 시작되는 순서대로 실행을 재생하며, 각 에이전트는 저장된 결과를 반환하거나 다시 실행됩니다.

* **완료됨**: 저장된 결과를 반환합니다. 스크립트를 편집했거나 앞선 에이전트가 다른 결과를 반환하여 프롬프트가 이전 실행과 달라진 첫 번째 에이전트는 다시 실행되며, 그 뒤의 모든 에이전트도 완료된 에이전트를 포함하여 다시 실행됩니다.

  v2.1.305 이전에는 `pipeline()` 항목이나 `parallel()` 작업이 각각 둘 이상의 에이전트를 실행한 스크립트를 편집하지 않고 다시 시작할 때도 완료된 에이전트가 다시 실행될 수 있었습니다. 새 실행에서 이러한 재실행을 막으려면 Claude Code를 업데이트하세요.
* **중지 시점에 실행 중이었음**: 처음부터 다시 시작합니다. 전체 실행을 중지해도 어떤 에이전트도 실패한 것으로 간주되지 않습니다.
* **실패함**: 다시 실행되며, 스크립트가 그 뒤에 시작하는 모든 에이전트도 완료된 에이전트를 포함하여 다시 실행됩니다. [`/workflows`](#watch-the-run)에서 에이전트 하나를 선택하고 `x`를 눌러 해당 에이전트만 중지하면 실패로 간주됩니다.

마지막 경우는 팬아웃 도중에 실패가 발생하면 이미 완료된 작업까지 다시 실행된다는 의미입니다. 스크립트가 A, B, C, D를 순서대로 시작하고 B가 실패하면, 다시 시작할 때 A는 캐시에서 반환되고 B, C, D는 다시 실행됩니다.

A, B, C, D를 시작하던 스크립트를 A, C, B, D 순서로 시작하도록 편집하면, 두 번째로 시작하는 에이전트는 이전 실행에서 B였던 자리에 이제 C가 됩니다. 다시 시작하면 A는 캐시에서 반환되고 C, B, D는 다시 실행됩니다.

#### 세션을 떠난 후 재개

워크플로 실행이 진행 중일 때 세션을 백그라운드로 보내거나 Claude Code를 종료하면 실행은 자동으로 계속되지 않습니다. 실행은 Claude가 `Workflow` 호출로 다시 시작할 때만 계속되며, 이 호출은 [저장된 결과에서 실행을 재생합니다](#which-agents-run-again).

* **세션을 백그라운드로 보냈거나 [`Move to background and exit`](https://code.claude.com/docs/ko/agent-view#from-inside-a-session)를 선택한 경우**: [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md#what-carries-over-when-you-background)을 확인했을 때 실행이 계속되지 않았다면 해당 세션에서 Claude에게 워크플로를 다시 시작하도록 요청합니다. [권한 모드](#approve-the-plan-before-it-runs)에 따라 Claude Code가 먼저 재시작 승인을 요청합니다. 세션이 agent view에서 `Needs input` 아래에 표시되면 [세션에 연결](https://code.claude.com/docs/ko/agent-view.md#attach-to-a-session)하여 승인 프롬프트에 응답합니다.
* **백그라운드 세션에서 재시작이 `nothing to resume`으로 실패한 경우**: Claude에게 워크플로를 새 실행으로 처음부터 시작하도록 요청합니다. Claude가 작업 디렉터리에 있는 스크립트처럼 `~/.claude/projects/` 외부에 있는 스크립트 파일의 경로로 실행을 시작했다면, Claude는 백그라운드 세션에서 해당 실행을 다시 시작할 수 없습니다.
* **`Exit and stop tasks`를 선택했거나 `Move to background and exit`가 제공되지 않은 경우**: 실행은 세션과 함께 중지되었으며, Claude Code는 실행의 저장된 결과를 `~/.claude/projects/` 아래 해당 세션 디렉터리에 보관합니다. 셸에서 `claude --resume`으로 세션을 재개한 다음 Claude에게 워크플로를 다시 시작하도록 요청합니다. 새로 시작한 세션에서는 Claude가 다시 시작할 이전 실행이 없으므로 워크플로를 처음부터 시작합니다.

[클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)에서는 Claude Code가 실행 결과를 세션의 대화 기록과 함께 저장하며, 이 기록은 세션의 VM이 회수된 후에도 유지됩니다. [이러한 세션을 다시 열고](https://code.claude.com/docs/ko/claude-code-on-the-web.md#environment-expired) Claude에게 워크플로를 다시 시작하도록 요청하면, 완료된 에이전트는 여전히 저장된 결과를 반환합니다.

로컬 세션과 클라우드 세션 모두에서, Claude가 이전 실행을 다시 시작할 때 Claude Code가 해당 실행의 저장된 결과를 전혀 찾을 수 없으면, 실행을 자동으로 처음부터 시작하는 대신 `nothing to resume` 오류와 함께 재시작이 실패합니다. 이 경우 Claude에게 워크플로를 새 실행으로 처음부터 시작하도록 요청하세요.

### 실행이 사용 한도에 도달한 경우

에이전트가 claude.ai [사용 한도](https://code.claude.com/docs/ko/interactive-mode.md#wait-for-a-usage-limit-to-reset)에 도달하면 해당 에이전트를 실패 처리하는 대신 실행이 일시 중지됩니다. 한도에 도달한 에이전트는 한도가 재설정될 때까지 대기하며, 새 에이전트는 시작되지 않습니다. 한도가 재설정되고 잠시 후 대기 중이던 에이전트가 다시 실행되고 실행이 자동으로 계속됩니다. Claude Code v2.1.271 이상이 필요하며, 이전 버전에서는 영향을 받은 에이전트가 실패합니다.

실행이 대기하는 동안 작업 패널의 진행 줄과 [`/workflows`](#watch-the-run) 헤더에 한도가 재설정되는 시점이 표시됩니다.

실행은 다음 조건이 모두 충족될 때만 일시 중지되며, 하나라도 충족되지 않으면 영향을 받은 에이전트가 대신 실패합니다.

* 세션이 대화형이며 claude.ai 구독으로 로그인되어 있습니다. `claude -p`를 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md)나 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md), [백그라운드 세션](https://code.claude.com/docs/ko/agent-view.md), [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 또는 [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md) 팀원 세션에서는 실행이 일시 중지되지 않습니다.
* [`autoContinueAtUsageLimit`](https://code.claude.com/docs/ko/settings-reference#autocontinueatusagelimit)가 켜져 있습니다. 이는 세션 자체가 [사용 한도가 재설정될 때까지 대기](https://code.claude.com/docs/ko/interactive-mode.md#wait-for-a-usage-limit-to-reset)하도록 하는 것과 같은 설정입니다. 대기 중에 이 설정을 끄면 대기가 종료되고 대기 중이던 에이전트가 실패합니다.
* 한도가 24시간 이내에 재설정됩니다. 주간 한도는 그보다 더 늦게 재설정될 수 있습니다.
* 실행이 이미 두 번 대기하지 않았습니다. 세 번째로 한도에 도달하면 에이전트가 실패합니다.

### 에이전트가 멈추고 다시 시작되는 경우

출력이 충분히 오랫동안 도착하지 않는 에이전트는 같은 프롬프트로 처음부터 다시 시작합니다. [`/workflows`](#watch-the-run)에서 해당 에이전트 이름에 `(retry 1)` 접미사가 붙고, 세부 정보에 `attempt 2 (stalled)`가 표시됩니다. 재시작은 자동으로 이루어지므로 별도로 조치할 필요가 없습니다.

새 시도는 멈춘 시도의 트랜스크립트 없이 시작됩니다. 멈춘 시도가 이미 변경한 파일은 변경된 상태로 유지되며, 해당 시도가 사용한 토큰은 실행의 총계에 그대로 포함됩니다. 멈춤 기간은 Claude Code가 시도를 종료하기 전에 에이전트의 출력을 기다리는 시간입니다. 에이전트가 자체 도구 호출이나 [사용 한도 재설정](#when-a-run-hits-your-usage-limit)을 기다리는 시간은 멈춤 기간에 포함되지 않습니다.

에이전트는 `r`로 요청한 재시작을 포함하여 최대 다섯 번까지 다시 시작합니다. 여섯 번째 시도도 멈추면 `agent()` 호출이 실패하며, 오류의 시작 부분에 그 이유가 표시됩니다.

* `agent stalled on all 6 attempts`: 모든 시도가 기간 전체 동안 출력 없이 지나갔습니다. 에이전트의 작업 특성상 그만큼 오래 출력이 없다면 기간을 늘리세요
* `agent lost its reply on all 6 attempts`: 모든 시도의 응답 스트림이 멈췄고 Claude Code가 대기를 포기했습니다. [스트리밍 유휴 감시기](https://code.claude.com/docs/ko/network-config.md#streaming-idle-watchdogs)가 먼저 응답을 종료했으므로 멈춤 기간을 늘려도 도움이 되지 않으며, 해당 감시기의 타임아웃은 `CLAUDE_STREAM_IDLE_TIMEOUT_MS`로 설정합니다
* `agent abandoned after 6 attempts`: 시도들이 서로 다른 방식으로 종료되었으며, 오류에 그 방식이 순서대로 나열됩니다

기간이 끝나기 전에 에이전트가 출력을 생성할 시간을 더 주려면 다음과 같이 합니다.

* **에이전트 하나**: 해당 `agent()` 호출에 밀리초 단위로 `stallMs`를 전달합니다. 예를 들어 30분이면 `agent(prompt, { stallMs: 1800000 })`입니다
* **모든 에이전트**: [`CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS`](https://code.claude.com/docs/ko/env-vars#variables)를 설정합니다. 이 값은 워크플로 외부의 서브에이전트에도 적용됩니다

실패 후 실행이 계속되는지는 스크립트가 에이전트를 호출한 방식에 따라 다릅니다.

* **[`parallel()` 또는 `pipeline()`](#what-the-saved-script-looks-like) 내부**: 에이전트의 결과 자리에 `null`이 들어간 채로 실행이 계속됩니다
* **직접 await한 경우**: 오류와 함께 실행이 종료됩니다

다시 시도하려면 Claude에게 워크플로를 다시 시작하도록 요청하세요. 다시 실행되는 항목은 [일시 중지 후 재개](#resume-after-a-pause)에서 설명합니다.

### 비용

워크플로는 많은 에이전트를 생성하므로, 한 번의 실행이 같은 작업을 대화로 처리하는 것보다 상당히 많은 토큰을 사용할 수 있습니다. 실행은 플랜의 사용량 및 속도 제한에 포함됩니다.

대규모 작업에 착수하기 전에 비용을 가늠하려면 먼저 작은 범위에서 워크플로를 실행해 보세요. 예를 들어 저장소 전체 대신 디렉터리 하나를, 광범위한 질문 대신 범위가 좁은 질문을 사용합니다. `/workflows` 보기에는 실행이 진행되는 동안 각 에이전트의 토큰 사용량이 표시되며, 언제든지 그곳에서 실행을 중지할 수 있고 대개 완료된 작업은 손실되지 않습니다. 중지된 실행에서 유지되는 항목은 [일시 중지 후 재개](#resume-after-a-pause)에서 설명합니다. 런타임의 [에이전트 상한](#behavior-and-limits)은 단일 실행이 생성할 수 있는 에이전트 수를 제한하므로, 통제를 벗어난 스크립트의 비용에도 상한이 생깁니다. 더 적은 에이전트로 실행하려면 `small` [규모 가이드라인](#set-a-size-guideline)을 선택하세요.

Claude Code는 비정상적으로 커지는 실행도 표시합니다. 워크플로가 25개를 초과하는 에이전트를 예약하거나 예상 토큰 총계가 150만 개를 넘으면, 입력 상자 아래 작업 패널의 진행 줄에 `Large workflow` 경고가 표시됩니다. 이 경고는 실행을 중지할 수 있는 [`/workflows`](#watch-the-run)로 안내합니다.

이 경고는 권고일 뿐이며 실행을 일시 중지하거나 제한하지 않습니다. 경고가 표시되는 시점은 두 가지 설정에 따라 달라집니다.

* [규모 가이드라인](#set-a-size-guideline)을 직접 선택하면 해당 가이드라인의 에이전트 수가 25개 임계값을 대체합니다. 기본 제공 기본 가이드라인에서는 임계값이 25개로 유지됩니다.
* [ultracode](#let-claude-decide-with-ultracode)가 켜진 세션에서는 경고가 표시되지 않습니다. ultracode를 켜는 것 자체가 대규모 실행에 동의하는 것이기 때문입니다.

Claude Code는 [서브에이전트에 사용하는 것과 같은 순서](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)로 각 워크플로 에이전트의 모델을 선택합니다. 스크립트가 단계에 지정한 모델은 이 순서에서 호출별 모델로 간주됩니다. 다른 방식으로 모델이 지정되지 않으면 에이전트는 세션의 모델로 실행됩니다.

모델 비용을 제어하려면 다음과 같이 합니다.

* 일상적인 작업에 주로 더 작은 모델로 전환해 사용한다면 대규모 실행 전에 `/model`을 확인합니다
* 작업을 설명할 때 가장 강력한 모델이 필요하지 않은 단계에는 더 작은 모델을 사용하도록 Claude에게 요청합니다

조직의 [`availableModels` 허용 목록](https://code.claude.com/docs/ko/model-config#restrict-model-selection)이 스크립트가 에이전트에 요청한 모델을 차단하면, 해당 에이전트는 [서브에이전트와 같은 대체 규칙](https://code.claude.com/docs/ko/sub-agents.md#choose-a-model)에 따라 대체된 모델로 실행됩니다.

### 규모 가이드라인 설정

규모 가이드라인은 Claude가 동적 워크플로를 작성할 때 목표로 삼을 에이전트 수를 알려 줍니다. Claude Code는 이 가이드라인을 상한이 아닌 조언으로 Claude에 전달하므로, 다른 규모를 요구하는 프롬프트는 여전히 이를 재정의합니다.

각 값은 다음 에이전트 수에 대응합니다.

| 값 | Claude가 목표로 하는 에이전트 수 |
| :- | :- |
| `unrestricted` | 가이드라인 없음: Claude가 작업에 맞게 워크플로 규모를 정합니다 |
| `small` | 5개 미만의 에이전트 |
| `medium` | 10개 미만의 에이전트 |
| `large` | 50개 미만의 에이전트 |

기본값은 `medium`이며, Claude Code v2.1.271 이상에서 Pro 플랜으로 로그인한 경우에는 `small`입니다. 값을 선택하기 전까지는 `/config` 행에 해당 값이 기본값으로 표시되며, 워크플로의 `Running in background` 줄에 현재 적용 중인 규모가 표시됩니다.

가이드라인을 변경하려면 `/config`에서 Dynamic workflow size 설정의 값을 선택하거나 `/config workflowSizeGuideline=small`을 실행합니다. 모든 설정 파일에서 [`workflowSizeGuideline` 키](https://code.claude.com/docs/ko/settings-reference#workflowsizeguideline)를 설정할 수도 있습니다. 이 값은 `/config`보다 우선하며, 설정 파일에서 값을 제공하는 동안 Claude Code는 `/config` 행을 숨깁니다.

변경 사항은 다음 프롬프트부터 적용됩니다. 설정과 관계없이 [런타임 에이전트 상한](#behavior-and-limits)은 계속 적용됩니다.

### 워크플로 끄기

워크플로는 CLI, Desktop 앱, IDE 확장 프로그램, `claude -p`를 사용하는 [비대화형 모드](https://code.claude.com/docs/ko/headless.md), [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)에서 사용할 수 있습니다. 모든 사용 환경에 같은 비활성화 설정이 적용됩니다.

본인에 대해 워크플로를 끄려면 다음과 같이 합니다.

* `/config`에서 Dynamic workflows를 끕니다. 세션 간에 유지됩니다.
* `~/.claude/settings.json`에 `"disableWorkflows": true`를 설정합니다. 세션 간에 유지됩니다.
* `CLAUDE_CODE_DISABLE_WORKFLOWS=1`을 설정합니다. 시작 시 읽히므로 설정한 모든 곳에 적용됩니다.

조직 전체에 대해 워크플로를 끄려면 [관리형 설정](https://code.claude.com/docs/ko/server-managed-settings.md)에 `"disableWorkflows": true`를 설정하거나 [Claude Code 관리자 설정](https://claude.ai/admin-settings/claude-code) 페이지의 토글을 사용합니다.

워크플로가 비활성화되면 다음과 같이 됩니다.

* `/workflows`, 워크플로 명령, `/workflow-authoring` 스킬을 사용할 수 없습니다
* `ultracode` 키워드가 더 이상 실행을 트리거하지 않으며, `/effort`에서 **Ultracode** 토글이 제거됩니다

이미 진행 중이던 실행은 계속됩니다.

워크플로를 끄면 [ultracode](#let-claude-decide-with-ultracode)도 사용할 수 없게 됩니다. ultracode만 단독으로 막는 관리형 설정은 없습니다. ultracode를 [사용할 수 있는](https://code.claude.com/docs/ko/model-config.md#when-ultracode-is-available) 곳이라면 어디서든 사용자가 `/effort ultracode`로 켤 수 있습니다. [effort 상한](https://code.claude.com/docs/ko/model-config.md#organization-effort-limits)은 ultracode가 켜진 세션이 실행되는 effort 수준을 낮추지만, ultracode를 끄지는 않습니다.

## 관련 리소스

* [에이전트를 병렬로 실행](https://code.claude.com/docs/ko/agents.md): 서브에이전트, 에이전트 보기, 에이전트 팀, 워크플로우 비교
* [사용자 정의 서브에이전트 만들기](https://code.claude.com/docs/ko/sub-agents.md): 워크플로우가 조율하는 워커 기본 요소
* [비용 관리](https://code.claude.com/docs/ko/costs.md): 다중 에이전트 실행이 사용량 제한에 어떻게 포함되는지
