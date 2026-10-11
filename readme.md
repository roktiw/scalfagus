# Scalfagus — Godot-only RTS / Direct / Possession prototype

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

## UI and keys

The Godot main menu includes **START GAME / OPTIONS / QUIT**. Start opens the *existing* technical prototype world without a second window. In game: F1 RTS, F2 Direct/TPP, F3 FPS, Tab cycles views; Q/E orbit; right drag orbit; wheel zoom; WASD controls actor in Direct/FPS. **RTS WASD camera panning, HUD, unit selection and right-click orders are a separate upcoming gameplay change and are not yet in main.**

## Project layout

- `apps/game/` — full Godot project, source art and GDScript.
- `design/`, `architecture/`, `art/` — rules, 5-direction renderer contract and MVP MAN/ETH roadmap.
- `scripts/{bootstrap,dev,game,check,build}.sh` — game install, execution and export.
- `scripts/*.mjs` — optional Node.js art validation and generation tools.

The game is currently an **engine vertical slice**, not a complete RTS. The MAN/ETH Verdant Divide 64×64 jungle gameplay specification exists, but resource collection, squads, production, opponent AI, victory flow, unit selection and RTS orders still need implementation. Refer to `design/mvp-man-eth-jungle-vertical-slice-2026-10-11.md`.

**Historical note:** `docs/INSTALLATION-BUILD-REPORT-2026-10-11.md` records an older local Tauri build. It is not the current product architecture. Old local `~/Applications/Scalfagus.app` Tauri bundle is not modified by updating this repository; uninstall it manually if no longer desired.
