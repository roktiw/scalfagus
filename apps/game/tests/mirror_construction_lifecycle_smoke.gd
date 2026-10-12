extends SceneTree

# Construction lifecycle: no ghost 3x3 reservations, no double bookkeeping
# and deterministic interruption for the MVP0 single-worker Barracks.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const REPLAY = preload("res://scripts/mirror_replay_archive.gd")
const SITE = Vector2i(13, 12)

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_CONSTRUCTION_LIFECYCLE_FAIL: " + message)
    quit(1)

func _funded(seed: int, amount: int = 200) -> MirrorMatchState:
    var sim: MirrorMatchState = MATCH.new()
    sim.setup(seed, ["human", "human"])
    # Ledger-only fixture; real replay test below mines its own resources.
    sim.mined_matter = amount
    sim.players[0]["matter"] = amount
    return sim

func _start(sim: MirrorMatchState) -> int:
    var builder_id: int = sim.units_for(0, "worker")[0]
    var builder: Dictionary = sim.entities[builder_id]
    builder["pos"] = Vector2i(11, 12) # Exact legal exterior access to SITE.
    if not sim.issue_command(0, "build_barracks", builder_id, SITE):
        _fail("Canonical paid 3x3 worksite rejected")
        return -1
    if int(builder["work_ticks"]) != 360 or str(builder["order"]) != "build":
        _fail("Construction never became a reserved worker order")
        return -1
    if sim._can_build(SITE, 0) or not sim.matter_is_conserved():
        _fail("Active construction lost its reservation or Matter custody")
        return -1
    return builder_id

func _last_abandon(sim: MirrorMatchState) -> Dictionary:
    for i in range(sim.events.size() - 1, -1, -1):
        var event: Dictionary = sim.events[i]
        if str(event.get("action", "")) == "build_abandoned":
            return event
    return {}

func _assert_abandoned(sim: MirrorMatchState, reason: String, worker_id: int, expected_spent: int) -> bool:
    var event: Dictionary = _last_abandon(sim)
    if event.is_empty() or event.get("reason") != reason:
        _fail("Missing canonical construction abandonment reason: " + reason)
        return false
    if int(event.get("actor", -1)) != worker_id or event.get("site", {}).get("type", "") != "cell":
        _fail("Abandonment event lost the builder ID or typed site")
        return false
    if int(sim.spent_matter) != expected_spent or not sim.matter_is_conserved():
        _fail("Cancellation refunded or duplicated physical Matter")
        return false
    if sim.entities.has(worker_id):
        var worker: Dictionary = sim.entities[worker_id]
        if str(worker["order"]) == "build":
            _fail("Interrupted worker still holds a worksite reservation")
            return false
        if worker["build_pos"] != Vector2i(-1, -1) or int(worker["work_ticks"]) != 0:
            _fail("Interrupted worker retained stale build progress or position")
            return false
        if not worker["route"].is_empty() or int(worker["route_revision"]) != -1:
            _fail("Interrupted worker retained stale AStar route")
            return false
    if sim._reserved_site_at(SITE):
        _fail("Interrupted worksite is still blocked for a second builder")
        return false
    return true

