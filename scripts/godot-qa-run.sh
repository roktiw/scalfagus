#!/usr/bin/env bash
# Godot can exit zero after a script parse failure. Preserve its output and fail closed.
set -euo pipefail
strict=false
if [[ "${1:-}" == --strict-errors ]]; then strict=true; shift; fi
log="$(mktemp "${TMPDIR:-/tmp}/scalfagus-godot-qa.XXXXXX")"
trap 'rm -f "$log"' EXIT
set +e
"$@" > "$log" 2>&1
status=$?
set -e
cat "$log"
if [[ "$status" -ne 0 ]]; then exit "$status"; fi
if [[ "$strict" == true ]] && grep -Eq '^ERROR:' "$log"; then
  echo 'SCALFAGUS_QA_FAIL: export reported an engine error despite exit 0.' >&2
  exit 1
fi
if grep -Eq 'SCRIPT ERROR:|Assertion failed|Failed to load script|SCALFAGUS_.*FAIL' "$log"; then
  echo 'SCALFAGUS_QA_FAIL: Godot reported a script failure despite exit 0.' >&2
  exit 1
fi
