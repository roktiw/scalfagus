# Scalfagus — UMU Physical Capacity, Mono-Cargo Side Racks and Specialist-vs-Generalist Balance

Date: 2026-10-12  
**Decision:** DEC-042 — owner-approved physical capacity and faction MAN balance identity.  
**Machine contract:** [man-umu-capacity-and-specialist-balance.yaml](man-umu-capacity-and-specialist-balance.yaml).  
**Supersedes** previously unspecified UMU numerical capacity in DEC-036/040/041 while preserving physical wings, modes, Energy, actual cargo, and DEC-033 first-MVP exclusion.  
**Release gate:** Post-MVP0. These mechanics are planned, **not implemented/tested in Godot**.

## Owner statement (Polish, unedited)

> Umu ma w środku miejsce na 4 żołnierzy albo 3x3x3 jednostki surowców. Gdy jest mono surowców to może jeszcze dokleić z dwóch stron 3x3 surowców . Także są op: lekkie , uniwersalne, muli funkcjonalne ale wyspecjalizowane jednostki będą o wiele bardzie mocarne .

Interpretation: "3x3x3 jednostki" = **3 × 3 × 3 = 27 actual standard cargo-unit slots inside**. For a **single resource type**, the UMU may physically attach **one 3×3 rack (=9 slots) on each of two sides**, hence a **45-slot maximum**. "OP" here conveys strong strategic flexibility; it **does not grant** an advantage over dedicated specialists in every numerical stat. "Light" is a **role/weight philosophy relative to heavier dedicated equipment**, not an override that automatically turns an already slow heavy MAX UMU into a faster-than-MIN scout. Adjust canonical MID/MAX unit-catalog tier only in separate explicit tuning.

## Capacity: count every occupant, not abstract global stock

| Internal configuration | Inside UMU | Left exterior | Right exterior | Combined | Rule |
| --- | ---: | ---: | ---: | ---: | --- |
| Troop transport | **4 soldiers** | 0 | 0 | **4 soldiers** | Four living tracked entities in real finite seats; **no cargo in same volume** |
| Multi-resource freight | **27 cargo units**, 3×3×3 | 0 | 0 | **27 cargo units** | Mixed compatible types share one common 27-unit cargo capacity |
| Mono-resource freight | **27 cargo units**, 3×3×3 | **9**, 3×3 | **9**, 3×3 | **45 cargo units** | All inside and both outside attachments are the **same selected resource type** |
| Empty | 0 | 0 | 0 | 0 | Nothing generated merely by changing configuration |

Mono specialization delivers **18 extra slots**, which is **18/27 = 2/3 ≈ 66.7% more units** than mixed capacity; the mono variant holds **5/3 ≈ 166.7%** of mixed capacity. This is the owner-approved quantitative outcome for UMU, replacing older DEC-036 "capacity bonus TBD" for this chassis; other MAN storage systems may have distinct capacity rules.

**Important:** "mono" applies to **total real cargo, not merely the external rack contents**. A 27-inside mixed load plus 18 units of just one type on the sides is **illegal**. No single entity has simultaneously four onboard soldiers and 27/45 cargo units in the same open cage. If troops occupy the cage, exterior racks are unavailable by default. Carrying passengers plus cargo simultaneously would require later explicit owner approval and a redesigned manifest/geometry.

**Physical resource-unit vocabulary:** the counts are **standard cargo cubes/slots**. If real-world solid, sealed-liquid container, gas canister, or processed Matter has heterogeneous volume, capacity charges must eventually normalize to consistent physical slots; quantity labels should not bypass container dimensions. No new resource currency, no free conversion of gaseous/raw material into identical cube inventory without legal extraction and packaging.

