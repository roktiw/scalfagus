# ETH — Dual Logistics Loops: Ground Obelisk Flags, Drone Relays and Elevated Ether Freight

Date: 2026-10-12  
Status: **owner-directed dual-loop logistics concept**, with **Nexus-only versus secondary uplink authority undecided**. Candidate implementation and balance policies are explicitly marked *proposed*, not owner-approved numerical rules.  
Related: DEC-021 (typed Ether resource conversion at Nexus), DEC-035 (slow in-network ETH unit transit), DEC-036 (Obelisk storage cost/congestion and canonical player-facing naming), DEC-037 (Obelisk shielding support).  
Proposed next registry ID: DEC-038 **only if approved**; this document is a design proposal and does not silently supersede the existing DEC-021 conversion authority.  
Machine spec: [eth-dual-loop-ground-flags-and-aerial-freight.yaml](eth-dual-loop-ground-flags-and-aerial-freight.yaml).  
MVP0 guard: DEC-033 MAN versus MAN four-template native Godot match; **do not implement ETH in MVP0**.

## The owner's latest concept (original Polish, recorded without correction)

> Transport eth. Pylony u podnóża jako flagi w settlers gdzie drony mogą przenosić jak sztafety. Drugi obieg to sieć eth jako proste linie proste pomiędzy czubkami obelisków i obiekty surowców lewitują od czubka obeliska do czubka in opadają do podnóża obeliska jeśli w pobliżu obeliska ma powstać nowa budowla. Jesli obelisk starci “zasilanie” np będąc całkowicie odciętym od sieci to wszystko co lewitował opada na ziemię. Obeliska może zatem magazynować lewitując lub być po prostu flagą gdzie u podnóża ma porozrzucane zasoby conohraniaja drony. Magazyniwanienorzez lewitacje oczywiście kosztuje sieć. Do sieci eth surowce na pewno mogą być wrzucone przez Nexus. Ale pytanie czy tylko? CY to ma sens?