func _verify() -> void:
    # Rejected command must not invalidate a real paid build order.
    var cancelled: MirrorMatchState = _funded(42)
    var worker: int = _start(cancelled)
    if worker < 0:
        return
    if cancelled.issue_command(0, "move", worker, Vector2i(64, 64)):
        _fail("Out-of-range move was accepted during construction")
        return
    if str(cancelled.entities[worker]["order"]) != "build" or cancelled._reserved_site_at(SITE) == false:
        _fail("Rejected command destroyed active build reservation")
        return
    if int(cancelled.spent_matter) != 100 or int(cancelled.players[0]["matter"]) != 100:
        _fail("Rejected command changed the construction ledger")
        return
    for i in range(9):
        cancelled.advance()
    var hash_before_stop: String = cancelled.replay_hash()
    if not cancelled.issue_command(0, "stop", worker):
        _fail("Worker STOP did not cancel Barracks construction")
        return
    if not _assert_abandoned(cancelled, "stop", worker, 100):
        return
    var stop_event: Dictionary = _last_abandon(cancelled)
    if int(stop_event["remaining_ticks"]) != 351 or not cancelled._can_build(SITE, 0):
        _fail("STOP did not preserve accurate unfinished progress in event or release site")
        return
    if cancelled.replay_hash() == hash_before_stop:
        _fail("Interrupted work produced the original authoritative replay hash")
        return

    # A new movement intent replaces the paid construction order atomically.
    var moved: MirrorMatchState = _funded(43)
    worker = _start(moved)
    if worker < 0:
        return
    if not moved.issue_command(0, "move", worker, Vector2i(11, 14)):
        _fail("Legal move could not override Barracks assembly")
        return
    if not _assert_abandoned(moved, "move", worker, 100):
        return
    if str(moved.entities[worker]["order"]) != "move":
        _fail("Move override left worker idle")
        return

    # Gathering must also release a worksite while retaining valid cargo.
    var gathered: MirrorMatchState = _funded(44)
    worker = _start(gathered)
    if worker < 0:
        return
    if not gathered.issue_command(0, "gather", worker, "nw_solid_1"):
        _fail("Legal gather could not interrupt a paid foundation")
        return
    if not _assert_abandoned(gathered, "gather", worker, 100):
        return
    if str(gathered.entities[worker]["order"]) != "gather":
        _fail("Gather override did not resume mining")
        return

    # Retarget to another clear, non-overlapping paid site (another 100 Matter).
    var retarget: MirrorMatchState = _funded(45, 250)
    worker = _start(retarget)
    if worker < 0:
        return
    var second: Vector2i = Vector2i(15, 8)
    if not retarget._can_build(second, 0):
        _fail("Fixture second Barracks site not clear")
        return
    if not retarget.issue_command(0, "build_barracks", worker, second):
        _fail("Retarget to a different legal worksite rejected")
        return
    if int(retarget.players[0]["matter"]) != 50 or int(retarget.spent_matter) != 200:
        _fail("Retarget did not debit exactly one more Barracks")
        return
    var retarget_event: Dictionary = _last_abandon(retarget)
    if retarget_event.get("reason", "") != "new_build_order" or retarget.entities[worker]["build_pos"] != second:
        _fail("Retarget did not close old site and open new site")
        return
    if retarget._reserved_site_at(SITE) or not retarget._reserved_site_at(second):
        _fail("Retarget did not atomically exchange old and new reservations")
        return
    if not retarget.matter_is_conserved():
        _fail("Retarget broke Matter conservation")
        return

    # Builder's death releases the incomplete reservation; no instant refund.
    var killed: MirrorMatchState = _funded(46)
    worker = _start(killed)
    if worker < 0:
        return
    killed._damage(worker, 500, 1)
    if killed.entities.has(worker):
        _fail("Destroyed builder is still alive")
        return
    if not _assert_abandoned(killed, "builder_dead", worker, 100):
        return
    if not killed._can_build(SITE, 0):
        _fail("Builder death left a ghost footprint reservation")
        return

    # Terrain appearing under a reserved site prevents phantom completion.
    var blocked: MirrorMatchState = _funded(47)
    worker = _start(blocked)
    if worker < 0:
        return
    blocked.entities[worker]["work_ticks"] = 1
    var tree_cell: Vector2i = SITE + Vector2i(1, 1)
    blocked.set_terrain_cell(tree_cell, "tree")
    blocked.advance()
    if not blocked.units_for(0, "barracks").is_empty():
        _fail("Barracks completed inside impassable terrain")
        return
    if not _assert_abandoned(blocked, "site_invalidated", worker, 100):
        return
    blocked.set_terrain_cell(tree_cell, "")
    if not blocked._can_build(SITE, 0):
        _fail("Invalidated site did not become buildable after terrain clears")
        return

    # Success also resets progress and reservation without creating an
    # abandonment event or a second debit.
    var completed: MirrorMatchState = _funded(48)
    worker = _start(completed)
    if worker < 0:
        return
    for i in range(360):
        completed.advance()
    if completed.units_for(0, "barracks").size() != 1:
        _fail("Uninterrupted 360-tick Barracks did not finish")
        return
    if not _last_abandon(completed).is_empty():
        _fail("Successful build incorrectly emitted a cancellation")
        return
    if int(completed.spent_matter) != 100 or not completed.matter_is_conserved():
        _fail("Build completion debited twice or broke conservation")
        return
    if completed.entities[worker]["build_pos"] != Vector2i(-1, -1) or int(completed.entities[worker]["work_ticks"]) != 0:
        _fail("Completed Barracks retained stale worker construction state")
        return

    # True human replay, funded ONLY through legal mining/delivery. Do not
    # grant artificial Matter to the captured test fixture.
    var replay_sim: MirrorMatchState = MATCH.new()
    replay_sim.setup(49, ["human", "human"])
    for wid in replay_sim.units_for(0, "worker"):
        var source: String = "nw_solid_2" if wid == replay_sim.units_for(0, "worker")[-1] else "nw_solid_1"
        if not replay_sim.issue_command(0, "gather", wid, source):
            _fail("Real mining fixture could not start")
            return
    var tries: int = 0
    while int(replay_sim.players[0]["matter"]) < 100 and tries < 8000:
        replay_sim.advance()
        tries += 1
    if int(replay_sim.players[0]["matter"]) < 100:
        _fail("Real mining failed to fund Barracks cancellation")
        return
    var real_builder: int = replay_sim.units_for(0, "worker")[0]
    if not replay_sim.issue_command(0, "build_barracks", real_builder, SITE):
        _fail("Real-funded Barracks could not reserve canonical site")
        return
    for i in range(14):
        replay_sim.advance()
    if not replay_sim.issue_command(0, "stop", real_builder):
        _fail("Real-funded construction stop rejected")
        return
    var archive: Dictionary = REPLAY.capture(replay_sim)
    var verified: Dictionary = REPLAY.playback(JSON.parse_string(JSON.stringify(archive)))
    if not bool(verified.get("ok", false)) or verified.get("hash") != replay_sim.replay_hash():
        _fail("Format-2 replay diverged after construction interruption: " + str(verified))
        return
    if not replay_sim.matter_is_conserved():
        _fail("Real-funded cancellation broke Matter conservation")
        return

    print("SCALFAGUS_CONSTRUCTION_LIFECYCLE_PASS")
    quit(0)
