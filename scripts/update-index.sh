#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
. "$DIR/lib.sh"

GRAPH="$ROOT/docs/_graph/graph.tsv"
INDEX_MD="$ROOT/docs/index.md"

echo -e "id\ttype\ttitle\tstatus\tpath\tparent\tchildren\ttags\tupdated" > "$GRAPH"

# Collect
while IFS= read -r -d '' f; do
  # Skip templates/prompts/this index/status
  rel="${f#"$ROOT/"}"
  case "$rel" in 
    templates/*|prompts/*|README.md|CHANGELOG.md|docs/status.md|docs/index.md) continue;;
  esac
  type="$(fm_get "$f" type || true)"; [ -z "$type" ] && continue
  id="$(fm_get "$f" id || true)"; [ -z "$id" ] && id="-"
  title="$(fm_get "$f" title || true)"; [ -z "$title" ] && title="-"
  status="$(fm_get "$f" status || true)"; [ -z "$status" ] && status="-"
  parent="$(fm_get "$f" parent || true)"
  tags="$(fm_get "$f" tags || true)"; tags="$(echo "$tags" | tr -d '[]' | tr -d '"' | tr -d "'" | sed 's/,/,/g')"
  updated="$(fm_get "$f" updated || true)"; [ -z "$updated" ] && updated="$(date -r "$f" +%Y-%m-%d 2>/dev/null || today)"
  path="$rel"
  printf "%s\t%s\t%s\t%s\t%s\t%s\t\t%s\t%s\n" "$id" "$type" "$title" "$status" "$path" "$parent" "$tags" "$updated" >> "$GRAPH"
done < <(find "$ROOT/docs" -type f -name "*.md" -print0)

# Build tables from GRAPH
build_table() {
  local type="$1"
  awk -F"\t" -v t="$type" 'BEGIN{print "| ID | Title | Status | Updated |"; print "|---|---|---|---|"} NR>1 && $2==t{printf "| %s | %s | %s | %s |\n", $1, $3, $4, $9}' "$GRAPH"
}

# Linkify paths relative to docs/
linkify_table() {
  local type="$1"
  awk -F"\t" -v t="$type" 'NR>1 && $2==t{printf "| [%s](%s) | %s | %s | %s |\n", $1, gensub(/^docs\//, "", 1, $5), $3, $4, $9}' "$GRAPH" |
  awk 'BEGIN{print "| ID | Title | Status | Updated |"; print "|---|---|---|---|"}1'
}

epics_tbl_file=$(mktemp); linkify_table epic > "$epics_tbl_file"
sources_tbl_file=$(mktemp); linkify_table source > "$sources_tbl_file"
summaries_tbl_file=$(mktemp); linkify_table summary > "$summaries_tbl_file"
features_tbl_file=$(mktemp); linkify_table feature > "$features_tbl_file"
stories_tbl_file=$(mktemp); linkify_table story > "$stories_tbl_file"
tasks_tbl_file=$(mktemp); linkify_table task > "$tasks_tbl_file"
ads_tbl_file=$(mktemp); linkify_table adr > "$ads_tbl_file"
refl_tbl_file=$(mktemp); linkify_table reflection > "$refl_tbl_file"
reviews_tbl_file=$(mktemp); linkify_table review > "$reviews_tbl_file"

replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: EPICS TABLE START -->" "<!-- AUTO-GENERATED: EPICS TABLE END -->" "$epics_tbl_file"
replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: FEATURES TABLE START -->" "<!-- AUTO-GENERATED: FEATURES TABLE END -->" "$features_tbl_file"
replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: STORIES TABLE START -->" "<!-- AUTO-GENERATED: STORIES TABLE END -->" "$stories_tbl_file"
replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: TASKS TABLE START -->" "<!-- AUTO-GENERATED: TASKS TABLE END -->" "$tasks_tbl_file"
replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: ADR TABLE START -->" "<!-- AUTO-GENERATED: ADR TABLE END -->" "$ads_tbl_file"
replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: REFLECTIONS TABLE START -->" "<!-- AUTO-GENERATED: REFLECTIONS TABLE END -->" "$refl_tbl_file"
replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: REVIEWS TABLE START -->" "<!-- AUTO-GENERATED: REVIEWS TABLE END -->" "$reviews_tbl_file"
replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: SOURCES TABLE START -->" "<!-- AUTO-GENERATED: SOURCES TABLE END -->" "$sources_tbl_file"
replace_between_file "$INDEX_MD" "<!-- AUTO-GENERATED: SUMMARIES TABLE START -->" "<!-- AUTO-GENERATED: SUMMARIES TABLE END -->" "$summaries_tbl_file"

echo "Index aktualisiert: ${INDEX_MD#"$ROOT/"} und ${GRAPH#"$ROOT/"}"
