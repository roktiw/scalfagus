# Scalfagus MVP 0.1 — MAN Mirror RTS Execution Contract

Date: 2026-10-11
Status: **Godot implementation instructions and unapproved numeric candidates; not code complete**.
**Controlling owner decision: DEC-033**. This file is CURRENT MVP release guidance; broader MAN-vs-ETH, UMU, Energy, FPP and previous `MVP-DELIVERY-GATES.md` plans are **POST-MVP** and must not block the initial playable build.
Required reading: [current MVP scope](mvp0-man-mirror-rts-2026-10-11.md), [release YAML](mvp0-man-mirror-rts.yaml), [current selected numeric implementation contract](mvp0-agent-implementation-contract.yaml), [alternative analytical scenario, not active](mvp0-man-mirror-balance-v0.1.yaml), [network protocol](mvp0-man-mirror-network.yaml), [acceptance](mvp0-man-mirror-acceptance.yaml), [Godot headless lab](godot-headless-balance-lab-2026-10-11.md), [required flying platform](space-platform-world-contract-2026-10-11.md).

## 1. Locked release scope versus legacy engine spike

Two player slots with **the same MAN faction**. Controller combinations **Human–Human over two native Godot LAN/loopback clients**, **Human–Computer**, and **Computer–Computer** with live GUI observer or accelerated Godot headless mode. The shipped UI contains **Overlord RTS only**. Existing prototype F1 RTS, F2 TPP, F3 FPS may be retained as debug coverage until two-view product migration, but **do not advertise FPP/TPP or add Hero requirements to MVP0**. The later product target is Overlord+FPP (DEC-031), not three cameras.

Exactly FOUR producible/counted templates: `man_command_core` (HQ), `man_min` (worker), `man_barracks` (troop factory), `man_rifleman` (ground soldier). No UMU, Pylon, ETH, ORG, support cap, spendable Energy, advanced transformation tree, recycling supply loop or liquid/gas processing in 0.1. **Matter only**. The richer suite written for two races remains useful for later expansion; it is not a mandatory step now.

A single authored Verdant Divide jungle flying space platform 64×64 candidate, brown ground/trees/water and no void escape, with an actual rim/underside and noninteractive stars/planet. Trees block ground movement and projectiles; leaves are visual only. Pond surface is impassable to all MVP0 workers/riflemen and cannot be gathered.

## 2. GameState, player slots and authoritative commands

In Godot native, own one authoritative `GameSession` with two `PlayerSlot` records. Each has `slot_id, controller_kind, peer_binding, team_id, owned_entity_ids, known_fog`. H-H/H-C/C-C differ **ONLY** by command controller inputs, not by simulation rules or costs. Bot calls the same `submit_command()` as player.

Pure-ish GDScript simulation API (proposed):
```gdscript
# GDScript-like interface, not existing checked-in implementation
func new_match(config: Dictionary, map_data: Dictionary, seed: int) -> GameState
func observe_for_slot(state: GameState, slot: int) -> Dictionary
func validate_command(state: GameState, slot: int, command: Dictionary) -> String
func queue_command(state: GameState, slot: int, command: Dictionary) -> Dictionary
func advance_one_tick(state: GameState) -> Array[Dictionary]
func snapshot(state: GameState) -> Dictionary
func canonical_state_hash(state: GameState) -> String
```
Typed implementations should use appropriate Godot objects as needed; the published contract is about **single authority and serializable behavior**, not exact class spelling. The GUI, C-C lab and LAN host must reuse this one core. No separate fake text simulation engine.

At the proposed 20 Hz runtime cadence, event ordering is deterministic by `tick, slot_id, per_slot_sequence`. Reject wrong owner/unknown entity, invalid target, stale or duplicate sequence, blocked ground, unseen unit, insufficient deposited Matter, illegal placement, wrong producer and already-ended match. Errors are returned with stable reason codes, not silently ignored.

## 3. Physical SOLID → Matter delivery (only economic chain)

