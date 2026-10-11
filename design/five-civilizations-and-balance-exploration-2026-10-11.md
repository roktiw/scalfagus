# Five foundational civilizations — StarCraft asymmetry, MTG topology, fifth-race exploration

Date: 2026-10-11
Status: **new conversation-derived design discussion**; no approval to change canonical `design/factions.yaml`, no commitment to five-race MVP.
Prior context: `faction-evolution-discussion-and-decisions-2026-10-11.md` and `fourth-civilization-independent-machines-2026-10-11.md`.

## 0. Owner intent — accurately distinguished from design hypotheses
The owner explicitly wants to **strive toward five foundational playable races**. The owner regards an even count as aesthetically less compelling and wants a five-way balance / philosophical structure reminiscent of **MTG's five colors**, while regarding **StarCraft's three races** as the benchmark for deep readable RTS asymmetry.

Important distinction:
- **Owner preference**: five different civilizations as *long-term aspirational target*, not a generic 3 + 2 re-skin. Non-even count matters to the desired feel.
- **Analytical caveat**: **odd number does NOT inherently improve competitive balance**. Matchups among n distinct races = n(n−1)/2. Three -> 3; four -> 6; five -> 10. Five increases balance-testing complexity.
- **Working proposal**: borrow the MTG color-wheel pattern where each node has **two neighbors and two opposite nodes**, creating overlap, affinity and friction; this is conceptual balance, not hardcoded matchups or proof of numerical balance.

The owner also asked that this work be delivered in **long, listenable Polish podcast-style prose**, rather than a terse table, and that all discussion be recorded in GitHub.

## 1. Firm baseline: three existing civilizations (canon-concept)
| Civilization | StarCraft comparator | MTG analogy | Core civilization idea | Economic/production difference |
| --- | --- | --- | --- | --- |
| **Blergians** | Zerg | Jund (B/R/G) | **Organism / Life as technology** | Growth, biological reproduction, living infrastructure, mutation and metabolism |
| **Manusians** | Terran | Jeskai (W/U/R) | **Tools / Intelligence building instruments** | Factories, modules, cybernetics, industry, logistics, distributed bases |
| **Aetherians** | Protoss | Bant (W/U/G) | **Consciousness / Energy and resonance** | High-value specialists, resonance structures, shields, field/energy engineering |

Do NOT translate the analogies into franchise copies. Blergians are not a universally assimilating Tyranid blob; individual intelligence and specialized organisms must remain possible. Manusians may own robots, fully autonomous AI, cybernetic Strogg-like forms, biological Akira-like mutants and ordinary humans **inside one civilization**. Predator-inspired honor hunters can be specialist **Aetherian units**, not necessarily a species. The owner rejects forced mandatory hive minds and anonymous undifferentiated swarms.

### User's modular design preference
Factions should feel like MTG card ecosystems: **identifiable individual worker/scout/engineer/soldier/scientist/commander units** with unique local behavior, configurable roles, faction doctrine and combinable synergies. Large-scale AI need not imply one mind or a shapeless fused entity.

## 2. Fourth candidate: autonomous artificial life
Owner's newly highlighted, preferred candidate for fourth race is independently organized **machine persons**, inspired by 1996 `Z` (The Bitmap Brothers) and Stanisław Lem's `Bajki robotów` (humorous autonomous machine citizens/societies).
- Origin *may* be Manusian artificial intelligence that gained political and economic autonomy, left Terra and developed its own independent civilization; origins unfinalized.
- Independent self-maintenance, remanufacture, modular repair, partial salvaging and replaceable body parts. Detached modules might have limited local function (scout/repair), never infinite utility.
- Differentiate from mere Manusian drone/robot by **self-reproducing civilization with its own workshops, memory continuity, institutions, agency and economic loop**.
- May inherit ideas from three original races: Manusian precision/administration/modularity, Blergian regeneration-like mechanical self-repair, Aetherian powerful energy management.
- A robot person is not one central 'hive' and is not forced to rebel; artificial life ≠ merely an AI unit.
- Working philosophical tag: **Artifact** or Construct; partial resonance with Esper (W/U/B), Yellow as proposed energy semantics, not an official new MTG color. Names are provisional and cannot be taken as approved lore.
- Do not ship this in the primary single-Manusian MVP; strong long-term concept only.

