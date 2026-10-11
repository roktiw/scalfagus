# RTS-first playable interaction slice — 2026-10-11

**Status:** Godot GDScript implementation committed for review. **NOT verified in a running Godot 4.7.2 engine in this environment**. Do not claim finished playable MVP.

## Shipped in this slice
- Existing Godot-only menu `START GAME` opens existing `main.tscn`.
- RTS / Overlord F1: camera-relative WASD panning independent of hero, Q/E map orbit, mouse wheel zoom with limits; middle mouse drag orbit (right mouse exclusively issues move orders).
- F2 Direct/TPP and F3 possession/FPP continue using the same hero ID/body and five-source-view sprite renderer.
- Left click selects own physical MAN units/buildings, Shift-left click adds to selection, left drag marquee box-selects MAN actors by projected screen position.
- Selection markers on MAN workers / hero; right click queues simple straight-line move target in world coordinates for mobile MAN actors; basic formation offsets. Structures do not move.
- Godot Control HUD: title/map/mode, provisional solids count, selected type/HP/status and controls. No TypeScript or Tauri runtime.
- Larger physically collidable 128m square terrain with fixed jungle tree trunks, rocks, two non-harvestable water bodies, MAN Command Core, UMU, HERO + 3 MAN workers and ETH Nexus/pylon/three clearly placeholder sentinels.
- Headless smoke contract for RTS map/state added.

## Explicit gaps vs canonical Verdant Divide spec
- This is **not** a complete YAML map importer. World uses a simplified authored-in-GDScript fixture and representative jungle features, not the full precise 64×64 tile layout, ridge geometry, canonical ten-solid deposits or deterministic generated map hash.
- No pathfinding around trees/water, no proper destination validation or flow fields; straight-line CharacterBody movement may stall at cover. Enemy sentinels are static visual placeholders, not AI.
- No mining, physical cargo, working Matter ledger, UMU cables, ETH Ether Network, combat, production, construction, FOW, minimap, bot strategy or DEC-024 victory implementation. HUD solids number is explicitly a fixture, not a working resource economy.
- No proper multi-unit movement avoidance, selection hover, destination marker, selection box occlusion handling, authority/multiplayer, pause menu or persistent UI options.
- Existing MAN art and Lunar Lander atlas contain unverified rotational variants; ETH art intentionally uses generic primitive placeholders.

## Next agent order of work
1. **P0** Run Godot 4.7.2 `--editor --import --quit`, existing smoke, new RTS smoke; correct GDScript warnings/errors. Manual interactive test macOS: Start → F1, WASD, Q/E, wheel, LMB/Shift/drag, right-click workers; F2/F3 and back to F1.
2. **P1** Implement actual map YAML → validated JSON → Godot reader, grid 64×64 at 2m/tile, water impassable, trunk bullets/LOS, two spawns, solid deposits and reproducible hash. Add map unit tests.
3. **P2** Implement RTS navigation/pathfinding (NavigationRegion3D or grid A*), avoid collisions and command target on impassable/occupied ground; raycast ownership, hitboxes and selectable building outlines.
4. **P3** Real HUD Godot scene/components + faction assets/icons, selection group cards, orders/status, minimap with camera footprint.
5. **P4** Five MVP types for MAN/ETH, economy and physical units, worker gather/deliver, bot, combat and victory by all completed building-class entities (including UMU/pylons).

## Launch

```sh
bash bootstrap.sh
bash scripts/check.sh
bash scripts/dev.sh
```

Controls F1 RTS, F2 TPP, F3 FPP, WASD pan in RTS/move Hero in TPP/FPP, Q/E rotate, wheel zoom, LMB select/drag, Shift add, RMB ground move, MMB camera drag, Esc menu, F9 window profiles.
