#!/bin/sh
# new.sh -- create artifact from template
set -eu
DIR=$(dirname "$0")
ROOT=$(cd "$DIR/.."; pwd)
. "$ROOT/scripts/lib/id.sh"
. "$ROOT/scripts/lib/frontmatter.sh"
TYPE=""; TITLE=""; PARENT=""; TAGS=""; MILESTONE=""; CONTEXT=""; FROM=""; URL="";
while [ $# -gt 0 ]; do
  case "$1" in
    --type) TYPE="$2"; shift 2;;
    --title) TITLE="$2"; shift 2;;
    --parent) PARENT="$2"; shift 2;;
    --tags) TAGS="$2"; shift 2;;
    --milestone) MILESTONE="$2"; shift 2;;
    --context) CONTEXT="$2"; shift 2;;
    --from) FROM="$2"; shift 2;;
    --url) URL="$2"; shift 2;;
    --help) echo "Usage: new.sh --type <type> --title <title> [--parent ID] [--tags t1,t2]"; exit 0;;
    *) echo "Unknown arg $1"; exit 1;;
  esac
done
[ -n "$TYPE" ] || { echo "--type required"; exit 1; }
[ -n "$TITLE" ] || { echo "--title required"; exit 1; }
ID=$("$ROOT/scripts/lib/id.sh")
OUT="artifacts/${TYPE}/${ID}.md"
mkdir -p "artifacts/${TYPE}"
TEMPLATE="templates/${TYPE}.md"
if [ -f "$TEMPLATE" ]; then cp "$TEMPLATE" "$OUT"; else echo "---\nid: $ID\ntype: $TYPE\ntitle: $TITLE\nstatus: draft\ncreated: $(date -u +%Y-%m-%d)\nupdated: $(date -u +%Y-%m-%d)\n---\n\n" > "$OUT"; fi
# replace placeholders
sed -i '' "s/<ID>/$ID/" "$OUT" 2>/dev/null || sed -i "" "s/<ID>/$ID/" "$OUT" 2>/dev/null || true
sed -i '' "s/<TITLE>/$TITLE/" "$OUT" 2>/dev/null || sed -i "" "s/<TITLE>/$TITLE/" "$OUT" 2>/dev/null || true
[ -n "$PARENT" ] && fm_set_field "$OUT" parent "$PARENT"
[ -n "$TAGS" ] && fm_set_field "$OUT" tags "[${TAGS//,/ , }]"
[ -n "$MILESTONE" ] && fm_set_field "$OUT" milestone "$MILESTONE"
[ -n "$CONTEXT" ] && fm_set_field "$OUT" context_sources "[${CONTEXT//,/ , }]"
[ -n "$FROM" ] && fm_set_field "$OUT" derived_from "[${FROM//,/ , }]"
[ -n "$URL" ] && fm_set_field "$OUT" url "$URL"
prov_inject "$OUT" "new.sh" "new --type $TYPE"
echo "$OUT"