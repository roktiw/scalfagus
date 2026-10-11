# Scalfagus — Engine / Library Selection for Three-Pillar RTS + FPS Possession
Research date: 2026-10-11
Status: evidence-supported recommendation; **no engine chosen and no executable benchmarking performed yet**.
Supersedes the **FPS is post-MVP** assumption in [engine-selection-357.md](engine-selection-357.md). New project requirement: *minimal real Dungeon Keeper-like FPS possession is mandatory within the internal playable MVP*, while advanced Quake/Counter-Strike FPS is deferred.

## 1. Target product and hard gates
One local, offline, **1990s Warcraft II / Dungeon Keeper / Z style pixel-art isometric RTS** with three equally legitimate control fantasies on a **single authoritative simulation world**:
- Architect / SIM: transport, buildings, production, automated workers, traps, tower defense (inspired by TTD, SimCity, Factorio, DK).
- Commander / RTS: production, army control, scouting, tactical orders + a very simple isometric/top-down single-unit action-RPG control (Realm of the Mad God direction).
- Avatar / FPS: possess one eligible actor, WASD, mouse look/aim/fire, optionally add a third-person camera. Full Quake/Counter-Strike/Enemy Territory depth is future.
All three operate on one map with consistent collision, visibility, resources and health.

**Fatal engine-gates:**
G1. RTS ortho/isometric visual quality sufficient for pixel art, selection rectangle, minimap and HUD without fake-world limitations.
G2. Possessed unit can move/fire in first person and return to RTS with exact same actor, target, health, inventory and map state.
G3. Movement, targeting and structures use the SAME 3D geometry/rules in RTS and FPS.
G4. Offline local build for targeted desktop, command-line test and headless acceptance scenario.
G5. License permits intended distribution with acceptable obligations, and art is original or licensed.
G6. Agent/AI workflow supports small reviewable changes, clear debugging and tests.
G7. Performance benchmark, not assumptions, on the actual target laptop(s).

## 2. Technical option A — GODOT 4 (recommended initial prototype)
**Approach:** Create a *real 3D world*, primarily seen by an **orthographic tilted camera** for isometric gameplay; use low-poly tiled geometry, hand-painted/pixel textures, Sprite3D/AnimatedSprite3D billboards with directional animations where needed, a retro low-resolution viewport and simple flat-shaded structures. Possession switches **camera + input authority**, NOT scene/level or simulation model. Unit-direct action RPG uses a closer overhead orthographic camera attached to actor.

Documented features:
- `Camera3D` supports perspective and orthogonal projection, position projection and selection rays: https://docs.godotengine.org/en/stable/classes/class_camera3d.html
- 2D sprites in 3D via Sprite3D/AnimatedSprite3D: https://docs.godotengine.org/en/4.4/tutorials/3d/introduction_to_3d.html
- Ray casting from either orthographic or perspective camera: https://docs.godotengine.org/en/4.4/tutorials/physics/ray-casting.html
- AStar3D for cell graphs, NavigationServer3D for navmesh: https://docs.godotengine.org/en/4.5/tutorials/navigation/navigation_introduction_3d.html
- Headless execution/dedicated server options: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html
- MIT: https://godotengine.org/license/

**Important:** Godot is not a ready-made RTS game. Need select/box select, minmap, build placement, economy, army commands, combat, task AI and balance. 3D with pixel-art RTS view has *specific art risks*: 2:1 tile consistency, transparency/sorting, sprite billboarding close to FPS camera, occlusion, 4/8 facing direction, sloped terrain and shimmering at fractional pixel zoom. Build a dedicated art/geometry spike before engine commitment.

**Suggested implementation primitives:**
- `Node3D` world root; simple sector/tile 3D mesh/colliders; authoritative fixed simulation tick (proposal ~30 Hz); render sampling/interpolation separate.
- For 48x48/64x64 proof map: grid A* movement on 2D footprint + cell height for passability, ramps and LOS; no dynamic navmesh rebuild required for first demo. Move actor positions in shared 3D coordinates.
- `Camera3D` RTS orthographic, camera Avatar perspective; unit-direct = RTS camera following the controlled unit; camera switching is inexpensive.
- Per-unit state plain data/Resources; GDScript first, optional C# or C++ GDExtension *after* profiling. GDExtension compatibility/versioning is extra dependency and not a first-step requirement.
- HUD with standard Godot controls; sprites near camera may need 8-way texture swaps, lowpoly LOD or a simple unique FPS hands/weapon mesh while distant third-person units remain billboards.
- Pin one stable 4.x version once tested; reproduce imports; version all custom assets and manifests.

