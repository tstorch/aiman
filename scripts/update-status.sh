#!/bin/sh
# update-status.sh -- aggregate counts
set -eu
DIR=$(dirname "$0")
ROOT=$(cd "$DIR/.."; pwd)
. "$ROOT/scripts/lib/frontmatter.sh"
OUT="$ROOT/docs/status.md"
counts_tmp="$ROOT/.counts.$$"
: > "$counts_tmp"
scan_dir="$ROOT/artifacts"
[ -d "$scan_dir" ] || scan_dir="$ROOT"
find "$scan_dir" -type f -name '*.md' -not -path '*/_setup/*' -not -path '*/docs/*' -not -path '*/templates/*' -not -path '*/prompts/*' | while read -r f; do
  type=$(fm_get_field "$f" type || true)
  status=$(fm_get_field "$f" status || true)
  [ -n "$type" ] || continue
  printf '%s\t%s\n' "$type" "$status" >> "$counts_tmp"

done

types_total=$(awk '{print $1}' "$counts_tmp" | wc -l | tr -d ' ')
# build summary per type
summary=$(awk '{c[$1]++} END{for(k in c){printf "- %s: %d\n", k, c[k]}}' "$counts_tmp")

{
  cat <<HDR
---
id: STATUS
type: status
title: Status Overview
status: draft
updated: $(date -u +%Y-%m-%d)
---

Counts:

- artifacts: $types_total

Per Type:

$summary
HDR
} > "$OUT"

rm -f "$counts_tmp"

echo "Updated: $OUT"