See dedicated deep design: `fourth-civilization-independent-machines-2026-10-11.md`.

## 3. Fifth candidate, proposed in this conversation: Worldborn / Environment
**Status: assistant thought experiment only, not owner-approved.**

Hypothesis: First four civilizations may center the individual actor:
- Blergian: self-contained living organism.
- Manusian: intelligent body operating tools.
- Aetherian: conscious field/biological-technology specialist.
- Construct: autonomous synthetic robot person.

A genuinely fifth axis might instead organize civilization around the **environment as substrate**:
- distributed intelligence/memory in geological, chemical, ecological or mineral terrain systems;
- a mountain can function simultaneously as storehouse, information organ, factory and fortification;
- a forest as sensor network;
- waterways/mineral deposits as material transfer/memory/territorial infrastructure;
- combat as **terrain engineering and distributed ecological defense** instead of ordinary barracks production.

Working name `Worldborn` (not canon). Keep an open mind that this could simply be an environmental Blergian sub-doctrine rather than an autonomous civilization.

### Independence/admission test
Would this faction:
1. Create a *different economic and territorial game loop*, not just new 'living buildings'?
2. Enable a playable and intelligible starting state distinct from first minute?
3. Still operate with same three resources **Matter, Volatiles and Energy**?
4. Have reversible counterplay with no unstoppable continent/whole-map conversion?
5. Support individually identifiable units and direct unit-possession gameplay even if intelligence can be spatially distributed?
6. Remain ontologically distinct from Blergian growth and Aetherian environmental resonance?
7. Produce matchups that can actually be tested and balanced?

If those tests fail, treat it as an interesting **environmental technology tree or neutral ecosystem** rather than a fifth playable race.

## 4. Signature test — one engineering problem, five truly different approaches
In the discussion, a **bridge across a river** served as a conceptual diagnostic, not an implemented design.

| Civilization | Builds a bridge by ... | Restores the bridge by ... |
| --- | --- | --- |
| Blergians | growing a load-bearing organism/biological infrastructure | regrowing damaged living tissue using materials/metabolism |
| Manusians | surveying, planning, moving physical material and engineering a structure | dispatching engineers, material and equipment |
| Aetherians | building a resonant support/field or precise advanced-material crossing | repairing/restabilizing the field or resonant structure |
| Independent Constructs | assembling adaptive modular components with autonomous builders | recovering intact components, replacing modules and reconfiguring |
| **Worldborn [hypothesis]** | altering riverbed, banks, geological processes or terrain structure | reestablishing terrain-forming environmental processes |

A good faction should answer **the same civilian engineering problem and the same combat problem in fundamentally distinct ways**. Be clear that this does not imply bridges exist in MVP.

## 5. Balance — distinct dimensions
The discussion distinguishes:
- **Mathematical matchup count:** `n(n−1)/2` excluding mirrors.
- **Mechanical asymmetry:** constructors, resource flow, base topology, field maintenance, mortality and replacement, transformation and combat.
- **Competitive balance:** each matchup has viable counterplay, at multiple phases, on multiple map geometries; verified through replay simulations and human testing.
- **Narrative/philosophical balance:** no civilization is simply 'good/bad' or 'biological/robot' as an exclusive binary; every one has neighboring philosophical affinities and tensions.
- **Production feasibility:** MIN and first MVP should not multiply five full race technologies into an enormous build requirement.

### Desired five design criteria
1. No race is best at all civilian/military tasks.
2. Each has a unique macro advantage with a material, time, terrain, information or logistics cost.
3. Each has at least one credible strategic response to every other faction; no preordained hard losses.
4. Unit silhouette, base behavior and production are recognizable without names or colors.
5. Difference begins on the **first minutes** of base building, not after a tier-3 tech unlock.

