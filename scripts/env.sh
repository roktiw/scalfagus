#!/usr/bin/env bash
# Source this from other scripts. No Rust/Tauri tooling is required.
SCALFAGUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export SCALFAGUS_ROOT
if [[ -x "$SCALFAGUS_ROOT/.tools/map-venv/bin/python" ]]; then
  export MAP_PYTHON="${MAP_PYTHON:-$SCALFAGUS_ROOT/.tools/map-venv/bin/python}"
  export PATH="$SCALFAGUS_ROOT/.tools/map-venv/bin:$PATH"
fi
export PATH="/opt/homebrew/opt/node@24/bin:/usr/local/opt/node@24/bin:$PATH"
if [[ -z "${GODOT_BIN:-}" ]]; then
  if [[ -x "$SCALFAGUS_ROOT/.tools/Godot.app/Contents/MacOS/Godot" ]]; then
    GODOT_BIN="$SCALFAGUS_ROOT/.tools/Godot.app/Contents/MacOS/Godot"
  elif command -v godot >/dev/null 2>&1; then
    GODOT_BIN="$(command -v godot)"
  elif command -v godot4 >/dev/null 2>&1; then
    GODOT_BIN="$(command -v godot4)"
  else
    GODOT_BIN=""
  fi
fi
export GODOT_BIN
require_godot() {
  [[ -n "$GODOT_BIN" && -x "$GODOT_BIN" ]] || { echo 'ERROR: Godot 4.7.2 not found. Run bash bootstrap.sh (macOS), or set GODOT_BIN to an executable.' >&2; return 1; }
  "$GODOT_BIN" --version | grep -q '^4\.7\.2\.stable' || { echo "ERROR: Expected Godot 4.7.2 stable, got $($GODOT_BIN --version)" >&2; return 1; }
}
