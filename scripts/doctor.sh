#!/usr/bin/env bash
# Read-only environment inventory. Missing prerequisites produce a nonzero exit.
set -uo pipefail
source "$(dirname "$0")/env.sh"
cd "$SCALFAGUS_ROOT"
failures=0
check() {
  local label="$1"; shift
  if "$@"; then echo "DOCTOR_PASS: $label"; else
    echo "DOCTOR_FAIL: $label"; failures=$((failures + 1))
  fi
}
check godot require_godot
check addons bash scripts/install-godot-addons.sh --check
check native-source bash scripts/check-native-source.sh
check map-python python3 -c 'import yaml; assert yaml.__version__ == "6.0.3"'
check node-assets node --version
template_dir="${XDG_DATA_HOME:-$HOME/.local/share}/godot/export_templates/4.7.2.stable"
if [[ "$(uname -s)" == Darwin ]]; then
  template_dir="$HOME/Library/Application Support/Godot/export_templates/4.7.2.stable"
fi
for file in macos.zip windows_release_x86_64.exe linux_release.x86_64 web_nothreads_release.zip; do
  check "export-template:$file" test -s "$template_dir/$file"
done
echo "Doctor failures: $failures. Repairs: bash scripts/setup-dev.sh"
[[ "$failures" -eq 0 ]]
