> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 클라우드에서 Claude Code 사용하기

> 브라우저, 휴대폰, 데스크톱 앱 또는 터미널에서 클라우드의 Claude Code 세션을 실행하고, `--cloud` 및 `--teleport`로 이동하며, 풀 리퀘스트를 자동 수정합니다.

> [!NOTE]
>
> 클라우드 세션은 Pro, Max, Ultra 및 Team 요금제, 그리고 프리미엄 시트 또는 Chat + Claude Code 시트가 있는 Enterprise 사용자를 위해 제공됩니다. [사용자 지정 역할](https://support.claude.com/en/articles/13930452)로 액세스가 관리되는 경우, 브라우저, 앱 또는 터미널에서 Anthropic 인프라의 세션을 시작하려면 클라우드 세션 권한이 포함된 역할도 필요합니다. Owner에게 [**Organization settings > Roles**](https://claude.ai/admin-settings/roles)에서 해당 권한을 사용자의 역할 중 하나에 추가하도록 요청하십시오.

클라우드 세션은 사용자의 머신 대신 클라우드 인프라에서 실행되는 Claude Code 세션입니다. 기본적으로 Anthropic이 관리하는 인프라에서 실행되거나, 라우팅될 때 조직의 [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)에서 실행됩니다. 세션은 노트북을 닫은 후에도 계속 실행되며, 모든 기기에서 확인하거나 조종할 수 있습니다. 클라우드 세션은 나머지 Claude 및 Claude Code 사용량과 함께 요금제의 사용 한도에 포함되며, 클라우드 VM에 대한 별도 요금은 없습니다.

클라우드 세션이 GitHub에서 코드를 클론하고 브랜치를 푸시할 수 있도록 하려면 [GitHub 연결 방법](#github-authentication-options) 중 하나로 GitHub를 연결하십시오. 저장소가 GitLab, Bitbucket 또는 기타 호스트에 있는 경우 [플랫폼 제한](#limitations)에서 지원되는 기능을 확인하십시오.

다음 중 어느 곳에서나 클라우드 세션을 시작할 수 있습니다:

* **브라우저**: [claude.ai/code](https://claude.ai/code), 웹에서 Claude Code라고도 불림
* **모바일**: [Claude 앱](https://code.claude.com/docs/ko/mobile.md)의 **Code** 탭
* **데스크톱 앱**: [세션을 시작](https://code.claude.com/docs/ko/desktop.md#run-long-running-tasks-in-the-cloud)할 때 환경 선택기의 **Cloud** 아래에서 환경을 선택
* **터미널**: [`claude --cloud`](#from-terminal-to-cloud)
* **클라우드 예약 작업**: [예약 및 트리거된 실행](https://code.claude.com/docs/ko/routines.md)은 각각 클라우드 세션으로 실행됨

설정이 완료되면 이 페이지를 참고하여 터미널과 클라우드 간에 작업을 이동하고, 세션을 관리 및 공유하고, 풀 리퀘스트 자동 수정을 켜고, 문제를 해결하십시오.

> [!NOTE]
>
> 다음 사례는 다른 페이지에서 다룹니다:
>
> * **첫 번째 클라우드 세션 시작하기**: [클라우드 세션 시작하기](https://code.claude.com/docs/ko/web-quickstart.md)에서 GitHub를 연결하고 브라우저에서 작업을 진행하는 과정을 안내합니다
> * **한 본문의 작업을 위한 여러 클라우드 세션**: [프로젝트](https://code.claude.com/docs/ko/claude-projects.md)를 사용하면 Claude가 세션을 대신 시작하고 추적합니다
> * **다른 기기에서 로컬 세션 조종하기**: 터미널, IDE 또는 **Local**이 선택된 데스크톱 앱의 세션은 사용자의 머신에서 실행되며, [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 사용하면 휴대폰이나 브라우저에서 이러한 세션에 접근할 수 있습니다

## 클라우드 환경

모든 클라우드 세션은 [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md)에서 실행되며, 이는 네트워크 액세스, 환경 변수 및 설정 스크립트를 제어하는 저장된 구성입니다.

* **첫 번째 환경**: 아직 환경이 없으면 온보딩이 [**신뢰할 수 있는** 네트워크 액세스](https://code.claude.com/docs/ko/cloud-environments.md#access-levels)를 사용하여 **기본** 환경을 설정합니다. 이는 사용자를 위해 생성하거나 사용자가 생성하도록 요청합니다. 플랜에서 어느 것이 발생하는지는 [기본 환경](https://code.claude.com/docs/ko/cloud-environments.md#the-default-environment)을 참조하세요
* **세션이 사용하는 환경**: 둘 이상의 환경이 있을 때 세션이 환경을 선택하는 방법은 [기본 환경](https://code.claude.com/docs/ko/cloud-environments.md#the-default-environment)을 참조하세요
* **세션이 접근하거나 시작 시 실행할 수 있는 항목 변경**: [클라우드 환경 구성](https://code.claude.com/docs/ko/cloud-environments.md)을 참조하세요
* **구성 없이 설치되어 있는 항목**: [설치된 도구](https://code.claude.com/docs/ko/cloud-environments.md#installed-tools)를 참조하세요

## GitHub 인증 옵션

클라우드 세션은 코드를 복제하고 분기를 푸시하기 위해 GitHub 저장소에 액세스해야 합니다. 두 가지 방법으로 액세스 권한을 부여할 수 있습니다:

| 방법 | 연결 방식 | 세션이 도달할 수 있는 저장소 | 최적 대상 |
| :- | :- | :- | :- |
| **GitHub App** | [웹 온보딩](https://code.claude.com/docs/ko/web-quickstart.md) 중에 Claude GitHub App을 승인합니다. | 모든 공개 저장소 및 Claude GitHub App이 설치된 비공개 저장소 | 브라우저 온보딩; [자동 수정](#auto-fix-pull-requests)을 원하는 팀 |
| **`/web-setup`** | 터미널에서 `/web-setup`을 실행하여 로컬 `gh` CLI 토큰을 Claude 계정으로 전송합니다. | `gh` 토큰이 액세스할 수 있는 모든 저장소(App 설치 여부와 관계없음) | 이미 `gh`를 사용하는 개별 개발자 |

다음 기능은 저장소에 Claude GitHub App이 설치되어 있어야 합니다:

* **자동 수정**: 저장소에 Claude GitHub App을 설치하면 해당 저장소의 풀 리퀘스트에 대해 [자동 수정](#auto-fix-pull-requests)도 활성화됩니다
* **프로젝트**: [프로젝트](https://code.claude.com/docs/ko/claude-projects.md)의 스레드는 연결 방법에 관계없이 복제하는 각 저장소에 Claude GitHub App이 설치되어 있어야 합니다. [GitHub 액세스 설정](https://code.claude.com/docs/ko/claude-projects.md#set-up-github-access)을 참조하세요

Anthropic 호스팅 환경에서는 GitHub 자격 증명이 Anthropic 서버에 암호화되어 저장되며 세션의 VM에 절대 들어가지 않습니다. VM의 GitHub 작업은 [GitHub 프록시](https://code.claude.com/docs/ko/cloud-environments.md#github-proxy)를 통해 진행되며, 이는 서버 측에서 자격 증명을 첨부합니다.

`/web-setup` 안내(`/web-setup`이 저장하는 내용 및 제거 방법 포함)는 [터미널에서 연결](https://code.claude.com/docs/ko/web-quickstart.md#connect-from-your-terminal)을 참조하세요.

> [!NOTE]
>
> [Zero Data Retention](https://code.claude.com/docs/ko/zero-data-retention.md)이 활성화되었거나 [HIPAA 구성](https://code.claude.com/docs/ko/hipaa-setup.md)이 적용된 조직은 `/web-setup` 또는 기타 클라우드 세션 기능을 사용할 수 없습니다. [고객 관리형 암호화 키](https://platform.claude.com/docs/en/manage-claude/cmek)(CMEK)를 사용하는 조직도 클라우드 세션을 시작할 수 없습니다.

### Team 및 Enterprise용 빠른 설정

빠른 설정은 구성원의 GitHub 및 환경 설정 단계를 줄여 주는 조직 설정입니다. Team 및 Enterprise 플랜에서는 기본적으로 꺼져 있습니다.

이 설정을 켜면 구성원에게 다음과 같은 변화가 있습니다:

* **`/web-setup`**: 구성원이 `/web-setup`으로 GitHub를 연결할 수 있습니다. 설정이 꺼져 있는 동안에는 이 명령이 숨겨집니다
* **GitHub App 프롬프트**: 브라우저 온보딩에서 Claude GitHub App 설치 프롬프트를 건너뜁니다
* **첫 번째 환경**: 브라우저 온보딩이 환경 양식을 표시하는 대신 구성원을 위해 [**기본** 환경](https://code.claude.com/docs/ko/cloud-environments.md#the-default-environment)을 생성합니다

[Owner](https://code.claude.com/docs/ko/server-managed-settings.md#access-control)는 [**Organization settings > Claude Code**](https://claude.ai/admin-settings/claude-code)의 **Quick setup** 토글로 이 설정을 켭니다.

## 터미널과 클라우드 간 작업 이동

이러한 워크플로우는 동일한 claude.ai 계정으로 로그인한 [Claude Code CLI](https://code.claude.com/docs/ko/quickstart.md)가 필요합니다. 터미널에서 새로운 클라우드 세션을 시작하거나, 클라우드 세션을 터미널로 가져와 로컬에서 계속 작업할 수 있습니다. 클라우드 세션은 노트북을 닫아도 유지되며, Claude 모바일 앱을 포함한 어디서나 모니터링할 수 있습니다.

> [!NOTE]
>
> CLI에서 세션 핸드오프는 일방향입니다. `--teleport`를 사용하여 클라우드 세션을 터미널로 가져올 수 있지만, 기존 터미널 세션을 클라우드로 푸시할 수는 없습니다. 작업 설명과 함께 `--cloud` 플래그는 현재 저장소에 대한 새로운 클라우드 세션을 생성합니다. `-p`와 세션 ID 또는 claude.ai/code URL을 사용하면 대신 [해당 기존 세션에 메시지를 큐에 넣습니다](https://code.claude.com/docs/ko/claude-code-on-the-web.md#send-follow-ups-from-the-cli). [Desktop 앱](https://code.claude.com/docs/ko/desktop.md#continue-in-another-surface)은 **Open in** 메뉴에서 Code 탭의 로컬 세션을 클라우드로 보낼 수 있습니다.

### 터미널에서 클라우드 세션 시작하기

`--cloud` 플래그를 사용하여 명령줄에서 클라우드 세션을 시작합니다:

```bash theme={null}
claude --cloud "Fix the authentication bug in src/auth/login.ts"
```

이는 claude.ai에서 새로운 클라우드 세션을 생성합니다. 클라우드 VM은 로컬 체크아웃이 아닌 현재 브랜치에서 현재 디렉터리의 GitHub 원격을 복제하므로, 로컬 커밋이 있으면 먼저 푸시하십시오. Claude Code가 원격을 복제하는 대신 로컬 저장소를 업로드하는 경우는 [GitHub 없이 로컬 저장소 보내기](#send-local-repositories-without-github)를 참조하십시오. 터미널에 `Branch <name> is not on GitHub`가 출력되면 [Branch is not on GitHub](#branch-is-not-on-github)를 참조하십시오.

`--cloud`는 한 번에 하나의 저장소에서만 작동합니다. 작업은 클라우드에서 실행되는 동안 로컬에서 계속 작업할 수 있습니다. 이전의 `--remote` 표기법은 여전히 `--cloud`의 더 이상 사용되지 않는 별칭으로 작동합니다.

클라우드 컨테이너가 시작되는 동안 CLI는 저장소 복제 및 [설정 스크립트](https://code.claude.com/docs/ko/cloud-environments.md#setup-scripts) 실행과 같은 설정 단계의 라이브 체크리스트를 표시합니다. 프로비저닝 중에 입력한 메시지를 큐에 넣고 세션이 준비되면 전송합니다.

> [!NOTE]
>
> `--cloud`는 클라우드 세션을 생성합니다. `--remote-control`은 관련이 없습니다. 이는 claude.ai 또는 Claude 앱에서 로컬 CLI 세션을 모니터링하고 조종할 수 있게 해줍니다. [Remote Control](https://code.claude.com/docs/ko/remote-control.md)을 참조하십시오.

claude.ai 또는 Claude 모바일 앱에서 세션을 열어 진행 상황을 확인하거나 직접 상호작용합니다. 여기서 Claude를 조종하고, 피드백을 제공하거나, 다른 대화와 마찬가지로 질문에 답할 수 있습니다.

Claude가 질문을 하고 세션이 유휴 상태로 있으면, [환경 만료](#environment-expired)까지 돌아올 때 여전히 답할 수 있으며, 세션은 답변에서 계속됩니다.

#### 클라우드 작업 팁

**로컬에서 계획하고 클라우드에서 실행**: 복잡한 작업의 경우, Claude를 계획 모드로 시작하여 접근 방식을 협력한 다음, 작업을 클라우드로 보냅니다:

```bash theme={null}
claude --permission-mode plan
```

계획 모드에서 Claude는 파일을 읽고, 명령을 실행하여 탐색하고, 소스 코드를 편집하지 않고 계획을 제안합니다. 만족하면 계획을 저장소에 저장하고, 커밋하고, 푸시하여 클라우드 VM이 복제할 수 있도록 합니다. 그런 다음 자동 실행을 위해 클라우드 세션을 시작합니다:

```bash theme={null}
claude --cloud "Execute the migration plan in docs/migration-plan.md"
```

**작업을 병렬로 실행**: 각 `--cloud` 명령은 독립적으로 실행되는 자체 클라우드 세션을 생성합니다. 여러 작업을 시작할 수 있으며 모두 별도의 세션에서 동시에 실행됩니다:

```bash theme={null}
claude --cloud "Fix the flaky test in auth.spec.ts"
claude --cloud "Update the API documentation"
claude --cloud "Refactor the logger to use structured output"
```

세션이 완료되면 claude.ai/code에서 PR을 생성하거나 [teleport](#from-cloud-to-terminal)를 사용하여 세션을 터미널로 가져와 계속 작업할 수 있습니다.

#### GitHub 없이 로컬 저장소 보내기

git 원격이 없는 저장소에서 또는 Claude GitHub 앱이 설치되지 않은 github.com 저장소에서 `claude --cloud`를 실행하면, Claude Code는 로컬 저장소를 번들로 묶어 클라우드 세션에 직접 업로드합니다. 이는 `/web-setup`으로 GitHub를 연결한 경우에도 적용됩니다.

전체 복제의 경우, 번들에는 모든 브랜치의 저장소 기록과 추적된 파일에 대한 커밋되지 않은 변경 사항이 포함됩니다.

민감한 파일의 커밋되지 않은 변경 사항이 어떻게 처리되는지는 플랫폼에 따라 다릅니다:

* **macOS, Linux 및 WSL**: Claude Code는 자격 증명 또는 키와 같은 이름의 파일에 대한 커밋되지 않은 변경 사항을 업로드에서 제외합니다. 여기에는 `.env` 파일, Terraform `*.tfvars` 파일, `id_rsa` 및 `*.pem`과 같은 키 파일이 포함됩니다. 또한 Git LFS와 같은 git 필터가 관리하는 파일에 대한 커밋되지 않은 변경 사항도 제외합니다. `Left on this machine:` 알림에 제외된 파일의 이름이 표시되며, 세션은 각 파일의 커밋된 버전으로 시작하거나, 커밋된 버전이 없으면 해당 파일 없이 시작합니다.
* **네이티브 Windows**: 추적된 파일에 대한 커밋되지 않은 변경 사항은 파일 이름과 관계없이 그대로 업로드됩니다. 클라우드 세션에 포함하고 싶지 않은 편집 내용은 세션을 시작하기 전에 stash하거나 되돌리십시오.

Claude Code가 원격에서 복제하는 대신 번들을 업로드하도록 하려면 `CCR_FORCE_BUNDLE=1`을 설정합니다:

```bash theme={null}
CCR_FORCE_BUNDLE=1 claude --cloud "Run the test suite and fix any failures"
```

번들된 저장소는 다음 제한을 충족해야 합니다:

* 디렉토리는 최소 하나의 커밋이 있는 git 저장소여야 합니다
* 번들된 저장소는 100 MB 미만이어야 합니다. 더 큰 저장소는 현재 브랜치만 번들로 묶기로 폴백한 다음, 작업 트리의 단일 스쿼시된 스냅샷으로 폴백하고, 스냅샷이 여전히 너무 크면 실패합니다
* 추적되지 않은 파일은 포함되지 않습니다. 클라우드 세션이 볼 파일에 대해 `git add`를 실행합니다
* macOS, Linux 및 WSL에서 Claude Code는 포함된 구성 파일에 설정된 `core.attributesFile`과 같이 파일에 적용되는 속성 규칙에 영향을 미치는 git 설정을 따를 수 없을 때 업로드를 거부합니다. [거부 메시지](https://code.claude.com/docs/ko/errors.md#the-repository-upload-cant-follow-a-git-setting)는 설정과 수정 방법을 이름으로 지정합니다
* 번들에서 생성된 세션은 [GitHub 연결](#github-authentication-options)이 해당 저장소에 대한 푸시 액세스 권한을 가질 때만 GitHub 원격으로 다시 푸시할 수 있습니다

macOS, Linux 및 WSL에서는 업로드에 git 2.31 이상과 지원되는 체크아웃 레이아웃도 필요하지만, 네이티브 Windows에서는 Claude Code가 두 가지 확인 없이 업로드합니다. 체크아웃이 이러한 요구 사항을 충족하지 않으면 Claude Code는 세션을 시작하지 않습니다. `Not uploading this working tree:`가 포함된 오류를 출력하고, 원인을 밝히며, 무엇을 변경해야 하는지 안내합니다. 일반적인 원인은 다음과 같습니다:

* **이전 버전의 git**: 설치된 git이 2.31보다 오래되었습니다. git을 업데이트한 다음 재시도하십시오.
* **업로드가 지원하지 않는 체크아웃 레이아웃**: 서브모듈 내부, `git clone --separate-git-dir`, `--shared` 또는 `--reference`로 만든 클론, `core.worktree`가 설정된 체크아웃, 또는 ref를 reftable 형식으로 보관하는 저장소에서 시작했습니다. 대신 일반 `git clone`으로 만든 클론의 메인 체크아웃에서 시작하십시오.
* **스파스 체크아웃이 있는 연결된 worktree**: `git sparse-checkout`은 worktree 자체의 `config.worktree` 파일에 설정을 기록하는데, 업로드는 이 파일을 허용하지 않습니다. 따라서 이러한 설정이 있는 worktree는 업로드되지 않으며, Claude Code가 [`worktree.sparsePaths`](https://code.claude.com/docs/ko/settings-reference#worktree-sparsepaths)로 생성한 worktree도 마찬가지입니다. 대신 저장소의 메인 체크아웃에서 시작하십시오.
* **작업 트리 내부에 보관된 git 구성**: git 구성이 체크아웃 내부에 있는 파일을 포함합니다(예: 저장소 내부를 가리키는 `include.path` 항목). 해당 파일을 작업 트리 밖으로 옮기거나 include를 제거한 다음 재시도하십시오.

macOS, Linux 및 WSL에서 `git clone --filter`로 만든 부분 클론은 모든 추적된 파일을 로컬에 보유하고 있는 한, 기록 없이 작업 트리의 스냅샷으로 업로드됩니다.

`claude --cloud`의 경우 저장소가 GitHub에 있으면 업로드와 그 요구 사항을 피할 수 있습니다. 브랜치를 푸시하고, 저장소에 Claude GitHub 앱을 설치한 다음, 세션을 다시 시작하여 GitHub에서 복제되도록 하십시오.

### CLI에서 후속 메시지 보내기

클라우드 세션이 실행 중이면, 어디서 실행되든 `claude auth login`으로 로그인한 모든 머신의 `claude` CLI에서 후속 메시지를 보낼 수 있습니다. CLI는 Anthropic 계정 자격 증명으로 인증하고 로컬 세션 상태를 보내지 않으므로, 명령은 세션을 시작한 머신에서 실행할 필요가 없습니다.

명령은 하나의 메시지를 게시하고 종료합니다:

```bash theme={null}
claude -p "your message" --cloud <session-id>
```

CLI는 메시지를 세션에 큐에 넣고 응답을 기다리지 않고 종료합니다. 이를 사용하여 장시간 실행되는 세션을 조종하고, 현재 세션이 아직 완료되는 동안 다음 단계를 큐에 넣거나, [CI 스크립트](https://code.claude.com/docs/ko/self-hosted-environments-testing.md#run-the-test-loop)에서 후속 메시지를 보냅니다. 또한 인수로 전달하는 대신 stdin에서 메시지를 파이프할 수 있습니다: `echo "your message" | claude -p --cloud <session-id>`.

`<session-id>`의 경우, `session_...` 또는 `cse_...`와 같은 베어 ID 또는 세션의 `claude.ai/code/<id>` URL을 스키마 또는 쿼리 문자열 없이 전달합니다. claude.ai/code의 세션 목록에서 ID를 찾습니다.

> [!NOTE]
>
> `--cloud`는 Anthropic 계정이 필요합니다. Claude Code가 Amazon Bedrock, Google Cloud의 Agent Platform 또는 다른 타사 제공자로 구성된 경우 사용할 수 없습니다. `ANTHROPIC_BASE_URL`을 통해서만 구성된 [LLM gateway](https://code.claude.com/docs/ko/llm-gateway)는 이 확인에서 타사 제공자로 간주되지 않지만, 여전히 `claude auth login`으로 로그인해야 합니다. 조직의 `allow_remote_sessions` 정책도 활성화되어야 합니다. 소유자는 claude.ai/admin-settings/claude-code의 Claude Code 관리 설정에서 이를 켤 수 있습니다.

#### 출력

성공하면 명령은 세션 ID와 세션을 보기 위한 링크를 인쇄합니다:

```
Sent to cloud session.
Session ID: session_01DiUkqY2kzbUbDmW1w96rfi
View: https://claude.ai/code/session_01DiUkqY2kzbUbDmW1w96rfi?from=cli&m=0
```

`--output-format json`을 전달하여 머신이 읽을 수 있는 결과를 얻습니다: 성공 시 `{ok, session_id, url}`, 또는 세션이 누락되거나 보관된 경우와 같이 전송이 실패할 때 `{ok: false, session_id, error}`입니다. 지원되지 않는 제공자 또는 비활성화된 조직 정책과 같은 구성 오류는 JSON 없이 stderr에 인쇄됩니다. `--output-format stream-json`은 `--cloud <session-id>`에서 지원되지 않습니다.

전송이 실패하면 [클라우드 세션으로 전송할 때의 오류](#errors-when-sending-to-a-cloud-session)를 참조하십시오.

### 터미널에서 클라우드 세션 계속하기

다음 중 하나를 사용하여 클라우드 세션을 터미널로 가져옵니다:

* **`--teleport` 사용**: 명령줄에서 `claude --teleport`를 실행하여 대화형 세션 선택기를 열거나, `claude --teleport <session-id>`를 실행하여 특정 세션을 직접 재개합니다. 커밋되지 않은 변경 사항이 있으면 먼저 stash하라는 메시지가 표시됩니다. [`--resume`](https://code.claude.com/docs/ko/sessions#resume-a-session)은 이 머신의 로컬 기록에서 대화를 다시 열며 클라우드 세션을 나열하지 않습니다.
* **`/teleport` 사용**: 기존 CLI 세션 내에서 `/teleport` 또는 `/tp`를 실행하여 Claude Code를 다시 시작하지 않고 동일한 세션 선택기를 엽니다.
* **`/tasks`에서**: `/tasks`를 실행하여 백그라운드 세션을 보고, `t`를 눌러 하나로 teleport합니다.
* **claude.ai/code에서**: 세션 메뉴에서 **Open in > Terminal**을 선택하여 터미널에 붙여넣을 수 있는 명령을 복사합니다.
* **클라우드 세션 내에서**: `/teleport`를 입력하면 Claude Code가 해당 세션에 대한 정확한 `claude --teleport <session-id>` 명령으로 응답하며, 저장소의 체크아웃에서 실행할 준비가 됩니다. 세션의 환경에서 Claude Code v2.1.223 이상이 필요합니다.

세션을 teleport할 때, Claude는 올바른 저장소에 있는지 확인하고, 클라우드 세션에서 브랜치를 가져와 체크아웃하고, 대화를 터미널에 로드합니다.

> [!NOTE]
>
> Claude Code가 클라우드 세션을 [압축](https://code.claude.com/docs/ko/context-window.md#what-survives-compaction)한 경우(긴 세션에서는 자동으로 수행됨), 요약된 이전 메시지는 터미널로 복사되지 않습니다. Claude는 요약에서부터 계속합니다. 원래 메시지를 읽으려면 claude.ai 또는 Claude 모바일 앱의 클라우드 세션에서 위로 스크롤하십시오.

터미널은 세션의 자체 복사본을 가집니다. 여기서의 새로운 작업은 로컬로 유지되며 claude.ai의 클라우드 세션이나 Claude 모바일 앱에 나타나지 않습니다. teleport 후 휴대폰에서 계속 조종하려면 로컬 세션에서 [`/remote-control`](https://code.claude.com/docs/ko/remote-control)을 시작합니다.

#### Teleport 요구 사항

Teleport는 세션을 재개하기 전에 이러한 요구 사항을 확인합니다. 요구 사항이 충족되지 않으면 오류가 표시되거나 문제를 해결하라는 메시지가 표시됩니다.

| 요구 사항 | 세부 사항 |
| - | - |
| 깨끗한 git 상태 | 작업 디렉토리에 커밋되지 않은 변경 사항이 없어야 합니다. Teleport는 필요한 경우 변경 사항을 stash하라는 메시지를 표시합니다. |
| 올바른 저장소 | 포크가 아닌 동일한 저장소의 체크아웃에서 `--teleport`를 실행해야 합니다. 다른 저장소의 체크아웃에서 실행하면 Claude Code는 세션의 저장소와 체크아웃의 저장소 이름을 모두 표시하는 오류를 보여줍니다. Claude Code가 원격을 호스트 이름으로 파싱할 수 없으면(예: `git@work:owner/repo.git`과 같은 SSH 호스트 별칭), 확인을 요청하고 원격의 소유자 및 저장소 이름이 세션의 저장소와 일치할 때 체크아웃을 수락합니다. |
| 사용 가능한 브랜치 | 클라우드 세션의 브랜치를 원격으로 푸시해야 합니다. Teleport는 자동으로 가져와 체크아웃합니다. |
| 동일한 계정 | 클라우드 세션에서 사용된 동일한 claude.ai 계정으로 인증해야 합니다. |

Teleport가 세션의 브랜치를 가져올 때, fetch는 터미널에서 입력을 기다리지 않습니다. git 또는 ssh가 비밀번호, 키 암호 구문 또는 새 SSH 호스트 확인을 요청하는 경우 fetch가 실패하며, 이 경우 로컬 클론에 이미 해당 브랜치가 있을 때만 체크아웃이 작동합니다. 두 가지 SSH 경우에는 키를 `ssh-agent`에 로드하고, 먼저 `git fetch`를 한 번 직접 실행하여 호스트를 기록하십시오.

#### `--teleport`를 사용할 수 없음

Teleport는 claude.ai 구독 인증이 필요합니다. 해당하는 경우를 찾으십시오:

* **API 키 또는 Console 계정으로 로그인한 경우**: 셸에서 `claude auth login`을 실행한 다음 claude.ai로 로그인합니다
* **오류가 제공자의 이름을 표시하는 경우**: 클라우드 세션은 타사 제공자를 통해 사용할 수 없습니다. [오류 테이블](#errors-when-sending-to-a-cloud-session)을 참조하십시오
* **이미 claude.ai를 통해 로그인한 경우**: 조직이 클라우드 세션을 비활성화했을 수 있습니다

## 세션 작업

세션은 claude.ai/code의 사이드바에 나타납니다. 여기서 변경 사항을 검토하고, 팀원과 공유하고, 완료된 작업을 보관하거나, 세션을 영구적으로 삭제할 수 있습니다.

### 클라우드 세션의 권한 모드

클라우드 세션의 [권한 모드](https://code.claude.com/docs/ko/permission-modes.md)는 작업을 생성할 때와 세션이 실행되는 동안 모두 [모드 드롭다운](https://code.claude.com/docs/ko/permission-modes.md#switch-permission-modes)에서 선택합니다.

다음 중 하나를 수행하면 Claude Code는 세션이 있던 권한 모드에서 세션을 재개합니다:

* Anthropic 호스팅 [환경이 만료된](#environment-expired) 세션을 다시 열기
* 자체 호스팅 runner가 [유휴 상태일 때 해제한](https://code.claude.com/docs/ko/self-hosted-environments-reference.md#runner-cli-flags) 세션에 메시지 보내기

### 변경 사항 검토

Claude가 변경 사항을 브랜치에 푸시하면 채팅 옆 패널의 **Changes** 카드에 `+42 -18`과 같이 추가 및 제거된 줄 수가 표시됩니다. **Changes** 카드의 줄 수를 클릭하면 diff 보기가 열립니다.

* 세션 제목 표시줄 또는 표시줄의 **⋮** 메뉴에서 **Changes**를 클릭할 수도 있습니다.
* 패널이 숨겨져 있을 때 표시하려면 세션 제목 표시줄 또는 표시줄의 **⋮** 메뉴에서 **Show session rail** 아이콘을 클릭하세요.

diff 보기에서는 줄에 주석을 달고 다른 브랜치와 비교할 수 있습니다:

* **Comment**: 특정 줄에 인라인 주석을 남긴 다음, 다음 메시지와 함께 주석을 Claude에 보냅니다
* **Compare**: diff 보기는 기본적으로 세션의 변경 사항을 해당 기본 브랜치와 비교합니다. 저장소의 다른 브랜치와 비교하려면 **Compare against**를 선택하고 브랜치를 하나 고르세요

Claude Code는 이러한 diff를 raw git blob 콘텐츠에서 계산하므로 저장소에 구성된 diff 드라이버 및 `textconv` 필터는 적용되지 않습니다.

다음 단계는 다른 곳에서 다룹니다:

* **PR 생성을 포함한 전체 안내**: [검토 및 반복](https://code.claude.com/docs/ko/web-quickstart.md#review-and-iterate)을 참조하세요
* **Claude가 PR을 모니터링하여 CI 실패 및 검토 주석에 자동으로 대응하도록 하기**: [풀 리퀘스트 자동 수정](#auto-fix-pull-requests)을 참조하세요

#### diff 보기에서 누락된 파일 문제 해결

diff 보기가 기본 브랜치와 비교할 때, 세션이 변경 사항을 푸시했는지 여부와 관계없이 예상한 파일이 diff 보기의 파일 목록에서 누락될 수 있습니다:

* **아직 푸시된 변경 사항이 없는 경우**: 목록에는 Claude가 직접 수행한 편집은 포함되지만, 포매터와 같이 Claude가 실행한 명령으로 인한 변경 사항은 포함되지 않습니다
* **변경 사항이 푸시된 경우**: 목록에는 푸시된 커밋은 포함되지만, 마지막 푸시 이후에 이루어진 변경 사항은 포함되지 않습니다

누락된 변경 사항을 목록에 추가하려면 Claude에게 커밋하고 푸시하도록 요청하세요.

### 컨텍스트 관리

클라우드 세션은 텍스트 출력을 생성하는 [기본 제공 명령](https://code.claude.com/docs/ko/commands.md)을 지원합니다. `/plugin` 또는 `/resume`과 같이 터미널 인터페이스에서만 실행되는 명령은 사용할 수 없습니다. 터미널에서 선택기 또는 패널을 열어야 하는 명령은 클라우드 세션에서 다르게 작동합니다:

* **`/model`, `/effort`, `/color`, 및 `/rename`**: 터미널 선택기 또는 슬라이더를 열지 않고 대신 인수로 값을 전달합니다(예: `/model sonnet`). 인수 형식은 각 명령의 [가용성 참고 사항](https://code.claude.com/docs/ko/commands.md#all-commands)을 따릅니다.
* **`/fast`**: 빠른 모드가 [계정에서 사용 가능](https://code.claude.com/docs/ko/fast-mode.md#requirements)할 때 세션에 대해 [빠른 모드](https://code.claude.com/docs/ko/fast-mode.md#use-fast-mode-in-cloud-sessions)를 전환합니다. 세션의 환경에서 Claude Code v2.1.271 이상이 필요합니다.
* **`/config`**: 브라우저의 claude.ai/code에서는 값을 설정하는 대신 **Settings > Code** 또는 **Settings > Claude Code**를 엽니다. 클라우드 세션의 설정을 변경하려면 환경에 [환경 변수](https://code.claude.com/docs/ko/cloud-environments.md#set-environment-variables)를 설정하세요. [프로젝트](https://code.claude.com/docs/ko/claude-projects.md)의 스레드 외부에서 하나의 저장소가 있는 세션에서는 대신 해당 저장소의 `.claude/settings.json`에 키를 커밋하세요. [클라우드 세션의 설정](https://code.claude.com/docs/ko/settings.md#settings-in-cloud-sessions)에서 각 세션이 읽는 내용을 나열합니다.

[프로젝트의 스레드](https://code.claude.com/docs/ko/claude-projects.md#choose-models-and-let-claude-manage-context) 외부의 클라우드 세션에서 컨텍스트를 관리하는 방법은 다음과 같습니다:

| 명령 | 클라우드 세션에서 작동 | 참고 |
| :- | :- | :- |
| `/compact` | 예 | 대화를 요약하여 컨텍스트를 확보합니다. `/compact keep the test output`과 같은 선택적 포커스 지침을 허용합니다 |
| `/context` | 예 | 현재 컨텍스트 윈도우에 있는 것을 표시합니다 |
| `/clear` | 예 | 동일한 클라우드 세션에서 빈 컨텍스트로 새 대화를 시작합니다 |

자동 압축은 컨텍스트 윈도우가 용량에 접근할 때 자동으로 실행됩니다. 클라우드 세션은 [`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`](https://code.claude.com/docs/ko/env-vars)를 자체적으로 설정하므로 압축이 윈도우가 가득 찰 때가 아니라 [auto-compact window](https://code.claude.com/docs/ko/model-config.md#set-the-auto-compact-window)의 중간에 트리거됩니다. 해당 값은 [환경 변수](https://code.claude.com/docs/ko/cloud-environments.md#set-environment-variables)에 추가한 것을 재정의하므로 거기에 변수를 추가해도 압축이 트리거되는 시기가 변경되지 않습니다.

대신 auto-compact window를 변경하려면 환경 변수에 [`CLAUDE_CODE_AUTO_COMPACT_WINDOW`](https://code.claude.com/docs/ko/env-vars)를 설정하거나 변수가 설정되지 않은 세션에서 토큰 수와 함께 [`/autocompact`](https://code.claude.com/docs/ko/commands#all-commands)를 실행하세요.

[서브에이전트](https://code.claude.com/docs/ko/sub-agents.md)는 로컬과 동일한 방식으로 작동합니다. Claude는 Agent 도구로 이들을 생성하여 연구 또는 병렬 작업을 별도의 컨텍스트 윈도우로 오프로드하여 주 대화를 더 가볍게 유지할 수 있습니다. [프로젝트](https://code.claude.com/docs/ko/claude-projects.md#what-threads-pick-up-from-your-repositories)의 스레드 외부에서는 저장소의 `.claude/agents/`에 정의된 서브에이전트가 자동으로 로드됩니다.

[Agent teams](https://code.claude.com/docs/ko/agent-teams.md)는 기본적으로 꺼져 있지만 [환경 변수](https://code.claude.com/docs/ko/cloud-environments.md#set-environment-variables)에 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`을 추가하여 활성화할 수 있습니다.

### 대화 중 플러그인 제안

대화에 하나 이상의 [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)을 나열하고 **Add** 버튼이 있는 카드가 표시되면 Claude가 작업에 맞는 플러그인을 제안하고 있다는 의미입니다. Claude는 사용자가 요청하지 않아도 이러한 제안을 할 수 있습니다. 응답할 필요는 없으며, 어느 쪽이든 Claude는 작업을 계속 진행합니다.

#### 제안된 플러그인 추가 또는 제거

플러그인에서 **Add**를 선택하면 claude.ai 계정에서 해당 플러그인이 켜지며, 세션이 끝난 후에도 켜진 상태로 유지됩니다. 이를 취소하려면 카드에서 추가된 플러그인을 열고 **Manage**를 선택하여 claude.ai의 플러그인 페이지로 이동한 다음, 해당 페이지에서 플러그인을 제거하세요.

#### 플러그인 제안 끄기

Claude가 플러그인을 제안하지 않도록 하려면 [권한 규칙](https://code.claude.com/docs/ko/permissions.md#manage-permissions)으로 `SearchPlugins` 및 `SuggestPluginInstall` 도구를 거부하세요. [프로젝트](https://code.claude.com/docs/ko/claude-projects.md) 외부에서 하나의 저장소가 있는 세션에서는 해당 저장소의 `.claude/settings.json`에 규칙을 커밋하고, `permissions.deny` 아래에 두 도구 이름을 모두 나열하세요:

```json theme={null}
{
  "permissions": {
    "deny": ["SearchPlugins", "SuggestPluginInstall"]
  }
}
```

세션에 적용되는 [관리형 설정](https://code.claude.com/docs/ko/managed-settings.md)이 [`allowManagedPermissionRulesOnly`](https://code.claude.com/docs/ko/settings-reference#allowmanagedpermissionrulesonly)를 설정하는 경우, Claude Code는 이러한 거부 규칙을 포함하여 저장소의 `.claude/settings.json`에 있는 권한 규칙을 무시합니다. 이 경우 대신 해당 관리형 설정에 규칙을 넣으세요. 여러 저장소가 있는 세션이나 프로젝트의 클라우드 스레드와 같은 다른 구성의 경우 [클라우드 세션에 적용되는 설정](https://code.claude.com/docs/ko/settings.md#settings-in-cloud-sessions)을 참조하세요.

### 대기 중인 메시지 되돌리기

Claude가 작업 중일 때 메시지를 보내면 Claude가 읽을 때까지 메시지가 대기합니다. 대기 중인 메시지를 되돌리려면 메시지의 ✕를 클릭하세요. 텍스트가 메시지 상자로 돌아가므로 편집하거나 다른 내용을 보낼 수 있습니다.

Claude가 이미 메시지를 읽었다면 메시지는 대화에 남아 있습니다.

### 세션 공유

세션을 공유하려면 아래 계정 유형에 따라 가시성을 전환하세요. 그 후 세션 링크를 그대로 공유합니다. 수신자는 링크를 열 때 최신 상태를 보지만 보기가 실시간으로 업데이트되지 않습니다.

#### Enterprise 또는 Team 계정에서 공유

Enterprise 및 Team 계정의 공유는 다음과 같이 작동합니다:

* **가시성 옵션**: **Private** 및 **Team**. Team 가시성은 claude.ai 조직의 다른 구성원에게 세션을 표시합니다
* **저장소 액세스**: 수신자의 계정에 연결된 GitHub 계정을 기반으로 확인이 기본적으로 활성화됩니다
* **사용자 이름**: 계정의 표시 이름은 액세스 권한이 있는 모든 수신자에게 표시됩니다
* **Slack 세션**: [Claude in Slack](https://code.claude.com/docs/ko/slack.md) 세션은 자동으로 Team 가시성으로 공유됩니다

#### Max, Ultra 또는 Pro 계정에서 공유

* **가시성 옵션**: **Private** 및 **Public**. Public 가시성은 claude.ai에 로그인한 모든 사용자에게 세션을 표시합니다
* **저장소 액세스**: 확인은 기본적으로 활성화되지 않습니다
* **민감한 내용**: 공유하기 전에 세션을 확인하세요. 세션에는 개인 GitHub 저장소의 코드 및 자격 증명이 포함될 수 있습니다

수신자에게 저장소 액세스를 요구하거나 공유 세션에서 이름을 숨기려면 claude.ai에서 Settings를 연 다음 다음과 같이 진행하세요:

* **Settings 메뉴에 Claude Code 대신 Code가 표시되는 경우**: 이러한 설정이 있는 [**Privacy**](https://claude.ai/settings/data-privacy-controls)로 이동하세요
* **그 외의 경우**: [**Claude Code > Sharing settings**](https://claude.ai/settings/claude-code)로 이동하세요

### 세션 보관

세션을 보관하면 사이드바의 세션 목록에서 제거됩니다. 세션을 보관하려면 사이드바에서 세션 위에 마우스를 올리고 **⋯** 메뉴를 열어 **Archive**를 선택하세요.

#### 보관된 세션 찾기

보관된 세션을 보려면 [claude.ai/code/sessions](https://claude.ai/code/sessions)로 이동하여 **Archived** 탭을 여세요. 세션을 사이드바의 세션 목록으로 되돌리려면 해당 탭에서 세션 위에 마우스를 올리고 **⋮** 메뉴를 열어 **Unarchive**를 선택하세요.

### 세션 삭제

세션을 삭제하면 세션과 해당 데이터가 영구적으로 제거됩니다. 이 작업은 실행 취소할 수 없습니다. 사이드바, 세션 메뉴 또는 이미 보관한 경우 **Archived** 탭에서 세션을 삭제할 수 있습니다:

* **사이드바에서**: 세션 위에 마우스를 올리고 **⋯** 메뉴를 열어 **Delete**를 선택합니다
* **세션 메뉴에서**: 세션을 열고 세션 제목 옆의 드롭다운을 선택한 다음 **Delete**를 선택합니다
* **Archived 탭에서**: [**Archived** 탭](#find-an-archived-session)에서 세션 위에 마우스를 올리고 **⋮** 메뉴를 열어 **Delete**를 선택합니다

세션이 삭제되기 전에 확인하라는 메시지가 표시됩니다.

## Pull request 자동 수정

Claude는 pull request를 감시하고 CI 실패 및 검토 주석에 자동으로 응답할 수 있습니다. Claude는 PR의 GitHub 활동을 구독하고, 검사가 실패하거나 검토자가 주석을 남기면 Claude가 조사하고 명확한 수정이 있으면 푸시합니다.

> [!NOTE]
>
> 자동 수정을 위해서는 Claude GitHub App이 저장소에 설치되어야 합니다. 아직 설치하지 않았으면 [GitHub App 페이지](https://github.com/apps/claude)에서 설치하세요.

PR이 어디에서 왔는지와 어떤 기기를 사용하는지에 따라 자동 수정을 켜는 방법은 몇 가지가 있습니다:

* **클라우드 세션에서 생성된 PR**: claude.ai/code에서 세션을 열고 [**Changes** 카드](#review-changes)에서 풀 리퀘스트를 찾습니다. 풀 리퀘스트 제목 옆의 **⋮** 메뉴를 열고 **Auto-fix**를 켭니다
* **터미널에서**: PR의 분기에 있는 동안 [`/autofix-pr`](https://code.claude.com/docs/ko/commands)을 실행합니다. Claude Code가 `gh`로 열린 PR을 감지하고, 클라우드 세션을 생성하고, 한 단계에서 자동 수정을 켭니다
* **모바일 앱에서**: Claude에 PR을 자동 수정하도록 지시합니다. 예를 들어 "watch this PR and fix any CI failures or review comments"
* **기존 PR**: PR URL을 세션에 붙여넣고 Claude에 자동 수정하도록 지시합니다

모니터링을 중지하려면 세션의 [**Changes** 카드](#review-changes)에서 풀 리퀘스트의 **⋮** 메뉴에 있는 **Auto-fix**를 끄거나, Claude에 PR 감시를 중지하도록 지시합니다.

### Claude가 PR 활동에 응답하는 방식

자동 수정이 활성화되면 Claude는 새 검토 주석 및 CI 검사 실패를 포함한 PR의 GitHub 이벤트를 수신합니다. 각 이벤트에 대해 Claude는 조사하고 진행 방식을 결정합니다:

* **명확한 수정**: Claude가 수정에 확신하고 이전 지침과 충돌하지 않으면 Claude가 변경을 수행하고, 푸시하고, 세션에서 수행한 작업을 설명합니다
* **모호한 요청**: 검토자의 주석을 여러 방식으로 해석할 수 있거나 아키텍처적으로 중요한 사항이 포함되면 Claude가 행동하기 전에 확인합니다
* **중복 또는 조치 불필요 이벤트**: 이벤트가 중복이거나 변경이 필요 없으면 Claude가 세션에서 이를 기록하고 계속합니다

GitHub는 기본 분기가 진행되고 병합 충돌이 생성될 때 웹훅을 내보내지 않으므로 자동 수정은 충돌에 자체적으로 반응할 수 없습니다. 충돌을 해결하려면 세션을 열고 Claude에 리베이스하도록 요청합니다.

Claude는 GitHub의 검토 주석 스레드에 회신할 수 있습니다. 이러한 회신은 GitHub 계정을 사용하여 게시되므로 사용자 이름 아래에 나타나지만 각 회신은 Claude Code에서 온 것으로 표시되어 검토자가 에이전트에 의해 작성되었으며 직접 작성되지 않았음을 알 수 있습니다.

> [!WARNING]
>
> 저장소가 Atlantis, Terraform Cloud 또는 `issue_comment` 이벤트에서 실행되는 사용자 정의 GitHub Actions와 같은 주석 트리거 자동화를 사용하는 경우 Claude의 회신이 해당 워크플로우를 트리거할 수 있음을 알아두세요. 자동 수정을 활성화하기 전에 저장소의 자동화를 검토하고 PR 주석이 인프라를 배포하거나 권한 있는 작업을 실행할 수 있는 저장소에서는 자동 수정을 비활성화하는 것을 고려하세요.

## 보안 및 격리

각 클라우드 세션은 여러 계층을 통해 머신과 다른 세션으로부터 분리됩니다:

* **격리된 가상 머신**: 각 세션은 격리된 Anthropic 관리 VM에서 실행됩니다. 조직이 [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)으로 라우팅하는 세션은 자신의 인프라에서 실행되며, 격리는 배포의 책임입니다
* **네트워크 액세스 제어**: Anthropic 호스팅 환경에서 네트워크 액세스는 기본적으로 제한되며 비활성화할 수 있습니다. 액세스 수준, [기본 허용 도메인](https://code.claude.com/docs/ko/cloud-environments.md#default-allowed-domains), 그리고 허용 목록을 통과하지 않는 트래픽에 대해서는 [네트워크 액세스](https://code.claude.com/docs/ko/cloud-environments.md#network-access)를 참조하세요. 자체 호스팅 환경에서는 자신의 네트워크 경계에서 세션 송신을 제한합니다. 네트워크 액세스가 비활성화된 상태에서 실행할 때 Claude Code는 여전히 Anthropic API와 통신할 수 있으며, 이는 VM에서 데이터가 나갈 수 있습니다.
* **자격 증명 보호**: Anthropic 호스팅 환경에서 git 자격 증명 및 서명 키는 샌드박스 외부에 유지되며, 프록시는 범위 자격 증명으로 세션을 대신하여 인증합니다. 자체 호스팅 환경에서 배포는 git 자격 증명을 제공합니다. [git 구성](https://code.claude.com/docs/ko/self-hosted-environments-deploy.md#configure-git)을 참조하세요
* **네트워크 시크릿**: Anthropic 호스팅 환경에서 [클라우드 환경에 추가한](https://code.claude.com/docs/ko/cloud-environments.md#add-network-secrets) 키는 샌드박스 외부에 동일한 방식으로 유지되며, 세션을 떠난 후 일치하는 요청에 첨부됩니다. 자체 호스팅 환경에는 네트워크 시크릿이 없습니다
* **안전한 분석**: 코드는 PR을 생성하기 전에 세션의 격리된 환경 내에서 분석 및 수정됩니다

## 문제 해결

대화에 나타나는 `API Error: 500`, `529 Overloaded`, `429`, `Prompt is too long` 같은 런타임 API 오류는 [오류 참조](https://code.claude.com/docs/ko/errors.md)를 참고하십시오. 이러한 오류와 해결 방법은 CLI 및 Desktop 앱과 공통입니다. 아래 섹션에서는 클라우드 세션에만 해당하는 문제를 다룹니다.

### Session creation failed

새 세션을 시작하려 할 때 `Session creation failed` 오류가 발생하며 실패하거나 프로비저닝 단계에서 멈춘다면, Claude Code가 세션에 VM을 할당하지 못한 것입니다.

* [status.claude.com](https://status.claude.com)에서 클라우드 세션 관련 장애를 확인합니다
* 용량은 필요할 때 프로비저닝되므로 1분 후에 재시도합니다
* [GitHub 연결 후 저장소가 표시되지 않음](https://code.claude.com/docs/ko/web-quickstart.md#no-repositories-appear-after-connecting-github)의 안내에 따라 GitHub 연결이 저장소에 접근할 수 있는지 확인합니다

### Your new session couldn't start

프롬프트는 보냈던 입력란에 다시 채워져 있습니다.

* **연결 끊김**: 인터넷 연결과 사용 중인 VPN 또는 프록시를 확인한 다음 프롬프트를 다시 보냅니다
* **서버 오류**: 잠시 기다린 다음 프롬프트를 다시 보냅니다. 알림이 다시 나타나면 [status.claude.com](https://status.claude.com)을 확인합니다

### Can't rewind to this message

v2.1.246 이전 Claude Code를 사용하는 [자체 호스팅 러너](https://code.claude.com/docs/ko/self-hosted-environments)에서 세션이 실행되는 경우, 가장 최근 메시지를 제외한 모든 메시지에서 **Rewind to here**가 이 오류와 함께 실패합니다. 조직의 러너를 운영하는 담당자에게 [러너 업그레이드](https://code.claude.com/docs/ko/self-hosted-environments-deploy.md#pin-the-version)를 요청하십시오.

### Unable to get organization UUID

`claude --cloud` 및 `claude --teleport`를 사용하려면 claude.ai 계정으로 로그인해야 합니다. 대신 API 키나 Console 로그인으로 인증하거나 저장된 계정 정보가 오래된 경우 다음과 같은 메시지가 표시됩니다.

* `Unable to get organization UUID`
* ``Cloud sessions need a claude.ai sign-in. Run `claude auth login` (or /login in a local session), then try again.``
* ``Cloud sessions aren't available with this Console sign-in. They need a claude.ai sign-in. Run `claude auth login` (or /login in a local session), then try again.``
* 세션 ID 없이 `claude --teleport`를 실행할 때 세션 선택기에 표시되는 `Error loading Claude Code sessions`

셸에서 [`claude auth login`](https://code.claude.com/docs/ko/cli-reference#cli-commands)을 실행하여 claude.ai 계정으로 로그인한 다음 명령을 재시도합니다. 실행 중인 세션 안에서는 `/login`이 같은 역할을 합니다. 오류에 공급자 이름이 표시된다면 [오류 표](#errors-when-sending-to-a-cloud-session)를 참고하십시오. 클라우드 세션은 서드파티 공급자를 통해서는 사용할 수 없습니다.

v2.1.274부터 v2.1.289까지는 로그인 메시지가 `Claude Code cloud sessions require authentication with a Claude.ai account. API key authentication is not sufficient. Please run /login to authenticate, or check your authentication status with /status.`로 표시되었습니다.

### 브랜치가 GitHub에 없음

`claude --cloud`가 `Branch <name> is not on GitHub`로 시작하는 줄을 출력하면 클라우드 세션은 여전히 시작되지만, 사용자의 브랜치에서 시작되지는 않습니다. 이 줄에는 세션이 대신 시작되는 위치가 표시됩니다. 즉, 브랜치 기록 중 푸시된 커밋이나 저장소의 기본 브랜치입니다. 로컬 컴퓨터에만 있는 커밋과 커밋되지 않은 변경 사항은 세션에 포함되지 않습니다.

예를 들어 브랜치를 한 번도 푸시하지 않았거나, 풀 리퀘스트가 병합된 후 GitHub에서 브랜치가 삭제된 경우 이 줄이 표시됩니다. 이 줄에 표시된 시작 지점에 작업에 필요한 내용이 있다면 세션을 그대로 사용합니다. 그렇지 않다면 브랜치를 푸시하고 새 세션을 시작하여 해당 브랜치를 클론하도록 합니다.

### Remote Control 세션 만료 또는 접근 거부

`--teleport`는 클라우드 세션이 사용하는 것과 동일한 Remote Control 세션 인프라를 통해 연결되므로, 인증 및 세션 만료 오류가 Remote Control 문구로 표시됩니다. `Remote Control session expired` 또는 `Access denied`가 표시될 수 있습니다. 연결 토큰은 수명이 짧으며 사용자의 계정으로 범위가 제한됩니다.

* 로컬에서 `/login`을 실행하여 자격 증명을 갱신한 다음 다시 연결합니다
* 세션을 소유한 계정과 동일한 계정으로 로그인했는지 확인합니다
* `Remote Control may not be available for this organization`이 표시되면 Owner가 조직에서 클라우드 세션을 활성화하지 않은 것입니다

### 클라우드 세션으로 보낼 때 발생하는 오류

이 오류는 `-p` 사용 여부와 관계없이 [`--cloud <session-id>`](#send-follow-ups-from-the-cli)와 함께 `claude`를 실행할 때 발생합니다. CLI는 오류 앞에 `Error: `를 붙입니다. 전송에 실패하면 `failed to send message to cloud session <id>: <reason>` 형식으로 감싸서 표시됩니다.

| 메시지 | 의미 |
| - | - |
| `Cloud sessions aren't available with <provider>. They run on Anthropic's infrastructure and require an Anthropic account.` | Claude Code가 서드파티 공급자를 사용하도록 구성되어 있습니다. 메시지에는 `Amazon Bedrock` 또는 `Google Vertex AI`처럼 구성에서 사용하는 레이블로 공급자 이름이 표시됩니다. 예를 들어 `CLAUDE_CODE_USE_BEDROCK`의 설정을 해제하여 해당 공급자의 구성을 제거하고, Anthropic 계정으로 로그인합니다(`claude auth login`). |
| `Cloud sessions are disabled by your organization's policy. Contact your organization admin to enable them.` | 조직의 `allow_remote_sessions` 정책이 꺼져 있습니다. [Cloud sessions are disabled by your organization's policy](https://code.claude.com/docs/ko/errors.md#cloud-sessions-are-disabled-by-your-organizations-policy)를 참고하십시오. 메시지에 이 세션에서 사용 중인 자격 증명이 대신 표시된다면 [클라우드 세션은 claude.ai 로그인을 사용합니다](https://code.claude.com/docs/ko/errors.md#cloud-sessions-use-your-claude-ai-login)를 참고하십시오. |
| `Couldn't verify your organization's policy for cloud sessions. Check your network connection and try again.` | Claude Code가 조직의 정책을 아직 다 불러오지 못했으므로, 클라우드 세션이 허용된다고 가정하는 대신 전송을 거부합니다. 네트워크 연결을 확인하고 재시도합니다. |
| `Cloud sessions aren't available:` 뒤에 원인이 이어짐 | 조직의 정책을 불러오는 데 실패했으며, 메시지의 나머지 부분에 실패 원인이 나와 있습니다. 표시된 원인에 따라 조치하십시오. [Couldn't verify your organization's policy for cloud sessions](https://code.claude.com/docs/ko/errors.md#couldnt-verify-your-organizations-policy-for-cloud-sessions)를 참고하십시오. |
| `Attaching to an existing cloud session is not enabled for your account.` | `-p` 없이 `--cloud <session-id>`를 실행했습니다. `claude -p "your message" --cloud <session-id>`로 메시지를 보내십시오. |
| `Session not found: <id>` | ID 또는 URL이 사용자가 접근할 수 있는 세션과 일치하지 않습니다. 세션의 claude.ai/code URL과 대조하여 확인하십시오. |
| `cloud session <id> is archived and cannot accept new messages` | 세션이 보관되었습니다. 대신 새 세션을 시작하십시오. |

### 환경 만료

클라우드 세션은 일정 시간 동안 활동이 없으면 중지되며 세션의 VM이 회수됩니다. 세션이 [MCP 커넥터](https://code.claude.com/docs/ko/cloud-environments.md#network-access) 도구 호출 승인이나 MCP 서버 로그인을 기다리는 동안에도 비활성 상태로 간주되므로, 대기 중에 만료될 수 있습니다.

[claude.ai/code](https://claude.ai/code)에서 세션을 다시 열면 새 VM이 프로비저닝됩니다.

* **복원됨**: 대화 기록
* **복원되지 않음**: VM이 회수될 때 아직 실행 중이거나 대기 중이던 백그라운드 작업으로, 다음이 포함됩니다.
  * **셸 명령**: Claude Code가 어떤 명령이 중지되었는지 Claude에게 알려 줍니다. 여전히 필요한 명령을 다시 실행하도록 Claude에게 요청합니다.
  * **서브에이전트**: Claude Code가 어떤 서브에이전트가 중지되었는지, 그리고 그중 어떤 서브에이전트를 처음부터 다시 시작하는 대신 [재개](https://code.claude.com/docs/ko/sub-agents.md#resume-subagents)할 수 있는지 Claude에게 알려 줍니다. 작업을 계속하도록 Claude에게 요청합니다.
  * **세션 범위 예약 작업**: [세션에서 예약한](https://code.claude.com/docs/ko/scheduled-tasks.md) 작업과 다음 반복을 기다리던 `/loop`는 다시 연 세션으로 이어지지 않습니다. 작업을 다시 예약하도록 Claude에게 요청하거나, `/loop`를 다시 실행하여 루프를 다시 시작합니다.

## 제한 사항

클라우드 세션을 워크플로우에 사용하기 전에 다음 제약 사항을 고려하십시오:

* **속도 제한**: 클라우드 세션은 계정 내의 다른 모든 Claude 및 Claude Code 사용과 속도 제한을 공유합니다. 여러 작업을 병렬로 실행하면 비례적으로 더 많은 속도 제한을 소비합니다.
* **시간 제한**: Claude가 실행하는 명령 및 SessionStart 훅에는 변경할 수 있는 기본 시간 초과가 있으며, 설정 스크립트는 대략 5분 내에 완료될 때만 캐시됩니다. [시간 제한](https://code.claude.com/docs/ko/cloud-environments.md#time-limits)을 참조하십시오.
* **저장소 인증**: 동일한 계정으로 인증된 경우에만 클라우드 세션을 터미널로 가져올 수 있습니다.
* **플랫폼 제한**: Anthropic 호스팅 환경에서의 저장소 복제 및 풀 리퀘스트 생성에는 GitHub이 필요합니다. 자체 호스팅 [GitHub Enterprise Server](https://code.claude.com/docs/ko/github-enterprise-server.md) 인스턴스는 Team 및 Enterprise 플랜에서 지원됩니다. `CCR_FORCE_BUNDLE=1`을 설정하여 GitLab, Bitbucket 또는 기타 비-GitHub 저장소를 [로컬 번들](#send-local-repositories-without-github)로 클라우드 세션에 전송할 수 있지만, 세션은 결과를 원격으로 다시 푸시할 수 없습니다.
  * **자체 호스팅 환경**: 다른 git 호스트에 있는 저장소의 경우 [`--environment`로 세션을 시작하기 위한 요구 사항](https://code.claude.com/docs/ko/self-hosted-environments-deploy#start-a-session-on-a-repository-outside-github)을 참조하십시오.
* **조직 IP 허용 목록**: 클라우드 세션은 사용자의 네트워크가 아닌 Anthropic 관리 인프라에서 Anthropic API를 호출하는 반면, [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)의 세션은 사용자의 네트워크에서 호출합니다. 조직에 [IP 허용 목록](https://support.claude.com/en/articles/13200993-restrict-access-to-claude-with-ip-allowlisting)이 활성화되어 있으면 모든 Anthropic 호스팅 클라우드 세션이 인증 오류로 실패합니다.
  * **Code Review 및 예약 작업**: 이는 [Code Review](https://code.claude.com/docs/ko/code-review.md) 및 Anthropic 호스팅 환경에서 실행되는 [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md)에도 동일하게 적용됩니다. 자체 호스팅 환경으로 라우팅된 예약 작업은 사용자의 네트워크에서 API를 호출합니다.
  * **예외 적용 받기**: [Anthropic 지원](https://support.claude.com/)에 문의하여 조직의 IP 허용 목록에서 Anthropic 호스팅 서비스를 제외하십시오.

## 관련 리소스

* [클라우드 환경](https://code.claude.com/docs/ko/cloud-environments.md): 클라우드 세션의 네트워크 액세스, 환경 변수 및 설정 스크립트 구성
* [Projects](https://code.claude.com/docs/ko/claude-projects.md): Claude가 리포지토리에서 병렬 클라우드 세션을 조정하고 결과를 보고하는 하나의 대화
* [Ultrareview](https://code.claude.com/docs/ko/ultrareview.md): 클라우드 샌드박스에서 심층 다중 에이전트 코드 검토 실행
* [클라우드 예약 작업](https://code.claude.com/docs/ko/routines.md): 일정에 따라, API 호출을 통해 또는 GitHub 이벤트에 응답하여 작업 자동화
* [Hooks 구성](https://code.claude.com/docs/ko/hooks.md): 세션 수명 주기 이벤트에서 스크립트 실행
* [모든 설정](https://code.claude.com/docs/ko/settings-reference.md): 모든 구성 옵션
* [보안](https://code.claude.com/docs/ko/security.md): 격리 보장 및 데이터 처리
* [데이터 사용](https://code.claude.com/docs/ko/data-usage.md): Anthropic이 클라우드 세션에서 보유하는 것
* [Claude Tag](https://claude.com/docs/claude-tag/overview): 동일한 클라우드 인프라에서 실행되는 조직 관리형 Slack의 @Claude
