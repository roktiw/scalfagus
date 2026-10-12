extends SceneTree

# M0-14 / CODE-GAP-09. Pure host command-contract regression; no sockets.
# The next ENet adapter must supply authenticated multiplayer sender IDs.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const GATEWAY = preload("res://scripts/mirror_command_gateway.gd")

func _initialize() -> void:
    call_deferred("_test")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_MIRROR_GATEWAY_FAIL: " + message)
    quit(1)

func _check_reject(ack: Dictionary, reason: String) -> bool:
    return not bool(ack.get("accepted", true)) and str(ack.get("reason_code", "")) == reason

func _test() -> void:
    var state = MATCH.new()
    state.setup(42, ["human", "human"])
    var gate = GATEWAY.new()
    if not gate.configure(state, "mirror-42"):
        _fail("Gateway failed to configure canonical state")
        return
    if gate.bind_peer(4, 0) or gate.bind_peer(1, 1):
        _fail("Remote peer could impersonate host or host could take remote slot")
        return
    if not gate.bind_peer(1, 0) or not gate.bind_peer(9, 1):
        _fail("Two distinct authorized peer bindings failed")
        return
    if gate.bind_peer(10, 1) or gate.bind_peer(9, 0):
        _fail("Third client or extra slot takeover was accepted")
        return
    var worker0: int = state.units_for(0, "worker")[0]
    var worker1: int = state.units_for(1, "worker")[0]
    var envelope: Dictionary = GATEWAY.encode_order("mirror-42", 1, 0, "stop", worker0)
    var baseline_hash: String = state.replay_hash()
    if not _check_reject(gate.submit_from_peer(20, envelope), "unknown_peer"):
        _fail("Unbound attacker reached state")
        return
    var spoof: Dictionary = envelope.duplicate()
    spoof["slot_id"] = 1
    if not _check_reject(gate.submit_from_peer(1, spoof), "malformed_command"):
        _fail("Client-provided slot impersonation was not fail-closed")
        return
    if not _check_reject(gate.submit_from_peer(9, envelope), "not_owner"):
        _fail("Enemy order did not reject ownership spoof")
        return
    var broken: Dictionary = envelope.duplicate()
    broken["actor_id"] = worker1
    if not _check_reject(gate.submit_from_peer(1, broken), "not_owner"):
        _fail("Host submitted opponent unit")
        return
    broken = envelope.duplicate()
    broken["protocol_version"] = 100
    if not _check_reject(gate.submit_from_peer(1, broken), "invalid_protocol_version"):
        _fail("Unknown wire protocol accepted")
        return
    broken = envelope.duplicate()
    broken["requested_tick"] = 30
    if not _check_reject(gate.submit_from_peer(1, broken), "requested_tick_too_far_or_stale"):
        _fail("Future-tick override accepted")
        return
    broken = envelope.duplicate()
    broken["sequence"] = 2
    if not _check_reject(gate.submit_from_peer(1, broken), "out_of_order_sequence"):
        _fail("Out-of-order command was accepted")
        return
    broken = envelope.duplicate()
    broken["target"] = [1, 2]
    if not _check_reject(gate.submit_from_peer(1, broken), "malformed_command"):
        _fail("STOP accepted an injected destination")
        return
    if baseline_hash != state.replay_hash() or not gate.pending.is_empty():
        _fail("Rejected commands mutated authority or queue")
        return

    # Deliberately reverse arrival order; host must still execute slot 0
    # before slot 1 at the same authoritative tick.
    var remote: Dictionary = GATEWAY.encode_order("mirror-42", 1, 0, "stop", worker1)
    var remote_ack: Dictionary = gate.submit_from_peer(9, remote)
    var host_ack: Dictionary = gate.submit_from_peer(1, envelope)
    if not bool(host_ack["accepted"]) or not bool(remote_ack["accepted"]):
        _fail("Valid signed-by-peer commands did not queue")
        return
    if state.replay_hash() != baseline_hash:
        _fail("Queued commands executed before fixed-tick commit")
        return
    if not _check_reject(gate.submit_from_peer(1, envelope), "duplicate_sequence"):
        _fail("Duplicate sequence was applied twice")
        return
    var result: Array[Dictionary] = gate.flush_tick()
    if result.size() != 2 or not bool(result[0]["accepted"]) or not bool(result[1]["accepted"]):
        _fail("Host did not flush exactly two legal commands")
        return
    if int(result[0]["slot_id"]) != 0 or int(result[1]["slot_id"]) != 1:
        _fail("Host event ordering depends on packet arrival order")
        return
    if gate.accepted_log.size() != 2 or gate.pending.size() != 0:
        _fail("Accepted replay log did not record both unique orders")
        return

    # Unknown actors MUST NOT appear in fog-filtered snapshots; even the
    # target_id of a friendly soldier cannot leak a hidden enemy.
    var own: Dictionary = gate.observe_for_slot(0)
    var enemy_hq: int = state.units_for(1, "hq")[0]
    for report in own["units"]:
        if int(report["id"]) == enemy_hq:
            _fail("Hidden enemy HQ leaked its ID to the client")
            return
    if own.has("players") or own.has("events") or own.has("full_state"):
        _fail("Snapshot leaked omniscient host internals")
        return
    if own["sources"].size() >= state.sources.size():
        _fail("Snapshot exposed distant untouched Matter stock")
        return
    var enemy_order: Dictionary = GATEWAY.encode_order("mirror-42", 2, 0, "attack", worker0, enemy_hq)
    if not _check_reject(gate.submit_from_peer(1, enemy_order), "target_not_currently_visible"):
        _fail("Host accepted targeting unseen enemy")
        return
    if int(gate.last_sequence[1]) != 1:
        _fail("Rejected visibility probe consumed valid command sequence")
        return

    # Enqueued commands cannot be applied after peer disconnect/rebind.
    var future: Dictionary = GATEWAY.encode_order("mirror-42", 2, state.tick + 1, "stop", worker1)
    if not bool(gate.submit_from_peer(9, future)["accepted"]):
        _fail("Future legal command not queued")
        return
    gate.unbind_peer(9)
    state.advance()
    if not gate.flush_tick().is_empty() or not gate.pending.is_empty():
        _fail("Disconnected peer retained a queued order")
        return
    if not gate.bind_peer(10, 1):
        _fail("Freed slot could not be assigned to another peer")
        return

    # Same authorized remote ID cannot exceed 40 accepted orders / 20 ticks.
    for n in range(GATEWAY.MAX_ORDERS_PER_SECOND):
        var e: Dictionary = GATEWAY.encode_order("mirror-42", n + 1, state.tick, "stop", worker1)
        if not bool(gate.submit_from_peer(10, e)["accepted"]):
            _fail("Rate limiter rejected within legal quota")
            return
    var overflow: Dictionary = GATEWAY.encode_order("mirror-42", 41, state.tick, "stop", worker1)
    if not _check_reject(gate.submit_from_peer(10, overflow), "rate_limited"):
        _fail("Unbounded peer queue allowed excessive orders")
        return
    if gate.pending.size() != GATEWAY.MAX_ORDERS_PER_SECOND:
        _fail("Rate limit allowed extra command mutation")
        return
    var accepted: Array[Dictionary] = gate.flush_tick()
    if accepted.size() != GATEWAY.MAX_ORDERS_PER_SECOND:
        _fail("Queued command count changed unexpectedly")
        return

    # Dynamic enemy secrets must not be visible due to our own order metadata.
    var soldier: int = state._spawn("rifleman", 0, Vector2i(14, 10))
    state.entities[soldier]["target_id"] = enemy_hq
    var observed: Dictionary = gate.observe_for_slot(0)
    for report in observed["units"]:
        if int(report["id"]) == soldier and int(report["target_id"]) != -1:
            _fail("Hidden enemy entity ID leaked through friendly target metadata")
            return
    if not state.matter_is_conserved():
        _fail("Network boundary mutated Matter custody")
        return
    print("SCALFAGUS_MIRROR_GATEWAY_PASS")
    quit(0)
