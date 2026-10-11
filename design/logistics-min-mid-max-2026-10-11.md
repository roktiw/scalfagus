# Scalfagus — Economic MIN / MID / MAX: Harvest, Convey, Relay

Date: 2026-10-11  
Status: **owner-directed logistics and defensive transformations**, with ETH MID architecture and numerical parameters explicitly **proposed**.  
**Newest role and base-canon precedence:** [base ecologies (DEC-012/013)](base-ecologies-and-expansion-2026-10-11.md), [base ecologies YAML](base-ecologies.yaml). This document contains previous candidate roles; below they are aligned with the updated owner canon.
References: [canonical faction logistics](faction-logistics-2026-10-11.md), [3×3 config](logistics-unit-scales.yaml), [transformation policy](deployment.yaml), [faction config](faction-logistics.yaml), [worker roster](unit-domains-and-archetypes.yaml).

## A single economy, three ways of thinking

The starting worker of **every faction is a MIN that can harvest and carry cargo home alone**. Once the economy grows, the three factions diverge in their *physical* handling of resources:

1. **ORG — Gather / Move / Carry (hunter–gatherer):** living, mobile gatherers and cargo animals circulate freely. More size buys larger loads at the cost of slower walking/flying and slower personal mining. Their cargo carriers can optionally move smaller **living units as passengers** or trade cargo capacity for basic defense/combat. The player manages migration routes, extraction parties, moving cargo mothers and escort/interception.
2. **MAN — Convey / Build / Fortify (industrial):** modular ground conveyors and depots generate rapid, continuous flows through physical infrastructure. The same specialized economic assets can *switch modes* to become defensive walls and staffed bunkers, surrendering the corresponding throughput while fortified. The player designs factories, traffic, bypasses, terrain control and evacuation.
3. **ETH — Relay / Buffer / Endure (network):** small independent couriers hand physical cargo to intermediate relays and large stationary storage pylons. Nodes are strategically valuable. A pylon may **retain all stored inventory** while meditating into a combat turret, but **cannot accept or dispatch cargo during meditation or while in turret mode** (see state policy below). The player decides whether to maintain a functioning supply network or defend the core to survive into late game.

These names describe **logistics behavior**, not mandatory manual clicks: routine ordered collection, carrying and handoffs can be autonomous in the medium-automation RTS system. The human or explicitly authorized strategic AI chooses route architecture, investment and mode changes.

## The 3×3 economic worker and transporter matrix

| Faction | MIN: independent | MID: intermediate | MAX: economic anchor |
|---|---|---|---|
| **ORG / Organites** | Small fast **worker**, mines, carries, **buds L1** at live connected vessel tips. May scout/fend for itself if specialized. | **Mid-size harvester** with multiple slots, slow mining/carriage, **buds L2** at live vessel tips when growth-equipped; can load MAX. | **Huge flying mother transporter** with many resource slots; source/home feeding loops, specialist L3 buds only along a connected living vessel. **Baseline: stop to receive/dispatch one item per worker handoff, one worker at a time. Moving handoffs unlock in mid game; extra ports unlock in late game.** May transport compatible living troops/workers in passenger bays and optionally defend itself at a real cargo/speed/cost tradeoff. |
| **MAN / Manusians** | **SCV-like ground miner, builder and repairer**; independently hauls and feeds conveyor input, repairs eligible units and buildings. | **Tracked relay / conveyor** length 3 or 5 tiles, finite buffers. In **one-person bunker** mode carries one soldier; in **Sentry Wall** mode flips to an outward barrier and ejects packets safely, disabling conveyor flow. | Very slow **ground-only mobile warehouse** with slots. **Depot mode:** collect, distribute and store. **Bunker mode:** explicitly deploy, **eject stored resource packages into legal nearby cells** and become a garrisonable bunker for soldiers. No flying. |
| **ETH / Etherans** | Small independent extractor/courier; construction **NETWORK mode** occupies worker and visibly beams blue Energy to nearest eligible large node for the whole build. | **Stationary MID pylon**: finite storage/relay OR defensive turret via time-costed meditation; retains cargo but seals intake/output during meditation/turret. | **Nexus-class MAX immediately**, local stock, knowledge cache and large construction-support node, not the former oversized turret pylon. |

