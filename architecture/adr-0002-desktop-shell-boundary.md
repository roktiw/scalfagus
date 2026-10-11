# ADR-0002 — Standalone Native Game First; Tauri/Electron Studio Optional
Date: 2026-10-11
Status: **PROPOSED**. The owner requested comparison and boilerplate; no Tauri/launcher code shipped yet.

## Context
Scalfagus needs offline desktop RTS+FPS, with TypeScript-first developer tooling. The same project may later benefit from a GUI to edit unit decks, hero skills, map rules, inspect telemetry and browse replays. Tauri 2 and Electron are plausible desktop shells; Godot itself exports native binaries.

## Decision proposed
- **Main game**: independent Godot export, no Node, Tauri or Electron required.
- **Development Studio**: first a local React/Vite TypeScript SPA with static authored fixtures and generated JSON. Add safe local data editing/replay view when valuable.
- **Optional desktop Studio/launcher**: Tauri 2 as shell, packaging native game binary as a platform-specific sidecar. Studio starts the separate Godot process, does not simulate rendering or FPS.
- Electron/Forge alternative only when TS-only launcher main process or Chromium-specific features are worth more than size/attack surface.
- Keep Studio/editor and native game as separate deliverables and independently versioned artifacts; use a proven manifest to ensure compatible data/protocol revisions.
- Treat app signing, release notarization, transparent updates and third-party licenses as required for public release but not initial proof.

## Tauri packaging concrete requirements
- Rust stable toolchain + system prerequisites per target platform; Linux WebKitGTK, Windows MSVC/WebView2, macOS Command Line Tools.
- Tauri config bundle.externalBin names sidecar; Tauri expects each binary with target triple suffix, e.g. aarch64-apple-darwin, with proper extension on Windows.
- Tauri shell permissions scoped to **one named sidecar** and finite validated CLI arguments; no unrestricted shell, no unrestricted filesystem or arbitrary URL open.
- Sidecar stdio can supply startup/exit status; optional game telemetry via bounded loopback interface must use version checks, random local auth token and no remote bind.
- No long-running privileged backchannel from remote sites, mods or LLM prompts to system shell.
- Source: https://v2.tauri.app/develop/sidecar/ and https://v2.tauri.app/reference/javascript/shell/ .

## Electron fallback constraints
- Use Electron Forge to package; hardened BrowserWindow with contextIsolation true, nodeIntegration false, sandbox true, restrictive CSP, narrow preload bridge and sender checks.
- Separate game process launched from reviewed packaged path; never a generic renderer 'execute arbitrary command' API.
- More resources/Chromium runtime in exchange for all-TS launcher internals.
- Sources: https://www.electronjs.org/docs/latest/tutorial/security/ and https://www.electronjs.org/docs/latest/tutorial/distribution-overview .

## Rejected now
- Tauri sidecar as mandatory control-plane for each game command, movement or projectile.
- Chromium renderer as the only game renderer **while also claiming it is a native Godot game**.
- Installing Rust, MSVC, WebKitGTK and Electron on every contributor's machine before any game code exists.
- Starting with auto-updater, cloud accounts, mod marketplace and desktop packaging before a playable vertical slice.

## Switch criteria
Adopt Tauri only when Studio has independent validated benefits and packaging/signing impact is manageable. Adopt Electron instead only if a measurable feature or maintenance advantage offsets its distribution/runtime costs. Keep standalone Godot as fallback in either case.

Related: [Tech seed](mono-blue-tech-seed-2026-10-11.md), [Templates](bootstrap-and-file-templates.md).
