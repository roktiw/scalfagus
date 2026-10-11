# Scalfagus — Three Pillars, One World: Sim / Commander / Avatar

> **DEC-033 scope note (2026-10-11):** This file describes historical full-game Hero/three-camera concepts, NOT current first-playable deliverables. MVP 0.1 ships **one faction MAN vs MAN**, classic **Overlord RTS only**, H-H (LAN/loopback), H-C and C-C, four core MAN templates. FPP possession is a **later** approved direction under DEC-031; TPP/Direct is not a target shipped mode. See [current first-release spec](../design/mvp0-man-mirror-rts-2026-10-11.md) and [current backlog](../design/mvp0-man-mirror-backlog.yaml). Existing 3-camera technical spike is preserved as regression baseline; no code migration is implied.


Date: 2026-10-11
Status: owner direction plus concrete engineering proposal.
Core principle: **Three ways to play the same RTS, not three disconnected modes.**

## 1. Architect — SIM / construction / logistics / tower defense
**Player fantasy:** make a functioning settlement and see the things it makes actually travel, fight and matter.
Inspirations: Transport Tycoon Deluxe (physical throughput), SimCity (zoning/placement), Factorio (automation), Settlers II (autonomous carriers), Dungeon Keeper I (imps, traps, rooms), tower defense (spatial defense).

**First implementation:** HQ, storage/depot, simple extraction or harvesting site, barracks/workshop, turret and exactly one trap or chokepoint hazard. Select deposit -> assign workers; workers loop harvest/carry/unload; visible moving cargo and finite storage; simple policy button e.g. Defend / Expand / Balanced with transparent AI status. A player may manually place structures; AI placement is bounded by map validity/resources, not omniscience.

**User actions:** select build/route, place, assign, inspect, change policy, set rally points, repair and defend. No mandatory per-carrier micromanagement.

**MVP success:** a newcomer can establish a defensible production loop and repel an attack largely through placement/automation, without directly aiming.

**Deferred:** SimCity-grade citizens/zoning/population satisfaction, full Factorio belts, signaling rail networks, transportation fleets, procedural terrain surgery, trap factories and economic hundreds of recipes.

## 2. Commander — traditional RTS + direct single-unit action RPG
**Player fantasy:** direct squads and tactics, issue strategic production orders, and optionally control one soldier/creature from above.
Inspirations: Warcraft II / StarCraft I / Z for commands and clarity; Realm of the Mad God and simple action RPG for direct overhead twin-stick-like movement/aim.

**First implementation:** single/box selection, click-to-move, click-to-attack, limited grouping, train/produce, guard/defend, health and target-state HUD, minimap if affordable. Toggle Direct Unit: WASD motion, mouse aim and one attack from a near-isometric/top-down camera. This is the same entity and weapon system as RTS targeting, not a separate ARPG character.

**Strategic mechanics:** scouting and fog-of-war, legal targeting LAND/AIR where supported, defend one chokepoint, prioritize economic/war resources, queue a few units, counter an enemy squad.

**MVP success:** player can win entirely via classic RTS orders, and Direct Unit control allows local tactics without giving unfair combat stats.

**Deferred:** nuanced unit experience/training, complicated formations, massive army pathing, specialized 7x3x4 rosters, RTS multiplayer and macro balance.

## 3. Avatar — direct first-person possession, optional future third-person
**Player fantasy:** jump into the battle using the body of a *real existing RTS unit*, without exiting the match.
Inspirations: Dungeon Keeper I possession, Machines/Battlezone, later Quake, Counter-Strike, Return to Castle Wolfenstein/Enemy Territory. The owner's last phrase 'or a driving style from ...' was unfinished; exact further reference remains open.

**Required minimum:** select eligible ranged soldier -> Possess -> FPS perspective from the unit's body -> WASD + mouse look + primary fire -> enemy takes ordinary RTS hit/armor damage -> exit possession -> RTS camera shows the SAME unit at its new position, with changed HP/ammo/target state. No special FPS damage scaling.

