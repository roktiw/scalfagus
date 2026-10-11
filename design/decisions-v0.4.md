# Scalfagus — Approved Design Decisions v0.4

Status: **four approved decisions**. Details marked `TBD` or `proposed` remain subject to design and balancing.

## DEC-001 — Energy as the Third Stored Resource

Matter (T1), Volatiles (T2), and Energy (T3) are three transportable, spendable economic resources. Energy can be generated or harvested at special resource locations, stored in warehouses and cargo units, transferred, and spent on technologies, modules, abilities, and transformations. **A mandatory electrical transmission grid is not part of the baseline.** Lava is an optional geothermal source dependent on the world, not a fourth resource. Resource conversion is allowed only through explicit recipes. The first extraction steps and the initial Energy production path must not softlock the player.

**Open questions:** generation output per cycle, container capacities, transformation costs, cargo loss rules, optional ongoing upkeep, and faction production efficiency.

## DEC-002 — Only Specialized Units Can Deploy into Structures

Ordinary MIN/MID/MAX units cannot transform into arbitrary buildings. A unit template must explicitly have the `deployable` capability. Deployment requires suitable terrain, available space, sufficient resources, and time, and can be interrupted.

Working examples: a Blergian *Colony Seed* roots itself into a permanent organic structure; a Manusian *Modular Constructor* anchors prefabricated modules (potentially reversible); an Aetherian *Resonance Anchor* manifests a structure using Energy (potentially reversible at substantial cost). These examples and their dismantling mechanics are **proposals**, not approved unit names.

**Open questions:** deployment cost and duration, fate of the constructor, HP and vulnerability during deployment, capture, salvage, and construction on drifting asteroids.

## DEC-003 — Medium Logistics Automation

Scalfagus remains a classic RTS. The player selects extraction deposits, destinations, routes, expansion targets, and docking operations. Units repeat ordered extraction, return full cargo to a configured recipient, and transfer it to compatible MIN/MID/MAX receivers according to established logistics rules. Units do not autonomously expand, choose strategic map objectives, or construct factories. Energy is handled as cargo.

**Open questions:** transfer range, throughput, queues, full storage, collisions, destroyed recipients, route interruptions, and drifting asteroid behavior.

## DEC-004 — Standard 1v1 Match Duration of 25–40 Minutes

A 25–40 minute duration is a **design target**, not a hard time limit. Illustrative windows: early 0–8 minutes (Matter and scouting), mid 8–22 (Volatiles, islands, MID), late 22–40 (Energy, asteroids, MAX). Phases emerge from technological and economic progression, not a clock. Blergian early, Manusian mid, and Aetherian late economic advantages are intended **power windows**, not measured win rates. All matchups and map types require validation.

**Open questions:** victory conditions, population caps, starting resources, production rate, comeback mechanisms, and stalemate resolution.

## Acceptance Criteria for v0.4

1. A simulator can generate, store, transport, and spend Energy without a mandatory grid.
2. Units without a `deployable` tag cannot deploy; eligible units must validate placement, time, and cost.
3. With configured routes and compatible receivers, MIN transfers cargo to MID/MAX without a separate manual transfer order.
4. Match telemetry measures game duration and technology transitions without enforcing a 40-minute deadline.
5. Legacy `Crystals/Gas/Resin` data in `economy.yaml`, `resources.yaml`, and `units.yaml` must be migrated in a separate task; old values are **not directly compatible** with Matter/Volatiles/Energy.

Related: [resource-balance.yaml](resource-balance.yaml), [factions.yaml](factions.yaml), [units.yaml](units.yaml).
