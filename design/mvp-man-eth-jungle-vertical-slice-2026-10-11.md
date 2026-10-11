# Scalfagus MVP 0.1 — MAN vs ETH on Verdant Divide

> **Current release scope reconciliation — DEC-033 (2026-10-11):** Post-MVP0 asymmetrical MAN versus ETH candidate; original owner DEC-025 two-faction-first release superseded by DEC-033 MAN mirror MVP0. Keep five roles per faction and one Ether graph for future, not current.
>
> **CURRENT executable release: [MAN mirror scope](mvp0-man-mirror-rts-2026-10-11.md), [active numbers](mvp0-man-mirror-balance-v0.1.yaml), [execution](mvp0-man-mirror-execution-contract.md), [authority](mvp0-man-mirror-network.yaml), [M0 backlog](mvp0-man-mirror-backlog.yaml), [acceptance](mvp0-man-mirror-acceptance.yaml).**


Date: 2026-10-11
Status: **owner-scoped two-faction / solid-only MVP; authored implementation proposals require playtesting, NOT owner approval for names, numbers or final map**.
Decision log: [DEC-025](decisions.yaml).
Structured starting data: [catalog](mvp-man-eth-catalog.yaml), [jungle map](mvp-verdant-divide-map.yaml), [acceptance cases](mvp-man-eth-acceptance.yaml).
**Latest DEC-030 / CANON:** **ALL** playable Scalfagus maps are floating platforms in outer space, including this first playable. MVP Verdant Divide remains a square PLANAR battlefield with hard four-side collision walls, but the **actual level/world must visibly be an enormous stationary flying jungle deck**: brown real soil, trees and cover, freshwater pools, outer rim/underside and distant space. Surface materials may later be metal patchwork, desert or other original biome, but `floating_space_platform` is required for every map. The platform does not move, count toward victory, permit flying, or introduce a sphere. See [world constitution](space-platform-world-contract-2026-10-11.md), [mandatory map frame](battlefield-frames.yaml), [map data](mvp-verdant-divide-map.yaml), and [agent delivery gates](MVP-DELIVERY-GATES.md).

Main earlier MVP scope: [three cameras + Hero](mvp-iso-pixel-rts.md). Do not silently discard the one-world/three-camera product promise; implement first RTS loop before final Hero camera acceptance.

## Product goal and strict scope

**Owner requests the first playable two civilizations to be MAN (Manusians) and ETH (Etherans), with only surface SOLID resources distributed across the map**. Five minimal economic/combat roles for **each**: **mother/HQ, worker, basic soldier, basic infrastructure (UMU or Pylon/Obelisk), barracks**. The first map is an **Earthlike exotic jungle growing on a massive spaceborne platform**, because trees can be meaningful natural defensive cover and the owner likes trees. No ORG gameplay in MVP 0.1.

**Role counting**: 5 functional templates per faction, not 5 military units; each faction has 3 structures and 2 ordinary units. The existing Hero can use the soldier actor/model/weapon with a `hero` capability and one ability, **not a sixth unique art/model chassis in the first slice**. Headless simulation and basic RTS match must work before all three camera adapters are feature-complete.

**No liquid pools or gas vents as harvestable sources in this initial two-faction map**. No pumps, gas extractors, liquid/gas logistics or related resource recipes in this build. DEC-016 solid/liquid/gas rules still exist for later maps. Canonically Matter, Volatiles and Energy are distinct economic IDs, **not automatically identical to SOLID/LIQUID/GAS**. For MVP 0.1, each SOLID world deposit yields a counted finite **Matter** packet (temporary explicit source-form conversion mapping, not universal law), Volatiles is unavailable and no active recipe can require it, and Energy is supplied from a valid, finite-rate external-source generator or starter reserve. Energy is still accounted and spent; it is **not** a gas and not an untracked free global grant.

**Owner-locked default victory** (DEC-024): lose ALL living, completed, building-class entities, including mobile MAN UMU and completed ETH pylons while in any legal mode. Alive MINs, soldiers, Hero, cargo packets and incomplete sites cannot keep a player alive. No mandatory mother-only kill, no exhaustion win, no hidden timer.

