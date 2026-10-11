# Scalfagus — Flat Battlefield vs True Spherical Planetoid

Date: 2026-10-11
Status: **ARCHIVED TECHNICAL RESEARCH, superseded by DEC-030 for playable-map authoring**. All playable Scalfagus maps MUST now be floating space platforms. Actual spherical gameplay remains a hypothetical future engineering experiment only; no current map may choose a planet surface instead of a flying deck. See [world constitution](space-platform-world-contract-2026-10-11.md).
Machine-readable option contract: [world-topologies.yaml](world-topologies.yaml).
Current first map: [Verdant Divide](mvp-verdant-divide-map.yaml) is a strictly bounded PLANAR flying space platform. A spherical level would require a new explicit owner decision and is not a legal current map variant.
Design authority: [map authoring](world-environments-and-map-authoring-2026-10-11.md) and [MVP agent handoff](AGENT-MVP-IMPLEMENTATION.md).

## Why topology is gameplay, not cosmetic curvature

| Criterion | PLANAR (square/rectangular grid) | TRUE SPHERICAL planetoid |
|---|---|---|
| Basic game feeling | Classic Warcraft/StarCraft clear front lines | Planet-scale global siege / Little Prince geography |
| Map boundary | Physical edges or authored blockers | Surface closes onto itself; can attack from behind entire planet |
| Terrain coordinates | x/z + y height field | Surface normal and radial elevation; lat/long only for UI or editor |
| Ground pathfinding | Fixed rectangular navmesh or grid A* | Planet-surface geodesic graph/navmesh, adjacency across face seams |
| Units/building foundations | Common world-up, planar footprints | Per-position tangent basis, conforming ground footprints |
| Man UMU | Easy packed tracked vehicle travel | Curved travel path, local-up orientation and long circumnavigation |
| Eth Ether Network | Same graph and finite typed packets | Same logical graph but link range/LOS and path lengths are spherical surface-aware |
| Tree trunk hard cover | Simple colliders and rays | Same world collider principles but radial orientation and horizon |
| Liquid geometry | Ponds / streams height levels | Radial equipotential/surface-shell bodies or local basins |
| Hero Direct/FPS | Ordinary gravity and camera | Radial gravity, continuously changing upright, curved horizon |
| Fog/exploration | Rectangular minimap | Globe minimap or stitched unfolded faces; seam/pole handling |
| Map YAML | Sparse X/Z shapes and height overlay | Sphere coordinate charts, cube-face patches with authoring projections |
| Rendering/performance | Smaller scene and simpler culling | Sphere mesh/LOD, curvature culling, streaming, local normal |
| Risk for first MVP | Low | High, multiplies difficulty of every subsystem |
| Expansion over time | Adds independent maps | Adds entirely new topology; requires adapter abstraction now to avoid retrofit |

**Recommendation:** implement **PLANAR** first and encode a `world.topology` variant from the beginning. Do NOT claim spherical mode exists until a true 3D sphere with radial gravity, 360-degree wrapping land navigation and line-of-sight works.

### A tiny planetoid has an especially surprising combat problem

For a convex sphere of radius `R`, an observer with eyes at height `h` above the local surface has geometric horizon ground-arc distance approximately `sqrt(2*R*h)` when `h << R`, ignoring terrain and atmosphere.

Example: `R=36 m`, `h=1.7 m` -> horizon approximately **11 m** or only **~5–6 two-meter tiles**. A soldier with a 6-tile (12 m) weapon would frequently fail to target a ground soldier just across the curvature. At `R=1000 m`, horizon distance is ~58 m or ~29 two-meter tiles, which is comfortable, but the **entire sphere** then covers ~3.14 million 2x2 m cell equivalents. A spherical world cannot be just a 64x64 flat tilemap painted on a tiny globe without **changing visibility or scale**.

Exact surface horizon arc can be calculated using `s=R*acos(R/(R+h))`; the approximate formula is sufficient for scale sanity tests. Actual line of sight between two raised eye positions depends on both heights, cover and projectiles. The physics kernel must decide whether it is straight projectile ray, ballistic in radial gravity, or stylized curved pseudo-line-of-sight.

## Spherical implementation candidates

