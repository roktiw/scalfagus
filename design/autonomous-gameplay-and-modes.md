# Scalfagus — Autonomous RTS, Tactical FPS, and Game Modes
Date: 2026-10-11
Status: direction approved by project owner; details below labeled proposals where appropriate.

## Central design pivot
Default play is **AI-led base development with human assistance and intervention**. The faction's AI plans, constructs, operates, expands and defends its infrastructure while human players guide priorities, override choices, command forces or possess units. This is a gameplay AI, not a requirement for an LLM or online inference. AI must be observable, interruptible, explainable and bounded by resources, fog of war, map rules and player constraints.

**Manual play is equally supported.** Autonomy and possession are independent match flags; neither should be mandatory. The same simulation rules must work with AI or human issuing valid orders.

## Inspiration and intended design transfer
| Inspiration | Transfer to Scalfagus | Not a commitment |
|---|---|---|
| Aliens versus Predator (1999) / Aliens versus Predator 2 (2001) | Three radically different playable FPS species, movement, sensing, traversal and combat; interwoven faction perspectives | No copied IP, models or characters |
| Return to Castle Wolfenstein (2001) | Readable, responsive classic FPS gunplay and atmosphere | Not necessarily a class/objective multiplayer template |
| Wolfenstein: Enemy Territory (2003) | Class-based teamwork, engineer/medic/support roles, objective-driven combat, deployables and field repairs | No rigid class lock |
| Enemy Territory: Quake Wars (2007) | Asymmetric team roles, vehicles, objective chains, deployables, territory logistics and large-scale battle | Not necessarily identical player counts |
| Dungeon Keeper (1997) | Autonomous workforce, training, task priorities, base synergies, possession, player intervention | Not an exact creature-needs simulation |
| Warcraft I/II, StarCraft | RTS ergonomics, map, production, orders, fog of war | No forced manual micromanagement |
| Factorio | Logistics, resource throughput, worker automation and bottlenecks | No mandatory conveyor-belt micromanagement |

Historical references: https://www.mobygames.com/game/5493/aliens-versus-predator-2/ ; https://www.mobygames.com/game/30407/enemy-territory-quake-wars/ .

## Distinct FPS identities — proposals
- **Organs:** predatory organic locomotion; rapid close combat, wall/ceiling traversal for equipped forms, scent/biological sensing, swarm coordination, asymmetric hitboxes and movement. No universal human-style gunplay.
- **Manus:** precise weapon handling, equipment, squads, deployables, repair, transport and combined arms. Strongest conventional tactical FPS.
- **Eters:** psionic mobility, resonance perception, energy management, temporary transformation, shielding and control effects; powerful but telegraphed abilities and counterplay.
These are flavor/ability directions, not guaranteed Alpha features. Each must support fair combat and readable audiovisual feedback.

## AI-led base management
The AI operates at **three levels**:
1. **Strategic planner:** proposes build goals, expansion, defensive posture and economy priorities subject to human policy and match permissions.
2. **Operational scheduler:** turns goals into build queues, resource budgets, logistics networks, repair priorities, scouting and unit production.
3. **Tactical/doctrine controller:** executes movement, combat, worker tasks and threat responses with faction-specific behavior.

Important distinction from earlier autonomy: worker-level autonomy alone did not choose strategic goals. **Newly approved default** adds a separately configurable strategic planner that *can* choose base development and expansion within player policy. Disabling that planner preserves previous bounded worker automation. Player orders take precedence according to explicit authority/conflict rules.

### Human–AI contract (proposed)
- Human may set goals such as **Fortify**, **Expand**, **Tech**, **Rush**, **Balanced**, or a custom policy.
- Human may set budgets, allowed regions, building bans, target priorities and risk tolerance.
- AI presents intent, estimated cost, prerequisites and current blockers; optional approval gates for irreversible/high-cost actions.
- Human can take over individual buildings, squads, logistics networks or the whole faction without restarting the match.
- AI hands control back with a snapshot of work in progress and must not instantly undo manual changes.
- AI must never have privileged map knowledge or free resources. If strategic AI is enabled in competitive play, its limits are part of the ruleset.

## Proposed control ownership model
Orders have issuer, authority, scope, timestamp/tick, priority and optional expiration. Strategic policy is distinct from manual orders, operational plans and unit doctrine. A manual lock or temporary reservation can protect human actions from planner overrides. Multiple human controllers require explicit conflict resolution later; never assume one player per faction.

