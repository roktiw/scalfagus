#!/usr/bin/env bash
# Optional local MIT GUT test suite. No GitHub Actions runner required.
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
require_godot
bash scripts/install-godot-addons.sh --ensure
"$GODOT_BIN" --headless --path apps/game --editor --import --quit

log="$(mktemp "${TMPDIR:-/tmp}/scalfagus-gut.XXXXXX")"
trap 'rm -f "$log"' EXIT
set +e
"$GODOT_BIN" --headless --path apps/game \
  --script res://addons/gut/gut_cmdln.gd \
  -gdir=res://tests/gut -gexit -glog=1 2>&1 | tee "$log"
status=${PIPESTATUS[0]}
set -e
if [[ "$status" -ne 0 ]]; then
  echo "SCALFAGUS_GUT_FAIL: Godot/GUT returned exit status $status" >&2
  exit "$status"
fi
# Guard against a 0 exit code when GUT aborted during import or discovery.
if ! grep -Fq 'All tests passed!' "$log"; then
  echo "SCALFAGUS_GUT_FAIL: no successful GUT Run Summary found; inspect output." >&2
  exit 1
fi
echo 'SCALFAGUS_GUT_CHECK_PASS'
