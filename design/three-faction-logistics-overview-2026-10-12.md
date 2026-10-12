# Scalfagus — Three-Faction Logistics: Current Canon and Decisions

**Updated:** 2026-10-12  
**Audience:** game-design and Godot implementation agents.  
**Purpose:** concise, actionable **overview** of decisions DEC-035–039 and the prior network rules. This is an index/summary, **not a competing source** of numerical balance or a new owner approval. Follow the linked contracts and newer owner decisions in case of conflict.

> **Current release boundary (DEC-033): MVP 0.1 is MAN vs MAN only** with four active templates (Command Core, MIN, Barracks, Rifleman) and physical SOLID → worker → own HQ Matter delivery. No conveyors, UMU, ORG, ETH, multi-resource advanced economy, shields or unit-relay networks in this MVP. Do not expand release scope due to this document.

## One-line identity

- **MAN — engineer a factory:** physical vehicles, conveyor belts, compartmentalized UMU depots, modular power and mobile infrastructure.
- **ORG — grow a living organism:** large biological mother carriers, bidirectional living veins, dock ports and mono-resource cysts.
- **ETH — design a network:** ground-foot Obelisk drone flags plus elevated bidirectional tip-to-tip Ether links, with mixed real per-node levitated storage, Energy costs, congestion and slow network unit relays.

All resource transfers are **real, finite, attributable and time-consuming**. No unlimited global wallet, instant teleported cargo, duplicate in-flight ownership or unlimited bandwidth. All factions can be directed by the RTS player and later scoped managers or civilization doctrines via the same authoritative rules.

## Comparison matrix

| Axis | MAN / Manusians | ORG / Organites | ETH / Etherans |
| --- | --- | --- | --- |
| Basic extraction | Physical workers, machines, compatible equipment | Biological gatherers and extraction organisms | Physical worker/drones before legal Ether injection |
| Local delivery | Workers, finite transport vehicles, containers | MIN/MID/MAX compatible living transporters and mother-hauling organisms | Physical courier drones passing ground cargo between **Obelisk foot flags** |
| Main network | **Real material belts**; separate hybrid electrical-power + optical-information conductor network that **cannot carry Matter** | One **live bidirectional vein/vessel substrate** for finite resources, nutrition, Energy, information; mitochondria provide biological power | One **bidirectional Ether graph** with straight visible links **between Obelisk tips** carrying typed resources, Energy, information and eligible slow unit transfers |
| Directionality | **Two-way belts proposed for the first post-MVP conveyor slice**; both directions share finite capacity; later manual one-way lanes optional/TBD | Two-way living-vein freight is an owner direction, with bounded flow both ways | Two-way tips and physical drone relays are owner direction, with bounded hop/edge/node service |
| Depot | Finite cargo in appropriate UMU/storage/bunker module modes, with physically legal open ports | Physical **cysts**, each holding **one resource type only** | At **Obelisk foot**: unlevitated physical ground stacks. At **tip**: actual mixed typed resources levitating around the node |
| Specialization cost/benefit | Mixed UMU cargo is flexible; configuring one resource type increases **effective packing/storage capacity** | A cyst is mono-resource; biological binding/change incurs **real mutation/specialization cost**; reversibility details open | More homogeneous levitated stock costs **less upkeep Energy** for the same held quantity; mixed stock remains legal |
| Network/store pressure | Belt junctions, physical lanes, vehicle/warehouse throughput and space | Finite vessel bandwidth, available docks/cysts, branch nourishment and living maintenance | **More levitated stock → lower node transit throughput** regardless of homogeneity; heavily loaded storage branches and lightly loaded transit trunks are strategically useful |
| Infrastructure vulnerability | Cut belt/hauler route; power cable damage only breaks power/data, not hidden material pipeline; independent UMU outposts remain possible | Cut vein: partition, starvation and gradual withering after finite reserves; hit mother transporter to disrupt bulk flow | Cut graph: no cross-component free transfers; break tips/edges and disrupt cargo/slow unit transfer; loss of **actual levitation support** makes real tip stock **fall to ground once** |
| Unique army mobility | Physical passenger transports if equipped | Physical organism carriers if equipped; veins do **not** convey troops as Ether-like packets | Slow, capacity-/cost-limited eligible **unit-to-unit identity-preserving transfer via linked Obelisks** (DEC-035); not instant teleport or relocation of built Obelisks |

