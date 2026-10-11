# Scalfagus — HISTORICAL Coding Agent Handoff: MAN vs ETH, Verdant Divide

> **Current release scope reconciliation — DEC-033 (2026-10-11):** Historical/full two-faction PR00-PR10 plan, superseded as immediate release scope. Current Godot agent should work through DEC-033 MAN mirror M0-00..09 and micro-only economics/network/acceptance.
>
> **CURRENT owner-approved executable release: [DEC-033](decisions.yaml), [MAN mirror scope](mvp0-man-mirror-rts-2026-10-11.md), [active numerical profile](mvp0-man-mirror-balance-v0.1.yaml), [Godot execution rules](mvp0-man-mirror-execution-contract.md), [Godot ENet authority](mvp0-man-mirror-network.yaml), [M0 backlog](mvp0-man-mirror-backlog.yaml), [M0 acceptance](mvp0-man-mirror-acceptance.yaml).**


**DEC-033 NOTICE:** The first playable MVP is now **MAN-vs-MAN, Overlord RTS only**, with two player slots H-H LAN/loopback, H-C and C-C, four MAN templates and a small Matter economy. This earlier MAN+ETH handoff and three-camera PR-09 are **post-MVP reference** rather than active coding tasks. Follow [current release spec](mvp0-man-mirror-rts-2026-10-11.md), [YAML](mvp0-man-mirror-rts.yaml), [backlog](mvp0-man-mirror-backlog.yaml), [acceptance](mvp0-man-mirror-acceptance.yaml), and [DEC-033](decisions.yaml). The older three-camera technical spike stays preserved for regression only. Also see DEC-031 (future Overlord+FPP only).

Date: 2026-10-11
Status: **implementation tasking / documentation, not a claim that code is complete or tests have passed**.
Owner-directed scope: **2 races MAN and ETH; 5 base roles each; only surface SOLID resource harvesting; jungle ground-only map with real liquid terrain; all-building victory. DEC-030: EVERY playable map is a floating space platform with variable soil, metal, rock or other surface material.**
**Latest delivery gates:** [MVP-DELIVERY-GATES.md](MVP-DELIVERY-GATES.md); [universal space-platform constitution](space-platform-world-contract-2026-10-11.md); [mandatory frame](battlefield-frames.yaml); [surface palettes](platform-surface-presets.yaml).
**Current world:** EVERY playable map is a floating platform in OUTER SPACE (DEC-030). MVP game topology remains **PLANAR**, with an impassable four-sided border, mandatory visible rim and underside, and noninteractive space background. The first flying platform carries Earthlike brown soil and jungle. A normal planetary surface is NOT a legal play map, even if an earlier art comparison suggests otherwise. The deck is static during the match and real spherical planets are NOT implemented.
Detailed index: [MVP contract](mvp-man-eth-jungle-vertical-slice-2026-10-11.md), [world/map design](world-environments-and-map-authoring-2026-10-11.md), [planet alternative](planetary-map-topology-2026-10-11.md).

## 0. Repository reality — do NOT regenerate or overwrite functioning work

As currently observed on GitHub `main`:
- `apps/game/project.godot`: **Godot 4.7.2 Standard / GDScript**, Compatibility renderer, 3D terrain and real collision. Already has one Hero actor and F1 Overlord, F2 Direct/TPP, F3 FPS viewpoints.
- `apps/game/scripts/main.gd`, `hero.gd`, `directional_sprite_5.gd`: scene/render camera/actor spike. It is **not yet a complete playable RTS**; no real economy, bot, buildings, production or combat loop.
- `apps/game/assets/`: existing MAN worker and neutral tree/rock 5-view sprite concept/reference assets, with some unresolved asymmetric mirroring quality.
- `apps/game/tests/smoke.gd`: existing headless import and smoke checks: Hero ID/HP remains stable across F1/F2/F3, 5 source view to 8 rotated sectors/mirroring. **Preserve** this test.
- **Godot-only** current architecture. Godot owns the built-in main menu, native game window, 3D world, UI and cameras; there is no Tauri desktop launcher. Node/TypeScript is optional OFFLINE authoring tooling only.
- `scripts/bootstrap.sh`, `scripts/check.sh`, `scripts/dev.sh`, `scripts/game.sh`, `scripts/build.sh`, `readme.md`: Godot-only bootstrap, test, run and export paths. Follow these; do not add a desktop launcher.
- `architecture/adr-0001-one-authoritative-game-world.md` and the old desktop-shell ADR are historical design records. The current `readme.md`, `apps/game/project.godot` and Bash scripts describe the actual Godot-only game. **Do not reintroduce Tauri/Rust/WebView or an extra native window.**

