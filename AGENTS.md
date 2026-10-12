# SCALFAGUS — Coding-Agent Contract


## MVP0 3×3 FOOTPRINT & 2M WORLD GEOMETRY (DRAFT, UNVERIFIED)

Use the single `apps/game/scripts/mirror_geometry.gd` contract for all
HQ/Barracks 3×3 (nine tiles) occupancy and the twelve exterior access cells.
Every gameplay cell represents **2 metres** in the visual world. The authoritative
`MirrorMatchState.building_cells` and native `AStarGrid2D` agree on all nine
blocked cells, and the 3D `StaticBody3D` on the Sprite actor covers the same
6×6m area. No alternate grid spacing/collision tables may be introduced.
Resource delivery, building, training, and targeting use exterior footprint
cells. Draw / line-of-sight remain grid-authoritative; elevation, physical
terrain colliders and 3D raycast LOS are **NOT FINISHED**. Test:
`apps/game/tests/mirror_footprint_smoke.gd` and `scripts/check.sh` locally
using real Godot 4.7.2, not broken GitHub Actions.
Details: `docs/MVP0-FOOTPRINT-WORLD-SCALE-2026-10-12.md`.


## MAN 3 ACADEMIES / 9 FACULTIES — DEC-044 (POST-MVP0)

**This NEWER owner design supersedes DEC-043's earlier SEVEN-faculty roster.** Read [three academies / nine faculties](design/man-three-academies-nine-faculties-2026-10-12.md) and [machine contract](design/man-three-academies-nine-faculties.yaml) **before** the dated DEC-043 professions file. Basic Manus retains **exactly THREE personal credential slots** and one active job needing trained qualification AND real issued kit. **TECHNICAL** = Construction Engineering, Machine Operator (mechs/UMU), **proposed** Industrial Engineering (mining/transport/industry); **MILITARY** = Infantry, Navy, Aviation (all owner-named; SpecOps is advanced Infantry, not a tenth faculty); **SCIENTIFIC** = Medicine, Research Science, **proposed** Cybernetics (AI/telemetry/digital control). All three academies have THREE degree choices; the two proposed third names need final owner confirmation. Barracks remains Infantry training for Military Academy, while Science research uses the existing Academy/Lab training/work separation. Do not collapse Navy/Aviation into Machine Operator or turn every credential into a free physical tool. **Do not edit DEC-033 MVP0's working man_min/man_rifleman or train_worker/train_rifleman as part of future academic design.**


## MAN BASIC ASTRONAUT / PREVIOUS SEVEN-ROLE ROSTER — DEC-043 (HISTORICAL, SUPERSEDED BY DEC-044)

Read [Basic Manus, professions, training and equipment](design/man-basic-astronaut-professions-training-equipment-2026-10-12.md) and [machine contract](design/man-basic-astronaut-professions-training-equipment.yaml). DEC-043 historically established: MAN base creates **Basic Manus astronauts** with **exactly THREE initially empty persistent vocational slots**. Its older **SEVEN-career draft below is superseded by DEC-044**, which defines THREE academies and NINE possible courses. Current recommended names: **Industrial Technician** (miners + physical logisticians), **Engineer** (including grid engineering), **Soldier**, **Scientist**, **Medic**, **Machine Operator** (mechs, heavy machinery) and **SpecOps** (recon, sabotage, EW). These names/boundaries are proposed in response to owner's request, but 3 slots and 7 choices are binding. Person must **TRAIN in appropriate facility** (Barracks for soldier, Academy for scientist/Lab) **AND physically equip a compatible tool/kit** before doing that job. Only ONE profession active; weapon/tool variants and proficiency within same faculty don't eat extra slots. Preserve stable actor ID, HP, certifications and physical kit/cargo ledgers; do not create classes by respawning persons. **Do not mutate DEC-033 MVP0 train_worker/train_rifleman, four templates or current Godot simulation** without explicit later migration. UMU's separate exclusive machine-role system remains DEC-041.


## UMU PRECISE CAPACITY / LIGHT GENERALIST BALANCE — DEC-042 (POST-MVP0)

Read [UMU cargo packing and specialist balance](design/man-umu-capacity-and-specialist-balance-2026-10-12.md) and [machine contract](design/man-umu-capacity-and-specialist-balance.yaml). Owner-set, **not candidate**, capacities are **FOUR soldiers OR cargo**, with **3×3×3 = 27** real standardized resource units in the open cage, or **27 + 3×3 left + 3×3 right = 45** cargo units when **every unit of cargo is of ONE resource type**. Passenger and cargo profiles are exclusive. The additional two visible nine-unit side racks are **real objects**, not free abstract slots; account for collisions/clearances with the same two changing conveyor-belt wings and with any building-drive mounts. This replaces "UMU packing bonus TBD" in older docs; it **does not** set other MAN warehouse capacity. UMU is **light, versatile and strong because it can change jobs**, but **DEDICATED SPECIALIST units must clearly outperform UMU in their one chosen function**. Exact specialist performance multipliers TBD in balance testing. Maintain DEC-041 exclusive one active UMU function and DEC-033 first-release exclusion.


