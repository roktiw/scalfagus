# MAN UMU — Reconfigurable Conveyor-Wing Chassis and Sentry Wall

**Owner concept:** 2026-10-12.  
**Decision:** DEC-040.  
**Status:** owner-approved physical identities (every UMU has two belt wings; 3-/5-tile conveyor lengths; tracks when moving; folded side panels in Bunker; separately rotated wall in Sentry), with candidate tuning and collision protocols clearly noted.  
**Machine contract:** [man-umu-transforming-belt-wings.yaml](man-umu-transforming-belt-wings.yaml).  
**Release:** post-DEC-033 MVP0. Do not add UMU, belts or sentry modes to the four-template MAN mirror first release.

## Owner's source statements

> U man każdy umu ma dwa skrzydła z pasami które może rozstawić na 1 lub 2 pola. Czyli 3 lub 5 długości po rozstawieniu . Do poruszania się wstawia z dwóch stron transport bełty pod siebie i używa jak gąsienic . W trybie bunkra sentry składa je po bokach. Rozwiń i opisz ten koncept

> Umu może jeszcze nic akternstyeny ten sentry gdzie pasy obracają się tworząc mur dla jednostek naziemnych.

The second statement clarifies that **Sentry Wall is a separate alternative mode** from Bunker, not merely another name for it.

## One chassis, two persistent wings, four different functions

Each Universal Man Unit has exactly **two physically persistent conveyor wings** permanently connected to a **central UMU chassis**. The wings are the **same mechanical equipment** in all modes: no spawning duplicate belts, no creating extra structures when folded or packed, and no loss of owned resource inventory merely because the collision shape changes.

| Configuration | Wing physical position | Active service | Main strategic trade-off |
| --- | --- | --- | --- |
| **MOVE / TRACKS** | Left and right assemblies retract/rotate underneath, forming a pair of ground-contact continuous tracks | Actual ground locomotion of the same UMU entity | Belt network stops; no full deployed bunker capability; deployed-only generation/connectors unavailable |
| **CONVEYOR / SHORT** | One wing extends **1 tile** on either side of one-tile center | Real finite freight across **1 + 1 + 1 = 3 tiles** | Shorter reach, faster/safer emplacement candidate; no track locomotion or defensive wall |
| **CONVEYOR / LONG** | One wing extends **2 tiles** on either side of center | Real finite freight across **2 + 1 + 2 = 5 tiles** | Longer reach/greater exposed footprint; not intrinsically infinite or twice the bandwidth |
| **BUNKER** | Both wings **fold snugly alongside the central hull**, creating armored side flanks | Garrison / protection / optional defensive equipment according to chassis | Conveyor ports close; static; physical cargo may need unloading before mode switch |
| **SENTRY WALL** | Both belt wing panels **rotate upward and out into a coherent solid barrier**, with center body anchoring/sealing the middle | **Physically obstruct ground-unit movement** across a real map corridor | Static blockade, not conveyor, not moving tracks, not automatically a turret or troop bunker |

This is **four functional postures**, with 3 and 5 being two selectable submodes of CONVEYOR. No free combined "bunker + uninterrupted full-rate belt" state.

### The 3 / 5 conveyor geometry