## 1. Exactly five roles per faction

| Role | MAN template / recommended working name | ETH template / recommended working name | Gameplay function | Victory building? |
|---|---|---|---|---|
| Mother / HQ | **MAN Command Core** (MAN Nexus-equivalent command configuration) | **ETH Nexus** (MAX from deployment) | Starting command node, initial finite storage/energy reserve, produces MIN workers, provides baseline support; ETH also converts real incoming raw Matter into typed Ether | **YES** |
| Worker | **MAN MIN / SCV** | **ETH MIN / Courier-Channeler** | Direct SOLID harvest, true finite cargo and delivery, build; MAN physical assembly and repair, ETH occupied blue-beam NETWORK build | NO |
| Basic soldier | **MAN Rifleman** | **ETH Sentinel** | Basic ground ranged combat, modest building damage, one simple common health/targeting/LOS model | NO |
| Infrastructure / Farm | **MAN UMU** (Universal Man Unit; existing ground mobile depot-bunker family with generator kit) | **ETH MID Pylon/Obelisk**, one template | MAN generates real Energy/runs local grid and chooses warehouse OR bunker; can pack and travel on ground. ETH adds resonance cap, relays one Ether graph including typed Matter, Energy and information, storage OR turret | **YES**, including mobile/mode variants |
| Barracks / production | **MAN Barracks** | **ETH Manifestation Chamber** | Trains/manifest soldiers using exact locally legal paid resources; production obeys support cap and actual operating Energy; no mandatory second advanced tech building | **YES** |

All names other than owner-established UMU, Pylon/Obelisk and Nexus are **provisional**, deliberately compatible with existing MIN/MID/MAX ecology without spawning an extra mandatory MAN `Power Dock` alongside the UMU. In the MVP the MAN mother is a **Command Core configuration** of modular HQ equipment, not an additional fully independent heavy warehouse/bunker competing with UMU; it can be anchored for this first map even though UMU itself must be ground-mobile. Exact eventual HQ mobility is a later decision.

**Mother production and lack of softlock**:
- Each player **starts with a completed mother, 3 MIN, and starter Energy reserve**, but 0 stored Matter. Each starts with enough support slots for 3 MIN plus one Hero-class actor.
- Mother's starter Energy allows first construction. MAN can then build a deployed generator-equipped UMU without needing liquid/gas; ETH Nexus has slow legal background ambient resonance/Energy generation to power the first Pylon (or starts with finite enough reserve for one); per-tick Energy generated is a real accountable increment from a named external environmental source.
- Mother **produces MIN** without an additional worker building. Barracks produces soldiers. Never require MAN to build a separate fourth energy plant or ETH to construct a new MAX just to acquire first Pylon.
- MAN Command Core provides a finite receiving depot port. ETH MIN must bring Matter to a **real Nexus** before a typed Ether packet can enter the one network. ETH pylon creation still requires occupied blue ETH MIN NETWORK beam to a valid large Nexus.
- All construction and new-unit training costs are real positive Matter/Energy inputs after valid custody/transfer. No free troop generation from mere support cap.

## 2. Intended first match, not a fixed timer

1. **Spawn:** two opposite jungle clearings. Each side has an HQ and 3 MIN; optionally one Hero actor based on the shooter archetype for the controls/three-camera milestone.
2. **Harvest:** select MIN, click one of the dispersed SOLID rock/deadwood nodes; MIN collects **finite Matter**, returns to local legal HQ port, amount is in player-owned inventory at that actual receiver only.
3. **Infrastructure:** MAN builds a ground-mobile UMU using 1→2→2 phase max assemblers and physical crates; ETH builds a stationary Pylon via 1→2→3 occupied blue-beam MIN contributors and real network stock.
4. **Power/support:** UMU deploys, becomes powered and increases operational headroom; ETH pylon increases resonance cap and opens extra Ether network topology.
5. **Production:** build first barracks/manifestation chamber, train 1–3 soldiers after actual delivery/payment and supply check.
6. **Scout and clash:** soldier scouts one jungle lane, trees block real lines of fire and movement; no tree chopping needed. Enemy bot runs same economy and finite resource rules.
7. **Win:** damage every completed enemy building-class entity, **including a fleeing packed UMU**. Enemy surviving workers and loot cannot stall a declared defeat. Surrender available.
8. **Replay/check:** identical seed + command log must produce same account movements and death result on fixed tested runtime.

