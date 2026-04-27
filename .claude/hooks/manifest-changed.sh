#!/usr/bin/env bash
# PostToolUse(Edit|Write) hook — manifest.tsv가 수정되면 사용자에게 /sync 실행을 안내한다.
# Claude Code는 stdin으로 JSON을 보낸다: { tool_input: { file_path: "..." } }

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# manifest.tsv가 수정된 경우만 알림
if [[ "$FILE_PATH" == *".scripts/manifest.tsv" ]]; then
    echo "" >&2
    echo "📝 manifest.tsv가 변경되었습니다." >&2
    echo "   다음 명령으로 다운로드 + 정리를 수행하세요:" >&2
    echo "     /sync" >&2
    echo "" >&2
fi

# 카테고리 README가 직접 편집된 경우 카운트 검증을 권유
if [[ "$FILE_PATH" =~ ^[0-9]+-[a-z-]+/README\.md$ ]]; then
    CATEGORY="$(dirname "$FILE_PATH")"
    EXPECTED=$(find "$CATEGORY" -name "*.md" -not -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "" >&2
    echo "📋 $CATEGORY/README.md 편집됨." >&2
    echo "   현재 폴더의 페이지 수: $EXPECTED" >&2
    echo "   README 표의 행 수가 일치하는지 확인하세요." >&2
    echo "   불일치 시: /refresh-readme $CATEGORY" >&2
    echo "" >&2
fi

# 항상 success로 종료 (정보성 알림)
exit 0
