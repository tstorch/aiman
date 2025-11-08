#!/bin/sh
# drift.sh -- detect duplication between central and agent prompts
set -eu
ROOT=$(cd "$(dirname "$0")/.."; pwd)
CENTRAL_DIR="$ROOT/prompts/central"
AGENT_DIR="$ROOT/prompts/agent"
fail=0
for c in "$CENTRAL_DIR"/*.md; do
  base=$(basename "$c")
  for a in "$AGENT_DIR"/*.md; do
    dup=$(comm -12 <(sed '1,/^---$/d' "$c" | sort) <(sed '1,/^---$/d' "$a" | sort) || true)
    if [ -n "$dup" ]; then
      echo "DRIFT: duplicate lines central=$base agent=$(basename "$a")"; echo "$dup" | sed 's/^/  /'
      fail=1
    fi
  done
done
[ $fail -eq 0 ] && echo "No drift duplicates" || echo "Drift detected"
exit $fail
