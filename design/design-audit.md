# Scalfagus — Design Audit and Implementation Backlog

**Version:** v0.5  
**Scope:** design documents inspected through the connected GitHub repository and the project design discussion. Full repository-tree enumeration was unavailable, so this document does **not** certify every tracked file.

**Canon synchronization note (2026-10-11):** The approved detailed faction economy, construction,
MID/MAX worker pivot and expansion dependencies are consolidated in
[the conversation economy record](faction-economy-and-construction-conversation-2026-10-11.md)
and [base ecologies](base-ecologies-and-expansion-2026-10-11.md).
**DEC-014 building relocation is an open research choice**, not an accepted
universal building-mobility rule. See
[building relocation options](building-relocation-design-options-2026-10-11.md).
Older generic worker/chassis and biomass references below are historical audit
findings and **must not override DEC-011/012/013**.

## Executive assessment

The project's distinguishing gameplay loop combines **three faction transformation philosophies** (irreversible Organ mutations, rapid Manus module changes, costly reversible Eter ascension), **three stored resources** (Matter, Volatiles, Energy), **three platform sizes** (MIN/MID/MAX), and **three geographic zones** (mainland, islands, drifting asteroids).

The central design risk is not a shortage of unit concepts but **missing interfaces between systems**. Resource costs, movement rules, transformation state changes, and combat counterplay must be formalized before numerical balancing.

## Canonical approved decisions

1. Energy is the third stored, transported and spent resource; a mandatory power grid is not part of the baseline.
2. Only specialist units explicitly able to deploy may become buildings.
3. Logistics use classic RTS player commands with automatic compatible cargo transfer.
4. Standard competitive 1v1 match target: **25–40 minutes**, not a hard timeout.

**Default strategy is not a faction lock.** Advanced players may execute rush, turtling, macro expansion, raids, air mobility or tech strategies with any race.

## Priority P0 — Architecture and first playable loop

- **AUD-001 — Unify resource taxonomy:** Migrate legacy Crystals/Gas/Resin definitions and core costs to Matter/Volatiles/Energy; no numerical one-to-one assumptions
- **AUD-002 — Define complete Energy economy:** Resolve extraction versus generation, costs, containers, capacity, replenishment, transport and resource anti-softlocks
- **AUD-003 — Separate unit tier from role and technology:** Define core sizes MIN/MID/MAX, abilities, module slots, mass and capacity; distinguish platform tier and technology access
- **AUD-004 — Formalize transformations:** Define state transitions, cancellation, health, cargo, module recovery, interruption and reversible versus irreversible costs
- **AUD-005 — Define production recipes and building economy:** Define costs in Matter/Volatiles/Energy for units, modules, research, fortification and repairs
- **AUD-006 — Specify world topology and pathfinding:** Define water, voids, airspace, islands, moving asteroids, docking, moving footprints and deployable construction
- **AUD-007 — Establish combat primitives:** Define HP, armor, damage classes, range, target layers, projectiles, anti-air, active and passive abilities, counterplay and siege
- **AUD-008 — Define first playable gameplay loop:** Specify initial economy, scouting, first encounter, first expansion, technology and victory conditions

## Priority P1 — Balance and tactical systems

- **AUD-009 — Balance four resource subsystem matrices:** Separate extraction, processing, transport/storage and conversion/spending efficiencies; avoid compounding global multipliers
- **AUD-010 — Validate power windows not win rates:** Use economic index as a proposed baseline, not measured win rate; balance early Organ pressure, mid Manus adaptability and late Eter ascension
- **AUD-011 — Model faction base geography:** Define biomass network constraints, widely dispersed Manus outposts, medium-range Eter satellites and core base vulnerability
- **AUD-012 — Complete logistics edge cases:** Define transfer queuing, throughput, full warehouses, docking failure, lost cargo and destroyed endpoints
- **AUD-013 — Technology trees and unlock timing:** Specify research prerequisites and viable alternative strategies per faction and for each game phase
- **AUD-014 — Scouting and information systems:** Specify fog of war, radar, psionic senses, organic detection, stealth and intelligence counterplay
- **AUD-015 — Measure map control and comeback:** Specify resource denial, contested islands/asteroids, recovery after base loss, siege and anti-stalemate mechanisms
- **AUD-016 — Scenario-based economic simulation:** Test MIN/MID/MAX solo and relay throughput, route length, cargo loss, asteroid drift, energy reserves and ROI
- **AUD-017 — Faction combat and strategic matchup playtests:** Test all three pairings across phases, armor/weapon counters, sieges, specialist deployment, raids and hot-swap

## Priority P2 — Quality and provenance

