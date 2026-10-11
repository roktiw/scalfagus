#!/usr/bin/env bash
SCALFAGUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="/opt/homebrew/opt/node@24/bin:/opt/homebrew/opt/rustup/bin:$HOME/.cargo/bin:$PATH"
GODOT_BIN="${GODOT_BIN:-$SCALFAGUS_ROOT/.tools/Godot.app/Contents/MacOS/Godot}"
