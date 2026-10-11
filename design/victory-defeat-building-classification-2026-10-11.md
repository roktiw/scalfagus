# Scalfagus — Default Annihilation Victory: No Surviving Buildings

Date: 2026-10-11
Status: **OWNER-APPROVED DEFAULT MATCH VICTORY RULE**. Implementation tags, mode-invariant classification, simultaneous elimination and optional objectives below are engineering proposals until tested.
Decision: [DEC-024](decisions.yaml). Data: [match-rules.yaml](match-rules.yaml). Fixtures: [victory-defeat-acceptance-cases.yaml](victory-defeat-acceptance-cases.yaml).
Related new economic mechanics: [world loot, salvage, attrition](world-loot-salvage-and-recycling-2026-10-11.md) and [ORG/MAN/ETH 2/3/1 channels](three-network-channels-and-destruction-2026-10-11.md).

## Core user rule

**The default Scalfagus skirmish is won by destroying ALL surviving ENEMY BUILDINGS, including unit entities that count as buildings.** This is classic RTS building-elimination victory, NOT kill all mobile military units, all workers or every resource object.

Elimination is checked against **the economic faction/team ownership of valid living building entities**, not model mesh style, movement speed, whether a building is producing, or whether it currently looks like a tank. MAN buildings with wheels or tracks must remain targetable and count while they pack/travel, not evade elimination through mode swaps. A functioning ETH pylon/obelisk and ORG mitochondrion count as buildings; the original rooted ORG Nexus and ETH Nexus count; MAN has no single mandatory physical HQ by default.

A **UNIT can count as a BUILDING**. This classification is a gameplay/authority tag, not a graphics flag. Examples to specify per authored template:
- MAN UMU (Universal Man Unit), which is a modular mobile building even in packed ground travel: **counts as building**.
- MAN tracked MID which becomes conveyor, one-person bunker or sentry wall: **counts if its template is designated as a persistent infrastructure / building-class chassis**, including during travel/packing. The owner deliberately includes building-like units; exact MID template tagging should be frozen in unit config before MVP.
- MAN MAX moving depot/bunker, unless it is simply a separately authored non-structure cargo vehicle: **counts as building** when the unit class is the established deployable warehouse/bunker infrastructure.
- ETH MID Pylon/Obelisk (regardless storage, meditation, turret or eligible future relocation mode): **counts**.
- ETH MAX Nexus: **counts**.
- ORG rooted functional building, including the two mitochondrial energy organs and each completed living organ: **counts**.
- **ORG flying MAX mother cargo transporter**: does **NOT** count solely because MAX can aid some structures' growth; it is a transport animal, not a structure.
- MIN harvesters, ordinary fighters, HERO and specialist deployable-capable actors not explicitly tagged `victory_building`: **do not count**.
- Loose material packages (tetrahedron/cube/orb), unmined resource deposits, rubble, ruined frames, standalone supply cables, freestanding vascular conduit *segments*, transient Ether beams/edge queues and broken pylons with no surviving building entity: **do not count by themselves**.
- **Unfinished** cocoon/spore/frame/ETHER manifestation is not a *completed surviving building* for default elimination; it remains a construction site or ruin until genuinely finished. Design decision: this prevents spamming 1%-complete sites to delay defeat. Its physical loot, salvage and embodied inventory remain conserved and can exist after the match.

**Why persistent building identity matters**: player cannot dodge defeat by ordering UMU PACK while it was the last deployed building, and opponent must still destroy the surviving mobile structure. Equally, the game must not count a generic worker merely because it can build a structure.

## Proposed executable classifier

Each entity has stable tags/attributes:
`owner_team_id, life_state, entity_kind, victory_building, structural_template_id, construction_status, current_mode, is_illusion, hp, world_entity_id`.

A building contributes to its team count if ALL:
1. `victory_building: true` on actual authorized structural entity/template, not derived from visuals or a held tool;
2. `life_state == alive` and `hp > 0`;
3. `construction_status == complete` OR it is an **originally completed structural module presently packed/mobile/transformed**;
4. not mere ruin/abandoned scaffold, raw detached module, construction ghost, illusion or wreck;
5. legitimately owned by a live team, with capture/transfer resolved before count.

Modes do not change `victory_building`. An actual rebuilt structure only counts after successful completion, not as soon as a 1%-finished foundation begins. A completing scaffold and a destruction in the same fixed-step tick obey deterministic event ordering. Despawn/merge/morph of a surviving completed building must atomically **transfer building identity to exactly one resultant world entity** if the conversion is still alive, rather than having an uncounted intermediate tick.

Simplified end-of-authoritative-tick algorithm:

