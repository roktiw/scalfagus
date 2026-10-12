# Scalfagus MVP0 — authoritative command gateway, first LAN gate

Date: 2026-10-12. **Code implemented on an untested feature PR**; this is the
network trust boundary and local RTS integration, **not a finished H-H LAN game**.

## Why this was next

The owner-approved MVP0 scope in `design/mvp0-man-mirror-rts.yaml` has
three controller combinations: H-C, C-C and **H-H using two native Godot
LAN/loopback processes**. H-C/C-C, physical Matter, fixed 20Hz timing,
Verdant and 3D LOS *diagnostics* already existed and were successfully
headless-tested on macOS in QA PR #17 (baseline `948e67a...`).
The remaining P0 blockers are **M0-07, CODE-GAP-08 and CODE-GAP-09**:
a host-authoritative network transport and *peer-bound command
validation*. This increment addresses the latter and prepares the former.

## Source changes

`apps/game/scripts/mirror_command_gateway.gd` implements:

- A versioned **primitive-only order envelope**, with exactly these
  seven client fields: `protocol_version`, `match_id`, `sequence`,
  `requested_tick`, `action`, `actor_id`, `target`.
  World cells are integer pairs `[x,y]`, source IDs strings, target
  entity IDs integers; no HP/Matter/client-owned slot/state fields.
- **Authenticated connection source** is the caller-provided
  `peer_id` (future ENet integration must supply
  `multiplayer.get_remote_sender_id()` on the server). Host peer 1
  owns slot 0; one distinct joined peer owns slot 1. An envelope
  cannot claim or change its slot.
- Protocol version and match-id matching, fail-closed payload shape
  and size, per-peer monotonically increasing sequences, duplicate /
  reordering / future/stale request rejection, tick-window throttle
  at 40 validated orders/20 sim ticks.
- **Queue by accepted host tick, authorized slot, sequence**;
  `flush_tick()` alone invokes existing
  `MirrorMatchState.issue_command()`. Server's state still decides
  costs, fog legality, pathing, owners and production; no fork of
  gameplay rules. Each applied order has a positive/negative result
  and accepted-only event record for future replay/ENet ACK.
- `observe_for_slot()` emits a **fog-filtered, serializable snapshot**,
  containing only own full unit orders and queues, currently visible
  enemy records, visible source stocks, and the caller's own HQ Matter.
  Hidden enemy IDs are also scrubbed from *friendly unit target metadata*.
  Guessing a missing or hidden enemy ID produces the same rejection.
- Peer disconnect clears its binding and **all outstanding orders**,
  preventing stale queued orders on reconnect.

`apps/game/scripts/mirror_view.gd` now submits local player
orders (move/attack/gather/build/train) through the **same**
gateway interface. Local commands are synchronously committed for
legacy game/UI smoke compatibility. When ENet H-H is connected,
the server must instead call `flush_tick()` immediately before each
single authoritative `sim.advance()` so that both network peers'
commands are canonically sorted. `MirrorMatchState` remains the only
gameplay authority. Bots currently still call `issue_command` in
their own authoritative `_bot_tick`; a later increment must route
bots through the same host acceptance layer before claiming one
interface for all three controllers.

## Test coverage

`apps/game/tests/mirror_gateway_smoke.gd` is run by
`scripts/check.sh` and validates:
- host/remote binding, no third slot or client spoof;
- unknown peer / opponent actor / forged slot / invalid protocol /
  future tick / out-of-order and duplicate sequences;
- rejected packets do not mutate match or resource state;
- reversed network arrival yields stable host slot 0 → slot 1
  command execution;
- fog-filtered snapshots hide enemy HQ, other team's Matter,
  distant resource stock and friendly target references to hidden IDs;
- no queued commands after unbind;
- 40 orders/sec throttle, with overrun rejected;
- shared user-facing group orders and Keychain hotkeys now explicitly
  assert accepted entries in the gateway.

## Limitations & acceptance status

**Not implemented in this PR:** `ENetMultiplayerPeer` host/join;
server RPC wired to the trusted sender ID; 2-process start lobby;
snapshot/delta transport; LAN timeout/disconnect UI; client HUD and
fog-safe visual state. Accordingly, M0-13/14/15 are **NOT VERIFIED** as
two-process LAN tests. They must not be marked PASS until actual Mac
host/client loopback playtesting. No real Godot tests could run in
this tool environment. No GUI replay, packaging, export template or
Keychain restart evidence has changed.

Local verification after checking out the feature branch:

```sh
git fetch origin
git switch feat/mvp0-authoritative-command-gateway-20261012
bash scripts/check.sh
bash scripts/check-gut.sh
bash scripts/check-map.sh
# manual H-C: click/drag -> group order, Keychain W/T, gather, build, train
```

QA findings from PR #17 remain valuable, but **its PASS results
covered earlier SHA 948e67a, not this branch**. Keep this change
draft until the above commands and UI pass against its final SHA.

Reuse First (DEC-034): Godot dictionaries, `Variant`, typed GDScript,
built-in JSON serialization, existing `MirrorMatchState`; no new
transport, identity, queueing, cryptography or pathfinding dependency.
