extends Control
class_name ScalfagusRTSMinimap

# Visual-only RTS minimap. Coordinates are a deterministic 128m planar square.
# Does not reveal fog-of-war knowledge; this is a debug-preview map only.
const WORLD_HALF: float = 64.0
var world: Node3D
var update_clock: float = 0.0

func configure(root: Node3D) -> void:
    world = root
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    custom_minimum_size = Vector2(144.0, 144.0)

func _process(delta: float) -> void:
    update_clock += delta
    if update_clock >= 0.15:
        update_clock = 0.0
        queue_redraw()

func _point(node_position: Vector3) -> Vector2:
    var local: Vector2 = Vector2(node_position.x, node_position.z)
    return Vector2(
        (local.x + WORLD_HALF) * size.x / (WORLD_HALF * 2.0),
        (local.y + WORLD_HALF) * size.y / (WORLD_HALF * 2.0)
    )

func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), Color("#0b2029"))
    for i in range(1, 8):
        var p: float = float(i) / 8.0
        draw_line(Vector2(p * size.x, 0.0), Vector2(p * size.x, size.y), Color("#24404a"), 1.0)
        draw_line(Vector2(0.0, p * size.y), Vector2(size.x, p * size.y), Color("#24404a"), 1.0)
    # Temporary fixed water fixtures: must be replaced by canonical YAML importer.
    for basin in [Vector3(-4.0, 0.0, -24.0), Vector3(3.0, 0.0, 25.0)]:
        draw_circle(_point(basin), 9.0 * size.x / 128.0, Color("#266d8e"))
    if not is_instance_valid(world):
        return
    var props: Array = world.get("test_props")
    for prop in props:
        if is_instance_valid(prop) and prop.name.begins_with("Tree"):
            draw_circle(_point(prop.global_position), 1.6, Color("#537e59"))
    var buildings: Array = world.get("world_buildings")
    for building in buildings:
        if not is_instance_valid(building):
            continue
        var name_id: String = str(building.get_meta("faction", "man"))
        var col: Color = Color("#e2b568") if name_id == "man" else Color("#78e4f6")
        draw_rect(Rect2(_point(building.global_position) - Vector2.ONE * 3.0, Vector2.ONE * 6.0), col)
    var units: Array = world.get("selectable_units")
    var selection: Array = world.get("selected_units")
    for unit in units:
        if not is_instance_valid(unit) or not unit is PrototypeHero:
            continue
        var pos: Vector2 = _point(unit.global_position)
        var selected: bool = selection.has(unit)
        draw_circle(pos, 3.4 if selected else 2.1, Color("#ffe59e") if selected else Color("#e3b46b"))
    if int(world.get("view_mode")) == 0:
        var focus: Vector3 = world.get("camera_focus")
        draw_arc(_point(focus), 7.0, 0.0, TAU, 24, Color("#ffffff"), 1.2)
    draw_rect(Rect2(Vector2.ZERO, size), Color("#5c7883"), false, 1.0)
