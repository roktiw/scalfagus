#!/usr/bin/env bash
set -euo pipefail
# Import native resources and validate script loading before opening the editor.
source "$(dirname "$0")/env.sh"
require_godot
exec bash "$SCALFAGUS_ROOT/scripts/godot-qa-run.sh" "$GODOT_BIN" --headless --path "$SCALFAGUS_ROOT/apps/game" --editor --import --quit
