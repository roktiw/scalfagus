# Scalfagus — Three-Layer Faction Naming Convention

Date: 2026-10-11
Status: **proposal**, not an additional approved rename.

## Already approved
- IDs: org / man / eth.
- Short UI labels: Organs / Manus / Eters.
- These replace obsolete Blergians / Manusians / Aetherians as **canonical faction labels** in active runtime-facing definitions.
- See faction-identity-rename-2026-10-11.md.

## Never use MIN/MID/MAX for name levels
MIN/MID/MAX already describe *match scale* and separately *chassis scale*. Do not add third contradictory usage. Prefer:
1. **id** (3 lowercase letters, stable machine key): org/man/eth.
2. **display_name** (short player-facing faction label): Organs/Manus/Eters.
3. **people_name and singular_person** (ethnonym/demonym; optional): name for members, language and lore, not automatically equal to the polity.
4. **polity_name** (long formal political/institutional name): one federation, state, guild union or concord, not one obligatory universal biological species title.
5. Optional epithet for scenario flavor.

This is not an acronym system: ORG should not be retroactively forced to mean "Organsians Race Generality." A faction ID is an identifier. Proper long names should express actual institutions and their worldview.

## User-proposed medium expansion (NOT approved)
| id | short | expanded candidate | potential formal title |
|---|---|---|---|
| org | Organs | Organians | Organian Assembly of Living Guilds |
| man | Manus | Manusians | Manusian Interstellar Commonwealth |
| eth | Eters | Etherians | Etherian Resonance Concord |

### Original-IP warning: found existing names
- **Organians** are an existing incorporeal energy-based alien species in **Star Trek**, from Organia. This is an exact naming collision and (coincidentally) much closer to the concept of Eters than Organs. See https://memory-alpha.fandom.com/wiki/Organia_system .
- **Etherians** is used for peoples of **Etheria** in **She-Ra**, and the World of Ether setting also names its beings Etherians. See https://she-raandtheprincessesofpower.fandom.com/wiki/People_Groups and https://docs.worldofether.com/ .
- **Manus** occurs in other media and language usages; Manusians not verified as unique.
- This is preliminary web collision research, NOT a trademark clearance or legal opinion. Before commercial release, check relevant trademarks, confusing similarity, localization and game-store naming.

## Alternative expanded names for testing (NOT approved)
| id | short | people_name proposal | singular_person | formal political title example |
|---|---|---|---|---|
| org | Organs | **Organites** | Organite | **Organite Free Lineages** |
| man | Manus | **Manusians** | Manusian | **Manusian Expeditionary Commonwealth** |
| eth | Eters | **Eterans** | Eteran | **Eteran Resonance Concord** |

These are phonetic/semantic proposals only, NOT guaranteed original or cleared. Other candidate systematic family: Organids / Manusids / Eterids, but "-ids" may feel clinically taxonomic. Short approved labels are sufficient for MVP; people names can stay optional until lore development.

## Institutional distinction
- **Organs** represent independent biological organisms and diverse lineages. A **Free Lineages** or comparable coalition is more consistent with the owner's **anti-hive-mind** requirement than a single collective mind.
- **Manus** describes human-origin industrial communities with humans, cyborgs, robots and independent AI. A Commonwealth of Colonies/Guilds reflects loose economic and political organization.
- **Eters** represent distinct resonant/advanced beings, technologists and spiritual schools. **Concord** expresses voluntary cooperation and avoids compulsory mind fusion.
- Individual species, cultures, political factions and technological orders may overlap but are NOT the same schema entity. One faction can include many species; one species can have several political factions.

## Data convention (example proposal, not active runtime schema)
    faction_id: org
    display_name: Organs
    people_name: Organites
    singular_person: Organite
    polity_name: Organite Free Lineages

Names are separate localization fields; identifiers must not be derived from localizable labels. Use org/man/eth in data/telemetry/qualified unit IDs.

## Examples
- Lobby: ORG — Organs | MAN — Manus | ETH — Eters.
- Short unit: ORG / Worker / MIN chassis.
- Lore encyclopedia: "Organites" (people) vs "Organite Free Lineages" (one confederation).

## Decision register
- Q1: Do expanded people names belong in MVP at all? Recommendation: leave optional until lore.
- Q2: Should UI faction names remain Organs/Manus/Eters or show longer names?
- Q3: Which expanded alternatives are distinctive enough after real IP search?
- Q4: Are formal full titles universal names or names of particular political organizations? Recommendation: political.
- Q5: Is an optional second "military order" name useful as a separate scenario-level field?

No approved YAML name is changed by this document. See design/hero-progressions-and-three-cameras-2026-10-11.md for separate player-hero system.
