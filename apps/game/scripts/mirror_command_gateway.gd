extends RefCounted
class_name MirrorCommandGateway

# MVP0 network boundary. Server owns peer->slot identity, serializes intent
# by (host tick, authorized slot, per-peer sequence), and only then calls
# MirrorMatchState.issue_command(). A client never sends authoritative stats.
const PROTOCOL_VERSION: int = 1
const MAX_ENVELOPE_BYTES: int = 1024
const MAX_ORDERS_PER_SECOND: int = 40
const MAX_FUTURE_TICKS: int = 2

const ACTIONS: Array[String] = [
    "stop", "move", "gather", "build_barracks",
    "train_worker", "train_rifleman", "attack"
]

var sim: MirrorMatchState
var match_id: String = ""
var peer_slots: Dictionary = {}
var slot_peers: Dictionary = {}
var last_sequence: Dictionary = {}
var rate_windows: Dictionary = {}
var pending: Array[Dictionary] = []
var accepted_log: Array[Dictionary] = []
var processed_log: Array[Dictionary] = []

func configure(state: MirrorMatchState, session_id: String) -> bool:
    if state == null or session_id.is_empty() or session_id.length() > 80:
        return false
    sim = state
    match_id = session_id
    peer_slots.clear()
    slot_peers.clear()
    last_sequence.clear()
    rate_windows.clear()
    pending.clear()
    accepted_log.clear()
    processed_log.clear()
    return true

func bind_peer(peer_id: int, slot: int) -> bool:
    # ENet host has peer ID 1; only one additional human may control slot 1.
    # No caller may impersonate local host with a remote peer ID.
    if sim == null or peer_id < 1 or slot not in [0, 1]:
        return false
    if slot == 0 and peer_id != 1:
        return false
    if slot == 1 and peer_id == 1:
        return false
    if peer_slots.has(peer_id) or slot_peers.has(slot):
        return false
    peer_slots[peer_id] = slot
    slot_peers[slot] = peer_id
    last_sequence[peer_id] = 0
    rate_windows[peer_id] = {"window": -1, "count": 0}
    return true

func unbind_peer(peer_id: int) -> void:
    if not peer_slots.has(peer_id):
        return
    var slot: int = int(peer_slots[peer_id])
    peer_slots.erase(peer_id)
    slot_peers.erase(slot)
    last_sequence.erase(peer_id)
    rate_windows.erase(peer_id)
    # Disconnect makes even already-queued orders from the peer invalid.
    var left: Array[Dictionary] = []
    for order in pending:
        if int(order["peer_id"]) != peer_id:
            left.append(order)
    pending = left

func _ack(sequence: int, slot: int, ok: bool, reason: String, resolved_tick: int) -> Dictionary:
    return {
        "protocol_version": PROTOCOL_VERSION, "match_id": match_id,
        "slot_id": slot, "sequence": sequence, "accepted": ok,
        "reason_code": reason, "resolved_tick": resolved_tick
    }

func _parse_int(value: Variant, minimum: int, maximum: int) -> bool:
    return value is int and int(value) >= minimum and int(value) <= maximum

func _decode_target(action: String, target: Variant) -> Dictionary:
    if action in ["move", "build_barracks"]:
        if not (target is Array) or target.size() != 2:
            return {"ok": false}
        if not _parse_int(target[0], 0, 63) or not _parse_int(target[1], 0, 63):
            return {"ok": false}
        return {"ok": true, "arg": Vector2i(int(target[0]), int(target[1]))}
    if action == "gather":
        if not (target is String) or target.is_empty() or target.length() > 80:
            return {"ok": false}
        return {"ok": true, "arg": target}
    if action == "attack":
        if not _parse_int(target, 1, 2147483647):
            return {"ok": false}
        return {"ok": true, "arg": target}
    if target != null:
        return {"ok": false}
    return {"ok": true, "arg": null}

