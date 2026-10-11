# Scalfagus — Godot-only RTS / Direct / Possession prototype

## MVP 0.1 — one race, two player slots, classic RTS

**CURRENT OWNER-APPROVED DELIVERY SCOPE (DEC-033):** MAN vs MAN (four templates: HQ / MIN worker / Barracks / Rifleman), Overlord RTS only, one floating platform map, finite carried Matter, basic production/combat/victory, and **Human-Human LAN/loopback, Human-Computer, Computer-Computer** (GUI watch or accelerated headless). This is an implementation plan, **not an existing playable feature**. FPP possession is future; TPP is not a production mode. ETH/ORG and advanced logistics are later milestones. Start with [agent contract](AGENTS.md), [MVP 0.1 design](design/mvp0-man-mirror-rts-2026-10-11.md), [YAML scope](design/mvp0-man-mirror-rts.yaml), [backlog](design/mvp0-man-mirror-backlog.yaml) and [headless lab](design/godot-headless-balance-lab-2026-10-11.md).


## Godot plugins — local installation (no GitHub Actions dependency)

Four MIT addons are enabled in the Godot project: RTS Framework (WIP reference), Keychain 2.1, Godot State Charts 0.22.5 and GUT 9.7.1 (dev tests). The last two are **pinned Git submodules**, copied into `apps/game/addons/` automatically on the first `bash scripts/dev.sh` or `bash scripts/check.sh` run; no manual AssetLib steps. LimboAI remains excluded due redundant AI stack and native binary portability. On initial checkout, a GitHub connection is required **once** for submodule sources. No downloads occur inside the running game.

```sh
git pull
bash scripts/dev.sh --editor      # installs missing addons, opens editor
bash scripts/check.sh             # independently checks real Godot locally
bash scripts/install-godot-addons.sh --check  # offline addon inventory
```

Instructions: [Godot addon installation](docs/GODOT-ADDON-INSTALLATION-2026-10-11.md), [exact pins and status](architecture/godot-addons.lock.yaml). **GitHub Actions are currently unavailable (jobs fail before allocating a runner); never report their state as test evidence.** Keychain's RTS control editor and InputMap dispatch now have a code integration (not engine-verified); State Charts game AI integration remains future work. See [MVP0 Keychain controls](docs/MVP0-KEYCHAIN-CONTROLS-2026-10-12.md).

## Runtime map — Verdant Divide (stacked draft PR)

Canonical YAML: `design/mvp-verdant-divide-map.yaml`; compiled native Godot JSON:
`apps/game/maps/verdant_divide.compiled.json`. Includes 10 fixed SOLID Matter
sources (1660 stock), two diagonal MAN starts, fixed water and trunk collision.
`MirrorMapPort` shares authored terrain and sources between simulation, renderer
and Godot AStarGrid2D. **Pending actual Godot engine run.** For source-parity
checks with pinned PyYAML: `bash scripts/check-map.sh`. See
[Verdant runtime contract](docs/MVP0-VERDANT-MAP-RUNTIME-2026-10-12.md).

## Engineering rule — DEC-034 Reuse First

Do not reinvent Godot A*, raycasting, UI, keybinds, physics, generic FSMs or networking. **Wrap built-in Godot facilities first**; use **pinned and audited GitHub/AssetLib modules** only when demonstrably beneficial. Keep game rules behind stable ports and use one authoritative command validation path. Read [ADR-0004](architecture/adr-0004-godot-reuse-first-wrappers.md), [21-capability map](architecture/godot-reuse-component-map.yaml), [third-party candidates](architecture/godot-third-party-candidates.yaml), [research](docs/GODOT-REUSE-RESEARCH-2026-10-11.md) and [agent playbook](docs/AGENT-REUSE-FIRST-PLAYBOOK.md). Candidates are NOT installed or locally runtime-tested simply by being listed.

**Current first playable release = DEC-033: MAN vs MAN classic RTS, H-H/H-C/C-C.** ETH, ORG and possession remain future milestones. The existing 3-camera Godot demo stays as a regression fixture. Draft PR #5 RTS navigation is not a confirmed feature on main.

## Universal world rule — DEC-030

