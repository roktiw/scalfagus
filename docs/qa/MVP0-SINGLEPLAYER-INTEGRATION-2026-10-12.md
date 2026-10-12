# MVP0 single-player integration — minimap shroud, replay rules, restart

Status: **source-level implementation; real Godot 4.7.2 integration QA still required**.

This patch reconciles the eight merged MVP0 PRs on native Godot, targeting **Human vs Bot MAN mirror**. LAN remains deferred. No new gameplay units, balance, generated art, or authoritative mechanics.

## Corrected integration regressions

1. **Fog-safe native minimap:** the main renderer respected shroud but `mirror_minimap.gd` still painted all trees/water and every nondepleted Matter source. Unknown map cells are now dark; previously explored but currently unseen terrain is dim; deposits appear **only in current sight**. Enemy symbols pass presentation fog *and* existing authoritative `can_see`. Friendly symbols remain visible. Bot-vs-Bot spectating remains omniscient. These rules are presentation-only.
2. **One v6 rules identifier:** after PR #25 construction cancellation, the authoritative hash used `mvp0-man-mirror-v6-construction-lifecycle`, while `result()["rules"]` still returned v5. `MirrorMatchState.RULES_ID` is now the one source for both, and replay captures identify v6. Replay archive format is still v2; legacy incompatible v5 archives fail with `rules_mismatch`, rather than silently playing with changed economics.
3. **No shroud-memory leak on replay restart:** `MirrorView._restart_replay` resets the nonauthoritative exploration cache before refreshing the newly rebuilt replay session.

## New automated regression

`apps/game/tests/mirror_singleplayer_integration_smoke.gd` checks hidden and remembered enemy HQ cells, visible/hidden resource nodes, Matter/hash immutability, v6 capture and metadata acceptance, v5 rejection and restarting playback without stale exploration. Registered in `scripts/check.sh`.

## Native macOS acceptance (not performed in tool-only environment)

```sh
git fetch origin
git switch fix/mvp0-singleplayer-fog-replay-parity-20261012
bash scripts/check.sh
bash scripts/check-gut.sh
bash scripts/check-map.sh
bash scripts/qa-local.sh
```

Required new marker: `SCALFAGUS_SINGLEPLAYER_INTEGRATION_PASS`. The older regression markers must also continue to pass. On a real Mac verify Play vs Bot → Mine → Barracks → Rifleman → Attack → End result → Save replay → Main Menu → Watch replay → Verified → Restart. Check minimap Matter shroud and remembered terrain while moving units, in standalone GUI (mouse, pause, HUD); record tested full SHA, engine version, and logs in `docs/qa/reports/`. Do not describe this PR as QA-passing until actual execution evidence exists.
