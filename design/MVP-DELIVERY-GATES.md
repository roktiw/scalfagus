# Scalfagus MVP 0.1 — Agent Delivery Gates and Definition of Done

Date: 2026-10-11
Status: **owner-confirmed product scope + proposed engineering execution gates, not completed features**.
Entry point: [root coding instructions](../AGENTS.md), [existing implementation breakdown](AGENT-MVP-IMPLEMENTATION.md), [machine task backlog](mvp-implementation-backlog.yaml).
World constitution: [DEC-030 world/platform](space-platform-world-contract-2026-10-11.md). Core game: [MAN/ETH roster](mvp-man-eth-catalog.yaml), [combat](mvp-combat.yaml), [economy](mvp-economy.yaml), [bot](mvp-bot-behavior.yaml), [Verdant Divide](mvp-verdant-divide-map.yaml).
Acceptance: [platform cases](battlefield-frame-acceptance.yaml), [gameplay cases](mvp-man-eth-acceptance.yaml), [victory cases](victory-defeat-acceptance-cases.yaml).

## Product-level target

**A local, fully playable, finishable Godot-native RTS match on ONE bounded floating space platform**. Two factions: MAN vs ETH. Five roles per faction: **HQ/mother, MIN worker, basic soldier, primary infrastructure (MAN UMU/ETH pylon), barracks**; existing Hero is an actor variant whose state persists across Overlord/Direct/FPS views. One finite SOLID→Matter harvesting chain; visible water/other liquid terrain on platform but no liquid/gas extraction. Actual trees give cover. One scripted bot runs the **same economy** as human. Default win: **all opponent's completed living building-class entities destroyed**, including a ground-mobile packed UMU. Battle stays on the top deck; there are no flying/swimming playable units in MVP.

The platform is a **mandatory Scalfagus universe object**: visual underside/rim, hard four-edge physics barrier, static cosmic background. Biomes and upper-deck materials vary by scenario, but ordinary flat planet-surface map framing is **not a supported choice**. In the initial map, show **brown soil, jungle, ponds, support structure and cosmic surroundings**, not a generic empty grid or fully metallic replacement.

## What exists vs what agents still need to implement

The repository currently includes **Godot native 3D Hero/camera/sprite-spike, menu and smoke tests**. A prior prototype or launcher may exist, but its presence does **not** imply real economy, bots, two-faction balance, map compiler, building production or final win flow are implemented.

For the delivered MVP, agents must create real in-engine behavior and executable tests. Every YAML specification is a **design input**, not an implemented engine capability.

## Fixed architecture and no-rewrite rules

- Runtime gameplay/world/camera authority: **Godot 4 native / GDScript**. Keep existing `apps/game/project.godot`, menu, scenes, Hero and 5-direction sprite renderer; don't rebuild from scratch.
- External TS/Node build-time script is acceptable to parse/validate YAML and emit normalized versioned JSON imported by Godot. The game does not need a new YAML interpreter runtime. Keep map ID, frame version, stable object IDs and seed in the exported artifact.
- **No second simulation engine, separate FPS game map, or new front-end framework required**. Tauri/desktop shell, if still present, is **optional tooling**, not a dependency for native Godot game running.
- All gameplay objects have stable team/owner, real 3D position, HP when damageable, and explicit tags: `victory_building`, `resource_form`, `inventory_custody`, `movement_domain`, `visible_to`.
- `world.topology: planar`, `battlefield_frame.variant: floating_space_platform`, hard bounded legal world, `surface_preset: brown_soil_jungle`. Reject every authored playable map missing the required frame (including a formerly permitted `bounded_planetary_surface` value).
- Every camera uses identical physical tree trunks, liquids, terrain height, hero, actual resource stacks, frame guard and victory state.
- Never pretend source **SOLID** means the permanent Matter currency mapping for all future maps. The 1:1 Matter output is explicitly an MVP recipe. Energy is a separate accounted stock with actual source/finite generation; Volatiles and liquid/gas extraction are disabled in this first map.

