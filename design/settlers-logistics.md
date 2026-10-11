# Scalfagus — Settlers-Inspired Autonomous Logistics
Date: 2026-10-11
Status: design direction; implementation details are proposals.

## Vision
The Settlers (1993) and The Settlers II (1996) are primary inspirations for Architect gameplay: an observable, physically simulated economy where workers perform useful tasks autonomously. The player sets policy, designs or adjusts infrastructure, and intervenes when desired. Scalfagus extends this with AI-led base planning by default, combat, territory control and optional direct unit possession.

## Inspiration matrix
| Settlers mechanism | Scalfagus adaptation | Priority |
|---|---|---|
| Autonomous workers | MIN/MID/MAX units perform assigned jobs if equipped and authorized | 7/7 |
| Roads, flags and carriers | Physical transport links, logistics nodes, haulers and transfer points | 7/7 |
| Production chains | Matter, Volatiles and Energy feed processing, construction and equipment | 7/7 |
| Warehouses | Local inventories, depots, buffers, reserves and distribution policies | 7/7 |
| Bottlenecks | Congestion, queue length, route throughput and missing supplies | 7/7 |
| Military border expansion | Dynamic territory, outposts and contested infrastructure, also inspired by Z | 7/7 |
| Building placement | Planner evaluates path cost, safety, supply access and network synergy | 7/7 |
| Visible economy | Inspectable worker intent, delivery routes, inventories and blocked jobs | 6/7 |
| Production priorities | Human defines policy; AI schedules execution | 7/7 |

## Economy model
Only three canonical resources: Matter, Volatiles and Energy. Energy is a stored/transportable/spendable resource, not a compulsory electric grid. Lava is an energy source, not a fourth resource. Transformations, processing recipes, production rates and loss rules remain to be specified.

Every resource transfer should have an explicit source, destination, amount, carrier or permitted transfer mechanism, travel time, and inventory mutation. No invisible teleportation unless a later faction ability explicitly authorizes it and pays a cost.

### Nodes and edges (proposal)
- Nodes: extraction site, processor, factory, depot, outpost, mobile cargo unit, base core, special transfer node.
- Edges: traversable paths with distance, terrain constraints, safety, traffic and capacity.
- Inventories: finite capacities, reservations for pending orders, supply thresholds and priorities.
- Jobs: extract, collect, transfer, process, deliver, construct, repair, reclaim, patrol and defend, gated by chassis equipment and doctrine.
- Planning: allocate resources, schedule transport, choose depot location, expand routes, identify bottlenecks, protect critical flows.
- Units: MIN/MID/MAX denote chassis scale, not job or tech tier. Appropriately equipped units can transfer cargo across scales.

## Autonomous planner hierarchy
1. Strategic planner: choose economic posture, build/expand goals and resource priorities within player policy.
2. Operational planner: place buildings, queue production, assign transport and construction jobs, resolve shortages and repair disruptions.
3. Unit executor: carry out eligible jobs and doctrines; obey manual orders and ownership reservations.

This **extends** the older unit-only autonomy design. Strategic expansion is allowed only when strategic AI is enabled. In full-manual mode no planner creates buildings or expansion goals.

## Human control and visibility
- Modes: full manual; suggested actions with approval; autonomous execution; hybrid per subsystem.
- Inspect each AI decision: why this building, which prerequisite, expected benefit, risk, blocked resources.
- Allow human-defined no-build zones, protected routes, production budgets, reserves and priorities.
- Manual intervention must not be immediately reverted by AI. Use explicit locks/leases or handoff rules.
- Diagnostics: inventory map, flow overlay, throughput per route, idle units, missing inputs, delivery ETA estimates, contested routes and connectivity health.

## Faction logistics asymmetry
- **Blergians:** connected biomass infrastructure yields strong synergies; detached outposts function but weakly. Organic routes and assimilation should remain interruptible.
- **Manusians:** strongest independent outposts, modular factories and distributed depots; pay transport and defense costs.
- **Aetherians:** balanced satellites with a preference for connected resonance networks; costly but expressive transformations.
No faction receives free resources or privileged map knowledge.

## Territory, terrain and military logistics
Combine The Settlers II's logistical geography with Z's contestable territory and Earth 2150's terrain engineering. Control of a factory, bridge, chokepoint, mine, transport hub or relay changes the real economy. Elevation, obstacles, tunnels, water crossings and asteroid geography affect route feasibility, cost and exposure. Destroying a supply link should cause observable shortages; repairs or rerouting should restore flow.

## Data and system boundaries (proposed)
- Pure, deterministic economy state: resource inventories, production jobs, transport reservations and route graph.
- Planner reads a snapshot and emits valid orders, not direct state mutations.
- Order validator checks resource costs, ownership, map visibility, equipment and mode permissions.
- Simulation applies validated orders in a stable tick order.
- Renderer/UI displays state but does not own authoritative inventories or AI decisions.
- Match configuration controls base_ai, strategy_ai, worker_ai, combat_ai and possession independently.
- Save/replay records seed, resolved config, orders, relevant planner decisions and simulation version.

## Example gameplay loop
A new colony starts with a base core, workers and nearby Matter. The autonomous planner identifies extraction, builds a depot and processor, assigns equipped MIN units to harvest, dispatches MID cargo haulers, and reserves Matter for a defensive outpost. The player sees that the northern route is congested, manually adds a depot or asks AI to optimize. An enemy captures a bridge: deliveries fail, factory production slows, AI reroutes and proposes an escort. In manual mode the same systems run, but the human creates and manages the strategic orders.

## Proposed MVP implementation slices
1. Finite inventories, resource extraction and deterministic transfer.
2. One producer -> carrier -> depot -> consumer loop, with observable route.
3. Job assignment for equipped MIN/MID/MAX; interruptions and cancellation.
4. Automated bottleneck detection and an explainable economic planner.
5. Human override and full-manual mode parity.
6. Connected/disconnected base synergy by faction.
7. Territory interruption, contested transport and terrain-aware routing.

## Acceptance tests
- Resources never appear without a valid source, transformation or explicitly costed ability.
- A fixed seed and order stream produce identical simulation results.
- 20 autonomous workers sustain a functioning extraction/transport chain.
- Disconnected outposts obey faction-specific rules without becoming nonfunctional.
- Destroyed/blocked transport routes create measurable shortages.
- AI can recover from congestion or lost routes, subject to available capacity.
- Manual mode never initiates strategic construction or expansion.
- Human override remains respected until released.
- All inventory and task decisions can be inspected in headless logs.

## Open questions
Exact carrier capacities, route topology (free navigation vs roads/links), depot placement heuristics, production recipes, logistics scaling for islands/asteroids, congestion modeling, unit wear/maintenance, and whether advanced AI uses deterministic heuristics, planners or offline-trained policies.
