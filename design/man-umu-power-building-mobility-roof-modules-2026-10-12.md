# MAN UMU — Naming, Fuel Generator, Building Mobility and Roof Equipment

**Date:** 2026-10-12  
**Decision register:** DEC-041  
**Status:** owner-directed generator consumes actual resources; building mobility uses **4/6/8 attached UMU for small/medium/large buildings**; **one operational function per UMU at a time**. Roof module catalogue and final expansion of "UMU" are **design candidates**, not final owner choices.  
**Machine contract:** [man-umu-power-building-mobility-roof-modules.yaml](man-umu-power-building-mobility-roof-modules.yaml).  
**Earlier physical chassis and five modes:** [DEC-040 transforming wings](man-umu-transforming-belt-wings-2026-10-12.md) / [YAML](man-umu-transforming-belt-wings.yaml).  
**Game release gate:** DEC-033 four-template MAN-vs-MAN first MVP remains unchanged. This feature is future gameplay; no engine implementation or passing test suite is claimed.

## Owner's text (original Polish)

> Rozpisz UMU Alternarywne nazwy jak uniwersal module unit. Rozpisz jak działa jak elektrownia : łyka zasoby jak magazyn ale je zużywa na wytworzenie energii . Umu może też tworzyć koła dla budynków. 4 umu do małych budynków, 6 średniej wielkości i 8 do dużych . Umu może pełnić jedynie 1 funkcję w danym czasie . I chyba na dachu można montować na stałe moduły: do rozkminy różne zaproponuj jak działka różne, drills do materii stałej i innych, baterie słoneczne .

Treat this as concrete owner direction on **power conversion, wheel/undercarriage role and exclusivity**; no explicit approval yet of one English expansion, rooftop module list, reactor fuel yield, speed, power-grid rates or acquisition technology.

## Naming comparison (working names, NOT a rename instruction)

| Full English name | Acronym | Connotation | Caveat |
| --- | --- | --- | --- |
| **Universal Modular Unit** | UMU | Modular machine for transport, power, defense, industry and structural movement | **Recommended provisional lore name** |
| **Universal Module Unit** | UMU | Generic building block; matches owner's example | Slightly redundant |
| **Universal Mobility Unit** | UMU | Strong building-transport/undercarriage identity | Under-describes generator/warehouse |
| Universal Mechanical Unit | UMU | Rugged mechanical industrial chassis | Broad but less specific |
| Universal Multipurpose Unit | UMU | Five-plus functions and retrofitting | Long and repetitive |
| Universal Manufacturing Unit | UMU | Industrial/economic roles | Inaccurate as soldier carrier/wall |
| Universal Man Unit | UMU | **Existing canonical name in prior DEC-021/040** | Suggests human association rather than modular construction |

