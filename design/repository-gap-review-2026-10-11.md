# Repository gap review — faction ontology, RTS / WH40K research and executable scope

**Date:** 2026-10-11  
**Status:** independent repository review; **recommendations, not approvals or game implementation**.  
**Coverage:** GitHub `main` recursive tree contained **49 tracked files** (41 in `design/`, seven in `research/`, one root `readme.md`). The review inspected governing files, representative contracts, all directory paths and multiple active YAML definitions. It was not a line-by-line factual verification of every research assertion or an executable test run.

## Executive assessment

The repository already has unusually broad **design coverage**: approved three-tier race naming, three resources, faction identities, player Hero, three viewing/control modes, simulation principles, logistics concepts, unit taxonomy, design bible, roadmap, existing audit and RTS comparative atlas.

**Do not add another top-level vision document without new content.** The next gains come from: (1) completing missing *interfaces and examples*, (2) resolving old-vs-new contract disagreements, (3) capturing the newly discussed WH40K/SC/MTG ontology as research, (4) validating a single complete Manus vertical slice, and (5) distinguishing the five-race aspiration from accepted founding race definitions.

## Source-of-truth hierarchy — preserve

1. `design/faction-naming-conventions-2026-10-11.md`: **approved spellings** — ID `org/man/eth`; short **Organs, Manus, Eters**; mid **Organites, Manusians, Etherans**; full **Organites Reproductive Generalismus / Manusians Augmented Navigators / Etherans Transcendent Hypervisors**.
2. `design/decisions.yaml` and `design/factions.yaml`: approved decisions and active current faction IDs.
3. `design/product-principles.md`, `design/hero-progressions-and-three-cameras-2026-10-11.md`, `design/mvp-iso-pixel-rts.md`, `design/three-pillars-one-world-control-contract.md`: recent product / MVP direction.
4. Historical race notes and prior roadmaps must not silently supersede any of the above.

**No approval** is inferred for a fourth or fifth playable race. The independent machine civilization is a serious owner-favored candidate; **Worldborn** is an assistant-proposed, unapproved idea.

## Priority findings — targeted additions and edits

| Priority | File(s) to extend | Observed fact / gap | Recommended edit and completion condition |
| --- | --- | --- | --- |
| P0-A | `design/economy.yaml`, `design/resources.yaml`, `design/units.yaml`, `design/energy.yaml` | Economy and resource files still define **crystals, gas, resin** and sample costs; units still refer to `base_core_costs_crystals`; Energy storage still uses legacy `blergians/manusians/aetherians` keys. `design/decisions.yaml` already lists migration debt. | Introduce an explicitly **draft migration plan and cost reconciliation** for Matter / Volatiles / Energy, with one compatibility/validation test. Do not numerically relabel old costs one-for-one. Rename active Energy faction keys `org/man/eth`. Only after agreeing recipes should original live YAML values be migrated. |
| P0-B | `design/recommendations-and-roadmap-2026-10.md`, `design/match-scale-min-mid-max.md`, `research/engine-selection-357.md`, `design/design-audit.md` | Older roadmap explicitly puts FPS possession at `P6` and says it is not core MVP; latest governing `design/mvp-iso-pixel-rts.md` requires a **small literal FPS Hero possession** in the internal MVP, along with Overlord + Direct Unit. The earliest feasibility/proof and internal MVP are distinct milestones. | Mark prior milestone ordering **superseded**, clearly distinguish engine spike, first playable proof, internal MVP, three-faction alpha and future deep FPS. Align audit acceptance criteria with same Hero entity, LOS, HP, cooldown, inventory and command legality across all cameras. |
| P0-C | `design/design-audit.md`, `design/design-audit.yaml` | Current audit says full tree enumeration unavailable; it is now available. The issue registry still has historical names in test cases and priorities for the new Hero/camera contract are not explicit. | Refresh coverage statement to 49 current files, keep the 20 existing AUD IDs, add new dated auditable tasks for camera/control/Hero validation, identify **status = proposed/approved/open**, and migrate active test-scenario labels to ORG/MAN/ETH. |
| P0-D | `readme.md` (currently only `scalfa brew`) | No newcomer navigation, no current state, no design authority links, no prototype status. The repo currently has **design files only**, no visible source/test code. | Write a concise English `README.md` or replace `readme.md` as intentionally chosen: project promise, canonical names, three resources, 3 views, MVP vs future, status, first 5 document links, how-to-contribute/no IP copies. Do not imply working game. |
| P1-E | **NEW** `research/wh40k-starcraft-mtg-ontology-2026-10-11.md` | The recent WH40K/SC/MTG spoken analysis is **not present** in the tracked research filenames. `research/rts-factions-podcast-and-comparative-atlas-2026-10-11.md` covers RTS games and Soulstorm only at a high level, not the full WH40K spectrum. | Add a research **mapping by ontology, doctrine and economics**, including Imperium: Astra Militarum, Astartes/chapters, Mechanicus, Custodes, Sororitas, Knights; Chaos gods/warbands, Daemons/Knights; Xenos: Tyranids, Genestealer Cults, Orks, Aeldari/Drukhari/Harlequins/Ynnari, Necrons, T'au, Votann. For each: Terran/Zerg/Protoss mixture, MTG color / guild / shard/ wedge **as analyst interpretation**, mode of production, locus of agency, distinctive combat/tech, lessons and IP cautions. Mark canonical Warhammer lore vs analogy; source citations separately, no imported copyrighted assets. |
| P1-F | `design/five-civilizations-and-balance-exploration-2026-10-11.md`, `design/fourth-civilization-independent-machines-2026-10-11.md`, `design/faction-dimensions-and-rts-comparative-notes-2026-10-11.md` | Extensive discussion exists, but not one **pass/fail admission scorecard** applied consistently to both fourth and fifth candidates. Fifth Worldborn risks overlap with living Organ structures; robot civilization risks overlap with Manus autonomous robots. | Add a standardized candidate dossier: **physical substrate, locus of mind, reproduction/manufacturing, worker startup, 3-resource transformations, infrastructure topology, repair/death, map interaction, hero and possession, combat signature, counterplay, matchup cost, overlap rejection test**. Include falsifiable side-by-side first-five-minute experiments and a bridge-destruction/repair test, all proposals. |
| P1-G | `design/factions.yaml`, `design/unit-domains-and-archetypes.yaml`, `design/hero-progressions-and-three-cameras-2026-10-11.md` | Names and broad play styles exist, but race-specific **hero/worker/economy early sequences** are still conceptual. 63 draft units are not a shipping roster. | Write three comparable **minute 0–5 vignette/playtest scripts**: Org Organite reproduces/grows, Man Manusian builds/transports/refits, Eth Etheran assembles/energizes/resonates; demonstrate 1 Hero + a worker + combat encounter for each. Document input & AI parity and recovery/counterplay. Keep actual MVP Manus-only. |
| P1-H | **NEW** `design/faction-interaction-matrix.md` or `design/faction-balance-test-plan.md`; reuse `design/resource-balance.yaml` | Symmetrical proposed 3×3 efficiency matrix is **not measured competitive balance**. Five factions yield 10 distinct non-mirror pairings; no recorded matchup assumptions or test matrices for future candidates. | Specify economy, vision, mobility, structures, range, repair, objective capture, Hero, early/mid/late, map topology and resource paths as comparable axes. Track win-rate evidence **only after tests**, with uncertainties/sample sizes. No hardcoded rock-paper-scissors outcome or false '5 = inherently fair'. |
| P1-I | `design/faction-naming-conventions-2026-10-11.md`, `design/five-civilizations-and-balance-exploration-2026-10-11.md`, `research/rts-factions-podcast-and-comparative-atlas-2026-10-11.md`, `design/design-audit.yaml` | Some newly dated research still puts **Blergians / Aetherians** front and center even though the canonical IDs and levels are now Organs/Organites and Eters/Etherans. Preserving exact historical quotes is appropriate. | **Add a canonical naming header** to research documents and favor new names in live recommendations; preserve old names **only in historical quotations / explicitly tagged legacy comparisons**. Do not mass rewrite historical conversations. |
| P2-J | `research/rts-factions-podcast-and-comparative-atlas-2026-10-11.md` | The Warlords Battlecry section explicitly flags uncertainty in its 16-race roster; the text says it is not an authoritative list. | Verify exact editions, faction names and release/current counts from primary game / project sources; distinguish officially released roster, fan continuation and subjective classification. |
| P2-K | `design/design-audit.yaml`, new schema/test folder **when implementation begins** | Project currently has no repo-visible simulation, CI or schema tests; extensive conceptual tests are named but cannot run. | Add schema validators and **contract tests** when code exists: resource conservation, no free energy, deterministic command replay, no fog leaks, same Hero entity across 3 controllers, construction/deployment legality, basic match completion. |