### MAN: industrial logistics and UMU

1. Source → worker/vehicle → actual conveyor/warehouse/UMU → compatible factory/build site. Construction consumes stock held by a real custodian, never an arbitrary remotely powered wire.
2. UMU is a mobile infrastructure chassis with generator/warehouse versus bunker/travel mode restrictions. Mixed cargo is convenient; choosing one good improves the same chassis's usable cargo capacity. No stock creation or loss on reconfiguration.
3. For the **first actual belt implementation after MVP0**, the owner floated **universal two-way belt segments without mandatory manual orientation**. Recommended deterministic implementation arbitrates shared finite bandwidth, head-on traffic and backpressure. Expert one-way belt lanes with optional optimization are possible later, **not yet a permanent requirement**.
4. Separate power and data channels share physical cable-routing infrastructure but never transport cargo themselves. Damage may leave nearby warehouses with their contents still physically accessible if ordinary material routes survive.

### UMU wing transformation update (DEC-040)

**DEC-040 refinement — five UMU modes:** MOVE has two folded-under belt tracks giving a **trapezoid profile with an open-front/open-rear cage for real soldiers or transported cargo**. WAREHOUSE is a **new fifth posture** with **exactly one belt wing open** to a finite storage hold and the other folded. CONVEYOR alone opens both wings for 3/5 throughflow. In a WAREHOUSE the one active belt is a **one-sided pickup/delivery port**, not a free through-line or a mobile conveyor. Mode transition must preserve unique soldier/cargo custody. No gameplay implementation claimed.


Every MAN **UMU has two permanently attached physical belt wings**, shared by mutually exclusive postures:
- **MOVE:** both belt wings retract underneath as crawler tracks, leaving a trapezoid-shaped open-front/rear troop-or-cargo cage.
- **WAREHOUSE:** exactly one belt wing opens as a stationary one-sided physical loader; other wing remains folded.
- **CONVEYOR:** left/right symmetric wings extend by 1 or 2 tiles each around a 1-tile central UMU, making **3 or 5 actual connected tiles**.
- **BUNKER:** both wings fold along the two sides of the hull for flank cover and legal garrison modules.
- **SENTRY WALL:** both wings **rotate upright to form a real physically blocking wall** for ground units; this is separate from bunker, has real collision/nav consequences and is **not a free turret gun**.

Exactly one posture operates at a time. Transformations require finite time, valid collision-free geometry, settlement of real cargo and connector states, and preservation of the same unit identity, actual materials and victory tag. These owner rules refine older "MID belt only" / "UMU Power Dock no continuous belt" candidates wherever a template is **actually** an UMU. Exact classification of tiered MID/MAX types remains open. See [DEC-040 full design](man-umu-transforming-belt-wings-2026-10-12.md) and [YAML machine contract](man-umu-transforming-belt-wings.yaml). **Post-MVP0 only.**

### UMU power plant, mobile buildings and rooftop modules (DEC-041)

**New owner rule:** each UMU performs **exactly one active job** at any time. A generator can accept real resources via a finite physical intake and **consume eligible fuel** (Matter/Volatiles only when legal recipes permit) to create finite stored/transmitted **Energy**. It is **not simultaneously an open-ended warehouse or powered combat turret**. Dedicated roof solar belongs to the generator role, not a free always-on income stream.

**Whole buildings move using attached real UMU as wheels/crawler bogies:** **4 for small, 6 for medium, 8 for large**. Each involved UMU is reserved exclusively for one building's mobility, requiring real mounts, pathing, clear footprint, coordination and finite time. No duplicated UMU, conjured building, or simultaneous warehouse/belt/power jobs from a mounted drive.

**Rooftop equipment proposals** (not a finalized roster): infantry/heavy/AA turret, solid drill, liquid pump, gas collection/compressor, solar panels, real-fuel generator, battery bank, repair manipulator, sensors and loaders. Such modules can remain **physically mounted** across role switches but only work within their dedicated active job; installing/replacing them is costed.

