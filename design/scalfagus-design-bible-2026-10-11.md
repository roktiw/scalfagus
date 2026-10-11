# SCALFAGUS — Consolidated Design Bible

> **Current release scope reconciliation — DEC-033 (2026-10-11):** Long-term universe, not current code release rules; DEC-033 first release is MAN mirror four templates, while DEC-030 all maps space platforms and DEC-031 future two views remain binding.
>
> **CURRENT executable release: [MAN mirror scope](mvp0-man-mirror-rts-2026-10-11.md), [active numbers](mvp0-man-mirror-balance-v0.1.yaml), [execution](mvp0-man-mirror-execution-contract.md), [authority](mvp0-man-mirror-network.yaml), [M0 backlog](mvp0-man-mirror-backlog.yaml), [acceptance](mvp0-man-mirror-acceptance.yaml).**


> **Latest owner world constitution (DEC-030, supersedes optional frames): EVERY playable Scalfagus battlefield is a spaceborne floating platform.** The top can be brown jungle soil, industrial metal patchwork, stone, desert or mixed terrain. In MVP it is a flat square `planar` map, enclosed by a physical boundary and visibly suspended over space; the rim/underside is neutral world terrain. Bare playable planetary surfaces are FORBIDDEN. The first MAN–ETH map is a jungle on a static floating deck, not a playable spherical globe. [World constitution](space-platform-world-contract-2026-10-11.md), [frame schema](battlefield-frames.yaml), [surface presets](platform-surface-presets.yaml), [MVP delivery](MVP-DELIVERY-GATES.md).

> **Current first playable scope (DEC-025/026): MAN vs ETH**, 5 base roles per faction, only SOLID extraction, water bodies as nonharvestable environment, ground-only actors and default all-building-class victory (DEC-024). Older speculative full-race/spherical/planetary design below does not override this playable slice.


> **Latest approved base economy/expansion canon (DEC-012/013):** [Three Base Ecologies](base-ecologies-and-expansion-2026-10-11.md), [machine-readable ecology](base-ecologies.yaml), [economic 3×3](logistics-unit-scales.yaml). This supersedes earlier exploratory statements about disconnected ORG buildings, always-mobile ETH MID relays, ETH MAX as a turret pylon, and a mandatory single static Manus Nexus.

> **Canonical faction naming (2026-10-11): Organs (`org`), Manus (`man`), Eters (`eth`).** Earlier names are archived in historical discussion notes; see [naming decision](faction-identity-rename-2026-10-11.md).
Date: 2026-10-11
Version: discussion consolidation v0.1
Language: English
Status: **living design baseline, NOT implemented gameplay or final balance**.

> Product identity: **A fast, readable classic RTS where your civilization can run itself; optionally take over any part of it, collaborate with AI, or watch autonomous civilizations collide.** Simple in MIN, strategic in MID, industrial/transport sandbox in MAX. One coherent simulation under all interfaces.

## 0. Document authority and decision notation
- **Approved direction**: directly established in the design discussions.
- **Recommended**: engineering/game-design guidance; requires prototyping or explicit signoff.
- **Proposed**: concrete examples (unit names, starting domains, APIs, tuning) that are not yet locked.
- **Deferred**: part of the vision, but not required for a first playable release.
- Prior artifacts remain authoritative for detailed catalogs; this document consolidates and cross-references rather than silently replacing them.
- Apparent conflict: older decision DEC-003 restricted *worker-local* autonomy. Newer approved strategic AI may expand/build when enabled; worker doctrine still cannot create its own strategic policy.
- Apparent conflict: older standard 1v1 duration 25–40 min is the tighter MIN target within the new overall MIN 20–40 min window.
- The 7/7 inspiration relevance ratings are **not** sprint priority, readiness or measured balance.

## 1. Fantasy, audience and boundaries
Scalfagus blends:
- **Warcraft II / StarCraft:** instantly recognizable selection, units, hotkeys, battles and clarity.
- **Z:** map sectors and factories whose capture shifts an active frontline.
- **Dungeon Keeper:** autonomous base workforce, functional rooms/infrastructure and possible direct possession.
- **Settlers I/II + Factorio + Transport Tycoon Deluxe:** living, inspectable goods movement with increasing logistical depth.
- **Earth 2150:** modular units, resupply, terrain as a war resource.
- **Civilization I/II:** research, exploration, colony specialization, diplomacy and long-term strategy translated into real-time play.
- **Battlezone II / Machines:** eventually possess a unit and see the SAME battlefield from FPS perspective.
- **Aliens vs Predator / Enemy Territory / Quake Wars / Tribes 2 / Quake III / RTCW:** asymmetric species FPS identities, objectives, engineering, movement and shooting feel.
- **LLM Civilization Lab:** partner, competitor or fully autonomous spectator tournaments with constrained model agents.

