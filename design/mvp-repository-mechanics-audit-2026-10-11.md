# Scalfagus — Repository-Wide Mechanics and Agent-Readiness Audit

Date: 2026-10-11
Status: **source-based design/implementation audit; fixes and recommendations, NOT implemented or measured gameplay.**
Companion actionable machine-readable register: [mvp-repository-mechanics-audit.yaml](mvp-repository-mechanics-audit.yaml).
Current agent authority: [AGENTS.md](../AGENTS.md), [agent-source-of-truth.yaml](agent-source-of-truth.yaml).

## Consolidated engineering conclusions — current main snapshot

**2026-10-11 source review.** This executive section is the **latest corrected interpretation** of earlier findings elsewhere in this report, which were compiled during rapid parallel changes to `main`. The report remains a **source audit only**; there is no claim of executing Godot in this review.

### What the coding agent should implement now

**Ship DEC-033:** a full **MAN vs MAN** RTS using exactly four templates (Command Core, MIN Worker, Barracks, Rifleman), only finite SOLID → worker cargo → owned HQ Matter, combat/LOS/victory, one mandatory floating Verdant Divide space platform, and controller combinations **H–H LAN/loopback, H–C and C–C observed/headless**. Release MVP 0.1 is **RTS only**. Future Overlord + FPP is DEC-031. Do not import earlier MAN–ETH five-role + Energy, UMU, Pylon, ORG or extra cameras. Reuse existing Godot/addons under DEC-034, but do not allow third-party source to own authoritative game rules.

| Finding | Verified current state | Mandatory next action |
|---|---|---|
| **Runnable RTS source exists** | `mirror_match_state.gd`, `mirror_view.gd`, `mirror_match.tscn`, `mirror_smoke.gd`, `mirror_batch.gd` and visual smoke exist on `main`. Includes local H–C/C–C prototypes. **Not verified by this review** | Preserve code and run actual pinned Godot checks before declaring completion |
| **One wrong timebase** | GUI calls `sim.advance()` approximately **10 times/s** at speed 1; design candidate is **20Hz**. State `MAX_TICKS=5400` yields **9 GUI minutes**, or **4.5 simulated minutes** if moved to 20Hz unchanged, not the 20-minute candidate timeout | Define one authoritative tick duration and derive movement, extraction, queues, combat, timeout and headless simulation time from that profile |
| **One wrong map fixture** | State hardcodes source stock **2,500** in four deposits and a local cell-layout/spawn; authored YAML defines **1,660** stock in **ten** deposits, starting clusters 400 per side | Compile the authored Verdant Divide map to Godot Resource/JSON and load identical terrain, source IDs, spawns, LOS/nav and render collision in GUI/headless |
| **Extraction and production much too fast** | Mine a **full 10-Matter bag after 6 ticks** (0.6s in normal GUI) vs 2s per unit candidate. Barracks + training timers are 45/65 ticks rather than profile times | Remove prototype magic numbers, load **one release-specific numeric profile** into runtime, recompute tick durations and test |
| **Movement is gated every 3 ticks** | `_walk()` explicitly returns unless `tick % 3 == 0`. This corrects the earlier incorrect claim of movement every tick: theoretical unobstructed 3.33 cells/s in current 10Hz GUI, 6.67 cells/s if simply moved to 20Hz | Convert target 2.3 tiles/s and 2-metre tile mapping consistently; reuse `AStarGrid2D`/existing adapters per DEC-034 rather than duplicating general pathfinding |
| **Source-authority security missing** | Local `issue_command(side,...)` is not a peer-bound LAN command protocol. No authoritative two-human host/join flow identified | ENet host binds physical peer → slot, validates/fog-filters commands/snapshots and uses one GameState for H-H/H-C/C-C |
| **Test scripts already integrated partially** | Latest `scripts/check.sh` **does invoke** `mirror_smoke.gd` and **`mirror_visual_smoke.gd`** (correcting earlier source-refresh text); it does **not invoke `mirror_batch.gd`**. This review has **no execution logs** | Execute actual Godot checks and explicit headless batch; capture engine SHA/version, commit, command, exit codes, failure seeds and hashes |
| **Visual regressions now protected** | `mirror_visual_smoke.gd` checks real 5-view sprites, camera zoom and minimum startup window dimensions, but asserts **exactly four** source visuals, matching the hardcoded map not authored ten-node map | Keep the sprite/window checks; migrate source count/IDs to the compiled canonical map so tests do not force obsolete layout |
| **Candidate balance ≠ measured balance** | Matching MAN costs on two sides are a useful mirror design; there are still no verified run distributions/playtest win rates in this audit | Run side-swapped paired seeds, replay invariants, H-H LAN tests and real humans before making balance claims |

