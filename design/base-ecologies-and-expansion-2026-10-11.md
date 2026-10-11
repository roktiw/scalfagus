# Scalfagus — Three Base Ecologies: Organite Vessels, Manus Modularity, Etheran Networks

Date: 2026-10-11  
Status: **owner-approved directional canon** for faction economics, base architecture and economic MIN/MID/MAX identities. Exact balancing formulas, special-case terrain connectors, timings, visibility/fog rules, recovery windows and costs remain **proposed or TBD**.

**Authoritative technical companion:** [base-ecologies.yaml](base-ecologies.yaml).  
**Related:** [logistics-unit-scales.yaml](logistics-unit-scales.yaml), [faction-logistics.yaml](faction-logistics.yaml), [deployment.yaml](deployment.yaml), [factions.yaml](factions.yaml), [decisions.yaml](decisions.yaml).

## 1. Overview — three different shapes of civilization

| Dimension | ORG / Organites | MAN / Manusians | ETH / Etherans |
|---|---|---|---|
| Economic philosophy | **Hunter–gatherer organisms** | **Modular industry** | **Distributed resonant knowledge network** |
| Base metaphor | One rooted, **vascular living organism** | A **modular ensemble of vehicles/structures**, not one mandatory command building | A graph of **pylons and Nexus-class nodes** |
| Time-lapse signature | A **branching organism spreads** from a planted root | A **crawling, radially growing, vertically rising** industrial cluster | A **node-and-beam constellation** appears, disconnects/reconnects and sometimes levitates |
| Fixed versus mobile | **Least mobile base** and anchored buildings; economically mobile worker/carrier fauna | **Most physically movable base**; few obligatory permanent foundations | Some buildings may levitate and reposition after meditating; most hubs static while operating |
| Early harvesting | MIN personally mines/carries; MID/MAX carry larger batches | MIN mines/carries, then MID conveyors and MAX storage | MIN mines/carries and dispatches through MID pylons and MAX cores |
| Main map connection | **Physical living vessel / root chain** from a Nexus | **Optional conveyors and interfaces**; no home tether | **Information + local relay links**, not obligatory continuous home connection |
| Expansion independence | **Least**: branch connected and **continuously nourished** from home | **Most**: isolated colonies fully self-supporting if locally equipped | **Middle**: must synchronize on foundation and request unknown blueprints, thereafter operates from local knowledge and stocks |
| How buildings appear | A **living vessel must arrive** first; eligible builders bud structures along it | Modular units transport/connect/prefabricate structures; some units change mode | Builder **enters NETWORK mode**, stays to maintain visible blue beam to nearest eligible large network node, consumes resources to instantiate structure |
| Vulnerability | Cut a vessel branch or intercept food carriers: distal colony **withers** | Raid a moving modular base or cut conveyors: traffic stops but independent colonies survive | Strike a relay/Nexus, intercept beam construction, suppress local storage or force defensive mode |
| Player's mental task | Where to grow branches, how to feed them, how to escort biological freight | Where to position/reposition modules, when to trade throughput for walls and bunkers | Where to site Nexus and pylons, when to reveal construction beam, when to meditate/move/defend |

All races share physically accounted **Matter / Volatiles / Energy** and finite inventories; crystal ore is a visual Matter source. Distinguish resource consumption from topology/information requirements. Never create fourth mandatory resource currencies out of "food", "resonance" or "blueprints"; those are **logistical needs, functional access conditions or research state**.

## 2. Economic units — the revised MIN/MID/MAX canonical roles

