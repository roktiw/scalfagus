# Scalfagus — Faction-Native Logistics: Living Loops, Industrial Belts, Resonance Hubs

Date: 2026-10-11
Status: **owner-directed core gameplay canon**, with implementation details and numeric balance explicitly **proposed / TBD**.
Latest base ecology and unit-role precedence: [DEC-012/013 base ecologies](base-ecologies-and-expansion-2026-10-11.md). This document remains the transport-system specification.
Related: [logistics.yaml](logistics.yaml), [faction-logistics.yaml](faction-logistics.yaml), [settlers-logistics.md](settlers-logistics.md), [economy.yaml](economy.yaml), [factions.yaml](factions.yaml), [decisions.yaml](decisions.yaml).

## The governing design decision

**The faction determines the physical logistics paradigm; the player determines the architecture within it.** The economy must feel different to operate for each faction. Do not offer every faction the same best-in-slot workers, conveyors and pylons with cosmetic skins. These are not mere passive mining multipliers.

Three recognizable economic thought processes:
- **ORG / Organites — Living Loops:** a **physically rooted base** branches into vulnerable living vessels, and expansions need recurring home-fed nutrient deliveries. Independent gatherers mine, queue and transfer one item/worker at a time to MID/MAX; flying mothers loop between sources/home, initially stopping, with researched moving handoffs.
- **MAN / Manusians — Industrial Belts:** relocatable modular base components and fully independent hidden-until-scouted expansions use **physical conveyor corridors** and repairable machines. MID can become a one-soldier bunker or outward sentry wall; MAX can be warehouse or larger bunker. Cut links disrupt only connected systems.
- **ETH / Etherans — Resonance Hubs:** MIN couriers and occupied blue-beam NETWORK builders operate with **MID storage/relay/turret pylons** and **MAX Nexus-class core hubs**. New colonies contact home at initialization and later for unknown blueprints only.

The player has flexibility in *topology, capacity, redundancy, timing, doctrines and risk*. The approximate 80% identity / 20% variation ratio is merely a qualitative design heuristic, not a required allocation or balance constant.

Canon on other axes remains intact:
- Resources: **Matter, Volatiles, Energy** — the only three current primary resources; crystals are a visual form of a Matter deposit, not a fourth resource. Energy is a tangible stored/transportable resource, **not a compulsory electric grid**.
- Unit sizes MIN/MID/MAX describe chassis/scale, not job, doctrine or naming level.
- Units are independently acting specialists, **not a mandatory shared hive mind**.
- Automatic routine deliveries and compatible handoffs occur after player policy/orders; strategic expansion AI is separate and permission-gated; manual intervention prevails.
- Combat, economy, direct control and FPS possession share one deterministic authoritative world and inventories.
- Movement, transfers, construction and loss have real costs and counterplay. No free cargo duplication or invisible teleportation.

## Canonical design matrix

| Parameter | ORG — Living Loops | MAN — Industrial Belts | ETH — Resonance Hubs |
|---|---|---|---|
| Economy verb | **Grow / load / circulate** | **Build / route / distribute** | **Connect / relay / reroute** |
| Moving transport | Workers and giant mother haulers | Emergency haulers and service units | Small autonomous cargo couriers |
| Persistent infrastructure | **Branching living vessels linked to home Nexus, plus recurring nourishment** | Optional modular conveyor paths and independent crawling bases | **MID storage/turret pylons plus MAX Nexus-class nodes** |
| Throughput scaling | Number of workers + size/count/loop speed of mothers | Belt speed + parallel capacity + well-designed junctions | Courier fleet + pylon service rate + parallel network links |
| Latency consideration | Loading and loop travel | Belt fill and distance to destination | Courier travel + queue + handoff delay |
| Planning skill | Configure overlapping live load/unload loops | Place high-volume flow corridors | Design low-congestion resilient hub graph |
| Expansion style | Rooted, vessel-first budding + constant return supply; gatherers remain mobile | Fully independent modular outposts; connect if desirable | Initial home initialization; local cached blueprints; return home for unknown plans |
| Single-point weakness | **Severed vessel branch, starving expansion, intercepted mother** | **Belt chokepoint / vulnerable packed module** | **MID pylon loss, MAX core loss, exposed build beam** |
| Enemy response | Ambush and intercept the loaded mother | Cut/congest belts and attack splitters | Destroy/jam hubs and force longer routes |
| Fantasy | Rooted mycelial colony nourished by giant circulating beasts | Crawling, radial and vertical factory-civilization | Distributed resonant nodes and visible occupied blue construction beams |

