#!/bin/sh
# frontmatter helpers (BSD/POSIX awk/sed)
set -eu

# Extract YAML frontmatter body (between first and second ---)
fm_extract() { awk 'BEGIN{infm=0} /^---/{c++; if(c==2){exit} else {infm=1; next}} infm==1 {print}' "$1"; }

fm_has_field() { fm_extract "$1" | awk -v k="$2" -F': *' '$1==k {print; exit}'; }

fm_get_field() { # $1=file $2=key
  fm_extract "$1" | awk -v k="$2" -F': *' '($1==k){v=$2; sub(/^ +/,"",v); if(v ~ /^".*"$/){v=substr(v,2,length(v)-2)}; print v; exit}'
}

# Upsert a top-level scalar key inside frontmatter (before second ---)
fm_set_field() {
  file="$1"; key="$2"; val="$3"; tmp="$file.tmp.$$"
  awk -v k="$key" -v v="$val" 'BEGIN{c=0; done=0}
    {
      if($0=="---"){ c++; if(c==2 && !done){ print k ": " v; done=1 }
      }
      if(c==1 && index($0, k ": ")==1){ if(!done){ print k ": " v; done=1 }; next }
      print
    }
    END{ if(c<2){ print "---"; if(!done){ print k ": " v }; print "---" } }
  ' "$file" > "$tmp" && mv "$tmp" "$file"
}

# Append a multi-line block before closing --- of first frontmatter
fm_append_block() {
  file="$1"; block="$2"; tmp="$file.tmp.$$"
  awk -v b="$block" 'BEGIN{c=0}
    {
      if($0=="---"){ c++; if(c==2){ print b }}
      print
    }' "$file" > "$tmp" && mv "$tmp" "$file"
}

# provenance injection (minimal but safe for top-level blocks)
prov_inject() {
  file="$1"; tool="$2"; cmd="$3"; agent="${AIMAN_AGENT:-manual}"; model="${AIMAN_MODEL:-}"
  fm_set_field "$file" "updated" "$(date -u +%Y-%m-%d)"
  if ! fm_has_field "$file" "created_by" >/dev/null 2>&1; then
    fm_append_block "$file" "created_by:\n  agent: $agent\n  model: $model\n  version: "
  fi
  if ! fm_has_field "$file" "generated_with" >/dev/null 2>&1; then
    fm_append_block "$file" "generated_with:\n  tool: $tool\n  command: $cmd\n  prompt_ref: \n  prompt_hash: "
  fi
}
