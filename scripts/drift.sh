#!/bin/sh
# drift.sh -- detect duplication between central and agent prompts (POSIX)
set -eu
ROOT=$(cd "$(dirname "$0")/.."; pwd)
CENTRAL_DIR="$ROOT/prompts/central"
AGENT_DIR="$ROOT/prompts/agent"
fail=0
tmp1="$ROOT/.drift1.$$"; tmp2="$ROOT/.drift2.$$"; tmpo="$ROOT/.drifto.$$"
for c in "$CENTRAL_DIR"/*.md; do
  base=$(basename "$c")
  sed '1,/^---$/d' "$c" | sed '/^[[:space:]]*$/d' | sort -u > "$tmp1"
  for a in "$AGENT_DIR"/*.md; do
  sed '1,/^---$/d' "$a" | sed '/^[[:space:]]*$/d' | sort -u > "$tmp2"
    comm -12 "$tmp1" "$tmp2" > "$tmpo" || true
    if [ -s "$tmpo" ]; then
      echo "DRIFT: duplicate lines central=$base agent=$(basename "$a")"
      sed 's/^/  /' "$tmpo"
      fail=1
    fi
  done
done
rm -f "$tmp1" "$tmp2" "$tmpo"
[ $fail -eq 0 ] && echo "No drift duplicates" || echo "Drift detected"
exit $fail
