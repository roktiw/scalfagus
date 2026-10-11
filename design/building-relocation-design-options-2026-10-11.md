# Scalfagus — Can Buildings Move? Controlled Relocation Options and Precedents

Date: 2026-10-11  
Status: **OPEN DESIGN / RESEARCH / NOT APPROVED CANON**. Record of owner questions and assistant recommendations; no blanket building transport implementation is authorized by this document.  
Companion: [building-relocation-options.yaml](building-relocation-options.yaml).  
Current approved baseline: [base ecologies](base-ecologies-and-expansion-2026-10-11.md), [colony topologies](colony-topologies-vascular-modular-resonant-2026-10-11.md), [deployable rules](deployment.yaml), [economic unit scales](logistics-unit-scales.yaml), [conversation record](faction-economy-and-construction-conversation-2026-10-11.md).

## 1. The actual design question

The owner asked whether to:
1. Allow very **slow, expensive transfer of existing ORG buildings through vascular vessels** to another legal point of the living network;
2. Allow ETH buildings to move **more quickly through a directed resonant "railgun beam" across network nodes**, distinct from basic construction beams;
3. Keep MAN's already-established, physically movable and modular buildings;
4. Or **restrict building transport for all three** because unrestricted mobility could erase expansion's strategic geography, overload the game with micro-management and undermine the StarCraft-like importance of choosing where to found a base.

The owner's final message began another idea concerning the **ETH MAX pylon/Nexus**, but the message ended before the idea was described. **Do not invent, approve or implement it.** Current ETH economic MAX is the **Nexus-class** hub; MID is the storage/relay/turret pylon.

## 2. Important distinctions — never conflate them

- **Construction:** pay resources and builder time to place a *new* building at a permitted site. ORG requires live vessel; ETH MIN sustains a blue beam to eligible large node.
- **Unit self-deployment:** an explicitly deployable chassis changes form/function (MAN MID conveyor → wall/bunker or MAX depot → bunker; ETH MID pylon storage → turret). This is a **mode switch**, not moving a building between coordinates.
- **Module repositioning:** MAN already has mobile specialized buildings/production vehicles that pack, physically travel, unpack and reconnect. They cease to function while packed/moving, and their location/footprint and materials remain real.
- **Meditation / levitation:** certain explicitly capable ETH structures may spend time and Energy to relocate at bounded speed. This is a *selective* previously described capability, not universally unlocked.
- **Full building transplant:** retain a particular structure's persistent identity, progression and (subject to explicit constraints) state while physically/logistically transferring it to a new site. This is the **NEW, unresolved** extra feature.
- **Demolish / salvage / reconstruct:** remove a structure, recover some actual physical resources, build a *new* instance elsewhere. This is **not** automatically equivalent to preserving the same building's identity/level and garrison.

## 3. Candidate permission model — assistant recommendation, NOT yet approved

Rather than saying "all structures move", assign each structure template one policy:

| Candidate class | Example | Relocation eligibility | Why keep this class |
|---|---|---|---|
| **ANCHORED** | Root Nexus, terrain-bound ore extractor, vital colony seed, deep foundation | Cannot move in a normal match; may salvage/rebuild if legal | Gives founding/expansion a permanent geographical stake |
| **RELOCATABLE** | Specific ORG tissue building, MAN modular factory, selected ETH energy structure | Only through a typed faction-specific paid process | Supports faction character without turning every building into a vehicle |
| **MOBILE LOGISTICS** | ORG living mother, MAN tracked 3/5-tile conveyor MID, MAN ground depot MAX | Can physically move as an economic unit within domain/range constraints | Mobility is the chassis's ordinary gameplay loop, not an exploit |
| **MODE-SWITCHING ONLY** | ETH MID pylon turret, a static warehouse with alternate behavior | Can change duty locally, *cannot change position* unless another capability explicitly grants relocation | Separates defensive flexibility from global geography |

