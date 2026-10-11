# Scalfagus — Three-Faction Network and Infrastructure Contract

Date: 2026-10-11
Status: **HISTORICAL earlier proposal, superseded when contradicted by DEC-021–024**.
**Latest canonical precedence:** [ORG two / MAN three / ETH one network](three-network-channels-and-destruction-2026-10-11.md), [physical world loot/recycling](world-loot-salvage-and-recycling-2026-10-11.md), [building-class annihilation victory](victory-defeat-building-classification-2026-10-11.md). Do not implement the obsolete separate ETH freight/control topologies, ORG nutrition-only vessels, separate mandatory Power Dock, or remote automatic interrupted-construction refunds.
Companion data: [ETH ether network](eth-ether-network-mechanics.yaml), [MAN Power Dock and ORG vessels](man-power-dock-and-org-vessel-mechanics.yaml), [test fixtures](network-mechanics-acceptance-cases.yaml).
Decision log: [decisions.yaml](decisions.yaml), DEC-018 / DEC-019 / DEC-020.
Precedence: This document **supersedes conflicting older ETH physical-courier-only relay assumptions** and older suggestions that ETH Matter/Volatiles must always be carried between pylons. It does **not** remove ETH MIN's physical extraction and delivery to a Nexus, the MIN blue construction beam, MAX being a Nexus from creation, MAN MID conveyor/wall/bunker, MAN MAX large warehouse/bunker, or ORG live-vessel-and-home-nourishment requirements. Every section distinguishes owner directions from proposals.

## 1. A comparison the player can understand

| Mechanic | ORG / Organites | MAN / Manusians | ETH / Etherans |
|---|---|---|---|
| Territorial infrastructure | Physically connected *living vessels* rooted at original home Nexus | Physical modular workshops, ground-mobile modules and local electrical connections | Immovable basic *Pylon/Obelisk* vertices in Ether Network and large Nexus cores |
| Farm / support analogue | Each viable connected finished living building contributes metabolic capacity | Online deployed generators contribute local power/supply | Active connected pylons contribute resonance/supply capacity |
| Basic logistics | Actual cargo transported by MIN/MID/MAX and flying mothers | Actual crates, sealed barrels and gas canisters hauled by workers, MID belts or MAX depot | Actual raw cargo delivered to a Nexus; after conversion into typed Ether, **network transfers between pylons** |
| What flows in infrastructure | Real nourishment, growth/viability signal, finite vessel effects. NOT one global matter wallet | Electric power through connected ports/wires; other materials remain physical. No material teleporter | Knowledge and **typed converted resource quantities** at bounded link/node capacity |
| Construction site | Live vessel physically reaches site; eligible care worker incubates cocoon | Site needs actual delivered materials by a nearby transporter/Nexus/workers; physical assembly | Occupied ETH MIN sustained NETWORK beam to eligible large node; network resources must be available for consumption |
| Growth/expansion | Root connection **and** recurring physical home-origin nourishment | Independent ground-modular outpost possible with its own power and material flow | Nexus initialization; afterward local knowledge and network inventory support independent expansion |
| On connection cut | Starvation/gradual wither after reserves/grace; no instant death | Independent electric islands, batteries sustain some load; belt cargo remains physical | Connected Ether graph becomes **two independent inventories**; local portion can fund construction |
| Natural attack target | Arteries and nourishment carrier loops | Power connections, generator/depot and exposed belt | Pylon articulation points, local Ether reserves and construction beam |
| Structural relocation | Rooted bases (special transplant still research-only) | Ground-only pack/move/unpack for equipped basic modules | Pylon immobile initially; optional future meditation-on-network reposition tech |

**Core shared accounting:** World sources have physical forms solid/liquid/gas (DEC-016); Matter/Volatiles/Energy remain canonical spendable categories pending an explicit resource-identity decision. **ETHER IS NOT A FOURTH CURRENCY.** It is a conversion/transport/storage *form* containing a typed and counted resource payload. Gas is not automatically Energy and gas remains infrastructure-gated.

## 2. ETH basic Pylon/Obelisk, Nexus and independent MIN

### 2.1 Owner-directed structure merge and 2–3 functions per chassis

The owner now uses **Pylon/Obelisk as one primary infrastructure building**, not two separately required buildings. This supersedes the earlier suggestion that an independent immovable obelisk should be built alongside a specialized MID pylon. Its economic chassis is the existing **ETH MID pylon**, with an immobile baseline and a future **optional** capability to meditate and relocate *along a valid line of its own network*.

