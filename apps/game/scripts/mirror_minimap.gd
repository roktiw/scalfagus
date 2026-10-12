extends Control

signal focus_requested(cell: Vector2i)
var world: Node3D

func _ready() -> void:
    custom_minimum_size = Vector2(152, 152)
    mouse_filter = Control.MOUSE_FILTER_STOP
    tooltip_text = "Click to focus the camera. Enemy markers follow visibility."

func _point(cell: Vector2i) -> Vector2:
    return Vector2(cell) / 63.0 * size

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        focus_requested.emit(Vector2i((event.position / size * 63.0).round()))
        accept_event()

func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), Color("#263b30"))
    if not is_instance_valid(world):
        return
    var sim = world.sim
    var tile := size / 64.0
    for cell in sim.terrain:
        draw_rect(Rect2(_point(cell), tile), Color("#397c97") if sim.terrain[cell] == "water" else Color("#405744"))
    for sid in sim.sources:
        if int(sim.sources[sid]["stock"]) > 0:
            draw_circle(_point(sim.sources[sid]["pos"]), 2.0, Color("#dbb568"))
    for id in sim.sorted_ids():
        var entity: Dictionary = sim.entities[id]
        if not world.spectator and int(entity["owner"]) == 1 and not sim.can_see(0, entity["pos"]):
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