**Every playable Scalfagus battlefield is a floating platform in outer space.** The top can be brown-earth jungle with trees, welded metal patchwork, rock, desert, marshland or mixed terrain. Each platform has real traversable ground, visible outer rim/underside, hard invisible gameplay walls and space/starfield around it; the distant planet is backdrop only. **Ordinary planet-surface maps are not a valid alternative.** The first `Verdant Divide` map is a **stationary 64×64 candidate floating jungle platform**. No orbital movement, starship travel, spherical gravity, sailing/flying units or fluid harvesting in MVP.

**Newest repo-wide findings:** [audited conclusions and coding order](design/mvp-repository-mechanics-audit-2026-10-11.md) · [machine-readable findings](design/mvp-repository-mechanics-audit.yaml) · [live-code mismatches](design/mvp0-runtime-parity-gaps.yaml). These are source-based reports; they do **not** certify passing Godot tests or LAN completion.

**Coding agents for CURRENT MVP 0.1 start here:** [AGENTS.md](AGENTS.md) → [MAN mirror scope](design/mvp0-man-mirror-rts-2026-10-11.md) → [M0 backlog](design/mvp0-man-mirror-backlog.yaml) → [current implementation candidate values](design/mvp0-agent-implementation-contract.yaml) → [source-versus-rules P0 mismatches](design/mvp0-runtime-parity-gaps.md) → [M0 acceptance](design/mvp0-man-mirror-acceptance.yaml). **The previous `MVP-DELIVERY-GATES.md` and `mvp-implementation-backlog.yaml` describe a later MAN–ETH milestone, not the first playable release.** World law: [space-platform-world-contract](design/space-platform-world-contract-2026-10-11.md), [frame YAML](design/battlefield-frames.yaml), [surface material presets](design/platform-surface-presets.yaml), [first playable map YAML](design/mvp-verdant-divide-map.yaml), [acceptance](design/battlefield-frame-acceptance.yaml). The older MAN vs ETH five-role loop is a **later expansion**, superseded for the first playable release by DEC-033's MAN mirror 1v1.


**Game/runtime: Godot 4.7.2 Standard with typed GDScript, one native window.** Tauri, Rust, Vite, WebView and a separate launcher are no longer part of the product. Godot owns menu, HUD, cameras, 3D terrain, actor simulation and platform exports. JavaScript/Node is *optional offline tooling* for pixel sprite atlas validation; it is not a game runtime requirement.

## Current code increment — local MAN mirror prototype (2026-10-11)

A **new experimental RTS path** now exists alongside the preserved original camera/hero spike:
- Menu **PLAY MAN vs BOT** loads `apps/game/scenes/mirror_match.tscn`. Select one MAN unit by left-click; right-click a tile to move, a yellow SOLID source to gather, or a visible enemy as a Rifleman to attack. Select a Worker, press **B** and click a valid tile to build Barracks after saving 100 Matter; select HQ and press **W** to train a Worker; select Barracks and press **R** to train a Rifleman. **WASD** pans the RTS camera; **Esc** returns to the menu.
- Menu **WATCH BOT vs BOT** runs the same simulation with two scripted bots. **P** pauses; **+/-** changes local spectator playback speed (not Godot editor speed).
- Headless runner (no rendering, no LLM on each tick):

```sh
godot --headless --path apps/game --editor --import --quit
godot --headless --path apps/game --script res://tests/mirror_smoke.gd
godot --headless --path apps/game --script res://tests/mirror_batch.gd -- --matches 10 --seed 42 --output user://mirror-results.jsonl
```

**Unverified implementation:** files are committed, but these NEW tests have not yet been executed successfully in a Godot runtime by this change. Both existing GitHub Actions Godot workflows currently report failure **before runner allocation** (`runner_id=0`, zero steps); this is not evidence of a GDScript pass or failure. A developer should run `bash scripts/check.sh` locally and inspect any script errors. Baseline graphics/3-camera prototype remains available through **LEGACY CAMERA SPIKE**.

**Not implemented yet:** real LAN/loopback H-H two-client multiplayer, box selection, full fog-of-war shroud, art polish, full MAN logistics/UMU/Energy, playable ETH, FPP possession. The new RTS view is a **blockout** and these mechanics are working-code candidates pending actual executable verification, not certified release features.

## Display and pixel-art regression fix (2026-10-11)