## ORG / Organites — stop-and-transfer baseline, moving handoffs through research

**Owner-updated core mechanic (DEC-011):** workers load/unload a giant mother with **one physical item per completed handoff, one worker at a time**, using a single basic transfer port. The unupgraded mother runs mutually exclusive **MOVE, RECEIVE, DISPATCH, EXTRACT** modes: it flies between endpoints, but stops/holds position for loading and unloading. Flying handoffs are a mid-game researched capability; limited parallel worker ports are a further late-game upgrade. Previous starting-game moving handoffs are superseded.

### Required gameplay behavior

1. A player assigns one or more loop routes to a mother: pickup zone near deposit -> delivery zone near base/depot -> return to pickup, repeating until canceled or disabled.
2. Independent extractor organisms work the deposit. Eligible loading organisms collect cargo and approach the mother during a legal moving rendezvous.
3. **Baseline transfer:** the mother must hold position in RECEIVE or DISPATCH mode; only one worker and one resource item per completed handoff, at finite rate and legal transfer range. More workers form a queue. After mid-game research, movement and one transfer direction may overlap, still through the basic single port.
4. Near the base, workers or compatible docks unload a hovering mother one item/receiver at a time, subject to finite transfer rate, range, and capacity. Moving unload and extra simultaneous ports are technology-gated.
5. To sustain uninterrupted flow, the player must balance extractor rate, number of loaders/unloaders, mother cargo capacity, loop travel time, pickup/delivery window duration, and congestion.
6. Mothers may evolve into much larger bodies at significant cost; larger size increases payload but imposes footprint/pathing, speed or investment constraints. Exact growth parameters are **TBD**.
7. **Fatal weak point:** enemy interception of the mother may kill it and destroy/drop/release the valuable carried cargo according to an explicit, deterministic cargo-loss rule (**TBD**). Redundant mothers, escorts and split loads mitigate this.

This creates a staged progression: early-game stop-and-load organic loops, mid-game moving handoffs, and late-game limited multiport loading — never unlimited free transport.

### DEC-011: serialization, exclusive mother modes, researched upgrades

**Baseline ORG MID and MAX: one transfer item per completed worker handoff, one active worker port per transporter.** Queued workers are served sequentially. A high slot count does not imply parallel loading. The unupgraded mother can occupy only one mode at a time — `MOVE`, `RECEIVE`, `DISPATCH`, `EXTRACT` — and must hold position to transfer. **Mid-game research** unlocks moving + one direction of handoff while retaining a single port; **late-game research** can add finite parallel worker ports or separate receiving/dispatch organs at real cost. Extraction overlap is not granted automatically. Numeric handling rates, port upgrades and costs are TBD. Tests: `ORG-PORT-01`, `ORG-MODE-02`, `ORG-MODE-03`, `ORG-MIDTECH-04`, `ORG-LATETECH-05`, `ORG-ECO-06`.

### ORG transport choices / doctrines (proposed)

- **Swarm:** more independent small harvesters/loaders and shorter-lived loops. Less concentrated risk; greater congestion.
- **Giant:** bigger mother transporters, fewer trips and strong bulk economics. High-value, telegraphed raid targets.
- **Symbiosis:** specialized extractor–loader–mother–unloader teams, better rendezvous and overlapping loops; dependent on coordination.

Choices remain available at the player level even if doctrine upgrades later specialize the preferred solution. One mother must not become mathematically superior to all mixed strategies on all terrain.

### ORG interruption conditions

If a mother is slowed, killed, trapped or rerouted, the source workers do not silently send cargo through an imaginary shortcut. Their cargo remains in inventories or is routed to explicitly configured, reachable alternatives. If the pickup window is too short for the workforce, mother travel speed alone will not produce maximum throughput. Huge mothers cannot cross map chokepoints smaller than their footprint.

## MAN / Manusians — fast and intricate conveyor economies

**Owner-specified central mechanic:** physical conveyors deliver resources very quickly and enable **arbitrarily interesting logistics topologies**, but an attack on the belts can break the route and choke economic production.

