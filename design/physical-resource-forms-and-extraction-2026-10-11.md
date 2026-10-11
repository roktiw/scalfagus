# Scalfagus — Solid, Liquid and Gaseous Deposits: Three Extraction Gates

Date: 2026-10-11
Status: **OWNER-DIRECTED CORE EXTRACTION RULES**, with material-to-currency mapping, numbers, world generation and advanced packaging **OPEN**.
Machine-readable contract: [physical-resource-forms.yaml](physical-resource-forms.yaml).
Decision: [DEC-016](decisions.yaml).
Related existing canon: [resource balance](resource-balance.yaml), [Energy](energy.yaml), [faction logistics](faction-logistics.yaml), [base ecologies](base-ecologies.yaml), [MVP](mvp-iso-pixel-rts.md).

## 1. Approved physical forms are about gathering rules, not a hidden replacement of the three canonical spending currencies

**Three physical deposit/extraction classes:** `solid`, `liquid`, `gas`.

**Three established primary economic resource IDs:** `matter`, `volatiles`, `energy`. Keep them until the owner explicitly chooses a resource-accounting replacement. **Energy is not a gas**, and a source having `form: gas` does not make gas equivalent to Energy. `form` describes how a deposit exists in the world and how it must be extracted/stored/transported; `resource_id` describes the actual credited or spent game economic asset.

**Unresolved accounting design**: decide which source classes yield Matter, Volatiles, Energy after harvest or on-site conversion. A conservative prototype example (NOT CANON): loose solids yield Matter; liquids yield Volatiles; gas capture can yield compressed volatile feedstock or supply an on-site conversion generator yielding Energy at a fixed paid recipe. Solar/geothermal Energy generation also remains a legitimate existing Energy source and must not be silently removed. If raw captured gas becomes a transportable feedstock, it is a **typed physical packet / limited intermediate inventory**, not automatically a fourth abstract universally spendable currency.

This distinction is critical: do not migrate the old `crystals/gas/resin` YAML names by a blind mapping of `gas` into the Energy resource, or assume that the former legacy `gas` economic tier authorizes hand-harvesting from gas vents. Existing `economy.yaml`, `resources.yaml` and `units.yaml` are historical proposed data pending deliberate schema and price migration.

## 2. The fundamental three-class rule — owner direction

| Attribute | SOLID | LIQUID | GAS |
|---|---|---|---|
| Typical look | Loose crystals, rocks, rubble, wood-like organic Matter, scattered deposits | Pools, springs, seeps, reservoirs, liquid wells | Vents, fissures, pockets, fumaroles, pressurized fields |
| Distribution | **Scattered across the accessible planet/map**; individual finite nodes/patches, not only big mines | Spatially concentrated liquid sources | Recognizable, capturable gas-source sites |
| Worker extraction at game start | **YES**: walk to node, harvest a portion, carry it | **YES**: slowly collect **small individual portions** and carry in a compatible container | **NO**: workers cannot directly scoop/freehand harvest from an uncaptured gas source |
| Structure to collect the very first portion | **NOT required** | **NOT required** | **REQUIRED** at the deposit |
| Investment option | Optional higher-throughput mine/drill/collection improvements, not baseline gate | Pump, wellhead/intake, reservoir, loading interface: faster larger volumes | Collector/capture head, sealed piping/interface, storage/compression and perhaps processing: mandatory capability |
| Independent MIN bootstrap | Fully viable as sole income from solid sources | Limited viable manual income if worker can carry sealed small packets | Not viable before collector exists, **by design** |
| Typical world cargo | Actual discrete crates, sacks, mineral/wood chunks | Bounded leak-proof flasks, bags, barrels, cisterns | Sealed canister, pressure vessel or closed wellhead output, with meaningful handling capacity |
| Main counterplay | Contest exposed workers and scattered patches | Ambush manual couriers, raid installed pumps | Fight for fixed extraction rig and connected logistic bottlenecks |

### A. SOLID — scattered starter resources, no infrastructure gate

