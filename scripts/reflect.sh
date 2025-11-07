#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
. "$DIR/lib.sh"

usage() {
  cat <<EOF
Usage: $0 <path-or-id>
Erzeugt eine ACE-Reflexion für ein bestehendes Artefakt.
EOF
}

[[ ${1:-} == "-h" || ${1:-} == "--help" || $# -lt 1 ]] && { usage; exit 1; }

target="$1"

if [[ -f "$target" ]]; then
  target_path="$target"
else
  # Find by ID
  target_path=$(grep -Rsl "^id:[[:space:]]*$target\b" "$ROOT/docs" || true)
  [[ -z "$target_path" ]] && { echo "Artefakt mit ID nicht gefunden: $target" >&2; exit 2; }
fi

TARGET_ID="$(fm_get "$target_path" id)"
TARGET_TITLE="$(fm_get "$target_path" title)"

# Create reflection
"$DIR/new-entity.sh" reflection "$TARGET_TITLE" --target-id "$TARGET_ID" --parent "$TARGET_ID" --status draft >/dev/null

echo "Reflexion erstellt für: ${TARGET_ID} - ${TARGET_TITLE}"