**Anti-goal: no Dwarf Fortress-level mandatory simulation.** Players do not manage personal needs, thousands of recipes, per-creature psychology or hundreds of opaque switches to enjoy an ordinary RTS match. Each subsystem must create strategic choice, be legible, and work under AI management. No copied art, characters or protected IP.

## 2. Distinct scales: matches versus unit chassis

### 2A. match_scale (play session)
| Dimension | MIN | MID | MAX |
|---|---|---|---|
| Target match duration | 20–40 minutes | 40–80 minutes | Unbounded / optional scenario win |
| Anchor | Warcraft II + Z + StarCraft | Earth 2150 + Dungeon Keeper + Settlers II | Factorio + Transport Tycoon Deluxe + Civilization |
| Rhythm | Early combat, simple tactical goals | Several fronts, territory and logistics | Long-term civilization, industry and infrastructure |
| Bases | Main base, optional satellite | Several differentiated bases | Many colonies/production sites |
| Production | Few significant chains | Processing and local specialization | Wide network of interdependent chains |
| Logistics | Finite cargo, automatically handled | Depots/routes and interdiction | Optimized network flows, throughput and congestion |
| Technology | Small readable branches | Meaningful branching | Long-horizon research and large projects |
| Loadouts | Curated proven presets | Module decisions | Broad specialist configurations |
| Diplomacy | Default off | Optional scenarios | Optional alliances, trade, espionage |
| Victory | Rapid annihilation or control | Strategic objectives | Sandbox, custom, megaproject, formal win if desired |

Duration is a design distribution, not an automatic timer. Do not create longer games just by inflating unit HP, production times and prices. Expand breadth of consequential decisions, maps and fronts.

### 2B. chassis_scale (unit size)
**MIN, MID and MAX also denote chassis/platform sizes**. These are **not** technology tiers, combat ranks, unit archetypes, or match-scale restrictions. A MIN chassis can remain valuable through MAX play. A MIN match may contain MAX chassis if its validated tech/scenario explicitly permits them. The two names require different enums, UI labels and telemetry.

### 2C. Orthogonal mode axes
Match generation concept:
`scenario + session_context + match_scale + control_preset + objective_ruleset + map + players/controllers + validated overrides -> resolved_match_config`.
- Session context: campaign, skirmish, multiplayer.
- Control preset: autonomous RTS, classic manual RTS, Architect, Commander, Avatar, Hybrid, Sandbox.
- Objective ruleset: annihilation, territory/control, assault, escort, extraction, custom.
- Teams: 1v1, 2v2, 3v3 ranked aspiration, 3v3v3 showcase aspiration, other sizes.
- Controller slots: human, scripted/heuristic AI, LLM. Shared faction play is allowed conceptually.
- Orthogonal flags: base_ai, strategy_ai, worker_ai, combat_ai, possession, roles, fog, economy, tech, map, pause, seed, replay.
- FPS / LLM features must be explicitly feature-gated; no impossible combinations or implicit privileges.
- Ranked playlists lock compatible settings; custom/sandbox can experiment.

## 3. Three factions and their identities
| Faction | Identity | Economic topology | Power window (hypothesis) | Preferred flavor, not forced role |
|---|---|---|---|---|
| **Organs** | Predatory living swarm, organic mutation | **Rooted Nexus-linked living vessel branches; distant expansions need repeated home nourishment; severed branches wither after grace** | Early pressure | Architect |
| **Manus** | Modular industrial colonists and combined arms | **Modular repositionable composite bases, independent outposts, optional corridors; repairable machines** | Mid-game | Commander |
| **Eters** | Ancient psionic/resonance civilization | **MID cargo/turret pylons + MAX Nexus-class hubs; initial home knowledge and conditional unknown-blueprint syncing; exposed blue build beams** | Late game | Avatar |

All factions can perform all jobs, use every gameplay control surface and win in early/mid/late play. Affinity and power windows are character, not automatic score multipliers. Organ mutation can be irreversible; Manus modules configurable; Eter transformations expensive and reversible where designed. Each needs counterplay against rush, siege, turtling, stealth and logistics disruption.

