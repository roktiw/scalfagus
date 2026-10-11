# SCALFAGUS — Coding-Agent Contract

## POST-MVP FACTION LOGISTICS UPDATE — DEC-035

Read [three-faction logistics and ETH unit relay](design/three-faction-logistics-and-eth-unit-relay-2026-10-11.md) and [machine-readable specification](design/three-faction-logistics-and-eth-unit-relay.yaml) before modifying post-MVP0 MAN/ORG/ETH logistics. MAN uses physical transporters, mode-dependent warehouses/bunkers/UMU and belts (NOT cargo in electricity/data cables); ORG uses large living carriers and finite rooted veins; ETH has finite actual storage on EVERY pylon, gradual typed-resource hop transfers, and additionally a **slow, finite-capacity ETH unit transit capability across connected pylon links**, which no other faction's infrastructure grants. Shared unit identity, inventory, network interruption behavior and authoritative transfer/cost semantics are mandatory; numerical balance and interruption policies remain TBD. **Do not introduce ETH, ORG, conveyors, UMU or pylon unit relays into the DEC-033 MAN-only first MVP0 release.**


## OWNER PRODUCT VISION — THREE CONTROL MODES (POST-MVP0)

**Read [command-autonomy design](design/command-autonomy-modes-2026-10-11.md) and [machine-readable contract](design/command-autonomy-modes.yaml) when planning future agent autonomy.** Player can instantly switch **FULL MANUAL** (classic RTS explicit orders), **SEMI-AUTO** (bounded managers controlling chosen groups of units and buildings) and **FULL AUTO** (civilization-wide doctrines with explicitly delegated authority). Preset doctrines include **War, Industrial, Reconstruction, Expansion Preparation, Defensive Readiness and Balanced**. Candidate doctrine panel exposes **3 / 5 / 7 axes** with -1 / 0 / +1 temperatures; temperature biases legal behavior, but never grants authority, vision, free resources or stat bonuses. Explicit manual commands always win. No reset or duplicate resource transactions on live mode/preset switches. **These are design contracts, not implemented or MVP0 deliverables. DEC-033 MAN-vs-MAN RTS-only release scope is unchanged.**


## LATEST VERIFIED SOURCE AUDIT — OPEN P0 GATES

Read the [consolidated mechanics findings](design/mvp-repository-mechanics-audit-2026-10-11.md) and [machine-actionable findings](design/mvp-repository-mechanics-audit.yaml) before editing the match. The [runtime parity checklist](design/mvp0-runtime-parity-gaps.yaml) has **CODE-GAP-01..17**, including corrected movement rate: `MirrorMatchState._walk()` moves **one cell only every third simulation tick**, not every tick. `mirror_view.gd` advances at **10Hz** in default GUI; the candidate sim specifies **20Hz**. Authoritative YAML map: **10 source nodes/1660 units**; current state: **4 source nodes/2500 units**.

`scripts/check.sh` NOW includes `mirror_smoke.gd` and `mirror_visual_smoke.gd`; the visual smoke protects directional sprite assets, startup window and camera zoom, but assumes exactly **four** resource visuals until map migration. The separately runnable `mirror_batch.gd` is **not** part of `scripts/check.sh`. None of these were executed by this documentation audit; run pinned Godot and record actual exit status, seed and hashes before writing “green”. The **current first-release numeric candidate** is `design/mvp0-agent-implementation-contract.yaml`; the other `mvp0-man-mirror-balance-v0.1.yaml` is a different analytical experiment, not an active second source.

**P0 coding order:** fix one timebase/profile → compile correct map/nav/collider/source data → verify paid end-to-end local RTS + smoke/headless → ENet host-authoritative two-client H-H → repeatable C-C + H-H QA. Do not start ETH/UMU/Energy or FPP work before DEC-033 MVP0 gates.

## P0 CODE-TO-RULE PARITY BLOCKERS (new source inspection)

**Before tuning bot results or calling `mirror_batch.gd` balanced**, review [current map/timing/network gaps](design/mvp0-runtime-parity-gaps.md) and [machine list CODE-GAP-01..15](design/mvp0-runtime-parity-gaps.yaml). The experimental `mirror_match_state.gd` uses **2500** hard-coded source units, `MAX_TICKS=5400` and mining a full bag in 6 ticks; canonical authored Verdant Divide uses **1660** source units. The GUI `mirror_view.gd` currently advances at **10Hz** while the intended candidate simulator is **20Hz**, so simulation time, gathering, training and rifle ranges need normalization. New test scripts have not been verified by this audit. H-H ENet authority is still a release blocker.

**Load ONE first-release numeric candidate:** [mvp0-agent-implementation-contract.yaml](design/mvp0-agent-implementation-contract.yaml) is the current selected source under [agent-source-of-truth.yaml](design/agent-source-of-truth.yaml). The additional [micro-MVP analytical profile](design/mvp0-man-mirror-balance-v0.1.yaml) and its [numeric scenario tests](design/mvp0-man-mirror-balance-acceptance.yaml) are **alternative experiments**; do not blend their differing worker speeds/build radii into runtime or claim tests pass. The [LAN authority protocol](design/mvp0-man-mirror-network.yaml) and [micro execution semantics](design/mvp0-man-mirror-execution-contract.md) provide detailed implementation help without adding ETH, UMU, Energy or FPP to MVP0.