**Do not silently rename the in-game canonical label yet.** Existing \`Universal Man Unit\` and \`UMU\` stay until owner selects a new expansion. All proposed alternatives keep acronym UMU and should not change serialized entity IDs. For documentation readability, use UMU.

## Design principle: One physical machine, exactly one active job

Owner rule: **one UMU may perform only one operational function at a time**. It can carry a fixed physical roof module, battery or mechanical adapters even when idle, but mounted equipment is not a free simultaneous active service.

\`operational_role\` is a **single authoritative enum** with exclusive capabilities. Existing DEC-040 had MOVE, WAREHOUSE, CONVEYOR, BUNKER, SENTRY_WALL. Extend it with:
- **POWER_GENERATOR**: physically accepts fuel into a finite input buffer, consumes fuel according to a legal recipe, produces the existing stored Energy resource, then exports it through real grid/physical storage interfaces. Does **not** act as a general warehouse while generating.
- **BUILDING_DRIVE**: physically docks as a wheel/track/undercarriage unit under or alongside a compatible whole building; it contributes locomotion to that **one** convoy assembly and cannot simultaneously operate as an independent road transporter, belt, bunker, drill or generator.
- **HARVEST**: operates an installed compatible rooftop extractor while stationary over an eligible real source; doesn't generate power, serve as a warehouse or send cargo down a long two-sided active conveyor while harvesting. A finite onboard output buffer is allowed as auxiliary machine internals.
- **SOLAR_GENERATOR**: roof solar panel supplies finite existing Energy according to real exposed irradiance and panel condition; it is an alternative recipe/provider within the exclusive **POWER_GENERATOR** role (or an explicit subtype), not a second simultaneous activity.
- **REPAIR**: if a maintenance arm variant is later approved, uses actual real parts/time/consumed Energy on valid mechanical targets. Separate exclusive support role.
- **SURVEY**: sensor/communications specialization if later approved; the scanner's active detection performance is only available in that role.

**Important distinction:** subcomponents needed to carry out one function (fuel intake belt and internal fuel buffer while generating, cooling and controller logic, consuming already stored battery Energy to drive wheels) are not a second external gameplay job. Roof installations may remain physically present and inactive. Passive armor/structural fixtures can remain attached but provide no extra warehouse throughput, power generation, hidden radar or weapons without the relevant selected job.

Existing five modes retain identity. More role labels are **not a requirement to expose 11 equal-level UI buttons**: use a role family and equipment-aware action menu. One selected job is always enforced by the state machine.

### Consolidated role table

| Role | Two transforming conveyor wings | Primary function | Not available concurrently |
| --- | --- | --- | --- |
| MOVE | Both fold beneath open trapezoid cage as two caterpillar tracks | Move same UMU, carrying finite real soldiers OR cargo | Conveyor network, active extraction/generation/warehouse/bunker |
| WAREHOUSE | Exactly **one** wing opens at chosen loading side, other remains folded | Finite goods inventory and real physical loading/unloading | Generator recipes, wall, troop mobility, 3/5 throughflow |
| CONVEYOR | Both extend symmetrically left/right **1+1+1=3** or **2+1+2=5** axial cells | Real finite bidirectional candidate cargo conveyance | Bunker/generator/harvest/building undercarriage |
| POWER_GENERATOR | **One** wing acts as input fuel feeder (candidate physical setup); other folded | Consume actual Matter/Volatiles where an approved recipe allows and produce Energy | Regular external warehouse dispatch, belt corridor, Bunker, transport, survey |
| HARVEST | Parked support pose with enabled rooftop drill/pump/capture module, output goes to finite local buffer | Extract actual compatible world resource | Generator, through-conveyor, Bunker, troop carrying |
| BUNKER | Wings folded alongside body to provide flank cover | Defensive shelter, legal actual garrison/installed weapon if permitted by active defense variant | Conveyor/warehouse/generation/mobility |
| SENTRY_WALL | Wings rotated upright as collision-active ground-unit wall | Deny actual ground navigation, including allies | Conveyor, mobility, automatic warehouse/generator; no free turret |
| BUILDING_DRIVE | Wings become tracks/support contact points for one attached building chassis | Coordinated locomotion with **4/6/8** allied UMUs | All independent UMU jobs, including carrying a separate passenger/cargo manifest by default |
| REPAIR / SURVEY | To be determined by installed roof module, no automatic belt throughflow | Specialist service if researched/approved | Other active jobs |
  
**Generator-versus-Warehouse must look distinct:** both may open a **single physical intake belt**, but *warehouse deposits are stored* while *generator fuel deposits are consumed and converted to Energy*. Both need finite loading time and room. This is a **mode** distinction, not a new hidden resource ledger.

## POWER_GENERATOR — true fuel-fed plant

Owner direction: an UMU **swallows physically delivered cargo just like a warehouse but actually consumes it to create Energy**.

Proposed deterministic pipeline:
1. Player/authorized manager selects \`POWER_GENERATOR\` and a permitted **fuel recipe** from genuinely installed equipment. Validate clear supporting footprint, power grid interface and source accessibility. One fuel intake wing deploys, the other remains stowed (candidate layout).
2. Worker or connected physical conveyor delivers cargo to the **actual intake port**. The packet leaves the sender exactly once, enters UMU's **limited generator-only input buffer** and keeps original resource identity until consumed.
3. Each work cycle consumes finite recipe-defined typed source resource and positive tick time: \`actual_fuel_debit >= 1 legal material amount\`, then creates a finite new amount of stored, transferable, spendable \`Energy\` (DEC-001) under an accountable conversion operation. Never treat generic "power units" as fourth currency.
4. Generated Energy enters a finite local Energy battery or legally connected finite-capacity MAN electric grid. Overflow/stalled grid must stop/pause conversion when there is nowhere lawful to credit the output (rather than magically waste/clone unless explicit venting policy exists). Grid remains **electrical/data only**, never moves solid fuel as packets.
5. Fuel starvation, blocked intake, damage, output battery full or missing export capacity lowers/stops generation. The machine can be repositioned only after switching out, physically retracting intake and handling real remaining fuel.
6. **No circular arbitrage**: cannot make positive Energy out of consuming Energy as sole net input, invent combustible gas without a legal capture rig, use a shield/health bar as fuel, or recursively reprocess produced Energy into surplus Energy. Design finite efficiency and separate sources of potential/chemical/radiant energy.
7. Keep generator Energy production strictly separate from the recurring upkeep of levitated ETH stock and its Obelisk network (different faction).

**Fuel candidates to tune, not yet owner-selected:**
- **Volatiles burner:** high-energy source conversion (especially physically captured fluid/gas using legal containers/collectors). Must actually consume Volatiles; gas must have compliant extraction method.
- **Refined Matter fuel:** only an eligible material subclass or processed chemical carrier; **not every rock is fuel** and ordinary Matter must not spontaneously produce Energy with no plausible conversion recipe.
- **Solar roof:** use light irradiance, panel coverage, shadowing, efficiency, and finite charging/export. Solar is **a power-generation role**, so traveling with roof panels doesn't produce free background Energy. Platform in space can be sunlit/shadowed; do not assume constant maximum irradiance.
- **Battery roof:** reservoir/storage, *not independent electricity generation*. Battery may power the selected active role (tracks, tools or shields) but cannot in parallel act as an unrestricted Energy producer/transfer depot.

**Balance invariants:** Energy output per converted inventory, recipe cost, intake speed, generator warm-up and efficiency, waste/heat/cooling if modeled, and fuel supply chain are all TBD. Avoid hard-coded rates until simulation tests. Energy is not unlimited.

## BUILDING_DRIVE — the UMUs become wheels / bogies of whole buildings

**Owner-approved minimum UMUs for one mobile complete building:**

| Building tier | Required physically attached UMUs | Typical candidate arrangement |
| --- | ---: | --- |
| Small | **4** | Two per long side / at four load points |
| Medium | **6** | Three per long side |
| Large | **8** | Four per long side |

"Koła" (wheels) describes **functional undercarriage/drive units**; physically the UMU retain their belt-based track capability. Do not spawn four free wheels that exist separately from the same four actual actors. They coordinate to carry/drive an intact compatible building, subject to mass, supports and legal ground topology.

**Assembly proposal:**
- Building must be complete and have real \`transport_mount_points\` that accept eligible UMU. Require 4/6/8 **distinct living allied UMU actors**, free to take the job, healthy enough to support load and in suitable physical positions.
- Each one reserves a unique mount point and enters exclusive \`BUILDING_DRIVE\`, remains attributed to its owner and loses all independent roles. A single UMU **cannot be shared across two buildings**, counted twice, or double serve as both mobile generator and wheel.
- Pre-motion: stop building's external production/warehousing/relay/garrison services or adopt an explicit cargo/passenger manifest transfer policy. **No building may fully produce/repair/fire and drive at full power simultaneously by default**. Stop and disconnect external electrical/data/belt/piping edges, settle all real parcels/reservations, stow attached machines and validate height/clearance.
- Begin one **convoy assembly** move order issued to the building group. All participating UMUs coordinate the same route and speed; overall movement is limited by the **slowest available legal constituent drive**, mass and terrain. Pathfinding reserves the **whole building footprint**, not merely individual crawler centers.
- Losing one required active drive in motion **halts** the assembly; it never grants remaining actors invisible capacity to move a supported load with fewer than 4/6/8 unless a future explicit emergency tolerance upgrade is approved. Handle safe emergency stop, damage, obstruction and reconnect without teleporting/duplicating actors.
- Separate stored stock, vehicle HP, wing HP, generator Energy, garrison/soldier identity, building identity and victory-class status survive loading and travel. No free detached copies of the building or its UMUs appear at arrival.
- Dismount/release requires valid terrain, time and no overlap. Each released UMU returns to its own legal mode (typically MOVE), and the building resumes services only after safe re-connection and explicit transition.
- No air travel, void crossing or planet hopping. All playable world surfaces are floating space platforms, so edges/abysses cannot be crossed by this chassis.
- **Do not equate "more UMUs" with unlimited scaling**. Fixed 4/6/8 are owner required counts; actual speed, mass limit and installation time need later balance. If a larger building is not equipped for relocation, mounting 8 UMUs does not conjure wheels through its floor.

**Key strategy:** the MAN player can relocate industrial factories, storage and defenses but immobilizes **4, 6 or 8 other multipurpose UMU** as undercarriage while doing so. This is an enormous opportunity cost; prevents unlimited efficient mobile mega-base.

## Roof / top-mounted module catalogue — brainstorm, not final approved roster

The user suggested **permanently mounted** roof attachments and named guns, drills for solid and other materials, solar arrays. Interpret "permanent" as **persistent installed equipment** until explicitly changed at a legal workshop for a real finite price/time, not freely hot-swappable mid-fight.

| Roof module (candidate) | Eligible *exclusive* job | Effect/terrain input | Main tradeoff |
| --- | --- | --- | --- |
| Light automatic turret | BUNKER active-defense subconfiguration | Combat versus infantry in valid range/LOS | Ammunition or actual Energy; cannot also transport ore |
| Heavy anti-armor gun | BUNKER active-defense subconfiguration | Finite slow heavy fire | Weight, turret turning, energy/ammo, reduced mobility while deployed |
| Anti-air mount / flak | BUNKER active-defense subconfiguration | Threatens valid air targets | Cannot solve ground attack unless separate equipment allowed |
| Solid Matter drill | HARVEST | Physically reaches eligible solid deposit via pivoting roof arm | Must park, depletion of actual vein; no generic unlimited digging of any tile |
| Industrial pump | HARVEST | Extracts nearby legal liquid resource | Needs fluid-compatible port/containment; cannot conjure gas |
| Gas capture + compressor | HARVEST | Attached legal gas collection rig and storage | Gas requires genuine capture and sealed handling |
| Fold-out photovoltaic array | POWER_GENERATOR / SOLAR submode | Converts actual available irradiance into finite stored Energy | Shadow/occlusion and surface area; **does not generate while other mode active** |
| Fuel conversion turbine/reactor | POWER_GENERATOR | Consumes real applicable fuel resource from wing feeder | Finite recipe, fuel logistics, heat/output cap |
| Rooftop battery bank | Power support in selected job only | Finite actual Energy buffer powering selected service, possibly MOVE | Stores rather than creates; no unrestricted background generation/export |
| Mechanical repair manipulator | REPAIR (future proposal) | Physically works on friendly mechanical damage | Requires real parts/materials, Energy and nonzero ticks |
| Sensors/radar/signal dish | SURVEY (future proposal) | Bounded detection/observation with honest fog rules | Separate selected scanning job, Energy/signal constraints |
| Industrial manipulator/loader | WAREHOUSE or CONVEYOR compatible work module | Accelerates eligible one-sided physical handling | Cannot be a free second production/energy job |

**Strict "one function" reconciliation:** a roof weapon module **only functions when the selected role explicitly runs defense**, e.g. BUNKER with actual weapon/garrison rules. An **upright SENTRY_WALL** remains solely a physical barrier by default; the roof gun is **not also automatically firing** as a separate full tactical function. Rooftop solar panels stay attached during MOVE/BUNKER but do **not** generate Energy during those modes. Roof drills must be deployed to a legal extractor role, never mine incidentally while driving. Battery use as input support to the selected role is permitted but charging/export as a separate active role must be gated. Proposals for future combined roles would need **explicit** owner acceptance and real opportunity costs, not casual UI checkboxes.

**Recommended first module catalogue for prototyping (candidate):** one basic gun, solid drill, fuel converter, solar array, battery. Add heavy guns, AA, pump, gas capture, repair, sensing only after physics/inventory/gas and energy budgets work.

**Attachment rules proposed:**
- One **active roof work socket** per baseline UMU. MID/MAX differentiated roof socket size/weight limits are TBD.
- Installed roof module identity, owner, real wear/HP and mass persist across modes, escorts and grouped building drive.
- Physically replacing or removing module takes time, source components, compatible service access and legal footprint; never free per-tick module switching.
- A roof gun isn't inherently a free "auto-sentry" when the unit has selected GENERATOR/WAREHOUSE/CONVEYOR.
- High/massive top modules may conflict with **BUILDING_DRIVE** clearance or roof space under a transport building; stow/require removal rather than clipping geometry.

## What is owner-approved vs candidate?

**Owner-directed, implement as constraints in future release:** the UMU may act as a power plant that actually **consumes real incoming material** and makes Energy; it can provide wheels/drive units for moving whole compatible buildings; **4/6/8 UMUs for small/medium/large**; **one active function at a time**.

**Owner asked to consider, not yet selected:** a new exact English expansion of UMU, permanent roof module types/loadouts, solar output curve, exact fuel recipes, harvest source types and roof-arm lengths, roof socket count, roof weapon ranges, and detailed collision arrangement. The recommendation "Universal Modular Unit" is **not** a new official name until approved.

## Suggested test obligations (future; not passing tests)

- **UMU-25:** a fuel generator debits actual source fuel once per legal positive-duration cycle and credits only bounded output Energy in local/grid storage.
- **UMU-26:** generator does not act as unrestricted general warehouse while running or transfer "free Matter" through electric/data cable.
- **UMU-27:** fuel-starved, storage-full, disconnected or nonmatching-fuel generator stops rather than printing Energy.
- **UMU-28:** selecting POWER_GENERATOR terminates old CONVEYOR/WAREHOUSE full-rate service and excludes independent movement, bunker and extraction.
- **UMU-29:** same roof solar panels attached during MOVE produce **zero** Energy until an eligible solar generation role is selected; sunlight/shadow changes actual output.
- **UMU-30:** solid drill extracts only valid solid actual source after legal stationary deployment and preserves source inventory.
- **UMU-31:** liquid pump/gas collector cannot bypass sealed extraction/compatible containers and real source depletion.
- **UMU-32:** rooftop turret cannot fire while selected role is independent GENERATOR or BUILDING_DRIVE; no unapproved dual-function duty.
- **UMU-33:** exactly four **unique** UMU attach to a small building (three is insufficient), all in BUILDING_DRIVE, with real actor identity.
- **UMU-34:** exactly six unique UMU attach to medium; five cannot start motion.
- **UMU-35:** exactly eight unique UMU attach to large; seven cannot start motion.
- **UMU-36:** one UMU cannot attach to two buildings, count twice or use an unrelated active job during group locomotion.
- **UMU-37:** moving building reserves full actual footprint, stops on unsafe terrain/collision/void, never teleports to the requested destination.
- **UMU-38:** loss of one required powered/healthy attached UMU safely halts whole building convoy and preserves real cargo, garrison and ownership.
- **UMU-39:** replacing an installed roof module takes actual compatible parts/time, cannot duplicate existing module or bypass cargo/actor persistence.
- **UMU-40:** exactly one active role enum resolves all concurrent commands, no phantom services after role change.
- **UMU-41:** building production/warehouse exports/utility power cables settle correctly before move and require physical reconnect after stop.
- **UMU-42:** all role/energy/cargo/building attachment snapshots replay identically on pinned deterministic Godot tick model (GUI/headless/authoritative LAN), pending executable verification.

No new game code was written; this design is strictly a post-MVP0 backlog/canonical contract.
