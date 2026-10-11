extends RefCounted
class_name MirrorNavigationPort

# DEC-034: thin adapter to the native Godot AStarGrid2D.
# All geometry is cell-based and belongs to MirrorMatchState; this class
# never owns the match clock, unit orders, economy or damage.
const CARDINALS: Array[Vector2i] = [
    Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)
]

var graph: AStarGrid2D
var side_length: int = 0
var revision: int = 0

func configure(size: int, blocked_terrain: Dictionary) -> void:
    assert(size > 2)
    side_length = size
    graph = AStarGrid2D.new()
    graph.region = Rect2i(0, 0, size, size)
    graph.cell_size = Vector2.ONE
    graph.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    graph.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
    graph.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
    graph.update()

    # An impassable border is part of the gameplay world, not drawn scenery.
    for x in range(size):
        graph.set_point_solid(Vector2i(x, 0), true)
        graph.set_point_solid(Vector2i(x, size - 1), true)
    for y in range(size):
        graph.set_point_solid(Vector2i(0, y), true)
        graph.set_point_solid(Vector2i(size - 1, y), true)
    for key in blocked_terrain.keys():
        var cell: Vector2i = key
        if graph.is_in_boundsv(cell):
            graph.set_point_solid(cell, true)
    revision += 1

func in_bounds(cell: Vector2i) -> bool:
    return graph != null and graph.is_in_boundsv(cell)

func is_blocked(cell: Vector2i) -> bool:
    return not in_bounds(cell) or graph.is_point_solid(cell)

func set_blocked(cell: Vector2i, blocked: bool) -> void:
    if not in_bounds(cell):
        return
    var desired: bool = (
        blocked or cell.x == 0 or cell.y == 0
        or cell.x == side_length - 1 or cell.y == side_length - 1
    )
    if graph.is_point_solid(cell) == desired:
        return
    graph.set_point_solid(cell, desired)
    revision += 1

func route(start: Vector2i, destination: Vector2i, adjacent_ok: bool = false) -> Array[Vector2i]:
    var empty: Array[Vector2i] = []
    if is_blocked(start) or not in_bounds(destination):
        return empty
    var distance: int = absi(start.x - destination.x) + absi(start.y - destination.y)
    if distance <= (1 if adjacent_ok else 0):
        return empty

    # Native A* owns all shortest-path search. For buildings/resources we find
    # an adjacent walkable tile, never route through an occupied goal cell.
    var candidates: Array[Vector2i] = []
    if adjacent_ok:
        for direction in CARDINALS:
            var adjacent: Vector2i = destination + direction
            if not is_blocked(adjacent):
                candidates.append(adjacent)
    elif not is_blocked(destination):
        candidates.append(destination)
    if candidates.is_empty():
        return empty

    var best: Array[Vector2i] = []
    for goal in candidates:
        var path: Array[Vector2i] = graph.get_id_path(start, goal)
        if path.is_empty() or path[0] != start or path[path.size() - 1] != goal:
            continue
        # Stable tie-break: candidate list is in deterministic CARDINALS order.
        if best.is_empty() or path.size() < best.size():
            best = path
    if best.size() <= 1:
        return empty
    best.remove_at(0) # Caller owns this actor's current cell.
    return best
