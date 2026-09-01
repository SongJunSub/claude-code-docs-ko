---
name: translation-status
description: 117개 페이지의 한국어/영어 번역 비율을 점검하고, 새로 한국어 번역이 들어온 페이지(영문 → 한국어로 교체할 후보)를 검출합니다. 매월 sync 후 실행.
allowed-tools: Bash Read
---

# /translation-status: 번역 상태 점검

## 절차

1. **현재 영문 fallback 페이지 목록 추출**
   - 각 카테고리 README에서 `ⓔ` 표시가 있는 페이지를 수집
   ```bash
   grep -hr "ⓔ" 0*-*/README.md | grep -oE '\[[a-z0-9/-]+\]' | sed 's/[][]//g' | sort -u
   ```

2. **각 영문 fallback 페이지에 대해 한국어 가용성 재확인**:
   ```bash
   for slug in <영문 fallback 목록>; do
     code=$(curl -fsSL -o /dev/null -w "%{http_code}" "https://code.claude.com/docs/ko/$slug.md" 2>/dev/null)
     if [ "$code" = "200" ]; then
       # 한국어 페이지가 200을 반환하지만 실제로 영어로 redirect되는 경우도 있으니 컨텐츠 길이도 체크
       size=$(curl -fsSL "https://code.claude.com/docs/ko/$slug.md" 2>/dev/null | wc -c)
       echo "AVAILABLE $slug ($size bytes)"
     else
       echo "STILL_EN $slug"
     fi
   done
   ```

3. **실제 한국어 vs 영어 휴리스틱 검증**
   - "AVAILABLE" 후보 중에서, 다운받은 컨텐츠를 임시로 받아 한글 글자 비율 검사:
   ```bash
   # 한글 음절 / 전체 문자 비율이 5% 이상이면 한국어로 간주
   ```
   - 비율 5% 미만이면 여전히 영어 → 제외

4. **fetch.log 기반 현재 상태 카운트**
   ```bash
   grep -c '^OK ko' .scripts/fetch.log
   grep -c '^OK en' .scripts/fetch.log
   ```

5. **결과 출력**

   ```
   📊 번역 상태 (2026-XX-XX 기준)
   ─────────────────────────────────────
     전체 페이지: 117
     한국어: N (N/117 = X%)
     영문 fallback: M (M/117 = Y%)
   ─────────────────────────────────────

   🆕 새로 한국어가 들어온 페이지 (K개):
     - agent-sdk/sessions      (이전 ⓔ → 한국어 OK)
     - agent-sdk/permissions   (이전 ⓔ → 한국어 OK)

   👉 다음 행동:
     1. /sync 로 한국어 콘텐츠로 교체
     2. 해당 카테고리 README에서 ⓔ 표시 제거:
        - 04-agent-sdk/README.md → sessions, permissions 줄
   ```

6. **새로 한국어가 들어온 페이지가 없으면**: `이번 점검에서 변화 없음. 다음 달에 다시 확인.`
