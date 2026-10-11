#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
exec "$GODOT_BIN" --path "$SCALFAGUS_ROOT/apps/game" "$@"
