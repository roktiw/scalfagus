extends Node3D

# Scalfagus — scene-scale technical spike, not a full RTS.
# Real rolling terrain, one hero body, five-source-view sprites, three cameras.
# Controls: F1 Overlord, F2 Direct/TPP, F3 FPS, Tab next, Q/E orbit,
# right-mouse drag to orbit, wheel zoom, WASD Direct/FPS, Esc free cursor,
# F9 alternate window profile. No second world is created.

const HERO_SCRIPT = preload("res://scripts/hero.gd")
const VIEW_SCRIPT = preload("res://scripts/directional_sprite_5.gd")
const WORKER_TEXTURE = preload("res://assets/man_worker_32x48_idle_5view.png")
const WORKER_WALK_REFERENCE = preload("res://assets/man_worker_32x48_walk_reference_5view.png")
const LANDER_TEXTURE = preload("res://assets/man_lander_128x128_unverified_5view.png")
const TREE_TEXTURE = preload("res://assets/neutral_tree_40x64_5view.png")
const ROCK_TEXTURE = preload("res://assets/neutral_rock_56x36_5view.png")
const MAP_HALF: int = 64
const CAMERA_PAN_SPEED: float = 15.0
const CAMERA_ZOOM_MIN: float = 8.0
const CAMERA_ZOOM_MAX: float = 68.0


const OVERLORD = 0
const DIRECT = 1
const FPS = 2

var view_mode: int = OVERLORD
var orbit_yaw: float = deg_to_rad(36.0)
var orbit_pitch: float = deg_to_rad(49.0)
var fps_pitch: float = 0.0
var zoom_distance: float = 20.0
var camera: Camera3D
var hero: PrototypeHero
var hud: Label
var reticle: Label
var terrain: MeshInstance3D
var test_props: Array[Node3D] = []
var window_size_index: int = 0
const WINDOW_PROFILES: Array[Vector2i] = [Vector2i(960, 540), Vector2i(640, 360), Vector2i(320, 240)]
var dragging_orbit: bool = false
var elapsed: float = 0.0
var camera_focus: Vector3 = Vector3(-41.0, 0.0, -41.0)
var selected_units: Array[Node3D] = []
var selectable_units: Array[Node3D] = []
var drag_origin: Vector2 = Vector2.ZERO
var drag_active: bool = false
var drag_moved: bool = false
var selection_box: ColorRect
var unit_hud: Label
var resource_hud: Label
var tactical_hud: Label
var world_buildings: Array[Node3D] = []
var solids: int = 150
var map_name: String = "VERDANT DIVIDE · PROTOTYPE"


func _ready() -> void:
    _make_environment()
    _make_terrain()
    _make_test_entities()
    _make_camera_and_hud()
    _apply_mode(OVERLORD)
    _refresh_hud()

func _make_environment() -> void:
    var world_environment: WorldEnvironment = WorldEnvironment.new()
    world_environment.name = "Atmosphere"
    var env: Environment = Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color("#829DB0")
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color("#C1D2DD")
    env.ambient_light_energy = 0.85
    world_environment.environment = env
    add_child(world_environment)

    var light: DirectionalLight3D = DirectionalLight3D.new()
    light.name = "Sunlight"
    light.rotation_degrees = Vector3(-54, -35, 0)
    light.light_energy = 1.2
    light.shadow_enabled = true
    add_child(light)

func height_at(x: float, z: float) -> float:
    # Deterministic undulating 3D height field; no voxel/tunneling yet.
    return sin(x * 0.21) * cos(z * 0.19) * 0.62 + sin(z * 0.33) * 0.25

