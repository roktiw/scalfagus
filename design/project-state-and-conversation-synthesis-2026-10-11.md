# Scalfagus — Canonical Project State and Conversation Synthesis

Date: 2026-10-11
Status: **living index of approved decisions, owner directions, design proposals and unresolved engineering choices**.
This consolidates the current conversation and points to earlier detailed records. It is NOT a word-for-word transcript. The game is in **design/research, not implemented**.

## TL;DR: one game, three player experiences, three base civilizations
Scalfagus is an **original** 1990s-feeling isometric pixel-art RTS inspired by Warcraft II, StarCraft I, Z, Dungeon Keeper I, Settlers II, Transport Tycoon Deluxe, SimCity, Factorio, tower defense, Realm of the Mad God, Quake/Enemy Territory and the owner's MTG-as-Code ontology. The nontrivial product proposition is **Simple Surface, Deep Simulation**: automated base logistics and independent specialist units, precise RTS control and real direct unit control coexist on **one authoritative world**, not three games with divergent physics or economies.

**Current canonical faction naming (APPROVED):**

| Stable ID | Short | Mid | Full backronym | MTG working identity |
|---|---|---|---|---|
| `org` / ORG | Organs | Organites | **Organites Reproductive Generalismus** | Jund B/R/G |
| `man` / MAN | Manus | Manusians | **Manusians Augmented Navigators** | Jeskai W/U/R |
| `eth` / ETH | Eters | Etherans | **Etherans Transcendent Hypervisors** | Bant W/U/G |

Backronym letters are deliberate, approved and **verbatim**. Generalismus, Etherans and Manusians are intentional spellings. These expansions are *full faction names*, **not** auto-generated singular species or necessarily one formal government. A polity/state name remains a separate optional concept. The naming levels should be called `short/mid/full` (and machine `id`); never confuse with the already overloaded MIN/MID/MAX match and chassis dimensions. See [canonical naming specification](faction-naming-conventions-2026-10-11.md), [active faction registry](factions.yaml), [approved decisions](decisions.yaml).

## 2026-10-11 — full economy discussion consolidation and open relocation options

This project's complete discussion about **the three separate extraction, transport,
MIN/MID/MAX construction and defense paradigms** is now indexed in
[Economy and Construction Conversation](faction-economy-and-construction-conversation-2026-10-11.md).
It joins previous approved decisions, summarizes early ORG transfer mode/port constraints,
explains MAN one-person bunker versus 3-/5-tile conveyor and outward wall, and records
the deliberate ETH pivot to MID pylon and immediately Nexus-class MAX.

The subsequent question **"can existing buildings relocate, and would universal mobility
undermine expansion?"** is separately preserved in
[Building Relocation Options](building-relocation-design-options-2026-10-11.md) and
[Building Relocation Options YAML](building-relocation-options.yaml).
**DEC-014 is explicitly OPEN / NOT APPROVED.** Existing selective MAN modular mobility and
eligible ETH meditated levitation remain the approved baseline; very slow vascular ORG
building transplantation and ETH high-Energy railgun-beam relocation between nodes remain
candidate experiments. The user's final ETH MAX idea was unfinished; no capability is inferred.

This synthesis is an index only; [decisions.yaml](decisions.yaml) and
[base ecologies](base-ecologies-and-expansion-2026-10-11.md) retain canon precedence.

## Subsequent proposal — DEC-015 phased construction (2026-10-11)

The owner proposed three distinct stage-worker capacity profiles across
0–33%, 33–66%, 66–100% progress:
**ORG 3→2→1 cocoon caretakers**, **MAN 1→2→3 on-site assemblers**,
**ETH 1→3→2 visible NETWORK channelers**.
Their losses differ: ORG neglected cocoon decays, MAN paused worksite
persists and can be salvaged by any faction if exposed/destroyed,
ETH full mandatory-link loss zeroes construction progress but returns
a finite permitted percentage of actual paid materials to their source
Nexus/expansion **through legitimate transfers**. This is an **unbalanced
proposed mechanic**, not a validated equal-strength set. The ORG final
caregiver jumping into the cocoon was an exploratory possible sacrifice,
not an approved worker loss.
See [three-stage construction](construction-incubation-assembly-resonance-2026-10-11.md)
and [machine-readable stages](construction-phases.yaml).
[DEC-015](decisions.yaml) tracks open thresholds, refund, detection and
interruption tuning.

## Latest owner canon — DEC-012/013: base ecology and economic units (2026-10-11)