**Name expansion pending approval:** `Universal Modular Unit` is recommended as an alternative to established `Universal Man Unit`; also consider `Universal Module Unit`, `Universal Mobility Unit`, `Universal Mechanical Unit`. Keep canonical name and serialization IDs until owner selects one.

See [DEC-041 human spec](man-umu-power-building-mobility-roof-modules-2026-10-12.md) and [DEC-041 YAML](man-umu-power-building-mobility-roof-modules.yaml). All is POST-MVP0, not verified game code.

### UMU fixed capacity and dedicated-specialist balance (DEC-042)

**Owner-fixed UMU capacity (not a balance placeholder):** **4 actual soldiers OR real cargo**; 3×3×3 = **27 standardized inside cargo units** when mixing resource types; when cargo is entirely **one homogeneous resource type**, two physical outside side racks add 3×3 = 9 units on each side, making **27 + 9 + 9 = 45 total** (18 bonus units, roughly 66.7% more). External racks are visible and affect occupancy and belt-wing transformation; do not allow mixed cargo inside and monotype side racks outside. Troops and cargo are not simultaneous cabin profiles.

**Qualitative power hierarchy:** UMU are **light, flexible multi-role generalists**; a dedicated purpose-built hauler, warehouse, fixed power plant, miner, conveyor or military defender should be **substantially more effective at that specific job**, while UMU remains exceptional at fast redeployment, emergency rebuilding and changing function. No specific specialist ratio has yet been owner-approved. The same UMU performs exactly one active job (DEC-041); do not give it multiple simultaneous production/defense/storage powers.

Read [DEC-042 design](man-umu-capacity-and-specialist-balance-2026-10-12.md) and [DEC-042 YAML](man-umu-capacity-and-specialist-balance.yaml). This is **post-DEC-033 MVP0** and not implemented in Godot.

### MAN three academies and nine qualification choices (DEC-044)

**Latest owner concept supersedes the DEC-043 historical seven-option list below:** Basic Manus has **three credential slots** and selects from **nine faculties across three academy institutions**. **Technical**: Construction Engineering, Machine Operator, **proposed Industrial Engineering**. **Military**: Infantry, Navy, Aviation. **Scientific**: Medicine, Research Science, **proposed Cybernetics**. Owner specified the groupings and seven names and requested choices for the two missing branches; the two proposed names and exact training boundaries await owner selection. A person may train any three distinct legal faculties (including multiple in one academy under the recommended default), one active job at a time, after physically collecting the requisite kit. Infantry maintains Barracks training, Scientific research requires Academy course + legal Lab kit/work; SpecOps is an advanced Infantry qualification/gear type, not a tenth basic faculty. Current DEC-033 worker/rifleman MVP0 remains unchanged.

[Current DEC-044 design](man-three-academies-nine-faculties-2026-10-12.md) / [YAML contract](man-three-academies-nine-faculties.yaml). The following dated DEC-043 seven-faculty summary is **historical only**, not authoritative for current implementation.

### MAN astronaut career slot doctrine (DEC-043)

MAN Command Core eventually produces **Basic Manus astronauts** rather than intrinsically specialized people. A living person has **exactly three initially empty qualification slots** and can learn any **three out of seven career families**. Owner examples: Engineer, Soldier, Scientist, SpecOps, Machine Operator (mechs) and Medic; seventh recommended basic faculty is **Industrial Technician** (Miner + Logistician). Electrical specialties belong under Engineer. A person can perform only **one active profession at once**, requiring both real completed certification and actual physically issued role tools/weapon/research kit. Barracks certification is required for combat Soldiers, Academy certification for Scientists working in a real Lab. Different weapons and later proficiency levels within an earned faculty **do not consume a new slot**. Exact seven names and school arrangements remain recommended design, not owner-fixed labels. See [DEC-043 human design](man-basic-astronaut-professions-training-equipment-2026-10-12.md) and [YAML](man-basic-astronaut-professions-training-equipment.yaml). This is **post-MVP0**; current four-template worker/Rifleman actions persist.