Owner visual touchpoints: Warcraft II wood harvesting, Dune II / C&C field harvesting, Factorio surface rock/mineral nodes. Scalfagus uses **original** units and art, with the shared idea of **immediate harvesting from resource objects**.

- Place many accessible finite solid nodes/patches around the planet so every faction can create its first positive material-income loop with only its MIN worker, reachable storage, and a normal gather order.
- The MIN explicitly mines/picks up from the node and transports a **real cargo portion** to a compatible receiver. No mine, refinery, wellhead, pipe, live conveyor or extractor structure is required merely to start harvesting.
- Building a collector, drill, quarry, specialized organ or material-processing plant can later improve throughput/handling where worth its actual cost, but must not retroactively gate ordinary initial extraction.
- Individual nodes deplete. Cluster density, unit slots, deposit hardness, regeneration and exact art are future map/balance choices.
- Stone, wood analogues, crystals and rubble are **world appearance/source templates**, not four new global resource currencies by default.

### B. LIQUID — direct manual trickle OR installed pump

- A MIN with compatible modest-sized fluid storage can **directly draw a small portion** from a pool, spring or surface source and carry it to a tank/compatible depot. This is deliberately **slow and low-capacity**, not impossible or always infrastructure-gated.
- Upgrade path: an explicit faction-compatible **pump/intake/wellhead**, with finite extraction ports, rate, loading time and storage. A real pump, tank, line/vehicle or alternate carrier changes the economic ROI at a contested liquid source.
- Make the manual method meaningful for **first access, emergency recovery and small tactical consumption**; make the installed extraction substantially better for a sustained industrial economy after payback time.
- The initial liquid collection capability must not force an additional dedicated technological currency or require a gas extractor just to build the first liquid pump. Sealed tiny containers may be considered part of the worker's base equipment.
- The source is finite; no implicit infinite lake unless an authored scenario explicitly opts in.

### C. GAS — collector first, never hand-harvest from a vent

- A worker alone at a raw gas deposit has **no direct extract action**. The player must **build/activate a compatible extraction installation** on/next to the source, using legal builders and actual previously available resources.
- Only when the rig is finished, powered/operational if required and has free output capacity can it capture gas into a **finite sealed local container** or feed a separate valid processing/generation recipe.
- No generic early MIN obtains gas by standing near a vent, magical absorbing, or claiming a warehouse slot; variants for ORG biological bladders, MAN industrial compressors and ETH resonant containment still honor the **structure-first requirement**.
- Material stored in the capture rig is **not automatically credited to an unlimited faction-wide inventory**. It either physically leaves as safe cargo in valid containers or is consumed by an explicit on-site conversion recipe.
- Pumps vs pipes vs pressure tanks may vary by faction. **For the first MVP implement one gas capture building with a finite local output queue**, not a complete fluid simulation.
- Gas infrastructure must be bootstrappable without needing that same unavailable gas output or an unreachable amount of Energy. Define low-tier material-only recipe or guaranteed starter/alternate Energy supply.

## 3. Three factions, same access gates but their own infrastructure designs

| Phase | ORG — Organites | MAN — Manusians | ETH — Etherans |
|---|---|---|---|
| Solid hand harvesting | MIN biological gatherer picks loose surface material and physically delivers it | MIN suited worker / drill uses direct extraction and haul | MIN courier/extractor gathers solid pieces and delivers |
| Liquid manual collection | MIN siphons/scoops tiny droplets into organic fluid sac | MIN draws into small sealed canister | MIN draws into contained resonance vessel |
| Liquid installation | Living organ/pump budded at a **live vessel-linked legal site**; physical input/output | Modular pump and finite tank can be built in a **fully independent expansion** | Resonant well intake built by occupied NETWORK beam with legal large-node support |
| Gas installation | **Capturing organ** grown at a legal connected living branch, not free raw-organism gas inhalation | Physical collector/compressor with real module, repair and route | **Resonant containment/collector structure** built via sustained legal blue beam, not a free field ability |
| Carrier | Biological cargo sacs; mother MAX stops to receive/dispatch before tech | Sealed barrels/cartridges on tracked conveyors or slow ground depots; exposed lines are attackable | Sealed courier packets, MID pylon finite storage/relay and MAX Nexus interfaces; no free matter teleport |
| Counterplay | Attack ORG live vessel, maintain forced feeding cost, raid liquid/gas cargo mother | Break belts, destroy pump/compressor, intercept isolated independent outpost | Disrupt construction beam before rig forms, shut down pylon service by turret mode, destroy critical node |