**Why strong:** best single tool for simultaneously inventing pixel-style visuals, lightweight standalone FPS, rich user interfaces and headless test scene, all in one codebase.
**Risk:** custom RTS stack effort; avoid assuming built-in 3D navmesh automatically delivers stable high-unit-count RTS collision or cross-platform deterministic lockstep.

## 3. Technical option B — RECOIL RTS Engine (serious benchmark challenger)
Official: https://recoilengine.org/ and https://github.com/beyond-all-reason/RecoilEngine
Open-source RTS engine powering Beyond All Reason; Lua gameplay/UI scripting atop C++ native RTS mechanics.
- Existing RTS simulation, unit orchestration, terrain, economy and broad army-scale engineering are compelling.
- Critically, Recoil docs list **unsynced `ControlUnit`: 'Start to first-person-control a unit', no cheats needed**:
  https://recoilengine.org/docs/unsynced-commands/
- The Lua API includes `Spring.GetPlayerControlledUnit(playerID)`: returns currently controlled FPS unit:
  https://recoilengine.org/docs/lua-api/
- Native RTS and camera modes documented; this makes genuine unit control **much more plausible than we assumed earlier**, though **not proof** of fully suitable first-person weapon/physics/input behavior for our project.
- Engine license references GNU GPL v2 or later and third-party notices; distribution/game-content integration requires legal review:
  https://github.com/beyond-all-reason/RecoilEngine/blob/master/LICENSE

**What needs proof:** can ControlUnit be used as a regular gameplay toggle with correct single-player state/AI suppression? Does its aiming/weapon/LOS match desired Quake-ish action feel? Can isometric-like view be locked with original sprite-like/pixelated artwork and still show FPS world faithfully? Can data-driven game rules and assets be authored without inheriting BAR-specific copyrighted content? Is macOS (Apple Silicon) pipeline practical? Can 3D unit targeting and 2D isometric art coexist with native render pipelines? Does license fit business/release plans? These are **open questions**.

**Risks:** C++/Lua development surface, more complex art customization, version/packaging/toolchain friction, real-time action feel originally subordinated to RTS control, GPL compliance. No proven friction numbers yet.

## 4. Technical option C — OpenRA (great RTS, poor single-engine fit for genuine FPS)
Official: https://www.openra.net/ ; source https://github.com/OpenRA/OpenRA
Mature 2D/2.5D C#/MiniYaml mod-capable RTS foundation with UI, orders, fog, replays and multiplayer.
License engine GPLv3: https://www.openra.net/legal/
**Strength:** quickly make playable C&C/Warcraft-ish 2D RTS with data and behavior traits.
**Weakness:** lacks an equivalent integrated first-person 3D presentation/world; building or bridging a second 3D FPS renderer and collision model would defeat our 'one world, two cameras' simplicity. Keep as control/UX reference only unless possession requirement changes.

## 5. Technical option D — Babylon.js + TypeScript
Official source https://github.com/BabylonJS/Babylon.js ; physics design docs:
https://github.com/BabylonJS/Documentation/blob/master/content/features/featuresDeepDive/physics/v2/usingPhysicsEngine.md
**Strength:** TypeScript modularity, browser/test/debug workflows, first-person 3D and camera freedom, easy custom simulation API.
**Weakness:** browser graphics-first rather than RTS battery included; would build selection, armies, nav, economy, fog, simulation, UI and packaging mostly from scratch. More engineering surface for first playable than Godot unless browser delivery and TypeScript are nonnegotiable.
- Havok Physics WASM available with Babylon via MIT package per published docs, but physics engine does not replace RTS rules or consistent fixed simulation.
- Can use a single 3D world with ortho RTS and FPS cameras, just like Godot; no immediate Phaser layering required.

## 6. Technical option E — Phaser + Three.js/Babylon (not recommended for MVP)
Phaser is strong MIT browser 2D but explicitly **does not provide built-in 3D rendering/physics**: https://docs.phaser.io/
Bridging a 2D isometric map to a 3D first-person engine requires extra mapping/rendering/occlusion/collision consistency work. Prefer Godot 3D-first or Babylon 3D-first for genuine single-world FPS.

