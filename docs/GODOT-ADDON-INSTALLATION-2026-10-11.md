# Scalfagus — Godot MIT addon installation

**Status:** Repository setup is committed. Local Godot 4.7.2 editor verification is pending.
GitHub Actions currently fail before a runner executes any steps; **do not use CI as
test evidence or a release gate until runners are repaired**.

## Selected addons

| Provider | Version / Git SHA | Editor | Runtime use |
|---|---|---|---|
| RTS Framework — rluders | already vendored, MIT | enabled; no-op plugin | reference only; upstream WIP |
| Keychain — Orama Interactive | 2.1, already vendored, MIT | enabled | keybinding UI integration pending |
| Godot State Charts — derkork | v0.22.5 / `76d226a3efac66a72aea825382b320c94808f409` | enabled after setup | future unit AI only; never authoritative match |
| GUT — bitwes | 9.7.1 / `aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605` | enabled after setup | development testing only |
| LimboAI — limbonaut | v1.8.1 reviewed, MIT | **not installed** | excluded: native GDExtension and overlapping State Charts functionality |

MIT is commercially permissive but **requires preserving upstream copyright
and license notices**. The complete selected `addons/` subtree is copied intact,
including fonts/icons/licenses. The GUT addon is for dev tests, not game AI.

## One command after git pull

```sh
cd ~/GitHub/scalfagus
git pull
bash scripts/dev.sh --editor
```

`scripts/dev.sh` and `scripts/check.sh` call
`scripts/install-godot-addons.sh --ensure` automatically. On a new checkout
this performs `git submodule update --init` for the two source repositories
at locked commit SHAs, copies their exact addon subtrees into
`apps/game/addons/`, and preserves upstream notices. Future launches reuse
existing installations offline. **No network activity at game runtime.**
The independent launcher `bash scripts/dev.sh` starts the game directly.

For explicit operations:

```sh
bash scripts/install-godot-addons.sh --install  # download pinned sources and install
bash scripts/install-godot-addons.sh --check    # offline inventory and pins
bash scripts/install-godot-addons.sh --offline  # no downloads; use cached submodules
bash scripts/check.sh                         # real local Godot imports/smokes
```

For full Mac initial setup, `bash bootstrap.sh` invokes the local
check script after fetching the official Godot binary.

The checked-in `.gitmodules` locks complete upstream source in
`third_party/`. The installer **copies**, rather than symlinks, the needed
subtree into the game's `addons/`, keeping portable game exports. Its
generated local copies are ignored in Git to avoid 500+ vendored files in every
source change. To inspect source and licensing, use the pinned submodules.

## Manual Godot editor verification

After running the installer, open `apps/game/project.godot` via
`bash scripts/dev.sh --editor`. Under **Project → Project Settings → Plugins**,
confirm RTS Framework, Keychain, Godot State Charts and GUT are enabled.
Inspect editor Output for load/parse errors. Run local
`bash scripts/check.sh` and confirm `SCALFAGUS_ADDONS_SMOKE_PASS`.
This tests manifests and script presence, **not full editor usability**.

State Charts and Keychain are installed and enabled, **not yet wired into**
the MAN mirror bot and keybindings options respectively. The authoritative
`MirrorMatchState` remains the source of truth. LimboAI is not a required
MVP0 dependency. For rollback, revert the commit and remove the two generated
addon directories; never modify copied upstream files in place.

## Offline / GitHub Actions limitation

GitHub Actions currently fails before steps begin (`runner_id=0`); no CI
green status can be claimed. Use the above local scripts and keep their
real terminal output as evidence. `--check` does not use the network.
If the initial submodule download cannot connect to GitHub, the installer
will explain the missing dependency rather than reporting a false success.