- **AUD-018 — CI and schema validation:** Add machine-validatable YAML schema, references, unit conversions, versioning, tests and explicit status tags
- **AUD-019 — Original-IP visual direction:** Develop distinct silhouettes and terminology without borrowing copyrighted characters, weapons, logos or franchise-identifying geometry
- **AUD-020 — English-only repository documentation:** Review all remaining tracked text files; English-only text, comments, descriptions, strings and design documentation

## Current conflicts and migrations

| Conflict | Current location | Required resolution |
|---|---|---|
| Crystals, Gas and Resin versus Matter, Volatiles and Energy | `economy.yaml`, `resources.yaml`, `units.yaml` | Replace resource identities and recalculate costs; preserve historical values as draft references until migration is tested |
| Energy described as potentially grid-like | `resource-balance.yaml` | Align with approved inventory-resource decision; optional generation does not imply mandatory grid |
| MIN/MID/MAX worker classes versus universal unit tiers | `economy.yaml`, `units.yaml` | Distinguish chassis scale, worker template, role and technology level |
| Permanent organic rooting versus general deployable rules | `units.yaml`, `deployment.yaml` | Require explicit specialist tag; generic units never become arbitrary buildings |
| Single nominal resource multiplier | `resource-balance.yaml` | Split into extraction, processing, logistics and utilization models |
| Polish documentation | `decisions-v0.4.md` | Translated to English in this audit update |

## Default faction strategy profiles

| Faction | Default identity | Base topology | Main power window | Vulnerabilities |
|---|---|---|---|---|
| **Organs** | Continuous pressure from early game, reinforcement streams over one to three attack lanes, irreversible mutations | Few separated bases; preferentially connected by structure-grown biomass | Early | Choke points, biomass-link disruption, overcommitment |
| **Manus** | Scouting, light bunkers, tactical planning, cohesive specialist strike groups, modular/flying expansion structures | Highly dispersed outposts | Mid | Vulnerable isolated bases, disrupted module logistics |
| **Eters** | Reconstruct and fortify a homeworld-like core, cautious scouting, survive into advanced technology | Strong core with moderately separated satellites | Late | Early siege, containment, central-base dependency |

See [factions.yaml](factions.yaml) for machine-readable profiles and a **high-level inspiration moodboard**. References to *Warhammer 40,000*, *Prometheus*, *Alien*, and *Predator* are creative research touchpoints only. The game's silhouettes, lore, character designs, unit identities, names, symbols and art must be original.

## Baseline economic asymmetry is not win rate

The proposed resource multipliers remain:

| Faction | Matter | Volatiles | Energy |
|---|---:|---:|---:|
| Organs | 1.30 | 0.80 | 1.00 |
| Manus | 1.00 | 1.30 | 0.80 |
| Eters | 0.80 | 1.00 | 1.30 |

Symmetric row/column sums do **not** imply equal matchup outcomes. Compounding bonuses can magnify early snowballing; maps and investment payback can negate or amplify a nominal advantage. Keep intended early/mid/late power windows while targeting balanced skill-matched outcomes.

**Suggested experiment design:** instrument economic income and loss, build and tech timings, module switching, map control, effective DPS/EHP, energy reserves, base connectivity, late-game access, match duration and faction pairings. Run scenarios across multiple deposit layouts and terrain topologies.

## Recommended development order

1. Normalize resource schemas and prevent economic softlocks.
2. Specify Energy generation, storage, cargo and costs.
3. Formalize cores, slots, specializations, deployables and transformation state machines.
4. Specify production, tech unlocks and costs.
5. Build an event-driven economy/logistics simulator.
6. Add minimal combat and victory conditions to create a playable vertical slice.
7. Expand faction counters and test matchups; tune only measured imbalances.
8. Add YAML validation, automated balance telemetry and English-only documentation checks.

## Test scenarios

- 10 MIN versus one MAX extraction and delivery
- MIN → MID → MAX relay under congestion
- Asteroid drift and moving docking targets
- Continuous Organ early attacks in one, two and three lanes
- Organ biomass-link disruption and counterplay
- Manus widely dispersed outposts under raids
- Manus module hot-swap during an enemy attack
- Eter home-core siege, survival and late tech transition
- Loss of a fully loaded MAX transporter
- Energy-first-generation resource softlock
- Cost of permanent Organ mutation versus reversible Eter ascension
- Depleted Matter deposits and recycling

## Definition of done for the next milestone

A simple instrumented simulation supports at least one playable faction economy from initial MIN harvesting through cargo transfer, construction, a specialist deployable structure, Energy generation/storage, an upgrade or transformation, and an economically justified expansion. The system records time, material costs, resource deliveries, and failures. Equivalent paths for the other two factions must be possible without changing the underlying resource and unit schemas.

See [design-audit.yaml](design-audit.yaml) for a structured, trackable issue list.
