# Scalfagus — Godot-only RTS / Direct / Possession prototype

## MVP 0.1 — one race, two player slots, classic RTS

**CURRENT OWNER-APPROVED DELIVERY SCOPE (DEC-033):** MAN vs MAN (four templates: HQ / MIN worker / Barracks / Rifleman), Overlord RTS only, one floating platform map, finite carried Matter, basic production/combat/victory, and **Human-Human LAN/loopback, Human-Computer, Computer-Computer** (GUI watch or accelerated headless). This is an implementation plan, **not an existing playable feature**. FPP possession is future; TPP is not a production mode. ETH/ORG and advanced logistics are later milestones. Start with [agent contract](AGENTS.md), [MVP 0.1 design](design/mvp0-man-mirror-rts-2026-10-11.md), [YAML scope](design/mvp0-man-mirror-rts.yaml), [backlog](design/mvp0-man-mirror-backlog.yaml) and [headless lab](design/godot-headless-balance-lab-2026-10-11.md).


## Engineering rule — DEC-034 Reuse First

Do not reinvent Godot A*, raycasting, UI, keybinds, physics, generic FSMs or networking. **Wrap built-in Godot facilities first**; use **pinned and audited GitHub/AssetLib modules** only when demonstrably beneficial. Keep game rules behind stable ports and use one authoritative command validation path. Read [ADR-0004](architecture/adr-0004-godot-reuse-first-wrappers.md), [21-capability map](architecture/godot-reuse-component-map.yaml), [third-party candidates](architecture/godot-third-party-candidates.yaml), [research](docs/GODOT-REUSE-RESEARCH-2026-10-11.md) and [agent playbook](docs/AGENT-REUSE-FIRST-PLAYBOOK.md). Candidates are NOT installed or locally runtime-tested simply by being listed.

**Current first playable release = DEC-033: MAN vs MAN classic RTS, H-H/H-C/C-C.** ETH, ORG and possession remain future milestones. The existing 3-camera Godot demo stays as a regression fixture. Draft PR #5 RTS navigation is not a confirmed feature on main.

## Universal world rule — DEC-030

**Every playable Scalfagus battlefield is a floating platform in outer space.** The top can be brown-earth jungle with trees, welded metal patchwork, rock, desert, marshland or mixed terrain. Each platform has real traversable ground, visible outer rim/underside, hard invisible gameplay walls and space/starfield around it; the distant planet is backdrop only. **Ordinary planet-surface maps are not a valid alternative.** The first `Verdant Divide` map is a **stationary 64×64 candidate floating jungle platform**. No orbital movement, starship travel, spherical gravity, sailing/flying units or fluid harvesting in MVP.

**Coding agents start here:** [AGENTS.md](AGENTS.md) → [MVP delivery gates](design/MVP-DELIVERY-GATES.md) → [machine-readable task backlog](design/mvp-implementation-backlog.yaml). World law: [space-platform-world-contract](design/space-platform-world-contract-2026-10-11.md), [frame YAML](design/battlefield-frames.yaml), [surface material presets](design/platform-surface-presets.yaml), [first playable map YAML](design/mvp-verdant-divide-map.yaml), [acceptance](design/battlefield-frame-acceptance.yaml). The older MAN vs ETH five-role loop is a **later expansion**, superseded for the first playable release by DEC-033's MAN mirror 1v1.


**Game/runtime: Godot 4.7.2 Standard with typed GDScript, one native window.** Tauri, Rust, Vite, WebView and a separate launcher are no longer part of the product. Godot owns menu, HUD, cameras, 3D terrain, actor simulation and platform exports. JavaScript/Node is *optional offline tooling* for pixel sprite atlas validation; it is not a game runtime requirement.

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
