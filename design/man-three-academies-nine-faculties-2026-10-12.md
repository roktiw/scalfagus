# Scalfagus — MAN Three Academies, Nine Faculties and Three Slots per Basic Manus (DEC-044)

**Date:** 2026-10-12  
**Status:** owner-directed three-academy structure, seven explicitly named degrees and **three persistent faculty slots per person**. The two missing branches, proposed school modules, and exact skill trees below are **assistant recommendations pending owner acceptance**.  
**Machine contract:** [man-three-academies-nine-faculties.yaml](man-three-academies-nine-faculties.yaml).  
**Supersedes:** DEC-043's proposed **seven-faculty catalogue** (and eight-career earlier draft), *not* its one-human identity, three available qualifications, mandatory training/equipment and MVP0 guard.  
**First-release guard:** DEC-033 (MAN mirror, Command Core + MIN + Barracks + Rifleman) stays as implemented until the user explicitly authorizes migration. The three academies are **future gameplay**.

## Owner's original instruction

> 3 akademie: techniczna, wojskowa, naukowa. Nauka medyk, naukowiec i? Wojskowa: piechota, marynarka, lotnictwo. Technika: inżynieria budowy, operator maszyn, i

Owner explicitly specifies:
- **Three academy groups:** Technical, Military and Scientific;
- **Military Academy:** Infantry, Navy, Aviation;
- **Technical Academy:** Construction Engineering, Machine Operator, third TBD;
- **Scientific Academy:** Medic, Scientist, third TBD;
- In preceding DEC-043 owner clarification, **each human has three faculty slots**.

**Canonical structure proposal:** 3 academies × 3 branches = **9 selectable faculties**, of which 7 are user-named and **2 are proposed**: Industrial Engineering (technical) and Cybernetics (scientific).

## A 3 × 3 degree matrix