### One numerical authority and release data separation

- **Current selected first-release candidate numeric profile:** [`mvp0-agent-implementation-contract.yaml`](mvp0-agent-implementation-contract.yaml), according to [`agent-source-of-truth.yaml`](agent-source-of-truth.yaml). These values remain **proposals**, not owner-approved competitive balance.
- [`mvp0-man-mirror-balance-v0.1.yaml`](mvp0-man-mirror-balance-v0.1.yaml) is a **separate, non-active analytical scenario** (e.g. worker speed 2.4 vs current selected 2.3, and build-radius differences). Its [supplementary numerical acceptance cases](mvp0-man-mirror-balance-acceptance.yaml) must be recalculated or converted into profile-independent invariant tests before running as current release gates.
- **Only post-MVP0:** [MAN–ETH numeric prototype](mvp-balance-playtest-v0.1.yaml), [finite multi-faction networks](mvp-network-execution.yaml), [inverse source-form specialization](resource-balance.yaml), advanced construction, Energy, salvage, supplies/farms, UMU and ETH Pylon. Preserve these as future design, not mandatory code for the first complete match.

### Definition of ready for the coding agent

**Documentation/specification:** enough linked MD/YAML now exists to start an implementation PR without inventing the release scope, provisional prices, LAN host semantics, ledger conservation or legal win behavior. Entry points are [AGENTS.md](../AGENTS.md), [current decision registry](decisions.yaml), [machine-readable authority](agent-source-of-truth.yaml), [MVP0 agent backlog](mvp0-man-mirror-backlog.yaml), [micro execution contract](mvp0-man-mirror-execution-contract.md), [LAN protocol](mvp0-man-mirror-network.yaml) and [code parity tracker](mvp0-runtime-parity-gaps.yaml).

**Code/release-ready:** **NOT YET.** Critical work remains in source; YAML acceptance scenarios are **not self-running Godot tests**. A real successful GUI H-C match, paired C-C graphical/headless run, two separately connected human clients using one authoritative host, correct authored map, conservation replay hash and actual Godot/CI evidence are required before calling Scalfagus MVP0 playable or balanced.

### P0 coding sequence

1. **Normalize timebase, units and profile:** pick fixed 20Hz sim, ensure GUI steps and Godot headless advance exactly the same logical seconds; parameterize hardcoded economy, movement, weapon and timeout ticks from one selected profile.
2. **Unify world truth:** compile ten-node authored map; validate two mirrored MAN starts, dry route access, actual deck/trees/water/rim collision, sight rays, source stock 1660 and visible 5-view sprites/window.
3. **Prove a full paid single-process RTS match:** worker gathers/carries/delivers, one Barracks starts only with deposited Matter, riflemen train/attack, completed building-class elimination/draw; no negative balances, fog cheating or duplicate refunds.
4. **Prove bots and headless:** H-C, C-C spectator and unpaced Godot batches; seeds/side swaps, trace+hash+timings, real command log and passing smoke.
5. **Ship H-H LAN:** Godot ENet host/clients, authenticated peer-slot binding, rejection of hostile/duplicate/out-of-order orders, fog-filtered snapshots and abort-on-disconnect.
6. **Verify and tune:** actual end-to-end local and two-process runs; turn relevant YAML acceptance into real tests, report failures and sampling uncertainty; do not claim 50% win rate from designed symmetry alone.