## MANDATORY REUSE-FIRST ENGINEERING POLICY — DEC-034

**Every coding agent MUST search existing Scalfagus components, built-in Godot 4.7.2 APIs, and audited GitHub/AssetLib modules BEFORE implementing a generic subsystem.** Prefer existing wrappers, then thin adapters to engine primitives, then pinned and license-reviewed third-party modules, then only unique game-domain logic. GitHub availability alone is NOT approval: source, license, immutable commit, Godot 4.7.2 compatibility, macOS/Windows/Linux/Web support, authority/security, actual tests and rollback must be checked. **No arbitrary plugins, floating dependency branches, runtime auto-downloads, or self-written standard A*, physics, keybind framework, GUI layout, generic FSM or networking transport.**

**Required reading and PR evidence:** [ADR-0004 reuse architecture](architecture/adr-0004-godot-reuse-first-wrappers.md) → [component map](architecture/godot-reuse-component-map.yaml) → [GitHub candidate registry](architecture/godot-third-party-candidates.yaml) → [research](docs/GODOT-REUSE-RESEARCH-2026-10-11.md) → [agent playbook](docs/AGENT-REUSE-FIRST-PLAYBOOK.md) → [GitHub PR checklist](.github/pull_request_template.md). Candidate addons are **NOT installed** merely because listed. Godot built-ins count as preferred upstream reuse. The authoritative GameState, fog, owner validation, finite resource accounting, match state and victory logic are specific to Scalfagus and cannot be delegated to unverified plugins.

**Release precedence:** DEC-033 MAN-vs-MAN classic RTS first; DEC-034 governs HOW code is built. Preserve F2/F3 experimental camera code, but do not expand ETH/FPP/TPP into this micro MVP.

**Development evidence and next verification gates:** [Markdown report](docs/SCALFAGUS-MVP0-DEVELOPMENT-FINDINGS-2026-10-11.md) and [machine-readable YAML](design/mvp0-development-findings-2026-10-11.yaml). Newly added MAN mirror state, renderer, smoke and batch runners are committed but **unverified**; no Human–Human LAN host yet. Never treat historical Godot smoke passes as evidence the new RTS compiles.

**Code status (2026-10-11):** Experimental implementation added at `apps/game/scripts/mirror_match_state.gd` (fixed-tick MAN state, four unit/building templates, bot controllers, economic ledger, combat and victory), `mirror_view.gd` + `scenes/mirror_match.tscn` (local RTS blockout), `tests/mirror_smoke.gd` + `tests/mirror_batch.gd` (new headless tests). Menu launches H-C or C-C only. **Code committed but new Godot tests are NOT verified**, and Human-Human LAN is still TODO. Preserve legacy spike and run `bash scripts/check.sh` before reporting any pass.\n\n## CURRENT RELEASE GATE — DEC-033 current micro-MVP (supersedes old MAN+ETH first-MVP plan)

**Implement ONLY the MAN-vs-MAN classic RTS for MVP 0.1, with two player slots and all three combinations H-H / H-C / C-C.** Human-Human requires two Godot clients over LAN or loopback and an authoritative host; computer players use the same commands. C-C runs headless/accelerated or in observer mode. The roster for this first release is **Command Core / MIN worker / Barracks / Rifleman**; initial Matter-only finite-gather economy, one floating-space-platform Verdant Divide map, combat and full building-elimination victory. **NO FPP/TPP gameplay, ETH/ORG, MAN UMU/power networks, Hero progression or advanced resources in this micro-MVP.** Preserve the existing three-camera prototype/smoke for safety; do not advertise or enhance it as an MVP deliverable. Future product FPP remains DEC-031. Do not infer that the new scope has been implemented.

**Authoritative agent reading order:** [DEC-033 in decisions](design/decisions.yaml) → [micro MVP design](design/mvp0-man-mirror-rts-2026-10-11.md) → [micro MVP YAML](design/mvp0-man-mirror-rts.yaml) → [proposed MVP0 implementation parameters](design/mvp0-agent-implementation-contract.yaml) → [micro MVP agent backlog](design/mvp0-man-mirror-backlog.yaml) → [micro MVP acceptance](design/mvp0-man-mirror-acceptance.yaml) → [runtime test cases](design/mvp0-man-mirror-rts-runtime-tests.yaml) → [Godot headless balance lab](design/godot-headless-balance-lab-2026-10-11.md). **Mechanics audit:** [Markdown findings](design/mvp-repository-mechanics-audit-2026-10-11.md), [YAML findings](design/mvp-repository-mechanics-audit.yaml), [machine authority](design/agent-source-of-truth.yaml). The older two-faction `MVP-DELIVERY-GATES.md` and `mvp-implementation-backlog.yaml` are **post-MVP history**, NOT the current execution queue.


