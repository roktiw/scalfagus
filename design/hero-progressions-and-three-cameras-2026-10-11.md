# Scalfagus — One Hero per Player, Open Specialization Graph, Three Camera Modes

> **DEC-033 scope note (2026-10-11):** This file describes historical full-game Hero/three-camera concepts, NOT current first-playable deliverables. MVP 0.1 ships **one faction MAN vs MAN**, classic **Overlord RTS only**, H-H (LAN/loopback), H-C and C-C, four core MAN templates. FPP possession is a **later** approved direction under DEC-031; TPP/Direct is not a target shipped mode. See [current first-release spec](../design/mvp0-man-mirror-rts-2026-10-11.md) and [current backlog](../design/mvp0-man-mirror-backlog.yaml). Existing 3-camera technical spike is preserved as regression baseline; no code migration is implied.\n\n
Date: 2026-10-11

> Faction terminology: **Organs / Organites (ORG), Manus / Manusians (MAN), Eters / Etherans (ETH)**. See the [approved naming canon](faction-naming-conventions-2026-10-11.md). Hero roles, skill pivots and camera modes are independent of faction names.
Status: **owner-requested product direction**. Ability names, progression mechanics, balance and presentation details below are **proposals**, not playtested rules.

## Executive rule
**Every human player starts each match with one identifiable Hero unit**. The Hero can become an Engineer (SIM), Commander (RTS), or Specialist (direct action) and evolve between these areas in one shared, open, choice-sensitive progression graph. The player can freely switch between **three camera/control modes**:

1. **Overlord** — overhead orthographic/isometric world overview for settlement production, logistics, traps, towers and classic RTS command.
2. **Direct Unit** — Realm of the Mad God-like top-down/isometric action control, or optional following third-person camera; one existing actor is directly steered.
3. **Full FPS** — Dungeon Keeper I-like first-person possession/control of the same existing actor.

**A Hero archetype is neither a player class lock nor a camera mode.** An Engineer can shoot in FPS; a Specialist can command armies in Overlord. What changes are talents, equipment, efficiencies and decisions available, not the legal right to open a camera. **Three initial presets, one shared graph, three views, one simulation**.

## The central design distinction: role, hero build, camera, controller
- **Player role / game pillar** = Architect (SIM), Commander (RTS), Avatar (individual action).
- **Hero starting kit/archetype** = Engineer / Commander / Specialist; an initial stat/equipment/talent choice, not a different species/class engine.
- **Hero development** = one shared capability graph with branch prerequisites, exclusions, talent-point cost and possible pivots.
- **Camera/control perspective** = Overlord / Direct Unit / FPS; perspective can change regardless of hero build when actor eligibility rules permit.
- **Unit possession** = a controller lease on an existing unit, not creation of a second entity. Whether anyone can possess other owned units or only their Hero is **not yet final**.
- **Game mode** = match configuration (MIN/MID/MAX, manual/assisted/autonomous AI, co-op/multiplayer rules), separate from all above.

## One Hero per human player
- Exactly one initial Hero unit per participating *human player* in standard matches. AI players may receive an equivalent Hero under the same rules when scenario/balance demands; do not make human-only free power in competitive play.
- Hero has stable entity ID, position, orientation, health, inventory, progression, owner, and one controller lease.
- Starting Hero should be useful even if the player remains in Overlord and never possesses them.
- The Hero is an **avatar and strategic assistant**, not the only unit that can build, command or fight.
- Keep ordinary workers, squads, factories and defenses functional without a Hero standing nearby.
- Start kit is a strategic choice or tutorial preset; game can default to Engineer in a SIM-focused tutorial. Presets require parity testing, not arbitrary power rankings.
- In co-op/shared-faction mode each human can own one Hero while coordinating the same economy. Unique claims to the same unit cannot be held simultaneously.
- Unresolved: death means respawn at cost, recoverable injury, or match elimination? Strong recommendation: **not immediate elimination**; a paid recovery or cooldown preserves broad SIM/RTS freedom and reduces snowballing. Test costs.
- Hero unit is *not* a new eighth unit archetype; it is a tag/trait on a configurable unit spanning the same movement, health, attack and economy rules.

