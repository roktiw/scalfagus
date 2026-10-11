# Scalfagus ADR-0003 — reference Godot 4 implementation, NOT engine-tested.
# Scene:
# ActorRoot3D (CharacterBody3D/StaticBody3D) -> DirectionalSprite5 (Node3D)
#                                           -> Sprite3D (child of DirectionalSprite5)
#
# Sprite3D editor configuration:
# - billboard = Y-Billboard (fixed Y), no_depth_test = false
# - texture_filter = Nearest, alpha via real RGBA PNG
# - do not use fixed_size = true
# Manifest convention: columns = animation frames; rows = 5 authored views:
# [front, front-right, right, back-right, back].
# Facing reference: actor's local -Z = forward; local +X = right.
# World Y is vertical; positive signed angle is observer toward actor's right.

extends Node3D
class_name DirectionalSprite5

@export var actor_root: Node3D
@export var viewer_camera: Camera3D
@export var atlas: Texture2D
@export var frame_size_px: Vector2i = Vector2i(24, 32)
@export_range(1, 32, 1) var animation_frames: int = 4
@export var animation_frame: int = 0

@onready var sprite: Sprite3D = $Sprite3D

var _last_row: int = -1
var _last_flip: bool = false
var _last_frame: int = -1

func _ready() -> void:
    if actor_root == null:
        actor_root = get_parent() as Node3D
    assert(actor_root != null, "DirectionalSprite5 needs an actor_root.")
    assert(atlas != null, "DirectionalSprite5 needs an atlas texture.")
    assert(frame_size_px.x > 0 and frame_size_px.y > 0)
    assert(atlas.get_width() == frame_size_px.x * animation_frames,
        "Atlas columns must equal animation_frames.")
    assert(atlas.get_height() == frame_size_px.y * 5,
        "Atlas must have five authored viewpoint rows.")
    sprite.texture = atlas
    sprite.region_enabled = true
    _update_visual()

func _process(_delta: float) -> void:
    _update_visual()

# Azimuth is a VISUAL decision. Do not alter actor yaw, physics or inventory.
func _update_visual() -> void:
    var active_camera: Camera3D = viewer_camera
    if active_camera == null:
        active_camera = get_viewport().get_camera_3d()
    if active_camera == null:
        return

    var observer_vector: Vector3
    if active_camera.projection == Camera3D.PROJECTION_ORTHOGONAL:
        # Wide RTS ortho: one parallel view direction for the whole scene.
        observer_vector = active_camera.global_transform.basis.z
    else:
        # FPS/TPP perspective: actual observer bearing for THIS entity.
        observer_vector = active_camera.global_position - actor_root.global_position

    observer_vector.y = 0.0
    if observer_vector.length_squared() < 0.000001:
        observer_vector = active_camera.global_transform.basis.z
        observer_vector.y = 0.0
    if observer_vector.length_squared() < 0.000001:
        return
    observer_vector = observer_vector.normalized()

    var forward: Vector3 = -actor_root.global_transform.basis.z
    var right: Vector3 = actor_root.global_transform.basis.x
    forward.y = 0.0
    right.y = 0.0
    if forward.length_squared() < 0.000001 or right.length_squared() < 0.000001:
        return
    forward = forward.normalized()
    right = right.normalized()

    var signed_angle_deg: float = rad_to_deg(atan2(
        observer_vector.dot(right), observer_vector.dot(forward)))
    var sector: int = wrapi(roundi(signed_angle_deg / 45.0), 0, 8)
    var authored_row: int = sector if sector <= 4 else 8 - sector
    var mirror_horizontal: bool = sector > 4
    var safe_frame: int = clampi(animation_frame, 0, animation_frames - 1)

    if authored_row == _last_row and mirror_horizontal == _last_flip and safe_frame == _last_frame:
        return

    sprite.region_rect = Rect2(
        Vector2(safe_frame * frame_size_px.x, authored_row * frame_size_px.y),
        Vector2(frame_size_px))
    sprite.flip_h = mirror_horizontal

    _last_row = authored_row
    _last_flip = mirror_horizontal
    _last_frame = safe_frame

# Important limitations / manual Godot integration:
# 1. Check bottom-center foot pivot/offset using a real scene; Sprite3D offsets
#    and alpha cut can differ by renderer and should NOT be guessed here.
# 2. A mirrored one-sided door/tool/label is artistically WRONG unless designed
#    for reflection symmetry. Collision/door coordinates never flip.
# 3. One view-pitch atlas will not invent a visible roof/underside in FPS.
# 4. Local player's own billboard may be hidden during possession; other
#    observers still see the same actor, atlas and persistent world transform.
# 5. Render per active viewport camera if split-screen/multi-viewport is added.
