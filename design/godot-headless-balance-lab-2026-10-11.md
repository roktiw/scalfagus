# Scalfagus — Godot Headless Balance Lab

Date: 2026-10-11
Status: **owner-approved technical direction (DEC-032)**; **design only**, not a completed or benchmarked runner.

**DEC-033 update (2026-10-11):** the CURRENT first playable scope is MAN vs MAN (not MAN vs ETH). Implement initial fair mirror C-C tournaments and paired seed/side swaps before adding ETH or ORG. Broader asymmetric comparisons are future milestones, with the same Godot simulation authority.

## Outcome

Build automated, repeatable, accelerated full-match tests for Scalfagus. Use them to measure racial/faction balance, economy and logistics performance, combat, tech choices, strategy dominance, pathfinding and regressions. A single shared simulation core must be authoritative for human play, scripted bots and offline self-play.

The active **MVP 0.1** fixture is **MAN vs MAN** on Verdant Divide with four templates and finite SOLID→Matter harvesting (DEC-033). MAN vs ETH and ORG become later test matrices. Mirror tests assess strategy/map spawn fairness and mechanics, not inter-faction balance.

## Architecture

- **Godot 4.7.2 Standard and typed GDScript** remain the only game/simulation runtime for MVP. No separate Python or text game required, no mandatory external AI/LLM online API, no second rules engine, no Tauri game shell.
- Create a **separable, testable Simulation Core**: authoritative world state, fixed simulation tick, canonical entity IDs, legal commands, economy packet custody, movement/pathing, structures and production, line-of-sight/combat, faction rules, victory and deterministic event logging.
- Graphical RTS/FPP view/controllers **adapt to** the same core. Bots call the same validated command API and obey the same fog-of-war, resources, movement, cooldowns and targeting restrictions as players.
- Use narrow Godot world/physics adapters for terrain collisions, LOS and movement; don't pretend a separate simplified numerical combat model is equivalent. Test consistency against playable scene and state hashes.
- **`--headless` only disables graphical output.** Acceleration requires a batch runner that explicitly advances simulation ticks without frame-time sleeps and avoids creating thousands of rendered scenes or launching a separate Godot process per match.
- Prefer data-driven YAML source specs → schema-validated versioned JSON compiled offline (if necessary), loaded by the game. Balance sweeps change provisional parameters via controlled overrides, not hardcoded scripts or silent approved-lore edits.
- Start with GDScript. Profile real matches before considering C++ GDExtension or other acceleration.

## Bot strategy library

Implement simple deterministic legal bots with bounded observation, reproducible random seeds and difficulty/strategy settings:
- `economist` (resource throughput and production growth)
- `rusher` (earliest legal aggression)
- `turtle` (defensive economy, coverage)
- `aggressor` (continuous pressure)
- `random_legal` (edge-case discovery)
- `adaptive` (opponent-reactive policy; only after baseline bots)

Do **not** call an LLM for each unit/tick. The optional **AI Researcher** reads batch summaries, identifies hypotheses, proposes YAML parameter deltas, runs targeted experiments and reports confidence/side effects. Its proposals **never auto-approve balance** without human review.

## Experimental protocol

- Pin `game_version`, `rules_hash`, `map_hash`, `map_id`, `seed`, `scenario_id`, `bot_policy_version`, and `balance_config_hash` on every run.
- Compare candidate against baseline using matched seeds, both spawn sides, symmetrical faction swaps, paired policy match-ups, multiple strategies and maps when available.
- Measure not just faction wins: ties, stalemates, match length, time to first worker/soldier/attack, resources mined/transported/lost, economy throughput, supply/energy starvation, unit survival, weapon utilization, stuck paths, attack frequency, and victory reason.
- Track sample counts and statistical uncertainty; do not label small noisy sweeps as balanced. A win rate near 50% against one bot is **not** evidence of good strategic diversity.
- Include mirror matches early to validate engine invariants, map/spawn parity and strategy balance. Include MAN-vs-ETH once ETH implements its distinct real network economics. FPP attention/skill advantage requires human playtesting in addition to self-play.
- Enforce no source-stock cloning, double spending, free construction, illegal fog knowledge or bypassed victory rule during all batch runs.
- On failure record minimal reproducible seed, accepted command log and snapshot/replay hash; support playback in the 3D scene. ASCII/text map dump is an optional debug view **only**, not an additional rules engine.

## CLI target (not implemented)

```sh
godot --headless --path apps/game --script res://balance/run.gd -- --matches 10000 --seed 42
```

Runner may batch many independent matches in one Godot process. The CLI is a **proposed interface**, not proof that `res://balance/run.gd` already exists.

## Suggested outputs

- `results.jsonl` — one row per match with hashes, bot names, seed, races, spawn sides, winner, duration, economy/combat indicators and warnings.
- `summary.json` + `summary.csv` — win-rate matrices, paired comparisons, distribution stats and regression alarms.
- Full replays/event logs only for selected seed failures and representative games to reduce storage overhead.
- Report performance as **simulated game minutes per wall-clock second** and completed matches/minute, benchmarked on named hardware. Do not promise 10,000 completed matches per minute in advance.

## Suggested phased tasks and gates

1. `BAL-00`: fixed-tick engine API + authoritative snapshots, entity IDs, legal action log, conserved economy ledger.
2. `BAL-01`: headless one-match runner with configurable seed + consistent output format; assert equivalence to graphical gameplay.
3. `BAL-02`: repeated matches in one process; paired seeds, side swaps, mirror matches; two baseline bots.
4. `BAL-03`: metrics collector, validation rules, CSV/JSONL, minimal replay and automated regressions.
5. `BAL-04`: MAN-vs-ETH full rules tournament as soon as both races and end-to-end combat work; strategy matrix and statistical uncertainty.
6. `BAL-05`: optional offline/online LLM researcher orchestration; candidate parameter sweeps subject to owner approval.
7. `BAL-06`: ORG only after separate roster/mechanics approval and implementation.

**Definition of done for first useful runner:** an actual complete headless scripted match reaches the same legal outcome as graphical playback, resource conservation and replay checks pass, and a reproducible result file is produced. No balance certification until enough verified runs and human playtests.

## Boundaries

**DEC-033 explicitly changes first playable MVP to one-faction MAN mirrors**; DEC-025's two-faction release requirement is deferred. DEC-030 mandatory floating-platform rule still applies.