The MAN mirror RTS now **uses the project's real five-direction Sprite3D atlas renderer** again. The previous early RTS blockout drew every entity as a colored cube; this was a presentation regression, not missing source PNGs. Workers use `man_worker_32x48_idle_5view.png`, HQ uses the 128×128 lander atlas, trees use `neutral_tree_40x64_5view.png` and resource rocks use `neutral_rock_56x36_5view.png`. For now, Riflemen tint/reuse the worker art and Barracks tint/reuse the lander art; their dedicated atlases remain outstanding. Runtime state is still shared and sprite changes do not alter unit rules.

The desktop window now starts at **1440×810** (internal reference viewport 1280×720). Options offer 1280×720, 1440×810 and 1600×900 plus fullscreen; tiny 640×360/320×240 profiles were removed, including from the legacy F9 cycle. In mirror RTS the **mouse wheel** zooms the orthographic battlefield.

Regression checks: `bash scripts/check.sh` now also invokes `res://tests/mirror_visual_smoke.gd` to verify the five-view atlas nodes, resource/tree sprites, camera scale and startup resolution. New checks require a real Godot runtime and are **not claimed passed** merely because code was committed.

## Install & run — macOS (Apple Silicon and Intel)

Install Apple Command Line Tools first (`xcode-select --install`). Then:

```sh
bash bootstrap.sh                 # verified official Godot 4.7.2 and smoke tests
bash scripts/dev.sh               # one Godot window, MAIN MENU → START GAME → 3D scene
bash scripts/dev.sh --editor      # edit scene/scripts in Godot IDE
bash scripts/check.sh             # headless scene smoke + menu smoke + optional asset checks
bash scripts/build.sh --templates # optional: official 4.7.2 export templates (~1.28 GB)
bash scripts/build.sh macos       # export macOS zip (needs installed templates)
```

Linux/Windows: install official **Godot 4.7.2 Standard** and its matching export templates from https://godotengine.org/download. On Linux use `GODOT_BIN=/path/to/godot bash scripts/dev.sh`. On Windows open `apps/game/project.godot` in Godot Editor, press F6/F5 (run current scene/project) or use a bash-compatible shell. Platform exports may be created from Godot Editor → Project → Export or via `scripts/build.sh` on Bash-capable hosts after installing templates. Test exports on the target OS; cross-compilation does not guarantee target runtime compatibility.

## Current technical spike UI and keys (NOT finished MVP 0.1)

The Godot main menu includes **START GAME / OPTIONS / QUIT**. Start opens the *existing* technical prototype world without a second window. In game: F1 RTS, F2 Direct/TPP, F3 FPS, Tab cycles views; Q/E orbit; right drag orbit; wheel zoom; WASD controls actor in Direct/FPS. **New RTS navigation slice (in integration PR):** WASD camera-relative pan, Q/E rotate, wheel zoom, LMB/drag selection, Shift-add selection, RMB route around blocked jungle obstacles via 64×64 A* grid, and a debug minimap. Godot GUI acceptance is pending.

## Project layout

- `apps/game/` — full Godot project, source art and GDScript.
- `design/`, `architecture/`, `art/` — rules, 5-direction renderer contract and MVP MAN/ETH roadmap.
- `scripts/{bootstrap,dev,game,check,build}.sh` — game install, execution and export.
- `scripts/*.mjs` — optional Node.js art validation and generation tools.

The game is currently an **engine vertical slice**, not a complete RTS. All new mandatory floating-platform/map/roster/economy/combat/HUD/AI YAML and Markdown are **requirements and agent design fixtures**, NOT already implemented gameplay. The MAN/ETH Verdant Divide 64×64 jungle gameplay specification exists, but resource collection, production, opponent AI and victory flow still need implementation. Selection, formation commands and a coarse static A* path are part of the RTS integration slice, not full RTS AI. Refer to `design/mvp-man-eth-jungle-vertical-slice-2026-10-11.md`.

**Historical note:** `docs/INSTALLATION-BUILD-REPORT-2026-10-11.md` records an older local Tauri build. It is not the current product architecture. Old local `~/Applications/Scalfagus.app` Tauri bundle is not modified by updating this repository; uninstall it manually if no longer desired.

## RTS navigation development handoff

[RTS navigation + minimap implementation notes](docs/RTS-NAVIGATION-DEVELOPMENT-2026-10-11.md). This code adds a simplified floating-jungle fixture and static A* pathing. It is **not** a YAML-complete Verdant Divide map or a proven native Godot release until `scripts/check.sh` and manual macOS visual tests pass.
