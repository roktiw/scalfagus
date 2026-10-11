# Scalfagus — Discussion Record: 3D Terrain, Pixel Sprites, Dungeon Keeper Possession and 5+Mirror Compromise

Date: 2026-10-11
Status: **chronological design-decision synopsis**, NOT a literal full raw transcript.
Canonical technical outcome: [ADR-0003](../architecture/adr-0003-five-view-mirrored-3d-sprites.md) and [five-view YAML](../art/directional-sprite-five-view-v0.1.yaml).
This log captures why the decision changed and what is still uncertain. Never rewrite past hypotheses as confirmed facts.

## 1. Original ambition and invariant
The owner defined Scalfagus as a **genuine 3D game world** with real height, terrain, occlusion, collisions and continuous 360-degree camera rotation, but a 1990s sprite-based visual identity. Faction units, mobile buildings, rocks, trees and props should be hand-authored pixel sprites. Strategic Overlord camera zooms into a directly steered unit (Realm of the Mad God-like top-down action/TPP), then into actual first-person possession inspired by Dungeon Keeper 1. Magic Carpet contributes true 3D landforms, hills and possible future terrain deformation.

**One world, one actor, one body of sprites in all modes** was the owner's repeated central request. Earlier assistant sometimes suggested a separate high-resolution FPS sprite set or even a visible 3D body in FPS, which violated this minimum-cost artistic thesis as default.

## 2. Earlier proposed artwork budgets
- A first design note adopted eight direction poses N/NE/E/SE/S/SW/W/NW for MAN worker, with 4 directions permissible for the engine spike and 16 to improve rotating-camera smoothness. Both designs assumed separate drawings for many poses.
- A previous assistant considered all objects in the world potentially needing 16 authored direction views. This increased the potential asset burden across Worker/Fighter/Shooter/Artillery/Tank/Flyer/Specialist, economic MIN/MID/MAX and all three factions ORG/MAN/ETH.
- Existing MAN worker specifications suggested 24x32px per source frame and a 32x48px detail version, but did not yet prove a working Godot sprite pipeline, true rotational consistency, same visual appearance in eye-level FPS, or a 320x240 performance/readability capture.
- A generated 9-view lander/concept board is a **visual reference**, not evidence of five mechanically consistent views around a functional door.

## 3. Discussion with Gemini, supplied by owner as a text attachment
The other assistant claimed Dungeon Keeper 1 used 8 displayed directions synthesized from 5 unique and 3 mirrored views. It further asserted the original game may have used **different overhead and first-person artwork angle sets**. These are *claims made in the supplied conversation*; a source file or original engine asset analysis was not furnished there. Treat historical fidelity of exact DK1 asset layering as **not independently established**. Scalfagus' choice does not require proving the original did precisely the same thing.

The Gemini conversation offered a generic angle selection pseudocode based on camera yaw minus object yaw. That formula is incomplete for a freely movable perspective camera: in perspective each object sees the camera from a potentially different bearing; in orthographic view use the common camera axis.

The owner then explicitly preferred **eight runtime directions produced from five authored directional sprites**, to reduce workload and increase a retro feel. The AI praised 16 earlier and praised 8 afterward; current project requires an engineering choice justified by numbers and tests rather than unconditional agreement.

## 4. Owner's final explicit request this turn
"Design the architecture for five sprites + mirroring, one set for RTS/FPP — cheapest, worth testing; save architecture, conclusions and discussion to the repo."

**Resulting approved baseline for the first prototype:**
- 5 unique horizontal views per action: Front / Front-Right / Right / Back-Right / Back.
- View sectors 0..7: [Front, Front-Right, Right, Back-Right, Back, mirrored Back-Right, mirrored Right, mirrored Front-Right].
- Free continuously orbiting camera 360°; image snaps to closest 45° view.
- Same ONE artist-authored view/pitch family across RTS Overlord, Direct/TPP and FPS for all object categories **where feasible**; no mandatory second FPS view suite.
- One authoritative 3D terrain/actor world; sprite is only visual presentation.
- Horizontal mirroring only safe for suitable artwork. MAN lopsided shoulder tool, a factory's left-only chimney or a lander's one-sided door cannot be assumed mirror-safe.
- View pitch mismatch remains open and requires a *deliberately ugly early prototype* to test rather than untestable verbal promises.

## 5. Budget arithmetic
If an actor has 2 idle + 4 walk + 4 work + 2 carry frames per angle:
- 5 authored views x 12 action frames = **60 manually authored frames**.
- 8 unique authored views x 12 action frames = **96 manually authored frames**.
- **36 fewer original frames, 37.5% reduction** in drawings for the per-action face sheets, provided mirroring is legitimate.
- 16 uniquely authored directions would have 192 frames; comparison is not a promise of triple performance or savings on every asset.
- Separate RTS/FPS authored 5-angle families would double 60 to 120 for those actions if both needed all animations. The owner rejects such duplication in the first experiment.

