# ADR-0004 — Reuse First: Godot facilities, vetted GitHub modules, thin adapters

Date: 2026-10-11  
Status: **OWNER-APPROVED ENGINEERING POLICY; implementation candidates NOT installed or runtime-verified**  
Decision: **DEC-034**  
Authoritative release scope: **DEC-033, MAN vs MAN, RTS only**, two player slots H-H / H-C / C-C. The historical MAN+ETH and FPP/TPP milestones must NOT leak into the MVP 0.1 coding queue.

Supporting material:
- [Component architecture map](godot-reuse-component-map.yaml)
- [Vetted source registry](godot-third-party-candidates.yaml)
- [Verified public-source research](../docs/GODOT-REUSE-RESEARCH-2026-10-11.md)
- [Mandatory agent intake / PR review](../docs/AGENT-REUSE-FIRST-PLAYBOOK.md)
- [Micro MVP backlog](../design/mvp0-man-mirror-backlog.yaml)

## Decision / nonnegotiable engineering rule

**Before writing a nontrivial utility, subsystem, widget, algorithm or gameplay framework, search in this order:**
1. **Already present** in this repository and its Godot scenes, scripts and pinned addons.
2. **Godot 4.7.2 Standard** documented class/node/server/API (preferred; no third-party dependency).
3. An **audited GitHub / Godot AssetLib implementation** with source availability, compatible license, version/commit, compatible Godot 4.7.2 and intended runtime targets.
4. Only then write **Scalfagus-specific glue** (thin adapters) or genuinely unique **game domain code**. Document the failed reuse alternatives and tests in the PR.

"Wrap what's already on GitHub" **does not mean download arbitrary GitHub code**. Prefer an engine primitive to copying 2,000 lines from a WIP RTS package. Do not load unreviewed third-party code at game runtime. Prefer immutable, offline-vendored source under `apps/game/addons/<id>` over floating `main`, remote installers, or anonymous binaries. Follow the license; log upstream, exact commit SHA, hashes for distributed archives, notices, and security review. If an upstream library needs heavy editing, isolate a small adapter or reject it and justify the exception.

**Disallowed without a reviewed ADR exception:** homegrown A* search, ray/shape physics solver, bespoke GUI layout engine, custom input-event dispatch stack, hand-written general FSM/BT engine, custom network socket transport or OS launcher. Game rules, canonical command validators, fog-of-war filtering, integer resource ledger and deterministic simulation are genuinely unique and are **owned by Scalfagus**; a reusable module can support them but cannot override them.

## Domain boundaries — the existing game stays the source of truth

The game owns **one authoritative `GameState`** and fixed-tick `MatchSimulation`. A neutral `CommandEnvelope` carries `{tick, slot_id, actor_ids, action_id, target_cell/entity_id, sequence_no}`. Human, bot and network inputs all pass through the same command validator. No Godot plugin, AI behavior tree, selection UI, `NavigationAgent3D` nor a peer client may directly grant Matter, spawn paid units, move another player's pieces, reveal fog, damage opponents, or declare victory.

**MVP release:** one MAN faction mirrored into two slots, four templates (Command Core, MIN, Barracks, Rifleman), two-player LAN/loopback host for H-H, bot or headless C-C, one bounded floating jungle platform. Existing optional F2/F3 camera test code is preserved as an engine regression, not expanded into a parallel game mode.

### Dependency direction

```text
Scenes / input / HUD / visual presentation / headless test runner
                  |
       PlayerIntent / SelectionService
                  |
       CommandGateway (server authority)
                  |
     MatchSimulation fixed-tick + GameState
                  |
  [rules]  [economy ledger] [combat] [bot orders]
                  |
    read-only event/snapshot/projection ports
       /            |            \
Godot Adapters  Approved addons   Offline tooling
(input, nav,     (only behind      (YAML → Godot
physics, net,    adapters;         Resources/JSON)
UI, signals)    optional)
```

A node may own a `CharacterBody3D`, `NavigationAgent3D`, `Sprite3D` or `Control`. That node is an **adapter/presenter**, not a parallel inventory/HP authority. Keep functions pure where possible. All networking/bot/client paths must call the same command API as the human UI.

## Named wrappers / ports (not new infrastructure libraries)

