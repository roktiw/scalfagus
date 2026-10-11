# Scalfagus — Command Autonomy, Managers and Civilization Doctrines

**Date:** 2026-10-11  
**Status:** owner-directed product vision; implementation and numerical balance are proposals, not shipped behavior.  
**Machine-readable contract:** [command-autonomy-modes.yaml](command-autonomy-modes.yaml).  
**Release authority:** DEC-033 / [current MAN mirror RTS scope](mvp0-man-mirror-rts.yaml) still takes precedence for MVP 0.1.

## Core thesis

**The player always controls how much of the civilization is self-governing.** Scalfagus combines the command precision of StarCraft, the autonomous activity of Dungeon Keeper / Dwarf Fortress, Factorio-style physical production and logistics, and (later) direct Dungeon Keeper-style possession. No separate worlds or rulebooks: a single authoritative simulation serves every mode.

Three selectable control modes form a continuum. They can be switched **during a running match, including under attack**, without resetting or duplicating units, cargo, inventories, orders, buildings, queues or the resource ledger:

| Mode | Player specifies | Units / managers decide | Default strategic freedom |
| --- | --- | --- | --- |
| **FULL MANUAL** (classic RTS) | Every significant order to units/buildings | Path following, legal attack response and other low-level reactions inside orders | None; no unsolicited expansion or spending |
| **SEMI-AUTO** (managed groups) | Assign units/buildings to named groups; choose group manager, objective, territory, doctrine, budgets | Manager allocates workers and soldiers, schedules allowed production/repairs, coordinates local jobs | Bounded to explicit group mandate |
| **FULL AUTO** (civilization doctrine) | Select civilization doctrine/preset, constraints, strategic objectives and global limits | System of delegated managers allocates subordinate tasks and reacts to changes while player observes or intervenes | Broad **but explicitly delegated**, not unlimited |

**Manual is always available as an immediate override in every mode.** Full auto is *not* a second opponent bot secretly playing under the player. It acts for the player within chosen authority, and can be stopped at any moment.

### Modes and temperature are orthogonal

Mode answers **who is allowed to initiate and coordinate tasks**. A temperature slider answers **which approved tasks are preferred**. Doctrine preset answers **what the current high-level priority is**. Budget and rules answer **whether the task is permitted and affordable**.

Setting military temperature +1 while in FULL MANUAL does **not** enable autonomous attacks. Selecting FULL AUTO with a defensive doctrine does **not** grant permission to capture distant territory. A unit can still obey a direct guard order even if an inherited offensive preference is +1.

## 1. Explicit unit / building orders remain first-class

Classic RTS orders: select, move, stop, hold, guard, patrol, gather, deliver, build, repair (when available), train, attack, escort, set rally point, cancel. The shipped MVP0 command set remains the smaller DEC-033 subset.

A direct command temporarily preempts group and civilization automation for its target entity or explicit selection set. The actor continues necessary legal local tactics and navigation, but must not silently replace the player's objective. Two particularly important semantics:

- **STOP**: cancel current active task; latch explicit held-idle until new manual order or deliberate 'resume autonomy'. Do not immediately auto-assign a new job on the next tick.
- **HOLD POSITION**: keep position and perform only permitted defensive reactions. No unauthorized chase, including with offensive doctrine +1.
- **Order completion**: if the entity is still part of an autonomous scope, it may resume inherited policy only if the order explicitly allows *resume on completion*. Otherwise remain held / request instruction. A visible HUD state prevents ambiguity.

Unit state, authority, inventory, HP and cooldowns remain the same across modes. Future FPP possession directly controls the *same* entity; when released it can resume its preceding legal objective.

## 2. Managed groups: the middle layer

A **manager** is initially a logical controller, not a new physical soldier, paid structure or map entity. Do not introduce a unit type just to implement management. A group may contain workers, Riflemen and buildings; dynamic membership is allowed but cannot make one unit obey conflicting active managers. Group types: extraction crew, logistics team, defense garrison, production cell, reconstruction task force and expansion party.

Each manager has a written mandate:
- scope: owner/team, explicit member IDs, assigned sector/area and duration;
- objective: e.g. 'protect northern bridge', 'keep Matter delivered', 'repair these two structures';
- permissions: legal action types, target classes, pursuit / scouting boundary and build blueprint;
- limits: Matter allowance/reserve, maximum training/construction commitments, risk ceiling and task capacity;
- command precedence: human orders always win; group manager can coordinate only its available members;
- reporting: current objective, task claims, blocked reason, Matter committed and suggested next action.

