# Scalfagus — Internal MVP Scope: 1990s Isometric RTS, Hero and Tiny FPS Possession

Date: 2026-10-11
Status: **recommended playable scope**, not implementation. User-required product ingredients identified; unit/building counts are adjustable planning caps.

## Product outcome / player promise

Current three faction names: **Organs (ORG / Organites), Manus (MAN / Manusians), Eters (ETH / Etherans)**. Full names and backronyms: [Naming Canon](faction-naming-conventions-2026-10-11.md). The initial prototype remains Manus-only.

One original, offline **retro pixel-art isometric RTS** with **three observation/control views on the SAME game world**:
1. Overlord — build a small autonomous settlement, transport finite cargo, command a small army, place basic defense.
2. Direct Unit — `Realm of the Mad God`-like near-isometric/top-down action with the player's existing Hero (simple move + aim + attack; TPP optional later).
3. Full FPS — small Dungeon Keeper I-like possession of the **same Hero** with WASD + mouse look/fire, and instant return to Overlord.

Every human player starts with **one Hero**, who has an Engineer / Commander / Specialist starting *preset* and one shared, open, consequence-aware skill graph; specialization can pivot. Preset choice does not block cameras. This does NOT promise three parallel complete standalone genres.

## Default victory and latest economic contracts — DEC-021–024 (2026-10-11)

**OWNER APPROVED DEFAULT WIN:** the opponent is defeated when all **completed living building-class entities** owned by that team are gone. This includes mobility-capable structural units such as the MAN UMU, even while traveling/packed, and ETH pylons/Nexus or ORG living buildings. It does **not** require killing all ordinary workers, soldiers or the Hero. Loose tetrahedral/cubic/orb loot, standalone conduit segments and incomplete scaffolds are not victory-preserving buildings. No resource-exhaustion timeout is implied. An optional designated-heart objective requires explicit scenario selection; it is not default.

**Current owner mechanics:** [new ORG/MAN/ETH 2/3/1 networks](three-network-channels-and-destruction-2026-10-11.md): ORG finite actual cargo/energy/info in live veins and two mitochondria (precise scope TBD), MAN Universal Man Unit (UMU) + real material logistics + power/data hybrid cables, ETH one typed Ether Network for cargo/info/Energy after Nexus conversion. [Visible loot and recycling](world-loot-salvage-and-recycling-2026-10-11.md) adds cross-faction collectible tetrahedron/cube/orb material drops and per-form colors, loss-bearing salvage, ETH incomplete-site immediate drop, ORG timed spit-out and MAN persistent recoverable excavation. [Victory rule](victory-defeat-building-classification-2026-10-11.md) is the default ruleset.

**MVP impact:** build a single deterministic ledger and a `WorldDrop` entity, ensure genuine salvage custody and correct no-duplication settlement. First MAN playable slice can test UMU→hybrid power/data cable→physical construction crates→scaffold/ruin loot→all-buildings victory without needing the entire three-faction economy at once. ETH and ORG adapters follow the same transaction/event contracts. Exact salvage rates, Ether pylon node rate and mitochondrial energy requirements need tests.

## Source of truth and design constraints
- Product philosophy [product-principles.md](product-principles.md).
- View/input semantics [three-pillars-one-world-control-contract.md](three-pillars-one-world-control-contract.md).
- Hero contract [hero-progressions-and-three-cameras-2026-10-11.md](hero-progressions-and-three-cameras-2026-10-11.md).
- Engine benchmark [engine-selection-rts-possession-2026-10-11.md](../research/engine-selection-rts-possession-2026-10-11.md).
- Three resources Matter, Volatiles, Energy; no fourth primary currency. Existing Crystals/Gas/Resin legacy YAML must be migrated before production config.
- One initial playable Manus side; scripted Manus mirror opponent. Fourth machine civilization remains post-MVP exploratory. No hive mind requirement.
- Shared units and weapons obey domain, LOS, cost, control lease, cooldown and fog rules. FPS does not grant free damage or global scouting.

