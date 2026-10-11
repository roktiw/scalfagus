#!/usr/bin/env bash
# Fail-closed independent authored-YAML vs compiled-Godot-JSON consistency gate.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
MAP_PYTHON="${MAP_PYTHON:-python3}"
if ! command -v "$MAP_PYTHON" >/dev/null 2>&1; then
  echo "MAP_COMPILER_MISSING: Python 3 required" >&2
  exit 2
fi
if ! "$MAP_PYTHON" -c "import yaml" >/dev/null 2>&1; then
  echo "MAP_COMPILER_MISSING: PyYAML==6.0.3 required; see scripts/requirements-map.txt" >&2
  exit 2
fi
"$MAP_PYTHON" scripts/compile-verdant-map.py --check