## Three starting Hero kits (working)
| Starter preset | Immediate tools | Contribution from Overlord | Direct Unit / FPS feel | Vulnerability |
|---|---|---|---|---|
| Engineer | repair tool, starter construction modifier, 1 deployable | accelerates one legal build/repair job or places a small defense/trap | manually fix, deploy, salvage and fend off enemy; engineer in Enemy Territory spirit | low direct combat damage; limited carrying capacity |
| Commander | recon/command beacon, rally/stance tool | issues a squad rally or targeted doctrine/ping; gives tactical *local*, not global omniscient bonuses | sidearm/rifle, leader movement, mark a visible target | vulnerable when isolated; commands cost attention |
| Specialist | single aimed ability (shot/dash/shield variant), sensor | acts as scout, disruptor, assassin or defender | most expressive precision action, not superpowered free DPS | poor baseline economy/army buff |

Proposal for MVP: implement **one underlying hero scene/entity and one primary combat weapon + one role-tagged active skill**, not three complete combat classes, three animation families, three inventories or three sets of controls.

### Example abilities (proposals)
- Engineer: `Field Repair` spends finite Matter/Energy; `Place Sentry` consumes recorded resource cost and build time. Must not let human manually conjure towers for free.
- Commander: `Rally Beacon` affects friendly units in a visible, finite radius and lasts limited ticks; `Priority Target` marks only a target visible under the faction's fog state.
- Specialist: `Focused Shot` uses existing weapon damage/cooldown calculation; `Dodge Burst` spends a stamina or cooldown budget, **not a fourth primary economic currency**.

## One open progression graph, with consequential choices
Owner proposal: **any hero can develop any capability**, but each next pick can close incompatible alternatives. The Hero can start Engineer and pivot toward Specialist; start Specialist and later gain Commander abilities; a Commander can acquire practical engineering.

Avoid three mutually exclusive, opaque trees. Represent talents as **one capability graph** with:
- `prerequisites` (what must already be learned),
- `excludes` (genuine mutual exclusivity, not every branch),
- `point_cost` (finite progression budget),
- `tags` (engineering / command / action, optional),
- `effect` (data-driven bounded modifiers / skill unlocks),
- `respec_rule` (TBD: none in match, limited at HQ, between matches only).

**IMPORTANT: 'choices close previous choices' has multiple interpretations.** Prefer that a new talent *blocks some alternative future investments*, not silently deletes skills already purchased. It is possible to pivot through bridge skills at increasing opportunity cost; no build should become permanently unplayable due to a misunderstood click.

### Illustrative graph (NOT final)
- Tier 0, universal: Move, Inspect, Interact, Attack, Build/Repair (only if unit/equipment permits).
- Tier 1, starter flavor: `Field Tools` (E), `Squad Radio` (C), `Targeting Rig` (S).
- Tier 2, cross-branch bridge: `Combat Engineer` (E+S); `Forward Observer` (C+S); `Logistics Officer` (E+C).
- Tier 3, exclusive specialization examples: `Field Architect` *versus* `Demolitionist`, `Operations Network` *versus* `Duelist Systems`. Not every Tier 3 must be exclusive.
- A choice may require a compatible equipment slot and has no effect when the unit cannot perform the action. Show disabled button with reason.
- Example pivot: starts Engineer (`Field Tools`), learns `Combat Engineer`, invests later in `Targeting Rig` and `Duelist Systems`; sacrifices top-level macro-construction efficiency.
- Example pivot: starts Specialist (`Targeting Rig`), learns `Forward Observer` and later `Operations Network`; never becomes automatically better than a dedicated Commander at both dueling and army bonuses with the same talent budget.