## Development gates

| Gate | Priority | Implement actual behavior | Test / acceptance |
|---|---|---|---|
| **G0 — Preserve existing spike** | P0 | Start existing Godot project, identify actual currently supported commands, keep menu / Hero stable / view switching and 5-view sprite renderer | Existing `apps/game/tests/smoke.gd`, menu smoke and project check; report tool availability/failures |
| **G1 — Compile universal platform world** | P0 | YAML map→validated deterministic runtime terrain; brown-soil jungle and cosmetic underside/rim; four-sided nav/physics guard; visible cosmic starfield/planet; real trees and freshwater ponds; fixed starts, rocks and ramps; no random gameplay terrain | FRAME-01..FRAME-12 + MAP cases + out-of-bounds spawn rejection; missing/wrong platform variant explicitly fails map compile |
| **G2 — Spawn five-role MAN/ETH templates** | P0 | Template registry and team ownership; HQ, 3 MIN, standard soldier, UMU/Pylon, barracks; no non-MVP combat class spam. Existing Hero state reused across cameras | MVP-01, -12, -23, -28 and spawn collision checks |
| **G3 — Actual solid resource loop** | P0 | MIN orders and pathfinding, pick up finite solids, carry and deliver, depleted deposits, MAN real depot/UMU packets, ETH Nexus conversion into counted typed Ether; energy bootstrap & finite accounting | MVP-03..06, -26..27, no remote free credits |
| **G4 — Infrastructure, construction & training** | P0 | MAN UMU generator warehouse/bunker/ground packed move with hybrid data/power cable and real crates, MAN builder caps 1→2→2; ETH single Nexus/pylon graph with finite capacity and energy/info/resource routes, beam builders caps 1→2→3; barracks soldier queues | MVP-12..14, -17..20; no bypass for disconnected Ether network |
| **G5 — Combat and win** | P0 | Rifleman/Sentinel attack units/buildings using line-of-fire blocked by tree trunks, soldier health/armor/range, garrison/turret prototype, no combat through water, explicit all-building win check | MVP-07..11, -16, -28; packed UMU remains defeat-relevant |
| **G6 — Scripted fair opponent** | P0 | A bot obeying fog, real resource flows, power, production and same unit costs; gather→infrastructure→barracks→army→attack and respond to deaths/stuck path | MVP-15, -32; headless local complete match |
| **G7 — Physical loot/recycling** | P1 (required for final MVP) | Amber SOLID loot as MAN cubes and ETH orbs, physical enemy pickup, MAN interrupted scaffold with stealable crates and mined ruins, ETH last-beam site ejection of all site-committed materials, finite loss-bearing completed-building salvage | MVP-20..22, LOOT scenarios, ledger uniqueness invariants |
| **G8 — Input, cameras and HUD** | P1 (required for final MVP) | RTS selection/multi-order, WASD move camera, Q/E rotate, wheel zoom, overview minimap, Matter/Energy/support counts, action panels, queues and match-end UI; one Hero actor across RTS/Direct/FPS | Existing smoke and MVP-23/-30/-31; camera change never duplicates Hero |
| **G9 — Release gate** | P1 | Playable MAN and ETH against scripted bot from menu to win/defeat/restart, no required online APIs, headless reproducible fixture log, reasonable frame budget, clear errors on invalid maps | MVP-01..32, FRAME-01..12, battle ledger hash, snapshot/replay; known tunable numbers documented |

The gate table indicates **expected complete functional work**; not every test exists as executable code yet. Keep YAML status `design_only` until an actual automated test runner verifies it. If prior G1 cannot pass because the current YAML authoring fixture has invalid paths or object overlaps, **fix authored geometry and add an assertion**, never silently warp gameplay.

## Strict priority P0 vs P1, to avoid blocking first match