**Naming scope:** ORG/MAN/ETH are the stable machine IDs; Organites/Manusians/Etherans are the canonical mid names of the peoples, *not* unit size MID. Names like Relay Conductor, Sentry Wall and Bunker are descriptive working labels, not approved fiction names. This table refines *economic worker/transport variants only*; military unit archetypes retain separate role definitions.

## DEC-011 — ORG baseline bandwidth and mode constraints (owner-approved)

These rules override any legacy suggestion that ORG has free in-motion transfers at the start.

- A basic **MIN worker transfers only one resource item/portion per completed handoff** to/from ORG **MID or MAX**. One item is not an entire compartment or full cargo inventory; repeated transfers take finite time.
- Each unupgraded ORG **MID and MAX has one active transfer port**. Only one worker can be served at a time, whether loading or unloading; others wait. A worker likewise performs only one transfer at a time.
- **Many cargo slots increase total carrying capacity, not loading bandwidth.** Port count and handling rate must be tracked separately; upgrades in later eras can raise parallelism.
- Before research, the ORG mother has exactly **one active mode**: `MOVE` (travel/carry but do not transfer), `RECEIVE` (hover and load, one item/worker at a time), `DISPATCH` (hover and unload, one item/worker at a time), or `EXTRACT` (stationary self-mining, only if equipped).
- A base-level mother can automatically perform a loop of `MOVE → RECEIVE → MOVE → DISPATCH`, but it **holds position at each handoff**. It need not land. State switching, worker queues, finite distance and slot validation apply.
- **Mid-game biological upgrade (proposed):** allow movement **plus either RECEIVE or DISPATCH** as a combined authorized operating state; **still one handoff port and one item per completed worker transfer**, never receive and dispatch at once with that one port. Self-extraction cannot overlap.
- **Late-game biological upgrade (proposed):** add costly loading/unloading organs for a limited number of **simultaneous worker handoffs** and possibly separate intake/output while moving. Each worker's transaction remains finite. Number of ports, cost, throughput budget and constraints need playtesting. Self-extraction overlap remains separately gated, not presumed.
- Damaged mothers, mode changes, disconnected workers and canceled transfers reconcile inventory atomically; no duplication, phantom deliveries, infinite transfer rate, or zero-time handoff.

**Balance rationale:** the most mobile faction must pay with loading dwell time and sequential handling. This keeps early hunter–gatherer logistics distinct from MAN continuous conveyors and ETH distributed relays. Mid/late upgrades earn improved concurrency through research/resource investment rather than granting free throughput from minute one.

**Acceptance tests:** `ORG-PORT-01` two workers requesting one MID/MAX port queue; `ORG-MODE-02` no moving transfer without research; `ORG-MODE-03` all four basic modes are mutually exclusive; `ORG-MIDTECH-04` movement plus one handoff after research still uses one port; `ORG-LATETECH-05` multiple ports remain finitely capped; `ORG-ECO-06` benchmark ORG early/mid/late with port occupancy, handling delay and opportunity cost versus MAN and ETH.

## ORG: an intentionally simple organic size tree