### Required gameplay behavior

1. Drill/harvester outputs physical resource units into a finite buffer, then a conveyor edge.
2. Segments, splitters, mergers, storage depots and distribution rules form a player-designed routing network. Every edge has throughput, fill/travel time, footprint, ownership and vulnerability.
3. Converging belts obey finite receiving capacity, prioritization and backpressure. Destroyed edges stop cargo from passing through, rather than being merely cosmetic.
4. Parallel corridors, bypasses and local buffer storage can prevent a complete economic collapse, but have real capital/footprint cost.
5. Rerouting may be manual or planner-assisted only when that AI function is enabled; it cannot fabricate replacement belts or spend resources without authorization.
6. Temporary emergency trucks/haulers can be a secondary fallback; they must not outperform a protected mature belt system in all meaningful conditions.
7. Longer remote logistics to islands or drifting asteroids require explicit physical transfer/docking solutions, not an impossible free conveyor across void.

### MAN transport choices / doctrines (proposed)

- **Belt:** fast continuous flow; splitters, mergers, buffer controls.
- **Rail:** large-batch long-distance scheduled carriers (future exploration, not required for MVP).
- **Automation:** intelligent routing priorities, dispatch, sorting, diagnostics and safe recovery.

**Signature counterplay:** a targeted strike on a critical belt or splitter interrupts otherwise excellent throughput. Good players design a protected, redundant industrial topology rather than a single brittle line. Belt destruction must be visible, counterable and economically meaningful, not an instant irrecoverable defeat from one cheap attack.

## ETH / Etherans — MIN courier, MID pylon, MAX Nexus-class core

**Updated canon (DEC-012/013):** ETH is a hybrid of **mobile MIN couriers**, **static MID pylon hubs** (finite cargo relay/storage OR meditated turret), and **large MAX Nexus-class nodes**. The earlier draft of a mobile economic MID relay and a MAX pylon/turret is superseded. The large node is a local blueprint/expansion authority as well as a finite warehouse; knowledge is state, not a fourth resource.

### Required gameplay behavior

1. MIN extracts and directly carries when useful, or delivers physical cargo to MID pylons and MAX Nexus-class cores.
2. Each **MID pylon** has finite cargo slots, intake/outflow service and queues. In STORAGE mode it serves courier relays. In TURRET mode, reached by a time/energy-costed **meditation transition**, it **keeps the cargo sealed but stops all intake/dispatch**; reverting is likewise costed. This is not a permanent free dual-function structure.
3. Each **MAX** starts as a Nexus-class core, with major inventory capacity, network/construction authorization and local blueprint cache. It is not automatically a turret. Some explicitly equipped structures may mediate a **meditation → levitation/reposition → resettlement** sequence, interrupting productive functions while moving.
4. ETH MIN does **not** place a Protoss-style energy orb and leave. At construction it switches into **NETWORK** mode and remains at the site, connecting a visible **blue energy beam** to the nearest eligible large node until the job completes or is canceled. Energy transfer is finite and priced; Matter and Volatiles must be physically provided. Opponent visibility beyond ordinary sight and detection is a future balancing decision.
5. A fresh ETH expansion contacts home to initialize its core and known plans. After initialization, local stock and cached knowledge suffice to run independently; **only an unfamiliar blueprint causes a further home request**.
6. Destroying a critical MID pylon interrupts relevant couriers, while losing a MAX can block local construction knowledge and authorization; surviving local inventories and previously learned designs do not disappear. Real routes, fallback and recovery must be tested.
7. An optional speculative Phase shortcut requires explicit Energy price/range/counterplay if ever approved. **No baseline free teleportation**.

### Proposed ETH strategic doctrines

- **Relay:** economical short physical courier legs through MID hubs.
- **Mesh:** redundant MID/MAX paths and caches, resilient against local interruption.
- **Phase:** a hypothetical late-game Energy-priced workaround, not approved as baseline.

**Key tension:** the player must choose when to turn a resource pylon into defense, when to commit a MIN to an exposed construction beam, and when to risk a distant expansion acquiring a new blueprint from the core. Details: [base-ecologies-and-expansion](base-ecologies-and-expansion-2026-10-11.md).

## Shared logistics rules: differences without different games