The authoritative reference is [Three Base Ecologies](base-ecologies-and-expansion-2026-10-11.md) and [base-ecologies.yaml](base-ecologies.yaml). This **supersedes earlier proposed disconnected-ORG-building behavior and ETH MID/MAX economic template roles**.

- **ORG:** the least movable *base*, with narrow living vascular branches physically rooted at the home Nexus; each building buds on a connected vessel and disconnected branches eventually wither. Distant colonies additionally need recurring physical nutrient deliveries from home. Independently thinking MIN/MID/mobile flying MAX transporters still act without hive-mind control. Growth-equipped MIN/MID/MAX bud L1/L2/L3. Flying mother initially uses stop-and-load with one port, later researched moving transfer.
- **MAN:** the most physically modular and movable base; its "Nexus" is a composition of units/modules, not mandatory one command building. Bunkers/conveyors and warehouses move/reconfigure; tracked MID is a 3/5-tile relay/conveyor or **one-soldier bunker**, or an outward sentry wall. Slow land MAX is a warehouse or multi-soldier bunker. SCV-like MIN repairs units and structures. Independent colonies do not require home connection and need not expose a supply path.
- **ETH:** independent MIN gatherer enters **occupied NETWORK construction mode** and projects a strategically visible blue beam to nearest eligible large node while consuming finite actual Energy. **MID is now a stationary cargo relay/storage pylon or time-transformed defensive turret**, retaining cargo but locking handoffs; **MAX is a Nexus-class core node immediately**. Expansion contacts home initially and later only for a blueprint it does not know locally. Some equipped structures may meditate/levitate to reposition.
- Fairness and mechanics for fog-of-war visibility, ORG nourishment recipes / decay grace, ETH blueprint transfer timings, mobility costs and building height remain proposals needing tests.

## 1. Status hierarchy and ownership
### Owner-approved / canon
- Faction IDs and three naming levels as table above. Prior Blergians / Manusians-as-short / Aetherians were superseded; historical design docs retain their original discussion language.
- **Exactly three primary, stored, transported resources:** Matter, Volatiles, Energy. Old Crystals/Gas/Resin data in legacy YAML are migration debt, not extra resources.
- Distinct specialized **independent units**, not mandated hive minds, amorphous super-organism, Akira-like civilization-level blob or free Tyranid-like enemy DNA ingestion. Coordination, networking and specialist biological groups are allowed without loss of unit identity.
- One human player starts with **one Hero**; starting **Engineer / Commander / Specialist** kits map to player fantasies, but do not lock camera or forbid cross-tree skill pivots.
- One **shared, open talent graph** for hero evolution, where choices have real consequences and can exclude other choices. Exact respec interpretation and XP distribution are *not* approved.
- Three real player-facing observation/control modes: **Overlord** (base simulation and RTS orders), **Direct Unit** (Realm of the Mad God-like overhead action, optional eventual TPP), **Full FPS** (Dungeon Keeper I-like first-person control).
- **Minimal literal FPS possession** is in the intended internal playable MVP; Quake/CS/Enemy Territory-grade locomotion, weapon design, TPP polish and online netcode are post-MVP.
- Manual orders remain supreme over bounded non-cheating AI within controller ownership scope. Default base labor is autonomous; optional strategic AI may act only when authorized and budgeted.
- The project is conceptually faction-symmetric in basic legal capabilities: each civilization can build/economize, command, use eligible direct control and pursue early/mid/late wins, but their preferred production, logistics and terrain topologies differ.
- Units should resemble MTG cards in design: unique identifiable roles, finite costs, trade-offs, tactical synergies and guild-like specialization. A "deck" is a useful *compositional analogy*, NOT a required digital collectible-card mechanism.

### Strong owner-favored candidate, NOT fourth playable faction approval
A fourth civilization of **independent artificial machine people** could originate from Terra's human-built robotics, later depart into space, and become distinct from Manus technologically and politically. Aspects: Manus scientific management/observation/modularity, Organite-like self-repair/regeneration and locally autonomous detached components, Eter-like precision Energy systems and sophisticated energy weapons. Aetherian-equivalent Eter technology might have benefited from historical contact with machine navigators/shipbuilders; precise history remains unapproved. Aesthetic influences **Z** (expressive chunky independent robot soldiers) and Stanislaw Lem's **Fables for Robots** (distinct robot persons, societies, inventors and humor). No single omniscient AI supermind or "grey goo."
See [Fourth Machine Civilization Candidate](fourth-civilization-independent-machines-2026-10-11.md).