- **Network/signal function** (always when alive and connected): connects nearby eligible nodes; carries information, blueprint requests/answers and contributes finite local network/support capacity.
- **Resource logistics/storage function** (STORAGE/RELAY mode): holds typed finite Ether inventory and accepts network transit and courier ingress at legal interfaces.
- **Defense function** (TURRET mode after positive-duration meditation): fires a bounded-cost weapon, **retains stored resource quantities** but suspends at least normal cargo loading/unloading and (in the default test variant) Ether resource transit through that pylon. The control/knowledge/support link may remain connected. This is a costed choice, not a free permanent combination.
- **MOVE BY MEDITATION** is not a base mode for the MVP. Owner: maybe a future upgrade letting pylons move to legal positions **on the existing network line**. It must not relocate between disconnected subnets without a separate explicit authorization.

**ETH MAX is the Nexus** from first deployment: major network node, local conversion endpoint, physical import from couriers, knowledge cache and founding bootstrap. It is not an upgrade to the ordinary MID pylon and not automatically a turret.

**ETH MIN** remains the independent physical gatherer/courier and a **busy NETWORK-mode builder** with a visible blue beam. It harvests uncaptured solids directly, manually taps liquids slowly or operates a required gas rig, as all races do.

### 2.2 Physical arrival, conversion and custody

Owner-directed pipeline:
1. MIN harvests physical cargo or collects from a local extraction rig.
2. A legitimate carrier hands that cargo to an eligible **Nexus** at a real legal port. Cargo ceases to be in the carrier and enters one accountable Nexus intake inventory.
3. The Nexus performs a real **conversion into typed Ether storage representation**. The economic resource ID and quantity provenance remain recorded. This is a change of storage medium, **not** transmutation of solids into arbitrary gas, and not a fourth abstract currency.
4. Converted Ether can travel from node to node over active Ether Network paths at finite node service rate, edge capacity and queue time; pylons locally store their own amounts.
5. When a builder spends construction inputs, the relevant ETH subnet must have enough unreserved typed inventory. Legal production **reserves**, **delivers as necessary** and **consumes** actual units once at a permitted construction receiver/site. No globally instant free withdrawal from distant obelisks.

**IMPORTANT clarification:** Since the owner says Ether can be handed between pylons, old specs saying ETH Matter and Volatiles must *always* be physically carried between pylons are now historical. **The physical delivery requirement ends at an eligible Nexus conversion endpoint** (or at another separately approved intake converter in future). Unconverted raw cargo never moves as Ether and may still need physical hauling to the Nexus. ETH network transfer is an explicit faction capability, not a free feature for ORG or MAN.

A proposed implementation record per transfer:
- origin physical source + source_form, economic resource_id (matter/volatiles/energy), quantity, original owner/funding lineage;
- representation physical or ether (transit does not change quantity or resource_id), source node, destination node, reserved amount, event tick/transaction ID;
- valid graph route and finite available capacity;
- atomic debit from one inventory and credit to the next **exactly once**, with no simultaneous counted duplicates, no zero-time long-range delivery, no negative node holdings.

The exact **conversion Energy/processing fee or yield** is not yet owner-selected. Keep a configurable no-duplication conservation rule; any fee or waste must be a separately named actual consumed source, not an arbitrary disappearance or newly minted resource. MVP may set lossless re-encoding to isolate routing behavior while preserving nonzero conversion time and finite capacity.

### 2.3 "Even distribution" means fair proportional fill, not instant cloning

Owner: *network resources are evenly distributed*. Safest precise candidate:
- For **each resource ID separately** and each **connected active Ether transport component**, equalize **stored fill percentage of eligible node capacity**, not a magic global one-bank currency.
- If all pylons have the same per-resource capacity, this reduces to equal quantity per pylon; a Nexus with much larger capacity receives proportionally more. Nodes may reserve inventory for player-authorized construction, and those reservations are unavailable for balancing.
- Compute target fill: for node i and type r, target_i,r = total_unreserved_r * capacity_i,r / sum(capacity_j,r), subject to reachable connected nodes, finite link bandwidth and rounding.
- Prioritize explicit player-approved construction consumption, legitimate delivery, then background equalization; use a deterministic deficit/surplus router with finite per-edge/node per-tick transfer volume and stable node-ID tie breaks.
- Nodes join the equalization set only if eligible for Ether transfer. A turret may remain part of knowledge/support graph but stop cargo/ether freight service (proposed default), splitting the **freight** graph without destroying the control/supply graph.
- Backpressure/full nodes pause; there is no instantaneous resource credit and no double spending while equalization is in flight.
- UI shows actual local stocks plus reachable component totals, pending and reserved items. **Available now** vs **available after routing** cannot be confused.

