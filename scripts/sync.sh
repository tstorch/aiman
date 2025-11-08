#!/bin/sh
# sync.sh -- run index + status
set -eu
DIR=$(dirname "$0")
ROOT=$(cd "$DIR/.."; pwd)
"$ROOT/scripts/update-index.sh"
"$ROOT/scripts/update-status.sh"
