# Unity + Blender migration — repository map and agent handoff

Owner direction, 2026-10-12: migrate to Unity + Blender with procedural worlds, units and content. This document maps the existing implementation; it does not claim a Unity project, Blender pipeline or migration has already been implemented.

Baseline inspected: `4767afdd5518cad4b2dfdab40ca54bbea82a323e`. Local QA fixes are in [PR #29](https://github.com/roktiw/scalfagus/pull/29); incorporate its minimap fog and test coverage corrections before using Godot as a reference. Its tested code is `d04c049bcca6b66589aad7fca352e8fbf977f50a`.

The new owner instruction supersedes older Godot-only stack requirements. It does not authorize changing resource conservation, faction rules, unit costs or unresolved future design decisions. Preserve the running Godot reference until Unity passes parity gates. Do not delete source/assets to make the migration appear complete.

## Read first

1. This map and [machine-readable inventory](repository-map.json).
2. `design/decisions.yaml`, especially DEC-033 release behavior and DEC-035–046 future faction contracts.
3. `design/agent-source-of-truth.yaml`: document routing; some implementation/status fields are historical, so verify against current code and QA.
4. `design/mvp0-man-mirror-rts.yaml` and `design/mvp0-agent-implementation-contract.yaml`: current scope/numeric candidate. Do not merge the alternative analytical balance profile into runtime.
5. `design/mvp-verdant-divide-map.yaml`, `design/space-platform-world-contract-2026-10-11.md`, `design/world-environments.yaml`, `design/world-topologies.yaml`.
6. QA evidence in PR #29, then `docs/qa/LOCAL-AGENT-TESTING.md` and current executable fixtures.
7. For procedural identity and art: `blueprints/README.md`, `art/README.md`, faction naming and machine contracts under `design/`.

## Repository districts

| Directory | What exists | Migration treatment |
|---|---|---|
| `apps/game` | Running Godot project, GDScript, scenes, tests, addons, imported PNGs | Reference implementation; port behavior, replace engine integration |
| `design` | YAML rules, decisions, scope, authored map, future systems | Preserve canonical decisions; separate active MVP from proposals |
| `architecture` | ADRs, reuse map, addon lock, sprite mapping example | Keep history; write new Unity adapter/pipeline ADRs |
| `blueprints` | Unit/building/map/environment dossiers and asset references | Convert approved fields into generator recipes; retain stable IDs |
| `art`, `assets` | Concepts, generated images, faction/UI assets | Visual reference and audited reusable assets; not procedural 3D implementation |
| `scripts` | Godot setup/QA/build/export and map/icon compilers | Retain reference QA; add distinct Unity/Blender tools |
| `third_party`, `apps/game/addons` | Godot vendors/submodules | Do not copy into Unity; retain for reference until retirement |
| `docs/qa`, `logs/local-qa` | Evidence, test instructions, reports | Preserve; add Unity results with exact editor version and exit codes |
| `research`, `inbox` | Research and owner discussion history | Context, not automatic feature requirements |
| `package.json` | Auxiliary Node asset/test tooling | Inspect actual scripts before removal; Node does not imply a web game |
| `build`, `.tools`, `.godot` | Local generated artifacts/tools/caches | Not source to port; keep out of Unity Assets and Git |

## Source → target map

Target paths below are proposed, not existing directories. Keep C# simulation independent of Unity objects so it can run in EditMode tests and a headless runner.

| Current source (`apps/game/scripts/` unless stated) | Responsibility | Proposed target under `apps/unity/Assets/Scalfagus/` | Port boundary and acceptance |
|---|---|---|---|
| `mirror_match_state.gd` | IDs, commands, economy, movement, mining, construction, production, combat, bots, victory, hash | `Core/Simulation/` | Split by domain without changing tick ordering; never put authority in MonoBehaviour lifecycle |
| `mirror_timing.gd` | Fixed tick/durations | `Core/Simulation/Timing.cs` | Preserve 20 Hz and durations; rendering rate must not change economy |
| `mirror_geometry.gd` | Tile scale, footprint, access cells | `Core/World/Geometry.cs` | One geometry contract: 2 m tiles, 3×3 buildings, 6 m footprint, 12 exterior access cells |
| `mirror_map_port.gd`, `apps/game/maps/verdant_divide.compiled.json` | Load compiled terrain/resources/spawns | `Core/World/MapDocument.cs` | Initial exact authored fixture: 10 deposits / 1660 Matter; validate schema and source hash |
| `mirror_navigation_port.gd` | AStarGrid2D adapter, occupancy, invalidation | `Adapters/Navigation/` | Replace Godot provider; deterministic routes/tie breaks must be specified and tested; rendered navigation cannot silently change sim outcomes |
| `mirror_command_gateway.gd` | Host-bound command validation | `Core/Commands/` | Preserve owner/slot/sequence validation, rejected commands and no direct client state mutation; no playable LAN exists to copy |
| `mirror_replay_archive.gd` | Replay serialization/validation/checksums | `Core/Replay/Archive.cs` | Preserve format 2 reader or explicitly version conversion; canonical JSON/hash bytes, map/rules/history validation |
| `mirror_replay_session.gd` | Incremental playback/restart/step | `Core/Replay/Session.cs` | Same command order/ticks, safe malformed loads, read-only playback |
| `mirror_fog_of_war.gd` | Discovery/visibility state | `Core/Visibility/` | Fog filtered snapshots shared by world, selection, minimap, bots |
| `mirror_view.gd`, `scenes/mirror_match.tscn` | Large integration scene: tick driver, camera, selection, visuals, input | `Runtime/Match/`, `Presentation/`, `Input/` | Decompose integration; commands through gateway, snapshots out; procedural mesh actors bind to persistent IDs |
| `mirror_physics_los_3d.gd` | Collider/raycast diagnostics | `Adapters/Physics/` | Trees/buildings block diagnostic ray, water distinct surface; deletion updates collider; never silently promote physics to combat authority |
| `mirror_fog_overlay.gd` | Fog presentation | `Presentation/Fog/` | Filter hidden state before graphics; shader is not access control |
| `mirror_minimap.gd` | Minimap and picking | `UI/Minimap/` | Port PR29 repair: discovery-safe terrain and currently visible sources, spectator omniscience only when authorized |
| `mirror_command_hud.gd`, `command_ui_theme.gd` | Portrait, stats, queues, orders, styling | `UI/Hud/` | Responsive bottom HUD; minimap left, portrait center, selected details/actions right; don't obscure world input |
| `mirror_match_result_overlay.gd` | End-match result UI | `UI/Results/` | Victory snapshot and restart/menu navigation |
| `menu.gd`, `scenes/menu.tscn` | Main menu/options/replay entry | `UI/Menu/` | Back/Escape, focus, pointer, scaling, settings persistence; preserve tested flow |
| `dev_menu.gd` | Local diagnostics/dev workflow | `Editor/`, `UI/Development/` | Development-only toggles; no free resources or cheats in production authority |
| `directional_sprite_5.gd`, asset manifest | Five-view sprites/atlas selection | `Presentation/Actors/`, procedural Blender recipes | Replace sprites with procedural 3D meshes; old PNGs remain reference/fallback, directional atlas algorithm is not required for a mesh |
| `main.gd`, `hero.gd`, `grid_navigator.gd`, `rts_minimap.gd`, `scenes/main.tscn` | Legacy multi-camera/hero spike | `Reference/` documentation only initially | Do not mistake spike for current MAN match or ship FPP/TPP accidentally |
| `project.godot`, Keychain addon | Engine settings, input, profile persistence | `Input/`, `Settings/`, `ProjectSettings/` | Replace engine settings and addon integration; preserve action names and actual restart acceptance |
| GUT, RTS Framework, State Charts | Godot tooling/reference | Unity-native test/adapters after audit | No automatic equivalent dependency installation or authority delegation |

## Procedural content contracts

Procedural means reproducible recipes plus validated output. It does not mean randomized game rules, free inventory or an online AI model deciding combat. Offline generative experiments may produce candidate recipes; approved recipes must be versioned, reproducible and license reviewed. External generative services are not required at runtime by this plan.

**World pipeline:** seed + generator version + approved world recipe → topology/resource/obstacle/spawn document → validation → canonical map hash → simulation and visual adapters. Generate logical occupancy before meshes/colliders/navigation. Use separate RNG streams for topology, resources, actors and decoration so an art change cannot alter deposits. Store generated logical world in save/replay, not just a seed dependent on an unavailable future generator. Verdant Divide remains a regression fixture; new procedural topology/stock distribution needs explicit design acceptance before replacing its gameplay parameters.

**Blender pipeline:** authored parametric scripts/node recipes + versioned parameters + seed → mesh/material/rig/animation/LOD/collider metadata + manifest. Build units, buildings, trees, rocks and platform pieces from original faction design language. Use local coordinates, explicit metre scale/pivots, socket names and collision bounds. Validate degeneracy, UV/material assignment, animation names, connector alignment, LOD budgets and repeatability. Render/UI decoration may vary while actor IDs, HP, cargo and gameplay footprint remain fixed.

**Unity pipeline:** import explicit exported assets and manifests into reproducible generated-content directories; assemble prefabs from validated recipes; instantiate/render snapshots from authoritative IDs. Do not rely on each developer's Blender installation to implicitly convert `.blend` files during game import. Bake reusable geometry offline first; runtime procedural geometry needs measured budgets and matching occupancy/collider tests before adoption.

**Shared manifest proposal:** schema version, recipe ID/version, seed, input hashes, logical map hash, generator/tool versions, output artifact hashes, dimensions/pivot, material slots, collision/LOD/socket descriptors and license provenance. Separate visual recipe hash from rules/map hash. Validate unique IDs, reachable starts/access cells, finite resource totals, bounds, no colliders covering legal exits and no hidden-state leaks.

**Replay determinism:** choose an explicit PRNG and integer/state serialization semantics. C# numeric overflow, iteration order, path tie breaks and JSON property ordering can diverge from GDScript. Matching gameplay traces is required; matching old SHA requires matching byte encoding too. If encoding changes, version it and compare semantic snapshots rather than reporting a false hash mismatch. Unity physics/frame timing must not drive authoritative replay.

## Proposed repository layout

```text
apps/unity/                    # new project; exact editor version pinned before implementation
  Assets/Scalfagus/
    Core/{Simulation,World,Commands,Replay,Visibility}/
    Adapters/{Navigation,Physics,Storage}/
    Runtime/Match/
    Presentation/{Actors,World,Fog}/
    Input/  UI/  Editor/
    Tests/{EditMode,PlayMode}/
    Generated/                 # only intentional runtime/import artifacts
  Packages/                    # manifest + dependency lock
  ProjectSettings/
tools/blender/                 # offline recipes, validation, export commands
content/procedural/            # approved recipes/schemas/manifests; persistent content IDs
scripts/unity/                 # batch test/build wrappers
scripts/blender/               # reproducible generate/validate/export wrappers
docs/migration/                # parity matrix, implementation reports, retirement checklist
```

Exact Unity/Blender versions, rendering pipeline, UI provider, navigation provider and performance budgets are implementation decisions to verify and pin in the bootstrap ADR. This repository map does not certify package compatibility. Reuse audited engine/package primitives before inventing generic frameworks; domain authority remains Scalfagus code.

## Work packages and dependencies

These are task boundaries for agents, not a claim that agents have been dispatched. Each PR must name its owner, changed contracts, dependency PRs, tests and artifacts.

| Package | Files owned / deliverable | Depends on | Done when |
|---|---|---|---|
| M0 Bootstrap | Unity project, version/package lock, batch runner, minimal scene, Blender tool pin | Owner stack direction | Clean checkout imports, EditMode/PlayMode/batch build produce real logs |
| M1 Core parity | Core simulation/timing/geometry/command schemas; reference trace exporter | M0 | Paid gather/build/train/combat/victory and rejected orders match fixed Godot traces |
| M2 World data | Map loader/schema, authored fixture, procedural logical generator | M1 contracts | Same fixture hashes/occupancy; generated worlds satisfy bounds, accessibility and conservation |
| M3 Blender recipes | Geometry/material/rig recipes and deterministic export manifests | M0, M2 geometry contract | Four MAN roster assets + terrain kit import with correct scale/pivots/colliders |
| M4 Navigation/physics | Adapters and occupancy invalidation | M1, M2 | Footprints/exits/routes tested; diagnostic collider parity; no physics authority drift |
| M5 Presentation/input/UI | Runtime match, camera, selection, fog, HUD, menus/settings | M1/M2/M3/M4 snapshots | Real mouse full match, Back/focus/scaling, hidden-state filtering, binding restart |
| M6 Replay | Archive/session/storage and playback UI adapter | M1/M2 serialization | Rejected commands, corrupt data, full lifecycle, generated-world replay and repeated hashes |
| M7 QA/build/retirement | Cross-engine parity matrix, platform packages/runtime acceptance, removal plan | All above | Evidence-backed parity; rollback available; remove Godot only in explicit retirement PR |

Parallel editing must avoid `mirror_match_state.gd` and shared schemas as contested files. Establish simulation/map/command/snapshot schemas in M1/M2 first; downstream agents consume them. One integration owner approves contract revisions and updates fixtures.

## Tests to port and expand

- `mirror_integrity_smoke.gd`, GUT authority fixtures → ownership, conservation, no duplicate spending or illegal client mutation.
- `mirror_timing_smoke.gd`, `mirror_smoke.gd`, `mirror_batch.gd` → fixed 20 Hz, complete lifecycle, repeated seed and multi-seed traces.
- `mirror_authored_map_smoke.gd`, `mirror_navigation_port_smoke.gd`, `mirror_footprint_smoke.gd` → authored fixture parity, route obstruction/invalidation, 3×3 and exits.
- `mirror_construction_lifecycle_smoke.gd` → reservation/cancellation/death/paid completion invariants.
- `mirror_gateway_smoke.gd` → owner/host validation; does not prove LAN.
- All `mirror_*replay*smoke.gd`, `mirror_human_replay_smoke.gd` → archive corruption checks, replay UI/session, terminal snapshots.
- `mirror_fog_smoke.gd`, `mirror_group_orders_smoke.gd` → fog-safe minimap/world/selection and group commands; import PR29 fix.
- `mirror_physics_los_smoke.gd` → reference 49/148 collider fixture and deletion; extend for generated worlds, keep diagnostic scope.
- `menu_pointer_smoke.gd`, `command_ui_smoke.gd`, `mirror_match_result_smoke.gd`, Keychain fixtures → menu pointers, HUD, results, remap/restart. OS mouse acceptance remains separate from injected events.
- `mirror_visual_smoke.gd`, Node atlas/emblem checks → retain legacy evidence; add procedural mesh/material/rig/LOD/import validators.
- New: malformed recipe rejection; repeated generation manifests; per-stream seed isolation; generated resource ledger; connectivity/exit validation; regenerate after tool upgrade; frame rate independent simulation; real target builds and runtime tests.

Do not mechanically translate assertions tied to Godot nodes into C# engine assertions. Preserve behavioral acceptance, then test Unity-specific import/input/rendering independently. Documentation-only work here does not rerun gameplay or establish Unity/Blender passes.

## HANDOFF TO IMPLEMENTATION AGENTS

Start with M0 and M1, retaining Godot as a reference. Ship one playable MAN mirror vertical slice before expanding procedural variety or post-MVP factions. Preserve canonical rule IDs and finite ledgers. Record which Godot fixture maps to which Unity test and publish exact tool versions, code SHA, seed, generated-world manifest, exit codes and actual target execution.

Do not port `.godot`, `.import`, vendored GDScript plugins, exported binaries or five-view lookup as the foundation of procedural 3D. Do not erase useful map compilers, design contracts, blueprints or regression evidence. Do not infer LAN, ETH/ORG, Titans or autonomous civilization implementation from design files. The immediate next deliverable is a pinned Unity/Blender bootstrap PR with headless tests and a reference-trace parity harness; the procedural asset pipeline follows the shared geometry/schema contract.
