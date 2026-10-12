#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
require_godot
version='4.7.2.stable'
target="${1:-macos}"
if [[ "$target" == '--templates' ]]; then
  archive='.tools/Godot_v4.7.2-stable_export_templates.tpz'
  mkdir -p .tools
  if [[ ! -f "$archive" ]]; then
    echo 'Downloading official export templates (~1.28 GB). This can take some time.'
    curl --fail --location --retry 3 'https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_export_templates.tpz' --output "$archive"
  fi
  echo 'f298490b8d44d934be425a5a65a51bf15f422428b229a06a6e11d9ffea248011  .tools/Godot_v4.7.2-stable_export_templates.tpz' | shasum -a 256 --check
  dest="$HOME/Library/Application Support/Godot/export_templates/$version"
  if [[ "$(uname -s)" != Darwin ]]; then
    dest="${XDG_DATA_HOME:-$HOME/.local/share}/godot/export_templates/$version"
  fi
  mkdir -p "$dest"
  unzip -q -o -j "$archive" 'templates/*' -d "$dest"
  echo "Templates installed at $dest"
  exit 0
fi
case "$target" in
  macos) preset='macOS'; filename='build/Scalfagus.zip' ;;
  windows) preset='Windows Desktop'; filename='build/Scalfagus.exe' ;;
  linux) preset='Linux'; filename='build/Scalfagus.x86_64' ;;
  web) preset='Web'; filename='build/web/index.html' ;;
  *) echo 'Usage: bash scripts/build.sh [macos|windows|linux|web|--templates]' >&2; exit 2 ;;
esac
mkdir -p "$(dirname "$filename")"
bash scripts/godot-qa-run.sh "$GODOT_BIN" --headless --path apps/game --editor --import --quit
bash scripts/godot-qa-run.sh --strict-errors "$GODOT_BIN" --headless --path apps/game --export-release "$preset" "$SCALFAGUS_ROOT/$filename"
echo "Exported $filename. Target-platform runtime testing still required."
