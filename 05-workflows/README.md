# 05. 워크플로우 / 자동화

Claude Code로 실제 일을 어떻게 굴릴지에 대한 카테고리. 일상 작업 패턴, CI 통합, 예약 실행, 고급 모드를 다룬다.

## 이럴 때 본다
- 특정 작업(버그 수정·리팩토링·테스트)을 가장 효율적으로 시키고 싶다
- PR 자동 리뷰나 GitHub/GitLab CI에 Claude를 끼워 넣고 싶다
- 정기적으로 돌리는 작업(주간 의존성 감사, 야간 PR 리뷰 등)을 예약하고 싶다
- 큰 변경 전에 클라우드에서 본격 plan/review를 돌리고 싶다 (`/ultraplan`, `/ultrareview`)

## 페이지 목록

### 일상 작업 패턴
| 페이지 | 한 줄 |
|---|---|
| [common-workflows](common-workflows.md) | 코드베이스 탐색·버그 수정·리팩토링·테스트 등 일상 작업 가이드 |
| [best-practices](best-practices.md) | 환경 설정~병렬 세션 확장까지 활용 패턴 |
| [context-window](context-window.md) ⓔ | context window가 세션 동안 어떻게 채워지는지 인터랙티브 시뮬레이션 |
| [debug-your-config](debug-your-config.md) | CLAUDE.md/설정/hooks/MCP/skills 적용 안 될 때 진단 (`/context`, `/doctor`, `/hooks`, `/mcp`) |
| [troubleshooting](troubleshooting.md) | 일반적 설치·사용 문제 해결 |

### CI / 코드 리뷰
| 페이지 | 한 줄 |
|---|---|
| [code-review](code-review.md) | 멀티 에이전트로 PR 자동 리뷰 (로직 오류·보안·회귀) |
| [github-actions](github-actions.md) | Claude Code GitHub Actions로 워크플로우 통합 |
| [gitlab-ci-cd](gitlab-ci-cd.md) | GitLab CI/CD 통합 |

### 예약 / 자율 실행
| 페이지 | 한 줄 |
|---|---|
| [scheduled-tasks](scheduled-tasks.md) | `/loop`과 cron 도구로 프롬프트 반복 실행 |
| [goal](goal.md) | `/goal`로 완료 조건을 설정하면 충족될 때까지 턴 자동 반복 |
| [desktop-scheduled-tasks](desktop-scheduled-tasks.md) ⓔ | 데스크톱 예약 작업 (일일 코드 리뷰·의존성 감사·모닝 브리핑) |
| [routines](routines.md) | cron/API/GitHub 이벤트 트리거 routine — Anthropic 관리 인프라 |

### 고급 모드
| 페이지 | 한 줄 |
|---|---|
| [ultraplan](ultraplan.md) | CLI에서 plan 시작 → 웹에서 작성 → 원격/터미널 실행 |
| [ultrareview](ultrareview.md) | `/ultrareview`로 클라우드에서 멀티 에이전트 딥 코드 리뷰 |
| [headless](headless.md) | Agent SDK로 CLI/Python/TypeScript에서 프로그래밍 방식 실행 |
| [agent-teams](agent-teams.md) | 여러 Claude Code 인스턴스를 팀으로 조율 |
| [checkpointing](checkpointing.md) | 편집·대화 추적, 되돌리기, 요약하여 세션 상태 관리 |
| [fast-mode](fast-mode.md) | Opus 4.6 빠른 응답 토글 |

> ⓔ = 영어 원문
