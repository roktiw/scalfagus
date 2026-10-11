# MAN / Manusians — MIN Astronaut Worker: Isometric Pixel-Art Production Specification v0.1

Date: 2026-10-11
> **2026-10-11 CANON UPDATE — DEC-017.** The original eight-uniquely-authored-direction and mandatory close-FPS-proxy recommendations below are **historical proposals**, not current S0/S1 implementation requirements. The first renderer prototype uses **five authored yaw views + horizontal mirroring to eight runtime sectors and the same authored source atlas across Overlord, Direct/TPP and FPS**. See [ADR-0003](../architecture/adr-0003-five-view-mirrored-3d-sprites.md) and [current renderer YAML](directional-sprite-five-view-v0.1.yaml). Source frame size **24×32**, transparent PNG, 3D collision, pivot and MAN style remain proposed and reusable. DO NOT infer eight uniquely painted views or a second FPS art set from the old atlas-size examples. Functional asymmetric tools must pass mirroring safety review. Existing concept art is not a validated five-angle turntable.

Status: **proposed production specification**, based on user-approved *cute moon-landing / human in a spacesuit with minimal exoskeleton* visual direction, and the current proposed isometric pixel/camera standard. **No production sprites or Godot render tests are claimed.**

## Sources, precedence and scope
- [Sprite resolution and camera requirements](sprite-resolution-and-camera-profile-v0.1.yaml) — 2:1 dimetric diamond, nominal 32x16px tile, optional 64x32px detail tile, 320x240, 640x320, 640x360, 3840x2160 target profiles, eight directions eventually, initial four, separate VFX/shadow and bottom-center anchor.
- [Faction visual grammar](faction-art-direction-and-transport-v0.2-2026-10-11.md) — blue/white/industrial orange, asymmetric but modular machinery, physical supply routes, no generic identical humanoids for every MAN unit.
- [MAN economy and base mechanics](../design/base-ecologies.yaml) — MAN MIN can mine/build/repair/haul and support independent outposts. This body does not turn every other MAN unit into a human-in-suit: rovers, mechs, bots, transport chassis and vehicles are visually distinct.
- [Hero progression](../design/hero-progressions-and-three-cameras-2026-10-11.md) — three starter kits Engineer / Commander / Specialist use an open graph and three views on the same actor; visual gear can express the kit without creating different physics characters.
- Four conversation concept illustrations: **Field Engineer**, **Repair Technician**, **Prospector Scout**, **Logistics Crewman** — concept reference sheets, not extracted sprite atlases. Their displayed figure scale and inconsistent perspective are to be remade, not trivially resized. No source PNG is committed by this document.

## Art thesis
**One practical human worker in a pressure suit, not a chunky robot**. Retro SNES/Mega Drive-era pixel-art readability, cute but robust lunar-settlement exploration, portable industrial backpack, small visible knee/hip/forearm braces and explicitly HUMAN movements. Suit in ivory/white with hard blue visor, blue identification panels, orange hazard accents and compact modular tool sockets. One slightly oversized helmet is a proportion cue; most mechanical bulk stays in backpack/tool attachments, not in the base silhouette. Silhouette is first: rounded helmet + squat boxy trunk + tiny braced limbs + two huge functional boots.

MAN geometry: rectangle/square modules, docked packages, right-angle braces, squared shoulder panel and **square selection footprint**. A square tile under a 2:1 isometric projection appears as a **diamond**, so selection FX should mark its four projected corners or draw a 2:1 floor-plane quadrilateral; avoid a screen-aligned square disconnected from world grid. Keep the rounded visor/helmet: square faction grammar is about HUMAN ENGINEERING, not forcing human heads into cubes.

