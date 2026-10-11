# Scalfagus — Faction Logistics and ETH Slow Unit Relay

Date: 2026-10-11  
Status: **owner-approved high-level faction identity / ETH unit-relay direction; throughput, costs, technology gates and interruption handling remain engineering and balance proposals.**  
See [machine-readable rules](three-faction-logistics-and-eth-unit-relay.yaml).  
Authority: new DEC-035, supplementing DEC-010/011/012/013/018–023. **This is POST-MVP0**: DEC-033 MAN-vs-MAN remains the first-playable scope.

**Later owner update (DEC-039):** The older ETH text below saying that ONLY Nexus may convert raw cargo is **superseded** for future gameplay. Three routes now exist: Nexus deposit with no incremental Energy conversion tariff; an eligible shielded drone inserting a finite parcel at an Obelisk tip while losing 33% of its own shield; or costly powered Obelisk ground pick-up. See [DEC-039](org-plug-holes-and-eth-three-ingress-methods-2026-10-12.md). The canonical player-facing term is **Obelisk**; the word "pylon" in this dated historical design does not authorize new UI strings using that term. DEC-035 unit-over-network transfers remain separate from cargo injection.

## The owner's new design clarification

- **MAN (Manusians)**: physical resources arrive through **transporters, warehouses, bunker/UMU configurations where cargo access is physically permitted, power-station infrastructure where equipped with actual storage/input ports, and conveyor belts**. None of these is a free network-wide inventory. Existing hybrid electricity/information cables **do not convey resource matter**. A bunker in combat/garrison mode cannot implicitly act as an open warehouse when that mode disables its ports.
- **ORG (Organites)**: physical resources travel aboard **large transport organisms**, from smaller gatherers and through **living vascular veins**. Veins are finite-rate material / nutrition / information infrastructure, rooted and vulnerable; large flying mother organisms remain genuine movable cargo carriers. This does not grant troops a building-free 'vein teleport' mechanic.
- **ETH (Etherans)**: physical resource intake is converted only by eligible **Nexus**, then relayed **pylon → pylon → pylon**. **Every pylon has a finite, real local inventory** of typed resources; the network gradually transfers stocks over hops, not via an instant global wallet. The **new distinctive advantage** is that connected pylons also transport eligible ETH **units slowly along their links**. Neither MAN belts/power cables nor ORG veins may transport combat units internally by this network-relay mechanic. Physical personnel/passenger transports for those factions remain allowed by their separate unit capabilities.

These three transit paradigms should be mechanically different, not the same generic teleport/flow under three visual skins.

## ETH Unit Relay: game behavior

The **one pre-existing Ether Network** now supports a fourth kind of transmitted payload: `unit`, alongside typed resources, Energy and information; this must not create a fourth economy currency or an unrelated second network.

**Candidate transfer procedure:**
1. A living, owned, eligible ETH unit approaches an eligible pylon departure port; player/manual order or properly authorized manager issues `relay_unit(unit_id, source_pylon_id, destination_pylon_id)`.
2. The authoritative server validates ownership, available observation, connection/path, accessible port and destination space, legal posture and resources; a queue/reservation is created without duplicating the unit.
3. After nonzero departure/channeling time, the unit becomes **in transit**, losing normal movement, combat, mining and construction actions during transit. The real unit ID, HP, status, cooldowns, equipment, passengers (if any and allowed), inventory and ownership remain unique and unchanged except for specifically costed transit effects.
4. The unit progresses across **real connected edges**, one hop at a time, with positive latency and finite per-link/per-pylon capacity. Unit transfer may compete with typed resource freight and Energy; information/control service is retained as defined by existing unified-network rules.
5. At the eligible destination pylon, the unit waits for finite arrival/departure processing and a legal non-overlapping physical spawn position; then the **same unit** materializes. If the landing position is blocked, it stays safely queued in destination custody—never overlap-spawns, loses identity or duplicates itself.

**Important distinction:** this is intentionally **slow, costly infrastructure mobility**, not instantaneous teleportation and not the same as permission to move completed pylons/buildings. DEC-014's possible building relocation remains a separate open research question. The pylon is a storage/relay node; a unit transiting through it is NOT counted as a normal resource stack or newly produced unit.

## Proposed constraints to protect RTS balance