All individual blockers and tests are tracked by [CODE-GAP-01…17](mvp0-runtime-parity-gaps.yaml) and [M0-00…09](mvp0-man-mirror-backlog.yaml).

## Source refresh — later same-day Godot changes and DEC-034

**This section overrides stale code-status claims in the initial audit pass below.** While this review was being written, the repository received additional source commits. The newest verified GitHub contents include:

- **`apps/game/scripts/mirror_match_state.gd`** — a new `RefCounted` **two-slot MAN mirror rules prototype** with four templates (`hq, worker, barracks, rifleman`), finite Matter bookkeeping, orders, cell movement, an internal scripted bot, a building-annihilation predicate and a replay hash. This is source code, **not a confirmed passing Godot test**.
- **`apps/game/scripts/mirror_view.gd`** + `apps/game/scenes/mirror_match.tscn` — new local Godot tactical world/H–C and C–C spectator UI. `apps/game/scripts/menu.gd` now shows **PLAY MAN vs BOT** and **WATCH BOT vs BOT**, explicitly stating LAN H–H is unimplemented.
- **`apps/game/tests/mirror_smoke.gd`** and **`mirror_batch.gd`** — real candidate GDScript test/runner files exist. **Correction in the consolidated section above:** the current `scripts/check.sh` *does call* `mirror_smoke.gd` and `mirror_visual_smoke.gd`; the standalone `mirror_batch.gd` remains separate. No pass was observed in this audit.
- **DEC-034** adds a mandatory **reuse-first engineering policy**: existing repo code → Godot 4.7.2 built-ins → vetted pinned GitHub/AssetLib modules → unique domain code. See [reuse architecture](../architecture/adr-0004-godot-reuse-first-wrappers.md), [component map](../architecture/godot-reuse-component-map.yaml), and [agent playbook](../docs/AGENT-REUSE-FIRST-PLAYBOOK.md). **Third-party candidate lists are research, not permission to install unreviewed addons.**

**New P0 source-to-design mismatches, verified directly from the new source:**

1. **Different map data:** `mirror_match_state.gd` uses generated mirrored HQ positions around **(8,32)** and **(55,31)** plus source stocks **900+900+350+350 = 2,500**. The approved **Verdant Divide fixture** has starts **(9,9)/(54,54)**, ten authored deposits totaling **1,660** and more organic water/tree terrain. No actual YAML→Godot terrain compiler is present in the observed mirror path. This is **not** the same source layout, even if both are 64×64 and visually suspended in space.
2. **Clock ambiguity:** `mirror_view.gd` advances `sim.advance()` per **0.1 seconds** of GUI time (10 ticks/s), while `mvp0-man-mirror-rts.yaml` proposes **20 ticks/s** and a 20-minute candidate cap. `MirrorMatchState.MAX_TICKS=5400` means **9 minutes at 10 Hz**, or **4.5 minutes at 20 Hz**. Choose one tick scale and derive all gather, training, building, cooldown, timeout and bot-decision intervals from it.
3. **Balance constants differ from proposed single-release profile:** the new `MirrorMatchState` hardcodes the canonical micro-costs 35/100/50, but its construction work counter and training counters are code-owned tick numbers (`45`, `65`) rather than loading the declared `7s / 18s / 9s` from `mvp0-man-mirror-rts.yaml`. Do not assume YAML is wired to the runtime or overwrite working numbers without tests.
4. **Current movement and visibility are a custom grid prototype:** `mirror_match_state.gd` contains `_find_route()` using a hand-built queue/BFS and `_line_clear()` using manual grid ray stepping. DEC-034 requires evaluating Godot built-ins **`AStarGrid2D`**, `NavigationServer3D`, `PhysicsDirectSpaceState3D` before keeping a homemade generic substitute. Preserve current behavior while introducing an adapter and parity tests; do not rip out a stable prototype blindly.
5. **LAN still missing:** two player slots are modeled in `MirrorMatchState`, but no two-client authoritative host/join flow exists in the observed `mirror_view`/menu. A model with two owners is **not** implemented H–H multiplayer.
6. **More tests are now present, but not verified:** the old legacy smoke, `rts_smoke.gd` and `navigation_smoke.gd` may appear in `scripts/check.sh`. The new `mirror_smoke.gd` and bounded `mirror_batch.gd` must also be executed and integrated into the CI gate, subject to observed parser/runtime behavior.

