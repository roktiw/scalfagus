# Scalfagus MVP 0.1 — Executable Gameplay Contract for a Godot Coding Agent

Date: 2026-10-11
Status: **implementation interpretation with playtest candidate values**, not a claim of completed code or proven competitive balance.
Scope: **MAN vs ETH on a single mandatory floating space platform, with five templates per faction, three cameras and physical finite resources**.
Canonical owner decisions: [DEC-001, DEC-016, DEC-018–019, DEC-021–027, DEC-030](decisions.yaml).
One source of **actual provisional numerical tuning**: [mvp-balance-playtest-v0.1.yaml](mvp-balance-playtest-v0.1.yaml). Existing `mvp-economy.yaml`, `mvp-combat.yaml` and `mvp-man-eth-catalog.yaml` remain semantic definitions and historical prototype hypotheses where their numbers disagree. **Do not sum or mix different profiles.**
Dependencies: [world](space-platform-world-contract-2026-10-11.md), [map](mvp-verdant-divide-map.yaml), [network](mvp-network-execution.yaml), [HUD](mvp-hud-and-input.yaml), [bot](mvp-bot-behavior.yaml), [victory](victory-building-template-registry.yaml), [balance tests](mvp-balance-acceptance.yaml).

## 1. Start and win conditions

A local match selects HUMAN = `man` or `eth`, BOT = the other faction, with factions assignable to NW/SE authored slots. A map is a 64×64 candidate bounded top deck of a gigantic **floating space platform** with genuine tree-trunk cover, fresh ponds and finite SOLID source nodes. All gameplay is confined to the deck; underside/space/distant planet have **no entity IDs, currency or HP**.

Each player starts with **one completed HQ, three MIN workers, one Hero variant**; initial Matter 0, Energy 40 held in real mother inventory and base support capacity 8, usage 5. The Hero is an actor, not a separate sixth production template. Its death ends Direct/FPS possession only, not the match.

Win at **end of simulation tick** when enemy has no alive *completed* structural entities tagged `victory_building`. All mother/HQ, barracks, ETH Pylon, MAN UMU in every mode are building class; incomplete scaffolds, Hero, other soldiers, workers, cables, world loot and neutral platform are not. Simultaneous zero-building losses produce an explicit draw candidate. Do not end because no remaining surface resources, or when a Nexus dies but distant pylon survives.

**Winning requires buildings to be destroyed**, not all ordinary units. There is no forced match time limit in this profile.

## 2. Five-role templates, exact IDs and responsibilities

| Role | MAN template | ETH template | Interface |
|---|---|---|---|
| Mother/HQ | `man_command_core` | `eth_nexus` | Real cargo/input, small Energy generation, MIN production, team identity, support 8 |
| MIN worker | `man_min` | `eth_min` | Walk/gather, carry at most 8 Matter, deliver, initiate/help build, real loot/salvage |
| Basic infantry | `man_rifleman` | `eth_sentinel` | Ground, 85 HP, range 6, 9 damage/1.2 seconds, basic building attack |
| Infrastructure/farm | `man_umu` | `eth_pylon_obelisk` | MAN: move/warehouse/generator or garrison; ETH: node/storage/support or turret |
| Barracks | `man_barracks` | `eth_manifestation_chamber` | One paid FIFO soldier queue each |

**Mode tradeoffs:** MAN UMU has mutually exclusive `deployed_warehouse` (+8 supply, generator 0.4 E/s, open Matter ports), `deployed_bunker` (+8 supply, generator 0.2 E/s, 2 physical soldiers can garrison, warehouse ports closed), `packed_travel` (slow 0.8 tiles/s, support +0, generation 0, ports closed, retained cargo but cannot withdraw until re-deploy). In ALL modes the UMU remains a completed `victory_building`. No bunker turret without real garrisoned soldiers.

ETH Pylon is stationary. In `storage_relay`, full finite freight service and Matter inventory, information+Energy+support +8. A 5-second, 2-E meditation switches to `turret`; the same building keeps its network and +8 support, but only 50% freight bandwidth and no outside local courier input. It has a simple 4-tile, 8-damage, 2s-cooldown Energy-powered turret. It never generates Energy by itself and must receive/hold stored actual Energy; no unlimited fortification.

All names and exact numeric costs/stats in the YAML balance profile are first-pass candidate values, not newly owner-approved faction mechanics.