Recommended environment checks **after agent changes** (from repo root, prerequisites installed):
```sh
bash scripts/check.sh
bash scripts/dev.sh
```
Individual native headless test after verified Godot import:
```sh
godot --headless --path apps/game --editor --import --quit
godot --headless --path apps/game --script res://tests/smoke.gd
```
Do not announce successful tests unless actually executed on a supported environment; macOS bootstrap is currently the supported verified path. Windows/Linux game export validation is a later task.

## 1. Source-of-truth precedence and approval boundaries

1. **Owner decisions** in [decisions.yaml](decisions.yaml) DEC-001 and DEC-015/016 and DEC-021 through DEC-027. In particular DEC-024 default win: all **completed building-class** entities eliminated, including packed/moving MAN UMU. DEC-026: environmental affinities MAN earth, ETH air, ORG water, but land-only gameplay for 0.1.
2. This latest **scope** + [5-role catalog](mvp-man-eth-catalog.yaml), [MVP combat](mvp-combat.yaml), [MVP economy](mvp-economy.yaml), [AI](mvp-bot-behavior.yaml), [map](mvp-verdant-divide-map.yaml), [map schema](map-authoring-format-v0.1.yaml), [environment](world-environments.yaml), [world topologies](world-topologies.yaml).
3. [Current network truth](three-network-channels-and-destruction.yaml): **ETH one** Ether network for typed resources/Energy/data after Nexus conversion; **MAN three** systems (UMU, physical cargo, hybrid conductive power+optical data links); **ORG two** systems but is **not playable yet**.
4. [Construction caps](construction-phases.yaml): MAN 1→2→2; ETH 1→2→3; stages mean max simultaneous eligible contributors, not forced minimum staffing.
5. [Current loot](world-loot-and-recycling.yaml) and [victory building registry](victory-building-template-registry.yaml). MAN drops cubes, ETH drops orbs; SOLIDS amber, future LIQUID cyan, GAS violet; cross-faction pickup legal.
6. **Proposal-only numbers** in `mvp-*` data and design documents are initial test fixtures. Use them for a reproducible prototype but do not mark them approved competitive balance. Any mismatch between provisional old `design/resources.yaml` / `design/economy.yaml` crystal/gas/resin IDs and current Matter/Volatiles/Energy must be resolved **via the MVP-specific compatibility data**, not invented irreversible global migration.

**Newest content wins only when marked as owner-approved and specifically superseding older rules.** Do not silently delete prior documentation or original sprite pipelines; record migration issues for unresolved differences.

## 2. Smallest playable entity roster — no uncontrolled asset explosion

Exactly five roles per faction:

| Role | MAN ID / provisional name | ETH ID / provisional name |
|---|---|---|
| Mother / HQ | `man_command_core` / Command Core | `eth_nexus` / Nexus |
| MIN worker | `man_min` / SCV | `eth_min` / Courier/Channeler |
| Basic soldier | `man_rifleman` / Rifleman | `eth_sentinel` / Sentinel |
| Infrastructure / Farm | `man_umu` / Universal Man Unit | `eth_pylon_obelisk` / Pylon/Obelisk |
| Barracks | `man_barracks` / Barracks | `eth_manifestation_chamber` / Manifestation Chamber |