func _make_terrain() -> void:
    terrain = MeshInstance3D.new()
    terrain.name = "Terrain"
    add_child(terrain)
    var surface: SurfaceTool = SurfaceTool.new()
    surface.begin(Mesh.PRIMITIVE_TRIANGLES)
    for x in range(-MAP_HALF, MAP_HALF):
        for z in range(-MAP_HALF, MAP_HALF):
            var a: Vector3 = Vector3(x, height_at(x, z), z)
            var b: Vector3 = Vector3(x + 1, height_at(x + 1, z), z)
            var c: Vector3 = Vector3(x, height_at(x, z + 1), z + 1)
            var d: Vector3 = Vector3(x + 1, height_at(x + 1, z + 1), z + 1)
            var color: Color = _tile_color(x, z, (a.y + b.y + c.y + d.y) * 0.25)
            for vertex in [a, c, b, b, c, d]:
                surface.set_color(color)
                surface.add_vertex(vertex)
    surface.generate_normals()
    var mesh: ArrayMesh = surface.commit()
    terrain.mesh = mesh
    var material: StandardMaterial3D = StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.roughness = 1.0
    terrain.material_override = material

    var ground: StaticBody3D = StaticBody3D.new()
    ground.name = "TerrainCollider"
    ground.collision_layer = 1
    ground.collision_mask = 0
    var collision: CollisionShape3D = CollisionShape3D.new()
    var shape: ConcavePolygonShape3D = ConcavePolygonShape3D.new()
    shape.set_faces(mesh.get_faces())
    collision.shape = shape
    ground.add_child(collision)
    add_child(ground)

func _tile_color(x: int, z: int, altitude: float) -> Color:
    var checker: bool = posmod(x * 3 + z * 7, 9) < 2
    if altitude > 0.46:
        return Color("#A1A7A0") if checker else Color("#8F958E")
    if altitude < -0.46:
        return Color("#4D6B70") if checker else Color("#527477")
    return Color("#647B6F") if checker else Color("#748A76")

func _make_test_entities() -> void:
    # Fixed, simplified 128m square prototype of the authored Verdant Divide
    # 64x64, 2m tile design. Data/YAML rasterization is the next milestone.
    hero = HERO_SCRIPT.new()
    hero.setup(WORKER_TEXTURE, WORKER_WALK_REFERENCE,
        Vector3(-41.0, height_at(-41.0, -41.0) + 1.2, -41.0))
    hero.unit_name = "MAN Hero"
    add_child(hero)
    selectable_units.append(hero)
    hero.set_selected(true)
    selected_units.append(hero)
    _make_static_sprite("Lander", LANDER_TEXTURE, Vector2i(128, 128),
        Vector2(-47, -47), Vector3(5.3, 3.8, 4.8), 0.040, false)
    _make_building("MAN_UMU", Vector2(-34, -44), Vector3(3.0, 2.3, 3.0),
        Color("#d5ae69"), "man", "UMU · Power / Storage")
    _make_building("ETH_Nexus", Vector2(45, 45), Vector3(7.0, 4.4, 7.0),
        Color("#64e0de"), "eth", "ETH Nexus")
    _make_building("ETH_Pylon", Vector2(36, 42), Vector3(1.8, 5.0, 1.8),
        Color("#76bfe6"), "eth", "ETH Network Pylon")
    for n in range(3):
        var npc: PrototypeHero = HERO_SCRIPT.new()
        npc.setup(WORKER_TEXTURE, WORKER_WALK_REFERENCE,
            Vector3(-39.0 + float(n)*2.0, height_at(-39.0 + float(n)*2.0, -37.0) + 1.2, -37.0))
        npc.name = "MAN_Worker_%02d" % (n + 1)
        npc.entity_id = "man.scv.%02d" % (n + 1)
        npc.unit_name = "MAN Worker / SCV"
        add_child(npc)
        selectable_units.append(npc)
    # Original sprite research is MAN-only. Opposing ETH uses openly marked
    # geometry placeholders until a real five-view ETH atlas is approved.
    for n in range(3):
        _make_eth_placeholder(n, Vector2(41.0 + float(n) * 2.0, 38.0))
    # Fixed jungle trunks provide real collision/physical cover in this spike.
    var jungle: Array[Vector2] = [
        Vector2(-23,-34),Vector2(-16,-29),Vector2(-7,-28),Vector2(13,-30),
        Vector2(24,-34),Vector2(-30,-7),Vector2(-25,8),Vector2(-12,17),
        Vector2(5,19),Vector2(26,9),Vector2(31,21),Vector2(-30,29),
        Vector2(-19,33),Vector2(13,34),Vector2(26,37),Vector2(10,-12),
        Vector2(-14,-12),Vector2(4,4),Vector2(29,-5),Vector2(-7,31)]
    for i in range(jungle.size()):
        _make_static_sprite("Tree_%02d" % i, TREE_TEXTURE, Vector2i(40, 64),
            jungle[i], Vector3(0.9, 3.2, 0.9), 0.051, true)
    for i in range(12):
        var loc: Vector2 = Vector2(-28 + (i * 17) % 58, -21 + (i * 29) % 51)
        _make_static_sprite("Rock_%02d" % i, ROCK_TEXTURE, Vector2i(56, 36),
            loc, Vector3(2.1, 1.35, 2.0), 0.041, false)
    _make_water(Vector2(-4, -24), 9.0)
    _make_water(Vector2(3, 25), 8.0)

