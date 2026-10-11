# Scalfagus Godot-Native Implementation Contract — MVP 0.1

Date: 2026-10-11
Status: target module responsibilities and serialized interfaces for coding agents; **not an assertion any classes already exist**.
Runtime: Godot 4.7.2 Standard / typed GDScript / Compatibility renderer. Single game world, one native window and menu; **no Tauri**. Current source baseline is `apps/game/scripts/main.gd`, `hero.gd`, `directional_sprite_5.gd`, `menu.gd`, and `apps/game/tests/smoke.gd` / `menu_smoke.gd`.
Agent entry: [AGENTS](../AGENTS.md), [delivery stages](MVP-DELIVERY-GATES.md), [gameplay contract](mvp-gameplay-execution-contract.md), [candidate balance](mvp-balance-playtest-v0.1.yaml), [world/map](mvp-verdant-divide-map.yaml).

## A. Real current program vs expected MVP

Actual `main.gd` currently creates a **~50×50 undulating technical test mesh** by nested `range(-25,25)`; a single Hero actor is spawned near the center, a lander/tree/rock static proxy set is created, F1/F2/F3 view rotation is implemented, and the HUD is a diagnostic three-line Label. It has **no authoritative RTS GameState, ownership roster, world map compilation, unit selection, finite resource economy, production, enemy AI, building win check or physical platform rim/void environment**. `hero.gd` has a prototype identifier and dictionary inventory for smoke testing, **not** a transactional currency ledger. `scripts/check.sh` executes the existing camera/sprite/menu tests only (plus optional Node art checks).

Therefore, do not refactor `main.gd` into an independent new game and claim release based solely on unchanged smoke tests. Make **incremental Godot-native components** and retain the current camera/Sprite3D assets as a vertical proof under a reversible scenario/debug mode while the real match scene is wired.

## B. Minimum Godot scene graph and responsibilities (proposed)

```text
ScalfagusApp (Godot main menu, existing scenes/menu.tscn)
  MatchScene (Node3D; the sole authoritative game instance)
    GameSession (Node; FixedTick, command arbitration, authoritative GameState)
    World (Node3D; loaded terrain + tree collision + water + platform rim)
      SurfaceTerrain (MeshInstance3D + StaticBody3D)
      TerrainLiquidBodies (nonharvestable Area3D/StaticBody3D)
      FixedCoverTrunks (real movement/LOS collision)
      PlatformRimAndUnderside (visible meshes, neutral)
      OuterBoundaryGuards (four impassable physics walls)
      StarfieldBackdrop (noninteractive Environment/sky/mesh)
    Entities (Node3D; all real units + completed/unfinished buildings + source nodes)
    WorldDrops (Node3D; cubes/orbs, collision + pickup components)
    UnifiedPlayerCamera (Camera3D; F1/F2/F3 views, same actual Hero)
    NativeHUD (CanvasLayer/Controls; no second simulation)
    BotController (Node; issues same command API as human)
```

Nodes carry views and collider proxies. **One command/session authority** owns HP/damage/currency, not the individual Sprite3D or HUD Label. Existing Hero actor can become an adapter exposing entity ID/HP/cargo/positions from GameState; avoid mutating authoritative inventory in both Hero and GameState.

## C. Proposed typed GDScript modules

