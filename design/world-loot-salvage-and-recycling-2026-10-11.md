# Scalfagus — World Loot, Salvage, Attrition and Circular Resource Economy

Date: 2026-10-11
Status: **owner-directed core visual / gameplay behavior; exact recycling fractions, hazards and TTL are playtest proposals**.
Machine data: [world-loot-and-recycling.yaml](world-loot-and-recycling.yaml).
Acceptance fixtures: [recycling-and-network-acceptance-cases.yaml](recycling-and-network-acceptance-cases.yaml).
Supersedes any preceding promise that all destroyed cargo disappears or that unfinished ETH building resources auto-credit distant Nexus after an interruption.
Network contract: [three-faction networks](three-faction-network-and-infrastructure-contract-2026-10-11.md), [new network specialization](three-network-channels-and-destruction-2026-10-11.md).

## 1. Why world resources persist

**Owner requirement:** destructible structures, incomplete/aborted construction jobs, units, and broken material supply chains should eject real, individually collectible items onto the actual 3D map, comparable in gameplay legibility to Minecraft drops. These are owned-by-world packet objects, not just decorations. Any faction's eligible extractor, carrier or salvage worker may physically retrieve them subject to weight/form/equipment, pickup time, terrain, fog and danger. Their formation costs, salvage, lifetime, and losses are deterministic.

Not every destroyed resource packet is fully refunded. The global economy is **open to recovery but lossy**: more battles can circulate previously mined materials and make battlefields strategically attractive, but repeated destruction/rebuilding has strictly decreasing total recoverable input in the absence of fresh extraction.

Three independent axes:
1. **Source/resource physical form** `solid`, `liquid`, `gas` — determines extraction gates and color; DEC-016. Gas vents require rig, but a **previously collected and sealed dropped gas canister** is ordinary recoverable cargo with the appropriate equipment, not a raw gas vent.
2. **Dropped container silhouette** `org_tetrahedron`, `man_cube`, `eth_orb` — indicates the race that fabricated/ejected this item, regardless of who will collect it.
3. **Economic resource identifier** `matter`, `volatiles`, `energy` — accounting label, preserved unless a real authorized conversion recipe changes it; NOT silently 1:1 identical to solid/liquid/gas and **Ether is not a fourth currency**.

## 2. Visual encoding: nine basic pick-ups from only three shapes and three colors

| Origin | Shape in 3D | Solids | Liquids | Gas |
|---|---|---|---|---|
| ORG | **Tetrahedron (4 triangular faces)**: chitinous secretion pod | Amber `#E8AF42` | Cyan `#36C4D8` | Violet `#B58AF6` |
| MAN | **Cube (6 square faces)**: mechanical crate | Amber | Cyan | Violet |
| ETH | **Sphere/Orb**: stabilized energy-matter shell | Amber | Cyan | Violet |

These are **proposed color values** for owner approval. Use the same color for the same physical form regardless of race; an additional glyph `S`, `L`, `G`, outline/pattern and tooltip must support colorblind readability. Do not use shape to encode the resource *type*; the shape always encodes packaging origin.

- Solids: amber/gold `#E8AF42` (stone/wood/crystal equivalent).
- Liquids: saturated cyan `#36C4D8` (sealed fluid).
- Gases: violet `#B58AF6` (sealed vapor/pressure packet).
- **ETH orbs** physically materialized as loot are no longer freely network-traversing Ether inventory once they land on ground. To reinsert them into Ether Network they must be physically carried to a valid **Nexus converter**. This prevents a raid/reclaim exploiting instantaneous returns.

Rendering: simple original low-poly cube/tetrahedron/sphere or matching five-view sprite asset with small bounce/brief initial scatter (deterministic drop position and ownership). Real hitboxes and stack quantities exist on the 3D terrain. Combine identical nearby drops into *one visible stack with a number* after a deterministic merge that preserves origin/custody fields; do not render 1,000 independent animated pickups per large factory death. Never merge dissimilar physical forms or accounts across distinct stack kinds in a way that breaks visibility/ledger.

Cross-faction pickup: no affinity immunity. Equipment suitability still matters (e.g., sealed gas pod should not be hand-opened for free, damaged gas storage may leak under a loss rule). A robot picking an ORG tetrahedron may place its contents into MAN's crate after a real repack/pickup transaction; record `origin_faction` separately from `current_packet_packaging` and `controller_faction`.