## UMU EXCLUSIVE POWER / MOBILE BUILDING / ROOF TOOLS — DEC-041 (POST-MVP0)

Read [UMU fuel generation, building drive, naming and roof-module design](design/man-umu-power-building-mobility-roof-modules-2026-10-12.md) and [machine contract](design/man-umu-power-building-mobility-roof-modules.yaml). Owner rule: **each real UMU has EXACTLY ONE ACTIVE FUNCTION at any time**, independent of the roof equipment physically installed. In **POWER_GENERATOR**, the UMU physically consumes eligible real source materials delivered into a finite intake buffer, converts them via a timed legal recipe to the existing stored **Energy** resource, and is **not a general WAREHOUSE** at the same time; solar panels require the dedicated generation role. In **BUILDING_DRIVE** distinct real UMU act as wheels/crawlers of a whole compatible building: **4 small, 6 medium, 8 large**, locked to collective locomotion, unavailable for any independent tasks; full real-building collision/path/motion and resource conservatism apply. The fixed roof gun/drill/pump/solar/battery/repair/sensor roster and official English expansion of UMU are **owner-requested candidates, not settled**. Existing name remains `Universal Man Unit`; `Universal Modular Unit` is the working recommendation only. This supersedes older suggestions of simultaneous warehouse/generation. **Do not put any of these features in the DEC-033 first MAN mirror.**


## UMU MOVE CAGE AND ONE-BELT WAREHOUSE — DEC-040 REFINEMENT

**The current UMU contract has FIVE exclusive modes**, not four: [MOVE open-cage trapezoid tracks, WAREHOUSE one active belt, CONVEYOR symmetric 3/5 cells, BUNKER side armor, SENTRY wall]. See the [updated design](design/man-umu-transforming-belt-wings-2026-10-12.md) and [updated YAML](design/man-umu-transforming-belt-wings.yaml). In MOVE both conveyor wings **bend under the vehicle as two crawler tracks**, producing a characteristic **trapezoid silhouette around an open front-and-rear cage** capable of transporting actual soldiers **or** finite cargo. In WAREHOUSE **exactly one** of those physical belt wings opens to the left/right for local loading/unloading while the other stays folded. Do NOT require a symmetric two-wing CONVEYOR deployment to access warehouse goods, do NOT treat the cage's carried inventory as a free remote deposit, and do NOT allow MOVE to keep live external belt connections. Soldier/cargo mix and exact warehouse-wing length are TBD. Keep DEC-033 MVP0 scope unchanged.


## MAN UMU TRANSFORMING WINGS — DEC-040 (POST-MVP0)

Read [UMU transforming belt-wing design](design/man-umu-transforming-belt-wings-2026-10-12.md) and [machine contract](design/man-umu-transforming-belt-wings.yaml) before touching future MAN UMU mechanics. Owner rule: **EVERY UMU HAS TWO ATTACHED CONVEYOR-BELT WINGS**, used as two under-hull tracks under an open soldier/cargo cage in MOVE, **one belt open for the separate WAREHOUSE loader** (the other folded), symmetric **3- or 5-tile through-CONVEYOR** (1+center+1 or 2+center+2), folded side armor/garrison in BUNKER, and upright physical ground-unit-blocking barrier in the distinct SENTRY WALL mode. SENTRY is terrain denial, **not an automatic sentry-gun or bunker synonym**; it blocks friendly/enemy ground units where actual collision exists. Never give one UMU full modes simultaneously, create wing copies, clip through occupied cells, or teleport/destroy resources on pack/deploy. **DEC-040 supersedes old MID-only 3/5 belt / no belt on UMU Power Dock statements for any unit designated an UMU**, but exact MID/MAX catalog mapping remains TBD. All is post-MVP0 and must not be included in DEC-033 four-template MAN mirror.


## MAN MVP0 MAP SOURCE CONTRACT — Verdant Divide

The **only authored world topology source** is `design/mvp-verdant-divide-map.yaml`.
`scripts/compile-verdant-map.py` converts it using the pinned permissive MIT PyYAML
authoring tool to the checked-in native Godot artifact
`apps/game/maps/verdant_divide.compiled.json`.
`MirrorMapPort` feeds both `MirrorMatchState` and its AStar navigation from that
JSON. **Do not copy/paste source deposits, trees or spawn positions into gameplay
GDScript or add a second procedural gameplay terrain generator.**

