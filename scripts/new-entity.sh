#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

usage() {
  cat <<EOF
Usage: $0 <type> "<title>" [--parent ID] [--milestone M] [--tags a,b] [--owner NAME] [--status STATUS]
Types: epic, feature, story, task, adr, vision, specification, architecture, review, reflection
EOF
}

[[ ${1:-} == "-h" || ${1:-} == "--help" || $# -lt 2 ]] && { usage; exit 1; }

type="$1"; shift
raw_title="$1"; shift
parent=""; milestone="${MILESTONE:-M1}"; tags=""; owner=""; status="${STATUS:-draft}"; target_id=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --parent) parent="${2:-}"; shift 2;;
    --milestone) milestone="${2:-}"; shift 2;;
    --tags) tags="${2:-}"; shift 2;;
    --owner) owner="${2:-}"; shift 2;;
    --status) status="${2:-}"; shift 2;;
    --target-id) target_id="${2:-}"; shift 2;; # for reflection
    *) echo "Unknown arg: $1" >&2; usage; exit 1;;
  esac
done

case "$type" in
  epic) dest="docs/work/epics"; template="templates/epic.md";;
  feature) dest="docs/work/features"; template="templates/feature.md";;
  story) dest="docs/work/stories"; template="templates/story.md";;
  task) dest="docs/work/tasks"; template="templates/task.md";;
  adr) dest="docs/architecture/adr"; template="templates/adr.md";;
  architecture) dest="docs/architecture"; template="templates/architecture.md";;
  vision) dest="docs/product"; template="templates/vision.md";;
  specification) dest="docs/product"; template="templates/specification.md";;
  source) dest="docs/sources"; template="templates/source.md";;
  summary) dest="docs/knowledge"; template="templates/summary.md";;
  review) dest="docs"; template="templates/review.md";;
  reflection) dest="docs/reflections"; template="templates/reflection_ACE.md";;
  *) echo "Unknown type: $type" >&2; exit 2;;
esac

id="$(new_id)"
slug="$(slugify "$raw_title")"
filename="$id-$slug.md"
[ "$type" = "adr" ] && filename="$id-$slug.md"
filepath="$ROOT/$dest/$filename"

DATE="$(today)"
TAGS="$(echo "$tags" | sed 's/,/, /g')"
OWNER="$owner"
MILESTONE="$milestone"
PARENT="$parent"
TITLE="$raw_title"
TARGET_ID="$target_id"
TARGET_TITLE="$raw_title"
URL="${URL:-}"

mkdir -p "$ROOT/$dest"

# Render template
content="$(
  sed \
    -e "s/{{ID}}/$id/g" \
    -e "s/{{TITLE}}/$TITLE/g" \
    -e "s/{{DATE}}/$DATE/g" \
    -e "s/{{OWNER}}/$OWNER/g" \
    -e "s/{{PARENT}}/$PARENT/g" \
    -e "s/{{MILESTONE}}/$MILESTONE/g" \
    -e "s/{{TAGS}}/$TAGS/g" \
    -e "s/{{TARGET_ID}}/$TARGET_ID/g" \
    -e "s/{{TARGET_TITLE}}/$TARGET_TITLE/g" \
  -e "s|{{URL}}|$URL|g" \
    "$ROOT/$template"
)"

# Adjust type if reflection/review templates carry different 'type' default
content="$(echo "$content" | sed -E "s/^type:[ ]+.*/type: $type/")"
content="$(echo "$content" | sed -E "s/^status:[ ]+.*/status: $status/")"

printf "%s\n" "$content" > "$filepath"
echo "Created: ${filepath#"$ROOT/"}"
