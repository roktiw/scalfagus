#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
bash "$SCALFAGUS_ROOT/scripts/install-godot-addons.sh" --ensure
require_godot
if [[ "${1:-}" == "--editor" ]]; then
  shift
  exec "$GODOT_BIN" --path "$SCALFAGUS_ROOT/apps/game" --editor "$@"
fi
exec "$GODOT_BIN" --path "$SCALFAGUS_ROOT/apps/game" "$@"
