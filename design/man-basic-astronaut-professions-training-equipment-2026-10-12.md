# Scalfagus — Manus Basic Astronauts, Professional Certifications and Equipment

**Date:** 2026-10-12  
**Decision:** DEC-043.  
**Status:** owner direction that the MAN base produces **Basic Manus astronauts rather than intrinsically specialized human castes**; each professional job requires both **personal training and physical role-appropriate equipment**, with soldiers trained at Barracks and scientists at Academy before legal lab work. **Eight proposed careers and up to three faculties per person are recommendations** because the owner asked whether this should be permitted and how many careers there should be.  
**Machine contract:** [man-basic-astronaut-professions-training-equipment.yaml](man-basic-astronaut-professions-training-equipment.yaml).  
**Release guard:** Post-MVP0 — DEC-033 still uses \`man_min\` and \`man_rifleman\` four-template MAN mirror and its simple Barracks → Rifleman production rule until a deliberate migration. **Do not rewrite, rename or accidentally disable the working first-release loop.**

## Owner prompt — original Polish

> Mamusi z bazy produkują Basic manus kosmonautów. Każdy musi pobrać sprzęt aby móc być robotnikiem strzelcem etc. Każdy też musi przejść szkolenie w barakach  aby być żołnierzem, na akademii aby móc być naukowcem etc pracować w labie . Czy jeden człowiek może mieć 3 fakultety? Ile roli będzie? Inżynier żołnierz etc

"Baraki" = Barracks. Manus is the canonical faction short name, Manusians its mid name. No biological soldier/worker caste: **the person has a stable individual identity and accumulates skill credentials**.

## Concept: person ≠ qualification ≠ equipment ≠ current job

One \`Basic Manus\` is **one biological person entity**, spawned/trained by an eligible Command Core/Base (finite production time and resource cost), wearing the minimum standardized survival/environmental astronaut suit; **not automatically a miner, shooter or scientist**.

A MAN actor's actual active capability is the intersection of:

1. **Individual identity**: unique actor ID, HP, biological type, owner, location, occupied passenger seat or current work position, individual history.
2. **Credentials**: permanent earned professional course certificates, source facility, training completion tick, optional later skill proficiency. Certificates are not inventory items and **cannot be transferred, dropped or stolen**.
3. **Current physical equipment/loadout**: legally produced unique real tool/weapon/medical kit/scientific kit/vehicle control interface allocated and physically received by the individual; the suit alone is not a free rifle or industrial drill.
4. **Current selected job**: **one active role**, which must match a credential and compatible installed kit; no simultaneous shooting/healing/building/mining.
5. **Legal work context**: real lab, qualified mining source, reachable construction site, medical target or operational machinery as necessary.

Training **does not automatically give equipment**. Equipment **does not automatically give training**. Either missing factor prohibits the role's actual productivity.

## Career design — recommend eight distinct qualification paths

| Career | Suggested certificate facility | Mandatory active kit | Real player-facing contribution |
| --- | --- | --- | --- |
| **Miner / extractor** | Base foundation school / Extraction Center | Compatible manual mining/capture tools | Gather finite Matter or compatible source forms; no unrestricted pumping without technology |
| **Engineer / builder** | Workshop / Engineering School; base foundation course for bootstrap | Construction and repair toolkit | Construct real structures, service mechanical damage, manage building frames |
| **Logistician / warehouse worker** | Logistics Center | Freight/handling/loadout | Load, unload, handle tagged inventories; advanced routing/depot duties |
| **Soldier** | **Barracks** | Actual legal rifle/armor or other weapon + ammunition/energy as required | Combat and weapon operations; specific gun type is equipment specialization, not an extra "faculty" |
| **Medic** | Medical Center / Training Clinic | Medical treatment kit | Restore green biological HP for allowed targets, not mechanical maintenance |
| **Scientist / researcher** | **Academy** | Science lab/research interface kit | May be assigned to compatible **Lab**, conduct timed authorized research when powered/supplied |
| **Power engineer / electrician** | Technical School / Power Facility | Electrical diagnostics/protection kit | Operate, diagnose and service Energy networks/plant; fuel recipes require real resources |
| **Heavy equipment operator / pilot** | Operator School / Garage | Physical compatible vehicle control/operation kit | Staff suitable heavy UMU/building-drive/industrial machinery if crew requirement exists; **exact crew-versus-AI-autopilot gate remains TBD** |

**Roster status:** Eight is an **assistant-recommended starting catalogue**, **not** a fixed owner-approved count. Specializations (sniper, heavy gunner, chemist, biologist, surgeon, aerospace pilot, mech engineer, etc.) should first be **equipment upgrades, role proficiency or research**, not eighteen entirely separate career tracks.

**Potential merge decisions to simplify first post-MVP:** (A) combine Miner+Logistician into \`Industrial Worker\` for early launch; (B) combine Power Engineer with Engineer until power grid exists; (C) Operator can be an *endorsement attached to Engineer/Logistician* rather than an independent faculty. The eight-path matrix is for long-term clarity and does **not** require all eight schools/assets immediately.

## Faculties per person: recommend max THREE, one active

**Recommendation:** \`max_distinct_certifications_per_actor = 3\`, with **one currently active role and one equipped functional loadout**. The owner asked "can one person have three faculties?" — it is an **open approval question** rather than a canon hard cap.

Example: actor M-017 has Engineer, Soldier and Medic certifications. In a Workshop/Armory/Medical Locker:
- Equips construction kit → active \`engineer\`; may build/repair but does not shoot or heal.
- Legally deposits construction tools, picks up rifle → active \`soldier\`; valid combat behavior, not medical assistance.
- Deposits rifle, draws treatment kit → active \`medic\`; can treat biological HP, cannot perform combat or mechanical repair.

Switching is **physical**, time-limited, facility/stock-dependent, and can fail if equipment is unavailable. A change can be fast in well-provisioned forward armories/lockers but **not** an arbitrary instantaneous field-menu click. Credentials stay with that same living person's ID throughout, unlike tools.

Three qualifications cannot create simultaneous buffs, triple passive production rates or a free magic all-in-one unit. Train each faculty in its **correct dedicated institution** with real queue time/cost; the third credential can take longer or require deeper investment as a **balance candidate**, not settled. Dedicated specialists and expert operators may have more proficiency in one discipline, while versatile Manus pays time for breadth. No automatic 3 faculty limit on training trees per faction; the limit applies per person if approved.

### Career progression candidates

- **Untrained Basic Manus:** can walk, occupy eligible seats, follow safety/evacuation commands, accept equipment only if permitted, and queue for courses. Cannot perform professional mining/building/combat/lab work merely because a tool appeared nearby.
- **Certified novice:** one completed faculty and a matching real kit.
- **Multi-faculty generalist:** 2–3 completed courses and compatible equipment switches; flexible but expensive training investment.
- **Deep specialist:** higher skill level/master certification in **one** profession if later approved, better at that task than broad generalists, consistent with DEC-042 principle for dedicated equipment without conflating separate specialist **machines** and human qualifications.

No faculty can be copied onto another person or transferred to a respawned recruit on death. If a soldier dies, their diploma dies with them; dropped or recovered kit remains a separate physical salvage/ownership issue.

## Training and equipment flow

\`Command Core → Basic Manus astronaut → training queue at correct live facility → certified person → physically takes a compatible kit from stock → one active job\`.

- **Barracks:** converts a Basic Manus with available course place into a **certified soldier** by real passage of course time; rifle is separately produced/stored/issued. No Barracks simply materializes a brand-new separate biological \`Rifleman\` from nothing in the post-MVP evolution. Different weapon variants are primarily loadout choices after basic soldier training.
- **Academy:** produces researcher certificate; **Lab** must validate scientist qualification, real science tools, supply/workstation capacity and research permissions. An untrained Basic Manus may enter for training but **cannot operate a Lab**.
- **Workshop/Engineering School:** certifies engineer; trained and equipped engineer constructs frames/repairs mechanisms.
- **Extraction school (possibly inside Command Core initially):** certifies basic gatherer for resource-source hand collection; specialty capture tools still needed for liquids/gases.
- **Medical/Logistics/Power/Operator schools:** later specialized facilities or co-located benches; recommend **training stations** as components of fewer buildings rather than eight separate mandatory structures. Equipment lockers can be modules in real warehouses or Barracks/Academy.
- **Training queues** consume actual facility slots and do not mutate the same actor from multiple concurrent queues. Reserve necessary costs and occupancy; actor must physically reach facility, stay/participate for applicable ticks, and exit from a legal point.

### Bootstrap and avoidance of a hard lock

**Critical design hole to prevent:** if nobody is born with engineering/mining skill, who builds the first Engineering School and mines the materials to train the first engineer?

Recommended **starter Command Core** provides a **small basic induction/training station and a finite starter tool locker** capable of certifying at least first basic Miner and Engineer using legal training queues, or a mission can grant **already-certified founder actors** without treating every later spawn as specialized. The owner has not yet chosen which starter bootstrap method. **Never implement both "all new persons require courses" and "training buildings must be built by people no one can train" with no legal start path.**

A dedicated Academy is still required for **scientist** certification; Barracks is required for **soldier** certification, as owner directed.

### Facility, capacity and combat interactions

- No conversion of trained combat soldiers into robots/equipment actors; humans stay human and may board DEC-042 **4-soldier UMU passenger cage** as distinct units keeping training records and carried equipment.
- Qualified Medic role heals biological MAN via finite authorized treatment (DEC-037); qualified Engineer mechanical service needs real repair tools, Matter/parts and time (DEC-037). **No universal passive human HP regeneration** merely because "soldier" is certified.
- Scientist does not automatically fight as Soldier unless separately certified and equipped; lab active employment is one selected job.
- Logistics automation can route issued equipment, but **MAN cannot mint kits for free**. Starter suits do not hide rifles, drills or lab instruments in a generic enum.
- Equipment swaps require role exclusivity; physical current item remains reserved/held by one actor/locker at once. Drop, recover, steal and combat durability may be separate later scenarios but conservation must hold.
- UMU is a **machine actor** (DEC-040/041/042), **not** a Basic Manus human. The human's active work role and an UMU's own single active job are two distinct role enums. Whether an UMU requires a certified driver/energy technician for full performance is a later autonomous-machinery vs crew policy, and should not silently invalidate existing automatable UMU decisions.

## First-release compatibility (DEC-033)

Current initial game roster is **man_command_core, man_min, man_barracks, man_rifleman**, with a very simple \`train_worker\` at Command Core and \`train_rifleman\` at Barracks. **Do not break these actions or claim the profession system is already running in Godot.**

For a later planned migration only:
- \`man_min\` physical actor becomes \`Basic Manus + Miner/Engineer course + fitted work tool\` under a chosen training profile. If worker/miner/engineer need separate certified skills, add explicit certification, not free bundled traits.
- \`man_rifleman\` becomes **one identical human actor** that underwent \`barracks_training\` and received a real rifle loadout. The original Barracks "produces Rifleman" button can become an ergonomic compound workflow *only if it legally consumes/recruits a Basic Manus plus kit stock and training capacity*, maintaining physical accounting.
- Keep same authoritative human entity while switching jobs. Do not kill/recreate an actor to change loadout, resetting HP/certifications. Retain host-authoritative LAN/Godot fixed ticks and physical inventories.
- The first functional post-MVP test should be **one Basic Manus → one basic training → equipment pickup → legal work**; build Academy/Lab after the core gating works.

## Suggested acceptance matrix (all future)

- **HUM-01:** Command Core produces Basic Manus astronaut with unique ID/HP/suit, **no free vocational certification or professional kit**.
- **HUM-02:** Basic Manus without Miner training and kit cannot perform professional extraction or unapproved profession work.
- **HUM-03:** Soldier eligible only after **completed Barracks training** plus actual issued compatible weapon; Barracks alone does not grant a physical gun.
- **HUM-04:** Scientist eligible for actual powered Lab research only after **Academy training + suitable real research kit**.
- **HUM-05:** Equipped untrained actor and trained unequipped actor both fail full professional job capability.
- **HUM-06:** Example triple-qualified Engineer/Soldier/Medic performs **one active job** at a time, keeping same actor ID and HP.
- **HUM-07:** Recommended 3-faculty cap, *if enabled*, prohibits fourth unique certificate but does not prohibit improving the existing qualifications.
- **HUM-08:** Any training consumes real queue occupancy/time/resources; impossible to train same person in three buildings simultaneously.
- **HUM-09:** Changing active loadout uses real equipment locker, actual travel/interaction and takes positive time; no kit cloning/refund.
- **HUM-10:** Death/destruction retains resource/kit accounting and cannot copy learned certificates onto a new recruit.
- **HUM-11:** Medic may heal living MAN green HP but cannot repair damaged mechanical UMU; Engineer with legal repair tools can service mechanical actor (DEC-037).
- **HUM-12:** Four trained soldiers can physically board a four-seat UMU; fifth cannot; cargo-exclusive capacity applies (DEC-042).
- **HUM-13:** Basic starter Command Core / prequalified founder policy avoids first-training bootstrap deadlock, without inventing unlimited free equipment.
- **HUM-14:** Different firearm kits for same certified Soldier change loadout, **not** the number of completed formal faculties.
- **HUM-15:** A lab researcher does not gain engineer build or soldier shooting just from being Academy certified.
- **HUM-16:** Faction MAN bot/agent, full/semi/manual control all use same qualification-and-equipment validators; no unrestricted developer cheat mode.
- **HUM-17:** Current MVP0 train_worker/train_rifleman remains callable and working under DEC-033 until a deliberate gated migration.
- **HUM-18:** Later qualifying flows pass deterministic GUI/headless/host-authoritative LAN replay tests with the same actor, kit, course and inventory ledgers.

**No executable functionality is claimed as implemented by this document.**