## Authoring grid and projection
| Concern | Proposed production target | Status / rationale |
|---|---|---|
| World tile | 1x1 world cell projected to **32x16 screen px** | From existing shared art standard |
| Detailed tile | 64x32 screen px | Optional look/zoom tier; same world cell |
| Projection | 2:1 **dimetric** (not mathematically true isometric): ortho Camera3D with approx azimuth 45°, elevation 30° | Camera parameters need Godot visual verification |
| Core MAN economic MIN | Transparent **24x32px RGBA** frame | Matches economic_min proposed in repository |
| Hero / closer overhead angle | Independently polished **32x48px** frame | Matches proposed military_standard size; **not** a dumb nearest-neighbor downsample/upscale of 24x32 |
| Logical occupancy | **1x1 world cell** for worker, separate collision body | Not determined by sprite rectangle; gameplay occupancy pending |
| Pivot/feet | Core frame **(12,30)**; close frame **(16,45)**, top-left = (0,0) | 0-index pixel coords; sprites need fixed pivot across actions/facings |
| Sprite cutout | PNG RGBA, nearest sampling; transparent outside silhouette | No fuzzy anti-aliased fringe |
| Palette | 12–16 working colors plus transparency; constrained ramps | Visual budget proposal, not literal NES hardware emulation |
| Shadow | Separate diffuse **14x4px** ground-plane dark oval/squashed shape | World-projected position anchors shadow even when sprite jumps |
| Selection | Blue/white **four-corner square footprint** projected onto diamond tile | Selection overlay independent of sprite |
| Dimensions | Collision capsule/body in actual 3D coordinate space | Godot authority, same body in FPS/Overlord |
| Offset | Boots touch pivot, backpack/tool may extend frame region | One foot anchor all directions; expand overlay canvas rather than cropping |
| View dirs | N, NE, E, SE, S, SW, W, NW | N/S are world-space angles; screen angle changes by camera azimuth |
| Production phase | 4 authored cardinal dirs in early engine spike, eight for full visual standard | Must avoid promising 8x all animations before MVP works |

### 2:1 world projection and feet anchoring
For a flat world plane, conceptual projection of grid coordinates (x,z) in units of cells:
- screen_x = 16*(x-z) + origin_x
- screen_y = 8*(x+z) + origin_y - projected_height
This is a **diagram of tile artwork**, not a formula to replace Godot Camera3D or physics. Camera 45°/30° approximately yields the 2:1 dimetric diamond convention. Depth and elevation must come from 3D world geometry. A torso sprite can be 32 pixels tall while the feet occupy only 1 tile; a large helmet drawing does not imply a collision radius larger than its walking footprint.

A real Godot Sprite3D/AnimatedSprite3D can be rotated to camera or switch view-specific frames. Do **not** use arbitrary flat billboards for FPS close-up; use a separate low-poly/voxel proxy or FPS-specific nearby visual tied to the SAME authoritative ActorState.

## Physical anatomy within a 24x32 tile (working pixel budget)
Coordinates are relative to transparent frame, not hard clipping boxes:
- **Helmet:** about **10x9px** around x=7..17, y=2..11; one rounded white outer contour and a 6x5px blue visor whose highlight is 1–2 px, no tiny painted eyes.
- **Neck/gasket:** 1–2px dark ring at y=11–13.
- **Torso:** approximately **10x10px** around x=7..17, y=12..21. Squared utility chest with **2–3px identification panel**; detailed MAN letters/logo belong in UI and high-LOD only.
- **Arms:** x=3..8 and x=16..21 at y=12..23; emphasize small articulated elbow/wrist braces; one arm can carry a distinct tool.
- **Backpack:** 5–8px width along back/side, y=10..21, square casing with one orange port; less dominant on front, visible on rear and diagonals.
- **Legs:** x=6..11 and x=13..18, y=21..29; short feet/boots with dark outsole at y=28..30. Orange ankle/forearm brackets express the light exo. Avoid superwide robot knees.
- **Antenna:** optional detached gear overlay; ideally compact and telescoping so it does not eat 20% of unit height or clip other sprites.
- **Carried cargo:** overlay or separately instantiated world packet; packet must be accounted in actual inventory, not duplicated in sprite frames.

### Readability hierarchy at 320x240
1. Identify a MAN worker from **outline and white helmet**, not from text.
2. Read **tool versus scanner versus carried crate** from shape in 1 second.
3. Observe animation status **walking / drilling / welding / scanning / carrying** from poses, sparks and cargo rather than tiny glowing pixels.
4. Recognize team and selection with a border/selection layer without obscuring the body.
5. The smallest ambient detail may vanish: no tiny UI glyph is allowed to carry essential gameplay information.

## Palette and material rendering (provisional artist palette)
| Material | Dominant colors / value intent | Pixel-art treatment |
|---|---|---|
| Ink silhouette | #0C1626 / #223148 | 1px strong outline on lit side, thicker only at shadowed gaps |
| Pressure suit shadow/mid/light | #8295AF / #CED5DD / #FFF3E4 | Three readable ramps; light from screen top-left |
| Visor deep/mid/highlight | #0B3159 / #1567AF / #58C8FC | Big uninterrupted dark-blue visor patch; 1–2 specular highlights |
| MAN machinery/enamel | #174D88 / #268BDE | Blue rectangular panels and faction-recognition strips |
| Utility orange | #AF571C / #F49A2B / #FFD081 | Hinges, warning bumpers, active tool, tiny bright hotspot |
| Joints/outsole | #26374A / #52637C | Distinguish movement from inflated fabric |

