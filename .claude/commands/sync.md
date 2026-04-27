---
name: sync
description: Claude Code 공식 문서를 다시 다운로드하고 카테고리별로 정리한 뒤 변경 사항을 요약합니다. 새 페이지가 추가됐거나 한국어 번역이 들어왔는지 확인할 때 사용합니다.
allowed-tools: Bash Read
---

# /sync — 공식 문서 동기화

## 절차

1. **다운로드 실행**
   ```bash
   bash .scripts/fetch.sh
   ```

2. **카테고리 정리**
   ```bash
   bash .scripts/organize.sh
   ```

3. **결과 요약** — 다음을 모두 출력:
   - `git status --porcelain`로 변경된 파일 목록
   - `.scripts/fetch.log`에서 한국어 / 영어 fallback / FAIL 카운트
   - `find . -name "*.md" -not -path "./.git/*" -not -path "./.scripts/*" | wc -l` (정상값 126)
   - 빈 파일 검사: `find . -name "*.md" -size 0 -not -path "./.git/*"`

4. **이상 검출** — 아래 중 하나라도 해당하면 즉시 사용자에게 경고:
   - `.md` 카운트가 100개 미만
   - 빈 파일이 있음
   - FAIL 항목이 5개 이상

5. **결과 표 출력** — 다음 형식:
   ```
   📊 Sync 결과
   ─────────────────────────────────
     한국어 페이지:   N
     영어 fallback:  M
     실패:           K
     변경 파일:      L
     전체 .md:       126 (정상)
   ─────────────────────────────────
   ```

6. **다음 단계 제안**:
   - 변경된 파일 중 README.md가 없는데 새 페이지가 추가됐다면: "/refresh-readme <category> 권장"
   - 영어 → 한국어로 바뀐 페이지가 있으면: "ⓔ 표시 제거 필요"
   - 변경 없으면: "이번 동기화는 변경 없음"

## 주의
- 매월 1일 09:00 KST에 routine이 자동으로 동일한 작업 + PR 생성을 수행함. 수동 /sync는 routine 사이에 강제 갱신이 필요할 때만 사용.
- 이 명령은 git commit/push를 하지 않음. 검토 후 사용자가 수동 커밋.
