# Scalfagus — Individual Agency and Composable Civilizations
Date: 2026-10-11

> Current owner-approved faction names are Organs (Organites / ORG), Manus (Manusians / MAN), and Eters (Etherans / ETH); exact full backronyms: [Canonical Naming](faction-naming-conventions-2026-10-11.md).
Status: **project-owner design direction** on individuality, specialization and anti-blob faction design; implementation details are proposals.

## Constitutional thesis: an army of characters, not one amorphous intelligence
Every major civilization must be recognizable as a collection of **distinct, specialized, locally functional units**. We do NOT want a mandatory hive mind, a single totalizing super-organism, an Akira-style civilization-wide flesh blob, or an entity that absorbs everything into one undifferentiated being. Neither supreme intelligence nor enormous power justifies losing legible unit identities.

Important nuance:
- Tactical coordination, communications, biological signaling and shared intelligence are allowed.
- Network infrastructure may *enhance* operation and change economics, but it must **not replace all individual agency**.
- Human/AI strategic controllers can coordinate a faction without owning the literal minds of every citizen.
- A unit's AI is a **bounded, autonomous local decision-maker** that follows legal commands, doctrine, available information and resources. It may retreat, improvise, maintain itself or carry out its specialized role.
- Units need not be human-level sentient, but their *role and behavior* must be independently legible and useful.
- No faction's identity should depend on compulsory mind assimilation, enemy-DNA theft or obliteration of other beings' individuality.
- This is a design principle, **not** a statement that all units must be sapient or that all AI controllers must operate without coordination.

## The Magic: The Gathering / deck-building analogy
The owner values **cards that remain identifiable while forming decks, guilds, combinations, civilizations and strategic systems**.

Translate that into the RTS:
- **Card -> unit/template/module** with a distinctive name, silhouette, cost, capability, vulnerability, visual feedback and counter.
- **Deck -> squad/loadout/production doctrine** with complementary roles.
- **Guild -> school/organization of interoperable abilities**; cultural and technological cross-pollination is allowed.
- **Civilization -> portfolio of independent units, infrastructures and policies**, not a physically merged blob.
- **Rules engine -> compositional contracts**: logistics, cost accounting, domains, status effects, targeting, build prerequisites, local orders.
- **Synergy -> emergent tactics**: one specialist enables another's operation or efficiency, but not by erasing their identity.
- Do not literally implement an MTG collectible-card economy, five-color mana costs or deck construction UI as mandatory MVP gameplay. This is a product design analogy.

### Compositional rules for designers
1. Any unit should have an intelligible solo function and a reason to combine it with others.
2. Synergy improves a unit's options, efficiency, protection or range. It should not make disconnected units useless unless the specific device requires connectivity.
3. A module detaching from a machine has finite functionality, hardware and local intelligence, **not free unlimited self-replication**.
4. Temporary combination is permitted (transport, formation, attachment, support) if the components remain identifiable.
5. No microscopic unit-component simulation is required in MVP. A detached part can be represented by an existing lightweight module/drone/loot entity if gameplay earns it.
6. Enemy assets can be salvaged as **Matter, parts or generic equipment** without importing a copy of their genetics, culture, identity or unique faction technology for free.
7. Named unit families are **not automatically extra playable factions**.
8. Unit role (Worker/Fighter/Shooter/Artillery/Tank/Flyer/Specialist), faction lineage, chassis size, movement domains and body substrate are independent axes.
9. Each faction must be *readable without a wiki*: icon, silhouette, command response and one signature world interaction reveal its character.
10. The simulation can be rich, but everyday commands must remain classic 1990s RTS simple.

## Applying the principle to the four-faction direction
### Organs (ORG / Organites)
Predatory biological civilizations with breeding, mutations, differentiated organisms, sophisticated *individual* specialist intelligence, and living infrastructure. Connected biomass helps throughput and support, not a literal mind-merging requirement. No general automatic gene assimilation from enemies. Proposed historical template named 'Hive Mind' should be renamed before gameplay implementation to an individual specialist such as 'Brood Strategist' or 'Synaptic Commander' — a **proposal only**, not a retroactive canonical change.

### Manus (MAN / Manuss)
People, modified humans, Akira-like bio-experiments, Quake Strogg-style cyberforms, service robots, drones and advanced AI can all remain **unit families** within a Human-origin industrial civilization. Some AI may be citizens with agency; ancestry and political ownership differ from substrate.

### Eters (ETH / Etherans)
Advanced biological/technological/psionic beings; a hunter with Predator-like ethos can be an elite *individual*, not a different species or proof all Eters follow hunter culture. Sophisticated resonance can coordinate without thought fusion.

### Autonomous Machine Civilization (FOURTH FACTION CANDIDATE)
A **civilization of independent machine persons** may justify separate faction status, even if its ancestors were Manus robots. It differs through a civilization-level repair, continuity, maintenance, machine sociology and modular reconstruction economy. Components can function after physical separation using local controllers, limited power and real inventories. Other factions may learn from its engineering; none thereby become machine hive minds.

## Economic integrity
- Exactly three primary currencies: Matter, Volatiles, Energy.
- Biomass, tissue, scrap, electricity, software, memory and component patterns are typed matter, states, quality tags or production knowledge, **not additional mandatory primary resources**.
- Any self-repair, regrowth, detached module or replication must respect finite matter inventory, energy expenditure, time, spatial capacity and unit limits (details TBD).
- Losing a depot, repair station or energy source must matter; no free infinite machine resurrection, no free tissue reproduction, no free instant spawn when cut.
- Avoid unbounded exponential replication: enforce costs, cooldowns, capacity and production constraints using the shared sim.

## Agency / control-order priority
Possessed human unit > protected human explicit manual order > approved higher-level strategy/operational order > local doctrine > bounded individual autonomy > idle. A unit can be autonomous without being rebellious or magically telepathic; communications loss should have predictable local fallback.

## Gameplay acceptance tests
- Players can point out three distinct roles by silhouette/actions for each developed civilization.
- A detached machine part never duplicates its current payload, energy or material inventory.
- Severing a network affects logistics/support but does not delete every isolated unit's autonomy.
- Local squad tactics work without assuming shared omniscience.
- Individual units remain selectable, targetable, destructible and possessable when eligible.
- Every claimed synergy has a visible range, price, trigger or tell and a counter.
- AI and manual control share the same resource/fog-of-war restrictions.
- No new primary resource is necessary to ship any one faction's signature mechanic.

## Status
**Accepted intent from owner:** preserve unit individuality, specialization and clear mechanical identities; avoid total hive-mind/blob/total assimilation fantasy.
**Proposed:** exact repair algorithms, communication-degraded behavior, detachable part simulation, module rescue, MTG/guild composition mechanic and the fourth machine faction.
**Explicitly not approved:** five playable races, new economic currencies, full procedural civilization evolution, smart limbs as mandatory MVP feature, or full FPS in MVP.

Related: [Faction Evolution Debate](faction-evolution-discussion-and-decisions-2026-10-11.md), [Cross-Cutting Faction Dimensions](faction-dimensions-and-rts-comparative-notes-2026-10-11.md), [Design Bible](scalfagus-design-bible-2026-10-11.md).
