# Scalfagus — Asymmetric Storage, Cysts, UMU Cargo Optimization and Obelisk Traffic

**Date:** 2026-10-11. **Owner direction:** new DEC-036; post-MVP0 faction economy.  
**Machine contract:** [faction-storage-specialization-and-obelisk-traffic.yaml](faction-storage-specialization-and-obelisk-traffic.yaml).  
**Precedence:** supplement DEC-010/012/013/018–023/035. DEC-033 still gates MVP0 MAN vs MAN and excludes all these advanced storage systems.

## Owner's design clarification

- **ORG:** resources are stored in living **cysts**. Each cyst holds **exactly one resource kind at a time**; no mixing of different typed resources within one cyst.
- **MAN:** an **UMU** can store a **mix of different goods**. When the player assigns it to store **one selected good only**, it uses its physical compartments more efficiently and can store **more of that good** than in mixed mode.
- **ETH:** a single **Obelisk** levitates and stores **a mixture of typed resource goods around itself**, visibly. The more of its capacity it uses for storage, **the lower its cargo/transport throughput becomes**. The player should therefore create **network sidings/branches and dedicated storage-Obelisk clusters**, while keeping key thoroughfare Obelisks lightly loaded.
- **Naming:** the canonical **player-facing name is "Obelisk", not "Pylon"**. Avoid inviting StarCraft Protoss comparisons by calling ETH structures "Pylons" in UI, lore, tutorials, new game assets, or future public descriptions. Existing identifiers (such as `eth_mid_pylon`, `pylon_obelisk`, legacy keys and filenames) are **legacy compatibility aliases**, NOT an order to rename serialized scenes, savegames, tests or code IDs without a migration plan. New prose and visual UI use **Obelisk** consistently.

This gives each faction a different storage planning problem, not simply a recolored inventory widget.

## Side-by-side storage identity

| Dimension | ORG — living cysts | MAN — modular UMU cargo | ETH — levitating Obelisk stock |
| --- | --- | --- | --- |
| Storage | One resource kind per cyst | Mixed cargo by default; single-type specialized configuration optional | Mixed typed Ether stores visibly levitating around each Obelisk |
| Specialization | **Mandatory** per cyst | **Optional**; single kind offers greater usable capacity | **Spatial**: distribute storage to Obelisk sidings rather than busy backbone |
| Transport relation | Large organisms and vascular veins feed/empty cysts | Transporters, local warehouses and belts deliver/collect from eligible ports | Unified Ether network moves resources across actual Obelisk hops |
| Player's puzzle | Correct cyst proportions, location and vessel capacity | Flexible mixed buffering versus efficient bulk commodity depots | Storage density versus local relay bandwidth, branch topology, rerouting |
| Failure mode | Full/wrong cyst backs up its single goods stream | Reconfiguration or full UMU blocks receipts; bunker/packed ports obey existing modes | Saturated trunk Obelisk slows transit, backing up freight and possibly unit relays |

## ORG cyst contract

1. A cyst has finite `capacity`, `stored_resource_id` (one of approved typed currencies when bound), `stored_amount`, owner and physical location. **One cyst may never contain multiple distinct `resource_id` values**.
2. A cyst must select or acquire a resource binding before accepting stock. A cyst bound to `matter` rejects `volatiles` or `energy` (provided each is eligible for that cyst type). Empty cysts may be unbound; selecting a binding is a legal player/manager action.
3. Changing the bound type when nonempty is **not an instant conversion**: existing stock must be physically transferred to eligible other inventory or disposed of only by explicit costly game rules. No disappearing goods, phantom refunds or currency transmutation.
4. Material enters/leaves through real organism transfers or accessible finite living vessels; cysts do not bypass ORG rooted-base home nourishment requirements. A severed vein partitions access to cyst stock; the stock remains at the actual cyst.
5. Cyst capacity, construction cost, eligible resource types and whether nutrition needs a separate cyst class remain **TBD**. Do not assume unlimited biological storage or a passive global wallet.

