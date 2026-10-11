# ADR / migration handoff: Retire Tauri desktop launcher; ship Godot-only

Date: 2026-10-11
Status: **owner-approved architectural supersession**. Source code change prepared here; target-platform builds require testing.

## Decision
Godot 4.7.2 Standard owns **the entire product window**: native gameplay, menu, HUD, 3D physics, terrain, sprites, input, AI and exports for macOS, Windows, Linux and Web. No Tauri shell, Rust sidecar, React/Vite UI, JavaScript bridge or duplicate input stack in game. TypeScript/Node remains allowed **as OPTIONAL OFFLINE build/art/data tooling**, not needed for game startup. No need to prefer C# when web is a target; use typed GDScript for MVP.

## Source changes
- Delete `apps/desktop/` and its Tauri/Rust/npm deps and generated icons/schemas from the tracked tree.
- Delete root shell scripts' launcher/sidecar assumptions and replace with direct `GODOT_BIN --path apps/game`.
- Root `bootstrap.sh` delegates to scripts/bootstrap.sh; on macOS install SHA256-pinned verified official Godot Standard. It installs NO Rust/Tauri. Node may optionally be installed via existing Homebrew for asset validation.
- Native main menu scene: START GAME, OPTIONS, QUIT. START opens `res://scenes/main.tscn` (the original RTS/TPP/FPS prototype scene). `apps/game/tests/smoke.gd` continues to validate underlying game directly.
- Export profiles for macOS, Windows, Linux, Web (Web uses Compatibility + GDScript). Download verified official **1.28 GB** matching export templates with `bash scripts/build.sh --templates`. Exact Godot export-option compatibility needs engine-import/export check.
- `scripts/check.sh` includes menu smoke and existing render/world smoke; optional pixel atlas Node checks.

## Project/agent priorities
P0: run the new menu and game with actual Godot 4.7.2 on macOS (manual launch) plus headless import/smoke; validate exports on all requested OSes and browsers. Verify template paths; inspect any Godot API warnings. Do not assert successful export without a created executable.
P1: RTS camera: WASD camera-relative pan, Q/E orbit, wheel zoom; actor selection, multi-selection, contextual HUD and command right-click. Respect F1/F2/F3 and single world/hero identity.
P2: replace first MAN-only test fixture with `design/mvp-verdant-divide-map.yaml` 64×64 jungle MAN vs ETH, trees as cover, water non-traversable, 2 spawn slots and fixed solid resources.
P3: economic worker and supply loops, health/combat/orders, basic 5-template rosters and victory by enemy completed building-class destruction incl mobile structural units (DEC-024).
P4: CI export smoke for desktop and Web. Platform signing and notarization are release requirements, not local development requirements.

## Historical limitations
The previous report `docs/INSTALLATION-BUILD-REPORT-2026-10-11.md` described a *local Tauri-based installation* and remains historical. Existing Tauri `.app` on user's machine is not removed remotely. Deleting tracked launcher source does NOT delete installed software.

## Explicit non-goals
No Electron substitute, no custom macOS launcher, no immediate map editor GUI rewrite, no mandatory Rust or pnpm/Bun/Vite. No promise that generated Godot export templates and application bundles have been tested on all platforms yet.