**One shared map** with 3D world space: overhead orthographic isometric sprite presentation, valid first-person collision and ray LOS. A foliage fade shader is visual only and must NOT change actual visibility, projectile collision, fog ownership or targeting.

## 3. Specific race contrast that the 5-role catalog must demonstrate

| Interaction | MAN | ETH |
|---|---|---|
| SOLID worker collection | No mine building; real chunks/crates per trip | Same source accessibility; MIN carries real Matter to Nexus |
| Where finished SOLID Matter is stored | Physical Command Core/UMU inventories; trucks/MIN must carry building materials to site | Nexus converts deposited Matter into typed Ether; pylons hold counted per-node stock |
| Infrastructure | UMU deployed warehouse/power OR bunker, can pack and move over land | Pylon/Obelisk anchored, storage/relay OR turret, contribution to resonance capacity |
| Communications/energy | Small **hybrid** conductor+fiber links can connect deployed structures; no material teleport; startup local battery | **One** graph relays typed Matter, information and Energy, bounded by link/node rates |
| How barracks is built | MAN MIN assembles with 1→2→2 max workers and locally delivered packets | ETH MIN holds blue NETWORK beam, 1→2→3; requires valid Nexus link and routed typed Ether |
| What interruption does | Installed MAN scaffold persists; uninstalled site crates can be stolen; salvage installed structure by mining after ruin | If last required blue beam is broken, progress instantly dies; **all actually site-committed materials** spill as collectible ETH orbs at build spot, time/operating Energy lost |
| Battle damage and drops | Origin **cube**, solid-amber | Origin **orb**, solid-amber; world orb does not automatically reenter Ether Network |
| Default victory | Command Core, Barracks, UMU count; UMU travel cannot dodge counting | Nexus, Barracks/Manifestation Chamber and Pylon count even in meditation/turret |

Do not construct a second ETH network for info or a third ETH energy line in the MVP. The owner explicitly defined ETH one network. Do not make wood/standing jungle trees infinite universal harvesters by default; use distinct scattered **deadwood logs** and rocks as loose SOLID nodes on first map, while living large trees are cover.

## 4. Proposed map — Verdant Divide, 64×64 fields

- **Terrain/biome:** original, lush alien jungle on an exotic planet; humid cyan/magenta bioluminescent accents are atmospheric cosmetics, not extra gameplay resources.
- **Start corners:** northwest and southeast, roughly diagonally opposed and mirrored in effective path length/safe SOLID mass for fair MAN↔ETH matchups; full bilateral aesthetics may differ without altering gameplay.
- **Routes:** (1) open central clearing with the largest contested SOLID patch; (2) winding north forest corridor with tree-trunk cover, limited chokepoints; (3) south shallow dry ravine/understory flank with broader crossing. At least two independent walkable paths survive without clearing a tree.
- **Sources:** finite little surface rocks/deadwood in multiple small patch clusters: starting zones and extra contested pockets. **Only** SOLID nodes are extractable. Nothing in the first stage requires a pump, gas rig or tree-cutting tech. Trees stay intact even when the last resource node is depleted.
- **Cover:** living tree **trunks**, rooted giant plants and fallen solid trunks are actual collision + hard line-of-fire/LOS blockers. Leafy crowns/canopy do **not** contribute extra independent collision or accuracy modifiers in the first MVP; their art fades when hiding selected/player units. The cover must work in RTS, Direct and FPS on the SAME ray/collision geometry. Cover does not automatically block pathing along a clear lane.
- **Geometry:** mostly flat for first resource/combat test, with **one small authored rise or gentle ramp** to test same 3D world in the engine spike. No destruction of trees/terrain, procedural jungle, large caves, water extraction, flying combat or dynamic navmesh until later.
- **Balance targets:** equal accessible starter Matter per side, one obvious central contest, multiple meaningful flanks. Avoid a giant forest wall giving ETH free safe pylon segmentation or a trunk choke MAN UMU cannot pass.
- **Camera readability:** distinctive tree silhouettes and transparent canopy over obscured units; minimap shows traversable roads and sources, not a sea of irrelevant detail. Test cover from FPS eye-height and overhead; no projectile shoot-through due to inconsistent sprite render/3D collision.

