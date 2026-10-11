# Scalfagus MVP 0.1 — Concrete Code-to-Spec Parity Review

Date: 2026-10-11
Status: **static source inspection ONLY**, not a Godot run, benchmark or confirmation of a compiler failure.
Owner authority: DEC-033 (MAN mirror RTS first release), DEC-034 (Reuse First), DEC-030 (all maps floating platforms).
Machine-readable P0/P1 tasks: [mvp0-runtime-parity-gaps.yaml](mvp0-runtime-parity-gaps.yaml).
Active release **numerical hypothesis:** [mvp0-man-mirror-balance-v0.1.yaml](mvp0-man-mirror-balance-v0.1.yaml); other agent-authored draft [mvp0-agent-implementation-contract.yaml](mvp0-agent-implementation-contract.yaml) includes alternative proposal values and must not silently become a **second active** balance profile.
Actual prototype code inspected on GitHub `main`: `apps/game/scripts/mirror_match_state.gd`, `mirror_view.gd`, `mirror_smoke.gd`, `mirror_batch.gd`; later concurrent edits must be re-fetched before applying patches.

## What exists in the latest source

Godot-only **MAN mirror experimental implementation** now exists on `main` (an update that arrived during this audit, after the initial 198-file inventory). It has a RefCounted match state, two slots, four basic template kinds, deterministic-ish headless `advance()`, basic bot actions, scripted combat and a blockout flying deck 3D view, plus headless test scripts. This is meaningful progress, **not proof of working/completed MVP**: currently reported as unverified by its own development findings. No checked-in full authoritative LAN Host/Join was identified, and original tests passing would not establish it.

## High-impact mismatches requiring coding-agent fixes

| System | Current hard-coded `mirror_match_state.gd` | Candidate release contract | Effect / required action |
|---|---|---|---|
| 20Hz match timeout | `MAX_TICKS = 5400` = **4.5 min** | `24000` ticks = **20 min**, timeout is draw | Bot self-play truncated; load profile |
| Finite source placement | West 900 + East 900 + North 350 + South 350 = **2500** total | Canonical Verdant Divide YAML nodes sum **1660**, two near-start clusters **400** each | Cannot balance against real map; compile authored YAML |
| SOLID extraction | Fills 10 Matter after **6 ticks** = 0.30s at 20Hz | **2.0s per Matter** = 20s for full 10 bag | Current theoretical harvesting ~67× faster for full bag alone |
| Unit motion | One full grid cell per `advance()` tick | **2.4 tiles/s** worker, 20Hz => 0.12 tiles/tick | Current unblocked 20 tiles/s (~8.3× target) |
| Barracks build | `work_ticks = 45` = **2.25s** | **18s** = 360 ticks | Very large early rush distortion |
| Worker training | `train_left = 45` = **2.25s** | **7s** = 140 ticks | Unit snowball too fast |
| Rifleman training | `train_left = 65` = **3.25s** | **9s** = 180 ticks | Army spawn too fast |
| Rifle cooldown | `cooldown = 10` = **0.50s** | **1.0s** = 20 ticks | Twice intended sustained damage |
| Rifle range units | Manhattan `distance <= 6` **cells** | **6.5 world metres = 3.25 two-metre tiles**, using 3D LOS | Weapon has incompatible space/time scale |
| Build radius | Manhattan HQ distance `<=9` | Candidate **18 tiles** (profile proposed) | Agent must use one legal region and consistent path-distance metric |
| Bot decisions | Every 12 ticks | Candidate every 10 ticks | Tuning/command count differs |
| World geometry | Hand-coded trees/water in state; 64×64 one-unit-wide 3D deck art | Versioned `Verdant Divide` YAML, proposed **2 world metres/tile**, ramps, 1660 real source units | Visual and simulation can disagree; map source of truth not implemented |
| Pathfinding | Hand-written generic breadth-first queue in `_find_route` | DEC-034 reuse `AStarGrid2D` / vetted existing `grid_navigator.gd` adapter | Replace general algorithm when integrating |
| Multiplayer | Local arrays of `human|bot` controllers | **Two separate LAN/loopback Godot clients** and one authoritative host | H-H release requirement unmet |
| Commands | `issue_command(side,...)` direct state mutation | Peer-bound slot + sequenced, idempotent validated commands; snapshot filtering | LAN authority/security cannot reuse unsafe entrypoint unguarded |
| Resource custody | Flat `players[side][matter]` counter | Spending value must represent **actual own HQ-held Matter** after finite source→worker→HQ transfer | Clarify physical depot vs global wallet at code/API boundary |

