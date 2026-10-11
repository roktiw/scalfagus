# MVP 0.1 — Native AStarGrid2D navigation integration

Date: 2026-10-11
Status: **implementation committed on dependent PR; runtime NOT YET VERIFIED**.
Related: DEC-033 MAN mirror RTS, DEC-034 Reuse First; CODE-GAP-11.
Depends on the existing [MVP0 state integrity PR](https://github.com/roktiw/scalfagus/pull/6).

## Why

Before this change, the mirror RTS simulation used `_find_route()` with a home-written
breadth-first search over a Python-like GDScript queue. That duplicated a core
Godot capability, allocated queues repeatedly in a headless batch and violated
the approved reuse-first policy. The earlier technical spike already uses
`AStarGrid2D` through `scripts/grid_navigator.gd`, but its coordinate model
is **world-metre coordinates spanning -64...64** rather than mirror game
**tile coordinates spanning 0...63**. Reusing its implementation wholesale
would silently move everything to the wrong map positions.

## Implementation

- New **`mirror_navigation_port.gd`** is a thin, pure-GDScript wrapper over
  `AStarGrid2D`. It maps the 64×64 mirror match tiles to integer grid IDs,
  uses cardinal movement, a Manhattan heuristic and an impassable outer rim.
  It does not create a replacement search algorithm.
- `MirrorMatchState._find_route()` delegates to `navigation.route()`.
  Other game rules, commands and the original speed of **one tile per three
  fixed ticks** remain unchanged by this PR. This PR **does not** claim to fix
  the separate canonical 20Hz/movement-speed/economy-parity deficits.
- **Approach blocked targets:** choosing one of four valid adjacent cells
  by shortest native AStarGrid2D path. Workers cannot walk through the HQ;
  riflemen can chase enemy structures without occupying their cell.
- **Dynamic occupancy:** `_spawn` of a structure calls
  `navigation.set_blocked(cell, true)`, and destruction releases it.
  `revision` changes force queued movement to recalculate routes.
- **Terrain mutation:** `set_terrain_cell()` atomically updates both the
  gameplay terrain map and pathfinding. Direct external changes to
  `terrain` are unsupported except during setup; tests now use this setter.
- The adapter does **not** own collision physics, team ownership, resource
  ledger, combat legality or authoritative match scheduling.

## Smoke coverage

`apps/game/tests/mirror_navigation_port_smoke.gd` checks:
- actual Godot `AStarGrid2D` selected as provider;
- blocked platform edges;
- cardinal shortest detour around a solid tree and repeated-route stability;
- a sealed start (no invented partial route);
- a newly reopened path;
- legal adjacent building approach but not entry into the blocked goal;
- real `MirrorMatchState` route recalculation after a new enemy Barracks,
  then rerouting through the tile after its destruction;
- water-cell updates affecting live pathfinding.

Existing integrity smoke was adjusted to use `set_terrain_cell()`.
`scripts/check.sh` includes the new smoke alongside previous tests.

## Verification and known limitations

**No claim of a passing real Godot 4.7.2 run.** An actual Godot binary was
not available in the execution environment. Run:

```bash
bash scripts/check.sh
GODOT_BIN=/path/to/Godot bash scripts/check.sh
```

C-C `mirror_batch.gd` remains part of the dependent integrity smoke suite.

This version does **not** implement dynamic crowd avoidance, multi-unit
formations, map-YAML import, fixed-point movement speed, 3D NavigationAgent3D
or canonical 20Hz economy rebalancing. Those remain separate milestones.
The wrapper is replaceable after a measured comparison with the built-in 3D
navigation stack. The original `grid_navigator.gd` spike is preserved.

## Reuse evidence (DEC-034)

- Existing repository inspected: `apps/game/scripts/grid_navigator.gd`,
  `apps/game/scripts/mirror_match_state.gd`, `apps/game/tests/navigation_smoke.gd`.
- Reused engine API: `AStarGrid2D`, `get_id_path`, `set_point_solid`,
  `is_point_solid`, `is_in_boundsv`.
- External candidate: previously reviewed WIP `rluders/rts-framework`.
  Not required; would complicate ownership of the match state.
- Decision: **WRAP_GODOT**, no new dependency, no copied GitHub algorithms.
- Rollback: revert the dependent branch changes and restore prior BFS.
  No data migration, balance parameter change or renderer alteration.