| Proposed file responsibility | Inputs | Outputs / invariant |
|---|---|---|
| `game_session.gd` | `FixedTick(t)`, `GameCommand` | Exactly one world, ordered events, final victory, replay snapshot |
| `entity_registry.gd` | Templates, stable IDs | Ownership, building-class tags, HP and indexes |
| `inventory_ledger.gd` | finite source/packet transfers | One custody per packet; no negative balances or duplicates |
| `map_loader.gd` | Versioned normalized map JSON exported from authored YAML | World geometry, stable authored IDs, spawn and map validation errors |
| `platform_frame.gd` | Required `floating_space_platform` style/biome | Visible rim/underside/space and matching no-exit bounds; not a victory building |
| `ground_navigation.gd` | Map resolved passability/ramps, footprint | Legal routes for MIN, soldier, Hero and large packed UMU |
| `worker_orders.gd` | Same accepted `GameCommand` | Harvest, haul, deliver, build, salvage with real entity work times |
| `structure_actor.gd` / `construction_site.gd` | builder assignment, 3-stage caps, resource packets | Committed Matter, progress, MAN pause vs ETH beam abort |
| `man_umu.gd` / `man_service_grid.gd` | modes, cable service, battery/cargo | Local power/data, no cable Matter teleport, victory building in travel |
| `eth_network.gd` | graph nodes/links/custody, network events | Nexus conversion, fixed bandwidth/escrow/equalization, split without cloning |
| `combat_system.gd` | positions, target visibility and LOS | Damage/cooldown once per tick and race-shared soldier profiles |
| `world_drop.gd` | source-lineage loot events, legal inside-grid location | Physical origin-shape/goods-color/quantity, no double refund |
| `rts_input_controller.gd` | RTS screen click/drag/keyboard, camera | Orders to single authoritative session; no direct currency mutation |
| `native_hud.gd` | Read-only current authoritative state | Correct resources/E, support, queues, action panels and win overlay |
| `scripted_bot.gd` | Fog-filtered observations, same command types | Paid gather/build/train/attack orders; no omniscient bypass |
| `replay_recorder.gd` | Map/profile hash, events and command log | Stable within pinned engine simulation, no visual frame influence |

Exact file names/classes are recommendations, not a reason to create 20 unused stubs. Implement the **smallest real end-to-end behavior** in PR order: frame→spawn→resource→build→combat→bot→salvage→HUD. Use typed GDScript and avoid circular `class_name` dependencies.

## D. Godot 4 action API and signals

Define a serializable `GameCommand` Dictionary or typed `RefCounted`/Resource that can become JSON for headless tests. Minimum fields:
- `tick_target` (int), `client_sequence` (int), `issuer_team_id` (int/string), `actor_ids` (list of stable IDs), `intent` (canonical verb), optional `target_entity_id`, `target_map_cell`, `template_id`, `mode_id`, `queue_index`.
- Serialized output `GameCommandResult`: `accepted` bool, `reason_code`, `queued_tick`, `resulting_event_ids`.
- `GameEvent`: `event_id`, `tick`, `kind`, `actor_id`, `owner/team`, `resource_id/form`, `quantity`, `source_custody`, `destination_custody`, `world_position`, `prior_HP/new_HP` as applicable. Every event requiring multiple inventory transfers must be atomic.

Possible GDScript signals `entity_spawned(id)`, `entity_removed(id, reason)`, `inventory_changed(custody_id, resource_id, before, after)`, `order_rejected(order_id, code)`, `network_partitioned(component_ids)`, `building_completed(id)`, `match_ended(result)`. Signals notify views, **do not duplicate authority** or credit a second resource account.

### Fixed-tick safety

For deterministic game economy and fixed production/attack cooldowns, store Energy in **milli-E integers** rather than floating accumulation, and use integer tick durations for mining, network latency and training. If a candidate seconds value is noninteger (MAN 1.90 s = 38 ticks, ETH 2.00 = 40, Pylon 0.5s edge latency = 10), explicitly round in one shared helper and snapshot the decision. Material quantities are integers; timestamps/ticks are integer. Quantize resource packet events and clamp world drop positions to legal grid before drawing sprites.

3D player collision/raycast still uses actual Godot physics; exact cross-hardware bitwise determinism is **not guaranteed** merely by fixed tick. Assert repeatability in the pinned Godot build and record tolerance/canonical serialized fields; never claim rollback-compatible deterministic multiplayer on the basis of local smoke.

## E. Map compile/load boundary

Godot need not understand YAML directly: use a **build-time** validator/converter to produce a normalized, versioned JSON map, ideally with stable content hash, accepted only if `world.topology=planar`, `battlefield_frame.variant=floating_space_platform`, legal 64x64 grid/map, object uniqueness and actual passable corridors. Build-time `Node` or `Python` helper may parse YAML, but **must specify/install the chosen parser**; avoid an imaginary built-in Godot YAML parser and do not silently strip YAML keys.

