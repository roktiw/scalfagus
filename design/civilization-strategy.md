# Civilization I/II-Inspired Strategic Layer
Date: 2026-10-11
Status: inspiration approved for exploration; mechanics and scores are proposals.

## Intent
Bring long-horizon civilization-level decisions from Civilization I (1991) and Civilization II (1996) into Scalfagus' real-time, three-faction RTS. Do not import turns, historical technology names, historical governments, or Civ's city-population economy verbatim. Strategic planning runs at a slower cadence than combat and physical logistics.

## Transfer matrix
| Inspiration | Scalfagus mechanic | Priority |
|---|---|---|
| Technology tree | Branching research prerequisites, faction specialization, unlockable MIN/MID/MAX equipment and base systems | 7/7 |
| Exploration and fog of war | Per-faction discovered/visible/remembered map, scouts, sensors, intelligence uncertainty | 7/7 |
| Settlers/Engineers | AI-led founding and improvement of outposts, infrastructure, bridges, tunnels and defenses | 7/7 |
| City specialization | Military, industrial, logistics, research and sensor outposts with real transport dependencies | 7/7 |
| Diplomacy | Negotiation, treaties, ceasefires, alliances, trade, betrayal and reputation | 7/7 |
| Long-horizon development | Strategic research/economy/territory/military priorities and measurable progress | 7/7 |
| Wonders | Unique faction megaprojects with meaningful opportunity cost and counterplay | 6/7 |
| Government types | Faction policy/doctrine regimes influencing AI behavior and tradeoffs, not historical governments | 6/7 |
| Trade | Negotiated exchanges of Matter, Volatiles and Energy with physical deliveries | 6/7 |
| Espionage | Scouting, infiltration, intelligence theft, disruption and counterintelligence with fog-of-war limits | 6/7 |
| Happiness/disorder | Optional faction-appropriate stability, morale or cohesion; avoid mandatory micromanagement | 4/7 |
| Multiple victory conditions | Military dominance, territory, objectives, megaproject, ascension or scenario victory | 7/7 |

## Historically grounded design references
Civilization I's original manual describes Settlers founding cities and improving land, Diplomats establishing embassies, stealing technologies and sabotaging production, and caravans/trade. Its technology and government choices influence units and city improvements. Civilization II's manual documents research advances, wonders, diplomacy, trade and city management. These are references for *inspiration*, not evidence that Scalfagus mechanics already exist.
- https://civfanatics.com/content/civ1/manual/civ1_man.htm
- https://steamcdn-a.akamaihd.net/steam/apps/3910/manuals/manual.pdf?t=1531947942

## Real-time translation
- Strategic planner ticks at a configurable low frequency or event-driven cadence.
- Operational planner allocates research, construction, logistics and defense budgets.
- Unit AI executes valid tasks at simulation tick rate.
- Human may choose a technology, policy, megaproject or diplomatic offer directly, or delegate each subsystem.
- Research should have explicit costs and prerequisites; consider using the existing three resources and generated research progress, not automatically inventing a fourth stored resource.
- Treaty enforcement and alliance information must be server-authoritative in multiplayer.
- Different victory rulesets must be configurable and tested.

## Faction-specific strategic identity
- Blergians: organic adaptation, biomass network expansion and assimilation; distant isolated colonies are weak.
- Manusians: modular technology, distributed independent outposts, engineering and combined arms.
- Aetherians: resonance research, linked satellites, meditation/ascension and high-value transformations.
Each faction can play all roles and must retain viable early/mid/late strategies.

## Integrating the rest of the inspiration map
- Settlers I/II + Factorio: physical inventories, carriers, production chains, depots and bottleneck analysis.
- Dungeon Keeper: autonomous workers, training, base functionality and intervention.
- Z: contested sectors and infrastructure with dynamic frontlines.
- Earth 2150: unit configuration, resupply, terrain engineering, multi-layer maps.
- Warcraft II/StarCraft: readable real-time interface, orders, combat and asymmetry.
- Battlezone II/Machines: strategic-to-direct-unit possession.
- Aliens vs Predator: three distinct FPS experiences.
- Wolfenstein Enemy Territory / Quake Wars: objective-based asymmetric teamwork and deployables.
- Tribes 2 / Quake III: vertical terrain and responsive direct movement.

## Scope and acceptance experiments
1. AI selects a research path and completes prerequisite-driven unlocks without violating budgets.
2. A specialized outpost contributes to the actual economy and can be starved by severed supply.
3. Diplomacy changes validated permissions and relationships; a broken treaty is observable.
4. A megaproject has visible resource costs, timing and possible counterplay.
5. Full manual mode can control all strategic actions without mandatory AI decisions.
6. A fixed simulation seed and identical order log yield reproducible outcomes.

Open issues: research production mechanics, diplomacy vocabulary, faction stability, treaty duration, megaproject uniqueness, ranked balance and map knowledge.