## 3. What ejects, and when?

| Event | Owner-directed visible outcome | Accounting boundary |
|---|---|---|
| Destroy completed building | Nearby finite cargo and salvageable recoverable ingredients appear in location-legal stacks; some lost | Separate `loose_on_hand` from `embedded_structure_material`; no 100% guaranteed recycle |
| Destroy combat/economic unit | Finite remaining cargo/battery and recoverable remains can drop, subject to explosion severity | Never spawn the full original unit cost AND full cargo from the same debited stock |
| MAN construction interrupted by worker removal | **Worksite persists** at existing percent, loose delivered build crates lie around and can be stolen/reclaimed | Installed materials stay installed until excavated/salvaged; loose crates still fully real |
| MAN unfinished structure damaged/destroyed | Requires **mining / excavation** by any faction's eligible salvage worker; embedded materials recovered over time, plus on-ground delivery crates | Result cannot exceed selected salvage fraction of actual embedded mass |
| ORG spore/cocoon abandoned | Organic progress decays; periodically **spits out a declining subset of already embodied material** as shape-coded drops | Scheduled decay ticks debit actual remaining embodied stock; remainder decomposes and is irrecoverably lost |
| ORG vessels severed | Affected disconnected branches and dying buildings progressively eject part of their remaining locally contained material | Disconnect itself is not a magic every-building payout: only actually decaying/dying structures/vessel contents emit |
| ETH construction fully interrupted / required NETWORK link lost | **Immediate materialization and ejection at the exact build location of ALL material ingredients already committed to that unfinished construction**; progress becomes 0 | All *committed, not previously consumed elsewhere* ingredients move from construction escrow/installed ledger to ground items once. Channeling Energy already burnt as time/operating cost is **not** refunded as a new resource. No auto-refund to remote original Nexus |
| ETH freight link breaks | Converted Ether packets **actually in transit** may condense into orbs at legal rupture point according to bounded interception/spillage rule | Transfer edge escrow owned once; per-packet source/edge/destination must not all own it |
| MAN material conveyor breaks | Real crates present on destroyed belt segment fall to ground or are lost based on damage; other sections keep their cargo | Distinguish material conveyor from energy/data cable (no material cartons fall out of plain information fiber) |
| ORG vein ruptures | Real in-vessel contents partially leak/drop, surviving vein stores stay real | Living vessel is a physical material transport edge, not an ETH virtual wallet |

**Owner's "all ETH materials drop on interruption" is a deliberate special-case exception to ordinary lossy recycling:** an interrupted *unfinished* ETH structure releases all its material ingredients, but **not** paid labor time, energy already spent in channeling, finished weapon ammo, lost completed-building structural mass, or phantom "value" of a blueprint. Never release both drops and a resource refund transaction for the same ETH commit. Even if the game allows deliberate cancel, it cannot mint resources, and conversion into ground packets still takes legally routed resource supply and build-site work/time.

At an ETH link failure, an already formed finished building is handled by **destruction rules only if it is actually destroyed**, not by automatic complete refund from its inventory.

## 4. Suggested numeric recovery classes — NOT approved percentages

The owner asked for strong recycling but not 1:1. This is an initial benchmark proposal, not guaranteed balance.

| Class | Illustration of recoverability | Additional time/risk |
|---|---:|---|
| Loose intact unattended delivery crates | **100% quantity remains in the world** until collected, destroyed, leaked or expired | Contested terrain, transport and storage |
| ETH unfinished construction on network interruption | **100% of committed material ingredients eject immediately** | All build progress lost; paid channel Energy lost; material must be physically salvaged, then hauled to Nexus for reuse |
| ORG untended/dying cocoon or branch | **20–50% of remaining embodied material** emitted incrementally; rest biological decomposition | Time, caretaker recovery window, interception of corpse/drop |
| MAN half-built frame / destroyed industrial module | **35–55% of embedded structural material** available to mine as rubble; loose build packets separately intact | Mining/excavation work and actual trucks/hauling |
| Destroyed completed structures/units | **20–45% of recoverable invested input**, after damage severity | Fighting over salvage + loss of deployment time |
| Voluntary safe dismantling / deconstruction | **50–70%** from structure body, after disassembly work | Less efficient than simply leaving it; no risk-free full refund |