## 4. Three resources and physical economy
**Exactly three primary resource currencies: Matter (T1), Volatiles (T2), Energy (T3).**
- Each is storable, spendable and transportable, with inventory accounting and real delivery.
- Energy does **not** require a universal power grid. Lava can generate geothermal Energy; lava is not a fourth resource.
- Specialized sites, recipes and equipment consume/convert resources through explicit cost rules.
- Miners, builders, carriers, factories and depots need valid assignment, physical reach, capacity and scheduling.
- Production chains should remain shallow in MIN and much more configurable in MAX.
- MIN may simplify transport topology and UI but **not** invent resources or teleport inventory.
- A severed bridge, captured depot or blocked route must interrupt actual factory supply until bypassed, reconnected or replaced.
- Do not mistake intermediate crafted components for additional required globally tracked currencies.

### Inspiration synthesis
- **Settlers I:** autonomous professions and work cycles.
- **Settlers II:** roads/flags/carriers, depots, warehouses, border control and geographical economics.
- **Factorio:** throughput, bottlenecks, production optimization.
- **Transport Tycoon Deluxe:** capacity-aware freight networks and long-term infrastructure.
- **Dungeon Keeper:** autonomous workers, repair/build priorities and visible needs of functional base infrastructure.
- **Z:** controlling a point changes access to production or strategic routes.

### System layers (recommended)
Economy state -> inventories, recipes, reservations, logistics graph.
Strategic planner -> chooses expansion and budget priorities, within player constraints.
Operational scheduler -> construction, hauling, repairs, tech and defense tasks.
Tactical/unit AI -> pathing, combat, harvesting, transport and doctrines.
All orders pass an authoritative validator. Human override is protected and explainable.

## 5. Territory, terrain and Civilization strategy
- **Territory:** sectors and strategic points matter through factories, resources, chokepoints, depots, relays and functional bases; not every building should be captured by touching a universal flag.
- **Terrain:** elevation, cover, passes, bridges, tunnels, coastline, islands and drifting asteroids affect placement, pathing, line of sight and logistics.
- **Faction capture flavor (proposed):** biomass assimilation for Organs, hacking/occupation for Manus, resonance control for Eters.
- **Civ I/II inspirations:** technology tree and prerequisites; fog/exploration memory; founders/engineers; colony specialization; treaties, trade and intelligence; megaprojects/wonders; long-horizon victory conditions.
- **Real-time translation:** strategic research/diplomacy runs slower than combat; no imported turn structure, historical governments, new happiness micro-simulation or obligatory culture statistics.
- Diplomacy, espionage, government analogues, stability and megaprojects are **proposed/deferred**, mostly MAX or scenario-specific MID—not needed in MIN.

## 6. Three complementary human roles
- **Architect:** policies, building, processing chains, depots, supply and economic analysis.
- **Commander:** scouts, army composition, formations, defensive posture, objectives and map control.
- **Avatar:** possess a compatible unit; directly fight/drive/fly as part of the actual RTS simulation.

One person may switch among roles; multiple human players may share one faction. Roles do not mandate exactly three humans, nor hard-lock any faction to a role. Permission policy for simultaneous human/AI orders needs engineering before larger multiplayer.

Authority intent: possession > protected human manual order > strategic AI authorization > unit doctrine > idle. Use ownership/locks/expiry instead of immediate AI reversal. Human may use full-manual play; strategic AI cannot build/expand while off.

## 7. Seven unit archetypes and 63-template catalog
Warcraft II-like simplicity: one worker, basic melee soldier, basic ranged soldier, artillery/siege, tank/breakthrough, flyer, special/support unit. A **role** is not a movement domain or chassis size.

| # | Archetype | Function | Warcraft II inspiration |
|---|---|---|---|
| 1 | Worker | Extract/haul/build/repair with proper equipment | Peasant/Peon |
| 2 | Fighter | Basic melee line | Footman/Grunt |
| 3 | Shooter | Basic direct ranged combat | Archer/Axethrower |
| 4 | Artillery | Siege, indirect fire, area denial | Ballista/Catapult |
| 5 | Tank | Defense, breakthrough, screen | Knight/Ogre |
| 6 | Flyer | Air-focused recon/strike/transport | Gryphon/Dragon |
| 7 | Specialist | Faction utility, control, sabotage or support | Mage/Death Knight |

