# ADR-0001 — One Authoritative World, Three Perspective Adapters

> **DEC-033 scope note (2026-10-11):** This file describes historical full-game Hero/three-camera concepts, NOT current first-playable deliverables. MVP 0.1 ships **one faction MAN vs MAN**, classic **Overlord RTS only**, H-H (LAN/loopback), H-C and C-C, four core MAN templates. FPP possession is a **later** approved direction under DEC-031; TPP/Direct is not a target shipped mode. See [current first-release spec](../design/mvp0-man-mirror-rts-2026-10-11.md) and [current backlog](../design/mvp0-man-mirror-backlog.yaml). Existing 3-camera technical spike is preserved as regression baseline; no code migration is implied.\n\nDate: 2026-10-11
Status: **PROPOSED / engine conditional**, not an implemented engine choice.

## Context
Scalfagus combines Architect/Sim, Commander/RTS+simple overhead action RPG, and Avatar/Dungeon Keeper-like FPS. Every participant starts with one evolving Hero, choosing Engineer/Commander/Specialist starter preset. Three camera modes are Overlord, Direct Unit, FPS. The same actor moves, fights, consumes resource, learns abilities and dies in one shared world. The owner favors Mono-Blue TS tooling, but wants actual 1990s pixel-art RTS and real FPS control.

## Decision proposed
- Keep ONE in-process authoritative game simulation runtime in native engine.
- Candidate first proof: Godot 4.7.2 Standard + GDScript. Alternative challenger: Recoil RTS engine (C++/Lua), tested on identical camera/unit/LOS/economy scenario.
- Godot's 3D world stores collisions/terrain; 3 Camera3D projections and controller adaptors read/write through shared legal command API.
- Fixed sim tick, actor stable IDs, economy cost ledger, unit AI and combat belong to native runtime. Render/UI can interpolate; input cameras cannot mint resources or bypass fog.
- TypeScript CLI owns validated YAML->JSON generation, optional replay parsers, offline analysis, developer dashboards. No required external Node process for FPS frame loop.
- Author a versioned telemetry/replay contract without turning every internal function into JSON-over-WebSocket.
- Never assume camera switching itself implements possession; manual control lease, weapon/collision ownership and AI order arbitration need specific tests.

## Rejected MVP alternatives
1. TypeScript simulation in Node as *the* authority + Godot graphic frontend: possible but makes ordinary offline FPS depend on external IPC, coordinate mapping and collision duplication; uncertain latency. Defer pending measured benefit.
2. Community GodotJS TypeScript engine binding: interesting but unofficial and introduces dependency lifecycle risk. Research only.
3. Separate 2D RTS and 3D FPS world with duplicated entity state: rejected for desynchronization and design complexity.
4. TS/Babylon one-world: coherent **if 100% TypeScript runtime becomes a hard product rule**. Costs significant RTS construction work; benchmark if required.

## Acceptance tests
- Overlord -> Direct -> FPS -> Overlord hero retains entity ID, position, HP, weapons, cooldown, skill points.
- A wall blocks the same legally targeted projectile in RTS and FPS; no target domain bypass.
- Worker AI continues collecting while Hero is possessed; resource conservation holds.
- Hero death releases FPS controls, returns valid camera, leaves whole match playable.
- Headless fixed-seed scenario produces reproducible event log on pinned environment; do not promise cross-platform perfect lockstep.
- 30/60/120 entities performance measured, not guessed. Pixel-art perspective aesthetically reviewed at 1x and close FPS.

## Consequences
+ No accidental second game. Strong separation of authored rules from camera UI. Native game can run without npm/Tauri.
- Godot-first means some GDScript alongside TypeScript. RTS selection, pathing, combat and economy need implementation.
- Major engine decision remains **pending spike**. If Recoil wins, preserve TS schemas/tools and swap engine-specific native adapter rather than rewriting data/domain contracts.

Related: [Tech seed](mono-blue-tech-seed-2026-10-11.md), [Three pillars](../design/three-pillars-one-world-control-contract.md), [Engine comparison](../research/engine-selection-rts-possession-2026-10-11.md).