**ORG fairness:** A gas capture structure still requires a live vascular path, so the faction may have a harder time claiming a detached vent. Keep placement geometry, early-map solid access, vessel-growth costs and late-game gas-site difficulty viable; do not accidentally deny ORG gas on every reasonable map.

**MAN fairness:** Independent extractors and pumps are a benefit, but building modules and supply routes cost real materials/space/time. Conveyors do **not** carry exposed uncontained raw gas or free-flowing liquid packets unless a specific compatible sealed cargo module exists.

**ETH fairness:** Holding one construction worker in NETWORK beam mode can make initial gas rigs slower and more visible; the same pump/collector requirement applies to all factions. Energy spent on gas capture cannot be circularly required as the only way to acquire the first Energy.

## 4. Why this makes a comprehensible MVP resource loop

Suggested **MVP test** progression (world gate only, no compulsory timer):
1. Player starts with MIN gatherer and reachable compatible storage. MIN harvests a **solid** loose patch and returns a real packet. This alone funds early construction.
2. The player discovers a **liquid** pool, tests slow manual collection with MIN, then decides to invest in a pump. Pump gives sustained efficiency, creating an understandable choice rather than a binary lock.
3. The player discovers a **gas** vent. Clicking with an unassisted MIN shows **"Extractor required"**, with a contextual build order and its legal faction construction dependencies.
4. Upon finishing the gas rig, it begins emitting a bounded sealed packet or legitimate converted product for worker pickup. Enemy can interrupt site/transport. Player can use output for appropriate production/technology after a valid recipe.
5. Once all three states work, repeat the same scenario under ORG, MAN and ETH building/transport logic; no second resource or physics simulator per faction.

**Vertical slice MVP scope recommendation:** solid direct harvest first; liquid direct + pump next; gas required extractor next. A fully playable **three-race alpha** should honor all three forms, but the initial one-faction 10-minute engine spike can prove one solid loop before implementing pumps/gas. This is a technical sequence, not an exception to the final resource-gate rule.

## 5. Edges, state contract and anti-softlock

For each authored source object:
- `source_id`, `form` (solid/liquid/gas), `position`, `remaining_quantity`, `extractable_units_per_operation`, `workers_or_ports_limit`, `terrain_footprint`, `visibility`, `extraction_mode`, `supported_container_types`, `depletion_policy`, `compatibility`, `time_and_energy_costs`.
- SOLID and LIQUID direct extraction must accept normal MIN orders without an attached building. GAS direct extraction must fail at order validation **before any cargo appears**; full or damaged rigs suspend output.
- Every extraction or output reservation is **transactional**: reduce source quantity exactly when a physically identified packet/stock is created, never twice and never before a legitimate process/tick finishes.
- Empty/blocked depot or incompatible vessel makes worker wait/reroute; does not create global stock.
- A destroyed liquid pump may leave accessible hand-harvestable source for recovery. A destroyed gas capture rig makes the raw gas inaccessible until repaired/rebuilt; previously captured physical packets remain separately accounted.
- Queues, congestion, changed modes, missing carriers, worker death, supply interruption and structure attack must never spawn infinite material.
- Dynamic smoke/vapor can signal a gas deposit's position; the visual effect itself isn't collectible gas.

## 6. Balance knobs and measurement — not canon numbers

