# 04. Agent SDK

Claude Code를 **라이브러리로** 사용해 자체 AI 에이전트를 만들 때 보는 카테고리. Python·TypeScript SDK 둘 다 지원.

## ⚠️ 한국어 미제공 페이지 다수
이 카테고리는 페이지 대부분이 한국어 번역이 없어 영어 원문으로 보존했습니다. (하단 표의 ⓔ 표시)

## 이럴 때 본다
- 챗봇/어시스턴트/CLI 등 **자체 제품**에 Claude Code의 도구·세션·hook·MCP 통합을 얹고 싶다
- 멀티턴 대화 + tool use + 구조화 출력이 필요한 자율 워크플로우를 만들고 싶다
- 기존 Claude Code TypeScript/Python SDK 사용자라면 → [migration-guide](migration-guide.md)부터

## 페이지 목록

### 시작
| 페이지 | 한 줄 |
|---|---|
| [overview](overview.md) ⓔ | Agent SDK 개요 — Claude Code를 라이브러리로 사용 |
| [quickstart](quickstart.md) | Python/TypeScript SDK로 자율 에이전트 시작 |
| [migration-guide](migration-guide.md) ⓔ | TypeScript/Python SDK → Claude Agent SDK 마이그레이션 |
| [agent-loop](agent-loop.md) ⓔ | 메시지 lifecycle, 도구 실행, context window, 아키텍처 |

### 입출력 모드
| 페이지 | 한 줄 |
|---|---|
| [streaming-output](streaming-output.md) ⓔ | 텍스트와 도구 호출을 실시간 스트리밍으로 받기 |
| [streaming-vs-single-mode](streaming-vs-single-mode.md) ⓔ | 두 가지 입력 모드와 사용 시점 |
| [structured-outputs](structured-outputs.md) ⓔ | JSON Schema/Zod/Pydantic으로 검증된 JSON 받기 |
| [user-input](user-input.md) ⓔ | 승인 요청·명확화 질문을 사용자에게 노출 + 결정 반환 |

### Claude Code 기능 통합
| 페이지 | 한 줄 |
|---|---|
| [claude-code-features](claude-code-features.md) | 프로젝트 지침·skill·hook 등 Claude Code 기능을 SDK로 로드 |
| [sessions](sessions.md) ⓔ | 세션이 대화 히스토리를 보존하는 방식 + continue/resume/fork |
| [skills](skills.md) ⓔ | SDK에서 Agent Skill로 Claude 확장 |
| [slash-commands](slash-commands.md) | SDK로 슬래시 명령어 활용 |
| [hooks](hooks.md) ⓔ | 실행 핵심 지점에서 에이전트 동작 가로채기 |
| [permissions](permissions.md) ⓔ | 도구 사용 제어 (모드·훅·허용/거부 규칙) |
| [subagents](subagents.md) ⓔ | 컨텍스트 격리, 병렬 실행, 전문 지침 적용 |
| [todo-tracking](todo-tracking.md) ⓔ | SDK로 todo 추적/표시 |
| [file-checkpointing](file-checkpointing.md) ⓔ | 세션 동안 파일 변경 추적 후 임의 시점으로 복원 |
| [modifying-system-prompts](modifying-system-prompts.md) ⓔ | output style, append 모드, 커스텀 system prompt |

### 도구 / MCP
| 페이지 | 한 줄 |
|---|---|
| [mcp](mcp.md) ⓔ | MCP 서버로 외부 도구 확장 (transport·tool search·auth·에러 처리) |
| [custom-tools](custom-tools.md) ⓔ | in-process MCP 서버로 함수/API 호출 도구 정의 |
| [tool-search](tool-search.md) ⓔ | 수천 개 도구로 확장 — 필요한 것만 발견/로드 |
| [plugins](plugins.md) ⓔ | SDK로 플러그인 로드 (commands·agents·skills·hooks) |

### 프로덕션 운영
| 페이지 | 한 줄 |
|---|---|
| [cost-tracking](cost-tracking.md) | 토큰 사용 추적, 비용 추정, 프롬프트 캐싱 설정 |
| [observability](observability.md) ⓔ | OpenTelemetry로 추적·메트릭·이벤트 내보내기 |
| [secure-deployment](secure-deployment.md) ⓔ | 격리·자격 증명 관리·네트워크 제어로 안전한 배포 |
| [hosting](hosting.md) | 프로덕션 환경 배포·호스팅 |

### 언어별 API 레퍼런스
| 페이지 | 한 줄 |
|---|---|
| [python](python.md) | Python SDK 전체 API 레퍼런스 |
| [typescript](typescript.md) | TypeScript SDK 전체 API 레퍼런스 |
| [typescript-v2-preview](typescript-v2-preview.md) | 단순화된 V2 TypeScript SDK 미리보기 (세션 기반 send/stream) |

> ⓔ = 영어 원문 (한국어 번역 미제공)
