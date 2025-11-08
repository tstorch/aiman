#!/bin/sh
# audit.sh -- simple repository health audit
set -eu
ROOT=$(cd "$(dirname "$0")/.."; pwd)
fail=0
missing_updated=$(grep -L '^updated:' -R artifacts 2>/dev/null || true)
if [ -n "$missing_updated" ]; then
  echo "MISSING updated field:"; echo "$missing_updated"; fail=1
fi
./scripts/validate-provenance.sh || fail=1
./scripts/drift.sh || fail=1
if [ $fail -eq 0 ]; then echo "AUDIT PASS"; else echo "AUDIT FAIL"; fi
exit $fail