**Typical consequence:** an ORG base rich in Matter but short on Volatiles may still face an apparent storage shortage because every nearby cyst is Matter-bound; it must build/rebind suitable cysts and supply real biological transfer capacity.

## MAN UMU storage contract

1. When cargo-capable and its warehouse ports are enabled, UMU supports **MIXED** mode: accepted typed goods coexist under a **finite shared cargo capacity**.
2. In **SPECIALIZED** mode, UMU accepts **one explicitly selected resource kind**, with **greater effective usable volume/capacity for that selected kind than the same chassis in mixed mode**. This is packing/layout efficiency, not new Matter or matter transmutation.
3. Mode change is a deliberate configuration choice. Switching from mixed to specialized while holding incompatible cargo requires actual unload/reroute first; never discard another resource or copy cargo. Time, access conditions and mode costs are **balance TBD**.
4. The new cargo composition modes are **subconfigurations of an eligible warehouse/UMU mode**, not a new ability to store in fortified bunker, packed travelling or shut-port states if existing law closes the ports. A different factory or generator may offer only compatible interfaces; do not assume every power plant is an infinite universal container.
5. A specialist depot can be optimized for huge Matter throughput while another mixed UMU buffers repair resources. Player chooses flexibility versus footprint/efficiency.

**Not a buff:** specialized UMU is not faster at moving or collecting goods by default. It gains **physical capacity**, not free hauling. Actual belt/hauler port throughput is separately bounded.

## ETH — Obelisk storage is traffic interference

1. **Every Obelisk is a real local mixed typed-Ether store** (subject to its currently allowed operational service mode). The resources are represented visually as **levitating orbs/packets distributed around the Obelisk**, matching real `resource_id`, finite quantities and custody.
2. **Stored goods reduce the Obelisk's effective through-relay handling capacity as storage fills.** The penalty is calculated from **actual occupied storage** (including legitimate reserved stock in the node), not simply whether the Obelisk was assigned a cosmetic 'warehouse' label. No free throughput by hiding its inventory in different graphics.
3. A player may deliberately create a **warehouse spur/siding** (a branch off the main Ether path) containing several heavily loaded Obelisks and a **lightly loaded main-line corridor** of high-throughput transit Obelisks. Supplies must still move through physical valid graph edges with finite time; no isolated off-network store with magically accessible stock.
4. Back-pressure and queueing are real: if a central Obelisk is loaded close to capacity, through traffic and perhaps ETH slow unit transport may be delayed. Traffic routing can favor less loaded alternative corridors, if they actually exist.
5. **No permanent softlock at maximum legal capacity without escape mechanics.** The first design candidate applies a *strictly positive minimum relay service rate* to an active storage-relay Obelisk so stored goods can drain; turret/meditation service restrictions remain independent and may close cargo ports. Other positive-only depletion mechanisms require explicit balancing if chosen later.
6. Proposed illustrative, **non-canonical** performance relation (storage-relay mode):
   `effective_node_cargo_bandwidth = max(min_service, floor(base_service * (1 - storage_pressure_factor * occupied_fraction)))`.
   Here `occupied_fraction = actual_occupied_storage / actual_total_capacity`; all constants and slope are **TBD and must be playtested**. Nothing in this formula mints/destroys stock. Linked edge bandwidth and other mode restrictions still apply, so the effective hop capacity is limited by both edge and node.
7. Traffic class `unit_relay` (DEC-035) uses the *same Obelisk graph* and should face explicit finite node/edge arbitration. Whether storage pressure penalizes unit transit equally, proportionally or via separate reserved service slots is **open**; do not silently grant teleport-like priority.
8. Network equalization must respect the owner's deliberate placement of warehouse sidings. A blanket 'equalize every Obelisk to the same fill ratio' rule (older candidate) would automatically clog the main line and destroy this design. **DEC-036 supersedes default unqualified full-network fill equalization.** Preferred proposal: per-node storage/relay policy, optional active load targets and non-storage transit reserves; background equalization operates **only on explicitly participating eligible store nodes**, after urgent real supply movements, and never force-fills protected backbone relays.
9. The player must be able to see `held stock`, `max stock`, `effective traffic throughput`, queues/congestion and route type on each Obelisk. Visual orbiting packets must not be mistaken for free combat projectiles or for a newly introduced currency.

