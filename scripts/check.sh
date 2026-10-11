#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
node --version
rustc --version
"$GODOT_BIN" --headless --path apps/game --editor --import --quit
"$GODOT_BIN" --headless --path apps/game --script res://tests/smoke.gd
npm --prefix apps/desktop run build
