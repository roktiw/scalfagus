#!/usr/bin/env bash
# Local-only Godot QA orchestrator: durable per-command logs and honest report.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 2
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Run in a Git checkout, not a source archive" >&2; exit 2; }
source scripts/env.sh
BASE="$(git rev-parse HEAD)"
SHORT="$(git rev-parse --short=9 HEAD)"
STAMP="$(date +%Y-%m-%d-%H%M%S)"
RUN="${STAMP}-${SHORT}"
LOGDIR="logs/local-qa/${RUN}"
REPORT="docs/qa/reports/${RUN}.md"
mkdir -p "$LOGDIR" "$(dirname "$REPORT")"
OS="$(uname -srm)"
GODOT_VERSION="unavailable"
if [[ -n "${GODOT_BIN:-}" && -x "${GODOT_BIN:-}" ]]; then GODOT_VERSION="$("$GODOT_BIN" --version 2>&1)"; fi
printf "# Scalfagus — Local QA %s\n\n" "$RUN" > "$REPORT"
printf "> Overall: PENDING (update after manual inspection)\n\n" >> "$REPORT"
printf "## Metadata\n\n- Tested SHA: %s\n- QA branch: %s\n- OS/arch: %s\n- Godot: %s\n- Run: %s\n\n" "$BASE" "$(git branch --show-current)" "$OS" "$GODOT_VERSION" "$RUN" >> "$REPORT"
printf "## Executed commands (actual exit codes)\n\n| Command | Exit | Status | Log |\n|---|---:|---|---|\n" >> "$REPORT"
FAILED=0
run_gate() {
  local label="$1"; shift
  local log="$LOGDIR/$label.log"
  echo "=== SCALFAGUS QA: $label ==="
  "$@" 2>&1 | tee "$log"
  local codes=("${PIPESTATUS[@]}")
  local rc="${codes[0]}"
  if [[ "${codes[1]}" -ne 0 ]]; then rc="${codes[1]}"; fi
  local result="PASS"
  if [[ "$rc" -ne 0 ]]; then result="FAIL"; FAILED=$((FAILED+1)); fi
  printf "| %s | %s | %s | %s |\n" "$*" "$rc" "$result" "$log" >> "$REPORT"
  echo "SCALFAGUS_QA_GATE_${result}: $label (exit=$rc)"
}
run_gate native-source bash scripts/check-native-source.sh
run_gate smoke-coverage bash scripts/check-smoke-coverage.sh
run_gate runner-regression bash scripts/test-godot-qa-run.sh
run_gate addon-inventory bash scripts/install-godot-addons.sh --check
run_gate godot-smoke bash scripts/check.sh
run_gate gut bash scripts/check-gut.sh
run_gate keychain-restart bash scripts/check-keychain-persistence.sh
run_gate map bash scripts/check-map.sh
run_gate five-view node --test architecture/examples/test_five_view_mapping.mjs
printf "\n## Manual GUI, exports, stress and untested scenarios\n\n- Status: NOT_RUN until the agent verifies them.\n- Record Keychain remap/restart, H-C/C-C, LOS 49/148, 3x3, Matter custody, exports, renderer warnings.\n\n" >> "$REPORT"
printf "## Incidents and fixes\n\n- Root cause, reproduce steps, code SHA, before/after logs: TODO\n\n" >> "$REPORT"
printf "## Unresolved / owner decisions\n\n- P0/P1 blockers: TODO\n- 3D physics diagnostics are NOT combat authority.\n\n" >> "$REPORT"
printf "## HANDOFF TO CHATGPT\n\n> Report: %s; baseline SHA %s; gate failures %s. Add final SHA, PR permalink, fixed issues and next ask before pushing.\n" "$REPORT" "$BASE" "$FAILED" >> "$REPORT"
echo "QA report: $REPORT"
echo "QA logs: $LOGDIR"
if [[ "$FAILED" -gt 0 ]]; then exit 1; fi
exit 0