For economic workers **MIN → MID → MAX**:
- **Cargo capacity and compartment count increase** with scale.
- **Personal extraction rate and movement speed decrease** with scale. MAX is airborne; this measures speed within the legal movement domain and does not imply a ground path.
- All MIN can extract and carry. MID can harvest and load/unload in several slots. The MAX's *primary* purpose is bulk transport, not mining; any MAX self-extraction is an optional specialist fitting that remains slower than MIN/MID, never a prerequisite.
- The mother follows deposit rendezvous → base rendezvous → return. **Initially it holds position to load/unload without landing**. Researched mid-game organs permit a moving mother to receive OR dispatch, still via a single port; researched late-game organs may add more ports.
- Some **specialized** transport organisms can also **transport smaller units as passengers**. Passenger manifest/size, boarding/exiting, attackability, and survival after carrier loss need explicit rules. **Cargo slots and passenger berths must be counted separately or compete for a single finite mass budget**; units are not free extra cargo.
- Limited self-defense / armed carrier variants are **proposed**. Combat organs cost biomass/resources/module budget and must reduce available transport capability or increase vulnerability/upkeep. Mobile cargo assets must not outperform dedicated fighters by default.
- Counterplay: intercept the mother (anti-air), raid the loading workers, cut safe pickup zones. ORG's strengths are resilience through redeployment and independent gathering, not a safe indestructible airborne warehouse.

### ORG player choices
Fast scattered MIN collectors versus fewer MID harvesters; a single economical large cargo loop versus redundant escorted mothers; cargo capacity versus passenger transport or escort capability. Losing the mother may strand workers but never delete/deposit cargo invisibly.

## MAN: the infrastructure itself becomes a defensive line

**MIN — Miner/hauler:** obtains Matter/Volatiles/Energy according to extractor equipment, then hand-carries a small finite amount to base or a belt input. Even with every belt destroyed a MIN can still work if the path is traversable.

**MID — Repositionable conveyor (3 or 5 tiles):**
- **Conveyor mode (normal):** connect real input/output endpoints. Fixed spatial length and orientation; finite speed and packet/buffer slots; moving the MID unlinks the segment. Junction topology, splitters, queueing and backpressure remain physical.
- **Sentry Wall mode (alternate):** issue a deliberate mode-switch. First disconnect/stop accepting new belt loads; finish/abort reserved transfers safely; **eject the currently carried packages on the protected/behind-the-wall side**, into *finite free ground cells or an explicitly reachable receiving depot* (not immediately into player bank). After successful transfer or a documented fallback, transform into a solid defensive wall segment. The segment no longer conveys packages while serving as a wall. The armored wall can be attacked/destroyed.
- Rotation and “behind” must derive from explicit wall facing and owned side, not whichever side is advantageous during an attack. If there is no legal unload space, the mode switch must **wait/fail** or use a clearly surfaced authorized fallback; never duplicate, destroy or tele-port cargo.
- Return from Wall to Conveyor is *proposed* as a reversible, costed Manus module reconfiguration. Rotation/footprint checks and vulnerability during the change are essential.

**MAX — Slow mobile warehouse / infantry bunker:**
- **Depot mode:** crawls over land, absorbs bulk deliveries into many finite compartments and dispatches material to MAN transport edges.
- **Bunker mode:** a **specialized deployable MAX** empties/resource-ejects stored cargo into reachable packages/depot cells (possibly requiring several trips, therefore cannot be instantaneous if loaded), then anchors into defensive bunkers with **finite soldier garrison slots**. Soldiers are actual actor entities, not transformed resource packets. Bunker weapons should require eligible installed equipment or garrisoned soldiers, not be free universal turrets.
- Protected side unloading, garrison entry/exit, packing/unpacking, time, vulnerability and build/resource costs require playtesting. Garrison is a separate finite passenger/unit list.
- Topological cost: a belt converted to a wall no longer transports cargo; a warehouse converted to a bunker ceases to serve as a warehouse until reverted. This creates an intentional **economy vs defense** tradeoff. Bypass lines, local depots and emergency MIN hauls are counters.

**Deployability:** these form-changing **specialized economic MID/MAX templates** must explicitly hold `deployable`/mode capability. Ordinary soldiers, generic workers and unrelated MAX chassis do **not** morph into arbitrary buildings.

## ETH: Network builder MIN, pylon MID and Nexus MAX (DEC-013)

**This supersedes the old mobile Relay Conductor MID and MAX turret-pylon models.** The new MID and MAX identities are owner-approved; precise times, health, ranges and costs are not.

