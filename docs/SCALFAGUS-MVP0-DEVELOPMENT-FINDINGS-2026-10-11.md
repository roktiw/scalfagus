# Scalfagus — Development Findings and Next Engineering Gates

Date: 2026-10-11  
Scope: **DEC-033 / MVP 0.1 — MAN vs MAN, Overlord RTS, two player slots**  
Status: **source committed, new gameplay unverified**. This file reports repository observations; it is not a test-run certificate.

Machine-readable companion: [mvp0-development-findings-2026-10-11.yaml](../design/mvp0-development-findings-2026-10-11.yaml).  
Active release scope: [MVP 0.1](../design/mvp0-man-mirror-rts-2026-10-11.md).  
Task backlog: [mvp0-man-mirror-backlog.yaml](../design/mvp0-man-mirror-backlog.yaml).

## 1. Decision recap

**Ship a small complete game before adding more races and possession.**

- One **MAN faction** on both sides, exactly **two** player slots.
- Three controller combinations: **human-human** (separate clients on LAN/loopback), **human-computer**, **computer-computer**.
- Playable MVP exposes **RTS Overlord only**. FPP possession remains an approved *later* direction (DEC-031); TPP is not a production mode. Preserve the existing camera and directional-sprite technical spike without treating it as a finished gameplay feature.
- Four MVP templates: **Command Core/HQ**, **MIN worker**, **Barracks**, **Rifleman**.
- One real finite resource loop, **SOLID → carried Matter → HQ → funded construction/training**.
- First map remains a mandatory **stationary floating space platform** (DEC-030): finite planar battlefield, impassable edge and water, trees as hard obstacles and line-of-sight blockers.
- One authoritative rules/command API, shared by humans, bots and headless tests. No separate rules implementation for spectator/headless play; no per-frame LLM bot calls.
- Winner is decided by destruction of all opposing completed building-class entities. Timeout/draw must be reported explicitly.

**The broader MAN vs ETH feature list, advanced MAN logistics/UMU, Energy, ORG, hero talent graph, FPS possession and Internet matchmaking do not block this first playable release.**

## 2. Confirmed repository artifacts (source, not runtime certification)

| Path | Current observed role | Verification |
|---|---|---|
| `apps/game/scripts/mirror_match_state.gd` | Two-slot MAN state, roster, finite sources/Matter ledger, orders, movement, construction, training, rifleman combat, local scripted bot, victory, replay hash | Source exists; Godot compile and scenario outcome **not verified** |
| `apps/game/scripts/mirror_view.gd` | Native Godot 3D floating-platform strategy view, unit selection/orders, local human-vs-bot and bot-vs-bot spectator | Source exists; interactive play **not verified** |
| `apps/game/scenes/mirror_match.tscn` | Entry scene for MAN mirror match | Source exists; loading **not verified** |
| `apps/game/scripts/menu.gd` | Local human-bot and bot-bot menu entries, legacy camera spike entry | Source exists; new transitions **not verified** |
| `apps/game/tests/mirror_smoke.gd` | Intended physical Matter, barracks, rifleman, victory and deterministic-match checks | Test script exists; **not executed here** |
| `apps/game/tests/mirror_batch.gd` | Candidate accelerated no-render bot-bot run, seed variation, optional JSONL result and summary | Runner exists; **not executed or benchmarked here** |

The current implementation is a **prototype step**, not a shipped RTS. It does **not** include synchronized human-human clients, final collision quality, a verified production economy loop or proven competitive balance.

## 3. CI findings

The user-provided local replay describes successful **legacy** menu/game/sprite smoke tests on macOS. Those results do **not** establish that the newly committed MAN mirror scripts compile and run.

The current checked-in `.github/workflows/five-view-spike.yml` and `.github/workflows/godot-native.yml` both already show the complete Godot 4.7.2 Linux SHA-256 ending in `...329e4`. **Do not blindly apply the old missing-digit fix again**. The historical local replay report is valuable evidence, but its workflow checksum diagnosis describes an older state than the currently fetched files.

On 2026-10-11, GitHub's Actions API returned recent `failure` conclusions for the two Godot validation workflows, including runs [38171957663](https://github.com/roktiw/scalfagus/actions/runs/38171957663) and [38171957648](https://github.com/roktiw/scalfagus/actions/runs/38171957648). Detailed job logs were not accessible through the connector during this check, so **the exact current CI failure cause is unconfirmed**.

Separate art pipeline risk: `scripts/build-faction-emblems.mjs` generates tracked atlases, while `.github/workflows/faction-emblems.yml` runs `git diff --exit-code -- assets/faction-emblems` after generation. The replay noted two changed PNG atlases. Validate clean-checkout reproducibility instead of disabling the diff gate or treating generated changes as harmless.

**Immediate CI gate:** run the official Godot 4.7.2 import and all old/new tests on a compatible host, capture stdout/stderr, and diagnose the *current* GitHub job failure from actual logs. Do not classify a workflow as fixed based solely on a corrected line in YAML.

## 4. Static-review risks requiring executable acceptance