Never take class default yield, then multiply it upward past 100% through several salvaging abilities. Higher skill may improve the *fraction* up to a **hard cap below 1** for destroyed or fully assembled objects. A dropped undamaged loose package is not "recycling," so its unchanged 100% quantity does not violate that rule.

If input mix contains solids/liquids/gases, recover each actual typed ingredient separately. Different survival fractions by form/impact are candidates (e.g. leaking liquids, escaping gases); don't force all resources to be recovered at identical percentages. Energy converted to work/heat is **spent** and not recreated by a debris explosion.

## 5. Physical item and infrastructure state machines

World item:
`SOURCE/INVENTORY/CONSTRUCTION/NETWORK_OR_EDGE_ESCROW -> WORLD_DROP -> CLAIMED_PICKUP -> PHYSICAL_CARGO -> STORAGE_OR_NEXUS -> SPENT_OR_REMATERIALIZED`.
Each transfer is one authoritative finite ledger transaction, not multi-wallet phantom credit.

WorldDrop fields:
`id, pos3d, faction_of_packaging, original_source_faction, physical_form, economic_resource_id, amount, package_integrity, pickup_requirements, recovery_time, creation_event, parent_entity_id, reservation_owner, expiration_policy, stack_visual_count`.
Player can issue `SALVAGE`, `COLLECT`, `RECLAIM` or `TRANSPORT` orders. Autonomy can perform **routine authorized cleanup** near base while avoiding unapproved raids or expansions. Optional manual looting after battles improves tactics; do not make picking every 1-unit shard mandatory micro.

MAN frame:
`EMPTY_SITE -> CRATES_DELIVERED -> PARTIALLY_ASSEMBLED -> (PAUSED | CONTINUING) -> COMPLETE / RUIN -> EXCAVATED`.
Crates nearby are physical lots; installed inventory separate. Cancel alone does not magically turn all installed structure back into loose crates. A rival may pick up loose crates and then excavate occupied/destroyed ruin using legitimate salvage action.

ORG bud:
`SPORE_SEEDED -> TENDED_GROWTH -> FINAL_MATURATION -> COMPLETE`, or `UNTENDED -> WITHERING -> EXPELLING_RESOURCE_PACKETS -> COLLAPSED`. In interrupted vessel branches, nutrients fail gradually and the process can advance to withering; callbacks eject real portions over time. A caretaker returning can arrest decay if viability remains.

ETH incomplete build:
`PATTERN_SEED -> PHASED_CHANNEL_1_2_3 -> COMPLETE`, or `LAST_REQUIRED_BEAM_BROKEN -> ABORT_AND_EJECT_ALL_COMMITTED_INGREDIENTS -> WORLD_DROPS -> BUILD_PROGRESS_ZERO`. Drop created once at legal cells near unfinished position with deterministic scatter and capacity-limited stacks. Do not automatically credit a remote refund to the previously funding Nexus. The converted investment must have actually traveled over Ether Network to construction custody before it can drop.

Freight edge:
`RESERVED_AT_SOURCE -> IN_FLIGHT_ESCROW -> DELIVERED_AT_RECEIVER` or `EDGE_BROKEN -> SPILLED_AT_RUPTURE_AND_LOST_PART`.
This supersedes the prior simplified **source-retains-ownership-until-ack** proposal specifically where user wants looting from severed ETH link. For very early headless unit tests an atomic source-retained hop may be used as a development simplification **only if** the final mechanics above are separately tested and not misrepresented as implemented.

## 6. A complete resource ledger across the map

Per tracked resource ID and physical-source conversion lineage, at an arbitrary tick:

`authoritatively_extracted_or_generated = physical_inventories + loose_world_items + materials_embedded_in_live_or_incomplete_entities + recoverable_ruins + actual_Ether_node_balances + edge_escrow + already_consumed_or_irrecoverably_lost`

For **unmined source deposits** include `remaining_in_world_source` on both sides of the initial-resource equality, or maintain the equation for *already extracted* stock only. On any transformation recipe record inputs consumed + explicitly produced outputs; gas/solid/liquid are extraction forms, not automatically aliases of Matter/Volatiles/Energy.

A deterministic record of source cost and successive output must be kept **once**. When a full structure is destroyed, don't recreate the entire original recipe's input inventory if a part was already consumed as Energy, fuel, biological feeding or ammunition. `Ether` is counted inside actual ETH node inventory or transfer escrow, **not in a free extra ledger**.

