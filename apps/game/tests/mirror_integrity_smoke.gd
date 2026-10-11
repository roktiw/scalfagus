extends SceneTree

# MVP0: authority, physical occupancy, Matter custody and replay integrity.
const MATCH = preload("res://scripts/mirror_match_state.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(why: String) -> void:
    push_error("SCALFAGUS_MIRROR_INTEGRITY_FAIL: " + why)
    quit(1)

func _verify() -> void:
    var sim = MATCH.new()
    sim.setup(42, ["human", "human"])
    var worker: int = sim.units_for(0, "worker")[0]
    var owned: Dictionary = sim.entities[worker]

    # An occupied source or worker cell cannot accept a Barracks or debit Matter.
    sim.mined_matter = 150
    sim.players[0]["matter"] = 150
    var other_worker: int = sim.units_for(0, "worker")[1]
    var occupied: Vector2i = sim.entities[other_worker]["pos"]
    if sim.issue_command(0, "build_barracks", worker, occupied):
        _fail("Barracks overlapped a mobile unit")
        return
    sim.sources["fixture"] = {"pos": Vector2i(13, 36), "stock": 10}
    if sim.issue_command(0, "build_barracks", worker, Vector2i(13, 36)):
        _fail("Barracks overlapped a resource source")
        return
    if int(sim.players[0]["matter"]) != 150 or not sim.matter_is_conserved():
        _fail("Rejected placement debited the ledger")
        return

    # A legal-looking but enclosed cell cannot silently accept an impossible route.
    var sealed := Vector2i(19, 19)
    for delta in MATCH.DIRECTIONS:
        sim.set_terrain_cell(sealed + delta, "water")
    if sim.issue_command(0, "move", worker, sealed):
        _fail("Unreachable move was accepted")
        return

    # An existing building blocks fire through it but is itself a valid target.
    var from_cell := Vector2i(13, 40)
    var building_cell := Vector2i(14, 40)
    var behind := Vector2i(15, 40)
    sim._spawn("barracks", 0, building_cell)
    if sim._line_clear(from_cell, behind):
        _fail("Projectile passed through an intervening building")
        return
    if not sim._line_clear(from_cell, building_cell):
        _fail("A target building blocked its own hit")
        return

    # A trained actor cannot spawn on another mobile actor.
    var spawn_sim = MATCH.new()
    spawn_sim.setup(43, ["human", "human"])
    var hq_id: int = spawn_sim.units_for(0, "hq")[0]
    var hq: Dictionary = spawn_sim.entities[hq_id]
    var hq_pos: Vector2i = hq["pos"]
    var blocking_ids: Array[int] = []
    for delta in MATCH.DIRECTIONS:
        blocking_ids.append(spawn_sim._spawn("worker", 0, hq_pos + delta))
    var count_before: int = spawn_sim.units_for(0, "worker").size()
    hq["train_kind"] = "worker"
    hq["train_left"] = 1
    spawn_sim._train_tick(hq)
    if spawn_sim.units_for(0, "worker").size() != count_before or str(hq["train_kind"]) != "worker":
        _fail("Training spawned on an occupied cell")
        return
    spawn_sim.entities.erase(blocking_ids[0])
    spawn_sim._train_tick(hq)
    if spawn_sim.units_for(0, "worker").size() != count_before or str(hq["train_kind"]) != "":
        _fail("Training failed to finish after a cell became free")
        return

    # HQ death destroys the stored treasury once without violating conservation.
    var treasury = MATCH.new()
    treasury.setup(44, ["human", "human"])
    treasury.mined_matter = 90
    treasury.players[0]["matter"] = 90
    var treasury_hq: int = treasury.units_for(0, "hq")[0]
    treasury._damage(treasury_hq, 2000, 1)
    if int(treasury.players[0]["matter"]) != 0 or treasury.lost_matter != 90:
        _fail("Destroyed HQ retained spendable Matter")
        return
    if not treasury.matter_is_conserved():
        _fail("HQ destruction did not reconcile custody")
        return

    # Visually identical actors with different queues or cooldowns have distinct hashes.
    var a = MATCH.new()
    var b = MATCH.new()
    a.setup(45, ["human", "human"])
    b.setup(45, ["human", "human"])
    if a.replay_hash() != b.replay_hash():
        _fail("Identical seeds produced different initial hashes")
        return
    var a_worker: int = a.units_for(0, "worker")[0]
    a.entities[a_worker]["cooldown"] = 1
    if a.replay_hash() == b.replay_hash():
        _fail("Replay hash omitted an authoritative cooldown")
        return
    a.entities[a_worker]["cooldown"] = 0
    var a_hq: int = a.units_for(0, "hq")[0]
    a.entities[a_hq]["train_kind"] = "worker"
    a.entities[a_hq]["train_left"] = 20
    if a.replay_hash() == b.replay_hash():
        _fail("Replay hash omitted a production queue")
        return

    print("SCALFAGUS_MIRROR_INTEGRITY_PASS")
    quit(0)
