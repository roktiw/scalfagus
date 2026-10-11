# Scalfagus — Economy, Freight, Construction and Expansion: Consolidated Conversation Record

Date: 2026-10-11
Status: **conversation synthesis**. Owner-approved direction is marked **CANON**. Assistant suggestions, future experiments and balancing choices are **PROPOSED**, not silently approved. This is a navigation/reference record, not an implementation claim and not a verbatim chat transcript.

**Canonical sources:** [decisions.yaml](decisions.yaml) DEC-001–DEC-013; [base ecologies](base-ecologies-and-expansion-2026-10-11.md); [base ecology data](base-ecologies.yaml); [colony topologies](colony-topologies-vascular-modular-resonant-2026-10-11.md); [economic chassis](logistics-unit-scales.yaml); [logistics physics](faction-logistics.yaml); [deployable policy](deployment.yaml); [faction definitions](factions.yaml).
**Newest separate open design:** [building relocation options](building-relocation-design-options-2026-10-11.md), [option data](building-relocation-options.yaml).

## 1. Core product intent

Scalfagus is an original asymmetric RTS whose civilizations are not merely reskinned worker groups: **the same resource extraction, delivery, construction, repair, expansion and survival problems demand different thinking for each faction**.

- **ORG / Organs / Organites / Organites Reproductive Generalismus:** biology as production; gather/hunt, grow, circulate, and keep a rooted living organism nourished. Economic units are movable but the **base is the least movable**.
- **MAN / Manus / Manusians / Manusians Augmented Navigators:** modular engineering; mine, belt-route, reconfigure, repair and fortify. Bases are **composite, physically relocatable industrial systems**, not necessarily a single command-center building. Independent colonies have the lowest home dependency.
- **ETH / Eters / Etherans / Etherans Transcendent Hypervisors:** resonance plus local knowledge; courier/relay logistics, slow committed network-beam construction, large Nexus nodes, time-costed meditation and defensive pylons. Initialized colonies may operate from cached patterns.

Stable runtime IDs: `org`, `man`, `eth`; race name levels **short / mid / full** are distinct from *economic chassis* MIN/MID/MAX and *match scale* MIN/MID/MAX.

**One simulation, not three economies:** Matter / Volatiles / Energy are the only three primary stored, transported and spendable resource types. "Crystals" visually represent a Matter deposit. Nourishment is a supply/use rule, blueprint knowledge is information state, and resonance does not create a fourth global currency or a compulsory electric grid. All resource operations have finite inventories, slots, physical eligibility, capacity, geometry, time, costs and interruption. No free teleportation, invented cargo or infinite throughput.

The player selects **economic architecture** within the race-specific paradigm; do not give all three factions identical conveyors, living mother ships and pylon graphs. Medium-autonomy workers can repeat assigned jobs; player control is authoritative and strategic expansion cannot be independently ordered by routine worker AI without permission.

## 2. Three philosophies side by side — CANON

| Dimension | ORG — Living organism | MAN — Modular machine ecology | ETH — Resonant knowledge network |
|---|---|---|---|
| Economic verb | Gather, grow, nourish, circulate | Mine, assemble, convey, repair, redeploy | Gather, relay, synchronize, meditate |
| Early direct logistics | Independent MIN gatherer carries cargo | Independent MIN SCV-like hauler | Independent MIN gatherer/courier |
| Heavy transport | Slower MID and huge flying MAX mother | Physical conveyor segments MID, ground MAX depot | Mobile MIN couriers, MID storage/relay pylons, MAX Nexus hubs |
| Primary throughput bottleneck | Worker-to-carrier serialized load/unload; mother occupancy/travel | Belt edge, junction, buffer, damage | Courier trip and hub service rate, queue, network graph |
| Building | Living vessel must physically reach bud site | Modular physical assembly and service | MIN enters NETWORK mode, stays with visible blue beam to eligible large node |
| Home dependence | Continuous **physical living vessel AND real recurring nourishment shipments** | Independent outpost may operate without home communication | Founding contact; later home communication for **unknown** blueprint only |
| Base mobility | Lowest: rooted building/vessel system | Highest: relocatable modules, radial/vertical growth | Selective slow meditation/levitation for eligible structures |
| Defensive conversion | Specialized organic growth/combat adaptation (not free) | MID 1-soldier bunker or sentry wall; MAX depot ↔ garrison bunker | MID pylon storage/relay ↔ meditated turret; MAX begins as Nexus-class |
| Primary raiding target | Living artery, nourishment convoy, loaded mother | Belt/intersection, packed mobile module, isolated island | Pylon bottleneck, occupied blue build beam, key Nexus/knowledge route |
| Timelapse | Blood vessel/fungal tree sprouting and withering | Crawling factory city, islands and vertical stacks | Node constellation with glowing temporary construction beams |
| Faction thought process | Position living feeders and protect a vulnerable organism | Design flow, maintenance, movable defenses and autonomous outposts | Arrange graph, knowledge caches, defense timing and temporary beam exposure |