On YAML changes, regenerate JSON using `python3 scripts/compile-verdant-map.py`
with the pinned `scripts/requirements-map.txt` package, then validate with
`bash scripts/check-map.sh` and `bash scripts/check.sh` on real Godot 4.7.2.
The source SHA and exact JSON artifact must agree. One known raster collision is
resolved as **water over tree** at (28,46); do not remove the pond in collision
logic to conceal it. The source currently contains 10 nodes / 1660 Matter,
2 diagonal starts and a single-cell impassable rim. 3x3 building footprints,
ridges/ramps, 2m visual physics and 3D LOS remain **unimplemented**.
GitHub Actions remain unavailable before runner allocation: do not imply green CI.



## THREE-FACTION LOGISTICS — CANON OVERVIEW (DEC-035–039)

**Start with [MAN / ORG / ETH logistics overview](design/three-faction-logistics-overview-2026-10-12.md) for a current side-by-side summary** of physical MAN belts and UMU packing, biological ORG bidirectional veins and monotypic cysts, and ETH Obelisk ground drone flags plus upper levitating network. It includes all three owner-selected ETH ingress options (Nexus zero Energy upload tariff, drone paying 33% shield at Obelisk tip, powered Obelisk ground pick-up with high Energy cost), the power-loss resource drop, storage energy/throughput tradeoffs, unresolved choices, and direct links to specific DEC-035–039 machine contracts. **This is a summary, not a replacement for those contracts and never changes DEC-033 MVP0 release scope.**


## ORG PLUG HOLES / ETH THREE UPLOAD PATHS — DEC-039

Read [ORG port & ETH ingress design](design/org-plug-holes-and-eth-three-ingress-methods-2026-10-12.md) and [DEC-039 contract](design/org-plug-holes-and-eth-three-ingress-methods.yaml). ORG preferred standard vascular docking interface is a **universal biological Plug Hole** accepting eligible equipped MIN/MID/MAX transport workers, with distinct specialist Mouth organs optional; the owner has not finally chosen Plug Hole-only vs hybrid. Respect DEC-011's one active worker/item handoff and exclusive MOVE/RECEIVE/DISPATCH/EXTRACT modes for initial ORG MID/MAX. **ETH owner selected three resource upload methods:** (1) physical delivery to Nexus with ZERO additional ingress Energy tariff, real travel/processing; (2) eligible shielded drone physically injects a finite cargo batch into an Obelisk tip at **33% drone blue shield cost** (max-shield basis per bounded batch is a proposed implementation and remains TBD); (3) powered Obelisk directly picks up authorized real nearby ground cargo at the **highest actual Energy cost**. This **supersedes the historical Nexus-only raw ingress restriction of DEC-021 for later ETH gameplay**. Unique custody, finite positive transfer times, DEC-037 shield recovery rules, DEC-036/038 storage congestion/homogeneity and ongoing levitation upkeep still apply. Any older "Nexus only" statements elsewhere are historical for ETH release plans. **None of this belongs in DEC-033 MVP0.**


## BIDIRECTIONAL FACTION LOGISTICS AND ETH HOMOGENEITY — DEC-038

Read [bidirectional logistics and storage economics](design/faction-bidirectional-logistics-and-homogeneous-storage-2026-10-12.md) and [machine specification](design/faction-bidirectional-logistics-and-homogeneous-storage.yaml). Owner rule: at **equal total levitated inventory**, ETH **single-resource** Obelisk storage has **lower continuing Energy upkeep** than heterogeneous mixes; it **still reduces relay throughput as its inventory fills**, under DEC-036, and still needs energy to stay aloft. ORG's universal living veins and ETH's Obelisk-tip links are **bidirectional** for legal material flow; never double finite bandwidth just because movement is possible in either direction. ORG cyst remains single-resource, with **costly biological specialization/mutation**; reversibility remains open. For **early post-MVP MAN conveyors**, owner proposed belts capable of both flow directions **without manual arrow orientation**; later optional Factorio-style directional modes are *not* decided and head-on traffic must be resolved deterministically with genuine shared capacity. This is **future work beyond DEC-033 first release**. Nexus-only raw ETH conversion remains the baseline pending its separate owner decision.


## ETH DUAL GROUND/LEVITATION LOGISTICS — PROPOSAL, NOT AN APPROVED RAW-UPLINK CHANGE

