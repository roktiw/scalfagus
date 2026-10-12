#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if bash scripts/godot-qa-run.sh bash -c 'echo "SCRIPT ERROR: Parse Error"; exit 0'; then
  echo 'FAIL: zero-exit parse error was accepted' >&2
  exit 1
fi
bash scripts/godot-qa-run.sh bash -c 'echo SCALFAGUS_FIXTURE_PASS; exit 0'
if bash scripts/godot-qa-run.sh bash -c 'exit 7'; then
  echo 'FAIL: nonzero process exit was accepted' >&2
  exit 1
fi
echo SCALFAGUS_QA_RUNNER_REGRESSION_PASS
