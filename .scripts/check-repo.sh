#!/usr/bin/env bash
# 커밋 / PR 전에 레포 일관성을 한 번에 검증한다.
# CLAUDE.md 의 검증 체크리스트를 실행 가능한 형태로 옮긴 것이고,
# /ship 과 precommit hook 이 같이 쓴다.
# 위반이 있으면 사유를 출력하고 exit 1.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

MANIFEST="$ROOT/.scripts/manifest.tsv"
LOG="$ROOT/.scripts/fetch.log"
errors=0

fail() {
    echo "  x $*" >&2
    errors=$((errors + 1))
}

# 1. 빈 페이지
empty="$(find . -name "*.md" -size 0 -not -path "./.git/*" -not -path "./.scripts/*" -not -path "./.claude/*" 2>/dev/null)"
if [ -n "$empty" ]; then
    fail "빈 .md 파일:"
    echo "$empty" | sed 's/^/      /' >&2
fi

# 2. HTML 혼입
# 문서 사이트가 .md 경로에 HTML 을 200 으로 주는 경우가 있어(fetch.sh 가드 참고)
# 페이지 파일에 HTML 문서가 섞이지 않았는지 첫 줄로 확인한다.
html_hits="$(for f in 0*/*.md; do
    awk 'NF { sub(/^[[:space:]]+/, ""); if (tolower($0) ~ /^<!doctype html|^<html[ >]/) print FILENAME; exit }' "$f"
done)"
if [ -n "$html_hits" ]; then
    fail "HTML 페이지가 마크다운으로 저장돼 있음:"
    echo "$html_hits" | sed 's/^/      /' >&2
fi

# 3. 페이지 수와 매니페스트 줄 수 일치
page_count="$(find . -name "*.md" -not -path "./.git/*" -not -path "./.scripts/*" \
    -not -path "./.claude/*" -not -name "README.md" -not -name "CLAUDE.md" 2>/dev/null | wc -l | tr -d ' ')"
manifest_count="$(awk -F'\t' 'NF>=2 && $1 != ""' "$MANIFEST" | wc -l | tr -d ' ')"
if [ "$page_count" != "$manifest_count" ]; then
    fail "페이지 수($page_count)와 매니페스트 줄 수($manifest_count)가 다름"
fi

# 4. 카테고리 README 표 행 수와 폴더 내 페이지 수 일치
for cat_readme in [0-9]*-*/README.md; do
    [ -f "$cat_readme" ] || continue
    dir="$(dirname "$cat_readme")"
    actual="$(find "$dir" -maxdepth 1 -name "*.md" -not -name "README.md" 2>/dev/null | wc -l | tr -d ' ')"
    rows="$(grep -cE '^\| \[[a-z0-9-]+\]\([a-z0-9-]+\.md\)' "$cat_readme" 2>/dev/null || true)"
    if [ "$actual" != "$rows" ]; then
        fail "$cat_readme: 표 행($rows)과 실제 페이지($actual) 불일치, /refresh-readme $dir 권장"
    fi
done

# 5, 6. ⓔ 마커 일치와 글쓰기 규칙
#       문자 단위 판정은 로케일 영향을 받지 않도록 파이썬에서 처리한다.
if ! page_check="$(python3 "$ROOT/.scripts/check-pages.py" 2>&1)"; then
    fail "페이지 검사 실패:"
    echo "$page_check" | sed 's/^/  /' >&2
fi

# 7. 마지막 fetch 에서 실패한 슬러그가 있는지 (로그가 있을 때만)
if [ -f "$LOG" ]; then
    failed="$(grep -c '^FAIL' "$LOG" || true)"
    if [ "$failed" != "0" ]; then
        fail "fetch.log 에 실패 $failed 건, 해당 슬러그 확인 필요"
    fi
fi

if [ "$errors" -gt 0 ]; then
    echo "" >&2
    echo "검증 실패: $errors 건" >&2
    exit 1
fi

echo "검증 통과: 페이지 $page_count, 매니페스트 $manifest_count"
exit 0
