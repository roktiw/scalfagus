extends Node3D

# First playable visualization of MVP 0.1's shared authoritative MAN rules.
# This is local Human-vs-Bot / Bot-vs-Bot; LAN Human-vs-Human is a later gate.
const MATCH = preload("res://scripts/mirror_match_state.gd")
const TIMING = preload("res://scripts/mirror_timing.gd")
const VIEW_SCRIPT = preload("res://scripts/directional_sprite_5.gd")
const WORKER_ATLAS = preload("res://assets/man_worker_32x48_idle_5view.png")
const LANDER_ATLAS = preload("res://assets/man_lander_128x128_unverified_5view.png")
const TREE_ATLAS = preload("res://assets/neutral_tree_40x64_5view.png")
const ROCK_ATLAS = preload("res://assets/neutral_rock_56x36_5view.png")
const MENU_SCENE: String = "res://scenes/menu.tscn"

var sim
var camera: Camera3D
var world_root: Node3D
var unit_nodes: Dictionary = {}
var source_nodes: Dictionary = {}
var selected_id: int = -1
var build_mode: bool = false
var spectator: bool = false
var time_accumulator: float = 0.0
var speed: int = 1
var hud: Label
var help_label: Label
var selection_marker: MeshInstance3D
var info: String = ""
var camera_center: Vector3 = Vector3(17.0, 0.0, 17.0)
var zoom_size: float = 50.0

func _ready() -> void:
    sim = MATCH.new()
    var mode: String = str(ProjectSettings.get_setting("scalfagus/mirror_mode", "human_bot"))
    spectator = mode == "bot_bot"
    if spectator:
        camera_center = Vector3(31.5, 0.0, 31.5)
        zoom_size = 76.0
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
    var visual: DirectionalSprite5 = VIEW_SCRIPT.new()
    visual.name = "Visual"
    root.add_child(visual)
    visual.configure(atlas, frame_size, 1, root, pixel_scale, mirror_safe)
    visual.sprite.modulate = tint
    return root

func _unit_sprite(e: Dictionary) -> Node3D:
    var kind: String = str(e["kind"])
    var blue: bool = int(e["owner"]) == 0
    if kind == "hq":
        return _pixel_actor(LANDER_ATLAS, Vector2i(128, 128), 0.038,
            Color(0.85, 0.98, 1.0) if blue else Color(1.0, 0.77, 0.70))
    if kind == "barracks":
        # Existing lander sprite temporarily represents a Barracks until dedicated art.
        return _pixel_actor(LANDER_ATLAS, Vector2i(128, 128), 0.027,
            Color(0.58, 0.81, 1.0) if blue else Color(1.0, 0.64, 0.50))
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
    var underdeck := _block(Vector3(67.0, 1.5, 67.0), Color("#25314b"), world_root)
    underdeck.position = Vector3(31.5, -1.2, 31.5)
    var ground := _block(Vector3(64.0, 0.4, 64.0), Color("#526c4d"), world_root)
    ground.position = Vector3(31.5, -0.28, 31.5)

    # Cosmetic rim reinforces the mandatory floating-platform world rule.
    for edge in range(4):
        var rim_size := Vector3(65.0, 1.0, 0.65) if edge < 2 else Vector3(0.65, 1.0, 65.0)
        var rim := _block(rim_size, Color("#8498b1"), world_root)
        if edge == 0:
            rim.position = Vector3(31.5, 0.02, -0.5)
        elif edge == 1:
            rim.position = Vector3(31.5, 0.02, 63.5)
        elif edge == 2:
            rim.position = Vector3(-0.5, 0.02, 31.5)
        else:
            rim.position = Vector3(63.5, 0.02, 31.5)

    # Gameplay obstruction lives in the Simulation Core. Pixel art is visual only.
    for cell in sim.terrain.keys():
        var kind: String = str(sim.terrain[cell])
        if kind == "tree":
            var tree_sprite: Node3D = _pixel_actor(
                TREE_ATLAS, Vector2i(40, 64), 0.052, Color.WHITE, true)
            tree_sprite.position = Vector3(float(cell.x), 0.0, float(cell.y))
        else:
            var pond := _block(Vector3(1.0, 0.07, 1.0),
                Color("#296d9d"), world_root)
            pond.position = Vector3(float(cell.x), 0.04, float(cell.y))

    for sid in sim.sources.keys():
        var source: Dictionary = sim.sources[sid]
        var ore: Node3D = _pixel_actor(
            ROCK_ATLAS, Vector2i(56, 36), 0.040, Color(1.0, 0.88, 0.57))
        var p: Vector2i = source["pos"]
        ore.position = Vector3(float(p.x), 0.0, float(p.y))
        source_nodes[sid] = ore

    camera = Camera3D.new()
    camera.projection = Camera3D.PROJECTION_ORTHOGONAL
    camera.size = zoom_size
    camera.far = 300.0
    camera.current = true
    add_child(camera)
    _position_camera()

    selection_marker = _block(Vector3(1.65, 0.08, 1.65), Color("#f5f18d"), world_root)
    selection_marker.visible = false

    var ui := CanvasLayer.new()
    add_child(ui)
    hud = Label.new()
    hud.position = Vector2(16, 12)
    hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
    hud.add_theme_color_override("font_color", Color.WHITE)
    hud.add_theme_font_size_override("font_size", 18)
    ui.add_child(hud)
    help_label = Label.new()
    help_label.position = Vector2(16, 56)
    help_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    help_label.add_theme_color_override("font_color", Color("#f5e6b2"))
    help_label.add_theme_font_size_override("font_size", 14)
    ui.add_child(help_label)

