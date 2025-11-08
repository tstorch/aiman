#!/bin/sh
# validate-provenance.sh [--json] [--strict] [--paths ...]
set -eu
ROOT=$(cd "$(dirname "$0")/.."; pwd)
. "$ROOT/scripts/lib/frontmatter.sh"
JSON=0; STRICT=0; PATHS=
while [ $# -gt 0 ]; do
  case "$1" in
    --json) JSON=1; shift;;
    --strict) STRICT=1; shift;;
    --paths) shift; while [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; do PATHS="$PATHS $1"; shift; done;;
    --help) echo "Usage: validate-provenance.sh [--json] [--strict] [--paths <dir|file> ...]"; exit 0;;
    *) PATHS="$PATHS $1"; shift;;
  esac
done
[ -n "$PATHS" ] || PATHS="artifacts prompts/rendered"
fail=0
errs_tmp=".prov_errs.$$"; :>"$errs_tmp"
warns_tmp=".prov_warns.$$"; :>"$warns_tmp"
scan() {
  for p in $PATHS; do
    [ -e "$p" ] || continue
    find "$p" -type f -name '*.md' | while read -r f; do
      # required frontmatter fields
      req=0
      for k in id type title status; do
        if ! fm_has_field "$f" "$k" >/dev/null 2>&1; then
          echo "$f::missing $k" >> "$errs_tmp"; req=1; fi
      done
      [ $req -eq 1 ] && fail=1
      type=$(fm_get_field "$f" type || true)
      # created must not be empty (strict)
      created=$(fm_get_field "$f" created || true)
      if [ "$STRICT" -eq 1 ] && [ -z "${created:-}" ]; then
        echo "$f::missing created" >> "$errs_tmp"; fail=1
      fi
      # rendered prompts or any with generated_with.tool must have prompt_hash
      if grep -q '^type: rendered-prompt' "$f" 2>/dev/null || grep -q '^generated_with:' "$f" 2>/dev/null; then
        if ! grep -q '^generated_with:' "$f" || ! grep -q 'prompt_hash:' "$f"; then
          echo "$f::missing prompt_hash" >> "$errs_tmp"; fail=1
        fi
      fi
      # source integrity (strict)
      if [ "$type" = "source" ]; then
        if ! fm_has_field "$f" content_hash >/dev/null 2>&1; then
          echo "$f::missing content_hash" >> "$errs_tmp"; fail=1
        fi
      fi
      # citations required for summary/reflection/adr (strict)
      if [ "$STRICT" -eq 1 ]; then
        case "$type" in
          summary|reflection|adr)
            if ! grep -q '^citations:' "$f"; then
              echo "$f::missing citations block" >> "$errs_tmp"; fail=1
            else
              # check minimal keys in first item
              block=$(awk '/^citations:/{f=1;next} f==1 && /^\S/{exit} f==1{print}' "$f")
              echo "$block" | grep -q '\bid:' || { echo "$f::citations missing id" >> "$errs_tmp"; fail=1; }
              echo "$block" | grep -q '\blocator:' || { echo "$f::citations missing locator" >> "$errs_tmp"; fail=1; }
              echo "$block" | grep -q '\bquote:' || { echo "$f::citations missing quote" >> "$errs_tmp"; fail=1; }
              echo "$block" | grep -q '\bquote_hash:' || { echo "$f::citations missing quote_hash" >> "$errs_tmp"; fail=1; }
            fi
          ;;
        esac
      fi
    done
  done
}
scan
if [ $JSON -eq 1 ]; then
  # count errors
  fc=$(wc -l < "$errs_tmp" | tr -d ' ')
  printf '{"valid": %s, "fail_count": %s, "errors": [' "$([ $fail -eq 0 ] && echo true || echo false)" "$fc"
  first=1
  while IFS= read -r e; do
    [ $first -eq 1 ] || printf ','
    printf ' {"message": %s }' "\"$e\""
    first=0
  done < "$errs_tmp"
  printf ']}'
  echo
else
  if [ $fail -eq 0 ]; then echo "PASS"; else echo "FAIL"; fi
  cat "$errs_tmp"
fi
rm -f "$errs_tmp"
exit $fail
