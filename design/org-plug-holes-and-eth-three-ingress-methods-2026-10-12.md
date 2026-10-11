# Scalfagus — ORG Plug Holes and Three ETH Resource Ingress Methods

Date: 2026-10-12  
Decision register: **DEC-039** (ETH three injection paths: owner-selected direction; ORG universal Plug Hole: preferred design candidate, not a final owner selection over Mouth/Hybrid).  
Machine-readable contract: [org-plug-holes-and-eth-three-ingress-methods.yaml](org-plug-holes-and-eth-three-ingress-methods.yaml).  
Related source-of-truth: DEC-011 (ORG first-release handoff serialization), DEC-012/020/023 (ORG live vessels), DEC-021 (old Nexus-only ETH conversion baseline), DEC-035 (ETH slow unit relay), DEC-036 (Obelisk storage congestion), DEC-037 (ETH natural shield recharge), DEC-038 (ORG/ETH bidirectional links, ETH homogeneity upkeep); [ETH ground-vs-tip dual loop](eth-dual-loop-ground-flags-and-aerial-freight-2026-10-12.md).  
Release guard: **DEC-033 MAN vs MAN MVP0 remains unaffected**; nothing here is implemented or tested Godot gameplay.

## Owner's question and selected three ETH methods

> U org wejście do sieci mają gęby czy plug hole? Plug hole by mogły być używane prze min mid i max robotnice transportowe . Rooosz tabele jak najlepiej to ogarnac. I dał bym 3 opcje wylewitowania surowców do sieci eth. Najtańsza darmowa zanieść do nexusa, druga drony wkopują do czubka pylona tracąc 33% tarczy, i najdroższa pylon pick-up z z ziemi

Canonical ETH player-facing term is **Obelisk**, not Pylon (DEC-036). The user's 'drony wkopują do czubka pylona' is treated as **ETH drone physically reaches and inserts cargo into the Obelisk's upper/tip port**. The 33% shield payment is presumed to be the **injecting drone's own blue shield**. The owner did not specify whether the percentage means *maximum* or *current* shield, or whether it is per item or batch: these are **engineering candidates**, not secretly owner-approved balance. The design selects **33% of maximum shield per finite cargo batch** as a predictable recommended starting rule, with explicit limits and no silent HP damage.

## 1. ORG access to its universal, bidirectional living-vein network

| Candidate | Industrial/logistical interaction | Compatible with MIN/MID/MAX | Gameplay strengths | Problems | Recommendation |
| --- | --- | --- | --- | --- | --- |
| **Mouths** | Physically swallow/regurgitate cargo through organic jaws or throat | Requires explicit port/organ scaling | Very expressive biological visual, natural intake or digestion | Less legible as bidirectional universal docking; size and throughput ambiguity | Use for digestion, feeding and unique specialized organs, not the only basic vein interface |
| **Plug Holes** | Physical organic socket with flexible membrane, capable of receiving and dispatching cargo into vein channels | **Yes**, all eligible MIN/MID/MAX transport workers can dock using their compatible interface | Clear bidirectional I/O, precise port queueing, obvious link to vessel system | Must model MAX reach/footprint and prevent infinite throughput | **Preferred common logistics port** |
| **Hybrid** | Plug Holes for daily cargo; Mouths for consuming/digesting special feedstock, one-way stomach paths and exceptional buildings | Yes where equipped | Best separation of roles; distinctive art, composable growth | Two organ assets/logic paths to maintain | **Recommended long-term visual/mechanical combination** |

**Preferred implementation:** one **universal biological Plug Hole interface class** exposed by eligible ORG vein stations/cysts and transport organisms. A port exposes finite entry/exit capacity, compatible size envelope or docking adapter, accessible live vessel, permissions and ordered requests. MIN/MID/MAX may use it **if they possess a compatible hauling/docking organ**; size is not a blank permission for every combat MAX or non-hauler unit. The same port supports inward **and outward** resource transfer under DEC-038. Animated muscular ring and membrane may visually resemble a mouth, but its operational role is a dock, not digestion.