### Conceptual horizon / exploratory, NOT approved to implement
- Five playable races as a philosophical aspiration rather than arbitrary extras; no settled fifth race and no mandatory five-army MVP. Proposed fifth Worldborn/Environmental civ remains an exploratory source note, not canon.
- All factions evolving from one universal Genesis Seed in a Spore-like tree, full emergent civilization generator and MTG weighted color-system AI lab.
- Complete 63-or-more named template roster, four/five full cultural and army packages, full MIN/MID/MAX world simulation, massive naval/amphibious/asteroid campaigns, realtime local LLM policy, multiplayer shared-faction FPS and hero persistent RPG.
- Any numeric balance sheets not playtested are **hypotheses**, not factual performance measurements.

## 2. Three civilization design theses
**Organs / Organites / ORG** — life as technology. Distinct organisms with biological specialties, personal or local agency and living/growing infrastructure. Jund (Black/Red/Green) describes mortality/reclamation, impulse/experimentation and adaptive life. Specialized biological predators, growth workers, synaptic coordinators, carapace tanks and organic defenses; no forced absorption or one collective mind. Suggested base topology: contiguous biological support routes providing tangible advantages, but disconnected units retain local function.

**Manus / Manusians / MAN** — intelligence designs tools and bodies. Flexible human-origin industrial institutions, observation, logistics, modular factories and dispersed self-supporting colonies. Jeskai (White/Blue/Red) describes institutional order, science, technology and experimentation. Manus includes baseline humans, augmented soldiers, Akira-inspired unstable bioforms, Quake Strogg-inspired cybernetic bodies, drones and independent AI machine citizens **as unit families/tech paths**. Their existence does not automatically justify new playable races; separate machine civilization would require independently functioning political/production/economic topology.

**Eters / Etherans / ETH** — advanced consciousness coupled to living bodies, sophisticated technology and resonance/energy. Bant (White/Blue/Green): continuity/order, knowledge/control and cultivated organic systems. Psionic specialists, resonance architects, seers, and Predator-inspired **individual hunter elites** with ritual/honor/stealth; no requirement that every Eter is spiritually pure, morally good or part of a hive mind. Suggested spatial economy: valuable core, optional resonant satellites and positional control.

See [dimension matrix + RTS precedents](faction-dimensions-and-rts-comparative-notes-2026-10-11.md), [individuality rules](individual-agency-and-composable-civilizations.md), [historical race debate](faction-evolution-discussion-and-decisions-2026-10-11.md).

## 3. Distinguish ontological categories (prevents runaway race count)
Separate:
- **Faction/political controller** and **civilization** vs species/biological lineage.
- Body substrate (organic/cybernetic/mechanical/resonant) vs mind architecture (individual/network/AI/psi).
- **Unit family** vs base combat **archetype** vs size/chassis vs LAND/WATER/AIR movement and legal target domains.
- **Culture or philosophy** (honor, adaptation, reconstruction, independent thought) vs technical technology doctrine (modular assembly, repair, growing infrastructure).
- Product **view/input role** vs Hero starter kit vs actual current hero learned talents vs match preset.
A fourth playable civilization must demonstrably add a new *economic spatial decision loop and counterplay*, not merely a new costume, robot, hunter or biomutant.

Owner's "as hard as from 3D to 4D/5D" comparison usefully summarizes the ontology challenge: independent axes produce combinatorial diversity, but do not imply every cross-product deserves a full playable race.

## 4. Three play pillars and ONE simulated world
**Architect / SIM (Overlord):** build and place factories, resource collectors, stores, routes, walls, tower-defense structures, traps; design efficient workflows; automated workforce performs routine logistics. Influences: TTD, SimCity, Settlers II, Factorio, Dungeon Keeper and tower defense.

**Commander / RTS (Overlord, sometimes Direct Unit):** train, select, scout, position and micro units, exploit terrain and resources, give orders, command combined arms, and optionally steer one specific actor from above as a simple action RPG like Realm of the Mad God.

**Avatar / possession (Direct Unit or Full FPS):** own Hero or eligible unit is directly controlled in real time; move/aim/fire and perhaps future vehicle controls. FPS is an actual camera attached to a real actor in the same world. Later extend to full Quake/Counter-Strike/Enemy Territory dynamics; TPP optional. The game must remain playable without possession.

Observation modes are **Overlord / Direct Unit / FPS**. Do not describe Architect/Commander/Specialist as fixed mutually exclusive player classes or three independently implemented games.

