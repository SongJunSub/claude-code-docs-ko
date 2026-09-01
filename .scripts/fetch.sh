#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$ROOT/.scripts/manifest.tsv"
LOG="$ROOT/.scripts/fetch.log"
: > "$LOG"

# 받은 파일이 실제 마크다운인지 검사한다.
# 문서 사이트가 .md 경로에 HTML 페이지를 200으로 응답하는 슬러그가 있다.
# (예: ko/changelog.md 는 한국어판이 없어 GitHub 블롭 페이지를 그대로 돌려준다)
# 200 이라 curl -f 로는 걸러지지 않고, 그대로 저장하면 영어 fallback 이 영영
# 시도되지 않은 채 HTML 덤프가 한국어 페이지로 집계된다.
# 첫 비어 있지 않은 줄이 HTML 문서 시작이면 마크다운이 아닌 것으로 본다.
# (본문에서 <html> 을 인라인으로 언급하는 정상 문서를 오탐하지 않도록 첫 줄만 본다)
is_markdown() {
    local f="$1" first_line
    [ -s "$f" ] || return 1
    first_line="$(awk 'NF { sub(/^[[:space:]]+/, ""); print tolower($0); exit }' "$f")"
    case "$first_line" in
        '<!doctype html'*|'<html>'*|'<html '*) return 1 ;;
    esac
    return 0
}

# URL 하나를 받아 마크다운일 때만 저장한다.
# 1차로 Content-Type 을 보고(문서 사이트는 정상 페이지에 text/markdown 을 준다),
# 2차로 본문 첫 줄을 확인한다.
# 실패하면 기존 파일을 건드리지 않으므로 직전 정상 내용이 남는다.
try_download() {
    local url="$1" out="$2" ctype
    if ! ctype="$(curl -fsSL --max-time 30 -w '%{content_type}' "$url" -o "$out.tmp" 2>/dev/null)"; then
        rm -f "$out.tmp"
        return 1
    fi
    case "$ctype" in
        text/markdown*|text/plain*) ;;
        *) rm -f "$out.tmp"; return 1 ;;
    esac
    if is_markdown "$out.tmp"; then
        mv "$out.tmp" "$out"
        return 0
    fi
    rm -f "$out.tmp"
    return 1
}

fetch_one() {
    local slug="$1" cat="${2:-}"
    # organize.sh가 ROOT/<slug>.md 위치를 기대하므로 슬러그 경로 그대로 루트에 받는다.
    # (agent-sdk/*, whats-new/* 처럼 슬래시 포함 슬러그는 임시 서브디렉토리에 받고,
    #  이후 organize.sh가 카테고리 폴더로 옮긴 뒤 빈 디렉토리를 정리한다.)
    local out="$ROOT/$slug.md"
    mkdir -p "$(dirname "$out")"

    if try_download "https://code.claude.com/docs/ko/$slug.md" "$out"; then
        echo "OK ko  $slug" >> "$LOG"
        return 0
    fi

    if try_download "https://code.claude.com/docs/en/$slug.md" "$out"; then
        echo "OK en  $slug (ko unavailable)" >> "$LOG"
        return 0
    fi

    echo "FAIL   $slug" >> "$LOG"
    return 1
}

export -f fetch_one try_download is_markdown
export ROOT LOG

awk -F'\t' 'NF==2 {print $1 "\t" $2}' "$MANIFEST" \
  | xargs -n 1 -P 12 -I {} bash -c 'IFS=$'"'"'\t'"'"' read -r s c <<<"{}"; fetch_one "$s" "$c"'

echo "--- summary ---" | tee -a "$LOG"
grep -c '^OK ko' "$LOG"  | awk '{print "Korean OK: " $1}'  | tee -a "$LOG"
grep -c '^OK en' "$LOG"  | awk '{print "English fallback: " $1}'  | tee -a "$LOG"
grep -c '^FAIL'  "$LOG"  | awk '{print "Failed: " $1}'  | tee -a "$LOG"
echo "Total expected: $(wc -l < "$MANIFEST")" | tee -a "$LOG"
