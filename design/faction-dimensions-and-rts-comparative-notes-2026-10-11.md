# Scalfagus — Three Civilizations, Cross-Cutting Dimensions and Multi-Faction RTS Lessons

Date: 2026-10-11
Status: **proposed comparative design and research notes, not approved mechanics or measured balance**.
Companion: [Faction Evolution Discussion](faction-evolution-discussion-and-decisions-2026-10-11.md).

## 1. Recommendation
**Keep three foundational playable civilizations** until their economic, spatial and strategic asymmetry is proven. Embed Akira-like biomorphs, Strogg-like cyberforms, independent machine AI and robotics **within Manusian unit families**, and Predator-like hunters **within Aetherian elite units** or intelligent Blergian subcastes. Other cultures, neutral ecosystems and independent political subfactions need not become additional RTS race packages.

Do not confuse race count with conceptual depth: Warcraft III, Dawn of War, Age of Mythology and Forged Alliance demonstrate different degrees of asymmetry and reuse. Our unique differentiators are deep-but-legible logistics, autonomous base, meaningful terrain and RTS-to-unit possession.

## 2. Canonical MTG-as-Code mapping from owner's research
| Civilization | Mono | Duo | Tri | High-level meaning |
|---|---|---|---|---|
| Blergians | Green (G) | Golgari (B/G) | Jund (B/R/G) | Organic growth, mortality/reclamation, impulsive predation/mutation |
| Manusians | Blue (U) | Izzet (U/R) | Jeskai (W/U/R) | Analysis, invention and experimentation under flexible institutions |
| Aetherians | White (W) | Azorius (W/U) | Bant (W/U/G) | Continuity/order, knowledge, and cultivated living harmony |

This mapping is a working analytical analogy, not canonical MTG lore or an officially licensed use. Pairwise intersections: Blergians–Manusians share Red, Blergians–Aetherians share Green, Manusians–Aetherians share White + Blue. Their union covers all original five MTG colors.

Owner's experimental new **Yellow** means energy charge, vitality, sustaining and transmission (not an extra game-resource currency). Orange, Violet and Brown are explicitly unfinalized proposed ontological semantics, not official Garfield colors. They should remain a metaphor or game-design tagging vocabulary; never introduce nine economic currencies.

Primary user research:
- https://github.com/roktiw/research-/blob/main/mtgasacode/README.md
- https://github.com/roktiw/research-/blob/main/mtg-color-architecture/README.md
- https://github.com/roktiw/research-/blob/main/inbox/2026-10-03-mtg-as-code-math-geometry-riemann.md

## 3. Shared comparison matrix: proposed realizations, not faction-exclusive capabilities
| Dimension | Blergians (Jund) | Manusians (Jeskai) | Aetherians (Bant) |
|---|---|---|---|
| Ontological question | What can life do when bodies become technology? | What can intelligence do through tools and designed bodies? | What can consciousness do through matter/field resonance? |
| Physical substrate | Cells, chitin, fluids, organs, secretions | Baseline humans, armor, tools, machinery, cybernetics, synths | Advanced biological bodies, resonant materials and physical constructs |
| Cell/biomass theme | Genome and growth, metabolic infrastructure, breeding | Biomedical research, cloning, experimental biomorphs (Akira-like) | Deliberate cultivation, symbiotic organisms, controlled bio-resonance |
| Learning/perception | Evolutionary specialization, sensory organs, pheromone or local networks, optional intelligent castes | Scientific method, sensors, telemetry, scouting, machine learning and operators | Psionic detection and sophisticated perception, field-based sensing |
| Intelligence locus | Could mix individual cognition and network/hive coordination | Human minds, institutions, algorithms, independent AI citizens | Individual skilled minds with optional resonant collectives |
| Cultural ethics | Predation, survival, commitment, continuity; not inherently evil | Freedom, military discipline, exploration, experimentation; not inherently virtuous | Contemplation, ritual, honor for some elite hunters, order; not automatically benevolent |
| Manufacturing | Growth and biological structures, organic molds | Factories, building modules, vehicles, biomorph labs, robots, cybernetics | Precision field engineering, cultivated architecture and expensive resonant assembly |
| Matter / Volatiles / Energy | Organic metabolism / enzymes / bioenergy stores | Industrial raw material / chemistry-fuels / cartridges-generators | Resonant materials / synthesis / field-energy stores |
| Economy and base topology | Connected biomass clusters, vulnerable network interruption | Distributed independent colonies, route planning, physical module/cargo supply | Fortified core with satellite resonance connections |
| Technology beyond intelligence | Emergent distributed bio-cognition, design-by-mutation within own lineage | Autonomous drones, independent synthetic intellect, embodied AI, replacement bodies | Advanced consciousness projection, fields, memory/resonance technologies |
| Mortality and replacement | Individual dies; biological lineage and inherited adaptation persists | Tool can be replaced, knowledge and institutions can persist; synth identity may survive chassis loss if implemented | Potential continuity through costly resonant structures, no free resurrection by default |
| Transform philosophy | Irreversible committed mutation | Reconfigurable physical equipment, cyborg and robotic forms | Reversible but costly/time-consuming ascension |
| Combat | Continuous pressure, skirmish, attrition, specialized organisms | Recon, logistics, combined arms, equipment swaps, precision and fortification | Elite positional control, psionic fields, shields, hunters, delayed power |
| Signature visible base action | Grow/extend biological network | Build distributed workshop / relay or module | Stabilize/extend resonant satellite |
| Possession feel (later except basic Manusian MVP) | Biological traversal, close-combat senses, pounce | Conventional shooter, cyborg tank, remote drone | Honor hunter, psionic abilities, sensor modes |
| Counters and failure modes | Network cuts, overcommitment, specialist vulnerability | Supply disruption, isolated outposts, module mismatch | Core/satellite dependence, slow costly recovery |