func _make_building(label: String, location: Vector2, size: Vector3,
        color: Color, faction: String, kind: String) -> void:
    var body: StaticBody3D = StaticBody3D.new()
    body.name = label
    body.collision_layer = 4
    body.position = Vector3(location.x, height_at(location.x, location.y), location.y)
    var collision: CollisionShape3D = CollisionShape3D.new()
    var shape: BoxShape3D = BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    collision.position.y = size.y * 0.5
    body.add_child(collision)
    var mesh: MeshInstance3D = MeshInstance3D.new()
    var block: BoxMesh = BoxMesh.new()
    block.size = size
    mesh.mesh = block
    mesh.position.y = size.y * 0.5
    var material: StandardMaterial3D = StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 1.0
    mesh.material_override = material
    body.add_child(mesh)
    body.set_meta("faction", faction)
    body.set_meta("unit_name", kind)
    body.set_meta("hp", 400)
    body.set_meta("selectable", true)
    add_child(body)
    world_buildings.append(body)
    if faction == "man":
        selectable_units.append(body)

func _make_eth_placeholder(n: int, location: Vector2) -> void:
    var body: StaticBody3D = StaticBody3D.new()
    body.name = "ETH_Sentinel_%02d" % n
    body.collision_layer = 4
    body.position = Vector3(location.x, height_at(location.x, location.y), location.y)
    var shape: SphereShape3D = SphereShape3D.new()
    shape.radius = 0.85
    var collider: CollisionShape3D = CollisionShape3D.new()
    collider.shape = shape
    collider.position.y = 0.85
    body.add_child(collider)
    var mesh: MeshInstance3D = MeshInstance3D.new()
    var sphere: SphereMesh = SphereMesh.new()
    sphere.radius = 0.72
    sphere.height = 1.44
    mesh.mesh = sphere
    mesh.position.y = 0.85
    var material: StandardMaterial3D = StandardMaterial3D.new()
    material.albedo_color = Color("#80d9ed")
    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    mesh.material_override = material
    body.add_child(mesh)
    body.set_meta("faction", "eth")
    body.set_meta("unit_name", "ETH Sentinel / placeholder")
    add_child(body)

func _make_water(center: Vector2, radius: float) -> void:
    var body: StaticBody3D = StaticBody3D.new()
    body.name = "Water_%s" % str(int(center.x))
    body.collision_layer = 4
    body.position = Vector3(center.x, -0.10, center.y)
    var collision: CollisionShape3D = CollisionShape3D.new()
    var shape: CylinderShape3D = CylinderShape3D.new()
    shape.radius = radius
    shape.height = 0.35
    collision.shape = shape
    body.add_child(collision)
    var mesh: MeshInstance3D = MeshInstance3D.new()
    var disc: CylinderMesh = CylinderMesh.new()
    disc.top_radius = radius
    disc.bottom_radius = radius
    disc.height = 0.07
    mesh.mesh = disc
    var material: StandardMaterial3D = StandardMaterial3D.new()
    material.albedo_color = Color("#277f9e")
    material.roughness = 0.3
    mesh.material_override = material
    body.add_child(mesh)
    add_child(body)