Terminology: the player-facing ETH node is **Obelisk**, never "Pylon" in new UI/lore. \`eth_mid_pylon\` remains a legacy internal serialized template/alias pending a safe migration.

## The two logistics loops

**Ground-level flag/drone loop (Obelisk foot):**
- Every eligible Obelisk has a **ground-foot flag / staging area** with finite, spatially represented piles of cargo (resource ID, quantity, source form/provenance, owner/custody). Eligible independent ETH drones/workers carry cargo physically between adjacent or routable ground stations, performing a *relay-style handoff* analogous to Settlers logistics.
- Ground cargo is **not automatically levitated**, nor is it automatically credited to a Nexus, a disconnected network component or a global wallet. Ground capacity/footprint, handling rate, carrier movement, queues, pilfering and loss obey world rules.
- The same Obelisk can function as a basic ground flag, an elevated node, both or neither (if destroyed/unusable). Ground cargo may remain physically present when Ether levitation fails, although access, ownership and drone energy constraints still apply.
- Do not grant ETH drones free traversal of arbitrary impassable world geometry or unlimited instant handoffs.

**Elevated/top-of-Obelisk Ether loop:**
- One graph of real connected **Obelisks** (not an independent third faction-wide magic wallet) supports finite typed-resource transport. **Straight visible lines between Obelisk tips** show legal connected links. Freight manifests move tip-to-tip through real positive-duration hops. Visibility/line/obstacle constraints and exact link eligibility still require authored physics rules.
- A node may hold **mixed resources visibly levitating around it**, or choose **ground-staged inventory** at its base, or split supplies across both representations. **Levitating inventory requires ongoing network service and Energy/support budget, and also reduces throughput as load increases** (DEC-036).
- Destination cargo for an authorized nearby construction job **descends from the Obelisk tip to its real foot-hand-off station** before ground-level carriers/workers deliver it to the actual site. This is a finite debit/credit event, not instant materialization inside a building; all established ETH blue-beam construction eligibility still applies.
- An unconnected Obelisk is a valid **ground flag** if its structure/cargo area survives, but not an active Ether tip/link merely by standing there. Exact limits for obsolete or broken structures are TBD.

**The two loops are operational interfaces of the same civilization, not an excuse for a second global ledger or a different ETH communication graph.** Ether network information/energy/unit relay services remain in the existing topology. The ground network is physical courier routes, not a competing free remote account. ETH can choose when to use costly elevated freight versus slower resilient ground relays.

## Levitation, storage, power failure and physical drops

**Owner direction:** if an Obelisk actually loses the required power/network support for levitation — e.g., complete isolation that deprives it of live network service — **all resources it is actively levitating fall to actual ground positions**.

Precise states must be tracked separately:
1. \`foot_world_stack\`: actual ground cargo at the Obelisk footprint, including landed resources; no levitation upkeep.
2. \`tip_local_levitated_inventory\`: actual mixed typed-resource quantities held aloft by this powered Obelisk; real ongoing upkeep, storage-pressure effect and custody.
3. \`edge_in_flight\`: actual freight between two tips; holds the cargo exclusively until delivered or dropped. Existing edge-escrow invariant (DEC-021) applies.
4. \`drone_cargo\`: real physical cargo on the carrier; dropping levitated stock may not silently copy this state.
5. \`construction_site_committed\`: cargo actually delivered at a valid build site; no double refund when a beam is lost.

**Loss of levitation:** move only the amount in \`tip_local_levitated_inventory\` to actual ground stacks once; visually animate descending objects but make exactly one authoritative transaction. In-flight packages on a severed tip-to-tip edge drop once at a real world-space position on the broken route, not at both endpoints. World-map edge/safe landing rules may require a deterministic lost/irrecoverable ledger if the drop point is outside the traversable platform. Never clone or globally redistribute lost packets.

**Cut graph versus power:** existing ETH canon explicitly allows isolated network components to retain their real, local stored Energy and assets. Thus a *graph cut* need not always equal *instant loss of power* for every surviving component. For the owner's scenario, an Obelisk **completely isolated from all valid support** loses levitation, even if some non-levitated cargo stays at its foot. Whether locally retained Energy, an eligible surviving Nexus and a finite buffer can sustain an isolated subnetwork for some time is **TBD**; do not hardcode both "all splits retain working levitation forever" and "every graph split instantly destroys all storage". Visible power/service connectivity and exhaustion policy must be explicit.

**Strategic choice:**
- Ground piles: no levitation/storage power cost, physical handling/travel cost, exposed to theft and congestion.
- Levitated orbs: finite upkeep and bandwidth pressure, higher convenience for distant transfer and direct node distribution, vulnerable to network-power failure.
- Depot branch: highly loaded storage Obelisks separate from less-loaded fast transit Obelisks (DEC-036).
- Fleet of drones: resilient physical fallback but finite carrier count and pathing; not instant recovery after any failure.

## Nexus-only upload versus secondary ETH uplinks — a design question, NOT yet an approved change

**Existing DEC-021 canon**: freshly harvested physical resource must arrive at an eligible Nexus input port before conversion into typed Ether. That is the **safe initial ruleset**.

| Option | Admission into elevated graph | Benefits | Costs / design risk |
| --- | --- | --- | --- |
| A — Nexus only | Fresh raw physical cargo converted by Nexus exclusively | Keeps Nexus strategically important and ground drones useful; clear early gameplay | Distant raw-source expansion may bottleneck at one conversion hub |
| B — Every Obelisk unrestricted | Any Obelisk converts any fresh raw resource automatically | High convenience, trivial expansion | Trivializes ground-drone economy, Nexus role, physical carrying risk, map geography |
| C — Nexus baseline + expensive specialized uplink | Nexus handles raw conversion initially; later approved/paid Obelisk conversion interface with finite rate/energy/ports | Preserves economic friction and strategic future decentralized industry | Requires upgrade balance, authority gate, interception and choke-point tests |

**Assistant recommendation, not owner decision: choose C in the long term but retain A for early progression.**
- A basic Obelisk always remains an eligible *ground drop/flag*, not an unconditional raw-to-Ether converter.
- A **previously converted Ether resource** that falls to its foot should be a *separate special case*: since its typed Ether provenance can be retained, a powered eligible Obelisk may **re-levitate/re-admit it locally** at real Energy, time and port cost without a round trip to the Nexus. This is not the same as allowing fresh raw ore arbitrary injection into the network. If the physical fall material is considered irreversibly "raw" by the eventual ruleset, then this exception requires explicit unlocking.
- Only a deliberately upgraded, powered **uplink-equipped Obelisk** may convert **fresh raw** physical cargo away from a Nexus in the proposed advanced variant. Its conversion rate and processing Energy must be finite; creating one consumes real resources and does not grant full Nexus knowledge/build authority.
- New outpost bootstrap must not bypass DEC-012 authority/cached blueprint requirements. There must be a legal first conversion path and no self-locking dependency loop.
- "Can read/drop physical resource at foot" != "may convert raw cargo" != "can raise previously converted Ether cargo". All three permissions are distinct.

**Explicit open owner decision:** Does the player approve secondary raw-resource uplink at specialized Obelisks as a future technology, or insist on exclusive Nexus raw conversion for all phases? This document leaves the decision open.

## Example: one ETH outpost and a construction project

1. Drone carries 10 real Matter units to the Obelisk's **foot staging flag**. They are not yet in elevated network accounting, regardless of any tooltip.
2. If fresh/raw Matter: drone must eventually reach a legal Nexus intake under baseline A. Under a future explicitly unlocked C implementation, it may use an uplink-equipped local Obelisk after the correct cost/permission gates.
3. The Nexus converts 10 units into actual typed Ether inventory; the local Nexus inventory is debited as transfer departs along a valid tip edge; cargo enters edge escrow.
4. Cargo arrives at a storage-Obelisk branch via finite tip-to-tip hops. Orbiting objects represent real inventory and increase occupancy and Energy upkeep while reducing local transit rate.
5. A legal building site is placed near Obelisk B. Its actual needed stock is reserved and routed from the stored stock. Upon real arrival, parcels **descend at B's foot** and enter physical ground handoff, then the eligible builder/courier carries them to the actual site.
6. Enemy removes B's only support line. Already landed foot cargo remains on ground; actual levitated B stock **drops once**; cargo on broken B edge **drops at rupture**; unit-relay traffic follows its separate DEC-035 interruption policy, not a fake cargo spill.
7. Drones can recover salvage from legal ground if reachable; restoring levitation never instantly mints/resummons destroyed packets or refills all Obelisks.

## Required presentation and telemetry

- Show **two visually distinct pathways**: ground courier relay foot-to-foot, versus straight glowing elevated tip-to-tip Ether lines.
- Obelisk inspected UI distinguishes \`ground_staging_stock\`, \`levitated_stock\`, \`inbound/outbound_edge_in_flight\`, \`energy_upkeep\`, \`available_service\`, \`storage_pressure\`, \`foot_queue\`, \`tip_queue\`.
- On cut/loss, physically observable descent of resources (but use one ledger transaction, not simulation via unbounded per-resource RigidBodies).
- AI policies must distinguish local drone deliveries and expensive elevated traffic. FULL MANUAL never permits unapproved auto uplinks, FULL/SEMI AUTO require allowed budgets and safe routes, with human STOP/hold overriding.
- Never use the term "Pylon" in player-facing content.

## Design verification / future test cases

- **ETH-DUAL-01:** physical cargo can be handed off drone to drone / flag to flag with nonzero travel and finite ground storage.
- **ETH-DUAL-02:** a plain disconnected Obelisk flag can hold legal physical ground stacks without crediting the Ether network.
- **ETH-DUAL-03:** top-to-top route segments are straight visually and enforce permitted physical link endpoints, positive hop time and bandwidth.
- **ETH-DUAL-04:** construction-bound Ether cargo descends at actual destination foot, is collected physically and committed to real site only once.
- **ETH-DUAL-05:** levitated storage burns finite upkeep/service budget for every relevant tick; ground stock does not.
- **ETH-DUAL-06:** holding more levitated stock reduces node freight throughput under DEC-036, preserving a nonzero decongestion solution.
- **ETH-DUAL-07:** actual loss of levitation support lands all local suspended stock as unique ground stacks; no source refund or duplicate state.
- **ETH-DUAL-08:** interrupted elevated edge drops only actual in-flight edge cargo once, at the recorded in-flight world position.
- **ETH-DUAL-09:** a split with a still-powered component retains only permitted local service, while an isolated unpowered Obelisk drops its suspended stock.
- **ETH-DUAL-10:** basic Obelisk accepts ground raw cargo but rejects unsupported raw → Ether conversion; Nexus acceptance remains valid.
- **ETH-DUAL-11:** candidate re-lift of previously converted ground Ether requires valid supported Obelisk and finite time/Energy, preserving source lineage.
- **ETH-DUAL-12:** candidate upgraded uplink converts fresh cargo only if unlocked and physically equipped, with limited rate/cost; ordinary Obelisk still cannot.
- **ETH-DUAL-13:** no transfer ever creates a fourth resource kind or double credits raw, levitated, edge and site custodians.
- **ETH-DUAL-14:** unit relay and resource transit have separate custody; a cargo drop is not an entity duplication and the in-flight unit break policy is not silently changed.
- **ETH-DUAL-15:** deterministic resource totals, source form identity and side effects under headless/GUI/LAN for a pinned ruleset.
- **ETH-DUAL-16:** Obelisk warehouse side branches and ground stations allow meaningful fallback without a global free inventory.

No game code change or tested gameplay is asserted by this proposal.