Classes: each team starts 1 mother (building-class), 3 MIN, 1 optional Hero **tagged soldier variant** (one stable actor in all cameras), 0 standard soldiers, 0 completed infrastructure, 0 barracks. Preserve one production queue on mother for workers; one barracks queue for soldiers. No sixth art-template hero until the common soldier actor works.

MAN UMU is physically moveable over ground and must **still count for victory during travel**. It can be deployed generator+warehouse **or** generator+bunker (costed mode switch), with no generation when packed. ETH Pylon is fixed in MVP, can store/relay or become a turret after meditation, **not a separate obelisk farm plus pylon**.

## 3. Headless simulation contracts and implementation boundaries

**Never build separate 2D RTS and 3D FPS worlds.** Existing Godot `Node3D` / real colliders / existing Hero entity are the shared authority.

Authoritative new components/classes (proposed GDScript files; exact names flexible if consistent):
- `GameState.gd`: fixed tick, stable entity IDs, team ownership, game phase, event queue, resource ledger, victory check, replay snapshot hash.
- `BattlefieldFrameRenderer.gd` / `WorldBoundary.gd` (proposed): implement the **mandatory platform frame on ALL playable maps**. Render noninteractive soil/metal/rock upper surface, visible rim and underside and starfield; enforce impassable four-sided physics and navmesh borders for all units, Hero and packed UMU. Reject missing frame or forbidden `bounded_planetary_surface` map variant. No building/loot outside bounds; neutral platform NEVER counts toward victory. Validate surface skin swap without implicit physics/resource changes.
- `MapManifestLoader.gd`: accepts validated compiled JSON or parse YAML through **TypeScript build tool**; Godot runtime need not implement a YAML parser. Build-time YAML→canonical JSON is recommended. Pin compiler schema version.
- `WorldTopology.gd`: currently **planar-only** wrapper for tile->world, local up, legal neighbors, LOS/travel; throw explicit unsupported error if requested `spherical`. Do not implement globe by drawing a sphere beneath flat physics.
- `ResourceSource.gd` and `ResourceLedger.gd`: finite solid deposits; source debit, worker carried cargo, MAN physical storage or ETH Nexus conversion; exactly one custody owner for each packet.
- `WorldDrop.gd`: world items, shape by origin (cube/orb initially; reserve ORG tetrahedron), color by form, amount and stable ID; legal cross-faction pickup and deterministic drop merging.
- `UnitActor.gd` / `WorkerOrders.gd`: movement, gather, real haul, build/repair/salvage, combat authority and camera control lease arbitration; reuse original Hero actor when possible.
- `StructureActor.gd` / `ConstructionSite.gd`: building-class flag persistent across pack/mode, health, production, work progress, race-specific three-stage caps and death salvage.
- `ManUMU.gd` / `HybridCableGrid.gd`: ground mode state, real local power/data and physical material stores (electric cable **never** carries Matter).
- `EtherNetwork.gd`: one graph, Nexus real intake/conversion, typed finite per-pylon balances, packet edge escrow, routing and component partition, reduced relay service when turret.
- `CombatSystem.gd` and `BotController.gd`: finite basic attack/LOS, no omniscient scouting, valid paid build/raid commands.
- `RTSSelectionHUD.gd`: select, multiple-unit order, basic training, Matter, Energy, support cap, status, warnings and mode buttons.

These are **suggested responsibilities** not a forced architecture or proof that existing Godot scripts implement them. Keep a minimal number of clean files and thin UI/controller layers; nontrivial game rules live in testable pure/stateful simulation modules.

**One authoritative event order** proposed:
1. Validate player/bot commands by known game state and fog; reserve costs.
2. Advance movement, extraction, finite cargo transfers and transfers-in-edge escrow.
3. Resolve fixed-rate Energy generation/consumption, support power and network modes.
4. Advance valid construction, production and legal ETH materialization.
5. Resolve weapons, hitboxes, damage, structure destruction and associated loot events.
6. Rebuild affected network components, settle interruption and drops exactly once.
7. Check victory after all completed entity transfers/deaths at tick end.
8. Record ledger/event/replay hash. Render/UI read resulting state; they do not mutate the ledger directly.