**Audit interpretation:** initial statements below that the repo has “only a camera spike” refer to the **earlier snapshot**, not the newer MAN-mirror source. Correct present status is: **MAN mirror prototype code exists and is unverified; finite economics/combat/bots are drafted in code, authored-world parity/LAN/release validation remain open**. The numeric defaults in the newly created `mvp0-agent-implementation-contract.yaml` are still **proposals** and DO NOT describe the current implemented tick timing until migrated and checked.

The present report remains a mechanics/design gap audit, not a substitute for the more detailed [current development findings](../docs/SCALFAGUS-MVP0-DEVELOPMENT-FINDINGS-2026-10-11.md).

## Executive conclusion

The current repository tree enumerated **198 tracked files** at the time of the first audit pass, including **91 files under `design/`**. It has substantial world, faction, logistics, combat, economy and interface research. The **checked-in Godot app is still a camera/Hero/sprite/menu prototype**, not a functioning multiplayer RTS. In particular, `apps/game/scripts/main.gd` synthesizes its own undulating test terrain, five-view sprites and three diagnostic cameras. The currently visible `scripts/check.sh` invokes import, Hero/sprite/camera and menu smoke tests plus optional offline asset tests, **not** end-to-end resource collection, combat, networking or victory checks.

**Most important latest correction: DEC-033 is the CURRENT playable-release authority.** First shipped MVP 0.1 is **MAN versus MAN** on one universal floating space platform, four MAN templates, classic Overlord RTS only, and all three two-player controller pairings: H–H over LAN/loopback using two separate Godot clients and one authoritative host, H–C locally and C–C observed/headless. **DEC-031** later product FPP possession is explicitly deferred, and **DEC-032** provides the Godot-native headless balance lab. **DEC-030** still requires every playable world to be a floating platform in space. **DEC-024** defines building-class annihilation victory.

Previous **MAN–ETH five-role** specifications are a future expansion, NOT the current execution queue, regardless of older file headings such as `MVP-DELIVERY-GATES.md`. Their Energy/Pylon/UMU tuning is useful **after** completing the mirror first release but must NOT be loaded into `mvp_0_1`.

### Status and source-of-truth table

| Subject | Current first-release authority | Status |
|---|---|---|
| Owner decisions | `decisions.yaml` DEC-033, DEC-032, DEC-031, DEC-030, DEC-024 | Owner-approved design |
| One-race playable scope | `mvp0-man-mirror-rts-2026-10-11.md` + `mvp0-man-mirror-rts.yaml` | Designed, **not built** |
| Implementation sequence | `mvp0-man-mirror-backlog.yaml` M0-00..M0-09 | Todo |
| Acceptance criteria | `mvp0-man-mirror-acceptance.yaml` M0-01..M0-20 | Fixture specs, **not executable tests** |
| Initial playable map | `mvp-verdant-divide-map.yaml`, `battlefield-frames.yaml` | Authoring fixture, needs compiled collision/path validation |
| Headless simulator | `godot-headless-balance-lab-2026-10-11.md` | Design, **no measured match results** |
| Future MAN–ETH implementation | `mvp-gameplay-execution-contract.md`, `mvp-balance-playtest-v0.1.yaml`, `mvp-network-execution.yaml` | **Post-MVP-0.1** candidate only |

## Findings by implementation impact

### P0-01 — Active release precedence was contradicted by a newer numerical profile

