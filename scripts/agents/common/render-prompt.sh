#!/usr/bin/env bash
set -euo pipefail

# Renders a composed prompt for a given agent and task.
# Usage:
#   render-prompt.sh --agent <copilot|claude|openai|goose> --task <adr|ace_reflection|sprint_planning|status_update|code_change|implementation|knowledge_ingestion> [--context file1,file2,...]
# Output: Combined markdown to stdout.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/../../.." && pwd)"

agent=""
task=""
context_csv=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) agent="${2:-}"; shift 2;;
    --task) task="${2:-}"; shift 2;;
    --context) context_csv="${2:-}"; shift 2;;
    -h|--help) sed -n '1,20p' "$0"; exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

[[ -z "$agent" || -z "$task" ]] && { echo "Missing --agent or --task" >&2; exit 2; }

# Map generic task names to file names
case "$task" in
  adr) task_file="adr_prompt.md";;
  ace_reflection) task_file="ace_reflection_prompt.md";;
  sprint_planning) task_file="sprint_planning_prompt.md";;
  status_update) task_file="status_update_prompt.md";;
  code_change) task_file="code_change_prompt.md";;
  implementation) task_file="implementation_prompt.md";;
  knowledge_ingestion) task_file="knowledge_ingestion_prompt.md";;
  *) echo "Unknown task: $task" >&2; exit 3;;
esac

# Always use the canonical central prompt for the task
TASK_PROMPT="$ROOT/prompts/$task_file"
# Agent-specific addendum (optional)
agent_task_path="$ROOT/prompts/agents/$agent/${task}.md"

GUIDE="$ROOT/prompts/agent_guidelines.md"
CONFIG="$ROOT/config/project.yml"
INDEX_MD="$ROOT/docs/index.md"

# Header
printf "# Aiman Prompt – Agent: %s – Task: %s\n\n" "$agent" "$task"

# Agent-specific note
if [[ -f "$ROOT/prompts/agents/$agent/README.md" ]]; then
  echo "<!-- Agent Instructions Start -->"
  sed -n '1,200p' "$ROOT/prompts/agents/$agent/README.md"
  echo "<!-- Agent Instructions End -->"
  echo
fi

# Guidelines
if [[ -f "$GUIDE" ]]; then
  echo "## Guardrails"
  sed -n '1,9999p' "$GUIDE"
  echo
fi

# Task prompt (canonical)
echo "## Task (zentral)"
sed -n '1,9999p' "$TASK_PROMPT"
echo

# Agent-specific addendum
if [[ -f "$agent_task_path" ]]; then
  echo "## Agent-spezifisches Addendum"
  sed -n '1,9999p' "$agent_task_path"
  echo
fi

# Project config and index (short)
echo "## Project Config (excerpt)"
sed -n '1,200p' "$CONFIG"
echo

echo "## Index (excerpt)"
sed -n '1,200p' "$INDEX_MD"
echo

# Optional context
if [[ -n "$context_csv" ]]; then
  IFS=',' read -r -a ctx <<< "$context_csv"
  echo "## Context Appendix"
  for f in "${ctx[@]}"; do
    p="$f"; [[ -f "$p" ]] || p="$ROOT/$f"
    [[ -f "$p" ]] || { echo "- Skipped missing: $f"; continue; }
    echo
    echo "### $(basename "$p")"
    echo '```markdown'
    sed -n '1,400p' "$p"
    echo '```'
  done
  echo
fi
