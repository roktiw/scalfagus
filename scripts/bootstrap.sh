#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mode="--check"
if [ "$#" -gt 0 ]; then mode="$1"; fi
case "$mode" in
  --check|--all)
    exec node scripts/doctor.mjs --all
    ;;
  --repo)
    exec node scripts/doctor.mjs --repo
    ;;
  --install)
    printf '%s\n' \
      "Automatic installation is intentionally disabled in S0." \
      "Install verified Node.js 24 LTS, pnpm 12.7.0 and Godot 4.7.2 from official sources." \
      "Run ./scripts/bootstrap.sh --check after installation."
    exit 2
    ;;
  *)
    echo "Usage: ./scripts/bootstrap.sh [--check|--repo|--install]"
    exit 2
    ;;
esac
