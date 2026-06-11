# Claude Code 한국어 공식 문서 큐레이션

[Claude Code 공식 문서](https://code.claude.com/docs/ko/overview) 전체(146페이지)를 카테고리별로 정리한 개인용 큐레이션 레포.

- **누락 없음**: 공식 문서 모든 페이지를 풀텍스트 마크다운으로 보존
- **빠른 탐색**: 8개 카테고리 + 카테고리별 README가 "어디에 무엇이 있는지" 안내
- **검색 가능**: 마크다운이라 IDE/VS Code/`grep`으로 바로 검색

> Fetch 시점: **2026-06-11** · 출처: `https://code.claude.com/docs/ko/*.md`
> 가장 최신 정보는 항상 공식 문서를 우선하세요. 이 레포는 스냅샷입니다.

## 카테고리

| # | 카테고리 | 페이지 | 한 줄 |
|---|---|---:|---|
| 01 | [시작하기](01-getting-started/) | 10 | 설치·로그인·환경 선택·Claude Code 동작 원리·설치 트러블슈팅 |
| 02 | [실행 환경 / 인터페이스](02-environments/) | 18 | CLI·VS Code·JetBrains·Desktop·Web·Slack·Chrome·agent view·deep links |
| 03 | [Claude Code 확장](03-extending/) | 16 | CLAUDE.md·Skills·Sub-agents·Hooks·MCP(+빠른 시작)·Plugins |
| 04 | [Agent SDK](04-agent-sdk/) | 30 | Claude Code를 라이브러리로 — Python/TypeScript |
| 05 | [워크플로우 / 자동화](05-workflows/) | 27 | 일상 작업·CI 통합·예약/자율 실행·병렬/worktree·동적 워크플로우·세션·고급 모드 |
| 06 | [설정 / 레퍼런스](06-config-reference/) | 13 | 환경 변수·플래그·권한·도구·샌드박스·에러 사전·용어집 |
| 07 | [엔터프라이즈 / 운영](07-enterprise/) | 20 | Bedrock·Vertex·Foundry·AWS·네트워크·보안·managed MCP·비용·조직 도입 |
| 08 | [What's New / 릴리스 노트](08-whats-new/) | 12 | 주별 변경 이력 (w13~w22) |

## 빠른 탐색

### "지금 뭘 하고 싶은지"별 진입점

| 하고 싶은 것 | 어디부터 |
|---|---|
| 처음 설치 | [`01-getting-started/setup.md`](01-getting-started/setup.md) → [`quickstart.md`](01-getting-started/quickstart.md) |
| 어떤 확장 포인트를 쓸지 결정 | [`01-getting-started/features-overview.md`](01-getting-started/features-overview.md) |
| 프로젝트별 지속 지침 주기 | [`03-extending/memory.md`](03-extending/memory.md) |
| 슬래시 명령 직접 만들기 | [`03-extending/skills.md`](03-extending/skills.md) |
| 전문 서브에이전트 만들기 | [`03-extending/sub-agents.md`](03-extending/sub-agents.md) |
| 파일 편집 후 자동 포맷 | [`03-extending/hooks-guide.md`](03-extending/hooks-guide.md) |
| 외부 도구(Jira/Slack/DB) 연결 | [`03-extending/mcp.md`](03-extending/mcp.md) |
| PR 자동 리뷰 | [`05-workflows/code-review.md`](05-workflows/code-review.md) + [`github-actions.md`](05-workflows/github-actions.md) |
| 클라우드 딥 리뷰 | [`05-workflows/ultrareview.md`](05-workflows/ultrareview.md) |
| 정기 작업 예약 | [`05-workflows/scheduled-tasks.md`](05-workflows/scheduled-tasks.md) + [`routines.md`](05-workflows/routines.md) |
| 조건 충족까지 자동 반복 (`/goal`) | [`05-workflows/goal.md`](05-workflows/goal.md) |
| 대규모 작업을 서브에이전트로 조율 | [`05-workflows/workflows.md`](05-workflows/workflows.md) |
| 세션 이름·재개·분기·전환 | [`05-workflows/sessions.md`](05-workflows/sessions.md) |
| 모노레포/대규모 코드베이스 설정 | [`05-workflows/large-codebases.md`](05-workflows/large-codebases.md) |
| 내 코드 보안 취약점 자동 검토 | [`05-workflows/security-guidance.md`](05-workflows/security-guidance.md) |
| MCP 빠르게 붙여보기 | [`03-extending/mcp-quickstart.md`](03-extending/mcp-quickstart.md) |
| 병렬 세션 격리(worktree) | [`05-workflows/worktrees.md`](05-workflows/worktrees.md) + [`agents.md`](05-workflows/agents.md) |
| 여러 세션 한눈에 관리 | [`02-environments/agent-view.md`](02-environments/agent-view.md) |
| 용어 빠르게 찾기 | [`06-config-reference/glossary.md`](06-config-reference/glossary.md) |
| 설치/로그인 에러 해결 | [`01-getting-started/troubleshoot-install.md`](01-getting-started/troubleshoot-install.md) |
| 권한·샌드박스 거는 법 | [`06-config-reference/permissions.md`](06-config-reference/permissions.md) + [`sandboxing.md`](06-config-reference/sandboxing.md) |
| 환경 변수 / 플래그 찾기 | [`06-config-reference/env-vars.md`](06-config-reference/env-vars.md) + [`cli-reference.md`](06-config-reference/cli-reference.md) |
| 에러 메시지 의미 찾기 | [`06-config-reference/errors.md`](06-config-reference/errors.md) |
| 나만의 AI 에이전트 만들기 | [`04-agent-sdk/quickstart.md`](04-agent-sdk/quickstart.md) |
| 비용/사용량 추적 | [`07-enterprise/costs.md`](07-enterprise/costs.md) + [`analytics.md`](07-enterprise/analytics.md) |
| Bedrock/Vertex/Foundry 설정 | [`07-enterprise/`](07-enterprise/) |

### 자주 쓸 만한 개별 페이지 Top 10

1. [skills.md](03-extending/skills.md) — 슬래시 명령 만들기
2. [sub-agents.md](03-extending/sub-agents.md) — 서브에이전트
3. [hooks-guide.md](03-extending/hooks-guide.md) — hooks 입문
4. [mcp.md](03-extending/mcp.md) — MCP 외부 도구 연결
5. [memory.md](03-extending/memory.md) — CLAUDE.md / auto memory
6. [common-workflows.md](05-workflows/common-workflows.md) — 일상 작업 패턴
7. [best-practices.md](05-workflows/best-practices.md) — 활용 패턴 모음
8. [permissions.md](06-config-reference/permissions.md) — 권한 시스템
9. [settings.md](06-config-reference/settings.md) — 설정 전체
10. [cli-reference.md](06-config-reference/cli-reference.md) — CLI 레퍼런스

## 한국어 / 영어 비율

총 146 페이지 중:
- 🇰🇷 **한국어 144 페이지** (99%)
- 🇬🇧 **영어 2 페이지** (1%, 한국어 번역 미제공이라 영문 원문 그대로 보존)

2026-06-11 sync 기준, 이전에 영문이던 Agent SDK 전체·What's New w13~w15·`voice-dictation`·`context-window`·`github-enterprise-server` 등에 한국어 번역이 들어와 교체되었습니다. 현재 영문으로 남은 페이지는 2개뿐:
- [`05-workflows/advisor.md`](05-workflows/advisor.md) — 신규 페이지, 아직 한국어 미제공
- [`08-whats-new/changelog.md`](08-whats-new/changelog.md) — 전체 릴리스 노트 (영문 원문 유지)

각 카테고리 README에서 ⓔ 마크로 표시.

## 활용 팁

### IDE에서 검색용으로 쓰기
```bash
# 클론 후 VS Code/IntelliJ로 폴더 열기
git clone https://github.com/SongJunSub/claude-code-docs-ko.git
# 전역 검색(Cmd+Shift+F)으로 "MCP", "skills" 같은 키워드 빠르게 찾기
```

### Claude Code 자체에 컨텍스트로 주기
프로젝트 CLAUDE.md에 다음 줄을 넣으면, 막힐 때마다 Claude가 바로 참조 가능:
```markdown
# Claude Code 문서 레퍼런스
공식 문서 한국어 큐레이션: ~/path/to/claude-code-docs-ko/
- 슬래시 명령 / hooks / MCP / sub-agents 관련해서 막히면 03-extending/ 참조
- 에러 메시지 / 권한 / 환경 변수는 06-config-reference/ 참조
```

### 갱신 방법
공식 문서가 업데이트되면 동일한 fetch 스크립트로 다시 받으면 됨:
```bash
bash .scripts/fetch.sh && bash .scripts/organize.sh
```
스크립트는 `.scripts/` 폴더에 있고, 각 페이지의 한국어 페이지가 추가되면 자동으로 한국어가 우선 적용됨.

## 디렉토리 구조

```
claude-code-docs-ko/
├── README.md                    # 이 파일
├── .scripts/
│   ├── manifest.tsv             # 146개 페이지 → 카테고리 매핑
│   ├── fetch.sh                 # 한국어 우선, 영어 fallback 다운로드
│   └── organize.sh              # 매니페스트 기반 카테고리 정리
├── 01-getting-started/          # 10 pages
├── 02-environments/             # 18 pages
├── 03-extending/                # 16 pages
├── 04-agent-sdk/                # 30 pages
├── 05-workflows/                # 27 pages
├── 06-config-reference/         # 13 pages
├── 07-enterprise/               # 20 pages
└── 08-whats-new/                # 12 pages (changelog만 영문)
```

## 라이선스

본 레포의 문서 내용 저작권은 [Anthropic](https://www.anthropic.com/)에 있으며, 본 레포는 개인 학습/참조 목적의 큐레이션입니다. 원본은 [code.claude.com/docs](https://code.claude.com/docs/ko/overview)에서 확인하세요.
