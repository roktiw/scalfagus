# Scalfagus — Mono-Blue TypeScript Tech Seed

Date: 2026-10-11
Status: **proposed implementable architecture / RFC**, NOT a built or verified game.
Scope: architecture, repository layout, development environment, toolbelt, setup scripts, desktop packaging and milestone gates. First playable target: retro isometric RTS + Overlord, Direct Unit, true FPS possession of ONE hero in ONE world.

## Executive decision (proposed)
**TS-first development, Godot-native runtime**. Do not choose an unstable TypeScript binding for Godot simply to avoid writing any GDScript. Do not split authoritative combat physics across TS and Godot processes. Use TS for tooling, schemas, data authoring/build, asset pipeline, scenarios and developer UI; Godot/GDScript for runtime actor simulation, cameras, collisions, local AI, combat and game GUI. Tauri is an optional **studio/launcher**, not the playable game rendering canvas. Standalone Godot export runs without Tauri/Node/npm.

Toolchain baseline as of Oct 11 2026: **Node.js 24 Active LTS; pnpm 12.x with exact packageManager pin; TypeScript strict; Godot 4.7.2-stable Standard editor; Git; VS Code; macOS Apple Silicon first; Windows x64 and Linux x64 CI after vertical slice.** The Node 26 LTS transition is scheduled for 2026-10-28. Godot 4.7.2-stable released 2026-08-18. **Never use Godot 4.8 dev snapshots for MVP.** pnpm 12 workspace and monorepo support are verified in official docs. Rust stable, Tauri 2, WebView2 and platform C++ toolchains are OPTIONAL, installed only for studio packaging.

## Non-goals (first seed)
- No full Godot TypeScript runtime, no Node subprocess for every simulation tick, no two synchronized worlds, no custom ECS framework before actual profiling.
- No Electron/Tauri requirement for launching Godot-native game.
- No online multiplayer and FPS prediction/rollback, no LLM combat brain, no full Factorio, no procedural universal five-race generator, no heavy codegen that must regenerate on every keypress.
- No expectation that writing YAML/TS packages automatically creates a playable RTS. Engine, animations, collision, AI, packaging still need implementation and tests.

## Approved game constraints reflected in repository
- Faction identifiers ORG/Man/ETH lowercase 'org', 'man', 'eth'; short Organs/Manus/Eters; mid Organites/Manusians/Etherans; full owner-approved backronyms:
  - Organites Reproductive Generalismus (ORG)
  - Manusians Augmented Navigators (MAN)
  - Etherans Transcendent Hypervisors (ETH)
- No compulsory hive mind or undifferentiated super-organism. Unit roles remain distinct, independently useful and compositionally synergistic.
- Three resources ONLY: Matter, Volatiles, Energy. No extra mandatory currency, including fuel, mana, salvage or data.
- Seven basic unit archetypes in long-term design (worker/fighter/shooter/artillery/tank/flyer/specialist); independent from body substrate, chassis MIN/MID/MAX, match MIN/MID/MAX and LAND/WATER/AIR movement/target permission.
- Every participating human player starts with one Hero; Engineer, Commander and Specialist are STARTER kits of one shared open specialization graph. Future picks may exclude incompatible alternatives; exact respec remains unresolved.
- Three player-facing perspectives: Overlord RTS/sim, Direct Unit top-down action-RPG, literal FPS possession. All consume one actor state/weapon/resolver.
- One MAN playable MVP initially; three faction alpha later; fourth autonomous machine people and fifth speculations later only if proved distinct.

## Architecture invariant: one world, three controllers
~~~
                Scalfagus development monorepo
  +--------------------------------------------------------+
  | pnpm / Node 24 / TypeScript                            |
  | scripts, schema validator, CLI, data generator, tests  |
  | React/Vite Studio (dev only), replay inspection         |
  +------------------------+-------------------------------+
                           |
                    compile validated data
                           v
  +--------------------------------------------------------+
  | Godot 4.7.2 Native Game (.exe / .app / Linux executable)|
  | WorldState / FixedTick / Rules / Economy / Unit AI     |
  | HeroSkills / Combat / Map / Fog / Validated Commands    |
  |                   ONE authority                       |
  |      +---------------+-------------+                  |
  |      | OVERLORD      | DIRECT      | FPS              |
  |      | ortho-camera  | top-down    | perspective      |
  |      | build/RTS     | move/aim    | move/look/fire   |
  |      +---------------+-------------+                  |
  +--------------------------------------------------------+
                | OPTIONAL dev telemetry snapshots
                v
  +--------------------------------------------------------+
  | React/Vite Studio / optional Tauri 2 shell              |
  | design editor, local analytics, replay and launcher    |
  | Never required for the released native game           |
  +--------------------------------------------------------+
