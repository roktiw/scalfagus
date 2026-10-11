# Scalfagus — Faction Evolution Debate, Current Conclusions and Research Agenda

Date: 2026-10-11
Status: **discussion summary and working recommendations; NOT a decision to build five playable races**.
Repository language: English.

## 0. Why this document exists
This document consolidates the discussion following the [Consolidated Design Bible](scalfagus-design-bible-2026-10-11.md) and the earlier [Faction Taxonomy](faction-taxonomy-and-discussion-2026-10-11.md). The question is not merely "how to invent two more races?" but **what distinctions actually warrant a playable RTS faction, rather than a unit, technology branch, cultural doctrine, or worldbuilding concept**.

The owner has challenged several earlier five-race proposals. Explicit correction: **do not mistake an interesting unit family for a civilization**. The current working preference is to thoroughly define three foundational factions before attempting expansion.

## 1. Non-negotiable game identity and MVP
- **Simple Surface, Deep Simulation**: strong internal interaction rules, 1990s Warcraft II / Dungeon Keeper I / Settlers II-readable, isometric pixel-art RTS. Beginner can understand and enjoy gameplay without mastering systems; expert can master emergent depth.
- Three primary resource types remain **Matter, Volatiles, Energy**, all storable/transportable/spendable; no automatic fourth 'biomass' currency. Biomass may be world material/process/status and faction-specific logistics, to be specified.
- Seven base archetypes: Worker, Fighter, Shooter, Artillery, Tank (combat role, not chassis size), Flyer (role, not exclusive movement domain), Specialist; three physical chassis sizes MIN/MID/MAX independently of match-scale MIN/MID/MAX.
- LAND/WATER/AIR are independent movement and target domains; unit sizes, tech level and role must remain separate.
- Default intelligent autonomous base and workers with explicit player intervention and fully manual option. Faction/agent AI never gets free resources or unseen map information. LLM lab optional later.
- **Internal MVP**: **one playable Manusian roster**, one small authored isometric map, a few useful units and production buildings, functional three-resource economy, sensible base AI/manual overrides, enemy bot, fog, classic RTS controls and **very small true possession of one unit** (Dungeon Keeper-style direct control). Bigger Doom/Quake Champions-like FPS, broad multiplayer, five factions and complete 63-unit catalog are out of MVP.
- Intended early competitive MIN 1v1 duration approximately 25–40 minutes, tested rather than enforced.
- Engine Godot/Recoil/Babylon comparison remains unresolved; possession proof must be part of engine-selection spike.

## 2. Base three playable civilizations
### Blergians — living predatory biology
Core identity: genetically specialized living organisms, high pressure, breeding, mutations, swarm tactics and organic/biomass-connected bases. Inspirations: Zerg, Alien/Xenomorph and H. R. Giger, some Warcraft Orc aggression. Owner's chosen MTG identity is **Jund (Black/Red/Green)**. **Important correction:** the owner does **not** want the central Tyranid/Genestealer-style mechanic of assimilating others' genetic capabilities. Eating biomass as material is not the same as automatically copying enemy DNA. Mutation may rely on their own biology and deliberate development. Biological worker/caster/hunter/tank are internal families, not separate races.

### Manusians — industrial humanity with extremely broad internal spectrum
Core identity: humans, colonies, transport, factories, flexible tactics, manual/automated tools and distributed outposts. Classic Terran, Colonial Marines, industrial and 40k-esque imagery; existing MTG identity **Jeskai (White/Blue/Red)**.
**Owner's explicit clarification:** Akira-like body mutations, Fleshborn/biomutants, Quake II/IV Strogg-style industrial cybernetic horror, Borg-like assimilation concepts, pure AI, robotics, autonomous machines and transhuman technology are **unit families/technological doctrines inside Manusians**, NOT automatically separate races. Their diversity is a positive feature of this civilization. The label 'Strogg' is an external inspirational comparison and should not become a copied game property; Star Trek Borg is a distinct franchise.
Potential internal families: baseline people/infantry, powered armor, biotech experiments, cyborg/augmented troops, servitor-like workers, drones/robots, independent synthetic intelligences and automated production systems. Their gameplay can evolve toward biological transformation OR full robotic automation while the civilization remains Manusian.