- **MIN:** independent direct-to-base courier/extractor. On a construction job it enters **NETWORK** mode and stays at the site throughout work, maintaining a **visible blue beam** to the nearest valid **large node** (typically MAX). The beam draws finite accounted Energy; Matter/Volatiles are actually delivered. It cannot harvest or haul while busy. Opponent visibility relative to fog, stealth and detection remains to be tuned.
- **MID:** physical **pylon**. In STORAGE/RELAY mode accepts and dispatches cargo via finite service queues. Its alternate TURRET mode costs meditation time, **retains all cargo without unloading**, and locks receipt/dispatch throughout meditation and turret operation. Reverting similarly takes time/cost. Optional future relocation/levitation is a separate specialist capability, not intrinsic to this MID.
- **MAX:** **Nexus-class hub from creation**, with major storage, construction-beam support, a local knowledge cache and authorization/initialization of expansions. It is not just a larger MID and not automatically a turret. Only specifically eligible buildings may meditate, levitate to new sites and reconnect; this is not unrestricted mobile construction.
- **ETH expansions:** initial home contact provides an operating seed and known blueprints. Afterwards the local Nexus/MID network handles extraction, production and known structures without constant home contact. An **unknown blueprint** causes a fresh permitted home request; losing a distant home connection alone cannot erase already learned structures or inventories.
- **Faction identity:** staggered relay economy; strategically visible active construction; costed defensive timing and slow relocation. A construction beam is **not** a free cross-map matter teleport or a Protoss-like energy orb left behind by a departing builder.

See [the canonical base ecology spec](base-ecologies-and-expansion-2026-10-11.md) for the expansion-dependence comparison and acceptance tests.

## Common mode-switch state machine

Each asset has a persistent ID, `faction_id`, `chassis_scale`, `role`, `mobility_domains`, finite `cargo_slots[]`, optional `passenger_slots[]`, a `mode`, and an optional **explicit** `mode_transition_capability`.

Mode switches are intentional economic/combat actions, **not role changes that happen freely or silently**. They validate owner permissions, cooldowns/upgrade, terrain/footprint, available ground cells, nearby enemies where relevant, ongoing reservations, finite cost and duration.

| Unit | Economic mode | Transition | Defense mode | Cargo policy |
|---|---|---|---|---|
| ORG MID/MAX | Gather/Carry/Flying Loop | Equipped organic specialist adaptation (proposed, possibly irreversible) | Optional escort / defensive organs | Cargo remains on unit; transport/payload competes with combat/passenger mass |
| MAN MID | Conveyor | Isolate edge → drain/eject packages behind facing → deploy wall | Sentry Wall | Packages physically spawn or move into valid defended-side inventory; belt unavailable |
| MAN MAX | Mobile Depot | Finish reservations → unload/eject resource crates → deploy bunker | Soldier Bunker | Stored packages are expelled before defense mode; soldiers occupy finite garrison slots |
| ETH MID | Pylon Storage/Relay | Lock gates → meditate | Turret | Keep cargo in compartments; no inbound/outbound during meditation or turret mode |
| ETH MAX | Nexus-class core | Eligible structure only: meditate → levitate → resettle | Relocated Nexus | Keeps finite stock/known-blueprint state; downtime, legal space and Energy cost required |

### Cargo accounting and recovery
- Any resource transfer is source reservation → physically legal handoff/ejection → destination commit. Never subtract twice; never credit the base just because a package dropped behind a wall.
- **Ejected packages** are world entities with quantity, owner, position, pickup eligibility and possible capture/loss. They are NOT economically delivered until actually deposited.
- Ejecting must have placement/capacity checks to prevent free infinite ground storage and blocked cells. Failed unloading cannot silently delete cargo.
- **Sealed ETH cargo** retains its current amount and resource type in every pylon mode; transferring is unavailable while gates are locked. Destruction invokes an explicit loss/drop/salvage policy, not free refunds.
- **Boarded ORG passenger units** remain distinct serialized actors, with population/transport mass and deterministic exit/destruction rules; carrying a unit cannot duplicate it.
- Converting modes disables incompatible workers/jobs and triggers explainable retries and routing suggestions rather than phantom deliveries.