### User experience
Show three visible lanes on a **single small skill map** with connectors and clear icons. The UI has *one default recommended upgrade* for each starter preset. Optional full graph for experts; inspect talents and incompatibilities before choosing. No mandatory talent micro during combat. At most one popup after leveling, and allow postpone.

## XP and balance design (proposals)
- Three ways to earn progression: **engineering contributions** (valid buildings repaired / completed), **command contributions** (squad objectives, defensive orders, scouting), **direct action contributions** (combat, enemy units disrupted). Important: **award capped progress for meaningful outcomes, not spam clicks or repetitive building/demolition abuse**.
- Alternative **shared match milestone XP** or time/objective budget prevents a Specialist from outleveling an Architect solely due to access to FPS damage events; run fairness tests.
- Start with **simple fixed mission milestone rewards**, not elaborate anti-farm XP, until the three pillars playtest proves fun.
- Hero talent choices modify *scope, cadence, convenience and specialized outcomes*, not foundational input rights. A Commander should not be necessary for all units to obey ordinary RTS commands.
- Direct manual precision should have meaningful opportunity cost because player attention is scarce, but no extra damage multiplier without balance cost.
- No power escalation that makes normal squads obsolete, and no hero abilities that ignore shared cost/LOS/fog constraints.

## Minimal Hero + camera MVP, not three genres fully shipped
**Technical spike, smallest proof:**
- One Manusian Hero with stable ID and one normal weapon.
- One tiny map, two workers, one enemy dummy and one buildable/repairable defense.
- Overlord camera: select, build/repair, order worker.
- Direct camera: take Hero, move/aim/fire in isometric overhead using same motor/weapon.
- FPS camera: take same Hero, WASD/mouse aim/fire, damage dummy; return to Overlord.
- One simple talent node or one hero ability that is used in at least two perspectives; no separate action-RPG subsystem.
- While in FPS, economy continues and old actor IDs/HP/resource amounts remain authoritative.
- Save/replay basic command stream and show deterministic or bounded-reproducible results on pinned runtime.

**Internal playable MVP:**
- Three *starter presets* with lightweight distinctive action; one hero template, one initial weapon baseline, minimal original pixel assets.
- A **tiny shared graph**: recommended **6–9 selectable talents total** with 2 bridge talents and **at most 1–2 mutually exclusive choices**. All values are planning limits, not promised content.
- One meaningful Engineer→Specialist pivot and Specialist→Commander pivot demonstration.
- Three genuinely working views, with Direct Unit initially **top-down/near-iso**. Full polished TPP follow-cam is deferred unless nearly free.
- One physical resource loop (and eventually all Matter/Volatiles/Energy), one scripted enemy and one win/loss objective.
- A match remains winnable primarily by RTS orders without compulsory action-control skill.

**Deferred:** level cap 100; campaign-wide persistent RPG progression; per-faction 3x hero animation sets; multiplayer ability prediction; hero RPG loot economy; 3D character customization; advanced FPS/Quake traversal; full every-unit possession; multiple concurrent Hero instances in one faction; full hero death/respawn metagame; dozens of interconnected ability combos.

## Shared cameras and control state
- **Overlord** = global RTS camera + strategic selection/order input; selecting Hero does not automatically possess.
- **Direct Unit** = elevated camera follows controlled Hero (or eligible actor); isometric/top-down WASD, aim mouse, fire. TPP as optional camera angle under the SAME `DirectUnitController`, not a fourth game mode.
- **Full FPS** = perspective camera attached to same actor's world pose. No duplicate actor, duplicate projectile or hidden attack rules.
- All modes must honor camera-independent collision, target domains, LOS and inventory.
- Suggested controls: `1` Overlord; `2` Direct; `3` FPS, with key rebinding later. Tab/Escape to exit possession; labels and tutorial are project choices, not finalized keys.
- On camera switch, release old input capture, preserve actor position/velocity/weapon cooldown, no teleportation. On hero death, return to Overlord and show a valid recovery UI; do not trap player in FPS.
- Controller arbitration: possessed Hero manually owned > protected RTS manual command > optional base AI > local doctrine > idle. Other players cannot commandeer a Hero owned by another unless role policies explicitly allow it later.