An **illustrative** opening fixture for first balance tests: 2 near-home deposit clusters per side holding 200 Matter equivalent each, 1 center patch holding 400, and 2 side contested pockets holding 150 each; counts and distances are intentionally tunable. Favor symmetric **accessible** amounts; raw screen positions do not guarantee fairness when a mobile UMU can relocate or ETH workers need Nexus admission.

## 5. What MUST be written before production coding

| ID | Priority | Contract / deliverable | Questions that must be answered | Proposed artifact |
|---|---|---|---|---|
| MVP-01 | P0 | **First match rules** | Two factions only; human vs ETH/MAN bot; spawn assets, baseline victory and safe restart | `mvp-man-eth-catalog.yaml` + `match-rules.yaml` |
| MVP-02 | P0 | **Five-template catalogs** | IDs, tags, HP, footprint, base speed, legal modes, production ownership, support demand, victory-building flags | `mvp-man-eth-catalog.yaml` |
| MVP-03 | P0 | **One-resource economy** | Source solid-to-Matter mapping, starting reserve, finite carry, harvest rate, hauling, build/training prices, Energy bootstrap and no Volatiles recipes | `mvp-man-eth-catalog.yaml` |
| MVP-04 | P0 | **Combat contract** | Soldier vs soldier/building stats, range, LOS through trees, damage/cooldown, aggro, target priority, garrison/turret limits, friendly fire | Future `mvp-combat.yaml`; example baseline in catalog |
| MVP-05 | P0 | **Map/trees** | 64×64 paths, spawn, rock/deadwood locations, tree trunk cover, obstacle collision, navigability, single ramp and forest fade | `mvp-verdant-divide-map.yaml` |
| MVP-06 | P0 | **Build/training lifecycle** | MAN delivery + 1→2→2 work slots; ETH Nexus + blue beam + 1→2→3 slots; canceled/destroyed progression; barracks queue | `mvp-man-eth-catalog.yaml` and existing `construction-phases.yaml` |
| MVP-07 | P0 | **Infrastructure state machines** | UMU DEPOT/BUNKER/PACKED; Pylon STORAGE/RELAY/MEDITATION/TURRET; permitted shared and exclusive duties | `mvp-man-eth-catalog.yaml` |
| MVP-08 | P0 | **Resource custody + loot** | Physical MAN cube vs ETH orb, source->worker->storage->build, drops, salvage partial MAN frame vs ETH instant complete site ingredient drops | Existing `world-loot-and-recycling.yaml`; fixture below |
| MVP-09 | P0 | **ETH network simplification** | Nexus conversion, finite per-node stock, route, equalization, cut/merge and availability for a single resource | Existing `eth-ether-network-mechanics.yaml` plus test fixtures |
| MVP-10 | P0 | **MAN power/data simplification** | Local automatic short-range hybrid lines vs physical Matter crates; first generator/battery, no mandatory long cable planning | Existing `three-network-channels-and-destruction.yaml` |
| MVP-11 | P0 | **AI/autonomy** | Harvest/build/train/raid cycle, react to invalid stock/power, target buildings, not free hidden map vision, ordinary worker auto-fetch | Future `mvp-bot-behavior.yaml` |
| MVP-12 | P0 | **UI/UX** | Select/move/attack/harvest/build/produce, health and support, used/local available Matter, vision, minimap, mode buttons, defeat/restart | Future `mvp-hud-and-input.md` |
| MVP-13 | P1 | **Single-world hero/cameras** | One Hero variant, Overlord->Direct->FPS->Overlord actor continuity and one shared ability; no double hit or independent 2D map | Existing `three-pillars-one-world-control-contract.md` |
| MVP-14 | P0 | **Engine proof + sim tests** | Deterministic authoritative tick, basic pathfinding, cover/LOS, no duplicated resources/loot, match end with packed UMU, replay | `mvp-man-eth-acceptance.yaml` |

