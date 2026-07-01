> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 여러 에이전트를 에이전트 뷰로 관리하기

> 하나의 화면에서 많은 Claude Code 세션을 디스패치하고 관리합니다. 에이전트 뷰는 모든 세션이 무엇을 하고 있는지, 어떤 세션이 입력을 필요로 하는지 보여줍니다.

`claude agents`로 열 수 있는 에이전트 뷰는 모든 백그라운드 세션을 위한 하나의 화면입니다: 무엇이 실행 중인지, 무엇이 입력을 필요로 하는지, 무엇이 완료되었는지를 보여줍니다. 새로운 세션을 디스패치하고, 트랜스크립트를 스크롤하는 대신 한눈에 상태를 확인하고, 필요할 때만 개입합니다. 각 백그라운드 세션은 터미널이 연결되지 않은 상태에서도 계속 실행되는 완전한 Claude Code 대화이므로, 언제든지 열고, 답변하고, 떠날 수 있습니다.

<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-light.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=7a186c96ed47d6700d084d77e786be65" className="dark:hidden" alt="터미널의 에이전트 뷰: 헤더는 Claude Code v2.1.140, 모델, 작업 디렉토리 및 요약 개수를 표시합니다. 세션은 입력 필요, 작업 중, 완료됨으로 그룹화되며, 하단에 디스패치 입력과 키보드 힌트의 바닥글이 있습니다." width="1772" height="780" data-path="images/agent-view-light.png" />

<img src="https://mintcdn.com/claude-code/1B48Qz2Z9hac4SLG/images/agent-view-dark.png?fit=max&auto=format&n=1B48Qz2Z9hac4SLG&q=85&s=a5bed7434bae368faea3a8f023b52aa2" className="hidden dark:block" alt="터미널의 에이전트 뷰: 헤더는 Claude Code v2.1.140, 모델, 작업 디렉토리 및 요약 개수를 표시합니다. 세션은 입력 필요, 작업 중, 완료됨으로 그룹화되며, 하단에 디스패치 입력과 키보드 힌트의 바닥글이 있습니다." width="1772" height="780" data-path="images/agent-view-dark.png" />

Claude가 사용자의 감시 없이 작업할 수 있는 여러 독립적인 작업이 있을 때 에이전트 뷰를 사용합니다. 버그 수정, 풀 리퀘스트 검토, 불안정한 테스트 조사를 세 개의 행으로 디스패치하고, 다른 창에서 계속 작업하며, 행에 입력이 필요하거나 결과가 있음을 표시할 때 다시 확인합니다.

에이전트의 세션에서 더 직접적으로 작업하려면, 행에 연결하여 전체 대화에 진입합니다.

에이전트 뷰를 서브에이전트, 에이전트 팀 및 워크트리와 비교하려면 [병렬로 에이전트 실행](/ko/agents)을 참조하세요.

<Note>
  에이전트 뷰는 연구 미리보기이며 Claude Code v2.1.139 이상이 필요합니다. `claude --version`으로 버전을 확인합니다. 기능이 발전함에 따라 인터페이스와 키보드 단축키가 변경될 수 있습니다.
</Note>

이 페이지에서 다루는 내용:

