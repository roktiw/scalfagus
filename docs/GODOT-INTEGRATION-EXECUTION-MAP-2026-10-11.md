# Godot integration execution map — 2026-10-11

## Authoritative scope
Use **DEC-033 MVP0 MAN-vs-MAN Overlord RTS (H-H, H-C, C-C)** as the active development scope. MAN-vs-ETH, full possession cameras and faction asymmetry are subsequent milestones, despite older documents referring to them as MVP. All arenas are bounded **floating platforms in space** (DEC-030), not planetary spheres. Single native Godot 4.7.2 Standard GDScript runtime; no Tauri, Pixel UI Free, or second GameState.

## Installed versus connected
Files are already present in `apps/game/addons/rts_framework/` and `apps/game/addons/keychain/` on main, including MIT license files. Presence is NOT proof the editor plugin is enabled or that the components are used in live gameplay. Built-in `NavigationAgent3D` and `NavigationServer3D` require no installation. The repository documentation claims a local headless Godot validation of the PR #5 slice; this guide does not independently rerun it.

## Provider -> adapter -> game ownership

| Capability / gate | Existing provider | Scalfagus wrapper / consumer | Never delegate |
|---|---|---|---|
| Camera and 3 modes / M0-02, later possession | `Camera3D`, `InputMap`, RTS Framework camera references | `RTSCameraController` and `PlayerIntentAdapter` | Hero identity and authority |
| Click/box/Shift selection / M0-02 | `PhysicsDirectSpaceState3D`, `PhysicsRayQueryParameters3D`, RTS Framework `SelectionManager`, `SelectableComponent` | `SelectionPort` | Ownership, fog and faction filtering |
| RMB move/build/attack / M0-02–04 | RTS Framework `CommandManager`, Godot signals | `CommandGateway` | Cost, cooldown, tick ordering, validation |
| Pathfinding / M0-02 | `AStarGrid2D` and existing `grid_navigator.gd` | `NavigationPort` | 64x64 2m blocked-cell map, edge bounds, deterministic navigation version |
| 3D movement / M0-02 | `CharacterBody3D`, `StaticBody3D`, `CollisionShape3D` | `UnitMotionPort` | Unit orders, traversability rules |
| Uneven terrain, ramps, crowds / benchmark | `NavigationRegion3D`, `NavigationServer3D`, `NavigationAgent3D`, `NavigationObstacle3D` | Alternate `NavigationPort` and `UnitMotionPort` provider | Simultaneously running conflicting path planners; deterministic gameplay oracle |
| Resource pickup / M0-02 | RTS Framework `CollectableComponent`, Godot `Resource` | `MatterLedger`, worker cargo adapter | Finite resources, custody, delivery and conservation |
| Construction and queues / M0-03 | RTS Framework construction/queue components, `PackedScene` | `ProductionPort` | One-time costs, legal sites, spawn positions, building class |
| Combat / M0-04 | RTS Framework attack/damage/projectile components, `Area3D`, raycasts | `CombatPort` | LOS, attack permissions, HP, winner determination |
| Unit states and bot / M0-05 | RTS Framework state-machine patterns, Godot signals | `BotBehaviorPort` | Fair bot observation and same command API as humans |
| RTS UI/minimap / M0-08 | Godot `Control`, `CanvasLayer`, `Theme`, existing `rts_minimap.gd`; optional RTS Framework minimap reference | `HUDPort`, `ViewportMapPort` | Visibility filtering: debug minimap currently leaks enemy buildings |
| Remappable shortcuts / M0-08 | **vendored Keychain**, `InputMap`, `ConfigFile` | `InputBindingPort` | Logical action IDs, input contexts, conflict policy, command validation |
| LAN H-H / M0-07 | `ENetMultiplayerPeer`, `MultiplayerAPI`, RPC | `NetworkSessionPort` | Host authority and anti-cheat input checks |
| Fixed-tick sim & replays / M0-01, M0-06 | `SceneTree`, `_physics_process`, signals | `MatchSimulation` | GameState, stable IDs, seeded replay and victory |
| Headless tests / M0-09 | Existing `apps/game/tests/*_smoke.gd` | `TestHarnessPort` | Acceptance evidence and cross-platform export checks |
| Map + sprite / M0-01 | `MeshInstance3D`, physics, `Sprite3D`, `AnimationPlayer` | `MapAuthoringPort`, `DirectionalSprite5` | Canonical YAML geometry, floating frame, physical bounds |

## Integration sequence
1. Treat current main as the integration baseline. Do not merge legacy draft PR #1 or stale/diverged PR #5 blindly: PR #5 changes already appear in main, and the PR metadata still reports conflict/draft. Compare patch hunks before closing or rebasing.
2. Run `bash scripts/check.sh` under the **actual** Godot 4.7.2 binary. Separate engine import, automated smoke, GUI click/drag/RMB, runtime export, and CI statuses in evidence. Do not mark queued or failing CI green.
3. Pin and audit the already-vendored RTS Framework and Keychain revisions and licenses. Fix `architecture/godot-third-party-candidates.yaml` registry's stale `installed_in_project: false` entries; never silently replace vendor code.
4. Start with selection and legal command adapters. Each feature must prove preservation of `entity_id`, ownership checks, fog checks and fixed-tick logic.
5. Use current `AStarGrid2D` for deterministic planar 64x64 MVP0 movement. Spike `NavigationAgent3D` on a *separate test scene*, compare route legality, clearance, blocked-goal fallback, dynamic obstacle invalidation and performance at 20/100 units; do not swap MVP authority until benchmarks pass.
6. Bind Keychain to named actions in Options; persist profiles, test collisions/restarts and GUI focus. Default bindings must work without a saved profile.
7. Adopt RTS Framework components one-by-one (selection, command, collectable, queue, attack) only when a smoke test demonstrates actual wiring; otherwise retain a wrapper around native Godot.
8. Ship MVP0 complete loop: HQ -> finite Matter -> worker carries -> barracks -> riflemen -> cover/LOS combat -> last enemy building destroyed; fair bot, H-H/H-C/C-C, fog-safe minimap, result UI, replay hash and packaging follow the backlog gates.

## Guardrails
- **No Pixel UI Free**. Native Godot `Control` only.
- **No unvetted add-on network downloads** at game runtime.
- Exactly one authoritative state and resource ledger; third-party RTS components are replaceable providers, not the source of truth.
- Visibility filtering precedes minimap drawing, picking and enemy-target commands.
- `NavigationServer3D` is built-in; not a downloaded package and not by itself a mandate to replace the working grid adapter.
- Do not claim a feature installed-and-working purely because it is checked into `addons/`.
