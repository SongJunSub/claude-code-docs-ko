#!/usr/bin/env bash
# PreToolUse(Bash) hook — git commit 시 레포 일관성을 검증.
# 위반 발견 시 exit 2로 차단하고 stderr에 사유 출력.
# git commit 외 명령에는 영향 없음 (즉시 exit 0).

set -uo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# git commit 명령이 아니면 그대로 통과
if [[ ! "$COMMAND" =~ ^git[[:space:]]+commit ]]; then
    exit 0
fi

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$ROOT" || exit 0

ERRORS=()

# 1. 빈 .md 파일 검사
EMPTY_FILES=$(find . -name "*.md" -size 0 -not -path "./.git/*" -not -path "./.scripts/*" -not -path "./.claude/*" 2>/dev/null)
if [ -n "$EMPTY_FILES" ]; then
    ERRORS+=("빈 .md 파일이 있습니다:")
    while IFS= read -r f; do
        ERRORS+=("  - $f")
    done <<< "$EMPTY_FILES"
fi

# 2. 매니페스트 줄 수와 실제 페이지 수 비교
MANIFEST="$ROOT/.scripts/manifest.tsv"
if [ -f "$MANIFEST" ]; then
    MANIFEST_COUNT=$(awk 'NF>=2' "$MANIFEST" | wc -l | tr -d ' ')
    PAGE_COUNT=$(find . -name "*.md" -not -path "./.git/*" -not -path "./.scripts/*" -not -path "./.claude/*" -not -name "README.md" -not -name "CLAUDE.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$MANIFEST_COUNT" != "$PAGE_COUNT" ]; then
        ERRORS+=("매니페스트 ($MANIFEST_COUNT) ↔ 실제 페이지 ($PAGE_COUNT) 카운트 불일치")
        ERRORS+=("  → /sync 실행 또는 매니페스트 수정 필요")
    fi
fi

# 3. 카테고리 README 페이지 표 카운트와 폴더 내 .md 카운트 비교
for cat_readme in [0-9]*-*/README.md; do
    [ -f "$cat_readme" ] || continue
    CAT_DIR="$(dirname "$cat_readme")"
    ACTUAL=$(find "$CAT_DIR" -maxdepth 1 -name "*.md" -not -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
    # README의 테이블에서 페이지 행 추출 (`| [slug](slug.md)` 패턴)
    TABLE_ROWS=$(grep -cE '^\| \[[a-z0-9-]+\]\([a-z0-9-]+\.md\)' "$cat_readme" 2>/dev/null || echo "0")
    if [ "$ACTUAL" != "$TABLE_ROWS" ]; then
        ERRORS+=("$CAT_DIR/README.md: 표 행 ($TABLE_ROWS) ↔ 실제 페이지 ($ACTUAL) 불일치")
        ERRORS+=("  → /refresh-readme $CAT_DIR 권장")
    fi
done

# 결과
if [ ${#ERRORS[@]} -gt 0 ]; then
    echo "" >&2
    echo "❌ 커밋 차단: 레포 일관성 검증 실패" >&2
    echo "" >&2
    for err in "${ERRORS[@]}"; do
        echo "$err" >&2
    done
    echo "" >&2
    echo "위 이슈를 수정한 후 다시 커밋하세요." >&2
    echo "차단을 우회하려면 hook을 일시 비활성화 (.claude/settings.json)." >&2
    exit 2
fi

exit 0