### Nine MAN machine kinds with optional human crew or autonomous AI (DEC-045)

Owner selects a MAN army/industry identity in which **human operators may physically pilot actual machines**, but **the same chassis can run autonomously via fitted onboard AI with zero humans aboard**. **Nine distinct machine types** are wanted, including **mechs, tanks and rapid bolides**. Proposed roster **counting UMU as one** (NOT owner-final): UMU generalist, bolide scout, APC troop carrier, battle tank, combat mech, self-propelled artillery, mobile anti-air, heavy drill, heavy hauler. If nine means nine specialists IN ADDITION to UMU, revise explicitly in a newer DEC; never silently claim the proposal was approved.

Physical pilot requires legal Machine Operator qualification from **DEC-044 Academy**, actor boarding time/seat and real equipment. Future player FPP/TPP possession is a direct control layer, **not necessarily a physical human boarding event**; onboard AI has bounded permissions under existing FULL MANUAL/SEMI AUTO/FULL AUTO. One physical machine, distinct onboard persons, one authoritative steering controller. No invisible AI-human, duplicated cargo or hidden skill certificate. Dedicated specialist families must win in their main role versus UMU, while UMU wins adaptability (DEC-042). See [DEC-045 human spec](man-nine-machines-crews-and-autonomy-2026-10-12.md) and [YAML](man-nine-machines-crews-and-autonomy.yaml); **post-MVP0** only.

### MAN combining existing machines into mechs and Titans (DEC-046)

Owner direction for **original MAN technological fantasy**: single machines physically transform (UMU), **several distinct existing units physically combine into a meta-machine**, and major late-game projects may form **gigantic Titan-class walking war engines**, inspired at a mechanical/theme level by General Daimos, Transformers combiners and massive WH40K war mechs. Individual source machines are **real, persistent and not cloned**: one composite group owns movement/command while its parts preserve original IDs, HP, cargo and Energy, and their former independent jobs cease. Physically separate in legal space to regain surviving constituent units, not free healed replacements.

This is distinct from **DEC-041's fixed 4/6/8 real UMU building undercarriage**. Those are owner-approved *building motion* counts; **the number and recipes for meta-mechs and Titans remain open**. The nine candidate MAN chassis families from DEC-045 are **not secretly expanded** merely by adding composite forms. Trained human machine operator and crewless AI both can control the same assembled machine via one coordinator under DEC-044/045. Costs/heat/ammo/mass/power/footprint and vulnerability to component loss are mandatory. Read [DEC-046 concept](man-machine-recombination-meta-mechs-titans-2026-10-12.md) and [YAML](man-machine-recombination-meta-mechs-titans.yaml). **No inclusion in DEC-033 MVP0.**

### Three forms of unit union: MAN assembly, ORG absorption, ETH resonance (DEC-047)

In addition to distinct freight infrastructure, each faction has a distinct **physical/identity mechanism for combining units**: **MAN** combines existing detachable machines with preserving source component IDs (DEC-046). **ORG** permanently fuses **two or more actual organisms**, or devours/absorbs real organism sources for **one-way biological mutation**; original live units cannot pop back out of their successor. **ETH** lies between: beings may **energetically merge into a more complex new being**, or **meditate into a connected collective system**; it is not a reversible MAN socket operation by default. The exact permanence and identity mapping of a deep ETH fusion remain **OPEN** under existing costly ascension/downgrade rules.

The podcast's names **Chór / Synteza / Ascendent / Konstelacja / Lewiatan / Łono Mutacji** remain **proposals** only. No conversion generates free HP, bodies, materials, Energy, shields, vision or cargo; ORG biomass and ETH energy/network limits apply. See [raw owner conversation](../inbox/2026-10-12-man-org-eth-fusion-transformation-discussion.md), [DEC-047 specification](three-faction-assembly-fusion-resonance-2026-10-12.md) and [DEC-047 YAML](three-faction-assembly-fusion-resonance.yaml). All **post-DEC-033 MVP0**.

### ORG: biology, vein logistics and cysts