- **Do not supersede DEC-011 by accident:** unupgraded ORG MID/MAX transporter handoffs remain **one resource item per completed worker handoff, one active worker-transfer port at a time**, with initial exclusive MOVE / RECEIVE / DISPATCH / EXTRACT modes. Universal Plug Hole compatibility does not grant concurrent three-size transfers or automatic moving handoffs.
- **Bidirectionality**: a vehicle may load from the vascular net or unload to it. The living vein beneath is already bidirectional, with real finite capacity, queues and pressure/cargo arbitration.
- **Cysts (DEC-036):** every cyst holds exactly one typed resource class. An attached Plug Hole cannot deposit the wrong resource class; the cyst refuses it, preserving the resource at the worker/ground queue instead.
- **Biological mutation:** port size, additional docks, service rate and specialized glands may be upgraded/mutated at real cost. A port's species/art matters, but the routing system stays common.
- **Physical animation**: MIN plugs a small tube in, MID anchors a broader tendril, MAX extends a large trunk/umbilical into a docking hub; the socket can flex or use a scalable adapter. Actors cannot overlap/clip and docks respect valid movement domains and collision footprint.
- **Mouths remain available** for specialized eating/gas/liquid extraction or biological conversion/feeding, with direction and throughput governed by their own capability. They are not a magic way to bypass cyst restrictions or vein throughput.
- **Owner decision still open**: pure Plug Hole vs Hybrid aesthetic and whether named "Mouth" is used for any network station. Engineering preference is **hybrid**, with **Plug Hole as universal logistics interface**.

## 2. ETH: exactly three resource ingress methods

The user explicitly wants three ways to lift physical raw cargo into the elevated Ether circulation while retaining the two-loop ground foot flags and drone handoffs. This **updates and supersedes the Nexus-only exclusivity assumption of DEC-021 in future ETH gameplay**; DEC-021's typed resource preservation, Nexus's major authority/blueprint role, and existing finite network principles remain intact.

| Ingress | Physical action | Direct injection price | Work/traffic cost | Role and strategic weakness |
| --- | --- | --- | --- | --- |
| **1. Nexus deposit** | ETH drone/worker carries physical cargo to an eligible Nexus input | **FREE Energy tariff for the act of upload/conversion** | Real walking/flying, finite handoff and Nexus processing/queue; production/energy source infrastructure still real | Central, most efficient per-upload; long distances and Nexus chokepoint |
| **2. Shield-powered drone tip injection** | Eligible shielded ETH transport drone physically approaches the upper Obelisk tip and inserts a finite parcel | **Consumes 33% of that drone's blue shield per accepted finite batch** (candidate measure: max shield capacity; NOT HP, NOT 33% of the cargo) | Positive docking/transfer duration, legal tip access, node capacity, capped cargo, shield cooldown/recharge time | Distributed cheap outpost service, but a temporarily undefended carrier and finite relay queues |
| **3. Obelisk ground pick-up** | An appropriately powered/configured Obelisk autonomously lifts legally accessible physical cargo **from its nearby ground foot/collection footprint** into its tip-level Ether inventory | **Highest real Energy/service expenditure per comparable amount** | Finite pickup radius, lift speed, staffing/port capacity, transport and node traffic quota, actual levitation upkeep | Strongest automation; consumes scarce power and node throughput, vulnerable to grid cuts |

The **three methods are direct sources of elevated Ether cargo**, not three new currencies. **Nexus is still the only *free-ingress Energy-tariff* path**, not necessarily the only physical conversion endpoint. The old "all physical cargo MUST reach Nexus before conversion" is superseded for post-MVP planned faction features; existing historical docs must be read under the newer decision register.

### Price, energy, capacity and exploit prevention

