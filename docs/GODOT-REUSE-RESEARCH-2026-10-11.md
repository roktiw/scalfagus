# Research: Godot 4.7.2 reusable facilities and vetted GitHub candidates

Research date: 2026-10-11. Audience: all Scalfagus coding agents. Sources below are **upstream docs/repos checked during research**, NOT locally installed software or evidence of runtime compatibility. Latest project canon is **DEC-033: MAN–MAN, RTS-only MVP 0.1**.

## Executive finding

Almost every *general-purpose technical mechanism* sought by the owner has an existing Godot node/class/service. The proposed `AStarGrid2D` approach in draft PR #5 **already reuses native C++ pathfinding**; the project should only author a map-grid/3D adapter, cell-occupancy updates and gameplay-specific movement rules. Replacing it with a self-written A* or a full WIP third-party RTS framework is not an improvement. Godot's 3D navigation and avoidance are a later measured alternative, not a magic crowd/path solution.

## Evidence table

| Area | Verified available upstream | Decision for Scalfagus |
|---|---|---|
| Input | Godot `InputEvent`/`InputMap` actions, runtime reconfiguration and built-in `_unhandled_input` | Bind `rts_pan_left/right/up/down`, `rts_orbit_left/right`, selection, context. Do not scatter raw keycodes |
| HUD | `Control` nodes, containers, `Theme`, progress bars, popups and focus system | Native Godot UI; wrap filtered game snapshots in HUD presenters |
| Picking | `World3D.direct_space_state`, `PhysicsDirectSpaceState3D.intersect_ray` | Raycast existing world colliders for click; screen projection + rectangle for box selection |
| Navigation (grid) | `AStarGrid2D`, built-in configurable diagonal modes, solid cells, paths | First-choice deterministic-ish 64×64 static-grid planner for floating platform; `DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES` is a no-corner-cutting option |
| Navigation (3D) | `NavigationAgent3D`, `NavigationServer3D`, `NavigationRegion3D` | Compare later for ramps / complex geometry, not both planners as sources of truth |
| Avoidance | `NavigationAgent3D` avoidance, `NavigationObstacle3D` | Useful for moving units, but not global path search; official docs warn crowded/narrow environments can block agents |
| Physics | `CharacterBody3D`, `StaticBody3D`, `CollisionShape3D`; Jolt built-in for *new* Godot 4.6+ projects | Preserve current project engine setting; measure any physics backend migration (simulation remains host-authoritative) |
| Networking | `ENetMultiplayerPeer`, `MultiplayerAPI`, RPC, `MultiplayerSpawner`, `MultiplayerSynchronizer` | Native two-client LAN; server validates all commands; avoid hand-made UDP stack or blindly exposing hidden replicated entities |
| Rendering/art | `Sprite3D`, `AnimationPlayer`, `AnimationTree`, `SubViewport` | Preserve existing `DirectionalSprite5`, wrap rather than rewrite five-angle sector maths |
| Terrain | `FastNoiseLite`, `MeshInstance3D`, `Resource`, `JSON` | Deterministic compiled gameplay map + optional seeded cosmetic noise; offline YAML compiler only |

### External candidates

| GitHub project | Evidence | Integration decision |
|---|---|---|
| [Orama-Interactive/Keychain](https://github.com/Orama-Interactive/Keychain) | MIT; addon supports remapping keyboard/mouse/gamepad, profiles, groups, save/load; source last updated to Godot 4.6.1 Feb 2026 | **Candidate** for advanced Controls menu; not needed to make WASD/QE work. Verify 4.7.2 and Web first |
| [derkork/godot-statecharts](https://github.com/derkork/godot-statecharts) | MIT; release **v0.22.5** (2026-06-25) expressly fixed Godot 4.7 type hint compatibility; builtin visual statecharts/debugger | **Preferred optional** bot/unit FSM if logic exceeds simple typed states; not authoritative economy |
| [bitwes/Gut](https://github.com/bitwes/Gut) | MIT; repo explicitly identifies `godot_4_7` branch and 9.7.1 for Godot 4.7.x | **Candidate early adoption** for test assertions, mocking and CI; keep existing native smoke tests |
| [limbonaut/limboai](https://github.com/limbonaut/limboai) | MIT code; v1.8.1, prebuilt GDExtension for Godot 4.6+ and alternate 4.7.2 engine build | **Reserve** for truly complex behavior trees; GDExtension binary artifacts and Web target require major compatibility/security review |
| [rluders/rts-framework](https://github.com/rluders/rts-framework) | MIT; component selection and command managers; explicitly marked **WIP / not intended for production** | **Reference only**. Learn patterns; do not replace existing GameState/commands with this package |

### Public primary-source links

- Godot UI building blocks: https://docs.godotengine.org/en/stable/tutorials/ui/index.html
- Godot physics ray queries: https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
- Godot AStarGrid2D API: https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html
- Godot 3D navigation/avoidance: https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html
- Navigation obstacle constraints: https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationobstacles.html
- Navigation performance warnings: https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html
- Godot Input Events / InputMap: https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
- High-level multiplayer and server-authority caveat: https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
- Godot 4.6 physics default change (Jolt for newly created projects): https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.6.html
- Installing and enabling plugins: https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html
- Keychain: https://github.com/Orama-Interactive/Keychain
- Godot State Charts change log: https://github.com/derkork/godot-statecharts/blob/main/CHANGES.md
- GUT version matrix: https://github.com/bitwes/Gut/blob/main/README.md
- LimboAI supported versions: https://github.com/limbonaut/limboai/blob/master/README.md
- RTS Framework WIP warning: https://github.com/rluders/rts-framework

## Integration priorities for DEC-033

1. **P0: no external runtime addon**. Wrap `InputMap`, `Camera3D`, physics queries, Control HUD, `AStarGrid2D`, `CharacterBody3D`. Build canonical command validation and finite Matter ledger (the latter *is* original Scalfagus domain logic).
2. **P1: tests**. Trial GUT in separate branch, compare with existing headless smoke coverage. Only integrate pinned Godot-4.7-compatible version after success.
3. **P2: bot states**. Trial Godot State Charts v0.22.5 behind `BotBehaviorPort`; reject if it adds more complexity than fixed legal bot actions.
4. **P2: remappable keys**. Trial Keychain only when Controls screen needs collision detection/profiles; native InputMap works now.
5. **P3: crowd/terrain benchmark**. Built-in `NavigationAgent3D` avoidance / 3D navmesh versus existing grid path, not a homegrown solver.
6. **Do not integrate** full rluders RTS framework or LimboAI GDExtension in the first release without a deliberately scoped, measurable proof and platform review.

## Provenance/licensing and security warning

MIT status is based on the upstream project metadata and README/license as reviewed; individual demo art may be licensed differently. Pin commits in the machine registry; do not claim author residence/nationality or software supply-chain safety from `github.com` alone. Do not install a plugin until 4.7.2 tests, code/extension review, license notice, platforms and rollback are proven. Never make tests green by bypassing errors or disabling real command validation.

## Validation status / branch reality

Research checked upstream docs, public GitHub metadata, tags/branches and source README. **No third-party addon was downloaded or enabled in Scalfagus by this research.** No local macOS/Windows/Linux/Web runtime or export was executed here. At the time of drafting, PR #5 is a **draft** and not part of `main`; its AStarGrid2D spike is a reference to inspect/test before merge. `Godot 4.7.2` source availability is not proof that all modules work on all targets.