```text
resolve_orders_movement_combat_and_damage();
resolve_completed_morphs_deaths_captures_and_construction();
counts = count_live_victory_building_entities_per_team();

if game_phase != ACTIVE: do_not_evaluate();
else if only_one_team_with_count_gt_0: declare_that_team_victorious();
else if all_teams_have_count_0: declare_draw_or_scenario_tiebreak_after_simultaneous_elimination();
else: continue_match();
```

Allow ordinary surrender/concession to end early. For 2v2+ compute by **team**, not separately every allied player's personal inventory unless explicitly configured otherwise.

**Suggested zero-tick tie policy:** draw when all competing teams lose their last surviving building on the same simulation tick. If only one team loses its last building, the other team wins even if the destroyed player's Hero/workers can still move.

**No automated "recover from zero" exception**: once last structure is gone, a surviving builder and loose salvage do not rescue the match by placing a new foundation milliseconds later. The win check follows the deterministic authoritative event batch, not a discretionary ten-minute timeout.

## Optional mode — Heartstrike (not baseline, player-selected)

An *optional* scenario can additionally enable a **designated-heart/command-structure elimination** rule. This is a separately selected alternate victory condition, not a hidden requirement for default matches.

- ORG can use its home root Nexus as heart.
- ETH can designate an existing Nexus-class MAX.
- MAN's base is composite; there is **no canonical mandatory single Nexus building**, so Heartstrike must designate a physical command module as target **under explicit scenario rules**. Do not silently use "first UMU" as permanent unavoidable loss target.
- If a map cannot legally assign an appropriate opponent heart, the Heartstrike mode fails match validation.
- For future mobile hearts, assignment and ownership persist through packing; a moving heart is still the objective.

Other game objective types such as area control, escort, extraction and points are distinct optional scenario modifiers if implemented. **The default rule stays all-buildings-eliminated.**

## Why recycling does not create stalemate by itself

Physical resources on the battlefield may be scavenged and reprocessed with real losses, but **resource exhaustion is NOT the victory predicate**. Destroy/recover/rebuild loops strictly lose some inputs and cost worker-time, real freight, fuel and construction time; however even an extremely stock-rich opponent loses the instant they have **zero surviving actual building entities**. No scavenging from piles of stock, capturing abandoned cargo, or remaining workers prevents defeat after zero.

Keep match duration target (25–40 min) as a balance aspiration, not a victory timer. Monitor:
- game duration, fraction spent searching for the last mobile building, last-building escape exploit attempts;
- total original stock mined vs repeated salvaged stock and permanently lost materials;
- map control, capture/denial, site loot, army rebuild events;
- players with workers but no surviving buildings at terminal tick;
- final-building-class counts by faction (MAN mobility may require scouting/tracking but cannot evade targetability).

### Design test matrix

| Situation | Default expected outcome |
|---|---|
| Enemy owns 1 worker, 3 soldiers, 1 Hero, **0 completed building-class entities** | Enemy loses |
| Enemy owns only a moving but previously completed MAN UMU | Enemy stays in match until UMU is destroyed |
| Enemy MAN UMU changes from warehouse to bunker or packed travel | Count stays 1 |
| Enemy owns only completed ETH pylon in turret meditation | Enemy stays in match |
| Enemy has only incomplete ETH manifestation and physical Ether orbs | Enemy loses |
| Enemy has only decayed ORG cocoon, broken vein and mother flyer | Enemy loses unless any real completed viable ORG building survives |
| Enemy has one completed ORG mitochondrion at 1 HP | Enemy stays in match until it dies |
| Enemy has uncollected MAN crates and a salvaged ruin | Enemy loses |
| Enemy has only 1% ghost foundation + workers with materials | Enemy loses |
| Both teams destroy each other's final building in same authoritative tick | Draw/tiebreak scenario per declared config |

See precise scenario expectations in [victory-defeat-acceptance-cases.yaml](victory-defeat-acceptance-cases.yaml).

## Open balance and content tags

1. Exactly which tracked MAN MID templates are **structural building-class**, independent of mode. Proposed: the deployable belt/wall/bunker chassis qualifies, but not an ordinary resource-only vehicle.
2. Optional Heartstrike and team victory ownership/capture/ally sharing details; not part of standard annihilation.
3. Handling of scripted invulnerable or neutral dummy structures (exclude), garrison crews, lifeless living-building husks (destroyed vs disabled), and illusion cloning.
4. UI must clearly distinguish moving MAN buildings from normal units and display **Enemy buildings remaining** when endgame visibility or reveal rules allow; don't trivially disclose fog-protected secret outposts.
5. If last remaining structure hides forever and owner never yields, consider opt-in reveal/locator after objective-specific grace; this must not leak fog before actual victory or invent unapproved timed automatic elimination.

**Decision precedence:** Owner approved all-building loss rule (DEC-024) overrides older `victory_conditions: TBD` and makes it the default for all eligible ordinary skirmishes. This design classification note does not turn all military units into buildings or force ORG/ETH to have exactly one indispensable heart.