## 3. Ownership, resource identity and physical custody

**Never conflate three axes:**
1. Physical world-source FORM `solid`, `liquid`, `gas`. MVP: only scattered surface SOLID chunks/deadwood are collectible.
2. Economic type `matter`, `volatiles`, `energy`. MVP conversion recipe specifically produces `matter` from one unit of SOLID stock; Energy is independently metered from an explicit ambient/solar source; Volatiles disabled.
3. Package **origin silhouette**: MAN cube, ETH orb, future ORG tetrahedron. Color by source form: solid amber `#E8AF42`, liquid cyan, gas violet. A foreign worker can collect legal physical packages without first changing the icon.

Every packet has a stable ID, immutable resource ID and quantity, physical form, source lineage, custody compartment, team/controller and a single authoritative owner location. Currency stock is **NOT** global omnipresent gold. Valid custody buckets include `deposit`, `worker_bag`, `depot`, `eth_nexus_typed`, `eth_pylon_typed`, `eth_edge_escrow`, `site_loose`, `site_committed`, `structure_embodied`, `world_drop`, `ruin_embedded`, `spent/lost`. All transfers are **atomic debit and credit**, create uniquely numbered events, preserve nonnegative ledgers, and cannot credit the same packet twice.

A MIN harvests SOLIDS at the legal source even without a Mine; cargo fills to capacity 8. Work amount is limited by real mining timer and extraction slots. Drop at a compatible physical HQ/UMU intake to credit MAN depot; ETH physical raw cargo must reach **Nexus intake** and be **converted there** into typed Ether held on the Nexus before any Pylon transfer. ETH "Ether" is not a fourth spending currency; typed Matter stays Matter.

**No liquid resource income from visible water.** Do not spontaneously create Matter from living trees (those are stable cover) or infinite Matter from ambience.

## 4. Finite Energy without a mandatory global Energy grid

Energy is a real stored/spent resource `energy` in milli-E fixed point. For early playtest, the only legitimate *external* source is ambient/solar intake: starter MAN command core and ETH Nexus each yield **0.20 E/s** into their finite local inventory; deployed MAN UMU yields 0.40 E/s warehouse or 0.20 E/s bunker. These are explicit externally metered generators and **not free per-frame global credits**. ETH Pylons **relay and hold** Energy but do not produce it.

Building/training pays real E from an eligible local producer/component, as stated in `mvp-balance-playtest-v0.1.yaml`. The initial 40 E reserve already exceeds first UMU/Pylon (5 E), Barracks (8 E) and 3 soldiers (6 E). First solid extraction and worker walking require no Energy, so no circular gas/liquid prerequisite. Future operating fuel/tech can change in later tiers.

MAN one short-range hybrid cable comprises two logical services, **power conductor and optical data**. It **never transports Matter**. No user-drawn cable spaghetti is necessary in the first slice; nearby eligible deployed ports auto-connect up to candidate 10 tiles with a visible service overlay. A remote UMU can form its own functioning independent component; a broken/packed link removes upstream conducted power but does not kill all workers. Energy held in batteries persists locally.

ETH has one single resonance graph carrying typed actual Matter cargo, Energy, blueprint/information and support over Pylon relays. A node or link never instantaneously turns physically stored stock into a universal pool; each edge has rate/latency and packet escrow.

## 5. Construction, interruption, production

All 3-stage constructions have stage limits for **parallel contributing workers**, not mandatory quorum:
- MAN **1 → 2 → 2**.
- ETH **1 → 2 → 3**.
- Future ORG **3 → 2 → 1** (not part of MVP).

Single eligible worker can always make progress with valid materials/power; the extra contributors speed only the stages where allowed. Stage paid Matter allocation for integer recipe `C`: stage `k` takes `floor(C*k/3) - floor(C*(k-1)/3)` (k=1,2,3). This sums to `C` for every integer `C`, including 40, 60, 150. A constructor reserves **actual local items**; game never constructs from remotely available but physically unreachable material.

**MAN:** assign builder(s) to valid site; real Matter from bag, local HQ/UMU port, or queued worker trips. Uninstalled delivery crates remain **loose and stealable**; installed ingredients stay embedded in an incomplete scaffold. Removing all active workers **pauses at same completion**, not instant refund. Ruin excavation by a legal worker consumes time and returns fractional Matter determined by the tuning profile. Packing/redeploying the UMU costs actual time, disconnects local service, retains its owned physical contents.