**Recommendation:** no universal move command for all structures; explicit `relocatable`, `mobile_logistics`, `deployable`, `levitate_capable`, and `anchored` should be **separate capabilities** in the entity schema. Never give mass transport through a MAX slot as a magical shortcut for large rooted structures.

## 4. ORG option — vascular building transplantation (OPEN)

Owner's imagery: a living building is slowly carried through the organism's *blood vessel / mycelial route* from one location to another. Rather than detaching and walking, the structure is assimilated/resorbed and re-grown in a different point of the same vascular network.

**Proposed safe process (requires approval):**
1. Player chooses an *eligible non-anchor* structure and a destination already connected by a continuous live vessel back to the ORG Nexus.
2. Validate that the source building is not a required **articulation point for the only live path supporting other buildings**; alternatively require a backup vessel route before removal. No immediate cascading loss disguised as one move.
3. Lock production, construction, defense and its local inventories according to a chosen explicit cargo policy. **No global teleportation of stored Matter/Volatiles/Energy or soldiers.**
4. Begin **RESORB** (nonzero time, visible form change, actual biological cost). Transmit a finite amount of recoverable mass/building essence over vascular segments at **very low rate**; each edge has carrying capacity and may be attacked.
5. On a valid destination branch, **BUD/REGROW**, with real time and further resources. Building identity/research attachments retained only to an agreed finite state budget; HP and upgrades policy TBD.
6. If vessels are cut mid-transport, enter a visible **PAUSED / STRANDED / DECAYING** state. No duplicate source+destination; recovery requires reconnection or salvage from a definite location and ledger.
7. New expansion still requires physical vessel growth **before** any remote replant; transplantation cannot bypass home-origin recurring nourishment or establish an independent root anywhere.

**Design benefit:** spectacular fungal/vascular timelapse and a race-specific slow "metabolically moving" base.  
**Design risk:** extremely difficult identity and dependency preservation, path capacity and cascading topology; the least mobile base should remain the least mobile *even after introducing transplantation*.

**More conservative fallback:** no building relocation initially; only allow **salvage + bud anew**, with some refunded cargo and visible growth. Later prototype transplantation for a very small class of non-critical branches.

## 5. MAN baseline — modular crawl and repack (ALREADY PARTLY CANON)

Current MAN identity already allows a movable **assemblage** of facilities and free-standing independent expansions, with few genuinely foundation-bound buildings.

- MIN repairs and constructs eligible structures using parts, energy/resources, range and time.
- MID tracked module operates as conveyor (3/5 tiles) or, after transition, **one-soldier bunker** or **outward-facing sentry wall**; alternative modes disable the conveyor. Stored goods must be ejected in valid space.
- MAX is an extremely slow ground-only warehouse/depot or, after unloading, a multi-soldier bunker.
- Specialized MAN factory modules may fold/pack, disconnect physical belt/data interfaces, move on terrain and redeploy after collision/foundation/footprint checks. **Not every platform is automatically relocatable**: permanent foundations and terrain-integrated structures remain possible.
- A base may split into independent sub-bases, which require **no compulsory supply pulse or information ping to home** after they have locally sufficient equipment and resources.
- Ordinary fog-of-war still applies: a standalone outpost is not automatically exposed by a cable leading to home, but it is not magically invisible.

**Anti-exploit requirement:** packed, traveling and unpacking buildings stop their production/defense/flow as appropriate; moving a complete factory has physical bottlenecks, time and risk. No instant free "teleport the factory behind the enemy" action.

## 6. ETH option — network-borne structure transfer / "railgun beam" (OPEN)

This option must be **distinguished from the current ETH blue construction beam**:
- Current **CANON**: MIN stays at a new site in NETWORK mode, using a visible blue Energy beam to an eligible large node and paying construction costs. It is **not** transporting a complete old building.
- **PROPOSED relocation:** an eligible *existing* structure is broken down into a bounded pattern/energy stream between **prepared network endpoints**, transferred through an overt high-energy "railgun" beam, then reconstituted at a permitted receiver. It would be **faster than ORG vessel transplantation**, but still not instant and not available anywhere.