**Current architecture: Godot 4.7.2 Standard / GDScript, one native window, one authoritative 3D world.** No Tauri, Rust, Vite, WebView or second launcher. Godot already has a menu, a Hero actor, and F1 RTS / F2 Direct / F3 FPS camera spike. It does **not yet** have the full playable RTS mechanics. Do not overwrite or re-bootstrap the project from scratch.

**Most important latest owner decision (DEC-030): EVERY PLAYABLE SCALFAGUS MAP IS A FLYING PLATFORM IN OUTER SPACE.** This is mandatory for all maps, not an optional aesthetic preset. Soil with jungle trees, welded metal patchwork, rocks, sand, marshland or mixed materials may cover the platform, but the world always visibly has a space-facing rim/underside and a cosmic exterior. No ordinary planet-surface playable map. In MVP, the surface is a bounded planar **64×64 candidate square** with real elevation/ramps, invisible hard outer walls, a visible space-platform edge, one gameplay ground deck and uniform gravity. The platform does NOT physically move during matches; its backdrop planet/stars are noninteractive.

**Current implementation handoff:** [RTS navigation & minimap](docs/RTS-NAVIGATION-DEVELOPMENT-2026-10-11.md) and [first RTS slice](docs/RTS-FIRST-SLICE-2026-10-11.md). Treat the coarse A* map, mock ETH actors and debug minimap as prototype code. The canonical map YAML and economic/combat MVP are NOT yet implemented. Import and run new Godot headless tests before merge; never report completion from source review alone.\n\n## Historical two-faction expansion references — NOT the MVP 0.1 worklist

**The following eight references describe the future MAN–ETH five-role implementation, not the current MAN mirror scope.** Do not load their separate numerical balance profile, Energy, ETH networks, UMU or old three-camera UI into `mvp_0_1`. For the first release use the DEC-033 read order above, and the DEC-034 reuse-first policy at the top.

## Historical future reading (in precedence order)

1. **Owner decisions:** [design/decisions.yaml](design/decisions.yaml), especially **DEC-030** for every map, DEC-024 for victory, DEC-025 for roster/MVP, DEC-026 for environmental affinities, DEC-021–023 for networks and loot.
2. **Universal world law:** [design/space-platform-world-contract-2026-10-11.md](design/space-platform-world-contract-2026-10-11.md); compulsory [design/battlefield-frames.yaml](design/battlefield-frames.yaml); valid [surface/biome presets](design/platform-surface-presets.yaml).
3. **Concrete required deliveries:** [design/MVP-DELIVERY-GATES.md](design/MVP-DELIVERY-GATES.md), [design/mvp-implementation-backlog.yaml](design/mvp-implementation-backlog.yaml), [design/AGENT-MVP-IMPLEMENTATION.md](design/AGENT-MVP-IMPLEMENTATION.md).
4. **First map:** [design/mvp-verdant-divide-map.yaml](design/mvp-verdant-divide-map.yaml), [design/map-authoring-format-v0.1.yaml](design/map-authoring-format-v0.1.yaml), [design/world-environments.yaml](design/world-environments.yaml). Note version of the YAML manifest; do not treat a sparse authored route hint as proof of walkable navmesh.
5. **Game mechanics:** [design/mvp-man-eth-catalog.yaml](design/mvp-man-eth-catalog.yaml), [design/mvp-economy.yaml](design/mvp-economy.yaml), [design/mvp-combat.yaml](design/mvp-combat.yaml), [design/mvp-bot-behavior.yaml](design/mvp-bot-behavior.yaml).
6. **Shared invariants:** [design/three-network-channels-and-destruction.yaml](design/three-network-channels-and-destruction.yaml), [design/world-loot-and-recycling.yaml](design/world-loot-and-recycling.yaml), [design/victory-building-template-registry.yaml](design/victory-building-template-registry.yaml).
7. **Executable tests to write:** [design/mvp-man-eth-acceptance.yaml](design/mvp-man-eth-acceptance.yaml), [design/battlefield-frame-acceptance.yaml](design/battlefield-frame-acceptance.yaml). These YAML files are design fixtures, NOT tests that have already passed.
8. **Historical comparisons only:** [design/floating-platform-battlefields-2026-10-11.md](design/floating-platform-battlefields-2026-10-11.md) previously treated flying platforms as optional; [design/planetary-map-topology-2026-10-11.md](design/planetary-map-topology-2026-10-11.md) considered real spheres. **DEC-030 supersedes those alternatives.**

## Historical two-faction slice (after MVP 0.1; NOT first playable release)

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

## Historical MAN+ETH implementation order (after micro MVP)

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
- If specs disagree, **latest approved DEC wins**: DEC-030 all-platform world over DEC-029 optional map skin or ordinary-planetary fallback; DEC-033 MAN-mirror first release above DEC-025 historical two-faction plans; DEC-034 reuse-first engineering; DEC-030 universal floating-platform world; DEC-024 building-class victory.
- Prefer small idempotent changes to existing scenes/scripts. Never replace Godot with another engine, generate an empty scaffold instead of completing playable behavior, or duplicate source stock into both a world drop and an account refund.
