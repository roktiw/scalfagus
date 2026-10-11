#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
require_godot
bash "$SCALFAGUS_ROOT/scripts/install-godot-addons.sh" --check
if [[ "${1:-}" == "--editor" ]]; then
  exec "$GODOT_BIN" --path "$SCALFAGUS_ROOT/apps/game" --editor
fi
exec "$GODOT_BIN" --path "$SCALFAGUS_ROOT/apps/game" "$@"
