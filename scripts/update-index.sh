#!/bin/sh
# update-index.sh -- build graph/index JSON and docs index
set -eu
DIR=$(dirname "$0")
ROOT=$(cd "$DIR/.."; pwd)
. "$ROOT/scripts/lib/frontmatter.sh"
GRAPH_JSON="$ROOT/docs/_graph/graph.json"
INDEX_JSON="$ROOT/docs/_graph/index.json"
DOC_INDEX="$ROOT/docs/index.md"

nodes_tmp="$ROOT/.nodes.$$"
edges_tmp="$ROOT/.edges.$$"
index_tmp="$ROOT/.index.$$"
rows_tmp="$ROOT/.rows.$$"
: > "$nodes_tmp"; : > "$edges_tmp"; : > "$index_tmp"; : > "$rows_tmp"

scan_dir="$ROOT/artifacts"
[ -d "$scan_dir" ] || scan_dir="$ROOT"

find "$scan_dir" -type f -name '*.md' -not -path '*/_setup/*' -not -path '*/docs/*' -not -path '*/templates/*' -not -path '*/prompts/*' | while read -r f; do
  id=$(fm_get_field "$f" id || true)
  type=$(fm_get_field "$f" type || true)
  title=$(fm_get_field "$f" title || true)
  status=$(fm_get_field "$f" status || true)
  parent=$(fm_get_field "$f" parent || true)
  tags=$(fm_get_field "$f" tags || echo "[]")
  milestone=$(fm_get_field "$f" milestone || true)
  owner=$(fm_get_field "$f" owner || true)
  created=$(fm_get_field "$f" created || true)
  updated=$(fm_get_field "$f" updated || true)
  case "$f" in
    "$ROOT"/*) relpath=${f#"$ROOT/"} ;;
    *) relpath="$f" ;;
  esac
  [ -n "$id" ] || continue
  esc() { printf %s "$1" | sed 's/\\/\\\\/g; s/\"/\\\"/g'; }
  titleq=$(esc "$title"); ownerq=$(esc "$owner"); milestoneq=$(esc "$milestone"); parentq=$(esc "$parent"); createdq=$(esc "$created"); updatedq=$(esc "$updated"); pathq=$(esc "$relpath")
  [ -n "$tags" ] || tags="[]"
  printf '{"id":"%s","type":"%s","title":"%s","status":"%s","path":"%s","parent":"%s","tags":%s,"milestone":"%s","owner":"%s","created":"%s","updated":"%s"}\n' \
    "$id" "$type" "$titleq" "$status" "$pathq" "$parentq" "$tags" "$milestoneq" "$ownerq" "$createdq" "$updatedq" >> "$nodes_tmp"
  printf '%s\t%s\t%s\t%s\t%s\n' "$id" "$type" "$title" "$status" "$relpath" >> "$rows_tmp"
  if [ -n "$parent" ]; then
    printf '{"source":"%s","target":"%s","rel":"parent"}\n' "$parent" "$id" >> "$edges_tmp"
  fi
  # simple index terms
  terms=$(printf "%s %s %s %s %s %s %s" "$id" "$type" "$title" "$status" "$milestone" "$owner" "$relpath")
  printf '{"id":"%s","terms":%s,"fields":{"type":"%s","status":"%s","tags":%s,"milestone":%s,"owner":%s}}\n' \
    "$id" "\"$terms\"" "$type" "$status" "${tags:-[]}" "${milestone:+\"$milestone\"}" "${owner:+\"$owner\"}" >> "$index_tmp"

done

# Assemble JSON arrays
{
  printf '{"nodes":['
  paste -sd, "$nodes_tmp" 2>/dev/null
  printf '],"edges":['
  paste -sd, "$edges_tmp" 2>/dev/null
  printf ']}'
} > "$GRAPH_JSON"

{
  printf '['
  paste -sd, "$index_tmp" 2>/dev/null
  printf ']'
} > "$INDEX_JSON"

# Docs index table
{
  cat <<HDR
---
id: INDEX
type: index
title: Artifact Index
status: draft
updated: $(date -u +%Y-%m-%d)
---

| ID | Type | Title | Status | Path |
|----|------|-------|--------|------|
HDR
  awk 'BEGIN{FS="\t"} {printf "| %s | %s | %s | %s | %s |\n", $1,$2,$3,$4,$5}' "$rows_tmp"
} > "$DOC_INDEX"

rm -f "$nodes_tmp" "$edges_tmp" "$index_tmp" "$rows_tmp"

echo "Updated: $GRAPH_JSON, $INDEX_JSON, $DOC_INDEX"