| Tier | ORG / Organites | MAN / Manusians | ETH / Etherans |
|---|---|---|---|
| **MIN** | Small independent organism, fastest personal extractor and courier, limited slots; with permitted growth organ, **buds L1 buildings** along a connected living vessel | Versatile **SCV-like mobile worker**: mines, hauls, assembles small modules and **repairs buildings/other units** when equipped and supplied | Independent courier/extractor; in **NETWORK construction mode**, **holds a visible blue beam** to eligible nearest large node until its construction job resolves (not a Protoss-style energy orb followed by immediate departure) |
| **MID** | Larger/slower harvester with multiple slots; can mine, transport and — when equipped — **bud L2 buildings** along living vessel | Ground tracked **relay/conveyor** with length 3 or 5 tiles in operating mode; reversible **one-person bunker/sentry** variant; sentry mode flips outward into a blocking wall and gives up conveyor throughput | **Pylon**: finite cargo storage / stationary relay **OR turret mode** after time-costing meditation; cargo remains in compartments and gates stop during meditation/turret. MID is **not** the formerly proposed traveling Relay Conductor |
| **MAX** | Huge flying mother with many cargo/passenger compartments; on connected permitted placement sites, equipped specialist **buds L3 buildings**; transports on routes; early single-port and exclusive modes | Large, very slow, **ground-only** modular store/transport; **warehouse OR multi-soldier bunker**, retractable/redeployable if the equipped template permits; resource packets must be physically unloaded before bunker conversion | **Nexus-class core node immediately**, not merely a bigger pylon: larger cargo/knowledge/construct support network with core-base capabilities; remains distinct from stationary MID turret. Large nodes may be relocatable by costly **meditation then levitation** only when the specific model supports this |
| Principal upgrade tradeoff | Mass/storage up, personal mining and movement speed down; route bandwidth tech-gated | Repair/modularity and quick reconfiguration versus module/cargo/transport costs | More reachable nodes/available construction knowledge versus meditation downtime and beam exposure |
| Essential counterplay | Kill/redirect mother, attack exposed roots, starve distant branch | Disconnect segmented conveyor, harass unsupported modules, force bunker conversions | Force MID pylon into turret, spot/interrupt blue beam, cut network route / Nexus information access |

**Scope discipline:** MIN/MID/MAX are platform *scales*, not a mandatory generic ability for every combat unit. A builder can create a building of an eligible level if its template has a matching **construction capability**; this does **not** mean an ordinary unit can transform *itself* into an arbitrary building. Dedicated morphing units still require an explicit `deployable` flag (DEC-002).

## 3. ORG — physical vessels, anchored colonies, nourishment

### 3.1 Design intent and Zerg comparison

**Owner canon:** do **not** adopt an identical Zerg-like area carpet as the primary building placement rule. Instead, imagine **narrow, branching, physical vascular/mycelial structures** that visibly grow from the living **Nexus/root** across the map. The colony is effectively the **least mobile base** even though its workers and mother ships are mobile.

- All ORG buildings must attach to a **connected living vessel branch** that physically reaches their placement site. The branch is a real, attackable object, not abstract global influence or map-wide purple/green terrain.
- A new building **buds only after a vessel/tendril grows to the location**. MIN/MID/MAX with authorized living-construction organs bud L1/L2/L3 structures respectively.
- Vessels are **support conduits**: they transmit local structural sustenance/viability and establish the attached building's ongoing tie to the originating Nexus. They do **not** automatically replace transport units or inject free Matter/Volatiles/Energy into inventories.
- If an enemy severs the only live connection to the home Nexus, distal vessels and attached buildings become **disconnected and begin withering**. They do not instantly vanish. Grace duration, progressive shutdown, regeneration, regrowth, reconnection and destruction timings are **to be balanced**.
- **Independent disconnected organisms remain individual units** and can still move/fight/extract where physically possible. Network-connected **buildings**, not all life in the faction, require a functioning root. This preserves the anti-hivemind individuality canon.
- Additional redundant vessel branches can protect a critical expansion against a single cut but cost growth, map space and defensive commitments.

### 3.2 Remote expansion must keep "pinging home"

