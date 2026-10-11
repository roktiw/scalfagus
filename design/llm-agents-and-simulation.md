# LLM Partners, Opponents and Civilization Simulation Lab
Date: 2026-10-11
Status: approved product direction; API, metrics and implementation details are proposals.

## Vision
A human may play with one or several LLM teammates, play against LLM-controlled factions, or observe an entirely autonomous simulation. Support locally hosted models and API models behind the same provider-neutral adapter. Traditional scripted/heuristic agents must remain available for baseline comparisons and offline gameplay. LLM participation is optional and not required for core simulation.

## Session patterns
| Pattern | Human | AI |
|---|---|---|
| Human + LLM | Commander, Architect or Avatar | Delegated strategic/base/logistics duties |
| Human + multiple LLMs | Any role | Different delegated domains with explicit ownership |
| Human vs LLM | Human faction | Rival faction controlled by LLM |
| LLM vs LLM vs LLM | Observer | Three independently controlled civilizations |
| Tournament | Observer or none | Automated multi-seed matches and evaluation |
| AI Sandbox | Experiment operator | Models execute constrained plans under configurable rules |
| Replay analysis | Viewer | Optional commentator/analyst (not authoritative simulation controller) |

## Architecture
**LLM strategic planner -> validated typed Agent API -> deterministic simulation -> compact observation -> LLM.**
Never allow an LLM to directly mutate game state, bypass fog of war, create resources, read hidden enemy state, or call arbitrary host/system tools through the game interface. An LLM is a potentially untrusted external participant. Expose only scoped game actions and filtered observations.

### Control layers
- Strategic LLM: long-horizon goals, expansion, research, diplomatic offers, strategic policies and force allocations.
- Deterministic operational AI: schedules build jobs, production, logistics, repairs, scouting and defenses.
- Unit AI: pathfinding, target selection, doctrine execution and local reactions.
- Human: direct manual orders and optional possession; human overrides must be respected and logged.
- Optional multiple LLM agents: separate roles and authority, arbitration through one server-owned order validator.

### Example typed action categories
- `set_strategy`, `set_budget`, `request_build`, `queue_research`, `assign_squad_objective`
- `configure_doctrine`, `establish_supply_route`, `propose_treaty`, `accept_treaty`
- `inspect_own_status`, `request_intelligence_summary`, `yield_control`
These are illustrative commands; define versioned JSON schemas and an allowlist per role and match mode. A model's free-text response is not itself a game command.

### Observation contract
Provide a bounded, faction-specific structured snapshot: tick/time, known map, visible units, owned units/bases, stockpiles, throughput, research, current objectives, active treaties, recent events and pending orders. Summaries must label uncertainty and stale intelligence. Never include privileged enemy information. Use deltas and summaries to control token usage.

### Timing and reliability
- Run model decisions on strategic/event cadence, not once per rendering frame or unit tick.
- Async model calls must not block rendering or authoritative simulation.
- Timeout, invalid JSON, unavailable provider and over-budget response => safe fallback (keep last valid plan, use deterministic AI or idle according to preset).
- Bound decisions by time, input/output tokens, monetary budget and action rate.
- Queue actions for an explicitly defined future simulation tick; validate against current state on application.
- External LLM outputs are inherently nondeterministic; record observation version, prompt/config hashes, provider/model metadata, returned actions and their resolved execution ticks for faithful replay. A fixed seed alone does not reproduce live LLM output.

## Proposed model provider interface
- Local: any OpenAI-compatible local endpoint or other explicit adapter.
- Hosted: provider-specific adapters with secrets kept server-side, never in replays or public logs.
- Baseline: scripted or heuristic AI through the same Agent API.
- No dependence on a specific model family, vendor or jurisdiction in core game logic.
- Rate limits, API usage and costs visible in UI and experiment logs.

## Observer and laboratory mode
Observer UI: live map, territory control, resource flow, technology timelines, faction plans (only when experiment policy permits), diplomatic timeline, major battles, build trees, LLM cost/token charts, pause/speed/step, replay and export. For fair competition, restrict spectators from leaking privileged information to active participants.

### Evaluation metrics
- Win/loss/draw and Elo-like rating across seeds/maps (with uncertainty).
- Economy: resource efficiency, throughput, idle time, supply outages, construction completion.
- Territory: area held, duration, contested sectors, expansion rate.
- Combat: army losses, objective progress, tactical effectiveness.
- Research: technology progress, strategic timing, megaprojects.
- AI engineering: model calls, input/output tokens, cost, latency, invalid actions, timeout rate.
- Agency: human override frequency, plan adherence, recovery from disruption.
- Fairness: identical observations and action limits for compared models.

## Match modes and flags (proposals)
- `controller_type`: human | scripted_ai | llm
- `llm_role`: architect | commander | diplomat | research | generalist
- `llm_decision_interval_ticks`: positive integer
- `llm_max_input_tokens`, `llm_max_output_tokens`, `llm_max_cost_usd`
- `llm_fallback`: last_valid_plan | scripted_ai | idle
- `llm_visibility`: faction_limited | omniscient_observer (observer-only)
- `observer_mode`: off | live | replay
- `experiment_mode`: off | single | tournament
- `record_llm_actions`: true | false (mandatory for comparable tournaments)
All flags must be schema-validated and gated by implemented features. Campaign, skirmish and multiplayer are session contexts, not controller types.

## Safety, privacy and competitive integrity
- No external model gets local files, API keys, other players' private data or unrestricted network/system execution via game tools.
- Prompt-injection text in in-game chat, diplomacy or player names is untrusted data.
- Record model identifier, prompt version, costs and limits, but redact secrets and unnecessary personal data.
- Separate ranked playlists from experimental LLM-enabled rulesets until fairness and anti-cheat are defined.
- Local models should work without Internet when all assets are available.
- Multiplayer authority remains with the game server, not the model provider.

## Milestones
1. Headless deterministic sim with structured observations and action validation.
2. Scripted AI using the exact same Agent API.
3. One local/remote LLM controlling strategic build/research choices with fallbacks.
4. Human + LLM shared-faction control, arbitration and manual override.
5. Three-model observer match with timeline and full action log.
6. Tournament runner across seeds, budgets and maps, plus reports.
7. Optional diplomacy and alliance negotiations between models.
8. Future RTS/FPS hybrid participation; LLM remains strategic, not frame-by-frame FPS controller.

## Acceptance criteria
- LLM can develop a viable base without direct state access.
- Invalid actions cannot mutate state.
- Provider outage does not crash or freeze a match.
- Manual and LLM actions use identical resource and legality checks.
- Spectator mode can run with zero human-controlled factions.
- Saved LLM actions reproduce the match without re-calling the model.
- Experiment report exposes tokens, latency, cost, failures and outcome.
- Model cannot access fogged enemy information or unauthorized files.
- Match can run entirely without LLM using scripted agents.

## Key design question
Do we expose the full tactical command set to LLMs or limit initial models to strategic policy and delegated orders? Recommendation: begin with strategic API and deterministic execution; expand after measuring reliability and cost.