**Proposed safe process (requires approval):**
1. A reachable **destination endpoint** must have been legitimately founded (initialized local ETH MAX Nexus-class or an eligible endpoint) and must offer sufficient available buffer and valid build cell.
2. The transported structure requires an explicit `beam_translocatable` specialist capability; **MID pylon default does not inherit it merely by being a pylon**, and MAX Nexus-class does not automatically fly anywhere.
3. Spend a timed **MEDITATE/DEMATERIALIZE** stage that suspends production, storage handoffs, active defense, and accepts a visible/predictable vulnerability window.
4. Reserve a finite bandwidth **BEAM TRANSFER** path along eligible network nodes at a real Energy price per unit mass/distance and perhaps slot capacity. The beam is a **visible strategic signal when detectable**; fog/stealth rules remain an open balance decision.
5. Reconstitute at the receiver through a timed **MANIFEST/RECONNECT** stage. Nothing can produce/defend at both ends at the same tick; exact inventory, HP, research, and garrison carry-over policies are TBD.
6. Interception, loss of nodes, partial transfer and cancellation must have **atomic** resource, identity and ownership reconciliation — no "duplicate building and its upgrades" bug.
7. Need physical delivery for other building materials where recipes require it; transport cannot use an uninitialized empty distant spot as a pseudo-Nexus.

**Design benefit:** strategically beautiful energy-beam timelapse and ETH positional flexibility that is faster than biological transport.  
**Design risk:** this can invalidate expansion positioning, defenses and map-control battles if too cheap, opaque or easy to abuse. Beam reveal/counterplay and range must be tested.

**Safer first step:** keep existing slow meditation/levitation for *some* eligible buildings. Prototype beam-based full structure transfer only after construction beams, node queues, alternate routes, fog-of-war and interruption are stable.

## 7. Strategic invariants if any building relocation is enabled

1. **New expansion remains real:** need an established foothold, real terrain access and resources; cannot turn a relocation into cross-map remote creation without founding.
2. **No relocation while fully operational:** during transit, productive/defensive/transfer capabilities shut off or have separately paid explicitly modeled limits.
3. **A meaningful redeploy cost:** time, Energy/Matter/Volatiles where appropriate, vulnerability, footprint, and opportunity cost. No free heal/repair, fresh shields or emptied queue.
4. **No duplicated state:** entity ID persists once, or a new ID with a single auditable lineage; cargo/garrison/tech/HP state reconciles exactly once.
5. **Contracts are independently typed:** self-deploying into bunker is not equivalent to moving an established bunker; current ETH construction blue beam is not full building transport.
6. **Routes can be attacked and require viable endpoints**. ORG vessel cut interrupts biological transfer; MAN obstacles/interdiction break the physical route; ETH node/beam disruption stops network transfer.
7. **Respect map control:** defensive foundations, high-tier production, raw deposits, island borders, drifting asteroids and critical home Nexuses retain strategic anchoring even if *some* buildings are mobile.
8. **Avoid player micro-tax:** one relocation command with clear ETA/cost/risk preview; automatic plan/transfer/redeployment within permitted orders. Surface transfer activity in an overlay, not hundreds of manual cargo clicks.
9. **Multiplayer fairness:** balance the transport subsystem without granting one race guaranteed escape from siege or one-click unlimited aggression.
10. **Consider fixed game scale:** compact MIN matches must not need the full building-moving machinery; advanced scenarios might unlock specialist transport without mandatory use.

## 8. Game precedent research leads from the discussion

The assistant previously mentioned these comparison leads. They are **research examples, not licensing/asset references or proof that arbitrary full-building transport balances well**. Recheck current official materials before citing exact implementation or release status externally.