**Map rendering first-release assets:** primitive procedural underside slab and edge rim under the real brown-soil jungle, simple starfield/planet billboard as noninteractive backdrop, static water planes, tile-painted ground, existing trees and rock sprite assets, placeholder MAN/ETH buildings and soldiers. Preserve source art and known 5-view asymmetric sprites warnings. Verify from F1 overview and F3 eye-level that the entire upper surface is a platform, not a skybox color over endless procedural rolling ground.

## F. Stable IDs, naming and mode transitions

- Template IDs from `mvp-man-eth-catalog.yaml`, NOT `eth_mid_pylon` in older research: first MVP Pylon ID is `eth_pylon_obelisk`. Alias old historic IDs at parse/migration boundary only; don't have two distinct Pylon classes.
- The same `man_umu` entity ID / HP / victory flag remains through warehouse, bunker, 5-sec packing and ground drive/unpack.
- ETH Pylon ID / E balance, typed Matter, connections and victory flag remains through storage/meditating/turret changes.
- Hero ID/HP/position/cargo from the same actor persists across RTS→Direct→FPS→RTS, and Hero's weapon/dash obeys the central command/cooldown registry.
- Worksite IDs survive temporary MAN builder absence; ETH site can be destroyed/aborted with one loot event and no simultaneous remote refund. Assigned builder cap is by **progress thirds**, not a requirement for matching worker chassis size.

## G. Minimal test assemblies

1. Keep existing `apps/game/tests/smoke.gd` and `menu_smoke.gd` passing. Add a new **map smoke** that loads the real compiled map: platform rim/wall, brown soil, 2 spawn slots, ponds, cover and 1660 source units.
2. Add economy smoke running the same commands twice: mine 8 Matter, carry+deliver, convert at ETH Nexus, check one ledger owner before/after.
3. Add construction smoke: MAN one-builder scaffold persists, ETH last-beam abort ejects committed inputs once, build caps respected.
4. Add fight smoke: two soldiers and one tree, no through-trunk damage; legal soldier destroys real opposing Barracks.
5. Add victory smoke: packed MAN UMU protects from loss until destroyed; surviving Hero does not.
6. Add BOT smoke until match ending: legal gather, UMU/Pylon, Barracks, infantry, attacks. Save seed and replay hash.
7. Add camera/input smoke: RTS WASD pans view without Hero movement; F2/F3 controls same ID, no separate world.
8. Add **map validator negative** smoke: missing frame or `bounded_planetary_surface` is rejected; outside-platform spawn/loot and no navigable route are rejected.

Do **not** report the existing smoke suite as covering these proposed new tests; this document is a coding handoff only.

## H. Performance budgets for first true MVP

Candidate budgets, NOT measured:
- 64×64 fixed map = 4096 logical cells. Cache passability/height/collision, don't perform A* globally for all units every rendered frame.
- Aim for interactive ~60 FPS on intended Mac hardware **after measurement**; no fixed promise for all cross-platform exports.
- Sample simulation at 20 Hz; hundreds of inert cosmetic grass blades must not have physics bodies.
- Max 10 authored large tree trunks and a few dozen decorative instances at first, plus 10 finite surface deposits; dynamically expand based on FPS.
- Coalesce nearby world-drop icons/stack visuals but **preserve underlying packet source lineage and custody** in authoritative game state.
- Avoid graph-wide ETH equalization on every draw frame; run after node/link change or bounded periodic resource scheduler.

## I. Do NOT grow the game while fixing the engine

Not in this MVP: sea or flight gameplay, ORG units, true spheres, shifting orbital decks, interplanetary ship steering, fourth currency, complex fluid simulation, research trees, many advanced soldier classes, full region control, SaaS LLM bot, multiplayer networking or new packaging launcher. These are not prerequisites for completing a real two-faction match on a floating platform.