The code uses `mirror_view.gd` to render deck rim and dark sky, which is a useful **visual blockout** but not a verified 3D platform collision implementation. The actual `_line_clear` logic is a cell-grid trunk check, not yet the common source-of-truth Godot 3D ray LOS matching sprites/obstacles.

**No gameplay result from this code may certify balance against the proposed canonical profile until these disparities are removed or documented as an intentionally different measured profile.** In particular, current 5400-tick outcomes and near-instant mining/production distort game pacing by orders of magnitude.

## Single profile precedence and reconciliation

Owner fixed: four MAN templates, two player slots and all H-H/H-C/C-C, finite SOLID→Matter, platform jungle, building-annihilation, 20-minute *candidate* test timeout as draw. Source of active numeric **implementation target** in this audit is `design/mvp0-man-mirror-balance-v0.1.yaml`. Existing `design/mvp0-agent-implementation-contract.yaml` gives a second, independently authored set of candidate defaults, e.g., worker speed 2.3 instead of 2.4. It is supplemental architecture/readiness research until merged and the owner/test lead selects a single profile; do not import a mixture.

**Paper balance check:** 3 workers, 10 Matter capacity each, mining 2s/unit, 8 tiles travel each way at 2.4 tiles/s, 0.5s handling per trip → ~27.17s per 10-unit cycle, ~66.26 Matter/min combined. Locally reachable 400 Matter funds **one 100-Matter Barracks plus 6×50-Matter Riflemen** or **one Barracks + 3 Riflemen + 3 extra Workers =355 Matter**, leaving45. This is a sustainable legal opening against symmetric mirror starts *on paper*. Robot path congestion, delivery ports and actual first shots must still be measured. Until the actual map is compiled and navigable, **start parity is not proven**.

## Agent priorities

1. **Do not reimplement Godot A* or generic FPS/RPG subsystems.** Owner DEC-034 Reuse First: current project `apps/game/scripts/grid_navigator.gd`, available `AStarGrid2D`, Godot physics/input/ENet and vetted vendored modules must be considered before bespoke code. Existing RTS Framework and Keychain `addons/` are not proof the runtime actively uses them; audit integration/licenses/version before enabling.
2. **Parameterize fixed-tick GameState** from ONE selected versioned `mvp0` YAML profile: timeout, mining per unit, walking, training, build, weapon, source amounts and frame.
3. **Compile map YAML into one resolved gameplay map** or an explicitly documented compatible Godot Resource, rather than drawing a separate authored route in `mirror_view.gd` and an incompatible source arrangement in `mirror_match_state.gd`. Validate two starts, dry paths and complete edge collision.
4. Wrap the existing state behind one command validator for human GUI, bot and ENet host. Add stable client per-slot sequence IDs, visible snapshots, replay hash and two-process Host/Join smoke.
5. Convert existing headless smoke into **actual Godot-run passing** tests and report commands/commit/hash/engine; do not invent pass results. Run paired mirrored starts/seeds and measure frame times only after implementation catches up to design.
6. Keep FPP/TPP existing camera spike for regressions but do NOT ship as a third user-facing perspective or first-release requirement (DEC-031/033).

## Project status clarification

Static MD/YAML now gives agent a full **target behavior and negative-test checklist** for the first release. The repo's current new code is a **provisional gameplay blockout**, with more implementation/verification still required; it should not be described as complete or balanced yet. A true successful LAN H-H match, matched C-C graphical/headless replay and complete tested GUI game are the actual release gates.
