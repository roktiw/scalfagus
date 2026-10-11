# ADR-0003 — Five authored viewpoints, mirrored to eight; one visual atlas shared across RTS/TPP/FPP

Date: 2026-10-11
Status: **OWNER-APPROVED FIRST PROTOTYPE ARCHITECTURE** (5 authored yaw views, 3 runtime mirrors, ONE perspective artwork set across all camera modes). **Visual feasibility, engine, shader and art production remain UNTESTED**.
Precedence: this ADR overrides conflicting 8/16-unique-view or mandatory separate RTS/FPP appearance expectations for the first renderer spike. It does NOT supersede gameplay, physical logistics, construction, shape grammar or canonical faction naming decisions.
Machine-readable specification: [directional-sprite-five-view-v0.1.yaml](../art/directional-sprite-five-view-v0.1.yaml)
Example implementation: [directional_sprite_five.gd](examples/directional_sprite_five.gd)
Discussion record: [five-view-mirroring-renderer-discussion-2026-10-11.md](../research/five-view-mirroring-renderer-discussion-2026-10-11.md)

## Intent
Scalfagus combines Dungeon Keeper 1-style zoom from base management into literal possession, Magic Carpet-inspired 3D landscapes, Realm of the Mad God direct steering and a 1990s console/PC pixel-art look. The world is physically three dimensional, but its entities — units, buildings, trees, rocks and props — are primarily **directional 2D sprite impostors**. No duplicated RTS/FPP game worlds and no compulsory 3D mesh replacement for a unit's appearance in FPS.

The chosen first experiment uses a SINGLE artist-authored azimuth artwork family for each object identity. The game renders **eight horizontal sectors from five authored angle views via mirroring**. The camera may rotate smoothly 360 degrees, zoom continuously and transition Overlord -> Direct/TPP -> FPS, without changing entity identity or switching to a second independently authored camera-perspective sprite set.

## Canonical 5-to-8 direction mapping
Direction reference is **camera viewpoint relative to ACTOR'S OWN forward axis**, not a world compass, sprite's screen translation, velocity, or camera yaw alone. Godot convention for the reference controller: actor forward = local -Z, right = local +X, world up = +Y.

The **front view** means the observer is located in front of the actor (the actor looks toward the observer). Angles positive toward actor's right when seen from actor coordinates. The authored frames are:

| Relative sector | Bearing | Visual name | Authored row/index | Mirror horizontally? |
|---:|---:|---|---:|---|
| 0 | 0° | front | 0 | no |
| 1 | 45° | front-right | 1 | no |
| 2 | 90° | right side | 2 | no |
| 3 | 135° | back-right | 3 | no |
| 4 | 180° | back | 4 | no |
| 5 | 225° | back-left | 3 | **yes** |
| 6 | 270° | left side | 2 | **yes** |
| 7 | 315° | front-left | 1 | **yes** |

Azimuth sector width is 45 degrees; maximum view quantization error is 22.5 degrees. Wrap angle at 0°/360°. First implementation uses nearest-frame hard switching (no default crossfade or synthetic rotation). Optionally add hysteresis around sector boundaries **after** visual testing. Eight-direction output is not eight authored textures.

### Correct camera-relative bearing
For **perspective** views: use horizontal projection of (camera_world_position - actor_world_position) to find where the observer actually stands relative to this particular actor. Do **not** use the camera's yaw alone; a camera may look across a scene and stand at different bearings to different objects.

For **orthographic** Overlord: the projected view rays are parallel, so use the camera's horizontal backward axis (the +Z basis of Camera3D) rather than a camera-to-actor position delta. This makes every equally oriented actor consistently choose the same view regardless of its position in the wide RTS frame.

Transform the flattened observer-to-actor bearing into the actor's local right/forward basis, then angle = atan2(dot(bearing, actor_right), dot(bearing, actor_forward)). Convert radians to degrees, quantize and wrap to [0, 7]. When the camera is nearly vertically overhead and the horizontal bearing degenerates, fall back to its horizontal backward axis or the last valid sector. All yaw math is visual and does not affect physics or aim direction.

## Render/world components

### Real 3D world — authoritative game code
- Terrain: actual 3D height/triangles/collision and proper pathfinding. Heightmap may be the first MVP terrain method; caves/bridges/digging demand additional geometry architecture and remain separate engine research.
- Entity: persistent entity_id, world position, forward facing, collision body/LOS, inventory, combat, resource movement, Hero/talents, valid command interface.
- Building: real world footprint and 3D collision/occlusion. A sprite is NOT the collision mask. Important doors/entrances have fixed **world-space** positions, even if art mirrors.
- Camera: three user-facing controllers — Overlord orthographic, Direct/TPP following, FPS possession attached to the same existing actor. Zoom/rotation are smooth; visual frame choice is discrete.
- Rendering is per-viewpoint. Local owner may hide possessed unit's own billboard without hiding it for everyone else or deleting actor. Hands/weapon HUD only if needed for readability, sourced from same design family rather than a second physics body.