func _make_static_sprite(
    label: String, texture: Texture2D, dimensions: Vector2i,
    location: Vector2, collider_size: Vector3,
    pixel_scale: float, mirror_safe: bool
) -> void:
    var body: StaticBody3D = StaticBody3D.new()
    body.name = label
    body.collision_layer = 4
    body.collision_mask = 0
    body.position = Vector3(location.x, height_at(location.x, location.y), location.y)
    var shape: BoxShape3D = BoxShape3D.new()
    shape.size = collider_size
    var collider: CollisionShape3D = CollisionShape3D.new()
    collider.name = "Collider"
    collider.shape = shape
    collider.position = Vector3(0.0, collider_size.y * 0.5, 0.0)
    body.add_child(collider)
    add_child(body)

    var visual: DirectionalSprite5 = VIEW_SCRIPT.new()
    visual.name = "Visual"
    body.add_child(visual)
    visual.configure(texture, dimensions, 1, body, pixel_scale, mirror_safe)
    test_props.append(body)
    if label == "Lander":
        body.set_meta("selectable", true)
        body.set_meta("faction", "man")
        body.set_meta("unit_name", "MAN Command Core / Lander")
        body.set_meta("hp", 550)
        selectable_units.append(body)
        world_buildings.append(body)

func _make_camera_and_hud() -> void:
    camera = Camera3D.new()
    camera.name = "UnifiedCamera"
    camera.current = true
    camera.near = 0.07
    camera.far = 150.0
    add_child(camera)

    var layer: CanvasLayer = CanvasLayer.new()
    layer.name = "HUD"
    add_child(layer)
    var label_background: ColorRect = ColorRect.new()
    label_background.name = "HudBackdrop"
    label_background.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
    label_background.custom_minimum_size = Vector2(0, 102)
    label_background.color = Color(0.03, 0.08, 0.12, 0.76)
    label_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(label_background)
    hud = Label.new()
    hud.name = "Instructions"
    hud.position = Vector2(12, 7)
    hud.add_theme_font_size_override("font_size", 15)
    hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(hud)
    var side: ColorRect = ColorRect.new()
    side.name = "SidePanel"
    side.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
    side.offset_left = -240
    side.offset_top = -140
    side.offset_right = -12
    side.offset_bottom = -12
    side.color = Color(0.025, 0.075, 0.10, 0.85)
    side.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(side)
    unit_hud = Label.new()
    unit_hud.name = "SelectedUnitHud"
    unit_hud.position = Vector2(6, 6)
    unit_hud.add_theme_font_size_override("font_size", 13)
    side.add_child(unit_hud)
    unit_hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
    resource_hud = Label.new()
    resource_hud.name = "ResourceHud"
    resource_hud.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
    resource_hud.offset_left = -230
    resource_hud.offset_top = 10
    resource_hud.offset_right = -10
    resource_hud.offset_bottom = 66
    resource_hud.add_theme_font_size_override("font_size", 14)
    layer.add_child(resource_hud)
    resource_hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
    selection_box = ColorRect.new()
    selection_box.name = "SelectionMarquee"
    selection_box.visible = false
    selection_box.color = Color(0.12, 0.68, 0.96, 0.2)
    selection_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(selection_box)
    reticle = Label.new()
    reticle.name = "Crosshair"
    reticle.text = "+"
    reticle.add_theme_font_size_override("font_size", 28)
    reticle.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    reticle.offset_left = -8
    reticle.offset_top = -14
    reticle.offset_right = 16
    reticle.offset_bottom = 20
    reticle.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(reticle)

