extends RefCounted
class_name MirrorGeometry

# Authoritative tile-space footprint helper (3x3, center-cell anchor).
# Native Godot AStarGrid2D remains solely responsible for route search.
const BUILDING_SIZE: int = 3
const BUILDING_RADIUS: int = 1
const METERS_PER_TILE: float = 2.0
const RIFLEMAN_RANGE_METERS: float = 6.5

static func is_building(kind: String) -> bool:
    return kind in ["hq", "barracks"]

static func occupied_cells(center: Vector2i) -> Array[Vector2i]:
    var cells: Array[Vector2i] = []
    for y in range(-BUILDING_RADIUS, BUILDING_RADIUS + 1):
        for x in range(-BUILDING_RADIUS, BUILDING_RADIUS + 1):
            cells.append(center + Vector2i(x, y))
    return cells

static func perimeter_cells(center: Vector2i) -> Array[Vector2i]:
    # Deterministic clockwise ring: no diagonal-only access to a building.
    var cells: Array[Vector2i] = []
    for x in range(-BUILDING_RADIUS, BUILDING_RADIUS + 1):
        cells.append(center + Vector2i(x, -BUILDING_RADIUS - 1))
    for y in range(-BUILDING_RADIUS, BUILDING_RADIUS + 1):
        cells.append(center + Vector2i(BUILDING_RADIUS + 1, y))
    for x in range(BUILDING_RADIUS, -BUILDING_RADIUS - 1, -1):
        cells.append(center + Vector2i(x, BUILDING_RADIUS + 1))
    for y in range(BUILDING_RADIUS, -BUILDING_RADIUS - 1, -1):
        cells.append(center + Vector2i(-BUILDING_RADIUS - 1, y))
    return cells

static func distance_to_building(p: Vector2i, center: Vector2i) -> int:
    # Manhattan distance to the nearest *occupied* tile (0 on footprint).
    var dx: int = maxi(absi(p.x - center.x) - BUILDING_RADIUS, 0)
    var dy: int = maxi(absi(p.y - center.y) - BUILDING_RADIUS, 0)
    return dx + dy

static func distance_sq_cells(a: Vector2i, b: Vector2i) -> int:
    var dx: int = a.x - b.x
    var dy: int = a.y - b.y
    return dx * dx + dy * dy

static func distance_sq_to_building(p: Vector2i, center: Vector2i) -> int:
    var dx: int = maxi(absi(p.x - center.x) - BUILDING_RADIUS, 0)
    var dy: int = maxi(absi(p.y - center.y) - BUILDING_RADIUS, 0)
    return dx * dx + dy * dy

static func tile_to_world(cell: Vector2i, height: float = 0.0) -> Vector3:
    return Vector3(
        float(cell.x) * METERS_PER_TILE, height,
        float(cell.y) * METERS_PER_TILE
    )

static func world_to_tile(pos: Vector3) -> Vector2i:
    return Vector2i(
        roundi(pos.x / METERS_PER_TILE),
        roundi(pos.z / METERS_PER_TILE)
    )