**Camera modes:** `rts_ortho`, `unit_direct_iso`, `unit_fps`; `unit_tpp` is optional if almost free and can be switched with a camera, otherwise postpone. A camera switch never creates another simulation entity.

**Control authority proposal:** possession > protected explicit human command > strategic/operational AI > unit doctrine > idle. On possession enter: verify unit is eligible, alive, owned, in valid state; cache previous job/order; establish exclusive controller lease; follow authoritative pose. Exit/death: release lease, restore/replace prior order according to clear rule; validate no duplicate commands.

**MVP success:** continuous combat while switching camera twice, with preserved projectile/hit history and movement, and without cross-view teleportation or second physics body.

**Deferred:** Quake-style air strafing / bunnyhop/rocket-jumps, highly tactical CS weapon arsenals, cover-peeking simulation, multiplayer FPS responsiveness, per-species FPS locomotion, complete TPP animations, climbing/flying/underwater avatar forms.

## 4. Actor and command contract
Each owned actor has stable `entity_id`, `faction_id`, `world_pose`, `health`, `inventory`, `movement_domains`, `weapons`, `orders`, `doctrine`, `controller_lease`, `visibility_state` and `status_effects`; individual features can be absent when inapplicable. Authoritative state lives outside presentation nodes.

Commands have actor, issuer/authority, simulation tick, input parameters and expected validation:
- `MoveTo(unit_id, world_position)` from RTS; `DirectMove(unit_id, vector)` from action-RPG/FPS -> ONE movement/collision rule.
- `AttackTarget(unit_id, target_id)` from RTS; `DirectFire(unit_id, aim_direction)` from FPS -> ONE weapon/cooldown/targeting/LOS rule.
- `AssignJob(worker_id, deposit_id, depot_id)`; `Build(blueprint, location)`; `PlaceDefense(...)`; `Repair(...)` -> ONE resource and placement system.
- `Possess(unit_id)` and `Release(unit_id)` create/release controller lease, do not create/destroy the actor.
- `SetDoctrine(scope, policy)`, `SelectSquad(ids)`, `Pause` (mode restricted), `CameraChange` (pure view change).

Input mapping can have client-frequency motion and aim, but commit validated combat/movement effects at an authoritative fixed tick. Do not promise deterministic cross-platform floating-point physics unless tested. Use stable seed, stable entity order, state hashes and accepted-command logs for initial replay debugging.

### Single-world rule
Map owns a cell/elevation/obstacle/material description and *3D collision geometry*. RTS uses orthographic/dimetric view; FPS uses perspective from the same geometry. Buildings block sightlines and physical movement consistently. Fog-of-war/visibility and hit legality are still enforced through the common simulation. A direct FPS view may show its own camera perspective but **not** hidden enemy coordinates or remote map-wide omniscience.

### Suggested Godot implementation
One 3D WorldRoot; tile-based terrain visualized with low-poly/texture-mapped meshes; camera RTS = orthographic tilted ~30–45° to tune pixel-art 2:1 projection; sprite billboards / AnimatedSprite3D for entities with 4–8 directions where necessary; camera Avatar = perspective and short distance; UI layer = Control/CanvasLayer; unit_direct_iso = closer orthographic camera following selected unit; use camera-specific visual layers only if needed. Use a low-resolution render target/nearest filtering where tested for pixel stability, but verify shimmer, overlaps, sorting and occlusion, 8-direction art consistency and FPS sprite-scale issues. Keep physics collision geometry real, not faked by images.

### Suggested Recoil implementation
Use existing game/units/commands/terrain/RTS camera plus FPS direct control: Recoil documents `ControlUnit` as an unsynced command to start first-person control **without enabling cheats**, and Lua API `Spring.GetPlayerControlledUnit(playerID)`. **Actual input semantics, synchronization, weapons, compatibility with isometric pixel-art sprites, UI and modding limits must be validated in an executable spike.** Its RTS maturity makes it a serious alternative, not a guarantee of fully functional game-specific possession.

