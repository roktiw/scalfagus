#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
require_godot
bash scripts/install-godot-addons.sh --ensure
# Optional source-level parity: PyYAML is needed only for OFFLINE authoring,
# never to launch or export the Godot game.
if command -v python3 >/dev/null 2>&1; then
  python3 scripts/check-map-source.py
  if python3 -c 'import yaml' >/dev/null 2>&1; then
    python3 scripts/compile-verdant-map.py --check
  else
    echo 'MAP_COMPILE_CHECK_SKIPPED: install PyYAML==6.0.3 for exact raster compiler parity (bash scripts/check-map.sh).'
  fi
else
  echo 'MAP_SOURCE_CHECK_SKIPPED: Python3 not found; run scripts/check-map-source.py with Python3.'
fi
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --editor --import --quit
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/addons_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/menu_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/keychain_rts_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/rts_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/navigation_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_integrity_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_human_replay_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_replay_lifecycle_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_timing_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_navigation_port_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_footprint_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_authored_map_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_batch.gd -- --matches 1 --seed 42
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_visual_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_physics_los_smoke.gd
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/mirror_group_orders_smoke.gd
if command -v node >/dev/null 2>&1; then
  node scripts/verify_atlases.mjs
  node scripts/test-faction-emblems.mjs
else
  echo 'Node not installed: skipping optional offline asset checks.'
fi
printf 'SCALFAGUS_GODOT_CHECK_PASS\n'
