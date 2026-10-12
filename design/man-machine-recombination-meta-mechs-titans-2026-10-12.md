# Scalfagus — MAN Mechanical Recombination: Transformers, Combiners, Colossi and Titans

**Date:** 2026-10-12  
**Decision:** DEC-046  
**Owner-set direction:** MAN has a technology fantasy of physical, visible, mechanically credible (within sci-fi) transformation, **multiple machines combining into one meta-machine**, and late-game **gigantic Titan-class walking combat machines**. Inspirations explicitly named by owner: General Daimos, Transformers and Warhammer 40,000 mega-mechs. Create **original Scalfagus designs**; do not copy protected character likenesses, faction emblems, names or signature silhouettes.  
**Implementation status:** specification/proposal; no Godot game features implemented or runtime tests executed.  
**Machine contract:** [man-machine-recombination-meta-mechs-titans.yaml](man-machine-recombination-meta-mechs-titans.yaml).

## Raw user intent

> Chcę aby było coś jak generał fajnie i transformers i możliwości łączenia się maszyn w meta maszyny i takie mega mechy jak w wh40k

> Chcę aby było coś jak generał dajmos i transformers i możliwości łączenia się maszyn w meta maszyny i takie mega mechy jak w wh40k kumasz klimat? To dopięcie modularności i tech fabstyzmu manusian

"generał dajmos" = General Daimos (the transforming classic super-robot; called Tōshō Daimos), "transformers" = transformations and combined machines, "WH40K" = evocative massive Titan/engine-of-war scale. The desired aesthetic is **MAN technofantasy/technological excess grounded in industrial engineering**. Owner has not yet approved connector geometry, recipe counts, numeric sizes, pilot rules or the exact parts composition of any individual meta-unit.

## The faction fantasy, as one principle

**MAN's infrastructure is made from reconfigurable physical actors rather than fixed immovable buildings:** \`machines → modular assemblies → combat meta-machines / mobile buildings → Titan-class moving industrial fortress\`.

ORG grows a living collective; ETH arranges a levitated Ether network. **MAN composes its existing technological inventory into new larger physical mechanical organisms**. This is technologically extravagant and visually dramatic, without granting free resources or infinite transformers.

## Hierarchy: do not proliferate core chassis IDs

| Technology scale | Constituent actors | Actual operation | What the player sees | Approval |
| --- | --- | --- | --- | --- |
| **TRANSFORM** | One owned chassis | The one actor switches a legal posture; same HP, components and cargo | UMU belts fold below cage as tracks, extend as 3/5 conveyor, become SENTRY WALL, etc. | Already owner-approved for UMU in DEC-040/041 |
| **COMBINE / Meta-machine** | Multiple distinct real compatible ground machines | Realtime physical docking/latching into one subordinate assembly with one active control coordinator | A bolide becomes sensor head, a mech becomes leg/arm, a tank contributes armor/weapon, an UMU contributes a chassis/battery if fitted | Combining is owner-approved direction, exact recipes and role assignments are candidates |
| **COLOSSUS / Heavy combined unit** | Several heavy compatible machines plus genuine structural connector frame | Heavy modular walker/mobile fortress with integrated movement and fire-control | Industrial-scale articulated construction, moving cranes, heavy joints, exposed power cabling | A proposed middle rung for clarity; no fixed owner counts |
| **TITAN / Mega-mech** | Many compatible real industrial machines and costed manufactured structural components | Extremely large walking war platform that can be piloted or AI-directed and that carries powerful installed weapons | Building-scale engine of war with heavy machinery, reactor pack, cranes, artillery, modular limb assemblies | Mega-mech aspiration owner-approved; count, stats and catalog TBD |

**Counts:** do not freeze arbitrary number of machines per combiner or Titan. For prototyping, propose small 2–4-machine combiners, 4–8-machine colossi and 8-plus special industrial Titan installations **only as research/balance candidates**; actual recipes and footprint depend on physically possible connector geometry. The existing **4 / 6 / 8 distinct UMU required to move small / medium / large buildings (DEC-041) are OWNER-APPROVED and are a DIFFERENT operation** from a robot-combination recipe. Never misread those as approved mech-part counts.

**The nine MAN machine families (DEC-045)** remain the intended *base chassis variety*. Combining is a composite **product state**, not automatically a tenth family or nine brand-new hero chassis. The exact base 9 roster still awaits owner selection.

## Proposed distinctive silhouettes / fantasy roles, NOT final roster