1. **Nexus upload is free at the conversion interface**, not zero-cost for building/upkeeping the Nexus, operating source extraction, travel or queuing. Keep actual positive finite processing time and port rate; no omnipresent Nexus wallet. Don't debit a separate conversion Energy tax. Any Energy used to *keep subsequently levitated cargo aloft* is separate universal service/upkeep (DEC-038).
2. **Shield-powered drone injection**: candidate deterministic rule \`required_shield = ceil(max_shield_HP * 33 / 100)\` per **bounded courier batch**, debited once at handoff acceptance from the actual injecting ETH drone. A shield-less, destroyed, in-transit or insufficiently charged drone cannot inject by this method. The drone need not surrender green HP; the shield payment is real defensive vulnerability. Shield recharges naturally and faster near a valid connected Obelisk (DEC-037), so **docking, cargo packet size, queue and recharge time** are necessary throughput caps. Recharge cannot happen instantly at the same authoritatively charged step to nullify danger; exact service schedule is tuning. Resource transfer is atomic: worker/drone cargo debit, shield debit, upper Obelisk typed cargo credit, with stable packet identity. Reject without spending shield if tip cannot accept packet (full or unsupported). Any conversion latency and custody escrow must remain explicit. Do not permit an infinite "one 33% payment for arbitrary huge unbounded cargo" exploit.
3. **Obelisk ground pick-up**: expensive automatic tractor/levitation function, restricted by real local ground radius/footpad ownership rules. It consumes the most **Energy per comparable successful ingress operation**, relative to Nexus tariff zero; its exact Energy-to-shield substitution is intentionally not defined because the shield is a renewable defensive reserve, not a fungible Energy amount. Charge finite Energy per picked quantity and possibly power draw during lifting; debit accepted ground cargo exactly once, never lift unseen/unreachable enemy stock without an explicitly approved capture rule. The Obelisk needs working support and available inbound port; no magic pickup when isolated. Do not conflate this with a passive "all nearby resources auto-suck" feature: consent/player policy or authorized manager config is required. If unpaid/unpowered/blocked, the parcel stays on ground.
4. **Existing ground piles and already-converted fallen Ether**: DEC-036/dual-loop lower stage and tips remain distinct. The owner now allows secondary ingress via methods 2/3, so a tracked previously converted packet may re-enter using any compatible **legally paid** method; a special discounted "re-lift with no shield/energy cost" is **not approved**. Packet source identity, physical source form and custody state survive every conversion.
5. **Source forms**: solids can be directly gathered. Liquids still require legal sealed-handling methods, gas requires a previously completed compatible capture rig (DEC-016). Tip injection and pick-up must not bypass extraction requirements. Preserve Matter, Volatiles, Energy IDs across representation changes; Ether is a carriage state, not an extra currency.
6. **ETH resource flows** remain tip-to-tip, bidirectional, finite and storage-congestion-limited (DEC-036/038). Homogeneous suspended loads have cheaper **ongoing levitation**; that does not erase the initial upload charge for methods 2/3.
7. **Power loss**: the Obelisk loses legal automatic pickup, and actually suspended packages fall once if levitation support is gone. Foot piles remain as real world cargo, and recoverable particles still require a legal injection method. Ground-drones continue physical movement if their own systems permit it.

### UX / player agency

- Player-facing labels: **"Nexus Deposit (0 Energy)"**, **"Drone Tip Upload (33% Shield)"**, **"Obelisk Ground Pick-up (high Energy)"**. Use **Obelisk**, not Pylon; legacy \`eth_mid_pylon\` IDs remain for serialization.
- HUD for drone: current/max shields and cargo batch; show 33% threshold and why a queue is waiting ("Insufficient shield", "Tip port occupied", "Network offline", "Cargo too large").
- HUD for Obelisk: local ground stacks, levitated typed stock, available tip ports, per-tick Energy upkeep, automated pickup mode/remaining pickup budget, storage fullness vs throughput, in-flight edges and queues.
- Automatic managers must respect local scope and spend cap: shield-sacrifice cargo uploads count as a tactical durability expenditure; bulk Energy pickup requires an explicit economic budget. Full Manual doesn't imply that all pickup runs autonomously.
- If a packet is sent to a nearby construction site, it first descends to real Obelisk-foot custody and is then physically transferred to the site, while a valid ETH MIN blue beam/build authority still applies.

## Do not confuse resource ingress with other ETH abilities

- **Drone upload spending shields** is a *logistics-specific shield discharge*; it is not the same as **ETH whole-shield consumption to heal green HP** under DEC-037. Both may be legal activities but cannot double-spend the same shield points in one authoritative tick.
- **Slow unit relay** under DEC-035 transports actual eligible units over Obelisk network links and uses unit custody; it is not automatically enabled by merely picking up resource cargo.
- **ORG Plug Hole** is not an ETH Obelisk uplink; neither grants an extra currency or a cross-faction free converter.
- Third method's automatic lifting rate and Energy expense should be tuned against manually delivered physical bags so three strategic solutions remain viable instead of one dominated method.

## Suggested future acceptance test matrix

- **PORT-01**: ORG MIN, MID and MAX compatible transport workers all dock to legal Plug Hole station, with valid physical footprints and nonoverlapping slots.
- **PORT-02**: A Plug Hole can receive and dispatch actual cargo through one living vein, both directions, obeying finite shared capacity.
- **PORT-03**: Initial ORG MID/MAX receives exactly one worker handoff and one item per completed transfer; merely having universal docking does not open illegal parallel ports.
- **PORT-04**: A Matter-only cyst rejects a Volatiles parcel and debits no sender/cyst stock.
- **PORT-05**: A severed vascular component cannot remotely use inaccessible Plug Hole inventory.
- **PORT-06**: Mouth digestion cannot magically insert wrong class into cyst without legal compatible transfer.

- **INGRESS-01**: An eligible Nexus accepts physically delivered raw legal parcel for exactly **0 conversion Energy**, with finite processing time and queue.
- **INGRESS-02**: Shielded drone at valid Obelisk tip pays once 33% of maximum shield per finite accepted batch, then receives actual Ether inventory credit once.
- **INGRESS-03**: Shield-less or insufficient-shield drone cannot insert at tip; failed accept never debits shield or cargo.
- **INGRESS-04**: Repeating shield uploads requires real natural recharge/valid port scheduling and never exceeds finite throughput.
- **INGRESS-05**: Powered Obelisk with authorized ground pick-up accepts only in-range legal finite packets and pays actual Energy from legal component/stock.
- **INGRESS-06**: An unpowered Obelisk, blocked tip, unavailable Energy or disabled pickup policy cannot lift cargo; ground stock remains in original custody.
- **INGRESS-07**: Both non-Nexus ingress paths work on valid outpost Obelisks without granting remote Nexus blueprint knowledge/authority or an unlimited inventory wallet.
- **INGRESS-08**: Conversion preserves typed resource identity, quantity and original source form; repeated ascent/descent or cut does not double-credit any ledger.
- **INGRESS-09**: Gas extraction requirement and liquid containment are honored for all three paths.
- **INGRESS-10**: Levitation loss drops local suspended stock once and does not consume/destroy stationary foot piles twice.
- **INGRESS-11**: Shield spent on resource upload cannot simultaneously satisfy full-shield-to-HP healing debit.
- **INGRESS-12**: Work from same authoritative Godot fixed-tick world/state for headless, visual and two-client LAN; no misleading green CI claim without executing tests.
- **INGRESS-13**: Pricing includes no Nexus upload Energy tax, exactly one shield debit or Energy pickup charge under methods 2/3, with other recurring levitation upkeep separate.
- **INGRESS-14**: Loading policy and available funds/energy/shields cannot be bypassed by full-auto manager or off-grid client.

## Implementation and scope

Post-MVP implementation order: create one typed finite inventory/custody ledger; add physical ORG socket ports (size-aware and single-slot baseline) and real bidirectional living veins; add ETH Nexus zero-Energy upload and physical foot flags; add shielded drone tip upload with finite batch and atomic debit; add powered Obelisk ground pick-up with expensive Energy settlement and network congestion; run source/shield/energy conservation and replay tests. These systems are **not** part of DEC-033 MVP0 MAN-only four-template mirror slice.