These hex values are a **candidate shared palette**, not brand-locked colors. An asset can exceed 16 total shades where necessary, but artist should justify each extra ramp by silhouette readability. Avoid glossy gradients, blurry glow and pixel scatter as substitutes for clear geometry. Visor may be curved; backpack should be square.

## One base body with four gear modules (do not create four new races/classes)
| Loadout / concept name | Character-visible delta | Common base preserved | Action signature |
|---|---|---|---|
| **Field Engineer** (recommended baseline MIN) | Small drill/constructor tool on wrist, orange utility pouch | Full core astronaut body | Short drilling/welding action, kneel/lean |
| **Repair Technician** | Compact articulated repair arm on backpack, welding nozzle | Same suit and most locomotion frames | Tool arm extends, contact sparks (separate FX) |
| **Prospector Scout** | Thin sensor mast, palm scanner, sample case; less bulky pack | Same core shape | Hold scanner out, sweep cone (gameplay-validated overlay) |
| **Logistics Crewman** | Cargo harness/quick-release pack and visible crate | Same boots/helmet | Pick up, carry, put down with correct packet counts |

**Design trap:** engineer and repair technician are currently too similar to be separate gameplay roles. For the initial playable proof use one **MAN MIN Worker** with interchangeable tools/visual attachments. Defer multiple production templates unless their abilities/costs counter each other.

A player's **Engineer / Commander / Specialist Hero kit** changes equipment/ability icons and potentially overlay visuals but never camera eligibility; the same underlying suit remains an existing actor with one persistent identity.

## Eight-direction sprites and asymmetric equipment
A production-complete moving actor has **N / NE / E / SE / S / SW / W / NW** facing views. Use actor yaw relative to the fixed Overlord camera to select image (not arbitrary screen-space 2D velocity when unit stands and aims elsewhere). Card board with FRONT/SIDE/BACK is not sufficient for final 8-direction movement.

- Front-facing: oversized visor, tool held outward, shoulders separated.
- Front diagonals: show one side of visor + attached backpack silhouette; primary readability test.
- Side: nose-of-helmet, front tool and back pack clearly separated.
- Rear diagonals: backpack becomes central; shoulders at different distances.
- Back: emphasize MAN rectangular maintenance pack and braces; still readable without the visor.

Because a torch or sensor mast may be on the **character's right arm**, naive horizontal mirroring swaps side and alters what hand is holding the tool. For finished asymmetric loadouts, paint independent E/W and NE/NW views or mirror ONLY if design establishes symmetrical gear and the action still has correct handedness. Pivot coordinates and ground footprint remain identical in all eight directions.

### Proposed atlas budget (core LOD)
**Phase A / first runnable spike:**
- 4 authored cardinal facings × [idle=2, walk=4, work=4, carry=2] = **48 total frames**.
- Frame 24×32px, atlas organized **12 columns × 4 rows = 288×128px**.
- Change accessory as a separate overlay if possible; use a generic initial work animation for dig/build/repair in the very first test. This is a development compromise, **not** a claim that 4 views satisfy final 8-direction visual quality.

**Phase B / full eight-direction base:**
- 8 facings × the same 12-frame menu = **96 frames**.
- Core atlas **12 columns × 8 rows = 288×256px** at 24×32.
- A distinct hero/detail atlas at 32×48px becomes **384×384px** for 96 frames if actually authored at that detail level.
- Full future actions (harvest, build, repair, scan, hurt, death, FPS weapon variant) extend or split atlases. Do not use one endlessly wide source sheet for every item; export per-action if the art team prefers and ensure manifest ordering is stable.

A physically separate backpack/tool/cargo layer can lower redraw count but requires exact pivots and **per-direction occlusion** (backpack in front/behind the torso depending on facing). Prototype this rather than assuming overlays are free.

## Animation and timing guidance
| Action | Initial frames/dir | Suggested playback | Key legibility cue |
|---|---:|---:|---|
| Idle | 2 | 2–4 fps | Subtle suit breathing or antenna blink |
| Walk | 4 | 6–8 fps | Alternating boots + tiny pack motion, NOT slipping |
| Work (generic initial) | 4 | 6–8 fps | Arms operate the correct tool, contact flash after wind-up |
| Carry / unload | 2 | 3–5 fps | Physical crate becomes attached/detached at exact ledger event |

Later add 4–6 authored frames for repair/scanning/mining and 2–4 for damage/death where budget allows. At 320x240, gameplay communicates through **strong 2–4 px pose changes**, not single subpixel shimmer. Sparks, drill dust and sensor arcs live on separate VFX layer, tied to legal game action events.

