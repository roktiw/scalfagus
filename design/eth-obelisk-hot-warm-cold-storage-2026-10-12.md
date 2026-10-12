# ETH — Obelisk Three-Temperature Storage: HOT Stream, WARM Halo, COLD Foot

**Date:** 2026-10-12  
**Decision:** DEC-048 — **owner-approved visual and physical three-tier Obelisk storage architecture**.  
**Machine-readable contract:** [eth-obelisk-hot-warm-cold-storage.yaml](eth-obelisk-hot-warm-cold-storage.yaml).  
**Owner concept art:** whiteboard photos submitted in conversation (wide view + zooms of pyramid / Obelisk towers / floating cargo / ETH drones). Photos **are not claimed to be committed as GitHub binary assets** by this document.  
**Scope:** future ETH faction, **not** the first DEC-033 MAN-vs-MAN MVP0.  
**Precedence:** DEC-021/035/036/038/039 remain controlling for one Ether network, physical freight, finite link/node throughput, levitation upkeep, resource mix and three legal raw-cargo ingress methods; DEC-048 **refines the visual/local placement and accounting subdivisions of an Obelisk's cargo**, it does not create a fourth ingress or fourth resource type.

## Original owner instruction

> Strumień nad obeliskiem żongluje obiekty jako hot storage, aureola orbita wokół to warm storage a u podnóża to manual cold storage

**Binding conceptual meanings:**
- **HOT** — an **active vertical stream ABOVE the Obelisk**, visibly **juggling real objects** in a levitated circulation column;
- **WARM** — an **aureola / orbital halo AROUND the Obelisk** with objects visibly circling as a medium-temperature local store;
- **COLD** — **manual ground storage AT THE FOOT of the Obelisk**, physical items that ETH drones or other legal carriers explicitly pick up / put down.

The user defined these **three physical locations and metaphors**. The following throughput, cost, queuing, event-model and UI semantics are technical **recommendations to realize the concept**; absolute limits and ratios remain **TBD** rather than falsely owner-approved values.

## Whiteboard-to-concept interpretation

Owner's sketch contains:
- a **pyramidal/Nexus-like larger structure** at the start of an elevated freight link;
- **tall faceted Obelisk towers** with **vertical lines above their tips** and **wide elliptical orbital loops through their midsections**;
- **small black orbs / resource objects** alongside the link and rotating around the towers;
- slender, finned ETH courier drone variants with **FLY**, **SIT**, **STAND**, **CARRY RESOURCE** and three illustrated **HIDE ANIMATION** poses;
- a visible high line of freight between structure **tips** plus physical drone handling near terrain.

**Do not confuse three different elevations:** the HOT *local vertical juggling column at one Obelisk tip* is **not** the *edge-in-flight freight packet on a straight tip-to-tip line*. WARM local halo is **not** an independent second inter-Obelisk transport graph. COLD foot flag is **not** silently part of the elevated Ether ledger. The pyramid/Nexus visual identity needs owner confirmation; Nexus already exists as canonical functional core, so preserve its different naming and rules.

## Storage tiers