**Example:** Six identical online pylons each hold 20 units of the same resource (total 120). A link break splits them into 2-node and 4-node components. Their real retained resources are **40 and 80**. Each can now spend only its local 40/80 minus active reservations. No 50/50 forced split, no bank refund and no 120 replicated to both.

**Different capacities example:** 3 pylons with capacities 10, 20, 30 share 30 units. Their long-term equalized targets are 5, 10, 15. A cut after convergence isolating the 10-capacity node leaves it with 5, the other side with 25. The split consumes or generates **zero resources**.

If a cut happens **before equalization completes**, each part retains exactly its **actual balances on that tick**, NOT an ideal capacity-based theoretical allocation. This is crucial: a surprise raid should deny a new expansion access to the parent stock even if equalization would have eventually replenished it.

### 2.4 Two graphs, one set of pylons — clean state semantics

Use two logical edge permissions over the same visible physical pylon/Nexus topology:
- **CONTROL/KNOWLEDGE + SUPPORT graph:** alive network links, eligible signal service. Used for blueprint sync, control/synchrony cap. Pylon in turret can maintain it. Initialized local Nexus with cached plans remains operative when isolated from home; unknown plans need a working legal link to a library that knows them.
- **ETHER FREIGHT graph:** only nodes/interfaces currently allowed to route or store/disburse typed Ether. In STORAGE/RELAY mode ports are open. During meditation and in the baseline proposed TURRET mode resource transfer ports are closed, including through-traffic for the test model. This can isolate a store, but does not automatically cut knowledge.
- **Conversion at Nexus is a separate port state**, so an active Nexus can intake physical raw cargo, convert at finite rate, then enter Ether freight routing even when remote pylons are defending.

Competing variant to test: turret closes **physical courier intake** but permits reduced Ether through-traffic. Never hide this as approved; benchmark game clarity and raid viability against complete freight lock.

### 2.5 Connectivity transitions, partitions, mergers, deletion

**Graph rebuild:** On structure finish/death/move, mode switch, link destruction or obstruction, update affected connected components; do not globally teleport/rebalance inventories.

**Partition:** preserve node identities, local typed inventories, local capacity, reserved commitments if still legal, source lineage and local blueprint caches. Recompute reachable component totals after graph split. New building orders may use only funds actually held or eventually routed **inside their current freight component**. Unreachable queued transfer reservations are canceled/replanned deterministically without negative stock.

**In-flight policy proposal for minimal MVP:** an Ether hop is committed atomically at an acknowledged fixed-tick end. Until that tick the item remains reserved at the previous node; if the connection is cut, reservation is released **at that previous node** and the next hop does not happen. The visual beam pulse is cosmetic progress of the pending hop; no true independently stored edge inventory for MVP. This avoids invisible instantaneous transfer, currency duplication and ambiguous edge ownership. In a later physically explicit in-flight edge model, the edge must own a separately counted escrow with deterministic drop/destination rules.

**Merger:** add the two current component balances, never regenerate or divide equally at the merge tick. Resume finite routing/equalization and optional sync; no late "home network" mandatory ping for already cached plans.

**Pylon destruction:** whether stored Ether drops as recoverable typed packets, can be captured, or is lost needs owner balance decision. Under **all** options, it is removed from the player's network ledger exactly once, and potential world drops are explicitly created once; no phantom recovery.

**Capacity reduction when a node is killed:** no instant redistribution of destroyed node's stock to surviving network. If a surviving subnet has temporarily too many committed reservations versus new support cap, block new allocations rather than retroactively erase already finished buildings/units.

### 2.6 Building and support after split

- Pylon is the ETH Farm analogue: increases locally usable **Resonance Slots** when legal and supplied by connected, initialized local authority.
- Supply is **support capacity**, not a fourth economic resource. Unit and building resonance demand is finite.
- Isolated initialized expansions retain their cached blueprints and own typed Ether; constructions cost and consume actual local network inventory.
- An isolated expansion without any eligible Nexus/large node may lose authorization to construct via ETH MIN beam, **even if other pylons still store Ether**. Stored goods do not materialize a Nexus or a valid construction beam automatically.
- ETH construction progress reset when the **last required active blue beam** is severed remains per DEC-015; any bounded refund must credit the correct *currently reachable* node/accounting location or create a legitimate recovery packet, not leap a destroyed link.

