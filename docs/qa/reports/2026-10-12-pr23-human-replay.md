# PR23 human replay — local Mac QA and fixes

## Versions and environment

- PR: [#23](https://github.com/roktiw/scalfagus/pull/23).
- Original candidate: `f6700e2e38cbc3bfa73cbbc0d8a06689ea5a12c5`.
- Final tested code: `0f7dcaf156bcf6a020415d75f9beb5a0222b3bb5`.
- Platform: macOS arm64 / Apple M4, Godot `4.7.2.stable.official.ed1daf0bf`, GUT 9.7.1.
- Separate checkout: the existing menu/HUD branch and installed app were not overwritten.
- Overall: automatic replay/backend QA **PASS after fixes**; replay HUD integration remains a separate acceptance task.

## Actual results

| Scenario | Exit | Status | Evidence |
|---|---:|---|---|
| Original candidate `check.sh` | 0 | PASS existing tests | `original-check.log` |
| Extended malformed metadata test before fix | 1 | FAIL | `lifecycle-validation.log` |
| Changed rejected history before integrity fix | 1 | FAIL | `history-integrity-before.log` |
| Final format-2 `qa-local.sh` | 0 | PASS all gates | `qa-format2-final.log` and final individual gate logs |
| Original human replay smoke after fixes | 0 | PASS | original-smoke log and final Godot gate |
| Full human-bot lifecycle replay | 0 | PASS | final Godot gate and repeated runs |
| Fifteen malformed/schema/version cases | 0 | PASS | `SCALFAGUS_REPLAY_VALIDATION_PASS` |
| Ten independent full lifecycle runs, format 2 | 0 | PASS, same terminal SHA-256 in every run | `format2-repeat-10.log` |
| Native non-headless lifecycle run | 0 | PASS, actual OpenGL renderer | `format2-native-lifecycle.log` |
| GUT | 0 | PASS 4/4 tests, 32 assertions | final GUT log |
| Map parity | 0 | PASS | final map log |
| Five-view mapping | 0 | PASS 6/6 tests | final five-view log |
| In-game Save/Load buttons and replay viewer | n/a | NOT_RUN | Not implemented by this backend QA change |
| Exported replay runtime / other platforms | n/a | NOT_RUN | Tests used the pinned Mac editor binary |

Logs: `logs/local-qa/pr23-replay/` and `logs/local-qa/2026-10-12-130442-0f7dcaf15/`. Intermediate reports are superseded by this report. Documentation commits after the tested SHA do not change runtime code.

## Confirmed bugs and repairs

### RQA-01 — malformed metadata raises a GDScript error

An archive with `map_hash` set to a Dictionary reached a String comparison and raised `Invalid operands 'String' and 'Dictionary' in operator '!='`. This is a load-time technical defect, not valid replay divergence. Rules had the same missing type guard.

Explicit String checks now reject map/rules/archive metadata with structured failure reasons before comparisons. Regression covers object/array/null metadata, fractional format/coordinates, invalid seed/tick, controller types, accepted outcome and hash types. No validation assertion was disabled.

### RQA-02 — state hash alone misses edited rejected history

Changing a rejected command after the terminal tick preserved `rejected_commands`, final state and the state hash. Original playback returned verified even though the command history had been edited.

Format 2 now stores and checks an independent SHA-256 over canonical ordered commands, including rejected/same-tick attempts and typed arguments. JSON integral floats are normalized before digesting. State hashing and gameplay rules are unchanged. Tests prove the formerly undetected edit fails as `command_history_mismatch`; an explicitly resealed changed accepted outcome still fails simulation validation. Format 1 archives are not silently accepted or migrated.

This checksum is integrity evidence, not author authentication. A party able to rewrite an archive and recompute its hashes can still create another internally consistent archive; no signing or multiplayer trust claim is made.

### RQA-03 — fixed QA filename can overwrite user data

The original smoke test saved and removed `qa-mirror-human-42.json`. It could replace an existing user archive with that name. QA filenames now include process ID and monotonic time and tests remove only the file created by that run.

### RQA-04 — runner gaps

The new replay smoke was invoked directly, bypassing the existing zero-exit script-error detector. Both replay tests now use `godot-qa-run.sh`. `qa-local.sh` also accepts a Git worktree `.git` file, enabling clean isolated local replay QA.

## Complete lifecycle checkpoints

The fixture uses normal legal commands and actual mining/delivery; it does not grant artificial Matter or inject units. It records gathering, movement, Worker/Barracks/Rifleman production, an accepted integer-target attack, and a rejected attempt at the final tick. It validates JSON round-trip hashes at active build/production, attack and terminal checkpoints, checks Matter conservation, saves/loads the complete match and verifies that `setup` clears history.

| Checkpoint | Tick | Human attempts |
|---|---:|---:|
| Worker production and Barracks construction queued | 2584 | 5 |
| Rifleman queued | 3549 | 7 |
| Accepted attack | 4253 | 9 |
| Match end plus rejected terminal attempt | 6833 | 10 |
| Fresh setup clears history | 0 | 0 |

Repeated terminal hash: `7a997e7b63a1abd60687c5efeba3eff551ddf0cf091e7e8b38a9f743d383a8d4`.

## Limits and next integration

- No balance, map, costs, timing, faction doctrine, combat authority, menu or HUD file was changed.
- Existing smoke teardown RID/ObjectDB warnings and clean-checkout Keychain UID fallback warnings remain visible; no replay script error remains in the final gates.
- `playback` verifies/recreates a simulation and returns its result; this test is not proof of an interactive timeline viewer.
- Coordinate integration with `feat/mvp0-in-game-replay-controls-20261012`, which appeared remotely during QA. Those controls were not tested in this run. They must use format 2 and handle structured load errors without discarding the current match.
- LAN remains deferred.

## HANDOFF TO CHATGPT

[PR23](https://github.com/roktiw/scalfagus/pull/23) tested from `f6700e2e38cbc3bfa73cbbc0d8a06689ea5a12c5` to `0f7dcaf156bcf6a020415d75f9beb5a0222b3bb5` on actual Mac Godot 4.7.2. All final gates PASS; full resource-funded lifecycle, 15 malformed cases, disk round-trip and ten deterministic terminal hashes PASS. Fixed malformed metadata exceptions, undetected command-history changes, fixed QA filename and runner gaps. Format is now 2; update any Save/Load integration accordingly. Next: test the in-game replay-controls branch with the new HUD and preserve the current live match on failed load. Report: `docs/qa/reports/2026-10-12-pr23-human-replay.md`.
