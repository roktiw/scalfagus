# Scalfagus — Gameplay Roles, Autonomy, and Multiplayer
Date: 2026-10-11
Status: design discussion; distinguish approved directions from implementation proposals

## Three gameplay disciplines

One human player starts with one Hero (Engineer, Commander or Specialist starter kit), shared open pivotable talents, and may switch Overlord / Direct Unit / FPS perspectives; see [Hero and Three Cameras](hero-progressions-and-three-cameras-2026-10-11.md). This takes precedence over older language placing *all* possession after MVP: minimal FPS is required in the internal playable MVP, advanced FPS later.

1. **Architect (simulation/Factorio):** construction, production, storage, resource flow, logistics, base connectivity and infrastructure.
2. **Commander (classic RTS/Warcraft/StarCraft):** reconnaissance, strategic objectives, combat groups, orders, formations, defenses and battlefield control.
3. **Avatar (Dungeon Keeper possession; eventual FPS):** direct control of a compatible unit. Advanced Quake III-style FPS is well beyond MVP.

These are capabilities, not compulsory player slots. One player can perform all three roles; a faction may have one, two, three or more human players. Full shared control is the simple early model. Configurable role-based access control (RBAC), exclusive permissions and detailed arbitration are explicitly deferred beyond Alpha.

## Flagship match formats
- **3v3:** preferred competitive/ranked target, three players per faction/team.
- **3v3v3:** flagship showcase target, three factions with three players each, nine total.
- Solo, 1v1, 2v2 and flexible team sizes should be possible subject to actual technical and balance constraints. Three roles do not imply exactly three players.

## Faction-to-role affinity
All factions support all roles; each emphasizes one:
- **Organs -> Architect/simulation:** living biomass infrastructure; disconnected islands are weak, mother-base connectivity provides major synergies.
- **Manus -> Commander/strategy:** modular, tactical, highly dispersed and relatively autonomous outposts; best value from independent islands.
- **Eters -> Avatar/direct control:** expressive psionic and resonance-based units; balanced satellite viability, with an advantage toward connection to the mother base.

Affinity means richer decisions and distinctive skill expression, not an unconditional power multiplier. Each of the nine faction × role combinations should be meaningful.

## Autonomous units: Dungeon Keeper imps + Factorio drones
Every MIN, MID and MAX unit has an autonomous task/doctrine framework. Actual mining, transport, construction, repair or fighting actions require the correct chassis modules, capabilities and orders. Workers can repeat configured routes, transfers and production support, respond to local threats, and report blocked tasks. They must not autonomously choose strategic expansion or override explicit player intent.

Proposed priority: direct Avatar control > explicit player orders > assigned doctrine > autonomous task > idle behavior. Conflict resolution for multiple human players needs later design and testing.

## Unit AI and progression
- Configurable doctrines: defend, patrol, escort, attack, retreat, harvest, repair and similar role-appropriate behaviors.
- Experience from meaningful activity, not just kills.
- Organs: adaptation and irreversible mutations.
- Manus: training, specialization and modular equipment proficiency.
- Eters: meditation, resonance mastery and costly reversible ascension.
- Experience must not erase MIN/MID/MAX chassis tradeoffs or replace the technology tree.

## Functional base synergies
- **Organs:** weak isolated satellite bases, strong biomass connection to mother-base ecosystem. Isolation should not make them entirely unusable; disruptions need counterplay.
- **Manus:** strongest standalone islands and distributed infrastructure, but pay real transport, protection and module-supply costs.
- **Eters:** moderately capable satellites with a clear advantage when linked to the central resonance/homeworld core.

## Other Dungeon Keeper 1 inspirations considered
Territory claiming; functional rooms; imps; training; creature needs and personalities; traps and doors; dungeon heart; prison/conversion; Keeper spells; Hand of Evil. These are inspirations, not all approved features. Avoid excessive morale micromanagement, free unit teleportation, or copying protected characters/artwork.

## Phasing
**Alpha:** classic 2D RTS controls, economy, autonomous units, doctrines, progression, base synergy prototypes, retro UI; avoid premature 3D.
**Later:** advanced logistics, flexible multiplayer teams and permissions/RBAC, showcase 3v3v3, possession and ultimately retro FPS. Exact milestone allocation is provisional.

## Open questions
- Autonomy budget, task ownership, doctrine override, idle defaults.
- Precise base-connection effects and interruption behavior by faction.
- Whether experience belongs to chassis, operator, biological core or modules.
- Shared-player conflict arbitration, server authority, permission schema.
- Competitive balance for 3v3 and three-sided 3v3v3.
