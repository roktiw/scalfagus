# Scalfagus — Asymmetric Building Labor, Interruption and Salvage

Date: 2026-10-11
Status: **revised owner-proposed construction crew profiles (2026-10-11), not yet balanced or approved as fixed numbers**. Stage worker limits and interruption identities come directly from the discussion; the exact refund rules, worker-sacrifice finalization, interruption grace, costs and stage duration weights are **proposals**, not pre-approved implementation numbers.

Authoritative context: [decisions.yaml](decisions.yaml), [base ecologies](base-ecologies-and-expansion-2026-10-11.md), [colony topologies](colony-topologies-vascular-modular-resonant-2026-10-11.md), [deployment](deployment.yaml), [three resources](resource-balance.md).
Machine-readable companion: [construction-phases.yaml](construction-phases.yaml).
The main [discussion consolidation](faction-economy-and-construction-conversation-2026-10-11.md) links this subsequent specification.

## 0. Latest proposal — revise stage crew counts

**Latest working candidate:** ORG **3→2→1**, MAN **1→2→2**, ETH **1→2→3**. The owner suggested reducing MAN construction parallelism to compensate for its most mobile, independently expandable, repairable and reconfigurable base system. **1→2→2 is an owner-proposed balance hypothesis, not a measured balance outcome or final approval**. Historical MAN candidates: 2→1→3 (previous preferred), 2→3→1 (alternative), 1→2→3 (original). ETH historical candidate: 1→3→2. These are **upper caps**, not required simultaneous participants.

Narrative roles:
- ORG: **seed quickly → fewer nurturers → one patient final caretaker**. The unattended cocoon still decays and material is progressively embodied/consumed.
- MAN: **one engineer lays a physical foundation → two assemble frame, core and interfaces → the same maximum two commission the finished structure**. Its benefit is not construction burst speed but the ability to preserve and resume unfinished sites, salvage real materials, repair and relocate modules.
- ETH: **one channeler establishes the unique pattern → two channelers align the link and transfer Energy → three channelers perform final coherent manifestation**. More workers can progressively join the visible network operation; fully losing the mandatory beam still resets progress, with bounded source-accounted material recovery.

**Balancing observation:** MAN 1→2→2 deliberately has one fewer aggregate stage-slot than ORG 3→2→1 and ETH 1→2→3 (5 versus 6), and its final stage cannot use three helpers. This limits parallel labor but does **not** establish a fixed percentage slowdown: stage workloads, worker efficiency and availability decide real completion time. MAN's unfinished structures survive interruption, while ORG buds wither and ETH incomplete manifestations lose progress on full link loss. This is a compensating asymmetry, not a proven fair nerf.

## 1. The core asymmetry

In addition to three extraction/transport/base paradigms, all three civilizations use different *construction life cycles*.

| Question | ORG — living incubation | MAN — on-site physical assembly | ETH — channeled resonance |
|---|---|---|---|
| Construction fantasy | A **cocoon/spore** is tended by moving living organisms; the building is born | Workers assemble a **persistent physical site** | A worker maintains a visible blue beam to a network node to **manifest a structure** |
| First 0–33% | **Up to 3** caretakers | **Up to 1** assembler (foundation and frame start) | **Up to 1** channeler (pattern initiation) |
| Middle 33–66% | **Up to 2** caretakers | **Up to 2** assemblers (core and framework) | **Up to 2** channelers (energy transfer and alignment) |
| Last 66–100% | **Up to 1** caretaker | **Up to 2** assemblers (installation and commissioning) | **Up to 3** channelers (final manifestation) |
| Active builder behavior | Wander/crawl around and over cocoon; regularly tend it | Physically work at the site, install modules, weld and fit | Remain channeling in NETWORK mode with blue beam; physically occupied, cannot haul/mine |
| Builder leaves / is frightened / killed | **Tending stops; cocoon slowly decays** if no effective caretaker remains | Work stops; **structure keeps its as-built percent** | If the required connection fully breaks, **construction progress resets to zero** |
| Materials after interruption | Consumed progressively as living biomass, with limited or no standard direct refund; decay consumes value | Invested materials remain installed at physical construction site | Fraction of reserved/invested materials becomes reclaimable and returns to original contributing **Nexus/expansion inventories via a valid, accounted return mechanism** |
| Salvage | Primarily living repair/rescue before irreversible wither, not cheap scrap | **Incomplete or destroyed structures leave world salvage** other factions can actually collect | Unstable resonant pattern collapses; separate refund logistics/energy loss, not durable blueprint material on site |
| Vulnerability | Raid/scare last tending caretaker, starve/cut organic branch, wait for decay | Deny builders and salvage wrecks; opponent can steal exposed materials | Break channel at a crucial point, cause total loss of labor time (potentially extreme) |
| Relative fairness challenge | Front-loaded helpers, exposed single final caretaker | Most mobile/independent base but permanently lower helper ceiling; persistent worksite and repair compensate | Solo start, accelerating final manifestation, catastrophic progress loss after last necessary beam breaks |

