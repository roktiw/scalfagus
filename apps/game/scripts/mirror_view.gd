extends Node3D

# First playable visualization of MVP 0.1's shared authoritative MAN rules.
# This is local Human-vs-Bot / Bot-vs-Bot; LAN Human-vs-Human is a later gate.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const TIMING = preload("res://scripts/mirror_timing.gd")
const GEOM = preload("res://scripts/mirror_geometry.gd")
const PHYSICS_LOS = preload("res://scripts/mirror_physics_los_3d.gd")
const VIEW_SCRIPT = preload("res://scripts/directional_sprite_5.gd")
const WORKER_ATLAS = preload("res://assets/man_worker_32x48_idle_5view.png")
const LANDER_ATLAS = preload("res://assets/man_lander_128x128_unverified_5view.png")
const TREE_ATLAS = preload("res://assets/neutral_tree_40x64_5view.png")
const ROCK_ATLAS = preload("res://assets/neutral_rock_56x36_5view.png")
const MENU_SCENE: String = "res://scenes/menu.tscn"

var sim
var camera: Camera3D
var world_root: Node3D
var terrain_physics_root: Node3D
var unit_nodes: Dictionary = {}
var source_nodes: Dictionary = {}
var selected_id: int = -1
var selected_ids: Array[int] = []
var group_markers: Dictionary = {}
var selection_box: ColorRect
var drag_start: Vector2 = Vector2.ZERO
var drag_active: bool = false
var drag_moved: bool = false
var build_mode: bool = false
var spectator: bool = false
var time_accumulator: float = 0.0
var speed: int = 1
const COMMAND_HUD = preload("res://scripts/mirror_command_hud.gd")
const REPLAY_ARCHIVE = preload("res://scripts/mirror_replay_archive.gd")
const REPLAY_SESSION = preload("res://scripts/mirror_replay_session.gd")
var command_hud: Control
var paused: bool = false
var pause_overlay: Control
var settings_overlay: Control
var replay_mode: bool = false
var replay_session: MirrorReplaySession
var replay_save_status: Label
var hud: Label
var help_label: Label
var selection_marker: MeshInstance3D
var info: String = ""
var camera_center: Vector3 = Vector3(34.0, 0.0, 34.0)
var zoom_size: float = 100.0

func _ready() -> void:
    sim = MATCH.new()
    var mode: String = str(ProjectSettings.get_setting("scalfagus/mirror_mode", "human_bot"))
    replay_mode = mode == "replay"
    spectator = mode == "bot_bot"
    if spectator:
        camera_center = Vector3(63.0, 0.0, 63.0)
        zoom_size = 152.0
    if replay_mode:
        replay_session = REPLAY_SESSION.new()
        var document: Dictionary = REPLAY_ARCHIVE.load_user("last-human-match")
        var start: Dictionary = replay_session.begin(document)
        if bool(start.get("ok", false)):
            sim = replay_session.sim
        else:
            # Never silently replay with a different seed/map or controller.
            # Leave a visible error in a paused, non-commandable match.
            sim.setup(42, ["human", "bot"])
            info = "Replay unavailable: " + str(start.get("reason", "missing_save"))
            speed = 0
    else:
        sim.setup(42, ["bot", "bot"] if spectator else ["human", "bot"])
    _build_scene()
    _sync_visuals()

func _mat(color: Color) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = 0.9
    return m

func _block(size: Vector3, color: Color, parent: Node3D) -> MeshInstance3D:
    var visual := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    visual.mesh = mesh
    visual.material_override = _mat(color)
    parent.add_child(visual)
    return visual

# Restore existing five-view pixel art from the original camera prototype.
# The returned Node3D belongs to presentation only. No gameplay state is duplicated.
func _pixel_actor(atlas: Texture2D, frame_size: Vector2i, pixel_scale: float,
        tint: Color, mirror_safe: bool = false) -> Node3D:
    var root := Node3D.new()
    world_root.add_child(root)
    root.scale = Vector3.ONE * sim.tile_meters
    var visual: DirectionalSprite5 = VIEW_SCRIPT.new()
    visual.name = "Visual"
    root.add_child(visual)
    visual.configure(atlas, frame_size, 1, root, pixel_scale, mirror_safe)
    visual.sprite.modulate = tint
    return root