The newer `mvp-balance-playtest-v0.1.yaml` states that MAN–ETH numbers are authoritative for a first MVP, and the original `agent-source-of-truth.yaml` starts with MAN–ETH, five roles, three cameras and Energy. This conflicts with **latest DEC-033**. Implementers who select the wrong baseline would mistakenly build two races and complex networks first.

**Resolution:** `agent-source-of-truth.yaml` must put DEC-033/one-faction mirror first; mark `mvp-balance-playtest-v0.1.yaml`, `mvp-network-execution.yaml`, `mvp-gameplay-execution-contract.md`, `mvp-hud-and-input.yaml` and `MVP-DELIVERY-GATES.md` as future two-faction fixtures, even if filenames currently contain 'mvp'. Agents must resolve the *release ID* before numeric profile selection.

### P0-02 — Missing single micro-MVP implementation profile for exact rule choices

The current `mvp0-man-mirror-rts.yaml` gives important core numbers — 35 Matter worker, 100 Barracks, 50 Rifleman; HP 1200/50/650/100; worker bag 10; basic rifle shot 8/1s; worker queue 7s, Barracks 18s, Rifleman 9s. However it leaves walking speed, mining interval, extraction slots, shot line-of-sight geometry and stage-by-stage payment, worker construction pause, refunds, material delivery to a site, final built unit spawn and producer destruction outcomes underdetermined.

**Resolution:** additional **separate proposed, versioned** `mvp0-agent-implementation-contract.yaml` provides candidate defaults without claiming owner approval or overriding DEC-033. Use a clear single-resolution hierarchy (release config → proposed implementation defaults → test fixture), and fail validation for missing required values rather than silently importing the MAN–ETH numeric profile.

### P0-03 — Construction and custody event accounting are not executable contracts yet

Owner's full-faction design has sophisticated physical Matter custody, loose crates, interruptions, recycling, MAN permanent scaffolds, ETH orb drops and unified graph. DEC-033 deliberately **does not require** UMU, recycling and network logistics for 0.1, but finite **worker-carried Matter** and **HQ delivery** remain mandatory. If Barracks can be paid from unrestricted global UI credits or a nonexistent local source, the prototype defeats its own economy premise.

**Minimum 0.1 contract:** every SOLID deposit decrements its finite stock; worker bag retains its real carried quantity; only actual delivery at own completed HQ increases **team spendable Matter**; Barracks can reserve that team Matter and spends exactly once on an accepted build; production reserves actual Matter once. In this simplified one-HQ-per-player economy, treat deposited Matter as team HQ-accessible inventory, **not** an unrestricted post-MVP infinite wallet. The configured result of aborting an unfinished Barracks and the source of any refund must be deterministic; salvage drops are **not required** for 0.1.

### P0-04 — Networking is a release blocker, not a postscript

DEC-033 explicitly requires **H–H LAN or loopback** using two **separate Godot clients** and an authoritative host. This is a much more demanding release gate than a simple local H–C RTS. Without command identity/sequence validation, duplicate/replay protection, bounded snapshot/state replication, disconnect policy and a two-process smoke test, the current promise is incomplete.

**Minimum:** exactly two player slots, `human|bot` controllers, each player may issue commands only for owned entities. Host assigns authoritative ticks and fixed order, receives commands (no client-supplied HP/inventory), checks owner/fog/resources/map bounds, acknowledges results and replicates authoritative state. Repeat sequence from one player must not execute twice. One client closing returns clear abort/error, not fabricated victory. Test with two separate processes against loopback/real LAN. No Internet auth, matchmaking, host migration or rollback for 0.1.

### P0-05 — Headless acceleration is not implied by Godot `--headless`

DEC-032 and the balance lab rightly distinguish no rendering from unpaced simulation. Running the current scene in a headless Godot window is NOT equivalent to 100s of accelerated valid matches. The renderer/actors and authoritative game rules must share one simulation core. There is no evidence from existing scripts that complete bot-vs-bot matches or batch replay exist.