**ETH:** MIN goes into stationary NETWORK/build mode and forms a visible blue beam to an eligible Nexus or same reachable **single** Pylon backbone that leads to a live authorized Nexus. The site must be supplied with physically **delivered converted Ether** via that network, at finite bandwidth and receiver capacity. If one of three finishing workers leaves but another valid beam remains, construction continues more slowly. If the **last valid required beam/path disappears** (or a player cancels), progress instantly resets and **100% of material already committed in site custody** becomes physical, collectible ETH orbs at that exact world site **once**; consumed channeling Energy and elapsed time are not refunded. Remote inventory that never arrived stays where it really was; edge escrow undergoes the link-break packet policy, **not site duplication**. The changed meaning of raw-vs-converted packages is explicit: ejected ETH orbs are physical again and need worker transport to Nexus before reentering Ether graph.

Training workers at HQ and soldiers at Barracks follows one paid FIFO queue, real Energy and valid support capacity. Costs are reserved at actual start, finished actor is spawned on an eligible free ground cell; if spawn blocked, production finishes but queues the actor until a safe cell opens, with no double payment or clipping outside platform. Queue cancellation before actor spawned returns unspent Matter to **the same actual depot/node**, never as both world drop and account refund, while the upfront paid Energy is consumed (candidate). Worker deaths lose carried goods to world drops according to the packet policy.

## 6. Network partition and shutoff

`mvp-network-execution.yaml` defines numerical candidate bandwidths, link length and event policy. On ETH link cut, physically retained inventory stays at each Pylon/Nexus, with no simultaneous retroactive rebalance: new component quantities are exact sums of original held local node stocks. In-flight edge packets are either delivered before a cut according to tick order or **moved once into a real world-orb escrow spill**, partly lost in the explicit packet-damage account. The same packet may not also be returned to sender or credited to the receiver.

Equalization is **eventual**, capacity-weighted, low-priority routing with actual hop events after existing site/production reservations, not an instantaneous pool. Node-death may spill actual local stock with fraction loss, but cutting a healthy link **does not** dump stored inventories of the surviving nodes. An isolated expansion can construct with genuinely reachable local stock and cached blueprint only when still connected to a valid authorized local Nexus/beam; do not fabricate a replacement Nexus.

MAN cable cut affects its local power/data service, not physical crates. Physical packet delivery routes remain from real worker inventory/UMU depots and paths, including detours around water/trees.

## 7. Combat, fog, Hero and the world

A soldier has initially 85 HP / 0 armor / 9 raw damage per 1.2s / range 6 tiles; basic MAN and ETH infantry deliberately share this combat baseline to isolate their logistics difference. Soldier attacks may damage enemy completed buildings; structures have 1–2 armor and documented HP. Flat armor reduces per-shot damage, minimum 1, with one fixed authoritative hit application. Explicit LOS raycast blocks shots through actual tree trunks, rigid buildings and raised ground; canopy fading is purely visual, **not an override** of LOS. Water and outside-platform space are impassable to every initial unit and the Hero. If target becomes invisible, stop specific-target auto-fire; moving to last seen point as Attack Move is legal but does not regain target knowledge magically.

ETH Pylon turret fires only in real turret mode, with available E, valid target and LOS. MAN bunker shoots through **its actual garrisoned unit(s)**, without extra ghost cannons.

F1 Overlord RTS, F2 Direct TPP, F3 Hero FPS are **different inputs/cameras on the SAME game actor IDs** and one 3D simulation. No duplicate Hero. In F1, WASD pans camera and doesn't move Hero; F2/F3 moves Hero. Attack/projectile/loot action in FPS still invokes the same authoritative validation used by Overlord RTS. Prototype Hero ability `dash` has a cooldown and collides with actual trees, walls, water and the map rim; never teleports through invalid terrain. When Hero dies, Direct/FPS ends and RTS remains operational until actual building loss.

The platform frame is neutral geometry; it cannot be mined, selected or won/lost. A distant giant planet is a noninteractive background, never a full gameplay spherical world.

## 8. Fixed-tick event ordering (mandatory to avoid double refunds)

One **proposed deterministic ordering** within 20 Hz game ticks; agent must implement one documented order and use tests for all corner cases:

