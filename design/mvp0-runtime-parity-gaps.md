# Scalfagus MVP 0.1 — Concrete Code-to-Spec Parity Review

Date: 2026-10-11
Status: **static source inspection ONLY**, not a Godot run, benchmark or confirmation of a compiler failure.
Owner authority: DEC-033 (MAN mirror RTS first release), DEC-034 (Reuse First), DEC-030 (all maps floating platforms).
Machine-readable P0/P1 tasks: [mvp0-runtime-parity-gaps.yaml](mvp0-runtime-parity-gaps.yaml).
**CURRENT micro-release selected numerical hypothesis:** [mvp0-agent-implementation-contract.yaml](mvp0-agent-implementation-contract.yaml), as linked by the latest agent source-of-truth. [mvp0-man-mirror-balance-v0.1.yaml](mvp0-man-mirror-balance-v0.1.yaml) is a distinct **alternative analytical scenario**, not an automatically loaded second profile. Candidate differences must be resolved before a real release.
Actual prototype code inspected on GitHub `main`: `apps/game/scripts/mirror_match_state.gd`, `mirror_view.gd`, `mirror_smoke.gd`, `mirror_batch.gd`; later concurrent edits must be re-fetched before applying patches.

## What exists in the latest source

Godot-only **MAN mirror experimental implementation** now exists on `main` (an update that arrived during this audit, after the initial 198-file inventory). It has a RefCounted match state, two slots, four basic template kinds, deterministic-ish headless `advance()`, basic bot actions, scripted combat and a blockout flying deck 3D view, plus headless test scripts. This is meaningful progress, **not proof of working/completed MVP**: currently reported as unverified by its own development findings. No checked-in full authoritative LAN Host/Join was identified, and original tests passing would not establish it.

## Latest conclusions for the coding agent (same-day source recheck)

- The **active MVP0 is MAN–MAN**, exactly four MAN template IDs, RTS Overlord only; H-H LAN, H-C and C-C are the release modes. DEC-033 supersedes earlier MAN–ETH-first release targets; DEC-034 requires using existing code/Godot primitives before custom generic utilities.
- The existing `apps/game/scripts/mirror_match_state.gd` implements a useful **experimental** command/economy/AI loop, but it does not load the fully authored Verdant Divide YAML or the canonical 20Hz candidate profile. Treat this as a simulation prototype, **not balance evidence**.
- `scripts/check.sh` **now invokes `mirror_smoke.gd` and `mirror_visual_smoke.gd`**, as well as earlier smoke scripts. This corrects older notes that those tests were absent from the check script. **The script does not execute `mirror_batch.gd`** by default. The presence of test calls is not evidence of a successful Godot run in this review.
- The newly added `mirror_visual_smoke.gd` verifies five-direction sprites, an appropriate initial camera/window size and **exactly four physical resource-source visuals**. That is a valuable visual regression against disappearing sprites and tiny windows, but its exact-four source assertion must migrate when the authored 10-deposit Verdant Divide map replaces hardcoded nodes. Do not keep a false green fixture by retaining the wrong map.
- The `_walk()` implementation is **one cell every three authoritative ticks**, not a cell every tick. At the current GUI's 10Hz, its theoretical unobstructed rate is **3.33 grid cells/s**; if simply moved to 20Hz it becomes **6.67 cells/s**. The desired candidate is **2.3 tiles/s**, requiring explicit units/cell/world conversion, not only a tick-rate change.
- `mirror_view.gd` now renders actual directional sprites. Other visual tests and sourced art are committed, but runtime render quality, official Godot import, collision coherence and sprite persistence **are unverified by this audit**.
- Two separate client LAN H-H, authoritative peer-bound validation, fog-filtered snapshots, real map compilation, deterministic replay equivalence and human playtests remain **release blockers**.
- **One active numeric source:** `mvp0-agent-implementation-contract.yaml` currently wins per `agent-source-of-truth.yaml`; `mvp0-man-mirror-balance-v0.1.yaml` is a supplementary alternative experiment. Neither is measured or owner-approved numerical balance. Future MAN–ETH Energy/UMU/Pylon profile must not leak into current build.

**Recommended first implementation order:** normalize sim-time and map units → compile canonical map and reconcile sources/spawns/colliders → migrate simulation values into a single pinned profile → verify gameplay/visual headless tests → implement peer-bound LAN authority → run paired-seed C-C tests, two-client H-H tests and human playtests. Follow the tracked agent gates in [MVP0 backlog](mvp0-man-mirror-backlog.yaml).

## High-impact mismatches requiring coding-agent fixes

**Timebase correction:** `mirror_view.gd` calls `sim.advance()` at **10Hz** in normal GUI mode, while the candidate engine uses **20Hz**. `MAX_TICKS=5400` is therefore 9 minutes of current GUI game-time, or 4.5 minutes of simulation if played at proposed 20Hz without counter changes. The table gives **both** interpretations wherever relevant. Godot headless `mirror_batch.gd` advances unpaced; same logical tick count does not imply a consistent game-time duration until the timebase is fixed.

