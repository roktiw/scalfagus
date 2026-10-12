#!/usr/bin/env bash
# Idempotent local setup; large export templates are an explicit option.
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
case "${1:-}" in
  ''|--templates) ;;
  *) echo 'Usage: bash scripts/setup-dev.sh [--templates]' >&2; exit 2 ;;
esac
if [[ -z "$GODOT_BIN" ]]; then bash scripts/bootstrap.sh; source scripts/env.sh; fi
require_godot
python3 -m venv .tools/map-venv
.tools/map-venv/bin/python -m pip install -r scripts/requirements-map.txt
bash scripts/install-godot-addons.sh --ensure
bash scripts/prepare-game.sh
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --script res://tests/configure_local_editor.gd
if [[ "${1:-}" == --templates ]]; then bash scripts/build.sh --templates; fi
echo 'Ready: bash scripts/dev-tools.sh editor | game | test | doctor'