## Conceptual distinction to make explicit

Each named group can be:
- `species_or_substrate`: living organic, engineered bio, mechanical/synthetic, resonant/energetic, distributed ecological;
- `civilization`: sovereign reproducible culture, institutions and economic reproduction;
- `polity_or_faction`: Imperium, guilds, dynasties, septs, cults or independent houses;
- `army_or_doctrine`: unit roster, command style, faith/ritual/stealth, recruitment and technology;
- `unit_family`: human, cyberform, mutant, drone, elite hunter, construct;
- `mtg_philosophy_tags`: five classical colors and owner's separately experimental vocabulary.

*Warhammer 40,000* examples illustrate why these axes must not be conflated: Space Marines vs Imperial Guard share humanity; Aeldari vs Drukhari share ancestry but differ in ethos; Mechanicus vs Necrons share mechanical aesthetics but not independent substrates; Genestealer Cults hybridize forms and institutions. None of this licenses adding a Scalfagus race merely because a roster feels distinct.

## Architecture and information ownership

Prefer placing:
- Analyses of **external games, factions, canon and analogies** under `research/`.
- Owner-approved names / gameplay decisions in `design/faction-naming-conventions-2026-10-11.md`, `design/decisions.yaml`, `design/factions.yaml` after explicit approval only.
- Candidate fourth/fifth theories under `design/five-civilizations-and-balance-exploration-2026-10-11.md` and the dedicated machine-civilization record.
- Executable game rules in YAML only when costs and schemas are agreed and validated.
- Roadmap / work tracking in the existing `design/design-audit.yaml`, not another independent unmaintained backlog.

## Recommended order, bounded

**First — documentation consistency:** README, supersession banners, audit coverage, reconcile MVP vs roadmap, canonical naming headers. These are safe editorial changes.
**Second — simulation foundation:** approved resources, finite supply/consumption, first energy anti-softlock, one Manus worker/hero tactical scenario, shared state across three views.
**Third — conceptual research expansion:** dedicated WH40K → StarCraft → MTG mapping, five-race candidate dossier, analogies drawn to Scalfagus without declaring canon.
**Fourth — faction-test design:** side-by-side first-five-minutes, matchup test harness and future five-civilization feasibility after three-race core is proven.

## Scope note

This review **does not** imply approval for Worldborn, a mandatory collective intelligence, extra MTG-colored in-game resources, free regeneration, a fifth race in MVP, or an actual prototype. No existing governing file was modified by creating this audit note.
