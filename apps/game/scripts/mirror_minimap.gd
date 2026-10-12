extends Control

signal focus_requested(cell: Vector2i)
var world: Node3D

func _ready() -> void:
    custom_minimum_size = Vector2(152, 152)
    mouse_filter = Control.MOUSE_FILTER_STOP
    tooltip_text = "Click to focus the camera. Unknown terrain and Matter stay shrouded."

func _point(cell: Vector2i) -> Vector2:
    return Vector2(cell) / 63.0 * size

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        focus_requested.emit(Vector2i((event.position / size * 63.0).round()))
        accept_event()

# Keep the HUD consistent with the world's presentation fog, never reveal
# authored tree/water shapes or unobserved Matter stock from sim dictionaries.
func _vision_state(cell: Vector2i) -> int:
    if not is_instance_valid(world):
        return 0
    if world.spectator:
        return 2
    var fog = world.get("fog")
    if fog == null:
        return 0
    if fog.is_visible(cell, 0):
        return 2
    return 1 if fog.is_discovered(cell, 0) else 0

func _source_is_visible(source: Dictionary) -> bool:
    return int(source["stock"]) > 0 and _vision_state(source["pos"]) == 2

func _entity_is_visible(entity: Dictionary) -> bool:
    if not is_instance_valid(world):
        return false
    if world.spectator or int(entity["owner"]) == 0:
        return true
    return _vision_state(entity["pos"]) == 2 and world.sim.can_see(0, entity["pos"])

func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), Color("#0c1118"))
    if not is_instance_valid(world):
        return
    var sim = world.sim
    var tile := size / 64.0
    for cell in sim.terrain:
        var vision: int = _vision_state(cell)
        if vision == 0:
            continue
        var water: bool = sim.terrain[cell] == "water"
        var tone: Color = Color("#397c97") if water else Color("#405744")
        if vision == 1:
            tone = Color("#20313b") if water else Color("#27342d")
        draw_rect(Rect2(_point(cell), tile), tone)
    for sid in sim.sources:
        var source: Dictionary = sim.sources[sid]
        if _source_is_visible(source):
            draw_circle(_point(source["pos"]), 2.0, Color("#dbb568"))
    for id in sim.sorted_ids():
        var entity: Dictionary = sim.entities[id]
        if not _entity_is_visible(entity):
            continue
        var point := _point(entity["pos"])
        var color := Color("#79d6ee") if int(entity["owner"]) == 0 else Color("#f27e67")
        if str(entity["kind"]) in ["hq", "barracks"]:
            draw_rect(Rect2(point - Vector2(3, 3), Vector2(6, 6)), color)
        else:
            draw_circle(point, 2.4, Color("#ffffff") if world.selected_ids.has(id) else color)
    var bounds := world.get_viewport().get_visible_rect().size
    var corners := PackedVector2Array()
    for screen in [Vector2(0, 42), Vector2(bounds.x, 42), Vector2(bounds.x, bounds.y - 212), Vector2(0, bounds.y - 212)]:
        corners.append(_point(world._cell_at_mouse(screen)))
    if corners.size() == 4:
        corners.append(corners[0])
        draw_polyline(corners, Color("#e2e9cc"), 1.0)
    draw_rect(Rect2(Vector2.ZERO, size), Color("#7995a1"), false)
