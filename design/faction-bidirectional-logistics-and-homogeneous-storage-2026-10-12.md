# Scalfagus — Bidirectional Logistics and Storage Specialization Economics

Date: 2026-10-12.  
**Decision:** DEC-038 — approved direction for ETH homogeneous levitation discount and ORG/ETH bidirectional network links; owner suggests **universal two-way MAN belts for early post-MVP releases** and has not frozen future final one-way optimization rules.  
**Machine specification:** [faction-bidirectional-logistics-and-homogeneous-storage.yaml](faction-bidirectional-logistics-and-homogeneous-storage.yaml).  
Precedence: DEC-010/011/012/018–023, DEC-035/036 and the **draft ETH dual-loop architecture**. DEC-033 MAN mirror MVP0 still does not include MAN conveyors, ETH, ORG or multi-resource economies.

## Owner's original Polish statement

> Eth obeliski im bardziej lononsurowce lewitują tym mniej energii je to kosztuje więc w ten sposób analogicznie balansują ronnorodnosc bo u man jest to optymalizacja przestrzeni a u org koszt mutacji w jedną stronę
>
> U org sieć żył jest uniwersalna  i transportuje w dwie strony . U eth też w dwie strony. Zastanawiam się czy u ludzi belty też w dwie strony czy jednak manualnienustawiac jak w favtorioZ. Może do pierwszych wersji zrobić ze belty są uniwersalne two way

**Interpretation note:** The noisy transcription "lononsurowce" is interpreted as homogeneous / mono-resource loads: at the same stored amount a more homogeneous composition costs ETH less Energy to levitate than a diverse mixture. "koszt mutacji w jedną stronę" states that ORG specialization has a biological mutation / specialization commitment cost; it does **not** by itself settle whether mutations are legally irreversible forever. Manual Factorio-style belt facing/direction is an **open later-game design option**. No numbers from this document constitute approved balance.

## Three distinct types of warehousing specialization

| Faction | Mixed cargo / broad compatibility | Concentrating on one resource | Economic dividend |
| --- | --- | --- | --- |
| **MAN** | UMU with several resource kinds in compatible warehouse mode | Deliberate single-cargo UMU mode improves how efficiently real compartments are packed | **More usable physical capacity**, not automatically free speed/production |
| **ORG** | Different resource classes require separate dedicated cysts | One cyst stores only one resource class; converting its biological specialization involves mutation/configuration investment | **Single-resource biological specialization with a real commitment cost**; cannot instantly rebind a stocked cyst |
| **ETH** | Obelisk can levitate a mix of typed resources simultaneously | For a **fixed occupied quantity and valid power state**, a more homogeneous store uses **less ongoing Energy/service** than the same-size heterogeneous one | **Lower ongoing levitation upkeep**, not higher max capacity |

The cost dimensions are different intentionally: MAN packing capacity, ORG specialization/mutation expense, ETH levitation Energy. Do not trivially implement all three as "one type gives 20% capacity" under new skins.

### ETH: distinguish *two independent effects*

1. **Load amount → throughput pressure (DEC-036):** growing occupied levitated inventory uses node handling capacity and therefore decreases that Obelisk's effective tip-to-tip transit throughput. A **full all-Matter store is still a congestion-heavy relay**. Homogeneity **never** exempts it from congestion, and a separate transit-oriented Obelisk can remain relatively empty.
2. **Load diversity → levitation upkeep (DEC-038):** at **equal amount**, more homogeneous stock consumes *less per-tick Energy* to keep aloft than an otherwise equivalent mix. Multiple resource types must not become incompatible or unstoreable: they remain legal, simply less energy-efficient.

