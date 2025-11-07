#!/usr/bin/env bash
set -euo pipefail

# Install a composed prompt by writing it to an agent-specific export file
# and copying it to clipboard on macOS (pbcopy) for quick paste.
# Usage:
#   install-prompt.sh --agent <copilot|claude|openai|goose> --task <task> [--context file1,file2,...]

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/../../.." && pwd)"
RENDER="$DIR/render-prompt.sh"

agent=""; task=""; context_csv=""
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

export_dir="$ROOT/prompts/agents/$agent/exports"
mkdir -p "$export_dir"

outfile="$export_dir/${task}.md"
bash "$RENDER" --agent "$agent" --task "$task" ${context_csv:+--context "$context_csv"} > "$outfile"

echo "Prompt exportiert nach: ${outfile#"$ROOT/"}"

# Copy to clipboard on macOS if available
if command -v pbcopy >/dev/null 2>&1; then
  cat "$outfile" | pbcopy
  echo "Prompt in Zwischenablage kopiert (pbcopy)."
fi