## 5. Mode contract / common scenario
Scenario 'Relay Frontier' (working title): one small authored map with a chokepoint, ore depot, HQ, enemy outpost, defense build spot and scripted raid. In all modes:
- Sim player allocates workers, expands defenses and sends AI task priorities.
- Commander moves a small army and uses direct overhead control for one soldier.
- Avatar occupies a ranged soldier to hit a target while ongoing harvest and squad AI continue.
- Win condition can be defeat enemy HQ; defensive holdout mode is future scenario variant.
- Switch freely, with world health/resources/positions always matching.

## 6. Key unresolved questions
1. Is unit_direct_iso an independently exposed advertised mode at MVP or simply a small optional alternative to clicking in RTS?
2. Must FPS be literal first-person or is third-person acceptable for initial technical slice? Current direction: **literal FPS**.
3. Is default Architect autonomous enough to win without manually ordering attacks, or merely defend? Set precise MVP acceptance.
4. Which target PC/platform and pixel scale anchor? Need target resolution and scaling tests, not fixed lore numbers.
5. Is the map world truly 3D with sprite billboards, or 2D RTS with generated FPS collision twin? Compare via spike; recommendation first.
6. Do manual possession aim and RTS aiming share line-of-sight exactly, and how to avoid aim advantage becoming mandatory for ranked play?
7. What remains of a unit's prior command after release, and after death?
8. How many simultaneously independent units remain performant: 20/50/100 on representative hardware?
9. Networked FPS and simultaneous human/AI ownership are later work.
10. User's unfinished 'driving style from ...' game reference needs exact identification before adding controls.

## 7. Acceptance tests
A. Put actor at (10,0,6) in RTS; possess; walk and fire; release; observe new actor pose and damage in RTS, not second actor.
B. While possessed, AI harvest/delivery continues. Player's actor is not immediately re-tasked by base AI.
C. A wall blocks movement and shots from both camera modes. No through-wall FPS shots.
D. Scarce supply still blocks production and repair; no source of free Matter/Volatiles/Energy through FPS.
E. AI and human obey same target permissions; flying units need explicit anti-air weapons.
F. RTS-only player can beat same enemy without ever possessing; Architect-only player can defeat a defensive scenario if planner policies configured.
G. Unit death exits possession; no orphan camera, old input capture or stuck control lease.

Related: [Product Principles](product-principles.md), [MVP](mvp-iso-pixel-rts.md), [Engine Selection](../research/engine-selection-rts-possession-2026-10-11.md).


## 8. Hero ownership and three-view amendment (2026-10-11)
The owner now requires **one Hero per human player from match start**, with initial Engineer, Commander or Specialist *kit* and one shared open talent graph. Skills can cross branches, while selected mutually-exclusive upgrades block incompatible **future** skills unless a later explicit respec system is approved. This creates NO hero-specific camera or exclusive gameplay mode.

The three user-facing *observation/control* perspectives are:
- **Overlord**: base / transport / RTS / army overview.
- **Direct Unit**: top-down near-isometric `Realm of the Mad God`-like movement, aim and attack with one owned Hero; following TPP camera is optional, not a separate game system.
- **Full FPS**: direct first-person control of that SAME Hero actor, with the same movement, weapon, collision, health, inventory and ability cooldowns.

Architect / Commander / Avatar describe player *interests and control disciplines*, **not locked selectable classes**. A Specialist can enter Overlord to place buildings, an Engineer can use FPS, a Commander can control a unit directly. Full manual RTS remains playable without using direct control at all. One authoritative hero entity receives different input adapters. The progression graph and ability resolver are not duplicated per camera. All camera views must respond to hero death and controller release coherently.

**Internal MVP delta:** a single unit hero with the three starting kits/presets as small modifiers or starter abilities, a tiny common graph (6–9 proposals), two demonstrated pivots, three working cameras (Overlord/Direct/FPS), no deep RPG class engine, no full TPP, no Quake movement mechanics. See [Hero and Cameras](hero-progressions-and-three-cameras-2026-10-11.md), [MVP Scope](mvp-iso-pixel-rts.md).
