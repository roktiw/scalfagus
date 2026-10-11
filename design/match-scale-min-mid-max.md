# Match scale: MIN / MID / MAX
Date: 2026-10-11
Status: approved direction; detailed balancing is a proposal.

## Product principle
Depth is optional; friction is not. One shared RTS simulation supports three scales. AI manages routine economy by default; humans can intervene or choose fully manual play. Avoid Dwarf Fortress-like compulsory micromanagement.

Match scale is a duration/complexity preset, NOT unit size. Field match_scale = min/mid/max; field chassis_scale = min/mid/max refers only to MIN/MID/MAX unit frames. Do not reuse one enum in game logic.

## Comparative target matrix
| Property | MIN | MID | MAX |
|---|---|---|---|
| Target duration | 20–40 min | 40–80 min | Open-ended / optional goals |
| Feel | Warcraft II, Z, StarCraft | Earth 2150, Settlers II, Dungeon Keeper | Factorio, Transport Tycoon Deluxe, Civilization |
| Main goal | Fast tactical victory | Multi-base strategic warfare | Industry/transport/civilization simulation |
| Bases | 1 primary + optional satellite | Several | Many specialized colonies |
| Canonical resources | Matter, Volatiles, Energy | Same three | Same three |
| Logistics | Automatic, short visible delivery chains | Multiple routes, depots, supply cuts | Freight capacity and network optimization |
| Research | Short and meaningful | Branching and specialized | Long-horizon, megaprojects |
| Units | Curated chassis loadouts | Modular configuration | Specialized module portfolios |
| Terrain | Height, obstruction, chokepoints | Bridges, tunnels, capture routes | Larger-scale engineering |
| Diplomacy | Default off | Optional | Optional rich AI diplomacy |
| LLM | Optional player/observer | Strategic counterpart | Civilization lab and tournaments |
| Victory | Combat / rapid control | Strategic control / objectives | Sandbox, custom milestones or formal victory |

Targets are not hard game timers. Features shown for MID/MAX are candidates, not shipping guarantees.

## Anti-bloat rules
1. Three canonical resources only. Processing may create components, but not dozens of mandatory new global currencies.
2. Deep subsystems need player-facing decisions, observable consequences and an AI default.
3. Progressive disclosure: MIN default HUD is sparse. Detail appears only on demand.
4. No obligatory unit hunger, toilet, personality micromanagement, granular injury, legal bureaucracy, large maintenance loops or excessive production recipes.
5. Physical inventories and supply still exist in MIN. Simplify initial topology, recipes, interface and routing; do not cheat or teleport resources.
6. Every factory stall must explain its cause. Human overrides must not be immediately reversed.
7. Never block the first playable MIN release on FPS possession, LLM, multiplayer role enforcement or diplomacy.
8. Every faction remains viable in each scale, era and playstyle.
9. Presets have validated custom overrides; ranked configurations are server-locked.
10. Campaign/skirmish/multiplayer and manual/autonomous/LLM controllers are independent axes.

## Timing and proposed balance
Historical DEC-004: standard 1v1 target 25–40 min. This remains a narrower hypothesis inside MIN's 20–40 minute envelope. Proposed MIN median ~30 min, MID median ~60 min; MAX has no fixed median. Do not lengthen MID simply by multiplying prices and hit points: add meaningful map fronts, logistics decisions and tech choices.

Match duration is jointly driven by geography, starting stocks, income, movement, production, victory rules, opponent strength and player count. Early Blergian / mid Manusian / late Aetherian power windows are flavor hypotheses, NOT predetermined wins. Each race needs opening survival, viable middle-game options and meaningful late-game counterplay.

## Calibration telemetry
Track duration p10/median/p90, faction-vs-faction results by map/scale/controller, first conflict, first new base, T2/T3 timings, tech decisions, stalemates, economy bottlenecks, route losses, unit-idle fraction, manual orders per minute, AI overrides, first meaningful player choice and comeback rates. Mirror map starts; run fixed-seed bot batches and human playtests separately. AI-only win rate is NOT human balance evidence.

Proposed go/no-go:
- Most balanced 1v1 MIN games conclude within 20–40 min, with exceptions understood.
- Most balanced MID games conclude within 40–80 min.
- A new MIN player need not route individual carriers to maintain a functioning economy.
- A stalled production chain explains its blocker within two UI interactions.
- Manual and AI orders obey identical cost, vision and ownership checks.
- MAX supports saving/resuming and sandbox without mandatory online inference.

## Scope phasing
MIN: retro RTS input/HUD, three resources, combat and fog, functioning AI-built base, worker jobs, limited research, curated unit loadouts, territory objectives.
MID: multi-base transport, interruption/recovery, meaningful module choices, strategic territory infrastructure, richer terrain and branching research.
MAX: long-running industrial networks, many colonies, optimization tools, optional diplomacy/megaprojects/LLM laboratory.
Future optional cross-cutting: direct FPS possession and shared-faction large multiplayer.

## Open questions
Exact roster/recipes/map counts, capture-victory conditions, ranked custom overrides, MAX formal wins vs free sandbox, economy performance at scale, research length, pause/save multiplayer, and final display names.

Related: decisions-v0.4.md, autonomous-gameplay-and-modes.md, settlers-logistics.md, civilization-strategy.md, llm-agents-and-simulation.md.