## 3. MAN mobile Power Dock, electric ports and physical construction materials

### 3.1 One ground-only basic power-support structure

Owner direction: the **basic MAN building is land-mobile**, is a **power generator**, and can act as **warehouse or bunker**. Its functional name here is **Power Dock**. Avoid adding yet another universal combat/building unit.

Proposed core **three mutually exclusive modes**:
1. **POWER / DEPOT (deployed):** produces finite valid Energy output or electrical PU budget under an installed generation source; recharges nearby batteries and exposes a **small local cargo depot** and construction pickup point. Not a large MAX depot.
2. **FORTIFIED / BUNKER (deployed):** grants actual defensive protection and a bounded garrison. Local storage service is disabled or restricted and generation/charging are **reduced**, not fully free. Its defensive weapon/embrasure is weaker or more restricted than the specialist MID bunker. Requires legal soldier slots and an actual unit, not free generated damage.
3. **PACKED / GROUND TRAVEL:** can move on passable terrain with actual footprint and slow speed, loses wired connection and normal generation, retains bounded onboard battery/cargo; unpack needs time and collision/placement validation. No flight or instantaneous teleport.

**Hard balance rule:** Power Dock is a **small basic settlement/power-support module**, NOT a replacement for MAN's prior economic MID or MAX. Keep its storage/defense/energy caps narrow, and ensure mode switching has actual time/risk so mobile construction does not yield unraidable power. Exact whether this chassis should be a new small base component versus an attachable kit on existing MAN frame is unresolved, and MUST be benchmarked against the goal of fewer unit/building templates.

### 3.2 Role boundary, no accidental MAX replacement

| MAN template | Primary job | Secondary/alternate job | Must NOT inherit by default |
|---|---|---|---|
| **MIN worker** | Mine and directly carry physical cargo | Assemble and repair if equipped | Infinite power production, free cargo teleport |
| **Power Dock (basic base module)** | Generate power and recharge / supply cap | **Small** local construction stock or limited shelter/bunker, ground pack-and-move | 3/5-tile high-throughput belts, large cargo warehouse, large garrison, heavy turret |
| **MID tracked module** | **3- or 5-tile** continuous conveyor and real packet buffer | **One-person armed bunker OR outward sentry wall** (existing mode set) | Free generator/charging hub or significant strategic bulk storage |
| **MAX tracked depot** | **Large** cargo storage, long-haul ground logistics | Multiple-soldier bunker on costly unload-and-mode switch | Permanent generation without a generator kit, or automatic remote power in transit |
| **Nexus composition** | A system of modules including eligible HQ/Power Dock/production/storage | Can be geographically split | Required single immobile building or hidden all-map material bank |

If playtests show Power Dock garrison too similar to the MID one-soldier bunker, **prefer a shared configurable shelter module or only defensive cover for Power Dock** rather than introducing a new combat asset.

### 3.3 Automatic electric connections — not a physical-material network

**Candidate for MVP:** no player-drawn wires. Neighboring **deployed** MAN modules with valid electrical connector faces/ports, within short legal snap range and with no obstructed path, **automatically create a visible cable link**. The cable is a real graph edge with limited electrical transfer rate; it is not a physical cargo belt. Moving/packing disconnects/reconnects it.

- Power Dock generation feeds a local grid; local batteries and depots actually store finite Energy (canonical stored resource). Local **PU** is an instantaneous power-delivery budget/status, not a new stockpile currency. The grid may transport actual metered Energy (E) along edges, subject to production, storage and consumption; no magical global charge.
- Generator input can be geothermal/solar/fuel with a legitimate recipe and site conditions. It must not indefinitely mint charged batteries with no finite generation rate/source.
- MAN independent outposts can host a Power Dock and battery; do **not** require connection to distant home. On cut, there are independent electrical islands; on-board batteries allow units to keep moving for a finite grace period.
- Brownout policy proposal: suspend new production / slow recharging first, then degrade power-hungry equipment as reserves fall. Do not instantly kill already built army.
- **Only electricity uses this cable graph.** Solid, liquid, gas and other construction materials are NOT delivered through electric wires.

### 3.4 MAN building worksite material sourcing (owner direction)

An eligible builder can consume real materials from:
1. Its own finite carried inventory;
2. A nearby compatible universal transporter or **local Power Dock**, if it is within valid loading range, in an accessible warehouse mode and has stock;
3. A nearby **MAN MAX** warehouse / suitably equipped composite Nexus module;
4. A direct source (deposit or completed extractor for gas) the MIN physically visits, then brings actual portions back to the construction site.

