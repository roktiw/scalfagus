# Scalfagus — Faction Taxonomy, Five-Vector Experiment and Discussion Record
Date: 2026-10-11
Status: design exploration; **five playable factions are NOT approved**. This file records discussion and alternative directions, not a mandate to implement five factions.

## Context and decisions so far
The Scalfagus vision is a 1990s-readable isometric pixel-art RTS with a deep, compositional simulation: Warcraft II / StarCraft I clarity, Dungeon Keeper I autonomous base and tiny MVP possession, Settlers II physical logistics, Populous I/II terrain and isometric presentation, plus inspirations from Chris Sawyer's transport/management games, Peter Molyneux's god games, Civilization, Earth 2150, Magic: The Gathering and Advanced Dungeons & Dragons systemic interactions.

**Constitution:** Simple Surface, Deep Simulation. Depth belongs to the underlying rules and their interactions; routine complexity is handled by competent AI and progressive UI disclosure. The player should be able to click a worker, collect resources, build and fight without understanding the entire engine. Experts can optimize routes, modules, targeting, terrain and doctrines. The MVP remains **one playable Manusian faction**, seven MIN-chassis role archetypes, three resources (Matter, Volatiles, Energy), one small map, simple scripted/autonomous base AI, RTS combat and **one genuinely controllable unit in a small Dungeon Keeper-like possession mode**. Future Quake Champions/Doom-mod-like FPS is out of MVP. Three factions and 63 chassis-role designs are the next broader milestone, not the MVP checklist.

## Initial three-faction baseline (approved direction, not final implementation)
| Faction | Source-of-power fantasy | Mechanical differentiator | References / warnings |
|---|---|---|---|
| Blergians | Predatory, living biological swarm, mutating biomass | Living base network, organism production, irreversible mutation, detached colonies viable but less synergistic | Zerg; Alien/Xenomorph and H. R. Giger biomechanical horror; Warcraft Orcs for aggression; Warhammer 40k Tyranids more mechanically analogous than Orks. Use original visual IP. |
| Manusians | Human industrial colonists, logistics, machines | Distributed outposts, modular equipment, vehicles, deployable specialist structures, human/robot cooperation | Terrans; Alien/Aliens Colonial Marines; AvP humans; 40k Astra Militarum / Adeptus Mechanicus for different aspects. |
| Aetherians | Ancient high-tech psionic/resonance civilization | Fortified core, satellites, expensive reversible transformation, fields/shields | Protoss, Xel'Naga, Predator's stealth/hunting ethos; 40k Aeldari for psionics, Necrons for ancient tech. These references are analogies, not exact equivalents. |

All three should support all seven archetypes and all player roles, and be competitively viable in early, mid and late play. Faction flavor is not moral alignment.

### Dune comparison
No exact Zerg analogue in Frank Herbert's Dune. Sandworms are a giant ecological/economic keystone, Bene Tleilax provide biological engineering and gholas, Bene Gesserit represent multigenerational breeding design, Fremen extreme-environment adaptation. Treat as separate inspiration axes, not a single Dune race equivalent.

## Five-point experiment from the discussion — now challenged by the user
The user explored an A–E continuum:
- **A:** primordial life, DNA, mucus, cells, proto-Zerg/Xel'Naga creator-of-life flavor.
- **B:** predatory swarm / Zerg-like biomass; Blergians.
- **C:** humans, Terran-like adaptable industry; Manusians.
- **D:** human–AI–robotics hybrids, automation, modular bodies, scaled industry.
- **E:** energy, purity, light, order, psionic Protoss/Xel'Naga flavor; Aetherians.

Working names **Primordials** (A) and **Synthians** (D) were suggestions, not accepted faction names. The five-color MTG wheel inspired faction philosophy and strategic counterplay, **not** a literal good–evil/light–dark line. MTG colors are multidimensional values; their positions do not map neatly to a single biological-to-energy scale.

### Why five playable factions were questioned
- 7 roles x 3 chassis x 3 factions = 63 baseline designs; five factions = **105** designs before variants and loadouts.
- Unordered cross-faction matchup pairs: three factions = **3**; five factions = **10**. Including mirror matchups: 6 versus 15. These are counts, not proven proportional production costs.
- Extra art, animations, effects, buildings, AI doctrines, balance scenarios, onboarding and differentiated possession behavior.
- Adding two races does **not** itself eliminate resemblance to StarCraft. Distinct mechanics, visual language, terrain and logistics do.
- Five lore civilizations need not mean five playable factions. The engine can model independent axes and the setting can contain minor cultures, neutral life and robots.
- Strong recommendation: one-faction internal MVP, three-faction Alpha, optional further playable factions only after validated mechanics.