## Orthogonal match flags (proposal; not finalized)
| Flag | Example values | Notes |
|---|---|---|
| `base_ai` | off / assist / autonomous | Off = fully manual construction |
| `strategy_ai` | off / suggest / execute | May choose expansion only when execute |
| `worker_ai` | off / doctrine / full | Resource jobs and autonomous local tasks |
| `combat_ai` | manual / doctrine / autonomous | Strategic decisions remain separately governed |
| `possession` | disabled / enabled | Independent of base AI |
| `possession_scope` | selected / eligible_all | Specialized unit eligibility |
| `player_roles` | unrestricted / advisory / enforced | Enforced RBAC later |
| `camera_modes` | rts / fps / hybrid | FPS depends on available implementation |
| `faction_selection` | fixed / draft / random | Balance-dependent |
| `teams` | 1v1 / 2v2 / 3v3 / 3v3v3 / custom | Players per faction are flexible |
| `objectives` | annihilation / control / assault / escort / extraction / custom | Mission script selects victory logic |
| `fog_of_war` | on / off / explored | Competitive presets enforce defaults |
| `starting_economy` | standard / accelerated / sandbox | Preset or custom values |
| `tech_progression` | normal / accelerated / unlocked | |
| `unit_progression` | on / off | Training/experience |
| `map_topology` | mainland / islands / asteroids / mixed | Scenario-specific |
| `ai_difficulty` | easy / normal / hard / custom | Must not imply cheating |
| `pause_policy` | unrestricted / vote / disabled | Campaign/skirmish/multiplayer |
| `match_seed` | integer | Reproducibility |
| `replay` | on / off | Competitive default on |
Flags are **composable but validated**: impossible or unimplemented combinations must fail early with readable errors. Some values imply feature gates (e.g., FPS not available in Alpha).

## Game mode presets (proposals)
| Preset | Description |
|---|---|
| Autonomous RTS | AI builds and operates; human directs strategy and tactical intervention |
| Classic RTS | All strategic and building actions manual; worker doctrine optionally on |
| Architect | Economy/logistics focus; AI combat may defend while player manages production |
| Commander | AI runs economy; human commands military |
| Avatar | AI runs base and armies; human directly controls eligible units |
| Hybrid | All three control surfaces available with configurable autonomy |
| Objective Assault | Enemy Territory-style multi-stage goals and role-specific tasks |
| Campaign | Narrative mission with authored objectives, cinematics and locked overrides |
| Skirmish | Local/custom match with configurable opponents and flags |
| Multiplayer | Human teams, shared faction control, server-authoritative validated rules |
| Sandbox | Economy experimentation, debug controls, no competitive ranking |

**Campaign / skirmish / multiplayer are session contexts**, while Autonomous RTS / Classic RTS / Avatar / Hybrid are control presets; Objective Assault is an objective ruleset. Do not model them as mutually exclusive game modes.

## Configuration composition
`scenario + session_context + control_preset + objective_ruleset + map + overrides -> validated_match_config`.
Resolution order should be explicit and deterministic; record resolved config and version with save/replay. Ranked playlists use locked server-side presets; custom lobbies may override compatible flags. A campaign may lock narrative-critical rules.

## Design risks
1. Autonomous AI must be **competent without becoming opaque**; player needs intelligible goals, status and intervention controls.
2. Manual vs AI control must not cause thrashing or duplicate build orders.
3. Objective FPS gameplay must affect the **same world** as RTS economy and structures.
4. Three FPS species require distinct cameras, traversal and animation, not cosmetic stat swaps.
5. Shared-faction multiplayer plus AI requires server authority and order arbitration.
6. Combinatorial flag explosion requires constraints, test matrix and preset-based QA.
7. Engine selection (Godot vs Recoil vs Babylon.js) must now test AI planner and direct possession architecture, but FPS remains post-MVP.
8. AI-vs-manual balance and competitive integrity require explicit playlist rules.

## Suggested incremental milestones
- **Alpha A:** single-map classic RTS controls, deterministic sim, 3 resources, basic worker jobs.
- **Alpha B:** autonomous base planner prototype (economy + build/repair) with transparent intent and manual override.
- **Alpha C:** configurable flags/presets, skirmish, automated bot-vs-bot simulation.
- **Later:** shared-faction multiplayer, objectives/classes, territory logistics, campaign scripting.
- **Post-MVP:** possession and three differentiated FPS movement/combat models; objective-driven hybrid matches.

## Acceptance tests
- Same seed and resolved config yield the same headless simulation outcome.
- AI autonomously builds a functional base from minimal starting conditions without cheating.
- Manual mode performs no AI-initiated construction or strategic expansion.
- Switching autonomous -> manual preserves existing orders and does not reissue forbidden tasks.
- Human manual order is not immediately overwritten by AI.
- Resource constraints, transport and connectivity rules apply equally to AI and humans.
- Invalid flag combinations return actionable validation errors.
- Every replay records preset, overrides, version and seed.
- In shared-faction scenarios, simultaneous conflicting human/AI orders resolve deterministically.
- Objective destruction/repair changes real RTS infrastructure and logistics state.

## Decision status
**Approved direction:** three new FPS inspirations; autonomous AI-led base as default; optional full manual and no-possession play; many flag-driven campaign/skirmish/multiplayer combinations.
**Proposed, awaiting design review:** flag names/values, AI policy UX, presets, objective rulesets, phase boundaries and detailed faction FPS abilities.
