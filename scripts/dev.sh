#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
require_godot
if [[ "${1:-}" == "--editor" ]]; then
  exec "$GODOT_BIN" --path "$SCALFAGUS_ROOT/apps/game" --editor
fi
exec "$GODOT_BIN" --path "$SCALFAGUS_ROOT/apps/game" "$@"