Short logical line: \`[BELT] — [UMU] — [BELT]\` (**3 contiguous tiles**).

Long logical line: \`[BELT] — [BELT] — [UMU] — [BELT] — [BELT]\` (**5 contiguous tiles**).

This describes the **central conveyor axis**, not a promise that a physically bulky MAX chassis or its collision radius occupies only one square in both directions. Occupancy/collision must reserve the entire real chassis footprint. Wings are symmetric by default; 4-tile asymmetric placement is not implicitly approved. Deployed wing layout should rotate with actor facing and be validated against map edges, obstacles, other UMU, civilians, military actors and construction reservations.

**MAN starting post-MVP belts**: DEC-038 proposes default **bidirectional** cargo flow with shared finite segment bandwidth and deterministic contention; manual single-direction specialization is a future candidate. A belt wing is **not an army transporter** and an adjacent MAN power/data cable never conveys physical Matter.

### MOVE: conveyor wings become caterpillar tracks

In packing, both conveyors retract beneath either side of the body and wrap around actual rollers. Left/right movement can turn the machine using differential track velocity as animation inspiration. Movement follows actual ground navigation, entity footprint, obstacles, map bounds and transition time. The belt freight graph is disconnected **before** the first mobile simulation step; there is no invisible stretching conveyor between old/new coordinates. Cargo on extended wings must be delivered to a real buffer or safely unloaded before retraction. Cargo physically inside a finite UMU hold may accompany the chassis.

**Not a tank buff**: tracks are slow relative to dedicated light units, the mobile UMU is not a fully functional deployed fortification, and a mobile UMU retains its building-class victory tag when that template has one. Deployed-only electrical generation and grid ports follow older power-mode gates.

### BUNKER: folded side plates, defensive shelter

Wings tuck **parallel against left and right hull sides**, adding flank bulk/protection without extending to block entire approaches. BUNKER is a compact **defensive chassis posture**, providing real side cover and **garrison slots only if the selected variant/module allows it**. A dedicated sentry/turret module may operate under its own actual cost/ammunition/line-of-sight rules; merely choosing BUNKER does not spawn a free weapon or extra soldiers. Cargo input/output conveyor ports remain closed. Initial MID one-soldier versus MAX multi-soldier distinctions may be retained, but every UMU still includes the two wing mechanisms.

### SENTRY WALL: upright belts as a ground-unit barrier

**This is a distinct owner-approved posture.** The belt wings **pivot/rotate upright into rigid protective panels**, each hinged to the central body, and align into a **continuous wall** anchored by the UMU. Their mechanical conveyor faces are **not carrying cargo** in this state. The wall occupies real collision and navigation blocker cells: it **prevents both friendly and hostile ground units from passing through its solid sections**. Friendly-only ghost passage would undermine the physical design. A dedicated authorized opening/gate system may be researched later but is **not approved by this concept**.

Candidate physical layout: turn the two extended wing segments about a hinge to form an upright barrier on both sides of the core. The core itself fills the central gap, so actors cannot walk through the UMU center. The designer can configure wall-facing to protect a chosen approach and compose multiple deployed units into a defensive line. **Whether wall width equals 3 or 5 tiles, how high it blocks, and whether projectile LOS is blocked are future decisions**; the owner has approved *the physical wall function*, not automatic sight/projectile blocking, infinite armor or both 3- and 5-wall variants. The scene must have real collision while deployed and respect combat destructibility.

SENTRY WALL is primarily **movement denial, not sentry-gun attack**. Add mounted guns/auto-fire only if separate equipment is physically present and expressly authorized. Do not conflate this mode with the earlier \`sentry_wall\` idea of an outward-facing defensive emplacement, and do not silently merge SENTRY with BUNKER.

**Prevent construction grief and pathing abuse**:
- Never erect a wall **inside an existing living unit or solid structure**. If the area is occupied, wait/block, ask units to clear by a legal order, or reject — do not damage, teleport or clip them.
- A wall should not be allowed to pass through a map edge, floating platform void, non-buildable cliff, another blocking chassis or illegal reserved tile.
- Valid deploy does change NavigationServer/agent paths in the authoritative simulation at the accepted tick; bots and humans see the same obstacle. No "client visual wall but still walkable" mismatch.
- Friendly workers cannot pass **through** the wall to deliver materials. Provide a deliberate open route, alternate path, or later explicit gated mechanism. Avoid unintentional permanent lock-in by permitting legal retraction, provided transition safety holds.
- Multiple units may build a continuous barrier only if footprints don't overlap. Neighboring wall pieces must share an appropriate physical seam or have an intentional gap; avoid infinitely thin diagonal bypasses.
- On destruction, remove the correct collider and reveal the legal debris/salvage. Existing material custody remains physical and countable exactly once.
- If wing damage exists, wall strength may depend on that actual component's health; per-wing HP/repair and full physics fracture are **implementation candidates**, not canonical combat numbers.

### Explicit resource custody and switching

UMU already has existing **mixed cargo versus dedicated one-resource cargo** options (DEC-036) when legal warehouse ports are open, and an optional finite generator/battery/grid service (DEC-019/021).

Changing between modes requires a legal finite-time transition and clear, auditable material custody:
1. **Inspect/plan** target footprint, nearby collision bodies, reservations, wing health and energy/upgrade permissions.
2. **Quiesce** old belt services and stop accepting packets into soon-to-close wing ports.
3. **Settle** active parcels: accept into real finite chassis buffer, hand to a legal receiver, unload as physical loot/piles in actual free location, or **wait/reject** if neither legal custody transfer nor space is available. Never silently delete, teleport, refund or double-count.
4. **Perform** physical transform over >0 fixed simulation ticks; transforms can be interrupted deterministically, with safe defined midpoint occupancy and no free combat invulnerability.
5. **Commit/verify** the new posture and collider/nav topology. Resume only its legal service providers, never all three simultaneously.

The **same actor ID, owner, HP, typed cargo inventory, garrison manifest, battery reserve, attached wing identity and existing world reservations** persist across mode switches.

## Specialization versus MID/MAX historical contracts

**Latest owner direction overrides the older exclusivity that only a MID conveyor chassis can unfold a 3/5-tile belt.** Every actor called an **UMU** has two belt wings and can arrange them in the owner-specified postures *subject to permitted equipment and operational constraints*.

Earlier contracts:
- MAN MID is a mobile 3/5 belt segment with possible one-soldier bunker / sentry.
- MAN MAX is a larger mobile warehouse / multi-soldier bunker. Power Dock was proposed as a kit on an existing MAX chassis and older YAML explicitly said \`continuous_belt_3_or_5_tiles: false\`.

**Reconciliation:** Treat **UMU as a shared folding-wing chassis/interface**, but **do not yet claim every existing MID/MAX entity is an UMU** or add a fourth new competing tech tier. Once a specific MID or MAX chassis is designated \`umu_capable\`, it **must** own the two transforming wings. MID may specialize in higher belt throughput, MAX in finite storage and fortification; the UMU's portable generator is a physically installed module and its operation follows deployed/packed limits. The exact default unit catalog and ability unlock level remain to be balanced. Deprecate the older prohibiting \`continuous_belt_3_or_5_tiles: false\` for the actual UMU — leave unaffected dedicated Power Dock-only prototypes as historical options.

This avoids a fatal design contradiction: an UMU cannot simultaneously be an owner-approved built-in conveyor vehicle and, by legacy schema, a machine that lacks a conveyor.

## Scenario — mobile line changes into fortified wall

1. A player places three separate UMU on a route between a mine and a factory, each in 5-tile CONVEYOR configuration. They form a real connected commodity transport corridor, subject to capacity and port queues.
2. Enemy ground units flank toward the mine. The nearest UMU receives \`switch_mode(SENTRY_WALL)\`. It stops accepting freight and settles parcels currently on its wings. Connected neighbors register a real network break.
3. Its wing panels rotate upright, extending into an actual blocking barrier. Ground troops must move around, destroy the barrier or wait for it to retract; they cannot walk through it. Friendly traffic is also physically blocked.
4. A second UMU becomes BUNKER: folded side shields protect a real garrisoned unit if the chassis owns a garrison module. No conveyor throughput while it is a bunker.
5. Once the attackers retreat, the player converts the wall back into 5-tile CONVEYOR. If the target cells are free and the fold is legal, real physical freight starts moving again. No free cargo was created or deleted.

## Future validation contract

- **UMU-01:** Every instantiated UMU carries exactly two persistent belt wing components bound to the same entity ID across modes.
- **UMU-02:** A legal 3-tile conveyor footprint has one left wing cell, one core cell and one right wing cell; a legal 5-tile conveyor footprint has two on either side.
- **UMU-03:** In MOVE, both actual wings form left/right under-hull tracks; cargo ports disconnected; nonzero movement and footprint collision verified.
- **UMU-04:** In CONVEYOR, actual finite cargo crosses 3 or 5 tiles via correct ports, respecting DEC-038 two-way candidate and unique custody.
- **UMU-05:** In BUNKER, both wings fold along hull sides, conveyor service shuts off, and only legal equipment/garrison operates.
- **UMU-06:** In **SENTRY_WALL**, the wings rotate into a real blocking barrier, distinct from BUNKER; default no free turret weapon or bonus garrison.
- **UMU-07:** Both friendly and hostile ground agents route around the wall (unless a future physically valid pass-through gate is installed).
- **UMU-08:** Impossible or occupied wall/long-belt deployment cannot push, teleport, silently kill or clip units.
- **UMU-09:** Composing multiple wall UMU yields a continuous collision barrier only where actual world footprints align.
- **UMU-10:** Packed/retracted/destroyed barrier releases correct blocked nav cells and does not leave ghost occlusion.
- **UMU-11:** Switching from occupied conveyor to wall/bunker/move honors parcel custody, legal unload or stops without duplicating stock.
- **UMU-12:** Generator/grid and garrison ports operate only in the postures permitted by their fitted modules and the existing MAN economy.
- **UMU-13:** UMU inventory, wing attachment identity, garrison entities and building victory flag persist across mode changes.
- **UMU-14:** Damaged/blocked wings cannot silently produce collision-free protective wall or full freight rates if relevant damage systems are enabled.
- **UMU-15:** RTS human and bot orders use the same legal transitions; zero-cost instant mode spam and indefinite unaccounted reserved cells forbidden.
- **UMU-16:** Fixed seed/rules produce identical transitions/resource totals in Godot GUI, headless and host-authoritative LAN tests.
- **UMU-17:** Actual source/render/world assets align 3/5 grid with center hull and both wings; not merely icons or descriptions.
- **UMU-18:** Four modes and 3/5 conveyor variants do not creep into current DEC-033 MAN mirror MVP0.

**No verified Godot implementation or test pass is claimed by this design document.**
