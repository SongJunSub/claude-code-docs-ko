# CLAUDE.md: Claude Code 한국어 문서 큐레이션 레포

## 이 레포의 정체
- **목적**: [code.claude.com/docs/ko](https://code.claude.com/docs/ko/overview)의 모든 페이지(146개)를 카테고리별로 풀텍스트 보존하는 개인 큐레이션
- **운영 모드**: 매월 1일 09:00 KST에 [routine](https://claude.ai/code/routines/trig_01KLXu6PZJF3khuCAEbT33nz)이 자동으로 fetch → organize → 변경 있으면 PR 생성
- **우선순위**: 한국어 원문 > 영어 fallback (공식 문서에 한국어판이 없으면 영어 보존)
- **영어 페이지는 특별 규칙이 아니다**: 특정 페이지를 영문으로 고정하지 않는다. 공식 문서에 한국어판이 생기면 다음 sync 에서 자동으로 한국어로 바뀐다

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
│   ├── fetch.sh              # 한국어 우선, 영어 fallback, HTML 응답 거부
│   ├── organize.sh           # manifest 기반 카테고리 정리
│   ├── check-repo.sh         # 커밋 전 일관성 검증 (hook 과 /ship 이 공용)
│   ├── check-pages.py        # ⓔ 마커 + 글쓰기 규칙 검사 (로케일 무관)
│   └── fetch.log             # 다운로드 로그 (gitignore)
├── 01-getting-started/       # 10 pages
├── 02-environments/          # 18 pages
├── 03-extending/             # 16 pages
├── 04-agent-sdk/             # 30 pages
├── 05-workflows/             # 27 pages
├── 06-config-reference/      # 13 pages
├── 07-enterprise/            # 20 pages
└── 08-whats-new/             # 12 pages
```

## 카테고리 8개의 의도

| 폴더 | 의도 |
|---|---|
| `01-getting-started/` | 처음 설치/로그인부터 첫 작업까지. 환경 선택과 동작 원리 |
| `02-environments/` | 어디서 띄울지: CLI, VS Code, JetBrains, Desktop, Web, Slack, Chrome, 터미널 환경 다듬기 |
| `03-extending/` | Claude Code 확장: Skills, Sub-agents, Hooks, MCP, Plugins, CLAUDE.md |
| `04-agent-sdk/` | Claude Code를 라이브러리로 사용해 에이전트 빌드 (Python/TypeScript) |
| `05-workflows/` | 일상 작업 패턴, CI 통합, 예약 실행, 고급 모드(/ultraplan, /ultrareview) |
| `06-config-reference/` | 환경 변수, 플래그, 권한, 도구, 에러 사전 (검색용) |
| `07-enterprise/` | Bedrock, Vertex, Foundry, 네트워크, 보안, 비용, 컴플라이언스 |
| `08-whats-new/` | 변경 이력. 주별 다이제스트와 버전별 릴리스 노트 |

## 매니페스트 형식 (`.scripts/manifest.tsv`)

```
<slug>\t<category>
```
- 탭(`\t`)으로 구분
- `slug`: docs 사이트의 경로 (예: `overview`, `agent-sdk/quickstart`, `whats-new/2026-w15`)
- `category`: 위 8개 폴더 이름 정확히
- 146줄, 추가/제거 시 정렬은 카테고리 순으로 유지

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
2. `bash .scripts/fetch.sh`: 새 페이지 다운로드 (한국어 우선)
3. `bash .scripts/organize.sh`: 카테고리 폴더로 이동
4. 해당 카테고리 README 표에 한 줄 추가 (한 줄 설명은 페이지 본문 첫 단락 기반)
5. 루트 README의 카테고리 카운트 업데이트
6. `git add . && git commit -m "docs: add <slug>"`

→ 위 1~5단계는 슬래시 명령 [`/add-page`](.claude/commands/add-page.md)로 자동화됨.

## 한국어 / 영어 교체 정책

영어로 남는 페이지는 "그렇게 정한 것"이 아니라 **공식 문서에 한국어판이 없어서 fallback 된 결과**다.
따라서 특정 슬러그를 영문으로 고정하는 규칙을 만들지 않는다. 한국어판이 생기면 다음 sync 에서 자동 교체된다.

1. 월간 sync routine이 다운로드한 결과를 [`/translation-status`](.claude/commands/translation-status.md)로 점검
2. "새로 한국어가 들어온 페이지"가 검출되면 해당 카테고리 README의 ⓔ 표시 제거
3. 반대로 새로 영어 fallback 된 페이지가 생기면 ⓔ 를 추가

### fetch 가 HTML 을 받는 경우
문서 사이트가 `.md` 경로에 마크다운 대신 HTML 페이지를 **HTTP 200** 으로 돌려주는 슬러그가 있다.
`ko/changelog.md` 가 그렇고, 한국어판이 없어 GitHub 블롭 페이지를 그대로 반환한다.
200 이라 `curl -f` 로는 걸러지지 않으므로 `fetch.sh` 가 두 단계로 막는다:

1. `Content-Type` 이 `text/markdown` 계열인지 확인
2. 본문 첫 비어 있지 않은 줄이 HTML 문서 시작(`<!doctype html`, `<html`)인지 확인

걸리면 저장하지 않고 다음 URL(영어)로 넘어간다. 두 URL 이 모두 실패하면 기존 파일을 그대로 두어
직전 정상 내용이 남는다. **이 가드를 제거하면 HTML 덤프가 한국어 페이지로 집계된다.**

## 절대 금지
- ❌ `master` 브랜치에 직접 push (브랜치와 PR을 통해서만 머지)
- ❌ `manifest.tsv`를 임의로 정렬하거나 재구조화 (카테고리 순서 보존)
- ❌ 카테고리 폴더 이름 변경 (`organize.sh`와 매니페스트가 의존)
- ❌ `README.md`의 페이지 카운트와 실제 `.md` 카운트 불일치 상태로 커밋
- ❌ 특정 슬러그를 영문으로 고정하는 규칙 추가 (한국어판이 생기면 자동 교체돼야 함)
- ❌ `fetch.sh`의 HTML 가드 제거 (제거하면 HTML 덤프가 한국어 페이지로 집계됨)

## 커밋부터 머지까지 자동 진행

검증을 통과한 변경은 사용자에게 되묻지 않고 커밋, 푸시, PR 생성, 머지, 로컬 master 갱신까지
[`/ship`](.claude/commands/ship.md)으로 끝까지 진행한다. 절차와 멈춰야 하는 조건은 그 문서에 있다.

핵심만 옮기면 다음과 같다.

1. `bash .scripts/check-repo.sh`로 사전 검증. 실패하면 여기서 멈추고 사용자에게 보고
2. 브랜치 생성 (`chore/sync-docs-<날짜>`, `fix/<slug>`, `feat/<slug>`)
3. 논리 단위로 나눠 커밋 (Conventional Commits, 본문은 한국어)
4. `git push -u origin <branch>`
5. `gh pr create --base master`
6. `gh pr view <N> --json mergeStateStatus`가 `CLEAN`인지 확인. CI가 있으면 통과까지 대기
7. `gh pr merge <N> --merge` (기존 이력이 merge commit 방식이므로 squash로 바꾸지 않는다)
8. `git checkout master && git pull --ff-only origin master`
9. 커밋 수, PR 번호, 머지 커밋 해시를 함께 보고

다음 경우에는 자동으로 넘기지 않고 사용자에게 묻는다.

- 사전 검증 실패
- 페이지 수와 매니페스트 줄 수 불일치
- `fetch.log`의 `Failed`가 0이 아님
- sync가 아닌데 변경 파일이 100개를 넘음
- PR에 사용자 아닌 리뷰어의 코멘트가 달림

## 글쓰기 규칙

레포가 직접 작성하는 모든 문서에 적용한다. 업스트림에서 받은 페이지는 원문이므로 손대지 않는다.
대상은 루트 `README.md`, `CLAUDE.md`, 카테고리 `README.md`, `.claude/commands/`, `.claude/agents/`이다.

세 문자를 금지한다. 한국어 실무 문서에서 쓰지 않는 문장부호라 기계가 쓴 티가 난다.

| 금지 | 코드포인트 | 쓰던 자리 | 대신 쓸 것 |
|---|---|---|---|
| em dash | U+2014 | 라벨과 설명을 잇는 자리 | `:` |
| | | 부연이나 삽입구 | 쉼표 또는 괄호 |
| | | 목록 항목과 설명 구분 | `-` |
| en dash | U+2013 | 범위 표기 | `~` (`3월 23~27`, `2020-07-01 ~ 2030-07-01`) |
| 가운뎃점 | U+00B7 | 대등한 항목 나열 | 쉼표 |
| | | 마지막 항목을 잇는 자리 | `및` |
| | | 택일이나 구분 | `/` |

하이픈 `-`와 물결 `~`는 정상 사용한다. 금지 대상은 위 세 글자다.

`bash .scripts/check-repo.sh`가 이 규칙을 검사하고, `git commit` 시 precommit hook이 같은
스크립트로 차단한다. 금지 문자 목록은 [`.scripts/check-pages.py`](.scripts/check-pages.py)의
`BANNED_PUNCTUATION`에 있다.

## 자주 쓰는 명령

| 명령 | 용도 |
|---|---|
| `/sync` | fetch + organize 실행, 결과 요약 |
| `/find-doc <키워드>` | 146개 문서에서 키워드 검색 |
| `/translation-status` | 한국어/영어 비율 + 새 한국어 페이지 검출 |
| `/add-page <slug> <category>` | 새 페이지 매니페스트 추가 + 다운로드 + README 갱신 |
| `/refresh-readme <category>` | 카테고리 README 표 재생성 |
| `/ship` | 커밋, 푸시, PR 생성, 머지, 로컬 master 갱신까지 일괄 수행 |

| Bash 명령 | 용도 |
|---|---|
| `bash .scripts/fetch.sh` | 모든 페이지 다운로드 (병렬) |
| `bash .scripts/organize.sh` | 매니페스트 기반 카테고리 정리 |
| `bash .scripts/check-repo.sh` | 커밋 전 일관성 검증 (빈 파일, HTML 혼입, 카운트, ⓔ, 글쓰기 규칙) |
| `find . -name "*.md" -not -path "./.git/*" \| wc -l` | 전체 .md 카운트 (정상값: 162 = 146 페이지 + 8 카테고리 README + 루트 README + CLAUDE.md + `.claude/` 6개) |
| `find . -name "*.md" -not -path "./.git/*" -not -path "./.claude/*" -not -name README.md -not -name CLAUDE.md \| wc -l` | 페이지만 카운트 (정상값: 146, 매니페스트 줄 수와 같아야 함) |
| `gh pr list --base master` | 월간 sync routine이 만든 PR 목록 |

## 검증 체크리스트 (커밋 전)
- [ ] `.md` 카운트가 카테고리 README들의 페이지 수 합과 일치
- [ ] 빈 파일(0 byte) 없음: `find . -name "*.md" -size 0`
- [ ] 매니페스트 줄 수 = 146 (페이지 추가 시 변경)
- [ ] 카테고리 README의 ⓔ 표시가 실제 영어 fallback 페이지와 일치
- [ ] HTML 이 섞여 들어오지 않았는지: 아래 명령이 아무것도 출력하지 않아야 함
      ```bash
      for f in 0*/*.md; do
          awk 'NF { sub(/^[[:space:]]+/, ""); if (tolower($0) ~ /^<!doctype html|^<html[ >]/) print FILENAME; exit }' "$f"
      done
      ```
- [ ] `fetch.log` 요약의 `Failed` 가 0 (0 이 아니면 해당 슬러그를 확인)

## 참조

- [3-extending/skills.md](03-extending/skills.md): Skill 작성 형식
- [3-extending/sub-agents.md](03-extending/sub-agents.md): Sub-agent 작성 형식
- [3-extending/hooks-guide.md](03-extending/hooks-guide.md): Hook 작성 형식
- [6-config-reference/permissions.md](06-config-reference/permissions.md): 권한 패턴
- [6-config-reference/settings.md](06-config-reference/settings.md): settings.json 전체 스키마