## Reframe: separate axes rather than force a five-race spectrum
**Do not assume that life, biomass, humanity, honor, AI, robotics, automation and energy are peers.** They belong to different ontological dimensions:
1. **Substrate / embodiment:** cellular-organic, cybernetic, mechanical, photonic/field-based, hybrid.
2. **Agency / intelligence:** individual biological minds, hive coordination, distributed AI, centralized superintelligence, psionic collective.
3. **Reproduction / production:** breeding, mutation, cloning, factories, self-replication, summoning/field assembly.
4. **Economy / logistics:** biological networks, manual cargo, automated cargo, energy resonance relays; all obey Matter/Volatiles/Energy.
5. **Governance / values:** honor, ritual, survival, cooperation, conquest, order, liberty, optimization; honor is a *culture*, not a material.
6. **Combat doctrine:** swarm, combined arms, precision elites, autonomous drones, terrain control, siege, stealth.
7. **Spatial ecology:** mother-base dependency, independent distributed colonies, satellites/relays, nomadic/mobile habitats.
8. **Transformation:** irreversible mutation, equipment swap, software/robotic reconfiguration, costly reversible ascension.
9. **Aesthetic language:** organic wet/visceral, industrial functional, machine geometries, luminous/crystalline; must be distinct original IP.
10. **Possession embodiment:** direct control should feel different by unit but remain the same simulation; only one unit implementation in MVP.

Axes may be mixed: organic beings can have honor; robots can have religion; energy beings can be predators; humans can form a hive. This yields more design space than forcing five categories onto a linear gradient.

## Candidate structural models to evaluate
**Option 1 — Three independent species:** Blergians / Manusians / Aetherians. Distinguish via gameplay, not just StarCraft-like silhouettes. Recommended baseline.
**Option 2 — Three factions + internal branches:** Manusian biological-human versus AI/robotic doctrines; Blergian primitive symbiosis versus predatory swarm; Aetherian honor hunters versus resonance architects. This exposes A and D without two extra complete playable factions. Recommended research direction.
**Option 3 — Two opposed poles + humans in the middle:** Life/Biomass ↔ Humanity/Synthesis ↔ Energy/Order, with cross-pollination. Strong philosophical story, but beware overly deterministic evolutionary ladder.
**Option 4 — Five fully independent species:** maximum expression, highest production and balancing burden; defer pending prototype evidence.
**Option 5 — Faction builder from traits:** powerful long-term sandbox/LLM lab; too difficult to balance as core MVP; start with curated authored factions.

## Open questions / decision register
- **F-001:** Are 'race', 'faction', 'civilization', 'species', 'ideology', 'tech doctrine' distinct in lore and game data? Recommendation: yes; do not use interchangeably.
- **F-002:** Is A–E a useful worldbuilding taxonomy or an artificial linear spectrum? User currently does not feel the five-race concept; do not lock it.
- **F-003:** Are humans fully biological Manusians with robotics as a tech branch, or are synthetic post-humans a separate playable civilization?
- **F-004:** Are Blergians organisms with individual consciousness, an emergent collective, or centrally controlled by queens?
- **F-005:** Are Aetherians truly energy life, embodied organisms using energy tech, or machine/psionic hybrids?
- **F-006:** Where does honor belong: species biology, cultural doctrine, specialist code or diplomacy? Recommendation: culture/doctrine.
- **F-007:** Are primitive life forms a separate neutral ecosystem, ancestor faction, or a playable Primordial species?
- **F-008:** Should factions share all three resources and seven archetypes but diverge in production/logistics/transformation? Current direction: yes.
- **F-009:** What *one* mechanic makes each playable faction instantly distinct within a 30-second demo?
- **F-010:** How to visually distinguish Blergians from Zerg, Manusians from Terrans, Aetherians from Protoss, while preserving readable RTS archetypes and avoiding copied protected art?
- **F-011:** Which faction best supports the initial tiny possession MVP? Current recommendation: Manusian ranged infantry.
- **F-012:** How can AI/robotics be available to humans without creating an unmanageable fourth resource or parallel game?
- **F-013:** Can faction branches meaningfully change gameplay while keeping cross-faction counters understandable?
- **F-014:** Which design variables are fixed per species, mutable per civilization, selectable doctrines or individual-unit traits?
- **F-015:** Should MTG influence counterplay via a non-linear philosophy graph rather than literal color/faction correspondence?
- **F-016:** What are the minimum measurable tests to prove three faction identities are fun and not cosmetic?
- **F-017:** Is the setting cosmic evolution from cells to energy, or coexistence of unrelated civilizations? Avoid implying the former without explicit approval.

## Practical production approach
1. Preserve **one playable Manusian MVP** and shared unit/economy/domain contracts.
2. Write one-page faction identity cards with distinct core loop, AI behavior, production and counterplay for Blergians, Manusians, Aetherians.
3. Prototype one signature mechanic per faction *before* adding its full roster.
4. Explore primitive ecology (A) and machine intelligence (D) as neutral systems/branches, not additional factions.
5. Build original silhouettes, economy topology and gameplay loops that avoid StarCraft imitation.
6. Add a fourth/fifth faction only when it adds a new playstyle impossible to express clearly as a branch or doctrine.

## Related documents
- [Design Bible](scalfagus-design-bible-2026-10-11.md)
- [Unit domains and roster](unit-domains-and-archetypes.md)
- [MVP scope](mvp-iso-pixel-rts.md)
- [Product principles](product-principles.md)
- [Faction YAML](factions.yaml) — earlier three-faction model; not automatically migrated
- [Faction gameplay roles](gameplay-roles.md)
- [Inspirations](../research/gameplay-inspirations.md)

## Explicit status
This document captures the **discussion so far** and reframes the unresolved five-race experiment. It does not approve five factions, rename any faction, edit the existing canonical faction YAML, or assert any game code has been implemented.