Managers may place approved tasks on a shared job board, reserve limited slots and avoid duplicate assignments; every proposed action passes the same host CommandGateway, visibility, permission and ledger checks as a player's order.

Manager tasks are not magically completed. Workers must carry and deliver real Matter to an owned HQ; construction, training, LOS, movement, HP and victory constraints remain unchanged.

## 3. Doctrine temperature — three-state controls

Each axis is **-1, 0, +1**: respectively conservative, balanced and proactive. These are **behavioral preferences, never buffs** to harvesting, damage, economy, fog, navigation or CPU reaction rate.

| Axis | -1 | 0 | +1 |
| --- | --- | --- | --- |
| **Construction** | Save; authorized critical repair only | Maintain approved infrastructure | Prioritize approved build plans |
| **Extraction** | Safe essential extraction | Match current real demand | Maximize legal safe throughput |
| **Warfare** | Defend, no unsolicited pursuit | Guard, patrol, local engagement | Proactive *authorized* pressure |
| **Logistics** | Essential low-risk deliveries | Normal transport | Prioritize allowed throughput |
| **Recon** | No unsolicited scouting | Limited safe patrol | Active exploration within approved area |
| **Repair/recovery** | Critical salvage only | Normal repairs | Prioritize restoration of authorized assets |
| **Expansion preparation** | Consolidate current sector | Prepare when ordered | Prioritize scouting, stockpiles and approved staging |

Candidate UI complexity levels: **3 basic axes** (construction, extraction, warfare), **5 standard axes** (+ logistics, recon), **7 advanced axes** (+ repair, expansion preparation). 3/5/7 are *interface-depth candidates*, not 357 distinct hard-coded strategies and not permission to begin full-auto features in MVP0.

Policy inheritance: civilization → sector → manager/group → building/unit. The nearest **explicit** override wins; *inherit* must be separate from setting explicit **0**, which overrides an upstream +/-1. Prefer showing the effective value and its source.

A higher temperature lowers the threshold for choosing a legal action and changes prioritization. It does not override the legal-action filter. Units can correctly idle if no beneficial/authorized action exists. Hysteresis, minimum task duration and failure cooldown prevent jitter.

## 4. Doctrine presets and instant switching

**Doctrine is a strategic preset, not merely an AI 'aggression' knob.** Players can switch presets manually at any time, without changing the underlying units or leaving RTS.

| Preset | Intent | Example priorities (candidates, NOT final balance) |
| --- | --- | --- |
| **War** | Repel threat or execute explicitly sanctioned attack | warfare +1, logistics +1, extraction 0, construction -1, recon 0, repair 0, expansion prep -1 |
| **Industrial** | Build productive capacity | construction +1, extraction +1, logistics +1, warfare -1, repair 0, expansion prep 0 |
| **Reconstruction** | Recover after an attack | repair +1, logistics +1, construction 0, warfare -1, extraction +1, expansion prep -1 |
| **Expansion preparation** | Accumulate supplies and ready staging areas | expansion prep +1, recon +1, extraction +1, logistics +1, warfare 0, construction 0 |
| **Defensive readiness** | Hold strategic structures and protect supply | warfare -1, repair +1, logistics +1, recon 0, construction -1 |
| **Balanced** | Sustain the current base | all axes 0 |

Preset selection applies a new **desired policy**, never a direct irreversible world mutation. The current jobs, orders, queue charges and already-committed resources are reconciled at the next authoritative fixed-tick boundary.

**Emergency example:** a civilization running industrial FULL AUTO is attacked. The player hits **Take Control → FULL MANUAL**, individually controls the decisive Riflemen, and optionally applies the **War** doctrine as a saved policy for later reactivation. The AI stops issuing *new* autonomous strategic orders immediately at the next tick, but existing human orders, units, in-progress lawful construction, physical Matter and combat state persist. After the battle, the player selects **Reconstruction → SEMI-AUTO** for a repair team, then **Industrial → FULL AUTO** when safe. All state is continuous.

Preset switches should not destroy the previous custom configuration; provide previous/custom slot and an undoable policy history. The game may *recommend* switching to War when attacked but must not change civilization doctrine without permission. An eventual 'automatic doctrine transitions' toggle is an explicit advanced authorization with guardrails, hysteresis and cooldown; never an implicit consequence of full-auto mode.

### Hot handover: key safety rule

There are two different actions:
1. **Disable new autonomy decisions**: immediate at next authoritative simulation tick; suspend or revoke manager-issued proposals and **future** auto-spending. Already accepted operations follow ordinary game rules, not a silent rollback.
2. **Issue STOP/CANCEL** to selected actors/buildings: an explicit further order; pays any ordinary refund/transition consequences according to game laws. Do not conflate these actions or cancel production for free.