func _attach_footprint_collider(actor: Node3D, height_tiles: float, entity_id: int) -> void:
    # Actual Godot physics shape matches the authoritative 3x3 footprint:
    # root is scaled by tile_meters, so this 3-tile BoxShape becomes 6x6 m.
    var collider := StaticBody3D.new()
    collider.name = "FootprintBody"
    collider.collision_layer = 1
    collider.collision_mask = 0
    collider.set_meta("scalfagus_entity_id", entity_id)
    actor.add_child(collider)
    var shape_node := CollisionShape3D.new()
    shape_node.name = "FootprintShape"
    var shape := BoxShape3D.new()
    shape.size = Vector3(3.0, height_tiles, 3.0)
    shape_node.shape = shape
    shape_node.position.y = height_tiles * 0.5
    collider.add_child(shape_node)

func _unit_sprite(e: Dictionary) -> Node3D:
    var kind: String = str(e["kind"])
    var blue: bool = int(e["owner"]) == 0
    if kind == "hq":
        var hq_sprite: Node3D = _pixel_actor(LANDER_ATLAS, Vector2i(128, 128), 0.038,
            Color(0.85, 0.98, 1.0) if blue else Color(1.0, 0.77, 0.70))
        _attach_footprint_collider(hq_sprite, 2.6, int(e["id"]))
        return hq_sprite
    if kind == "barracks":
        # Existing lander sprite temporarily represents a Barracks until dedicated art.
        var barracks_sprite: Node3D = _pixel_actor(LANDER_ATLAS, Vector2i(128, 128), 0.027,
            Color(0.58, 0.81, 1.0) if blue else Color(1.0, 0.64, 0.50))
        _attach_footprint_collider(barracks_sprite, 2.0, int(e["id"]))
        return barracks_sprite
    if kind == "rifleman":
        # Reuse MAN worker sheet until the Rifleman 5-view atlas is authored.
        return _pixel_actor(WORKER_ATLAS, Vector2i(32, 48), 0.045,
            Color(0.52, 0.83, 1.0) if blue else Color(1.0, 0.67, 0.50))
    return _pixel_actor(WORKER_ATLAS, Vector2i(32, 48), 0.039,
        Color(0.98, 0.98, 1.0) if blue else Color(1.0, 0.85, 0.78))

func _build_scene() -> void:
    var background := WorldEnvironment.new()
    var environment := Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color("#080f27")
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color("#bdc4d0")
    environment.ambient_light_energy = 0.9
    background.environment = environment
    add_child(background)

    var light := DirectionalLight3D.new()
    light.rotation_degrees = Vector3(-62.0, -20.0, 0.0)
    light.light_energy = 1.0
    add_child(light)

    world_root = Node3D.new()
    add_child(world_root)
    terrain_physics_root = Node3D.new()
    terrain_physics_root.name = "TerrainPhysics"
    world_root.add_child(terrain_physics_root)
    var underdeck := _block(Vector3(134.0, 3.0, 134.0), Color("#25314b"), world_root)
    underdeck.position = Vector3(63.0, -2.4, 63.0)
    var ground := _block(Vector3(128.0, 0.8, 128.0), Color("#526c4d"), world_root)
    ground.position = Vector3(63.0, -0.56, 63.0)

    # Cosmetic rim reinforces the mandatory floating-platform world rule.
    for edge in range(4):
        var rim_size := Vector3(130.0, 2.0, 1.3) if edge < 2 else Vector3(1.3, 2.0, 130.0)
        var rim := _block(rim_size, Color("#8498b1"), world_root)
        if edge == 0:
            rim.position = Vector3(63.0, 0.04, -1.0)
        elif edge == 1:
            rim.position = Vector3(63.0, 0.04, 127.0)
        elif edge == 2:
            rim.position = Vector3(-1.0, 0.04, 63.0)
        else:
            rim.position = Vector3(127.0, 0.04, 63.0)

    # Gameplay obstruction lives in the Simulation Core. Pixel art is visual only.
    for cell in sim.terrain.keys():
        var kind: String = str(sim.terrain[cell])
        # These native colliders mirror the compiled authored tile raster.
        # Water is solid for future actor physics, but never blocks LOS rays.
        PHYSICS_LOS.attach_tile(terrain_physics_root, cell, kind)
        if kind == "tree":
            var tree_sprite: Node3D = _pixel_actor(
                TREE_ATLAS, Vector2i(40, 64), 0.052, Color.WHITE, true)
            tree_sprite.position = GEOM.tile_to_world(cell)
        else:
            var pond := _block(Vector3(2.0, 0.14, 2.0),
                Color("#296d9d"), world_root)
            pond.position = GEOM.tile_to_world(cell, 0.08)

    for sid in sim.sources.keys():
        var source: Dictionary = sim.sources[sid]
        var ore: Node3D = _pixel_actor(
            ROCK_ATLAS, Vector2i(56, 36), 0.040, Color(1.0, 0.88, 0.57))
        var p: Vector2i = source["pos"]
        ore.position = GEOM.tile_to_world(p)
        source_nodes[sid] = ore

    camera = Camera3D.new()
    camera.projection = Camera3D.PROJECTION_ORTHOGONAL
    camera.size = zoom_size
    camera.far = 600.0
    camera.current = true
    add_child(camera)
    _position_camera()

    selection_marker = _block(Vector3(2.1, 0.16, 2.1), Color("#f5f18d"), world_root)
    selection_marker.visible = false

    var ui := CanvasLayer.new()
    add_child(ui)
    command_hud = COMMAND_HUD.new()
    ui.add_child(command_hud)
    command_hud.configure(self)
    command_hud.command_requested.connect(_hud_command)
    command_hud.menu_requested.connect(_toggle_pause)
    hud = command_hud.top
    help_label = command_hud.status

    # CanvasLayer's native Control draws a marquee; it never intercepts clicks.
    selection_box = ColorRect.new()
    selection_box.name = "RTSSelectionMarquee"
    selection_box.color = Color(0.15, 0.68, 1.0, 0.20)
    selection_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
    selection_box.visible = false
    ui.add_child(selection_box)