**Owner canon:** an ORG remote expansion cannot be economically self-contained even if it mines locally. It requires **repeated real nourishment shipments from the mother base**. In practice:
1. A living vessel connection first reaches the expansion site. The authorized organism buds the new buildings along the branch.
2. The expansion may harvest local Matter/Volatiles/Energy and create local unit stocks, but periodically requires a finite **nourishment delivery** from the main Nexus/Hive (cargo consumed as upkeep or a timed feeding order; exact recipe/rhythm TBD).
3. MIN/MID carriers or MAX flying mother loops travel between home and the expansion. **A root by itself does not silently satisfy the recurring physical delivery requirement.**
4. Missing nourishment causes declining vitality/production before eventual withering, so the opponent can **starve** an expansion by raiding carriers even without cutting the root.
5. Cutting the vessel causes an independently observable **disconnect -> wither** transition regardless of still-active local mining. Reconnection and feed deliveries can reverse decline if made before final decay, subject to cost.

The exact relationship between flow through vessel and delivered food cargo is a pending tuning choice, but **both constraints must matter mechanically**: physical connection for viable rooted buildings, periodic returns/deliveries to home for remote-colony sustainability. Avoid no-win abrupt death: grant finite stores and warning time.

### 3.3 MID and MAX logistics strategies

| Strategy | MID role | MAX role | Strategic strength | Cost/risk |
|---|---|---|---|---|
| **Direct circuit** | MIN/MID collect, travel Nexus ↔ deposit/expansion, stop and unload | Flying mother uses ordered source ↔ home **stop-and-load/stop-and-unload loop** initially | Keeps the economic fantasy mobile and readable; good for widely spaced deposits and nourishment runs | Return-trip overhead, exposure to interception, transfer queueing |
| **Researched moving handoffs** | MID consolidates and meets mother where legal; still finite worker transfer rate | Mid-game research allows **moving + receive OR moving + dispatch**, initially one handoff port; late-game additional costly ports | Less idle hover time, better distant throughput | Technology cost, limited bandwidth and rendezvous risk |
| **Temporary stationary pool** | MID waits near vein or branch tip as local collector | Mother hovers as depot/staging, then later departs | Useful during first colony growth, concentration, siege staging or short-term congestion | Sacrifices route throughput and concentrates cargo; **not default best strategy** |
| **Continuous expansion feeding** | MID runs supply shuttles and collects local goods | MAX periodically visits expansions, carries finite home-origin nourishment, returns harvested stock | Keeps branch settlement alive; dramatic visible logistics timelapse | Raids on mothership/starvation, no independent mature ORG colony |

**Design recommendation:** **routes and loops are the primary ORG transport mechanic**, not permanently anchored carriers imitating MAN depots or ETH pylons. Early mother loops **stop** to load/unload. After research the same routes permit **in-motion** handoffs, and some mother ships may still hold position tactically. MID can also perform short loops or wait briefly at a pickup. Never allow a new early infinite bandwidth exploit.

### 3.4 Timelapse

ORG appears as a **single rooted organism**, a progressively branching tree of visible vessels stretching from an anchored Nexus. Buildings **bud** only where living branches have reached. Outlying expansions beat/pulse while courier organisms and flying mother ships visibly shuttle nutrition back and forth to the original core. A cut branch discolors and withers progressively rather than vanishing instantly.

## 4. MAN — modular organism made of machines, radial/mobile bases

**Owner canon:** a MAN "Nexus" is **not necessarily one fixed building**. It is a composable system of mobile facilities, factories, storage, conveyor modules, specialists and possible building foundations. MAN modules can **crawl/reposition** across the map, so time-lapse may show a base **expanding radially and vertically** and gradually **migrating**. Few MAN buildings are required to use permanently immovable foundations (specific immovable structures TBD).

### 4.1 Unit roles and multiple modes