func submit_from_peer(peer_id: int, envelope: Variant) -> Dictionary:
    # peer_id MUST be supplied by multiplayer.get_remote_sender_id() on host,
    # never read from the untrusted envelope or claimed slot_id.
    if sim == null:
        return _ack(-1, -1, false, "unknown_match", -1)
    if not peer_slots.has(peer_id):
        return _ack(-1, -1, false, "unknown_peer", sim.tick)
    var slot: int = int(peer_slots[peer_id])
    if sim.finished:
        return _ack(-1, slot, false, "game_over", sim.tick)
    if not (envelope is Dictionary):
        return _ack(-1, slot, false, "malformed_command", sim.tick)
    var serialized: String = JSON.stringify(envelope)
    if serialized.length() > MAX_ENVELOPE_BYTES:
        return _ack(-1, slot, false, "malformed_command", sim.tick)
    var required: Array[String] = ["protocol_version", "match_id", "sequence", "requested_tick", "action", "actor_id", "target"]
    if envelope.size() != required.size():
        return _ack(-1, slot, false, "malformed_command", sim.tick)
    for key in required:
        if not envelope.has(key):
            return _ack(-1, slot, false, "malformed_command", sim.tick)
    if not _parse_int(envelope["protocol_version"], 0, 2147483647) or int(envelope["protocol_version"]) != PROTOCOL_VERSION:
        return _ack(-1, slot, false, "invalid_protocol_version", sim.tick)
    if not (envelope["match_id"] is String) or str(envelope["match_id"]) != match_id:
        return _ack(-1, slot, false, "unknown_match", sim.tick)
    if not _parse_int(envelope["sequence"], 1, 2147483647):
        return _ack(-1, slot, false, "malformed_command", sim.tick)
    var seq: int = int(envelope["sequence"])
    if seq <= int(last_sequence[peer_id]):
        return _ack(seq, slot, false, "duplicate_sequence", sim.tick)
    if seq != int(last_sequence[peer_id]) + 1:
        return _ack(seq, slot, false, "out_of_order_sequence", sim.tick)
    if not _parse_int(envelope["requested_tick"], 0, 2147483647):
        return _ack(seq, slot, false, "malformed_command", sim.tick)
    var requested_tick: int = int(envelope["requested_tick"])
    if requested_tick < sim.tick or requested_tick > sim.tick + MAX_FUTURE_TICKS:
        return _ack(seq, slot, false, "requested_tick_too_far_or_stale", sim.tick)
    if not (envelope["action"] is String) or str(envelope["action"]) not in ACTIONS:
        return _ack(seq, slot, false, "invalid_template_or_action", sim.tick)
    if not _parse_int(envelope["actor_id"], 1, 2147483647):
        return _ack(seq, slot, false, "malformed_command", sim.tick)
    var action: String = str(envelope["action"])
    var actor_id: int = int(envelope["actor_id"])
    var decoded: Dictionary = _decode_target(action, envelope["target"])
    if not bool(decoded["ok"]):
        return _ack(seq, slot, false, "malformed_command", sim.tick)
    if not sim.entities.has(actor_id) or int(sim.entities[actor_id]["owner"]) != slot:
        return _ack(seq, slot, false, "not_owner", sim.tick)
    if action == "attack":
        var victim_id: int = int(decoded["arg"])
        if not sim.entities.has(victim_id):
            return _ack(seq, slot, false, "target_dead", sim.tick)
        var target: Dictionary = sim.entities[victim_id]
        if int(target["owner"]) == slot:
            return _ack(seq, slot, false, "not_owner", sim.tick)
        if not sim.can_see(slot, target["pos"]):
            return _ack(seq, slot, false, "target_not_currently_visible", sim.tick)
    var window: int = sim.tick / MirrorTiming.TICKS_PER_SECOND
    var limiter: Dictionary = rate_windows[peer_id]
    if int(limiter["window"]) != window:
        limiter["window"] = window
        limiter["count"] = 0
    if int(limiter["count"]) >= MAX_ORDERS_PER_SECOND:
        return _ack(seq, slot, false, "rate_limited", sim.tick)
    limiter["count"] = int(limiter["count"]) + 1
    # Sequence is consumed when a structurally valid order is admitted,
    # even if later rejected as blocked/unfunded by the game authority.
    last_sequence[peer_id] = seq
    pending.append({
        "peer_id": peer_id, "slot": slot, "sequence": seq,
        "tick": requested_tick, "action": action, "actor_id": actor_id,
        "arg": decoded["arg"]
    })
    return _ack(seq, slot, true, "queued", requested_tick)