func _apply_mode(new_mode: int) -> void:
    view_mode = new_mode
    camera.projection = Camera3D.PROJECTION_ORTHOGONAL if view_mode == OVERLORD else Camera3D.PROJECTION_PERSPECTIVE
    camera.fov = 72.0
    hero.set_local_fps_hidden(view_mode == FPS)
    hero.controlled = view_mode != OVERLORD
    hero.desired_movement = Vector3.ZERO
    if view_mode == FPS:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    else:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    _update_camera(0.0)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_F1: _apply_mode(OVERLORD)
            KEY_F2: _apply_mode(DIRECT)
            KEY_F3: _apply_mode(FPS)
            KEY_TAB: _apply_mode((view_mode + 1) % 3)
            KEY_F9:
                window_size_index = (window_size_index + 1) % WINDOW_PROFILES.size()
                get_window().size = WINDOW_PROFILES[window_size_index]
            KEY_ESCAPE:
                if view_mode == FPS and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
                    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
                else:
                    get_tree().change_scene_to_file("res://scenes/menu.tscn")
    if event is InputEventMouseButton:
        if view_mode == OVERLORD:
            if event.button_index == MOUSE_BUTTON_LEFT:
                if event.pressed:
                    drag_origin = event.position
                    drag_moved = false
                    drag_active = true
                elif drag_active:
                    drag_active = false
                    selection_box.visible = false
                    var additive: bool = Input.is_key_pressed(KEY_SHIFT)
                    if drag_moved:
                        _select_box(drag_origin, event.position, additive)
                    else:
                        _select_click(event.position, additive)
            if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
                _issue_context_command(event.position)
        if event.button_index == MOUSE_BUTTON_MIDDLE:
            dragging_orbit = event.pressed
        if event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
            zoom_distance = maxf(CAMERA_ZOOM_MIN, zoom_distance * 0.89)
        if event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            zoom_distance = minf(CAMERA_ZOOM_MAX, zoom_distance * 1.12)
    if event is InputEventMouseMotion:
        if view_mode == FPS and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            orbit_yaw -= event.relative.x * 0.003
            fps_pitch = clampf(fps_pitch - event.relative.y * 0.003, -1.1, 1.1)
        elif dragging_orbit:
            orbit_yaw -= event.relative.x * 0.006
            orbit_pitch = clampf(orbit_pitch + event.relative.y * 0.005, 0.18, 1.32)
        elif drag_active and view_mode == OVERLORD:
            if drag_origin.distance_to(event.position) >= 8.0:
                drag_moved = true
            if drag_moved:
                selection_box.visible = true
                selection_box.position = Vector2(minf(drag_origin.x, event.position.x), minf(drag_origin.y, event.position.y))
                selection_box.size = Vector2(absf(drag_origin.x-event.position.x), absf(drag_origin.y-event.position.y))

func _raycast(screen_point: Vector2) -> Dictionary:
    var start: Vector3 = camera.project_ray_origin(screen_point)
    var end: Vector3 = start + camera.project_ray_normal(screen_point) * 250.0
    var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start, end)
    query.collision_mask = 1 | 2 | 4
    return get_world_3d().direct_space_state.intersect_ray(query)

func _raycast_ground(screen_point: Vector2) -> Dictionary:
    var start: Vector3 = camera.project_ray_origin(screen_point)
    var end: Vector3 = start + camera.project_ray_normal(screen_point) * 250.0
    var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start, end)
    query.collision_mask = 1
    return get_world_3d().direct_space_state.intersect_ray(query)

func _select_click(screen_point: Vector2, additive: bool) -> void:
    var result: Dictionary = _raycast(screen_point)
    var body: Node3D = result.get("collider") as Node3D
    if body != null and selectable_units.has(body):
        _select_units([body], additive)
    elif not additive:
        _select_units([], false)

func _select_box(a: Vector2, b: Vector2, additive: bool) -> void:
    var rect: Rect2 = Rect2(Vector2(minf(a.x,b.x),minf(a.y,b.y)),
        Vector2(absf(a.x-b.x),absf(a.y-b.y)))
    var hits: Array[Node3D] = []
    for unit in selectable_units:
        if not is_instance_valid(unit) or camera.is_position_behind(unit.global_position):
            continue
        if rect.has_point(camera.unproject_position(unit.global_position + Vector3.UP * 0.7)):
            hits.append(unit)
    _select_units(hits, additive)

func _select_units(units: Array[Node3D], additive: bool) -> void:
    if not additive:
        for unit in selected_units:
            if is_instance_valid(unit) and unit is PrototypeHero:
                (unit as PrototypeHero).set_selected(false)
        selected_units.clear()
    for unit in units:
        if not selected_units.has(unit):
            selected_units.append(unit)
        if unit is PrototypeHero:
            (unit as PrototypeHero).set_selected(true)
    _refresh_hud()

func _issue_context_command(point: Vector2) -> void:
    if selected_units.is_empty():
        return
    var ray: Dictionary = _raycast_ground(point)
    if ray.is_empty():
        return
    var location: Vector3 = ray.get("position", Vector3.ZERO)
    var index: int = 0
    for unit in selected_units:
        if unit is PrototypeHero:
            var offset: Vector3 = Vector3(float(index % 3) * 1.4, 0.0, float(index / 3) * 1.4)
            (unit as PrototypeHero).issue_move(location + offset)
            index += 1

func _rts_pan_vector() -> Vector3:
    var x: float = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
    var y: float = float(Input.is_key_pressed(KEY_W)) - float(Input.is_key_pressed(KEY_S))
    var right: Vector3 = Vector3(cos(orbit_yaw), 0.0, -sin(orbit_yaw))
    var forward: Vector3 = Vector3(-sin(orbit_yaw), 0.0, -cos(orbit_yaw))
    return (right * x + forward * y).normalized()