**Avoid misleading absolutes:** Strongest MAN steady-state belt throughput, ORG mobility and ETH defensive endurance are *design hypotheses* that must be validated against cost, travel, terrain, setup, interruption and balanced player skill. Every faction should support early, mid and late approaches and retain counterplay.

## 3. Nine economic MIN / MID / MAX chassis — CANON with explicit specialized features

| Faction | MIN | MID | MAX |
|---|---|---|---|
| ORG | **Fastest small gatherer**; mines, small finite carry, feeds larger carriers; growth-equipped workers bud **L1** and living-vessel segments | **Larger, slower harvester**; several slots, slower personal extraction, short local shuttles; growth-equipped MID buds **L2**; one initial worker handoff port | **Enormous flying mother**; many cargo/passenger compartments where equipped, long-haul loops, specialist **L3** budding at connected vascular placement; early-mode exclusivity; high-value anti-air target |
| MAN | **SCV analogue**: mines, transports, assembles structures, repairs eligible units and buildings with real tools/materials/time | **Tracked mobile relay/conveyor** with deployed lengths **3 or 5 tiles**; alternate **one-person bunker** or outward-facing **Sentry Wall**; modes mutually exclusive by default | **Very slow ground-only warehouse/depot**; physically unloads cargo and can deploy as **multi-soldier bunker** with eligible specialist tag |
| ETH | **Independent gatherer and courier**; committed **NETWORK builder** with blue energy beam to eligible large node for entire construction task | **Stationary pylon** in finite **Storage/Relay** mode or **Turret** mode reached by meditation; stored cargo retained, inbound/outbound locked when meditating/defending | **Nexus-class large node from initial creation**: local construction-beam receiver, substantial inventory and cached blueprint/knowledge authority; *not* the old MAX turret pylon |

**CANON scope:** these are *economic chassis roles*, not all combat templates of corresponding chassis size. All three MIN workers may independently gather **and carry directly to compatible storage**; do not softlock early income if higher-tier logistics is destroyed. MID/MAX size does not universally mean increased mining speed or guaranteed self-deployment.

## 4. ORG mechanics and source ↔ home mother-loop debate

**CANON: organic economic size curve.** Larger organism -> greater capacity and more compartments, but **slower mobility and personal extraction**. MIN is the most efficient individual small gatherer; MID trades speed for carrying and consolidating; huge flying MAX is primarily a transporter, not an automatically superior extractor.

**CANON: DEC-011 early limits.**
- One completed worker handoff moves **one resource item/portion**, not an entire cargo hold.
- Basic ORG MID and MAX have **one active worker transfer port**, serving **one worker at a time**; other workers queue. The mother may have many occupied slots while still loading sequentially.
- Before tech, mother is in **exactly one** of `MOVE`, `RECEIVE`, `DISPATCH`, `EXTRACT`. Extract requires eligible organs. Traveling does not mean simultaneously accepting goods.
- A loop is an ordered repeated route: **source → stop/hover to receive → home → stop/hover to dispatch → repeat**. It may hover without landing.
- **Mid-game upgrade PROPOSED**: move while receiving OR move while dispatching, still one port. **Late-game upgrade PROPOSED**: additional costed ports and bounded parallel transfers; never infinite or free. Upgrade prices, exact per-handoff time and combined extraction remain TBD.