Each start has HQ, 3 MIN and 400 finite nearby SOLID inventory on symmetric authored positions. Source form SOLID is available directly without a mining rig, and one depleted source unit yields one Matter for this test map. A worker can carry up to **10 Matter**, gathering one in **2.0 seconds** (20 Hz: 40 ticks) on uninterrupted source. Movement is **2.3 tiles/s** in the current agent implementation candidate (2.4 tiles/s in the separate alternative analysis) (world tiles may be 2 m; consistent conversion). At HQ delivery, atomically subtract from actual carried packet and add to **that player's HQ Matter inventory** — no global wallet before arrival and no cross-player credit.

A source is finite, and when empty cannot spawn a replacement for free. Living cover trees are not economic deposits. If an armed opponent kills a worker carrying Matter, the cargo must leave the worker custody exactly once: MVP0 may choose explicit irrecoverable loss (simplest) OR a ground MAN cube without an accessible salvage action (pure visual unless future pickup is enabled); never return it to HQ automatically or allow duplicated physical world credit. Stronger physical salvage belongs to later multi-faction release.

The example at 8 tiles one-way with full 10-capacity trip takes approximately **27.66 seconds** at 2.3 tiles/s and 0.70 seconds handling, yielding **~21.69 Matter/min per worker**, or **~65.09/min for three**; the separate 2.4tiles/s /0.5seconds scenario yields 27.17s/66.3min in an ideal no-contention case. This is a theoretical fixture only; map route/queue speed can differ, so the agent must test actual movement.

## 4. Buildings, production, population and progress

- `man_command_core`: 1200 HP, 0 cost at start, 600 Matter store, trains one MIN in a 7-second FIFO slot for 35 Matter. **Rebuilding the HQ is disabled in MVP0**; if the remaining Barracks is destroyed the team loses. Only completed HQ/Barracks count as `victory_building`.
- `man_min`: 50 HP, physical gathering and Barracks construction. Workers cannot shoot in 0.1 and have no support cost; there is no supply system to implement.
- `man_barracks`: 650 HP, build cost 100 Matter from the player's actual HQ store, one worker actively builds it over **18 game seconds**. A legal site requires dry, flat, collision-free footprint; initial candidate allows it within the **current agent candidate radius of 9 ground tiles** of HQ (subject to exact path vs Manhattan rule) and with an actual worker route. A worker leaving **pauses** work; structure remains incomplete and is **not** a victory building. No UMU, cable, power plant, personal material hauling to site or third resource prerequisite.
- `man_rifleman`: 100 HP, 50 Matter, one FIFO production slot, 9 seconds to train, moves on ground and fires basic ranged 8 raw damage every 1s (20 fixed ticks), effective attack range **6.5 world metres (3.25 grid tiles at 2 m/tile)**; blocks shot through tree trunks and buildings. Attacks other units or completed HQ/Barracks, not scenery.

For materials, distinguish worker delivery to HQ from construction payment: in MVP0 Barracks costs are debited from the **owned HQ actual inventory at worksite creation**, not automatically carried through an unimplemented universal transporter network. The 18-tile build-radius limit is a scoped simplifying rule for legal local construction. **Do not implement global Matter credit or remote expansion** under this shortcut. On cancellation after site creation, initial candidate no Matter refund (book as spent/loss), pending explicit later salvage rules. Queue cancellation before spawn may return reserved Matter to the **same HQ** once; define transaction IDs. Colliding spawn waits for a free dry cell and must not pay twice.

For any agent: if it cannot implement one Barracks legitimately before exhausting initial 400 Matter, the prototype is invalid. Starter safe 400 can pay a Barracks plus six Riflemen or a Barracks plus three Riflemen and three additional Workers. Distinct commanders/spawns both get same costs.

## 5. Attack, fog, victory and timeout

Combat tick applies one damage event per legal shot; cooldown is fixed tick, obey 3D raycast and actual 6.5m range, and only currently visible/LOS target IDs are valid. No remote targeting through unexplored fog. No instant damage to neutral platform rim/underside/background. No forced friendly fire.

**Victory at end-of-tick:** zero remaining alive *completed* opponent HQ/Barracks means opponent eliminated; workers and soldiers left cannot save them. Destroyed walls/tree props/resources are not buildings; there are no UMU building-units in the release. If both sides lose their last completed building in the same tick, record `draw_simultaneous_elimination`. A candidate **20 game-minute test cap** yields `draw_timeout` (never a fabricated winner) if unresolved. Never mark resource exhaustion alone as victory.