If dependency demands another order, document it and prove with deterministic acceptance tests, especially *last ETH beam death vs onsite material ejection vs pylon rupture*, and *packed UMU classification*. No two systems may both credit the same resource packet or salvage event.

## 4. Authored map compiler and asset scope

Current target: [Verdant Divide 64×64](mvp-verdant-divide-map.yaml), proposed 2 metres/tile, Earthlike exotic jungle. Must **contain real terrain water** (nonharvestable, impassable without future water capability), height patches, legal ramps, tree-trunk hard cover with canopy visual fade, 2 spawn slots and multiple reachable solid Matter deposits. *Only SOLID surface deposits are mineable*; do not add liquid/gas extraction yet.

**Existing `apps/game/scripts/main.gd` procedurally creates a tiny undulating test terrain**, not this authored 64×64 map. Do not confuse current visual with map-loader acceptance. Replace/hide spike terrain only behind a reversible scene/mode selection once map compiler succeeds and smoke remains green.

Map compiler should:
- Read manifest + possible future PNG sidecars.
- Materialize semantic tiles, heightfield, ramps, liquid obstacles and stable colliders.
- Validate tree/trunk collisions and multiple ground paths **including a packed UMU footprint**; report failing IDs instead of silently moving water/trunks.
- Preserve spawn/resource parity, finite deposits, and no random critical-collision modification.
- Seed cosmetic grass/ferns without affecting game outcome.
- Compile deterministic map data & hash; replay stores `map_id`, `version`, `topology`, `seed`, `schema`, `resolved_hash`.

**DEC-030 universal platform requirement:** every playable map is a finite floating platform in space, and first map is bounded PLANAR jungle above a visible underside and space background. The planet/starfield cannot act as world terrain or resource source. Every map must have a flying-platform frame; swapping cosmetic **upper-surface material presets** (jungle brown earth vs patchwork metal) must leave strategy unchanged unless semantic terrain/cover objects explicitly change. See `FRAME-01`–`FRAME-12` fixture tests.

**Important:** The authored first YAML map contains *route intent hints*, not guaranteed navigable roads. The game/validator must detect and report any blockers, unreachable nodes or invalid ramp joins. The sample source-stock sum must be checked from nodes, not trusted from a handwritten total.

## 5. Timeline expressed as implementable, independently testable changes

| Order | Pull request / vertical-slice task | Files/components / measurable DONE |
|---|---|---|
| **PR-00** | Preserve existing Godot-native menu/game/camera spike | `bash scripts/check.sh` imports Godot and exercises `apps/game/tests/smoke.gd` and menu smoke; record actual passed and blocked checks |
| **PR-01** | Compile mandatory floating-platform map and hard boundaries | YAML→JSON using map manifest v0.3, reject missing/nonplatform frame, author brown-soil jungle deck, real water, fixed trees, ramps and source IDs, draw visible rim/underside/stars, guard all four sides and pass `FRAME-01`–`FRAME-12` plus map fixtures |
| **PR-02** | Actor template registry and basic orders | Spawn MAN/ETH mother, 3 MIN, Hero; selection, Move, Stop; building-class tags and counters |
| **PR-03** | SOLID harvest and deterministic economy | Source depletion, worker cargo, real MAN depot, ETH Nexus deposit/conversion, Matter ledger and end-state replay |
| **PR-04** | MAN basic playable loop | UMU packed/deployed, local hybrid cable, MAN scaffold, real crate supply, barracks + Rifleman, energy support |
| **PR-05** | ETH basic playable loop | Nexus, fixed Pylon, one Ether graph, inventory equalization, blue-beam construction, barracks + Sentinel, site interruption as orb drops |
| **PR-06** | Combat and victory | Soldier attacks units/buildings, genuine tree LOS, HP, turret/bunker bounds, zero enemy buildings win including moving UMU |
| **PR-07** | First economy-safe bot | Scripted fair fog-aware bot can gather, build, train, raid and lose/win in a full 1v1 against either faction |
| **PR-08** | Loot, logistics disruption and replay | MAN crates + excavation, ETH site orbs and pylon rupture escrow, rival pickup, physical transport and conservation audit |
| **PR-09** | Three-camera Hero & UI finishing | Same Hero actor across RTS, Direct and FPS, no alternate world; HUD, production, minimap, selected actions, match end and restart |
| **PR-10** | Release regression and performance gate | Headless suite and current smoke, readable sprites at RTS/FPS, pinned build and local reproducible 1v1; no false balance certification |