**Minimum:** one deterministic scripted bot using **identical legal command validator** as a person, then an accelerated match-tick runner with pinned rules/map/bot profile and seed, emitted result JSONL, explicit draw/win reason and a state hash. Compare same-seed commands in normal and headless runs. Measure actual throughput; do not claim throughput or faction balance before execution.

### P0-06 — Map manifest conflicts with the simplified first-release spawn roster

The current `Verdant Divide` manifest includes `factions_allowed: [man, eth]`, **two start slots with `hero_location` and THREE worker locations each**, originally authored for MAN–ETH + Hero. For MVP 0.1, legal slots both use **MAN** and **no Hero is spawned as a game entity**. The map's optional hero positions may remain as dormant authored metadata, but an importer must ignore them for the current ruleset and MUST NOT spawn extra actors from the older roster.

The map proposes two equal 400-unit safe SOLID clusters and 1660 total physically placed units, real water and 10 fixed tree trunks. Route polylines are authoring intentions **not guarantees** that workers, barracks footprints and Riflemen can walk legally. Compile 64x64 real collisions and check both deposits, both bases, clearance around Barracks and at least two independent ground attack routes.

**Resolution:** bind the map to the active `mvp_0_1` ruleset using a **match-level faction/roster override**, not a copied second map or a fake ETH spawn. Reject illegal frame variants: `floating_space_platform` is mandatory on **ALL** playable Scalfagus maps per DEC-030.

### P0-07 — FPS/TPP instructions are obsolete for shipped MVP, but its smoke code should survive

Current `main.gd` has F1 Overlord, F2 Direct and F3 FPS, and the initial smoke test exercises the same Hero actor across three camera modes. Latest DEC-031 wants **two** perspectives overall (RTS/FPP), while DEC-033 ships **RTS only**. Retain the camera prototype for debug until a safe migration; the 0.1 playable menu/HUD must not advertise FPP, Direct or TPP features. Do not use old `mvp-hud-and-input.yaml`'s three-camera key map as shipping controls.

### P1-08 — Balancing is not possible yet; provide measurable mirror tests

The active MAN mirror fixture uses **identical units, stats and costs**, so it can measure **starting-side fairness, mechanical economy, bot strategy balance and pacing**, not MAN-vs-ETH faction win rate. Candidate starting 400 reachable Matter per side permits Barracks (100) + 3 Riflemen (150) + 2 replacement workers (70) = **320**, leaving 80 if the same stock remains reachable and no other spending occurs. It does not prove that those purchases complete by any given wall-clock time.

Suggested explicit starting rates for microbalance (see `mvp0-agent-implementation-contract.yaml`): MIN carry 10, 2s per Matter, 2.3 tiles/s on legal ground; 0.7s total pickup/unload overhead for a full packet; linear 8-tile one-way trip = roughly 27.66s and three uninterrupted workers produce ~65 Matter/min. These are **analytical examples**, not measured current Godot results. Target 8–15 min games is a development goal, while the candidate 20-minute cap yields an explicit **draw**. In case both teams lose their last buildings in the same tick, record **draw**.

For experimental parity, side-swap starting positions and bot policies under identical seeds; verify incomes, first Barracks/Rifleman times, resources captured, building eliminations, illegal orders and win/draw rates. A 50% mirror outcome between mirrored starts is a **statistical hypothesis**, not proven just because units are identical.

### P1-09 — Long-term inverse resource extraction must not rewrite current economy

The user approved a full three-form asymmetric design: **ORG worst at SOLID / fastest GAS; MAN worst at LIQUID / fastest SOLID; ETH worst at GAS / fastest LIQUID**, while every race must still obey the same SOLID, LIQUID and GAS **access gates**. The latest `resource-balance.yaml` documents this separately from canonical spending IDs Matter/Volatiles/Energy. Older hypothetical `ORG Matter 1.30 / MAN Volatiles 1.30 / ETH Energy 1.30` was a **different, legacy efficiency concept**, not equivalent to physical harvesting.