- **MANTIS** — quick bipedal or quadrupedal combined recon striker: bolide sensor/navigation + light mech lower assembly + weapon component; fast and fragile. Name placeholder.
- **GOLIAT** — medium combined humanoid assault machine: mech mobility frame + tank armor/gun + dedicated core/cooling + optionally an UMU-supported physical battery or logistics port. Contrasts with ordinary non-combined mechs by being visibly assembled from distinct original machines.
- **BASTION** — industrial fortress: multiple physically attached UMUs in BUILDING_DRIVE carry a real building while relocating; when anchored the building may become a fortified node with separate legal defensive machines. This is **not** a loophole to drive, run full production, use all UMUs as independently active generators and fire all weapons concurrently.
- **ATLAS** — heavy Colossus: articulated cargo frames and armored industrial platform, siege guns, tremendous structural load and energy draw, vulnerable exposed joints. Name placeholder.
- **LEVIATAN / TITAN MAN** — enormous multi-component walker, assembled at a real heavy industrial yard, with dedicated walking chassis/legs, central combat/control spine, roof-sized reactor module, massive but countable weapons, maintenance gantries and visible mechanical couplers. Player can watch its upper factory-like superstructure unfold into an enormous war machine. Name placeholder.

**Original visual identity:** hard-edged exposed hydraulics, recognizable **conveyor segments**, cranes, folding wings, construction steel, telescoping trusses, rotating gearing and power cable couplings; lights and paint in Scalfagus-specific faction palette. The look must remain industrial rather than recolored copies of Daimos, Devastator or Imperial Titans.

## Core assembly contract — physical identity is never erased

