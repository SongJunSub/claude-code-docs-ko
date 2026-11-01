> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# AWS의 Claude Platform에서 Claude Code

> AWS 인증, IAM 액세스 제어 및 AWS Marketplace 청구를 사용하여 Anthropic 운영 Claude API를 사용하도록 Claude Code를 구성합니다.

AWS의 Claude Platform은 AWS 인증, IAM 액세스 제어 및 AWS Marketplace 청구를 지원하는 Anthropic 운영 Claude API입니다. 요청은 Anthropic의 API에 직접 도달하므로 동일한 릴리스 일정에 따라 [Claude API](https://platform.claude.com/docs)와 동일한 모델 및 API 기능을 사용할 수 있습니다. AWS 자격 증명 또는 워크스페이스 API 키로 인증하며, AWS Marketplace를 통해 비용을 지불합니다.

Anthropic의 기능 플래그 서비스를 통해 Claude Code가 활성화하는 클라이언트 측 기능은 기본적으로 비활성화되어 있으며, [어드바이저 도구](https://code.claude.com/docs/ko/advisor.md)는 사용할 수 없습니다. 전체 목록은 [기능 가용성 매트릭스](https://code.claude.com/docs/ko/feature-availability.md#summary-by-provider)를 참조하십시오.

이 가이드를 사용하여 Claude Platform on AWS를 통해 이미 프로비저닝한 워크스페이스를 가리키도록 Claude Code를 설정합니다. 이 전에 필요한 AWS 구독 및 워크스페이스 설정은 [Claude Platform on AWS 설명서](https://platform.claude.com/docs/en/build-with-claude/claude-platform-on-aws)를 참조하십시오.

> [!NOTE]
>
> AWS Marketplace를 통해 구독하면 AWS 계정에 연결된 새로운 Anthropic 조직이 프로비저닝됩니다. 이 조직은 Anthropic에서 이미 보유한 모든 조직과 별개이며, 자격 증명은 조직 간에 전송되지 않습니다. AWS 연결 조직의 워크스페이스 ID 및 API 키를 사용하고, 기존 Claude Console 계정의 키는 사용하지 마십시오.

## 필수 조건

Claude Code를 구성하기 전에 다음이 필요합니다.

* AWS Marketplace를 통한 활성 Claude Platform on AWS 구독
* AWS 연결 Anthropic 조직의 워크스페이스 및 해당 워크스페이스 ID
* Anthropic 서비스를 호출할 수 있는 권한이 있는 IAM 주체 또는 워크스페이스로 범위가 지정된 API 키
* 환경, `~/.aws/credentials` 또는 SigV4 인증을 원하는 경우 연결된 IAM 역할의 AWS 자격 증명. AWS CLI는 SSO 로그인 흐름에만 필요합니다.

## 설정

### AWS 자격 증명 구성

Claude Code는 Claude Platform on AWS에 대해 두 가지 인증 방법을 지원합니다. 팀의 액세스 관리 방식에 맞는 방법을 선택합니다.

* [SigV4를 사용하는 AWS 자격 증명](#use-aws-credentials-with-sigv4): 표준 AWS 자격 증명 체인의 자격 증명을 사용하여 IAM 주체로 인증합니다
* [워크스페이스 API 키](#use-a-workspace-api-key): AWS Console에서 생성한 장기 키로 인증합니다

#### SigV4를 사용하는 AWS 자격 증명 사용

Claude Code는 표준 AWS 자격 증명 체인을 사용하여 SigV4로 요청에 서명합니다. 이 체인에는 환경 변수, `~/.aws/credentials`의 공유 자격 증명, IAM 역할, AWS SSO 세션 및 AWS SDK가 지원하는 기타 모든 소스가 포함됩니다.

로컬에서 사용하는 경우 Claude Code를 시작하기 전에 AWS CLI로 로그인합니다. 아래 예시는 SSO 프로필을 사용하지만, 표준 위치에 자격 증명을 생성하는 방법이라면 어떤 방법이든 사용할 수 있습니다.

```bash theme={null}
aws sso login --profile my-profile
export AWS_PROFILE=my-profile
```

CI 및 자동화 환경에서는 러너에 Anthropic 서비스를 호출할 권한이 있는 IAM 역할을 부여하고 `AWS_REGION`을 설정합니다. 자격 증명 체인이 해당 역할을 자동으로 인식합니다.

세션 도중 SSO 자격 증명이 만료되는 경우, 실패하는 대신 Claude Code가 로그인 명령을 다시 실행하고 재시도하도록 [`awsAuthRefresh`](https://code.claude.com/docs/ko/amazon-bedrock#advanced-credential-configuration)를 구성합니다. `~/.claude/settings.json`과 같은 [설정 파일](https://code.claude.com/docs/ko/settings.md)에 명령을 추가합니다.

```json theme={null}
{
  "awsAuthRefresh": "aws sso login --profile my-profile"
}
```

Claude Code는 기존 AWS 자격 증명을 검증할 수 없는 경우 시작 시에도 이 명령을 실행하며, 로그인이 완료될 때까지 `Authentication` 패널에 명령의 출력을 표시합니다.

`awsAuthRefresh`가 구성된 상태에서 `/login`을 실행하고 **3rd-party platform**을 선택한 다음, **Using 3rd-party platforms** 아래에서 **Claude Platform on AWS · refresh credentials**를 선택합니다. Claude Code는 구성된 명령을 실행하고 재시작 없이 AWS 자격 증명을 다시 읽어 들입니다.

#### 워크스페이스 API 키 사용

워크스페이스 API 키는 장기 보안 비밀로, 페더레이션된 AWS 자격 증명을 관리하고 싶지 않을 때 유용합니다. AWS Console의 **Claude Platform on AWS → API keys**에서 키를 생성하고 `ANTHROPIC_AWS_API_KEY`로 설정합니다.

```bash theme={null}
export ANTHROPIC_AWS_API_KEY=sk-ant-xxxxx
```

키는 `x-api-key`로 전송되며 SigV4보다 우선하므로, 환경에 있는 모든 AWS 자격 증명은 무시됩니다. 별도의 Claude Console 조직에서 발급된 API 키는 여기서 작동하지 않습니다.

워크스페이스 API 키는 다른 프로덕션 자격 증명과 동일하게 취급해야 합니다. [사용자 설정 파일](https://code.claude.com/docs/ko/settings.md)의 `env` 블록을 사용하면 키를 전역으로 내보내지 않고도 사용자의 머신 범위로 편리하게 지정할 수 있습니다.

> [!NOTE]
>
> `/login` 및 `/logout` 명령은 Claude Platform on AWS에서 claude.ai 구독으로 로그인하지 않습니다. 인증은 AWS 자격 증명 또는 워크스페이스 API 키를 통해 이루어집니다.

### Claude Code 구성

기본 Anthropic API 대신 Claude Platform on AWS를 통해 Claude Code를 라우팅하는 환경 변수를 설정합니다.

```bash theme={null}
export CLAUDE_CODE_USE_ANTHROPIC_AWS=1
export ANTHROPIC_AWS_WORKSPACE_ID=wrkspc_01ABCDEFGHIJKLMN
export AWS_REGION=us-east-1
```

`ANTHROPIC_AWS_WORKSPACE_ID`는 필수입니다. Claude Code는 모든 요청에서 이 값을 `anthropic-workspace-id` 헤더로 전송합니다. 예시 값 `wrkspc_01ABCDEFGHIJKLMN`을 Claude Platform on AWS 설정에서 확인한 자신의 워크스페이스 ID로 바꿉니다.

Claude Code는 AWS 리전으로부터 기본 URL을 `https://aws-external-anthropic.{region}.api.aws`로 계산하며, 리전은 [Amazon Bedrock과 동일한 우선순위](https://code.claude.com/docs/ko/amazon-bedrock.md#3-configure-claude-code)로 결정됩니다. URL을 직접 재정의하려면 `ANTHROPIC_AWS_BASE_URL`을 설정합니다.

Claude Platform on AWS는 환경에 AWS 자격 증명이 있더라도 자동으로 활성화되지 않으며, 명시적으로 옵트인해야 합니다. 공급자 라우팅에서는 Amazon Bedrock과 Microsoft Foundry가 우선하므로, `CLAUDE_CODE_USE_BEDROCK` 및 `CLAUDE_CODE_USE_FOUNDRY`가 설정되어 있다면 설정을 해제합니다.

### 모델 버전 고정

Claude Platform on AWS는 Claude API와 직접 사용할 때와 동일한 모델 ID를 사용합니다.

기본 별칭 `fable`, `opus`, `sonnet`, `haiku`는 Claude Platform on AWS용 Claude Code 내장 기본값으로 확인되며, 이 기본값은 최신 릴리스보다 늦게 반영될 수 있습니다. `ANTHROPIC_DEFAULT_OPUS_MODEL`이 없으면 `opus` 별칭은 Opus 5.5로 확인됩니다. v2.1.280 이전에는 v2.1.219부터 Opus 5로 확인되었습니다.

팀에 Claude Code를 배포하는 경우, 새 릴리스로 인해 모든 사용자가 한꺼번에 변경되지 않도록 모델 ID를 명시적으로 고정합니다.

```bash theme={null}
export ANTHROPIC_DEFAULT_FABLE_MODEL=claude-fable-5
export ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-8
export ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-5
export ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5
```

전체 모델 ID 및 별칭 목록은 [모델 개요](https://platform.claude.com/docs/en/about-claude/models/overview)를 참조하세요. 기타 모델 관련 변수는 [모델 구성](https://code.claude.com/docs/ko/model-config.md)을 참조하세요.

[프롬프트 캐싱](https://code.claude.com/docs/ko/prompt-caching.md)은 자동으로 활성화됩니다. 기본값인 5분 대신 1시간 캐시 TTL을 요청하려면 `ENABLE_PROMPT_CACHING_1H=1`을 설정합니다. API는 1시간 캐시 쓰기에 더 높은 요금을 청구합니다. 요금은 [프롬프트 캐싱 가격](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)을 참조하세요.

메인 대화와 Claude Code가 그 외부에서 보내는 요청에 서로 다른 TTL을 설정하려면 [TTL을 직접 선택](https://code.claude.com/docs/ko/prompt-caching.md#choose-the-ttl-yourself)합니다.

### 실행 및 확인

Claude Code를 시작하고 라우팅을 확인합니다.

```bash theme={null}
claude
```

공급자가 활성화되어 있으면 시작 배너에 `Claude Platform on AWS`가 표시됩니다. `/status`를 실행하여 세부 정보를 확인합니다. `API provider` 줄에 `Claude Platform on AWS`가 표시되며, 출력에는 `Workspace ID`, `AWS region`, 그리고 재정의를 설정한 경우 `Claude Platform on AWS base URL`이 포함됩니다.

## Agent SDK 사용

[Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)는 CLI와 동일한 환경 변수를 읽으므로 Claude Code 하위 프로세스를 생성하는 모든 프로그램은 호출 전에 `CLAUDE_CODE_USE_ANTHROPIC_AWS`, `ANTHROPIC_AWS_WORKSPACE_ID` 및 `ANTHROPIC_AWS_API_KEY` 또는 AWS 자격 증명을 내보내 Claude Platform on AWS를 대상으로 할 수 있습니다.

```typescript theme={null}
import { query } from "@anthropic-ai/claude-agent-sdk";

process.env.CLAUDE_CODE_USE_ANTHROPIC_AWS = "1";
process.env.ANTHROPIC_AWS_WORKSPACE_ID = "wrkspc_01ABCDEFGHIJKLMN";
process.env.AWS_REGION = "us-east-1";

for await (const msg of query({ prompt: "What's in this repo?" })) {
  console.log(msg);
}
```

이 예제는 SigV4에 대한 주변 AWS 자격 증명 체인을 사용합니다. 대신 워크스페이스 API 키로 인증하려면 동일한 방식으로 `ANTHROPIC_AWS_API_KEY`를 설정하십시오. 더 광범위한 Agent SDK 표면은 [Agent SDK 개요](https://code.claude.com/docs/ko/agent-sdk/overview.md)를 참조하십시오.

## 기업 프록시를 통해 라우팅

프록시 또는 [LLM 게이트웨이](https://code.claude.com/docs/ko/llm-gateway)를 통해 트래픽을 라우팅하려면 `ANTHROPIC_AWS_BASE_URL`을 프록시의 주소로 설정하십시오. Claude Code는 동일한 워크스페이스 및 인증 헤더를 사용하여 해당 URL로 요청을 보내므로 변경되지 않은 상태로 전달하는 모든 게이트웨이가 작동합니다.

```bash theme={null}
export CLAUDE_CODE_USE_ANTHROPIC_AWS=1
export ANTHROPIC_AWS_WORKSPACE_ID=wrkspc_01ABCDEFGHIJKLMN
export ANTHROPIC_AWS_BASE_URL=https://anthropic-proxy.example.com
```

게이트웨이가 요청 자체에 서명하는 경우 `CLAUDE_CODE_SKIP_ANTHROPIC_AWS_AUTH=1`을 설정하여 Claude Code가 서명되지 않은 요청을 보내고 게이트웨이가 AWS로 전달하기 전에 SigV4 헤더를 추가하도록 합니다. 게이트웨이가 자체 토큰을 요구하는 경우 `ANTHROPIC_AUTH_TOKEN`에 설정하십시오.

```bash theme={null}
export CLAUDE_CODE_USE_ANTHROPIC_AWS=1
export CLAUDE_CODE_SKIP_ANTHROPIC_AWS_AUTH=1
export ANTHROPIC_AWS_WORKSPACE_ID=wrkspc_01ABCDEFGHIJKLMN
export ANTHROPIC_AWS_BASE_URL=https://anthropic-proxy.example.com
```

## 문제 해결

`/status`를 실행하여 확인된 공급자 및 명시적으로 구성된 워크스페이스 ID, 지역, 기본 URL 재정의 및 인증 건너뛰기 설정을 확인하십시오. 이것이 Claude Code가 Claude Platform on AWS를 대상으로 하는지 확인하는 가장 빠른 방법입니다.

### 모든 요청에서 `403 Forbidden` 또는 `AccessDenied`

Claude Code가 확인한 IAM 주체는 워크스페이스에서 Anthropic 서비스를 호출할 수 있는 권한이 없을 가능성이 높습니다. AWS 프로필에 연결된 역할 또는 Claude Code를 시작한 실행기를 확인하고 [IAM 작업 참조](https://platform.claude.com/docs/ko/api/claude-platform-on-aws-iam-actions)에 설명된 `aws-external-anthropic` 작업이 있는지 확인하십시오.

`ANTHROPIC_AWS_API_KEY`를 설정한 경우 키가 SigV4보다 우선하고 오래된 키는 동일한 오류를 생성합니다. AWS Console의 **Claude Platform on AWS → API keys** 아래에서 키를 다시 생성하거나 변수를 해제하여 AWS 자격 증명으로 돌아가십시오.

### 요청이 누락된 워크스페이스 오류로 실패합니다.

`ANTHROPIC_AWS_WORKSPACE_ID`가 설정되지 않았거나 비어 있을 가능성이 높습니다. 모든 Claude Platform on AWS 요청에는 워크스페이스 ID가 포함되어야 합니다. AWS 자격 증명에 의해 암시되지 않습니다. Claude Platform on AWS 설정에서 ID를 찾고 Claude Code를 시작하기 전에 내보내십시오.

### 요청이 여전히 `api.anthropic.com`으로 이동합니다.

`CLAUDE_CODE_USE_ANTHROPIC_AWS`가 설정되지 않았거나 truthy로 구문 분석되지 않는 값으로 설정되었을 가능성이 높습니다. `1`로 설정하고 `/status`를 실행하여 확인된 공급자를 확인하십시오. `CLAUDE_CODE_USE_BEDROCK` 또는 `CLAUDE_CODE_USE_FOUNDRY`도 설정된 경우 Claude Platform on AWS보다 우선합니다.

## 추가 리소스

Claude Code 구성 전에 필요한 Claude Platform on AWS 구독, 워크스페이스 및 IAM 설정은 플랫폼 설명서에서 다룹니다.

* [Claude Platform on AWS 개요](https://platform.claude.com/docs/ko/build-with-claude/claude-platform-on-aws): 구독, 워크스페이스 설정 및 제품 참조
* [IAM 작업 참조](https://platform.claude.com/docs/ko/api/claude-platform-on-aws-iam-actions): 권한 및 관리형 정책
