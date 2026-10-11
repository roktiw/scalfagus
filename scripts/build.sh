#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
bash scripts/prepare-game.sh
npm --prefix apps/desktop run tauri -- build --bundles app
mkdir -p build
ditto apps/desktop/src-tauri/target/release/bundle/macos/Scalfagus.app build/Scalfagus.app

codesign --force --deep --sign - build/Scalfagus.app
codesign --verify --deep --strict build/Scalfagus.app
