# Scalfagus — MAN Machines: Human Pilots, Autonomous AI and Nine Candidate Chassis

**Date:** 2026-10-12  
**Decision:** DEC-045 — owner-approved **human-operable AND autonomously AI-operable machines** and desire for **nine distinct machine kinds**, including **mechs, tanks and fast bolides**. The exact nine-family catalogue below is a **proposed roster**, not a user-approved final list.  
**Machine contract:** [man-nine-machines-crews-and-autonomy.yaml](man-nine-machines-crews-and-autonomy.yaml).  
**Precedence:** DEC-033 first four-template MAN mirror MVP0 remains hard-scoped; DEC-040/041/042 UMU modes/capacity/specialist superiority; DEC-043 superseded by DEC-044 three academies / nine faculties / three human qualification slots; [command autonomy](command-autonomy-modes-2026-10-11.md).  
**No code implemented or tests passed as a result of this document.**

## Owner's new direction (Polish original)

> Ludzie mogą też sterować maszynami choć maszyny mogą też operować samodzielnie z ai. Chcę mieć mechy, czołgi, boilidy, etc. Z 9 różnych maszyn

"Boilidy" is read as **bolidy**: rapid purpose-built ground vehicles. The owner has **not** yet fixed the nine type names, performance parameters, exact vehicle count inclusive/exclusive of UMU, crew sizes or autonomy costs.

## Fundamental model: person, machine and control authority are different objects

