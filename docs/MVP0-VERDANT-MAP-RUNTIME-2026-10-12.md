# MVP0 Verdant Divide — compiled native Godot map

Status: **code committed in a stacked draft PR, real Godot 4.7.2 run NOT YET VERIFIED.**

## Canonical source and build contract

- **Source of truth**: `design/mvp-verdant-divide-map.yaml`. The design document remains the only place authors change fixed trees, water, spawn positions, source IDs, or Matter amounts.
- **Build-time only**: `scripts/compile-verdant-map.py`, using pinned MIT `PyYAML==6.0.3` `safe_load`, converts the manifest to strict native JSON.
- **Compiled checked-in artifact**: `apps/game/maps/verdant_divide.compiled.json`, with exact Git blob SHA-1 of the source YAML and a stable, sorted set of rasterized blocked cells. The Git SHA covers the authored bytes; the running match records a SHA-256 of the entire JSON.
- **Runtime**: `apps/game/scripts/mirror_map_port.gd` loads JSON with built-in Godot `FileAccess`/`JSON`, validates schema/frame/dimensions, constructs typed `Vector2i` terrain and source positions, and supplies the same data to `MirrorMatchState`, its `AStarGrid2D`, and `mirror_view.gd`.
- No YAML parser, Python process, external asset-fetcher, or dynamic map generator ships in the Godot game.

Exact map contents:

| Feature | Authored value |
|---|---|
| Topology | 64 × 64 bounded tiles, floating platform |
| Candidate physical tile size | 2 metres |
| Northwest start | HQ (9,9), workers (7,11), (9,12), (12,9) |
| Southeast start | HQ (54,54), workers (56,52), (54,51), (51,54) |
| Solid resources | **10** source nodes, total **1660** Matter |
| Equal safe start stock | 2 × 200 = 400 per side |
| Impassable terrain | 148 water tiles, 49 tree trunk tiles |
| Compiled terrain total | 197 fixed blocked tiles |
| Edge policy | Outer one-tile rim impassable |

One original YAML issue is intentional and now explicit: a circle of giant-tree trunk `trunk_s_02` intersects the south pond at tile **(28,46)**. **Water always wins on overlapping tiles**, maintaining the nontraversable pond and deterministic topology. No object is silently moved, and the issue remains eligible for an authoring cleanup in the source.

## Reuse-first evidence

Native Godot `JSON`, `FileAccess`, `AStarGrid2D`, `Vector2i`, `sha256_text`; pinned, external permissive MIT `PyYAML` only in authoring. There is no handwritten general-purpose YAML parser or replacement Godot pathfinder.

## Validations

`apps/game/tests/mirror_authored_map_smoke.gd` validates:
- all ten Matter sources sum to 1660, noncolliding and on-deck;
- both starts, six workers, symmetric 400 starting Matter access;
- native A* route from each start to its near source;
- water/tree geometry, outer bounds, central meadow and explicit water/tree overlap;
- stable authored map hash and reproducible initial simulation hash.

Existing mirror, visual, integrity and timing smoke fixtures were migrated off the old horizontal-map IDs and spawn positions. `scripts/check.sh` now runs the map smoke.

Validate the exact authored YAML against the precompiled JSON with:

```sh
python3 -m venv .tools/map-venv
.tools/map-venv/bin/pip install -r scripts/requirements-map.txt
MAP_PYTHON=.tools/map-venv/bin/python bash scripts/check-map.sh
# Regenerate after editing YAML:
.tools/map-venv/bin/python scripts/compile-verdant-map.py
bash scripts/check.sh   # local Godot; GitHub Actions runners currently unavailable
```

For regeneration, `python3 scripts/compile-verdant-map.py` with the venv Python is enough; commit both the YAML and compiled JSON together.

## Deliberately not yet implemented

- Authored **ridges, ramps, height levels** and their real 3D geometry/LOS; the source manifests them, but the game remains a flat platform at one world unit per tile.
- Full **2m visual-world metric** and physically collidable 3×3 HQ/Barracks footprints. Current Godot game still uses point-grid buildings. These must be implemented before claiming faithful authored world geometry.
- Route hint corridors are **validation hints**, not forced carved paths.
- Tree canopy fade, physical camera occlusion and water shoreline art remain future art/render integration.
- ENet LAN H-H and authoritative command-envelope/network snapshots are still separate MVP0 gates.

**Important:** no local Godot compilation/playtest or PyYAML `--check` output was produced in this chat; do not claim tests passed. No GitHub Actions runner can be trusted while it fails to start.
