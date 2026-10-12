#!/usr/bin/env bash
# Native Godot Web exports are valid; a separate browser client is not.
set -euo pipefail
cd "$(dirname "$0")/.."
files="$(git ls-files --cached --others --exclude-standard -- apps)"
if printf '%s\n' "$files" | grep -Eq '(^apps/(desktop|studio-web|web|client)/|(^|/)src-tauri/|(^|/)(Cargo\.toml|tauri\.conf\.json|vite\.config\.[^/]+)$|\.(tsx|jsx)$)'; then
  echo 'NATIVE_SOURCE_FAIL: desktop shell or browser client source found.' >&2
  exit 1
fi
echo SCALFAGUS_NATIVE_SOURCE_PASS