### DirectionalVisual5 — presentation-only adapter
Inputs: (active viewer camera; actor world transform; animation name/frame; validated atlas/manifest; optional equipment overlays).
Outputs: (selected authored source row, flip_h, per-action animation frame, texture region, fixed foot pivot, visual depth behavior).
No authority: visual component may NOT create cargo, move actor, change HP/cooldowns, alter collision or defeat fog rules.

Scene prototype:
~~~
ActorRoot3D (CharacterBody3D or StaticBody3D)
  CollisionShape3D
  DirectionalSprite5 (Node3D, presentation)
    Sprite3D (Y-billboard, nearest, depth test ON)
  GroundShadow / SelectionFootprint
  Optional physical hitboxes / equipment collision
~~~
Static foliage/buildings use StaticBody3D and can reuse this exact presentation adapter; not all need an animated controller.

Implement in Godot using Sprite3D.region_enabled, region_rect and flip_h; source has 5 rows (authored angles), variable animation columns. Godot SpriteBase3D supports billboard and nearest filtering. Configure Y-only billboard as initial default for upright actors so feet remain grounded; compare full billboarding for unusual flying props. Disable fixed_size (so distance is real), keep depth testing on and use RGBA alpha — **magenta is QA preview only**, not in shipped sprite pixels.

## One SOURCE artwork set across camera modes
This is the strongest owner requirement: **do NOT silently ship a different artist-authored FPS angle set**. Five authored yaw views are reused even when the camera enters FPS. World geometry, collisions and occluders remain true 3D.

- The owner deliberately prefers retro image popping to overbuilding an asset pipeline.
- Screen pixel scale can change for readability, and multiple export scales/texture filtering may be tested, but the original viewpoint/source drawings stay the same.
- The own body billboard is hidden in possession so it does not cover the player's eye camera. All *other* sprites display via exactly the same adapter.
- No "FPS mode -> change sprite to a 3D character" automatic special case.
- An art-approved exception (multi-layer roof, additional view-angle set, hidden side geometry) is NOT included in the baseline and must be proposed after failing acceptance tests.

### Honest visual limitation: azimuth != camera elevation
The single source family only resolves horizontal yaw. At RTS camera pitch vs eye-height FPS, the visible top of a building, underside of a flyer, a tree canopy or a rock will be approximate and may look like a cardboard cutout. Fixed-Y billboarding alleviates ground anchoring but **cannot invent missing perspective**. Deliberately accept stylized cheats only if they pass visual and gameplay readability tests in all modes. Avoid claiming that using the same five images is guaranteed to reconstruct volumetric perspective.

A 2:1 dimetric diamond is a useful **camera preset** for overview and art; it cannot remain an exact 2:1 on-screen footprint at every free rotation/pitch in a true 3D scene.

## Mirroring policy: geometry > wishful savings
Horizontal mirroring is physically legitimate only if the sprite/prop design is sufficiently reflection-symmetric, **including functional details**:
- mirror_safe: true => all eight sectors derive from five rows.
- mirror_safe: false => art must redesign silhouette for symmetry, separate mirrored-safe detachable overlays (correct left/right state and world attachment), OR become an explicit, reviewable exception with 8 authored angles. An asymmetrical MAN drill, unique left-arm gun, one-sided entrance, text/logo, cargo socket or door does NOT magically switch physical sides in world logic.
- Reversible abstract triangular/square/circular faction emblems may mirror; readable text, numbers and directional arrows should be drawn as independent HUD decals with stable orientation or remain off mirrored surfaces.
- If a functional building door appears to shift on a mirrored sheet, the rendering fails even if collisions are right.
- ETH pylon ring symmetry and some ORG creatures can be mirror-friendly. MAN with modular unequal equipment and the lunar lander are likely the *hardest* cases. Validate on the lander and worker before mass production.

## Art source and manifest contract
**Recommended format:** one file per entity + action, frame grid **columns = animation frames, rows = 5 authored views**, with stable row order 0..4. All cells share dimensions and a foot/pivot; examples:
- MAN worker 24x32 px per frame, walk 4 frames => 96x160 px sprite sheet.
- Idle 2 frames => 48x160 px sheet.
- Prototype base poses require 5 authentic angle drawings per pose/action, not "five arbitrary designs from a concept poster".
- MAN lander 128x128 px per frame, idle 1 frame => 128x640 px sheet if it proves five clean symmetric rotational views possible; 3D collision shape is an independent world definition.
- For all entities, authoring a *single material source* (Aseprite/layered source) with logically separate actions is fine; the runtime may use one packed PNG per action or one atlas, selected by manifest.
- Runtime transparency = alpha; magenta background is reserved for documentation/contact sheets, not encoded chroma key.

JSON/YAML metadata must explicitly name original logical action, physical frame dimensions, FPS, authored rows and direction/flip lookup, pivot, world units per pixel or sprite physical size, shadow/selection association, mirror_safe flag, provenance/license and collision proxy ID. TypeScript CLI validates authored rows, image size, alpha and all region bounds and generates a Godot-readable JSON. Compiled output must have stable hash and never be manually edited.

**Historical concept status**: generated worker and lander images/current extracted atlas references are *research prototypes*, NOT evidence of five consistent 3D angle rotations. Do not claim ready-to-ship sprites or 16/8 directions simply because a PNG has multiple panels.