**7 archetypes × 3 chassis sizes × 3 races = 63 named baseline templates**. Their names and stats are draft, not final production commitments.

### Complete roster (MIN / MID / MAX chassis)
| Role | Organs MIN / MID / MAX | Manus MIN / MID / MAX | Eters MIN / MID / MAX |
|---|---|---|---|
| Worker | Sporeling / Harvester / Brood Carrier | Utility Drone / Engineer Rig / Mobile Constructor | Wisp / Shaper / Resonance Architect |
| Fighter | Clawling / Ravager / Behemoth | Marine / Assault Trooper / Siege Walker | Blade Adept / Templar / Ascendant |
| Shooter | Spitter / Acid Hunter / Corrosive Hive | Rifleman / Gunner / Fire Support Rig | Spark Adept / Pulse Weaver / Storm Conduit |
| Artillery | Spore Caster / Bile Lobber / Siege Organ | Mortar Drone / Mobile Howitzer / Siege Platform | Resonance Orb / Prism Caster / Celestial Array |
| Tank | Carapace / Bulwark / Colossus | Shield Trooper / Battle Tank / Land Fortress | Ward / Aegis Guardian / Monolith |
| Flyer | Mothling / Razorwing / Sky Brood | Scout Drone / Gunship / Heavy Carrier | Glimmer / Sky Sentinel / Astral Vessel |
| Specialist | Parasite / Mutator / Hive Mind | Saboteur / Field Engineer / Command Platform | Seer / Phase Weaver / Oracle |

The baseline YAML uses deliberately conservative domain profiles; specialized versions adapt domains and weapons through mutations/modules/resonance. Tank is a combat role, not MAX chassis. Flyer is a role, not exclusive ownership of air movement. Only templates explicitly tagged **deployable** may turn into buildings (legacy DEC-002), subject to placement, cost and time.

## 8. Movement and attack domains: LAND, WATER, AIR
The three labels describe gameplay environments rather than literal states of matter. Water means a fluid/aquatic domain, air an aerial domain, and land a supported surface. Separate future refinements may distinguish water surface vs submerged, altitude, orbital/vacuum or lava without multiplying current baseline categories prematurely.

### Seven meaningful movement sets
| Code | Land | Water | Air |
|---|---|---|---|
| ground | Yes | No | No |
| aquatic | No | Yes | No |
| aerial | No | No | Yes |
| amphibious | Yes | Yes | No |
| air_ground | Yes | No | Yes |
| air_water | No | Yes | Yes |
| omnimodal | Yes | Yes | Yes |

Each unit independently declares:
1. `movement_domains`: where it can physically traverse/operate.
2. `melee_targets`: domain(s) it can engage in close combat.
3. `ranged_targets`: domain(s) its installed ranged equipment can engage.

An airborne unit does **not** automatically shoot air targets; a land unit may have anti-air weapons. A unit may have no melee or no ranged attack. A domain target permission does not guarantee range, detection, accuracy, line of sight or hitting submerged/fast targets. A flying unit above land does not automatically possess ground movement; air-ground means it can actually transition/operate on ground.

### Proposed specialization examples
| Loadout | Move | Melee target | Ranged target |
|---|---|---|---|
| Manus Anti-Air Gunner | Land | None | Land, Air |
| Organ Amphibious Ravager | Land, Water | Land, Water | None |
| Eter Sky Sentinel | Air | Air | Land, Water, Air |
| Manus Gunship | Air | None | Land, Water |
| Organ Spore Caster | Land | None | Land, Water |
| Eter Omnimodal Specialist | Land, Water, Air | Land, Water | Land, Water, Air |

### Balance rules
- Extra movement environments cost capacity, modules, speed, resources or specialization.
- Anti-air costs a suitable targeting/weapon capability, not a blanket rule.
- Artillery pays in reload, minimum range, supply or vulnerability.
- Tanks pay in mobility/expense/size; massive chassis are not universal upgrades.
- Omnimodal units are rare, expensive or weaker in focused engagements.
- All three domains need counters within each faction; amphibious gameplay needs explicit transition/pathing.
- Ammo and special actions respect the three-resource economy; no uncapped resource generation.
- This is a **combat capability schema**, not finalized weapon-stat balance.

