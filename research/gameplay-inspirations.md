# Scalfagus — Gameplay Inspiration Map
Date: 2026-10-11
Status: design research and prioritization; adaptations are original Scalfagus proposals.

## Design thesis
One shared simulation with three human interfaces: Architect (economy and autonomous base), Commander (classic RTS), and Avatar (direct possession/FPS). Default gameplay is AI-led base development with optional human intervention. Full manual RTS, no-possession, AI-assist, campaign, skirmish and multiplayer remain configurable. References are inspirations, not requests to copy IP or reproduce mechanics verbatim.

## Inspirations and design transfer
| Game | Main transferable concept | Priority /7 | Target system |
|---|---|---:|---|
| The Settlers (1993) | Autonomous workers, production chains, settlement flow | 7 | Architect/economy |
| The Settlers II (1996) | Roads, flags, carriers, warehouses, physical logistics, borders | 7 | Logistics/territory |
| Earth 2150 (2000) | Unit constructor, terrain engineering, tunnels, resupply, multi-layer warfare | 7 | Unit designer/terrain |
| Z (1996) | Territory capture, factory control, proactive unit behavior, dynamic frontlines | 7 | Territory AI |
| Dungeon Keeper (1997) | Autonomous workforce, training, functional base rooms, possession | 7 | Unit AI/base/Avatar |
| Factorio | Production throughput, logistics automation, bottleneck optimization | 7 | Economy |
| Battlezone II: Combat Commander (1999) | FPS/RTS crossover, pilotable units, base production in shared battlefield | 7 | Commander/Avatar |
| Machines: Wired for War (1999) | Possess RTS units from first-person perspective | 7 | Avatar |
| Aliens versus Predator (1999), Aliens versus Predator 2 (2001) | Three truly distinct playable species, locomotion, senses and combat | 7 | Asymmetric FPS |
| Enemy Territory: Quake Wars (2007) | Asymmetric classes, vehicles, deployables, objective chains and logistics | 7 | Objective multiplayer |
| Wolfenstein: Enemy Territory (2003) | Engineer/support roles, sabotage, repairs, cooperative objectives | 6 | Teamplay |
| Tribes 2 (2001) | Terrain, large maps, vertical mobility, sensors, generators, deployables | 6 | FPS terrain/control |
| Parkan: Iron Strategy (2001) | Customizable robots, equipment and direct control | 6 | Units/Avatar |
| Warcraft I/II | Classic RTS UX, selection, orders, groups, map readability, retro art | 7 | Commander/UI |
| Planet X16 (2023) | Compact readable retro RTS pixel art, tangible resource pickup/drop to processing, economy/defense dependencies, mouse-first orders | 7 (inspiration relevance, not sprint priority) | Pixel art / logistics / Commander UX |
| StarCraft (1998) | Strong faction asymmetry, counters, timing and strategic clarity | 7 | Combat/balance |
| Return to Castle Wolfenstein (2001) | Responsive FPS feedback, atmosphere, weapon readability | 5 | Avatar |
| Quake III Arena (1999) | High-skill movement and aiming, immediate input response | 5 | Avatar |

## Planet X16 — owner-added inspiration (2026-10-12)

[Dedicated source-based reference and Scalfagus transfer boundaries](planet-x16-rts-inspiration-2026-10-12.md). This is David Murray / 8-Bit Productions' modern **Commander X16 RTS**, spiritually succeeding Planet X3, **not a game released in the original 1990s**. Learn from clear tiny sprites, physical mineral carrying and drop-off to a Smelter, compact building/energy feedback, accessible selection/hotkeys, and mode clarity. **Do not copy** maps, interface, characters, sprite art, buildings, code, stats, no-fog-of-war policy or fixed first-attack timing. Our Godot isometric/5-view art contract and DEC-033 MVP0 scope remain unchanged.

## Cross-game synthesis
- **The Settlers II + Factorio:** physical logistics with inspectable throughput, buffers, and automation.
- **Planet X16 + Warcraft I/II:** a low-pixel-count RTS can show understandable workers, pick-up/drop-off logistics, buildings, minimap and commands with minimal visual noise; Scalfagus adds original factions and 5-view isometric sprites.
- **Dungeon Keeper + The Settlers:** autonomous units and AI-led base operations, with human intervention.
- **Z + The Settlers II:** territory capture matters because it changes infrastructure and real supply lines.
- **Earth 2150 + Scalfagus MIN/MID/MAX:** chassis-scale unit designer, equipment-based jobs and terrain-sensitive deployment.
- **Battlezone II + Machines + Dungeon Keeper:** switching between strategic command and direct unit control in one authoritative simulation.
- **AvP + Quake Wars + Enemy Territory:** asymmetric species-specific FPS, role-based objective play, engineers, deployables, sabotage, support.
- **Tribes 2 + Earth 2150:** terrain as tactical infrastructure, not a cosmetic stat bonus.

## Seven defining pillars
1. Autonomous Base AI.
2. Dynamic Territory Control.
3. Modular Unit Designer.
4. Terrain Engineering.
5. Physical Logistics.
6. Asymmetric Faction Simulation.
7. RTS-to-FPS Possession.

## Faction adaptation
Blergians: organic, network-dependent infrastructure; adaptation, biomass assimilation and predatory traversal.
Manusians: modular machines, distributed outposts, engineering, combined-arms tactics and conventional equipment.
Aetherians: resonance-linked satellites, psionic sensing, transformations and high-value direct-control units.
Every faction must remain viable in Architect, Commander and Avatar play, with distinct strengths rather than mandatory roles.

## Player agency and match modes
Control axes are independent: base_ai, strategy_ai, worker_ai, combat_ai, possession and player role permissions. Campaign, skirmish and multiplayer are session contexts, not mutually exclusive control modes. Objective Assault, Annihilation and Territory Control are separate victory rulesets. Competitive presets can lock flags; custom lobbies can compose validated combinations.

## Scope and risks
- Alpha is RTS-first: responsive UX, deterministic economy, worker autonomy, three resources and a first AI base planner.
- Multiplayer with multiple players sharing a faction is a technical proof point, not assumed solved.
- Detailed Quake-like FPS possession is post-MVP; do not choose the engine solely for it.
- Terrain engineering and arbitrary unit design can greatly expand pathfinding, balance and testing complexity; prototype incrementally.
- Priorities /7 measure inspiration relevance, not feature approval, delivery commitment or game balance.
- Avoid copying protected assets, maps, distinctive character designs or other IP.

## Concrete design experiments
A. AI creates a functioning base using Matter extraction and depot deliveries, with player override.
B. A contested territory node changes ownership and redirects real factory output and supply.
C. One MIN/MID/MAX chassis supports two equipment-based roles, with transparent resource cost.
D. Blocking a bridge or pass interrupts logistics and triggers a valid AI reroute.
E. Switching RTS -> possessed unit -> RTS preserves orders and world state (future prototype).
F. Campaign/skirmish/multiplayer presets resolve to validated, replayable match configurations.

Related: design/settlers-logistics.md; design/autonomous-gameplay-and-modes.md; design/gameplay-roles.md; research/engine-selection-357.md.
