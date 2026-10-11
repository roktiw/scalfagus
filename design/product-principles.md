# Scalfagus — Product Constitution and MVP Discipline

Date: 2026-10-11
Status: project direction, with implementation recommendations explicitly flagged.

## Promise: Simple Surface, Deep Simulation
Scalfagus is a classic 1990s-readable, isometric pixel-art RTS with a rich systemic core. A beginner should be able to select, build, harvest, order, attack and, when enabled, possess a unit without reading a simulation manual. Advanced players should uncover depth through **combinations** of terrain, production, transport, combat, tactics and agent doctrines, not endless compulsory panels.

Influences: Warcraft II, StarCraft I, Z, Dungeon Keeper I, Settlers II, SimCity, Transport Tycoon Deluxe, Factorio, tower defense, Realm of the Mad God, classic action RPG, Quake, Counter-Strike, Enemy Territory, AD&D and the owner's MTG-as-Code compositional philosophy.

## Three equal player fantasies on one simulated world
1. **Architect / Sim:** shape the economy and base, build roads/depots/defenses/traps, set priorities and watch meaningful automated work. Later: sprawling transportation and urban systems.
2. **Commander / RTS:** select squads, issue orders, harvest, train, position, scout, fight, micro, and optionally directly move/attack one unit in a simple **top-down/isometric action-RPG** control.
3. **Avatar / Possession:** take direct control of one eligible unit, initially a deliberately small Dungeon Keeper I-like first-person experience, with optional future third-person perspective and Quake/Enemy Territory-like depth later.

These are **interaction modes/roles**, not mutually exclusive game sessions or forced player classes. One human may switch among them; each uses the SAME units, world geometry, resource accounting, ownership, combat legality, fog, AI and health state. No one mode should secretly mint free units, resources or combat power.

## Mode boundaries are input/camera changes, not alternate game rules
- Architect issues build/priority/defense/transport commands.
- Commander issues group orders and optional direct top-down movement/aim commands.
- Avatar issues first-person movement, look/aim/fire/use commands to an eligible embodied unit.
- The same command validator, movement rules and combat system process all three.
- Prior autonomous jobs and strategic policies persist while a unit is possessed. The possessed unit receives a temporary exclusive manual-control lock; return releases it and applies a predictable doctrine/queued-order policy.
- The world continues while playing Avatar by default. A solo pause option is a separate scenario setting; possession must not freeze the simulation invisibly.
- Competitively, manual/direct control grants precision and attention cost but **not hidden map information, free ammo or damage multipliers**.
- Architect-only and Commander-only matches remain possible. Possession is optional in player-configurable full game; a single eligible FPS unit exists as a required MVP feature.

## Four engineering boundaries
**Sim:** authoritative grid/3D coordinates, fixed-step advancement, entities, resources, ownership, rules, validated commands, RNG seeding and reproducible scenario tests.

**View:** RTS camera, action-RPG camera and FPS/TPP camera are consumers of simulation, never sources of truth.

**Input:** mouse/keyboard/gamepad mapping creates legal commands, not direct unaccounted scene mutations.

**Policy:** per-unit autonomy and optional base/strategy AI choose commands through the same authority and cost checks.

Start with one in-process Godot/Recoil match. A network server, cloud architecture, LLM model provider or complete ECS framework is **not necessary** for the first playable test.

## Player-facing complexity progression
- **Play:** one-click jobs, build buttons, selection, health, resources, counter warnings, AI status summaries.
- **Master:** route and production priorities, target categories, doctrines, attachments, tactics, direct possession and detailed economy.
- **Engineer:** validated YAML definitions, deterministic logs, headless scenarios, balance metrics and optional future LLM policies.

These are disclosure levels, not paid or gameplay power tiers.

## Unit identity instead of superorganism
Specialized independent units with clear silhouettes/abilities remain fundamental. No race requires a literal hive mind, amorphous one-being consumption fantasy or loss of individuality. Players build armies/systems like decks of distinct useful MTG cards. Shared communications, network logistics, spell links and team AI can provide synergy without erasing local decision-making.

## Non-negotiable production discipline
- First proof: ONE map, ONE playable civilization, ONE possessed shooter, a few workers/enemies, simple RTS camera and direct control.
- Internal MVP: all three fantasies need a real gameplay loop; scope of art and roster is calibrated to staffing, not to the full 63-template design catalog.
- After proof: one complete three-resource economy, one combat/victory loop, readable original art and modest automation.
- Seven archetypes and three physical chassis are the **design taxonomy**, not a demand for every variation in the first proof.
- MIN match scale, MID and MAX scales differ from chassis MIN/MID/MAX and from UI/control modes.
- Fully differentiated additional civilizations, water navies, asteroid docking, complete factory-chain simulation, advanced FPS, and MMO-sized multiplayer are later milestones.
- Never over-engineer simulation determinism: begin with reproducibility on pinned runtime/hardware and explicit command/event records. Cross-platform lockstep is a later separately tested requirement.

## Acceptance questions for new mechanics
Can a novice read its effect? Does a unit/role still have individual identity? Is this a genuinely new decision, not one more chore? Does the AI perform the routine form? Can it be tested with one map? Does it share the same entity/resource/weapon rules? Can it ship later without rewrites?

Related:
- [Three Pillars Control Contract](three-pillars-one-world-control-contract.md)
- [Realistic MVP](mvp-iso-pixel-rts.md)
- [Individual Agency](individual-agency-and-composable-civilizations.md)
- [Design Bible](scalfagus-design-bible-2026-10-11.md)
