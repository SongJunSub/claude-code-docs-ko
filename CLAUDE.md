# CLAUDE.md — Claude Code 한국어 문서 큐레이션 레포

## 이 레포의 정체
- **목적**: [code.claude.com/docs/ko](https://code.claude.com/docs/ko/overview)의 모든 페이지(131개)를 카테고리별로 풀텍스트 보존하는 개인 큐레이션
- **운영 모드**: 매월 1일 09:00 KST에 [routine](https://claude.ai/code/routines/trig_01KLXu6PZJF3khuCAEbT33nz)이 자동으로 fetch → organize → 변경 있으면 PR 생성
- **우선순위**: 한국어 원문 > 영어 fallback (한국어 번역이 없으면 영어 보존)

## 디렉토리 구조

```
claude-code-docs-ko/
├── README.md                 # 레포 소개 + 빠른 탐색
├── CLAUDE.md                 # 이 파일
├── .claude/
│   ├── settings.json         # 권한 + hook 등록
│   ├── commands/             # 슬래시 명령 (Skills)
│   ├── agents/               # 서브에이전트
│   └── hooks/                # hook 스크립트
├── .scripts/
│   ├── manifest.tsv          # 페이지 ↔ 카테고리 매핑 (단일 진실 원천)
│   ├── fetch.sh              # 한국어 우선, 영어 fallback 다운로드
│   ├── organize.sh           # manifest 기반 카테고리 정리
│   └── fetch.log             # 다운로드 로그 (gitignore)
├── 01-getting-started/       # 10 pages
├── 02-environments/          # 18 pages
├── 03-extending/             # 14 pages
├── 04-agent-sdk/             # 29 pages
├── 05-workflows/             # 20 pages
├── 06-config-reference/      # 12 pages
├── 07-enterprise/            # 19 pages
└── 08-whats-new/             # 9 pages (일부 영문)
```

## 카테고리 8개의 의도

| 폴더 | 의도 |
|---|---|
| `01-getting-started/` | 처음 설치/로그인부터 첫 작업까지. 환경 선택과 동작 원리 |
| `02-environments/` | 어디서 띄울지 — CLI·VS Code·JetBrains·Desktop·Web·Slack·Chrome·터미널 환경 다듬기 |
| `03-extending/` | Claude Code 확장 — Skills·Sub-agents·Hooks·MCP·Plugins·CLAUDE.md |
| `04-agent-sdk/` | Claude Code를 라이브러리로 사용해 에이전트 빌드 (Python/TypeScript) |
| `05-workflows/` | 일상 작업 패턴, CI 통합, 예약 실행, 고급 모드(/ultraplan, /ultrareview) |
| `06-config-reference/` | 환경 변수·플래그·권한·도구·에러 사전 (검색용) |
| `07-enterprise/` | Bedrock·Vertex·Foundry·네트워크·보안·비용·컴플라이언스 |
| `08-whats-new/` | 변경 이력 (전체 영문) |

## 매니페스트 형식 (`.scripts/manifest.tsv`)

```
<slug>\t<category>
```
- 탭(`\t`)으로 구분
- `slug`: docs 사이트의 경로 (예: `overview`, `agent-sdk/quickstart`, `whats-new/2026-w15`)
- `category`: 위 8개 폴더 이름 정확히
- 131줄, 추가/제거 시 정렬은 카테고리 순으로 유지

## README 작성 컨벤션

### 카테고리 README (`<category>/README.md`)
- 카테고리 의도 1~2줄
- "이럴 때 본다" 가이드 (3~5줄)
- 페이지 목록 표:
  ```markdown
  | 페이지 | 한 줄 |
  |---|---|
  | [overview](overview.md) | 설명 |
  ```
- 영문 fallback 페이지는 페이지 표시 옆에 ⓔ 표시:
  ```markdown
  | [agent-loop](agent-loop.md) ⓔ | ... |
  ```
- 카테고리 README 하단에 `> ⓔ = 영어 원문 (한국어 번역 미제공)` 추가

### 루트 README
- "지금 뭘 하고 싶은지"별 진입점 표 유지
- "자주 쓸 만한 개별 페이지 Top 10" 유지
- 페이지 카운트는 카테고리 변경 시 같이 업데이트

## 새 페이지 추가 절차
1. `.scripts/manifest.tsv`에 `slug<TAB>category` 한 줄 추가 (카테고리 그룹 안 알파벳 순)
2. `bash .scripts/fetch.sh` — 새 페이지 다운로드 (한국어 우선)
3. `bash .scripts/organize.sh` — 카테고리 폴더로 이동
4. 해당 카테고리 README 표에 한 줄 추가 (한 줄 설명은 페이지 본문 첫 단락 기반)
5. 루트 README의 카테고리 카운트 업데이트
6. `git add . && git commit -m "docs: add <slug>"`

→ 위 1~5단계는 슬래시 명령 [`/add-page`](.claude/commands/add-page.md)로 자동화됨.

## 한국어 / 영어 교체 정책
공식 문서에 한국어 번역이 새로 들어오면 영문 fallback 페이지를 한국어로 교체해야 한다:
1. 월간 sync routine이 다운로드한 결과를 [`/translation-status`](.claude/commands/translation-status.md)로 점검
2. "새로 한국어가 들어온 페이지"가 검출되면 해당 카테고리 README의 ⓔ 표시 제거

## 절대 금지
- ❌ `master` 브랜치에 직접 push (PR을 통해서만 머지)
- ❌ `manifest.tsv`를 임의로 정렬/재구조 (카테고리 순서 보존)
- ❌ 카테고리 폴더 이름 변경 (`organize.sh`와 매니페스트가 의존)
- ❌ `README.md`의 페이지 카운트와 실제 `.md` 카운트 불일치 상태로 커밋

## 자주 쓰는 명령

| 명령 | 용도 |
|---|---|
| `/sync` | fetch + organize 실행, 결과 요약 |
| `/find-doc <키워드>` | 117개 문서에서 키워드 검색 |
| `/translation-status` | 한국어/영어 비율 + 새 한국어 페이지 검출 |
| `/add-page <slug> <category>` | 새 페이지 매니페스트 추가 + 다운로드 + README 갱신 |
| `/refresh-readme <category>` | 카테고리 README 표 재생성 |

| Bash 명령 | 용도 |
|---|---|
| `bash .scripts/fetch.sh` | 모든 페이지 다운로드 (병렬) |
| `bash .scripts/organize.sh` | 매니페스트 기반 카테고리 정리 |
| `find . -name "*.md" -not -path "./.git/*" \| wc -l` | 전체 .md 카운트 (정상값: 140 = 131 페이지 + 8 카테고리 README + 1 루트) |
| `gh pr list --base master` | 월간 sync routine이 만든 PR 목록 |

## 검증 체크리스트 (커밋 전)
- [ ] `.md` 카운트가 카테고리 README들의 페이지 수 합과 일치
- [ ] 빈 파일(0 byte) 없음: `find . -name "*.md" -size 0`
- [ ] 매니페스트 줄 수 = 131 (페이지 추가 시 변경)
- [ ] 카테고리 README의 ⓔ 표시가 실제 영어 fallback 페이지와 일치

## 참조

- [3-extending/skills.md](03-extending/skills.md) — Skill 작성 형식
- [3-extending/sub-agents.md](03-extending/sub-agents.md) — Sub-agent 작성 형식
- [3-extending/hooks-guide.md](03-extending/hooks-guide.md) — Hook 작성 형식
- [6-config-reference/permissions.md](06-config-reference/permissions.md) — 권한 패턴
- [6-config-reference/settings.md](06-config-reference/settings.md) — settings.json 전체 스키마