Auto-assist may issue finite fetch-and-carry suborders for a player-approved construction site (no free autonomous expansion). Reserve before pickup, move actual packet/cargo, receive at site and consume/affix actual portions. Partial MAN worksite progress and invested materials persist when builders leave (DEC-015); unfinished/destroyed sites yield bounded recoverable physical salvage. **Do not permit build to debit a remote MAN depot merely because it is on the same electric network.** Electrical and cargo graphs are separate.

**Recommended failure scenario:** power remains available while the builder is starved of Matter; building must pause for materials rather than completing. Conversely, parts may be piled beside an unpowered module, but powered operations pause/brownout.

## 4. ORG living vessels are NOT an alternate Ether Network

Owner: **Every ORG rooted building must be connected to a physically living vessel graph**. Unlike ETH, this is an actual living nutritional and structural dependency, not an all-purpose global teleport/bank.

- ORG source materials are picked up and transported by equipped workers, MID handlers and flying mothers. The initial MAX mother runs exclusive MOVE / RECEIVE / DISPATCH / EXTRACT modes; one worker and one item per handoff unless later researched (DEC-011).
- Vessels provide **placement/growth eligibility**, nutrient signal and finite actual nourishment transfer between nodes; vessels are destructible and have local finite stores and transport constraints. They do **not** expose a free pooled global Matter/Volatiles/Energy wallet.
- Distant colonies need **both** a continuously connected home-origin live vessel **and** recurring **physical home-origin nourishment deliveries**, despite local mining. A full vessel alone does not satisfy shipment; a shipment alone does not repair a severed vessel.
- Each completed viable connected building contributes metabolic **support cap** (Farm analogue). Actual biological upkeep and feeding remain separate finite consumption; creating a building must not conjure nutritious resource inventory.
- Sever a critical vessel: the branch enters ISOLATED_BUFFERED, then STARVING, DORMANT, WITHERED over time (thresholds TBD). Mobile living units retain individual agency and finite carried supply; there is grace and opportunity to repair/regrow. No instant global disappearance or automatic loss of all carried cargo.
- A caretaker-sustained budding cocoon uses ORG staged 3→2→1 contributors. Work stops and gradually decays when untended; being on a healthy branch is a separate requirement, not a substitute for caretaker actions.

**Contrast:** ORG topology carries **dependency/biological throughput**, MAN cables carry **electricity only**, ETH Ether links carry **typed resource stock and information**.

## 5. Typical event sequence for one faction

**ORG:** authorize remote bud → grow continuous vessel → MIN/MID/MAX deliver required physical materials → 3→2→1 caregivers incubate → completion contributes metabolism → recurrent home nourishment mother route → enemy cuts vessel → local reserves decline and organisms/buds wither gradually.

**MAN:** MIN harvests loose solids → hauls to local Power Dock in depot mode / MAX or brings directly to worksite → Power Dock automatically electrically connects to deployed neighbors → MIN constructs at proposed 1→2→2 labor maxima → Power Dock may fortify (less recharge; storage unavailable) or pack (no generator; cable disconnects) → enemy cuts cable → charge in local batteries supports bounded fallback while actual packets remain in their containers.

**ETH:** MIN physically mines and reaches Nexus → Nexus converts into typed Ether while preserving resource amount/class → connected MID pylon graph routes and gradually equalizes individual node inventory → ETH MIN begins 1→2→3 occupied construction beam job at legal site → local network reserves and consumes real resources → enemy severs central obelisk link → components retain actual local balances and local initialized cached known blueprints → each independent side can continue only up to its own reachable stock and authorizations.

## 6. Concrete acceptance and benchmark tests (design contract, no code execution claimed)