**Loop versus static parking (design recommendation, not a new universal rule):**
- Default **continuous route orders** for mother MAX; movement fantasy remains strong, even though unupgraded mother must stop for each service window.
- MID can run short loops to support the source or hold as a **temporary** buffer.
- A parked MAX is useful for a siege, construction, staging, short-range extraction, rescue or loading congestion, but **not** the dominant always-stationary alternative mimicking MAN factories or ETH pylons.
- More than one smaller mother can reduce single-target catastrophic risk, competing against one giant mother that has good capacity but long flight/service windows.
- A costed specialist mother could carry smaller units/passengers or basic weapons; passenger seats, mass and weapons compete with cargo/other biological organs (**PROPOSED**).

**CANON: rooted organic civilization, not a uniform Zerg creep carpet.** Narrow, actual, attackable **vascular/mycelial vessels** grow outward from the rooted Nexus/Hive. Every rooted building is placed at a location physically reached by a live connected vessel. Eligible MIN/MID/MAX growth units bud L1/L2/L3 respectively. A torn branch becomes disconnected and then **gradually withers**, with visible warnings and a finite opportunity to repair/reconnect; units outside the building network retain individuality and can move/act.

**CANON: expansion must keep 'knocking at home'.** Distal colony needs **both** a live vascular connection to home **and** *recurring physical nourishment delivery of real supplies originating from home*, even while extracting local resources. Neither requirement magically satisfies the other. Nutrient recipe/upkeep cadence/storage grace and recovery remain balance parameters, not extra primary resource types. The player can raid roots and/or intercept nourishment motherships.

**Timelapse:** Nexus anchors the least movable base; branching blood-vessel/fungal fingers visibly grow, buildings bud along endpoints, worker streams and flying mother loops pulse between colonies. Disconnected branches darken/dry progressively rather than vanish instantly.

## 5. MAN mechanics and mobile independent industry

**CANON:** A MAN "Nexus" may be an assembled *system of units and buildings*, rather than exactly one immovable command center. A base consists of tracked/mobile factory segments, repair shops, depots, production nodes, interface modules and selected foundation-bound structures. It can **crawl**, spread radially, rise vertically where supported, detach components, move and reassemble. Few structures need permanent foundations (exact eligible templates TBD).

**Economic actor modes:**
- MIN is SCV-like and **repairs other eligible units, worker robots and buildings**. Repair requires spare material, tools, service time and range. A robot does not heal infinitely for free.
- MID is a tracked **3-/5-tile conveyor/relay** with real packet buffer, connected finite throughput and split/merge constraints; or a **single-soldier bunker**; or a **Sentry Wall** formed by overturning/folding the belt outward from the defended area. Modes are alternative, not all fully active simultaneously. A full belt turned into a wall stops cargo.
- A Sentry Wall must safely **eject already carried resource packets on the protected side** into actual legal cells/receivers. Crates on the ground are not automatically credited as base inventory.
- MAX is a very slow **ground-only** mobile warehouse; in bunker mode it **must physically unload its goods** and become a larger garrison space for several actual soldier entities. Finite garrison slots, footprint, mode time and specialist `deployable` permissions apply.
- Modular changes are, in principle, **reversible but costed**. Different modes may depend on fittings; no generic unrelated combat unit becomes a warehouse or bunker for free.

**CANON: strongest independence of outposts.** MAN can found a viable base on a distant island with local resource extraction and matching equipment, **without running a compulsory home conveyor or communication link**. Colonies can connect when it helps and separate when it does not. An enemy does not automatically receive a reveal/line to the original MAN base; ordinary scouting/fog rules still apply. This is not a supernatural stealth bonus.

**Balance:** huge belts across an entire map must be **possible but situational**, with physical segment costs, map footprints, setup, exposed chokepoints, buffer limits, vulnerable splitters and repair time. Factory throughput can be high, but a wall/bunker conversion trades away economy, and fully relocating a base disrupts operations. Never grant instant free whole-base movement.