| Unit | Logistics role | Alternate/defense role | Build/maintenance role | Constraint |
|---|---|---|---|---|
| **MIN** | SCV-like independent miner/hauler; feeds storage and belts | Limited equipment-based field defense | Light prefab assembly, **repair another MIN, MID, MAX or structures** with modules/material/time | Cannot instantly repair for free; repairs must have real material cost and service range |
| **MID** | **Tracked movable relay / conveyor, operational length 3 or 5 tiles**, finite packet buffers | **One-person bunker** and/or **Sentry Wall**: belt folds/flips to outward-facing barrier, giving up delivery throughput | Mobile repair/connection point if equipped; modular construction service | No simultaneous full belt throughput and wall/bunker throughput; a one-person bunker has exactly one garrison slot |
| **MAX** | Very slow, ground-only large mobile warehouse and redistribution center | Heavy bunker with **multiple soldier slots** after physically unloading cargo | Heavy prefab staging/field workshop; assists large builds and repairs | A packed/moving MAX ceases its fixed depot interfaces; specialist `deployable` capability required for morph |

The MID **one-person bunker** is a newly approved specialization and may coexist with sentry-wall configuration as **explicit mutually exclusive modes**. Don't grant both independently active in the same vehicle tick without research. A wall uses facing to define safe resource-package ejection; packets must land in legal world positions or a compatible reachable depot, not spontaneously credit global stockpiles. A MAX bunker similarly must empty its resource compartments before its soldier garrison becomes usable. MAN modularity is **reversible with nonzero time/cost/space**, not instantaneous magic.

### 4.2 Construction and moving bases

- Workers/modules physically deliver material, assemble/repair and connect prefab modules. A dedicated construction function is required but **no generic unit automatically morphs into a random building**.
- A crawler module can fold, relocate, reopen its logistics interfaces and reconnect if geometry and stored cargo allow.
- **Independent expansion is the easiest of the three factions:** local extraction, supply, construction, technology available by owned equipment/blueprint, defense and production may run without **any recurring contact or signal to the home base**.
- Multiple MAN settlements can remain independent or optionally connect conveyors/vehicles/data links according to economic benefit.
- **Hidden expansions:** MAN does **not** expose any obligatory long biological vessel or blue build beam leading back to the main base. An opponent sees the settlement only by actual scouting, detection and normal fog-of-war rules; this is an advantage of *reduced mandatory linkage*, **not an invisibility or permanent stealth buff**.
- A crawling base cannot keep operating disassembled modules at full output. Changing position requires costs, movement time, collision/pathing and temporary production interruptions. Vertical growth consumes structure footprint/support and must not make unreachable towers or impossible pathfinding.

### 4.3 Timelapse

MAN is visually an **urban/industrial moving ecosystem**: small units form workshops, warehouses and conveyor corridors, then rearrange and push outward, with modules **climbing/stacking upward** where support systems permit. Some sub-bases start independently, perhaps not even connected to the home complex, and later link up only if convenient. It looks **radial and architectural**, rather than one fixed creep/root tree.

## 5. ETH — construction beams, MID pylons and Nexus-class MAX

**Owner canon revises the older draft:** **ETH MID is a stationary pylon** with explicit **Storage/Relay** versus **Turret** modes. **ETH MAX is already a Nexus-class hub**, not just a larger warehouse pylon. The former "mobile Relay Conductor" MID and old "MAX storage pylon converting to turret" descriptions are **superseded for the economic unit lineup**. No generic forced physical ring to home once a colony has been seeded and holds needed knowledge.

### 5.1 ETH economic roster and alternative forms

| Tier | Function | Construction/transport behavior | Defense and mode tradeoff |
|---|---|---|---|
| **MIN** | Independent extractor and courier, finite cargo; can start normal direct-to-base supply | Builder enters **NETWORK mode**: stays at build site, sends **visible blue energy beam to nearest eligible large node** and maintains it while building, with actual Energy drawn from accounted inventory/node and other construction inputs physically available | Worker committed to beam, **cannot harvest/transport simultaneously**; exposed construction signature is strategically important |
| **MID** | **Pylon** that acts as local cargo storage **and relay node**; receives/releases finite packets in network | Routes locally, collects couriers, buffers flows, and may facilitate building only within explicitly researched capabilities | **MEDIDATE → TURRET** is a time-costing transformation; retains goods **without unloading**, but gates shut while meditating and while defending (current strict baseline); reverse transition also costs time |
| **MAX** | **Nexus-class node immediately**: major local storage, network/knowledge authority, construction support and local expansion center | Can receive construction beams, provision known plans, authorize new ETH colony initialization and hold local blueprint cache; **a new expansion can become self-operating once initialized** | Not automatically a free superturret, giant mobile hauler or always-mobile structure; optional levitating relocation requires specifically supported structure + meditation |