## Sprite size, zoom and world scale
- Established proposed sizes: MAN MIN economic sprite 24x32 with foot pivot around (12,30), closer Hero 32x48 as a **possible export/LOD** but NOT a mandatory second perspective; lander ~128x128 provisional.
- World tile 1x1 maps to nominal 32x16 pixels in 2:1 dimetric camera preset, but screen footprint changes with camera orbit. Colliders and floor selection remain world-coordinate based.
- 320x240 4:3 (minimum compact HUD); 640x320 2:1 alternative; 640x360 16:9 logical candidate; 3840x2160 UHD target with exact 6x nearest upscale from 640x360 if that presentation mode is used. Never horizontally stretch 320x240 to fill 16:9 4K.
- Freely adjustable zoom is allowed; pixel-perfect stepped zoom may be an optional mode. Fractional zoom/angle can shimmer; compare and profile, do not overpromise exact pixel-perfect geometry in all world views.

## Build steps (narrow prototype, NOT all RTS features)
**P0** — Artist: make one genuine symmetric MAN worker pose in five correct yaw views (no copied/skewed concept poster), one lander with visible real door and roof, one tree and one asymmetric rock as test objects.
**P1** — Rendering: implement DirectionalSprite5 mapping and correct per-camera viewpoint math; transparent Sprite3D atlas, flip_h and foot pivots; freely orbit camera; physical terrain collision and raycast selection.
**P2** — Control: keep same actor while switching Overlord (ortho), Direct overhead/TPP and FPP; hide local possessed body, still render other characters, preserve combat/HP/inventory.
**P3** — Failure hunt: stress reflections on left/right entrances, tools, shadow drift, camera above/under object, behind wall, rock/tree occlusion; 320x240 readability and 640x360.
**P4** — Freeze art conventions only after screenshot/video proof. Then generate source sheets for ORG/MAN/ETH and automate the atlas pipeline. If P3 fails, adjust policy as an explicit design change; don't secretly migrate the entire game to mesh characters.

## Tests / exit criteria
1. Eight sector outputs correspond to rows [0,1,2,3,4,3,2,1] and horizontal flips [F,F,F,F,F,T,T,T]; angle wrap around ±180, ±360 is correct.
2. Same yaw-facing actor viewed by orthographic camera at two different map coordinates chooses the same row, whereas perspective camera chooses the correct per-actor bearing.
3. Continuous 360-degree orbit produces a stable repeated eight-sector sequence and no wrong handoffs across 0°/360°. Boundary chattering documented; optional hysteresis later.
4. Sprite physical height remains stable and its foot pivot does not float as camera rotates or switches Overlord/TPP/FPP.
5. MAN worker's asymmetric tool and lander's door don't teleport to the opposite world side on mirrored frames; if they do, the declared mirror_safe design FAILS.
6. Other units remain visible in FPS using the SAME source art. The player's own body is hidden only locally, and their actor physics/HP/weapon remains.
7. Collisions, LOS, fog, cargo and building entrances are invariant to flip_h and angle selection. They are derived from world shapes, not artwork.
8. Terrain hills/occlusion, camera pitch extremes, FPS up-close lander and tall foliage remain visually acceptable in human screenshots. This is the **gating experiment** for the single source atlas.
9. All art inputs are real files committed with provenance after inspection, not inferred from generated moodboards. Source sprite sheet and validated manifest have matching checksums.
10. Any claim of completed Godot test must include logs/screenshots; mathematical reference code validation alone is not visual proof.

## Alternatives considered and explicitly NOT selected for first spike
- 16 authored yaw directions: higher asset cost, may reduce horizontal pop but does not solve elevation/perspective or functional mirroring.
- 8 uniquely authored yaw directions: important exception for some asymmetric objects, but NOT the base contract.
- Two separate top-down and FPS art sets (5+5): historically plausible, but explicitly rejected by owner for first experiment on cost/consistency grounds.
- Always-3D visible meshes in FPS: possible engine fallback, not authorized as default renderer.
- Separate top-down TileMap game + first-person 3D clone: rejected due to duplicated world/actor logic.
- Doom-style sprite impostor: shares concept but source verification of the exact original DK1 atlas layout is NOT a precondition for our own technical experiment. Do not assert 5 unique DK1 sprite views were verified purely from a conversational AI answer.

## Technical sources
- Godot Sprite3D regions/frames: https://docs.godotengine.org/en/stable/classes/class_sprite3d.html
- Godot SpriteBase3D billboard, alpha, flip_h, pixel_size, filtering: https://docs.godotengine.org/en/stable/classes/class_spritebase3d.html
- Related project architecture: [ADR-0001](adr-0001-one-authoritative-game-world.md), [art dimensions](../art/sprite-resolution-and-camera-profile-v0.1.yaml), [Hero camera modes](../design/hero-progressions-and-three-cameras-2026-10-11.md)

**Decision status**: the first prototype's 5+mirroring+one source set is approved by the owner. Its quality on every object class, special handling of pitch/asymmetric props, and engine selection are engineering hypotheses until a successful test.
