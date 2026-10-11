extends CharacterBody3D
class_name PrototypeHero

# One real physics actor, independently of presentation camera and sprite view.
var desired_movement: Vector3 = Vector3.ZERO
var controlled: bool = false
var selected: bool = false
var command_target: Vector3 = Vector3.ZERO
var has_command: bool = false
var navigation_waypoints: Array[Vector3] = []
var faction_id: String = "man"
var unit_name: String = "MAN SCV"
var selection_corners: Array[MeshInstance3D] = []
var move_speed: float = 5.5
var display: DirectionalSprite5
var idle_source: Texture2D
var walk_reference_source: Texture2D
var pose_tick: float = 0.0
var showing_walk_reference: bool = false
var entity_id: String = "man.hero.prototype-001"
var hp: int = 100
var inventory: Dictionary = {"matter": 0, "volatiles": 0, "energy": 0}

func setup(atlas: Texture2D, walk_reference: Texture2D, world_position: Vector3) -> void:
    idle_source = atlas
    walk_reference_source = walk_reference
    name = "Hero"
    position = world_position
    collision_layer = 2
    collision_mask = 1 | 4

    var capsule: CapsuleShape3D = CapsuleShape3D.new()
    capsule.radius = 0.35
    capsule.height = 1.75
    var collision: CollisionShape3D = CollisionShape3D.new()
    collision.name = "HeroCollider"
    collision.shape = capsule
    collision.position = Vector3(0.0, 0.93, 0.0)
    add_child(collision)

    display = DirectionalSprite5.new()
    display.name = "Visual"
    add_child(display)
    display.configure(atlas, Vector2i(32, 48), 1, self, 0.036, false)

    var footprint: MeshInstance3D = MeshInstance3D.new()
    footprint.name = "SelectionFootprint"
    var mat: StandardMaterial3D = StandardMaterial3D.new()
    mat.albedo_color = Color(0.13, 0.67, 0.99, 0.7)
    mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    for i in range(4):
        var marker: MeshInstance3D = MeshInstance3D.new()
        marker.name = "Corner%d" % i
        var block: BoxMesh = BoxMesh.new()
        block.size = Vector3(0.20, 0.035, 0.20)
        marker.mesh = block
        marker.material_override = mat
        marker.position = Vector3((-0.52 if i % 2 == 0 else 0.52), 0.08, (-0.52 if i < 2 else 0.52))
        add_child(marker)
        selection_corners.append(marker)
    set_selected(false)

func set_selected(value: bool) -> void:
    selected = value
    for corner in selection_corners:
        corner.visible = selected

func issue_move(target: Vector3) -> void:
    # Compatibility with existing scripting tests and direct move orders.
    var one: Array[Vector3] = [target]
    issue_route(one)

func issue_route(waypoints: Array[Vector3]) -> void:
    navigation_waypoints = waypoints.duplicate()
    has_command = not navigation_waypoints.is_empty()
    if has_command:
        command_target = navigation_waypoints[0]

func cancel_order() -> void:
    navigation_waypoints.clear()
    has_command = false

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= 15.0 * delta
    else:
        velocity.y = -0.1
    var input_motion: Vector3 = desired_movement if controlled else Vector3.ZERO
    if not controlled and has_command:
        # Consume reached grid waypoints; preserve the final authored target.
        while not navigation_waypoints.is_empty():
            var delta_target: Vector3 = navigation_waypoints[0] - global_position
            delta_target.y = 0.0
            if delta_target.length_squared() > 0.40:
                input_motion = delta_target.normalized()
                command_target = navigation_waypoints[0]
                break
            navigation_waypoints.pop_front()
        if navigation_waypoints.is_empty():
            has_command = false
    velocity.x = input_motion.x * move_speed
    velocity.z = input_motion.z * move_speed
    if input_motion.length_squared() > 0.001:
        rotation.y = atan2(-input_motion.x, -input_motion.z)
    move_and_slide()
    # The original concept sheet contains two *poses*, NOT a production gait.
    # Alternate them as a diagnostic only; future actual walk animation needs authored frames.
    if input_motion.length_squared() > 0.001:
        pose_tick += delta
        if pose_tick >= 0.23:
            pose_tick = 0.0
            showing_walk_reference = not showing_walk_reference
            display.replace_texture(walk_reference_source if showing_walk_reference else idle_source)
    elif showing_walk_reference:
        showing_walk_reference = false
        pose_tick = 0.0
        display.replace_texture(idle_source)

func set_local_fps_hidden(hidden: bool) -> void:
    # In a future multiplayer renderer this flag will be per local viewport.
    display.visible = not hidden
