> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 예약 작업으로 작업 자동화하기

> Claude Code를 자동 조종 모드로 전환합니다. 일정에 따라, API 호출로, 또는 GitHub 이벤트에 반응하여 클라우드에서 실행되는 예약 작업(이전 명칭: 루틴)을 만듭니다.

> [!NOTE]
>
> 예약 작업은 리서치 프리뷰 상태입니다. 동작, 제한 사항 및 API 사양이 변경될 수 있습니다.

클라우드 예약 작업(이전 명칭: 루틴)은 저장된 Claude Code 구성입니다. 프롬프트, 하나 이상의 저장소, 그리고 [커넥터](https://code.claude.com/docs/ko/mcp.md) 세트를 한 번에 패키징하여 자동으로 실행합니다. 예약 작업은 Anthropic 관리 클라우드 인프라에서 실행되거나, 라우팅된 경우 조직의 [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)에서 실행되므로 노트북을 닫아도 계속 작동합니다.

각 예약 작업에는 하나 이상의 트리거를 연결할 수 있습니다.

* **일정**: 시간별, 야간 또는 주간과 같은 반복 주기로 실행되거나 특정 미래 시간에 한 번 실행
* **API**: 베어러 토큰과 함께 작업별 엔드포인트로 HTTP POST를 보내 필요할 때 트리거
* **GitHub**: 풀 리퀘스트나 릴리스와 같은 저장소 이벤트에 반응하여 자동으로 실행

하나의 예약 작업에 여러 트리거를 결합할 수 있습니다. 예를 들어 PR 리뷰 작업은 매일 밤 실행되고, 배포 스크립트에서 트리거되며, 모든 새 PR에도 반응할 수 있습니다.

예약 작업에 반드시 일정이 필요한 것은 아닙니다.

* API 트리거만 있는 작업은 해당 엔드포인트를 호출할 때 실행됩니다.
* GitHub 트리거만 있는 작업은 일치하는 저장소 이벤트가 발생할 때 실행됩니다.

예약 작업은 Pro, Max, Ultra, Team 및 Enterprise 플랜에서 사용할 수 있습니다. [claude.ai/code/routines](https://claude.ai/code/routines)에서 또는 CLI에서 `/schedule`로 만들고 관리합니다. 이전 명칭인 루틴은 [여전히 나타납니다](#where-the-name-routines-still-appears).

> [!NOTE]
>
> 다른 두 기능은 클라우드 대신 사용자의 머신에서 작업을 예약합니다. [데스크톱 예약 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md)과 [`/loop`](https://code.claude.com/docs/ko/scheduled-tasks)입니다. 세 가지 중에서 선택하려면 [예약 옵션 비교](https://code.claude.com/docs/ko/scheduled-tasks.md#compare-scheduling-options)를 참조하십시오.

Team 및 Enterprise Owner는 [**Organization settings > Capabilities > Remote sessions**](https://claude.ai/admin-settings/capabilities)의 **Scheduled tasks (Was Routines)** 토글로 모든 구성원에 대해 예약 작업을 끌 수 있습니다. 토글이 꺼지면 기존 예약 작업의 실행이 중지되고 구성원은 새 예약 작업을 만들 수 없습니다.

Enterprise 조직에서 [사용자 지정 역할](https://support.claude.com/en/articles/13930452)로 액세스를 관리하는 경우, 예약 작업 권한이 포함된 역할도 필요합니다. Owner는 [**Organization settings > Roles**](https://claude.ai/admin-settings/roles)에서 역할의 **Remote sessions** 섹션에 이 권한을 추가할 수 있습니다.

## 사용 사례 예시

각 예시는 트리거 유형을 예약 작업에 적합한 작업 종류와 짝지어 보여줍니다. 무인으로 실행되고, 반복 가능하며, 명확한 결과와 연결된 작업입니다.

* **백로그 유지 관리**: 이슈 추적기를 커넥터로 추가한 저장소에서 일정 트리거가 매주 평일 밤에 실행됩니다. 예약 작업은 마지막 실행 이후 열린 이슈를 읽고, 레이블을 적용하고, 참조된 코드 영역을 기반으로 소유자를 할당합니다. 그런 다음 Slack에 요약을 게시하여 팀이 정리된 큐로 하루를 시작할 수 있도록 합니다.
* **경고 분류**: 오류 임계값을 넘으면 모니터링 도구가 예약 작업의 API 엔드포인트를 호출하고 경고 본문을 `text`로 전달합니다. 작업의 프롬프트는 Claude에게 fire 페이로드에 담긴 경고를 조사하도록 지시하므로, Claude는 스택 추적을 가져와 저장소의 최근 커밋과 연관 짓습니다. 그런 다음 제안된 수정 사항과 경고로 돌아가는 링크가 담긴 초안 풀 리퀘스트를 엽니다. 온콜 담당자는 빈 터미널에서 시작하는 대신 PR을 검토합니다.
* **맞춤형 코드 리뷰**: GitHub 트리거가 `pull_request.opened`에서 실행됩니다. 예약 작업은 팀 고유의 리뷰 체크리스트를 적용하고 보안, 성능 및 스타일 문제에 대해 인라인 댓글을 남깁니다. 또한 요약 댓글을 추가하여 사람 리뷰어가 기계적인 검사 대신 설계에 집중할 수 있도록 합니다.
* **배포 검증**: CD 파이프라인이 각 프로덕션 배포 후 예약 작업의 API 엔드포인트를 호출합니다. 작업은 새 빌드에 대해 스모크 검사를 실행하고, 오류 로그에서 회귀를 스캔하고, 배포 윈도우가 닫히기 전에 릴리스 채널에 진행 또는 진행 불가를 게시합니다.
* **문서 드리프트**: 일정 트리거가 매주 실행됩니다. 예약 작업은 마지막 실행 이후 병합된 PR을 스캔하고, 변경된 API를 참조하는 문서에 플래그를 지정하고, 편집자가 검토할 수 있도록 문서 저장소에 업데이트 PR을 엽니다.
* **라이브러리 포팅**: GitHub 트리거가 한 SDK 저장소의 병합된 PR로 필터링된 `pull_request.closed`에서 실행됩니다. 예약 작업은 변경 사항을 다른 언어로 된 병렬 SDK로 포팅하고 대응하는 PR을 열어, 사람이 각 변경 사항을 다시 구현하지 않아도 두 라이브러리를 동기화된 상태로 유지합니다.

## 예약 작업 만들기

[claude.ai/code/routines](https://claude.ai/code/routines)의 웹에서, 데스크톱 앱에서, 또는 CLI에서 예약 작업을 만들 수 있습니다. 세 가지 사용 환경 모두 동일한 클라우드 계정에 저장되므로, 한 곳에서 만든 예약 작업이 다른 곳에도 즉시 나타납니다. 데스크톱 앱의 **Code** 탭에서 사이드바 또는 사이드바의 **More** 메뉴에 있는 **Scheduled**를 클릭한 다음 **New task**를 클릭하고 [웹에서 만들기](#create-from-the-web)의 단계를 이어서 진행합니다.

예약 작업은 전체 Claude Code 클라우드 세션으로 자율적으로 실행됩니다. 세션은 셸 명령을 실행하고, [스킬](https://code.claude.com/docs/ko/skills.md)을 사용하며, 포함된 모든 커넥터를 호출합니다. [프로젝트](https://code.claude.com/docs/ko/claude-projects.md#what-threads-pick-up-from-your-repositories)의 스레드 외부에서는 이러한 스킬에 복제된 저장소에 커밋된 스킬도 포함됩니다. 작업을 만들 때 권한 모드는 선택하지 않습니다. 실행이 멈추고 사용자를 기다리는 경우에 대해서는 [실행 중 권한 프롬프트](#permission-prompts-during-a-run)를 참조하십시오.

예약 작업이 도달할 수 있는 범위는 다음에 의해 결정됩니다.

* 선택한 저장소
* [환경](https://code.claude.com/docs/ko/cloud-environments.md)의 네트워크 액세스 및 변수
* 포함한 커넥터

각각의 범위를 작업에 필요한 것으로 제한하십시오.

예약 작업은 개별 claude.ai 계정에 속합니다. 팀원과 공유되지 않으며, 실행은 계정의 [사용량 및 한도](#usage-and-limits)에 포함됩니다. 예약 작업이 연결된 GitHub 신원이나 커넥터를 통해 수행하는 모든 작업은 사용자 본인으로 표시됩니다. 커밋과 풀 리퀘스트에는 사용자의 GitHub 사용자가 표시되며, Slack 메시지, Linear 티켓 또는 기타 커넥터 작업은 해당 서비스에 연결된 사용자의 계정을 사용합니다.

### 웹에서 만들기

**1. 생성 대화 상자 열기**

[claude.ai/code/routines](https://claude.ai/code/routines)로 이동하여 **New task**를 클릭해 **New scheduled task** 대화 상자를 엽니다. 계속하기 전에 다음 화면이 나타나는지 확인하십시오.

* 버튼에 **New task** 대신 **New routine**이 표시되면 **New routine**을 클릭하고 [전체 페이지 양식](#full-page-form)으로 이어서 진행합니다.
* 데스크톱 앱에서 **Local**과 **Cloud**가 있는 메뉴가 열리면 [전체 페이지 양식](#full-page-form)으로 이동합니다.
* **Create with Claude**와 **Set up manually**가 있는 메뉴가 열리면 **Set up manually**를 선택하여 대화 상자를 엽니다. **Create with Claude**를 사용하면 채팅으로 작업을 설명하고 Claude가 대신 작업을 만들도록 할 수 있습니다.
* 대화 상자 대신 전체 페이지가 열리면 [전체 페이지 양식](#full-page-form)으로 이동합니다.

대화 상자가 열릴 때 **Repositories**와 **Environment**가 이미 표시되어 있다면 [해당 대화 상자의 차이점](#dialog-with-repositories-and-environment-in-the-main-view)을 참조하십시오. 그렇지 않은 경우 이 대화 상자는 claude.ai 채팅용 예약 작업도 만듭니다. 대화 상자에서 Claude Code 작업이라고 부르는 작업으로 만들려면, 이어지는 단계에서 저장소를 선택하거나 GitHub 이벤트 또는 API 트리거를 추가합니다. 이러한 종류의 작업은 클라우드 세션에서 Claude Code를 실행합니다.

**2. 작업 이름 지정 및 프롬프트 작성**

예약 작업에 설명적인 이름을 지정하고 Claude가 매번 실행할 프롬프트를 작성합니다. 프롬프트가 가장 중요한 부분입니다. 작업이 자율적으로 실행되므로 프롬프트는 그 자체로 완결되어야 하며, 무엇을 해야 하는지와 성공이 어떤 모습인지를 명시적으로 밝혀야 합니다.

트리거가 발동되면 세션은 저장된 프롬프트를 할당된 작업으로 받아 수행하며, 대화 중간에 도착한 신뢰할 수 없는 콘텐츠로 취급하지 않습니다. 트리거는 프롬프트가 계정의 승인된 세션에 의해 미리 저장되었다는 사실만 증명합니다. 따라서 발동된 프롬프트는 실시간 사용자 입력이 아니며 실행 중 작업에 대한 승인이나 동의로 작용할 수 없습니다. 세션이 실행 중에 가져오는 콘텐츠는 평소와 같이 처리됩니다.

**3. 트리거 선택**

**Trigger** 행에서 작업이 시작되는 방식을 선택합니다. 여러 트리거를 결합하려면 행 끝의 \*\*+\*\*를 클릭합니다.

> [tab] Schedule
>
> 반복 실행을 위한 사전 설정 빈도를 선택합니다. 시간대 처리, 지연 시작, 사용자 정의 cron 간격 및 일회성 실행에 대해서는 [일정 트리거 추가](#add-a-schedule-trigger)를 참조하십시오.

> [tab] GitHub event
>
> 저장소, 반응할 이벤트 및 선택적 필터를 선택합니다. 지원되는 이벤트와 필터 필드의 전체 목록은 [GitHub 트리거 추가](#add-a-github-trigger)를 참조하십시오.

> [tab] API
>
> 여기서 **API**를 선택합니다. **Create**를 클릭하면 **API token** 대화 상자에 토큰이 한 번만 표시되므로 대화 상자를 닫기 전에 복사하십시오. URL을 복사하거나 새 토큰을 생성하려면 [API 트리거 추가](#add-an-api-trigger)를 참조하십시오.

**4. 저장소 선택**

**Advanced settings**를 펼칩니다. **General** 탭의 **Repository** 아래에서 Claude가 작업할 하나 이상의 GitHub 저장소를 선택합니다.

각 저장소는 실행 시작 시 복제됩니다. Claude는 변경 사항에 대해 `claude/` 접두사가 붙은 브랜치를 만듭니다.

**5. 환경 선택**

저장소를 선택하면 그 아래에 **Cloud environment**가 나타납니다. 작업에 사용할 [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md)을 선택합니다. 환경은 클라우드 세션이 액세스할 수 있는 것을 제어합니다.

* **Network access**: 각 실행 중에 사용할 수 있는 인터넷 액세스 수준을 설정합니다
* **Environment variables**: Claude가 각 실행 중에 사용할 수 있는 값을 제공합니다. 이 값은 [환경을 사용하는 모든 사람에게 표시](https://code.claude.com/docs/ko/cloud-environments.md#what-carries-over-from-your-setup)되므로, Anthropic 호스팅 환경에서는 Claude가 실행 중에 호출하는 API의 키를 대신 [네트워크 시크릿](https://code.claude.com/docs/ko/cloud-environments.md#add-network-secrets)으로 저장합니다. 해당 섹션에는 시크릿을 받지 않는 요청도 나열되어 있습니다
* **Setup script**: 작업에 필요한 의존성과 도구를 설치합니다. 결과가 [캐시](https://code.claude.com/docs/ko/cloud-environments.md#environment-caching)되므로 스크립트가 모든 세션에서 다시 실행되지는 않습니다

**Default** 환경은 **Trusted** 네트워크 액세스로 제공되며, 세션의 네트워크를 통해 패키지 레지스트리, 클라우드 제공자 API, 컨테이너 레지스트리 및 일반적인 개발 도메인으로 구성된 [기본 허용 목록](https://code.claude.com/docs/ko/cloud-environments.md#default-allowed-domains)만 허용합니다. 작업에 추가하는 커넥터는 Anthropic의 서버를 통해 해당 서비스에 도달하므로 허용 목록을 변경할 필요가 없습니다.

작업이 자체 서비스나 해당 목록 외부의 도메인에 직접 도달해야 하는 경우, 실행하기 전에 환경의 [네트워크 액세스](https://code.claude.com/docs/ko/cloud-environments.md#network-access)를 편집합니다. 별도의 환경을 사용하려면 먼저 [환경을 만듭니다](https://code.claude.com/docs/ko/cloud-environments.md#configure-your-environment).

**6. 모델 및 effort 수준 선택**

프롬프트 입력란의 모델 선택기에서 Claude가 모든 실행에서 사용할 모델을 선택합니다. Claude Code 작업의 경우 모델이 [effort 수준](https://code.claude.com/docs/ko/model-config.md#adjust-effort-level)을 제공하면 같은 선택기의 **Effort**에 현재 수준이 표시됩니다. 변경하려면 다른 수준을 선택합니다. 선택기의 **Default** 옵션은 수준을 제공하지 않습니다.

**7. 커넥터 검토**

**Advanced settings**의 **Connectors** 탭으로 전환합니다. 연결된 모든 [MCP 커넥터](https://code.claude.com/docs/ko/mcp.md)가 기본적으로 포함됩니다. 작업에 필요하지 않은 커넥터는 제거하십시오. Claude는 실행 중에 포함된 커넥터를 쓰기 작업을 포함하여 사용할 수 있습니다. 실행이 멈추고 먼저 사용자에게 확인을 요청하는 경우에 대해서는 [실행 중 권한 프롬프트](#permission-prompts-during-a-run)를 참조하십시오.

**8. 작업 만들기**

**Create**를 클릭합니다. 대화 상자가 닫히고 새 작업의 세부 정보 페이지가 열립니다. 작업은 다음에 트리거 중 하나가 일치할 때 실행됩니다. 즉시 실행을 시작하려면 세부 정보 페이지에서 **Run now**를 클릭합니다.

실행에서 수행된 작업을 확인하려면 세부 정보 페이지의 **History** 목록에서 해당 실행을 클릭합니다. 실행은 [전체 세션으로 열리며](#view-and-interact-with-runs) 실행마다 새 세션이 만들어집니다. 여기서 Claude가 수행한 작업을 확인하고, 변경 사항을 검토하고, 풀 리퀘스트를 만들 수 있습니다.

#### 기본 화면에 Repositories와 Environment가 있는 대화 상자

[웹에서 만들기 단계](#create-from-the-web)를 따르되, 각 필드를 **Advanced settings** 아래가 아닌 대화 상자의 기본 화면에서 입력합니다. 이 대화 상자는 Claude Code 작업만 만듭니다.

GitHub 이벤트 트리거는 저장소를 선택하기 전까지 사용할 수 없으므로, 트리거를 추가하기 전에 저장소를 선택하십시오.

#### 전체 페이지 양식

데스크톱 앱에서 **Local**과 **Cloud**가 있는 메뉴가 열리면 **Cloud**를 선택합니다. **New routine** 또는 **New scheduled task**라는 제목의 페이지가 열립니다. 다음 필드를 입력합니다.

* **Name**: 이름을 입력합니다.
* **Instructions**: 프롬프트를 입력합니다. 같은 입력란에서 모델, 모델이 제공하는 경우 effort 수준, 저장소 및 환경을 선택합니다. 각 항목이 제어하는 내용은 [웹에서 만들기](#create-from-the-web)의 단계를 참조하십시오.
* **Select a trigger**: **Schedule**, **GitHub event** 또는 **API**를 선택합니다. 일정의 경우 [일정 트리거 추가](#add-a-schedule-trigger)를 참조하십시오. [GitHub 이벤트](#add-a-github-trigger)의 경우 저장소를 선택합니다. [API 트리거](#add-an-api-trigger)의 경우 **Create**를 클릭한 후 열리는 **API token** 대화 상자에서 토큰을 복사하십시오. 토큰은 한 번만 표시됩니다. 여러 트리거를 결합하려면 **Add another trigger**를 클릭합니다.
* **Connectors**: 연결된 모든 커넥터가 기본적으로 포함되므로 작업에 필요하지 않은 커넥터는 제거하십시오.

**Create**를 사용할 수 없는 경우 마우스를 올려 양식에 아직 필요한 항목을 확인합니다. **Create**를 클릭하면 작업의 세부 정보 페이지가 열립니다.

### CLI에서 만들기

아무 세션에서나 `/schedule`을 실행하여 대화식으로 예약 작업을 만듭니다. 반복 작업의 경우 `/schedule daily PR review at 9am`, 일회성 작업의 경우 `/schedule clean up feature flag in one week`와 같이 설명을 직접 전달할 수도 있습니다. Claude는 웹 대화 상자가 수집하는 것과 동일한 정보를 안내한 후 작업을 계정에 저장합니다. 이 명령은 별칭 `/routines`로도 사용할 수 있습니다.

성공적으로 시작되면 대화처럼 보입니다. Claude는 저장하기 전에 일정, 저장소 및 프롬프트에 대해 후속 질문을 합니다. Claude가 대신 인증이 필요하다거나 원격 claude.ai 계정에 연결할 수 없다고 응답하면 예약 작업이 생성되지 않은 것입니다. [문제 해결](#troubleshooting)을 참조하십시오.

`/schedule`로 만든 작업에는 일정 트리거가 있습니다. 다른 트리거 유형도 추가할 수 있습니다.

* **API 트리거**: [claude.ai/code/routines](https://claude.ai/code/routines)의 웹에서 작업을 편집합니다
* **[GitHub 트리거](#add-a-github-trigger)**: 웹에서 작업을 편집하거나 CLI에서 Claude에게 요청합니다. CLI에서 추가하려면 Claude Code v2.1.225 이상이 필요합니다

API 호출이나 GitHub 이벤트로만 시작되는 작업처럼 일정 트리거가 없는 예약 작업에는 다음 실행 시간이 없습니다. Claude가 이러한 작업을 저장하거나 업데이트할 때 CLI는 다음 실행 시간을 표시하지 않습니다.

## 트리거 구성

예약 작업은 트리거 중 하나가 일치할 때 시작됩니다. 작업의 [편집 대화 상자](#edit-and-control-scheduled-tasks)에 있는 **Trigger** 행에서 언제든지 트리거를 추가하거나 제거할 수 있습니다.

작업에 트리거가 두 개 이상 있으면 해당 대화 상자에서 각 트리거에 휴지통 아이콘이 표시됩니다. 일정 또는 GitHub 이벤트 트리거를 제거하려면 휴지통 아이콘을 클릭한 다음 **Save changes**를 클릭합니다. API 트리거를 제거하려면 대신 [토큰을 삭제](#add-an-api-trigger)합니다.

### 일정 트리거 추가

일정 트리거는 반복 주기에 따라 작업을 실행하거나 특정 미래 시간에 한 번 실행합니다. 웹의 작업 생성 또는 편집 대화 상자에서 시간별, 일일, 주간과 같은 사전 설정 빈도를 선택합니다.

* **정각 실행**: 9:00처럼 정확히 정각에 실행을 예약하면 몇 분 늦게 시작될 수 있습니다. 예약된 시간에 가깝게 시작하려면 정각에서 몇 분 지난 시간(예: 9:07)을 선택하십시오.
* **사용자 정의 간격**: 사전 설정에 없는 주기가 필요하면 작업을 만든 다음 [편집 대화 상자](#edit-and-control-scheduled-tasks)에서 **Custom**을 선택합니다. 그런 다음 2시간마다 실행하는 `0 */2 * * *`와 같은 cron 표현식을 입력합니다. CLI에서 설정하려면 [`/schedule update`](#manage-scheduled-tasks-from-the-cli)를 실행합니다. 1시간에 한 번보다 더 자주 실행되는 표현식은 거부됩니다.
* **시간대**: 사전 설정 빈도를 선택할 때는 로컬 시간대로 시간을 입력합니다.
* **cron 표현식 시간대**: 표현식이 다섯 개의 필드로만 구성된 경우 시간을 UTC로 작성합니다. 따라서 `0 9 * * 1-5`는 평일 UTC 오전 9:00에 실행됩니다. 필드가 `CRON_TZ=` 접두사로 시작하면 이를 유지하고 해당 시간대로 시간을 작성하거나, 접두사를 삭제하고 UTC로 작성합니다.

#### 일회성 실행 예약

일회성 일정은 특정 타임스탬프에 작업을 한 번만 실행합니다. 예를 들어 다음과 같은 용도로 사용합니다.

* 주 후반에 스스로에게 알림 보내기
* 롤아웃이 완료된 후 정리 PR 열기
* 업스트림 변경 사항이 배포된 후 후속 작업 시작하기

작업이 실행된 후에는 스스로 꺼지고 웹 UI에 **Completed**로 표시됩니다. 다시 실행하려면 웹에서 작업의 [편집 대화 상자](#edit-and-control-scheduled-tasks)를 열고 대화 상자에 표시되는 레이블에 따라 **One-time** 또는 **Once**를 선택합니다. 그런 다음 로컬 시간대로 새 날짜와 시간을 설정하고 저장합니다.

CLI에서 자연어로 시간을 설명하여 일회성 실행을 만듭니다. Claude는 현재 시간을 기준으로 해당 문구를 해석하고 저장하기 전에 절대 타임스탬프를 확인합니다.

```text theme={null}
/schedule tomorrow at 9am, summarize yesterday's merged PRs
```

```text theme={null}
/schedule in 2 weeks, open a cleanup PR that removes the feature flag
```

일회성 실행은 다른 예약 실행과 동일한 시간당 한도에 포함됩니다. 자세한 내용은 [사용량 및 한도](#usage-and-limits)를 참조하십시오.

### API 트리거 추가

API 트리거는 예약 작업에 전용 HTTP 엔드포인트를 제공합니다. 작업의 베어러 토큰과 함께 엔드포인트에 POST하면 새 세션이 시작되고 세션 URL이 반환됩니다. 이를 사용하여 Claude Code를 경고 시스템, 배포 파이프라인, 내부 도구 또는 인증된 HTTP 요청을 보낼 수 있는 모든 곳에 연결합니다.

API 트리거는 웹에서 [작업을 만드는](#create-from-the-web) 동안 추가하거나, 나중에 아래 단계에 따라 추가합니다. CLI에서는 API 트리거를 추가하거나 토큰을 관리할 수 없습니다.

**1. 편집할 작업 열기**

[claude.ai/code/routines](https://claude.ai/code/routines)로 이동하여 API로 트리거하려는 예약 작업을 클릭한 다음, 이름 옆의 메뉴를 열고 **Edit**를 선택합니다. **Edit scheduled task** 대화 상자가 열립니다.

**2. API 트리거 추가**

**Trigger** 행에서 \*\*+\*\*를 클릭하고 열리는 메뉴에서 **API**를 선택합니다. 이 작업의 **Fire URL**과 **Token**이 있는 패널이 나타납니다.

**3. URL 복사 및 토큰 생성**

**Fire URL**을 복사합니다. **Generate token**을 클릭한 다음 **Token generated** 대화 상자에서 토큰을 즉시 복사합니다. 토큰은 한 번만 표시되며 나중에 다시 가져올 수 없으므로 경고 도구의 시크릿 저장소와 같은 안전한 곳에 보관하십시오.

API 트리거는 토큰을 생성하는 즉시 적용됩니다. **Save changes**를 클릭할 필요가 없으므로 완료되면 대화 상자를 닫습니다.

**4. 엔드포인트 호출**

URL에 POST할 때 `Authorization: Bearer` 헤더에 토큰을 넣어 보냅니다. [예약 작업 트리거](#trigger-a-scheduled-task)에서 전체 예시를 보여줍니다.

각 예약 작업에는 해당 작업의 트리거로만 범위가 지정된 자체 토큰이 있습니다. API 액세스를 끄거나 토큰을 교체하려면 [작업의 **Edit scheduled task** 대화 상자](#edit-and-control-scheduled-tasks)를 다시 엽니다. 두 컨트롤 모두 API 트리거 패널의 토큰 옆에 있으며 즉시 적용됩니다.

* **API 액세스 끄기**: **Regenerate** 옆의 휴지통 아이콘인 **Delete token**을 클릭합니다. 이렇게 하면 API 트리거가 제거됩니다
* **토큰 교체**: **Regenerate**를 클릭합니다. 이전 토큰은 작동을 멈추고, **Token generated** 대화 상자에 새 토큰이 한 번 표시됩니다

#### 예약 작업 트리거

`Authorization` 헤더에 베어러 토큰을 넣어 `/fire` 엔드포인트로 POST 요청을 보냅니다. 요청 본문은 경고 본문이나 실패한 로그와 같은 실행별 컨텍스트를 위한 선택적 `text` 필드를 받으며, 이 값은 저장된 프롬프트와 함께 작업에 전달됩니다. 값은 자유 형식 텍스트이며 구문 분석되지 않습니다. JSON이나 다른 구조화된 페이로드를 보내면 작업은 이를 리터럴 문자열로 받습니다.

`text` 값은 루틴에 일반 메시지로 전달되지 않습니다. 이 값은 신뢰할 수 없는 데이터임을 표시하고, 루틴 자체의 프롬프트가 지시하지 않는 한 Claude가 그 안의 지침을 따르지 않도록 하는 `<routine-fire-payload>` 블록으로 감싸져 전달됩니다. 웹 UI의 **Run now**로 제공되는 텍스트에도 동일한 래핑이 적용됩니다.

즉, 루틴의 저장된 프롬프트가 fire 텍스트에 따라 동작하도록 명시적으로 허용해야 합니다. 예를 들어 "Investigate the alert described in the routine-fire-payload block"처럼 프롬프트에서 페이로드를 명시적으로 참조하도록 작성하십시오. 그렇지 않으면 루틴은 텍스트를 비활성 컨텍스트로 취급합니다. 베어러 토큰을 가진 누구나 `text`를 보낼 수 있으므로, 래퍼는 유출된 토큰으로 보낸 fire 텍스트가 루틴에 대한 직접 지침이 아니라 신뢰할 수 없는 데이터로 표시되어 도착하도록 합니다.

아래 예시는 셸에서 예약 작업을 트리거합니다. 표시된 작업 ID와 토큰은 자리 표시자입니다. [API 트리거를 추가](#add-an-api-trigger)할 때 복사한 URL과 토큰으로 바꾸지 않으면 요청이 `401` 인증 오류로 실패합니다.

```bash theme={null}
curl -X POST https://api.anthropic.com/v1/claude_code/routines/trig_01ABCDEFGHJKLMNOPQRSTUVW/fire \
  -H "Authorization: Bearer sk-ant-oat01-xxxxx" \
  -H "anthropic-beta: experimental-cc-routine-2026-04-01" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"text": "Sentry alert SEN-4521 fired in prod. Stack trace attached."}'
```

요청이 성공하면 새 세션 ID와 URL이 담긴 JSON 본문이 반환됩니다.

```json theme={null}
{
  "type": "routine_fire",
  "claude_code_session_id": "session_01HJKLMNOPQRSTUVWXYZ",
  "claude_code_session_url": "https://claude.ai/code/session_01HJKLMNOPQRSTUVWXYZ"
}
```

브라우저에서 세션 URL을 열어 실행을 실시간으로 지켜보거나, 변경 사항을 검토하거나, 대화를 직접 이어갈 수 있습니다.

> [!WARNING]
>
> `/fire` 엔드포인트는 `experimental-cc-routine-2026-04-01` 베타 헤더로 제공됩니다. 기능이 리서치 프리뷰 상태인 동안 요청 및 응답 형태, 속도 제한, 토큰 의미 체계가 변경될 수 있습니다. 호환성을 깨는 변경 사항은 날짜가 지정된 새 베타 헤더 버전으로 제공되며, 호출자가 마이그레이션할 시간을 가질 수 있도록 가장 최근의 이전 헤더 버전 두 개는 계속 작동합니다.

#### API 참조

모든 오류 응답, 검증 규칙 및 필드 제한을 포함한 전체 API 참조는 Claude Platform 문서의 [Trigger a routine through the API](https://platform.claude.com/docs/en/api/claude-code/routines-fire)를 참조하십시오.

`/fire` 엔드포인트는 claude.ai 사용자만 사용할 수 있으며 Claude Platform API의 일부가 아닙니다.

### GitHub 트리거 추가

GitHub 트리거는 연결된 저장소에서 일치하는 이벤트가 발생하면 자동으로 새 세션을 시작합니다. Claude Code는 이벤트 간에 세션을 재사용하지 않으므로 PR 업데이트 두 번은 독립적인 세션 두 개를 생성합니다.

> [!NOTE]
>
> GitHub 웹훅 이벤트에는 작업별 및 계정별 시간당 상한이 적용됩니다. 한도를 초과한 이벤트는 윈도우가 재설정될 때까지 삭제됩니다.

어느 사용 환경에서 트리거를 구성하든, 구독하려는 저장소에 Claude GitHub App이 설치되어 있어야 합니다.

* 웹 UI에서 GitHub 트리거를 구성합니다. 앱이 없으면 설치하라는 안내가 표시됩니다. 아래 단계에 따라 웹에서 구성합니다.
* CLI에서는 먼저 [GitHub App 페이지](https://github.com/apps/claude)에서 앱을 설치한 다음, Claude에게 기존 예약 작업에 GitHub 트리거를 연결하도록 요청합니다. 예: `/schedule add a GitHub trigger to my nightly review for pull requests opened in acme/webapp`. CLI 방식에는 Claude Code v2.1.225 이상이 필요합니다. Claude가 트리거를 추가하면 트리거가 실행하는 작업에 대한 링크로 응답합니다.

**1. 편집할 작업 열기**

[claude.ai/code/routines](https://claude.ai/code/routines)로 이동하여 예약 작업을 클릭한 다음, 이름 옆의 메뉴를 열고 **Edit**를 선택합니다. **Edit scheduled task** 대화 상자가 열립니다.

**2. GitHub 이벤트 트리거 추가**

**Trigger** 행에서 \*\*+\*\*를 클릭하고 열리는 메뉴에서 **GitHub event**를 선택합니다.

> [!NOTE]
>
> CLI에서 `/web-setup`을 실행하면 복제를 위한 저장소 액세스 권한이 부여되지만, Claude GitHub App이 설치되지는 않으며 웹훅 전달도 활성화되지 않습니다.

**3. 트리거 구성**

필요하면 저장소를 변경하고, [지원되는 이벤트](#supported-events) 목록에서 이벤트를 선택하고, 선택적으로 필터를 추가합니다. 그런 다음 대화 상자 하단의 **Save changes**를 클릭하여 트리거를 적용합니다.

#### 지원되는 이벤트

다음 범주 중 어느 것에서든 이벤트를 선택합니다. 각 범주 내에서 `pull_request.opened`와 같은 특정 작업을 선택하거나 범주의 모든 작업에 반응할 수 있습니다.

| 이벤트 | 트리거 시점 |
| :- | :- |
| 풀 리퀘스트 | PR이 열리거나, 닫히거나, 할당되거나, 레이블이 지정되거나, 동기화되거나, 기타 방식으로 업데이트될 때 |
| 릴리스 | 릴리스가 생성되거나, 게시되거나, 편집되거나, 삭제될 때 |
| 이슈 | 이슈가 열리거나, 편집되거나, 닫히거나, 다시 열리거나, 레이블이 지정되거나, 할당되거나, 기타 방식으로 업데이트될 때 |

#### 풀 리퀘스트 필터링

필터를 사용하여 새 세션을 시작할 풀 리퀘스트의 범위를 좁힙니다. 예약 작업이 트리거되려면 모든 필터 조건이 일치해야 합니다. 사용 가능한 필터 필드는 다음과 같습니다.

| 필터 | 일치 대상 |
| :- | :- |
| Author | PR 작성자의 GitHub 사용자 이름 |
| Title | PR 제목 텍스트 |
| Body | PR 설명 텍스트 |
| Base branch | PR이 대상으로 하는 브랜치 |
| Head branch | PR의 출처 브랜치 |
| Labels | PR에 적용된 레이블 |
| Is draft | PR이 초안 상태인지 여부 |
| Is merged | PR이 병합되었는지 여부 |

각 필터는 필드와 연산자를 짝지어 구성합니다. 연산자는 equals, contains, starts with, is one of, is not one of, matches regex 중 하나입니다.

`matches regex` 연산자는 필드 내의 부분 문자열이 아니라 필드 값 전체를 검사합니다. `hotfix`를 포함하는 모든 제목과 일치시키려면 `.*hotfix.*`로 작성합니다. 앞뒤의 `.*`가 없으면 필터는 앞뒤에 아무것도 없이 정확히 `hotfix`인 제목과만 일치합니다. 정규식 구문 없이 리터럴 부분 문자열로 일치시키려면 대신 `contains` 연산자를 사용하십시오.

필터 조합 예시:

* **인증 모듈 리뷰**: base branch `main`, head branch가 `auth-provider`를 포함. 인증과 관련된 모든 PR을 전담 리뷰어에게 보냅니다.
* **리뷰 준비 완료만**: is draft가 `false`. 초안을 건너뛰므로 PR이 리뷰할 준비가 되었을 때만 작업이 실행됩니다.
* **레이블 기반 백포트**: labels에 `needs-backport` 포함. 유지 관리자가 PR에 태그를 지정할 때만 다른 브랜치로 포팅하는 작업을 트리거합니다.

## 예약 작업 관리

목록에서 예약 작업을 클릭하여 세부 정보 페이지를 엽니다. 세부 정보 페이지에는 작업의 저장소, 커넥터, 프롬프트, 일정, API 토큰, GitHub 트리거 및 과거 실행 목록이 표시됩니다.

### 실행 보기 및 상호 작용

실행을 클릭하면 전체 세션으로 열립니다. 거기서 Claude가 수행한 작업을 확인하고, 변경 사항을 검토하고, 풀 리퀘스트를 만들거나, 대화를 이어갈 수 있습니다. 각 실행 세션은 다른 세션과 동일하게 작동합니다. 세션 제목 옆의 드롭다운 메뉴를 사용하여 이름을 바꾸거나, 보관하거나, 삭제할 수 있습니다.

작업 세부 정보 페이지의 **History**에서 완료된 각 실행의 행 끝에는 실행이 실패한 경우 **Error**, 취소된 경우 **Cancelled**가 표시되며, 성공한 경우에는 두 단어 모두 표시되지 않습니다. **Status** 필터에서는 이 세 가지 결과를 각각 **Failed**, **Cancelled**, **Succeeded**라고 부릅니다. 이러한 결과는 세션이 어떻게 종료되었는지를 나타낼 뿐, 프롬프트에 설명된 작업을 Claude가 완료했는지를 나타내지는 않습니다. 따라서 실행을 열고 트랜스크립트를 읽어 무슨 일이 있었는지 확인하십시오.

* **Succeeded**: Claude Code가 실패를 보고하지 않고 세션이 종료되었습니다. 차단된 네트워크 요청, 누락된 커넥터 도구, Claude가 완료하지 못한 작업은 행이 아닌 트랜스크립트에 나타납니다
* **Failed**: 세션이 정상적으로 완료되지 않았습니다. 예를 들어 예기치 않게 중지되었거나, 오류로 종료되었거나, 실행이 시작되기 전에 보관된 경우입니다
* **Cancelled**: 실행이 실패하지 않았으며 해당 세션이 보관되었습니다. 성공한 실행의 세션을 보관하면 해당 실행은 **Cancelled**로 변경됩니다. 작업에서 변경해야 할 사항은 없습니다

**History** 아래에 경고가 표시되면 ["The last run" 경고](#the-last-run-didnt-start)를 참조하십시오.

### 예약 작업 편집 및 제어

세부 정보 페이지에서 다음을 수행할 수 있습니다.

* **Run now**를 클릭하여 다음 예약 시간을 기다리지 않고 즉시 실행을 시작합니다.
* 페이지 상단의 켜기/끄기 스위치를 사용하여 일정을 일시 중지하거나 재개합니다. 일시 중지된 작업은 구성을 유지하지만 다시 켤 때까지 실행되지 않습니다.
* 작업 이름 옆의 메뉴를 열고 **Edit**를 선택하여 이름, 프롬프트, 저장소, 환경, 커넥터 또는 작업의 트리거를 변경합니다. **Edit scheduled task** 대화 상자는 [생성 대화 상자](#create-from-the-web)와 동일한 레이아웃으로 열립니다. 트리거를 추가하려면 **Trigger** 행에서 \*\*+\*\*를 클릭합니다. **Save changes**를 클릭하여 편집 내용을 적용합니다. API 토큰 작업은 **Save changes** 없이 즉시 적용됩니다.
* 같은 메뉴를 열고 **Delete**를 선택하여 작업을 삭제합니다.

### CLI에서 예약 작업 관리

`/schedule list`를 실행하여 예약 작업을 확인하거나, `/schedule update`로 작업을 변경하거나, `/schedule run`으로 작업을 즉시 시작합니다.

예약 작업의 실행 기록에 대해 질문할 수도 있습니다. 예: `/schedule why did my nightly review do nothing this morning?`. Claude는 작업의 최근 실행을 상태 및 [웹에서 각 실행을 열 수 있는](#view-and-interact-with-runs) 링크와 함께 나열합니다. 또한 실행의 로그를 읽어 도구 오류, 권한 거부, 최종 결과를 포함하여 무슨 일이 있었는지 설명합니다. Claude Code v2.1.227 이상이 필요합니다.

### 저장소 및 브랜치 권한

예약 작업은 저장소를 복제하기 위해 GitHub 액세스가 필요합니다. CLI에서 `/schedule`로 예약 작업을 만들면, Claude는 명령을 실행한 저장소에 대해 계정에 GitHub 액세스 권한이 있는지 확인합니다. 권한이 없으면 Claude는 권한을 부여하는 방법을 알려주는 설정 메모를 추가합니다.

> [!NOTE]
>
> 액세스 권한을 부여하는 두 가지 방법은 [GitHub 인증 옵션](https://code.claude.com/docs/ko/claude-code-on-the-web.md#github-authentication-options)을 참조하십시오. Team 및 Enterprise 플랜에서는 Claude 조직의 [Owner](https://code.claude.com/docs/ko/server-managed-settings.md#access-control)가 각 방법을 켜야 사용할 수 있습니다. [GitHub 연결](https://code.claude.com/docs/ko/web-quickstart.md#connect-github)을 참조하십시오.

실행 시점에 GitHub 연결이 없거나 만료된 경우, 예약 작업은 최대 72시간 동안 다시 연결될 때까지 실행을 건너뜁니다. 이 기간 내에 GitHub를 다시 연결하면 작업이 자동으로 재개됩니다. 72시간 동안 연결이 없으면 작업이 꺼지며, GitHub를 다시 연결한 후 직접 다시 켜야 합니다.

추가한 각 저장소는 매 실행마다 복제됩니다. 프롬프트에서 달리 지정하지 않는 한 Claude는 저장소의 기본 브랜치에서 시작합니다. [GitHub 풀 리퀘스트 이벤트](#add-a-github-trigger)가 실행을 트리거하고 풀 리퀘스트의 저장소가 작업의 첫 번째 저장소인 경우, 해당 저장소는 대신 풀 리퀘스트의 head 커밋에서 시작합니다.

프롬프트에서 다른 브랜치로 푸시하도록 지시하지 않는 한 Claude는 `claude/` 접두사가 붙은 브랜치로 작업을 푸시합니다. 실행이 푸시할 수 있는 브랜치를 제어하려면 GitHub에서 브랜치 보호 규칙 또는 규칙 세트를 사용하십시오. Anthropic 관리 인프라에서의 실행과 [Anthropic의 git 프록시](https://code.claude.com/docs/ko/self-hosted-environments-deploy.md#use-the-anthropic-git-proxy)를 통해 푸시하는 자체 호스팅 실행의 경우, GitHub는 연결한 GitHub 액세스에 이러한 규칙을 적용하므로 해당 액세스가 우회할 수 있는 규칙은 실행의 푸시를 차단하지 않습니다. 배포에서 제공하는 git 자격 증명으로 푸시하는 자체 호스팅 실행은 대신 해당 자격 증명을 기준으로 검사됩니다. [git 구성](https://code.claude.com/docs/ko/self-hosted-environments-deploy.md#configure-git)을 참조하십시오.

### 커넥터

예약 작업은 연결된 MCP 커넥터를 사용하여 각 실행 중에 외부 서비스에서 읽고 쓸 수 있습니다. 예를 들어 지원 요청을 분류하는 작업은 Slack 채널에서 읽고 Linear에 이슈를 만들 수 있습니다.

커넥터는 계정의 [claude.ai 통합](https://code.claude.com/docs/ko/mcp.md#use-mcp-servers-from-claude-ai)입니다. CLI에서 `claude mcp add`로 로컬에 추가한 MCP 서버는 claude.ai 계정이 아닌 사용자의 머신에 저장되므로 커넥터 목록에 나타나지 않습니다. 예약 작업에서 이러한 서버 중 하나를 사용하려면 다음과 같이 합니다.

* **커넥터로 추가**: [claude.ai/customize/connectors](https://claude.ai/customize/connectors)에서 커넥터로 추가합니다
* **저장소에 포함**: 저장소가 하나인 예약 작업의 경우, 대신 커밋된 [`.mcp.json`](https://code.claude.com/docs/ko/mcp#project-scope)에 서버를 선언할 수 있습니다. 단, 작업이 [프로젝트](https://code.claude.com/docs/ko/claude-projects.md#what-threads-pick-up-from-your-repositories)에서 스레드로 실행되는 경우는 예외입니다. 이 경우에는 서버를 커넥터로 추가하십시오.

예약 작업을 만들면 현재 연결된 모든 커넥터가 기본적으로 포함됩니다. 실행 중에 Claude가 액세스할 수 있는 도구를 제한하려면 필요하지 않은 커넥터를 제거하십시오. 작업의 생성 또는 편집 대화 상자에서 직접 커넥터를 추가할 수도 있습니다.

해당 대화 상자 밖에서 커넥터를 관리하거나 추가하려면 [claude.ai/customize/connectors](https://claude.ai/customize/connectors)를 방문하거나 CLI에서 `/schedule update`를 사용하십시오.

### 실행 중 권한 프롬프트

> [!NOTE]
>
> 조직의 자체 호스팅 환경에서 실행되는 작업의 경우 [권한 및 도구 승인](https://code.claude.com/docs/ko/self-hosted-environments-configuration.md#permissions-and-tool-approval)을 참조하십시오.

실행이 Anthropic 클라우드에서 새 세션을 시작하면, 자동 모드를 사용할 수 없는 경우를 제외하고 해당 세션은 [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#eliminate-prompts-with-auto-mode)로 시작합니다. 자동 모드에서는 분류기 모델이 원래라면 사용자의 승인을 기다려야 하는 작업을 허용하거나 차단합니다.

다음과 같은 경우에는 실행이 여전히 멈추고 응답을 기다립니다.

* **자동 모드에서도 확인을 요청하는 작업**: 예를 들어 [ask 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)과 일치하는 작업입니다. [자동 모드가 작업을 평가하는 방법](https://code.claude.com/docs/ko/permission-modes.md#how-auto-mode-evaluates-actions)을 참조하십시오
* **반복 차단**: 한 번의 차단으로 실행이 종료되지는 않습니다. 차단이 자동 모드의 [반복 차단 임계값](https://code.claude.com/docs/ko/permission-modes.md#repeated-block-thresholds)에 도달하면 실행의 세션에 권한 프롬프트가 나타나고 누군가 응답할 때까지 기다립니다

조직에서 자동 모드를 끈 경우나 작업의 모델이 자동 모드를 지원하지 않는 경우처럼 자동 모드를 사용할 수 없으면, 실행은 시작될 때의 권한 모드를 유지합니다. 대기 중인 프롬프트에 응답하려면 작업의 [세부 정보 페이지](#view-and-interact-with-runs)에서 실행을 엽니다.

[프로젝트](https://code.claude.com/docs/ko/claude-projects.md)에서는 실행이 새 세션을 시작하는 대신 스레드를 이어갈 수 있습니다. 이러한 실행은 그 시점에 스레드에 적용된 권한 모드를 그대로 유지합니다. 해당 스레드는 만들어질 때 자동 모드를 사용할 수 없는 경우를 제외하고 자동 모드로 시작되었습니다. 해당 스레드에서 대기 중인 프롬프트에 응답하려면 [승인을 기다리는 스레드 차단 해제](https://code.claude.com/docs/ko/claude-projects.md#unblock-a-thread-waiting-on-approval)를 참조하십시오.

### 실행이 묻지 않고 아티팩트를 게시하는 경우

[자동 모드](#permission-prompts-during-a-run)의 실행 중에는 분류기가 게시를 허용하면 Claude가 사용자에게 묻지 않고 [아티팩트](https://code.claude.com/docs/ko/artifacts.md)를 게시합니다. 예를 들어 게시가 [ask 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)과 일치하는 경우에는 여전히 먼저 확인을 요청합니다. 새 아티팩트는 [공유](https://code.claude.com/docs/ko/artifacts.md#share-an-artifact)하기 전까지 사용자에게만 표시됩니다. 아래의 [Accept edits 규칙](#artifacts-in-accept-edits-mode)은 자동 모드에는 적용되지 않습니다.

예약 작업의 역할이 페이지를 최신 상태로 유지하는 것이라면 이미 게시한 아티팩트를 지정하십시오.

#### Accept edits 모드의 아티팩트

예약 작업의 일정이나 **Run now**로 실행이 시작되면 Claude는 묻지 않고 새 [아티팩트](https://code.claude.com/docs/ko/artifacts.md)를 게시할 수 있습니다. 새 아티팩트는 [공유](https://code.claude.com/docs/ko/artifacts.md#share-an-artifact)하기 전까지 사용자에게만 표시됩니다. 게시 시 [커넥터 호출](https://code.claude.com/docs/ko/artifacts.md#pull-live-data-with-mcp-connectors)이나 [파일 다운로드](https://code.claude.com/docs/ko/artifacts.md#offer-a-file-download)와 같은 페이지의 런타임 기능을 선언하는 경우 Claude는 먼저 확인을 요청합니다.

이러한 실행에서 Claude는 다음 조건이 모두 충족되는 경우에만 묻지 않고 기존 아티팩트를 다시 게시합니다.

* 사용자가 아티팩트를 편집할 수 있고 아티팩트가 사용자의 조직에 속해 있음
* 게시에 지원 파일과 같이 페이지 이외의 내용이 포함된 경우, 사용자가 아티팩트를 소유하고 있음
* 아티팩트가 공개적으로 공유되지 않음
* 아티팩트가 특정 사용자 또는 조직과 공유된 경우, 뷰어에게 각 새 버전이 자동으로 표시되지 않음
* 게시가 더 최신 버전을 강제로 덮어쓰지 않음
* 게시가 페이지의 런타임 기능을 선언하지 않음
* 기존 페이지에 [커넥터 호출](https://code.claude.com/docs/ko/artifacts.md#pull-live-data-with-mcp-connectors)과 같이 페이지 범위를 넘어서는 권한 부여가 없음

API 또는 GitHub 트리거로 시작된 실행을 포함한 그 외의 모든 경우에는 Claude가 먼저 확인을 요청합니다.

### 환경 및 네트워크 액세스

각 예약 작업은 네트워크 액세스, 환경 변수 및 설정 스크립트를 제어하는 [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md)을 사용합니다. 작업은 모든 실행에서 환경의 네트워크 정책을 상속합니다.

**Default** 환경은 **Trusted** 네트워크 액세스를 사용하며, 세션의 네트워크를 통해 [기본 허용 목록](https://code.claude.com/docs/ko/cloud-environments.md#default-allowed-domains)만 허용합니다. 해당 경로에서 허용 목록 외부의 호스트로 보내는 요청은 `403` 및 `x-deny-reason: host_not_allowed`로 실패합니다. MCP 커넥터 트래픽은 해당 경로가 아닌 Anthropic의 서버를 통해 라우팅되므로, 작업에 추가한 커넥터는 **Allowed domains**에 호스트를 추가하지 않아도 작동합니다. 필요하지 않은 커넥터는 [커넥터](#connectors)에서 제거하십시오.

자신의 환경 중 하나에서 추가 도메인을 허용하려면 다음 단계를 따릅니다. [조직 공유 환경](https://code.claude.com/docs/ko/cloud-environments.md#organization-shared-environments)은 여기서 읽기 전용으로 열리므로, Owner가 대신 [관리자 설정](https://claude.ai/admin-settings)의 **Cloud environments** 페이지에서 네트워크 액세스를 변경합니다.

**1. 편집할 작업 열기**

[claude.ai/code/routines](https://claude.ai/code/routines)로 이동하여 예약 작업을 클릭한 다음, 이름 옆의 메뉴를 열고 **Edit**를 선택합니다. **Edit scheduled task** 대화 상자가 열립니다.

**2. 환경 선택기 열기**

**Advanced settings > General > Cloud environment**로 이동합니다. **Advanced settings**가 접혀 있으면 먼저 펼칩니다. **Default**와 같이 환경 이름이 표시된 클라우드 아이콘을 클릭합니다.

**3. 환경 설정 열기**

목록에서 환경 위에 마우스를 올리고 오른쪽에 나타나는 설정 아이콘을 클릭합니다.

**4. 네트워크 액세스 수준 변경**

**Edit cloud environment** 대화 상자에서 **Network access**를 **Custom**으로 변경하고 **Allowed domains**에 도메인을 입력합니다. 사용자 정의 도메인과 함께 [기본 허용 목록](https://code.claude.com/docs/ko/cloud-environments.md#default-allowed-domains)을 유지하려면 **Also include default list of common package managers**를 선택합니다. 제한 없는 액세스를 원하면 대신 **Full**을 선택합니다.

**5. 저장**

**Edit cloud environment** 대화 상자에서 **Save changes**를 클릭한 다음, 그 뒤에 있는 **Edit scheduled task** 대화 상자를 닫습니다. 새 정책은 다음 실행부터 적용됩니다.

액세스 수준과 기본 허용 목록에 대한 자세한 내용은 [네트워크 액세스](https://code.claude.com/docs/ko/cloud-environments.md#network-access)를 참조하십시오.

## 사용량 및 한도

예약 작업은 대화형 세션과 동일한 방식으로 구독 사용량을 소모합니다. 현재 사용량은 [claude.ai/settings/usage](https://claude.ai/settings/usage)에서 확인할 수 있습니다.

구독 사용량과는 별도로, 실행을 시작하는 각 방식에는 시간당 한도가 있습니다.

| 작업 | 한도 | 집계 기준 | 한도 초과 시 |
| :- | :- | :- | :- |
| 예약 실행(일회성 실행 포함) | 시간당 100회 | 계정 | 한도가 재설정될 때까지 실행 대기 |
| **Run now**, API fire, 일회성 작업을 다시 실행하도록 설정 | 시간당 30회 | 각 예약 작업, 세 가지가 하나의 횟수를 공유 | 한도가 재설정될 때까지 작업 실패 |
| **Run now** 및 일회성 작업을 다시 실행하도록 설정 | 시간당 100회 | 계정 | 동일 |
| API fire | 시간당 100회 | 계정, **Run now**와 별도로 집계 | 동일 |
| GitHub 이벤트 | [GitHub 트리거 추가](#add-a-github-trigger) 참조 | | |

이러한 시간당 한도에는 초과 사용이 허용되지 않습니다.

예약 작업이 구독 사용 한도에 도달하면, 사용량 크레딧을 켠 조직은 종량제 초과 사용으로 예약 작업을 계속 실행할 수 있습니다. 사용량 크레딧이 없으면 사용량 윈도우가 재설정될 때까지 추가 실행이 거부됩니다. 사용량 크레딧은 [claude.ai/settings/usage](https://claude.ai/settings/usage)에서 켭니다. Team 및 Enterprise 플랜에서는 관리자가 [claude.ai/admin-settings/usage](https://claude.ai/admin-settings/usage)에서 조직에 대해 켭니다.

구독이 일시 중지된 동안에는 예약 작업이 보류되어 실행되지 않습니다. 구독이 다시 활성화되면 예약 작업을 다시 켜십시오.

## 루틴이라는 이름이 여전히 나타나는 곳

예약 작업은 이전에 루틴이라고 불렸으며, 다음 위치에서는 이전 이름을 유지합니다. 모두 동일한 기능을 가리킵니다.

* **앱**: 일부 계정에서는 사이드바 항목과 페이지 제목이 **Routines**로, 버튼이 **New routine**으로 표시되며, 다른 레이블에도 routine이라고 표시됩니다. 이 경우 작업을 만드는 방법은 [전체 페이지 양식](#full-page-form)을 참조하세요.
* **웹 주소**: `claude.ai/code/routines`
* **CLI**: `/schedule`의 별칭인 `/routines`, 명령의 설명, 그리고 작업을 설정하는 동안의 Claude 응답
* **API**: `/fire` 엔드포인트 경로, 베타 헤더, 응답의 `type`, `<routine-fire-payload>` 태그, 그리고 [Trigger a routine through the API](https://platform.claude.com/docs/en/api/claude-code/routines-fire) 참조 페이지
* **조직 설정**: **Scheduled tasks (Was Routines)** 토글

## 문제 해결

### `/schedule`이 "Unknown command"를 반환함

CLI는 요구 사항 중 하나가 충족되지 않으면 `/schedule`을 숨깁니다. 입력하는 동안 명령 메뉴에 `No commands match "/schedule"`이 표시됩니다. 제출하면 아래에서 다른 응답을 명시한 경우를 제외하고 `Unknown command: /schedule`이 반환됩니다.

원인은 일반적으로 다음 중 하나입니다.

* Console API 키, [Anthropic 프로필 또는 페더레이션 자격 증명](https://code.claude.com/docs/ko/authentication.md#anthropic-profiles-and-federation-credentials), 또는 Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry와 같은 클라우드 제공자로 인증되어 있습니다. `/schedule`에는 claude.ai 구독 로그인이 필요합니다. Console API 키나 프로필을 사용하고 기능 플래그 가져오기가 활성화되어 있으면, `/schedule`을 제출할 때 대신 `/schedule is available with Claude for Enterprise — ask your admin about migrating from API-key access`가 표시됩니다. 클라우드 제공자 로그인을 사용하면 여전히 `Unknown command: /schedule`이 표시됩니다. 셸에 `ANTHROPIC_API_KEY` 또는 `ANTHROPIC_AUTH_TOKEN`이 설정되어 있거나 `settings.json`에 `apiKeyHelper`가 설정되어 있으면 이들이 claude.ai 로그인보다 우선하므로 먼저 제거하십시오. 프로필 또는 페더레이션 자격 증명도 우선하므로 함께 꺼야 합니다
* API 키나 다른 자격 증명 없이 완전히 로그아웃되어 있습니다. 기능 플래그 가져오기가 활성화되어 있으면 `/schedule`을 제출할 때 `/schedule requires a claude.ai subscription. Run /login to sign in with your claude.ai account.`가 표시됩니다. v2.1.268 이전에는 로그아웃된 세션에 Console API 키와 동일한 Claude for Enterprise 메시지가 표시되었습니다
* 클라우드 세션 안에 있으며, 이 경우 `/schedule`을 제출하면 해당 환경에서는 명령을 사용할 수 없다는 응답이 표시됩니다. 대신 [웹 UI](https://claude.ai/code/routines)에서 예약 작업을 관리하십시오
* 조직의 정책이 예약 작업에 필요한 [클라우드 세션](https://code.claude.com/docs/ko/claude-code-on-the-web.md)을 비활성화합니다. 이 경우 `/schedule`을 제출하면 대신 [`Cloud sessions are disabled by your organization's policy`](https://code.claude.com/docs/ko/errors#cloud-sessions-are-disabled-by-your-organizations-policy)로 응답합니다. v2.1.268 이전에는 `Unknown command: /schedule`을 반환했습니다
* Owner가 Team 또는 Enterprise 조직에 대해 [예약 작업을 껐습니다](#routines-are-disabled-by-your-organizations-policy). v2.1.227 이전에는 이 경우에도 명령이 계속 나타났으며, Claude가 작업을 만들거나 실행하려고 하면 claude.ai가 작업을 거부했습니다
* Enterprise 조직이 [사용자 지정 역할](https://support.claude.com/en/articles/13930452)로 액세스를 관리하고 있으며, 할당된 역할 중 어느 것에도 **Remote sessions** 아래의 예약 작업 권한이 포함되어 있지 않습니다. Owner에게 역할 중 하나에 해당 권한을 추가해 달라고 요청하십시오

원인이 CLI 로그인 방식이거나 클라우드 세션 안에 있는 것이라면, [claude.ai/code/routines](https://claude.ai/code/routines)에서 여전히 예약 작업을 만들고 관리할 수 있습니다. 이를 위해서는 Pro, Max, Ultra, Team 또는 Enterprise 계정이 필요합니다. 조직에서 예약 작업이나 클라우드 세션이 꺼져 있거나 역할에 포함되어 있지 않으면 웹에서도 만들 수 없습니다.

### "Routines are disabled by your organization's policy"

Team 또는 Enterprise 조직의 Owner가 [**Organization settings > Capabilities > Remote sessions**](https://claude.ai/admin-settings/capabilities)의 **Scheduled tasks (Was Routines)** 토글을 껐을 가능성이 높습니다. Claude Code v2.1.227 이상에서는 같은 토글이 CLI의 `/schedule`도 숨깁니다. 이는 서버 측 조직 설정이므로 로컬 구성으로 재정의할 수 없습니다. Owner에게 조직의 예약 작업을 다시 켜 달라고 요청하십시오.

### "The last run" 경고

**History** 아래의 경고가 "The last run"으로 시작하면 첫 번째 열에서 해당 경고를 찾아 그 행에 안내된 대로 조치하십시오. 이후 실행이 시작되면 경고가 사라집니다.

| 경고 | 조치 방법 |
| :- | :- |
| "The last run didn't start because your organization had reached its limit on cloud sessions running at once." | 작업을 변경할 필요는 없습니다. 나중에 **Run now**를 클릭하거나 다음 실행을 기다리십시오 |
| "The last run didn't start because its cloud environment couldn't be found or used." | 작업의 세부 정보 페이지에서 이름 옆의 메뉴를 열고 **Edit**를 선택한 다음 [클라우드 환경 선택기](#environments-and-network-access)를 찾으십시오. **Unavailable environment**로 표시되면 해당 환경이 보관되었거나 더 이상 계정에서 사용할 수 없는 것이므로, 그곳에서 다른 환경을 선택하고 변경 사항을 저장하십시오. 그렇지 않으면 세부 정보 페이지에서 **Run now**로 재시도하거나, 선택기에서 다른 환경을 선택하고 변경 사항을 저장하십시오 |
| "The last run was blocked because it couldn't access something it needs, or your organization's policy doesn't allow it." | [GitHub 액세스](#repositories-and-branch-permissions)가 작업의 저장소를 포함하는지 확인하십시오. 포함한다면 Claude 조직의 [Owner](https://code.claude.com/docs/ko/server-managed-settings.md#access-control)에게 정책이 작업을 차단하고 있는지 문의하십시오 |
| "The last run didn't start because of a problem that's usually temporary." | **Run now**를 클릭하여 다시 시도하거나 다음 실행을 기다리십시오 |
| "The last run didn't start because its repository or branch wasn't available." | GitHub에서 작업의 각 저장소에 [실행이 시작되는 브랜치](#repositories-and-branch-permissions)가 있는지 확인하십시오. 또한 [GitHub 액세스](#repositories-and-branch-permissions)가 각 저장소를 포함하는지 확인하고, 연결이 만료되었다면 GitHub를 다시 연결하십시오 |
| "The last run didn't start because some of its settings weren't accepted." | 작업의 세부 정보 페이지에서 이름 옆의 메뉴를 열고 **Edit**를 선택하십시오. 대화 상자에는 어떤 설정이 허용되지 않았는지 표시되지 않으므로, 작업의 이름, 프롬프트, 모델, 저장소, 환경, 커넥터, 트리거를 포함한 각 설정을 그곳에서 확인하십시오 |
| "The last run stopped because a usage limit was reached." | 사용 한도에 도달한 후 작업 실행이 언제 다시 시작될 수 있는지는 [사용량 및 한도](#usage-and-limits)를 참조하십시오 |
| "The last run failed." | **Run now**를 클릭하여 다시 시도하거나 다음 실행을 기다리십시오. 실패한 실행에는 열 수 있는 세션이 없습니다 |

## 관련 리소스

* [`/loop` 및 세션 내 예약](https://code.claude.com/docs/ko/scheduled-tasks): 열려 있는 CLI 세션 내에서 로컬 작업 예약
* [데스크톱 예약 작업](https://code.claude.com/docs/ko/desktop-scheduled-tasks.md): 로컬 파일에 액세스할 수 있는 사용자의 머신에서 실행되는 로컬 예약 작업
* [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md): 클라우드 세션의 네트워크 액세스, 환경 변수 및 설정 스크립트 구성
* [프로젝트](https://code.claude.com/docs/ko/claude-projects.md): Claude가 병렬 클라우드 세션 전반에서 조율하는 진행 중인 작업이며, 프로젝트에서 만든 예약 작업은 해당 프로젝트의 **Scheduled tasks** 탭에 나타납니다
* [MCP 커넥터](https://code.claude.com/docs/ko/mcp.md): Slack, Linear, Google Drive와 같은 외부 서비스 연결
* [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md): 저장소 이벤트 발생 시 CI 파이프라인에서 Claude 실행