1. Gatherers and large living carrier organisms haul physical finite materials into a real bidirectional living vein system. Roots/veins transfer material, nutrients, Energy and information both ways with finite throughput, meaningful cuts, a nourishment need and biological power support.
2. A **cyst** stores **exactly one** typed resource kind; it rejects incompatible goods. Re-specialization/mutation is not free and cannot instantly rebind a stocked cyst without physically handling remaining cargo. Whether changing cyst type is irreversible or simply expensive is **TBD**.
3. An ORG **Plug Hole** is the **preferred, not finally owner-selected** universal logistics docking interface for eligible **MIN/MID/MAX transport workers**. A hybrid is plausible: Plug Holes for bidirectional network intake/dispatch, specialized mouths for food/digestion/extraction. Ordinary size/port fit and docking range/collision apply.
4. **Do not override initial mother-transporter constraints:** one active worker handoff port, one resource item per completed handoff, initial MOVE / RECEIVE / DISPATCH / EXTRACT modes exclusive, later research to allow extra ports or moving handoffs.
5. Cutting veins does not instantly delete all units or cyst cargo. Access partitions and local reserves matter; starving branches weaken/wither over finite time.

### ETH: lower courier flags + upper Ether network

**Two concurrent loops:**
- **Lower loop:** at the feet of Obelisks, drones shuttle/carry actual ground piles from flag to flag (in both directions) as in The Settlers. This can function without upper levitation **if the ground workers/ports/paths remain viable**.
- **Upper loop:** physical goods enter Ether through an authorized ingress method and travel as visible parcels along **straight tip-to-tip links**, hop by hop, at finite latency, congestion and network Energy service. All stock is real locally held at each Obelisk; no global instant resource pool.
- A near-site ETH construction delivery **descends from a real tip inventory to Obelisk foot**, then reaches the legal construction site by a physical last-mile transfer, respecting builder blue-beam work, reservation and commit rules.

**Three owner-selected ways to place raw resources into elevated Ether stock (DEC-039):**

| Method | Ingress operation | Specific ingress cost | Other costs / drawbacks |
| --- | --- | --- | --- |
| **1. Nexus delivery** | Physically carry a legal raw cargo batch to Nexus | **0 incremental Energy for conversion/upload** | Real extraction, travel, finite queue/port and handling time; subsequent levitation upkeep is still payable |
| **2. Shielded drone → Obelisk tip** | A qualified shielded drone reaches the tip and physically injects a finite batch | **33% of the injecting drone's blue shield** per upload operation; **33% of max shield per bounded batch is a technical candidate, NOT confirmed owner interpretation** | Vulnerable drone while shields recharge, finite batch capacity and tip-port congestion; distinguish from ETH consuming a whole shield for green HP (DEC-037) |
| **3. Powered Obelisk ground pickup** | Authorized supported Obelisk lifts real, legal nearby foot/ground cargo into tip custody | **Highest real Energy tariff for comparable ingress** | Finite pickup radius/rate/ports, Energy/network availability, policy permissions |

**The three legal alternatives supersede previous "Nexus-only raw conversion" exclusivity in DEC-021 for future ETH gameplay.** However, Nexus maintains its distinct core/pattern/blueprint authority: a random Obelisk uploads cargo, **not** Nexus research or civilization identity. There is no fourth money/resource.

**Storage and failure:**
- Obelisks can keep a mix of typed resources levitating around their structures. A more **homogeneous** levitated load consumes **less ongoing Energy at fixed quantity** than an equally loaded mixture. Levitation cost is still positive for nonempty inventory.
- **Independent effect:** increasing the **amount** of levitated inventory decreases the node's **effective throughput**, regardless of cargo diversity. Even an all-Matter Obelisk at 100% occupancy is a slow through-relay; favor **storage sidings/spurs** and **clear lightly loaded trunk relays**. Background equalization must not force-fill protected mainline nodes.
- Stationary ground piles do not pay levitation upkeep; their footprint, exposure, handling and real drone trips still matter.
- When an Obelisk genuinely loses required **power/levitation service**, currently levitated stock falls into ground custody once. A graph split is not automatically total power loss for every surviving component if it retains legitimate sustain; a broken edge can separately drop cargo that was *actually in flight* at the rupture position. No duplication or refund of the same packet.
- ETH-only troop transfer rides the same valid graph at finite time/ports/bandwidth, with persistent unit identity/HP/inventory; it is separate from cargo packets and lower drones. Cargo load, shields/recharge (DEC-037), Energy service and military traffic may contend according to a future explicit service policy.

