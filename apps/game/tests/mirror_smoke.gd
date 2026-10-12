extends SceneTree

# Self-contained checks for the first MAN mirror economy/combat loop.
const MATCH = preload("res://scripts/mirror_match_state.gd")

func _initialize() -> void:
    call_deferred("_run")

func _fail(reason: String) -> void:
    push_error("SCALFAGUS_MIRROR_FAIL: " + reason)
    quit(1)

func _run() -> void:
    var match_state = MATCH.new()
    match_state.setup(42, ["human", "human"])
    if match_state.units_for(0, "hq").size() != 1 or match_state.units_for(1, "worker").size() != 3:
        _fail("Incorrect mirrored initial roster")
        return

    # The first battlefield must be a fair, rotationally mirrored pair of starts.
    var left_hq: Vector2i = match_state.entities[match_state.units_for(0, "hq")[0]]["pos"]
    var right_hq: Vector2i = match_state.entities[match_state.units_for(1, "hq")[0]]["pos"]
    if right_hq != Vector2i(63 - left_hq.x, 63 - left_hq.y):
        _fail("Spawn locations are not rotationally mirrored")
        return
    var west_source: Vector2i = match_state.sources["nw_solid_1"]["pos"]
    var east_source: Vector2i = match_state.sources["se_solid_1"]["pos"]
    if east_source != Vector2i(63 - west_source.x, 63 - west_source.y):
        _fail("Harvest start locations are not mirrored")
        return
    if not match_state._blocked(Vector2i(21, 15)):
        _fail("Tree trunk is not impassable")
        return
    if match_state._line_clear(Vector2i(19, 15), Vector2i(23, 15)):
        _fail("Tree trunk does not block line of sight")
        return

    var west_worker: int = match_state.units_for(0, "worker")[0]
    var enemy_worker: int = match_state.units_for(1, "worker")[0]
    if match_state.issue_command(0, "move", enemy_worker, Vector2i(12, 12)):
        _fail("Human player controlled enemy worker")
        return
    if match_state.issue_command(0, "build_barracks", west_worker, Vector2i(13, 12)):
        _fail("Unfunded building was accepted")
        return
    if not match_state.issue_command(0, "gather", west_worker, "nw_solid_1"):
        _fail("Cannot order worker to gather")
        return
    for id in match_state.units_for(0, "worker"):
        if id != west_worker:
            match_state.issue_command(0, "gather", id, "nw_solid_2" if id == match_state.units_for(0, "worker")[1] else "nw_solid_1")
    # Twenty Hertz with 40 ticks per Matter replaces the old six-tick lump.
    for i in range(7500):
        match_state.advance()
        if int(match_state.players[0]["matter"]) >= 100:
            break
    if int(match_state.players[0]["matter"]) < 100 or not match_state.matter_is_conserved():
        _fail("Physical Matter gathering/delivery or conservation failed")
        return

    if not match_state.issue_command(0, "build_barracks", west_worker, Vector2i(13, 12)):
        _fail("Funded worker cannot build Barracks")
        return
    for i in range(1500):
        match_state.advance()
        if match_state.units_for(0, "barracks").size() > 0:
            break
    if match_state.units_for(0, "barracks").size() != 1:
        _fail("Barracks build never completed")
        return
    if not match_state.matter_is_conserved():
        _fail("Matter was duplicated during building")
        return

    # Additional gathering funds Rifleman training.
    for i in range(5000):
        match_state.advance()
        if int(match_state.players[0]["matter"]) >= 50:
            break
    var barracks_id: int = match_state.units_for(0, "barracks")[0]
    if not match_state.issue_command(0, "train_rifleman", barracks_id):
        _fail("Barracks cannot train funded Rifleman")
        return
    for i in range(200):
        match_state.advance()
    if match_state.units_for(0, "rifleman").is_empty():
        _fail("Training failed")
        return

    # A real state hash must be stable for equal state and sensitive to updates.
    var before_hash: String = match_state.replay_hash()
    match_state.advance()
    if before_hash == match_state.replay_hash():
        _fail("Replay hash did not change with the authoritative tick")
        return

    var opponent_hq: int = match_state.units_for(1, "hq")[0]
    match_state._damage(opponent_hq, 2000, 0)
    match_state._check_end()
    if not match_state.finished or match_state.winner != 0 or match_state.finish_reason != "buildings_eliminated":
        _fail("All-completed-buildings victory condition failed")
        return
    if not match_state.matter_is_conserved():
        _fail("End-of-match Matter conservation failed")
        return

    var a = MATCH.new()
    var b = MATCH.new()
    a.setup(99, ["bot", "bot"])
    b.setup(99, ["bot", "bot"])
    for i in range(200):
        a.advance()
        b.advance()
    if a.replay_hash() != b.replay_hash() or not a.matter_is_conserved() or not b.matter_is_conserved():
        _fail("Bot match is not reproducible or resource-safe")
        return
    print("SCALFAGUS_MIRROR_SMOKE_PASS")
    quit(0)