**Network-mode construction is *not* a Protoss probe placing an energy orb and immediately leaving.** MIN **stays engaged**, with a visible continuous blue beam linking builder to the **nearest eligible large node** for construction Energy and knowledge. The beam terminates/cancels if the worker stops, node is lost, funding is exhausted, or the legal link becomes impossible. It consumes a finite build-time opportunity and potentially exposes the site to enemies.

- **Visibility is strategic owner intent**, but whether opponents can see a beam beyond ordinary field of view, how stealth/disruption affects beams, and what sensors detect them are **future balance decisions**. Do not silently grant map-wide enemy information or guaranteed permanent concealment.
- The beam is a **costed Energy transfer/authorization channel**, **not** free teleportation of Matter and Volatiles or an inexhaustible generator. Finite stocks and building recipes remain authoritative.

### 5.2 ETH expansions "ping home" only conditionally

A new ETH expansion **contacts home during initial creation/initialization**. Afterwards it can run locally using its MAX Nexus-class node, local MID pylons, stored materials and **cached known building blueprints**. It contacts home again **only when it requests a building/technology blueprint it does not already know locally** (or another explicitly modeled new dependency). There is **no permanent home tether, recurring home-food requirement, or invisible compulsory global Energy grid**.

If a live path to home disappears:
- An **already initialized and provisioned** ETH expansion continues operating, builds **known** structures, mines and uses existing local resources.
- An expansion requiring a **new, uncached blueprint** must reestablish a permitted communications/supply connection or otherwise legitimately acquire that knowledge.
- Home communication uses explicit range/topology/delay/possible disruption, not infinite free global data transfer. Exact mechanics remain TBD; blueprint **information is not an extra consumable resource**.
- Local MID pylon vs MAX Nexus identity is meaningful: losing the MAX can disrupt knowledge/authorization, but it must not cause unfair instant destruction of every locally viable unit (recovery path TBD).

### 5.3 Levitating repositionable buildings

Certain ETH buildings may **meditate to enter LEVITATE/RELOCATION mode**, slowly move, then **meditate again to reconnect** at a new legal site. This is a movement mechanism for *eligible structures only*, not a license for all buildings or a permanent free-flying base. During transitions they suspend incompatible transfer/construction/defense operations, use finite Energy, expose themselves and are vulnerable. A MID pylon can be stationary in productive/defensive modes even if a specific later upgrade permits relocation.

### 5.4 Timelapse

ETH economy is a **graph**: stationary pylons appear first, then larger Nexus-class expansion nodes. When construction starts, each committed worker emits an identifiable **blue beam** to its nearest valid larger node, making active build sites visible when observable. The base grows by **new nodes and paths**, with occasional slow levitation/meditation relocations. Unlike ORG it need not maintain one unbroken living root back to the mother colony, and unlike MAN its growth exposes characteristic temporary energy-beam signals.

## 6. Expansion autonomy and counterplay — canonical comparison

