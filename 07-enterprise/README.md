# 07. 엔터프라이즈 / 운영

조직 규모로 배포, 관리, 모니터링할 때 보는 카테고리. 클라우드 공급자(Bedrock, Vertex, Foundry) 통합, 네트워크/보안, 비용, 사용량 추적, 컴플라이언스를 다룬다.

## 이럴 때 본다
- 사내 정책상 직접 Anthropic API가 아니라 Bedrock/Vertex/Foundry를 거쳐야 한다
- 프록시, CA, mTLS 환경에서 작동시켜야 한다
- 팀 사용량/비용을 분석하고 한도를 걸고 싶다
- 컴플라이언스(데이터 보존, 감사, ZDR) 요구사항이 있다
- 자가 호스팅 GitHub Enterprise와 연동해야 한다

## 페이지 목록

### 배포 / 통합
| 페이지 | 한 줄 |
|---|---|
| [admin-setup](admin-setup.md) | 관리자 배포 결정 맵 (API provider, 관리 설정, 정책, 사용 모니터링, 데이터 처리) |
| [third-party-integrations](third-party-integrations.md) | 엔터프라이즈 배포 요구사항을 위한 외부 서비스 통합 |
| [amazon-bedrock](amazon-bedrock.md) | Amazon Bedrock 설정, IAM, 트러블슈팅 |
| [claude-platform-on-aws](claude-platform-on-aws.md) | AWS 인증, IAM, AWS Marketplace 빌링으로 Anthropic 운영 Claude API 사용 |
| [google-vertex-ai](google-vertex-ai.md) | Google Vertex AI 설정 |
| [microsoft-foundry](microsoft-foundry.md) | Microsoft Foundry 설정 |
| [github-enterprise-server](github-enterprise-server.md) | 자가 호스팅 GHES 연결 (web, code review, 마켓플레이스) |
| [llm-gateway](llm-gateway.md) | LLM gateway 솔루션과 함께 사용 |
| [devcontainer](devcontainer.md) | 일관, 안전한 환경을 위한 dev container |

### 네트워크 / 보안
| 페이지 | 한 줄 |
|---|---|
| [network-config](network-config.md) | 프록시, 커스텀 CA, mTLS 인증 |
| [security](security.md) | 보안 안전장치 + 사용 모범 사례 |
| [managed-mcp](managed-mcp.md) | 관리 설정, allowlist, denylist로 사용자가 추가, 연결 가능한 MCP 서버 제한 |
| [legal-and-compliance](legal-and-compliance.md) | 법적 동의, 컴플라이언스 인증, 보안 정보 |
| [data-usage](data-usage.md) | Anthropic 데이터 사용 정책 |
| [zero-data-retention](zero-data-retention.md) | ZDR (Claude for Enterprise): 비활성화 기능, 활성화 요청 |

### 사용량 / 비용
| 페이지 | 한 줄 |
|---|---|
| [analytics](analytics.md) | 팀 사용량 메트릭, 채택률, 엔지니어링 속도 측정 |
| [monitoring-usage](monitoring-usage.md) | OpenTelemetry로 사용량 모니터링 |
| [costs](costs.md) | 토큰 사용 추적, 팀 지출 한도, 비용 절감 (context 관리, 모델 선택, thinking 설정, 전처리 hook) |

### 조직 도입 / 홍보
| 페이지 | 한 줄 |
|---|---|
| [champion-kit](champion-kit.md) | 사내에서 Claude Code를 옹호하는 엔지니어용 플레이북 (공유 내용, Q&A, 30일 도입 가이드) |
| [communications-kit](communications-kit.md) | 조직 롤아웃을 위한 출시 공지, 드립 캠페인 메시지, FAQ 응답 자료 |