**Critical clarification:** 3/2/1, 1/2/2 and 1/2/3 are **maximum simultaneous contributing builders by phase**, **not** a demand to always maintain the maximum. One eligible builder can continue a project in any stage if the building-specific requirement permits; losing *one of multiple* builders reduces speed, not necessarily aborts the project. If a structure requires a quorum, that is a specialist rule still TBD.

These workers are **independent labor actors**, not necessarily economic chassis MIN/MID/MAX. L1/L2/L3 building eligibility, construction equipment, mode and topology checks remain unchanged (ORG equipped MIN for L1, MID for L2, MAX for L3; MAN builds through permitted modular construction tools; ETH MIN channels to a large eligible node). Supporting units must have the appropriate *tending/assembly/channeling* capability; otherwise a raw cargo unit cannot contribute.

### Stage thresholds

Three normalized stages:
- Stage 1: progress in `[0, 1/3)`.
- Stage 2: progress in `[1/3, 2/3)`.
- Stage 3: progress in `[2/3, 1]`.

At the boundary recalculate eligible labor slots **deterministically**. If an ORG cocoon moves from stage 1 to stage 2 with three workers, exactly one worker is released by a stable ordering rule and may take another task; the extra worker does not create a hidden build-speed bonus. MAN starts with one worker, opens a second legal slot at 33% and remains limited to two through completion. ETH opens one additional eligible channel at each boundary if a worker is available.

## 2. ORG — spore, cocoon, incubation and birth

**Owner direction:** an ORG builder must **not immediately die and mutate into a building on initial placement** as in a familiar Zerg presentation. Instead, one or more workers incubate a spore/cocoon throughout its growth, physically moving around it and/or on its surface. The spore remains rooted in a physically connected living vascular branch.

- **Phase A, sowing (3 worker slots):** eligible builder initiates spore at a legal vessel-connected site. Up to 3 tending organisms establish living surface, accumulate biomass, clean/feed/repair tissue.
- **Phase B, growth (2 worker slots):** cocoon expands; up to 2 remain involved, physically animate around/on it. Additional workers are released for other jobs.
- **Phase C, maturation (1 worker slot):** one caretaker sustains a final differentiation and completes the organ structure.
- **Possible final birth (OPEN, visually compelling):** the final caretaker jumps into/merges with the cocoon like a fertilizing cell or a functional brain to grant it a unique living spark. **This is explicitly an idea, not yet a mandatory worker sacrifice**. If implemented as irreversible consumed builder, it must be priced and signaled at order time (especially severe for L1 early game). Alternative: animation only, caretaker survives; or only special higher-level structures require an actual unit.

**Interruption:** scare off, manually redirect or kill tending workers. If no effective worker is near the cocoon, construction pauses **and unmaintained living biomass starts to wither over time**. The progress decreases in a visible, deterministic curve; a valid caretaker can return to stabilize it if not yet destroyed. Growth needs live-vessel connectivity and local nourishment: cut roots can add an independent decay pressure even if caregivers remain. One negative tick must not unfairly count the same loss twice without a defined formula.

**Resource policy:** organic input is **consumed gradually during growth**, rather than magically refunding completed biomass. Already-incorporated material becomes living mass; withering consumes that investment as it deteriorates. Do not create a cheap global refund on cancellation. Allow an explicit **salvage/regrowth organ upgrade** only if later approved and budgeted.

**Opportunity cost / strengths:** early 3-caregiver parallelism permits rapid critical early placement, but ties up the fastest gathering workers. Stage 3 has a deliberately slow one-worker finish and is extremely exposed to raids. Organic construction integrates with home vessels and creates a visual living timelapse, at the cost of babysitting.

## 3. MAN — construction as a durable physical worksite

**Owner direction:** MAN workers physically construct on site. If all workers stop, the unfinished building **persists with the exact current construction percent**; it neither heals nor collapses automatically merely because builders walked away.

- **Phase A, foundation (1 slot):** one engineer surveys, anchors the worksite and begins the primary frame, paying actual setup materials/time.
- **Phase B, engineering (2 slots):** a second eligible engineer may join to assemble the load-bearing frame and operational core in parallel.
- **Phase C, commissioning (2 slots):** at most two engineers fit hardware modules, test connections and complete the building. MAN has no three-worker final sprint in this candidate.
- **Repairs** are a separate eligible action for MIN engineering workers and equipped higher machines; resource cost, timing, damage state and repair path matter.

**Interruption:** cancel, frighten, kill or move away all builders. Site stays at `progress = p` and can later continue from that exact `p` if structure survives; enemy damage can reduce HP/destroy the site but isn't an automatic build-progress rewind.

