# Scalfagus S1 — one world, five-view sprite renderer spike

**Purpose:** A deliberately narrow native Godot 4.7.2 engineering test, **not** the final Scalfagus MVP.

## Next required world and gameplay work (DEC-030)

**All future playable maps are floating platforms in outer space.** The first MAN-versus-ETH `Verdant Divide` is a 64x64 candidate bounded, stationary spaceborne deck covered in real brown jungle soil, tactical tree-trunk cover, nonharvestable freshwater, and finite surface SOLID deposits; it has visible physical edges/underside and an invisible four-sided gameplay collision guard. The sky planet is just background. Other platform surfaces can be industrial metal patchwork, desert rock or mixed terrain. Bare ordinary planet surface is not a valid selectable map, and true spherical navigation is out of MVP.

This **is not yet present as functional Godot map code**. Implement by following [AGENTS.md](../../../AGENTS.md), [MVP delivery gates](../../../design/MVP-DELIVERY-GATES.md), [map data](../../../design/mvp-verdant-divide-map.yaml), [world constitution](../../../design/space-platform-world-contract-2026-10-11.md) and [frame test cases](../../../design/battlefield-frame-acceptance.yaml). Preserve the native menu, three Hero camera modes and 5-view sprite smoke tests, with NO Tauri/second engine.


## Run locally

Install the official **Godot 4.7.2 Standard (GDScript)** editor for your platform. Open `apps/game/project.godot` in Godot. Or run from repo root (replace `godot` with your binary name):

```bash
godot --headless --path apps/game --editor --import --quit
godot --path apps/game
godot --headless --path apps/game --script res://tests/smoke.gd
```

The repo root does NOT need pnpm, Node or Tauri to run the game. Node is only for offline atlas checking (`node scripts/verify_atlases.mjs`). The project uses the Compatibility renderer for broad retro-friendly device coverage.

## Controls

| Key | Result |
|---|---|
| F1 | Overlord — orthographic RTS-style camera |
| F2 | Direct/TPP — following a real hero body |
| F3 | Possession FPP — camera at same hero's eye level |
| Tab | Switch through three modes |
| WASD | Move hero in Direct/TPP/FPP |
| Mouse movement in FPP | Turn view/pitch; Esc releases cursor |
| Q / E | Rotate camera/character view horizontally |
| Right mouse drag | Orbit in Overlord/TPP |
| Mouse wheel | Zoom Overlord |
| F9 | Cycle 960×540 / 640×360 / 320×240 window presets |

## What is being tested

- Real 3D undulating, collision-enabled terrain; real physics body for Hero, tree, rock and lunar lander.
- One actor ID, HP and cargo state across Overlord, Direct/TPP, FPP.
- `DirectionalSprite5`: camera-relative 8-sector selection from **five authored views** and three `flip_h` mirrors. Orthographic uses a shared camera axis; perspective uses per-object observer bearing.
- The same sprite assets and world objects in all camera modes. In FPP, local Hero body's visual is hidden to avoid a self-occluding card, but Hero physics and inventory remain.
- Inspect overhang/cardboard limitations and one-sided lander doors under free orbit and changing camera pitch.

## Why these atlases are marked provisional

`man_worker_32x48_*_5view.png` derives from previous user-directed concept-generated sheets. First five sectors are extracted from the 8-view concept series; `walk_reference` is a **second concept pose, not a genuine walk cycle**. `man_lander_128x128_unverified_5view.png` contains five different top-row *concept variants* that are NOT a geometrically certified rotational series. That is intentional for the first failure-discovery experiment. The tree/rock are simple authored placeholder drawings to isolate camera and occlusion issues.

Alpha channel is used, **not magenta chroma key**. The 5 source rows are ordered `[front, front-right, right, back-right, back]`; the runtime sector source indices are `[0,1,2,3,4,3,2,1]` with flip for 5–7. Mirroring an uneven MAN tool or lander doorway is a **known visible failure** and a critical visual gate, not automatically fixed by gameplay physics.

## Scope still missing

Not a full RTS: no build orders, harvesting, production, enemy AI, weapons, minimap, player win conditions, true 4K pixel-perfect implementation, terrain deformation or animation state machine. Visual FPS pitch and large structure art require human screenshots and inspection. An engineering green CI proves import/smoke tests, **not** that the art passes the FPP visual gate.

Documentation: `architecture/adr-0003-five-view-mirrored-3d-sprites.md`, `art/directional-sprite-five-view-v0.1.yaml`.