# Raycast audit for authored static world. The authoritative RefCounted match
# deliberately never consumes this renderer-physics result (CI/lockstep safe).
func physics_los_probe(from_cell: Vector2i, to_cell: Vector2i,
        target_building_id: int = -1) -> Dictionary:
    return PHYSICS_LOS.trace(get_world_3d(), from_cell, to_cell, target_building_id)

func _position_camera() -> void:
    if camera == null:
        return
    camera.position = camera_center + Vector3(0.0, 124.0, 98.0)
    camera.look_at(camera_center, Vector3.UP)

func _unit_color(e: Dictionary) -> Color:
    var owner: int = int(e["owner"])
    var kind: String = str(e["kind"])
    if owner == 0:
        if kind == "hq":
            return Color("#2368b5")
        if kind == "barracks":
            return Color("#538fce")
        return Color("#9bd5ff") if kind == "worker" else Color("#2f9bc8")
    if kind == "hq":
        return Color("#9f442e")
    if kind == "barracks":
        return Color("#cb6745")
    return Color("#ffcf82") if kind == "worker" else Color("#ef8b5f")

func _unit_shape(e: Dictionary) -> Vector3:
    match str(e["kind"]):
        "hq":
            return Vector3(2.5, 3.0, 2.5)
        "barracks":
            return Vector3(2.0, 2.2, 2.0)
        "worker":
            return Vector3(0.75, 1.2, 0.75)
        _:
            return Vector3(0.95, 1.5, 0.95)

func _sync_visuals() -> void:
    for id in unit_nodes.keys():
        if not sim.entities.has(id):
            (unit_nodes[id] as Node).queue_free()
            unit_nodes.erase(id)
    for id in sim.sorted_ids():
        var e: Dictionary = sim.entities[id]
        if not unit_nodes.has(id):
            unit_nodes[id] = _unit_sprite(e)
        var v: Node3D = unit_nodes[id]
        var p: Vector2i = e["pos"]
        v.position = GEOM.tile_to_world(p)
        v.visible = spectator or int(e["owner"]) == 0 or sim.can_see(0, p)
    for sid in source_nodes.keys():
        var source: Dictionary = sim.sources[sid]
        (source_nodes[sid] as Node3D).visible = int(source["stock"]) > 0
    # Reconcile all selected references after unit death or production.
    var live_selection: Array[int] = []
    for id in selected_ids:
        if sim.entities.has(id) and int(sim.entities[id]["owner"]) == 0:
            live_selection.append(id)
    selected_ids = live_selection
    if not selected_ids.has(selected_id):
        selected_id = selected_ids.back() if not selected_ids.is_empty() else -1
    selection_marker.visible = selected_id >= 0 and sim.entities.has(selected_id)
    if selection_marker.visible:
        var focus: Vector2i = sim.entities[selected_id]["pos"]
        selection_marker.position = GEOM.tile_to_world(focus, 0.24)
        selection_marker.scale = Vector3(3.0, 1.0, 3.0) if GEOM.is_building(str(sim.entities[selected_id]["kind"])) else Vector3.ONE
    for id in group_markers.keys():
        if not selected_ids.has(id) or id == selected_id or not sim.entities.has(id):
            (group_markers[id] as Node).queue_free()
            group_markers.erase(id)
    for id in selected_ids:
        if id == selected_id:
            continue
        if not group_markers.has(id):
            group_markers[id] = _block(Vector3(2.1, 0.12, 2.1),
                Color("#92d8ff"), world_root)
        var p: Vector2i = sim.entities[id]["pos"]
        (group_markers[id] as Node3D).position = GEOM.tile_to_world(p, 0.24)
        (group_markers[id] as Node3D).scale = Vector3(3.0, 1.0, 3.0) if GEOM.is_building(str(sim.entities[id]["kind"])) else Vector3.ONE
    command_hud.refresh()

