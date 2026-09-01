#!/usr/bin/env bash
# PreToolUse(Bash) hook: git commit 시 레포 일관성을 검증한다.
# 위반 발견 시 exit 2 로 차단하고 stderr 에 사유를 출력한다.
# git commit 외 명령에는 영향이 없다 (즉시 exit 0).
#
# 실제 검사는 .scripts/check-repo.sh 하나로 모았다.
# /ship 과 커밋 전 체크리스트가 같은 스크립트를 쓰므로 규칙이 갈라지지 않는다.

set -uo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

if [[ ! "$COMMAND" =~ ^git[[:space:]]+commit ]]; then
    exit 0
fi

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$ROOT" || exit 0

if OUTPUT="$(bash "$ROOT/.scripts/check-repo.sh" 2>&1)"; then
    exit 0
fi

echo "" >&2
echo "커밋 차단: 레포 일관성 검증 실패" >&2
echo "" >&2
echo "$OUTPUT" >&2
echo "" >&2
echo "위 이슈를 수정한 후 다시 커밋하세요." >&2
echo "차단을 우회하려면 hook 을 일시 비활성화하세요 (.claude/settings.json)." >&2
exit 2