1. Advance simulation tick `t`; collect input/bot commands, sort by `t, team_id, command_sequence`, validate ownership, visibility and legal target.
2. Settle *previously completed* movement and loads/deliveries; extraction source debit→worker custody; factory/supply/reservation existence validated.
3. Apply bounded environmental E generation, finite local Energy delivery and one component/channel allocation; reject any resulting negative balance.
4. Move one step of actual workers/ground units and in-flight Ether edge packets (only where nav/capacity exists); compute completed source → edge → destination packet events atomically.
5. Process legal construction labor, staged item installment (site custody), production queues, paid mode switches and spawn backlog.
6. Process target acquisition using fog and ray LOS; execute weapons in fixed order, apply damage and death/cargo losses exactly once.
7. Apply structure/node/edge death effects; recompute graph; process ETH interruption orbs and MAN ruins and deposits; ensure pending deliveries cannot complete through destroyed links.
8. Check all **completed** building-class entity counts for victory/draw; if match ended lock new production/costs and record end-state.
9. Write deterministic event delta, ledger-account checksum, telemetry and save/replay snapshot (never HUD-dependent).

For a simultaneous kill, actions in the same tick are resolved before victory. Tie only if both have zero completed building-class entities after end-of-tick application.

## 9. Data types, serializable commands and error states

Required serializable authoritative state per entity: `entity_id, template_id, faction_id, team_id, owner_id, grid_position, world_position, facing, HP, max_HP, movement_domain, mode, construction_stage, construction_progress_work_units, victory_building, support_cost_or_supply, physical_inventory_ids, E_milli, powered_connected_component_id, fog_visible_to, target_id`. Not every entity needs every field; NULL/absent explicitly where not applicable. Stable IDs and event IDs in replay.

At minimum, typed validated command intent IDs:
- `move, attack_target, attack_move, stop, hold_position, gather_solid, return_cargo, pick_up_drop, start_build, assign_build, cancel_build, queue_unit, cancel_queue, pack_umu, deploy_umu, set_umu_mode, set_pylon_mode, garrison, ungarrison, excavate_ruin, repair, hero_dash, surrender`.
- Command arguments: actor IDs, target world cell/entity, template, optional queue index, player/team/sequence/tick and predictable error code.
- Returns accepted/rejected with explicit reason `not_owned, not_visible, unreachable, blocked_by_water, out_of_bounds, source_depleted, insufficient_local_matter, insufficient_local_energy, full_inventory, not_connected, support_cap, wrong_mode, occupied_builder, no_authorized_nexus, invalid_build_site, target_dead, game_over`.
- RTS mouse, Direct/FPS possession and scripted bot all submit **the same command protocol**, though some modes hide unsuitable verbs.

No actor can stand outside the platform. A losing team cannot save itself by queuing a new scaffold after its last completed building was killed at the same tick.

## 10. Candidate balance acceptance, not magic equality

Numerical values live in [the profile](mvp-balance-playtest-v0.1.yaml), with scenario thresholds and economic microtests in [balance acceptance](mvp-balance-acceptance.yaml). Both infantry share first-pass DPS so later win differences mostly reflect acquisition, delivery, construction, network security, bunker/turret and map. **No fair win rate or 25–40min typical duration can be inferred from static files**; only full scripted/random-seed matches + human playtests answer it.

Avoid setting ETH's better gas/energy identities into the first solid-only map as an unexplained combat stat boost or without normal physical arrival. In this first map, MAN's modest direct solid mining advantage is compensated experimentally by ETH's compact network routing and distinct pylon defensive option; this may or may not be enough, and is measured.

## 11. Definition of "agent-ready" versus code-complete

**Agent-ready** means owner constraints and all potentially blocking implementation choices have a written default rule or an explicit fail-closed stub/feature gate, source-of-truth precedence is defined, references resolve, and each feature has data/test IDs. **Code-complete** means GDScript, Godot scene, UI, real map compiler and headless tests run, and actual 1v1 produces valid victory/replay; none of this follows automatically from a YAML specification.

In case of conflicts: [Owner decisions](decisions.yaml) → [fixed accepted semantics this document](mvp-gameplay-execution-contract.md) → [single numeric candidate profile](mvp-balance-playtest-v0.1.yaml) → [specific system data and acceptance fixtures](mvp-network-execution.yaml) / [MVP game tests](mvp-man-eth-acceptance.yaml) → older broad full-faction YAML and research; never allow an old `crystals/gas/resin` or MAN-only MVP draft to override the two-faction solid-only profile.