This saves authored-angle cost but not all labor: terrain geometry, buildings' door placements, animating props, physical logistics, collision, LOD, alpha testing and source originality are unchanged.

## 6. Geometric challenges discovered
### Horizontal plane
Correctly compute relative yaw using observer position for perspective, camera's parallel backward axis for orthographic. Quantize angles to 45°. During position transitions, do not accidentally use movement direction or a fixed global compass instead of actor-facing relative viewpoint.

### Vertical plane
Five authored yaw views do **NOT** convey changing camera pitch. At eye-level FPS a painterly overview roof or the underside of a giant ORG flying mother may be missing. Y-axis billboard helps anchor units but cannot construct unpainted faces. Overlord free camera cannot maintain exact 2:1 pixel diamond all yaw/pitch and perspective configurations. This is a *visual acceptance problem*, not theoretical invalidity of stylized 2.5D games.

### Mirroring and asymmetric assets
Reversing a panel may mirror inscriptions and relocate visible one-sided ports. Functional entrance/hitboxes stay in world coordinates; presentation needs consistent art. Best options in order: design symmetry from the start; separate decals/functional overlay tied to world ports; one explicitly approved extra angle set if necessary. An unsafe mirror is a failed asset quality check, not a reason to change collision logic.

### FPS possession
Hide the locally possessed actor's own billboard to avoid the camera clipping inside it. Every other actor remains the same 5-view sprite asset. No body/weapon duplicate, same collision/damage/inventory. If a near-eye-held tool is later shown, it must be consistent with owner assets and not create a second independently simulated actor.

## 7. Explicit rejected or deferred approaches
- Default 16 directions for all art merely because the engine allows a 360° camera.
- Two separately produced sprite-perspective atlases mandatory for all RTS and FPS objects.
- Default visible 3D character models in FPS to solve pixel pitch without playtest.
- One static 2D TileMap world and a separate dynamically synchronized 3D FPS world.
- Requiring every object to be a perfect 3D cuboid at arbitrary pitch despite intentionally retro constraints.
- Ship magenta chroma-key transparent backgrounds: store RGBA alpha; magenta only for debug/backdrop previews.
- Treat asset-generation concept posters or shuffled view collages as validated geometric sprite animations.

## 8. Testable hypothesis / next practical work
Create one real 3D Godot test map with sloping ground and four original assets:
1. MAN 24x32 MIN suit worker, with light exoskeleton and optional mirrored-safe gear.
2. Square lunar lander MAN 128x128, with stable doors/roof.
3. Tree whose trunk collides in 3D and crown is sprite-based.
4. Asymmetric rock with visible occlusion/collision.

Test full 360° free camera rotation, RTS orthographic, direct third-person and first-person, foot pivot, view index, mirror parity, doors, FPS pitch and depth across minimum 320x240 and 640x360. Existing sprite concept images are not yet five valid yaw views. Failures must be documented with captures before adding exceptions or mass-producing sheets.

## 9. Relationship to other project decisions
- Canonical names: Organs/Organites, Manus/Manusians, Eters/Etherans (DEC-008/009) unchanged.
- User's ORG triangular asymmetry makes mirror safety especially questionable for some creatures, not a universal prohibition.
- MAN square modular machines often exhibit functional left/right features; do not flip a recognizable one-sided cannon or entry.
- ETH circular/ring structures may be nearly mirror-symmetric, and therefore cheaper for this asset model.
- All construction/supply mechanics and three-color MTG philosophy are independent of the rendering decision.
- Base geometry remains world-space: screen-space ORG triangle / MAN square / ETH circle selection overlays do not change underlying 3D collision shapes or camera physics.
- No new factions/units, costs, 4th resource or source-extraction policy are implied by this renderer choice.

## 10. Documentation precedence
- **Owner-approved renderer baseline (first prototype):** DEC-017 + [ADR-0003](../architecture/adr-0003-five-view-mirrored-3d-sprites.md) + [machine-readable specification](../art/directional-sprite-five-view-v0.1.yaml).
- Older 8/16 unique-view art manifests and a 32x48 hero FPS/close-up asset proposal are retained **as history or optional detail**, no longer required for the first prototype.
- Do not silently edit earlier research conversations to falsely suggest this was known from the beginning.
- Engine capability to display regions/mirror is documented; actual project feasibility, camera pitch art, sprite atlas import, code tests and performance remain **unverified**.

**Outcome:** Optimize for one-world gameplay and a small, provable original-art pipeline. Make actual sprites before extending view counts. This is **cheap to test**, not guaranteed cheap to ship.