Read [ETH two transport loops](design/eth-dual-loop-ground-flags-and-aerial-freight-2026-10-12.md) and [machine candidate](design/eth-dual-loop-ground-flags-and-aerial-freight.yaml). The owner specifies **physical drone-to-drone cargo handoffs at Obelisk foot flags** plus a **separate elevated visible straight-line tip-to-tip Ether freight service** on the already unified ETH network, with actual mixed levitated stocks, network upkeep, and physical falling resource objects on loss of levitation support. Nearby build sites receive real parcels descended to the Obelisk foot and physically delivered onward. The owner has now resolved the non-Nexus raw uplink question in DEC-039: legal shielded-drone tip upload and expensive powered Obelisk ground pick-up supplement free Nexus upload. Exact port technology, shield-charge basis and Energy tariffs remain TBD. Secondary ingress is owner-selected under DEC-039; no special cost-free re-lift of previously fallen Ether stock is approved. Do not introduce these ETH systems into DEC-033 MVP0.


## RECOVERY / SHIELD DOCTRINE — DEC-037 (POST-MVP0)

Read [faction recovery rules](design/faction-damage-recovery-shields-and-repair-2026-10-11.md) and [typed contract + HEAL scenarios](design/faction-damage-recovery-shields-and-repair.yaml): ORG has slow passive biological HP regeneration and faster healing when genuinely connected to a functioning living vein; ETH shields naturally recharge, recharge faster near properly connected **Obelisks**, and **consume an entire recharged shield to restore a finite amount of green HP**, possibly over multiple shield→health cycles; MAN biological damage needs medical treatment, mechanical damage needs service/repair, and optional MAN force shields **NEVER** recharge except by finite battery or valid powered grid. Shield durability, green HP and the stored Energy resource are distinct ledgers. Exact timing, HP per consumed ETH shield and costs are TBD. **Keep this out of DEC-033 four-template MAN mirror MVP0.**


## ETH OBELISK / FACTION STORAGE UPDATE — DEC-036

**Canonical ETH player-facing term: OBELISK, not PYLON.** Older `eth_mid_pylon` / `pylon_obelisk` are technical compatibility IDs only; do not blindly rename serialized Godot data or old acceptance fixtures. Read [storage rules](design/faction-storage-specialization-and-obelisk-traffic-2026-10-11.md) and [YAML tests](design/faction-storage-specialization-and-obelisk-traffic.yaml): ORG stores only one resource kind per cyst; MAN UMU stores mixed goods or more of one type when deliberately specialized; ETH levitates mixed typed-resource stock around Obelisks, and greater node inventory occupancy **reduces throughput**. Use storage Obelisk sidings/clusters and lightly loaded transit backbone nodes. The old idea of unconditionally equalizing all ETH pylon fill levels is **superseded** by DEC-036: protect transit nodes from forced fill and scope background equalization to explicitly participating storage nodes. None of these systems belongs in DEC-033 MAN mirror MVP0.


## LOCAL GODOT ADDONS — ACTIVE SETUP, NO ACTIONS GATE

Godot 4.7.2 editor plugins: RTS Framework (WIP reference only), Godot State Charts 0.22.5 and GUT 9.7.1. Keychain 2.1 is an **explicit runtime autoload** so native games do not depend on launching the editor to register its singleton. The Keychain editor plugin is disabled to avoid duplicate singleton management; the vendored Keychain library remains installed. Locked revisions for new addons are tracked in `architecture/godot-addons.lock.yaml` and Git submodules. `scripts/dev.sh` / `scripts/check.sh` automatically call `scripts/install-godot-addons.sh --ensure`; the latter runs an independent headless addon manifest smoke. **GitHub Actions have pre-runner failures, so never claim CI passed; use actual local Godot logs.** LimboAI intentionally not installed. Installed editor plugins are NOT evidence that they implement RTS gameplay; never delegate GameState authority.


## LATEST DESIGN DISCUSSION ARCHIVE — 2026-10-11

The owner's recent conversation on unit initiative, FULL MANUAL / SEMI-AUTO / FULL AUTO, group managers, -1/0/+1 doctrine temperatures, hot preset switching, X-COM / Dwarf Fortress / Dungeon Keeper inspiration, and MAN / ORG / ETH asymmetric transport is preserved in [the chronological discussion archive](inbox/2026-10-11-gameplay-autonomy-doctrines-xcom-dwarf-logistics-conversation.md). It includes original Polish user utterances, separate assistant design summaries and explicit MVP0 vs future-scope labels. Use owner-approved decisions and release-specific contracts as authority; a brainstormed podcast mechanic is not automatically a release requirement. 

## POST-MVP FACTION LOGISTICS UPDATE — DEC-035

Read [three-faction logistics and ETH unit relay](design/three-faction-logistics-and-eth-unit-relay-2026-10-11.md) and [machine-readable specification](design/three-faction-logistics-and-eth-unit-relay.yaml) before modifying post-MVP0 MAN/ORG/ETH logistics. MAN uses physical transporters, mode-dependent warehouses/bunkers/UMU and belts (NOT cargo in electricity/data cables); ORG uses large living carriers and finite rooted veins; ETH has finite actual storage on EVERY pylon, gradual typed-resource hop transfers, and additionally a **slow, finite-capacity ETH unit transit capability across connected pylon links**, which no other faction's infrastructure grants. Shared unit identity, inventory, network interruption behavior and authoritative transfer/cost semantics are mandatory; numerical balance and interruption policies remain TBD. **Do not introduce ETH, ORG, conveyors, UMU or pylon unit relays into the DEC-033 MAN-only first MVP0 release.**