## Balancing principle

| Faction | Real economic design question | Winning infrastructure tradeoff |
| --- | --- | --- |
| MAN | Where to place physical freight routes, depots, buffers and mobile power? | **Packing efficiency, footprint, route/junction capacity and industrial resilience** |
| ORG | How many dedicated cysts, live veins, biological docks and transport organisms are needed? | **Mutation/specialization cost, nutrition, physiological redundancy and growth** |
| ETH | What goes on the ground, what levitates, which Obelisks hold stock, and how is network Energy spent? | **Network topology, energy-efficient homogeneous levitation, separated warehouse branches and protected through-corridors** |

Competitive parity comes from balancing **delivery latency, sustained throughput, setup/resource cost, Energy upkeep, stock safety, resilience and recovery**, not making three races perform identical deliveries with different visual effects.

## Status: approved owner direction versus open engineering/design choices

**Owner directions:** physical nonmagical logistics all factions; mono-type ORG cysts; MAN mixed/single-type UMU packing; ETH Obelisks with real mixed stock and lower throughput when fuller; homogeneous ETH storage cheaper Energy upkeep; two-way ORG veins and ETH links; ETH lower drones and elevated beams with drop-on-loss; all **three** ETH raw ingress methods with **33%** drone shield; ETH slow linked-unit relay; one shared authoritative world.

**Still open / implementation candidates:** definitive ORG Plug Hole-only vs mixed Plug Hole + mouth aesthetic; port adaptation and mutation prices; reversibility of ORG cyst specialization; MAN early two-way belt finalization versus later one-way optimization, head-on collision algorithm; 33% shield reference basis (max/current) and exactly how much cargo constitutes an upload batch; Obelisk automatic pickup Energy charge and radius; non-Nexus uplink technology prerequisites; levitation and congested traffic coefficients, power/grace rules; ETH unit transfer safety/interruption policy.

**Nothing described here is a claim of implemented/tested code.** Current documented Godot match is a narrower MAN mirror spike and the full DEC-033 first release still needs separate actual runtime verification.

## Source-of-truth links

1. [Decision register / latest scope authority](decisions.yaml) — DEC-033, DEC-035, DEC-036, DEC-037, DEC-038, DEC-039.
2. [Broad faction logistics roles](faction-logistics.yaml).
3. [MAN/ORG power docks and living veins](man-power-dock-and-org-vessel-mechanics.yaml).
4. [ORG Plug Holes and ETH three ways of entering Ether](org-plug-holes-and-eth-three-ingress-methods-2026-10-12.md) and [contract](org-plug-holes-and-eth-three-ingress-methods.yaml).
5. [ETH lower flag and upper levitating freight loops](eth-dual-loop-ground-flags-and-aerial-freight-2026-10-12.md), interpreted under **newer DEC-039** for uplink authority.
6. [ETH network mechanics](eth-ether-network-mechanics.yaml), [ETH slow unit relay](three-faction-logistics-and-eth-unit-relay.yaml).
7. [Storage specialization / congestion](faction-storage-specialization-and-obelisk-traffic.yaml), [two-way / homogeneous Energy efficiency](faction-bidirectional-logistics-and-homogeneous-storage.yaml).
8. [Faction healing and shield recovery](faction-damage-recovery-shields-and-repair.yaml).
9. [MVP0 hard boundary](mvp0-man-mirror-rts.yaml) and [coding agent guidance](../AGENTS.md).

**Agent precedence:** Newer specific DEC requirements supersede older conflicting passages, but **do not overwrite historic source quotes**. In particular, DEC-039 overrides older "Nexus is the only Ether entry point" proposals without removing the Nexus's original blueprint role; DEC-036 prevents unconditional equalization across transit relays; DEC-033 remains the release gate.