| System | Current hard-coded `mirror_match_state.gd` | Candidate release contract | Effect / required action |
|---|---|---|---|
| Match timeout | `MAX_TICKS = 5400` = **9 min in current GUI at 10Hz**, or **4.5 min if advanced at intended 20Hz** | Candidate `24000` ticks at 20Hz = **20 min**; timeout produces draw | Normalize the one tick unit; then load profile and evaluate bot pacing |
| Finite source placement | West 900 + East 900 + North 350 + South 350 = **2500** total | Canonical Verdant Divide YAML nodes sum **1660**, two near-start clusters **400** each | Cannot balance against real map; compile authored YAML |
| SOLID extraction | Fills 10 Matter after **6 ticks** = **0.6s GUI at 10Hz** (or 0.3s at proposed 20Hz) | **2.0s per Matter**, or 20s per full 10 bag | Roughly **33×** faster in current GUI, or **67×** faster under 20Hz without fixing mining counters |
| Unit motion | One grid cell only **every third tick** (`_walk: if tick % 3 != 0: return`) | Active candidate **2.3 tiles/s**, at 20Hz ~0.115 tiles/tick | Current theoretical unobstructed **3.33 cells/s at GUI 10Hz** or **6.67 cells/s if advanced at 20Hz**; different from the intended metric-space speed |
| Barracks build | `work_ticks = 45` = **4.5s in current 10Hz GUI** or 2.25s at 20Hz | **18s** = 360 ticks at target 20Hz | Early barracks timing is 4× faster than candidate in normal GUI; 8× at 20Hz without counter adjustment |
| Worker training | `train_left = 45` = **4.5s GUI at 10Hz**, or 2.25s at 20Hz | Candidate **7s** = 140 ticks at target 20Hz | Faster than candidate; production requires rule-profile conversion |
| Rifleman training | `train_left = 65` = **6.5s GUI at 10Hz**, or 3.25s at 20Hz | Candidate **9s** = 180 ticks at target 20Hz | Faster than candidate; production needs one tick source |
| Rifle cooldown | `cooldown = 10` = **1.0s in current GUI at 10Hz**, or 0.50s at 20Hz | Candidate **1.0s** = 20 ticks at target 20Hz | Current GUI happens to match candidate wall-clock rate; naïve 20Hz switch would double firing rate |
| Rifle range units | Manhattan `distance <= 6` **cells** | **6.5 world metres = 3.25 two-metre tiles**, using 3D LOS | Weapon has incompatible space/time scale |
| Build radius | Manhattan HQ distance `<=9` | Candidate **9 tiles** (active candidate) | Agent must use one legal region and consistent path-distance metric |
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

**Paper balance check:** 3 workers, 10 Matter capacity each, mining 2s/unit, 8 tiles travel each way at 2.3 tiles/s, 0.7s handling per trip → ~27.66s per 10-unit cycle, ~65.09 Matter/min combined. Locally reachable 400 Matter funds **one 100-Matter Barracks plus 6×50-Matter Riflemen** or **one Barracks + 3 Riflemen + 3 extra Workers =355 Matter**, leaving45. This is a sustainable legal opening against symmetric mirror starts *on paper*. Robot path congestion, delivery ports and actual first shots must still be measured. Until the actual map is compiled and navigable, **start parity is not proven**.

## Agent priorities

1. **Do not reimplement Godot A* or generic FPS/RPG subsystems.** Owner DEC-034 Reuse First: current project `apps/game/scripts/grid_navigator.gd`, available `AStarGrid2D`, Godot physics/input/ENet and vetted vendored modules must be considered before bespoke code. Existing RTS Framework and Keychain `addons/` are not proof the runtime actively uses them; audit integration/licenses/version before enabling.
2. **Parameterize fixed-tick GameState** from ONE selected versioned `mvp0` YAML profile: timeout, mining per unit, walking, training, build, weapon, source amounts and frame.
3. **Compile map YAML into one resolved gameplay map** or an explicitly documented compatible Godot Resource, rather than drawing a separate authored route in `mirror_view.gd` and an incompatible source arrangement in `mirror_match_state.gd`. Validate two starts, dry paths and complete edge collision.
4. Wrap the existing state behind one command validator for human GUI, bot and ENet host. Add stable client per-slot sequence IDs, visible snapshots, replay hash and two-process Host/Join smoke.
5. Convert existing headless smoke into **actual Godot-run passing** tests and report commands/commit/hash/engine; do not invent pass results. Run paired mirrored starts/seeds and measure frame times only after implementation catches up to design.
6. Keep FPP/TPP existing camera spike for regressions but do NOT ship as a third user-facing perspective or first-release requirement (DEC-031/033).

## Project status clarification

Static MD/YAML now gives agent a full **target behavior and negative-test checklist** for the first release. The repo's current new code is a **provisional gameplay blockout**, with more implementation/verification still required; it should not be described as complete or balanced yet. A true successful LAN H-H match, matched C-C graphical/headless replay and complete tested GUI game are the actual release gates.
