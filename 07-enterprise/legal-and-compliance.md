> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# 법률 및 규정 준수

> Claude Code의 법률 계약, 규정 준수 인증 및 보안 정보입니다.

## 법률 계약

### 라이선스

Claude Code의 사용은 다음의 적용을 받습니다:

* [상용 약관](https://www.anthropic.com/legal/commercial-terms) - Team, Enterprise 및 Claude API 사용자용
* [소비자 서비스 약관](https://www.anthropic.com/legal/consumer-terms) - Free, Pro, Max 및 Ultra 사용자용

### 상용 계약

Claude API를 직접 사용하든(1P) Amazon Bedrock 또는 Google Cloud의 Agent Platform을 통해 접근하든(3P), 기존 상용 계약이 Claude Code 사용에 적용되며, 달리 상호 합의하지 않는 한 그러합니다.

### Claude Code를 고객의 제품에서 제공할 수 있습니까?

달리 상호 합의하지 않는 한, Claude Code를 제품 또는 서비스에 사전 설치하거나 실행하는 경우(예: 호스팅된 샌드박스 또는 기타 에이전트 인프라에서) 당사의 [상용 약관](https://www.anthropic.com/legal/commercial-terms)에 동의하고 아래 조건을 준수해야 합니다:

* **Claude Code 바이너리는 수정되어서는 안 됩니다.** Claude Code는 Anthropic에서 게시한 대로 설치 및 실행되어야 하며, 고객은 이에 내장된 인증 방법(Claude 계정으로 로그인하거나 사용자 자신의 API 키를 사용하는 방법 포함)을 제거, 비활성화 또는 제한할 수 없습니다.
* **고객은 최종 사용자를 대신하여 Claude 사용에 대해 비용을 지불하거나, 재판매하거나, 중개할 수 없습니다.** 각 최종 사용자는 자신의 Anthropic API 키, Claude 구독 계획 자격 증명 또는 3P 추론 제공자 자격 증명(Amazon Bedrock, Google Cloud의 Agent Platform, Microsoft Foundry)으로 인증해야 합니다. 해당 사용량은 Anthropic과의 자신의 계약 또는 타사 추론 제공자의 경우 해당 제공자와의 계약에 따라 최종 사용자에게 직접 청구됩니다.

**Claude Code 이름 및 로고 사용.** 제품에 Claude Code가 사전 설치되어 있거나 Claude Code를 실행한다는 것을 일반 텍스트로 정확하게 말할 수 있습니다. 그러나 Claude Code 또는 Anthropic 이름이나 로고를 자신의 제품, 기능 또는 회사 이름의 일부로, 자신의 로고에서, 또는 Anthropic이 제품을 구축했거나 승인했거나 제품과 파트너십을 맺었음을 시사하는 방식으로 사용할 수 없습니다. Anthropic 이름 또는 로고의 기타 모든 사용은 당사의 [상표 지침](https://www.anthropic.com/legal/trademark-guidelines)에 의해 관리되며 당사의 서면 허가가 필요합니다.

Claude Code는 접근하는 플랫폼에 관계없이 Anthropic의 표준 약관(위의 라이선스 및 상용 계약 섹션 참조)에 의해 계속 관리됩니다.

## 규정 준수

### 의료 규정 준수(BAA)

고객이 Anthropic과 Business Associate Agreement(BAA)를 체결한 경우, 해당 BAA는 조직에서 사용할 수 있는 항목에 따라 다음 두 가지 구성의 Claude Code로 확장됩니다.

* **HIPAA 구성**: Claude for Enterprise 계정과 함께 사용하는 Claude Code CLI 또는 Claude Desktop의 Code 탭입니다. 조직에 HIPAA가 활성화되어 있어야 하며, Claude Code(로컬 모드) 및 Cowork(로컬 모드)에 HIPAA 구성이 적용되어 있어야 합니다. [HIPAA 지원 조직을 위한 Claude Code(로컬 모드) 설정](https://code.claude.com/docs/ko/hipaa-setup.md)을 참조하세요.
* **Zero Data Retention**: 관련 조직에 대해 [Zero Data Retention(ZDR)](https://code.claude.com/docs/ko/zero-data-retention.md)이 활성화된 Claude Code입니다. ZDR은 모든 조직에서 사용할 수 있는 것은 아닙니다.

HIPAA 구성에서는 클라우드 세션, Remote Control, Claude 모바일 앱의 Claude Code, 그리고 서드파티 클라우드 공급자나 게이트웨이를 통해 라우팅되는 Claude Code는 적용 대상에 포함되지 않습니다. 적격 서비스의 전체 목록은 [구현 가이드](https://trust.anthropic.com/resources?s=l1wrssd9hsbi4gak0tp5a6\&name=%5Banthropic%5D-hipaa-ready-offering-implementation-guide)를 검토하세요.

## 사용 정책

### 허용되는 사용

Claude Code 사용은 [Anthropic 사용 정책](https://www.anthropic.com/legal/aup)의 적용을 받습니다. Pro, Max 및 Ultra 플랜의 공시된 사용 한도는 Claude Code 및 Agent SDK의 일반적인 개별 사용을 가정합니다.

### 인증 및 자격 증명 사용

Claude Code는 OAuth 토큰 또는 API 키를 사용하여 Anthropic의 서버로 인증합니다. 이러한 인증 방법은 서로 다른 목적으로 사용됩니다:

* **OAuth 인증**은 Claude Free, Pro, Max, Ultra, Team 및 Enterprise 구독 플랜의 구매자를 위해 독점적으로 의도되었으며, Claude Code 및 기타 네이티브 Anthropic 애플리케이션의 일반적인 사용을 지원하도록 설계되었습니다. 로그인 단계는 [Claude 계정에 로그인](https://support.claude.com/en/articles/13189465-logging-in-to-your-claude-account)을 참조하시기 바라며, Claude Code가 OAuth 인증을 수행하는 방법에 대해서는 [인증](https://code.claude.com/docs/ko/authentication.md)을 참조하시기 바랍니다.
* **개발자**가 [Agent SDK](https://code.claude.com/docs/ko/agent-sdk/overview.md)를 사용하는 것을 포함하여 Claude의 기능과 상호 작용하는 제품 또는 서비스를 구축하는 경우, [Claude Console](https://platform.claude.com/) 또는 지원되는 클라우드 제공자를 통해 API 키 인증을 사용해야 합니다. Anthropic은 제3자 개발자가 Claude.ai 로그인을 자신의 애플리케이션에 제공하거나 사용자를 대신하여 Free, Pro, Max 또는 Ultra 플랜 자격 증명을 통해 요청을 라우팅하는 것을 허용하지 않습니다. 또한 개발자는 Claude.ai 자격 증명 또는 세션 토큰을 수집, 저장 또는 중개할 수 없습니다. Claude 계정으로의 로그인은 Anthropic의 자체 흐름을 통해 완료되어야 합니다.

이는 고객이 자신의 API 키 또는 제3자 추론 제공자 자격 증명을 프로비저닝하고 관리하는 방식을 제한하지 않습니다. 예를 들어, 개발 환경, 비밀 관리자 또는 머신 이미지에서 API 키를 구성하여 고객의 승인된 사용자가 사용하도록 하는 경우, 결과적인 사용이 Anthropic(또는 해당 제공자)과의 계약에 따라 키 소유자에게 청구되고 위에서 설명한 대로 재판매되거나 중개되지 않는 한 이를 제한하지 않습니다. 또한 플랫폼이 위의 *고객이 자신의 제품에서 Claude Code를 제공할 수 있습니까?* 아래에서 설명한 대로 Claude Code를 호스팅하는 경우를 포함하여 최종 사용자가 자신의 Claude 구독으로 수정되지 않은 Claude Code 바이너리에 로그인하는 것을 방지하지 않습니다.

Anthropic은 이러한 제한을 시행하기 위한 조치를 취할 권리를 보유하며, 사전 통지 없이 이를 수행할 수 있습니다.

사용 사례에 대해 허용되는 인증 방법에 대한 질문이 있으시면 [영업팀에 문의](https://www.anthropic.com/contact-sales?utm_source=claude_code\&utm_medium=docs\&utm_content=legal_compliance_contact_sales)하시기 바랍니다.

## 보안 및 신뢰

### 신뢰 및 안전

[Anthropic Trust Center](https://trust.anthropic.com) 및 [Transparency Hub](https://www.anthropic.com/transparency)에서 더 많은 정보를 찾을 수 있습니다.

### 보안 취약점 보고

Anthropic은 HackerOne을 통해 보안 프로그램을 관리합니다. [이 양식을 사용하여 취약점을 보고](https://hackerone.com/4f1f16ba-10d3-4d09-9ecc-c721aad90f24/embedded_submissions/new)하십시오.

***

© Anthropic PBC. 모든 권리 보유. 사용은 해당 Anthropic 서비스 약관의 적용을 받습니다.