## 7. Comparative qualitative matrix (hypotheses only, NOT benchmark scores)
| Criterion | Godot 4 | Recoil | Babylon.js | OpenRA | Phaser + 3D |
|---|---|---|---|---|---|
| Ready-made RTS armies, queues and orders | Custom | **Strong** | Custom | **Strong** | Custom |
| Built-in/direct documented FPS unit-control path | **3D camera & inputs; custom** | **ControlUnit documented; test behavior** | **Custom** | Big engine work | 2-engine bridge |
| Isometric original pixel-art direction | Strong with art spike | Possible; uncertain sprite workflow | Custom shaders/pixel art | Strong native 2D | Strong for 2D |
| One actual world for RTS + FPS | **Yes** | **Potentially yes** | **Yes** | Hard | Hard |
| Local headless scenario tests | Yes | Possible, investigate builds | JS no-render/test possible | RTS infra | Custom |
| Team skill / simple agent PR | GDScript or C# | Lua + engine C++ | TypeScript | C# traits | TS + rendering bridge |
| Licensing | MIT | GPLv2+ / notices | See upstream dependencies | GPLv3 | Phaser MIT + 3D licenses |
| Chief risk | Building RTS | 3-mode UX/retro art/toolchain | Building full RTS | First-person 3D | World consistency |
| Working ranking | **Prototype first** | **Mandatory challenger** | Fallback | Reference | Reject first MVP |

**Do not assign numeric 4.5/5 or decimals until tasks are actually run.**

## 8. Same-spike benchmark: Godot vs Recoil, optional Babylon
Each engine must implement the SAME 5-minute test scenario with colored placeholders, no purchased/unlicensed art:
1. One 3D ground grid 32x32, one wall, one elevation difference/step or ramp, one small structure; show isometric ortho RTS scene.
2. Select two friendly units, order move/attack; same 3D collision/LOS rule determines positions and damage.
3. Possess **one ranged soldier**; player walks with WASD, aims mouse and fires at enemy; release returns to RTS with exact new actor position/health/target.
4. Direct unit overhead/isometric action-RPG view follows same actor with no separate entity.
5. While possessing, scripted worker collects Matter and delivers to depot; resource tally changes visibly.
6. Repeat fixed seed/accepted commands and compare event log/state hashes; ensure no free spawns or visibility cheats.
7. Build/package for macOS and one additional desktop OS if targeted; run CLI/headless smoke test.
8. Measure functional work, wall-clock implementation time, iteration count, AI input/output tokens, edit surface, crash count, asset adaptation, screenshots, frame time and license/packaging risk.

**Kill tests:**
- Any implementation needs a duplicate separately mutable world to support RTS+FPS.
- Possession cannot share the authoritative actor movement/hit/damage states.
- Pixel iso view fails aesthetic benchmark under feasible asset workflow.
- License obligations conflict with intended distribution.
- Essential pathing/selection/FPS action UX is prohibitively complex in a measured spike.

**Chosen only after comparative demo**. Provisional preference **Godot 4**, Recoil close second if ControlUnit and sprite/pixel style work convincingly. Reevaluate ranking if performance, licensing or developer ergonomics fail tests.

## 9. External package policy (start light)
- Godot native physics/collision, Camera3D, Sprite3D, AStar3D/NavigationServer3D, Control UI and headless are enough for first spike; no default third-party mega-RTS plugin.
- Game schemas: retain canonical YAML authoring, validate schema/cross-file refs at **build-time** and generate loaded data; no runtime YAML parser dependency required. Legacy Crystals/Gas/Resin values must migrate separately to Matter/Volatiles/Energy before gameplay.
- Test framework: simple headless scenario scripts and deterministic scenario fixtures first; adopt a well-maintained Godot unit-test add-on only once project version/license verified.
- Pixel art tools and original assets may be external but must have explicit attribution/licenses. Do not redistribute Blizzard, Bitmap Brothers or Dungeon Keeper original sprites.
- Physics: use simple grid/capsule collision and ray checks for first-person proof; heavy simulation and destructible dynamic terrain are later.
- Security/provenance: pin releases, record dependency licenses and source commits; do not silently integrate arbitrary third-party add-ons or cloud keys.

## 10. Delivery recommendation
**S0** lock player scenario and input/command contract before final engine.
**S1** Godot 4 spike; in parallel separate Recoil spike with ControlUnit and custom RTS camera.
**S2** choose engine on measured evidence and minimal engine-specific integration branch.
**S3** implement common authoritative simulation and 3 camera/control adapters, simple AI economy/combat.
**S4** visual/pixel polish, economy, basic defense and production, playtest all 3 entry routes.
**S5** three-faction MIN, then complex Sim MID/MAX, full FPS/TPP, LLM lab and multiplayer.

This file does not imply that the project already has a running engine, benchmark results or validated numeric balance.
