#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
"$GODOT_BIN" --version | grep -q '^4\.7\.2\.stable\.'
resources="$SCALFAGUS_ROOT/apps/desktop/src-tauri/resources"
mkdir -p "$resources"
"$GODOT_BIN" --headless --path apps/game --editor --import --quit
"$GODOT_BIN" --headless --path apps/game --export-pack Resources "$resources/game.pck"
cp "$GODOT_BIN" "$resources/Godot"
chmod +x "$resources/Godot"
codesign --force --sign - "$resources/Godot"
curl -fLsS --retry 3 https://raw.githubusercontent.com/godotengine/godot/4.7.2-stable/LICENSE.txt -o "$resources/GODOT-LICENSE.txt"
