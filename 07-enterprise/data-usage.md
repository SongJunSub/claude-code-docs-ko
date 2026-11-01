> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 데이터 사용

> Anthropic의 Claude 데이터 사용 정책에 대해 알아봅니다

## 데이터 정책

### 데이터 학습 정책

**개인 사용자(Free, Pro, Max, Ultra 플랜)**:
사용자는 향후 Claude 모델 개선에 데이터 사용을 허용할지 선택할 수 있습니다. 이 설정이 켜져 있으면 Anthropic은 Free, Pro, Max, Ultra 계정의 데이터를 사용하여 새 모델을 학습시킵니다(해당 계정에서 Claude Code를 사용하는 경우 포함).

**상업 사용자**: (Team 및 Enterprise 플랜, API, 서드파티 플랫폼, Claude Gov) 기존 정책이 유지됩니다. 고객이 모델 개선을 위해 데이터를 제공하기로 선택한 경우(예: [Developer Partner Program](https://support.claude.com/en/articles/11174108-about-the-development-partner-program))가 아니라면, Anthropic은 상업 약관에 따라 Claude Code로 전송된 코드나 프롬프트를 사용하여 생성형 모델을 학습시키지 않습니다.

### Development Partner Program

[Development Partner Program](https://support.claude.com/en/articles/11174108-about-the-development-partner-program) 등을 통해 학습용 자료를 제공하는 방식에 명시적으로 옵트인한 경우, Anthropic은 제공된 자료를 모델 학습에 사용할 수 있습니다. 조직 관리자는 조직 단위로 Development Partner Program에 명시적으로 옵트인할 수 있습니다. 이 프로그램은 Anthropic 퍼스트파티 API에서만 제공되며, Amazon Bedrock 또는 Google Cloud의 Agent Platform 사용자에게는 제공되지 않습니다.

### `/feedback` 명령을 통한 피드백

`/feedback` 명령을 사용하여 Claude Code에 대한 피드백을 보내는 경우, Anthropic은 해당 피드백을 제품 및 서비스 개선에 사용할 수 있습니다. `/feedback` 또는 동일한 경로로 보고되는 `/bug` 및 `/share`를 통해 공유된 트랜스크립트는 5년간 보관됩니다.

[Claude가 작성하는 피드백](https://code.claude.com/docs/ko/tools-reference.md#sendfeedback-tool-behavior)을 사용하면 Claude가 피드백 보고서 초안을 작성하여 사용자가 검토할 수 있도록 로컬 머신에 대기시켜 둘 수도 있습니다. 사용자가 초안을 보내기로 선택하기 전까지 Claude Code는 아무것도 전송하지 않으며, 전송된 초안은 다른 `/feedback` 보고서와 동일한 제출 경로 및 보관 정책을 따릅니다.

### 세션 품질 설문

Claude Code에서 "How is Claude doing this session?" 프롬프트가 표시될 때 이 설문에 응답하면("Dismiss" 선택 포함) 평가만 기록됩니다. 평가 프롬프트 자체의 일부로 대화 트랜스크립트, 입력, 출력 또는 기타 세션 데이터는 수집하거나 저장하지 않습니다. 좋아요/싫어요 피드백이나 `/feedback` 보고서와 달리, 이 세션 품질 설문은 단순한 제품 만족도 지표입니다.

평가 프롬프트 이후에 "Can Anthropic look at your session transcript to help us improve Claude Code?"라고 묻는 별도의 후속 질문이 표시될 수 있습니다. 이는 평가와 구별되는 선택적 두 번째 단계입니다.

* **Yes**: 대화 트랜스크립트, 모든 서브에이전트 트랜스크립트, 디스크의 원시 세션 로그 파일을 Anthropic에 업로드합니다. 알려진 API 키 및 토큰 패턴은 업로드 전에 마스킹됩니다. 소스 코드, 파일 내용 및 기타 대화 내용은 그대로 업로드됩니다. 공유된 트랜스크립트는 최대 6개월간 보관됩니다. Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 및 로그인된 [Claude apps gateway](https://code.claude.com/docs/ko/claude-apps-gateway) 세션에서는 Yes를 선택하면 업로드 대신 동일한 페이로드를 `~/.claude/feedback-bundles/` 아래의 로컬 아카이브에 기록하며, 사용자가 해당 파일을 전달하기 전까지는 아무것도 머신 밖으로 전송되지 않습니다.
* **No**: 아무것도 전송하지 않고 거절합니다
* **Don't ask again**: 거절하고 이후 세션에서 이 후속 질문이 표시되지 않도록 합니다

명시적으로 **Yes**를 선택하지 않는 한 아무것도 업로드되지 않습니다. [데이터 무보존(zero data retention)](https://code.claude.com/docs/ko/zero-data-retention.md)이 적용된 조직, 조직 정책으로 제품 피드백이 비활성화된 조직, 또는 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`이 설정된 조직에는 이 후속 질문이 표시되지 않습니다. 평가 프롬프트 이후 제출된 세션 트랜스크립트를 포함하여 이 설문에 대한 응답은 데이터 학습 설정에 영향을 주지 않으며, AI 모델 학습에 사용될 수 없습니다.

이 설문을 비활성화하려면 `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1`을 설정합니다. `DISABLE_TELEMETRY`, `DO_NOT_TRACK` 또는 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`이 설정된 경우에도 설문이 비활성화됩니다. 필수적이지 않은 트래픽을 차단하지만 자체 [OpenTelemetry 수집기](https://code.claude.com/docs/ko/monitoring-usage.md)를 통해 설문 응답을 수집하는 조직은 `CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL=1`을 설정하여 설문을 다시 활성화할 수 있습니다. 이 경우 설문은 구성된 수집기에만 평가를 로그로 기록합니다. 트랜스크립트 공유 후속 질문과 Anthropic으로 향하는 기타 모든 피드백 트래픽은 계속 비활성화됩니다. 비활성화하는 대신 빈도를 조절하려면 설정 파일에서 [`feedbackSurveyRate`](https://code.claude.com/docs/ko/settings-reference#feedbacksurveyrate)를 `0`과 `1` 사이의 확률 값으로 설정합니다.

### 데이터 보존

Anthropic은 계정 유형과 사용자 설정에 따라 Claude Code 데이터를 보존합니다.

**개인 사용자(Free, Pro, Max, Ultra 플랜)**:

* 모델 개선을 위한 데이터 사용을 허용한 사용자: 모델 개발 및 안전성 개선을 지원하기 위해 5년 보존 기간
* 모델 개선을 위한 데이터 사용을 허용하지 않은 사용자: 30일 보존 기간
* 개인정보 설정은 [claude.ai/settings/data-privacy-controls](https://claude.ai/settings/data-privacy-controls)에서 언제든지 변경할 수 있습니다.

**상업 사용자(Team, Enterprise, API)**:

* 표준: 30일 보존 기간
* [데이터 무보존(Zero data retention)](https://code.claude.com/docs/ko/zero-data-retention.md): Claude for Enterprise의 Claude Code에서 자격을 갖춘 계정에 제공됩니다. ZDR은 표준 Enterprise 플랜에 포함되어 있지 않으며, 자격 확인 후 계정 팀이 조직별로 활성화합니다
* 로컬 캐싱: Claude Code 클라이언트는 세션 재개를 위해 기본적으로 30일 동안 `~/.claude/projects/` 아래에 세션 트랜스크립트를 일반 텍스트로 로컬에 저장합니다. 기간은 `cleanupPeriodDays`로 조정할 수 있습니다. 저장되는 항목과 삭제 방법은 [애플리케이션 데이터](https://code.claude.com/docs/ko/claude-directory.md#application-data)를 참조하세요.

  Claude Desktop 또는 Cowork에서 시작되었거나 가장 최근에 이어서 진행된 세션의 트랜스크립트는 [기본적으로 해당 제한에서 제외](https://code.claude.com/docs/ko/claude-directory.md#cleaned-up-automatically)됩니다.

개별 클라우드 세션은 언제든지 삭제할 수 있습니다. 세션을 삭제하면 해당 세션의 이벤트 데이터가 영구적으로 제거됩니다. 세션 삭제 방법은 [세션 삭제](https://code.claude.com/docs/ko/claude-code-on-the-web.md#delete-sessions)를 참조하세요.

데이터 보존 관행에 대한 자세한 내용은 [개인정보 센터](https://privacy.anthropic.com/)에서 확인할 수 있습니다.

자세한 내용은 [상업 서비스 약관](https://www.anthropic.com/legal/commercial-terms)(Team, Enterprise, API 사용자) 또는 [소비자 약관](https://www.anthropic.com/legal/consumer-terms)(Free, Pro, Max, Ultra 사용자) 및 [개인정보 처리방침](https://www.anthropic.com/legal/privacy)을 검토하세요.

## 데이터 액세스

모든 자체 플랫폼 사용자의 경우, [로컬 Claude Code](#local-claude-code-data-flow-and-dependencies) 및 [원격 Claude Code](#cloud-execution-data-flow-and-dependencies)에 대해 기록되는 데이터에 대해 자세히 알아볼 수 있습니다. [Remote Control](https://code.claude.com/docs/ko/remote-control.md) 세션은 모든 실행이 사용자의 머신에서 발생하므로 로컬 데이터 흐름을 따릅니다. 연결된 상태에서 세션 기록은 [Connection and security](https://code.claude.com/docs/ko/remote-control.md#connection-and-security)에 설명된 대로 디바이스 간 대화를 동기화하기 위해 Anthropic 서버에도 저장됩니다. 원격 Claude Code의 경우 Claude는 Claude Code 세션을 시작한 저장소에 액세스합니다. Claude는 연결했지만 세션을 시작하지 않은 저장소에는 액세스하지 않습니다.

## 로컬 Claude Code: 데이터 흐름 및 종속성

아래 다이어그램은 설치 및 정상 작동 중에 Claude Code가 외부 서비스에 어떻게 연결되는지 보여줍니다. 실선은 필수 연결을 나타내고, 점선은 선택적 또는 사용자가 시작한 데이터 흐름을 나타냅니다.

![Claude Code의 외부 연결을 보여주는 다이어그램: 설치/업데이트는 배포 서버에 연결되고, 사용자 요청은 Anthropic의 Console auth 및 public-api에 연결되며, 선택적으로 Anthropic 및 타사 서비스로 metrics 및 오류 보고서를 전송하는 텔레메트리 흐름이 있습니다. /feedback으로 전송된 피드백은 Google Cloud Storage로 이동하고 선택적으로 GitHub 이슈를 생성합니다](https://mintcdn.com/claude-code/YR4DRZyI3CdsXkiT/images/claude-code-data-flow.svg?fit=max\&auto=format\&n=YR4DRZyI3CdsXkiT\&q=85\&s=2846ea92cfc2297b8620c31c82b482ad)

Claude Code는 로컬에서 실행됩니다. LLM과 상호작용하기 위해 Claude Code는 네트워크를 통해 데이터를 전송합니다. 이 데이터에는 모든 사용자 프롬프트 및 모델 출력이 포함되며, TLS 1.2+ 이상을 통해 전송 중에 암호화됩니다. Claude Code는 대부분의 인기 있는 VPN 및 LLM 프록시와 호환됩니다.

저장 시 암호화는 모델 제공자에 따라 달라집니다:

| 제공자 | 저장 시 암호화 |
| - | - |
| Anthropic API | 인프라 수준 디스크 암호화(AES-256). [Zero Data Retention](https://code.claude.com/docs/ko/zero-data-retention.md)을 활성화하여 서버 측 지속성이 없도록 합니다. |
| Amazon Bedrock | AWS 관리 키를 사용한 AES-256. AWS KMS를 통해 고객 관리 키를 사용할 수 있습니다. |
| Google Cloud의 Agent Platform | Google 관리 암호화 키. CMEK를 사용할 수 있습니다. |
| Microsoft Foundry | 배포의 [호스팅 옵션](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)에 따라 달라집니다. Azure에서 호스팅되는 배포의 경우, 프롬프트 및 완성은 Azure 내에 유지되며, 사용 메타데이터 및 Anthropic의 안전 시스템에 의해 플래그된 콘텐츠만 Anthropic으로 나갑니다. Anthropic에서 호스팅되는 배포의 경우, 요청은 AES-256 디스크 암호화를 사용하는 Anthropic 인프라로 라우팅됩니다. |

Claude Code는 Anthropic의 API를 기반으로 구축되었습니다. API 로깅 절차를 포함한 API 보안 제어에 대한 자세한 내용은 [Anthropic Trust Center](https://trust.anthropic.com)의 규정 준수 아티팩트를 참조하세요.

### 클라우드 실행: 데이터 흐름 및 종속성

[Claude Code on the web](https://code.claude.com/docs/ko/claude-code-on-the-web.md)은 기본적으로 로컬이 아닌 Anthropic 관리 가상 머신에서 실행됩니다. 조직이 [자체 호스팅 환경](https://code.claude.com/docs/ko/self-hosted-environments)으로 라우팅하는 세션은 사용자가 제어하는 인프라에서 실행됩니다. 머신에 유지되는 것과 여전히 Anthropic으로 이동하는 것에 대해서는 [인프라에 유지되는 것](https://code.claude.com/docs/ko/self-hosted-environments#what-stays-on-your-infrastructure)을 참조하세요. Anthropic 호스팅 클라우드 세션에서:

* **코드 및 데이터 저장소:** 저장소가 격리된 VM으로 복제됩니다. Anthropic은 나중에 세션으로 돌아올 수 있도록 세션 기록을 저장합니다. 코드 및 세션 데이터는 계정 유형에 대한 [보관 및 사용 정책](#data-retention)의 적용을 받습니다.
* **자격 증명:** GitHub 자격 증명은 Anthropic의 서버에 암호화되어 저장되며 VM에 절대 입력되지 않습니다. VM의 GitHub 트래픽은 Anthropic 프록시를 통해 이동하며, 서버 측에서 자격 증명을 첨부합니다.
* **네트워크 트래픽:** 모든 아웃바운드 트래픽은 감사 로깅 및 악용 방지를 위해 보안 프록시를 통해 이동합니다.
* **세션 데이터:** 프롬프트, 코드 변경 및 출력은 로컬 Claude Code 사용과 동일한 데이터 정책을 따릅니다.

클라우드 실행의 보안 세부 사항은 [Security](https://code.claude.com/docs/ko/security.md#cloud-execution-security)를 참조하세요.

## 원격 측정 서비스

Claude Code는 두 가지 종류의 운영 원격 측정을 전송합니다: 사용 메트릭과 오류 보고서입니다. 아래의 환경 변수를 사용하여 각각을 개별적으로 끌 수 있으며, `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`을 설정하여 모든 필수가 아닌 트래픽을 한 번에 비활성화할 수 있습니다. `DISABLE_TELEMETRY` 또는 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`을 설정하면 [Remote Control](https://code.claude.com/docs/ko/remote-control.md#requirements)이 의존하는 기능 플래그 평가도 비활성화됩니다. `DISABLE_ERROR_REPORTING`은 그렇지 않습니다.

**메트릭**: 지연 시간, 안정성 및 사용 패턴으로, TLS를 통해 Anthropic 및 타사 로깅 인프라로 전송됩니다. 메트릭에는 코드, 프롬프트 또는 파일 경로가 포함되지 않습니다. `DISABLE_TELEMETRY=1`을 설정하여 거부합니다.

**오류 보고서**: Claude Code의 자체 내부에서 발생한 오류 메시지 및 스택 추적으로, TLS를 통해 타사 오류 추적 서비스로 전송됩니다. Claude Code는 머신을 벗어나기 전에 알려진 패턴의 비밀, 파일 경로, 이메일 주소 및 기타 개인 정보를 제거합니다. `DISABLE_ERROR_REPORTING=1`을 설정하여 거부합니다.

오류 보고는 다음의 모든 조건이 적용될 때만 활성화됩니다:

* Claude Pro, Max 또는 Ultra 구독으로 로그인합니다
* Claude Code v2.1.198 이상을 실행 중입니다
* Claude API에 직접 연결합니다
* 조직에 제로 데이터 보존 또는 HIPAA 계약이 없습니다

`/feedback` 명령을 실행하면 코드를 포함한 대화 기록의 복사본이 Anthropic으로 전송됩니다. `/bug` 및 `/share` 명령은 동일한 경로를 통해 제출됩니다. 피드백 대화 상자에서 보고서를 제출하기 전에 포함할 기록의 양을 선택합니다: 기본값인 현재 세션만 포함하거나, 지난 24시간 또는 7일 동안 같은 프로젝트의 다른 세션도 포함할 수 있습니다. Claude Code는 [Claude가 작성한 피드백](https://code.claude.com/docs/ko/tools-reference.md#sendfeedback-tool-behavior)을 동일한 경로를 통해 제출하며, 초안의 검토 화면에서 포함하도록 선택한 경우 기록을 포함합니다. 데이터는 TLS를 통해 전송 중에 암호화되고 Google Cloud Storage에 저장되며, Google Cloud Storage는 기본적으로 저장된 데이터를 암호화합니다. 선택적으로 공개 저장소에 GitHub 이슈가 생성됩니다. 거부하려면 `DISABLE_FEEDBACK_COMMAND` 환경 변수를 `1`로 설정합니다.

Amazon Bedrock 또는 Google Cloud의 Agent Platform과 같은 타사 제공자를 사용하거나 Anthropic 자격 증명이 구성되지 않은 경우, `/feedback`은 보고서를 Anthropic으로 전송하는 대신 `~/.claude/feedback-bundles/` 아래의 로컬 아카이브에 작성합니다. 알려진 API 키 및 토큰 패턴은 아카이브가 작성되기 전에 제거됩니다. 파일을 Anthropic 계정 담당자에게 보내거나 지원 요청에 첨부할 때까지 머신을 벗어나지 않습니다.

## API 제공자별 기본 동작

기본적으로 Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry 또는 AWS의 Claude Platform을 사용할 때 오류 보고, 원격 측정 및 버그 보고가 비활성화됩니다. 세션 품질 설문조사 및 WebFetch 도메인 안전 검사는 예외이며 제공자와 관계없이 실행됩니다. 서명된 [Claude 앱 게이트웨이](https://code.claude.com/docs/ko/claude-apps-gateway) 세션에서는 게이트웨이 자격 증명 자체에 의해 Anthropic에 대한 사용 분석, 오류 보고 및 설문조사 평가가 비활성화되며, 이를 다시 활성화할 수 있는 설정이 없습니다. `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`을 설정하여 설문조사를 포함한 모든 필수가 아닌 트래픽을 한 번에 거부할 수 있습니다. 이 변수는 WebFetch 검사 또는 공식 플러그인 마켓플레이스 자동 설치에 영향을 주지 않습니다. 각각 자체 거부 옵션이 있습니다: WebFetch의 경우 [settings](https://code.claude.com/docs/ko/settings.md)의 `skipWebFetchPreflight`, 마켓플레이스의 경우 `CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL`. 다음은 전체 기본 동작입니다:

| 서비스 | Claude API | Google Cloud의 Agent Platform API | Amazon Bedrock API | Microsoft Foundry API | AWS의 Claude Platform |
| - | - | - | - | - | - |
| **메트릭** | 기본 켜짐. `DISABLE_TELEMETRY=1`로 비활성화합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_VERTEX`는 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_BEDROCK`은 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_FOUNDRY`는 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_ANTHROPIC_AWS`는 1이어야 합니다. |
| **오류 보고** | v2.1.198+에서 Pro, Max 및 Ultra 로그인의 경우 켜짐, 그 외에는 꺼짐. `DISABLE_ERROR_REPORTING=1`로 비활성화합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_VERTEX`는 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_BEDROCK`은 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_FOUNDRY`는 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_ANTHROPIC_AWS`는 1이어야 합니다. |
| **Claude API (`/feedback` 보고)** | 기본 켜짐. `DISABLE_FEEDBACK_COMMAND=1`로 비활성화합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_VERTEX`는 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_BEDROCK`은 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_FOUNDRY`는 1이어야 합니다. | 기본 꺼짐. `CLAUDE_CODE_USE_ANTHROPIC_AWS`는 1이어야 합니다. |
| **세션 품질 설문조사** | 기본 켜짐. `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1`로 비활성화합니다. | 기본 켜짐. `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1`로 비활성화합니다. | 기본 켜짐. `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1`로 비활성화합니다. | 기본 켜짐. `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1`로 비활성화합니다. | 기본 켜짐. `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1`로 비활성화합니다. |
| **WebFetch 도메인 안전 검사** | 기본 켜짐. [settings](https://code.claude.com/docs/ko/settings.md)에서 `skipWebFetchPreflight: true`로 비활성화합니다. | 기본 켜짐. [settings](https://code.claude.com/docs/ko/settings.md)에서 `skipWebFetchPreflight: true`로 비활성화합니다. | 기본 켜짐. [settings](https://code.claude.com/docs/ko/settings.md)에서 `skipWebFetchPreflight: true`로 비활성화합니다. | 기본 켜짐. [settings](https://code.claude.com/docs/ko/settings.md)에서 `skipWebFetchPreflight: true`로 비활성화합니다. | 기본 켜짐. [settings](https://code.claude.com/docs/ko/settings.md)에서 `skipWebFetchPreflight: true`로 비활성화합니다. |

모든 환경 변수는 `settings.json`에 체크인할 수 있습니다([settings reference](https://code.claude.com/docs/ko/settings-reference.md) 참조).

호스트 플랫폼이 `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST`를 설정하면, Google Cloud의 Agent Platform, Amazon Bedrock, Microsoft Foundry 및 AWS의 Claude Platform에서 메트릭은 기본적으로 켜지며 표준 `DISABLE_TELEMETRY` 거부 옵션을 따릅니다. 오류 보고 및 `/feedback` 보고는 해당 제공자에서 기본적으로 꺼진 상태로 유지됩니다.

### WebFetch 도메인 안전 검사

URL을 가져오기 전에 WebFetch 도구는 요청된 호스트명을 `api.anthropic.com`으로 전송하여 Anthropic에서 유지 관리하는 안전 차단 목록에 대해 확인합니다. 전체 URL, 경로 또는 페이지 내용이 아닌 호스트명만 전송됩니다. Claude Code는 검사를 통과한 호스트명을 5분 동안 캐시하며, 차단되거나 실패한 호스트명은 다음 요청 시 다시 확인합니다.

이 검사는 사용하는 모델 제공자와 관계없이 실행되며 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`의 영향을 받지 않습니다. 네트워크가 `api.anthropic.com`을 차단하는 경우, WebFetch 요청은 도메인을 허용 목록에 추가하거나 [settings](https://code.claude.com/docs/ko/settings.md)에서 `skipWebFetchPreflight: true`를 설정할 때까지 실패합니다. 검사를 비활성화하면 WebFetch가 차단 목록을 참조하지 않고 모든 URL을 검색하려고 시도하므로, Claude가 도달할 수 있는 도메인을 제한해야 하는 경우 [`WebFetch` permission rules](https://code.claude.com/docs/ko/permissions#webfetch)와 함께 사용합니다.