## Phase 0 — engine selection / kill-test (must precede serious content)
**Single reproducible 3D world** represented as Warcraft-II-readable isometric pixel art from above, but first-person navigable geometry beneath. Colored placeholder map acceptable.
- A 32x32 or 48x48 map, 1 wall, 1 ramp/height step, 1 small base, 2 units and enemy target.
- Select hero in Overlord; Direct Unit from overhead; FPS; move/fire; switch back, verify identical actor ID, position, HP and inventory/cooldown.
- While controlling hero, worker automatically mines and delivers Matter to storage.
- Show one hero ability from Direct and FPS whose cooldown/cost state remains the same.
- On hero death FPS exits safely, ordinary army/base remains operable.
- Compare Godot 4 vs Recoil first; Babylon.js only if first pair fail or TS/browser changes priority.
- Test real pixel-art asset pipeline near and far camera; 2D sprite billboarding may be insufficient at close FPS distance. May need flat 3D proxies or camera-specific cosmetic first-person weapon hands that do NOT create gameplay actors.
- No commitment to cross-platform deterministic physics, multiplayer netcode or large battles until measured.

## Extraction-form gate amendment (DEC-016, 2026-10-11)

**Owner-directed shared extraction law:** raw SOLID nodes are dispersed and directly gathered by MIN without mine infrastructure; LIQUID sources permit slow, low-capacity worker tapping but an optional pump accelerates sustained production; GAS deposits **require a completed capture/extraction structure** before any gas output. Physical form does not replace the approved Matter/Volatiles/Energy identifiers; form-to-spendable-resource recipes are TBD. See [physical resource forms](physical-resource-forms-and-extraction-2026-10-11.md) and [data contract](physical-resource-forms.yaml).

**Playable sequencing:** Phase 1 may prove a standalone solid gathering loop first. Internal MVP/full 3-faction economy proving should include direct liquid tapping and pump choice, then at least one mandatory gas collector, a valid built-without-gas bootstrap recipe and physical packet handling. All three factions must obey the same access gates with their existing racial construction and transport rules. Do not build a complex continuous-fluid pressure simulator for MVP: sealed finite cargo packets suffice.

## Phase 1 — smallest playable vertical slice (about 10 minutes to finish)
- One **original sprite + small 3D collision map** with obstacles, chokepoint and distinguishable resource deposit.
- Three functional ordinary unit types: worker, melee fighter and shooter; **one Hero** using the shooter actor class plus starter equipment and talent data, not a new independent game engine.
- Buildings: HQ, one depot/extractor, one training/production site and a simple defense/trap (may reuse mesh art).
- Matter working production loop; stub/fixture Volatiles and Energy internally at first, then **implement real three-resource transport** by internal MVP acceptance.
- Overlord select/move/attack/build, Direct Unit steer/aim/fire and FPS walk/aim/fire.
- Basic bot raid vs base and **default defeat by destroying all enemy building-class entities** (including mobile structural UMU) or a specifically scripted optional survive-wave objective. A single enemy HQ is not universally sufficient to end the default match.
- One simple skill graph with 3 starting kit names but only **one ability** needed to validate cross-camera effects.
- Basic economy worker AI and opponent controller.
- No advanced tech branching, training simulation or high polish required.

## Phase 2 — internal playable MVP (scope frozen after player test)
### SIM / Architect
- 1 authored compact map with consistent height, obstacles and sightline/collision; visual readability at RTS pixel scale and from FPS.
- Complete Matter, Volatiles and Energy collection, storage, physical short-haul transfer and spending, without tedious carrier micro.
- Suggested 5–7 simple building categories (HQ, resource extractor, energy source, depot, production, turret, one trap). Merge when useful.
- Bounded base AI for worker scheduling, construction suggestion/basic autonomous development, defense priorities. Fully manual play remains valid.
- One meaningful tower-defense decision (placement of turret/trap at chokepoint). No full Dungeon Keeper room simulation or Factorio belts.

### COMMANDER / RTS
- Unit selection, click move/attack, produce, simple squad/multi-select, health, visible resource bottleneck, fog-of-war, AI opponent and victory/defeat/restart.
- Class taxonomy eventually seven role archetypes. **Do not require all seven fully distinct production assets to get MVP playable**; a proposed MVP target is **worker, fighter, shooter, tank/defender, artillery/structure breaker and specialist** only if each brings a testable choice. Flyer/AA can be added as balance allows. Full 7 x 3 x 3 catalog is explicitly not in MVP.
- Hero is one normal world actor with hero tag and one active ability; starts each participating player's match.
- Direct Unit view: fixed elevated top-down or near-isometric camera, WASD, mouse target/fire, one ability, switch back to Overlord.
- Human manual orders supersede base AI within clear ownership scope.