| Tier | Physical location | Owner imagery | Proposed function | Energy principle | Cargo status |
| --- | --- | --- | --- | --- | --- |
| **HOT** | Above the Obelisk's tip, vertical energized stream | Objects visibly **juggle / cycle** upwards and downwards through the stream | Smallest-latency local routing queue / immediate injection or extraction staging; priority cargo | Real **positive** levitation and active circulation service Energy; likely **highest per comparable held quantity** (relative rank candidate) | One physical Obelisk **hot** inventory/queue with unique parcel custody |
| **WARM** | Obelisk's orbital **aureola / ring** | Separate objects continuously **orbit** the tower in a closed loop | Local levitated holding buffer, queued reserve before promotion to HOT, multitype finite depot | Real **positive** levitation Energy; **likely less active upkeep than HOT** for equal comparable cargo (candidate rate relationship), not free | One physical Obelisk **warm** inventory with unique parcel custody |
| **COLD** | Foot-ground staging area / Settlers-like flag | Real piles / containers resting on the platform near the base | Longer-term/manual stock, physical drone-to-drone handoff and fallback if elevated levitation unavailable | **Zero levitation upkeep**, **not** zero pickup labor, drone movement Energy, footprint, congestion or defense cost | Physical \`foot_world_stack\`, **outside elevated-storage ledger** |

**Priority is not capacity:** HOT is urgent service, not a global magical inventory. WARM is medium-latency buffering, not automatic routing without a real queue/port. COLD is low energy but physically reachable by adversaries and can congest if the actual terrain fills.

The proposed usual ranking is \`hot_access_latency <= warm_access_latency < cold_manual_handoff_latency\`, **conditional on non-saturated links and real flight/handling distances**; jammed HOT can absolutely be slower than a nearby COLD pickup. Similarly HOT > WARM > COLD for *levitation/activity Energy per same comparable stock* is a candidate engineering target; rates, basis per item/cargo mix, and capacity are not owner-set yet.

## Visual storyboard (no added user artwork)

\`\`\`text
                          [ objects  ↕  ↕  ↕ ]    HOT: vertical juggling stream above tip
                                   ↑ ↓
                                [ TIP ] ------ packet --> [ OTHER TIP ]  edge_in_flight, not HOT
                                   ||
                     o -- o -- o  ||  o -- o         WARM: local orbital halo/aureola
                    (            OBELISK          )
                     o -- o -- o  ||  o -- o
                                   ||
                             [ FOOT FLAG ]
                           [o][o]     [o]        COLD: solid ground stacks + courier pickups
                               ETH DRONE
\`\`\`

**Movement through the same node:** \`COLD foot ↔ local eligible elevated ingress/landing ↔ WARM halo ↔ HOT stream ↔ elevated tip-to-tip edge\`. WARM↔HOT is a **finite intranode transfer** between already levitated cargo custodians. HOT↔edge is a **real finite link dispatch/hop**. COLD↔elevated **must follow an approved ingress path** (below), never a fourth free elevator.

Rendering: each actual object must appear exactly once at its authoritative custody layer. Animations can depict vertical juggling/ring rotation without changing counts every visual frame; only the committed fixed-simulation transaction changes source/destination state. Icons and sprite variants should depict distinguishable trajectories **even when zoomed out**: HOT narrow vertical shaft, WARM broad horizontal halo, COLD grounded box/pile; use color/shape/trajectory, not color alone. The ring is local storage **not** a continuous conveyor magically connected to other nodes.

## Reconcile DEC-039: raw/ground cargo has exactly three accepted ingress methods

**Owner-approved existing list**:

1. **Nexus delivery:** physically deliver real raw cargo to the proper **Nexus physical input**, then after finite processing convert it to an eligible typed Ether cargo with **zero *additional ingress Energy tariff***. Nexus levitation/upkeep and transit costs **still apply**, and throughput/ports are finite.
2. **Shielded ETH drone → Obelisk TIP:** an eligible courier physically approaches/flies to tip and uploads a bounded actual real cargo packet, paying **33% of the drone's blue shield** per allowed upload as in DEC-039 (basis of max/current shield and batch sizing remain TBD). Again levitation upkeep applies afterward.
3. **Powered Obelisk ground pickup:** an eligible Obelisk with actual sufficient power lifts an actual eligible grounded packet into levitation, paying the **highest positive finite ingress Energy tariff** of these methods. Pickup radius, rate and upgrades TBD.

Once cargo is in elevated custody it can be accepted by a legal WARM or HOT queue depending on availability/policy and the actual physical handoff; **this routing choice does not alter the upstream ingress fee**. There is **no automatic COLD→WARM or COLD→HOT upload** without one of the above paths. Conversely, selecting HOT→WARM does **not** require paying a second raw-to-Ether ingress tariff for an already levitated parcel.

**Ground courier relay remains its own physical lower loop** (DEC-021/039): drone carries real packages between grounded foot flags; it does not teleport them into HOT. Elevated tip-to-tip freight remains one real Ether graph, with finite energy, information, material and unit-relay service. Ground cargo can be delivered to a construction site by an actual worker/drone after physically descending from an eligible Obelisk.

## Custody ledger — HOT and WARM refine one existing elevated inventory

Before this concept, old docs used \`tip_local_levitated_inventory\` to describe physically stored local suspended goods. The **new authoritative accounting** breaks that inventory into:

- \`obelisk_hot_custody\` — actual levitated stock currently cycling in vertical stream;
- \`obelisk_warm_custody\` — actual levitated stock currently on the halo orbit;
- \`foot_world_stack\` — actual grounded physical items;
- \`drone_cargo\` — actual packages carried by drones;
- \`edge_in_flight\` — actual network packets in the elevated inter-Obelisk link; **NOT part of HOT while in flight**;
- \`construction_site_committed\` or a lawful destination inventory, as defined in old canon.

A given \`parcel_id\` has **exactly one** owner/custodian at any tick. Do not retain it in HOT once transferred into WARM, COLD, drone, edge, or construction. **Aggregate levitated node load** for DEC-036 traffic pressure = \`HOT occupied stock + WARM occupied stock\` (plus any explicitly accounted shared service/queue reservations as policy permits); do **not** count in-flight inter-node packets twice. **Levitation operating costs apply to BOTH HOT and WARM**, and continue to honor DEC-038: equal total levitated stock with **more homogeneous resource types costs less Energy** than a mixed equivalent, while remaining strictly positive. The cost comparison of HOT vs WARM does **not** cancel homogeneity cost and does **not** cancel full-node traffic congestion.

**Mode restrictions:** Obelisk existing STORAGE_RELAY vs MEDITATE vs TURRET eligibility remains as DEC-018/021 canon. In turret meditation the storage may remain as actual stock even if writes/intakes are blocked; do not disappear/delete orbit objects, invent new active ports or force automatic drops solely from changing Obelisk mode while local levitation support still exists.

**Potential optimization (proposed):** keep backbone relay nodes **lightly stocked in both HOT and WARM**; store reserve orbs in side-branch Obelisks' WARM halo and at ground COLD flags. This retains existing DEC-036 logic that *higher aggregate levitated Obelisk fill → lower traffic throughput*, even when one node's halo has beautiful synchronized orbiting assets.

## Transfers and queues (engineering proposal)

All operations require **nonzero fixed tick time**, real ports/capacity, permission, legal topology and unique source/destination parcel custody:

- \`warm_to_hot\` — promote queued actual orb from visible orbit to energized vertical stream, consuming bounded service/time/Energy; then eligible for priority dispatch.
- \`hot_to_warm\` — demote actual orb from vertical stream to circular holding pattern when no urgent dispatch exists, consuming nonzero service; frees hot queue space but **does not magically remove node pressure**.
- \`hot_to_elevated_edge\` — reserve link/route/receiver capacity, transfer custody atomically to \`edge_in_flight\`; material visibly moves onto straight beam, not teleported.
- \`edge_to_hot_or_warm\` — on legal arrival, attribute stock exactly once to eligible receiving node queue/orbit according to granted reservation and available service.
- \`warm_or_hot_to_ground\` — controlled descent to actual free physical ground footprint and ledger transfer, with real time and port; once landed it costs zero levitation upkeep. Broken/blocked placement must be handled by legal landing queue/drop policy rather than asset disappearing.
- \`ground_to_hot_or_warm\` — only through one of existing three legal ingress methods; no bare \`hot=true\` UI shortcut.
- \`cold_to_drone\` and \`drone_to_cold\` — real manual/AI courier handling at ground flag; accepted only with legal reachable storage and free carrying capacity.

**Automatic "cooling" on overload** (move excess HOT→WARM→COLD) is a *candidate storage/energy policy*, not a mandatory owner-confirmed law. Overload may instead lead to backpressure and queues. **Do not silently drop** material to COLD from ordinary congestion; use explicit legal policy and destination capacity.

## Power loss, partitions and dropped cargo

Earlier owner direction: when **levitation support actually fails**, suspended cargo **falls to the real ground once**, rather than creating duplicate salvage or remote refunds.

Apply to **both** HOT and WARM: all actual local levitated packets without sufficient local support must be converted through one authoritative \`unsupported_levitation_drop\` into physically placed world stacks (or explicit deterministic world-loss event if no safe platform ground exists). Track which parcels spill, actual terrain, drop geometry and one unique pickup target. Ground COLD cargo already at the foot **stays at the foot**. Edge-in-flight cargo on a severed link follows the independent edge-spill rule, **not another duplicate HOT drop**.

**Important caveat:** merely breaking one Ether graph edge need not collapse local levitation if the resulting node/connected component retains actual power/local reserves. Always check genuine levitation support, as in DEC-021 and the dual-loop spec. Homogeneous discount never reduces HOT/WARM levitation upkeep to zero.

## Proposed inspect UI / artist handoff

Select Obelisk -> three side-by-side tier indicators \`HOT  n/C_hot\`, \`WARM  n/C_warm\`, \`COLD  n/C_ground\`, showing **physically separate actual quantities** by Matter/Volatiles/Energy, combined \`elevated_fill=(H+W)/C_elevated\`, real \`energy_upkeep\`, pending queues, allowed transfer policy, port status, link latency, mode and grounded pile accessibility. Cargo represented in elevated Ether remains typed real resource, not an independent fourth resource ID or a mere UI effect.

Recommended sprite/animation concepts:
- **HOT:** irregular vertical circulation of a few shining distinct typed resource stones above tip; separate lane from the straight outgoing beam.
- **WARM:** broad slower halo with distributed parcels traveling in an elliptical projected orbit around monolith at consistent height, not a planetary ring texture only.
- **COLD:** static nonlevitating stacks near foot with physical drones arriving/departing; pile scale reflects real stock.
- **Handoffs:** foot pickup, controlled lift, orbit insertion, promotion into juggling column, tip-to-tip dispatch, reverse descent.
- **Whiteboard drone:** two upper fin/horn shapes, lateral/rear fins/arms and fold/hide pose sequence; its detailed asset/state spec is separate and not finalized by this storage decision.

## Proposed acceptance tests (to be implemented, not passing)

- **ETH-TEMP-01:** one real parcel in HOT has a visible above-tip vertical juggling path and exactly one HOT custodian.
- **ETH-TEMP-02:** one real parcel in WARM has visible horizontal orbit/halo path and exactly one WARM custodian.
- **ETH-TEMP-03:** one real parcel in COLD rests at accessible foot and uses **zero levitation upkeep**.
- **ETH-TEMP-04:** HOT/WARM levitated stock costs **positive Energy** and respects mono-versus-mixed DEC-038 discount without becoming free.
- **ETH-TEMP-05:** HOT↔WARM moves only with real finite service/ticks and a single debit/credit; never creates two orbs.
- **ETH-TEMP-06:** Inter-Obelisk beam freight is \`edge_in_flight\`, not double counted in HOT or WARM.
- **ETH-TEMP-07:** higher total HOT+WARM occupancy monotonically does not increase net node throughput under DEC-036; COLD stock isn't counted as elevated fill.
- **ETH-TEMP-08:** COLD upload through Nexus path respects finite time/ports and zero **ingress tariff** only, not free levitation.
- **ETH-TEMP-09:** approved 33%-shield drone upload is real tip physical insertion and debits shield; does not also pull a free ground copy.
- **ETH-TEMP-10:** powered Obelisk raw-ground uplift requires the highest finite Energy ingress tariff and real source.
- **ETH-TEMP-11:** invalid fourth free COLD→WARM elevator or COLD→HOT direct credit is rejected.
- **ETH-TEMP-12:** when true levitation support is lost, HOT and WARM packets land/spill exactly once at legal physical positions; old COLD stock remains.
- **ETH-TEMP-13:** merely partitioning a still-powered Ether subnet does **not** drop its valid local HOT/WARM stock.
- **ETH-TEMP-14:** Obelisk turret/meditation local intake gating retains already-credited stocks and their legal levitation without magic erase/refund.
- **ETH-TEMP-15:** courier pickup/drop-off at COLD is actual reachable real world action, finite, deterministic and does not auto-credit elevated node.
- **ETH-TEMP-16:** blocked/full HOT or WARM queues generate finite backpressure and do not silently demote cargo to COLD unless an authorized policy can actually settle ground cargo.
- **ETH-TEMP-17:** fixed-seed Godot GUI/headless authoritative replay conserves typed material, owned parcels and legal Energy across tier transfers.
- **ETH-TEMP-18:** first DEC-033 MAN mirror release requires no ETH HOT/WARM/COLD implementation, UI, rates or assets.

## Open design decisions

1. Exact HOT vs WARM capacity and level height/halo radius; do not fabricate numeric figures.
2. Exact Energy/time ranking and warm↔hot queue policy, especially for combat and construction priority.
3. How deeply per-Obelisk transit throughput shares capacity with hot juggling stream vs halo buffering and slow unit relay (DEC-035).
4. Whether COLD stacks are only temporary uncovered stock or may benefit from future costed physical ETH shelter/container modules.
5. If hot and warm warehouse power failures have distinct inertia/grace buffers; default safe physical drop once if levitation is truly lost.
6. Whether general-purpose ordinary ETH drones may enter tip directly under the 33%-shield method: only eligible uploader units per DEC-039; exact species/template and batch capacity TBD.
7. Nexus/pyramid appearance and exact orbit conventions await owner design.