**Timelapse:** a sprawling, rearranging factory/urban colony creeps outward, sometimes upward, and produces independent islands of activity.

## 6. ETH mechanics and one major chassis pivot

**CANON pivot (DEC-013):** earlier proposals of a medium **traveling "Relay Conductor"** and a MAX **plain storage pylon/turret** are **superseded**. The current economic MID is the **pylon**, and MAX is **a Nexus from the moment it is deployed**.

- MIN always gathers and hauls independently. During construction it enters **NETWORK mode**, remains at the construction site until the job completes or is canceled, and holds a **visible blue energy beam** to the nearest eligible large network node. This is intentionally **not** "Protoss probe leaves an energy orb and departs." The worker is busy, Energy is actually spent, and Matter/Volatiles must be physically supplied. Enemy visibility beyond normal LOS/fog remains undecided and must be balanced.
- MID is a **stationary productive pylon** that can store/sort/relay finite cargo from mobile MIN couriers. It can enter a timed **meditation-to-turret** transition and emerge as defensive weapon. **Cargo remains inside** throughout, without ejection. Gates are disabled during meditation; the current strict proposed/default behavior also disables ingress/egress during active turret operation. Reverse mode and timing consume time/energy.
- MAX is a **Nexus-class large node**, a strong warehouse if storage-equipped and a local source of building knowledge, construction support, network authority and expansion bootstrap. It is not automatically the same turret role as MID. Its cost/strength must compensate for beginning with full Nexus-class functions.
- **Expansion knowledge dependency:** communicate/synchronize with home **at founding**, then cache known building patterns locally. After initialization a distant network operates and builds **known** objects even when home is unreachable. When the expansion wants a **novel/uncached blueprint**, request it through a valid home/network path. Knowledge is not a fourth consumable and previous plans never vanish because a link is cut.
- Some explicitly capable ETH structures may **meditate, enter slow LEVITATION mode, travel and reconnect** after another timed transition. This already-discussed selective slow relocation is a design direction; it does not grant all buildings unrestricted flight.

**Strategic exposure:** MIN construction beams are intentionally identifiable when observed; exact fog-of-war propagation, sensors, counter-stealth and false-signature options are future balance work. Opponents can target exposed builders/links or force pylons into turret duty, thereby interrupting logistics.

**Timelapse:** a star-like node graph with luminous occasional building beams, storage pylons switching into defense, larger Nexus-class cores and selective meditative moves.

## 7. Building transport/relocation — OPEN, NOT NEW CANON

Late in the discussion the owner proposed:
- ORG moving an existing building **slowly and expensively via live vascular conduits**, as a biological transplant/reassembly.
- ETH moving an existing building **more quickly than ORG by a networked high-energy "railgun"/blue-beam stream** between nodes, subject to constraints.
- Concern that freeing **every building** for relocation would erase meaningful RTS expansion, multiply complexity and make play harder for both designer and users.
- Assistant recommendation to **restrict mobility to eligible structure templates**: anchors/permanent structures, costed relocatable structures, and inherently mobile logistics modules. MAN retains the strongest mobility; do not turn all existing bases into instantaneous nomads.

These are **ideas/options pending player/owner selection, not approved rules**. ETH railgun relocation is **not** the same as the **already approved visible blue MIN construction beam**; the former transports an *existing building*, the latter powers/authorizes a *new build* while a worker stays engaged. The owner started but did not finish a sentence: "I have an idea for the ETH MAX pylon..." — **no MAX-specific new ability or shape is to be inferred from that unfinished thought**.

See the dedicated [building relocation options](building-relocation-design-options-2026-10-11.md) for candidate rules, anti-exploit safeguards and game precedent notes. Until selected, existing selective MAN module packing and ETH explicit meditation/levitation rules remain in force; ORG vessel-transplant, ETH railgun building beam and free cross-faction relocation are **not** mandatory implemented features.

## 8. Fairness, shared rules and easy-to-read player controls

