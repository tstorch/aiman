#!/bin/sh
# generate_id: time-based unique ID per ID policy
set -eu
rand() { LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c 4; }
now() { date -u +%Y%m%d-%H%M%S; }
if [ "${1:-}" = "--help" ]; then echo "Usage: id.sh"; exit 0; fi
printf "%s-%s\n" "$(now)" "$(rand)"