### What 'five' provides creatively
Five allows symbolic affinity/opposition graphs akin to MTG: each civilization concept can share design traits with two other civilizations while fundamentally conflicting with two, preventing a neat 2-vs-2 duality. This is an **optional design heuristic**, not objective proof that four is boring or five numerically balances game outcomes.

## 6. Shared simulation, different conversion policies
Primary physical resources remain **Matter, Volatiles, Energy**:
- Blergian converts resources into organ growth, metabolic stores and biological weapons.
- Manusian into engineered tools, cargo, vehicles and outposts.
- Aetherian into resonance, energy fields, shields and elite precision.
- Construct into modular machine components, repair cycles, memory/maintenance and remanufacture.
- Worldborn [hypothesis] into geo/ecological transformations and territorial infrastructure.

Do not introduce mandatory new race-specific currencies simply because a race is spiritual, biological or robotic; specialized intermediates can be local inventories/process conditions if physically grounded.

Other cross-cutting axes: substrate, intelligence locus, production, culture, economy/logistics, military doctrine, transformation/recovery. Distinguish **species**, **civilization**, **political faction**, **unit family**, **strategic doctrine** and **mechanical resource**.

## 7. Cross-title learning (from this conversation)
- Warcraft III: faction's starting economy and worker construction can differ immediately; Undead Blight and Night Elf walking Ancients.
- Age of Mythology: distinct gods/favour sources; internal branching can multiply viable doctrines while avoiding unnecessary founding civilizations.
- Supreme Commander: UEF/Cybran/Aeon/Seraphim operate with shared mass and energy; differences in weapons/technology/strategy.
- Battle for Middle-earth II: six recognizable armies share substantial economic structure; Dwarven tunnels highlight logistics.
- Dawn of War Soulstorm: nine armies show that humans, machine bodies, psionic beings and other cultures can provide variety without nine separate substrates.
- Warlords Battlecry Protectors of Etheria: massive race/subfaction matrix scales sandbox diversity but makes strict balance more difficult.
- Age of Empires II: dozens of historical human civilizations mostly differentiated by common-rule bonuses, tech and units.

Full race-by-race catalog: `../research/rts-factions-podcast-and-comparative-atlas-2026-10-11.md`.

## 8. Decision journal
**Stated / owner-supported:**
- Seek **five** foundational civilizations over the long horizon, using StarCraft three-way deep asymmetry and MTG five-color relational logic as inspiration.
- Biological **Blergians**, industrial **Manusians**, consciousness/field **Aetherians** remain three foundations.
- Serious fourth-race candidate: politically independent artificial robot civilization (Z + Lem style).
- Reject compulsory hive/multi-body blob identity, obligatory assimilation, arbitrary +2 'fake' races.
- Prefer individually legible modular units, guild/card-like synergies, limited direct possession and deep simulation.
- Want long Polish audio-friendly explanations and thorough preservation to the repository.

**Assistant analysis / proposals, NOT approved:**
- Worldborn environmental/geological fifth civilization.
- Five-way philosophical wheel mapped onto the five factions.
- Bridge construction/repair as game-mechanics diagnostic.
- Five-asymmetry acceptance criteria and n(n−1)/2 balance framing.

**Open:**
- Does fifth race require another nonbiological substrate or a different locus of intelligence?
- Can geography-as-being coexist with independent small controllable units?
- Is fourth machine race economically different enough from autonomous Manusian AI units?
- Are five civilizations actually worth 10 non-mirror matchups for project scope?
- What relation chart connects all five without contrived 'hard counters'?
- Which prototypes expose meaningful distinction from first minute?
- What technologies remain **inside** Manusian/Blergian/Aetherian trees instead of being spun into factions?

## 9. Delivery scope
No changes to `design/factions.yaml`, `design/decisions.yaml`, costs, units or implementation. This document records discussion, candidate taxonomy and research framing. First MVP remains focused on a playable **Manusian vertical slice**, with modular RTS/logistics and a limited possession mechanic; the full five-civilization package is a long-term direction, not a deliverable promise.