**Explicit inventory structure candidate:**
- \`transport_profile\` ∈ \`troops\`, \`mixed_cargo\`, \`mono_cargo\`, \`empty\`.
- \`passengers\`: up to 4 real allied legally boardable soldier IDs; no duplication, each actor's HP/owner persists through boarding, travel and disembark.
- \`internal_stack_slots\`: exactly 27 compatible real standard cargo slots in a 3×3×3 volume.
- \`left_side_rack_slots\`: max 9 (3×3), \`right_side_rack_slots\`: max 9 (3×3); each legal only when profile is mono and \`selected_resource_type\` is valid.
- \`all_cargo_resource_types == {selected_resource_type}\` for mono mode whenever nonempty. Check before each intake/handoff.
- \`cargo_custody_owner\` remains exactly one real UMU/cargo storage component per packet. Moving packets to exterior mounts is a **real transfer inside the UMU inventory** and never deposits twice into the economy.

### Physical attachment geometry / contact with existing belt wings

The UMU has **two actual movable belt wings** (DEC-040). Side 3×3 cargo racks must be visibly mounted on both sides **without occupying the same physical swept volume as either belt wing in its current posture**.

**Engineering requirement, not owner-defined geometry:** prefer side-mounted clamped modules *above/outboard of the underbody tracked-belt path* when moving. If real 3×3 side racks collide with wing retraction, upright SENTRY WALL, BUNKER protective side plates, the open WAREHOUSE wing or a roof extractor/gun, that transition is **blocked until racks are emptied/retracted/legally relocated**. Do not simply hide external stock in inventory because the animation needs clearance.

External racks likely increase:
- full physical width, legal path footprint/turning radius and collision/reservation area;
- exposure to attack and spill/salvage when external restraints are destroyed (specific destruction rules TBD);
- visible loading/unloading steps for both external 3×3 arrays, potentially serially from one active warehouse loader rather than bypassing its port bottleneck.

**Not automatically approved:** carrying external side racks at maximum speed, allowing side racks in SENTRY wall pose, mixed internal stock while racks hold mono, or instant refolding without relocating attached goods. During **BUILDING_DRIVE** (DEC-041), UMU are dedicated bogies under a building; physical side-rack clearance and load status must pass a real check, so by default require removing external racks or explicitly compatible mounts.

### Mode and occupancy invariants

- **MOVE**: open trapezoid cage contains **either up to 4 soldiers OR 27 mixed OR up to 45 mono resource units**, subject to mass/width and real boarding/loading constraints.
- **WAREHOUSE**: one existing belt wing opens to serve the finite actual hold. The **same 27/45 storage cap** applies; it is not a magically larger pocket dimension when parked. All external racks remain real and accessible only through legal handling.
- **CONVEYOR**: both belts extend as 3/5 tile through-flow. Goods **in transit on belts** are separately physically attributed lane packets, not hidden extra stationary UMU storage. If its internal cargo remains, it can only be held in real finite sealed/buffer capacity that is compatible with the deployed geometry; do not turn every 3/5 belt into a free 45-unit warehouse.
- **POWER_GENERATOR / HARVEST**: internal feed/output buffers are finite physical subareas, not simultaneously a full 27/45 general cargo warehouse. Any idle cargo must remain in a safe legal persisted hold or be unloaded before switching.
- **BUNKER**: having garrison seats during deployed operation is different from the **MOVE 4-soldier travel manifest**; a legal garrison capacity by tier/module remains an independent policy. Do not assume every bunker receives four protected firing positions by reusing passenger capacity.
- **SENTRY_WALL**: collision-active folded/upright side wing geometry must be clear; no hidden exterior racks through wall collision.
- **BUILDING_DRIVE**: all 4/6/8 attached UMU have one active drive role, not an additional 45 cargo units per bogie unless a specific separately accounted building payload policy authorizes it.

### Specialized equipment must dominate UMU at its own job

The owner's desired unit design is **lightweight, universal, multifunctional UMU with broad strategic optionality; far more powerful specialist units in each dedicated role**.

That means *different axes of strength*, not equality or merely reskinned variants:
- **Dedicated heavy hauler** (candidate): significantly more cargo throughput/capacity per time or better cost per delivered cargo on a fixed optimized route than UMU; UMU's advantage is being able to turn into the warehouse/belt/defensive object after arrival.
- **Dedicated warehouse**: bigger stack capacity, higher intake/outtake concurrency, denser fixed packing or lower upkeep. UMU provides relocatable stock and mono capacity bonus, but its **single-wing loader** is a physical bottleneck.
- **Dedicated conveyor/splitter line**: better sustained belts, advanced priority and multi-lane routing. UMU provides fast redeployable 3/5 bridges, not the best permanent freight megabackbone.
- **Dedicated power plant**: stronger sustained Energy output and efficiency for the same appropriate fuel/maintenance footprint; UMU can bootstrap a remote outpost but not outproduce a carefully supplied plant.
- **Dedicated drill/miner**: higher extraction throughput/efficiency and ability to access difficult deposits; UMU rooftop drill has light/mobile utility, not massive industrial rate.
- **Dedicated APC or bunker**: better assault durability/protection or firepower per military investment; UMU is open-cage troop mover or improvised defense, not a tank that becomes the best factory.
- **Dedicated building tractor/industrial lifter**: if introduced later, could move giant structures faster/more safely, but **do not** invalidate owner-approved standard 4/6/8 UMU wheel assemblies.

**Quantitative balance is OPEN:** "much stronger" is a binding **qualitative role hierarchy**; do not silently invent exact 1.5× or 3× specialist multipliers. Benchmark normal conditions (cost, sustained throughput, power per fuel, protection, mobility, maintenance) and assign measurable margins through simulation/playtesting; specialist should reliably outperform a comparable UMU in its intended, already-established operating scenario. UMU can legitimately beat it on **versatility, quick role pivot, portable footprint, emergency redundancy**, and some rapid redeployment situations.

**Risk of overpowered pure UMU spam:** A competitive strategy made exclusively of universal UMUs must have significant disadvantages against one using dedicated plants/warehouses/defenses for a developed base. Opportunity cost helps — **exactly one active role per UMU** (DEC-041), time to change pose, side-rack placement limitations and roof module compatibility. No free all-in-one activated powers, no background rooftop solar while driving, no simultaneous bunker turret while performing generator production.

### Acceptance tests (future, not executed)

- **UMU-43:** MOVE accepts exactly 4 legal soldier IDs, rejects fifth and rejects all cargo during troop profile; reboarding retains IDs/HP.
- **UMU-44:** Mixed cargo fits up to 27 standard cube slots, physical layout 3×3×3; 28th mixed unit is rejected.
- **UMU-45:** Mono cargo fits 27 inner plus exactly two 3×3 racks of 9 each for maximum 45; 46th rejected.
- **UMU-46:** Switching from mixed to mono with incompatible stock cannot conjure the two racks or quietly relabel mixed stock; physically unload or deny transition.
- **UMU-47:** Attaching two racks never duplicates their 18 stored cargo packets in the original hold/global stock.
- **UMU-48:** MOVE with full external racks uses the **actual wider path/collider/turn radius** and rejects illegal narrow passages; geometry is consistent in GUI/headless/LAN.
- **UMU-49:** Full exterior racks block any BUNKER / SENTRY / WAREHOUSE / BUILDING_DRIVE transform that would physically overlap wings or the building undercarriage until safe unloading/reposition.
- **UMU-50:** One-sided WAREHOUSE loader preserves actual 27/45 storage capacity; one port does not produce hidden infinite throughput or double-count external racks.
- **UMU-51:** CONVEYOR 3/5 live belt packet custody does not create an additional perpetual 45-capacity floating depot.
- **UMU-52:** Generator fuel buffer and drill output buffers do not magically borrow all 45 cargo slots as independent secondary WAREHOUSE while those exclusive roles run.
- **UMU-53:** Roof gun/solar/drill remains idle if another role is currently active (DEC-041).
- **UMU-54:** Specialist industrial unit is measurably stronger than comparably costed UMU in its one intended function under benchmark scenarios, while UMU has a versatility advantage (balance test, threshold TBD).
- **UMU-55:** Mobile 4-passenger / 27-mixed / 45-mono profiles preserve actor identity and economic conservation after destruction/salvage, disconnect or mode change.
- **UMU-56:** None of these capacities or attachments is accidentally introduced into DEC-033 first MAN-vs-MAN four-template MVP.

All quantities above are **owner-selected**, not arbitrary placeholder tuning, except for explicitly labeled candidate rules governing collision/mass/partial buffer use.