A single deterministic economic engine models all three: finite source/depot inventories, cargo reservations, transport orders, geometric travel, transfer windows, backpressure, interruption, cargo loss and delivery events. ORG/ETH use mobile agents differently; MAN uses physical continuous-flow edges. Each faction adapter specializes a common transport contract without receiving a privileged resource ledger or hidden income.

Every event should expose: owner, resource (Matter/Volatiles/Energy), source inventory, destination inventory, actual quantity, timestamps, movement/flow path, capacity consumed, and failure outcome. Saved games/replays must reproduce the same deliveries at fixed seed and input stream.

### Important throughput distinction

- **Latency:** time from first extraction to first delivery.
- **Sustained throughput:** delivered resource units per second after startup.
- **Economics:** total cost, tech unlock, idle carrier/workforce time, footprint and failure exposure.
- **Resilience:** throughput and recovery time after losing one critical asset.

Early ORG mother throughput is bounded by cargo capacity C divided by total cycle time: flight time **plus** N_loaded × single-item handling time **plus** N_unloaded × handling time **plus** state-switch delays. Extraction and worker availability can reduce it further. Researched moving handoffs overlap some travel with a single transfer direction, but one initial port remains the cap. Late-game extra ports have finite throughput and cost; multiple mothers contend for workers. A large cargo hold alone does not deliver infinite bandwidth.

MAN belt throughput is bounded by producer, slowest belt edge/junction and consumer capacities. ETH network throughput is bounded by producer, slowest relay/edge/courier service stage and consumer capacities. More transfer checkpoints alone do not create free throughput; extra handoffs can be slower than direct courier transport. Balance as a coupled system, not per-unit paper stats.

**Comparative playtest benchmark:** how much cost, time, footprint and risk does each faction incur to deliver **1,000 units of Matter** for different deposit distances and threat/map profiles? Repeat for Volatiles and stored Energy. The benchmark is a test objective, not a fixed design requirement to make all observed numbers identical.

### Proposed telemetry

- Time to first unit, delivered units/min and time to 1,000.
- Setup cost, upgrade cost, infrastructure footprint, opportunity cost and resource payback time.
- ORG: mother occupancy %, active-port utilization, one-item transfer completion rate, worker queue length, receive/dispatch dwell time, mode conflicts, researched in-motion transfer windows, carried cargo at destruction, loop throughput.
- MAN: belt utilization %, splitter backpressure, buffer occupancy, broken links, bypass capacity and time to repair.
- ETH: pylon queue length, courier load factor, link throughput, isolated inventories, hop delay and alternate path availability.
- Shared: idle time, damaged/stolen/dropped cargo, economic output during raids, reroute/recovery time and resulting match dynamics.

## Cross-faction fairness and map obligations

- Three archetypes must feel genuinely different *from the start of the match*, not after a late unlock.
- Every faction can extract, store and deliver all three resources and has at least one affordable early logistics loop and one emergency fallback.
- MAN belt corridors should often win at peak safe steady-state throughput, ORG can move impressive batches with moving mothers, ETH can excel at rerouting and topology — **these are strengths to test, not universally predetermined win conditions**.
- No map may make one faction's primary logistics structurally impossible. Provide passable corridors, defensible junction zones and reachable positions for pylons; map generation should test spatial fairness across ORG/MAN/ETH.
- Off-base outposts, islands and drifting asteroids must obey route/docking and geometry restrictions; moving mother docking and moving asteroid targets require real simulation.
- Unbroken economy when no attack occurs; visible, recoverable consequences when attackers hit the high-value mother, critical belt or articulation pylon.
- Preserve a skill ceiling for advanced macro players, but allow medium-autonomy routine logistics (Settlers inspiration). Avoid repetitive mandatory manual cargo clicks.

## Minimal implementable vertical slice

**Phase 0 — deterministic base:**
- Three resources/inventories, extractor, depot, common reservation and transfer events; finite buffers, transfer geometry, capacity and interruption.
- Three adapters in one headless match simulator: ORG mother loop with one-port stop-and-load/stop-and-unload, MAN physical belt with a destructible junction, ETH courier service between static pylons. Research-gated ORG moving handoffs belong to a later prototype phase.
- Equal map/deposit layouts and controllable rates; instrument delivery and lost cargo; baseline 1v1 target remains 25–40 minutes as a later match-level goal.