### AVATAR / FPS
- One eligible **player-owned Hero** can be controlled in literal FPS; walk/look/primary fire/use and exit. Other unit possession is future.
- Same weapon profile and shared validated hit/LOS as RTS/Direct. Direct/manual precision advantage must be tested, not assumed balanced.
- FPS collision uses same map geometry as overhead pathfinding/obstacle concepts. Don't render a second independently simulated map.
- Auto-exit and release controller when Hero dies, becomes ineligible or match ends.
- TPP optional; polished first-person bodies, multiplayer prediction, jumping/traversal, Quake physics, vehicles, species-specific FPS are NOT required.

### HERO / single open skill graph
- Three **starter kits**: Engineer (repair/build/defenses), Commander (unit orders/rally/mark target), Specialist (combat/scout precision), with clear economic costs and limited abilities.
- One shared tiny progression graph with **6–9 talents total**, ideally 2 bridge talents and 1–2 exclusive alternatives. No three parallel classes. Implement a visible Engineer -> Specialist pivot and Specialist -> Commander pivot.
- Choices exclude incompatible FUTURE picks; do not quietly erase already purchased abilities without player approval. Exact in-match respec/death/XP mechanics pending decision.
- Pilot objective/milestone-based rewards, not click farming; ordinary RTS remains winnable without hero skill upgrades.

### TECH / QA
- One sim authority for health, movement, orders, resources, skills and targeting; distinct camera/input adapters; controller lease ownership on Hero.
- Simple fixed-step world and repeatable event-command testing on pinned environment; do not promise deterministic cross-platform lockstep until tested.
- Basic tests: RTS->Direct->FPS->RTS actor identity; worker AI continues; no double spending; LOS through wall blocked; hero ability cooldown preserved; zero duplicate enemy units; hero death graceful.
- Original art / legitimate licensing. Build and run locally without Internet/API keys.

## What is NOT in internal MVP
- All three or four playable civilizations with full asymmetry or every one of 63+ templates.
- Fifth race, procedural Genesis faction evolution, complete MTG card/deck UI, hero campaign progression.
- Dedicated multiplayer FPS, shared faction networking, Quake/CS/Enemy Territory complete gunplay, advanced TPP.
- Terraforming beyond one simple static height/ramp, real naval gameplay, huge terrain/world/asteroids.
- Complete SimCity city needs, Factorio complete automation chains, Transport Tycoon railway scheduling, thousands of independent entities.
- Live LLM strategic agent, cloud subscription, proprietary art reuse, indefinite skill trees.

## Definition of Done (internal build)
1. From desktop launch, user can start a match, choose a hero starter kit and obtain one owned Hero.
2. User can **play a complete 10–25 minute scenario** primarily through Overlord without FPS and without hand-moving cargo.
3. Economy collects/transports/stores/spends Matter, Volatiles and Energy with one legitimate autonomous loop.
4. Player can command ordinary army units, build a defense and destroy **all surviving enemy buildings including mobile building-class units**, or complete an explicitly selected scenario objective; workers/loot/ruins do not block this victory.
5. In the SAME live match Hero can switch **Overlord -> Direct Unit -> FPS -> Overlord**, move, fire and use at least one valid shared ability, with consistent HP, position, collision, sightline, costs and cooldowns.
6. Choosing hero talents has visible effects and demonstrates at least one cross-archetype pivot while leaving other play styles accessible.
7. On Hero death, no stuck camera or locked input; base/army remain playable.
8. Local replayable accepted command log/headless smoke tests pass on pinned runtime.
9. New player can accomplish first harvest/build/attack without understanding progression graph, possession or configuration flags.
10. All assets original/appropriately licensed.

## Largest unresolved questions
- How important is literal 2:1 pixel-perfect isometric projection compared with usable FPS 3D geometry? Need art spike.
- Is FPS balance optional unranked in early release? Direct aiming can grant measurable advantage.
- Are all 3 starter kits mechanically distinct from first internal MVP or only input presets with one common hero ability at first?
- Which Hero death/recovery economy? Hero cannot be indispensable to allow pure RTS matches.
- Exactly how does choice exclusion/respec work? Owner wording leaves this open.
- Is TPP just camera option for Direct Unit or separately advertised polished control style? Recommend later.
- User's unfinished reference to 'style of driving from ...' requires a title if relevant to vehicle handling.

This is a design/buildability contract, not a claim that any code exists yet.