### Aetherians — luminous psionic/biological-technological civilization
Core identity: highly advanced living beings, consciousness, energy, resonance, order, spiritualism, organic-tech symbiosis, protective and reversible costly transformations. Inspired by Protoss, parts of Xel'Naga lore, mystical technology, Aeldari-like psionics. Existing MTG identity **Bant (White/Blue/Green)**.
**Owner's explicit clarification:** Predator-style hunters are better understood as an **elite Aetherian hunter/unit family** or possibly an unusually intelligent hive specialist than as an automatically fourth race. Predator's aggressiveness, material hunting tools and ritual honor need not define all Aetherians; honor is cultural and doctrinal, not material substrate.
Possible families: hunters/trackers, psionic warrior elites, resonant engineers, projecting energy constructs, cloaked recon units, highly evolved advanced beings. Do not falsely treat Aetherians as necessarily literally pure energy or morally good.

## 3. Why previous 3+2 models were rejected / demoted
The discussion tried at least three alternative expansions:
1. **Linear evolutionary spectrum**: Blergians / Akira-Strogg Fleshborn / Manusians / pure AI Machinids / Aetherians.
2. **Five combat fantasies**: Blergians / industrial biomech Ironbrood / Manusians / honor-hunting Predator-like Varkhans / Aetherians.
3. **Three vertices plus two combinations**: Blergian–Manusian biotech hybrid and Manusian–Aetherian synthetic superintelligence.
Working names Fleshborn, Ironbrood, Machinids, Noemids, Varkhans, Primordials and Synthians were **suggestions only**, not approved new lore, playable species or canonical taxonomy.

The owner's central objection is sound: every proposed fourth/fifth faction can plausibly be a **unit family within one of the three existing factions**. If a hypothetical new race differs only by 'more cybernetics', 'a hunter caste', 'more AI' or 'biological contamination', that is insufficient.

StarCraft similarity is not solved by adding two races. Different production rules, physical logistics, terrain, autonomous ecology, direct possession, silhouettes and game loops are stronger sources of originality.

## 4. MTG-as-Code findings from owner's research repository
Source: https://github.com/roktiw/research-/blob/main/mtgasacode/README.md
Source: https://github.com/roktiw/research-/blob/main/mtg-color-architecture/README.md
Source: https://github.com/roktiw/research-/blob/main/inbox/2026-10-03-mtg-as-code-math-geometry-riemann.md

The owner has an independent research vocabulary:
- **White** = governance, order, rules, preservation.
- **Blue** = knowledge, observation, model, control, learning.
- **Black** = sacrifice, lifecycle end, recycling, pragmatic death.
- **Red** = speed, impulse, experimentation, creative chaos.
- **Green** = organic adaptation, emergence, evolution, healing.
- **Yellow** (*new speculative color*) = energy, charge, sustaining, enlivening, conduction, usable resource transfer.
- Additional speculative color-ontology concepts: Orange (Red + Yellow), Violet (Red + Blue), Brown (desaturated material mixture), and white/black as boundary/meta-colors. Proposed sequence White -> Yellow -> Red -> Orange -> Green -> Blue -> Violet -> Brown -> Black is **an invented ontological ordering, NOT physical wavelength ordering or official MTG**.
- `colorless` as pre-assigned existence/form and `artifact` as made form is an interpretative abstraction; colored artifacts really do exist in MTG.
- Proposed mono/duo/tri identities for StarCraft analogies: Zerg Green -> Golgari (Black/Green) -> Jund (Black/Red/Green); Terran Blue -> Izzet (Blue/Red) -> Jeskai (White/Blue/Red); Protoss White -> Azorius (White/Blue) -> Bant (White/Blue/Green). These are designer mappings, not Wizards canon.
- Esper (White/Blue/Black) in the owner's framework means a reproducible system that observes, learns, deliberately terminates obsolete instances and recreates them. This could inspire synthetic units or Manusian AI doctrine **without demanding a new independent race**.
- Color philosophy is for civilization values and action mechanics; avoid turning it into nine new physical currencies or forcing one color = one biological race.

