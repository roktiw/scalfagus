# Conversation record — RTS races, MTG five-way balance and Scalfagus
Date: 2026-10-11
Status: **conversation journal, not a word-for-word transcript**. Captures user requests, assistant's analyses, disagreements, decisions, links and outstanding issues. Older design discussions are already preserved in other files under `design/`.

## Chronology of the requests

### Opening: "rasy w grach. opowiedz mi o mnich wiecej"
Context: broad discussion of how other RTS games organize playable races and what their asymmetries mean for the ongoing Scalfagus project. Source material included a long pasted historical conversation about three original factions, later fourth-civilization possibility, unit families, MTG colors, RPG possession and the project scope. Existing in-repo records include:
- `design/scalfagus-design-bible-2026-10-11.md`
- `design/faction-taxonomy-and-discussion-2026-10-11.md`
- `design/faction-evolution-discussion-and-decisions-2026-10-11.md`
- `design/fourth-civilization-independent-machines-2026-10-11.md`
- `design/faction-dimensions-and-rts-comparative-notes-2026-10-11.md`

The assistant compared Warcraft III, Supreme Commander: Forged Alliance, Dawn of War: Soulstorm, Grey Goo, Warlords Battlecry, D.O.R.F. and other RTSs. The main distinction: **species vs civilization vs faction vs unit family**. The preliminary working palette: Blergians (living organic predator civilization), Manusians (technology, logistics, cybernetics, robots and bioengineering), Aetherians (advanced biological/energy/psi civilization), plus a serious fourth possibility of independent mechanical/artificial life inspired by Z and Lem. Grey Goo-style undifferentiated absorbing blobs are contrary to the desired modular individual units.

### Prompt 2: comparison to StarCraft and MTG
Owner's words:
> "opisz mi po kolei rasy porownoujac je do idealnego balansu jakie znam ze starcraft (3 rasy) i mtg (5 ras)"
> "waj w formie przyjaznej do sluchania. jak podcast. dlugie zadnia. daze do 5 ras bo parzysta ilosc jest nudna i balansuje rozgrywke i inne aspekty"

Owner provided a comparative table of seven games:
1. Warcraft III — 4 — strong asymmetry in economy/buildings — new civilization can differ from first minute.
2. Age of Mythology: Retold — 4 at launch, further additions — pantheons, gods, economy and technology — common core + different paths.
3. Supreme Commander: Forged Alliance — 4 — common economy, different armies/doctrines — multiple factions on shared simulation.
4. Battle for Middle-earth II — 6 — army/hero/tempo differences — diversity without separate physics.
5. Warhammer 40,000: Dawn of War – Soulstorm — 9 — armies/production/mechanics — variety developed through expansions.
6. Warlords Battlecry: The Protectors of Etheria — claimed 16 races, 50+ factions — race/hero/specialization — sandbox richness, balance challenge.
7. Age of Empires II — dozens — shared economic core, technology differences — many civilizations are not many separate engines.

Assistant's first long podcast:
- StarCraft: Terran tools/industry, Zerg organic biology, Protoss psionic/energy elite; strong asymmetry but no claim of perfect measured balance.
- MTG five-color model: White, Blue, Black, Red, Green in a five-node relational wheel, each with two neighbors and two opposites. Owner's extended nine-color metaphor should be preserved and not misconstrued as nine game resources.
- Described the seven games through mechanical perspectives; emphasized **different worker roles and production as first-minute identity**.
- Proposed five civilization abstractions: **Organism (Blergians); Tools (Manusians); Consciousness (Aetherians); Artifact (independent Constructs); Environment (Worldborn, speculative)**.
- Speculative fifth-race idea: terrain/geology/eco-infrastructure as locus of a civilization rather than another unit-themed army; marked as *unapproved concept*.
- Bridge thought experiment across all five: growth vs engineering vs resonant field vs modular assembly vs geological terrain formation; damage recovery mechanics likewise differ.
- Counterpoint: odd race count does **not** produce numerical balance; five races have ten distinct non-mirror pairings versus four having six. Five is potentially valuable as a **worldbuilding philosophy** and relational topology, not as a balance theorem.

### Prompt 3: explicit podcast about factions/races from the table
Owner's words:
> "opisz mi rasy z rtsow wg tabeli co byla w formie podcastu"

Assistant delivered a longer, spoken-style **race-by-race walk-through**:
- Warcraft III: Human Alliance, Orcish Horde, Undead Scourge, Night Elves.
- Age of Mythology: Retold: Greeks, Egyptians, Norse, Atlanteans (launch civilizations; later expanded).
- Supreme Commander: Forged Alliance: UEF, Cybran Nation, Aeon Illuminate, Seraphim.
- Battle for Middle-earth II: Men of the West, Elves, Dwarves, Goblins, Isengard, Mordor.
- Dawn of War: Soulstorm: Space Marines, Chaos Space Marines, Imperial Guard, Orks, Eldar, Dark Eldar, Tau Empire, Necrons, Sisters of Battle.
- Warlords Battlecry: project claims large roster; discussion grouped human/Empire, multiple elf and dwarf societies, Orcs, Barbarians, Minotaurs, Undead, Daemons, Plaguelords, Fey, Swarm and Ssrathi; **catalog should be verified against actual project source before treating it as an authoritative complete roster**.
- Age of Empires II: Mongols, Britons, Franks, Byzantines, Japanese, Vikings, Chinese as illustrations of many shared-core human civs.

The assistant framed three design schools:
1. Deep foundational asymmetry (StarCraft, partially Warcraft III).
2. Common simulation + different technologies/strategies (Supreme Commander, Age of Mythology).
3. Many playable rosters via recombination of species/culture/bonuses/tech/hero specialization (Dawn of War, Warlords, AoE II).

Detailed expanded reference was saved separately:
`research/rts-factions-podcast-and-comparative-atlas-2026-10-11.md`.

### Prompt 4: archive everything
Owner's words:
> "pisz wszystko z tej rozmowy do https://github.com/roktiw/scalfagus/tree/main"

Action taken: saved the new discussion as additive dated notes to the repository's **main** branch without overwriting canonical faction data or implying unapproved fifth-race decisions are implemented.

Files:
- `research/rts-factions-podcast-and-comparative-atlas-2026-10-11.md`: seven games, every major faction discussed, comparison table and StarCraft/MTG conceptual benchmarks.
- `design/five-civilizations-and-balance-exploration-2026-10-11.md`: aspirational five-race system, fourth machine civilization, Worldborn **unapproved** fifth hypothesis, bridge test and detailed balance criteria.
- `research/conversation-log-rts-races-2026-10-11.md`: this concise chronology and attribution of direct user wishes vs analytical additions.

## Research vs decision discipline
**User-directed / foundational:** aspire to five truly distinct civilizations; deep asymmetry; visible first-minute differentiation; distinct individuals; reusable generic physical economy; fourth autonomous synthetic life serious candidate; no obligatory hive mind/grey goo; Polish podcast style; preservation in repo.

**Exploratory assistant concepts, not agreed canon:** proposed Worldborn environmental civilization, five-race MTG wheel assignments, specific bridge implementations, hypothesized counterplay.

**Future validation needed:** exact current AoM DLC pantheons and Warlords Battlecry fan project race labels/counts; fine historical faction mechanics; formal race-vs-race matchup tests; independently original artistic identity.

## Do not silently modify
- `design/factions.yaml` — existing three core playable races.
- `design/decisions.yaml` — approvals.
- Economy/resource/units YAMLs and first-MVP implementation scope.

The note files are documentation, not commands for unattended implementation.
