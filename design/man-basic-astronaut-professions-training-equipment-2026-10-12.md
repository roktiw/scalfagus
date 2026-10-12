# Scalfagus — Manus Basic Astronauts, Professional Certifications and Equipment

**Date:** 2026-10-12  
**Decision:** DEC-043.  
**Status:** owner-approved Basic Manus astronaut production, **three permanent qualification slots per human** and one active trained + physically equipped profession. Owner requests **seven specialty choices**; the names/merges below are the **proposed seven-role catalogue**, with the slot count (3) and choice count (7) now fixed.  
**Machine contract:** [man-basic-astronaut-professions-training-equipment.yaml](man-basic-astronaut-professions-training-equipment.yaml).  
**Release guard:** Post-MVP0 — DEC-033 still uses \`man_min\` and \`man_rifleman\` four-template MAN mirror and its simple Barracks → Rifleman production rule until a deliberate migration. **Do not rewrite, rename or accidentally disable the working first-release loop.**

## Owner prompt — original Polish

> Mamusi z bazy produkują Basic manus kosmonautów. Każdy musi pobrać sprzęt aby móc być robotnikiem strzelcem etc. Każdy też musi przejść szkolenie w barakach  aby być żołnierzem, na akademii aby móc być naukowcem etc pracować w labie . Czy jeden człowiek może mieć 3 fakultety? Ile roli będzie? Inżynier żołnierz etc

> Każdy człowiek ma sloty na 3 specjalizacje: inżynier, żołnierz, naukowiec, specjał, operator maszyn jak lechy etc, medyk… po wymyślaj mi z 7 specjalizacji

The latter settles **THREE slots per person** and requests **a roster of SEVEN distinct selectable specialization families**. The seventh below is Industrial Technician, merging miner and logistics so the other six named roles remain visible. Equipment changes are not further certificates.

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

## Seven specialization choices — owner's requested structure, working roster

**Exact choice count = seven.** The owner explicitly listed Engineer, Soldier, Scientist, SpecOps, Machine Operator (including mechs) and Medic. The seventh proposed branch is **Industrial Technician**, combining the previous basic Miner + Logistician paths to preserve economic bootstrapping and avoid an unnecessary eighth diploma. "Power Engineer" is a later endorsement/proficiency of Engineer, not a separate eighth basic faculty.

| # | Faculty / ID | Training facility | Physically required functional kit | Permitted active role |
| --- | --- | --- | --- | --- |
| 1 | **Industrial Technician** (\`industrial\`) | Command Core induction / Industrial Training Bay | Miner drill, extraction kit, basic warehouse/hand-cargo tools | Mining eligible real sources, hauling, loading/unloading, physical warehouse logistics; sophisticated construction/repairs still need Engineer |
| 2 | **Engineer** (\`engineer\`) | Engineering Workshop / Engineering School | Construction, mechanical service or electrical tools | Builds real frames, repairs mechanical damage, services MAN generator/cables; electrical power engineering is an Engineer specialization |
| 3 | **Soldier** (\`soldier\`) | **Barracks** | Owned and actually carried rifle, armor, other permitted weapons | Fight, hold cover and operate weaponry; heavy rifle/sniper is a kit subtype not a new faculty |
| 4 | **Scientist** (\`scientist\`) | **Academy** | Research instruments or lab-control interface | Work in an eligible supplied/authorized **Lab**; choose later research branches rather than duplicate all faculties |
| 5 | **Medic** (\`medic\`) | Clinic / Medical Training Center | Real medkit, diagnostics or surgical tools | Treat living MAN biological HP (DEC-037); not repair UMU/mechs |
| 6 | **Machine Operator** (\`operator\`) | Machine Simulator / Hangar Training Center | Authorized operator/control interface | Operate piloted mechs, industrial exosuits, heavy machines, UMU where crew is required; **autonomous UMU existence must not be prohibited silently** |
| 7 | **SpecOps** (\`specops\`) | Advanced Barracks / SpecOps Training Center | Recon sensors, infiltration/EW/breach kit, specialized equipment | Recon, sabotage, tactical electronic intrusion, stealth/missions; using a military firearm still needs legal Soldier training, **unless** an explicit SpecOps weapons endorsement is later approved |

The seven-category framework is requested by the owner. The **Industrial Technician** label/merge and precise boundaries of SpecOps, crew authorization and school construction are **design recommendations** pending a final lore/UX naming choice; no separate extra "Scientist, Doctor, Miner, Logistician, Electrician, Mech Pilot" specializations may be silently added as eighth-plus basic faculty.

**Role vs equipment:** a certified Soldier may switch among legal rifleman/sniper/heavy-gunner weapon kits without spending two or three faculty slots. An Engineer may choose mechanical service or electrical diagnostics within the Engineer faculty. An Industrial Technician can perform distinct mining/transport tasks with the corresponding issued tool but still has only **one active job**. SpecOps may use infiltration equipment without Soldier cert, but ordinary firearms remain Soldier-gated unless explicitly authorized.

**Specialist dominance:** specialized veteran MAN personnel can progress in mastery within a faculty without spending another slot; physically purpose-built machines still outperform UMU at their dedicated jobs (DEC-042). A three-faculty generalist gains flexibility, not triple concurrent output.

## Faculties per person: recommend max THREE, one active

**Recommendation:** \`max_distinct_certifications_per_actor = 3\`, with **one currently active role and one equipped functional loadout**. The owner asked "can one person have three faculties?" — it is an **open approval question** rather than a canon hard cap.

Example: actor M-017 has Engineer, Soldier and Medic certifications. In a Workshop/Armory/Medical Locker:
- Equips construction kit → active \`engineer\`; may build/repair but does not shoot or heal.
- Legally deposits construction tools, picks up rifle → active \`soldier\`; valid combat behavior, not medical assistance.
- Deposits rifle, draws treatment kit → active \`medic\`; can treat biological HP, cannot perform combat or mechanical repair.

Switching is **physical**, time-limited, facility/stock-dependent, and can fail if equipment is unavailable. A change can be fast in well-provisioned forward armories/lockers but **not** an arbitrary instantaneous field-menu click. Credentials stay with that same living person's ID throughout, unlike tools.

Three qualifications cannot create simultaneous buffs, triple passive production rates or a free magic all-in-one unit. Train each faculty in its **correct dedicated institution** with real queue time/cost; the third credential can take longer or require deeper investment as a **balance candidate**, not settled. Dedicated specialists and expert operators may have more proficiency in one discipline, while versatile Manus pays time for breadth. The three-slot limit applies per living **person**, not globally to the faction or to weapon/tool loadout variants. A fourth new faculty must be rejected unless the owner later designs explicit respecialization; replacing an old earned faculty is not free or currently approved.

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
- **Workshop/Engineering School:** certifies Engineer; trained and equipped Engineer constructs frames, repairs mechanisms and can qualify for Energy-grid specialist training within the same faculty.
- **Command Core / Industrial Bay:** certifies Industrial Technician for physical gathering, haulage and loading, with real source/transport gear. Gas/liquid capture still requires legal tools and research.
- **Clinic / Hangar Simulator / SpecOps Center:** teach Medic, Machine Operator and SpecOps faculties. Prefer training stations housed within fewer infrastructure buildings rather than forcing seven standalone mandatory schools. Equipment lockers can be modules in real warehouses or Barracks/Academy.
- **Training queues** consume actual facility slots and do not mutate the same actor from multiple concurrent queues. Reserve necessary costs and occupancy; actor must physically reach facility, stay/participate for applicable ticks, and exit from a legal point.

### Bootstrap and avoidance of a hard lock

**Critical design hole to prevent:** if nobody is born with engineering/mining skill, who builds the first Engineering School and mines the materials to train the first engineer?

Recommended **starter Command Core** provides a **small Industrial Technician induction/training station and a finite starter tool locker** capable of certifying the first basic Industrial Technician and Engineer using legal training queues, or a mission can grant **already-certified founder actors** without treating every later spawn as specialized. The owner has not yet chosen which starter bootstrap method. **Never implement both "all new persons require courses" and "training buildings must be built by people no one can train" with no legal start path.**

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
- **HUM-02:** Basic Manus without Industrial Technician course and physically issued compatible tool cannot perform professional extraction or freight operations.
- **HUM-03:** Soldier eligible only after **completed Barracks training** plus actual issued compatible weapon; Barracks alone does not grant a physical gun.
- **HUM-04:** Scientist eligible for actual powered Lab research only after **Academy training + suitable real research kit**.
- **HUM-05:** Equipped untrained actor and trained unequipped actor both fail full professional job capability.
- **HUM-06:** Example triple-qualified Engineer/Soldier/Medic performs **one active job** at a time, keeping same actor ID and HP.
- **HUM-07:** Exactly three distinct filled faculty slots reject a fourth qualification, but permit earned mastery/rank progression inside an existing faculty.
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

- **HUM-19:** Exactly seven basic faculty IDs exist: industrial, engineer, soldier, scientist, medic, operator, specops. No ghost power-engineer/miner/logistician eighth faculty is added.
- **HUM-20:** New Basic Manus starts with exactly three EMPTY persistent slots; each unique passed course occupies one and certificates preserve actor identity after equipment swaps.
- **HUM-21:** Industrial Technician performs basic mining and physical logistics, but cannot perform engineer structural repair or lab research without additional faculty+kit.
- **HUM-22:** Operator may drive a real crew-required mech with proper training and cockpit gear; autonomous UMU does not suddenly require a person at every node.
- **HUM-23:** SpecOps trained actor with recon/EW kit can perform permitted missions, but cannot use soldier-gated firearm from kit alone without valid Soldier qualification.
- **HUM-24:** A triple-trained soldier/scientist/operator consumes no extra faculty slot when exchanging one allowed weapon for another under the Soldier specialty.
- **HUM-25:** Rank advancement within existing certificate leaves the count of occupied faculties unchanged; no free training or double simultaneous job.
- **HUM-26:** Academy/Lab, Barracks and specialized kits remain post-MVP0; DEC-033 current training workflow is not modified.

**No executable functionality is claimed as implemented by this document.**
