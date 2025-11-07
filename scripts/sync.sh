#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$DIR/update-index.sh"
bash "$DIR/update-status.sh"

echo "Sync abgeschlossen."