| Parameter | Solid | Liquid | Gas |
|---|---|---|---|
| Initial node density | High dispersed | Lower, grouped | Lower or strategically placed |
| Worker direct throughput | Standard | **Significantly below an efficient liquid pump** | **Zero without infrastructure** |
| Infrastructure payback | Optional | Must justify pump investment | Rig cost is nonoptional |
| Main map pressure | Many small harvesting opportunities | Contest concentrated accessible basins | Contest visible capture sites |
| Starter economy requirement | At least one accessible source per start | Optional manual access to prevent lockouts | No gas required to bootstrap its own extractor |
| Strategic scaling | More workers, advanced mines | Pump rate, tank, routes | Capture rate, containment, route, conversion |

Do **not** assume that three physical states must be early/mid/late gameplay tiers. The player may encounter all three early; **their extraction gate** differs. Economic importance can change across game phases after test-driven recipe decisions.

Critical choice: keep the world's three physical forms orthogonal to resource spending types until direct owner confirmation of a mapping. Otherwise the early consensus that stored Energy is a distinct economic type would be silently erased by a physically inaccurate "Energy = gas" substitution.

## 7. Tests and definition of done

| ID | Scenario | Expected |
|---|---|---|
| FORM-01 | MIN directly gathers solid with no mining building | Succeeds after finite work, creates one real removable item |
| FORM-02 | Dispersed solid sources surround start | Each of three factions can establish basic self-funded economy |
| FORM-03 | MIN manually taps liquid without a pump | Succeeds with small container and low throughput |
| FORM-04 | Liquid pump installed at same source | Sustained output higher than one MIN manual collection after accounting for costs |
| FORM-05 | MIN directly orders extraction from uncaptured gas vent | Order rejected with extractor-required explanation, no packet debited/created |
| FORM-06 | Gas rig constructed without gas | Possible through preceding legal resources/technologies, no circular lock |
| FORM-07 | Gas rig captures resource | Finite queue/capacity, real source debits, sealed packet/output only |
| FORM-08 | Man belt moves fluids/gas only via compatible packaging | No loose/invalid package magically flowing on solid conveyor |
| FORM-09 | ORG tries to bud gas organ away from living vessel | Must establish physically connected vessel before extractor is viable |
| FORM-10 | ETH MIN attempts gas capture without NETWORK-built installation | Must complete legal rig with real beam/build time |
| FORM-11 | Liquid pump destroyed | Manual draw remains possible if source reachable |
| FORM-12 | Gas rig destroyed | Raw gas capture stops; existing independent captured cargo conserved |
| FORM-13 | Storage full or wrong container | Worker/rig pauses or reroutes without resource loss or duplicate credit |
| FORM-14 | Source depleted | Finite source reaches zero and produces no further cargo |
| FORM-15 | Energy conversion from gas chosen later | Gas conversion uses approved real recipe and does not silently rename Energy as gas |
| FORM-16 | One-faction vertical slice then 3-faction alpha | Solid→liquid→gas gates reusable in one authoritative extraction rule engine |

## 8. Explicitly unresolved after this conversation

- Are solids/liquids/gases **only deposit classes** under the approved Matter/Volatiles/Energy wallet, or does the owner intend to **replace** the primary resource taxonomy? This document adopts the nonbreaking deposit-class interpretation until told otherwise.
- Which concrete raw liquids and gases yield which stored canonical resources, and which are merely intermediate local captured packets.
- Can liquids be passively transported in a pipe network, or only as discrete container cargo in the first MVP? Initial model: finite sealed packets; advanced pipelines are optional.
- Gas rig upgrades: compression, pressure, capacity, leakage, explosion hazards, environment effects and weapons are **not** part of the basic MVP. They require separate balancing and performance specs.
- Authored maps: proportions of accessible scattered solids, grouped liquids, gas vent positions, total reserve and source regeneration policies.
- Quantitative manual-liquid-to-pump rate ratio, starter kit container capabilities, per-unit throughput and exact extractor costs.

**Precedence:** New DEC-016 extraction gates supersede earlier examples where a generic worker can harvest any source form without an installation. DEC-001 Energy remains stored, transportable and spendable; gas is not Energy.