IMPORTANT: Sharing capability labels does not mean sharing costs, access or implementation. All three need meaningful anti-air, anti-siege, amphibious and scout counters in full game. None gets mandatory unique resource currencies.

## 4. Suggested unit-family graph (do not equate with playable races)
### Blergians
- Brood / Worker organisms; Predator hunters; Carapace/Shield brutes; Synaptic leadership castes; Mutators; living infrastructure.
- A clever hunter can be a high-intelligence Blergian organism without making the whole faction Predator.
- **No automatic enemy DNA theft / Tyranid-like assimilation** as central faction identity. Eating biomass is not equivalent to gaining another species' genetic capabilities.

### Manusians
- Baseline Humans / Colonial Marines; Industrial machines / tanks / transports; Augmented armor; Biomorphs inspired by Akira; Industrial cyberforms inspired by Quake Strogg; Autonomous robots; Post-human synthetic minds.
- All remain Manusian by civilization origin, tech infrastructure and political ownership even if some are fully synthetic individuals; independence could form future political *factions*.
- Research progression may cross from biological augmentation through cybernetics into embodied autonomous AI. **Do not force this as an inevitable linear evolution path**: branching alternatives and counterplay are preferable.
- Honor can be part of a Manusian doctrine, AI can have individual agency, and a person can choose to remain fully human.

### Aetherians
- Psionic Templars; Predator-flavored elite Hunters; Seers and sensory experts; Resonant field engineers; Architects/core maintainers; costly Ascendants and projected units.
- Aetherian spirituality need not mean good/evil or literally pure energy. Possession hunter combat need not impose Predator culture on all Aetherians.

Crosscutting archetypes remain the approved seven: Worker, Fighter, Shooter, Artillery, Tank, Flyer, Specialist. Unit family/form is distinct from chassis MIN/MID/MAX, movement_domains, melee_targets, ranged_targets, and technology level. Avoid multiplying the 63 drafted unit templates into all family x roles x chassis combinations as actual shipping obligations.

## 5. Design admission test for a fourth/fifth playable faction
A proposed faction passes only if it:
1. Changes the *full economy loop*: acquisition/processing/production/transport decisions, not simply unit appearance.
2. Changes territory and base geography: what must be held, built, interconnected, defended and attacked.
3. Has an original military decision pattern with fair counters across land/air/water when supported.
4. Clearly differs from Manusian robot/cyber/biomorph branches, Blergian predatory organisms and Aetherian hunters/psionics.
5. Can be explained in one short sentence with one immediately observable mechanic.
6. Can use the common deterministic engine with Matter, Volatiles, Energy and standard command/visibility validators.
7. Has measurable match tests and a minimum viable roster/tech tree.
Otherwise represent it as a **unit family, doctrine, tech branch, culture, political subfaction, neutral world system or campaign event**.

## 6. RTS comparisons: sourced examples, not proofs of perfect balance
| Game | Playable major sides in specified version | What is shared and what differs | Lesson for Scalfagus |
|---|---:|---|---|
| Warcraft III | 4 (Human, Orc, Undead, Night Elf) | Four major races; Night Elves use mobile Ancients, Wisps, Moon Wells; Undead spread Blight and summon buildings | 'Seems like an Elf subgroup' in lore may conceal fundamental economic/topological asymmetry. |
| Age of Mythology: Retold at original 2024 launch | 4 (Greek, Egyptian, Norse, Atlantean); additional pantheons in later releases | Shared RTS loop, pantheon-specific gods, favor acquisition, mythology units and tech branches | Asymmetry in progression and production is more valuable than solely visuals. |
| Supreme Commander: Forged Alliance / Forged Alliance Forever | 4 (UEF, Cybran, Aeon, Seraphim) | Shared continuous economy and tech strata, major differentiation in equipment and doctrine; actively maintained by balance community | Reusing a large shared core enables more factions but balance never 'finishes'. |
| Warhammer 40,000: Dawn of War — Soulstorm | 9 armies | Highly distinct lore, visuals and unit rosters with considerable shared RTS controls | Large rosters are feasible over expansions; do not infer tournament parity from faction count. |
| Battle for Middle-earth II | 6 | Men, Elves, Dwarves, Goblins, Mordor, Isengard; shared structural game systems, distinct army strengths and heroes | Many factions can share production rules and have different tactical profiles; unique races need not be ontologically fundamental. |
| Warlords Battlecry: The Protectors of Etheria (standalone community project, NOT original WBC III) | Claims 16 races / 50+ factions | Broad data-driven variation, heroes and tactics; creator claims asymmetry | Huge faction count can serve sandbox/campaign breadth; not automatic proof of tight competitive balance. |
| Age of Empires II | Many (number depends on edition/expansions) | Mostly shared economic/unit skeleton with faction bonuses and unique units | A high civilization count can be feasible when asymmetry is comparatively lighter. |
| D.O.R.F. RTS, **unreleased as of 2026-10-11** | **3** officially planned | Union of Imperial States, Warband Tribes, The Collective; classic pixel-isometric, supply chains, territory, specialized units and recently more modular factory Annexes | Relevant retro-RTS example is deliberately three factions. Its developers' public logistics simplification is a caution against over-engineered mandatory systems. |

