# Scalfagus — Unit Domains, Combat Capabilities and 63-Template Roster
Date: 2026-10-11
Status: design proposal; names, domain defaults and weapon profiles are **not yet balanced or implemented**.

## Design objective
Preserve Warcraft II's immediately legible seven-role RTS vocabulary while supporting Scalfagus' three factions, three chassis sizes, and land/water/air combat. The full design catalog contains **7 archetypes × 3 chassis sizes × 3 factions = 63 named templates**, not 63 independent mechanical systems. Do not confuse chassis MIN/MID/MAX with match duration MIN/MID/MAX.

## Orthogonal dimensions
1. **Archetype**: worker, fighter, shooter, artillery, tank, flyer, specialist.
2. **Chassis scale**: MIN, MID, MAX (physical platform size, not tier or tech gate).
3. **Faction**: Blergians, Manusians, Aetherians.
4. **Movement domains**: land, water, air; valid combinations below.
5. **Melee target domains**: independently enumerated; may be empty.
6. **Ranged target domains**: independently enumerated; may be empty.
7. **Equipment/abilities**: weapon-specific accuracy, reach, ammunition/energy cost, area damage, cooldown and special rules.

Domains represent **traversal/combat environments**, not the physical state of matter: land need not be only solid matter, water may later include other fluids, air is not all gas, and orbital space is a separate possible future domain. Surface ships vs submerged units and low vs high altitude may later require subdomain layers. Do not implement these as universal baseline mechanics until needed.

## Seven valid movement-domain combinations
| Movement class | Land | Water | Air |
|---|:---:|:---:|:---:|
| Ground | Yes | No | No |
| Aquatic | No | Yes | No |
| Aerial | No | No | Yes |
| Amphibious | Yes | Yes | No |
| Air-Ground | Yes | No | Yes |
| Air-Water | No | Yes | Yes |
| Omnimodal | Yes | Yes | Yes |

These are **capability combinations, not seven more unit archetypes**. Air-Ground is meaningful only if the unit can actually land or operate on ground. Merely flying over land does not count as land movement. Similarly, an amphibious unit must support explicit transition between terrain modes.

## Seven baseline archetypes
| Archetype | Warcraft II flavor | Gameplay responsibility |
|---|---|---|
| Worker | Peasant/Peon | Extract, haul, construct, repair when equipped |
| Fighter | Footman/Grunt | Accessible melee frontline |
| Shooter | Archer/Axethrower | Accessible direct ranged unit |
| Artillery | Ballista/Catapult | Siege, long-range area denial |
| Tank | Knight/Ogre | Screening, durability, breakthrough |
| Flyer | Gryphon/Dragon | Air-oriented scouting or combat |
| Specialist | Mage/Death Knight | Faction-specific support and control |

**Tank is a combat role, not synonymous with MAX. Flyer is a role, not the only archetype that can move through air.** Each archetype has MIN/MID/MAX variants, but their design is not a requirement to ship all 63 units in Alpha.

## Complete named roster
| Role | Blergians MIN | MID | MAX | Manusians MIN | MID | MAX | Aetherians MIN | MID | MAX |
|---|---|---|---|---|---|---|---|---|---|
| worker | Sporeling | Harvester | Brood Carrier | Utility Drone | Engineer Rig | Mobile Constructor | Wisp | Shaper | Resonance Architect |
| fighter | Clawling | Ravager | Behemoth | Marine | Assault Trooper | Siege Walker | Blade Adept | Templar | Ascendant |
| shooter | Spitter | Acid Hunter | Corrosive Hive | Rifleman | Gunner | Fire Support Rig | Spark Adept | Pulse Weaver | Storm Conduit |
| artillery | Spore Caster | Bile Lobber | Siege Organ | Mortar Drone | Mobile Howitzer | Siege Platform | Resonance Orb | Prism Caster | Celestial Array |
| tank | Carapace | Bulwark | Colossus | Shield Trooper | Battle Tank | Land Fortress | Ward | Aegis Guardian | Monolith |
| flyer | Mothling | Razorwing | Sky Brood | Scout Drone | Gunship | Heavy Carrier | Glimmer | Sky Sentinel | Astral Vessel |
| specialist | Parasite | Mutator | Hive Mind | Saboteur | Field Engineer | Command Platform | Seer | Phase Weaver | Oracle |