## Atlas naming, metadata, integration
Asset ID: \`man.worker.min.walk.ne\` or \`man.worker.min.work.sw\` (stable agreed base ordering \`<faction>.<role>.<scale>.<action>.<facing>\`).
Filenames:
- \`man_worker_min_base_24x32_8dir.png\`
- \`man_worker_min_hero_32x48_8dir.png\` (post-MVP)
- \`man_worker_min_gear_repair_arm_24x32.png\`
- \`man_worker_min_gear_scanner_24x32.png\`
- \`man_worker_min_gear_cargo_24x32.png\`
- \`man_worker_min_shadow.png\`
- \`man_worker_min_atlas.json\` / manifest YAML source.

Authoring format can be Aseprite (\`.aseprite\`) or a lossless layered alternative; export to transparent PNG and stable metadata with frame index, direction, action, fps, pivot, collision proxy ID and license/source. Validate the PNG dimensions and alpha edges automatically in a future TypeScript asset checker. Avoid using a large generated concept poster as a runtime sprite sheet.

In Godot, actor instance retains WorldPose / HeroData / Inventory / CommandState regardless of camera. Overlord and Direct use directional 3D sprite rig or low-poly proxy; FPS uses close-up authored geometry/asset, **not an infinitely scaled 24x32 sprite**. Foot/selection shadow drawn against the same 3D terrain cell; depth comes from 3D world, not independently guessed hand-placed screen-space Z ordering. All resource transfers happen via authoritative inventory and gameplay rules, not visual keyframes alone.

## Scaling / screen profiles and UI
- **320x240, 4:3:** real minimum display target; fit a compact HUD with only name, HP, action and 3 resources; key sprites remain readable. Do not shrink game world into a 100px-tall viewport to show an expensive MMO skill panel.
- **640x320, 2:1:** widescreen alternate; adaptive view area and UI. **Do not stretch 4:3 world art**.
- **640x360, 16:9:** a practical retro logical render size; **integer ×6** produces 3840x2160 UHD exactly.
- **3840x2160, 16:9:** render as 640x360 nearest-neighbor integer ×6 for consistent chunky-pixel mode, OR use high-resolution world render with nearest-filter sprites and appropriately scaled UI for hybrid mode; compare visually.
- Physical zoom and logical output resolution are different dimensions: snap exact pixel zoom to tested discrete steps; optional smooth fractional camera zoom may shimmer with nearest-neighbor sprites and must be tested.
- Never upscale 320x240 to 4K with unequal x/y factors (3840/320=12; 2160/240=9).

## Tests before approving the sprite
1. In grayscale at true 320x240, a novice distinguishes the MAN worker from ORG MIN / ETH MIN without reading faction labels.
2. Core worker fits within 24x32 sprite with feet at consistent pivot (12,30), not clipping antenna/tool; use overlay canvas or reduce gear scale to fit.
3. No frame jumps laterally/up vertically when changing N/NE/E/SE/S/SW/W/NW (pivot remains fixed).
4. All facings visibly share the same suit and attachment placement (no accidentally mirrored scanner or drill).
5. At 320x240, player identifies mining/building/repairing/carrying by action silhouette and VFX, not tiny letters.
6. Correct MAN four-corner square selection projection onto 2:1 ground diamond; unit click/hover geometry comes from true world space, not opaque PNG rectangle.
7. Overlord and Direct cameras select same actor with exact position/HP; FPS close-up shares collision and inventory.
8. Original independent art avoids direct copyrighted characters, game assets, franchise-specific helmets and insignia.
9. PNG transparent RGBA, alpha=0 outside silhouette, no black rectangular background, no antialias blur or off-grid fractional resampling in pixel-perfect mode.
10. Source editable asset, export manifest, license/provenance, palette and pivot are committed in a future **art implementation** PR, not assumed delivered by this document.

## Art implementation sequencing
A0. Pick one silhouette among existing Field Engineer/Repair/Prospector/Logistics sketches; recommended Field Engineer as standard Worker. Create grayscale 24x32 *front and 3/4 ISO front* silhouettes.
A1. Paint 4 cardinal idle/walk/work/carry directions to 288x128 atlas; compare 320x240 screenshot with unselected worker and selected worker on real Godot 2:1 floor.
A2. Extend to 8 facings, measure edit burden and compare with early camera spike; correct handedness and alignment.
A3. Add scanner, cargo harness and repair-arm overlay rigs. Make one 3-step physical resource pickup and real move/unload animation.
A4. Author 32x48 hero LOD and small 3D/FPS body proxy; confirm actor continuity across 3 modes.
A5. Only after real player test, proliferate into distinct MAN human combat units, bots, mechs, tracked belts, vehicles; do not let all MAN units look like astronauts.

**Art acceptance is pending**: the chosen tile/frame specs are consistent with current repo's *proposed graphic requirements*, not yet tested as satisfying every final UI/animation requirement.
