> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Code Review

> Code Review로 GitHub 풀 리퀘스트의 버그를 찾아냅니다. Claude가 각 변경 사항을 리뷰하고, 결과를 검증하며, 인라인 댓글을 남깁니다. Team 및 Enterprise 플랜용

Code Review를 사용하면 Claude가 GitHub 저장소의 풀 리퀘스트를 리뷰합니다. 여러 에이전트가 각 변경 사항을 주변 코드와 함께 읽으며 논리 오류, 보안 취약점, 손상된 엣지 케이스와 같은 문제를 찾습니다. 검증 단계에서는 결과를 보고하기 전에 코드와 대조하여 확인합니다.

결과는 [심각도](https://code.claude.com/docs/ko/code-review-pull-requests.md#severity-levels)별로 순위가 매겨져 해당 라인에 인라인 댓글로 게시되며, 풀 리퀘스트에는 요약과 확인 실행(check run)이 함께 표시됩니다. 리뷰는 풀 리퀘스트를 승인하거나 차단하지 않으므로 병합 결정은 팀에 그대로 남습니다.

![네 단계로 이루어진 리뷰 다이어그램. GitHub의 풀 리퀘스트가 Anthropic 인프라에서 병렬로 탐색하는 여러 에이전트에게 전달됩니다. 검증 단계에서 거짓 양성을 제거하고, 남은 결과는 중복 제거 후 심각도별로 순위가 매겨지며, 리뷰는 인라인 댓글, 요약 및 확인 실행을 GitHub에 다시 게시합니다.](https://mintcdn.com/claude-code/gLJVaPQEgKC8ZyUD/images/code-review-pipeline.svg?fit=max\&auto=format\&n=gLJVaPQEgKC8ZyUD\&q=85\&s=0351c96df9efa3105172eb00a672f130)

> [!NOTE]
>
> Code Review는 AI를 사용하여 코드를 리뷰하므로 버그, 보안 취약점 또는 기타 문제를 놓칠 수 있습니다. 결과가 없는 리뷰가 코드에 오류가 없거나 안전하다는 것을 의미하지는 않습니다.

Code Review를 켜려면 Claude 조직의 Owner가 [Code Review 설정](https://code.claude.com/docs/ko/code-review-setup.md)을 따릅니다. Claude는 이 서비스 없이도 코드를 리뷰할 수 있습니다. 모든 플랜에서 Claude Code 세션에서 [`/code-review`](https://code.claude.com/docs/ko/code-review-local)를 실행하거나, [모든 옵션을 비교](#compare-ways-to-get-a-review)해 보십시오.

## 사용 가능 여부

Code Review를 설정하기 전에 조직이 자격 요건을 충족하는지 확인하십시오:

* **플랜**: [Team 및 Enterprise](https://code.claude.com/docs/ko/feature-availability.md)
* **코드 호스트**: [GitHub Enterprise Server](https://code.claude.com/docs/ko/github-enterprise-server.md) 및 데이터 레지던시가 적용된 GitHub Enterprise Cloud를 포함하여 GitHub에 호스팅된 저장소. 데이터 레지던시의 경우 Owner가 [GitHub Enterprise Server 관리자 설정](https://code.claude.com/docs/ko/github-enterprise-server.md#admin-setup)을 따르고 엔터프라이즈의 `ghe.com` 호스트 이름을 입력해야 합니다.
* **데이터 보존**: Code Review는 [Zero Data Retention](https://code.claude.com/docs/ko/zero-data-retention.md)이 활성화되었거나 [HIPAA 구성](https://code.claude.com/docs/ko/hipaa-setup.md)이 적용된 조직에서는 사용할 수 없으며, Anthropic의 Business Associate Agreement(BAA) 적용 대상이 아닙니다.
* **암호화 키**: Code Review는 아직 고객 관리형 암호화 키(CMEK)를 사용하는 조직에서 사용할 수 없습니다.
* **클라우드 제공업체**: 개발자가 Amazon Bedrock, Google Cloud의 Agent Platform 또는 Microsoft Foundry를 통해 Claude Code를 사용하더라도 이러한 플랜 중 하나의 Claude 조직이 필요합니다

## Code Review 설정 및 사용

필요한 작업에 맞는 페이지를 선택하십시오:

> [card] [Code Review 설정](https://code.claude.com/docs/ko/code-review-setup.md)
>
> 요구 사항을 확인하고, Claude GitHub App을 설치하고, 저장소, 리뷰 수준 및 리뷰 실행 시기를 선택합니다

> [card] [Code Review 사용자 정의](https://code.claude.com/docs/ko/code-review-customize.md)
>
> 저장소의 `REVIEW.md` 및 `CLAUDE.md` 파일로 플래그되는 항목을 조정합니다

> [card] [풀 리퀘스트에서 리뷰 읽기 및 요청](https://code.claude.com/docs/ko/code-review-pull-requests.md)
>
> 결과와 심각도를 읽고, 댓글로 다른 리뷰를 요청합니다

> [card] [Code Review 문제 해결](https://code.claude.com/docs/ko/code-review-troubleshooting.md)
>
> 시작되지 않았거나, 실패했거나, 예산 때문에 건너뛴 리뷰를 해결합니다

> [card] [Code Review 비용 및 사용량](https://code.claude.com/docs/ko/code-review-costs.md)
>
> 리뷰 청구 방식을 확인하고, 지출을 추정하고, 월간 지출 한도를 설정하고, 리뷰 활동을 추적합니다

## 리뷰 작동 방식

기본적으로 Code Review는 정확성에 중점을 둡니다. 형식 선호나 누락된 테스트 범위가 아니라 프로덕션을 중단시킬 버그입니다. 플래그되는 항목을 변경하려면 저장소에 [지침 파일을 추가](https://code.claude.com/docs/ko/code-review-customize.md)하십시오.

리뷰는 Anthropic 인프라에서 네 단계로 실행됩니다:

1. **찾기**: 여러 에이전트가 diff와 주변 코드를 병렬로 검사합니다.
2. **검증**: 검증 단계에서 후보 결과를 코드와 대조하여 확인하고 거짓 양성을 걸러냅니다.
3. **순위 지정**: 남은 결과는 중복 제거된 후 심각도별로 순위가 매겨집니다.
4. **게시**: 리뷰가 풀 리퀘스트에 결과를 게시합니다.

각 리뷰는 풀 리퀘스트에 다음을 남깁니다:

* **결과**: 해당 라인의 인라인 댓글과 리뷰 본문의 요약
* **확인 실행**: 이름은 **Claude Code Review**이며, 결과가 [세부 정보](https://code.claude.com/docs/ko/code-review-pull-requests.md#check-run-output)에 나열됩니다. 확인 실행은 실패로 종료되지 않습니다.
* **결과 대신 남기는 메모**: 확인 실행의 제목이 **Code review found no issues**로 표시될 때 게시됩니다

Code Review는 리뷰가 실행될 Claude 모델을 선택하며, 관리자 설정에서는 모델 선택을 제공하지 않습니다. 리뷰를 더 철저하게 또는 덜 철저하게 하려면 [리뷰 수준](#review-levels)을 변경하십시오.

Owner가 Code Review를 켜면 각 저장소에는 [리뷰 실행 시기](https://code.claude.com/docs/ko/code-review-setup.md#set-when-reviews-run)에 대한 설정이 있습니다. 풀 리퀘스트가 열릴 때 한 번, 모든 푸시 후, 또는 요청 시에만 실행됩니다. 어떤 설정이든 저장소에 대한 쓰기 권한이 있는 사용자는 풀 리퀘스트에 `@claude review`를 댓글로 작성하여 [리뷰를 시작](https://code.claude.com/docs/ko/code-review-pull-requests.md#comment-commands)할 수 있습니다.

### 리뷰 수준

리뷰 수준은 각 리뷰의 철저함을 설정하며, 더 철저한 리뷰일수록 비용이 더 많이 듭니다:

* **Quick**: 더 가벼운 검토입니다. 가장 빠른 수준이며 비용이 가장 낮습니다.
* **Standard**: 깊이, 속도, 비용의 균형을 맞춥니다. 기본 수준입니다.
* **Deep**: 가장 철저한 검토입니다. 시간이 가장 오래 걸리고 비용이 가장 많이 듭니다.

Owner는 [조직에 대해 하나의 수준을 선택](https://code.claude.com/docs/ko/code-review-setup.md#set-the-default-review-level)하고, 일상적인 코드베이스에는 Quick, 중요한 코드베이스에는 Deep처럼 개별 저장소에 별도의 수준을 지정할 수 있습니다. 각 리뷰의 비용에 영향을 주는 다른 요인은 [Code Review 비용 및 사용량](https://code.claude.com/docs/ko/code-review-costs.md)을 참조하십시오.

### 리뷰가 액세스할 수 있는 항목

리뷰는 Owner가 [설정 중에 설치](https://code.claude.com/docs/ko/code-review-setup.md#turn-on-code-review)한 Claude GitHub App을 통해 저장소에 접근합니다:

* **실행 위치**: Anthropic 인프라의 관리형 환경에서 실행됩니다. 리뷰는 [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)에서 실행되지 않습니다.
* **읽고 쓰는 항목**: 리뷰 내에서 저장소에 대한 액세스는 읽기 전용이며, 리뷰는 커밋을 푸시하지 않습니다. 풀 리퀘스트에서는 댓글과 [확인 실행](https://code.claude.com/docs/ko/code-review-pull-requests.md#check-run-output)을 게시하고, 자신의 이전 댓글 스레드를 해결하며, 댓글 명령에 👀로 반응할 수 있습니다. 앱 자체는 다른 Claude 기능과 공유하는 [더 광범위한 권한 집합](https://code.claude.com/docs/ko/github-actions.md#github-app-permissions)을 보유합니다.
* **코드 검사 방식**: 리뷰는 코드를 빌드하거나 실행하지 않고 diff와 주변 코드를 읽는 방식으로 작동합니다.

### 리뷰를 제어하는 주체

* **시작할 수 있는 사람**: 리뷰가 자동으로 실행되는 경우, 풀 리퀘스트를 열거나 푸시하면 리뷰가 시작됩니다. 단, [초안과 포크는 예외](https://code.claude.com/docs/ko/code-review-pull-requests.md#review-drafts-and-pull-requests-from-forks)입니다. 일부 푸시 후에는 Code Review가 리뷰를 시작하는 대신 [이전 결과를 유지](https://code.claude.com/docs/ko/code-review-pull-requests.md#when-a-push-keeps-the-earlier-result)합니다. [댓글 명령](https://code.claude.com/docs/ko/code-review-pull-requests.md#comment-commands)은 저장소에 대한 쓰기 권한이 있는 사람이 작성한 경우에만 리뷰를 시작합니다.
* **따르는 지침**: base 또는 기본 브랜치의 `REVIEW.md`를 따르며, [풀 리퀘스트 자체의 변경 사항에서는 절대 읽지 않습니다](https://code.claude.com/docs/ko/code-review-customize.md#which-branch-review-md-is-read-from).

## 리뷰를 받는 방법 비교

사용 가능한 옵션을 찾으려면 **사용 가능 대상** 열을 플랜 및 코드 호스트와 비교하여 확인하십시오:

| 옵션 | 리뷰를 시작하는 방법 | 실행 위치 | 사용 가능 대상 |
| :- | :- | :- | :- |
| [Code Review](#how-reviews-work) | 각 저장소 설정에 따른 풀 리퀘스트 활동 또는 `@claude review` 댓글 | Anthropic 인프라 | Owner가 켠 후, GitHub 저장소를 보유한 Team 또는 Enterprise 플랜의 조직 |
| [`/code-review`](https://code.claude.com/docs/ko/code-review-local) | 브랜치에서 명령을 실행 | Claude Code 세션 | 모든 플랜의 모든 사용자 |
| [Ultrareview](https://code.claude.com/docs/ko/ultrareview.md) | Claude Code에서 시작 | 클라우드 샌드박스 | claude.ai 계정으로 로그인해야 합니다. 사용할 수 없는 환경은 [Ultrareview](https://code.claude.com/docs/ko/ultrareview.md)를 참조하십시오 |
| [GitHub Actions](https://code.claude.com/docs/ko/github-actions.md) 또는 [GitLab CI/CD](https://code.claude.com/docs/ko/gitlab-ci-cd.md)를 사용한 자체 CI의 Claude | 모든 풀 리퀘스트 또는 merge request와 같은 파이프라인 이벤트 | 자체 CI 러너 | GitHub 또는 GitLab에서 Claude API 키 또는 클라우드 제공업체 자격 증명이 있는 모든 사용자 |
| [서브에이전트](https://code.claude.com/docs/ko/sub-agents.md) 또는 [스킬](https://code.claude.com/docs/ko/skills.md)로 만든 자체 리뷰어 | 세션 중에 사용자 또는 Claude가 호출 | Claude Code를 실행하는 모든 위치 | 직접 작성하는 모든 사용자 |

## 관련 리소스

* [GitHub Enterprise Server](https://code.claude.com/docs/ko/github-enterprise-server.md): 자체 호스팅 GitHub 인스턴스에서 Code Review를 사용합니다
* [GitHub App 권한](https://code.claude.com/docs/ko/github-actions.md#github-app-permissions): Claude GitHub App이 요청하는 전체 권한 집합
* [How Anthropic secures its AI-native software development lifecycle](https://claude.com/blog/how-anthropic-secures-its-ai-native-software-development-lifecycle): 자동화된 리뷰가 Anthropic의 안전한 개발 프로세스의 한 계층으로 어떻게 적합한지에 대한 설명
