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

func _ready() -> void:
    _make_environment()
    _make_terrain()
    _make_test_entities()
    _make_camera_and_hud()
    _apply_mode(OVERLORD)

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
    for x in range(-25, 25):
        for z in range(-25, 25):
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
    hero = HERO_SCRIPT.new()
    hero.setup(WORKER_TEXTURE, WORKER_WALK_REFERENCE, Vector3(0.0, height_at(0.0, 0.0) + 1.2, 0.0))
    add_child(hero)
    _make_static_sprite("Lander", LANDER_TEXTURE, Vector2i(128, 128),
        Vector2(-8, -5), Vector3(5.3, 3.8, 4.8), 0.040, false)
    _make_static_sprite("TreeA", TREE_TEXTURE, Vector2i(40, 64),
        Vector2(6, -7), Vector3(0.7, 3.2, 0.7), 0.051, true)
    _make_static_sprite("TreeB", TREE_TEXTURE, Vector2i(40, 64),
        Vector2(10, 4), Vector3(0.7, 3.2, 0.7), 0.044, true)
    _make_static_sprite("RockA", ROCK_TEXTURE, Vector2i(56, 36),
        Vector2(4, 8), Vector3(2.1, 1.35, 2.0), 0.041, false)
    _make_static_sprite("RockB", ROCK_TEXTURE, Vector2i(56, 36),
        Vector2(-10, 8), Vector3(2.2, 1.35, 1.7), 0.042, false)
    _make_static_sprite("WorkerNPC", WORKER_TEXTURE, Vector2i(32, 48),
        Vector2(-5, 6), Vector3(0.8, 1.8, 0.8), 0.036, false)

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
    layer.add_child(label_background)
    hud = Label.new()
    hud.name = "Instructions"
    hud.position = Vector2(12, 7)
    hud.add_theme_font_size_override("font_size", 15)
    layer.add_child(hud)
    reticle = Label.new()
    reticle.name = "Crosshair"
    reticle.text = "+"
    reticle.add_theme_font_size_override("font_size", 28)
    reticle.set_anchors_preset(Control.PRESET_CENTER)
    reticle.position = Vector2(-8, -14)
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
                Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_RIGHT:
            dragging_orbit = event.pressed
        if event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
            zoom_distance = maxf(7.0, zoom_distance * 0.89)
        if event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            zoom_distance = minf(55.0, zoom_distance * 1.12)
    if event is InputEventMouseMotion:
        if view_mode == FPS and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            orbit_yaw -= event.relative.x * 0.003
            fps_pitch = clampf(fps_pitch - event.relative.y * 0.003, -1.1, 1.1)
        elif dragging_orbit:
            orbit_yaw -= event.relative.x * 0.006
            orbit_pitch = clampf(orbit_pitch + event.relative.y * 0.005, 0.18, 1.32)

func _process(delta: float) -> void:
    elapsed += delta
    var orbit_axis: float = Input.get_axis("ui_left", "ui_right")
    if Input.is_key_pressed(KEY_Q):
        orbit_axis -= 1.0
    if Input.is_key_pressed(KEY_E):
        orbit_axis += 1.0
    orbit_yaw += orbit_axis * delta * 1.1

    var control_motion: Vector3 = Vector3.ZERO
    if view_mode != OVERLORD:
        var move_x: float = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
        var move_z: float = float(Input.is_key_pressed(KEY_W)) - float(Input.is_key_pressed(KEY_S))
        var facing_forward: Vector3 = Vector3(-sin(orbit_yaw), 0.0, -cos(orbit_yaw))
        var facing_right: Vector3 = Vector3(cos(orbit_yaw), 0.0, -sin(orbit_yaw))
        control_motion = (facing_right * move_x + facing_forward * move_z).normalized()
    hero.desired_movement = control_motion
    _update_camera(delta)

    if hud != null:
        var mode_name: String = ["OVERLORD · RTS", "DIRECT · TPP", "POSSESSION · FPP"][view_mode]
        var lander: Node3D = get_node_or_null("Lander")
        var lander_status: String = "n/a"
        if lander != null:
            var display: DirectionalSprite5 = lander.get_node("Visual")
            lander_status = "%d%s" % [display.latest_sector, " MIRROR UNSAFE" if display.is_mirroring_unsafe() else ""]
        hud.text = "SCALFAGUS · FIVE VIEW TEST     %s\n" % mode_name
        hud.text += "F1 RTS  F2 TPP  F3 FPP  TAB next  Q/E orbit  RMB drag  Wheel zoom  WASD move  F9 resolution\n"
        hud.text += "Hero ID: %s | HP: %d | yaw sector: %d | Lander: %s | Camera zoom: %.1f" % [
            hero.entity_id, hero.hp, hero.display.latest_sector, lander_status, zoom_distance]
        reticle.visible = view_mode == FPS

func _update_camera(_delta: float) -> void:
    if camera == null or hero == null:
        return
    var view_vector: Vector3 = Vector3(sin(orbit_yaw), 0.0, cos(orbit_yaw))
    var destination: Vector3 = hero.global_position
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
