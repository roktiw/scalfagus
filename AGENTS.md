# SCALFAGUS — Coding-Agent Contract

**Current architecture: Godot 4.7.2 Standard / GDScript, one native window, one authoritative 3D world.** No Tauri, Rust, Vite, WebView or second launcher. Godot already has a menu, a Hero actor, and F1 RTS / F2 Direct / F3 FPS camera spike. It does **not yet** have the full playable RTS mechanics. Do not overwrite or re-bootstrap the project from scratch.

**Most important latest owner decision (DEC-030): EVERY PLAYABLE SCALFAGUS MAP IS A FLYING PLATFORM IN OUTER SPACE.** This is mandatory for all maps, not an optional aesthetic preset. Soil with jungle trees, welded metal patchwork, rocks, sand, marshland or mixed materials may cover the platform, but the world always visibly has a space-facing rim/underside and a cosmic exterior. No ordinary planet-surface playable map. In MVP, the surface is a bounded planar **64×64 candidate square** with real elevation/ramps, invisible hard outer walls, a visible space-platform edge, one gameplay ground deck and uniform gravity. The platform does NOT physically move during matches; its backdrop planet/stars are noninteractive.

## Required reading (in precedence order)

1. **Owner decisions:** [design/decisions.yaml](design/decisions.yaml), especially **DEC-030** for every map, DEC-024 for victory, DEC-025 for roster/MVP, DEC-026 for environmental affinities, DEC-021–023 for networks and loot.
2. **Universal world law:** [design/space-platform-world-contract-2026-10-11.md](design/space-platform-world-contract-2026-10-11.md); compulsory [design/battlefield-frames.yaml](design/battlefield-frames.yaml); valid [surface/biome presets](design/platform-surface-presets.yaml).
3. **Concrete required deliveries:** [design/MVP-DELIVERY-GATES.md](design/MVP-DELIVERY-GATES.md), [design/mvp-implementation-backlog.yaml](design/mvp-implementation-backlog.yaml), [design/AGENT-MVP-IMPLEMENTATION.md](design/AGENT-MVP-IMPLEMENTATION.md).
4. **First map:** [design/mvp-verdant-divide-map.yaml](design/mvp-verdant-divide-map.yaml), [design/map-authoring-format-v0.1.yaml](design/map-authoring-format-v0.1.yaml), [design/world-environments.yaml](design/world-environments.yaml). Note version of the YAML manifest; do not treat a sparse authored route hint as proof of walkable navmesh.
5. **Game mechanics:** [design/mvp-man-eth-catalog.yaml](design/mvp-man-eth-catalog.yaml), [design/mvp-economy.yaml](design/mvp-economy.yaml), [design/mvp-combat.yaml](design/mvp-combat.yaml), [design/mvp-bot-behavior.yaml](design/mvp-bot-behavior.yaml).
6. **Shared invariants:** [design/three-network-channels-and-destruction.yaml](design/three-network-channels-and-destruction.yaml), [design/world-loot-and-recycling.yaml](design/world-loot-and-recycling.yaml), [design/victory-building-template-registry.yaml](design/victory-building-template-registry.yaml).
7. **Executable tests to write:** [design/mvp-man-eth-acceptance.yaml](design/mvp-man-eth-acceptance.yaml), [design/battlefield-frame-acceptance.yaml](design/battlefield-frame-acceptance.yaml). These YAML files are design fixtures, NOT tests that have already passed.
8. **Historical comparisons only:** [design/floating-platform-battlefields-2026-10-11.md](design/floating-platform-battlefields-2026-10-11.md) previously treated flying platforms as optional; [design/planetary-map-topology-2026-10-11.md](design/planetary-map-topology-2026-10-11.md) considered real spheres. **DEC-030 supersedes those alternatives.**

## Frozen playable MVP boundaries

