---
name: find-doc
description: 117개 Claude Code 문서 페이지에서 키워드를 검색해 관련 페이지와 카테고리를 찾습니다. "hooks 어디서 봐야 해?" "MCP 권한 설정" 같은 탐색 질문에 사용합니다.
argument-hint: <키워드>
arguments: keyword
allowed-tools: Bash Read
---

# /find-doc: 문서 검색

검색어: **$ARGUMENTS**

## 절차

1. **본문 검색** (대소문자 무시):
   ```bash
   grep -lir --include="*.md" "$ARGUMENTS" 0*-*/ | sort
   ```

2. **제목/헤딩 검색** (가중치 ↑):
   ```bash
   grep -lir --include="*.md" -E "^#+ .*$ARGUMENTS" 0*-*/ | sort
   ```

3. **각 매치 페이지에 대해**:
   - 카테고리 (폴더명)
   - 페이지 slug
   - 매치된 줄 컨텍스트 1~2줄
   - 한 줄로 정리: `[카테고리] slug: "...매치 컨텍스트..."`

4. **상위 5개만 출력**. 5개 초과면 마지막에 `... 외 N개 페이지에서 매치됨` 표시.

5. **카테고리별 요약 표** 추가:
   ```
   카테고리            매치 페이지 수
   03-extending/       3
   06-config-reference/ 2
   ```

6. **추천 진입점**: 상위 1~2 페이지를 "먼저 볼 페이지"로 강조.

## 출력 예시

```
🔍 "hooks" 검색 결과 (총 8개 페이지)

먼저 볼 페이지:
  1. [03-extending] hooks-guide.md: "Claude Code가 파일을 편집하거나..."
  2. [03-extending] hooks.md: "hook 이벤트, 설정 스키마, JSON I/O..."

기타 매치:
  - [04-agent-sdk] hooks.md
  - [06-config-reference] settings.md (hook 설정 부분)
  - ...

카테고리별:
  03-extending/      2
  04-agent-sdk/      1
  06-config-reference/ 1
```
