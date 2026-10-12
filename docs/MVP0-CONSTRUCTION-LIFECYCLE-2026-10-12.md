# Scalfagus MVP0 — deterministic Barracks interruption lifecycle

**Date:** 2026-10-12  
**Status:** implemented on a draft branch, **real Godot 4.7.2 tests not executed in this environment**.  
**Scope:** one-human MAN vs Bot gameplay and local replay; H-H LAN remains explicitly paused.

## Existing MVP0 mechanics vs future MAN canon

The current simplified MAN mirror charges **100 Matter once** when a worker receives a valid `build_barracks` order. Work takes **360 uninterrupted 20Hz ticks at the exterior 3×3 foundation rim**; there is no separate partially constructed building entity, delivered material crate, or salvagable foundation in MVP0.

This change **makes existing semantics explicit**, rather than introducing new balance:
- Only **accepted** Stop, Move, Gather or a different legal Build order interrupts an active foundation. An invalid command does **not** cancel a paid worksite.
- On interruption, the 3×3 site becomes available immediately (reservation is derived from currently active builder orders), stale path/work fields are reset, and the event log emits `build_abandoned` with tick, actor, owner, typed site, remaining ticks and a reason (`stop`, `move`, `gather`, `new_build_order`, `builder_dead`, `site_invalidated`).
- Worker's death also releases the reservation and forfeits their ordinary carried cargo according to existing rules.
- A temporary mobile occupant in the 3×3 build footprint still pauses completion until it leaves; permanent invalidation (tree/water/structure/source) terminates the paid build with the legacy `build_site_lost` event plus the new typed abandonment event.
- A successful build spawns exactly one Barracks, blocks nine AStarGrid2D cells, and clears the builder's stale route/site/timer without emitting a cancellation.
- **Existing cost accounting remains unchanged**: committed Matter stays in `spent_matter` after cancel, death, or site invalidation; no instant refund, duplicated spending or retrospective debit. A legal replacement build order purchases a new 100-Matter Barracks.
- Rejected actions keep their original state and only increment the existing rejection ledger; they do not lose work progress or release the site.

**Important boundary:** `design/construction-phases.yaml` describes **proposed, not approved** later MAN behavior: persistent worksite, no progress decay when workers leave, salvagable installed Matter, crates and support from multiple engineers. This patch **does not implement** that proposal or imply owner approval. No economy balancing changes or new faction tech.

## Replay/rules identity

The authoritative match rules identifier changes from
`mvp0-man-mirror-v5-3x3-world2m` to
`mvp0-man-mirror-v6-construction-lifecycle`. That is deliberate:
replays of older rules should fail the v2 replay archive's **rules_mismatch**
provenance check instead of silently producing divergent outcomes.

The archive format remains **2**, including its separate SHA-256
`commands_hash` for rejected and same-tick human attempts.
The match state hash, command type/argument schema and Matter formula
are not otherwise redefined.

## Godot test

`apps/game/tests/mirror_construction_lifecycle_smoke.gd` runs under
`scripts/check.sh` and verifies:

1. Legal foundation reservation and only one cost debit.
2. Invalid move during construction does not disrupt or refund work.
3. Nine ticks' progress, accepted STOP, correct 351 remaining ticks in event, site release, retained sunk cost.
4. Accepted Move and Gather switch the worker to a new order and release old site without changing Matter.
5. Accepted new Build moves the reservation to a second legal 3×3 site and pays the second Barracks fee exactly once.
6. Builder death releases the old 3×3 site and retains prior construction accounting.
7. A tree occupying a reserved footprint prevents impossible Barracks completion; worksite is released on invalidation.
8. The uninterrupted 360-tick build produces exactly one Barracks and cleans up the worker's timer/site.
9. **Real** mining and HQ delivery of 100 Matter (no test-only funding), construction, STOP, JSON archive capture and full deterministic v2 playback to the **identical replay hash**.

Expected marker `SCALFAGUS_CONSTRUCTION_LIFECYCLE_PASS`.

### Local test commands

```sh
git fetch origin
git switch feat/mvp0-construction-interruptions-20261012
bash scripts/check.sh
bash scripts/check-gut.sh
bash scripts/check-map.sh
```

The agent should attach actual full Godot 4.7.2 Mac logs,
the final tested SHA, any first failing assertion/root cause/fix,
replay hash evidence and a Markdown handoff under `docs/qa/reports/`.

**No engine or native GUI exists in this assistant's execution environment.**
Do not claim a PASS, display successful gameplay or merge this draft based
only on source inspection. Manual H-C scenario and real pointer/viewport
checks remain a separate UI acceptance test, not evidence from this smoke.
