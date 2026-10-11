# Scalfagus MVP0 — canonical MAN fixed-tick economy slice

Status: **draft implementation on a stacked PR — real Godot runtime NOT tested**.
Dependencies: PR #6 state integrity → PR #8 native AStarGrid2D → this PR.
Applies DEC-033 and Reuse First DEC-034. The simulation remains authoritative
in one process; this slice does NOT implement multiplayer ENet or a new AI FSM.

## Implemented numeric candidate (from design/mvp0-agent-implementation-contract.yaml)

- 20 fixed simulation ticks per second, both GUI and unpaced headless.
  GUI frame delta *only* schedules complete simulation ticks.
- 20 game-minute timeout = exactly 24,000 authoritative ticks.
- Worker movement: integer accumulator, 115 milli-tiles/tick = 2.3
  tiles/s; Rifleman: 130 milli-tiles/tick = 2.6 tiles/s. Sub-step remainder
  is retained so movement never rounds 2.3 into 2.22 tiles/s.
- Gather 1 Matter after 40 *uninterrupted* mining ticks (2 seconds), up
  to 10 carried; at most **two** eligible mining workers per source,
  admitted by deterministic entity-ID order. Other workers wait.
- Worker cargo transitions: `mine -> pickup (7 ticks) -> return -> unload
  (7 ticks) -> mine`. Source debited at extraction, cargo credited in
  same tick, and real spendable treasury credited only after returning
  to the owning HQ and completing unloading.
- Production / build: Worker 140 ticks (7 s), Rifleman 180 ticks (9 s),
  Barracks 360 ticks (18 s of nearby worker labor).
- Rifleman cooldown: 20 ticks between 8-damage shots.
- Scripted bot policy reconsidered every 10 ticks (0.5 s).
- All values exported via native-GDScript `MirrorTiming` constants;
  no new proprietary A*, movement library, scheduler or plugin.
- `replay_hash` now includes movement accumulator and gather phase,
  preventing visually identical but economically different states from
  hashing as equal. Result includes rules version, ticks/sec and cap.

## New local tests

`apps/game/tests/mirror_timing_smoke.gd` tests exact 39/40 mining
boundary, ten-unit bag, pickup/unload latency, source-to-bag-to-HQ
conservation, three miners on a two-miner source, exact travel count
over two seconds for both kinds, 140/180/360 production boundaries,
combat 20-tick cooldown, 20-minute cap, replay hash sensitivity and
an actual GUI fixed-step tick using the `mirror_match.tscn` scene.

The old `mirror_smoke.gd` was re-budgeted for **real candidate economic
durations** without faking 100 Matter in a few seconds. One full C-C
match is still invoked by the local check suite to test accelerated batch.

```sh
bash scripts/check.sh  # local Godot 4.7.2; GitHub Actions unusable
```

**Execution evidence:** None yet. Source-only verification is not a PASS.

## Still outstanding

This is a **timing/economy increment**, not full MVP0 equivalence.
The visual map still has four hardcoded source nodes totalling 2500 Matter,
while the authored Verdant Divide candidate has more nodes totalling
1660 Matter. The 64×64 gameplay tiles are not yet derived from the
canonical map manifest, and visible 3D world uses one world unit per
gameplay tile instead of its candidate two-metre measurement. LOS is
not yet tied to real raycast colliders; rifleman range remains six
Manhattan grid cells rather than an audited 6.5-world-metre metric.
The player's Matter remains represented by a team treasury record
(which PR #6 clears on HQ destruction) rather than an independent
typed HQ storage component. LAN H-H, legal command envelopes,
source queues/fairness and modern bot doctrine are also separate gates.
Do not claim benchmark, playtest, multiplayer or full economic balance.

## Reuse evidence

- Built-in Godot `RefCounted`, `AStarGrid2D` (from PR #8),
  native `Node._process`/fixed tick accumulator, dictionaries and typed
  scripts; no alternate task scheduler.
- `MirrorTiming` holds domain-specific canonical constants, not a
  replacement timing engine.
- Headless and GUI call the exact same `MirrorMatchState.advance()`.
- Rollback by reverting this stacked PR only after PR #8 is merged.