### Primary and close-to-primary evidence
- Warcraft III Night Elves: https://classic.battle.net/war3/nightelf/ ; Undead: https://classic.battle.net/war3/undead/basics.shtml
- Age of Mythology four original launch pantheons: https://www.ageofempires.com/news/age-of-mythology-retold-coming-september-4th-pre-order-now/ ; current catalog: https://www.ageofempires.com/age-of-myth-retold-pantheons/
- Forged Alliance Forever four faction strategy and ongoing balance: https://faforever.com/ and https://faforever.com/faf-teams
- Dawn of War/Soulstorm nine: https://store.steampowered.com/app/4570/
- Battle for Middle-earth II six: https://www.gamespot.com/articles/the-lord-of-the-rings-the-battle-for-middle-earth-ii-qanda-details-on-new-lands-new-factions-new-heroes-and-more/1100-6141394/
- Warlords Battlecry Protectors of Etheria: https://store.steampowered.com/app/2420170/
- D.O.R.F. current three: https://www.dorf-rts.com/the-factions and https://store.steampowered.com/app/2388620/
- D.O.R.F. May 2026 logistics systems simplification: https://www.dorf-rts.com/dev-blog/end-of-may-update-major-systems-rework-and-bringing-in-more-talent
- D.O.R.F. July 2026 Annex system: https://steamcommunity.com/app/2388620

### Distilled design observations
- Warcraft III **Night Elf is not merely a reskinned Human**: Wisps bond to forests without consuming trees and Ancients uproot/move; **Undead** infrastructure depends on Blight. Both alter settlement and economy, not just unit cosmetics.
- FAF has four factions, a long-lived balance team and extensive counterplay, but this does not constitute a measured claim of perfect balance.
- D.O.R.F.'s developers publicly report that overlapping logistics systems had created busy/redundant play; they simplified role assignment and made some logistics faction-specific. One strong lesson for **Simple Surface, Deep Simulation**.
- D.O.R.F.'s **Annex** factory attachments produce variants of common tank and infantry templates rather than every loadout being a standalone unit. This echoes Scalfagus' chassis + roles + modules model; prefer it over multiplying faction rosters.

## 7. Near-term experiments / acceptance tests
- Build **one Manusian** worker, fighter, shooter and limited possession as proof; scale to seven MIN archetypes as resources permit.
- Prove one deterministic cargo pickup, path and delivery with Matter/Volatiles/Energy inventory contract.
- Represent human soldier, cyberaugmented shooter and robotic shooter as three forms using **one attack/order/visibility model**; verify costs and drawbacks.
- Ensure a simple robot is not automatically an independent faction and an honor hunter is not automatically its own race.
- Later validate one Blergian biomass route and one Aetherian resonance link: same core simulation, different infrastructure policy and vulnerabilities.
- Ask new players to identify each faction's distinctive base mechanic **without reading lore**.
- Exclude Genesis Seed universal civ evolution, fifth faction, procedural tech tree, advanced FPS and LLM inference from MVP.

## 8. Decision register: unresolved
- Are Blergians individually conscious, centrally hive-controlled or a mixture?
- What is Aetherian consciousness: native biology, energy-field technology, shared psi network or all context-dependent?
- Which Manusian synthetic intelligences have political autonomy, and does that matter only to lore or to gameplay control?
- Is biological mutant material an alternate form of Matter, or a faction-local production inventory? Retain exactly three primary resources.
- Do any two candidate extra factions truly demand distinct *economic topology*?
- Can 3 existing races + rich unit families feel original and readable enough to ship MIN first?
- Which MTG as Code ontology additions are merely color semantics vs actionable mechanics?

Do not silently update the approved `design/factions.yaml` or source-of-truth decision registry based on this proposal. All proposed mechanics remain under review.