* [빠른 시작](#quick-start): Claude에게 백그라운드에서 작업할 작업을 제공하고, 확인하고, 필요할 때 개입합니다
* [에이전트 뷰로 세션 모니터링](#monitor-sessions-with-agent-view), 상태 아이콘, 엿보기 및 답변, 연결, 구성 및 키보드 단축키 포함
* [에이전트 뷰에서 새로운 에이전트 디스패치](#dispatch-new-agents), 세션 내에서, 또는 셸에서
* [셸에서 세션 관리](#manage-sessions-from-the-shell)
* [백그라운드 세션이 호스팅되는 방식](#how-background-sessions-are-hosted), 감독자 프로세스에 의해

<h2 id="quick-start">
  빠른 시작
</h2>

이 연습은 핵심 에이전트 뷰 루프를 다룹니다: 작업을 디스패치하고, Claude가 작업하면서 행이 업데이트되는 것을 지켜보고, 엿보기로 확인하고 답변하고, 전체 대화를 위해 연결합니다. 디스패치한 세션은 에이전트 뷰를 닫은 후에도 계속 실행되므로, 언제든지 떠났다가 돌아올 수 있습니다.

<Steps>
  <Step title="에이전트 뷰 열기">
    셸에서 다음을 실행합니다:

    ```bash theme={null}
    claude agents
    ```

    에이전트 뷰가 하단의 입력과 세션이 시작되면서 채워지는 테이블과 함께 열립니다. 언제든지 `Esc`를 눌러 셸로 돌아갑니다. 세션은 떠나 있는 동안 계속 실행되며 다음에 에이전트 뷰를 열 때 다시 나타납니다.
  </Step>

  <Step title="세션 디스패치">
    작업을 설명하는 프롬프트를 입력하고 `Enter`를 누릅니다. 새로운 백그라운드 세션이 해당 작업에서 시작되고 작업 중인지, 입력을 기다리는지, 완료되었는지를 보여주는 행으로 나타납니다. 새로운 세션은 에이전트 뷰 헤더에 표시된 모델과 해당 디렉토리에서 `claude`를 실행할 때 얻을 수 있는 동일한 [권한 모드](#permission-mode-model-and-effort)를 사용합니다.

    여기에 입력하는 모든 프롬프트는 자신의 새로운 세션을 시작합니다. 다른 프롬프트를 입력하고 `Enter`를 누르면 첫 번째 세션에 후속 메시지를 보내는 대신 첫 번째 세션과 함께 두 번째 세션을 시작합니다. 이렇게 여러 세션을 병렬로 실행할 수 있습니다.

    각 세션은 구독 할당량을 독립적으로 사용하므로, 한 번에 많은 세션을 디스패치하기 전에 [제한사항](#limitations)을 참조하십시오.
  </Step>

  <Step title="엿보기 및 답변">
    화살표 키로 행을 선택하고 `Space`를 눌러 엿보기 패널을 엽니다. 전체 대화 기록이 아닌 세션의 가장 최근 출력 또는 기다리고 있는 질문을 표시합니다. 답변을 입력하고 `Enter`를 눌러 에이전트 뷰를 떠나지 않고 전송합니다.
  </Step>

  <Step title="연결 및 분리">
    전체 대화를 원할 때 행에서 `Enter` 또는 `→`를 눌러 연결합니다. 세션이 전체 대화형 Claude Code 세션으로 터미널을 인수합니다. 빈 프롬프트에서 `←`를 눌러 분리하고 테이블로 돌아갑니다.
  </Step>

  <Step title="기존 세션 가져오기">
    이미 열려 있는 세션을 에이전트 뷰로 이동하려면 세션 내에서 `/bg`를 실행하거나, 빈 프롬프트에서 `←`를 눌러 세션을 백그라운드로 보내고 한 단계에서 에이전트 뷰를 엽니다. 세션은 계속 실행되며 디스패치한 세션과 함께 행으로 나타납니다.
  </Step>
</Steps>

`claude agents`를 `claude` 대신 기본 진입점으로 사용할 수 있습니다: 에이전트 뷰에서 모든 작업을 디스패치하고, 전체 대화를 원할 때 연결하고, `←`를 눌러 테이블로 돌아갑니다.

<h2 id="monitor-sessions-with-agent-view">
  에이전트 뷰로 세션 모니터링
</h2>

`claude agents`를 실행하여 에이전트 뷰를 엽니다. 전체 터미널을 차지하고 상태별로 그룹화된 모든 세션을 나열하며, 고정된 세션과 입력이 필요한 세션이 맨 위에 있습니다. 각 행은 세션의 이름, 현재 활동 및 마지막 변경 이후 경과 시간을 보여줍니다.

기본적으로 목록은 모든 프로젝트에 걸쳐 시작한 모든 백그라운드 세션을 표시합니다. 한 저장소에서 작업하는 세션과 다른 worktree에서 작업하는 세션은 모두 여기에 나타나며, 에이전트 뷰를 연 디렉토리와 관계없이 표시됩니다. 목록을 한 프로젝트로 범위를 지정하려면 `--cwd`를 전달합니다:

```bash theme={null}
claude agents --cwd ~/projects/my-app
```

이는 해당 디렉토리 아래에서 시작된 세션만 표시합니다. `~/projects/my-app/.claude/worktrees/` 아래의 [worktree로 이동한](#how-file-edits-are-isolated) 세션은 여전히 `~/projects/my-app`에 속하는 것으로 간주됩니다.

다른 터미널에서 열려 있는 대화형 세션은 [백그라운드로 보낼](#from-inside-a-session) 때까지 나타나지 않습니다. [서브에이전트](/ko/sub-agents)와 [팀원](/ko/agent-teams)은 세션이 생성하는 별도의 행으로 나열되지 않습니다.

```text theme={null}
고정됨
  ✽ clawd walk cycle          Write assets/sprites/clawd-walk.png           3m

검토 준비 완료
  ∙ jump physics              Opened PR with collision fix              PR #2048  2h

입력 필요
  ✻ power-up design           needs input: double jump or wall climb?       1m

작업 중
  ✽ collision detection       Edit src/physics/CollisionSystem.ts           2m
  ✢ playtest level 3          run 12 · all checkpoints cleared           in 4m

완료됨
  ✻ title screen              result: menu, options, and credits done       9m
  ∙ sound effects             result: 14 SFX exported to assets/audio       4h
  … 6 more
```

<h3 id="read-session-state">
  세션 상태 읽기
</h3>

각 행은 세션의 상태를 나타내는 아이콘으로 시작하며, 아이콘의 색상과 애니메이션이 상태를 보여줍니다:

| 상태    | 아이콘 표시 | 의미                                  |
| :---- | :----- | :---------------------------------- |
| 작업 중  | 애니메이션  | Claude가 적극적으로 도구를 실행하거나 응답을 생성 중    |
| 입력 필요 | 노란색    | Claude가 특정 질문이나 권한 결정을 기다리는 중       |
| 유휴    | 흐릿함    | 세션이 할 일이 없으며 다음 프롬프트를 기다리는 중        |
| 완료됨   | 녹색     | 작업이 성공적으로 완료됨                       |
| 실패    | 빨간색    | 작업이 오류로 종료됨                         |
| 중지됨   | 회색     | 세션이 `Ctrl+X` 또는 `claude stop`으로 중지됨 |

별도로, 아이콘의 모양은 기본 프로세스가 실행 중인지 여부를 나타냅니다:

| 모양               | 의미                                                                  |
| :--------------- | :------------------------------------------------------------------ |
| `✻` 또는 애니메이션 `✽` | 세션 프로세스가 활성 상태이며 즉시 응답                                              |
| `∙`              | 프로세스가 종료됨. 여전히 엿보기, 답변 또는 연결할 수 있으며, Claude는 중단된 위치에서 다시 시작         |
| `✢`              | [`/loop`](/ko/scheduled-tasks) 세션이 반복 사이에 절전 중. 행은 실행 횟수와 카운트다운을 표시 |

행의 오른쪽 가장자리에 나타날 수 있는 `PR #N` 레이블은 [세션이 열은 풀 리퀘스트](#pull-request-status)이며, 상태 아이콘의 일부가 아닙니다. 세션이 둘 이상의 풀 리퀘스트를 열었을 때 레이블은 `3 PRs`와 같은 개수를 표시합니다.

터미널 탭 제목은 에이전트 뷰가 열려 있는 동안 입력 대기 중인 개수를 표시합니다: 세션이 입력이 필요할 때 `2 awaiting input · claude agents`, 필요하지 않을 때 `claude agents`.

백그라운드 세션은 계속 작동하기 위해 열린 터미널이 필요하지 않습니다. 별도의 [감독자 프로세스](#the-supervisor-process)가 실행하므로 에이전트 뷰를 닫거나, 셸을 닫거나, 새로운 대화형 세션을 시작해도 디스패치된 작업은 계속됩니다.

세션 상태는 자동 업데이트 및 감독자 재시작을 통해 디스크에 유지됩니다. 세션은 머신이 절전 상태일 때도 보존됩니다. 프로세스는 깨어날 때 재개되고 감독자는 시간 간격을 유휴로 취급하는 대신 다시 연결됩니다. 종료하면 여전히 실행 중인 세션이 중지됩니다. 복구 방법은 [종료 후 세션이 실패로 표시됨](#sessions-show-as-failed-after-shutdown)을 참조하세요.

<h3 id="row-summaries">
  행 요약
</h3>

각 행의 한 줄 요약은 [Haiku 클래스 모델](/ko/model-config)에 의해 생성되므로 행은 세션이 무엇을 하고 있는지, 무엇이 필요한지, 또는 트랜스크립트를 열지 않고도 무엇을 생성했는지 알려줄 수 있습니다. 세션이 적극적으로 작동하는 동안 요약은 최대 15초마다 한 번, 그리고 각 턴이 끝날 때 한 번 새로고침됩니다.

세션이 서브에이전트, 백그라운드 셸 명령 또는 모니터와 같은 두 개 이상의 병렬 작업 항목을 실행 중일 때, `2/5`와 같은 `done/total` 개수가 요약 텍스트 앞에 나타납니다.

각 새로고침은 일반 제공자를 통한 하나의 짧은 Haiku 클래스 요청이며, 세션 자체와 동일한 [데이터 사용 약관](/ko/data-usage)에 따라 청구되고 처리됩니다. Bedrock, Vertex AI, Microsoft Foundry 및 사용자 정의 게이트웨이와 같은 타사 제공자에서는 Haiku 모델이 구성되지 않은 경우 요청이 세션의 주 모델로 폴백됩니다. 이러한 제공자에서 이 요약에 대한 모델을 선택하려면 [`ANTHROPIC_DEFAULT_HAIKU_MODEL`](/ko/model-config#environment-variables)을 설정합니다.

<h3 id="pull-request-status">
  풀 리퀘스트 상태
</h3>

세션이 풀 리퀘스트를 열면 `PR #1234` 레이블이 행의 오른쪽 가장자리에 나타나며, 하이퍼링크를 지원하는 터미널에서 풀 리퀘스트에 연결됩니다. 세션에 후속 조치를 보낼 때 레이블이 유지되므로 행이 라이브 진행 상황으로 되돌아가는 동안 풀 리퀘스트가 표시된 상태로 유지됩니다.

세션이 둘 이상의 풀 리퀘스트를 열었을 때 레이블은 `3 PRs`와 같은 개수를 표시하며, 가장 주의가 필요한 열린 풀 리퀘스트로 색상이 지정됩니다. [엿보기 패널](#peek-and-reply)을 열어 모두 확인합니다.

풀 리퀘스트 번호는 상태에 따라 색상이 지정됩니다:

| 색상  | 풀 리퀘스트 상태               |
| :-- | :---------------------- |
| 노란색 | 검사 또는 검토 대기 중, 또는 검사 실패 |
| 녹색  | 검사 통과 및 검토 차단 없음        |
| 보라색 | 병합됨                     |
| 회색  | 초안 또는 닫힘                |

대부분의 작업에서 이 열은 결과를 수집하는 방법입니다: 풀 리퀘스트 번호가 녹색으로 변하면 풀 리퀘스트를 검토하고 병합합니다.

<h3 id="peek-and-reply">
  엿보기 및 답변
</h3>

선택된 행에서 `Space`를 눌러 엿보기 패널을 엽니다. 세션이 필요로 하는 것, 최근 출력 및 열린 풀 리퀘스트를 보여줍니다. 대부분의 경우 이것으로 충분하며 전체 트랜스크립트를 열 필요가 없습니다.

세션이 병렬 작업 항목을 실행 중일 때, 패널은 또한 가장 오래 실행 중인 항목의 이름과 실행 시간을 표시하므로 연결하지 않고도 세션이 기다리는 것을 볼 수 있습니다.

엿보기 패널에 답변을 입력하고 `Enter`를 눌러 해당 세션으로 전송합니다. 세션이 객관식 질문을 하는 경우 엿보기 패널은 옵션을 표시하고 숫자 키를 눌러 하나를 선택할 수 있습니다. 다른 차단된 세션의 경우 `Tab`을 눌러 입력을 편집하기 전에 제안된 답변으로 채웁니다. 답변 앞에 `!`를 붙여 Bash 명령을 대신 전송합니다.

[음성 받아쓰기](/ko/voice-dictation)가 활성화된 경우, 답변 입력에 포커스가 있는 동안 푸시-투-톡 키를 누르거나 탭하여 입력하는 대신 답변을 받아쓸 수 있습니다. 에이전트 뷰 하단의 디스패치 입력에서도 동일하게 작동합니다.

`↑` 및 `↓`를 사용하여 패널을 닫지 않고 인접한 세션을 엿보거나 `→`를 눌러 연결합니다.

<h3 id="attach-to-a-session">
  세션에 연결
</h3>

선택된 행에서 `Enter` 또는 `→`를 눌러 연결합니다. 에이전트 뷰는 전체 대화형 세션으로 대체됩니다. 연결하면 Claude는 떠나 있는 동안 발생한 일에 대한 짧은 요약을 게시합니다.

연결된 동안 세션은 다른 Claude Code 세션처럼 작동합니다: 모든 [명령](/ko/commands), 키보드 단축키 및 기능이 작동합니다.

연결된 세션은 `tui` 설정과 관계없이 항상 [전체 화면 모드](/ko/fullscreen)로 렌더링됩니다. 백그라운드 세션에는 추가할 터미널 스크롤백이 없기 때문입니다. `PgUp`, `PgDn` 또는 마우스 휠로 스크롤하고, `Ctrl+O`를 눌러 트랜스크립트 모드로 전환합니다. 터미널의 기본 스크롤 및 tmux 복사 모드는 현재 뷰포트만 표시하며, 이는 전체 화면 애플리케이션을 실행할 때와 동일합니다.

빈 프롬프트에서 `←`를 눌러 분리하고 에이전트 뷰로 돌아갑니다. 대화 상자가 포커스를 가지고 있고 `←`에 응답하지 않으면 `Ctrl+Z`를 눌러 즉시 분리합니다.

`Ctrl+C`는 연결된 동안 표준 인터럽트 동작을 유지합니다: 분리하는 대신 실행 중인 응답 또는 `!` 셸 명령을 취소합니다. 빈 프롬프트에서 `Ctrl+C`를 두 번 누르면 분리되며, 다른 세션에서와 동일합니다.

분리는 백그라운드 세션을 중지하지 않습니다: `←`, `Ctrl+Z`, `/exit`, 그리고 이중 `Ctrl+C` 또는 이중 `Ctrl+D`는 모두 실행 상태로 둡니다. 세션 내에서 세션을 종료하려면 `/stop`을 실행합니다.

빈 프롬프트에서 `←`를 누르면 에이전트 뷰에서 연결한 세션뿐만 아니라 모든 Claude Code 세션에서 작동합니다. 현재 세션을 백그라운드로 보내고 해당 행이 선택된 상태로 에이전트 뷰를 열어 터미널을 떠나지 않고 세션을 전환할 수 있습니다. 행은 대화 기록이 없는 새로운 세션에서도 생성되므로 `→`는 이를 반환합니다. 해당 행이 유일한 경우 에이전트 뷰는 아래에 온보딩 힌트를 표시합니다. `/config`에서 이 단축키를 끌 수 있습니다(`leftArrowOpensAgents` 설정).

<h3 id="organize-the-list">
  목록 구성
</h3>

에이전트 뷰는 세션을 그룹화하여 입력이 필요한 세션이 맨 위에 있고, `검토 준비 완료`와 `입력 필요`가 `작업 중`과 `완료됨` 위에 있습니다. 이 그룹 이름은 [상태](#read-session-state) 위의 일대일 매핑이 아닙니다: 세션이 열린 풀 리퀘스트를 가지면 `검토 준비 완료`로 이동하고, `완료됨`은 완료되고, 실패하고, 중지된 세션을 함께 수집합니다.

`Ctrl+S`를 눌러 대신 디렉토리별로 그룹화로 전환합니다. 선택 사항은 실행 간에 저장됩니다.

그룹 내에서:

* `Ctrl+T`를 눌러 세션을 맨 위에 고정하고 [유휴 상태일 때 프로세스를 계속 실행](#the-supervisor-process)합니다
* `Shift+↑` 또는 `Shift+↓`를 눌러 세션 순서 변경
* `Ctrl+R`을 눌러 세션 이름 바꾸기
* 그룹 헤더에서 `Enter`를 눌러 축소

세션을 목록에서 제거하려면 `Ctrl+X`를 눌러 중지하고 2초 이내에 `Ctrl+X`를 다시 눌러 삭제합니다. 그룹 헤더에서 `Ctrl+X`를 누르면 확인 후 해당 그룹의 모든 세션이 삭제됩니다.

삭제하면 세션이 에이전트 뷰에서 제거됩니다. Claude가 세션에 대해 [worktree를 생성](#how-file-edits-are-isolated)한 경우 삭제하면 커밋되지 않은 변경 사항을 포함한 해당 worktree도 제거되므로 유지하려는 작업을 먼저 푸시하거나 커밋합니다. 직접 생성하고 세션을 시작한 worktree는 제자리에 남겨집니다. 대화 트랜스크립트는 로컬 머신에 남아 있으며 `claude --resume`을 통해 계속 사용할 수 있습니다.

오래된 완료된 세션은 목록을 짧게 유지하기 위해 `… N more` 행으로 접힙니다. 실패 및 열린 풀 리퀘스트가 있는 세션은 항상 표시됩니다. `완료됨` 그룹은 라이브 그룹 이후 남은 수직 공간을 채우며, 짧은 터미널에서 헤더는 단일 요약 라인으로 압축되므로 작업 중이거나 입력이 필요한 세션이 표시된 상태로 유지됩니다.

<h3 id="filter-sessions">
  세션 필터링
</h3>

디스패치 입력에 입력하여 디스패치 대신 필터링합니다:

| 필터                    | 표시                                                             |
| :-------------------- | :------------------------------------------------------------- |
| `a:<name>`            | 명명된 에이전트를 실행하는 세션                                              |
| `s:<state>`           | 주어진 상태의 세션, 예: `s:working`. 또한 `s:blocked`를 수락하여 입력을 기다리는 모든 것 |
| `#<number>` 또는 PR URL | 해당 풀 리퀘스트에서 작업하는 세션                                            |
| 다른 URL                | 첫 번째 프롬프트에 해당 URL이 포함된 세션                                      |

<h3 id="keyboard-shortcuts">
  키보드 단축키
</h3>

에이전트 뷰에서 `?`를 눌러 모든 단축키를 확인합니다. 아래 표는 이를 요약합니다.

| 단축키                   | 작업                                    |
| :-------------------- | :------------------------------------ |
| `↑` / `↓`             | 행 간 이동                                |
| `Enter`               | 선택된 세션에 연결하거나, 입력에 텍스트가 있으면 디스패치      |
| `Space`               | 선택된 세션의 엿보기 패널 열기 또는 닫기               |
| `Shift+Enter`         | 디스패치하고 즉시 연결                          |
| `→`                   | 선택된 세션에 연결                            |
| `Alt+1`..`Alt+9`      | 포커스된 세션의 디렉토리에서 세션 1–9에 연결            |
| `Tab`                 | 빈 입력에서 모든 서브에이전트 검색. 그 외에는 강조된 제안 적용  |
| `Ctrl+S`              | 상태와 디렉토리 간 그룹화 전환                     |
| `Ctrl+T`              | 선택된 세션 고정 또는 고정 해제                    |
| `Ctrl+R`              | 선택된 세션 이름 바꾸기                         |
| `Ctrl+G`              | `$VISUAL` 또는 `$EDITOR`에서 디스패치 프롬프트 열기 |
| `Ctrl+X`              | 세션 중지; 2초 이내에 다시 눌러 삭제                |
| `Shift+↑` / `Shift+↓` | 선택된 세션 순서 변경                          |
| `Esc`                 | 엿보기 패널 닫기, 입력 지우기 또는 종료               |
| `Ctrl+C`              | 입력 지우기; 두 번 눌러 종료                     |
| `?`                   | 모든 단축키 표시                             |

<h2 id="dispatch-new-agents">
  새로운 에이전트 디스패치
</h2>

에이전트 뷰에서 새로운 백그라운드 세션을 디스패치하거나, 기존 대화형 세션을 백그라운드로 보내거나, 셸에서 직접 시작할 수 있습니다.

<h3 id="from-agent-view">
  에이전트 뷰에서
</h3>

에이전트 뷰 하단의 입력에 프롬프트를 입력하고 `Enter`를 눌러 새로운 백그라운드 세션을 시작합니다. 세션은 프롬프트에서 자동으로 이름이 지정됩니다. 나중에 `Ctrl+R`로 이름을 바꿀 수 있습니다.

프롬프트에 이미지를 붙여넣어 작업에 스크린샷이나 다이어그램을 포함합니다.

프롬프트의 일부를 접두사로 붙이거나 언급하여 세션이 시작되는 방식을 제어합니다:

| 입력                        | 효과                                                                                         |
| :------------------------ | :----------------------------------------------------------------------------------------- |
| `<agent-name> <prompt>`   | 첫 번째 단어가 사용자 정의 [서브에이전트](/ko/sub-agents) 이름과 일치하면 해당 서브에이전트가 프론트매터의 구성으로 세션의 주 에이전트로 실행됩니다 |
| `@<agent-name>`           | 프롬프트의 어디든지 사용자 정의 서브에이전트를 언급하여 주 에이전트로 실행합니다                                               |
| `@<repo>`                 | 에이전트 뷰를 연 디렉토리 아래의 저장소를 언급하여 세션을 거기서 실행합니다                                                 |
| `/<command>`              | [스킬](/ko/skills) 및 [명령](/ko/commands)을 프롬프트로 디스패치하도록 제안합니다                                 |
| `! <command>`             | Claude 세션을 시작하는 대신 백그라운드 작업으로 셸 명령을 실행합니다. 작업은 연결하고, 감시하고, 분리할 수 있는 행으로 나타납니다              |
| `#<number>` 또는 풀 리퀘스트 URL | 세션이 이미 해당 PR에서 작업 중이면 디스패치 대신 선택합니다                                                        |
| `Shift+Enter`             | 디스패치하고 즉시 새 세션에 연결합니다                                                                      |

에이전트 뷰 자체에서만 실행되는 작은 명령 집합이 있습니다: `/exit` 및 `/quit`는 에이전트 뷰를 닫고, `/logout`은 로그아웃하며, `/model`은 [디스패치 모델](#set-the-model)을 설정합니다. 스킬, 사용자 정의 명령 및 `/init`과 같은 프롬프트 확장 기본 제공 명령은 새로운 백그라운드 세션으로 첫 번째 프롬프트로 전송됩니다. 다른 기본 제공 명령은 대신 `세션에 연결하여 실행` 힌트를 표시합니다.

반복되는 작업을 [스킬](/ko/skills)로 패키징하면 프롬프트를 다시 입력하지 않고 에이전트 뷰에서 동일한 워크플로우를 여러 번 시작할 수 있습니다.

동일한 `@name`이 서브에이전트와 형제 저장소 모두와 일치하면 서브에이전트가 우선합니다. 첫 단어 일치도 적용되므로 서브에이전트 이름 중 하나로 시작하는 프롬프트는 해당 서브에이전트를 디스패치합니다. 명시적으로 하려면 `@` 형식을 사용하거나, 일치를 피하기 위해 다른 단어로 프롬프트를 시작합니다.

<h4 id="dispatch-to-a-specific-directory">
  특정 디렉토리로 디스패치
</h4>

새로운 세션은 에이전트 뷰를 연 디렉토리에서 실행됩니다. 다른 디렉토리를 대상으로 하려면:

* 해당 디렉토리에서 `claude agents`를 엽니다.
* 여러 저장소를 보유한 상위 디렉토리에서 `claude agents`를 열고 프롬프트에서 `@<repo>`로 하나를 언급하여 세션을 거기서 실행합니다.
* 셸에서 디렉토리로 `cd`하고 `claude --bg "<prompt>"`를 실행합니다.

에이전트 뷰가 디렉토리별로 그룹화되면 강조된 행의 디렉토리가 디스패치 대상이 되므로 그룹으로 스크롤하고 경로를 다시 입력하지 않고 디스패치할 수 있습니다.

<h3 id="from-inside-a-session">
  세션 내에서
</h3>

`/background` 또는 별칭 `/bg`를 실행하여 현재 대화를 백그라운드 세션으로 이동합니다. `/bg run the test suite and fix any failures`와 같은 프롬프트를 전달하여 먼저 하나의 추가 명령을 보냅니다. Claude가 응답 중일 때 `/bg`를 실행하면 응답이 백그라운드 세션에서 계속됩니다.

대화형 세션에서 백그라운드로 이동하면 저장된 대화에서 재개되는 새로운 프로세스가 시작되며, 진행 중인 작업이 이동됩니다: 실행 중인 백그라운드 셸 명령, 백그라운드 서브에이전트, 동적 워크플로우 및 [`/loop`](/ko/scheduled-tasks)로 생성한 예약된 작업이 백그라운드 세션으로 이동하고 계속 실행됩니다. 서브에이전트는 시작한 모든 것과 함께 이동하므로 Windows를 포함한 모든 작업이 이동할 수 있을 때만 이동합니다. 진행 중인 작업을 이동하는 대신 중지하려면 [`CLAUDE_DISABLE_ADOPT=1`](/ko/env-vars#variables) 환경 변수를 설정합니다. Claude Code는 백그라운드로 이동하기 전에 확인을 요청합니다.

이동할 수 없는 작업(예: 실행 중인 [모니터](/ko/tools-reference#monitor-tool))은 중지됩니다. 모니터를 소유한 백그라운드 서브에이전트는 함께 중지됩니다. 이러한 작업이 실행 중일 때 Claude Code는 `Background this session?` 대화 상자를 표시하므로 중지되기 전에 확인할 수 있습니다.

백그라운드에 있으면 세션은 새로운 서브에이전트, 모니터 및 백그라운드 명령을 시작할 수 있으며, 이들은 나중의 분리 및 재연결 전체에서 계속 실행됩니다.

원본 실행의 구성 플래그는 백그라운드로 이동된 세션으로 전달되므로 MCP 서버, 설정 및 폴백 모델이 계속 적용됩니다:

* `--mcp-config` 및 `--strict-mcp-config`
* `--settings`
* `--add-dir`
* `--plugin-dir`
* `--fallback-model`
* `--allow-dangerously-skip-permissions`

[`/add-dir`](/ko/permissions#additional-directories-grant-file-access-not-configuration)로 세션 중에 추가한 디렉토리도 전달됩니다.

`--allow-dangerously-skip-permissions`를 전달하면 백그라운드 세션에서 `bypassPermissions`에 도달할 수 있지만 새로운 것을 부여하지는 않습니다. 이 모드는 여전히 [권한 모드, 모델 및 노력](#permission-mode-model-and-effort)에 설명된 동일한 일회성 대화형 수락이 필요합니다.

<h3 id="from-your-shell">
  셸에서
</h3>

`--bg` 또는 긴 형식 `--background`를 전달하여 백그라운드로 직접 이동하는 세션을 시작합니다:

```bash theme={null}
claude --bg "investigate the flaky SettingsChangeDetector test"
```

특정 서브에이전트를 세션의 주 에이전트로 실행하려면 `--bg`를 `--agent`와 결합합니다:

```bash theme={null}
claude --agent code-reviewer --bg "address review comments on PR 1234"
```

`--name`을 전달하여 자동 생성된 이름 대신 에이전트 뷰에서 세션의 표시 이름을 설정합니다:

```bash theme={null}
claude --bg --name "flaky-test-fix" "investigate the flaky SettingsChangeDetector test"
```

백그라운드로 보낸 후 Claude는 세션의 짧은 ID와 관리 명령을 인쇄합니다. `--name`을 전달하면 짧은 ID 뒤에 이름이 나타납니다:

```text theme={null}
backgrounded · 7c5dcf5d · flaky-test-fix
  claude agents             list sessions
  claude attach 7c5dcf5d    open in this terminal
  claude logs 7c5dcf5d      show recent output
  claude stop 7c5dcf5d      stop this session
```

<h4 id="run-a-shell-command">
  셸 명령 실행
</h4>

에이전트 뷰 디스패치 입력의 첫 번째 문자로 `!`를 입력하여 Claude 세션 대신 백그라운드 작업으로 셸 명령을 실행합니다. `!`는 접두사로 표시되며 그 뒤에 입력하는 모든 것이 명령입니다. 다음 예제는 에이전트 뷰 입력 상자에서 `pytest -x`를 디스패치합니다:

```text theme={null}
! pytest -x
```

`Enter`를 눌러 작업을 시작합니다. 동일한 작업을 셸에서 `--exec`로 직접 실행할 수도 있습니다:

```bash theme={null}
claude --bg --exec 'pytest -x'
```

명령은 PTY 기반 작업으로 실행되며 에이전트 뷰에 행으로 나타나며, 가장 최근의 출력 라인이 상태입니다. 셸 작업은 Claude 대신 명령을 실행하므로 모델이 호출되지 않으며 출력이 세션으로 전송되지 않습니다.

출력을 보려면 행에 연결하고, `Space`를 눌러 연결하지 않고 엿보거나, 셸에서 `claude logs <id>`를 실행합니다. 캡처된 출력은 메모리에 유지되며 디스크에 기록되지 않습니다. 행과 출력은 명령이 종료된 후 약 5분 후에 자동으로 정리되므로 결과가 필요하면 그 전에 읽습니다.

<h3 id="how-file-edits-are-isolated">
  파일 편집이 격리되는 방식
</h3>

에이전트 뷰, `/bg` 또는 `claude --bg`에서 시작된 모든 백그라운드 세션은 작업 디렉토리에서 시작됩니다. 파일을 편집하기 전에 Claude는 세션을 `.claude/worktrees/` 아래의 격리된 [git worktree](/ko/worktrees)로 이동하므로 병렬 세션은 동일한 체크아웃을 읽을 수 있지만 각각은 자신의 것에 씁니다.

Claude는 다음의 경우 worktree를 건너뜁니다:

* 세션이 이미 연결된 git worktree 내부에 있으며, Claude가 `.claude/worktrees/` 아래에 생성했거나 다른 곳에서 `git worktree add`로 생성했는지 여부
* 작업 디렉토리가 git 저장소가 아니고 [`WorktreeCreate` 훅](/ko/hooks#worktreecreate)이 구성되지 않음
* 쓰기가 작업 디렉토리 외부

git worktree가 비실용적인 저장소에 대해 worktree 격리를 끄려면 [`worktree.bgIsolation`](/ko/settings#worktree-settings)을 `"none"`으로 설정합니다. 백그라운드 세션은 먼저 worktree로 이동하지 않고 작업 복사본을 직접 편집합니다. 프로젝트의 `.claude/settings.json`에 설정을 추가합니다:

```json theme={null}
{
  "worktree": {
    "bgIsolation": "none"
  }
}
```

git 저장소 외부에서 세션은 작업 디렉토리에 직접 쓰며 서로 격리되지 않으므로 동일한 파일을 편집하는 병렬 세션을 디스패치하지 않도록 합니다. 다른 버전 제어 시스템을 사용하는 경우 [`WorktreeCreate` 훅](/ko/worktrees#non-git-version-control)을 구성하면 Claude는 git에 대해 수행하는 것과 동일한 방식으로 편집을 격리합니다.

에이전트 뷰에서 세션을 삭제하면(`Ctrl+X` 두 번) Claude가 생성한 worktree가 제거되며, 커밋되지 않은 변경 사항도 포함되므로 유지하려는 변경 사항을 먼저 병합하거나 푸시합니다. 셸에서 [`claude rm`](#manage-sessions-from-the-shell)으로 삭제하면 커밋되지 않은 변경 사항이 있는 worktree를 유지하고 경로를 인쇄하므로 직접 정리할 수 있습니다. 직접 생성한 worktree이고 세션을 시작한 경우 어느 쪽이든 그대로 유지됩니다.

세션의 worktree 경로를 찾으려면 세션을 엿보거나 연결하고 작업 디렉토리를 확인합니다.

백그라운드 세션이 생성하는 [서브에이전트](/ko/sub-agents)는 세션의 작업 디렉토리를 상속하므로 파일 편집은 세션의 worktree가 아닌 작업 복사본에 저장됩니다. 서브에이전트에 자신의 별도 worktree를 제공하려면 프론트매터에서 [`isolation: worktree`](/ko/sub-agents#supported-frontmatter-fields)를 설정하거나 생성할 때 `isolation: "worktree"`를 전달합니다.

<h3 id="set-the-model">
  모델 설정
</h3>

에이전트 뷰 헤더에 표시된 모델 이름은 디스패치 기본값입니다. 입력에서 시작하는 새로운 세션은 이 모델을 사용하며, 이는 사용자 설정의 [`model` 설정](/ko/settings#available-settings)에서 제공됩니다. [`/model` 선택기](/ko/model-config)에서 모델을 선택하여 설정하거나 설정을 직접 편집합니다.

전체 에이전트 뷰 세션에 대해 이를 재정의하려면 에이전트 뷰를 열 때 `--model`을 전달합니다. [권한 모드, 모델 및 노력](#permission-mode-model-and-effort)을 참조하십시오.

에이전트 뷰 내에서 디스패치 기본값을 변경하려면 디스패치 입력에서 `/model` 뒤에 모델 이름을 입력하고 `Enter`를 누릅니다. 헤더는 `(session)` 마커와 함께 해당 모델을 표시하도록 업데이트되며, 그 후 디스패치하는 세션은 이를 사용합니다. `/model default`를 입력하여 재정의를 지우고 디스패치 기본값으로 돌아갑니다. 이 재정의는 현재 `claude agents` 실행의 나머지 동안 지속되며, 설정 파일에 쓰지 않습니다. 다음 예제는 Opus에서 한 세션을 디스패치하고 Sonnet에서 다음 세션을 디스패치합니다:

```text theme={null}
/model opus
refactor auth
/model sonnet
run the test suite
```

각 백그라운드 세션은 다른 모델에서 실행될 수 있습니다. 한 세션에 대해 이를 재정의하려면:

* 셸에서 `claude --bg`와 함께 `--model`을 전달합니다.
* 실행 중인 세션에 연결하고 `/model`을 열고 모델에서 `s`를 눌러 해당 세션에만 전환합니다. 세션이 다시 생성되면 변경 사항이 유지됩니다.
* 프론트매터가 `model` 필드를 설정하는 [서브에이전트](/ko/sub-agents)를 디스패치합니다.

<h3 id="permission-mode-model-and-effort">
  권한 모드, 모델 및 노력
</h3>

백그라운드 세션은 실행되는 디렉토리에서 [설정](/ko/settings)을 읽으며, 마치 거기서 `claude`를 시작한 것처럼 동일합니다. 여기에는 프로젝트 설정의 [`env` 값](/ko/settings#available-settings)이 포함되므로 거기에 설정된 `ANTHROPIC_MODEL` 또는 공급자 변수가 해당 디렉토리의 백그라운드 세션에 적용됩니다.

`CLAUDE_CODE_USE_BEDROCK` 또는 `CLAUDE_CODE_USE_VERTEX`와 같은 클라우드 공급자 선택 및 `ANTHROPIC_DEFAULT_*_MODEL` 별칭은 세션을 디스패치한 셸을 따릅니다. `ANTHROPIC_BASE_URL` 및 쌍을 이루는 `ANTHROPIC_AUTH_TOKEN`과 같은 게이트웨이 엔드포인트 변수는 따르지 않습니다. 백그라운드 세션이 공급자 설정 및 자격 증명을 소싱하는 방법에 대해서는 [감독자 프로세스](#the-supervisor-process)를 참조하십시오.

[권한 모드](/ko/permissions)는 세션을 시작한 방식에 따라 달라집니다. `/bg` 또는 `←`로 기존 세션을 백그라운드로 이동하면 현재 권한 모드가 유지되므로 `acceptEdits` 또는 `auto`로 전환한 세션은 분리 후에도 해당 모드에 유지됩니다. 에이전트 뷰 입력에서 디스패치하거나 셸에서 `claude --bg`를 실행하면 해당 디렉토리의 설정에서 `defaultMode`를 사용하거나 디스패치된 [서브에이전트의 프론트매터](/ko/sub-agents#supported-frontmatter-fields)에서 `permissionMode`를 사용합니다.

권한 모드, 모델 및 노력은 백그라운드 세션이 시작된 방식과 함께 [구성 플래그](#from-inside-a-session)와 함께 감독자가 나중에 [세션의 프로세스를 중지하고 다시 시작](#the-supervisor-process)할 때 유지됩니다. `claude --bg --dangerously-skip-permissions` 또는 `claude --bg --permission-mode bypassPermissions`로 실행한 세션은 디렉토리의 `defaultMode`로 폴백하는 대신 해당 재시작 후 `bypassPermissions`에 유지되며, `/model` 또는 `/effort`로 세션 중에 변경한 모델 또는 노력은 유지됩니다.

에이전트 뷰를 열 때 `--permission-mode`, `--model`, `--effort` 또는 `--agent` 중 하나를 전달하여 에이전트 뷰에서 디스패치하는 모든 세션에 대한 기본값을 설정합니다:

```bash theme={null}
claude agents --permission-mode plan --model opus --effort high
```

`--agent`는 디스패치 프롬프트가 `@name` 또는 첫 번째 단어로 이름을 지정하지 않을 때 사용되는 [서브에이전트](/ko/sub-agents)를 설정합니다. 설정된 경우 [`agent` 설정](/ko/settings#available-settings)으로 기본값이 지정되며, 그렇지 않으면 기본 제공 catch-all `claude` 에이전트입니다. 디스패치 입력에서 서브에이전트의 이름을 지정하면 둘 다 재정의됩니다.

`claude agents`는 또한 `--dangerously-skip-permissions`를 `--permission-mode bypassPermissions`의 약자로 허용하며, `--allow-dangerously-skip-permissions`를 사용하여 각 디스패치된 세션의 `Shift+Tab` 사이클에서 `bypassPermissions`를 사용 가능하게 만들 수 있습니다. 둘 다 [최상위 CLI 플래그](/ko/cli-reference)와 일치합니다.

활성 기본값은 디스패치 입력 아래의 바닥글에 나타납니다.

이러한 플래그가 없으면 세션은 해당 디렉토리의 설정에서 `defaultMode`를 사용하거나 디스패치된 [서브에이전트의 프론트매터](/ko/sub-agents#supported-frontmatter-fields)에서 `permissionMode`를 사용하며, 에이전트 뷰 헤더에 표시된 모델을 사용합니다.

`bypassPermissions` 또는 `auto`를 사용하는 것은 대화형으로 한 번 실행하여 해당 모드를 수락할 때까지 거부됩니다. 이러한 모드는 감시하지 않는 세션이 승인 없이 작동하도록 허용하기 때문입니다. 이는 `claude agents`에 모드를 전달하든 `claude --bg --permission-mode`에 전달하든 동일하게 적용됩니다. `--allow-dangerously-skip-permissions`를 전달하면 동일한 면책 조항을 표시하고, 수락하면 `bypassPermissions`를 해당 세션의 `Shift+Tab` 사이클에서 사용 가능하게 만듭니다.

<h3 id="settings-plugins-and-mcp-servers">
  설정, 플러그인 및 MCP 서버
</h3>

에이전트 뷰는 설정, 플러그인, MCP 서버 및 추가 디렉토리를 로드하기 위해 `claude`와 동일한 구성 플래그를 허용합니다. 각 플래그는 에이전트 뷰 자체에 적용되며 디스패치하는 모든 세션에 전달되므로 이러한 방식으로 로드하는 플러그인 또는 MCP 서버는 해당 세션에서도 사용 가능합니다.

| 플래그                                                                                              | 효과                                          |
| :----------------------------------------------------------------------------------------------- | :------------------------------------------ |
| [`--settings <file-or-json>`](/ko/settings)                                                      | 에이전트 뷰 및 디스패치된 세션에 대한 설정 재정의                |
| [`--add-dir <path>`](/ko/permissions#additional-directories-grant-file-access-not-configuration) | 추가 디렉토리에 파일 액세스 권한 부여                       |
| [`--plugin-dir <path>`](/ko/plugins)                                                             | 로컬 디렉토리에서 플러그인 로드                           |
| [`--mcp-config <file-or-json>`](/ko/mcp)                                                         | 구성 파일 또는 JSON 문자열에서 MCP 서버 로드               |
| `--strict-mcp-config`                                                                            | `--mcp-config`에서만 MCP 서버를 사용하고 다른 MCP 구성 무시 |

`--add-dir`, `--plugin-dir` 또는 `--mcp-config`를 값당 한 번씩 반복합니다. `--add-dir a b c`와 같은 공백으로 구분된 형식은 `claude agents`에서 지원되지 않습니다.

다음 예제는 설정 재정의 및 하나의 추가 디렉토리로 에이전트 뷰를 엽니다:

```bash theme={null}
claude agents --settings ./ci-settings.json --add-dir ../shared-lib
```

<h2 id="manage-sessions-from-the-shell">
  셸에서 세션 관리
</h2>

모든 백그라운드 세션에는 셸에서 사용할 수 있는 짧은 ID가 있습니다. ID는 `claude --bg`로 세션을 시작할 때 출력되며, 각 세션의 ID는 `~/.claude/jobs/` 아래의 디렉터리 이름입니다. 이 명령은 스크립팅이나 에이전트 뷰를 열고 싶지 않을 때 유용합니다.

| 명령                           | 목적                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| :--------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `claude agents`              | 에이전트 뷰 열기                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `claude agents --cwd <path>` | `<path>` 아래에서 시작된 세션으로 범위가 지정된 에이전트 뷰 열기                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `claude agents --json`       | 활성 세션을 JSON 배열로 인쇄하고 종료합니다. 모든 라이브 세션과 프로세스가 종료되었어도 여전히 작동 중이거나 차단된 백그라운드 세션이 포함됩니다. 완료된 백그라운드 세션도 포함하려면 `--all`을 추가합니다. 각 항목에는 `cwd`, `kind`, `startedAt`이 있습니다. 백그라운드 항목에는 `claude attach`/`logs`/`stop`에서 사용 가능한 `id`와 `state`도 있습니다. `state`는 `working`, `blocked`, `done`, `failed`, `stopped` 중 하나입니다. `pid`와 `status`는 프로세스가 활성 상태일 때만 표시되며, `status`가 `waiting`일 때는 `waitingFor`가 표시되어 `permission prompt` 또는 `input needed`와 같이 세션이 차단된 이유를 나타냅니다. `sessionId`와 `name`은 설정된 경우 표시됩니다. `--cwd <path>`와 함께 사용하여 필터링 |
| `claude attach <id>`         | 이 터미널에서 세션에 연결                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `claude logs <id>`           | 세션의 최근 출력 인쇄                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `claude stop <id>`           | 세션 중지. `claude kill`도 허용                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `claude respawn <id>`        | 세션을 다시 시작하고, 실행 중이거나 중지된 상태에서 대화를 유지합니다. 예를 들어 업데이트된 Claude Code 바이너리를 선택하기 위해                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `claude respawn --all`       | 모든 실행 중인 세션을 다시 시작합니다. 예를 들어 모든 세션을 한 번에 업데이트된 Claude Code 바이너리로 이동하기 위해                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `claude rm <id>`             | 세션을 목록에서 제거합니다. 커밋되지 않은 변경 사항이 없으면 세션을 위해 Claude가 생성한 worktree를 제거합니다. 그렇지 않으면 정리할 수 있도록 worktree 경로를 인쇄합니다. 직접 생성한 worktree는 그대로 둡니다. 대화 기록은 로컬 머신에 남아 있으며 `claude --resume`을 통해 계속 사용할 수 있습니다                                                                                                                                                                                                                                                                                                                            |
| `claude daemon status`       | [감독자](#the-supervisor-process)의 상태, 버전, 소켓 디렉터리 및 워커 수 인쇄                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `claude daemon stop --any`   | 감독자 프로세스와 이를 호스팅하는 백그라운드 세션을 중지합니다. `--keep-workers`를 전달하여 백그라운드 세션을 실행 상태로 유지하면 다음 감독자가 이들에 다시 연결됩니다. 다음 `claude agents` 또는 `claude --bg`는 새로운 감독자를 시작합니다                                                                                                                                                                                                                                                                                                                                                                 |

<h2 id="how-background-sessions-are-hosted">
  백그라운드 세션이 호스팅되는 방식
</h2>

에이전트 뷰에 나열된 모든 세션은 현재 연결되어 있는지 여부와 관계없이 백그라운드 세션으로 간주됩니다. 반대로 `claude`를 직접 실행하여 시작한 세션은 해당 터미널에 연결되어 있으며 [백그라운드로 보내지](#from-inside-a-session) 않는 한 터미널이 닫힐 때 종료됩니다.

<h3 id="the-supervisor-process">
  감독자 프로세스
</h3>

백그라운드 세션은 터미널 및 에이전트 뷰와 별도의 사용자별 감독자 프로세스에 의해 호스팅됩니다. 감독자는 세션을 백그라운드로 보내거나 에이전트 뷰를 열 때 자동으로 시작되며 직접 관리하지 않습니다.

감독자는 에이전트 뷰 또는 `claude --bg`에서의 디스패치가 콜드 런칭의 지연 없이 시작되도록 미리 준비된 워커 프로세스 하나를 준비 상태로 유지합니다. 디스패치할 때 감독자는 미리 준비된 워커를 세션에 할당하고, 해당 세션의 디렉토리, 설정 및 자격 증명을 적용한 다음, 다음 디스패치를 위한 대체 프로세스를 시작합니다. 건강한 미리 준비된 워커를 사용할 수 없으면 감독자는 대신 새로운 프로세스를 시작합니다.

감독자 및 세션은 대화형 세션과 동일한 저장된 자격 증명으로 인증하고 모델 API 이상의 추가 네트워크 연결을 하지 않습니다. `CLAUDE_CODE_USE_BEDROCK` 및 `ANTHROPIC_DEFAULT_*_MODEL` 별칭과 같은 공급자 선택 변수는 각 세션을 디스패치한 셸에서 읽혀지고 해당 워커에 적용됩니다.

백그라운드 세션은 `ANTHROPIC_BASE_URL`, 동등한 Bedrock, Vertex 및 Foundry 기본 URL 변수, 또는 감독자를 시작한 셸이나 디스패칭 셸에서 쌍을 이루는 `ANTHROPIC_AUTH_TOKEN`과 같은 게이트웨이 엔드포인트 변수를 상속하지 않습니다. 세션은 저장된 자격 증명과 프로젝트 디렉토리의 [설정](/ko/settings)에 있는 `env` 값을 사용합니다. 프로젝트의 백그라운드 세션을 [LLM 게이트웨이](/ko/llm-gateway)로 지정하려면 셸에서 내보내는 대신 해당 프로젝트의 `.claude/settings.json` `env` 블록에 `ANTHROPIC_BASE_URL`을 설정합니다.

각 백그라운드 세션은 자체 Claude Code 프로세스이며 터미널이 아닌 감독자에 의해 관리됩니다. 적극적으로 작업 중이거나, 입력을 기다리거나, 터미널이 연결된 세션은 프로세스를 실행 상태로 유지합니다. 실행 중인 백그라운드 셸 명령, 서브에이전트, 동적 워크플로우 또는 모니터는 활성 작업으로 간주되므로 개발 서버와 같은 장기 실행 프로세스는 세션을 활성 상태로 유지합니다.

세션이 완료되고 약 1시간 동안 연결되지 않은 상태로 있으면 감독자는 리소스를 확보하기 위해 프로세스를 중지합니다. `Ctrl+T`로 [고정](#organize-the-list)한 세션은 예외이며 유휴 상태에서도 프로세스를 실행 상태로 유지합니다. 트랜스크립트와 상태는 어느 쪽이든 디스크에 유지되며, 다음에 연결하거나, 엿보거나, 중지된 세션에 답변할 때 감독자는 중단된 위치에서 새로운 프로세스를 시작합니다. 모든 세션이 완료되고 터미널이 연결되지 않으면 감독자 자체가 종료되고 다음에 필요할 때 다시 시작됩니다.

백그라운드 셸 명령 및 동적 워크플로우는 세션의 프로세스가 중지되거나, 다시 시작되거나, Windows를 포함한 업데이트될 때 계속 실행됩니다. 해당 세션을 위해 시작된 다음 프로세스는 이들을 다시 선택하고, 그 사이에 완료된 셸 명령은 출력과 함께 완료된 것으로 보고되며, 워크플로우는 중단된 위치에서 재개됩니다. 서브에이전트가 시작한 셸 명령 및 실행 중인 [모니터](/ko/tools-reference#monitor-tool)는 여전히 프로세스와 함께 중지되며, 세션을 삭제하면 모든 것이 중지됩니다. 백그라운드 셸 명령 및 워크플로우를 프로세스와 함께 중지하려면 [`CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF`](/ko/env-vars#variables) 환경 변수를 `1`로 설정합니다.

다시 시작된 세션이 트랜스크립트를 비어 있는 것으로 잘못 읽었기 때문에 원본 프롬프트만 표시되면서 돌아오면, 대화 트랜스크립트는 삭제되는 대신 `.orphaned-` 접두사로 이름이 바뀌므로 머신에 남아 있습니다.

`←`를 눌러 남겨진 빈 행에 프롬프트가 주어지지 않은 경우 약 5분 후에 완전히 제거되므로 목록이 자동으로 정리됩니다. `claude --bg`로 시작한 세션과 신뢰 대화 상자와 같은 설정 프롬프트를 기다리는 세션은 이러한 방식으로 제거되지 않습니다.

호스트의 메모리가 부족할 때 감독자는 유휴 고정되지 않은 세션을 먼저 중지하고 아무것도 확보되지 않은 경우에만 유휴 고정된 세션을 중지합니다.

감독자는 디스크에 설치된 Claude Code 바이너리를 감시하고 일반 [자동 업데이터](/ko/setup#auto-updates)가 교체한 후 새 버전으로 다시 시작합니다. 이는 네트워크 검사가 아닌 로컬 파일 감시입니다. 백그라운드 세션은 분리된 프로세스이므로 다시 시작을 통해 계속 실행되고 새 감독자는 다시 연결됩니다. 유휴 고정된 세션도 새 버전으로 제자리에서 다시 시작되므로 다시 연결하지 않고도 업데이트를 적용합니다.

<h3 id="where-state-is-stored">
  상태가 저장되는 위치
</h3>

세션 상태는 Claude Code 구성 디렉토리 아래에 저장됩니다. [`CLAUDE_CONFIG_DIR`](/ko/env-vars)을 설정하면 감독자는 `~/.claude` 대신 해당 디렉토리를 사용하고 자체 세션이 있는 별도의 인스턴스로 실행됩니다.

| 경로                               | 내용                                                 |
| :------------------------------- | :------------------------------------------------- |
| `~/.claude/daemon.log`           | 감독자 로그                                             |
| `~/.claude/daemon/roster.json`   | 실행 중인 백그라운드 세션 목록, 다시 시작 후 다시 연결하는 데 사용됨           |
| `~/.claude/jobs/<id>/state.json` | 에이전트 뷰에 표시되는 세션별 상태                                |
| `~/.claude/jobs/<id>/tmp/`       | 세션별 스크래치 디렉토리. 여기에 쓰기는 권한을 요청하지 않습니다. 세션이 삭제되면 제거됨 |

각 백그라운드 세션에는 `CLAUDE_JOB_DIR` 환경 변수가 `~/.claude/jobs/<id>` 디렉토리로 설정되어 있으므로 세션이 실행하는 셸 명령은 병렬 세션과 충돌하지 않고 `$CLAUDE_JOB_DIR/tmp`에 임시 파일을 쓸 수 있습니다.

파일을 직접 읽지 않고 이 상태를 검사하려면 `claude daemon status`를 실행합니다. 감독자에 도달할 수 있는지 여부, 프로세스 ID 및 버전, 소켓 디렉토리, 그리고 활성 백그라운드 세션의 수를 보고합니다. `/doctor`는 동일한 검사의 요약을 포함합니다.

명령은 또한 실행 중인 감독자가 호출한 `claude`와 다른 버전에 있을 때 경고하며, 이는 감독자가 아직 다시 시작하지 않은 업데이트 후에 발생합니다. 경고는 두 버전을 모두 표시하고 새 버전을 적용하려면 `claude daemon stop --any`를 실행하도록 지시합니다. Claude Code가 OS 서비스로 설치된 경우 제안된 명령은 플래그 없이 `claude daemon stop`입니다.

Windows에서 `claude daemon status`는 감독자의 파이프 키 파일이 잠겨 있거나 읽을 수 없을 때 일반적인 연결 실패를 보고하는 대신 기본 파일 오류를 표시합니다.

세션은 버전 불일치를 그대로 유지합니다: 이전 Claude Code 버전이 세션의 `state.json`을 업데이트할 때 인식하지 못하는 필드를 보존하고 세션을 나열된 상태로 유지합니다.

<h3 id="turn-off-agent-view">
  에이전트 뷰 끄기
</h3>

백그라운드 에이전트 및 에이전트 뷰를 완전히 끄려면 `disableAgentView` [설정](/ko/settings)을 `true`로 설정하거나 `CLAUDE_CODE_DISABLE_AGENT_VIEW` 환경 변수를 설정합니다. 관리자는 [관리 설정](/ko/permissions#managed-settings)을 통해 이를 적용할 수 있습니다.

<h2 id="troubleshooting">
  문제 해결
</h2>

<h3 id="claude-agents-lists-subagents-instead-of-opening-agent-view">
  `claude agents`가 에이전트 뷰를 열지 않고 서브에이전트를 나열함
</h3>

`claude agents`가 개수를 출력한 후 구성된 서브에이전트를 나열하고 종료되면, 에이전트 뷰를 사용할 수 없는 환경입니다. `claude update`를 실행하여 최신 버전을 설치합니다.

업데이트 후에도 에이전트 뷰가 열리지 않으면, 설정 또는 환경 변수에 의해 [꺼져 있는지](#turn-off-agent-view) 확인합니다.

<h3 id="agent-view-opens-with-no-sessions">
  에이전트 뷰가 세션 없이 열림
</h3>

첫 번째 세션을 디스패치하기 전에 에이전트 뷰는 세션 목록 대신 짧은 온보딩 힌트와 예제 프롬프트를 표시합니다. 하단의 입력에 프롬프트를 입력하고 `Enter`를 눌러 첫 번째 세션을 디스패치합니다.

<h3 id="backgrounding-shows-a-background-this-session-dialog">
  백그라운드로 이동하면 `Background this session?` 대화 상자가 표시됨
</h3>

`←`를 눌러 현재 세션을 백그라운드로 전환할 때 `Background this session?` 대화 상자가 표시되면, 세션에 실행 중인 [모니터](/ko/tools-reference#monitor-tool)와 같이 백그라운드 세션으로 이동할 수 없는 진행 중인 작업이 있으며, Claude Code는 이를 자동으로 중단하지 않습니다. 대화 상자는 중단될 작업의 이름을 지정하고 별도로 이동할 작업의 개수를 세어줍니다. `/tasks`를 실행하여 실행 중인 모든 작업을 확인한 후 어쨌든 백그라운드로 이동하도록 확인하거나 `Stay`를 선택하여 작업이 먼저 완료되도록 합니다. [세션 내에서](#from-inside-a-session)에서 이동되는 작업 종류와 중지되는 작업 종류를 참조합니다.

<h3 id="prompt-rejected-as-too-short">
  프롬프트가 너무 짧아서 거부됨
</h3>

디스패치 입력은 대화형 오프닝이 아닌 작업 설명을 예상합니다. 4자 미만의 프롬프트는 `Too short` 힌트와 함께 거부되므로 실수로 누른 키가 세션을 시작하지 않습니다. 세션이 수행할 작업을 설명합니다. 예를 들어 `investigate the flaky checkout test`와 같이 설명합니다.

<h3 id="sessions-show-as-failed-after-shutdown">
  머신 종료 후 세션이 실패로 표시됨
</h3>

머신을 종료하거나 재시작하면 실행 중인 백그라운드 세션이 중지되므로, 다음에 에이전트 뷰를 열 때 실패로 표시됩니다. 이들 중 하나에 연결하거나, 엿보거나, 답변하면 세션이 중단된 위치에서 다시 시작됩니다.

절전 상태만으로는 이 문제가 발생하지 않습니다. 세션은 절전 상태에서 보존되며 감독자는 깨어날 때 이들에 다시 연결됩니다.

<h3 id="agent-view-says-the-background-service-did-not-respond">
  에이전트 뷰에서 백그라운드 서비스가 응답하지 않음
</h3>

연결, 엿보기 또는 `claude logs`에서 백그라운드 서비스가 응답하지 않음을 보고하면, 감독자 프로세스가 중단되었을 가능성이 높습니다. 이를 중지하고 다음 `claude agents`가 새로운 프로세스를 시작하도록 합니다. 백그라운드 세션을 재시작 중에도 계속 실행하려면 `--keep-workers`를 전달합니다:

```bash theme={null}
claude daemon stop --any --keep-workers
```

새로운 감독자는 실행 중인 세션에 다시 연결됩니다. `--keep-workers` 없이는 명령이 백그라운드 세션도 종료합니다. `--any` 플래그는 기본값인 설치된 서비스가 아닌 요청 시 시작된 감독자를 중지하려는 의도를 확인합니다.

감독자가 시작되지만 연결을 수락할 수 없으면 자체적으로 종료되고 잠금을 해제하므로, 다음 `claude agents`는 이 수동 중지 없이 새로운 프로세스를 시작합니다. 위의 단계는 실행 중인 감독자가 중단되었을 때 적용됩니다.

Windows에서 감독자가 중지 요청에 응답하지 않으면, 명령이 프로세스 ID를 출력합니다. `taskkill /PID <pid>`로 해당 프로세스를 종료하여 복구를 완료합니다. `--keep-workers`를 전달했으면 백그라운드 세션은 여전히 보존됩니다.

<h3 id="dispatch-fails-with-could-not-resolve-authentication-method">
  `Could not resolve authentication method` 오류로 디스패치 실패
</h3>

백그라운드 디스패치가 `Could not resolve authentication method` 오류로 실패하지만 대화형 세션은 정상적으로 인증되면, 디스패치를 받은 워커가 자격 증명을 선택하지 못했습니다. 감독자는 [사전 준비된 워커](#the-supervisor-process)를 할당할 때 새로운 자격 증명 스냅샷을 제공하므로, 이 오류는 감독자 프로세스 자체에서 저장된 자격 증명을 사용할 수 없음을 의미합니다. `/login`을 실행했거나 API 키를 구성했는지 확인한 후 감독자를 중지합니다:

```bash theme={null}
claude daemon stop --any --keep-workers
```

다음 `claude agents` 또는 `claude --bg`는 저장된 자격 증명을 읽는 새로운 감독자를 시작합니다. `ANTHROPIC_API_KEY`와 같은 환경 변수로 인증하는 경우 `/login` 대신 변수가 설정된 셸에서 다음 명령을 실행합니다.

원인 및 해결 방법의 전체 목록은 [오류 참조](/ko/errors#could-not-resolve-authentication-method)를 참조합니다.

<h3 id="background-sessions-cannot-read-desktop-documents-or-downloads-on-macos">
  macOS에서 백그라운드 세션이 Desktop, Documents 또는 Downloads를 읽을 수 없음
</h3>

macOS에서 백그라운드 세션 호스트는 자체 프로세스로 실행되며 터미널과 별도로 보호된 폴더에 대한 액세스를 요청합니다. 백그라운드 세션이 `~/Desktop`, `~/Documents`, `~/Downloads` 또는 다른 보호된 위치를 읽을 때 `Operation not permitted`를 보고하면, 시스템 설정의 개인정보 보호 및 보안 > 파일 및 폴더에서 액세스를 허용하거나 항목에 대해 전체 디스크 액세스를 활성화합니다.

기본 설치 프로그램을 사용하면 항목이 Claude Code로 표시되고 권한이 업데이트 전체에서 유지됩니다. Homebrew 또는 npm과 같은 다른 설치 방법을 사용하면 항목이 바이너리 경로를 표시하며 업데이트 후 다시 권한을 부여해야 할 수 있습니다.

<h3 id="a-session-is-slow-to-respond-after-attaching">
  연결 후 세션이 응답이 느림
</h3>

세션이 완료되고 약 1시간 동안 연결되지 않으면 감독자는 리소스를 확보하기 위해 프로세스를 중지합니다. 연결하면 중단된 위치에서 새로운 프로세스를 시작합니다. 작업 중이거나 입력을 기다리는 세션 또는 [고정된](#organize-the-list) 세션은 이런 식으로 중지되지 않으므로, `Ctrl+T`로 세션을 고정하여 응답성을 유지합니다.

<h3 id="claude/worktrees/-is-filling-up">
  `.claude/worktrees/`가 채워지고 있음
</h3>

에이전트 뷰에서 세션을 삭제하면 Claude가 생성한 워크트리가 제거됩니다. `claude rm`은 커밋되지 않은 변경 사항이 있는 워크트리를 유지하고 해당 경로를 출력합니다. 프로젝트 디렉토리에서 `git worktree list`로 남은 항목을 나열하고 각각을 `git worktree remove <path>`로 제거합니다. [워크트리 정리](/ko/worktrees#clean-up-worktrees)를 참조합니다.

<h2 id="limitations">
  제한 사항
</h2>

에이전트 뷰는 연구 미리보기 상태이며 다음과 같은 제한 사항이 있습니다:

* **속도 제한 적용**: 백그라운드 세션은 대화형 세션과 동일하게 구독 사용량을 소모하므로 10개의 에이전트를 병렬로 실행하면 할당량을 약 10배 빠르게 소모합니다.
* **세션은 로컬입니다**: 백그라운드 세션은 사용자의 머신에서 실행되며 머신이 절전 모드로 전환되어도 유지되지만 머신이 종료되면 중지됩니다.
* **Claude에서 생성한 워크트리는 에이전트 뷰의 세션과 함께 삭제됩니다**: 자체 워크트리에서 파일을 편집한 세션을 삭제하기 전에 변경 사항을 병합하거나 푸시합니다. `claude rm`은 커밋되지 않은 변경 사항이 있는 워크트리를 유지하며, 사용자가 직접 생성한 워크트리는 그대로 유지됩니다.

<h2 id="related-resources">
  관련 리소스
</h2>

Claude를 병렬로 실행하는 다른 방법은 다음을 참조하십시오:

* [에이전트를 병렬로 실행](/ko/agents): 에이전트 뷰를 서브에이전트, 에이전트 팀 및 워크트리와 비교합니다
* [에이전트 팀](/ko/agent-teams): 서로 메시지를 주고받는 여러 세션을 조정합니다
* [웹의 Claude Code](/ko/claude-code-on-the-web): 로컬 대신 관리되는 클라우드 환경에서 세션을 실행합니다

<h2 id="version-history">
  버전 기록
</h2>

에이전트 뷰는 연구 미리보기 중에 빠르게 발전했습니다. 이전 Claude Code 버전을 사용 중인 경우 이 페이지의 일부 동작이 다를 수 있습니다. 특히 `claude agents`는 아직 지원하지 않는 플래그를 `unknown option` 오류로 거부합니다. 아래 표는 각 플래그와 동작이 추가된 시기를 나열합니다.

| 버전       | 변경 사항                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| v2.1.196 | {/* min-version: 2.1.196 */}단일 `←` 누름이 포그라운드 세션을 백그라운드로 이동합니다. 이전 버전은 바닥글 힌트와 확인이 있는 두 번의 누름이 필요했습니다. `claude agents`에 전달된 `--dangerously-skip-permissions`는 자동으로 삭제되는 대신 면책 조항을 표시합니다. 이름을 지정하지 않은 대화형 세션은 세션 목록 및 `claude agents --json`에서 `my-app-3f`와 같은 기본 이름을 가집니다. 백그라운드 셸 명령 및 동적 워크플로우는 세션의 프로세스가 중지되거나, 다시 시작되거나, Windows를 포함한 업데이트될 때 생존합니다. `CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF=1`을 설정하여 핸드오프를 끕니다. 다시 시작 시 비어 있는 것으로 잘못 읽은 트랜스크립트는 삭제되는 대신 `.orphaned-` 접두사로 이름이 바뀝니다. |
| v2.1.195 | {/* min-version: 2.1.195 */}Windows에서도 백그라운드 세션으로 이동할 때 진행 중인 작업이 이동합니다. `CLAUDE_DISABLE_ADOPT=1`을 설정하여 대신 중지합니다. `완료됨` 그룹은 남은 수직 공간을 채우고 짧은 터미널에서 헤더가 압축됩니다. 이전 Claude Code 버전은 더 이상 최신 세션의 `state.json` 필드를 삭제하거나 해당 세션을 `claude agents`에서 숨기지 않습니다. 중지된 세션에 연결하면 최대 5초 동안 빈 화면을 표시하는 대신 즉시 전환됩니다. 연결을 수락할 수 없는 감독자는 자체적으로 종료되고 잠금을 해제합니다.                                                                                                                                         |
| v2.1.174 | {/* min-version: 2.1.174 */}백그라운드 세션은 더 이상 감독자의 시작 셸에서 `ANTHROPIC_BASE_URL`과 같은 게이트웨이 엔드포인트 변수를 상속하지 않습니다. 감독자는 사전 준비된 워커에 새로운 자격 증명 스냅샷을 제공하여 허위 `Could not resolve authentication method` 오류를 수정합니다.                                                                                                                                                                                                                                                                               |
| v2.1.172 | {/* min-version: 2.1.172 */}디스패치 입력의 `/model`이 세션 범위 디스패치 모델 재정의를 설정합니다.                                                                                                                                                                                                                                                                                                                                                                                                             |
| v2.1.161 | {/* min-version: 2.1.161 */}행 요약은 병렬 작업 항목에 대해 `done/total` 개수를 표시합니다. 엿보기 패널은 가장 오래 실행 중인 병렬 작업 항목의 이름을 지정합니다.                                                                                                                                                                                                                                                                                                                                                                      |
| v2.1.157 | {/* min-version: 2.1.157 */}}`claude agents`는 `--agent`를 허용합니다. 디스패치된 세션은 `agent` 설정을 준수합니다.                                                                                                                                                                                                                                                                                                                                                                                         |
| v2.1.145 | {/* min-version: 2.1.145 */}음성 받아쓰기는 엿보기 패널 답변 입력 및 디스패치 입력에서 지원됩니다.                                                                                                                                                                                                                                                                                                                                                                                                                 |
| v2.1.143 | {/* min-version: 2.1.143 */}}`worktree.bgIsolation` 설정이 추가되었습니다. `claude agents`는 `--allow-dangerously-skip-permissions`를 허용합니다.                                                                                                                                                                                                                                                                                                                                                     |
| v2.1.142 | {/* min-version: 2.1.142 */}}`claude agents`는 `--permission-mode`, `--model`, `--effort`, `--dangerously-skip-permissions`, `--settings`, `--add-dir`, `--plugin-dir`, `--mcp-config` 및 `--strict-mcp-config`를 허용합니다.                                                                                                                                                                                                                                                                |
| v2.1.141 | {/* min-version: 2.1.141 */}}`claude agents`는 `--cwd`를 허용하여 목록을 한 프로젝트로 범위를 지정합니다.                                                                                                                                                                                                                                                                                                                                                                                                   |
| v2.1.139 | {/* min-version: 2.1.139 */}에이전트 뷰가 연구 미리보기로 도입되었습니다.                                                                                                                                                                                                                                                                                                                                                                                                                                |