~~~
All player/controller commands are validated by Godot's authoritative rules. Do NOT put a network bridge on the required per-frame path. If a future full-TS simulation becomes essential, benchmark (a) Babylon.js/TS one-world or (b) a stable native Godot binding; migrating engines then is an explicit expensive decision.

## Monorepo layout: proposed target, not current git tree
~~~
scalfagus/
  readme.md                          # Product, quickstart, status and links
  AGENTS.md                          # Agent constraints and PR policy
  LICENSE / NOTICE                   # After owner approves license
  .gitignore / .gitattributes / .editorconfig
  .node-version                      # 24 (LTS major)
  .npmrc                             # restrictive supply-chain settings if applicable
  package.json                       # private pnpm monorepo scripts and toolchain
  pnpm-workspace.yaml
  pnpm-lock.yaml                     # generated and committed after real install
  tsconfig.base.json
  eslint.config.mjs / prettier.config.mjs (after deps pinned)
  toolchain.lock.json                # exact Godot, Node, pnpm and asset tool versions;
                                     # archive SHA-256 values only once verified
  apps/
    game/                            # TRUE product (Godot; NOT a JS package)
      project.godot
      export_presets.cfg              # after platform export feasibility check
      scenes/
        main.tscn
        maps/prototype_map.tscn
        actors/hero.tscn
        actors/worker.tscn
        buildings/hq.tscn
        ui/overlord_hud.tscn
      scripts/
        app/main.gd
        core/world_state.gd
        core/game_clock.gd
        core/command_validator.gd
        core/resource_ledger.gd
        entities/actor_state.gd
        entities/hero_progression.gd
        controllers/overlord_controller.gd
        controllers/direct_controller.gd
        controllers/fps_controller.gd
        cameras/camera_router.gd
        economy/worker_policy.gd
      assets/
        sprites/                      # original/licensed
        materials/                    # pixel-stable materials
        meshes/                       # low-poly FPS collision/render proxies
        fonts/
      generated/
        rules.v1.json                 # GENERATED — do not hand edit
        rules.v1.schema.json
      tests/
        headless_smoke.gd
        cross_camera_identity.gd
        economic_conservation.gd
    studio-web/                       # React + Vite + TS; optional design workbench
      package.json
      index.html
      src/main.tsx
      src/panels/faction_editor.tsx
      src/panels/replay_viewer.tsx
    desktop/                          # Tauri v2 wrapper AFTER gameplay proof
      package.json
      src-tauri/
        Cargo.toml
        tauri.conf.json
        capabilities/default.json
        binaries/                     # packaged Godot export per target triple
  packages/
    schemas/                          # canonical schema and versioned protocol types
      src/index.ts
      src/faction.schema.ts
      src/hero.schema.ts
      src/unit.schema.ts
      src/match.schema.ts
      src/command.schema.ts
    game-data/                        # runtime-authoritative authored YAML/JSON
      factions/org.yaml
      factions/man.yaml
      factions/eth.yaml
      heroes/talents.yaml
      heroes/starter-kits.yaml
      units/man/*.yaml
      economy/resources.yaml
      buildings/man/*.yaml
      scenarios/relay-frontier.yaml
    protocol/                         # versioned snapshots / optional dev telemetry
      src/index.ts
    cli/                              # scalfagus dev CLI
      src/cli.ts
      src/commands/doctor.ts
      src/commands/generate.ts
      src/commands/validate.ts
      src/commands/benchmark.ts
    replay-tools/                     # TS parser/analyser, used offline
      src/index.ts
  scripts/
    bootstrap.sh                      # idempotent macOS/Linux environment doctor
    bootstrap.ps1                     # Windows environment doctor
    doctor.mjs                        # no dependencies, checks tools/versions
    dev-game.mjs                      # spawn pinned Godot project
    generate.mjs                      # wrapper around typed schema/data compiler
    verify.mjs                        # complete local CI gate
    release.mjs                       # signed package ONLY after artifacts verified
  fixtures/
    smoke/
      move-and-fire.json
      cargo-loop.json
      hero-three-cameras.json
  tests/
    contracts/
    performance/
    visual/
  docs/                               # optional future, existing design/research kept
  design/                              # historical concepts; NOT directly runtime YAML
  research/                            # literature and game comparisons
  architecture/
    mono-blue-tech-seed-2026-10-11.md
    bootstrap-and-file-templates.md
    adr-0001-one-authoritative-game-world.md
    adr-0002-desktop-shell-boundary.md
  .github/
    workflows/check.yml
    workflows/game-smoke.yml
    workflows/release.yml             # disabled until signing configured
    dependabot.yml                    # optional; PR not auto-merge
    CODEOWNERS                        # later
~~~
Important: the **actual repository currently has design documents, not this runtime directory structure**. Do NOT claim any listed source exists until it is actually generated/committed and run.

## Module ownership; dependency rules
| Owner | Owns | Must NOT own |
|---|---|---|
| packages/schemas (TS) | schema versions, structural validity, generated JSON Schemas, typed protocol | live Godot actor behavior |
| packages/game-data (YAML) | values and prerequisites with existing approved naming and economics | executable JS callbacks embedded in YAML |
| packages/cli (TS) | bootstrap, validation, conversion, packaging/benchmark orchestration | production frame loop |
| apps/game/core (Godot) | authoritative entities/ticks/visibility, legal commands, HP, cost, ownership, physics, inventory | calling external npm model or Tauri for every move |
| apps/game/controllers (Godot) | camera-specific input to common command | separate weapon damage or independent copy of actor |
| apps/studio-web (React TS) | design editing, offline replay, local performance dashboards | cheating game sim by direct editing authoritative state |
| apps/desktop (Tauri Rust/TS) | optional launch, inspect, local file access via explicit scoped capabilities | embedded second renderer for real FPS gameplay |
| packages/replay-tools (TS) | event parsing and differential report | changing finalized replay source |

**Import graph:** data YAML -> typed TS validation/generation -> versioned compiled JSON -> Godot loader -> fixed game authority -> optional safe replay/telemetry output -> TS Studio. Never import historical design YAML at runtime unvalidated.

## Game data and build contract
- Existing design/*.yaml has historic values (Crystals/Gas/Resin) and exploratory balance: do NOT blindly import it into live gameplay.
- Author **fresh runtime data** under packages/game-data; after reviewing approved design, migrate deliberately.
- packages/schemas owns JSON Schema 2020-12 for canonical domain objects, generated through TS validation library (Zod/TypeBox/Ajv selection at implementation; **pick one**; proposed TypeBox + Ajv for JSON Schema output or Zod + tested exporter). Godot consumes compiled JSON and small runtime assert for supported schema version.
- Build strict gates: faction IDs exactly org/man/eth (fourth after approval); resource IDs exactly matter/volatiles/energy; references exist; no duplicate ids; skills have acyclic prerequisite DAG; conflicts cannot create impossible default build; initial kits not locked to camera; valid recipe costs; legal target domains.
- Generate one deterministic merged JSON manifest with stable key sorting, schema_version and content_hash (SHA-256) recorded in replay. Do not assign timestamps into gameplay hash.
- Do not maintain the same costs in both game-data YAML and scene file. Scene file uses ID reference and loads cost/profile data.
- Migrate/rename files only once source import and validation are covered with a test.

### Example entities in Godot core
- WorldState: tick, seeded PRNG, terrain + elevation, resource stores, factions, entity registry, mutable actor state, job queue, end condition.
- ActorState: entity_id, faction_id, body/chassis, movement domains, world transform, health, weapons, orders, inventory, current controller lease, hero data if applicable.
- CommandValidator: ownership/control authority, current tick, fog/LOS legality, resources/cooldowns, target domain and geometry; returns accepted or rejected reason.
- ResourceLedger: finite Matter/Volatiles/Energy transfer receipts, no negative balances, conservation within recipe outputs.
- HeroProgression: learned skills, skill points, prerequisite/exclusion graph, starting kit, cooldowns; 1 hero per human at start.
- CameraRouter: RTS orthographic / Direct overhead / FPS perspective; changes are visual/input only.
- Unit AI: per-actor local behavior + base economy policy; no collective supermind requirement.

### Event schemas (serialize only at boundaries)
Commands, snapshots and replay logs should include protocol_version and sim_tick; use idempotent unique command IDs where network/replay needed. Minimal conceptual contract:
~~~
{
  "protocol_version": 1,
  "command_id": "cmd-000128",
  "sim_tick": 440,
  "issuer": {"kind": "human", "player_id": "p1"},
  "actor_id": "hero-man-01",
  "type": "direct_fire",
  "payload": {"direction": [0.2, 0.0, 0.98]}
}
~~~
In-process Godot controllers can call typed GDScript APIs directly; JSON is for **archive, test and external tooling**, not a requirement to serialize 60 events every render frame. A scene camera is never an authority by itself.

## Development environment / toolbelt
**Everyday tools**: VS Code + Godot Standard, Git, Node 24 LTS, pinned pnpm 12, TypeScript strict, modern PowerShell 7 on Windows, Bash on macOS/Linux, native platform build utils. Optional: Rust stable + Tauri CLI, pixel editor, Blender for mesh/collider art, ffmpeg for GIF/video regression, image diff tool, DevTools inspector. Keep third-party dependencies minimal and reviewed.

**CI choices**: GitHub Actions with readonly permissions by default; Node 24 + pnpm pinned, lockfile/frozen install; schema/data validate + lint + TS typecheck + TS unit tests; Godot pinned editor headless import/test; optional pixel screenshot on repeatable renderer; upload artifacts/hashes. MacOS packaging requires signing/notarization in release pipeline only, not PR CI. Test Windows/Linux exports before claiming supported release platforms.

**Security / provenance**: no curl|bash with unreviewed remote scripts in bootstrap; opt-in installation step; prefer OS vendor/GitHub official releases, SHA-256 checks against independently retrieved manifests, pinned tooling; no committing credentials, release certificates or LLM API keys; restricted Tauri shell capabilities; no arbitrary local shell execution from Studio data, and no untrusted user YAML code execution. Add dependency approval and license inventory in CI before public builds.

## Desktop distribution: do not wrap the game itself prematurely
- First deliverable: **Godot standalone native game export** for macOS Apple Silicon; then Windows/Linux.
- Second deliverable when it brings value: **Scalfagus Studio** React/Vite web app, useful without desktop packaging.
- Third deliverable if wanted: Tauri v2 desktop Studio/launcher. Bundle platform-specific Godot export using Tauri's externalBin 'sidecar', which requires TARGET_TRIPLE suffix and narrowly scoped shell spawn permissions. The game remains its own native window and executable.
- Electron alternative: bigger Chromium/Node distribution, but familiar TS-only main/preload/renderer; Electron Forge packages. Require contextIsolation true, sandbox true, nodeIntegration false and strict IPC boundary. This is *not* a fallback capable of magically making Godot into a DOM widget.
- Recoil remains a benchmark challenger; if it wins the engine spike, preserve TS package/toolbelt/studio layers and replace the native Godot adapter and scene project explicitly through ADR, not stealth migration.

## Platform matrix
| Platform | Core game | TS toolbelt | Tauri Studio | Target |
|---|---|---|---|---|
| macOS Apple Silicon | Godot native | Node 24 arm64 | WebKit + Rust | PRIMARY |
| Windows x64 | Godot native | Node 24 x64 | WebView2 + MSVC Rust | secondary CI/export |
| Ubuntu x64 | Godot native | Node 24 x64 | WebKitGTK + Rust deps | secondary CI/export |
| macOS Intel | investigate performance and export after Apple Silicon proof | supported | available | optional |

## Local developer commands, proposed UX
~~~
git clone https://github.com/roktiw/scalfagus.git
cd scalfagus
./scripts/bootstrap.sh --check             # macOS/Linux; no side effects
pwsh -File scripts/bootstrap.ps1 -Check    # Windows
pnpm install --frozen-lockfile             # after lockfile is generated+committed
pnpm doctor
pnpm validate:data
pnpm generate:data
pnpm dev:game
pnpm dev:studio
pnpm test:ts
pnpm test:godot
pnpm test:contract
pnpm benchmark:engine
pnpm package:godot
pnpm package:studio                      # optional Tauri post-spike
pnpm ci
~~~
The above are **desired command contracts**, not a false assertion that these scripts currently exist. See [file and installation templates](bootstrap-and-file-templates.md).

## Installation/bootstrapping contract
- scripts/bootstrap.sh and scripts/bootstrap.ps1 are idempotent and **default to read-only check**.
- 'install' mode explicitly requested by human; installs only agreed toolchain from official/verifiable source or prints safe manual commands. Never silently call sudo/winget/brew install on a user's machine.
- Doctor verifies executable and MINIMUM/PINNED version requirements (Node 24.x, exact pnpm 12.x pin, Godot 4.7.2-stable, Git), platform arch, root project paths, export templates where relevant, optional Rust, stale generated JSON, YAML schema coverage and program code signatures when needed.
- If tool unavailable, explain next steps and stop. Avoid installing random Godot from OS package managers without validating version; Brew/Winget may carry newer versions.
- record platform environment in fixtures/doctor-output.json **without usernames, private paths or secrets** (use sanitized summary).

## CI gates and code quality
**P0** formatting, no secrets, install frozen lock, TS strict and ESM, schema refs, replay fixtures.
**P1** headless Godot editor import + script compilation + smoke launch. Use '--headless --path apps/game --editor --import --quit'; then appropriate Godot scripts/scenes.
**P2** fixed seeds / actor-id continuity / money conservation, camera->control authority and hero skill pivots.
**P3** screenshot comparisons across overlord and FPS (only on pinned GPU/renderer or with allowed variance), microbenchmark count of AI units.
**P4** package game export and Studio; sign/notarize only on privileged protected release workflow. Actions dependencies pinned by immutable SHA *at implementation*.

## Roadmap / deliverable gates
**S0 — repo/toolchain seed**: README, AGENTS.md, workspace, doctor, schema+fixture validation, stable build script, CI smoke. Exit: clean checkout+setup on primary Mac runs pnpm ci without missing tools except optional Godot until installed.
**S1 — rendering/camera kill-test**: one compact real 3D terrain, orthographic RTS readable pixel aesthetic, true FPS traversal, same actor ID & damage. Exit: no 2nd world; no sprite visual deal-breaker.
**S2 — vertical game slice**: 1 MAN hero, 2 workers, enemy, wall, deposit, HQ and defense; real cargo loop, three perspective controls, ability. Exit: 10-minute playable skirmish.
**S3 — internal MVP**: meaningful Overlord/Direct/FPS, Matter+Volatiles+Energy physical movement, a handful of well differentiated units/buildings, simple bot, talents, one map, win/loss and restarts. Exit: newcomer can play through entirely Overlord, and ability persists across perspectives.
**S4 — original faction alpha**: ORG/MAN/ETH distinct economic loops, counterplay, BALANCE, no mandatory hive mind. Exit: players identify differences within first minute.
**S5 — post-MVP**: autonomous machine fourth race probe; optional Studio/Tauri launcher, advanced FPS and multiplayer, optional LLM lab. No fixed delivery date.

## Architecture decisions requiring explicit signoff
A1. Godot 4.7.2 versus Recoil measured spike outcome.
A2. Full TypeScript browser runtime (Babylon) **only** if TS in every runtime line is an absolute constraint.
A3. Hero respec, death/recovery, starter-kit economy.
A4. Whether Studio is developer-only or distributable with game.
A5. Whether need Tauri at all; not until website/dev-tool value exists.
A6. Pixel-art renderer pipeline: 3D + billboards versus low-poly only versus hybrid; performance/occlusion test.
A7. Data schema library TypeBox/Ajv vs Zod exporter, verify version compatibility.
A8. Locked toolchain artifacts + SHA-256, first actual CI green run. Never invent pinned hashes or success claims.

## Primary official documentation
- Node release schedule: https://github.com/nodejs/Release
- pnpm 12 install/workspaces: https://pnpm.io/installation/ ; https://pnpm.io/workspaces
- Godot 4.7.2 stable archive: https://godotengine.org/download/archive/
- Godot CLI: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- Godot GDExtension: https://docs.godotengine.org/en/stable/engine_details/engine_api/gdextension/index.html
- Godot VCS ignore: https://docs.godotengine.org/en/stable/tutorials/best_practices/version_control_systems.html
- Tauri prerequisites: https://v2.tauri.app/start/prerequisites/
- Tauri sidecar: https://v2.tauri.app/develop/sidecar/
- Tauri shell API: https://v2.tauri.app/reference/javascript/shell/
- Electron security: https://www.electronjs.org/docs/latest/tutorial/security/
- Electron Forge distribution: https://www.electronjs.org/docs/latest/tutorial/application-distribution
- Community GodotJS: https://github.com/godotjs/javascript — research only, NOT official TS runtime approval.

See also Scalfagus gameplay constraints:
- ../design/project-state-and-conversation-synthesis-2026-10-11.md
- ../design/faction-naming-conventions-2026-10-11.md
- ../design/hero-progressions-and-three-cameras-2026-10-11.md
- ../design/mvp-iso-pixel-rts.md