1. **Cube-sphere with six face patches** (recommended if later implemented): each face has a square raster/heightmap/quadtree. Normalize direction `v` from face UV, then `position=(R+height)*normalize(v)`. Build graph links across face boundaries with consistent orientation and no cracked seams. Never let two vertices on different face sides duplicate a deposit. A cube-sphere can be refined per camera distance with LOD.
2. **Icosphere triangle mesh:** more isotropic sampling but harder square-raster editing and structure placement; adjacency/tris need stable IDs. Viable alternate.
3. **Lat-long grid:** straightforward user coordinates but grid cells become very narrow near poles and wrap seam requires care; not recommended as underlying authoritative navigation lattice.
4. **Wrapped 2D torus/cylinder:** easy gameplay looping but **NOT a sphere**; no physical spherical horizon, poles, or true radial gravity. If added, label `toroidal` as a distinct type, not `spherical`.
5. **Flat localized patch over curved background:** can fake a planet camera but **not** a true walk-around planetoid; not acceptable as implementation of user-requested spherical mode.

## Suggested engine contract for future topology adapter

```text
interface WorldTopology {
  sampleSurfaceHeight(surfaceCoord) -> height
  surfaceToWorld(surfaceCoord, radialOffset) -> Vec3
  worldToSurface(worldPoint) -> SurfaceCoord
  upAt(surfaceCoord) -> Vec3
  tangentFrameAt(surfaceCoord) -> (forward, right, up)
  groundNeighbors(surfaceCell) -> []SurfaceCell
  surfaceTravelDistance(a,b) -> metres
  hasTraversableConnection(a,b,footprint) -> bool
  worldRaycastLOS(aEye,bEye,coverColliders) -> hit
  footprintPlacement(surfaceCoord,rotation,dimensions) -> legal
  distanceForNetworkLink(a,b,edgeSpec) -> metres
}
```

- `PLANAR` = `{x, z, elevation}`, up=(0,1,0), bounded width/height, heightmap.
- `SPHERICAL` = `{cube_face, uv, elevation}`, up=normalized position relative to sphere center, radius, seamless graph.
- Neither MAN, ETH, resource ledger nor combat systems should directly assume a world-axis Y-up or raw Euclidean X/Z *ground travel* when a topology adapter is available.
- Rendering and simulation share **one** world geometry per map; RTS vs Direct/FPS views never create independent physical scenes.
- A globe would need own **scenario budget**, stronger map validator, test plan, pathfinding/camera experiments and asset/physics spike before implementation.

## Map flag proposal

```yaml
world:
  topology: planar                # planar | spherical
  gravity: uniform                # uniform | radial
  planar:
    width_tiles: 64
    height_tiles: 64
    tile_meters: 2
  # spherical:                     # only when topology=spherical
  #   radius_m: 1000
  #   grid_type: cube_sphere
  #   faces: 6
  #   resolution_per_face: 256
  #   gravity: radial
```

Treat alternatives as discriminated variants: if `topology: planar`, the `spherical` block should be **absent or disabled** and vice versa. The YAML `world` example here is a proposal for a future map manifest extension; `mvp-verdant-divide-map.yaml` currently uses `grid` and can retain it under `world.planar` when a compatible versioned migration is implemented.

## Sphere-specific future acceptance tests

- Path across two neighboring cube faces has same distance/collision from either direction and no teleport, gap or duplicate entity ID.
- Unit can circumnavigate 360° and return to same site without falling off the navmesh; no accessible artificial map edge.
- Deployed MAN UMU footprint and local power cables conform to tangent plane/radial gravity; moving UMU retains `victory_building`.
- ETH pylon link route/capacity across face seam follows same graph economics and conservation as planar.
- Ponds follow local potential and surface height; no water walk unless the unit has the capability.
- Fixed tree-trunk collision and ray LOS work near every face boundary and at poles; camera keeps stable local-up.
- Hero FPS controls orient up along local surface normal with horizon/physics understood, while RTS camera can orbit globe.
- Seeded resource distribution does not bias polar/face corners or generate inaccessible deposits.
- Tiny-radius horizon warning is emitted by compiler for soldier attack range and eye-height parameters.
- Snapshot/replay recreates same spherical geometry, grid boundary links, source balances and elimination result.

## Decision state

**Historical note:** owner compared spherical maps with flat ones but subsequently required all playable maps to be **spaceborne platforms** (DEC-030). Sphere is not a valid substitute for that rule. No owner decision authorizes a playable spherical globe in MVP. Safe architectural choice: expose topology vocabulary and a topology-independent simulation interface, ship planar `Verdant Divide` first. Put full spherical implementation in separately budgeted **post-MVP research** rather than claim it is a one-line map flag.
