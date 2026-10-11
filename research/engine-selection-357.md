# Scalfagus — Engine Selection and AI Engineering 357
Date: 2026-10-11
Status: research; no engine selected

## Product priority
Alpha is a 1990s-flavored pixel-art RTS with Warcraft I/II and StarCraft-style human interface, Dungeon Keeper 1-inspired autonomous creatures, and Factorio-inspired logistics. Possession with simple 3D sprites and Quake III-style FPS movement is a post-MVP aspiration, not an Alpha engine-selection requirement.

## Alpha requirements
- Responsive camera scrolling, minimap, fog of war, selection rectangles, control groups, hotkeys, order queues, attack/move/guard/patrol.
- Unit stats, health, armor, damage types, targeting, pathfinding, formations, collision, combat and production.
- Three transportable resources: Matter, Volatiles, Energy.
- Autonomous MIN/MID/MAX workers and fighters, with specialization-gated abilities; medium automation without self-directed strategic expansion.
- Doctrine-driven unit behavior, training/experience, logistics and faction-specific base connectivity.
- Text-first game data, reproducible CLI builds, headless simulation, CI and automated visual checks.
- Multiplayer with shared-faction control as an architectural consideration; ranked 3v3 and showcase 3v3v3 are longer-term goals.

## Candidate history
Wargus/Stratagus was initially attractive as a Warcraft II-like RTS reference. Babylon.js was briefly preferred for an all-TypeScript AI-first stack, but its 3D-rendering focus leaves most RTS systems to implement. OpenRA was considered for C#/YAML and existing RTS infrastructure. Recoil, Godot and Babylon.js are the current shortlisted three. Avoid planning automatic migrations OpenRA -> Godot -> Babylon: such migrations could require major rewrites.

## AI engineering evaluation (estimates, not benchmarks)
The latest conversation compared Godot, Babylon.js and Recoil across 21 criteria (scale 1–5; higher is better):
| Criterion | Godot | Babylon.js | Recoil |
|---|---:|---:|---:|
| Small context requirements | 5 | 5 | 3 |
| Predictable code generation | 4 | 5 | 3 |
| Debug iteration economy | 4 | 4 | 3 |
| Official documentation | 5 | 5 | 3 |
| API/pattern consistency | 4 | 5 | 3 |
| Static typing and analysis | 4 | 5 | 3 |
| Clear project conventions | 4 | 5 | 3 |
| Headless and CLI | 5 | 5 | 4 |
| Unit testing | 4 | 5 | 4 |
| Integration testing | 4 | 5 | 4 |
| Screenshot regression | 4 | 5 | 4 |
| Error diagnostics | 4 | 5 | 3 |
| Module separation | 5 | 5 | 4 |
| Parallel agent work | 5 | 5 | 4 |
| Refactoring ease | 4 | 5 | 3 |
| Existing RTS controls and camera | 2 | 1 | 5 |
| Pathfinding and large armies | 3 | 2 | 5 |
| Economy and unit autonomy | 4 | 4 | 5 |
| Classic pixel art | 5 | 3 | 3 |
| RTS multiplayer | 3 | 2 | 5 |
| Future 3D possession | 5 | 5 | 4 |

Previous qualitative weighted ranking: Godot ~4.15, Recoil ~4.05, Babylon.js ~3.65. These were illustrative judgments, not reproducibly derived measurements; do not treat the decimals as empirical findings.

### Candidate tradeoffs
- **Godot 4:** strongest general-purpose compromise for AI-driven, long-lived development; text scene files, GDScript/C#, CLI/headless and 2D/3D support. Must implement substantial RTS logic, UI behavior and multiplayer architecture.
- **Recoil:** strongest ready-made large-scale RTS foundation, unit behavior and multiplayer synchronization; C++/Lua engine/game split increases codebase learning and debugging complexity.
- **Babylon.js:** strongest TypeScript-first ecosystem for agents, browser automation, npm tests and eventual 3D; not a complete RTS engine, so selection, pathfinding orchestration, commands, economy and multiplayer need custom implementation.

## AI engineering measurement plan
Compare the same three tasks in each engine: (1) create one configured unit with HUD and combat stats; (2) implement 20 autonomous MIN workers extracting and transporting Matter; (3) implement a doctrine and selection/hotkeys with a deterministic test. Measure actual input/output tokens, wall-clock time, number of agent iterations, tests passing, defects, and PR review effort. Additional hard gates: shared-faction multiplayer feasibility, license compatibility, performance with 200 units, reproducible headless runs.

## Proposed agent workflow
Maintain AGENTS.md, concise architecture docs, canonical YAML game design, narrow component contracts, deterministic scenarios, screenshot regression, CI gates, and small independently reviewable PRs. Keep simulation state independent of the renderer where practical.

## Decision
No engine is approved yet. Godot is the strategic AI-first leader; Recoil is the RTS-first challenger; Babylon.js is the TypeScript-first alternative. Run an actual agent benchmark before committing. Do not over-optimize Alpha for post-MVP FPS.
