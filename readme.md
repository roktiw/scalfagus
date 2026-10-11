# Scalfagus

Offline RTS / TPP / FPS technical prototype: Godot 4.7.2 game, bundled in a Tauri 2 desktop launcher. The launcher opens the native game in a separate window. This build does not yet implement the full RTS economy, combat or faction design described in `design/`.

## macOS Apple Silicon

Prerequisites: Homebrew and Apple Command Line Tools (`xcode-select --install`). From this checkout:

```sh
bash scripts/bootstrap.sh  # installs Rust and Node 24, verified official Godot, npm dependencies
npm run check              # Godot import + existing smoke scenario + frontend typecheck/build
npm run dev                # Tauri development launcher
npm run game               # native game directly
npm run build              # release app at build/Scalfagus.app
open build/Scalfagus.app
```

Node 24 is selected by project scripts without requiring edits to shell configuration. Godot lives in ignored `.tools/`; release resources, npm dependencies, Cargo artifacts and builds are ignored. npm and Cargo lockfiles pin dependencies. Exporting the resource pack needs no Godot export templates: this initial local app bundles the verified Standard engine binary with the game pack.

Controls: F1 RTS, F2 TPP, F3 FPS, Tab cycles views; WASD moves the hero in TPP/FPS; mouse aims in FPS; right drag or Q/E rotates the external view; wheel zooms RTS; Escape releases the cursor. See `apps/game/README.md` for prototype details and visual limitations.

The release is for local macOS use, without Apple Developer distribution signing/notarization. Windows/Linux packaging and gameplay beyond the existing engineering spike are not validated.