**Materials:** physically committed Matter/Volatiles/Energy remain accounted to the world site, installed/stockpiled as appropriate. Some materials may be consumed as installation or fuel and aren't fully reclaimable. Destroyed or abandoned sites leave a finite **world salvage inventory** tied to actually recoverable components. **Other factions can collect MAN scrap** with an eligible salvage actor and real time/cargo/pathing. Salvage is an exposed economic opportunity, not a cost-free instant windfall.

**Key risk:** MAN construction is highly interruption-tolerant, and the final stage accepts more labor; if scrap recovery were 100% with no time/material loss, MAN could spam impossible forward worksites without meaningful economic downside. Limit reclaimed fraction and require collection/hauling, terrain access and contested-site security.

## 4. ETH — network initiation, resonant expansion, phase lock

**Owner direction:** ETH MIN **must remain channeling** a visible blue Energy beam to a nearby eligible large network node during construction (it cannot merely leave an orb). The revised candidate stage worker count is **1 → 2 → 3**.

**Thematic explanation for this irregular labor curve (PROPOSED):**
- **Phase A, single-frequency seed (1 channeler):** one worker establishes the object's unique blueprint, initial phase and secure link to a valid Nexus-class knowledge/energy source. Other workers may not yet lock to an unformed pattern.
- **Phase B, dual-channel energy transfer (2 channelers):** after a first valid pattern exists, a second worker joins and aligns a complementary frequency, allowing stable, finite Energy supply and transfer toward the growing structure.
- **Phase C, triadic manifestation (3 channelers):** an additional worker joins to distribute the final coherent field across three synchronized axes; the structure locks into persistent matter. Three is a useful physical/channeling design language, not a hard quorum unless separately approved.

This makes the revised `1→2→3` sequence visible: progressively more Etheran workers enter NETWORK mode, feeding one coherent connected operation without turning it into an instant-free-teleport or permitting the builder to leave the site.

**Interruption:** if the **last necessary active legal beam/link** is lost (worker removed/killed, authorized Nexus lost, Energy supply exhausted or geometry obstructed), the unfinished resonant object *collapses*. Per the owner's proposed very harsh rule **all construction progress is lost** — do not simply preserve 67% like MAN or slowly wither like ORG. The object does not keep generating resources or retaining a phantom scaffold.

**Resource return proposal:** unlike construction time, some portion of paid material should **survive as recoverable value**. Track exact origin of resource contribution by Nexus / expansion / local physical stock. The relevant percentage is refunded **to the supplying inventory or local salvage pool with a legal return path**, not granted to a global wallet or teleported free to a remote Nexus. Stored Energy may potentially return by a costed eligible resonant return if such a transport mode is explicitly approved; Matter/Volatiles require real parcel recovery / couriers. Distributed contributions may return proportionally to contributing nodes. Pending physical returns remain visible, interceptable and capacity bounded.

**Important balance warning:** immediate 100% time loss for a *single brief worker interruption*, especially when 2-3 workers are already channeling and the attacker only needs to poke the endpoint for one tick, risks making ETH unusable under competitive pressure. The strict rule may still hold, **but** balance requires costs/rewards elsewhere, e.g. good ability to prepare protected local endpoints, efficient final-stage amplification with assistants, bounded refunds, redundancy where more than one eligible beam remains, safe recovery/defensive cooldowns, or an explicit nonzero link-failure grace (last idea would **soften the proposed strict owner rule and needs approval**).

### Distinguish cancellation from attack

A deliberate player cancel is not necessarily the same as destroyed node, worker death or Energy outage. Any future different refund ratio must be explicit and non-exploitable; never award more than the actual unconsumed/conserved resource value. Early-stage false-start refunds may be higher than near-completed structures, but exact curve TBD.

## 5. Balance assessment — asymmetry yes, equality not yet proven

**Directionally compelling, not yet balanced.** Two effects compound: labor-slot profiles and progress-loss profiles. Raw builder count **must not** be interpreted as raw construction time equality.

1. **Labor efficiency:** each extra builder should have diminishing returns, e.g. first worker full contribution, second worker +fraction, third less. Same diminishing-return formula across factions is a sensible starting test, but rates may depend on stage and equipment. Need test actual time-to-complete with 1/2/3 workers and at optimal stage routing.
2. **Time weighting:** three equal completion percentages do **not** imply stages take equal real time or material. ETH's first solo phase might be a huge raid weakness; compensate with low setup cost, good defenses or careful stage labor/efficiency. ORG's solo finish is similarly dangerous.
3. **Economic opportunity cost:** every working builder is not gathering, hauling or fighting. Counting extra builders as "faster" while ignoring lost mining is inaccurate.
4. **Attrition profile:** ORG's decay is a soft failure with possible rescue, MAN's persisted site is a durable investment with loot risk, ETH's hard reset is catastrophic time loss mitigated by partial refunds. A refund **does not restore time or tactical position**.
5. **Construction under attack:** compare safe back-base builds, forward contested buildings, very remote deposits and siege construction. ETH may be strongest in protected network conditions but weak in exposed front lines; MAN can resume work after raids; ORG needs reliable caretaker escort/root protection.
6. **Anti-exploit invariants:** no costless rapid cancel/restart recycling, no infinite recovered scrap, no material dupes with ETH proportional returns, no ORG cocoon life extension without consumed nourishment, no cross-faction economic softlock from one trivial attack.