**Hard anti-exploit invariant:** For any closed destroy→salvage→rebuild loop with no newly mined resources, valuable recoverable stock must strictly decrease, unless an explicit separately paid external input makes up the difference. The high-proportion ETH unfinished refund is not a *completed structure recycling loop*: it only changes where still-committed construction materials live, with labor/time/energy and repeated nexus hauling as real costs.

## 7. How recycling changes match length and incentives

**Benefits**
- A defeated army or dismantled front becomes a second, dangerous contested resource field.
- Capture and recovery enable rebuilding outside the main mining areas; raiders can carry crates home.
- Relocation/reconfiguration can involve choosing to lose recoverable structural material instead of magical free repack.
- Terrain persists as visual evidence of battle, creating tactical objectives and comeback opportunities.

**Costs / risks**
- Loot spam: thousands of world sprites/colliders and excessive worker pathfinding; deterministic stack coalescing and rendering level-of-detail needed.
- PvP pacing: recovering and rebuilding can extend a match and reward turtling more than conquering new territory. Consider clear elimination/strategic objective rules and map control timing rather than perpetual economic grind.
- Perverse incentives: demolishing your own army to print cheap resources. Require strict less-than-one recycling of a completed asset and account for remaining ammo/battery/gear versus embedded structure.
- Snowballing: winning player picks up both battlefield scrap and captured enemy materials, gaining even more of an advantage. Contested recovery time, opponent denial raids and limited carrying throughput help.
- Inequality: ETH refunds all ingredients of aborted construction while ORG slowly loses and MAN digs wrecks. ETH must pay **all lost build time plus channeling energy plus network access/looting effort**, not get both full instant refund and no effort.
- Unowned gas items: dropped packets must remain realistically sealed, and leak after physical damage rather than acting like raw freely scoopable gas vents.

**Geometric attrition example:** If a finished asset recycles at 40% effective return repeatedly without new extraction, then 100 initial units yield at most 40, then 16, then 6.4 units of recoverable construction materials on the next successive destroys. Those numbers are illustrative only. With a fixed `r < 1`, `r^n` tends toward zero; recycling does not create an infinite supply in a finite map.

**Cross-check with Factorio (inspiration, not copied mechanic):** Factorio's Recycler typically returns 25% of ingredients; the designers explain that efficiency limit prevents net-positive loops with productivity bonuses ([official developer note](https://direct.factorio.com/blog/post/fff-375), [wiki](https://wiki.factorio.com/Recycler)). Scalfagus can use different faction/event yield curves but must preserve the same no-arbitrage principle.

## 8. MVP implementation constraints / proposed scope

Implement only:
1. A deterministic `WorldDrop` entity with **three shape IDs and three form colors**, amount-based stacking and a basic bounce visual.
2. Loose cargo ejection on building and belt destruction, pickup/haul by MIN and standard collector orders.
3. MAN unfinished scaffold physically persists with **separate delivered loose crates** and finite excavation salvage.
4. ETH unfinished build cancels all progress and **ejects all already committed ingredients at site**, no invisible resource bank refund.
5. ORG disconnected/untended budding emits a sequence of salvage items on a timer; add full multibranch biological salvage later.
6. One in-flight Ether resource escrow scenario, with rupture drops and no duplication.
7. One global per-resource ledger verifier and log of irreversible consumption/loss.

Defer advanced loot physical simulation, chemistry of decomposition, complex liquid spills, exploding gas clouds, elaborate dismantling tech and independent quality grades. Keep 20–40 dropped stacks visible on small combat sites, not thousands of floating animated objects. A world drop stack can be **one sprite plus count** without changing real resource accounting.

## 9. Acceptance tests

See [recycling-and-network-acceptance-cases.yaml](recycling-and-network-acceptance-cases.yaml) for `LOOT-01` through `LOOT-20`, including world geometry, faction compatibility, cancel/destroy semantics, retained inventory, ETH edge rupture escrow, ORG decay emissions, MAN excavation, replay and no-positive-cycle tests.

**Open decisions requiring measured evaluation:** palette confirmation, drops-on-death yield per form, ETH already-consumed operating Energy when construction aborts, amount of information transfer over ETH resource links, ORG mitochondrial energy bootstrap and vein throughput, MAN hybrid cable range and whether UMU should be equivalent to existing MAX chassis, owner preference for when loot despawns and match anti-stalemate rules.