Do **not** introduce Energy mining, the gas=Energy shortcut, ETH network or ORG vessel simulation in the current MAN mirror. All current income is finite SOLID→Matter at a single symmetric MAN throughput, through workers and HQs. Save the inverse 3x3 production throughput hypotheses for three-faction balance after 0.1.

### P1-10 — Future complex faction logistics is credible but intentionally not implemented now

Current detailed contracts cover: ETH Nexus-only conversion into typed Ether, a single finite network moving goods+Energy+information, capacity-based eventual distribution, strict partition inventory; MAN UMU power/warehouse/bunker and separate cargo versus hybrid conductor/fiber; ORG live vessel supply plus two mitochondria; build caps ORG 3-2-1, MAN 1-2-2, ETH 1-2-3; loss-bearing salvage, tetrahedron/cube/orb world drops. These mechanics are design assets, **not additional MVP 0.1 obligations**.

The post-0.1 two-faction numeric profile `mvp-balance-playtest-v0.1.yaml` provides an initial **unverified** MAN–ETH tuning proposal, not a replacement for the micro-MVP's different costs or roster.

### P1-11 — Documentation, data compilation and real test execution must be separated

The repo contains many `*.yaml` files with test IDs, but a test scenario list is not a Godot test runner. The current Godot project has only the Hero/sprite and menu `SceneTree` smoke tests described above. Agent must implement actual GDScript tests for the M0-01..M0-20 fixtures, a real map parser/compiler with schema failure paths, authoritative replay and two-client networking tests. Avoid declaring the release “agent-complete” on documentation quantity alone.

`design/design-audit.yaml` predates present repository scale and still says full-tree enumeration was unavailable. Preserve that audit as historic context; this report supersedes its old coverage statement for the current release.

## Critical negative tests to prevent feature creep and regressions

1. Starting a micro-MVP match instantiates **two MAN HQs and exactly six MAN workers**, **zero** ETH/ORG and **zero player-controlled Hero**.
2. Invalid `bounded_planetary_surface` map or missing `floating_space_platform` is refused before match starts; background planet not attackable.
3. Worker SOLID extraction debits finite source; his cargo changes; team Matter credits only **after actual own-HQ delivery**.
4. Two clients cannot command the other team, replay an accepted serial number, create double queue purchases or select unseen enemy units.
5. Tree trunk stops path and shot; trees are **not** a farmable SOLID deposit. Ponds block ground but **do not produce Liquid**.
6. One real worker can finish the Barracks from legal funding; it does not accidentally invoke advanced MAN 1-2-2 production requirements, UMU or Energy.
7. Host/headless and observed C–C games use the **same accepted command stream and victory rule**; headless mode does not invent deterministic physics guarantees.
8. Destroy the opponent's last completed HQ+Barracks → win even if workers survive. Both sides' final completed building death in one tick → draw.
9. 20-minute *candidate* match cap → declared draw with reason, not a new resource exhaustion win condition.
10. Extra debug-only F2/F3 controls do not appear in shipped 0.1 UI or gameplay config.

## Actionable delivery order

- **Immediate P0:** patch canonical source-of-truth routing to DEC-033, introduce release-specific deterministic implementation defaults/test fixtures and tag MAN–ETH numerical files as **future only**.
- **M0-00–M0-04:** preserve existing Godot spike → authoritative two-team state/one flying map → finite Matter workers → Barracks/Rifleman → LOS combat and all-building win.
- **M0-05–M0-06:** legal C–C/H–C bot and truly accelerated Godot headless lab with JSONL/replay.
- **M0-07–M0-08:** two-client LAN host/join, UI and spectator flow.
- **M0-09:** executable acceptance tests, map geometry proof, replay reproducibility, paired side swaps, performance measurements, export checks.
- **Only after micro-MVP 0.1:** MAN UMU/Energy logistics, ETH networks and playable faction, ORG, finally possession/FPP, larger platform biomes and gameplay modes as separate decisions require.

