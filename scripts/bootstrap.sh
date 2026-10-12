#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
if [[ "$(uname -s)" != Darwin ]]; then
  echo 'macOS bootstrap only. On Windows/Linux install Godot 4.7.2 Standard, set GODOT_BIN, then run scripts/check.sh.' >&2
  exit 1
fi
# Standard Godot/GDScript development does not require a C++/Rust compiler.
mkdir -p .tools
if [[ ! -x "$SCALFAGUS_ROOT/.tools/Godot.app/Contents/MacOS/Godot" ]]; then
  file='Godot_v4.7.2-stable_macos.universal.zip'
  url="https://github.com/godotengine/godot/releases/download/4.7.2-stable/$file"
  echo 'Downloading official Godot 4.7.2 Standard for macOS (universal) ...'
  curl --fail --location --retry 3 "$url" --output ".tools/$file"
  echo 'c58a24e31d720be9d62f60cb5627c4e695fb72f21b0cfe1bc9ccaa9a3b3ba63e  .tools/Godot_v4.7.2-stable_macos.universal.zip' | shasum -a 256 --check
  (cd .tools && unzip -q -o "$file")
fi
require_godot
# Node is for OFFLINE art/manifest validation, NOT the game runtime.
if ! command -v node >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install node@24
    export PATH="$(brew --prefix node@24)/bin:$PATH"
  else
    echo 'Note: Node 24 optional for asset verification. Install via https://nodejs.org or Homebrew.'
  fi
fi
bash scripts/check.sh
cat <<MESSAGE
Godot ready. Run:
  bash scripts/dev.sh                 # Native Godot one-window game, starts at menu
  bash scripts/dev.sh --editor        # Godot IDE
  bash scripts/build.sh --templates   # Download official export templates (~1.3 GB)
  bash scripts/build.sh macos         # Export for macOS
This does NOT install Rust, Tauri, Vite, WebView or a second launcher.
MESSAGE
