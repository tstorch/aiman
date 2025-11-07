#!/usr/bin/env bash
# shellcheck disable=SC2001

_slugify() {
  printf "%s" "$*" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g;s/^-+|-+$//g'
}

_randstr() {
  LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 3
}

new_id() {
  printf "%s-%s" "$(date +%Y%m%d-%H%M%S)" "$(_randstr)"
}

today() {
  date +%Y-%m-%d
}

slugify() {
  _slugify "$@"
}

# fm_get <file> <key>
fm_get() {
  local file="$1" key="$2"
  awk -v k="$key" '
    BEGIN{ inside=0 }
    /^---[ \t]*$/ {inside = inside ? 0 : 1; next}
    inside && $0 ~ "^[[:space:]]*"k":" {
      sub(/^[[:space:]]*[^:]+:[[:space:]]*/, "", $0)
      gsub(/^\"|\"$/, "", $0)
      print $0; exit
    }
  ' "$file"
}

# replace_between <file> <start_marker> <end_marker> <content>
replace_between() {
  local file="$1" start="$2" end="$3" content="$4"
  local tmp
  tmp=$(mktemp)
  awk -v s="$start" -v e="$end" -v r="$content" '
    BEGIN{inside=0}
    index($0,s){print; print r; inside=1; next}
    index($0,e){inside=0; print; next}
    !inside {print}
  ' "$file" > "$tmp" && mv "$tmp" "$file"
}

# replace_between_file <file> <start_marker> <end_marker> <content_file>
replace_between_file() {
  local file="$1" start="$2" end="$3" content_file="$4"
  local tmp
  tmp=$(mktemp)
  awk -v s="$start" -v e="$end" -v cf="$content_file" '
    BEGIN{inside=0}
    index($0,s){
      print; 
      while ((getline line < cf) > 0) print line;
      close(cf);
      inside=1; next
    }
    index($0,e){inside=0; print; next}
    !inside {print}
  ' "$file" > "$tmp" && mv "$tmp" "$file"
}

# path_relative_to_docs <absolute_or_relative_path_from_repo_root>
path_relative_to_docs() {
  local p="$1"
  echo "$p" | sed -E 's#^docs/##'
}