| Decision/rule | ORG | MAN | ETH |
|---|---|---|---|
| Home is a compulsory reference | **Always for rooted buildings** | **No** | **At initialization; later for unknown plans** |
| Needs a continuous home connection | **Yes, a real living vessel** | **No** | **No persistent physical/data tether after local initialization** |
| Needs recurring supplies from home | **Yes, real delivered nourishment** | **No, if locally equipped** | **No, if locally supplied and holding needed knowledge** |
| Can build while totally isolated | Cannot create a **viable new rooted building** without a living vessel; independent workers survive | Yes, with local resources, kit and labor | Yes, for known plans with local valid Nexus-class support and Energy |
| Weakest point | Root cut + carrier starvation | Isolated modules can be raided; belts cut | Pylon/Nexus outage, beam interruption, unknown-plan communications |
| Least observable expansion | Root exposes approach; carriers expose home dependency | Can create independent outpost without any obligatory back-link | Blue construction beam can reveal active work when visible; no always-on mandatory home strand |
| Recovery | Regrow/rejoin vessel, refeed branch before wither timeout | Repair/reassemble modules and optional reconnect | Reestablish valid local relay/Nexus, restore beam or request missing plan |
| Visual shape | Branching rooted tree | Crawling radial/vertical modular city | Interconnected resonant constellation |

## 7. Balance: preserve asymmetry, not guaranteed victory

**Warning — asymmetric dependency can be a mathematical trap:** ORG is substantially more tied to home than MAN and ETH. This must be compensated through carefully playtested lower-cost/redundant living vessel growth, mobile worker/transport utility, defensive biology, explicit *withering grace periods*, locally stored nutrients and possible rescue/reconnection. Do not give ORG permanent catastrophic failure from any single cheap scout attack on a one-tile vessel.

- ORG roots **must cost something**, expose routes and wither when cut, but create meaningful shortcuts/capacity and can branch. The **nourishment requirement is separate** from vessel connectivity. Avoid double-counting it into an unbeatable maintenance tax.
- MAN independently seeded outposts should require real deployable module investment, local workers/resources and opportunity cost; independence does not imply free outpost construction or stealth in normal vision.
- ETH starts with **one local Nexus-class MAX role**; this is a role/capability, not an automatic free capital advantage. Its time, cost, storage, build aura, mobility and protections require budget equivalence. MID turret has an explicit logistics downtime, and visible blue construction beams offer opponents counterplay.
- On early direct extraction, all factions must have a credible MIN-only recovery loop. Later infrastructure should win in different map/threat/spacing conditions.
- Measure effective cost of delivering 1,000 units of each canonical resource, first-delivery latency, cost/time to independent expansion, number of viable expansions after a home cut, time-to-starvation/withering, visibility leakage, repair/redeployment and economic damage induced by combat.

## 8. Acceptance tests

| ID | Scenario | Expected |
|---|---|---|
| ECO-01 | ORG MIN buds L1 away from any connected vessel | Rejected until the physical live vessel tip reaches the placement |
| ECO-02 | ORG MID/MAX construction equipped with L2/L3 bud organs | Only correct level is permitted at a live connected site; separate specialist capability required |
| ECO-03 | Cut the only root connecting remote ORG expansion | Remote rooted buildings enter deterministic withering sequence with visible grace, not instantaneous deletion |
| ECO-04 | ORG root intact but scheduled nourishment convoys stop | Expansion vitality declines after local reserves run down; local mining cannot satisfy compulsory home shipment by fiat |
| ECO-05 | ORG MAX executes basic source/home freight loop | Move, stop receive one item/worker at a time, move, stop dispatch; only researched mother can transfer while flying |
| ECO-06 | MAN isolated expansion has valid local kit and supplies | Operates and constructs without an obligatory home connection or location reveal |
| ECO-07 | MAN MID deployed as one-person bunker | Exactly one compatible garrison unit; conveyor unavailable while in bunker/wall |
| ECO-08 | MAN MAX unloads resource crates and becomes bunker | Actual packets placed legally and multi-soldier garrison only after costed transition |
| ECO-09 | MAN module relocates | Movement interrupts original physical links and reestablishes new ones only after valid placement |
| ECO-10 | ETH MID pylon meditates into turret while storing cargo | Stored quantities persist; cargo intake/outflow is blocked during meditation and active turret |
| ECO-11 | ETH MAX placed as local core | Immediately functions as **Nexus-class node**, subject to normal local inventory/tech/cost validation |
| ECO-12 | ETH MIN starts construction | MIN remains in NETWORK mode; blue beam connects to nearest valid large node; build is canceled/paused when link fails |
| ECO-13 | ETH initialized outpost loses home communications | Keeps operating with known cached plans; requests unknown plan only via eligible restored connection |
| ECO-14 | ETH capable building levitates to new site | Requires meditation before/after, real movement time and outage, not instantaneous invisible relocation |
| ECO-15 | Any faction loses its primary logistics edge | Cargo conservation, deterministic effects, clear warning, and some faction-legal recovery path |