func _hud_command(action: String) -> void:
    if spectator or replay_mode or sim.finished or paused or not sim.entities.has(selected_id):
        return
    if action == "build_barracks":
        build_mode = true
        info = "Place Barracks on clear ground · Esc cancels"
    elif action == "stop":
        for id in selected_ids:
            sim.issue_command(0, "stop", id)
        info = "Selected units stopped"
    else:
        info = "Production queued" if sim.issue_command(0, action, selected_id) else "Order rejected: check Matter and production queue"
    _sync_visuals()

func _toggle_pause() -> void:
    if settings_overlay != null:
        return
    if pause_overlay != null:
        pause_overlay.queue_free()
        pause_overlay = null
        paused = false
        return
    paused = true
    drag_active = false
    selection_box.visible = false
    pause_overlay = Control.new()
    pause_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    command_hud.add_child(pause_overlay)
    var shade := ColorRect.new()
    shade.color = Color(0.02, 0.05, 0.08, 0.94)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    pause_overlay.add_child(shade)
    var center := CenterContainer.new()
    center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    pause_overlay.add_child(center)
    var choices := VBoxContainer.new()
    choices.custom_minimum_size.x = 360
    center.add_child(choices)
    choices.add_child(COMMAND_HUD.UI.label("REPLAY PAUSED" if replay_mode else "MATCH PAUSED", 28))
    if not spectator and not replay_mode:
        var save: Button = Button.new()
        save.name = "SaveReplay"
        save.text = "Save replay"
        save.custom_minimum_size.y = 48
        save.pressed.connect(_save_current_replay)
        choices.add_child(save)
        replay_save_status = COMMAND_HUD.UI.label("", 14)
        choices.add_child(replay_save_status)
    for entry in [["Resume", _toggle_pause], ["Settings", _match_settings], ["Return to main menu", func(): get_tree().change_scene_to_file(MENU_SCENE)]]:
        var button := Button.new()
        button.text = entry[0]
        button.custom_minimum_size.y = 48
        button.pressed.connect(entry[1])
        choices.add_child(button)
    # Focus actual Resume button; optional Save Replay may precede it.
    for item in choices.get_children():
        if item is Button and item.text == "Resume":
            item.grab_focus()
            break

func _save_current_replay() -> void:
    if spectator or replay_mode or sim == null:
        return
    var data: Dictionary = REPLAY_ARCHIVE.capture(sim)
    var path: String = REPLAY_ARCHIVE.save_user(data, "last-human-match")
    info = "Replay saved to user://replays/last-human-match.json" if not path.is_empty() else "Replay save failed"
    if replay_save_status != null:
        replay_save_status.text = info
    _sync_visuals()

func _match_settings() -> void:
    settings_overlay = load(MENU_SCENE).instantiate()
    command_hud.add_child(settings_overlay)
    settings_overlay._open_options()
    settings_overlay.settings_closed.connect(func():
        settings_overlay.queue_free()
        settings_overlay = null
        pause_overlay.visible = true)
    pause_overlay.visible = false

