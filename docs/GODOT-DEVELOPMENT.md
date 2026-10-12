# Native Godot development environment

Scalfagus uses one Godot 4.7.2 Standard/GDScript project: `apps/game/project.godot`. Open that project for scene editing, debugger, profiler, remote scene inspector, native input mapping and the GUT bottom panel. The runtime has no browser client, desktop shell or second launcher. Node runs optional offline asset checks; Python/PyYAML only compiles authored map data.

## Prepare a machine

```sh
bash scripts/dev-tools.sh setup --templates
bash scripts/dev-tools.sh doctor
bash scripts/dev-tools.sh editor
```

Setup imports resources, installs pinned addons, creates a repository-local map Python environment, seeds the GUT editor directory and optionally verifies/installs the official export templates. It preserves existing GUT test directories and never changes Keychain profiles. On macOS the bundled editor is used; elsewhere install Godot 4.7.2 and set `GODOT_BIN`. Node 24 and Python 3 are required for the full offline QA package. Setup requires network access for first-time dependencies. Reruns reuse the existing installations. Restart an already-open editor after setup so its GUT panel reloads the local configuration.

## Daily use

| Command | Purpose |
|---|---|
| `bash scripts/dev-tools.sh game` | Standalone native game window, useful for GUI input and focus testing |
| `bash scripts/dev-tools.sh editor` | Godot scene/script editor and integrated diagnostics |
| `bash scripts/dev-tools.sh import` | Resource import with script-error detection |
| `bash scripts/dev-tools.sh gut` | Same test directory and failure policy as the GUT editor panel |
| `bash scripts/dev-tools.sh test` | Native-source guard, runner regression, import/smokes, GUT, map and assets, with logs/report |
| `bash scripts/dev-tools.sh export macos` | Native macOS export; also accepts windows, linux and web |

VS Code tasks expose the same scripts, with local QA as the default test task. They do not install another language runtime or UI client. Godot remains the scene editor and debugger.

For GUI testing prefer the standalone `game` command when embedded editor input does not activate controls. Test Human-Bot and Bot-Bot, Worker gather/delivery, construction, production, group selection, camera, attack and victory. Change one Keychain shortcut and restart the standalone game to test persistence; restore the user's setting afterward. Passing headless tests does not establish GUI acceptance.

Use the debugger's remote tree and profiler to inspect node lifetimes, collision bodies, fixed ticks and physics/render costs. Never alter balance or game authority to improve measurements. Physics LOS remains diagnostic under DEC-033/034.

## Test evidence and exports

`qa-local.sh` supports normal checkouts and Git worktrees. Logs are local under `logs/local-qa/<run>/`; the generated report is a draft requiring an explicit manual result and handoff before publication. Script parse errors fail even if Godot returns zero. GUT tracks engine and push_error failures, and keeps orphan reporting enabled.

Export templates and build artifacts stay outside Git. Native Godot Web export is a build target, not a separate web client. An export PASS means packaging succeeded; run Windows/Linux/Web on their target environments before claiming runtime PASS. macOS release signing/notarization is a separate release task.

`doctor` reports missing Godot/addons/map tools/asset tools/templates without installing anything. Use `setup --templates` for repairs. Avoid parallel imports/exports against the same `.godot` cache. Native source guard rejects a reintroduced Tauri/React/Vite application. Existing historical reports remain evidence, not current architecture instructions.