## OWNER PRODUCT VISION — THREE CONTROL MODES (POST-MVP0)

**Read [command-autonomy design](design/command-autonomy-modes-2026-10-11.md) and [machine-readable contract](design/command-autonomy-modes.yaml) when planning future agent autonomy.** Player can instantly switch **FULL MANUAL** (classic RTS explicit orders), **SEMI-AUTO** (bounded managers controlling chosen groups of units and buildings) and **FULL AUTO** (civilization-wide doctrines with explicitly delegated authority). Preset doctrines include **War, Industrial, Reconstruction, Expansion Preparation, Defensive Readiness and Balanced**. Candidate doctrine panel exposes **3 / 5 / 7 axes** with -1 / 0 / +1 temperatures; temperature biases legal behavior, but never grants authority, vision, free resources or stat bonuses. Explicit manual commands always win. No reset or duplicate resource transactions on live mode/preset switches. **These are design contracts, not implemented or MVP0 deliverables. DEC-033 MAN-vs-MAN RTS-only release scope is unchanged.**


## LATEST VERIFIED SOURCE AUDIT — OPEN P0 GATES

Read the [consolidated mechanics findings](design/mvp-repository-mechanics-audit-2026-10-11.md) and [machine-actionable findings](design/mvp-repository-mechanics-audit.yaml) before editing the match. The [runtime parity checklist](design/mvp0-runtime-parity-gaps.yaml) has **CODE-GAP-01..17**, including corrected movement rate: `MirrorMatchState._walk()` moves **one cell only every third simulation tick**, not every tick. `mirror_view.gd` advances at **10Hz** in default GUI; the candidate sim specifies **20Hz**. Authoritative YAML map: **10 source nodes/1660 units**; current state: **4 source nodes/2500 units**.

`scripts/check.sh` NOW includes `mirror_smoke.gd` and `mirror_visual_smoke.gd`; the visual smoke protects directional sprite assets, startup window and camera zoom, but assumes exactly **four** resource visuals until map migration. The separately runnable `mirror_batch.gd` is **not** part of `scripts/check.sh`. None of these were executed by this documentation audit; run pinned Godot and record actual exit status, seed and hashes before writing “green”. The **current first-release numeric candidate** is `design/mvp0-agent-implementation-contract.yaml`; the other `mvp0-man-mirror-balance-v0.1.yaml` is a different analytical experiment, not an active second source.

**P0 coding order:** fix one timebase/profile → compile correct map/nav/collider/source data → verify paid end-to-end local RTS + smoke/headless → ENet host-authoritative two-client H-H → repeatable C-C + H-H QA. Do not start ETH/UMU/Energy or FPP work before DEC-033 MVP0 gates.

## P0 CODE-TO-RULE PARITY BLOCKERS (new source inspection)

**Before tuning bot results or calling `mirror_batch.gd` balanced**, review [current map/timing/network gaps](design/mvp0-runtime-parity-gaps.md) and [machine list CODE-GAP-01..15](design/mvp0-runtime-parity-gaps.yaml). The experimental `mirror_match_state.gd` uses **2500** hard-coded source units, `MAX_TICKS=5400` and mining a full bag in 6 ticks; canonical authored Verdant Divide uses **1660** source units. The GUI `mirror_view.gd` currently advances at **10Hz** while the intended candidate simulator is **20Hz**, so simulation time, gathering, training and rifle ranges need normalization. New test scripts have not been verified by this audit. H-H ENet authority is still a release blocker.

**Load ONE first-release numeric candidate:** [mvp0-agent-implementation-contract.yaml](design/mvp0-agent-implementation-contract.yaml) is the current selected source under [agent-source-of-truth.yaml](design/agent-source-of-truth.yaml). The additional [micro-MVP analytical profile](design/mvp0-man-mirror-balance-v0.1.yaml) and its [numeric scenario tests](design/mvp0-man-mirror-balance-acceptance.yaml) are **alternative experiments**; do not blend their differing worker speeds/build radii into runtime or claim tests pass. The [LAN authority protocol](design/mvp0-man-mirror-network.yaml) and [micro execution semantics](design/mvp0-man-mirror-execution-contract.md) provide detailed implementation help without adding ETH, UMU, Energy or FPP to MVP0.



## MANDATORY REUSE-FIRST ENGINEERING POLICY — DEC-034

