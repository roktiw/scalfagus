#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
action="${1:-help}"
if [[ "$#" -gt 0 ]]; then shift; fi
case "$action" in
  setup) exec bash scripts/setup-dev.sh "$@" ;;
  doctor) exec bash scripts/doctor.sh "$@" ;;
  editor) exec bash scripts/dev.sh --editor "$@" ;;
  game) exec bash scripts/dev.sh "$@" ;;
  test) exec bash scripts/qa-local.sh "$@" ;;
  gut) exec bash scripts/check-gut.sh "$@" ;;
  import) exec bash scripts/prepare-game.sh "$@" ;;
  export) exec bash scripts/build.sh "$@" ;;
  *) echo 'Usage: bash scripts/dev-tools.sh {setup [--templates]|doctor|editor|game|test|gut|import|export TARGET}'; exit 2 ;;
esac
