#!/usr/bin/env bash
# Prevent integrated smoke fixtures from silently disappearing from the suite.
set -euo pipefail
cd "$(dirname "$0")/.."
missing=0
for source in apps/game/tests/*_smoke.gd; do
  test_name="${source##*/}"
  if ! grep -Fq "res://tests/$test_name" scripts/check.sh; then
    echo "SMOKE_COVERAGE_FAIL: $test_name is not in scripts/check.sh" >&2
    missing=1
  fi
done
[[ "$missing" -eq 0 ]]
echo SCALFAGUS_SMOKE_COVERAGE_PASS