func _cell_at_mouse(screen_pos: Vector2) -> Vector2i:
    var ray_origin: Vector3 = camera.project_ray_origin(screen_pos)
    var ray_dir: Vector3 = camera.project_ray_normal(screen_pos)
    if absf(ray_dir.y) < 0.0001:
        return Vector2i(-1, -1)
    var distance: float = -ray_origin.y / ray_dir.y
    if distance < 0.0:
        return Vector2i(-1, -1)
    var point: Vector3 = ray_origin + ray_dir * distance
    return GEOM.world_to_tile(point)

func _entity_near(cell: Vector2i, owner_filter: int) -> int:
    var best: int = -1
    var best_distance: int = 2
    for id in sim.sorted_ids():
        var e: Dictionary = sim.entities[id]
        var owner: int = int(e["owner"])
        if owner != owner_filter:
            continue
        if owner == 1 and not sim.can_see(0, e["pos"]):
            continue
        var p: Vector2i = e["pos"]
        var d: int = sim._distance_to_entity(cell, e)
        if d < best_distance:
            best_distance = d
            best = id
    return best

func _resource_near(cell: Vector2i) -> String:
    for sid in sim.sources.keys():
        var s: Dictionary = sim.sources[sid]
        var p: Vector2i = s["pos"]
        if absi(p.x - cell.x) + absi(p.y - cell.y) <= 1 and int(s["stock"]) > 0:
            return str(sid)
    return ""

# These helpers are independent of InputEvents for headless smoke coverage.
func _select_click(cell: Vector2i, additive: bool = false) -> void:
    var hit: int = _entity_near(cell, 0)
    if not additive:
        selected_ids.clear()
    if hit >= 0:
        if additive and selected_ids.has(hit):
            selected_ids.erase(hit)
        elif not selected_ids.has(hit):
            selected_ids.append(hit)
    selected_id = selected_ids.back() if not selected_ids.is_empty() else -1

func _select_box(from_screen: Vector2, to_screen: Vector2,
        additive: bool = false) -> void:
    if not additive:
        selected_ids.clear()
    var low: Vector2 = Vector2(
        minf(from_screen.x, to_screen.x), minf(from_screen.y, to_screen.y))
    var high: Vector2 = Vector2(
        maxf(from_screen.x, to_screen.x), maxf(from_screen.y, to_screen.y))
    var selection_rect := Rect2(low, high - low)
    for id in sim.sorted_ids():
        var e: Dictionary = sim.entities[id]
        if int(e["owner"]) != 0:
            continue
        var p: Vector2i = e["pos"]
        var location: Vector3 = GEOM.tile_to_world(p, 1.6)
        if camera.is_position_behind(location):
            continue
        if selection_rect.has_point(camera.unproject_position(location)):
            if not selected_ids.has(id):
                selected_ids.append(id)
    selected_id = selected_ids.back() if not selected_ids.is_empty() else -1

func _issue_group_order(cell: Vector2i) -> int:
    var applied: int = 0
    var target: int = _entity_near(cell, 1)
    var source_id: String = _resource_near(cell)
    var chosen_destinations: Dictionary = {}
    for id in selected_ids:
        if not sim.entities.has(id) or int(sim.entities[id]["owner"]) != 0:
            continue
        var kind: String = str(sim.entities[id]["kind"])
        if target >= 0:
            if kind == "rifleman" and sim.issue_command(0, "attack", id, target):
                applied += 1
        elif source_id != "":
            if kind == "worker" and sim.issue_command(0, "gather", id, source_id):
                applied += 1
        elif kind in ["worker", "rifleman"]:
            # Distinct nearby arrival tiles; the authoritative command API
            # still checks bounds, movement legality and ownership.
            var accepted: bool = false
            for radius in range(6):
                if accepted:
                    break
                for dy in range(-radius, radius + 1):
                    if accepted:
                        break
                    for dx in range(-radius, radius + 1):
                        if maxi(absi(dx), absi(dy)) != radius:
                            continue
                        var destination: Vector2i = cell + Vector2i(dx, dy)
                        if chosen_destinations.has(destination) or sim._blocked(destination):
                            continue
                        if sim.issue_command(0, "move", id, destination):
                            chosen_destinations[destination] = id
                            applied += 1
                            accepted = true
                            break
    return applied