**Ordering:** P0 does not imply every numeric value must be scientifically balanced before coding. Author starter numbers, mark `example_for_playtest`, execute 1v1, then adjust costs/timing. Story, multiplayer, advanced research, combat skill trees, third race, liquid/gas and mobile ETH pylon research are out of 0.1.

## 6. Provisional balance seed for the first simulation only — NEVER silently canon

One resource loop: `SOLID_WORLD_SOURCE -> MIN_cargo -> MAN_storage / ETH_Nexus -> actual_Matter_paid_to_building_or_unit`. Treat 1 source unit = 1 Matter as **MVP-specific explicit sample recipe**. No Volatiles source or spending in this map. Energy is separate, metered, already stored at spawn and/or produced at a fixed finite rate by a legitimate operational unit with declared environmental input; **do not** spend nonexistent gas/liquid or grant untracked Energy every frame.

Suggested equal first test (tune to match length and army survivability): start **3 MIN, 1 completed mother, 0 Matter, finite starter Energy**, no completed UMU/Pylon/barracks. Worker carries **8 Matter per trip**; baseline `harvest_time_per_Matter: 2 seconds`, travel/path time not eliminated; first infrastructure roughly **40 Matter**, barracks **60 Matter**, ordinary soldier **20 Matter**, replacement MIN **15 Matter**; rebuild mother higher cost (example **150 Matter**) so expanding before headquarters loss matters. Unit/build HP, DPS and source density still require combat fixture choices. No balance claim from these integers.

MAN can initially use a small HQ **starter battery** to assemble its first UMU. UMU may recharge/deploy only when powered under finite rate and placement. ETH Nexus initially has enough E to seed its first Pylon and can convert delivered Matter into Ether under finite cost and throughput. Exact E-production recipe and recharge location are independent decisions; use a named `environmental_energy_intake` as external source with positive bounded `E/tick`, rather than conflating Energy with SOLID matter or raw gas.

**Important edge case:** ETH could lose its last Nexus while a pylon survives. Under DEC-024 its team still has a building and thus is not automatically defeated; but its ability to originate new Ether or new construction may be crippled. Decide if a very expensive legal emergency Nexus reseeding is needed, or whether the player may survive tactically with existing resources until enemy finishes the pylon. No rule granting free Nexus just to prevent this vulnerability.

## 7. Criteria for first playable acceptance

See [mvp-man-eth-acceptance.yaml](mvp-man-eth-acceptance.yaml). MVP 0.1 is testable when:
1. Player can pick MAN or ETH and start on identical fair jungle topology; bot can use either faction without omniscient access.
2. MIN gathers free-standing finite rock/deadwood Matter without a mine, and no liquid/gas extractor exists on map.
3. MAN physical build stack and UMU can function and **UMU counts toward elimination even when packed/moving**.
4. ETH Nexus converts Matter only after true raw worker delivery; pylon paths carry counted resources/Energy/info and links split without duplicating stock.
5. Each can build the infrastructure structure and barracks, pay Matter, train soldier, move and attack behind destructible? **No:** **indestructible tree trunk cover in first release**, but fighting around trunks changes results.
6. Broken construction and destroyed assets materialize honest loss-bearing recoverable cube/orb stacks; competitor can pick up opponent's resources.
7. Enemy buildings all destroyed -> win, including barracks/Pylon/UMU regardless of mobility; surviving soldier/workers/ruin not prevent ending.
8. Hero variant can in a follow-on internal MVP gate switch three camera modes on the exact same actor.
9. Only a small number of enemy/ally assets are present; frame rate remains acceptable, units do not path into trees, fog/collision is consistent between perspectives.
10. Saving replay of fixed seed + commands yields the same resource total and victory outcome in the same pinned runtime.

**Explicit not yet approved:** biome title, exact map dimensions, HP/damage/build costs, how a MAN Command Core relates to an eventual roaming composite Nexus, production queue details, equalized Ether bandwidth numbers, permanent tree indestructibility beyond the first slice, actual Energy generator recipe, and whether separate Hero capability appears in the earliest *MAN mirror* test or only after the two-faction playable RTS gate.