**Every coding agent MUST search existing Scalfagus components, built-in Godot 4.7.2 APIs, and audited GitHub/AssetLib modules BEFORE implementing a generic subsystem.** Prefer existing wrappers, then thin adapters to engine primitives, then pinned and license-reviewed third-party modules, then only unique game-domain logic. GitHub availability alone is NOT approval: source, license, immutable commit, Godot 4.7.2 compatibility, macOS/Windows/Linux/Web support, authority/security, actual tests and rollback must be checked. **No arbitrary plugins, floating dependency branches, runtime auto-downloads, or self-written standard A*, physics, keybind framework, GUI layout, generic FSM or networking transport.**

**Required reading and PR evidence:** [ADR-0004 reuse architecture](architecture/adr-0004-godot-reuse-first-wrappers.md) → [component map](architecture/godot-reuse-component-map.yaml) → [GitHub candidate registry](architecture/godot-third-party-candidates.yaml) → [research](docs/GODOT-REUSE-RESEARCH-2026-10-11.md) → [agent playbook](docs/AGENT-REUSE-FIRST-PLAYBOOK.md) → [GitHub PR checklist](.github/pull_request_template.md). Candidate addons are **NOT installed** merely because listed. Godot built-ins count as preferred upstream reuse. The authoritative GameState, fog, owner validation, finite resource accounting, match state and victory logic are specific to Scalfagus and cannot be delegated to unverified plugins.

**Release precedence:** DEC-033 MAN-vs-MAN classic RTS first; DEC-034 governs HOW code is built. Preserve F2/F3 experimental camera code, but do not expand ETH/FPP/TPP into this micro MVP.

**Development evidence and next verification gates:** [Markdown report](docs/SCALFAGUS-MVP0-DEVELOPMENT-FINDINGS-2026-10-11.md) and [machine-readable YAML](design/mvp0-development-findings-2026-10-11.yaml). Newly added MAN mirror state, renderer, smoke and batch runners are committed but **unverified**; no Human–Human LAN host yet. Never treat historical Godot smoke passes as evidence the new RTS compiles.

**Code status (2026-10-11):** Experimental implementation added at `apps/game/scripts/mirror_match_state.gd` (fixed-tick MAN state, four unit/building templates, bot controllers, economic ledger, combat and victory), `mirror_view.gd` + `scenes/mirror_match.tscn` (local RTS blockout), `tests/mirror_smoke.gd` + `tests/mirror_batch.gd` (new headless tests). Menu launches H-C or C-C only. **Code committed but new Godot tests are NOT verified**, and Human-Human LAN is still TODO. Preserve legacy spike and run `bash scripts/check.sh` before reporting any pass.\n\n## CURRENT RELEASE GATE — DEC-033 current micro-MVP (supersedes old MAN+ETH first-MVP plan)

**Implement ONLY the MAN-vs-MAN classic RTS for MVP 0.1, with two player slots and all three combinations H-H / H-C / C-C.** Human-Human requires two Godot clients over LAN or loopback and an authoritative host; computer players use the same commands. C-C runs headless/accelerated or in observer mode. The roster for this first release is **Command Core / MIN worker / Barracks / Rifleman**; initial Matter-only finite-gather economy, one floating-space-platform Verdant Divide map, combat and full building-elimination victory. **NO FPP/TPP gameplay, ETH/ORG, MAN UMU/power networks, Hero progression or advanced resources in this micro-MVP.** Preserve the existing three-camera prototype/smoke for safety; do not advertise or enhance it as an MVP deliverable. Future product FPP remains DEC-031. Do not infer that the new scope has been implemented.

**Authoritative agent reading order:** [DEC-033 in decisions](design/decisions.yaml) → [micro MVP design](design/mvp0-man-mirror-rts-2026-10-11.md) → [micro MVP YAML](design/mvp0-man-mirror-rts.yaml) → [proposed MVP0 implementation parameters](design/mvp0-agent-implementation-contract.yaml) → [micro MVP agent backlog](design/mvp0-man-mirror-backlog.yaml) → [micro MVP acceptance](design/mvp0-man-mirror-acceptance.yaml) → [runtime test cases](design/mvp0-man-mirror-rts-runtime-tests.yaml) → [Godot headless balance lab](design/godot-headless-balance-lab-2026-10-11.md). **Mechanics audit:** [Markdown findings](design/mvp-repository-mechanics-audit-2026-10-11.md), [YAML findings](design/mvp-repository-mechanics-audit.yaml), [machine authority](design/agent-source-of-truth.yaml). The older two-faction `MVP-DELIVERY-GATES.md` and `mvp-implementation-backlog.yaml` are **post-MVP history**, NOT the current execution queue.


