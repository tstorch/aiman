#!/bin/sh
# render-prompt.sh -- compose prompt central->agent->model and hash
set -eu
DIR=$(dirname "$0")
ROOT=$(cd "$DIR/.."; pwd)
. "$ROOT/scripts/lib/frontmatter.sh"
AGENT=""; MODEL=""; TASK="global_guardrails"; OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2;;
    --model) MODEL="$2"; shift 2;;
    --task) TASK="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    --help) echo "Usage: render-prompt.sh [--task file_basename] [--agent name] [--model id] [--out path]"; exit 0;;
    *) echo "Unknown arg $1"; exit 1;;
  esac
done
CENTRAL="$ROOT/prompts/central/${TASK}.md"
[ -f "$CENTRAL" ] || { echo "Central task not found: $CENTRAL"; exit 1; }
AGENT_FILE="$ROOT/prompts/agent/${AGENT}.md"
MODEL_FILE="$ROOT/prompts/model/${MODEL}.md"
TMP="$ROOT/.prompt.$$"
{
  echo "# Central"
  sed '1,/^---$/d' "$CENTRAL" | sed '1,/^---$/d'
  if [ -n "$AGENT" ] && [ -f "$AGENT_FILE" ]; then
    echo "\n# Agent Addendum ($AGENT)"
    sed '1,/^---$/d' "$AGENT_FILE" | sed '1,/^---$/d'
  fi
  if [ -n "$MODEL" ] && [ -f "$MODEL_FILE" ]; then
    echo "\n# Model Addendum ($MODEL)"
    sed '1,/^---$/d' "$MODEL_FILE" | sed '1,/^---$/d'
  fi
} > "$TMP"
# normalize: trim trailing spaces, collapse multiple blank lines
NORM="$ROOT/.prompt_norm.$$"
awk 'BEGIN{prev=""} {gsub(/[ \t]+$/,"",$0); if($0=="" && prev=="") next; print; prev=$0}' "$TMP" > "$NORM"
HASH=$(shasum -a 256 "$NORM" 2>/dev/null | awk '{print $1}')
[ -n "$HASH" ] || HASH=$(openssl dgst -sha256 "$NORM" | awk '{print $2}')
OUT=${OUT:-"$ROOT/prompts/rendered/${TASK}-${AGENT:-na}-${MODEL:-na}.md"}
{
  cat <<HDR
---
id: PROMPT-${TASK}-${AGENT:-na}-${MODEL:-na}
type: rendered-prompt
title: Rendered Prompt $TASK ($AGENT/$MODEL)
status: draft
created: $(date -u +%Y-%m-%d)
updated: $(date -u +%Y-%m-%d)
created_by:
  agent: ${AIMAN_AGENT:-manual}
  model: ${AIMAN_MODEL:-}
  version: ""
generated_with:
  tool: render-prompt.sh
  command: render --task $TASK --agent $AGENT --model $MODEL
  prompt_ref: $CENTRAL
  prompt_hash: $HASH
---
HDR
  cat "$NORM"
} > "$OUT"
rm -f "$TMP" "$NORM"
echo "Rendered: $OUT (hash=$HASH)"