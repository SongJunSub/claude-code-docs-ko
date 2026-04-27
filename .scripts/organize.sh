#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$ROOT/.scripts/manifest.tsv"

moved=0; missing=0
while IFS=$'\t' read -r slug cat; do
    [ -z "$slug" ] && continue
    src="$ROOT/$slug.md"
    base="$(basename "$slug")"
    dst="$ROOT/$cat/$base.md"
    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dst")"
        mv "$src" "$dst"
        moved=$((moved+1))
    else
        echo "MISSING: $src"
        missing=$((missing+1))
    fi
done < "$MANIFEST"

# Clean up empty directories left behind by slashed slugs
find "$ROOT" -type d -empty -not -path "$ROOT/.git*" -not -path "$ROOT/.scripts*" -delete

echo "Moved: $moved, Missing: $missing"