func _position_camera() -> void:
    if camera == null:
        return
    camera.position = camera_center + Vector3(0.0, 62.0, 49.0)
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
        v.position = Vector3(float(p.x), 0.0, float(p.y))
        v.visible = spectator or int(e["owner"]) == 0 or sim.can_see(0, p)
    for sid in source_nodes.keys():
        var source: Dictionary = sim.sources[sid]
        (source_nodes[sid] as Node3D).visible = int(source["stock"]) > 0
    selection_marker.visible = selected_id >= 0 and sim.entities.has(selected_id)
    if selection_marker.visible:
        var p: Vector2i = sim.entities[selected_id]["pos"]
        selection_marker.position = Vector3(p.x, 0.12, p.y)
    var selected_text: String = "None"
    if selected_id >= 0 and sim.entities.has(selected_id):
        var chosen: Dictionary = sim.entities[selected_id]
        selected_text = "%s #%d HP:%d (%s)" % [
            str(chosen["kind"]).to_upper(), selected_id, int(chosen["hp"]), str(chosen["order"])
        ]
    var result_text: String = ""
    if sim.finished:
        result_text = " | FINISHED: %s — %s" % [
            "DRAW" if sim.winner < 0 else "PLAYER %d WINS" % (sim.winner + 1), sim.finish_reason
        ]
    hud.text = "SCALFAGUS MVP 0.1  |  MAN vs MAN  |  %s  |  Tick %d  |  Matter %d  |  Speed x%d%s" % [
        "BOT vs BOT" if spectator else "HUMAN vs BOT",
        sim.tick, int(sim.players[0]["matter"]), speed, result_text
    ]
    help_label.text = "Selected: %s  |  %s\n%s" % [
        selected_text, info,
        "P pause / +/- speed / Esc menu" if spectator else
        "Left click select / Right click move, gather or attack / B then click: Barracks / W: Worker at HQ / R: Rifleman at Barracks / WASD pan / Mouse wheel zoom / Esc menu"
    ]

func _cell_at_mouse(screen_pos: Vector2) -> Vector2i:
    var ray_origin: Vector3 = camera.project_ray_origin(screen_pos)
    var ray_dir: Vector3 = camera.project_ray_normal(screen_pos)
    if absf(ray_dir.y) < 0.0001:
        return Vector2i(-1, -1)
    var distance: float = -ray_origin.y / ray_dir.y
    if distance < 0.0:
        return Vector2i(-1, -1)
    var point: Vector3 = ray_origin + ray_dir * distance
    return Vector2i(roundi(point.x), roundi(point.z))

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
        var d: int = absi(p.x - cell.x) + absi(p.y - cell.y)
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

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_ESCAPE:
                get_tree().change_scene_to_file(MENU_SCENE)
                return
            KEY_P:
                if spectator:
                    speed = 0 if speed != 0 else 1
            KEY_EQUAL, KEY_KP_ADD:
                speed = mini(16, speed + 1)
            KEY_MINUS, KEY_KP_SUBTRACT:
                speed = maxi(1, speed - 1)
            KEY_B:
                if not spectator and sim.entities.has(selected_id) and str(sim.entities[selected_id]["kind"]) == "worker":
                    build_mode = true
                    info = "Choose Barracks location with left click"
            KEY_W:
                if not spectator and sim.entities.has(selected_id):
                    info = "Worker queued" if sim.issue_command(0, "train_worker", selected_id) else "Cannot train Worker"
            KEY_R:
                if not spectator and sim.entities.has(selected_id):
                    info = "Rifleman queued" if sim.issue_command(0, "train_rifleman", selected_id) else "Cannot train Rifleman"
    elif event is InputEventMouseButton and event.pressed and event.button_index in [
            MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
        zoom_size = clampf(
            zoom_size * (0.88 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1.12),
            24.0, 96.0)
        camera.size = zoom_size
    elif event is InputEventMouseButton and event.pressed and not spectator:
        if event.button_index not in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
            return
        var cell: Vector2i = _cell_at_mouse(event.position)
        if not sim._in_bounds(cell):
            return
        if event.button_index == MOUSE_BUTTON_LEFT:
            if build_mode and sim.entities.has(selected_id):
                info = "Barracks ordered" if sim.issue_command(0, "build_barracks", selected_id, cell) else "Invalid site or insufficient Matter"
                build_mode = false
            else:
                selected_id = _entity_near(cell, 0)
        elif selected_id >= 0 and sim.entities.has(selected_id):
            var kind: String = str(sim.entities[selected_id]["kind"])
            var source_id: String = _resource_near(cell)
            var enemy: int = _entity_near(cell, 1)
            if kind == "worker" and source_id != "":
                info = "Gathering" if sim.issue_command(0, "gather", selected_id, source_id) else "Cannot gather"
            elif kind == "rifleman" and enemy >= 0 and int(sim.entities[enemy]["owner"]) == 1:
                info = "Attacking" if sim.issue_command(0, "attack", selected_id, enemy) else "Invalid attack"
            else:
                info = "Moving" if sim.issue_command(0, "move", selected_id, cell) else "Invalid move"
        _sync_visuals()

func _process(delta: float) -> void:
    var shift := Vector3.ZERO
    if not spectator:
        shift.x = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
        shift.z = float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
    if shift.length_squared() > 0.0:
        camera_center += shift.normalized() * delta * 18.0
        camera_center.x = clampf(camera_center.x, 12.0, 52.0)
        camera_center.z = clampf(camera_center.z, 12.0, 52.0)
        _position_camera()
    if not sim.finished and speed > 0:
        time_accumulator += delta * float(speed)
        var steps: int = 0
        while time_accumulator >= TIMING.TICK_SECONDS and steps < 32:
            sim.advance()
            time_accumulator -= TIMING.TICK_SECONDS
            steps += 1
        if steps > 0:
            _sync_visuals()