No default unlimited repair or replacement HQ. A softlocked surviving Barracks with no production can still be destroyed; the 20-minute draw timer is a temporary micro-MVP match test cap, not the ultimate product victory doctrine.

## 6. Three controller combinations and fair bot

- **H-C:** human owns slot 0 or 1; local bot receives fog-filtered observations and issues same paid gather/build/train/attack commands. With valid orders, bot must eventually build a Barracks, train at least three Riflemen, scout and attack a legal target.
- **C-C:** same bot adapters run both slots; in GUI Watch mode camera is a **read-only omniscient observer** with no third command-owning slot, while accelerated Headless runs exact same core without waits or rendering. Record seed/rules/profile hash per match and run side-swapped mirrored start pairs.
- **H-H:** two separate Godot clients over LAN/loopback, exactly one authoritative host. One client sends serialized orders; the host validates bound slot identity and publishes **visibility-filtered authoritative states**, not a stream of all hidden entities to human observers. No split screen, public matchmaking, cloud account service or host migration needed.

Avoid race-condition softlocks: if the other client disconnects, abort with an explicit code and leave a UI path back to menu. The match winner is never arbitrarily awarded just because a peer left. Duplicate/malicious orders must be idempotently rejected; host must never accept client-supplied Matter/HP.

## 7. Testable serialization and network basics

Read [mvp0-man-mirror-network.yaml](mvp0-man-mirror-network.yaml) for sample packet/event fields and authority rules. First implementation may use `ENetMultiplayerPeer` and a Godot-side serializable RPC layer, but **do not** create a duplicate Tauri/Node LAN server. One host simulation supports bots and humans.

Candidate packet format:
```json
{
  "protocol_version": 1,
  "match_id": "verdant_divide_357",
  "slot_id": 1,
  "sequence": 82,
  "requested_tick": 110,
  "intent": "move",
  "actor_ids": ["p1_man_min_003"],
  "target_cell": [14, 20]
}
```
The host derives the *authenticated bound slot* from the actual ENet peer association; the client `slot_id` is **not** an authority proof. Broadcast structured `command_rejected` reasons and bounded snapshots/deltas with fog filtering. Replays record **accepted commands** in canonical order, not arbitrary client-sent invalid inputs.

## 8. Concrete code delivery sequence

| Step | Godot-owned implementation | Pass condition |
|---|---|---|
| M0-00 | Preserve existing menu/test scene and debug 3-camera spike behind non-release mode | Existing Godot import + smoke/menu test still pass |
| M0-01 | Compile floating platform map, GameState, exact two slots, stable entity IDs, fixed tick | Both starts valid/dry; four hard boundaries; 2 HQ, 6 MIN |
| M0-02 | RTS select/move/gather, finite source/carry/HQ Matter | Three-worker real delivery produces income, no duplication |
| M0-03 | Barracks construction and train workers/riflemen | HQ balance debited once; new units spawn legally |
| M0-04 | Fog/LOS, infantry hits/building HP, win + draw timeout | Legitimate complete match without any bot |
| M0-05 | Fair scripted bot, H-C and C-C | Bot can play full game and can also lose |
| M0-06 | Unpaced Godot headless batch with JSONL and replays | Same accepted commands/hash as normal Godot mode |
| M0-07 | Godot ENet authoritative host+join LAN | Two separate human clients finish same match, client cheats rejected |
| M0-08 | Main menu H-H/H-C/C-C, RTS controls/HUD, spectator/read-only overlay | No production FPP/TPP requirement, all controller combos work |
| M0-09 | Full CI/regression, mirrored spawn fairness and playtests | `M0-01...M0-20` acceptance converted into executable tests and actual run logs |

**Do not mark any of M0-00 to M0-09 complete just because the design YAML exists.** The engine must execute its accepted commands and the real test runner must pass.

## 9. Later-release compatibility

Keep stable faction `man`, entity IDs, finite packet ledger, GameState tick and map compiler capable of expansion. The current broader MAN–ETH numeric profile, network protocol and two-perspective Overlord+FPP work remain valid **future experiments**. Do not silently import costs from `mvp-balance-playtest-v0.1.yaml` (worker15/soldier20/Energy) into MVP0 (worker35/soldier50/Matter-only); they are intentionally distinct rule profiles.
