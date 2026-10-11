extends SceneTree

# DEC-034: prove that MAN mirror pathing uses native AStarGrid2D and
# responds to dynamic construction / destruction without inventing new A*.
const PORT = preload("res://scripts/mirror_navigation_port.gd")
const MATCH = preload("res://scripts/mirror_match_state.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _fail(message: String) -> void:
    push_error("SCALFAGUS_MIRROR_ASTAR_FAIL: " + message)
    quit(1)

func _verify() -> void:
    var terrain := {Vector2i(6, 5): "tree"}
    var port = PORT.new()
    port.configure(16, terrain)
    if not (port.graph is AStarGrid2D):
        _fail("The selected provider is not Godot AStarGrid2D")
        return
    if not port.is_blocked(Vector2i(0, 0)) or not port.is_blocked(Vector2i(15, 15)):
        _fail("The floating platform border is traversable")
        return
    var start := Vector2i(5, 5)
    var goal := Vector2i(7, 5)
    var around: Array[Vector2i] = port.route(start, goal)
    if around.size() != 4 or around.has(Vector2i(6, 5)):
        _fail("AStar did not detour around a solid tree")
        return
    if around != port.route(start, goal):
        _fail("Same grid did not produce a reproducible path")
        return

    # Dynamic no-path case: sealed start must not fall through a wall.
    port.set_blocked(Vector2i(4, 5), true)
    port.set_blocked(Vector2i(5, 4), true)
    port.set_blocked(Vector2i(5, 6), true)
    if not port.route(start, goal).is_empty():
        _fail("Unreachable destination incorrectly returned a path")
        return
    port.set_blocked(Vector2i(5, 4), false)
    if port.route(start, goal).is_empty():
        _fail("Opening the corridor did not restore routing")
        return

    # Building is an occupied target: workers route adjacent, not through it.
    var building := Vector2i(10, 10)
    port.set_blocked(building, true)
    var approach: Array[Vector2i] = port.route(Vector2i(7, 10), building, true)
    if approach.is_empty() or approach.back().distance_to(building) != 1.0:
        _fail("Could not approach blocked building from a legal neighbor")
        return
    if not port.route(Vector2i(7, 10), building, false).is_empty():
        _fail("Navigation routed into a solid building")
        return

    # The authoritative match calls the exact same port and invalidates
    # previously cached routes when structures change.
    var sim = MATCH.new()
    sim.setup(42, ["human", "human"])
    var origin: Vector2i = Vector2i(37, 25)
    var end: Vector2i = Vector2i(47, 25)
    var direct: Array[Vector2i] = sim._find_route(origin, end, false)
    if direct.is_empty() or direct[0] != origin + Vector2i(1, 0):
        _fail("Initial MAN match route was not direct")
        return
    var obstacle_cell: Vector2i = Vector2i(42, 25)
    var revision_before: int = sim.navigation.revision
    var building_id: int = sim._spawn("barracks", 1, obstacle_cell)
    if sim.navigation.revision <= revision_before:
        _fail("Constructing a building did not invalidate cached routes")
        return
    var detour: Array[Vector2i] = sim._find_route(origin, end, false)
    var footprint: Array[Vector2i] = sim.GEOM.occupied_cells(obstacle_cell)
    var crosses_footprint: bool = false
    for step in detour:
        if footprint.has(step):
            crosses_footprint = true
    if detour.is_empty() or crosses_foot:
        _fail("An active building is not excluded from routes")
        return
    sim._damage(building_id, 5000, 0)
    var restored: Array[Vector2i] = sim._find_route(origin, end, false)
    if restored.is_empty() or not restored.has(obstacle_cell):
        _fail("Destroyed building did not restore traversability")
        return

    # Mutating authored terrain must go through the adapter, not raw Dict.
    sim.set_terrain_cell(obstacle_cell, "water")
    if sim._find_route(origin, end, false).has(obstacle_cell):
        _fail("New water cell did not block movement")
        return
    sim.set_terrain_cell(obstacle_cell, "")
    if sim._find_route(origin, end, false).is_empty():
        _fail("Removed terrain obstacle did not restore a route")
        return

    print("SCALFAGUS_MIRROR_ASTAR_PASS")
    quit(0)
