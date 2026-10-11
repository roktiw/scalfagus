#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
[[ -f apps/desktop/src-tauri/resources/game.pck ]] || bash scripts/prepare-game.sh
npm --prefix apps/desktop run tauri -- dev
