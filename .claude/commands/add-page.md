---
name: add-page
description: 공식 문서에 새 페이지가 추가됐을 때 매니페스트에 추가하고 다운로드한 뒤 해당 카테고리 README도 갱신합니다. 사용법 /add-page <slug> <category>
argument-hint: <slug> <category>
arguments: slug category
allowed-tools: Bash Read Edit
---

# /add-page: 새 페이지 추가

- slug: **$1**
- category: **$2**

## 절차

1. **사전 검증**
   - 카테고리가 8개 중 하나인지 확인 (`01-getting-started`, `02-environments`, `03-extending`, `04-agent-sdk`, `05-workflows`, `06-config-reference`, `07-enterprise`, `08-whats-new`)
   - 매니페스트에 이미 같은 slug가 있는지 검사:
     ```bash
     grep -P "^$1\t" .scripts/manifest.tsv && echo "이미 매니페스트에 있음. abort." && exit 1
     ```
   - URL 가용성 확인:
     ```bash
     curl -fsSL -o /dev/null -w "%{http_code}\n" "https://code.claude.com/docs/ko/$1.md"
     # 200 또는 영어 fallback URL 200이어야 함
     ```

2. **매니페스트에 추가** (해당 카테고리 그룹 내 알파벳 순으로 삽입):
   - 새 줄 형식: `<slug>\t<category>` (탭 구분, 정확히 1개 탭)
   - awk로 카테고리 그룹 찾아 알파벳 순 위치에 삽입
   - sort 후 카운트 검증 (이전 + 1)

3. **다운로드 + 정리**:
   ```bash
   bash .scripts/fetch.sh
   bash .scripts/organize.sh
   ```

4. **다운로드 검증**:
   - `<category>/<basename($1)>.md`가 존재하는지
   - 0 byte가 아닌지
   - 한국어인지 영어 fallback인지 확인 (fetch.log 마지막 항목)

5. **doc-curator 서브에이전트 호출**해서 한 줄 설명 생성:
   - 입력: 다운로드된 페이지 본문 첫 단락
   - 출력: 한국어 한 줄 설명 (40~80자)

6. **카테고리 README 표 갱신**:
   - 해당 카테고리 README에서 페이지 표를 찾고
   - 새 페이지 줄 삽입: `| [slug](slug.md){ ⓔ if 영어} | <한 줄 설명> |`
   - 가능하면 알파벳 순 또는 의미적 그룹 안 적절한 위치에

7. **루트 README 카운트 업데이트**:
   - 해당 카테고리의 페이지 수를 +1
   - "Fetch 시점" 날짜 갱신

8. **결과 출력**:
   ```
   ✅ 페이지 추가 완료
     slug: <slug>
     category: <category>
     언어: 한국어 / 영어 fallback
     크기: N bytes
     매니페스트: 117 → 118줄
     README 갱신: <category>/README.md, README.md
   ```

9. **사용자에게 다음 단계 안내**:
   - 변경 사항 검토 후 `git add . && git commit -m "docs: add <slug>"`
   - PR 만들기 전 `/sync`로 전체 일관성 재검증 권장

## 절대 금지
- 카테고리를 임의 변경하지 말 것. 사용자가 지정한 그대로
- 매니페스트의 다른 줄 정렬 변경 금지. 새 줄 삽입만
- 자동 commit/push 금지 (사용자 확인 단계)
