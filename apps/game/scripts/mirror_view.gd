extends Node3D

# First playable visualization of MVP 0.1's shared authoritative MAN rules.
# This is local Human-vs-Bot / Bot-vs-Bot; LAN Human-vs-Human is a later gate.
const MATCH = preload("res://scripts/mirror_match_state.gd")
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
var camera_center: Vector3 = Vector3(32.0, 0.0, 32.0)

func _ready() -> void:
    sim = MATCH.new()
    var mode: String = str(ProjectSettings.get_setting("scalfagus/mirror_mode", "human_bot"))
    spectator = mode == "bot_bot"
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

    for cell in sim.terrain.keys():
        var kind: String = str(sim.terrain[cell])
        var tile: MeshInstance3D
        if kind == "tree":
            tile = _block(Vector3(0.72, 2.5, 0.72), Color("#163e32"), world_root)
            tile.position = Vector3(float(cell.x), 1.25, float(cell.y))
        else:
            tile = _block(Vector3(1.0, 0.07, 1.0), Color("#296d9d"), world_root)
            tile.position = Vector3(float(cell.x), 0.04, float(cell.y))

    for sid in sim.sources.keys():
        var source: Dictionary = sim.sources[sid]
        var crystal := _block(Vector3(1.25, 0.7, 1.25), Color("#e6be57"), world_root)
        var p: Vector2i = source["pos"]
        crystal.position = Vector3(p.x, 0.38, p.y)
        source_nodes[sid] = crystal

    camera = Camera3D.new()
    camera.projection = Camera3D.PROJECTION_ORTHOGONAL
    camera.size = 78.0
    camera.far = 300.0
    camera.current = true
    add_child(camera)
    _position_camera()

    selection_marker = _block(Vector3(1.65, 0.08, 1.65), Color("#f5f18d"), world_root)
    selection_marker.visible = false

    var ui := CanvasLayer.new()
    add_child(ui)
    hud = Label.new()
    hud.position = Vector2(12, 8)
    hud.add_theme_color_override("font_color", Color.WHITE)
    hud.add_theme_font_size_override("font_size", 18)
    ui.add_child(hud)
    help_label = Label.new()
    help_label.position = Vector2(12, 62)
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
            unit_nodes[id] = _block(_unit_shape(e), _unit_color(e), world_root)
        var v: MeshInstance3D = unit_nodes[id]
        var p: Vector2i = e["pos"]
        v.position = Vector3(p.x, _unit_shape(e).y * 0.5, p.y)
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
        "Left click select / Right click move, gather or attack / B then click: Barracks / W: Worker at HQ / R: Rifleman at Barracks / WASD camera / Esc menu"
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
        while time_accumulator >= 0.1 and steps < 32:
            sim.advance()
            time_accumulator -= 0.1
            steps += 1
        if steps > 0:
            _sync_visuals()
