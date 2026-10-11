# Scalfagus — permissive Godot addon setup

**Decision:** install pure-GDScript **Godot State Charts 0.22.5** and development-only **GUT 9.7.1** from pinned Git submodules, enable the already-present **Keychain 2.1**, retain already-vendored **RTS Framework** as a WIP reference. **Do not install LimboAI** in MVP 0.1: binary GDExtension, cross-platform release risks and overlapping State Charts functionality.

All four codebases are licensed under **MIT**. MIT permits private and commercial use, modification and redistribution but **requires retention of copyright and license notices**; it is not literally obligation-free. GUT may ship independent fonts/assets with their own notices; retain upstream files and verify any distributed assets. Nothing here changes the game's Godot-only architecture or DEC-033 release scope.

## One-time local installation (after switching to this branch / after merge)

```bash
git submodule sync --recursive
bash scripts/install-godot-addons.sh --install
bash scripts/check.sh
bash scripts/dev.sh --editor
```

`--install` initializes Git submodules at pinned commits and copies *only* `addons/godot_state_charts` and `addons/gut` to the native Godot project. No demos are copied. Install is **development-time only**; nothing downloads during the game. `--offline` copies only already-initialized submodules; `--check` verifies module hashes, installed directory markers and plugin manifests without networking. `scripts/dev.sh` and `scripts/check.sh` demand a completed setup and print the installer command otherwise.

The copied project add-ons are ignored in Git; upstream is reproducibly pinned via tracked submodule gitlinks and `.gitmodules`. Never hand-edit a generated addon; change the source revision or integration wrapper, then reinstall. External libs do not take over economy, legal commands, fog, ownership, replays or server authority.

Godot `project.godot` enables Keychain, State Charts and GUT as editor plugins. RTS Framework remains **disabled** because its editor plugin currently registers no useful classes (and upstream labels the framework WIP); source is retained for reference. Actual gameplay adapters for Keychain and State Charts remain future work.

## Verification status

**Not yet tested in an actual Godot editor or game runtime.** Source revisions and manifests are verified upstream; no Mac/Windows/Linux/Web engine or CI success claim is made. First run `bash scripts/install-godot-addons.sh --install` on a machine with GitHub access, then `bash scripts/check.sh`, and inspect editor's Project Settings → Plugins.

## Selected upstream pins

- [Godot State Charts](https://github.com/derkork/godot-statecharts/tree/76d226a3efac66a72aea825382b320c94808f409), version v0.22.5, pure GDScript, MIT, Godot 4.7 fix.
- [GUT](https://github.com/bitwes/Gut/tree/aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605), branch `godot_4_7`, 9.7.1, MIT.
- [Keychain](https://github.com/Orama-Interactive/Keychain), vendored, MIT.
- [RTS Framework](https://github.com/rluders/rts-framework), vendored, MIT, WIP.
- [LimboAI](https://github.com/limbonaut/limboai/releases/tag/v1.8.1), deliberately not installed.
