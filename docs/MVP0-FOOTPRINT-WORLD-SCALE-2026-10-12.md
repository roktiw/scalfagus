# Scalfagus MVP0 — 3×3 buildings and two-metre world

Status: **implemented on feature branch, local Godot 4.7.2 execution NOT RUN**.
Parent: the current `main` after the author's requested merging of #1, #5, #6,
#8, #9, #11, #12 and #13. GitHub Actions currently does not start a runner and
provides **no evidence** of successful build/tests.

## Implementation

- `MirrorGeometry` is the single geometry contract: each grid tile is 2 metres,
  every completed HQ / Barracks occupies exactly 3×3 tiles (6m × 6m),
  the entity's `pos` stays the center tile, and access is through 12
  deterministic cardinal exterior port cells.
- `MirrorMatchState` marks/unmarks all nine occupied tiles in both its
  authoritative `building_cells` index and Godot's existing
  `AStarGrid2D` adapter; it invalidates cached routes when buildings
  appear or die. A new Barracks site must have nine clear, unreserved
  and dry cells. Overlap with even **one** water tile, tree, source,
  mobile unit or existing building is rejected with no treasury debit.
- Workers physically approach a completed HQ footprint before unloading.
  A Barracks constructor must stand adjacent to the footprint, not
  on a future foundation tile. Two build orders cannot reserve
  overlapping footprints. Completed HQ/Barracks spawn units through
  exterior ring cells, never inside the occupied footprint.
- **Rifleman range is 6.5 metres**, computed in world metres against
  an actual target footprint tile, not 6 Manhattan cells to a
  building's artificial center. Grid LOS now considers footprint
  faces and blockers rather than just building anchor cells.
  Godot engine raycasting for elevation remains a separate
  implementation stage.
- Godot RTS 3D view doubles the old grid coordinates: 64×64 cells
  become a 128m×128m floating deck. Sprites, source nodes, pond
  tiles, camera, selection markers and pointer unprojection share
  `MirrorGeometry.tile_to_world/world_to_tile`. Visual HQ/Barracks
  now include an actual `StaticBody3D` + `BoxShape3D`
  (world width 6 metres). There is **no duplicate game-owned nav mesh**.
- Replay rules version advanced to `mvp0-man-mirror-v5-3x3-world2m`.
  The map source remains the existing compiled authored Verdant JSON.

## Regression coverage

`apps/game/tests/mirror_footprint_smoke.gd` exercises the nine blocked
cells, native nav occupancy, exterior perimeter, exact 2m
coordinate conversion, rejection of rim/overlapping/wet sites,
Matter payment, one complete Barracks build, producer spawn outside
the collider, a 6m-vs-10m shooting test, and removal of all nine
obstacles on destruction.

Also updated legacy map, nav, integrity, visual, timing and group-selection
fixtures for physical dimensions and external HQ/Barracks doors.
All tests are collected in `scripts/check.sh`.

```bash
git fetch origin
git switch feat/mvp0-building-footprints-2m-world-20261012
bash scripts/check.sh
bash scripts/dev.sh --editor
```

**No runtime verification happened in this environment**. The earlier test
suites were not previously demonstrated to pass either.

## Still open

- True 3D `PhysicsRayQueryParameters3D` LOS and terrain colliders for
  tree trunks, cliff edges and all elevation/ramps. Current combat
  has authoritative grid LOS and target-face awareness, not an audited
  3D height model; there is no claim of full physics equivalence.
- FPP possession, autonomous MAN logistics/doctrines, collision-aware
  moving actor separation and 3D pathing are outside MVP0.
- A completed Barracks is a 3×3 collider. An unfinished construction
  site is a **reservation** but does not yet have its own separate
  construction-site `StaticBody3D` or raycast visibility barrier.
- Actual Mac/Windows/Linux/Web export, real 20/100-unit throughput and
  multiplayer H-H validation remain pending.
