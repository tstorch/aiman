#!/bin/sh
# aiman.sh - CLI wrapper for common commands
set -eu
ROOT=$(cd "$(dirname "$0")/.."; pwd)
CMD="${1:-}"; shift || true
usage() {
  cat <<EOF
aiman CLI
Usage: aiman <command> [args]
Commands:
  new        --type <type> --title <title> [--parent ID] [...]
  sync       (run index + status)
  index      (update index/graph)
  status     (update status)
  prompt     --task <name> [--agent A] [--model M]
  prompt-install --src <file> [--name NAME] [--clipboard]
  validate   [--strict] [--json]
  audit      (run audit + drift)
  drift      (check prompt duplicates)
  explorer   (open explorer.html if on macOS)
EOF
}
case "$CMD" in
  new)        "$ROOT/scripts/new.sh" "$@" ;;
  sync)       "$ROOT/scripts/sync.sh" ;;
  index)      "$ROOT/scripts/update-index.sh" ;;
  status)     "$ROOT/scripts/update-status.sh" ;;
  prompt)     "$ROOT/scripts/render-prompt.sh" "$@" ;;
  prompt-install) "$ROOT/scripts/prompt-install.sh" "$@" ;;
  validate)   "$ROOT/scripts/validate-provenance.sh" "$@" ;;
  audit)      "$ROOT/scripts/audit.sh" ;;
  drift)      "$ROOT/scripts/drift.sh" ;;
  explorer)   if [ "$(uname)" = "Darwin" ]; then open "$ROOT/docs/explorer.html"; else echo "Open docs/explorer.html in browser"; fi ;;
  -h|--help|help|"") usage ;;
  *) echo "Unknown command: $CMD"; usage; exit 1;;
esac