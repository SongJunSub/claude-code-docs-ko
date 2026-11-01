> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 여러 에이전트를 에이전트 뷰로 관리하기

> 하나의 화면에서 많은 Claude Code 세션을 디스패치하고 관리합니다. 에이전트 뷰는 모든 세션이 무엇을 하고 있는지, 어떤 세션이 입력을 필요로 하는지 보여줍니다.

`claude agents`로 열 수 있는 에이전트 뷰는 모든 백그라운드 세션을 위한 하나의 화면입니다: 무엇이 실행 중인지, 무엇이 입력을 필요로 하는지, 무엇이 완료되었는지를 보여줍니다. 새로운 세션을 디스패치하고, 트랜스크립트를 스크롤하는 대신 한눈에 상태를 확인하고, 필요할 때만 개입합니다. 각 백그라운드 세션은 터미널이 연결되지 않은 상태에서도 계속 실행되는 완전한 Claude Code 대화이므로, 언제든지 열고, 답변하고, 떠날 수 있습니다.

![터미널의 에이전트 뷰. 상단의 한 줄은 입력을 기다리는 세션, 작업 중인 세션, 완료된 세션의 개수를 표시합니다. 네 개의 세션이 입력 필요, 작업 중, 완료됨 아래에 그룹화되어 있습니다. 각 행은 세션의 이름, 최신 상태 또는 질문, 시간을 표시합니다. 하단에는 새 작업을 설명하기 위한 입력 필드와 키보드 힌트 행이 있습니다.](https://mintcdn.com/claude-code/HDAmBwgbrZVk0pOt/images/agent-view-light.png?fit=max\&auto=format\&n=HDAmBwgbrZVk0pOt\&q=85\&s=d6905012bee31f3e6b3920b09c05dd02)

Claude가 사용자의 감시 없이 작업할 수 있는 여러 독립적인 작업이 있을 때 에이전트 뷰를 사용합니다. 버그 수정, 풀 리퀘스트 검토, 불안정한 테스트 조사를 세 개의 행으로 디스패치하고, 다른 창에서 계속 작업하며, 행에 입력이 필요하거나 결과가 있음을 표시할 때 다시 확인합니다.

에이전트의 세션에서 더 직접적으로 작업하려면, 행에 연결하여 전체 대화에 진입합니다.

에이전트 뷰를 서브에이전트, 에이전트 팀 및 워크트리와 비교하려면 [병렬로 에이전트 실행](https://code.claude.com/docs/ko/agents.md)을 참조하세요. 에이전트 뷰는 사용자의 머신에서 세션을 실행하고 각 세션을 디스패치합니다. 대신 Claude가 하나의 대화에서 클라우드의 병렬 세션을 시작하고 추적하도록 하려면 [프로젝트](https://code.claude.com/docs/ko/claude-projects.md)를 참조하세요.

> [!NOTE]
>
> 에이전트 뷰는 연구 미리보기 상태입니다. 기능이 발전함에 따라 인터페이스와 키보드 단축키가 변경될 수 있습니다.

## 빠른 시작

이 연습은 핵심 에이전트 뷰 루프를 다룹니다: 작업을 디스패치하고, Claude가 작업하면서 행이 업데이트되는 것을 지켜보고, 엿보기로 확인하고 답변하고, 전체 대화를 위해 연결합니다. 디스패치한 세션은 에이전트 뷰를 닫은 후에도 계속 실행되므로, 언제든지 떠났다가 돌아올 수 있습니다.

**1. 에이전트 뷰 열기**

셸에서 다음을 실행합니다:

```bash theme={null}
claude agents
```

아직 디렉토리에 대한 [워크스페이스 신뢰 대화](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)를 수락하지 않았다면, Claude Code는 에이전트 뷰가 열리기 전에 이를 표시합니다. 이는 `claude`가 표시하는 동일한 대화입니다. 워크스페이스에 대한 신뢰를 저장하고 계속하려면 수락합니다. 거부하면 Claude Code는 에이전트 뷰를 열지 않고 종료됩니다.

에이전트 뷰는 하단의 입력과 세션이 시작되면서 채워지는 테이블과 함께 열립니다. `Esc`를 눌러 셸로 돌아갑니다. `←`로 세션을 백그라운드로 보내서 에이전트 뷰를 열었다면, `Esc`는 대신 해당 대화로 돌아갑니다. 세션은 떠나 있는 동안 계속 실행되며 다음에 에이전트 뷰를 열 때 다시 나타납니다.

**2. 세션 디스패치**

작업을 설명하는 프롬프트를 입력하고 `Enter`를 누릅니다. 새로운 백그라운드 세션이 해당 작업에서 시작되고 작업 중인지, 입력을 기다리는지, 완료되었는지를 보여주는 행으로 나타납니다. 새로운 세션은 에이전트 뷰 헤더에 표시된 모델을 사용합니다. [시작되는 권한 모드](#permission-mode-model-and-effort)는 에이전트 뷰를 열 때의 방식에 따라 달라집니다.

여기에 입력하는 모든 프롬프트는 자신의 새로운 세션을 시작합니다. 다른 프롬프트를 입력하고 `Enter`를 누르면 첫 번째 세션에 후속 메시지를 보내는 대신 첫 번째 세션과 함께 두 번째 세션을 시작합니다. 이렇게 여러 세션을 병렬로 실행할 수 있습니다.

각 세션은 구독 할당량을 독립적으로 사용하므로, 한 번에 많은 세션을 디스패치하기 전에 [제한사항](#limitations)을 참조하십시오.

**3. 엿보기 및 답변**

화살표 키로 행을 선택하고 `Space`를 눌러 엿보기 패널을 엽니다. 전체 트랜스크립트가 아닌 세션의 가장 최근 출력 또는 기다리고 있는 질문을 표시합니다. 답변을 입력하고 `Enter`를 눌러 에이전트 뷰를 떠나지 않고 전송합니다.

**4. 연결 및 분리**

전체 대화를 원할 때 행에서 `Enter` 또는 `→`를 눌러 연결합니다. 세션이 전체 대화형 Claude Code 세션으로 터미널을 차지합니다. 빈 프롬프트에서 `←`를 눌러 분리하고 테이블로 돌아갑니다.

**5. 기존 세션 가져오기**

이 단계에는 실행 중인 세션이 필요합니다. 이전 단계를 따랐다면 이 터미널에서 열려 있는 세션이 없으므로, 다른 터미널에서 일반 `claude` 세션을 열고 먼저 메시지를 보냅니다.

이미 열려 있는 세션을 에이전트 뷰로 이동하려면 세션 내에서 `/bg`를 실행하거나, 빈 프롬프트에서 `←`를 눌러 세션을 백그라운드로 보내고 한 단계에서 에이전트 뷰를 엽니다. 메시지가 아직 없는 새로운 세션에서는 `/bg`가 먼저 메시지를 보내도록 요청하는 반면, `←`는 바로 작동합니다. 세션은 계속 실행되며 디스패치한 세션과 함께 행으로 나타납니다.

일반 `claude` 세션에서 빈 프롬프트에서 `←`를 누르면 에이전트 뷰가 열리며, 푸터의 `←` 힌트는 백그라운드 세션에 대한 정보를 표시합니다:

* **힌트**: 세션이 열린 후 10초 동안 푸터에 `← for agents`가 표시됩니다. 힌트가 사라진 후에도 `←`를 누르면 계속 작동합니다
* **대기 개수**: 백그라운드 세션이 입력을 기다리는 동안 같은 위치에 `← 2 agents`와 같이 그 개수가 표시되며, 99개를 초과하면 `← 99+ agents`로 표시됩니다. 개수는 터미널이 포커스되어 있는 동안 약 10초마다 새로 고쳐지고 포커스가 돌아올 때 즉시 새로 고쳐집니다
* **완료 개수**: 입력을 기다리는 세션이 없는 상태에서 백그라운드 세션이 성공적으로 완료되면, 푸터에 완료된 개수가 잠깐 표시됩니다. 예를 들어 두 개가 완료되면 `← 2 done`으로 표시됩니다

대기 개수가 늘어나거나 줄어들 때와 백그라운드 세션이 성공적으로 완료될 때 대기 개수의 색상이 잠깐 변합니다. [`prefersReducedMotion`](https://code.claude.com/docs/ko/settings-reference#prefersreducedmotion)을 켜면 색상 변화와 `done` 개수가 모두 표시되지 않습니다. [화면 읽기 모드](https://code.claude.com/docs/ko/accessibility.md)에서는 `←` 힌트와 개수가 숨겨집니다.

### 기본적으로 에이전트 뷰 열기

`claude`를 인수 없이 실행할 때 새로운 대화 대신 에이전트 뷰를 열도록 하려면 `/config` 설정을 켭니다.

**1. 설정 켜기**

일반 `claude` 세션에서 `/config`를 실행하고 **기본적으로 에이전트 뷰 열기**를 켭니다. 메뉴를 건너뛰려면 [`defaultToAgentsView`](https://code.claude.com/docs/ko/settings-reference#defaulttoagentsview) 키를 직접 설정합니다:

```text theme={null}
/config defaultToAgentsView=true
```

**2. Claude Code 시작**

세션을 종료한 다음 인수 없이 `claude`를 실행합니다:

```bash theme={null}
claude
```

에이전트 뷰가 새로운 대화 대신 열립니다.

설정이 켜져 있는 동안 일반 세션을 시작하려면 프롬프트를 전달합니다: `claude "fix the login test"`. 설정을 끄려면 일반 세션에서 또는 에이전트 뷰에서 연결한 세션에서 `/config defaultToAgentsView=false`를 실행합니다.

## 에이전트 뷰로 세션 모니터링

`claude agents`를 실행하여 에이전트 뷰를 엽니다. 전체 터미널을 차지하고 상태별로 그룹화된 모든 세션을 나열하며, 고정된 세션과 입력이 필요한 세션이 맨 위에 있습니다. 각 행은 세션의 이름, 현재 활동 및 나이를 보여줍니다. 나이는 세션이 생성된 시점부터 계산되며, 완료된 세션의 나이는 실행에 걸린 시간에서 멈춥니다.

이름은 해당 세션에서 [`/color`](https://code.claude.com/docs/ko/commands)로 설정된 색상으로 표시됩니다. `←` 또는 `/background`로 [세션을 백그라운드로 보낼](#from-inside-a-session) 때를 포함합니다.

기본적으로 목록은 모든 프로젝트에 걸쳐 시작한 모든 백그라운드 세션을 표시합니다. 한 저장소에서 작업하는 세션과 다른 worktree에서 작업하는 세션은 모두 여기에 나타나며, 에이전트 뷰를 연 디렉토리와 관계없이 표시됩니다. 목록을 한 프로젝트로 좁히려면 `--cwd`를 전달합니다:

```bash theme={null}
claude agents --cwd ~/projects/my-app
```

이는 해당 디렉토리 아래에서 시작된 세션만 표시합니다. `~/projects/my-app/.claude/worktrees/` 아래의 [worktree로 이동한](#how-file-edits-are-isolated) 세션은 여전히 나열됩니다.

다른 터미널에서 열려 있는 대화형 세션은 [백그라운드로 보낼](#from-inside-a-session) 때까지 나타나지 않습니다. 세션이 생성하는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)와 [팀원](https://code.claude.com/docs/ko/agent-teams.md)은 별도의 행으로 나열되지 않습니다.

```text theme={null}
Pinned
  ✽ clawd walk cycle          Drawing the walk-cycle sprite frames          3m

Ready for review
  ∙ jump physics              Opened PR with collision fix                 #2048  2h

Needs input
  ✻ power-up design           double jump or wall climb?                    1m

Working
  ✽ collision detection       Adding swept-AABB checks to CollisionSystem   2m
  ✢ playtest level 3          all checkpoints cleared ×12                in 4m

Completed
  ✻ title screen              menu, options, and credits done               9m
  ∙ sound effects             14 SFX exported to assets/audio               4h
  … 6 more
```

### 세션 상태 읽기

각 행은 세션의 상태를 나타내는 아이콘으로 시작하며, 아이콘의 색상과 애니메이션이 상태를 보여줍니다:

| 상태 | 아이콘 표시 | 의미 |
| :- | :- | :- |
| 작업 중 | 애니메이션 | Claude가 적극적으로 도구를 실행하거나 응답을 생성 중 |
| 입력 필요 | 노란색 | Claude가 사용자만 제공할 수 있는 것을 기다리는 중입니다: 질문에 대한 답변, 권한 결정, 또는 네트워크 호스트를 허용하는 [샌드박스](https://code.claude.com/docs/ko/sandboxing.md) 프롬프트나 MCP 서버의 [입력 요청](https://code.claude.com/docs/ko/mcp.md#respond-to-mcp-elicitation-requests)과 같이 사용자만 답변할 수 있는 다른 프롬프트입니다. 연결된 터미널이 필요한 명령(예: `/install-github-app` 또는 `/mcp` 설정 목록)도 [무인 세션을 이 상태로 둡니다](#attach-to-a-session) |
| 유휴 | 흐릿함 | 세션이 할 일이 없으며 다음 프롬프트를 기다리는 중 |
| 완료됨 | 녹색 | 작업이 성공적으로 완료됨 |
| 실패 | 빨간색 | 작업이 오류로 종료됨 |
| 중지됨 | 회색 | `Ctrl+X` 또는 `claude stop`으로 세션을 중지했거나, [프로세스가 Claude Code 외부에서 종료되었거나](#the-supervisor-process), [백그라운드 서비스가 꺼져 있는 동안 종료됨](#sessions-show-as-failed-after-shutdown) |

별도로, 아이콘의 모양은 그 자체의 의미를 가집니다:

| 모양 | 의미 |
| :- | :- |
| `✻` 또는 애니메이션 `✽` | 세션 프로세스가 실행 중이거나, 세션이 사용자의 입력을 필요로 함 |
| `∙` | 프로세스가 종료됨. 여전히 행을 엿볼 수 있으며, 답변하거나 연결하면 Claude가 저장된 대화에서 프로세스를 다시 시작 |
| `✢` | [`/loop`](https://code.claude.com/docs/ko/scheduled-tasks) 세션이 반복 사이에 절전 중. 행은 실행 횟수와 카운트다운을 표시 |

행의 오른쪽 가장자리에 나타날 수 있는 `#N` 또는 `!N` 레이블은 세션의 [풀 리퀘스트 또는 병합 요청](#pull-request-status)에 대한 링크이며, 상태 아이콘의 일부가 아닙니다.

터미널 탭 제목은 에이전트 뷰가 열려 있는 동안 입력 대기 중인 개수를 표시합니다: 세션이 입력이 필요할 때 `2 awaiting input · claude agents`, 필요하지 않을 때 `claude agents`.

스크립트 또는 다른 프로그램에서 세션 상태를 읽으려면 `~/.claude/jobs/` 아래의 파일 대신 [`claude agents --json`](#read-session-state-from-a-script)을 사용합니다.

에이전트 뷰가 열려 있는 동안 Claude Code는 로컬 백그라운드 세션이 입력이 필요해지거나, 완료되거나, 실패할 때 구성된 [터미널 알림 채널](https://code.claude.com/docs/ko/terminal-config.md#get-a-terminal-bell-or-notification)을 통해 알림을 보냅니다. [`/loop`](https://code.claude.com/docs/ko/scheduled-tasks) 세션과 같이 일정에 따라 실행되는 세션은 입력이 필요할 때만 알립니다. 알림은 Claude Code의 나머지 부분과 동일한 [`preferredNotifChannel` 설정](https://code.claude.com/docs/ko/settings-reference#preferrednotifchannel)을 사용하며 `agent_needs_input` 또는 `agent_completed` 유형으로 [`Notification` 훅](https://code.claude.com/docs/ko/hooks#notification)을 실행합니다.

백그라운드 세션은 계속 작동하기 위해 열린 터미널이 필요하지 않습니다. 별도의 [감독자 프로세스](#the-supervisor-process)가 실행하므로 에이전트 뷰를 닫거나, 셸을 닫거나, 새로운 대화형 세션을 시작해도 디스패치된 작업은 계속됩니다.

세션 상태는 자동 업데이트 및 감독자 재시작을 통해 디스크에 유지됩니다. 세션은 머신이 절전 상태일 때도 보존됩니다. 프로세스는 깨어날 때 재개되고 감독자는 시간 간격을 유휴로 취급하는 대신 다시 연결됩니다. 종료하면 여전히 실행 중인 세션이 중지됩니다. 복구 방법은 [종료 후 세션이 실패 또는 중지로 표시됨](#sessions-show-as-failed-after-shutdown)을 참조하세요.

응답 중에 머신이 절전 상태일 때 세션이 응답하지 않는 상태로 돌아올 수 있습니다. 응답하지 않는 세션을 열 때 감독자는 프로세스를 다시 시작하고 세션은 중단된 응답을 중단된 위치에서 계속합니다.

### 행 요약

각 행의 한 줄 요약은 [Haiku 클래스 모델](https://code.claude.com/docs/ko/model-config.md)에 의해 생성되므로 행은 트랜스크립트를 열지 않고도 세션이 무엇을 하고 있는지, 무엇이 필요한지, 또는 무엇을 생성했는지 알려줄 수 있습니다. 세션이 적극적으로 작동하는 동안 행 텍스트는 최대 15초마다 한 번, 세션의 최근 출력에서 모델 요청을 보내지 않고 업데이트되며, 각 턴이 끝날 때 모델이 새로운 요약을 작성합니다.

작업 중인 행은 세션이 수행 중이라고 말하는 작업을 표시하고, 차단된 행은 요청하는 질문을 표시합니다. 긴 턴 동안 모델은 몇 분마다 요약을 다시 작성하므로 바쁜 행이 오래된 요약을 계속 표시하지 않습니다. 요약 텍스트는 행의 남은 너비를 채웁니다. 터미널 가장자리에서 잘리는 문장을 읽으려면 [엿보기 패널](#peek-and-reply)을 엽니다.

목록이 [디렉토리별로 그룹화](#organize-the-list)될 때 요약은 `Needs input · double jump or wall climb?`와 같이 색상이 지정된 단어로 된 세션의 상태로 시작합니다. 기본 상태 그룹화에서는 그룹 헤더가 이미 상태를 명명하므로 행은 요약만 표시합니다.

턴 끝 요약 및 각 중간 다시 작성은 일반 제공자를 통한 하나의 짧은 Haiku 클래스 요청이며, 세션 자체와 동일한 [데이터 사용 약관](https://code.claude.com/docs/ko/data-usage.md)에 따라 청구되고 처리됩니다. 모델 다시 작성 사이의 15초 업데이트는 세션의 자체 출력을 재사용하며 요청을 보내지 않습니다. Haiku 클래스 모델이 구성되지 않은 타사 제공자 또는 게이트웨이에서는 요청이 대신 세션의 주 모델을 사용합니다. 모델을 선택하려면 [`ANTHROPIC_DEFAULT_HAIKU_MODEL`](https://code.claude.com/docs/ko/model-config#environment-variables)을 설정합니다.

### 풀 리퀘스트 상태

세션이 [풀 리퀘스트를 열](#how-file-edits-are-isolated) 때 Claude Code는 행의 오른쪽 가장자리에 레이블을 추가하며, 풀 리퀘스트에 연결됩니다:

* Claude Code는 풀 리퀘스트의 경우 `#1234`로, GitLab 병합 요청의 경우 `!1234`로 레이블을 작성합니다.
* Claude Code는 SSH 또는 tmux를 통한 경우와 같이 하이퍼링크 지원을 감지할 수 없을 때도 링크를 내보냅니다. [`FORCE_HYPERLINK=0`](https://code.claude.com/docs/ko/env-vars)을 설정하여 레이블을 일반 텍스트로 렌더링합니다.
* 세션에 후속 메시지를 보낸 후 Claude Code는 행이 라이브 진행 상황으로 돌아가는 동안 레이블을 유지합니다.

기존 풀 리퀘스트에서 작업하는 세션은 동일한 방식으로 연결됩니다. Claude Code는 Claude가 실행하는 명령에 따라 풀 리퀘스트를 다르게 찾습니다:

* Claude가 `gh`로 풀 리퀘스트를 편집, 댓글, 닫기 또는 준비 완료로 표시할 때 Claude Code는 명령의 자체 출력이 명명하는 풀 리퀘스트에 연결합니다. 캡처된 출력이 풀 리퀘스트를 명명하지 않는 `gh` 명령은 링크를 생성하지 않습니다. `gh pr merge`는 일반적인 경우이며, 결과를 대화형 터미널에만 인쇄하기 때문입니다.
* Claude가 `gh pr checkout`으로 풀 리퀘스트를 체크아웃하거나 브랜치로 푸시할 때 Claude Code는 `gh pr view`로 브랜치를 조회하고 열린 풀 리퀘스트에 연결합니다.
* 푸시할 때 풀 리퀘스트가 아직 존재할 필요가 없습니다: Claude Code는 같은 디렉토리에서 최대 5개의 나중 `git`, `gh`, `glab` 또는 `curl` 명령이 실행된 후 브랜치 조회를 재시도하므로, 푸시 후 생성된 풀 리퀘스트(Claude가 GitHub REST API를 통해 생성한 것 포함)는 재시도가 이를 찾을 때 연결됩니다.

세션이 둘 이상의 풀 리퀘스트에 연결되면 레이블은 `3 PRs`와 같은 개수를 표시하며, 가장 주의가 필요한 열린 풀 리퀘스트로 색상이 지정됩니다. [엿보기 패널](#peek-and-reply)을 열어 모두 확인합니다.

풀 리퀘스트 번호는 상태에 따라 색상이 지정됩니다:

| 색상 | 풀 리퀘스트 상태 |
| :- | :- |
| 노란색 | 검사 또는 검토 대기 중, 또는 검사 실패 |
| 녹색 | 검사 통과 및 검토 차단 없음 |
| 보라색 | 병합됨 |
| 회색 | 초안 또는 닫힘 |

작업이 풀 리퀘스트로 끝나면 이 레이블에서 결과를 확인합니다: 풀 리퀘스트 번호가 녹색으로 변하면 풀 리퀘스트를 검토하고 병합합니다.

### 엿보기 및 답변

선택된 행에서 `Space`를 눌러 엿보기 패널을 엽니다. 행이 터미널 가장자리에서 자르는 문장으로 열리며, 어떤 문장인지는 세션의 상태에 따라 다릅니다:

* 입력을 기다리는 세션: 요청하는 정확한 질문, 답변 입력 위에 표시
* 완료된 세션: 결과
* 작업 중인 세션: 전체 상태 문장

세션에 연결된 모든 풀 리퀘스트가 다음에 나열됩니다. 입력을 기다리는 세션이나 안전 모드로 실행 중인 세션의 경우 그 아래에 한 줄이 더 표시됩니다:

* `waiting 3m`과 같은 줄: 세션이 입력을 기다린 시간입니다. 행의 오른쪽 가장자리의 나이는 다른 숫자입니다: 세션이 시작된 시점부터 계산됩니다
* `safe mode · customizations are off`: 셸에서 `claude --bg --safe-mode`로 시작했기 때문에 이 세션은 [사용자 지정이 꺼진 상태](https://code.claude.com/docs/ko/debug-your-config.md#test-against-a-clean-configuration)로 실행됩니다. 그대로 두어도 됩니다. 사용자 지정을 다시 켠 상태로 대화를 계속하려면 셸에서 [`claude stop <id>`](#manage-sessions-from-the-shell)를 실행한 다음 [`claude --resume`](https://code.claude.com/docs/ko/sessions#resume-a-session)을 실행합니다

대부분의 경우 엿보기 패널로 충분하며 전체 트랜스크립트를 열 필요가 없습니다.

엿보기 패널에 답변을 입력하고 `Enter`를 눌러 해당 세션으로 전송합니다. 답변 앞에 `!`를 붙여 Bash 명령을 대신 전송합니다. 답변이 어떻게 처리되는지는 세션과 전송하는 내용에 따라 다릅니다:

* 작업 중인 세션: `/model`, `/effort`, `/rename`, `/usage`는 즉시 실행됩니다. 그 외의 답변은 응답을 중단하는 대신 세션의 [메시지 대기열](https://code.claude.com/docs/ko/interactive-mode.md#queue-messages-while-claude-works)에 추가되며, [대기열의 입력이 적용될 때](https://code.claude.com/docs/ko/interactive-mode.md#when-claude-code-sends-what-you-queued) 적용됩니다. 그 밖의 [명령](https://code.claude.com/docs/ko/commands.md)은 세션 자체의 프롬프트에서 입력하자마자 실행되는 명령이라도 턴이 끝날 때까지 기다립니다
* 정확히 `/stop`인 답변: 세션에 전달되는 대신 세션이 작업 중이든 입력을 기다리든 즉시 세션을 중지합니다
* [셸 작업](#run-a-shell-command): `/stop`을 포함한 답변이 입력된 텍스트로 명령의 터미널에 전달됩니다

세션이 입력을 기다리는 경우 엿보기 패널에서 답변하는 방법은 세션이 무엇을 기다리는지에 따라 다릅니다:

* 미리 정의된 선택지가 있는 질문: 패널은 선택지를 번호로 나열합니다. 답변 입력이 비어 있을 때 선택지의 번호를 눌러 채운 다음 `Enter`를 눌러 전송하거나, 대신 직접 답변을 입력합니다
* 미리 정의된 선택지가 없는 질문: 답변을 입력합니다. 빈 입력에 제안된 답변이 표시되면 `Tab`을 눌러 채우고 전송하기 전에 편집합니다
* 권한 프롬프트 또는 [샌드박스](https://code.claude.com/docs/ko/sandboxing.md) 프롬프트나 MCP 서버의 [입력 요청](https://code.claude.com/docs/ko/mcp.md#respond-to-mcp-elicitation-requests)과 같은 다른 대화 상자: 답변으로는 응답되지 않습니다. 답변은 대기열에서 기다립니다. 대화 상자에 응답하려면 `→`로 연결합니다

[`PermissionRequest`](https://code.claude.com/docs/ko/hooks#permissionrequest) 또는 [`PreToolUse`](https://code.claude.com/docs/ko/hooks#pretooluse) 훅이 Claude Code가 세션이 요청하는 호출에 대해 검증할 수 없는 출력을 반환하면 행은 훅 이벤트와 `hook output invalid:`를 보류 중인 요청의 텍스트 앞에 검증 오류와 함께 표시합니다. 다른 방식으로 실패하는 훅의 경우 행은 훅이 실패했다고 표시합니다. 세션은 여전히 동일한 요청을 기다립니다.

답변을 전달할 수 없으면 오류 메시지에 답변이 저장되었는지 여부가 표시됩니다. `!` 또는 `/`로 시작하는 답변은 저장되지 않습니다. Claude Code는 다음에 세션을 다시 시작할 때 저장된 답변을 세션의 다음 프롬프트로 전송합니다. 그 외의 답변은 다시 전송하세요.

[음성 받아쓰기](https://code.claude.com/docs/ko/voice-dictation.md)가 [누르고 있기 모드](https://code.claude.com/docs/ko/voice-dictation.md#hold-to-record)로 활성화된 경우, 답변 입력에 포커스가 있는 동안 푸시-투-톡 키를 누르고 있으면 입력하는 대신 답변을 받아쓸 수 있습니다. 에이전트 뷰 하단의 디스패치 입력에서도 동일하게 작동합니다.

`↑` 및 `↓`를 사용하여 패널을 닫지 않고 인접한 세션을 엿보거나 `→`를 눌러 연결합니다.

### 세션에 연결

선택된 행에서 `Enter` 또는 `→`를 눌러 연결합니다. 에이전트 뷰는 전체 대화형 세션으로 대체됩니다. 연결하면 Claude는 떠나 있는 동안 발생한 일에 대한 짧은 요약을 게시합니다.

연결된 동안 세션은 다른 Claude Code 세션처럼 작동합니다: [명령](https://code.claude.com/docs/ko/commands.md), 키보드 단축키 및 기능 모두 작동하며, 아래의 예외가 있습니다.

연결된 동안 `/install-github-app`과 [`/mcp`](https://code.claude.com/docs/ko/mcp) 설정 목록은 정상적으로 작동합니다. 터미널 앞의 사람이 대화 상자를 완료할 수 있기 때문입니다. 아무도 연결되지 않으면 이 명령은 대화 상자를 열 수 없으므로 세션은 에이전트 뷰의 `Needs input` 아래에 `open this session to manage MCP servers`와 같은 행으로 나타나며, 트랜스크립트 답변도 동일하게 표시됩니다. 연결하고 명령을 다시 실행하여 계속합니다. 입력 필요 행은 연결할 때 지워집니다. `/mcp reconnect <server>`, `/mcp enable` 및 `/mcp disable`은 연결 여부와 관계없이 작동합니다.

연결된 세션은 `tui` 설정과 관계없이 항상 [전체 화면 모드](https://code.claude.com/docs/ko/fullscreen.md)로 렌더링됩니다. 백그라운드 세션에는 추가할 터미널 스크롤백이 없기 때문입니다. `PgUp`, `PgDn` 또는 마우스 휠로 스크롤하고, `Ctrl+O`를 눌러 트랜스크립트 모드로 전환합니다. 터미널의 기본 스크롤 및 tmux 복사 모드는 현재 뷰포트만 표시하며, 이는 전체 화면 애플리케이션을 실행할 때와 동일합니다.

연결된 세션은 [터미널에 상태를 보고](https://code.claude.com/docs/ko/terminal-config.md#see-session-status-in-your-terminal)하지 않습니다.

빈 프롬프트에서 `←`를 누르거나 `/exit`를 실행하여 분리하고 에이전트 뷰로 돌아갑니다. 에이전트 뷰에서 세션을 열었는지 또는 셸에서 `claude attach <id>`로 실행했는지 여부와 관계없이 동일하게 작동합니다.

`←`는 [`/btw` 오버레이](https://code.claude.com/docs/ko/interactive-mode#side-questions-with-%2Fbtw)가 열려 있을 때도 분리됩니다. Claude Code v2.1.257 이상이 필요합니다. 여전히 답변 중인 부가 질문은 떠나 있는 동안 계속 실행됩니다. 다음에 연결할 때 오버레이는 해당 질문 또는 그 답변과 함께 다시 열립니다.

Windows에서 연결 후 약 0.5초 이내에 `←`를 누르면 Claude Code는 `Ambiguous ←, press again to detach`를 표시합니다. 이 기간 동안 터미널이 연결 전의 누름을 다시 전달할 수 있기 때문입니다. 분리하려면 `←`를 다시 누릅니다.

`Ctrl+Z`도 분리하지만 시작한 위치로 돌아갑니다: 에이전트 뷰에서 연결한 경우 에이전트 뷰, 또는 `claude attach`를 실행한 경우 셸입니다. 대화 상자가 포커스를 가지고 있고 `←`에 응답하지 않을 때 `Ctrl+Z`를 사용합니다.

`Ctrl+C`는 연결된 동안 표준 인터럽트 동작을 유지합니다: 분리하는 대신 실행 중인 응답 또는 `!` 셸 명령을 취소합니다. 빈 프롬프트에서 `Ctrl+C`를 두 번 누르면 분리됩니다.

분리는 백그라운드 세션을 중지하지 않습니다: `←`, `Ctrl+Z`, `/exit`, 그리고 이중 `Ctrl+C` 또는 이중 `Ctrl+D`는 모두 실행 상태로 둡니다. `/loop`가 다음 반복을 기다리는 동안 분리하면 루프는 계속 실행되며 해당 반복은 사용자 없이 일정대로 시작됩니다. 분리하기 전에 루프를 중지하려면 [루프 중지](https://code.claude.com/docs/ko/scheduled-tasks.md#stop-a-loop)를 참조하세요. 세션 내에서 세션을 종료하려면 `/stop`을 실행합니다.

#### 터미널을 떠나지 않고 세션 전환

포그라운드에서 실행 중인 세션, 즉 에이전트 뷰에서 연결한 것이 아니라 터미널에서 시작한 세션에서 빈 프롬프트에서 `←`를 누르면 세션을 백그라운드로 보내고 해당 행이 선택된 상태로 에이전트 뷰를 열어 터미널을 떠나지 않고 세션을 전환할 수 있습니다. 동일한 단일 누름이 연결된 세션을 분리합니다.

프롬프트의 마지막 텍스트를 삭제하거나 프롬프트 기록을 이동한 직후 `←`를 누르면 Claude Code는 확인을 요청합니다: 첫 번째 누름은 `Press ← again to open agents`를 표시하거나, 연결된 세션에서 `Press ← again to go back to agents`를 표시하고, 두 번째 누름이 전환합니다.

`←`가 포그라운드 세션을 백그라운드로 보낼 때 에이전트 뷰는 목록 위에 `Your conversation moved to the background`를 표시하며, 해당 세션의 행이 이미 선택되어 있습니다. 거기에서:

* `Enter`를 눌러 대화를 다시 엽니다.
* `Esc`를 눌러 전환을 취소하고 대화로 돌아갑니다. `Esc`가 `Still starting — try again in a moment`를 표시하면 백그라운드 세션이 아직 준비되지 않았으므로 잠시 후 `Esc`를 다시 누릅니다.
* `Ctrl+C`를 두 번 눌러 셸로 종료합니다.

Claude Code가 대화를 다시 열 수 없으면 종료하고 대화를 재개하는 `claude --resume` 명령을 인쇄합니다.

[Claude의 작업 목록](https://code.claude.com/docs/ko/interactive-mode.md#task-list)은 대화와 함께 백그라운드 세션으로 이동하므로 해당 행으로 돌아갈 때 체크리스트가 그대로 유지됩니다.

`←`를 누른 행은 화살표 키 또는 마우스로 선택을 이동한 후에도 굵고 흐릿하지 않은 이름을 유지하므로 어느 세션에서 왔는지 알 수 있습니다.

도구가 실행 중일 때 `←`를 누르면 Claude Code는 도구가 완료될 때까지 기다린 후 백그라운드로 보내며, Claude는 백그라운드 세션에서 응답을 계속합니다. 대신 기다리지 않고 즉시 백그라운드로 보내려면 `←`를 다시 누릅니다. 진행 중인 백그라운드 작업을 백그라운드 세션으로 이월할 수 없으면 Claude Code는 [`/background`](#from-inside-a-session)와 마찬가지로 `Background this session?` 대화 상자를 먼저 표시합니다.

약 10초가 지나면 Claude Code는 더 이상 기다리지 않고 세션을 백그라운드로 보냅니다. 단, 다음과 같은 경우는 예외입니다:

* **포그라운드 서브에이전트가 아직 실행 중인 경우**: Claude Code는 Claude가 시작한 [포그라운드 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#run-subagents-in-foreground-or-background)의 작업이 이어지도록 계속 대기하며 `Still backgrounding after the current tool`을 표시합니다. 기다리지 않고 백그라운드로 전환하려면 `←`를 다시 누릅니다. 이 경우 해당 서브에이전트는 처음부터 다시 시작됩니다.
* **권한 프롬프트 또는 질문이 답변을 기다리는 경우**: 권한 프롬프트나 Claude가 한 질문이 대기하는 동안 Claude Code는 계속 기다리며 `Still backgrounding after the current tool — a question is waiting for your answer.`를 표시합니다. 권한 프롬프트에서 **Yes**를 선택하는 것처럼 답변으로 턴이 계속되면 Claude Code는 현재 도구가 완료될 때 세션을 백그라운드로 보냅니다.
* **프롬프트 입력에 텍스트를 입력하는 경우**: 미전송 텍스트는 터미널의 입력 상자에 남아 있고 백그라운드 세션으로 이동하지 않으므로 Claude Code는 전환을 취소합니다. 이때 `Backgrounding cancelled — you have unsent text in the input. Send it or clear it, then press ← again.`를 표시합니다. Claude는 포그라운드에서 계속 작업합니다.
* **턴을 중지하는 경우**: Claude Code는 전환을 취소하고 `Backgrounding cancelled — the turn was stopped.`를 표시합니다. 예를 들어 [`Esc`로 Claude를 중단](https://code.claude.com/docs/ko/interactive-mode#general-controls)하거나, 메인 대화의 권한 프롬프트에서 [코멘트 없이](https://code.claude.com/docs/ko/permissions.md#add-a-comment-when-you-answer-a-permission-prompt) **No**를 선택하거나, 메인 대화에서 Claude가 한 질문에 `Esc`를 누르면 턴이 중지됩니다. 세션을 백그라운드로 보내려면 `←`를 다시 누릅니다.
* **대기열의 메시지를 이동할 수 없는 경우**: [Claude가 작업하는 동안 대기열에 추가한](https://code.claude.com/docs/ko/interactive-mode.md#queue-messages-while-claude-works) 메시지는 대화와 함께 백그라운드 세션으로 이동합니다. 그중 하나라도 이동할 수 없으면 세션은 포그라운드에 남고 Claude Code는 `Cannot open agents — 1 queued message can't move to the background. Press ← again once Claude has read it.`와 같은 알림을 표시합니다.

Claude Code가 약 10초 후 또는 `←`를 다시 누른 후 세션을 백그라운드로 보낼 때, Claude가 아직 포그라운드에서 실행 중인 셸 명령은 중지됩니다. Claude Code는 해당 명령에 대해 `Background this session?` 대화 상자를 표시하지 않습니다. 백그라운드 세션에서 Claude에게는 해당 명령이 시작되었다는 기록이 없으므로 Claude가 명령을 다시 실행할 수 있습니다. 세션이 이동할 때 명령을 계속 실행하려면 Claude Code가 아직 기다리는 동안 `Ctrl+B`를 눌러 [백그라운드 명령으로 전환](https://code.claude.com/docs/ko/interactive-mode.md#background-bash-commands)합니다.

`←`를 누르면 대화에 메시지가 아직 없을 때도 세션의 행이 생성되므로 `→`로 여전히 해당 세션으로 돌아갈 수 있습니다.

`/config`에서 [`leftArrowOpensAgents`](https://code.claude.com/docs/ko/settings-reference#leftarrowopensagents) 설정으로 포그라운드 세션의 이 단축키를 끌 수 있습니다.

##### 세션이 백그라운드로 이동할 때 전송된 프롬프트

세션이 백그라운드로 이동하는 순간 프롬프트나 `!` 셸 명령을 입력하면 중지되거나 전송되지 않은 채로 남습니다:

* **대화가 닫힐 때 전송된 경우**: 대화가 닫히고 에이전트 뷰가 열릴 때 응답 또는 명령이 중지됩니다
* **그 순간 아직 [훅](https://code.claude.com/docs/ko/hooks.md)을 기다리는 경우**: 프롬프트가 전송되지 않으며, 화면에는 이를 알리는 표시가 없습니다. [`SessionStart` 훅](https://code.claude.com/docs/ko/hooks#sessionstart)이 아직 실행 중일 때 입력한 프롬프트도 이에 해당합니다

두 경우 모두 입력한 텍스트는 [프롬프트 기록](https://code.claude.com/docs/ko/interactive-mode.md#command-history)에 유지됩니다. 다시 전송하려면 백그라운드로 보낸 세션을 열고 프롬프트에서 `↑`를 눌러 텍스트를 다시 불러옵니다.

### 목록 구성

에이전트 뷰는 입력이 필요한 세션이 맨 위에 오도록 세션을 그룹화하며, `Ready for review`와 `Needs input`이 `Working`과 `Completed` 위에 있습니다. 이 그룹 이름은 위의 [상태](#read-session-state)와 일대일로 대응하지 않습니다: 세션에 검토가 필요하거나 검사가 실패한 열린 풀 리퀘스트가 있으면 `Ready for review`로 이동하고, `Completed`는 완료된 세션, 실패한 세션, 중지된 세션을 함께 모읍니다.

`Ctrl+S`를 눌러 대신 디렉토리별로 그룹화합니다. 선택 사항은 실행 간에 유지됩니다.

그룹 내에서:

* `Ctrl+T`를 눌러 세션을 맨 위에 고정하고 [유휴 상태일 때 프로세스를 계속 실행](#the-supervisor-process)합니다
* `Shift+↑` 또는 `Shift+↓`를 눌러 세션 순서 변경
* `Ctrl+R`을 눌러 세션 이름 바꾸기
* 그룹 헤더에서 `Enter`를 눌러 축소. 단, [필터](#filter-sessions)가 활성화된 동안에는 모든 그룹이 펼쳐진 상태로 유지됩니다
* `Ctrl+X`를 눌러 세션을 중지하고 2초 이내에 `Ctrl+X`를 다시 눌러 목록에서 삭제하거나, `Esc`를 눌러 삭제하지 않고 확인을 닫습니다. 두 번째 누름은 예를 들어 [백그라운드 서비스가 응답하지 않아](#agent-view-says-the-background-service-did-not-respond) 중지 시도가 실패할 때도 세션을 삭제합니다. 이 경우 확인은 2초 더 활성 상태로 유지되고, 삭제는 세션의 프로세스를 직접 종료합니다

그룹 헤더에서 `Ctrl+X`를 누르면 확인 후 해당 그룹의 모든 세션이 삭제됩니다. [세션 삭제가 제거하는 것](#what-deleting-a-session-removes)에서 다루는 유지되는 경우를 제외하고, 삭제하면 세션이 목록에서 제거됩니다. Claude가 세션을 위해 생성한 worktree는 삭제 방법과 worktree가 보유한 내용에 따라 제거, 유지 또는 제자리에 남겨집니다. 대화 트랜스크립트는 로컬 머신에 남아 있으며 `claude --resume`을 통해 사용할 수 있습니다.

화면에 맞지 않는 완료된 세션은 `… N more` 행으로 접힙니다. `Completed` 그룹은 라이브 그룹 이후 남은 수직 공간을 채웁니다. 짧은 터미널에서는 헤더가 단일 요약 줄로 압축되므로 작업 중이거나 입력이 필요한 세션이 계속 표시됩니다.

#### 과거 세션 다시 가져오기

세션을 다시 가져오려면 [디스패치 입력](#dispatch-an-agent-from-agent-view)에 `/resume`을 입력합니다. 피커가 열리며 에이전트 뷰를 연 저장소의 과거 세션이 최신순으로 표시되며, 목록에서 삭제한 세션을 포함합니다. 이미 행이 있는 세션은 나열되지 않습니다. `Enter`를 눌러 선택된 세션을 백그라운드 세션으로 재개하면 목록에 행으로 다시 추가됩니다.

다음과 같은 경우 `/resume`은 `isn't available in agent view`와 함께 실패합니다:

* `/resume`이 id 또는 검색어를 지정하는 경우
* 뷰가 `--cwd`로 범위가 지정된 경우
* 뷰가 [`--safe-mode`](https://code.claude.com/docs/ko/cli-reference#cli-flags)로 시작된 경우
* 뷰가 `--permission-mode` 또는 `--settings`와 같은 플래그로 열린 경우

`/resume` 뒤에 무언가를 입력했다면 그 부분 없이 다시 입력합니다. 이러한 플래그 중 하나를 사용했다면 셸에서 해당 플래그 없이 `claude agents`를 실행한 다음 `/resume`만 입력합니다.

### 세션 필터링

디스패치 입력을 다음 필터 중 하나로 시작하면 입력하는 동안 목록이 좁혀집니다:

| 필터 | 표시 |
| :- | :- |
| `a:<name>` | 명명된 에이전트를 실행하는 세션 |
| `s:<state>` | 주어진 상태의 세션(예: `s:working`) 또는 주어진 그룹 헤더 아래의 세션(예: `Ready for review`의 경우 `s:ready`). `s:blocked`는 입력을 기다리는 모든 세션을 나열합니다 |
| `n:<text>` | 이름 또는 첫 번째 프롬프트에 해당 텍스트가 포함된 세션(예: `n:login`). Claude Code v2.1.287 이상이 필요합니다 |
| `o:<text>` | 결과에 해당 텍스트가 포함된 세션(예: `o:merged`). `o:`만 입력하면 결과를 보고한 모든 세션이 나열됩니다 |
| `#1234`와 같은 풀 리퀘스트 또는 병합 요청 번호, 또는 그 URL | 해당 풀 리퀘스트 또는 병합 요청에서 작업하는 세션 |
| 다른 URL | 첫 번째 프롬프트에 해당 URL이 포함된 세션 |

필터를 결합하려면 `a:`, `s:`, `n:` 또는 `o:`로 시작하고 공백으로 구분하여 더 추가합니다. 목록은 모든 필터와 일치하는 세션을 표시합니다. 예를 들어 `s:blocked a:reviewer`는 입력을 기다리는 `reviewer` 세션을 나열합니다.

필터가 활성화된 동안 축소한 그룹은 일치 항목을 표시하도록 펼쳐지고 일치 항목이 선택되므로 `Enter`를 누르면 이를 엽니다. 입력을 지우면 필터가 제거되고 해당 그룹은 다시 축소됩니다.

### 키보드 단축키

에이전트 뷰에서 `?`를 눌러 단축키를 상황에 맞게 확인합니다. 아래 표는 이를 요약합니다.

| 단축키 | 작업 |
| :- | :- |
| `↑` / `↓` | 행 간 이동 |
| `PgUp` / `PgDn` | 한 화면 분량의 행만큼 위 또는 아래로 이동 |
| `Home` / `End` | 첫 번째 또는 마지막 행으로 이동 |
| `Enter` | 선택된 세션에 연결하거나, 입력의 텍스트가 [필터](#filter-sessions)가 아니면 이를 제출 |
| `Space` | 선택된 세션의 엿보기 패널 열기 또는 닫기 |
| `Shift+Enter` | 디스패치 입력에 줄 바꿈 삽입, [메인 프롬프트처럼](https://code.claude.com/docs/ko/terminal-config.md#enter-multiline-prompts) |
| `Ctrl+Enter` | 디스패치하고 즉시 연결, `?` 오버레이가 `ctrl+enter to start and open`을 나열하는 터미널에서 |
| `→` | 선택된 세션에 연결 |
| `Alt+1`..`Alt+9` | 포커스된 세션의 디렉토리에서 세션 1–9에 연결 |
| `Tab` | 빈 입력에서 모든 서브에이전트 탐색. 그 외에는 강조된 제안 적용 |
| `Ctrl+S` | 상태와 디렉토리 간 그룹화 전환 |
| `Ctrl+T` | 선택된 세션 고정 또는 고정 해제 |
| `Ctrl+F` | [`n:` 필터](#filter-sessions)로 이름으로 세션 찾기 |
| `Alt+↑` / `Alt+↓` | 이전 또는 다음 그룹 헤더로 이동 |
| `Ctrl+R` | 선택된 세션 이름 바꾸기 |
| `Ctrl+G` | `$VISUAL` 또는 `$EDITOR`에서 디스패치 프롬프트 열기 |
| `Ctrl+J` | 디스패치 입력에 줄 바꿈 삽입 |
| `Ctrl+X` | 세션 중지; 2초 이내에 다시 눌러 삭제 |
| `Shift+↑` / `Shift+↓` | 선택된 세션 순서 변경 |
| `Esc` | 엿보기 패널 닫기, 입력 지우기 또는 종료. `←`로 세션을 백그라운드로 보내 에이전트 뷰를 연 경우 최종 `Esc`는 종료 대신 해당 대화로 돌아갑니다. [vim 편집기 모드](https://code.claude.com/docs/ko/interactive-mode.md#vim-editor-mode)가 켜져 있으면 입력에서 `Esc`를 누르면 메인 프롬프트처럼 INSERT에서 NORMAL 모드로 전환되고 텍스트가 유지됩니다 |
| `Ctrl+C` | 입력 지우기; 두 번 눌러 종료. 화면의 텍스트가 선택된 동안에는 대신 선택을 해제하며, [선택 시 이미 복사된](https://code.claude.com/docs/ko/settings-reference.md#copyonselect) 경우가 아니면 먼저 복사합니다 |
| `?` | 단축키 표시 |

[`Agents` 컨텍스트](https://code.claude.com/docs/ko/keybindings#agents-actions)에 작업이 있는 단축키는 [`keybindings.json`](https://code.claude.com/docs/ko/keybindings)을 따릅니다. `Ctrl+G`도 `Chat` 컨텍스트의 `chat:externalEditor` 바인딩을 통해 마찬가지로 따릅니다.

## 새로운 에이전트 디스패치

에이전트 뷰에서 새로운 백그라운드 세션을 디스패치하거나, 기존 대화형 세션을 백그라운드로 보내거나 복사하거나, 셸에서 직접 시작할 수 있습니다.

### 에이전트 뷰에서 에이전트 디스패치

에이전트 뷰 하단의 입력 필드에 프롬프트를 입력하고 `Enter`를 눌러 새로운 백그라운드 세션을 시작합니다. 세션은 프롬프트에서 자동으로 이름이 지정되며, 나중에 `Ctrl+R`로 이름을 바꿀 수 있습니다.

자동 이름은 [Haiku-class 모델](https://code.claude.com/docs/ko/model-config.md)에서 작성한 짧은 레이블입니다. 세션이 나중에 받는 이름도 해당 행에 표시되며, 여기에는 해당 세션에서 [플랜을 수락](https://code.claude.com/docs/ko/permission-modes.md#review-and-approve-a-plan)할 때 세션이 받는 [생성된 제목](https://code.claude.com/docs/ko/sessions.md#name-your-sessions)이 포함됩니다.

이미지를 프롬프트에 붙여넣어 작업과 함께 스크린샷이나 다이어그램을 포함할 수 있습니다.

800자를 초과하거나 3줄을 넘는 붙여넣은 텍스트는 입력이 한 줄로 유지되도록 `[Pasted text #N]` 플레이스홀더로 축소됩니다. 전체 텍스트는 디스패치할 때 전송됩니다. 디스패치하기 전에 축소된 텍스트를 검토하거나 편집하려면 동일한 텍스트를 다시 붙여넣으면 플레이스홀더가 입력으로 다시 확장됩니다.

프롬프트의 일부를 접두사로 붙이거나 언급하여 세션이 시작되는 방식을 제어합니다:

| 입력 | 효과 |
| :- | :- |
| `<agent-name> <prompt>` | 첫 번째 단어가 사용자 정의 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md) 이름과 일치하면, 해당 서브에이전트가 frontmatter의 구성으로 세션의 주 에이전트로 실행됩니다 |
| `@<agent-name>` | 프롬프트의 어디든지 사용자 정의 서브에이전트를 언급하여 주 에이전트로 실행합니다 |
| `@<repo>` | 저장소를 언급하여 해당 위치에서 세션을 실행합니다. 어떤 저장소가 나열되는지는 [특정 디렉터리로 디스패치](#dispatch-to-a-specific-directory)를 참조하세요 |
| `/<command>` | [스킬](https://code.claude.com/docs/ko/skills.md) 및 [명령](https://code.claude.com/docs/ko/commands.md)을 제안하여 프롬프트로 디스패치합니다 |
| `! <command>` | Claude 세션을 시작하는 대신 셸 명령을 백그라운드 작업으로 실행합니다. 작업은 연결하고, 감시하고, 분리할 수 있는 행으로 나타납니다 |
| `#<number>` 또는 풀 리퀘스트나 병합 요청 URL | 세션이 이미 해당 풀 리퀘스트 또는 병합 요청에서 작업 중이면, Claude Code는 새 세션을 디스패치하는 대신 해당 행을 선택합니다 |

일부 명령은 디스패치하는 대신 에이전트 뷰 자체에서 실행됩니다:

* `/exit` 및 `/quit`는 에이전트 뷰를 닫습니다
* `/logout`은 로그아웃합니다
* `/model`, `/effort`, `/fast`는 [다음에 디스패치하는 세션이 시작할 때 사용할 값](#set-the-model-effort-and-fast-mode)을 설정합니다. `/effort`와 `/fast`는 Claude Code v2.1.299 이상이 필요합니다.
* `/login`은 세션에 연결하지 않고 다시 로그인할 수 있도록 로그인 대화 상자를 엽니다
* 인수 없는 `/resume` 또는 그 별칭 `/continue`는 저장소의 과거 세션 선택기를 열어 하나를 백그라운드 세션으로 [다시 가져옵니다](#bring-back-a-past-session)

스킬, 사용자 정의 명령, 그리고 `/init`과 같은 프롬프트 확장 기본 제공 명령은 새로운 백그라운드 세션에 첫 번째 프롬프트로 전송됩니다. `isn't available in agent view` 힌트는 입력한 기본 제공 명령이 실행되지 않았음을 의미합니다. 이를 실행하려면 [세션에 연결](#attach-to-a-session)하여 그곳에서 입력합니다. 입력한 모든 내용이 힌트 옆의 입력에 남아 있으므로 편집할 수 있습니다.

반복되는 작업을 [스킬](https://code.claude.com/docs/ko/skills.md)로 패키징하면 프롬프트를 다시 입력하지 않고도 에이전트 뷰에서 동일한 워크플로를 반복적으로 시작할 수 있습니다.

동일한 `@name`이 서브에이전트와 형제 저장소 모두와 일치하면 서브에이전트가 우선합니다. 단순 첫 단어 일치도 적용되므로, 서브에이전트 이름 중 하나로 시작하는 프롬프트는 단어를 일반 텍스트로 취급하는 대신 해당 서브에이전트를 디스패치합니다. 명시적으로 하려면 `@` 형식을 사용하거나, 일치를 피하려면 프롬프트를 다른 단어로 시작합니다.

#### 특정 디렉터리로 디스패치

새로운 세션은 에이전트 뷰를 연 디렉터리에서 실행됩니다. 다른 디렉터리를 대상으로 하려면 다음 중 하나를 사용합니다:

* 해당 디렉터리에서 `claude agents`를 엽니다.
* 상위 디렉터리에서 `claude agents`를 열고 프롬프트에서 `@<repo>`로 하위 저장소를 언급합니다. `@`를 입력하면 다음 대상이 나열됩니다:

  * 시작 디렉터리 한 수준 아래의 Git 저장소
  * 시작한 저장소의 등록된 [git worktree](https://code.claude.com/docs/ko/worktrees.md) 중 해당 디렉터리 트리 안에 있는 것(예: Claude가 `.claude/worktrees/` 아래에 생성한 것)이며, 체크아웃된 브랜치로 레이블이 지정됩니다. `git worktree add ../feature`와 같이 저장소 외부에 추가된 워크트리는 나열되지 않습니다
  * 이미 목록에 세션이 있는 모든 디렉터리

  이름에 공백이 포함된 디렉터리는 나열되지 않습니다.
* 셸에서 `cd`로 디렉터리로 이동하고 `claude --bg "<prompt>"`를 실행합니다.

에이전트 뷰가 디렉터리별로 그룹화되면, 디스패치는 선택한 행의 디렉터리로 프롬프트를 보내므로, 경로를 다시 입력하지 않고도 그룹을 선택하고 그 안으로 디스패치할 수 있습니다.

### 세션을 백그라운드로 보내기 또는 복사

두 명령은 현재 세션의 작업을 백그라운드로 이동합니다. `/background`는 현재 대화를 백그라운드로 보내고 터미널을 해제하며, `/fork`는 복사본을 보내고 사용자는 현재 위치에서 계속 작업합니다.

#### 세션을 백그라운드로 보내기

`/background` 또는 그 별칭 `/bg`를 실행하여 현재 대화를 백그라운드 세션으로 이동합니다. `/bg run the test suite and fix any failures`와 같은 프롬프트를 전달하면 먼저 지시사항을 하나 더 제공할 수 있습니다. `/bg`를 실행할 때 Claude가 응답 중이면, 응답은 백그라운드 세션에서 계속됩니다.

서브에이전트, 백그라운드 셸 명령, 워크플로, 또는 [모니터](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool)와 같은 백그라운드 작업이 여전히 실행 중인 세션을 종료하면, 즉시 종료하는 대신 `Background work is running` 대화 상자가 표시됩니다. `/background`와 동일한 방식으로 세션을 백그라운드로 이동하고 셸로 돌아가려면 `Move to background and exit`를 선택합니다. 에이전트 뷰가 [꺼져 있으면](#turn-off-agent-view) 이 옵션은 표시되지 않습니다.

목록의 백그라운드 세션이 이미 대화의 이름을 가지고 있으면, Claude Code는 새 행의 이름에 `my-session (2)`와 같이 번호를 매기고 기존 행의 이름은 그대로 둡니다. 새 행의 이름을 바꾸려면 에이전트 뷰에서 선택하고 `Ctrl+R`을 누릅니다.

#### /fork로 세션 복사

`/fork`를 실행하면 원본이 계속 실행되는 동안 현재 대화를 새로운 백그라운드 세션으로 복사합니다. 복사본은 그 시점까지의 대화 내용을 모두 가지고 시작합니다. 복사본이 실행되는 위치는 아래 목록을 참조하세요. 또한 모델, 권한 모드, effort 수준, 그리고 세션 중에 추가한 모든 디렉터리 또는 "다시 묻지 않기" 권한 부여도 이어받습니다. 복사본은 에이전트 뷰에서 별도의 행으로 나타납니다.

분기 후 두 대화는 독립적입니다. 복사본이 하는 일은 자동으로 원본 대화에 들어가지 않습니다. 다만 [교차 세션 메시징](https://code.claude.com/docs/ko/cross-session-messaging.md)이 활성화된 세션에서는 어느 세션의 Claude든 명시적으로 다른 세션에 메시지를 보낼 수 있습니다.

[에이전트 뷰가 꺼져 있으면](#turn-off-agent-view), `/fork`는 세션을 복사하는 대신 [분기된 서브에이전트](https://code.claude.com/docs/ko/sub-agents.md#fork-the-current-conversation)를 시작합니다.

##### 복사본에 프롬프트를 보내고 세션 열기

`/fork open a draft pull request with the work so far`와 같은 프롬프트를 전달하면 복사본이 즉시 작업을 시작합니다. 프롬프트가 없으면 복사본은 첫 번째 지시사항을 기다립니다. `claude agents`에서 해당 행을 선택하고 `Space`를 눌러 지시사항을 보내거나, `claude attach <id>`를 실행합니다. 기다리는 동안 선택한 행에는 `space to send it a prompt`가 표시됩니다.

`/fork` 확인 메시지는 복사본의 상태(예: `session running`), 에이전트 뷰 행의 이름, 그리고 `claude attach`에 사용할 세션 ID를 보여주는 한 줄입니다. 이름을 클릭하면 복사본으로 전환됩니다. 이 세션은 `←`를 누른 것과 동일하게 백그라운드로 이동하고, 에이전트 뷰가 복사본의 세션을 엽니다.

##### 복사본이 실행되는 위치

복사본이 [제자리에서 편집](#how-file-edits-are-isolated)하는 경우를 제외하고, Claude Code는 코드를 변경하기 전에 자체 워크트리를 생성하도록 복사본에 지시합니다. git 저장소 외부에서는 훅으로 생성된 워크트리에서 빠져나온 복사본만 이 지시를 받으며, [`WorktreeCreate` 훅](https://code.claude.com/docs/ko/hooks#worktreecreate)이 없으면 복사본은 제자리에서 편집합니다. 사용자의 워크트리에서 빠져나온 복사본은 격리 설정과 관계없이 해당 워크트리를 편집하거나, 그 안에서 명령을 실행하거나, 그 안으로 들어가지 말라는 지시도 받습니다.

복사본이 시작되는 위치는 현재 세션이 실행 중인 위치에 따라 다릅니다:

* 디스패치된 다른 세션과 마찬가지로, 복사본은 [파일을 편집하기 전에 자체 워크트리로 이동합니다](#how-file-edits-are-isolated). 이 경우 확인 메시지는 복사본이 실행되는 위치를 언급하지 않습니다.
* 세션이 시작된 후 연결된 [워크트리](https://code.claude.com/docs/ko/worktrees.md)로 이동한 경우, 복사본은 이동 전 세션이 있던 위치에서 시작하며, [제자리에서 편집](#how-file-edits-are-isolated)하지 않는 한 그곳의 자체 워크트리에서 코드를 변경합니다. 사용자의 워크트리가 브랜치에 체크아웃되어 있으면, 해당 지시는 작업이 사용자의 작업을 기반으로 하는 복사본에게 새 브랜치를 사용자의 브랜치 기반으로 만들라고도 알립니다. 사용자의 브랜치는 사용자의 워크트리에 체크아웃된 상태로 유지되기 때문입니다. 확인 메시지는 `runs in the origin tree`로 끝납니다.
* 메인 작업 트리가 있는 저장소의 연결된 워크트리 안에서 세션을 시작한 경우, 복사본은 해당 메인 작업 트리에서 시작하며, 자체 워크트리 규칙은 동일하지만 브랜치 지시는 없습니다. 여기서도 확인 메시지는 `runs in the origin tree`로 끝납니다.
* 베어 저장소 레이아웃의 워크트리 안에서 시작한 세션은 돌아갈 메인 작업 트리가 없으므로, 복사본은 제자리에 머물며 확인 메시지는 `edits this checkout`으로 끝납니다. 연결된 워크트리 안에 있지 않은 세션에서 워크트리 격리가 [꺼져 있을](#how-file-edits-are-isolated) 때도 같은 메모가 표시됩니다. 이 경우 복사본이 사용자가 열어 둔 파일을 편집하기 때문입니다.

##### 분기할 수 없는 세션

대체된 시스템 프롬프트나 `--tools` 허용 목록처럼 복사본이 상속하지 않는 시작 플래그로 시작한 세션은 분기할 수 없습니다. Claude Code는 부분 복사본을 만드는 대신 그 사실을 알립니다. 에이전트 뷰에서 디스패치된 세션은 정상적으로 분기됩니다. 복사본은 원래 세션과 동일한 [에이전트 정의](https://code.claude.com/docs/ko/sub-agents.md) 및 추가된 지시사항으로 시작됩니다.

#### 백그라운드로 이동할 때 이어지는 것

세션을 백그라운드로 보내면, 진행 중인 백그라운드 작업은 종류에 따라 백그라운드 세션으로 이어지거나, Claude가 그곳에서 다시 시작할 때만 계속되거나, 중지됩니다:

* **이어짐**: 실행 중인 백그라운드 셸 명령, 백그라운드로 보낸 서브에이전트, [`/loop`](https://code.claude.com/docs/ko/scheduled-tasks)로 생성한 예약 작업, 그리고 Claude의 [아티팩트 댓글에 대한 자동 회신](https://code.claude.com/docs/ko/artifacts.md#let-claude-reply-to-comments-on-its-own)은 백그라운드 세션에서 계속 실행됩니다. 서브에이전트는 자신이 시작한 모든 것과 함께 이동하므로, 그 작업이 모두 이동할 수 있을 때만 이어집니다.
* **Claude가 다시 시작할 때만 계속됨**: 실행 중인 [동적 워크플로](https://code.claude.com/docs/ko/workflows.md). 백그라운드 세션을 확인했을 때 워크플로가 계속되지 않았다면 [Claude에게 다시 시작하도록 요청합니다](#dynamic-workflows-when-you-background).
* **중지됨**: 실행 중인 [모니터](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool)처럼 백그라운드 세션으로 이동할 수 없는 작업. 이러한 작업이 실행 중이면 Claude Code는 `Background this session?` 대화 상자를 표시하여 작업을 중지하기 전에 확인할 수 있게 합니다. 모니터를 소유한 백그라운드 서브에이전트는 모니터와 함께 중지됩니다.

백그라운드로 이동한 후 세션은 새로운 서브에이전트, 모니터, 백그라운드 명령을 시작할 수 있으며, 이들은 이후 분리 및 재연결 후에도 계속 실행됩니다.

원래 시작할 때의 구성 플래그는 백그라운드 세션으로 이어지므로, 해당 MCP 서버, 설정, 폴백 모델이 계속 적용됩니다:

* `--mcp-config` 및 `--strict-mcp-config`
* `--settings`
* `--setting-sources`
* `--add-dir`
* `--plugin-dir`
* `--fallback-model`
* `--allow-dangerously-skip-permissions`

세션 중에 [`/add-dir`](https://code.claude.com/docs/ko/permissions#additional-directories-grant-file-access-not-configuration)로 추가한 디렉터리도 이어집니다. `--allow-dangerously-skip-permissions`가 이어지면 백그라운드 세션에서 `bypassPermissions`에 도달할 수 있지만, 새로운 권한을 부여하지는 않습니다. 이 모드는 여전히 [우회 면책 조항에 대한 사용자의 수락](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode) 기록이 필요합니다.

##### 백그라운드로 이동할 때의 동적 워크플로

세션을 백그라운드로 보낸 후 [동적 워크플로](https://code.claude.com/docs/ko/workflows.md)가 계속되지 않았다면, Claude에게 [워크플로를 다시 시작하도록](https://code.claude.com/docs/ko/workflows.md#resume-after-you-leave-the-session) 요청합니다. 실행은 Claude가 백그라운드 세션에서 다시 시작할 때만 계속되며, Claude Code는 먼저 해당 재시작을 승인하도록 요청할 수 있습니다. 세션의 대화에는 워크플로가 `could not be resumed`라는 알림이 표시됩니다.

Claude가 워크플로를 다시 시작하면, 세션을 백그라운드로 보냈을 때 아직 실행 중이던 서브에이전트는 처음부터 다시 시작되어 토큰을 다시 소비합니다. 아직 실행 중인 서브에이전트가 있을 때 `←`를 누르거나 `/background`를 실행하면, `Background this session?` 대화 상자에 그 수가 표시됩니다. 먼저 완료되도록 하려면 `Stay`를 선택합니다.

### 셸에서 에이전트 디스패치

`--bg` 또는 그 긴 형식 `--background`를 전달하여 바로 백그라운드로 가는 세션을 시작합니다:

```bash theme={null}
claude --bg "investigate the flaky SettingsChangeDetector test"
```

프롬프트는 `-p` 값이 아닌 위치 인수입니다. Claude Code는 세션이 생성되기 전에 `-p` 또는 `--print`와 결합된 `--bg`를 거부합니다. `--print`는 `claude agents`가 연결하는 대화형 세션을 시작하지 않기 때문입니다.

[신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)하지 않은 디렉터리의 터미널에서 `claude --bg`를 실행하면, 워크스페이스 신뢰 대화 상자가 먼저 나타나고 수락하면 세션이 시작됩니다. 거부하면 Claude Code는 세션을 시작하지 않고 종료합니다. 스크립트처럼 대화 상자가 나타날 수 없는 곳에서는 명령이 대신 [`Workspace not trusted`](https://code.claude.com/docs/ko/errors#workspace-not-trusted-when-dispatching-a-background-session) 오류로 종료됩니다.

`code-reviewer`처럼 직접 정의한 특정 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)를 세션의 주 에이전트로 실행하려면 `--bg`를 `--agent`와 결합합니다:

```bash theme={null}
claude --agent code-reviewer --bg "address review comments on PR 1234"
```

이름이 서브에이전트와 일치하지 않으면 시작이 실패합니다. Claude Code는 `no agent named` 경고를 출력하고 여전히 세션을 백그라운드로 보냈다고 보고하지만, 세션은 `--agent '<name>' not found` 오류로 즉시 종료됩니다.

백그라운드 세션이 나중에 재개되거나 재시작될 때, Claude Code는 에이전트와 해당 도구 제한을 복원합니다. 시스템 프롬프트에 대해서는 [재개된 대화의 시스템 프롬프트 플래그](https://code.claude.com/docs/ko/cli-reference.md#system-prompt-flags-in-resumed-conversations)를 참조하세요. 사용자가 [해당 워크스페이스를 신뢰](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)했다면 세션 자체의 디렉터리에서 에이전트를 먼저 검색하므로, 다른 디렉터리에서 세션을 재개해도 프로젝트 범위 에이전트가 로드됩니다. 에이전트가 더 이상 존재하지 않으면 세션은 기본 도구로 계속되며, 트랜스크립트는 [에이전트 이름을 알리는 경고](https://code.claude.com/docs/ko/errors.md#session-agent-no-longer-available)와 함께 열립니다.

기존 대화를 백그라운드에서 계속하려면 `--resume`으로 전체 세션 ID를 전달합니다:

```bash theme={null}
claude --resume 1f0e2c9a-6d0b-4c11-9f39-2a77c1d4e8b5 --bg "pick up where you left off and finish the migration"
```

Claude Code v2.1.257 이상에서 Claude Code는 동일한 ID로 해당 세션을 계속하거나, 새로운 ID로 복사본을 시작하고 제자리에서 계속할 수 없었던 이유를 설명하는 `note:` 줄을 출력합니다. 세션이 제자리에서 계속되면 `claude agents`에는 해당 세션의 행이 하나만 표시됩니다.

`--bg`를 `--continue`, 인수 없는 `--resume`, 또는 이름이나 파일 경로가 있는 `--resume`과 결합하면, Claude Code는 항상 이러한 복사본을 시작합니다. 메모 없이 의도적으로 복사본을 시작하려면 `--fork-session`을 추가합니다.

`--name`을 전달하면 자동 생성된 이름 대신 에이전트 뷰에 표시될 세션 이름을 설정할 수 있습니다:

```bash theme={null}
claude --bg --name "flaky-test-fix" "investigate the flaky SettingsChangeDetector test"
```

백그라운드로 이동한 후 Claude는 세션의 짧은 ID와 세션 관리 명령을 출력합니다. 백그라운드 세션을 호스팅하는 서비스가 아직 실행 중이 아니면, `--bg`가 이 출력 위에 먼저 `Starting background service…`를 출력할 수 있습니다. `--name`을 전달하면 이름이 짧은 ID 뒤에 나타납니다:

```text theme={null}
backgrounded · 7c5dcf5d · flaky-test-fix
  claude agents             list sessions
  claude attach 7c5dcf5d    open in this terminal
  claude logs 7c5dcf5d      show recent output
  claude stop 7c5dcf5d      stop this session
```

#### `--bg`가 포함된 프롬프트

`--bg` 또는 `--background`를 언급하는 프롬프트는 입력한 그대로 전달되며, 백그라운드 세션에 보내는 `--bg` 회신도 마찬가지입니다. 예를 들어 다음 명령은 백그라운드 세션 하나를 시작하며, 두 번째 `--bg`는 해당 프롬프트의 일부입니다:

```bash theme={null}
claude --bg "find out why --bg sessions are slow to start on this machine"
```

Claude Code는 플래그가 올 수 있는 위치, 즉 단독 `--` 구분자 앞이면서 다른 플래그가 값을 기대하는 위치가 아닌 곳에서만 인수 전체를 플래그로 읽습니다. `claude --bg "<prompt>"`처럼 플래그를 먼저 둡니다.

결합된 짧은 플래그가 연속된 뒤처럼 위치가 모호한 경우 Claude Code는 아무것도 시작하지 않습니다. 대신 [`Couldn't tell whether --bg is a flag or text here`](https://code.claude.com/docs/ko/errors#couldnt-tell-whether-bg-is-a-flag-or-text) 오류로 종료합니다.

#### 셸 명령 실행

Claude 세션 대신 셸 명령을 백그라운드 작업으로 실행하려면 `--exec`을 전달합니다. 다음 예제는 `pytest -x`를 백그라운드 작업으로 실행합니다:

```bash theme={null}
claude --bg --exec 'pytest -x'
```

에이전트 뷰에서는 디스패치 입력의 첫 번째 문자로 `!`를 입력하여 같은 종류의 작업을 디스패치합니다. `!`는 접두사로 표시되고, 그 뒤의 모든 내용이 명령이며, `Enter`를 누르면 작업이 시작됩니다.

명령은 PTY 기반 작업으로 실행되고 에이전트 뷰에 행으로 나타나며, 가장 최근 출력 줄이 상태로 표시됩니다. 셸 작업은 Claude 대신 명령을 실행하므로 모델이 호출되지 않고, 출력은 어떤 세션으로도 전송되지 않습니다.

출력을 보려면 행에 연결하거나, `Space`를 눌러 연결하지 않고 미리 보거나, 셸에서 `claude logs <id>`를 실행합니다. 캡처된 출력은 메모리에 유지되며 디스크에 기록되지 않습니다. 행과 출력은 명령이 종료된 후 약 5분 뒤에 자동으로 정리되므로, 결과가 필요하면 그 전에 확인하세요.

### 파일 편집이 격리되는 방식

에이전트 뷰에서 백그라운드 세션을 디스패치하거나 `claude --bg`로 시작하면, 세션은 작업 디렉터리에서 시작합니다. 파일을 편집하기 전에 Claude는 세션을 `.claude/worktrees/` 아래의 격리된 [git worktree](https://code.claude.com/docs/ko/worktrees.md)로 이동하므로, 병렬 세션이 동일한 체크아웃을 읽을 수 있지만 각각은 자체 워크트리에 씁니다. 세션이 워크트리에 들어가면 Claude Code는 세션과 세션이 생성하는 모든 서브에이전트에 대해 [워크트리 격리를 적용합니다](https://code.claude.com/docs/ko/worktrees.md#how-claude-code-enforces-isolation).

Claude는 다음의 경우 워크트리를 건너뜁니다:

* 이미 열어 둔 세션을 `←` 또는 `/background`로 [백그라운드로 이동한](#from-inside-a-session) 경우. 해당 세션은 이미 작업하던 위치에서 계속 파일을 편집합니다
* 세션이 이미 연결된 git 워크트리 안에 있는 경우. Claude가 `.claude/worktrees/` 아래에 생성했든 사용자가 `git worktree add`로 다른 곳에 생성했든 마찬가지입니다
* Claude가 편집하는 파일이 연결된 git 워크트리 안에 있는 경우. 예를 들어 세션이나 그 서브에이전트가 `git worktree add`로 생성한 워크트리입니다
* 작업 디렉터리가 git 저장소가 아니고 [`WorktreeCreate` 훅](https://code.claude.com/docs/ko/hooks#worktreecreate)이 구성되지 않은 경우
* 쓰기가 작업 디렉터리 외부에서 일어나는 경우

git 워크트리가 실용적이지 않은 저장소에서 워크트리 격리를 끄려면 [`worktree.bgIsolation`](https://code.claude.com/docs/ko/settings-reference#worktree-bgisolation)을 `"none"`으로 설정합니다. 그러면 백그라운드 세션은 먼저 워크트리로 이동하지 않고 작업 복사본을 직접 편집합니다. 프로젝트의 `.claude/settings.json`에 설정을 추가합니다:

```json theme={null}
{
  "worktree": {
    "bgIsolation": "none"
  }
}
```

git 저장소 외부에서는 세션이 작업 디렉터리에 직접 쓰고 서로 격리되지 않으므로, 동일한 파일을 편집하는 병렬 세션을 디스패치하지 않도록 합니다. 다른 버전 관리 시스템을 사용한다면 [`WorktreeCreate` 훅](https://code.claude.com/docs/ko/worktrees#non-git-version-control)을 구성하면 Claude가 git과 동일한 방식으로 편집을 격리합니다.

git 저장소가 아닌 디렉터리에서 훅이 실패하면 Claude는 해당 디렉터리의 격리를 건너뛰고 작업 디렉터리를 제자리에서 편집합니다. git 저장소 안에서는 Claude가 편집 전에 워크트리로 이동시키는 세션은 그 이동이 이루어질 때까지 공유 체크아웃에서 `Edit`, `Write`, `NotebookEdit` 도구를 사용할 수 없습니다.

세션의 워크트리 경로를 찾으려면 세션에 연결하여 작업 디렉터리를 확인합니다.

백그라운드 세션이 생성하는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)는 세션의 작업 디렉터리를 상속합니다. 세션이 워크트리에 들어간 후에는 서브에이전트의 파일 편집이 작업 복사본이 아닌 해당 워크트리에 반영됩니다. 대신 서브에이전트에 별도의 자체 워크트리를 제공하려면 frontmatter에서 [`isolation: worktree`](https://code.claude.com/docs/ko/sub-agents#supported-frontmatter-fields)를 설정하거나 생성할 때 `isolation: "worktree"`를 전달합니다.

백그라운드 세션이 Claude가 들어간 워크트리에서 코드를 변경한 경우, Claude Code는 완료하기 전에 작업을 보존하도록 Claude에 지시하므로, 세션과 워크트리를 삭제해도 작업이 남습니다:

* **커밋 및 푸시**: Claude는 묻지 않고 커밋하며, 저장소에 원격이 있으면 브랜치를 푸시합니다.
* **초안 풀 리퀘스트**: 작업에 필요하면 Claude가 초안 풀 리퀘스트를 열고, 행에 [`#N` 레이블](#pull-request-status)이 나타납니다.
* **절대 하지 않음**: `main` 또는 `master`로 푸시, 강제 푸시, 병합.
* **사용자의 git 지시사항이 우선합니다**: 작업, `CLAUDE.md`, 또는 [메모리](https://code.claude.com/docs/ko/memory.md)에 커밋이나 푸시를 사용자가 직접 처리한다고 되어 있으면, Claude는 git 작업을 사용자에게 맡깁니다.

스스로 격리하지 않은 체크아웃을 편집하는 세션은 여전히 커밋하거나 브랜치를 전환하기 전에 묻습니다. 이는 격리가 `"none"`으로 설정되었거나, 워크트리 이동이 실패했거나, 세션이 이미 존재하던 워크트리 안에서 시작된 경우에 적용됩니다.

작업이 무엇이든 Claude는 무엇을 했는지와 작업 결과가 어디에 있는지(경로, 브랜치, 풀 리퀘스트, 또는 답변 자체)를 알리는 보고로 작업을 마칩니다.

#### 세션 삭제 시 제거되는 것

[에이전트 뷰](#organize-the-list)에서 `Ctrl+X`를 두 번 누르거나 [`claude rm`](#manage-sessions-from-the-shell)으로 세션을 삭제합니다. 아래에서 유지되는 경우를 제외하면 세션은 목록에서 사라집니다. 트랜스크립트는 `claude --resume`을 통해 사용할 수 있도록 머신에 남아 있으며, 제거 상태는 감독자가 재시작되어도 유지됩니다.

Claude가 세션을 위해 생성한 워크트리는 다음과 같이 처리됩니다:

* 에이전트 뷰는 커밋되지 않은 변경 사항을 포함하여 워크트리를 제거하므로, 유지하려는 내용은 먼저 커밋합니다.
* `claude rm`은 커밋되지 않은 변경 사항이 있으면 세션 행과 함께 워크트리를 유지합니다.
* 에이전트 뷰와 `claude rm` 모두 실행 중인 다른 세션이 사용 중이거나 잠근 워크트리는 제거하지 않으며, 다시 삭제해도 달라지지 않습니다. Claude Code는 워크트리와 세션을 유지하고, 유지한 디렉터리와 이유를 알립니다. 에이전트 뷰에서는 세션의 행에 `not deleted`가 표시됩니다. 다른 세션을 닫은 다음 다시 삭제합니다.
* 다른 곳에 저장되었는지 Claude Code가 확인할 수 없는 커밋이 워크트리에 있는 세션을 삭제하면, Claude Code는 워크트리와 세션을 유지하고, 메시지에 워크트리의 브랜치와 푸시되지 않은 커밋 수를 표시합니다. 메시지는 두 가지 방법도 제시합니다. 커밋을 푸시하거나, 다시 삭제하여 커밋을 버리는 것입니다.

  원격에 있는 커밋은 삭제를 막지 않습니다. `origin` 원격의 기본 브랜치의 로컬 복사본에 있는 커밋도 마찬가지이며, 단 해당 브랜치가 워크트리가 아닌 저장소 디렉터리 자체인 메인 체크아웃에 체크아웃되어 있어야 합니다.

  이렇게 거부된 후 다음 중에서 선택합니다:

  * 커밋을 유지하려면 푸시하거나 해당 기본 브랜치에 병합한 다음 세션을 다시 삭제합니다.
  * 커밋을 버리려면 푸시하지 않고 세션을 다시 삭제합니다. 에이전트 뷰에서 해당 행에 `Ctrl+X`를 두 번 누르거나, 거부 메시지에 출력된 `claude rm <id> --discard-unpushed` 명령을 실행합니다. 이렇게 하면 세션과 워크트리, 그리고 워크트리의 브랜치가 제거되며, 푸시되지 않은 커밋과 커밋되지 않은 변경 사항이 모두 버려집니다.

  다시 삭제할 때 Claude Code는 거부 시 표시한 것만 버립니다. 그 이후 워크트리에 커밋이 추가되었으면 Claude Code는 다시 유지하고 업데이트된 상태를 표시합니다.

  완료된 다른 세션의 기록에도 해당 워크트리가 지정되어 있으면, 다시 삭제해도 워크트리가 유지됩니다. 커밋을 푸시한 다음 다시 삭제합니다.
* 예를 들어 `git worktree prune` 이후처럼 git이 더 이상 인식하지 않는 워크트리는 삭제를 막지 않습니다. Claude Code는 세션을 삭제하고 디렉터리는 디스크에 남겨 둡니다.
* git이나 [`WorktreeRemove` 훅](https://code.claude.com/docs/ko/hooks#worktreeremove)이 워크트리를 제거하지 못하면, Claude Code는 워크트리와 세션을 유지하고 메시지에 원인을 표시합니다. 훅의 경우 메시지는 `exited 1`처럼 훅이 어떻게 종료되었는지 알리고 stderr의 앞부분을 인용합니다. 메시지는 다음으로 할 수 있는 작업도 알려줍니다:

  * 세션을 다시 삭제하여 어쨌든 디렉터리를 제거합니다. 에이전트 뷰에서 해당 행에 `Ctrl+X`를 두 번 누르거나, `claude rm` 거부 메시지에 출력된 `claude rm <id> --force-remove-worktree <worktree-id>` 명령을 실행합니다. 워크트리의 브랜치는 저장소에 남습니다.

    Claude Code는 다음을 모두 확인할 수 있을 때만 이 방법을 제시합니다:

    * 디렉터리가 `.claude/worktrees/` 아래에 있는 저장소의 연결된 워크트리 중 하나입니다
    * 워크트리와 체크아웃된 서브모듈 모두 추적 파일에 커밋되지 않은 변경 사항이 없습니다
    * 다른 세션의 기록에 해당 워크트리가 지정되어 있지 않습니다

    별도의 git 저장소로 대체된 서브모듈 체크아웃처럼 Claude Code가 서브모듈 체크아웃의 상태를 확인할 수 없는 경우에도 이 방법을 제시하지 않습니다.
  * 커밋되지 않은 변경 사항을 커밋하거나 스태시하기, 별도의 git 저장소를 워크트리 밖으로 옮기기, 디렉터리를 사용 중인 것을 닫기, 훅 수정하기 등 방해 요인을 해결한 다음 세션을 다시 삭제합니다.
  * 디렉터리를 직접 제거한 다음 세션을 다시 삭제합니다.

사용자가 직접 생성하고 그 안에서 세션을 시작한 워크트리는 어느 경우든 그대로 남습니다.

저장소가 삭제되었거나 [`WorktreeCreate` 훅](https://code.claude.com/docs/ko/hooks#worktreecreate)이 디렉터리를 다른 곳에 생성했기 때문에 워크트리 디렉터리가 어떤 git 저장소에도 속하지 않는 세션도 삭제할 수 있습니다. 디렉터리에 파일이 남아 있는 동안에는 다음과 같습니다:

* 에이전트 뷰는 파일을 버리기 전에 동일하게 `Ctrl+X`를 두 번 누르도록 요청합니다. 훅으로 생성된 디렉터리의 경우 대신 [`WorktreeRemove` 훅](https://code.claude.com/docs/ko/hooks#worktreeremove)을 실행하며, 훅이 없으면 삭제를 거부하고 세션을 유지합니다.
* `claude rm`은 세션과 워크트리를 유지하고 이유를 알립니다.

어느 방법이든 완료된 다른 세션의 기록에 지정된 디렉터리는 유지됩니다.

### 모델, effort, 빠른 모드 설정

에이전트 뷰의 [디스패치 입력](#dispatch-an-agent-from-agent-view)에 `/model`, `/effort`, 또는 `/fast`를 입력하고 `Enter`를 누르면, 이후 디스패치하는 세션이 설정한 값으로 시작합니다. 이 선택은 해당 에이전트 뷰 창에만 유지되며 설정 파일에 저장되지 않습니다. `/effort`와 `/fast`는 Claude Code v2.1.299 이상이 필요하며, 뒤에 아무것도 입력하지 않은 `/model`도 마찬가지입니다.

명령 뒤에 값을 지정하거나, 명령만 입력하여 목록에서 선택합니다:

* **모델**: `/model <name>`, 예: `/model opus`
* **[effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)**: `/effort`와 함께 `low`, `medium`, `high`, `xhigh`, 또는 `max`, 예: `/effort high`. [ultracode](https://code.claude.com/docs/ko/workflows.md#let-claude-decide-with-ultracode)로 세션을 시작하려면 대신 셸에서 [`claude agents --effort ultracode`](#dispatch-defaults)로 에이전트 뷰를 엽니다. 디스패치 입력은 `/effort ultracode`를 허용하지 않습니다
* **빠른 모드**: `/fast on` 또는 `/fast off`. 세션은 빠른 모드를 [사용할 수 있고](https://code.claude.com/docs/ko/fast-mode.md#requirements) 해당 모델이 빠른 모드를 지원하는 경우에만 빠른 모드로 시작합니다. 지원하지 않는 모델에서는 세션이 빠른 모드가 꺼진 상태로 시작하므로, 먼저 `/model`로 [빠른 모드를 지원하는 모델](https://code.claude.com/docs/ko/fast-mode.md) 중 하나를 선택합니다. 새 세션에 빠른 모드가 적용되는지는 헤더가 아니라 입력 아래의 힌트에서 확인할 수 있습니다.

선택을 취소하려면 값으로 `default`를 지정합니다. 예: `/effort default`.

다음 예제는 한 세션을 Opus로, 다음 세션을 Sonnet으로 디스패치합니다:

```text theme={null}
/model opus
refactor auth
/model sonnet
run the test suite
```

각 백그라운드 세션은 서로 다른 모델로 실행될 수 있습니다. 한 세션에 대해 재정의하려면:

* 셸에서 `claude --bg`와 함께 `--model`을 전달합니다.
* 실행 중인 세션에 연결하고 `/model`을 실행하여 전환합니다. 선택기에서 고르거나 `/model <name>`을 입력한 선택은, 선택기에서 `s`를 눌러 세션 전용으로 전환하지 않는 한 새 세션의 기본값으로 저장됩니다. 세션 전용 전환은 세션이 다시 생성되어도 유지됩니다.
* frontmatter에 `model`을 설정한 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)를, 프롬프트를 그 이름으로 시작하거나 `@name`을 언급하여 디스패치합니다. 디스패치 입력에서 한 `/model` 선택이 적용되는 동안에는 서브에이전트의 `model`이 사용되지 않으므로, 그곳에 `/model default`를 입력합니다. [`claude agents --model`](#dispatch-defaults)로 시작한 경우에도 서브에이전트의 모델이 사용되지 않으므로, 셸에서 `--model` 없이 `claude agents`를 실행합니다.

### 권한 모드, 모델, effort

백그라운드 세션은 설정, 제공자, 권한 모드, 모델, effort를 디스패치한 위치와 방식에서 가져옵니다. 아래 하위 섹션에서는 각 출처와, 감독자가 세션을 재시작할 때 유지되는 항목을 다룹니다.

#### 설정 및 제공자

백그라운드 세션은 실행되는 디렉터리에서 [설정](https://code.claude.com/docs/ko/settings.md)을 읽으며, 이는 [이어받은 구성 플래그](#what-carries-over-when-you-background)로 그곳에서 `claude`를 시작한 것과 같습니다. 여기에는 프로젝트 설정의 [`env` 값](https://code.claude.com/docs/ko/settings-reference#env)도 포함되므로, 그곳에 설정된 `ANTHROPIC_MODEL`이나 제공자 변수는 해당 디렉터리의 모든 백그라운드 세션에 적용됩니다.

백그라운드 세션은 또한 디스패치한 셸의 `PATH`로 실행되므로, 세션이 실행하는 명령은 터미널과 동일한 도구를 찾습니다. `CLAUDE_CODE_USE_BEDROCK`이나 `CLAUDE_CODE_USE_VERTEX` 같은 해당 셸의 클라우드 제공자 선택도 유지되며, `ANTHROPIC_DEFAULT_*_MODEL` 별칭과 그 셸에서 내보낸 [`CLAUDE_CODE_EXTRA_BODY`](https://code.claude.com/docs/ko/env-vars) 재정의도 함께 유지됩니다.

#### LLM 게이트웨이

[LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 통해 Claude Code를 라우팅한다면, 게이트웨이 변수를 셸에서 내보내는 대신 설정 파일의 `env` 블록에 넣으면 백그라운드 세션이 나머지 설정과 함께 이를 읽습니다. [설정 파일에서 설정](https://code.claude.com/docs/ko/llm-gateway-connect.md#set-in-a-settings-file)에서 해당 블록과 자격 증명에 사용할 설정 파일을 확인할 수 있습니다.

대신 게이트웨이 `ANTHROPIC_BASE_URL`을 셸에서만 내보내면, 함께 내보낸 `ANTHROPIC_CUSTOM_HEADERS` 및 자격 증명과 함께 백그라운드 세션에 전달되는 것은 [감독자](#the-supervisor-process) 자체가 같은 게이트웨이를 내보낸 셸에서 시작된 경우뿐이며, 그마저도 다음 경우에만 해당합니다:

* `←` 또는 `/background`로 자신의 세션을 백그라운드로 보내는 경우
* 현재 있는 디렉터리로 세션을 디스패치하는 경우
* 현재 있는 디렉터리에서 중지된 세션에 연결하거나 회신하여 깨우는 경우
* 현재 있는 디렉터리에서 [`claude respawn`](#manage-sessions-from-the-shell)으로 세션을 재시작하는 경우

Claude Code는 클라우드 제공자 앞에 있는 게이트웨이도 전달합니다. 디스패치하는 셸이 제공자를 선택하고 인증 우회 플래그와 함께 게이트웨이 엔드포인트를 내보내면, Claude Code는 `ANTHROPIC_BASE_URL`에 적용되는 조건에서 엔드포인트와 플래그 쌍을 `ANTHROPIC_CUSTOM_HEADERS`와 함께 세션에 전달합니다. 예를 들어 `CLAUDE_CODE_USE_VERTEX=1`을 `ANTHROPIC_VERTEX_BASE_URL` 및 `CLAUDE_CODE_SKIP_VERTEX_AUTH=1`과 함께 내보내면, Claude Code는 해당 엔드포인트와 플래그를 전달합니다.

Claude Code는 전달된 게이트웨이를 해당 세션의 실행 중인 프로세스에만 적용하며 디스크에 기록하지 않습니다.

#### 권한 모드

* **`/bg` 또는 `←`로 백그라운드로 보낸 경우**: Claude Code는 세션의 기존 [권한 모드](https://code.claude.com/docs/ko/permissions.md)를 유지하므로, `acceptEdits`나 `auto`로 전환한 세션은 분리 후에도 그 모드를 유지합니다
* **셸에서 시작한 `claude agents` 또는 `claude --bg`로 디스패치한 경우**: [디스패치 기본값](#dispatch-defaults)과 함께 연 에이전트 뷰에서 디스패치한 경우가 아니면, 새 세션은 해당 디렉터리에서 새 `claude` 세션이 시작되는 방식대로 시작됩니다. [세션이 시작되는 권한 모드](https://code.claude.com/docs/ko/permission-modes.md#which-mode-a-session-starts-in)에 순서가 나와 있습니다

`←`로 연 에이전트 뷰에서 디스패치한 세션의 경우, Claude Code는 다음 중 처음으로 적용되는 항목에서 권한 모드를 가져옵니다:

1. 대상 디렉터리의 [`permissions.defaultMode`](https://code.claude.com/docs/ko/settings-reference#permissions-defaultmode). `auto`와 `bypassPermissions`는 [관리형 설정, `--settings` 파일, 또는 `~/.claude/settings.json`에서만 적용됩니다](https://code.claude.com/docs/ko/settings-reference#permissions-defaultmode). Claude Code는 프로젝트의 `.claude/settings.json` 또는 `.claude/settings.local.json`에 있는 `defaultMode`가 원래 세션의 모드보다 더 허용적인 모드를 선택하면 이를 거부합니다.
2. 원래 세션의 권한 모드.

   해당 세션이 `bypassPermissions` 모드였다면, 새 세션은 대신 `Bypass permissions was requested at launch and ignored` 알림과 함께 Manual 모드로 시작될 수 있습니다. 이는 우회 면책 조항에 대한 사용자의 수락이 `.claude/settings.local.json` 또는 `--settings` 파일에만 있을 때 발생합니다. Manual 모드로 계속하거나, [해당 수락을 `~/.claude/settings.json`에 추가](https://code.claude.com/docs/ko/permission-modes#bypass-permissions-ignored-in-a-background-session)합니다.

Claude Code가 어떤 출처의 모드를 지나치게 허용적이라는 이유로 거부하면, 목록의 다음 출처가 결정합니다. 예를 들어 플랜 모드 세션에서 체크인된 설정이 `acceptEdits`를 요청하는 디렉터리로 디스패치하면, 새 세션은 플랜 모드로 시작합니다. 해당 `defaultMode`를 `~/.claude/settings.json`으로 옮기면 원래 세션의 권한 모드와 관계없이 적용됩니다.

허용 범위는 plan, 그다음 Manual과 `dontAsk`, 그다음 `acceptEdits`와 auto(서로가 서로보다 더 허용적인 것으로 간주됨), 그다음 `bypassPermissions` 순으로 넓어집니다.

#### 디스패치 기본값

에이전트 뷰에서 디스패치하는 모든 세션의 기본값을 설정하려면, 에이전트 뷰를 열 때 `--permission-mode`, `--model`, `--effort`, `--agent` 중 원하는 것을 전달합니다:

```bash theme={null}
claude agents --permission-mode plan --model opus --effort high
```

여기서 `--effort`는 `ultracode`를 포함하여 [최상위 `--effort` 플래그](https://code.claude.com/docs/ko/cli-reference#cli-flags)와 동일한 값을 허용합니다.

`--agent`는 디스패치 프롬프트가 `@name`이나 첫 단어로 서브에이전트를 지정하지 않을 때 사용되는 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)를 설정합니다. 기본값은 [`agent` 설정](https://code.claude.com/docs/ko/settings-reference#agent)이 있으면 그 값이고, 없으면 기본 제공 범용 `claude` 에이전트입니다. 디스패치 입력에서 서브에이전트를 지정하면 둘 다 재정의됩니다.

`claude agents`는 `--permission-mode bypassPermissions`의 약칭인 `--dangerously-skip-permissions`와, 해당 모드로 시작하지 않으면서 디스패치된 각 세션의 `Shift+Tab` 순환에서 `bypassPermissions`를 사용할 수 있게 하는 `--allow-dangerously-skip-permissions`도 허용합니다. 둘 다 [최상위 CLI 플래그](https://code.claude.com/docs/ko/cli-reference.md)와 동일합니다.

`--restricted`를 전달하면 뷰에서 디스패치하는 모든 세션이 각각 최상위 `--restricted` 플래그로 시작된 것처럼 [제한 모드](https://code.claude.com/docs/ko/cli-reference.md#cli-flags)로 시작됩니다. Claude Code v2.1.248 이상이 필요합니다.

활성 기본값은 디스패치 입력 아래의 바닥글에 표시됩니다.

`bypassPermissions` 모드로 시작한 백그라운드 세션에는 [우회 면책 조항에 대한 사용자의 수락](https://code.claude.com/docs/ko/permission-modes.md#skip-all-checks-with-bypasspermissions-mode) 기록이 필요합니다. 이 모드에서는 사용자가 지켜보지 않는 세션이 승인 없이 작업하기 때문입니다. 이전에 수락하지 않았다면 `claude agents`에 `--dangerously-skip-permissions` 또는 `--permission-mode bypassPermissions`를 전달할 때도 같은 면책 조항이 표시되며, 수락하면 뷰에서 시작하는 세션에 `bypassPermissions`가 적용됩니다. `--allow-dangerously-skip-permissions`를 전달해도 같은 면책 조항이 표시되며, 수락하면 해당 세션을 그 모드로 시작하지 않으면서 `Shift+Tab` 순환에서 `bypassPermissions`를 사용할 수 있게 됩니다.

#### 재시작 후에도 유지되는 것

백그라운드 세션에 대해 선택한 권한 모드, 모델, effort는 [세션이 이어받은 구성 플래그](#what-carries-over-when-you-background)와 함께, 감독자가 나중에 프로세스를 [중지하고 재시작](#the-supervisor-process)해도 모두 유지됩니다. 세션 도중 `/model` 또는 `/effort`로 변경한 모델이나 effort도 유지됩니다.

세션이 `--effort`나 `/effort`가 아닌 설정에서 effort를 가져왔다면, Claude Code는 세션의 프로세스를 시작할 때마다 설정을 다시 읽습니다. `settings.json`에 저장된 effort를 편집하면, 그 변경은 `←` 또는 `/bg`로 백그라운드로 보내는 세션과 그 이후의 재시작에 반영됩니다. 저장된 effort는 [`effortLevel`](https://code.claude.com/docs/ko/settings-reference#effortlevel) 키 또는 [`modelSettings`](https://code.claude.com/docs/ko/settings-reference#modelsettings) 항목입니다.

Claude Code는 [`/rename`](https://code.claude.com/docs/ko/commands) 또는 `Ctrl+R`로 설정한 이름도 재시작 후에 유지하므로, 여전히 [`claude --resume <name>`](https://code.claude.com/docs/ko/sessions#name-your-sessions)을 실행하여 세션에 접근할 수 있습니다.

연결된 동안 [`Ctrl+S`](https://code.claude.com/docs/ko/interactive-mode#general-controls)로 스태시한 프롬프트도 세션과 함께 유지됩니다. 프로세스가 중지되거나 재시작된 후 세션을 다시 열고 `Ctrl+S`를 누르면 스태시한 텍스트가 복원됩니다. 스태시에 포함된 붙여넣은 콘텐츠는 재시작 후 유지되지 않습니다.

### 설정, 플러그인, MCP 서버

에이전트 뷰는 설정, 플러그인, MCP 서버, 추가 디렉터리를 로드하기 위해 `claude`와 동일한 구성 플래그를 허용합니다. 에이전트 뷰는 `--settings`, `--setting-sources`, `--plugin-dir`을 자체에 적용하고 모든 구성 플래그를 디스패치하는 세션에 전달하므로, 이 방식으로 로드한 플러그인이나 MCP 서버는 해당 세션에서 사용할 수 있습니다.

| 플래그 | 효과 |
| :- | :- |
| [`--settings <file-or-json>`](https://code.claude.com/docs/ko/settings) | 에이전트 뷰 및 디스패치된 세션의 설정 재정의 |
| [`--setting-sources <sources>`](https://code.claude.com/docs/ko/cli-reference#cli-flags) | 에이전트 뷰 및 디스패치된 세션에서 지정한 설정 소스만 로드 |
| [`--add-dir <path>`](https://code.claude.com/docs/ko/permissions#additional-directories-grant-file-access-not-configuration) | 추가 디렉터리에 파일 액세스 권한 부여 |
| [`--plugin-dir <path>`](https://code.claude.com/docs/ko/plugins/create#load-a-directory-or-archive-for-one-session) | 로컬 디렉터리에서 플러그인 로드 |
| [`--mcp-config <file-or-json>`](https://code.claude.com/docs/ko/mcp) | 설정 파일 또는 JSON 문자열에서 MCP 서버 로드 |
| `--strict-mcp-config` | `--mcp-config`의 MCP 서버만 사용하고 다른 MCP 구성은 무시합니다. 관리형 MCP 파일이 있을 때 이 플래그의 동작은 [managed-mcp.json을 통한 배타적 제어](https://code.claude.com/docs/ko/managed-mcp.md#exclusive-control-with-managed-mcp-json)를 참조하세요 |

`--add-dir`, `--plugin-dir`, `--mcp-config`는 값마다 한 번씩 반복합니다. `claude agents`는 `--add-dir a b c`와 같은 공백으로 구분된 형식을 지원하지 않습니다.

`--settings`, `--setting-sources`, `--plugin-dir`은 `agents` 앞이나 뒤에 둘 수 있습니다. `--add-dir`과 `--mcp-config`는 `agents` 뒤에 두어야 합니다. 둘 중 하나라도 `agents` 앞에 두면 [`claude agents --json`](#manage-sessions-from-the-shell)이 `unknown option` 오류로 실패합니다.

다음 예제는 설정 재정의와 추가 디렉터리 하나로 에이전트 뷰를 엽니다:

```bash theme={null}
claude agents --settings ./ci-settings.json --add-dir ../shared-lib
```

`--settings`는 파일 경로 또는 인라인 JSON 문자열을 허용합니다. 파일 경로는 존재하는 파일을 가리켜야 하며, 그렇지 않으면 Claude Code는 `Settings file not found` 오류로 종료됩니다.

## 셸에서 세션 관리

모든 백그라운드 세션에는 셸에서 사용할 수 있는 짧은 ID가 있습니다. ID는 `claude --bg`로 세션을 시작할 때 출력되며, 각 세션의 ID는 `~/.claude/jobs/` 아래의 디렉터리 이름입니다. 이 명령은 스크립팅이나 에이전트 뷰를 열고 싶지 않을 때 유용합니다.

| 명령 | 목적 |
| :- | :- |
| `claude agents` | 에이전트 뷰 열기 |
| `claude agents --cwd <path>` | `<path>` 아래에서 시작된 세션으로 범위가 지정된 에이전트 뷰 열기 |
| `claude agents --json` | 세션을 JSON 배열로 인쇄하고 종료합니다. [세션을 JSON으로 나열](#list-sessions-as-json) 참조 |
| `claude attach <id\|name>` | 이 터미널에서 세션에 연결 |
| `claude logs <id\|name>` | 세션의 최근 출력 인쇄 |
| `claude stop <id>` | 세션 중지. `claude kill`도 허용 |
| `claude respawn <id>` | 실행 중이거나 중지된 세션을 다시 시작합니다. 예를 들어 업데이트된 Claude Code 바이너리를 적용하기 위해 사용합니다. 저장된 대화가 있는 세션은 해당 대화를 재개합니다 |
| `claude respawn --all` | 모든 실행 중인 세션을 다시 시작합니다. 예를 들어 모든 세션을 한 번에 업데이트된 Claude Code 바이너리로 이동하기 위해 |
| `claude rm <id>` | 세션을 목록에서 제거하고, 안전하게 삭제할 수 있을 때 Claude가 생성한 worktree를 함께 제거합니다. [세션 삭제 시 제거되는 항목](#what-deleting-a-session-removes) 참조. 대화 트랜스크립트는 로컬 머신에 남아 있으며 `claude --resume`을 통해 계속 사용할 수 있습니다 |
| `claude rm <id> --discard-unpushed <commit>@<worktree-id>` | 푸시되지 않은 커밋으로 인해 삭제가 거부된 세션을 삭제하고, worktree와 해당 브랜치 및 커밋을 함께 삭제합니다. 거부 시 출력된 정확한 값을 전달합니다. [세션 삭제 시 제거되는 항목](#what-deleting-a-session-removes) 참조. v2.1.260 이상 필요 |
| `claude rm <id> --force-remove-worktree <worktree-id>` | git 또는 `WorktreeRemove` 훅이 worktree를 제거할 수 없어 삭제가 거부된 세션을 삭제하고, worktree 디렉터리를 어쨌든 삭제하며 해당 브랜치는 저장소에 남겨둡니다. 거부 시 출력된 정확한 값을 전달합니다. [세션 삭제 시 제거되는 항목](#what-deleting-a-session-removes) 참조. v2.1.268 이상 필요 |
| `claude daemon status` | [감독자](#the-supervisor-process)의 상태, 버전, 소켓 디렉터리 및 워커 수 인쇄 |
| `claude daemon logs` | 감독자의 로그 파일 [`~/.claude/daemon.log`](#where-state-is-stored)를 팔로우하며, `Ctrl+C`를 누를 때까지 새 줄이 도착하는 대로 인쇄 |
| `claude daemon stop --any` | 감독자 프로세스와 감독자가 호스팅하는 백그라운드 세션을 중지합니다. 백그라운드 세션을 실행 상태로 유지하여 [다음 감독자](#the-supervisor-process)가 다시 연결하도록 하려면 `--keep-workers`를 전달합니다. 다음 `claude agents` 또는 `claude --bg`는 새로운 감독자를 시작합니다 |

`claude attach`와 `claude logs`는 ID 대신 세션 이름의 일부를 받을 수 있습니다(예: `claude logs "auth refactor"`). `claude attach`는 프로세스가 실행 중인 동안에만 이름으로 세션을 열 수 있으므로, 중지된 세션을 다시 시작하려면 대신 ID를 전달합니다. 이름을 전달하려면 Claude Code v2.1.290 이상이 필요합니다.

### 세션을 JSON으로 나열

`claude agents --json`은 활성 세션을 JSON 배열로 인쇄하고 종료합니다. 모든 라이브 세션과 프로세스가 종료되었어도 여전히 작동 중이거나 차단된 백그라운드 세션이 포함됩니다. 완료된 백그라운드 세션도 포함하려면 `--all`을 추가하고, 특정 디렉터리 아래에서 시작된 세션으로 제한하려면 `--cwd <path>`를 추가합니다.

각 항목은 하나의 세션을 설명합니다:

| 필드 | 표시 | 설명 |
| :- | :- | :- |
| `cwd`, `kind`, `startedAt` | 항상 | 작업 디렉터리, `interactive` 또는 `background`, Unix 밀리초 단위의 시작 시간 |
| `id` | 백그라운드 세션 | `claude attach`, `claude logs`, `claude stop`에서 사용 가능한 짧은 ID |
| `state` | 백그라운드 세션 | `working`, `blocked`, `done`, `failed`, `stopped` 중 하나. 각 값의 의미는 [스크립트에서 세션 상태 읽기](#read-session-state-from-a-script) 참조 |
| `pid`, `status` | 프로세스가 활성 상태일 때 | 프로세스 ID 및 `busy`, `waiting`, `idle` 중 하나 |
| `waitingFor` | `status`가 `waiting`일 때 | 세션이 차단된 이유: 승인을 위한 `permission prompt`, Claude 또는 MCP 서버의 입력 요청을 위한 `input needed`, `sandbox request`, `worker request`, `dialog open` |
| `sessionId`, `name` | 설정된 경우 | `sessionId`는 [`claude --resume`](https://code.claude.com/docs/ko/sessions)에서 사용 가능한 전체 세션 UUID입니다. 대화형 세션의 `name`은 세션 이름을 지정하거나 플랜을 수락할 때까지 [기본 표시 이름](https://code.claude.com/docs/ko/sessions.md#name-your-sessions)입니다 |

### 스크립트에서 세션 상태 읽기

`claude agents --json`은 Claude Code 외부에서 세션 상태를 읽는 지원되는 방법입니다. 예를 들어 상태 표시줄, 스케줄러 또는 백그라운드 작업을 감독하는 다른 Claude 세션에서 사용할 수 있습니다. `claude agents --json --all`을 폴링하면 프로세스가 종료된 세션도 계속 나열되며, 각 항목의 `state`, `status`, `waitingFor`을 읽습니다.

| `state` | 의미 |
| :- | :- |
| `working` | 턴이 실행 중이거나 세션이 [`/loop`](https://code.claude.com/docs/ko/scheduled-tasks) 반복 또는 CI 대기와 같이 자체적으로 수행하는 작업의 단계 사이에 있습니다. `status`는 프로세스가 지금 `busy`인지 여부를 알려줍니다 |
| `blocked` | 세션이 사용자를 기다리고 있습니다: 질문, 권한 또는 샌드박스 결정, 만료된 로그인과 같이 사용자만 해결할 수 있는 오류, 또는 프롬프트 없이 시작한 경우 첫 번째 프롬프트. 대기가 라이브 프로세스의 열린 프롬프트인 경우 `waitingFor`이 이를 나타냅니다 |
| `done` | 마지막 턴이 요청한 작업을 완료했으며 세션이 다음 프롬프트를 기다리고 있습니다. 프로세스가 여전히 활성 상태인지 여부는 상관없습니다 |
| `failed`, `stopped` | 작업이 오류로 종료되었거나 세션이 중지되었습니다 |

턴을 완료하고 다음 명령을 기다리는 세션은 `blocked`가 아닌 `done`으로 읽힙니다. `blocked`는 항상 세션이 계속하기 전에 사용자로부터 무언가가 필요함을 의미합니다.

`~/.claude/jobs/<id>/` 아래의 파일은 안정적인 인터페이스가 아닙니다. 세션 또는 다른 프로그램이 `state`, `detail`, `tempo`, `needs`에 쓰는 값은 다음 업데이트에서 대체됩니다.

세션이 자신의 말로 진행 상황을 보고하도록 하려면, 예를 들어 `$CLAUDE_JOB_DIR/tmp` 아래에 자체 파일을 작성하도록 하고, `state.json`을 편집하지 마십시오.

## 백그라운드 세션이 호스팅되는 방식

Claude Code는 에이전트 뷰에 나열된 모든 세션을 현재 연결되어 있는지 여부와 관계없이 백그라운드 세션으로 취급합니다. 반대로 `claude`를 직접 실행하여 시작한 세션은 해당 터미널에 연결되어 있으며 [백그라운드로 보내지](#from-inside-a-session) 않는 한 터미널이 닫힐 때 종료됩니다.

어떤 종류의 세션에 있는지 확인하려면 [`/status`](https://code.claude.com/docs/ko/commands)를 실행합니다. `Session kind` 행은 백그라운드 세션에서 터미널이 연결되어 있는지 여부에 따라 `background job · attached` 또는 `background job · unattended`를 표시하며, 다른 모든 세션에서는 `interactive`를 표시합니다.

### 감독자 프로세스

감독자는 백그라운드 서비스로서 백그라운드 세션을 실행하므로 에이전트 뷰나 터미널을 닫은 후에도 계속 작동합니다. Claude Code는 세션을 백그라운드로 보내거나 에이전트 뷰를 열 때 처음으로 시작하며, 직접 관리할 필요가 없습니다.

각 세션은 감독자 아래의 자체 Claude Code 프로세스이며, 해당 프로세스에 일어나는 일은 세션의 상태에 따라 달라집니다:

* **작업 중, 권한 프롬프트 또는 다른 대화 상자에서 일시 중지됨, 또는 연결됨**: 프로세스가 계속 실행됩니다. 실행 중인 서브에이전트, 워크플로 또는 모니터는 작업 중으로 간주되며, `/loop` 깨우기와 같은 대기 중인 [세션 범위 예약 작업](https://code.claude.com/docs/ko/scheduled-tasks.md)도 마찬가지입니다.
* **완료되었거나 다음 메시지를 기다리는 중이며, 약 1시간 동안 연결되지 않음**: 감독자가 리소스를 확보하기 위해 프로세스를 중지합니다. 질문을 하여 턴을 끝낸 세션은 다음 메시지를 기다리는 중으로 간주됩니다. 대화는 디스크에 저장되며, 다음에 연결하거나 답변할 때 세션은 중단된 위치에서 재개됩니다. `Ctrl+T`로 세션을 고정하여 프로세스를 계속 실행 상태로 유지합니다.
* **감독자가 실행 중인 동안 예기치 않게 종료됨**: 감독자가 프로세스를 다시 시작합니다. `←` 또는 `/background`로 직접 백그라운드로 보낸 세션을 종료하면(예: `kill` 사용) 다시 시작하는 대신 중지된 것으로 표시됩니다. 종료로 인해 끝난 세션의 경우 [세션이 종료 후 실패 또는 중지로 표시됨](#sessions-show-as-failed-after-shutdown)을 참조하세요.
* **자동 업데이트 후**: 감독자가 자신을 새 버전으로 다시 시작하고 유휴 세션을 백그라운드에서 이동합니다. 작업 중이거나, 입력을 기다리거나, 연결된 세션은 중단되지 않습니다.
* **감독자 자체가 중지됨**(예: 프로세스가 Claude Code 외부에서 종료된 경우): macOS 및 Linux에서는 약 1분 이내에 새 감독자가 연결되지 않으면 세션이 중지됩니다. 새 감독자를 시작하려면 셸에서 `claude agents`를 실행합니다. 1분이 지난 후에는 [감독자가 중지된 후에도 세션 계속 실행하기](#keep-sessions-running-after-the-supervisor-stops)를 참조하세요.

세션의 프로세스가 중지되거나 다시 시작될 때, Claude가 그 세션에서 시작한 백그라운드 셸 명령과 백그라운드 서브에이전트는 다음 프로세스로 이월됩니다. 동적 워크플로는 [Claude가 다시 실행할 때만 계속됩니다](#dynamic-workflows-when-you-background). 실행 중인 모니터와 서브에이전트가 시작한 셸 명령은 프로세스와 함께 중지됩니다. 세션을 삭제하면 이월된 모든 것이 중지됩니다. 대신 프로세스와 함께 모든 것을 중지하려면 [`CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF`](https://code.claude.com/docs/ko/env-vars#variables)를 `1`로 설정합니다.

감독자와 세션은 대화형 세션과 동일한 저장된 자격 증명으로 인증합니다. 세션에 도달하는 설정 및 셸 변수(예: `PATH`)는 [설정 및 공급자](#settings-and-provider)를 참조하세요. 게이트웨이 엔드포인트는 [LLM 게이트웨이](#llm-gateway)를 참조하세요.

#### 감독자가 중지된 후에도 세션 계속 실행하기

에이전트 뷰가 종료될 때 다음 알림을 출력하면 실행 중인 [감독자](#the-supervisor-process)가 없는 것입니다:

```text theme={null}
Background sessions still running will stop in about a minute. Run 'claude agents' to keep them.
```

그 1분 이내에 셸에서 `claude agents`를 실행하여 새 감독자를 시작하고 세션을 계속 실행 상태로 유지합니다.

1분이 먼저 지나면 세션은 중지되지만 저장된 대화는 디스크에 유지됩니다. 저장된 대화에서 세션을 다시 시작하려면 [세션이 종료 후 실패 또는 중지로 표시됨](#sessions-show-as-failed-after-shutdown)에 설명된 대로 세션에 [연결](#attach-to-a-session)하거나 [답변](#peek-and-reply)합니다.

### 상태가 저장되는 위치

세션 상태는 Claude Code 구성 디렉토리 아래에 저장됩니다. [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars)을 설정하면 감독자는 `~/.claude` 대신 해당 디렉토리를 사용하고 자체 세션이 있는 별도의 인스턴스로 실행됩니다.

| 경로 | 내용 |
| :- | :- |
| `~/.claude/daemon.log` | 감독자 로그 |
| `~/.claude/daemon/roster.json` | 실행 중인 백그라운드 세션 목록, 다시 시작 후 다시 연결하는 데 사용됨 |
| `~/.claude/jobs/<id>/state.json` | 에이전트 뷰에 표시되는 세션별 상태. [`claude agents --json`](#read-session-state-from-a-script)을 통해 읽으세요. 파일을 직접 파싱하지 마세요 |
| `~/.claude/jobs/<id>/tmp/` | 세션별 스크래치 디렉토리. 이 위치에 대한 Claude의 `Write` 및 `Edit` 호출은 권한을 요청하지 않습니다. 세션이 삭제되면 제거됨 |

각 백그라운드 세션에는 `CLAUDE_JOB_DIR` 환경 변수가 `~/.claude/jobs/<id>` 디렉토리로 설정되어 있으므로 세션이 실행하는 셸 명령은 병렬 세션과 충돌하지 않고 `$CLAUDE_JOB_DIR/tmp`에 임시 파일을 쓸 수 있습니다.

파일을 직접 읽지 않고 이 상태를 검사하려면 `claude daemon status`를 실행합니다. 감독자에 도달할 수 있는지 여부, 프로세스 ID 및 버전, 소켓 디렉토리, 그리고 활성 백그라운드 세션의 수를 보고합니다.

명령은 또한 실행 중인 감독자가 호출한 `claude`와 다른 버전에 있을 때 경고하며, 이는 감독자가 아직 다시 시작하지 않은 업데이트 후에 발생합니다. 경고는 두 버전을 모두 표시하고 새 버전을 적용하려면 `claude daemon stop --any`를 실행하도록 안내합니다.

세션은 이러한 버전 불일치에도 그대로 유지됩니다. 이전 Claude Code 버전이 세션의 `state.json`을 업데이트할 때 인식하지 못하는 필드를 보존하고 세션을 나열된 상태로 유지합니다. `roster.json`의 세션 목록도 동일한 규칙을 따르므로 최신 버전으로 시작한 세션은 도달 가능한 상태로 유지되고 감독자가 다시 시작한 후에도 입력을 계속 받습니다.

### 에이전트 뷰 끄기

백그라운드 에이전트 및 에이전트 뷰를 완전히 끄려면 `disableAgentView` [설정](https://code.claude.com/docs/ko/settings.md)을 `true`로 설정하거나 `CLAUDE_CODE_DISABLE_AGENT_VIEW` 환경 변수를 설정합니다. 관리자는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)을 통해 이를 적용할 수 있습니다.

## 문제 해결

### `claude agents`가 에이전트 뷰를 열지 않고 서브에이전트를 나열함

`claude agents`가 개수를 출력한 후 구성된 서브에이전트를 나열하고 종료되면, 에이전트 뷰를 사용할 수 없는 환경입니다. `claude update`를 실행하여 최신 버전을 설치합니다.

업데이트 후에도 에이전트 뷰가 열리지 않으면, 설정 또는 환경 변수에 의해 [꺼져 있는지](#turn-off-agent-view) 확인합니다.

### 에이전트 뷰가 세션 없이 열림

첫 번째 세션을 디스패치하기 전에 에이전트 뷰는 세션 목록 대신 각 섹션 아래에 설명이 있는 빈 섹션 헤더와 입력 위의 한 줄 설명을 표시합니다. 하단의 입력에 프롬프트를 입력하고 `Enter`를 눌러 첫 번째 세션을 디스패치합니다.

### 백그라운드로 이동하면 `Background this session?` 대화 상자가 표시됨

`←`를 눌러 세션을 백그라운드로 전환할 때 `Background this session?` 대화 상자가 표시되면, 세션에 중지되거나, 중단되거나, 지켜보는 사람 없이 계속 실행될 진행 중인 백그라운드 작업이 있다는 의미입니다:

* **이동할 수 없는 작업**: 세션에 백그라운드 세션으로 이동할 수 없는 작업이 있습니다. 예를 들어 실행 중인 [모니터](https://code.claude.com/docs/ko/tools-reference.md#monitor-tool)와 같은 작업입니다. 대화 상자는 Claude Code가 중단할 백그라운드 작업의 이름을 표시하고, 별도로 이동할 작업의 개수를 세어줍니다.
* **실행 중인 서브에이전트가 있는 워크플로**: [동적 워크플로](https://code.claude.com/docs/ko/workflows.md)에 여전히 실행 중인 서브에이전트가 있습니다. 그래도 백그라운드로 전환하면 해당 서브에이전트는 중지되며, 대화 상자는 그 개수를 표시합니다. Claude가 [백그라운드 세션에서 워크플로를 다시 시작](#dynamic-workflows-when-you-background)하면 이 서브에이전트는 처음부터 다시 시작됩니다.
* **자동 아티팩트 답변**: Claude가 [아티팩트의 댓글에 자동으로 답변](https://code.claude.com/docs/ko/artifacts.md#let-claude-reply-to-comments-on-its-own)하고 있습니다. 이러한 답변은 백그라운드 세션에서 계속되며, 대화 상자는 이를 표시합니다.

`/tasks`를 실행하여 실행 중인 모든 작업을 확인한 후 어쨌든 백그라운드로 이동하도록 확인하거나 `Stay`를 선택하여 작업이 먼저 완료되도록 합니다. [백그라운드로 이동할 때 이어지는 것](#what-carries-over-when-you-background)을 참조하여 어떤 종류의 작업이 이어지고 어떤 작업이 Claude Code에 의해 중지되는지 확인합니다.

### 대화에 백그라운드 에이전트가 `was carried into this session and not resumed`라고 표시됨

이 알림은 이 세션에서 실행되고 있지 않은 백그라운드 [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)를 가리킵니다.

Claude가 알림을 확인하고 스스로 답변하므로 별도로 요청할 필요가 없습니다. Claude의 답변을 읽은 후에도 해당 서브에이전트의 작업이 여전히 필요하면 Claude에게 요청합니다.

### 프롬프트가 너무 짧아서 거부됨

디스패치 입력은 대화형 오프닝이 아닌 작업 설명을 예상합니다. 4자 미만의 프롬프트는 `Too short` 힌트와 함께 거부되므로 실수로 누른 키가 세션을 시작하지 않습니다. 세션이 수행할 작업을 설명합니다. 예를 들어 `investigate the flaky checkout test`와 같이 설명합니다.

### 머신 종료 후 세션이 실패 또는 중지로 표시됨

머신을 종료하거나 재시작하면 실행 중인 백그라운드 세션이 중지됩니다. 입력을 기다리던 세션은 돌아올 때 `Needs input` 아래에 남아 있습니다. 다른 실행 중인 세션의 경우, 에이전트 뷰가 표시하는 내용은 마지막으로 진행한 이후 경과 시간에 따라 달라집니다:

* 48시간 이내에는 세션이 실패로 표시됩니다. 연결하거나 답변하면 저장된 대화에서 다시 시작됩니다. 중단된 작업을 이어서 진행하려면 계속하라고 요청하는 답변을 보냅니다.
* 48시간 이후, 예를 들어 머신이 며칠 동안 꺼져 있었던 경우, 세션은 `ended while the background service was off`와 함께 중지로 표시됩니다. 행에서 `Enter`를 누르면 바닥글에 `Press enter again to resume this session (it ended while the background service was off), or ctrl+x to delete it.`이 표시됩니다. 같은 행에서 `Enter`를 다시 누르면 저장된 대화를 다시 시작합니다. 답변 또는 `claude attach <id>`는 바닥글 프롬프트 없이 다시 시작합니다.

[트랜스크립트 정리](https://code.claude.com/docs/ko/settings-reference.md#cleanupperioddays)가 중지된 세션의 저장된 대화를 제거한 경우, Claude Code는 행을 열기를 거부합니다: 메시지는 다시 시작할 것이 없음을 나타냅니다. `claude rm <id>`는 행을 삭제합니다. 단, [유지되는 경우](#what-deleting-a-session-removes)에서 설명한 경우는 제외되며, `claude respawn <id>`는 원래 프롬프트를 다시 실행합니다. [이 세션의 저장된 대화는 더 이상 디스크에 없습니다](https://code.claude.com/docs/ko/errors.md#this-sessions-saved-conversation-is-no-longer-on-disk)를 참조합니다.

절전 상태만으로는 세션이 중지되지 않습니다. 세션은 절전 상태에서 보존되며 감독자는 깨어날 때 이들에 다시 연결됩니다.

### 세션을 열면 대화가 이미 열려 있다고 표시됨

두 프로세스가 같은 트랜스크립트에 쓸 수 없습니다. 중지된 세션의 저장된 대화가 다른 라이브 Claude Code 프로세스에서 이미 열려 있으면, Claude Code는 세션의 자체 프로세스를 시작하기를 거부합니다. 표시되는 내용은 대화를 보유한 것에 따라 달라집니다:

* 예를 들어 `claude --resume` 또는 `/resume`으로 대화를 다시 시작한 터미널: 행은 `Open in a terminal`을 표시하고 거기서 계속하라는 힌트를 표시하며, 행을 열면 `Can't open — this session is running in another terminal`을 표시합니다. 해당 터미널에서 계속하거나 종료한 후 행을 다시 엽니다.
* 다른 비대화형 Claude Code 프로세스, 예를 들어 같은 대화를 위한 백그라운드 세션 프로세스가 아직 종료되지 않은 경우: 행을 열면 `This conversation is already open in another running Claude session`을 표시합니다. 해당 프로세스를 사용하거나 종료될 때까지 기다린 후 행을 다시 엽니다.

Claude Code는 거부된 시도로 입력한 답변을 저장하고 세션이 다음에 시작될 때 전송합니다. 단, `!` 또는 `/`로 시작하는 답변은 제외됩니다.

### 세션을 열면 저장된 트랜스크립트가 없다고 표시됨

[다른 대화에서 백그라운드로 이동한](#from-inside-a-session) 세션이 자체 턴을 실행하기 전에 중지된 경우, 해당 세션을 열면 Claude Code는 그 대화를 다시 시작합니다. Claude Code가 대화를 찾을 수 없으면 세션 열기를 거부합니다:

* `claude attach`는 `This session has no saved transcript`를 출력합니다.
* 에이전트 뷰는 목록 아래에 `Press enter again to restart this session fresh`를 표시합니다.

같은 행에서 `Enter`를 다시 눌러 빈 대화로 세션을 다시 시작하거나, 셸에서 `claude respawn <id>`를 실행합니다.

자세한 내용은 [오류 참조](https://code.claude.com/docs/ko/errors.md#this-session-has-no-saved-transcript)를 참조합니다.

### 터미널 호스트가 죽었거나 세션이 응답하지 않음

[감독자](#the-supervisor-process)는 각 백그라운드 세션의 터미널을 자체 호스트 프로세스에서 실행합니다. 해당 프로세스가 죽거나 응답하지 않으면, Claude Code는 이유를 표시하고 다시 시작을 제공합니다; 두 경우 모두 대화가 저장되고 다시 시작이 이를 다시 시작합니다. [오류 참조](https://code.claude.com/docs/ko/errors.md#terminal-host-process-died)는 전체 메시지를 인용합니다.

Claude Code는 `Enter`에서 또는 `claude attach`에서 [셸 명령](#run-a-shell-command)을 실행하는 행을 다시 시작하지 않습니다. 왜냐하면 명령을 다시 실행하기 때문입니다; 행의 메시지와 `claude attach` 모두 명령이 다시 실행되지 않음을 나타냅니다.

### 세션이 시작되기 전에 `possibly low memory` 메모와 함께 실패함

백그라운드 세션의 프로세스가 시작을 완료하기 전에 종료되고 호스트의 메모리가 부족하면, 행의 상태는 종료를 이름 지정하고 `possibly low memory — free some up and retry`를 추가합니다.

메모는 가설이지 확인된 원인이 아닙니다. Claude Code는 프로세스가 오류를 작성하지 않고 신호로 중지되지 않고 자동으로 종료되었으며 호스트가 그 순간 메모리 부족을 보고한 경우에만 추가합니다. 프로세스가 종료되기 전에 오류를 작성한 경우, 행은 대신 해당 오류를 표시합니다.

머신의 메모리를 확보한 후 행에 연결하거나 답변하면 감독자가 세션을 위한 새로운 프로세스를 시작합니다. 메모리가 계속 부족하면 감독자는 [유휴 세션을 중지](#the-supervisor-process)하여 자체적으로 리소스를 확보하고, 다른 세션을 중지해도 아무것도 확보되지 않으면 유휴 고정 세션도 중지합니다.

### 에이전트 뷰에서 백그라운드 서비스가 응답하지 않음

연결, 엿보기 또는 `claude logs`에서 백그라운드 서비스가 응답하지 않음을 보고하면, 감독자 프로세스가 중단되었을 가능성이 높습니다. 이를 중지하고 다음 `claude agents`가 새로운 프로세스를 시작하도록 합니다. 백그라운드 세션을 재시작 중에도 계속 실행하려면 `--keep-workers`를 전달합니다:

```bash theme={null}
claude daemon stop --any --keep-workers
```

그런 다음 셸에서 `claude agents`를 실행하여 새로운 감독자를 시작합니다. macOS와 Linux에서는 이전 감독자가 종료된 후 약 1분 이내에 실행해야 하며, 그렇지 않으면 세션이 [감독자 없이 중지됩니다](#the-supervisor-process). `stopped`가 표시되었는데도 같은 오류가 다시 발생하고, macOS 또는 Linux에서 v2.1.300보다 오래된 Claude Code를 사용 중이라면 `claude update`를 실행한 후 두 명령을 다시 실행합니다.

중지 명령이 대신 다음 네 가지 메시지 중 하나를 출력했다면 이전 프로세스는 중지되지 않은 것입니다. 셸에서 해당 행에 안내된 조치를 수행한 후 `claude agents`를 실행합니다:

| 메시지에 포함된 내용 | 플랫폼 | 조치 |
| :- | :- | :- |
| `could not be verified as the daemon, so it was not signalled` | 모두 | 해당 프로세스 ID를 가진 프로그램을 확인합니다. 사용자 본인의 감독자이면 중지하고, 다른 프로그램은 그대로 둡니다. 그런 다음 `~/.claude/daemon.lock`을 삭제합니다. |
| `is still running after SIGKILL` | macOS, Linux | 프로세스가 종료될 때까지 기다립니다. 끝내 종료되지 않으면 컴퓨터를 재시작합니다. |
| `was not sent SIGKILL` | macOS, Linux | 중지 명령을 다시 실행합니다. 프로세스가 남아 있으면 `ps -ww -o args= -p <pid>`로 확인합니다: `daemon`과 함께 시작된 Claude Code는 감독자이므로 `kill -9 <pid>`를 실행합니다. 그 외의 것은 그대로 두고, 이후 `claude agents`가 감독자를 시작할 수 없으면 `~/.claude/daemon.lock`을 삭제합니다. |
| `supervisor (pid=<pid>) is still running` | Windows | `taskkill /PID <pid>`로 프로세스를 종료합니다 |

### `Could not resolve authentication method` 오류로 디스패치 실패

백그라운드 디스패치가 `Could not resolve authentication method` 오류로 실패하지만 대화형 세션은 정상적으로 인증되면, 디스패치를 받은 워커가 자격 증명을 선택하지 못했습니다. 백그라운드 세션은 [감독자](#the-supervisor-process)에서 자격 증명을 가져오므로, 이 오류는 감독자 프로세스 자체에서 저장된 자격 증명을 사용할 수 없음을 의미합니다. `/login`을 실행했거나 API 키를 구성했는지 확인한 후 감독자를 중지합니다:

```bash theme={null}
claude daemon stop --any --keep-workers
```

[약 1분](#the-supervisor-process) 이내에 셸에서 `claude agents` 또는 `claude --bg`를 실행하여 저장된 자격 증명을 읽는 새로운 감독자를 시작합니다. `/login` 대신 `ANTHROPIC_API_KEY`와 같은 환경 변수로 인증하는 경우, 변수가 설정된 셸에서 이 다음 명령을 실행합니다.

원인 및 해결 방법의 전체 목록은 [오류 참조](https://code.claude.com/docs/ko/errors.md#could-not-resolve-authentication-method)를 참조합니다.

### 백그라운드 세션에 `No LLM gateway`가 표시됨

백그라운드 세션에 [`No LLM gateway`](https://code.claude.com/docs/ko/errors#no-llm-gateway-opened-from-another-folder)가 표시되면, 해당 세션은 게이트웨이 `ANTHROPIC_BASE_URL`을 받지 못했으므로 요청이 실패합니다. 메시지에 표시된 폴더가 아닌 다른 디렉토리에서 세션을 디스패치하거나, 깨우거나, 재시작했기 때문에 Claude Code가 이를 전달하지 않은 것입니다.

예를 들어 [`@<repo>`](#dispatch-to-a-specific-directory)로 저장소에 디스패치하거나, 다른 디렉토리에서 `claude attach`를 실행하여 중지된 세션을 깨운 후 이 메시지가 표시됩니다. 세션에 게이트웨이를 제공하려면 게이트웨이가 설정된 위치에 맞는 해결 방법을 선택합니다:

* **터미널에서 게이트웨이를 export한 경우**: 게이트웨이 변수를 export한 터미널에서 메시지에 표시된 폴더로 `cd`한 후 메시지의 [`claude respawn <id>`](#manage-sessions-from-the-shell) 명령을 실행합니다.
  * 게이트웨이는 [감독자](#the-supervisor-process) 자체가 같은 게이트웨이를 export한 셸에서 시작된 경우에만 세션에 전달됩니다. 그렇지 않은 경우 [`Could not resolve authentication method` 오류로 디스패치 실패](#dispatch-fails-with-could-not-resolve-authentication-method)에서 설명한 대로 respawn 명령을 실행한 터미널에서 감독자를 재시작한 후 해당 명령을 다시 실행합니다.
* **설정에서 게이트웨이를 지정하는 프로젝트에서 에이전트 뷰를 사용한 경우**: `ANTHROPIC_BASE_URL`과 해당 자격 증명을 [설정 파일의 `env` 블록](https://code.claude.com/docs/ko/llm-gateway-connect#set-in-a-settings-file)에 넣습니다. `~/.claude/settings.json` 또는 세션 자체 프로젝트의 `.claude/settings.local.json`을 사용하며, 두 파일 모두 respawn된 세션이 읽습니다. 그런 다음 아무 디렉토리에서나 셸에서 [`claude respawn <id>`](#manage-sessions-from-the-shell)를 실행하여 이 세션을 게이트웨이로 재시작합니다.

### macOS에서 백그라운드 세션이 Desktop, Documents 또는 Downloads를 읽을 수 없음

macOS에서 백그라운드 세션 호스트는 자체 프로세스로 실행되며 터미널과 별도로 보호된 폴더에 대한 액세스를 요청합니다. 백그라운드 세션이 `~/Desktop`, `~/Documents`, `~/Downloads` 또는 다른 보호된 위치를 읽을 때 `Operation not permitted`를 보고하면, 시스템 설정의 개인정보 보호 및 보안 > 파일 및 폴더에서 액세스를 허용하거나 항목에 대해 전체 디스크 액세스를 활성화합니다.

기본 설치 프로그램을 사용하면 항목이 Claude Code로 표시되고 권한이 업데이트 전체에서 유지됩니다. Homebrew 또는 npm과 같은 다른 설치 방법을 사용하면 항목이 바이너리 경로를 표시하며 업데이트 후 다시 권한을 부여해야 할 수 있습니다.

### macOS에서 백그라운드 세션이 로컬 네트워크 호스트에 도달할 수 없음

macOS 15 이상에서 시스템은 로컬 네트워크 권한을 부여할 때까지 프로세스가 로컬 네트워크의 장치에 도달하는 것을 차단하므로, LAN 주소를 대상으로 하는 명령은 포그라운드 터미널에서 작동하더라도 백그라운드 세션에서 `connect: no route to host`로 실패할 수 있습니다. 백그라운드 세션의 첫 번째 명령이 로컬 네트워크 주소에 연결되면 Claude Code에 대한 macOS 로컬 네트워크 권한 프롬프트를 트리거합니다. 한 번 부여하면 이러한 명령은 포그라운드 터미널에서와 동일한 방식으로 LAN 호스트에 도달합니다.

### 연결 후 세션이 응답이 느림

세션이 완료되었거나 입력을 기다리고 있으며 약 1시간 동안 연결되지 않으면, 감독자는 리소스를 확보하기 위해 프로세스를 중지합니다. 연결하면 중단된 위치에서 새로운 프로세스를 시작하고 프로세스가 다시 시작되는 동안 세션으로 즉시 전환합니다. 작업 중이거나 권한 프롬프트 또는 다른 대화 상자에서 일시 중지되거나 [고정된](#organize-the-list) 세션은 이런 식으로 중지되지 않으므로, `Ctrl+T`로 세션을 고정하여 응답성을 유지합니다.

프로세스가 시작되는 동안 Claude Code는 세션의 트랜스크립트의 마지막 부분을 라이브 세션이 렌더링하는 방식으로 포맷하여 표시합니다. 마크다운, 강조 표시된 코드 블록, 도구 호출은 흐린 행으로 표시되며, 그 아래에는 `Session is starting` 메모가 있는 흐린 프롬프트 영역이 있습니다. 라이브 세션이 준비되는 즉시 이를 대체합니다.

### `.claude/worktrees/`가 채워지고 있음

에이전트 뷰에서 세션을 삭제하면 Claude가 생성한 워크트리가 제거됩니다. 하지만 [일부 삭제는 워크트리를 유지하거나 디스크에 디렉토리를 남겨두므로](#what-deleting-a-session-removes) 남은 디렉토리가 누적될 수 있습니다. Git이 더 이상 인식하지 않는 디렉토리는 `git worktree list`에 나타나지 않으므로 이들을 직접 제거합니다.

프로젝트 디렉토리에서 `git worktree list`로 남은 항목을 나열하고 각각을 `git worktree remove <path>`로 제거합니다. [워크트리 정리](https://code.claude.com/docs/ko/worktrees.md#clean-up-worktrees)를 참조합니다.

## 제한 사항

에이전트 뷰는 연구 미리보기 상태이며 다음과 같은 제한 사항이 있습니다:

* **속도 제한 적용**: 백그라운드 세션은 대화형 세션과 동일하게 구독 사용량을 소모하므로 10개의 에이전트를 병렬로 실행하면 할당량을 약 10배 빠르게 소모합니다.
* **세션은 로컬입니다**: 백그라운드 세션은 사용자의 머신에서 실행되며 머신이 절전 모드로 전환되어도 유지되지만 머신이 종료되면 중지됩니다.
* **Claude에서 생성한 워크트리는 에이전트 뷰의 세션과 함께 삭제됩니다**: 자체 워크트리에서 파일을 편집한 세션을 삭제하기 전에 변경 사항을 커밋합니다. [일부 삭제는 워크트리를 대신 유지합니다](#what-deleting-a-session-removes).

## 관련 리소스

Claude를 병렬로 실행하는 다른 방법과 실행하는 세션 간에 발견 사항을 전달하는 방법은 다음을 참조하십시오:

* [에이전트를 병렬로 실행](https://code.claude.com/docs/ko/agents.md): 에이전트 뷰를 서브에이전트, 에이전트 팀 및 worktrees와 비교합니다
* [세션 간 메시징](https://code.claude.com/docs/ko/cross-session-messaging.md): 세션이 서로 발견 사항을 전달하도록 합니다
* [에이전트 팀](https://code.claude.com/docs/ko/agent-teams.md): 서로 메시지를 주고받는 여러 세션을 조정합니다
* [웹의 Claude Code](https://code.claude.com/docs/ko/claude-code-on-the-web.md): 로컬 대신 관리되는 클라우드 환경에서 세션을 실행합니다
* [프로젝트](https://code.claude.com/docs/ko/claude-projects.md): Claude가 하나의 대화에서 병렬 클라우드 세션을 조정하고 어떤 세션이 필요한지 알려줍니다

## 버전 기록

에이전트 뷰는 리서치 프리뷰 중에 빠르게 발전했습니다. 이전 Claude Code 버전을 사용 중인 경우 이 페이지의 일부 동작이 다를 수 있습니다. 특히 `claude agents`는 아직 지원하지 않는 플래그를 `unknown option` 오류로 거부합니다. 아래 표는 각 플래그와 동작이 추가된 시기를 나열합니다.

| 버전 | 변경 사항 |
| - | - |
| v2.1.299 | [디스패치 입력의 `/effort` 및 `/fast`](#set-the-model-effort-and-fast-mode)는 다음에 디스패치하는 세션의 effort 수준과 빠른 모드를 설정합니다. 값 없이 입력한 `/model`, `/effort`, `/fast`는 선택기를 엽니다. |
| v2.1.299 | Claude Code는 단순 `--` 구분자 앞이면서 다른 플래그의 값 밖에 있을 때만 [`--bg`와 `--background`를 플래그로 읽으며](#from-your-shell), 모호한 위치에서는 추측하는 대신 거부합니다. 이 릴리스 이전에는 백그라운드 세션에 보내는 `--bg` 또는 `--background`라는 프롬프트나 회신이 플래그로 해석될 수 있었습니다. 이로 인해 텍스트를 전달하는 대신 새 백그라운드 세션이 반복해서 시작될 수 있었습니다. |
| v2.1.296 | [세션이 백그라운드로 이동하는 동안](#switch-sessions-without-leaving-the-terminal) 입력한 프롬프트나 `!` 셸 명령은 중지되거나 전송되지 않은 상태로 남으며, 그 텍스트는 프롬프트 기록에 유지됩니다. 이 릴리스 이전에는 응답이나 명령이 더 이상 볼 수 없는 곳에서 계속 실행되었으며, `←` 직후 보낸 프롬프트가 보이지 않는 곳에서 두 번 실행될 수 있었습니다. `SessionStart` 훅이 아직 실행 중일 때 입력한 프롬프트는 손실되었습니다. 전송되지도 않았고 프롬프트 기록에도 남지 않았습니다. |
| v2.1.295 | [연결된 백그라운드 세션](#attach-to-a-session)의 유휴 프롬프트에서 `Ctrl+C`는 [자체 페이스 `/loop`](https://code.claude.com/docs/ko/scheduled-tasks#let-claude-choose-the-interval)의 보류 중인 깨우기를 건드리지 않으므로, 두 번 누르면 분리되고 루프는 계속 실행됩니다. 해당 프롬프트에서 `Esc`는 [자체 페이스 루프를 중지](https://code.claude.com/docs/ko/scheduled-tasks.md#stop-a-loop)하고 `Pending wakeup cancelled` 알림을 표시합니다. 이 릴리스 이전에는 첫 번째 `Ctrl+C`가 아무런 알림 없이 자체 페이스 루프를 종료할 수 있었으며, `Esc`는 세션과 함께 백그라운드로 이동한 루프를 중지하지 않았습니다. |
| v2.1.295 | macOS 및 Linux에서 [감독자](#keep-sessions-running-after-the-supervisor-stops)가 실행 중이지 않을 때 `claude agents`가 종료되면 스스로 새 감독자를 시작하지 않습니다. 그러면 `claude agents`를 다시 실행하지 않는 한 실행 중인 세션은 약 1분 후에 중지되며, 에이전트 뷰는 종료하면서 이를 알리는 알림을 출력할 수 있습니다. 이 릴리스 이전에는 종료하는 `claude agents`가 새 감독자를 시작했습니다. |
| v2.1.295 | 네이티브 설치 프로그램을 사용하는 macOS에서 업데이트 후 함께 다시 시작되는 백그라운드 세션은 사용자가 부여한 [보호된 폴더 액세스](#background-sessions-can’t-read-desktop-documents-or-downloads-on-macos)를 보유한 동일한 Claude Code 항목으로 실행됩니다. 이 릴리스 이전에는 이러한 세션이 대신 바이너리 자체 경로로 실행될 수 있었습니다. macOS는 해당 경로를 별도 항목으로 나열하므로 업데이트 후 폴더 액세스 프롬프트가 다시 나타날 수 있었습니다. |
| v2.1.290 | [`claude attach` 및 `claude logs`](#manage-sessions-from-the-shell)는 ID 대신 세션 이름의 일부를 받을 수 있습니다. |
| v2.1.290 | 작업 중인 세션에 [엿보기 회신](#peek-and-reply)으로 보낸 `/model`, `/effort`, `/rename`, `/usage`는 즉시 실행됩니다. |
| v2.1.290 | 전달할 수 없는 [엿보기 회신](#peek-and-reply)은 `/`로 시작하거나, 세션의 프로세스가 실행 중인 동안 미리 정의된 선택지가 있는 질문에 답하는 경우 더 이상 다음 재시작을 위해 저장되지 않습니다. |
| v2.1.288 | `Ctrl+F`는 이름으로 세션을 찾고, `Alt+↑` / `Alt+↓`는 그룹 헤더 사이를 이동합니다. 이 두 가지와 `Ctrl+R`은 [다시 바인딩](https://code.claude.com/docs/ko/keybindings.md#agents-actions)할 수 있습니다. |
| v2.1.287 | [`n:<text>` 필터](#filter-sessions)는 이름이나 첫 프롬프트로 세션을 찾습니다. 필터가 활성화되어 있는 동안에는 접어 둔 그룹이 펼쳐져 일치 항목을 표시하고 첫 번째 일치 항목이 선택되므로 `Enter`로 바로 열 수 있습니다. |
| v2.1.287 | [엿보기 회신](#peek-and-reply)으로 보낸 명령은 세션의 현재 턴이 끝날 때 실행되며, 세션 자체 프롬프트에서 입력하는 즉시 실행되는 명령도 마찬가지입니다. 정확히 `/stop`인 회신은 세션을 즉시 중지합니다. |
| v2.1.281 | [`--setting-sources`](https://code.claude.com/docs/ko/cli-reference#cli-flags) 제한이 `←` 또는 `/bg`로 백그라운드하는 세션과 에이전트 뷰에서 디스패치하는 세션으로 [이월](#what-carries-over-when-you-background)됩니다. 이 릴리스 이전에는 생성된 세션이 모든 설정 소스를 로드했습니다. |
| v2.1.281 | `claude --bg`와 세션을 다시 시작하는 명령은 먼저 세션의 디렉터리에 대한 워크스페이스 신뢰를 확인합니다. 해당 디렉터리의 터미널에서는 아직 수락하지 않았다면 [신뢰 대화 상자가 나타납니다](#from-your-shell). 스크립트와 같이 대화 상자가 나타날 수 없는 곳에서는 명령이 [`Workspace not trusted`](https://code.claude.com/docs/ko/errors#workspace-not-trusted-when-dispatching-a-background-session) 오류로 종료됩니다. |
| v2.1.274 | 자동 업데이트 후 약 1시간 동안 떠나 있던 에이전트 뷰는 새 빌드로 자신을 다시 시작할 수 있습니다. 이렇게 할 때 열었던 [디스패치 기본값](#dispatch-defaults)을 유지합니다: `--model`, `--effort`, `--permission-mode`, `--allow-dangerously-skip-permissions`, `--agent`. 이 릴리스 이전에는 다시 시작된 뷰가 `--cwd` 및 `--settings`, `--mcp-config`와 같은 구성 플래그만 유지했으므로 그 후 디스패치한 세션은 해당 기본값 없이 시작되었습니다. |
| v2.1.274 | git이나 `WorktreeRemove` 훅이 워크트리를 제거할 수 없어 [삭제가 거부](#what-deleting-a-session-removes)될 때, Claude Code가 추적된 파일에 커밋되지 않은 변경 사항이 없음을 확인한 체크아웃된 서브모듈은 다시 삭제하여 디렉터리를 어쨌든 제거하는 제안을 차단하지 않습니다. 체크아웃된 서브모듈 내의 커밋되지 않은 작업은 커밋되지 않은 변경 사항으로 계산되며 메시지는 서브모듈의 이름을 명시합니다. 이 릴리스 이전에는 워크트리의 모든 서브모듈 체크아웃이 제안을 차단했으며 메시지는 워크트리에 중첩된 저장소가 포함되어 있다고 말했습니다. |
| v2.1.268 | git이나 `WorktreeRemove` 훅이 워크트리를 제거할 수 없어 [삭제가 거부](#what-deleting-a-session-removes)될 때 메시지는 원인을 명시하며, 훅이 어떻게 종료되었는지와 stderr의 시작 부분을 포함합니다. 저장소의 `.claude/worktrees/` 아래의 연결된 워크트리로, 추적된 파일에 커밋되지 않은 변경 사항이 없고, 내부에 중첩된 저장소가 없으며, 다른 세션의 레코드가 이를 명시하지 않으면 세션을 다시 삭제하면 에이전트 뷰에서 또는 `claude rm <id> --force-remove-worktree <worktree-id>`로 디렉터리가 어쨌든 제거됩니다. 이 릴리스 이전에는 행이 `worktree could not be removed (WorktreeRemove hook failed)` 또는 git의 오류만 표시했으며, 훅의 stderr은 디버그 로그로만 이동했고, 다시 삭제하면 같은 방식으로 거부되었습니다. |
| v2.1.268 | 첫 `←`가 `Press ← again to open agents` 또는 연결된 세션에서 `Press ← again to go back to agents`를 표시한 후 [최소 1초 후에 도착하는 첫 번째 누름이 전환](#switch-sessions-without-leaving-the-terminal)되며, 그 사이의 더 빠른 누름이 무시되었어도 전환됩니다. 이 릴리스 이전에는 무시된 각 누름이 대기를 다시 시작했으므로 `←`를 꾸준한 속도로 다시 누르면 1초 이상 일시 중지할 때까지 전환되지 않았습니다. |
| v2.1.260 | [세션을 백그라운드로 이동](#from-inside-a-session)할 때 다른 세션의 [에이전트 목록](https://code.claude.com/docs/ko/cross-session-messaging.md#see-which-sessions-claude-can-reach)은 대화를 백그라운드 세션으로 한 번만 표시하며, 이에 대한 메시지는 더 이상 이동하기 전의 터미널에 도달하지 않습니다. 이 릴리스 이전에는 해당 터미널이 대화 이름 아래 두 번째 대화형 세션으로 나열될 수 있었으며, 이동 전에 대화에 메시지를 보낸 세션은 계속해서 해당 터미널에 전달했습니다. |
| v2.1.260 | [푸시되지 않은 커밋으로 인해 삭제가 거부](#what-deleting-a-session-removes)될 때 메시지는 워크트리의 브랜치 이름과 푸시되지 않은 커밋 수를 명시하며, 세션을 다시 삭제하면 워크트리와 그 커밋이 삭제됩니다. 이 릴리스 이전에는 거부 메시지가 `worktree has commits that are not pushed anywhere`만 표시했으며, 다시 삭제하면 같은 방식으로 거부되었고, 세션을 삭제하려면 커밋을 푸시하거나 워크트리를 수동으로 제거해야 했습니다. |
| v2.1.257 | `←`는 [`/btw` 오버레이가 열려 있는 동안](#attach-to-a-session) 답변 중간에도 연결된 세션에서 분리되며, 다음에 연결할 때 오버레이가 다시 열립니다. 이 릴리스 이전에는 오버레이가 열려 있는 동안 `←`가 분리되지 않았습니다. |
| v2.1.257 | [`claude --resume <session-id> --bg`](#from-your-shell)를 실행할 때 Claude Code는 해당 세션을 자신의 ID로 계속하거나 새 ID로 복사본을 시작하고 이유를 설명하는 `note:` 줄을 출력합니다. `--continue`, 단순 `--resume`, 그리고 이름이나 경로가 있는 `--resume`은 같은 메모와 함께 복사본을 시작합니다. 이 릴리스 이전에는 `--resume`과 `--bg`가 항상 새 ID로 복사본을 시작했으며 아무것도 말하지 않았습니다. |
| v2.1.257 | `←`로 연 에이전트 뷰에서 세션을 디스패치할 때 Claude Code는 `permissions.defaultMode`를 통해 [대상 디렉터리가 구성하는 권한 모드](#permission-mode)에서 시작합니다. 디렉터리가 설정하지 않으면 원래 세션의 권한 모드가 적용됩니다. 이 릴리스 이전에는 디스패치된 세션이 항상 원래 세션의 권한 모드에서 시작하여 이를 재정의했습니다. |
| v2.1.257 | 에이전트 뷰에서 `Ctrl+S`, `Ctrl+T`, `Ctrl+G`는 [`keybindings.json`을 따릅니다](#keyboard-shortcuts): `Ctrl+S`와 `Ctrl+T`는 `Agents` 컨텍스트의 `agents:switchView` 및 `agents:togglePin` 작업을 통해, `Ctrl+G`는 `Chat` 컨텍스트의 `chat:externalEditor` 바인딩을 통해 따릅니다. 이 릴리스 이전에는 에이전트 뷰가 `keybindings.json`을 무시했으며 이 키들은 고정되어 있었습니다. |
| v2.1.257 | [백그라운드 서비스](#the-supervisor-process) 시작은 두 가지 실패 원인에서 복구됩니다. macOS npm 설치에서 자체 업데이트 중 시작은 바이너리를 교체하는 동안 npm이 배치한 자리 표시자를 실행하는 대신 [설치를 기다립니다](https://code.claude.com/docs/ko/errors.md#eacces-when-starting-a-background-session). Windows에서는 머신이 마지막으로 부팅되기 전에 작성되었거나 기록된 프로세스 ID가 이제 다른 프로세스에 속하는 오래된 `daemon.lock`이 교체됩니다. 이 릴리스 이전에는 macOS 시작이 설치 중에 `Error: claude native binary not installed.` 오류로 실패했으며, Windows 잠금으로 인해 `~/.claude/daemon.lock`을 삭제할 때까지 모든 시작이 [`exited before it became reachable`](https://code.claude.com/docs/ko/errors#background-service-exited-before-it-became-reachable)로 실패했습니다. |
| v2.1.257 | 다른 Claude Code 프로세스가 npm 업데이트를 다운로드하는 동안 백그라운드 세션을 열거나 디스패치할 때 Claude Code는 설치가 실행되는 동안 [최대 2분까지 계속 기다린 후](https://code.claude.com/docs/ko/errors.md#eacces-when-starting-a-background-session) `Claude Code is being updated by npm on this machine`이라는 메시지와 함께 실패합니다. 이 릴리스 이전에는 대기가 10초에서 중지되어 다운로드가 여전히 실행 중일 때 `Couldn't start the background service`로 열기가 실패했습니다. |
| v2.1.257 | 승인을 위해 [교차 세션 메시지](https://code.claude.com/docs/ko/cross-session-messaging.md#control-inbound-messages)를 보류 중인 백그라운드 세션은 `Needs input` 행에 `approve message from`을 표시하며, 발신자의 주소와 발신자가 주장하는 이름이 표시됩니다. 이 릴리스 이전에는 행이 `Needs input`으로 이동했지만 이전 텍스트를 유지했으므로 `claude agents`의 어디에서도 대기 중인 메시지나 발신자를 명시하지 않았습니다. |
| v2.1.257 | 열린 백그라운드 세션 내에서 `Ctrl+S`로 보관한 프롬프트는 [세션과 함께 유지](#what-persists-across-restarts)되므로 세션의 프로세스가 중지되고 다시 시작된 후 `Ctrl+S`가 이를 복원합니다. 이 릴리스 이전에는 보관된 프롬프트가 실행 중인 프로세스에만 존재했으며 세션이 충분히 오래 유휴 상태가 되어 프로세스가 중지되거나 중지되었다가 다시 열릴 때 손실되었습니다. |
| v2.1.251 | [워크트리로 이동](#how-file-edits-are-isolated)하지 않은 백그라운드 세션에서 Claude와 생성하는 서브에이전트는 연결된 git 워크트리 내의 파일을 편집할 수 있습니다. |
| v2.1.251 | Claude Code는 디스패치하는 셸에서 내보낸 클라우드 제공자 게이트웨이(예: `ANTHROPIC_VERTEX_BASE_URL` 또는 `ANTHROPIC_BEDROCK_BASE_URL`과 그 인증 우회 플래그)를 `ANTHROPIC_BASE_URL`과 같은 조건 아래 [세션의 워커](#llm-gateway)로 전달합니다. 이 릴리스 이전에는 이러한 게이트웨이를 통해서만 인증된 셸에서 백그라운드하거나 디스패치했다면 세션이 만드는 모든 요청이 실패했습니다. 엔드포인트와 플래그가 환경에서 삭제되었기 때문입니다. |
| v2.1.251 | 백그라운드 세션이 다른 Claude Code 프로세스가 [플러그인 마켓플레이스](https://code.claude.com/docs/ko/plugins/overview.md)를 새로 고치는 동안 시작될 때(예: [마켓플레이스 자동 업데이트](https://code.claude.com/docs/ko/plugins/install.md#keep-plugins-updated)를 실행하는 형제 세션) Claude Code는 해당 마켓플레이스의 플러그인을 사용 가능하게 유지합니다. 이 릴리스 이전에는 이러한 세션이 해당 마켓플레이스의 스킬, 에이전트, 훅, MCP 서버 없이 시작될 수 있었으며 전체 실행 동안 그대로 유지되었습니다. |
| v2.1.248 | [디스패치 입력](#keyboard-shortcuts)에서 `Shift+Enter`는 줄바꿈을 삽입하여 주 프롬프트와 일치하며, `Ctrl+Enter`는 `?` 오버레이가 `ctrl+enter to start and open`을 나열하는 터미널에서 즉시 디스패치하고 연결합니다. 이 릴리스 이전에는 `Shift+Enter`가 디스패치하고 연결했습니다. |
| v2.1.248 | [세션 삭제](#what-deleting-a-session-removes)는 워크트리의 커밋이 이미 `origin` 원격의 기본 브랜치의 로컬 복사본에 있고 주 체크아웃이 해당 브랜치를 체크아웃했을 때 성공합니다. 이 릴리스 이전에는 삭제가 `has commits that are not pushed anywhere`로 거부되었습니다. |
| v2.1.248 | `←` 또는 `/background`로 백그라운드된 세션은 실행되는 동안 워크트리에 [`git worktree lock`](https://code.claude.com/docs/ko/worktrees#clean-up-subagent-and-background-session-worktrees)을 유지합니다. 이 릴리스 이전에는 백그라운드하면 잠금이 해제되었으며 정리 또는 `git worktree remove`가 실행 중인 세션 아래의 워크트리를 제거할 수 있었습니다. |
| v2.1.248 | 입력을 기다리지 않았으며 마지막 활동 후 48시간 이상 지난 후 종료된 것으로 발견된 백그라운드 세션(예: 머신이 며칠 동안 꺼져 있었던 후)은 `ended while the background service was off`와 함께 [중지됨으로 표시](#sessions-show-as-failed-after-shutdown)되며, `Enter`를 누르면 저장된 대화를 재개하기 전에 묻습니다. 이 릴리스 이전에는 이러한 세션이 목록 맨 위로 정렬된 새로운 실패로 다시 나타났으며, 단일 `Enter`가 몇 주 전의 대화를 포그라운드로 끌어왔습니다. |
| v2.1.248 | 대화를 [다른 터미널에서 재개](#opening-a-session-says-the-conversation-is-already-open)한 중지된 행을 열면 `Can't open — this session is running in another terminal`로 거부되며, 행은 `Working` 아래 표시되는 대신 `Open in a terminal`을 표시합니다. 이 릴리스 이전에는 행을 열면 같은 대화에 쓰는 두 번째 프로세스가 시작되었습니다. |
| v2.1.248 | `PermissionRequest` 또는 `PreToolUse` 훅이 잘못된 답변을 출력한 상태에서 권한 결정을 기다리는 백그라운드 세션은 [훅 이벤트와 스키마 오류를 행에 명시](#peek-and-reply)합니다. 이 릴리스 이전에는 행이 보류 중인 요청만 표시했습니다. |
| v2.1.248 | Windows에서 `claude agents`는 이전 프로그램이 win32-input-mode로 남긴 터미널 탭에서 시작될 때 키보드에 응답합니다. 이 릴리스 이전에는 Claude Code가 이러한 탭이 보내는 키 레코드를 디코딩하지 않았습니다. |
| v2.1.247 | Linux 및 WSL에서 [터미널 호스트 프로세스가 죽은](#the-terminal-host-died-or-the-session-stopped-responding) 세션은 몇 초 내에 이유와 함께 실패합니다. 출력이 없는 열기는 약 10초 후 재시작 제안과 함께 끝나며, 행에서 `Enter`를 누르면 대화와 함께 세션을 다시 시작합니다. `claude attach <id>`는 원인을 보고하고 종료합니다. 이 릴리스 이전에는 이러한 세션을 열면 `opening… · esc to cancel`이 무한정 표시되었으며 `claude attach <id>`는 오류를 보고하지 않고 기다렸습니다. |
| v2.1.246 | npm 설치에서 `npm install -g @anthropic-ai/claude-code`가 바이너리를 교체하는 동안 [백그라운드 서비스](#the-supervisor-process)가 시작되지 않으면 Claude Code는 설치가 완료될 때까지 최대 10초를 기다리고 재시도한 후 [`EACCES: permission denied`](https://code.claude.com/docs/ko/errors#eacces-when-starting-a-background-session)를 보고합니다. |
| v2.1.246 | [백그라운드 서비스](#the-supervisor-process) 프로세스가 오류를 출력한 후 죽으면 Claude Code는 실패를 보고하고 [서비스의 첫 번째 오류 줄을 인용](https://code.claude.com/docs/ko/errors.md#background-service-exited-before-it-became-reachable)합니다. |
| v2.1.246 | [백그라운드 서비스](#the-supervisor-process)가 시작되는 동안 머신이 절전 모드로 전환되면 Claude Code는 실패하는 대신 시작을 한 번 재시도합니다. |
| v2.1.246 | Claude Code는 살아 있지만 연결 수락이 느린 새로 시작된 [백그라운드 서비스](#the-supervisor-process)를 45초 대신 약 2분 동안 기다립니다. |
| v2.1.246 | [백그라운드 서비스](#the-supervisor-process)는 홈 디렉터리에서 시작되므로 macOS 및 Linux에서 삭제되거나 이동된 시작 디렉터리는 더 이상 시작을 차단하지 않습니다. |
| v2.1.246 | `/fork`는 자체가 복사본으로 시작했으며 이후 새 프롬프트를 기록하지 않은 세션에서 [전체 대화를 복사](#copy-the-session-with-%2Ffork)합니다: 연결한 `/fork` 복사본, `←` 또는 `/background`가 백그라운드로 이동한 후 다시 연결한 세션, 또는 `claude --resume <id> --fork-session`으로 시작한 세션입니다. 이 릴리스 이전에는 이러한 세션에서 새 프롬프트를 보내기 전에 `/fork`를 실행했다면 Claude Code가 일반적인 확인을 출력했지만 빈 대화로 복사본을 시작했습니다. 이러한 세션을 `←` 또는 `/background`로 백그라운드로 이동하면 같은 방식으로 대화가 손실되었습니다. |
| v2.1.246 | 방금 디스패치한 세션을 워커 프로세스가 여전히 시작 중일 때 열 때(예: 행에서 `Enter`를 누를 때) Claude Code는 프로세스를 기다린 후 연결합니다. 이 릴리스 이전에는 프로세스가 여전히 시작 중일 때 `Enter`를 누르면 Claude Code가 [`Session <id> was stopped while the respawn was in flight`](https://code.claude.com/docs/ko/errors#session-was-stopped-while-the-respawn-was-in-flight)로 세션을 중지할 수 있었습니다. |
| v2.1.246 | 이름이 지정된 세션을 [백그라운드](#from-inside-a-session)로 이동할 때 Claude Code는 이를 한 번 나열하며, 같은 대화를 다시 백그라운드로 이동할 때 새 행의 이름에 번호를 붙이고(예: `my-session (2)`), 기존 행은 이름을 유지합니다. 이 릴리스 이전에는 `←`를 누른 터미널이 `claude agents --json`에 같은 이름 아래 두 번째 세션으로 나타날 수 있었으며, 같은 대화를 다시 백그라운드로 이동했다면 Claude Code가 동일한 이름 아래 다른 행을 추가했습니다. |
| v2.1.239 | [vim 편집기 모드](https://code.claude.com/docs/ko/interactive-mode.md#vim-editor-mode)가 켜져 있을 때 에이전트 뷰의 입력에서 `Esc`를 누르면 INSERT에서 NORMAL 모드로 전환되고 텍스트를 유지하여 주 프롬프트와 일치합니다. NORMAL 모드에서 입력에 텍스트가 여전히 있으면 `Esc`를 누르면 지워지고, 빈 입력에서 `Esc`를 누르면 [`Esc` 단축키](#keyboard-shortcuts)가 설명하는 대로 종료됩니다. 이 릴리스 이전에는 `Esc`가 입력을 지웠습니다. |
| v2.1.233 | GitLab 병합 요청에 연결된 세션의 경우 Claude Code는 행의 레이블을 GitLab의 `!1234` 참조 구문으로 작성합니다. [디스패치 입력](#filter-sessions)에 병합 요청의 URL을 붙여넣어 해당 세션을 선택할 수도 있습니다. 이 릴리스 이전에는 레이블이 `#1234`로 렌더링되었으며, 붙여넣은 병합 요청 URL은 첫 프롬프트에 URL이 포함된 경우에만 세션과 일치했습니다. |
| v2.1.227 | [세션 삭제](#what-deleting-a-session-removes)는 다른 라이브 Claude Code 세션이 해당 워크트리 디렉터리 내에서 실행 중일 때 세션과 워크트리를 유지합니다. 에이전트 뷰는 행에 `not deleted`를 표시하고 바닥글에 이유를 표시하며, `claude rm`은 이유와 함께 `kept <id>`를 출력하고, 이유에는 다른 세션의 프로세스 ID가 명시됩니다. 이 릴리스 이전에는 세션을 삭제하면 다른 세션이 여전히 작업 중일 때 워크트리가 제거되었습니다. |
| v2.1.225 | 신뢰하지 않은 디렉터리에서 `claude agents`는 `claude`가 시작 시 표시하는 것과 같은 [워크스페이스 신뢰 대화 상자](https://code.claude.com/docs/ko/permissions.md#project-allow-rules-and-workspace-trust)를 에이전트 뷰가 열리기 전에 표시합니다. 수락하면 해당 워크스페이스에 대한 신뢰가 저장되고, 거부하면 에이전트 뷰를 열지 않고 종료됩니다. 이 릴리스 이전에는 `claude agents`가 묻지 않고 열렸으므로 디스패치한 세션이 신뢰 여부를 요청받은 적 없는 디렉터리에서 실행되었습니다. 목록이 디렉터리별로 그룹화되면 행 위에 마우스를 가져가도 [디스패치 대상](#dispatch-to-a-specific-directory)을 변경하지 않고 강조 표시만 되며, 화살표 키 또는 클릭으로 행을 선택하면 여전히 대상이 변경됩니다. 이 릴리스 이전에는 다른 프로젝트의 세션 위로 마우스를 이동하면 다음에 디스패치된 세션이 시작되는 디렉터리가 조용히 변경되었습니다. |
| v2.1.221 | `/status`는 `Session kind` 행을 표시합니다: 터미널이 연결되어 있는지 여부에 따라 백그라운드 세션에서 `background job · attached` 또는 `background job · unattended`, 다른 모든 세션에서 `interactive`입니다. 이 릴리스 이전에는 `/status`가 세션 종류를 보고하지 않았습니다. `/fork`: Claude Code는 [복사본](#from-inside-a-session)에 원본 세션의 작업과 격리하도록 지시합니다: 복사본은 코드를 변경하기 전에 자신의 워크트리를 생성하고, 원본 세션의 워크트리에서 벗어나 있으며, 작업이 원본의 작업을 기반으로 할 때 원본의 브랜치를 기반으로 새 브랜치를 생성합니다. 정확한 조건은 연결된 섹션을 참조하십시오. 이 릴리스 이전에는 복사본이 격리 지시를 받지 않았으며 원본 세션이 작업 중인 워크트리나 체크아웃을 편집할 수 있었습니다. [vim 편집기 모드](https://code.claude.com/docs/ko/interactive-mode.md#vim-editor-mode)가 켜져 있을 때 `u`로 프롬프트를 되돌려 비운 직후 `←`를 누르면 텍스트를 삭제하거나 프롬프트 기록을 이동하는 것과 같은 확인을 요청하며, 두 번째 누름에서만 전환됩니다. 이 릴리스 이전에는 누름이 즉시 전환되었습니다. |
| v2.1.219 | [vim 편집기 모드](https://code.claude.com/docs/ko/interactive-mode.md#vim-editor-mode)가 켜져 있을 때 빈 프롬프트에서 `←`를 누르면 INSERT뿐만 아니라 NORMAL 모드에서도 에이전트 뷰를 열며, 바닥글의 `←` 힌트는 NORMAL 모드에서도 표시됩니다. 이 릴리스 이전에는 제스처와 힌트가 INSERT 전용이었으며, NORMAL 모드에서 빈 프롬프트에 `←`를 누르면 아무것도 하지 않았습니다. Claude Code가 세션을 백그라운드로 이동하기를 기다리는 동안 입력에 입력하면 `Backgrounding cancelled — you have unsent text in the input. Send it or clear it, then press ← again.`으로 전환이 취소되므로 입력된 초안이 손실되지 않습니다. |
| v2.1.218 | 프롬프트를 비운 삭제 또는 프롬프트 기록을 이동한 후 2초 이내에 `←`를 누르면 `Press ← again to open agents` 또는 연결된 세션에서 `Press ← again to go back to agents`를 표시하며, 최소 1초 후 두 번째 누름에서만 전환됩니다. 이 릴리스 이전에는 누름이 즉시 전환되었습니다. 붙여넣거나 스크립트된 입력 내에 도착하는 `←`는 더 이상 전환을 트리거하지 않습니다. `←`로 포그라운드 세션을 백그라운드로 이동하면 목록 위에 `Your conversation moved to the background`를 표시하고, 에이전트 뷰의 루트에서 `Esc`를 누르면 셸로 종료하는 대신 해당 대화로 돌아가며, 이중 `Ctrl+C`는 종료로 유지됩니다. 대화를 다시 열 수 없으면 Claude Code가 종료되고 해당 대화에 대한 `claude --resume` 명령을 출력합니다. Windows에서 연결 후 약 0.5초 이내에 누른 `←`는 `Ambiguous ←, press again to detach`를 표시하고 두 번째 누름에서 분리됩니다. |
| v2.1.217 | 세션 행의 풀 리퀘스트 배지는 Claude Code가 터미널 하이퍼링크 지원을 감지할 수 없을 때(예: SSH 또는 tmux를 통해)도 하이퍼링크로 렌더링되며, [`FORCE_HYPERLINK=0`](https://code.claude.com/docs/ko/env-vars)을 설정하면 일반 텍스트로 렌더링됩니다. 이 릴리스 이전에는 지원이 감지되지 않으면 배지가 일반 텍스트로 렌더링되었습니다. |
| v2.1.216 | `/fork`: [확인](#from-inside-a-session)은 한 줄이며, 복사본의 상태, 에이전트 뷰 행의 이름, `claude attach`의 세션 ID를 표시하며, 복사본이 주 작업 트리에서 실행되거나 열린 체크아웃을 편집할 때만 `runs in the origin tree` 또는 `edits this checkout`으로 끝납니다. 이름을 클릭하면 이 세션을 백그라운드로 이동하고 복사본의 세션에서 에이전트 뷰를 엽니다. 확인은 더 이상 복사본의 상속된 권한 모드를 다시 설명하지 않습니다. 이전 버전은 클릭 가능한 이름이 없는 여러 줄 확인을 출력했습니다. 입력 필요: `/install-github-app` 및 `/mcp` 설정 목록은 아무도 연결되지 않은 상태에서 실행될 때 세션을 `Needs input` 아래 표시하며 명령을 명시하는 행을 표시하고, 연결하고 명령을 다시 실행하면 계속됩니다. v2.1.208부터 v2.1.215까지는 해당 상태에서 완전히 거부되었습니다. `--agent` 복원: [백그라운드된 `--agent` 세션](#from-your-shell)을 재개하거나 다시 시작할 때 워크스페이스가 신뢰된 경우 에이전트의 시스템 프롬프트와 도구 제한을 복원하며, 세션 자신의 디렉터리에서 에이전트를 먼저 검색합니다. 에이전트가 더 이상 존재하지 않는 세션은 기본 도구 및 시스템 프롬프트로 계속되며 보이는 경고와 함께 열리고, 기본 에이전트로 조용히 되돌아가지 않습니다. `Ctrl+X`: 두 번 누르면 중지 시도가 실패해도 세션이 삭제되며, 실패한 중지가 보류 중인 삭제를 취소하지 않습니다. 또한 워커 프로세스가 죽은 삭제된 세션은 다음 새로 고침에서 다시 나타나지 않습니다. 워크트리 삭제: 워크트리 디렉터리가 git 저장소에 속하지 않는 세션은 삭제할 수 있습니다. 이 릴리스 이전에는 이러한 세션을 삭제하려는 모든 시도가 거부되었습니다. 이미 없는 디렉터리는 즉시 지워집니다. 에이전트 뷰 이중 누름은 다른 세션의 레코드도 이를 명시하지 않는 한 파일이 여전히 있는 디렉터리를 제거하며, 훅이 생성한 디렉터리에 대해서는 `WorktreeRemove` 훅을 실행합니다. `claude rm`은 파일이 남아 있을 때마다 이러한 디렉터리를 유지합니다. |
| v2.1.214 | `←` 또는 `/background`로 백그라운드된 세션이 실행 중인 것이 없이 유휴 상태로 남겨지면 다른 유휴 세션처럼 프로세스가 중지되며, 프로세스와 백그라운드 서비스를 무한정 실행 상태로 유지하지 않습니다. 완료된 세션은 백그라운드 서비스가 유휴 상태가 된 후 `claude rm` 또는 에이전트 뷰에서 제거할 수 있으며, git 저장소가 아닌 디렉터리(예: 다중 저장소 워크스페이스 폴더)에서 디스패치된 후 워크트리로 들어간 세션은 워크트리 자체가 git 저장소에 속할 때 에이전트 뷰에서 삭제할 수 있습니다. 정리가 디스패치된 디렉터리 대신 워크트리에서 해결되기 때문입니다. 두 제거 모두 이전에는 모든 시도에서 거부되었습니다. 중지된 세션을 다시 열면 트랜스크립트 저장소의 폴더를 읽을 수 없을 때도 저장된 대화를 복원합니다. |
| v2.1.213 | `/install-github-app`, [`/mcp`](https://code.claude.com/docs/ko/mcp) 설정 목록, MCP 인증 작업은 터미널이 연결된 백그라운드 세션에서 작동하며, 아무도 연결되지 않았을 때만 거부되고, 연결하여 명령을 다시 실행하라는 메시지가 표시됩니다. v2.1.208부터 v2.1.212까지는 터미널이 연결되어 있어도 거부되었습니다. |
| v2.1.212 | [대화형 세션의 `/fork`](#from-inside-a-session)는 원본이 계속 실행되는 동안 대화를 새로운 백그라운드 세션으로 복사합니다. `/fork`의 이전 포크된 서브에이전트 동작은 `/subtask`로 이동했습니다. [에이전트 뷰가 꺼져 있으면](#turn-off-agent-view) `/fork`는 포크된 서브에이전트 동작을 유지합니다. |
| v2.1.212 | [에이전트 뷰에서 단순 `/resume`을 입력하면](#bring-back-a-past-session) 에이전트 뷰를 연 저장소의 과거 세션 선택기가 열립니다. |
| v2.1.211 | 세션이 실행되는 디렉터리에서 연결하거나 회신하여 중지된 세션을 깨우면 새 디스패치와 같은 조건 아래 셸의 게이트웨이 `ANTHROPIC_BASE_URL`을 다시 전달하므로, 게이트웨이 `ANTHROPIC_AUTH_TOKEN`으로 인증된 세션은 `Not logged in`을 보고하는 대신 게이트웨이에서 재개됩니다. 첫 응답이 완료되기 전에 다른 대화에서 백그라운드된 중지된 세션에 연결하면 같은 세션 ID로 빈 대화를 조용히 시작하는 대신 `This session has no saved transcript`로 거부되며, 에이전트 뷰에서 같은 행을 열면 바닥글에 거부를 표시했습니다. Claude Code 외부에서 `←` 또는 `/background` 세션의 프로세스를 종료하면 감독자가 다시 시작하는 대신 중지됨으로 표시되고, 이미 디스크에 기록된 중지는 보낸 회신이 여전히 전달 대기 중이 아니면 준수되며, 충돌 후 다시 시작된 세션은 다시 시작되었다는 사실을 전달받고, 다시 시작된 `←` 또는 `/background` 세션은 약 1시간보다 오래된 중단된 응답을 재개하지 않습니다. 프롬프트에 레이블을 지정하는 대신 답변하거나 거부하는 세션 이름 지정 회신(예: 대부분 링크인 프롬프트의 경우)은 폐기되며 행은 프롬프트 텍스트에서 가져온 이름을 유지합니다. git이 더 이상 워크트리를 인식하지 않는 세션을 삭제하면 모든 시도가 거부되는 대신 성공하며, 워크트리 디렉터리를 디스크에 남기고 그 경로를 명시합니다. 거부된 삭제는 행이 조용히 다시 나타나는 대신 세션 행에 이유를 표시하며, 워크트리를 제거할 수 없을 때는 기본 git 오류도 포함합니다. |
| v2.1.210 | `claude attach`는 백그라운드 서비스가 시작되거나 다시 연결되는 동안 `job not found` 또는 `still starting` 오류로 실패하는 대신 기다리며, 연결 중에 완료된 세션을 종료됨으로 보고하고, 느린 연결 중에 만든 터미널 크기 조정을 연결이 완료될 때 적용합니다. 프롬프트 바닥글의 `←` 입력 필요 개수는 이전에 일반 `← for agents` 형식을 표시한 타사 제공자를 포함한 모든 제공자에 나타납니다. `←`로 세션을 백그라운드로 이동하면 Claude의 작업 목록을 삭제하지 않고 백그라운드 세션으로 가져갑니다. `←`를 누른 행은 선택이 이동한 후에도 굵고 흐리지 않은 이름을 유지합니다. `claude agents --effort`는 `ultracode`를 조용히 삭제하는 대신 허용합니다. |
| v2.1.208 | 프로세스가 중지된 세션에 연결하면 프로세스가 시작되는 동안 `Session is starting` 메모만 표시하는 대신 트랜스크립트의 마지막 화면을 표시합니다. 백그라운드 서비스에 연결할 수 없거나 전송이 실패하여 전달할 수 없는 회신은 저장되었다가 프로세스가 다시 시작될 때 세션의 다음 프롬프트로 전송됩니다. 이 릴리스 이전에는 백그라운드 서비스에 연결할 수 없는 동안 손실된 회신이 폐기되었습니다. 자신의 바이너리가 업데이트로 교체된 프로세스는 Claude Code를 다시 시작할 때까지 실패하는 대신 설치된 `claude` 런처 또는 디스크의 최신 버전에서 감독자를 시작할 수 있습니다. 더 이전 버전을 실행하는 감독자는 더 최신 버전으로 시작된 유휴 세션을 자신의 더 이전 바이너리로 다시 시작하지 않습니다. 세션을 삭제하면 세션이 워크트리를 다른 브랜치로 이동한 후에도 워크트리가 제거되며, 워크트리에 어디에도 푸시되지 않은 커밋이 있거나 다른 세션이 이를 사용 중일 때 워크트리를 세션 행과 함께 유지하여 커밋을 삭제하거나 워크트리를 고아로 남기지 않습니다. `/install-github-app` 및 `/mcp` 설정 목록과 그 인증 작업은 백그라운드 세션에서 대안을 명시하는 메시지와 함께 거부됩니다. v2.1.208에서만 `/model` 선택기가 같은 방식으로 거부되었으며 입력된 `/model <name>`은 기본 모델도 저장하는 대신 해당 세션만 전환했습니다. |
| v2.1.207 | 엿보기 패널은 행이 잘라내는 문장(예: 사용자의 입력을 기다리는 세션의 정확한 질문)과 함께 열리며, 차단된 세션이 얼마나 오래 기다렸는지를 상태 문장과 질문에 같은 타임스탬프를 접두사로 붙이는 대신 단일 `waiting 3m` 줄로 표시합니다. 디스패치 입력에 같은 텍스트를 다시 붙여넣으면 두 번째 자리 표시자를 추가하는 대신 축소된 `[Pasted text #N]` 자리 표시자를 확장합니다. 계획을 수락하여 이름이 지정된 백그라운드 세션은 해당 이름을 행에 표시합니다. 워크트리로 이동한 백그라운드 세션은 프로세스가 에이전트 뷰에서 다시 시작될 때 대화를 유지합니다. |
| v2.1.206 | 행 요약은 64개 열에서 잘리는 대신 행의 남은 너비를 채우고 터미널의 오른쪽 가장자리에서만 잘립니다. 감독자가 새로운 Claude Code 버전으로 다시 시작한 후 남은 유휴 백그라운드 세션을 분당 몇 개씩이 아니라 백그라운드에서 해당 버전으로 다시 시작합니다. `Ctrl+X` 또는 `claude rm`으로 세션을 삭제하면 감독자의 세션 목록에서도 지워지므로 감독자가 다시 시작한 후 행이 더 이상 다시 나타나지 않습니다. 디스패치 셸에서 내보낸 `CLAUDE_CODE_EXTRA_BODY` 요청 본문 재정의는 무시되는 대신 백그라운드 세션에 도달합니다. |
| v2.1.205 | 일반 `claude` 세션에서 프롬프트 바닥글의 `←` 힌트는 사용자를 기다리는 백그라운드 에이전트 수를 표시합니다(예: `← 2 agents`). 행 요약은 원시 도구 호출이나 `done/total` 개수 대신 세션 자체의 한 줄 보고를 64개 열에서 잘라 표시합니다. 디렉터리로 그룹화된 행은 색상이 지정된 상태 단어로 시작합니다. 엿보기 패널은 전체 상태 문장과 함께 열리며, 사용자의 입력을 기다리는 세션의 경우 회신 입력 위에 정확한 질문이 표시됩니다. 풀 리퀘스트를 생성하거나 체크아웃하는 세션뿐만 아니라 `gh`로 풀 리퀘스트를 편집하거나, 댓글을 달거나, 닫거나, 준비 완료로 표시하는 세션도 해당 풀 리퀘스트에 연결되며, 푸시는 로컬 브랜치 이름이 일치하지 않을 때도 풀 리퀘스트를 연결하고, 생성 명령의 출력이 인라인 제한을 초과한 풀 리퀘스트도 연결됩니다. 읽을 수 있는 텍스트가 없는 턴은 세션을 `Working`으로 되돌리는 대신 세션의 이전 상태를 유지합니다. `claude attach`는 재시작 중인 세션에 대해 실패하는 대신 이유를 명시하는 상태줄과 함께 최대 약 60초까지 기다립니다. |
| v2.1.203 | 디스패치 셸에서 내보낸 게이트웨이 `ANTHROPIC_BASE_URL`은 감독자가 해당 게이트웨이 환경을 공유할 때 그 셸에서 같은 디렉터리로 디스패치된 세션에 도달하며, 함께 내보낸 API 키만 유지되고 URL은 삭제되던 문제가 해결되었습니다. 디스패치 셸의 `PATH`는 각 세션의 워커에 적용됩니다. 서브에이전트가 실행 중일 때 `←`를 누르면 10초 후에 다시 시작하는 대신 이들이 완료될 때까지 기다립니다. 빈 목록은 항상 각 섹션 헤더를 설명과 함께 표시합니다. 디스패치 입력에서 `@`를 입력하면 디렉터리 트리 내에 있는 시작 저장소의 등록된 git worktree도 나열합니다. `effortLevel` 설정에서 상속된 노력 수준은 디스패치 시 고정되는 대신 해당 설정에 대한 이후 편집을 따릅니다. 대화가 이미 다른 실행 중인 세션에서 열려 있는 중지된 세션을 열면 행이 실패하는 대신 메시지와 함께 거부됩니다. 에이전트 뷰에서 사용할 수 없는 명령은 입력한 텍스트를 입력란에 남깁니다. git 저장소 외부에서 실패하는 `WorktreeCreate` 훅은 더 이상 세션이 파일을 편집하는 것을 차단하지 않습니다. |
| v2.1.202 | 백그라운드 세션에서 `/rename` 또는 `Ctrl+R`로 설정한 이름은 감독자가 프로세스를 중지하고 다시 시작할 때 세션이 디스패치된 이름으로 되돌아가는 대신 유지됩니다. |
| v2.1.200 | 더 이전 Claude Code 버전이 `roster.json`의 세션 목록을 다시 작성할 때 최신 버전이 작성한 필드를 보존하여 기존 `state.json` 보장과 일치하므로 최신 버전으로 시작한 세션은 감독자가 다시 시작한 후에도 입력을 계속 수락합니다. 응답을 중지한 세션을 열면 감독자가 프로세스를 다시 시작하고 세션은 중단된 응답을 중단된 위치에서 계속합니다. 에이전트 뷰는 `agents` 뒤에 배치된 `--plugin-dir` 플래그를 디스패치된 세션뿐만 아니라 디스패치 입력의 자체 서브에이전트 및 스킬 자동 완성에도 적용합니다. |
| v2.1.199 | 메모리가 부족한 호스트에서 시작을 완료하기 전에 프로세스가 종료되는 백그라운드 세션은 단순히 종료 이유만 표시하는 대신 행 상태에 `possibly low memory — free some up and retry`를 표시합니다. `←` 또는 `/background`로 세션을 백그라운드로 이동하면 `/color`가 새 행으로 이어집니다. |
| v2.1.198 | 에이전트 뷰는 백그라운드 세션이 입력이 필요하거나, 완료되거나, 실패할 때 `preferredNotifChannel`을 통해 알림을 보내고 `agent_needs_input` 또는 `agent_completed` 유형으로 `Notification` 훅을 실행합니다. `claude attach <id>` 내의 `←` 및 `/exit`는 셸로 종료하는 대신 에이전트 뷰로 돌아갑니다. `Ctrl+Z`는 셸로 돌아갑니다. 작업을 워크트리에 격리한 백그라운드 세션은 완료될 때 먼저 묻는 대신 커밋하고, `main`이나 `master`가 아닌 자신의 격리된 브랜치를 푸시하며, 초안 풀 리퀘스트를 엽니다. `/login`은 에이전트 뷰에서 실행되고 로그인 대화 상자를 엽니다. `Background work is running` 종료 대화 상자는 `Move to background and exit`를 제공합니다. 종료 핸드오프는 백그라운드 서브에이전트도 포함하며, 이들은 실패로 보고되는 대신 다음 깨어날 때 트랜스크립트에서 재개됩니다. `claude --bg`는 `-p` 또는 `--print`와 결합되면 오류로 거부됩니다. 백그라운드 세션 호스트는 `connect: no route to host`로 실패하는 대신 첫 LAN 액세스 시 macOS 로컬 네트워크 권한을 요청합니다. |
| v2.1.196 | 단일 `←` 누름이 포그라운드 세션을 백그라운드로 이동합니다. 이전 버전은 바닥글 힌트와 확인이 있는 두 번의 누름이 필요했습니다. `claude agents`에 전달된 `--dangerously-skip-permissions`는 조용히 삭제되는 대신 우회 면책 조항을 표시합니다. 이름을 지정하지 않은 대화형 세션은 세션 목록 및 `claude agents --json`에서 `my-app-3f`와 같은 기본 이름을 가집니다. 백그라운드 셸 명령은 Windows를 포함하여 세션의 프로세스가 중지되거나, 다시 시작되거나, 업데이트되어도 유지됩니다. `CLAUDE_CODE_DISABLE_BG_EXIT_HANDOFF=1`을 설정하면 핸드오프를 끕니다. 다시 시작 시 비어 있는 것으로 잘못 읽은 트랜스크립트는 삭제되는 대신 `.orphaned-` 접미사로 이름이 바뀝니다. |
| v2.1.195 | Windows에서도 세션을 백그라운드로 이동할 때 진행 중인 백그라운드 작업이 이어집니다. `Completed` 그룹은 남은 수직 공간을 채우고 짧은 터미널에서 헤더가 압축됩니다. 이전 Claude Code 버전은 더 이상 최신 세션의 `state.json` 필드를 삭제하거나 해당 세션을 `claude agents`에서 숨기지 않습니다. 중지된 세션에 연결하면 최대 5초 동안 빈 화면을 표시하는 대신 즉시 전환됩니다. 연결을 수락할 수 없는 감독자는 자체적으로 종료되고 잠금을 해제합니다. |
| v2.1.191 | `claude --bg`에 서브에이전트와 일치하지 않는 `--agent` 이름을 지정하면 시작이 실패합니다: 세션은 기본 에이전트로 실행되는 대신 `--agent '<name>' not found` 오류로 즉시 종료됩니다. |
| v2.1.174 | 백그라운드 세션은 더 이상 감독자의 시작 셸에서 `ANTHROPIC_BASE_URL`과 같은 게이트웨이 엔드포인트 변수를 상속하지 않습니다. 감독자는 사전 준비된 워커에 새로운 자격 증명 스냅샷을 제공하여 잘못된 `Could not resolve authentication method` 오류를 수정합니다. |
| v2.1.172 | 디스패치 입력의 `/model`이 세션 범위 디스패치 모델 재정의를 설정합니다. |
| v2.1.161 | 행 요약은 병렬 작업 항목에 대해 `done/total` 개수를 표시합니다. 엿보기 패널은 가장 오래 실행 중인 병렬 작업 항목의 이름을 표시합니다. |
| v2.1.157 | `claude agents`는 `--agent`를 허용합니다. 디스패치된 세션은 `agent` 설정을 준수합니다. |
| v2.1.145 | 음성 받아쓰기는 엿보기 패널 회신 입력 및 디스패치 입력에서 지원됩니다. |
| v2.1.143 | `worktree.bgIsolation` 설정이 추가되었습니다. `claude agents`는 `--allow-dangerously-skip-permissions`를 허용합니다. |
| v2.1.142 | `claude agents`는 `--permission-mode`, `--model`, `--effort`, `--dangerously-skip-permissions`, `--settings`, `--add-dir`, `--plugin-dir`, `--mcp-config` 및 `--strict-mcp-config`를 허용합니다. |
| v2.1.141 | `claude agents`는 목록 범위를 한 프로젝트로 지정하는 `--cwd`를 허용합니다. |
| v2.1.139 | 에이전트 뷰가 리서치 프리뷰로 도입되었습니다. |