## 5. The classification problem: what is a race, what is not?
Keep these independent:
- **Biological species/lineage**: genetic inheritance, reproduction, substrate.
- **Civilization**: technological repertoire, social and economic organization.
- **Faction/army**: current political controller in a match and its objectives.
- **Unit family**: recognizable biomechanical form/functions (cyborg, robot, hunter, mutated infantry).
- **Technology doctrine**: route of specialization within a civilization.
- **Culture/values**: honor, individualism, predation, transcendence, order.
- **Intelligence architecture**: individual mind, hive, distributed AI, psionic network.
- **Embodiment/substrate**: organic/augmented/mechanical/resonant; combinations allowed.
- **Production/logistics**: spawning, assembly, factory, modular transfer, resonance manifestation, cargo systems.
- **Terrain and territory ecology**: biology network, independent colonies, core+sats, adaptive terrain, infrastructure.
- **Control/possession embodiment**: how one chosen unit feels to directly control; this is an important differentiator of *units*, not automatic evidence for separate factions.

**Test for a legitimate fourth/fifth RTS faction:**
1. Does it have a new, clearly communicable civilization-level production/economy loop?
2. Does it require a new topology of base/territory/infrastructure (not only skins and stats)?
3. Does it produce a recognizably different decision pattern and vulnerability/counterplay?
4. Can the owner explain its distinctive identity within ~30 seconds?
5. Can it be implemented without splitting the shared engine or adding resource currencies?
6. Can it be played in a MIN RTS match without excessive hidden complexity?
7. Does it remain different if advanced cyborgs, hunters and AI drones are allowed in the original three?
If the final answer is no, classify it as a unit family, technology doctrine, minor culture, neutral world-system, scenario or evolving sub-faction rather than playable race.

## 6. Three competing future systems (not final choices)
- **Five authored starting races:** readable but expands production burden and balancing: 7 roles x 3 chassis x 5 = 105 design templates; 10 cross-race unordered matchups compared to 3 for three races.
- **Shared Genesis Seed:** all start from common seed, evolve into organic, industrial, synthetic or resonant civilization as in Spore; strong open-ended/campaign design but delayed RTS identity, tech snowball, reconnaissance difficulty and economic complexity. Potential MAX or campaign experiment, **not MVP promise**.
- **Three authored starts + philosophical tech vectors:** Blergian/Manusian/Aetherian at spawn, tech specialization and selective hybridization; better for MIN clarity while retaining evolution in MID/MAX. **Recommended experiment**, not locked rules. Five *vectors* or *doctrines* need not equal five playable races.

The owner's new conclusion leans even more strongly toward retaining exactly three playable baseline civilizations while expressing Fleshborn, Strogg, robotic AI, Akira-style mutations and Predator-like hunting as **intra-civilization units and branching tech**.

## 7. Distinctive thematic axes needing explicit design
- Cellular biomass/life/organism/ecological network (not automatically DNA theft).
- Spirituality/psionics/consciousness/resonance/energy (do not equate technical energy resource with supernatural 'good').
- Intelligence, reconnaissance, perception, knowledge, industrial logistics.
- Technology beyond human intellect: AI, robotization, automation, synthetic minds, self-design, replacement of physical bodies.
- Culture, honor, cooperation, domination, individual versus swarm agency.
- Reproduction, manufacturing, transformation, mortality, identity persistence.
- Territory, infrastructure and the relationship between a parent/core base and colonies.
- Biological/mechanical/resonant embodiment and corresponding gameplay/counterplay.
These axes may vary *within* each base faction and intersect with primary MTG triads, optional fourth/fifth 'splashes' and experimental new Yellow.

