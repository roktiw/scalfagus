# Scalfagus — RTS Pathfinding + Minimap Development Handoff

Date: 2026-10-11
Status: **CODE WRITTEN, NOT GODOT-ENGINE VERIFIED HERE**. Supersedes the *straight-line movement* limitation in [RTS first-slice](RTS-FIRST-SLICE-2026-10-11.md) once this branch is imported successfully.

## Scope implemented in this change

- AStarGrid2D with a 64×64 logical grid and 2m cells over the physically 128×128m planar battlefield. Renderer and collision remain 3D. Grid has 4-neighbor routes (no corner-cutting), conservative clearance for MAN actor size.
- Physically obstructing MAN/ETH buildings, non-walkable water basins, trees, rocks and ETH Sentinel prototype bodies mark grid obstacles. Map is bounded with invisible collision walls; a decorative solid slab shows the jungle habitat floating in space. Bounds match the currently implemented simplified 128m square map, NOT every authored feature in canonical Verdant Divide YAML.
- Context right-click for selected MAN Hero and workers uses A* waypoints and spaced goal cells. It never turns static buildings into mobile actors. Path execution remains on CharacterBody3D, with collision and gravity unchanged.
- Hero supports `issue_route()`, `issue_move()` compatibility and `cancel_order()`, waypoints are consumed as the unit moves. F1/F2/F3 keep the exact same Hero object/HP/world position.
- Visual-only native-Godot Control minimap in the lower-left corner of RTS. It shows fixed water, trees, friendly buildings, owned units, selection, and RTS camera focus. **Debug minimap only**: it does not implement fog of war and reveals known placed map features.
- Added headless tests `apps/game/tests/navigation_smoke.gd` and included them in `scripts/check.sh`.

## Key current gameplay controls

| Mode | Keyboard / mouse | Effect |
|---|---|---|
| RTS F1 | WASD | Pan independent camera relative to yaw |
| RTS F1 | Q/E | Rotate 360 degrees |
| RTS F1 | Mouse wheel | RTS zoom |
| RTS F1 | LMB / drag | Select single / box-select MAN |
| RTS F1 | Shift+LMB | Add to selection |
| RTS F1 | RMB ground | A* movement path for selected owned MAN actors |
| TPP/FPS | F2/F3 | Control the SAME physical Hero |
| Any | Esc | Release mouse / return main menu |

## Tests and evidence hierarchy

1. CI or developer macOS: Godot 4.7.2 `--headless --path apps/game --editor --import --quit`, then `bash scripts/check.sh`. `navigation_smoke.gd` checks route detouring past obstacles, no blocked route cell, blocked-target snapping, no teleport from outside map, real scene obstacles, path storage/cancellation, minimap and Hero identity.
2. Manual Godot GUI: Start -> RTS, WASD pan, Q/E rotate, wheel zoom, select workers -> RMB far side of jungle, confirm avoidance of *visible* tree trunks and water with screenshots.
3. Manual input regression: drag marquee does not select enemy ETH or terrain; Shift adds units; select a MAN static structure -> RMB must NOT move it. F2/F3 keep manual control and return to RTS with unchanged HP/identity.
4. Visual proof: screen capture near terrain border to inspect floating slab/walls and HUD at 960x540 and 320x240. **Do not claim completed solely from headless success.**

## Explicit limitations / future agent tasks

- **Real-world A* navmesh is NOT implemented.** This is a coarse static 2D navigation grid over 3D height-field. It does not model slopes, bridges, flying/water units, newly constructed or destroyed buildings, worker crowd avoidance, nav avoidance from dynamic moving units, or path cancellation under enemy attacks.
- **MAP CANON STILL PENDING:** Current tree/water/building coordinates are deliberately simplified fixtures from an earlier PR, not a parser output of `design/mvp-verdant-divide-map.yaml`. Build YAML→validated JSON map compiler, cover/reed vegetation/ramps from canonical coordinates, spawn assignments, solid deposits, and geometry hash before claiming full Verdant Divide.
- **RTS action HUD still a prototype.** Matter is a fixed placeholder value; no production queue, build commands, harvested actual solid deposits, battle loop, or win condition.
- ETH uses visible placeholder geometric assets; do not substitute fake sprites or mirror asymmetrical details without art QA.
- Minimap currently shows even enemy buildings because fog of war is not implemented; label/debug mode prevents accidentally treating this as shipped competitive feature.
- Tests created here were statically inspected but cannot execute real Godot in this assistant runtime (no installed engine). GitHub Actions runners had failures without useful job logs in previous attempts; a Mac Godot import and manual screenshot QA remain required.

## Next tickets (ordered)

1. Run `scripts/check.sh` on actual Godot 4.7.2; fix GDScript parser/API issues if any. Capture `SCALFAGUS_NAV_SMOKE_PASS` and real screenshots.
2. Fix A* destination in narrow clearings and unit/collider clearance as needed from observed movement. Add unit-stuck detection/repath and discrete nav graph change events.
3. Generate the map from `mvp-verdant-divide-map.yaml` instead of hard-coded coordinates; verify 64×64×2m and 3 lanes/tree cover plus water collision.
4. Implement physical finite SOLIDS resource nodes and worker pickup→carry→store loop, then MAN UMU and ETH Nexus/Pylon logistics.
5. Add combat, simple hostile bots, building-class victory (`DEC-024`), fog-of-war and minimap visibility restrictions.