| Scalfagus port | Wrap, don't replace | Scope / contract | Important non-goal |
|---|---|---|---|
| `InputBindingPort` | `InputMap`, `InputEvent`, `Shortcut`, `ConfigFile` | stable actions `rts_pan_*`, `rts_orbit_*`, `rts_select`, `rts_context`; consumer sees **semantic actions** | no raw `KEY_W` scattered in simulation; future remap via Keychain if approved |
| `RTSCameraController` | `Camera3D`, `InputMap`, built-in ray projection | WASD pans camera-relative, Q/E orbits, wheel zoom, bounded to floating platform; pitch preset | never moves the Hero or changes world collision |
| `SelectionPort` | `PhysicsDirectSpaceState3D.intersect_ray`, `Camera3D.project_position`, `Control` | click/drag/Shift; filter by team ownership, game visibility and interactability; selection returns entity IDs | no separate picking physics, no enemy-target commands by unauthorized clients |
| `CommandGateway` | Godot `signals`, `@rpc`/MultiplayerAPI transport | validates owner, tick, target, available resources, fog; queues legal commands | never trusts the UI or bot to mutate state |
| `NavigationPort` | `AStarGrid2D` for initial 64×64 discrete field; `NavigationServer3D`/`NavigationAgent3D` for evaluated upgrades | `route(from,to,clearance)` + versioned occupancy + blocked-target policy + recompute | do not author own A*, do not mark trees/water passable because a sprite looks transparent |
| `UnitMotionPort` | `CharacterBody3D.move_and_slide`, `CollisionShape3D`; optional `NavigationAgent3D.avoidance_enabled` | follows server-approved path, stops/replans when stuck; physics is a movement constraint, **not** the money/combat ledger | no transform teleport through colliders |
| `ViewportMapPort` | `Control`, custom `_draw`, `SubViewport` only when justified | minimap overlays from visible snapshot; terrain atlas separate from dynamic icons | no exposing hidden enemy units in production |
| `HUDPort` | `CanvasLayer`, `Control`, `Container`, `Theme`, `TextureProgressBar`, `RichTextLabel` | player resources, selection panel, orders and queues via snapshots/events | no React/Vite/Tauri, no monolithic hundreds-of-controls script |
| `UnitVisualPort` | existing `DirectionalSprite5` -> `Sprite3D` | five authored views mirrored to eight; render-only and unchanged by authoritative simulation | no duplicate FPS model/world |
| `AnimationPort` | `AnimationPlayer`, `AnimationTree`, `AnimatedSprite3D` where suitable | action/animation adapter to existing atlas; independent of state truth | no custom timeline interpreter |
| `BotBehaviorPort` | start with Godot nodes/signals/timers; evaluate State Charts / LimboAI | proposed actions go through same `CommandGateway`; fixed/seeded scheduling | no bot-only cheats, no LLM in simulation tick |
| `NetworkSessionPort` | `ENetMultiplayerPeer` + `MultiplayerAPI` + `@rpc`; selective `MultiplayerSpawner` and `MultiplayerSynchronizer` | native H-H loopback/LAN: **authoritative host**, validated commands, snapshots per permitted fog visibility | no custom UDP stack or naive blind property sync |
| `TestHarnessPort` | existing Godot `SceneTree` smoke tests; trial GUT `godot_4_7` | headless regression, per-capability fixtures, paired-seed bots; integration and UI acceptance separate | design YAML is NOT proof of tested code |
| `MapAuthoringPort` | `Resource`, `JSON`, `FastNoiseLite`, `MeshInstance3D`, `StaticBody3D` | offline canonical YAML→generated JSON/Resources with deterministic geometry hash; seeded decorative noise only | no runtime general YAML parser, no second terrain physics implementation |

### Navigation hard rule — one planner at a time

The first floating-64×64 RTS slice uses **Godot's `AStarGrid2D`** inside a thin 3D XZ adapter because cells, tree trunks, ponds, structures and bounds are explicitly authored. It is a reusable algorithm supplied by Godot, **not a homemade pathfinder**. On any dynamic placement/destruction, notify/invalidate affected grid cells and increment `nav_version`. Convert paths to ground `Vector3` waypoints using trusted terrain height. Only the server's legal path drives unit orders. The visual client may interpolate, but must not alter authoritative endpoints.

Future alternatives (NOT simultaneous contradictory planners):
- `NavigationRegion3D` / `NavigationServer3D` for ramps, bridges, complex surfaces and clearance.
- `NavigationAgent3D` for **local avoidance**, after benchmark and Godot 4.7.2 compatibility tests. Avoidance is **not** a replacement for connectivity/pathfinding, cannot reliably solve narrow crowded bottlenecks, and can be expensive. Recompute paths only when target or topology materially changes, not every frame.

Benchmark AStarGrid2D vs navigation mesh with 20/100 workers, tree trunk/pond chokepoints, map changes, and moving groups. Measure time-to-destination, stuck rate, collision violations, path query cost, performance and headless reproducibility. Migrate only after measurable advantage and completed regression suite.

### Multiplayer hard rule — native LAN first, web later