The YAML file `unit-domains-and-archetypes.yaml` is the structured source for these names and proposed **baseline** combat profiles. Defaults are deliberately conservative: most units start on land; flyer starts in air; noncombat workers/specialists have no assumed weapon. The six illustrative specialization overlays show how equipment or evolution can add amphibious movement or anti-air capability. **They are not additional baseline roster entries.**

## Combat targeting contract
- `movement_domains` answers where the unit can traverse or operate.
- `melee_targets` answers which target domains are reachable in close combat; no attack if empty.
- `ranged_targets` answers which target domains are reachable by equipped ranged weapons; no attack if empty.
- Being airborne does not automatically grant air-to-air, anti-ground or anti-water attack.
- Target-domain permission does not guarantee line of sight, accuracy, range, armor penetration, detection or ability to hit submerged targets.
- Attacking land, water or air targets may require separate weapon mounts or modes, each with their own balance.
- Distinguish a weapon's target permission from a target's actual collision/hitbox and from map terrain.
- Do not conflate a unit's movement capability with the player's order legality: possession, transport and deployment may add constraints.

### Sample specializations
| Example | Movement | Melee | Ranged |
|---|---|---|---|
| Manusian Anti-Air Gunner | Land | None | Land, Air |
| Blergian Amphibious Ravager | Land, Water | Land, Water | None |
| Aetherian Sky Sentinel | Air | Air | Land, Water, Air |
| Manusian Gunship | Air | None | Land, Water |
| Blergian Spore Caster | Land | None | Land, Water |
| Aetherian Omnimodal Specialist | Land, Water, Air | Land, Water | Land, Water, Air |

These are **proposed equipment/loadout examples**, not finalized core profiles.

## Balance and counterplay
1. Each additional movement domain costs specialization, capacity, speed, resources or survivability.
2. Anti-air requires explicit weapon capability; air units are not automatically dominant.
3. Artillery trades burst/area/range against reload, vulnerability, minimum range, friendly fire or supply.
4. Tanks are durable but pay in speed, cost, footprint or counters.
5. Omnimodal units are rare, expensive or less effective than specialists; never default-best.
6. Land/water/air interaction must produce meaningful counters, not invulnerable units that opponents cannot target.
7. Each faction expresses its identity through equipment, movement, support and tech; all seven roles remain recognizable.
8. MIN chassis units remain strategically relevant in MID/MAX matches; chassis is not a strict upgrade ladder.
9. Physical ammunition/energy costs should obey the existing Matter/Volatiles/Energy economy and logistics contracts.
10. Preserve faction differences: Blergian organic mutation, Manusian modular equipment, Aetherian costly resonance transformation.

## Proposed build sequence
**Alpha 1:** implement seven MIN-chassis roles per faction (21 templates), basic land and air interactions, explicit attack permissions, one meaningful anti-air counter, and a limited amphibious test. Full water combat can follow once pathfinding and maps support it. The design catalog may contain all 63 templates without implying that Alpha ships 63.
**Alpha 2:** validate role counters and each faction's distinct economic/combat profile; add MID chassis and loadout customization.
**Later:** MAX chassis, richer naval/amphibious warfare, specialist mechanics and advanced domain transitions.

## Deterministic tests
- All 63 unique faction/archetype/chassis keys exist; no duplicate keys or missing entries.
- All declared domains belong to the allowed set; empty attack lists are legal.
- Land-only melee cannot hit air by default.
- Air-only units cannot traverse ground as ground movers unless explicitly allowed.
- An anti-air unit can target air but still respects line-of-sight, range and projectile rules.
- Amphibious units transition across land/water without unintended path teleportation.
- A unit lacking a weapon cannot fire even if it is airborne.
- MIN match_scale does not implicitly forbid MID/MAX chassis; restrictions must be explicit.
- Replay and AI orders use the same validated movement/targeting capabilities as manual orders.

## Open decisions
Whether WATER includes surface and submerged in Alpha; how to represent flying altitude; weapon mounting and targeting profiles; unit capacities, exact stats, tech availability, formation/collision scale; number of aquatic baseline units; whether some MAX archetypes are mobile buildings or only combat platforms. Only specifically `deployable` units may transform into structures under DEC-002.

Related: `match-scale-min-mid-max.md`, `gameplay-roles.md`, `decisions-v0.4.md`, `settlers-logistics.md`.