## Godot vs Recoil implications
**Godot 4**: one 3D world + RTS orthographic Camera3D + actor-follow overhead Camera3D + first-person Camera3D; one actor component with input adapter and weapon system. Best flexibility for a skill graph and UI, but RTS and simulation are custom.
**Recoil**: existing RTS unit-control APIs and `ControlUnit` first-person pathway reduce RTS engineering, but the exact limits of full hero RPG direct-overhead motor and skill-tree UI must be benchmarked before committing. A working FPS camera alone is insufficient to certify per-actor hero abilities or consistent fine control.
**Babylon.js**: similar 3-camera potential with TS-first custom sim, more RTS code than either finalist.
In all engines implement a thin `CameraAdapter`, `HeroProgression`, `UnitControlLease`, `UnifiedActor` and `AbilityResolver` with one authoritative rules engine. Do **not** build custom AAA ability frameworks for MVP.

## Open design questions / tradeoffs
1. Does every human-controlled side always require an alive Hero? Strong recommendation: hero can die and match continues; resurrection requires resources/time.
2. Do all players receive a Hero in multiplayer only, or AI commanders too? For fair skirmish, equalized availability is recommended.
3. Does "choice closes previous choices" mean excludes other FUTURE skills or literally deletes/replaces EXISTING ones? We recommend excluding future alternatives only.
4. Can a Hero freely respec during matches? Recommend no free on-demand reset; possible expensive base return or next match.
5. How much XP originates from the economy compared with combat? Recommend milestone/capped objective XP first.
6. Does Engineer/Commander/Specialist determine initial kit only, or a starting talent that itself can later be refunded?
7. Can a player possess ANY friendly compatible unit or primarily the Hero? Proposed initial MVP: only own Hero; later eligible units via permission.
8. Is the advertised 'third person' shoulder cam essential to MVP, or is top-down direct enough? The latter supports a truthful three-mode MVP (Overlord, Direct, FPS).
9. Do different factions receive identical talent graph nodes or shared graph *structure* with faction-specific implementations? Recommendation for now: a shared abstract graph/roles, faction-specific flavor/counters later.
10. Hero uniqueness: can a single player recruit secondary named champions? Avoid in MVP.
11. Does persistent progression last only one skirmish or across campaign matches? Default recommendation: match-local talents; campaign progression optional later.
12. How do hero-specific upgrades affect RTS-only matches without turning Avatar skill into a mandatory source of power?
13. How do talents and equipment affect a machine Hero, Blergian organism or Aetherian Hunter consistently? Future work; only Manusian proof initially.

## Decision boundary
**Owner-established:** one Hero per human player at start; three initial Engineer/Commander/Specialist playstyle kits; common open evolution with pivots; clear consequences from choices; three camera modes Overlord / Direct Unit (RotMG-like or TPP) / Full FPS.
**Recommended, pending test:** Graph exclusions lock *future* options only; limited talents, one unit state and shared ability system; match-local XP; no free respec; MVP only own Hero possessable, full TPP deferred; all modes usable independent of starting hero.
**NOT approved:** permanent hero death ending game, global shared mind, full FPS RPG alongside all RTS systems, 100-skill tree, unrestricted multi-player hero ownership, 5-faction MVP.

Related:
- [Three Pillars Control Contract](three-pillars-one-world-control-contract.md)
- [Product Principles](product-principles.md)
- [Engine Selection for Possession](../research/engine-selection-rts-possession-2026-10-11.md)
- [Realistic MVP scope](mvp-iso-pixel-rts.md) (create/update separately if absent).
