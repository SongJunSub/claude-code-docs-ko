---
name: refresh-readme
description: 카테고리 README의 페이지 표를 실제 폴더 내 .md 파일과 fetch.log를 기반으로 재생성합니다. 페이지 추가/삭제 후 또는 영문→한국어 교체 후 사용.
argument-hint: <category>
arguments: category
allowed-tools: Bash Read Edit
---

# /refresh-readme: 카테고리 README 페이지 표 재생성

대상 카테고리: **$1**

## 절차

1. **카테고리 검증**:
   - `$1`이 8개 카테고리 중 하나인지
   - `$1/README.md`가 존재하는지
   - `$1/`에 실제 `.md` 파일이 있는지

2. **현재 페이지 목록 수집**:
   ```bash
   ls $1/*.md | grep -v "README.md" | xargs -n1 basename | sed 's/\.md$//'
   ```

3. **각 페이지의 한국어/영어 상태 확인**:
   - `.scripts/fetch.log`에서 해당 slug 검색
   - `OK ko` → 한국어, `OK en` → 영어 fallback (ⓔ 마크)
   - log에 없으면 (오래된 파일) → 콘텐츠 첫 200자에서 한글 비율로 판정

4. **각 페이지의 한 줄 설명 추출**:
   - 페이지 본문 frontmatter 다음 첫 번째 단락 (`> ## Documentation Index` 블록 제외)
   - 또는 첫 번째 H1 다음 문장
   - 80자 이내로 다듬어서 한국어 한 줄로 정리
   - **이 작업은 doc-curator 서브에이전트에 위임** (페이지 수가 5개 이상일 때)

5. **기존 README의 표 영역 식별**:
   - `## 페이지 목록` 헤더 이후부터 다음 섹션 또는 `> ⓔ = ...` 줄 직전까지가 표 영역
   - 해당 영역만 재생성, 나머지(카테고리 의도 / 이럴 때 본다 / 추천 학습 순서) 보존

6. **새 표 생성**:
   ```markdown
   | 페이지 | 한 줄 |
   |---|---|
   | [slug](slug.md){ ⓔ if 영어} | 한 줄 설명 |
   ```
   - 페이지 정렬: 의미적 그룹이 있으면 보존, 없으면 알파벳 순

7. **하단 ⓔ 범례 처리**:
   - 영어 fallback 페이지가 1개 이상이면 `> ⓔ = 영어 원문 (한국어 번역 미제공)` 추가
   - 0개면 제거

8. **결과 출력**:
   ```
   ✅ $1/README.md 갱신 완료
     이전 페이지 수: M
     현재 페이지 수: N (added: A / removed: R)
     한국어: K
     영어 fallback: E (이전 EE → 변화 ΔE)
   ```

9. **변경 diff 표시** (`git diff $1/README.md`).

## 주의
- 카테고리 의도, "이럴 때 본다" 가이드 등 **표 외 영역은 절대 건드리지 않는다**
- 페이지 한 줄 설명을 새로 작성한 경우, 기존 설명과 다르면 사용자에게 비교 표시 후 진행
- 자동 commit 금지

## 참고
- doc-curator subagent: 한 줄 설명 작성 전문 (`.claude/agents/doc-curator.md`)
