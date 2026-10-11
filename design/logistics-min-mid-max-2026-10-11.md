# Scalfagus — Faction MIN/MID/MAX Economic Logistics
Date: 2026-10-11
Status: Owner-directed roles; ETH MID, unit names, timings and capacity numbers proposed.

## Decision
All three factions have economic MIN, MID and MAX *platform scales*. These are not tech tiers, match scale, nor restrictions on combat units. Each race has a different extraction-and-transport architecture. Resources remain **Matter, Volatiles, Energy**; crystals are one presentation of Matter.

**MIN in all factions:** small independent worker; mines/harvests, carries finite cargo, and can directly deliver to reachable base inventory. No faction may be unable to start mining without special infrastructure.

**MID in all factions:** intermediate platform with multiple finite cargo compartments, independent operation and optional mining equipment. Primary utility varies by faction.

**MAX in all factions:** heavy logistics platform with the largest storage role, but **not necessarily a vehicle**. A generic rule saying every MAX must move or mine is superseded for these logistic specializations.

| Faction | MIN | MID | MAX |
|---|---|---|---|
| ORG / Organites | Small, fastest organic extractor/courier; small cargo | Larger and slower independent harvester, several slots, can collect, carry and load mother | **Flying mother ship**: many separate cargo slots, travels source–base loops; workers can load and unload it **while it is flying and moving** |
| MAN / Manusians | Small self-sufficient ground mining robot | **Mobile conveyor belt unit** with 3-tile or 5-tile operating length, multiple buffer slots; repositionable; extraction possible with mining equipment | **Very slow ground-only mobile warehouse** with specialist deployable capability to settle into armored **bunker-storage** |
| ETH / Etherans | Small independent extractor and courier | **Proposal: Relay Skiff**: mobile courier with several storage slots; stops to serve as an intermediate collection and handoff point; possible extraction module | **Large static pylon hub** for finite goods storage, receiving, sorting and outgoing courier handoffs; no free teleportation |

## ORG: simple biological size ladder
The owner-defined monotone tradeoff for economic collection organisms: **increasing size raises cargo capacity and decreases movement speed and personal mining speed**. MIN is fastest at extraction, MID is intermediate, MAX has enormous transport capacity but is slow. In ORG's case MAX movement is **air**, not land: flying mother transporters trace player-specified loops.

MIN and MID can meet a moving mother and load her available slots; near a delivery depot, receiver units unload the moving mother. Transfers require actual spatial proximity, available compatible compartment capacity, and finite transfer bandwidth; the mother need not stop. Aerial access height/range remains TBD. Optional MAX self-mining is a later equipment specialization, not mandatory for the core mother role. Threat: mother carries concentrated value, so interception makes the economy vulnerable. Redundant mothers and escorts counter this.

## MAN: conveyor vehicles plus fortified ground depots
MIN mines and can fall back to direct transport if belts fail. **MID is a mobile 3-unit or 5-unit-long conveyor** which connects with adjacent compatible conveyors and depots. Belts have finite rate, physical connectivity and damage; a severed line stops delivery. MID has several buffer/storage slots and can mine only when appropriately equipped, with role tradeoffs. **MVP proposal**: belt transfers while MID is positioned/parked, not during repositioning; vehicle remains a mobile unit, not a free permanent structure. MAX moves only on the ground, **very slowly**, and can anchor into a bunker-warehouse if it has an explicit specialist deployable flag. Packing and redeploy cost/time TBD. Anchored MAX stores cargo in multiple slots and can buffer/split physical conveyor throughput.

## ETH: courier + temporary relay + permanent pylon
ETH MID was not specified by the owner. **Recommended alternative to a generic large courier:** a dual-mode **mobile relay**. In travel mode it carries several finite cargo compartments between deposit, depot, or pylons. In relay stance it stops and accepts/releases packages from independent MIN couriers, functioning as a temporary micro-hub. This creates a meaningful intermediate scale: MIN handles local short trips, MID creates flexible relay chains, MAX provides permanent high-capacity **static pylon storage nodes**. MID independent mining is possible with an optional compatible extraction module. MAX pylons are built in place by an explicitly authorized specialist; ordinary MAX workers are not automatically allowed to turn into buildings. Pylons are cargo hubs, **not** compulsory energy grids or unpriced teleport beacons. More hops add queue/service delay, and a direct MIN-to-base run may outperform relay on short distances.

## Shared finite inventory model
- Each actor has a finite array of cargo slots (resource compatibility, capacity, occupancy, reservations).
- **Slots are containers, not automatically literal single resource units**. Exact slot count, stack size, extraction rates, footprint and hit points are TBD.
- Transfer checks source ownership, destination, capacity, distance, time and speed; commits to the destination exactly once.
- When a source or destination is lost mid-transfer, carried versus delivered inventory remains accounted for.
- MIN/MID/MAX describe chassis scale; mobility, extraction ability, freight slots, docking and deployment are independent features.
- No universal numeric boost: test first-delivery latency, 1,000 units delivered, setup cost, throughput, footprint and recovery after critical-link loss.
- Routine extraction and transport can be automated after player orders. Strategic expansion requires separate player authorization.

## Prototyping acceptance checks
1. **SCALE-01:** MIN of ORG/MAN/ETH gathers and returns goods to base with zero MID/MAX logistics.
2. **SCALE-02:** ORG MIN/MID/MAX economics preserve cargo-up/mining-speed-down/mobility-speed-down gradient, with air motion for flying MAX.
3. **SCALE-03:** ORG mother has multiple slots and can be loaded/unloaded without stopping mid-flight if transfer geometry is valid.
4. **SCALE-04:** ORG mother loss cannot duplicate cargo and creates observable loss or recoverable cargo per explicit future policy.
5. **SCALE-05:** MAN MID physical 3-tile and 5-tile variants connect and transport at finite rate; broken edges block flow.
6. **SCALE-06:** MAN MAX is ground-only and slow; bunker-mode activation requires a specialist deployment tag and cost/time.
7. **SCALE-07:** ETH MID travel/relay transition preserves slot inventory, queues and valid courier handoffs.
8. **SCALE-08:** ETH MAX is a static construction-site pylon and stores actual finite cargo; destruction disconnects affected graph paths.
9. **SCALE-09:** Direct MIN delivery remains legal even if network nodes are offline.
10. **SCALE-10:** Fixed match inputs replay to same inventory state and transfer timings.

## Existing-file precedence and migration
- This file refines [faction-logistics](faction-logistics-2026-10-11.md) for the economic MIN/MID/MAX templates.
- [logistics-unit-scales.yaml](logistics-unit-scales.yaml) is the machine-readable matrix.
- Legacy [economy.yaml](economy.yaml) uses Crystals/Gas/Resin and a single generic speed/cargo/mining table. These old numbers are **draft migration debt**, not current per-faction balance.
- Existing 63-archetype worker labels were drafts; align the worker row with these roles, without changing unrelated military units.
- Preserve the explicit deployable-tag rule from [deployment.yaml](deployment.yaml).

**Owner-directed:** MIN independence; ORG intermediate harvesting MID, flying in-motion-loading MAX mother and simple biological capacity/speed tradeoff; MAN mobile 3/5-length belt MID and slow ground bunker-storage MAX; ETH huge fixed goods-storage pylon MAX.

**Unapproved proposal:** ETH MID dual-mode mobile relay, its working name 'Relay Skiff', exact compartment sizes, optional mining equipment details, MAN parked-only conveyor operation, and unit balance.