### Example, not tuned balance

A→B→C is the main supply corridor. A→D→E is a storage siding. B stays almost empty for high-speed through-flow; D/E levitate most strategic reserves at reduced local service. When D/E are full, their branch may clog, but A→B→C can still transfer at near-full capacity unless a true shared bottleneck lies at A. If B is also used as a giant store, transfers and eligible unit relays become slower. Attackers can threaten storage clusters and cut branch links; defending them creates a meaningful tradeoff.

## Shared rules and AI doctrine integration

- Exactly **one authoritative state** and physical accounting ledger for goods; storage modes do not alter resource identity. Stocks, reservations, in-flight link escrow and delivered-on-site resources must be distinct custody states.
- Full Manual: the human selects cyst type, UMU specialization and Obelisk storage policy. No silent reconfiguration.
- Semi-Auto: a bounded warehouse/logistics manager proposes rebinding, zoning or routing only within explicit budgets and permissions.
- Full Auto: economic doctrine may design and operate storage sidings but must respect scarce material, construction cost, legal location and manual overrides.
- Neither +1 logistics temperature nor industrial doctrine creates goods or instant capacity. Storage filling/leaving the network is a gradual logistical event.
- Manual/Human-human/Bot and deterministic headless all use the same resource transfers and throughput.

## Test and balancing backlog

- **STOR-01:** ORG cyst bound to `matter` accepts Matter but rejects a Volatiles deposit; no mixed state can be committed.
- **STOR-02:** Nonempty ORG cyst cannot silently rebind to Energy; previously held Matter remains accountable and real.
- **STOR-03:** Sever ORG vein and verify cyst stock stays locally owned and isolated until physical logistics restore contact.
- **STOR-04:** MAN UMU mixed mode accepts multiple typed goods within a finite shared cap.
- **STOR-05:** Identical empty MAN UMU specialized for Matter accepts **strictly more Matter** than its mixed configuration, without generating any.
- **STOR-06:** Mixed→specialized MAN UMU with incompatible goods requires an actual authorized unload, not free deletion.
- **STOR-07:** UMU fortified/packed mode cannot use closed cargo ports; goods stay in their real custodian and no duplicate credits occur.
- **STOR-08:** ETH Obelisk levitated stock reflects **real mixed typed inventory**; renderer cannot generate new resource totals.
- **STOR-09:** Increasing Obelisk stock reduces its effective through-cargo service rate (same mode, same graph and edge conditions).
- **STOR-10:** The Obelisk mainline plus storage siding sustains higher through-traffic than loading the mainline with the same quantity when alternative path capacities allow it.
- **STOR-11:** Protected backbone Obelisks remain eligible to stay empty; opt-in equalization does not force-fill them.
- **STOR-12:** A stock-full ETH storage-relay Obelisk still permits eventual progress/drain using positive service floor (candidate) rather than deadlocking forever.
- **STOR-13:** An Obelisk lost in a graph cut or destruction does not duplicate stored stock or unit-in-transit payload.
- **STOR-14:** Optional unit relay is delayed according to its specifically configured shared traffic policy, never given infinite instant priority.
- **STOR-15:** UI uses **Obelisk** in every new ETH name, tooltip, asset and user-facing message; existing `eth_mid_pylon` save/serialization identifiers remain compatible until deliberate migration.
- **STOR-16:** At matched physical resource access and cost conditions, all three faction storage approaches create understandable, counterplay-rich bottlenecks, not magic money or hidden stat multipliers.

## Implementation gates

**Do not implement DEC-036 in MVP0.** Finish DEC-033 native Godot MAN mirror + H-H/H-C/C-C first. Later build physical multi-resource stock/ledger; ORG cyst segregation; MAN UMU mixed/specialized capacity; ETH Obelisk visible local mixed storage plus fill-related throughput and storage-siding routing. Only after that integrate ETH unit relay (DEC-035) with the finalized shared traffic model and deterministic interruption behavior.
