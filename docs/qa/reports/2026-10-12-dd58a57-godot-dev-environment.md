# Godot workstation setup, cleanup and validation

## Context

- Baseline `origin/main`: `dd58a57357ec8bb03812f1b82d0194d3f9a433b5`.
- Tested development code: `d823963f502fe111eafe66a0783353f65e8f4ec6`.
- Branch: `codex/godot-local-dev-environment`.
- macOS Darwin 27 / arm64, Godot `4.7.2.stable.official.ed1daf0bf`, GUT 9.7.1, Node 24.21.0, local PyYAML 6.0.3.
- Overall: automated environment/QA/export validation PASS; GUI gameplay and foreign target runtime acceptance remain incomplete.

## Changes and local actions

1. No tracked Tauri/Rust/React browser client was found. Replaced obsolete Studio/desktop-shell setup documents and stale game README with current native Godot instructions. Added a native-source gate and removed the ignore rule that could hide a reintroduced desktop client.
2. Added `setup-dev.sh`, `doctor.sh` and the `dev-tools.sh` entrypoint. Setup installs pinned addons, imports the project, creates a repository-local map-tool venv and seeds the existing GUT editor configuration without replacing Keychain profiles or other GUT test directories.
3. Added shared GUT CLI config and VS Code tasks for the native editor/game, full QA, GUT, diagnostics and macOS export. Godot's existing debugger, profiler, remote inspector and GUT bottom panel remain the integrated development tools; no new shell or custom test UI was introduced.
4. Downloaded official Godot 4.7.2 export templates and verified the repository-pinned SHA-256. Installed templates locally for all four existing presets.
5. Removed the unnecessary Apple Command Line Tools requirement for Standard Godot/GDScript setup. Enabled local map venv discovery; corrected editor argument forwarding; made QA compatible with `.git` files in Git worktrees.
6. Found a zero-exit engine error while the exporter packed GUT's editor/test scenes. Release presets now exclude `tests/*`, `addons/gut/*` and `.gutconfig.json`; strict export checks reject engine errors even with exit zero. Added a regression for this failure mode. Runtime addons remain packaged.
7. Archived the installed legacy bundle identified by `com.scalfagus.desktop` under `~/.local/share/scalfagus/retired-tauri-20261012/Scalfagus.app`. Installed the exported native bundle in `~/Applications/Scalfagus.app`. User profiles were untouched. The archive provides recovery if necessary; Git pull alone does not repeat this machine-specific app installation.
8. Preserved local `dev_menu.gd` formatting separately; excluded it from the PR. The currently open editor can rewrite that file's indentation. Restart the existing editor after setup to reload its GUT settings; this run did not forcibly close an editor that might contain unsaved work.

## Actual validation

| Scenario | Exit | Status | Evidence |
|---|---:|---|---|
| Template archive checksum/install | 0 | PASS | `templates-install.log` |
| Initial setup and repeated setup | 0 | PASS | `setup.log`, `setup-final.log`; editor config marker |
| Doctor after setup and after final QA | 0 | PASS | `doctor.log`, `doctor-final.log`; all prerequisites present |
| Full `dev-tools.sh test` on tested SHA | 0 | PASS | `qa-final.log` |
| Native-source and runner regressions | 0 | PASS | final QA gate logs |
| Godot import/addons/runtime smoke suite | 0 | PASS | final QA gate logs |
| GUT shared config | 0 | PASS | 4/4 tests, 32 assertions |
| Authored map consistency | 0 | PASS | final QA map log |
| Five-view reference tests | 0 | PASS | 6/6 tests |
| macOS export after release filtering | 0 | PASS | `export-macos-final.log`, no ERROR output |
| Windows export | 0 | PASS | `export-windows-final.log` |
| Linux export | 0 | PASS | `export-linux-final.log` |
| Godot Web export | 0 | PASS | `export-web-final.log`; native engine target, no separate web client |
| Installed native macOS startup, headless 120 frames | 0 | PASS | `macos-runtime-final.log` |
| Standalone GUI menu | n/a | PASS for launch only | observed native Scalfagus debug menu; OpenGL Apple M4 in `native-gui.log` |
| GUI click-through gameplay | n/a | BLOCKED | Computer Use reported `noWindowsAvailable` on clicks; no full gameplay PASS claimed |
| Exported match via CLI scene override | 1 | BLOCKED | Official release template disables path overrides; `macos-match-runtime.log`; not treated as a gameplay regression |
| Windows/Linux/Web target execution | n/a | NOT_RUN | Packaging results do not prove runtime on other systems |
| GUT bottom-panel click test, Keychain remap/restart | n/a | NOT_RUN | Editor config successfully seeded, but interactive acceptance remains |

Logs: `logs/local-qa/godot-dev-environment/` and `logs/local-qa/2026-10-12-115907-d823963f5/`. Paths and ANSI formatting are sanitized before publication. The generated QA drafts are superseded by this report.

## Remaining work

- Complete GUI Human-Bot economy/combat and Keychain persistence using a working native input route. Do not claim menu visibility as full gameplay acceptance.
- Test Windows/Linux/Web exports on target systems, and sign/notarize macOS for release when appropriate. Templates/build outputs are local and excluded from Git.
- Existing ObjectDB/RID teardown warnings remain in legacy headless smoke tests.
- LAN Human-Human and recorded-command replay remain release gaps described by the prior deep audit; this environment change does not implement them.
- Historical test reports mentioning Tauri are retained as evidence; they no longer prescribe a current runtime. Optional offline Node/Python tooling is retained because it validates authored assets and maps.

## HANDOFF TO CHATGPT

- PR: [#21](https://github.com/roktiw/scalfagus/pull/21).
- Report: [Markdown evidence snapshot](https://github.com/roktiw/scalfagus/blob/a0a58d7/docs/qa/reports/2026-10-12-dd58a57-godot-dev-environment.md).

Use [Godot development instructions](../../GODOT-DEVELOPMENT.md). Baseline `dd58a57357ec8bb03812f1b82d0194d3f9a433b5`, tested code `d823963f502fe111eafe66a0783353f65e8f4ec6`. Workstation setup, doctor, all automatic QA gates and four exports PASS. macOS native startup PASS. Local Tauri app archived and replaced by native Godot. GUI sequence/Keychain persistence, GUT panel interaction and foreign target runtimes are not accepted yet. Next agent should use existing dev-tools scripts, review the LAN/command-gateway branch, and preserve the engine-authority boundaries. PR and report links are added during publication.
