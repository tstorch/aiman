#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
. "$DIR/lib.sh"

GRAPH="$ROOT/docs/_graph/graph.tsv"
STATUS_MD="$ROOT/docs/status.md"

# Compute counts per type and status
summary_file=$(mktemp)
awk -F"\t" 'NR>1{c[$2]++; s[$2"/"$4]++} END {
  print "### Übersicht (Counts)\n";
  print "| Typ | Anzahl |"; print "|---|---|";
  for (t in c) printf "| %s | %d |\n", t, c[t];
  print "\n### Nach Status je Typ\n";
  print "| Typ/Status | Anzahl |"; print "|---|---|";
  for (k in s) printf "| %s | %d |\n", k, s[k];
}' "$GRAPH" > "$summary_file"

replace_between_file "$STATUS_MD" "<!-- AUTO-GENERATED: STATUS SUMMARY START -->" "<!-- AUTO-GENERATED: STATUS SUMMARY END -->" "$summary_file"
replace_between_file "$STATUS_MD" "<!-- AUTO-GENERATED: STATUS DETAILS START -->" "<!-- AUTO-GENERATED: STATUS DETAILS END -->" "$summary_file"

echo "Status aktualisiert: ${STATUS_MD#"$ROOT/"}"