func _process(delta: float) -> void:
    elapsed += delta
    var turn: float = float(Input.is_key_pressed(KEY_E)) - float(Input.is_key_pressed(KEY_Q))
    orbit_yaw += turn * delta * 1.1
    var control_motion: Vector3 = Vector3.ZERO
    if view_mode == OVERLORD:
        camera_focus += _rts_pan_vector() * CAMERA_PAN_SPEED * delta * (zoom_distance / 20.0)
        camera_focus.x = clampf(camera_focus.x, -60.0, 60.0)
        camera_focus.z = clampf(camera_focus.z, -60.0, 60.0)
        camera_focus.y = height_at(camera_focus.x, camera_focus.z)
    else:
        var move_x: float = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
        var move_z: float = float(Input.is_key_pressed(KEY_W)) - float(Input.is_key_pressed(KEY_S))
        var facing_forward: Vector3 = Vector3(-sin(orbit_yaw), 0.0, -cos(orbit_yaw))
        var facing_right: Vector3 = Vector3(cos(orbit_yaw), 0.0, -sin(orbit_yaw))
        control_motion = (facing_right * move_x + facing_forward * move_z).normalized()
    hero.desired_movement = control_motion
    _update_camera(delta)
    _refresh_hud()

func _refresh_hud() -> void:
    if hud == null:
        return
    var mode_name: String = ["RTS OVERLORD", "DIRECT TPP", "POSSESSION FPP"][view_mode]
    hud.text = "SCALFAGUS · %s · %s\n" % [map_name, mode_name]
    hud.text += "WASD pan/move · Q/E rotate · wheel zoom · LMB select/drag · Shift add · RMB order · F1/F2/F3 views"
    resource_hud.text = "MAN    SOLIDS: %d\nETH    SOLIDS: —" % solids
    if selected_units.is_empty():
        unit_hud.text = "NO SELECTION\nLMB: select\nRMB: move"
    elif selected_units.size() > 1:
        unit_hud.text = "%d UNITS SELECTED\nRMB: move formation" % selected_units.size()
    else:
        var unit: Node3D = selected_units[0]
        var faction: String = "MAN"
        var name_text: String = unit.name
        var hp_text: int = int(unit.get_meta("hp", 100))
        if unit is PrototypeHero:
            faction = (unit as PrototypeHero).faction_id.to_upper()
            name_text = (unit as PrototypeHero).unit_name
            hp_text = (unit as PrototypeHero).hp
        else:
            faction = str(unit.get_meta("faction", "man")).to_upper()
            name_text = str(unit.get_meta("unit_name", unit.name))
        unit_hud.text = "%s  %s\nHP: %d\nRIGHT CLICK: MOVE" % [faction, name_text, hp_text]
    reticle.visible = view_mode == FPS

func _update_camera(_delta: float) -> void:
    if camera == null or hero == null:
        return
    var view_vector: Vector3 = Vector3(sin(orbit_yaw), 0.0, cos(orbit_yaw))
    var destination: Vector3 = camera_focus if view_mode == OVERLORD else hero.global_position
    if view_mode == OVERLORD:
        # Parallel orthographic rays over real sloped mesh. Free orbit changes visual diamond angle.
        var horizontal: float = zoom_distance * cos(orbit_pitch)
        var vertical: float = zoom_distance * sin(orbit_pitch)
        camera.position = destination + view_vector * horizontal + Vector3.UP * vertical
        camera.look_at(destination + Vector3(0.0, 0.7, 0.0), Vector3.UP)
        camera.size = zoom_distance * 1.0
    elif view_mode == DIRECT:
        camera.position = destination + view_vector * 5.8 + Vector3(0.0, 4.1, 0.0)
        camera.look_at(destination + Vector3(0.0, 1.0, 0.0), Vector3.UP)
    else:
        camera.position = destination + Vector3(0.0, 1.56, 0.0)
        var gaze: Vector3 = -view_vector * cos(fps_pitch) + Vector3.UP * sin(fps_pitch)
        camera.look_at(camera.position + gaze, Vector3.UP)