| Academy | # | Qualification / ID | Who/what it authorizes after training AND receiving real tools | Status |
| --- | ---: | --- | --- | --- |
| **Technical** | 1 | **Construction Engineering** — \`construction_engineer\` | Build buildings, erect MAN conveyor/wiring structures, repair mechanical machines/UMU, structural construction management | Owner-named (construction engineering), boundaries recommended |
| **Technical** | 2 | **Machine Operator** — \`machine_operator\` | Pilot/control real ground mechs, UMU if crew is needed, mining and heavy equipment, ground construction machinery | Owner-named, crew requirements TBD |
| **Technical** | 3 | **Industrial Engineering** — \`industrial_engineer\` | Resource extraction, mining/capture operations, physical haulage, logistics, warehouses, plant operations and energy-generation process work | **Recommended third faculty**, owner has not selected name |
| **Military** | 4 | **Infantry** — \`infantry\` | Soldier, rifleman, heavy infantry and advanced SpecOps ground branches with compatible weapons and training | Owner-named; SpecOps is advanced Infantry endorsement, NOT tenth degree |
| **Military** | 5 | **Navy** — \`navy\` | Crew/navigate/command space-capable ships and fleet systems; waterborne operations only if later world physics supports them | Owner-named; recommended **space navy** flavour, not a claim spacefaring content is in MVP0 |
| **Military** | 6 | **Aviation** — \`aviation\` | Fly qualified aircraft, aerospace fighters, bombers, air transports and other permitted combat flight vehicles | Owner-named; specialist pilot curriculum separate from ground machine operator |
| **Scientific** | 7 | **Medicine** — \`medicine\` | Treat green biological HP, triage, surgery/recovery at real medical units and clinical facilities | Owner-named |
| **Scientific** | 8 | **Research Science** — \`research_science\` | Perform controlled experiments, research technology in powered supplied Lab, run authorized research programmes | Owner-named (scientist), formal name proposed |
| **Scientific** | 9 | **Cybernetics** — \`cybernetics\` | Computing, AI/autonomy, data/telemetry, secure control interfaces, electronic warfare/countermeasures where real systems permit | **Recommended third faculty**, owner has not selected name |

**Why these two suggested branches?**
- **Industrial Engineering** covers the actual MAN extraction, production, power process and physical resource-handling economy, which otherwise has no training path. Alternative labels include **Mining & Logistics**, **Industrial Operations**, **Resource Engineering**. It does **not** turn every industrial engineer into a free high-throughput robot; compatible source tools and positive work durations remain necessary.
- **Cybernetics** captures MAN's information and automation layer, telemetry, robot control, AI autonomy and defensive/offensive electronic operations without conflating research scientist with systems operator. Alternative labels include **Computer Science**, **Systems Analysis**, **Applied Informatics**. The \`Cybernetics\` qualification does not automatically grant unlimited map fog revelation, enemy hacking or foreign-race mind control; all require separate legal technologies and physical information/energy access.

**Cross-faculty distinctions:**
- A **Machine Operator** drives tracked mechs/UMU/heavy ground machines. **Aviation** qualifies flight pilots; **Navy** qualifies ship crews. No one gets free automatic operation of every vehicle by taking Operator alone.
- **Infantry** covers ground fighting. Sniper, grenadier, engineer combat kit, marine boarding combat, and SpecOps are *training endorsements or equipment specialties*, not separate foundational faculties. A Navy crew member who must conduct Infantry fighting requires separate Infantry certificate/endorsement as later defined; no automatic combat superpowers from naval pilot license.
- **Construction Engineer** builds/services structural equipment. **Industrial Engineer** extracts, operates logistics and supports production/energy processes. Some tools overlap but don't collapse the two degrees.
- **Medicine** handles biological healing; Construction Engineer handles mechanical repair (DEC-037). Scientific Research studies technology; Cybernetics operates computational/information systems. Electronic warfare may have a future Military equipment interface but **does not** grant Infantry just by having a Cybernetics credential.

## Institutions versus courses versus facilities

**Three academy institutions do not require exactly three total physical map objects, nor nine obligatory separate campuses.** Every academy can have course-specific real modules/facilities. Positive training times, finite slots, actual staff/equipment and physical attendance still apply.

- **Technical Academy:** Builder Workshop / Structural Engineering Hall, Heavy Machine Simulator / Hangar, Industrial Training Bay / Mine and Logistics Bench.
- **Military Academy:** Barracks/Infantry Training Wing, Naval Simulator / Fleet Operations Trainer, Flight Academy / Hangar Flight Simulator.
- **Scientific Academy:** Medical Clinic & Training Ward, Science Lecture/Lab Training Wing (research jobs later happen in real supplied Labs), Cybernetics/Data and Telemetry Laboratory.
- **No deadlocked bootstrap:** founder mission supplies minimal already-trained Industrial Engineer and Construction Engineer (candidate), **or** Command Core has finite introductory teaching stations/starter kits to grant first legally trained industrial/structural workforce (candidate). Which is canonical remains open. A basic untrained astronaut can still travel, take shelter and attend a course.
- Existing **DEC-033 Barracks → Rifleman** training shortcut stays unchanged. Post-MVP Military Academy's **Infantry Barracks wing** is the upgraded course accreditor; barracks are not removed or replaced with an abstract instant click.
- No scientist, medic or cyberneticist receives a kit free of charge upon degree completion. A legitimate Lab still requires a real qualified Research Scientist and physical equipment/stock/power; analogous facility guards apply to clinic, cockpit and data lab.

## A person holds 3 out of 9, not 1 from each mandatory

Owner rule from DEC-043: \`qualification_slots_total=3\`; now **\`available_faculties_total=9\`**. Default recommended interpretation: an astronaut may choose **any three distinct** qualifications from the nine, **including multiple from one Academy**, but may run just one trained, physically equipped **active occupation** at a time. Nothing in owner's "three academies" phrase requires 1 certification per institution.

Illustrative combinations:
- **Field engineering medic:** Construction Engineering + Machine Operator + Medicine.
- **Frontline technologist:** Infantry + Aviation + Cybernetics.
- **Space-fleet science officer:** Navy + Aviation + Research Science.
- **Self-sufficient industrial expedition:** Industrial Engineering + Construction Engineering + Machine Operator.
- **Infantry reconnaissance specialist:** Infantry + Cybernetics + Medicine.

Credential grants are persistent and uniquely attached to the same living actor (including while aboard four-passenger UMU); gear is a separate real inventory object. A person never gets three simultaneous active jobs, never learns a fourth basic faculty for free and never converts a rifle into a research kit by selecting a UI icon. Rank progression and specialty endorsements within a completed faculty **do not** consume an extra slot.

**Balance:** three degrees confer versatility and high training investment, not triple instantaneous productivity. An experienced single-faculty specialist should often outperform a novice three-degree generalist within that one job. Real specialized machinery exceeds universal UMU's throughput in the same dedicated industrial task (DEC-042).

## What becomes of earlier seven-career plan?

Earlier DEC-043 suggested \`industrial, engineer, soldier, scientist, medic, operator, specops\` as seven faculties; that list is now **historical and superseded**. Mapping for planning and legacy authored examples only:

| Earlier ID | DEC-044 faculty |
| --- | --- |
| \`industrial\` | \`industrial_engineer\` |
| \`engineer\` | \`construction_engineer\` |
| \`soldier\` | \`infantry\` |
| \`scientist\` | \`research_science\` |
| \`medic\` | \`medicine\` |
| \`operator\` | \`machine_operator\` |
| \`specops\` | **Not a separate basic faculty** — advanced Infantry course / kit endorsement |
| Newly added | \`navy\`, \`aviation\`, \`cybernetics\` |

Avoid blindly renaming stable existing game \`man_rifleman\` actor or training action during DEC-033 release. These future identifiers are design IDs, not claims that a runtime migration has already happened.

## Future acceptance scenarios (no executable tests claimed)

- **ACADEMY-01:** Exactly three accrediting Academy categories exist: Technical, Military, Scientific; they offer **3 × 3 = 9** distinct faculty choices.
- **ACADEMY-02:** Any new Basic Manus has three initially empty personal slots; exactly three unique valid certificates may be earned, a fourth is rejected with no cost/kit duplication.
- **ACADEMY-03:** An actor can choose three qualifications belonging to the same academy if enough slots and legal course access exist; no hidden one-per-academy restriction.
- **ACADEMY-04:** Barracks remains the physical Infantry training facility of Military Academy; graduating Infantry alone does not create a rifle without equipment production.
- **ACADEMY-05:** Medicine and Research Science belong to Scientific Academy; Science Lab requires Research Science diploma and physical research kit/valid supply.
- **ACADEMY-06:** The proposed Cybernetics course can operate only eligible real data/AI/telemetry infrastructure; enemy EW power requires legal hardware/technology and cost.
- **ACADEMY-07:** Navy-qualified human may crew real eligible ships, not automatically every aircraft or land mech; Aviation covers aircraft; Machine Operator covers ground machines.
- **ACADEMY-08:** Infantry SpecOps/sniper/heavy gunner courses do not create extra faculty slots; qualification and legal specialist loadout still apply.
- **ACADEMY-09:** Industrial Engineering vs Construction Engineering have distinct extraction/logistics vs construction/mechanical service permissions.
- **ACADEMY-10:** No course produces a free personal kit; actor training and equipment custody persist across job changes, travel and UMU boarding.
- **ACADEMY-11:** One active profession per person even with three degrees; concurrent jobs validate credentials, gear and real work context.
- **ACADEMY-12:** Early first MAN worker can lawfully obtain credentials/tools; no economy bootstrap deadlock.
- **ACADEMY-13:** Current first-release \`train_worker\`/\`train_rifleman\`, fixed four templates and scope remain intact until explicit migration.
- **ACADEMY-14:** Nine certifications are stable deterministic roster entries shared by GUI/headless/LAN with no actor identity/HP duplication on switching jobs.
- **ACADEMY-15:** Training facility infrastructure can be a module of an Academy campus, but real port/slot capacity and actual course time remain.
- **ACADEMY-16:** A three-faculty person can retain skill history during soldier/medic/operator equipment swaps, never gets simultaneous combat/medicine or vehicle-driving effects.

**No Godot implementation or passing game tests are asserted in this document.**