1. **Inspect / plan:** authorize COMBINE, define an actual \`assembly_recipe_id\` and ordered part slots (core, locomotion, left-arm, right-arm, weapons, armor, cooling, sensor, power etc.). Existing individual machines keep own IDs and inventories. The assembly graph lists exact children and their assigned connector slots. No "sum arbitrary 30 cars = free robot" without legal compatible interfaces.
2. **Physical rendezvous:** actual surviving part machines move to a real legal industrial assembly footprint or eligible field dock. Validate each machine's ownership, module connector interface, footprint, mass/energy budget, health, permit and expected physical assembly alignment. Foreign ownership and space-void terrain are rejected absent separately costed capture mechanics.
3. **Quiesce and lock roles:** each part receives a temporary **ASSEMBLY_MEMBER / COMPONENT_LOCKED** exclusive mode (DEC-041 UMU one function). Its independent orders and services shut off: an UMU used as a Titan leg **cannot also run its own free solar generator, full warehouse, conveyor and sentry wall**.
4. **Actual transformation over positive ticks:** hinges unfold, arms rotate, hydraulic locks engage, bus couplings connect; real assembly hardware, Energy/material supplies and a positive build/transform duration. No particles that teleport an entire tank into a Titan torso instantly.
5. **Create one assembly *controller*, not replacement copies of the parts:** \`assembly_id\` is a coordinator aggregating references to existing \`machine_ids\`; source machines remain real subordinate world entities/custody holders, with visibility/colliders/nav modeled by assembly. Avoid double-counting selection/HP and victory tags. A single steering/weapon action authority directs this entity; subordinate AIs remain support modules (damage sensors, joint control, local diagnostics), not nine simultaneous conflicting tank drivers.
6. **Finite shared resources:** structural capacity, real fuel/Energy, motor torque, service/heat dissipation, weapon ammunition, coolant and cargo are all resource-constrained. Shared bus can transfer legal finite Energy/data among attached machines, but does **not** create unlimited Matter or instantly combine isolated inventories; local attached holds remain countable.
7. **Tactical motion and attacks:** uses real composite footprint, gravity and ground-contact support. Pathfinding navigates space-platform terrain ramps, corners and the hard void-facing map edge. Feet/legs and active combat modules each have explicit ranges/arc/LOS and damage. Massive walkers cannot pass through ordinary houses or teleport over gaps.
8. **Damage and severing:** damage can disable a real constituent motor/arm/core, cut Energy/control bus and alter assembly balance/stability. A destroyed tank component **does not respawn as a healthy tank when disassembling**. Broken arms can detach as physical wreckage; loss of required support can make the Titan kneel, topple or immobilize it according to future deterministic damage policy (no automatic elaborate realtime full ragdoll required in prototype).
9. **Disconnect / decompose:** if legal on a real nonoccupied site with stable support, unlink only surviving serviceable child machines, preserving their actor IDs, HP, cargo, ammo and installed modules. Destroyed constituents become real salvage once; no free full unit restoration, duplicating passengers or inventory refunds.
10. **Authority:** player RTS commands, manual possession, qualified human pilot and autonomous AI work through the existing DEC-045 control chain. A person cannot pilot the Titan from a nonexistent cockpit. One active *top-level* control coordinator; a planned multi-person bridge is a specialty requiring real operator/crew slots and command arbitration. Manual captain orders preempt all subordinate autonomous strategic decisions.

### Crew, passengers, pilots and AI

- **Human-piloted meta-machine:** requires an appropriately trained **Machine Operator** from DEC-044 and legal physical control station. Titanic naval-like operation may use qualified Navy or Aviation specialists only if its actual platform capabilities justify that, without inventing a tenth faculty.
- **Crewless AI:** the combination can form and operate with **zero humans inside** if actual competent control equipment is installed and owner policy authorizes it. Unit sub-AIs coordinate low-level articulation, one master finite controller owns strategy/steering.
- **Player direct takeover (future FPP/TPP):** possession switches camera/control authority to the same assembly; no fictitious human copy. Distinguish pilot avatar sitting in the physical head/cockpit from remote operator controlling a machine, if later supported.
- **Boarding:** actual 4 troop seats OR 27 mixed/45 mono cargo of each **free-standing UMU** (DEC-042) are not automatically additive Titan troop bays once arms/legs physically consume their cages. Assembly recipe explicitly declares preserved occupied bays and required unloading; no "8 UMU = 32 soldiers or 360 cargo plus full Titan armor" unless physically engineered and actually accounted for.

### Composite health, controls, performance, resources

**Recommended initial simulation model** (future; no approved numeric balance):
- \`assembly_component_graph\` of actual persistent part IDs and socket IDs; one \`meta_controller\` with a deterministic public ruleset and AI policy.
- Core hull HP and individual component HP remain separate. Assembly health display may aggregate or display a core vital indicator, but **never mint extra HP from the act of joining**.
- Motor capability is bounded by physical traction/legs and supported mass; a heavier combined mech moves more slowly across paths. Total damage is limited by surviving installed weapon supply, ammo, Energy, barrel arc and heat; adding tank gun with no actual supported mount cannot fire it.
- Heat/power/cooling matter; expensive Titan has high peak threat but sustained fights can exhaust fuel, overheat, get stalled by joint damage or require repair.
- Breakable attachments give tactical counterplay: target articulated joints, cooling spine, visible buses, fuel delivery lines, leg supports; enemy sees only what actual line of sight allows.
- **Human specialization** vs AI: humans may achieve learned operator perks at real qualification cost, while AI offers reaction/reliability under actual power/sensors. None gains magical target knowledge or hidden network omniscience.

## Assembly line of meta-machines and Titans — construction infrastructure

The following future buildings are **proposals**, not user-approved new playable templates:

| Building / facility | Capability |
| --- | --- |
| **Modular Service Dock** | Small machine coupling/uncoupling; actual real accessible floor |
| **Combiner Assembly Gantry** | Suspended crane jigs, physically locks medium mechs and tanks |
| **Heavy Forge** | Produces actual load-bearing joints, armor, hydraulic cylinders, motors, interface adapters |
| **Titan Foundry / Colossus Yard** | Large late-game physical assembly site with powered staging, fuel, construction scaffold and entire Titan footprint clearance |
| **Reactor and Cooling Works** | Real finite fuel conversion, coolant/heat service, power bus components |
| **Machine Hangar / Repair Depot** | Restores actual damaged chassis/modules at real material/time cost; no miraculous "decombine to heal" |

**No forced single immobile global headquarter:** MAN's mobile industry/ecology and ordinary depot independence remain, but assembly facilities have footprint/mass/clearance needs. Building relocation **4/6/8 real UMU** stays governed by DEC-041, not replaced by arbitrary Titan mobility.

## Campaign-ready transformation examples (narrative use cases, not executable recipes)

**Defense of a factory:** two UMUs carry four soldiers each? **No**: each UMU individually holds four, but once dedicated as a combiner joint the passenger cage must be physically cleared or approved as attached garrison module. A tank and mech physically dock around an industrial crane frame and form a new bipedal defender. Individual source units can no longer independently attack/move; their real guns now aim under the one Goliat fire-control system. A side-coupler breaks in combat: one gun falls offline, without phantom free replacement.

**Massed endgame assault:** MAN builds a major Titan at a special construction yard using a large industrial hull frame and several compatible specialist machines. Walking legs lift the superstructure; multiple real support vehicles have been absorbed into its loadout and cannot protect separate convoy lanes. A Titan's stride crosses legal squares but struggles with narrow corridors and especially the floating platform edge. It becomes a monumental tactical threat — and simultaneously a **single huge concentration of economic investment** that ORG can attack through biological mass/terrain pressure and ETH through networked artillery/shields (their exact counters are future game-balance work).

**Repositioning a factory:** eight UMU physically latch to a large building as DEC-041 BUILDING_DRIVE, acting as wheels/tracks. This is a **mobile building**, not a combat Titan. If designer later wants mobile fortress guns while driving, that requires a separately approved multi-function construct rule with paid specialist combat mounts, not silent overlap of UMU jobs.

## Strategy and game balance

- **Escalation path:** low-tier single machines are flexible; mid-tier special machines outperform them in narrow roles (DEC-042), and **meta-machines outperform normal machines at big combined problems** but require real multiple costly inputs. The Titan is spectacular, **not guaranteed invincible**.
- A combined unit loses the ability to distribute its component machines across the map. This is the key **opportunity cost**. An army of independent tanks can split, flank, escort and repair separately. The same tanks locked into a meta-machine become one large potentially slower and less flexible target.
- Breakdown/detachment costs time and may be unavailable under enemy pressure. Protect the exposed central spine or leg couplers.
- A unique swarm of cheap units, air forces, anti-armor, EMP/EW (only if future rules approve) or logistics denial may defeat an expensive Titan; do not give Titans infinite armor, unlimited ammo, free radar or free movement.
- Faction asymmetry: ORG's mega-entities grow/mutate irreversibly with nourishment risk; ETH's powerful manifestations leverage limited Energy/resonance links. **Only MAN** assembles/reassembles physically independent machines into other industrial/combat machines; don't copy a "five tanks combine" recipe as shared faction behavior.

## Future build order (not current Godot MVP)

1. Stable persistent \`person_id\` vs \`machine_id\`, and common manual/AI control API (DEC-045).
2. Physical mode transform / one active role and resource ledger for actual UMU (DEC-040/041/042).
3. Prototype **two-machine coupled assembly** with deterministic transform, collision, coordinated move, forced HOLD, zero duplication.
4. Three-part meta-machine with individually destructible components, crew + AI control modes and re-separation.
5. Small dedicated assembly building, production costs, nonzero power/heat and mechanically valid slot graph.
6. Experimental heavy Colossus; exercise full footprint nav, balanced specialist opportunity costs.
7. Titan cinematic assembly / gameplay as late-game content only on maps with sufficient legal terrain and spatial scale. Current 64×64 bounded platform MVP0 may be too small and **must not be expanded merely for this aspirational feature**.

## Acceptance tests for later (not executed)

- **COMB-01**: A machine keeps persistent unique original ID when added/removed to a combined unit; new assembly controller has unique group ID and does not double-add unit count.
- **COMB-02**: Illegal connector, blocked terrain, occupied alignment, insufficient required compatible component, or zero energy rejects COMBINE and does not destroy components.
- **COMB-03**: Physical part assembly takes positive ticks and consumes exactly real costs once.
- **COMB-04**: All part machines stop their formerly independent services when locked; an attached UMU is exactly one \`ASSEMBLY_MEMBER\` role and not generator/warehouse/transport at once.
- **COMB-05**: Surviving part guns can fire only as physically mounted, powered, supplied and issued one legal coordinator command; no cloned DPS from parallel free tank controllers.
- **COMB-06**: Crew board/exit with their genuine IDs and equipment and compatible certification; autonomous operation requires no ghost human.
- **COMB-07**: Human/manual possession overrides authorized AI and subordinate controllers deterministically without resetting machine/assembly state.
- **COMB-08**: Damage to a part persists before/after decombine; destroyed parts cannot reform fully healed.
- **COMB-09**: Attached UMU passenger seats/cargo profiles cannot secretly retain unsafe occupants if the cage becomes a leg or sealed joint.
- **COMB-10**: Loss of one load-bearing component immobilizes or degrades movement according to the legal recipe and real physics rules; no zero-HP ghost legs.
- **COMB-11**: In-flight cargo, buffered materials, Energy, ammo and shield/HP remain uniquely attributed through assemble/decompose/destroy.
- **COMB-12**: Composite collider/pathfinding correctly handles all parts and map-edge space void (never cross floating platform perimeter).
- **COMB-13**: A composed meta-machine is **not a tenth base MAN machine family** by default; DEC-045 count ambiguity stays open.
- **COMB-14**: DEC-041's 4/6/8 UMU building-drive operation is **distinct from** this unapproved numeric mech recipe and never grants driving UMU simultaneous jobs.
- **COMB-15**: Losing/building a victory-class structure while it is a component of a group preserves DEC-024 existing building-class victory checks; no win-condition laundering or duplicate group counts.
- **COMB-16**: A model can control one assembled machine without multiple contradictory autonomous drive owners; replay hashes remain stable under fixed seed.
- **COMB-17**: Tiny/medium/Titan-size compositions cannot occupy overlapping solid cells or spawn/detach through structures.
- **COMB-18**: No combine recipe, giant Titan, crewed mech or FPP/TPP is added to DEC-033 first MAN-vs-MAN four-template MVP0.

**Precedence:** this decision approves the presence of **physical combining and Titans as a future MAN technology direction**, but does not finalize a specific recipe, number of parts, mech/titan catalog, terrain/balance coefficients, cockpit count, build unlock, internal thermal simulation or exact engine code. Do not treat the examples above as immutable owner design constraints.