func flush_tick() -> Array[Dictionary]:
    var replies: Array[Dictionary] = []
    if sim == null:
        return replies
    pending.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
        if int(a["tick"]) != int(b["tick"]):
            return int(a["tick"]) < int(b["tick"])
        if int(a["slot"]) != int(b["slot"]):
            return int(a["slot"]) < int(b["slot"])
        return int(a["sequence"]) < int(b["sequence"])
    )
    var future: Array[Dictionary] = []
    for order in pending:
        if int(order["tick"]) > sim.tick:
            future.append(order)
            continue
        if not peer_slots.has(int(order["peer_id"])) or int(peer_slots[int(order["peer_id"])]) != int(order["slot"]):
            continue
        var ok: bool = sim.issue_command(int(order["slot"]), str(order["action"]), int(order["actor_id"]), order["arg"])
        var reason: String = "accepted" if ok else "rejected_by_match_state"
        var ack: Dictionary = _ack(int(order["sequence"]), int(order["slot"]), ok, reason, sim.tick)
        ack["peer_id"] = int(order["peer_id"])
        replies.append(ack)
        processed_log.append({
            "tick": sim.tick, "slot": int(order["slot"]),
            "sequence": int(order["sequence"]), "accepted": ok,
            "reason_code": reason
        })
        if ok:
            # Record only accepted intents, in host-determined mutation order.
            var target: Variant = order["arg"]
            if target is Vector2i:
                target = [target.x, target.y]
            accepted_log.append({
                "tick": sim.tick, "slot": int(order["slot"]),
                "sequence": int(order["sequence"]), "action": str(order["action"]),
                "actor_id": int(order["actor_id"]), "target": target
            })
    pending = future
    return replies

func observe_for_slot(slot: int) -> Dictionary:
    if sim == null or slot not in [0, 1]:
        return {}
    var units: Array[Dictionary] = []
    for id in sim.sorted_ids():
        var e: Dictionary = sim.entities[id]
        var own: bool = int(e["owner"]) == slot
        if not own and not sim.can_see(slot, e["pos"]):
            continue
        var pos: Vector2i = e["pos"]
        var report: Dictionary = {
            "id": id, "owner": int(e["owner"]), "kind": str(e["kind"]),
            "pos": [pos.x, pos.y], "hp": int(e["hp"])
        }
        if own:
            report["order"] = str(e["order"])
            report["cargo"] = int(e["cargo"])
            report["train_kind"] = str(e["train_kind"])
            report["train_left"] = int(e["train_left"])
            var target_id: int = int(e["target_id"])
            if target_id >= 0 and sim.entities.has(target_id):
                var target: Dictionary = sim.entities[target_id]
                if int(target["owner"]) != slot and not sim.can_see(slot, target["pos"]):
                    target_id = -1
            report["target_id"] = target_id
        units.append(report)
    var known_sources: Array[Dictionary] = []
    var ids: Array = sim.sources.keys()
    ids.sort()
    for sid in ids:
        var source: Dictionary = sim.sources[sid]
        if sim.can_see(slot, source["pos"]):
            var cell: Vector2i = source["pos"]
            known_sources.append({
                "id": str(sid), "pos": [cell.x, cell.y],
                "stock": int(source["stock"])
            })
    return {
        "protocol_version": PROTOCOL_VERSION, "match_id": match_id,
        "tick": sim.tick, "map_id": sim.map_id, "map_hash": sim.map_hash,
        "slot": slot, "units": units, "sources": known_sources,
        "matter": int(sim.players[slot]["matter"]),
        "finished": sim.finished,
        "winner": sim.winner if sim.finished else -1,
        "reason": sim.finish_reason if sim.finished else ""
    }

static func encode_order(session_id: String, sequence: int, requested_tick: int,
        action: String, actor_id: int, argument: Variant = null) -> Dictionary:
    var target: Variant = argument
    if argument is Vector2i:
        target = [argument.x, argument.y]
    return {
        "protocol_version": PROTOCOL_VERSION, "match_id": session_id,
        "sequence": sequence, "requested_tick": requested_tick,
        "action": action, "actor_id": actor_id, "target": target
    }