**Current architecture: Godot 4.7.2 Standard / GDScript, one native window, one authoritative 3D world.** No Tauri, Rust, Vite, WebView or second launcher. Godot already has a menu, a Hero actor, and F1 RTS / F2 Direct / F3 FPS camera spike. It does **not yet** have the full playable RTS mechanics. Do not overwrite or re-bootstrap the project from scratch.

**Most important latest owner decision (DEC-030): EVERY PLAYABLE SCALFAGUS MAP IS A FLYING PLATFORM IN OUTER SPACE.** This is mandatory for all maps, not an optional aesthetic preset. Soil with jungle trees, welded metal patchwork, rocks, sand, marshland or mixed materials may cover the platform, but the world always visibly has a space-facing rim/underside and a cosmic exterior. No ordinary planet-surface playable map. In MVP, the surface is a bounded planar **64×64 candidate square** with real elevation/ramps, invisible hard outer walls, a visible space-platform edge, one gameplay ground deck and uniform gravity. The platform does NOT physically move during matches; its backdrop planet/stars are noninteractive.

**Current implementation handoff:** [RTS navigation & minimap](docs/RTS-NAVIGATION-DEVELOPMENT-2026-10-11.md) and [first RTS slice](docs/RTS-FIRST-SLICE-2026-10-11.md). Treat the coarse A* map, mock ETH actors and debug minimap as prototype code. The canonical map YAML and economic/combat MVP are NOT yet implemented. Import and run new Godot headless tests before merge; never report completion from source review alone.\n\n## Historical two-faction expansion references — NOT the MVP 0.1 worklist

**The following eight references describe the future MAN–ETH five-role implementation, not the current MAN mirror scope.** Do not load their separate numerical balance profile, Energy, ETH networks, UMU or old three-camera UI into `mvp_0_1`. For the first release use the DEC-033 read order above, and the DEC-034 reuse-first policy at the top.

## Historical future reading (in precedence order)

1. **Owner decisions:** [design/decisions.yaml](design/decisions.yaml), especially **DEC-030** for every map, DEC-024 for victory, DEC-025 for roster/MVP, DEC-026 for environmental affinities, DEC-021–023 for networks and loot.
2. **Universal world law:** [design/space-platform-world-contract-2026-10-11.md](design/space-platform-world-contract-2026-10-11.md); compulsory [design/battlefield-frames.yaml](design/battlefield-frames.yaml); valid [surface/biome presets](design/platform-surface-presets.yaml).
3. **Concrete required deliveries:** [design/MVP-DELIVERY-GATES.md](design/MVP-DELIVERY-GATES.md), [design/mvp-implementation-backlog.yaml](design/mvp-implementation-backlog.yaml), [design/AGENT-MVP-IMPLEMENTATION.md](design/AGENT-MVP-IMPLEMENTATION.md).
4. **First map:** [design/mvp-verdant-divide-map.yaml](design/mvp-verdant-divide-map.yaml), [design/map-authoring-format-v0.1.yaml](design/map-authoring-format-v0.1.yaml), [design/world-environments.yaml](design/world-environments.yaml). Note version of the YAML manifest; do not treat a sparse authored route hint as proof of walkable navmesh.
5. **Game mechanics:** [design/mvp-man-eth-catalog.yaml](design/mvp-man-eth-catalog.yaml), [design/mvp-economy.yaml](design/mvp-economy.yaml), [design/mvp-combat.yaml](design/mvp-combat.yaml), [design/mvp-bot-behavior.yaml](design/mvp-bot-behavior.yaml).
6. **Shared invariants:** [design/three-network-channels-and-destruction.yaml](design/three-network-channels-and-destruction.yaml), [design/world-loot-and-recycling.yaml](design/world-loot-and-recycling.yaml), [design/victory-building-template-registry.yaml](design/victory-building-template-registry.yaml).
7. **Executable tests to write:** [design/mvp-man-eth-acceptance.yaml](design/mvp-man-eth-acceptance.yaml), [design/battlefield-frame-acceptance.yaml](design/battlefield-frame-acceptance.yaml). These YAML files are design fixtures, NOT tests that have already passed.
8. **Historical comparisons only:** [design/floating-platform-battlefields-2026-10-11.md](design/floating-platform-battlefields-2026-10-11.md) previously treated flying platforms as optional; [design/planetary-map-topology-2026-10-11.md](design/planetary-map-topology-2026-10-11.md) considered real spheres. **DEC-030 supersedes those alternatives.**

## Historical two-faction slice (after MVP 0.1; NOT first playable release)

