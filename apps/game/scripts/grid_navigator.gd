extends RefCounted
class_name ScalfagusGridNavigator

# Gameplay-independent 64x64, 2-metre grid for the Verdant Divide RTS spike.
# The visual terrain is 3D; only horizontal navigation is discretized.
# Reservations/footprints are in world metres. This is NOT full 3D navmesh
# or terrain-height aware pathfinding.

const GRID_SIDE: int = 64
const CELL_METRES: float = 2.0
const WORLD_MIN: float = -64.0
const WORLD_MAX: float = 64.0
const AGENT_CLEARANCE: float = 0.70
const NEAREST_SEARCH_CELLS: int = 10

var graph: AStarGrid2D
var blocked_count: int = 0

func _init() -> void:
    graph = AStarGrid2D.new()
    graph.region = Rect2i(Vector2i.ZERO, Vector2i(GRID_SIDE, GRID_SIDE))
    graph.cell_size = Vector2(CELL_METRES, CELL_METRES)
    graph.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    graph.update()

static func in_world_bounds(pos: Vector2) -> bool:
    return pos.x >= WORLD_MIN and pos.x < WORLD_MAX and pos.y >= WORLD_MIN and pos.y < WORLD_MAX

static func world_to_cell(pos: Vector2) -> Vector2i:
    return Vector2i(
        clampi(int(floor((pos.x - WORLD_MIN) / CELL_METRES)), 0, GRID_SIDE - 1),
        clampi(int(floor((pos.y - WORLD_MIN) / CELL_METRES)), 0, GRID_SIDE - 1)
    )

static func cell_to_world(cell: Vector2i) -> Vector2:
    return Vector2(
        WORLD_MIN + (float(cell.x) + 0.5) * CELL_METRES,
        WORLD_MIN + (float(cell.y) + 0.5) * CELL_METRES
    )

func _mark(cell: Vector2i) -> void:
    if not graph.is_in_boundsv(cell) or graph.is_point_solid(cell):
        return
    graph.set_point_solid(cell, true)
    blocked_count += 1

func block_circle(center: Vector2, radius_metres: float) -> void:
    var radius: float = maxf(0.0, radius_metres) + AGENT_CLEARANCE
    var low: Vector2i = world_to_cell(center - Vector2.ONE * radius)
    var high: Vector2i = world_to_cell(center + Vector2.ONE * radius)
    for x in range(low.x, high.x + 1):
        for y in range(low.y, high.y + 1):
            var id: Vector2i = Vector2i(x, y)
            if cell_to_world(id).distance_to(center) <= radius:
                _mark(id)

func block_rectangle(center: Vector2, dimensions: Vector2) -> void:
    var half: Vector2 = dimensions * 0.5 + Vector2.ONE * AGENT_CLEARANCE
    var low: Vector2i = world_to_cell(center - half)
    var high: Vector2i = world_to_cell(center + half)
    for x in range(low.x, high.x + 1):
        for y in range(low.y, high.y + 1):
            var pos: Vector2 = cell_to_world(Vector2i(x, y))
            if absf(pos.x - center.x) <= half.x and absf(pos.y - center.y) <= half.y:
                _mark(Vector2i(x, y))

func is_blocked_at(pos: Vector2) -> bool:
    if not in_world_bounds(pos):
        return true
    return graph.is_point_solid(world_to_cell(pos))

func _nearest_walkable(pos: Vector2) -> Vector2i:
    var origin: Vector2i = world_to_cell(pos)
    if not graph.is_point_solid(origin):
        return origin
    var best: Vector2i = Vector2i(-1, -1)
    var best_dist: float = INF
    for radius in range(1, NEAREST_SEARCH_CELLS + 1):
        for dy in range(-radius, radius + 1):
            for dx in range(-radius, radius + 1):
                if maxi(absi(dx), absi(dy)) != radius:
                    continue
                var cell: Vector2i = origin + Vector2i(dx, dy)
                if not graph.is_in_boundsv(cell) or graph.is_point_solid(cell):
                    continue
                var dist: float = cell_to_world(cell).distance_squared_to(pos)
                if dist < best_dist:
                    best_dist = dist
                    best = cell
        if best.x >= 0:
            return best
    return best

func route(start_world: Vector2, destination_world: Vector2) -> Array[Vector3]:
    var result: Array[Vector3] = []
    # Never teleport an actor back onto the map from outside the physics rim.
    if not in_world_bounds(start_world):
        return result
    var from_id: Vector2i = _nearest_walkable(start_world)
    var to_id: Vector2i = _nearest_walkable(Vector2(
        clampf(destination_world.x, WORLD_MIN + 0.1, WORLD_MAX - 0.1),
        clampf(destination_world.y, WORLD_MIN + 0.1, WORLD_MAX - 0.1)
    ))
    if from_id.x < 0 or to_id.x < 0:
        return result
    var ids: Array[Vector2i] = graph.get_id_path(from_id, to_id)
    if ids.is_empty():
        return result
    # Skip the origin cell: units are already somewhere inside it.
    for i in range(1, ids.size()):
        var waypoint: Vector2 = cell_to_world(ids[i])
        result.append(Vector3(waypoint.x, 0.0, waypoint.y))
    if result.is_empty():
        var last: Vector2 = cell_to_world(to_id)
        result.append(Vector3(last.x, 0.0, last.y))
    return result