func _unhandled_input(event: InputEvent) -> void:
    if paused and not (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE):
        return
    if replay_mode and event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_ESCAPE:
            _toggle_pause()
        elif event.is_action_pressed("rts_speed_up"):
            speed = mini(16, speed + 1)
        elif event.is_action_pressed("rts_speed_down"):
            speed = maxi(1, speed - 1)
        return
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_ESCAPE:
            if build_mode:
                build_mode = false
                info = "Barracks placement cancelled"
            else:
                _toggle_pause()
            return
        if event.is_action_pressed("rts_pause"):
            if spectator:
                speed = 0 if speed != 0 else 1
        elif event.is_action_pressed("rts_speed_up"):
            speed = mini(16, speed + 1)
        elif event.is_action_pressed("rts_speed_down"):
            speed = maxi(1, speed - 1)
        elif event.is_action_pressed("rts_build_barracks"):
            if not spectator and sim.entities.has(selected_id) and str(sim.entities[selected_id]["kind"]) == "worker":
                build_mode = true
                info = "Choose Barracks location with left click"
        elif event.is_action_pressed("rts_train_worker"):
            if not spectator and sim.entities.has(selected_id):
                info = "Worker queued" if sim.issue_command(0, "train_worker", selected_id) else "Cannot train Worker"
        elif event.is_action_pressed("rts_train_rifleman"):
            if not spectator and sim.entities.has(selected_id):
                info = "Rifleman queued" if sim.issue_command(0, "train_rifleman", selected_id) else "Cannot train Rifleman"
    elif event is InputEventMouseButton:
        if event.pressed and event.button_index in [
                MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
            zoom_size = clampf(
                zoom_size * (0.88 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1.12),
                48.0, 192.0)
            camera.size = zoom_size
            return
        if spectator or replay_mode:
            return
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                drag_start = event.position
                drag_active = true
                drag_moved = false
            elif drag_active:
                drag_active = false
                selection_box.visible = false
                var cell: Vector2i = _cell_at_mouse(event.position)
                if build_mode and sim.entities.has(selected_id):
                    if sim._in_bounds(cell):
                        info = "Barracks ordered" if sim.issue_command(
                            0, "build_barracks", selected_id, cell
                        ) else "Invalid site or insufficient Matter"
                    build_mode = false
                elif drag_moved:
                    _select_box(drag_start, event.position,
                        Input.is_key_pressed(KEY_SHIFT))
                elif sim._in_bounds(cell):
                    _select_click(cell, Input.is_key_pressed(KEY_SHIFT))
                _sync_visuals()
        elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            var destination: Vector2i = _cell_at_mouse(event.position)
            if sim._in_bounds(destination):
                var count: int = _issue_group_order(destination)
                info = "%d unit order(s) accepted" % count
                _sync_visuals()
    elif event is InputEventMouseMotion and drag_active and not spectator and not replay_mode:
        if drag_start.distance_to(event.position) > 8.0:
            drag_moved = true
        if drag_moved and not build_mode:
            var p: Vector2 = event.position
            selection_box.position = Vector2(
                minf(drag_start.x, p.x), minf(drag_start.y, p.y))
            selection_box.size = Vector2(
                absf(drag_start.x - p.x), absf(drag_start.y - p.y))
            selection_box.visible = true

func _process(delta: float) -> void:
    if paused:
        return
    var shift := Vector3.ZERO
    if not spectator:
        shift.x = Input.get_axis("rts_pan_left", "rts_pan_right")
        shift.z = Input.get_axis("rts_pan_up", "rts_pan_down")
    if shift.length_squared() > 0.0:
        camera_center += shift.normalized() * delta * 36.0
        camera_center.x = clampf(camera_center.x, 24.0, 104.0)
        camera_center.z = clampf(camera_center.z, 24.0, 104.0)
        _position_camera()
    if not sim.finished and speed > 0:
        time_accumulator += delta * float(speed)
        var steps: int = 0
        while time_accumulator >= TIMING.TICK_SECONDS and steps < 32:
            if replay_mode:
                if replay_session == null or replay_session.sim == null:
                    speed = 0
                    break
                var frame: Dictionary = replay_session.step()
                if not bool(frame.get("ok", false)):
                    speed = 0
                    info = "REPLAY DIVERGED: " + str(frame.get("reason", "unknown"))
                    steps += 1
                    break
                if bool(frame.get("complete", false)):
                    speed = 0
                    info = "REPLAY VERIFIED  ·  " + str(frame.get("hash", "")).substr(0, 12)
                    steps += 1
                    break
            else:
                sim.advance()
            time_accumulator -= TIMING.TICK_SECONDS
            steps += 1
        if steps > 0:
            _sync_visuals()