## Evidence and limitations

**Confirmed in repository content:** filenames and documented owner decisions, active micro-MVP YAML and backlog, contents of current `main.gd`, `hero.gd`, `scripts/check.sh`, existing smoke test responsibilities, Verdant Divide deposit list, and presence of older MAN–ETH YAML. **Analytical inference:** candidate build order affordability and example worker mining round-trip. **Not confirmed:** parsing all YAML with the actual planned compiler, Godot engine runtime tests in this review, compiled route reachability, any completed LAN match, any headless full-match throughput, human playtests, numerical win-rate balance, correctness of every historical research claim.

**Do not assert complete implementation readiness based on documentation alone.** Agent readiness for the *current cut* improves when gaps are documented with a fail-closed default; genuine product readiness arrives only when M0-01..M0-20 are executed and pass on the pinned Godot runtime.

## Latest source-verified addendum — new MVP0 Godot implementation arrived during audit

**This addendum supersedes the old 198-file first-pass code-status snapshot above.** A later recursive tree observed **357 tracked blobs** while several other agents were actively committing. The repo now includes `apps/game/scripts/mirror_match_state.gd`, `mirror_view.gd`, `scenes/mirror_match.tscn`, `tests/mirror_smoke.gd` and `tests/mirror_batch.gd`, as well as vendored `addons/rts_framework` and `addons/keychain`. This is meaningful **unverified** new code, not only a camera prototype. There was **no complete H-H LAN server/client implementation** evidenced in the inspected mirror scene, and no Godot tests were run during this documentation audit. Current code and separate addon integration must be validated by the running engine; mere file presence does not mean integration.

**Additional latest owner rule DEC-034 (Reuse First):** do not invent another generic A*, physics, keybind manager, GUI system or socket transport; audit existing Godot built-ins and relevant vendored components, pin/check license/compatibility and write thin Scalfagus domain adapters. See [ADR-0004](../architecture/adr-0004-godot-reuse-first-wrappers.md), [module map](../architecture/godot-reuse-component-map.yaml), [integration report](../docs/GODOT-INTEGRATION-EXECUTION-MAP-2026-10-11.md).

**Numeric code-versus-design mismatch is now a P0 blocker for trustworthy self-play.** The source `mirror_match_state.gd` hardcodes **2500** total SOLID units vs **1660** authored, `MAX_TICKS=5400` vs suggested **24000**, mines a full ten-unit bag in six ticks, builds Barracks in 45 ticks and trains Worker/Rifleman in 45/65 ticks. The GUI in `mirror_view.gd` runs approximately **10 simulation ticks/s**, while design intends **20 ticks/s**. Please see the concrete [code parity review](mvp0-runtime-parity-gaps.md) and [machine gap register](mvp0-runtime-parity-gaps.yaml) for correct timebase, attack ranges, paths, map geometry, ENet identity, and strict single numeric-profile choice. No analysis of win rates from the unnormalized prototype should be represented as final balance.

**Current micro-release canonical numerical candidate** is the existing [mvp0-agent-implementation-contract.yaml](mvp0-agent-implementation-contract.yaml) linked by the latest `agent-source-of-truth.yaml`. The assistant-authored [mvp0-man-mirror-balance-v0.1.yaml](mvp0-man-mirror-balance-v0.1.yaml) is a **supplementary alternative analytical scenario** and is NOT safe to auto-merge. Numeric release profile requires actual Godot verification and, before real release, human/bot match measurements. Other general two-race contracts were marked **post-MVP0** under DEC-033.

**All new micro-MVP agent handoffs (not implementation claims):** [MVP0 execution](mvp0-man-mirror-execution-contract.md), [Godot host protocol](mvp0-man-mirror-network.yaml), [25 additional candidate balance tests](mvp0-man-mirror-balance-acceptance.yaml), and [active source precedence](agent-source-of-truth.yaml). The earlier all-map flying-platform and victory rules still apply. 
