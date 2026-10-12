# Scalfagus MVP0 — single-player end screen, rematch, main menu

Status: **implemented in stacked feature branch, local Mac Godot test NOT RUN
for these new changes**. Scope is the owner-prioritized **one human against
one bot**, with Bot-vs-Bot spectator still supported. Human–Human LAN remains
paused. No new art or alternate UI framework is introduced.

## What the player can do

When `MirrorMatchState` declares the match finished by completed-building
elimination or the 24,000-tick time limit, a fullscreen native Godot modal
appears over the paused final battlefield.

- **VICTORY** — player slot 0 defeated all enemy completed buildings.
- **DEFEAT** — slot 0 lost its last completed building.
- **DRAW** — either both teams lost their last buildings in the same
  authoritative game tick or the match expired with neither side defeated.
- **Bot-vs-Bot spectator** sees **NORTHWEST WINS** or **SOUTHEAST WINS**
  instead of false human victory/defeat attribution.

The overlay shows the authoritative end reason, elapsed match clock,
and global Matter totals mined/spent/lost. It never mutates those values
or modifies the simulation result. It provides three native buttons:

1. **Play again** — load a *new* `MirrorMatch` Godot scene with tick 0,
   original mode (one human + bot, or spectator mode) and a clean
   `MirrorMatchState`. No old orders, units, collision bodies or
   match-state hash are carried over.
2. **Save finished replay** — Human-vs-Bot only. Uses the existing
   format-2 `MirrorReplayArchive.capture/save_user` and the normal
   validated `user://replays/last-human-match.json` destination.
   The save's status is shown inside the modal. Only legitimately played
   finished matches have portable replay command streams; tests that
   artificially kill an HQ must not claim valid finished playback.
3. **Main menu** — leaves the match using native Godot scene transition
   and resets `scalfagus/mirror_mode` to the ordinary one-human menu
   default. Spectators don't get a misleading human replay-save button.

## Implementation

- `apps/game/scripts/mirror_match_result_overlay.gd` owns the native
  `Control` modal; uses existing `command_ui_theme.gd`, extends full
  viewport, blocks underlying mouse input, uses keyboard-focusable
  `Button` controls and emits signals for retry/save/menu.
- `apps/game/scripts/mirror_view.gd` observes `sim.finished` during
  its normal `_sync_visuals()`. It constructs exactly one overlay only
  on a completed non-replay match. `_process`, pause and gameplay
  input cannot continue after the modal appears. This does not create
  new GameState ownership or change replay-hash material.
- No new modes or faction-specific rules. During **Watch Replay** from
  PR #24, the existing replay verification banner and playback controls
  stay in charge; the match-result modal is disabled to avoid covering
  the viewer before its recorded terminal commands/hash are checked.
- Draft PR #25 builds construction lifecycle separately. Draft PR #26
  implements fog-of-war separately. This change does not modify either
  subsystem; cherry-pick/rebase their native view additions when stacking
  later, never replace them wholesale.

## Native Mac QA required

```sh
git fetch origin
git switch feat/mvp0-single-player-result-restart-20261012
bash scripts/check.sh
bash scripts/check-gut.sh
bash scripts/check-map.sh
bash scripts/dev.sh
```

New `mirror_match_result_smoke.gd` expects
`SCALFAGUS_MATCH_RESULT_PASS`. It checks that an initial H-C match
has no result overlay; killing the final opponent HQ shows VICTORY;
repeated updates don't duplicate UI or alter hash; paused/gameplay
inputs cannot resume a finished world; real Play Again button creates
a fresh tick-zero H-C scene with conserved Matter; loss of own final HQ
shows DEFEAT; Main Menu button opens `MainMenu`; spectator victory
uses player-neutral slot labels and lacks Save Replay; simultaneous
elimination yields DRAW without accounting mutation.

Manual acceptance must include **an actual gameplay result**, not only
test fixture damage: Play Human vs Bot → gather → Barracks → Riflemen →
attack enemy HQ → VICTORY/DEFEAT → Save Finished Replay → Main Menu →
Watch Last Replay (v2 checksum verified) → new human match via Play Again.
Also verify a 20-minute timeout displays DRAW, responsive controls at
1280×720 and 1440×810, actual mouse clicks in standalone and embedded
Godot Game with Stretch to Fit. Report Mac engine version, SHA,
screenshots, actual exit statuses and sanitized logs under
`docs/qa/reports/`.

**Do not mark this code PASS based on the earlier tested PR #23 backend,
PR #21/22 UI QA, or #19 runner results.** The new combined branch's
Godot 4.7.2 code has not been executed by this remote assistant.