## 8. References and comparison candidates
Warcraft III: four asymmetrical factions (Humans, Orcs, Night Elves, Undead); owner questions whether Night Elves/Undead feel sufficiently distinct, which should motivate a mechanical rather than mere lore comparison.
Beyond three factions: Age of Empires II (many civilizations, mostly shared unit systems), Age of Mythology (distinct pantheons/civilizations), Command & Conquer: Generals / Zero Hour (three primary sides with subfactions), Rise of Nations (many nations with shared core), Warlords Battlecry III (many fantasy races), Dawn of War: Dark Crusade / Soulstorm (numerous strongly differentiated 40k armies), Supreme Commander: Forged Alliance (four civilizations), C&C 3 Kane's Wrath (three cores + variants), Battle for Middle-earth II (six factions), Star Wars: Empire at War: Forces of Corruption (three factions), Total Annihilation mods and other large-roster RTS.
**D.O.R.F.** is a modern retro-RTS inspiration, not automatically evidence of a shipped, balanced competitive title. Its actual playable faction roster, production status and mechanics should be verified with current primary project sources before claims.

## 9. Practical next steps
1. Keep approved Jund/Jeskai/Bant mapping, but give each civilization a **cross-axis profile** for intelligence, substrate, values, energy doctrine, logistics, territory, transformation, production and control.
2. Design a genuine **Manusian family graph**: regular humans -> bio-mutants/Akira-like; humans -> industrial biomech/Strogg-like; humans -> drones/synthetic AI. These branches need clear resource costs and viable counterplay, not automatic separate political factions.
3. Design Blergian castes incl. intelligent hunters without automatic Tyranid DNA absorption, and Aetherian hunter elites without converting the whole civilization into Predator.
4. Define a **signature world mechanic for each faction**: Blergian biomass network; Manusian modular distributed logistics; Aetherian resonance-based core/satellite network.
5. Write a 'different faction' rubric and test whether any fourth/fifth candidate clears it after the above family expansions.
6. Keep MVP one faction, one map and tiny possession; work toward 3 faction MIN before considering additional entire civilizations.
7. Run evidence-based comparison of >3-faction RTS and D.O.R.F. separately; do not confuse faction *count* with actual asymmetry or competitive balance.

## 10. Unresolved questions
Q1. Are Blergians truly a distributed hive mind, or independently intelligent organisms communicating via biology?
Q2. What production distinctions actually make Manusian cybermutants, cyborgs, synthetic AI and conventional troops economically different?
Q3. Is the Aetherian substrate organic, partly synthetic or field/energy based, and how does 'spirituality' manifest as an actionable mechanic?
Q4. Can a Manusian build AI machines without becoming a new faction, and what non-cheating limits keep autonomous AI balanced?
Q5. Is advanced self-replicating AI permitted as a specialization for all races, or Manusian-only?
Q6. Can a Blergian predator have honor, or Aetherian elite be ruthless, without erasing identities? Strong recommendation: yes.
Q7. Is 'biomass' a terrain condition, inventory cargo class, conversion process, or all three? Avoid a fourth primary resource.
Q8. What is the irreversible cost to Blergian mutation, and can strategic AI explain/review it?
Q9. What remains uniquely Aetherian after Manusian robotics/AI become advanced?
Q10. If a fourth/fifth race is proposed, what **new world-scale economic topology** must it bring?
Q11. How much evolutionary tech branching fits a 25–40 min MIN match before it becomes a separate Spore-like campaign?
Q12. Which mechanics are visibly present to the beginner, and which exist only as master/engineer disclosure?
Q13. Which RTS comparisons genuinely demonstrate balanced faction diversity rather than common-roster national bonuses?
Q14. How to avoid IP lookalikes of StarCraft, Quake, Alien, Predator and Warhammer while preserving broad inspiration?

## 11. Status and ownership
- **Explicit owner direction:** keep only three foundational civilizations for now; Strogg, Akira and pure AI as Manusian unit families/tech routes, hunters predominantly Aetherian or capable hive units; avoid Tyranid-like enemy DNA assimilation for Blergians.
- **Working proposal:** compositional cross-axis faction ontology and more rigorous fourth-race admission test.
- **Deferred:** five independently playable races, universal Genesis evolution system, unrestricted faction builder, complete FPS and full MIN/MID/MAX ecosystem.
- **No game implementation represented.** This is a design/history note, not a balance-verified specification. Do not silently overwrite `design/factions.yaml` or approved decisions based on explorations here.
