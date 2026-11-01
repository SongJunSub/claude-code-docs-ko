> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Claude Code GitHub Actions

> @claude 멘션에 응답하고, 작업을 자동화하고, 이슈를 풀 리퀘스트로 변환하기 위해 GitHub Actions 워크플로우에서 Claude Code를 실행합니다

[Claude Code GitHub Actions](https://github.com/anthropics/claude-code-action)는 저장소의 워크플로우 내에서 Claude Code를 실행하는 GitHub Action입니다. 풀 리퀘스트나 이슈 댓글에서 `@claude`를 멘션하여 Claude가 코드를 분석하고, 변경 사항을 구현하고, 커밋을 푸시하도록 합니다. Claude Code GitHub Action에 프롬프트를 제공하여 모든 GitHub 이벤트에서 자동으로 실행되도록 할 수도 있습니다. 이슈를 풀 리퀘스트로 변환하거나, 댓글에서 버그를 수정하거나, 반복되는 작업을 자동화하는 데 사용합니다.

여러 제품이 Claude Code 이름을 공유합니다. 이 페이지는 저장소의 워크플로우 파일로 구성하는 `claude-code-action` 워크플로우 통합을 다룹니다. 관련 제품의 경우 다음을 참조하십시오:

* [Code Review](https://code.claude.com/docs/ko/code-review.md): 워크플로우를 작성하지 않고 모든 풀 리퀘스트에서 자동 리뷰
* [클라우드의 Claude Code](https://code.claude.com/docs/ko/claude-code-on-the-web.md): 클라우드 인프라에서 실행되는 Claude Code 세션
* [Claude Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md): GitHub Actions 외부의 사용자 정의 자동화. Claude Code GitHub Action은 SDK를 기반으로 구축됩니다
* [GitHub Enterprise Server](https://code.claude.com/docs/ko/github-enterprise-server.md): 자체 호스팅 GitHub를 사용한 Claude Code

## 설정

Claude Code GitHub Action은 다음 두 가지 방법 중 하나로 설정할 수 있습니다.

* **빠른 설정**: Claude Code에서 `/install-github-app`을 실행합니다. Claude Code가 GitHub App을 설치하고, 인증 시크릿을 추가하고, 워크플로 풀 리퀘스트를 준비합니다
* **수동 설정**: 앱을 설치하고, 시크릿을 추가하고, 워크플로 파일을 저장소에 직접 복사합니다. 로컬에서 Claude Code를 실행하지 않는 경우, 명령이 실패하는 경우, 또는 워크플로 파일을 완전히 제어하려는 경우에 이 방법을 사용합니다

어느 방법이든 저장소에 대한 관리자 액세스 권한이 필요합니다.

### 빠른 설정

`/install-github-app`은 github.com 저장소에서만 작동합니다. 저장소의 git remote가 gitlab.com 또는 bitbucket.org에 있는 경우, 이 명령은 설정을 시작하는 대신 안내 메시지를 출력하고 종료됩니다. GitLab 파이프라인에서 Claude Code를 실행하려면 [Claude Code GitLab CI/CD](https://code.claude.com/docs/ko/gitlab-ci-cd.md)를 참조하세요.

시작하기 전에 [GitHub CLI](https://cli.github.com)를 설치하고 `gh auth login`으로 인증합니다. Claude Code는 GitHub CLI가 있는지 확인하고, 없으면 경고를 표시합니다.

연결하려는 저장소에서 `claude`를 열고 `/install-github-app`을 실행한 다음 안내를 따릅니다. Claude Code는 Claude GitHub App을 설치한 다음 워크플로용 인증 시크릿을 설정합니다.

* Claude Code에 이미 API 키가 있으면 해당 키를 재사용하며, 저장소에 `ANTHROPIC_API_KEY` 시크릿이 이미 설정되어 있으면 이를 유지할지 묻습니다
* 그렇지 않으면 Claude 구독으로 장기 토큰을 생성할지, API 키를 붙여 넣을지 선택합니다

Claude Code는 자격 증명을 저장소 시크릿으로 저장하며, API 키의 경우 `ANTHROPIC_API_KEY`, 구독 토큰의 경우 `CLAUDE_CODE_OAUTH_TOKEN`이라는 이름을 사용합니다.

그런 다음 Claude Code는 선택한 워크플로 파일이 포함된 브랜치를 푸시하고(해당 시크릿을 사용하도록 이미 설정됨), 풀 리퀘스트를 생성할 준비가 된 상태로 브라우저에서 GitHub를 엽니다. 해당 풀 리퀘스트를 생성하고 병합하면 저장소에서 `@claude`가 작동합니다.

설정 도중에 중단하려면 Esc를 누릅니다. 이미 진행 중인 단계는 완료되고, 이후 단계는 시작되지 않습니다. 종료 메시지에는 푸시된 브랜치나 저장된 시크릿 등 저장소에서 이미 수행된 작업이 나열됩니다.

리뷰 워크플로를 선택하면 Claude는 각 리뷰를 풀 리퀘스트 자체에 게시합니다. 발견한 각 이슈에 대해 인라인 코멘트로 게시하거나, 아무것도 발견하지 못한 경우 하나의 요약 코멘트로 게시합니다. Claude는 초안 등 일부 풀 리퀘스트를 건너뜁니다. [리뷰 워크플로 예제](#run-a-skill)는 동일한 스킬을 사용하며 해당 풀 리퀘스트 유형을 나열합니다. v2.1.229 이전에는 Claude가 리뷰를 워크플로 실행 로그에만 기록했습니다.

이전 버전에서 생성된 리뷰 워크플로를 업데이트하려면 다음 중 하나를 수행합니다.

* `/install-github-app`을 다시 실행합니다. 저장소에 이미 `claude.yml`이 있으면 **Update workflow file with latest version**을 선택합니다. Claude Code는 최초 설치와 마찬가지로 워크플로 파일의 새 사본을 새 브랜치에 푸시하고 풀 리퀘스트를 엽니다.
* [리뷰 워크플로 예제](#run-a-skill)의 `--comment` 인수와 `claude_args` 줄을 체크인된 파일에 직접 추가합니다. 이 방법을 사용하면 파일에 적용한 다른 수정 사항이 유지됩니다.

GitHub App을 설치한 후 Claude Code는 GitHub Actions 설정을 계속할지 묻습니다. GitHub App만 설치된 상태로 중단하려면 **Skip for now**를 선택합니다. 나중에 `/install-github-app`을 다시 실행하여 워크플로 및 시크릿 단계를 완료할 수 있습니다.

> [!NOTE]
>
> * GitHub App을 설치하면 여러 권한을 부여하게 됩니다. 전체 권한 목록은 [GitHub App 권한](#github-app-permissions)을 참조하세요
> * 빠른 설정은 Claude API 및 Claude 구독과 함께 작동합니다. Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry를 사용하는 경우 [클라우드 제공업체와 함께 Claude Code GitHub Actions 사용하기](https://code.claude.com/docs/ko/github-actions-cloud-providers.md)를 참조하세요

### 수동 설정

`/install-github-app`을 실행하지 않고 Claude Code GitHub Action을 구성하려면 앱을 설치하고, 시크릿을 추가하고, 워크플로 파일을 직접 복사합니다.

**1. Claude GitHub App 설치**

저장소에 [Claude GitHub App](https://github.com/apps/claude)을 설치합니다. Claude Code GitHub Action은 앱의 다음 세 가지 권한을 사용합니다.

* **Contents**: 읽기 및 쓰기. Claude가 저장소 파일을 수정할 수 있습니다
* **Issues**: 읽기 및 쓰기. Claude가 이슈에 응답할 수 있습니다
* **Pull requests**: 읽기 및 쓰기. Claude가 PR을 생성하고 변경 사항을 푸시할 수 있습니다

설치 중에는 다른 Claude 기능에서 사용하는 권한도 부여하게 됩니다. 전체 권한 목록은 [GitHub App 권한](#github-app-permissions)을 참조하세요.

**2. 인증 시크릿 추가**

인증 방식에 따라 다음 시크릿 중 하나를 저장소에 추가합니다. GitHub의 [GitHub Actions에서 시크릿 사용하기](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) 가이드를 참조하세요.

* `ANTHROPIC_API_KEY`: [Claude Console](https://platform.claude.com)에서 발급한 Claude API 키
* `CLAUDE_CODE_OAUTH_TOKEN`: Claude 구독으로 인증하는 OAuth 토큰으로, Pro, Max, Ultra, Team, Enterprise 플랜에서 사용할 수 있습니다. 로컬에서 `claude setup-token`을 실행하여 생성합니다. [장기 토큰 생성하기](https://code.claude.com/docs/ko/authentication.md#generate-a-long-lived-token)를 참조하세요

워크플로 파일에서는 시크릿을 해당 입력에 전달합니다. API 키는 `anthropic_api_key`에, OAuth 토큰은 `claude_code_oauth_token`에 전달합니다.

**3. 워크플로 파일 복사**

[examples/claude.yml](https://github.com/anthropics/claude-code-action/blob/main/examples/claude.yml)을 저장소의 `.github/workflows/` 디렉터리에 복사합니다. 이 파일은 단순한 예제가 아니라 실제로 작동하는 워크플로입니다. 커밋된 그대로 사용하면, 누군가 이슈나 풀 리퀘스트에서 `@claude`를 멘션할 때마다 Claude가 `ANTHROPIC_API_KEY` 시크릿으로 인증하여 응답합니다. 대신 `CLAUDE_CODE_OAUTH_TOKEN`을 추가했다면 워크플로의 `anthropic_api_key` 줄을 `claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}`으로 변경합니다.

> [!TIP]
>
> 설정 후 이슈 또는 PR 코멘트에서 `@claude`를 태그하여 Claude Code GitHub Action을 테스트합니다.

### 조직 단위로 설정하기

빠른 설정이나 수동 설정에서는 한 번에 하나의 저장소를 구성합니다. 조직 전체에 Claude Code GitHub Action을 배포하려면 다음을 수행합니다.

* 조직 수준에서 [Claude GitHub App](https://github.com/apps/claude)을 한 번 설치하고, 모든 저장소 또는 선택한 저장소 목록을 지정합니다
* 각 저장소에 별도의 사본이 필요하지 않도록 인증 시크릿을 조직 수준 Actions 시크릿으로 저장합니다
* Claude Code GitHub Action을 실행할 각 저장소에 워크플로 파일을 추가하거나, 각 저장소가 호출하는 [재사용 가능한 워크플로](https://docs.github.com/en/actions/using-workflows/reusing-workflows)로 작업을 한 번 정의합니다

여러 저장소에서 공유하는 시크릿에는 OAuth 토큰 대신 [Claude Console](https://platform.claude.com)의 API 키로 인증합니다. OAuth 토큰은 `claude setup-token`을 실행한 사람의 구독에 연결되기 때문입니다.

장기 시크릿을 아예 저장하지 않으려면 워크로드 ID 페더레이션을 통해 인증합니다. 이 방식에서는 Claude Code GitHub Action이 워크플로의 GitHub OpenID Connect(OIDC) 토큰을 Claude Console 서비스 계정을 통해 Claude API 액세스로 교환합니다. 다음 입력을 설정합니다.

* `anthropic_federation_rule_id`: 페더레이션 규칙 ID, `fdrl_...`
* `anthropic_organization_id`: Anthropic 조직 ID
* `anthropic_service_account_id`: 서비스 계정 ID, `svac_...`. Console에서 생성하는 페더레이션 규칙이 이미 서비스 계정을 대상으로 하므로 선택 사항입니다
* `anthropic_workspace_id`: 워크스페이스 ID, `wrkspc_...`. 페더레이션 규칙이 단일 워크스페이스를 대상으로 하는 경우 선택 사항입니다

워크플로에 `id-token: write` 권한을 부여합니다. 자체 `github_token`을 전달하는 경우에도 Claude Code GitHub Action은 페더레이션 교환에 이 권한이 필요합니다. Console 측 구성은 [Claude Code GitHub Action 설정 가이드](https://github.com/anthropics/claude-code-action/blob/main/docs/setup.md)를 참조하세요.

보안 검토에서 데이터 처리 및 보존에 관한 질문은 [데이터 사용](https://code.claude.com/docs/ko/data-usage.md) 및 [보안](https://code.claude.com/docs/ko/security.md)을 참조하세요.

### 제거

Claude Code GitHub Action을 제거하려면 설치 환경에 해당하는 각 설정 요소를 되돌립니다.

* **워크플로 파일**: `.github/workflows/`에서 `anthropics/claude-code-action`을 사용하는 워크플로를 삭제합니다. 빠른 설정을 사용했다면 `claude.yml`을 찾고, 리뷰 워크플로를 선택했다면 `claude-code-review.yml`도 찾습니다. 워크플로를 삭제하면 Claude Code GitHub Action이 더 이상 실행되지 않습니다
* **시크릿**: 저장소에서 `ANTHROPIC_API_KEY` 또는 `CLAUDE_CODE_OAUTH_TOKEN` 시크릿을 삭제하고, [여러 저장소에서 공유](#set-up-for-an-organization)한 경우 조직 수준 Actions 시크릿에서도 삭제합니다. 시크릿을 삭제해도 그 안에 있던 자격 증명은 유효한 상태로 남습니다. API 키를 완전히 폐기하려면 [Claude Console](https://platform.claude.com)에서도 키를 삭제합니다
* **GitHub App**: 저장소 또는 조직 설정의 GitHub Apps에서 Claude GitHub App을 제거합니다. 단, Code Review나 웹 자동 수정 등 다른 Claude 기능에 사용하지 않는 경우에만 제거합니다

[클라우드 제공업체](https://code.claude.com/docs/ko/github-actions-cloud-providers.md)를 구성한 경우 `AWS_ROLE_TO_ASSUME`, `GCP_*` 시크릿, `AZURE_*` 시크릿 등 제공업체 시크릿도 삭제하고, 커스텀 GitHub App과 함께 해당 `APP_ID` 및 `APP_PRIVATE_KEY` 시크릿도 제거합니다.

### GitHub App 권한

[Claude GitHub App](https://github.com/apps/claude)은 Claude Code GitHub Action, [Code Review](https://code.claude.com/docs/ko/code-review.md), 클라우드 세션의 [풀 리퀘스트 자동 수정](https://code.claude.com/docs/ko/claude-code-on-the-web.md#auto-fix-pull-requests) 등 GitHub와 통합되는 모든 Claude 기능에서 공유됩니다. GitHub App에는 모든 기능을 포괄하는 단일 권한 세트가 있으므로, 이 세트에는 Claude Code GitHub Action이 사용하지 않는 일부 권한도 포함됩니다.

앱을 설치하면 다음 권한을 부여하게 됩니다.

| 권한 | 액세스 |
| - | - |
| Actions | 읽기 및 쓰기 |
| Administration | 읽기 |
| Checks | 읽기 및 쓰기 |
| Contents | 읽기 및 쓰기 |
| Discussions | 읽기 및 쓰기 |
| Issues | 읽기 및 쓰기 |
| Members | 읽기 |
| Merge queues | 읽기 |
| Metadata | 읽기 |
| Pull requests | 읽기 및 쓰기 |
| Repository hooks | 읽기 및 쓰기 |
| Statuses | 읽기 |
| Workflows | 읽기 및 쓰기 |

권한 세트는 이를 사용하는 기능보다 먼저 변경될 수도 있습니다. 앱이 이전에 없던 권한을 요청하면 GitHub는 계정 소유자(조직 설치의 경우 조직 소유자)에게 승인을 요청하며, 승인될 때까지 설치는 기존 권한을 유지합니다. 예를 들어 Actions 액세스가 읽기에서 쓰기로 변경되면 앱은 실행과 로그를 보는 것뿐만 아니라 워크플로를 다시 실행할 수 있게 되므로, GitHub는 소유자에게 변경 승인을 요청합니다.

앱을 설치하면 전체 권한 세트를 수락하게 됩니다. GitHub에서는 일부만 수락할 수 없습니다. 조직에서 Claude Code GitHub Action이 사용하는 권한만 허용해야 하는 경우, [Claude Code GitHub Action 설정 가이드](https://github.com/anthropics/claude-code-action/blob/main/docs/setup.md)에 따라 Contents, Issues, Pull requests 권한만 가진 커스텀 GitHub App을 대신 생성합니다. 커스텀 앱은 Claude Code GitHub Action만 지원합니다. Code Review와 웹 자동 수정에는 여전히 공식 앱이 필요합니다.

Claude Code GitHub Action이 이러한 권한으로 Claude가 수행할 수 있는 작업을 어떻게 제한하는지에 대한 자세한 내용은 [보안 문서](https://github.com/anthropics/claude-code-action/blob/main/docs/security.md)를 참조하세요.

## 대화형 및 자동화 모드

Claude Code GitHub Action은 워크플로우 구성에서 실행 방법을 감지합니다:

* **대화형 모드**: 워크플로우가 `prompt` 입력을 제공하지 않으면 Claude는 트리거 구문인 `@claude`(기본값)를 이슈나 풀 리퀘스트 댓글, 풀 리퀨스트 리뷰 또는 새로 열린 이슈의 본문이나 제목에서 기다린 후 해당 요청에 응답합니다. 진행 상황과 결과는 트리거 이슈나 PR의 댓글로 나타납니다.
* **자동화 모드**: 워크플로우가 `prompt` 입력을 제공하면 Claude는 [실행을 트리거할 수 있는 사람](#who-can-trigger-runs)에 대한 확인만 받아 대기 없이 실행됩니다. 기본적으로 결과는 댓글이 아닌 워크플로우 실행 로그에 나타납니다. Claude는 프롬프트가 지시할 때 그리고 [코드 리뷰 예제](#run-a-skill)와 같이 게시할 수 있는 도구가 있을 때 이슈나 풀 리퀘스트에 게시할 수 있습니다.

### 실행을 트리거할 수 있는 사람

두 모드 모두에서 Claude Code GitHub Action은 Claude가 시작하기 전에 트리거 행위자에 대해 두 가지 확인을 실행합니다. 어느 확인이든 거부하면 실행이 실패합니다:

* **쓰기 액세스**: 이슈 및 풀 리퀘스트 이벤트에서 트리거 사용자는 저장소에 대한 쓰기 액세스 권한이 있어야 합니다. 쓰기 액세스 없이 특정 사용자를 허용하려면 `allowed_non_write_users`를 설정하고 자신의 `github_token` 입력을 전달합니다. `schedule` 트리거와 같이 사용자가 작성하지 않은 이벤트는 이 확인을 건너뜁니다.
* **인간 행위자**: 모든 이벤트에서 Claude Code GitHub Action은 `allowed_bots`에 나열하지 않는 한 봇 행위자를 거부합니다. 이는 봇이 루프에서 Claude를 트리거하는 것을 방지합니다. 이 확인은 GitHub가 저장소 사용자(일반적으로 워크플로우의 `cron` 일정을 마지막으로 변경한 사용자)에 귀속시키는 예약된 실행에도 적용됩니다. 해당 사용자가 봇이면 `allowed_bots`에 나열합니다.

## 예제 사용 사례

[examples 디렉토리](https://github.com/anthropics/claude-code-action/tree/main/examples)에는 다양한 시나리오에 대한 즉시 사용 가능한 워크플로우가 포함되어 있습니다.

이 페이지의 예제는 API 키 인증을 보여줍니다. Claude 구독으로 인증하는 경우 모든 예제의 `anthropic_api_key` 줄을 `claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}`으로 바꿉니다.

### @claude 멘션에 응답

이 워크플로우는 Claude Code GitHub Action을 대화형 모드에서 실행합니다. Claude는 누군가 이슈나 PR 댓글에서 `@claude`를 멘션할 때마다 응답합니다.

```yaml theme={null}
name: Claude Code
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
jobs:
  claude:
    if: contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
      issues: write
      id-token: write
      actions: read
    steps:
      - uses: actions/checkout@v6
        with:
          fetch-depth: 1
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

이 워크플로우에서 보일러플레이트가 아닌 부분:

* `id-token: write`: Claude Code GitHub Action의 기본 GitHub App 인증에 필요합니다
* `actions: read`: Claude가 PR에서 CI 결과를 읽을 수 있게 합니다
* `actions/checkout`: Claude에게 작업할 저장소의 로컬 복사본을 제공합니다
* `if`: `@claude`를 멘션하지 않는 댓글에서 러너가 시작되지 않도록 합니다. Claude Code GitHub Action도 응답하기 전에 트리거 구문 자체를 확인합니다

워크플로우가 준비되면 이슈나 PR 댓글에서 `@claude`를 멘션하고 요청을 합니다:

```text wrap theme={null}
@claude implement this feature based on the issue description
@claude how should I implement user authentication for this endpoint?
@claude fix the TypeError in the user dashboard component
```

Claude가 동일한 이슈나 PR의 댓글로 응답하고 작업하면서 업데이트합니다.

### 스킬 실행

`prompt` 입력은 일반 텍스트뿐만 아니라 [스킬](https://code.claude.com/docs/ko/skills.md) 호출도 허용합니다:

* 저장소의 `.claude/skills/` 디렉토리에 있는 스킬의 경우 `anthropics/claude-code-action` 단계 전에 `actions/checkout`을 실행하여 스킬 파일을 러너에서 사용할 수 있게 한 후 `/skill-name`을 `prompt`로 전달합니다.
* [플러그인](https://code.claude.com/docs/ko/plugins/overview.md)에 패키징된 스킬의 경우 `plugin_marketplaces` 및 `plugins` 입력으로 플러그인을 설치한 후 네임스페이스가 지정된 `/plugin-name:skill-name`을 `prompt`로 전달합니다. `plugins` 입력은 `plugin-name@marketplace-name`을 사용합니다. 마켓플레이스 이름은 저장소 URL이 아닌 마켓플레이스 자체의 매니페스트에서 나옵니다.

다음 워크플로우는 `code-review` 플러그인을 설치하고 풀 리퀘스트가 열리거나, 업데이트되거나, 다시 열리거나, 리뷰 준비로 표시될 때 해당 스킬을 실행합니다. 빠른 설정의 리뷰 워크플로우와 동일한 플러그인을 실행합니다. 프롬프트, 모델 및 트리거를 직접 제어하려는 경우 이와 같은 워크플로우를 사용합니다. 워크플로우 파일을 유지하지 않고 자동 리뷰의 경우 [Code Review](https://code.claude.com/docs/ko/code-review.md)를 참조하십시오. 공개 저장소에서 GitHub는 포크 풀 리퀘스트로 트리거된 실행에서 시크릿을 보류하므로 리뷰는 동일한 저장소의 브랜치에서 풀 리퀘스트에서만 실행됩니다.

```yaml theme={null}
name: Code Review
on:
  pull_request:
    types: [opened, synchronize, ready_for_review, reopened]
jobs:
  review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: read
      issues: read
      id-token: write
    steps:
      - uses: actions/checkout@v6
        with:
          fetch-depth: 1
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          plugin_marketplaces: "https://github.com/anthropics/claude-plugins-official.git"
          plugins: "code-review@claude-plugins-official"
          prompt: "/code-review:code-review --comment ${{ github.repository }}/pull/${{ github.event.pull_request.number }}"
          claude_args: '--allowedTools "mcp__github_inline_comment__create_inline_comment"'
```

이 워크플로우에서 리뷰가 어디로 가는지 제어하는 두 줄:

* **`--comment`**: Claude가 풀 리퀘스트에 리뷰를 게시합니다. 발견한 각 이슈에 대한 인라인 댓글로 또는 발견하지 못한 경우 하나의 요약 댓글로 게시합니다. 없으면 Claude는 아무것도 게시하지 않으며 워크플로우 실행 로그에서 결과를 읽습니다.
* **`claude_args`**: 스킬 자체의 `allowed-tools` frontmatter가 동일한 도구를 명명하더라도 이 줄을 유지합니다. Claude Code GitHub Action이 `claude_args`의 `--allowedTools`가 이를 명명할 때만 인라인 댓글을 게시하는 MCP 서버를 시작하기 때문입니다.

Claude는 초안 및 닫힌 풀 리퀘스트, 리뷰가 필요하지 않다고 판단하는 풀 리퀘스트(자동화되거나 사소한 것 등), 그리고 이미 Claude의 댓글이 있는 풀 리퀘스트를 건너뜁니다.

### 일정에 따라 실행

`prompt` 입력으로 Claude Code GitHub Action은 cron 일정을 포함한 모든 GitHub 이벤트에서 자동화 모드에서 실행됩니다. 일반 텍스트 프롬프트의 경우 Claude는 프롬프트가 필요로 하는 도구에 대해 `claude_args`의 `--allowedTools` 또는 `settings` 입력의 [`permissions.allow` 규칙](https://code.claude.com/docs/ko/permissions#permission-rule-syntax)으로 도구를 부여할 때까지 셸이나 GitHub API 액세스 권한이 없습니다. 대신 스킬을 호출하면 Claude는 [`allowed-tools` frontmatter](https://code.claude.com/docs/ko/skills#pre-approve-tools-for-a-skill)가 부여하는 도구를 사용할 수 있습니다. GitHub는 예약된 워크플로우를 기본 브랜치에서만 실행하며, 공개 저장소에서는 저장소 활동이 60일 없으면 일정을 비활성화합니다.

이 워크플로우는 매일 09:00 UTC에 워크플로우 실행 로그에서 보고서를 생성합니다. 해당 `claude_args` 줄은 [CLI 인수를 전달](#pass-cli-arguments)하여 모델을 선택하고 두 개의 GitHub MCP 도구를 허용합니다. Claude가 해당 도구로 GitHub API를 통해 커밋과 이슈를 읽으므로 체크아웃 단계를 생략할 수 있습니다:

```yaml theme={null}
name: Daily Report
on:
  schedule:
    - cron: "0 9 * * *"
jobs:
  report:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      issues: read
      id-token: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "Generate a summary of yesterday's commits and open issues"
          claude_args: |
            --model claude-opus-5-5
            --allowedTools "mcp__github__list_commits,mcp__github__list_issues"
```

## 모범 사례

### CLAUDE.md에서 프로젝트 표준 정의

저장소 루트에 `CLAUDE.md` 파일을 생성하여 코드 스타일 지침, 리뷰 기준, 프로젝트별 규칙 및 선호하는 패턴을 정의합니다. Claude는 PR을 생성하고 요청에 응답할 때 이러한 지침을 따릅니다. 자세한 내용은 [메모리 설명서](https://code.claude.com/docs/ko/memory.md)를 참조하십시오.

### 자격 증명 보호

> [!WARNING]
>
> API 키나 OAuth 토큰을 저장소에 직접 커밋하지 마십시오. 항상 GitHub Secrets로 저장하고 워크플로우에서 참조합니다. 예: `anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}`.

워크플로우에 필요한 권한만 부여하고 병합하기 전에 Claude의 변경 사항을 검토합니다.

권한 및 인증을 포함한 보안 지침은 [Claude Code Action 보안 설명서](https://github.com/anthropics/claude-code-action/blob/main/docs/security.md)를 참조하십시오.

### 비용 관리

각 실행은 두 가지 종류의 리소스를 소비합니다:

* **GitHub Actions 분**: Claude Code GitHub Action은 GitHub 호스팅 러너에서 실행되며, GitHub Actions 분을 소비합니다. 가격 책정 및 분 제한은 [GitHub의 청구 설명서](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions)를 참조하십시오.
* **API 토큰**: 각 상호 작용은 프롬프트 및 응답의 길이, 작업 복잡도 및 코드베이스 크기에 따라 토큰을 소비합니다. 현재 토큰 요금은 [Claude의 가격 책정 페이지](https://claude.com/platform/api)를 참조하십시오. OAuth 토큰으로 인증하면 실행이 API 청구 대신 Claude 구독을 사용합니다.

Claude에게 더 명확한 컨텍스트를 제공하고 각 실행이 수행할 수 있는 작업의 양을 제한하여 두 종류의 비용을 낮출 수 있습니다:

* 특정 `@claude` 요청을 작성하여 Claude가 완료하는 데 더 적은 턴이 필요하도록 합니다
* 이슈 템플릿을 사용하여 미리 컨텍스트를 제공합니다
* `CLAUDE.md`를 간결하게 유지합니다. Claude가 모든 실행에서 이를 읽기 때문입니다
* `claude_args`에서 `--max-turns`를 설정하여 반복을 제한합니다
* 워크플로우 수준 타임아웃을 설정하여 실행 중인 작업을 방지합니다
* GitHub의 동시성 제어를 사용하여 병렬 실행을 제한합니다

조직 전체의 사용 추적은 [분석 대시보드](https://code.claude.com/docs/ko/analytics.md) 및 [모니터링](https://code.claude.com/docs/ko/monitoring-usage.md)을 참조하십시오. 사용이 측정되고 청구되는 방법은 [비용](https://code.claude.com/docs/ko/costs.md)을 참조하십시오.

## 클라우드 공급자 사용

기본적으로 Claude Code GitHub Action은 API 키나 OAuth 토큰으로 Claude API를 직접 호출합니다. 대신 자신의 클라우드 계정을 통해 추론을 라우팅하려면 공급자에 대한 입력을 설정하고 [클라우드 공급자와 함께 Claude Code GitHub Actions 사용](https://code.claude.com/docs/ko/github-actions-cloud-providers.md)을 따릅니다:

* **Amazon Bedrock**: `use_bedrock: "true"`
* **Google Cloud의 Agent Platform**: `use_vertex: "true"`
* **Microsoft Foundry**: `use_foundry: "true"`

세 공급자 모두에서 Claude API 키 대신 OIDC ID 페더레이션을 통해 인증하므로 저장소에 정적 클라우드 자격 증명을 저장하지 않습니다.

## 문제 해결

### Claude가 @claude 명령에 응답하지 않음

* GitHub App이 저장소에 설치되었는지 확인합니다
* 저장소에 대해 워크플로우가 활성화되었는지 확인합니다
* API 키나 OAuth 토큰이 저장소 시크릿에 설정되었는지 확인합니다
* 댓글에 `/claude`나 `@claude-bot`이 아닌 완전한 단어로 `@claude`가 포함되어 있는지 확인합니다
* 댓글 작성자가 저장소에 대한 쓰기 액세스 권한이 있는지 확인합니다. [실행을 트리거할 수 있는 사람](#who-can-trigger-runs)에서 예외를 참조하십시오

### Claude의 커밋에서 CI가 실행되지 않음

* GitHub는 기본 `GITHUB_TOKEN`으로 만든 커밋에서 워크플로우를 트리거하지 않습니다. Claude Code GitHub Action에 `github_token: ${{ secrets.GITHUB_TOKEN }}`을 전달하면 Claude GitHub App으로 인증하도록 제거하거나 대신 사용자 정의 앱 토큰을 전달합니다
* CI 워크플로우의 트리거에 Claude의 푸시가 생성하는 이벤트(예: `push` 또는 `pull_request`)가 포함되어 있는지 확인합니다

### 인증 오류

* 워크플로우를 디버깅하기 전에 로컬에서 `claude`로 테스트하여 API 키나 OAuth 토큰이 유효한지 확인합니다
* Bedrock, Agent Platform 및 Foundry의 경우 클라우드 공급자 페이지의 [문제 해결 섹션](https://code.claude.com/docs/ko/github-actions-cloud-providers.md#troubleshooting)을 참조하십시오

더 많은 솔루션은 Claude Code GitHub Action의 [FAQ](https://github.com/anthropics/claude-code-action/blob/main/docs/faq.md)를 참조하십시오.

## 고급 구성

### 작업 파라미터

이는 가장 일반적으로 사용되는 입력입니다. 각각은 `anthropics/claude-code-action` 단계의 `with:` 키에 매핑됩니다.

| 파라미터 | 설명 | 필수 |
| - | - | - |
| `prompt` | Claude에 대한 지침. 일반 텍스트 또는 [스킬](https://code.claude.com/docs/ko/skills.md) 호출. 생략하면 Claude는 [트리거 구문](#interactive-and-automation-modes) 대신 응답합니다 | 아니오 |
| `claude_args` | Claude Code에 전달된 CLI 인수 | 아니오 |
| `anthropic_api_key` | Claude API 키 | Claude API의 경우 `claude_code_oauth_token` 또는 [워크로드 ID 페더레이션](#set-up-for-an-organization)을 사용하지 않는 한 필수입니다. Bedrock, Agent Platform 또는 Foundry에는 사용되지 않습니다 |
| `claude_code_oauth_token` | Claude 구독으로 인증하기 위한 OAuth 토큰. `claude setup-token`으로 생성됩니다 | 아니오 |
| `github_token` | GitHub 작업용 토큰. 생략하면 Claude Code GitHub Action이 Claude GitHub App으로 인증합니다 | 아니오 |
| `plugin_marketplaces` | 플러그인 마켓플레이스 Git URL의 줄 바꿈으로 구분된 목록 | 아니오 |
| `plugins` | 실행 전에 설치할 플러그인 이름의 줄 바꿈으로 구분된 목록 | 아니오 |
| `settings` | Claude Code 설정. JSON 문자열 또는 설정 JSON 파일의 경로 | 아니오 |
| `trigger_phrase` | Claude가 응답하는 트리거 구문. 기본값: `@claude` | 아니오 |
| `use_bedrock` | Claude API 대신 Amazon Bedrock 사용 | 아니오 |
| `use_vertex` | Claude API 대신 Google Cloud의 Agent Platform 사용 | 아니오 |
| `use_foundry` | Claude API 대신 Microsoft Foundry 사용 | 아니오 |

전체 입력 목록은 Claude Code GitHub Action의 [구성 참조](https://github.com/anthropics/claude-code-action/blob/main/docs/usage.md#inputs)를 참조하십시오.

### CLI 인수 전달

`claude_args` 파라미터는 모든 [Claude Code CLI 인수](https://code.claude.com/docs/ko/cli-reference.md)를 허용합니다:

```yaml theme={null}
claude_args: "--max-turns 5 --model claude-sonnet-5 --mcp-config /path/to/config.json"
```

일반적인 인수:

* `--max-turns`: 대화 턴 수 제한
* `--model`: 사용할 모델. 예: `claude-sonnet-5`. 이 인수 없으면 Claude Code GitHub Action이 Claude Code [기본 모델](https://code.claude.com/docs/ko/model-config.md)을 사용합니다
* `--mcp-config`: [MCP 구성](https://code.claude.com/docs/ko/mcp.md) 경로
* `--allowedTools`: 허용된 도구의 쉼표로 구분된 목록. `--allowed-tools` 별칭도 작동합니다
* `--debug`: 디버그 출력 활성화

## 베타에서 업그레이드

워크플로우가 여전히 `anthropics/claude-code-action@beta`를 참조하면 v1로 업데이트합니다:

1. `uses` 줄에서 `@beta`를 `@v1`로 변경합니다
2. `mode` 입력을 제거합니다. Claude Code GitHub Action이 이제 [모드를 자동으로 감지](#interactive-and-automation-modes)하기 때문입니다
3. `direct_prompt`를 `prompt`로 바꿉니다
4. `max_turns` 및 `model`과 같은 CLI 옵션을 `claude_args`로 이동합니다. `custom_instructions`는 같은 이름의 플래그가 없으며 `--append-system-prompt`가 됩니다

전체 입력 매핑 및 이전/이후 예제는 [마이그레이션 가이드](https://github.com/anthropics/claude-code-action/blob/main/docs/migration-guide.md)를 참조하십시오.

## 다음 단계

* [클라우드 공급자와 함께 Claude Code GitHub Actions 사용](https://code.claude.com/docs/ko/github-actions-cloud-providers.md): Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry를 통해 추론을 라우팅합니다
* [구성 참조](https://github.com/anthropics/claude-code-action/blob/main/docs/usage.md#inputs): 작업 입력의 전체 목록
* [Examples 디렉토리](https://github.com/anthropics/claude-code-action/tree/main/examples): 더 많은 시나리오에 대한 즉시 사용 가능한 워크플로우
* [Code Review](https://code.claude.com/docs/ko/code-review.md): 워크플로우 파일을 유지하지 않고 자동 풀 리퀘스트 리뷰