## 9. Autonomous AI and LLM agents
### Built-in non-LLM autonomy (core)
The game should remain playable entirely offline using scripted/deterministic AI. Its strategic planner can build and expand automatically by default. Workers carry out orders; they are not themselves grand strategists. The player may choose policy presets (expand, fortify, tech, rush, balanced), approve actions, take manual control, or disable autonomy.

### LLM participation (optional)
Modes include human + LLM teammate, human versus LLM, multiple LLMs sharing a faction with explicit scopes, LLM vs LLM vs LLM spectator, tournament, simulation sandbox and replay analyst. Model providers may be local or hosted; classical bots are baseline comparators.

### Safety/architecture contract
**Bounded faction observation -> LLM strategic decision -> typed Agent API -> game authority validator -> deterministic simulation.**
- LLM never directly edits state, gets opponent hidden data, bypasses fog or obtains unrestricted host file/network access.
- Separate prompt-injection defenses for untrusted diplomacy/chat content.
- Rate-limit tokens, calls, latency, actions and money; no per-frame model calls for FPS or movement.
- On timeout or invalid output, use safe fallback (last valid plan, heuristic bot or idle according to preset).
- Record model outputs/accepted actions with their simulation ticks for faithful replay: a fixed seed alone cannot reproduce a nondeterministic LLM response.
- Keep LLM tournaments separate from ranked human balance until fair rules exist.
- Observer panel can inspect economy, map, territory, events, tech, decisions and token/cost telemetry as permitted by visibility settings.
- The LLM cannot become an implicit requirement for MIN or the base game.

## 10. Cross-layer technical architecture (proposed)
- One authoritative simulation owns economy, map, combat, unit domains, ownership, fog and validated orders.
- Controller-neutral action schema used by UI players, scripted agents and LLM adapters.
- Deterministic headless tests for gameplay and replay; asynchronous hosted models never block the sim tick.
- Readable retro RTS presentation first. Future FPS Avatar is a viewport/controller onto the same world, not a second separate economy/combat game.
- Faction policies and module loadouts remain data-driven.
- Map/environment system handles domain traversal, transitions, cargo movement and combat targeting under shared constraints.
- Engine choice remains open: candidate research includes Godot 4, Recoil and Babylon.js. Choose by identical test tasks, profiling, headless validation and future FPS feasibility, not a popularity vote.
- Visuals and UI should be readable at a glance; no overly complex inspector screens by default.

## 11. Recommended implementation roadmap (not dates)
**P0 — technical proof:** deterministic headless sim and action schema; selection/input; pathfinding/domain legality; replay; compare engines.
**P1 — MIN vertical slice:** one representative faction, three resources, one compact map, functional autonomous workers/base planner, a scripted enemy, small combat roster and objective.
**P2 — MIN complete:** all three factions, initial 7 MIN-chassis archetypes per faction (**21 templates**), simple land/air counters, an amphibious prototype, readable tech/territory objectives, human playtests. Target 20–40 min and benchmark the 25–40 standard 1v1 subtarget.
**P3 — MID:** multiple bases, differentiated logistics, depots and supply cuts, unit MID modular loadouts, branching tech, terrain engineering and objectives; target 40–80 min.
**P4 — LLM optional beta:** controller-neutral provider adapter, one strategic agent, constrained observations, resilient fallback, headless bot-vs-bot observer, metrics. This can progress after the action API stabilizes, parallel to later gameplay work.
**P5 — MAX:** long-running freight/industrial economy, many colonies, extended research, megaprojects, optional diplomacy, save/resume and model civilization lab. No obligatory end timer.
**P6 — hybrid/direct and multiplayer expansion:** first-person possession on authoritative RTS simulation; faction-specific locomotion; larger shared-role multiplayer (3v3 competitive goal; 3v3v3 showcase); robust permission and arbitration rules.

Feature sequence is a recommendation, not a claim that all features exist. The full 63-template design catalog is **not** an Alpha shipping checklist.

## 12. Balance and usability test plan
Quantitative metrics:
- Match duration p10/p50/p90 by MIN/MID (not hard-cap).
- Faction matchup wins, by map, mode, seed and player/agent skill.
- First skirmish, first outpost, first Volatiles/Energy, tech progress, objective completion, stalemates, comebacks.
- Resources created/consumed/stored, idle time, route utilization, factory blocked time and repair/reroute recovery.
- Land/water/air usage distribution, invalid melee/ranged orders, anti-air effectiveness, amphibious transitions.
- Player action burden and clarity: time to understand a blocker, manual override churn, number of required micro-orders.
- LLM: valid-action rate, inference latency, tokens/cost, timeouts, wins across matched seeds and identical visibility.

