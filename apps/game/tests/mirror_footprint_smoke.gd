extends SceneTree

# Godot headless acceptance: a 3x3 building is one entity with nine blocked
# world tiles, one external entrance ring and matching two-metre tile geometry.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const GEOM = preload("res://scripts/mirror_geometry.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_MIRROR_FOOTPRINT_FAIL: " + message)
    quit(1)

func _verify() -> void:
    var sim = MATCH.new()
    sim.setup(42, ["human", "human"])
    if sim.finished or sim.tile_meters != 2.0:
        _fail("Authored 2m Verdant map failed initialization")
        return
    var hq_id: int = sim.units_for(0, "hq")[0]
    var hq: Dictionary = sim.entities[hq_id]
    var center: Vector2i = hq["pos"]
    var cells: Array[Vector2i] = GEOM.occupied_cells(center)
    var rim: Array[Vector2i] = GEOM.perimeter_cells(center)
    if cells.size() != 9 or rim.size() != 12:
        _fail("3x3 occupies nine tiles with twelve exterior ports")
        return
    for cell in cells:
        if not sim._blocked(cell) or not sim.building_cells.has(cell):
            _fail("HQ footprint tile not occupied: " + str(cell))
            return
        if int(sim.building_cells[cell]) != hq_id:
            _fail("Wrong building owns footprint tile " + str(cell))
            return
        if sim.navigation.graph.is_point_solid(cell) != true:
            _fail("Godot AStarGrid2D ignored HQ collider " + str(cell))
            return
    if GEOM.distance_to_building(center + Vector2i(2, 0), center) != 1:
        _fail("Exterior port distance is wrong")
        return
    if GEOM.tile_to_world(center) != Vector3(18.0, 0.0, 18.0):
        _fail("World coordinates are not two metres per tile")
        return
    if GEOM.world_to_tile(Vector3(18.0, 0.0, 18.0)) != center:
        _fail("World-to-grid round trip is broken")
        return

    # A 3x3 footprint rejects overlap even if its *center* looks legal.
    var worker_id: int = sim.units_for(0, "worker")[0]
    var worker: Dictionary = sim.entities[worker_id]
    if sim._can_build(center + Vector2i(2, 0), 0):
        _fail("Barracks would overlap only the edge of the HQ")
        return
    if sim._can_build(Vector2i(1, 1), 0):
        _fail("Barracks would extend through the impassable platform rim")
        return
    var site := Vector2i(13, 12)
    if not sim._can_build(site, 0):
        _fail("Canonical near-HQ 3x3 site is not available")
        return
    sim.set_terrain_cell(site + Vector2i(1, 1), "water")
    if sim._can_build(site, 0):
        _fail("Flooding a single edge tile did not reject full-site placement")
        return
    sim.set_terrain_cell(site + Vector2i(1, 1), "")
    if not sim._can_build(site, 0):
        _fail("Clearing terrain did not restore legal site")
        return
    var debit_before: int = 100
    sim.mined_matter = debit_before
    sim.players[0]["matter"] = debit_before
    worker["pos"] = Vector2i(11, 12) # West of the 3x3 planned site, outside collider.
    if not sim.issue_command(0, "build_barracks", worker_id, site):
        _fail("Funded construction with adjacent external worker was rejected")
        return
    if sim._can_build(site, 0):
        _fail("Reserved construction site may be booked by two builders")
        return
    if int(sim.players[0]["matter"]) != 0 or sim.spent_matter != 100:
        _fail("Placement did not debit exact HQ Matter once")
        return
    for i in range(360):
        sim.advance()
    var buildings: Array[int] = sim.units_for(0, "barracks")
    if buildings.size() != 1:
        _fail("3x3 Barracks not constructed in 360 uninterrupted ticks")
        return
    var barracks_id: int = buildings[0]
    if sim.entities[barracks_id]["pos"] != site:
        _fail("Barracks anchor changed while building")
        return
    var revision_before: int = sim.navigation.revision
    for cell in GEOM.occupied_cells(site):
        if sim.building_cells.get(cell, -1) != barracks_id or not sim._blocked(cell):
            _fail("One of nine Barracks collider tiles is walkable")
            return

    # Spawn is outside 3x3 producer, not from the blocked center-adjacent tile.
    var barracks: Dictionary = sim.entities[barracks_id]
    barracks["train_kind"] = "rifleman"
    barracks["train_left"] = 1
    sim._train_tick(barracks)
    var soldiers: Array[int] = sim.units_for(0, "rifleman")
    if soldiers.size() != 1:
        _fail("Trained Rifleman could not leave full Barracks footprint")
        return
    var soldier: Dictionary = sim.entities[soldiers[0]]
    if not rim.is_empty() and GEOM.occupied_cells(site).has(soldier["pos"]):
        _fail("Rifleman spawned inside completed Barracks")
        return
    if not GEOM.perimeter_cells(site).has(soldier["pos"]):
        _fail("Rifleman spawned outside the legal perimeter ports")
        return

    # Attack range uses 6.5 real metres = at most three grid tiles for a
    # straight shot, and nearest occupied surface of the 3x3 target.
    var near: Vector2i = Vector2i(38, 25)
    var far: Vector2i = Vector2i(36, 25)
    var target := {"kind": "barracks", "pos": Vector2i(42, 25)}
    if not sim._can_hit(near, target):
        _fail("Legal six metre shot to a building face is out of range")
        return
    if sim._can_hit(far, target):
        _fail("Illegal ten metre shot was accepted")
        return

    sim._damage(barracks_id, 5000, 1)
    if sim.navigation.revision <= revision_before:
        _fail("Destruction did not invalidate native navigation revision")
        return
    for cell in GEOM.occupied_cells(site):
        if sim.building_cells.has(cell) or sim._blocked(cell):
            _fail("Destroyed Barracks still blocks tile " + str(cell))
            return
    if not sim.matter_is_conserved():
        _fail("Physical construction and death broke Matter conservation")
        return
    print("SCALFAGUS_MIRROR_FOOTPRINT_PASS")
    quit(0)