## Identity, fairness and balance
- ORG **mobile gatherers but rooted base:** workers and mothers travel, while every viable rooted building needs the physical Nexus vessel and remote colony nourishment. Branch cutting/starvation and mother interception are separate threats.
- MAN **space:** high peak throughput and sophisticated routing with convertible fortifications, but any conversion may choke an entire industrial corridor.
- ETH **time:** redundant courier graphs, durable core pylons and a carefully timed defensive conversion, but sustained turret mode starves network output and delays late tech.
- Give each faction fair map access and **low-cost MIN-only recovery** when signature infrastructure is lost. No automatic global extraction/throughput buffs.
- Evaluate first delivery, time/cost to deliver 1,000 units, throughput by map distance, lost cargo, interruption recovery, downtime in defense mode, combat deterrence and probability of economic softlock.
- Values for slots, harvesting seconds, belt speed, map squares, turret DPS, meditation time, transit capacity and passenger rules are TBD. Older Crystals/Gas/Resin values in `economy.yaml` are legacy tuning and must be migrated separately.

## Prototype acceptance criteria
1. All three MIN workers mine and carry home without MID/MAX support.
2. ORG MIN→MID→MAX capacity rises while movement/personal mining speed falls; basic MAX stops to receive/dispatch, with researched moving transfer later.
3. ORG carries compatible worker/soldier passengers only with sufficient berths/mass, and manifests are never duplicated on boarding/destruction.
4. MAN MID belt in 3/5 tile versions has finite flow and blocks when destroyed/disconnected.
5. A MAN MID filled with packets cannot instantly deploy wall with free bank delivery; packets must be placed on legal protected-side ground/depot cells before mode completion.
6. While MAN MID is wall, belt throughput on that segment is zero; reverting requires an explicit and legal transition.
7. MAN MAX only moves on ground, very slowly; correctly ejects stored resource packages and converts to an explicit specialist bunker that can garrison real soldiers.
8. An ordinary MAX without the specialized mode capability cannot become a bunker or wall.
9. ETH MID pylon stores/relays finite courier cargo; MIN alone still delivers directly on short routes; no free teleportation.
10. ETH **MID pylon** with cargo converts STORAGE→MEDITATION→TURRET with **no unloading**; its slots remain filled and *zero* cargo enters/leaves during meditation and turret mode.
11. ETH MID pylon returns to STORAGE through a costed reverse transition; **ETH MAX is Nexus-capable immediately**, including local knowledge/blueprint services (cost/range TBD).
12. Destroying a mother, wall, bunker or pylon reconciles slot cargo, packages and passenger units exactly once.
13. With seed + orders fixed, state hashes, package positions, mode timings and ledger remain reproducible.
14. Attack-induced defensive conversion has a measurable **opportunity cost** for MAN and ETH; never free simultaneous full-output economy and defense.

## Approval boundary
**Owner decisions (DEC-011/012/013):** ORG sequential handoffs, baseline mode-exclusive flying mothers and researched moving handoffs; **living-vessel-only rooted buildings and recurring home nourishment**; equipped MIN/MID/MAX bud L1/L2/L3. MAN SCV repair MIN, tracked 3/5-tile MID with **one-person bunker**, conveyor or sentry wall, and ground MAX warehouse or multi-soldier bunker; **mobile composite bases and independent expansion**. ETH MIN occupied visible blue-beam NETWORK builder, **MID cargo/turret pylon** and **MAX Nexus-class core from creation**, with conditional blueprint-only home requests.

**Proposals needing confirmation or playtest:** defensive capabilities for ORG cargo creatures and passenger berths; nourishment interval/wither grace; MAN bunkering footprints and reconfiguration costs; ETH beam visibility relative to fog, Nexus range, eligible levitation templates and blueprint delivery logic; numeric balance and exact tile placement.