- **NET-001:** ETH 6 equal pylons, 20 per node; cut at 2+4 => component balances 40 and 80; source ledger sum remains 120.
- **NET-002:** ETH 3 pylons with capacities 10/20/30, resource total 30 => eventual 5/10/15, *not* immediate if bandwidth low.
- **NET-003:** ETH cut during incomplete equalization => actual node holdings retained, not recomputed theoretical 40/80.
- **NET-004:** ETH split followed by builds: component A cannot spend B inventory even if A once belonged to same network; local Nexus/beam authorization still required.
- **NET-005:** ETH merge two components => conserve summed balances; no multiplication or immediate redistribution.
- **NET-006:** ETH turret mode keeps control/support but stops normal freight throughput; cargo remains frozen until reset; alternate partial through-traffic is an experiment.
- **NET-007:** ETH raw solid/liquid/gas cargo may enter Ether ledger only after legal physical arrival and Nexus conversion; source_form preserved, no cross-type conversion.
- **NET-008:** ETH beam construction interrupted after funding => full progress loss with no cross-partition refund teleport, conserved actual reserved/reclaimed stock.
- **NET-009:** ETH destroy a storing pylon => exactly one clearly accounted cargo loss/drop, not zero or double-counting.
- **NET-010:** ETH capacity from pylons and finite bandwidth independently affect support, service and graph path cost; adding disconnected pylons does not globally increase another network's freight speed.
- **NET-011:** MAN Power Dock POWER→BUNKER→PACKED transitions show correct local generation/charging, small cargo and garrison availability and land-only mobility.
- **NET-012:** MAN small Power Dock may not replace high-throughput 3/5 MID belt, large MAX warehouse or large garrison at equal cost.
- **NET-013:** MAN two nearby deployed connector-equipped modules auto-link to a finite power grid; pack one and link disappears; independent new island can run via local generator.
- **NET-014:** MAN builder can use nearby stocked legal Power Dock/transport/MAX or carry materials from a source; cannot debit remote material inventory through power cable.
- **NET-015:** MAN power outage after cut does not delete installed unfinished construction percent or physical salvage; finite batteries sustain legal local operation.
- **NET-016:** ORG cannot bud without a live home-connected vessel; network cut triggers timed stages, not ETH-style resource-bank partition or instant extinction.
- **NET-017:** ORG a connected branch without actual home-origin recurring nutrient shipments still runs short of nourishment.
- **NET-018:** All factions build using the most recent stage crew profiles ORG 3→2→1, MAN 1→2→2, ETH 1→2→3; limits indicate maximum contributors, not required quorums.
- **NET-019:** Gas remains rig-gated; manual solids and small slow liquid tapping still work under all three networks.
- **NET-020:** Fixed-seed simulation, ordered events and restart/replay preserve typed resource conservation and local component splits.

### Main experiments and what is explicitly NOT decided

1. **Ether equalization policy:** default candidate proportional *fill ratio*, not absolute raw totals; tick rate, node/edge capacity, reserved-stock priority, offlining a turret and user preference overlays require real playtests.
2. **Ether inventory when a pylon is killed/captured:** drop/capture/destroy fraction, cargo in flight, reconnection edge cases and processing cost require a chosen rule; conservation requires explicit loss/drops.
3. **Power Dock role collision:** A (small independent base module; narrow defensive stock), B (a swappable generator kit on an existing tracked chassis), or C (a power-only charging attachment to existing MAN MAX) must be A/B tested for overpowered one-building starts and too many templates. **The user has approved its functional direction, not its exact unit/chassis implementation.**
4. **Power link wiring:** short-range auto-connector is recommended instead of manual cables for MVP; connector radius, damage, obstruction, recharge range and repair costs are TBD.
5. **Ether transport cost/performance:** no global instant inventory, preserve resource IDs and finite transit; whether conversion spends extra Energy or has efficiency loss remains open.
6. **ETH pylon relocation:** mobility tech, duration, legal in-network destination, cargo service during move and ability to bridge two subgraphs remain **future research, not baseline**.
7. **Farm-like resource relationship:** ORG viability/capacity, MAN PU generator load and ETH RS resonance cap are support/rates, not extra primary currencies. No precise capacity numbers are treated as approved.

## 7. Minimal MVP implementation strategy

**MVP implementation contract proposal, not claim of implemented software:** single immutable authoritative resource ledger and fixed-step event order; three adapter graphs and capability-tagged templates. Phase I MAN one-faction playable: physical cargo fetch/build, small depot/generator/battery, auto-link power and brownout; preserve current MID/MAX as separately bounded roles. Phase II ETH adapter: typed Nexus conversion, finite link service, pylon mode toggles, proportional equalization, split/merge snapshot, known blueprint local expansion. Phase III ORG adapter: vessel construction, real home nourishment, 3→2→1 incubators, withering and mother-stop cargo delivery.

Each phase retains ordinary RTS build orders, unit command authority, the same physical world and a Hero that can switch perspectives as already required by [internal MVP](mvp-iso-pixel-rts.md). ETH advanced building railgun and pylon move upgrade, deep MAN power-grid electronics and physical fluid pressure simulation are explicitly **post-first-MVP**.