## 5. Every player gets one evolving Hero
- **Engineer** starter fantasy: construction, repair, logistics, defenses and traps.
- **Commander** starter fantasy: rally, recon, tactical unit direction and army organization.
- **Specialist** starter fantasy: local precision, FPS/Direct combat, scouting and disruption.
- All three are **starter presets in ONE common unlock graph**. Example Engineer -> Combat Engineer -> Specialist, or Specialist -> Forward Observer -> Commander. Picks may exclude mutually incompatible *future* picks. Exact wording of owner "future choices close previous choices" leaves possible interpretation; do not silently erase invested abilities.
- Cross-mode use: the Engineer can fight FPS, the Specialist can give RTS orders, and Commander can repair if equipment/talents permit.
- Hero is an existing actor with one stable ID across camera changes. The avatar must share collision, LOS, damage, cooldown, inventory and legal targeting with normal units.
- Hero death must not automatically end an otherwise playable RTS match without explicit approval; recovery rules to be designed.
- Proposed internal MVP graph is *small* (~6–9 talents) and shows 1–2 meaningful cross-specialization pivots, not separate full RPGs.
See [hero graph](hero-progressions-and-three-cameras-2026-10-11.md), [control contract](three-pillars-one-world-control-contract.md).

## 6. Engine selection: unresolved, benchmark Godot vs Recoil
Candidate 1 **Godot 4**: one actual 3D collision/terrain world, orthographic pseudo-isometric pixel-art RTS view, overhead following camera and literal FPS camera, one entity/control authority, custom RTS UI/pathfinding/economy; manageable code tooling. Candidate 2 **Recoil**: strong existing RTS functionality, documented `ControlUnit` first-person unit control, but unproven custom top-down Direct mode, hero skills, pixel art, licensing/toolchain tradeoffs. **Babylon.js** TS/browser-first third choice; OpenRA primarily 2D RTS, 3D FPS integration would be disproportionate. No bench results yet.
- Need an identical 32x32 or 48x48 3D world demo across finalists: one wall, elevation, base, 2-3 actors, worker transport and attack.
- Test Overlord -> Direct Unit -> FPS -> Overlord on **same entity_id**, same damage and world state.
- Verify hero skills share exact costs/cooldowns and observer/input switches do not duplicate actors.
- Test headless repeatable scenarios, original pixel art in near/far camera, pathfinding/LOS, macOS packaging, performance, agent workflow and licenses.
See [engine research](../research/engine-selection-rts-possession-2026-10-11.md). Older [research 357](../research/engine-selection-357.md) still says possession post-MVP and should be treated as superseded **for that requirement**.

## 7. Economy, unit model and production scope
- Three fungible primary *types* of physically stored/transferred resource: **Matter, Volatiles, Energy**. No extra mandatory mana/fuel/biomass currencies. Faction transformations are bounded by matter/energy inventory, time, throughput and vulnerability.
- Seven unit **archetypes**: Worker, Fighter, Shooter, Artillery, Tank, Flyer, Specialist. Physical **chassis_scale MIN/MID/MAX** is distinct from **match_scale MIN/MID/MAX**, and both differ from technological advancement. Flyer describes a job/role, not universal aerial attack ability.
- Separate `movement_domains`, `melee_targets`, `ranged_targets` in LAND/WATER/AIR; movement permission never implies weapon targeting or detection.
- One commander/hero per player is an actor with a Hero marker and talents, **not an eighth mandatory basic unit archetype**.
- AI does routine harvesting/redeployment and operates under same fog/resources/command validator. No free AI spawns; agents/LLMs may suggest strategic commands later only through bounded validated API.
- Logistics aims for real visible transported goods, but no forced micromanagement/complete Factorio or Transport Tycoon systems for early build.
- Legacy economy/resources/units yaml may use historical Crystals/Gas/Resin concepts; identify and migrate separately, do not claim runtime schema completed.
See [unit roles and domains](unit-domains-and-archetypes.md), [working balance ideas](resource-balance.md), [MVP contract](mvp-iso-pixel-rts.md).