Suggested initial smooth accounting:
- Define \`total_quantity = sum(per_resource_held)\` for **levitated** stock only; normal packet transit uses its own existing budget.
- Define \`homogeneity\` in [0, 1], e.g. \`max_type_quantity / total_quantity\` for nonempty stock (simple dominant-type measure) or a normalized concentration index (e.g. HHI). These are design variants **not numeric canon**. Decide whether resource mass/volume differences need quantity normalization.
- Compute \`levitation_energy_per_tick = cost_for_quantity(total_quantity) * diversity_multiplier(homogeneity)\`, where for fixed occupied quantity a greater \`homogeneity\` gives a lower multiplier and cost. Costs are real debits/reservations of available network Energy. A homogeneous payload does not create resources or produce Energy.
- When total stored quantity is zero, upkeep should be zero. At the same total quantity, the energy for \`matter=100\` must be **strictly lower** than for \`matter=50, volatiles=50\`, assuming equal types' per-item levitation baseline.
- Density and throughput penalties still apply independently; changing the mix without changing total does **not** magically clear backlog. To protect replay and prevent rapid oscillations, clamp and deterministically tick charging; use integer/fixed-point accumulation or remainder ledger rather than fractional energy fabrication.
- If there is no valid sustaining network Energy, apply the already owner-directed **levitated inventory falls once to ground** mechanism. Being homogeneous makes levitation cheaper, **not free**, so even a single-resource store eventually loses levitation without support.
- Ground-level Obelisk foot-flag stock carried by drones does **not** incur levitation upkeep. It still needs real ground space, pathing and physical handling. When the same cargo changes representation, perform one authoritative custody transition, not source-credit plus destination-credit copies.
- DEC-037 faster ETH shield regeneration at powered Obelisks and DEC-035 ETH slow unit relay also compete for finite services as future balance rules; do not allow cheap mono storage to grant free healing or free unit transit.

### ORG: universal, bidirectional veins

- All compatible ORG vascular edges can transport actual typed cargo/nutrition/Energy/information **in either direction**, including return flow toward the home/root and outward flow to a colony. This does not imply two independent full-speed lanes by default.
- A vein is one physical, finite-capacity substrate. Traffic toward both endpoints **shares capacity** (initial proposed model), with deterministic collision/flow scheduling, backpressure and per-class priority; optional future anatomical upgrades can allow extra parallel or specialized channels.
- A severed branch splits permitted routes and local physical stock. Remote viable tissues and cysts follow existing buffer/starvation/wither rules; no teleport, infinite food or lossless recovery.
- **Cysts remain monotypic** (DEC-036). Reconfiguring/retargeting a cyst must respect biological mutation/specialization cost, existing cargo removal and legal vein supply. Whether there is an irreversible maturation lock or a costly second mutation to undo remains open; never instant and free.
- Two-way resource flow does not equal unit teleport through veins: only permitted *resource/information/energy* flows, physical ORG transports remain distinct.

### ETH: bidirectional elevated links and bidirectional drone shuttles

- Every **valid connected Obelisk-tip link** is physically usable for **A→B and B→A** resource transfer. The physical Obelisk-foot flag/drone relay system can also carry cargo in both directions along legal physical routes. This is a **bidirectional graph**, not an instant worldwide wallet, and packet hops have finite duration and unique custody.
- Existing visible straight-line tip-to-tip geometry, mixed Obelisk inventory, storage sidings, costed levitation, power-loss spills and Nexus raw-conversion baseline remain unchanged.
- Initial capacity policy: traffic in both directions **shares the bounded edge/node budget**. Separate dedicated directional lanes or full duplex are future balance/technology choices only if explicitly approved. A route cannot send twice its legal aggregate bandwidth just because two paths use the same link in opposite directions.
- ETH unit relay (DEC-035) can move eligible units over a connected link in either direction, under its own eligibility, cost and lane-sharing contract; no universal arbitrary-location teleport.
- Storage levitation Energy discount based on homogeneity is independent of edge directionality. A fully loaded homogeneous storage Obelisk saves upkeep but is still a poor trunk relay.

### MAN: the early two-way conveyor decision

**Owner asks whether to use manual Factorio-style single-direction belts or a universal two-way belt for early versions.** Recommended release strategy:
1. **First MAN conveyor slice after MVP0:** a belt segment supports cargo in **both directions without requiring the player to manually set its arrow**. This minimizes repetitive setup and makes autonomous logistics managers feasible without removing user control of jobs, limits, receivers and priority.
2. **Shared actual capacity:** both traffic directions compete for the same finite maximum throughput. One-lane head-on transit cannot be represented as two trucks occupying the same tile indefinitely; implement deterministic small cargo-cell reservations, serialized token/service passes, or a route/scheduling gate that prevents crossing and perpetual deadlock. The chosen physical representation and head-on resolution require prototyping.
3. **Finite buffer/junction backpressure:** splitters, merging links, storage inputs, real cargo handoffs and idle/no-route reporting. Packet routing honors explicit player-selected source/destination goals and uses actual available legal edges. Two-way does not mean arbitrary packet circulation when nothing requested it.
4. **Later optional expert mode:** player can assign a direction to a belt lane or add one-way specialist belt components. Directionality may improve predictable flow and possibly higher net utilization **at a real change/reconfiguration cost**, but the exact throughput bonus, unlocked tech and UI are **not owner-approved** and require tests.
5. **Do not accidentally flatten factions:** MAN transports discrete physical cargo on visible, attackable conveyors, not through light beams or vessels. A belt cannot teleport a worker/army through the lane. Parallel belts and local depot buffers remain meaningful; keep MAN ground mobility and separate power/data cable logic.
6. **No creep into DEC-033:** the current MAN mirror has MIN carrying SOLID to own HQ, **not conveyor technology**.

**Recommendation status:** owner floated early universal two-way belts as a candidate. This document records the proposal as the preferred initial implementation direction but **does not claim a final approval that all MAN belts must be two-way forever**.

## Worked tactical/logistics situation

Two load requests are active across one arterial route. At the same time, a workshop needs Matter from a remote mine while a nearby outpost needs another compatible resource in the other direction:

- **ORG:** two-way vein moves both actual supply streams with deterministic shared finite capacity. A cut can starve the distant cyst cluster. The cyst mutation choices determine which reserves can actually be held.
- **ETH:** Obelisk A and B share a bidirectional tip link and physical droned ground flags. A storage spur holds mostly Matter cheaply in levitation but still clogs its own node. The mainline remains lightly loaded. If powered link fails, in-flight stock drops under the edge custody rule, while levitated local inventory falls when sustain disappears.
- **MAN:** a first-generation two-way belt can move real containers in both directions **without manual arrow placement**, but both streams contend for the segment, so adding parallel routes or directional lanes can improve throughput when a serious congestion problem emerges.

## Validation backlog

- **DIR-01:** ORG live vein moves Matter A→B then B→A without recreating or cloning cargo.
- **DIR-02:** ORG opposed deliveries share finite conduit capacity; cut/reconnection preserve only actual stored cargo and legally in-flight parcels.
- **DIR-03:** ETH tip edge accepts legal A→B and B→A shipments, applying common finite link/node bandwidth.
- **DIR-04:** ETH physical drone flags carry cargo in either direction; it does not imply free conversion raw ore into Ether at Obelisk.
- **DIR-05:** ETH eligible unit relays in both directions without unit duplication, respecting relay limits.
- **DIR-06:** MAN early belt can schedule A→B and B→A cargo without player-set arrow; one shared capacity is enforced.
- **DIR-07:** Opposing MAN packets cannot deadlock forever or pass through each other without an explicitly modeled lane/reservation system.
- **DIR-08:** Upgraded optional one-way routing, if implemented, costs and validates conversions and cannot reverse packets instantly.
- **HOMO-01:** Same levitated stock total, single resource costs less per tick than a mixed configuration.
- **HOMO-02:** Same stock total, increasing homogeneity never increases levitation upkeep; all positive stock retains positive upkeep.
- **HOMO-03:** Same stored quantity, homogeneous and mixed ETH stores face equivalent fullness-derived throughput reduction absent other explicit modifiers.
- **HOMO-04:** Homogeneous ETH store without sustaining power still drops its levitated stock exactly once.
- **HOMO-05:** ORG cyst mutation/dedication is not free or automatically reversible with incompatible existing stock.
- **HOMO-06:** MAN specialized UMU increases capacity, not free Energy nor instant conveyor speed.
- **HOMO-07:** At partial network partition, remaining Energy and connection state govern actual levitation availability; do not confuse mere split with all-energy outage.
- **HOMO-08:** Deterministic ledgers and transfer decisions across GUI/headless/LAN when the same seed/rules apply.

All above are design/acceptance **targets**, not claimed passing executable tests.