Shared:
1. Every economic MIN can begin direct mining and direct base delivery. Bigger chassis roles and network construction are **faction-specific**.
2. A finite "slot" is a **container**, not necessarily one crystal/unit. Capacity and throughput are separate. World crates and boarded soldiers are real state, not instantly banked cargo.
3. Starting ORG one worker port and four exclusive modes; MAN physical link break/backpressure; ETH node queues and meditation-gate locks are part of one deterministic cargo ledger.
4. Distinguish **building construction by an eligible worker** from **specialist unit self-deployment into a building** (requires explicit `deployable`).
5. Keep decisions comprehensible: direct worker assignments, route policy, modal command, network overlay, finite delivery reports, repairs and interruption warning. Routine AI executes jobs; strategic expansion still follows control permissions.
6. Do not turn every asymmetry into passive permanent income bonuses or fully automatic defense.

Potential balance hazards:
- ORG pays **two** ongoing home dependencies. Give low-cost living branch redundancies, finite starvation grace, repair and cargo rescue routes; don't let one cheap enemy hit wipe an entire colony instantly.
- MAN huge straight belts might become unconditionally optimal, or free mode changes might give a defensive advantage with no lost throughput. Enforce setup/traffic/bottlenecks, interrupts, repair material, and costed reconfiguration.
- ETH compulsory visible beams might reveal far too much or make construction impossible under pressure. Tune detection under fog, interference, pause/resume, small local build alternatives, research/stealth and beam duration; don't leak all network positions for free.
- ETH MAX starting as Nexus-class must not mean free early economy; calibrate price, tech and timing.
- Spatial maps should support all three systems including islands, obstacles and slow-moving asteroid docking; no faction should be geometrically excluded.

Recommended telemetry (no claims of measured balance): time to first delivery; cost/time for **1,000 resource units** at varying distance; income/s; handoff queue and transit occupancy; repair costs; starvation/vascular-link wither; MAN belt utilization and broken-corridor output; ETH relay hop delay, forced defensive downtime and beam exposure; expansion seeding cost, viability and recovery after raids; army timing and map control.

## 9. Acceptance and edge-case test list

| ID | Scenario | Must hold |
|---|---|---|
| SYN-01 | Each MIN has no MID/MAX support | May independently extract and carry to reachable compatible storage |
| SYN-02 | ORG two MINs approach a basic MID/MAX | One handoff worker at a time; one item per completed operation; queues deterministically |
| SYN-03 | ORG basic mother flies from source to home | Exclusive MOVE/RECEIVE/DISPATCH/EXTRACT; loading/unloading only while holding; mid/late tech gates respected |
| SYN-04 | ORG L1/L2/L3 attempt to bud | Correct equipped MIN/MID/MAX and actual live vessel at destination required |
| SYN-05 | ORG branch cut but local mining continues | Buildings begin visible finite withering; living units still act; local mining alone cannot waive structural link |
| SYN-06 | ORG branch intact but home nourishment blocked | Colony consumes finite reserves, warning and staged decline; no invisible supply |
| SYN-07 | MAN MID converts from conveyor to one-soldier bunker | Exactly one soldier berth; flow disabled; time/cost/footprint apply |
| SYN-08 | MAN MID becomes sentry wall, or MAX becomes bunker | Physical packets ejected/placed legally; resource ledger and passengers conserved |
| SYN-09 | MAN base is split into distant islands | Equipped outpost remains locally self-supporting without compulsory home ping |
| SYN-10 | MAN mobile modules pack/unpack, reconnect and repair | Broken belt edges cease output until physically reconnected; repairs take parts/time |
| SYN-11 | ETH MIN builds | Remains occupied with blue beam; valid large node and real costs; no orb-drop-and-leave |
| SYN-12 | ETH MID pylon converts storage ↔ turret | Cargo stays inside; transfer gates locked during meditation and defense per adopted strict policy |
| SYN-13 | ETH MAX starts and initializes outpost | Nexus-class core from start; only later unknown patterns require home contact |
| SYN-14 | Existing initialized ETH outpost disconnected | Known local blueprint construction continues; no loss of stored inventory/state |
| SYN-15 | A capable ETH structure levitates | Timed meditation, legal destination and actual outage/energy budget required |
| SYN-16 | Future proposed building relocation | **Disabled until explicit approval**, and if enabled no instantly functioning zero-cost relocation/exploits |
| SYN-17 | Enemy hits a critical ORG artery / MAN belt / ETH pylon | Measurable, observable, recoverable cost and deterministic reproducible resource state |
| SYN-18 | RTS player disables strategic autonomy | Worker routine actions may run, but no unapproved base expansion/construction objective is invented |

