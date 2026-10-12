# Scalfagus MVP0 — Fog of War / explored-memory presentation

Date: 2026-10-12 · branch `feat/mvp0-verdant-fog-of-war-20261012`

**Status:** implementation committed, **Godot 4.7.2 execution NOT RUN**
in this assistant environment. Complete existing Godot QA locally on Mac
before merging. This PR is independent of the open PR #25 construction
lifecycle and the PR #22/#24 native HUD/replay stack.

## User-visible result (Human vs Bot)

- Starts with **unexplored shroud** across the 64×64 Verdant platform;
  only the friendly NW HQ/workers and tiles inside line of sight reveal.
- Trees block visibility behind their trunks, but **the front face of a
  tree itself can be discovered**: it must not remain invisible simply
  because `MirrorMatchState._line_clear` treats the trunk at the target
  tile as opaque to weapon rays.
- Visited terrain remains **explored** after moving away, but receives a
  darker out-of-sight overlay. This is **geographic memory**, not
  omniscient live information.
- Enemy units continue to be visible only while the canonical
  `MirrorMatchState.can_see(0, enemy_pos)` succeeds. Unseen enemy
  units remain hidden, even inside explored territory.
- Matter source sprites are rendered **only within currently visible
  cells** (or in Bot-vs-Bot spectator mode); undiscovered nodes and their
  depletion state cannot be inferred from their sprite. An attempted
  right-click gather command on hidden Matter becomes an ordinary
  move order, instead of selecting an invisible source by its ID.
- Terrain sprites are absent in **unexplored** cells. Previously seen
  trees remain but are dimmed out of sight; authored water tiles are
  shaded by the fog overlay. The map still contains the same canonical
  49 tree blockers, 148 water cells, 10 sources and 1660 Matter.
- **Spectator mode remains omniscient** for two-bot tests. The visual
  shroud and hidden-source rules are disabled there.

## Architecture and performance

`MirrorFogOfWar` is a presentation-only `RefCounted` adapter; it
computes each team's `currently_visible` and `discovered` sets from
existing unit positions, the canonical integer vision radius (HQ 9,
others 8 Manhattan tiles) and `MirrorMatchState._line_clear`. It
remembers terrain without storing a duplicate resource/army state.
It caches by own-unit positions, object IDs, map digest and navigation
revision to avoid recalculating every render frame when nothing in
vision changed. It **never modifies** `MirrorMatchState`, economy,
replay hash, enemy AI vision, damage or movement rules.

`MirrorFogOverlay` is pure native Godot rendering:
two `MultiMeshInstance3D` layers (unexplored and explored-but-unseen),
with 4096 reserved `PlaneMesh` instances each, reusing the 2m tile
transform contract from `MirrorGeometry`. Only the required
`visible_instance_count` is drawn, and transforms are refreshed
only when own sight geometry changes. There are no 4096 independent
`MeshInstance3D` nodes, new shader runtimes, custom pathfinders or
third-party plugins.

For **completed buildings** `sim.can_see` still controls actual
enemy target visibility and combat legality; FOW never substitutes
a different authority. The scene-level `MirrorView` reconciles
unit visibility, sources, terrain sprites and two fog layers in the
same `_sync_visuals()` used by production, movement and destruction.

## Real regression gates

Added `apps/game/tests/mirror_fog_smoke.gd` to the existing hardened
`scripts/check.sh`. It verifies:

- friendly HQ is visible initially and distant enemy HQ undiscovered;
- source-cell vision equals the canonical `can_see` in the source's
  current position, rather than trusting global source metadata;
- no Matter or match-hash mutation when vision is computed;
- no redundant fog rebuild when positions/nav revision are unchanged;
- moving units away makes old territory explored but no longer visible;
- a tree is discoverable from an unobstructed adjacent cell;
- state reset clears geographic memory;
- native world scene uses exactly two MultiMesh fog layers, with
  4096 possible tile positions and no duplicate per-cell scene nodes;
- visible/hidden source sprites and no invisible gather target click;
- each of 197 terrain visual objects obeys explored-memory visibility.

Run on a Mac using the existing pinned Godot environment:

```bash
git fetch origin
git switch feat/mvp0-verdant-fog-of-war-20261012
bash scripts/check.sh       # expect SCALFAGUS_MIRROR_FOG_PASS
bash scripts/check-gut.sh
bash scripts/check-map.sh
bash scripts/dev.sh
```

Manual Human-vs-Bot: start at NW, confirm shroud; send Worker to
neutral center and verify cells reveal incrementally. Move back:
terrain remembered/dimmed, hidden enemy re-concealed, Matter cannot
be remotely selected through darkness. Restart match and verify old
exploration does not carry over; Bot-vs-Bot spectator sees entire map.
Check mouse pointer, camera, FPS on Mac M4 with 10/100 actors,
resolutions 1280×720 / 1440×810, and recorded ObjectDB/RID warnings.
Pin QA results to full commit SHA in `docs/qa/reports/`.

## Deliberate non-goals

LAN H-H remains paused by owner. No unseen-unit ghost markers, radar,
persistent last-known enemy position or new combat detection rules
are added. There is no change to spawn/production/Matter/seed/replay
format, nor new pixel art. Subsequent merge with PR #22/#24 should
preserve their HUD and replay controls while retaining the fog calls
around `MirrorView._sync_visuals()`.
