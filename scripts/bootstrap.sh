#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
[[ $(uname -s) == Darwin ]] || { echo 'This bootstrap currently supports macOS only.'; exit 1; }
command -v brew >/dev/null || { echo 'Install Homebrew from https://brew.sh first.'; exit 1; }
xcode-select -p >/dev/null
brew install rustup node@24
rustup toolchain install 1.99.0 --profile minimal
mkdir -p .tools
version=4.7.2-stable
archive="Godot_v${version}_macos.universal.zip"
base="https://github.com/godotengine/godot-builds/releases/download/$version"
if [[ ! -x "$GODOT_BIN" ]]; then
  curl -fLsS --retry 3 "$base/SHA512-SUMS.txt" -o .tools/SHA512-SUMS.txt
  curl -fL --retry 3 "$base/$archive" -o ".tools/$archive"
  (cd .tools; awk -v name="$archive" '$2 == name { print }' SHA512-SUMS.txt > checksum.txt; test -s checksum.txt; shasum -a 512 -c checksum.txt; unzip -q -o "$archive")
fi
npm --prefix apps/desktop ci
bash scripts/prepare-game.sh
