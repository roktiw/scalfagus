#!/usr/bin/env bash
set -euo pipefail
# Legacy compatibility: does NOT produce Tauri sidecars.
source "$(dirname "$0")/env.sh"
require_godot
exec "$GODOT_BIN" --headless --path "$SCALFAGUS_ROOT/apps/game" --editor --import --quit