- Exactly **two playable factions**, MAN and ETH, each initially: mother/HQ, MIN worker, basic soldier, infrastructure (MAN **UMU** / ETH **Pylon/Obelisk**), barracks. Hero reuses a soldier-based actor and preserves the SAME entity ID/HP/cooldowns across F1/F2/F3.
- First battlefield = **Verdant Divide**: stationary **floating jungle deck in space**, brown fertile earth, trees with real solid-trunk line-of-sight and movement blocking, freshwater ponds/streams (nonharvestable), two starts, authored paths and scattered finite SOLIDS.
- **Only raw SOLIDS are harvested** in the MVP (directly without a mining building). They yield Matter through an explicit MVP-specific mapping. No direct liquid/gas extraction. Energy is separately accounted and sourced at finite declared rates; Volatiles is not required on initial recipes.
- MAN: ground-mobile UMU as generator + warehouse OR bunker; physical material crates, one hybrid power-conductor + optical-data cable; builders assemble real frames (worker caps 1/2/2); unfinished structures and loose crates remain and can be looted.
- ETH (older roadmap superseded by DEC-039): Nexus is one of three permitted physical-cargo to typed-Ether ingress methods; **one** actual network through anchored pylons transfers real typed Matter/Energy/information with finite inventories and capacity; builders use beam (caps 1/2/3). Interrupted active incomplete construction **immediately ejects all site-committed materials as real ETH orbs**.
- Loot: MAN crates/cubes, ETH orbs, later ORG tetrahedra; form colors SOLID amber / LIQUID cyan / GAS violet; cross-faction pickup legal, completed-asset recycling loses resources and must not create infinite income.
- **Default victory = all opposing live completed BUILDING-CLASS entities destroyed**, including packed/moving MAN UMU. Workers, soldiers, surviving Hero, trees, platform structure, loose crates, cables or incomplete ruins do not count.
- No in-MVP player flight, sailing, swimming, genuine curved planet terrain, interplanetary travel, moving platform origin, multiplayer, playable ORG, new heavy-unit/barracks families, or full tech tree.

## Runtime + commands

The **existing native Godot project** is under `apps/game/`. Game is one Godot window with a built-in menu. Node is optional **offline tooling** (sprite atlas checks, build-time YAML→JSON compiler) and **not** a gameplay runtime. Do not reintroduce Tauri.

From repo root on a supported system with Godot installed:
```sh
bash scripts/check.sh                   # native Godot import, game smoke, menu smoke; optional Node asset checks
bash scripts/dev.sh                     # native Godot menu/game
bash scripts/dev.sh --editor            # native Godot IDE
```
On macOS `bash scripts/bootstrap.sh` installs/validates the pinned official Godot binary; on other OS set `GODOT_BIN` to the installed compatible Godot. Check actual code/project/scripts before assuming an API or executable. Never claim tests passed if not run.

## Historical MAN+ETH implementation order (after micro MVP)

- **G0** inspect current game and preserve existing Hero / 5-direction renderer / menu tests.
- **G1** validate and compile mandatory **space-platform** YAML into runtime terrain: brown soil, water, fixed tree trunk cover, ramps, stable spawn/SOLIDS, visible rim/underside/starfield and four impenetrable bounds; **reject** missing or classic planetary-surface framing.
- **G2–G4** spawn correct MAN/ETH roster, select/order units, mine/carry/deposit real Matter, spawn infrastructure, construct with faction-specific actual logistics and finite Energy.
- **G5–G6** produce soldiers, fight around tree cover, use win condition, run fair scripted bot from initial match until end.
- **G7–G9** physical salvage and loot, network splitting and no-duplication, full HUD and one Hero across camera modes, reproducible tests and perf.
- For each gate, add executable headless checks with corresponding design-fixture IDs; report tested, untested and blocked cases. Do **not** mark design-only YAML as implemented.

## Documentation, data and change policy

- Write all repository documentation, source comments, names and commit messages **in English**.
- A playable map's `battlefield_frame.variant` **MUST** equal `floating_space_platform`. Vary `environment.preset` and surface material region masks for soil, metal patchwork, desert, rocky or aquatic-looking platforms. Merely painting a planet in the background does not make the gameplay level spherical.
- Gameplay-critical cover, source, spawn, ramp and liquid features are authored as deterministic semantic objects; cosmetic plants, rivets and starfield may be seeded and are nonblocking.
- YAML numbers such as HP, exact prices, map physical scale and Energy production are developer starting hypotheses for playtests. Never call them final owner-approved balance.
- If specs disagree, **latest approved DEC wins**: DEC-030 all-platform world over DEC-029 optional map skin or ordinary-planetary fallback; DEC-033 MAN-mirror first release above DEC-025 historical two-faction plans; DEC-034 reuse-first engineering; DEC-030 universal floating-platform world; DEC-024 building-class victory.
- Prefer small idempotent changes to existing scenes/scripts. Never replace Godot with another engine, generate an empty scaffold instead of completing playable behavior, or duplicate source stock into both a world drop and an account refund.
