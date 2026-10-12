#!/usr/bin/env bash
# Pinned, reproducible native-Godot addon setup. No download at game runtime.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/apps/game/addons"
MODE=--ensure
if (( $# > 0 )); then MODE="$1"; fi
case "$MODE" in
  --ensure|--install|--offline|--check) ;;
  *) echo "Usage: bash scripts/install-godot-addons.sh [--ensure|--install|--offline|--check]" >&2; exit 2 ;;
esac
command -v git >/dev/null || { echo "ERROR: Git is required to install pinned addons." >&2; exit 2; }

STATE_SHA=76d226a3efac66a72aea825382b320c94808f409
GUT_SHA=aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605

fail() { echo "ERROR: $*" >&2; exit 1; }

# The main repository's gitlink is authoritative; reject altered SHA pins.
verify_gitlink() {
  local module="$1" expected="$2" entry actual
  entry="$(git -C "$ROOT" ls-files --stage -- "$module")" || fail "Missing gitlink for $module"
  [[ "$entry" == "160000 $expected"* ]] || fail "Gitlink SHA mismatch for $module"
}

verify_checkout() {
  local module="$1" expected="$2" actual
  [[ -f "$ROOT/$module/.git" || -d "$ROOT/$module/.git" ]] \
    || fail "Submodule $module is not initialized; use --install"
  actual="$(git -C "$ROOT/$module" rev-parse HEAD)" || fail "Cannot inspect $module"
  [[ "$actual" == "$expected" ]] || fail "$module checkout $actual does not match pinned $expected"
}

# Check complete file inventory, not just plugin.cfg / a revision marker.
matches() {
  local module="$1" addon="$2" expected="$3"
  local source="$ROOT/$module/addons/$addon" target="$DEST/$addon"
  [[ -f "$target/.scalfagus-pinned-revision" ]] || return 1
  [[ "$(< "$target/.scalfagus-pinned-revision")" == "$expected" ]] || return 1
  [[ -f "$target/plugin.cfg" ]] || return 1
  if [[ -d "$source" && -f "$source/plugin.cfg" ]]; then
    while IFS= read -r -d '' file; do
      # Godot rewrites import metadata for the host renderer/platform.
      # Source assets and scripts remain byte-checked against the pinned checkout.
      [[ "$file" == *.import ]] && continue
      cmp -s "$source/$file" "$target/$file" || return 1
    done < <(cd "$source" && find . -type f -print0)
  fi
  return 0
}

copy_addon() {
  local module="$1" addon="$2" expected="$3"
  local source="$ROOT/$module/addons/$addon" target="$DEST/$addon"
  [[ -d "$source" && -f "$source/plugin.cfg" ]] || fail "Missing source $source"
  if matches "$module" "$addon" "$expected"; then
    echo "ADDON_OK $addon $expected"
    return
  fi
  [[ ! -e "$target" || -f "$target/.scalfagus-pinned-revision" ]] \
    || fail "Refusing to overwrite unmanaged directory $target"
  local staged="$DEST/.$addon.staged.$$" old="$DEST/.$addon.previous.$$"
  trap 'rm -rf "$staged"' RETURN
  cp -R "$source" "$staged"
  printf '%s\n' "$expected" > "$staged/.scalfagus-pinned-revision"
  if [[ -d "$target" ]]; then
    mv "$target" "$old"
    mv "$staged" "$target"
    rm -rf "$old"
  else
    mv "$staged" "$target"
  fi
  trap - RETURN
  matches "$module" "$addon" "$expected" || fail "Incomplete installation of $addon"
  echo "ADDON_INSTALLED $addon $expected"
}

verify_bundled() {
  [[ -f "$DEST/keychain/plugin.cfg" && -f "$DEST/keychain/LICENSE" ]] \
    || fail "Bundled Keychain with license is missing"
  [[ -f "$DEST/rts_framework/plugin.cfg" && -f "$DEST/rts_framework/LICENSE" ]] \
    || fail "Bundled RTS Framework with license is missing"
}

verify_gitlink third_party/godot-statecharts "$STATE_SHA"
verify_gitlink third_party/gut "$GUT_SHA"
mkdir -p "$DEST"
verify_bundled

if [[ "$MODE" == --check ]]; then
  if [[ -f "$ROOT/third_party/godot-statecharts/.git" || -d "$ROOT/third_party/godot-statecharts/.git" ]]; then
    verify_checkout third_party/godot-statecharts "$STATE_SHA"
  fi
  if [[ -f "$ROOT/third_party/gut/.git" || -d "$ROOT/third_party/gut/.git" ]]; then
    verify_checkout third_party/gut "$GUT_SHA"
  fi
  matches third_party/godot-statecharts godot_state_charts "$STATE_SHA" \
    || fail "State Charts absent/incomplete; run bash scripts/install-godot-addons.sh --install"
  matches third_party/gut gut "$GUT_SHA" \
    || fail "GUT absent/incomplete; run bash scripts/install-godot-addons.sh --install"
  echo "SCALFAGUS_ADDONS_CHECK_PASS (no network)"
  exit 0
fi

if [[ "$MODE" == --install || "$MODE" == --ensure ]]; then
  # Fast path: existing complete copies do not need network on each launch.
  if [[ "$MODE" == --install ]] \
    || ! matches third_party/godot-statecharts godot_state_charts "$STATE_SHA" \
    || ! matches third_party/gut gut "$GUT_SHA"; then
    git -C "$ROOT" submodule update --init -- \
      third_party/godot-statecharts third_party/gut \
      || fail "Git submodule download failed. Retry online or use --offline after initial checkout."
  fi
fi

# Offline mode requires previously downloaded, exactly pinned upstream sources.
if [[ -d "$ROOT/third_party/godot-statecharts/.git" || -f "$ROOT/third_party/godot-statecharts/.git" ]]; then
  verify_checkout third_party/godot-statecharts "$STATE_SHA"
fi
if [[ -d "$ROOT/third_party/gut/.git" || -f "$ROOT/third_party/gut/.git" ]]; then
  verify_checkout third_party/gut "$GUT_SHA"
fi

if ! matches third_party/godot-statecharts godot_state_charts "$STATE_SHA"; then
  verify_checkout third_party/godot-statecharts "$STATE_SHA"
  [[ -f "$ROOT/third_party/godot-statecharts/addons/godot_state_charts/LICENSE" ]] \
    || fail "State Charts MIT notice is missing"
  copy_addon third_party/godot-statecharts godot_state_charts "$STATE_SHA"
fi
if ! matches third_party/gut gut "$GUT_SHA"; then
  verify_checkout third_party/gut "$GUT_SHA"
  [[ -f "$ROOT/third_party/gut/addons/gut/LICENSE.md" ]] \
    || fail "GUT MIT notice is missing"
  copy_addon third_party/gut gut "$GUT_SHA"
fi

bash "$ROOT/scripts/install-godot-addons.sh" --check
echo "SCALFAGUS_ADDON_SETUP_OK"
