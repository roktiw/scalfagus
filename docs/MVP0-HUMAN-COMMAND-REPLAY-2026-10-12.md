# MVP0 — Deterministic HUMAN command replay (one human vs bot)

Status: **feature code committed, NOT RUN in Godot 4.7.2 on this branch**.
Priority: P1 gap in the locally executed QA report in PR #19.
Avoid UI/viewport files: other developers are concurrently working on the
menu/HUD and local Godot tooling in PRs #20, #21 and #22.

## Why the Bot–Bot replay hash was not enough

The original `MirrorMatchState.events` recorded only tick/owner/actor/action.
Without a target, a move or gather event cannot be replayed. Moreover, the
match state hash includes `rejected_commands`: recording only accepted
actions is insufficient to reproduce a human's failed attempts, even when
nothing visibly changes. An equal-seed bot match is only a seed regression,
not proof that the human input stream can be reproduced.

## Implemented gameplay contract

- `MirrorMatchState.issue_command` now delegates unchanged validation and
  gameplay mutation to `_execute_command`. Every **human** command
  attempt is recorded as a typed JSON-safe primitive (including rejected
  attempts), with tick, slot, actor, action, target and accepted boolean.
  Existing bot control behavior and economy timings are unchanged.
- Accepted `events` now contain the typed `argument`, too, while
  retaining their old fields for any legacy UI/tests.
- `MirrorReplayArchive.capture(sim)` stores version 1, seed,
  controller mapping, rules version, map identity and source SHA, final tick,
  final SHA-256 replay hash, and human attempt stream in issue order.
- `playback(json)` strictly validates schema, tick monotonicity,
  controller ownership, numeric types, allowed command argument types and
  map/rules provenance before recreating the original `MirrorMatchState`.
  Accepted and rejected human intents are reapplied **at the recorded
  tick and within-tick order**. Bots run their pinned deterministic policy
  from the same seed and are **not replayed twice**.
- Each historical command's accepted/rejected result is checked; replay
  finishes only if the authoritative final `replay_hash` matches.
  JSON-round-trip integral numbers are validated before int conversion.
- `save_user(archive, safe_basename)` writes
  `user://replays/<safe_basename>.json`. `load_user` reads it.
  Basenames allow only ASCII letters, digits, underscores and hyphens;
  path traversal is rejected. No networking, runtime plugin, or new
  dependency is involved.
- Unsupported arbitrary Variant Objects cannot be used to create a
  silently misleading replay: the capture marks their argument type as
  `unsupported` and playback rejects that archive explicitly.

## Local acceptance

`apps/game/tests/mirror_human_replay_smoke.gd` is added to
`scripts/check.sh` and checks:

1. One human vs deterministic bot, with multiple orders on the same tick
   including gather + move + rejected attack; additional stop and gather
   after multiple elapsed ticks.
2. Typed source IDs and grid cells preserved; JSON stringify/parse and
   save/load from `user://replays` reproduce the same state hash/tick.
3. Missing rejected command, changed destination, forged accepted result,
   decreasing command tick, bot-slot spoof, changed map digest, changed
   rules and unsupported Variant tags are detected.
4. Matter remains conserved; serializing the archive does not mutate the
   current simulation.

Run on Mac:

```sh
git fetch origin
git switch feat/mvp0-human-command-replay-20261012
bash scripts/check.sh
bash scripts/check-gut.sh
bash scripts/check-map.sh
```

Expected NEW marker: `SCALFAGUS_HUMAN_REPLAY_PASS`.
Local agent must submit the complete Godot 4.7.2 log and actual replay
hashes from the tested branch SHA. This assistant environment has
**no Godot executable**; success is therefore not asserted.

## Boundaries and next steps

- This is an **internal deterministic replay component and local
  user:// file API**. In-game Save Replay / Load Replay controls are **not**
  yet connected; integrate those with the new Command HUD after PR #22
  without rewriting or conflicting with current UI.
- Replays are pinned to the current rules+map SHA and intended for local QA,
  not guaranteed portable across engine versions or altered balance.
- A replay is *not an authoritative signed multiplayer proof*; hashes
  catch divergence and accidental corruption, not maliciously modified
  archives if the attacker also modifies hashes.
- This work does **not** implement, extend or merge the deferred ENet LAN
  PR #18. Keep priority on one human player.