- Only controllable **ETH units** with the relay capability; not enemy units or arbitrary structures, not passengers of other civilizations, and not loose enemy cargo by magic.
- Pylons are fixed network endpoints by default; a player's units still need to physically reach the source pylon, and the destination pylon must already legally exist, be reachable and support arrival.
- The relay is a **rear-line reinforcement tool, not a no-warning frontline blink**. Starting a relay while engaged, landing inside active enemy threat, transfer of heavier units, and channeling under fire can be prohibited or penalized after playtesting. Never bypass the map's edge, terrain or fog using an arbitrary free destination.
- Per-hop latency, unit mass/size, departure and arrival slot limits, node queues, link capacity, and real Energy costs are tunable. Prefer queueing over silently dropping legitimate transfers. No numeric values are approved in this document.
- Pylon STORAGE/RELAY and TURRET mode interactions must be explicit: recommend storage/relay for embark/disembark; whether turret may forward transiting units at reduced rate or block passage is **TBD**. Existing resource and signal behavior should remain consistent.
- A player can prioritize units vs resources; doing so costs real throughput and possibly Energy and may starve logistics. The automatic doctrine cannot spend more than its allocated budget or override direct/manual commands.
- Resource equalization is background traffic with lower priority than reserved production and explicitly approved transfers. Routing must prevent permanent starvation of each service class.
- Network partition, destroyed source/destination, cancelled orders and reconnected paths need **deterministic, loss/duplication-proof handling**. Candidate safest initial implementation: preserve the unique entity in transit custody at the last safe surviving node, reroute if a valid path exists, or return to the last safe node; no free instant evacuation, uncontrolled death, or reappearance on both sides. Final damage/loss/capture rules are not yet decided and require explicit acceptance.
- Use actual deterministic world ticks and the same authoritative GameState for UI, LAN and headless. A physical ETH actor does not also exist on the terrain while it is an in-transit entity.

## Combat and logistics counterplay

| Attack | MAN | ORG | ETH |
| --- | --- | --- | --- |
| Supply cut | Break belts, interdict haulers; local warehouses may buffer | Sever vessels, ambush mother carriers; isolated branches starve over time | Cut pylons/links; inventories partition in-place and unit routing stops or is rerouted |
| Defense | Physical bypass belts, alternate roads and independent UMU outposts | Regrow vessel and dispatch backup large organism | Redundant pylon graph, extra local stocks and safeguarded departure/arrival points |
| Major payoff | Fast physical throughput and relocatable bases | Large organic mass movement and nutrient continuity | Slow internal unit reinforcement without physical troop carriers, at graph cost |

**Do not let ETH unit relays erase MAN/ORG transport identity.** MAN and ORG may still use ordinary physical passenger vehicles/organisms. They simply do not have ETH's **unit-over-network-link** capability.

## Player control and AI behavior

Full Manual: player directly orders pylon transfer; no network auto-move.  
Semi-Auto: authorized group manager may issue unit-relay instructions only inside its explicit sector, with approved priority and spending cap.  
Full Auto: doctrine and faction manager may proactively rebalance defensive garrisons through connected pylons **only if explicitly delegated**, obeying threat posture and transit safety.  
Manual stop/control overrides automation at the next authoritative simulation boundary. If the unit is already in transit, an explicit interrupt obeys physical travel and safe-landing policy; a mode switch never duplicates or instantly extracts it.

## Validation / balance scenarios

- **LOG-01:** MAN conveyor delivers Matter through real buffer/storage, but MAN power/data cable does not move physical Matter.
- **LOG-02:** MAN bunker/UMU with closed cargo ports cannot magically send/receive Matter.
- **LOG-03:** ORG huge transporter must physically load, travel and unload; living veins transfer finite material without moving combatants through the vein itself.
- **LOG-04:** ETH all three connected pylons have their own finite typed stocks; a stock transfer advances gradually across hops, and a cut splits only actual stocks.
- **ETH-UNIT-01:** One ETH unit relays A→B→C at nonzero time, emerges once at C with same ID/HP/equipment/inventory.
- **ETH-UNIT-02:** A second unit queues when the only source/destination transit port is occupied.
- **ETH-UNIT-03:** A blocked landing area holds the unit safely in destination custody and never creates a colliding copy.
- **ETH-UNIT-04:** An interrupted connection neither duplicates nor instant-teleports the unit; last-safe-node/repath policy is deterministic.
- **ETH-UNIT-05:** EMP, turret-mode change or pylon loss is evaluated under declared port/service rules, not guessed by renderer.
- **ETH-UNIT-06:** Unit-relay traffic competes for finite shared logistics capacity; resources, Energy and unit traffic all keep proper ledgers.
- **ETH-UNIT-07:** MAN/ORG reject a network unit-relay command, even with a friendly nearby conveyor or living vessel.
- **ETH-UNIT-08:** No automatic unit transfer when player has FULL MANUAL or manager lacks authority.
- **ETH-UNIT-09:** Same event stream and replay hash under GUI vs headless and H-H host with same deterministic commands/seed.
- **ETH-UNIT-10:** An occupied pylon cannot be used as an infinite capacity troop teleporter; congestion and cost are visible.

## Delivery order

1. Complete **DEC-033 MVP0 MAN mirror**: four templates, real Matter delivery, one authored floating platform, H-H/H-C/C-C.
2. Expand MAN industrial belt/warehouse models and ORG physical vascular logistics, preserving existing decisions.
3. Implement ETH per-pylon finite storage and actual resource hop routing (existing DEC-021 canon).
4. Implement ETH **slow unit relay** with movement ports/queues, one unique actor in transit, capacity/energy and interruption rules.
5. Tune combat counterplay, doctrines, manager permissions and large-map balance. No automatic FPP or moving buildings implied.

No release feature or numeric balance has been implemented or tested by this documentation.
