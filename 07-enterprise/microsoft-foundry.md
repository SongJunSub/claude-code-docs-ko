> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# Microsoft Foundry의 Claude Code

> 설정, 구성 및 문제 해결을 포함하여 Microsoft Foundry를 통해 Claude Code를 구성하는 방법을 알아봅니다.

**Deploying Claude Code across your organization?** Talk to sales about enterprise plans, SSO, and centralized billing.

View plans
Contact sales

## 필수 조건

Microsoft Foundry로 Claude Code를 구성하기 전에 다음을 확인하세요:

* Microsoft Foundry에 액세스할 수 있는 Azure 구독
* Microsoft Foundry 리소스 및 배포를 만들 수 있는 RBAC 권한
* Azure CLI 설치 및 구성(선택 사항 - 자격 증명을 얻을 다른 메커니즘이 없는 경우에만 필요)

> [!NOTE]
>
> Claude Code를 여러 사용자에게 배포하는 경우 롤아웃하기 전에 [모델 버전을 고정](#4-pin-model-versions)하세요.

## 설정

### Microsoft Foundry 리소스 프로비저닝

먼저 Azure에서 Claude 리소스를 만듭니다:

1. [Microsoft Foundry 포털](https://ai.azure.com/)로 이동합니다
2. 새 리소스를 만들고 리소스 이름을 기록합니다
3. Claude 모델에 대한 배포를 만들고 각 배포에 지정한 배포 이름을 기록합니다. 4단계에서 이 이름들을 모델 변수로 설정합니다:

   * Claude Opus
   * Claude Sonnet
   * Claude Haiku

   배포를 구성할 때 [호스팅 옵션](https://platform.claude.com/docs/en/build-with-claude/claude-in-microsoft-foundry#hosting-options)도 선택합니다. 이는 추론이 Azure에서 실행되는지 아니면 Anthropic 인프라에서 실행되는지를 결정합니다.

### Azure 자격 증명 구성

Claude Code는 Microsoft Foundry에 대해 세 가지 인증 방법을 지원합니다. 보안 요구 사항에 가장 적합한 방법을 선택하세요.

* [API 키](#use-an-api-key): Microsoft Foundry 포털에서 키를 복사하여 `ANTHROPIC_FOUNDRY_API_KEY`로 설정합니다
* [Microsoft Entra ID](#use-microsoft-entra-id): Claude Code가 Azure SDK 기본 자격 증명 체인을 통해(예: `az login` 세션에서) 토큰을 얻으므로 저장할 API 키가 없습니다
* [Bearer 토큰](#use-a-bearer-token): 다른 프로세스가 Microsoft Entra ID 액세스 토큰을 얻고, 이를 `ANTHROPIC_FOUNDRY_AUTH_TOKEN`으로 전달합니다

> [!NOTE]
>
> Microsoft Foundry를 사용할 때 `/logout` 명령은 Azure 자격 증명을 통해 인증이 처리되므로 사용할 수 없습니다.

#### API 키 사용

Microsoft Foundry 포털에서 키를 복사한 다음 환경 변수로 설정합니다:

1. Microsoft Foundry 포털에서 리소스로 이동합니다
2. **엔드포인트 및 키** 섹션을 엽니다
3. **API 키**를 복사합니다
4. 환경 변수를 설정합니다. `your-azure-api-key`를 복사한 키로 바꾸세요:

```bash theme={null}
export ANTHROPIC_FOUNDRY_API_KEY=your-azure-api-key
```

#### Microsoft Entra ID 사용

`ANTHROPIC_FOUNDRY_API_KEY`와 `ANTHROPIC_FOUNDRY_AUTH_TOKEN`을 설정하지 않은 상태로 둡니다. 그러면 Claude Code는 Azure SDK [기본 자격 증명 체인](https://learn.microsoft.com/en-us/azure/developer/javascript/sdk/authentication/credential-chains#defaultazurecredential-overview)을 사용합니다.
이는 로컬 및 원격 워크로드를 인증하기 위한 다양한 방법을 지원합니다.

로컬 머신에서는 Azure CLI로 로그인합니다:

```bash theme={null}
az login
```

ID에 필요한 역할은 [Azure RBAC 구성](#azure-rbac-configuration)을 참조하세요.

#### Bearer 토큰 사용

Claude Code는 모든 요청에서 `ANTHROPIC_FOUNDRY_AUTH_TOKEN`의 값을 `Authorization: Bearer` 헤더로 전송합니다. 호스트 애플리케이션이나 로그인 스크립트와 같은 다른 프로세스가 이미 액세스 토큰을 얻은 경우 이 옵션을 사용합니다.

변수를 Microsoft Entra ID가 리소스에 대해 발급한 bearer 토큰으로 설정합니다:

```bash theme={null}
export ANTHROPIC_FOUNDRY_AUTH_TOKEN=your-entra-access-token
```

`ANTHROPIC_FOUNDRY_AUTH_TOKEN`은 `ANTHROPIC_FOUNDRY_API_KEY`보다 우선하며 기본 자격 증명 체인보다 우선합니다.

### Claude Code 구성

Microsoft Foundry를 활성화하려면 다음 환경 변수를 설정합니다:

```bash theme={null}
# Microsoft Foundry 통합 활성화
export CLAUDE_CODE_USE_FOUNDRY=1

# Azure 리소스 이름 ({resource}를 리소스 이름으로 바꾸기)
export ANTHROPIC_FOUNDRY_RESOURCE={resource}
# 또는 전체 기본 URL 제공:
# export ANTHROPIC_FOUNDRY_BASE_URL=https://{resource}.services.ai.azure.com/anthropic
```

`ANTHROPIC_FOUNDRY_RESOURCE`는 `my-resource`와 같이 리소스 이름만으로 설정합니다. URL이나 호스트 이름을 설정하면 메시지를 보낼 때 Claude Code가 [이를 거부합니다](https://code.claude.com/docs/ko/errors.md#anthropic-foundry-resource-must-be-a-foundry-resource-name).

### 모델 버전 고정

> [!WARNING]
>
> 모든 배포에 대해 특정 모델 버전을 고정합니다. 고정하지 않으면 `sonnet` 및 `opus`와 같은 모델 별칭이 Claude Code의 Microsoft Foundry용 기본 제공 기본값으로 확인되며, 이는 최신 릴리스보다 뒤떨어질 수 있고 계정에서 아직 사용할 수 없을 수 있습니다. Microsoft Foundry는 시작 모델 확인이 없으므로 기본값을 사용할 수 없을 때 요청이 실패합니다. Azure 배포를 만들 때 "최신으로 자동 업데이트" 대신 특정 모델 버전을 선택합니다.

모델 변수를 1단계에서 만든 배포 이름과 일치하도록 설정합니다.

`ANTHROPIC_DEFAULT_OPUS_MODEL`이 없으면 Microsoft Foundry의 `opus` 별칭은 Opus 4.6으로 확인됩니다. 최신 Opus 모델(예: Opus 4.8)의 ID로 설정합니다:

```bash theme={null}
export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-8'
export ANTHROPIC_DEFAULT_SONNET_MODEL='claude-sonnet-5'
export ANTHROPIC_DEFAULT_HAIKU_MODEL='claude-haiku-4-5'
```

세션 제목 생성과 같은 백그라운드 작업은 일반적으로 Haiku 클래스 모델인 소형/빠른 모델을 사용합니다. Microsoft Foundry에서 Claude Code는 모든 계정이 Haiku 배포를 가지고 있지 않기 때문에 기본 모델로 기본 설정됩니다. 백그라운드 작업에 Haiku를 사용하려면 위에 표시된 대로 `ANTHROPIC_DEFAULT_HAIKU_MODEL`을 계정에서 사용 가능한 Haiku 배포로 설정합니다.

현재 및 레거시 모델 ID는 [모델 개요](https://platform.claude.com/docs/en/about-claude/models/overview)를 참조하세요. 전체 환경 변수 목록은 [모델 구성](https://code.claude.com/docs/ko/model-config.md#pin-models-for-third-party-deployments)을 참조하세요.

[프롬프트 캐싱](https://code.claude.com/docs/ko/prompt-caching.md)은 자동으로 활성화됩니다. 기본 5분 대신 1시간 캐시 TTL을 요청하려면 다음 변수를 설정합니다. 1시간 TTL로 캐시 쓰기는 더 높은 요금으로 청구됩니다:

```bash theme={null}
export ENABLE_PROMPT_CACHING_1H=1
```

주 대화와 Claude Code가 외부에서 수행하는 요청에 대해 다른 TTL을 설정하려면 [TTL을 직접 선택](https://code.claude.com/docs/ko/prompt-caching.md#choose-the-ttl-yourself)하세요.

### Claude Code 실행

환경 변수가 설정되면 프로젝트 디렉터리에서 Claude Code를 시작합니다:

```bash theme={null}
claude
```

Claude Code는 환경에서 `CLAUDE_CODE_USE_FOUNDRY` 및 기타 Microsoft Foundry 변수를 읽고 첫 번째 프롬프트에서 Azure 리소스에 연결합니다. Amazon Bedrock 및 Google Cloud의 Agent Platform과 달리 Microsoft Foundry는 대화형 설정 마법사가 없으므로 3단계와 4단계의 환경 변수가 유일한 구성 경로입니다.

설정을 확인하려면 Claude Code 내에서 `/status`를 실행합니다. API 제공자 라인은 구성한 리소스 이름 또는 기본 URL과 함께 `Microsoft Foundry`를 표시합니다.

## Azure RBAC 구성

`Azure AI User` 및 `Cognitive Services User` 기본 역할에는 Claude 모델을 호출하는 데 필요한 모든 권한이 포함됩니다.

더 제한적인 권한의 경우 다음을 포함하는 사용자 지정 역할을 만듭니다:

```json theme={null}
{
  "permissions": [
    {
      "dataActions": [
        "Microsoft.CognitiveServices/accounts/providers/*"
      ]
    }
  ]
}
```

자세한 내용은 [Microsoft Foundry RBAC 설명서](https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/rbac-azure-ai-foundry)를 참조하세요.

## 1M 토큰 컨텍스트 윈도우

Microsoft Foundry에서 Claude Code가 배포에서 제공하는 모델을 식별할 수 있는 경우, Fable 모델, Sonnet 5 이상, Opus 4.7 이상은 `[1m]` 접미사 없이도 기본적으로 [1M 토큰 컨텍스트 윈도우](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-window-sizes-by-model)로 실행됩니다. Claude Code는 모델 변수의 배포 이름에서 모델을 읽습니다. 각 배포의 이름을 `claude-opus-4-8`과 같은 모델 ID로 지정하거나, [`modelOverrides`](https://code.claude.com/docs/ko/model-config#override-model-ids-per-version)를 사용하여 모델을 배포 이름에 매핑하십시오. 모델과 매칭할 수 없는 배포 이름의 경우, [다른 윈도우를 선언](https://code.claude.com/docs/ko/model-config.md#correct-the-window-for-a-gateway-or-custom-model-id)하지 않는 한 Claude Code는 200K 윈도우로 간주합니다.

다음 `settings.json` 항목은 `team-opus-prod`라는 이름의 배포가 Opus 4.8을 제공한다는 것을 Claude Code에 알려 줍니다.

```json theme={null}
{
  "modelOverrides": {
    "claude-opus-4-8": "team-opus-prod"
  }
}
```

대신 200K 윈도우를 유지하려면 [`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](https://code.claude.com/docs/ko/model-config#turn-off-1m-context)을 설정하십시오.

Opus 4.6과 Sonnet 4.6은 [서드파티 배포용 모델 고정](https://code.claude.com/docs/ko/model-config.md#pin-models-for-third-party-deployments)에 설명된 대로 `ANTHROPIC_DEFAULT_OPUS_MODEL` 또는 `ANTHROPIC_DEFAULT_SONNET_MODEL`의 배포 이름에 `[1m]`을 추가하면 1M 윈도우를 사용할 수 있습니다. v2.1.287 이전에는 Microsoft Foundry에서 Fable 모델과 Opus 4.7 이상에도 해당 접미사가 필요했으며, 접미사가 없으면 기본적으로 200K 윈도우로 실행되었습니다.

## 문제 해결

"Failed to get token from azureADTokenProvider: ChainedTokenCredential authentication failed" 오류가 발생하면:

* 환경에서 Entra ID를 구성하거나 `ANTHROPIC_FOUNDRY_API_KEY`를 설정합니다.

첫 번째 프롬프트에서 반복되는 연결 오류로 요청이 실패하면:

* `ANTHROPIC_FOUNDRY_RESOURCE`가 자리 표시자가 아닌 실제 리소스 이름으로 설정되어 있는지 확인합니다. Claude Code는 이 값에서 엔드포인트 URL을 구성하므로 잘못된 이름은 존재하지 않는 호스트를 가리킵니다.

## 추가 리소스

* [Microsoft Foundry 설명서](https://learn.microsoft.com/en-us/azure/ai-foundry/what-is-azure-ai-foundry)
* [Microsoft Foundry 모델](https://ai.azure.com/explore/models)
* [Microsoft Foundry 가격](https://azure.microsoft.com/en-us/pricing/details/ai-foundry/)