**Phase 1 — faction decisions:**
- ORG one mother vs two smaller mothers; changing extractor-loader balance; manual loop routes; escort and interception.
- MAN single belt vs protected two-path system with buffers, splitters and emergency hauling.
- ETH direct MIN delivery vs MID-pylon route vs redundant MID/MAX graph; meditated MID turret, visible build beam and remote blueprint cache.

**Phase 2 — doctrines and map complexity:**
- Prototype and test ORG mid-game moving handoffs and late-game limited multiport loading, then evaluate Swarm/Giant/Symbiosis; Belt/Rail/Automation; Relay/Mesh/Phase **as experimental branches**; do not presume Rail and teleport approved.
- Add island transport, long-distance routes, drifting asteroid docking, congested chokepoints and terrain effects.
- Validate costed performance with simulations and competitive playtests; do not lock in arbitrary capacities yet.

### Acceptance tests (design targets)

| ID | Situation | Must hold |
|---|---|---|
| LOG-F01 | Unupgraded ORG mother reaches pickup zone | It stops/holds position, serves exactly one worker and one item per handoff; others queue. An in-motion handoff is rejected unless unlocked |
| LOG-F02 | ORG mother delivers to base | Without upgrade it stops and dispatches one item per handoff; with moving-handoff research it may dispatch during flight but still through one port |
| LOG-F03 | ORG mother destroyed mid-loop | Carried cargo follows explicit drop/loss policy; no duplication or invisible base delivery |
| LOG-F04 | Multiple ORG mothers share workers | Contention, queueing, occupancy and route overlap remain deterministic |
| LOG-F05 | MAN belt broken between source and destination | Delivery on that route ceases, input buffers back up and supply downstream declines |
| LOG-F06 | MAN bypass built | Flow resumes over actually connected path subject to capacity and costs |
| LOG-F07 | ETH MID pylon holds cargo | Stationary finite inventory is visible and linked to real courier transfer events; turret-mode locks cargo gates without unloading |
| LOG-F08 | ETH MID relay or MAX Nexus hub removed | Broken routes and knowledge services degrade without inventing cargo or erasing previously learned blueprints |
| LOG-F09 | ETH adds a fifth hop | Handling delay and stage bottlenecks remain real; no automatic free speed boost |
| LOG-F10 | Destination storage is full | Backpressure/queuing prevents duplication and overflowing inventories |
| LOG-F11 | Strategic AI disabled, worker AI enabled | Workers execute configured jobs, AI cannot add unauthorized expansion |
| LOG-F12 | Fixed seed + ordered player commands | State hash, cargo conservation and delivery timing are reproducible |
| LOG-F13 | Early-game supply line threatened | At least one faction-valid, affordable, observable fallback exists |

## Outstanding decisions

- Exact ORG mother shape, loop turning/path widths, matching speed for rolling transfer, handoff radii and cargo-on-death policy.
- Is ORG mother a unique unit category or a specialized large chassis compatible with MIN/MID/MAX? Avoid conflating size and job.
- Does MAN Rail need dedicated track geometry? Does emergency hauling remain available through all eras?
- Exact ETH pylon relay radius, node cooldown/queue limits, jam mechanics and optional Phase Energy costs.
- Can players freely blend doctrines, lock one branch, or respec? The three doctrine labels per faction are **proposed**.
- Deterministic cargo collision/reservation policy and UI overlays for all three systems.
- Actual tuning coefficients, map generators and balance thresholds after first prototype telemetry.

## Decision precedence

**Approved owner directions as of 2026-10-11 (DEC-010–013):** ORG flying mothers with one-worker/one-item base transfer and researched moving/parallel ports **plus** physically connected living vessel roots and recurring home nourishment. MAN fast modular conveyors, independent crawling/composite bases, a one-soldier-bunker MID and warehouse/bunker MAX. ETH MIN courier/occupied blue-beam builder, stationary **MID** storage/turret pylon, immediately Nexus-class **MAX**, initial home initialization and conditional unknown-blueprint synchronization only.

**Design proposals rather than approved detailed mechanics:** specific doctrine trees, emergency truck/Rail paths, Phase teleportation, numeric performance coefficients, cargo-on-death rules and queue algorithms. These should be exposed as open decisions, not quietly converted to canon.