## 9. Open questions (not approved as implementation numbers)

1. ORG vessel per-tile cost, traversable mediums (mainland, islands, asteroids), vessel thickness, decay duration, redundant vessel flow capacity, regeneration and starvation recipe.
2. ORG expansion nourishment must originate from home, but exact stored resource recipe and shipping cadence are TBD; avoid creating a new fourth resource.
3. ORG mother route dwell time versus research unlock, in-motion transfer geometry and loading port upgrades remain as DEC-011.
4. MAN MID bunker mode physically shares the 3/5-tile conveyor chassis; detailed folding footprint and soldier port/weapon permissions are TBD.
5. MAN movement and vertical construction require collision, support/load, foundation exceptions, unloading/ejection and no-overlap checks.
6. ETH can a regular MID pylon levitate with research, or only other eligible structures? Eligibility is still per-template and must not erase pylon signature roles.
7. ETH construction beam range, duration, delay, enemy line-of-sight/fog handling, anti-detection, disruption/cancellation and exact eligible nearest large-node definition.
8. ETH message/blueprint channel, local knowledge caching, unknown-plan acquisition and offline queues need explicit deterministic rules and UI.
9. What exact structure/level combinations MIN/MID/MAX may build for MAN/ETH? Unlike ORG's direct L1/L2/L3 size mapping, these remain role/equipment dependent, not automatically tier-gated.
10. Benchmark faction matchup win rates *after* extensive equal-skill matches; these are proposed mechanics, not proven balance.

## 10. Decision precedence and design migration

**This document supersedes earlier proposals** where:
- ORG disconnected rooted outposts continue to operate normally without a live Nexus stem — they now **wither** after severance or home nourishment interruption (not instant deletion).
- ORG builds on unbounded biomass terrain / Zerg creep carpet — now requires **physical branching vessel to placement**.
- MAN Nexus is treated as necessarily one stationary command building — now a **composite, repositionable base system** with truly independent expansions.
- MAN MID is only a conveyor or sentry wall — its explicitly declared additional **one-soldier bunker mode** is now canon.
- ETH MID is a **mobile Relay Conductor** — now **stationary pylon storage/relay/turret**, with only explicitly researched relocation/levitation exceptions.
- ETH MAX is a **warehouse-only turret-switching pylon** — now **Nexus-class large node**, while the pylon-to-turret behavior moves to MID.
- ETH construction is Protoss-style place-and-leave orb — now the MIN is **occupied in NETWORK construction mode with a visible blue beam to the nearest large valid node**.
- ETH expansions need to be continuously connected to home — they only initialize from home and ask again for unknown blueprints; established known local functions persist while disconnected.

**Preserved earlier canon:** unit individuality (no mandated hive mind), 3 stored resources, real finite transport, typed constructor/deployable permissions, player command authority, medium labor automation, ORG early single-port exclusive mother modes and researched rolling/multiport transfer, MAN reversible modularity, ETH expensive meditation/reconfiguration, and 3 distinct faction economic paradigms.

The specific exact race names remain **Organs / Organites**, **Manus / Manusians**, **Eters / Etherans** with machine IDs `org`, `man`, `eth`. All new documentation is in English under DEC-006.