- Exactly **two playable factions**, MAN and ETH, each initially: mother/HQ, MIN worker, basic soldier, infrastructure (MAN **UMU** / ETH **Pylon/Obelisk**), barracks. Hero reuses a soldier-based actor and preserves the SAME entity ID/HP/cooldowns across F1/F2/F3.
- First battlefield = **Verdant Divide**: stationary **floating jungle deck in space**, brown fertile earth, trees with real solid-trunk line-of-sight and movement blocking, freshwater ponds/streams (nonharvestable), two starts, authored paths and scattered finite SOLIDS.
- **Only raw SOLIDS are harvested** in the MVP (directly without a mining building). They yield Matter through an explicit MVP-specific mapping. No direct liquid/gas extraction. Energy is separately accounted and sourced at finite declared rates; Volatiles is not required on initial recipes.
- MAN: ground-mobile UMU as generator + warehouse OR bunker; physical material crates, one hybrid power-conductor + optical-data cable; builders assemble real frames (worker caps 1/2/2); unfinished structures and loose crates remain and can be looted.
- ETH: Nexus is the only physical-cargo to typed-Ether converter; **one** actual network through anchored pylons transfers real typed Matter/Energy/information with finite inventories and capacity; builders use beam (caps 1/2/3). Interrupted active incomplete construction **immediately ejects all site-committed materials as real ETH orbs**.
- Loot: MAN crates/cubes, ETH orbs, later ORG tetrahedra; form colors SOLID amber / LIQUID cyan / GAS violet; cross-faction pickup legal, completed-asset recycling loses resources and must not create infinite income.
- **Default victory = all opposing live completed BUILDING-CLASS entities destroyed**, including packed/moving MAN UMU. Workers, soldiers, surviving Hero, trees, platform structure, loose crates, cables or incomplete ruins do not count.
- No in-MVP player flight, sailing, swimming, genuine curved planet terrain, interplanetary travel, moving platform origin, multiplayer, playable ORG, new heavy-unit/barracks families, or full tech tree.

## Runtime + commands

The **existing native Godot project** is under `apps/game/`. Game is one Godot window with a built-in menu. Node is optional **offline tooling** (sprite atlas checks, build-time YAML→JSON compiler) and **not** a gameplay runtime. Do not reintroduce Tauri.

From repo root on a supported system with Godot installed:
```sh
bash scripts/check.sh                   # native Godot import, game smoke, menu smoke; optional Node asset checks
bash scripts/dev.sh                     # native Godot menu/game
bash scripts/dev.sh --editor            # native Godot IDE
```
On macOS `bash scripts/bootstrap.sh` installs/validates the pinned official Godot binary; on other OS set `GODOT_BIN` to the installed compatible Godot. Check actual code/project/scripts before assuming an API or executable. Never claim tests passed if not run.

## Implementation order and quality bars

- **G0** inspect current game and preserve existing Hero / 5-direction renderer / menu tests.
- **G1** validate and compile mandatory **space-platform** YAML into runtime terrain: brown soil, water, fixed tree trunk cover, ramps, stable spawn/SOLIDS, visible rim/underside/starfield and four impenetrable bounds; **reject** missing or classic planetary-surface framing.
- **G2–G4** spawn correct MAN/ETH roster, select/order units, mine/carry/deposit real Matter, spawn infrastructure, construct with faction-specific actual logistics and finite Energy.
- **G5–G6** produce soldiers, fight around tree cover, use win condition, run fair scripted bot from initial match until end.
- **G7–G9** physical salvage and loot, network splitting and no-duplication, full HUD and one Hero across camera modes, reproducible tests and perf.
- For each gate, add executable headless checks with corresponding design-fixture IDs; report tested, untested and blocked cases. Do **not** mark design-only YAML as implemented.

## Documentation, data and change policy

- Write all repository documentation, source comments, names and commit messages **in English**.
- A playable map's `battlefield_frame.variant` **MUST** equal `floating_space_platform`. Vary `environment.preset` and surface material region masks for soil, metal patchwork, desert, rocky or aquatic-looking platforms. Merely painting a planet in the background does not make the gameplay level spherical.
- Gameplay-critical cover, source, spawn, ramp and liquid features are authored as deterministic semantic objects; cosmetic plants, rivets and starfield may be seeded and are nonblocking.
- YAML numbers such as HP, exact prices, map physical scale and Energy production are developer starting hypotheses for playtests. Never call them final owner-approved balance.
- If specs disagree, **latest approved DEC wins**: DEC-030 all-platform world over DEC-029 optional map skin or ordinary-planetary fallback; DEC-025/026 first MVP and natural-domain lore; DEC-024 all-buildings victory.
- Prefer small idempotent changes to existing scenes/scripts. Never replace Godot with another engine, generate an empty scaffold instead of completing playable behavior, or duplicate source stock into both a world drop and an account refund.
