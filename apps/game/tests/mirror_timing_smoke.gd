extends SceneTree

# Real Godot headless checks for the candidate 20Hz MAN mirror rules.
# No external CI runner; source of truth is MirrorTiming and MirrorMatchState.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const TIMING = preload("res://scripts/mirror_timing.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(why: String) -> void:
    push_error("SCALFAGUS_MIRROR_TIMING_FAIL " + why)
    quit(1)

func _verify() -> void:
    if TIMING.TICKS_PER_SECOND != 20 or MATCH.MAX_TICKS != 24000:
        _fail("Expected 20Hz and a 20-minute authoritative match cap")
        return
    if TIMING.BARRACKS_BUILD_TICKS != 360 or TIMING.WORKER_TRAIN_TICKS != 140 or TIMING.RIFLEMAN_TRAIN_TICKS != 180:
        _fail("Production/building duration not aligned to approved candidate")
        return

    var mine = MATCH.new()
    mine.setup(42, ["human", "human"])
    var worker_id: int = mine.units_for(0, "worker")[0]
    var worker: Dictionary = mine.entities[worker_id]
    # Fixture is parked at an actual source input tile: isolate mining clock
    # from the separate movement/navigation contract.
    worker["pos"] = Vector2i(10, 16)
    if not mine.issue_command(0, "gather", worker_id, "nw_solid_1"):
        _fail("Cannot order eligible Worker to mine")
        return
    for i in range(39):
        mine.advance()
    if int(worker["cargo"]) != 0 or int(mine.sources["nw_solid_1"]["stock"]) != 200:
        _fail("Mining extracted Matter before 2 seconds")
        return
    mine.advance()
    if int(worker["cargo"]) != 1 or int(mine.sources["nw_solid_1"]["stock"]) != 199:
        _fail("One unit of Matter was not extracted on tick 40")
        return
    for i in range(360):
        mine.advance()
    if int(worker["cargo"]) != 10 or str(worker["gather_phase"]) != "pickup":
        _fail("Ten-unit cargo did not take 400 extraction ticks")
        return
    for i in range(TIMING.PICKUP_TICKS):
        mine.advance()
    if str(worker["gather_phase"]) != "return":
        _fail("Pickup delay did not last exactly seven ticks")
        return
    worker["pos"] = Vector2i(9, 10) # Adjacent to own HQ; no teleport occurs in gameplay.
    for i in range(TIMING.UNLOAD_TICKS - 1):
        mine.advance()
    if int(mine.players[0]["matter"]) != 0:
        _fail("Matter became spendable before HQ unloading finished")
        return
    mine.advance()
    if int(mine.players[0]["matter"]) != 10 or int(worker["cargo"]) != 0:
        _fail("HQ failed atomic custody transfer after unloading")
        return
    if not mine.matter_is_conserved():
        _fail("Matter was created/lost in source-to-bag-to-HQ transfer")
        return

    # Three workers in range, only two may mine simultaneously. Sorted
    # entity IDs guarantee tie-break without relying on scene frame order.
    var concurrency = MATCH.new()
    concurrency.setup(12, ["human", "human"])
    var ids: Array[int] = concurrency.units_for(0, "worker")
    for id in ids:
        concurrency.entities[id]["pos"] = Vector2i(10, 16)
        if not concurrency.issue_command(0, "gather", id, "nw_solid_1"):
            _fail("Cannot assign miner fixture")
            return
    for i in range(40):
        concurrency.advance()
    var extracted: Array[int] = []
    for id in ids:
        extracted.append(int(concurrency.entities[id]["cargo"]))
    if extracted != [1, 1, 0] or concurrency.mined_matter != 2:
        _fail("Per-source two-miner cap or stable worker ordering failed")
        return

    # Precise movement credit: in 40 ticks each actor should take floor(40*v/20)
    # grid steps, rather than truncating v to a 1-step-every-N-ticks shortcut.
    var movement = MATCH.new()
    movement.setup(20, ["human", "human"])
    var walker_id: int = movement.units_for(0, "worker")[0]
    movement.entities[walker_id]["pos"] = Vector2i(10, 2)
    if not movement.issue_command(0, "move", walker_id, Vector2i(50, 2)):
        _fail("No legal Worker route for motion clock fixture")
        return
    var soldier_id: int = movement._spawn("rifleman", 0, Vector2i(10, 4))
    if not movement.issue_command(0, "move", soldier_id, Vector2i(50, 4)):
        _fail("No legal Rifleman route for motion clock fixture")
        return
    for i in range(40):
        movement.advance()
    if movement.entities[walker_id]["pos"] != Vector2i(14, 2):
        _fail("Worker did not travel exactly 4 cells in 2 seconds at 2.3 tiles/s")
        return
    if movement.entities[soldier_id]["pos"] != Vector2i(15, 4):
        _fail("Rifleman did not travel exactly 5 cells in 2 seconds at 2.6 tiles/s")
        return

    # Inject pre-mined test stock to isolate payment and fixed-duration queues.
    var production = MATCH.new()
    production.setup(30, ["human", "human"])
    production.mined_matter = 300
    production.players[0]["matter"] = 300
    var hq_id: int = production.units_for(0, "hq")[0]
    if not production.issue_command(0, "train_worker", hq_id):
        _fail("Funded HQ cannot queue a Worker")
        return
    for i in range(TIMING.WORKER_TRAIN_TICKS - 1):
        production.advance()
    if production.units_for(0, "worker").size() != 3:
        _fail("Worker trained before seven seconds elapsed")
        return
    production.advance()
    if production.units_for(0, "worker").size() != 4:
        _fail("Worker was not trained at the 140th tick")
        return
    var builder_id: int = production.units_for(0, "worker")[0]
    production.entities[builder_id]["pos"] = Vector2i(12, 12)
    if not production.issue_command(0, "build_barracks", builder_id, Vector2i(13, 12)):
        _fail("Funded Barracks site was refused")
        return
    for i in range(TIMING.BARRACKS_BUILD_TICKS - 1):
        production.advance()
    if not production.units_for(0, "barracks").is_empty():
        _fail("Barracks completed before 18 seconds")
        return
    production.advance()
    if production.units_for(0, "barracks").size() != 1:
        _fail("Barracks not finished after 360 uninterrupted labor ticks")
        return
    var barracks_id: int = production.units_for(0, "barracks")[0]
    if not production.issue_command(0, "train_rifleman", barracks_id):
        _fail("Funded Barracks cannot queue Rifleman")
        return
    for i in range(TIMING.RIFLEMAN_TRAIN_TICKS - 1):
        production.advance()
    if not production.units_for(0, "rifleman").is_empty():
        _fail("Rifleman trained before 9 seconds")
        return
    production.advance()
    if production.units_for(0, "rifleman").size() != 1:
        _fail("Rifleman not trained on tick 180")
        return
    if not production.matter_is_conserved():
        _fail("Costs broke custody conservation")
        return

    # One hit every 20 authoritative ticks: exactly 1.0 seconds.
    var combat = MATCH.new()
    combat.setup(34, ["human", "human"])
    var rifle_id: int = combat._spawn("rifleman", 0, Vector2i(12, 33))
    var victim_id: int = combat.units_for(1, "worker")[0]
    combat.entities[victim_id]["pos"] = Vector2i(13, 33)
    if not combat.issue_command(0, "attack", rifle_id, victim_id):
        _fail("Visible adjacent target could not be attacked")
        return
    combat.advance()
    if int(combat.entities[victim_id]["hp"]) != 42:
        _fail("First Rifleman shot was not eight damage")
        return
    for i in range(TIMING.RIFLEMAN_ATTACK_COOLDOWN_TICKS - 1):
        combat.advance()
    if int(combat.entities[victim_id]["hp"]) != 42:
        _fail("Rifleman fired again before 20 ticks elapsed")
        return
    combat.advance()
    if int(combat.entities[victim_id]["hp"]) != 34:
        _fail("Rifleman did not fire at the 20-tick cooldown")
        return

    # Visual game and accelerated headless state use the SAME tick duration.
    var packed: PackedScene = load("res://scenes/mirror_match.tscn")
    if packed == null:
        _fail("The visual scene is unavailable")
        return
    var view := packed.instantiate()
    root.add_child(view)
    await process_frame
    view.set("speed", 0)
    view.set("time_accumulator", 0.0)
    var view_sim = view.get("sim")
    var previous_tick: int = view_sim.tick
    view.set("speed", 1)
    view.call("_process", TIMING.TICK_SECONDS)
    view.set("speed", 0)
    if view_sim.tick != previous_tick + 1:
        _fail("GUI did not advance exactly one fixed tick in 0.05 seconds")
        return
    view.queue_free()

    var cap = MATCH.new()
    cap.setup(44, ["human", "human"])
    cap.tick = MATCH.MAX_TICKS - 1
    cap.advance()
    if not cap.finished or cap.winner != -1 or cap.tick != 24000:
        _fail("Authoritative 20-minute draw did not trigger at tick 24000")
        return
    var same = MATCH.new()
    same.setup(44, ["human", "human"])
    var old_hash: String = same.replay_hash()
    same.entities[same.units_for(0, "worker")[0]]["move_progress"] = 10
    if old_hash == same.replay_hash():
        _fail("Replay state hash omitted movement accumulator")
        return

    print("SCALFAGUS_MIRROR_TIMING_PASS")
    quit(0)
