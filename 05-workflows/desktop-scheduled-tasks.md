> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code Desktop에서 반복 작업 예약하기

> Claude Code Desktop에서 예약된 작업을 설정하여 일일 코드 리뷰, 종속성 감사 또는 아침 브리핑을 위해 Claude를 자동으로 반복 실행합니다.

예약된 작업은 선택한 시간과 빈도에 따라 새 세션을 자동으로 시작합니다. 일일 코드 리뷰, 종속성 업데이트 확인 또는 캘린더와 받은편지함에서 정보를 가져오는 아침 브리핑과 같은 반복 작업에 사용합니다.

Desktop 앱의 **Scheduled tasks** 페이지에는 로컬 예약 작업과 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)(이전 명칭: 루틴)이 모두 표시됩니다.

* **로컬 작업**: 사용자의 머신에서 실행되며 파일과 도구에 직접 접근할 수 있지만, 앱이 열려 있고 컴퓨터가 깨어 있을 때만 실행됩니다
* **클라우드 작업**: 컴퓨터가 꺼져 있어도 실행되며, API 호출이나 GitHub 이벤트에 따라 시작될 수도 있습니다

이 페이지는 로컬 예약 작업을 다룹니다. 클라우드 예약 작업과 해당 트리거 옵션에 대해서는 [예약 작업으로 작업 자동화하기](https://code.claude.com/docs/ko/routines.md)를 참조하세요.

> [!NOTE]
>
> 앱에서 이 기능이 [이전 명칭](https://code.claude.com/docs/ko/routines.md#where-the-name-routines-still-appears)으로 표시되는 경우, 이 페이지에서 **Scheduled**라고 안내하는 곳에서는 **Routines**를, **New task**라고 안내하는 곳에서는 **New routine**을 클릭하세요.

## 예약 옵션 비교

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

> [!NOTE]
>
> 기본적으로 로컬 예약 작업은 커밋되지 않은 변경 사항을 포함하여 작업 디렉터리의 현재 상태에 대해 실행됩니다. 대신 각 실행이 자체 [격리된 Git worktree](https://code.claude.com/docs/ko/desktop.md#run-a-session-in-its-own-worktree)를 갖도록 하려면 작업을 만든 후 작업의 [**Edit** 양식](#manage-scheduled-tasks)에서 **Worktree**를 선택합니다. 이 체크박스는 작업의 폴더가 Git 저장소인 경우에 사용할 수 있습니다.

## 예약된 작업 만들기

로컬 예약 작업을 사용하려면 Claude Desktop 1.1.5368 이상이 필요합니다.

**1. Scheduled tasks 페이지 열기**

[**Code** 탭](https://code.claude.com/docs/ko/desktop.md)에서 사이드바 또는 사이드바의 **More** 메뉴에 있는 **Scheduled**를 클릭합니다. 사이드바에 **Scheduled** 대신 **Routines**가 표시되면 **Routines**를 클릭한 다음 **New routine**을 클릭하고 [전체 페이지 양식](#full-page-form)으로 계속 진행합니다.

**2. 새 작업 시작하기**

**New task**를 클릭하여 **New scheduled task** 대화 상자를 엽니다. 계속하기 전에 다음 화면이 나타나는지 확인합니다:

* **Create with Claude**와 **Set up manually**가 있는 메뉴가 열리면 **Set up manually**를 선택하여 대화 상자를 엽니다.
* 대화 상자 맨 위에 **Only on this computer**가 있으면 아무것도 입력하기 전에 [맨 위에 Only on this computer가 있는 대화 상자](#dialog-with-only-on-this-computer-at-the-top)로 이동합니다.
* **Local**과 **Cloud**가 있는 메뉴가 열리거나 대화 상자 대신 전체 페이지가 열리면 [전체 페이지 양식](#full-page-form)으로 이동합니다.

**3. 작업 이름 지정하기**

**Name** 필드에 이름을 입력합니다. Desktop은 이름을 소문자 kebab-case로 변환하여 디스크에서 작업의 폴더 이름으로 사용하므로, 이름은 모든 작업 전체에서 고유해야 합니다.

**4. 지침 작성하기**

이름 아래의 상자에 작업이 실행될 때 Claude가 수행해야 할 작업을 입력합니다.

**5. Only on this computer 켜기**

지금은 **Trigger** 카드를 건너뛰고 그 아래의 **Advanced settings**를 펼칩니다. **General** 탭에서 **Only on this computer**를 켭니다. 이 옵션을 켜면 작업이 사용자의 컴퓨터에서 로컬 폴더를 대상으로 실행됩니다.

스위치를 사용할 수 없는 경우 저장소나 GitHub 이벤트 또는 API 트리거를 지웁니다. 이러한 항목이 있으면 작업이 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)이 되기 때문입니다.

**6. 로컬 폴더 선택하기**

**Local folder** 행에서 폴더를 선택합니다. 폴더를 선택할 때까지 **Create**는 사용할 수 없습니다.

**7. 일정 설정하기**

다시 **Trigger** 카드로 돌아가 [일정 프리셋](#schedule-options)을 선택합니다.

**8. 권한 모드와 모델 선택하기**

지침 상자의 도구 모음에서 [권한 모드](#permissions-for-scheduled-tasks)와 모델을 선택합니다. 변경하지 않으면 실행 시 Claude Code 설정과 기본 모델이 사용됩니다.

**9. 작업 만들기**

**Create**를 클릭합니다. 아직 폴더를 신뢰하지 않은 경우 Desktop이 이 시점에 폴더를 신뢰하도록 요청합니다. 작업의 세부 정보 페이지가 열립니다.

세부 정보 페이지에서 연필 아이콘을 클릭하면 [**Edit** 양식](#manage-scheduled-tasks)이 열립니다. 여기에서 Desktop이 지침을 바탕으로 채운 **Description**을 변경하거나, **Worktree**를 선택하거나, 일정을 **Manual** 또는 **Custom**으로 전환할 수 있습니다.

모든 세션에서 원하는 작업을 설명하여 작업을 만들 수도 있습니다. 예를 들어, "매일 아침 9시에 실행되는 일일 코드 리뷰 설정"은 반복 작업을 만듭니다. "내일 오후 3시에 배포 확인을 상기시켜 줘"와 같은 요청은 실행 후 스스로 비활성화되는 일회성 작업을 만듭니다.

### 맨 위에 Only on this computer가 있는 대화 상자

**New scheduled task** 대화 상자가 열릴 때 맨 위에 **Only on this computer**가 있으면 아무것도 입력하기 전에 이 옵션을 켭니다. 옵션을 켜면 로컬 작업용 별도의 빈 양식이 기존 양식을 대체합니다.

그런 다음 로컬 양식의 필드를 채웁니다:

* **Name**: [예약 작업 만들기 단계](#create-a-scheduled-task)에서와 같이 이름을 입력합니다.
* **Description**: 설명을 입력합니다. 입력할 때까지 **Create**는 사용할 수 없습니다.
* **지침 상자**: 작업이 실행될 때 Claude가 수행해야 할 작업을 입력합니다. 상자의 메뉴에서 권한 모드와 모델을 선택합니다.
* **Working folder**: 작업이 실행될 폴더를 선택합니다. 폴더를 선택할 때까지 **Create**는 사용할 수 없습니다.
* **Trigger**: 일정을 선택합니다. 프리셋은 [일정 옵션](#schedule-options)을 참조하세요.

**Create**를 클릭합니다. 작업의 세부 정보 페이지가 열립니다.

### 전체 페이지 양식

**Local**과 **Cloud**가 있는 메뉴가 열리면 **Local**을 선택합니다. **New local routine** 또는 **New local scheduled task**라는 제목의 페이지가 열립니다. 해당 필드를 채웁니다:

* **Name**: 모든 작업 전체에서 고유한 이름을 입력합니다.
* **Description**: 설명을 입력합니다.
* **Instructions**: 작업이 실행될 때 Claude가 수행해야 할 작업을 입력합니다. 같은 상자에서 권한 모드, 모델, 작업이 실행될 폴더를 선택합니다.
* **Schedule**: [일정 옵션](#schedule-options) 중 하나를 선택합니다.

**Create**를 사용할 수 없는 경우 마우스 포인터를 올려 양식에 아직 필요한 항목을 확인합니다. **Create**를 클릭하면 작업의 세부 정보 페이지가 열립니다.

## 예약 옵션

**Advanced settings**에서 **Only on this computer**를 켜면 **Trigger** 카드에서 Hourly, Daily, Weekdays, Weekly를 선택할 수 있습니다. 이러한 작업에 **Manual** 또는 **Custom**을 사용하려면 작업을 만든 후 해당 작업의 [**Edit** 양식](#manage-scheduled-tasks)을 엽니다. 이 양식, [상단에 **Only on this computer**가 있는 대화 상자](#dialog-with-only-on-this-computer-at-the-top), [전체 페이지 양식](#full-page-form)에서는 다음 여섯 가지 옵션을 제공합니다.

* **Hourly**: 매시간 실행됩니다.
* **Daily**: 매일 선택한 현지 시간에 실행됩니다.
* **Weekdays**: Daily와 동일하지만 토요일과 일요일을 건너뜁니다.
* **Weekly**: 시간 선택기와 요일 선택기를 표시합니다.
* **Manual**: 일정이 없으며, **Run now**를 클릭할 때만 실행됩니다. 요청 시 트리거하는 프롬프트를 저장하는 데 유용합니다.
* **Custom**: 직접 입력한 cron 표현식에 따라 실행되며, 이 표현식은 현지 시간 기준으로 평가됩니다. 예를 들어 `0 9 * * *`는 매일 오전 9시에 실행됩니다. 요일과 월의 이름은 허용되지 않으므로 숫자로 작성합니다. 일요일은 `7`이 아니라 `0`입니다. 양식은 한 시간에 한 번보다 자주 실행되는 표현식을 거부합니다.

Desktop의 모든 세션에서 Claude에게 일정을 설정하도록 요청할 수도 있습니다. Claude는 한 시간에 한 번이라는 제한을 받지 않으며, 미래의 특정 시간에 한 번만 실행되도록 설정할 수도 있습니다. 예를 들어 "30분마다 테스트 스위트를 실행해 줘" 또는 "다음 주 월요일 오전 9시에 금요일 이후 병합된 풀 리퀘스트를 요약해 줘"라고 요청합니다.

## 예약된 작업이 실행되는 방식

로컬 예약 작업은 사용자의 머신에서 실행됩니다. Desktop은 앱이 열려 있는 동안 매분 일정을 확인하고, 열려 있는 수동 세션과 관계없이 작업을 실행할 시간이 되면 새 세션을 시작합니다. 각 작업은 API 트래픽을 분산하기 위해 예약된 시간 이후 몇 분의 작은 지연을 받습니다. 지연은 결정론적입니다. 동일한 작업은 항상 동일한 오프셋에서 시작됩니다.

작업은 desktop 앱이 실행 중이고 컴퓨터가 깨어 있을 때만 실행됩니다. 예약된 시간에 컴퓨터가 절전 모드 상태이면 해당 실행은 건너뜁니다. 유휴 절전을 방지하려면 **Settings > Desktop app** 또는 **Settings > This computer > System**에서 **Keep computer awake**를 켭니다. 노트북 뚜껑을 닫으면 여전히 절전 모드로 전환됩니다.

> [!NOTE]
>
> 컴퓨터가 꺼져 있어도 실행되어야 하거나 API 호출이나 GitHub 이벤트로 트리거되어야 하는 작업의 경우, 대신 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)을 만듭니다.

### 실행의 세션 찾기

실행이 시작한 세션을 열려면 작업의 [세부 정보 페이지](#manage-scheduled-tasks)로 이동하여 **History** 목록에서 해당 실행의 행을 클릭합니다.

사이드바의 세션 목록에는 작업당 하나의 행이 있는 **Scheduled** 그룹도 표시될 수 있습니다. 작업의 최신 실행 세션을 열려면 해당 그룹에서 작업의 행을 클릭합니다. 그룹을 표시하려면 [사용 중인 레이아웃을 확인](https://code.claude.com/docs/ko/desktop.md#check-which-layout-you-have)합니다.

* **현재 레이아웃**: [**Group and sort** 메뉴](https://code.claude.com/docs/ko/desktop.md#organize-and-find-sessions)를 열고 **Show**를 선택한 다음 **Scheduled**를 선택합니다. 그룹은 접힌 상태로 시작하므로 제목을 클릭하여 펼칩니다. **Show**에는 작업 중 하나 이상이 **Active**일 때 **Scheduled**가 나열되며, 이는 작업의 세부 정보 페이지에 표시되는 **Status**입니다. 나열되지 않으면 그룹 표시 여부와 관계없이 작동하는 **History** 목록을 사용합니다.
* **이전 레이아웃**: 별도로 켤 필요 없이 그룹이 세션 목록에 있습니다

어떤 방법으로 접근했든 실행의 세션에서 Claude가 수행한 작업을 확인하고, 변경 사항을 검토하고, 권한 프롬프트에 응답할 수 있습니다. Claude는 사용자가 직접 시작한 세션과 동일하게 파일을 편집하고, 명령을 실행하고, 커밋을 만들고, 풀 리퀘스트를 열 수 있습니다.

## 놓친 실행

앱이 시작되거나 컴퓨터가 깨어나면 Desktop은 지난 7일 동안 각 작업이 놓친 실행이 있는지 확인합니다. 있으면 Desktop은 가장 최근에 놓친 시간에 대해 정확히 하나의 catch-up 실행을 시작하고 더 오래된 것은 버립니다. 6일을 놓친 일일 작업은 깨어날 때 한 번 실행됩니다. Desktop은 catch-up 실행이 시작될 때 알림을 표시합니다.

프롬프트를 작성할 때 이를 염두에 두세요. 오전 9시에 예약된 작업은 컴퓨터가 하루 종일 절전 모드였다면 오후 11시에 실행될 수 있습니다. 타이밍이 중요한 경우 프롬프트 자체에 보호 장치를 추가합니다. 예를 들어, "오늘의 커밋만 검토합니다. 오후 5시 이후이면 검토를 건너뛰고 놓친 내용의 요약만 게시합니다."

## 예약된 작업에 대한 권한

각 작업에는 자신의 권한 모드가 있으며, 이는 작업을 만들거나 편집할 때 설정합니다. `~/.claude/settings.json`의 Allow 규칙도 예약된 작업 세션에 적용됩니다. 작업이 [Manual 모드](https://code.claude.com/docs/ko/desktop.md#choose-a-permission-mode)에서 실행되고 권한이 없는 도구를 실행해야 하는 경우, 승인할 때까지 실행이 정지됩니다. 승인하려면 [해당 실행의 세션을 찾아](#find-a-runs-session) 그곳에서 권한 프롬프트에 응답합니다.

정지를 방지하려면 작업을 만든 후 **Run now**를 클릭하고 권한 프롬프트를 확인한 다음 각 프롬프트에 대해 "always allow"를 선택합니다. 해당 작업의 향후 실행은 프롬프트 없이 동일한 도구를 자동으로 승인합니다. 작업의 세부 정보 페이지에서 이러한 승인을 검토하고 취소할 수 있습니다.

[`requiresUserInteraction`](https://code.claude.com/docs/ko/mcp#require-approval-for-a-specific-tool)으로 표시된 MCP 도구는 매번 호출할 때마다 프롬프트를 표시하며 always-allow 옵션을 제공하지 않습니다. 이러한 도구를 호출하는 실행은 매번 정지됩니다.

## 예약된 작업 관리

**Code** 탭의 사이드바에서 **Scheduled**를 클릭한 다음, 목록에서 작업을 클릭하여 세부 정보 페이지를 엽니다. 여기에서 다음을 수행할 수 있습니다:

* **Run now**: 다음 예약된 시간을 기다리지 않고 작업을 즉시 시작합니다.
* **Status**: Active와 Paused 사이를 전환하여 작업을 삭제하지 않고 예약된 실행을 일시 중지하거나 재개합니다.
* **Edit**: instructions, schedule, folder 또는 기타 설정을 변경합니다.
* **Review history**: 건너뛴 실행을 포함하여 모든 과거 실행을 확인합니다. 건너뛴 항목 위에 마우스를 올려 이유를 확인합니다: 컴퓨터가 절전 모드였거나, 이전 실행이 여전히 진행 중이거나, 다른 예약된 작업이 이미 실행 중입니다. **Show more**를 클릭하여 더 오래된 항목을 로드합니다.
* **Review allowed permissions**: **Always allowed** 패널에서 이 작업에 대해 저장된 도구 승인을 확인하고 취소합니다.
* **Delete**: 작업을 제거합니다. 작업이 생성한 세션은 삭제되지 않고 [보관](https://code.claude.com/docs/ko/desktop.md#organize-and-find-sessions)됩니다. 작업의 `SKILL.md` 파일이 들어 있는 폴더는 디스크의 `~/.claude/scheduled-tasks/<task-name>/`에, 또는 [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars) 변수를 설정한 경우 그 아래의 `scheduled-tasks/<task-name>/`에 그대로 남습니다. 해당 폴더를 제거하려면 직접 삭제해야 합니다.

Desktop의 모든 세션에서 Claude에게 요청하여 작업을 나열, 만들, 편집 및 일시 중지할 수도 있습니다. 예를 들어, "내 dependency-audit 작업을 일시 중지해 줘" 또는 "내 예약된 작업을 보여 줘"입니다. 작업을 삭제하려면 세부 정보 페이지의 **Delete** 버튼을 사용합니다.

예약된 작업은 실행 중인 세션 내에서 `update_scheduled_task` MCP 도구를 사용하여 자신의 일정이나 프롬프트를 수정할 수도 있습니다. 이를 통해 작업은 발견한 내용에 따라 자신을 재예약할 수 있습니다. 예를 들어, 릴리스 브랜치가 생성되었음을 감지할 때 코드 리뷰를 더 일찍 실행하도록 재예약합니다.

디스크에서 작업의 프롬프트를 편집하려면 `~/.claude/scheduled-tasks/<task-name>/SKILL.md`를 엽니다 (설정된 경우 [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars) 아래). 파일은 `name` 및 `description`에 대해 YAML frontmatter를 사용하며, 프롬프트는 본문입니다. 변경 사항은 다음 실행에 적용됩니다. Schedule, folder, model 및 enabled state는 이 파일에 없습니다: Edit 양식을 통해 변경하거나 Claude에게 요청합니다.

## 관련 리소스

* [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md): 클라우드에서 일정에 따라, API 호출을 통해 또는 GitHub 이벤트에 대응하여 작업을 실행합니다. 컴퓨터가 꺼져 있어도 실행됩니다.
* [Run prompts on a schedule](https://code.claude.com/docs/ko/scheduled-tasks.md): CLI에서 `/loop`를 사용한 세션 범위 예약
* [Claude Code GitHub Actions](https://code.claude.com/docs/ko/github-actions.md): 머신에서가 아닌 CI에서 일정에 따라 Claude를 실행합니다.
* [Use Claude Code Desktop](https://code.claude.com/docs/ko/desktop.md): 전체 Desktop 앱 가이드
