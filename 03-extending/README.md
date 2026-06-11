# 03. Claude Code 확장

기본 동작 위에 자기만의 룰·도구·자동화를 얹는 카테고리. 이 카테고리를 모르면 Claude Code의 절반밖에 못 쓴다.

## 6가지 확장 포인트, 어떻게 다른가
| 도구 | 무엇을 위해 |
|---|---|
| **CLAUDE.md / 메모리** | 프로젝트별 지속 지침 + auto-memory 누적 |
| **Skills** | 반복 워크플로우를 슬래시 명령으로 패키징 (`/review-pr`, `/deploy-staging`) |
| **Sub-agents** | 컨텍스트 격리한 전문 에이전트 (보안 리뷰어, 테스트 작성자 등) |
| **Hooks** | 파일 편집/태스크 종료 등 이벤트에 셸 명령 자동 실행 |
| **MCP** | 외부 시스템(JIRA, Slack, DB 등)을 도구로 연결 |
| **Plugins** | 위 5가지를 묶어 배포 가능한 단위로 패키징 |

→ 우선 [features-overview](../01-getting-started/features-overview.md)에서 의사결정 가이드를 본 뒤 이 카테고리로 들어오는 걸 추천.

## 페이지 목록

### 핵심 확장 메커니즘
| 페이지 | 한 줄 |
|---|---|
| [memory](memory.md) | CLAUDE.md + auto memory로 지속 지침/학습 누적 |
| [skills](skills.md) | 커스텀 명령어/번들 skill로 능력 확장 |
| [sub-agents](sub-agents.md) | 작업별 전문 서브에이전트 생성 |
| [hooks-guide](hooks-guide.md) | hook 입문/실전 — 자동 포맷, 알림, 검증, 룰 적용 |
| [hooks](hooks.md) | hook 이벤트·스키마·JSON I/O·exit code·async/HTTP/prompt/MCP hook 전체 레퍼런스 |
| [mcp](mcp.md) | Model Context Protocol로 외부 도구 연결 |
| [mcp-quickstart](mcp-quickstart.md) | MCP 서버 추가·연결 확인·디스크상 설정 위치 빠른 시작 |

### Plugins
| 페이지 | 한 줄 |
|---|---|
| [plugins](plugins.md) | skill/agent/hook/MCP 서버를 묶은 커스텀 플러그인 만들기 |
| [plugins-reference](plugins-reference.md) | 플러그인 시스템 스키마/CLI/컴포넌트 기술 레퍼런스 |
| [plugin-marketplaces](plugin-marketplaces.md) | 플러그인 마켓플레이스 구축·배포 |
| [plugin-dependencies](plugin-dependencies.md) | 플러그인 의존성 버전 제약 선언 |
| [discover-plugins](discover-plugins.md) | 마켓플레이스에서 플러그인 검색·설치 |
| [plugin-hints](plugin-hints.md) | CLI에서 한 줄 마커를 emit해 사용자에게 공식 플러그인 설치 안내 |

### 기타
| 페이지 | 한 줄 |
|---|---|
| [output-styles](output-styles.md) | 소프트웨어 엔지니어링 외 용도로 Claude Code 활용 |
| [claude-directory](claude-directory.md) | `.claude` 디렉토리 구조 (CLAUDE.md, settings.json, hooks, skills, commands, subagents, rules, auto memory) |
| [commands](commands.md) | 모든 슬래시 명령어 + 번들 skill 레퍼런스 |