## 8. MVP, technical prototype, expansions
**Proof-of-engine spike (earliest):** Manus hero, worker delivery, enemy dummy and building; 3 camera modes + one ability; stable actor and LOS; pixel-art visual feasibility.
**Playable vertical slice:** one small original map, ~3 ordinary unit types, one hero, functional autonomous harvest/build/attack/tower or trap, one simple objective and keyboard/mouse switching.
**Internal playable MVP:** one **Manus** faction (mirrored scripted opponent), meaningful SIM/Commander/Avatar loops, small open Hero skill graph, Matter/Volatiles/Energy economy and finite transport, modest AI, direct action and truly FPS possession. The seven archetypes are long-term roster taxonomy; avoid seven wholly unique expensive productions if proof needs fewer.
**3-faction alpha:** Organs, Manus, Eters differentiated by production topology; ~21 MIN templates if needed, balanced via tested matchups.
**Later:** candidate fourth independent machines, possibly fifth foundational civilization, broader MIN/MID/MAX, full FPS/TPP movement, multiplayer, sophisticated research/terraform and optional LLM sandbox. No timelines promised.
See [MVP](mvp-iso-pixel-rts.md), [roadmap](recommendations-and-roadmap-2026-10.md).

## 9. External comparisons and philosophy sources
- **MTG-as-Code (owner research)**: https://github.com/roktiw/research-/blob/main/mtgasacode/README.md ; https://github.com/roktiw/research-/blob/main/inbox/2026-10-03-mtg-as-code-math-geometry-riemann.md . Classic colors plus speculative Yellow as 'sustaining/energy'; do not assume a literal additional game resource or five mandatory factions.
- **RTS faction comparisons**: Warcraft III four (living Ancients, Undead Blight), AoM originally four pantheons, Supreme Commander Forged Alliance four, Dawn of War Soulstorm nine, BFME II six, AoE II many lighter-asymmetry civilizations. Larger rosters do **not** establish measured tournament balance by themselves.
- **D.O.R.F.**: three developing factions, plus a warning from its developers about excessive logistic chores and a modular factory-attachment unit approach. It is an inspiration/ongoing development, not proven completed balanced production.
- **Early race research/conversation atlas**: [comparative atlas](../research/rts-factions-podcast-and-comparative-atlas-2026-10-11.md) and [conversation log](../research/conversation-log-rts-races-2026-10-11.md).
- **Further five-race exploration**: [five-civilizations notes](five-civilizations-and-balance-exploration-2026-10-11.md). These include a speculative 'Worldborn' ecological fifth concept; not approved.

## 10. Open decision queue (do NOT silently fill in)
1. Player hero death/revival, match-local versus campaign progression, scoring and respec.
2. Does a talent exclude only FUTURE alternatives or revoke earlier mastered skills? Prefer former for UX; get approval.
3. Can non-hero units be possessed in initial release? MVP recommendation Hero-first.
4. Is TPP in Direct Unit optional or a fully supported sub-camera in MVP? Currently optional.
5. Literal pixel-perfect 2:1 isometry and 3D first-person rendering art pipeline: benchmark.
6. Select actual engine after Godot-vs-Recoil proof, benchmark performance and distribution.
7. Standard baseline control flow for Architect-only, Commander-only and all-in-one players; prove no perspective mandatory for victory.
8. How do Organs maintain independent biological minds while gaining collective tactical support? Set locality, network failure modes.
9. Eters' "energy/psionics" versus technologically advanced Manus/Machine energy weapons: ensure readable different behavior.
10. Fourth independent Machine People: does repair/remanufacture + identity/repair guild network change full gameplay loop enough to warrant playable faction?
11. A fifth genuinely independent *civilization-scale* economy/territory doctrine: no new species solely for Akira, Strogg, Predator, robots or another body style.
12. Production exact art budget, hit-testing, interface hotkeys and first level/map scenario.
13. IP/naming clearance for current new canon, source licensing and wholly original race/unit silhouette designs.
14. Legacy YAML migration and later game data schema validation, link and reference audit.

## 11. Principle of documentation precedence
- **Approved gameplay/names:** [decisions.yaml](decisions.yaml), [faction naming canon](faction-naming-conventions-2026-10-11.md), [factions.yaml](factions.yaml).
- **Mechanics contracts:** [product principles](product-principles.md), [hero and views](hero-progressions-and-three-cameras-2026-10-11.md), [three-pillar input contract](three-pillars-one-world-control-contract.md), [MVP](mvp-iso-pixel-rts.md).
- **Historical exploration:** dated race analyses and previous proposals can use then-current names, but are superseded when contradicted by the above.
- This synthesis is a **navigation index**, not a new source of truth overruling owner-approved detailed files.

No claim of a playable build, passed tests, performance benchmark, cleared trademarks or committed schedule is made.