| Example | Broad precedent to examine | Why it matters |
|---|---|---|
| StarCraft / StarCraft II Terran | *Some* Terran buildings can lift off and land elsewhere | Selective building mobility can coexist with strategic bases and expansion locations |
| Warcraft III Night Elves | Some tree-buildings uproot and walk | Economic function and combat/movement state are intentionally different |
| Factorio | Cut/paste and construction robotics support deconstruction and reconstruction of production layouts | A factory can be rearranged via physical dismantle/rebuild rather than carrying the same building entity through the map |
| Against the Storm | Selected structures can be relocated, often with rules or costs | A sim/basebuilder may distinguish movable from fixed structure classes |
| Radiant Ruins RTS | Earlier marketing described mobile building/truck concepts | Investigate a mobile-base extreme before adopting it; treat pre-release claims as **unverified**, not playtest evidence |

Do not paste copyrighted game art or franchise-identifying units into the Scalfagus repository. Creative provenance matters, but these are mechanics-design touchpoints.

## 9. Comparison for owner decision

| Choice | Implementation burden | Expansion meaning | Faction identity | Recommended sequence |
|---|---|---|---|---|
| **A. No existing-building relocation**; demolish/rebuild only except already mobile chassis | Lowest | Strong | Some loss of the distinctive timelapse | Safe MVP default |
| **B. Selective relocation** (explicit template tags; ORG transplant late, MAN modules, ETH levitation/beam late) | Medium–high | Preserved if endpoints/costs enforced | Strong | **Assistant preferred research direction**, not approved |
| **C. Every building always relocatable** | Very high | Risk of trivializing expansion and map control | Makes races more similar unless physics heavily diverge | Do not assume; requires a separate experimental proof |

No arbitrary numeric timing ratios (e.g., ETH always exactly 2× faster) are accepted. Any comparison must use explicit speed, throughput, costs, storage, cooldown, interruption and terrain limits.

## 10. Open questions requiring explicit future owner decision

- Should building relocation be in the **first playable MIN** at all, or deferred to a tech/advanced scenario?
- Are ORG **Nexus**, nutrient roots, L1 production tissue, L2 nurseries or L3 temples ever transplantable, or only noncritical endpoints? How is branch articulation enforced?
- Does an ORG transplant carry real physical Matter/Volatiles/Energy and passenger units, or must cargo be emptied first?
- Does ETH beam-transfer transport actual **building identity**, raw materials or only a recoverable blueprint/module shell? Cost by distance and mass? Interruption policy?
- Is slow ETH meditation/levitation a distinct ability or a stepping stone to beam transfer?
- Which MAN structures really have permanent foundations, despite strong overall mobility?
- What is the simplest UI for a clear difference between **MOVE UNIT**, **CHANGE MODE**, **RELOCATE BUILDING** and **REBUILD FROM SALVAGE**?
- What is the owner's **unfinished idea for the ETH MAX pylon/Nexus**? It cannot be inferred from the partial message.

## 11. Proposed tests, not completed work

- `RELOC-01` attempting to move an ANCHORED building fails with explanation.
- `RELOC-02` eligible building loses production/delivery ability during transfer; no duplicate output.
- `RELOC-03` ORG vessel interrupted during a proposed transplant leaves one reconciled building/material state.
- `RELOC-04` relocated ORG structure is valid only when a live vessel reaches receiver and remote nutrition rule is met.
- `RELOC-05` MAN composite factory packs, moves, reconnects without retaining phantom old conveyor links.
- `RELOC-06` ETH relocated structure requires initialized sender/receiver nodes, paid Energy and an exposed bounded transfer interval.
- `RELOC-07` ETH blue beam construction remains separate from moving a pre-existing structure.
- `RELOC-08` failed/canceled transfer does not duplicate cargo, garrison, upgrades or production queues.
- `RELOC-09` a faction starting from a legal MIN-only economy remains viable even with full relocation disabled.
- `RELOC-10` comparative maps prove expansion still has strategic weight versus forward-relocated production.

**Precedence:** DEC-012/013 and existing selective mobility remain canon. Every new relocation option above remains **unapproved exploration** until specifically accepted.
