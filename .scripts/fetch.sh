#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$ROOT/.scripts/manifest.tsv"
LOG="$ROOT/.scripts/fetch.log"
: > "$LOG"

fetch_one() {
    local slug="$1" cat="$2"
    local out="$ROOT/$cat/$slug.md"
    mkdir -p "$(dirname "$out")"

    local url_ko="https://code.claude.com/docs/ko/$slug.md"
    local url_en="https://code.claude.com/docs/en/$slug.md"

    if curl -fsSL --max-time 30 "$url_ko" -o "$out.tmp" 2>/dev/null; then
        if [ -s "$out.tmp" ]; then
            mv "$out.tmp" "$out"
            echo "OK ko  $slug" >> "$LOG"
            return 0
        fi
    fi
    rm -f "$out.tmp"

    if curl -fsSL --max-time 30 "$url_en" -o "$out.tmp" 2>/dev/null; then
        if [ -s "$out.tmp" ]; then
            mv "$out.tmp" "$out"
            echo "OK en  $slug (ko unavailable)" >> "$LOG"
            return 0
        fi
    fi
    rm -f "$out.tmp"
    echo "FAIL   $slug" >> "$LOG"
    return 1
}

export -f fetch_one
export ROOT LOG

awk -F'\t' 'NF==2 {print $1 "\t" $2}' "$MANIFEST" \
  | xargs -n 1 -P 12 -I {} bash -c 'IFS=$'"'"'\t'"'"' read -r s c <<<"{}"; fetch_one "$s" "$c"'

echo "--- summary ---" | tee -a "$LOG"
grep -c '^OK ko' "$LOG"  | awk '{print "Korean OK: " $1}'  | tee -a "$LOG"
grep -c '^OK en' "$LOG"  | awk '{print "English fallback: " $1}'  | tee -a "$LOG"
grep -c '^FAIL'  "$LOG"  | awk '{print "Failed: " $1}'  | tee -a "$LOG"
echo "Total expected: $(wc -l < "$MANIFEST")" | tee -a "$LOG"