- **P0:** spawn/commands; compulsory platform frame and collision; finite SOLID economy; two 5-role rosters; legal building and soldier production; combat with tree LOS; one fair basic bot; actual all-buildings victory. **This is the first complete game loop.**
- **P1 for complete MVP:** proper resource custody/loot recycling and interrupt rules; ETH inventory split; final Hero camera/HUD integration; headless regression, deterministic replay and frame polish.
- **Do not start now:** ORG playable race, aquatic/air units, 5+ building families, procedurally randomized strategic layouts, marine/air combat, destructible moving mother platform, orbital travel, multiplayer/server backend, active liquid/gas harvesting, second battlefield map or fully spherical true planetoid.

## Code work by responsibilities

Recommended boundaries (adapt to actual repo files; do not generate unused boilerplate just to fill names):

1. `MapCompiler`: strict `scalfagus_map_manifest` v0.3 validation + YAML→JSON + stable IDs + elevation/water/tree/start/source transforms.
2. `PlatformFrame`: required frame validator, visible rim/underside, zero-impact starfield, all-four-sides collision and map-bounds rejection.
3. `GameState`: fixed tick, ownership, event ordering, reliable entity IDs, resource packet custody ledger and win.
4. `Units`: orders, ground navigation, worker extraction, soldier/hero combat, valid movement/LOS and route refusal.
5. `Structures`: HQ/UMU/Pylon/barracks templates, construction workers, queues, upgrade mode invariants, no invisible magic depot.
6. `ETHNetwork` and `MANPowerCargo`: deliberately distinct routing with one ETH graph and three MAN logistical services.
7. `WorldDrops`: faction-origin packaging, physical packet collision/pickup, no double debit/refund, salvage.
8. `Bot`: finite, deterministic strategic script with player-equivalent commands; cannot know unseen locations.
9. `HUD` and camera/controller input adapters, retaining one Hero identity.

Author helper tests and fixture loaders near the corresponding implementation. For a headless map validator, verify both semantic invariants and **resolved walkable ground** for a large UMU footprint, because a route-polyline string by itself isn't proof of passability.

## Agent checklist for PR review

- **For every playable map**: required `floating_space_platform`, visually apparent boundary, physical barrier, legal internal ground, mixed surface palettes, noninteractive cosmic background.
- **For first map**: brown soil jungle, strategically useful trees, 3 routes validated, two fair spawns, real water ponds, only SOLID source mining, real terrain height/ramps.
- **For MAN**: UMU acts as power and warehouse/bunker, is ground-mobile, still tagged `victory_building` in packed mode; workers fetch real parts.
- **For ETH**: Nexus is only raw-to-Ether converter, one graph for Matter/Energy/info, Pylons are stationary and use actual finite node/edge cargo, interruption ejects site inputs exactly once.
- **For war and economy**: both factions train units and destroy each other's buildings; workers/Hero/loot don't prolong a defeated team; complete unit/structure destruction recycles with loss.
- **For reproducibility**: same seed + commands + fixed map and simulation version results in same authoritative outcome, regardless of cosmic backdrop decoration.
- **For reporting**: describe exactly which code files changed, which test commands actually passed/failed, and which design fixture remains unimplemented. No "done" on a heading-only document.

## Environment-canonical vs prototype-only choices

**Owner canonical:** all maps floating space platforms; first MVP square bounded, land-only, MAN+ETH, five roles each, solid-only resource harvesting, jungle trees as hard cover, liquid scenery and default building-elimination victory.

**Engineering proposals to tune by testing:** Verdant Divide 64×64 at 2 metres per tile, precise source placement, visible underside design, brown loam/metal ratio, exact generator inputs/rates, initial energy, individual HP and troop/barracks costs, bot strength and camera UI details. Sphere design remains historical research, not an approved runtime mode.

**Non-feature:** merely switching `battlefield_frame` in an unimplemented renderer will not make a platform appear. The delivery gate requires actual Godot mesh/colliders/visual tests and executable map load.