Godot's high-level multiplayer provides **ENet** on native targets. Implement an authoritative host and exactly two controller slots; a host-local human and remote human both issue **intent** and receive authorized results. Bot controllers use the same legal command envelope and fog constraints. Use Godot `MultiplayerSpawner` for replicated visual entities when useful and `MultiplayerSynchronizer` only for safe state/projections; neither replaces `CommandGateway` or fog filtering. Reject clients sending resource totals, HP, victory status, teleport positions or hidden target IDs. Add sequence/rate validation and bounded input decoding. Native ENet uses UDP; the Web export requires a separate supported transport adapter (WebSocket/WebRTC as feasible), **not a promise that raw ENet works in browsers**. Physics is not assumed cross-platform bit-for-bit deterministic; the host decides truth and clients reconcile to authoritative snapshots.

### HUD, shortcuts, bots and test modules

- Godot UI first: native `Control` scene tree, `Theme`, `Container`, responsive anchoring; small custom renderers only for faction-specific graphics. The debug minimap in PR #5 cannot ship with omniscient enemy icons; all HUD views consume filtered player snapshots.
- `InputMap` first. Consider **Keychain** once remappable controls appear in Options. A wrapper owns persistence and disables conflicting RTS/FPS action groups. Pin and test Keychain under Godot 4.7.2; do not enable blindly.
- Basic bot worker state can start with a few nodes/signals; for branching AI select **one** verified library: Godot State Charts (GDScript MIT, explicit Godot 4.7 fix) or LimboAI (C++ GDExtension, different web/platform support burden). Do not ship both engines or reimplement a generic BT framework.
- **GUT** (Godot 4.7 branch) is a strong candidate for more assertions, mocks, and CI JUnit. Existing native smoke scripts stay until migration demonstrates equal or better coverage.
- **rluders/rts-framework** is learning/reference only for now: its README explicitly says WIP/not production. Adapting one well-audited manager pattern is acceptable with correct license, not importing its entire GameState/command model.

## GitHub module lifecycle

1. `DISCOVER`: read repository, engine docs, at least one relevant GitHub source; open license and known issues. Review suitability versus standard Godot.
2. `PROPOSE`: record origin, maintainers/project (not guessed nationality), use case, Git tag **and immutable full commit**, SPDX license, code notice, version compatibility (Godot **4.7.2**), native/Web support, test plan, and removal plan in the module registry.
3. `QUARANTINE`: exact SHA/verified release archive, no online runtime updates, no blanket file/network access, inspect autoloads, editor plugin registration, native binaries and transitive deps.
4. `SPIKE`: isolated branch runs Godot import, headless tests, 1 real game integration scene, macOS native test and Windows/Linux/Web export checks wherever library is runtime-required.
5. `APPROVE`: change registry status to `approved_pinned` and pin/vendor under `apps/game/addons/` with original notices. Plugin updates via reviewed PR and tests only.
6. `WRAP`: adapter under `apps/game/scripts/adapters/`; contracts under `apps/game/scripts/core/`; game rules never import vendor classes directly outside adapter composition.
7. `MONITOR/REPLACE`: update advisories/bugs, compare maintenance delta; rollback by switching provider via the port, not rewriting gameplay.

**Agent PR checklist:** every change touching system behavior must state `Reused engine APIs`, `GitHub candidates reviewed`, `Chosen port + why`, `Dependency license + exact pin if any`, `Why original game code is needed`, `Tests actually run`, and `Scope DEC-033`. Review cannot be marked complete with empty boilerplate, a fake benchmark, or a self-reported engine test that was not executed.

## PR #5 / current source status

`feat/rts-astar-navigation-and-minimap` (PR #5) exists as a **draft**, with AStarGrid2D + selection + HUD/minimap spike. The `main` branch and initial test reports do **not** establish this draft as a shipped or passing feature. Do not drop its code, merge blindly or call its static minimap fog-safe. Inspect the branch/head and run `scripts/check.sh` and GUI selection/navigation trials before integrating. Scope overlap with MAN+ETH demo code does NOT expand DEC-033's first-release roster.

## Why not simply copy every GitHub solution?

Maintenance cost and correctness. Community code may use old APIs, declare the wrong engine version, ship binary GDExtensions without Web builds, rewrite authority rules, include broken licensing, or conflict with our existing `DirectionalSprite5`. Reuse is an **engineering constraint**, not an excuse for hidden complexity. Built-in Godot counts as upstream reuse. Game-specific rules and thin adapters are the only justified original code by default.

Sources are itemized with links and evidence notes in the companion research and machine-readable registry. The researched candidates are **not auto-installed** by this ADR.
