# Scalfagus — Faction Naming Decision: Organs / Manus / Eters
Date: 2026-10-11
Status: **approved by project owner for the original three faction identities**, not a decision to add more playable races.

## Canonical names and stable short IDs
| Canonical faction name | Canonical ID | Legacy name | Inspiration / focus |
|---|---|---|---|
| **Organs** | `org` | Blergians / Blergian | Independently specialized organic organisms, evolution, living infrastructure; Jund (B/R/G) |
| **Manus** | `man` | Manusians / Manusian | Humans, modular industry, individual technology and autonomous machines within human-origin civilization; Jeskai (W/U/R) |
| **Eters** | `eth` | Aetherians / Aetherian | Advanced living and technological, psionic/energy/resonance civilization; Bant (W/U/G) |

Owner decision: the name **Blerg** felt too close to **Zerg**; the new set is intentionally short, direct and independent of StarCraft naming. These names are creative working identifiers; clearance and distinctiveness checks for commercial IP/marketing are **not completed**. Especially "Organs" is an ordinary English word, so do not assume protectability or search uniqueness.

### Usage
- UI/display names: `Organs`, `Manus`, `Eters`.
- All new YAML/JSON key values, faction identifiers, API `faction_id`, scenario files and balance datasets: **`org`, `man`, `eth`**.
- Singular references can use "an Organ", "a Manus individual", "an Eter"; avoid exposing singular taxonomy before lore editorial approval. In written faction names prefer `Organs`, `Manus`, `Eters`.
- Unit ID prefixes: `org_...`, `man_...`, `eth_...`; faction-qualified templates: `org.worker.min`, `man.shooter.mid`, `eth.specialist.max`.
- Do not create a new fourth/fifth race by inference. Independent machine people remain a **separate research candidate**, outside MVP.

### Migration semantics
- **Do not** treat legacy IDs as valid keys in new runtime YAML. Migrate all current active design/config data and references to the canonical short IDs.
- Historical discussion notes intentionally retain original words when they **quote past proposals**. They are noncanonical and should refer here for current nomenclature.
- If a game save or network client with legacy IDs ever exists, write an explicit versioned importer that maps `blergians -> org`, `manusians -> man`, `aetherians -> eth`. There is currently no shipped game save format; **do not add indefinite runtime aliases before needed**.
- Race philosophy/MTG mappings, resources Matter/Volatiles/Energy, 7 unit archetypes, chassis scales and gameplay mechanics do NOT change as a consequence of the rename.
- Original StarCraft, Alien, Predator, Warhammer, Quake and Lem references remain inspiration only. Create original assets, rules, lore and symbols.

## Known legacy strings for migration/search
`Blergians`, `Blergian`, `blergians`, `blergian_`;
`Manusians`, `Manusian`, `manusians`, `manusian_`;
`Aetherians`, `Aetherian`, `aetherians`, `aetherian_`.

## Three-camera Hero system — preserved
Each player starts with a Hero using Engineer, Commander or Specialist starting kit, one open branching talent graph and the three observation/control modes **Overlord**, **Direct Unit**, and **FPS possession**. Rename does not alter these rules.
- [Hero contract](hero-progressions-and-three-cameras-2026-10-11.md)
- [MVP contract](mvp-iso-pixel-rts.md)
- [Product constitution](product-principles.md)

## Ownership and source precedence
This document overrides legacy faction naming in earlier exploration/bible/dated discussion docs. `design/factions.yaml` is the canonical active faction registry. Keep historical discussions as historical rather than silently rewriting debate text.
