extends SceneTree

# Local Godot test: authored YAML -> committed JSON -> native map adapter
# -> exactly the same simulation/nav/3D visualization inputs.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const MAP = preload("res://scripts/mirror_map_port.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(why: String) -> void:
    push_error("SCALFAGUS_VERDANT_MAP_FAIL: " + why)
    quit(1)

func _verify() -> void:
    var map_data: Dictionary = MAP.load_verdant()
    if map_data.is_empty():
        _fail("Native JSON map failed schema/shape validation")
        return
    if map_data["tile_meters"] != 2.0 or map_data["sources"].size() != 10:
        _fail("Missing 2m tile scale or ten source nodes")
        return
    if map_data["terrain"].size() != 197:
        _fail("Authored water/tree raster must have exactly 197 cells")
        return
    if map_data["terrain"].get(Vector2i(28, 46), "") != "water":
        _fail("Water-over-tree precedence changed for documented overlap")
        return

    var sim = MATCH.new()
    sim.setup(42, ["human", "human"])
    if sim.finished or sim.map_id != "verdant_divide":
        _fail("Simulation did not use authored Verdant map")
        return
    if sim.map_hash != map_data["map_hash"] or sim.map_source_sha != map_data["source_git_blob_sha"]:
        _fail("Map artifact digest/manifest SHA not recorded by simulation")
        return
    var expected_hqs: Array[Vector2i] = [Vector2i(9, 9), Vector2i(54, 54)]
    var expected_workers: Array[Vector2i] = [
        Vector2i(7, 11), Vector2i(9, 12), Vector2i(12, 9),
        Vector2i(56, 52), Vector2i(54, 51), Vector2i(51, 54)
    ]
    for side in range(2):
        var own_hq: Vector2i = sim.entities[sim.units_for(side, "hq")[0]]["pos"]
        if own_hq != expected_hqs[side]:
            _fail("HQ positions differ from YAML authored start slots")
            return
        for wid in sim.units_for(side, "worker"):
            var cell: Vector2i = sim.entities[wid]["pos"]
            if not expected_workers.has(cell) or sim._blocked(cell):
                _fail("Worker spawned on incorrect/blocked tile " + str(cell))
                return
    var total: int = 0
    for sid in sim.sources.keys():
        var src: Dictionary = sim.sources[sid]
        total += int(src["stock"])
        if sim._blocked(src["pos"]):
            _fail("SOLID source spawned inside tree/water or outer rim")
            return
    if total != 1660:
        _fail("Matter source checksum != 1660")
        return
    for cluster in [
        ["nw_solid_1", "nw_solid_2"],
        ["se_solid_1", "se_solid_2"]
    ]:
        if int(sim.sources[cluster[0]]["stock"]) + int(sim.sources[cluster[1]]["stock"]) != 400:
            _fail("Unbalanced starting resource cluster")
            return
    for side in range(2):
        var mine_id: String = "nw_solid_1" if side == 0 else "se_solid_1"
        var worker: Dictionary = sim.entities[sim.units_for(side, "worker")[0]]
        var goal: Vector2i = sim.sources[mine_id]["pos"]
        if sim._find_route(worker["pos"], goal, true).is_empty():
            _fail("Authoritative AStar cannot reach legal own source")
            return
    if not sim._blocked(Vector2i(32, 20)) or not sim._blocked(Vector2i(21, 15)):
        _fail("Water or giant tree no longer collides with native nav")
        return
    if sim._blocked(Vector2i(32, 32)):
        _fail("Central meadow became blocked")
        return
    var repeat = MATCH.new()
    repeat.setup(42, ["human", "human"])
    if repeat.map_hash != sim.map_hash or repeat.replay_hash() != sim.replay_hash():
        _fail("Identical map and seed did not produce stable state hash")
        return
    print("SCALFAGUS_VERDANT_MAP_PASS")
    quit(0)