1. **Fixed tick mismatch.** The match core advances in abstract ticks, the renderer currently consumes a 0.1-second accumulator (10 ticks/s at speed 1), while the earlier MVP YAML has a proposed 20 Hz rate and a separate match-duration expectation. `MAX_TICKS=5400` equals 9 minutes at 10 Hz, not the proposed 20-minute cap. Pick one explicit tick duration, derive action/cooldown durations and max match ticks from it; assert the same time semantics in graphical/headless play.
2. **Actual map/spawn parity is not proven.** Two sides use the same templates and resource prices, but cell-by-cell symmetry, deposit travel times, navigability and cover must be checked on the resolved geometry, including side swaps.
3. **Bot knowledge may exceed intended fog.** Bot source selection currently examines global source inventory/coordinates. Agree whether deposits are initially known map data or must be discovered; do not silently allow hidden real-time source-stock knowledge when humans are restricted.
4. **The worker/building occupancy model needs adversarial tests.** Building-site legality checks terrain and structure placement, but interactions with non-building actors, simultaneous builders, worker death and obstructed training spawn need validation before LAN play.
5. **Pathfinding/performance.** The current shortest-path search is computed on demand for individual moves. Profile 30/60/120 moving actors and long 1v1 batches before scaling the bot tournament. Do not optimize speculatively or replace Godot's core without a benchmark.
6. **Networking is absent.** The generic two-player simulation is not yet an authoritative LAN host plus two independently controlled network clients. Human-human is **not complete** simply because both owner slots exist in state.
7. **Regression coverage is not wired into CI.** Existing `scripts/check.sh` validates the legacy smoke, menu and assets, but does not yet execute `mirror_smoke.gd` or a bounded `mirror_batch.gd` run. Make newly added gameplay checks an actual CI release gate after fixing their failures.
8. **Headless and real-time parity** needs replay verification on the same initial seed, policy versions and accepted command stream. A SHA of a single final state alone does not prove ordering correctness or cross-platform determinism.
9. **Visual world requirement** is only partially proven by source. A cosmetic platform rim and terrain blocks in the new scene are not a validated 64×64 authored Verdant Divide compiler, navigability/LOS acceptance suite or polished pixel-art RTS presentation.
10. **Multiplayer security and state authority.** Before LAN: validate player identity/slot, monotonic command sequence, rate/ownership, fog, source spending, collision and event ordering on the host; never trust client state mutation.

Treat all 10 as **risk/validation work**, not evidence of bugs already reproduced.

## 5. Suggested next pull requests (strict order)

**PR 1 — Reproduce and stabilize.** Run Godot 4.7.2 import, old smoke, new mirror smoke, local spectator scene, a single headless bot-bot match. Fix parse/runtime faults. Add mirror smoke and a short bounded batch to `scripts/check.sh` and Linux CI. Capture exact outputs and hardware details. **Do not claim a PASS without running the command.**

**PR 2 — Contract correctness.** Define one simulation tick duration, timeouts, deterministic event ordering, material conservation, mirror map parity and actor/building occupancy. Add executable fixtures for illegal commands, finite resources, victory, pathing, worker death, starvation and actor training.

**PR 3 — Complete local Human–Computer.** From menu to actual win/draw and restart. Verify the bot uses the same commands/resources/visibility as the human. Test late-game and defeat flows, not only startup.

**PR 4 — Reliable Computer–Computer headless.** Batch matches without frame-time sleeps; pin seed/rules/map/policy hashes; write JSONL and useful metrics; measure wall-clock throughput and identify dominant policy/mirror spawn advantage. An LLM may analyze results later but is not needed to run matches.

**PR 5 — Human–Human local network.** Implement authoritative host, LAN/loopback Host/Join, two independent players, snapshot/command protocol, and consistent victory/disconnect handling. This is an MVP 0.1 **required feature**, not optional post-release work.

**PR 6 — Gameplay polish and playable release.** UX and input ergonomics, selection/move/attack clarity, visual readability, end-match feedback, performance, packaging and human mirror playtesting. Preserve old camera spike tests until replacement coverage is genuinely stable.

## 6. Mandatory verification commands

From repository root using a verified **Godot 4.7.2 Standard** binary:

```bash
bash scripts/check.sh
godot --headless --path apps/game --editor --import --quit
godot --headless --path apps/game --script res://tests/mirror_smoke.gd
godot --headless --path apps/game --script res://tests/mirror_batch.gd -- --matches 2 --seed 42
```

These are **commands to run**, not results. To inspect graphics, start the Godot menu and choose **PLAY MAN vs BOT** or **WATCH BOT vs BOT**; the LAN option is not implemented.

## 7. What to report after every subsequent coding session

Update the companion YAML with: touched files and commit, `implemented` versus `unverified` status, commands executed, exit codes, test result excerpts, known reproducible defects with seeds, measured match duration/ticks-per-second, performance environment, next unblocked task, and any approved scope change.

**Rule:** progress means code plus a reproducible test, not merely documentation or green legacy smoke.