On reactivation, reconcile jobs against current world state, revalidate all reservations and permissions; never replay stale manager commands, re-spend reserved Matter or resurrect destroyed targets. The player should be able to see why an agent has stopped.

## 5. Decision system and explainability

Recommended simple, deterministic **rule/utility AI**, not realtime LLM agents:
1. Gather observed data filtered by faction fog and real world state.
2. Enumerate unit capability-legal actions; reject anything blocked by control mode, current human order, delegated authority, spatial boundary, funds, task slots, target visibility or game laws.
3. Rank legal candidates by need, urgency and doctrine preference versus travel, danger, Matter and task-switch penalties.
4. Assign only bounded legal tasks through a shared board / one validated command path.
5. Keep a job until completed, explicitly interrupted, invalidated, or clearly surpassed; otherwise idle.
6. Expose each decision as a concise 'why': `Guarding bridge (manual)`, `Repair blocked: budget 0`, `Extraction idle: no reachable known SOLID`.

One authoritative GameState for GUI, LAN and headless simulations. Deterministic step order, seed, policy revision/epoch and stable tie breaking; no direct client world mutation. One actor has at most one active controller and one accepted instruction stream. No extra resources, aim bonuses, omniscient scouting or privileged action frequencies in automatic modes.

## 6. Balance: autonomy must support—not replace—skill

- **FULL MANUAL** must remain competitive and fully playable; automation is opt-in.
- **SEMI-AUTO** should save repetitive logistics and coordination clicks while leaving strategic goals to humans.
- **FULL AUTO** is a valid alternate experience; it can advance without input *only when explicitly enabled and given permissions*, and a good micromanaging player can still outperform default tactical AI.
- **All +1** can compete for scarce Matter and increase exposure; it must not be an always-optimal setting. Negative temperatures may protect reserves but slow growth.
- Absent valid work, an idle unit is correct. A 'helpful' but unauthorized expenditure, retreat or target chase is a **bug**.

Track accepted/rejected decisions, human order preemption latency, idle causes, resource spending by authority, task churn, number of manual clicks/actions, income per minute, tactical losses, doctrine switches, handover latency and replay hashes. Compare manual, semi and full modes with identical map/seed, identical legal physics and side swaps—not just subjective 'AI looks alive'.

## 7. Implementation phases and gates

1. **MVP0 unchanged (DEC-033):** complete authoritative MAN mirror RTS, correct map/timebase/economy, H-H LAN, H-C, C-C and executable smoke/batch validation. Do not add doctrine sliders to this release.
2. **Autonomy foundation:** explicit Stop/Hold/resume semantics, actor order state, local idle/job selection, legal guard and worker task loops.
3. **SEMI-AUTO:** logical managers for groups of units/buildings; scoped task board, budgets, permissions, group UI, manual overrides, tests.
4. **Doctrine control:** 3/5/7 visible axes, hierarchy and override/inherit semantics, War/Industrial/Reconstruction/Expansion Preparation/Balanced presets, explainability and hot-switch tests.
5. **FULL AUTO:** civilization manager delegates within approved authority, simulation runs without repeated clicks, opt-in adaptive presets, richer economy and later MAN/ETH/ORG.
6. **Future FPP:** possession of a real entity with same state and legal return to AI; no parallel pawn spawned.

## 8. Acceptance scenarios for implementation agents

The YAML companion names **AUTO-01 through AUTO-18** with testable scenarios. Critical handover cases:
- Full Auto Industrial → FULL MANUAL during attack stops new autonomous strategic orders **at the next authoritative tick**, without wiping unit HP, inventory, accepted queues or building progress.
- Selecting War in FULL MANUAL changes stored doctrine but **does not authorize spontaneous attacks**.
- Semi-Auto group manager can schedule paid work only inside its permitted region/blueprint and budget; never double-spends on the same Matter.
- Explicit Stop latches idle even with +1 global extraction.
- One building can participate in a manager's production group without becoming another actor or creating a conflicting controller.
- Reconstruction with no money or no valid site produces a visible blocked reason rather than a loop of invalid commands.
- Return from FPP (future) retains exact unit identity, equipment, HP and any still-legal objective.

**Decision to preserve:** The player's freedom to shift **Full Manual ↔ Semi-Auto ↔ Full Auto** is itself a core Scalfagus game mechanic. Military, industrial, rebuilding and expansion-preparation doctrines are selectable *during combat and recovery*, not separate game modes requiring a restart.