Each PR must add direct tests, document candidate parameter changes, and preserve existing sprite orientation smoke. Do not use the word "implemented" or "test passed" in commit summaries without actually checking. A build that merely parses YAML but never validates routes/ledger is not complete.

## 6. Automated contract/fixture tests to implement

Translate [32 MVP test fixtures](mvp-man-eth-acceptance.yaml) plus the existing [victory fixture](victory-defeat-acceptance-cases.yaml), [network tests](recycling-and-network-acceptance-cases.yaml) and [loot/energy tests](network-mechanics-acceptance-cases.yaml) into real Godot headless tests, wherever possible.

Minimum fail-fast invariants:
- No resource can simultaneously be held by a source, worker, depot, Ether node, in-flight edge escrow, worksite and world drop.
- ETH network split does not clone balances; its last build beam interruption **materializes site-committed inputs as local orbs once**, not a silent remote refund.
- MAN stores and transports actual crates; a powered cable never transfers Matter. UMU switching packed/travel does not evade victory.
- One unit moves on actual dry ground, not through tree trunks or pond water. One projectile has the same LOS collision in any camera perspective.
- Worker builds only with legal labor caps (MAN 1-2-2, ETH 1-2-3), valid materials/Energy and available support.
- Bot obeys fog and resource limits; does not originate a liquid/gas resource out of water scenery.
- Lose only after **all** genuine living completed enemy building-class entities die, including mobile structural units.
- Spherical topography request yields a clear **unsupported** error while there is no spherical engine adapter. No fake globe support.

## 7. Backlog cut line / don't implement yet

Not in first MAN vs ETH release: moving the entire space platform, orbital travel and management, falling off or flying beyond the battlefield edge, ORG playable, ORG mitochondria/veins, liquid mining or pumps, gas collectors, aerial/naval combat, many soldiers or advanced tech tiers, complete destructible forest, marketplace, multiplayer server, AI-LLM agent runtime, detailed weather seasons, realistic fluid physics, custom authoring GUI, procedural **strategic** multiplayer map generator, fully functioning actual spherical planet, alternate Heartstrike scenario.

Keep future interfaces data-defined where cheap but don't implement unapproved physics. Explicitly preserve the product's future natural domains MAN Earth, ETH Air, ORG Water.

## 8. Known risks and implementation questions that should not block starter code

- Working names `Command Core`, `Rifleman`, `Sentinel`, `Manifestation Chamber` and all provisional cost/HP values are placeholders, not locked canon.
- The current map YAML terrain corridors may fail geometric clearance; validator must measure, not trust the route text or guessed resource-stock total.
- Exact Energy generator input mechanism and usage rates, Pylon per-link bandwidth, UMU Bunker tradeoff, Hero ability and production prices remain playtest candidates. Implement as tunable data with complete ledger, not fabricated numbers presented as approved.
- Future topology: provide `planar` runtime with an explicit discriminated map type and an early `spherical` unsupported guard. Don't tie every physics function to planar X/Z in ways that require complete rewrite.
- ADR-0002 describes historical launcher consideration. Current Godot-only `readme.md` is authoritative; do not implement/revive Tauri.
- Preserve the established 5-view/mirrored sprite renderer and existing test; do not substitute a second 2D world just to simplify map combat.