## 10. Follow-up construction-phase discussion (DEC-015, owner-proposed)

The later owner message adds an additional **three-stage building-labor asymmetry** and
three incompatible interrupted-construction outcomes. Full details are in
[construction incubation, assembly and resonance](construction-incubation-assembly-resonance-2026-10-11.md)
with [construction-phases.yaml](construction-phases.yaml).

- **ORG:** workers physically tend a cocoon/spore, running around or over it instead
  of immediately dying or morphing into the building on placement. Maximum
  contributors per 0–33%, 33–66%, 66–100% stage: **3 → 2 → 1**.
  If all caretakers leave, progress slowly withers and progressively incorporated
  resources are consumed. Optional final worker entering/fertilizing cocoon is
  an **unresolved** real-sacrifice-versus-animation choice.
- **MAN:** onsite tangible construction; maximum **1 → 2 → 3** workers.
  If workers leave, build percent and installed materials remain. Unfinished
  or destroyed sites can leave real salvage collected by even enemy factions
  through finite eligible salvage/haul actions.
- **ETH:** continuous blue NETWORK channeling, maximum **1 → 3 → 2**
  helpers, proposed as single pattern seeding, harmonic triad and two-channel
  coherence lock. If the **last required valid beam** is fully lost, progress
  resets to zero. Some paid resources can be reclaimed proportionately by
  original contributing Nexus/expansion inventories via **real finite return
  logistics**, not free instant remote bank credit.
- **Balance NOT proven:** worker slot counts are maxima, not staffing
  requirements; assistance efficiency, stage work, ORG decay, ETH refund,
  brief disconnect grace and contested construction all require tests.
  Worker presence and network validity must remain deterministically auditable.

## 11. Open decisions, dependencies and provenance

**Owner-approved direction:** DEC-001–DEC-013, with explicit "details TBD" labels in those decisions; most importantly DEC-010 faction logistics, DEC-011 ORG base bandwidth and modes, DEC-012 physical colony ecology, DEC-013 updated worker roles.

**Assistant recommendations / exploration not owner-approved:** exactly which ORG routes/park patterns optimize each map; specific doctrine labels Swarm/Giant/Symbiosis, Belt/Rail/Automation, Relay/Mesh/Phase; exact cargo-on-death policy, nourishments, repair throughput, healing durations; ETH fog rules; all relocation-of-building options; exact military loadout and passenger tradeoffs.

**Separate earlier broad project research:** asymmetric inspiration from StarCraft three races, Magic five color philosophies, Warcraft III factions, Age of Mythology, Warhammer 40K mapping and other RTSs is context/moodboard, *not licensed assets or proof of gameplay balance*. The game must have original unit silhouettes, names, models and IP. Historical race discussion documents remain preserved in the repository; do not overwrite those retrospectives as current canon.

**Implementation hygiene:** Legacy `design/economy.yaml`, `design/resources.yaml`, `design/units.yaml` may still contain early Crystal/Gas/Resin and generic chassis stats — migration debt rather than current canonical resource names. Do not silently alter those numeric tables without an explicit schema+balancing task. Naming legacy `blergians/manusians/aetherians` similarly requires careful migration to `org/man/eth`.

**Precedence and links:** This synthesis indexes — but does not override — [decisions](decisions.yaml) and [base ecologies](base-ecologies-and-expansion-2026-10-11.md). New relocation candidate goes to [relocation options](building-relocation-design-options-2026-10-11.md); proposals do not become canon solely by being documented.