- A **machine** is an owned physical entity with persistent \`machine_id\`, chassis/module inventory, HP, stored Energy, fuel/physical cargo, control computer, navigation and optional cockpit/crew stations.
- A **Basic Manus** is a distinct persistent living actor with actor ID, personal HP, three qualification slots, up to three trained faculties and physically issued equipment. The same human may physically **board a compatible machine** as operator; boarding does **not** clone either.
- **AI** is the machine's legal controller/decision system, **not an additional free invisible human occupant**, and it does not inherit human career certificates. Operational autonomy is permitted when the machine has appropriate controller hardware, Energy and a legal task/permission. A machine **can operate without any human on board**.
- **Direct player control** (future FPP/TPP / vehicle possession) is a third **authority path**, not a new chassis or an automatic living soldier. The owner has already requested entering units in the game. Taking direct control must leave same machine entity, HP and actual cargo/crew intact; it can be a direct command channel to an autonomous machine without spawning a human. Whether game FPP is camera-only remote teleoperation versus literal avatar boarding is an additional gameplay choice; do not conflate the two.
- Human operator's qualifications may improve vehicle handling, repair coordination or tactical operation **only through measurable earned capabilities**, not permanent free double DPS. Any AI strengths/weaknesses (fatigue resistance, skill, jamming, maintenance, hacking) are future costed balance mechanics; no arbitrary assertion that "AI is always worse" or "people always win".
- A damaged controller or crew injury should trigger a legal fallback/stop, not transform the machine into a completely new unit. A human operator can physically leave and take a different vehicle when conditions permit.

### Three modes of machine control (authority priority, NOT three separate types of machine)

| Effective controller | Physical pilot? | Source of commands | Persistent machine? |
| --- | --- | --- | --- |
| **Human-occupied / crewed** | **Yes**, qualified actor physically at licensed station | Operator's legal locally delegated actions and higher-priority player orders | Yes, same machine ID. Human remains separate actor ID |
| **Onboard AI autonomous** | **No required human** | Native deterministic local AI within permissions / group manager / owner control mode | Yes, same chassis/HP/cargo |
| **Direct player possession** | **Not inherently**: player may directly control legal vehicle, crew presence remains factual | Immediate manual input supersedes onboard AI and manager choices | Yes, same machine. Return control without respawn or duplicate |

### Authority rules

1. **Manual direct control > accepted explicit player order > currently authorized human-crewed machine control > delegated manager/autonomous AI initiative**; in case of conflict prefer explicit recent legal owner instructions and latch STOP/HOLD. Exact relative priority of human pilot initiative vs explicit remote RTS issued task needs explicit deterministic arbitration; do not introduce two simultaneous steering systems.
2. The player's **FULL MANUAL / SEMI-AUTO / FULL AUTO** global policy is orthogonal to **person or AI currently driving**. In FULL MANUAL even an autonomous capable machine must not initiate unauthorized strategic work; low-level legal pathfinding and ordered target engagement continue. In AUTO, bot can self-route and select only allowed tasks.
3. **Board** requires reachable physical cockpit, compatible trained faculty, vacant slot, real actor identity and finite time; AI control is suspended or relegated to safety/navigation **when human takes the vehicle helm**. A boarding infantry soldier without \`machine_operator\` training does not magically know how to drive a heavy mech or MBT.
4. **Disembark** requires legal landing/ground/nav positions; the person keeps its own HP/skills/items. If no legal disembark point exists, machine is occupied until it reaches one. No free teleport.
5. If human pilot exits, the machine may **hand control back to AI** if fitted and permitted. If AI is unavailable, it safely holds/stops or follows remaining legal low-level commands. Transfer takes an authoritative fixed-tick event with audit log.
6. Damage to hull vs pilot are two tracked states. An autonomous tank is not invulnerable to electronic/infrastructure disruption, nor does an alive human pilot eliminate the tank's physical fuel/Energy or repair requirements.
7. A machine's **specialized main job** remains exclusive with other jobs, like UMU's one-role rule. An MBT can have tracked locomotion and a gun as components of its **one combat role**; this is not a loophole granting a refinery/miner simultaneously.
8. Ownership and control cannot be acquired by arbitrarily hopping inside an enemy machine. Capture/hacking, abandoned enemy vehicles and surrendered pilots are **future explicitly costed mechanics**, not enabled by the mere presence of cockpits.

## Integration with MAN Academy (DEC-044), no tenth faculty

The user's already established **3 academies × 3 faculties** must be reused, not replaced by new vehicle-specific basic credentials.

- **Technical / Machine Operator** (\`machine_operator\`): ground tracked machines, mechs, bolides, APC, tanks, UMU and industrial machinery where the proper course and compatible tools/licence exist. Exact subtype endorsements (tank gunnery, mech servo handling, hazardous drill) may be **additional training within the same faculty**, not extra tenth, eleventh or twelfth university faculty.
- **Military / Infantry**: soldiers used as human combat troops. This does **not** itself grant the Machine Operator faculty; an infantry person may be a passenger but not the legal driver of a ground tank unless personally cross-trained.
- **Military / Aviation**: flying aircraft/VTOL if later added to chassis roster, not automatic from Machine Operator.
- **Military / Navy**: water/spacecraft and fleet operation according to final vehicle domain; do not pretend a tracked UMU is a ship.
- **Scientific / Cybernetics** (candidate faculty under DEC-044): AI systems and onboard diagnostics; engineers can maintain machines by correct certifications and tools. The owner has not finally named the third Scientific degree.
- **Three personal qualification slots** remain per person, **one active job**: sitting at tank driver's station doesn't simultaneously make that astronaut an active medic and builder. Training alone does not create a vehicle, weapon, ammunition, pilot suit or AI controller.

## Nine MAN machine kinds — candidate roster, not fixed owner selection

**Proposed counting choice:** Nine machine *families in total including UMU* to maintain a clear production roster; if the owner meant nine **specialists besides UMU**, change only the count/roster contract by a subsequent decision rather than secretly adding a tenth item.

| # | Candidate machine family | Physical profile | Main specialist job / output | Distinctive strength vs UMU |
| --- | --- | --- | --- | --- |
| 1 | **UMU — Universal Modular / Man Unit** | Open-cage trapezoid tracks, two transforming belt wings | Generalist MOVE/WAREHOUSE/CONVEYOR/GENERATOR/HARVEST/BUNKER/SENTRY/BUILDING_DRIVE, **one active function** | **Versatility**; 4 human seats or 27 mixed / 45 mono cargo. Not the specialist power benchmark |
| 2 | **BOLIDE / Strider** | Lightweight low-slung high-speed ground racer/recon car | Scouting, rapid messages, flank probing | **Faster** maneuver and light reconnaissance than UMU at comparable conditions; little armor/cargo |
| 3 | **APC / Carrier** | Dedicated armored troop transport | Deliver/protect a troop squad | Better protected troop transport and/or more troop places than open 4-seat UMU (exact seat count TBD) |
| 4 | **BATTLE TANK** | Heavy tracked armored fighting vehicle | Breakthrough, armor combat | Stronger dedicated front armor + gun than bunker-equipped generalist UMU |
| 5 | **COMBAT MECH / Walker** | Legged pilotable robotic armored frame | Vertical geometry / obstacles, medium-heavy combat, manipulators if fitted | Tactical obstacle handling and role-specific weapons; not an economy warehouse |
| 6 | **SELF-PROPELLED ARTILLERY** | Long chassis with stabilized indirect fire unit | Siege, artillery support at finite standoff range | Significantly longer ranged explosive/kinetic attack than default UMU weapons, limited close-in survivability |
| 7 | **MOBILE ANTI-AIR** | Sensor mast and anti-air launcher/gun on real wheeled/tracked chassis | Protect military/economic nodes from flying units | Superior legal detection and AA combat; weaker vs tanks/land artillery by role |
| 8 | **HEAVY DRILL / HARVESTER** | Specialized drill rig with actual deposit interface | High-volume eligible Matter extraction | Extraction efficiency/rate/deposit access materially better than UMU roof drill |
| 9 | **HEAVY HAULER / MULE** | Big multi-axle cargo carrier with physical containers | High-volume specialized freight | Actual material carrying capacity and freight throughput exceed UMU's **27 mixed / 45 mono** benchmark under comparable route; exact chassis capacity TBD |

**Why this mix:** infantry transport, scouting, armor, maneuvering mech, siege, AA, extraction and freight are all differentiated jobs. A roster with nine differently styled tanks would produce much less interesting economy/combined-arms choices. Each machine supports **AI autonomy** when equipped and **qualified human operation** where physically cockpit-capable.

**MVP / later aviation:** The nine above deliberately focus on **ground specializations** compatible with the floating platform map and Machine Operator Academy. **Aviation** and **Navy** already exist as qualifications; air/space/water craft are future candidate machine rosters or could replace one of the nine if the owner prefers. Do not turn a proposed ground-only shortlist into a permanent ban on flying MAN machines.

### No blanket "all machines have a free gun"

Each role has real model-specific equipment, Energy/fuel, ammo, weapon HP, accuracy, detection/LOS and legal task constraints. A self-propelled mining rig can be expensive and powerful at extracting Matter but is **not** automatically a high-DPS tank. A bolide can outrun most opponents on legal lanes but may be one-shot by heavy weapons. A human Machine Operator doesn't convert a fuel-less tank into a functioning turret.

## Core AI capability: useful but bounded and inspectable

**Suggested initial implementation:** deterministic FSM + utility scoring, same combat/navigation/extraction rules as player, no realtime LLM runtime dependency. Each machine template exposes \`role_capabilities\` and \`autonomy_supported\`; each actual instance has finite \`energy\`, \`damage\`, \`ammo\`, \`crew_station\`, \`machine_controller\`, \`policy\`, \`task_claim\` and \`manual_override\`.

- **Bolide:** recon patrol, return to safety on threat/high damage under approved recon policy.
- **APC:** collect/escort/deliver real named passengers, not teleported squad slots.
- **Tank:** guard/attack within permitted ROE, no targeting invisible enemy; only legal target classes.
- **Mech:** choose physically navigable reachable terrain/LOS/stance and pursue authorized engagements.
- **Artillery:** ranged attack only on known or legally spotted targets, avoid firing on friendly positions where friendly fire is modeled.
- **Anti-air:** detect/track valid air targets and obey target eligibility/visibility.
- **Drill:** extract eligible deposit only, finite resource depletion, deliver output to legal manifest.
- **Hauler:** complete actual bounded physical cargo transfers without ghosting through walls.
- **UMU:** pick among only the currently selected **single** legal active job; group managers may request a paid mode switch only with legal authority and confirmed physical cargo/people clearance.

**Autonomy permissions do not override doctrine and resource budgets.** Even full-auto AI cannot spawn vehicles, route through map voids, see hidden enemies, transfer a trained human's three certificates, operate an unpowered chassis or spend unbudgeted Matter. All agents interpret *one* world-state transition system.

## Distinguishing AI benefit from trained-human benefit

**Design candidates for balancing (NOT yet owner-approved):**

| Dimension | Trained human crew | Autonomous onboard AI |
| --- | --- | --- |
| Entry requirements | Real trained actor, available operator seat, issued equipment/endorsement | Actual built-in controller firmware/module and required Energy |
| Opportunity cost | Ties up a valuable human who has only 3 degrees and one active job | Frees human for other tasks, but controller itself costs resources/technology |
| Decision style | Player can delegate to human skill model or possess/command; high specialized learned proficiency if trained | Reliable scripted/replayable patrol and logistics; bounded permissions and machine's hardware/sensor envelope |
| Vulnerability | Crew HP / ejection/capture risk plus machine destruction | EMP/cyber disruption when later implemented, power/controller damage and behavior-policy failures |
| Performance | Operator experience can improve one metric in earned, bounded way | Repeatable low-fatigue precision/path execution, but no superhuman omniscience |
| Mode change | Crew can leave, climb into another machine with legal permits | AI can take over if lawful and serviceable without creating a duplicate operator |

A human operator does **not** need to be systematically stronger or weaker across all metrics; specialists should gain distinguishable advantages that justify training costs.

## Shared machine command model

Proposed commands: \`board_machine(person_id,machine_id,seat_id)\`, \`disembark_machine(person_id)\`, \`assign_machine_controller(machine_id,ai|crew|player)\`, \`issue_machine_order(machine_id,order)\`, \`possess_machine(machine_id)\`, \`release_machine(machine_id)\`. These are illustrative APIs, **not authorized runtime function names**.

- Only one **current active command authority** holds steering/action arbitration per machine, even when gunner and driver are multiple physical crew roles (multi-crew hierarchy requires a design).
- A human leaving a driven machine causes AI takeover **if allowed and available**, otherwise brakes/holds. The machine's selected \`operational_role\`, health, inventory, cooldowns and accepted orders persist.
- Physical boarding of one human into one machine must remove that actor from free-ground active nav occupancy but not delete or duplicate the person. Its occupied seat exists only once.
- Actor-to-machine passenger status differs from driver/operator status; troop APC passengers are not automatically qualified to drive it.
- Vehicle procurement, fuel, maintenance and training have actual resource costs and future equipment production queues.
- Individual machine AI obeys Full Manual / Semi Auto / Full Auto autonomy rules as owner has already set; robot-vs-pilot is not the global autonomy setting itself.

## Acceptance tests for later implementation (not passing tests)

- **MACHINE-01:** Ground Machine Operator with required certification and legal issued gear can physically board and drive supported UMU/mech/tank; unqualified infantry passenger cannot seize cockpit.
- **MACHINE-02:** Autonomy-capable uncrewed MAN tank/mech/bolide operates a permitted task without any human secretly being spawned.
- **MACHINE-03:** Changing crewed→AI or AI→crewed never duplicates/stomps vehicle HP, cargo, bullets, Energy or soldier actor.
- **MACHINE-04:** Player future direct machine possession overrides AI at next authoritative tick and release returns prior legal control state with same machine ID.
- **MACHINE-05:** FULL MANUAL idle autonomous vehicle does no unauthorized new strategic work; FULL AUTO policy can assign legal bounded work.
- **MACHINE-06:** Boarding/disembarking has legal location, finite ticks, seat reservation, collision and actual soldier ID persistence.
- **MACHINE-07:** Damaged/destroyed vehicle has deterministic, real pilot/passenger fate and no free resurrection or reissued equipment.
- **MACHINE-08:** Trained operator has three persistent qualification slots but only one active role while piloting; AI gets no human faculty credit.
- **MACHINE-09:** One vehicle at a time has one authoritative driving controller; conflicting commands resolve by explicit precedence/STOP.
- **MACHINE-10:** AI respects map void, navigation, LOS/fog, supply, Energy, ammunition, target permissions and operator-independent mechanics.
- **MACHINE-11:** Nine-roster candidate contains UMU exactly once and eight distinct specialist families until owner redefines what "nine" counts.
- **MACHINE-12:** Each specialist has testable primary-role performance advantage vs comparably costed UMU; literal comparative multipliers remain TBD.
- **MACHINE-13:** APC troop inventory never becomes free cargo and maintains separately manifest-controlled soldiers and driver.
- **MACHINE-14:** Dedicated heavy hauler can demonstrably exceed UMU benchmark 27 mixed / 45 mono cargo without unlimited carrying volume.
- **MACHINE-15:** Human piloting an AI-capable mining drill does not duplicate extracted real Matter, create free fuel or override finite source eligibility.
- **MACHINE-16:** Optional Aviation-qualified craft, if later introduced, require aviation credentials for human flight but still may operate uncrewed if enabled.
- **MACHINE-17:** Pilot leaving a vehicle passes steering to valid AI only when fitted and authorized, otherwise safe HOLD.
- **MACHINE-18:** No nine-machine catalogue, FPP/TPP possession, Academy population or autonomous fleet enters the DEC-033 first four-template MAN mirror build prematurely.

This file is a future design and agent planning contract, not a claim of implemented Godot support.
