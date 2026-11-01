> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Google Cloud의 Agent Platform에서 Claude Code 사용하기

> Google Cloud의 Agent Platform(이전 Vertex AI)을 통해 Claude Code를 구성하는 방법을 알아봅니다. 설정, IAM 구성 및 문제 해결을 포함합니다.

**Deploying Claude Code across your organization?** Talk to sales about enterprise plans, SSO, and centralized billing.

View plans
Contact sales

## 필수 요구사항

Google Cloud의 Agent Platform(이전의 Vertex AI)을 사용하여 Claude Code를 구성하기 전에 다음을 확인하십시오:

* 청구가 활성화된 Google Cloud Platform(GCP) 계정
* Google Cloud의 Agent Platform API가 활성화된 GCP 프로젝트
* 원하는 Claude 모델에 대한 액세스(예: Claude Sonnet 4.6)
* Google Cloud SDK(`gcloud`) 설치 및 구성
* 원하는 GCP 지역에 할당된 할당량

자신의 Google Cloud의 Agent Platform 자격증명으로 로그인하려면 아래의 [Google Cloud의 Agent Platform으로 로그인](#sign-in-with-agent-platform)을 따르십시오. 팀 전체에 Claude Code를 배포하려면 [수동 설정](#set-up-manually) 단계를 사용하고 롤아웃 전에 [모델 버전을 고정](#5-pin-model-versions)하십시오.

## Agent Platform으로 로그인

Google Cloud 자격증명이 있고 Google Cloud의 Agent Platform을 통해 Claude Code 사용을 시작하려면 로그인 마법사가 이를 안내합니다. GCP 측 필수 요구사항을 프로젝트당 한 번 완료하면 마법사가 Claude Code 측을 처리합니다.

**1. GCP 프로젝트에서 Claude 모델 활성화**

프로젝트에 대해 [Google Cloud의 Agent Platform API 활성화](#1-enable-agent-platform-api)한 다음 [Google Cloud의 Agent Platform Model Garden](https://console.cloud.google.com/vertex-ai/model-garden)에서 원하는 Claude 모델에 대한 액세스를 요청합니다. 계정에 필요한 권한은 [IAM 구성](#iam-configuration)을 참조하십시오.

**2. Claude Code를 시작하고 Google Cloud의 Agent Platform 선택**

`claude`를 실행합니다. 로그인 프롬프트에서 **3rd-party platform**을 선택한 다음 **Google Vertex AI**를 선택합니다. 이는 로그인 프롬프트가 Google Cloud의 Agent Platform에 대해 여전히 사용하는 레이블입니다. 이미 로그인한 경우 `/login`을 실행하여 동일한 메뉴를 엽니다.

**3. 마법사 프롬프트 따르기**

Google Cloud에 인증하는 방법을 선택합니다: `gcloud`의 Application Default Credentials, 서비스 계정 키 파일 또는 환경에 이미 있는 자격증명. 마법사는 프로젝트와 지역을 감지하고, 프로젝트가 호출할 수 있는 Claude 모델을 확인하며, 이를 고정할 수 있게 합니다. 결과를 [사용자 설정 파일](https://code.claude.com/docs/ko/settings.md)의 `env` 블록에 저장하므로 환경 변수를 직접 내보낼 필요가 없습니다.

로그인한 후 언제든지 `/setup-vertex`를 실행하여 마법사를 다시 열고 자격증명, 프로젝트, 지역 또는 모델 고정을 변경할 수 있습니다. 모델 고정 단계는 현재 고정된 모델에서 시작됩니다. 마법사는 `~/.claude/settings.json`에 쓰거나, [`CLAUDE_CONFIG_DIR`](https://code.claude.com/docs/ko/env-vars#variables)이 설정되어 있을 때 `$CLAUDE_CONFIG_DIR/settings.json`에 씁니다.

## 지역 구성

Claude Code는 Google Cloud의 Agent Platform [전역](https://cloud.google.com/blog/products/ai-machine-learning/global-endpoint-for-claude-models-generally-available-on-vertex-ai), 다중 지역 및 지역 엔드포인트를 지원합니다. `CLOUD_ML_REGION`을 `global`, `eu` 또는 `us`와 같은 다중 지역 위치 또는 `us-east5`와 같은 특정 지역으로 설정합니다. Claude Code는 `aiplatform.eu.rep.googleapis.com` 및 `aiplatform.us.rep.googleapis.com` 호스트를 포함한 다중 지역 위치에 대해 각 형식에 맞는 올바른 Google Cloud의 Agent Platform 호스트명을 선택합니다.

> [!NOTE]
>
> Google Cloud의 Agent Platform은 모든 엔드포인트 유형에서 Claude Code 기본 모델을 지원하지 않을 수 있습니다. 모델 가용성은 [특정 지역](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations#genai-partner-models), 다중 지역 위치 및 [전역 엔드포인트](https://cloud.google.com/vertex-ai/generative-ai/docs/partner-models/use-partner-models#supported_models)에 따라 다릅니다. 지원되는 위치로 전환하거나 지원되는 모델을 지정해야 할 수 있습니다.

## 수동으로 설정

마법사 대신 환경 변수를 통해 Google Cloud의 Agent Platform을 구성하려면(예: CI 또는 스크립트된 엔터프라이즈 롤아웃의 경우), 아래 단계를 따릅니다.

### Agent Platform API 활성화

GCP 프로젝트에서 Google Cloud의 Agent Platform API를 활성화합니다. `YOUR-PROJECT-ID`를 GCP 프로젝트 ID로 바꾸고 아래 구성 단계에서도 바꿉니다:

```bash theme={null}
# 프로젝트 ID 설정
gcloud config set project YOUR-PROJECT-ID

# Agent Platform API 활성화
gcloud services enable aiplatform.googleapis.com
```

### 모델 액세스 요청

Google Cloud의 Agent Platform에서 Claude 모델에 대한 액세스를 요청합니다:

1. [Google Cloud의 Agent Platform Model Garden](https://console.cloud.google.com/vertex-ai/model-garden)으로 이동합니다
2. "Claude" 모델을 검색합니다
3. 원하는 Claude 모델에 대한 액세스를 요청합니다(예: Claude Sonnet 4.6)
4. 승인을 기다립니다(24\~48시간이 소요될 수 있음)

### GCP 자격증명 구성

Claude Code는 표준 Google Cloud 인증을 사용합니다.

자세한 내용은 [Google Cloud 인증 설명서](https://cloud.google.com/docs/authentication)를 참조하세요.

Claude Code는 동일한 Application Default Credentials 체인을 통해 [X.509 인증서 기반 Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation-with-x509-certificates)을 지원합니다. `GOOGLE_APPLICATION_CREDENTIALS`를 자격증명 구성 파일의 경로로 설정합니다.

> [!NOTE]
>
> Claude Code는 `GCLOUD_PROJECT`, `GOOGLE_CLOUD_PROJECT` 또는 `GOOGLE_APPLICATION_CREDENTIALS`에서 참조하는 자격증명 파일이 다른 프로젝트를 나타내더라도 `ANTHROPIC_VERTEX_PROJECT_ID`의 프로젝트에 Google Cloud의 Agent Platform 요청을 주소 지정합니다.

#### 고급 자격증명 구성

Claude Code는 `gcpAuthRefresh` 설정을 통해 GCP의 자동 자격증명 새로 고침을 지원합니다. Claude Code [설정 파일](https://code.claude.com/docs/ko/settings.md)(예: `~/.claude/settings.json`)에 추가합니다. Claude Code가 GCP 자격증명이 만료되었거나 로드할 수 없음을 감지하면 요청을 다시 시도하기 전에 구성된 명령을 실행하여 새 자격증명을 얻습니다.

```json theme={null}
{
  "gcpAuthRefresh": "gcloud auth application-default login",
  "env": {
    "ANTHROPIC_VERTEX_PROJECT_ID": "your-project-id"
  }
}
```

명령을 실행하기 전에 Claude Code는 현재 자격증명으로 액세스 토큰을 요청하여 실제로 만료되었는지 확인하고 여전히 작동하면 명령을 건너뜁니다.

확인이 5초 이내에 완료되지 않으면 Claude Code도 명령을 건너뛰고 요청이 자격증명 오류로 실패한 후에만 실행합니다. v2.1.261 이전에는 시간 초과된 확인이 만료된 자격증명으로 계산되었으므로 자격증명이 여전히 유효했음에도 불구하고 명령이 시작 시 브라우저를 열 수 있었습니다.

Claude Code는 명령의 출력을 표시하지만 명령에 대화형 입력을 보낼 수 없습니다. 이는 CLI가 URL을 표시하고 브라우저에서 인증을 완료하는 브라우저 기반 인증 흐름에서 잘 작동합니다. 인증이 완료되지 않으면 새로 고침 명령은 3분 후에 시간 초과됩니다. `.claude/settings.json`과 같은 프로젝트 설정에서 `gcpAuthRefresh`를 설정하면 Claude Code는 [설정 파일의 훅에 대한 동일한 작업 공간 신뢰 규칙](https://code.claude.com/docs/ko/permissions.md#what-runs-before-you-trust-a-folder) 아래에서 실행되며, 여기에는 신뢰한 적이 없는 폴더의 `-p` 세션이 포함됩니다.

### Claude Code 구성

다음 환경 변수를 설정합니다:

```bash theme={null}
# Agent Platform 통합 활성화
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=global
export ANTHROPIC_VERTEX_PROJECT_ID=YOUR-PROJECT-ID

# 선택 사항: 사용자 지정 엔드포인트 또는 게이트웨이에 대해 Agent Platform 엔드포인트 URL 재정의
# export ANTHROPIC_VERTEX_BASE_URL=https://aiplatform.googleapis.com

# CLOUD_ML_REGION=global일 때 글로벌 엔드포인트를 지원하지 않는 모델에 대해 지역 재정의
export VERTEX_REGION_CLAUDE_HAIKU_4_5=us-east5
export VERTEX_REGION_CLAUDE_4_6_SONNET=europe-west1
```

대부분의 모델 버전에는 해당하는 `VERTEX_REGION_CLAUDE_*` 변수가 있습니다. 전체 목록은 [환경 변수 참조](https://code.claude.com/docs/ko/env-vars.md#variables)를 참조하세요. [Google Cloud의 Agent Platform Model Garden](https://console.cloud.google.com/vertex-ai/model-garden)을 확인하여 어떤 모델이 글로벌 엔드포인트를 지원하는지 또는 지역 전용인지 확인합니다.

지역 값이 지역 또는 위치 이름처럼 보이지 않으면 Claude Code는 이를 설정되지 않은 것으로 취급합니다. 예를 들어 Claude Code는 슬래시, 점 또는 공백을 포함하는 값을 설정되지 않은 것으로 취급합니다. Claude Code는 각 변수에 대해 다른 소스로 폴백합니다:

* `VERTEX_REGION_CLAUDE_*`: Claude Code는 `CLOUD_ML_REGION`으로 폴백합니다.
* `CLOUD_ML_REGION`: Claude Code는 `us-east5`로 폴백합니다.

[프롬프트 캐싱](https://code.claude.com/docs/ko/prompt-caching.md)은 자동으로 활성화됩니다. 비활성화하려면 `DISABLE_PROMPT_CACHING=1`을 설정합니다. 기본값인 5분 대신 1시간 캐시 TTL을 요청하려면 `ENABLE_PROMPT_CACHING_1H=1`을 설정합니다. 1시간 TTL을 사용한 캐시 쓰기는 더 높은 요금으로 청구됩니다. 주 대화와 Claude Code가 외부에서 수행하는 요청에 대해 다른 TTL을 설정하려면 [TTL을 직접 선택](https://code.claude.com/docs/ko/prompt-caching.md#choose-the-ttl-yourself)합니다.

요금 한도를 높이려면 Google Cloud 지원팀에 문의합니다. Google Cloud의 Agent Platform을 사용할 때 `/logout` 명령은 Google Cloud 자격증명을 통해 인증이 처리되므로 사용할 수 없습니다.

Claude Code는 [MCP 도구 검색](https://code.claude.com/docs/ko/mcp.md#scale-with-mcp-tool-search)과 사전 로딩 중에서 모델 생성에 따라 결정합니다:

* **Claude Opus 4.5, Sonnet 4.5, Haiku 4.5 및 이후 버전**: Claude Code는 기본적으로 도구 검색을 활성화합니다.
* **이전 모델**: Claude Code는 필요한 베타 헤더를 거부하는 Agent Platform 서빙 스택 때문에 MCP 도구 정의를 사전에 로드합니다. `ENABLE_TOOL_SEARCH=true`를 설정해도 이를 재정의하지 않습니다.

모든 모델에서 도구 검색을 비활성화하려면 `ENABLE_TOOL_SEARCH=false`를 설정합니다. v2.1.221 이전에는 Claude Code가 `ENABLE_TOOL_SEARCH=true`를 설정하지 않는 한 Google Cloud의 Agent Platform의 모든 모델에 대해 도구 검색을 비활성화했습니다.

### 모델 버전 고정

> [!WARNING]
>
> 여러 사용자에게 배포할 때 특정 모델 버전을 고정합니다. 고정하지 않으면 `sonnet` 및 `opus`와 같은 모델 별칭이 Claude Code의 Google Cloud의 Agent Platform에 대한 기본 제공 기본값으로 확인되며, 이는 최신 릴리스보다 뒤떨어질 수 있고 프로젝트에서 아직 활성화되지 않았을 수 있습니다. Claude Code는 기본값을 사용할 수 없을 때 시작 시 [이전 또는 낮은 계층 모델로 폴백](#startup-model-checks)하지만 고정하면 사용자가 새 모델로 이동하는 시기를 제어할 수 있습니다.

이러한 환경 변수를 특정 Google Cloud의 Agent Platform 모델 ID로 설정합니다.

`ANTHROPIC_DEFAULT_OPUS_MODEL` 없이는 Google Cloud의 Agent Platform의 `opus` 별칭이 Opus 5.5로 확인되고, `ANTHROPIC_DEFAULT_SONNET_MODEL` 없이는 `sonnet` 별칭이 Sonnet 4.5로 확인됩니다. 이 예제는 각 별칭을 특정 버전으로 고정합니다:

```bash theme={null}
export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8'
export ANTHROPIC_DEFAULT_SONNET_MODEL='claude-sonnet-5'
export ANTHROPIC_DEFAULT_HAIKU_MODEL='claude-haiku-4-5@20251001'
```

현재 및 레거시 모델 ID는 [모델 개요](https://platform.claude.com/docs/en/about-claude/models/overview)를 참조하세요. 전체 환경 변수 목록은 [모델 구성](https://code.claude.com/docs/ko/model-config.md#pin-models-for-third-party-deployments)을 참조하세요.

고정 변수가 설정되지 않으면 Claude Code는 이러한 기본 모델을 사용합니다:

| 모델 유형 | 기본값 |
| :- | :- |
| 주 모델 | `claude-opus-5-5` |
| 소형/빠른 모델 | `claude-sonnet-4-5@20250929` |

v2.1.280 이전에는 Google Cloud의 Agent Platform의 주 모델이 기본적으로 Opus 5였고 v2.1.219부터 `opus` 별칭이 Opus 5로 확인되었습니다.

세션 제목 생성과 같은 백그라운드 작업은 소형/빠른 모델(일반적으로 Haiku 클래스 모델)을 사용합니다. Google Cloud의 Agent Platform에서 Claude Code는 모든 프로젝트 또는 지역에서 Haiku를 활성화하지 않을 수 있으므로 백그라운드 작업에 기본 Sonnet 모델을 사용합니다. 두 가지 선택이 어떤 모델이 이를 수행하는지 변경합니다:

* `--model`, `ANTHROPIC_MODEL` 또는 `model` 설정으로 주 모델을 선택하면 백그라운드 작업이 해당 모델을 사용합니다. Claude Code가 [`ANTHROPIC_DEFAULT_MODEL`](https://code.claude.com/docs/ko/model-config#set-a-default-model-for-new-sessions)로 설정한 모델에서 세션을 시작하면 백그라운드 작업도 해당 모델을 사용합니다. `ANTHROPIC_DEFAULT_SONNET_MODEL` 없이 `ANTHROPIC_DEFAULT_OPUS_MODEL`을 설정하는 것도 선택으로 계산됩니다. 자체 Opus를 조종하는 프로젝트에서는 기본 제공 Sonnet 모델을 활성화하지 않을 수 있기 때문입니다.
* 백그라운드 작업에 Haiku를 사용하려면 `ANTHROPIC_DEFAULT_HAIKU_MODEL`을 프로젝트에서 사용 가능한 모델 ID로 설정합니다.

> [!WARNING]
>
> Opus 모델은 Sonnet 모델보다 토큰당 가격이 높으므로 주 모델을 고정하지 않으면 Opus 요금으로 청구됩니다. Sonnet 4.5를 주 모델로 사용하려면 `ANTHROPIC_MODEL`을 전체 모델 ID로 설정합니다. `ANTHROPIC_DEFAULT_SONNET_MODEL`로 기본값을 조종하고 `ANTHROPIC_DEFAULT_OPUS_MODEL`을 설정하지 않는 배포는 조종된 Sonnet 모델을 기본값으로 유지합니다.

모델을 추가로 사용자 지정하려면:

```bash theme={null}
export ANTHROPIC_MODEL='claude-opus-4-8'
export ANTHROPIC_DEFAULT_HAIKU_MODEL='claude-haiku-4-5@20251001'
```

### 구성 확인

Claude Code를 시작하고 `/status`를 실행하여 설정을 확인합니다. `API provider` 줄은 `Google Vertex AI`를 표시하고, `GCP project`, `Default region` 및 `Model` 줄은 프로젝트 ID, 지역 및 확인된 모델을 표시합니다. 공급자 줄이 없으면 환경 변수가 프로세스에 도달하지 않습니다. `claude`를 시작한 셸에서 내보내졌는지 확인하거나 [설정 파일](https://code.claude.com/docs/ko/settings.md)의 `env` 블록에서 설정합니다.

## 시작 모델 확인

Claude Code가 Google Cloud의 Agent Platform으로 구성되어 시작할 때 사용하려는 모델이 프로젝트에서 액세스 가능한지 확인합니다.

현재 Claude Code 기본값보다 오래된 모델 버전을 고정했고 프로젝트가 최신 버전을 호출할 수 있으면 Claude Code는 고정을 업데이트하라는 메시지를 표시합니다. 수락하면 새 모델 ID를 [사용자 설정 파일](https://code.claude.com/docs/ko/settings.md)에 쓰고 Claude Code를 다시 시작합니다. 거절하면 다음 기본 버전 변경까지 기억됩니다.

모델을 고정하지 않았고 현재 기본값을 프로젝트에서 사용할 수 없으면 Claude Code는 현재 세션에 대해 이전 버전으로 폴백하고 알림을 표시합니다. 기본값이 Opus 모델이고 사용 가능한 Opus 버전이 없으면 기본 Sonnet 모델로 폴백합니다. 폴백은 유지되지 않습니다. [Model Garden](https://console.cloud.google.com/vertex-ai/model-garden)에서 최신 모델을 활성화하거나 [버전을 고정](#5-pin-model-versions)하여 선택을 영구적으로 만듭니다.

특정 Sonnet 또는 Opus 버전에서 세션을 시작할 때(예: `--model`, `ANTHROPIC_MODEL` 또는 [`model` 설정](https://code.claude.com/docs/ko/settings-reference#model)을 사용하여), 해당 버전은 일치하는 `sonnet` 또는 `opus` 별칭에 대한 세션의 고정된 기본값으로 작동합니다. Claude Code는 모델이 대체하는 기본 제공 기본값에 대한 가용성 확인을 건너뛰고 구성한 모델에서 시작하며 폴백 알림이 없습니다.

`opus`와 같은 모델 별칭은 고정으로 작동하지 않으며, Claude Code가 인식하지 못하는 모델 ID도 마찬가지입니다.

이러한 확인에서 프로젝트가 호출할 수 없는 모델을 찾으면 Claude Code는 이 머신에서 거부를 최대 하루 동안 기억하고, 그 시간 동안 기억된 모델을 건너뛰고 Agent Platform에 다시 묻지 않고 시작합니다. Claude Code는 마지막 확인 이후 10분이 경과한 현재 기본 모델의 거부를 시작할 때 다시 확인하므로, 관리자가 다시 활성화한 기본값이 돌아옵니다. 메모리를 끄려면 [`CLAUDE_CODE_SKIP_MODEL_ACCESS_MEMORY=1`](https://code.claude.com/docs/ko/env-vars)을 설정합니다.

### 조직에서 모델 허용 목록을 적용하는 경우

관리형 설정에서 [`enforceAvailableModels`](https://code.claude.com/docs/ko/model-config#enforce-the-allowlist-for-the-default-model)를 설정하면 시작 모델 확인은 `availableModels` 목록에서 허용하는 모델만 사용합니다. 이 기능에는 Claude Code v2.1.287 이상이 필요합니다. `enforceAvailableModels`가 없는 목록은 이러한 확인을 제한하지 않습니다.

확인 과정에서는 각 항목을 Agent Platform으로 보낼 모델 ID와 비교하므로, 목록은 해당 ID로 작성합니다. 다음 예시는 Opus 4.8과 Sonnet 4.5를 허용합니다.

```json theme={null}
{
  "availableModels": ["claude-opus-4-8", "claude-sonnet-4-5@20250929"],
  "enforceAvailableModels": true
}
```

별칭, 버전 접두사 및 `modelOverrides` 항목에 대해서는 [타사 배포를 위한 모델 고정](https://code.claude.com/docs/ko/model-config.md#pin-models-for-third-party-deployments)을 참조하세요.

### 세션 중에 모델이 비활성화될 때

프로젝트가 세션이 실행 중인 모델에 대한 액세스를 잃으면(예: 관리자가 [Model Garden](https://console.cloud.google.com/vertex-ai/model-garden)에서 비활성화하는 경우), Claude Code는 각 요청이 실패하는 대신 세션을 다른 모델로 전환하고 `Switched to <fallback> because <model> is not available`을 표시합니다. 시작 폴백과 동일한 모델을 시도합니다: 먼저 동일한 계층의 이전 버전이고, Opus 세션에서 사용 가능한 Opus 버전이 없으면 기본 Sonnet 모델입니다.

전환은 고정하지 않은 계층에만 적용되며, 이는 시작 폴백과 동일한 조건입니다. 선택한 특정 버전의 세션은 모델을 유지하고, 폴백 모델 체인이 없으면 요청이 실패합니다. [자동 모드](https://code.claude.com/docs/ko/permission-modes.md#enable-auto-mode-on-bedrock-agent-platform-or-foundry)에서 Claude Code는 Agent Platform에서 자동 모드가 지원하는 모델로만 전환합니다. 해당 모델도 사용 가능하지 않으면 요청이 실패합니다.

구성한 [폴백 모델 체인](https://code.claude.com/docs/ko/model-config.md#fallback-model-chains)은 계층 전환을 대체합니다: 이러한 거부에서 Claude Code는 구성한 폴백으로 전환합니다. 거부된 요청이 전환되지 않고 실패하도록 하려면 [`CLAUDE_CODE_DISABLE_MODEL_ACCESS_FALLBACK=1`](https://code.claude.com/docs/ko/env-vars)을 설정합니다. 구성한 폴백 체인은 여전히 이러한 거부에서 전환합니다. 모든 거부된 요청이 실패하도록 하려면 체인도 제거합니다.

## IAM 구성

`roles/aiplatform.user` 역할을 할당합니다. 이 역할에는 필요한 권한이 포함됩니다:

* `aiplatform.endpoints.predict` - 모델 호출 및 토큰 계산에 필요

더 제한적인 권한의 경우 위의 권한만 포함하는 사용자 정의 역할을 만듭니다.

자세한 내용은 [Google Cloud의 Vertex AI IAM 설명서](https://cloud.google.com/vertex-ai/docs/general/access-control)를 참조하십시오.

> [!NOTE]
>
> 비용 추적 및 액세스 제어를 단순화하기 위해 Claude Code용 전용 GCP 프로젝트를 만듭니다.

## 1M 토큰 context window

Fable 모델, Sonnet 5 이상, Opus 4.7 이상은 Google Cloud의 Agent Platform에서 기본적으로 [1M 토큰 컨텍스트 윈도우](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)로 실행되며, `[1m]` 접미사가 필요하지 않습니다. 대신 200K 윈도우를 유지하려면 [`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](https://code.claude.com/docs/ko/model-config#turn-off-1m-context)을 설정합니다.

Opus 4.6 및 Sonnet 4.6은 `[1m]` 변형을 선택하면 1M 윈도우를 사용할 수 있습니다. [설정 마법사](#sign-in-with-agent-platform)는 모델을 고정할 때 1M 컨텍스트 옵션을 제공합니다. 수동으로 고정된 모델에 대해 대신 활성화하려면 모델 ID에 `[1m]`을 추가합니다. 고정을 변경하지 않고 1M 윈도우를 사용하는 방법을 포함한 자세한 내용은 [타사 배포를 위한 모델 고정](https://code.claude.com/docs/ko/model-config.md#pin-models-for-third-party-deployments)을 참조하십시오.

v2.1.287 이전에는 Fable 모델과 Opus 4.7 이상이 Google Cloud의 Agent Platform에서 기본적으로 200K 윈도우로 실행되었으며, `[1m]` 접미사를 통해 1M 윈도우를 사용할 수 있었습니다.

## 문제 해결

"기본 자격증명을 로드할 수 없음" 오류가 발생하는 경우:

* `gcloud auth application-default login`을 실행하여 Application Default Credentials를 설정합니다
* `GOOGLE_APPLICATION_CREDENTIALS`를 서비스 계정 키 파일 경로로 설정합니다
* 모든 옵션은 [GCP 자격증명 구성](#3-configure-gcp-credentials)을 참조하세요

할당량 문제가 발생하는 경우:

* [Cloud Console](https://cloud.google.com/docs/quotas/view-manage)을 통해 현재 할당량을 확인하거나 할당량 증가를 요청합니다

"모델을 찾을 수 없음" 404 오류가 발생하는 경우:

* [Model Garden](https://console.cloud.google.com/vertex-ai/model-garden)에서 모델이 활성화되어 있는지 확인합니다
* 지정된 위치에서 모델을 사용할 수 있는지 확인합니다. 일부 모델은 특정 지역이 아닌 `global` 또는 `eu` 및 `us`와 같은 다중 지역 위치에서만 제공됩니다
* `CLOUD_ML_REGION=global`을 사용하는 경우 [Model Garden](https://console.cloud.google.com/vertex-ai/model-garden)의 "지원되는 기능" 아래에서 모델이 전역 엔드포인트를 지원하는지 확인합니다. 전역 엔드포인트를 지원하지 않는 모델의 경우:
  * `ANTHROPIC_MODEL` 또는 `ANTHROPIC_DEFAULT_HAIKU_MODEL`을 통해 지원되는 모델을 지정하거나,
  * [환경 변수 참조](https://code.claude.com/docs/ko/env-vars.md#variables)에 나열된 해당 모델의 `VERTEX_REGION_CLAUDE_*` 변수를 사용하여 지역 또는 다중 지역 위치를 설정합니다

429 오류가 발생하는 경우:

* 지역 엔드포인트의 경우 주 모델과 소형/빠른 모델이 선택한 지역에서 지원되는지 확인합니다
* `CLOUD_ML_REGION=global`로 전환하여 더 나은 가용성을 고려합니다

## 추가 리소스

* [Google Cloud의 Agent Platform 설명서](https://cloud.google.com/vertex-ai/docs)
* [Google Cloud의 Agent Platform 가격](https://cloud.google.com/vertex-ai/pricing)
* [Google Cloud의 Agent Platform 할당량 및 제한](https://cloud.google.com/vertex-ai/docs/quotas)
