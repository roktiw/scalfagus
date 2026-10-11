# Godot modules and libraries for Scalfagus MVP

## Runtime baseline

Godot 4.7.2 Standard with typed GDScript is the only runtime. The MVP is one authoritative 3D world with three camera fantasies: Overlord RTS, Direct/TPP and FPS possession. No second simulation, Tauri shell or WebView is used.

## Installed dependencies

| Module/library | Revision | Use in Scalfagus | Boundary |
|---|---|---|---|
| [RTS Framework](https://github.com/rluders/rts-framework) | `b366628f02f18199db6077d3beff2b606df3c40b` | Candidate reusable patterns for selectable entities, commands, construction, queues, damage, resources, state machines and manager boundaries. | WIP upstream; do not replace the authoritative Scalfagus entity/state model blindly. Adopt components one at a time behind local tests. |
| [Keychain](https://github.com/Orama-Interactive/Keychain) | `5e13f4c5d1e2c67c2d14c97a1cf5f8bbe0737d6b` | Player remapping and shortcut profiles for the Godot Options screen. Start with camera, selection, move order, possession and fire actions. | Godot 4 plugin; enable only after the existing Input Map is registered. Keep gameplay command validation outside the plugin. |
| Godot `NavigationAgent3D` + `NavigationServer3D` | built into Godot 4.7.2 | Future continuous 3D path following for units on the floating platform, local avoidance and navigation-region queries where grid navigation is insufficient. | Engine API, no third-party install. The first bounded 64×64 MVP may use deterministic `AStarGrid2D`; NavigationAgent3D must share the same walkability/collision authority. |
| Pixel UI Free | intentionally omitted | None. | Do not install or use it. Build the MVP HUD with native Godot `Control` nodes and the authored Scalfagus pixel assets. |

## Mapping to MVP systems

- `apps/game/scripts/main.gd`: world assembly, cameras, input contexts, platform frame and scene-level orchestration.
- `apps/game/scripts/hero.gd`: one actor identity shared by RTS/TPP/FPS; movement and possession state.
- `apps/game/scripts/grid_navigator.gd` from the RTS slice: deterministic 64×64 path planning around blocked cells, water and solid obstacles. It is the first MVP navigation authority.
- RTS Framework `SelectionManager` patterns: drag/shift selection and ownership filtering. Use only after matching Scalfagus `entity_id`, faction and completed-building victory rules.
- RTS Framework `CommandManager` patterns: legal move/attack/build commands. Commands must enter the Scalfagus validation boundary before mutating simulation state.
- RTS Framework `StateMachine` patterns: worker, soldier, construction and combat states. State transitions remain fixed-tick and testable in headless Godot.
- RTS Framework entity components: candidate adapters for `Selectable`, `Damageable`, `Collectable` and `Queue`; do not let addon components own resources or victory state.
- Keychain: Options menu remapping and persisted profiles only. It must emit named Godot actions consumed by the same input-context layer as keyboard defaults.
- `NavigationServer3D`/`NavigationAgent3D`: later navigation adapter for terrain regions, ramps and local avoidance. It does not replace the map compiler’s solid/liquid/wall validation.
- Native Godot `Control`: minimap, command card, resource bar, selection rectangle and possession HUD. Pixel UI Free is excluded.

## Adoption order

1. Merge and verify the RTS slice and its headless navigation/selection tests.
2. Keep deterministic grid navigation for the first 64×64 Verdant Divide match.
3. Add Keychain to the Options screen after named Input Map actions exist; add a smoke test that remapping does not bypass command validation.
4. Wrap RTS Framework components with Scalfagus adapters only where they reduce duplicate code and preserve the one-world contract.
5. Prototype a NavigationAgent3D adapter on a small platform region, compare paths against the grid oracle, then decide whether it belongs in MVP.

## PR #5 decision

PR [#5](https://github.com/roktiw/scalfagus/pull/5) was still open and aligned with the current MVP: it adds RTS camera/selection/commands, deterministic grid navigation around obstacles, the minimap, floating-platform frame behavior and headless RTS/navigation smoke tests. It was merged into `main` after local verification. The merged slice is the current foundation for the RTS module; it does not claim that economy, combat, bot behavior or the full MAN/ETH match are complete.

Local post-merge results:

- `SCALFAGUS_SMOKE_PASS`
- `SCALFAGUS_MENU_PASS`
- `SCALFAGUS_RTS_SMOKE_PASS`
- `SCALFAGUS_NAV_SMOKE_PASS`
- `SCALFAGUS_GODOT_CHECK_PASS`

Godot 4.7.2 still reports `ObjectDB/RID` allocations on headless shutdown. The assertions pass; cleanup should be a separate task.
