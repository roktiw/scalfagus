extends Node3D
class_name DirectionalSprite5

# One source family: five 45-degree yaw drawings (front -> right -> back).
# Three additional sectors are horizontal mirrors; gameplay NEVER mirrors.
# Atlas: five rows, columns are animation frames. Source PNG is RGBA.

const SOURCE_ROWS: Array[int] = [0, 1, 2, 3, 4, 3, 2, 1]
const MIRROR: Array[bool] = [false, false, false, false, false, true, true, true]

var actor_root: Node3D
var sprite: Sprite3D
var frame_size: Vector2i = Vector2i(32, 48)
var animation_frames: int = 1
var animation_frame: int = 0
var latest_sector: int = 0
var mirror_safe: bool = true
var mirrored_view_warning: bool = false
var source_rows: Array[int] = [0, 1, 2, 3, 4]
var has_incomplete_views: bool = false
static var validated_rows: Dictionary = {}

static func resolve_sector(degrees: float) -> Dictionary:
    var sector: int = wrapi(int(floor(degrees / 45.0 + 0.5)), 0, 8)
    return {"sector": sector, "row": SOURCE_ROWS[sector], "flip": MIRROR[sector]}

func configure(
    source: Texture2D, dimensions: Vector2i, frames: int,
    owner_node: Node3D, pixel_scale: float = 0.035,
    safe_to_mirror: bool = true
) -> void:
    actor_root = owner_node
    frame_size = dimensions
    animation_frames = maxi(1, frames)
    mirror_safe = safe_to_mirror
    if sprite == null:
        sprite = Sprite3D.new()
        sprite.name = "PixelBillboard"
        add_child(sprite)
    sprite.texture = source
    sprite.region_enabled = true
    sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
    sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
    sprite.pixel_size = pixel_scale
    sprite.offset = Vector2(0.0, float(dimensions.y) * 0.5 - 1.0)
    sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
    sprite.shaded = false
    sprite.no_depth_test = false
    sprite.double_sided = true
    sprite.fixed_size = false
    assert(source.get_width() == dimensions.x * animation_frames,
        "Atlas width must equal frame width * animation frames")
    assert(source.get_height() == dimensions.y * 5,
        "Atlas height must equal five authored directions")
    _validate_source_rows(source)
    _apply(0)

func _validate_source_rows(source: Texture2D) -> void:
    # Provisional atlases can have nominal dimensions but nearly empty views.
    # Display a substantial authored row instead of transparent speckles.
    var key: String = "%d:%d:%d" % [source.get_instance_id(), frame_size.x, frame_size.y]
    if not validated_rows.has(key):
        var image := source.get_image()
        var coverage: Array[int] = []
        for row in range(5):
            var opaque: int = 0
            for y in range(row * frame_size.y, (row + 1) * frame_size.y):
                for x in range(frame_size.x):
                    if image.get_pixel(x, y).a >= 0.5:
                        opaque += 1
            coverage.append(opaque)
        var largest: int = coverage.max()
        var fallback: int = coverage.find(largest)
        var rows: Array[int] = []
        for row in range(5):
            rows.append(fallback if coverage[row] < largest * 0.2 else row)
        validated_rows[key] = rows
    source_rows.assign(validated_rows[key])
    has_incomplete_views = source_rows != [0, 1, 2, 3, 4]

func _process(_delta: float) -> void:
    if sprite == null or actor_root == null:
        return
    var camera: Camera3D = get_viewport().get_camera_3d()
    if camera == null:
        return

    var observation: Vector3
    if camera.projection == Camera3D.PROJECTION_ORTHOGONAL:
        observation = camera.global_transform.basis.z
    else:
        observation = camera.global_position - actor_root.global_position

    observation.y = 0.0
    if observation.length_squared() < 0.00001:
        observation = camera.global_transform.basis.z
        observation.y = 0.0
    if observation.length_squared() < 0.00001:
        return
    observation = observation.normalized()

    var forward: Vector3 = -actor_root.global_transform.basis.z
    var right: Vector3 = actor_root.global_transform.basis.x
    forward.y = 0.0
    right.y = 0.0
    if forward.length_squared() < 0.00001 or right.length_squared() < 0.00001:
        return
    forward = forward.normalized()
    right = right.normalized()

    var angle: float = rad_to_deg(atan2(observation.dot(right), observation.dot(forward)))
    var mapping: Dictionary = resolve_sector(angle)
    _apply(int(mapping["sector"]))

func _apply(sector: int) -> void:
    if sprite == null:
        return
    var chosen: int = wrapi(sector, 0, 8)
    var row: int = source_rows[SOURCE_ROWS[chosen]]
    var reflected: bool = MIRROR[chosen]
    latest_sector = chosen
    mirrored_view_warning = reflected and not mirror_safe
    sprite.flip_h = reflected
    sprite.region_rect = Rect2(
        float(animation_frame * frame_size.x), float(row * frame_size.y),
        float(frame_size.x), float(frame_size.y)
    )

func replace_texture(source: Texture2D) -> void:
    if sprite == null:
        return
    assert(source.get_width() == frame_size.x * animation_frames)
    assert(source.get_height() == frame_size.y * 5)
    sprite.texture = source
    _validate_source_rows(source)
    _apply(latest_sector)

func set_animation_frame(frame: int) -> void:
    animation_frame = clampi(frame, 0, animation_frames - 1)
    _apply(latest_sector)

func is_mirroring_unsafe() -> bool:
    return mirrored_view_warning
