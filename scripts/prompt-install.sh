#!/bin/sh
# prompt-install.sh -- copy rendered prompt to installed/ and optional clipboard (macOS)
set -eu
DIR=$(dirname "$0")
ROOT=$(cd "$DIR/.."; pwd)
SRC=""; NAME=""; CLIP=0
while [ $# -gt 0 ]; do
  case "$1" in
    --src) SRC="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    --clipboard) CLIP=1; shift 1;;
    --help) echo "Usage: prompt-install.sh --src path [--name filename] [--clipboard]"; exit 0;;
    *) echo "Unknown arg $1"; exit 1;;
  esac
done
[ -n "$SRC" ] || { echo "--src required"; exit 1; }
[ -f "$SRC" ] || { echo "not found: $SRC"; exit 1; }
base=$(basename "$SRC")
out="$ROOT/prompts/installed/${NAME:-$base}"
cp "$SRC" "$out"
if command -v pbcopy >/dev/null 2>&1 && [ $CLIP -eq 1 ]; then
  sed '1,/^---$/d' "$out" | sed '1,/^---$/d' | pbcopy
  echo "Copied content to macOS clipboard"
fi
echo "Installed: $out"