Acceptance examples:
- MIN is satisfying without manually assigning every carrier.
- AI builds a working base with legitimate visible resources, in the same rules as humans.
- Full manual does not cause autonomous expansion.
- Losing a bridge/depot can break a real supply chain; AI can reroute if possible.
- No land-only melee attack can hit air unless a specific ability grants it.
- Amphibious mobility is terrain-aware and does not teleport.
- A replay with recorded LLM actions does not requery the provider.
- Disabling LLM/FPS/advanced diplomacy never prevents a standard MIN match.
- Every faction can field counters for all attack domains represented on a map.
- MIN match_scale and MIN chassis_scale remain distinguishable in configuration and UI.

## 13. Scope control: what not to build prematurely
- No Dwarf Fortress-style individual needs, per-limb simulation, happiness spreadsheets or huge ingredient catalogs.
- No requirement that every unit can both melee and shoot in all domains.
- No assumption that every one of 63 designs is a unique engine subsystem.
- No promise that all 7 movement combinations ship in MIN, nor that all 63 variants ship at launch.
- No mandatory FPS, LLM, diplomacy, multiplayer ranked infrastructure or megaprojects for the first complete RTS.
- No forced switching among Architect/Commander/Avatar.
- No magical lossless cargo shortcuts to hide economic complexity.
- No technology tier or match scale inferred solely from unit chassis size.

## 14. Decision inventory
### Approved directions
Three factions; three primary resources; 7 archetypes and 3 chassis scales per faction as the proposed full design catalog; independent movement/melee/ranged target domain model; autonomously developed bases with full manual option; MIN 20–40, MID 40–80, MAX long-running; optional LLM partners/competitors/observer simulations; classic RTS first with possible FPS possession later.

### Important proposals
All unit names and default profiles, exact counters, anti-air ammo, complexity gates per scale, API names, AI planner scheduling, hardware performance caps, default tech breadth, special abilities, domain refinements, MAX objectives and roadmap milestones.

### Unresolved design questions
1. Naval water surface vs underwater differentiation and whether water gameplay ships in MIN.
2. Minimum viable roster, air detection and anti-air defaults; availability of chassis sizes by match scale.
3. How much of unit design is fixed faction biology versus Manus modules versus Eter transformation.
4. Whether additional terrain layers (underground/orbit) are map locations or combat domains.
5. Actual resource costs, recipe counts, carrier payloads, transport latency and unit HP.
6. First victory condition, stalemate prevention, standard map count and map symmetry.
7. Default LLM observation frequency, human/agent conflict arbitration and tournament fairness.
8. Engine selection based on measured prototype performance.
9. Save/pause rules for long-running multiplayer MAX.
10. Role permissions and shared faction control, especially simultaneous humans and AI.

## 15. Source of truth and follow-on documents
- [Unit roster, movement domains and combat targeting](unit-domains-and-archetypes.md)
- [Machine-readable unit taxonomy with all 63 variants](unit-domains-and-archetypes.yaml)
- [Match scale and duration balancing](match-scale-min-mid-max.md)
- [Draft scale presets](scale-presets.example.yaml)
- [Consolidated roadmap/recommendations](recommendations-and-roadmap-2026-10.md)
- [Legacy design decisions](decisions-v0.4.md)
- [Scale decision reconciliation](scale-decisions-2026-10-11.md)
- [Autonomous gameplay and mode rules](autonomous-gameplay-and-modes.md)
- [Sample match configuration](match-config.example.yaml)
- [Gameplay roles and faction affinities](gameplay-roles.md)
- [Settlers-inspired logistics](settlers-logistics.md)
- [Civilization I/II-inspired strategy](civilization-strategy.md)
- [LLM agents and civilization simulations](llm-agents-and-simulation.md)
- [Example LLM match](llm-match.example.yaml)
- [Cross-game inspiration research](../research/gameplay-inspirations.md)
- [Engine selection research](../research/engine-selection-357.md)

### Next recommended deliverable
A **MIN Alpha executable vertical slice specification**: small fixed roster and map, exact resource costs, AI planner order schema, legal land/air targeting and test scenarios. Keep speculative MAX mechanics as optional extensions, not dependencies.
