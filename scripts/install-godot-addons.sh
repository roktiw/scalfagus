#!/usr/bin/env bash
# Scalfagus development-only setup. Upstream repos are pinned as git submodules;
# this script copies only the canonical addon subtree, never demo projects.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:---install}"
case "$MODE" in --install|--offline|--check) ;; *)
  echo "Usage: bash scripts/install-godot-addons.sh [--install|--offline|--check]" >&2
  exit 2
esac
command -v git >/dev/null || { echo "ERROR: git is required." >&2; exit 2; }
GODOT_ADDONS="$ROOT/apps/game/addons"
mkdir -p "$GODOT_ADDONS"

fail() { echo "ERROR: $*" >&2; exit 1; }
validate_upstream() {
  local module="$1" expected="$2" source="$3"
  if [[ "$MODE" == "--install" ]]; then
    git -C "$ROOT" submodule update --init -- "$module" || fail "Unable to fetch pinned $module"
  fi
  [[ -f "$ROOT/$module/$source/plugin.cfg" ]] || fail "Missing upstream $module; run bash scripts/install-godot-addons.sh --install"
  local sha
  sha="$(git -C "$ROOT/$module" rev-parse HEAD)" || fail "Unable to inspect $module"
  [[ "$sha" == "$expected" ]] || fail "Unpinned $module: $sha (expected $expected)"
}

copy_addon() {
  local module="$1" addon="$2" expected="$3" source="$ROOT/$module/addons/$addon"
  local dest="$GODOT_ADDONS/$addon" marker="$dest/.scalfagus-pinned-revision"
  [[ -d "$source" && -f "$source/plugin.cfg" ]] || fail "Missing addon subtree $source"
  if [[ -e "$dest" && ! -f "$marker" ]]; then
    fail "Refusing to overwrite unmanaged $dest; inspect it manually."
  fi
  if [[ "$MODE" == "--check" ]]; then
    [[ -f "$marker" ]] || fail "$addon not installed. Run bash scripts/install-godot-addons.sh --install"
    [[ "$(< "$marker")" == "$expected" ]] || fail "$addon locally pinned to wrong revision"
    cmp -s "$source/plugin.cfg" "$dest/plugin.cfg" || fail "$addon local plugin.cfg differs from upstream"
    echo "CHECK: $addon @ $expected"
    return
  fi
  if [[ -f "$marker" ]] && [[ "$(< "$marker")" == "$expected" ]] && cmp -s "$source/plugin.cfg" "$dest/plugin.cfg"; then
    echo "OK: $addon already installed @ $expected"
    return
  fi
  local staged="$GODOT_ADDONS/.${addon}.staged.$$"
  rm -rf "$staged"
  cp -R "$source" "$staged"
  printf '%s\n' "$expected" > "$staged/.scalfagus-pinned-revision"
  if [[ -d "$dest" ]]; then
    local old="$GODOT_ADDONS/.${addon}.previous.$$"
    mv "$dest" "$old"
    mv "$staged" "$dest"
    rm -rf "$old"
  else
    mv "$staged" "$dest"
  fi
  echo "INSTALLED: $addon @ $expected"
}

STATE_REV="76d226a3efac66a72aea825382b320c94808f409"
GUT_REV="aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605"
validate_upstream "third_party/godot-statecharts" "$STATE_REV" "addons/godot_state_charts"
validate_upstream "third_party/gut" "$GUT_REV" "addons/gut"
copy_addon "third_party/godot-statecharts" "godot_state_charts" "$STATE_REV"
copy_addon "third_party/gut" "gut" "$GUT_REV"
[[ -f "$GODOT_ADDONS/keychain/plugin.cfg" ]] || fail "Bundled Keychain missing"
[[ -f "$GODOT_ADDONS/rts_framework/plugin.cfg" ]] || fail "Bundled RTS Framework missing"
echo "SCALFAGUS_ADDON_SETUP_OK ($MODE)"