### Proposed stage-based throughput formula (not canon)

Let `B_s` be base stage work duration/cost for stage `s`, and `n_s` the number of active legal builders (from 1 up to faction stage max). For a first benchmark:

`stage_progress_rate = base_rate_s × (1 + alpha2 × (n_s>=2) + alpha3 × (n_s>=3))`

where `0 < alpha3 <= alpha2 < 1` and actual multipliers/caps are **TBD**. Then verify all three races using the same completion-cost/defense constraints. Ineligible `n_s=0`: ORG decays, MAN persists, ETH collapses if mandatory links are fully lost.

**Never interpret `1-2-3` as mandatory staffing: extra channelers in stages 2 and 3 accelerate/stabilize, while a single authorized beam may continue if the building has no separate minimum quorum requirement.**

### Candidate test suite

| ID | Scenario | Expected behavior |
|---|---|---|
| BUILD-01 | ORG starts a bud with 3 eligible caretakers | Up to 3 contribute in phase A; excess contributors release at thresholds |
| BUILD-02 | ORG crosses 33% and 66% | Caps shift 3→2→1 with deterministic worker job reassignment |
| BUILD-03 | Last ORG caretaker flees/dies/leaves | Cocoon pauses then progressively loses build progress; returning caretaker may recover before wither completion |
| BUILD-04 | ORG vascular connection fails while caretaker present | Structural constraint and resource upkeep handled without double-counted instant destruction |
| BUILD-05 | ORG caretaker "fertilization" chosen | **Not enabled until separately approved** whether worker entity is permanently consumed or only animation |
| BUILD-06 | MAN proposed 1→2→2 stages and work interruption | Percentage persists at interruption; legal workers can resume |
| BUILD-07 | MAN site destroyed and enemy gathers salvage | Real finite world salvage obtained at paid salvage/hauling time, no free bank credit |
| BUILD-08 | ETH construction at phase 1/2/3 with 1→2→3 caps | Channeler role/time accounted; visible beam and eligible node maintained |
| BUILD-09 | ETH loses all required links at 67% | Work progress resets to zero; bounded accounted refund candidates generated, without inventing cargo |
| BUILD-10 | ETH one of three final-stage channelers leaves, others sustain valid legal connection | Progress/rate adapts; project does not magically collapse if at least one mandatory link remains |
| BUILD-11 | ETH energy/material return requested after loss | Contributions attributed by source; Matter/Volatiles physically recovered; refund never exceeds unconsumed/reclaimable stock |
| BUILD-12 | All faction builds interrupted with identical raid window | Measure completion, progression loss, economic opportunity cost and recoverable value |
| BUILD-13 | Construction reaches 100% at stage threshold | Exactly one complete building entity; finite workers released/consumed by authorized mechanic; no phantom output |
| BUILD-14 | Player cancels at staged percentages | Explicit cancel outcome, deterministic items, no hidden extra refunds |

## 6. What should be canonized now?

**Owner's newest design direction:** ORG cocoon incubation with wandering caretakers, worker intimidation/death as interruption, no instant initial Zerg-like builder transformation, stage labor caps 3/2/1 and progressive untended withering; MAN tangible on-site construction, immutable paused percentage, **new candidate** stage caps 1/2/2 (historical 2/1/3, 2/3/1 and 1/2/3 kept as alternatives) and salvageable incomplete/destroyed worksites that other races can collect; ETH continuous worker NETWORK beam, **new candidate** caps 1/2/3, complete progress loss on fully broken required link and some source-accounted proportionate refund to original contributing local expansion/Nexus.

**Not yet confirmed:** whether MAN 1/2/2 properly compensates its expansion/mobility economy rather than imposing excessive early-game setup, and final stage caps as proven balance, ORG finale worker jumps into cocoon and dies versus merely animates; exact ETH refund rate/curve, method of routing refund materials back physically, whether ETH allows a short link outage without full collapse, stage quorum, rates and balance constants. Treat these as research questions; never invent firm numbers or deploy the optional worker-sacrifice or free remote refunds as approved mechanics.

*Stage counts correspond to simultaneous contributors to one building site, not three worker chassis tiers.*
