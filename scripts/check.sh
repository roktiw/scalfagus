#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
require_godot
"$GODOT_BIN" --headless --path apps/game --editor --import --quit
"$GODOT_BIN" --headless --path apps/game --script res://tests/smoke.gd
"$GODOT_BIN" --headless --path apps/game --script res://tests/menu_smoke.gd
"$GODOT_BIN" --headless --path apps/game --script res://tests/rts_smoke.gd
"$GODOT_BIN" --headless --path apps/game --script res://tests/navigation_smoke.gd
"$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_smoke.gd
"$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_integrity_smoke.gd
"$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_timing_smoke.gd
"$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_navigation_port_smoke.gd
"$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_batch.gd -- --matches 1 --seed 42
"$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_visual_smoke.gd
if command -v node >/dev/null 2>&1; then
  node scripts/verify_atlases.mjs
  node scripts/test-faction-emblems.mjs
else
  echo 'Node not installed: skipping optional offline asset checks.'
fi
printf 'SCALFAGUS_GODOT_CHECK_PASS\n'
