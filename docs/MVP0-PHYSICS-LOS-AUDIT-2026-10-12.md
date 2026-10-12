# Scalfagus MVP0 — native Godot 3D physics LOS audit

**Status:** code committed on a separate draft PR; **Godot 4.7.2 real execution
NOT RUN** in this environment. PR #14 had a documented successful local replay
**before** PR #15 and the changes in this PR. Do not present that old result
as current-pass evidence. GitHub Actions still cannot run its jobs.

## What works in code

The first Godot-native physical terrain layer is built from the same
`MirrorMatchState.terrain` compiled from the authored Verdant YAML.
`MirrorPhysicsLos3D.attach_tile()` creates `StaticBody3D` and
`BoxShape3D` geometry with consistent two-metre horizontal footprints.

| Physical geometry | Count | Godot mask | Rendering & play behavior |
|---|---:|---:|---|
| Trunk cells | 49 | 1 / LOS | 2m × 2m × 4.8m, blocks visibility rays |
| Water cells | 148 | 2 / surface | 2m × 2m × 0.2m; opaque to pathing but *transparent* to above-water weapon LOS |
| Completed HQ/Barracks | 1 collider per building | 1 / LOS | 6m × 6m, built in PR #15; contains authoritative stable entity-ID metadata |

`MirrorPhysicsLos3D.trace()` uses built-in
`PhysicsRayQueryParameters3D` and `World3D.direct_space_state.intersect_ray`
to identify the **first real physics occluder**. When the first occluder is
the explicitly requested enemy building, its collider reports the target
entity ID and accepts a hit to its near face. Any other finished building
or tree is reported as blocking. Water is in a different collision mask.

`mirror_view.gd` exposes `physics_los_probe(from_tile, to_tile, target_id)`
as a diagnostics function. The game visualization creates native colliders
and supplies that function to tests and future debug overlays.

**Important authority boundary:** `MirrorMatchState` still decides
combat using the deterministic grid and visible building faces.
The physics result is **NOT** used to accept/deny commands or apply
damage, because renderer/physics scheduling could cause divergent
results in replay or ENet multiplayer. This is a parity instrument,
not yet a new gameplay authority.

## Tests

`apps/game/tests/mirror_physics_los_smoke.gd` is called by
`scripts/check.sh`. It waits for real `physics_frame` synchronization
and checks:
- exactly 197 colliders corresponding to authored water/tree raster;
- Godot collision masks for water versus tree;
- a ray crossing the authored trunk (19,15) → (23,15) is blocked;
- a ray crossing only water (31,20) → (33,20) is transparent;
- the native ray hits the near face of a completed 6m-wide HQ and
  reports its authoritative entity ID;
- firing *through* the same HQ is blocked;
- the collider is released after authoritative HQ death;
- no renderer-physics call creates/spends Matter.

After pulling the draft branch:

```bash
git fetch origin
git switch feat/mvp0-physics-los-audit-20261012
bash scripts/check.sh
bash scripts/check-gut.sh
bash scripts/dev.sh --editor
```

## Remaining work

The authored manifest has ridge/ramps/elevation semantics that still need
heightfield or static meshes and consistent raycast/occlusion integration.
No claim is made that a 4.8m tree-column is the final visual trunk mesh,
that 3D physics checks agree with the grid for every camera angle, or
that 3D rays are authoritative. Add differential probes for tree canopy
and cliffs before considering that switch. Unfinished building sites
remain reservations without physical blocking geometry; moving units are
not yet dynamic `CharacterBody3D` actors.

DEC-034 Reuse First: Godot built-in physics and the existing geometry
contract; no third-party physics addon or custom ray-casting solver.
