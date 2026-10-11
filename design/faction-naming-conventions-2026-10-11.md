# Scalfagus — Canonical Three-Level Faction Naming Convention

Date: 2026-10-11
Status: **OWNER-APPROVED CANON** for the initial three civilizations.
This document supersedes the earlier exploratory version of this file and the provisional expanded names elsewhere. Do not auto-correct the owner's intentional spellings.

## Canonical matrix — EXACT SPELLING

| Stable machine ID | Short faction label | Mid / people name | Full formal backronym |
|---|---|---|---|
| `org` / **ORG** | **Organs** | **Organites** | **Organites Reproductive Generalismus** |
| `man` / **MAN** | **Manus** | **Manusians** | **Manusians Augmented Navigators** |
| `eth` / **ETH** | **Eters** | **Etherans** | **Etherans Transcendent Hypervisors** |

The full formal expressions are **deliberate backronyms**: O–R–G, M–A–N, E–T–H. The three-letter labels are simultaneously compact technical identifiers and initials of the long names. Preserve the expansions **verbatim**, including **Generalismus** and **Etherans**. Do not silently rewrite them to "Generality", "Organites", "Eterans" or "Etherians", or turn the full names into unrelated formal institutions.

The owner has approved all three full lines above. Earlier names and suggestions are no longer candidates for the original three faction naming tiers.

## Semantics / scope
- **`id`** = lowercase three-letter durable machine identity: `org`, `man`, `eth`.
- **`short`** = short UI / HUD / lobby faction collective label: `Organs`, `Manus`, `Eters`.
- **`mid`** = expanded people/civilization name: `Organites`, `Manusians`, `Etherans`.
- **`full`** = the exact in-universe long expansion of the initialism: `Organites Reproductive Generalismus`, `Manusians Augmented Navigators`, `Etherans Transcendent Hypervisors`.
- **Political state name** = a separate, optional future field (`polity_name`) if campaigns introduce multiple governments within a civilization. Do **not** reinterpret the approved full backronym as the name of a single polity unless the owner later says so.
- **Singular citizen terms** = not approved; never infer or hard-code them from mid labels.
- **MTG philosophy** remains ORG Jund (B/R/G), MAN Jeskai (W/U/R), ETH Bant (W/U/G). These three-color identities are thematic analysis, not magical factions restricted to only three attributes.

## Distinguish canonical levels from existing MIN/MID/MAX dimensions
The user casually describes expanded names as "mid", but do not reuse the capitalized game mechanics enum `MIN/MID/MAX`. Those already independently describe **match_scale** and **chassis_scale**. In code and configs use explicit field names `faction_id`, `name_short`, `name_mid`, `name_full`; do not create ambiguous `tier` or `name_scale`.

## Suggested active YAML fields
```yaml
factions:
  - id: org
    name: Organs
    name_short: Organs
    name_mid: Organites
    name_full: Organites Reproductive Generalismus
    name_initialism: ORG
  - id: man
    name: Manus
    name_short: Manus
    name_mid: Manusians
    name_full: Manusians Augmented Navigators
    name_initialism: MAN
  - id: eth
    name: Eters
    name_short: Eters
    name_mid: Etherans
    name_full: Etherans Transcendent Hypervisors
    name_initialism: ETH
```
`name` is retained as backward-compatible current short display label in design definitions. The full expansions are owner-approved strings; the suggested extra fields are an authoring interface, not proof of a running game parser.

## Player-facing usage
- HUD icons / unit tooltips: `ORG`, `MAN`, `ETH`.
- Match setup: `Organs`, `Manus`, `Eters`.
- Encyclopedia / selection: `Organites`, `Manusians`, `Etherans`.
- Full faction screen and campaign opening: `Organites Reproductive Generalismus`, `Manusians Augmented Navigators`, `Etherans Transcendent Hypervisors`.

## Superseded names and history (NOT canonical)
- Blergians / Blergian → `org` / Organs / Organites.
- "Manusians" **as the original short faction name** is superseded by Manus; **Manusians is NOW canon at the mid level**.
- Aetherians / Aetherian → `eth` / Eters / Etherans.
- Previous proposed Organians, Organites Free Lineages, Eterans, Etherians, Etherian Technocracy Hypervisors, Organian Republic of Guilds, Manusian Autonomous Nations etc. are drafts, **not** canonical.
- Old conversation notes are historical records and should not be silently rewritten to misrepresent what was discussed.
- Historical legacy identifiers only matter for a future migration script if an actual save format exists. New design runtime IDs must be lowercase `org/man/eth`.

## Intellectual-property and branding caution
The design goal is an original non-StarCraft identity, including distinct lore, aesthetics and abilities. Canonical selection is the owner's creative decision, **not legal trademark clearance**. Search for conflicting names/marks and check commercial storefront availability before external branding. Existing-name collision concerns around unapproved *Organians* / *Etherians* do not substitute for independent checking of the **new** choices.

## Decision precedence and related documents
1. **This file** is authoritative for name spellings and tier meanings.
2. [factions.yaml](factions.yaml) is authoritative for active faction identity fields and stable IDs.
3. [decisions.yaml](decisions.yaml) records owner-approved decisions.
4. [prior naming migration](faction-identity-rename-2026-10-11.md) is historical support for the `org/man/eth` transition.
5. [design bible](scalfagus-design-bible-2026-10-11.md), [hero and cameras](hero-progressions-and-three-cameras-2026-10-11.md), [three pillars](three-pillars-one-world-control-contract.md) describe gameplay, not alternate names.

**Owner-approved nomenclature does NOT approve five factions, a fourth playable machine civilization, untested balance or a finished game build.**
